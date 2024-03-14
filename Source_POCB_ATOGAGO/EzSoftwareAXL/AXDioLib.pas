unit AXDioLib;

interface

uses
	System.Classes, System.SysUtils, Winapi.Windows, Winapi.Messages, 
	Vcl.Dialogs, Vcl.ExtCtrls, 
{$IFDEF DEBUG}
  CodeSiteLogging,
{$ENDIF}
{$IFDEF USE_AXL_DIO}
  AXL, AXD, AXHS,
{$ENDIF}
	DefCommon, CommonClass, DefDio;

type
  AxIoStatus 			= array[0..pred(DefDio.MAX_IO_CNT)] of boolean;
  AxDioEvent 			= procedure(bIn: Boolean; IoDio: AxIoStatus; sErrMsg: string) of object;
  AxControlEvent 	= procedure(nErrCode: Integer; sErrMsg: string) of object;

  PGuiAxDio = ^RGuiAxDio;
  RGuiAxDio = packed record
    MsgType : Integer;
    Channel : Integer;
    Mode    : Integer;
    nParam  : Integer;
    Msg     : string;
  end;

  TAxDio = class(TObject)
  private
		//	
    m_hMain     				: THandle;
    m_bThreadStop 			: Boolean;
    m_sPrevDioMsg 			: string;
    m_bLock1, m_bLock2 	: Boolean;
    m_dwDataHigh, m_dwDataHigh2         : DWORD;
    m_dwPreWriteDio, m_dwPreWriteDio2   : DWORD;
    m_dwWriteDio, m_dwWriteDio2         : DWORD;
    tmCheckDio  				: TTimer;
		//	
    FisConneced 				: boolean;
    FIsMaintOn					: Boolean;
    FInDioStatus				: AxDioEvent;
    FMaintInDioStatus		: AxDioEvent;
    FDoneAutoControl1		: AxControlEvent;
    FDoneAutoControl2		: AxControlEvent;
    procedure SetIsMaintOn(const Value: Boolean);
    procedure SetInDioStatus(const Value: AxDioEvent);
    procedure SetMaintInDioStatus(const Value: AxDioEvent);
    procedure SetDoneAutoControl1(const Value: AxControlEvent);
    procedure SetDoneAutoControl2(const Value: AxControlEvent);
		//
    function OpenDevice(var nModuleCnt: LongInt; var sErrMsg: string; var sModuleInfo: string) : DWORD;
    procedure CheckThreadDio;
    procedure ControlOuput64;
    procedure OntmCheckDioTimer(Sender: TObject);
    procedure SendMainGuiDisplay(nGuiMode: Integer; nP1: Integer = 0; sMsg: string = '');
  public
		//NEW---
		//OLD---
    m_bInDio, m_bOutDio : AxIoStatus;
    m_bEmsOn            : Boolean;
 	  m_bProbeFrontStop 	: array[0..1] of  Boolean;	//TBD? REF_OPTIC_ONLY?
		//
    constructor Create(hMain :HWND; nType: Integer; nScanTime: Integer; nOption: Integer = 0); virtual;
    destructor Destroy; override;
    function SetDio64(dnSig: DWORD; bOff: Boolean = False) : DWORD; // For Normal or Maint window
    function WriteDio(dwSig: DWORD; nVal: Integer) : DWORD; 				// 
{$IFDEF REF_OPTIC}
    procedure GetDioStatus;
    function SetDio(dwSig: DWORD; bAllSet: Boolean = False) : DWORD;
    procedure SetAutoControl(nStage: Integer; bFront: Boolean);
    procedure SetAutoManualCtrl(nStage: Integer; bDown: Boolean);
{$ENDIF}
		//
    property IsConnected : Boolean read FisConneced;
    property IsMaintOn : Boolean read FIsMaintOn write SetIsMaintOn;
    property InDioStatus : AxDioEvent read FInDioStatus write SetInDioStatus;
    property MaintInDioStatus : AxDioEvent read FMaintInDioStatus write SetMaintInDioStatus;
    property DoneAutoControl1 : AxControlEvent read FDoneAutoControl1 write SetDoneAutoControl1;
    property DoneAutoControl2 : AxControlEvent read FDoneAutoControl2 write SetDoneAutoControl2;

  end;
var
  AxDio   : TAxDio;
implementation

{ TAxDio }

//******************************************************************************
// procedure/function: Creat/Destroy
//    - constructor TAxDio.Create(hMain: HWND; nType: Integer; nScanTime: Integer; nOption: Integer = 0);
//    - destructor TAxDio.Destroy;
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] constructor TAxDio.Create(hMain: HWND; nType: Integer; nScanTime: Integer; nOption: Integer = 0)
//    Called-by: procedure TfrmMain.tmrDisplayTestFormTimer(Sender: TObject)
//
constructor TAxDio.Create(hMain: HWND; nType: Integer; nScanTime: Integer; nOption: Integer = 0);
var
  dwRet, dwUse, dwModuleID, dwDataHigh : DWORD;
  lBoardNo, lModulePos     : LongInt;
  sErrMsg, sModuleInfo : string;
  lModuleCnt : LongInt;
  i : Integer;
  thDio : TThread;
{$IFDEF DEBUG}
  sDebug : string;
{$ENDIF}
begin
	//
  m_hMain 			:= hMain;
  m_bLock1 			:= False;
  m_bLock2 			:= False;
  m_dwDataHigh  := $ffff;
  m_dwDataHigh2 := $ffff;
  sErrMsg       := '';
  lModuleCnt    := 0;
  sModuleInfo   := '';
  m_sPrevDioMsg := '';
  FisConneced   := False;
  m_dwWriteDio  := 0;
  m_dwPreWriteDio := 0;
  m_dwWriteDio2  := 0;
  m_dwPreWriteDio2 := 0;
  m_bThreadStop  := False;
  m_bEmsOn       := False;
  m_bProbeFrontStop[0] := False;
  m_bProbeFrontStop[1] := False;
	//
  try
    dwRet := OpenDevice(lModuleCnt,sErrMsg, sModuleInfo);
    m_sPrevDioMsg := sErrMsg;
{$IFDEF DEBUG}
    sDebug := format('lModuleCnt(%d),sErrMsg(%s),sModuleInfo(%s)',[lModuleCnt,sErrMsg,sModuleInfo]);
    CodeSite.Send(sDebug);
{$ENDIF}
//  ShowMessage(sDebug);
    if dwRet = AXT_RT_SUCCESS then begin
			// DONGA_16X16_CH ----------------
      if (lModuleCnt in [0,1]) and (nType = DefDio.DONGA_16X16_CH) then begin
        AxdInfoGetModule(0, @lBoardNo, @lModulePos, @dwModuleID);
{$IFDEF DEBUG}
    		sDebug := format('lBoardNo(%d),lModulePos(%d),dwModuleID(%d)',[lBoardNo,lModulePos,dwModuleID]);
    		CodeSite.Send(sDebug);
{$ENDIF}
//			ShowMessage(sDebug);
        if (dwModuleID in [AXT_SIO_DB32T, AXT_SIO_DB32P]) then begin
          AxdiInterruptGetModuleEnable(0, @dwUse);
          AxdiInterruptEdgeGetWord(0, 0, UP_EDGE, @dwDataHigh);
//        sDebug := format('dwUse(%d),dwDataHigh(%d)',[dwUse,dwDataHigh]);
//        ShowMessage(sDebug);
//        m_dwModuleID := dwModuleID;
          for i := 0 to Pred(DefDio.MAX_IN_CNT) do begin
            m_bInDio[i] := False;
          end;
          for i := 0 to Pred(DefDio.MAX_OUT_CNT) do begin
            m_bOutDio[i] := False;
          end;
          // Timer
          tmCheckDio := TTimer.Create(nil);
          tmCheckDio.Enabled  := False;
          tmCheckDio.Interval := nScanTime;
          tmCheckDio.OnTimer  := OntmCheckDioTimer;
          tmCheckDio.Enabled  := True;
          FisConneced         := True;
        end
        else begin
          // 오류 처리
        end;
      end
			// DONGA_32X32_CH: PCI_DB64R x 1ea ----------------
			else if (lModuleCnt in [0,1]) and (nType = DefDio.DONGA_32X32_CH) then begin
        AxdInfoGetModule(0, @lBoardNo, @lModulePos, @dwModuleID);
{$IFDEF DEBUG}
    		sDebug := format('lBoardNo(%d),lModulePos(%d),dwModuleID(%d)',[lBoardNo,lModulePos,dwModuleID]);
    		CodeSite.Send(sDebug);
{$ENDIF}
//			ShowMessage(sDebug);
        if (dwModuleID in [AXT_PCI_DB64R, AXT_PCIE_DB64R]) then begin		//TBD?
          AxdiInterruptGetModuleEnable(0, @dwUse);
          AxdiInterruptEdgeGetWord(0, 0, UP_EDGE, @dwDataHigh);
//        sDebug := format('dwUse(%d),dwDataHigh(%d)',[dwUse,dwDataHigh]);
//        ShowMessage(sDebug);
//        m_dwModuleID := dwModuleID;
          for i := 0 to Pred(DefDio.MAX_IN_CNT) do begin
            m_bInDio[i] := False;
          end;
          for i := 0 to Pred(DefDio.MAX_OUT_CNT) do begin
            m_bOutDio[i] := False;
          end;
          // Timer
        	thDio := TThread.CreateAnonymousThread(CheckThreadDio);	//TBD???
        	thDio.FreeOnTerminate := True;
        	thDio.Priority := tpHighest;
        	thDio.Start;
//				tmCheckDio := TTimer.Create(nil);
//				tmCheckDio.Enabled  := False;
//				tmCheckDio.Interval := nScanTime;
//				tmCheckDio.OnTimer  := OntmCheckDioTimer;
//				tmCheckDio.Enabled  := True;
					//
          FisConneced         := True;
        end
        else begin
{$IFDEF DEBUG}
    			sDebug := format('dwModuleID(%d) is NOT in [AXT_PCI_DB64R(%d), AXT_PCIE_DB64R(%d)]',[dwModuleID,AXT_PCI_DB64R,AXT_PCIE_DB64R]);
    			CodeSite.Send(sDebug);
{$ENDIF}
//				ShowMessage(sDebug);
          //TBD? 오류 처리
        end;
      end
			// DONGA_60X60_CH: PCI_DB64R x 2ea ----------------
      else if (lModuleCnt = 4) and (nType = DefDio.DONGA_60X60_CH) then begin
        for i := 0 to Pred(DefDio.MAX_IN_CNT) do begin
          m_bInDio[i] := False;
        end;
        for i := 0 to Pred(DefDio.MAX_OUT_CNT) do begin
          m_bOutDio[i] := False;
        end;
        for i := 0 to Pred(lModuleCnt) do begin
          AxdInfoGetModule(i, @lBoardNo, @lModulePos, @dwModuleID);
{$IFDEF DEBUG}
          sDebug := format('lBoardNo(%d),lModulePos(%d),dwModuleID(%d)',[lBoardNo,lModulePos,dwModuleID]);
          CodeSite.Send(sDebug);
{$ENDIF}
          AxdiInterruptGetModuleEnable(i, @dwUse);
        end;
        thDio := TThread.CreateAnonymousThread(CheckThreadDio);
        thDio.FreeOnTerminate := True;
        thDio.Priority := tpHighest;
        thDio.Start;
        // Read.
//      tmCheckDio := TTimer.Create(nil);
//      tmCheckDio.Enabled  := False;
//      tmCheckDio.Interval := nScanTime;
//      tmCheckDio.OnTimer  := OnTmCheckDioTimer64;
//      tmCheckDio.Enabled  := True;
        FisConneced         := True;
      end
			// 
      else begin
        // TBD
      end;
    end;
//
  except

  end;
end;

destructor TAxDio.Destroy;
begin
  if tmCheckDio <> nil then begin
    tmCheckDio.Free;
    tmCheckDio := nil;
  end;
  m_bThreadStop := True;
  Sleep(100);
  AxlClose;
  inherited;
end;

//******************************************************************************
// procedure/function:
//		- procedure TAxDio.SetIsMaintOn(const Value: Boolean);
//		- procedure TAxDio.SetInDioStatus(const Value: AxDioEvent);
//		- procedure TAxDio.SetMaintInDioStatus(const Value: AxDioEvent);
//		- procedure TAxDio.SetDoneAutoControl1(const Value: AxControlEvent);
//		- procedure TAxDio.SetDoneAutoControl2(const Value: AxControlEvent);
//		- //TBD? procedure TAxDio.GetDioStatus;  //NO-USE-FOR_A2CH?
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.SetIsMaintOn(const Value: Boolean)
//    Called-by: procedure TfrmMainter.FormCreate(Sender: TObject)
//    Called-by: procedure TfrmMainter.FormCloseQuery(Sender: TObject; var CanClose: Boolean)
//    Called-by: procedure TfrmMainter.RzPageControl1Click(Sender: TObject)
//
procedure TAxDio.SetIsMaintOn(const Value: Boolean);
begin
  FIsMaintOn := Value;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.SetInDioStatus(const Value: AxDioEvent)
//    Called-by: procedure TfrmMainter.FormCreate(Sender: TObject)
//    Called-by: procedure TfrmMain.tmrDisplayTestFormTimer(Sender: TObject)
//
procedure TAxDio.SetInDioStatus(const Value: AxDioEvent);
begin
  FInDioStatus := Value;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.SetMaintInDioStatus(const Value: AxDioEvent)
//    Called-by: procedure TfrmMainter.FormCreate(Sender: TObject)
//
procedure TAxDio.SetMaintInDioStatus(const Value: AxDioEvent);
begin
  FMaintInDioStatus := Value;
  //2018-07-31 JHHWANG DEL:   if not IsMaintOn then Exit;
//MaintInDioStatus(m_bInDio,m_bOutDio,'');
  MaintInDioStatus(True,m_bInDio,'');
  MaintInDioStatus(False,m_bOutDio,'');
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.SetDoneAutoControl1(const Value: AxControlEvent)	//TBD? REF_OPTIC?
// [PROC/FUNC] TAxDio.SetDoneAutoControl2(const Value: AxControlEvent)	//TBD? REF_OPTIC?
//		Called-by: procedure TAxDio.SetAutoControl(nStage: Integer; bFront : Boolean)	//TBD? REF_OPTIC?
//		Called-by: procedure TAxDio.SetAutoManualCtrl(nStage: Integer; bFront : Boolean)	//TBD? REF_OPTIC?
//    Called-by: procedure TfrmTest4ChGB.SetProbeAutoControl 	//TBD? REF_OPTIC?
//
procedure TAxDio.SetDoneAutoControl1(const Value: AxControlEvent);
begin
  FDoneAutoControl1 := Value;
end;

procedure TAxDio.SetDoneAutoControl2(const Value: AxControlEvent);
begin
  FDoneAutoControl2 := Value;
end;

{$IFDEF REF_OPTIC}
//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.GetDioStatus	//TBD? REF_OPTIC_ONLY?
//    Called-by:procedure TfrmDioSignal.FormShow(Sender: TObject)
//
procedure TAxDio.GetDioStatus;	//TBD? REF_OPTIC_ONLY?
begin
//if Assigned(InDioStatus) then InDioStatus(True,m_bInDio,'');
  InDioStatus(True,m_bInDio,m_sPrevDioMsg);
  InDioStatus(False,m_bOutDio,m_sPrevDioMsg);
  if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(True,m_bInDio,m_sPrevDioMsg);
end;
{$ENDIF}

//******************************************************************************
// procedure/function:
//		- function TAxDio.OpenDevice(var nModuleCnt : LongInt; var sErrMsg : string; var sModuleInfo : string) : DWORD;
//		- procedure TAxDio.CheckThreadDio;
//		- procedure TAxDio.ControlOuput64;
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.OpenDevice(var nModuleCnt : LongInt; var sErrMsg : string; var sModuleInfo : string) : DWORD
//    Called-by: constructor TAxDio.Create(hMain: HWND; nType: Integer; nScanTime: Integer; nOption: Integer = 0)
//
function TAxDio.OpenDevice(var nModuleCnt : LongInt; var sErrMsg : string; var sModuleInfo : string) : DWORD;
var
  dwStatus, dwModuleID, dwRet : DWORD;
  lModuleCount, lBoardNo, lModulePos : LongInt;
  i : SmallInt;
  strData, sDebug : String;
begin
	//++
	// Library initialize.
// VH 818 L2, 점등 검사기는 모두 SIO - DB 32 Model 사용.   아진텍사.
// SIO - DB 32 Model - 디지털 입출력 모듈 디지털 입력(16) / 출력(16)
// VH E5 광보 : PCI-DO64R, PCI-DI64R 사용.
  // AxlOpen(7)   ==> PCI의 경우 AXL Open Parameter값 무시. 임의값 7(예제에 나와 있음.)
  dwRet := AxlOpen(7);
  sModuleInfo := '';
  nModuleCnt  := 0;
  sErrMsg     := '';
{$IFDEF DEBUG}
    sDebug := format('OpenDevice : dwRet(%d),sErrMsg(%s),sModuleInfo(%s)',[dwRet,sErrMsg,sModuleInfo]);
    CodeSite.Send(sDebug);
{$ENDIF}
 	if (dwRet = AXT_RT_SUCCESS) then begin
    dwRet := AxdInfoIsDIOModule(@dwStatus);
{$IFDEF DEBUG}
    sDebug := format('AxdInfoIsDIOModule : dwRet(%d),sErrdwStatusMsg(%d)',[dwRet,dwStatus]);
    CodeSite.Send(sDebug);
{$ENDIF}
		if (dwRet = AXT_RT_SUCCESS) then begin
			if (dwStatus = STATUS_EXIST) then begin
        dwRet := AxdInfoGetModuleCount(@lModuleCount);
        nModuleCnt := lModuleCount;
{$IFDEF DEBUG}
    sDebug := format('AxdInfoGetModuleCount : dwRet(%d),lModuleCount(%d)',[dwRet,lModuleCount]);
    CodeSite.Send(sDebug);
{$ENDIF}
				if (dwRet = AXT_RT_SUCCESS) then begin
					for i := 0 to lModuleCount do begin
						if (AxdInfoGetModule(i, @lBoardNo, @lModulePos, @dwModuleID) = AXT_RT_SUCCESS) then begin
{$IFDEF DEBUG}
    sDebug := format('AxdInfoGetModule : i(%d),lBoardNo(%d),lModulePos,dwModuleID(%0.2x)',[i,lBoardNo,lModulePos,dwModuleID]);
    CodeSite.Send(sDebug);
{$ENDIF}
							case dwModuleID of
                AXT_SIO_DI32: strData := Format('[BD No:%d - MD No:%d] SIO_DI32',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_DI32';
                AXT_SIO_DO32P: strData := Format('[BD No:%d - MD No:%d] SIO-DO32P',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO-DO32P';
                AXT_SIO_DB32P: strData := Format('[BD No:%d - MD No:%d] SIO-DB32P',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO-DB32P';
                AXT_SIO_DO32T: strData := Format('[BD No:%d - MD No:%d] SIO_DO32T',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_DO32T';
                AXT_SIO_DB32T: strData := Format('[BD No:%d - MD No:%d] SIO-DB32T',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO-DB32T';
                AXT_SIO_RDI32: strData := Format('[BD No:%d - MD No:%d] SIO_RDI32',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDI32';
                AXT_SIO_RDO32: strData := Format('[BD No:%d - MD No:%d] SIO_RDO32',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDO32';
                AXT_SIO_RSIMPLEIOMLII: strData := Format('[BD No:%d - MD No:%d] SIO_RSIMPLEIOMLII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RSIMPLEIOMLII';
                AXT_SIO_RDI16MLII: strData := Format('[BD No:%d - MD No:%d] SIO_RDI16MLII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDI16MLII';
                AXT_SIO_RDO16AMLII: strData := Format('[BD No:%d - MD No:%d] SIO_RDO16AMLII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDO16AMLII';
                AXT_SIO_RDO16BMLII: strData := Format('[BD No:%d - MD No:%d] SIO_RDO16BMLII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDO16BMLII';
                AXT_SIO_RDB96MLII: strData := Format('[BD No:%d - MD No:%d] SIO_RDB96MLII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDB96MLII';
  //              AXT_SIO_RDO32RTEX: strData := '[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDO32RTEX';
                AXT_SIO_RDI32RTEX: strData := Format('[BD No:%d - MD No:%d] SIO_RDI32RTEX',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDI32RTEX';
                AXT_SIO_RDB32RTEX: strData := Format('[BD No:%d - MD No:%d] SIO_RDO32',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDO32';
                AXT_SIO_DI32_P: strData := Format('[BD No:%d - MD No:%d] SIO_DI32_P',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_DI32_P';
                AXT_SIO_DO32T_P: strData := Format('[BD No:%d - MD No:%d] SIO_DO32T_P',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_DO32T_P';
                AXT_SIO_RDB32T: strData := Format('[BD No:%d - MD No:%d] SIO_RDB32T',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDB32T';
                AXT_SIO_RDI32MLIII: strData := Format('[BD No:%d - MD No:%d] SIO_RDI32MLIII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDI32MLIII';
                AXT_SIO_RDI32MSMLIII: strData := Format('[BD No:%d - MD No:%d] SIO_RDI32MSMLIII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDI32MSMLIII';
                AXT_SIO_RDI32PMLIII: strData := Format('[BD No:%d - MD No:%d] SIO_RDI32PMLIII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDI32PMLIII';
                AXT_SIO_RDO32MLIII: strData := Format('[BD No:%d - MD No:%d] SIO_RDO32MLIII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDO32MLIII';
                AXT_SIO_RDO32AMSMLIII: strData := Format('[BD No:%d - MD No:%d] SIO_RDO32AMSMLIII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDO32AMSMLIII';
                AXT_SIO_RDO32PMLIII: strData := Format('[BD No:%d - MD No:%d] SIO_RDO32PMLIII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDO32PMLIII';
                AXT_SIO_RDB32MLIII: strData := Format('[BD No:%d - MD No:%d] SIO_RDB32MLIII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDB32MLIII';
                AXT_SIO_RDB32PMLIII: strData := Format('[BD No:%d - MD No:%d] SIO_RDB32PMLIII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDB32PMLIII';
                AXT_SIO_RDB128MLIIIAI: strData := Format('[BD No:%d - MD No:%d] SIO_RDB128MLIIIAI',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDB128MLIIIAI';
                AXT_SIO_RDB128MLII: strData := Format('[BD No:%d - MD No:%d] SIO_RDB128MLII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDB128MLII';
                AXT_SIO_UNDEFINEMLIII: strData := Format('[BD No:%d - MD No:%d] SIO_UNDEFINEMLIII',[lBoardNo,i]);//'[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_UNDEFINEMLIII';
              end;
              if sModuleInfo <> '' then sModuleInfo := sModuleInfo + ', ';
              sModuleInfo := sModuleInfo + strData;
						end;
					end;
				end;
			end
			else  begin
        sErrMsg := 'Module does not exist.';
			end;
		end
		else  begin
			sErrMsg := 'AxdInfoIsDIOModule Error!!';
		end;
	end
	else begin
		sErrMsg := 'Open Error!';
	end;
  if sErrMsg <> '' then begin
    SendMainGuiDisplay(DefCommon.MSG_MODE_DISPLAY_CONNECTION, 1,sErrMsg);
  end
  else begin
    SendMainGuiDisplay(DefCommon.MSG_MODE_DISPLAY_CONNECTION, 0,'Connected');
  end;
  Result := dwRet;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.CheckThreadDio
//    Called-by: constructor TAxDio.Create(hMain: HWND; nType: Integer; nScanTime: Integer; nOption: Integer = 0)
//
procedure TAxDio.CheckThreadDio;
var
  dwDIOErr, dwDataHigh,dwDataHigh2, dwBit : DWORD;
  i : Integer;
  sDioMsg : string;
begin
  // Write - 100 ms, Read - 100 ms.
  while not m_bThreadStop do begin

    sDioMsg := '';
    dwDataHigh := 0;
    dwDIOErr :=	AxdiReadInportDword(0, 0, @dwDataHigh);
    if dwDIOErr = AXT_RT_SUCCESS then begin
      if dwDataHigh <> m_dwDataHigh then begin
        for i := 0 to DefDio.MAX_IO_CNT do begin
          if i > 31 then break;
          // Confirm a last bit price of data to read.
          dwBit := $01 shl i;
          if (dwBit and dwDataHigh) <> 0 then begin
            m_bInDio[i] := True;
          end
          else begin
            m_bInDio[i] := False;
          end;
        end;

        if dwDIOErr <> AXT_RT_SUCCESS then begin
          sDioMsg := Format('ERROR - Code (%d)',[dwDIOErr]);
          m_sPrevDioMsg := sDioMsg;
          FisConneced := False;
        end;
        m_dwDataHigh := dwDataHigh;
        if Assigned(InDioStatus) then InDioStatus(True,m_bInDio,sDioMsg);// InDioStatus(m_bInDio,m_bOutDio,sDioMsg);
        if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(True,m_bInDio,sDioMsg);

        if not FisConneced then Break;
      end;
    end
    else begin
      FisConneced := False;
      if m_sPrevDioMsg <> sDioMsg then begin
        sDioMsg := Format('ERROR - Code (%d)',[dwDIOErr]);
        m_sPrevDioMsg := sDioMsg;
        if Assigned(InDioStatus) then InDioStatus(True,m_bInDio,sDioMsg);
        if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(True,m_bInDio,sDioMsg);
      end;
      break;
    end;
    if m_bThreadStop then Break;
    Sleep(10);
    if m_bThreadStop then Break;
    dwDataHigh2 := 0;
    dwDIOErr :=	AxdiReadInportDword(1, 0, @dwDataHigh2);
    if dwDIOErr = AXT_RT_SUCCESS then begin
      if dwDataHigh2 <> m_dwDataHigh2 then begin
        for i := 32 to DefDio.MAX_IO_CNT do begin
          // Confirm a last bit price of data to read.
          dwBit := $01 shl (i-32);
          if (dwBit and dwDataHigh2) <> 0 then begin
            m_bInDio[i] := True;
          end
          else begin
            m_bInDio[i] := False;
          end;
        end;
        if dwDIOErr <> AXT_RT_SUCCESS then begin
          sDioMsg := Format('ERROR - Code (%d)',[dwDIOErr]);
          m_sPrevDioMsg := sDioMsg;
          FisConneced := False;
        end;
        m_dwDataHigh2 := dwDataHigh2;
        if Assigned(InDioStatus) then InDioStatus(True,m_bInDio,sDioMsg);// InDioStatus(m_bInDio,m_bOutDio,sDioMsg);
        if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(True,m_bInDio,sDioMsg);
        if not FisConneced then Break;
      end;
    end
    else begin
      FisConneced := False;
      if m_sPrevDioMsg <> sDioMsg then begin
        sDioMsg := Format('ERROR - Code (%d)',[dwDIOErr]);
        m_sPrevDioMsg := sDioMsg;
        if Assigned(InDioStatus) then InDioStatus(True,m_bInDio,sDioMsg);
        if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(True,m_bInDio,sDioMsg);
      end;
      Break;
    end;

    // 160 ms 마다 Scan.
    for i := 0 to 3 do begin
      Sleep(40);
      if m_bThreadStop then Break;
    end;
    // IO 설정에 따른 Output Siganl 변경.
    ControlOuput64;
//    if m_dwPreWriteDio <> m_dwWriteDio then begin
//
//      dwDIOErr := AxdoWriteOutportDword(1,0,m_dwWriteDio);
//      m_dwPreWriteDio := m_dwWriteDio;
//
//      if dwDIOErr <> AXT_RT_SUCCESS then begin
//        sDioMsg := Format('ERROR - Code (%d)',[dwDIOErr]);
//        m_sPrevDioMsg := sDioMsg;
//      end;
//      for i := 0 to Pred(DefDio.MAX_IO_CNT) do begin
//        if (m_dwWriteDio and ($01 shl i)) <> 0 then m_bOutDio[i] := True
//        else                                        m_bOutDio[i] := False;
//      end;
//      if Assigned(InDioStatus) then InDioStatus(False,m_bOutDio,sDioMsg);
//      if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(False,m_bOutDio,sDioMsg);
//      if Trim(sDioMsg) <> '' then Break;
//    end;
  end;

end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.ControlOuput64
//    Called-by: procedure TAxDio.CheckThreadDio;
//
procedure TAxDio.ControlOuput64;
var
  i : Integer;
  dwTemp1, dwTemp2    : DWORD;
  dwWrite1, dwWrite2  : DWORD;
  dwDIOErr            : DWORD;
  bWriteDio1, bWriteDio2  : boolean;
  sDioMsg             : string;
begin
  dwWrite1  := m_dwWriteDio;
  dwWrite2  := m_dwWriteDio2;
  // EMS 처리 부터.... 가장 중요함.
  dwTemp1 := 1 shl (DefDio.DIO_IN_EMS_1 - DefDio.MAX_MODULE_NO);
  dwTemp2 := 1 shl (DefDio.DIO_IN_EMS_2 - DefDio.MAX_MODULE_NO);
  bWriteDio1 := False;  bWriteDio2 := False;
  if ((m_dwDataHigh2 and (dwTemp1)) <> 0) or ((m_dwDataHigh2 and (dwTemp2)) <> 0)  then begin
    m_bEmsOn := True;
    bWriteDio2 := True;
    Sleep(50);
    dwWrite2 := 0;
    dwDIOErr := AxdoWriteOutportDword(2,0,dwWrite2);
    for i := 0 to Pred(DefDio.MAX_MODULE_NO) do begin
      dwTemp2 := $01 shl (i);
      if (dwWrite2 and dwTemp2) <> 0 then  m_bOutDio[i] := True
      else                                      m_bOutDio[i] := False;
    end;
    Sleep(50);

    dwWrite2 := 1 shl (DefDio.DIO_OUT_RED_LAMP-DefDio.MAX_MODULE_NO);
    dwWrite2 := (1 shl (DefDio.DIO_OUT_BUZZER-DefDio.MAX_MODULE_NO)) or dwWrite2;
    dwDIOErr := AxdoWriteOutportDword(3,0,dwWrite2);
    for i := DefDio.MAX_MODULE_NO to Pred(DefDio.MAX_IO_CNT) do begin
      dwTemp2 := $01 shl (i-DefDio.MAX_MODULE_NO);
      if (dwWrite2 and dwTemp2) <> 0 then  m_bOutDio[i] := True
      else                                 m_bOutDio[i] := False;
    end;

    if Assigned(InDioStatus) then InDioStatus(False,m_bOutDio,sDioMsg);
    if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(False,m_bOutDio,sDioMsg);
    m_dwWriteDio2 := dwWrite2;
    m_dwWriteDio  := dwWrite1;
    Exit;
  end
  // Reset.
  else if (((1 shl (DefDio.DIO_IN_RESET_1 - DefDio.MAX_MODULE_NO)) and m_dwDataHigh2) <> 0) or
          (((1 shl (DefDio.DIO_IN_RESET_2 - DefDio.MAX_MODULE_NO)) and m_dwDataHigh2) <> 0) then begin
    m_bEmsOn := False;
  end
  else if m_bEmsOn then begin
    Sleep(50);
    dwWrite2 := 0;
    dwDIOErr := AxdoWriteOutportDword(2,0,dwWrite2);
    for i := 0 to Pred(DefDio.MAX_MODULE_NO) do begin
      dwTemp1 := $01 shl (i);
      if (dwWrite2 and dwTemp1) <> 0 then  m_bOutDio[i] := True
      else                                      m_bOutDio[i] := False;
    end;
    Sleep(50);

    dwWrite2 := 1 shl (DefDio.DIO_OUT_RED_LAMP - DefDio.MAX_MODULE_NO);
    dwDIOErr := AxdoWriteOutportDword(3,0,dwWrite2);
    for i := DefDio.MAX_MODULE_NO to Pred(DefDio.MAX_IO_CNT) do begin
      dwTemp2 := $01 shl (i-DefDio.MAX_MODULE_NO);
      if (dwWrite2 and dwTemp2) <> 0 then  m_bOutDio[i] := True
      else                                 m_bOutDio[i] := False;
    end;
    m_dwWriteDio2 := dwWrite2;
    m_dwWriteDio  := dwWrite1;
    if Assigned(InDioStatus) then InDioStatus(False,m_bOutDio,sDioMsg);
    if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(False,m_bOutDio,sDioMsg);
    Exit;
  end;


  for i := DefDio.DIO_IN_PROBE_UP_1 to DefDio.DIO_IN_CONTACT_DN_8 do begin
    if i < DefDio.MAX_MODULE_NO then begin
      dwTemp1 := 1 shl i;
      // 해당 Part에 신호가 들어와 있으면 꺼주자.
      if (dwTemp1 and m_dwDataHigh) <> 0 then begin
        dwWrite1 := dwWrite1 and ((not dwTemp1) and $ffffffff);
      end;
    end
    else begin
      dwTemp2 := 1 shl (i-DefDio.MAX_MODULE_NO);
      if (dwTemp2 and m_dwDataHigh2) <> 0 then begin
        dwWrite2 := dwWrite2 and ((not dwTemp2) and $ffffffff);
      end;
    end;
  end;
  if (dwWrite1 <> m_dwWriteDio) then begin
    Sleep(10);
    for i := 0 to Pred(DefDio.MAX_MODULE_NO) do begin
      dwTemp1 := $01 shl i;
      if (m_dwWriteDio and dwTemp1) <> 0 then m_bOutDio[i] := True
      else                                    m_bOutDio[i] := False;
    end;
  {$IFDEF DEBUG}
    CodeSite.Send(Format('Write1 %0.8x , %0.8x',[dwWrite1, m_dwWriteDio]));
  {$ENDIF}
    m_dwWriteDio := dwWrite1;
    dwDIOErr := AxdoWriteOutportDword(2,0,dwWrite1);

    if dwDIOErr <> AXT_RT_SUCCESS then begin
      sDioMsg := Format('ERROR - Code (%d)',[dwDIOErr]);
      FisConneced := False;
    end
    else begin
      sDioMsg := '';
    end;
    m_sPrevDioMsg := sDioMsg;
    bWriteDio1 := True;
  end;
  // 사용은 안하지만 추후 기능 추가시를 대비.
  if (dwWrite2 <> m_dwWriteDio2) then begin
    Sleep(10);
    for i := DefDio.MAX_MODULE_NO to Pred(DefDio.MAX_IO_CNT) do begin
      dwTemp2 := $01 shl (i-DefDio.MAX_MODULE_NO);
      if (m_dwWriteDio2 and dwTemp2) <> 0 then  m_bOutDio[i] := True
      else                                      m_bOutDio[i] := False;
    end;
  {$IFDEF DEBUG}
    CodeSite.Send(Format('Write2 %0.8x , %0.8x',[dwWrite2, m_dwWriteDio2]));
  {$ENDIF}
    m_dwWriteDio2 := dwWrite2;
    dwDIOErr := AxdoWriteOutportDword(3,0,dwWrite2);
    if dwDIOErr <> AXT_RT_SUCCESS then begin
      sDioMsg := Format('ERROR - Code (%d)',[dwDIOErr]);
      FisConneced := False;
    end
    else begin
      sDioMsg := '';
    end;
    m_sPrevDioMsg := sDioMsg;
    bWriteDio2 := True;
  end;
  if bWriteDio1 or bWriteDio2 then begin
//    CodeSite.Send(Format('Write %0.8x , %0.8x',[dwWrite1, dwWrite2]));

    if Assigned(InDioStatus) then InDioStatus(False,m_bOutDio,sDioMsg);
    if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(False,m_bOutDio,sDioMsg);
  end;

  {for i := 0 to 31 do begin
    dwTemp := $01 shl i;
    if (m_dwWriteDio and dwTemp) <> 0 then m_bOutDio[i] := True
    else                                   m_bOutDio[i] := False;
  end;

  for i := 32 to Pred(DefDio.MAX_IO_CNT) do begin
    dwTemp := $01 shl (i-32);
    if (m_dwWriteDio2 and dwTemp) <> 0 then   m_bOutDio[i] := True
    else                                      m_bOutDio[i] := False;
  end;
  if dnSig > 31 then
    dwDIOErr := AxdoWriteOutportDword(3,0,m_dwWriteDio2)
  else
    dwDIOErr := AxdoWriteOutportDword(2,0,m_dwWriteDio);
  if dwDIOErr <> AXT_RT_SUCCESS then begin
    sDioMsg := Format('ERROR - Code (%d)',[dwDIOErr]);
    m_sPrevDioMsg := sDioMsg;
    FisConneced := False;
  end
  else begin
    sDioMsg := '';
  end;
  m_sPrevDioMsg := sDioMsg;
  if Assigned(InDioStatus) then InDioStatus(False,m_bOutDio,sDioMsg);
  if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(False,m_bOutDio,sDioMsg);}
end;

//******************************************************************************
// procedure/function:
//		- function TAxDio.SetDio(dwSig: DWORD; bAllSet: Boolean): DWORD;
//		- function TAxDio.SetDio64(dnSig: DWORD; bOff: Boolean): DWORD;
//		- function TAxDio.WriteDio(dwSig: DWORD; nVal : Integer): DWORD;
//		- procedure TAxDio.SetAutoControl(nStage: Integer; bFront : Boolean);
//		- procedure TAxDio.SetAutoManualCtrl(nStage: Integer; bDown: Boolean);	//TBD? REF_OPTIC_ONLY?
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.SetDio(dwSig: DWORD; bAllSet: Boolean): DWORD		//TBD? REF_OPTIC_GIB?
//    Called-by: none		//TBD? REF_OPTIC_GIB?
//
function TAxDio.SetDio(dwSig: DWORD; bAllSet: Boolean): DWORD;
var
  dwResult : DWORD;
  sErrMsg : string;
begin
  dwResult := AXT_RT_SUCCESS;
  if not bAllSet then begin
    if dwSig in [0.. DefDio.MAX_OUT_CNT] then begin
      // Signal이 들어와 있음으로 끄자.
      if m_bOutDio[dwSig] then begin
        dwResult := AxdoWriteOutportBit(0, dwSig, 0);
        m_bOutDio[dwSig] := False;

      end
      else begin
        dwResult := AxdoWriteOutportBit(0, dwSig, 1);
        m_bOutDio[dwSig] := True;

      end;
      if dwResult <> AXT_RT_SUCCESS then begin
        sErrMsg := Format('ERROR - Code (%d)',[dwResult]);
      end
      else begin
        sErrMsg := '';
      end;
      if Assigned(InDioStatus) then InDioStatus(False,m_bOutDio,sErrMsg);
      if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(False,m_bOutDio,sErrMsg);
    end;
  end;
  Result := dwResult;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.SetDio64(dnSig: DWORD; bOff: Boolean): DWORD		//TBD? REF_OPTIC_GIB?
//    Called-by:procedure TAxDio.SetAutoControl(nStage: Integer; bFront : Boolean)		//TBD? REF_OPTIC_GIB?
//    Called-by:procedure TAxDio.SetAutoManualCtrl(nStage: Integer; bDown: Boolean)		//TBD? REF_OPTIC_GIB?
//
function TAxDio.SetDio64(dnSig: DWORD; bOff: Boolean): DWORD;
var
  dnRealSig, dwTemp, dwDioErr : DWORD;
  i : Integer;
  sDioMsg : string;
begin
  // signal Check.
  if not Common.SystemInfo.OcManualType then begin
    // Front & back signal
    if dnSig in [DefDio.DIO_OUT_FORWORD_1, DefDio.DIO_OUT_BACK_1] then begin
      // Probe & Pusher가 Up이 아니면 Forward 신호를 주지 말자.
      if not (m_bInDio[DefDio.DIO_IN_PROBE_UP_1] and m_bInDio[DefDio.DIO_IN_PUSHER_UP_1]) then begin
        Exit(0);
      end;
    end;
    if dnSig in [DefDio.DIO_OUT_FORWORD_2, DefDio.DIO_OUT_BACK_2] then begin
      // Probe & Pusher가 Up이 아니면 Forward 신호를 주지 말자.
      if not (m_bInDio[DefDio.DIO_IN_PROBE_UP_2] and m_bInDio[DefDio.DIO_IN_PUSHER_UP_2]) then begin
        Exit(0);
      end;
    end;
  end;
  
  if Common.SystemInfo.OcManualType then begin
    // GIB-OPTIC:DIO:
    //   - Contact Open 관련 DIO 없음
    //   - Probe Down인 경우에도 기구적으로 Contact부와 Probe간 충돌없음
    //   - DIN_PRESSURE를 제어에 관련 시키는 것은 부적절 (압력센서 설정/관리 되지 않음)
    // OPTIC-GIB-DIO
    if dnSig = DefDio.DIO_OUT_PROBE_DOWN_1 then begin
    { //TBD:OPTIC-GIB:DIO: Probe Down 제어와 Presssure sensor 상태와의 연계 처리는 하지 않음
      for xxx := DefDio.DION_IN_PRESSURE_SEN_1 to DefDio.DION_IN_PRESSURE_SEN_4 do begin
        if not m_bInDio[xxx]then begin
          Exit(0);
        end;
      end;
    }
    end;
    if dnSig = DefDio.DIO_OUT_PROBE_DOWN_2 then begin
    { //TBD:OPTIC-GIB:DIO: Probe Down 제어와 Presssure sensor 상태와의 연계 처리는 하지 않음
      for xxx := DefDio.DION_IN_PRESSURE_SEN_5 to DefDio.DION_IN_PRESSURE_SEN_8 do begin
        if not m_bInDio[xxx]then begin
          Exit(0);
        end;
      end;
    }
    end;
  end;

  if dnSig > 31 then begin
    dnRealSig := 1 shl (dnSig - 32);
  end
  else begin
    dnRealSig := 1 shl dnSig;
  end;

  if bOff then begin
    // Signal Off
    if dnSig > 31 then
      m_dwWriteDio2 := m_dwWriteDio2 and ((not dnRealSig) and $ffffffff)
    else
      m_dwWriteDio := m_dwWriteDio and ((not dnRealSig) and $ffffffff);
  end
  else begin
    // Signal On.
    if dnSig > 31 then
      m_dwWriteDio2 := m_dwWriteDio2 or dnRealSig
    else
      m_dwWriteDio := m_dwWriteDio or dnRealSig;
  end;
  //dwDIOErr := AxdoWriteOutportDword(1,0,m_dwWriteDio);
  for i := 0 to 31 do begin
    dwTemp := $01 shl i;
    if (m_dwWriteDio and dwTemp) <> 0 then m_bOutDio[i] := True
    else                                   m_bOutDio[i] := False;
  end;

  for i := 32 to Pred(DefDio.MAX_IO_CNT) do begin
    dwTemp := $01 shl (i-32);
    if (m_dwWriteDio2 and dwTemp) <> 0 then   m_bOutDio[i] := True
    else                                      m_bOutDio[i] := False;
  end;
  if dnSig > 31 then
    dwDIOErr := AxdoWriteOutportDword(3,0,m_dwWriteDio2)
  else
    dwDIOErr := AxdoWriteOutportDword(2,0,m_dwWriteDio);
  if dwDIOErr <> AXT_RT_SUCCESS then begin
    sDioMsg := Format('ERROR - Code (%d)',[dwDIOErr]);
    m_sPrevDioMsg := sDioMsg;
    FisConneced := False;
  end
  else begin
    sDioMsg := '';
  end;
  m_sPrevDioMsg := sDioMsg;
  if Assigned(InDioStatus) then InDioStatus(False,m_bOutDio,sDioMsg);
  if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(False,m_bOutDio,sDioMsg);
  Result := dwDIOErr;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.WriteDio(dwSig: DWORD; nVal: Integer): DWORD	//TBD? REF_ISPD_A/L_OPTIC_GIB?
//    Called-by: procedure TScrCls.WriteDio_Proc(AMachine: TatVirtualMachine)	//TBD? REF_ISPD_A/L_OPTIC_GIB?
//    Called-by: procedure TfrmTest4Ch.WMCopyData(var Msg: TMessage) //MSG_TYPE_SCRIPT&MSG_MODE_DIO_CONTROL	//TBD? REF_ISPD_A/L_OPTIC_GIB?
//    Called-by: procedure TfrmMainA.FormCloseQuery(Sender: TObject; var CanClose: Boolean)	//TBD? REF_ISPD_A/L_OPTIC_GIB?
//    Called-by: procedure TfrmMainA.btnMaintMsgClick(Sender: TObject)	//TBD? REF_ISPD_A/L_OPTIC_GIB?
//		Called-by: procedure TfrmMainA.tmrDisplayTestFormTimer(Sender: TObject)	//TBD? REF_ISPD_A/L_OPTIC_GIB?
//
// dwSig : Position. nVal : 0 : off, 1 : On.
function TAxDio.WriteDio(dwSig: DWORD; nVal: Integer): DWORD;
var
  dwResult : DWORD;
  sErrMsg : string;
begin
  dwResult := 0;
  if not FisConneced then Exit(AXT_RT_NOT_OPEN);
  sErrMsg := '';
  if dwSig in [0.. DefDio.MAX_OUT_CNT] then begin
    // Signal이 들어와 있음으로 끄자.
    case nVal of

      0 : begin
        if m_bOutDio[dwSig] then begin
          dwResult := AxdoWriteOutportBit(0, dwSig, 0);
          if dwResult = AXT_RT_SUCCESS then begin
            m_bOutDio[dwSig] := False;
          end
          else begin
            sErrMsg := Format('ERROR - Code (%d)',[dwResult]);
          end;
          if Assigned(InDioStatus) then InDioStatus(False,m_bOutDio,sErrMsg);
          if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(False,m_bOutDio,sErrMsg);
        end;
      end;
      1 : begin
        if not m_bOutDio[dwSig] then begin
          dwResult := AxdoWriteOutportBit(0, dwSig, 1);
          if dwResult = AXT_RT_SUCCESS then begin
            m_bOutDio[dwSig] := True;
          end
          else begin
            sErrMsg := Format('ERROR - Code (%d)',[dwResult]);
          end;
          if Assigned(InDioStatus) then InDioStatus(False,m_bOutDio,sErrMsg);
          if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(False,m_bOutDio,sErrMsg);
        end;
      end
      else begin
        dwResult := AXT_RT_INVALID_VARIABLE;
      end;
    end;
  end
  else begin
    dwResult := AXT_RT_INVALID_VARIABLE;
  end;
  Result := dwResult;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.SetAutoControl(nStage: Integer; bFront : Boolean)		//TBD? REF_OPTIC_GIB
//    Called-by: procedure TfrmMainter.btnAutoFrontClick(Sender: TObject)	//TBD? REF_OPTIC_GIB
//    Called-by: procedure TfrmMainter.btnAutoBackClick(Sender: TObject);	//TBD? REF_OPTIC_GIB
//    Called-by: procedure TScrCls.ControlDio_Proc(AMachine: TatVirtualMachine);	//TBD? REF_OPTIC_GIB
//    Called-by: procedure TfrmTest4ChGB.SyncProbeBack(nJigCh, nParam1, nNgCode: Integer);	//TBD? REF_OPTIC_GIB
//
procedure TAxDio.SetAutoControl(nStage: Integer; bFront : Boolean);
var
  thDio : TThread;
begin
  if nStage = 0 then begin
    if m_bLock1 then Exit;
    m_bLock1 := True;
  end;
  if nStage = 1 then begin
    if m_bLock2 then Exit;
    m_bLock2 := True;
  end;

  thDio := TThread.CreateAnonymousThread( procedure
  var
    i: Integer;
    bIsTimeOut : boolean;
    sDebug : string;
    bTemp      : Boolean;
  begin
    bIsTimeOut := False;
    sDebug := '';
    if bFront then begin
        bTemp := m_bInDio[DefDio.DIO_IN_CONTACT_DN_1+ nStage*4] and m_bInDio[DefDio.DIO_IN_CONTACT_DN_2+ nStage*4];
        bTemp := bTemp and m_bInDio[DefDio.DIO_IN_CONTACT_DN_3+ nStage*4] and m_bInDio[DefDio.DIO_IN_CONTACT_DN_4+ nStage*4];

      // Contact Up 상태가 아니면 Up
      if not bTemp then begin
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_1 + nStage*4,False);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_2 + nStage*4,False);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_3 + nStage*4,False);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_4 + nStage*4,False);
        bIsTimeOut := True;
        for i := 0 to 20 do begin
          sleep(100);
          bTemp := m_bInDio[DefDio.DIO_IN_CONTACT_DN_1+ nStage*4] and m_bInDio[DefDio.DIO_IN_CONTACT_DN_2+ nStage*4];
          bTemp := bTemp and m_bInDio[DefDio.DIO_IN_CONTACT_DN_3+ nStage*4] and m_bInDio[DefDio.DIO_IN_CONTACT_DN_4+ nStage*4];
          if (bTemp) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_1 + nStage*4,True);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_2 + nStage*4,True);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_3 + nStage*4,True);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_4 + nStage*4,True);
        if bIsTimeOut then begin
          sDebug := '[DIO IN SENSOR] CONTACT DOWN';
          if not m_bInDio[DefDio.DIO_IN_CONTACT_DN_1+ nStage*4] then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 1,DefDio.DIO_IN_CONTACT_DN_1+ nStage*4]);
          end;
          if not m_bInDio[DefDio.DIO_IN_CONTACT_DN_2+ nStage*4] then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 2,DefDio.DIO_IN_CONTACT_DN_2+ nStage*4]);
          end;
          if not m_bInDio[DefDio.DIO_IN_CONTACT_DN_3+ nStage*4] then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 3,DefDio.DIO_IN_CONTACT_DN_3+ nStage*4]);
          end;
          if not m_bInDio[DefDio.DIO_IN_CONTACT_DN_4+ nStage*4] then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 4,DefDio.DIO_IN_CONTACT_DN_4+ nStage*4]);
          end;
        end;
        sDebug := sDebug + 'NG';
      end;


      // Probe Up 상태가 아니면 Up
      if (not (m_bInDio[DefDio.DIO_IN_PROBE_UP_1+ nStage] ))  and (not bIsTimeOut) then begin
        SetDio64(DefDio.DIO_OUT_PROBE_UP_1 + nStage,False);
        bIsTimeOut := True;
        for i := 0 to 20 do begin
          sleep(100);
          if (m_bInDio[DefDio.DIO_IN_PROBE_UP_1+ nStage] ) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_PROBE_UP_1 + nStage,True);
        if bIsTimeOut then begin
          sDebug := Format('[DIO IN SENSOR] PROBE UP %d (%0.2d) NG',[nStage + 1,DefDio.DIO_IN_PROBE_UP_1+ nStage])
        end;
      end;
      
      // Pusher Up 상태가 아니면 Up
      if (not (m_bInDio[DefDio.DIO_IN_PUSHER_UP_1+ nStage] )) and (not bIsTimeOut) then begin
        SetDio64(DefDio.DIO_OUT_PUSHER_UP_1 + nStage,False);
        bIsTimeOut := True;
        for i := 0 to 20 do begin
          sleep(100);
          if (m_bInDio[DefDio.DIO_IN_PUSHER_UP_1+ nStage] ) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_PUSHER_UP_1 + nStage,True);
        if bIsTimeOut then begin
          sDebug := Format('[DIO IN SENSOR] PUSHER UP %d (%0.2d) NG',[nStage + 1,DefDio.DIO_IN_PUSHER_UP_1+ nStage])
        end;
      end;
      // Probe 움직일때만...
      if m_bProbeFrontStop[nStage] then  begin
        // 2번일 경우 일시 정지.... NG 메시지 띄우지 말고...
        if nStage = 0 then DoneAutoControl1(2, sDebug)
        else if nStage = 1 then DoneAutoControl2(2, sDebug);
        if nStage = 0 then begin
          m_bLock1 := False;
        end;
        if nStage = 1 then begin
          m_bLock2 := False;
        end;
        Exit;
      end;

      // Front 상태가 아니면 Front
      if (not (m_bInDio[DefDio.DIO_IN_FORWORD_1+ nStage] )) and (not bIsTimeOut) then begin
        SetDio64(DefDio.DIO_OUT_FORWORD_1 + nStage,False);
        bIsTimeOut := True;
        for i := 0 to 300 do begin
          if m_bProbeFrontStop[nStage] then  begin
            Break;
          end;

          sleep(10);
          if (m_bInDio[DefDio.DIO_IN_FORWORD_1+ nStage] ) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_FORWORD_1 + nStage,True);
        if bIsTimeOut then begin
          sDebug := Format('[DIO IN SENSOR] FORWORD %d (%0.2d) NG',[nStage + 1,DefDio.DIO_IN_FORWORD_1+ nStage])
        end;
      end;
      // Probe 움직일때만...
      if m_bProbeFrontStop[nStage] then  begin
        // 2번일 경우 일시 정지.... NG 메시지 띄우지 말고...
        if nStage = 0 then DoneAutoControl1(2, sDebug)
        else if nStage = 1 then DoneAutoControl2(2, sDebug);
        if nStage = 0 then begin
          m_bLock1 := False;
        end;
        if nStage = 1 then begin
          m_bLock2 := False;
        end;
        Exit;
      end;

      // Pusher DOWN 상태가 아니면 DOWN
      if (not (m_bInDio[DefDio.DIO_IN_PUSHER_DOWN_1+ nStage] )) and (not bIsTimeOut) then begin
        SetDio64(DefDio.DIO_OUT_PUSHER_DOWN_1 + nStage,False);
        bIsTimeOut := True;
        for i := 0 to 20 do begin
          sleep(100);
          if (m_bInDio[DefDio.DIO_IN_PUSHER_DOWN_1+ nStage] ) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_PUSHER_DOWN_1 + nStage,True);
        if bIsTimeOut then begin
          sDebug := Format('[DIO IN SENSOR] PUSHER DOWN %d (%0.2d) NG',[nStage + 1,DefDio.DIO_IN_PUSHER_DOWN_1+ nStage])
        end;
      end;

      // Probe DOWN 상태가 아니면 DOWN
      if (not m_bInDio[DefDio.DIO_IN_PROBE_DOWN_1+ nStage] )and (not bIsTimeOut)  then begin
        SetDio64(DefDio.DIO_OUT_PROBE_DOWN_1 + nStage,False);
        bIsTimeOut := True;
        for i := 0 to 20 do begin
          sleep(100);
          if (m_bInDio[DefDio.DIO_IN_PROBE_DOWN_1+ nStage] ) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_PROBE_DOWN_1 + nStage,True);
        if bIsTimeOut then begin
          sDebug := Format('[DIO IN SENSOR] PROBE DOWN %d (%0.2d) NG',[nStage + 1,DefDio.DIO_IN_PROBE_DOWN_1+ nStage])
        end;
      end;

      bTemp :=           m_bInDio[DefDio.DIO_IN_CONTACT_UP_1+ nStage*4];
      bTemp := bTemp and m_bInDio[DefDio.DIO_IN_CONTACT_UP_2+ nStage*4];
      bTemp := bTemp and m_bInDio[DefDio.DIO_IN_CONTACT_UP_3+ nStage*4];
      bTemp := bTemp and m_bInDio[DefDio.DIO_IN_CONTACT_UP_4+ nStage*4];

      // Contact Up 상태가 아니면 Up
      if (not bTemp) and (not bIsTimeOut) then begin
        SetDio64(DefDio.DIO_OUT_CONTACT_UP_1 + nStage*4,not m_bInDio[DefDio.DIO_IN_DETECT_CH1+ nStage*4]);
        SetDio64(DefDio.DIO_OUT_CONTACT_UP_2 + nStage*4,not m_bInDio[DefDio.DIO_IN_DETECT_CH2+ nStage*4]);
        SetDio64(DefDio.DIO_OUT_CONTACT_UP_3 + nStage*4,not m_bInDio[DefDio.DIO_IN_DETECT_CH3+ nStage*4]);
        SetDio64(DefDio.DIO_OUT_CONTACT_UP_4 + nStage*4,not m_bInDio[DefDio.DIO_IN_DETECT_CH4+ nStage*4]);
        bIsTimeOut := True;
        for i := 0 to 20 do begin
          sleep(100);
          bTemp := True;
          if m_bInDio[DefDio.DIO_IN_DETECT_CH1+ nStage*4] then bTemp := bTemp and m_bInDio[DefDio.DIO_IN_CONTACT_UP_1+ nStage*4];
          if m_bInDio[DefDio.DIO_IN_DETECT_CH2+ nStage*4] then bTemp := bTemp and m_bInDio[DefDio.DIO_IN_CONTACT_UP_2+ nStage*4];
          if m_bInDio[DefDio.DIO_IN_DETECT_CH3+ nStage*4] then bTemp := bTemp and m_bInDio[DefDio.DIO_IN_CONTACT_UP_3+ nStage*4];
          if m_bInDio[DefDio.DIO_IN_DETECT_CH4+ nStage*4] then bTemp := bTemp and m_bInDio[DefDio.DIO_IN_CONTACT_UP_4+ nStage*4];

          if (bTemp) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_CONTACT_UP_1 + nStage*4,True);
        SetDio64(DefDio.DIO_OUT_CONTACT_UP_2 + nStage*4,True);
        SetDio64(DefDio.DIO_OUT_CONTACT_UP_3 + nStage*4,True);
        SetDio64(DefDio.DIO_OUT_CONTACT_UP_4 + nStage*4,True);
        if bIsTimeOut then begin
          sDebug := '[DIO IN SENSOR] CONTACT UP';
          if (not m_bInDio[DefDio.DIO_IN_CONTACT_UP_1+ nStage*4]) and (m_bInDio[DefDio.DIO_IN_DETECT_CH1+ nStage*4]) then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 1,DefDio.DIO_IN_CONTACT_UP_1+ nStage*4]);
          end;
          if (not m_bInDio[DefDio.DIO_IN_CONTACT_UP_2+ nStage*4]) and (m_bInDio[DefDio.DIO_IN_DETECT_CH2+ nStage*4]) then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 2,DefDio.DIO_IN_CONTACT_UP_2+ nStage*4]);
          end;
          if (not m_bInDio[DefDio.DIO_IN_CONTACT_UP_3+ nStage*4]) and (m_bInDio[DefDio.DIO_IN_DETECT_CH3+ nStage*4]) then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 3,DefDio.DIO_IN_CONTACT_UP_3+ nStage*4]);
          end;
          if (not m_bInDio[DefDio.DIO_IN_CONTACT_UP_4+ nStage*4]) and (m_bInDio[DefDio.DIO_IN_DETECT_CH4+ nStage*4]) then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 4,DefDio.DIO_IN_CONTACT_UP_4+ nStage*4]);
          end;
          sDebug := sDebug + 'NG';
          if nStage = 0 then DoneAutoControl1(1, sDebug)
          else if nStage = 1 then DoneAutoControl2(1, sDebug);

        end
        else begin
          if nStage = 0 then DoneAutoControl1(0, sDebug)
          else if nStage = 1 then DoneAutoControl2(0, sDebug);
        end;
      end;
    end
    else begin
      sleep(500);
      bTemp := m_bInDio[DefDio.DIO_IN_CONTACT_DN_1+ nStage*4] and m_bInDio[DefDio.DIO_IN_CONTACT_DN_2+ nStage*4];
      bTemp := bTemp and m_bInDio[DefDio.DIO_IN_CONTACT_DN_3+ nStage*4] and m_bInDio[DefDio.DIO_IN_CONTACT_DN_4+ nStage*4];
      // Contact Up 상태가 아니면 Up
      if not bTemp then begin
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_1 + nStage*4,False);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_2 + nStage*4,False);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_3 + nStage*4,False);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_4 + nStage*4,False);
        bIsTimeOut := True;
        for i := 0 to 20 do begin
          sleep(100);
          bTemp := m_bInDio[DefDio.DIO_IN_CONTACT_DN_1+ nStage*4] and m_bInDio[DefDio.DIO_IN_CONTACT_DN_2+ nStage*4];
          bTemp := bTemp and m_bInDio[DefDio.DIO_IN_CONTACT_DN_3+ nStage*4] and m_bInDio[DefDio.DIO_IN_CONTACT_DN_4+ nStage*4];
          if (bTemp) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_1 + nStage*4,True);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_2 + nStage*4,True);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_3 + nStage*4,True);
        SetDio64(DefDio.DIO_OUT_CONTACT_DN_4 + nStage*4,True);
        if bIsTimeOut then begin
          sDebug := '[DIO IN SENSOR] CONTACT DOWN';
          if not m_bInDio[DefDio.DIO_IN_CONTACT_DN_1+ nStage*4] then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 1,DefDio.DIO_IN_CONTACT_DN_1+ nStage*4]);
          end;
          if not m_bInDio[DefDio.DIO_IN_CONTACT_DN_2+ nStage*4] then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 2,DefDio.DIO_IN_CONTACT_DN_2+ nStage*4]);
          end;
          if not m_bInDio[DefDio.DIO_IN_CONTACT_DN_3+ nStage*4] then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 3,DefDio.DIO_IN_CONTACT_DN_3+ nStage*4]);
          end;
          if not m_bInDio[DefDio.DIO_IN_CONTACT_DN_4+ nStage*4] then begin
            sDebug := sDebug + Format(' %d (%0.2d),',[nStage*4 + 4,DefDio.DIO_IN_CONTACT_DN_4+ nStage*4]);
          end;
          sDebug := sDebug + 'NG';
        end;
      end;

      // Probe Up 상태가 아니면 Up
      if (not (m_bInDio[DefDio.DIO_IN_PROBE_UP_1+ nStage] )) and (not bIsTimeOut) then begin
        SetDio64(DefDio.DIO_OUT_PROBE_UP_1 + nStage,False);
        bIsTimeOut := True;
        for i := 0 to 20 do begin
          sleep(100);
          if (m_bInDio[DefDio.DIO_IN_PROBE_UP_1+ nStage] ) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_PROBE_UP_1 + nStage,True);
        if bIsTimeOut then begin
          sDebug := Format('[DIO IN SENSOR] PROBE UP %d (%0.2d) NG',[nStage + 1,DefDio.DIO_IN_PROBE_UP_1+ nStage])
        end;
      end;
      // Pusher Up 상태가 아니면 Up
      if (not (m_bInDio[DefDio.DIO_IN_PUSHER_UP_1+ nStage] )) and (not bIsTimeOut) then begin
        SetDio64(DefDio.DIO_OUT_PUSHER_UP_1 + nStage,False);
        bIsTimeOut := True;
        for i := 0 to 20 do begin
          sleep(100);
          if (m_bInDio[DefDio.DIO_IN_PUSHER_UP_1+ nStage] ) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_PUSHER_UP_1 + nStage,True);
        if bIsTimeOut then begin
          sDebug := Format('[DIO IN SENSOR] PUSHER UP %d (%0.2d) NG',[nStage + 1,DefDio.DIO_IN_PUSHER_UP_1+ nStage])
        end;
      end;
      // Back 상태가 아니면 Back
      if (not (m_bInDio[DefDio.DIO_IN_BACK_1+ nStage] )) and (not bIsTimeOut) then begin
        SetDio64(DefDio.DIO_OUT_BACK_1 + nStage,False);
        bIsTimeOut := True;
        for i := 0 to 30 do begin
          sleep(100);
          if (m_bInDio[DefDio.DIO_IN_BACK_1+ nStage] ) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_BACK_1 + nStage,True);
        if bIsTimeOut then begin
          sDebug := Format('[DIO IN SENSOR] BACK %d (%0.2d) NG',[nStage + 1,DefDio.DIO_IN_BACK_1+ nStage])
        end;
      end;
    end;
    if bIsTimeOut then begin
      SendMainGuiDisplay(DefCommon.MSG_MODE_DIO_SEN_NG, 0,sDebug);
      if nStage = 0 then DoneAutoControl1(1, sDebug)
      else if nStage = 1 then DoneAutoControl2(1, sDebug);
    end
    else begin
      if nStage = 0 then DoneAutoControl1(0, sDebug)
      else if nStage = 1 then DoneAutoControl2(0, sDebug);
    end;
    if nStage = 0 then begin
      m_bLock1 := False;
    end;
    if nStage = 1 then begin
      m_bLock2 := False;
    end;

  end);
  thDio.Start;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.SetAutoManualCtrl(nStage: Integer; bDown: Boolean)		//TBD? REF_OPTIC_ONLY
//    Called-by: procedure TScrCls.ControlDio_Proc(AMachine: TatVirtualMachine)
//    Called-by: procedure TfrmTest4ChGB.SyncProbeBack(nJigCh, nParam1, nNgCode: Integer)		//TBD? REF_OPTIC_GIB
//
procedure TAxDio.SetAutoManualCtrl(nStage: Integer; bDown: Boolean);	//TBD? REF_OPTIC_ONLY?
var
  thDio : TThread;
begin
  if nStage = 0 then begin
    if m_bLock1 then Exit;
    m_bLock1 := True;
  end;
  if nStage = 1 then begin
    if m_bLock2 then Exit;
    m_bLock2 := True;
  end;

  thDio := TThread.CreateAnonymousThread( procedure
  var
    i: Integer;
    bIsTimeOut : boolean;
    sDebug : string;
    bTemp      : Boolean;
  begin
    bIsTimeOut := False;
    sDebug := '';
    if bDown then begin

      // LED : 1
      SetDio64(DefDio.DIO_OUT_LED_SUB_1 + nStage,False);

      // Vacum Sol Off
      SetDio64(DefDio.DIO_OUT_VAC_SOL_1 + nStage*4,True); //True: Off, False: On
      SetDio64(DefDio.DIO_OUT_VAC_SOL_2 + nStage*4,True); //True: Off, False: On
      SetDio64(DefDio.DIO_OUT_VAC_SOL_3 + nStage*4,True); //True: Off, False: On
      SetDio64(DefDio.DIO_OUT_VAC_SOL_4 + nStage*4,True); //True: Off, False: On

      // Probe DOWN 상태가 아니면 DOWN
      if (not m_bInDio[DefDio.DIO_IN_PROBE_DOWN_1+ nStage] )and (not bIsTimeOut)  then begin
        SetDio64(DefDio.DIO_OUT_PROBE_DOWN_1 + nStage,False);
        bIsTimeOut := True;
        for i := 0 to 20 do begin
          sleep(100);
          if (m_bInDio[DefDio.DIO_IN_PROBE_DOWN_1+ nStage] ) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_PROBE_DOWN_1 + nStage,True);
        if bIsTimeOut then begin
          sDebug := Format('[DIO IN SENSOR] PROBE DOWN %d (%0.2d) NG',[nStage + 1,DefDio.DIO_IN_PROBE_DOWN_1+ nStage])
        end;
      end;

      if bIsTimeOut then begin
        sDebug := sDebug + 'NG';
        if nStage = 0 then DoneAutoControl1(1, sDebug)
        else if nStage = 1 then DoneAutoControl2(1, sDebug);

      end
      else begin
        if nStage = 0 then DoneAutoControl1(0, sDebug)
        else if nStage = 1 then DoneAutoControl2(0, sDebug);
      end;
      if nStage = 0 then begin
        m_bLock1 := False;
      end;
      if nStage = 1 then begin
        m_bLock2 := False;
      end;
    end
    else begin
      sleep(500);

      // Probe Up 상태가 아니면 Up
      if (not (m_bInDio[DefDio.DIO_IN_PROBE_UP_1+ nStage] )) and (not bIsTimeOut) then begin
        SetDio64(DefDio.DIO_OUT_PROBE_UP_1 + nStage,False);
        bIsTimeOut := True;
        for i := 0 to 20 do begin
          sleep(100);
          if (m_bInDio[DefDio.DIO_IN_PROBE_UP_1+ nStage] ) then begin
            bIsTimeOut := False;
            break;
          end;
        end;
        SetDio64(DefDio.DIO_OUT_PROBE_UP_1 + nStage,True);
        if bIsTimeOut then begin
          sDebug := Format('[DIO IN SENSOR] PROBE UP %d (%0.2d) NG',[nStage + 1,DefDio.DIO_IN_PROBE_UP_1+ nStage])
        end;
      end;

      if bIsTimeOut then begin
        SendMainGuiDisplay(DefCommon.MSG_MODE_DIO_SEN_NG, 0,sDebug);
        if nStage = 0 then DoneAutoControl1(1, sDebug)
        else if nStage = 1 then DoneAutoControl2(1, sDebug);
      end
      else begin
        if nStage = 0 then DoneAutoControl1(0, sDebug)
        else if nStage = 1 then DoneAutoControl2(0, sDebug);
      end;
      if nStage = 0 then begin
        m_bLock1 := False;
      end;
      if nStage = 1 then begin
        m_bLock2 := False;
      end;

      // LED : 1
      SetDio64(DefDio.DIO_OUT_LED_SUB_1 + nStage,True);

      // Auto Open : 1 -> 0
      SetDio64(DefDio.DIO_OUT_AUTO_OPEN_1 + nStage*4,False);
      SetDio64(DefDio.DIO_OUT_AUTO_OPEN_3 + nStage*4,False);
      sleep(300);

      SetDio64(DefDio.DIO_OUT_AUTO_OPEN_1 + nStage*4,True);
      SetDio64(DefDio.DIO_OUT_AUTO_OPEN_3 + nStage*4,True);
      sleep(300);

      // Auto Close : 1 -> 0
      SetDio64(DefDio.DIO_OUT_AUTO_CLOSE_1 + nStage*4,False);
      SetDio64(DefDio.DIO_OUT_AUTO_CLOSE_3 + nStage*4,False);
      sleep(300);

      SetDio64(DefDio.DIO_OUT_AUTO_CLOSE_1 + nStage*4,True);
      SetDio64(DefDio.DIO_OUT_AUTO_CLOSE_3 + nStage*4,True);

    end;
  end);
  thDio.Start;
end;

//******************************************************************************
// procedure/function: Timer
//		- procedure TAxDio.OntmCheckDioTimer(Sender: TObject);
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.OntmCheckDioTimer(Sender: TObject)
//    Called-by: constructor TAxDio.Create(hMain: HWND; nType: Integer; nScanTime: Integer; nOption: Integer = 0);
//
procedure TAxDio.OntmCheckDioTimer(Sender: TObject);
var
  dwDIOErr, dwDataHigh, dwBit : DWORD;
  i : Integer;
  sDioMsg : string;
//  sDebug : string;
begin
  dwDataHigh := 0;
//  dwBit := 0;
  sDioMsg := '';
//  tmCheckDio.Enabled
  // Read the signal to become input to WORD.
	dwDIOErr :=	AxdiReadInportWord(0, 0, @dwDataHigh);

//  sDebug := format('AxdiReadInportWord : m_dwModuleID(%d),dwDataHigh(%d),dwModuleID(%d),m_dwDataHigh(%d)',[m_dwModuleID,dwDataHigh,m_dwDataHigh]);
//  ShowMessage(sDebug);
//  tmCheckDio.Enabled := False;
  if dwDataHigh <> m_dwDataHigh then begin
    for i := 0 to Pred(DefDio.MAX_IN_CNT) do begin
      // Confirm a last bit price of data to read.
      dwBit := $01 shl i;
      if (dwBit and dwDataHigh) <> 0 then begin
        m_bInDio[i] := True;
      end
      else begin
        m_bInDio[i] := False;
      end;
    end;
    m_dwDataHigh := dwDataHigh;
    if dwDIOErr <> AXT_RT_SUCCESS then begin
      sDioMsg := Format('ERROR - Code (%d)',[dwDIOErr]);
      m_sPrevDioMsg := sDioMsg;
      FisConneced := False;
    end;
    if Assigned(InDioStatus) then InDioStatus(True,m_bInDio,sDioMsg);// InDioStatus(m_bInDio,m_bOutDio,sDioMsg);
    if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(True,m_bInDio,sDioMsg);
  end;
  if dwDIOErr <> AXT_RT_SUCCESS then begin
    FisConneced := False;
    if m_sPrevDioMsg <> sDioMsg then begin
      sDioMsg := Format('ERROR - Code (%d)',[dwDIOErr]);
      m_sPrevDioMsg := sDioMsg;
      if Assigned(InDioStatus) then InDioStatus(True,m_bInDio,sDioMsg);
      if Assigned(MaintInDioStatus) and IsMaintOn then MaintInDioStatus(True,m_bInDio,sDioMsg);
    end;
  end;
end;

//******************************************************************************
// procedure/function:
//		- procedure TAxDio.SendMainGuiDisplay(nGuiMode, nP1: Integer; sMsg: string);
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] TAxDio.SendMainGuiDisplay(nGuiMode, nP1: Integer; sMsg: string)
//    Called-by: function TAxDio.OpenDevice(var nModuleCnt : LongInt; var sErrMsg : string; var sModuleInfo : string) : DWORD
//    Called-by: procedure TAxDio.SetAutoControl(nStage: Integer; bFront : Boolean)
//    Called-by: procedure TAxDio.SetAutoManualCtrl(nStage: Integer; bDown: Boolean)
//
procedure TAxDio.SendMainGuiDisplay(nGuiMode, nP1: Integer; sMsg: string);
var
  ccd         : TCopyDataStruct;
  GuiData     : RGuiAxDio;
begin
  GuiData.MsgType := DefCommon.MSG_TYPE_AXDIO;
  GuiData.Channel := 0 ;
  GuiData.Mode    := nGuiMode;
  GuiData.nParam  := nP1;
  GuiData.Msg     := sMsg;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(GuiData);
  ccd.lpData      := @GuiData;
  SendMessage(m_hMain,WM_COPYDATA,0, LongInt(@ccd));
end;

end.
