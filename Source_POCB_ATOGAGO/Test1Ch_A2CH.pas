unit Test1Ch_A2CH;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, Winapi.WinSock,
  System.SysUtils, System.Variants, System.Classes, IdGlobal,
  Vcl.ComCtrls, Vcl.Controls, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.Grids, Vcl.Mask, Vcl.StdCtrls,
  RzButton, RzCommon, RzEdit, RzGrids, RzLabel, RzLine, RzPanel, RzRadChk,
  {AdvGlassButton,} AdvGrid, AdvListV, AdvObj, AdvPanel, AdvSmoothLedLabel, AdvUtil, ALed,
  //
  CamComm, CommonClass, UserID,
  DefPocb, DefDio, DefGmes, DefPG, DefMotion, DioCtl, MotionCtl, MotionCtlAxt,
  DongaPattern, HandBCR, JigControl, LogicPocb, SwitchBtn, UdpServerPocb,
  DefRobot, RobotCtl, DefIonizer, IonizerCtl, UserUtils,
{$IFDEF SITE_LENSVN}
  LensHttpMes,
{$ELSE}
  GMesCom,
{$ENDIF}
  //
  CodeSiteLogging, BaseGrid;

type
	{$IFDEF SUPPORT_1CG2PANEL}
//TStatusType = (OK=0, NG=1, INFO=2, IDLE=3, READY=4, ALREADY=5, SKIP=6); //2022-06-XX SKIP_POCB
	{$ELSE}
//TStatusType = (OK=0, NG=1, INFO=2, IDLE=3, READY=4, ALREADY=5);
	{$ENDIF}

  TfrmTest1Ch = class(TForm)
    tmrTotalTact: TTimer;
    tmrJigTact: TTimer;
    tmrUnitTact: TTimer;
    tmrFlashEraseTact: TTimer;  //2021-05
    tmrFlashWriteAckTact: TTimer; //2021-05
    RzpnlTestMain: TRzPanel;
    PnlRcbSimKeys: TAdvPanel;
    btnRcbSimKey1PrevPat: TRzBitBtn;
    btnRcbSimKey2NextPat: TRzBitBtn;
    btnRcbSimKey3PreCompPat1: TRzBitBtn;
    btnRcbSimKey4CompPat1: TRzBitBtn;
    btnRcbSimKey5PreCompPat2: TRzBitBtn;
    btnRcbSimKey6CompPat2: TRzBitBtn;
    btnRcbSimKey7Vacuum: TRzBitBtn;
    btnRcbSimKey8Stop: TRzBitBtn;
    btnRcbSimKey9StartNext: TRzBitBtn;
    RzgrpMotionStatus: TRzGroupBox;
{$IFDEF HAS_MOTION_CAM_Z}
    ledMotionZaxisLimitPlus: ThhALed;
    RzpnlMotionZaxisLimitPlusTitle: TRzPanel;
    pnlMotionZaxisUnitPulse: TPanel;
    RzpnlMotionZaxisLimitMinusTitle: TRzPanel;
    ledMotionZaxisLimitMinus: ThhALed;
    RzpnlMotionZaxisOnModelPosTitle: TRzPanel;
    ledMotionZaxisOnModelPos: ThhALed;
    RzpnlMotionZaxisOnHomeTitle: TRzPanel;
    ledMotionZaxisOnHome: ThhALed;
    grpMotionZaxis: TGroupBox;
    ledMotionZaxisServoOnOut: ThhALed;
    ledMotionZaxisAlarmOn: ThhALed;
    RzpnlMotionZaxisServoOnOutTitle: TRzPanel;
    RzpnlMotionZaxisUnitPulseTitle: TRzPanel;
    RzpnlMotionZaxisAlarmTitle: TRzPanel;
    RzPnlMotionZaxisCmdPosTitle: TRzPanel;
    pnlMotionZaxisCmdPos: TPanel;
    RzpnlMotionZaxisInPosTitle: TRzPanel;
    ledMotionZaxisInPos: ThhALed;
    RzpnlMotionZaxisServoOnInTitle: TRzPanel;
    ledMotionZaxisServoOnIn: ThhALed;
    pnlMotionZaxisActPosIMSI: TPanel;
{$ENDIF}
    grpMotionYaxis: TGroupBox;
    ledMotionYaxisLimitMinus: ThhALed;
    ledMotionYaxisLimitPlus: ThhALed;
    ledMotionYaxisOnHome: ThhALed;
    ledMotionYaxisOnCamPos: ThhALed;
    ledMotionYaxisServoOnOut: ThhALed;
    ledMotionYaxisAlarmOn: ThhALed;
    pnlMotionYaxisCmdPos: TPanel;
    RzpnlMotionYaxisLimitMinusTitle: TRzPanel;
    RzpnlMotionYaxisLimitPlusTitle: TRzPanel;
    RzpnlMotionYaxisOnHomeTitle: TRzPanel;
    RzpnlMotionYaxisOnCamPosTitle: TRzPanel;
    RzpnlMotionYaxisServoOnOutTitle: TRzPanel;
    RzpnlMotionYaxisAlarmTitle: TRzPanel;
    RzpnlMotionYaxisUnitPulseTitle: TRzPanel;
    RzpnlMotionYaxisCmdPosTitle: TRzPanel;
    pnlMotionYaxisUnitPulse: TPanel;
    ledMotionYAxisOnLoadPos: ThhALed;
    RzpnlMotionYaxisOnLoadPosTitle: TRzPanel;
    RzpnlMotionYaxisServoOnInTitle: TRzPanel;
    ledMotionYaxisServoOnIn: ThhALed;
    GrpChTestNgMsg: TGroupBox;
    lblChTestNgMsg: TLabel;
    lblChTestNgClose: TLabel;
    lblChTestNgHeader: TLabel;
    pnlShowNgConfirm: TAdvPanel;
    btnNgConfirmSendHost: TRzBitBtn;
    btnNgConfirmCancel: TRzBitBtn;
    grpRobot: TGroupBox; // ROBOT Status
    RzpnlRobotAutoMode: TRzPanel;
    RzpnlRobotManualMode: TRzPanel;
    RzpnlRobotError: TRzPanel;
    RzpnlRobotProjRunning: TRzPanel;
    RzpnlRobotProjPause: TRzPanel;
    RzpnlRobotGetControl: TRzPanel;
    RzpnlRobotEstop: TRzPanel;
    RzpnlRobotLightTitle: TRzPanel;
    RzpnlRobotSpeedTitle: TRzPanel;
    RzpnlRobotXYZ: TRzPanel;
    RzpnlRobotRxRyRz: TRzPanel;
    ledRobotAutoMode: ThhALed;
    ledRobotManualMode: ThhALed;
    ledRobotFatalError: ThhALed;
    ledRobotProjRunning: ThhALed;
    ledRobotProjEditing: ThhALed;
    ledRobotProjPause: ThhALed;
    ledRobotGetControl: ThhALed;
    ledRobotEStop: ThhALed;
    pnlRobotSpeedValue: TPanel;
    pnlRobotLightValue: TPanel;
    pnlRobotCoordX: TPanel;
    pnlRobotCoordY: TPanel;
    pnlRobotCoordZ: TPanel;
    pnlRobotCoordRx: TPanel;
    pnlRobotCoordRy: TPanel;
    pnlRobotCoordRz: TPanel;
    pnlRobotLightColor: TPanel;
    tmrRobotLight: TTimer;
    grpPatternDisp: TRzGroupBox;
    DongaPat: TDongaPat;
    RzlnDispPatSigOff1: TRzLine;
    RzlnDispPatSigOff2: TRzLine;
    pnlDispPatName: TPanel;
    grpPatternList: TRzGroupBox;
    gridPatternList: TAdvStringGrid;
    pnlPatGrpName: TPanel;
    pnlMotionYAxisSyncMode: TRzPanel;
    ledMotionYaxisOnSync: ThhALed;
    RzpnlRobotCoordHome: TRzPanel;
    ledRobotCoordHome: ThhALed;
    RzpnlRobotCoordModel: TRzPanel;
    ledRobotCoordModel: ThhALed;
//{$IFDEF SUPPORT_1CG2PANEL}
    pnlShowSkipPocbConfirm: TAdvPanel;
    btnSkipPocbConfirmRUN: TRzBitBtn;
    btnSkipPocbConfirmSKIP: TRzBitBtn;
    RzpnlBcrKbdInput: TAdvPanel;
    btnBcrKbdInputEnter: TRzBitBtn;
    btnBcrKbdInputClear: TRzBitBtn;
    edBcrKbdInputNum: TRzEdit;
    RzgrpScanBcrOtherChMsg: TGroupBox;
    lblScanBcrOtherChMsgVN: TLabel;
    lblScanBcrOtherChClose: TLabel;
    lblScanBcrOtherChHeader: TLabel;
    lblScanBcrOtherChMsgEN: TLabel;
//{$ENDIF}
    procedure btnStartTestClick(Sender: TObject);
    procedure btnStopTestClick(Sender : TObject);
{$IFDEF USE_FPC_LIMIT}
    procedure btnFpcUsageResetClick(Sender: TObject); //2019-04-11 FPC Usage Limit
{$ENDIF}
    procedure btnSpiResetClick(Sender: TObject); //2019-04-29
    procedure btnCntResetClick(Sender: TObject);
    procedure TMLog(nCh: Integer; sMsg: string);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  //procedure gridPatternListClick(Sender: TObject);
    procedure WMCopyData(var Msg : TMessage); message WM_COPYDATA;
    procedure tmrTotalTactTimer(Sender: TObject);
    procedure tmrJigTactTimer(Sender: TObject);
    procedure tmrUnitTactTimer(Sender: TObject);
    procedure tmrFlashEraseTactTimer(Sender: TObject);  //2021-05
    procedure tmrFlashWriteAckTactTimer(Sender: TObject);  //2021-05
    procedure tmrRobotLightTimer(Sender: TObject);  //A2CHv3:ROBOT
    procedure FormDestroy(Sender: TObject);
    procedure btnVirtualKeyClick(Sender: TObject);
    procedure btnRcbSimKey1PreviousPatClick(Sender: TObject);
    procedure btnRcbSimKey2NextPatClick(Sender: TObject);
    procedure btnRcbSimKey3PreCompPat1Click(Sender: TObject);
    procedure btnRcbSimKey4CompPat1Click(Sender: TObject);
    procedure btnRcbSimKey5PreCompPat2Click(Sender: TObject);
    procedure btnRcbSimKey6CompPat2Click(Sender: TObject);
    procedure btnRcbSimKey7VacummClick(Sender: TObject);
    procedure btnRcbSimKey8StopClick(Sender: TObject);
    procedure btnRcbSimKey9StartNextClick(Sender: TObject);
    procedure lblChTestNgCloseClick(Sender: TObject);
    procedure lblScanBcrOtherChCloseClick(Sender: TObject); //2023-08-11
    procedure btnNgConfirmCancelClick(Sender: TObject);
    procedure btnNgConfirmSendHostClick(Sender: TObject);
//{$IFDEF SUPPORT_1CG2PANEL}
    procedure btnSkipPocbConfirmRunClick(Sender: TObject);   //2022-06-XX ASSY:1CG2PANEL:SKIP_POCB
    procedure btnSkipPocbConfirmSkipClick(Sender: TObject);  //2022-06-XX ASSY:1CG2PANEL:SKIP_POCB
//{$ENDIF}
    procedure btnBcrKbdInputEnterClick(Sender: TObject); //2023-06-22
    procedure btnBcrKbdInputClearClick(Sender: TObject);
  private
    GuiFlowSeqToGridIdx : array [0..DefPocb.POCB_SEQ_MAX] of integer;

    m_nNgCnt, m_nOkCnt  : Integer;
    m_nTotalTact, m_nJigTact, m_nUnitTact : Integer;
    m_nFlashEraseTact, m_nFlashWriteAckTact : Integer;
    RzpnlJigMain        : TRzPanel;
    RzpnlJigCommon1     : TRzPanel;
    pnlJigTitle         : TPanel;
    btnStartTest        : TRzBitBtn;
    btnStopTest         : TRzBitBtn;
    btnVirtualKey       : TRzBitBtn;
    rzpnlTactTotalTitle : TRzPanel;
    pnlTactTotalValue   : TPanel;
    rzpnlTactUnitTitle  : TRzPanel;
    pnlTactUnitValue    : TPanel;
    rzpnlTactJigTitle   : TRzPanel;
    pnlTactJigValue     : TPanel;
{$IFDEF USE_FPC_LIMIT}
    rzpnlFpcUsageTitle  : TRzPanel;   //2019-04-11 FPC Usage Limit
    pnlFpcUsageValue    : TPanel;     //2019-04-11 FPC Usage Limit
    btnFpcUsageReset    : TRzBitBtn;  //2019-04-11 FPC Usage Limit
{$ENDIF}
    RzpnlChGrp          : TRzPanel;
    RzpnlModelStatus    : TRzPanel;  //A2CHv3:MULTIPLE_MODEL
    pnlModelName        : TPanel;    //A2CHv3:MULTIPLE_MODEL
{$IFDEF CH_USE_CHECKBOX} //NOT_USED
    rzcbChUsage         : TRzCheckBox;
{$ENDIF}
    cbAutoPowerOff      : TRzCheckBox;
    RzpnlPgStatus       : TRzPanel;
    ledPgStatus         : ThhALed;
    pnlHwVer            : TRzLabel;
    ledSpiStatus        : ThhALed;
    pnlSpiVer           : TRzLabel;
    btnSpiReset         : TRzBitBtn; //2019-04-29
    RzpnlSerials        : TRzPanel;
    pnlSerialNo         : TPanel;
    pnlPCBNo            : TPanel;
    pnlMesResult        : TPanel;
    pnlSelectSendMes    : TPanel;  //TBD:MERGE? A2CHv2?
    pnlChStatus         : TPanel;
    RzpnlTestCnt        : TRzPanel;
    rzpnlCntTotalTitle  : TRzPanel;
    pnlCntTotalValue    : TPanel;
    rzpnlCntOkTitle     : TRzPanel;
    pnlCntOkValue       : TPanel;
    rzpnlCntNgTitle     : TRzPanel;
    pnlCntNgValue       : TPanel;
    btnCntReset         : TRzBitBtn;
    gridChPower         : TAdvStringGrid;
		RzpnlLogGrp 				: TRzPanel;				//2019-05-20 GUI:FlowSeq
		gridFlowSeq 				: TAdvStringGrid;	//2019-05-20 GUI:FlowSeq
		mmChannelLog        : TRichEdit;
    pnlDisplayPattern   : TPanel;

    RzpnlFlashProgress  : TRzPanel;  //2021-05
    rzpnlFlashEraseTitle: TRzPanel;  //2021-05
    pnlFlashEraseValue  : TPanel;    //2021-05
    rzpnlFlashTxTitle   : TRzPanel;  //2021-05
    pnlFlashTxValue     : TPanel;    //2021-05
    rzpnlFlashWriteAckTitle: TRzPanel;  //2021-05
    pnlFlashWriteAckValue  : TPanel;    //2021-05

    pnlInsStatus        : TPanel;
    gridCRCStatus       : TAdvStringGrid;
    RzpnlJigCommon2     : TRzPanel;
  //pnlJigStatus        : TPanel;
	//lblShow        			: TRzLabel;	//TBD:A2CH:GUI? lblShow?
    nPnlJigCmmon2Height : Integer;

    { Private declarations }
    DongaSwitch   : TSerialSwitch;
    procedure CreateGui;
    procedure CreateGridFlowSeq;
    procedure ClearChData;
  //procedure DisplaySysInfo; // TfrmTest4ChGB.DisplaySysInfo;
    //TBD:NOT_USED? procedure DisplayPGStatus(nCh, nType: Integer; sMsg: string);
    procedure cbAutoPowerOffClick(Sender: TObject);
    procedure GetBcrData(sScanData: string);
    procedure ThreadedGetBcrData(sScanData: string); //2023-09-26
    procedure RevSwDataJig(sGetData : String);
    //TBD:NOT_USED?  procedure ShowOkNgCnt(nCh, nTotal, nOk, nNg: Integer);
    function DisplayPatList(sPatGrpName : string) : TPatternGroup;
    procedure ShowJIGStatus(sMsg : string);
    function  CheckOutOfPwr(PwrData : TPwrDataPg; out sErrMsg : string) : Boolean;  //TBD:MERGE? (NOT-USED?)
    procedure DisplayPwrData(nCh : Integer; PwrData : TPwrDataPg);
    procedure ShowDioErr(bEmsReset: Boolean; sMsg: string);
  //procedure arrivedAction(nIdx : Integer);     //TBD?
    function WorkStart : Boolean;
    procedure DisplayPatPrevNext(bNext: Boolean);
    procedure ShowChTestNgMsg(nCh: Integer; sMessage: string);
    procedure ShowFlowSeq(nSeqNo, nSeqResult: Integer); //2019-05-20
    procedure ShowFlashWriteProgress(nFlashProgress: Integer; sMsg: string = ''); //2021-05
    function CheckScanInterlock : Boolean;
    procedure SendMainGuiDisplay(nGuiMode, nCH, nP1: Integer; nP2: Integer; nP3: Integer = 0; sMsg: string = '');
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND; //2018-09-13 TBD?
    procedure DisplayChStatus(status : Integer; sMsg : string = '');
    procedure AppendChannelLog(sMsg: string; nLogType: integer = DefPocb.LOG_TYPE_INFO); //2022-07-30
{$IFDEF SIMULATOR}
    procedure SimFlowThreadTask(nSeqNo: Integer; nSeqResult: Integer);
{$ENDIF}
  protected
    procedure CreateParams(var Params: TCreateParams); override; // ADD THIS LINE! //A2CHv3:GUI
  public
    m_hMain       : THandle;
    pnlJigStatus  : TPanel;
    m_nJig        : Integer;
    m_nCh         : Integer;
    { Public declarations }
    procedure arrivedAction(nIdx : Integer);     //TBD?
    procedure WorkStop(nStopReason: TInspctionStopReason = StopNormal);   //2018-12-11, 2019-01-01 (Private->Pulblic)
    procedure ShowGui(hMain : HWND);
    procedure ShowMotionStatus(nCh: Integer; nAxisType: Integer);
    procedure ShowRobotStatusCoord; //A2CHv3:ROBOT
    procedure SetConfig;
    procedure SetBcrSet;
    procedure SetLanguage(nIdx : Integer);
    //TBD? procedure SetCamConfig;
    procedure UpdatePtList(hMain: HWND);
    procedure ResetChGui(nCh : Integer);
    procedure SetCRCValue(nCol : Integer; sValue : string);
    procedure ClearQuantity;
  end;

var
  frmTest1Ch: array[DefPocb.JIG_A .. DefPocb.JIG_MAX] of TfrmTest1Ch;

implementation

{$R *.dfm}

uses LogIn;
{$R+}

{ TfrmTest1Ch }

//******************************************************************************
// procedure/function: Create/Destroy/Init
//******************************************************************************

procedure TfrmTest1Ch.WMSysCommand(var Msg: TWMSysCommand);  //2018-09-13 GUI(Disable Move or Resize)
begin
  if ((Msg.CmdType and $FFF0) = SC_MOVE) or ((Msg.CmdType and $FFF0) = SC_SIZE) then begin
    Msg.Result := 0;
    Exit;
  end;
  inherited;
end;

procedure TfrmTest1Ch.CreateParams(var Params: TCreateParams);  //A2CHv3:GUI
begin
  inherited;
  Params.style := Params.style and not WS_CAPTION; // for MDI Chile
//Params.Style := Params.Style or WS_THICKFRAME;
end;

procedure TfrmTest1Ch.FormCreate(Sender: TObject);
begin
  m_nOkCnt := 0;
  m_nNgCnt := 0;
  //TBD? (Jig-based Global Attributes?)

  // GUI(Test1Ch:DongaPat)
  DongaPat.DongaImgWidth  := DongaPat.Width;  //TBD???
  DongaPat.DongaImgHight  := DongaPat.Height; //TBD???
  DongaPat.DongaPatPath   := Common.Path.Pattern;
  DongaPat.DongaBmpPath   := Common.Path.BMP;
  DongaPat.LoadPatFile('No Signal');
  DongaPat.LoadAllPatFile;

  //TBD? SetLanguage(Common.SystemInfo.Language);
  if DongaDio <> nil then begin //TBD???
    DongaDio.SetErrMsg := ShowDioErr;
  //DongaDio.ArrivedUnload := arrivedAction;
  end;
{$IFDEF REF_ISPD_L}
  tmrLogOut.Interval := Common.SystemInfo.LogOutTime * 60 * 1000;
{$ENDIF}
end;

procedure TfrmTest1Ch.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if tmrTotalTact <> nil then begin
    tmrTotalTact.Enabled := False;
    tmrTotalTact.Free;
    tmrTotalTact := nil;
  end;
  if tmrJigTact <> nil then begin
    tmrJigTact.Enabled := False;
    tmrJigTact.Free;
    tmrJigTact := nil;
  end;
  if tmrUnitTact <> nil then begin
    tmrUnitTact.Enabled := False;
    tmrUnitTact.Free;
    tmrUnitTact := nil;
  end;
  if tmrFlashEraseTact <> nil then begin  //2021-05
    tmrFlashEraseTact.Enabled := False;
    tmrFlashEraseTact.Free;
    tmrFlashEraseTact := nil;
  end;
  if tmrFlashWriteAckTact <> nil then begin  //2021-05
    tmrFlashWriteAckTact.Enabled := False;
    tmrFlashWriteAckTact.Free;
    tmrFlashWriteAckTact := nil;
  end;

  JigLogic[Self.Tag].Free;
  JigLogic[Self.Tag] := nil;
  DongaSwitch.Free;
  DongaSwitch := nil;
end;

procedure TfrmTest1Ch.FormDestroy(Sender: TObject);
begin
  // Timer
  if tmrTotalTact <> nil then begin
    tmrTotalTact.Enabled := False;
    tmrTotalTact.Free;
    tmrTotalTact := nil;
  end;
  if tmrJigTact <> nil then begin
    tmrJigTact.Enabled := False;
    tmrJigTact.Free;
    tmrJigTact := nil;
  end;
  if tmrUnitTact <> nil then begin
    tmrUnitTact.Enabled := False;
    tmrUnitTact.Free;
    tmrUnitTact := nil;
  end;
  if tmrFlashEraseTact <> nil then begin  //2021-05
    tmrFlashEraseTact.Enabled := False;
    tmrFlashEraseTact.Free;
    tmrFlashEraseTact := nil;
  end;
  if tmrFlashWriteAckTact <> nil then begin  //2021-05
    tmrFlashWriteAckTact.Enabled := False;
    tmrFlashWriteAckTact.Free;
    tmrFlashWriteAckTact := nil;
  end;

  //
  if mmChannelLog <> nil then begin
    mmChannelLog.Free;
    mmChannelLog := nil;
  end;

  if DongaSwitch <> nil then begin
    DongaSwitch.Free;
    DongaSwitch := nil;
  end;
  if JigLogic[Self.Tag] <> nil then begin
    JigLogic[Self.Tag].Free;
    JigLogic[Self.Tag] := nil;
  end;

  if Logic[m_nCh] <> nil then begin
    Logic[m_nCh].Free;
    Logic[m_nCh] := nil;
  end;
end;


//******************************************************************************
// procedure/function: Timer
//******************************************************************************

procedure TfrmTest1Ch.tmrTotalTactTimer(Sender: TObject);
var
  nSec, nMin : Integer;
begin
  Inc(m_nTotalTact);
  nSec := m_nTotalTact mod 60;
  nMin := (m_nTotalTact div 60) mod 60;
  pnlTactTotalValue.Caption := Format('%0.2d : %0.2d',[nMin, nSec]);
end;

//2019-01-12 LGD요청사항(Shutter/Sgate TT),협의(JIG+UNIT TT 추가)
procedure TfrmTest1Ch.tmrJigTactTimer(Sender: TObject);
var
  nSec, nMin : Integer;
begin
  Inc(m_nJigTact);
  nSec := m_nJigTact mod 60;
  nMin := (m_nJigTact div 60) mod 60;
  pnlTactJigValue.Caption := Format('%0.2d : %0.2d',[nMin, nSec]);
end;

procedure TfrmTest1Ch.tmrUnitTactTimer(Sender: TObject);
var
  nSec, nMin : Integer;
begin
  Inc(m_nUnitTact);
  nSec := m_nUnitTact mod 60;
  nMin := (m_nUnitTact div 60) mod 60;
  pnlTactUnitValue.Caption := Format('%0.2d : %0.2d',[nMin, nSec]);
end;

procedure TfrmTest1Ch.tmrRobotLightTimer(Sender: TObject);  //A2CHv3:ROBOT
begin
  if (DongaRobot = nil) then Exit;
  if (not DongaRobot.m_bConnectedModbus[m_nJig]) then Exit;
  //
  try
    tmrRobotLight.Enabled := False;
    case DongaRobot.Robot[m_nJig].m_RobotStatusCoord.RobotLight of
      ROBOT_TM_LIGHT_00_Off_EStop: begin
        pnlRobotLightColor.Color := clGray;
      end;
      ROBOT_TM_LIGHT_01_SolidRed_FatalError: begin
        pnlRobotLightColor.Color := clRed;
      end;
      ROBOT_TM_LIGHT_02_FlashingRed_Initializing: begin
        if (pnlRobotLightColor.Color = clRed) then pnlRobotLightColor.Color := clGray
        else                                       pnlRobotLightColor.Color := clRed;
      end;
      ROBOT_TM_LIGHT_03_SolidBlue_StandbyInAutoMode: begin
        pnlRobotLightColor.Color := clBlue;
      end;
      ROBOT_TM_LIGHT_04_FlashingBlue_AutoMode: begin
        if (pnlRobotLightColor.Color = clBlue) then pnlRobotLightColor.Color := clGray
        else                                        pnlRobotLightColor.Color := clBlue;
      end;
      ROBOT_TM_LIGHT_05_SloidGreen_StandbyInManualMode: begin
        pnlRobotLightColor.Color := clGreen;
      end;
      ROBOT_TM_LIGHT_06_FlashingGreen_ManualMode: begin
        if (pnlRobotLightColor.Color = clGreen) then pnlRobotLightColor.Color := clGray
        else                                         pnlRobotLightColor.Color := clGreen;
      end;
      ROBOT_TM_LIGHT_09_AlterBlueRed_AutoModeError: begin
        if (pnlRobotLightColor.Color = clBlue) then pnlRobotLightColor.Color := clRed
        else                                        pnlRobotLightColor.Color := clBlue;
      end;
      ROBOT_TM_LIGHT_10_AlterGreenRed_ManualModeError: begin
        if (pnlRobotLightColor.Color = clGreen) then pnlRobotLightColor.Color := clRed
        else                                         pnlRobotLightColor.Color := clGreen;
      end;
      ROBOT_TM_LIGHT_13_AlterPurpleGreen_HmiInManualMode: begin
        if (pnlRobotLightColor.Color = clPurple) then pnlRobotLightColor.Color := clGreen
        else                                          pnlRobotLightColor.Color := clPurple;
      end;
      ROBOT_TM_LIGHT_14_AlterPurpleBlue_HmiInAutoMode: begin
        if (pnlRobotLightColor.Color = clPurple) then pnlRobotLightColor.Color := clBlue
        else                                          pnlRobotLightColor.Color := clPurple;
      end;
      ROBOT_TM_LIGHT_17_AlterWhiteGreen_ReducedSpaceInManualMode: begin
        if (pnlRobotLightColor.Color = clWhite) then pnlRobotLightColor.Color := clGreen
        else                                         pnlRobotLightColor.Color := clWhite;
      end;
      ROBOT_TM_LIGHT_18_AlterWhiteBlue_ReducedSpaceInAutoMode : begin
        if (pnlRobotLightColor.Color = clWhite) then pnlRobotLightColor.Color := clBlue
        else                                         pnlRobotLightColor.Color := clWhite;
      end;
      ROBOT_TM_LIGHT_19_FlashingLightBlue_SafeStartupMode: begin
        if (pnlRobotLightColor.Color = clWebLightBlue) then pnlRobotLightColor.Color := clGray
        else                                                pnlRobotLightColor.Color := clWebLightBlue;
      end;
      else begin
      //TBD:ROBOT? Unknown?
      end;
    end;
  finally
    tmrRobotLight.Enabled := True;
  end;
end;

{$IFDEF REF_ISPD}
procedure TfrmTest1Ch.tmrDisplayOffTimer(Sender: TObject);
begin
  //Common.MLog(m_nJig,'<TestCh> tmrDisplayOffTimer');
  tmrDisplayOff.Enabled := False;
  pnlErrAlram.Visible := False;
end;
{$ENDIF}

{$IFDEF REF_ISPD_L_DFS}
procedure TfrmTest1Ch.tmrLogInTimer(Sender: TObject);
begin
  if (DongaGmes = nil) then begin
    if Trim(Common.SystemInfo.ServicePort) <> '' then begin
      SendMainGuiDisplay(DefCommon.MSG_MODE_LOGIN);
    end;
  end;
end;

procedure TfrmTest1Ch.tmrLogOutTimer(Sender: TObject);
begin
  if DongaGmes <> nil then begin
    if DongaGmes.MesUserName <> '' then begin
      SendMainGuiDisplay(DefCommon.MSG_MODE_LOGOUT);
    end;
  end;
end;
{$ENDIF}

procedure TfrmTest1Ch.tmrFlashEraseTactTimer(Sender: TObject);
var
  nSec, nMin : Integer;
begin
  Inc(m_nFlashEraseTact);
  nSec := m_nFlashEraseTact mod 60;
  nMin := (m_nFlashEraseTact div 60) mod 60;
  pnlFlashEraseValue.Caption := Format('%0.2d:%0.2d',[nMin, nSec]);
end;

procedure TfrmTest1Ch.tmrFlashWriteAckTactTimer(Sender: TObject);
var
  nSec, nMin : Integer;
begin
  Inc(m_nFlashWriteAckTact);
  nSec := m_nFlashWriteAckTact mod 60;
  nMin := (m_nFlashWriteAckTact div 60) mod 60;
  pnlFlashWriteAckValue.Caption := Format('%0.2d:%0.2d',[nMin, nSec]);
end;

//******************************************************************************
// procedure/function: GUI(Test1Ch)
//******************************************************************************

procedure TfrmTest1Ch.CreateGui;
const
  NoSelection : TGridRect = (Left: 0; Top: -1; Right: 0; Bottom: -1);
var
  i, j : Integer;
  sTemp : string;
  marginTop, marginLeft : Integer;
  itemHeight, itemWidth : Integer;
begin
  //----------------------------------------------------------------------------
  // Main JIG Form
  //----------------------------------------------------------------------------
  RzpnlJigMain := TRzPanel.Create(Self);
	with RzpnlJigMain do begin
  	Align          := alLeft;
  	Parent         := RzpnlTestMain;
  	Font.Name      := 'Tahoma';
  	BorderOuter    := TframeStyleEx(fsFlat);
  	Width          := Self.Width;
  	Visible        := False;
  	DisableAlign;
	end;

  nPnlJigCmmon2Height := 60;  //TBD?

  //----------------------------------------------------------------------------
  // Common1 for JIG (Left)
  //----------------------------------------------------------------------------
  marginTop   := 0;
  marginLeft  := 0;
//itemHeight  := 50;
  itemWidth   := 220;

  // Jig ������ ���� Panel.
  RzpnlJigCommon1 := TRzPanel.Create(Self);
	with RzpnlJigCommon1 do begin
  	Parent      	:= RzpnlJigMain;
  	Top         	:= marginTop;
  	Left        	:= marginLeft;
  	Height      	:= RzpnlJigMain.Height - nPnlJigCmmon2Height - marginTop*2;
  	Width       	:= itemWidth;
  	Font.Size   	:= 12;
  	Align       	:= alLeft;
  	Font.Color  	:= clBlack;
  	Font.Style  	:= [fsBold];
  	Alignment   	:= taRightJustify;
  	BorderOuter 	:= TframeStyleEx(fsFlat);
  	StyleElements	:= [];
	end;

  marginTop   := 2;
	marginLeft  := 2;
  itemHeight  := 48;
  itemWidth   := RzpnlJigCommon1.Width - marginLeft*2;

  // Jig ������ ���� Panel.
  pnlJigTitle := TPanel.Create(Self);
	with pnlJigTitle do begin
  	Parent        := RzpnlJigCommon1;
  	Top           := marginTop;
  	Left          := marginLeft;
  	Height        := itemHeight;
  	Width         := itemWidth;// pnlJig[nJig].Width div nMaxCh;
  	Font.Size     := 20;
  	Color         := clBlack;
  	Font.Color    := clAqua;
  	Alignment     := taCenter;
  	Caption       := Format(' Stage %d',[1+Self.Tag]);
  	StyleElements := [];
	end;

  // ----------------------------------- Test Start/Stop Buttons
  // Test Start Button
  btnStartTest := TRzBitBtn.Create(Self);
	with btnStartTest do begin
  	Parent        := RzpnlJigCommon1;
  	Top           := pnlJigTitle.Top + pnlJigTitle.Height + marginTop;
  	Left          := pnlJigTitle.Left;
  	Height        := itemHeight;
  	Width         := itemWidth;
  	Font.Size     := 20;
  	Cursor        := crHandPoint;
  	HotTrack      := True;
  	Color         := clBlack;   //TBD?
  	Font.Color    := clYellow;  //TBD?
  	Alignment     := taCenter;
  	Caption       := 'START';
  	StyleElements := [];
    Enabled       := True;
	end;
  btnStartTest.OnClick := btnStartTestClick;
  // Test Stop Button
  btnStopTest := TRzBitBtn.Create(Self);
	with btnStopTest do begin
  	Parent        := RzpnlJigCommon1;
  	Top           := btnStartTest.Top + btnStartTest.Height + marginTop;
  	Left          := pnlJigTitle.Left;
  	Height        := itemHeight;
  	Width         := itemWidth;
  	Font.Size     := btnStartTest.Font.Size;
  	Cursor        := crHandPoint;
  	HotTrack      := True;
  	Color         := clBlack;
  	Font.Color    := clYellow;
  	Alignment     := taCenter;
  	Caption       := 'STOP';
    Enabled       := True;
	end;
  btnStopTest.OnClick := btnStopTestClick;

  // ----------------------------------- Test TaktTimes
	// TaktTime - Total(Title)
  rzpnlTactTotalTitle := TRzPanel.Create(Self);
	with rzpnlTactTotalTitle do begin
  	Parent      	:= RzpnlJigCommon1;
  	Top         	:= btnStopTest.Top + btnStopTest.Height + 4;
  	Left        	:= pnlJigTitle.Left;
  	Height      	:= itemHeight - 2;  //F2CH
  	Width       	:= (itemWidth div 2) - marginLeft;
  	Font.Size   	:= 14;
  	Caption     	:= 'Total Tact';
  	BorderOuter 	:= TframeStyleEx(fsFlat);
	end;
	// TaktTime - Total(Value)
  pnlTactTotalValue := TPanel.Create(Self);
	with pnlTactTotalValue do begin
  	Parent        := RzpnlJigCommon1;
  	Top           := rzpnlTactTotalTitle.Top;
  	Left          := rzpnlTactTotalTitle.Left + rzpnlTactTotalTitle.Width + marginLeft;
  	Height        := rzpnlTactTotalTitle.Height;
  	Width         := rzpnlTactTotalTitle.Width;
  	Color         := clBlack;
  	Font.Color    := clLime;
  	Font.Size     := 16;
  	Caption       := '00 : 00';
  	StyleElements := [];
	end;
	// TaktTime - JIG(Title)
  rzpnlTactJigTitle := TRzPanel.Create(Self);
	with rzpnlTactJigTitle do begin
  	Parent        := RzpnlJigCommon1;
  	Top           := rzpnlTactTotalTitle.Top + rzpnlTactTotalTitle.Height + marginTop;
  	Left          := rzpnlTactTotalTitle.Left;
  	Height        := rzpnlTactTotalTitle.Height;
  	Width         := rzpnlTactTotalTitle.Width;
  	Font.Size     := rzpnlTactTotalTitle.Font.Size;
  	Caption       := 'Jig Tact';
  	BorderOuter   := TframeStyleEx(fsFlat);
	end;
	// TaktTime - JIG(Value)
  pnlTactJigValue := TPanel.Create(Self);
	with pnlTactJigValue do begin
  	Parent        := RzpnlJigCommon1;
  	Top           := rzpnlTactJigTitle.Top;
  	Left          := pnlTactTotalValue.Left;
  	Height        := rzpnlTactTotalTitle.Height;
  	Width         := rzpnlTactTotalTitle.Width;
  	Color         := pnlTactTotalValue.Color;
  	Font.Color    := pnlTactTotalValue.Font.Color;
  	Font.Size     := pnlTactTotalValue.Font.Size;
  	Caption       := '00 : 00';
  	StyleElements := [];
	end;
	// TaktTime - Unit(Title)
  rzpnlTactUnitTitle := TRzPanel.Create(Self);
	with rzpnlTactUnitTitle do begin
  	Parent        := RzpnlJigCommon1;
  	Top           := rzpnlTactJigTitle.Top + rzpnlTactJigTitle.Height + marginTop;
  	Left          := rzpnlTactTotalTitle.Left;
  	Height        := rzpnlTactTotalTitle.Height;
  	Width         := rzpnlTactTotalTitle.Width;
  	Font.Size     := rzpnlTactTotalTitle.Font.Size;
  	Caption       := 'Unit Tact';
  	BorderOuter   := TframeStyleEx(fsFlat);
	end;
	// TaktTime - Unit(Value)
  pnlTactUnitValue := TPanel.Create(Self);
	with pnlTactUnitValue do begin
  	Parent        := RzpnlJigCommon1;
  	Top           := rzpnlTactUnitTitle.Top;
  	Left          := pnlTactTotalValue.Left;
  	Height        := rzpnlTactTotalTitle.Height;
  	Width         := rzpnlTactTotalTitle.Width;
  	Color         := pnlTactTotalValue.Color;
  	Font.Color    := pnlTactTotalValue.Font.Color;
  	Font.Size     := pnlTactTotalValue.Font.Size;
  	Caption       := '00 : 00';
  	StyleElements := [];
	end;

{$IFDEF USE_FPC_LIMIT}
	// FPC Usage Limit //2019-04-11
  if Common.SystemInfo.FpcUsageLimitUse then begin
    rzpnlFpcUsageTitle := TRzPanel.Create(Self);
  	with rzpnlFpcUsageTitle do begin
    	Parent        := RzpnlJigCommon1;
    	Top           := rzpnlTactUnitTitle.Top + rzpnlTactUnitTitle.Height + marginTop;
    	Left          := rzpnlTactUnitTitle.Left;
    	Height        := rzpnlTactUnitTitle.Height - 4;
    	Width         := pnlJigTitle.Width div 3;
    	Font.Size     := rzpnlTactUnitTitle.Font.Size;
  	  Caption       := 'FPC Usage';
    	BorderOuter   := TframeStyleEx(fsFlat);
  	end;
  	// FPC Usage Value
    pnlFpcUsageValue := TPanel.Create(Self);
  	with pnlFpcUsageValue do begin
    	Parent        := RzpnlJigCommon1;
    	Top           := rzpnlFpcUsageTitle.Top;
    	Left          := rzpnlFpcUsageTitle.Left + rzpnlFpcUsageTitle.Width + 4;
    	Height        := rzpnlFpcUsageTitle.Height;
    	Width         := rzpnlFpcUsageTitle.Width - 2;
    	Color         := pnlTactTotalValue.Color;
    	Font.Size     := pnlTactTotalValue.Font.Size;
    	Caption       := Format('%d',[Common.m_nFpcUsageValue[m_nJig]]); //2019-04-11
      if Common.m_nFpcUsageValue[m_nJig] > Common.SystemInfo.FpcUsageLimitValue then pnlFpcUsageValue.Font.Color := clRed
      else                                                                           pnlFpcUsageValue.Font.Color := clLime;
    	StyleElements := [];
  	end;
    // FPC Usage Reset Button
    btnFpcUsageReset := TRzBitBtn.Create(Self);
  	with btnFpcUsageReset do begin
    	Parent        := RzpnlJigCommon1;
    	Top           := rzpnlFpcUsageTitle.Top;
    	Left          := pnlFpcUsageValue.Left + pnlFpcUsageValue.Width + 4;
    	Height        := rzpnlFpcUsageTitle.Height;
    	Width         := rzpnlFpcUsageTitle.Width - 2;
    	Cursor        := crHandPoint;
    	HotTrack      := True;
    	Font.Color    := clBlack;
    	Font.Size     := pnlTactTotalValue.Font.Size;
    	Caption       := 'Reset';
  	end;
    btnFpcUsageReset.OnClick := btnFpcUsageResetClick;
    btnFpcUsageReset.Parent  := Self;
    btnFpcUsageReset.Visible := True;
  end;
{$ENDIF}

  // ----------------------------------- Virtual Key
  btnVirtualKey := TRzBitBtn.Create(Self);
	with btnVirtualKey do begin
  	Parent        := RzpnlJigCommon1;
{$IFDEF USE_FPC_LIMIT}
    if not Common.SystemInfo.FpcUsageLimitUse then
    	Top         := rzpnlTactUnitTitle.Top + rzpnlTactUnitTitle.Height + 4
    else
    	Top         := rzpnlFpcUsageTitle.Top + rzpnlFpcUsageTitle.Height + 4;
{$ELSE}
  	Top           := rzpnlTactUnitTitle.Top + rzpnlTactUnitTitle.Height + 4;
{$ENDIF}
  	Left          := pnlJigTitle.Left;
{$IFDEF POCB_A2CH}
  	Height        := pnlJigTitle.Height;
{$ELSE}
  	Height        := pnlJigTitle.Height - 5;
{$ENDIF}
  	Width         := pnlJigTitle.Width;
  	Cursor        := crHandPoint;
  	HotTrack      := True;
  	Font.Size     := 14;
  	Caption       := 'Virtual Key';
	end;
  btnVirtualKey.OnClick := btnVirtualKeyClick;
  PnlRcbSimKeys.Parent  := Self;
  PnlRcbSimKeys.Visible := False;

  if Common.TestModelInfo2[m_nJig].UsePucOnOff or Common.TestModelInfo2[m_nJig].UsePucImage then begin //2022-07-15 UNIFORMITY_PUCONOFF //2023-04-07 FEATURE_PUC_IMAGE}
    btnRcbSimKey3PreCompPat1.Caption := 'PUC OFF';
    btnRcbSimKey4CompPat1.Caption    := 'PUC ON';
    btnRcbSimKey5PreCompPat2.Caption := 'PUC OFF';
    btnRcbSimKey6CompPat2.Caption    := 'PUC ON';
  end;

  // ----------------------------------- Power Limit
  // ----------------------------------- Motion/Robot
  RzgrpMotionStatus.Parent  := RzpnlJigCommon1;
  RzgrpMotionStatus.Visible := True;
  RzgrpMotionStatus.Left := btnVirtualKey.Left;
  RzgrpMotionStatus.Top  := btnVirtualKey.Top + btnVirtualKey.Height + marginTop;
{$IFNDEF SUPPORT_1CG2PANEL}
  pnlMotionYAxisSyncMode.Visible := False;
  ledMotionYaxisOnSync.Visible := False;
{$ENDIF}

{$IFDEF HAS_ROBOT_CAM_Z}
  ledRobotAutoMode.TrueColor    := clLime;    ledRobotAutoMode.FalseColor    := clBtnFace;
  ledRobotManualMode.TrueColor  := clYellow;  ledRobotManualMode.FalseColor  := clBtnFace;
  ledRobotFatalError.TrueColor  := clRed;     ledRobotFatalError.FalseColor  := clBtnFace;
  ledRobotProjRunning.TrueColor := clLime;    ledRobotProjRunning.FalseColor := clBtnFace;
  ledRobotProjEditing.TrueColor := clYellow;  ledRobotProjEditing.FalseColor := clBtnFace;
  ledRobotProjPause.TrueColor   := clYellow;  ledRobotProjPause.FalseColor   := clBtnFace;
  ledRobotGetControl.TrueColor  := clYellow;  ledRobotGetControl.FalseColor  := clBtnFace;
  ledRobotEStop.TrueColor       := clRed;     ledRobotEStop.FalseColor       := clBtnFace;
  ledRobotCoordHome.TrueColor   := clYellow;  ledRobotCoordHome.FalseColor   := clBtnFace;
  ledRobotCoordModel.TrueColor  := clLime;    ledRobotCoordModel.FalseColor  := clBtnFace;
{$ENDIF}

  //----------------------------------------------------------------------------
  // CH Form
  //----------------------------------------------------------------------------
//SetLength(gridChPower,DefPocb.PG_CNT div 2);  //TBD??
  marginTop   := 2;
  marginLeft  := 2;
  itemHeight  := 36; //TBD??
  itemWidth   := (RzpnlJigMain.Width - RzpnlJigCommon1.Width - 6); //div DefPocb.JIGCH_CNT;

//for nJigCh := DefPocb.JIGCH_1 to DefPocb.JIGCH_MAX do begin
    //---------------------------------- Ch Group
    RzpnlChGrp := TRzPanel.Create(Self);
    with RzpnlChGrp do begin
    	Parent          	:= RzpnlJigMain;
    	StyleElements   	:= [];
    	Align           	:= alLeft;
    	Alignment       	:= taRightJustify;
    	BorderOuter     	:= TframeStyleEx(fsFlat);
    	Top             	:= marginTop;
    	Left            	:= RzpnlJigCommon1.Width;
    	Height          	:= RzpnlJigCommon1.Height;
    	Width           	:= itemWidth;
    	Font.Color      	:= clBlack;
    	Font.Size       	:= 12;
    	Caption         	:= '';
		end;
    //---------------------------------- Ch Grp - Model Status
    RzpnlModelStatus := TRzPanel.Create(Self);  //A2CHv3:MULTIPLE_MODEL
    with RzpnlModelStatus do begin
    	Parent            := RzpnlChGrp;
    	Align             := alTop;
    	BorderOuter       := TframeStyleEx(fsFlat);
    	Top               := marginTop;
    	Left              := marginLeft;
    	Height            := 48;
    	Width             := itemWidth;
    //StyleElements     := [];
    	ParentBackground  := False;
    	Font.Size         := 16;
    	Font.Style        := [fsBold];
		end;
    //---------------------------------- Ch Grp - Model Status - Model Name
    pnlModelName := TPanel.Create(Self);  //A2CHv3:MULTIPLE_MODEL
    with pnlModelName do begin
    	Parent          	:= RzpnlModelStatus;
    //Align           	:= alTop;
    	Alignment       	:= taCenter;
    	Top             	:= marginTop;
    	Left            	:= marginLeft;
    	Height          	:= 46;
    	Width           	:= itemWidth - 100;
      AutoSize          := False;
    	StyleElements   	:= [];
    	ParentBackground	:= False;
    	Color           	:= clBlack;
    	Font.Color      	:= clAqua;
    	Font.Size       	:= 12;
    	Font.Style      	:= [fsBold];
    	ShowHint        	:= True;
    	Hint            	:= 'Model Name';
    	Caption         	:= Common.SystemInfo.TestModel[m_nJig];
		end;
{$IFDEF CH_USE_CHECKBOX} //NOT_USED
    //---------------------------------- Ch Grp - Model Status - Channel Usage
    rzcbChUsage := TRzCheckBox.Create(Self);
    with rzcbChUsage do begin
    	Parent         		:= RzpnlModelStatus;
      Align          		:= alTop;
    	AlignWithMargins  := True;
    	AlignmentVertical := TAlignmentVertical(avCenter);
    	Top            		:= pnlModelName.Top;
    	Left           		:= pnlModelName.Width + marginLeft*2;
      WordWrap          := True;
    	Font.Color     		:= clGreen;
    	Font.Size      		:= 16;
    	Font.Style     		:= [fsBold];
    	ShowHint       		:= True;
    	Hint           		:= 'Channel Usage';
    	Caption        		:= Format(' Channel %d',[m_nCh]);
    	State          		:= cbChecked;
    	Cursor         		:= crHandPoint;
  	  OnClick        		:= chkPgClick;  //TBD:ISPD?
      Visible           := False;
		end;
{$ENDIF}
    //---------------------------------- Ch Grp - Model Status - Auto Power Off
    cbAutoPowerOff := TRzCheckBox.Create(Self);
    with cbAutoPowerOff do begin
    	Parent         		:= RzpnlModelStatus;
    //Align          		:= alTop;
    //AlignWithMargins  := True;
      AlignmentVertical := TAlignmentVertical(avCenter);
      AutoSize          := False;
    	Top            		:= pnlModelName.Top;
    	Left           		:= pnlModelName.Width + marginLeft*2;
    	Height         		:= itemHeight - 2;
      Width             := 95;
      WordWrap          := True;
    	StyleElements   	:= [];
    	Font.Color     		:= clGreen;
    	Font.Size      		:= 10;
    	Font.Style     		:= [fsBold];
    	ShowHint       		:= True;
    	Hint           		:= 'Auto Power Off';
    	Caption        		:= 'Auto PowerOff';
{$IFDEF PANEL_AUTO}
  {$IFDEF SITE_LGDVH}
      State := cbChecked;  //VH (A2CH|A2CHv2|A2CHv3|A2CHv4)
  {$ELSE}
      State := cbUnchecked; //LENS(ATO)
  {$ENDIF}
{$ELSE}
      State := cbUnchecked; //FOLD|GAGO
{$ENDIF}

    	Cursor         		:= crHandPoint;
  	  OnClick        		:= cbAutoPowerOffClick;
      Visible           := True;
		end;
    //---------------------------------- Ch Grp - PG Status
    RzpnlPgStatus := TRzPanel.Create(Self);
    with RzpnlPgStatus do begin
    	Parent            := RzpnlChGrp;
    	Align             := alTop;
    	BorderOuter       := TframeStyleEx(fsFlat);
    	Top               := RzpnlModelStatus.Top + RzpnlModelStatus.Height + marginTop*2;
    	Left              := marginLeft;
    	Height            := itemHeight;
    	Width             := itemWidth;
    //StyleElements     := [];
    	ParentBackground  := False;
    	Font.Size         := 16;
    	Font.Style        := [fsBold];
		end;
    //---------------------------------- Ch Grp - PG Status - PG Led
    ledPgStatus := ThhALed.Create(Self);
    with ledPgStatus do begin
    	Parent         		:= RzpnlPgStatus;
    	LEDStyle       		:= LEDSqLarge;
    	Blink          		:= False;
    	Top            		:= marginTop;
    	Left           		:= marginLeft;
    	Height         		:= itemHeight - 2;
    	Width          		:= itemHeight - 2;
      TrueColor         := clLime;
      FalseColor        := clRed;
      Value             := False;
    //StyleElements  		:= [];
    	ShowHint       		:= True;
    	Hint           		:= 'PG Status';
		end;
    //---------------------------------- Ch Grp - PG Status - PG Version
    pnlHwVer := TRzLabel.Create(Self);
    with pnlHwVer do begin
    	Parent         		:= RzpnlPgStatus;
    //Align          		:= alTop;
      Layout            := tlCenter;
      BorderInner       := fsButtonUp;
      Alignment      		:= taLeftJustify;
    	Top            		:= marginTop - 1;
    	Left           		:= marginLeft + 30;
    	Height         		:= itemHeight - 2;
    	Width          		:= (itemWidth div 2) - 65;
      AutoSize          := False;
    	Font.Color     		:= clYellow;
    	Font.Size      		:= 11; //2021-11-02 12->11
    	Font.Style     		:= [fsBold];
      Color             := clRed;
    	ShowHint       		:= True;
      StyleElements  		:= [];
    	Hint           		:= 'PG Version';
    	Caption        		:= 'PG Disconected';
		end;
    //---------------------------------- Ch Grp - SPI Status - Led
    ledSpiStatus := ThhALed.Create(Self);
    with ledSpiStatus do begin
    	Parent         		:= RzpnlPgStatus;
    	LEDStyle       		:= LEDSqLarge;
    	Blink          		:= False;
    	Top            		:= marginTop;
    	Left           		:= pnlHwVer.Left + pnlHwVer.Width + 2; //  (itemWidth div 2) + marginLeft;
    	Height         		:= itemHeight - 2;
    	Width          		:= itemHeight - 2;
      TrueColor         := clLime;
      FalseColor        := clRed;
      Value             := False;
    	ShowHint       		:= True;
    	Hint           		:= 'SPI Status';
		end;
    //---------------------------------- Ch Grp - SPI Status - SPI Version
    pnlSpiVer := TRzLabel.Create(Self);
    with pnlSpiVer do begin
    	Parent         		:= RzpnlPgStatus;
    //Align          		:= alTop;
      Layout            := tlCenter;
      BorderInner       := fsButtonUp;
    	Alignment      		:= taLeftJustify;
    	Top            		:= marginTop - 1;
    	Left           		:= ledSpiStatus.Left + 30;
    	Height         		:= itemHeight - 2;
    	Width          		:= (itemWidth div 2) - 65;
      AutoSize          := False;
    	Font.Color     		:= clYellow;
    	Font.Size      		:= 11; //2021-11-02 12->11
    	Font.Style     		:= [fsBold];
      Color             := clRed;
    	ShowHint       		:= True;
      StyleElements  		:= [];
    	Hint           		:= 'SPI Version';
    	Caption        		:= 'SPI Disconected';
		end;
    //---------------------------------- Ch Grp - SPI Status - SPI Reset  //2019-04-29
    // SPI Reset Button
    btnSpiReset := TRzBitBtn.Create(Self);
  	with btnSpiReset do begin
    	Parent            := RzpnlPgStatus;
    //Align          		:= alTop;
    //Alignment      		:= taLeftJustify;
    	Top            		:= marginTop - 1;
    	Left           		:= pnlSpiVer.Left + pnlSpiVer.Width + 2;
    	Height         		:= itemHeight - 2;
    	Width          		:= 50;
    	Cursor            := crHandPoint;
    //HotTrack          := True;
    	Font.Color        := clBlack;
    	Font.Size      		:= 10;
    	Font.Style     		:= [fsBold];
      StyleElements  		:= [];
    	Caption           := 'SPI Reset';
      Visible           := True;
      OnClick           := btnSpiResetClick;
  	end;
    //---------------------------------- CRC Status
    gridCRCStatus := TAdvStringGrid.Create(Self);
    with gridCRCStatus do begin
      Parent       			:= RzpnlChGrp;
      Align        			:= alTop;
      ColCount     			:= 3;
      RowCount     			:= 2;
      Top          			:= RzpnlPgStatus.Top + RzpnlPgStatus.Height + marginTop*2;
      Left         			:= marginLeft;
      DefaultRowHeight 	:= 23;
      Height       			:= gridCRCStatus.DefaultRowHeight*RowCount+2;
      Width        			:= itemWidth;
      ScrollBars        := ssNone;  //2019-01-04
      Font.Size    			:= 11;
      Font.Style   			:= [fsBold];
      FixedCols    			:= 0;

      for i := 0 to Pred(ColCount) do begin
        ColWidths[i] := Width div ColCount - 2;
        for j := 0 to Pred(RowCount) do begin
          Alignments[i,j] := taCenter;
          Cells[i,j]      := '';
        end;
      end;
      // Columns
      Cells[0,0] := 'CRC_Model';
      Cells[1,0] := 'CRC_CB Algorithm';
      Cells[2,0] := 'CRC_Cam Parameter';
    end;
    //---------------------------------- Serial Numbers
    RzpnlSerials := TRzPanel.Create(Self);
    with RzpnlSerials do begin
    	Parent            := RzpnlChGrp;
    	Align             := alTop;
      BorderOuter       := TframeStyleEx(fsFlat);
    	Top               := gridCRCStatus.Top + gridCRCStatus.Height;
    	Left              := marginLeft;
    	Height            := itemHeight;
    	Width             := itemWidth;
    //StyleElements     := [];
    	ParentBackground  := False;
    	Font.Size         := 14;
    	Font.Style        := [fsBold];
		end;
    //---------------------------------- Serial Numbers - PID
    pnlSerialNo := TPanel.Create(Self);
    with pnlSerialNo do begin
    	Parent         		:= RzpnlSerials;
    //Align          		:= alTop;
    	Alignment      		:= taCenter;
    	Top            		:= marginTop; //RzpnlSerials.Top;
    	Left           		:= marginLeft;
    	Height         		:= itemHeight;
    	Width          		:= (itemWidth div 3) * 2 - 2;
    	Color          		:= clBtnFace;
      AutoSize          := False;
      StyleElements  		:= [];
  	//ParentBackground 	:= False;
    	Font.Name      		:= 'Tahoma';
    	Font.Size      		:= 14;
    	Font.Color     		:= clBlack;
    	Font.Style     		:= [fsBold];
    	ShowHint       		:= True;
    	Hint           		:= 'PID Number';
    	Caption        		:= '';
		end;
    //---------------------------------- Serial Numbers - CPCB
    pnlPCBNo := TPanel.Create(Self);
    with pnlPCBNo do begin
    	Parent         		:= RzpnlSerials;
    //Align          		:= alTop;
    	Alignment      		:= taCenter;
    	Top            		:= marginTop - 1;  //RzpnlSerials.Top;
    	Left           		:= pnlSerialNo.Width + 2;
    	Height         		:= itemHeight;
    	Width          		:= (itemWidth div 3) - 1;
    	Color          		:= clBtnFace;
    //StyleElements  		:= [];
  	//ParentBackground 	:= False;
      AutoSize          := False;
    	Font.Name      		:= 'Tahoma';
    	Font.Size      		:= 10;
    	Font.Color     		:= clBlack;
    	Font.Style     		:= [fsBold];
    	ShowHint       		:= True;
    	Hint           		:= 'PCB ID';
    	Caption        		:= '';
		end;
    //---------------------------------- MES Result
    pnlMesResult := TPanel.Create(Self);
    with pnlMesResult do begin
    	Parent          	:= RzpnlChGrp;
    	Align           	:= alTop;
    	Alignment       	:= taCenter;
    	Top             	:= RzpnlSerials.Top + RzpnlSerials.Height;
    	Left            	:= marginLeft;
    	Height          	:= itemHeight;
    	Width           	:= itemWidth;
    	StyleElements   	:= [];
    	ParentBackground	:= False;
    	Color           	:= clBlack;
    	Font.Color      	:= clYellow;
    	Font.Size       	:= 16;
    	Font.Style      	:= [fsBold];
    	ShowHint        	:= True;
    	Hint            	:= 'MES Result';
    	Caption         	:= '';
		end;
    //---------------------------------- PG Status
    pnlChStatus := TPanel.Create(Self);
    with pnlChStatus do begin
    	Parent           	:= RzpnlChGrp;
    	Align            	:= alTop;
    	Alignment        	:= taCenter;
    	Top              	:= pnlMesResult.Top + pnlMesResult.Height;
    	Left             	:= marginLeft;
    	Height           	:= itemHeight;
    	Width            	:= itemWidth;
    	StyleElements    	:= [];
    	ParentBackground 	:= False;
    	Color            	:= clBlack;
    	Font.Color       	:= clLime;
    	Font.Size        	:= 16;
    	Font.Style       	:= [fsBold];
    	ShowHint         	:= True;
    	Hint             	:= 'Channel Status';
    	Caption          	:= 'Ready'; //TBD?: Ready?
		end;

    //---------------------------------- Product Test Counts
    // Test Count - Panel Group
    RzpnlTestCnt := TRzPanel.Create(Self);
    with RzpnlTestCnt do begin
    	Parent            := RzpnlChGrp;
    	Align             := alTop;
    	BorderOuter       := TframeStyleEx(fsFlat);
    	Top               := pnlChStatus.Top + pnlChStatus.Height + marginTop;
    	Left              := marginLeft;
    	Height            := itemHeight;
    	Width             := itemWidth;
    	StyleElements     := [];
    	ParentBackground  := False;
    	Font.Size         := 16;
    	Font.Style        := [fsBold];
		end;
    // Test Count - Total(Title)
    rzpnlCntTotalTitle := TRzPanel.Create(Self);
    with rzpnlCntTotalTitle do begin
    	Parent      			:= RzpnlTestCnt;
    	Top         			:= marginTop;
    	Left        			:= marginLeft;
    	Height      			:= itemHeight;
    	Width       			:= (itemWidth - marginLeft*3) div 7;
    	Caption     			:= 'Total';
		end;
    // Test Count - Total(Value)
   	pnlCntTotalValue := TPanel.Create(Self);
    with pnlCntTotalValue do begin
    	Parent        		:= RzpnlTestCnt;
    	Top           		:= marginTop;
    	Left          		:= rzpnlCntTotalTitle.Left + rzpnlCntTotalTitle.Width;
    	Height        		:= itemHeight;
    	Width         		:= (itemWidth - marginLeft*3) div 7;
    	StyleElements 		:= [];
    	Color         		:= clBlack;
    	Font.Color    		:= clYellow;
    	Caption       		:= '0';
		end;
    // Test Count - OK(Title)
   	rzpnlCntOkTitle := TRzPanel.Create(Self);
    with rzpnlCntOkTitle do begin
    	Parent         		:= RzpnlTestCnt;
    	Top            		:= marginTop;
    	Left           		:= pnlCntTotalValue.Left + pnlCntTotalValue.Width + 3;
    	Height         		:= itemHeight;
    	Width          		:= rzpnlCntTotalTitle.Width;
    	Caption        		:= 'OK';
		end;
    // Test Count - OK(Value)
    pnlCntOkValue := TPanel.Create(Self);
    with pnlCntOkValue do begin
      Parent           	:= RzpnlTestCnt;
      Top              	:= marginTop;
      Left             	:= rzpnlCntOkTitle.Left + rzpnlCntOkTitle.Width;
      Height           	:= itemHeight;
      Width            	:= pnlCntTotalValue.Width;
      StyleElements    	:= [];
      Color            	:= clBlack;
      Font.Color       	:= clLime;
      Caption          	:= '0';
    end;
    // Test Count - NG(Title)
    rzpnlCntNgTitle := TRzPanel.Create(Self);
    with rzpnlCntNgTitle do begin
      Parent          	:= RzpnlTestCnt;
      Top             	:= marginTop;
      Left            	:= pnlCntOkValue.Left + pnlCntOkValue.Width + 3;
      Height          	:= itemHeight;
      Width           	:= rzpnlCntTotalTitle.Width;
      Caption         	:= 'NG';
    end;
    // Test Count - NG(Value)
    pnlCntNgValue := TPanel.Create(Self);
    with pnlCntNgValue do begin
      Parent          	:= RzpnlTestCnt;
      Top             	:= marginTop;
      Left            	:= rzpnlCntNgTitle.Left + rzpnlCntNgTitle.Width;
      Height          	:= itemHeight;
      Width           	:= pnlCntTotalValue.Width;
      StyleElements   	:= [];
      Color           	:= clBlack;
      Font.Color      	:= clRed;
      Caption         	:= '0';
    end;
    btnCntReset := TRzBitBtn.Create(Self);
    with btnCntReset do begin
      Parent          	:= RzpnlTestCnt;
      Top             	:= marginTop - 2;
      Left            	:= pnlCntNgValue.Left + pnlCntNgValue.Width;
      Height          	:= itemHeight;
      Width           	:= pnlCntTotalValue.Width;
      Caption         	:= 'Reset';
      Cursor            := crHandPoint;
    	HotTrack          := True;
      OnClick           := btnCntResetClick;
    end;
    //---------------------------------- Power Measure
    gridChPower := TAdvStringGrid.Create(Self);
    with gridChPower do begin
      Parent       			:= RzpnlChGrp;
      Align        			:= alTop;
      Top          			:= RzpnlTestCnt.Top + RzpnlTestCnt.Height + marginTop*2;
      Left         			:= marginLeft;
      DefaultRowHeight 	:= 22;
      Height       			:= gridChPower.DefaultRowHeight*3+6;  //TBD:GUI?
      Width        			:= itemWidth;
      ScrollBars        := ssNone;  //2019-01-04
    //StyleElements    	:= [];
    //Font.Name    			:= 'Tahoma';
      Font.Size    			:= 11;
      Font.Style   			:= [fsBold];
    //Options      			:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRangeSelect,goRowSelect];
      Selection         := NoSelection;
      //
      ColCount     			:= 4;
      RowCount     			:= 3;
      FixedCols    			:= 0;
      for i := 0 to Pred(ColCount) do begin
        ColWidths[i] := ((itemWidth - marginLeft*4) div ColCount) - 20;
        for j := 0 to Pred(RowCount) do begin
          Cells[i,j] := '';
        end;
      end;
      // Columns
      Cells[0,0] := '';
      Cells[1,0] := 'Voltage';
      Cells[2,0] := '';
      Cells[3,0] := 'Current';
      // Rows
      Cells[0,1] := 'VCC (V)';
      Cells[2,1] := 'ICC (mA)';
{$IFDEF PANEL_AUTO}
      Cells[0,2] := 'VDD (V)';
      Cells[2,2] := 'IDD (mA)';
{$ELSE}
      Cells[0,2] := 'VEL (V)';
      Cells[2,2] := 'IEL (mA)';
{$ENDIF}

    end;
    //---------------------------------- Channel MLog (for backward compatabiliy to PocbAuto)
    pnlDisplayPattern := TPanel.Create(Self);
    with pnlDisplayPattern do begin
    	Parent           	:= RzpnlChGrp;
    	Align            	:= alTop;
    	Alignment        	:= taCenter;
    	Top              	:= gridChPower.Top + gridChPower.Height;
    	Left             	:= marginLeft;
    	Height           	:= itemHeight;
    	Width            	:= itemWidth;
    	StyleElements    	:= [];
    	ParentBackground 	:= False;
    	Color            	:= clBtnFace;
    	Font.Color       	:= clBlack;
    	Font.Size        	:= 16;
    	Font.Style       	:= [fsBold];
    	ShowHint         	:= True;
    	Hint             	:= 'Display Pattern';
    	Caption          	:= '';
    end;
    //---------------------------------- CBDATA Flash Write Progress
    RzpnlFlashProgress := TRzPanel.Create(Self);
    with RzpnlFlashProgress do begin
    	Parent            := RzpnlChGrp;
    //Align             := alTop;
    	BorderOuter       := TframeStyleEx(fsFlat);
    	Top               := pnlDisplayPattern.Top;
    	Left              := pnlDisplayPattern.Left;
    	Height            := pnlDisplayPattern.Height;
    	Width             := pnlDisplayPattern.Width;
    	StyleElements     := [];
    	ParentBackground  := False;
    	Font.Size         := 16;
    	Font.Style        := [fsBold];
      Hint             	:= 'Flash CBDATA Write Progress';
      Visible           := False;
		end;
    // Erase - Title
    rzpnlFlashEraseTitle := TRzPanel.Create(Self);
    with rzpnlFlashEraseTitle do begin
    	Parent      			:= RzpnlFlashProgress;
    	Top         			:= marginTop;
    	Left        			:= marginLeft;
    	Height      			:= itemHeight;
    	Width       			:= ((itemWidth - marginLeft*3) div 6) - 5;  //TBD???
    	Caption     			:= 'Erase';
		end;
    // Erase - Time
   	pnlFlashEraseValue := TPanel.Create(Self);
    with pnlFlashEraseValue do begin
    	Parent        		:= RzpnlFlashProgress;
    	Top           		:= marginTop;
    	Left          		:= rzpnlFlashEraseTitle.Left + rzpnlFlashEraseTitle.Width;
    	Height        		:= itemHeight;
    	Width         		:= (itemWidth - marginLeft*3) div 6;  //TBD???
    	StyleElements 		:= [];
    	Color         		:= clBlack;
    	Font.Color    		:= clBtnFace;
    	Caption       		:= '0';
		end;
    // TX DATA - Title
   	rzpnlFlashTxTitle := TRzPanel.Create(Self);
    with rzpnlFlashTxTitle do begin
    	Parent         		:= RzpnlFlashProgress;
    	Top            		:= marginTop;
    	Left           		:= pnlFlashEraseValue.Left + pnlFlashEraseValue.Width + 3;
    	Height         		:= itemHeight;
    	Width          		:= rzpnlFlashEraseTitle.Width + 10;
    	Caption        		:= 'DataTX';
		end;
    // TX DATA - Percentage
    pnlFlashTxValue := TPanel.Create(Self);
    with pnlFlashTxValue do begin
      Parent           	:= RzpnlFlashProgress;
      Top              	:= marginTop;
      Left             	:= rzpnlFlashTxTitle.Left + rzpnlFlashTxTitle.Width;
      Height           	:= itemHeight;
      Width            	:= pnlFlashEraseValue.Width;  //TBD???
      StyleElements    	:= [];
      Color            	:= clBlack;
      Font.Color       	:= clBtnFace;
      Caption          	:= '0';
    end;
    // WRITE END ACK - Title
    rzpnlFlashWriteAckTitle := TRzPanel.Create(Self);
    with rzpnlFlashWriteAckTitle do begin
      Parent          	:= RzpnlFlashProgress;
      Top             	:= marginTop;
      Left            	:= pnlFlashTxValue.Left + pnlFlashTxValue.Width + 3;
      Height          	:= itemHeight;
      Width           	:= rzpnlFlashEraseTitle.Width;  //TBD???
      Caption         	:= 'Write';
    end;
    // WRITE END - Time
    pnlFlashWriteAckValue := TPanel.Create(Self);
    with pnlFlashWriteAckValue do begin
      Parent          	:= RzpnlFlashProgress;
      Top             	:= marginTop;
      Left            	:= rzpnlFlashWriteAckTitle.Left + rzpnlFlashWriteAckTitle.Width;
      Height          	:= itemHeight;
      Width           	:= pnlFlashEraseValue.Width;   //TBD???
      StyleElements   	:= [];
      Color           	:= clBlack;
      Font.Color      	:= clBtnFace;
      Caption         	:= '0';
    end;
    //---------------------------------- Channel MLog (for backward compatabiliy to PocbAuto)
    pnlInsStatus := TPanel.Create(Self);
    with pnlInsStatus  do begin
    	Parent           	:= RzpnlChGrp;
    	Align            	:= alTop;
    	Alignment        	:= taLeftJustify;
    	Top              	:= pnlDisplayPattern.Top + pnlDisplayPattern.Height;
    	Left             	:= marginLeft;
    	Height           	:= itemHeight;
    	Width            	:= itemWidth;
    	StyleElements    	:= [];
    	ParentBackground 	:= False;
    	Color            	:= clBtnFace;
    	Font.Color       	:= clBlack;
    	Font.Size        	:= 16;
    	Font.Style       	:= [fsBold];
    	ShowHint         	:= True;
    	Hint             	:= 'Channel Flow Status';
    	Caption          	:= '';
    end;

    //---------------------------------- Channel Log (gridFlowSeq, mmChannelLog)
    RzpnlLogGrp := TRzPanel.Create(self);
    RzpnlLogGrp.Parent := RzpnlChGrp;
    RzpnlLogGrp.Align  := alClient;
    RzpnlLogGrp.BorderOuter := TframeStyleEx(fsFlat);

    //---------------------------------- FlowSeq
    gridFlowSeq := TAdvStringGrid.Create(Self);
    with gridFlowSeq do begin
    	Parent 				:= RzpnlLogGrp;
    	Align 				:= alLeft;
      DefaultRowHeight 	:= 16;
    	Width  				:= 140;
    	ColCount 			:= 2;
      RowCount     	:= DefPocb.POCB_SEQ_MAX+1;
    	Colwidths[0] 	:= 18;
    	Colwidths[1] 	:= 122;
      StyleElements := [];
    	ParentBackground 	:= False;
    	Font.Name 		:= 'Calibri'; //'Arial Narrow';
    	Font.Size 		:= 8;
      Font.Style    := [fsBold];
      Font.Color    := clBlack;
      FixedCols 		:= 0;
      FixedRows 		:= 0;
      //FocusCell(-1,-1);
    	ScrollBars 		:= ssNone;
    	Visible 			:= True;
    //FixedColor    := clBtnFace;
      ShowSelection := False;  //!!!
      Navigation.AllowCtrlEnter := False;     //TBD???
      Navigation.AlwaysEdit := False;
      MouseActions.NoScrollOnPartialCol := True; //!!!  TBD???
      MouseActions.NoScrollOnPartialRow := True; //!!!  TBD???
      MouseActions.NoAutoRangeScroll    := True; //!!!
    //Enabled       := False; //2019-04-29 (Enabled: Controls whether the control responds to mouse, keyboard, and timer events.)
    //ReadOnly      := True;
		end;
		CreateGridFlowSeq;

		//
    mmChannelLog := TRichEdit.Create(self);
    with mmChannelLog do begin
      Parent            := RzpnlLogGrp;
      Align             := alClient;
      ScrollBars        := ssVertical;
    //Alignment         := taLeftJustify;
  	//Top               := gridChPower.Top + gridChPower.Height + marginTop;
  	//Left              := marginLeft;
  	//Height            := RzpnlJigCommon1.Height - mmChannelLog.Top;
  	//Width             := itemWidth;
      StyleElements   	:= [];
      ScrollBars        := ssVertical;
    //ParentBackground	:= False;
    //Color             := clBlack;
      Font.Name 		    := 'Tahoma';
    //Font.Color        := clBlack;
      Font.Size         := 9;
      Font.Style        := [fsBold];
      ShowHint          := True;
    //Enabled           := False; //2019-04-29 (Enabled: Controls whether the control responds to mouse, keyboard, and timer events.)
      ReadOnly          := True;
      Hint              := 'Channel Log Message';
    end;
//end;

  pnlShowNgConfirm.Parent  := RzpnlJigMain;
  pnlShowNgConfirm.Visible := False;
  pnlShowNgConfirm.Left := pnlTactUnitValue.Left + pnlTactUnitValue.Width;
  pnlShowNgConfirm.Top  := pnlTactUnitValue.Top;
  pnlShowNgConfirm.BringToFront;

	{$IFDEF SUPPORT_1CG2PANEL}
  pnlShowSkipPocbConfirm.Parent  := RzpnlJigMain;  //2022-06-XX SKIP_POCB
  pnlShowSkipPocbConfirm.Visible := False;
  pnlShowSkipPocbConfirm.Left := pnlTactUnitValue.Left + pnlTactUnitValue.Width;
  pnlShowSkipPocbConfirm.Top  := pnlTactUnitValue.Top;
  pnlShowSkipPocbConfirm.BringToFront;
	{$ENDIF}

  //
  with RzpnlBcrKbdInput do begin //2022-06-22
    Parent  := RzpnlChGrp;
    Visible := False;
    Top     := RzpnlTestCnt.Top;
    Left    := RzpnlTestCnt.Left;
    Width   := RzpnlTestCnt.Width;
    BringToFront;
  end;
  btnBcrKbdInputEnter.Width := RzpnlBcrKbdInput.Width div 2; //2022-06-10
  btnBcrKbdInputClear.Width := RzpnlBcrKbdInput.Width div 2; //2022-06-10

  //
  with RzgrpScanBcrOtherChMsg do begin //2023-08-11
    Parent  := RzpnlChGrp;
    Visible := False;
    Top     := RzpnlTestCnt.Top;
    Left    := RzpnlTestCnt.Left;
    Width   := RzpnlTestCnt.Width;
    BringToFront;
  end;

  //----------------------------------------------------------------------------
  // Common2 for Jig (Bottom)
  //----------------------------------------------------------------------------
  marginTop   := 0;
  marginLeft  := 0;
  itemHeight  := nPnlJigCmmon2Height;
  itemWidth   := RzpnlJigMain.Width - marginLeft;

  RzpnlJigCommon2 := TRzPanel.Create(Self);
	with RzpnlJigCommon2 do begin
  	Parent      	:= RzpnlJigMain;
    StyleElements	:= [];
  	Align       	:= alLeft;
  	Alignment   	:= taRightJustify;
  	BorderOuter 	:= TframeStyleEx(fsFlat);
  	Top         	:= RzpnlJigCommon1.Top + RzpnlJigCommon1.Height + marginTop;
  	Left        	:= marginLeft;
  	Height      	:= itemHeight;
  	Width       	:= itemWidth;
  	Font.Color  	:= clYellow;
  	Font.Size   	:= 12;
	end;

  marginTop   := 1;
	marginLeft  := 1;
  // Jig Status
  pnlJigStatus := TPanel.Create(Self);
  with pnlJigStatus  do begin
    Parent            := RzpnlJigCommon2;
    Align             := alClient;
  	Alignment         := taLeftJustify;
  	Top               := RzpnlJigCommon2.Top;
  	Left              := RzpnlJigCommon2.Left;
  	Height            := RzpnlJigCommon2.Height - marginTop;
  	Width             := RzpnlJigCommon2.Width - marginLeft;
    StyleElements   	:= [];
    ParentBackground	:= False;
    Color             := clBlack;
    Font.Color        := clRed;
    Font.Size         := 14;
    Font.Style        := [fsBold];
    ShowHint          := True;
    Hint              := 'JIG Status Message';
  end;

  //----------------------------------------------------------------------------
  //
  //----------------------------------------------------------------------------
  SetLanguage(common.SystemInfo.Language);
//RzpnlJigMain.EnableAlign;
  RzpnlJigMain.Visible := True;

  //----------------------------------------------------------------------------
  // Timer for JIG
  //----------------------------------------------------------------------------

  //------------------------------------ Timer (Tact Total)
  m_nTotalTact := 0;
  tmrTotalTact := TTimer.Create(Self);
  tmrTotalTact.Interval := 1000;
  tmrTotalTact.OnTimer  := tmrTotalTactTimer;
  tmrTotalTact.Enabled  := False;
  //------------------------------------ Timer (Tact Jig = Stage/Shutter + Unit = Press READY_SW ~ Stage_Backward_Complete)
  m_nJigTact := 0;
  tmrJigTact := TTimer.Create(Self);
  tmrJigTact.Interval  := 1000;
  tmrJigTact.OnTimer   := tmrJigTactTimer;
  tmrJigTact.Enabled   := False;
  //------------------------------------ Timer (Tact Unit)
  m_nUnitTact := 0;
  tmrUnitTact := TTimer.Create(Self);
  tmrUnitTact.Interval  := 1000;
  tmrUnitTact.OnTimer   := tmrUnitTactTimer;
  tmrUnitTact.Enabled   := False;

  //------------------------------------ Timer (Robot Light)
  tmrRobotLight := TTimer.Create(Self);  //A2CHv3:ROBOT
  tmrRobotLight.Interval  := 300;
  tmrRobotLight.OnTimer   := tmrRobotLightTimer;
  tmrRobotLight.Enabled   := True;

  //------------------------------------ Timer (Flash Write - Erase) //2021-05
  m_nFlashEraseTact := 0;
  tmrFlashEraseTact := TTimer.Create(Self);
  tmrFlashEraseTact.Interval  := 1000;
  tmrFlashEraseTact.OnTimer   := tmrFlashEraseTactTimer;
  tmrFlashEraseTact.Enabled   := False;
  //------------------------------------ Timer (Flash Write - End Ack Wait) //2021-05
  m_nFlashWriteAckTact := 0;
  tmrFlashWriteAckTact := TTimer.Create(Self);
  tmrFlashWriteAckTact.Interval  := 1000;
  tmrFlashWriteAckTact.OnTimer   := tmrFlashWriteAckTactTimer;
  tmrFlashWriteAckTact.Enabled   := False;
end;

//==============================================================================
procedure TfrmTest1Ch.CreateGridFlowSeq;
var
  nFlowSeq, nGridIdx : Integer;
  sFlowSeq, sTemp : string;

	procedure AddFlowSeqToGrid(nStep: Integer);
  begin
		GuiFlowSeqToGridIdx[nStep] := nGridIdx;
		if nStep = DefPocb.POCB_SEQ_UNKNOWN then begin
			gridFlowSeq.Cells[0,nGridIdx] := '#';
			gridFlowSeq.Cells[1,nGridIdx] := 'STEP';
		end
		else begin
			gridFlowSeq.Cells[0,nGridIdx] := IntToStr(nGridIdx);
			gridFlowSeq.Cells[1,nGridIdx] := Common.PocbFlowSeqStr[nStep];
		end;
		Inc(nGridIdx);
	end;

begin
	// Make PocbFlowSeqStr
	for nFlowSeq := DefPocb.POCB_SEQ_UNKNOWN to DefPocb.POCB_SEQ_MAX do begin
		case nFlowSeq of
      DefPocb.POCB_SEQ_UNKNOWN                    : sFlowSeq := 'UNKNOWN';
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  		//TBD:A2CH? //TBD:A2CHv2?
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO)}
			DefPocb.POCB_SEQ_SCAN_BCR                   : sFlowSeq := 'SCAN BCR';
      {$IFDEF SITE_LENSVN}
      DefPocb.POCB_SEQ_MES_PCHK                   : sFlowSeq := TernaryOp(Common.SystemInfo.UseGIB,'MES:GIB START','MES START');
      {$ELSE}
			DefPocb.POCB_SEQ_MES_PCHK                   : sFlowSeq := TernaryOp(Common.SystemInfo.UseGIB,'MES INS_PCHK','MES PCHK');
      {$ENDIF}
 			DefPocb.POCB_SEQ_INIT_POWER_ON              : sFlowSeq := 'INIT POWER ON';
      {$IFDEF SUPPORT_1CG2PANEL}
 			DefPocb.POCB_SEQ_CONFIRM_SKIP_POCB          : sFlowSeq := 'CONFIRM SKIP-POCB';
      {$ENDIF}
			DefPocb.POCB_SEQ_INIT_CBPARA_WRITE          : sFlowSeq := 'EEP.W(CBPARA-Before)';
			DefPocb.POCB_SEQ_INIT_POWER_RESET           : sFlowSeq := 'INIT POWER RESET';
			DefPocb.POCB_SEQ_PAT_DISP_POWERON           : sFlowSeq := 'PATTERN (PowerOn)';
			DefPocb.POCB_SEQ_PROCMASK_BEFORE_CHECK      : sFlowSeq := 'EEP.C(ProcMask-Before)';
			DefPocb.POCB_SEQ_PROCMASK_BEFORE_WRITE      : sFlowSeq := 'EEP.W(ProcMask-Before)';
			DefPocb.POCB_SEQ_PRESS_START                : sFlowSeq := 'PRESS START';
			DefPocb.POCB_SEQ_STAGE_FWD                  : sFlowSeq := 'STAGE FORWARD';
			DefPocb.POCB_SEQ_CAM_PROC_CB1               : sFlowSeq := 'CAM-PROC CB1';
			DefPocb.POCB_SEQ_CB1_CBDATA_RCV             : sFlowSeq := 'CBDATA RCV';
			DefPocb.POCB_SEQ_CB1_CBDATA_FLASH_WRITE     : sFlowSeq := 'FLASH.W(CBDATA)';
			DefPocb.POCB_SEQ_CB1_CBPARA_AFTERPUC_WRITE  : sFlowSeq := 'EEP.W(AfterCB)';
			DefPocb.POCB_SEQ_CB1_POWER_RESET            : sFlowSeq := 'POWER RESET';
			DefPocb.POCB_SEQ_CAM_PROC_CB2               : sFlowSeq := 'CAM-PROC CB2';
			DefPocb.POCB_SEQ_CB2_CBDATA_RCV             : sFlowSeq := 'CB2 CBDATA RCV';
			DefPocb.POCB_SEQ_CB2_CBDATA_FLASH_WRITE     : sFlowSeq := 'FLASH.W(CBDATA)';
			DefPocb.POCB_SEQ_CB2_CBPARA_AFTERPUC_WRITE  : sFlowSeq := 'EEP.W(AfterCB)';
			DefPocb.POCB_SEQ_CB2_POWER_RESET            : sFlowSeq := 'CB2 POWER RESET';
			DefPocb.POCB_SEQ_CAM_PROC_EXTRA             : sFlowSeq := 'CAM-PROC EXTRA';
			DefPocb.POCB_SEQ_PROCMASK_AFTER_WRITE       : sFlowSeq := 'EEP.W(ProcMask-After)';
			DefPocb.POCB_SEQ_FINAL_CBPARA_WRITE         : sFlowSeq := 'EEP.W(CBPARA-After)';
			DefPocb.POCB_SEQ_PUC_PROC_END               : sFlowSeq := 'PUC-PROC END';
			DefPocb.POCB_SEQ_PAT_DISP_VERIFY            : sFlowSeq := 'PATTERN (Verify)';
			DefPocb.POCB_SEQ_STAGE_BWD                  : sFlowSeq := 'STAGE BACKWARD';
      {$IFDEF SITE_LENSVN}
      DefPocb.POCB_SEQ_MES_EICR                   : sFlowSeq := TernaryOp(Common.SystemInfo.UseGIB,'MES:GIB END','MES END');
      {$ELSE}
			DefPocb.POCB_SEQ_MES_EICR                   : sFlowSeq := TernaryOp(Common.SystemInfo.UseGIB,'MES RPR_EIJR','MES EICR');
      {$ENDIF}
{$ELSEIF Defined(POCB_GAGO) or Defined(POCB_F2CH)}
 			DefPocb.POCB_SEQ_INIT_POWER_ON              : sFlowSeq := 'INIT POWER ON';
      DefPocb.POCB_SEQ_INIT_CBPARA_WRITE          : sFlowSeq := 'CBPARA-Before Write';
			DefPocb.POCB_SEQ_INIT_POWER_RESET           : sFlowSeq := 'INIT POWER RESET';
			DefPocb.POCB_SEQ_PAT_DISP_POWERON           : sFlowSeq := 'PATTERN (PowerOn)';
			DefPocb.POCB_SEQ_SCAN_BCR                   : sFlowSeq := 'SCAN BCR';
      {$IFDEF SITE_LENSVN}
      DefPocb.POCB_SEQ_MES_PCHK                   : sFlowSeq := TernaryOp(Common.SystemInfo.UseGIB,'MES:GIB START','MES START');
      {$ELSE}
			DefPocb.POCB_SEQ_MES_PCHK                   : sFlowSeq := TernaryOp(Common.SystemInfo.UseGIB,'MES INS_PCHK','MES PCHK');
      {$ENDIF}
			DefPocb.POCB_SEQ_PRESS_START                : sFlowSeq := 'PRESS START';
			DefPocb.POCB_SEQ_STAGE_FWD                  : sFlowSeq := 'STAGE FWD';
			DefPocb.POCB_SEQ_CAM_PROC_CB1               : sFlowSeq := 'CAM-PROC CB1';
			DefPocb.POCB_SEQ_CB1_CBDATA_RCV             : sFlowSeq := 'CB1 PUC-DATA RCV';
			DefPocb.POCB_SEQ_CB1_CBDATA_FLASH_WRITE     : sFlowSeq := 'CB1 FLASH.W(CBDATA)';
			DefPocb.POCB_SEQ_CB1_CBPARA_FLASH_WRITE     : sFlowSeq := 'CB1 FLASH.W(CBPARA)';
			DefPocb.POCB_SEQ_CB1_POWER_RESET            : sFlowSeq := 'CB1 POWER RESET';
			DefPocb.POCB_SEQ_CAM_PROC_CB2               : sFlowSeq := 'CAM-PROC CB2';
			DefPocb.POCB_SEQ_CB2_CBDATA_RCV             : sFlowSeq := 'CB2 CBDATA RCV';
			DefPocb.POCB_SEQ_CB2_CBDATA_FLASH_WRITE     : sFlowSeq := 'CB2 FLASH.W(CBDATA)';
			DefPocb.POCB_SEQ_CB2_CBPARA_FLASH_WRITE     : sFlowSeq := 'CB2 FLASH.W(CBPARA)';
			DefPocb.POCB_SEQ_CB2_POWER_RESET            : sFlowSeq := 'CB2 POWER RESET';
      DefPocb.POCB_SEQ_CAM_PROC_CB3               : sFlowSeq := 'CAM-PROC CB3';
			DefPocb.POCB_SEQ_CB3_CBDATA_RCV             : sFlowSeq := 'CB3 PUC-DATA RCV';
			DefPocb.POCB_SEQ_CB3_CBDATA_FLASH_WRITE     : sFlowSeq := 'CB3 FLASH.W(CBDATA)';
			DefPocb.POCB_SEQ_CB3_CBPARA_FLASH_WRITE     : sFlowSeq := 'CB3 FLASH.W(CBPARA)';
			DefPocb.POCB_SEQ_CB3_POWER_RESET            : sFlowSeq := 'CB3 POWER RESET';
			DefPocb.POCB_SEQ_CAM_PROC_CB4               : sFlowSeq := 'CAM-PROC CB4';
			DefPocb.POCB_SEQ_CB4_CBDATA_RCV             : sFlowSeq := 'CB4 CBDATA RCV';
			DefPocb.POCB_SEQ_CB4_CBDATA_FLASH_WRITE     : sFlowSeq := 'CB4 FLASH.W(CBDATA)';
			DefPocb.POCB_SEQ_CB4_CBPARA_FLASH_WRITE     : sFlowSeq := 'CB4 FLASH.W(CBPARA)';
			DefPocb.POCB_SEQ_CB4_POWER_RESET            : sFlowSeq := 'CB4 POWER RESET';
			DefPocb.POCB_SEQ_CAM_PROC_EXTRA             : sFlowSeq := 'CAM-PROC EXTRA';
			DefPocb.POCB_SEQ_PUC_PROC_END               : sFlowSeq := 'PUC-PROC END';
			DefPocb.POCB_SEQ_PAT_DISP_VERIFY            : sFlowSeq := 'PATTERN (Verify)';
			DefPocb.POCB_SEQ_STAGE_BWD                  : sFlowSeq := 'STAGE BACKWARD';
      {$IFDEF SITE_LENSVN}
      DefPocb.POCB_SEQ_MES_EICR                   : sFlowSeq := TernaryOp(Common.SystemInfo.UseGIB,'MES:GIB END','MES END');
      {$ELSE}
			DefPocb.POCB_SEQ_MES_EICR                   : sFlowSeq := TernaryOp(Common.SystemInfo.UseGIB,'MES RPR_EIJR','MES EICR');
      {$ENDIF}
{$ELSEIF Defined(ITOLED_POCB) or Defined(POCB_ITOLED)}
{$ENDIF}
			DefPocb.POCB_SEQ_POWER_OFF                  : sFlowSeq := 'POWER OFF';
		end;
		Common.PocbFlowSeqStr[nFlowSeq] := sFlowSeq;
	end;

	// Init GuiFlowSeqToGridIdx 
	nGridIdx := 0;
	for nFlowSeq := DefPocb.POCB_SEQ_UNKNOWN to DefPocb.POCB_SEQ_MAX do begin
		GuiFlowSeqToGridIdx[nFlowSeq] := 0;
	end;
  
	// Make GuiFlowSeqToGridIdx
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_UNKNOWN);
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  //TBD:A2CH? //TBD:A2CHv2?
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO)}
	if Common.TestModelInfo2[m_nCh].UseScanFirst then begin
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_SCAN_BCR);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_MES_PCHK);
	end;
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_INIT_POWER_ON);
	{$IFDEF SUPPORT_1CG2PANEL}
  if Common.SystemInfo.UseAssyPOCB then begin
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CONFIRM_SKIP_POCB);
	end;
	{$ENDIF}
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_INIT_CBPARA_WRITE);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_INIT_POWER_RESET);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_PAT_DISP_POWERON);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_PROCMASK_BEFORE_CHECK);
	if not Common.TestModelInfo2[m_nCh].UseScanFirst then begin
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_SCAN_BCR);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_MES_PCHK);
	end;
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_PROCMASK_BEFORE_WRITE);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_PRESS_START);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_STAGE_FWD);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CAM_PROC_CB1);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB1_CBDATA_RCV);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB1_CBDATA_FLASH_WRITE);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB1_CBPARA_AFTERPUC_WRITE);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB1_POWER_RESET);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CAM_PROC_EXTRA);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_PROCMASK_AFTER_WRITE);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_FINAL_CBPARA_WRITE);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_PAT_DISP_VERIFY);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_STAGE_BWD);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_MES_EICR);
{$ELSEIF Defined(POCB_GAGO) or Defined(POCB_F2CH)}
	if Common.TestModelInfo2[m_nCh].UseScanFirst then begin
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_SCAN_BCR);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_MES_PCHK);
	end;
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_INIT_POWER_ON);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_INIT_CBPARA_WRITE);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_INIT_POWER_RESET);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_PAT_DISP_POWERON);
	if not Common.TestModelInfo2[m_nCh].UseScanFirst then begin
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_SCAN_BCR);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_MES_PCHK);
	end;
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_PRESS_START);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_STAGE_FWD);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CAM_PROC_CB1);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB1_CBDATA_RCV);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB1_CBDATA_FLASH_WRITE);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB1_CBPARA_FLASH_WRITE);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB1_POWER_RESET);

	if Common.TestModelInfo2[m_nCh].CamCBCount >= 2 then begin
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CAM_PROC_CB2);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB2_CBDATA_RCV);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB2_CBDATA_FLASH_WRITE);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB2_CBPARA_FLASH_WRITE);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB2_POWER_RESET);
  end;

  if Common.TestModelInfo2[m_nCh].CamCBCount >= 4 then begin
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CAM_PROC_CB3);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB3_CBDATA_RCV);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB3_CBDATA_FLASH_WRITE);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB3_CBPARA_FLASH_WRITE);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB3_POWER_RESET);
    AddFlowSeqToGrid(DefPocb.POCB_SEQ_CAM_PROC_CB4);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB4_CBDATA_RCV);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB4_CBDATA_FLASH_WRITE);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB4_CBPARA_FLASH_WRITE);
		AddFlowSeqToGrid(DefPocb.POCB_SEQ_CB4_POWER_RESET);
	end;

	AddFlowSeqToGrid(DefPocb.POCB_SEQ_CAM_PROC_EXTRA);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_PAT_DISP_VERIFY);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_STAGE_BWD);
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_MES_EICR);
{$ELSEIF Defined(ITOLED_POCB) or Defined(POCB_ITOLED)}
{$ENDIF}
	AddFlowSeqToGrid(DefPocb.POCB_SEQ_POWER_OFF);
end;

//==============================================================================
procedure  TfrmTest1Ch.ShowGui(hMain: HWND);
begin
  m_hMain := hMain;
  DongaSwitch := TSerialSwitch.Create(hMain,Self.Tag);
  DongaSwitch.OnRevSwData := RevSwDataJig;
	//
	if DongaGmes <> nil then begin
  	DongaGMes.hTestHandle[m_nJig] := Self.Handle; //TBD:GMES?
	end;
  //
  CreateGui;
  //
  JigLogic[m_nJig] := TJig.Create(m_nJig,hMain,Self.Handle);
  //
  SetConfig;
  UpdatePtList(hMain);

  SetCRCValue(0{Model},Common.m_ModelCrc[m_nCh].ModelMcf);
{$IFDEF USE_MODEL_PARAM_CSV}
//TBD:MERGE? SetCRCValue(0{Model},Common.m_ModelCrc[m_nCh].ModelParamCsv); 2022-09-XX
{$ENDIF}
end;

procedure TfrmTest1Ch.ShowJIGStatus(sMsg: string);
begin
  pnlJigStatus.Caption    := sMsg;
  pnlJigStatus.Color      := clBlack;
  pnlJigStatus.Font.Color := clRed;
end;

//==============================================================================
procedure TfrmTest1Ch.ClearChData;
begin
	// GUI
  // ----------------------------------- Serial Number
   pnlSerialNo.Caption := '';
   pnlPCBNo.Caption    := '';
  // ----------------------------------- MES Result
  pnlMesResult.Caption := '';
//if Common.SystemInfo.UIType in [DefPocb.UI_BLACK,DefPocb.UI_WIN10_BLACK] then begin
    pnlMesResult.Color := clBlack;
    pnlMesResult.Font.Color := clWhite;
//end
//else begin
//  pnlMesResult.Color := clBtnFace;
//  pnlMesResult.Font.Color := clBlack;
//end;
  // ----------------------------------- PG Status
//if Common.SystemInfo.UIType in [DefPocb.UI_BLACK,DefPocb.UI_WIN10_BLACK] then begin
    DisplayChStatus(CH_STATUS_INFO,'Ready');
//end
//else begin
//  pnlChStatus.Color := clBtnFace;
//  pnlChStatus.Font.Color := clBlack;
//end;
  // ----------------------------------- Power Status
  gridChPower.ClearAll;
  gridChPower.ColumnHeaders.Add('');
  gridChPower.ColumnHeaders.Add('Voltage');
  gridChPower.ColumnHeaders.Add('');
  gridChPower.ColumnHeaders.Add('Current');
  gridChPower.Cells[0,1] := 'VCC (V)';
  gridChPower.Cells[2,1] := 'ICC (mA)';
{$IFDEF PANEL_AUTO}
  gridChPower.Cells[0,2] := 'VDD (V)';
  gridChPower.Cells[2,2] := 'IDD (mA)';
{$ELSE}
  gridChPower.Cells[0,2] := 'VEL (V)';
  gridChPower.Cells[2,2] := 'IEL (mA)';
{$ENDIF}

  // ----------------------------------- Channel Log
  mmChannelLog.Clear;
  //------------------------------------ Jig Status
  pnlJigStatus.Caption := '';
  //------------------------------------ Display Pattern or Flash Write Progress
  pnlDisplayPattern.Visible  := True;
  RzpnlFlashProgress.Visible := False;

	// Bcr Keyboard Input
  edBcrKbdInputNum.Clear;            //2023-06-22
  RzpnlBcrKbdInput.Visible := False; //2023-06-22

  // ScanBcr Other Ch Message
  RzgrpScanBcrOtherChMsg.Visible := False; //2023-08-11

	// Channel Data
{$IFDEF REF_ISPD_L}
  edBCRNums.Clear;
{$ENDIF}
{$IFDEF REF_ISPD_L}
  pnlDfsResult.Caption := '';
  pnlCurDftName.Caption := '';
{$ENDIF}
end;

procedure TfrmTest1Ch.ClearQuantity;
begin
  m_nOkCnt := 0;
  m_nNgCnt := 0;
  //
  pnlCntTotalValue.Caption := '0';
  pnlCntOkValue.Caption := '0';
  pnlCntNgValue.Caption := '0';
end;

function TfrmTest1Ch.CheckOutOfPwr(PwrData: TPwrDataPg; out sErrMsg : string): Boolean;
var
  nLimit, nMesaure : Integer;
begin
	sErrMsg := '';
	
	if (PwrData.NG = 255) then begin // ALL_OK
    Result := False; //STATUS OK
    Exit;
  end;

  Result := True; //STATUS NG
  with Common.TestModelInfo[m_nJig] do begin
    case PwrData.NG of
      0: begin
        nLimit  := PWR_LIMIT_H[DefPG.PWR_VCC];      nMesaure := PwrData.VCC;
        sErrMsg := Format('VCC High NG : Limit(%0.2fV) Measure(%0.2fV) Diff(%0.2fV)', [nLimit/1000, nMesaure/1000, (nMesaure-nLimit)/1000]);
      end;
      1: begin
        nLimit  := PWR_LIMIT_L[DefPG.PWR_VCC];      nMesaure := PwrData.VCC;
        sErrMsg := Format('VCC Low NG : Limit(%0.2fV) Measure(%0.2fV) Diff(%0.2fV)',  [nLimit/1000, nMesaure/1000, (nMesaure-nLimit)/1000]);
      end;
      2: begin
        nLimit  := PWR_LIMIT_H[DefPG.PWR_VDD_VEL];  nMesaure := PwrData.VDD_VEL;
        sErrMsg := Format('VDD High NG : Limit(%0.2fV) Measure(%0.2fV) Diff(%0.2fV)', [nLimit/1000, nMesaure/1000, (nMesaure-nLimit)/1000]);
      end;
      3: begin
        nLimit  := PWR_LIMIT_L[DefPG.PWR_VDD_VEL];  nMesaure := PwrData.VDD_VEL;
        sErrMsg := Format('VDD Low NG : Limit(%0.2fV) Measure(%0.2fV) Diff(%0.2fV)', [nLimit/1000, nMesaure/1000, (nMesaure-nLimit)/1000]);
      end;
    //4 : //VBR_H
      6: begin
        nLimit  := PWR_LIMIT_H[DefPG.PWR_ICC];      nMesaure := PwrData.ICC;
        sErrMsg := Format('ICC High NG : Limit(%dmA) Measure(%dmA) Diff(%dmA)', [nLimit, nMesaure, nMesaure-nLimit]);
      end;
      7: begin
        nLimit  := PWR_LIMIT_L[DefPG.PWR_ICC];      nMesaure := PwrData.ICC;
        sErrMsg := Format('ICC Low NG : Limit(%dmA) Measure(%dmA) Diff(%dmA)', [nLimit, nMesaure,nMesaure-nLimit]);
      end;
      8: begin
        nLimit  := PWR_LIMIT_H[DefPG.PWR_IDD_IEL];  nMesaure := PwrData.IDD_IEL;
        sErrMsg := Format('IDD High NG : Limit(%dmA) Measure(%dmA) Diff(%dmA)', [nLimit, nMesaure, nMesaure-nLimit]);
      end;
      9: begin
        nLimit  := PWR_LIMIT_L[DefPG.PWR_IDD_IEL];  nMesaure := PwrData.IDD_IEL;
        sErrMsg := Format('IDD Low NG : Limit(%dmA) Measure(%dmA) Diff(%dmA)', [nLimit, nMesaure, nMesaure-nLimit]);
      end;
      //
      17: sErrMsg := 'VCC Short NG';
      18: sErrMsg := 'VDD Short NG';
      19: sErrMsg := 'ICC Short NG';
      20: sErrMsg := 'IDD Short NG';
      //
      else begin
        if Common.SystemInfo.PG_TYPE = PG_TYPE_DP489 then begin
          sErrMsg := Format('Unknown Status=%d NG',[PwrData.NG]);;
        end
        else begin //DP200|DP201
          case PwrData.NG of
          //10:
            11: sErrMsg := 'Open Check1 NG'; //2023-10-18 DP200|DP201:OpenCheck
            12: sErrMsg := 'Open Check2 NG'; //2023-10-18 DP200|DP201:OpenCheck
            13: sErrMsg := 'Open Check3 NG'; //2023-10-18 DP200|DP201:OpenCheck
            14: sErrMsg := 'Open Check4 NG'; //2023-10-18 DP200|DP201:OpenCheck
          //15: Fan Alarm
          //16: B/L Cable Setting
            // PO Auto FPD Fail Information --- START
            31: sErrMsg := 'Set up Variables NG';
            32: sErrMsg := 'Program SER to FPD-Link IV mode NG';
            33: sErrMsg := 'Set DP Config NG';
            34: sErrMsg := 'Enable I2C Passthrough NG';
            35: sErrMsg := '[Des0] EQ fuse program NG';
            36: sErrMsg := '[Des1] EQ fuse program NG';
            37: sErrMsg := 'Program VP0 Config NG';
            38: sErrMsg := 'Program VP1 Config NG';
            39: sErrMsg := 'Enable VPs NG';
            40: sErrMsg := 'Enable PATGEN NG';
            41: sErrMsg := 'Configure Serializer TX Link Layer NG';
            42: sErrMsg := 'Set up Des0 Temp Ramp Optimizations NG';
            43: sErrMsg := 'Set up Des1 Temp Ramp Optimizations NG';
            44: sErrMsg := 'Clear CRC errors NG';
            45: sErrMsg := '[Des0] Hold Des DTG in reset NG';
            46: sErrMsg := '[Des0] Disable Stream Mapping NG';
            47: sErrMsg := '[Des0] Setup DTG NG';
            48: sErrMsg := '[Des0] Map video to display output NG';
            49: sErrMsg := '[Des0] Configure 988 Display NG';
            50: sErrMsg := '[Des0] Release Des DTG reset NG';
            51: sErrMsg := '[Des0] Enable LVDS Output NG';
            52: sErrMsg := '[Des1] Hold Des DTG in reset NG';
            53: sErrMsg := '[Des1] Disable Stream Mapping NG';
            54: sErrMsg := '[Des1] Setup DTG NG';
            55: sErrMsg := '[Des1] Map video to display output NG';
            56: sErrMsg := '[Des1] Configure 988 Display NG';
            57: sErrMsg := '[Des1] Release Des DTG reset NG';
            58: sErrMsg := '[Des1] Enable LVDS Output NG';
            59: sErrMsg := '126 GPIO Setup NG';
            60: sErrMsg := '340 GPIO Setup NG';
            // PO Auto FPD Fail Information --- END
            else begin
              sErrMsg := Format('Unknown Status(%d) NG',[PwrData.NG]);;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmTest1Ch.DisplayPwrData(nCh: Integer; PwrData: TPwrDataPg);
var
  bSavePwrData : Boolean;
begin
  bSavePwrData := False;
  if Pg[nCh].m_bPowerOn then begin
    if PwrData.NG <> $ff then bSavePwrData := True
    else if ((Logic[nCh].m_Inspect.PwrData.VCC = 0) and (Logic[nCh].m_Inspect.PwrData.VDD_VEL = 0))  then bSavePwrData := True
    else if Pg[nCh].DisPatStruct.CurrPat.bPatternOn and (Pg[nCh].DisPatStruct.CurrPat.nCurrPatNum = Common.TestModelInfo2[nCh].PwrMeasurePatNum) then bSavePwrData := True; //2022-09-XX PwrMeasurePatNum
  end;
  if bSavePwrData then
    Logic[nCh].m_Inspect.PwrData := PwrData;   //2018-12-05 for Summary
  //
  gridChPower.DisableAlign;
  gridChPower.Cells[1,1] := Format('%0.2f',[PwrData.VCC     / 1000]); // VCC
  gridChPower.Cells[1,2] := Format('%0.2f',[PwrData.VDD_VEL / 1000]); // VDD_VEL
  gridChPower.Cells[3,1] := Format('%d',[PwrData.ICC]);               // ICC
  gridChPower.Cells[3,2] := Format('%d',[PwrData.IDD_IEL]);           // IDD_IEL
  //
  gridChPower.EnableAlign;
end;

procedure TfrmTest1Ch.SetLanguage(nIdx: Integer);
//var
//  i : Integer;
begin
{ //TBD?
  case nIdx of
    DefPocb.LANGUAGE_KOREA : begin
      btnStartTest.Caption  := 'START';  //'검사시작'
      btnStopTest.Caption   := 'STOP';   //'검사종료'
      btnVirtualKey.Caption := 'Virtual Key'; //'상세조작 버튼';
      for i := DefPocb.JIGCH_1 to DefPocb.JIGCH_MAX do begin
        rzcbChUsage[i].Caption := Format('Ch %d',[i+1+self.Tag*4]);//Format('Channel %d',[i+1+self.Tag*4]);
        rzpnlCntTotalTitle[i].Caption := 'Total';//'Product';
      end;
    end;
    DefPocb.LANGUAGE_VIETNAM : begin
      btnStartTest.Caption := 'bắt đầu';
      btnStopTest.Caption := 'Dừng lại';
      btnVirtualKey.Caption := 'phím ảo';
      for i := DefPocb.JIGCH_1 to DefPocb.JIGCH_MAX do begin
        rzcbChUsage[i].Caption := Format('kênh %d',[i+1+self.Tag*4]);//Format('Channel %d',[i+1+self.Tag*4]);
        rzpnlCntTotalTitle[i].Caption := 'sản xuất';//'Product';
      end;
    end;
  end;
}
end;

function TfrmTest1Ch.DisplayPatList(sPatGrpName: string): TPatternGroup;
var
  CurPatGrp   : TPatternGroup;
  i           : Integer;
begin
  //Common.MLog(m_nJig,'<TestCh> CH'+IntToStr(m_nJig+1)+' DisplayPatList');
  gridPatternList.RowCount := 1;
  gridPatternList.ColCount := 5;
  gridPatternList.Rows[0].Clear;

//  sPatGrpName := DongaYT.ModelInfo.PatGrFuse;
  CurPatGrp   := Common.LoadPatGroup(sPatGrpName);

  gridPatternList.HideColumn(0);
  gridPatternList.HideColumn(2);
  gridPatternList.HideColumn(3);
  gridPatternList.HideColumn(4);
  pnlPatGrpName.Caption := sPatGrpName;
  if CurPatGrp.PatCount > 0 then begin
    gridPatternList.RowCount := CurPatGrp.PatCount;
    for i := 0 to pred(CurPatGrp.PatCount) do begin
      gridPatternList.Cells[0, i] := Format('%d',[CurPatGrp.PatType[i]]);
      gridPatternList.Cells[1, i] := String(CurPatGrp.PatName[i]);
    end;
  end;
  gridPatternList.Row := 0;

  Result  := CurPatGrp;
end;

procedure TfrmTest1Ch.AppendChannelLog(sMsg: string; nLogType: integer = DefPocb.LOG_TYPE_INFO); //2022-07-30
var
  sDebug    : string;
  i, nTimes : Integer;
begin
  sDebug := FormatDateTime('[HH:MM:SS.zzz] ', now) + sMsg;
  mmChannelLog.DisableAlign;
  case nLogType of
    DefPocb.LOG_TYPE_NG: begin
      mmChannelLog.SelAttributes.Color := clRed;
    end;
    DefPocb.LOG_TYPE_DIO : begin
      mmChannelLog.SelAttributes.Color := clBlue;
    end
    else begin
    //mmChannelLog.SelAttributes.Color := clBlack;
    end;
  end;
  mmChannelLog.Lines.Add(sDebug);
  //----------------------------- ChannelLogScroll(Length(sDebug))
//mmChannelLog.Perform(EM_SCROLL,SB_LINEDOWN,0);
  nTimes := (Length(sDebug) div 68); //TBD? 2022-07-30 68 ???
  for i := 0 to nTimes do begin
    mmChannelLog.Perform(EM_SCROLL, SB_LINEDOWN, 0);
  end;
  mmChannelLog.EnableAlign;
end;

//******************************************************************************
// procedure/function: GUI(Button Action)
//******************************************************************************

procedure TfrmTest1Ch.btnStartTestClick(Sender: TObject);
begin
  Common.MLog(m_nJig,'<TestCh> Click START button');
  if not WorkStart then Exit;
{$IFDEF REF_ISPD_L}
  tmrLogIn.Enabled  := False;  tmrLogIn.Enabled := True;    // Reset Timer
  tmrLogOut.Enabled := False;  tmrLogOut.Enabled := True;   // Reset Timer
{$ENDIF}
end;

procedure TfrmTest1Ch.btnStopTestClick(Sender: TObject);
begin
  Common.MLog(m_nJig,'<TestCh> Click STOP button');

  WorkStop(StopByOperator);
{$IFDEF REF_ISPD_L}
  tmrLogIn.Enabled  := False;  tmrLogIn.Enabled := True;    // Reset Timer
  tmrLogOut.Enabled := False;  tmrLogOut.Enabled := True;   // Reset Timer
{$ENDIF}
end;

procedure TfrmTest1Ch.cbAutoPowerOffClick(Sender: TObject);
begin
  if Sender = cbAutoPowerOff then begin
    if Logic[m_nCh] <> nil then begin
      Logic[m_nCh].m_bAutoPowerOff := cbAutoPowerOff.Checked;
      Common.MLog(m_nCh,'<TestCh> Click AutoPowerOff checkbox('+BoolToStr(Logic[m_nCh].m_bAutoPowerOff)+')');
    end;
  end;
end;

{$IFDEF REF_ISPD_L}
procedure TfrmTest1Ch.ClearBcrUI(Sender: TObject);
begin
  edBCRNums[(Sender as TRzBitBtn).Tag].Text := '';
end;

procedure TfrmTest1Ch.EnterBCR(Sender: TObject);
var
  nCh : Integer;
  sData : string;
begin
  nCh := (Sender as TRzBitBtn).Tag;
  sData := edBCRNums[nCh].Text;

  GetBcrData(sData);
end;
{$ENDIF}

//******************************************************************************
// procedure/function: DIO
//******************************************************************************

procedure TfrmTest1Ch.ShowDioErr(bEmsReset: Boolean; sMsg: string);   //TBD:GUI? (JIG Status)
begin
{ //TBD:GUI:JIG?
  //Common.MLog(m_nJig,'<TestCh> CH'+IntToStr(m_nJig+1)+' ShowDioErr');
  if bEmsReset then begin
    pnlJigStatus.Caption  := sMsg;
    pnlJigStatus.Color 	  := clBtnFace;
		pnlJigStatus.Visible  := False;  //TBD:GUI? (JIG Status)
  end
  else begin
    pnlJigStatus.Caption  := sMsg;
    pnlJigStatus.Color 	  := clRed;
		pnlJigStatus.Visible  := True;   //TBD:GUI? (JIG Status)
  end;
}
end;

procedure TfrmTest1Ch.arrivedAction(nIdx: Integer);
begin
  Common.MLog(m_nCh,'<TestCh> arrivedAction');
  Logic[m_nCh].SendStartSeq3;
end;


//******************************************************************************
// procedure/function: RCB
//******************************************************************************

procedure TfrmTest1Ch.ResetChGui;  //TBD:NOT-USED?
begin
  ClearChData;
  Logic[m_nCh].StartSeqInit;
end;

procedure TfrmTest1Ch.RevSwDataJig(sGetData: String);
var
  nPos   : Integer;
  sDebug : string;
begin
  if Length(sGetData) < 3 then Exit;    //TBD: 3? 4?
  nPos := Pos('3',sGetData);
  //TMLog(m_nJig,sGetData);

  keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);

  if not (Byte(sGetData[nPos + 1]) in [$4E,$42,$31]) then begin
    if not DongaDio.CheckPinBlock(m_nJig, True) then begin
      TMLog(m_nJig,'Not Connected PinBlock');
      Exit;
    end;
  end;

  case Byte(sGetData[nPos + 1]) of
    $4E : begin   // KEY-9: Next
      sDebug := '<9Button> CH'+IntToStr(m_nJig+1)+': Key 9 Click';
      Common.MLog(m_nJig,sDebug);
      AppendChannelLog(sDebug);						
      if not WorkStart then Exit;
    end;
    $42 : begin   // KEY-8: Stop ---
      sDebug := '<9Button> CH'+IntToStr(m_nJig+1)+': Key 8 Click';
      Common.MLog(m_nJig,sDebug);
      AppendChannelLog(sDebug);			
      WorkStop(StopByOperator);
    end;
    $31 : begin   // KEY-7: //TBD:POCB_AUTO# Start?;
      sDebug := '<9Button> CH'+IntToStr(m_nJig+1)+': Key 7 Click';
      Common.MLog(m_nJig,sDebug);
      AppendChannelLog(sDebug);
      WorkStop(StopByOperator);
    end;
    $33 : begin   // KEY-5: Pre-Compensation Pat 2. (POCB Disable)
      sDebug := '<9Button> CH'+IntToStr(m_nJig+1)+': Key 5 Click';
      Common.MLog(m_nJig,sDebug);
      AppendChannelLog(sDebug);
Common.ThreadTask( procedure begin
{$IFDEF PANEL_AUTO}
      if Common.TestModelInfo2[m_nJig].UsePucOnOff or Common.TestModelInfo2[m_nJig].UsePucImage then begin //2022-07-15 UNIFORMITY_PUCONOFF //2023-04-07 FEATURE_PUC_IMAGE}
        if not Pg[m_nJig].m_bPowerOn then exit;
        Logic[m_nJig].PucCtrlPocbOnOff(False);
      end
      else begin
        if Common.TestModelInfo2[m_nJig].JudgeCount >= 2 then begin
          pnlDisplayPattern.Caption := 'Pre-Compensation Pat 2';
          Logic[m_nCh].DisplayPatCompBmp(2);
        end
        else begin
          pnlDisplayPattern.Caption := 'Reserved Button';
        end;
      end;
{$ELSE}
      if not Pg[m_nJig].m_bPowerOn then exit;
      Logic[m_nJig].PucCtrlPocbOnOff(False);
{$ENDIF}
end);
    end;
    $45 : begin   // KEY-6: Compensation Pat 2. (POCB Enable)
      sDebug := '<9Button> CH'+IntToStr(m_nJig+1)+': Key 6 Click';
      Common.MLog(m_nJig,sDebug);
      AppendChannelLog(sDebug);
Common.ThreadTask( procedure begin
{$IFDEF PANEL_AUTO}
      if Common.TestModelInfo2[m_nJig].UsePucOnOff or Common.TestModelInfo2[m_nJig].UsePucImage then begin //2022-07-15 UNIFORMITY_PUCONOFF //2023-04-07 FEATURE_PUC_IMAGE}
        if not Pg[m_nJig].m_bPowerOn then exit;
        Logic[m_nJig].PucCtrlPocbOnOff(True);
      end
      else begin
        if Common.TestModelInfo2[m_nJig].JudgeCount >= 2 then begin
          pnlDisplayPattern.Caption := 'Compensation Pat 2';
          Logic[m_nCh].DisplayPatCompBmp(3);
        end
        else begin
          pnlDisplayPattern.Caption := 'Reserved Button';
        end;
      end;
{$ELSE}
      if not Pg[m_nJig].m_bPowerOn then exit;
      Logic[m_nJig].PucCtrlPocbOnOff(True);
{$ENDIF}
end);
    end;
    $37 : begin   // KEY-1
      sDebug := '<9Button> CH'+IntToStr(m_nJig+1)+': Key 1 Click';
      Common.MLog(m_nJig,sDebug);
      AppendChannelLog(sDebug);
      DisplayPatPrevNext(False{bNext});
    end;
    $38 : begin   // KEY-2:
      sDebug := '<9Button> CH'+IntToStr(m_nJig+1)+': Key 2 Click';
      Common.MLog(m_nJig,sDebug);
      AppendChannelLog(sDebug);
      DisplayPatPrevNext(True{bNext});
    end;
    $35 : begin   // KEY-3: Pre-Compensation Pat 1. (POCB Disable)
      sDebug := '<9Button> CH'+IntToStr(m_nJig+1)+': Key 3 Click';
      Common.MLog(m_nJig,sDebug);
      AppendChannelLog(sDebug);
Common.ThreadTask( procedure begin
{$IFDEF PANEL_AUTO}
      if Common.TestModelInfo2[m_nJig].UsePucOnOff or Common.TestModelInfo2[m_nJig].UsePucImage then begin //2022-07-15 UNIFORMITY_PUCONOFF //2023-04-07 FEATURE_PUC_IMAGE}
        if not Pg[m_nJig].m_bPowerOn then exit;
        Logic[m_nJig].PucCtrlPocbOnOff(False);
      end
      else begin
        if Common.TestModelInfo2[m_nJig].JudgeCount >= 1 then begin
          pnlDisplayPattern.Caption := 'Pre-Compensation Pat 1';
          Logic[m_nCh].DisplayPatCompBmp(0); //WorkAfterPat(0);
        end
        else begin
          pnlDisplayPattern.Caption := 'Reserved Button';
        end;
      end;
{$ELSE}
      if not Pg[m_nJig].m_bPowerOn then exit;
      Logic[m_nJig].PucCtrlPocbOnOff(False);
{$ENDIF}
end);
    end;
    $36 : begin   // KEY-4: Compensation Pat 1. (POCB Enable)
      sDebug := '<9Button> CH'+IntToStr(m_nJig+1)+': Key 4 Click';
      Common.MLog(m_nJig,sDebug);
      AppendChannelLog(sDebug);
Common.ThreadTask( procedure begin
{$IFDEF PANEL_AUTO}
      if Common.TestModelInfo2[m_nJig].UsePucOnOff or Common.TestModelInfo2[m_nJig].UsePucImage then begin //2022-07-15 UNIFORMITY_PUCONOFF //2023-04-07 FEATURE_PUC_IMAGE}
        if not Pg[m_nJig].m_bPowerOn then exit;
        Logic[m_nJig].PucCtrlPocbOnOff(True);
      end
      else begin
        if Common.TestModelInfo2[m_nJig].JudgeCount >= 1 then begin
          pnlDisplayPattern.Caption := 'Compensation Pat 1';
          Logic[m_nCh].DisplayPatCompBmp(1); //WorkAfterPat(1);
        end
        else begin
          pnlDisplayPattern.Caption := 'Reserved Button';
        end;
      end;
{$ELSE}
      if not Pg[m_nJig].m_bPowerOn then exit;
      Logic[m_nJig].PucCtrlPocbOnOff(True);
{$ENDIF}
end);
    end;
  end;
{$IFDEF REF_ISPD_DFS}
  tmrLogIn.Enabled := False;
  tmrLogIn.Enabled := True;
  tmrLogOut.Enabled := False;
  tmrLogOut.Enabled
{$ENDIF}
  // 순서대로 버튼 눌렀을때 데이터.
  {02 3F 33 4E 03 (02 3F 33 4E 03 )
02 3F 33 4E 03 (02 3F 33 4E 03 )
02 3F 33 31 03 (02 3F 33 31 03 )
02 3F 33 42 03 (02 3F 33 42 03 )
02 3F 33 33 03 (02 3F 33 33 03 )
02 3F 33 45 03 (02 3F 33 45 03 )
02 3F 33 35 03 (02 3F 33 35 03 )     //3
02 3F 33 36 03 (02 3F 33 36 03 )     //4
02 3F 33 37 03 (02 3F 33 37 03 )    //1
02 3F 33 38 03 (02 3F 33 38 03 )}   //2
end;

procedure TfrmTest1Ch.btnNgConfirmSendHostClick(Sender: TObject);
begin
  pnlShowNgConfirm.Visible := False;

  if Logic[m_nJig].m_InsStatus <> IsUnload then Exit;

  if DongaGmes <> nil then begin
    if not Common.SystemInfo.UseGIB then Logic[m_nJig].SendGmesMsg(DefGmes.MES_EICR)
    else                                 Logic[m_nJig].SendGmesMsg(DefGmes.MES_RPR_EIJR);
  end;
end;

procedure TfrmTest1Ch.btnNgConfirmCancelClick(Sender: TObject);
begin
  pnlShowNgConfirm.Visible := False;

  if Logic[m_nJig].m_InsStatus <> IsUnload then Exit;

  Logic[m_nJig].SendStartSeq4;
end;

procedure TfrmTest1Ch.btnSkipPocbConfirmRunClick(Sender: TObject);  //2022-06-XX ASSY:1CG2PANEL:SkipPocbConfirm
begin
{$IFDEF SUPPORT_1CG2PANEL}
  if not pnlShowSkipPocbConfirm.Visible then Exit;
  //TBD? if Logic[m_nJig].m_InsStatus <> IsCamera then Exit;

  pnlShowSkipPocbConfirm.Visible := False;
  Logic[m_nJig].m_SkipPocbConfirmStatus := SkipPocbConfirmRUN;
{$ENDIF}
end;

procedure TfrmTest1Ch.btnSkipPocbConfirmSkipClick(Sender: TObject); //2022-06-XX ASSY:1CG2PANEL:SkipPocbConfirm
var
  bAllChSkip : Boolean;
begin
{$IFDEF SUPPORT_1CG2PANEL}
  if not pnlShowSkipPocbConfirm.Visible then Exit;
  //TBD? if Logic[m_nJig].m_InsStatus <> IsCamera then Exit;

  pnlShowSkipPocbConfirm.Visible := False;
  Logic[m_nJig].m_SkipPocbConfirmStatus := SkipPocbConfirmSKIP;
  DisplayChStatus(CH_STATUS_SKIP, 'SKIP Camera Process');
{$ENDIF}
end;

{$IFDEF USE_FPC_LIMIT}
//******************************************************************************
// procedure/function: FPC Usage Limit
//******************************************************************************

procedure TfrmTest1Ch.btnFpcUsageResetClick(Sender: TObject);  //2019-04-11
begin
  if TfrmLogIn.CheckAdminPasswd then begin
    //Common.MLog(m_nJig,'<FPC> CH'+IntToStr(m_nJig+1)+' FPC Usage Value Reset');
    //
    Common.m_nFpcUsageValue[m_nJig] := 0;
    Common.SaveFpcUsageValue(m_nJig);
    pnlFpcUsageValue.Font.Color := clLime;
    pnlFpcUsageValue.Caption := '0';
  end;
end;
{$ENDIF}

//******************************************************************************
// procedure/function: SPI Reset
//******************************************************************************

procedure TfrmTest1Ch.btnSpiResetClick(Sender: TObject);  //2019-04-29
var
  sMsg, sDebug : String;
begin
  if TfrmLogIn.CheckAdminPasswd then begin
    Common.MLog(m_nJig,'<SPI> CH'+IntToStr(m_nJig+1)+' SPI Reset');
    //
    sMsg := 'SPI Reset';
    sDebug := FormatDateTime('[HH:MM:SS.zzz] ',now) + sMsg;
    mmChannelLog.DisableAlign;
    mmChannelLog.Lines.Add(sDebug);
    mmChannelLog.Perform(EM_SCROLL,SB_LINEDOWN,0);  //2018-11-12
    mmChannelLog.EnableAlign;
    TMLog(m_nJig,sMsg);
    //
    Pg[m_nJig].SendSpiReset;
  end;
end;

//******************************************************************************
// procedure/function: RCB(Virtual)
//******************************************************************************

procedure TfrmTest1Ch.btnVirtualKeyClick(Sender: TObject);
begin
  //if not PnlRcbSimKeys.Visible then
  //  Common.MLog(m_nJig,'<VitrualKey> CH'+IntToStr(m_nJig+1)+': Open')
  //else
  //  Common.MLog(m_nJig,'<VitrualKey> CH'+IntToStr(m_nJig+1)+': Close');
  PnlRcbSimKeys.Visible := not PnlRcbSimKeys.Visible;
  PnlRcbSimKeys.Left := btnVirtualKey.Left;
  PnlRcbSimKeys.Top  := btnVirtualKey.Top + btnVirtualKey.Height
end;

procedure TfrmTest1Ch.btnCntResetClick(Sender: TObject);
begin
  ClearQuantity;
end;

procedure TfrmTest1Ch.btnRcbSimKey1PreviousPatClick(Sender: TObject);
var
  sDebug : string;
begin
  sDebug := '<VitrualKey> CH'+IntToStr(m_nJig+1)+': Key 1 Click';
  Common.MLog(m_nJig,sDebug);
  AppendChannelLog(sDebug);
	DisplayPatPrevNext(False{bNext});
end;

procedure TfrmTest1Ch.btnRcbSimKey2NextPatClick(Sender: TObject);
var
  sDebug : string;
begin
  sDebug := '<VitrualKey> CH'+IntToStr(m_nJig+1)+': Key 2 Click';
  Common.MLog(m_nJig,sDebug);
  AppendChannelLog(sDebug);
  DisplayPatPrevNext(True{bNext});
end;

procedure TfrmTest1Ch.btnRcbSimKey3PreCompPat1Click(Sender: TObject);
var
  sDebug : string;
begin
  sDebug := '<VitrualKey> CH'+IntToStr(m_nJig+1)+': Key 3 Click';
  Common.MLog(m_nJig,sDebug);
  AppendChannelLog(sDebug);
Common.ThreadTask( procedure begin
{$IFDEF PANEL_AUTO}
  if Common.TestModelInfo2[m_nJig].UsePucOnOff or Common.TestModelInfo2[m_nJig].UsePucImage then begin //2022-07-15 UNIFORMITY_PUCONOFF //2023-04-07 FEATURE_PUC_IMAGE}
    if not Pg[m_nJig].m_bPowerOn then exit;
    Logic[m_nJig].PucCtrlPocbOnOff(False);
  end
  else begin
    if Common.TestModelInfo2[m_nJig].JudgeCount >= 1 then begin
      pnlDisplayPattern.Caption := 'Pre-Compensation Pat 1';
      Logic[m_nCh].DisplayPatCompBmp(0); //WorkAfterPat(0);
    end
    else begin
      pnlDisplayPattern.Caption := 'Reserved Button';
    end;
  end;
{$ELSE}
    if not Pg[m_nJig].m_bPowerOn then exit;
    Logic[m_nJig].PucCtrlPocbOnOff(False);
{$ENDIF}
end);
end;

procedure TfrmTest1Ch.btnRcbSimKey4CompPat1Click(Sender: TObject);
var
  sDebug : string;
begin
  sDebug := '<VitrualKey> CH'+IntToStr(m_nJig+1)+': Key 4 Click';
  Common.MLog(m_nJig,sDebug);
  AppendChannelLog(sDebug);
Common.ThreadTask( procedure begin
{$IFDEF PANEL_AUTO}
  if Common.TestModelInfo2[m_nJig].UsePucOnOff or Common.TestModelInfo2[m_nJig].UsePucImage then begin //2022-07-15 UNIFORMITY_PUCONOFF //2023-04-07 FEATURE_PUC_IMAGE}
    if not Pg[m_nJig].m_bPowerOn then exit;
    Logic[m_nJig].PucCtrlPocbOnOff(True);
  end
  else begin
    if Common.TestModelInfo2[m_nJig].JudgeCount >= 1 then begin
      pnlDisplayPattern.Caption := 'Compensation Pat 1';
      Logic[m_nCh].DisplayPatCompBmp(1); //workAfterPat(1);
    end
    else begin
      pnlDisplayPattern.Caption := 'Reserved Button';
    end;
  end;
{$ELSE}
  if not Pg[m_nJig].m_bPowerOn then exit;
  Logic[m_nJig].PucCtrlPocbOnOff(True);
{$ENDIF}
end);
end;

procedure TfrmTest1Ch.btnRcbSimKey5PreCompPat2Click(Sender: TObject);
var
  sDebug : string;
begin
  sDebug := '<VitrualKey> CH'+IntToStr(m_nJig+1)+': Key 5 Click';
  Common.MLog(m_nJig,sDebug);
  AppendChannelLog(sDebug);
Common.ThreadTask( procedure begin
{$IFDEF PANEL_AUTO}
  if Common.TestModelInfo2[m_nJig].UsePucOnOff or Common.TestModelInfo2[m_nJig].UsePucImage then begin //2022-07-15 UNIFORMITY_PUCONOFF //2023-04-07 FEATURE_PUC_IMAGE}
    if not Pg[m_nJig].m_bPowerOn then exit;
    Logic[m_nJig].PucCtrlPocbOnOff(False);
  end
  else begin
    if Common.TestModelInfo2[m_nJig].JudgeCount >= 2 then begin
      pnlDisplayPattern.Caption := 'Pre-Compensation Pat 2';
      Logic[m_nCh].DisplayPatCompBmp(2); //WorkAfterPat(2);
    end
    else begin
      pnlDisplayPattern.Caption := 'Reserved Button';
    end;
  end;
{$ELSE}
  if not Pg[m_nJig].m_bPowerOn then exit;
  Logic[m_nJig].PucCtrlPocbOnOff(False);
{$ENDIF}
end);
end;

procedure TfrmTest1Ch.btnRcbSimKey6CompPat2Click(Sender: TObject);
var
  sDebug : string;
begin
  sDebug := '<VitrualKey> CH'+IntToStr(m_nJig+1)+': Key 6 Click';
  Common.MLog(m_nJig,sDebug);
  AppendChannelLog(sDebug);
Common.ThreadTask( procedure begin
{$IFDEF PANEL_AUTO}
  if Common.TestModelInfo2[m_nJig].UsePucOnOff or Common.TestModelInfo2[m_nJig].UsePucImage then begin //2022-07-15 UNIFORMITY_PUCONOFF //2023-04-07 FEATURE_PUC_IMAGE}
    if not Pg[m_nJig].m_bPowerOn then exit;
    Logic[m_nJig].PucCtrlPocbOnOff(True);
  end
  else begin
    if Common.TestModelInfo2[m_nJig].JudgeCount >= 2 then begin
      pnlDisplayPattern.Caption := 'Compensation Pat 2';
      Logic[m_nCh].DisplayPatCompBmp(3); //WorkAfterPat(3);
    end
    else begin
      pnlDisplayPattern.Caption := 'Reserved Button';
    end;
  end;
{$ELSE}
  if not Pg[m_nJig].m_bPowerOn then exit;
  Logic[m_nJig].PucCtrlPocbOnOff(True);
{$ENDIF}
end);
end;

procedure TfrmTest1Ch.btnRcbSimKey7VacummClick(Sender: TObject);
var
  sDebug : string;
begin
  sDebug := '<VitrualKey> CH'+IntToStr(m_nJig+1)+': Key 7 Click';
  Common.MLog(m_nJig,sDebug);
  AppendChannelLog(sDebug);
  WorkStop(StopByOperator);
end;

procedure TfrmTest1Ch.btnRcbSimKey8StopClick(Sender: TObject);
var
  sDebug : string;
begin
  sDebug := '<VitrualKey> CH'+IntToStr(m_nJig+1)+': Key 8 Click';
  Common.MLog(m_nJig,sDebug);
  AppendChannelLog(sDebug);
  WorkStop(StopByOperator);
end;

procedure TfrmTest1Ch.btnRcbSimKey9StartNextClick(Sender: TObject);
var
  sDebug : string;
begin
  sDebug := '<VitrualKey> CH'+IntToStr(m_nJig+1)+': Key 9 Click';
  Common.MLog(m_nJig,sDebug);
  AppendChannelLog(sDebug);

  WorkStart;
end;

//******************************************************************************
// procedure/function: HandBCR
//******************************************************************************

procedure TfrmTest1Ch.SetBcrSet;
begin
  //Common.MLog(m_nJig,'<TestCh> CH'+IntToStr(m_nJig+1)+': SetBcrSet');
  DongaHandBcr.OnRevBcrData := GetBcrData;
end;

procedure TfrmTest1Ch.btnBcrKbdInputEnterClick(Sender: TObject);
var
  sData : string;
begin
  Common.MLog(m_nCh,'<BcrKbdInput> CH'+IntToStr(m_nCh+1)+': Enter');
//nCh := (Sender as TRzBitBtn).Tag;
  if Trim(edBcrKbdInputNum.Text) = '' then Exit;
  sData := edBcrKbdInputNum.Text;
  GetBcrData(sData);
end;

procedure TfrmTest1Ch.btnBcrKbdInputClearClick(Sender: TObject);
begin
  Common.MLog(m_nCh,'<BcrKbdInput> CH'+IntToStr(m_nCh+1)+': Clear');
//edBcrKbdInputNum[(Sender as TRzBitBtn).Tag].Text := '';
  edBcrKbdInputNum.Text := '';
end;

procedure TfrmTest1Ch.GetBcrData(sScanData: string);
begin
  Common.ThreadTask(procedure begin  //2023-09-26
    ThreadedGetBcrData(sScanData);
  end);
end;

procedure TfrmTest1Ch.ThreadedGetBcrData(sScanData: string); //2023-09-26 (GetBcrData -> ThreadedGetBcrData)
var
  nCh, nOtherCh : Integer;
  sDebug : string;
  sRemoveCr : string;
  sPidFromBcr : string;
  sList : TStringList;
  sScanPidChkStr : string;
  nSendPchk : Boolean;
  sFlowStep : string;
begin
  nCh := m_nJig;
  //Common.MLog(m_nJig,'<TestCh> CH'+IntToStr(nCh+1)+': GetBcrData');
  //
  if Logic[m_nJig].m_InsStatus = IsStop then begin  //2018-12-11
    sDebug := 'Press Start Key and Scan Barcode';
    TMLog(nCh,sDebug);
    Exit;
  end;
  //
  if Logic[nCh].m_Inspect.IsScanned then begin  //2018-12-11
    sDebug := 'Already BCR Scanned';
    TMLog(nCh,sDebug);
    Exit;
  end;

  if not Common.TestModelInfo2[nCh].UseScanFirst then begin
    if Logic[m_nJig].m_InsStatus <> IsLoading then begin  //2018-12-11
      sDebug := 'Scan Barcode again after Power-On completed';
      TMLog(nCh,sDebug);
      Exit;
    end;
  end;
  //
  sRemoveCr := sScanData.Trim([#$0A{CR},' ',#$0D{LF}]);
  sDebug := '[BCR#] ' + sRemoveCr;
  AppendChannelLog(sDebug);
  TMLog(nCh,sDebug);

  if Common.TestModelInfo2[nCh].Bcrlength > 0 then begin
    if sRemoveCr.Length <> Common.TestModelInfo2[nCh].BcrLength then begin
      sDebug := sDebug + ' (Length Mismatch)';
      DisplayChStatus(CH_STATUS_NG,'BCR Length NG');
      AppendChannelLog(sDebug, DefPocb.LOG_TYPE_NG);
      TMLog(nCh,sDebug);
      Exit;
    end;
  end;

  if (Common.TestModelInfo2[nCh].BcrPidChkIdx > 0) and (Length(Common.TestModelInfo2[nCh].BcrPidChkStr) > 0) then begin
    if sRemoveCr.Length < (Common.TestModelInfo2[nCh].BcrPidChkIdx + Length(Common.TestModelInfo2[nCh].BcrPidChkStr) - 1) then begin
      sDebug := sDebug + ' (BCR# Check String Mismatch)';
      DisplayChStatus(CH_STATUS_NG,'BCR Check NG');
      AppendChannelLog(sDebug, DefPocb.LOG_TYPE_NG);
      TMLog(nCh,sDebug);
      Exit;
    end;
    sScanPidChkStr := Copy(sRemoveCr, Common.TestModelInfo2[nCh].BcrPidChkIdx, Length(Common.TestModelInfo2[nCh].BcrPidChkStr));
    if sScanPidChkStr <> Common.TestModelInfo2[nCh].BcrPidChkStr then begin
      sDebug := sDebug + ' (BCR# Check String Mismatch)';
      DisplayChStatus(CH_STATUS_NG,'BCR Check NG');
      AppendChannelLog(sDebug, DefPocb.LOG_TYPE_NG);
      TMLog(nCh,sDebug);
      Exit;
    end;
  end;

  //2022-08-29 Check Duplicated BCR#
  nOtherCh := TernaryOp((nCh = DefPocb.CH_1), DefPocb.CH_2, DefPocb.CH_1);
  if (Logic[nOtherCh].m_InsStatus <> IsStop) and (Length(Logic[nOtherCh].m_Inspect.SerialNo) > 0) and (Logic[nOtherCh].m_Inspect.SerialNo = sRemoveCr) then begin
    sDebug := sDebug + ' (Duplicated BCR#)';
    DisplayChStatus(CH_STATUS_NG,'Duplicated BCR# NG');
    AppendChannelLog(sDebug, DefPocb.LOG_TYPE_NG);
    TMLog(nCh,sDebug);
    Exit;
  end;

  //
  if Logic[nCh].m_InsStatus = IsLoading then begin

    pnlSerialNo.Caption    := Trim(sRemoveCr);
    Logic[nCh].m_Inspect.SerialNo  := Trim(sRemoveCr);
    Logic[nCh].m_Inspect.PanelID   := Trim(sRemoveCr); //2021-12-23
    Logic[nCh].m_Inspect.IsScanned := True;


    //--------------------------------- SPCB_ID_INTERLOCK // 2023-05-19 A2CHv4
  {$IFDEF FEATURE_BCR_SCAN_SPCB}
    if (not Common.TestModelInfo2[nCh].UseScanFirst) and (Common.TestModelInfo2[nCh].BcrScanMesSPCB and Common.TestModelInfo2[nCh].BcrSPCBIdInterlock) then begin
      sDebug := 'SPCB-ID EEPROM Data Check';
      AppendChannelLog(sDebug+' ------');
      TMLog(nCh,sDebug);
      //
      if not Logic[nCh].CheckEepromSPCBIdInterlock then begin
        ShowFlowSeq(DefPocb.POCB_SEQ_SCAN_BCR,DefPocb.SEQ_RESULT_FAIL);
        sDebug := sDebug + ' NG';
        DisplayChStatus(CH_STATUS_NG,sDebug);
        AppendChannelLog(sDebug, DefPocb.LOG_TYPE_NG);
        TMLog(nCh,sDebug);
        Exit;
      end;
      sDebug := sDebug + ' OK';
      AppendChannelLog(sDebug);
      TMLog(nCh,sDebug);
    end;
  {$ENDIF} //FEATURE_BCR_SCAN_SPCB

    //--------------------------------- BCR_PID_INTERLOCK //2023-09-24 VH#301
  {$IFDEF FEATURE_BCR_PID_INTERLOCK}
    if (not Common.TestModelInfo2[nCh].UseScanFirst) and ((not Common.TestModelInfo2[nCh].BcrScanMesSPCB) and Common.TestModelInfo2[nCh].BcrPIDInterlock) then begin
      sDebug := 'PID EEPROM Data Check';
      AppendChannelLog(sDebug+' ------');
      TMLog(nCh,sDebug);
      //
      if not Logic[nCh].CheckEepromPIDInterlock then begin
        ShowFlowSeq(DefPocb.POCB_SEQ_SCAN_BCR,DefPocb.SEQ_RESULT_FAIL);
        sDebug := sDebug + ' NG';
        DisplayChStatus(CH_STATUS_NG,sDebug);
        AppendChannelLog(sDebug, DefPocb.LOG_TYPE_NG);
        TMLog(nCh,sDebug);
        Exit;
      end;
      sDebug := sDebug + ' OK';
      AppendChannelLog(sDebug);
      TMLog(nCh,sDebug);
    end;
  {$ENDIF} //FEATURE_BCR_PID_INTERLOCK

    ShowFlowSeq(DefPocb.POCB_SEQ_SCAN_BCR,DefPocb.SEQ_RESULT_PASS); //2019-05-20 GUI:FlowSeq

    nSendPchk := False;
		if (DongaGmes <> nil) and Common.m_bMesOnline and (not Common.SystemInfo.UseGRR) then begin
      if not Common.SystemInfo.UseGIB then begin
        {$IFDEF SITE_LENSVN}
        DisplayChStatus(CH_STATUS_INFO,'SEND MES:START');
        {$ELSE}
        DisplayChStatus(CH_STATUS_INFO,'SEND PCHK');
        {$ENDIF}
  			Logic[nCh].SendGmesMsg(DefGmes.MES_PCHK);
        nSendPchk := True;
      end
      else begin
        {$IFDEF SUPPORT_1CG2PANEL}
        if (not Common.SystemInfo.UseAssyPOCB) then begin
        {$ENDIF}
          {$IFDEF SITE_LENSVN}
          DisplayChStatus(CH_STATUS_INFO,'SEND MES:GIB:START');
          {$ELSE}
          DisplayChStatus(CH_STATUS_INFO,'SEND INS_PCHK');
          {$ENDIF}
          nSendPchk := True;
  			  Logic[nCh].SendGmesMsg(DefGmes.MES_INS_PCHK);
        {$IFDEF SUPPORT_1CG2PANEL}
        end
        else begin
          if ((nCh = DefPocb.CH_1) and (Common.TestModelInfo2[nCh].AssyModelInfo.UseMainPidCh1)) or
             ((nCh = DefPocb.CH_2) and (Common.TestModelInfo2[nCh].AssyModelInfo.UseMainPidCh2)) then begin
            DisplayChStatus(CH_STATUS_INFO,'SEND INS_PCHK');
  			    Logic[nCh].SendGmesMsg(DefGmes.MES_INS_PCHK);
            nSendPchk := True;
          end
          else begin
            DisplayChStatus(CH_STATUS_INFO,'SKIP INS_PCHK');
          end;
        end;
        {$ENDIF} //SUPPORT_1CG2PANEL
      end;
    end;
//{$IFNDEF SITE_LENSVN}
    if (nSendPchk) then Exit;
//{$ENDIF}

    try
      sList := TStringList.Create;
      try
        ExtractStrings(['-'],[],PWideChar(Logic[nCh].m_Inspect.SerialNo),sList);
        sPidFromBcr := Trim(sList[0]);
        Logic[nCh].m_Inspect.SerialNo     := sPidFromBcr;  //2022-11-18
        Logic[nCh].m_Inspect.PanelID      := sPidFromBcr;  //2021-12-23
        Common.MesData[nCh].PchkRtnPid    := sPidFromBcr;
        Common.MesData[nCh].bRxPchkRtnPid := False;
      finally
        sList.Free;
      end;
    except
    end;
    //
    if not Common.TestModelInfo2[nCh].UseScanFirst then begin
      ShowFlowSeq(DefPocb.POCB_SEQ_PRESS_START,DefPocb.SEQ_RESULT_WORKING); //2019-05-20 GUI:FlowSeq
      if Common.CheckSerialMatch(Trim(sRemoveCr)) then
        DisplayChStatus(CH_STATUS_ALREADY,'Ready To Turn (Already Inspect)')
      else
        DisplayChStatus(CH_STATUS_INFO,'Ready To Turn');

      if m_nJig = DefPocb.JIG_A then DongaDio.IsReadyToTurn1 := True
      else                           DongaDio.IsReadyToTurn2 := True;
    end else begin
      if Common.CheckSerialMatch(Trim(sRemoveCr)) then
        DisplayChStatus(CH_STATUS_ALREADY,'Already Inspect');
    end;
  end;
end;

//******************************************************************************
// procedure/function: GMES
//******************************************************************************

//******************************************************************************
// procedure/function: Motion
//******************************************************************************
{
  ALARM_CH1_MOTION_Y_DISCONNECTED				= 28;
  ALARM_CH1_MOTION_Y_SIG_INPOSITION_OFF	= 29;
  ALARM_CH1_MOTION_Y_SIG_ALARM_ON				= 30;
  ALARM_CH1_MOTION_Y_SIG_SERVO_OFF			= 31;
  ALARM_CH1_MOTION_Y_INVALID_UNITPULSE	= 32;
  ALARM_CH1_MOTION_Y_OUT_OF_MODEL_POS		= 33;
}
procedure TfrmTest1Ch.ShowMotionStatus(nCh: Integer; nAxisType: Integer);
var
  nMotionID     : Integer;
  MotionStatus  : MotionStatusRec;
  MotionAlarmNo : TMotionAlarmNo;
begin
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxisType,nMotionID)) then begin
		Exit;
	end;
  //
  Common.GetMotionAlarmNo(nMotionID,MotionAlarmNo);
  MotionStatus := DongaMotion.Motion[nMotionID].m_MotionStatus;
  with DongaMotion.Motion[nMotionID].m_MotionStatus do begin
    case nAxisType of
      //----------------------------------------------------------------- MOTION_AXIS_Y
      DefMotion.MOTION_AXIS_Y: begin
        //------------------ 2018-11-30
        { case nCh of
          DefPocb.CH_1: if not DongaDio.IsReadyToTurn1 then m_bServoRecover := False;
          DefPocb.CH_2: if not DongaDio.IsReadyToTurn2 then m_bServoRecover := False;
        end; }
        //------------------ from MechSignal
        // +Limit Signal
        if (MechSignal and (1 shl 0)) <> 0 then ledMotionYaxisLimitPlus.Value := True
        else                                    ledMotionYaxisLimitPlus.Value := False;
{$IFDEF POCB_A2CH}
        // InPosition Signal
//      if (MechSignal and (1 shl 5)) <> 0 then ledMotionYaxisInPos.Value := True  //0:OutOfPosition, 1:InPosition
//      else                                    ledMotionYaxisInPos.Value := False;
{$ENDIF}
        // -Limit Signal
        if (MechSignal and (1 shl 1)) <> 0 then ledMotionYaxisLimitMinus.Value := True
        else                                    ledMotionYaxisLimitMinus.Value := False;
        // Alarm Signal
        if (MechSignal and (1 shl 4)) <> 0 then begin
          ledMotionYaxisAlarmOn.Value := True;
          if not Common.AlarmList[MotionAlarmNo.SIG_ALARM_ON].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCh,MotionAlarmNo.SIG_ALARM_ON,1);  //Alarm On
          //if Common.MotionInfo.ServoAlarmHomeSearch then begin  //2018-12-07 TBD?
          //  DongaMotion.Motion[nMotionID].m_bInitDone := False; //2022-11-17
          //  DongaMotion.Motion[nMotionID].m_bServoOn  := False; //2022-11-17
              DongaMotion.Motion[nMotionID].m_bHomeDone := False; //2018-12-07
              DongaMotion.Motion[nMotionID].m_bModelPos := False; //2018-12-07
          //end;
            if (Logic[nCh] <> nil) and (Logic[nCh].m_InsStatus = IsCamera) then begin  //2019-01-16
              WorkStop(StopByAlarm); //2018-12-10 (OTION:FLOW: SERVO ALARM발생시, 진행중 FLOW 종료처리. 이후 HomeSearch~)
            end;
          end;
        end
        else begin
          ledMotionYaxisAlarmOn.Value := False;
          if Common.AlarmList[MotionAlarmNo.SIG_ALARM_ON].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCh,MotionAlarmNo.SIG_ALARM_ON,0);  //Alarm Off
          end;
        end;
        //----------------------- from 범용 입출력
        // Home Sensor
        if (UnivInSignal and (1 shl 0)) <> 0 then ledMotionYaxisOnHome.Value := True
        else                                      ledMotionYaxisOnHome.Value := False;
        // Servo On (IN)
        //TBD:MOTION:ALARM:ServoOn(IN)? (동작중 ON/OFF 반복됨) //0:ServoOff, 1:ServoOn
        if (UnivInSignal and (1 shl 2)) <> 0 then ledMotionYaxisServoOnIn.Value := True
        else                                      ledMotionYaxisServoOnIn.Value := False;
{$IFDEF POCB_A2CH}
        //A2CH: Stage Backward: Work Position = Home
        if (UnivInSignal and (1 shl 0)) <> 0 then ledMotionYaxisOnHome.Value := True
        else                                      ledMotionYaxisOnHome.Value := False;
{$ELSE}
        //F2CH|A2CHv2: Stage Backward: Work Position (IN)
        if (UnivInSignal and (1 shl 3)) <> 0 then ledMotionYaxisOnLoadPos.Value := True
        else                                      ledMotionYaxisOnLoadPos.Value := False;
{$ENDIF}
        // Servo On (OUT)
        if (UnivOutSignal and (1 shl 0)) <> 0 then ledMotionYaxisServoOnOut.Value := True
        else                                       ledMotionYaxisServoOnOut.Value := False;
        //------------------- Motion Control Parameters
        // Unit/Pulse
        pnlMotionYaxisUnitPulse.Caption := FloatToStr(UnitPerPulse);
        if UnitPerPulse <> Common.MotionInfo.YaxisUnitPerPulse then begin
          pnlMotionYaxisUnitPulse.Color       := clRed;
          pnlMotionYaxisUnitPulse.Font.Color  := clYellow;
          if not Common.AlarmList[MotionAlarmNo.INVALID_UNITPULSE].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCh,MotionAlarmNo.INVALID_UNITPULSE,1); //Alarm On
          end;
        end
        else begin
          pnlMotionYaxisUnitPulse.Color       := clBtnFace;
          pnlMotionYaxisUnitPulse.Font.Color  := clBlack;
          if Common.AlarmList[MotionAlarmNo.INVALID_UNITPULSE].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCh,MotionAlarmNo.INVALID_UNITPULSE,0); //Alarm Off
          end;
        end;
        //------------------- Model Position
        pnlMotionYaxisCmdPos.Caption := Format('%0.2f',[CommandPos]);
        if Abs(CommandPos - Common.TestModelInfo2[nCh].CamYCamPos) <= 1 then begin //TBD 2018-12-11
          ledMotionYaxisOnLoadPos.Value    := False;
          ledMotionYaxisOnCamPos.Value     := True;
          pnlMotionYaxisCmdPos.Color       := clBtnFace;
          pnlMotionYaxisCmdPos.Font.Color  := clBlack;
          if DongaMotion.Motion[nMotionID].m_bHomeDone and (not IsInMotion) and Common.AlarmList[MotionAlarmNo.MODEL_POS_NG].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCh,MotionAlarmNo.MODEL_POS_NG,0); //Alarm Off
          end;
        end
        else if Abs(CommandPos - Common.TestModelInfo2[nCh].CamYLoadPos) <= 1 then begin  //TBD 2018-12-11
          ledMotionYaxisOnLoadPos.Value    := True;
          ledMotionYaxisOnCamPos.Value     := False;
          pnlMotionYaxisCmdPos.Color       := clBtnFace;
          pnlMotionYaxisCmdPos.Font.Color  := clBlack;
          if DongaMotion.Motion[nMotionID].m_bHomeDone and (not IsInMotion) and Common.AlarmList[MotionAlarmNo.MODEL_POS_NG].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCh,MotionAlarmNo.MODEL_POS_NG,0); //Alarm Off
          end;
        end
        else begin
          ledMotionYaxisOnCamPos.Value   := False;
          ledMotionYaxisOnLoadPos.Value  := False;
          if IsInMotion then begin
            pnlMotionYaxisCmdPos.Color       := clYellow;
            pnlMotionYaxisCmdPos.Font.Color  := clBlack;
          end
          else begin
            pnlMotionYaxisCmdPos.Color       := clRed;
            pnlMotionYaxisCmdPos.Font.Color  := clYellow;
          end;
          if (not IsInMotion) and IsMotionDone and (not Common.AlarmList[MotionAlarmNo.MODEL_POS_NG].bIsOn) then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCh,MotionAlarmNo.MODEL_POS_NG,1); //Alarm On
          end;
        end;
        {$IFDEF SUPPORT_1CG2PANEL}
        //------------------- SyncMode (Y-Asix : CH1/CH2 Sync-move if 1CGnPN ASSY-POCB) //A2CHv3:MOTION:SYNC-MOVE
        case nSyncStatus of
          DefMotion.SyncNone: begin
            ledMotionYaxisOnSync.FalseColor := clBtnFace;
            ledMotionYaxisOnSync.Value := False;
          end;
          DefMotion.SyncLinkMaster, DefMotion.SyncLinkSlave, SyncGantryMaster, SyncGantrySlave: begin
            ledMotionYaxisOnSync.TrueColor := clLime;
            ledMotionYaxisOnSync.Value := True;
          end;
          else begin  // DefMotion.SyncUnknown,...
            ledMotionYaxisOnSync.FalseColor := clGray;
            ledMotionYaxisOnSync.Value := False;
          end;
        end;
        {$ENDIF}
      end;
      //----------------------------------------------------------------- MOTION_AXIS_Z
      {$IFDEF HAS_MOTION_CAM_Z}			
      DefMotion.MOTION_AXIS_Z: begin
        //------------------ from MechSignal
        // +Limit Signal
        if (MechSignal and (1 shl 0)) <> 0 then ledMotionZaxisLimitPlus.Value := True
        else                                    ledMotionZaxisLimitPlus.Value := False;
        // InPosition Signal
        if (MechSignal and (1 shl 5)) <> 0 then ledMotionZaxisInPos.Value := True  //0:OutOfPosition, 1:InPosition
        else                                    ledMotionZaxisInPos.Value := False;
        // -Limit Signal
        if (MechSignal and (1 shl 1)) <> 0 then ledMotionZaxisLimitMinus.Value := True
        else                                    ledMotionZaxisLimitMinus.Value := False;
        // Alarm Signal
        if (MechSignal and (1 shl 4)) <> 0 then begin
          ledMotionZaxisAlarmOn.Value := True;
          if not Common.AlarmList[MotionAlarmNo.SIG_ALARM_ON].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,MotionAlarmNo.SIG_ALARM_ON,1); //Alarm On
          //if Common.MotionInfo.ServoAlarmHomeSearch then begin  //2018-12-07 TBD?
          //  DongaMotion.Motion[nMotionID].m_bInitDone := False; //2022-11-17
          //  DongaMotion.Motion[nMotionID].m_bServoOn  := False; //2022-11-17
              DongaMotion.Motion[nMotionID].m_bHomeDone := False; //2018-12-07
              DongaMotion.Motion[nMotionID].m_bModelPos := False; //2018-12-07
          //end;
          end;
        end
        else begin
          ledMotionZaxisAlarmOn.Value := False;
          if Common.AlarmList[MotionAlarmNo.SIG_ALARM_ON].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,MotionAlarmNo.SIG_ALARM_ON,0); //Alarm Off
          end;
        end;
        //----------------------- from 범용 입출력
        // Home Sensor
        if (UnivInSignal and (1 shl 0)) <> 0 then ledMotionZaxisOnHome.Value := True
        else                                      ledMotionZaxisOnHome.Value := False;
        // Servo On (IN)
        if (UnivInSignal and (1 shl 2)) <> 0 then ledMotionZaxisServoOnIn.Value := True  //0:ServoOff, 1:ServoOn
        else                                      ledMotionZaxisServoOnIn.Value := False;
        // Servo On (OUT)
        if (UnivOutSignal and (1 shl 0)) <> 0 then ledMotionZaxisServoOnOut.Value := True
        else                                       ledMotionZaxisServoOnOut.Value := False;
        //------------------- Motion Control Parameters
        // Unit/Pulse
        pnlMotionZaxisUnitPulse.Caption := FloatToStr(UnitPerPulse);
        if UnitPerPulse <> Common.MotionInfo.ZaxisUnitPerPulse then begin
          pnlMotionZaxisUnitPulse.Color       := clRed;
          pnlMotionZaxisUnitPulse.Font.Color  := clYellow;
          if not Common.AlarmList[MotionAlarmNo.INVALID_UNITPULSE].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,MotionAlarmNo.INVALID_UNITPULSE,1);  //Alarm On
          end;
        end
        else begin
          pnlMotionZaxisUnitPulse.Color       := clBtnFace;
          pnlMotionZaxisUnitPulse.Font.Color  := clBlack;
          if Common.AlarmList[MotionAlarmNo.INVALID_UNITPULSE].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,MotionAlarmNo.INVALID_UNITPULSE,0);  //Alarm Off
          end;
        end;
        //------------------- Model Position
        pnlMotionZaxisCmdPos.Caption := Format('%0.2f',[CommandPos]);
        if DongaMotion.IsSameMotionPos(CommandPos, Common.TestModelInfo2.CamZModelPos[m_nJig]) then begin   //TBD:MOTION? (정확하게 or 허용오차?)
          ledMotionZaxisOnModelPos.Value   := True;
          pnlMotionZaxisCmdPos.Color       := clBtnFace;
          pnlMotionZaxisCmdPos.Font.Color  := clBlack;
          if DongaMotion.Motion[nMotionID].m_bHomeDone and (not IsInMotion) and Common.AlarmList[MotionAlarmNo.MODEL_POS_NG].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,MotionAlarmNo.MODEL_POS_NG,0); //Alarm Off
          end;
        end
        else if DongaMotion.IsSameMotionPos(CommandPos, 0) then begin
          ledMotionZaxisOnModelPos.Value   := False;
          pnlMotionZaxisCmdPos.Color       := clBtnFace;
          pnlMotionZaxisCmdPos.Font.Color  := clBlack;
          if DongaMotion.Motion[nMotionID].m_bHomeDone and (not IsInMotion) and Common.AlarmList[MotionAlarmNo.MODEL_POS_NG].bIsOn then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,MotionAlarmNo.MODEL_POS_NG,0); //Alarm Off
          end;
        end
        else begin
          ledMotionZaxisOnModelPos.Value   := False;
          if IsInMotion then begin
            pnlMotionZaxisCmdPos.Color       := clYellow;
            pnlMotionZaxisCmdPos.Font.Color  := clBlack;
          end
          else begin
            pnlMotionZaxisCmdPos.Color       := clRed;
            pnlMotionZaxisCmdPos.Font.Color  := clYellow;
          end;
          if (not IsInMotion) and (not Common.AlarmList[MotionAlarmNo.MODEL_POS_NG].bIsOn) then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,MotionAlarmNo.MODEL_POS_NG,1);  //Alarm On
          end;
        end;
        //------------------- SyncMode (Z-Asix: N/A)
      end;
      {$ENDIF} //HAS_MOTION_CAM_Z}
    end;
  end;
end;

//******************************************************************************
// procedure/function: Robot
//******************************************************************************

procedure TfrmTest1Ch.ShowRobotStatusCoord;  //A2CHv3:ROBOT
var
  nCh, nRobot  : Integer;
  nTempAlarmNo : Integer;
  RobotAlarmNo : TRobotAlarmNo;
  StatusCoord  : TRobotStatusCoord;
  sTemp        : string;
begin
  nCh    := m_nJig;
	nRobot := m_nJig;
  //
  if not DongaRobot.m_bConnectedModbus[nRobot] then begin
    if pnlRobotLightValue.Caption <> '---' then begin
      //
      ledRobotAutoMode.Value     := False;
      ledRobotManualMode.Value   := False;
      ledRobotFatalError.Value   := False;
      ledRobotProjRunning.FalseColor := clBtnFace; ledRobotProjRunning.Value  := False;
      ledRobotProjEditing.Value  := False;
      ledRobotProjPause.Value    := False;
      ledRobotGetControl.Value   := False;
      ledRobotEStop.Value        := False;
      ledRobotCoordHome.Value    := False;
      ledRobotCoordModel.Value   := False;
      //
      pnlRobotSpeedValue.Caption := '---';
      pnlRobotLightValue.Caption := '---';
      pnlRobotCoordX.Caption     := '---';
      pnlRobotCoordY.Caption     := '---';
      pnlRobotCoordZ.Caption     := '---';
      pnlRobotCoordRx.Caption    := '---';
      pnlRobotCoordRy.Caption    := '---';
      pnlRobotCoordRz.Caption    := '---';
      //
      pnlRobotLightColor.Caption := '------';
      pnlRobotLightColor.Color   := clBtnFace;
    end;
    Exit; //!!!
  end
  else begin
    if pnlRobotLightValue.Caption = '---' then begin
      ledRobotProjRunning.FalseColor := clRed;
    end;
  end;

  //
  Common.GetRobotAlarmNo(nRobot,RobotAlarmNo);
  StatusCoord := DongaRobot.Robot[nRobot].m_RobotStatusCoord;
  with DongaRobot.Robot[nRobot].m_RobotStatusCoord do begin
    //----------------------------------------------------------------- Robot Status
    // Robot Status - AutoMode/manualMode
    case RunMode of
      DefRobot.ROBOT_TM_MB_RUNMODE_AUTO:   begin ledRobotAutoMode.Value := True;  ledRobotManualMode.Value := False; end;
      DefRobot.ROBOT_TM_MB_RUNMODE_MANUAL: begin ledRobotAutoMode.Value := False; ledRobotManualMode.Value := True;  end;
      else                                 begin ledRobotAutoMode.Value := False; ledRobotManualMode.Value := False; end;
    end;
    // Robot Status - FatalError
    nTempAlarmNo := RobotAlarmNo.FATAL_ERROR;
    if RobotStatus.FatalError then begin
      ledRobotFatalError.Value := True;
      if not Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,1); //Alarm On
      end;
    end
    else begin
      ledRobotFatalError.Value := False;
      if Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,0); //Alarm Off
      end;
    end;
    // Robot Status - ProjectRunning
    nTempAlarmNo := RobotAlarmNo.PROJECT_NOT_RUNNING;
    if RobotStatus.ProjectRunning then begin
      ledRobotProjRunning.Value := True;
      if Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,0); //Alarm Off
      end;
    end
    else begin
      ledRobotProjRunning.Value := False;
      if not Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,1); //Alarm On
      end;
    end;
    // Robot Status - ProjectEditing
    nTempAlarmNo := RobotAlarmNo.PROJECT_EDITING;
    if RobotStatus.ProjectEditing then begin
      ledRobotProjEditing.Value := True;
      if not Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,1); //Alarm On
      end;
    end
    else begin
      ledRobotProjEditing.Value := False;
      if Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,0); //Alarm Off
      end;
    end;
    // Robot Status - ProjectPause
    nTempAlarmNo := RobotAlarmNo.PROJECT_PAUSE;
    if RobotStatus.ProjectPause then begin
      ledRobotProjPause.Value := True;
      if not Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,1); //Alarm On
      end;
    end
    else begin
      ledRobotProjPause.Value := False;
      if Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,0); //Alarm Off
      end;
    end;
    // Robot Status - GetControl
    nTempAlarmNo := RobotAlarmNo.GET_NOT_CONTROL;
    if RobotStatus.GetControl then begin
      ledRobotGetControl.Value := True;
      if not Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,1); //Alarm On
      end;
    end
    else begin
      ledRobotGetControl.Value := False;
      if Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,0); //Alarm Off
      end;
    end;
    // Robot Status - EStop
    nTempAlarmNo := RobotAlarmNo.ESTOP;
    if RobotStatus.EStop then begin
      ledRobotEStop.Value := True;
      if not Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,1); //Alarm On
      end;
    end
    else begin
      ledRobotEStop.Value := False;
      if Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,0); //Alarm Off
      end;
    end;
    // Robot Coord Status - Home/Model
    nTempAlarmNo := RobotAlarmNo.CURR_COORD_NG;
    case CoordState of
      coordHome: begin
        ledRobotCoordHome.Value  := True;
        ledRobotCoordModel.FalseColor := clBtnFace;
        ledRobotCoordModel.Value := False;
        if Common.AlarmList[nTempAlarmNo].bIsOn then begin
          SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,0); //Alarm Off
        end;
      end;
      coordModel: begin
        ledRobotCoordHome.FalseColor := clBtnFace;
        ledRobotCoordHome.Value  := False;
        ledRobotCoordModel.Value := True;
        if Common.AlarmList[nTempAlarmNo].bIsOn then begin
          SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,0); //Alarm Off
        end;
      end;
      else begin
        ledRobotCoordHome.Value  := False;
        ledRobotCoordModel.Value := False;
        //Alarm: When Inspect Start //TBD:A2CHv3:ROBOT? (COORD_NG?)
      end;
    end;
    // Robot Extra - CannotMove
    nTempAlarmNo := RobotAlarmNo.CANNOT_MOVE;
    if RobotExtra.CannotMove then begin
      if not Common.AlarmList[nTempAlarmNo].bIsOn then begin
        ledRobotCoordHome.FalseColor  := clRed;
        ledRobotCoordHome.Value       := False;
        ledRobotCoordModel.FalseColor := clRed;
        ledRobotCoordModel.Value      := False;
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,1); //Alarm On
      end;
    end
    else begin
      if Common.AlarmList[nTempAlarmNo].bIsOn then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,m_nJig,nTempAlarmNo,0); //Alarm Off
      end;
    end;
    //----------------------------------------------------------------- Robot Speed
    pnlRobotSpeedValue.Caption := IntToStr(RunSpeed); //TBD:A2CHv3:ROBOT? 
    //----------------------------------------------------------------- Robot Light
    if pnlRobotLightValue.Caption <> IntToStr(RobotLight) then begin
      pnlRobotLightValue.Caption := IntToStr(RobotLight);
      case RobotLight of
        ROBOT_TM_LIGHT_00_Off_EStop:                             sTemp := '00_EStop';
        ROBOT_TM_LIGHT_01_SolidRed_FatalError:                   sTemp := '01_FatalError';
        ROBOT_TM_LIGHT_02_FlashingRed_Initializing:              sTemp := '02_Initializing';
        ROBOT_TM_LIGHT_03_SolidBlue_StandbyInAutoMode:           sTemp := '03_StandbyInAutoMode';
        ROBOT_TM_LIGHT_04_FlashingBlue_AutoMode:                 sTemp := '04_AutoMode';
        ROBOT_TM_LIGHT_05_SloidGreen_StandbyInManualMode:        sTemp := '05_StandbyInManualMode';
        ROBOT_TM_LIGHT_06_FlashingGreen_ManualMode:              sTemp := '06_ManualMode';
        ROBOT_TM_LIGHT_09_AlterBlueRed_AutoModeError:            sTemp := '09_AutoModeError';
        ROBOT_TM_LIGHT_10_AlterGreenRed_ManualModeError:         sTemp := '10_ManualModeError';
        ROBOT_TM_LIGHT_13_AlterPurpleGreen_HmiInManualMode:      sTemp := '13_HmiInManualMode';
        ROBOT_TM_LIGHT_14_AlterPurpleBlue_HmiInAutoMode:         sTemp := '14_HmiInAutoMode';
        ROBOT_TM_LIGHT_18_AlterWhiteBlue_ReducedSpaceInAutoMode: sTemp := '18_ReducedSpaceInAutoMode';
        ROBOT_TM_LIGHT_19_FlashingLightBlue_SafeStartupMode:     sTemp := '19_SafeStartupMode';
        else sTemp := pnlRobotLightValue.Caption;
      end;
      pnlRobotLightColor.Caption := sTemp;
    end;
    //----------------------------------------------------------------- Robot Coordinate - X/Y/Z/Rx/Ry/Rz
    pnlRobotCoordX.Caption  := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.X);
    pnlRobotCoordY.Caption  := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Y);
    pnlRobotCoordZ.Caption  := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Z);
    pnlRobotCoordRx.Caption := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Rx);
    pnlRobotCoordRy.Caption := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Ry);
    pnlRobotCoordRz.Caption := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Rz);
    //----------------------------------------------------------------- Robot Coordinate - X
  //pnlRobotCoordX.Font.Color := clBlack;
    if   (Abs(Common.TestModelInfo2[nCh].RobotModelInfo.Coord.X - RobotCoord.X) <= Common.RobotSysInfo.RobotCoordTolerance)
      or (Abs(Common.RobotSysInfo.HomeCoord[nCh].X - RobotCoord.X) <= Common.RobotSysInfo.RobotCoordTolerance)
    then pnlRobotCoordX.Color := clBtnFace
    else pnlRobotCoordX.Color := clYellow;
    //----------------------------------------------------------------- Robot Coordinate - Y
  //pnlRobotCoordY.Font.Color := clBlack;
    if   (Abs(Common.TestModelInfo2[nCh].RobotModelInfo.Coord.Y - RobotCoord.Y) <= Common.RobotSysInfo.RobotCoordTolerance)
      or (Abs(Common.RobotSysInfo.HomeCoord[nCh].Y - RobotCoord.Y) <= Common.RobotSysInfo.RobotCoordTolerance)
    then pnlRobotCoordY.Color := clBtnFace
    else pnlRobotCoordY.Color := clYellow;
    //----------------------------------------------------------------- Robot Coordinate - Z
  //pnlRobotCoordZ.Font.Color := clBlack;
    if   (Abs(Common.TestModelInfo2[nCh].RobotModelInfo.Coord.Z - RobotCoord.Z) <= Common.RobotSysInfo.RobotCoordTolerance)
      or (Abs(Common.RobotSysInfo.HomeCoord[nCh].Z - RobotCoord.Z) <= Common.RobotSysInfo.RobotCoordTolerance)
    then pnlRobotCoordZ.Color := clBtnFace
    else pnlRobotCoordZ.Color := clYellow;
    //----------------------------------------------------------------- Robot Coordinate - Rx
  //pnlRobotCoordRx.Font.Color := clBlack;
  //if   (Abs(Common.TestModelInfo2[nCh].RobotModelInfo.Coord.Rx - RobotCoord.Rx) <= Common.RobotSysInfo.RobotCoordTolerance)
  //  or (Abs(Common.RobotSysInfo.HomeCoord[nCh].Rx - RobotCoord.Rx) <= Common.RobotSysInfo.RobotCoordTolerance)
    if   (Common.GetRobotCoordDiffRxRyRz(Common.TestModelInfo2[nCh].RobotModelInfo.Coord.Rx, RobotCoord.Rx) <= Common.RobotSysInfo.RobotCoordTolerance)
      or (Common.GetRobotCoordDiffRxRyRz(Common.RobotSysInfo.HomeCoord[nCh].Rx, RobotCoord.Rx) <= Common.RobotSysInfo.RobotCoordTolerance)
    then pnlRobotCoordRx.Color := clBtnFace
    else pnlRobotCoordRx.Color := clYellow;
    //----------------------------------------------------------------- Robot Coordinate - Ry
  //pnlRobotCoordRy.Font.Color := clBlack;
  //if   (Abs(Common.TestModelInfo2[nCh].RobotModelInfo.Coord.Ry - RobotCoord.Ry) <= Common.RobotSysInfo.RobotCoordTolerance)
  //  or (Abs(Common.RobotSysInfo.HomeCoord[nCh].Ry - RobotCoord.Ry) <= Common.RobotSysInfo.RobotCoordTolerance)
    if   (Common.GetRobotCoordDiffRxRyRz(Common.TestModelInfo2[nCh].RobotModelInfo.Coord.Ry, RobotCoord.Ry) <= Common.RobotSysInfo.RobotCoordTolerance)
      or (Common.GetRobotCoordDiffRxRyRz(Common.RobotSysInfo.HomeCoord[nCh].Ry, RobotCoord.Ry) <= Common.RobotSysInfo.RobotCoordTolerance)
    then pnlRobotCoordRy.Color := clBtnFace
    else pnlRobotCoordRy.Color := clYellow;
    //----------------------------------------------------------------- Robot Coordinate - Rz
  //pnlRobotCoordRz.Font.Color := clBlack;
  //if   (Abs(Common.TestModelInfo2[nCh].RobotModelInfo.Coord.Rz - RobotCoord.Rz) <= Common.RobotSysInfo.RobotCoordTolerance)
  //  or (Abs(Common.RobotSysInfo.HomeCoord[nCh].Rz - RobotCoord.Rz) <= Common.RobotSysInfo.RobotCoordTolerance)
    if   (Common.GetRobotCoordDiffRxRyRz(Common.TestModelInfo2[nCh].RobotModelInfo.Coord.Rz, RobotCoord.Rz) <= Common.RobotSysInfo.RobotCoordTolerance)
      or (Common.GetRobotCoordDiffRxRyRz(Common.RobotSysInfo.HomeCoord[nCh].Rz, RobotCoord.Rz) <= Common.RobotSysInfo.RobotCoordTolerance)
    then pnlRobotCoordRz.Color := clBtnFace
    else pnlRobotCoordRz.Color := clYellow;
  end;
end;

//******************************************************************************
// procedure/function: Flow/SEQ???
//******************************************************************************

function TfrmTest1Ch.CheckScanInterlock: Boolean;
var
  nIdx : Integer;
begin
  for nIdx := 0 to DefPocb.JIG_MAX do begin
    if nIdx = m_nJig then Continue;

    if (Logic[nIdx].m_InsStatus = IsLoading) and
       (Logic[nIdx].m_Inspect.IsScanned = False) then
        Exit(True);
  end;

  Result := False;
end;

function TfrmTest1Ch.WorkStart : Boolean;
var
  nOutDioVacuum1, nOutDioVacuum2 : Integer;
  sMsg : string;
begin
  {$IFDEF SUPPORT_1CG2PANEL}
  //2021-08-24 (if AssyPOCB, Check DIO:AssyJigDetected and MOTION:MotionSyncOn)
  if Common.SystemInfo.UseAssyPOCB then begin
    if (not DongaMotion.m_bDioAssyJigOn) then begin
      DisplayChStatus(CH_STATUS_NG, 'ASSY-JIG Not Detected');
      sMsg := '<TestCh> WorkStart: ASSY-JIG Not Detected';
      Common.MLog(m_nJig,sMsg);
      Exit(False);
    end;
    if (DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_MotionStatus.nSyncStatus <> DefMotion.SyncLinkMaster) then begin
      DisplayChStatus(CH_STATUS_NG, 'CH1/CH2-Stage Not SyncMode');
      sMsg := '<TestCh> WorkStart: CH1/CH2 Stage Not SyncMode';
      Common.MLog(m_nJig,sMsg);
      Exit(False);
    end;
  end;
  {$ENDIF} //SUPPORT_1CG2PANEL

  if Common.TestModelInfo2[m_nJig].UseScanFirst then begin
    RzgrpScanBcrOtherChMsg.Visible := False; //2023-08-11 SCAN_BCR_OTHER_CH_MSG
    if Logic[m_nJig].m_InsStatus = IsLoading then begin
      if Logic[m_nJig].m_Inspect.IsScanned then begin
        if not DongaDio.CheckPinBlock(m_nJig, True) then begin
          TMLog(m_nJig,'Not Connected PinBlock');
          Exit(False);
        end;
        Logic[m_nJig].SendStartSeq1;
      end
      else begin
        TMLog(m_nJig,'Scan Barcode before Connect PinBlock');
        Exit(False);
      end;
      Exit(True);
    end;

    if CheckScanInterlock then begin
      TMLog(m_nJig,'Another Ch is Scanning...');
      Logic[m_nJig].m_bScanBcrOtherChMsgOn := True;
      RzgrpScanBcrOtherChMsg.Visible := True; //2023-08-11 SCAN_BCR_OTHER_CH_MSG
      Exit(False);
    end;
  end;

  if Logic[m_nJig].m_InsStatus <> IsStop then begin  //2018-12-11
    TMLog(m_nJig,'Already Started');
    Exit(False);
  end;

  Common.MLog(m_nJig,'<TestCh> WorkStart');

    ClearChData;
    {$IFDEF HAS_MOTION_CAM_Z}
    if Abs(Common.m_nCurPosZAxis[m_nJig] - Common.TestModelInfo2.CamZModelPos[m_nJig]) > 0.5 then begin   //TBD:MOTION? (정확하게 or 허용오차?)
      Common.MLog(m_nJig,'m_nCurPosZAxis('+FloatToStr(Common.m_nCurPosZAxis[m_nJig])+') Model.CamZ('+FloatToStr(Common.TestModelInfo2.CamZModelPos[m_nJig])+')');
      DisplayChStatus(CH_STATUS_NG, 'Z-Axis Set NG');
      if not Common.Systeminfo.DebugSelfTestPg then begin
        Exit(False);
      end;
    end;
    {$ENDIF} //HAS_MOTION_CAM_Z
    {$IFDEF HAS_ROBOT_CAM_Z}
    if (Abs(Common.TestModelInfo2[m_nJig].RobotModelInfo.Coord.X  - DongaRobot.Robot[m_nJig].m_RobotStatusCoord.RobotCoord.X) > Common.RobotSysInfo.RobotCoordTolerance) or
       (Abs(Common.TestModelInfo2[m_nJig].RobotModelInfo.Coord.Y  - DongaRobot.Robot[m_nJig].m_RobotStatusCoord.RobotCoord.Y) > Common.RobotSysInfo.RobotCoordTolerance) or
       (Abs(Common.TestModelInfo2[m_nJig].RobotModelInfo.Coord.Z  - DongaRobot.Robot[m_nJig].m_RobotStatusCoord.RobotCoord.Z) > Common.RobotSysInfo.RobotCoordTolerance) or
       (Common.GetRobotCoordDiffRxRyRz(Common.TestModelInfo2[m_nJig].RobotModelInfo.Coord.Rx, DongaRobot.Robot[m_nJig].m_RobotStatusCoord.RobotCoord.Rx) > Common.RobotSysInfo.RobotCoordTolerance) or
       (Common.GetRobotCoordDiffRxRyRz(Common.TestModelInfo2[m_nJig].RobotModelInfo.Coord.Ry, DongaRobot.Robot[m_nJig].m_RobotStatusCoord.RobotCoord.Ry) > Common.RobotSysInfo.RobotCoordTolerance) or
       (Common.GetRobotCoordDiffRxRyRz(Common.TestModelInfo2[m_nJig].RobotModelInfo.Coord.Rz, DongaRobot.Robot[m_nJig].m_RobotStatusCoord.RobotCoord.Rz) > Common.RobotSysInfo.RobotCoordTolerance) then begin
      DisplayChStatus(CH_STATUS_NG, 'ROBOT Coordination NG');
      sMsg := 'ROBOT Coordination NG (ModelInfo <> RobotCoord)';
      Common.MLog(m_nJig,sMsg);
      with Common.TestModelInfo2[m_nJig].RobotModelInfo do begin
        sMsg := '[ROBOT] Model X/Y/Z/Rx/Ry/Rz (' +FormatFloat(ROBOT_FORMAT_COORD,Coord.X)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,Coord.Y)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,Coord.Z)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,Coord.Rx)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,Coord.Ry)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,Coord.Rz)+')';
      end;
      Common.MLog(m_nJig,sMsg);
      with DongaRobot.Robot[m_nJig].m_RobotStatusCoord do begin
        sMsg := '[ROBOT] Current X/Y/Z/Rx/Ry/Rz (' +FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.X)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Y)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Z)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Rx)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Ry)
                     +'/'+FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Rz)+')';
      end;
      Common.MLog(m_nJig,sMsg);
      if not Common.Systeminfo.DebugSelfTestPg then begin
        Exit(False);
      end;
    end;
    {$ENDIF} //HAS_ROBOT_CAM_Z


  if Common.SystemInfo.HasDioVacuum and Common.TestModelInfo2[m_nJig].UseVacuum then begin  //2020-01-XX //2023-04-10 HasDioVacuum
    if (m_nJig = JIG_A) then begin
      nOutDioVacuum1 := DefDio.OUT_STAGE1_VACUUM1; nOutDioVacuum2 := DefDio.OUT_STAGE1_VACUUM2;
    end
    else begin
      nOutDioVacuum1 := DefDio.OUT_STAGE2_VACUUM1; nOutDioVacuum2 := DefDio.OUT_STAGE2_VACUUM2;
    end;
    if (not DongaDio.m_nSetDio[nOutDioVacuum1]) then DongaDio.SetDio(nOutDioVacuum1);
    if (not DongaDio.m_nSetDio[nOutDioVacuum2]) then DongaDio.SetDio(nOutDioVacuum2);
  end;

  Logic[m_nCh].m_bAutoPowerOff := cbAutoPowerOff.Checked; //2019-03-22
  Logic[m_nCh].StartSeqInit;

  SetBcrSet; //2018-11-28

  if Common.TestModelInfo2[m_nJig].UseScanFirst then Logic[m_nCh].SendScanSeq
  else                                               Logic[m_nCh].SendStartSeq1;
  Result := True;
end;

procedure TfrmTest1Ch.WorkStop(nStopReason: TInspctionStopReason = StopNormal);
var
  nOtherCh : Integer;
begin
{$IFDEF HAS_DIO_OUT_STAGE_LAMP}
  if Common.SystemInfo.HasDioOutStageLamp then DongaDio.SetStageLamp(m_nJig,True{LampON});
{$ENDIF}

  if nStopReason = stopByOperator then begin
    if DongaDio.m_nAutoFlow[m_nJig] in [IO_AUTO_FLOW_FRONT, IO_AUTO_FLOW_SHUTTER_DOWN, IO_AUTO_FLOW_SHUTTER_UP, IO_AUTO_FLOW_BACK] then begin //2023-06-14 TBD:GAGO:NEWFLOW?
      Common.MLog(m_nJig,'<TestCh> WorkStop ...On Stage|Shutter Moving');
      Exit;
    end;
  end;

  Common.MLog(m_nJig,'<TestCh> WorkStop');
  if m_nJig = DefPocb.JIG_A then begin  //2018-12-12
    if DongaDIo.m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_READY then DongaDio.IsReadyToTurn1 := False;
    if (DongaDIo.m_nDOValue and DefDio.MASK_OUT_STAGE1_READY_LED) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE1_READY_LED);
  end
  else begin
    if DongaDIo.m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_READY then DongaDio.IsReadyToTurn2 := False;
    if (DongaDIo.m_nDOValue and DefDio.MASK_OUT_STAGE2_READY_LED) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE2_READY_LED);
  end;

  Logic[m_nCh].SendStopSeq(nStopReason);

  pnlShowNgConfirm.Visible := False;
	{$IFDEF SUPPORT_1CG2PANEL}
  pnlShowSkipPocbConfirm.Visible := False;
	{$ENDIF}

  RzgrpScanBcrOtherChMsg.Visible := False; //2023-08-11 SCAN_BCR_OTHER_CH_MSG (Hidden OtherCh ScanBcrOtherChMsg)
  nOtherCh := TernaryOp((m_nCh=DefPocb.CH_1), DefPocb.CH_2, DefPocb.CH_1);
  //2023-08-11 SCAN_BCR_OTHER_CH_MSG (Hidden OtherCh ScanBcrOtherChMsg)
  nOtherCh := TernaryOp((m_nJig=DefPocb.CH_1), DefPocb.CH_2, DefPocb.CH_1);
  if Logic[nOtherCh].m_bScanBcrOtherChMsgOn then begin
    Logic[m_nCh].SendTestChGuiDisplay(nOtherCh, DefPocb.MSG_MODE_OTHERCH_SCANBCR_MSG, '', DefPocb.OTHERCH_SCANBCR_VISIBLE_OFF, 0);
  end;
end;

procedure TfrmTest1Ch.DisplayChStatus(status: Integer; sMsg : string = '');
begin
  pnlChStatus.Caption := sMsg;
  case status of
    CH_STATUS_OK      : begin
      pnlChStatus.Color      := clLime;
      pnlChStatus.Font.Color := clBlack;
    end;
    CH_STATUS_NG      : begin
      pnlChStatus.Color      := clRed;
      pnlChStatus.Font.Color := clBlack;
    end;
    CH_STATUS_INFO    : begin
      pnlChStatus.Color      := clNavy;
      pnlChStatus.Font.Color := clWhite;
    end;
    CH_STATUS_IDLE    : begin
      pnlChStatus.Color      := clBtnFace;
      pnlChStatus.Font.Color := clBlack;
    end;
    CH_STATUS_READY   : begin
      pnlChStatus.Color      := clBlack;
      pnlChStatus.Font.Color := clLime;
    end;
    CH_STATUS_ALREADY : begin
      pnlChStatus.Color      := clWebDarkViolet;
      pnlChStatus.Font.Color := clWhite;
    end;
		{$IFDEF SUPPORT_1CG2PANEL}
    CH_STATUS_SKIP : begin  //2022-06-XX SKIP_POCB
      pnlChStatus.Color      := clWebDarkViolet;
      pnlChStatus.Font.Color := clLime;
		end;
		{$ENDIF}
  end;
end;

procedure TfrmTest1Ch.DisplayPatPrevNext(bNext: Boolean);
var
  nCurRow : Integer;
begin
  if Logic[m_nCh].FLockThread then Exit;  //TBD:POCB_AUTO# AUTO->A2CH?
  //
  nCurRow := gridPatternList.Row;
  //15 17
  if bNext then begin
    Inc(nCurRow);
    // if not ( 17 16
    if not ((gridPatternList.RowCount) > nCurRow) then begin
      nCurRow := gridPatternList.RowCount - 1;
    end;
  end
  else begin
    Dec(nCurRow);
    if nCurRow < 0 then nCurRow := 0;
  end;
  gridPatternList.Row := nCurRow;
  //
  Logic[m_nCh].DisplayContactPat(nCurRow,gridPatternList.Cells[1, nCurRow]);
end;

//******************************************************************************
// procedure/function: ETC???
//******************************************************************************

procedure TfrmTest1Ch.SetConfig;
begin
  //Common.MLog(m_nJig,'<TestCh> CH'+IntToStr(m_nJig+1)+': SetConfig');
  // DongaSwitch
  if DongaSwitch <> nil then begin
    DongaSwitch.ChangePort(Common.SystemInfo.Com_RCB[m_nJig]);
  end;
  // CamComm -> Test1Ch
  CameraComm.m_hTest[Self.Tag]  := Self.Handle;
  // MotionCtl -> Test1Ch
  DongaMotion.m_hTest[Self.Tag] := Self.Handle;
  // DioCtl -> Test1Ch
  DongaDio.m_hTest[Self.Tag]    := Self.Handle;
  // RobotCtl -> Test1Ch
  DongaRobot.m_hTest[Self.Tag]  := Self.Handle;  //A2CHv3:ROBOT
end;

procedure TfrmTest1Ch.SetCRCValue(nCol: Integer; sValue: string);
begin
  gridCRCStatus.Cells[nCol,1] := sValue;
end;

procedure TfrmTest1Ch.ShowChTestNgMsg(nCh: Integer; sMessage: string);  //TBD:MERGE? USAGE?
begin
  GrpChTestNgMsg.Left := btnVirtualKey.Left + 100;
  GrpChTestNgMsg.Top  := btnVirtualKey.Top + btnVirtualKey.Height;
  //
  lblChTestNgHeader.Caption := 'CH'+IntToStr(nCh+1) + ' Test NG Message';
  lblChTestNgMsg.Caption := lblChTestNgMsg.Caption + #13 + #10 + sMessage;
  GrpChTestNgMsg.Visible := True;
end;

procedure TfrmTest1Ch.lblChTestNgCloseClick(Sender: TObject);
begin
  lblChTestNgMsg.Caption := '';
  GrpChTestNgMsg.Visible := False;
end;

procedure TfrmTest1Ch.lblScanBcrOtherChCloseClick(Sender: TObject); //2023-08-11
begin
  RzgrpScanBcrOtherChMsg.Visible := False;
end;

procedure TfrmTest1Ch.UpdatePtList(hMain: HWND);
var
  PatGrp : TPatternGroup;
begin
  Common.MLog(m_nJig,'<TestCh> CH'+IntToStr(m_nJig+1)+': UpdatePtList');
  PatGrp := DisplayPatList(Common.TestModelInfo[m_nJig].PatGrpName);
  Logic[m_nCh].PatGrp := PatGrp;
  CopyMemory(@Pg[Self.Tag].DisPatStruct.PatInfo,@DongaPat.InfoPat,SizeOf(DongaPat.InfoPat));
end;

procedure TfrmTest1Ch.ShowFlowSeq(nSeqNo, nSeqResult: Integer); //2019-05-20
var
  i, nOtherCh : Integer;
  nGridIdx : Integer;
begin
  if (nSeqResult <> DefPocb.SEQ_RESULT_CLEAR) and ((nSeqNo < 1) or (nSeqNo > DefPocb.POCB_SEQ_MAX)) then
    Exit;

  //2023-06-22 (Add RzpnlBcrKbdInput)
  //2023-08-11 (Add RzgrpScanBcrOtherChMsg)
  if (nSeqNo = DefPocb.POCB_SEQ_SCAN_BCR) and (nSeqResult = DefPocb.SEQ_RESULT_WORKING) then begin
    RzgrpScanBcrOtherChMsg.Visible := False; //2023-08-11 SCAN_BCR_OTHER_CH_MSG (Hidden MyCh ScanBcrOtherChMsg)
    RzpnlBcrKbdInput.Visible := True;
  end
  else begin
    RzpnlBcrKbdInput.Visible := False;
    RzgrpScanBcrOtherChMsg.Visible := False; //2023-08-11 SCAN_BCR_OTHER_CH_MSG (Hidden MyCh ScanBcrOtherChMsg)
    //2023-08-11 SCAN_BCR_OTHER_CH_MSG (Hidden OtherCh ScanBcrOtherChMsg)
    nOtherCh := TernaryOp((m_nJig=DefPocb.CH_1), DefPocb.CH_2, DefPocb.CH_1);
    if (Logic[m_nCh] <> nil) and (Logic[nOtherCh] <> nil) and  Logic[m_nCh].m_bScanBcrOtherChMsgOn then begin
      Logic[m_nCh].SendTestChGuiDisplay(nOtherCh, DefPocb.MSG_MODE_OTHERCH_SCANBCR_MSG, '', DefPocb.OTHERCH_SCANBCR_VISIBLE_OFF, 0);
    end;
  end;

  if nSeqResult = DefPocb.SEQ_RESULT_CLEAR then begin
    for nGridIdx := 1 to DefPocb.POCB_SEQ_MAX do begin
      gridFlowSeq.Colors[1,nGridIdx]     := clLtGray;
      gridFlowSeq.FontColors[1,nGridIdx] := clBlack;
    end;
    Exit;
  end;

{$IFDEF PANEL_ITOLED}
  // for Mainter Camera Command
  if (nSeqNo = DefPocb.POCB_SEQ_CAM_PROC_GAMMA) and Logic[m_nCh].IsMainter then begin
    for nGridIdx := DefPocb.POCB_SEQ_CAM_PROC_GAMMA to DefPocb.POCB_SEQ_CAM_DISP_AFTER_CB do begin
      gridFlowSeq.Colors[1,nGridIdx]     := clLtGray;
      gridFlowSeq.FontColors[1,nGridIdx] := clBlack;
    end;
  end;
{$ENDIF}

  try  // 2021-05-07 try !!!
    nGridIdx := GuiFlowSeqToGridIdx[nSeqNo];
    case nSeqResult of
      DefPocb.SEQ_RESULT_PASS: begin
        if nGridIdx <> 0 then begin
          gridFlowSeq.Colors[1,nGridIdx]     := clLime;
          gridFlowSeq.FontColors[1,nGridIdx] := clBlack;
        end;
      end;
      DefPocb.SEQ_RESULT_FAIL: begin
        if nGridIdx <> 0 then begin
          gridFlowSeq.Colors[1,nGridIdx]     := clRed;
          gridFlowSeq.FontColors[1,nGridIdx] := clYellow;
        end;
      end;
      DefPocb.SEQ_RESULT_WORKING: begin
        if nGridIdx <> 0 then begin
          gridFlowSeq.Colors[1,nGridIdx]     := clYellow;
          gridFlowSeq.FontColors[1,nGridIdx] := clBlack;
        end;
      end;
      else
        Exit;
    end;
  except

  end;

{$IFDEF SIMULATOR}
  if nSeqResult <> SEQ_RESULT_CLEAR then SimFlowThreadTask(nSeqNo,nSeqResult);
{$ENDIF}
end;

{$IFDEF SIMULATOR}
procedure TfrmTest1Ch.SimFlowThreadTask(nSeqNo: Integer; nSeqResult: Integer);
begin
    if nSeqNo = DefPocb.POCB_SEQ_INIT_POWER_ON then begin
      if  Common.TestModelInfo2[m_nJig].UseVacuum and (nSeqResult = SEQ_RESULT_WORKING) then begin
      {$IFDEF HAS_DIO_IN64}
        if m_nJig = DefPocb.CH_1 then DongaDio.SimulatorDioSetIn(UInt64(DefDio.MASK_IN_STAGE1_VACUUM1 or MASK_IN_STAGE1_VACUUM2))
        else                          DongaDio.SimulatorDioSetIn(UInt64(DefDio.MASK_IN_STAGE2_VACUUM1 or MASK_IN_STAGE2_VACUUM2));
      {$ELSE}
        if m_nJig = DefPocb.CH_1 then DongaDio.SimulatorDioSetIn(LongWord(DefDio.MASK_IN_STAGE1_VACUUM1 or MASK_IN_STAGE1_VACUUM2))
        else                          DongaDio.SimulatorDioSetIn(LongWord(DefDio.MASK_IN_STAGE2_VACUUM1 or MASK_IN_STAGE2_VACUUM2));
      {$ENDIF}
      end;
    end
    else if nSeqNo = DefPocb.POCB_SEQ_SCAN_BCR then begin
    {
      if nSeqResult = SEQ_RESULT_WORKING then begin
        Sleep(1000);
        if m_nJig = DefPocb.CH_1 then GetBcrData('POCBSIMCH1111')
        else                          GetBcrData('POCBSIMCH2222');
      end;
    }
    end
    else if nSeqNo = DefPocb.POCB_SEQ_POWER_OFF then begin
      if nSeqResult = SEQ_RESULT_WORKING then begin
      //if m_nJig = DefPocb.CH_1 then DongaDio.SimulatorDioClrIn(UInt64(DefDio.MASK_IN_STAGE1_VACUUM_1 or MASK_IN_STAGE1_VACUUM_2))
      //else                          DongaDio.SimulatorDioClrIn(UInt64(DefDio.MASK_IN_STAGE2_VACUUM_1 or MASK_IN_STAGE2_VACUUM_2));
      end;
    end
end;
{$ENDIF}

procedure TfrmTest1Ch.ShowFlashWriteProgress(nFlashProgress: Integer; sMsg: string = '');
begin
  case nFlashProgress of
    DefPocb.FLASH_PROGRESS_NONE : begin
    //pnlDisplayPattern.Visible  := True;
      RzpnlFlashProgress.Visible := False;
      tmrFlashEraseTact.Enabled    := False;
      tmrFlashWriteAckTact.Enabled := False;
      //TBD?
    end;
    DefPocb.FLASH_PROGRESS_START : begin
      m_nFlashEraseTact := 0;
      pnlFlashEraseValue.Font.Color    := clBtnFace;
      pnlFlashEraseValue.Caption       := '--:--';
      pnlFlashTxValue.Font.Color       := clBtnFace;
      pnlFlashTxValue.Caption          := '-- %';
      m_nFlashWriteAckTact := 0;
      pnlFlashWriteAckValue.Font.Color := clBtnFace;
      pnlFlashWriteAckValue.Caption    := '--:--';
    //pnlDisplayPattern.Visible  := False;
      RzpnlFlashProgress.Visible := True;
    end;
    DefPocb.FLASH_PROGRESS_ERASE_START : begin
      pnlFlashEraseValue.Font.Color := clYellow;
      tmrFlashEraseTact.Enabled := True;
    end;
    DefPocb.FLASH_PROGRESS_ERASE_END : begin
      pnlFlashEraseValue.Font.Color := clLime;
      pnlFlashTxValue.Font.Color    := clYellow;
      tmrFlashEraseTact.Enabled := False;
    end;
    DefPocb.FLASH_PROGRESS_DATA_PERCENTAGE : begin
      if (sMsg = '100') then pnlFlashTxValue.Font.Color := clLime;
      pnlFlashTxValue.Caption := sMsg + ' %';
    end;
    DefPocb.FLASH_PROGRESS_ENDACK_START : begin
      pnlFlashWriteAckValue.Font.Color := clYellow;
      tmrFlashWriteAckTact.Enabled := True;
    end;
    DefPocb.FLASH_PROGRESS_ENDACK_END : begin
      pnlFlashWriteAckValue.Font.Color := clLime;
      tmrFlashWriteAckTact.Enabled := False;
    end;
  end;
end;

//******************************************************************************
// procedure/function: frmTest1Ch -> frmMain
//    - MSG_TYPE_JIG
//        MSG_MODE_DISPLAY_ALARM
//******************************************************************************

procedure TfrmTest1Ch.SendMainGuiDisplay(nGuiMode, nCH, nP1: Integer; nP2: Integer; nP3: Integer = 0; sMsg: string = '');
var
  ccd : TCopyDataStruct;
  GuiJigData : RGuiJigData;
begin
  GuiJigData.MsgType := DefPocb.MSG_TYPE_JIG;
  GuiJigData.Channel := nCH;
  GuiJigData.Mode    := nGuiMode;   // MSG_MODE_DISPLAY_ALARM,   MSG_MODE_DISPLAY_STATUS
  GuiJigData.Param1  := nP1;        // alarmNo                   A2CH:1{FpcUsageLimitOver}
  GuiJigData.Param2  := nP2;        // 0:alarm Off, 1:alarm On
  GuiJigData.Param3  := nP3;        // 2018-11-21(NOT-USED)
  GuiJigData.Msg     := sMsg;       // 2018-11-21(NOT-USED)
  ccd.dwData := 0;
  ccd.cbData := SizeOf(GuiJigData);
  ccd.lpData := @GuiJigData;
  SendMessage(m_hMain,WM_COPYDATA,0, LongInt(@ccd));
end;

//******************************************************************************
// procedure/function: WMCopyData
//******************************************************************************

procedure TfrmTest1Ch.WMCopyData(var Msg: TMessage);
var
  nType, nMode, nPg, nCh, nParam, nParam2, i, j, nPatType : Integer;
  bTemp : Boolean;
  sMsg, sDebug, sTemp : string;
  slTemp : TStringList;
begin
  {
    RGuiCamData = packed record  // CammComm
      MsgType : Integer;
      Channel : Integer;
      Mode    : Integer;
      Param   : Integer;
      Msg     : string;
    end;
    RGuiLogic2Test = packed record     // LogicPocb
      MsgType : Integer;
      Channel : Integer;
      Mode    : Integer;
      Param   : Integer;
      Msg     : string[200];
    end;
    RGuiJigData = packed record   // JigControl
      MsgType : Integer;
      Channel : Integer;
      Mode    : Integer;
      nParam  : Integer;
      nParam1 : Integer;
      nParam2 : Integer;
      sMsg    : string;  //TBD:POCB-ONLY
    end;
    TransVoltage = record      // UdpServerPocb
      MsgType : Integer;
      PgNo    : Integer;
      Mode    : Integer;
      nParam  : Integer;
      sMsg    : string[250];
      ReadPwrData : ReadVoltCurr;
    end;
  }
  nType   := PTestGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.MsgType;
  //각 nType에서   nMode   := PGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
  //각 nType에서   nCh     := PGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
  case nType of
    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_CAMERA : begin
      nMode   := PTestGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nCh     := PTestGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel; //POCB: nCam=nCh
      nParam  := PTestGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;
      nParam2 := PTestGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param2;
      sMsg    := Trim(PTestGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg);

      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_WORKING : begin
          AppendChannelLog(sMsg,nParam);
          TMLog(nCh,sMsg);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_RESULT : begin
        //DisplayChStatus(TStatusType(nParam), sMsg); // <Param>  0: OK, 1: NG, 2:INFO
          if      nParam =  DefPocb.SEQ_RESULT_FAIL then DisplayChStatus(CH_STATUS_NG,sMsg)   //2019-05-xx
          else if nParam =  DefPocb.SEQ_RESULT_PASS then DisplayChStatus(CH_STATUS_OK,sMsg)
          else                                           DisplayChStatus(CH_STATUS_INFO,sMsg); //2021-05
          AppendChannelLog(sMsg,TernaryOp((nParam=DefPocb.SEQ_RESULT_FAIL),DefPocb.LOG_TYPE_NG,DefPocb.LOG_TYPE_INFO));
          TMLog(nCh,sMsg);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_PATTERN : begin  // <Param> Pattern#
          if Length(sMsg) > 1 then begin //2022-07-15 UNIFORMITY_PUCONOFF
            if (UpperCase(sMsg) = 'PUC-ON') or (UpperCase(sMsg) = 'PUC-OFF') then begin
              slTemp := TStringList.Create;
              try
                ExtractStrings(['/'],[],PWideChar(pnlDisplayPattern.Caption),slTemp);
                if (slTemp.Count > 0) then pnlDisplayPattern.Caption := slTemp[0] + '/' + sMsg
                else                       pnlDisplayPattern.Caption := sMsg;
              except
                pnlDisplayPattern.Caption := sMsg;
              end;
            end
            else begin
              pnlDisplayPattern.Caption := sMsg;
            end;
          end
          else begin
            if gridPatternList.RowCount > 0 then begin
              if (nParam >= 0) and (nParam < gridPatternList.RowCount) then
                pnlDisplayPattern.Caption := Trim(gridPatternList.Cells[1,nParam])
              else
                pnlDisplayPattern.Caption := '';
            end;
            { //TBD:GUI? (grinPatternList만 사용하고, GUI상에는 Display되는 Pattern만 표기)
            gridPatternList.Row := nTemp;
            pnlDispPatName.Caption := Trim(gridPatternList.Cells[1, nTemp]);
            nPatType := StrToInt(gridPatternList.Cells[0, nTemp]);
            RzlnDispPatSigOff1.Visible := False;
            RzlnDispPatSigOff2.Visible := False;
            DongaPat.DrawPatAllPat(nPatType, gridPatternList.Cells[1, nTemp]); }
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_ALARM : begin  // <Param> 0:OK, 1:NG
          pnlJigStatus.Caption := sMsg;
          if (Logic[nCh] <> nil) and
              ((Logic[nCh].m_InsStatus = IsCamera) or
               (DongaDio.m_nAutoFlow[m_nJig] in [IO_AUTO_FLOW_FRONT, IO_AUTO_FLOW_SHUTTER_DOWN, IO_AUTO_FLOW_SHUTTER_UP, IO_AUTO_FLOW_BACK])) then //2023-06-14
          begin
            WorkStop(StopByAlarm);
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ: begin  //2019-05-20
          ShowFlowSeq(nParam{SeqNo}, nParam2{nSeqResult});
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_CAM_CRC: begin
          SetCRCValue(1, Common.m_ModelCrc[nCh].CB_Algorithm);
          SetCRCValue(2, Common.m_ModelCrc[nCh].Cam_Parameter);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_STOP_CAMERA: begin
          if Logic[nCh].m_InsStatus = IsCamera then
            WorkStop(StopByAlarm);
        end
        else begin
          Common.MLog(nCh,'<TestCh> CH'+IntToStr(nCh+1)+': WMCopyData: TYPE_CAMERA, UnknownMode('+IntToStr(nMode)+')');
        end;
      end;
    end;
    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_LOGIC : begin
      nMode   := PGuiLogic2Test(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nCh     := PGuiLogic2Test(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
      nParam  := PGuiLogic2Test(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;
      nParam2 := PGuiLogic2Test(PCopyDataStruct(Msg.LParam)^.lpData)^.Param2;
      sMsg    := Trim(PGuiLogic2Test(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg);
    //Common.MLog(nCh,'<TestCh> CH'+IntToStr(nCh+1)+': WMCopyData: TYPE_LOGIV, Mode('+IntToStr(nMode)+') Msg('+sMsg+')');
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_CH_CLEAR : begin
          pnlSerialNo.Caption := '';
          pnlPCBNo.Caption    := '';
          mmChannelLog.Clear;
          //CameraComm.m_hTest := Self.Handle;  //TBD?
        //pnlChStatus.Color := clBtnFace;
          pnlChStatus.Caption := '';
        //pnlMesResult.Color := clBtnFace; //2018-12-03
          pnlMesResult.Caption := '';
          pnlJigStatus.Caption  := '';
        end;
        //--------------------------------
        DefPocb.MSG_MODE_TACT_START : begin
          m_nTotalTact := 0;
          m_nJigTact   := 0; //2019-01-02
          m_nUnitTact  := 0; //2018-12-05
          if tmrTotalTact <> nil then tmrTotalTact.Enabled := True;
          pnlTactUnitValue.Caption := '00 : 00'; //2018-12-05
          pnlJigStatus.Caption := '';
{$IFDEF USE_FPC_LIMIT}
          if Common.SystemInfo.FpcUsageLimitUse then begin  //2019-04-11 FPC Usage Limit
            Common.m_nFpcUsageValue[nCh] := Common.m_nFpcUsageValue[nCh] + 1;
            Common.SaveFpcUsageValue(nCh);
            if Common.m_nFpcUsageValue[nCh] > Common.SystemInfo.FpcUsageLimitValue then pnlFpcUsageValue.Font.Color := clRed
            else                                                                        pnlFpcUsageValue.Font.Color := clLime;
            pnlFpcUsageValue.Caption := Format('%d',[Common.m_nFpcUsageValue[nCh]]);
            //
            if (Common.SystemInfo.FpcUsageLimitValue > 0) and (Common.m_nFpcUsageValue[nCh] >= Common.SystemInfo.FpcUsageLimitValue) then begin
              SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,nCh,1{FpcUsageLimitOver},0);
              sDebug := '<FPC> CH'+IntToStr(nCh)+' FPC Cable Usage Limit Over (Max='+IntToStr(Common.SystemInfo.FpcUsageLimitValue)+', Now='+IntToStr(Common.m_nFpcUsageValue[nCh])+')';
              Common.MLog(nCh,sDebug);
            end;
          end;
{$ENDIF}
{$IFDEF REF_ISPD_DFS}
          if (모든 CH이 Off상태) then begin // Timer 시작....
            if DongaGmes <> nil then begin
              if tmrLogOut <> nil then tmrLogOut.Enabled := True;   // On-Line이면 LogOut Timer On
            end begin
              if tmrLogIn <> nil then tmrLogIn.Enabled := True;     // Off-Line이면 LogIn Timer On
            end;
          end;
{$ENDIF}
        end;
        //--------------------------------
        DefPocb.MSG_MODE_UNIT_TT_START : begin
          m_nUnitTact := 0;
          if tmrUnitTact <> nil then tmrUnitTact.Enabled := True;
          Logic[nCh].m_Inspect.UnitTimeStart := Now;  //2018-12-05 for Summary
          Logic[nCh].m_Inspect.UnitTimeEnd   := Logic[nCh].m_Inspect.UnitTimeStart;  //2018-12-05 for Summary
          pnlTactUnitValue.Caption := '00 : 00';
          pnlJigStatus.Caption  := '';
        end;
        //--------------------------------
        DefPocb.MSG_MODE_UNIT_TT_STOP : begin
          if tmrUnitTact <> nil then tmrUnitTact.Enabled := False;
          Logic[nCh].m_Inspect.UnitTimeEnd   := Now;  //2018-12-05 for Summary
          if nParam = 0 then Inc(m_nOkCnt)   // <Param> 0: OK, 1: NG
          else               Inc(m_nNGCnt);
          pnlCntTotalValue.Caption  := format('%d',[m_nOkCnt + m_nNgCnt]);
          pnlCntOkValue.Caption     := Format('%d',[m_nOkCnt]);
          pnlCntNgValue.Caption     := Format('%d',[m_nNgCnt]);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_WORKING : begin
          AppendChannelLog(sMsg,nParam);
          TMLog(nCh,sMsg);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_LOG_ON_GUI : begin
          TMLog(nCh,sMsg);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_PATTERN : begin  // <Param> pattern#
          if gridPatternList.RowCount > 0 then begin  //TBD:GUI? (gridPatternList?)
            if (nParam >= 0) and (nParam < gridPatternList.RowCount) then
              pnlDisplayPattern.Caption := Trim(gridPatternList.Cells[1,nParam])
            else if nParam = -2 then  //TBD:A2CHv3:ASSY-POCB:FLOW?
              pnlDisplayPattern.Caption := 'Display Off'
            else if nParam = -3 then  //TBD:A2CHv3:ASSY-POCB:FLOW?
              pnlDisplayPattern.Caption := 'Display On'
            else
              pnlDisplayPattern.Caption := '';
            { //TBD:GUI? (grinPatternList만 사용하고, GUI상에는 Display되는 Pattern만 표기)
            gridPatternList.Row := nParam;
            pnlDispPatName.Caption := Trim(gridPatternList.Cells[1, nParam]);
            nPatType := StrToInt(gridPatternList.Cells[0, nParam]);
            RzlnDispPatSigOff1.Visible := False;
            RzlnDispPatSigOff2.Visible := False;
            DongaPat.DrawPatAllPat(nPatType, gridPatternList.Cells[1, nParam]); }
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_RESULT : begin   // <Param> 1:Clear, 2:Pass, 3:Fail, 4:Working  // SEQ_RESULT_XXXX
        //if nParam <> DefPocb.SEQ_RESULT_PASS then pnlChStatus.Color := clRed
          if      nParam =  DefPocb.SEQ_RESULT_FAIL then DisplayChStatus(CH_STATUS_NG,sMsg)   //2019-05-xx
          else if nParam =  DefPocb.SEQ_RESULT_PASS then DisplayChStatus(CH_STATUS_OK,sMsg)
          else                                           DisplayChStatus(CH_STATUS_INFO,sMsg); //2021-05
					//
          AppendChannelLog(sMsg, TernaryOp((nParam=DefPocb.SEQ_RESULT_FAIL),DefPocb.LOG_TYPE_NG,DefPocb.LOG_TYPE_INFO));
          TMLog(nCh,sMsg);  //2021-05 TBD?
        end;
        //--------------------------------
        DefPocb.MSG_MODE_SHOW_SERIAL_NUMBER : begin   //TBD:GUI? (Logic->Test1Ch 송신 없음)
          if nParam = 1 then begin  //2018-12-03 (for 'Scan Barcode')
            pnlSerialNo.Caption := sMsg;
            AppendChannelLog('[BCR#] '+sMsg);
          end
          else begin
            DisplayChStatus(CH_STATUS_INFO, 'Scan Barcode');
            ShowFlowSeq(DefPocb.POCB_SEQ_SCAN_BCR,DefPocb.SEQ_RESULT_WORKING); //2019-05-20 GUI:FlowSeq
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_FLOW_STOP_REPORT : begin
          //Common.MLog(nCh,'<TestCh> TYPE_LOGIC, MODE_FLOW_STOP_REPORT',DefPocb.DEBUG_LEVEL_INFO);
          tmrTotalTact.Enabled  := False;
          tmrJigTact.Enabled    := False;
          tmrUnitTact.Enabled   := False;
          tmrFlashEraseTact.Enabled    := False;  //2021-05
          tmrFlashWriteAckTact.Enabled := False;  //2021-05
          //2019-01-19  pnlSerialNo.Caption := '';
          if (pnlChStatus.Caption = '') or (pnlChStatus.Caption = 'Power On')
             or (pnlChStatus.Caption = 'Ready To Turn') or (pnlChStatus.Caption = 'Scan Barcode') 
						 {$IFDEF SUPPORT_1CG2PANEL}
						 or (pnlChStatus.Caption = 'SKIP Camera Process')  //2022-06-XX SKIP_POCB
						 {$ENDIF}
					then begin //2018-12-03
            DisplayChStatus(CH_STATUS_READY,'Ready');
          end;
          gridChPower.Cells[1,1] := '';
          gridChPower.Cells[3,1] := '';
          gridChPower.Cells[1,2] := '';
          gridChPower.Cells[3,2] := '';
          if m_nJig = DefPocb.JIG_A then begin
            if Common.SystemInfo.HasDioVacuum and Common.TestModelInfo2[m_nJig].UseVacuum then begin //2023-04-10 HasDioVacuum
              if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_VACUUM1) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE1_VACUUM1);
              if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_VACUUM2) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE1_VACUUM2);
            end;
            if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_READY_LED) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE1_READY_LED);
          end
          else begin
            if Common.SystemInfo.HasDioVacuum and Common.TestModelInfo2[m_nJig].UseVacuum then begin //2023-04-10 HasDioVacuum
              if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_VACUUM1) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE2_VACUUM1);
              if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_VACUUM2) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE2_VACUUM2);
            end;
            if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_READY_LED) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE2_READY_LED);
          end;
					//
          if Common.TestModelInfo2[m_nJig].UseIonOnOff then begin
            for i := 0 to (Common.SystemInfo.IonizerCntPerCH-1) do begin
              j := (m_nJig*Common.SystemInfo.IonizerCntPerCH) + i;
              if (DaeIonizer[j] <> nil) then begin
                DaeIonizer[j].SetIonizer(True{On});
              end;
            end;
            AppendChannelLog('<IONIZER> ON');
            TMLog(nCh,sMsg);
          end;
					//
          Common.Delay(100);
          if Common.TestModelInfo2[m_nJig].UseVacuum then DongaDio.SetBlow(m_nJig, 250);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_SHOW_READY_TO_TURN : begin   // <Param>  0:set to ReadyToTurn, 1:Clear
          if nParam <> 0 then begin
            DisplayChStatus(CH_STATUS_IDLE);
          end
          else begin
            DisplayChStatus(CH_STATUS_INFO, 'Ready To Turn');
            ShowFlowSeq(DefPocb.POCB_SEQ_PRESS_START{SeqNo}, DefPocb.SEQ_RESULT_WORKING{nSeqResult});
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_CH_STATUS : begin  //2018-12-03
          DisplayChStatus(nParam, sMsg);
        end;
        //--------------------------------                                      +
        DefPocb.MSG_MODE_WORK_DONE : begin  //TBD:GUI? (Logic->Test1Ch 송신하지만, 처리없음?)
          //Common.MLog(nCh,'<TestCh> TYPE_LOGIC, MSG_MODE_WORK_DONE ...NotUsed',DefPocb.DEBUG_LEVEL_INFO);
        end;
        //--------------------------------------------------------------------------
        DefPocb.MSG_MODE_DISPLAY_JIG_STATUS: begin  //2018-12-12
          ShowJIGStatus(sMsg);
        end;
        //--------------------------------------------------------------------------
        DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ: begin  //2019-05-20
          ShowFlowSeq(nParam{SeqNo}, nParam2{nSeqResult});
        end;
        DefPocb.MSG_MODE_CONFIRM_HOST : begin
          pnlShowNgConfirm.Visible := True;
        end;
        DefPocb.MSG_MODE_RESET_TOWERLAMP: begin
          DongaDio.SetTowerLamp(False, False, True, False);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE : begin  //2021-05
          case nParam of
            DefPocb.FLASH_PROGRESS_NONE,
            DefPocb.FLASH_PROGRESS_START,
            DefPocb.FLASH_PROGRESS_ERASE_START,
            DefPocb.FLASH_PROGRESS_ERASE_END,
          //DefPocb.FLASH_PROGRESS_DATA_PERCENTAGE,
            DefPocb.FLASH_PROGRESS_ENDACK_START,
            DefPocb.FLASH_PROGRESS_ENDACK_END : begin
              ShowFlashWriteProgress(nParam, '');
            end;
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_IONIZER_ONOFF : begin  //2022-01-02
          if Common.TestModelInfo2[nCh].UseIonOnOff then begin
            for i := 0 to (Common.SystemInfo.IonizerCntPerCH-1) do begin
              j := (nCh*Common.SystemInfo.IonizerCntPerCH) + i;
              if (DaeIonizer[j] <> nil) then begin
                if (nParam = 0) then DaeIonizer[j].SetIonizer(False{Off})
                else                 DaeIonizer[j].SetIonizer(True{On});
              end;
            end;
            //
            if sMsg <> '' then begin
              AppendChannelLog(sMsg);
              TMLog(nCh,sMsg);
            end;
          end;
        end;
        //--------------------------------
        {$IFDEF SUPPORT_1CG2PANEL}
        DefPocb.MSG_MODE_CONFIRM_SKIP_POCB : begin
          pnlShowSkipPocbConfirm.Visible := True;
        end;
        DefPocb.MSG_MODE_ALLCH_SKIP_POCB : begin
          WorkStop(StopbyOperator);
        end;
        {$ENDIF}

        DefPocb.MSG_MODE_OTHERCH_SCANBCR_MSG : begin //2023-08-11
          RzgrpScanBcrOtherChMsg.Visible := (nParam = DefPocb.OTHERCH_SCANBCR_VISIBLE_ON);
        end;

        //--------------------------------------------------------------------------
        else begin
          Common.MLog(nCh,'<TestCh> CH'+IntToStr(nCh+1)+': TYPE_LOGIC, UnknownMODE('+IntToStr(nMode)+')');
        end;
      end;
    end;
    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_PG : begin
      nMode   := PTestGuiPgData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nPg     := PTestGuiPgData(PCopyDataStruct(Msg.LParam)^.lpData)^.PgNo;
      nParam  := PTestGuiPgData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;
      nCh     := nPg;
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_CONNECTION : begin
          sMsg  := PTestGuiPgData(PCopyDataStruct(Msg.LParam)^.lpData)^.sMsg;
          case nParam of   // <Param> 0:PG-Connect, 1:PG-FWVersion, 2:PG-Disconnect, 10:SPI-Connecet, 11:SPI-FwVersion, 12:SPI-Disconnect
            0 : begin  // 0:PG-Connect
              ledPgStatus.TrueColor   := clYellow;
              ledPgStatus.Value       := True;
              pnlHwVer.Color          := clBtnFace;
              pnlHwVer.Font.Color     := clBlack;
              pnlHwVer.Font.Size      := 11;
              pnlHwVer.Caption        := 'PG Connected';
            end;
            1 : begin  // 1:PG-FWVersion
              ledPgStatus.TrueColor   := clLime;
              ledPgStatus.Value       := True;
              pnlHwVer.Color          := clBtnFace;
              pnlHwVer.Font.Color     := clBlack;
              pnlHwVer.Font.Size      := 9;
              pnlHwVer.Caption        := 'PG ' + Common.SystemInfo.PGFWName + ' FW ' + Pg[nPg].m_sFwVerPg + #13#10 + 'FPGA ' + Pg[nPg].m_sFpgaVerPg + ' ALDP ' + Pg[nPg].m_sALDPVerPg + ' DLPU ' + Pg[nPg].m_sDLPUVerPg;
            end;
            2 : begin  // 2:PG-Disconnect
              ledPgStatus.FalseColor  := clRed;
              ledPgStatus.Value       := False;
              pnlHwVer.Color          := clRed;
              pnlHwVer.Font.Color     := clYellow;
              pnlHwVer.Font.Size      := 11;
              pnlHwVer.Caption        := 'PG Disconnected';
            end;
            // 10이후 부터 SPI.
            10 : begin  // 10:SPI-Connect
              ledSpiStatus.TrueColor  := clYellow;
              ledSpiStatus.Value      := True;
              pnlSpiVer.Color         := clBtnFace;
              pnlSpiVer.Font.Color    := clBlack;
              pnlSpiVer.Caption       := 'SPI Connected';
            end;
            11 : begin  //11: FwVerSpi/BootVerSpi 13:ModelCrcSpi
              if (Common.SystemInfo.SPI_TYPE = SPI_TYPE_DJ023_SPI) then begin //DJ023: No ModelCrc
                ledSpiStatus.TrueColor  := clLime;
                ledSpiStatus.Value      := True;
                pnlSpiVer.Color         := clBtnFace;
                pnlSpiVer.Font.Color    := clBlack;
              end;
              pnlSpiVer.Font.Size     := 9;
              sTemp                   := 'SPI ' + Common.SystemInfo.SPIFWName + #13#10 + 'FW ' + Pg[nPg].m_sFwVerSpi;
							if (Common.SystemInfo.SPI_TYPE <> SPI_TYPE_DJ023_SPI) then sTemp := sTemp + ' BOOT ' + Pg[nPg].m_sBootVerSpi + ' CRC ' + Format('%0.4x',[Pg[nPg].m_wModelCrcSpi]);
							pnlSpiVer.Caption       := sTemp;
            end;
            12 : begin
              ledSpiStatus.FalseColor := clRed;
              ledSpiStatus.Value      := False;
              pnlSpiVer.Color         := clRed;
              pnlSpiVer.Font.Color    := clYellow;
              pnlSpiVer.Font.Size     := 11;
              pnlSpiVer.Caption       := 'SPI Disconnected';
            end;
            13 : begin
              ledSpiStatus.TrueColor  := clLime;
              ledSpiStatus.Value      := True;
              pnlSpiVer.Color         := clBtnFace;
              pnlSpiVer.Font.Color    := clBlack;
              pnlSpiVer.Font.Size     := 9;
              sTemp                   := 'SPI ' + Common.SystemInfo.SPIFWName + #13#10 + 'FW ' + Pg[nPg].m_sFwVerSpi;
              sTemp := 'SPI ' + Common.SystemInfo.SPIFWName + #13#10 + 'FW ' + Pg[nPg].m_sFwVerSpi;
							if (Common.SystemInfo.SPI_TYPE <> SPI_TYPE_DJ023_SPI) then sTemp := sTemp + ' BOOT ' + Pg[nPg].m_sBootVerSpi + ' CRC ' + Format('%0.4x',[Pg[nPg].m_wModelCrcSpi]);
							pnlSpiVer.Caption       := sTemp;
            end;
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_VOLCUR : begin
          DisplayPwrData(nCh,PTestGuiPgData(PCopyDataStruct(Msg.LParam)^.lpData)^.PwrDataPg);
          if CheckOutOfPwr(PTestGuiPgData(PCopyDataStruct(Msg.LParam)^.lpData)^.PwrDataPg, sTemp) then begin
            Pg[nCh].SetPowerMeasureTimer(False); //2023-10-19
            Common.MLog(nCh,sTemp); //2023-10-19
            AppendChannelLog('Out of Limit : ' + sTemp,LOG_TYPE_NG);
            ShowJIGStatus('Out of Limit : ' + sTemp);
          //ShowChTestNgMsg(nCh,'Out of Limit : ' + sTemp); //2023-10-19 TBD?
            if Logic[nCh].m_InsStatus <> IsStop then WorkStop(StopByAlarm);
          end
          else begin
          //ShowJIGStatus('');
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_ALARM : begin   //TBD:NOT-USED?
          sMsg  := PTestGuiPgData(PCopyDataStruct(Msg.LParam)^.lpData)^.sMsg;
          //TBD? pnlErrAlram.Caption := Format('Channel %d, %s',[nCh+1,Trim(sMsg)]);
          //TBD? pnlErrAlram.Visible := True;
          DisplayChStatus(CH_STATUS_NG, 'ALARM NG');
					sMsg := 'ALARM NG ('+ sMsg + ')';
          AppendChannelLog(sMsg,LOG_TYPE_NG);
          TMLog(nCh,sMsg);
          //TBD? tmrDisplayOff.Interval := 7000; // 5초 있다가 끄자... 그냥...
          //TBD? tmrDisplayOff.Enabled  := True;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_LOG_ON_GUI : begin
          sMsg  := PTestGuiPgData(PCopyDataStruct(Msg.LParam)^.lpData)^.sMsg;
          TMLog(nCh,sMsg);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_WORKING : begin
          sMsg := Trim(PTestGuiPgData(PCopyDataStruct(Msg.LParam)^.lpData)^.sMsg);
          AppendChannelLog(sMsg,nParam); //2022-08-01 (add nParam)
          TMLog(nCh,sMsg);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_PATTERN : begin  //2019-01-19 <Param> Pattern#
          if gridPatternList.RowCount > 0 then begin
            if (nParam >= 0) and (nParam < gridPatternList.RowCount) then
              pnlDisplayPattern.Caption := Trim(gridPatternList.Cells[1,nParam])
            else if nParam = -2 then // -1: Power Off, -2: Display Off, -3: Display On  //TBD:A2CHv3:ASSY-POCB:FLOW?
              pnlDisplayPattern.Caption := 'Display Off'
            else if nParam = -3 then                                                    //TBD:A2CHv3:ASSY-POCB:FLOW?
              pnlDisplayPattern.Caption := 'Display On'
            else
              pnlDisplayPattern.Caption := '';
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE : begin  //2021-05
          case nParam of
            DefPocb.FLASH_PROGRESS_DATA_PERCENTAGE : begin
              sMsg := PTestGuiPgData(PCopyDataStruct(Msg.LParam)^.lpData)^.sMsg;
              ShowFlashWriteProgress(nParam, sMsg);  // sMsg: Percentage
            end;
          end;
        end;
        else begin
          Common.MLog(nCh,'<TestCh> CH'+IntToStr(nCh+1)+': TYPE_PG, UnknownMode('+IntToStr(nMode)+')');
        end;
      end;
    end;
    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_MOTION : begin
      nMode   := PTestGuiMotionData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nCh     := PTestGuiMotionData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
      nParam  := PTestGuiMotionData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;  // <Param> AXIS_Y,Z,..
			sMsg    := Trim(PTestGuiMotionData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg);			
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_STATUS : begin
          ShowMotionStatus(nCh,nParam);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_LOG_ON_GUI : begin
          //Common.MLog(nCh,'<TestCh> TYPE_MOTION, MODE_LOG_ON_GUI',DefPocb.DEBUG_LEVEL_INFO);
          //TBD?
        end;
        //--------------------------------
        DefPocb.MSG_MODE_WORKING : begin
          AppendChannelLog(sMsg);
          TMLog(nCh,sMsg);
        end;
        else begin
          Common.MLog(nCh,'<TestCh> CH'+IntToStr(nCh+1)+': TYPE_MOTION, UnknownMode('+IntToStr(nMode)+')');
        end;
      end;
    end;
    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_ROBOT : begin   //A2CHv3:ROBOT
      nMode   := PTestGuiRobotData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nCh     := PTestGuiRobotData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
      nParam  := PTestGuiRobotData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;  // <Param> Robot
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_STATUS : begin
          sMsg  := PTestGuiMotionData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
          ShowRobotStatusCoord;
        end;
        else begin
          Common.MLog(nCh,'<TestCh> CH'+IntToStr(nCh+1)+': TYPE_ROBOT, UnknownMode('+IntToStr(nMode)+')');
        end;
      end;
    end;
    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_DIO : begin  //2018-12-10
      nMode   := PTestGuiDioData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nCh     := PTestGuiDioData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
      nParam  := PTestGuiDioData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;
      nParam2 := PTestGuiDioData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param2;
      sMsg    := Trim(PTestGuiDioData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg);
      case nMode of
        DefPocb.MSG_MODE_DISPLAY_JIG_STATUS: begin
          ShowJIGStatus(sMsg);
          Common.MLog(nCh, sMsg);
        end;
        //--------------------------------
        DefPocb.MSG_MODE_JIG_TT_START : begin  //2019-01-02 for JigTactTime
          Common.MLog(nCh,'<TestCh> JIG_TT_START');
          if (tmrJigTact <> nil) and (not tmrJigTact.Enabled) then begin
            m_nJigTact  := 0;
            m_nUnitTact := 0;
            Logic[nCh].m_Inspect.JigTimeStart := Now;
            Logic[nCh].m_Inspect.JigTimeEnd   := Logic[nCh].m_Inspect.JigTimeStart;
            pnlTactJigValue.Caption := '00 : 00';
          end;
          pnlJigStatus.Caption := '';  //TBD?
          if tmrJigTact <> nil then tmrJigTact.Enabled := True;
          //
{$IFDEF SITE_LENSVN}
          if (DongaGmes <> nil) and Common.m_bMesOnline then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_SEND_GMES, nCH, LENS_MES_STATUS_RUN, 0{dummy});
          end;
{$ENDIF}
        end;
        //--------------------------------
        DefPocb.MSG_MODE_JIG_TT_STOP : begin  //2019-01-02 for JigTactTime
          //Common.MLog(nCh,'<TestCh> JIG_TT_STOP',DefPocb.DEBUG_LEVEL_INFO);
          if tmrJigTact <> nil then tmrJigTact.Enabled := False;
          Logic[nCh].m_Inspect.JigTimeEnd := Now;
          //
{$IFDEF SITE_LENSVN}
          if (DongaGmes <> nil) and Common.m_bMesOnline then begin
            SendMainGuiDisplay(DefPocb.MSG_MODE_SEND_GMES, nCH, LENS_MES_STATUS_IDLE, 0{dummy});
          end;
{$ENDIF}
        end;
        //--------------------------------------------------------------------------
        DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ: begin  //2019-05-20
          ShowFlowSeq(nParam{SeqNo}, nParam2{nSeqResult});
        end;
        DefPocb.MSG_MODE_RESET_TOWERLAMP: begin
          DongaDio.SetTowerLamp(False, False, True, False);
        end;
        DefPocb.MSG_MODE_FLOW_STOP: begin
          if Logic[nCh].m_InsStatus <> IsStop then WorkStop(StopByAlarm);
        end;
        DefPocb.MSG_MODE_WORKING: begin  //2022-08-01
          AppendChannelLog(sMsg,nParam);
					TMLog(nCh,sMsg);
        end;
        MSG_MODE_DIO_LOG: begin //2023-05-02
          sTemp := 'DateTime,CH,DIO,EVENT,TT_MSEC';
          Common.MakeDioLog(sTemp,sMsg);
        end;
        //--------------------------------
        else begin
          Common.MLog(nCh,'<TestCh> CH'+IntToStr(nCh+1)+': TYPE_DIO, Unknown MODE('+IntToStr(nMode)+')');
        end;
      end;
    end;
    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_HOST : begin
      nMode   := PSyncHost(PCopyDataStruct(Msg.LParam)^.lpData)^.MsgMode;
      nCh     := PSyncHost(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
      bTemp   := PSyncHost(PCopyDataStruct(Msg.LParam)^.lpData)^.bError;
      sMsg    := PSyncHost(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
    //nPg     := nCh;
      case nMode of
        {$IFDEF SITE_LENSVN}
        DefGmes.MES_ZSET : begin
          if bTemp then begin // error
            sTemp := 'MES:ReInput NG';
            pnlMesResult.Color      := clMaroon;
            pnlMesResult.Font.Color := clRed;
            pnlMesResult.Caption    := sTemp;
            sTemp := sTemp + ' [' + sMsg + ']';
            AppendChannelLog(sTemp, DefPocb.LOG_TYPE_NG);
          end
          else begin
            sTemp := 'MES:ReInput OK';
            pnlMesResult.Color      := clGreen;
            pnlMesResult.Font.Color := clBlack;
            pnlMesResult.Caption    := sTemp;
	          AppendChannelLog(sTemp);
          end;
          Common.MLog(nCh,'<MES> '+sTemp);
				end;
        DefGmes.MES_EQCC : begin
          if bTemp then begin // error
            sTemp := 'MES:Stats NG';
            sTemp := sTemp + ' [' + sMsg + ']';
            AppendChannelLog(sTemp, DefPocb.LOG_TYPE_NG);
          end
          else begin
            sTemp := 'MES:Status OK';
	          AppendChannelLog(sTemp);
          end;
          Common.MLog(nCh,'<MES> '+sTemp);
				end;
     		{$ENDIF} //SITE_LENSVN
        DefGmes.MES_PCHK, DefGmes.MES_INS_PCHK : begin
          if bTemp then begin // error
            if Common.TestModelInfo2[nCh].UseScanFirst then Logic[nCh].m_Inspect.IsScanned := False; //2023-07-27
            {$IFDEF SITE_LENSVN}
            if nMode = DefGmes.MES_PCHK then sTemp := 'MES:START NG' else sTemp := 'MES:GIB:START NG';
            {$ELSE}
            if nMode = DefGmes.MES_PCHK then sTemp := 'PCHK NG' else sTemp := 'INS_PCHK NG';
            {$ENDIF}
            pnlMesResult.Color      := clMaroon;
            pnlMesResult.Font.Color := clRed;
            pnlMesResult.Caption    := sTemp;
            {$IFDEF SITE_LENSVN}
            sTemp := sTemp + ' [' + sMsg + ']';
            {$ELSE}
            sTemp := sTemp + ' (' + sMsg + ')';
            {$ENDIF}
            AppendChannelLog(sTemp, DefPocb.LOG_TYPE_NG);
            ShowFlowSeq(DefPocb.POCB_SEQ_MES_PCHK,DefPocb.SEQ_RESULT_FAIL);
          end
          else begin
            {$IFDEF SITE_LENSVN}
            if nMode = DefGmes.MES_PCHK then sTemp := 'MES:START OK' else sTemp := 'MES:GIB:START OK';
            {$ELSE}
            if nMode = DefGmes.MES_PCHK then sTemp := 'PCHK OK' else sTemp := 'INS_PCHK OK';
            {$ENDIF}
            pnlMesResult.Color      := clGreen;
            pnlMesResult.Font.Color := clBlack;
            pnlMesResult.Caption    := sTemp;
	          AppendChannelLog(sTemp);
            ShowFlowSeq(DefPocb.POCB_SEQ_MES_PCHK,DefPocb.SEQ_RESULT_PASS);
						{$IFDEF FEATURE_BCR_SCAN_SPCB}
            if Common.TestModelInfo2[nCh].BcrScanMesSPCB then begin
              pnlPCBNo.Caption := Logic[nCh].m_Inspect.PanelID;
              if Common.MesData[nCh].bRxPchkRtnPid then begin
                Logic[nCh].m_Inspect.PanelID := Trim(Common.MesData[nCh].PchkRtnPid);
                pnlPCBNo.Caption := Logic[nCh].m_Inspect.PanelID;
                sTemp := sTemp + ' (RTN_PID='+Logic[nCh].m_Inspect.PanelID+')';
              end
              else begin
                {$IFDEF SITE_LENSVN}
                {$ELSE}
                sTemp := sTemp + ' (RTN_PID=)';
                {$ENDIF}
              end;
            end;
						{$ENDIF}
          end;
          Common.MLog(nCh,'<MES> '+sTemp);
          //
          if nMode = DefGmes.MES_PCHK then Logic[nCh].RunMesEventSeq(DefGMes.MES_PCHK)
          else                             Logic[nCh].RunMesEventSeq(DefGMes.MES_INS_PCHK);
				end;
        DefGmes.MES_EICR, DefGmes.MES_RPR_EIJR : begin
          if bTemp then begin // error
            {$IFDEF SITE_LENSVN}
            if nMode = DefGmes.MES_EICR then sTemp := 'MES:END NG' else sTemp := 'MES:GIB:END NG';
            {$ELSE}
            if nMode = DefGmes.MES_EICR then sTemp := 'EICR NG' else sTemp := 'RPR_EIJR NG';
            {$ENDIF}
            pnlMesResult.Color      := clMaroon;
            pnlMesResult.Font.Color := clRed;
            pnlMesResult.Caption    := sTemp;
            {$IFDEF SITE_LENSVN}
            sTemp := sTemp + ' [' + sMsg + ']';            
            {$ELSE}            
            sTemp := sTemp + ' (' + sMsg + ')';
            {$ENDIF}
	          AppendChannelLog(sTemp, DefPocb.LOG_TYPE_NG);
            ShowFlowSeq(DefPocb.POCB_SEQ_MES_EICR,DefPocb.SEQ_RESULT_FAIL);
          end
          else begin
            {$IFDEF SITE_LENSVN}
            if nMode = DefGmes.MES_EICR then sTemp := 'MES:END OK' else sTemp := 'MES:GIB:END OK';
            {$ELSE}
            if nMode = DefGmes.MES_EICR then sTemp := 'EICR OK' else sTemp := 'RPR_EIJR OK';
            {$ENDIF}
            pnlMesResult.Color      := clGreen;
            pnlMesResult.Font.Color := clBlack;
            pnlMesResult.Caption := sTemp;
	          AppendChannelLog(sTemp);
            ShowFlowSeq(DefPocb.POCB_SEQ_MES_EICR,DefPocb.SEQ_RESULT_PASS);
          end;
          Common.MLog(nCh,'<MES> '+sTemp);
          //
          if nMode = DefGmes.MES_EICR then Logic[nCh].RunMesEventSeq(DefGMes.MES_EICR)
          else                             Logic[nCh].RunMesEventSeq(DefGMes.MES_RPR_EIJR);
        end;
{$IFDEF USE_MES_APDR}
        DefGmes.MES_APDR : begin
          if bTemp then begin // error
            sTemp := 'MES APDR NG';
	          AppendChannelLog(sTemp, DefPocb.LOG_TYPE_NG);
            pnlMesResult.Color      := clMaroon;
            pnlMesResult.Font.Color := clRed;
            pnlMesResult.Caption    := sTemp;
            sTemp := sTemp + '(' + sMsg + ')';
          end
          else begin
            sTemp := 'MES APDR OK';
	          AppendChannelLog(sTemp);
            pnlMesResult.Color      := clGreen;
            pnlMesResult.Font.Color := clBlack;
            pnlMesResult.Caption    := sTemp;
          end;
          Common.MLog(nCh,'<MES> '+sTemp);
          //
          Logic[nCh].RunMesEventSeq(DefGMes.MES_APDR);
        end;
{$ENDIF}
        DefGmes.EAS_APDR : begin
          if bTemp then begin // error
            sTemp := 'EAS APDR NG';
	          AppendChannelLog(sTemp, DefPocb.LOG_TYPE_NG);
            pnlMesResult.Color      := clMaroon;
            pnlMesResult.Font.Color := clRed;
            pnlMesResult.Caption    := sTemp;
            sTemp := sTemp + '(' + sMsg + ')';
          end
          else begin
            sTemp := 'EAS APDR OK';
	          AppendChannelLog(sTemp);
            pnlMesResult.Color      := clGreen;
            pnlMesResult.Font.Color := clBlack;
            pnlMesResult.Caption    := sTemp;
          end;
          Common.MLog(nCh,'<EAS> '+sTemp);
          //
          Logic[nCh].RunMesEventSeq(DefGMes.EAS_APDR);
        end;
        //--------------------------------
        else begin
          Common.MLog(nCh,'<TestCh> CH'+IntToStr(nCh+1)+': TYPE_HOST, Unknown MODE('+IntToStr(nMode)+')');
        end;
      end;
    end;
    else begin
      Common.MLog(nCh,'<TestCh> CH'+IntToStr(nCh+1)+': WMCopyData: TYPE_Unknown('+IntToStr(nType)+')');
    end;
  end;
end;

procedure TfrmTest1Ch.TMLog(nCh: Integer; sMsg: string);
begin
  Common.MLog(nCh,sMsg);
  pnlInsStatus.Caption := sMsg;
end;

end.
