unit JigControl;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.Classes, System.SysUtils,
  CommonClass, {GMesCom,} {CodeSiteLogging,}
  DefPocb, LogicPocb, DefCam, CamComm;

type
  PGuiJigData  = ^RGuiJigData;
  RGuiJigData = packed record
    MsgType : Integer;
    Channel : Integer;
    Mode    : Integer;
    Param1  : Integer;
    Param2  : Integer;
    Param3  : Integer;
    Msg     : string;
  end;

  TJig = class(TObject)

    private
      m_hMain : HWND;
      m_hTest : HWND;
      m_nJig  : Integer;
      m_nCh   : Integer;
      m_nIdxPatContact : Integer;
      //----------------
      m_bHostLock    : boolean;
    //m_bHostAllSend : Boolean;
    //m_hHostEvnt    : HWND;
    //m_bIsHostEvent : boolean;
      m_bInitialized : Boolean;
      m_nStartSeq    : Integer;

      function CheckPgConnect : Boolean; // 한개라도 연결 안되면 False Return.
      procedure SendTestGuiDisplay(nGuiMode: Integer; nP1: Integer = 0; nP2: Integer = 0; nP3: Integer = 0; sMsg: string = '');
    public
      m_bKeyLock : boolean;
      constructor Create(nJig: Integer; hMain,hTest: HWND); virtual;
      destructor Destroy; override;
      procedure MakeCamEvent(nCam: Integer; nCamRet: enumCamRetType);
      procedure MakeCamEvent1(nCam: Integer; nCamRet: enumCamRetType);
  end;

var
  JigLogic : array[DefPocb.JIG_A .. DefPocb.JIG_MAX] of TJig;

implementation

{ TJig }
{$R+}

//==============================================================================
{$IFDEF PAS_SCRIPT}
constructor TJig.Create(nJig: Integer; hMain,hTest: HWND; AOwner: TComponent);
{$ELSE}
constructor TJig.Create(nJig: Integer; hMain,hTest: HWND);
{$ENDIF}
var
  nCh : Integer;
begin
  //
  m_hMain := hMain;
  m_hTest := hTest;
  //
  m_nJig := nJig;
  m_nCh  := nJig;
  //
  m_bKeyLock    := False;
  m_nIdxPatContact := -1;
  //
  Logic[m_nCh] := TLogic.Create(m_nCh,hMain,hTest);
  //

  //---POCB-ONLY
  m_bHostLock := False;  //TBD:GMES?
  m_bInitialized := False;
  m_nStartSeq := 0;
end;

//==============================================================================
destructor TJig.Destroy;
begin
  Logic[m_nCh].Free;
  Logic[m_nCh] := nil;
  inherited;
end;

//==============================================================================
// Private Methods
//      function CheckPgConnect : Boolean; // 한개라도 연결 안되면 False Return.
//      function CheckScript(nKeyIdx: Integer) : Boolean;
//      procedure SendTestGuiDisplay(nGuiMode: Integer; nP1: Integer = 0; nP2: Integer = 0; nP3: Integer = 0; sMsg: string = '');
//      procedure MakeCamEvent(nJigCh, nIdxErr: Integer);
//      procedure MakeCamEvent1(nJigCh, nIdxErr: Integer);
//      procedure SendHostResult(nIdx : Integer);
//      function CheckHostAck(Task : TProc; nSid, nDelay, nRetry : Integer) : DWORD;
//      procedure SetMesResult(nMsgType, nPg: Integer; bError : Boolean; sErrMsg : string);
//==============================================================================

//------------------------------------------------------------------------------
function TJig.CheckPgConnect: Boolean;
var
  bRet : boolean;
begin
  bRet := False;
  if not Logic[m_nCh].m_bUse then Exit;  //TBD:MERGE?
  if Logic[m_nCh].PgConnection then bRet := True;   //TBD:MERGE?
  Result := bRet;
end;

//==============================================================================
procedure TJig.SendTestGuiDisplay(nGuiMode, nP1, nP2, nP3: Integer; sMsg: string);
var
  ccd         : TCopyDataStruct;
  SendData    : RGuiJigData;
begin
  SendData.MsgType  := DefPocb.MSG_TYPE_JIG;
  SendData.Channel  := m_nJig;
  SendData.Mode     := nGuiMode;
  SendData.Param1   := nP1;
  SendData.Param2   := nP2;
  SendData.Param3   := nP3;
  SendData.Msg      := sMsg;
  ccd.dwData := 0;
  ccd.cbData := SizeOf(SendData);
  ccd.lpData := @SendData;
  SendMessage(m_hTest,WM_COPYDATA,0, LongInt(@ccd));
end;

//==============================================================================
procedure TJig.MakeCamEvent(nCam: Integer; nCamRet: enumCamRetType);
begin
  Logic[nCam].MakeTEndEvt(nCamRet);
end;

//==============================================================================
procedure TJig.MakeCamEvent1(nCam: Integer; nCamRet: enumCamRetType);
begin
  Logic[nCam].MakeTEndEvt(nCamRet);
end;

end.
