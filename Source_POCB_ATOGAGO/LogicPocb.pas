unit LogicPocb;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.WinSock, Winapi.Messages, 
	System.SysUtils,  System.Classes, System.Variants, System.Threading, System.DateUtils, System.StrUtils, 	
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Graphics, 
	IdGlobal,	
  CommonClass, DefPocb, DefPG, UdpServerPocb, DefGmes, DefCam, CamComm,
	DefDio, DioCtl, DefIonizer, IonizerCtl, UserUtils,
{$IFDEF SITE_LENSVN}
  LensHttpMes,
{$ELSE}
  GMesCom,
{$ENDIF}
{$IFDEF HAS_ROBOT_CAM_Z}
  DefRobot, RobotCtl,
{$ENDIF}
{$IFDEF DFS_HEX}
  DfsFtpPocb,
{$ENDIF}
  CodeSiteLogging;

type

  TInspectionStatus = (IsStop, IsStart, IsLoading, IsCamera, IsUnload);   // IsStop : Ready or Stop, IsReady : get Serial Info., IsRun : Running for inspection.
  TInspctionStopReason = (StopNone, StopNormal, StopByOperator, StopByAlarm);
  TDfsUploadResult = (DfsUploadNone, DfsUploadOK, DfsUploadNG);  //2021-12-23
  TSkipPocbConfirmStatus = (SkipPocbConfirmNone, SkipPocbConfirmRUN, SkipPocbConfirmSKIP); //2022-06-XX A2CHv3:SKIP_POCB
	
  TInspectionInfo = record
    PowerOn       : Boolean;
    IsScanned     : Boolean;
    IsReport      : Boolean;
    IsLoaded      : Boolean;
		//
    IsFlashWrite  : Boolean;         //2019-03-11 F2CH //2023-05-22 GAGO
    PowerOnAgingRemainSec : Integer; //2021-12-29		   //2023-05-22 GAGO
    CurFlowSeq    : integer; //2023-06-12 //TBD:GAGO:NEWFLOW?
    FailCode      : integer; //TBD:GAGO:NEWFLOW? //REF_ITOLED_POCB?
    //
    RtyCount      : Integer;
    Fail_Message  : string;
    Full_name     : string;
    KeyIn         : string;
    CarrierId     : string;
    SerialNo      : string; //BCR
    PanelID       : string; //2021-12-23 (PID)
    Result        : string;
    csvHeaderDetail : string; //SummaryCsv_Detail (Uniformity)
    csvDataDetail   : string; //SummaryCsv_Detail (Uniformity)
    //
    TimeStart     : TDateTime;
    TimeEnd       : TDateTime;
    //
    JigTimeStart   : TDateTime;
    JigTimeEnd     : TDateTime;
    UnitTimeStart  : TDateTime;
    UnitTimeEnd    : TDateTime;
    PwrData        : TPwrDataPg;
    //
    DefectCode     : string;  // 2019-01-09 //2019-01-17 Gmes->m_Inspect
    DefectName     : string;  // 2019-01-09 //2019-01-17 Gmes->m_Inspect
    DefectMesCode  : string;  // 2019-01-09 //2019-01-17 Gmes->m_Inspect
    DfsUploadResult: TDfsUploadResult; //2021-12-23
    //
    IsGRR          : Boolean;
  //TBD? GB_Final       : string;
  //TBD? Pocb_Final     : string;
		// Uniformoty Verify
    UniformityPost       : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of Double; //Uniformity    -> UniformityPost
    UniformityPre        : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of Double; //PreUniformity -> UniformityPre
    UniformityResult     : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of string; //RetUniform    -> UniformityResult
    HasUniformityPoint   : Boolean;                                    //HasValues     -> HasUniformityPoint
    UniformityPointsPost : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of string; //Values        -> UniformityPointsPost
    UniformityPointsPre  : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of string; //PreValues     -> UniformityPointPre
    //
    ApdrCsvHeader : string; //2022-08-01
    ApdrCsvValues : string; //2022-08-01
  end;

  TRevNvmData = record
    Cmd   : Byte;
    Data  : array of Byte;
  end;

  PGuiLogic2Main  = ^RGuiLogic2Main;
  RGuiLogic2Main = packed record
    MsgType : Integer;
    Channel : Integer;
    Mode    : Integer;
    Param   : Integer;
    Param2  : Integer;
    Msg     : string;
  end;

  PGuiLogic2Test = ^RGuiLogic2Test;
  RGuiLogic2Test = packed record
    MsgType : Integer;
    Channel : Integer;
    Mode    : Integer;
    Param   : Integer;
    Param2  : Integer; //2019-05-20
    Msg     : string;
  end;

  PDataView  = ^RDataView;
  RDataView = packed record
    MsgType     : Integer;
    Channel     : Integer;
    Option      : Integer;
    Len         : Integer;
    Start       : Boolean;
    CellMerage  : boolean;
    Result      : Boolean;
    DataType    : Integer;
    MinVal      : Integer;
    MaxVal      : Integer;
    Msg         : string;
  end;

  InMaintEvnt = procedure (nCh : Integer; sMsg : string) of object;

  TLogic = class(TObject)

  private
    FChNo   : Integer;
    FPgNo   : Integer;
    FCamNo  : Integer;
    FJigNo  : Integer;
    FhDisplay : THandle;
    FDataView   : RDataView;
    FIsMainter: Boolean;
    FOnPgLogForMaint: InMaintEvnt;
    m_MainHandle : HWND;
    m_TestHandle : HWND;
    FbStopKeyLock : boolean;
  //m_nEERepeat : Integer;
    FPatGrp: TPatternGroup;
    tmPwrReq       : TTimer;
		tmPowerOnAging : TTimer; //2021-12-29 //2023-05-22 GAGO
{$IFDEF DFS_HEX}
    m_thDfs : TThread;
{$ENDIF}
    procedure ThreadTask(task : TProc);
    procedure SetIsMainter(const Value: Boolean);
    procedure SetOnPgLogForMaint(const Value: InMaintEvnt);
    procedure SendMainGuiDisplay(nGuiMode: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0);
    procedure SendTestGuiDisplay(nGuiMode: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0);
  //procedure SendTestChGuiDisplay(nCh: Integer; nGuiMode: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0); //A2CHv3:ASSY:FLOW //2023-08-11 (to public)
    function CheckMsgCamWork(nWaitSec : Integer) : enumCamRetType;
    procedure MakeCsvDataDetail;
    procedure SetPatGrp(const Value: TPatternGroup);
    procedure TMLog(sMsg : string);
  //procedure CamProcess(bMaintCamAutoTest: Boolean = False); //TBD:GAGO:NEWFLOW?
    procedure CamProcess; //TBD:GAGO:NEWFLOW?
    procedure SetCamNgCodeToMesCode(sCamNgMsg: string);
    function CheckI2CConnect : Integer;
    procedure OnPowerOnAgingTimer(Sender: TObject); //2021-12-29 //2023-05-22 GAGO
  public
    m_hCamEvnt     : HWND;
    m_nCamRet      : enumCamRetType;
    m_bCamEvnt     : Boolean;
    //
    m_bUse      : boolean;
    FLockThread : Boolean;
    m_Inspect   : TInspectionInfo;
    m_InsStatus : TInspectionStatus;
    m_bAutoPowerOff : boolean;
    m_IsSWStart : Boolean;
    m_bCBParaBeforeWrited : Boolean;  //m_PwrOptMode -> m_bCBParaWrited //USE_MODEL_PARAM_CSV
    m_bScanBcrOtherChMsgOn : Boolean; //2023-08-11
    m_SkipPocbConfirmStatus : TSkipPocbConfirmStatus; //2022-06-XX
		m_nCBIdx     : Integer; //0:1st-CB, 1:2nd-CB  //2022-11-14 FOLDABLE_GIB_FLOW //2023-05-22 GAGO
    m_nStopReason : TInspctionStopReason; //2018-12-11

    FIsOnPowerReset : Boolean; //TBD:GAGO:NEWFLOW? (Check ITOLED_POCB)

    constructor Create(nCH: Integer; hMain, hTest: HWND); virtual;
    destructor Destroy; override;

		//------------------------------------ POCB FlowSeq
    function RunFlowSeq_ScanBcr: Integer;
    function RunFlowSeq_MesPchk: Integer;
    function RunFlowSeq_InitPowerOn: Integer;
    {$IFDEF SUPPORT_1CG2PANEL}
    function RunFlowSeq_ConfirmSkipPocb: Integer; //TBD:NEW_FLOW?
    {$ENDIF}
    function RunFlowSeq_InitCBParaWrite: Integer;
    function RunFlowSeq_PowerReset(nCBIdx: Integer): Integer; //0:InitPowerReset, 1:CB1, 2:CB2
    function RunFlowSeq_DispPatPowerOn: Integer;
    {$IFDEF PANEL_AUTO}
    function RunFlowSeq_ProcMaskBeforeCheck: Integer;
    function RunFlowSeq_ProcMaskBeforeWrite: Integer;
    function RunFlowSeq_ProcMaskAfterWrite: Integer;
    {$ENDIF}
    function RunFlowSeq_PressStart: Integer;
    function RunFlowSeq_StageFwd: Integer;
    function RunFlowSeq_ShutterDown: Integer;
    function RunFlowSeq_CamProcSTART(nCamCBIdx: Integer): Integer;
    function RunFlowSeq_CamProcCBDataFlashWrite(nCBIdx: Integer): Integer;
    {$IFDEF PANEL_AUTO}
    function RunFlowSeq_CamProcAfterPUCWrite(nCBIdx: Integer): Integer;
    function RunFlowSeq_FinalCBParaWrite: Integer;
    {$ELSE}
    function RunFlowSeq_CamProcCBParaFlashWrite(nCBIdx: Integer): Integer;
    {$ENDIF}
    function RunFlowSeq_CamProcEXTRA: Integer;
    function RunFlowSeq_PucProcEND: Integer;  	//TBD:GAGO:NEWFLOW?
    function RunFlowSeq_DispPatVerify: Integer;
    function RunFlowSeq_StageBwd: Integer;
    function RunFlowSeq_MesEICR: Integer;
    function RunFlowSeq_DfsUpload: Integer;
    function RunFlowSeq_PowerOff: Integer;

    function RunFlowSeq(nFlowSeq: Integer): Integer;
    procedure SetFlowSeqResult(nFlowSeq: Integer; nFlowSeqRtn: Integer);
    procedure SendTestChGuiDisplay(nCh: Integer; nGuiMode: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0); //A2CHv3:ASSY:FLOW //2023-08-11 (from public)

    procedure DisplayContactPat(nIdx : Integer; sPatName : string);
    procedure InitialData;
    procedure GetCsvData(var sHead : string; var sData : string);
    procedure MakeTEndEvt(nCamRet : enumCamRetType);
    function MakeApdrApdInfo : string;
    function PgConnection : Boolean;
    function SpiConnection : boolean;
    procedure StartSeqInit;
    procedure SendScanSeq;
    procedure SendStartSeq1;
    procedure SendStartSeq2;
    procedure SendStartSeq3;
    procedure SendStartSeq4;  //2018-12-03
    procedure StartSeq2Stop;  //2018-12-16
    procedure SendStopSeq(newStopReason: TInspctionStopReason = StopNormal); //2018-12-04
    procedure DisplayPatCompBmp(nCompBmpIdx: Integer = 0);
    property PatGrp         : TPatternGroup read FPatGrp write SetPatGrp;
    // GMES
    procedure ClearGMesData;
    procedure SetMesResultInfo(nMesCode : Integer; Fail_Message, Result, DefectCode, DefectName, DefectMesCode, Rwk: String);
    procedure SendGmesMsg(nMsgType: Integer); //SendPCHK,SendEICR
    procedure RunMesEventSeq(event: Integer);
{$IFDEF DFS_HEX}
    function  WorkDfsFunc: Boolean;
{$ENDIF}
{$IFDEF FEATURE_BCR_SCAN_SPCB}
    function CheckEepromSPCBIdInterlock: Boolean; //2023-05-19 LGDVH:302#(A2CHv4):SPCB_ID_INTERLOCK
{$ENDIF}
{$IFDEF FEATURE_BCR_PID_INTERLOCK}
    function CheckEepromPIDInterlock: Boolean; //2023-09-24 LGDVH:#301:BCR_PID_INTERLOCK //2023-10-10 LENSVN:ATO:BCR_PID_INTERLOCK
{$ENDIF}

    property IsMainter : Boolean read FIsMainter write SetIsMainter;
    property OnPgLogForMaint : InMaintEvnt read FOnPgLogForMaint write SetOnPgLogForMaint;
		
		// USE_MODEL_PARAM_CSV
    function EepromDataCheck(dataType: enumEepromDataType): Boolean;  //TBD:USE_MODEL_PARAM_CSV?
    function EepromDataWrite(dataType: enumEepromDataType; bBefore: Boolean): Boolean;
    {$IF Defined(PANEL_AUTO)}
    function EepromGammaDataCheck: Boolean; //TBD:USE_MODEL_PARAM_CSV?
    function EepromGammaDataRead(var nGammaDataSize: Integer; var GammaDataBuf: array of Byte): Boolean;
    {$ELSEIF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
    function FlashGammaDataRead(var nGammaDataSize: Integer; var GammaDataBuf: array of Byte): Boolean;
    function FlashAfterPUCDataWrite(nCB: Integer): Boolean;
    {$ENDIF}
    function EepromFlashAccessWrite(bEnable: Boolean; bPowerResetIfChanged: Boolean = True): Boolean;
    function FlashCBDataFileWrite(fName: string): Boolean;
    function FlashCBDataWrite(const transData : TFileTranStr): Boolean;
    function GetBinFileToTransData(sFullPath: string; var transData: TFileTranStr): Boolean;
    function PucCtrlPocbOnOff(bOn: Boolean): Boolean; //2022-07-15 UNIFORMITY_PUCONOFF
		
		procedure SetPowerOnAgingTimer(nAgingSec: Integer); //2021-12-29 //2022-08-24 EXLIGHT_FLOW //2023-05-22 GAGO
  end;

var
  Logic : array[DefPocb.CH_1..DefPocb.CH_MAX] of TLogic;

implementation

uses OtlTaskControl, OtlParallel;

{ TLogic }
//{$r+} // memory range check.

//******************************************************************************
// procedure/function: Create/Destroy/Init/WMCOPY
//    - Create(nCH : Integer; hMain, hTest : HWND)
//    -
//******************************************************************************

constructor TLogic.Create(nCh : Integer; hMain, hTest : HWND);
begin
	//
  FChNo  := nCh;
  FPgNo  := nCh;
  FCamNo := nCh;
  FJigNo := nCh;
  //
  m_MainHandle := hMain;
  m_TestHandle := hTest;
  Pg[FPgNo].m_hTestFrm := hTest;

  //----
  FLockThread := False;
  FbStopKeyLock := False;
  InitialData;
//m_bForceStop := False;
  m_nStopReason := StopNone;  //2018-12-11
	
{$IFDEF PANEL_GAGO}	
  tmPowerOnAging := TTimer.Create(nil);  //2021-12-29 FOABDABLE //2023-05-22 GAGO
  tmPowerOnAging.OnTimer  := OnPowerOnAgingTimer;
  tmPowerOnAging.Interval := 1000;
  tmPowerOnAging.Enabled  := False;
{$ENDIF}
		
{$IFDEF PANEL_AUTO}
  {$IFDEF SITE_LGDVH}
  m_bAutoPowerOff := True;  //VH (A2CH|A2CHv2|A2CHv3|A2CHv4)
  {$ELSE}
  m_bAutoPowerOff := False; //LENS(ATO)
  {$ENDIF}
{$ELSE}
  m_bAutoPowerOff := False; //FOLD|GAGO
{$ENDIF}
  m_bCBParaBeforeWrited := False; //USE_MODEL_PARAM_CSV
  m_bScanBcrOtherChMsgOn := False; //2023-08-11
end;

destructor TLogic.Destroy;
begin
  if m_bCamEvnt then CloseHandle(m_hCamEvnt);

{$IFDEF PANEL_GAGO}
  tmPowerOnAging.Enabled := False; //2021-12-29 FOABDABLE //2023-05-22 GAGO
  tmPowerOnAging.Free;
  tmPowerOnAging := nil;
{$ENDIF}

  Sleep(10);
  inherited;
end;

procedure TLogic.InitialData;
var
  nIdx : Integer;
begin
//FillChar(m_Inspect,SizeOf(m_Inspect),0);
  m_Inspect.PowerOn      := False;
  m_Inspect.IsScanned    := False;
  m_Inspect.IsReport     := False;
  m_Inspect.IsLoaded     := False;

  m_Inspect.RtyCount     := 0;
  m_Inspect.Fail_Message := '';
  m_Inspect.Full_name    := '';
  m_Inspect.KeyIn        := '';
  m_Inspect.CarrierId    := '';
  m_Inspect.SerialNo     := '';  //2022-11-18 BCR#
  m_Inspect.PanelID      := '';  //2022-11-18 if PCHK_R.RTN_PID is received then PchkRtnPid else BCR#
  m_Inspect.Result       := '';
  m_Inspect.csvHeaderDetail := '';
  m_Inspect.csvDataDetail   := '';
  //
  m_Inspect.IsGRR        := False;
  m_Inspect.HasUniformityPoint := False;
  for nIdx := 0 to DefPocb.UNIFORMITY_PATTERN_MAX do begin
    m_Inspect.UniformityPost[nIdx]   := 0.0;
    m_Inspect.UniformityPre[nIdx]    := 0.0;
    m_Inspect.UniformityResult[nIdx] := '';
    m_Inspect.UniformityPointsPre[nIdx]  := ',,,,,,,,,,,,,,,,,,,,';
    m_Inspect.UniformityPointsPost[nIdx] := ',,,,,,,,,,,,,,,,,,,,';
  end;

  m_Inspect.TimeStart     := Now;
  m_Inspect.TimeEnd       := m_Inspect.TimeStart;
  m_Inspect.JigTimeStart  := m_Inspect.TimeStart;
  m_Inspect.JigTimeEnd    := m_Inspect.TimeStart;
  m_Inspect.UnitTimeStart := m_Inspect.TimeStart;
  m_Inspect.UnitTimeEnd   := m_Inspect.TimeStart;

  m_Inspect.PwrData.VCC     := 0;
  m_Inspect.PwrData.ICC     := 0;
  m_Inspect.PwrData.VDD_VEL := 0;
  m_Inspect.PwrData.IDD_IEL := 0;

  m_Inspect.DefectCode    := '';
  m_Inspect.DefectName    := '';
  m_Inspect.DefectMesCode := '';

//m_Inspect.GB_Final      := '';
//m_Inspect.Pocb_Final    := '';

  m_Inspect.DfsUploadResult := DfsUploadNone; //2021-12-23

	m_Inspect.PowerOnAgingRemainSec := 0; //2021-12-29
	m_Inspect.IsFlashWrite := False; //2019-03-11 F2CH

  m_Inspect.ApdrCsvHeader := '';  //2022-08-01
  m_Inspect.ApdrCsvValues := '';  //2022-08-01

{$IFDEF USE_FLASH_WRITE}
  Common.m_sCBDataFullName[FChNo] := '';
{$ENDIF}

  m_InsStatus := IsStop;
  m_nCamRet := camRetUnknown;
	m_nCBIdx := 0; //0:1st-CB, 1:2nd-CB //2022-11-14 FOLDABLE_GIB_FLOW	
	
//m_bForceStop := False;
  m_nStopReason := StopNone;  //2018-12-11
  m_bCBParaBeforeWrited := False; //2021-07-07
  m_bScanBcrOtherChMsgOn := False; //2023-08-11
  m_SkipPocbConfirmStatus := SkipPocbConfirmNone; //2022-06-XX

	// for GMES
  if DongaGmes <> nil then begin
		ClearGMesData;	// Initialize MES Buffer.  // 2018-08-17
  end;
  //
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',-1{dummay},DefPocb.SEQ_RESULT_CLEAR);//2019-05-20 GUI:FlowSeq
end;

procedure TLogic.ClearGMesData;
begin
    Common.MesData[FChNo].MesPendingMsg 			:= DefGmes.MES_UNKNOWN;
		Common.MesData[FChNo].MesSentMsg    	    := DefGmes.MES_UNKNOWN;
		Common.MesData[FChNo].MesSendRcvWaitTick  := 0;
		Common.MesData[FChNo].TxSerial            := '';
    //
    Common.MesData[FChNo].SerialNo  := '';
    Common.MesData[FChNo].Model     := '';
    Common.MesData[FChNo].Pf        := '';
    Common.MesData[FChNo].Rwk       := '';
    Common.MesData[FChNo].DefectPat := '';
    Common.MesData[FChNo].CarrierId := '';
    //
  //Common.MesData[FChNo].bPCHK     			:= False;
    Common.MesData[FChNo].PchkSendNg      := False;
    Common.MesData[FChNo].bRxPchkRtnPid   := False;
    Common.MesData[FChNo].PchkRtnCd       := ''; // PCHK_R.RTN_CD
    Common.MesData[FChNo].PchkRtnSerialNo := ''; // PCHK_R.RTN_SERIAL_NO
    Common.MesData[FChNo].PchkRtnPid      := ''; // PCHK_R.RTN_PID
    Common.MesData[FChNo].PchkRtnModel    := ''; // PCHK_R.MODEL
    Common.MesData[FChNo].PchkRtnSubPid   := ''; // PCHK.RTN_SUB_PID  //A2CHv3:ASSYPOCB:MES
    Common.MesData[FChNo].PchkRtnPcbid    := ''; // PCHK_R.RTN_PCBID  //A2CHv4:Lucid
    Common.MesData[FChNo].EicrSendNg      := False;
    Common.MesData[FChNo].EicrRtnCd       := ''; // EICR_R.RTN_CD
    Common.MesData[FChNo].ZsetSendNg      := False;
    Common.MesData[FChNo].ZsetRtnCd				:= ''; // ZSET_R.RTN_CD
    //
    Common.MesData[FChNo].ApdrApdInfo     := '';
{$IFDEF USE_EAS}
    Common.MesData[FChNo].MesApdrSendNg   := False;
    Common.MesData[FChNo].MesApdrRtnCd    := '';
    Common.MesData[FChNo].EasApdrSendNg   := False;
    Common.MesData[FChNo].EasApdrRtnCd    := '';
{$ENDIF}
end;

procedure TLogic.SetPatGrp(const Value: TPatternGroup);
begin
  Pg[Self.FPgNo].CurPatGrpInfo := Value;
  FPatGrp := Value;
end;

procedure TLogic.SetIsMainter(const Value: Boolean);
begin
  FIsMainter := Value;
end;

procedure TLogic.SetOnPgLogForMaint(const Value: InMaintEvnt);
begin
  FOnPgLogForMaint := Value;
end;


procedure TLogic.SetPowerOnAgingTimer(nAgingSec: Integer);
var
  sTemp :string;
begin
  if (nAgingSec > 0) then begin
    sTemp := Format('Aging (%d sec)',[nAgingSec]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sTemp);
    m_Inspect.PowerOnAgingRemainSec := (nAgingSec + 1);
    tmPowerOnAging.Enabled := True;
  end
  else begin
    m_Inspect.PowerOnAgingRemainSec := 0;
  end;
end;

procedure TLogic.OnPowerOnAgingTimer(Sender: TObject);
begin
  Dec(m_Inspect.PowerOnAgingRemainSec);
  if (m_Inspect.PowerOnAgingRemainSec <= 0) or
   //((m_InsStatus <> IsCamera) or (m_nStopReason = StopByOperator) or (m_nStopReason = StopByAlarm)) then
     (((m_InsStatus <> IsLoading) and (m_InsStatus <> IsCamera)) or (m_nStopReason = StopByOperator) or (m_nStopReason = StopByAlarm)) then begin
    tmPowerOnAging.Enabled := False;
    m_Inspect.PowerOnAgingRemainSec := 0;
  end;
end;

//******************************************************************************
// procedure/function:
//		- procedure TLogic.SendMainGuiDisplay(nGuiMode: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0);
//    - procedure TLogic.SendTestGuiDisplay(nGuiMode: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0);
//    - procedure TLogic.SendTestChGuiDisplay(nCh: Integer; nGuiMode: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0);
//******************************************************************************

procedure TLogic.SendMainGuiDisplay(nGuiMode: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0);
var
  ccd : TCopyDataStruct;
  GuiLogic2Main : RGuiLogic2Main;
begin
  GuiLogic2Main.MsgType := DefPocb.MSG_TYPE_LOGIC;
  GuiLogic2Main.Channel := FChNo;
  GuiLogic2Main.Mode    := nGuiMode;
  GuiLogic2Main.Param   := nParam;
  GuiLogic2Main.Param2  := nParam2;	
  GuiLogic2Main.Msg     := sMsg;
  //
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(GuiLogic2Main);
  ccd.lpData      := @GuiLogic2Main;
  SendMessage(m_MainHandle,WM_COPYDATA,0, LongInt(@ccd));
end;

procedure TLogic.SendTestGuiDisplay(nGuiMode: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0);
var
  ccd           : TCopyDataStruct;
  GuiLogic2Test : RGuiLogic2Test;
begin
//FillChar(GuiLogic2Test,SizeOf(GuiLogic2Test),#0);
  GuiLogic2Test.MsgType  := DefPocb.MSG_TYPE_LOGIC;
  GuiLogic2Test.Channel  := FChNo;
  GuiLogic2Test.Mode     := nGuiMode;
  GuiLogic2Test.Param    := nParam;
  GuiLogic2Test.Param2   := nParam2;
  GuiLogic2Test.Msg      := sMsg;
  //
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(GuiLogic2Test);
  ccd.lpData      := @GuiLogic2Test;
  SendMessage(m_TestHandle,WM_COPYDATA,0, LongInt(@ccd));

  if FIsMainter and (nGuiMode = DefPocb.MSG_MODE_WORKING) then OnPgLogForMaint(FChNo,sMsg);
end;

procedure TLogic.SendTestChGuiDisplay(nCh: Integer; nGuiMode: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0); //2021-05-31
var
  ccd           : TCopyDataStruct;
  GuiLogic2Test : RGuiLogic2Test;
begin
//FillChar(GuiLogic2Test,SizeOf(GuiLogic2Test),#0);
  GuiLogic2Test.MsgType  := DefPocb.MSG_TYPE_LOGIC;
  GuiLogic2Test.Channel  := nCh;
  GuiLogic2Test.Mode     := nGuiMode;
  GuiLogic2Test.Param    := nParam;
  GuiLogic2Test.Param2   := nParam2;
  GuiLogic2Test.Msg      := sMsg;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(GuiLogic2Test);
  ccd.lpData      := @GuiLogic2Test;
  SendMessage(Logic[nCh].m_TestHandle,WM_COPYDATA,0, LongInt(@ccd));  //2021-05-31
end;

//------------------------------------------------------------------------------
//

procedure TLogic.TMLog(sMsg: string);
begin
  SendTestGuiDisplay(DefPocb.MSG_MODE_LOG_ON_GUI,sMsg);
end;

procedure TLogic.ThreadTask(task: TProc);
var
  thLogic : TThread;
begin
  if FLockThread then Exit;
  FLockThread := True;
  thLogic := TThread.CreateAnonymousThread( procedure begin
    try
      task;
    finally
      FLockThread   := False;
    end;
  end);
  thLogic.FreeOnTerminate := True;
  thLogic.Start;
end;

//******************************************************************************
// procedure/function: Test1Ch -> Logic
//******************************************************************************

// Test1Ch -> Logic
procedure TLogic.SendScanSeq;
var
  sDebug : string;
begin
  SendTestGuiDisplay(DefPocb.MSG_MODE_TACT_START,'',0);
  sDebug := Format('====== Flow Start : EXE(%s) MODEL(%s)',[Common.m_sExeVerNameLog,Common.SystemInfo.TestModel[FChNo]{,Pg[Self.FPgNo].m_sFwVer}]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
{$IFDEF HAS_DIO_OUT_STAGE_LAMP}
 // if Common.SystemInfo.HasDioOutStageLamp then DongaDio.SetStageLamp(FPgNo,True{LampOn});
{$ENDIF}

  ClearGMesData;

  m_Inspect.SerialNo := '';
  m_Inspect.PanelID  := '';  //2021-12-23

  m_InsStatus := IsLoading;
  SendTestGuiDisplay(DefPocb.MSG_MODE_SHOW_SERIAL_NUMBER,'',0);
end;

{$IFDEF FEATURE_BCR_SCAN_SPCB}
// (2022-05-15) VH AUTO #302: SPCCB ID Check
//
function TLogic.CheckEepromSPCBIdInterlock: Boolean; //2023-05-19 VH#302 SPCB_ID_INTERLOCK
const
  EEPROM_SPCBID_DEVADDR = $A0;
  EEPROM_SPCBID_REGADDR = 4085;
  EEPROM_SPCBID_LEN  = 5;
  BCR_SPCB_LEFTRIGHT_LEN = 5;
var
  sBcrSPCB_Left, sBcrSPCB_Right, sEepromSPCB_Left, sEepromSPCB_Right : AnsiString;
  i, nDevice, nRegister, nLength : Integer;
  EepromSPCBID : array[0..(EEPROM_SPCBID_LEN-1)] of Byte; // Read from EEPROM
  sEepromSPCBLeft : array[0..(EEPROM_SPCBID_LEN-1)] of Byte; // Read from EEPROM

  sDebug, sTemp : string;
  dwRet  : DWORD;
begin
  Result := False;

  // Get BcrSPCB_PRE5, BcrSPCB_POST5
  if (Length(m_Inspect.SerialNo) < 10) or (not m_Inspect.IsScanned) then begin
    sDebug := Format('[BCR] SPCB-ID(%s) ...NG(Length)',[m_Inspect.SerialNo]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;
  sBcrSPCB_Left  := AnsiLeftStr(m_Inspect.SerialNo, BCR_SPCB_LEFTRIGHT_LEN);
  sBcrSPCB_Right := AnsiRightStr(m_Inspect.SerialNo,BCR_SPCB_LEFTRIGHT_LEN);
  sDebug := Format('[BCR] SPCB-ID(%s)',[m_Inspect.SerialNo]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

  // Read EEPROM (SPCB_ID)
  nDevice   := EEPROM_SPCBID_DEVADDR;
  nRegister := EEPROM_SPCBID_REGADDR;
  nLength   := EEPROM_SPCBID_LEN;

  sDebug := Format('[EEPROM] READ 0x%0.2x %d %d',[nDevice,nRegister,nLength]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
  dwRet := Pg[FPgNo].SendI2cRead(nLength,nDevice,nRegister);
  if dwRet <> WAIT_OBJECT_0 then begin
    if dwRet = WAIT_TIMEOUT then sDebug := sDebug+' ...NG(Read Timeout)'
    else                         sDebug := sDebug+' ...NG(Read Error)';
  	SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;
  CopyMemory(@EepromSPCBID[0], @Pg[FPgNo].FRxDataSpi.Data[0], nLength);

  sTemp := '';
  sEepromSPCB_Left  := '';
  sEepromSPCB_Right := '';
  for i := 0 to Pred(nLength) do begin
    sTemp := sTemp + Format('%0.2x ',[EepromSPCBID[i]]);
    //
    if i <= 1 then begin
      sEepromSPCB_Left := sEepromSPCB_Left + Format('%0.2x',[EepromSPCBID[i]])
    end
    else if i = 2 then begin
      sEepromSPCB_Left  := sEepromSPCB_Left + Format('%0.1x',[((EepromSPCBID[i] shr 4) and $FF)]);
      sEepromSPCB_Right := Format('%0.1x',[(EepromSPCBID[i] and $0F)]);
    end
    else begin
      sEepromSPCB_Right := sEepromSPCB_Right + Format('%0.2x',[EepromSPCBID[i]])
    end;
  end;
  sDebug := '[EEPROM] SPCB-ID Check Data (' + Trim(sTemp) + ')';
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

  // Compare Left5/Right5
  if (sBcrSPCB_Left <> sEepromSPCB_Left) or (sBcrSPCB_Right <> sEepromSPCB_Right) then begin

    sDebug := Format('[SPCB-ID] SPCB-ID Check Data Mismatch ...BCR(%s..%s)<>EEPROM(%s..%s)',[sBcrSPCB_Left,sBcrSPCB_Right,sEepromSPCB_Left,sEepromSPCB_Right]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;

  Result := True;
end;
{$ENDIF} //FEATURE_BCR_SCAN_SPCB

{$IF Defined(FEATURE_BCR_PID_INTERLOCK) and Defined(SITE_LGDVH)}
// (2023-09-14) VH AUTO #301 Line PID CHeck Concept from LGD
//
//       1...5..89???13 // 5             8           9           10           11     12             13
// e.g., 6DH3600099BAA  // 6             0           9           9            B      A              A
//           a  bcdefg  // a:Month(1~C), b:TFT(0~9), c:LOT(0~9), d:SLOT(0~Z), e:Cut, f:Addr#1(0~Z), g:Addr#2(0~Z)
//
//  PID Char-to-Num (0..9,A..Z)
//            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z
//   (dec) =  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35
//   (hex) =  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F,10,11,12,13,14,15,16,17,18,19,1A,1B,1C,1D,1E,1F,20,21,22,23
//
//  4086  4087  4088  4099
//  ----  ----  ----------
//    ae    bc  (d*36*36)+(f*36)+g = 12034(0x2F02)
//  0x6B  0x09  0x2F  0x02
//
function TLogic.CheckEepromPIDInterlock: Boolean; //2023-09-26 LGDVH:#301:BCR_PID_INTERLOCK
const
  //
  EEPROM_PID_CHECK_DEVADDR = $A0;
  EEPROM_PID_CHECK_REGADDR = 4086; //VH#301
  EEPROM_PID_CHECK_LEN     = 4;    //VH#301
  //
  PID_IDX_MONTH = 5;  //VH#301
  PID_IDX_TFT   = 8;  //VH#301
  PID_IDX_LOT   = 9;  //VH#301
  PID_IDX_SLOT  = 10; //VH#301
  PID_IDX_CUT   = 11; //VH#301
  PID_IDX_ADDR1 = 12; //VH#301
  PID_IDX_ADDR2 = 13; //VH#301
var
  BcrPIDCheckData    : array[0..(EEPROM_PID_CHECK_LEN-1)] of Byte; // Get from BCR
  EepromPIDCheckData : array[0..(EEPROM_PID_CHECK_LEN-1)] of Byte; // Read from EEPROM
  sBcrPIDCheckData, sEepromPIDCheckData : AnsiString;
  //
  nMonth, nTFT, nLOT, nSLOT, nCut, nAddr1, nAddr2 : Integer;
  nSlotAddr1Addr2 : Integer;
  i, nDevice, nRegister, nLength : Integer;
  sDebug, sTemp : string;
  dwRet  : DWORD;

  function CharToNum(c: AnsiChar): Integer;
  begin
    if (c in ['0'..'9'])      then Result := Ord(c) - Ord('0')
    else if (c in ['A'..'Z']) then Result := Ord(c) - Ord('A') + 10
    else                           Result := -1; // Invalid char in PID !!!
  end;

begin
  Result := False;

  // Check BCR(=PID) //VH 301#
  if (Length(m_Inspect.SerialNo) < 13) or (not m_Inspect.IsScanned) then begin //301# BCR#(=PID) e.g., 6DH3600099BAA (13 bytes)
    sDebug := Format('[BCR] PID(%s) ...NG(Length<13)',[m_Inspect.SerialNo]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;
  sDebug := Format('[BCR] PID(%s)',[m_Inspect.SerialNo]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

  // Make PID_CHECK Data(4 bytes) from BCR(=PID)
  nMonth := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_MONTH]));
  nTFT   := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_TFT]));
  nLOT   := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_LOT]));
  nSLOT  := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_SLOT]));
  nCut   := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_CUT]));
  nAddr1 := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_ADDR1]));
  nAddr2 := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_ADDR2]));
  //
  sTemp := '';
  if (nMonth < 0) or (nMonth > 15) then sTemp := sTemp + Format('Month[%d:',[PID_IDX_MONTH])+m_Inspect.SerialNo[PID_IDX_MONTH]+']'; // nibble
  if (nTFT   < 0) or (nTFT   > 15) then sTemp := sTemp + Format('TFT[%d:'  ,[PID_IDX_TFT])  +m_Inspect.SerialNo[PID_IDX_TFT]+']';   // nibble
  if (nLOT   < 0) or (nLOT   > 15) then sTemp := sTemp + Format('LOT[%d:'  ,[PID_IDX_LOT])  +m_Inspect.SerialNo[PID_IDX_LOT]+']';   // nibble
  if (nSLOT  < 0) or (nSLOT  > 35) then sTemp := sTemp + Format('SLOT[%d:' ,[PID_IDX_SLOT]) +m_Inspect.SerialNo[PID_IDX_SLOT]+']';  //
  if (nCut   < 0) or (nCut   > 15) then sTemp := sTemp + Format('Cut[%d:'  ,[PID_IDX_CUT])  +m_Inspect.SerialNo[PID_IDX_CUT]+']';   // nibble
  if (nAddr1 < 0) or (nAddr1 > 35) then sTemp := sTemp + Format('Addr1[%d:',[PID_IDX_ADDR1])+m_Inspect.SerialNo[PID_IDX_ADDR1]+']'; //
  if (nAddr2 < 0) or (nAddr2 > 35) then sTemp := sTemp + Format('Addr2[%d:',[PID_IDX_ADDR2])+m_Inspect.SerialNo[PID_IDX_ADDR2]+']'; //
  if (sTemp <> '') then begin
    sDebug := Format('[BCR] PID(%s) ...NG(Invalid %s)',[m_Inspect.SerialNo,sTemp]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;
  //
  BcrPIDCheckData[0] := Byte((nMonth shl 4) or nCut);
  BcrPIDCheckData[1] := Byte((nTFT shl 4) or nLOT);
  nSlotAddr1Addr2 := nSLOT*36*36 + nAddr1*36 + nAddr2;
  BcrPIDCheckData[2] := Byte((nSlotAddr1Addr2 and $FF00) shr 8);
  BcrPIDCheckData[3] := Byte(nSlotAddr1Addr2 and $FF);
  sBcrPIDCheckData := Format('%0.2x %0.2x %0.2x %0.2x',[BcrPIDCheckData[0],BcrPIDCheckData[1],BcrPIDCheckData[2],BcrPIDCheckData[3]]);
  sDebug := Format('[BCR] PID Check Data (%s)',[sBcrPIDCheckData]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

  // Read EEPROM (PID_ID_CHECK)
  nDevice   := EEPROM_PID_CHECK_DEVADDR;
  nRegister := EEPROM_PID_CHECK_REGADDR;
  nLength   := EEPROM_PID_CHECK_LEN;

  sDebug := Format('[EEPROM] READ 0x%02x %d %d',[nDevice,nRegister,nLength]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
  dwRet := Pg[FPgNo].SendI2cRead(nLength,nDevice,nRegister);
  if dwRet <> WAIT_OBJECT_0 then begin
    if dwRet = WAIT_TIMEOUT then sDebug := sDebug+' ...NG(Read Timeout)'
    else                         sDebug := sDebug+' ...NG(Read Error)';
  	SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;
  CopyMemory(@EepromPIDCheckData[0], @Pg[FPgNo].FRxDataSpi.Data[0], nLength);
  sEepromPIDCheckData := Format('%0.2x %0.2x %0.2x %0.2x',[EepromPIDCheckData[0],EepromPIDCheckData[1],EepromPIDCheckData[2],EepromPIDCheckData[3]]);
  sDebug := Format('[EEPROM] PID Check Data (%s)',[sEepromPIDCheckData]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

  // Compare BcrPIDCheckData to EepromPIDCheckData
  if sBcrPIDCheckData <> sEepromPIDCheckData then begin
    sDebug := Format('[PID] PID Check Data Mismatch ...BCR(%s)<>EEPROM(%s)',[sBcrPIDCheckData,sEepromPIDCheckData]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;

  Result := True;
end;
{$ENDIF} //FEATURE_BCR_PID_INTERLOCK+SITE_LGDVH

{$IF Defined(FEATURE_BCR_PID_INTERLOCK) and Defined(SITE_LENSVN)}
// (2023-09-14) LENS ATO PID Check Concept from LGD
//
//       1..45..89???13 // 4             5             8            9            10           11          12             13
// e.g., 6WZ34DD01SBQ1  // 3             4             0            1            S            B           Q              1
//          ab  cdefgh  // a:Year(0~15), b:Month(0~15) c:TFT(0~15), d:LOT(0~15), e:SLOT(0~Z), f:Cut(0~Z), g:Addr#1(0~Z), h:Addr#2(0~Z)
//
//  PID Char-to-Num (0..9,A..Z)
//            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z
//   (dec) =  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35
//   (hex) =  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F,10,11,12,13,14,15,16,17,18,19,1A,1B,1C,1D,1E,1F,20,21,22,23
//
//  4084  4085  4086  4087  4088  4099
//  ----  ----  ----  ----  ----------
//    ab    cd     e     f     g     h
//  0x34  0x01  0x1C  0x0B  0x1A  0x01
//
function TLogic.CheckEepromPIDInterlock: Boolean; //2023-10-10 LENSVN:ATO:BCR_PID_INTERLOCK
const
  //
  EEPROM_PID_CHECK_DEVADDR = $A0;
  EEPROM_PID_CHECK_REGADDR = 4084; //ATO
  EEPROM_PID_CHECK_LEN     = 6;    //ATO
  //
  PID_IDX_YEAR  = 4;  //ATO
  PID_IDX_MONTH = 5;  //ATO
  PID_IDX_TFT   = 8;  //ATO
  PID_IDX_LOT   = 9;  //ATO
  PID_IDX_SLOT  = 10; //ATO
  PID_IDX_CUT   = 11; //ATO
  PID_IDX_ADDR1 = 12; //ATO
  PID_IDX_ADDR2 = 13; //ATO
var
  BcrPIDCheckData    : array[0..(EEPROM_PID_CHECK_LEN-1)] of Byte; // Get from BCR
  EepromPIDCheckData : array[0..(EEPROM_PID_CHECK_LEN-1)] of Byte; // Read from EEPROM
  sBcrPIDCheckData, sEepromPIDCheckData : AnsiString;
  //
  nYear, nMonth, nTFT, nLOT, nSLOT, nCut, nAddr1, nAddr2 : Integer;
  i, nDevice, nRegister, nLength : Integer;
  sDebug, sTemp : string;
  dwRet  : DWORD;

  function CharToNum(c: AnsiChar): Integer;
  begin
    if (c in ['0'..'9'])      then Result := Ord(c) - Ord('0')
    else if (c in ['A'..'Z']) then Result := Ord(c) - Ord('A') + 10
    else                           Result := -1; // Invalid char in PID !!!
  end;

begin
  Result := False;

  // Check BCR(=PID) //ATO
  if (Length(m_Inspect.SerialNo) < 13) or (not m_Inspect.IsScanned) then begin //ATO BCR#(=PID) e.g., 6WZ34DD01SBQ1 (13 bytes)
    sDebug := Format('[BCR] PID(%s) ...NG(Length<13)',[m_Inspect.SerialNo]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;
  sDebug := Format('[BCR] PID(%s)',[m_Inspect.SerialNo]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

  // Make PID_CHECK Data(4 bytes) from BCR(=PID)
  nYear  := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_YEAR]));
  nMonth := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_MONTH]));
  nTFT   := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_TFT]));
  nLOT   := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_LOT]));
  nSLOT  := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_SLOT]));
  nCut   := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_CUT]));
  nAddr1 := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_ADDR1]));
  nAddr2 := CharToNum(AnsiChar(m_Inspect.SerialNo[PID_IDX_ADDR2]));
  //
  sTemp := '';
  if (nYear  < 0) or (nYear  > 15) then sTemp := sTemp + Format('Year[%d:', [PID_IDX_YEAR]) +m_Inspect.SerialNo[PID_IDX_YEAR]+']';  // nibble
  if (nMonth < 0) or (nMonth > 15) then sTemp := sTemp + Format('Month[%d:',[PID_IDX_MONTH])+m_Inspect.SerialNo[PID_IDX_MONTH]+']'; // nibble
  if (nTFT   < 0) or (nTFT   > 15) then sTemp := sTemp + Format('TFT[%d:',  [PID_IDX_TFT])  +m_Inspect.SerialNo[PID_IDX_TFT]+']';   // nibble
  if (nLOT   < 0) or (nLOT   > 15) then sTemp := sTemp + Format('LOT[%d:',  [PID_IDX_LOT])  +m_Inspect.SerialNo[PID_IDX_LOT]+']';   // nibble
  if (nSLOT  < 0) or (nSLOT  > 35) then sTemp := sTemp + Format('SLOT[%d:', [PID_IDX_SLOT]) +m_Inspect.SerialNo[PID_IDX_SLOT]+']';  //
  if (nCut   < 0) or (nCut   > 35) then sTemp := sTemp + Format('Cut[%d:',  [PID_IDX_CUT])  +m_Inspect.SerialNo[PID_IDX_CUT]+']';   //
  if (nAddr1 < 0) or (nAddr1 > 35) then sTemp := sTemp + Format('Addr1[%d:',[PID_IDX_ADDR1])+m_Inspect.SerialNo[PID_IDX_ADDR1]+']'; //
  if (nAddr2 < 0) or (nAddr2 > 35) then sTemp := sTemp + Format('Addr2[%d:',[PID_IDX_ADDR2])+m_Inspect.SerialNo[PID_IDX_ADDR2]+']'; //
  if (sTemp <> '') then begin
    sDebug := Format('[BCR] PID(%s) ...NG(Invalid %s)',[m_Inspect.SerialNo,sTemp]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;
  //
  BcrPIDCheckData[0] := Byte((nYear shl 4) or nMonth); //ATO
  BcrPIDCheckData[1] := Byte((nTFT shl 4) or nLOT);    //ATO
  BcrPIDCheckData[2] := Byte(nSLOT) and $FF;           //ATO
  BcrPIDCheckData[3] := Byte(nCut) and $FF;            //ATO
  BcrPIDCheckData[4] := Byte(nAddr1) and $FF;          //ATO
  BcrPIDCheckData[5] := Byte(nAddr2) and $FF;          //ATO
  sBcrPIDCheckData := Format('%0.2x %0.2x %0.2x %0.2x %0.2x %0.2x',[BcrPIDCheckData[0],BcrPIDCheckData[1],BcrPIDCheckData[2],BcrPIDCheckData[3],BcrPIDCheckData[4],BcrPIDCheckData[5]]);
  sDebug := Format('[BCR] PID Check Data (%s)',[sBcrPIDCheckData]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

  // Read EEPROM (PID_ID_CHECK)
  nDevice   := EEPROM_PID_CHECK_DEVADDR;
  nRegister := EEPROM_PID_CHECK_REGADDR;
  nLength   := EEPROM_PID_CHECK_LEN;

  sDebug := Format('[EEPROM] READ 0x%02x %d %d',[nDevice,nRegister,nLength]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
  dwRet := Pg[FPgNo].SendI2cRead(nLength,nDevice,nRegister);
  if dwRet <> WAIT_OBJECT_0 then begin
    if dwRet = WAIT_TIMEOUT then sDebug := sDebug+' ...NG(Read Timeout)'
    else                         sDebug := sDebug+' ...NG(Read Error)';
  	SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;
  CopyMemory(@EepromPIDCheckData[0], @Pg[FPgNo].FRxDataSpi.Data[0], nLength);
  sEepromPIDCheckData := Format('%0.2x %0.2x %0.2x %0.2x %0.2x %0.2x',[EepromPIDCheckData[0],EepromPIDCheckData[1],EepromPIDCheckData[2],EepromPIDCheckData[3],EepromPIDCheckData[4],EepromPIDCheckData[5]]);
  sDebug := Format('[EEPROM] PID Check Data (%s)',[sEepromPIDCheckData]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

  // Compare BcrPIDCheckData to EepromPIDCheckData
  if sBcrPIDCheckData <> sEepromPIDCheckData then begin
    sDebug := Format('[PID] PID Check Data Mismatch ...BCR(%s)<>EEPROM(%s)',[sBcrPIDCheckData,sEepromPIDCheckData]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;

  Result := True;
end;
{$ENDIF} //FEATURE_BCR_PID_INTERLOCK+SITE_LENSVN

procedure TLogic.SendStartSeq1;
var
  sFlowStep, sDebug : string;
  nRet     : DWORD;
  bRet     : Boolean;
  func     : TFunc<Boolean>;
  nFlowSeq : Integer;
  nPwrOnDelay, nPwrOffDelay : Integer;
  nPowerOnPatNum : Integer;
begin
  if Pg[FPgNo].StatusPg in [pgForceStop, pgDisconnect] then Exit;

  ThreadTask( procedure var i : Integer; begin
    m_InsStatus := IsStart;

    //---------------------------------
    if not Common.TestModelInfo2[FChNo].UseScanFirst then begin
      SendTestGuiDisplay(DefPocb.MSG_MODE_TACT_START,'',0);
      sDebug := Format('====== Flow Start : EXE(%s) MODEL(%s)',[Common.m_sExeVerNameLog,Common.SystemInfo.TestModel[FChNo]{,Pg[Self.FPgNo].m_sFwVer}]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
{$IFDEF HAS_DIO_OUT_STAGE_LAMP}
    // if Common.SystemInfo.HasDioOutStageLamp then DongaDio.SetStageLamp(FPgNo,True{LampOn});
{$ENDIF}
		  ClearGMesData;
      sDebug := '[MODEL] ' + Common.SystemInfo.TestModel[FChNo];
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    end;
    if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end; //2018-12-16

    //---------------------------------
    // Check Vacuum
    if Common.TestModelInfo2[FChNo].UseVacuum then begin  //2019-06-24
      func := function : Boolean begin Result := DongaDio.CheckVacuum(Self.FChNo, True); end;
      if not UserUtils.RetryFunc(func, 10) then begin
        sDebug := Format('CH%d Vacuume(s) is not working. Check vacuum of CH%d',[Self.FChNo+1,Self.FChNo+1]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,sDebug,1);
        m_InsStatus := IsStop;
        //Pg[Self.FPgNo].SendPowerOn(0);
        m_Inspect.PowerOn := False;
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,'Vacuum Fail',DefPocb.SEQ_RESULT_FAIL);
        Exit;
      end;
  	end;
    //---------------------------------
    {$IFDEF HAS_MOTION_CAM_Z}
    sDebug := '[MOTION] Z-Axis ModelPos('+FormatFloat(MOTION_FORMAT_CMDPOS, Common.TestModelInfo2[FChNo].CamZModelPos[m_nJig])+') CurPos('+FormatFloat(MOTION_FORMAT_CMDPOS,Common.m_nCurPosZAxis[m_nJig)+')';
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    {$ENDIF}
    {$IFDEF HAS_ROBOT_CAM_Z}
    with DongaRobot.Robot[FChNo].m_RobotStatusCoord do begin
      sDebug := '[ROBOT] X/Y/Z/Rx/Ry/Rz (' +FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.X)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Y)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Z)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Rx)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Ry)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Rz)+')';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    end;
    {$ENDIF}

    //---------------------------------
    if Common.TestModelInfo2[FChNo].UseIonOnOff then begin //2022-01-02
      SendTestGuiDisplay(DefPocb.MSG_MODE_IONIZER_ONOFF,'<IONIZER> OFF',0{Off});
    end;
    //---------------------------------
    {$IFDEF HAS_DIO_OUT_STAGE_LAMP}
   // if Common.SystemInfo.HasDioOutStageLamp then DongaDio.SetStageLamp(FPgNo,False{LampOff});
  {$ENDIF}

    //--------------------------------- Power On
    sFlowStep := 'Power ON --- ';
    nFlowSeq  := DefPocb.POCB_SEQ_INIT_POWER_ON;

    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,'Power On',DefPocb.CH_STATUS_INFO);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);

    nRet := Pg[Self.FPgNo].SendPgPowerOn(1);
    if nRet <> WAIT_OBJECT_0 then begin
      m_InsStatus := IsStop;
      m_Inspect.PowerOn := False;
      //
      sDebug := sFlowStep + 'Fail';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_FAIL);
      //
      //TBD:2021-05? NG_PROC:POWER_OFF?
      Exit;
    end;

    m_Inspect.PowerOn := True;
    sDebug := sFlowStep + 'OK';
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_PASS);
    if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;  //TBD:2021-05?

    //--------------------------------- Power On/Off Delay
    nPwrOnDelay := Common.TestModelInfo2[FChNo].PwrOnDelayMsec;
    if nPwrOnDelay > 0 then begin
      sDebug := Format('Delay %d ms',[nPwrOnDelay]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      Sleep(nPwrOnDelay);
    end;
    if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;

    //--------------------------------- SPCB_ID_INTERLOCK // 2023-05-19 A2CHv4
  {$IFDEF FEATURE_BCR_SCAN_SPCB}
    if Common.TestModelInfo2[FChNo].UseScanFirst and (Common.TestModelInfo2[FChNo].BcrScanMesSPCB and Common.TestModelInfo2[FChNo].BcrSPCBIdInterlock) then begin
      sFlowStep := 'SPCB-ID EEPROM Data Check';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sFlowStep+' ------');
      //
      if not CheckEepromSPCBIdInterlock then begin
        sDebug := sFlowStep + ' NG';
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sDebug,DefPocb.SEQ_RESULT_FAIL);
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_SCAN_BCR,DefPocb.SEQ_RESULT_FAIL);
        //
        m_InsStatus := IsStop;
        m_Inspect.PowerOn := False;
        Pg[Self.FPgNo].SendPgPowerOn(0);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_POWER_OFF,DefPocb.SEQ_RESULT_PASS);
        Exit;
      end;
      sDebug := sFlowStep + ' OK';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
			if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;
    end;
  {$ENDIF} //FEATURE_BCR_SCAN_SPCB

    //--------------------------------- BCR_PID_INTERLOCK //2023-09-24 VH#301
  {$IFDEF FEATURE_BCR_PID_INTERLOCK}
    if Common.TestModelInfo2[FChNo].UseScanFirst and ((not Common.TestModelInfo2[FChNo].BcrScanMesSPCB) and Common.TestModelInfo2[FChNo].BcrPIDInterlock) then begin
      sFlowStep := 'PID EEPROM Data Check';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sFlowStep+' ------');
      //
      if not CheckEepromPIDInterlock then begin
        sDebug := sFlowStep + ' NG';
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sDebug,DefPocb.SEQ_RESULT_FAIL);
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_SCAN_BCR,DefPocb.SEQ_RESULT_FAIL);
        //
        m_InsStatus := IsStop;
        m_Inspect.PowerOn := False;
        Pg[Self.FPgNo].SendPgPowerOn(0);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_POWER_OFF,DefPocb.SEQ_RESULT_PASS);
        Exit;
      end;
      sDebug := sFlowStep + ' OK';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
			if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;
    end;
  {$ENDIF} //FEATURE_BCR_PID_INTERLOCK

    //--------------------------------- Confirm SKIP-POCB //2022-06-XX
{$IFDEF PANEL_AUTO}
  {$IFDEF SUPPORT_1CG2PANEL}
    if (Common.SystemInfo.UseAssyPOCB and Common.SystemInfo.UseSkipPocbConfirm and (not Common.m_bMesOnline)) then begin
      m_SkipPocbConfirmStatus := SkipPocbConfirmNONE;
      sFlowStep := 'Confirm SKIP-POCB --- ';
      nFlowSeq  := DefPocb.POCB_SEQ_CONFIRM_SKIP_POCB;
      //ASSYPOCB:SKIP-POCB
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);
      SendTestGuiDisplay(DefPocb.MSG_MODE_CONFIRM_SKIP_POCB);  //Show ConfirmPowerReset Panel
      while (m_SkipPocbConfirmStatus = SkipPocbConfirmNONE) do begin  //Wait OP Selection
        Sleep(50);
        if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;
      end;
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_PASS);
      if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;
      //
      if (m_SkipPocbConfirmStatus = SkipPocbConfirmSKIP) then begin
        //
        if (Logic[DefPocb.CH_1].m_SkipPocbConfirmStatus = SkipPocbConfirmSKIP) and (Logic[DefPocb.CH_2].m_SkipPocbConfirmStatus = SkipPocbConfirmSKIP) then begin
          FLockThread := False; //TBD? 2022-06-XX?
          SendTestChGuiDisplay(DefPocb.CH_1,DefPocb.MSG_MODE_ALLCH_SKIP_POCB);
          SendTestChGuiDisplay(DefPocb.CH_2,DefPocb.MSG_MODE_ALLCH_SKIP_POCB);
          Exit;
        end;
        //
        m_InsStatus := IsLoading; //2021-03-17 Moved
        Pg[Self.FPgNo].SetPowerMeasureTimer(True,300);
        if Common.TestModelInfo2[FChNo].UseScanFirst then begin
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_PRESS_START,DefPocb.SEQ_RESULT_WORKING);
          if FJigNo = DefPocb.JIG_A then DongaDio.IsReadyToTurn1 := True
          else                           DongaDio.IsReadyToTurn2 := True;
        end
        else begin
          m_Inspect.SerialNo := '';
          m_Inspect.PanelID  := '';
          SendTestGuiDisplay(DefPocb.MSG_MODE_SHOW_SERIAL_NUMBER,sDebug,0);  //TBD:2021-05? sDebug?
        end;
        Exit;
      end;
    end;
  {$ENDIF} //SUPPORT_1CG2PANEL
{$ENDIF} //PANEL_AUTO

    //--------------------------------- EEPROM FlashAccess(Disable) if GIB //2021-04-29 FLASH !!!
{$IFDEF PANEL_AUTO}
    if Common.TestModelInfo2[FChNo].EnableFlashWriteCBData then begin
      sFlowStep := 'EEPROM FlashAccess(Disable) Check';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sFlowStep+' ------');

      bRet := EepromFlashAccessWrite(False{bEnable},(not Common.TestModelInfo2[FChNo].EnablePwrMode){bPowerResetIfChanged}); // Power Reset after EEPROM CBPARA Write
      if (not bRet) then begin
        sDebug := sFlowStep + ' NG';
    //SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sDebug,DefPocb.SEQ_RESULT_FAIL);
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_FAIL);
        //
        m_InsStatus := IsStop;
        m_Inspect.PowerOn := False;
        Pg[Self.FPgNo].SendPgPowerOn(0);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_POWER_OFF,DefPocb.SEQ_RESULT_PASS);
        Exit;
      end;
  		if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;
    end;
{$ENDIF} //PANEL_AUTO

    //------------------------------------------------------------------ EEPROM CBPARA(Before) Write/Verify
    if Common.TestModelInfo2[FChNo].EnablePwrMode then begin  //2021-07-07
      nFlowSeq := DefPocb.POCB_SEQ_INIT_CBPARA_WRITE;
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);

      sFlowStep := 'EEPROM CBPARA(Before) Write';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sFlowStep+' ------');

      bRet := EepromDataWrite(eepromCBParam,True{bBefore});  //USE_MODEL_PARAM_CSV
      if (not bRet) then begin
        sDebug := sFlowStep + ' NG';
        SetMesResultInfo(19,sDebug, 'Fail', 'PD19', sDebug, DefGmes.POCB_MESCODE_PD19_SUMMARY, DefGmes.POCB_MESCODE_PD19_RWK); //TBD:MES_CODE?
      //SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sDebug,DefPocb.SEQ_RESULT_FAIL);
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_FAIL);
        //
        m_InsStatus := IsStop;
        m_Inspect.PowerOn := False;
        Pg[Self.FPgNo].SendPgPowerOn(0);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_POWER_OFF,DefPocb.SEQ_RESULT_PASS);
        Exit;
      end;
      sDebug := sFlowStep + ' OK';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_PASS);
      if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;//2018-12-16

      //--------------------------------- Power Reset
{$IFDEF PANEL_AUTO}				
      nFlowSeq := DefPocb.POCB_SEQ_INIT_POWER_RESET;
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);

      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
      m_Inspect.PowerOn := False;
      Pg[FPgNo].SendPgPowerOn(0); // power off
      nPwrOffDelay := Common.TestModelInfo2[FChNo].PwrOffDelayMsec;
      if nPwrOffDelay > 0 then begin
        sDebug := Format('Delay %d ms',[nPwrOffDelay]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
        Sleep(nPwrOffDelay);
      end;

      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power On');
      m_Inspect.PowerOn := True;
      Pg[FPgNo].SendPgPowerOn(1); // power On
      nPwrOnDelay := Common.TestModelInfo2[FChNo].PwrOnDelayMsec;
      if nPwrOnDelay > 0 then begin
        sDebug := Format('Delay %d ms',[nPwrOnDelay]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
        Sleep(nPwrOnDelay);
      end;
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_PASS);
{$ENDIF} //PANEL_AUTO
    end;

    //--------------------------------- Display Pattern
    nPowerOnPatNum := Common.TestModelInfo2[FChNo].PowerOnPatNum;  //2021-11-24 POWER_ON_PATTERN

    nFlowSeq := DefPocb.POCB_SEQ_PAT_DISP_POWERON;
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);

    Pg[Self.FPgNo].SendPgDisplayPatNum(nPowerOnPatNum);

    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_PASS);
    if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;//2018-12-16

  //-------------------------------------------------------------------- EEPROM ProcMask(Before) Check/Write
{$IFDEF PANEL_AUTO}
    if Common.TestModelInfo2[FChNo].EnableProcMask and (Common.m_bMesOnline or (not Common.m_bPmModeProcMaskSkip)) then begin //2023-09-20 1) EnableProcMask(always True) 2) Skip if PmMode & ProcMaskSkip(by MainGUI checkbox)

      //--------------------------------- EEPROM ProcMask(Before) Check
      sFlowStep := 'EEPROM ProcMask(Before) Check';
      nFlowSeq  := DefPocb.POCB_SEQ_PROCMASK_BEFORE_CHECK;
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sFlowStep+' ------');
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);

      bRet := EepromDataCheck(eepromProcMask);  //TBD:2021-05? (NG_REASON: R/W Fail?, Value Fail?)
      if (not bRet) then begin
        sDebug := sFlowStep + ' NG';
        SetMesResultInfo(22,sDebug,'Fail','PD22',sDebug,DefGmes.POCB_MESCODE_PD22_SUMMARY,DefGmes.POCB_MESCODE_PD22_RWK); //TBD:MES_CODE?
        //
      //SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sDebug,DefPocb.SEQ_RESULT_FAIL);
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_FAIL);
        //
        m_InsStatus := IsStop;
        m_Inspect.PowerOn := False;
        Pg[Self.FPgNo].SendPgPowerOn(0);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_POWER_OFF,DefPocb.SEQ_RESULT_PASS);
        Exit;
      end;
      sDebug := sFlowStep + ' OK';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_PASS);
      if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;

      //--------------------------------- EEPROM ProcMask(Before) Write  // --> 'ProcMask Reset'
      if Common.TestModelInfo2[FChNo].EnableProcMask then begin
        if Common.SystemInfo.UseGIB then begin
          sFlowStep := 'EEPROM ProcMask(Before) Write';  // --> 'ProcMask Reset'
          nFlowSeq  := DefPocb.POCB_SEQ_PROCMASK_BEFORE_WRITE;
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sFlowStep+' ------');
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);

          bRet := EepromDataWrite(eepromProcMask,True{bBefore});
          if (not bRet) then begin //USE_MODEL_PARAM_CSV
            sDebug := sFlowStep + ' NG';  // 'ProcMask Reset NG'
            SetMesResultInfo(22,sDebug,'Fail','PD22',sDebug,DefGmes.POCB_MESCODE_PD22_SUMMARY,DefGmes.POCB_MESCODE_PD22_RWK); //TBD:MES_CODE?
            //
          //SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
            SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sDebug,DefPocb.SEQ_RESULT_FAIL);
            SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_FAIL);
            //
            m_InsStatus := IsStop;
            m_Inspect.PowerOn := False;
            Pg[Self.FPgNo].SendPgPowerOn(0);
            SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
            SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_POWER_OFF,DefPocb.SEQ_RESULT_PASS);
            Exit;
          end;
          sDebug := sFlowStep + ' OK';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_PASS);
          if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;//2018-12-16
        end;
      end;
    end;
{$ENDIF} //PANEL_AUTO

    //---------------------------------
    m_InsStatus := IsLoading; //2021-03-17 Moved //TBD:MERGE? (IsLoading??)
    // Power Measurement.
    Pg[Self.FPgNo].SetPowerMeasureTimer(True{bEnable},300{nInterval}); //TBD:MERGE? POWER_MEASURE?
    if Common.TestModelInfo2[FChNo].UseScanFirst then begin
      SendTestGuiDisplay(DefPocb.MSG_MODE_SHOW_READY_TO_TURN,'',0);
      if FJigNo = DefPocb.JIG_A then DongaDio.IsReadyToTurn1 := True
      else                           DongaDio.IsReadyToTurn2 := True;
    end 
		else begin
      m_Inspect.SerialNo := '';
      m_Inspect.PanelID  := '';
      SendTestGuiDisplay(DefPocb.MSG_MODE_SHOW_SERIAL_NUMBER,sDebug,0);  //TBD:MERGE? 2021-05? sDebug?
    end;
  //m_InsStatus := IsLoading;
    if (m_nStopReason <> StopNone) then begin StartSeq2Stop; Exit; end;//2018-12-16
		
{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
    // Set Aging Timer
    if not Common.TestModelInfo2[FChNo].UseExLightFlow then begin //2022-08-23 (EXLIGHT_FLOW)
      SetPowerOnAgingTimer(Common.TestModelInfo2[FChNo].PowerOnAgingSec); //2021-12-29
    end;
{$ENDIF}

  end );
end;

procedure TLogic.StartSeq2Stop;  //2018-12-16
var
  nFlowSeq  : Integer;
  sFlowStep, sDebug : string;
  bRet : Boolean;
begin
  Pg[Self.FPgNo].SetPowerMeasureTimer(False);

{$IFDEF PANEL_AUTO}
  if m_bCBParaBeforeWrited then begin
    nFlowSeq := DefPocb.POCB_SEQ_FINAL_CBPARA_WRITE; //TBD:2021-12-07?
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);
    sFlowStep := 'EEPROM CBPARA(After) Write';
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sFlowStep+' ------');
    //
    bRet := EepromDataWrite(eepromCBParam,False{bBefore}); //USE_MODEL_PARAM_CSV
    if bRet then begin
      sDebug := sFlowStep + ' OK';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_INFO);
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_PASS)
    end
    else begin
      sDebug := sFlowStep + ' NG';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_FAIL);
    end;
  end;
{$ENDIF} //PANEL_AUTO

  m_InsStatus := IsStop;
  m_Inspect.PowerOn := False;
  Pg[Self.FPgNo].SendPgPowerOn(0);

  SendTestGuiDisplay(DefPocb.MSG_MODE_FLOW_STOP_REPORT,'',0);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_POWER_OFF,DefPocb.SEQ_RESULT_PASS);
  m_nStopReason := StopNone; //2018-12-16
end;

procedure TLogic.SendStartSeq2;
begin
  if m_InsStatus <> IsLoading then Exit;

  m_InsStatus := IsCamera;
  CameraComm.m_bForceStop[FChNo]   := False;  //A2CHv3:ASSY-POCB:FLOW
  CameraComm.m_bSendTSTOP[FChNo]   := False;  //A2CHv3:ASSY-POCB:FLOW
  CameraComm.m_bIsOnCamFlow[FChNo] := False;  //A2CHv3:ASSY-POCB:FLOW
  CameraComm.m_bCamZoneDone[FChNo] := False;  //A2CHv3:ASSY-POCB:FLOW

//ThreadTask(CamProcess{(False{bMaontCamAytoTest}}); //TBD:GAGO:NEWFLOW?
  ThreadTask(CamProcess);
end;

procedure TLogic.SendStartSeq3;
var
  sRetMsg : string;
begin
  if m_InsStatus <> IsCamera then Exit;
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Start Unloading Zone');
  m_InsStatus := IsUnload;
  //
{$IFDEF SITE_LENSVN}
  if (DongaGmes <> nil) and Common.m_bMesOnline then Common.MesData[FChNo].ApdrApdInfo := MakeApdrApdInfo;
  //
  if (DongaGmes <> nil) and Common.m_bMesOnline and (not Common.SystemInfo.UseGRR) then begin
    if Common.SystemInfo.UseEicrPassOnly then begin  //2018-12-17
      if (Trim(m_Inspect.Result) = 'PASS') then begin  //PASS만 EICR 보냄
        if not Common.SystemInfo.UseGIB then SendGmesMsg(DefGmes.MES_EICR) else SendGmesMsg(DefGmes.MES_RPR_EIJR);
        Exit;
      end;
    end
    else begin
      if (m_nStopReason <> StopByOperator) and (m_nStopReason <> StopByAlarm) then begin
        if Common.SystemInfo.UseConfirmHost and (Trim(m_Inspect.Result) <> 'PASS') then begin
          SendTestGuiDisplay(DefPocb.MSG_MODE_CONFIRM_HOST);
          Exit;
        end;
        if not Common.SystemInfo.UseGIB then SendGmesMsg(DefGmes.MES_EICR) else SendGmesMsg(DefGmes.MES_RPR_EIJR); //TBD:LENS:MES?
        Exit;
      end;
    end;
  end;
{$ELSE}
  if (DongaGmes <> nil) and Common.m_bMesOnline and (not Common.SystemInfo.UseGRR) then begin
    if Common.SystemInfo.UseEicrPassOnly then begin  //2018-12-17
      if (Trim(m_Inspect.Result) = 'PASS') then begin  //PASS만 EICR 보냄
        if not Common.SystemInfo.UseGIB then SendGmesMsg(DefGmes.MES_EICR) else SendGmesMsg(DefGmes.MES_RPR_EIJR);
        Exit;
      end else
      begin
        SendGmesMsg(DefGmes.MES_APDR);
        Exit;
      end;
    end
    else begin
      if (m_nStopReason <> StopByOperator) and (m_nStopReason <> StopByAlarm) then begin
        if Common.SystemInfo.UseConfirmHost and (Trim(m_Inspect.Result) <> 'PASS') then begin
          SendTestGuiDisplay(DefPocb.MSG_MODE_CONFIRM_HOST);
          Exit;
        end;
        if not Common.SystemInfo.UseGIB then SendGmesMsg(DefGmes.MES_EICR) else SendGmesMsg(DefGmes.MES_RPR_EIJR);
        Exit;
      end;
    end;
  end;
{$ENDIF}
  //
  SendMainGuiDisplay(DefPocb.MSG_MODE_MAKE_SUMMARY_CSV,'', DefPocb.ZONE_UNLOAD); //TBD?

  if m_bAutoPowerOff then begin
    SendStopSeq;
  end
  else begin
    if (not m_Inspect.PowerOn) then m_InsStatus := IsStop;
  end;
end;

procedure TLogic.SendStartSeq4;
begin
  if m_InsStatus <> IsUnload then Exit;

  //2019-04-18 DFS:Upload하는 조건(보상OK & Offline/Online)
  //if Common.DfsConfInfo.bUseDfs and (Trim(m_Inspect.Result) = 'PASS') then begin
  //  WorkDfs; //InspectionOK & Online & EICR응답수신
  //end;
  //
  SendMainGuiDisplay(DefPocb.MSG_MODE_MAKE_SUMMARY_CSV,'', DefPocb.ZONE_UNLOAD); //TBD?
  //
//if m_bAutoPowerOff then SendStopSeq;
  if m_bAutoPowerOff then begin  //2023-07-27
    SendStopSeq;
  end
  else begin
    if (not m_Inspect.PowerOn) then m_InsStatus := IsStop;
  end;
end;

procedure TLogic.SendStopSeq(newStopReason: TInspctionStopReason = StopNormal);
var
  i : Integer;
  nFlowSeq  : Integer;
  sFlowStep, sDebug : string;
  bRet : Boolean;
begin
	//2021-12-30 Delete!!! ClearGMesData;
	{$IFDEF SUPPORT_1CG2PANEL}
  m_SkipPocbConfirmStatus := SkipPocbConfirmNONE; //SUPPORT_1CG2PANEL
	{$ENDIF}
  //
  if (m_nStopReason = StopNone) then begin
    if ((newStopReason = StopByOperator) or (newStopReason = StopByAlarm)) and (m_InsStatus = IsCamera) then begin
    //CodeSite.Send('CH'+IntToStr(FChNo+1)+': Set CameraComm.m_bForceStop');
      if (newStopReason = StopByAlarm) then MakeTEndEvt(camRetStopByAlarm)
      else                                  MakeTEndEvt(camRetStopByOperator);
    end;
    m_nStopReason := newStopReason; // Camera로 TSTOP 송신 후에!!!
    if (m_nStopReason = StopByOperator)   then SetFlowSeqResult(m_Inspect.CurFlowSeq, DefPocb.POCB_FC_OPERATOR_STOP)  //2023-06-16
    else if (m_nStopReason = StopByAlarm) then SetFlowSeqResult(m_Inspect.CurFlowSeq, DefPocb.POCB_FC_ALARM_STOP);
  end
  else begin  //2018-12-15 (반복해서 STOP 누르는 경우 지연되어 치리되는 것 방지)
    if (not FLockThread) and (m_InsStatus <> IsStop) then begin //2019-01-23 TBD:NeedTest?
    //CodeSite.Send('CH'+IntToStr(FChNo+1)+': Already ForceStop:Countinue');
      ThreadTask( procedure begin
        Pg[Self.FPgNo].SetPowerMeasureTimer(False);
{$IFDEF PANEL_AUTO}
      //if m_bCBParaBeforeWrited then begin
        if m_Inspect.PowerOn and m_bCBParaBeforeWrited then begin //2023-0727
          nFlowSeq := DefPocb.POCB_SEQ_FINAL_CBPARA_WRITE;
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);
          sFlowStep := 'EEPROM CBPARA(After) Write';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sFlowStep+' ------');
          //
          bRet := EepromDataWrite(eepromCBParam,False{bBefore}); //USE_MODEL_PARAM_CSV
          if bRet then begin
            sDebug := sFlowStep + ' OK';
            SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_INFO);
            SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_PASS)
          end
          else begin
            sDebug := sFlowStep + ' NG';
            SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
            SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_FAIL);
          end;
        end;
{$ENDIF} //PANEL_AUTO				
        m_InsStatus := IsStop;
        m_Inspect.PowerOn := False;
        Pg[Self.FPgNo].SendPgPowerOn(0);

        SendTestGuiDisplay(DefPocb.MSG_MODE_FLOW_STOP_REPORT,'',0);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
        m_nStopReason := StopNone;
        //
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_POWER_OFF,DefPocb.SEQ_RESULT_PASS);
      end);
    end
    else begin
      CodeSite.Send('CH'+IntToStr(FChNo+1)+': Already ForceStop:WaitTaskDone');
    end;
    Exit;
  end;

  if FLockThread then begin  //TBD???

  end
  else begin
    ThreadTask( procedure begin
      Pg[Self.FPgNo].SetPowerMeasureTimer(False);
{$IFDEF PANEL_AUTO}
      if m_bCBParaBeforeWrited then begin
        nFlowSeq := DefPocb.POCB_SEQ_FINAL_CBPARA_WRITE;
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);
        sFlowStep := 'EEPROM CBPARA(After) Write';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sFlowStep+' ------');
        //
        bRet := EepromDataWrite(eepromCBParam,False{bBefore}); //USE_MODEL_PARAM_CSV
        if bRet then begin
          sDebug := sFlowStep + ' OK';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_INFO);
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_PASS)
        end
        else begin
          sDebug := sFlowStep + ' NG';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_FAIL);
        end;
      end;
{$ENDIF} //PANEL_AUTO
      m_InsStatus := IsStop;
      m_Inspect.PowerOn := False;
      Pg[Self.FPgNo].SendPgPowerOn(0);

      SendTestGuiDisplay(DefPocb.MSG_MODE_FLOW_STOP_REPORT,'',0);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
      m_nStopReason := StopNone; //2018-12-16
      //
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_POWER_OFF,DefPocb.SEQ_RESULT_PASS);
    end);
  end;
end;

// Test1Ch -> LogicPocb
procedure TLogic.StartSeqInit;             //TBD??? Seq_1: SetInit?
begin
  InitialData;
  //
  SendTestGuiDisplay(DefPocb.MSG_MODE_CH_CLEAR,'');
end;

// Test1Ch -> LogicPocb
procedure TLogic.DisplayPatCompBmp(nCompBmpIdx: Integer = 0);  //#SendDisplayDownloadBmp
begin
  if Pg[FPgNo].StatusPg in [pgForceStop, pgDisconnect] then Exit;

  ThreadTask( procedure begin
    // Display Pattern.
    Pg[Self.FPgNo].SendPgDisplayDownBmp(nCompBmpIdx);

    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Display Compensated bmp pattern');
  end);
end;

// Test1Ch/JigControl -> LogicPocb
procedure TLogic.DisplayContactPat(nIdx: Integer; sPatName : string);
var
  sDebug : string;
begin
  if Pg[FPgNo].StatusPg in [pgForceStop, pgDisconnect] then Exit;

  ThreadTask( procedure begin
    Pg[Self.FPgNo].SendPgDisplayPatNum(nIdx);
    sDebug := Format(' Manual Display Pattern : %s',[sPatName]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
  end);

end;

//******************************************************************************
// procedure/function: Sub of StartSeqXXX
//******************************************************************************


//##############################################################################
//###
//### Flow Seq
//###
//##############################################################################

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_ScanBcr: Integer; //TBD:ITOLED:FLOW_CONTROL?
begin
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_MesPchk: Integer; //TBD:ITOLED:FLOW_CONTROL?
begin
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_InitPowerOn: Integer; 	//TBD:GAGO:NEWFLOW?
var
  sDebug : string;
  dwRtn  : DWORD;
begin
{$IFDEF HAS_DIO_OUT_STAGE_LAMP}
 // if Common.SystemInfo.HasDioOutStageLamp then DongaDio.SetStageLamp(FPgNo,False{LampOff});
{$ENDIF}

  m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_INIT_POWER_ON;
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,'Power On',DefPocb.CH_STATUS_INFO);

  dwRtn := Pg[Self.FPgNo].SendPgPowerOn(DefPG.CMD_POWER_ON);
  if dwRtn <> WAIT_OBJECT_0 then begin
  	SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,'Power On',DefPocb.CH_STATUS_NG); //TBD:ITOLED?
		//
    m_InsStatus := IsStop;
		m_Inspect.PowerOn := False;
		//
		Result := DefPocb.POCB_FC_POWER_ON;
		Exit;
	end;

  m_InsStatus := IsStart; //TBD:ITOLED?
  m_Inspect.PowerOn := True;

  Result := DefPocb.POCB_FC_OK;
end;

//------------------------------------------------------------------------------
{$IFDEF SUPPORT_1CG2PANEL}
function TLogic.RunFlowSeq_ConfirmSkipPocb: Integer; 	//TBD:GAGO:NEWFLOW?
begin
	//TBD:GAGO:NEWFLOW?
end;
{$ENDIF}

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_InitCBParaWrite: Integer; 	//TBD:GAGO:NEWFLOW?
begin
	//TBD:GAGO:NEWFLOW?
end;

function TLogic.RunFlowSeq_PowerReset(nCBIdx: Integer): Integer; //0:InitPowerReset, 1:CB1, 2:CB2
var
  sCamFlow, sDebug : string;
  dwRtn  : DWORD;
  nPwrOffOnDelay, nPatNum : Integer;
begin
 	case nCBIdx of
 		1: begin
   		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB1_POWER_RESET;
    	sCamFlow := 'Camera CB1 - Power Reset';
  	end;
  	else begin
    	m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB1_POWER_RESET;
    	sCamFlow := 'Camera CB2 - Power Reset';
  	end;
  end;
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,sCamFlow,DefPocb.CH_STATUS_INFO);

  FIsOnPowerReset := True;
  try
  	//-------- Panel Power Off and Delay
  	SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
  	m_Inspect.PowerOn := False;
  	dwRtn := Pg[FPgNo].SendPgPowerOn(DefPG.CMD_POWER_OFF,True{bPowerReset}); // power off(PowerReset)

  	nPwrOffOnDelay := Common.TestModelInfo2[FChNo].PwrOffDelayMSec;
  	if nPwrOffOnDelay > 0 then begin
    	sDebug := Format('Delay %d ms',[nPwrOffOnDelay]);
    	SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    	Sleep(nPwrOffOnDelay);
  	end;
  	//-------- Panel Power On and Delay
  	SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power On');
  	m_Inspect.PowerOn := True;
  	dwRtn := Pg[FPgNo].SendPgPowerOn(DefPG.CMD_POWER_ON,True{bPowerReset}); // power on(PowerReset)

  	nPwrOffOnDelay := Common.TestModelInfo2[FChNo].PwrOnDelayMSec;
  	if nPwrOffOnDelay > 0 then begin
    	sDebug := Format('Delay %d ms',[nPwrOffOnDelay]);
    	SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    	Sleep(nPwrOffOnDelay);
  	end;

    // 2023-06-22
    nPatNum := Common.TestModelInfo2[FChNo].VerifyPatNum;
    sDebug := Format('Display Patten(Verify): %d(%s)',[nPatNum,Pg[FPgNo].CurPatGrpInfo.PatName[nPatNum]]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

    dwRtn  := Pg[Self.FPgNo].SendPgDisplayPatNum(nPatNum);
    Result := TernaryOp((dwRtn = WAIT_OBJECT_0), DefPocb.POCB_FC_OK, POCB_FC_PATTERN_DISPLAY);
    Sleep(200); //2023-06-28 TBD?
    Exit;
  finally
    FIsOnPowerReset := False;
  end;

  Result := POCB_FC_OK;
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_DispPatPowerOn: Integer;
var
  dwRtn   : DWORD;
  nPatNum : Integer;
  sDebug  : string;
begin
  m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_PAT_DISP_POWERON;

  //--------------------------------- Display Pattern (PowerOn)
  nPatNum := Common.TestModelInfo2[FChNo].PowerOnPatNum;
  sDebug := Format('Display Patten(PowerOn): %d(%s)',[nPatNum,Pg[FPgNo].CurPatGrpInfo.PatName[nPatNum]]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

  dwRtn  := Pg[Self.FPgNo].SendPgDisplayPatNum(nPatNum);
//Result := TernaryOp((dwRtn = WAIT_OBJECT_0), DefPocb.POCB_FC_OK, POCB_FC_PATTERN_DISPLAY);
  Result := DefPocb.POCB_FC_OK;
end;

//------------------------------------------------------------------------------
{$IF Defined(PANEL_AUTO)}
function TLogic.RunFlowSeq_ProcMaskBeforeCheck: Integer;
var
  sCamFlow : string;
begin
  m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_PROCMASK_BEFORE_CHECK;

  sCamFlow := 'ProcMask-Before EEPROM Check';
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,sCamFlow,DefPocb.CH_STATUS_INFO);

  //--------------------------------- ProcMask-Before Check (EEPROM)
  if (not EepromDataCheck(eepromProcMask)) then begin
		Result := DefPocb.POCB_FC_EEPROM_PROCMASK_VERIFY;
		Exit;
  end;

  Result := DefPocb.POCB_FC_OK;
end;
{$ENDIF}

//------------------------------------------------------------------------------
{$IF Defined(PANEL_AUTO)}
function TLogic.RunFlowSeq_ProcMaskBeforeWrite: Integer;
var
  sCamFlow : string;
begin
  m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_PROCMASK_BEFORE_WRITE;

 	sCamFlow := 'EEPROM ProcMask-Before Write';
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,sCamFlow,DefPocb.CH_STATUS_INFO);

  //--------------------------------- ProcMask-Before Write (EEPROM)
  if (not EepromDataWrite(eepromProcMask,False{bBefore})) then begin
		Result := DefPocb.POCB_FC_EEPROM_WRITE;
		Exit;
  end;
  Result := DefPocb.POCB_FC_OK;
end;
{$ENDIF}

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_PressStart: Integer; 	//TBD:GAGO:NEWFLOW?
begin
	//TBD:GAGO:NEWFLOW?
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_StageFwd: Integer; 	//TBD:GAGO:NEWFLOW?
begin
	//TBD:GAGO:NEWFLOW?
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_ShutterDown: Integer;
begin
	//TBD:GAGO:NEWFLOW?
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_CamProcSTART(nCamCBIdx: Integer): Integer; 	//TBD:GAGO:NEWFLOW?
var
  sCamCmd, sCamFlow : string;
  nCamRtn  : enumCamRetType;
  nCamProcWaitSec : integer;
  sCamPCPid : string;
  //
  bCamRtn : Boolean; //TBD:GAGO:NEWFLOW?
begin
	m_InsStatus := IsCamera; //2021-12-30 (Move from SendStartSeq2)  //TBD? FOLD vs AUTO?

  CameraComm.m_bForceStop[FCamNo] := False;
  CameraComm.m_bSendTSTOP[FCamNo] := False;
  CameraComm.InitCamBuf(FCamNo);

  if Trim(m_Inspect.SerialNo) = '' then m_Inspect.SerialNo := Format('EMPTYPNID%d',[FCamNo+1]);
  if Common.SystemInfo.UseGRR then
		sCamPCPid := Trim(m_Inspect.SerialNo)
  else begin
		//2021-12-23 (SerialNo -> PanelID) //2022-11-18
    if Trim(m_Inspect.SerialNo) <> Trim(m_Inspect.PanelID) then sCamPCPid := Format('%s %s',[Trim(m_Inspect.SerialNo),Trim(m_Inspect.PanelID)])
    else                                                        sCamPCPid := Trim(m_Inspect.SerialNo); //PanelID = SerialNo //2022-11-18
  end;

  CameraComm.m_sSerialNo[FCamNo] := Trim(m_Inspect.SerialNo);
  CameraComm.m_sPanelID[FCamNo]  := Trim(m_Inspect.PanelID);
  CameraComm.m_sCamNg[FCamNo]    := '';

  if Common.SystemInfo.UseGRR then begin
    m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CAM_PROC_CB1;
    //2023-06-29 IMSI-Recover!!! sCamCmd  := Format('GRRTSTART %s %s',[trim(sCamPCPid),Trim(Common.SystemInfo.TestModel[FCamNo])]);
    sCamCmd  := Format('GRRTSTART %s',[Trim(sCamPCPid)]);
    sCamFlow := 'Camera GRRTSTART';
	end
	else begin
  	case nCamCBIdx of
   		1: begin
     		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CAM_PROC_CB1;
      	//2023-06-29 IMSI-Recover!!! sCamCmd  := Format('TSTART %s %s',[Trim(sCamPCPid),Trim(Common.SystemInfo.TestModel[FCamNo])]);
        sCamCmd  := Format('TSTART %s',[Trim(sCamPCPid)]);
      	sCamFlow := 'Camera CB1 - TSTART';
    	end;

      	2: begin
     		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CAM_PROC_CB2;
      	//2023-06-29 IMSI-Recover!!! sCamCmd  := Format('TSTART %s %s',[Trim(sCamPCPid),Trim(Common.SystemInfo.TestModel[FCamNo])]);
        sCamCmd  := Format('TSTART2 %s',[Trim(sCamPCPid)]);
      	sCamFlow := 'Camera CB2 - TSTART';
    	end;

      	3: begin
     		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CAM_PROC_CB3;
      	//2023-06-29 IMSI-Recover!!! sCamCmd  := Format('TSTART %s %s',[Trim(sCamPCPid),Trim(Common.SystemInfo.TestModel[FCamNo])]);
        sCamCmd  := Format('TSTART3 %s',[Trim(sCamPCPid)]);
      	sCamFlow := 'Camera CB3 - TSTART';
    	end;

      	4: begin
     		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CAM_PROC_CB4;
      	//2023-06-29 IMSI-Recover!!! sCamCmd  := Format('TSTART %s %s',[Trim(sCamPCPid),Trim(Common.SystemInfo.TestModel[FCamNo])]);
        sCamCmd  := Format('TSTART4 %s',[Trim(sCamPCPid)]);
      	sCamFlow := 'Camera CB4 - TSTART';
    	end;

    end;
  end;
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,sCamFlow,DefPocb.CH_STATUS_INFO);

  CameraComm.m_nCurCBIdx[FChNo] := nCamCBIdx;
  if (Common.TestModelInfo2[FChNo].CamTEndWait > 0) and (Common.TestModelInfo2[FChNo].CamTEndWait <= 20) then  //TBD(<=10)?   //TBD:GAGO:NEWFLOW?
    nCamProcWaitSec := Common.TestModelInfo2[FChNo].CamTEndWait * 60
  else
    nCamProcWaitSec := 20 * 60; //by max
  bCamRtn := CameraComm.SendCmd(FCamNo,sCamCmd);



  if bCamRtn then begin
    nCamRtn := CheckMsgCamWork(nCamProcWaitSec);
    case nCamRtn of
      camRetOk              : Result := DefPocb.POCB_FC_OK;
      camRetNak             : Result := TernaryOp((nCamCBIdx = DefCam.CAM_STEP_CB1), DefPocb.POCB_FC_CAM_START_CB1_NAK, DefPocb.POCB_FC_CAM_START_CB2_NAK);
      camRetTimeout         : Result := TernaryOp((nCamCBIdx = DefCam.CAM_STEP_CB1), DefPocb.POCB_FC_CAM_START_CB1_TIMEOUT, DefPocb.POCB_FC_CAM_START_CB2_TIMEOUT);
      camRetCommErr         : Result := DefPocb.POCB_FC_CAM_COMM_NG;
      camRetTEndNg          : Result := DefPocb.POCB_FC_CAM_TEND_NG;
      camRetUnitformityNG   : Result := DefPocb.POCB_FC_CAM_TEND_UNITFORMITY_NG;
      camRetStopByAlarm     : Result := DefPocb.POCB_FC_ALARM_STOP;
      camRetStopByOperator  : Result := DefPocb.POCB_FC_OPERATOR_STOP;
      else                    Result := DefPocb.POCB_FC_CAM_COMM_NG; //TBD:GAGO?
    end;
  end
  else begin
    Result := TernaryOp((nCamCBIdx = DefCam.CAM_STEP_CB1), DefPocb.POCB_FC_CAM_START_CB1_TX_FAIL, DefPocb.POCB_FC_CAM_START_CB2_TX_FAIL);
  end;
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_CamProcCBDataFlashWrite(nCBIdx: Integer): Integer; 	//TBD:GAGO:NEWFLOW?
var
  sCamFlow : string;
begin
 	case nCBIdx of
 		1: begin
   		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB1_CBDATA_FLASH_WRITE;
    	sCamFlow := 'Camera CB1 - FLASH CBDATA Write';
  	end;

   	2: begin
   		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB2_CBDATA_FLASH_WRITE;
    	sCamFlow := 'Camera CB2 - FLASH CBDATA Write';
  	end;

   	3: begin
   		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB3_CBDATA_FLASH_WRITE;
    	sCamFlow := 'Camera CB3 - FLASH CBDATA Write';
  	end;

   	4: begin
   		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB4_CBDATA_FLASH_WRITE;
    	sCamFlow := 'Camera CB4 - FLASH CBDATA Write';
  	end;
  end;
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,sCamFlow,DefPocb.CH_STATUS_INFO);

  //--------------------------------- CBDATA Write (Flash)
  if not FlashCBDataFileWrite(Common.m_sCBDataFullName[FChNo]) then begin  	//TBD:GAGO:NEWFLOW?
    Result := DefPocb.POCB_FC_FLASH_WRITE_CBDATA;
    Exit;
  end;

  Result := POCB_FC_OK;
end;

//------------------------------------------------------------------------------
{$IF Defined(PANEL_AUTO)}
function TLogic.RunFlowSeq_CamProcAfterPUCWrite(nCBIdx: Integer): Integer;  	//TBD:GAGO:NEWFLOW?
var
  sCamFlow, sDebug : string;
begin
 	case nCBIdx of
 		1: begin
   		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB1_CBPARA_AFTERPUC_WRITE;
    	sCamFlow := 'Camera CB1 - EEPROM AfterPUC Write';
  	end;
  	else begin
    	m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB2_CBPARA_AFTERPUC_WRITE;
    	sCamFlow := 'Camera CB2 - EEPROM AfterPUC Write';
  	end;
  end;
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,sCamFlow,DefPocb.CH_STATUS_INFO);

  //--------------------------------- CBPARA-AfterPUC Write (EEPROM)
//sDebug := Format('CB%d EEPROM Write [AfterPUC]',[nCBIdx]);
//SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

  if not EepromDataWrite(eepromAfterPUC,True{bBefore:dummy}) then begin  	//TBD:GAGO:NEWFLOW?
    Result := POCB_FC_EEPROM_WRITE;
    Exit;
  end;

  Result := POCB_FC_OK;
end;
{$ENDIF}

//------------------------------------------------------------------------------
{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
function TLogic.RunFlowSeq_CamProcCBParaFlashWrite(nCBIdx: Integer): Integer;  	//TBD:GAGO:NEWFLOW?
var
  sCamFlow, sDebug : string;
begin
 	case nCBIdx of
 		1: begin
   		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB1_CBPARA_FLASH_WRITE;
    	sCamFlow := 'Camera CB1 - FLASH CBPARA Write';
  	end;

    2: begin
   		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB2_CBPARA_FLASH_WRITE;
    	sCamFlow := 'Camera CB2 - FLASH CBPARA Write';
  	end;

    3: begin
   		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB3_CBPARA_FLASH_WRITE;
    	sCamFlow := 'Camera CB3 - FLASH CBPARA Write';
  	end;

    4: begin
   		m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CB4_CBPARA_FLASH_WRITE;
    	sCamFlow := 'Camera CB4 - FLASH CBPARA Write';
  	end;
  end;
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,sCamFlow,DefPocb.CH_STATUS_INFO);

  //--------------------------------- CBPARA Write (Flash)
//sDebug := Format('CB%d Flash Write [CBPARA]',[nCBIdx]);
//SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
  if not FlashAfterPUCDataWrite(nCBIdx) then begin     	//TBD:GAGO:NEWFLOW?
    Result := POCB_FC_FLASH_WRITE_CBPARA;
    Exit;
  end;

  Result := POCB_FC_OK;
end;
{$ENDIF}

//------------------------------------------------------------------------------
{$IF Defined(PANEL_AUTO)}
function TLogic.RunFlowSeq_ProcMaskAfterWrite: Integer;  	//TBD:GAGO:NEWFLOW?
var
  sCamFlow, sDebug : string;
begin
	m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_PROCMASK_AFTER_WRITE;

 	sCamFlow := 'EEPROM ProcMask-After Write';
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,sCamFlow,DefPocb.CH_STATUS_INFO);

  //--------------------------------- ProcMask-After Write (EEPROM)
//sDebug := 'ProckMask-After EEPROM Write';
//SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
  if not EepromDataWrite(eepromProcMask,False{bBefore}) then begin  	//TBD:GAGO:NEWFLOW?
    Result := POCB_FC_EEPROM_WRITE;
    Exit;
  end;

  Result := POCB_FC_OK;
end;
{$ENDIF}

//------------------------------------------------------------------------------
{$IF Defined(PANEL_AUTO)}
function TLogic.RunFlowSeq_FinalCBParaWrite: Integer;  	//TBD:GAGO:NEWFLOW?
var
  sCamFlow, sDebug : string;
begin
	m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_FINAL_CBPARA_WRITE;

 	sCamFlow := 'EEPROM CBPARA-After Write';
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,sCamFlow,DefPocb.CH_STATUS_INFO);

  //--------------------------------- CBPARA-After Write (EEPROM)
//sDebug := 'EEPROM CBPARA-After Write';
//SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
  if not EepromDataWrite(eepromCBParam,False{bBefore}) then begin  	//TBD:GAGO:NEWFLOW?
    Result := POCB_FC_EEPROM_WRITE;
    Exit;
  end;

  Result := POCB_FC_OK;
end;
{$ENDIF}

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_CamProcEXTRA: Integer;  	//TBD:GAGO:NEWFLOW?
var
  bRtn     : Boolean;
  sCamCmd  : string;
  nCamRtn  : enumCamRetType;
  nCamProcWaitSec : Integer;
  //
  dwCamRtn : DWORD; //TBD:GAGO:NEWFLOW?
begin
  m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_CAM_PROC_EXTRA;

  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,'Camera EXTRA - RSTDONE',DefPocb.CH_STATUS_INFO);

  sCamCmd := 'RSTDONE';
	{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
  nCamProcWaitSec := 3*60;
  {$ELSE}
  nCamProcWaitSec := 5*60;   //2019-04-04 (For E2H-177: 3->5 for BMP x8)
  {$ENDIF}
  if CameraComm.SendCmd(FCamNo,sCamCmd) then begin
    nCamRtn := CheckMsgCamWork(nCamProcWaitSec);
    case nCamRtn of
      camRetOk              : Result := DefPocb.POCB_FC_OK;
      camRetNak             : Result := DefPocb.POCB_FC_CAM_START_EXTRA_NAK;
      camRetTimeout         : Result := DefPocb.POCB_FC_CAM_START_EXTRA_TIMEOUT;
      camRetCommErr         : Result := DefPocb.POCB_FC_CAM_COMM_NG;
      camRetTEndNg          : Result := DefPocb.POCB_FC_CAM_TEND_NG;
      camRetUnitformityNG   : Result := DefPocb.POCB_FC_CAM_TEND_UNITFORMITY_NG;
      camRetStopByAlarm     : Result := DefPocb.POCB_FC_ALARM_STOP;
      camRetStopByOperator  : Result := DefPocb.POCB_FC_OPERATOR_STOP;
      else                    Result := DefPocb.POCB_FC_CAM_COMM_NG; //TBD:GAGO?
    end;
  end
  else begin
    Result := DefPocb.POCB_FC_CAM_START_EXTRA_TX_FAIL;
  end;
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_PucProcEND: Integer;  	//TBD:GAGO:NEWFLOW?
var
  bRtn     : Boolean;
  sCamCmd  : string;
  nCamRtn  : integer;
  //
  i : Integer; //TBD:GAGO:NEWFLOW?
begin
  m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_PUC_PROC_END;
//SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,'PUC Process End',DefPocb.CH_STATUS_INFO);

	if (Common.TestModelInfo2[FChNo].JudgeCount > 0) or Common.TestModelInfo2[FChNo].UsePucImage then begin
    for i := 0 to DefPocb.UNIFORMITY_PATTERN_MAX do begin
      m_Inspect.IsGRR               := CameraComm.m_csvCamData[FCamNo].IsGRR;
      m_Inspect.UniformityPost[i]   := CameraComm.m_csvCamData[FCamNo].UniformityPost[i];
      m_Inspect.UniformityPre[i]    := CameraComm.m_csvCamData[FCamNo].UniformityPre[i];
      m_Inspect.UniformityResult[i] := CameraComm.m_csvCamData[FCamNo].UniformityResult[i];
      m_Inspect.HasUniformityPoint  := CameraComm.m_csvCamData[FCamNo].HasUniformityPoint;
      if '' <> CameraComm.m_csvCamData[FCamNo].UniformityPointsPost[i] then
        m_Inspect.UniformityPointsPost[i] := CameraComm.m_csvCamData[FCamNo].UniformityPointsPost[i];
      if '' <> CameraComm.m_csvCamData[FCamNo].UniformityPointsPre[i] then
        m_Inspect.UniformityPointsPre[i]  := CameraComm.m_csvCamData[FCamNo].UniformityPointsPre[i];
    end;
  end;

  //TBD:GAGI:NEWFLOW?

  Result := DefPocb.POCB_FC_OK;
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_DispPatVerify: Integer;  	//TBD:GAGO:NEWFLOW?
var
  dwRtn   : DWORD;
  nPatNum : Integer;
  sDebug  : string;
begin
	//TBD:ITOLED:FLOW_CONTROL?
  m_Inspect.CurFlowSeq := DefPocb.POCB_SEQ_PAT_DISP_VERIFY;

  nPatNum := Common.TestModelInfo2[FChNo].VerifyPatNum;
  sDebug := Format('Display Patten(Verify): %d(%s)',[nPatNum,Pg[FPgNo].CurPatGrpInfo.PatName[nPatNum]]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

  dwRtn  := Pg[Self.FPgNo].SendPgDisplayPatNum(nPatNum);
//Result := TernaryOp((dwRtn = WAIT_OBJECT_0), DefPocb.POCB_FC_OK, POCB_FC_PATTERN_DISPLAY);
  Result := DefPocb.POCB_FC_OK;
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_StageBwd: Integer;	//TBD:GAGO:NEWFLOW?
begin
	//TBD:GAGO:NEWFLOW?
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_MesEICR: Integer; 	//TBD:GAGO:NEWFLOW?
begin
	//TBD:GAGO:NEWFLOW?
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_DfsUpload: Integer; 	//TBD:GAGO:NEWFLOW?
begin
	//TBD:GAGO:NEWFLOW?
end;

//------------------------------------------------------------------------------
function TLogic.RunFlowSeq_PowerOff: Integer;	//TBD:GAGO:NEWFLOW?
begin
	//TBD:GAGO:NEWFLOW?
end;

//==============================================================================
// procedure/function:
//
function TLogic.RunFlowSeq(nFlowSeq: Integer): Integer;
var
  sFlowSeq, sDebug : string;
  nFlowSeqRtn : Integer;
  //
  timeSeqStart, timeSeqEnd : TDateTime;
  nTactMsec : Integer;
  sTactMsec : string;
begin
  nFlowSeqRtn  := DefPocb.POCB_FC_CAM_COMM_NG;
  timeSeqStart := Now;

	if not (nFlowSeq in [1..DefPocb.POCB_SEQ_MAX]) then exit;

	sFlowSeq := Common.PocbFlowSeqStr[nFlowSeq];
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'[SEQ] '+sFlowSeq+' START ------------');
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);

	//
	case nFlowSeq of
		DefPocb.POCB_SEQ_SCAN_BCR             		: ; //TBD:NEW_FLOW?
		DefPocb.POCB_SEQ_MES_PCHK             		: ; //TBD:NEW_FLOW?
 		DefPocb.POCB_SEQ_INIT_POWER_ON        		: nFlowSeqRtn := RunFlowSeq_InitPowerOn;
  	{$IFDEF SUPPORT_1CG2PANEL}
  	DefPocb.POCB_SEQ_CONFIRM_SKIP_POCB    		: nFlowSeqRtn := RunFlowSeq_ConfirmSkipPocb;
  	{$ENDIF}
		DefPocb.POCB_SEQ_INIT_CBPARA_WRITE    		: nFlowSeqRtn := RunFlowSeq_InitCBParaWrite;
		DefPocb.POCB_SEQ_INIT_POWER_RESET     		: nFlowSeqRtn := RunFlowSeq_PowerReset(DefCam.CAM_STEP_NONE); //InitPowerReset
		DefPocb.POCB_SEQ_PAT_DISP_POWERON     		: nFlowSeqRtn := RunFlowSeq_DispPatPowerOn;
		{$IF Defined(PANEL_AUTO)}
		DefPocb.POCB_SEQ_PROCMASK_BEFORE_CHECK		: nFlowSeqRtn := RunFlowSeq_ProcMaskBeforeCheck;
		DefPocb.POCB_SEQ_PROCMASK_BEFORE_WRITE		: nFlowSeqRtn := RunFlowSeq_ProcMaskBeforeWrite;
  	{$ENDIF}
		DefPocb.POCB_SEQ_PRESS_START          		: ; //TBD:NEW_FLOW?
		DefPocb.POCB_SEQ_STAGE_FWD            		: ; //TBD:NEW_FLOW?
		DefPocb.POCB_SEQ_CAM_PROC_CB1         		: nFlowSeqRtn := RunFlowSeq_CamProcSTART(DefCam.CAM_STEP_CB1);
		DefPocb.POCB_SEQ_CB1_CBDATA_RCV       		: ; //TBD:NEW_FLOW?
		DefPocb.POCB_SEQ_CB1_CBDATA_FLASH_WRITE 	: nFlowSeqRtn := RunFlowSeq_CamProcCBDataFlashWrite(DefCam.CAM_STEP_CB1);
		{$IF Defined(PANEL_AUTO)}
		DefPocb.POCB_SEQ_CB1_CBPARA_AFTERPUC_WRITE: nFlowSeqRtn := RunFlowSeq_CamProcAfterPUCWrite(DefCam.CAM_STEP_CB1);
		{$ELSEIF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
		DefPocb.POCB_SEQ_CB1_CBPARA_FLASH_WRITE		: nFlowSeqRtn := RunFlowSeq_CamProcCBParaFlashWrite(DefCam.CAM_STEP_CB1);
  	{$ENDIF}
		DefPocb.POCB_SEQ_CB1_POWER_RESET     			: nFlowSeqRtn := RunFlowSeq_PowerReset(DefCam.CAM_STEP_CB1);
		{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
		DefPocb.POCB_SEQ_CAM_PROC_CB2         		: nFlowSeqRtn := RunFlowSeq_CamProcSTART(DefCam.CAM_STEP_CB2); // CB2
		DefPocb.POCB_SEQ_CB2_CBDATA_RCV       		: ; //TBD:NEW_FLOW?
		DefPocb.POCB_SEQ_CB2_CBDATA_FLASH_WRITE 	: nFlowSeqRtn := RunFlowSeq_CamProcCBDataFlashWrite(DefCam.CAM_STEP_CB2);
		DefPocb.POCB_SEQ_CB2_CBPARA_FLASH_WRITE		: nFlowSeqRtn := RunFlowSeq_CamProcCBParaFlashWrite(DefCam.CAM_STEP_CB2);
		DefPocb.POCB_SEQ_CB2_POWER_RESET     			: nFlowSeqRtn := RunFlowSeq_PowerReset(DefCam.CAM_STEP_CB2);

    DefPocb.POCB_SEQ_CAM_PROC_CB3         		: nFlowSeqRtn := RunFlowSeq_CamProcSTART(DefCam.CAM_STEP_CB3); // CB3
		DefPocb.POCB_SEQ_CB3_CBDATA_RCV       		: ; //TBD:NEW_FLOW?
		DefPocb.POCB_SEQ_CB3_CBDATA_FLASH_WRITE 	: nFlowSeqRtn := RunFlowSeq_CamProcCBDataFlashWrite(DefCam.CAM_STEP_CB3);
		DefPocb.POCB_SEQ_CB3_CBPARA_FLASH_WRITE		: nFlowSeqRtn := RunFlowSeq_CamProcCBParaFlashWrite(DefCam.CAM_STEP_CB3);
		DefPocb.POCB_SEQ_CB3_POWER_RESET     			: nFlowSeqRtn := RunFlowSeq_PowerReset(DefCam.CAM_STEP_CB3);

    DefPocb.POCB_SEQ_CAM_PROC_CB4         		: nFlowSeqRtn := RunFlowSeq_CamProcSTART(DefCam.CAM_STEP_CB4); // CB4
		DefPocb.POCB_SEQ_CB4_CBDATA_RCV       		: ; //TBD:NEW_FLOW?
		DefPocb.POCB_SEQ_CB4_CBDATA_FLASH_WRITE 	: nFlowSeqRtn := RunFlowSeq_CamProcCBDataFlashWrite(DefCam.CAM_STEP_CB4);
		DefPocb.POCB_SEQ_CB4_CBPARA_FLASH_WRITE		: nFlowSeqRtn := RunFlowSeq_CamProcCBParaFlashWrite(DefCam.CAM_STEP_CB4);
		DefPocb.POCB_SEQ_CB4_POWER_RESET     			: nFlowSeqRtn := RunFlowSeq_PowerReset(DefCam.CAM_STEP_CB4);
  	{$ENDIF}
		DefPocb.POCB_SEQ_CAM_PROC_EXTRA       		: nFlowSeqRtn := RunFlowSeq_CamProcEXTRA;
		{$IF Defined(PANEL_AUTO)}
		DefPocb.POCB_SEQ_PROCMASK_AFTER_WRITE	    : nFlowSeqRtn := RunFlowSeq_ProcMaskAfterWrite;
		DefPocb.POCB_SEQ_FINAL_CBPARA_WRITE    		: nFlowSeqRtn := RunFlowSeq_FinalCBParaWrite;
  	{$ENDIF}
		DefPocb.POCB_SEQ_PUC_PROC_END             : nFlowSeqRtn := RunFlowSeq_PucProcEND;
		DefPocb.POCB_SEQ_PAT_DISP_VERIFY    			: nFlowSeqRtn := RunFlowSeq_DispPatVerify;
		DefPocb.POCB_SEQ_STAGE_BWD            		: ; //TBD:NEW_FLOW?
		DefPocb.POCB_SEQ_MES_EICR             		: ; //TBD:NEW_FLOW?
		DefPocb.POCB_SEQ_POWER_OFF            		: ; //TBD:NEW_FLOW?
		else exit;
	end;
  Result := nFlowSeqRtn;

  timeSeqEnd := Now;
  nTactMsec  := MilliSecondsBetween(timeSeqStart, timeSeqEnd);
  sTactMsec  := Format('(%d.',[(nTactMsec div 1000)]) + Format('%.*d sec)',[3,(nTactMsec mod 1000)]); //ss.zzz
	//------------------
  if nFlowSeqRtn = DefPocb.POCB_FC_OK then begin
		sDebug := sFlowSeq + ' OK ' + sTactMsec;
  	SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'[SEQ] '+sDebug);
  	SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq, DefPocb.SEQ_RESULT_PASS);
	end
	else begin
		sDebug := sFlowSeq + ' NG ' + sTactMsec;
  	SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'[SEQ] '+sDebug, DefPocb.LOG_TYPE_NG);
  	SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq, DefPocb.SEQ_RESULT_FAIL);
	end;

  SetFlowSeqResult(nFlowSeq, nFlowSeqRtn);
end;

procedure TLogic.SetFlowSeqResult(nFlowSeq: Integer; nFlowSeqRtn: Integer);
var
  sFailMsg : string;
  // for TEND
  slstData : TStringList;
  nCamNgCode : Integer;
  bIsDefinedCamNgCode : Boolean;
begin
	sFailMsg := '';

  if (nFlowSeqRtn <> POCB_FC_OK) and (m_Inspect.FailCode = POCB_FC_OK) then
    m_Inspect.FailCode := nFlowSeqRtn; //2023-06-14

  case nFlowSeqRtn of
    POCB_FC_OK : begin
      if nFlowSeq = DefPocb.POCB_SEQ_PUC_PROC_END then begin
        SetMesResultInfo(-1, ''{Fail_Message}, 'PASS'{Result}, ''{DefectCode}, ''{DefectName}, ''{DefectMesCode}, ''{Rwk});  //TBD:GAFO:NEWFLOW?
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,'Compensation OK',DefPocb.SEQ_RESULT_PASS);
      end;
    end;

    POCB_FC_POWER_ON : begin
      sFailMsg := 'Power ON NG';
      SetMesResultInfo(1, sFailMsg, 'Fail', 'PD01', sFailMsg, DefGmes.POCB_MESCODE_PD01_SUMMARY, DefGmes.POCB_MESCODE_PD01_RWK); //TBD:GAFO:NEWFLOW?
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;

    POCB_FC_OPERATOR_STOP : begin
      if (m_InsStatus = IsCamera) then begin
        sFailMsg := 'OPERATOR STOP';
        SetMesResultInfo(2, sFailMsg, 'Fail', 'PD02', sFailMsg, DefGmes.POCB_MESCODE_PD02_SUMMARY, DefGmes.POCB_MESCODE_PD02_RWK); //TBD:GAFO:NEWFLOW?
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
      end;
    end;

    POCB_FC_ALARM_STOP : begin
      sFailMsg := 'ALARM STOP';
      SetMesResultInfo(3, sFailMsg, 'Fail', 'PD03', sFailMsg, DefGmes.POCB_MESCODE_PD03_SUMMARY, DefGmes.POCB_MESCODE_PD03_RWK); //TBD:GAFO:NEWFLOW?
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;

    POCB_FC_PATTERN_DISPLAY: begin
      sFailMsg := 'Pattern Display NG';
      SetMesResultInfo(12, sFailMsg, 'Fail', 'PD12', sFailMsg, DefGmes.POCB_MESCODE_PD12_SUMMARY, DefGmes.POCB_MESCODE_PD12_RWK); //TBD:GAFO:NEWFLOW? AUTO(PD12: Pattern On Fail NG)
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;

    POCB_FC_PATTERN_BMP_DOWN: begin
      sFailMsg := 'Pattern(BMP) Display NG';
      SetMesResultInfo(12, sFailMsg, 'Fail', 'PD12', sFailMsg, DefGmes.POCB_MESCODE_PD12_SUMMARY, DefGmes.POCB_MESCODE_PD12_RWK); //TBD:GAFO:NEWFLOW? AUTO(PD12: Pattern On Fail NG)
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;

    // EEPROM
    POCB_FC_EEPROM_READ,
    POCB_FC_EEPROM_WRITE : begin
      sFailMsg := 'EEPROM Read/Write NG';
      SetMesResultInfo(19, sFailMsg, 'Fail', 'PD19', sFailMsg, DefGmes.POCB_MESCODE_PD19_SUMMARY, DefGmes.POCB_MESCODE_PD19_RWK); //AUTO(EEPROM WRITE NG) //TBD:GAFO:NEWFLOW?
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;
    POCB_FC_EEPROM_CBPARA_VERIFY : begin
      sFailMsg := 'EEPROM CBPARA Verify NG';
      SetMesResultInfo(19, sFailMsg, 'Fail', 'PD19', sFailMsg, DefGmes.POCB_MESCODE_PD19_SUMMARY, DefGmes.POCB_MESCODE_PD19_RWK); //AUTO(EEPROM WRITE NG) //TBD:GAFO:NEWFLOW?
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;
    POCB_FC_EEPROM_PROCMASK_VERIFY : begin
      sFailMsg := 'EEPROM ProcMask Verify NG';
      SetMesResultInfo(22, sFailMsg, 'Fail', 'PD22', sFailMsg, DefGmes.POCB_MESCODE_PD22_SUMMARY, DefGmes.POCB_MESCODE_PD22_RWK); //AUTO(PD22: GB Final NG)
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;

    // TCON
    POCB_FC_TCON_READ,
    POCB_FC_TCON_WRITE : begin
      sFailMsg := 'TCON Read/Write NG';
      SetMesResultInfo(19, sFailMsg, 'Fail', 'PD19', sFailMsg, DefGmes.POCB_MESCODE_PD06_SUMMARY, DefGmes.POCB_MESCODE_PD19_RWK); //AUTO(EEPROM WRITE NG) //TBD:GAFO:NEWFLOW?
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;
    POCB_FC_TCON_PARA_VERIFY : begin
      sFailMsg := 'TCON CBPARA Verify NG';
      SetMesResultInfo(19, sFailMsg, 'Fail', 'PD19', sFailMsg, DefGmes.POCB_MESCODE_PD07_SUMMARY, DefGmes.POCB_MESCODE_PD19_RWK); //AUTO(EEPROM WRITE NG) //TBD:GAFO:NEWFLOW?
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;

    // FLASH
    POCB_FC_FLASH_READ : begin
      sFailMsg := 'FLASH Read NG';
      SetMesResultInfo(18, sFailMsg, 'Fail', 'PD18', sFailMsg, DefGmes.POCB_MESCODE_PD18_SUMMARY, DefGmes.POCB_MESCODE_PD18_RWK); //AUTO(Flash Memory write NG) //TBD:GAGO:NEWFLOW?
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;
    POCB_FC_FLASH_WRITE_CBDATA,
    POCB_FC_FLASH_WRITE_CBPARA : begin
      sFailMsg := 'FLASH Write NG';
      SetMesResultInfo(18, sFailMsg, 'Fail', 'PD18', sFailMsg, DefGmes.POCB_MESCODE_PD18_SUMMARY, DefGmes.POCB_MESCODE_PD18_RWK); //AUTO(Flash Memory write NG)
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;

    // CameraPC
    POCB_FC_CAM_COMM_NG : begin //2022-08-26
      sFailMsg := 'Camera Communication NG';
      SetMesResultInfo(17, sFailMsg, 'Fail', 'PD25', sFailMsg, DefGmes.POCB_MESCODE_PD17_SUMMARY, DefGmes.POCB_MESCODE_PD17_RWK); //TBD:GAFO:NEWFLOW? AUTO(PD17: Communication NG)
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
    end;

    POCB_FC_CAM_START_CB1_NAK,
    POCB_FC_CAM_START_CB1_TX_FAIL : begin
      sFailMsg := 'CB1 START Process NG';
      SetMesResultInfo(2, sFailMsg, 'Fail', 'PD02', sFailMsg, DefGmes.POCB_MESCODE_PD02_SUMMARY, DefGmes.POCB_MESCODE_PD02_RWK); //AUTO(PD02: START DPC NG)
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
      //SendMainGuiDisplay(DefPocb.MSG_MODE_SEND_CAM_TSTOP); //TBD:ITOLED?  //TBD:GAFO:NEWFLOW?
		end;
    POCB_FC_CAM_START_CB1_TIMEOUT : begin
      sFailMsg := 'CB1 START Process Timeout';
      SetMesResultInfo(2, sFailMsg, 'Fail', 'PD03', sFailMsg, DefGmes.POCB_MESCODE_PD03_SUMMARY, DefGmes.POCB_MESCODE_PD03_RWK); //AUTO(PD03: No Response from DPC NG)
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
      //SendMainGuiDisplay(DefPocb.MSG_MODE_SEND_CAM_TSTOP); //TBD:ITOLED?  //TBD:GAFO:NEWFLOW?
		end;

    POCB_FC_CAM_START_CB2_NAK,
    POCB_FC_CAM_START_CB2_TX_FAIL : begin
      sFailMsg := 'CB2 START Process NG';
      SetMesResultInfo(2, sFailMsg, 'Fail', 'PD02', sFailMsg, DefGmes.POCB_MESCODE_PD02_SUMMARY, DefGmes.POCB_MESCODE_PD02_RWK); //AUTO(PD02: START DPC NG)
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
      //SendMainGuiDisplay(DefPocb.MSG_MODE_SEND_CAM_TSTOP); //TBD:ITOLED?  //TBD:GAFO:NEWFLOW?
		end;
    POCB_FC_CAM_START_CB2_TIMEOUT : begin
      sFailMsg := 'CB2 START Process Timeout';
      SetMesResultInfo(2, sFailMsg, 'Fail', 'PD03', sFailMsg, DefGmes.POCB_MESCODE_PD03_SUMMARY, DefGmes.POCB_MESCODE_PD03_RWK); //AUTO(PD03: No Response from DPC NG)
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
      //SendMainGuiDisplay(DefPocb.MSG_MODE_SEND_CAM_TSTOP); //TBD:ITOLED?  //TBD:GAFO:NEWFLOW?
		end;

    POCB_FC_CAM_START_EXTRA_NAK,
    POCB_FC_CAM_START_EXTRA_TX_FAIL : begin
      sFailMsg := 'EXTRA RSTDONE Process NG'; //TBD:GAFO:NEWFLOW?
      SetMesResultInfo(5, sFailMsg, 'Fail', 'PD05', sFailMsg, DefGmes.POCB_MESCODE_PD05_SUMMARY, DefGmes.POCB_MESCODE_PD05_RWK); //AUTO(PD05: RSTDONE NG)
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
		end;
    POCB_FC_CAM_START_EXTRA_TIMEOUT : begin
      sFailMsg := 'EXTRA RSTDONE Process Timeout'; //TBD:GAFO:NEWFLOW?
      SetMesResultInfo(5, sFailMsg, 'Fail', 'PD05', sFailMsg, DefGmes.POCB_MESCODE_PD05_SUMMARY, DefGmes.POCB_MESCODE_PD05_RWK); //AUTO(PD05: RSTDONE NG)
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sFailMsg,DefPocb.SEQ_RESULT_FAIL);
      //SendMainGuiDisplay(DefPocb.MSG_MODE_SEND_CAM_TSTOP); //TBD:ITOLED?   //TBD:GAFO:NEWFLOW?
    end;

    POCB_FC_CAM_TEND_NG : begin
      sFailMsg := CameraComm.m_sCamNg[FCamNo];
      m_Inspect.Fail_Message := sFailMsg;
      // SetCamNgCodeToMesCode from m_sCamNg
      bIsDefinedCamNgCode := False;
      slstData:= TStringList.Create;
      try
        if (Length(sFailMsg) >= 1) then begin
          ExtractStrings([' '],[],PChar(sFailMsg), slstData);
          nCamNgCode := StrToIntDef(slstData[0],0); // 0: CamNgCode, 1~: String
          if (nCamNgCode > 0) and (nCamNgCode < Length(Common.m_Dpc2GpcNgCodes)) and (Common.m_Dpc2GpcNgCodes[nCamNgCode].DefectCode <> '') then begin
            m_Inspect.DefectCode    := Common.m_Dpc2GpcNgCodes[nCamNgCode].DefectCode;
            m_Inspect.DefectName    := Common.m_Dpc2GpcNgCodes[nCamNgCode].DefectName;
            m_Inspect.DefectMesCode := Common.m_Dpc2GpcNgCodes[nCamNgCode].MesCodeSummary;
            if DongaGmes <> nil then Common.MesData[FChNo].Rwk := Common.m_Dpc2GpcNgCodes[nCamNgCode].MesCodeRwk;
            bIsDefinedCamNgCode := True;
          end;
        end;
      finally
        slstData.Free;
      end;
      //
      if (not bIsDefinedCamNgCode) then begin // Set to default (DPC WORK STOP NG) if undefined CamNgCode
        m_Inspect.DefectCode    := 'PD04';
        m_Inspect.DefectName    := 'DPC WORK STOP NG';
        m_Inspect.DefectMesCode := DefGmes.POCB_MESCODE_PD04_SUMMARY;
        if DongaGmes <> nil then Common.MesData[FChNo].Rwk := DefGmes.POCB_MESCODE_PD04_RWK;
      end;
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,'TEND (' + sFailMsg + ')',DefPocb.SEQ_RESULT_FAIL);
    end;

    POCB_FC_CAM_TEND_UNITFORMITY_NG : begin
    //if (Common.TestModelInfo2[FChNo].JudgeCount > 0) then begin
        sFailMsg := 'Uniformity NG';
        SetMesResultInfo(16, sFailMsg, 'Fail', 'PD16', sFailMsg, DefGmes.POCB_MESCODE_PD16_SUMMARY, DefGmes.POCB_MESCODE_PD16_RWK);
    //end
    //else begin
    //  sFailMsg := 'PUC Image Save NG';
    //  SetMesResultInfo(16, sFailMsg, 'Fail', 'PD04', sFailMsg, DefGmes.POCB_MESCODE_PD16_SUMMARY, DefGmes.POCB_MESCODE_PD16_RWK); //TBD:GAGO?
    //end;
    end;

    else begin
      //TBD:ITOLED?
    end;
  end;
end;

//##############################################################################
//###
//###
//###
//##############################################################################

//==============================================================================
// procedure/function:
//
//TBD:GAGO:NEWFLOW? procedure TLogic.CamProcess(bMaintCamAutoTest: Boolean = False);
procedure TLogic.CamProcess; //TBD:GAGO:NEWFLOW?
var
  nAgingLoopCnt   : Integer;
  nCamFlowCBIdx   : Integer;
  sRetMsg, sDebug, sFlowStep : string;
  bRet : Boolean;
  nFlowSeq : Integer;
begin

  try

		m_InsStatus := IsCamera; //2021-12-30 (Move from SendStartSeq2) //TBD:ITOLED? FoldPOCB?
		CameraComm.m_bIsOnCamFlow[FChNo] := False;
		
    SendTestGuiDisplay(DefPocb.MSG_MODE_SHOW_READY_TO_TURN,'',1);
    SendTestGuiDisplay(DefPocb.MSG_MODE_UNIT_TT_START,'',0);
  //TBD:NEW_FLOW?	SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,'Camera Process',DefPocb.CH_STATUS_INFO); //2018-12-14

	if (m_nStopReason = StopByOperator) or (m_nStopReason = StopByAlarm) then Exit;

{$IFDEF SUPPORT_1CG2PANEL}
  if Common.SystemInfo.UseAssyPOCB and Common.SystemInfo.UseSkipPocbConfirm and (m_SkipPocbConfirmStatus = SkipPocbConfirmSKIP) then begin  //2022-06-XX
    //
    CameraComm.m_bCamZoneDone[FChNo] := True;
    // Power Off
		//...TBD:NEW_FLOW? ...start
    Pg[Self.FPgNo].SetPowerMeasureTimer(False);
    m_Inspect.PowerOn := False;
    Pg[Self.FPgNo].SendPgPowerOn(0);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_POWER_OFF,DefPocb.SEQ_RESULT_PASS);
		//...TBD:NEW_FLOW? ...end
    Exit;
  end;
{$ENDIF}
	if (m_nStopReason = StopByOperator) or (m_nStopReason = StopByAlarm) then Exit;

  //
  if Pg[FPgNo].StatusPg in [pgForceStop, pgDisconnect] then begin
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Stop Camera Process (PG Status NG)');
    CameraComm.m_bCamZoneDone[FChNo] := True;
    {$IFDEF SUPPORT_1CG2PANEL}
    if not Common.SystemInfo.UseAssyPOCB then begin
    {$ENDIF}
      DongaDio.SetShutter(Self.FJigNo, ShutterState.UP);
    {$IFDEF SUPPORT_1CG2PANEL}
    end
    else begin
      if CameraComm.m_bCamZoneDone[DefPocb.CH_1] and CameraComm.m_bCamZoneDone[DefPocb.CH_2] then begin  //A2CHv3:ASSYPOCB:FLOW
        DongaDio.SetShutter(Self.FJigNo, ShutterState.UP);
      end;
    end;
    {$ENDIF} //SUPPORT_1CG2PANEL
  //m_InsStatus := IsStop;
    Exit;
  end;

  {$IFDEF SUPPORT_1CG2PANEL}
  if Common.SystemInfo.UseAssyPOCB then begin
    if (FJigNo = DefPocb.CH_1) then begin  //A2CHv3:ASSY-POCB:FLOW
      if (Logic[DefPocb.CH_2].m_SkipPocbConfirmStatus <> SkipPocbConfirmSKIP) then begin  //2022-06-XX
        sDebug := Format('Delay %d ms',[500]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
        Sleep(500);
      end;
    end
    else begin
      if (Logic[DefPocb.CH_1].m_SkipPocbConfirmStatus <> SkipPocbConfirmSKIP) then begin  //2022-06-XX
        Pg[FPgNo].SendPgDisplayOnOff(False); //Off
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Display Off');
      end;
    end;
  end;
  {$ENDIF} //SUPPORT_1CG2PANEL

  Pg[FPgNo].SetCyclicTimerSpi(False{bEnable});

  m_Inspect.RtyCount := 0;
{$IFDEF REF_ITOLED_POCB}
  for i := 0 to DefCam.UNIFORMITY_PATTERN_MAX do //TBD:GAGO:NEWFLOW?
    m_Inspect.UniformRet[i] := '';
{$ENDIF}

//try

{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
  	// Aging
  	if (not Common.TestModelInfo2[FChNo].UseExLightFlow) then begin //2022-08-24 EXLIGHT_FLOW
    	if (Common.TestModelInfo2[FChNo].PowerOnAgingSec > 0) and (m_Inspect.PowerOnAgingRemainSec > 0) then begin  //2020-12-29
     		nAgingLoopCnt := (Common.TestModelInfo2[FChNo].PowerOnAgingSec - 4) * 5; //-4:StageFwd, *5 (200ms->1sec)
      	while (m_Inspect.PowerOnAgingRemainSec > 0) and (nAgingLoopCnt > 0) do begin
        	if (m_nStopReason = StopByOperator) or (m_nStopReason = StopByAlarm) then Exit;
        	if ((nAgingLoopCnt mod 5) = 0) then begin
          	sDebug := Format('Aging (%d)',[m_Inspect.PowerOnAgingRemainSec]);
          	SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,sDebug,DefPocb.CH_STATUS_INFO);
        	end;
        	Sleep(200);
        	Dec(nAgingLoopCnt);
      	end;
    	end;
  	end;
{$ENDIF}

    //--------------------------------------------------------------------- CAM_PROC_XXX
    CameraComm.m_bIsOnCamFlow[FChNo] := True; //!!!

    for nCamFlowCBIdx := DefCam.CAM_STEP_CB1 to Common.TestModelInfo2[FChNo].CamCBCount do begin

      //---------------------------------------------------------- CAM_PROC_CB1|CAM_PROC_CB2
      case nCamFlowCBIdx of
        1:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CAM_PROC_CB1);
        2:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CAM_PROC_CB2);
        3:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CAM_PROC_CB3);
        4:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CAM_PROC_CB4);
      end;
      if m_Inspect.FailCode <> DefPocb.POCB_FC_OK then Exit;

      //---------------------------------------------------------- CBDATA Flash Write
			{$IF Defined(PANEL_AUTO) and (not Defined(POCB_ATO))}
			if (Common.SystemInfo.UseGIB and Common.TestModelInfo2[FChNo].EnableFlashWriteCBData)
				  or Common.TestModelInfo2[FChNo].UsePucOnOff
          or Common.TestModelInfo2[FChNo].UsePucImage then begin
      {$ENDIF}
       	case nCamFlowCBIdx of
        	1:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB1_CBDATA_FLASH_WRITE);
          2:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB2_CBDATA_FLASH_WRITE);
          3:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB3_CBDATA_FLASH_WRITE);
          4:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB4_CBDATA_FLASH_WRITE);
      	end;
	    	if m_Inspect.FailCode <> DefPocb.POCB_FC_OK then Exit;
  		{$IF Defined(PANEL_AUTO) and (not Defined(POCB_ATO))}
			end;
			{$ENDIF}

      //---------------------------------------------------------- (PANEL_AUTO) AfterPUC EEPROM Write
			{$IF Defined(PANEL_AUTO)}
        {$IF (not Defined(POCB_ATO))}
			if (Common.SystemInfo.UseGIB and Common.TestModelInfo2[FChNo].EnableFlashWriteCBData)
				  or Common.TestModelInfo2[FChNo].UsePucOnOff
          or Common.TestModelInfo2[FChNo].UsePucImage then begin
  			{$ENDIF}
      	case nCamFlowCBIdx of
        	1:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB1_CBPARA_AFTERPUC_WRITE);
        	else m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB2_CBPARA_AFTERPUC_WRITE);
      	end;
	    	if m_Inspect.FailCode <> DefPocb.POCB_FC_OK then Exit;
        {$IF (not Defined(POCB_ATO))}
			end;
  			{$ENDIF}
			{$ENDIF}

      //---------------------------------------------------------- (PANEL_FOLD|PANEL_GAGO) CBPARA Flash Write
			{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
      case nCamFlowCBIdx of
        	1:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB1_CBPARA_FLASH_WRITE);
          2:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB2_CBPARA_FLASH_WRITE);
          3:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB3_CBPARA_FLASH_WRITE);
          4:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB4_CBPARA_FLASH_WRITE);
      end;
	    if m_Inspect.FailCode <> DefPocb.POCB_FC_OK then Exit;
			{$ENDIF}

      //---------------------------------------------------------- Power Reset
      case nCamFlowCBIdx of
        1:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB1_POWER_RESET);
        2:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB2_POWER_RESET);
        3:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB3_POWER_RESET);
        4:   m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CB4_POWER_RESET);
      end;
	    if m_Inspect.FailCode <> DefPocb.POCB_FC_OK then Exit;
    end;

    //--------------------------------------------------------------------- GPC->DPC: RSTDONE
  //if Common.TestModelInfo[FChNo].FLOW.UseCamExtraProc then begin
 		if (Common.TestModelInfo2[FChNo].JudgeCount > 0) or Common.TestModelInfo2[FChNo].UsePucImage then begin
        m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_CAM_PROC_EXTRA);
        if m_Inspect.FailCode <> DefPocb.POCB_FC_OK then Exit;
    end;

    CameraComm.m_bIsOnCamFlow[FChNo] := False; //!!!

		{$IF Defined(PANEL_AUTO)}
    //---------------------------------------------------------- (PANEL_AUTO) ProcMask EEPROM Write
		if (not Common.SystemInfo.UseGRR) and
       (Common.TestModelInfo2[FChNo].EnableProcMask and (Common.m_bMesOnline or (not Common.m_bPmModeProcMaskSkip)) {and (Trim(m_Inspect.Result) = 'PASS')}) then begin //2023-09-20 1) EnableProcMask(always True) 2) Skip if PmMode & ProcMaskSkip(by MainGUI checkbox)
      m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_PROCMASK_AFTER_WRITE);
    end;
	  if m_Inspect.FailCode <> DefPocb.POCB_FC_OK then Exit;

    //---------------------------------------------------------- (PANEL_AUTO) EEPROM CBPARA(After) Write
  //if m_bCBParaBeforeWrited then begin
      m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_FINAL_CBPARA_WRITE);
  	  if m_Inspect.FailCode <> DefPocb.POCB_FC_OK then Exit;
  //end;
		{$ENDIF}

    //--------------------------------------------------------------------- END  //TBD:ITOLED?
    m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_PUC_PROC_END); // To save Uniformaity Valuse for Summary
    if m_Inspect.FailCode <> DefPocb.POCB_FC_OK then Exit;

    //--------------------------------- Display Pattern(After CB)
    m_Inspect.FailCode := Logic[FChNo].RunFlowSeq(DefPocb.POCB_SEQ_PAT_DISP_VERIFY);
    if m_Inspect.FailCode <> DefPocb.POCB_FC_OK then Exit;

  finally

    if (m_Inspect.FailCode = DefPocb.POCB_FC_OK) then begin //2023-06-16 TBD:GAGO:NEWFLOW?
      if (m_nStopReason = StopByOperator)   then SetFlowSeqResult(m_Inspect.CurFlowSeq, DefPocb.POCB_FC_OPERATOR_STOP)
      else if (m_nStopReason = StopByAlarm) then SetFlowSeqResult(m_Inspect.CurFlowSeq, DefPocb.POCB_FC_ALARM_STOP);
    end;

    if CameraComm.m_bIsOnCamFlow[FChNo]
      and (not (m_Inspect.FailCode in [DefPocb.POCB_FC_OK,
                                    DefPocb.POCB_FC_CAM_TEND_NG,
                                    DefPocb.POCB_FC_CAM_TEND_UNITFORMITY_NG])) then begin
      if CameraComm.SendCmd(FCamNo,'TSTOP') then begin
      end;
    end;

    CameraComm.m_bIsOnCamFlow[FChNo] := False;  //!!!
    CameraComm.m_bCamZoneDone[FChNo] := True;  //!!!

    if (m_Inspect.FailCode <> DefPocb.POCB_FC_OK) then begin //TBD:GAGO:NEWFLOW?
      //TBD:ITOLED ...start(StartSeq2Stop)
      Pg[FPgNo].SetPowerMeasurePgTimer(False{bEnable});

{$IFDEF PANEL_AUTO}
    //if m_bCBParaBeforeWrited then begin
      if m_Inspect.PowerOn and m_bCBParaBeforeWrited then begin //2023-07-27
        nFlowSeq := DefPocb.POCB_SEQ_FINAL_CBPARA_WRITE;
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING);
        sFlowStep := 'EEPROM CBPARA(After) Write';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sFlowStep+' ------');
        //
        bRet := EepromDataWrite(eepromCBParam,False{bBefore}); //USE_MODEL_PARAM_CSV
        if bRet then begin
          sDebug := sFlowStep + ' OK';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_INFO);
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_PASS)
        end
        else begin
          sDebug := sFlowStep + ' NG';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_FAIL);
        end;
    end;
{$ENDIF} //PANEL_AUTO

    //m_InsStatus := IsStop;
      m_Inspect.PowerOn := False;
      Pg[Self.FPgNo].SendPgPowerOn(DefPG.CMD_POWER_OFF);

      SendTestGuiDisplay(DefPocb.MSG_MODE_FLOW_STOP_REPORT,'',0);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',DefPocb.POCB_SEQ_POWER_OFF,DefPocb.SEQ_RESULT_PASS);
    //m_nStopReason := StopNone; //2018-12-16
      //TBD:ITOLED ...end(StartSeq2Stop)
    end;

    //---------------------------------------------------------------------

    if m_Inspect.FailCode <> DefPocb.POCB_FC_OK then SendTestGuiDisplay(DefPocb.MSG_MODE_UNIT_TT_STOP,'',1)
    else                                             SendTestGuiDisplay(DefPocb.MSG_MODE_UNIT_TT_STOP,'',0);

    //TBD:REF_ITOLED? if not bMaintCamAutoTest then begin
      //
      MakeCsvDataDetail;

      //2019-04-18 DFS:Upload하는 조건(보상OK & Offline/Online)
      //요청사항 : EICR 보고되는 경우는 무조건 DFS에 업로드가 완료되었다는 확인이 있는 경우만 업로드
      {$IFDEF SITE_LENSVN}
        //TBD:LENS:MES:FTP?
      {$ELSE}
      if Common.DfsConfInfo.bUseDfs and (Trim(m_Inspect.Result) = 'PASS') then begin  //TBD:A2CHv3:FLOW:DFS? (A2CHv2)
        if not WorkDfsFunc then begin
          sRetMsg := 'DFS Upload NG';
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,sRetMsg,DefPocb.SEQ_RESULT_FAIL);
        end;
        if (m_Inspect.DfsUploadResult = DfsUploadOK) and Common.DfsConfInfo.bDfsHexDelete then DeleteFile(Common.m_sCBDataFullName[FChNo]);
      end;
      {$ENDIF}

  		{$IFDEF SUPPORT_1CG2PANEL}
  		if not Common.SystemInfo.UseAssyPOCB then begin
  		{$ENDIF}
    		SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Finish DPC WORK & SHUTTER Up');
    		DongaDio.SetShutter(Self.FJigNo, ShutterState.UP);
        DongaDio.GetUnitTTLog(FChNo ,DefDio.DIO_IDX_GET_TT_CAM_RESET);
  		{$IFDEF SUPPORT_1CG2PANEL}
  		end
  		else begin
    		if FChNo = DefPocb.CH_1 then begin
      		if (Common.SystemInfo.UseSkipPocbConfirm and (Logic[DefPocb.CH_2].m_SkipPocbConfirmStatus = SkipPocbConfirmSKIP)) then begin //if CH2 SKIP-POCB
						SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Finish DPC WORK & SHUTTER Up');
        		DongaDio.SetShutter(Self.FJigNo, ShutterState.UP);
      		end
					else begin
						SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Finish DPC WORK (Wait CH2 Camera Process)');  //A2CHv3:ASSY-POCB:FLOW
					end;
    		end
    		else begin //CH2
      		if (Common.SystemInfo.UseSkipPocbConfirm and (Logic[DefPocb.CH_1].m_SkipPocbConfirmStatus = SkipPocbConfirmSKIP)) then begin
      		end
      		else begin
        		if Pg[DefPocb.CH_1].m_bPowerOn then Pg[DefPocb.CH_1].SendPgDisplayOnOff(True); //A2CHv3:ASSY:FLOW (CH1 Display ON if PowerON)
      		end;
				end;
      	//
				SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Finish DPC WORK & SHUTTER Up');
        DongaDio.GetUnitTTLog(FChNo ,DefDio.DIO_IDX_GET_TT_CAM_RESET);
      	DongaDio.SetShutter(Self.FJigNo, ShutterState.UP);
    	end;
    //TBD:REF_ITOLED? end;
  	{$ENDIF} //SUPPORT_1CG2PANEL
  end;
end;

procedure TLogic.SetCamNgCodeToMesCode(sCamNgMsg: string);
var
  slstData    : TStringList;
  nCamNgCode  : Integer;
  bIsDefinedCamNgCode : Boolean;
begin
  bIsDefinedCamNgCode := False;

  slstData:= TStringList.Create;
  try
    if (Length(sCamNgMsg) >= 1) then begin
      ExtractStrings([' '],[],PChar(sCamNgMsg), slstData);
      nCamNgCode := StrToIntDef(slstData[0],0); // 0: CamNgCode, 1~: String
      if (nCamNgCode > 0) and (Common.m_Dpc2GpcNgCodes[nCamNgCode].DefectCode <> '') then begin
        m_Inspect.DefectCode    := Common.m_Dpc2GpcNgCodes[nCamNgCode].DefectCode;
        m_Inspect.DefectName    := Common.m_Dpc2GpcNgCodes[nCamNgCode].DefectName;
        m_Inspect.DefectMesCode := Common.m_Dpc2GpcNgCodes[nCamNgCode].MesCodeSummary;
        if DongaGmes <> nil then Common.MesData[FChNo].Rwk := Common.m_Dpc2GpcNgCodes[nCamNgCode].MesCodeRwk;
        bIsDefinedCamNgCode := True;
      end;
    end;
  finally
    slstData.Free;
  end;

  if (not bIsDefinedCamNgCode) then begin // Set to default (DPC WORK STOP NG) if undefined CamNgCode
    m_Inspect.DefectCode    := 'PD04';
    m_Inspect.DefectName    := 'DPC WORK STOP NG';
    m_Inspect.DefectMesCode := DefGmes.POCB_MESCODE_PD04_SUMMARY;
    if DongaGmes <> nil then Common.MesData[FChNo].Rwk := DefGmes.POCB_MESCODE_PD04_RWK;
  end;
end;

function TLogic.CheckI2CConnect: Integer;
const
  EEPROM_READ_CNT = 15;
var
  i, nDataSum : integer;
  wTemp : Word;
  bRtn : Boolean;
  nRet : Integer;
begin
  {$IFDEF USE_FLASH_WRITE}
    Result := DefPG.CMD_SPI_RESULT_ACK; //TBD:USE_FLASH_WRITE?
  {$ELSE}  //USE_FLASH_WRITE
  nRet := Pg[FPgNo].SendI2cRead(EEPROM_READ_CNT*2,$A0,848); //TBD:2021-09?
  if Pg[FPgNo].FRxDataSpi.NgOrYes <> DefPG.CMD_SPI_RESULT_ACK then begin
    Result := Pg[FPgNo].FRxDataSpi.NgOrYes;
    if (nRet = WAIT_TIMEOUT) and Common.SystemInfo.SpiResetWhenTimeout then begin  //2019-04-27 (I2C Timeout의 경우, Reset SPI board.
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'SPI Reset');
      Pg[FPgNo].SendSpiReset;
    end;
  end
  else begin
    Result := DefPG.CMD_SPI_RESULT_ACK;
  end;
  {$ENDIF} //USE_FLASH_WRITE
end;

function TLogic.CheckMsgCamWork(nWaitSec: Integer): enumCamRetType;
var
	dwRtn : DWORD;
	sEvnt : WideString;
begin
	try
    if (m_bCamEvnt {and (m_hCamEvnt <> nil)}) then begin       //IMSI-INSERT!!!  //TBD:2021-09?
      CloseHandle(m_hCamEvnt);
      m_bCamEvnt := False;
    end;

		sEvnt := Format('SendCAM%d',[FPgNo]);
    m_nCamRet := camRetUnknown;
		m_hCamEvnt := CreateEvent(nil, False, False, PWideChar(sEvnt));
    m_bCamEvnt := True;
  //CodeSite.Send('[CAM%d] Start CAM Wait Event(hCamEvnt=%d)',[FPgNo+1,Integer(m_hCamEvnt)]);
    dwRtn := WaitForSingleObject(m_hCamEvnt,nWaitSec*1000);
  //CodeSite.Send('[CAM%d] CAM Wait Done(hCamEvnt=%d,CamRet=%d)',[FPgNo+1,Integer(m_hCamEvnt),m_nCamRet]);
    case dwRtn of
      WAIT_TIMEOUT : m_nCamRet := camRetTimeout;
      WAIT_FAILED  : m_nCamRet := camRetUnknown;
    end;
	finally
		CloseHandle(m_hCamEvnt);
    m_bCamEvnt := False;
	end;
  Result := m_nCamRet;
end;

procedure TLogic.MakeCsvDataDetail;
var
  nIdx, nCnt  : Integer;
  sTemp : string;
begin
  with m_Inspect do begin
    m_Inspect.csvHeaderDetail := ',';
    m_Inspect.csvDataDetail   := ',';
    m_Inspect.csvHeaderDetail := ',JUDGE_COUNT';
    m_Inspect.csvDataDetail   := Format(',%d',[Common.TestModelInfo2[FChNo].JudgeCount]);

    for nIdx := 0 to Pred(Common.TestModelInfo2[FChNo].JudgeCount) do begin
      //---------------------Uniformity Result Information------------------------------
      csvHeaderDetail := csvHeaderDetail + Format(',PTN%d_RESULT_UNIFORMITY',[nIdx+1]);
      csvDataDetail   := csvDataDetail + ',' + m_Inspect.UniformityResult[nIdx];
      //---------------------Uniformity Pattern Information------------------------------
      csvHeaderDetail := csvHeaderDetail + Format(',PTN%d_JUDGE',[nIdx+1]);
      sTemp := UserUtils.TernaryOp(Common.TestModelInfo2[FChNo].UseCustumPatName,
                               Common.TestModelInfo2[FChNo].ComparePatName[nIdx],
                               FPatGrp.PatName[Common.TestModelInfo2[FChNo].ComparedPat[nIdx]]);
      csvDataDetail        := csvDataDetail + ','+ Trim(sTemp);
      //---------------------Uniformity Percent Information------------------------------
      csvHeaderDetail := csvHeaderDetail + Format(',PTN%d_PREUNIFORMITY',[nIdx+1]);
      csvDataDetail   := csvDataDetail + Format(',%0.1f',[m_Inspect.UniformityPre[nIdx]]);
      csvHeaderDetail := csvHeaderDetail + Format(',PTN%d_POSTUNIFORMITY',[nIdx+1]);
      csvDataDetail   := csvDataDetail + Format(',%0.1f',[m_Inspect.UniformityPost[nIdx]]);
      //---------------------Uniformity Point Information------------------------------
      if Common.SystemInfo.UseUniformityPoint then begin
        for nCnt := 0 to Pred(DefPocb.UNIFORMITY_POINT_COUNT) do begin
          csvHeaderDetail := csvHeaderDetail + Format(',Pre%d_%.2d',[nIdx+1,nCnt+1]);
        end;
        csvDataDetail := m_Inspect.csvDataDetail + ',' + m_Inspect.UniformityPointsPre[nIdx];
        for nCnt := 0 to Pred(DefPocb.UNIFORMITY_POINT_COUNT) do begin
          csvHeaderDetail := csvHeaderDetail + Format(',Post%d_%.2d',[nIdx+1,nCnt+1]);
        end;
        csvDataDetail := csvDataDetail + ',' + m_Inspect.UniformityPointsPost[nIdx];
      end;
    end;
  end;
end;

procedure TLogic.MakeTEndEvt(nCamRet : enumCamRetType);
begin
//m_nCamRet := nCamRet;
  if      (m_nStopReason = StopByOperator) then m_nCamRet := camRetStopByOperator
  else if (m_nStopReason = StopByAlarm)    then m_nCamRet := camRetStopByAlarm
  else                                          m_nCamRet := nCamRet;

  if m_bCamEvnt then begin
    SetEvent(m_hCamEvnt);
  end;
end;

//******************************************************************************
// procedure/function: JigControl? -> Logic
//******************************************************************************

// JigControl -> LogicPocb
function TLogic.PgConnection: Boolean;
begin
//  if not m_bUse then Exit(True);
  //if not PgConnection then Exit;    //TBD? 2018-11-14

  if Pg[FPgNo].StatusPg in [pgForceStop, pgDisconnect] then Result := False
  else                                                      Result := True;
end;

function TLogic.SpiConnection: boolean;
begin
  if Pg[FPgNo].StatusSpi in [pgForceStop, pgDisconnect] then Result := False
  else                                                       Result := True;
end;

//******************************************************************************
// procedure/function: MainPocb <-> LogicPocb
//******************************************************************************

{$IFDEF USE_EAS}
		// [Note] EAS APDR 실처리보고 항목 (2019-06-20)
		//  - 2019-06-20 LGD 정의 POCB APDR 실처리 항목은 SummmaryCsv 항목과 일치함.
		//  - 따라서, 추후 SummaryCsv 항목 변경시, APDR 실처리항목에 반영 여부 검토/협의 필요함 !!!
{$ENDIF}

procedure TLogic.GetCsvData(var sHead, sData: string);
var
  sTemp1 : string;
  nIdx   : Integer;
begin
  //CodeSite.Send('GetCsv:start');
  m_Inspect.TimeEnd := now;
	// 2019-01-09 DateTime (e.g., 2018-12-03 11:12:13)
  sHead := 'Date/Time';
	sTemp1 := FormatDateTime('YYYY-MM-DD hh:nn:ss',m_Inspect.TimeStart);
  sData := Format('%s',[sTemp1]);

  // Serial Number
  sHead := sHead + ',SerialNumber';
  sData := sData + ',' + m_Inspect.SerialNo;

	// PM/MES
  sHead := sHead + ',PM/MES';
  if (DongaGmes <> nil) and (Length(DongaGmes.MesUserId) > 0) and (DongaGmes.MesUserId <> 'PM') then
    sData := sData + Format(',%s',[DongaGmes.MesUserId])
  else
    sData := sData + ',PM';

  // S/W UI VER
  sHead := sHead + ',SW_VER';
//sData := sData + format(',%s',[Common.m_sExeVerNameLog]);
  sData := sData + format(',%s',[Common.m_sExeVerNameSummary]); //2019-05-02
	// H/W PG VER

  sHead := sHead + ',HW_PG_VER';
  sData := sData + Format(',FW_%s_FPGA_%s',[Pg[FPgNo].m_sFwVerPg,Pg[FPgNo].m_sFpgaVerPg]);
  if (Common.SystemInfo.PG_TYPE <> PG_TYPE_DP489) then sData := sData + Format('_ALDP_%s_DLPU_%s',[Pg[FPgNo].m_sALDPVerPg,Pg[FPgNo].m_sDLPUVerPg]);

	// H/W SPI VER
  sHead := sHead + ',HW_SPI_VER';
  sData := sData + Format(',FW_%s',[Pg[FPgNo].m_sFwVerSpi]);
  if (Common.SystemInfo.SPI_TYPE <> SPI_TYPE_DJ023_SPI) then sData := sData + Format('_BOOT_%s',[Pg[FPgNo].m_sBootVerSpi]);

	// SCRIPT NAME
  sHead := sHead + ',MODEL_NAME';
  sData := sData + Format(',%s',[Common.SystemInfo.TestModel[FChNo]]);

    //CB_ALGORITHM_VER
  sHead := sHead + ',CB_ALGORITHM_VER';
  sData := sData + Format(',%s',[CameraComm.m_csvCamData[FPgNo].VerStr]);

  	// EQP ID
  sHead := sHead + ',EQP_ID';
  sData := sData + Format(',%s',[Common.SystemInfo.EQPId]);

	// Channel
  sHead := sHead + ',Channel';
  sData := sData + Format(',%d',[FChNo+1]);

  // Panel ID
  sHead := sHead + ',Panel_ID';
  sData := sData + Format(',%s',[m_Inspect.PanelID]);
//if Common.TestModelInfo2[FChNo].BcrScanMesSPCB then begin //2021-12-30 (Lucid: PchkRtnPid)
//  if Common.MesData[FChNo].bRxPchkRtnPid then sData := sData + Format(',%s',[Common.MesData[FChNo].PchkRtnPid])
//  else                                        sData := sData + Format(',%s',[m_Inspect.PanelID]); //2022-03-08 (null->PanelID for PM Mode)
//end
//else begin
//  sData := sData + Format(',%s',[m_Inspect.PanelID]); //2021-12-23 (SerialNo -> PanelID)
//end;

  // Final_Pass_Failed : 'PASS' or 'Failed'
  sHead := sHead + ',Final_Pass_Failed';
  if Trim(m_Inspect.Result) <> 'PASS' then sData := sData + ',Failed'
	else                                     sData := sData + ',PASS';
	
  // 2019-01-09 (Summary항목 추가: Result)
  sHead := sHead + ',Result';
  if (Trim(m_Inspect.Result) <> 'PASS') then begin
    if m_Inspect.DefectCode <> '' then sData := sData + Format(',%s',[m_Inspect.DefectCode])
    else sData := sData + ',PD01';
  end
  else sData := sData + ',OK'; //2019-06-25

  sHead := sHead + ',Failed_Message';
  if (Trim(m_Inspect.Result) <> 'PASS') then begin
    if m_Inspect.Fail_Message <> '' then sData := sData + Format(',%s',[m_Inspect.Fail_Message])
    else sData := sData + ',STOP by Operator';
  end
  else sData := sData + ',';

	// StartTime (e.g., 2018-12-03 11:12:13)
  sHead := sHead+ ',Start_Date';
  sTemp1 := FormatDateTime('YYYY/MM/DD', m_Inspect.TimeStart);
  sData := sData+ format(',%s',[sTemp1]);

  sHead := sHead + ',Start_Time';
	sTemp1 := FormatDateTime('YYYY-MM-DD hh:nn:ss',m_Inspect.TimeStart);
  sData := sData + format(',%s',[sTemp1]);
	// EndTime
  sHead := sHead + ',End_Time';
	sTemp1 := FormatDateTime('YYYY-MM-DD hh:nn:ss',m_Inspect.TimeEnd);
  sData := sData + format(',%s',[sTemp1]);
	// Measure Tact Time
  sHead := sHead + ',Measure_Tact_Time';
  sTemp1 := Format('%d',[SecondsBetween(m_Inspect.UnitTimeStart,m_Inspect.UnitTimeEnd)]);
  sData := sData + format(',%s',[sTemp1]);
	// 2019-01-09 Jig Tact Time (Jig + Measure)
  sHead := sHead + ',Jig_Tact_Time';
  sTemp1 := Format('%d',[SecondsBetween(m_Inspect.JigTimeStart,m_Inspect.JigTimeEnd)]);
  sData := sData + format(',%s',[sTemp1]);
	// Total Tact Time
  sHead := sHead + ',Total_Tact_Time';
	sTemp1 := Format('%d',[SecondsBetween(m_Inspect.TimeStart,m_Inspect.TimeEnd)]);
  sData := sData + format(',%s',[sTemp1]);

	// VCC(V)
  sHead  := sHead + ',VCC(V)';
  sTemp1 := Format('%0.2f',[m_Inspect.PwrData.VCC / 1000]);
  sData  := sData + Format(',%s',[sTemp1]);
	// VDD(V)
{$IFDEF PANEL_AUTO}	
  sHead  := sHead + ',VDD(V)';
{$ELSE}
  sHead  := sHead + ',VEL(V)';	
{$ENDIF}
  sTemp1 := Format('%0.2f',[m_Inspect.PwrData.VDD_VEL / 1000]);
  sData  := sData + Format(',%s',[sTemp1]);
	// ICC(mA)
  sHead  := sHead + ',ICC(mA)';
  sTemp1 := Format('%d',[m_Inspect.PwrData.ICC]);
  sData  := sData + Format(',%s',[sTemp1]);
	// IDD(mA)
{$IFDEF PANEL_AUTO}		
  sHead  := sHead + ',IDD(mA)';
{$ELSE}
  sHead  := sHead + ',IEL(mA)';
{$ENDIF}	
  sTemp1 := Format('%d',[m_Inspect.PwrData.IDD_IEL]);
  sData  := sData + Format(',%s',[sTemp1]);

  //CRC
  sHead := sHead + ',CRC_Model_Mcf';
  sData := sData + Format(',%s',[Common.m_ModelCrc[FChNo].ModelMcf]);
  sHead := sHead + ',CRC_Model_ParamCsv';
  sData := sData + Format(',%s',[Common.m_ModelCrc[FChNo].ModelParamCsv]);

  sHead := sHead + ',CRC_CB_Algorithm';
  sData := sData + Format(',%s',[Common.m_ModelCrc[FChNo].CB_Algorithm]);
  sHead := sHead + ',CRC_Cam_Parameter';
  sData := sData + Format(',%s',[Common.m_ModelCrc[FChNo].Cam_Parameter]);

  //Inspect Information (Details)
  sHead := sHead + m_Inspect.csvHeaderDetail;
  sData := sData + m_Inspect.csvDataDetail;
end;

function TLogic.EepromDataCheck(dataType: enumEepromDataType): Boolean; //USE_FLASH_WRITE //TBD:2021-05? (NG_REASON: R/W Fail, R/W Timeout, Value Mismatch)
var
  btBuf : TIdBytes;
  nRet, nDevice, nRegister, nFlowSeq : Integer;
  sDebug : string;
  EepromCheck : TEepromCheckRec;
  i, nCntEepromCheck : Integer;
begin
  Result := False;
  try
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(False{bEnable});
    //---------------------------------- Check EEPROM Data
    with Common.TestModelInfo2[FChNo] do begin

      SetLength(btBuf,1);
      if dataType = eepromCBParam then begin
        nCntEepromCheck := Length(EepromCheckCBParam);
      //sDebug := 'Check EEPROM CBPARA --------';
      {$IF Defined(PANEL_AUTO)}
      end
      else begin
        nCntEepromCheck := Length(EepromCheckProcMask);
      //sDebug := 'Check EEPROM ProcMask --------';
      {$ELSE}
      Exit;
      {$ENDIF}
      end;
    //SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      for i := 0 to Pred(nCntEepromCheck) do begin
        {$IF Defined(PANEL_AUTO)}
        // Get CSV Data (ProcMask|CBParam)
        if dataType = eepromCBParam then EepromCheck := EepromCheckCBParam[i]
        else                             EepromCheck := EepromCheckProcMask[i];
        {$ELSE}
        EepromCheck := EepromCheckCBParam[i];
        {$ENDIF}
        if (EepromCheck.nDevAddr = 0) then Continue;
        // Get Write Info (DevAddr,RegAddr,Value)
        nDevice   := EepromCheck.nDevAddr;
    	  nRegister := EepromCheck.nRegAddr;
        btBuf[0]  := EepromCheck.nValue;
        //
        sDebug := Format('[EEPROM] READ 0x%0.2x 0x%0.2x',[nDevice,nRegister]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
        nRet := Pg[Self.FPgNo].SendI2cRead(1,nDevice,nRegister);
{$IFDEF SIMULATOR_PANEL}
        Pg[self.FPgNo].FRxDataSpi.Data[0] := btBuf[0];
{$ENDIF}
        if nRet <> WAIT_OBJECT_0 then begin
          if nRet = WAIT_TIMEOUT then sDebug := sDebug+' ...NG(Read Timeout)'
          else                        sDebug := sDebug+' ...NG(Read Error)';
  	      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          if (nRet = WAIT_TIMEOUT) and Common.SystemInfo.SpiResetWhenTimeout then begin
            SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'SPI Reset');
            Pg[Self.FPgNo].SendSpiReset;
          end;
          Exit(False);
        end;
        if Pg[self.FPgNo].FRxDataSpi.Data[0] <> btBuf[0] then begin
          sDebug := Format('[EEPROM] Verify Data : 0x%0.2x ...NG (<> 0x%0.2x)',[Pg[self.FPgNo].FRxDataSpi.Data[0],btBuf[0]]);
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          Exit(False);
        end;
        sDebug := Format('[EEPROM] Verify Data : 0x%0.2x',[Pg[self.FPgNo].FRxDataSpi.Data[0]]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      end;
    end;
    Result := True;
  finally
    //---------------------------------- Enable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(True{bEnable});
  end;
end;

function TLogic.EepromDataWrite(dataType: enumEepromDataType; bBefore: Boolean): Boolean;
var
  btBuf : TIdBytes;
  nRet, nDevice, nRegister, nFlowSeq : Integer;
  sDebug : string;
  EepromWrite : TEepromWriteRec;
  i, nCntEepromWrite : Integer;
  bValueExist : Boolean;
begin
  Result := False;
  try
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(False{bEnable});
    //

    if ((dataType = eepromCBParam) and bBefore) then m_bCBParaBeforeWrited := True;  //USE_MODEL_PARAM_CSV

    with Common.TestModelInfo2[FChNo] do begin

{$IFDEF NO_NEED}  //TBD:USE_FLASH_WRITE?
      // EEPROM FlashAccess Disable if CBPARA
      if Common.TestModelInfo2[FChNo].EnableFlashWriteCBData then begin
        if (dataType = eepromCBParam) then begin
          sDebug := 'Check and Write EEPROM (FlashAccess Disable) ------';
          if not SetEepromFlashAccess(False{bEnable}) then begin
            sDebug := 'Write EEPROM (FlashAccess Disable)';
            SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...NG(Write Error)', DefPocb.LOG_TYPE_NG);
            Exit(False);
          end;
        end;
      end;
{$ENDIF}

      // CBParam|ProcMask|AfterPUCWrite
      SetLength(btBuf,1);
			case dataType of
				eepromCBParam  : nCntEepromWrite := Length(EepromWriteCBParam);
        {$IF Defined(PANEL_AUTO)}
				eepromProcMask : nCntEepromWrite := Length(EepromWriteProcMask);
        eepromAfterPUC : nCntEepromWrite := Length(EepromWriteAfterPUC); //2022-09-01
        {$ENDIF}
        else begin
          sDebug := 'Write EEPROM ...NG(Unknown DataType)';
  	      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug,DefPocb.LOG_TYPE_NG);
          Exit;
        end;
      end;
      for i := 0 to Pred(nCntEepromWrite) do begin
        // Get CSV Data (ProcMask|CBParam|AfterPUCWrite)
				case dataType of
					eepromCBParam  : EepromWrite := EepromWriteCBParam[i];
          {$IF Defined(PANEL_AUTO)}
					eepromProcMask : EepromWrite := EepromWriteProcMask[i];
        	eepromAfterPUC : EepromWrite := EepromWriteAfterPUC[i];
          {$ENDIF}
        end;
        if (EepromWrite.nDevAddr = 0) then Continue;

				case dataType of
					eepromCBParam : begin
            if bBefore then bValueExist := EepromWrite.bStartValue else bValueExist := EepromWrite.bEndValue; //2021-11-12 Skip if empty value
          end;
          {$IF Defined(PANEL_AUTO)}
					eepromProcMask : begin
            if bBefore then bValueExist := EepromWrite.bStartValue else bValueExist := EepromWrite.bEndValue; //2021-11-12 Skip if empty value
          end;
        	eepromAfterPUC : begin //2022-09-01
            bValueExist := EepromWrite.bStartValue;
          end;
          {$ENDIF}
        end;
        if not bValueExist then Continue;

        // Get Write Info (DevAddr,RegAddr,Value)
        nDevice   := EepromWrite.nDevAddr;
    	  nRegister := EepromWrite.nRegAddr;
				case dataType of
					eepromCBParam : begin
            if bBefore then btBuf[0] := EepromWrite.nStartValue else btBuf[0] := EepromWrite.nEndValue;
          end;
          {$IF Defined(PANEL_AUTO)}
					eepromProcMask : begin
            if bBefore then btBuf[0] := EepromWrite.nStartValue else btBuf[0] := EepromWrite.nEndValue;
          end;
        	eepromAfterPUC : begin //2022-09-01
            btBuf[0] := EepromWrite.nStartValue;
          end;
          {$ENDIF}
        end;

        // Write
        sDebug := Format('[EEPROM] WRITE 0x%0.2x 0x%0.4x : 0x%0.2x',[nDevice,nRegister,btBuf[0]]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
        nRet := Pg[Self.FPgNo].SendI2cWrite(1,nDevice,nRegister,btBuf);
        if nRet <> WAIT_OBJECT_0 then begin
          sDebug := sDebug+' ...NG(Write Error)';
  	      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          if (nRet = WAIT_TIMEOUT) and Common.SystemInfo.SpiResetWhenTimeout then begin  //2019-04-27 (I2C Timeout의 경우, Reset SPI board.
            SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'SPI Reset');
            Pg[Self.FPgNo].SendSpiReset;
          end;
          Exit(False);
        end;
        Sleep(10);

        // Verify(Read+Compare)
        sDebug := Format('[EEPROM] READ 0x%0.2x 0x%0.4x',[nDevice,nRegister]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
        nRet := Pg[Self.FPgNo].SendI2cRead(1,nDevice,nRegister);
{$IFDEF SIMULATOR_PANEL}
        Pg[self.FPgNo].FRxDataSpi.Data[0] := btBuf[0];
{$ENDIF}
        if nRet <> WAIT_OBJECT_0 then begin
          if nRet = WAIT_TIMEOUT then sDebug := sDebug+' ...NG(Read Timeout)'
          else                        sDebug := sDebug+' ...NG(Read Error)';
  	      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          if (nRet = WAIT_TIMEOUT) and Common.SystemInfo.SpiResetWhenTimeout then begin  //2019-04-27 (I2C Timeout의 경우, Reset SPI board.
            SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'SPI Reset');
            Pg[Self.FPgNo].SendSpiReset;
          end;
          Exit(False);
        end;
        //
        if Pg[self.FPgNo].FRxDataSpi.Data[0] <> btBuf[0] then begin
          sDebug := Format('[EEPROM] Verify Data : 0x%0.2x ...NG (<> 0x%0.2x)',[Pg[self.FPgNo].FRxDataSpi.Data[0],btBuf[0]]);
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          Exit(False);
        end;
        sDebug := Format('[EEPROM] Verify Data : 0x%0.2x',[Pg[self.FPgNo].FRxDataSpi.Data[0]]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      end;
    end;

    if (dataType = eepromCBParam) and (not bBefore) then m_bCBParaBeforeWrited := False;  //USE_MODEL_PARAM_CSV
    Result := True;

  finally
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(True{bEnable});  //2022-08-18 (False->True) //TBD:MERGE?
  end;
end;

{$IF Defined(PANEL_AUTO)}
function TLogic.EepromGammaDataCheck: Boolean;
const
  EEPROM_READ_CNT = 15;
var
  nRtn  : DWORD;
  sFunc, sMLog, sTempFunc, sTempMLog : string;
  nDevAddr, nRegAddr, nLength : Integer;
  nCntEepromGamma, nOffset, i : Integer;
  EepromData : TEepromDataRec;
  nDataSum : integer;
  wTemp : Word;
  bRtn : Boolean;
begin
  sMLog := 'EEPROM GammaData Check ';
  sFunc := 'EepromCheckGammaData: ';
//CodeSite.Send(sFunc+' ##### START #####');
  //
  nOffset := 0;
  nCntEepromGamma := Length(Common.TestModelInfo2[FPgNo].EepromGammaData);
  if nCntEepromGamma < 1 then Exit(False);
//for i := 0 to Pred(nCntEepromGamma) do begin
    EepromData := Common.TestModelInfo2[FPgNo].EepromGammaData[0];
    if (EepromData.nDevAddr = 0) then Exit(False);
    if (EepromData.nLength <= 0) then Exit(False);
    // Get Write Info (DevAddr,RegAddr,Length)
    nDevAddr := EepromData.nDevAddr;
    nRegAddr := EepromData.nRegAddr;
    nLength  := EEPROM_READ_CNT*2;
    //
    sTempFunc := Format('SendI2cRead(Len=%d,DevAddr=0x%0.2x,RegAddr=0x%0.4x): ',[nLength,nDevAddr,nRegAddr]);
    nRtn := Pg[FPgNo].SendI2cRead(nLength, nDevAddr, nRegAddr);
  //if Pg[m_nPgNo].FRxDataSpi.NgOrYes <> DefPG.CMD_SPI_RESULT_ACK then begin
    if (nRtn <> WAIT_OBJECT_0) then begin
      if nRtn = WAIT_TIMEOUT then sTempMLog := 'Timeout' else sTempMLog := 'Read Failed';
      if (nRtn = WAIT_TIMEOUT) and Common.SystemInfo.SpiResetWhenTimeout then begin  //2019-04-27 (I2C Timeout의 경우, Reset SPI board.
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sMLog+'SPI Reset');
        Pg[FPgNo].SendSpiReset;
      end;
    //CodeSite.Send(sFunc+sTempFunc+'...NG(EEPROM Read)');
      Exit(False);
    end;

    bRtn := False; nDataSum := 230;
    for i := 0 to Pred(EEPROM_READ_CNT) do begin
      CopyMemory(@wTemp,@Pg[FPgNo].FRxDataSpi.Data[i*2],2);
      wTemp := htons(wTemp);
      if wTemp > 1023 then begin
        bRtn := True;
        Break;
      end;
      nDataSum := nDataSum + wTemp;
      if nDataSum > 10230 then begin
        nDataSum := 255;
      end;
    end;
    if bRtn then begin
      Result := False; //DefPG.CMD_SPI_RESULT_ACK + 1;
    end
    else begin
      if nDataSum < 255 then begin
        Result := False; //DefPG.CMD_SPI_RESULT_ACK + 2;
      end
      else begin
        Result := True; //DefPG.CMD_SPI_RESULT_ACK;
      end;
    end;
//end;
  //
//CodeSite.Send(sFunc+' ##### END #####');
//Result := True;
end;
{$ENDIF}

{$IF Defined(PANEL_AUTO)}
function TLogic.EepromGammaDataRead(var nGammaDataSize: Integer; var GammaDataBuf: array of Byte): Boolean;
var
  dwRtn  : DWORD;
  sMLog, sTempMLog, sTempFunc : string;
  nDevAddr, nRegAddr, nLength : Integer;
  nCntEepromGamma, nOffset, i : Integer;
  EepromData : TEepromDataRec;
begin
  Pg[Self.FPgNo].SetCyclicTimerSpi(False{bEnable});
  //
  try
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'EEPROM GammaData Read ------');
 	  //
 	  // None-CI Model  Addr(Start)      Addr(End)   Length
 	  //      Region.1:  848 (h'xxxx) ~ 1567 (h'xxxx)  720
 	  //      Region.2: 2464 (h'xxxx) ~ 2943 (h'07AD)  480
 	  //      Total   :                               1200
 	  //
 	  nOffset := 0;
 	  nCntEepromGamma := Length(Common.TestModelInfo2[Self.FPgNo].EepromGammaData);
 	  for i := 0 to Pred(nCntEepromGamma) do begin
 	    EepromData := Common.TestModelInfo2[Self.FPgNo].EepromGammaData[i];
 	    if (EepromData.nDevAddr = 0) then Continue;
 	    if (EepromData.nLength <= 0) then Continue;
 	    // Get Write Info (DevAddr,RegAddr,Length)
 	    nDevAddr := EepromData.nDevAddr;
 	    nRegAddr := EepromData.nRegAddr;
 	    nLength  := EepromData.nLength;
 	    //
 	    sMLog := Format('[EEPROM] READ Gamma: 0x%0.2x %d Len(%d)',[nDevAddr,nRegAddr,nLength]);
 	    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sMLog);
 	    //
 	    sTempFunc := Format('SendI2cRead(Len=%d,DevAddr=0x%0.2x,RegAddr=0x%0.4x): ',[nLength,nDevAddr,nRegAddr]);
 	    dwRtn := Pg[Self.FPgNo].SendI2cRead(nLength, nDevAddr, nRegAddr);
 	  //if Pg[m_nPgNo].FRxDataSpi.NgOrYes <> DefPG.CMD_SPI_RESULT_ACK then begin
 	    if (dwRtn <> WAIT_OBJECT_0) then begin
 	      if dwRtn = WAIT_TIMEOUT then sTempMLog := 'Timeout' else sTempMLog := 'Failed';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'EEPROM GammaData Read '+sTempMLog, DefPocb.LOG_TYPE_NG);
 	      Exit(False);
 	    end;
 	    //
 	    CopyMemory(@GammaDataBuf[nOffset], @Pg[Self.FPgNo].FRxDataSpi.Data[0], nLength);
 	    Sleep(10); //2023-10-18 T/T (100 -> 10)
 	    //
 	    nOffset := nOffset + nLength;
 	    nGammaDataSize := nOffset;
	  end;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'EEPROM GammaData Read OK');
		Result := True;
	finally
  	Pg[Self.FPgNo].SetCyclicTimerSpi(True{bEnable});
  end;
end;
{$ENDIF}

{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
function TLogic.FlashGammaDataRead(var nGammaDataSize: Integer; var GammaDataBuf: array of Byte): Boolean;
var
  dwRtn  : DWORD;
  sMLog, sTempMLog, sTempFunc, sFunc, sDebug, sReason : string;
  nFlashAddr, nLength : Integer;
  nCntFlashGamma, nOffset, i, nDataIdx : Integer;
  FlashData : TFlashDataRec;
  //
  FlashAccessParam : TFlashAccessParamRec;
begin
  Pg[Self.FPgNo].SetCyclicTimerSpi(False{bEnable});
  //
  try
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'FLASH GammaData Read ------');
    FlashAccessParam := Common.TestModelInfo2[FPgNo].FlashAccessParam;

    //---------------------------------- Ext_Flash_Access(0x0020) - Enable
    sFunc  := 'ExtFlashAccess(Enable)';
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

    Sleep(FlashAccessParam.AccEnableBeforeDelayMsec);
    dwRtn := Pg[FPgNo].SendSpiFlashAccess(1{nMode:0=Disable,1=Enable});
    if (dwRtn <> WAIT_OBJECT_0) then begin
      Sleep(100);
      dwRtn := Pg[FPgNo].SendSpiFlashAccess(1{nMode:0=Disable,1=Enable});
      if (dwRtn <> WAIT_OBJECT_0) then begin
        if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
        sDebug := sMLog+sFunc+' ...NG('+sReason+')';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
        Exit(False);
      end;
    end;
    Sleep(FlashAccessParam.AccEnableAfterDelayMsec);

    if Common.SystemInfo.SPI_TYPE = SPI_TYPE_DJ023_SPI then begin
      //---------------------------------- Ext_Flash_Init(0x0032)
      sFunc  := 'ExtFlashInit';
      sDebug := sMLog+sFunc;
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      Sleep(FlashAccessParam.InitBeforeDelayMsec);
      dwRtn := Pg[FPgNo].SendSpiFlashInit;
      if (dwRtn <> WAIT_OBJECT_0) then begin
        Sleep(100);
        dwRtn := Pg[FPgNo].SendSpiFlashInit;
        if (dwRtn <> WAIT_OBJECT_0) then begin
          if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
          sDebug := sMLog+sFunc+' ...NG('+sReason+')';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          Exit(False);
        end;
      end;
      Sleep(FlashAccessParam.InitAfterDelayMsec);
    end;

 	  //
 	  nOffset := 0;
 	  nCntFlashGamma := Length(Common.TestModelInfo2[Self.FPgNo].FlashGammaData);
 	  for i := 0 to Pred(nCntFlashGamma) do begin
 	    FlashData := Common.TestModelInfo2[Self.FPgNo].FlashGammaData[i];
 	    if (FlashData.nFlashAddr = 0) then Continue;
 	    if (FlashData.nLength <= 0) then Continue;
 	    //
 	    nFlashAddr := FlashData.nFlashAddr;
 	    nLength    := FlashData.nLength;
 	    //
 	    sMLog := Format('[FLASH] READ Gamma: Addr(0x%0.8x) Len(%d)',[nFlashAddr,nLength]);
 	    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sMLog);
      // Flash Read
      sDebug := Format('Flash Data Read(Panel->QSPI): StartAddr(%d) Len(%d)',[nFlashAddr,nLength]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      dwRtn := Pg[Self.FPgNo].SendSpiFlashRead(flashReadLength, nFlashAddr, nLength, 10000);
      if dwRtn <> WAIT_OBJECT_0 then begin
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...NG');
        Exit;
      end;
      Sleep(100);

      nDataIdx := 0;
      sDebug := Format('Flash Data Upload(QSPI->PC): Index(%d) Len(%d)',[nDataIdx,nLength]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      dwRtn := Pg[Self.FPgNo].SendSpiFlashDataUploadFlow(nDataIdx,nLength, 10000);
      if dwRtn <> WAIT_OBJECT_0 then begin
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...NG');
        Exit;
      end;
 	    //
 	  //CopyMemory(@GammaDataBuf[nOffset], @Pg[Self.FPgNo].FRxDataSpi.Data[0], nLength);
 	    CopyMemory(@GammaDataBuf[nOffset], @Pg[Self.FPgNo].m_FlashRead.RxData[0], nLength);
 	  	Sleep(10); //2023-10-18 T/T (100 -> 10)
 	    //
 	    nOffset := nOffset + nLength;
 	    nGammaDataSize := nOffset;
	  end;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'FLASH GammaData Read OK');
	  Result := True;
  //================
  finally
    //---------------------------------- Ext_Flash_Access(0x0020) - Disable
    sFunc  := 'ExtFlashAccess(Disable)';
    sDebug := sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    Sleep(FlashAccessParam.AccDisableBeforeDelayMsec);
    dwRtn := Pg[FPgNo].SendSpiFlashAccess(0{nMode:0=Disable,1=Enable});
    if (dwRtn <> WAIT_OBJECT_0) then begin
      Sleep(100);
      dwRtn := Pg[FPgNo].SendSpiFlashAccess(0{nMode:0=Disable,1=Enable});
      if (dwRtn <> WAIT_OBJECT_0) then begin
        if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
        sDebug := sMLog+sFunc+' ('+sReason+')';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      end;
    end;
    Sleep(FlashAccessParam.AccDisableAfterDelayMsec);
    //---------------------------------- Enable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(True{bEnable});
  end;
end;

function TLogic.FlashAfterPUCDataWrite(nCB: Integer): Boolean;
var
  btBuf : TIdBytes;
  nRet, nFlashAddr, nFlowSeq : Integer;
  sDebug : string;
  flashWriteAfter : TFlashWriteAfterPUCRec;
  i, nCntFlashWrite : Integer;
  bValueExist : Boolean;
begin
  Result := False;
  try
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(False{bEnable});

    //
    with Common.TestModelInfo2[FChNo] do begin

      SetLength(btBuf,1);
      nCntFlashWrite := Length(FlashWriteAfterPUC);
      for i := 0 to Pred(nCntFlashWrite) do begin
        // Get CSV Data (AfterPUCWrite)
        flashWriteAfter := FlashWriteAfterPUC[i];
        if (flashWriteAfter.nAddr = 0) then Continue;
        bValueExist := flashWriteAfter.bValue[nCB];
        if not bValueExist then Continue;

        // Get Write Info (FlashAddr,Value)
        nFlashAddr := flashWriteAfter.nAddr;
        btBuf[0] := flashWriteAfter.nValue[i];

        // Write
        sDebug := Format('[FLASH] WRITE 0x%0.8x : 0x%0.2x',[nFlashAddr,btBuf[0]]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
        nRet := Pg[Self.FPgNo].FlashWriteData(nFlashAddr,1,btBuf,False{bImmediately});
        if nRet <> WAIT_OBJECT_0 then begin
	        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...NG (Write Error)');
          if (nRet = WAIT_TIMEOUT) and Common.SystemInfo.SpiResetWhenTimeout then begin  //2019-04-27 (I2C Timeout의 경우, Reset SPI board.
            //TBD:GAGO? SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'SPI Reset');
            //TBD:GAGO? Pg[Self.FPgNo].SendResetSpi;
          end;
          Exit(False);
        end;
        Sleep(10);
      end;

      sDebug := '[WRITE] FLASH Commit';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      nRet := Pg[Self.FPgNo].FlashWriteDeviceCommit; //TBD:EDNA:FLASH?
    {$IFDEF SIMULATOR_PANEL}
    //nRet := WAIT_TIMEOUT;  //SIM:PG (NG처리 확인 필요시, 값 변경)
    //Pg[self.FPgNo].FRxSpiData.NgOrYes := DefPg.CMD_SPI_RESULT_NAK; //SIM:PG (NG처리 확인 필요시, 값 변경)
    {$ENDIF}
      if nRet <> WAIT_OBJECT_0 then begin
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...NG (Write Error)');
        if (nRet = WAIT_TIMEOUT) and Common.SystemInfo.SpiResetWhenTimeout then begin  //2019-04-27 (I2C Timeout의 경우, Reset SPI board.
          //TBD:GAGO? SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'SPI Reset');
          //TBD:GAGO? Pg[Self.FPgNo].SendResetSpi;
        end;
        Exit(False);
      end;
      Sleep(10);  //2019-01-22
    end;

    Result := True;

  finally
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(True{bEnable});  //2022-08-18 (False->True) //TBD:MERGE?
  end;
end;
{$ENDIF}

function TLogic.FlashCBDataFileWrite(fName: string): Boolean;
var
  sDebug : string;
  transData: TFileTranStr;
  nPwrOffOnDelay : Integer;
  bWriteOK, bAccessDisableOK : Boolean;
begin
  Result := False;
  bWriteOK := False;
  bAccessDisableOK := False;

  //--------------------------------- Get CBDATA File (bin)
  if not GetBinFileToTransData(fName,transData) then begin
    sDebug := 'CBDATA File Access NG';
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
    Exit;
  end;

  try
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE, '', DefPocb.FLASH_PROGRESS_START);
    //--------------------------------- Set EEPROM FlashAccess(Enable)
    {$IFDEF PANEL_AUTO}
    sDebug := 'Write EEPROM FlashAccess(Enable)';
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    if not EepromFlashAccessWrite(True{bEnable},True{bPowerResetIfChanged}) then begin
      Exit;
    end;
    {$ENDIF}
    //--------------------------------- Power Reset (in EepromFlashAccessWrite)
    //--------------------------------- Flash Write (CBDATA,StartAddr,EndAddr)
    bWriteOK := FlashCBDataWrite(transData);
    if not bWriteOK then begin
      Exit;
    end;
  finally
    //--------------------------------- Set EEPROM FlashAccess(Disable)
    bAccessDisableOK := True;
    {$IFDEF PANEL_AUTO}
    sDebug := 'Write EEPROM FlashAccess(Disable)';
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    bAccessDisableOK := EepromFlashAccessWrite(False{bEnable},(not m_bAutoPowerOff){bPowerResetIfChanged}); // Power Reset if not AutoPowerOff
    {$ENDIF}
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE, '', DefPocb.FLASH_PROGRESS_NONE);
  end;

  if bWriteOK and bAccessDisableOK then Result := True;
end;

function TLogic.GetBinFileToTransData(sFullPath: string; var transData: TFileTranStr): Boolean;
var
  sDebug : string;
  sFileName : string;
  mtData : TMemoryStream;
  dGetCheckSum : DWORD;
begin
  Result := False;

  mtData := TMemoryStream.Create;
  try
    if Length(sFullPath) <= 0 then begin
      sDebug := 'CBDATA File NG(Unknown)';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      Exit;
    end;

    mtData.LoadFromFile(Trim(sFullPath));
    if mtData.Size <= 0 then begin
      sDebug := 'CBDATA File NG(Empty)';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      Exit;
    end;
    mtData.Position := 0;
    SetLength(transData.Data,mtData.Size); //TBD:USE_FLASH_WRITE?
    mtData.Read(transData.Data[0],mtData.Size);

    transData.TransMode := DefPocb.DOWNDATA_POCB_CBDATA;
    transData.TransType := DefPG.PGSPI_DOWNLOAD_FLASH_CBDATA; //info
    transData.TotalSize := mtData.Size;
    transData.fileName  := sFullPath;
    transData.filePath  := sFullPath;
    dGetCheckSum := 0;
    if transData.TotalSize > 0 then begin
      Common.CalcCheckSum(@transData.Data[0],mtData.Size, dGetCheckSum);
    end;
    transData.CheckSum  := dGetCheckSum;

    sFileName := ExtractFileName(sFullPath);
    sDebug := sFileName + ', Size(' + IntToStr(mtData.Size) + ')';
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
  finally
    mtData.Free;
  end;

  Result := True;
end;

function TLogic.EepromFlashAccessWrite(bEnable: Boolean; bPowerResetIfChanged: Boolean = True): Boolean;
var
  nRtn   : DWORD;
  sDebug : string;
  nDevAddr, nRegAddr : Integer;
  nValue : Byte;
  btBuf  : TIdBytes;
  nPwrOnDelay, nPwrOffDelay : Integer;
  FlashAccess : TEepromFlashAccessRec;
  i, nCntAccessWrite : Integer;
begin
  Result := False;
  try
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(False{bEnable});

    //----------------------------------
    with Common.TestModelInfo2[FChNo] do begin
      //
      nCntAccessWrite := Length(EepromFlashAccess);
      for i := 0 to Pred(nCntAccessWrite) do begin

        FlashAccess := EepromFlashAccess[i]; // Get EEPROM EepromFlashAccess
        if FlashAccess.nDevAddr = 0 then begin
          Exit(False);
        end;

        nDevAddr    := FlashAccess.nDevAddr;
        nRegAddr    := FlashAccess.nRegAddr;

        //--------------------------------- Read EepromFlashAccess
        sDebug := Format('[EEPROM] READ 0x%0.2x 0x%0.2x',[nDevAddr,nRegAddr]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
        nRtn := Pg[Self.FPgNo].SendI2cRead(1,nDevAddr,nRegAddr);
      //{$IFDEF SIMULATOR_PANEL}
      //if bEnable then Pg[self.FPgNo].FRxDataSpi.Data[0] := $01
      //else            Pg[self.FPgNo].FRxDataSpi.Data[0] := $41;
      //{$ENDIF}
        if nRtn <> WAIT_OBJECT_0 then begin
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...Retry');
          nRtn := Pg[Self.FPgNo].SendI2cRead(1,nDevAddr,nRegAddr); // retry
          if nRtn <> WAIT_OBJECT_0 then begin
            if nRtn = WAIT_TIMEOUT then sDebug := sDebug + ' ...NG(Read Timeout)'
            else                        sDebug := sDebug + ' ...NG(Read Fail)';
            SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
            Exit(False);
          end;
        end;
        nValue := Pg[self.FPgNo].FRxDataSpi.Data[0];
        sDebug := Format('[EEPROM] Read Data : 0x%0.2x',[nValue]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

        if FlashAccess.bWriteBit then begin // Bit# Operation -------------------------------------
          // Check EepromFlashAccess Enable/Disable Bit
          if bEnable then begin
            if (nValue and (1 shl FlashAccess.nBit)) <> 0 then begin
              sDebug := Format('[EEPROM] Verify Data : 0x%0.2x (Already Enabled)',[nValue]);
              SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
              Continue;
            end;
          end
          else begin
            if (nValue and (1 shl FlashAccess.nBit)) = 0 then begin
              sDebug := Format('[EEPROM] Verify Data : 0x%0.2x (Already Disabled)',[nValue]);
              SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
              Continue;
            end;
          end;
          // Set EepromFlashAccess Enable/Disable Bit
          if bEnable then nValue := nValue or (1 shl FlashAccess.nBit)
          else            nValue := nValue and (not (1 shl FlashAccess.nBit));

        end
        else begin // Byte Write -----------------------------------------------------
          // Check EepromFlashAccess Enable/Disable Byte
          if bEnable then begin
            if (nValue = FlashAccess.nByteEnable) then begin
              sDebug := Format('[EEPROM] Verify Data : 0x%0.2x (Already Enabled)',[nValue]);
              SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
              Continue;
            end;
          end
          else begin
            if (nValue = FlashAccess.nByteDisable) then begin
              sDebug := Format('[EEPROM] Verify Data : 0x%0.2x (Already Disabled)',[nValue]);
              SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
              Continue;
            end;
          end;
          // Set EepromFlashAccess Enable/Disable ByteValue
          if bEnable then nValue := FlashAccess.nByteEnable
          else            nValue := FlashAccess.nByteDisable;
        end;

        //--------------------------------- Write EepromFlashAccess
        SetLength(btBuf,1);
        btBuf[0] := nValue;
        sDebug := Format('[EEPROM] WRITE 0x%0.2x 0x%0.2x : 0x%0.2x',[nDevAddr,nRegAddr,btBuf[0]]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
        nRtn := Pg[Self.FPgNo].SendI2cWrite(1,nDevAddr,nRegAddr,btBuf);
        if nRtn <> WAIT_OBJECT_0 then begin
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...Retry');
          nRtn := Pg[Self.FPgNo].SendI2cWrite(1,nDevAddr,nRegAddr,btBuf); //retry
          if nRtn <> WAIT_OBJECT_0 then begin
            if nRtn = WAIT_TIMEOUT then sDebug := sDebug + ' ...NG(Write Timeout)'
            else                        sDebug := sDebug + ' ...NG(Write Fail)';
            SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
            Exit(False);
          end;
        end;

        //--------------------------------- Verify EepromFlashAccess
        sDebug := Format('[EEPROM] READ 0x%0.2x 0x%0.2x',[nDevAddr,nRegAddr]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
        nRtn := Pg[Self.FPgNo].SendI2cRead(1,nDevAddr,nRegAddr);
        //{$IFDEF SIMULATOR_PANEL}
      //if bEnable then Pg[self.FPgNo].FRxDataSpi.Data[0] := $41
      //else            Pg[self.FPgNo].FRxDataSpi.Data[0] := $01;
        //{$ENDIF}
        if nRtn <> WAIT_OBJECT_0 then begin
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...Retry');
          nRtn := Pg[Self.FPgNo].SendI2cRead(1,nDevAddr,nRegAddr);
          if nRtn <> WAIT_OBJECT_0 then begin
            if nRtn = WAIT_TIMEOUT then sDebug := sDebug + ' ...NG(Read Timeout)'
            else                        sDebug := sDebug + ' ...NG(Read Fail)';
            SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
            Exit(False);
          end;
        end;
        if Pg[self.FPgNo].FRxDataSpi.Data[0] <> btBuf[0] then begin
          sDebug := Format('[EEPROM] Verify Data : 0x%0.2x ...NG (<> 0x%0.2x)',[Pg[self.FPgNo].FRxDataSpi.Data[0],btBuf[0]]);
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          Exit(False);
        end;
        sDebug := Format('[EEPROM] Verify Data : 0x%0.2x',[Pg[self.FPgNo].FRxDataSpi.Data[0]]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      end;
      Result := True;

      //--------------------------------- Power Reset
      if bPowerResetIfChanged then begin
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power Off');
        m_Inspect.PowerOn := False;
        Pg[FPgNo].SendPgPowerOn(0); // power off
        nPwrOffDelay := Common.TestModelInfo2[FChNo].PwrOffDelayMsec;
        if nPwrOffDelay > 0 then begin
          sDebug := Format('Delay %d ms',[nPwrOffDelay]);
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
          Sleep(nPwrOffDelay);
        end;

        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'Power On');
        m_Inspect.PowerOn := True;
        Pg[FPgNo].SendPgPowerOn(1); // power On
        nPwrOnDelay := Common.TestModelInfo2[FChNo].PwrOnDelayMsec;
        if (bEnable and (nPwrOnDelay <= 500)) then nPwrOnDelay := nPwrOnDelay * 2;  // 2021-05-10
        if nPwrOnDelay > 0 then begin
          sDebug := Format('Delay %d ms',[nPwrOnDelay]);
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
          Sleep(nPwrOnDelay);
        end;
      end;

    end;  // with Common.TestModelInfo2[FChNo]
    Result := True;
  finally
    //---------------------------------- Enable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(True{bEnable});
  end;
end;

function TLogic.FlashCBDataWrite(const transData : TFileTranStr): Boolean;
var
  nRtn  : DWORD;
  nStartAddr{, nEndAddr} : Integer;
  nSize : UInt32;
  sDebug, sFunc, sTempFunc, sMLog, sReason : string;
  FlashAccessParam : TFlashAccessParamRec;
  nDelay : Integer;
begin
  sMLog   := 'FLASH Write - ';
  sFunc   := '';
  sReason := '';
	Result := False;

  try
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(False{bEnable});

    //---------------------------------- Get Flash Access Info
    nSize := transData.TotalSize;
    nStartAddr := Common.TestModelInfo2[FPgNo].FlashCBDataAddr.nStartAddr;
  //nEndAddr   := Common.TestModelInfo2[FPgNo].FlashCBDataAddr.nEndAddr;
  //if nEndAddr < nStartAddr then begin
  //  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sMLog+'NG(CBDATA Addr)', DefPocb.LOG_TYPE_NG);
  //  Exit(False);
  //end;
    FlashAccessParam := Common.TestModelInfo2[FPgNo].FlashAccessParam;

    //---------------------------------- Ext_Flash_Access(0x0020) - Enable
    sFunc  := 'ExtFlashAccess(Enable)';
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

    Sleep(FlashAccessParam.AccEnableBeforeDelayMsec);
    nRtn := Pg[FPgNo].SendSpiFlashAccess(1{nMode:0=Disable,1=Enable});
    if (nRtn <> WAIT_OBJECT_0) then begin
      Sleep(100);
      nRtn := Pg[FPgNo].SendSpiFlashAccess(1{nMode:0=Disable,1=Enable});
      if (nRtn <> WAIT_OBJECT_0) then begin
        if (nRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
        sDebug := sMLog+sFunc+' ...NG('+sReason+')';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
        Exit(False);
      end;
    end;
    Sleep(FlashAccessParam.AccEnableAfterDelayMsec);

    if Common.SystemInfo.SPI_TYPE = SPI_TYPE_DJ023_SPI then begin
      //---------------------------------- Ext_Flash_Init(0x0032)
      sFunc  := 'ExtFlashInit';
      sDebug := sMLog+sFunc;
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      Sleep(FlashAccessParam.InitBeforeDelayMsec);
      nRtn := Pg[FPgNo].SendSpiFlashInit;
      if (nRtn <> WAIT_OBJECT_0) then begin
        Sleep(100);
        nRtn := Pg[FPgNo].SendSpiFlashInit;
        if (nRtn <> WAIT_OBJECT_0) then begin
          if (nRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
          sDebug := sMLog+sFunc+' ...NG('+sReason+')';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          Exit(False);
        end;
      end;
      Sleep(FlashAccessParam.InitAfterDelayMsec);
    end;

    //---------------------------------- QSPI Erase(0x0024) - Block, start addr, file size
    // erase wait (param csv) & check erase ack
    sFunc  := Format('Erase(0x%0.8x,%d)',[nStartAddr,nSize]);
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    Sleep(FlashAccessParam.EraseBeforeDelayMsec);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE, '', DefPocb.FLASH_PROGRESS_ERASE_START); //2021-05
    nRtn := Pg[FPgNo].SendSpiFlashErase($D8{nMode:0xC7=Chip,0xD8=Block,0x20=Sector},nStartAddr,nSize,FlashAccessParam.EraseAckWaitSec*1000);
    if (nRtn <> WAIT_OBJECT_0) then begin
    //Sleep(100);
    //nRtn := Pg[FPgNo].SendQSPIErase($D8{nMode:0xC7=Chip,0xD8=Block,0x20=Sector},nStartAddr,nSize,FlashAccessParam.EraseAckWaitSec*1000);
    //if (nRtn <> WAIT_OBJECT_0) then begin
        if (nRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
        sDebug := sMLog+sFunc+' ...NG('+sReason+')';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
        Exit(False);
    //end;
    end;
    Sleep(FlashAccessParam.EraseAfterDelayMsec);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE, '', DefPocb.FLASH_PROGRESS_ERASE_END); //2021-05

    //---------------------------------- QSPI Write (0x0026) , 'S', start addr, file size <- flash write start
    sFunc  := Format('START(0x%0.8x,%d)',[nStartAddr,nSize]);
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    Sleep(FlashAccessParam.DataStartBeforeDelayMsec);
    nRtn := Pg[FPgNo].SendSpiFlashWrite_StartEnd(DefPG.PGSPI_DOWNLOAD_START, nStartAddr,transData.TotalSize,FlashAccessParam.DataStartAckWaitSec*1000);
    if (nRtn <> WAIT_OBJECT_0) then begin
      if (nRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
      sDebug := sMLog+sFunc+' NG('+sReason+')';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      Exit(False);
    end;
    Sleep(FlashAccessParam.DataStartAfterDelayMsec);

    //---------------------------------- TX Data (1024 bytes per packet)
    // inter-packet delay (param csv)
    sFunc  := 'TX_DATA';
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    nRtn := Pg[FPgNo].SendSpiFlashWriteCBData(transData,FlashAccessParam.DataSendInterDelayMsec);
    if (nRtn <> WAIT_OBJECT_0) then begin
      if (nRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
      sDebug := sMLog+sFunc+' ...NG('+sReason+')';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      Exit(False);
    end;

    //---------------------------------- QSPI Write (0x0026) , 'E', chksum
    // end ack wait (param csv) & check erase ack
    sFunc  := Format('END(0x%0.8x,0x%0.8x)',[nStartAddr,transData.Checksum]);
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    Sleep(FlashAccessParam.DataEndBeforeDelayMsec);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE, '', DefPocb.FLASH_PROGRESS_ENDACK_START); //2021-05
    nRtn := Pg[FPgNo].SendSpiFlashWrite_StartEnd(DefPG.PGSPI_DOWNLOAD_END, transData.Checksum,0{nSize:dummy}, FlashAccessParam.DataEndAckWaitSec*1000);
    if (nRtn <> WAIT_OBJECT_0) then begin
      if (nRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
      sDebug := sMLog+sFunc+' ...NG('+sReason+')';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      Exit(False);
    end;
    Sleep(FlashAccessParam.DataEndAfterDelayMsec);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE, '', DefPocb.FLASH_PROGRESS_ENDACK_END); //2021-05

	  Result := True;
  //================
  finally
    //---------------------------------- Ext_Flash_Access(0x0020) - Disable
    sFunc  := 'ExtFlashAccess(Disable)';
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    Sleep(FlashAccessParam.AccDisableBeforeDelayMsec);
    nRtn := Pg[FPgNo].SendSpiFlashAccess(0{nMode:0=Disable,1=Enable});
    if (nRtn <> WAIT_OBJECT_0) then begin
      Sleep(100);
      nRtn := Pg[FPgNo].SendSpiFlashAccess(0{nMode:0=Disable,1=Enable});
      if (nRtn <> WAIT_OBJECT_0) then begin
        if (nRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
        sDebug := sMLog+sFunc+' ('+sReason+')';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      end;
    end;
    Sleep(FlashAccessParam.AccDisableAfterDelayMsec);
    //---------------------------------- Enable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(True{bEnable});
  end;
end;

function TLogic.PucCtrlPocbOnOff(bOn: Boolean): Boolean;  //2022-07-15 UNIFORMITY_PUCONOFF
var
  btBuf : TIdBytes;
  dwRtn : DWORD;
  {$IFDEF PANEL_AUTO}
  nTconAddr : Integer;
  {$ENDIF}
  nDevice, nRegister, nValue : Integer;
  bValue : Boolean;
  sDebug : string;
  TconWrite : TTConWriteRec;
begin
  Result := False;
  try
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(False{bEnable});
    //
    with Common.TestModelInfo2[FChNo] do begin
      SetLength(btBuf,1);
      // Get Write Info (TConAddr->DevAddr/RegAddr,Value)
      if bOn then TconWrite := TConParam.PocbOnOff[1]  //On
      else        TconWrite := TConParam.PocbOnOff[0]; //Off
      {$IFDEF PANEL_AUTO}
      nTconAddr := TconWrite.nTconAddr;
      Common.GetTCon2DevRegAddr(nTconAddr, nDevice,nRegister);
      {$ELSE}
      nDevice   := TconWrite.nDevAddr;
      nRegister := TconWrite.nRegAddr;
      {$ENDIF}
      nValue    := TconWrite.nValue;
      bValue    := TconWrite.bValue;
      {$IFDEF PANEL_AUTO}
      sDebug := Format('PUC %s: TConAddr(%d): Dev(0x%0.2x) Reg(0x%0.2x) ',[TernaryOp(bOn,'ON','OFF'),nTconAddr,nDevice,nRegister]);
      {$ELSE}
      sDebug := Format('PUC %s: Dev(0x%0.2x) Reg(0x%0.2x) ',[TernaryOp(bOn,'ON','OFF'),nDevice,nRegister]);
      {$ENDIF}
      if bValue then sDebug := sDebug + Format('Value(0x%0.2x)',[nValue])
      else           sDebug := sDebug + 'Value(----)';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      // Check Write Info (DevAddr,RegAddr,Value)
      if (nDevice = 0) then Exit;
      if (nRegister = 0) then Exit;
      if (not bValue) then Exit;
      // Write
      {$IFDEF PANEL_AUTO}
      sDebug := Format('[TCON] WRITE Addr(%d): 0x%0.2x',[nTconAddr,nValue]);
      {$ELSE}
      sDebug := Format('[TCON] WRITE Dev(0x%0.2x) Reg(0x%0.4x): 0x%0.2x',[nDevice,nRegister,nValue]);
      {$ENDIF}
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      btBuf[0] := nValue;
      {$IFDEF PANEL_AUTO}
      dwRtn := Pg[FChNo].SendI2cWrite(1{DataCnt},nDevice,nRegister,btBuf, True{Is1Byte}); //TCon:RegAddr(1Byte)
      {$ELSE}
      dwRtn := Pg[FChNo].SendI2cWrite(1{DataCnt},nDevice,nRegister,btBuf, False{Is1Byte});
      {$ENDIF}
      if dwRtn <> WAIT_OBJECT_0 then begin
			  Sleep(100);
	      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...retry');
        {$IFDEF PANEL_AUTO}
	      dwRtn := Pg[FChNo].SendI2cWrite(1{DataCnt},nDevice,nRegister,btBuf, True{Is1Byte}); //TCon:RegAddr(1Byte)
        {$ELSE}
        dwRtn := Pg[FChNo].SendI2cWrite(1{DataCnt},nDevice,nRegister,btBuf, False{Is1Byte});
        {$ENDIF}
			end;
      if dwRtn <> WAIT_OBJECT_0 then begin
        if dwRtn = WAIT_TIMEOUT then sDebug := sDebug+' ...NG(Write Timeout)'
        else                         sDebug := sDebug+' ...NG(Write Error)';
	      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug,DefPocb.LOG_TYPE_NG);
        Exit;
      end;
      Sleep(10);
      // Verify(Read+Compare)
      {$IFDEF PANEL_AUTO}
      sDebug := Format('[TCON] READ Addr(%d)',[nTconAddr]);
      {$ELSE}
      sDebug := Format('[TCON] READ Dev(0x%0.2x) Reg(0x%0.4x)',[nDevice,nRegister]);
      {$ENDIF}
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      {$IFDEF PANEL_AUTO}
      dwRtn := Pg[FChNo].SendI2cRead(1{DataCnt},nDevice,nRegister, True{Is1Byte}); //TCon:RegAddr(1Byte)
      {$ELSE}
      dwRtn := Pg[FChNo].SendI2cRead(1{DataCnt},nDevice,nRegister, False{Is1Byte});
      {$ENDIF}
      if dwRtn <> WAIT_OBJECT_0 then begin
			  Sleep(100);
	      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...retry');
			end;
      if dwRtn <> WAIT_OBJECT_0 then begin
        if dwRtn = WAIT_TIMEOUT then sDebug := sDebug+' ...NG(Read Timeout)'
        else                         sDebug := sDebug+' ...NG(Read Error)';
	      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
        Exit;
      end;
			//Compare
      if Pg[FChNo].FRxDataSpi.Data[0] <> btBuf[0] then begin
        sDebug := Format('[TCON] Verify Data : 0x%0.2x ...NG(<> 0x%0.2x)',[Pg[FChNo].FRxDataSpi.Data[0],btBuf[0]]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug,DefPocb.LOG_TYPE_NG);
        Exit;
      end;
      sDebug := Format('[TCON] Verify Data : 0x%0.2x',[Pg[FChNo].FRxDataSpi.Data[0]]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      Result := True;
    end;
  finally
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    Pg[FPgNo].SetCyclicTimerSpi(True{bEnable});
  end;
end;

//******************************************************************************
//
//    Logic -> Main : WMCopy: TYPE_HOST, MES_PCHK or MES_EICR, ChannelNo
//
// [PROC/FUNC] procedure TLogic.SendPCHK
//    Called-by: pprocedure TfrmTest1Ch.getBcrData(sScanData: string);
//******************************************************************************
procedure TLogic.SetMesResultInfo(nMesCode : Integer; Fail_Message, Result, DefectCode, DefectName, DefectMesCode, Rwk: String);
var
  mesCode : TMesNgCodes4POCB;
  sTemp   : string;
begin

  m_Inspect.Fail_Message  := Fail_Message;
  m_Inspect.Result        := Result;
  m_Inspect.DefectName    := DefectName;
  m_Inspect.DefectCode    := DefectCode;
  m_Inspect.DefectMesCode := DefectMesCode;
  sTemp                   := Rwk;

  //v2에서 CSV 분리됨에 따라 코드 추가 - 19.12.10
  //nMesCode는 임의로 값을 주고 Csv에서 내용을 맞춘다
  //지금은 PDn에 맞춰서 설정
  {$IFNDEF POCB_F2CH}
  if (nMesCode >= 0) and (nMesCode <= DefGmes.POCB_MES_CODE_MAX) then begin
    mesCode := Common.GetMesCode4Pocb(nMesCode);
    m_Inspect.DefectCode    := mesCode.DefectCode;
    m_Inspect.DefectMesCode := mesCode.MesCodeSummary;
    sTemp                   := mesCode.MesCodeRwk;
  end;
  {$ENDIF}

  if DongaGmes <> nil then Common.MesData[FChNo].Rwk := sTemp;
end;

procedure TLogic.SendGmesMsg(nMsgType: Integer);
var
  nFlowSeq   : Integer;
  ccd        : TCopyDataStruct;
  MainMesMsg : RSyncHost;
begin
  {$IFDEF SUPPORT_1CG2PANEL}
  if Common.SystemInfo.UseAssyPOCB then begin
    case nMsgType of
      DefGmes.MES_INS_PCHK,
      DefGmes.MES_RPR_EIJR: begin
        if ((FChNo = DefPocb.CH_1) and (not Common.TestModelInfo2[FChNo].AssyModelInfo.UseMainPidCh1)) or
           ((FChNo = DefPocb.CH_2) and (not Common.TestModelInfo2[FChNo].AssyModelInfo.UseMainPidCh2)) then begin
          Exit;
        end;
      end;
    end;
  end;
  {$ENDIF} //SUPPORT_1CG2PANEL

  //
  case nMsgType of
    DefGmes.MES_PCHK, DefGmes.MES_INS_PCHK : nFlowSeq := DefPocb.POCB_SEQ_MES_PCHK; //2019-11-08
    DefGmes.MES_EICR, DefGmes.MES_RPR_EIJR : nFlowSeq := DefPocb.POCB_SEQ_MES_EICR; //2019-11-08
    else nFlowSeq := DefPocb.POCB_SEQ_UNKNOWN;
  end;
  if nFlowSeq <> DefPocb.POCB_SEQ_UNKNOWN then begin
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,'',nFlowSeq,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
  end;
  //
{$IFDEF SITE_LENSVN}
  case nMsgType of
    DefGmes.MES_PCHK, DefGmes.MES_INS_PCHK : DongaGmes.SendHostPchk(m_Inspect.SerialNo, FChNo);
    DefGmes.MES_EICR, DefGmes.MES_RPR_EIJR : begin
      if m_Inspect.DefectCode <> 'PD04' then DongaGmes.SendHostEicr(m_Inspect.SerialNo, FChNo);
    end;
  end;


{$ELSE}
  MainMesMsg.MsgType := MSG_TYPE_HOST;
  MainMesMsg.MsgMode := nMsgType;
  MainMesMsg.Channel := Self.FPgNo;
  MainMesMsg.bError  := False;
  MainMesMsg.Msg     := '';
  ccd.dwData :=  0;
  ccd.cbData := SizeOf(MainMesMsg);
  ccd.lpData := @MainMesMsg;
  SendMessage(m_MainHandle ,WM_COPYDATA,0, LongInt(@ccd));
{$ENDIF}
end;

procedure TLogic.RunMesEventSeq(event: Integer);
var
  sDebug : string;
  nSubPidCh : Integer;
begin
  if event = 0 then Exit; //TBD:LENS:MES?

  case event of
		//-----------------------------
    DefGMes.MES_PCHK, DefGMes.MES_INS_PCHK : begin  //2019-11-08
  		if (not Common.m_bMesOnline) then Exit;
    	//----- Get PCHK Send Result
      if Common.MesData[FChNo].PchkSendNg then begin  //TBD?
        SendStopSeq;
      	Exit;
    	end;
    	//----- Get PCHK_R.RTN_CD
{$IFDEF SITE_LENSVN}
    	if Common.MesData[FChNo].PchkRtnCd <> IntToStr(HTTP_STATUS_CODE_200) then begin
      //if event = DefGMes.MES_PCHK then sDebug := 'MES START.RESP NG' else sDebug := 'MES START.RESP NG';
      //Common.MLog(FChNo,sDebug);
        SendStopSeq;
      	Exit;
    	end;
{$ELSE}
    	if Common.MesData[FChNo].PchkRtnCd <> '0' then begin
        if event = DefGMes.MES_PCHK then sDebug := 'PCHK_R.RTN_CD NG' else sDebug := 'INS_PCHK_R.RTN_CD NG'; Common.MLog(FChNo,sDebug);
        SendStopSeq;
      	Exit;
    	end;
{$ENDIF}
    end;
		//-----------------------------
    DefGMes.MES_EICR, DefGMes.MES_RPR_EIJR : begin  //2019-11-08
		  if (not Common.m_bMesOnline) then Exit;
    	//----- Get EICR Send Result
      if Common.MesData[FChNo].EicrSendNg then begin  //TBD?
        SendStartSeq4;
      	Exit;
    	end;
    	//----- Get EICR_R.RTN_CD
{$IFDEF SITE_LENSVN}
    	if Common.MesData[FChNo].EicrRtnCd <> '200' then begin  //TBD:LENS:MES?
        if event = DefGMes.MES_EICR then sDebug := 'MES END.RESP NG' else sDebug := 'MES END.RESP NG'; Common.MLog(FChNo,sDebug);
        SendStartSeq4;
        Exit;
    	end;
{$ELSE}
    	if Common.MesData[FChNo].EicrRtnCd <> '0' then begin
        if event = DefGMes.MES_EICR then sDebug := 'EICR_R.RTN_CD NG' else sDebug := 'RPR_EIJR_R.RTN_CD NG'; Common.MLog(FChNo,sDebug);
        SendStartSeq4;
        Exit;
    	end;
{$ENDIF}

      {$IFDEF USE_EAS}
    	//----- Send MES_APDR|EAS_APDR
      if Common.SystemInfo.EAS_UseAPDR and (DongaGmes <> nil) and (DongaGmes.easCommTibRv <> nil) then begin
        Common.MesData[FChNo].ApdrApdInfo := MakeApdrApdInfo;
        {$IFDEF USE_MES_APDR}
        SendGmesMsg(DefGmes.MES_APDR);
        {$ELSE}
        SendGmesMsg(DefGmes.EAS_APDR);
        {$ENDIF} //USE_MES_APDR
        {$IFDEF SUPPORT_1CG2PANEL}
        if Common.SystemInfo.UseAssyPOCB then begin
          if FChNo = DefPocb.CH_1 then nSubPidCh := DefPocb.CH_2 else nSubPidCh := DefPocb.CH_1;
          Common.MesData[nSubPidCh].ApdrApdInfo := MakeApdrApdInfo;
          {$IFDEF USE_MES_APDR}
          Logic[nSubPidCh].SendGmesMsg(DefGmes.MES_APDR);
          {$ELSE}
          Logic[nSubPidCh].SendGmesMsg(DefGmes.EAS_APDR);
          {$ENDIF}
        end;
        {$ENDIF} //SUPPORT_1CG2PANEL
        Exit;
      end;
      {$ENDIF} //USE_EAS
      SendStartSeq4;
		end;
{$IFDEF USE_EAS}
  {$IFDEF USE_MES_APDR}
		//-----------------------------
    DefGMes.MES_APDR: begin
		if (not Common.m_bMesOnline) then Exit;
    	//----- Get MES_APDR Send Result
      if Common.MesData[FChNo].MesApdrSendNg then begin  //TBD?
        SendStartSeq4;
      	Exit;
    	end;
    	//----- Get MES APDR_R.RTN_CD
    	if Common.MesData[FChNo].MesApdrRtnCd <> '0' then begin
      //SendStartSeq4;  //2019-07-01 (for EAS APDR) //TBD(MES APDR_R NG시, EAS_APDR 송신 여부?)
      //Exit;           //2019-07-01 (for EAS APDR) //TBD(MES APDR_R NG시, EAS_APDR 송신 여부?)
    	end;
    	//----- Send EAS_APDR
      if Common.SystemInfo.EAS_UseAPDR and (DongaGmes <> nil) and (DongaGmes.easCommTibRv <> nil) then begin
        SendGmesMsg(DefGmes.EAS_APDR);
        Exit;
      end;
      SendStartSeq4;
		end;
  {$ENDIF} //USE_MES_APDR
		//-----------------------------
    DefGMes.EAS_APDR: begin
		if (not Common.m_bMesOnline) then Exit;
    	//----- Get EAS_APDR Send Result
      if Common.MesData[FChNo].EasApdrSendNg then begin  //TBD?
        SendStartSeq4;
      	Exit;
    	end;
    	//----- Get EAS APDR_R.RTN_CD
    	if Common.MesData[FChNo].EasApdrRtnCd <> '0' then begin
        SendStartSeq4;  //2019-07-01 (for EAS APDR) //TBD(MES APDR_R NG시, EAS_APDR 송신 여부?)
        Exit;           //2019-07-01 (for EAS APDR) //TBD(MES APDR_R NG시, EAS_APDR 송신 여부?)
    	end;
      SendStartSeq4;
		end;
{$ENDIF}
  end;
end;

{$IFDEF DFS_HEX}
function TLogic.WorkDfsFunc : Boolean;
var
  th : TThread;
begin
  Result := False;
  m_Inspect.DfsUploadResult := DfsUploadNG;

  if Common.DfsConfInfo.bUseDfs then Exit; //2023-04-10
  if (Length(Common.DfsConfInfo.sDfsServerIP) = 0) or (Length(Common.DfsConfInfo.sDfsUserName) = 0) or (Length(Common.DfsConfInfo.sDfsPassword) = 0) then Exit; //2023-04-10
  if (Common.m_sBinFullName[FChNo] = '') {or (Common.m_sBinFileName[FChNo] = '')} then Exit;

  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'<DFS> CBDATA File Upload Start');
  //
//th := TThread.CreateAnonymousThread(procedure var bUploadRtn: Boolean; begin
    try
      DfsFtpCh[FChNo].Connect;
      Result := DfsFtpCh[FChNo].DfsHexFilesUpload(trim(m_Inspect.SerialNo), m_Inspect.TimeStart, Common.m_sBinFullName[FChNo], 0{Hex});
			if Result then m_Inspect.DfsUploadResult := DfsUploadOK;
    except
      Result := False;
    end;
    //
    try
      if DfsFtpCh[FChNo].IsConnected then begin
        DfsFtpCh[FChNo].Disconnect;
      end;
    except
    end;
    //
//  Synchronize(nil,procedure begin
//    if Result then m_Inspect.DfsUploadResult := DfsUploadOK;
//  end);
//end);
//th.FreeOnTerminate := True;
//th.Start;
  //
  if Result then SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'<DFS> CBDATA File Upload OK')
	else           SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,'<DFS> CBDATA File Upload NG', DefPocb.LOG_TYPE_NG);
  //2021-12-21 Delete!!! Sleep(500); //2019-09-03 !!!!!

	if (Result and Common.DfsConfInfo.bDfsHexDelete) then DeleteFile(Common.m_sCBDataFullName[FChNo]); //2022-08-18 (Moved from CamProc)
end;
{$ENDIF}

//----------------------------------------------------------------------------
// [Note] EAS APDR 실처리보고 항목 (2019-06-20) 
//  - 2019-06-20 LGD 정의 POCB APDR 실처리 항목은 SummmaryCsv 항목과 일치함. 
//  - 따라서, 추후 SummaryCsv 항목 변경시, APDR 실처리항목에 반영 여부 검토/협의 필요함 !!!
//----------------------------------------------------------------------------
function TLogic.MakeApdrApdInfo : string;
var
  sRet, sTemp : string; // sRet: ApdrInfo string
  sItemName, sItemValue, sCsvHeader, sCsvValues : string; // for Apdr CSV
  i, j : Integer;
  sPgVer, sUnitTact, sUi, sPidFromBcr : string;
  sList : TStringList;
  sArrValues : TArray<string>;

  procedure AppendApdrItem;
  begin
    if sRet <> '' then sRet := sRet + ',';
	  sRet := sRet + sItemName + sItemValue;
    //
    if sCsvHeader <> '' then sCsvHeader := sCsvHeader + ',';
    sCsvHeader := sCsvHeader + sItemName;
    if sCsvValues <> '' then sCsvValues := sCsvValues + ',';
    sCsvValues := sCsvValues + sItemValue;
  end;

begin
	sRet := '';
  sCsvHeader := ''; sCsvValues := '';

//{$IFDEF PANEL_AUTO}  //2019-09-03 //2022-09-15
	// 실처리 Group명: POCB_RESULT --------------
	sItemName := 'PUC_INFO:USERID:';            sItemValue := Common.m_sUserId;        AppendApdrItem;
	sItemName := 'PUC_INFO:EQUIPMENT:';         sItemValue := Common.SystemInfo.EQPId; AppendApdrItem;
	sItemName := 'PUC_INFO:CH:';                sItemValue := Format('%d',[FChNo+1]);  AppendApdrItem;
  if Common.TestModelInfo2[FChNo].BcrScanMesSPCB and Common.MesData[FChNo].bRxPchkRtnPid then sTemp := Common.MesData[FChNo].PchkRtnPid  //2021-12-30 (Lucid: PchkRtnPid)
  else                                                                                        sTemp := m_Inspect.PanelID;
	sItemName := 'PUC_INFO:PANEL_ID:';         sItemValue := sTemp;                     AppendApdrItem;
  if (Trim(m_Inspect.Result) = 'PASS') then sTemp := 'PASS'
  else                                      sTemp := TernaryOp((m_Inspect.DefectCode<>''),m_Inspect.DefectCode,'PD01');
	sItemName := 'PUC_INFO:FINAL_RESULT:';     sItemValue := sTemp;                     AppendApdrItem;
  if (Trim(m_Inspect.Result) = 'PASS') then sTemp := ''
  else begin 
    sTemp := TernaryOp((m_Inspect.DefectCode<>''), m_Inspect.Fail_Message, 'STOP by Operator');
    sTemp := stringreplace(sTemp, ' ', '_', [rfReplaceAll, rfIgnoreCase]);
  end;
	sItemName := 'PUC_INFO:FAILED_MSG:';       sItemValue := sTemp;                     AppendApdrItem;
	sItemName := 'PUC_INFO:STARTTIME:';        sItemValue := FormatDateTime('YYYYMMDDhhnnss',m_Inspect.TimeStart);  AppendApdrItem;
  m_Inspect.TimeEnd := now;  //2019-07-08 (ADPR 송신시 임시로 EndTime 설정함. 사유: 시점이 Total Tact End 시점인 CSV 생성 시점 이전임)
	sItemName := 'PUC_INFO:ENDTIME:';          sItemValue := FormatDateTime('YYYYMMDDhhnnss',m_Inspect.TimeEnd);	  AppendApdrItem;
	sItemName := 'PUC_INFO:TACTTIME:';         sItemValue := Format('%d',[SecondsBetween(m_Inspect.TimeStart,m_Inspect.TimeEnd)]);         AppendApdrItem;
	sItemName := 'PUC_INFO:MEASURE_TACTTIME:'; sItemValue := Format('%d',[SecondsBetween(m_Inspect.UnitTimeStart,m_Inspect.UnitTimeEnd)]); AppendApdrItem;
	sItemName := 'PUC_INFO:JIG_TACTTIME:';     sItemValue := Format('%d',[SecondsBetween(m_Inspect.JigTimeStart,m_Inspect.JigTimeEnd)]);   AppendApdrItem;
	sItemName := 'PUC_INFO:SW_UI_VER:';        sItemValue := Common.m_sExeVerNameSummary;            AppendApdrItem;
	sItemName := 'PUC_INFO:HW_PG_VER:';
      sItemValue := Format('FW_%s_FPGA_%s',[Pg[FPgNo].m_sFwVerPg,Pg[FPgNo].m_sFpgaVerPg]);
      if (Common.SystemInfo.PG_TYPE <> PG_TYPE_DP489) then
        sItemValue := sItemValue + Format('_ALDP_%s_DLPU_%s',[Pg[FPgNo].m_sALDPVerPg,Pg[FPgNo].m_sDLPUVerPg]);
      AppendApdrItem;
	sItemName := 'PUC_INFO:HW_SPI_VER:';
      sItemValue := Format('FW_%s',[Pg[FPgNo].m_sFwVerSpi]);
      if (Common.SystemInfo.SPI_TYPE <> SPI_TYPE_DJ023_SPI) then
        sItemValue := sItemValue + Format('_BOOT_%s',[Pg[FPgNo].m_sBootVerSpi]);
      AppendApdrItem;
	sItemName := 'PUC_INFO:HW_SLOT_VER:';      sItemValue := '';                                     AppendApdrItem;
	sItemName := 'PUC_INFO:SCRIPT_NAME:';      sItemValue := Common.SystemInfo.TestModel[FChNo];     AppendApdrItem;
	// 실처리 Group명: POCB_RAW --------------
	sItemName := 'PUC_RAW:CRC_MODEL_MCF:';     sItemValue := Common.m_ModelCrc[FChNo].ModelMcf;       AppendApdrItem;
	sItemName := 'PUC_RAW:CRC_MODEL_PARAMCSV:';sItemValue := Common.m_ModelCrc[FChNo].ModelParamCsv;  AppendApdrItem; //2022-09-15
	sItemName := 'PUC_RAW:CB_ALGORITHM_VER:';  sItemValue := CameraComm.m_csvCamData[FChNo].VerStr;   AppendApdrItem;
	sItemName := 'PUC_RAW:CRC_CB_ALGORITHM:';  sItemValue := Common.m_ModelCrc[FChNo].CB_Algorithm;   AppendApdrItem;
	sItemName := 'PUC_RAW:CRC_CAM_PARAM:';     sItemValue := Common.m_ModelCrc[FChNo].Cam_Parameter;  AppendApdrItem;
	sItemName := 'PUC_RAW:VCC:';         sItemValue := Format('%0.2f',[m_Inspect.PwrData.VCC / 1000]);         AppendApdrItem;
	sItemName := 'PUC_RAW:ICC:';         sItemValue := Format('%d',[m_Inspect.PwrData.ICC]);                   AppendApdrItem;
{$IFDEF PANEL_AUTO}	
	sItemName := 'PUC_RAW:VDD:';         sItemValue := Format('%0.2f',[m_Inspect.PwrData.VDD_VEL / 1000]);     AppendApdrItem;
	sItemName := 'PUC_RAW:IDD:';         sItemValue := Format('%d',[m_Inspect.PwrData.IDD_IEL]);               AppendApdrItem;
{$ELSE}
	sItemName := 'PUC_RAW:VEL:';         sItemValue := Format('%0.2f',[m_Inspect.PwrData.VDD_VEL / 1000]);     AppendApdrItem;
	sItemName := 'PUC_RAW:IEL:';         sItemValue := Format('%d',[m_Inspect.PwrData.IDD_IEL]);               AppendApdrItem;
{$ENDIF}	
	sItemName := 'PUC_RAW:JUDGE_COUNT:'; sItemValue := Format('%d',[Common.TestModelInfo2[FChNo].JudgeCount]); AppendApdrItem;
  for i := 0 to DefPocb.UNIFORMITY_PATTERN_MAX do begin
    if Common.TestModelInfo2[FChNo].JudgeCount > i then begin
	    sItemName := Format('PUC_RAW:PTN%d_RESULT_UNIFORMITY:',[i+1]); sItemValue := Trim(m_Inspect.UniformityResult[i]);           AppendApdrItem;
      if Common.TestModelInfo2[FChNo].UseCustumPatName then sTemp := Trim(Common.TestModelInfo2[FChNo].ComparePatName[i])
      else                                                  sTemp := Trim(FPatGrp.PatName[Common.TestModelInfo2[FChNo].ComparedPat[i]]);
	    sItemName := Format('PUC_RAW:PTN%d_JUDGE:',[i+1]);             sItemValue := sTemp;                                         AppendApdrItem;
	    sItemName := Format('PUC_RAW:PTN%d_PREUNIFORMITY:',[i+1]);     sItemValue := Format('%0.1f',[m_Inspect.UniformityPre[i]]);  AppendApdrItem;
	    sItemName := Format('PUC_RAW:PTN%d_POSTUNIFORMITY:',[i+1]);    sItemValue := Format('%0.1f',[m_Inspect.UniformityPost[i]]); AppendApdrItem;
      if Common.SystemInfo.UseUniformityPoint then begin
        sArrValues := m_Inspect.UniformityPointsPre[i].Split([',']);
        for j := 0 to Pred(DefPocb.UNIFORMITY_POINT_COUNT) do begin  //2022-07-15 (Pre_%d_%.2d -> PTN%d_PREPOINT%.2d)
	        sItemName  := Format('PUC_RAW:PTN%d_PREPOINT%.2d:',[i+1,j+1]);  sItemValue := TernaryOp((Length(sArrValues) > j),sArrValues[j],''); AppendApdrItem;
        end;
        sArrValues := m_Inspect.UniformityPointsPost[i].Split([',']);
        for j := 0 to Pred(DefPocb.UNIFORMITY_POINT_COUNT) do begin  //2022-07-15 (Pre_%d_%.2d -> PTN%d_POSTPOINT%.2d)
	        sItemName  := Format('PUC_RAW:PTN%d_POSTPOINT%.2d:',[i+1,j+1]); sItemValue := TernaryOp((Length(sArrValues) > j),sArrValues[j],''); AppendApdrItem;
        end;
      end;
    end
    else begin
	    sItemName  := Format('PUC_RAW:PTN%d_RESULT_UNIFORMITY:',[i+1]); sItemValue := ''; AppendApdrItem;
	    sItemName  := Format('PUC_RAW:PTN%d_JUDGE_GRAY:',[i+1]);        sItemValue := ''; AppendApdrItem;
	    sItemName  := Format('PUC_RAW:PTN%d_PREUNIFORMITY:',[i+1]);     sItemValue := ''; AppendApdrItem;
	    sItemName  := Format('PUC_RAW:PTN%d_POSTUNIFORMITY:',[i+1]);    sItemValue := ''; AppendApdrItem;
      if Common.SystemInfo.UseUniformityPoint then begin
        for j := 0 to Pred(DefPocb.UNIFORMITY_POINT_COUNT) do begin
	        sItemName  := Format('PUC_RAW:PTN%d_PREPOINT%.2d:',[i+1,j+1]); sItemValue := ''; AppendApdrItem;
        end;
        for j := 0 to Pred(DefPocb.UNIFORMITY_POINT_COUNT) do begin
	        sItemName  := Format('PUC_RAW:PTN%d_POSTPOINT%.2d:',[i+1,j+1]); sItemValue := ''; AppendApdrItem;
        end;
      end;
    end;
  end;
//{$ELSE}
//{$ENDIF}
	//
  Result := sRet;

  m_Inspect.ApdrCsvHeader := sCsvHeader; //2022-08-01
  m_Inspect.ApdrCsvValues := sCsvValues; //2022-08-01
end;

end.
