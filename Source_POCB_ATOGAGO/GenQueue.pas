{*
--------------------------------------------------------------------------------
Copyrightⓒ 1999-2004 DONG A ELTEK CO.,LTD All rights reserved.
--------------------------------------------------------------------------------
$Id: GenQueue.pas,v 1.2 2006/03/17 03:03:17 dhjeong Exp $
$Author: dhjeong $
$Log: GenQueue.pas,v $
Revision 1.2  2006/03/17 03:03:17  dhjeong
RCB DR400 교체 작업으로 프로토콜 변경

Revision 1.1  2006/02/23 07:46:33  dhjeong
LPL파주 시험반 DL424 Aging (40CH/94CH/152/288CH)

Revision 1.0  2004-03-22 11:36:48+09  kudosj
Initial revision

--------------------------------------------------------------------------------
*}
unit GenQueue;

interface

uses Windows, SysUtils;

const MAX_QUEUE_SIZE = 100000; // Maximum possible size of queue (nr. of items);
                              // however actual instantiated size is determined
															// in run-time by a parameter to the constructor.

// ERROR CODES RETURNED BY ADDITEM AND READITEM FUNCTIONS:
const BUFF_NO_ERROR            =  0; // Function succeeded
			BUFF_ERR_INVALID_POINTER = -1; // A NULL pointer was received or retrieved
      BUFF_ERR_CLOSING         = -2; // Closedown event aborted block for Add/Read
			BUFF_ERR_WRITE_TIMEOUT   = -4; // Timeout on block in AddItem
      BUFF_ERR_READ_TIMEOUT    = -5; // Timeout on block in ReadItem
			BUFF_ERR_UNSAFE_WRITE    = -6; // Unknown return code from WaitForMultipleObjects/write
			BUFF_ERR_UNSAFE_READ     = -7; // Unknown return code from WaitForMultipleObjects/read
      BUFF_ERR_WRITE_FULL      = -8; // Buffer turned out to be full when written to
			BUFF_ERR_READ_EMPTY      = -9; // Buffer turned out to be empty when read


type

TQueuedItem = record
  pData: pointer;  // this is the "user data" pointer, created/freed externally
  dataLength: integer; // this is the size (bytes) of data block in pData (optional usage)
end;

TQueueArray = array[0..MAX_QUEUE_SIZE] of TQueuedItem;
pQueueArray = ^TQueueArray;


type TGeneralQueue = class
private
  // Private fields:
  ReadWriteCS: TRTLCriticalSection;   // Protective Critical Section object
  pCanWrite,pCanRead: PWOHandleArray; // Event object arrays;
  WriteCount,ReadCount: integer;      // "Semaphores" for counting blocked threads
  WritePointer,ReadPointer: integer;  // Slot in pQueue[] to write to/read from next
  queuedItems: LongInt;               // Current number of items in queue
  maxItems: LongInt;                  // Max items in queue (determined in Create)
  pQueue: pQueueArray;  // It`s a pointer to a variable-size array of TQueuedItem
  // Private functions/procs:
  function internalWriteItem(pData:pointer; dataLength:integer): LongInt;
  function internalReadItem(var pData: pointer; var dataLength: integer): LongInt;
  procedure internalFlush;
public
  // Here is the public interface:
  constructor Create(maxItemsInQueue: LongInt);
  destructor  Destroy; override;
  function WriteItem(pData:pointer; dataLength:integer; TimeOut: dword): LongInt;
  function ReadItem(var pData: pointer; var dataLength: integer; TimeOut: dword): LongInt;
  procedure Flush;
  procedure UnBlockAccess; // to be called only once at end of usage
  function ItemsInQueue: LongInt;
  function Full: boolean;
  function Empty: boolean;
end; // class TGeneralQueue declaration


implementation

//******************************************************************************
// Function Name:    TGeneralQueue.Create
// Input Parameters: maxItemsInQueue: Queue Capacity; must be >0
// Return Value:     None.
// Side Effects:     ..
// Conditions:       None.
// Description:      - Creates Queue object
//                   - Creates internal Critical section object ReadWriteCS
//                   - Initializes internal fields
//                   - Creates internal control events
//                   - Allocates memory for the pQueue pointer according to the
//                     specified maximum number of items in the queue.
// Notes:            None.
//******************************************************************************
constructor TGeneralQueue.Create(maxItemsInQueue: LongInt);
begin
  // Create critical section object:
  InitializeCriticalSection(ReadWriteCS);
  // Initializing internal variables:
  Writepointer:=0;
  Readpointer:=0;
  queuedItems:=0;
  WriteCount:=0;
  ReadCount:=0;
  maxItems:=maxItemsInQueue;
  // Creating Events:
  pCanRead:=AllocMem(2*sizeof(THandle));
  pCanRead[0]:=CreateEvent(nil,False,False,nil); // This is the "not Empty" event; Auto-Reset
  pCanRead[1]:=CreateEvent(nil,True,False,nil); // This is "Queue Invalidated" event; it`s Manual-Reset
  pCanWrite:=AllocMem(2*sizeof(THandle));
  pCanWrite[0]:=CreateEvent(nil,False,False,nil); // Auto-Reset; signaled by default
  pCanWrite[1]:=CreateEvent(nil,True,False,nil); // This is "Queue Invalidated" event; Manual-reset
  // Allocating Queue array:
  pQueue:=AllocMem(maxItems*sizeof(TQueuedItem)); // determines actual size of queue!
end; // constructor Create

//******************************************************************************
// Function Name:    TGeneralQueue.Destroy
// Input Parameters: None.
// Return Value:     None.
// Side Effects:     Flushes queue
// Conditions:       None.
// Description:      Flushes the Queue object, deletes the Critical section
//                   object, Closes the Event handles, frees the pQueue pointer
//                   and destroys the Queue object.
// Notes:            If the read/write threads have not already been killed,
//                   this destructor should be preceded by a call to the proc
//                   UnBlockAccess so that all threads are released from the
//                   wait functions; otherwise they access an invalid object
//                   when or if they do come out of the wait function.
//******************************************************************************
destructor TGeneralQueue.Destroy;
begin
  EnterCriticalSection(ReadWriteCS);
  try
    Flush; // must be public Flush not intFlush, otherwise get AV... don`t know why!
    CloseHandle(pCanRead[0]);
    CloseHandle(pCanRead[1]); // also closes pCanWrite[1]
    CloseHandle(pCanWrite[0]);
    CloseHandle(pCanWrite[1]);
    FreeMem(pCanRead);
    FreeMem(pCanWrite);
    FreeMem(pQueue);
  finally
    LeaveCriticalSection(ReadWriteCS);
  end;
  DeleteCriticalSection(ReadWriteCS);
  inherited; // destroy object... don`t know if this call does anything at all
end; // destructor Destroy

//******************************************************************************
// Function Name:    TGeneralQueue.UnBlockAccess
// Input Parameters: None.
// Return Value:     None.
// Side Effects:     Any waiting threads in the WaitForMultipleObjects functions
//                   in ReadItem and WriteItem are released and exit the queue.
// Conditions:       None.
// Description:      Sets the "Queue Termination" events, which are detected in
//                   the WaitForMultipleObjects functions in WriteItem/ReadItem.
//                   Then enters a loop which exits only when all Read threads
//                   and Write threads have been released from the wait function
// Notes:            None.
//******************************************************************************
procedure TGeneralQueue.UnBlockAccess;
var ReadThreadsHanging,WriteThreadsHanging: boolean;
begin
  WriteThreadsHanging:=True;
  ReadThreadsHanging:=True;
  SetEvent(pCanWrite[1]);
  SetEvent(pCanRead[1]);
  Sleep(10);
  while WriteThreadsHanging do
    begin
      EnterCriticalSection(ReadWriteCS); // avoid AV with Write threads
      WriteThreadsHanging:=(WriteCount>0);
      LeaveCriticalSection(ReadWriteCS);
      Sleep(10);
    end;
  while ReadThreadsHanging do
    begin
      EnterCriticalSection(ReadWriteCS); // avoid AV with Read threads
      ReadThreadsHanging:=(ReadCount>0);
      LeaveCriticalSection(ReadWriteCS);
      Sleep(10);
    end;
end; // proc UnBlockAccess

//******************************************************************************
// Function Name:    TGeneralQueue.Flush
// Input Parameters: None.
// Return Value:     None.
// Side Effects:     None.
// Conditions:       None.
// Description:      Public thread-safe interface to internalFlush
// Notes:            None.
//******************************************************************************
procedure TGeneralQueue.Flush;
begin
  EnterCriticalSection(ReadWriteCS);
  try
    internalFlush;
  finally
    LeaveCriticalSection(ReadWriteCS);
  end;
end; // proc Flush


//******************************************************************************
// Function Name:    TGeneralQueue.internalFlush
// Input Parameters: None.
// Return Value:     None.
// Side Effects:     None.
// Conditions:       None.
// Description:      Flushes the Queue
// Notes:            None.
//******************************************************************************
procedure TGeneralQueue.internalFlush;
var pData: pointer;
    dLength,tmp: integer;
begin
  while (queuedItems<>0) do
    begin
      tmp:=internalReadItem(pData,dLength);
      FreeMem(pData);
      pData:=nil;
    end;
end; // proc internalFlush

//******************************************************************************
// Function Name:    TGeneralQueue.WriteItem
// Input Parameters: pData:pointer
//                   dataLength: number of bytes allocated to pData
//                   TimeOut: Length of time (ms) to block if queue is full.
//                     0: No blocking => caller is responsible for full check
//                     1-$FFFFFFFE: Timeout period for blocking
//                     INFINITE: Infinite blocking: Guarantees valid return
// Return value:     QUEUE_ERR_X error code.
// Side Effects:     None.
// Conditions:       None.
// Description:      Adds a pointer to the tail of the Queue.
//                   WAITS for SlotFreeForWrite event if buffer is initially
//                   empty, so that calling thread sleeps (blocking call).
// Notes:            Public interface to coordinateAddItem->internalAddItem
//******************************************************************************
function TGeneralQueue.WriteItem(pData:pointer; dataLength:integer; TimeOut: dword): LongInt;
var WaitResult,tmp: LongInt;
begin
  tmp:=BUFF_NO_ERROR;
  try
    EnterCriticalSection(ReadWriteCS);
    while ((queuedItems>=maxItems) and (TimeOut<>0)) do // buffer full, wait for notFull event
    begin
      Inc(WriteCount);
      LeaveCriticalSection(ReadWriteCS);

      tmp:=BUFF_ERR_UNSAFE_WRITE;           // unknown reason for releasing!
      WaitResult:=WaitForMultipleObjects(2, // number of event objects in pCanWrite
                                         pCanWrite,// event objects to wait for
                                         False,    // either one will release a single thread
                                         TimeOut); // timeout to wait for objects
      EnterCriticalSection(ReadWriteCS);
      Dec(WriteCount);

      case WaitResult of
        WAIT_OBJECT_0:     tmp:=BUFF_NO_ERROR;
        WAIT_OBJECT_0+1:   begin
                             tmp:=BUFF_ERR_CLOSING; // the UnBlockThreads() method was called
                             break;                 // force exit of while loop
                           end;
        WAIT_TIMEOUT:      begin
                             tmp:=BUFF_ERR_WRITE_TIMEOUT; // timeout expired;
                             break;                 // force exit of while loop
                           end;
        else               break;                   // force exit of while loop
      end; // case WaitResult

    end; // if (do wait)
    if (tmp=BUFF_NO_ERROR) then
      tmp:=internalWriteItem(pData,dataLength);
  finally
    LeaveCriticalSection(ReadWriteCS);
    Result:=tmp;
  end;
end; // function WriteItem



//******************************************************************************
// Function Name:    TGeneralQueue.internalWriteItem
// Input Parameters: pData:pointer
//                   dataLength: number of bytes allocated to pData
// Side Effects:     None.
// Conditions:       None.
// Description:      Adds a pointer to the tail of the Queue.
// Notes:            The object that takes the pointer from the Queue will be
//                   responsible for freeing the memory associated with the
//                   object that the pointer points to!
//                   The calling object is also responsible for assuring that the
//                   Queue isn`t full! (Use TQueue.Full)
//******************************************************************************
function TGeneralQueue.internalWriteItem(pData:pointer; dataLength:integer): LongInt;
var tmp: LongInt;
begin
  tmp:=BUFF_NO_ERROR;
  try
    if (queuedItems>=maxItems) then tmp:=BUFF_ERR_WRITE_FULL
    else if (pData=nil) then tmp:=BUFF_ERR_INVALID_POINTER
    else
      begin
        Inc(WritePointer);
        if (WritePointer=maxItems) then WritePointer:=0; // writepointer range = 0..maxItems-1
        pQueue[WritePointer].pData:=pData;
        pQueue[WritePointer].dataLength:=dataLength;
        Inc(queuedItems);
        ResetEvent(pCanWrite[0]);
        if (queuedItems>0) then SetEvent(pCanRead[0]); // signals that ONE Read thread can be released from wait
      end;
  finally
    Result:=tmp;
  end; // try-finally
end; // function internalWriteItem


//******************************************************************************
// Function Name:    TGeneralQueue.ReadItem
// Input Parameters: TimeOut: User-specified timeout for blocking function:
//                      0: No blocking, proceed directly to coordinateReadItem
//                      1..(INFINITE-1): Timeout interval in ms to block
//                      INFINITE ($FFFFFFFF): Indefinite blocking
//                      Blocking occurs if queue is empty at the time of call.
// Return Value:     dataLength: number of bytes allocated to pointer
//                   pointer
// Side Effects:     None.
// Conditions:       None.
// Description:      Removes a pointer from the head of the Queue.
//                   WAITS for ItemAvailableForRead event if queue is initially
//                   empty, so that calling thread sleeps (blocking call).
// Notes:            Public interface for reading from the queue.
//******************************************************************************
function TGeneralQueue.ReadItem(var pData:pointer; var dataLength:integer; TimeOut:dword): LongInt;
var WaitResult,tmp: LongInt;
begin
  tmp:=BUFF_NO_ERROR;
  try
    EnterCriticalSection(ReadWriteCS);
    while ((queuedItems=0) and (TimeOut<>0)) do  // buffer empty, wait for notEmpty event
    begin
      Inc(ReadCount);
      LeaveCriticalSection(ReadWriteCS);

      tmp:=BUFF_ERR_UNSAFE_READ;           // unknown reason for releasing!
      WaitResult:=WaitForMultipleObjects(2, // number of event objects in pCanWrite
                                         pCanRead, // event objects to wait for
                                         False, // either one will release a single thread
                                         TimeOut); // timeout to wait for objects
      EnterCriticalSection(ReadWriteCS);

      Dec(ReadCount);
      case WaitResult of
        WAIT_OBJECT_0:     tmp:=BUFF_NO_ERROR;    // go back to top of loop to check if buffer is empty
        WAIT_OBJECT_0+1:   begin
                             tmp:=BUFF_ERR_CLOSING; // the UnBlockThreads() method was called
                             break;                 // force exit from while loop
                           end;
        WAIT_TIMEOUT:      begin
                             tmp:=BUFF_ERR_READ_TIMEOUT; // timeout expired;
                             break;                 // force exit from while loop
                           end;
        else               break;                 // force exit from while loop
      end; // case WaitResult
    end; // if (do wait)
    if (tmp=BUFF_NO_ERROR) then
      tmp:=internalReadItem(pData,dataLength);
  finally
    LeaveCriticalSection(ReadWriteCS);
    Result:=tmp;
  end;
end; // function ReadItem


//******************************************************************************
// Function Name:    TGeneralQueue.internalReadItem
// Input Parameters: None.
// Output Params:    pData: Allocated queued pointer
//                   dataLength: number of bytes allocated to pointer;
// Return Value:     BUFF_ERR_X Result code
// Side Effects:     None.
// Conditions:       None.
// Description:      Removes a pointer from the head of the queue.
// Notes:            The receiver of the pointer is responsible for freeing the
//                   memory associated with the object that the pointer points to!
//                   The calling object is also responsible for assuring that the
//                   queue isn`t empty!
//******************************************************************************
function TGeneralQueue.internalReadItem(var pData: pointer; var dataLength: integer): LongInt;
var tmp: LongInt;
begin
  tmp:=BUFF_NO_ERROR;
  try
    if (queuedItems=0) then tmp:=BUFF_ERR_READ_EMPTY
    else
      begin
        Inc(ReadPointer);
        if (ReadPointer=maxItems) then ReadPointer:=0;
        dataLength:=pQueue[ReadPointer].dataLength;
        pData:=pQueue[ReadPointer].pData;
        if (pData=nil) then tmp:=BUFF_ERR_INVALID_POINTER; // should do something more here!
        Dec(queuedItems);
        //if (queuedItems<maxItems) then
          SetEvent(pCanWrite[0]); // signals that ONE Write thread can be released from wait
        if (queuedItems=0) then ResetEvent(pCanRead[0]); // signals that ONE Read thread can be released from wait
      end;
  finally
    Result:=tmp;
  end; // try-finally
end; // function internalReadItem


//******************************************************************************
// Function Name:    TGeneralQueue.ItemsInQueue
// Input Parameters: None.
// Return Value:     LongInt
// Side Effects:     None.
// Conditions:       None.
// Description:      Returns the number of items that are currently in the Queue.
// Notes:            None.
//******************************************************************************
function TGeneralQueue.ItemsInQueue: LongInt;
begin
  EnterCriticalSection(ReadWriteCS);
  try
    Result:=queuedItems;
  finally
    LeaveCriticalSection(ReadWriteCS);
  end;
end;

//******************************************************************************
// Function Name:    TGeneralQueue.Full
// Input Parameters: None.
// Return Value:     TRUE if the Queue is full, FALSE otherwise
// Side Effects:     None.
// Conditions:       None.
// Description:      Checks if the Queue is full
// Notes:            None.
//******************************************************************************
function TGeneralQueue.Full: boolean;
begin
  EnterCriticalSection(ReadWriteCS);
  try
    Result:=(queuedItems>=maxItems);
  finally
    LeaveCriticalSection(ReadWriteCS);
  end;
end;

//******************************************************************************
// Function Name:    TGeneralQueue.Empty
// Input Parameters: None.
// Return Value:     TRUE if queue is empty, FALSE otherwise
// Side Effects:     None.
// Conditions:       None.
// Description:      Checks if the Queue is empty
// Notes:            None.
//******************************************************************************
function TGeneralQueue.Empty: boolean;
begin
  EnterCriticalSection(ReadWriteCS);
  try
    Result:=(queuedItems=0);
  finally
    LeaveCriticalSection(ReadWriteCS);
  end;
end;

end.

//******************************************************************************
//*                        End of File GenQueue.pas                            *
//******************************************************************************
