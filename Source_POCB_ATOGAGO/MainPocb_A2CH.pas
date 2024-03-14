unit MainPocb_A2CH;

interface
{$I Common.inc}

uses
  System.Classes, System.ImageList, System.SysUtils, System.UITypes, System.Variants,
  Winapi.Windows, Winapi.Messages, SafetyScreen,
  // TMS components
  Vcl.Buttons, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.Graphics, Vcl.Grids, Vcl.ImgList, Vcl.Menus, Vcl.StdCtrls, Vcl.Themes,
  RzButton, RzCommon, RzEdit, RzPanel, RzRadChk, RzShellDialogs, RzSplit, RzStatus,
  AdvObj, AdvGrid, AdvOutlookList, AdvPanel, AdvUtil, ALed, BaseGrid, TILed, RichEdit,
  // 3rd-party Classes
//{$IFDEF DEBUG}
	CodeSiteLogging,
//{$ENDIF}
  // User added classes
  DefCam, DefDio, DefGmes, DefPocb, DefPG, DefMotion, MotionCtl, DioCtl,
  About, CamComm, CommonClass, LogIn, DownloadBmpPg, DownloadFwPg, DownloadFwSpi,
  HandBCR, LogicPocb, {ModelDownload,} NGMsg, PwdChange, JigControl,
  ExLightCtl, //2019-04-17 ExLight
  DefEfu, EfuCtl,     //2019-05-02 EFU
  DefIonizer, IonizerCtl, //2019-08-23 Ionizer
  DfsFtpPocb,
  SystemSetup, SwitchBtn,
  CustomFrame, DiSimul,

{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHV2)}
  ModelInfo_A2CHv2, ModelSelect_A2CHv2, Mainter_A2CHv2, Test1Ch_A2CHv2, Frame_SystemAlarmAV1, Frame_SystemAlarmAV2,
{$ELSEIF Defined(POCB_A2CHv3)}
  ModelInfo_A2CH,   ModelSelect_A2CH,   Mainter_A2CH,   Test1Ch_A2CH,   Frame_SystemAlarmAV3, DefRobot, RobotCtl,
{$ELSEIF Defined(POCB_A2CHv4)}
  ModelInfo_A2CH,   ModelSelect_A2CH,   Mainter_A2CH,   Test1Ch_A2CH,   Frame_SystemAlarmAV4, DefRobot, RobotCtl,
{$ELSEIF Defined(POCB_ATO)}
  ModelInfo_ATO,    ModelSelect_A2CH,   Mainter_A2CH,   Test1Ch_A2CH,   Frame_SystemAlarmAV4, DefRobot, RobotCtl,
{$ELSEIF Defined(POCB_GAGO)}
  ModelInfo_GAGO,   ModelSelect_A2CH,   Mainter_A2CH,   Test1Ch_A2CH,   Frame_SystemAlarmAV4, DefRobot, RobotCtl,
{$ENDIF}

{$IFDEF SITE_LENSVN}
  LensHttpMes,
{$ELSE}
  GMesCom,
{$ENDIF}

{$IFDEF REMOTE_UPDATE}
  DefAimf, UpdateSupport,
{$ENDIF}
  UdpServerPocb, UserID, POCBClass, Alarm, EMSAlarmMsg, SafetyAlarmMsg, UserUtils;

type
  TfrmMain = class(TForm)
    // MainFrm:Header(ToolBar) ----------
    RzToolBarMainFrm							: TRzToolbar;				// Buttons ----------
    btnLogIn 											: TRzToolButton;
    btnModelChange								: TRzToolButton;
    btnModel											: TRzToolButton;
    btnStation										: TRzToolButton;
    btnMaint											: TRzToolButton;
    btnInit												: TRzToolButton;
    btnExit												: TRzToolButton;
    rzspcrHeader1									: TRzSpacer;
    rzspcrHeader2									: TRzSpacer;
    rzspcrHeader3									: TRzSpacer;
    rzspcrHeader4									: TRzSpacer;
    rzspcrHeader5									: TRzSpacer;
    rzspcrHeader6									: TRzSpacer;
    pnlAssyPocbInfo: TPanel;           // ModelName ---------
    // MainFrm:Left(Info) ---------------
    RzpnlMainFrmInfo							: TRzPanel;
    RzgrpSystemInfo								: TRzGroupBox;      // SysInfo ----------
    RzpnlSysinfoCameraTitle				: TRzPanel;
  //ledSysinfoCam1Clint           : ThhALed;
  //ledSysinfoCam1Server          : ThhALed;
  //ledSysinfoCam2Clint           : ThhALed;
  //ledSysinfoCam2Server          : ThhALed;
    pnlSysinfoCam1ClintStatus     : TPanel;
    pnlSysinfoCam1ServerStatus    : TPanel;
    pnlSysinfoCam2ClintStatus     : TPanel;
    pnlSysinfoCam2ServerStatus    : TPanel;
    RzpnlSysinfoRobotTitle: TRzPanel;
    ledSysinfoRobot1Modbus: ThhALed;
    ledSysinfoRobot2Modbus: ThhALed;
    pnlSysinfoRobot1Modbus: TPanel;
    pnlSysinfoRobot2Modbus: TPanel;
    pnlSysinfoRobot1StatusMsg: TPanel;
    pnlSysinfoRobot2StatusMsg: TPanel;
    RzpnlSysinfoYaxisTitle        : TRzPanel;
    ledSysinfoYaxis1Motor         : ThhALed;
    ledSysinfoYaxis2Motor         : ThhALed;
    pnlSysinfoYaxis1Status        : TPanel;
    pnlSysinfoYaxis2Status        : TPanel;
    pnlSysinfoYaxis1Servomsg      : TPanel;
    pnlSysinfoYaxis2Servomsg      : TPanel;
{$IFDEF HAS_MOTION_TILTING}
    RzpnlSysinfoTasixTitle        : TRzPanel;
    ledSysinfoTaxis1Motor         : ThhALed;
    ledSysinfoTaxis2Motor         : ThhALed;	
    pnlSysinfoTaxis1Status        : TPanel;
    pnlSysinfoTaxis2Status        : TPanel;
    pnlSysinfoTaxis1Servomsg      : TPanel;			
    pnlSysinfoTaxis2Servomsg      : TPanel;		
{$ENDIF}
    RzpnlSysinfoEfuTitle          : TRzPanel;         // SysInfo:EFU
    ledSysInfoEfuLv32Conn         : ThhALed;
    pnlSysinfoEfuLv32Conn         : TPanel;
    ledSysinfoEfuCh1              : ThhALed;
    pnlSysinfoEfuCh1Alarm         : TPanel;
    ledSysinfoEfuCh2              : ThhALed;
    pnlSysinfoEfuCh2Alarm         : TPanel;
    RzpnlSysinfoRcbTitle					: TRzPanel;         // SysInfo:RCB: RCB1 & RCB2
    ledSysinfoRcb1								: ThhALed;
    ledSysinfoRcb2								: ThhALed;
    pnlSysinfoRcb1								: TPanel;
    pnlSysinfoRcb2								: TPanel;
    RzpnlSysinfoIonizerTitle      : TRzPanel;      		// SysInfo:Ionizer1 & Ionizer2
    ledSysinfoIon1                : ThhALed;
    ledSysinfoIon2                : ThhALed;
    pnlSysinfoIon1: TPanel;
    pnlSysinfoIon2                : TPanel;
    RzpnlSysinfoHandBcrTitle			: TRzPanel;      		// SysInfo:HandBCR
    ledSysinfoHandBcr							: ThhALed;
    pnlSysinfoHandBcr							: TPanel;
    RzpnlSysinfoExLightTitle      : TRzPanel;         // SysInfo:ExLight
    ledSysinfoExLight             : ThhALed;
    pnlSysinfoExLight             : TPanel;
    RzpnlSysinfoGmesTitle					: TRzPanel;         // SysInfo:GMES
    ledSysinfoGmes								: ThhALed;
    pnlSysinfoGmes								: TPanel;
    RzpnlSysinfoEasTitle: TRzPanel;
    ledSysinfoEAS: ThhALed;
    pnlSysinfoEAS: TPanel;
    RzpnlSysinfoDfsTitle          : TRzPanel;         // SysInfo:DFS
    ledSysinfoDfs                 : ThhALed;
    pnlSysinfoDfs                 : TPanel;
    RzpnlSysinfoShareFolderTitle	: TRzPanel;    			// SysInfo:ShareFolder
    ledSysinfoSharefolder					: ThhALed;
    pnlSysinfoShareFolder					: TPanel;
    // MainFrm:Left(GMES) ---------------
    RzgrpGMES											: TRzGroupBox;
    RzpnlGmesStationTitle					: TRzPanel;
    RzpnlGmesUserIdTitle					: TRzPanel;
    RzpnlGmesUserNameTitle				: TRzPanel;
    pnlGmesStation								: TPanel;
    pnlGmesUserId									: TPanel;
    pnlGmesUserName								: TPanel;
    // MainFrm:Left(ModelInfo) ----------
    RzgrpModelInfo								: TRzGroupBox;
    RzpnlModelResTitle						: TRzPanel;
    RzpnlModelPatGrpTitle					: TRzPanel;
    RzpnlModelVolTitle						: TRzPanel;
    RzpnlModelVolVccTitle					: TRzPanel;
    RzpnlModelVolVddTitle: TRzPanel;
    pnlModelResolutionCh1: TPanel;
    pnlModelPatGrpCh1: TPanel;
    pnlModelVolVccCh1: TPanel;
    pnlModelVolVddCh1: TPanel;
    RzpnlModelBcrLenTitle         : TRzPanel;
    pnlModelBcrLenCh1: TPanel;
    RzpnlRobotHomeTitle: TRzPanel;
    RzpnlModelRobot1CoordTitle: TRzPanel;
    RzpnlModelYaxisCamPosTitle: TRzPanel;
    RzpnlModelYaxisPosTitle: TRzPanel;
    RzpnlModelYaxisLoadPosTitle: TRzPanel;
    pnlRobot1HomeCoordX: TPanel;
    pnlModelYaxis1CamPos: TPanel;
    pnlModelYaxis2CamPos: TPanel;
    pnlModelYaxis1LoadPos: TPanel;
    pnlModelYaxis2LoadPos: TPanel;
{$IFDEF HAS_MOTION_TILTING}
    RzpnlModelTaxisPosTitle: TRzPanel;
    RzpnlModelTaxisFlatPosTitle: TRzPanel;
    RzpnlModelTaxisUpPosTitle: TRzPanel;
    pnlModelTaxis1FlatPos: TPanel;
    pnlModelTaxis2FlatPos: TPanel;
    pnlModelTaxis1UpPos: TPanel;
    pnlModelTaxis2UpPos: TPanel;
{$ENDIF}
{$IFDEF DFS_HEX}
    // MainFrm:Left(DFS Info) ----------
    RzgrpDFS                   : TRzGroupBox;
    RzpnlCombiProcessNoTitle   : TRzPanel;
    RzpnlCombiModelRCPTitle    : TRzPanel;
    RzpnlCombiRouterNoTitle    : TRzPanel;
    pnlCombiModelRCPCh1        : TPanel;
    pnlCombiRouterNoCh1        : TPanel;
    pnlCombiProcessNoCh1       : TPanel;
    pnlCombiModelRCPCh2        : TPanel;
    pnlCombiRouterNoCh2        : TPanel;
    pnlCombiProcessNoCh2       : TPanel;
{$ENDIF}
     // MainFrm:Left(DIO) ----------
    RzgrpDIO											: TRzGroupBox;
    // MainFrm:StatusBar -----------
    RzstsbrMainFrmx								: TRzStatusBar;
    stsbrStatusClock							: TRzClockStatus;
    stsbrStatusMemTitle						: TRzStatusPane;
    stsbrStatusMemUsage						: TRzResourceStatus;
    stsbrStatusKeyTitle						: TRzStatusPane;
    stsbrStatusKeyValue						: TRzKeyStatus;
    // MainFrm:Alarm -----------
    btnShowSatetyAlarmMotion      : TBitBtn;  //for GrpSystemAlarms
    btnShowAlarm                  : TBitBtn;  //for Alarm.dfm
    btnStopBuzzer: TBitBtn;	
    // MainFrm:Timer ----------
    tmrDisplayOff									: TTimer;
    tmrDisplayTestForm						: TTimer;
    tmrZAxisError									: TTimer;
    tmrAutoHomeSearch             : TTimer;
    tmrZAxisModelPos: TTimer;
    tmrYAxisModelPos: TTimer;

{$IFDEF HAS_MOTION_TILTING}
    tmrTAxisModelPos: TTimer;
{$ENDIF}
    tmrTowerLampRedOnOff: TTimer;	
    tmrEQCC												: TTimer;		// for MES
    tmrMESConn                    : TTimer;   // for MES
    tmrCamConnCheck               : TTimer;
    // MainFrm:Etc ----------
    RzOpenDialog1									: TRzOpenDialog;
    IMGMain												: TImageList;
    imgCheckBox										: TImage;
    ilFlag												: TImageList;
    rzspcrHeader0									: TRzSpacer;
    // MainFrm: GrpSystemAlarms Panel
    btnClosePnlSystemAlarm        : TLabel;
    GrpMotionControl: TGroupBox;
    GrpSystemMessages: TGroupBox;
    //
    PnlAlarmMotionControl: TAdvPanel;	
    lblAlarmMotionStCh1: TLabel;
    lblAlarmMotionStCh2: TLabel;
    lblAlarmRobotSt: TLabel;
    pnlAlarmRobotStCh1: TPanel;
    pnlAlarmRobotStCh2: TPanel;
    lblAlarmMotionStY: TLabel;
    pnlAlarmMotionStCh1Y: TPanel;
    pnlAlarmMotionStCh2Y: TPanel;	
{$IFDEF HAS_MOTION_TILTING}
    lblAlarmMotionStT: TLabel;	
    pnlAlarmMotionStCh1T: TPanel;
    pnlAlarmMotionStCh2T: TPanel;
{$ENDIF}
    // MainFrm: GrpSystemNgMsg Panel
    GrpSystemNgMsg: TGroupBox;
    lblSystemNgMsg: TLabel;
    lblSystemNgClose: TLabel;
    lblSystemNgHeader: TLabel;
    btnAlarmMotionCh1: TLabel;
    btnAlarmMotionCh2: TLabel;
    btnAlarmMotionAll: TRzButton;
    btnShowWorkingMsg: TRzButton;
    mmAlarmOpMsg: TRichEdit;
    lblHomeSearchMovePosTitle: TLabel;
    pnlSysinfoUseGIB: TPanel;
    tmrPowerSaving: TTimer;
    pnlRobot1HomeCoordY: TPanel;
    pnlRobot1HomeCoordZ: TPanel;
    pnlRobot2HomeCoordX: TPanel;
    pnlRobot2HomeCoordY: TPanel;
    pnlRobot2HomeCoordZ: TPanel;
    RzpnlModelRobot2CoordTitle: TRzPanel;
    pnlRobot1HomeCoordRx: TPanel;
    pnlRobot1HomeCoordRy: TPanel;
    pnlRobot1HomeCoordRz: TPanel;
    pnlRobot2HomeCoordRx: TPanel;
    pnlRobot2HomeCoordRy: TPanel;
    pnlRobot2HomeCoordRz: TPanel;
    pnlModelResolutionCh2: TPanel;
    pnlModelPatGrpCh2: TPanel;
    pnlModelVolVccCh2: TPanel;
    pnlModelVolVddCh2: TPanel;
    pnlModelBcrLenCh2: TPanel;
    ledSysinfoRobot1ListenNode: ThhALed;
    pnlSysinfoRobot1ListenNode: TPanel;
    ledSysinfoRobot2ListenNode: ThhALed;
    pnlSysinfoRobot2ListenNode: TPanel;
    btnAlarmRobotMoveModel: TRzButton;
    pnlRobot1ModelCoordRx: TPanel;
    pnlRobot1ModelCoordRy: TPanel;
    pnlRobot1ModelCoordRz: TPanel;
    pnlRobot2ModelCoordRx: TPanel;
    pnlRobot2ModelCoordRy: TPanel;
    pnlRobot2ModelCoordRz: TPanel;
    pnlRobot1ModelCoordX: TPanel;
    pnlRobot1ModelCoordY: TPanel;
    pnlRobot1ModelCoordZ: TPanel;
    pnlRobot2ModelCoordX: TPanel;
    pnlRobot2ModelCoordY: TPanel;
    pnlRobot2ModelCoordZ: TPanel;
    RzpnlSysInfoRobot1CoordTitle: TRzPanel;
    RzpnlSysInfoRobot2CoordTitle: TRzPanel;
    RzpnlRobotModelTitle: TRzPanel;
    tmrAutoRobotMoveModel: TTimer;
    pnlModelBcrChkCh1: TPanel;
    pnlModelBcrMainCh1: TPanel;
    pnlModelBcrChkCh2: TPanel;
    pnlModelBcrMainCh2: TPanel;
    ledSysinfoEfuCh1_2: ThhALed;
    ledSysinfoEfuCh2_2: ThhALed;
    pnlSysinfoEfuCh1_2Alarm: TPanel;
    pnlSysinfoEfuCh2_2Alarm: TPanel;
    ledSysinfoIon1_2: ThhALed;
    ledSysinfoIon2_2: ThhALed;
    pnlSysinfoIon1_2: TPanel;
    pnlSysinfoIon2_2: TPanel;
    tmrIdlePmModeLoginPopup: TTimer;
    Btn_M_INFO: TBitBtn;

    // procedure/function: Create/Destroy/init/.. ----------
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CMStyleChanged(var Message: TMessage); message CM_STYLECHANGED;
    // procedure/function: GUI(Menu Button Action) ---------
    procedure btnLogInClick(Sender: TObject);
    procedure btnModelChangeClick(Sender: TObject);
    procedure btnModelClick(Sender: TObject);
    procedure btnStationClick(Sender: TObject);
    procedure btnMaintClick(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnKoreanClick(Sender: TObject);
    procedure btnVietnamClick(Sender: TObject);
    procedure btnShowSatetyAlarmMotionClick(Sender: TObject);
    procedure btnClosePnlSystemAlarmClick(Sender: TObject);
    procedure btnStopBuzzerClick(Sender: TObject);   //2019-03-29
    procedure btnAlarmMotionCh1Click(Sender: TObject);
    procedure btnAlarmMotionCh2Click(Sender: TObject);
    procedure btnAlarmMotionAllClick(Sender: TObject);
    procedure lblSystemNgCloseClick(Sender: TObject);
    procedure btnAlarmRobotMoveModelClick(Sender: TObject); //TBD:A2CHv3:ROBOT?
    // procedure/function: Sub (Common) --------------------
    // procedure/function: ---------------------------------
    // procedure/function: GMES ----------------------------
    // procedure/function: GUI(Pop-up) ---------------------
    procedure btnShowAlarmClick(Sender: TObject);
    procedure UpdateAlarmStatus(nAlarmNo: Integer; bIsOn: Boolean; sMsg: string = '');
    function  IsHighPriorityAlarmOn(nAlarmNo : Integer): Boolean;  //2019-03-29
    // procedure/function: Timer ---------------------------
    procedure tmrDisplayTestFormTimer(Sender: TObject);
    procedure tmrAutoHomeSearchTimer(Sender: TObject);
    procedure tmrYAxisModelPosTimer(Sender: TObject);  //F2CH|A2CHv2
{$IFDEF HAS_MOTION_CAM_Z}
    procedure tmrZAxisModelPosTimer(Sender: TObject);
{$ENDIF}
{$IFDEF HAS_MOTION_TILTING}
    procedure tmrTAxisModelPosTimer(Sender: TObject);  //F2CH
{$ENDIF}
//{$IFDEF HAS_ROBOT_CAM_Z}
    procedure tmrAutoRobotMoveModelTimer(Sender: TObject);
//{$ENDIF}
    procedure tmrEQCCTimer(Sender: TObject);
    procedure tmrMESConnTimer(Sender: TObject);
    procedure tmrCamConnCheckTimer(Sender: TObject); //2018-12-13
    procedure tmrTowerLampRedOnOffTimer(Sender: TObject); //2019-04-16 (Safety:TowerLampRed)
    procedure DoMotionYaxisHomeSearch(nCh: Integer);
{$IFDEF HAS_MOTION_CAM_Z}
    procedure DoMotionZaxisHomeSearch(nCh: Integer);
{$ENDIF}
{$IFDEF HAS_MOTION_TILTING}
    procedure DoMotionTaxisHomeSearch(nCh: Integer);
{$ENDIF}
    // procedure/function: WMCopyData
    procedure WMCopyData(var Msg : TMessage); message WM_COPYDATA;
    procedure btnShowWorkingMsgClick(Sender: TObject);
    procedure tmrPowerSavingTimer(Sender: TObject);
    procedure tmrIdlePmModeLogInPopUpTimer(Sender: TObject); //2023-10-12 IDLE_PMMODE_LOGIN_POPUP
    procedure pnlAssyPocbInfoDblClick(Sender: TObject);
    procedure Btn_M_INFOClick(Sender: TObject);
    procedure tmrZAxisErrorTimer(Sender: TObject);
  private
    PnlDioInTitle 	: TPanel;
    PnlDioOutTitle 	: TPanel;
    ledDioIn  			: array of TTILed;
    ledDioOut 			: array of TTILed;
    frmTest1Ch     	: array[DefPocb.JIG_A..DefPocb.JIG_MAX] of TfrmTest1Ch;

    // MainFrm - System Option Status (MES Online/Offline, ProcMask) //2023-09-20
    m_nHeightSysGrp : Integer;
    pnlMainFrmSysStGrp     : TPanel;  //2023-09-20
    pnlMainSysMesOffline   : TPanel;  //2023-09-20
{$IFDEF SITE_LENSVN}
    pnlMainSysProcMaskGrp   : TPanel; //2023-09-20
    pnlMainSysProcMaskSkip  : TPanel; //2023-09-20
    cbMainSysProcMaskSkip   : TRzCheckBox;//2023-09-20
{$ENDIF}
    tmrMainFrmSysStBlink : TTimer; //2023-09-20
    m_nIdlePmModeLogInPopUpTimerElapseCnt : Integer; //2023-10-12 IDLE_PMMODE_LOGIN_POPUP
    //
    Fframe_SystemArm : TCustomFrame;
    m_sUserIdBeforeInitial, m_sUserNameBeforeInitial : string; //2023-07-01

    // procedure/function: Create/Destroy/init/.. ----------
    function  SystemAlarmGuiFactory : TCustomFrame;
    procedure CreateClassData(bInitMotor : Boolean = True);
    procedure FreeAll(bInitMotor: Boolean = True; bInitRobot: Boolean = True);
    procedure InitAll(bInitMotor: Boolean = True; bInitRobot: Boolean = True);
    procedure InitForm;
    procedure MakeMainFrmDIO;
    procedure MakeMainFrmSysStGrp; //2023-09-20
    procedure cbMainSysProcMaskSkipClick(Sender: TObject); //2023-09-20
    // procedure/function: Sub (Common) --------------------
    procedure InitWindowUIType;
    function CheckPgRun : Boolean; // True : Run, False : Pg Stop.
    function  DisplayLogIn : Integer;
    procedure DisplayModelInfo;
    procedure SetLanguageMain(nIdx : Integer);
    procedure SetDioFlow(InDio, OutDio: ADioStatus);
    // procedure/function: ---------------------------------
    procedure InitMainFrmSystemInfo(bInitMotor : Boolean = True);
    procedure ShowHandBcrStatus(bConnected : Boolean; sMsg : string);
    procedure ShowExLightStatus(bConnected : Boolean; sMsg : string);  //2019-04-17 ExLight
    procedure ShowEfuStatus(nConnected : Integer; sMsg : string; nIcuId: Integer = -1);
    procedure ShowMainFrmSysStatus; //2023-09-20
    procedure UpdateMainFrmMesStatus(mesStatus: enumMesStatus; bMesLoginFailed: Boolean=False); //2023-09-20
    procedure tmrMainFrmSysStBlinkTimer(Sender: TObject); //2023-09-20
    procedure ShowMainFrmModelInfo;
    procedure ShowCamConnStatus(nCam: Integer; tcpPort: Integer; nConnect: Integer);  //2018-12-14
    procedure ShowCamClintConnStatus(nCam: Integer; nConnect: Integer);  //2018-12-14
    procedure ShowCamServerConnStatus(nCam: Integer; nConnect: Integer); //2018-12-14
    procedure ShowDioConnSt(nMode, nParam: Integer; sMsg: String);
    procedure ShowDioOutReadSt(OutDio: ADioStatus);
    procedure ShowMotionStatus(nMotionId: Integer; nMode, nErrCode: Integer; sMsg: String);
    {$IFDEF HAS_ROBOT_CAM_Z}
    procedure ShowRobotStatus(nRobot: Integer; nMode, nErrCode: Integer; sMsg: String); //A2CHv3:ROBOT
    procedure SendRobotMoveCmd(nRobot: Integer; nCmdId: Integer);                       //A2CHv3:ROBOT
    {$ENDIF}
    // procedure/function: GMES ----------------------------
    procedure InitGmes;
    procedure OnMesMsg(nMsgType, nCh: Integer; bError: Boolean; sMsg: string);
{$IFDEF DFS_HEX}
    // procedure/function: DFS_FTP -------------------------
    procedure InitDfs;
    procedure ShowDfsConnectSts(bIsConnect : Boolean);
{$ENDIF}
    // procedure/function: GUI(Pop-up) ---------------------
    procedure ShowAlarmMotionControl(nAlarmNo: Integer; bIsOn: Boolean);
    procedure ShowNgMessage(sMessage: string; bForce: Boolean=False);
    procedure ShowEMSAlarmMsg(sMessage: string);
    procedure ShowSafetyAlarmMsg(nAlarmNo: Integer); //2019-03-29
    // procedure/function: Timer ---------------------------
    // procedure/function: WMCopyData ----------------------
    //OLD(METHODS)----------------
    procedure ShowModelButtons(bEnable : Boolean);

    {$IFDEF REMOTE_UPDATE}
    procedure SetDllStatus(nMode : Integer; var nRet : Integer;sMsg : string);
    procedure AutoMc(sModelName : string);
    procedure InitAutoUpdate;
  //procedure DestroyInternalClass;
    {$ENDIF}

  public
    m_bExitOrInit : Boolean; //2019-01-16
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  FileMapObj : THandle;

implementation

{$R *.dfm}
//{$r+} // memory range check.
uses
  OtlTaskControl, OtlParallel, Maintenance_Info;

{$IFDEF REMOTE_UPDATE}
procedure TfrmMain.AutoMc(sModelName: string);  //TBD:REMOTE_UPDATE? 1CG2PANEL?
var
{ // IMD_GB
  sBeforeModel : string;
  i : integer;
}
  nJig, nCh : Integer;
begin
{ // IMD_GB
  sBeforeModel := Common.SystemInfo.TestModel;
  Common.SystemInfo.TestModel := sModelName;
  Common.SaveSystemInfo;

  for i := DefCommon.CH1 to DefCommon.MAX_CH do common.MLog(i,'Auto M/C');
  Common.LoadModelInfo(Common.SystemInfo.TestModel);
  InitialAll(True,False);
}
  DisplayModelInfo;
  for nJig := DefPocb.JIG_A to DefPocb.JIG_MAX do begin
    frmTest1Ch[nJig{TBD? old:DefPocb.JIG_B}].UpdatePtList(Self.Handle);;  //TBD:A2CH? PatList?    //TBD:A2CHv3:MULTIPLE_MODEL?
  end;

  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    //TBD:MERGE? NOT-USED? Common.MakeModelData(nCh, Common.SystemInfo.TestModel[nCh]);  //TBD? (MakeModelData에 대한 Return값 처리가 없는데...)
    if Logic[nCh] = nil then Continue;    //2018-11-15 (Exception 방지?)
    Common.SendModelData(nCh);
  end;
  CameraComm.SetModelSet;
  Sleep(1000);  //2019-03-29
  InitAll(False);      //2019-03-29
end;
{$ENDIF}

//******************************************************************************
// procedure/function: Create/Destroy/init/..
//******************************************************************************

procedure TfrmMain.CMStyleChanged(var Message: TMessage);
begin
  Self.WindowState := wsMaximized;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  nRet   : Integer;
  sDebug : string;
  sErrLogHeader, sErrLogData : string;
begin
  mmAlarmOpMsg.Perform(EM_EXLIMITTEXT, 0, $FFFF); //2019-04-03 TBD:ALARM:UI:RichEdit?
  m_bExitOrInit := False;  //2019-01-16

  m_sUserIdBeforeInitial   := ''; //2023-07-01
  m_sUserNameBeforeInitial := ''; //2023-07-01

  //
  Common := TCommon.Create;
  Common.SetEdModel2TestModel;

  {$IFDEF REMOTE_UPDATE}
  Sleep(1000);
  UsObject := TUpdateSupports.Create(DefAimf.MSG_TYPE_INSPECT);
  UsObject.OnCallBackAimf := SetDllStatus;
  UsObject.RunSubProgram;
  {$ENDIF}

  Fframe_SystemArm := SystemAlarmGuiFactory;
  Fframe_SystemArm.Parent := PnlAlarmMotionControl;
  Fframe_SystemArm.SendToBack;

{$IFDEF SITE_LENSVN}
  if Trim(Common.SystemInfo.LensMesUrlIF) <> '' then begin
    nRet := DisplayLogIn;
    if nRet = mrCancel then begin
      Application.ShowMainForm := False;
      Common.Free;
      Common := nil;
      Application.Terminate;
      Exit;
    end
    else begin
      if UpperCase(Common.m_sUserId) <> 'PM' then begin
        if not (DongaGmes is TGmes) then begin
          InitGmes;
        end;
        DongaGmes.MesUserId  := Common.m_sUserId;
        DongaGmes.MesUserPwd := Common.m_sUserPwd;
        DongaGmes.MesUserName:= '';
      //Common.ThreadTask( procedure begin
          DongaGmes.SendLoginPost(DongaGmes.MesUserId, DongaGmes.MesUserPwd);
      //end);
      end;
    end;
  end;
{$ELSE} //LGD-MES
  if Trim(Common.SystemInfo.MES_ServicePort) <> '' then begin
    {$IFDEF REMOTE_UPDATE}
    Common.Delay(1000); // Added by Clint 2023-01-10 오후 6:42:44   Send Message로 AIMF에서 정보 읽어 와야 함.
    if UsObject.IsAutoLogin = DefAimf.AIMF_IDX_LOG_PMMODE then begin
      Common.m_sUserId := 'PM';
      ShowMainFrmMesUpdate(MesStatus_OFFLINE,False{bMesLoginFailed});
    end
    else begin
    {$ENDIF}
    nRet := DisplayLogIn;
    if nRet = mrCancel then begin
      Application.ShowMainForm := False;
      {$IFDEF REMOTE_UPDATE}
      UsObject.TurnOffUpdateSw;
      {$ENDIF}
      Common.Free;
      Common := nil;
      {$IFDEF REMOTE_UPDATE}
      UsObject.Free;
      UsObject := nil;
      {$ENDIF}
      Application.Terminate;
      Exit;
    end
    else begin
      if Common.m_sUserId <> 'PM' then begin
        if not (DongaGmes is TGmes) then begin
          InitGmes;
        end
        else begin
          DongaGmes.MesUserId := Common.m_sUserId;
          if not DongaGmes.MesEayt then DongaGmes.SendHostUchk
          else                          DongaGmes.SendHostEayt;
        end;
      end;
    end;
    {$IFDEF REMOTE_UPDATE}
    end;
    {$ENDIF}
  end;
{$ENDIF}

{$IFDEF DFS_HEX}
  InitDfs;
{$ENDIF}
  //
  sDebug := '#################### START(EXE): ' + Common.m_sExeVerNameLog;
  Common.MLog(DefPocb.CH_1,sDebug);
  Common.MLog(DefPocb.CH_2,sDebug);
  Common.MLog(DefPocb.SYS_LOG,sDebug);

  //
  sErrLogHeader := 'DateTime,AlarmNo,AlarmName,DIO#,ON/OFF'; //2022-12-06 ERROR_LOG
  sErrLogData   := FormatDateTime('yyyy-mm-dd hh:mm:ss.zzz',Now) + ',---,EXE_START,-,--';
  Common.MakeErrorLog(sErrLogHeader,sErrLogData);

  Self.WindowState := wsMaximized;

  {$IFDEF SITE_LENSVN}
//btnShowWorkingMsg.Caption := btnShowWorkingMsg.Caption + #13#10 + '
  {$ENDIF}

  CreateClassData;
  // Init GUI
  InitForm;
  //
  DisplayModelInfo;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  sMsg : string;
  sErrLogHeader, sErrLogData : string;
begin
  {$IFDEF REMOTE_UPDATE}
  if (UsObject <> nil) and UsObject.CloseMainApp then begin
    //
    {$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)} //FEATURE_ERROR_LOG
    sErrLogHeader := 'DateTime,AlarmNo,AlarmName,DIO#,ON/OFF'; //2022-12-06 ERROR_LOG
    sErrLogData   := FormatDateTime('yyyy-mm-dd hh:mm:ss.zzz',Now) + ',---,EXE_START,-,--';
    Common.MakeErrorLog(sErrLogHeader,sErrLogData);
	  {$ENDIF}
    //
    FreeAll;
    //
    Sleep(1000);
    CanClose := True;
    CloseHandle(FileMapObj);
    //
    { IMD_GB
    sDebug := '[Click Event] Terminate IMD_GB Program';
    for i := DefCommon.CH1 to DefCommon.MAX_CH do common.MLog(i,sDebug);
    Common.TaskBar(False);
    InitWithDio(False);
    for i := 0 to 1000 do begin
      if Common = nil then Break;
      Sleep(100);
    end;
    CanClose := True;
    }
    //
    Exit;
  end;
  {$ENDIF}

  if Common = nil then Exit;
  case Common.SystemInfo.Language of
    DefPocb.LANGUAGE_KOREA : begin
      sMsg := #13#10 + '종료 하시겠습니까?';
    end;
    DefPocb.LANGUAGE_VIETNAM : begin
      sMsg := #13#10 + 'bạn có muốn thóat chương trình không?';
      {$IFDEF SITE_LENSVN}
      //TBD?
      {$ENDIF}
    end
    else begin
      sMsg := #13#10 + 'Are you sure you want to Exit Program?';
    end;
  end;

  if MessageDlg(sMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    //
    {$IFDEF REMOTE_UPDATE}
    UsObject.TurnOffUpdateSw;
    {$ENDIF}
    //
    sErrLogHeader := 'DateTime,AlarmNo,AlarmName,DIO#,ON/OFF'; //2022-12-06 ERROR_LOG
    sErrLogData   := FormatDateTime('yyyy-mm-dd hh:mm:ss.zzz',Now) + ',---,EXE_START,-,--';
    Common.MakeErrorLog(sErrLogHeader,sErrLogData);
    //
    tmrMainFrmSysStBlink.Free; //2023-09-20
    FreeAll;
    //
    Sleep(1000);
    CanClose := True;
    CloseHandle(FileMapObj);
  end
  else begin
    CanClose := False;
  end;
end;

function  TfrmMain.SystemAlarmGuiFactory : TCustomFrame;
var
  frame : TCustomFrame;
begin
  frame := TFrame_SystemArmAV.Create(Self);
  Result := frame;
end;

procedure TfrmMain.CreateClassData(bInitMotor : Boolean = True);
var
  i : Integer;
begin
  InitWindowUIType;
  // for Alarm Table
  Common.MakeAlarmList;
//Common.MakeDpc2GpcNgCodes; //2019-04-18 NGCODE:CAM
  //
  InitMainFrmSystemInfo(bInitMotor);  //2019-08-26

  // UDP Server for PG Comm
  if (UdpServer <> nil) then begin
    UdpServer.Free;
    UdpServer := nil;
  end;
  UdpServer := TUdpServerPocb.Create(Self.Handle, DefPocb.PG_CNT);

  // HandBCR
  if (DongaHandBcr <> nil) then begin
    DongaHandBcr.Free;
    DongaHandBcr := nil;
  end;
  DongaHandBcr := TSerialBcr.Create(Self);
  DongaHandBcr.OnRevBcrConn := ShowHandBcrStatus;
  DongaHandBcr.ChangePort(Common.SystemInfo.Com_HandBCR);

  //2019-04-17 ExLight
  if (DongaExLight <> nil) then begin
    DongaExLight.AllOff(-1{Cam1&Cam2});
    Sleep(100);
    DongaExLight.Free;
    DongaExLight := nil;
  end;
  DongaExLight := TSerialExLight.Create(Self);
  DongaExLight.OnRevExLightConn := ShowExLightStatus;
  DongaExLight.ChangePort(Common.SystemInfo.Com_ExLight);
  Sleep(100);
  DongaExLight.AllOff(-1{Cam1&Cam2});

  //2019-05-02 EFU
  if (DongaEfu <> nil) then begin
    DongaEfu.Free;
    DongaEfu := nil;
  end;
  DongaEfu := TSerialEfu.Create(Self.Handle);
  DongaEfu.OnRevEfuConn := ShowEfuStatus;
  DongaEfu.ChangePort(Common.SystemInfo.Com_Efu);

  //2019-08-23 Inoizer
  for i := 0 to DefIonizer.ION_MAX do begin
    if DaeIonizer[i] <> nil then begin
      DaeIonizer[i].Free;
      DaeIonizer[i] := nil;
    end;
  end;

  if (DongaPOCB <> nil) then begin
    DongaPOCB.Free;
    DongaPOCB := nil;
  end;

  DongaPOCB := TPOCB.Create;
  tmrPowerSaving.Enabled := Common.SystemInfo.ScreenSaverTime <> 0;

  tmrIdlePmModeLoginPopup.Enabled := True; //2023-10-12 IDLE_PMMODE_LOGIN_POPUP

  // Timer
  tmrDisplayTestForm.Interval := 100;  //2019-01-16 100->500 TBD?
  tmrDisplayTestForm.Enabled  := True;
  tmrEQCC.Enabled := False;
end;

procedure TfrmMain.FreeAll(bInitMotor: Boolean = True; bInitRobot: Boolean = True); //TBD:A2CHv3:ROBOT?
var
  i : Integer;
begin
    DongaHandBcr.Free;
    DongaHandBcr := nil;
  //2019-04-17 ExLight
  if (DongaExLight <> nil) then begin
    DongaExLight.AllOff(-1{Cam1&Cam2});
    Sleep(100);
    DongaExLight.Free;
    DongaExLight := nil;
  end;
  if (DongaEfu <> nil) then begin
    DongaEfu.Free;
    DongaEfu := nil;
  end;

  tmrPowerSaving.Enabled := False;
  if DongaPOCB <> nil then begin
    DongaPOCB.Free;
    DongaPOCB := nil;
  end;
  tmrIdlePmModeLogInPopUp.Enabled := False; //2023-10-12 IDLE_PMMODE_LOGIN_POPUP

  //2019-08-23 Inoizer
  for i := 0 to DefIonizer.ION_MAX do begin
    if DaeIonizer[i] <> nil then begin
      DaeIonizer[i].Free;
      DaeIonizer[i] := nil;
    end;
  end;

  if DongaDio <> nil then begin
    DongaDio.Free;
    DongaDio := nil;
  end;

  if bInitMotor then begin
    if DongaMotion <> nil then begin
      DongaMotion.Free;
      DongaMotion := nil;
    end;
  end;

  if Common.SystemInfo.HasDioYAxisMC then begin
    if DongaMotion <> nil then begin
      DongaMotion.Free;
      DongaMotion := nil;
    end;
  end;

{$IFDEF HAS_ROBOT_CAM_Z}
  if bInitRobot then begin  //TBD:A2CHv3:ROBOT?
    if DongaRobot <> nil then begin
      DongaRobot.Free;
      DongaRobot := nil;
    end;
  end;
{$ENDIF}

  if UdpServer <> nil then begin
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin //2022-08-01
      if Pg[i].m_ABindingSpi <> nil then Pg[i].SendSpiPowerOnOffReq(0{Off});
      if Pg[i].m_ABindingPg  <> nil then Pg[i].SendPgPowerReq(0{Off});
    end;
    Sleep(10);
    UdpServer.Free;
    UdpServer := nil;
  end;

  if CameraComm <> nil then begin
    tmrCamConnCheck.Enabled := False;
    CameraComm.Free;    //2019-01-09 TBD:CAM? (Initial시 Cam Connection 유지????) 2019-01-16 (유지하지 않음)
    CameraComm := nil;  //2019-01-09 TBD:CAM? (Initial시 Cam Connection 유지????) 2019-01-16 (유지하지 않음)
  end;
{$IFDEF DFS_HEX}
  if DfsFtpCommon <> nil then begin
    DfsFtpCommon.Free;
    DfsFtpCommon := nil;
  end;
  for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    if DfsFtpCh[i] <> nil then begin
      DfsFtpCh[i].Free;
      DfsFtpCh[i] := nil;
    end;
  end;
{$ENDIF}
  for i := DefPocb.JIG_A to DefPocb.JIG_B do begin
    if frmTest1Ch[i] <> nil then begin
      frmTest1Ch[i].Free;
      frmTest1Ch[i] := nil;
    end;
  end;
	
  {$IFDEF REMOTE_UPDATE}
  if UsObject <> nil then begin
    UsObject.Free;
    UsObject := nil;
  end;
  {$ENDIF}
		
  // 마지막에 !!!
  if Common <> nil then begin
    Common.Free;
    Common := nil;
  end;
end;

procedure TfrmMain.InitAll(bInitMotor: Boolean = True; bInitRobot: Boolean = True);
var
  sDebug : string;
  sErrLogHeader, sErrLogData : string;
begin
  {$IFDEF REMOTE_UPDATE}
  if UsObject <> nil then begin
    UsObject.SetInpectReady := False;
  end;
  {$ENDIF}

  m_sUserIdBeforeInitial := Common.m_sUserId;   //2023-07-01

  sDebug := Common.m_sExeVerNameLog +' Initial =====================';
  Common.MLog(DefPocb.CH_1,sDebug);
  Common.MLog(DefPocb.CH_2,sDebug);
  Common.MLog(DefPocb.SYS_LOG,sDebug);

  //
  sErrLogHeader := 'DateTime,AlarmNo,AlarmName,DIO#,ON/OFF'; //2022-12-06 ERROR_LOG
  sErrLogData   := FormatDateTime('yyyy-mm-dd hh:mm:ss.zzz',Now) + ',---,EXE_INITIAL,-,--';
  Common.MakeErrorLog(sErrLogHeader,sErrLogData);

  //
  FreeAll(bInitMotor,bInitRobot); //TBD:A2CHv3:ROBOT?

  Sleep(1000);
  // Create Again.
  Common :=	TCommon.Create;
  Common.SetEdModel2TestModel;

  m_bExitOrInit := False; //2019-01-16
  Common.m_sUserId := m_sUserIdBeforeInitial;   //2023-07-01

  //
  CreateClassData(bInitMotor);
{$IFDEF DFS_HEX}
  InitDfs; //!!!
{$ENDIF}
  ShowMainFrmSysStatus;
  DisplayModelInfo;

  if not bInitMotor then begin
{$IFDEF HAS_MOTION_CAM_Z}	
    tmrZAxisModelPos.Enabled := True;
{$ENDIF}		
    tmrYAxisModelPos.Enabled := True;
  end;
end;

{$IFDEF REMOTE_UPDATE}
procedure TfrmMain.InitAutoUpdate;
var
  nTemp : integer; sTemp : string;
begin
  if UsObject = nil then Exit;
  // 조경규 수석님 요청에 따라 buffer 저장 부분 Send 부분 따로 분리.
  // parameter setting.
  UsObject.SetInspectInfo(DefAimf.MSG_PARA_REQ_USER_ID,Common.m_sUserId);
  UsObject.SetInspectInfo(DefAimf.MSG_PARA_REQ_CUR_EQPID,Common.SystemInfo.EQPId);
//sTemp := ExtractFileName(Application.ExeName)+'('+trim(Common.SwVersion)+')';
  {$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
  sTemp := Common.m_sExeVerNameLog;
  {$ELSE}
  sTemp := Common.m_sExeVerName;
  {$ENDIF}
  UsObject.SetInspectInfo(DefAimf.MSG_PARA_REQ_OLD_SW_VERSION,sTemp);
  {$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
  UsObject.SetInspectInfo(DefAimf.MSG_PARA_REQ_OLD_MODEL_CH1,trim(Common.SystemInfo.TestModel[DefPocb.CH_1]));
  UsObject.SetInspectInfo(DefAimf.MSG_PARA_REQ_OLD_MODEL_CH2,trim(Common.SystemInfo.TestModel[DefPocb.CH_2]));
  {$ELSE}
  UsObject.SetInspectInfo(DefAimf.MSG_PARA_REQ_OLD_MODEL_CH1,trim(Common.SystemInfo.TestModel));
  UsObject.SetInspectInfo(DefAimf.MSG_PARA_REQ_OLD_MODEL_CH2,trim(Common.SystemInfo.TestModel));
  {$ENDIF}

  UsObject.SetInspectInfo(DefAimf.MSG_PARA_REQ_APP_PATH,ExtractFilePath(Application.ExeName));
  {$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
//sTemp := Common.ModelNameInfo.ModelInfo[Common.TestModelInfo2.Pwr_Offset_IDX[DefCommon.CH1]].ModelName;
  sTemp := Common.TestModelInfo2[DefPocb.CH_1].LogUploadPanelModel; //TBD:REMOTE_UPDATE? (-> Recipe)
  {$ELSE}
  sTemp := Common.TestModelInfo2[.LogUploadPanelModel; //TBD:REMOTE_UPDATE? (-> Recipe)
  {$ENDIF}
  UsObject.SetInspectInfo(DefAimf.MSG_PARA_REQ_INSPECT_MODEL,sTemp);
  {$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
//sTemp := Common.ModelNameInfo.ModelInfo[Common.TestModelInfo2.Pwr_Offset_IDX[DefCommon.CH2]].ModelName;
  sTemp := Common.TestModelInfo2[DefPocb.CH_2].LogUploadPanelModel; //TBD:REMOTE_UPDATE? (-> Recipe)
  {$ELSE}
  sTemp := Common.TestModelInfo2.LogUploadPanelModel; //TBD:REMOTE_UPDATE? (-> Recipe)
  {$ENDIF}
  UsObject.SetInspectInfo(DefAimf.MSG_PARA_REQ_INSPECT_MODEL2,sTemp);

  nTemp := TernaryOp(Common.SystemInfo.UseGIB, DefAimf.MSG_PARA_REQ_LINE_MGIB, DefAimf.MSG_PARA_REQ_LINE_INLINE); //TBD:REMOTE_UPDATE:GIB?
  { IMD_GB
  nTemp := DefAimf.MSG_PARA_REQ_LINE_SELECT_NG;
  case Common.SystemInfo.ProcessNo of
    DefCommon.GMES_IDX_PRODUCT : nTemp := DefAimf.MSG_PARA_REQ_LINE_INLINE;
    DefCommon.GMES_IDX_P_GIB   : nTemp := DefAimf.MSG_PARA_REQ_LINE_PGIB;
    DefCommon.GMES_IDX_M_GIB   : nTemp := DefAimf.MSG_PARA_REQ_LINE_MGIB;
    DefCommon.GMES_IDX_REPAIR  : nTemp := DefAimf.MSG_PARA_REQ_LINE_REPAIR;
  end;
  }
  UsObject.SetInspectInfo(DefAimf.MSG_PARA_REQ_LINE_MODE,'',nTemp);
  // send data.
  UsObject.SendInspectInfoToUdateSwAuto;
end;

procedure TfrmMain.SetDllStatus(nMode: Integer; var nRet: Integer; sMsg: string);
var
  sCurModel, sRecipe1, sRecipe2, sUserId  : string;
  sSelectProductLine : string;
  bRet : boolean;
  nCh : Integer;
begin
  nRet := -1;
  case nMode of
    DefAimf.MSG_MODE_UPDATE_CALL_STATUS : begin  // 검사기 상태 Return.
      nRet := DefAimf.AIMF_STATUS_RUN;

      sSelectProductLine := '';
      sSelectProductLine := TernaryOp(Common.SystemInfo.UseGIB, DefAimf.AIMF_PRODUCT_MGIB, DefAimf.AIMF_PRODUCT_INLINE); //TBD:REMOTE_UPDATE:GIB?
      { IMD_GB
      // Inline, PGIB, MGIB Check.
      case Common.SystemInfo.ProcessNo of
        0 : sSelectProductLine := DefAimf.AIMF_PRODUCT_INLINE;
        1 : sSelectProductLine := DefAimf.AIMF_PRODUCT_PGIB;
        2 : sSelectProductLine := DefAimf.AIMF_PRODUCT_MGIB;
        3 : sSelectProductLine := DefAimf.AIMF_PRODUCT_REPAIR;
      end;
      }
      // Line 상황 확인.
      if sSelectProductLine = '' then begin
        nRet := DefAimf.AIMF_STATUS_LINE_NG;
        Exit;
      end;
      // Line 상황 확인.
      if Pos(sSelectProductLine,UpperCase(UsObject.InfoLine)) = 0 then begin
        nRet := DefAimf.AIMF_STATUS_LINE_NG;
        Exit;
      end;

      { IMD_GB
      // Script 동작 중이면 RUN NG.
      if frmTest2ChGB[DefCommon.JIG_A] <> nil then begin
        if frmTest2ChGB[DefCommon.JIG_A].CheckScriptRun then begin
          Exit;
        end;
      end;
      }
      for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin  //TBD:REMOTE_UPDATE?
        if Logic[nCh].m_InsStatus <> IsStop then begin
          Exit;
        end;
      end;

      // PM Mode 동작중이면  AIMF_STATUS_RUN 상태로 동작중임을 확인.
      if Common.FindCreateForm('TFrmSafetyMsg') <> '' then Exit;  //TBD:REMOTE_UPDATE?
      if Common.FindCreateForm('TfrmMainter') <> '' then Exit;      //TBD:REMOTE_UPDATE?
      if Common.FindCreateForm('TfrmSelectModel') <> '' then Exit;  //TBD:REMOTE_UPDATE?
      if Common.FindCreateForm('TfrmModelInfo') <> '' then Exit;  //TBD:REMOTE_UPDATE?
      if Common.FindCreateForm('TfrmSystemSetup') <> '' then Exit;  //TBD:REMOTE_UPDATE?

      {$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
    //sRecipe1 := Common.ModelNameInfo.ModelInfo[Common.TestModelInfo2.Pwr_Offset_IDX[DefCommon.CH1]].ModelName;
    //sRecipe2 := Common.ModelNameInfo.ModelInfo[Common.TestModelInfo2.Pwr_Offset_IDX[DefCommon.CH2]].ModelName;
      sRecipe1 := Common.TestModelInfo2[DefPocb.CH_1].LogUploadPanelModel; //TBD:REMOTE_UPDATE?
      sRecipe2 := Common.TestModelInfo2[DefPocb.CH_2].LogUploadPanelModel; //TBD:REMOTE_UPDATE?
      {$ELSE}
      sRecipe1 := Common.TestModelInfo2.LogUploadPanelModel; //TBD:REMOTE_UPDATE?
      sRecipe2 := Common.TestModelInfo2.LogUploadPanelModel; //TBD:REMOTE_UPDATE?
      {$ENDIF}
      bRet := False;
      // 현재 Model명에 EADR Msg와 안맞으면... NG.
      // Script 명 ==> Model명으로 바꾸어야함.
      if UsObject.Is1Cg2Panel then begin

        if (UsObject.InfoRecipe <> '') or (UsObject.InfoRecipe2 <> '') then begin
          if UsObject.InfoRecipe <> '' then begin
            if UsObject.InfoRecipe = sRecipe1 then      bRet := True
            else if UsObject.InfoRecipe = sRecipe2 then bRet := True
            else                                        bRet := False;
          end
          else begin
            bRet := True
          end;
          if UsObject.InfoRecipe2 <> '' then begin
            if bRet then begin
              if UsObject.InfoRecipe2 = sRecipe1 then      bRet := True
              else if UsObject.InfoRecipe2 = sRecipe2 then bRet := True
              else                                        bRet := False;
            end;
          end;
        end
        else begin
          nRet := DefAimf.AIMF_STATUS_MODEL_NG;
          Exit;
        end;
        // Model명이 없오면 NG 처리.
        if Trim(sRecipe1) = '' then bRet := False;
        if Trim(sRecipe2) = '' then bRet := False;
      end
      else begin
        // 1CG 1Panel은 모델명이 같아야 한다.
        if Trim(UpperCase(sRecipe1)) <> Trim(UpperCase(sRecipe2)) then begin
          nRet := DefAimf.AIMF_STATUS_MODEL_NG;
          Exit;
        end;
        // 1,2 channel 같으니깐 1채널 기준으로 검증.
        if UpperCase(sMsg) = UpperCase(sRecipe1) then bRet := True;
        // Model명이 없오면 NG 처리.
        if Trim(sRecipe1) = '' then bRet := False;
      end;

      // 현재 Model명에 EADR Msg와 안맞으면... NG.
      if not bRet then begin
        nRet := DefAimf.AIMF_STATUS_MODEL_NG;
        Exit;
      end;


      nRet := DefAimf.AIMF_STATUS_IDLE;
    end;
    DefAimf.MSG_MODE_INSPECT_OFF : begin  // SW 강제 OFF.
      close;
    end;
    DefAimf.MSG_MODE_INSPECT_MC : begin   // M/C
      //sRecipe2 := UsObject.ModelFile2; // 1CG 2Panel일 경우 추가 Model 명.  열보 / 광보는 상관 없음.
      AutoMc(sMsg);
      nRet := 0;
    end;

    // restart aimf.exe file. there is no inspect info.
    DefAimf.MSG_MODE_SYSTEM_INFO_CALL : begin  // System 정보 Call
      InitAutoUpdate;
    end;

    DefAimf.MSG_MODE_INSP_UPDATE_FINISH : begin
      nRet := UsObject.FinishRet;
      {$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
      Common.MLog(DefPocb.SYS_LOG,Format('MSG_MODE_INSP_UPDATE_FINISH : RET(%d), Login(%s)' ,[nRet, sMsg]));
      {$ELSE}
      Common.MLog(DefPocb.MAX_SYSTEM_LOG,Format('MSG_MODE_INSP_UPDATE_FINISH : RET(%d), Login(%s)' ,[nRet, sMsg]));
      {$ENDIF}
      // Auto Log In. In case of EAAR_R OK and the result of update is OK.
      if nRet = DefAimf.AIMF_RET_ALL_OK then begin
        sUserId := Trim(sMsg);
        if not ((sUserId = '') or (UpperCase(sUserId) = 'PM')) then begin
          Common.m_sUserId  := sUserId;
          pnlGmesUserId.Caption := sUserId;
          InitGmes;
        end;
      end
      else if nRet in [DefAimf.AIMF_RET_NG_EAAR_OK, DefAimf.AIMF_RET_OK_EAAR_NG, DefAimf.AIMF_RET_NG_EAAR_NG ] then begin
        btnLogIn.Click;
      end;
    end;
    DefAimf.MSG_MODE_EAYT_INFO_CALL  : begin   // EDTI 정보 확인.
      if DongaGmes <> nil then begin
        if DongaGmes.IsEdtiOn then nRet := 0
        else                       nRet := 1;
      end
      else begin
        // PM Mode에서는 자유롭게 EAYT 돌리자.
        nRet := 0;
      end;
    end;
  end;
end;
{$ENDIF}

procedure TfrmMain.InitForm;
var
  i : Integer;
begin
  //
  mmAlarmOpMsg.Lines.Clear;
  for i := 0 to DefPocb.MAX_ALARM_NO do begin
    frmSafetyAlarmMsg[i] := TfrmSafetyAlarmMsg.Create(Self);
  end;
  //
//InitMainFrmSystemInfo; //2019-08-26 Move into CreateClassData()
  MakeMainFrmDIO;
  ShowMainFrmSysStatus; //#ShowMainFrmGmes+#MakeMainSystemMsg
  ShowMainFrmModelInfo;

  Fframe_SystemArm.ReconfigGui; //2022-07-15 A2CHv4_#3(FanInOutPC)
end;

procedure TfrmMain.InitMainFrmSystemInfo(bInitMotor : Boolean = True);
begin
  // Cam Connection Status : Cam1, Cam2
  //  - Cam1 (Ch1/Cam)
//ledSysinfoCam1Clint.TrueColor  := clLime;
//ledSysinfoCam1Clint.FalseColor := clRed;
//ledSysinfoCam1Clint.Value      := False;
//pnlSysinfoCam1ClintStatus.Caption := 'GPC-->DPC Disc';
 	pnlSysinfoCam1ClintStatus.StyleElements  := [];
  //  - Cam2 (Ch1/Cam)
//ledSysinfoCam2Clint.TrueColor  := clLime;
//ledSysinfoCam2Clint.FalseColor := clRed;
//ledSysinfoCam2Clint.Value      := False;
//pnlSysinfoCam2ClintStatus.Caption := 'GPC-->DPC Disc';
 	pnlSysinfoCam2ClintStatus.StyleElements := [];

  // Camera Status
  if bInitMotor then begin
{$IFDEF HAS_MOTION_CAM_Z}
  //  - Zaxis1 (Ch1/Z-axis)
  ledSysinfoZaxis1Motor.TrueColor     := clLime;
  ledSysinfoZaxis1Motor.FalseColor    := clRed;
  ledSysinfoZaxis1Motor.Value         := False;
  pnlSysinfoZaxis1Status.Caption      := 'Disconnectd';
 	pnlSysinfoZaxis1Status.StyleElements:= [];
  pnlSysinfoZaxis1ServoMsg.Caption    := '';
 	pnlSysinfoZaxis1ServoMsg.StyleElements := [];
  //  - Zaxis2 (Ch2/Z-axis)
  ledSysinfoZaxis2Motor.TrueColor   := clLime;
  ledSysinfoZaxis2Motor.FalseColor  := clRed;
  ledSysinfoZaxis2Motor.Value       := False;
  pnlSysinfoZaxis2Status.Caption    := 'Disconnectd';
 	pnlSysinfoZaxis2Status.StyleElements  := [];
  pnlSysinfoZaxis2ServoMsg.Caption  := '';
 	pnlSysinfoZaxis2ServoMsg.StyleElements  := [];
{$ENDIF}
{$IFDEF HAS_ROBOT_CAM_Z}
  //  - Robot1 (Ch1)
  ledSysinfoRobot1Modbus.TrueColor        := clLime;
  ledSysinfoRobot1Modbus.FalseColor       := clRed;
  ledSysinfoRobot1Modbus.Value            := False;
 	pnlSysinfoRobot1Modbus.StyleElements    := [];
 	pnlSysinfoRobot1Modbus.Color            := clRed;
 	pnlSysinfoRobot1Modbus.Font.Color       := clYellow;
  ledSysinfoRobot1ListenNode.TrueColor    := clLime;
  ledSysinfoRobot1ListenNode.FalseColor   := clRed;
  ledSysinfoRobot1ListenNode.Value        := False;
 	pnlSysinfoRobot1ListenNode.StyleElements:= [];
 	pnlSysinfoRobot1ListenNode.Color        := clRed;
 	pnlSysinfoRobot1ListenNode.Font.Color   := clYellow;
 	pnlSysinfoRobot1StatusMsg.StyleElements := [];
  pnlSysinfoRobot1StatusMsg.Caption       := 'Disconnectd';
  //  - Robot2 (Ch2)
  ledSysinfoRobot2Modbus.TrueColor        := clLime;
  ledSysinfoRobot2Modbus.FalseColor       := clRed;
  ledSysinfoRobot2Modbus.Value            := False;
 	pnlSysinfoRobot2Modbus.StyleElements    := [];
 	pnlSysinfoRobot2Modbus.Color            := clRed;
 	pnlSysinfoRobot2Modbus.Font.Color       := clYellow;
  ledSysinfoRobot2ListenNode.TrueColor    := clLime;
  ledSysinfoRobot2ListenNode.FalseColor   := clRed;
  ledSysinfoRobot2ListenNode.Value        := False;
 	pnlSysinfoRobot2ListenNode.StyleElements:= [];
 	pnlSysinfoRobot2ListenNode.Color        := clRed;
 	pnlSysinfoRobot2ListenNode.Font.Color   := clYellow;
 	pnlSysinfoRobot2StatusMsg.StyleElements := [];
  pnlSysinfoRobot2StatusMsg.Caption       := 'Disconnectd';
{$ENDIF}
  //  - Yaxis1 (Ch1/Y-axis)
  ledSysinfoYaxis1Motor.TrueColor   := clLime;
  ledSysinfoYaxis1Motor.FalseColor  := clRed;
  ledSysinfoYaxis1Motor.Value       := False;
  pnlSysinfoYaxis1Status.Caption    := 'Disconnectd';
 	pnlSysinfoYaxis1Status.StyleElements  := [];
  pnlSysinfoYaxis1ServoMsg.Caption  := '';
 	pnlSysinfoYaxis1ServoMsg.StyleElements  := [];
  //  - Yaxis2 (Ch2/Y-axis)
  ledSysinfoYaxis2Motor.TrueColor   := clLime;
  ledSysinfoYaxis2Motor.FalseColor  := clRed;
  ledSysinfoYaxis2Motor.Value       := False;
  pnlSysinfoYaxis2Status.Caption    := 'Disconnectd';
 	pnlSysinfoYaxis2Status.StyleElements  := [];
  pnlSysinfoYaxis2ServoMsg.Caption  := '';
 	pnlSysinfoYaxis2ServoMsg.StyleElements  := [];
{$IFDEF HAS_MOTION_TILTING}
  //  - Taxis1 (Ch1/T-axis)
  ledSysinfoTaxis1Motor.TrueColor   := clLime;
  ledSysinfoTaxis1Motor.FalseColor  := clRed;
  ledSysinfoTaxis1Motor.Value       := False;
  pnlSysinfoTaxis1Status.Caption    := 'Disconnectd';
 	pnlSysinfoTaxis1Status.StyleElements  := [];
  pnlSysinfoTaxis1ServoMsg.Caption  := '';
 	pnlSysinfoTaxis1ServoMsg.StyleElements  := [];
  //  - Taxis2 (Ch2/T-axis)
  ledSysinfoTaxis2Motor.TrueColor   := clLime;
  ledSysinfoTaxis2Motor.FalseColor  := clRed;
  ledSysinfoTaxis2Motor.Value       := False;
  pnlSysinfoTaxis2Status.Caption    := 'Disconnectd';
 	pnlSysinfoTaxis2Status.StyleElements  := [];
  pnlSysinfoTaxis2ServoMsg.Caption  := '';
 	pnlSysinfoTaxis2ServoMsg.StyleElements  := [];
{$ENDIF}
  end;
  // Switch Button Connection Status
  //  - Rcb1
  ledSysinfoRcb1.TrueColor  := clLime;
  ledSysinfoRcb1.FalseColor := clRed;
  ledSysinfoRcb1.Value      := False;
  pnlSysinfoRcb1.Caption        := 'Disconnected';
 	pnlSysinfoRcb1.StyleElements  := [];
  //  - Rcb2
  ledSysinfoRcb2.TrueColor  := clLime;
  ledSysinfoRcb2.FalseColor := clRed;
  ledSysinfoRcb2.Value          := False;
  pnlSysinfoRcb2.Caption        := 'Disconnected';
 	pnlSysinfoRcb2.StyleElements  := [];

  // HandBCR Connection Status
  ledSysinfoHandBcr.TrueColor   := clLime;
  ledSysinfoHandBcr.FalseColor  := clRed;
//ledSysinfoHandBcr.Value       := False;
//pnlSysinfoHandBcr.Caption     := 'Disconnected';
 	pnlSysinfoHandBcr.StyleElements := [];

  // Shared Folder Status
  ledSysinfoSharefolder.TrueColor  := clLime;
  ledSysinfoSharefolder.FalseColor := clRed;
  ledSysinfoSharefolder.Value      := False;
  pnlSysinfoSharefolder.Caption       := '';
 	pnlSysinfoSharefolder.StyleElements := [];

  // GMES Connection Status
  {$IFDEF SITE_LENSVN}
  if Trim(Common.SystemInfo.LensMesUrlIF) <> '' then
  {$ELSE}
  if Trim(Common.SystemInfo.MES_ServicePort) <> '' then
  {$ENDIF}
  begin
    //ShowMainFrmSysStatus; //2023-09-20
  end
  else begin
    ledSysInfoGmes.FalseColor := clGray;
    ledSysInfoGmes.Value      := False;
    pnlSysInfoGmes.Color      := clGray;
    pnlSysInfoGmes.Font.Color := clBlack;
    pnlSysInfoGmes.Caption    := 'NONE';
    //
    {$IFDEF USE_EAS}
    ledSysInfoEAS.FalseColor  := clGray;
    ledSysInfoEAS.Value       := False;
    pnlSysInfoEAS.Color       := clGray;
    pnlSysInfoEAS.Font.Color  := clBlack;
    pnlSysInfoEAS.Caption     := 'NONE';
    {$ELSE}
    RzpnlSysinfoEasTitle.Visible := False;
    ledSysInfoEAS.Visible := False;
    pnlSysInfoEAS.Visible := False;
    {$ENDIF}
  end;

  {$IFDEF SITE_LENSVN}
  RzpnlSysinfoEasTitle.Visible := False;
  ledSysInfoEAS.Visible := False;
  pnlSysInfoEAS.Visible := False;
  {$ENDIF}

  {$IFDEF DFS_HEX}
  if Common.DfsConfInfo.bUseDfs then begin
    // DFS Connection Status
    ledSysinfoDfs.TrueColor  := clLime;
    ledSysinfoDfs.FalseColor := clRed;
  //ledSysinfoDfs.Value      := False;
   	pnlSysinfoDfs.StyleElements := [];
  //pnlSysinfoDfs.Caption    := 'Disconn';
  end
  else begin
    ledSysInfoDfs.FalseColor := clGray;
    ledSysInfoDfs.Value      := False;
  //pnlSysinfoDfs.StyleElements := [];
    pnlSysinfoDfs.Color      := clGray;
    pnlSysInfoEAS.Font.Color := clBlack;
    pnlSysinfoDfs.Caption    := 'NONE';
  end;
  {$ELSE}
  RzpnlSysinfoDfsTitle.Visible := False;
  ledSysInfoDfs.Visible := False;
  pnlSysinfoDfs.Visible := False;
  {$ENDIF}

  //2019-05-10 ExLight Connection Status
  ledSysinfoExLight.TrueColor   := clLime;
  if Common.SystemInfo.Com_ExLight <> 0 then ledSysinfoExLight.FalseColor  := clRed
  else                                       ledSysinfoExLight.FalseColor  := clGray;
  ledSysinfoExLight.Value   := False;
  pnlSysinfoExLight.Caption := 'Disconn';
 	pnlSysinfoExLight.StyleElements := [];

  //2019-05-10 EFU Connection Status
  // EFU/LV32
  ledSysinfoEfuLv32Conn.TrueColor   := clLime;
  if Common.SystemInfo.Com_EFU <> 0 then ledSysinfoExLight.FalseColor  := clRed
  else                                   ledSysinfoExLight.FalseColor  := clGray;
  ledSysinfoEfuLv32Conn.Value   := False;
  pnlSysinfoEfuLv32Conn.Caption := 'Disconnected';
 	pnlSysinfoEfuLv32Conn.StyleElements := [];

  // EFU/CH1
  ledSysinfoEfuCh1.TrueColor   := clLime;
  if Common.SystemInfo.Com_EFU <> 0 then ledSysinfoEfuCh1.FalseColor  := clRed
  else                                   ledSysinfoEfuCh1.FalseColor  := clGray;
  ledSysinfoEfuCh1.Value              := False;
  pnlSysinfoEfuCh1Alarm.Caption       := '';
 	pnlSysinfoEfuCh1Alarm.StyleElements := [];
  //
  if Common.SystemInfo.EfuIcuCntPerCH = 2 then begin
    ledSysinfoEfuCh1_2.TrueColor   := clLime;
    if Common.SystemInfo.Com_EFU <> 0 then ledSysinfoEfuCh1_2.FalseColor  := clRed
    else                                   ledSysinfoEfuCh1_2.FalseColor  := clGray;
    ledSysinfoEfuCh1_2.Value              := False;
    pnlSysinfoEfuCh1_2Alarm.Caption       := '';
   	pnlSysinfoEfuCh1_2Alarm.StyleElements := [];
    //
    ledSysinfoEfuCh1_2.Visible      := True;
    pnlSysinfoEfuCh1_2Alarm.Visible := True;
  end
  else begin
    pnlSysinfoEfuCh1Alarm.Width := pnlSysinfoEfuCh1_2Alarm.Width*2 + ledSysinfoEfuCh1.Width;
    //
    ledSysinfoEfuCh1_2.Visible      := False;
    pnlSysinfoEfuCh1_2Alarm.Visible := False;
  end;

  // EFU/CH2
  ledSysinfoEfuCh2.TrueColor  := clLime;
  if Common.SystemInfo.Com_EFU <> 0 then ledSysinfoEfuCh2.FalseColor  := clRed
  else                                   ledSysinfoEfuCh2.FalseColor  := clGray;
  ledSysinfoEfuCh2.Value              := False;
  pnlSysinfoEfuCh2Alarm.Caption       := '';
 	pnlSysinfoEfuCh2Alarm.StyleElements := [];
  //
  if Common.SystemInfo.EfuIcuCntPerCH = 2 then begin
    ledSysinfoEfuCh2_2.TrueColor   := clLime;
    if Common.SystemInfo.Com_EFU <> 0 then ledSysinfoEfuCh2_2.FalseColor  := clRed
    else                                   ledSysinfoEfuCh2_2.FalseColor  := clGray;
    ledSysinfoEfuCh2_2.Value              := False;
    pnlSysinfoEfuCh2_2Alarm.Caption       := '';
   	pnlSysinfoEfuCh2_2Alarm.StyleElements := [];
    //
    ledSysinfoEfuCh2_2.Visible      := True;
    pnlSysinfoEfuCh2_2Alarm.Visible := True;
  end
  else begin
    pnlSysinfoEfuCh2Alarm.Width := pnlSysinfoEfuCh2_2Alarm.Width*2 + ledSysinfoEfuCh2.Width;
    //
    ledSysinfoEfuCh2_2.Visible      := False;
    pnlSysinfoEfuCh2_2Alarm.Visible := False;
  end;

  // Ionizer/CH1
  if Common.SystemInfo.IonizerCntPerCH = 2 then begin
    ledSysinfoIon1.TrueColor := clLime;
    if Common.SystemInfo.Com_ION[0] <> 0 then ledSysinfoIon1.FalseColor    := clRed
    else                                      ledSysinfoIon1.FalseColor    := clGray;
    ledSysinfoIon1.Value   := False;
    pnlSysinfoIon1.Caption         := 'Disc';
   	pnlSysinfoIon1.StyleElements   := [];
    //
    ledSysinfoIon1_2.TrueColor := clLime;
    if Common.SystemInfo.Com_ION[1] <> 0 then ledSysinfoIon1_2.FalseColor  := clRed
    else                                      ledSysinfoIon1_2.FalseColor  := clGray;
    ledSysinfoIon1_2.Value := False;
    pnlSysinfoIon1_2.Caption       := 'Disc';
   	pnlSysinfoIon1_2.StyleElements := [];
    //
    ledSysinfoIon2.TrueColor := clLime;
    if Common.SystemInfo.Com_ION[2] <> 0 then ledSysinfoIon2.FalseColor    := clRed
    else                                      ledSysinfoIon2.FalseColor    := clGray;
    ledSysinfoIon2.Value   := False;
    pnlSysinfoIon2.Caption         := 'Disc';
   	pnlSysinfoIon2.StyleElements   := [];
    //
    ledSysinfoIon2_2.TrueColor := clLime;
    if Common.SystemInfo.Com_ION[3] <> 0 then ledSysinfoIon2_2.FalseColor  := clRed
    else                                      ledSysinfoIon2_2.FalseColor  := clGray;
    ledSysinfoIon2_2.Value := False;
    pnlSysinfoIon2_2.Caption       := 'Disc';
   	pnlSysinfoIon2_2.StyleElements := [];
  end
  else begin  // SystemInfo.IonizerCntPerCH = 1
    ledSysinfoIon1.TrueColor   := clLime;
    if Common.SystemInfo.Com_ION[0] <> 0 then ledSysinfoIon1.FalseColor  := clRed
    else                                      ledSysinfoIon1.FalseColor  := clGray;
    ledSysinfoIon1.Value         := False;
		pnlSysinfoIon1.Width         := pnlSysinfoIon1.Width + ledSysinfoIon1_2.Width + pnlSysinfoIon1_2.Width;
    pnlSysinfoIon1.Caption       := 'Disconnected';
   	pnlSysinfoIon1.StyleElements := [];
		//
		ledSysinfoIon1_2.Visible := False;
		pnlSysinfoIon1_2.Visible := False;
    //
    ledSysinfoIon2.TrueColor   := clLime;
    if Common.SystemInfo.Com_ION[1] <> 0 then ledSysinfoIon2.FalseColor  := clRed
    else                                      ledSysinfoIon2.FalseColor  := clGray;
    ledSysinfoIon2.Value         := False;
		pnlSysinfoIon2.Width         := pnlSysinfoIon2.Width + ledSysinfoIon2_2.Width + pnlSysinfoIon2_2.Width;		
    pnlSysinfoIon2.Caption       := 'Disconnected';
   	pnlSysinfoIon2.StyleElements := [];
		//
		ledSysinfoIon2_2.Visible := False;
		pnlSysinfoIon2_2.Visible := False;
  end;

  //

end;

procedure TfrmMain.ShowMainFrmSysStatus;
begin
  if pnlMainFrmSysStGrp = nil then MakeMainFrmSysStGrp;

  //
  {$IFDEF SITE_LENSVN}
  if Trim(Common.SystemInfo.LensMesUrlIF) <> '' then
  {$ELSE}
  if Trim(Common.SystemInfo.MES_ServicePort) <> '' then
  {$ENDIF}
  begin
    Common.m_bMesOnline := False;
    if (DongaGmes <> nil) and (Length(DongaGmes.MesUserId) > 0) and (DongaGmes.MesUserId <> 'PM') and (Length(DongaGmes.MesUserName) > 0) then // (for LENSVN) set UserName to UserId if Login OK
      Common.m_bMesOnline := True;
    if Common.m_bMesOnline then UpdateMainFrmMesStatus(MesStatus_ONLINE)
    else                        UpdateMainFrmMesStatus(MesStatus_OFFLINE);
  end
  else
    UpdateMainFrmMesStatus(MesStatus_NONE);
end;

procedure TfrmMain.UpdateMainFrmMesStatus(mesStatus: enumMesStatus; bMesLoginFailed: Boolean=False); //2023-09-20
begin
  if not (Common.SystemInfo.UseGIB or Common.SystemInfo.UseGRR) then
    pnlSysinfoUseGIB.Visible := False  //2019-11-08
  else
    pnlSysinfoUseGIB.Visible := True;

  //
  if pnlMainFrmSysStGrp = nil then MakeMainFrmSysStGrp;
  case mesStatus of
    //----------------------------------
    MesStatus_NONE : begin
      Common.m_bMesOnline := False;
    	{$IFDEF SITE_LENSVN}
    	Common.m_sUserPwd  := '';
    	{$ENDIF}
    	//
      btnLogIn.Visible := False;
      btnLogIn.Caption := 'Log In';
			//
      ledSysInfoGmes.FalseColor := clGray;
      ledSysInfoGmes.Value      := False;
      pnlSysInfoGmes.Color      := clGray;
      pnlSysInfoGmes.Font.Color := clBlack;
      pnlSysInfoGmes.Caption    := 'NONE';
			//
	    {$IFDEF USE_EAS}
      ledSysInfoEAS.FalseColor  := clGray;
      ledSysInfoEAS.Value       := False;
      pnlSysInfoEAS.Caption     := 'NONE';
      pnlSysInfoEAS.Color       := clGray;
      pnlSysInfoEAS.Font.Color  := clBlack;
      {$ENDIF}
      //
      pnlGmesStation.Caption    := Common.SystemInfo.EQPId;
      pnlGmesUserId.Caption     := 'PM';
      pnlGmesUserName.Caption   := '';
			//
      pnlMainSysMesOffline.Visible := True;
      //
      {$IFDEF PANEL_AUTO}
      Common.m_bPmModeProcMaskSkip   := False; //!!!
      pnlMainSysProcMaskGrp.Visible  := True;
      cbMainSysProcMaskSkip.Checked  := Common.m_bPmModeProcMaskSkip;
      pnlMainSysProcMaskSkip.Visible := cbMainSysProcMaskSkip.Checked;
      {$ENDIF}
			//
      if DongaGmes <> nil then begin
        DongaGmes.Free;
        DongaGmes := nil;
      end;
    	//
			ShowModelButtons(True);
      tmrMainFrmSysStBlink.Enabled := True; // START Blinking
    end;
    //----------------------------------
    MesStatus_OFFLINE : begin
      Common.m_bMesOnline := False;
    	{$IFDEF SITE_LENSVN}
    	if (not bMesLoginFailed) then Common.m_sUserPwd := '';
    	{$ENDIF}
    	//
      btnLogIn.Visible := True;
      btnLogIn.Caption := 'Log In';
	    //
      ledSysInfoGmes.TrueColor  := clLime;
      ledSysInfoGmes.FalseColor := clRed;
      ledSysInfoGmes.Value      := False;
      pnlSysInfoGmes.Color      := clRed;
      pnlSysInfoGmes.Font.Color := clYellow;
      if Common.m_sUserId <> 'PM' then pnlSysinfoGmes.Caption := 'Disconnected'
      else                             pnlSysinfoGmes.Caption := 'PM Mode';
			//
	    {$IFDEF USE_EAS}
    	if not Common.SystemInfo.EAS_UseAPDR then begin
      	ledSysInfoEAS.FalseColor  := clGray;
      	ledSysInfoEAS.Value       := False;
      	pnlSysInfoEAS.Caption     := 'NONE';
      	pnlSysInfoEAS.Color       := clGray;
      	pnlSysInfoEAS.Font.Color  := clBlack;
    	end
    	else begin
      	ledSysInfoEAS.TrueColor   := clLime;
      	ledSysInfoEAS.FalseColor  := clRed;
      	ledSysInfoEAS.Value       := False;
      	pnlSysInfoEAS.Caption     := 'PM Mode';
      	pnlSysInfoEAS.Color       := clRed;
      	pnlSysInfoEAS.Font.Color  := clYellow;
    	end;
    	{$ENDIF}
      //
      pnlGmesStation.Caption  := Common.SystemInfo.EQPId;
      pnlGmesUserId.Caption   := Common.m_sUserId;
      pnlGmesUserName.Caption := '';
			//
      pnlMainSysMesOffline.Visible    := True;
      pnlMainSysMesOffline.Color      := clRed;
      pnlMainSysMesOffline.Font.Color := clYellow;
      pnlMainSysMesOffline.Caption    := 'MES OFFLINE_MODE';
      //
      {$IFDEF PANEL_AUTO}
      Common.m_bPmModeProcMaskSkip   := False; //!!!
      pnlMainSysProcMaskGrp.Visible  := True;
      cbMainSysProcMaskSkip.Checked  := Common.m_bPmModeProcMaskSkip;
      pnlMainSysProcMaskSkip.Visible := cbMainSysProcMaskSkip.Checked;
      {$ENDIF}
    	//
			ShowModelButtons(True);
      tmrMainFrmSysStBlink.Enabled := True; // START Blinking
    end;
    //----------------------------------
    MesStatus_ONLINE : begin
      tmrMainFrmSysStBlink.Enabled := False; // STOP Blinking
      //
      Common.m_bMesOnline := True;
    	{$IFDEF SITE_LENSVN}
    //Common.m_sUserPwd :=
    	{$ENDIF}
			//
      btnLogIn.Visible := True;
      btnLogIn.Caption := 'Log Out';
    	//
      ledSysInfoGmes.TrueColor  := clLime;
      ledSysInfoGmes.FalseColor := clRed;
      ledSysInfoGmes.Value      := True;
      pnlSysinfoGmes.Color      := clLime;
      pnlSysinfoGmes.Font.Color := clBlack;
      pnlSysinfoGmes.Caption    := 'Connected';
			//
      pnlGmesStation.Caption  := Common.SystemInfo.EQPId;
      pnlGmesUserId.Caption   := DongaGmes.MesUserId;
      pnlGmesUserName.Caption := DongaGmes.MesUserName;
			//
      pnlMainSysMesOffline.Visible    := True;
      pnlMainSysMesOffline.Color      := clLime;
      pnlMainSysMesOffline.Font.Color := clBlack;
      pnlMainSysMesOffline.Caption    := 'MES ONLINE_MODE';
      //
      {$IFDEF PANEL_AUTO}
      Common.m_bPmModeProcMaskSkip   := False; //!!!
      pnlMainSysProcMaskGrp.Visible  := False;
      cbMainSysProcMaskSkip.Checked  := False;
      pnlMainSysProcMaskSkip.Visible := cbMainSysProcMaskSkip.Checked;
      {$ENDIF}
    	//
    end;
  end;
end;

procedure TfrmMain.ShowMainFrmModelInfo;
begin
  // GroupBox: ModelInfo
  //  - Resolution
  //  - Pattern Group
  //  - Power(Voltage): VCC, ELVDD
  //
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  pnlModelPatGrp.Caption          := Common.TestModelInfo.PatGrpName;
  pnlModelResolution.Caption      := Format('%d x %d',[Common.TestModelInfo.H_Active, Common.TestModelInfo.V_Active]);
  pnlModelVolVcc.Caption          := Format('%0.2f V',[Common.TestModelInfo.PWR_VOL[DefPG.PWR_VCC]/1000]);
  pnlModelVolVdd.Caption          := Format('%0.2f V',[Common.TestModelInfo.PWR_VOL[DefPG.PWR_VDD_VEL]/1000]);
  pnlModelBcrLen.Caption          := IntToStr(Common.TestModelInfo2.BcrLength);
 	pnlModelBcrLen.StyleElements    := [];
{$ELSE}  //A2CHv3|A2CHv4
  with Common.TestModelInfo[DefPocb.CH_1] do begin
    pnlModelPatGrpCh1.Caption       := PatGrpName;
    pnlModelResolutionCh1.Caption   := Format('%d x %d',[H_Active, V_Active]);
    pnlModelVolVccCh1.Caption       := Format('%0.2f V',[PWR_VOL[DefPG.PWR_VCC]/1000]);
    pnlModelVolVddCh1.Caption       := Format('%0.2f V',[PWR_VOL[DefPG.PWR_VDD_VEL]/1000]);
  end;
  with Common.TestModelInfo[DefPocb.CH_2] do begin
    pnlModelPatGrpCh2.Caption       := PatGrpName;
    pnlModelResolutionCh2.Caption   := Format('%d x %d',[H_Active, V_Active]);
    pnlModelVolVccCh2.Caption       := Format('%0.2f V',[PWR_VOL[DefPG.PWR_VCC]/1000]);
    pnlModelVolVddCh2.Caption       := Format('%0.2f V',[PWR_VOL[DefPG.PWR_VDD_VEL]/1000]);
  end;
  pnlModelBcrLenCh1.Caption       := IntToStr(Common.TestModelInfo2[DefPocb.CH_1].BcrLength);
 	pnlModelBcrLenCh1.StyleElements := [];
  pnlModelBcrLenCh2.Caption       := IntToStr(Common.TestModelInfo2[DefPocb.CH_2].BcrLength);
 	pnlModelBcrLenCh2.StyleElements := [];

  //A2CHv3:BCR_PID_CHECK
  if (Common.TestModelInfo2[DefPocb.CH_1].BcrPidChkIdx > 0) and (Length(Common.TestModelInfo2[DefPocb.CH_1].BcrPidChkStr) > 0) then
    pnlModelBcrChkCh1.Caption := Format('%d,%s',[Common.TestModelInfo2[DefPocb.CH_1].BcrPidChkIdx, Common.TestModelInfo2[DefPocb.CH_1].BcrPidChkStr])
  else
    pnlModelBcrChkCh1.Caption := '';
 	pnlModelBcrChkCh1.StyleElements := [];
  if (Common.TestModelInfo2[DefPocb.CH_2].BcrPidChkIdx > 0) and (Length(Common.TestModelInfo2[DefPocb.CH_2].BcrPidChkStr) > 0) then
    pnlModelBcrChkCh2.Caption := Format('%d,%s',[Common.TestModelInfo2[DefPocb.CH_2].BcrPidChkIdx, Common.TestModelInfo2[DefPocb.CH_2].BcrPidChkStr])
  else
    pnlModelBcrChkCh2.Caption := '';
 	pnlModelBcrChkCh2.StyleElements := [];

  {$IFDEF SUPPORT_1CG2PANEL}
  if (not Common.SystemInfo.UseAssyPOCB) then begin
  {$ENDIF}
    pnlModelBcrMainCh1.Visible := False;
    pnlModelBcrMainCh2.Visible := False;
  {$IFDEF SUPPORT_1CG2PANEL}
  end
  else begin
    pnlModelBcrMainCh1.Visible := Common.TestModelInfo2[DefPocb.CH_1].AssyModelInfo.UseMainPidCh1;
    pnlModelBcrMainCh2.Visible := Common.TestModelInfo2[DefPocb.CH_2].AssyModelInfo.UseMainPidCh2;
  end;
  {$ENDIF}
{$ENDIF} //A2CH|A2CHv2, A2CHv3|A2CHv4
  //
  with Common.TestModelInfo2[DefPocb.CH_1] do begin
    pnlModelYaxis1CamPos.Caption          := Format('%0.2f',[CamYCamPos]);
   	pnlModelYaxis1CamPos.StyleElements    := [];
    pnlModelYaxis2CamPos.Caption          := Format('%0.2f',[CamYCamPos]);
   	pnlModelYaxis2CamPos.StyleElements    := [];
  end;
  with Common.TestModelInfo2[DefPocb.CH_2] do begin
    pnlModelYaxis1LoadPos.Caption         := Format('%0.2f',[CamYLoadPos]);
   	pnlModelYaxis1LoadPos.StyleElements   := [];
    pnlModelYaxis2LoadPos.Caption         := Format('%0.2f',[CamYLoadPos]);
   	pnlModelYaxis2LoadPos.StyleElements   := [];
  end;

  {$IFDEF HAS_MOTION_CAM_Z}
  with Common.TestModelInfo2[DefPocb.CH_1] do begin
    pnlModelZaxis1ModelPos.Caption        := Format('%0.2f',[CamZModelPos]);
   	pnlModelZaxis1ModelPos.StyleElements  := [];
  end;
  with Common.TestModelInfo2[DefPocb.CH_2] do begin
    pnlModelZaxis2ModelPos.Caption        := Format('%0.2f',[CamZModelPos]);
  	pnlModelZaxis2ModelPos.StyleElements  := [];
  end;
  {$ENDIF}

  {$IFDEF HAS_ROBOT_CAM_Z}
  with Common.RobotSysInfo.HomeCoord[DefPocb.CH_1] do begin
   	pnlRobot1HomeCoordX.StyleElements  := [];
    pnlRobot1HomeCoordX.Caption        := FormatFloat(ROBOT_FORMAT_COORD,X);
   	pnlRobot1HomeCoordY.StyleElements  := [];
    pnlRobot1HomeCoordY.Caption        := FormatFloat(ROBOT_FORMAT_COORD,Y);
   	pnlRobot1HomeCoordZ.StyleElements  := [];
    pnlRobot1HomeCoordZ.Caption        := FormatFloat(ROBOT_FORMAT_COORD,Z);
   	pnlRobot1HomeCoordRx.StyleElements := [];
    pnlRobot1HomeCoordRx.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Rx);
   	pnlRobot1HomeCoordRy.StyleElements := [];
    pnlRobot1HomeCoordRy.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Ry);
   	pnlRobot1HomeCoordRz.StyleElements := [];
    pnlRobot1HomeCoordRz.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Rz);
  end;
  with Common.RobotSysInfo.HomeCoord[DefPocb.CH_2] do begin
   	pnlRobot2HomeCoordX.StyleElements  := [];
    pnlRobot2HomeCoordX.Caption        := FormatFloat(ROBOT_FORMAT_COORD,X);
   	pnlRobot2HomeCoordY.StyleElements  := [];
    pnlRobot2HomeCoordY.Caption        := FormatFloat(ROBOT_FORMAT_COORD,Y);
   	pnlRobot2HomeCoordZ.StyleElements  := [];
    pnlRobot2HomeCoordZ.Caption        := FormatFloat(ROBOT_FORMAT_COORD,Z);
   	pnlRobot2HomeCoordRx.StyleElements := [];
    pnlRobot2HomeCoordRx.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Rx);
   	pnlRobot2HomeCoordRy.StyleElements := [];
    pnlRobot2HomeCoordRy.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Ry);
   	pnlRobot2HomeCoordRz.StyleElements := [];
    pnlRobot2HomeCoordRz.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Rz);
  end;
  with Common.TestModelInfo2[DefPocb.CH_2] do begin
   	pnlRobot2ModelCoordX.StyleElements  := [];
    pnlRobot2ModelCoordX.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.X);
   	pnlRobot2ModelCoordY.StyleElements  := [];
    pnlRobot2ModelCoordY.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Y);
   	pnlRobot2ModelCoordZ.StyleElements  := [];
    pnlRobot2ModelCoordZ.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Z);
   	pnlRobot2ModelCoordRx.StyleElements := [];
    pnlRobot2ModelCoordRx.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rx);
   	pnlRobot2ModelCoordRy.StyleElements := [];
    pnlRobot2ModelCoordRy.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Ry);
   	pnlRobot2ModelCoordRz.StyleElements := [];
    pnlRobot2ModelCoordRz.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rz);
  end;
  with Common.TestModelInfo2[DefPocb.CH_1] do begin
   	pnlRobot1ModelCoordX.StyleElements  := [];
    pnlRobot1ModelCoordX.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.X);
   	pnlRobot1ModelCoordY.StyleElements  := [];
    pnlRobot1ModelCoordY.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Y);
   	pnlRobot1ModelCoordZ.StyleElements  := [];
    pnlRobot1ModelCoordZ.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Z);
   	pnlRobot1ModelCoordRx.StyleElements := [];
    pnlRobot1ModelCoordRx.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rx);
   	pnlRobot1ModelCoordRy.StyleElements := [];
    pnlRobot1ModelCoordRy.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Ry);
   	pnlRobot1ModelCoordRz.StyleElements := [];
    pnlRobot1ModelCoordRz.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rz);
  end;
  with Common.TestModelInfo2[DefPocb.CH_2] do begin
   	pnlRobot2ModelCoordX.StyleElements  := [];
    pnlRobot2ModelCoordX.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.X);
   	pnlRobot2ModelCoordY.StyleElements  := [];
    pnlRobot2ModelCoordY.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Y);
   	pnlRobot2ModelCoordZ.StyleElements  := [];
    pnlRobot2ModelCoordZ.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Z);
   	pnlRobot2ModelCoordRx.StyleElements := [];
    pnlRobot2ModelCoordRx.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rx);
   	pnlRobot2ModelCoordRy.StyleElements := [];
    pnlRobot2ModelCoordRy.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Ry);
   	pnlRobot2ModelCoordRz.StyleElements := [];
    pnlRobot2ModelCoordRz.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rz);
  end;
  {$ENDIF}
end;

procedure TfrmMain.MakeMainFrmDIO;
var
  arDioInStr  : array of string; //array[0..Pred(DefDio.MAX_DIO_CNT)] of string //2022-07-15 A2CHv4_#3(
  arDioOutStr : array of string; //array[0..Pred(DefDio.MAX_DIO_CNT)] of string //2022-07-15 A2CHv4_#3(
  itemHeight, itemWidth, itemColumn, ItemPerColumn : Integer;
  marginTop, marginLeft : Integer;
  marginDioInOut : Integer;
  i: Integer;	
begin
  //
  arDioInStr := [
       'S1:RdyBtn'    // 0
      ,'S2:RdyBtn'
      ,'EMO1-F'
      ,'EMO2-R'
      ,'EMO3-In-R'    // 4
      ,'EMO4-In-L'
      ,'EMO5-L'
    {$IFDEF HAS_DIO_IN_DOOR_LOCK}
      ,'S1:Door1L'
      ,'S1:Door2L'    // 8
      ,'S2:Door1L'
      ,'S2:Door2L'
    {$ELSE}
      ,''
      ,''             // 8
      ,''
      ,''
    {$ENDIF}
      ,'S1:Muting'
      ,'S2:Muting'    // 12
      ,'S1:LightC'
      ,'S2:LightC'
      ,'S1:Key-A'
      ,'S1:Key-T'     // 16
      ,'S2:Key-A'
      ,'S2:Key-T'
      ,'S1:Door1O'
      ,'S1:Door2O'     // 20
      ,'S2:Door1O'
      ,'S2:Door2O'
      ,'Cyl-Regul'
      ,'Temper'       // 24
      ,'PowerHigh'
      ,'MC1'
      ,'S1:ShutUP'
      ,'S1:ShutDn'    // 28
      ,'S2:ShutUP'
      ,'S2:ShutDn'
    {$IFDEF HAS_DIO_SCREW_SHUTTER} //2022-07-15 A2CHv4_#3(No ScrewShutter)			
      ,'S1:S.ShuUP'
      ,'S1:S.ShuDn'   // 32
      ,'S2:S.ShuUP'
      ,'S2:S.ShuDn'
    {$ELSE}
      ,''
      ,''             // 32
      ,''
      ,''
    {$ENDIF}			
    {$IFDEF SUPPORT_1CG2PANEL}
      ,'ShuGuideUP'
      ,'ShuGuideDn'   // 36
      ,'CamZPtUP1'
      ,'CamZPtUP2'
      ,'CamZPtDn1'
      ,'CamZPtDn2'    // 40
    {$ELSE}
		  {$IFDEF HAS_DIO_FAN_INOUT_PC} //2022-07-15 A2CHv4_#3(FanInOutPC)
      ,'FanIn-GPC'
      ,'FanOut-GPC'  // 36
      ,'FanIn-DPC'
      ,'FanOut-DPC'			
			{$ELSE}
      ,''
      ,''            // 36
      ,''
      ,''
			{$ENDIF}		
      ,''
			,''            // 40
    {$ENDIF}
    {$IFDEF HAS_DIO_EXLIGHT_DETECT} //2022-07-15 A2CHv4_#3(No ExLightDetectSensor)		
      ,'S1:ExLight'
      ,'S2:ExLight'
		{$ELSE}			
      ,''
			,''
    {$ENDIF}			
      ,'S1:Y-Load'
      ,'S2:Y-Load'    // 44
      ,'S1:Vacuum1'
      ,'S1:Vacuum2'
      ,'S2:Vacuum1'
      ,'S2:Vacuum2'   // 48
    {$IFDEF SUPPORT_1CG2PANEL}
      ,'CamZDOpen'
      ,'CamZDClose'
      ,'S1:AssyJig'
      ,'S2:AssyJig'   // 52
    {$ELSE}
      ,'','','',''
    {$ENDIF}
      ,'MC2'
      ,'Vac-Regul'
    {$IFDEF SUPPORT_1CG2PANEL}
      ,'LoadZPt1'
      ,'LoadZPt2'     // 56
    {$ELSE}
      ,'',''
    {$ENDIF}
      ,'FanIn-L'      // 57
      ,'FanIn-R'      // 58
      ,'FanOut-L'     // 59
      ,'FanOut-R'     // 60
    {$IFDEF HAS_DIO_Y_AXIS_MC}
      ,'S1:YAxisMC'   // 61
      ,'S2:YAxisMC'   // 62
    {$ELSE}
      ,'',''          // 61,62
    {$ENDIF}
      ,'']; // 63

  arDioOutStr := [
       'S1:RdyBLed'   // 0
      ,'S2:RdyBLed'
      ,'ResetBLed'
      ,'S1:KeyUnL'
      ,'S2:KeyUnL'    // 4
      ,'TLampR'
      ,'TLampY'
      ,'TLampG'
      ,'BzMelody1'    // 8
      ,'BzMelody2'
      ,'BzMelody3'
      ,'BzMelody4'
      ,''             // 12
      ,''
      ,'S1:Dr1UnL'
      ,'S1:Dr2UnL'
      ,'S2:Dr1UnL'    // 16
      ,'S2:Dr2UnL'
      ,'S1:ShutUP'
      ,'S1:ShutDn'
      ,'S2:ShutUP'    // 20
      ,'S2:ShutDn'
    {$IFDEF HAS_DIO_SCREW_SHUTTER} //2022-07-15 A2CHv4_#3(No ScrewShutter)			
      ,'S1:S.ShuUP'
      ,'S1:S.ShuDn'
      ,'S2:S.ShuUP'   // 24
      ,'S2:S.ShuDn'
    {$ELSE}
      ,''
			,''
      ,''
			,''			
    {$ENDIF}
    {$IFDEF SUPPORT_1CG2PANEL}
      ,'ShuGuideUP'
      ,'ShuGuideDn'
    {$ELSE}
      ,''
			,''
    {$ENDIF}
      ,'S1:Vacuum1'   // 28
      ,'S1:Vacuum2'
      ,'S2:Vacuum1'
      ,'S2:Vacuum2'
      ,'S1:DestSol1'  // 32
      ,'S1:DestSol2'
      ,'S2:DestSol1'
      ,'S2:DestSol2'
      ,'S1:RbStick+'  // 36
      ,'S1:RbStick-'
      ,'S1:Rb-M/A'
      ,'S1:Rb-Pause'
      ,'S1:Rb-Stop'   // 40
      ,'S2:RbStick+'
      ,'S2:RbStick-'
      ,'S2:Rb-M/A'
      ,'S2:Rb-Pause'  // 44
      ,'S2:Rb-Stop'
      ,'RbRstBLed'
    {$IFDEF POCB_A2CHv3}
      ,'AirKnife'     // 47
      ,''             // 48
    {$ELSE}
      ,'S1:AirKnife'  // 47
      ,'S2:AirKnife'  // 48
    {$ENDIF}
    {$IFDEF HAS_DIO_PG_OFF}
      ,'S1:PG-OFF'    // 49
      ,'S2:PG-OFF'    // 50
    {$ELSE}
      ,'',''          // 49~50
    {$ENDIF}
    {$IFDEF HAS_DIO_Y_AXIS_MC}
      ,'S1:YAxisMC'   // 51
      ,'S2:YAxisMC'   // 52
    {$ELSE}
      ,'',''          // 51,52
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_STAGE_LAMP}
      ,'S1:SLampOff'  // 53
      ,'S2:SLampOff'  // 54
    {$ELSE}
      ,'',''          // 53,54
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_IONBAR}
      ,'S1:IonBarON' // 55
      ,'S2:IonBarON' // 56
    {$ELSE}
      ,'',''          // 55,56
    {$ENDIF}
      ,'','','','' ,'','','']; // 57~63

  //
  {$IFDEF HAS_DIO_EXLIGHT_DETECT}	
  if (not Common.SystemInfo.HasDioExLightDetect) then begin //2022-07-15 A2CHv4_#3(No ExLightDetectSensor)
    arDioInStr[DefDio.IN_STAGE1_EXLIGHT_DETECT] := '';
    arDioInStr[DefDio.IN_STAGE2_EXLIGHT_DETECT] := '';
  end;
	{$ENDIF}
	
  {$IFDEF HAS_DIO_FAN_INOUT_PC}	
  if (not Common.SystemInfo.HasDioFanInOutPC) then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
    arDioInStr[DefDio.IN_MAINPC_FAN_IN]  := '';
    arDioInStr[DefDio.IN_MAINPC_FAN_Out] := '';
    arDioInStr[DefDio.IN_CAMPC_FAN_IN]   := '';
    arDioInStr[DefDio.IN_CAMPC_FAN_Out]  := '';
  end;
	{$ENDIF}
	
  {$IFDEF HAS_DIO_SCREW_SHUTTER}	
  if (not Common.SystemInfo.HasDioScrewShutter) then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
    arDioInStr[DefDio.IN_STAGE1_SCREW_SHUTTER_UP]     := '';
    arDioInStr[DefDio.IN_STAGE1_SCREW_SHUTTER_DOWN]   := '';
    arDioInStr[DefDio.IN_STAGE2_SCREW_SHUTTER_UP]     := '';
    arDioInStr[DefDio.IN_STAGE2_SCREW_SHUTTER_DOWN]   := '';
    arDioOutStr[DefDio.OUT_STAGE1_SCREW_SHUTTER_UP]   := '';
    arDioOutStr[DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN] := '';
    arDioOutStr[DefDio.OUT_STAGE2_SCREW_SHUTTER_UP]   := '';
    arDioOutStr[DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN] := '';
  end;
	{$ENDIF}
  if (not Common.SystemInfo.HasDioVacuum) then begin  //ATO(False),ATO-TRIBUTO(True) //2023-04-10
    arDioInStr[DefDio.IN_STAGE1_VACUUM1]   := '';
    arDioInStr[DefDio.IN_STAGE1_VACUUM2]   := '';
    arDioInStr[DefDio.IN_STAGE2_VACUUM1]   := '';
    arDioInStr[DefDio.IN_STAGE2_VACUUM2]   := '';
    arDioInStr[DefDio.IN_VACUUM_REGULATOR] := '';
    arDioOutStr[DefDio.OUT_STAGE1_VACUUM1] := '';
    arDioOutStr[DefDio.OUT_STAGE1_VACUUM2] := '';
    arDioOutStr[DefDio.OUT_STAGE2_VACUUM1] := '';
    arDioOutStr[DefDio.OUT_STAGE2_VACUUM2] := '';
    arDioOutStr[DefDio.OUT_STAGE1_DESTRUCTION_SOL1] := '';
    arDioOutStr[DefDio.OUT_STAGE1_DESTRUCTION_SOL2] := '';
    arDioOutStr[DefDio.OUT_STAGE2_DESTRUCTION_SOL1] := '';
    arDioOutStr[DefDio.OUT_STAGE2_DESTRUCTION_SOL2] := '';
  end;
  //
  {$IFDEF HAS_DIO_PG_OFF}
  if (not Common.SystemInfo.HasDioOutPGOff) then begin  //ATO|GA~
    arDioOutStr[DefDio.OUT_PG1_OFF] := '';
    arDioOutStr[DefDio.OUT_PG2_OFF] := '';
  end;
  {$ENDIF}
  //
  {$IFDEF HAS_DIO_IN_DOOR_LOCK}
  if (not Common.SystemInfo.HasDioInDoorLock) then begin //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    arDioInStr[DefDio.IN_STAGE1_DOOR1_LOCK] := '';
    arDioInStr[DefDio.IN_STAGE1_DOOR2_LOCK] := '';
    arDioInStr[DefDio.IN_STAGE2_DOOR1_LOCK] := '';
    arDioInStr[DefDio.IN_STAGE2_DOOR2_LOCK] := '';
  end;
  {$ENDIF}
  //
  {$IFDEF HAS_DIO_Y_AXIS_MC}
  if (not Common.SystemInfo.HasDioYAxisMC) then begin //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    arDioInStr[DefDio.IN_STAGE1_Y_AXIS_MC] := '';
    arDioInStr[DefDio.IN_STAGE2_Y_AXIS_MC] := '';
    arDioOutStr[DefDio.OUT_STAGE1_Y_AXIS_MC_ON] := '';
    arDioOutStr[DefDio.OUT_STAGE2_Y_AXIS_MC_ON] := '';
  end;
  {$ENDIF}
  //
  {$IFDEF HAS_DIO_OUT_STAGE_LAMP}
  if (not Common.SystemInfo.HasDioOutStageLamp) then begin //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    arDioOutStr[DefDio.OUT_STAGE1_STAGE_LAMP_OFF] := '';
    arDioOutStr[DefDio.OUT_STAGE2_STAGE_LAMP_OFF] := '';
  end;
  {$ENDIF}
  //
  {$IFDEF HAS_DIO_OUT_IONBAR}
  if (not Common.SystemInfo.HasDioOutIonBar) then begin //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    arDioOutStr[DefDio.OUT_STAGE1_IONBAR_ON] := '';
    arDioOutStr[DefDio.OUT_STAGE2_IONBAR_ON] := '';
  end;
  {$ENDIF}

  //
  SetLength(ledDioIn,DefDio.MAX_DIO_CNT);
  SetLength(ledDioOut,DefDio.MAX_DIO_CNT);
  //
  marginDioInOut := 22;
  ItemPerColumn  := 21;
  itemHeight := 11;
  itemWidth  := (RzpnlMainFrmInfo.Width div 6) - 2;     //A2CHv3
  marginTop  := 1;
  marginLeft := 1;
  //
  PnlDioInTitle := TPanel.Create(Self);
  with PnlDioInTitle do begin
    Parent          	:= RzgrpDIO;
    Top             	:= marginDioInOut + marginTop - 4;
    Left            	:= marginLeft;
    Height          	:= itemHeight;
    Width           	:= itemWidth*3 + marginLeft*2;  //A2CHv3
   	StyleElements     := [];
    ParentBackground  := False;
    Color             := clBtnFace;
    Font.Size         := 7;
    Font.Style        := [fsBold];
    Caption         	:= 'DIO-IN';
  end;
  PnlDioOutTitle := TPanel.Create(Self);
  with PnlDioOutTitle do begin
    Parent          	:= RzgrpDIO;
    Top             	:= PnlDioInTitle.Top;
    Left            	:= PnlDioInTitle.Left + PnlDioInTitle.Width + 4;
    Height          	:= itemHeight;
    Width           	:= itemWidth*3 + marginLeft*2;
   	StyleElements     := [];
    ParentBackground  := False;
    Color             := clBtnFace;
    Font.Size         := 7;
    Font.Style        := [fsBold];
    Caption         	:= 'DIO-OUT';
  end;
  //
  itemHeight := 10;
//itemColumn := 0;
  for i := 0 to Pred(MAX_DIO_CNT) do begin  //F2CH: Pred(DefDio.MAX_DIO_CNT) -> MAX_DIO_IN
    if i <= DefDio.MAX_DIO_IN then begin
      itemColumn  := i div ItemPerColumn;  //A2CHv3
      ledDioIn[i] := TTILed.Create(nil);
      with ledDioIn[i] do begin
        Parent              := RzgrpDIO;
        Alignment           := taLeftJustify;
        if (i < ItemPerColumn) then begin
          Top               := marginDioInOut + (i+1)*(itemHeight+marginTop);
          Left              := marginLeft;
        end
        else begin
          Top               := marginDioInOut + ((i mod ItemPerColumn) + 1)*(itemHeight+marginTop);
          Left              := marginLeft + (itemWidth+1)*itemColumn;
        end;
        Height              := itemHeight;
        Width               := itemWidth;
       	StyleElements       := [];
        FullRepaint         := True;
        LedFadeSpeed        := 20;
        LedDelayBeforeFade  := 100;
        LedSmoothFlash      := True;
        LedColor            := Yellow;
        ParentBackground    := False;
        Color               := clGreen;
        Font.Size           := 6;
        Font.Style          := [fsBold];
        Enabled             := True;
        Visible             := True;
        LedOn               := False;
        Caption             := Trim(arDioInStr[i]);
      end;
    end;
    if i <= DefDio.MAX_DIO_OUT then begin
      itemColumn   := i div ItemPerColumn;  //A2CHv3
      ledDioOut[i] := TTILed.Create(nil);
      with ledDioOut[i] do begin
        Parent              := RzgrpDIO;
        Alignment           := taLeftJustify;
        if (i < ItemPerColumn) then begin
          Top               := marginDioInOut + (i+1)*(itemHeight+marginTop);
          Left              := PnlDioOutTitle.Left;
        end
        else begin
          Top               := marginDioInOut + ((i mod ItemPerColumn) + 1)*(itemHeight+marginTop);
          Left              := PnlDioOutTitle.Left + (itemWidth+1)*itemColumn;
        end;
        Height              := itemHeight;
        Width               := itemWidth;
       	StyleElements       := [];
        FullRepaint         := True;
        LedFadeSpeed        := 20;
        LedDelayBeforeFade  := 100;
        LedSmoothFlash      := True;
        LedColor            := Yellow;
        ParentBackground    := False;
        Color               := clGreen;
        Font.Size           := 6;
        Font.Style          := [fsBold];
        Enabled             := True;
        Visible             := True;
        LedOn               := False;
        Caption             := Trim(arDioOutStr[i]);
      end;
    end;
  end;

end;

procedure TfrmMain.MakeMainFrmSysStGrp;
var
  nCbProcMaskWidth : Integer;
begin
  m_nHeightSysGrp  := 60;
  nCbProcMaskWidth := 110;

  if pnlMainFrmSysStGrp <> nil then Exit;

  // (Group) System Status
  pnlMainFrmSysStGrp := TPanel.Create(Self); //2023-09-20
  with pnlMainFrmSysStGrp do begin
    Parent            := Self;
    Align             := alNone;
    Top               := RzstsbrMainFrmx.Top - m_nHeightSysGrp;
    Left              := RzpnlMainFrmInfo.Width + 3;
    Height            := m_nHeightSysGrp;
    Width             := (Self.Width - RzpnlMainFrmInfo.Width);
    StyleElements   	:= [];
    ParentBackground	:= False;
    Color             := clBlack;
    ShowHint          := True;
    Hint              := 'System Status';
    Visible           := True;
  end;

  // (Group) System Status - MES Status
  pnlMainSysMesOffline := TPanel.Create(Self); //2023-09-20
  with pnlMainSysMesOffline do begin
   	Parent            := pnlMainFrmSysStGrp;
    Align             := alNone;
   	Alignment         := taCenter;
    Top               := 0;
   	Left              := 3;
   	Height            := pnlMainFrmSysStGrp.Height;
   	Width             := (pnlMainFrmSysStGrp.Width div 2) - 12;
    StyleElements   	:= [];
    ParentBackground	:= False;
    Color             := clRed;
    Font.Color        := clYellow;
    Font.Size         := 22;
    Font.Style        := [fsBold];
    ShowHint          := True;
    Hint              := 'MES Status (Online/Offline)';
    Caption           := 'MES OFFLINE_MODE';
    Visible           := True;
  end;

  // (Group) System Status - Process Masking Status
  {$IFDEF PANEL_AUTO}
  pnlMainSysProcMaskGrp := TPanel.Create(Self); //2023-09-20
  with pnlMainSysProcMaskGrp  do begin
   	Parent            := pnlMainFrmSysStGrp;
    Align             := alNone;
   	Top               := pnlMainSysMesOffline.Top;
   	Left              := pnlMainSysMesOffline.Left + pnlMainSysMesOffline.Width;
   	Height            := pnlMainSysMesOffline.Height;
   	Width             := pnlMainSysMesOffline.Width - 3;
    StyleElements   	:= [];
    ParentBackground	:= False;
   	Color             := clBlack;
    Hint              := 'Process Masking Status';
    Visible           := True;
  end;
  // ------ Process Masking Skip Status
  pnlMainSysProcMaskSkip := TPanel.Create(Self); //2023-09-20
  with pnlMainSysProcMaskSkip  do begin
   	Parent            := pnlMainSysProcMaskGrp;
    Align             := alNone;
   	Alignment         := taCenter;
   	Top               := 0;
   	Left              := 0;
   	Height            := pnlMainSysProcMaskGrp.Height;
   	Width             := pnlMainSysProcMaskGrp.Width - nCbProcMaskWidth;
    StyleElements   	:= [];
    ParentBackground	:= False;
   	Color             := clRed;
   	Font.Color        := clYellow;
   	Font.Size         := 22;
    Font.Style        := [fsBold];
    ShowHint          := True;
    Hint              := 'Process Masking Skip Status';
    Caption           := 'PROCESS_MASKING_SKIP';
    Visible           := False;
  end;
  // ------ Process Masking Skip Checkbox
  cbMainSysProcMaskSkip := TRzCheckBox.Create(Self);
  with cbMainSysProcMaskSkip do begin
  	Parent         		:= pnlMainSysProcMaskGrp;
    Align             := alNone;
    AlignWithMargins  := True;
    AlignmentVertical := TAlignmentVertical(avCenter);
    AutoSize          := False;
  	Top            		:= pnlMainSysProcMaskGrp.Top + 2;
  	Left           		:= pnlMainSysProcMaskSkip.Width + 2;
  	Height         		:= pnlMainSysProcMaskGrp.Height - 4;
    Width             := pnlMainSysProcMaskGrp.Width - pnlMainSysProcMaskSkip.Width;
    WordWrap          := True;
  	StyleElements   	:= [];
  	Font.Color     		:= clBtnFace;
  	Font.Size      		:= 10;
  	Font.Style     		:= [fsBold];
  	ShowHint       		:= True;
  	Hint           		:= 'Process Masking Skip Option';
  	Caption        		:= 'SKIP Process Masking';
    State             := cbUnchecked;
   	Cursor         		:= crHandPoint;
	  OnClick        		:= cbMainSysProcMaskSkipClick;
    Visible           := True;
	end;
  {$ENDIF} //LENSVN

  //
  tmrMainFrmSysStBlink := TTimer.Create(nil);
  tmrMainFrmSysStBlink.OnTimer  := tmrMainFrmSysStBlinkTimer;
  tmrMainFrmSysStBlink.Interval := 1000;
  tmrMainFrmSysStBlink.Enabled  := False;
end;

procedure TfrmMain.tmrMainFrmSysStBlinkTimer(Sender: TObject); //2023-09-20
begin
  if Common.m_bMesOnline then begin
    tmrMainFrmSysStBlink.Enabled := False; // STOP Blinking
  end
  else begin
    pnlMainSysMesOffline.Visible := (not pnlMainSysMesOffline.Visible);
    if Common.m_bPmModeProcMaskSkip then begin
    //pnlMainSysProcMaskSkip.Visible := (not pnlMainSysProcMaskSkip.Visible);
      pnlMainSysProcMaskSkip.Visible := pnlMainSysMesOffline.Visible;
    end;
  end;
end;

procedure TfrmMain.cbMainSysProcMaskSkipClick(Sender: TObject); //2023-09-20
begin
  {$IFDEF PANEL_AUTO}
  if Common.m_bMesOnline or (Common.m_sUserId <> 'PM') then begin
    Common.m_bPmModeProcMaskSkip := False;
    Exit;
  end;

  // MES OFFLINE and UserId='PM'
  Common.m_bPmModeProcMaskSkip   := cbMainSysProcMaskSkip.Checked;
  pnlMainSysProcMaskSkip.Visible := cbMainSysProcMaskSkip.Checked;
  {$ENDIF}
end;

//******************************************************************************
// procedure/function: GUI(Menu Button Action)
//******************************************************************************

procedure TfrmMain.btnLogInClick(Sender: TObject);
var
  nJig, nCh : Integer;
begin
  //Common.MLog(DefPocb.SYS_LOG,'TfrmMain.btnLogInClick');
  if CheckPgRun then Exit;

  //if DisplayLogIn = mrCancel then Exit;

  if (btnLogIn.Caption = 'Log Out') then begin
    if not TfrmLogIn.CheckAdminPasswd then Exit;
    Common.m_sUserId   := 'PM';
  end
  else begin
    if DisplayLogIn = mrCancel then Exit;
  end;

  if UpperCase(Common.m_sUserId) = 'PM' then begin
    UpdateMainFrmMesStatus(MesStatus_OFFLINE); //!!!
   	//
    if (DongaGmes <> nil) then begin
      DongaGmes.Free;
      DongaGmes := nil;
    end;
  end
  else begin
{$IFDEF SITE_LENSVN}
    if DongaGmes = nil then begin
			InitGmes;
		end;
    DongaGmes.MesUserId   := Common.m_sUserId;
    DongaGmes.MesUserPwd  := Common.m_sUserPwd;
    DongaGmes.MesUserName := '';
  //Common.ThreadTask( procedure begin
      DongaGmes.SendLoginPost(DongaGmes.MesUserId, DongaGmes.MesUserPwd);
      if DongaGmes.LensHttpData.MesToken.token <> '' then begin // Login OK
        DongaGmes.SendHostStatus(DefPocb.CH_1{dummy}, LENS_MES_STATUS_IDLE{nEqStValue}, True{bForce}); //2023-08-21 LENS:MES:EQSTATUS:Warn:Login
        UpdateMainFrmMesStatus(MesStatus_ONLINE); //!!!
      end
      else begin
        UpdateMainFrmMesStatus(MesStatus_OFFLINE, True{bMesLoginFailed}); //!!!
      end;
  //end);
{$ELSE} //LGD
    if DongaGmes <> nil then begin
      DongaGmes.MesUserId := Common.m_sUserId;
      if not DongaGmes.MesEayt then DongaGmes.SendHostUchk
      else                          DongaGmes.SendHostEayt;
    end
    else begin
      InitGmes;
    end;
{$ENDIF}
    //
    for nJig := DefPocb.JIG_A to DefPocb.JIG_MAX do begin
      if frmTest1Ch[nJig] <> nil then DongaGmes.hTestHandle[nJig] := frmTest1Ch[nJig].Handle;  //2018-12-14
    end;
  end;

{$IFDEF DFS_HEX}
  if DfsFtpCommon <> nil then begin
    DfsFtpCommon.Free;
    DfsFtpCommon := nil;
  end;
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    if DfsFtpCh[nCh] <> nil then begin
      DfsFtpCh[nCh].Free;
      DfsFtpCh[nCh] := nil;
    end;
  end;
  InitDfs; //!!!
{$ENDIF}

{$IFDEF  REF_ISPD_L}
  for nJig := DefPocb.JIG_A to DefPocb.JIG_MAX do begin
    frmTest1Ch[nJig].ClearQuantity(0);
  end;
{$ENDIF}
end;

procedure TfrmMain.btnModelChangeClick(Sender: TObject);
var
  bChangeModel : Boolean;
  nJig, nCh    : Integer;
begin
  if CheckPgRun then Exit;
  if not TfrmLogIn.CheckAdminPasswd then Exit;
  frmSelectModel := TfrmSelectModel.Create(Self);
  try
    frmSelectModel.ShowModal;
  finally
    bChangeModel := frmSelectModel.m_bClickOkBtn;
    frmSelectModel.Free;
    frmSelectModel := nil;
  end;

  if bChangeModel then begin
{$IFDEF REF_ISPD}
    sDebug := '[Click Event] M/C : Old Model - '+sOldModel +' ===> New Model - ' + Common.SystemInfo.TestModel;
    for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do Common.MLog(nCh,sDebug);
    // Fusing model Data.
    Common.LoadModelInfo(Common.SystemInfo.TestModel);
    frmModelDownload := TfrmModelDownload.Create(Self);
    try
      frmModelDownload.ShowModal;
    finally
      frmModelDownload.Free;
      frmModelDownload := nil;
    end;
    InitialAll;
{$ENDIF}

    DisplayModelInfo;
    for nJig := DefPocb.JIG_A to DefPocb.JIG_MAX do begin
      frmTest1Ch[nJig{TBD? old:DefPocb.JIG_B}].UpdatePtList(Self.Handle);;  //TBD:A2CH? PatList?    //TBD:A2CHv3:MULTIPLE_MODEL?
    end;

    for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      //TBD:MERGE? NOT-USED? Common.MakeModelData(nCh, Common.SystemInfo.TestModel[nCh]);  //TBD? (MakeModelData에 대한 Return값 처리가 없는데...)
      if Logic[nCh] = nil then Continue;    //2018-11-15 (Exception 방지?)
      Common.SendModelData(nCh);
    end;
    CameraComm.SetModelSet;
    Sleep(1000);  //2019-03-29
    InitAll(False);      //2019-03-29
  end;
end;

procedure TfrmMain.btnModelClick(Sender: TObject);
var
  nCh   : Integer;
{$IFDEF DFS_EXTRA}
  nMode : Integer;
{$ENDIF}
begin
{$IFDEF DFS_EXTRA}
  if pnlCombiModelRCP.Caption = '' then nMode := 0
  else                                  nMode := 1;
  if TfrmLogIn.CheckAdminPasswd(nMode) then begin
    if (nMode = 1) and (not Common.CombiCodeData.bAuthority) then begin
      ShowMessage('It can access only administrator');
      Exit;
    end;
{$ELSE}
  if TfrmLogIn.CheckAdminPasswd then begin
{$ENDIF}
    //Common.MLog(DefPocb.SYS_LOG,'TfrmMain.btnModelClick');
    if Common.SystemInfo.UIType <> DefPocb.UI_WIN10_NOR then TStyleManager.SetStyle('Windows');

    frmModelInfo := TfrmModelInfo.Create(nil);
    try
      frmModelInfo.ShowModal;
    finally
      Freeandnil(frmModelInfo);
    end;

    for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      Common.LoadModelInfo(nCh,Common.SystemInfo.TestModel[nCh]);  //TBD:A2CHv3:MULTIPLE_MODEL?
    end;

    if Common.m_bNeedInitial {or (Common.SystemInfo.UIType <> DefPocb.UI_WIN10_NOR)} then begin
      InitAll(False);
    end;
    DisplayModelInfo;
  end;
end;

procedure TfrmMain.btnShowAlarmClick(Sender: TObject);
begin
  //Common.MLog(DefPocb.SYS_LOG,'<FrmMain> SHOW ALARM');
  if Common.SystemInfo.UIType <> DefPocb.UI_WIN10_NOR then TStyleManager.SetStyle('Windows');
  frmAlarm := TfrmAlarm.Create(Self);
  try
    frmAlarm.ShowModal;
  finally
    frmAlarm.Free;
    frmAlarm := nil;
  end;
end;

procedure TfrmMain.btnShowSatetyAlarmMotionClick(Sender: TObject);
begin
  PnlAlarmMotionControl.Top  := frmMain.Height - PnlAlarmMotionControl.Height - 200;
  PnlAlarmMotionControl.Left := frmMain.Width  - PnlAlarmMotionControl.Width  - 50;
  PnlAlarmMotionControl.Visible := True;
end;

procedure TfrmMain.btnShowWorkingMsgClick(Sender: TObject);
var
  frmSafetyMsg : TFrmSafetyMsg;
begin
  frmSafetyMsg := TFrmSafetyMsg.Create(Application);
  frmSafetyMsg.Show;
end;

procedure TfrmMain.btnStationClick(Sender: TObject);
{$IFDEF DFS_EXTRA}
var
  nMode : Integer;
{$ENDIF}
begin
{$IFDEF DFS_EXTRA}
  if pnlCombiModelRCP.Caption = '' then nMode := 0
  else                                  nMode := 1;
  if TfrmLogIn.CheckAdminPasswd(nMode) then begin
    if (nMode = 1) and (not Common.CombiCodeData.bAuthority) then begin
      ShowMessage('It can access only administrator');
      Exit;
    end;
{$ELSE}
  if TfrmLogIn.CheckAdminPasswd then begin
{$ENDIF}
    if Common.SystemInfo.UIType <> DefPocb.UI_WIN10_NOR then TStyleManager.SetStyle('Windows');
    frmSystemSetup := TfrmSystemSetup.Create(Self);
    try
      frmSystemSetup.ShowModal;
    finally
      frmSystemSetup.Free;
      frmSystemSetup := nil;
    end;
    if Common.m_bNeedInitial {or (Common.SystemInfo.UIType <> DefPocb.UI_WIN10_NOR)} then begin
      InitAll(False);
    end;
  end;
end;

procedure TfrmMain.btnMaintClick(Sender: TObject);
begin
  if TfrmLogIn.CheckAdminPasswd then begin
    if Common.SystemInfo.UIType <> DefPocb.UI_WIN10_NOR then TStyleManager.SetStyle('Windows');
    frmMainter := TfrmMainter.Create(Application);
//    Common.Mlog('[PGM] Mainter Click!');
    try
    //{$IFNDEF SIMULATOR}
      PnlAlarmMotionControl.Visible := False;  //2019-03-29
    //{$ENDIF}
      GrpSystemNgMsg.Visible        := False;  //2019-03-29
      frmMainter.ShowModal;
    finally
      CameraComm.OnCamConnection := ShowCamConnStatus;
      CameraComm.m_hTest[DefPocb.CAM_1] := frmTest1Ch[DefPocb.JIG_A].Handle; //2019-01-17 INSERT
      CameraComm.m_hTest[DefPocb.CAM_2] := frmTest1Ch[DefPocb.JIG_B].Handle; //2019-01-17 INSERT
      frmMainter.Free;
      frmMainter := nil;
    end;
    PnlAlarmMotionControl.Top  := frmMain.Height - PnlAlarmMotionControl.Height - 200; //2019-03-29
    PnlAlarmMotionControl.Left := frmMain.Width  - PnlAlarmMotionControl.Width - 50;   //2019-03-29
    PnlAlarmMotionControl.Visible := True;  //2019-03-29 TBD:ALARM:GUI?
    if lblSystemNgMsg.Caption <> '' then GrpSystemNgMsg.Visible := True;  //2019-03-29 //2019-03-29 TBD:ALARM:GUI?
    if Common.SystemInfo.UIType <> DefPocb.UI_WIN10_NOR then begin
      InitWindowUIType;
    end;
  end;
end;

procedure TfrmMain.btnInitClick(Sender: TObject);
var
  sMsg, sDebug : string;
begin
  m_bExitOrInit := True; //2019-01-16
  case Common.SystemInfo.Language of
    DefPocb.LANGUAGE_KOREA : begin
      //sMsg := #13#10 + '초기화 하시겠습니까?';
      sMsg := #13#10 + 'Are you sure to initialize this Program?';
    end;
    DefPocb.LANGUAGE_VIETNAM : begin
      sMsg := #13#10 + 'bạn có muốn khởi tạo chương trình không?';
    end
    else begin
      sMsg := #13#10 + 'Are you sure to initialize this Program?';
    end;
  end;
  if MessageDlg(sMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    sDebug := '#################### INITIAL(EXE): ' + Common.m_sExeVerNameLog;
    Common.MLog(DefPocb.CH_1,sDebug);
    Common.MLog(DefPocb.CH_2,sDebug);
    Common.MLog(DefPocb.SYS_LOG,sDebug);

    InitAll(False);
  end;
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
var
  sDebug : string;
begin
  if not TfrmLogIn.CheckAdminPasswd then Exit;
  //
  sDebug := '#################### EXIT(EXE): ' + Common.m_sExeVerNameLog;
  Common.MLog(DefPocb.CH_1,sDebug);
  Common.MLog(DefPocb.CH_2,sDebug);
  Common.MLog(DefPocb.SYS_LOG,sDebug);

  m_bExitOrInit := True; //2019-01-16

//2023-0823 Delete(at FromCloseQuery)!!!  FreeAll

  Close;
end;

procedure TfrmMain.btnKoreanClick(Sender: TObject);
begin
  Common.SystemInfo.Language := DefPocb.LANGUAGE_KOREA;

  SetLanguageMain(Common.SystemInfo.Language);
{$IFDEF REF_XXXXX}
  for i := DefPocb.JIG_A to DefPocb.JIG_B do begin
    if frmTest1Ch[i] <> nil then begin
      frmTest1Ch[i].SetLanguage(common.SystemInfo.Language);
    end;
  end;
{$ENDIF}
end;

procedure TfrmMain.btnVietnamClick(Sender: TObject);
begin
  Common.SystemInfo.Language := DefPocb.LANGUAGE_VIETNAM;
  SetLanguageMain(Common.SystemInfo.Language);
{$IFDEF REF_XXXXX}
  for i := DefPocb.JIG_A to DefPocb.JIG_B do begin
    if frmTest1Ch[i] <> nil then begin
      frmTest1Ch[i].SetLanguage(common.SystemInfo.Language);
    end;
  end;
{$ENDIF}
end;

procedure TfrmMain.Btn_M_INFOClick(Sender: TObject);
begin
  AlphaBlendValue := 100;
  Frm_M_INFO.Show;
end;

procedure TfrmMain.SetLanguageMain(nIdx: Integer);
begin
  case nIdx of
    DefPocb.LANGUAGE_KOREA : begin
//      btnLogIn.Caption := '로그인';
      btnModelChange.Caption := '모델 변경';
      btnModel.Caption := '모델 정보';
      btnMaint.Caption := '메인트';
      btnStation.Caption := '환경 설정';
      btnInit.Caption := '초기화';
      btnExit.Caption := '종료';
    end;
    DefPocb.LANGUAGE_VIETNAM : begin
//      btnLogIn.Caption := 'đăng nhập';
      btnModelChange.Caption := 'thay đổi Model';
      btnModel.Caption := 'Model Info';
      btnMaint.Caption := 'Maint';
      btnStation.Caption := 'cấu hình';
      btnInit.Caption := 'khởi tạo';
      btnExit.Caption := 'Lối thoát';
    end;
  end;
end;


//******************************************************************************
// procedure/function: Sub (Common)
//******************************************************************************

procedure TfrmMain.InitWindowUIType;
begin
  case Common.SystemInfo.UIType of
    DefPocb.UI_WIN10_NOR   : TStyleManager.SetStyle('Windows10');
    DefPocb.UI_WIN10_BLACK : TStyleManager.SetStyle('Windows10 Dark')
    else begin
      TStyleManager.SetStyle('Windows');
    end;
  end;
  Self.WindowState := wsMaximized;
  Self.Caption := Common.m_sExeVerNameLog;
  //
  Common.TaskBar(True);
  //
  //TBD? pnlStLocalIp.Caption := Common.GetLocalIpList;
  //TBD? SetLanguageMain(Common.SystemInfo.Language);  //TBD?: PocbAuto(O) ISPD(X)
end;

function TfrmMain.CheckPgRun: Boolean;
var
  i     : Integer;
  bRtn  : Boolean;
  sData : string;
begin
  bRtn := False;  sData := '';
  for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    if Logic[i] <> nil then begin
{$IFDEF REF_SDIP}
      if Logic[i].m_InsStatus = IsRun then begin
{$ELSE}
      if Logic[i].m_InsStatus <> IsStop then begin
{$ENDIF}
        bRtn  := True;
        sData := sData + Format('PG-%X ',[i+9]);
      end;
    end;
  end;
  if bRtn then begin
    if Common.SystemInfo.Language = DefPocb.LANGUAGE_KOREA then begin
      ShowMessage(sData + 'is working. please stop the PG.(PG가 동작중입니다)');
    end
    else begin
      ShowMessage(sData + 'is working. please stop the PG.(PG đi vào hoạt động)');
    end;
  end;
  Result := bRtn;
end;

function TfrmMain.DisplayLogIn: Integer;
var
  nRtn : Integer;
begin
  UserIdDlg := TUserIdDlg.Create(Application);
  try
    nRtn := UserIdDlg.ShowModal;
  finally
    UserIdDlg.Free;
    UserIdDlg := nil;
  end;
	Result := nRtn;
end;

procedure TfrmMain.DisplayModelInfo;
var
  bIsAlarmOn   : Boolean;
  sPocbSysType : string;
begin
{$IF Defined(POCB_A2CHv3)}
  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then sPocbSysType := 'PUC (1CG 1Panel)' //2022-07-15
  else                                      sPocbSysType := 'ASSY-PUC (1CG 2Panel)';
	{$ELSE}
  sPocbSysType := 'PUC';
  {$ENDIF}
{$ELSEIF Defined(POCB_A2CHv4)}
  sPocbSysType := 'PUC (VH Line#2)'; //2022-07-15
{$ELSEIF Defined(POCB_ATO)}
  sPocbSysType := 'PUC (ATO)';
{$ELSEIF Defined(POCB_GAGO)}
  sPocbSysType := 'PUC (GAGO)';
{$ELSE}
  sPocbSysType := 'PUC';
{$ENDIF}
  pnlAssyPocbInfo.Caption := sPocbSysType;

{$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then pnlAssyPocbInfo.Color := clBlack
  else                                      pnlAssyPocbInfo.Color := clGreen;
{$ELSE}
	pnlAssyPocbInfo.Color := clBlack;
{$ENDIF}
  //
  if Common.SystemInfo.UseGRR then begin
    pnlSysinfoUseGIB.Caption  := 'GRR';
    pnlSysinfoUseGIB.Visible  := True;
  end
  else begin
    if Common.SystemInfo.UseGIB then begin  //2019-11-08
      pnlSysinfoUseGIB.Caption  := 'GIB';
      pnlSysinfoUseGIB.Visible  := True;
    end
    else begin
      pnlSysinfoUseGIB.Caption  := 'GIB';
      pnlSysinfoUseGIB.Visible  := False;
    end;
  end;
  //

{$IFDEF DFS_HEX}
  if Common.DfsConfInfo.bUseDfs then begin
    RzgrpDFS.visible := True;
    //
    pnlCombiModelRCPCh1.Caption  := Common.CombiCodeData.sRcpName[DefPocb.CH_1];   //A2CHv3:MULTIPLE_MODEL
    pnlCombiProcessNoCh1.Caption := Common.CombiCodeData.sProcessNo[DefPocb.CH_1];
    pnlCombiRouterNoCh1.Caption  := IntToStr(Common.CombiCodeData.nRouterNo[DefPocb.CH_1]);
    //
    pnlCombiModelRCPCh2.Caption  := Common.CombiCodeData.sRcpName[DefPocb.CH_2];
    pnlCombiProcessNoCh2.Caption := Common.CombiCodeData.sProcessNo[DefPocb.CH_2];
    pnlCombiRouterNoCh2.Caption  := IntToStr(Common.CombiCodeData.nRouterNo[DefPocb.CH_2]);
  end
  else begin
    RzgrpDFS.visible := False;
  end;
{$ENDIF}
  //
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  with Common.TestModelInfo do begin
    pnlModelPatGrp.Caption        := PatGrpName;
    pnlModelResolution.Caption    := Format('%d x %d',[H_Active, V_Active]);
    pnlModelVolVcc.Caption        := Format('%0.2f V',[PWR_VOL[DefPG.PWR_VCC]/1000]);
    pnlModelVolElvdd.Caption      := Format('%0.2f V',[PWR_VOL[DefPG.PWR_ELVDD]/1000]);
  end;
  with Common.TestModelInfo2 do begin
    pnlModelBcrLen.Caption        := IntToStr(BcrLength);
    pnlModelBcrLen.Font.Color     := clBlack;
  end;
{$ELSE}
  //
  with Common.TestModelInfo[DefPocb.CH_1] do begin
    pnlModelPatGrpCh1.Caption     := PatGrpName;
    pnlModelResolutionCh1.Caption := Format('%d x %d',[H_Active, V_Active]);
    pnlModelVolVccCh1.Caption     := Format('%0.2f V',[PWR_VOL[DefPG.PWR_VCC]/1000]);
    pnlModelVolVddCh1.Caption     := Format('%0.2f V',[PWR_VOL[DefPG.PWR_VDD_VEL]/1000]);
  end;
  with Common.TestModelInfo[DefPocb.CH_2] do begin
    pnlModelPatGrpCh2.Caption     := PatGrpName;
    pnlModelResolutionCh2.Caption := Format('%d x %d',[H_Active, V_Active]);
    pnlModelVolVccCh2.Caption     := Format('%0.2f V',[PWR_VOL[DefPG.PWR_VCC]/1000]);
    pnlModelVolVddCh2.Caption     := Format('%0.2f V',[PWR_VOL[DefPG.PWR_VDD_VEL]/1000]);
  end;
  //
  with Common.TestModelInfo2[DefPocb.CH_1] do begin
    pnlModelBcrLenCh1.Caption     := IntToStr(BcrLength);
    pnlModelBcrLenCh1.Font.Color  := clBlack;
    if (BcrPidChkIdx > 0) and (Length(BcrPidChkStr) > 0) then pnlModelBcrChkCh1.Caption := Format('%d,%s',[BcrPidChkIdx,BcrPidChkStr])
    else                                                      pnlModelBcrChkCh1.Caption := '';
    pnlModelBcrChkCh1.Font.Color  := clBlack;
    {$IFDEF SUPPORT_1CG2PANEL}
    if (not Common.SystemInfo.UseAssyPOCB) then pnlModelBcrMainCh1.Visible := False
    else                                        pnlModelBcrMainCh1.Visible := AssyModelInfo.UseMainPidCh1;
    {$ELSE}
    pnlModelBcrMainCh1.Visible    := False;
    {$ENDIF}
  end;
  with Common.TestModelInfo2[DefPocb.CH_2] do begin
    pnlModelBcrLenCh2.Caption     := IntToStr(BcrLength);
    pnlModelBcrLenCh2.Font.Color  := clBlack;
    if (BcrPidChkIdx > 0) and (Length(BcrPidChkStr) > 0) then pnlModelBcrChkCh2.Caption := Format('%d,%s',[BcrPidChkIdx,BcrPidChkStr])
    else                                                      pnlModelBcrChkCh2.Caption := '';
    pnlModelBcrChkCh2.Font.Color  := clBlack;
    {$IFDEF SUPPORT_1CG2PANEL}
    if (not Common.SystemInfo.UseAssyPOCB) then pnlModelBcrMainCh2.Visible := False
    else                                        pnlModelBcrMainCh2.Visible := AssyModelInfo.UseMainPidCh2;
    {$ELSE}
    pnlModelBcrMainCh2.Visible    := False
    {$ENDIF}
  end;
{$ENDIF}
  //
  with Common.TestModelInfo2[DefPocb.CH_1] do begin
    {$IFDEF HAS_MOTION_CAM_Z}
    pnlModelZaxis1ModelPos.Caption    := Format('%0.2f',[CamZModelPos]);
    pnlModelZaxis1ModelPos.Font.Color := clBlack;
    {$ENDIF}
    pnlModelYaxis1CamPos.Caption      := Format('%0.2f',[CamYCamPos]);
    pnlModelYaxis1CamPos.Font.Color   := clBlack;
    {$IFNDEF POCB_A2CH}
    pnlModelYaxis1LoadPos.Caption     := Format('%0.2f',[CamYLoadPos]);
    pnlModelYaxis1LoadPos.Font.Color  := clBlack;
    {$ENDIF}
  end;
  with Common.TestModelInfo2[DefPocb.CH_2] do begin
    {$IFDEF HAS_MOTION_CAM_Z}
    pnlModelZaxis2ModelPos.Caption    := Format('%0.2f',[CamZModelPos]);
    pnlModelZaxis2ModelPos.Font.Color := clBlack;
    {$ENDIF}
    pnlModelYaxis2CamPos.Caption      := Format('%0.2f',[CamYCamPos]);
    pnlModelYaxis2CamPos.Font.Color   := clBlack;
    {$IFNDEF POCB_A2CH}
    pnlModelYaxis2LoadPos.Caption     := Format('%0.2f',[CamYLoadPos]);
    pnlModelYaxis2LoadPos.Font.Color  := clBlack;
    {$ENDIF}
  end;

  //
  {$IFDEF HAS_ROBOT_CAM_Z}
  with Common.RobotSysInfo.HomeCoord[DefPocb.CH_1] do begin
   	pnlRobot1HomeCoordX.StyleElements  := [];
    pnlRobot1HomeCoordX.Caption        := FormatFloat(ROBOT_FORMAT_COORD,X);
   	pnlRobot1HomeCoordY.StyleElements  := [];
    pnlRobot1HomeCoordY.Caption        := FormatFloat(ROBOT_FORMAT_COORD,Y);
   	pnlRobot1HomeCoordZ.StyleElements  := [];
    pnlRobot1HomeCoordZ.Caption        := FormatFloat(ROBOT_FORMAT_COORD,Z);
   	pnlRobot1HomeCoordRx.StyleElements := [];
    pnlRobot1HomeCoordRx.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Rx);
   	pnlRobot1HomeCoordRy.StyleElements := [];
    pnlRobot1HomeCoordRy.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Ry);
   	pnlRobot1HomeCoordRz.StyleElements := [];
    pnlRobot1HomeCoordRz.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Rz);
  end;
  with Common.RobotSysInfo.HomeCoord[DefPocb.CH_2] do begin
   	pnlRobot2HomeCoordX.StyleElements  := [];
    pnlRobot2HomeCoordX.Caption        := FormatFloat(ROBOT_FORMAT_COORD,X);
   	pnlRobot2HomeCoordY.StyleElements  := [];
    pnlRobot2HomeCoordY.Caption        := FormatFloat(ROBOT_FORMAT_COORD,Y);
   	pnlRobot2HomeCoordZ.StyleElements  := [];
    pnlRobot2HomeCoordZ.Caption        := FormatFloat(ROBOT_FORMAT_COORD,Z);
   	pnlRobot2HomeCoordRx.StyleElements := [];
    pnlRobot2HomeCoordRx.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Rx);
   	pnlRobot2HomeCoordRy.StyleElements := [];
    pnlRobot2HomeCoordRy.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Ry);
   	pnlRobot2HomeCoordRz.StyleElements := [];
    pnlRobot2HomeCoordRz.Caption       := FormatFloat(ROBOT_FORMAT_COORD,Rz);
  end;
  with Common.TestModelInfo2[DefPocb.CH_2] do begin
   	pnlRobot2ModelCoordX.StyleElements  := [];
    pnlRobot2ModelCoordX.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.X);
   	pnlRobot2ModelCoordY.StyleElements  := [];
    pnlRobot2ModelCoordY.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Y);
   	pnlRobot2ModelCoordZ.StyleElements  := [];
    pnlRobot2ModelCoordZ.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Z);
   	pnlRobot2ModelCoordRx.StyleElements := [];
    pnlRobot2ModelCoordRx.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rx);
   	pnlRobot2ModelCoordRy.StyleElements := [];
    pnlRobot2ModelCoordRy.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Ry);
   	pnlRobot2ModelCoordRz.StyleElements := [];
    pnlRobot2ModelCoordRz.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rz);
  end;
  with Common.TestModelInfo2[DefPocb.CH_1] do begin
   	pnlRobot1ModelCoordX.StyleElements  := [];
    pnlRobot1ModelCoordX.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.X);
   	pnlRobot1ModelCoordY.StyleElements  := [];
    pnlRobot1ModelCoordY.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Y);
   	pnlRobot1ModelCoordZ.StyleElements  := [];
    pnlRobot1ModelCoordZ.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Z);
   	pnlRobot1ModelCoordRx.StyleElements := [];
    pnlRobot1ModelCoordRx.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rx);
   	pnlRobot1ModelCoordRy.StyleElements := [];
    pnlRobot1ModelCoordRy.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Ry);
   	pnlRobot1ModelCoordRz.StyleElements := [];
    pnlRobot1ModelCoordRz.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rz);
  end;
  with Common.TestModelInfo2[DefPocb.CH_2] do begin
   	pnlRobot2ModelCoordX.StyleElements  := [];
    pnlRobot2ModelCoordX.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.X);
   	pnlRobot2ModelCoordY.StyleElements  := [];
    pnlRobot2ModelCoordY.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Y);
   	pnlRobot2ModelCoordZ.StyleElements  := [];
    pnlRobot2ModelCoordZ.Caption        := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Z);
   	pnlRobot2ModelCoordRx.StyleElements := [];
    pnlRobot2ModelCoordRx.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rx);
   	pnlRobot2ModelCoordRy.StyleElements := [];
    pnlRobot2ModelCoordRy.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Ry);
   	pnlRobot2ModelCoordRz.StyleElements := [];
    pnlRobot2ModelCoordRz.Caption       := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfo.Coord.Rz);
  end;
  {$ENDIF}
  //
  pnlSysInfoShareFolder.Caption  := Common.SystemInfo.ShareFolder;
  if Trim(Common.SystemInfo.ShareFolder) <> '' then begin
    ledSysInfoSharefolder.FalseColor := clRed;
    ledSysInfoSharefolder.Value := DirectoryExists(Common.SystemInfo.ShareFolder);
    if ledSysInfoSharefolder.Value then begin
      bIsAlarmOn := False; pnlSysInfoShareFolder.Color := clLime;  pnlSysInfoShareFolder.Font.Color := clBlack;
    end
    else begin
      bIsAlarmOn := True;  pnlSysInfoShareFolder.Color := clRed;   pnlSysInfoShareFolder.Font.Color := clYellow;
    end;
  end
  else begin
    ledSysInfoSharefolder.FalseColor := clGray;
    ledSysInfoSharefolder.Value := False;
    bIsAlarmOn := False;
  end;
  UpdateAlarmStatus(DefPocb.ALARM_SHARED_FOLDER_NOT_EXIST,bIsAlarmOn);   // for Alarm
end;

//******************************************************************************
// procedure/function: GUI (System Information)
//******************************************************************************
procedure TfrmMain.ShowCamConnStatus(nCam: Integer; tcpPort: Integer; nConnect: Integer);  //2018-12-14
begin
  if tcpPort = DefCam.BASE_CLINT_PORT then begin  //GPC:clint --> DPC:server
    ShowCamClintConnStatus(nCam,nConnect);
  end
  else begin  //GPC:server <-- DPC:clint
    ShowCamServerConnStatus(nCam,nConnect);
  end;
end;

procedure TfrmMain.ShowCamClintConnStatus(nCam: Integer; nConnect: Integer);
var
  sStatusCaption  : String;
  nColor, nFontColor : TColor;
  bIsAlarmOn  : Boolean;
  nAlarmNo    : Integer;
  sNgMsg      : string;
begin
  case nConnect of
    DefCam.CAM_CONNECT_FIRST_OK,
    DefCam.CAM_CONNECT_OK : begin
      sStatusCaption  := 'GPC-->DPC Conn';
      nColor          := clLime;
      nFontColor      := clBlack;
    end;
    DefCam.CAM_CONNECT_NG : begin
      sStatusCaption  := 'GPC-->DPC Disc';
      nColor          := clRed;
      nFontColor      := clYellow;
    end;
    else
      Exit;
  end;
  //
  sNgMsg := '';
  case nCam of
    DefPocb.CAM_1: begin
      pnlSysInfoCam1ClintStatus.Caption    := sStatusCaption;
      pnlSysInfoCam1ClintStatus.Color      := nColor;
      pnlSysInfoCam1ClintStatus.Font.Color := nFontColor;
      nAlarmNo := DefPocb.ALARM_CAMERA_PC1_DISCONNECTED; //2018-12-14 (CamConnection Alarm은 1개로 관리)
    end;
    DefPocb.CAM_2: begin
      pnlSysInfoCam2ClintStatus.Caption    := sStatusCaption;
      pnlSysInfoCam2ClintStatus.Color      := nColor;
      pnlSysInfoCam2ClintStatus.Font.Color := nFontColor;
      nAlarmNo := DefPocb.ALARM_CAMERA_PC2_DISCONNECTED; //2018-12-14 (CamConnection Alarm은 1개로 관리)
    end;
    else
      Exit;
  end;
  if (CameraComm.m_bCamClient[nCam] and CameraComm.m_bCamServer[nCam]) then bIsAlarmOn := False 
  else                                                                      bIsAlarmOn := True;
  UpdateAlarmStatus(nAlarmNo,bIsAlarmOn,'');
end;

procedure TfrmMain.ShowCamServerConnStatus(nCam: Integer; nConnect: Integer);
var
  sStatusCaption  : String;
  nColor, nFontColor : TColor;
  bIsAlarmOn  : Boolean;
  nAlarmNo    : Integer;
  sNgMsg      : string;
begin
  case nConnect of
    DefCam.CAM_CONNECT_FIRST_OK,
    DefCam.CAM_CONNECT_OK : begin
      sStatusCaption  := 'GPC<--DPC Conn';
      nColor          := clLime;
      nFontColor      := clBlack;
    end;
    DefCam.CAM_CONNECT_NG : begin
      sStatusCaption  := 'GPC<--DPC Disc';
      nColor          := clRed;
      nFontColor      := clYellow;
    end;
    else
      Exit;
  end;
  //
  sNgMsg := '';
  case nCam of
    DefPocb.CAM_1: begin
      pnlSysInfoCam1ServerStatus.Caption    := sStatusCaption;
      pnlSysInfoCam1ServerStatus.Color      := nColor;
      pnlSysInfoCam1ServerStatus.Font.Color := nFontColor;
      nAlarmNo := DefPocb.ALARM_CAMERA_PC1_DISCONNECTED; //2018-12-14 (CamConnection Alarm은 1개로 관리)
    end;
    DefPocb.CAM_2: begin
      pnlSysInfoCam2ServerStatus.Caption    := sStatusCaption;
      pnlSysInfoCam2ServerStatus.Color      := nColor;
      pnlSysInfoCam2ServerStatus.Font.Color := nFontColor;
      nAlarmNo := DefPocb.ALARM_CAMERA_PC2_DISCONNECTED; //2018-12-14 (CamConnection Alarm은 1개로 관리)
    end;
	else
	  Exit;
  end;
  if (CameraComm.m_bCamClient[nCam] and CameraComm.m_bCamServer[nCam]) then bIsAlarmOn := False
  else                                                                      bIsAlarmOn := True;
  if CameraComm.m_bCamServer[nCam] then CodeSite.Send('CAM'+IntToStr(nCam+1)+': ShowCamServerConnStatus: GPC <-- DPC Connected')
  else                                  CodeSite.Send('CAM'+IntToStr(nCam+1)+': ShowCamServerConnStatus: GPC <-- DPC Disconnected');
  if not Common.Systeminfo.DebugSelfTestPg then begin
    UpdateAlarmStatus(nAlarmNo,bIsAlarmOn,sNgMsg);
  end;
end;

procedure TfrmMain.ShowDioConnSt(nMode, nParam: Integer; sMsg: String);
var
  bConnected    : Boolean;
  bIsAlarmOn    : Boolean;
  sTemp, sNgMsg : string;
begin
  sTemp  := '';
  sNgMsg := '';
  case nMode of
    DefDio.MODE_DIO_CONNECT : begin
      if nParam > 0 then begin bConnected := True;  bIsAlarmOn := False; end
      else               begin bConnected := False; bIsAlarmOn := True;  end;
      if bConnected then begin
        sTemp := '<FrmMain> DIO Connected';
        PnlDioInTitle.Color   := clLime;
        PnlDioOutTitle.Color  := clLime;
        PnlDioInTitle.Font.Color   := clBlack;
        PnlDioOutTitle.Font.Color  := clBlack;
      end
      else begin
        sTemp := '<FrmMain> DIO Disonnected';
        PnlDioInTitle.Color   := clRed;
        PnlDioOutTitle.Color  := clRed;
        PnlDioInTitle.Font.Color   := clYellow;
        PnlDioOutTitle.Font.Color  := clYellow;
        //sNgMsg := 'DIO disconnected - please check DIO device';
      end;
    //Common.MLog(DefPocb.SYS_LOG,sTemp,DefPocb.DEBUG_LEVEL_INFO);
      UpdateAlarmStatus(DefPocb.ALARM_DIO_NOT_CONNECTED,bIsAlarmOn);

    end;
    else
      Exit;
  end;
end;

procedure TfrmMain.ShowDioOutReadSt(OutDio: ADioStatus);
var
  i : Integer;
begin
	//Common.MLog(DefPocb.SYS_LOG,'<FrmMain> ShowDioOutReadSt');
{$IFDEF POCB_A2CH}
  for i := 0 to Pred(DefDio.MAX_DIO_CNT) do  //A2CH
{$ELSE}
  for i := 0 to DefDio.MAX_DIO_OUT do        //F2CH|A2CHv2
{$ENDIF}
  begin
    //Common.MLog(DefPocb.SYS_LOG,'X'+IntToStr(i)+':'+BoolToStr(OutDio[i]));
    ledDioOut[i].LedOn := OutDio[i];
  end;
end;

//------------------------------------------------------------------------------
//
procedure TfrmMain.ShowMotionStatus(nMotionID: Integer; nMode, nErrCode: Integer; sMsg: String);
var
  nCh, nAxis  : Integer;
  bIsAlarmOn  : Boolean;
//nAlarmNo    : Integer;
  ledValue    : Boolean;
  sConnStMsg  : string;
  sPosStMsg   : string;
  nConnStColor, nConnStFontColor : TColor;
  nPosStColor,  nPosStFontColor  : TColor;
  MotionAlarmNo : TMotionAlarmNo;
  bIsMainSystemInfo : Boolean;
begin
  if (not DongaMotion.GetMotionID2ChAxis(nMotionID,nCh,nAxis)) then begin
    Exit;
  end;
  //--------------------- for MainFrm:SystemInfo
  ledValue   := True;
  sConnStMsg := ''; nConnStColor := clLime; nConnStFontColor := clBlack;
  sPosStMsg  := ''; nPosStColor  := clLime; nPosStFontColor  := clBlack;
	Common.CodeSiteSend('<FrmMain> ShowMotionStatus: '+Common.GetStrMotionID2ChAxis(nMotionID)+': Mode('+IntToStr(nMode)+') Param('+IntToStr(nErrCode)+') Msg('+sMsg+')');
  // for MainFrm:SystemInfo:Motion(s)
  bIsMainSystemInfo := True;
  case nMode of
    DefPocb.MSG_MODE_MOTION_CONNECT: begin
      ledValue := False;
      if (nErrCode = DefPocb.ERR_OK) then
        begin sConnStMsg := 'Connected';    nConnStColor := clLime; nConnStFontColor := clBlack;  end
      else
        begin sConnStMsg := 'Disconnected'; nConnStColor := clRed;  nConnStFontColor := clYellow; end;
      sPosStMsg  := 'Unknown'; nPosStColor := clRed; nPosStFontColor := clYellow;
    end;
    DefPocb.MSG_MODE_MOTION_INIT: begin
      ledValue := False;
      sConnStMsg := 'Connected'; nConnStColor := clLime; nConnStFontColor := clBlack;
      if (nErrCode = DefPocb.ERR_OK) then sPosStMsg := 'Need HomeSearch'
      else                                sPosStMsg := 'Init Fail';
      nPosStColor := clRed; nPosStFontColor := clYellow;
    end;
    DefPocb.MSG_MODE_MOTION_MODEL_POS: begin
      sConnStMsg := 'Connected'; nConnStColor := clLime; nConnStFontColor := clBlack;
      if (nErrCode = DefPocb.ERR_OK) then
        begin ledValue := True;  sPosStMsg := 'Ready'; nPosStColor := clLime; nPosStFontColor := clBlack; end //2021-11-18 ModelPos OK -> Ready
      else
        begin ledValue := False; sPosStMsg := 'ModelPos NG'; nPosStColor := clRed;  nPosStFontColor := clYellow; end;
    end;
    DefPocb.MSG_MODE_MOTION_MOVE_TO_HOME: begin
      sConnStMsg := 'Connected'; nConnStColor := clLime; nConnStFontColor := clBlack;
      case nErrCode of
        DefPocb.ERR_MOTION_MOVE_START: begin
          ledValue := False; sPosStMsg := 'Home Searching..'; nPosStColor := clYellow;  nPosStFontColor := clRed;
        end;
        DefPocb.ERR_OK: begin
          case nAxis of
						{$IFDEF POCB_A2CH}
            DefMotion.MOTION_AXIS_Y: begin ledValue := True;  sPosStMsg := 'HomeSearch OK'; nPosStColor := clLime; nPosStFontColor := clBlack;  end; //A2CH: Home=LoadPos						
						{$ELSE} //A2CHv2|A2CHv3|A2CHV4|F2CH|ITOLED
            DefMotion.MOTION_AXIS_Y: begin ledValue := False; sPosStMsg := 'Need ModelPos'; nPosStColor := clRed;  nPosStFontColor := clYellow; end;
						{$ENDIF}						
						{$IFDEF HAS_MOTION_CAM_Z}						
            DefMotion.MOTION_AXIS_Z: begin ledValue := False; sPosStMsg := 'Need ModelPos'; nPosStColor := clRed;  nPosStFontColor := clYellow; end;
						{$ENDIF}						
						{$IFDEF HAS_MOTION_TILTING}
            DefMotion.MOTION_AXIS_T: begin ledValue := False; sPosStMsg := 'Need ModelPos'; nPosStColor := clRed;  nPosStFontColor := clYellow; end;
						{$ENDIF}
          end;
        end;
        DefPocb.ERR_MOTION_MOVE_TO_HOME: begin
          ledValue := False; sPosStMsg := 'HomeSearch NG'; nPosStColor := clRed;  nPosStFontColor := clYellow;
        end;
        else begin  //2019-02-11
          ledValue := False; nPosStColor := clRed; nPosStFontColor := clYellow;
        end;
      end;
    end;
    else begin
      bIsMainSystemInfo := False;
    end;
  end;
  if bIsMainSystemInfo then begin
    case nMotionID of
      DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
        ledSysinfoYaxis1Motor.Value         := ledValue;
        pnlSysinfoYaxis1Status.Caption      := sConnStMsg;
        pnlSysinfoYaxis1Status.Color        := nConnStColor;
        pnlSysinfoYaxis1Status.Font.Color   := nConnStFontColor;
        pnlSysInfoYAxis1ServoMsg.Caption    := sPosStMsg;
        pnlSysInfoYAxis1ServoMsg.Color      := nPosStColor;
        pnlSysInfoYAxis1ServoMsg.Font.Color := nPosStFontColor;
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
        ledSysinfoYaxis2Motor.Value         := ledValue;
        pnlSysinfoYaxis2Status.Caption      := sConnStMsg;
        pnlSysinfoYaxis2Status.Color        := nConnStColor;
        pnlSysinfoYaxis2Status.Font.Color   := nConnStFontColor;
        pnlSysInfoYAxis2ServoMsg.Caption    := sPosStMsg;
        pnlSysInfoYAxis2ServoMsg.Color      := nPosStColor;
        pnlSysInfoYAxis2ServoMsg.Font.Color := nPosStFontColor;
      end;
			{$IFDEF HAS_MOTION_CAM_Z}
      DefMotion.MOTIONID_AxMC_STAGE1_Z: begin
        ledSysinfoZaxis1Motor.Value         := ledValue;
        pnlSysinfoZaxis1Status.Caption      := sConnStMsg;
        pnlSysinfoZaxis1Status.Color        := nConnStColor;
        pnlSysinfoZaxis1Status.Font.Color   := nConnStFontColor;
        pnlSysInfoZAxis1ServoMsg.Caption    := sPosStMsg;
        pnlSysInfoZAxis1ServoMsg.Color      := nPosStColor;
        pnlSysInfoZAxis1ServoMsg.Font.Color := nPosStFontColor;
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_Z: begin
        ledSysinfoZaxis2Motor.Value         := ledValue;
        pnlSysinfoZaxis2Status.Caption      := sConnStMsg;
        pnlSysinfoZaxis2Status.Color        := nConnStColor;
        pnlSysinfoZaxis2Status.Font.Color   := nConnStFontColor;
        pnlSysInfoZAxis2ServoMsg.Caption    := sPosStMsg;
        pnlSysInfoZAxis2ServoMsg.Color      := nPosStColor;
        pnlSysInfoZAxis2ServoMsg.Font.Color := nPosStFontColor;
      end;
			{$ENDIF}
			{$IFDEF HAS_MOTION_TILTING}
      DefMotion.MOTIONID_AxMC_STAGE1_T: begin
        ledSysinfoTaxis1Motor.Value         := ledValue;
        pnlSysinfoTaxis1Status.Caption      := sConnStMsg;
        pnlSysinfoTaxis1Status.Color        := nConnStColor;
        pnlSysinfoTaxis1Status.Font.Color   := nConnStFontColor;
        pnlSysInfoTAxis1ServoMsg.Caption    := sPosStMsg;
        pnlSysInfoTAxis1ServoMsg.Color      := nPosStColor;
        pnlSysInfoTAxis1ServoMsg.Font.Color := nPosStFontColor;
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_T: begin
        ledSysinfoTaxis2Motor.Value         := ledValue;
        pnlSysinfoTaxis2Status.Caption      := sConnStMsg;
        pnlSysinfoTaxis2Status.Color        := nConnStColor;
        pnlSysinfoTaxis2Status.Font.Color   := nConnStFontColor;
        pnlSysInfoTAxis2ServoMsg.Caption    := sPosStMsg;
        pnlSysInfoTAxis2ServoMsg.Color      := nPosStColor;
        pnlSysInfoTAxis2ServoMsg.Font.Color := nPosStFontColor;
      end;
			{$ENDIF}
    end;
  end;

  {$IFDEF SUPPORT_1CG2PANEL}
  case nMode of
    DefPocb.MSG_MODE_MOTION_MOVE_TO_HOME: begin
      if DongaMotion.Motion[nMotionID].m_MotionStatus.nSyncStatus = DefMotion.SyncLinkMaster then begin  //TBD:A2CHv3:MOTION? (SYNC_MOVE)
        ledSysinfoYaxis2Motor.Value         := ledValue;
        pnlSysinfoYaxis2Status.Caption      := sConnStMsg;
        pnlSysinfoYaxis2Status.Color        := nConnStColor;
        pnlSysinfoYaxis2Status.Font.Color   := nConnStFontColor;
        pnlSysInfoYAxis2ServoMsg.Caption    := sPosStMsg;
        pnlSysInfoYAxis2ServoMsg.Color      := nPosStColor;
        pnlSysInfoYAxis2ServoMsg.Font.Color := nPosStFontColor;
      end;
    end;
    else begin
    end;
  end;
  {$ENDIF} //SUPPORT_1CG2PANEL

  //--------------------- for MainFrm:AlarmMotionControl
  Common.GetMotionAlarmNo(nMotionID,MotionAlarmNo);
  if (nErrCode = DefPocb.ERR_OK) then bIsAlarmOn := False  // for Alarm
  else                                bIsAlarmOn := True;  // for Alarm
  //2019-04-03 MoveToHere //2019-04-04 Delete!!!  //2019-04-07 Add!!!(InMotionStatus->SendMainGui)
  if (PnlAlarmMotionControl.Visible) or (bIsAlarmOn) then begin
    if (sMsg.Length > 0) then begin
      sMsg := FormatDateTime('hh:mm:ss.zzz  ',Now) + sMsg; //2019-03-29
    //CodeSite.Send('ShowMotionStatus:mmAlarmOpMsg'+sMsg); //2019-04-03
      mmAlarmOpMsg.SelAttributes.Color := clBlack;         //2019-03-29 //2019-04-03 TBD:ALARM:UI:RichEdit?
      mmAlarmOpMsg.DisableAlign;
      mmAlarmOpMsg.Lines.Add(sMsg);
      mmAlarmOpMsg.Perform(EM_SCROLL,SB_LINEDOWN,0);
      mmAlarmOpMsg.EnableAlign;
    end;
  end;
  //
  case nMode of
    DefPocb.MSG_MODE_MOTION_CONNECT: begin
      UpdateAlarmStatus(MotionAlarmNo.DISCONNECTED,bIsAlarmOn);
    end;
    DefPocb.MSG_MODE_MOTION_INIT: begin
      UpdateAlarmStatus(MotionAlarmNo.NEED_HOME_SEARCH,True); // for Alarm On
{$IFDEF POCB_A2CH}
      if nAxis = MOTION_AXIS_Z then UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,True)   // for Alarm On
      else                          UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,False); // for Alarm Off  TBD?
{$ELSE}
      case nAxis of
        MOTION_AXIS_Y: UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,True);  // for Alarm On
        MOTION_AXIS_Z: UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,True);  // for Alarm On
			  {$IFDEF HAS_MOTION_TILTING}  //F2CH
        MOTION_AXIS_T: UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,True);  // for Alarm On  //F2CH
			  {$ENDIF}
      end;
{$ENDIF}
      if Common.MotionInfo.StartupHomeModelPos then begin
        if (not bIsAlarmOn) then tmrAutoHomeSearch.Enabled := True;
      end;
    end;
  //DefPocb.MSG_MODE_MOTION_HOME: begin
  //  UpdateAlarmStatus(MotionAlarmNo.NEED_HOME_SEARCH,bIsAlarmOn);
  //  case nAxis of
  //    MOTION_AXIS_Z: begin
  //      if (not bIsAlarmOn) then tmrZAxisModelPos.Enabled := True;
  //    end;
  //{$IFNDEF POCB_A2CH}
  //    MOTION_AXIS_Y: begin
  //      if (not bIsAlarmOn) then tmrYAxisModelPos.Enabled := True;
  //    end;
  //{$ENDIF}
  //{$IFDEF HAS_MOTION_TILTING}  //F2CH
  //    MOTION_AXIS_T: begin
  //      if (not bIsAlarmOn) then tmrTAxisModelPos.Enabled := True;
  //    end;
  //{$ENDIF}
  //  end;
  //end;
    DefPocb.MSG_MODE_MOTION_MODEL_POS: begin
      case nAxis of
{$IFDEF HAS_MOTION_CAM_Z}
        MOTION_AXIS_Z: begin
          UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,bIsAlarmOn);
          if (bIsAlarmOn) then tmrZAxisModelPos.Enabled := True;
        end;
{$ENDIF}
{$IFNDEF POCB_A2CH}
        MOTION_AXIS_Y: begin
          UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,bIsAlarmOn);
          if (bIsAlarmOn) then tmrYAxisModelPos.Enabled := True;
        end;
  {$IFDEF HAS_MOTION_TILTING}
        MOTION_AXIS_T: begin
          UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,bIsAlarmOn);
          if (bIsAlarmOn) then tmrTAxisModelPos.Enabled := True;
        end;
  {$ENDIF}
{$ENDIF}
      end;
    end;
    DefPocb.MSG_MODE_MOTION_MOVE_TO_HOME: begin
      case nErrCode of
        DefPocb.ERR_MOTION_MOVE_START: begin
          UpdateAlarmStatus(MotionAlarmNo.NEED_HOME_SEARCH,True); // for Alarm On
{$IFDEF POCB_A2CH}
          if nAxis = MOTION_AXIS_Z then UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,True)   // for Alarm On
          else                          UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,False); // for Alarm Off
{$ELSE}
          case nAxis of
             MOTION_AXIS_Y: begin UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,True);  end; // for Alarm On
  {$IFDEF HAS_MOTION_CAM_Z}						 
             MOTION_AXIS_Z: begin UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,True);  end; // for Alarm On
  {$ENDIF}						 
  {$IFDEF HAS_MOTION_TILTING}
             MOTION_AXIS_T: begin UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,True);  end; // for Alarm On
  {$ENDIF}
          end;
{$ENDIF}
          case nMotionID of
            DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
              pnlAlarmMotionStCh1Y.Color := clYellow; pnlAlarmMotionStCh1Y.Font.Color := clRed;
              pnlAlarmMotionStCh1Y.Caption := 'Home Searching...';
            end;
            DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
              pnlAlarmMotionStCh2Y.Color := clYellow; pnlAlarmMotionStCh2Y.Font.Color := clRed;
              pnlAlarmMotionStCh2Y.Caption := 'Home Searching...';
            end;
{$IFDEF HAS_MOTION_CAM_Z}
            DefMotion.MOTIONID_AxMC_STAGE1_Z: begin
              pnlAlarmMotionStCh1Z.Color := clYellow; pnlAlarmMotionStCh1Z.Font.Color := clRed;
              pnlAlarmMotionStCh1Z.Caption := 'Home Searching...';
            end;
            DefMotion.MOTIONID_AxMC_STAGE2_Z: begin
              pnlAlarmMotionStCh2Z.Color := clYellow; pnlAlarmMotionStCh2Z.Font.Color := clRed;
              pnlAlarmMotionStCh2Z.Caption := 'Home Searching...';
            end;
{$ENDIF}
{$IFDEF HAS_MOTION_TILTING}
            DefMotion.MOTIONID_AxMC_STAGE1_T: begin
              pnlAlarmMotionStCh1T.Color := clYellow; pnlAlarmMotionStCh1T.Font.Color := clRed;
              pnlAlarmMotionStCh1T.Caption := 'Home Searching...';
            end;
            DefMotion.MOTIONID_AxMC_STAGE2_T: begin
              pnlAlarmMotionStCh2T.Color := clYellow; pnlAlarmMotionStCh2T.Font.Color := clRed;
              pnlAlarmMotionStCh2T.Caption := 'Home Searching...';
            end;
{$ENDIF}			
          end;
        end;
        DefPocb.ERR_OK: begin
          UpdateAlarmStatus(MotionAlarmNo.NEED_HOME_SEARCH,bIsAlarmOn);
          case nAxis of
            DefMotion.MOTION_AXIS_Y: begin
{$IFDEF POCB_A2CH}
              UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,False); // for Alarm Off
{$ELSE}
              if (not bIsAlarmOn) then tmrYAxisModelPos.Enabled := True;
{$ENDIF}
            end;
{$IFDEF HAS_MOTION_CAM_Z}
            DefMotion.MOTION_AXIS_Z: begin
              if (not bIsAlarmOn) then tmrZAxisModelPos.Enabled := True;
            end;
{$ENDIF}
{$IFDEF HAS_MOTION_TILTING}
            DefMotion.MOTION_AXIS_T: begin
              if (not bIsAlarmOn) then tmrTAxisModelPos.Enabled := True;
            end;
{$ENDIF}
          end;
        end;
        DefPocb.ERR_MOTION_MOVE_TO_HOME: begin
          UpdateAlarmStatus(MotionAlarmNo.NEED_HOME_SEARCH,bIsAlarmOn);
          case nMotionID of
            DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
              pnlAlarmMotionStCh1Y.Color := clRed; pnlAlarmMotionStCh1Y.Font.Color := clYellow;
              pnlAlarmMotionStCh1Y.Caption := 'HomeSearch NG';
            end;
            DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
              pnlAlarmMotionStCh2Y.Color := clRed; pnlAlarmMotionStCh2Y.Font.Color := clYellow;
              pnlAlarmMotionStCh2Y.Caption := 'HomeSearch NG';
            end;
{$IFDEF HAS_MOTION_CAM_Z}
            DefMotion.MOTIONID_AxMC_STAGE1_Z: begin
              pnlAlarmMotionStCh1Z.Color := clRed; pnlAlarmMotionStCh1Z.Font.Color := clYellow;
              pnlAlarmMotionStCh1Z.Caption := 'HomeSearch NG';
            end;
            DefMotion.MOTIONID_AxMC_STAGE2_Z: begin
              pnlAlarmMotionStCh2Z.Color := clRed; pnlAlarmMotionStCh2Z.Font.Color := clYellow;
              pnlAlarmMotionStCh2Z.Caption := 'HomeSearch NG';
            end;
{$ENDIF}
{$IFDEF HAS_MOTION_TILTING}
            DefMotion.MOTIONID_AxMC_STAGE1_T: begin
              pnlAlarmMotionStCh1T.Color := clRed; pnlAlarmMotionStCh1T.Font.Color := clYellow;
              pnlAlarmMotionStCh1T.Caption := 'HomeSearch NG';
            end;
            DefMotion.MOTIONID_AxMC_STAGE2_T: begin
              pnlAlarmMotionStCh2T.Color := clRed; pnlAlarmMotionStCh2T.Font.Color := clYellow;
              pnlAlarmMotionStCh2T.Caption := 'HomeSearch NG';
            end;
{$ENDIF}
          end;
        end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
//
{$IFDEF HAS_ROBOT_CAM_Z}
procedure TfrmMain.ShowRobotStatus(nRobot: Integer; nMode, nErrCode: Integer; sMsg: String);  //TBD:A2CHv3:ROBOT?
var
  bRobotStReady, bIsAlarmOn  : Boolean;
//nAlarmNo    : Integer;
  ledValueModbus, ledValueListenNode : Boolean;
  nConnStColorModbus, nConnStFontColorModbus : TColor;
  nConnStColorListenNode, nConnStFontColorListenNode : TColor;
  sRobotStMsg, sPosStMsg : string;
  nPosStColor, nPosStFontColor : TColor;
  RobotAlarmNo : TRobotAlarmNo;
begin
  CodeSite.Send('<FrmMain> ShowRobotStatus: '+Format('ROBOT%d',[nRobot+1])+': Mode('+IntToStr(nMode)+') ErrCode('+IntToStr(nErrCode)+') Msg('+sMsg+')');
  //--------------------- for MainFrm:SystemInfo:Robot(s)
  sRobotStMsg := '';
  bRobotStReady := DongaRobot.GetRobotControlStatus(nRobot,sRobotStMsg);
  sPosStMsg := sRobotStMsg;
  //
  if DongaRobot.m_bConnectedModbus[nRobot]
  then begin ledValueModbus := True;  nConnStColorModbus := clLime; nConnStFontColorModbus := clBlack;  end
  else begin ledValueModbus := False; nConnStColorModbus := clRed;  nConnStFontColorModbus := clYellow; end;
  if DongaRobot.m_bConnectedListenNode[nRobot]
  then begin ledValueListenNode := True;  nConnStColorListenNode := clLime; nConnStFontColorListenNode := clBlack;  end
  else begin ledValueListenNode := False; nConnStColorListenNode := clRed;  nConnStFontColorListenNode := clYellow; end;
  //
  if bRobotStReady then begin
    nPosStColor := clLime; nPosStFontColor := clBlack;
    case nMode of
      DefPocb.MSG_MODE_ROBOT_MOVE_TO_HOME: begin
        if (nErrCode = DefPocb.ERR_ROBOT_MOVE_START_OK) then sPosStMsg := 'HomePos...';
        nPosStColor := clYellow; nPosStFontColor := clBlack;
      end;
      DefPocb.MSG_MODE_ROBOT_MOVE_TO_MODEL: begin
        if (nErrCode = DefPocb.ERR_OK) then nPosStColor := clLime else nPosStColor := clYellow;
        if (nErrCode = DefPocb.ERR_ROBOT_MOVE_START_OK) then sPosStMsg := 'ModelPos...';
        nPosStFontColor := clBlack;
      end;
      DefPocb.MSG_MODE_ROBOT_MOVE_TO_STANDBY: begin
        if (nErrCode = DefPocb.ERR_ROBOT_MOVE_START_OK) then sPosStMsg := 'StandbyPos...';
        nPosStColor := clYellow; nPosStFontColor := clBlack;
      end;
      DefPocb.MSG_MODE_ROBOT_HOME_COORD: begin
        if (nErrCode = DefPocb.ERR_OK)
        then begin sPosStMsg := 'Coord(Home)'; nPosStColor := clYellow; nPosStFontColor := clBlack;  end
        else begin sPosStMsg := 'HomePos NG';  nPosStColor := clRed;    nPosStFontColor := clYellow; end;  //TBD:A2CHv3:ROBOT?
      end;
      DefPocb.MSG_MODE_ROBOT_MODEL_COORD: begin
        if (nErrCode = DefPocb.ERR_OK)
        then begin sPosStMsg := 'Ready(Model)'; nPosStColor := clLime; nPosStFontColor := clBlack;  end
        else begin sPosStMsg := 'ModelPos NG';  nPosStColor := clRed;  nPosStFontColor := clYellow; end; //TBD:A2CHv3:ROBOT?
      end;
      DefPocb.MSG_MODE_ROBOT_STANDBY_COORD: begin
        if (nErrCode = DefPocb.ERR_OK)
        then begin sPosStMsg := 'Coord(Standby)'; nPosStColor := clYellow; nPosStFontColor := clBlack;  end
        else begin sPosStMsg := 'StandbyPos NG';  nPosStColor := clRed;    nPosStFontColor := clYellow; end; //TBD:A2CHv3:ROBOT?
      end;
      else begin
        if DongaRobot.Robot[nRobot].m_RobotStatusCoord.coordState = coordUndefined then begin
           sPosStMsg := 'Coord(Unknown)'; nPosStColor := clYellow;  nPosStFontColor := clBlack;
        end;
      end;
    end;
  end
  else begin
    nPosStColor := clRed; nPosStFontColor := clYellow;
  end;
  //
  case nRobot of
    DefRobot.ROBOT_CH1: begin
      ledSysinfoRobot1Modbus.Value          := ledValueModbus;
      pnlSysinfoRobot1Modbus.Color          := nConnStColorModbus;
      pnlSysinfoRobot1Modbus.Font.Color     := nConnStFontColorModbus;
      ledSysinfoRobot1ListenNode.Value      := ledValueListenNode;
      pnlSysinfoRobot1ListenNode.Color      := nConnStColorListenNode;
      pnlSysinfoRobot1ListenNode.Font.Color := nConnStFontColorListenNode;
      pnlSysInfoRobot1StatusMsg.Color       := nPosStColor;
      pnlSysInfoRobot1StatusMsg.Font.Color  := nPosStFontColor;
      pnlSysInfoRobot1StatusMsg.Caption     := sPosStMsg;
    end;
    DefRobot.ROBOT_CH2: begin
      ledSysinfoRobot2Modbus.Value          := ledValueModbus;
      pnlSysinfoRobot2Modbus.Color          := nConnStColorModbus;
      pnlSysinfoRobot2Modbus.Font.Color     := nConnStFontColorModbus;
      ledSysinfoRobot2ListenNode.Value      := ledValueListenNode;
      pnlSysinfoRobot2ListenNode.Color      := nConnStColorListenNode;
      pnlSysinfoRobot2ListenNode.Font.Color := nConnStFontColorListenNode;
      pnlSysInfoRobot2StatusMsg.Color       := nPosStColor;
      pnlSysInfoRobot2StatusMsg.Font.Color  := nPosStFontColor;
      pnlSysInfoRobot2StatusMsg.Caption     := sPosStMsg;
    end;
  end;
  //--------------------- for MainFrm:AlarmMotionRobotControl
  Common.GetRobotAlarmNo(nRobot,RobotAlarmNo);
  case nMode of
    DefPocb.MSG_MODE_ROBOT_CONNECT_MODBUS  : bIsAlarmOn := (not DongaRobot.m_bConnectedModbus[nRobot]);
    DefPocb.MSG_MODE_ROBOT_CONNECT_COMMAND : bIsAlarmOn := (not DongaRobot.m_bConnectedListenNode[nRobot]);
    else                                     bIsAlarmOn := not ((nErrCode = DefPocb.ERR_OK) or (nErrCode = DefPocb.ERR_ROBOT_MOVE_START_OK));
  end;
  if (PnlAlarmMotionControl.Visible) or (bIsAlarmOn) then begin
    if (sMsg.Length > 0) then begin
      sMsg := FormatDateTime('hh:mm:ss.zzz  ',Now) + sMsg;
      mmAlarmOpMsg.SelAttributes.Color := clBlack;
      mmAlarmOpMsg.DisableAlign;
      mmAlarmOpMsg.Lines.Add(sMsg);
      mmAlarmOpMsg.Perform(EM_SCROLL,SB_LINEDOWN,0);
      mmAlarmOpMsg.EnableAlign;
    end;
  end;
  //
  if bRobotStReady then begin
    if sRobotStMsg = 'Ready(Model)'        then begin nPosStColor := clLime;   nPosStFontColor := clBlack; end
    else if sRobotStMsg = 'Coord(Home)'    then begin nPosStColor := clYellow; nPosStFontColor := clBlack; end
    else if sRobotStMsg = 'Coord(Standby)' then begin nPosStColor := clYellow; nPosStFontColor := clBlack; end
    else if sRobotStMsg = 'Coord(Unknown)' then begin nPosStColor := clYellow; nPosStFontColor := clBlack; end;
  end
  else begin
    nPosStColor := clRed;  nPosStFontColor := clYellow;
  end;
  //
  sPosStMsg := sRobotStMsg;
  case nRobot of
    DefRobot.ROBOT_CH1: begin pnlAlarmRobotStCh1.Color := nPosStColor; pnlAlarmRobotStCh1.Font.Color := nPosStFontColor; pnlAlarmRobotStCh1.Caption := sPosStMsg; end;
    DefRobot.ROBOT_CH2: begin pnlAlarmRobotStCh2.Color := nPosStColor; pnlAlarmRobotStCh2.Font.Color := nPosStFontColor; pnlAlarmRobotStCh2.Caption := sPosStMsg; end;
  end;
  //
  case nMode of
    DefPocb.MSG_MODE_ROBOT_CONNECT_MODBUS, DefPocb.MSG_MODE_ROBOT_CONNECT_COMMAND: begin
      if nMode = DefPocb.MSG_MODE_ROBOT_CONNECT_MODBUS then UpdateAlarmStatus(RobotAlarmNo.MODBUS_DISCONNECTED,bIsAlarmOn)
      else                                                  UpdateAlarmStatus(RobotAlarmNo.COMMAND_DISCONNECTED,bIsAlarmOn);
      //
      if (DongaRobot.m_bConnectedModbus[nRobot] {and DongaRobot.m_bConnectedListenNode[nRobot]}) then begin
        tmrAutoRobotMoveModel.Enabled := True;
      end;
    end;
    DefPocb.MSG_MODE_ROBOT_MOVE_TO_HOME: begin
      case nErrCode of
        DefPocb.ERR_OK: begin
          if DongaRobot.Robot[nRobot].m_RobotStatusCoord.CoordState <> coordHome then
            UpdateAlarmStatus(RobotAlarmNo.HOME_COORD_MISMATCH,True{bIsAlarmOn})
          else
            UpdateAlarmStatus(RobotAlarmNo.HOME_COORD_MISMATCH,False{bIsAlarmOn});
        end;
        DefPocb.ERR_ROBOT_MOVE_START_OK: begin
          //NOP
        end;
        DefPocb.ERR_ROBOT_MOVE_TO_HOME: begin
        {UpdateAlarmStatus(RobotAlarmNo.CURR_COORD_NG,bIsAlarmOn);
          case nRobot of
            DefRobot.ROBOT_CH1: begin
              pnlAlarmRobotStCh1.Color := clRed; pnlAlarmRobotStCh1.Font.Color := clYellow;
              pnlAlarmRobotStCh1.Caption := 'MoveToHome NG';
            end;
            DefRobot.ROBOT_CH2: begin
              pnlAlarmRobotStCh2.Color := clRed; pnlAlarmRobotStCh2.Font.Color := clYellow;
              pnlAlarmRobotStCh2.Caption := 'MoveToHome NG';
            end;
          end;}
        end;
        else begin
          CodeSite.Send('#FrmMain# ShowRobotStatus: '+Format('ROBOT%d',[nRobot+1])+': Mode(MSG_MODE_ROBOT_MOVE_TO_HOME) ErrCode(Invalid:'+IntToStr(nErrCode)+') Msg('+sMsg+') ...TBD');
        end;
      end;
    end;
    DefPocb.MSG_MODE_ROBOT_MOVE_TO_MODEL: begin
      case nErrCode of
        DefPocb.ERR_OK: begin
          if DongaRobot.Robot[nRobot].m_RobotStatusCoord.CoordState <> coordModel then
            UpdateAlarmStatus(RobotAlarmNo.MODEL_COORD_MISMATCH,True{bIsAlarmOn})
          else
            UpdateAlarmStatus(RobotAlarmNo.MODEL_COORD_MISMATCH,False{bIsAlarmOn});
        end;
        DefPocb.ERR_ROBOT_MOVE_START_OK: begin
          //NOP
        end;
        DefPocb.ERR_ROBOT_MOVE_TO_MODEL: begin
         {UpdateAlarmStatus(RobotAlarmNo.CURR_COORD_NG,bIsAlarmOn);
          case nRobot of
            DefRobot.ROBOT_CH1: begin
              pnlAlarmRobotStCh1.Color := clRed; pnlAlarmRobotStCh1.Font.Color := clYellow;
              pnlAlarmRobotStCh1.Caption := 'MoveToModel NG';
            end;
            DefRobot.ROBOT_CH2: begin
              pnlAlarmRobotStCh2.Color := clRed; pnlAlarmRobotStCh2.Font.Color := clYellow;
              pnlAlarmRobotStCh2.Caption := 'MoveToModel NG';
            end;
          end;}
        end;
        else begin
          CodeSite.Send('#FrmMain# ShowRobotStatus: '+Format('ROBOT%d',[nRobot+1])+': Mode(MSG_MODE_ROBOT_MOVE_TO_MODEL) ErrCode(Invalid:'+IntToStr(nErrCode)+') Msg('+sMsg+') ...TBD');
        end;
      end;
    end;
    DefPocb.MSG_MODE_ROBOT_MOVE_TO_STANDBY: begin
      case nErrCode of
        DefPocb.ERR_OK: begin
          if DongaRobot.Robot[nRobot].m_RobotStatusCoord.CoordState <> coordStandby then
            UpdateAlarmStatus(RobotAlarmNo.STANDBY_COORD_MISMATCH,True{bIsAlarmOn})
          else
            UpdateAlarmStatus(RobotAlarmNo.STANDBY_COORD_MISMATCH,False{bIsAlarmOn});
        end;
        DefPocb.ERR_ROBOT_MOVE_START_OK: begin
          //NOP
        end;
        DefPocb.ERR_ROBOT_MOVE_TO_STANDBY: begin
         {UpdateAlarmStatus(RobotAlarmNo.CURR_COORD_NG,bIsAlarmOn);
          case nRobot of
            DefRobot.ROBOT_CH1: begin
              pnlAlarmRobotStCh1.Color := clRed; pnlAlarmRobotStCh1.Font.Color := clYellow;
              pnlAlarmRobotStCh1.Caption := 'MoveToStandby NG';
            end;
            DefRobot.ROBOT_CH2: begin
              pnlAlarmRobotStCh2.Color := clRed; pnlAlarmRobotStCh2.Font.Color := clYellow;
              pnlAlarmRobotStCh2.Caption := 'MoveToStandby NG';
            end;
          end;}
        end;
        else begin
          CodeSite.Send('#FrmMain# ShowRobotStatus: '+Format('ROBOT%d',[nRobot+1])+': Mode(MSG_MODE_ROBOT_MOVE_TO_STANDBY) ErrCode(Invalid:'+IntToStr(nErrCode)+') Msg('+sMsg+') ...TBD');
        end;
      end;
    end;
    DefPocb.MSG_MODE_ROBOT_HOME_COORD: begin
      UpdateAlarmStatus(RobotAlarmNo.CURR_COORD_NG,False);
    end;
    DefPocb.MSG_MODE_ROBOT_MODEL_COORD: begin
      UpdateAlarmStatus(RobotAlarmNo.CURR_COORD_NG,False);
    end;
    DefPocb.MSG_MODE_ROBOT_STANDBY_COORD: begin
      UpdateAlarmStatus(RobotAlarmNo.CURR_COORD_NG,False);
    end;
    DefPocb.MSG_MODE_ROBOT_GET_STATUS: begin  //TBD:A2CHv3:ROBOT?
    //CodeSite.Send('#FrmMain# ShowRobotStatus: '+Format('ROBOT%d',[nRobot])+': Mode(MSG_MODE_ROBOT_GET_STATUS) ErrCode('+IntToStr(nErrCode)+') Msg('+sMsg+') ..Unknown MSG_MODE');
    end;
    else begin
      CodeSite.Send('#FrmMain# ShowRobotStatus: '+Format('ROBOT%d',[nRobot+1])+': Mode('+IntToStr(nMode)+') ErrCode('+IntToStr(nErrCode)+') Msg('+sMsg+') ..Unknown MSG_MODE');
    end;
  end;
end;
{$ENDIF} //HAS_ROBOT_CAM_Z

procedure TfrmMain.ShowHandBcrStatus(bConnected : Boolean; sMsg : string);
var
  bIsAlarmOn : Boolean;
  sNgMsg     : String;
begin
  if bConnected then begin
    ledSysInfoHandBcr.TrueColor   := clLime;
    ledSysInfoHandBcr.Value       := True;
    pnlSysInfoHandBcr.Color       := clLime;
    pnlSysInfoHandBcr.Font.Color  := clBlack;
  end
  else begin
    if sMsg = 'NONE' then begin
      ledSysInfoHandBcr.FalseColor := clGray;  
      ledSysInfoHandBcr.Value      := False;   
      pnlSysInfoHandBcr.Color      := clGray;  
      pnlSysInfoHandBcr.Font.Color := clBlack; 
    end
    else begin
      ledSysInfoHandBcr.FalseColor := clRed;
      ledSysInfoHandBcr.Value      := False;
      pnlSysInfoHandBcr.Color      := clRed;
      pnlSysInfoHandBcr.Font.Color := clYellow;
      sNgMsg := 'HandBCR Communication NG'+#13+#10+'    - Check HandBCR Connection';
      {if (not Common.AlarmList[DefPocb.ALARM_HANDBCR_NOT_CONNECTED].bIsOn) then} ShowNgMessage(sNgMsg);
    end;
  end;
  if sMsg <> '' then pnlSysInfoHandBcr.Caption := sMsg;
  // for Alarm
  if (Common.SystemInfo.Com_HandBCR <> 0) then begin
    if bConnected then bIsAlarmOn := False
    else               bIsAlarmOn := True;
    UpdateAlarmStatus(DefPocb.ALARM_HANDBCR_NOT_CONNECTED,bIsAlarmOn);  //Mandatory for POCB
  end;
end;

procedure TfrmMain.ShowExLightStatus(bConnected : Boolean; sMsg : string);  //2019-04-17 ExLight
var
  bIsAlarmOn : Boolean;
  sNgMsg     : String;
begin
  if bConnected then begin
    ledSysInfoExLight.TrueColor  := clLime;
    ledSysInfoExLight.Value      := True;
    pnlSysInfoExLight.Color      := clLime;
    pnlSysInfoExLight.Font.Color := clBlack;
  end
  else begin
    if sMsg = 'NONE' then begin
      ledSysInfoExLight.FalseColor := clGray;
      ledSysInfoExLight.Value      := False;
      pnlSysInfoExLight.Color      := clGray;
      pnlSysInfoExLight.Font.Color := clBlack;
    end
    else begin
      ledSysInfoExLight.FalseColor := clRed;
      ledSysInfoExLight.Value      := False;
      pnlSysInfoExLight.Color      := clRed;
      pnlSysInfoExLight.Font.Color := clYellow;
      sNgMsg := 'Ch1/Ch2 ExLight Communication NG'+#13+#10+'    - Check ExLight Device Connection and Status(Power On, Remote Control)';
      {if (not Common.AlarmList[DefPocb.ALARM_EXLIGHT_NOT_CONNECTED].bIsOn) then} ShowNgMessage(sNgMsg);
    end;
  end;
  if sMsg <> '' then pnlSysInfoExLight.Caption := sMsg;
  // for Alarm
  if (Common.SystemInfo.Com_ExLight <> 0) then begin
    if bConnected then bIsAlarmOn := False
    else               bIsAlarmOn := True;
    UpdateAlarmStatus(DefPocb.ALARM_EXLIGHT_NOT_CONNECTED,bIsAlarmOn);
  end;
end;

procedure TfrmMain.ShowEfuStatus(nConnected : Integer; sMsg : string; nIcuId: Integer = -1);
var
  sNgMsg : string;
begin
  // ledSysInfoEfuLv32Conn, pnlSysInfoEfuLv32Conn
  case nConnected of
    0: begin  //Disconnected
      ledSysInfoEfuLv32Conn.FalseColor := clRed;
      ledSysInfoEfuLv32Conn.Value      := False;
      if sMsg <> '' then pnlSysInfoEfuLv32Conn.Caption := sMsg;
      pnlSysInfoEfuLv32Conn.Color      := clRed;
      pnlSysInfoEfuLv32Conn.Font.Color := clYellow;
      //
      ledSysInfoEfuCh1.FalseColor      := clRed;   //
      ledSysInfoEfuCh1.Value           := False;
      pnlSysInfoEfuCh1Alarm.Caption    := '----';   //
      pnlSysInfoEfuCh1Alarm.Color      := clRed;
      pnlSysInfoEfuCh1Alarm.Font.Color := clYellow;
      if Common.SystemInfo.EfuIcuCntPerCH = 2 then begin
        ledSysInfoEfuCh1_2.FalseColor      := clRed;   //
        ledSysInfoEfuCh1_2.Value           := False;
        pnlSysInfoEfuCh1_2Alarm.Caption    := '----';  //
        pnlSysInfoEfuCh1_2Alarm.Color      := clRed;
        pnlSysInfoEfuCh1_2Alarm.Font.Color := clYellow;
      end;
      ledSysInfoEfuCh2.FalseColor      := clRed;   //
      ledSysInfoEfuCh2.Value           := False;
      pnlSysInfoEfuCh2Alarm.Caption    := '----';   //
      pnlSysInfoEfuCh2Alarm.Color      := clRed;
      pnlSysInfoEfuCh2Alarm.Font.Color := clYellow;
      if Common.SystemInfo.EfuIcuCntPerCH = 2 then begin
        ledSysInfoEfuCh2_2.FalseColor      := clRed;   //
        ledSysInfoEfuCh2_2.Value           := False;
        pnlSysInfoEfuCh2_2Alarm.Caption    := '----';  //
        pnlSysInfoEfuCh2_2Alarm.Color      := clRed;
        pnlSysInfoEfuCh2_2Alarm.Font.Color := clYellow;
      end;
      //
      sNgMsg := 'EFU/LV32-BLDC Communication NG'+#13+#10+'    - Check LV32-BLDC Device Connection and Device Status';
      if (not Common.AlarmList[DefPocb.ALARM_EFU_NOT_CONNECTED].bIsOn) then ShowNgMessage(sNgMsg);
      UpdateAlarmStatus(DefPocb.ALARM_EFU_NOT_CONNECTED,True{bIsAlarmOn});
      UpdateAlarmStatus(DefPocb.ALARM_CH1_EFU_STATUS_NG,False{bIsAlarmOn});
      UpdateAlarmStatus(DefPocb.ALARM_CH2_EFU_STATUS_NG,False{bIsAlarmOn});
      if Common.SystemInfo.EfuIcuCntPerCH = 2 then begin
        UpdateAlarmStatus(DefPocb.ALARM_CH1_EFU2_STATUS_NG,False{bIsAlarmOn});
        UpdateAlarmStatus(DefPocb.ALARM_CH2_EFU2_STATUS_NG,False{bIsAlarmOn});
      end;
    end;
    1: begin  //Connected
      ledSysInfoEfuLv32Conn.TrueColor  := clLime;
      ledSysInfoEfuLv32Conn.Value      := True;
      if sMsg <> '' then pnlSysInfoEfuLv32Conn.Caption := sMsg;
      pnlSysInfoEfuLv32Conn.Color      := clLime;
      pnlSysInfoEfuLv32Conn.Font.Color := clBlack;
      //
      UpdateAlarmStatus(DefPocb.ALARM_EFU_NOT_CONNECTED,False{bIsAlarmOn});
    end;
    2: begin  //NONE
      ledSysInfoEfuLv32Conn.FalseColor := clGray;
      ledSysInfoEfuLv32Conn.Value      := False;
      pnlSysInfoEfuLv32Conn.Caption    := 'NONE';
      pnlSysInfoEfuLv32Conn.Color      := clGray;
      pnlSysInfoEfuLv32Conn.Font.Color := clBlack;
      //
      ledSysInfoEfuCh1.FalseColor      := clGray;   //
      ledSysInfoEfuCh1.Value           := False;
      pnlSysInfoEfuCh1Alarm.Caption    := 'NONE';   //
      pnlSysInfoEfuCh1Alarm.Color      := clGray;
      pnlSysInfoEfuCh1Alarm.Font.Color := clBlack;
      if Common.SystemInfo.EfuIcuCntPerCH = 2 then begin
        ledSysInfoEfuCh1_2.FalseColor      := clGray;   //
        ledSysInfoEfuCh1_2.Value           := False;
        pnlSysInfoEfuCh1_2Alarm.Caption    := 'NONE';   //
        pnlSysInfoEfuCh1_2Alarm.Color      := clGray;
        pnlSysInfoEfuCh1_2Alarm.Font.Color := clBlack;
      end;
      ledSysInfoEfuCh2.FalseColor      := clGray;   //
      ledSysInfoEfuCh2.Value           := False;
      pnlSysInfoEfuCh2Alarm.Caption    := 'NONE';   //
      pnlSysInfoEfuCh2Alarm.Color      := clGray;
      pnlSysInfoEfuCh2Alarm.Font.Color := clBlack;
      if Common.SystemInfo.EfuIcuCntPerCH = 2 then begin
        ledSysInfoEfuCh2_2.FalseColor      := clGray;   //
        ledSysInfoEfuCh2_2.Value           := False;
        pnlSysInfoEfuCh2_2Alarm.Caption    := 'NONE';   //
        pnlSysInfoEfuCh2_2Alarm.Color      := clGray;
        pnlSysInfoEfuCh2_2Alarm.Font.Color := clBlack;
      end;
      //
      UpdateAlarmStatus(DefPocb.ALARM_EFU_NOT_CONNECTED,False{bIsAlarmOn});
      UpdateAlarmStatus(DefPocb.ALARM_CH1_EFU_STATUS_NG,False{bIsAlarmOn});
      UpdateAlarmStatus(DefPocb.ALARM_CH2_EFU_STATUS_NG,False{bIsAlarmOn});
      if Common.SystemInfo.EfuIcuCntPerCH = 2 then begin
        UpdateAlarmStatus(DefPocb.ALARM_CH1_EFU2_STATUS_NG,False{bIsAlarmOn});
        UpdateAlarmStatus(DefPocb.ALARM_CH2_EFU2_STATUS_NG,False{bIsAlarmOn});
      end;
    end;
    3: begin //ICU Status
      if Common.SystemInfo.EfuIcuCntPerCH = 2 then begin
        case nIcuId of
          1: begin  // EFU_ICUID_MIN
            if DongaEfu.m_IcuSt[nIcuId].RX_Alarm = $80 then begin  // Normal
              ledSysInfoEfuCh1.TrueColor       := clLime;
              ledSysInfoEfuCh1.Value           := True;
              pnlSysInfoEfuCh1Alarm.Caption    := Format('%d',[DongaEfu.m_IcuSt[nIcuId].RX_PV*10]); //RPM = PV *10
              pnlSysInfoEfuCh1Alarm.Color      := clLime;
              pnlSysInfoEfuCh1Alarm.Font.Color := clBlack;
            end
            else begin  // NG
              ledSysInfoEfuCh1.FalseColor      := clRed;
              ledSysInfoEfuCh1.Value           := False;
              pnlSysInfoEfuCh1Alarm.Caption    := 'Alarm'+Format('(0x%02x)',[DongaEfu.m_IcuSt[nIcuId].RX_Alarm]);
              pnlSysInfoEfuCh1Alarm.Color      := clRed;
              pnlSysInfoEfuCh1Alarm.Font.Color := clYellow;
              //
              sNgMsg := 'Ch1 EFU1(ICUID=1) Status NG ('+sMsg+')'+#13+#10+'    - Check EFU/ICU Status using LV32-BLDC';
              if (not Common.AlarmList[DefPocb.ALARM_CH1_EFU_STATUS_NG].bIsOn) then ShowNgMessage(sNgMsg);
              //
              UpdateAlarmStatus(DefPocb.ALARM_CH1_EFU_STATUS_NG,True{bIsAlarmOn});
            end;
          end;
          2: begin
            if DongaEfu.m_IcuSt[nIcuId].RX_Alarm = $80 then begin  // Normal
              ledSysInfoEfuCh1_2.TrueColor       := clLime;
              ledSysInfoEfuCh1_2.Value           := True;
              pnlSysInfoEfuCh1_2Alarm.Caption    := Format('%d',[DongaEfu.m_IcuSt[nIcuId].RX_PV*10]); //RPM = PV *10
              pnlSysInfoEfuCh1_2Alarm.Color      := clLime;
              pnlSysInfoEfuCh1_2Alarm.Font.Color := clBlack;
            end
            else begin  // NG
              ledSysInfoEfuCh1_2.FalseColor      := clRed;
              ledSysInfoEfuCh1_2.Value           := False;
              pnlSysInfoEfuCh1_2Alarm.Caption    := 'Alarm'+Format('(0x%02x)',[DongaEfu.m_IcuSt[nIcuId].RX_Alarm]);
              pnlSysInfoEfuCh1_2Alarm.Color      := clRed;
              pnlSysInfoEfuCh1_2Alarm.Font.Color := clYellow;
              //
              sNgMsg := 'Ch1 EFU2(ICUID=2) Status NG ('+sMsg+')'+#13+#10+'    - Check EFU/ICU Status using LV32-BLDC';
              if (not Common.AlarmList[DefPocb.ALARM_CH1_EFU2_STATUS_NG].bIsOn) then ShowNgMessage(sNgMsg);
              //
              UpdateAlarmStatus(DefPocb.ALARM_CH1_EFU2_STATUS_NG,True{bIsAlarmOn});
            end;
          end;
          3: begin
            if DongaEfu.m_IcuSt[nIcuId].RX_Alarm = $80 then begin  //
              ledSysInfoEfuCh2.TrueColor       := clLime;
              ledSysInfoEfuCh2.Value           := True;
              pnlSysInfoEfuCh2Alarm.Caption    := Format('%d',[DongaEfu.m_IcuSt[nIcuId].RX_PV*10]); //RPM = PV *10
              pnlSysInfoEfuCh2Alarm.Color      := clLime;
              pnlSysInfoEfuCh2Alarm.Font.Color := clBlack;
            end
            else begin  // NG
              ledSysInfoEfuCh2.FalseColor      := clRed;
              ledSysInfoEfuCh2.Value           := False;
              pnlSysInfoEfuCh2Alarm.Caption    := 'Alarm'+Format('(0x%02x)',[DongaEfu.m_IcuSt[nIcuId].RX_Alarm]);
              pnlSysInfoEfuCh2Alarm.Color      := clRed;
              pnlSysInfoEfuCh2Alarm.Font.Color := clYellow;
              //
              sNgMsg := 'Ch2 EFU1(ICUID=3) Status NG ('+sMsg+')'+#13+#10+'    - Check EFU/ICU Status using LV32-BLDC';
              if (not Common.AlarmList[DefPocb.ALARM_CH2_EFU_STATUS_NG].bIsOn) then ShowNgMessage(sNgMsg);
              //
              UpdateAlarmStatus(DefPocb.ALARM_CH2_EFU_STATUS_NG,True{bIsAlarmOn});
            end;
          end;
          4: begin
            if DongaEfu.m_IcuSt[nIcuId].RX_Alarm = $80 then begin  //
              ledSysInfoEfuCh2_2.TrueColor       := clLime;
              ledSysInfoEfuCh2_2.Value           := True;
              pnlSysInfoEfuCh2_2Alarm.Caption    := Format('%d',[DongaEfu.m_IcuSt[nIcuId].RX_PV*10]); //RPM = PV *10
              pnlSysInfoEfuCh2_2Alarm.Color      := clLime;
              pnlSysInfoEfuCh2_2Alarm.Font.Color := clBlack;
            end
            else begin  // NG
              ledSysInfoEfuCh2_2.FalseColor      := clRed;
              ledSysInfoEfuCh2_2.Value           := False;
              pnlSysInfoEfuCh2_2Alarm.Caption    := 'Alarm'+Format('(0x%02x)',[DongaEfu.m_IcuSt[nIcuId].RX_Alarm]);
              pnlSysInfoEfuCh2_2Alarm.Color      := clRed;
              pnlSysInfoEfuCh2_2Alarm.Font.Color := clYellow;
              //
              sNgMsg := 'Ch2 EFU2(ICUID=4) Status NG ('+sMsg+')'+#13+#10+'    - Check EFU/ICU Status using LV32-BLDC';
              if (not Common.AlarmList[DefPocb.ALARM_CH2_EFU2_STATUS_NG].bIsOn) then ShowNgMessage(sNgMsg);
              //
              UpdateAlarmStatus(DefPocb.ALARM_CH2_EFU2_STATUS_NG,True{bIsAlarmOn});
            end;
          end;
        end;
      end
      else begin  //Common.SystemInfo.EfuIcuCntPerCH = 1
        case nIcuId of
          1: begin  // EFU_ICUID_MIN
            if DongaEfu.m_IcuSt[nIcuId].RX_Alarm = $80 then begin  // Normal
              ledSysInfoEfuCh1.TrueColor       := clLime;
              ledSysInfoEfuCh1.Value           := True;
              pnlSysInfoEfuCh1Alarm.Caption    := Format('%d',[DongaEfu.m_IcuSt[nIcuId].RX_PV*10]); //RPM = PV *10
              pnlSysInfoEfuCh1Alarm.Color      := clLime;
              pnlSysInfoEfuCh1Alarm.Font.Color := clBlack;
            end
            else begin  // NG
              ledSysInfoEfuCh1.FalseColor      := clRed;
              ledSysInfoEfuCh1.Value           := False;
              pnlSysInfoEfuCh1Alarm.Caption    := 'Alarm'+Format('(0x%02x)',[DongaEfu.m_IcuSt[nIcuId].RX_Alarm]);
              pnlSysInfoEfuCh1Alarm.Color      := clRed;
              pnlSysInfoEfuCh1Alarm.Font.Color := clYellow;
              //
              sNgMsg := 'Ch1 EFU(ICUID=1) Status NG ('+sMsg+')'+#13+#10+'    - Check EFU/ICU Status using LV32-BLDC';
              if (not Common.AlarmList[DefPocb.ALARM_CH1_EFU_STATUS_NG].bIsOn) then ShowNgMessage(sNgMsg);
              //
              UpdateAlarmStatus(DefPocb.ALARM_CH1_EFU_STATUS_NG,True{bIsAlarmOn});
            end;
          end;
          2: begin
            if DongaEfu.m_IcuSt[nIcuId].RX_Alarm = $80 then begin  //
              ledSysInfoEfuCh2.TrueColor       := clLime;
              ledSysInfoEfuCh2.Value           := True;
              pnlSysInfoEfuCh2Alarm.Caption    := Format('%d',[DongaEfu.m_IcuSt[nIcuId].RX_PV*10]); //RPM = PV *10
              pnlSysInfoEfuCh2Alarm.Color      := clLime;
              pnlSysInfoEfuCh2Alarm.Font.Color := clBlack;
            end
            else begin  // NG
              ledSysInfoEfuCh2.FalseColor      := clRed;
              ledSysInfoEfuCh2.Value           := False;
              pnlSysInfoEfuCh2Alarm.Caption    := 'Alarm'+Format('(0x%02x)',[DongaEfu.m_IcuSt[nIcuId].RX_Alarm]);
              pnlSysInfoEfuCh2Alarm.Color      := clRed;
              pnlSysInfoEfuCh2Alarm.Font.Color := clYellow;
              //
              sNgMsg := 'Ch2 EFU(ICUID=2) Status NG ('+sMsg+')'+#13+#10+'    - Check EFU/ICU Status using LV32-BLDC';
              if (not Common.AlarmList[DefPocb.ALARM_CH2_EFU_STATUS_NG].bIsOn) then ShowNgMessage(sNgMsg);
              //
              UpdateAlarmStatus(DefPocb.ALARM_CH2_EFU_STATUS_NG,True{bIsAlarmOn});
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.SetDioFlow(InDio, OutDio: ADioStatus);
var
  i: Integer;
//bTemp : Boolean;
  nCh {, nJig, nStartCh, nEndCh} : Integer;
  nDioInShutterDown, nDioOutShutterDown : Integer;
  bIsAlarmOn  : Boolean;
  nAlarmNo    : Integer;
  nDioMask    : UInt64;
{$IFDEF HAS_DIO_Y_AXIS_MC}
  bMC1MC2AlarmOnOLD, bMC1MC2AlarmOnNEW : Boolean;
{$ENDIF}
begin
	if (DongaDio = nil) or (not DongaDio.m_bDioFirstReadDone) then Exit;  //2019-04-05 TBD?
  // for GUI DIO-IN/OUT
  for i := 0 to DefDio.MAX_DIO_IN do begin
    ledDioIn[i].LedOn    := InDio[i];
    //if InDio[i] then CodeSite.Send('SetDioFlow:IN:ON:'+IntToStr(i));
  end;
  for i := 0 to DefDio.MAX_DIO_OUT do begin
      ledDioOut[i].LedOn := OutDio[i];
  end;
  { //TBD:SAFETY? for Maint Button (for PM Mode)
  if InDio[ALARM_DIO_TEACH_MODE_SWITCH] then begin
    btnMaint.Enabled := True;   // Key(Teach)인 경우, Maint창 버튼 활성화
  end
  else begin
    btnMaint.Enabled := False;  // Key(Auto)인 경우, Maint창 버튼 비활성화
  end; }
  // for Alarm
  for i := DefDio.IN_EMO1_FRONT to DefDio.MAX_DIO_IN do begin
    nAlarmNo := 0;
    if InDio[i] then bIsAlarmOn := True else bIsAlarmOn := False; // default
    case i of
    //DefDio.IN_STAGE1_READY:
      //
    //DefDio.IN_STAGE2_READY:
      //
      DefDio.IN_EMO1_FRONT: begin
        nAlarmNo := DefPocb.ALARM_DIO_EMO1_FRONT;
        {$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_EMO1_FRONT;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := True else bIsAlarmOn := False;
        end;
        {$ENDIF}
      end;
      DefDio.IN_EMO2_RIGHT: begin
        nAlarmNo := DefPocb.ALARM_DIO_EMO2_RIGHT;
        {$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_EMO2_RIGHT;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := True else bIsAlarmOn := False;
        end;
        {$ENDIF}
      end;
      DefDio.IN_EMO3_INNER_RIGHT: begin
        nAlarmNo := DefPocb.ALARM_DIO_EMO3_INNER_RIGHT;
        {$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_EMO3_INNER_RIGHT;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := True else bIsAlarmOn := False;
        end;
        {$ENDIF}
      end;
      DefDio.IN_EMO4_INNER_LEFT: begin
        nAlarmNo := DefPocb.ALARM_DIO_EMO4_INNER_LEFT;
        {$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_EMO4_INNER_LEFT;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := True else bIsAlarmOn := False;
        end;
        {$ENDIF}
      end;
      DefDio.IN_EMO5_LEFT: begin
        nAlarmNo := DefPocb.ALARM_DIO_EMO5_LEFT;
        {$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_EMO5_LEFT;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := True else bIsAlarmOn := False;
        end;
        {$ENDIF}
      end;
      DefDio.IN_LEFT_FAN_IN: begin
        nAlarmNo := DefPocb.ALARM_DIO_LEFT_FAN_IN;
        {$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_LEFT_FAN_IN;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
        end;
        {$ELSE}
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
        {$ENDIF}
      end;
		  DefDio.IN_RIGHT_FAN_IN: begin
        nAlarmNo := DefPocb.ALARM_DIO_RIGHT_FAN_IN;
        {$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_RIGHT_FAN_IN;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
        end;
        {$ELSE}
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
        {$ENDIF}
      end;
		  DefDio.IN_LEFT_FAN_OUT: begin
        nAlarmNo := DefPocb.ALARM_DIO_LEFT_FAN_OUT;
        {$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_LEFT_FAN_OUT;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
        end;
        {$ELSE}
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
        {$ENDIF}
      end;
		  DefDio.IN_RIGHT_FAN_OUT: begin
        nAlarmNo := DefPocb.ALARM_DIO_RIGHT_FAN_OUT;
        {$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_RIGHT_FAN_OUT;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
        end;
        {$ELSE}
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
        {$ENDIF}
      end;
		  DefDio.IN_CP1, DefDio.IN_CP2, DefDio.IN_CP3 : begin
        nAlarmNo := DefPocb.ALARM_DIO_CP1 + i - DefDio.IN_CP1 ;
        if InDio[i] then begin
           bIsAlarmOn := True ;
        end
        else begin
            bIsAlarmOn := False;
        end;
      end;

      DefDio.IN_CP6 : begin
        nAlarmNo := DefPocb.ALARM_DIO_CP6;
        if InDio[i] then begin
           bIsAlarmOn := True ;
        end
        else begin
            bIsAlarmOn := False;
        end;
      end;

      {$IFDEF HAS_DIO_FAN_INOUT_PC} //2022-07-15 A2CHv4_#3(FanInOutPC)
      DefDio.IN_MAINPC_FAN_IN: begin
				if Common.SystemInfo.HasDioFanInOutPC then begin			
        	nAlarmNo := DefPocb.ALARM_DIO_MAINPC_FAN_IN;
	        {$IFDEF DIO_ALARM_THRESHOLD}
	        nDioMask   := DefDio.MASK_IN_MAINPC_FAN_IN;
	        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
	        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
	          if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
	        end;
	        {$ELSE}
	        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
	        {$ENDIF}
				end;
      end;
		  DefDio.IN_MAINPC_FAN_OUT: begin
				if Common.SystemInfo.HasDioFanInOutPC then begin						
	        nAlarmNo := DefPocb.ALARM_DIO_MAINPC_FAN_OUT;
	        {$IFDEF DIO_ALARM_THRESHOLD}
	        nDioMask   := DefDio.MASK_IN_MAINPC_FAN_OUT;
	        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
	        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
	          if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
	        end;
	        {$ELSE}
	        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
	        {$ENDIF}
				end;
      end;
		  DefDio.IN_CAMPC_FAN_IN: begin
				if Common.SystemInfo.HasDioFanInOutPC then begin									
	        nAlarmNo := DefPocb.ALARM_DIO_CAMPC_FAN_IN;
	        {$IFDEF DIO_ALARM_THRESHOLD}
	        nDioMask   := DefDio.MASK_IN_CAMPC_FAN_IN;
	        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
	        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
	          if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
	        end;
	        {$ELSE}
	        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
	        {$ENDIF}
				end;
      end;
		  DefDio.IN_CAMPC_FAN_OUT: begin
				if Common.SystemInfo.HasDioFanInOutPC then begin									
	        nAlarmNo := DefPocb.ALARM_DIO_CAMPC_FAN_OUT;
	        {$IFDEF DIO_ALARM_THRESHOLD}
	        nDioMask   := DefDio.MASK_IN_CAMPC_FAN_OUT;
	        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
	        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
	          if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
	        end;
	        {$ELSE}
	        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
	        {$ENDIF}
	      end;
			end;
     {$ENDIF}

      //
    //DefDio.IN_STAGE1_MUTING_LAMP:
    //DefDio.IN_STAGE2_MUTING_LAMP:
    //DefDio.IN_STAGE1_LIGHT_CURTAIN:
    //DefDio.IN_STAGE2_LIGHT_CURTAIN:
      //
      DefDio.IN_STAGE1_KEY_AUTO,
      DefDio.IN_STAGE1_KEY_TEACH: begin  //TBD:A2CHv3:DIO? (ATUO/TEACTH)
        nAlarmNo := DefPocb.ALARM_DIO_STAGE1_NOT_AUTOMODE;
        bIsAlarmOn := (not InDio[DefDio.IN_STAGE1_KEY_AUTO]) or InDio[DefDio.IN_STAGE1_KEY_TEACH];
      //i := DefDio.IN_STAGE1_KEY_TEACH;
      end;
      DefDio.IN_STAGE2_KEY_AUTO,
      DefDio.IN_STAGE2_KEY_TEACH: begin  //TBD:A2CHv3:DIO? (ATUO/TEACTH)
        nAlarmNo := DefPocb.ALARM_DIO_STAGE2_NOT_AUTOMODE;
        bIsAlarmOn := (not InDio[DefDio.IN_STAGE2_KEY_AUTO]) or InDio[DefDio.IN_STAGE2_KEY_TEACH];
      //i := DefDio.IN_STAGE2_KEY_TEACH;
      end;
      DefDio.IN_STAGE1_DOOR1_OPEN: begin
        nAlarmNo := DefPocb.ALARM_DIO_STAGE1_DOOR1_OPEN;
      end;
      DefDio.IN_STAGE1_DOOR2_OPEN: begin
        nAlarmNo := DefPocb.ALARM_DIO_STAGE1_DOOR2_OPEN;
      end;
      DefDio.IN_STAGE2_DOOR1_OPEN: begin
        nAlarmNo := DefPocb.ALARM_DIO_STAGE2_DOOR1_OPEN;
      end;
      DefDio.IN_STAGE2_DOOR2_OPEN: begin
        nAlarmNo := DefPocb.ALARM_DIO_STAGE2_DOOR2_OPEN;
      end;
{$IFDEF HAS_DIO_IN_DOOR_LOCK}
      DefDio.IN_STAGE1_DOOR1_LOCK: begin
        nAlarmNo := DefPocb.ALARM_DIO_STAGE1_DOOR1_LOCK;
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
      end;
      DefDio.IN_STAGE1_DOOR2_LOCK: begin
        nAlarmNo := DefPocb.ALARM_DIO_STAGE1_DOOR2_LOCK;
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
      end;
      DefDio.IN_STAGE2_DOOR1_LOCK: begin
        nAlarmNo := DefPocb.ALARM_DIO_STAGE2_DOOR1_LOCK;
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
      end;
      DefDio.IN_STAGE2_DOOR2_LOCK: begin
        nAlarmNo := DefPocb.ALARM_DIO_STAGE2_DOOR2_LOCK;
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
      end;
{$ENDIF}
      DefDio.IN_CYLINDER_REGULATOR: begin
        nAlarmNo := DefPocb.ALARM_DIO_CYLINDER_REGULATOR;
{$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_CYLINDER_REGULATOR;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
        end;
{$ELSE}
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
{$ENDIF}
      end;
      DefDio.IN_VACUUM_REGULATOR: begin
				if Common.SystemInfo.HasDioVacuum then begin  //ATO(False),ATO-TRIBUTO|else(True) //2023-04-10 HasDioVacuum
          nAlarmNo := DefPocb.ALARM_DIO_VACUUM_REGULATOR;
          {$IFDEF DIO_ALARM_THRESHOLD}
          nDioMask   := DefDio.MASK_IN_VACUUM_REGULATOR;
          bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
          if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
            if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
          end;
          {$ELSE}
          if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
          {$ENDIF}
        end;
      end;
		  DefDio.IN_TEMPERATURE_ALARM: begin
        nAlarmNo := DefPocb.ALARM_DIO_TEMPERATURE;
{$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_TEMPERATURE_ALARM;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := True else bIsAlarmOn := False;
        end;
{$ENDIF}
      end;
		  DefDio.IN_POWER_HIGH_ALARM: begin
        nAlarmNo := DefPocb.ALARM_DIO_POWER_HIGH;
{$IFDEF DIO_ALARM_THRESHOLD}
        nDioMask   := DefDio.MASK_IN_POWER_HIGH_ALARM;
        bIsAlarmOn := Common.AlarmList[nAlarmNo].bIsOn;
        if ((DongaDio.m_nOldChangedDIValue and nDioMask) <> 0) and ((DongaDio.m_nChangedDIValue and nDioMask) = 0) then begin  //Keep Changed
          if InDio[i] then bIsAlarmOn := True else bIsAlarmOn := False;
        end;
{$ENDIF}
      end;
      DefDio.IN_MC1: begin
        nAlarmNo := DefPocb.ALARM_DIO_MC1;
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
      end;
      DefDio.IN_MC2: begin
        nAlarmNo := DefPocb.ALARM_DIO_MC2;
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
      end;
{$IFDEF HAS_DIO_Y_AXIS_MC}
      DefDio.IN_STAGE1_Y_AXIS_MC: begin
        nAlarmNo := DefPocb.ALARM_DIO_Y_AXIS_MC_CH1;
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
      end;
      DefDio.IN_STAGE2_Y_AXIS_MC: begin
        nAlarmNo := DefPocb.ALARM_DIO_Y_AXIS_MC_CH2;
        if InDio[i] then bIsAlarmOn := False else bIsAlarmOn := True;
      end;
{$ENDIF}
      //
    //DefDio.IN_STAGE1_SHUTTER_UP:
    //DefDio.IN_STAGE1_SHUTTER_DOWN:
    //DefDio.IN_STAGE2_SHUTTER_UP:
    //DefDio.IN_STAGE2_SHUTTER_DOWN:
    //DefDio.IN_STAGE1_SCREW_SHUTTER_UP:
    //DefDio.IN_STAGE1_SCREW_SHUTTER_DOWN:
    //DefDio.IN_STAGE2_SCREW_SHUTTER_UP:
    //DefDio.IN_STAGE2_SCREW_SHUTTER_DOWN:
      //
      {$IFDEF SUPPORT_1CG2PANEL}
      DefDio.IN_SHUTTER_GUIDE_UP,
      DefDio.IN_SHUTTER_GUIDE_DOWN: begin
        if (not Common.SystemInfo.UseAssyPOCB) then begin  //TBD:A2CHv3:DIO? (not-ASSY?)
          nAlarmNo := DefPocb.ALARM_DIO_SHUTTER_GUIDE_NOT_UP;
          bIsAlarmOn := (not InDio[DefDio.IN_SHUTTER_GUIDE_UP]) or InDio[DefDio.IN_SHUTTER_GUIDE_DOWN];
        end;
      end;
      DefDio.IN_CAMZONE_PARTITION_UP1,
      DefDio.IN_CAMZONE_PARTITION_UP2,
      DefDio.IN_CAMZONE_PARTITION_DOWN1,
      DefDio.IN_CAMZONE_PARTITION_DOWN2: begin
        if (not Common.SystemInfo.UseAssyPOCB) then begin
          nAlarmNo := DefPocb.ALARM_DIO_CAMZONE_PARTITION_NOT_DOWN;
          bIsAlarmOn := InDio[DefDio.IN_CAMZONE_PARTITION_UP1] or InDio[DefDio.IN_CAMZONE_PARTITION_UP2] or
                        (not InDio[DefDio.IN_CAMZONE_PARTITION_DOWN1]) or (not InDio[DefDio.IN_CAMZONE_PARTITION_DOWN2]);
        end
        else begin
          nAlarmNo := DefPocb.ALARM_DIO_CAMZONE_PARTITION_NOT_UP;
          bIsAlarmOn := (not InDio[DefDio.IN_CAMZONE_PARTITION_UP1]) or (not InDio[DefDio.IN_CAMZONE_PARTITION_UP2]) or
                        InDio[DefDio.IN_CAMZONE_PARTITION_DOWN1] or InDio[DefDio.IN_CAMZONE_PARTITION_DOWN2];
        end;
      end;
      {$ENDIF} //SUPPORT_1CG2PANEL
      //
    //DefDio.IN_STAGE1_EXLIGHT_DETECT:
    //DefDio.IN_STAGE2_EXLIGHT_DETECT:
    //DefDio.IN_STAGE1_WORKING_ZONE:
    //DefDio.IN_STAGE2_WORKING_ZONE:
    //DefDio.IN_STAGE1_VACUUM1:
    //DefDio.IN_STAGE1_VACUUM2:
    //DefDio.IN_STAGE2_VACUUM1:
    //DefDio.IN_STAGE2_VACUUM2:
      //
      {$IFDEF SUPPORT_1CG2PANEL}
      DefDio.IN_CAMZONE_INNER_DOOR_OPEN,
      DefDio.IN_CAMZONE_INNER_DOOR_CLOSE: begin
        if (not Common.SystemInfo.UseAssyPOCB) then begin  //TBD:A2CHv3:DIO? (not-ASSY?)
          nAlarmNo := DefPocb.ALARM_DIO_CAMZONE_INNER_DOOR_NOT_CLOSE;
          bIsAlarmOn := InDio[DefDio.IN_CAMZONE_INNER_DOOR_OPEN] or (not InDio[DefDio.IN_CAMZONE_INNER_DOOR_CLOSE]);
        end
        else begin  //TBD:A2CHv3:DIO? (ASSY?)
          nAlarmNo := DefPocb.ALARM_DIO_CAMZONE_INNER_DOOR_NOT_OPEN;
          bIsAlarmOn := (not InDio[DefDio.IN_CAMZONE_INNER_DOOR_OPEN]) or InDio[DefDio.IN_CAMZONE_INNER_DOOR_CLOSE];
        end;
      end;
      DefDio.IN_STAGE1_JIG_INTERLOCK,
      DefDio.IN_STAGE2_JIG_INTERLOCK: begin
        if (not Common.SystemInfo.UseAssyPOCB) then begin
          if not (InDio[DefDio.IN_LOADZONE_PARTITION1] and InDio[DefDio.IN_LOADZONE_PARTITION2]) then begin
            //2021-02-22 CP-POCB(No ALARM_DIO_ASSY_JIG_DETECTED if LoadingZonePartitions are detected)
            nAlarmNo := DefPocb.ALARM_DIO_ASSY_JIG_DETECTED;
            bIsAlarmOn := InDio[DefDio.IN_STAGE1_JIG_INTERLOCK]{ or InDio[DefDio.IN_STAGE2_JIG_INTERLOCK])};
          end;
        end
        else begin
          nAlarmNo := DefPocb.ALARM_DIO_ASSY_JIG_STAGE_NOT_ALIGNED;
          bIsAlarmOn := InDio[DefDio.IN_STAGE1_JIG_INTERLOCK] and InDio[DefDio.IN_STAGE2_JIG_INTERLOCK];
        end;
      end;
      {$ENDIF} //SUPPORT_1CG2PANEL

      //
      {$IFDEF SUPPORT_1CG2PANEL}
      DefDio.IN_LOADZONE_PARTITION1,
      DefDio.IN_LOADZONE_PARTITION2: begin
        if (not Common.SystemInfo.UseAssyPOCB) then begin
          nAlarmNo := DefPocb.ALARM_DIO_LOADZONE_PARTITION_NOT_DETECTED;
          bIsAlarmOn := not (InDio[DefDio.IN_LOADZONE_PARTITION1] and InDio[DefDio.IN_LOADZONE_PARTITION2]);
        end
        else begin
          nAlarmNo := DefPocb.ALARM_DIO_LOADZONE_PARTITION_DETECTED;
          bIsAlarmOn := (InDio[DefDio.IN_LOADZONE_PARTITION1] or InDio[DefDio.IN_LOADZONE_PARTITION2]);
        end;
      end;
      {$ENDIF} //SUPPORT_1CG2PANEL
    end;

    {$IFDEF HAS_DIO_Y_AXIS_MC}
    if Common.SystemInfo.HasDioYAxisMC and (nAlarmNo in [DefPocb.ALARM_DIO_MC1,DefPocb.ALARM_DIO_MC2]) then begin
      bMC1MC2AlarmOnOLD := (Common.AlarmList[DefPocb.ALARM_DIO_MC1].bIsOn or Common.AlarmList[DefPocb.ALARM_DIO_MC2].bIsOn);
    end;
    {$ENDIF}

    if (nAlarmNo <> 0) and (Common.AlarmList[nAlarmNo].bIsOn <> bIsAlarmOn) then begin
      UpdateAlarmStatus(nAlarmNo,bIsAlarmOn);   // for Alarm
    end;

    {$IFDEF HAS_DIO_Y_AXIS_MC}
    if Common.SystemInfo.HasDioYAxisMC and (nAlarmNo in [DefPocb.ALARM_DIO_MC1,DefPocb.ALARM_DIO_MC2]) then begin
      bMC1MC2AlarmOnNEW := (Common.AlarmList[DefPocb.ALARM_DIO_MC1].bIsOn or Common.AlarmList[DefPocb.ALARM_DIO_MC2].bIsOn);
    end;
    {$ENDIF}

    if nAlarmNo in [DefPocb.ALARM_DIO_MC1,DefPocb.ALARM_DIO_MC2] then begin
{$IFDEF HAS_DIO_Y_AXIS_MC}
      if Common.SystemInfo.HasDioYAxisMC then begin
        if (bMC1MC2AlarmOnOLD <> bMC1MC2AlarmOnNEW) then begin
          if bMC1MC2AlarmOnNEW then begin // MC1/MC2 Alarm Occur --> Y_AXIS_MC OFF
            DongaDio.SetDoValue(DefDio.OUT_STAGE1_Y_AXIS_MC_ON, False); // CH1 Y_AXIS_MC OFF
            DongaDio.SetDoValue(DefDio.OUT_STAGE2_Y_AXIS_MC_ON, False); // CH2 Y_AXIS_MC OFF
          end
          else begin                      // MC1/MC2 Alarm Clear --> Y_AXIS_MC ON
            DongaDio.SetDoValue(DefDio.OUT_STAGE1_Y_AXIS_MC_ON, True);  // CH1 Y_AXIS_MC ON
            DongaDio.SetDoValue(DefDio.OUT_STAGE2_Y_AXIS_MC_ON, True);  // CH2 Y_AXIS_MC ON
          end;
        end;
      end;
{$ENDIF}
      if Common.AlarmList[nAlarmNo].bIsOn then begin
{$IFDEF HAS_MOTION_CAM_Z}
        if not Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Z_NEED_HOME_SEARCH].bIsOn then
          UpdateAlarmStatus(DefPocb.ALARM_CH1_MOTION_Z_NEED_HOME_SEARCH, True);
        if not Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Z_NEED_HOME_SEARCH].bIsOn then
          UpdateAlarmStatus(DefPocb.ALARM_CH2_MOTION_Z_NEED_HOME_SEARCH, True);
{$ENDIF}
        if not Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_NEED_HOME_SEARCH].bIsOn then
          UpdateAlarmStatus(DefPocb.ALARM_CH1_MOTION_Y_NEED_HOME_SEARCH, True);
        if not Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_NEED_HOME_SEARCH].bIsOn then
          UpdateAlarmStatus(DefPocb.ALARM_CH2_MOTION_Y_NEED_HOME_SEARCH, True);
      end;
    end;

{$IFDEF HAS_DIO_Y_AXIS_MC}
    if Common.SystemInfo.HasDioYAxisMC then begin
      if (nAlarmNo = DefPocb.ALARM_DIO_Y_AXIS_MC_CH1) and Common.AlarmList[nAlarmNo].bIsOn then begin
        if not Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_NEED_HOME_SEARCH].bIsOn then
          UpdateAlarmStatus(DefPocb.ALARM_CH1_MOTION_Y_NEED_HOME_SEARCH, True);
      end;
      if (nAlarmNo = DefPocb.ALARM_DIO_Y_AXIS_MC_CH2) and Common.AlarmList[nAlarmNo].bIsOn then begin
        if not Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_NEED_HOME_SEARCH].bIsOn then
          UpdateAlarmStatus(DefPocb.ALARM_CH2_MOTION_Y_NEED_HOME_SEARCH, True);
      end;
    end;
{$ENDIF}
  end;
  //
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    case nCh of
      DefPocb.CH_1: nDioInShutterDown := DefDio.IN_STAGE1_SHUTTER_DOWN;
      DefPocb.CH_2: nDioInShutterDown := DefDio.IN_STAGE2_SHUTTER_DOWN;
      else Exit;
    end;
    if InDio[nDioInShutterDown] and (DongaDio.m_nAutoFlow[nCh] = DefDio.IO_AUTO_FLOW_SHUTTER_DOWN) then begin
      case nCh of
        DefPocb.CH_1: if DongaDio.IsReadyToTurn1 then DongaDio.m_nAutoFlow[nCh] := DefDio.IO_AUTO_FLOW_CAMERA;
        DefPocb.CH_2: if DongaDio.IsReadyToTurn2 then DongaDio.m_nAutoFlow[nCh] := DefDio.IO_AUTO_FLOW_CAMERA;
      end;
      //2019-04-27 DIO:CamZone에서 ShutterUp안되어 배출되지 않는 경우 보완? ...start
      if nCh = DefPocb.CH_1 then nDioOutShutterDown := DefDio.OUT_STAGE1_SHUTTER_DOWN
      else                       nDioOutShutterDown := DefDio.OUT_STAGE2_SHUTTER_DOWN;
      if (DongaDio.m_nDOValue and (UInt64(1) shl nDioOutShutterDown)) <> 0 then DongaDio.SetDio(nDioOutShutterDown);  //ShutterDown OUT신호 해제?
			//2019-04-27 DIO:CamZone에서 ShutterUp안되어 배출되지 않는 경우 보완? ...end
      if nCh = DefPocb.CH_1 then CameraComm.OnTEndEvt  := JigLogic[nCh].MakeCamEvent
      else                       CameraComm.OnTEndEvt1 := JigLogic[nCh].MakeCamEvent1;
      //
      DongaDio.GetUnitTTLog(nCh,DefDio.DIO_IDX_GET_TT_SHT_DN);
      Logic[nCh].SendStartSeq2;
    end;
  end;
end;

procedure TfrmMain.UpdateAlarmStatus(nAlarmNo: Integer; bIsOn: Boolean; sMsg: string = '');
var
  bHighPriorityAlarmOn : Boolean;  //2019-03-29
  bDioMotionAlarmOnOff : Boolean;  //2019-03-29
  sDebug : string;
  sDioNo, sErrLogHeader, sErrLogData : string; //2011-12-06

  function IsAutoCloseIfAlarmOff(nAlarmNo: Integer): Boolean; //2023-06-07
  begin
    Result := True;
    if nAlarmNo in [
      {$IF Defined(POCB_A2CH)} //############################################
      //,AlARM_DIO_NOT_CONNECTED
         AlARM_DIO_EMO
      //,AlARM_DIO_TEACH_MODE_SWITCH
      //,AlARM_DIO_LIGHT_CURTAIN
      //,AlARM_DIO_DOOR_LEFT
      //,AlARM_DIO_DOOR_RIGHT
      //,AlARM_DIO_DOOR_UNDER
      //,AlARM_DIO_LEFT_FAN_IN
      //,AlARM_DIO_RIGHT_FAN_IN
      //,AlARM_DIO_LEFT_FAN_OUT
      //,AlARM_DIO_RIGHT_FAN_OUT
      //,AlARM_DIO_TEMPERATURE
      //,AlARM_DIO_POWER_HIGH
      //,AlARM_DIO_MAIN_REGULATOR
        ,AlARM_DIO_MC1
        ,AlARM_DIO_MC2
      	//
      //,AlARM_CH1_MOTION_Y_DISCONNECTED
        ,AlARM_CH1_MOTION_Y_SIG_ALARM_ON
      //,AlARM_CH1_MOTION_Y_INVALID_UNITPULSE
      //,AlARM_CH1_MOTION_Y_NEED_HOME_SEARCH
      //,AlARM_CH1_MOTION_Y_MODEL_POS_NG
      //,AlARM_CH1_MOTION_Z_DISCONNECTED
        ,AlARM_CH1_MOTION_Z_SIG_ALARM_ON
      //,AlARM_CH1_MOTION_Z_INVALID_UNITPULSE
      //,AlARM_CH1_MOTION_Z_NEED_HOME_SEARCH
      //,AlARM_CH1_MOTION_Z_MODEL_POS_NG
      //,AlARM_CH2_MOTION_Y_DISCONNECTED
        ,AlARM_CH2_MOTION_Y_SIG_ALARM_ON
      //,AlARM_CH2_MOTION_Y_INVALID_UNITPULSE
      //,AlARM_CH2_MOTION_Y_NEED_HOME_SEARCH
      //,AlARM_CH2_MOTION_Y_MODEL_POS_NG
      //,AlARM_CH2_MOTION_Z_DISCONNECTED
        ,AlARM_CH2_MOTION_Z_SIG_ALARM_ON
      //,AlARM_CH2_MOTION_Z_INVALID_UNITPULSE
      //,AlARM_CH2_MOTION_Z_NEED_HOME_SEARCH
      //,AlARM_CH2_MOTION_Z_MODEL_POS_NG
      {$ELSEIF Defined(POCB_A2CHv2)}  //#####################################
      //,AlARM_DIO_NOT_CONNECTED
         AlARM_DIO_EMO
      //,AlARM_DIO_LEFT_SWITCH
      //,AlARM_DIO_RIGHT_SWITCH
      //,AlARM_DIO_STAGE1_LIGHT_CURTAIN
      //,AlARM_DIO_STAGE2_LIGHT_CURTAIN
      //,AlARM_DIO_DOOR_LEFT
      //,AlARM_DIO_DOOR_RIGHT
      //,AlARM_DIO_DOOR_UNDER_LEFT1
      //,AlARM_DIO_DOOR_UNDER_LEFT2
      //,AlARM_DIO_DOOR_UNDER_RIGHT1
      //,AlARM_DIO_DOOR_UNDER_RIGHT2
      //,AlARM_DIO_LEFT_FAN_IN
      //,AlARM_DIO_RIGHT_FAN_IN
      //,AlARM_DIO_LEFT_FAN_OUT
      //,AlARM_DIO_RIGHT_FAN_OUT
      //,AlARM_DIO_TEMPERATURE
      //,AlARM_DIO_POWER_HIGH
      //,AlARM_DIO_CYLINDER_REGULATOR
      //,AlARM_DIO_VACUUM_REGULATOR
        ,AlARM_DIO_MC1
        ,AlARM_DIO_MC2
      	//
      //,AlARM_CH1_MOTION_Y_DISCONNECTED
        ,AlARM_CH1_MOTION_Y_SIG_ALARM_ON
      //,AlARM_CH1_MOTION_Y_INVALID_UNITPULSE
      //,AlARM_CH1_MOTION_Y_NEED_HOME_SEARCH
      //,AlARM_CH1_MOTION_Y_MODEL_POS_NG
      //,AlARM_CH1_MOTION_Z_DISCONNECTED
        ,AlARM_CH1_MOTION_Z_SIG_ALARM_ON
      //,AlARM_CH1_MOTION_Z_INVALID_UNITPULSE
      //,AlARM_CH1_MOTION_Z_NEED_HOME_SEARCH
      //,AlARM_CH1_MOTION_Z_MODEL_POS_NG
      //,AlARM_CH2_MOTION_Y_DISCONNECTED
        ,AlARM_CH2_MOTION_Y_SIG_ALARM_ON
      //,AlARM_CH2_MOTION_Y_INVALID_UNITPULSE
      //,AlARM_CH2_MOTION_Y_NEED_HOME_SEARCH
      //,AlARM_CH2_MOTION_Y_MODEL_POS_NG
      //,AlARM_CH2_MOTION_Z_DISCONNECTED
        ,AlARM_CH2_MOTION_Z_SIG_ALARM_ON
      //,AlARM_CH2_MOTION_Z_INVALID_UNITPULSE
      //,AlARM_CH2_MOTION_Z_NEED_HOME_SEARCH
      //,AlARM_CH2_MOTION_Z_MODEL_POS_NG
      //,AlARM_CH1_MOTION_T_DISCONNECTED
        ,AlARM_CH1_MOTION_T_SIG_ALARM_ON
      //,AlARM_CH1_MOTION_T_INVALID_UNITPULSE
      //,AlARM_CH1_MOTION_T_NEED_HOME_SEARCH
      //,AlARM_CH1_MOTION_T_MODEL_POS_NG
      //,AlARM_CH2_MOTION_T_DISCONNECTED
        ,AlARM_CH2_MOTION_T_SIG_ALARM_ON
      //,AlARM_CH2_MOTION_T_INVALID_UNITPULSE
      //,AlARM_CH2_MOTION_T_NEED_HOME_SEARCH
      //,AlARM_CH2_MOTION_T_MODEL_POS_NG
      {$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}  //####################
      //,AlARM_DIO_NOT_CONNECTED
         AlARM_DIO_EMO1_FRONT
        ,AlARM_DIO_EMO2_RIGHT
        ,AlARM_DIO_EMO3_INNER_RIGHT
        ,AlARM_DIO_EMO4_INNER_LEFT
        ,AlARM_DIO_EMO5_LEFT
        {$IFDEF HAS_DIO_IN_DOOR_LOCK}
      //,ALARM_DIO_STAGE1_DOOR1_LOCK
      //,ALARM_DIO_STAGE1_DOOR2LOCK
      //,ALARM_DIO_STAGE2DOOR1_LOCK
      //,ALARM_DIO_STAGE2DOOR2LOCK
        {$ENDIF}
      //,AlARM_DIO_LEFT_FAN_IN
      //,AlARM_DIO_RIGHT_FAN_IN
      //,AlARM_DIO_LEFT_FAN_OUT
      //,AlARM_DIO_RIGHT_FAN_OUT
      //,AlARM_DIO_STAGE1_LIGHT_CURTAIN
      //,AlARM_DIO_STAGE2_LIGHT_CURTAIN
      //,AlARM_DIO_STAGE1_NOT_AUTOMODE
      //,AlARM_DIO_STAGE2_NOT_AUTOMODE
      //,AlARM_DIO_STAGE1_DOOR1
      //,AlARM_DIO_STAGE1_DOOR2
      //,AlARM_DIO_STAGE2_DOOR1
      //,AlARM_DIO_STAGE2_DOOR2
      //,AlARM_DIO_CYLINDER_REGULATOR
      //,AlARM_DIO_VACUUM_REGULATOR
      //,AlARM_DIO_TEMPERATURE
      //,AlARM_DIO_POWER_HIGH
        ,AlARM_DIO_MC1
        ,AlARM_DIO_MC2
        {$IFDEF HAS_DIO_Y_AXIS_MC}
        ,ALARM_DIO_Y_AXIS_MC_CH1
        ,ALARM_DIO_Y_AXIS_MC_CH2
        {$ENDIF}
      	{$IFDEF HAS_DIO_FAN_INOUT_PC} //2022-07-15 A2CHv4_#3(FanInOutPC)
      //,AlARM_DIO_MAINPC_FAN_IN
      //,AlARM_DIO_MAINPC_FAN_OUT
      //,AlARM_DIO_CAMPC_FAN_IN
      //,AlARM_DIO_CAMPC_FAN_OUT
      	{$ENDIF}
        {$IFDEF SUPPORT_1CG2PANEL} //A2CHv3
      //,AlARM_DIO_LOADZONE_PARTITION_NOT_DETECTED
      //,AlARM_DIO_SHUTTER_GUIDE_NOT_UP
      //,AlARM_DIO_CAMZONE_PARTITION_NOT_DOWN
      //,AlARM_DIO_CAMZONE_INNER_DOOR_NOT_CLOSE
      //,AlARM_DIO_ASSY_JIG_DETECTED
      //,AlARM_DIO_SHUTTER_GUIDE_NOT_DOWN
      //,AlARM_DIO_CAMZONE_PARTITION_NOT_UP
      //,AlARM_DIO_CAMZONE_INNER_DOOR_NOT_OPEN
      //,AlARM_DIO_LOADZONE_PARTITION_DETECTED
      //,AlARM_DIO_ASSY_JIG_STAGE_NOT_ALIGNED
        {$ENDIF}
      	//
      //,AlARM_CH1_MOTION_Y_DISCONNECTED
        ,AlARM_CH1_MOTION_Y_SIG_ALARM_ON
      //,AlARM_CH1_MOTION_Y_INVALID_UNITPULSE
      //,AlARM_CH1_MOTION_Y_NEED_HOME_SEARCH
      //,AlARM_CH1_MOTION_Y_MODEL_POS_NG
      //,AlARM_CH2_MOTION_Y_DISCONNECTED
        ,AlARM_CH2_MOTION_Y_SIG_ALARM_ON
      //,AlARM_CH2_MOTION_Y_INVALID_UNITPULSE
      //,AlARM_CH2_MOTION_Y_NEED_HOME_SEARCH
      //,AlARM_CH2_MOTION_Y_MODEL_POS_NG
      	//
      //,AlARM_CH1_ROBOT_MODBUS_DISCONNECTED
      //,AlARM_CH1_ROBOT_COMMAND_DISCONNECTED
      //,AlARM_CH1_ROBOT_FATAL_ERROR
      //,AlARM_CH1_ROBOT_PROJECT_NOT_RUNNING
      //,AlARM_CH1_ROBOT_PROJECT_EDITING
      //,AlARM_CH1_ROBOT_PROJECT_PAUSE
      //,AlARM_CH1_ROBOT_GET_CONTROL
      //,AlARM_CH1_ROBOT_ESTOP
      //,AlARM_CH1_ROBOT_CURR_COORD_NG
      //,AlARM_CH1_ROBOT_NOT_AUTOMODE
      //,AlARM_CH1_ROBOT_CANNOT_MOVE
      //,AlARM_CH1_ROBOT_HOME_COORD_MISMATCH
      //,AlARM_CH1_ROBOT_MODEL_COORD_MISMATCH
      //,AlARM_CH1_ROBOT_STANDBY_COORD_MISMATCH
      //,AlARM_CH2_ROBOT_MODBUS_DISCONNECTED
      //,AlARM_CH2_ROBOT_COMMAND_DISCONNECTED
      //,AlARM_CH2_ROBOT_FATAL_ERROR
      //,AlARM_CH2_ROBOT_PROJECT_NOT_RUNNING
      //,AlARM_CH2_ROBOT_PROJECT_EDITING
      //,AlARM_CH2_ROBOT_PROJECT_PAUSE
      //,AlARM_CH2_ROBOT_GET_CONTROL
      //,AlARM_CH2_ROBOT_ESTOP
      //,AlARM_CH2_ROBOT_CURR_COORD_NG
      //,AlARM_CH2_ROBOT_NOT_AUTOMODE
      //,AlARM_CH2_ROBOT_CANNOT_MOVE
      //,AlARM_CH2_ROBOT_HOME_COORD_MISMATCH
      //,AlARM_CH2_ROBOT_MODEL_COORD_MISMATCH
      //,AlARM_CH2_ROBOT_STANDBY_COORD_MISMATCH
      {$ENDIF}
    ] then
      Result := False;
  end;

begin
  if m_bExitOrInit then Exit;  //2019-01-16
  if (Common = nil) then Exit; //2019-01-16
  //
  if (Common.AlarmList[nAlarmNo].bIsOn = bIsOn) then begin  //2020-11-04
    Exit; //Already!!!
  end;
  //
  sDebug := '<ALARM> AlarmNo(' + IntToStr(nAlarmNo) + ':' + Common.AlarmList[nAlarmNo].AlarmName+')';
  if bIsOn then sDebug := sDebug + ' ON'
  else          sDebug := sDebug + ' OFF';
  Common.MLog(DefPocb.SYS_LOG,sDebug);

  //
  if Common.AlarmList[nAlarmNo].sDioIN <> '-1' then sDioNo := Common.AlarmList[nAlarmNo].sDioIN else sDioNo := '-';
  sErrLogHeader := 'DateTime,AlarmNo,AlarmName,DIO#,ON/OFF'; //2022-12-06 ERROR_LOG
  sErrLogData   := FormatDateTime('yyyy-mm-dd hh:mm:ss.zzz',Now) + ','
                   + IntToStr(nAlarmNo) + ','
                   + Common.AlarmList[nAlarmNo].AlarmName + ','
                   + StringReplace(sDioNo,',',':', [rfReplaceAll]) + ','
                   + TernaryOp(bIsOn, 'ON', 'OFF');
  Common.MakeErrorLog(sErrLogHeader,sErrLogData);

  //
  bHighPriorityAlarmOn := IsHighPriorityAlarmOn(nAlarmNo);  //Check Alarm Priotity  //2019-03-29
  bDioMotionAlarmOnOff := Common.SetAlarmOnOff(nAlarmNo,bIsOn);
	if bDioMotionAlarmOnOff {2019-04-17 and (not bHighPriorityAlarmOn)} then begin  //2019-04-05
      ShowAlarmMotionControl(nAlarmNo,bIsOn);
  end;

  //2019-03-29 (SafetyAlarmMsg if SAFETY Alarm ON)
  if bIsOn and (Common.AlarmList[nAlarmNo].AlarmClass = DefPocb.ALARM_CLASS_SAFETY) and (not bHighPriorityAlarmOn) then begin
    ShowSafetyAlarmMsg(nAlarmNo);  //After SetAlarmOnOff()!!!
  end
  else begin
    if (frmSafetyAlarmMsg[nAlarmNo] <> nil) and frmSafetyAlarmMsg[nAlarmNo].Visible and IsAutoCloseIfAlarmOff(nAlarmNo) then begin //2023-06-07 IsAutoCloseIfAlarmOff
      frmSafetyAlarmMsg[nAlarmNo].Close;
    end;
  end;

  //
  if Common.m_bAlarmOn then begin btnShowAlarm.Font.Color := clRed;   end
  else                      begin btnShowAlarm.Font.Color := clBlack; end;
  //
  //---------------------------- LAMP(Red/Green/Yellow) & BUZZER
  if DongaDio <> nil then begin //2018-12-15 LAMP
    if Common.m_bAlarmOn then begin  //Alarm-ON
      if Common.m_bSafetyAlarmOn and bIsOn{Off인 경우, Buzzer 재발생시키지 않음} then begin  //2019-04-17
        if Common.SystemInfo.UseBuzzer then begin  //2019-09-03
          DongaDio.SetBuzzer(True);
        end;
      end;
      if (DongaDio.m_nDOValue and DefDio.MASK_OUT_LAMP_RED) = 0 then DongaDio.SetDio(DefDio.OUT_LAMP_RED);
      if (DongaDio.m_nDOValue and DefDio.MASK_OUT_LAMP_YELLOW) <> 0 then DongaDio.SetDio(DefDio.OUT_LAMP_YELLOW);
      if (DongaDio.m_nDOValue and DefDio.MASK_OUT_LAMP_GREEN) <> 0 then DongaDio.SetDio(DefDio.OUT_LAMP_GREEN);
      //
      if Common.AlarmList[DefPocb.ALARM_DIO_MC1].bIsOn or Common.AlarmList[DefPocb.ALARM_DIO_MC2].bIsOn
//{$IFDEF HAS_DIO_Y_AXIS_MC} //2023-12-07
//       or (Common.AlarmList[DefPocb.ALARM_DIO_Y_AXIS_MC_CH1].bIsOn and Common.AlarmList[DefPocb.ALARM_DIO_Y_AXIS_MC_CH2].bIsOn)
//{$ENDIF}
{$IF Defined(A2CH) or Defined(A2CHv2)}
         or Common.AlarmList[DefPocb.ALARM_DIO_EMO].bIsOn
{$ELSE}
         or Common.AlarmList[DefPocb.ALARM_DIO_EMO1_FRONT].bIsOn
         or Common.AlarmList[DefPocb.ALARM_DIO_EMO2_RIGHT].bIsOn
         or Common.AlarmList[DefPocb.ALARM_DIO_EMO3_INNER_RIGHT].bIsOn
         or Common.AlarmList[DefPocb.ALARM_DIO_EMO4_INNER_LEFT].bIsOn
         or Common.AlarmList[DefPocb.ALARM_DIO_EMO5_LEFT].bIsOn
{$ENDIF}
         or Common.AlarmList[DefPocb.ALARM_DIO_EXTRA_EMS].bIsOn
      then tmrTowerLampRedOnOff.Enabled := False
      else tmrTowerLampRedOnOff.Enabled := True;
    end
    else begin  //Alarm-OFF
      tmrTowerLampRedOnOff.Enabled := False;
      DongaDio.SetBuzzer(False);
      if (DongaDio.m_nDOValue and DefDio.MASK_OUT_LAMP_RED) <> 0 then DongaDio.SetDio(DefDio.OUT_LAMP_RED);
      if (DongaDio.m_nDOValue and DefDio.MASK_OUT_LAMP_YELLOW) <> 0 then DongaDio.SetDio(DefDio.OUT_LAMP_YELLOW);
      if (DongaDio.m_nDOValue and DefDio.MASK_OUT_LAMP_GREEN) = 0 then DongaDio.SetDio(DefDio.OUT_LAMP_GREEN);
    end;
  end;

  //-------------------------------
{$IFDEF SITE_LENSVN}
  if (DongaGmes <> nil) and Common.m_bMesOnline then begin
    if (Common.AlarmList[nAlarmNo].AlarmClass = DefPocb.ALARM_CLASS_SAFETY) and (not bHighPriorityAlarmOn) then begin
      if (nAlarmNo in [ ALARM_DIO_NOT_CONNECTED
                       ,ALARM_DIO_EMO1_FRONT, ALARM_DIO_EMO2_RIGHT, ALARM_DIO_EMO3_INNER_RIGHT, ALARM_DIO_EMO4_INNER_LEFT, ALARM_DIO_EMO5_LEFT ]) then begin
        if bIsOn then DongaGmes.SendHostStatus(DefPocb.CH_1{dummy}, LENS_MES_STATUS_WARN{nEqStValue}, True{bForce}); //2023-08-21 LENS:MES:EQSTATUS:Warn(On):DIO|EMO
      end
      else if (nAlarmNo in [ ALARM_DIO_TEMPERATURE, ALARM_DIO_POWER_HIGH ]) then begin
        DongaGmes.SendHostStatus(DefPocb.CH_1{dummy}, LENS_MES_STATUS_WARN{nEqStValue}, True{bForce}); //2023-08-21 LENS:MES:EQSTATUS:Warn(On|Off):PowerHigh|TempHigh
      end
      else if (nAlarmNo in [
                //,ALARM_DIO_LEFT_FAN_IN, ALARM_DIO_RIGHT_FAN_IN, ALARM_DIO_LEFT_FAN_OUT, ALARM_DIO_RIGHT_FAN_OUT
                //,ALARM_DIO_STAGE1_LIGHT_CURTAIN, ALARM_DIO_STAGE2_LIGHT_CURTAIN
                // ALARM_DIO_STAGE1_NOT_AUTOMODE
                //,ALARM_DIO_STAGE2_NOT_AUTOMODE
                   ALARM_DIO_STAGE1_DOOR1_OPEN
                  ,ALARM_DIO_STAGE1_DOOR2_OPEN
                  ,ALARM_DIO_STAGE2_DOOR1_OPEN
                  ,ALARM_DIO_STAGE2_DOOR2_OPEN
                //,ALARM_DIO_CYLINDER_REGULATOR
                //,ALARM_DIO_VACUUM_REGULATOR
                //,ALARM_DIO_TEMPERATURE
                //,ALARM_DIO_POWER_HIGH
                //,ALARM_DIO_MC1, AlARM_DIO_MC2
                	{$IFDEF HAS_DIO_FAN_INOUT_PC}
                //,ALARM_DIO_MAINPC_FAN_IN, ALARM_DIO_MAINPC_FAN_OUT, ALARM_DIO_CAMPC_FAN_IN, ALARM_DIO_CAMPC_FAN_OUT
                	{$ENDIF}
              ]) then begin
        DongaGmes.SendHostStatus(DefPocb.CH_1{dummy}, LENS_MES_STATUS_WARN{nEqStValue}, TernaryOp(bIsOn,False,True){bForce}); //2023-08-21 LENS:MES:EQSTATUS:Warn(On|Off):Etc
      end;
    end;
  end;
{$ENDIF}
end;

function TfrmMain.IsHighPriorityAlarmOn(nAlarmNo : Integer): Boolean;
var
  bHighPriorityAlarmOn : Boolean;
begin
  bHighPriorityAlarmOn := False;
  case nAlarmNo of
  //ALARM_DIO_NOT_CONNECTED:
    //TBD:A2CHv3:DIO?
    //
  //ALARM_CH1_MOTION_Y_DISCONNECTED:
    ALARM_CH1_MOTION_Y_SIG_ALARM_ON: begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         {$IFDEF HAS_DIO_Y_AXIS_MC}
         Common.AlarmList[ALARM_DIO_Y_AXIS_MC_CH1].bIsOn or
         {$ENDIF}
         Common.AlarmList[ALARM_CH1_MOTION_Y_DISCONNECTED].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
  //ALARM_CH1_MOTION_Y_SIG_SERVO_OFF: //--
    ALARM_CH1_MOTION_Y_INVALID_UNITPULSE: begin
      if Common.AlarmList[ALARM_CH1_MOTION_Y_DISCONNECTED].bIsOn then bHighPriorityAlarmOn := True;
    end;
    ALARM_CH1_MOTION_Y_NEED_HOME_SEARCH: begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         {$IFDEF HAS_DIO_Y_AXIS_MC}
         Common.AlarmList[ALARM_DIO_Y_AXIS_MC_CH1].bIsOn or
         {$ENDIF}
         Common.AlarmList[ALARM_CH1_MOTION_Y_DISCONNECTED].bIsOn or
         Common.AlarmList[ALARM_CH1_MOTION_Y_SIG_ALARM_ON].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
    ALARM_CH1_MOTION_Y_MODEL_POS_NG: begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         {$IFDEF HAS_DIO_Y_AXIS_MC}
         Common.AlarmList[ALARM_DIO_Y_AXIS_MC_CH1].bIsOn or
         {$ENDIF}
         Common.AlarmList[ALARM_CH1_MOTION_Y_DISCONNECTED].bIsOn or
         Common.AlarmList[ALARM_CH1_MOTION_Y_SIG_ALARM_ON].bIsOn or
         Common.AlarmList[ALARM_CH1_MOTION_Y_INVALID_UNITPULSE].bIsOn or
         Common.AlarmList[ALARM_CH1_MOTION_Y_NEED_HOME_SEARCH].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
    //
  //ALARM_CH2_MOTION_Y_DISCONNECTED:
    ALARM_CH2_MOTION_Y_SIG_ALARM_ON: begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         {$IFDEF HAS_DIO_Y_AXIS_MC}
         Common.AlarmList[ALARM_DIO_Y_AXIS_MC_CH2].bIsOn or
         {$ENDIF}
         Common.AlarmList[ALARM_CH2_MOTION_Y_DISCONNECTED].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
  //ALARM_CH2_MOTION_Y_SIG_SERVO_OFF:             //--
    ALARM_CH2_MOTION_Y_INVALID_UNITPULSE: begin
      if Common.AlarmList[ALARM_CH2_MOTION_Y_DISCONNECTED].bIsOn then bHighPriorityAlarmOn := True;
    end;
    ALARM_CH2_MOTION_Y_NEED_HOME_SEARCH: begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         {$IFDEF HAS_DIO_Y_AXIS_MC}
         Common.AlarmList[ALARM_DIO_Y_AXIS_MC_CH2].bIsOn or
         {$ENDIF}
         Common.AlarmList[ALARM_CH2_MOTION_Y_DISCONNECTED].bIsOn or
         Common.AlarmList[ALARM_CH2_MOTION_Y_SIG_ALARM_ON].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
    ALARM_CH2_MOTION_Y_MODEL_POS_NG: begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         {$IFDEF HAS_DIO_Y_AXIS_MC}
         Common.AlarmList[ALARM_DIO_Y_AXIS_MC_CH2].bIsOn or
         {$ENDIF}
         Common.AlarmList[ALARM_CH2_MOTION_Y_DISCONNECTED].bIsOn or
         Common.AlarmList[ALARM_CH2_MOTION_Y_SIG_ALARM_ON].bIsOn or
         Common.AlarmList[ALARM_CH2_MOTION_Y_INVALID_UNITPULSE].bIsOn or
         Common.AlarmList[ALARM_CH2_MOTION_Y_NEED_HOME_SEARCH].bIsOn then
        bHighPriorityAlarmOn := True;
    end;

{$IFDEF HAS_MOTION_CAM_Z}
  //ALARM_CH1_MOTION_Z_DISCONNECTED:
    ALARM_CH1_MOTION_Z_SIG_ALARM_ON: begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         Common.AlarmList[ALARM_CH1_MOTION_Z_DISCONNECTED].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
  //ALARM_CH1_MOTION_Z_SIG_SERVO_OFF: //--
    ALARM_CH1_MOTION_Z_INVALID_UNITPULSE: begin
      if Common.AlarmList[ALARM_CH1_MOTION_Z_DISCONNECTED].bIsOn then bHighPriorityAlarmOn := True;
    end;
    ALARM_CH1_MOTION_Z_NEED_HOME_SEARCH: begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         Common.AlarmList[ALARM_CH1_MOTION_Z_DISCONNECTED].bIsOn or
         Common.AlarmList[ALARM_CH1_MOTION_Z_SIG_ALARM_ON].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
    ALARM_CH1_MOTION_Z_MODEL_POS_NG: begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         Common.AlarmList[ALARM_CH1_MOTION_Z_DISCONNECTED].bIsOn or
         Common.AlarmList[ALARM_CH1_MOTION_Z_SIG_ALARM_ON].bIsOn or
         Common.AlarmList[ALARM_CH1_MOTION_Z_INVALID_UNITPULSE].bIsOn or
         Common.AlarmList[ALARM_CH1_MOTION_Z_NEED_HOME_SEARCH].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
		//
  //ALARM_CH2_MOTION_Z_DISCONNECTED:
    ALARM_CH2_MOTION_Z_SIG_ALARM_ON: begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         Common.AlarmList[ALARM_CH2_MOTION_Z_DISCONNECTED].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
  //ALARM_CH2_MOTION_Z_SIG_SERVO_OFF:			        //--
    ALARM_CH2_MOTION_Z_INVALID_UNITPULSE: begin
    end;
    ALARM_CH2_MOTION_Z_NEED_HOME_SEARCH:  begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         Common.AlarmList[ALARM_CH2_MOTION_Z_DISCONNECTED].bIsOn or
         Common.AlarmList[ALARM_CH2_MOTION_Z_SIG_ALARM_ON].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
    ALARM_CH2_MOTION_Z_MODEL_POS_NG: begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn or
         Common.AlarmList[ALARM_CH2_MOTION_Z_DISCONNECTED].bIsOn or
         Common.AlarmList[ALARM_CH2_MOTION_Z_SIG_ALARM_ON].bIsOn or
         Common.AlarmList[ALARM_CH2_MOTION_Z_INVALID_UNITPULSE].bIsOn or
         Common.AlarmList[ALARM_CH2_MOTION_Z_NEED_HOME_SEARCH].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
{$ENDIF} //HAS_MOTION_CAM_Z

{$IFDEF HAS_ROBOT_CAM_Z}
  //ALARM_CH1_ROBOT_MODBUS_DISCONNECTED:
  //ALARM_CH1_ROBOT_COMMAND_DISCONNECTED:
    ALARM_CH1_ROBOT_FATAL_ERROR,
    ALARM_CH1_ROBOT_PROJECT_NOT_RUNNING,
    ALARM_CH1_ROBOT_PROJECT_EDITING,
    ALARM_CH1_ROBOT_PROJECT_PAUSE,
    ALARM_CH1_ROBOT_GET_CONTROL,
    ALARM_CH1_ROBOT_ESTOP,
    ALARM_CH1_ROBOT_CURR_COORD_NG,
    ALARM_CH1_ROBOT_NOT_AUTOMODE,
    ALARM_CH1_ROBOT_CANNOT_MOVE,
    ALARM_CH1_ROBOT_HOME_COORD_MISMATCH,
    ALARM_CH1_ROBOT_MODEL_COORD_MISMATCH,
    ALARM_CH1_ROBOT_STANDBY_COORD_MISMATCH : begin
      if Common.AlarmList[ALARM_CH1_ROBOT_MODBUS_DISCONNECTED].bIsOn then bHighPriorityAlarmOn := True;  //TBD:A2CHv3:ROBOT?
    end;
  //ALARM_CH2_ROBOT_MODBUS_DISCONNECTED:
  //ALARM_CH2_ROBOT_COMMAND_DISCONNECTED:
    ALARM_CH2_ROBOT_FATAL_ERROR,
    ALARM_CH2_ROBOT_PROJECT_NOT_RUNNING,
    ALARM_CH2_ROBOT_PROJECT_EDITING,
    ALARM_CH2_ROBOT_PROJECT_PAUSE,
    ALARM_CH2_ROBOT_GET_CONTROL,
    ALARM_CH2_ROBOT_ESTOP,
    ALARM_CH2_ROBOT_CURR_COORD_NG,
    ALARM_CH2_ROBOT_NOT_AUTOMODE,
    ALARM_CH2_ROBOT_CANNOT_MOVE,
    ALARM_CH2_ROBOT_HOME_COORD_MISMATCH,
    ALARM_CH2_ROBOT_MODEL_COORD_MISMATCH,
    ALARM_CH2_ROBOT_STANDBY_COORD_MISMATCH : begin
      if Common.AlarmList[ALARM_CH2_ROBOT_MODBUS_DISCONNECTED].bIsOn then bHighPriorityAlarmOn := True; //TBD:A2CHv3:ROBOT?
    end;
{$ENDIF} //HAS_ROBOT_CAM_Z

{$IFDEF HAS_DIO_Y_AXIS_MC}
    ALARM_DIO_Y_AXIS_MC_CH1,
    ALARM_DIO_Y_AXIS_MC_CH2 : begin
      if Common.AlarmList[ALARM_DIO_MC1].bIsOn or Common.AlarmList[ALARM_DIO_MC2].bIsOn then
        bHighPriorityAlarmOn := True;
    end;
{$ENDIF}

    else begin
      if nAlarmNo in [DefPocb.ALARM_DIO_FIRST..DefPocb.ALARM_DIO_LAST] then begin
        if Common.AlarmList[ALARM_DIO_NOT_CONNECTED].bIsOn then bHighPriorityAlarmOn := True;
      end;
    end;
  end;
  Result := bHighPriorityAlarmOn;
end;

//******************************************************************************
// procedure/function: GMES
//******************************************************************************

procedure TfrmMain.InitGmes;
var
  sService, sNetWork, sDaemon : string;
  sLocal, sRemote, sHostPath  : string;
  bRtn, bEasRtn               : Boolean;
begin
  DongaGmes := TGmes.Create(Self, Self.Handle);
  DongaGmes.OnGmsEvent := OnMesMsg;

{$IFDEF POCB_A2CH}
  ShowModelButtons(True); //TBD?
{$ENDIF}

  DongaGmes.MesSystemNo := Common.SystemInfo.EQPId;
  DongaGmes.MesUserId   := Common.m_sUserId;
{$IFDEF SITE_LENSVN}
  DongaGmes.MesUserPwd  := Common.m_sUserPwd;
{$ENDIF}
  ZeroMemory(@Common.MesData,SizeOf(Common.MesData));
	//
{$IFDEF SITE_LENSVN}
  //NOP!!!
{$ELSE}
  sService    := Common.SystemInfo.MES_ServicePort;
  sNetWork    := Common.SystemInfo.MES_Network;
  sDaemon     := Common.SystemInfo.MES_DaemonPort;
  sLocal      := Common.SystemInfo.MES_LocalSubject;
  sRemote     := Common.SystemInfo.MES_RemoteSubject;
  sHostPath   := Common.Path.GMES;
	//
  bRtn := DongaGmes.HOST_Initial(sService,sNetWork,sDaemon,sLocal,sRemote,sHostPath);
  if bRtn then begin
    pnlSysInfoGmes.Caption := 'TIB-Conn'; //2019-07-16 (Connected -> TIB Connected)
  	{$IFDEF REMOTE_UPDATE}
    if UsObject <> nil then begin
      {$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
      UsObject.SetModelInfoForGMES(Common.Path.MODEL + Common.SystemInfo.TestModel[DefPocb.CH_1] + '.mcf');
      {$ELSE}
      UsObject.SetModelInfoForGMES(Common.Path.MODEL + Common.SystemInfo.TestModel + '.mcf');
      {$ENDIF}
      DongaGmes.RcpInfo  := UsObject.GetRcpFileInfoMobile;
      {$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
      UsObject.SetModelInfoForGMES(Common.Path.MODEL + Common.SystemInfo.TestModel[DefPocb.CH_2] + '.mcf');
      {$ELSE}
      UsObject.SetModelInfoForGMES(Common.Path.MODEL + Common.SystemInfo.TestModel + '.mcf');
      {$ENDIF}
      DongaGmes.RcpInfo2 := UsObject.GetRcpFileInfoMobile;
    end;
  	{$ENDIF}
  end
  else begin
    pnlSysInfoGmes.Caption := 'Disconn';
  end;
{$ENDIF}

{$IFDEF USE_EAS}
  if not Common.SystemInfo.EAS_UseAPDR then begin
    pnlSysInfoEAS.Caption    := 'NONE';
    pnlSysInfoEAS.Color      := clGray;
    pnlSysInfoEAS.Font.Color := clBlack;
    Exit;
  end;
  sService    := Common.SystemInfo.EAS_ServicePort;
  sNetWork    := Common.SystemInfo.EAS_Network;
  sDaemon     := Common.SystemInfo.EAS_DaemonPort;
  if Common.SystemInfo.EAS_LocalSubject = '' then Common.SystemInfo.EAS_LocalSubject := Common.SystemInfo.MES_LocalSubject;  //2019-11-08
  sLocal      := Common.SystemInfo.EAS_LocalSubject;  //2019-11-08
  sRemote     := Common.SystemInfo.EAS_RemoteSubject;
  sHostPath   := Common.Path.EAS;
  {$IFDEF SIMULATOR}
  if ((Trim(sService) = '') {or (Trim(sNetWork) = '')} or (Trim(sDaemon) = '') or (sRemote = '')) then begin
  {$ELSE}
  if ((Trim(sService) = '') or (Trim(sNetWork) = '') or (Trim(sDaemon) = '') or (sRemote = '')) then begin
  {$ENDIF}
    bEasRtn := False;
    ledSysInfoEAS.Value      := bEasRtn;
    pnlSysInfoEAS.Caption    := 'CheckConf';   //2019-07-16 (Connected -> TIB Connected)
    pnlSysInfoEAS.Color      := clRed;
    pnlSysInfoEAS.Font.Color := clYellow;
  end
  else begin
    bEasRtn := DongaGmes.Eas_Initial(sService, sNetWork, sDaemon,sLocal,sRemote ,sHostPath);
    ledSysInfoEAS.Value := bEasRtn;
    if bEasRtn then begin
      pnlSysInfoEAS.Caption    := 'TIB-Conn';  //2019-07-16 (Connected -> TIB Connected)
      pnlSysInfoEAS.Color      := clLime;
      pnlSysInfoEAS.Font.Color := clBlack;
    end
    else begin
      pnlSysInfoEAS.Caption    := 'Disconn';
      pnlSysInfoEAS.Color      := clRed;
      pnlSysInfoEAS.Font.Color := clYellow;
    end;
  end;
{$ENDIF}
end;

procedure TfrmMain.ShowModelButtons(bEnable: Boolean);
begin
  btnModelChange.Enabled := bEnable;
  btnModel.Enabled  := bEnable;
end;

{$IFDEF SITE_LENSVN}
procedure TfrmMain.OnMesMsg(nMsgType, nCh: Integer; bError: Boolean; sMsg: string);
var
  i  : Integer;
  sDebug : string;
begin
//if (Common.SystemInfo.UseEQCC) then begin
//  tmrEQCC.Enabled := True;
//end;
  //
  case nMsgType of
    DefGmes.MES_UCHK  : begin
      if not bError then begin
        Common.m_bMesOnline   := True;
        //
        DongaGmes.MesUserName := DongaGmes.MesUserId; //!!! (for LENSVN MES)
        UpdateMainFrmMesStatus(MesStatus_ONLINE); //2023-09-20
      end
      else begin
        ShowNgMessage('MES LOGIN NG' + #$0D#$0A + sMsg, True{bForce});
        //
        Common.m_bMesOnline := False;
      //Common.m_sUserId    := 'PM';
        //
        DongaGmes.MesUserId  := Common.m_sUserId;
        DongaGmes.MesUserPwd := '';
        UpdateMainFrmMesStatus(MesStatus_OFFLINE, True{bMesLoginFailed}); //2023-09-20
      end;
    end;
    DefGmes.MES_EQCC  : begin
      //TBD:LENS:MES:EQST? 2023-08-XX
    end;
  end;
end;
{$ELSE}
procedure TfrmMain.OnMesMsg(nMsgType, nCh: Integer; bError: Boolean; sMsg: string);
var
  sHostMsg : string;
  i        : Integer;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<FrmMain> OnMesMsg',DefPocb.DEBUG_LEVEL_INFO);
  sHostMsg := StringReplace(sMsg, '[', '', [rfReplaceAll]);
  sHostMsg := StringReplace(sHostMsg, '[', '', [rfReplaceAll]);
  //
  if (Common.SystemInfo.UseEQCC) then begin
    tmrEQCC.Enabled := True;
  end;
  //
  case nMsgType of
    DefGmes.MES_EAYT  : begin
      if bError then begin
        ShowNgMessage(sHostMsg);
      end;
    end;
    DefGmes.MES_UCHK  : begin
      DongaGmes.MesUserName  := StringReplace(DongaGmes.MesUserName, '[', '', [rfReplaceAll]);
      DongaGmes.MesUserName  := StringReplace(DongaGmes.MesUserName, ']', '', [rfReplaceAll]);
      if not bError then begin
        Common.m_bMesOnline := True;
        //
        UpdateMainFrmMesStatus(MesStatus_ONLINE); //2023-09-20
      end
      else begin
        ShowNgMessage(sHostMsg);
      end;
    end;
    DefGmes.MES_EDTI  : begin
      ShowModelButtons(True);
      if bError then begin
        ShowNgMessage(sHostMsg);
      end;
    end;
    DefGmes.MES_FLDR  : begin
      if bError then begin
        ShowNgMessage(sHostMsg);
      end;
    end;
  {$IFDEF USE_MES_APDR}
    DefGmes.MES_APDR  : begin
      if bError then begin
        ShowMessage(sHostMsg);
      end;
    end;
  {$ENDIF}
    DefGmes.MES_EQCC  : begin
      if bError then begin
        ShowNgMessage(sHostMsg);
      end;
    end;
  end;
end;
{$ENDIF}

procedure TfrmMain.pnlAssyPocbInfoDblClick(Sender: TObject);
begin
{$IFNDEF SIMULATOR_DIO}
  Exit;
{$ENDIF}
  if (DiTestForm = nil) then
    DiTestForm := TTDiTestForm.Create(nil);

  if not DiTestForm.Visible then DiTestForm.Show;
end;

{$IFDEF DFS_HEX}
//******************************************************************************
// procedure/function: DFS_FTP
//******************************************************************************
procedure TfrmMain.InitDfs;  //A2CHv3:MULTIPLE_MODEL
var
  sIp, sUsrName, sPw : string;
  nCh : Integer;
begin
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin  //A2CHv3:MULTIPLE_MODEL
    Common.CombiCodeData.sRcpName[nCh]   := '';
    Common.CombiCodeData.sProcessNo[nCh] := '';
    Common.CombiCodeData.nRouterNo[nCh]  := 0;
    Common.CombiCodeData.nOrigin[nCh]    := 0;
  end;
  //
  DfsFtpConnOK := False; //2019-04-09
  if Common.DfsConfInfo.bUseDfs then begin
    if DfsFtpCommon <> nil then begin
      if DfsFtpCommon.IsConnected then DfsFtpCommon.Disconnect;
      DfsFtpCommon.Free;
      DfsFtpCommon := nil;
    end;
    for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      if DfsFtpCh[nCh] <> nil then begin
        DfsFtpCh[nCh].Free;
        DfsFtpCh[nCh] := nil;
      end;
    end;
    pnlSysinfoDfs.Caption    := 'Disconnected';
    pnlSysinfoDfs.Color      := clRed;
  //pnlSysinfoDfs.Font.Color := clYellow;
    ledSysInfoDfs.TrueColor  := clLime;
    ledSysInfoDfs.FalseColor := clRed;
    ledSysInfoDfs.Value      := False;
    //
    sIp       := Common.DfsConfInfo.sDfsServerIP;
    sUsrName  := Common.DfsConfInfo.sDfsUserName;
    sPw       := Common.DfsConfInfo.sDfsPassword;
    if Trim(sIp) = ''       then Exit;
    if Trim(sUsrName) = ''  then Exit;
    if Trim(sPw) = ''       then Exit;

    DfsFtpCommon := TDfsFtp.Create(sIp, sUsrName, sPw, -1{nCh:dummy for DfsFtpCommon});
    DfsFtpCommon.m_hMain := Self.Handle;
    DfsFtpCommon.Connect;
    for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      DfsFtpCh[nCh] := TDfsFtp.Create(sIp, sUsrName, sPw, nCh);
      DfsFtpCh[nCh].m_hMain := Self.Handle;
    end;
    //
    if Common.DfsConfInfo.bUseCombiDown and DfsFtpCommon.IsConnected then begin
      DfsFtpCommon.DownloadCombiFile;
    end;
    DfsFtpCommon.Disconnect;
  end
  else begin
    ledSysInfoDfs.FalseColor := clGray;
    ledSysInfoDfs.Value      := False;
    pnlSysinfoDfs.Caption    := 'NONE';
    pnlSysinfoDfs.Color      := clBtnFace;
    if DfsFtpCommon <> nil then begin
      if DfsFtpCommon.IsConnected then DfsFtpCommon.Disconnect;
      DfsFtpCommon.Free;
      DfsFtpCommon := nil;
    end;
    for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      if DfsFtpCh[nCh] <> nil then begin
        DfsFtpCh[nCh].Free;
        DfsFtpCh[nCh] := nil;
      end;
    end;
  end;
  //
  if Common.DfsConfInfo.bUseDfs then begin
    RzgrpDFS.visible := True;
    pnlCombiModelRCPCh1.Caption  := Common.CombiCodeData.sRcpName[DefPocb.CH_1];    //A2CHv3:MULTIPLE_MODEL
    pnlCombiProcessNoCh1.Caption := Common.CombiCodeData.sProcessNo[DefPocb.CH_1];
    pnlCombiRouterNoCh1.Caption  := IntToStr(Common.CombiCodeData.nRouterNo[DefPocb.CH_1]);
    pnlCombiModelRCPCh2.Caption  := Common.CombiCodeData.sRcpName[DefPocb.CH_2];    
    pnlCombiProcessNoCh2.Caption := Common.CombiCodeData.sProcessNo[DefPocb.CH_2];
    pnlCombiRouterNoCh2.Caption  := IntToStr(Common.CombiCodeData.nRouterNo[DefPocb.CH_2]);
  end
  else begin
    RzgrpDFS.visible := False;
  end;
end;

procedure TfrmMain.ShowDfsConnectSts(bIsConnect: Boolean);
begin
  if bIsConnect then begin
    DfsFtpConnOK := True;
    ledSysinfoDfs.Value       := True;
    pnlSysinfoDfs.Caption     := 'Connect';
    pnlSysinfoDfs.Color       := clLime;
    pnlSysinfoDfs.Font.Color  := clBlack;
  end
  else begin
    DfsFtpConnOK := False;
    ledSysinfoDfs.Value       := False;
    pnlSysinfoDfs.Caption     := 'Disconn';
    pnlSysinfoDfs.Color       := clRed;
    pnlSysinfoDfs.Font.Color  := clYellow;
  end;
end;
{$ENDIF}

//******************************************************************************
// procedure/function: GUI(Pop-up)
//******************************************************************************

procedure TfrmMain.ShowEMSAlarmMsg(sMessage: string);
begin
  //TBD? Common.ThreadTask( procedure begin
    if frmEMSAlarmMsg = nil then begin
      frmEMSAlarmMsg  := TfrmEMSAlarmMsg.Create(nil);
      try
      //frmEMSAlarmMsg.lblShowText1.Caption := sMessage;
      //2023-08-31 frmEMSAlarmMsg.ShowModal;
      finally
        frmEMSAlarmMsg.Free;
        frmEMSAlarmMsg := nil;
        //
      //btnExitClick(nil);  //2018-12-09 //2021-03-09
      end;
    end
    else begin
      //frmEMSAlarmMsg.lblShowText1.Caption := frmEMSAlarmMsg.lblShowText1.Caption + #13#10 + sMessage; //TBD?
    end;
  //TBD? end);
end;

procedure TfrmMain.ShowSafetyAlarmMsg(nAlarmNo: Integer); //2019-03-29
var
  sImageFullName, sAlarmOnTime : string;
begin
  if (nAlarmNo <= 0) or (nAlarmNo > DefPocb.MAX_ALARM_NO) then Exit;
  //
	sImageFullName := '';
  if Common.AlarmList[nAlarmNo].ImageFile <> '' then begin
    sImageFullName := Common.Path.Ini + 'SystemImage\' + Common.AlarmList[nAlarmNo].ImageFile + '.bmp';
    if not FileExists(sImageFullName) then sImageFullName := '';
  end;
  sAlarmOnTime := ' ' + FormatDateTime('YYYY-MM-DD hh:mm:ss.zzz',Common.AlarmList[nAlarmNo].AlarmOnTime);

  if (frmSafetyAlarmMsg[nAlarmNo] <> nil) and (frmSafetyAlarmMsg[nAlarmNo].Showing = True)
  then begin  //TBD?
    frmSafetyAlarmMsg[nAlarmNo].Close;
    frmSafetyAlarmMsg[nAlarmNo].Free;
    frmSafetyAlarmMsg[nAlarmNo] := nil;
  end;

  frmSafetyAlarmMsg[nAlarmNo] := TfrmSafetyAlarmMsg.Create(Self);
  frmSafetyAlarmMsg[nAlarmNo].SetAlarmInfo(Common.AlarmList[nAlarmNo], sImageFullName, sAlarmOnTime);
  frmSafetyAlarmMsg[nAlarmNo].Show;
	Sleep(10); //2019-04-02
end;

procedure TfrmMain.tmrPowerSavingTimer(Sender: TObject);
var
  bValue : Boolean;
  i : Integer;
begin
  for i := 0 to DefPocb.CH_MAX do begin
    if Logic[i] = nil then Exit;

    if Logic[i].m_InsStatus <> IsStop then begin
      keybd_event(VK_CONTROL,0,KEYEVENTF_KEYUP,0);
      Exit;
    end;
  end;

  if SystemParametersInfo(SPI_GETSCREENSAVERRUNNING, 0, @bValue, 0) then begin
     if nil <> DongaPOCB then DongaPOCB.SetPowerSaving(bValue);
  end;
end;

procedure TfrmMain.tmrIdlePmModeLogInPopUpTimer(Sender: TObject); //2023-10-12 IDLE_PMMODE_LOGIN_POPUP
var
  i : Integer;
  sDebug : string;
begin
  if (Common.SystemInfo.IdlePmModeLogInPopUpTime = 0) or // disabled
      Common.m_bMesOnline or                             // not PM mode
     ((frmLogIn <> nil) or (UserIdDlg <> nil)) or        // already Login Pop-up
     ((frmMainter <> nil) or (frmModelInfo <> nil) or (frmSystemSetup <> nil)) // on Working(Setup/ModelInfo/Mainter)
  then begin
    m_nIdlePmModeLogInPopUpTimerElapseCnt := 0; //Reset Cnt
    Exit;
  end;

  for i := 0 to DefPocb.CH_MAX do begin
    if (Logic[i] = nil) or (Logic[i].m_InsStatus <> IsStop) then begin // Not Idle
    sDebug := 'IMSI IdlePmModeLogInPopUpTime ...Exit(Busy)';  Common.MLog(DefPocb.SYS_LOG,sDebug);
      m_nIdlePmModeLogInPopUpTimerElapseCnt := 0; //Reset Cnt
      Exit;
    end;
  end;

  Inc(m_nIdlePmModeLogInPopUpTimerElapseCnt);
  sDebug := Format('IdlePmModeLogInPopUpTimer(elpased %d min)',[m_nIdlePmModeLogInPopUpTimerElapseCnt]);
  Common.MLog(DefPocb.SYS_LOG,sDebug);

  if (m_nIdlePmModeLogInPopUpTimerElapseCnt >= Common.SystemInfo.IdlePmModeLogInPopUpTime) then begin
    sDebug := Format('LogIn Window Pop-up (IdlePmModeLogInPopUpTime=%dmin elapsed))',[Common.SystemInfo.IdlePmModeLogInPopUpTime]);
    Common.MLog(DefPocb.SYS_LOG,sDebug);
    //
    btnLogInClick(nil); // Pop-up Login if not opened
    m_nIdlePmModeLogInPopUpTimerElapseCnt := 0; //Reset Cnt
  end;
end;

procedure TfrmMain.ShowAlarmMotionControl(nAlarmNo: Integer; bIsOn: Boolean);
var
  nMotionStOKColor, nMotionStOKFontColor, nMotionStNGColor, nMotionStNGFontColor : TColor;
  nMotionBtnOnColor, nMotionBtnOnFontColor, nMotionBtnOffColor, nMotionBtnOffFontColor : TColor;
  bCh1YaxisServoOn, bCh2YaxisServoOn : Boolean;
{$IFDEF HAS_MOTION_CAM_Z}
  bCh1ZaxisServoOn, bChZYaxisServoOn : Boolean;
{$ENDIF}
{$IFDEF HAS_ROBOT_CAM_Z}
  //bCh1RobotCanMove, bCh2RobotCanMove : Boolean; //TBD:ROBOT?
{$ENDIF}
{$IFDEF HAS_MOTION_TILTING}
  bCh1TaxisServoOn, bCh2TaxisServoOn : Boolean;
{$ENDIF}
  sOpMsg : string;
begin
  //TBD:GUI:ALARM? (SafetyAlarm인 경우, 안전사양에 따른 창 발생)

  // EMO
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  if Common.AlarmList[DefPocb.ALARM_DIO_EMO].bIsOn
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
  if Common.AlarmList[DefPocb.ALARM_DIO_EMO1_FRONT].bIsOn
     or Common.AlarmList[DefPocb.ALARM_DIO_EMO2_RIGHT].bIsOn
     or Common.AlarmList[DefPocb.ALARM_DIO_EMO3_INNER_RIGHT].bIsOn
     or Common.AlarmList[DefPocb.ALARM_DIO_EMO4_INNER_LEFT].bIsOn
     or Common.AlarmList[DefPocb.ALARM_DIO_EMO5_LEFT].bIsOn
{$ENDIF}
   //or Common.AlarmList[DefPocb.ALARM_DIO_EXTRA_EMS].bIsOn
  then begin
    ShowEMSAlarmMsg('EMO !!!');
    Exit;
  end;

  // non-EMS Alarm
  sOpMsg := '';

  //------------------------- Alarm Status & Motion Control
  nMotionStOKColor    := clLime;      nMotionStOKFontColor   := clBlack;
  nMotionStNGColor    := clRed;       nMotionStNGFontColor   := clYellow;
  nMotionBtnOnColor   := clLime;      nMotionBtnOnFontColor  := clBlack;
  nMotionBtnOffColor  := clBtnFace;   nMotionBtnOffFontColor := clSilver;
  bCh1YaxisServoOn := True; bCh2YaxisServoOn := True;
{$IFDEF HAS_MOTION_CAM_Z}
  bCh1ZaxisServoOn := True; bCh2ZaxisServoOn := True;
{$ENDIF}
{$IFDEF HAS_ROBOT_CAM_Z}
  //bCh1RobotCanMove := False; bCh2RobotCanMove := False; TBD:ROBOT?
{$ENDIF}
{$IFDEF HAS_MOTION_TILTING}
  bCh1TaxisServoOn := True; bCh2TaxisServoOn := True;
{$ENDIF}

  //
  Fframe_SystemArm.UpdateGui(sOpMsg);

  // CH1-Y
  if Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_DISCONNECTED].bIsOn then begin
     sOpMsg := sOpMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_DISCONNECTED].AlarmMsg;
    pnlAlarmMotionStCh1Y.Color := nMotionStNGColor; pnlAlarmMotionStCh1Y.Font.Color := nMotionStNGFontColor;
    pnlAlarmMotionStCh1Y.Caption := 'Disconnected';
    pnlSysInfoYAxis1ServoMsg.Color := nMotionStNGColor; pnlSysInfoYAxis1ServoMsg.Font.Color := nMotionStNGFontColor;
    pnlSysInfoYAxis1ServoMsg.Caption := 'Disconnected';
    bCh1YaxisServoOn := False;
  end
  else if Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_SIG_ALARM_ON].bIsOn then begin
    sOpMsg := sOpMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_SIG_ALARM_ON].AlarmMsg;
    pnlAlarmMotionStCh1Y.Color := nMotionStNGColor; pnlAlarmMotionStCh1Y.Font.Color := nMotionStNGFontColor;
    pnlAlarmMotionStCh1Y.Caption := 'Servo Alarm';
    pnlSysInfoYAxis1ServoMsg.Color := nMotionStNGColor; pnlSysInfoYAxis1ServoMsg.Font.Color := nMotionStNGFontColor;
    pnlSysInfoYAxis1ServoMsg.Caption := 'Servo Alarm';
    bCh1YaxisServoOn := False;
  end
  else begin
    if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_bHomeDone)
       {or Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_NEED_HOME_SEARCH].bIsOn} then begin //2021-11-02 Delete(or ALARM_ON)
      if DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_bHomeSearching then begin
        pnlAlarmMotionStCh1Y.Color := clYellow; pnlAlarmMotionStCh1Y.Font.Color := clRed;
        pnlAlarmMotionStCh1Y.Caption := 'Home Searching...';
        pnlSysInfoYAxis1ServoMsg.Color := nMotionStNGColor; pnlSysInfoYAxis1ServoMsg.Font.Color := nMotionStNGFontColor;
        pnlSysInfoYAxis1ServoMsg.Caption := 'Home Searching';
      end
      else begin
        pnlAlarmMotionStCh1Y.Color := nMotionStNGColor; pnlAlarmMotionStCh1Y.Font.Color := nMotionStNGFontColor;
        pnlAlarmMotionStCh1Y.Caption := 'Need HomeSearch';
        pnlSysInfoYAxis1ServoMsg.Color := nMotionStNGColor; pnlSysInfoYAxis1ServoMsg.Font.Color := nMotionStNGFontColor;
        pnlSysInfoYAxis1ServoMsg.Caption := 'Need HomeSearch';
      end;
    end
{$IFNDEF POCB_A2CH}
    else if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_bModelPos)
            {or Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_MODEL_POS_NG].bIsOn} then begin //2021-11-02 Delete(or ALARM_ON)
      if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_MotionStatus.IsInMotion) { and pnlAlarmMotionStCh1Y.Caption <> 'LoadPos Moving...'} then begin
        pnlAlarmMotionStCh1Y.Color := nMotionStNGColor; pnlAlarmMotionStCh1Y.Font.Color := nMotionStNGFontColor;
        pnlAlarmMotionStCh1Y.Caption := 'LoadPos NG';
        pnlSysInfoYAxis1ServoMsg.Color := nMotionStNGColor; pnlSysInfoYAxis1ServoMsg.Font.Color := nMotionStNGFontColor;
        pnlSysInfoYAxis1ServoMsg.Caption := 'LoadPos NG';
      end;
    end
{$ENDIF}
    else begin
      pnlAlarmMotionStCh1Y.Color := nMotionStOKColor; pnlAlarmMotionStCh1Y.Font.Color := nMotionStOKFontColor;
      pnlAlarmMotionStCh1Y.Caption := 'Ready';
      ledSysinfoYaxis1Motor.Value  := True;
      pnlSysInfoYAxis1ServoMsg.Color := nMotionStOKColor; pnlSysInfoYAxis1ServoMsg.Font.Color := nMotionStOKFontColor;
      pnlSysInfoYAxis1ServoMsg.Caption := 'Ready';
    end;
  end;

  // CH2-Y
  if Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_DISCONNECTED].bIsOn then begin
    sOpMsg := sOpMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_DISCONNECTED].AlarmMsg;
    pnlAlarmMotionStCh2Y.Color := nMotionStNGColor; pnlAlarmMotionStCh2Y.Font.Color := nMotionStNGFontColor;
    pnlAlarmMotionStCh2Y.Caption := 'Disconnected';
    pnlSysInfoYAxis2ServoMsg.Color := nMotionStNGColor; pnlSysInfoYAxis2ServoMsg.Font.Color := nMotionStNGFontColor;
    pnlSysInfoYAxis2ServoMsg.Caption := 'Disconnected';
    bCh2YaxisServoOn := False;
  end
  else if Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_SIG_ALARM_ON].bIsOn then begin
    sOpMsg := sOpMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_SIG_ALARM_ON].AlarmMsg;
    pnlAlarmMotionStCh2Y.Color := nMotionStNGColor; pnlAlarmMotionStCh2Y.Font.Color := nMotionStNGFontColor;
    pnlAlarmMotionStCh2Y.Caption := 'Servo Alarm';
    pnlSysInfoYAxis2ServoMsg.Color := nMotionStNGColor; pnlSysInfoYAxis2ServoMsg.Font.Color := nMotionStNGFontColor;
    pnlSysInfoYAxis2ServoMsg.Caption := 'Servo Alarm';
    bCh2YaxisServoOn := False;
  end
  else begin
    if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bHomeDone)
        {or Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_NEED_HOME_SEARCH].bIsOn} then begin //2021-11-02 Delete(or ALARM_ON)
      if DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bHomeSearching then begin
        pnlAlarmMotionStCh2Y.Color := clYellow; pnlAlarmMotionStCh2Y.Font.Color := clRed;
        pnlAlarmMotionStCh2Y.Caption := 'Home Searching...';
        pnlSysInfoYAxis2ServoMsg.Color := nMotionStNGColor; pnlSysInfoYAxis2ServoMsg.Font.Color := nMotionStNGFontColor;
        pnlSysInfoYAxis2ServoMsg.Caption := 'Home Searching';
      end
      else begin
        pnlAlarmMotionStCh2Y.Color := nMotionStNGColor; pnlAlarmMotionStCh2Y.Font.Color := nMotionStNGFontColor;
        pnlAlarmMotionStCh2Y.Caption := 'Need HomeSearch';
        pnlSysInfoYAxis2ServoMsg.Color := nMotionStNGColor; pnlSysInfoYAxis2ServoMsg.Font.Color := nMotionStNGFontColor;
        pnlSysInfoYAxis2ServoMsg.Caption := 'Need HomeSearch';
      end;
    end
{$IFNDEF POCB_A2CH}
    else if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bModelPos)
            {or Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_MODEL_POS_NG].bIsOn} then begin //2021-11-02 Delete(or ALARM_ON)
      if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_MotionStatus.IsInMotion) {pnlAlarmMotionStCh2Y.Caption <> 'LoadPos Moving...'} then begin
        pnlAlarmMotionStCh2Y.Color := nMotionStNGColor; pnlAlarmMotionStCh2Y.Font.Color := nMotionStNGFontColor;
        pnlAlarmMotionStCh2Y.Caption := 'LoadPos NG';
        pnlSysInfoYAxis2ServoMsg.Color := nMotionStNGColor; pnlSysInfoYAxis2ServoMsg.Font.Color := nMotionStNGFontColor;
        pnlSysInfoYAxis2ServoMsg.Caption := 'LoadPos NG';
      end;
    end
{$ENDIF}
    else begin
      pnlAlarmMotionStCh2Y.Color := nMotionStOKColor; pnlAlarmMotionStCh2Y.Font.Color := nMotionStOKFontColor;
      pnlAlarmMotionStCh2Y.Caption := 'Ready';
      ledSysinfoYaxis2Motor.Value  := True;
      pnlSysInfoYAxis2ServoMsg.Color := nMotionStOKColor; pnlSysInfoYAxis2ServoMsg.Font.Color := nMotionStOKFontColor;
      pnlSysInfoYAxis2ServoMsg.Caption := 'Ready';
    end;
  end;
	
{$IFDEF HAS_MOTION_CAM_Z}
  // CH1-Z
  if Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Z_DISCONNECTED].bIsOn then begin
    sOpMsg := sOpMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Z_DISCONNECTED].AlarmMsg;
    pnlAlarmMotionStCh1Z.Color := nMotionStNGColor;  pnlAlarmMotionStCh1Z.Font.Color := nMotionStNGFontColor;
    pnlAlarmMotionStCh1Z.Caption  := 'Disconnected';
    pnlSysInfoZAxis1ServoMsg.Color := nMotionStNGColor;  pnlSysInfoZAxis1ServoMsg.Font.Color := nMotionStNGFontColor;
    pnlSysInfoZAxis1ServoMsg.Caption  := 'Disconnected';
    bCh1ZaxisServoOn := False;
  end
  else if Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Z_SIG_ALARM_ON].bIsOn then begin
    sOpMsg := sOpMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Z_SIG_ALARM_ON].AlarmMsg;
    pnlAlarmMotionStCh1Z.Color := nMotionStNGColor;  pnlAlarmMotionStCh1Z.Font.Color := nMotionStNGFontColor;
    pnlAlarmMotionStCh1Z.Caption  := 'Servo Alarm';
    pnlSysInfoZAxis1ServoMsg.Color := nMotionStNGColor;  pnlSysInfoZAxis1ServoMsg.Font.Color := nMotionStNGFontColor;
    pnlSysInfoZAxis1ServoMsg.Caption  := 'Servo Alarm';
    bCh1ZaxisServoOn := False;
  end
  else begin
    if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Z].m_bHomeDone)
       {or Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Z_NEED_HOME_SEARCH].bIsOn} then begin //2021-11-02 Delete(or ALARM_ON)
      if pnlAlarmMotionStCh1Z.Caption <> 'Home Searching...' then begin
        pnlAlarmMotionStCh1Z.Color := nMotionStNGColor; pnlAlarmMotionStCh1Z.Font.Color := nMotionStNGFontColor;
        pnlAlarmMotionStCh1Z.Caption := 'Need HomeSearch';
        pnlSysInfoZAxis1ServoMsg.Color := nMotionStNGColor; pnlSysInfoZAxis1ServoMsg.Font.Color := nMotionStNGFontColor;
        pnlSysInfoZAxis1ServoMsg.Caption := 'Need HomeSearch';
      end;
    end
    else if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Z].m_bModelPos)
            {or Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Z_MODEL_POS_NG].bIsOn} then begin //2021-11-02 Delete(or ALARM_ON)
      if pnlAlarmMotionStCh1Z.Caption <> 'ModelPos Moving...' then begin
        pnlAlarmMotionStCh1Z.Color := nMotionStNGColor; pnlAlarmMotionStCh1Z.Font.Color := nMotionStNGFontColor;
        pnlAlarmMotionStCh1Z.Caption := 'ModelPos NG';
        pnlSysInfoZAxis1ServoMsg.Color := nMotionStNGColor; pnlSysInfoZAxis1ServoMsg.Font.Color := nMotionStNGFontColor;
        pnlSysInfoZAxis1ServoMsg.Caption := 'ModelPos NG';
      end;
    end
    else begin
      pnlAlarmMotionStCh1Z.Color := nMotionStOKColor; pnlAlarmMotionStCh1Z.Font.Color := nMotionStOKFontColor;
      pnlAlarmMotionStCh1Z.Caption := 'Ready';
      pnlSysInfoZAxis1ServoMsg.Color := nMotionStOKColor; pnlSysInfoZAxis1ServoMsg.Font.Color := nMotionStOKFontColor;
      pnlSysInfoZAxis1ServoMsg.Caption := 'Ready';
    end;
  end;
  // CH2-Z
  if Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Z_DISCONNECTED].bIsOn then begin
    sOpMsg := sOpMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Z_DISCONNECTED].AlarmMsg;
    pnlAlarmMotionStCh2Z.Color := nMotionStNGColor;  pnlAlarmMotionStCh2Z.Font.Color := nMotionStNGFontColor;
    pnlAlarmMotionStCh2Z.Caption  := 'Disconnected';
    pnlSysInfoZAxis2ServoMsg.Color := nMotionStNGColor;  pnlSysInfoZAxis2ServoMsg.Font.Color := nMotionStNGFontColor;
    pnlSysInfoZAxis2ServoMsg.Caption  := 'Disconnected';
    bCh2ZaxisServoOn := False;
  end
  else if Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Z_SIG_ALARM_ON].bIsOn then begin
    sOpMsg := sOpMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Z_SIG_ALARM_ON].AlarmMsg;
    pnlAlarmMotionStCh2Z.Color := nMotionStNGColor;  pnlAlarmMotionStCh2Z.Font.Color := nMotionStNGFontColor;
    pnlAlarmMotionStCh2Z.Caption  := 'Servo Alarm';
    pnlSysInfoZAxis2ServoMsg.Color := nMotionStNGColor;  pnlSysInfoZAxis2ServoMsg.Font.Color := nMotionStNGFontColor;
    pnlSysInfoZAxis2ServoMsg.Caption  := 'Servo Alarm';
    bCh2ZaxisServoOn := False;
  end
  else begin
    if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Z].m_bHomeDone)
       {or Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Z_NEED_HOME_SEARCH].bIsOn} then begin //2021-11-02 Delete(or ALARM_ON)
      if pnlAlarmMotionStCh2Z.Caption <> 'Home Searching...' then begin
        pnlAlarmMotionStCh2Z.Color := nMotionStNGColor; pnlAlarmMotionStCh2Z.Font.Color := nMotionStNGFontColor;
        pnlAlarmMotionStCh2Z.Caption := 'Need HomeSearch';
        pnlSysInfoZAxis2ServoMsg.Color := nMotionStNGColor; pnlSysInfoZAxis2ServoMsg.Font.Color := nMotionStNGFontColor;
        pnlSysInfoZAxis2ServoMsg.Caption := 'Need HomeSearch';
      end;
    end
    else if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Z].m_bModelPos)
            {or Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Z_MODEL_POS_NG].bIsOn} then begin //2021-11-02 Delete(or ALARM_ON)
      if pnlAlarmMotionStCh2Z.Caption <> 'ModelPos Moving...' then begin
        pnlAlarmMotionStCh2Z.Color := nMotionStNGColor; pnlAlarmMotionStCh2Z.Font.Color := nMotionStNGFontColor;
        pnlAlarmMotionStCh2Z.Caption := 'ModelPos NG';
        pnlSysInfoZAxis2ServoMsg.Color := nMotionStNGColor; pnlSysInfoZAxis2ServoMsg.Font.Color := nMotionStNGFontColor;
        pnlSysInfoZAxis2ServoMsg.Caption := 'ModelPos NG';
      end;
    end
    else begin
      pnlAlarmMotionStCh2Z.Color := nMotionStOKColor; pnlAlarmMotionStCh2Z.Font.Color := nMotionStOKFontColor;
      pnlAlarmMotionStCh2Z.Caption := 'Ready';
      pnlSysInfoZAxis2ServoMsg.Color := nMotionStOKColor; pnlSysInfoZAxis2ServoMsg.Font.Color := nMotionStOKFontColor;
      pnlSysInfoZAxis2ServoMsg.Caption := 'Ready';
    end;
  end;
{$ENDIF} //HAS_MOTION_CAM_Z}

{$IFDEF HAS_ROBOT_CAM_Z}
  //TBD:ROBOT?
{$ENDIF}

  //------------------------- Additional Status Check for Robot/Motion Control
{$IFDEF HAS_ROBOT_CAM_Z}
  if (DongaDio <> nil) and (DongaMotion <> nil) and (DongaRobot <> nil) then begin
{$ELSE}
  if (DongaDio <> nil) and (DongaMotion <> nil) then begin
{$ENDIF}
    //---------- CH1
    if bCh1YaxisServoOn
{$IFDEF HAS_MOTION_CAM_Z}
       and bCh1ZaxisServoOn
{$ENDIF}
{$IFDEF HAS_ROBOT_CAM_Z}
     //and bCh1RobotCanMove  //TBD:ROBOT?
{$ENDIF}
       and DongaDio.IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_1)
       and (not Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_NOT_AUTOMODE].bIsOn)
       and (not Common.AlarmList[DefPocb.ALARM_DIO_MC1].bIsOn) and (not Common.AlarmList[DefPocb.ALARM_DIO_MC2].bIsOn)
      {$IFDEF HAS_DIO_Y_AXIS_MC}
       and (not Common.AlarmList[DefPocb.ALARM_DIO_Y_AXIS_MC_CH1].bIsOn)
      {$ENDIF}
    then btnAlarmMotionCh1.Enabled := True 
    else btnAlarmMotionCh1.Enabled := False;
    if btnAlarmMotionCh1.Enabled then begin btnAlarmMotionCh1.Color := nMotionBtnOnColor;  btnAlarmMotionCh1.Font.Color := nMotionBtnOnFontColor;  end
    else                              begin btnAlarmMotionCh1.Color := nMotionBtnOffColor; btnAlarmMotionCh1.Font.Color := nMotionBtnOffFontColor; end;
    {$IFDEF POCB_A2CHv4_XXXXXX}  //2021-11-26 TBD:MOTION?
    btnAlarmMotionCh1.Visible := True;  //A2CHv4 (Individual CH Motion Control) //2021-11-26 TBD:MOTION?
    {$ELSE}
    btnAlarmMotionCh1.Visible := False; //A2CH|A2CHv2|A2CHv3 (No Individual CH Motion Control)
    {$ENDIF}
    //---------- CH2
    if bCh2YaxisServoOn
{$IFDEF HAS_MOTION_CAM_Z}
       and bCh2ZaxisServoOn
{$ENDIF}
{$IFDEF HAS_ROBOT_CAM_Z}
     //and bCh2RobotCanMove //TBD:ROBOT?
{$ENDIF}
       and DongaDio.IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_2)
       and (not Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_NOT_AUTOMODE].bIsOn)
       and (not Common.AlarmList[DefPocb.ALARM_DIO_MC1].bIsOn) and (not Common.AlarmList[DefPocb.ALARM_DIO_MC2].bIsOn)
      {$IFDEF HAS_DIO_Y_AXIS_MC}
       and (not Common.AlarmList[DefPocb.ALARM_DIO_Y_AXIS_MC_CH2].bIsOn)
      {$ENDIF}
    then btnAlarmMotionCh2.Enabled := True
    else btnAlarmMotionCh2.Enabled := False;
    if btnAlarmMotionCh2.Enabled then begin btnAlarmMotionCh2.Color := nMotionBtnOnColor;  btnAlarmMotionCh2.Font.Color := nMotionBtnOnFontColor;  end
    else                              begin btnAlarmMotionCh2.Color := nMotionBtnOffColor; btnAlarmMotionCh2.Font.Color := nMotionBtnOffFontColor; end;
    {$IFDEF POCB_A2CHv4_XXXXXX}  //2021-11-26 TBD:MOTION?
    btnAlarmMotionCh2.Visible := True;  //A2CHv4 (Individual CH Motion Control) //2021-11-26 TBD:MOTION?
    {$ELSE}
    btnAlarmMotionCh2.Visible := False; //A2CH|A2CHv2|A2CHv3 (No Individual CH Motion Control)
    {$ENDIF}
    //---------- CH1+CH2
    {$IFDEF POCB_A2CHv4_XXXXXX}
    if (btnAlarmMotionCh1.Enabled or btnAlarmMotionCh2.Enabled) then btnAlarmMotionAll.Enabled := True
    else                                                             btnAlarmMotionAll.Enabled := False;
    btnAlarmMotionAll.Visible := False; 
    {$ELSE}
  //if (btnAlarmMotionCh1.Enabled and btnAlarmMotionCh2.Enabled) and  //A2CH|A2CHv2|A2CHv3
    if (btnAlarmMotionCh1.Enabled or btnAlarmMotionCh2.Enabled) and   //A2CHv4
       (not DongaMotion.IsHomeDoneAll) and
       (not DongaMotion.IsAnyMotorMoving) then
      btnAlarmMotionAll.Enabled := True
    else begin
    //  btnAlarmMotionAll.Enabled := False;        // Modified by Kimjs007 2024-03-08 오후 5:59:45
    end;
    btnAlarmMotionAll.Visible := True; 
    {$ENDIF}
    if btnAlarmMotionAll.Enabled 
    then begin btnAlarmMotionAll.Color := nMotionBtnOnColor;  btnAlarmMotionAll.Font.Color := nMotionBtnOnFontColor;  end
    else begin btnAlarmMotionAll.Color := nMotionBtnOffColor; btnAlarmMotionAll.Font.Color := nMotionBtnOffFontColor; end;
  end;

  //---------------------------- LAMP(Red/Green/Yellow) & BUZZER //2019-04-16 (Move To UpdateAlarmStatus

  //------------------------- Operating Message
  if nAlarmNo <> DefPocb.ALARM_RESERVED0 then begin  //2019-03-29
    if (bIsOn) then sOpMsg := FormatDateTime('hh:mm:ss.zzz',Common.AlarmList[nAlarmNo].AlarmOnTime)
    else            sOpMsg := FormatDateTime('hh:mm:ss.zzz',Now);
    sOpMsg := sOpMsg + '  <ALARM> '+ Common.AlarmList[nAlarmNo].AlarmName;  //2019-03-29
    if bIsOn then begin
      sOpMsg := sOpMsg + '  ON ---';
      sOpMsg := sOpMsg + {#13 + #10 + '    ' +} Common.AlarmList[nAlarmNo].AlarmMsg;
      mmAlarmOpMsg.SelAttributes.Color := clRed;  //TBD:ALARM:UI:RichEdit?
    end
    else begin
      sOpMsg := sOpMsg + '  OFF';
      mmAlarmOpMsg.SelAttributes.Color := clBlue; //TBD:ALARM:UI:RichEdit?
    end;
  //CodeSite.Send('ShowAlarmMotionControl:mmAlarmOpMsg:'+IntToStr(nAlarmNo));
    mmAlarmOpMsg.DisableAlign;
    mmAlarmOpMsg.Lines.Add(sOpMsg);
    mmAlarmOpMsg.Perform(EM_SCROLL,SB_LINEDOWN,0);
    mmAlarmOpMsg.EnableAlign;
    //
    mmAlarmOpMsg.SelAttributes.Color := clBlack;  //to Default  //TBD:ALARM:UI:RichEdit?
  end;

  //
  if (frmMainter = nil) then begin  //2019-03-29
    PnlAlarmMotionControl.Top  := frmMain.Height - PnlAlarmMotionControl.Height - 200;
    PnlAlarmMotionControl.Left := frmMain.Width  - PnlAlarmMotionControl.Width - 50;
    PnlAlarmMotionControl.Visible := True;
  end;
end;

procedure TfrmMain.ShowNgMessage(sMessage: string; bForce: Boolean=False);
var
  sCaption : string;
  sNgMsg  : string;
  sList   : TStringList;
  i       : Integer;
  bAppend : Boolean;
begin
{$IFDEF SIMULATOR}
  if (not bForce) then Exit;
{$ENDIF}

  if Common.Systeminfo.DebugSelfTestPg then begin GrpSystemNgMsg.Visible := False; Exit; end;
  if Length(sMessage) <= 0 then Exit;
  if lblSystemNgMsg.Caption <> '' then bAppend := True else bAppend := False;
  sCaption := lblSystemNgMsg.Caption;
  if sCaption.Contains(sMessage) then Exit;
  //
  sNgMsg := FormatDateTime('  hh:mm:ss.zzz   ', Now) + sMessage;
  lblSystemNgMsg.Caption := lblSystemNgMsg.Caption + #13 + #10 + sNgMsg;
  if bAppend then begin
    sList := TStringList.Create;
    try
      try
        ExtractStrings([#13,#10],[],PWideChar(lblSystemNgMsg.Caption),sList);
        if sList.Count > 13 then begin
          lblSystemNgMsg.Caption := '';
          for i := sList.Count-13 to Pred(sList.Count) do begin
            lblSystemNgMsg.Caption := lblSystemNgMsg.Caption + #13 + #10 + sList[i];
          end;
        end;
      except
      end;
    finally
      sList.Free;
    end;
  end;
  GrpSystemNgMsg.Top  := 200;
  GrpSystemNgMsg.Left := 450;
//if not DongaMotion.MaintMotionUse then GrpSystemNgMsg.Visible := True
//else                                   GrpSystemNgMsg.Visible := False;  //2019-03-19 (Maint:Dio&Motion인 경우, InVisible)
  if (frmMainter = nil) then GrpSystemNgMsg.Visible := True;   //2019-03-29
end;

procedure TfrmMain.lblSystemNgCloseClick(Sender: TObject);
begin
  lblSystemNgMsg.Caption := '';
  GrpSystemNgMsg.Visible := False;
end;

procedure TfrmMain.DoMotionYaxisHomeSearch(nCh: Integer);
var
  nAxis, nMotionID : Integer;
begin
	nAxis := DefMotion.MOTION_AXIS_Y;
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then Exit;
  tmrAutoHomeSearch.Enabled := True;
end;

{$IFDEF HAS_MOTION_CAM_Z}
procedure TfrmMain.DoMotionZaxisHomeSearch(nCh: Integer);
var
  nAxis, nMotionID : Integer;
begin
	nAxis := DefMotion.MOTION_AXIS_Z;
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then Exit;
  tmrAutoHomeSearch.Enabled := True;
end;
{$ENDIF}

{$IFDEF HAS_MOTION_TILTING}
procedure TfrmMain.DoMotionTaxisHomeSearch(nCh: Integer);
var
  nAxis, nMotionID : Integer;
begin
	nAxis := DefMotion.MOTION_AXIS_T;
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then Exit;
  tmrAutoHomeSearch.Enabled := True;
end;
{$ENDIF}

procedure TfrmMain.btnAlarmMotionCh1Click(Sender: TObject);
begin
{$IFDEF HAS_MOTION_CAM_Z}
  DoMotionZaxisHomeSearch(DefPocb.CH_1);
{$ENDIF}
  DoMotionYaxisHomeSearch(DefPocb.CH_1);
{$IFDEF HAS_MOTION_TILTING}
  DoMotionTaxisHomeSearch(DefPocb.CH_1);
{$ENDIF}
end;

procedure TfrmMain.btnAlarmMotionCh2Click(Sender: TObject);
begin
{$IFDEF HAS_MOTION_CAM_Z}
  DoMotionZaxisHomeSearch(DefPocb.CH_2);
{$ENDIF}
  DoMotionYaxisHomeSearch(DefPocb.CH_2);
{$IFDEF HAS_MOTION_TILTING}
  DoMotionTaxisHomeSearch(DefPocb.CH_2);
{$ENDIF}  
end;

procedure TfrmMain.btnAlarmMotionAllClick(Sender: TObject);
var
  nCh : Integer;
begin
  for nCh := DefPocb.CH_1 to DefPocb.CH_2 do begin
{$IFDEF HAS_MOTION_CAM_Z}
    DoMotionZaxisHomeSearch(nCh);
{$ENDIF}
    DoMotionYaxisHomeSearch(nCh);
{$IFDEF HAS_MOTION_TILTING}
    DoMotionTaxisHomeSearch(nCh);
{$ENDIF}
  end;
end;

procedure TfrmMain.btnAlarmRobotMoveModelClick(Sender: TObject);
begin
  tmrAutoRobotMoveModel.Enabled := True;
end;

procedure TfrmMain.btnClosePnlSystemAlarmClick(Sender: TObject);
begin
  PnlAlarmMotionControl.Visible := False;
  mmAlarmOpMsg.Lines.Clear;
end;

procedure TfrmMain.btnStopBuzzerClick(Sender: TObject); //2019-03-29
begin
  if (DongaDio = nil) then Exit;
  DongaDio.SetBuzzer(False);
end;

//******************************************************************************
// procedure/function: Timer
//******************************************************************************

procedure TfrmMain.tmrDisplayTestFormTimer(Sender: TObject);
var
  nJig, nCh : Integer;
  sTarget, sSource  : string;
  bInitMotor : Boolean;
  bInitRobot : Boolean;
  i, nIonSysIdx : Integer;
begin
  tmrDisplayTestForm.Enabled := False;
  //-------------------------- Camera Communications: Create and Connect
  if (CameraComm <> nil) then begin
    CameraComm.Free;
    CameraComm := nil;
  end;
  CameraComm := TCamComm.Create(Self.Handle);
  CameraComm.OnCamConnection := ShowCamConnStatus;
  CameraComm.CheckClientConnect(DefPocb.CAM_1);  // 내부적으로 OnCamConnection를 사용하기 때문에 OnCamConnection 선언 이후에 Code가 와야함.
  CameraComm.CheckClientConnect(DefPocb.CAM_2);  //2018-12-14
  tmrCamConnCheck.Enabled := True;
  //-------------------------- DIO
  if (DongaDio <> nil) then begin
    DongaDio.Free;
    DongaDio := nil;
  end;
  DongaDio := TDioCtl.Create(Self.Handle,50);
  DongaDio.DioConnSt    := ShowDioConnSt;
  DongaDio.DioOutReadSt := ShowDioOutReadSt;
  DongaDio.InDioStatus  := SetDioFlow;
  DongaDio.Connect;
  Sleep(100);
  DongaDio.GetDioStatus;
  //-------------------------- Motion Control
  bInitMotor := False;
  if DongaMotion = nil then begin
    bInitMotor := True;
    DongaMotion := TMotionCtl.Create(Self.Handle); //2019-04-04 TBD:ALARM:After DioConnect !!!
    //TBD:OLD? DongaMotion.MotionStatus := ShowMotionStatus;
    DongaMotion.Connect;
  {$IFDEF SUPPORT_1CG2PANEL}
  end
  else begin //2021-10-27
    if Common.SystemInfo.UseAssyPOCB then begin  //2021-10-27 (ASSY-POCB:StartUp/Initial/MainterClose) SetYAxisSyncMode regardless of DioAssyJigOn
      if (DongaMotion.Motion[MOTIONID_AxMC_STAGE1_Y].m_bConnected and DongaMotion.Motion[MOTIONID_AxMC_STAGE2_Y].m_bConnected)
          {and (Motion[MOTIONID_AxMC_STAGE1_Y].m_MotionStatus.nSyncStatus <> DefMotion.SyncLinkMaster)} then begin
        DongaMotion.SetYAxisSyncMode;
      end;
    end
    else begin
      if (DongaMotion.Motion[MOTIONID_AxMC_STAGE1_Y].m_bConnected and DongaMotion.Motion[MOTIONID_AxMC_STAGE2_Y].m_bConnected)
         {and (Motion[MOTIONID_AxMC_STAGE1_Y].m_MotionStatus.nSyncStatus <> DefMotion.SyncUnknown)
          and (Motion[MOTIONID_AxMC_STAGE1_Y].m_MotionStatus.nSyncStatus <> DefMotion.SyncNone)} then begin
        DongaMotion.ResetYAxisSyncMode;
      end;
    end;
  {$ENDIF} //SUPPORT_1CG2PANEL
  end;
  //-------------------------- Robot Control
{$IFDEF HAS_ROBOT_CAM_Z}
  bInitRobot := False;
  if DongaRobot = nil then begin
    bInitRobot := True;
    DongaRobot := TRobotCtl.Create(Self.Handle);
    DongaRobot.Connect;
    //
    if Common.RobotSysInfo.StartupMoveType <> DefRobot.StartupMoveNone then begin
      Common.CodeSiteSend('<FrmMain> RobotCtl.Create: tmrRobotStartupMove enable');
      tmrAutoRobotMoveModel.Enabled := True;
    end;
  end;
{$ENDIF}
  //-------------------------- frmTest1Ch
  for nJig := DefPocb.JIG_A to DefPocb.JIG_MAX do begin
    if frmTest1Ch[nJig] = nil then frmTest1Ch[nJig] := TfrmTest1Ch.Create(self);
    //
    frmTest1Ch[nJig].m_nJig := nJig;
    frmTest1Ch[nJig].m_nCh  := nJig;
    //
    frmTest1Ch[nJig].Tag      := nJig;
    frmTest1Ch[nJig].Height   := RzpnlMainFrmInfo.Height - m_nHeightSysGrp - 5;
    frmTest1Ch[nJig].Width    := ((Self.Width - RzpnlMainFrmInfo.Width) div 2) - 10;
    frmTest1Ch[nJig].Left     := frmTest1Ch[nJig].Width * nJig;
    frmTest1Ch[nJig].Top      := 0;
    frmTest1Ch[nJig].Visible  := True;
    frmTest1Ch[nJig].Caption  := Format('Stage %X',[nJig+1]);
    frmTest1Ch[nJig].ShowGui(Self.Handle);
    if (nJig = DefPocb.JIG_A) then frmTest1Ch[nJig].SetBcrSet;
    if nJig = DefPocb.JIG_A then DongaDio.ArrivedUnload1 := frmTest1Ch[nJig].arrivedAction   //2018-12-10
    else                         DongaDio.ArrivedUnload2 := frmTest1Ch[nJig].arrivedAction;  //2018-12-10
    if DongaGmes <> nil then DongaGmes.hTestHandle[nJig] := frmTest1Ch[nJig].Handle; //2018-12-14
    //
    for i := 0 to (Common.SystemInfo.IonizerCntPerCH-1) do begin
      nIonSysIdx := (nJig*Common.SystemInfo.IonizerCntPerCH) + i;
      DaeIonizer[nIonSysIdx] := TIonizer.Create(nJig,i{nIonChIdx}, Self.Handle,frmTest1Ch[nJig].Handle);
      DaeIonizer[nIonSysIdx].ChangePort(Common.SystemInfo.Com_ION[nIonSysIdx]);
    end;
    //
    if (not bInitMotor) then begin //2021-11-18
      frmTest1Ch[nJig].ShowMotionStatus(nJig,DefMotion.MOTION_AXIS_Y);
      {$IFDEF HAS_MOTION_CAM_Z}
      frmTest1Ch[nJig].ShowMotionStatus(nJig,DefMotion.MOTION_AXIS_Z);
      {$ENDIF}
      {$IFDEF HAS_MOTION_TILTING}
      frmTest1Ch[nJig].ShowMotionStatus(nJig,DefMotion.MOTION_AXIS_T);
      {$ENDIF}
    end;
    //
    {$IFDEF HAS_ROBOT_CAM_Z}
    if (not bInitRobot) then begin //2021-11-18
      frmTest1Ch[nJig].ShowRobotStatusCoord;
    end;
    {$ENDIF}
  end;

  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    if Logic[nCh] = nil then Exit;
  end;
  UdpServer.FIsReadyToRead := True;

  {$IFDEF REMOTE_UPDATE}
  if UsObject <> nil then begin
    UsObject.SetInpectReady := True;
  end;
  {$ENDIF}

  //-------------------------- File Copy
  if Common.SystemInfo.AutoBackupUse then begin
    sTarget := Trim(Common.SystemInfo.AutoBackupList);
    if sTarget <> '' then begin
      sSource :=  ExtractFilePath(Application.ExeName);

      if not DirectoryExists(sTarget) then
         CreateDir(sTarget);

      if DirectoryExists(sTarget) then begin
        Parallel.Async( procedure begin
            Common.CopyDirectoryAll(sSource,sTarget, False);
          end
        );
{$IFDEF REF_ISPD}
        aTask := TThread.CreateAnonymousThread(
          procedure begin
            Common.CopyDirectoryAll(sSource,sTarget, False);
          end);
        aTask.FreeOnTerminate := True;
        aTask.Start;
//        Parallel.Async( procedure begin
//            Common.CopyDirectoryAll(sSource,sTarget, False);
//          end
//        );
{$ENDIF}
      end;
    end;
  end;

{$IFDEF SITE_LENSVN}
  if (DongaGmes <> nil) and Common.m_bMesOnline then begin
    DongaGmes.SendHostStatus(DefPocb.CH_1{dummy}, LENS_MES_STATUS_IDLE{nEqStValue}, True{bForce}); //2023-08-21 LENS:MES:EQSTATUS:Warn:StartExe|Initial
  end;
{$ENDIF}
end;

procedure TfrmMain.tmrAutoHomeSearchTimer(Sender: TObject);
var
  nMotionID : Integer;
  MotionAlarmNo : TMotionAlarmNo;
  sReasonMsg : string;
begin
  if (DongaDio = nil) or (DongaMotion = nil) or (not DongaDio.m_bDioFirstReadDone) then Exit;
  // Check Mainter (if Mainter opened, skip)
  if (frmMainter <> nil) then begin
  //Common.CodeSiteSend('tmrAutoHomeSearch:Mainter:EXIT');
    Exit;
  end;
  // Check DIO (if EMO, skip)
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO) <> 0) then begin
    Common.CodeSiteSend('tmrAutoHomeSearch:EXIT(DIO_EMO)');
    Exit;
  end;
{$ELSE}
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO1_FRONT) <> 0) then begin
    Common.CodeSiteSend('tmrAutoHomeSearch:EXIT(DIO_EMO1_FRONT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO2_RIGHT) <> 0) then begin
    Common.CodeSiteSend('tmrAutoHomeSearch:EXIT(DIO_EMO2_RIGHT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO3_INNER_RIGHT) <> 0) then begin
    Common.CodeSiteSend('tmrAutoHomeSearch:EXIT(DIO_EMO3_INNER_RIGHT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO4_INNER_LEFT) <> 0) then begin
    Common.CodeSiteSend('tmrAutoHomeSearch:EXIT(DIO_EMO4_INNER_LEFT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO5_LEFT) <> 0) then begin
    Common.CodeSiteSend('tmrAutoHomeSearch:EXIT(DIO_EMO5_LEFT)');
    Exit;
  end;
{$ENDIF}

  // Check DIO (if EMO, skip)
  if Common.AlarmList[DefPocb.ALARM_DIO_EXTRA_EMS].bIsOn then begin
    Common.CodeSiteSend('tmrAutoHomeSearch:EXIT(EMS)');
    Exit;
  end;

{$IFDEF SUPPORT_1CG2PANEL}
  // Check DIO (ShutterGuide, AssyJig)
  if not Common.SystemInfo.UseAssyPOCB then begin
    // ShutterGuide
    if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
    if ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) <> 0) then begin
      if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) <> 0) and ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) = 0) and
         ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) <> 0) and ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) = 0) then begin // CH1&CH2 AutoMode
        if (DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0 then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
        Common.CodeSiteSend('tmrAutoHomeSearch:NonASSY-POCB:NotShutterGuideUp:ShutterGuideUp:SKIP');
      end
      else begin
        Common.CodeSiteSend('tmrAutoHomeSearch:NonASSY-POCB:NotShutterGuideUp:CH1|CH2-NotAutoMode:SKIP');
        //TBD? (NOTIFY?)
      end;
      Exit;
    end;
    // AssyJig
    if (DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_JIG_INTERLOCK) <> 0 then begin //AssyJig Detected
      Common.CodeSiteSend('tmrAutoHomeSearch:ASSY-POCB:AssyJig-Deteced:SKIP');
      //TBD? (NOTIFY?)
      Exit;
    end;
  end
  else begin
    // Check CH1|CH2 Swtitch is Auto Mode (if Teach mode, skip)
    if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) or
       ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) then begin
      Common.CodeSiteSend('tmrAutoHomeSearch:CH1|CH2:NotAutoMode:SKIP');
      Exit;
    end;
    // Check CH1|CH2 Doors Opened
    if not DongaDio.IsDoorClosed(True{bCheckUnderDoor},-1) then begin
      Common.CodeSiteSend('tmrAutoHomeSearch:CH1|CH2:MaintDoor1|2:Open:SKIP');
      Exit;
    end;
    // ShutterGuide
    if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) <> 0) then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
    if ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) <> 0) then begin
      if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) <> 0) and ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) = 0) and
         ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) <> 0) and ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) = 0) then begin
        if (DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) = 0 then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
        Common.CodeSiteSend('tmrAutoHomeSearch:ASSY-POCB:NotShutterGuideDown:ShutterGuideDown:SKIP');
      end
      else begin
        Common.CodeSiteSend('tmrAutoHomeSearch:ASSY-POCB:NotShutterGuideDown:CH1|CH2-NotAutoMode:SKIP');
        //TBD? (NOTIFY?)
      end;
      Exit;
    end;
    // AssyJig
    if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_JIG_INTERLOCK) <> 0) and ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_JIG_INTERLOCK) <> 0) then begin //AssyJig Mis-aligned
      Common.CodeSiteSend('tmrAutoHomeSearch:ASSY-POCB:AssyJig-Misaligned:SKIP');
      //TBD? (NOTIFY?)
      Exit;
    end;
  end;
{$ENDIF} //SUPPORT_1CG2PANEL

  //---------------------------------------
  tmrAutoHomeSearch.Enabled := False; // !!!!
  for nMotionID := DefMotion.MOTIONID_BASE to DefMotion.MOTIONID_MAX do begin
    Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':start');
    // Check Motion (if Motion already Home Searched, skip)
    if DongaMotion.Motion[nMotionID].m_bHomeDone then begin
      Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':HomeDone:SKIP');
      Continue;
    end;
    //--------------- Check DIO (For Y-axis, skip if not Shutter Up)
    {$IFDEF SUPPORT_1CG2PANEL}
    if not Common.SystemInfo.UseAssyPOCB then begin
    {$ENDIF}
      case nMotionID of
        DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
          // Check CH1 Swtitch is Auto Mode (if Teach mode, skip)
          if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) then begin
            Common.CodeSiteSend('tmrAutoHomeSearch:CH1:NotAutoMode:SKIP');
            Continue;
          end;
          // Check CH1 Doors Opened
          if not DongaDio.IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_1) then begin
            Common.CodeSiteSend('tmrAutoHomeSearch:CH1:MaintDoor1|2Open:SKIP');
            Continue;
          end;
          // ShutterGuide
        //if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
        //if ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0) or ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) <> 0) then begin
        //  if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0 then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
        //  Common.CodeSiteSend('tmrAutoHomeSearch:CH1:NotShutterGuideUp:ShutterGuideUp:SKIP');
        //  Continue;
        //end;
          // CH1 Shutters
          if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE1_SHUTTER_DOWN);
					{$IFDEF HAS_DIO_SCREW_SHUTTER}					
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
            if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP);
          end;
					{$ENDIF}
          if not DongaDio.CheckShutterState(DefPocb.CH_1,ShutterState.UP) then begin
            if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) <> 0) then begin
              if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0 then DongaDio.SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
              Common.CodeSiteSend('tmrAutoHomeSearch:CH1:NotShutterUp:ShutterUP:SKIP');
            end;
						{$IFDEF HAS_DIO_SCREW_SHUTTER}											
            if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
              if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) <> 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) = 0) then begin
                if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) = 0 then DongaDio.SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN);
                Common.CodeSiteSend('tmrAutoHomeSearch:CH1:NotScrewShutterDown:ScrewShutterDown:SKIP');
              end;
            end;
  					{$ENDIF}						
            Continue;
          end;
        end;
        DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
          // Check CH2 Swtitch is Auto Mode (if Teach mode, skip)
          if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) then begin
            Common.CodeSiteSend('tmrAutoHomeSearch:CH2:NotAutoMode:SKIP');
            Continue;
          end;
          // Check CH2 Doors Opened
          if not DongaDio.IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_2) then begin
            Common.CodeSiteSend('tmrAutoHomeSearch:CH2:MaintDoor1|2Open:SKIP');
            Continue;
          end;
          // ShutterGuide
        //if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
        //if ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0) or ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) <> 0) then begin
        //  if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0 then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
        //  Common.CodeSiteSend('tmrAutoHomeSearch:CH2:NotShutterGuideUp:ShutterGuideUp:SKIP');
        //  Continue;
        //end;
          // CH2 Shutters
          if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE2_SHUTTER_DOWN);
					{$IFDEF HAS_DIO_SCREW_SHUTTER}					
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
            if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP);
          end;
 					{$ENDIF}											
          if not DongaDio.CheckShutterState(DefPocb.CH_2,ShutterState.UP) then begin
            if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) <> 0) then begin
              if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0 then DongaDio.SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
              Common.CodeSiteSend('tmrAutoHomeSearch:CH2:NotShutterUp:ShutterUP:SKIP');
            end;
  					{$IFDEF HAS_DIO_SCREW_SHUTTER}						
            if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
              if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) <> 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) = 0) then begin
                if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN) = 0 then DongaDio.SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN);
                Common.CodeSiteSend('tmrAutoHomeSearch:CH2:NotScrewShutterDown:ScrewShutterDown:SKIP');
              end;
            end;
  					{$ENDIF}												
            Continue;
          end;
        end;
      end;
    {$IFDEF SUPPORT_1CG2PANEL}
    end
    else begin  // ASSY-POCB
      //
      if (nMotionID = DefMotion.MOTIONID_AxMC_STAGE2_Y) and DongaMotion.m_bDioAssyJigOn then begin  //2020-03-02
        Common.CodeSiteSend('tmrAutoHomeSearch:CH2:AssyJigON:SKIP');
        Continue;
      end;
      //
      case nMotionID of
        DefMotion.MOTIONID_AxMC_STAGE1_Y,
        DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
          // Check CH1 Swtitch is Auto Mode (if Teach mode, skip)
          if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) then begin
            Common.CodeSiteSend('tmrAutoHomeSearch:CH1:NotAutoMode:SKIP');
            Continue;
          end;
          // Check CH2 Swtitch is Auto Mode (if Teach mode, skip)
          if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) then begin
            Common.CodeSiteSend('tmrAutoHomeSearch:CH2:NotAutoMode:SKIP');
            Continue;
          end;
          // Shutter/ScrewShutter/ShutterGuide
          if not DongaDio.CheckShutterState(DefPocb.CH_1,ShutterState.UP) then begin
            // ShutterGuide
            if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) <> 0) then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
            if ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) <> 0) then begin
              if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) = 0) then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
              Common.CodeSiteSend('tmrAutoHomeSearch:CH1/CH2:NotShutterGuideDown:ShutterGuideDown:SKIP');
            end;
            // CH1/CH2 Shutter
            if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) <> 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SHUTTER_DOWN);
            if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) <> 0) then begin
              if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
              Common.CodeSiteSend('tmrAutoHomeSearch:CH1:NotShutterUp:ShutterUP:SKIP');
            end;
            if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) <> 0) then DongaDio.SetDio(DefDio.OUT_STAGE2_SHUTTER_DOWN);
            if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) <> 0) then begin
              if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
              Common.CodeSiteSend('tmrAutoHomeSearch:CH2:NotShutterUp:ShutterUP:SKIP');
            end;
            // CH1/CH2 ScrewShutter
						{$IFDEF HAS_DIO_SCREW_SHUTTER}						
            if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
              if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) <> 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP);
              if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) <> 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) = 0) then begin
                if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN);
                Common.CodeSiteSend('tmrAutoHomeSearch:CH1:NotScrewShutterDown:ScrewShutterDown:SKIP');
              end;
              if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) <> 0) then DongaDio.SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP);
              if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) <> 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) = 0) then begin
                if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN);
                Common.CodeSiteSend('tmrAutoHomeSearch:CH2:NotScrewShutterDown:ScrewShutterDown:SKIP');
              end;
            end;
						{$ENDIF}
            Continue;
          end;
        end;
      end;
    end;
    {$ENDIF} //SUPPORT_1CG2PANEL
    //--------------- Check DIO (if not Light Curtain Off, skip)
    case nMotionID of
    	DefMotion.MOTIONID_AxMC_STAGE1_Y, DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
        //TBD:MOTION:SAFTETY? (LightCurtain?)  Y축 Home상태인 것은 어떻게?
      end;
    end;
    //-------------- Check Motion Status
    if (not DongaMotion.CheckMotionMovable(nMotionID,sReasonMsg)) then begin
      Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':CheckMotionMovable('+sReasonMsg+':SKIP');  //2020-03-02
      Continue;
    end;
    //-------------- Check Motion Status
    Common.GetMotionAlarmNo(nMotionID,MotionAlarmNo);
    // Check Motion (if Motion Control Disconneected, skip)
    if Common.AlarmList[MotionAlarmNo.DISCONNECTED].bIsOn then begin
			Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':DISCONNECTED:SKIP');
			Continue;
		end;
    // Check Motion (if Motion Alarm On, skip)
    if Common.AlarmList[MotionAlarmNo.SIG_ALARM_ON].bIsOn then begin
			Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':SIG_ALARM_ON:SKIP');
			Continue;
		end;
    // Check Motion (if Motion Unit/Pulse Error, skip)
    if Common.AlarmList[MotionAlarmNo.INVALID_UNITPULSE].bIsOn then begin
			Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':INVALID_UNITPULSE:SKIP');
			Continue;
		end;
	  // Check Motion (if Motion Moving, skip)
    if DongaMotion.Motion[nMotionID].m_MotionStatus.IsInMotion then begin
			Common.CodeSiteSend('tmrAutoHomeSearchMOTIONID:'+IntToStr(nMotionID)+':InMotion:SKIP');
			Continue;
		end;
	  // Check Motion (if Motion already Home Searching, skip)
    case nMotionID of
      DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
        if pnlAlarmMotionStCh1Y.Caption = 'Home Searching...' then begin
          Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':HomeSearching:SKIP');
          Continue;
        end;
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
        if pnlAlarmMotionStCh2Y.Caption = 'Home Searching...' then begin
          Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':HomeSearching:SKIP');
          Continue;
        end;
      end;
      {$IFDEF HAS_MOTION_CAM_Z}
      DefMotion.MOTIONID_AxMC_STAGE1_Z: begin
        if pnlAlarmMotionStCh1Z.Caption = 'Home Searching...' then begin
          Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':HomeSearching:SKIP');
          Continue;
        end;
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_Z: begin
        if pnlAlarmMotionStCh2Z.Caption = 'Home Searching...' then begin
          Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':HomeSearching:SKIP');
          Continue;
        end;
      end;
      {$ENDIF}
      {$IFDEF HAS_MOTION_TILTING}
      DefMotion.MOTIONID_AxMC_STAGE1_T: begin
        if pnlAlarmMotionStCh1T.Caption = 'Home Searching...' then begin
          Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':HomeSearching:SKIP');
          Continue;
        end;
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_T: begin
        if pnlAlarmMotionStCh2T.Caption = 'Home Searching...' then begin
          Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':HomeSearching:SKIP');
          Continue;
        end;
      end;
      {$ENDIF}
    end;
    //-------------- Move to HOME
    Common.CodeSiteSend('tmrAutoHomeSearch:'+IntToStr(nMotionID)+':MoveHOME:start');
    {$IFDEF HAS_MOTION_TILTING}
    case nMotionID of
    	DefMotion.MOTIONID_AxMC_STAGE1_T, DefMotion.MOTIONID_AxMC_STAGE2_T: begin
        if not Common.MotionInfo.SkipTaxisMotionCtl then begin
          DongaMotion.Motion[nMotionID].MoveHOME;
        end
        else begin
          //정상적으로 HOME SEARCH되었을 떄의 처리들???? TBD:MOTION:T-AXIS:SKIP?
        end;
      end;
      else begin
        DongaMotion.Motion[nMotionID].MoveHOME;
      end;
    end;
    {$ELSE}
    case nMotionID of
      {$IFDEF HAS_MOTION_CAM_Z}
      DefMotion.MOTIONID_AxMC_STAGE1_Z:
        Common.MotionLog(DefPocb.CH_1, '<Z-Axis> Homesearch Start');
      DefMotion.MOTIONID_AxMC_STAGE2_Z:
        Common.MotionLog(DefPocb.CH_2, '<Z-Axis> Homesearch Start');
      {$ENDIF}
      DefMotion.MOTIONID_AxMC_STAGE1_Y:
        Common.MotionLog(DefPocb.CH_1, '<Y-Axis> Homesearch Start');
      DefMotion.MOTIONID_AxMC_STAGE2_Y:
        Common.MotionLog(DefPocb.CH_2, '<Y-Axis> Homesearch Start');
    end;
    DongaMotion.Motion[nMotionID].MoveHOME;
    {$ENDIF}
    //TBD? frmTest1Ch[nJig].pnlJigStatus.Caption := 'Please wait for Home Search'; //TBD:GUI:JIG? (Clear?)
    //TBD? frmTest1Ch[nJig].pnlJigStatus.Color := clRed;         //TBD:GUI:JIG? (Clear?)
    Common.CodeSiteSend('tmrAutoHomeSearch:MOTIONID'+IntToStr(nMotionID)+':end');
  end;
  //
  if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_bHomeDone)
     or (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bHomeDone)
//if Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_NEED_HOME_SEARCH].bIsOn
//   or Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_NEED_HOME_SEARCH].bIsOn
    {$IFDEF HAS_MOTION_CAM_Z}
//   or Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Z_NEED_HOME_SEARCH].bIsOn
//   or Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Z_NEED_HOME_SEARCH].bIsOn
     or (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Z].m_bHomeDone)
     or (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Z].m_bHomeDone)
    {$ENDIF}
  then begin
     tmrAutoHomeSearch.Enabled := True;
	end
	else begin
  	CodeSite.Send('tmrAutoHomeSearch:AllHomeDone:StopTimer');
  //frmTest1Ch[0].ResetChGui(0);
  //frmTest1Ch[1].ResetChGui(0);
  end;
end;

procedure TfrmMain.tmrYAxisModelPosTimer(Sender: TObject);
var
  nJig      : Integer;
  nMotionID : Integer;
  MotionAlarmNo : TMotionAlarmNo;
begin
  if (DongaDio = nil) or (DongaMotion = nil) then Exit;
  // Check Mainter (if Mainter opened, skip)
  if (frmMainter <> nil) then begin
    //Common.CodeSiteSend('tmrYAxisModelPosTimer:Mainter:EXIT');
    Exit;
  end;

  // Check DIO (if EMO, skip)
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO)');
    Exit;
  end;
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
  // Check DIO (if EMS, skip)
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO1_FRONT) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO1_FRONT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO2_RIGHT) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO2_RIGHT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO3_INNER_RIGHT) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO3_INNER_RIGHT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO4_INNER_LEFT) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO4_INNER_LEFT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO5_LEFT) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO5_LEFT)');
    Exit;
  end;
{$ENDIF} //A2CH|A2CHv2, A2CHv3|A2CHv4

  // Check DIO (if EMO, skip)
  if Common.AlarmList[DefPocb.ALARM_DIO_EXTRA_EMS].bIsOn then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(EMS)');
    Exit;
  end;

{$IFDEF SUPPORT_1CG2PANEL}
  // Check DIO (ShutterGuide, AssyJig)
  if not Common.SystemInfo.UseAssyPOCB then begin
    // ShutterGuide
    if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
    if ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) <> 0) then begin
      if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) <> 0) and ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) = 0) and
         ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) <> 0) and ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) = 0) then begin // CH1&CH2 AutoMode
        if (DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0 then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
        Common.CodeSiteSend('tmrYAxisModelPosTimer:NonASSY-POCB:NotShutterGuideUp:ShutterGuideUp:SKIP');
      end
      else begin
        Common.CodeSiteSend('tmrYAxisModelPosTimer:NonASSY-POCB:NotShutterGuideUp:CH1|CH2-NotAutoMode:SKIP');
        //TBD? (NOTIFY?)
      end;
      Exit;
    end;
    // AssyJig
    if (DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_JIG_INTERLOCK) <> 0 then begin //AssyJig Detected
      Common.CodeSiteSend('tmrYAxisModelPosTimer:ASSY-POCB:AssyJig-Deteced:SKIP');
      //TBD? (NOTIFY?)
      Exit;
    end;
  end
  else begin
    // Check CH1|CH2 Swtitch is Auto Mode (if Teach mode, skip)
    if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) or
       ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) then begin
      Common.CodeSiteSend('tmrYAxisModelPosTimer:CH1|CH2:NotAutoMode:SKIP');
      Exit;
    end;
    // Check CH1|CH2 Doors Opened
    if not DongaDio.IsDoorClosed(True{bCheckUnderDoor},-1) then begin
      Common.CodeSiteSend('tmrYAxisModelPosTimer:CH1|CH2:MaintDoor1|2:Open:SKIP');
      Exit;
    end;
    // ShutterGuide
    if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) <> 0) then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
    if ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) <> 0) then begin
      if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) <> 0) and ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) = 0) and
         ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) <> 0) and ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) = 0) then begin
        if (DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) = 0 then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
        Common.CodeSiteSend('tmrYAxisModelPosTimer:ASSY-POCB:NotShutterGuideDown:ShutterGuideDown:SKIP');
      end
      else begin
        Common.CodeSiteSend('tmrYAxisModelPosTimer:ASSY-POCB:NotShutterGuideDown:CH1|CH2-NotAutoMode:SKIP');
        //TBD? (NOTIFY?)
      end;
      Exit;
    end;
    // AssyJig
    if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_JIG_INTERLOCK) <> 0) and ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_JIG_INTERLOCK) <> 0) then begin //AssyJig Mis-aligned
      Common.CodeSiteSend('tmrYAxisModelPosTimer:ASSY-POCB:AssyJig-Misaligned:SKIP');
      //TBD? (NOTIFY?)
      Exit;
    end;
  end;
{$ENDIF} //SUPPORT_1CG2PANEL

  Common.CodeSiteSend('tmrYAxisModelPosTimer');
  //----------------------------------------------
  tmrYAxisModelPos.Enabled := False;	// !!!!
  for nJig := DefPocb.JIG_A to DefPocb.JIG_B do begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:CH'+IntToStr(nJig+1)+':start');
    DongaMotion.GetChAxis2MotionID(nJig,MOTION_AXIS_Y,nMotionID);
    Common.GetMotionAlarmNo(nMotionID,MotionAlarmNo);
    // Check Motion (if Motion already Home Searched, skip)
    if not DongaMotion.Motion[nMotionID].m_bHomeDone then begin
      Common.CodeSiteSend('tmrYAxisModelPosTimer:CH'+IntToStr(nMotionID+1)+':NotHomeDone:SKIP');
      Continue;
    end;
    // Check Motion (if Motion already ModelPos Done, skip)
    if DongaMotion.Motion[nMotionID].m_bModelPos then begin
      Common.CodeSiteSend('tmrYAxisModelPosTimer:CH'+IntToStr(nMotionID+1)+':ModelPosDone:SKIP');
      Continue;
    end;
    //--------------- Check DIO (For Y-axis, skip if not Shutter Up)
    {$IFDEF SUPPORT_1CG2PANEL}
    if not Common.SystemInfo.UseAssyPOCB then begin  //A2CHv3:DIO
    {$ENDIF}
      case nMotionID of
        DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
          // Check CH1 Swtitch is Auto Mode (if Teach mode, skip)
          if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) then begin
            Common.CodeSiteSend('tmrYAxisModelPosTimer:CH1:NotAutoMode:SKIP');
            Continue;
          end;
          // Check CH1 Doors Opened
          if not DongaDio.IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_1) then begin
            Common.CodeSiteSend('tmrYAxisModelPosTimer:CH1:MaintDoor1|2Open:SKIP');
            Continue;
          end;
          // ShutterGuide
        //if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
        //if ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0) or ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) <> 0) then begin
        //  if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0 then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
        //  Common.CodeSiteSend('tmrAutoHomeSearch:CH1:NotShutterGuideUp:ShutterGuideUp:SKIP');
        //  Continue;
        //end;
          // CH1 Shutters
          if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) <> 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SHUTTER_DOWN);
					{$IFDEF HAS_DIO_SCREW_SHUTTER}					
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
            if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) <> 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP);
          end;
					{$ENDIF}					
          if not DongaDio.CheckShutterState(DefPocb.CH_1,ShutterState.UP) then begin
            if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) <> 0) then begin
              if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
              Common.CodeSiteSend('tmrYAxisModelPosTimer:CH1:NotShutterUp:ShutterUP:SKIP');
            end;
						{$IFDEF HAS_DIO_SCREW_SHUTTER}						
            if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
              if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) <> 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) = 0) then begin
                if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN);
                Common.CodeSiteSend('tmrYAxisModelPosTimer:CH1:NotScrewShutterDown:ScrewShutterDown:SKIP');
              end;
            end;
						{$ENDIF}						
            Continue;
          end;
        end;
        DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
          // Check CH2 Swtitch is Auto Mode (if Teach mode, skip)
          if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) then begin
            Common.CodeSiteSend('tmrYAxisModelPosTimer:CH2:NotAutoMode:SKIP');
            Continue;
          end;
          // Check CH2 Doors Opened
          if not DongaDio.IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_2) then begin
            Common.CodeSiteSend('tmrYAxisModelPosTimer:CH2:MaintDoor1|2Open:SKIP');
            Continue;
          end;
          // ShutterGuide
        //if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
        //if ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0) or ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) <> 0) then begin
        //  if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0 then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
        //  Common.CodeSiteSend('tmrAutoHomeSearch:CH2:NotShutterGuideUp:ShutterGuideUp:SKIP');
        //  Continue;
        //end;
          // CH2 Shutters
          if (DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) <> 0 then DongaDio.SetDio(DefDio.OUT_STAGE2_SHUTTER_DOWN);
					{$IFDEF HAS_DIO_SCREW_SHUTTER}					
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
            if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) <> 0) then DongaDio.SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP);
          end;
					{$ENDIF}					
          if not DongaDio.CheckShutterState(DefPocb.CH_2,ShutterState.UP) then begin
            if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) <> 0) then begin
              if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
              Common.CodeSiteSend('tmrYAxisModelPosTimer:CH2:NotShutterUp:ShutterUP:SKIP');
            end;
						{$IFDEF HAS_DIO_SCREW_SHUTTER}						
            if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
              if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) <> 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) = 0) then begin
                if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN);
                Common.CodeSiteSend('tmrYAxisModelPosTimer:CH2:NotScrewShutterDown:ScrewShutterDown:SKIP');
              end;
            end;
						{$ENDIF}
            Continue;
          end;
        end;
      end;
    {$IFDEF SUPPORT_1CG2PANEL}
    end
    else begin  // ASSY-POCB
      case nMotionID of
        DefMotion.MOTIONID_AxMC_STAGE1_Y,
        DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
          // Check CH1 Swtitch is Auto Mode (if Teach mode, skip)
          if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) then begin
            Common.CodeSiteSend('tmrYAxisModelPosTimer:CH1:NotAutoMode:SKIP');
            Continue;
          end;
          // Check CH2 Swtitch is Auto Mode (if Teach mode, skip)
          if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) then begin
            Common.CodeSiteSend('tmrYAxisModelPosTimer:CH2:NotAutoMode:SKIP');
            Continue;
          end;
          // Shutter/ScrewShutter/ShutterGuide
          if not DongaDio.CheckShutterState(DefPocb.CH_1,ShutterState.UP) then begin
            // ShutterGuide
          //if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) <> 0) then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
          //if ((DongaDio.m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0) or ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) <> 0) then begin
          //  if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) = 0 then DongaDio.SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
          //  Common.CodeSiteSend('tmrYAxisModelPosTimer:CH1/CH2:NotShutterGuideDown:ShutterGuideDown:SKIP');
          //end;
            // CH1/CH2 Shutter
            if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) <> 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SHUTTER_DOWN);
            if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) <> 0) then begin
              if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
              Common.CodeSiteSend('tmrYAxisModelPosTimer:CH1:NotShutterUp:ShutterUP:SKIP');
            end;
            if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) <> 0) then DongaDio.SetDio(DefDio.OUT_STAGE2_SHUTTER_DOWN);
            if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) <> 0) then begin
              if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
              Common.CodeSiteSend('tmrYAxisModelPosTimer:CH2:NotShutterUp:ShutterUP:SKIP');
            end;
            // CH1/CH2 ScrewShutter
						{$IFDEF HAS_DIO_SCREW_SHUTTER}						
            if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
              if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) <> 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP);
              if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) <> 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) = 0) then begin
                if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN);
                Common.CodeSiteSend('tmrYAxisModelPosTimer:CH1:NotScrewShutterDown:ScrewShutterDown:SKIP');
              end;
              if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) <> 0) then DongaDio.SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP);
              if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) <> 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) = 0) then begin
                if ((DongaDio.m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN) = 0) then DongaDio.SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN);
                Common.CodeSiteSend('tmrYAxisModelPosTimer:CH2:NotScrewShutterDown:ScrewShutterDown:SKIP');
              end;
            end;
						{$ENDIF}
            Continue;
          end;
        end;
      end;
    end;
    {$ENDIF} //SUPPORT_1CG2PANEL

    Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':start');
    Common.GetMotionAlarmNo(nMotionID,MotionAlarmNo);
    //-------------- Check Motion Status
		// Check Motion (if not Home Searched, skip)
    if (not DongaMotion.Motion[nMotionID].m_bHomeDone) then begin
			Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':NEED_HOME_SEARCH:SKIP');
      Common.MotionLog(nJig, 'YModelPos : Not Initialized');
			Continue;
    end;
    // Check Motion (if Motion Control Disconneected, skip)
    if Common.AlarmList[MotionAlarmNo.DISCONNECTED].bIsOn then begin
			Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':DISCONNECTED:SKIP');
      Common.MotionLog(nJig, 'YModelPos : Disconnect');
			Continue;
    end;
    // Check Motion (if Motion Alarm On, skip)
    if Common.AlarmList[MotionAlarmNo.SIG_ALARM_ON].bIsOn then begin
			Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':SIG_ALARM_ON:SKIP');
      Common.MotionLog(nJig, 'YModelPos : Motion Alarm');
			Continue;
    end;
    // Check Motion (if Motion Unit/Pulse Error, skip)
    if Common.AlarmList[MotionAlarmNo.INVALID_UNITPULSE].bIsOn then begin
			Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':INVALID_UNITPULSE:SKIP');
      Common.MotionLog(nJig, 'YModelPos : Pulse Error');
			Continue;
    end;
	  // Check Motion (if Motion Moving, skip)
    if DongaMotion.Motion[nMotionID].m_MotionStatus.IsInMotion then begin
			Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':InMotion:SKIP');
      Common.MotionLog(nJig, 'YModelPos : Is Moving');
			Continue;
    end;

    //-------------- Check if Y-Axis is already at Loading Position
    if DongaMotion.Motion[nMotionID].m_bModelPos and DongaMotion.IsSameMotionPos(DongaMotion.Motion[nMotionID].m_MotionStatus.CommandPos, Common.TestModelInfo2[nJig].CamYLoadPos) then begin
      CodeSite.Send('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+': bModelPos True Y-LoadPos');
    //DongaMotion.Motion[nMotionID].m_bModelPos  := True;
      DongaMotion.Motion[nMotionID].m_bUpdatePos := True;
			Common.MotionLog(nJig, 'YModelPos : Move Model Pos Done');
      ShowMotionStatus(nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');  //TBD:A1CHv3:MOTION? 
    //TBD:A1CHv3:MOTION?  DongaMotion.MotionStatus(nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
      UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,False); // for Alarm Off
      Continue;
    end;
	  // Check Motion (if Motion already Model Position, skip)
    if DongaMotion.Motion[nMotionID].m_bModelPos then begin
      if not DongaMotion.IsSameMotionPos(DongaMotion.Motion[nMotionID].m_MotionStatus.CommandPos, Common.TestModelInfo2[nJig].CamYLoadPos) then begin
        DongaMotion.Motion[nMotionID].m_bModelPos := False;
      end;{ else begin
        Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':bModelPos:SKIP');
        Continue;
      end;}
    end;
    if not Common.AlarmList[MotionAlarmNo.MODEL_POS_NG].bIsOn then begin
      DongaMotion.Motion[nMotionID].m_bModelPos := True; //2022-05-03 TBD???
    //tmrAutoModelPosMove[nMotionID].Enabled := False;	// !!!!
      ShowAlarmMotionControl(DefPocb.ALARM_RESERVED0{ShowOnly},False{bIsOn:Dummy});
      CodeSite.Send('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':AlarmCleared(MODEL_POS_NG):ModelPosMoveDone: StopTimer');
	  	Continue;
    end;
	  // Check Motion (if Motion already Moving Model Position, skip)
    case nMotionID of
      DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
        if pnlAlarmMotionStCh1Y.Caption = 'LoadPos Moving...' then begin
			    Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':MovingLoadPos:SKIP');
			    Continue;
        end;
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
        if pnlAlarmMotionStCh2Y.Caption = 'LoadPos Moving...' then begin
			    Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':MovingLoadPos:SKIP');
			    Continue;
        end;
      end;
    end;
    {$IFDEF HAS_MOTION_TILTING}
    // Check if T-Axis home searched
    case nMotionID of
      DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
        if not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_T].m_bHomeDone then begin
			    Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':Taxis:NotHomeSearch:SKIP');
			    Continue;
        end;
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
        if not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_T].m_bHomeDone then begin
			    Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':Taxis:NotHomeSearch:SKIP');
			    Continue;
        end;
      end;
    end;
		{$ENDIF}
    //-------------- Move Y Axis to Loading Position
    case nMotionID of
      DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
        pnlAlarmMotionStCh1Y.Color := clYellow; pnlAlarmMotionStCh1Y.Font.Color := clRed;
        pnlAlarmMotionStCh1Y.Caption := 'LoadPos Moving...';
        {$IFDEF SUPPORT_1CG2PANEL}
        if DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_MotionStatus.nSyncStatus = DefMotion.SyncLinkMaster then begin //2021-05-31
          pnlAlarmMotionStCh2Y.Color := clYellow; pnlAlarmMotionStCh2Y.Font.Color := clRed;
          pnlAlarmMotionStCh2Y.Caption := 'LoadPos Moving...';
        end;
        {$ENDIF}
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
        {$IFDEF SUPPORT_1CG2PANEL}
        if DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_MotionStatus.nSyncStatus = DefMotion.SyncLinkMaster then begin //2021-05-31
          Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':YAxis:SyncSlave:SKIP');
			    Continue;
        end;
        {$ENDIF}
        pnlAlarmMotionStCh2Y.Color := clYellow; pnlAlarmMotionStCh2Y.Font.Color := clRed;
        pnlAlarmMotionStCh2Y.Caption := 'LoadPos Moving...';
      end;
    end;
    Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+': MoveABS:start');
    Common.MotionLog(nJig, 'YModelPos : Move Model Pos Start ' + DongaMotion.Motion[nMotionID].m_MotionStatus.CommandPos.ToString);
 		DongaMotion.Motion[nMotionID].MoveABS(DefPocb.MSG_MODE_MOTION_MOVE_ABS,Common.TestModelInfo2[nJig].CamYLoadPos,Common.MotionInfo.YaxisVelocity);
    //TBD? frmTest1Ch[nJig].pnlJigStatus.Caption := 'Please wait for Y AXIS Setting';
    //TBD? frmTest1Ch[nJig].pnlJigStatus.Color := clRed;
    Common.CodeSiteSend('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':end');
  end;
  //
  if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_bModelPos) or
     (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bModelPos) then begin //2021-11-18 ALAAM_ON -> MotionStatus
//if Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_MODEL_POS_NG].bIsOn or
//   Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_MODEL_POS_NG].bIsOn then begin
     tmrYAxisModelPos.Enabled := True;
  end
  else begin
		CodeSite.Send('tmrYAxisModelPosTimer:'+IntToStr(nMotionID)+':AllModelPos:StopTimer');
  end;
end;

procedure TfrmMain.tmrZAxisErrorTimer(Sender: TObject);
begin

end;

{$IFDEF HAS_MOTION_CAM_Z}
procedure TfrmMain.tmrZAxisModelPosTimer(Sender: TObject);
var
  nJig      : Integer;
  nMotionID : Integer;
  MotionAlarmNo : TMotionAlarmNo;
begin
  if (DongaDio = nil) or (DongaMotion = nil) then Exit;
  // Check Mainter (if Mainter opened, skip)
  if (frmMainter <> nil) then begin
    //Common.CodeSiteSend('tmrYAxisModelPosTimer:Mainter:EXIT');
    Exit;
  end;

  // Check DIO (if EMO, skip)
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO)');
    Exit;
  end;
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO1_FRONT) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO1_FRONT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO2_RIGHT) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO2_RIGHT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO3_INNER_RIGHT) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO3_INNER_RIGHT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO4_INNER_LEFT) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO4_INNER_LEFT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO5_LEFT) <> 0) then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(DIO_EMO5_LEFT)');
    Exit;
  end;
{$ENDIF} //A2CH|A2CHv2, A2CHv3|A2CHv4

  // Check DIO (if EMO, skip)
  if Common.AlarmList[DefPocb.ALARM_DIO_EXTRA_EMS].bIsOn then begin
    Common.CodeSiteSend('tmrYAxisModelPosTimer:EXIT(EMS)');
    Exit;
  end;

  // Check Auto Mode (if Teach mode, skip)
  {$IFDEF POCB_A2CH}
  if Common.AlarmList[DefPocb.ALARM_DIO_TEACH_MODE_SWITCH].bIsOn then
  {$ELSE}
  if Common.AlarmList[DefPocb.ALARM_DIO_LEFT_SWITCH].bIsOn or Common.AlarmList[DefPocb.ALARM_DIO_RIGHT_SWITCH].bIsOn then
  {$ENDIF}
  begin
    //Common.CodeSiteSend('tmrZAxisModelPosTimer:TeachMode:EXIT');
    Exit;
  end;
  // Check DIO (if Left/Right Door Opened, skip)
  {$IFDEF POCB_A2CH}
  if not DongaDio.IsDoorClosed(False,-1) then
  {$ELSE}
  if not DongaDio.IsDoorClosed(True,-1) then
  {$ENDIF}
  begin
		Common.CodeSiteSend('tmrZAxisModelPosTimer:DIO:DOOR:EXIT');
    Common.MotionLog(DefPocb.CAM_1, 'ZModelPos : Door Open');
    Common.MotionLog(DefPocb.CAM_2, 'ZModelPos : Door Open');
		Exit;
  end;
  Common.CodeSiteSend('tmrZAxisModelPosTimer');
  //----------------------------------------------
  tmrZAxisModelPos.Enabled := False;	// !!!!
  for nJig := DefPocb.JIG_A to DefPocb.JIG_B do begin
    DongaMotion.GetChAxis2MotionID(nJig,MOTION_AXIS_Z,nMotionID);
    Common.CodeSiteSend('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+':start');
    Common.GetMotionAlarmNo(nMotionID,MotionAlarmNo);
    //-------------- Check Motion Status
		// Check Motion (if not Home Searched, skip)
    if (not DongaMotion.Motion[nMotionID].m_bHomeDone) then begin
			Common.CodeSiteSend('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+':NEED_HOME_SEARCH:SKIP');
      Common.MotionLog(nJig, 'ZModelPos : Not Initialized');
			Continue;
    end;
    // Check Motion (if Motion Control Disconneected, skip)
    if Common.AlarmList[MotionAlarmNo.DISCONNECTED].bIsOn then begin
			Common.CodeSiteSend('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+':DISCONNECTED:SKIP');
      Common.MotionLog(nJig, 'ZModelPos : Disconnected');
			Continue;
    end;
    // Check Motion (if Motion Alarm On, skip)
    if Common.AlarmList[MotionAlarmNo.SIG_ALARM_ON].bIsOn then begin
			Common.CodeSiteSend('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+':SIG_ALARM_ON:SKIP');
      Common.MotionLog(nJig, 'ZModelPos : Motion Alarm');
			Continue;
    end;
    // Check Motion (if Motion Unit/Pulse Error, skip)
    if Common.AlarmList[MotionAlarmNo.INVALID_UNITPULSE].bIsOn then begin
      Common.MotionLog(nJig, 'ZModelPos : Pulse Error');
			Common.CodeSiteSend('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+':INVALID_UNITPULSE:SKIP');
			Continue;
    end;
	  // Check Motion (if Motion Moving, skip)
    if DongaMotion.Motion[nMotionID].m_MotionStatus.IsInMotion then begin
      Common.MotionLog(nJig, 'ZModelPos : Is Moving');
			Common.CodeSiteSend('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+':InMotion:SKIP');
			Continue;
    end;
	  // Check Motion (if Motion already Model Position, skip)
    if DongaMotion.Motion[nMotionID].m_bModelPos then begin
      if not DongaMotion.IsSameMotionPos(DongaMotion.Motion[nMotionID].m_MotionStatus.CommandPos, Common.TestModelInfo2.CamZModelPos[nJig]) then begin
        DongaMotion.Motion[nMotionID].m_bModelPos := False;
      end;{ else begin
        Common.CodeSiteSend('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+':bModelPos:SKIP');
        Continue;
      end;}
    end;
	  // Check Motion (if Motion already Moving Model Position, skip)
    case nMotionID of
      DefMotion.MOTIONID_AxMC_STAGE1_Z: begin
        if pnlAlarmMotionStCh1Z.Caption = 'ModelPos Moving...' then begin
			    Common.CodeSiteSend('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+':MovingModelPos:SKIP');
			    Continue;
        end;
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_Z: begin
        if pnlAlarmMotionStCh2Z.Caption = 'ModelPos Moving...' then begin
			    Common.CodeSiteSend('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+':MovingModelPos:SKIP');
			    Continue;
        end;
      end;
    end;
    //-------------- Check if Z-Axis is already at Loading Position
    if DongaMotion.IsSameMotionPos(DongaMotion.Motion[nMotionID].m_MotionStatus.CommandPos, Common.TestModelInfo2.CamZModelPos[nJig]) then begin
      CodeSite.Send('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+': bModelPos True Z-LoadPos');
      DongaMotion.Motion[nMotionID].m_bModelPos  := True;
      DongaMotion.Motion[nMotionID].m_bUpdatePos := True;
			Common.MotionLog(nJig, 'ZModelPos : Move Model Pos Done');
      ShowMotionStatus(nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');  //TBD:A2CHv3:MOTION?
     //TBD:A2CHv3:MOTION?  DongaMotion.MotionStatus(nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
      UpdateAlarmStatus(MotionAlarmNo.MODEL_POS_NG,False); // for Alarm Off
      Continue;
    end;
    //-------------- Move Z Axis to Model Position
    case nMotionID of
      DefMotion.MOTIONID_AxMC_STAGE1_Z: begin
        pnlAlarmMotionStCh1Z.Color := clYellow; pnlAlarmMotionStCh1Z.Font.Color := clRed;
        pnlAlarmMotionStCh1Z.Caption := 'ModelPos Moving...';
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_Z: begin
        pnlAlarmMotionStCh2Z.Color := clYellow; pnlAlarmMotionStCh2Z.Font.Color := clRed;
        pnlAlarmMotionStCh2Z.Caption := 'ModelPos Moving...';
      end;
    end;
    Common.CodeSiteSend('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+': MoveABS:start');
    Common.MotionLog(nJig, 'ZModelPos : Move Model Pos Start ' + DongaMotion.Motion[nMotionID].m_MotionStatus.CommandPos.ToString);
 		DongaMotion.Motion[nMotionID].MoveABS(DefPocb.MSG_MODE_MOTION_MOVE_ABS,Common.TestModelInfo2.CamZModelPos[nJig],Common.MotionInfo.ZaxisVelocity);
    //TBD? frmTest1Ch[nJig].pnlJigStatus.Caption := 'Please wait for Z AXIS Setting';
    //TBD? frmTest1Ch[nJig].pnlJigStatus.Color := clRed;
    Common.CodeSiteSend('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+':end');
  end;
  //
  if (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Z].m_bModelPos) or
     (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Z].m_bModelPos) then begin //2021-11-18 ALAAM_ON -> MotionStatus
//if Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Z_MODEL_POS_NG].bIsOn or
//   Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Z_MODEL_POS_NG].bIsOn then begin
     tmrZAxisModelPos.Enabled := True;
  end
  else begin
		CodeSite.Send('tmrZAxisModelPosTimer:'+IntToStr(nMotionID)+':AllModelPos:StopTimer');
  end;
end;
{$ENDIF} //HAS_MOTION_CAM_Z

{$IFDEF HAS_ROBOT_CAM_Z}
procedure TfrmMain.tmrAutoRobotMoveModelTimer(Sender: TObject);
var
  nRobot : Integer;
  RobotAlarmNo : TRobotAlarmNo;
begin
  if (DongaDio = nil) or (DongaMotion = nil) then Exit;
  // Check Mainter (if Mainter opened, skip)
  if (frmMainter <> nil) then begin
  //Common.CodeSiteSend('tmrAutoRobotMoveModel:Mainter:EXIT');
    Exit;
  end;

  // Check DIO (if EMS, skip)
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO1_FRONT) <> 0) then begin
    Common.CodeSiteSend('tmrAutoRobotMoveModel:EXIT(DIO_EMO1_FRONT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO2_RIGHT) <> 0) then begin
    Common.CodeSiteSend('tmrAutoRobotMoveModel:EXIT(DIO_EMO2_RIGHT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO3_INNER_RIGHT) <> 0) then begin
    Common.CodeSiteSend('tmrAutoRobotMoveModel:EXIT(DIO_EMO3_INNER_RIGHT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO4_INNER_LEFT) <> 0) then begin
    Common.CodeSiteSend('tmrAutoRobotMoveModel:EXIT(DIO_EMO4_INNER_LEFT)');
    Exit;
  end;
  if ((DongaDio.m_nDIValue and DefDio.MASK_IN_EMO5_LEFT) <> 0) then begin
    Common.CodeSiteSend('tmrAutoRobotMoveModel:EXIT(DIO_EMO5_LEFT)');
    Exit;
  end;

  // Check DIO (if EMS, skip)
  if Common.AlarmList[DefPocb.ALARM_DIO_EXTRA_EMS].bIsOn then begin
    Common.CodeSiteSend('tmrAutoRobotMoveModel:EXIT(EMS)');
    Exit;
  end;

  {$IFDEF SUPPORT_1CG2PANEL}
  // Check CamZone Partition and InnerDoor
  if not Common.SystemInfo.UseAssyPOCB then begin
    if not DongaDio.CheckCamZonePartDoor(False{bIsOpen}) then begin
      Common.CodeSiteSend('tmrAutoRobotMoveModel:ASSY:CamZonePartitionInnerDoor:NotClosed:SKIP');
      Exit;
    end;
  end
  else begin
    if not DongaDio.CheckCamZonePartDoor(True{bIsOpen}) then begin
      Common.CodeSiteSend('tmrAutoRobotMoveModel:NotASSY:CamZonePartInnerDoor:NotOpened:SKIP');
      Exit;
    end;
    // Check CH1|CH2 Swtitch is Auto Mode (if Teach mode, skip)
    if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) or
      ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) then begin
      Common.CodeSiteSend('tmrAutoRobotMoveModel:CH1|CH2:NotAutoMode:SKIP');
      Exit;
    end;
    // Check CH1|CH2 Doors Opened
    if not DongaDio.IsDoorClosed(True{bCheckUnderDoor},-1) then begin
      Common.CodeSiteSend('tmrAutoRobotMoveModel:CH1|CH2:MaintDoor1|2:Open:SKIP');
      Exit;
    end;
  end;
  {$ENDIF} //SUPPORT_1CG2PANEL

  //-------------- Check Robot Status
  if not DongaRobot.m_bRobotControlStarted then begin
    Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:bRobotControlStarted(False):SKIP');
    Exit;
  end;

  //---------------------------------------
  tmrAutoRobotMoveModel.Enabled := False; // !!!!
  for nRobot := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_CH2 do begin
    {$IFNDEF SIMULATOR_ROBOT}
  //Common.CodeSiteSend('tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':start');
    {$ENDIF}
    case nRobot of
      DefRobot.ROBOT_CH1: begin
        // Check CH1 Swtitch is Auto Mode (if Teach mode, skip)
        if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) then begin
          Common.CodeSiteSend('tmrAutoRobotMoveModel:CH1:NotAutoMode:SKIP');
          Continue;
        end;
        // Check CH1 Doors Opened
        if not DongaDio.IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_1) then begin
          Common.CodeSiteSend('tmrAutoRobotMoveModel:CH1:MaintDoor1|2:Open:SKIP');
          Continue;
        end;
      end;
      DefRobot.ROBOT_CH2: begin
        // Check CH2 Swtitch is Auto Mode (if Teach mode, skip)
        if ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) = 0) or ((DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) then begin
          Common.CodeSiteSend('tmrAutoRobotMoveModel:CH2:NotAutoMode:SKIP');
          Continue;
        end;
        // Check CH2 Doors Opened
        if not DongaDio.IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_2) then begin
          Common.CodeSiteSend('tmrAutoRobotMoveModel:CH2:MaintDoor1|2:Open:SKIP');
          Continue;
        end;
      end;
    end;
    //
    if (not DongaRobot.m_bConnectedModbus[nRobot]) then begin
      {$IFNDEF SIMULATOR_ROBOT}
      Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':ModBusDisconnected:SKIP');
      {$ENDIF}
      Continue;
    end;
    //
    if (not DongaRobot.Robot[nRobot].m_bModbusFirstReadDone) then begin
      Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':Not-ModbusFirstReadDone:SKIP');
      Continue;
    end;
    //
    with DongaRobot.Robot[nRobot].m_RobotStatusCoord do begin
      // Robot Status - FatalError
      if RobotStatus.FatalError then begin
        Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':ModBus:FatalError:SKIP');
        Continue;
      end;
      // Robot Status - EStop
      if RobotStatus.EStop then begin
        Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':ModBus:EStop:SKIP');
        Continue;
      end;
      // Robot Status - AutoMode/ManualMode
      if RunMode <> DefRobot.ROBOT_TM_MB_RUNMODE_AUTO then begin
        Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':ModBus:NotAutoMode:SKIP');
        Continue;
      end;
      // Robot Extra - CannotMove  //A2CHv3:2021-03-06
      if RobotExtra.CannotMove then begin
        Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':ModBus:CannotMove:SKIP');
        Continue;
      end;
      //
      if RobotStatus.ProjectEditing then begin
        Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':ModBus:ProjectEditing:SKIP');
        Continue;
      end;
      //
    //if RobotStatus.GetControl then begin
    //  Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':ModBus:GetControl:SKIP');
    //  Continue;
    //end;
      //
      if (RobotLight <> ROBOT_TM_LIGHT_03_SolidBlue_StandbyInAutoMode) and (RobotLight <> ROBOT_TM_LIGHT_04_FlashingBlue_AutoMode) then begin
        Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':ModBus:RobotLight(not 03|04):SKIP');
        Continue;
      end;
      //
      if (not RobotStatus.ProjectRunning) or RobotStatus.ProjectPause then begin
          //-------------- Move to HOME/MODEL
        if DongaDio.m_IsOnDioRobotCtl[nRobot] then begin
          Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':OnDioCtl(Pause->Play):SKIP');
          Continue;
        end;
        Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+'DioCtl(Pause->Play)');
        DongaDio.RobotDioControl(nRobot,MakePlay);
        Continue;
      end;

      // After RobotDioControl(nRobot,MakePlay) !!!
      if (not DongaRobot.m_bConnectedListenNode[nRobot]) then begin
        Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':ListenNodeDisconnected:SKIP');
        Continue;
      end;
      //
      if (not DongaRobot.Robot[nRobot].m_bListenNodeFirstReadyDone) then begin
        Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':Not-ListenNodeFirstReadyDone:SKIP');
        Continue;
      end;

      // Set HomeDone if HOME or MODEL
      if (CoordState = coordHome) or (CoordState = coordModel) then begin
        DongaRobot.Robot[nRobot].m_bHomeDone := True;
      end;

      //
      if (CoordState <> coordModel) then begin
        if DongaRobot.Robot[nRobot].m_bIsOnListenNodeCmd then begin
          Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':OnRobotCmdAckWait:SKIP');
          Continue;
        end;
        //
        Common.GetRobotAlarmNo(nRobot,RobotAlarmNo);
        if Common.AlarmList[RobotAlarmNo.HOME_COORD_MISMATCH].bIsOn then begin
          if (DongaRobot.Robot[nRobot].m_RobotStatusCoord.CoordState <> coordUndefined) then begin
            UpdateAlarmStatus(RobotAlarmNo.HOME_COORD_MISMATCH,False{bIsAlarmOn});
          end
          else begin
           Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':HOME_COORD_MISMATCH:SKIP');
            Continue;
           end;
        end;
        if Common.AlarmList[RobotAlarmNo.MODEL_COORD_MISMATCH].bIsOn then begin
          if (DongaRobot.Robot[nRobot].m_RobotStatusCoord.CoordState = coordModel) then begin
            UpdateAlarmStatus(RobotAlarmNo.MODEL_COORD_MISMATCH,False{bIsAlarmOn});
          end
          else begin
            Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':MODEL_COORD_MISMATCH:SKIP');
            Continue;
          end;
        end;
        if Common.AlarmList[RobotAlarmNo.STANDBY_COORD_MISMATCH].bIsOn then begin
          if (DongaRobot.Robot[nRobot].m_RobotStatusCoord.CoordState <> coordUndefined) then begin
            UpdateAlarmStatus(RobotAlarmNo.STANDBY_COORD_MISMATCH,False{bIsAlarmOn});
          end
          else begin
            Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':STANDBY_COORD_MISMATCH:SKIP');
            Continue;
          end;
        end;
        //
        if not (DongaRobot.Robot[nRobot].m_RobotStatusCoord.CoordState in [coordHome, coordModel]) then begin
          SendRobotMoveCmd(nRobot,ROBOT_TM_CMD_MOVE_TO_HOME);
          Continue;
        end;
        // Move to Model
        {$IFDEF SUPPORT_1CG2PANEL}
        if not Common.SystemInfo.UseAssyPOCB then begin
        {$ENDIF}
          SendRobotMoveCmd(nRobot,ROBOT_TM_CMD_MOVE_TO_MODEL);
        {$IFDEF SUPPORT_1CG2PANEL}
        end
        else begin  // for ASSY-POCB, Move to Model if both CH1 and CH2 are HomeDone
          if DongaRobot.Robot[DefRobot.ROBOT_CH1].m_bHomeDone and DongaRobot.Robot[DefRobot.ROBOT_CH2].m_bHomeDone then begin
              SendRobotMoveCmd(nRobot,ROBOT_TM_CMD_MOVE_TO_MODEL);
          end
          else begin
            Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':WaitBothChHomeDone:SKIP');
          end;
        end;
        {$ENDIF} 
        Continue;
      end;
      Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':ModelMovedDone:SKIP');
    end;
    Common.CodeSiteSend('<FrmMain> tmrAutoRobotMoveModel:CH'+IntToStr(nRobot+1)+':StartupMoving:end');
  end;
  //
  if (DongaRobot.Robot[DefRobot.ROBOT_CH1].m_RobotStatusCoord.coordState <> coordModel) or
     (DongaRobot.Robot[DefRobot.ROBOT_CH2].m_RobotStatusCoord.coordState <> coordModel)
  then begin
    tmrAutoRobotMoveModel.Enabled := True;
  end;

  //
  if not tmrAutoRobotMoveModel.Enabled then begin
    CodeSite.Send('<FrmMain> tmrAutoRobotMoveModel:AllRobotMoveModelDone:StopTimer');
  //frmTest1Ch[0].ResetChGui(0);
  //frmTest1Ch[1].ResetChGui(0);
  end;
end;

procedure TfrmMain.SendRobotMoveCmd(nRobot: Integer; nCmdId: Integer);  //A2CHv3:ROBOT
begin
  Common.ThreadTask(procedure begin
    Common.CodeSiteSend('<FrmMain> SendRobotMoveCmd: ROBOT'+IntToStr(nRobot+1)+': nCmdId('+IntToStr(nCmdId)+')');
    case nCmdId of
    //ROBOT_TM_CMD_READY:
      ROBOT_TM_CMD_MOVE_TO_HOME:    DongaRobot.Robot[nRobot].MoveHOME;
      ROBOT_TM_CMD_MOVE_TO_MODEL:   DongaRobot.Robot[nRobot].MoveMODEL;
      ROBOT_TM_CMD_MOVE_TO_STANDBY: DongaRobot.Robot[nRobot].MoveSTANDBY;
    //ROBOT_TM_CMD_MOVE_COMMAND:
    //ROBOT_TM_CMD_MOVE_TO_RELCOORD:
    end;
  end);
end;
{$ENDIF} //HAS_ROBOT_CAM_Z

procedure TfrmMain.tmrEQCCTimer(Sender: TObject);
begin
  //Common.MLog(DefPocb.SYS_LOG,'TfrmMain.tmrEQCCTimer');
  //TBD:LENS:MES? DongaGmes.SendHostEqcc;
end;

procedure TfrmMain.tmrMESConnTimer(Sender: TObject);
begin
{
  //Common.MLog(DefPocb.SYS_LOG,'TfrmMain.tmrMESConnTimer');
  if pnlMESConn.Color = clRed then begin
    if Common.SystemInfo.UIType = DefPocb.UI_WIN10_BLACK then begin
      pnlMESConn.Color := clBlack;
    end
    else begin
      pnlMESConn.Color := clBtnFace;
    end;
  end
  else begin
    pnlMESConn.Color   := clRed;
  end;
  }
end;

procedure TfrmMain.tmrCamConnCheckTimer(Sender: TObject);
var
  nCh : Integer; // nCh = nJig = nCam
begin
  if (Common = nil) or (CameraComm = nil) then Exit;

  tmrCamConnCheck.Enabled := False;
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    case DongaDio.m_nAutoFlow[nCh] of
      DefDio.IO_AUTO_FLOW_NONE,
      DefDio.IO_AUTO_FLOW_READY,
      DefDio.IO_AUTO_FLOW_FRONT,
    //DefDio.IO_AUTO_FLOW_SHUTTER_DOWN,
    //DefDio.IO_AUTO_FLOW_CAMERA,
      DefDio.IO_AUTO_FLOW_SHUTTER_UP,
      DefDio.IO_AUTO_FLOW_BACK,
      DefDio.IO_AUTO_FLOW_UNLOAD: begin
        CameraComm.CheckClientConnect(nCh);
      end;
    end;
  end;
  tmrCamConnCheck.Enabled := True;
end;

procedure TfrmMain.tmrTowerLampRedOnOffTimer(Sender: TObject);  //2019-04-16
begin
  tmrTowerLampRedOnOff.Enabled := False;
  if (Common = nil) or (DongaDio = nil) then Exit;
  // LGD요구사항.1: Home Search and/or Model Pos 이동 중인 경우, Green 점멸 (0.5초 주기 On/Off)
  // LGD요구사항.2: EMO & Light Curtain(MC1/MC2 Down)인 경우, Red On (점멸 아님)
  // LGD요구사항.3: 기타 DIO 알람인 경우, Red 점멸 (0.5초 주기 On/Off)
  if Common.AlarmList[DefPocb.ALARM_DIO_MC1].bIsOn or Common.AlarmList[DefPocb.ALARM_DIO_MC2].bIsOn
//{$IFDEF HAS_DIO_Y_AXIS_MC} //2023-12-07
//   or (Common.AlarmList[DefPocb.ALARM_DIO_Y_AXIS_MC_CH1].bIsOn and Common.AlarmList[DefPocb.ALARM_DIO_Y_AXIS_MC_CH2].bIsOn)
//{$ENDIF}
{$IF  Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
     or Common.AlarmList[DefPocb.ALARM_DIO_EMO].bIsOn
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
     or Common.AlarmList[DefPocb.ALARM_DIO_EMO1_FRONT].bIsOn
     or Common.AlarmList[DefPocb.ALARM_DIO_EMO2_RIGHT].bIsOn
     or Common.AlarmList[DefPocb.ALARM_DIO_EMO3_INNER_RIGHT].bIsOn
     or Common.AlarmList[DefPocb.ALARM_DIO_EMO4_INNER_LEFT].bIsOn
     or Common.AlarmList[DefPocb.ALARM_DIO_EMO5_LEFT].bIsOn
{$ENDIF}
     or Common.AlarmList[DefPocb.ALARM_DIO_EXTRA_EMS].bIsOn
  then Exit;
  if not Common.m_bAlarmOn then Exit;
  //
  DongaDio.SetDio(DefDio.OUT_LAMP_RED);
  tmrTowerLampRedOnOff.Enabled := True;
end;

//******************************************************************************
// procedure/function: WMCopyData
//    - MSG_TYPE_CAMERA
//        MSG_MODE_SEND_RSTDONE
//        MSG_MODE_DISPLAY_ALARM
//        MSG_MODE_SHARED_FOLDER_STATUS
//    - MSG_TYPE_DIO
//        MSG_MODE_DISPLAY_ALARM
//    - MSG_TYPE_PG
//        MSG_MODE_DISPLAY_CONNECTION
//    - MSG_TYPE_SWITCH
//        MSG_MODE_DISPLAY_CONNECTION
//    - MSG_TYPE_LOGIC
//        MSG_MODE_WORK_DONE
//        MSG_MODE_MAKE_SUMMARY_CSV
//  //- MSG_TYPE_JIG
//        MSG_MODE_DISPLAY_ALARM (from frmTest1Ch)
//  //    MSG_MODE_WORKING
//******************************************************************************

procedure TfrmMain.WMCopyData(var Msg: TMessage);
var
  nType, nMode, nCh, nParam, nParam1, nParam2, nParam3 : Integer;
  nJig, nPg, nIonChIdx : Integer;
  nTemp: Integer;
  sMsg, sHeader, sData : string;
  bIsAlarmOn  : Boolean;
  nAlarmNo    : Integer;
  sNgMsg, sFwVer : string;
begin
  nType := PMainGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.MsgType;
  nCh   := PMainGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
  sNgMsg := '';
  case nType of
    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_CAMERA : begin
      nMode := PMainGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_ALARM : begin
          sMsg := PMainGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
          case nCh of
            DefPocb.CAM_1: begin
              {if (not Common.AlarmList[DefPocb.ALARM_CAMERA_PC1_DISCONNECTED].bIsOn) then} ShowNgMessage(sMsg);
            end;
            DefPocb.CAM_2: begin
              {if (not Common.AlarmList[DefPocb.ALARM_CAMERA_PC2_DISCONNECTED].bIsOn) then} ShowNgMessage(sMsg);
            end;
            else
              Exit;
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_SHARED_FOLDER_STATUS : begin
          nTemp := PMainGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;
          case nTemp of   // <Param1>   1: OK , 2: NG
            1: begin
              ledSysInfoSharefolder.Value := True;
              pnlSysinfoShareFolder.Color := clLime;
              pnlSysinfoShareFolder.Font.Color := clBlack;
            end;
            2: begin
              ledSysInfoSharefolder.Value := False;
              pnlSysinfoShareFolder.Color := clRed;
              pnlSysinfoShareFolder.Font.Color := clYellow;
            end;
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_SEND_RSTDONE : begin
          Parallel.Async( procedure begin
            CameraComm.SendCmd(nCh,'RSTDONE');
          end);
        { for i := DefYT.CH1 to DefYT.MAX_CH do begin
            if Logic[i].m_InsStatus = IsRun then bTemp := False;
          end;
          if bTemp then  m_StartStatus := IsPowerOffReady; }
        end;
      end;
    end;
    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_DIO: begin
			Common.MLog(DefPocb.SYS_LOG,'<FrmMain> TYPE_DIO, MODE_DISPLAY_ALARM');
      nMode  := PMainGuiDioData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nParam := PMainGuiDioData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;
      sMsg   := PMainGuiDioData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_ALARM : begin
        //case nParam of
        //  DefPocb.ALARM_DIO_EXTRA_EMS: begin ShowEMSAlarmMsg(''); btnExitClick(nil); end; // Exit!!!  //2021-03-11 DELETE
        //end;
        end;
        DefPocb.MSG_MODE_FLOW_STOP : begin
          tmrAutoHomeSearch.Enabled := False;
        end;
        DefPocb.MSG_MODE_DISPLAY_STATUS : begin
          if (PnlAlarmMotionControl.Visible) then begin
            if (sMsg.Length > 0) then begin
              sMsg := FormatDateTime('hh:mm:ss.zzz  ',Now) + '<DIO> ' + sMsg; //2019-03-29
            //CodeSite.Send('ShowMotionStatus:mmAlarmOpMsg'+sMsg); //2019-04-03
              mmAlarmOpMsg.SelAttributes.Color := clRed;         //2019-03-29 //2019-04-03 TBD:ALARM:UI:RichEdit?
              mmAlarmOpMsg.DisableAlign;
              mmAlarmOpMsg.Lines.Add(sMsg);
              mmAlarmOpMsg.Perform(EM_SCROLL,SB_LINEDOWN,0);
              mmAlarmOpMsg.EnableAlign;
            end;
          end;
        end;
      end;
    end;
    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_PG : begin
      nMode := PMainGuiPgData (PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nPg   := PMainGuiPgData (PCopyDataStruct(Msg.LParam)^.lpData)^.PgNo;
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_CONNECTION : begin
          sNgMsg   := ''; // dummy
          nParam  := PMainGuiPgData (PCopyDataStruct(Msg.LParam)^.lpData)^.Param;
          sMsg    := string(PMainGuiPgData (PCopyDataStruct(Msg.LParam)^.lpData)^.sMsg);
          case nParam of
            0, 1, 2 : begin
              if (nParam = 2) then bIsAlarmOn := True
              else                 bIsAlarmOn := False;
              if (nPg = DefPocb.PG_1) then nAlarmNo := DefPocb.ALARM_CH1_PG_DISCONNECTED
              else                         nAlarmNo := DefPocb.ALARM_CH2_PG_DISCONNECTED;
              if (bIsAlarmOn) and (not Common.AlarmList[nAlarmNo].bIsOn) then begin  //2019-04-17 (이미 알람발생상태인 경우, NG 메시지 출력하지 않음)
                sNgMsg := 'Ch'+IntToStr(nPg+1)+' PG Board Communication NG';
                {if (not Common.AlarmList[nAlarmNo].bIsOn) then} ShowNgMessage(sNgMsg);
              end;
			        UpdateAlarmStatus(nAlarmNo,bIsAlarmOn);
              //
              if (nParam = 1{PG_Version}) then begin
                if (Common.TestModelInfo2[nPg].PgFwVer <> '') then begin  //2019-04-19 ALARM:FW_VERSION_MISMATCH
                  sFwVer := sMsg;
                  if (nPg = DefPocb.PG_1) then nAlarmNo := DefPocb.ALARM_CH1_PG_VERSION_MISMATCH
                  else                         nAlarmNo := DefPocb.ALARM_CH2_PG_VERSION_MISMATCH;
                  if (sFwVer <> Common.TestModelInfo2[nPg].PgFwVer) then begin
                    sNgMsg := 'Ch'+IntToStr(nPg+1)+' PG F/W Version Mismatch (PG:'+sFwVer+' ,Model:'+Common.TestModelInfo2[nPg].PgFwVer+')';
                    {if (not Common.AlarmList[nAlarmNo].bIsOn) then} ShowNgMessage(sNgMsg);
                    UpdateAlarmStatus(nAlarmNo,True{bIsAlarmOn});
                  end
                  else begin
                    UpdateAlarmStatus(nAlarmNo,False{bIsAlarmOn});
                  end;
                end;
                Common.SendModelData(nPg,0{PG}); //TBD:MERGE?
              end;
            end;
            10, 11, 12, 13 : begin //13:QSPI ModelCrc
              if (nParam = 12) then bIsAlarmOn := True
              else                  bIsAlarmOn := False;
              if (nPg = DefPocb.PG_1) then nAlarmNo := DefPocb.ALARM_CH1_SPI_DISCONNECTED
              else                         nAlarmNo := DefPocb.ALARM_CH2_SPI_DISCONNECTED;
              if (bIsAlarmOn) and (not Common.AlarmList[nAlarmNo].bIsOn) then begin  //2019-04-17 (이미 알람발생상태인 경우, NG 메시지 출력하지 않음)
                sNgMsg := 'Ch'+IntToStr(nPg+1)+' SPI Board Communication NG';
                {if (not Common.AlarmList[nAlarmNo].bIsOn) then} ShowNgMessage(sNgMsg);
              end;
			        UpdateAlarmStatus(nAlarmNo,bIsAlarmOn);
              //
              if (nParam = 11{SPI_Version}) then begin
                if (Common.TestModelInfo2[nPg].SpiFwVer <> '') then begin  //2019-04-19 ALARM:FW_VERSION_MISMATCH
                  sFwVer := sMsg;
                  if (nPg = DefPocb.PG_1) then nAlarmNo := DefPocb.ALARM_CH1_SPI_VERSION_MISMATCH
                  else                         nAlarmNo := DefPocb.ALARM_CH2_SPI_VERSION_MISMATCH;
                  if (sFwVer <> Common.TestModelInfo2[nPg].SpiFwVer) then begin
                    sNgMsg := 'Ch'+IntToStr(nPg+1)+' SPI F/W Version Mismatch (SPI:'+sFwVer+' ,Model:'+Common.TestModelInfo2[nPg].SpiFwVer+')';
                    {if (not Common.AlarmList[nAlarmNo].bIsOn) then} ShowNgMessage(sNgMsg);
                    UpdateAlarmStatus(nAlarmNo,True{bIsAlarmOn});
                  end
                  else begin
                    UpdateAlarmStatus(nAlarmNo,False{bIsAlarmOn});
                  end;
                end;
                //
                Common.SendModelData(nPg,1{SPI}); //TBD:MERGE?
              end;
            end;
            else begin
              Exit;
            end;
          end;
        end;
      end;
    end;
    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_SWITCH : begin
      nMode := PGuiSwitch(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nJig  := PGuiSwitch(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
      nParam := PGuiSwitch(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;
      sMsg  := string(PGuiSwitch(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg);
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_CONNECTION : begin
          nAlarmNo := DefPocb.ALARM_RESERVED0;
          sNgMsg   := '';
          bIsAlarmOn := False;
          case nJig of
            DefPocb.JIG_A: begin
              pnlSysInfoRcb1.Caption := sMsg;
              case nParam of   // <Param1>   0: disconnect, 1: Connect , 2: NONE
                0 : begin
                  ledSysInfoRcb1.FalseColor := clRed;
                  ledSysInfoRcb1.Value      := False;
                  pnlSysInfoRcb1.Color      := clRed;
                  pnlSysInfoRcb1.Font.Color := clYellow;
                  bIsAlarmOn := True;
                  nAlarmNo := DefPocb.ALARM_SWITCHBUTTON1_NOT_CONNECTED;
                  sNgMsg := 'Ch'+IntToStr(nJig+1)+' Switch Button NG'+#13+#10+'    - Check Switch Button Connection';
                  {if (not Common.AlarmList[nAlarmNo].bIsOn) then} ShowNgMessage(sNgMsg);
                end;
                1 : begin
                  ledSysInfoRcb1.TrueColor  := clLime;
                  ledSysInfoRcb1.Value      := True;
                  pnlSysInfoRcb1.Color      := clLime;
                  pnlSysInfoRcb1.Font.Color := clBlack;
                  bIsAlarmOn := False;
                  nAlarmNo := DefPocb.ALARM_SWITCHBUTTON1_NOT_CONNECTED;
                end;
                2 : begin
                  ledSysInfoRcb1.FalseColor := clGray;
                  ledSysInfoRcb1.Value      := False;
                  pnlSysInfoRcb1.Color      := clGray;
                  pnlSysInfoRcb1.Font.Color := clBlack;
                  bIsAlarmOn := True;
                end;
              end;
            end;
            DefPocb.JIG_B: begin
              pnlSysInfoRcb2.Caption := sMsg;
              case nParam of   // <Param1>   0: disconnect, 1: Connect , 2: NONE
                0 : begin
                  ledSysInfoRcb2.FalseColor := clRed;
                  ledSysInfoRcb2.Value      := False;
                  pnlSysInfoRcb2.Color      := clRed;
                  pnlSysInfoRcb2.Font.Color := clYellow;
                  bIsAlarmOn := True;
                  nAlarmNo := DefPocb.ALARM_SWITCHBUTTON1_NOT_CONNECTED;
                  sNgMsg := 'Ch'+IntToStr(nJig+1)+' Switch Button NG'+#13+#10+'    - Check Switch Button Connection';
                  {if (not Common.AlarmList[nAlarmNo].bIsOn) then} ShowNgMessage(sNgMsg);
                end;
                1 : begin
                  ledSysInfoRcb2.TrueColor  := clLime;
                  ledSysInfoRcb2.Value      := True;
                  pnlSysInfoRcb2.Color      := clLime;
                  pnlSysInfoRcb2.Font.Color := clBlack;
                  bIsAlarmOn := False;
                  nAlarmNo := DefPocb.ALARM_SWITCHBUTTON1_NOT_CONNECTED;
                end;
                2 : begin
                  ledSysInfoRcb2.FalseColor := clGray;
                  ledSysInfoRcb2.Value      := False;
                  pnlSysInfoRcb2.Color      := clGray;
                  pnlSysInfoRcb2.Font.Color := clBlack;
                  bIsAlarmOn := True;
                end;
                else begin
                  Exit;
                end;
              end;
            end;
          end;
          if nAlarmNo <> DefPocb.ALARM_RESERVED0 then UpdateAlarmStatus(nAlarmNo,bIsAlarmOn,sNgMsg); //0:Disconnected, 1:Connected
        end;
      end;
    end;

    //--------------------------------------------------------------------------
    {
      RGuiLogicData = packed record
        MsgType : Integer;
        Channel : Integer;
        Mode    : Integer;
        DataLen : Integer;
        Data    : array[1..DefPocb.MAX_GUI_DATA_CNT] of Integer;
        Msg     : string[50];
      end;
    }
    DefPocb.MSG_TYPE_LOGIC:  begin    // from LogicPocb
      nMode := PGuiLogic2Main(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nCh   := PGuiLogic2Main(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_WORK_DONE : begin   //TBD:TO-BE-DELETED? (실제로 수행되는 루틴 없음)
        end;
        //--------------------------------
        DefPocb.MSG_MODE_MAKE_SUMMARY_CSV : begin
          Logic[nCh].GetCsvData(sheader, sData);
          Common.MakeSummaryCsvLog(nCh, sheader, sData);
          Common.MakeApdrCsvLog(nCh, Logic[nCh].m_Inspect.ApdrCsvHeader, Logic[nCh].m_Inspect.ApdrCsvValues);  //2022-08-01
        end;
        //--------------------------------
        DefPocb.MSG_MODE_SEND_CAM_TSTOP : begin  //2018-12-12 CAM:TSTOP
          Parallel.Async( procedure begin
            CameraComm.SendCmd(nCh,'TSTOP');
          end);
        end;
      end;
    end;

    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_HOST : begin
      nCh   := PSyncHost(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
      nMode := PSyncHost(PCopyDataStruct(Msg.LParam)^.lpData)^.MsgMode;
    //bTemp := PSyncHost(PCopyDataStruct(Msg.LParam)^.lpData)^.bError;
      sMsg  := string(PSyncHost(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg);
    //nJig  := nCh div DefPocb.JIGCH_CNT;
      case nMode of
        DefGmes.MES_PCHK : begin
					//Common.MLog(nCh,'<FrmMain> TYPE_HOST, MES_PCHK: Ch'+IntToStr(nCh+1),DefPocb.DEBUG_LEVEL_INFO);
          DongaGmes.SendHostPchk(Logic[nCh].m_Inspect.SerialNo, nCh);
				end;
        DefGmes.MES_EICR : begin
					//Common.MLog(nCh,'<FrmMain> TYPE_HOST, MES_EICR: Ch'+IntToStr(nCh+1),DefPocb.DEBUG_LEVEL_INFO);
          {$IFDEF SITE_LENSVN}
          DongaGmes.SendHostEicr(Logic[nCh].m_Inspect.SerialNo, nCh);
          {$ELSE}
          DongaGmes.SendHostEicr(Logic[nCh].m_Inspect.SerialNo, nCh, ''{CarrierId});
          {$ENDIF}
        end;
      {$IFDEF USE_EAS}
        {$IFDEF USE_MES_APDR}
        DefGmes.MES_APDR : begin  //2019-06-25 EAS
					//Common.MLog(nCh,'<FrmMain> TYPE_HOST, MES_APDR: Ch'+IntToStr(nCh+1),DefPocb.DEBUG_LEVEL_INFO);
          DongaGmes.SendHostApdr(Logic[nCh].m_Inspect.SerialNo, nCh);
        end;
        {$ENDIF}
        DefGmes.EAS_APDR : begin  //2019-06-25 EAS
					//Common.MLog(nCh,'<FrmMain> TYPE_HOST, EAS_APDR: Ch'+IntToStr(nCh+1),DefPocb.DEBUG_LEVEL_INFO);
          DongaGmes.SendEasApdr(Logic[nCh].m_Inspect.SerialNo, nCh);
        end;
      {$ENDIF}
        DefGmes.MES_INS_PCHK : begin
			  	//Common.MLog(nCh,'<FrmMain> TYPE_HOST, MES_INS_PCHK: Ch'+IntToStr(nCh+1),DefPocb.DEBUG_LEVEL_INFO);
          {$IFDEF SITE_LENSVN}
          DongaGmes.SendHostPchk(Logic[nCh].m_Inspect.SerialNo, nCh);
          {$ELSE}
          DongaGmes.SendHostIns_Pchk(Logic[nCh].m_Inspect.SerialNo, nCh);
          {$ENDIF}
			  end;
        DefGmes.MES_RPR_EIJR : begin
			  	//Common.MLog(nCh,'<FrmMain> TYPE_HOST, MES_RPR_EIJR: Ch'+IntToStr(nCh+1),DefPocb.DEBUG_LEVEL_INFO);
          {$IFDEF SITE_LENSVN}
          DongaGmes.SendHostEicr(Logic[nCh].m_Inspect.SerialNo, nCh);
          {$ELSE}
          DongaGmes.SendHostRpr_Eijr(Logic[nCh].m_Inspect.SerialNo, nCh, ''{CarrierId});
          {$ENDIF}
        end;
      end;
		end;

    //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_JIG : begin
      nMode   := PGuiJigData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;      // DISPLAY_ALARM
      nCh     := PGuiJigData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;   // - dummy
      nParam1 := PGuiJigData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param1;    // - alarmNo
      nParam2 := PGuiJigData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param2;    // - 0:Off,1:On
    //nParam3 := PGuiJigData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param3;    // - dummy
      sMsg    := PGuiJigData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
    //nJig    := nCh div DefPocb.JIGCH_CNT;
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_ALARM: begin
          case nParam2 of   // 0:Off, 1:On
            0:   bIsAlarmOn := False;
            else bIsAlarmOn := True;
          end;
          UpdateAlarmStatus(nParam1{alarmNo},bIsAlarmOn,sMsg);
          if bIsAlarmOn then begin
            case nParam1 of  // alarmNo
              DefPocb.ALARM_CH1_MOTION_Y_SIG_ALARM_ON: begin
                UpdateAlarmStatus(DefPocb.ALARM_CH1_MOTION_Y_NEED_HOME_SEARCH,bIsAlarmOn,'');
                //2018-12-11 DELETE!!! UpdateAlarmStatus(DefPocb.ALARM_CH1_MOTION_Y_MODEL_POS_NG,bIsAlarmOn,'');
              end;
              DefPocb.ALARM_CH2_MOTION_Y_SIG_ALARM_ON: begin
                UpdateAlarmStatus(DefPocb.ALARM_CH2_MOTION_Y_NEED_HOME_SEARCH,bIsAlarmOn,'');
                //2018-12-11 DELETE!!! UpdateAlarmStatus(DefPocb.ALARM_CH2_MOTION_Y_MODEL_POS_NG,bIsAlarmOn,'');
              end;
							{$IFDEF HAS_MOTION_CAM_Z}
              DefPocb.ALARM_CH1_MOTION_Z_SIG_ALARM_ON: begin
                UpdateAlarmStatus(DefPocb.ALARM_CH1_MOTION_Z_NEED_HOME_SEARCH,bIsAlarmOn,'');
                UpdateAlarmStatus(DefPocb.ALARM_CH1_MOTION_Z_MODEL_POS_NG,bIsAlarmOn,'');
              end;
              DefPocb.ALARM_CH2_MOTION_Z_SIG_ALARM_ON: begin
                UpdateAlarmStatus(DefPocb.ALARM_CH2_MOTION_Z_NEED_HOME_SEARCH,bIsAlarmOn,'');
                UpdateAlarmStatus(DefPocb.ALARM_CH2_MOTION_Z_MODEL_POS_NG,bIsAlarmOn,'');
              end;
							{$ENDIF}
							{$IFDEF HAS_MOTION_TILTING}
              DefPocb.ALARM_CH1_MOTION_T_SIG_ALARM_ON: begin  //2019-03-22
                UpdateAlarmStatus(DefPocb.ALARM_CH1_MOTION_T_NEED_HOME_SEARCH,bIsAlarmOn,'');
                UpdateAlarmStatus(DefPocb.ALARM_CH1_MOTION_T_MODEL_POS_NG,bIsAlarmOn,'');
              end;
              DefPocb.ALARM_CH2_MOTION_T_SIG_ALARM_ON: begin  //2019-03-22
                UpdateAlarmStatus(DefPocb.ALARM_CH2_MOTION_T_NEED_HOME_SEARCH,bIsAlarmOn,'');
                UpdateAlarmStatus(DefPocb.ALARM_CH2_MOTION_T_MODEL_POS_NG,bIsAlarmOn,'');
              end;
							{$ENDIF}
            end;
          end;
        end;
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_STATUS : begin  //2019-04-11 FPC Usage Limit
          nParam1 := PGuiJigData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param1;   // <nParam> 1:FpcUsageLimitOver
          sMsg    := PGuiJigData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
          case nParam1 of
{$IFDEF USE_FPC_LIMIT}
            1: begin  // FPC Usage Limit Over
              sNgMsg := 'Ch'+IntToStr(nCh+1)+' FPC Cable Usage Limit Over (Max:'+IntToStr(Common.SystemInfo.FpcUsageLimitValue)+')';
              sNgMsg := sNgMsg + #13 + #10 + '    - Change FPC Cable';  //2019-04-17
              ShowNgMessage(sNgMsg); // FPC Usage Limit
            end;
{$ENDIF}
            2: begin //TBD
            end;
          end;
        end;

        {$IFDEF SITE_LENSVN}
        DefPocb.MSG_MODE_SEND_GMES : begin
          if (DongaGmes <> nil) and Common.m_bMesOnline then begin
            DongaGmes.SendHostStatus(nCh, nParam1{nEqStValue}, TernaryOp((nParam2=0),False,True){bForce}); //2023-08-21 LENS:MES:EQSTATUS:Idle|Run
          end;
				end;
        {$ENDIF}

        //--------------------------------
//      DefPocb.MSG_MODE_WORKING : begin
////      PlcCtl.writePlc(defPlc.PLC_WRITE_TURN_READY,True);
////      SetPlcWriteStatus;
////      PlcCtl.writePlcRemove := defPlc.PLC_WRITE_TURN_READY;
//      end;
      end;
    end;
    //--------------------------------------------------------------------------
    {
      RMainGuiMotionData = record
        MsgType   : Integer;
        Channel   : Integer;
        Mode      : Integer;
        Param     : Integer;  // MotionID : DefMotion.MOTIONID_xxxxxx
        Param2    : Integer;  // MotionControlMode : DefPocb.MSG_MODE_MOTION_xxxxxx;
        Param3    : Integer;  // ErrCode : DefPocb.ERR_MOTION_xxxxxx
        Msg       : string[250];
      end;
    }
    DefPocb.MSG_TYPE_MOTION: begin  //2019-04-07
      nMode   := PMainGuiMotionData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nCh     := PMainGuiMotionData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
      nParam  := PMainGuiMotionData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;  // <Param>  MotionID
      nParam2 := PMainGuiMotionData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param2; // <Param2> nMotionCtlMode
      nParam3 := PMainGuiMotionData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param3; // <Param2> nErrCode
      sMsg    := PMainGuiMotionData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_STATUS : begin
          ShowMotionStatus(nParam{nMotionID},nParam2{nMotionCtlMode},nParam3{nErrCode},sMsg);
        end;
        else begin
          Common.MLog(DefPocb.SYS_LOG,'<FrmMain> CH'+IntToStr(nCh+1)+': TYPE_MOTION, UnknownMode('+IntToStr(nMode)+')');
        end;
      end;
    end;
  	//--------------------------------------------------------------------------
    {$IFDEF HAS_ROBOT_CAM_Z}
    DefPocb.MSG_TYPE_ROBOT: begin   //A2CHv3:ROBOT
      nMode   := PMainGuiRobotData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nCh     := PMainGuiRobotData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
      nParam  := PMainGuiRobotData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;  // <Param>  RobotID
      nParam2 := PMainGuiRobotData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param2; // <Param2> nRobotCtlMode
      nParam3 := PMainGuiRobotData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param3; // <Param2> nErrCode
      sMsg    := PMainGuiRobotData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_STATUS : begin
          ShowRobotStatus(nParam{nRobot},nParam2{nRobotCtlMode},nParam3{nErrCode},sMsg);
        end;
        else begin
          Common.MLog(DefPocb.SYS_LOG,'<FrmMain> CH'+IntToStr(nCh+1)+': TYPE_ROBOT, UnknownMode('+IntToStr(nMode)+')');
        end;
      end;
    end;
    {$ENDIF}
	//--------------------------------------------------------------------------
{$IFDEF USE_DFS}
    DefPocb.MSG_TYPE_DFS : begin
      nMode   := PMainGuiDfsData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;    //
      nCh     := PMainGuiDfsData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel; //
      nParam1 := PMainGuiDfsData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;   // <nParam> 0:Disconnected, 1:Connected
      sMsg    := PMainGuiDfsData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_STATUS: begin
          case nParam1 of   // 0:Off, 1:On
            0: begin ShowDfsConnectSts(False{bIsConnected}); end;
            1: begin ShowDfsConnectSts(True{bIsConnected});  end;
            else Exit;
          end;
          if nParam1 = 0 then begin // 0:Disconnected (FTP Connect/Send? Fail)
            //TBD:DFS? ALARM? NG?
          end;
        end;
      end;
    end;
{$ENDIF}
	  //--------------------------------------------------------------------------
    DefPocb.MSG_TYPE_IONIZER : begin
      nMode     := PMainGuiIonData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;     //
      nJig      := PMainGuiIonData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;  //
      nIonChIdx := PMainGuiIonData(PCopyDataStruct(Msg.LParam)^.lpData)^.IonChIdx; //
      nParam    := PMainGuiIonData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;    // <nParam> 0:Disconnected, 1:Connected
      sMsg      := PMainGuiIonData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
      case nMode of
        //--------------------------------
        DefPocb.MSG_MODE_DISPLAY_CONNECTION : begin
          sNgMsg   := '';
          case nJig of
            DefPocb.JIG_A: begin
              if nIonChIdx = 0 then begin
                case nParam of   // <Param>  0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG
                  0 : begin  //0: Disconnected
                    ledSysinfoIon1.FalseColor := clRed;
                    ledSysinfoIon1.Value      := False;
                    if sMsg <> '' then pnlSysInfoIon1.Caption := sMsg;
                    pnlSysinfoIon1.Color      := clRed;
                    pnlSysinfoIon1.Font.Color := clYellow;
                    if Common.SystemInfo.IonizerCntPerCH = 2 then sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer-1'
                    else                                          sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer';
                    sNgMsg := sNgMsg + ' Communication NG'+#13+#10+'    - Check Ionizer Device Connection and Ionizer Device Status';
                    if (not Common.AlarmList[DefPocb.ALARM_CH1_IONIZER_NOT_CONNECTED].bIsOn) then ShowNgMessage(sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER_NOT_CONNECTED,True{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  1 : begin  //1: Connected(+StatusOK)
                    ledSysinfoIon1.TrueColor  := clLime;
                    ledSysinfoIon1.Value      := True;
                    if sMsg <> '' then pnlSysInfoIon1.Caption := sMsg;
                    pnlSysinfoIon1.Color      := clLime;
                    pnlSysinfoIon1.Font.Color := clBlack;
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  2 : begin  //2: Ionizer NONE
                    ledSysinfoIon1.FalseColor := clGray;
                    ledSysinfoIon1.Value      := False;
                    pnlSysInfoIon1.Caption    := 'NONE';
                    pnlSysinfoIon1.Color      := clGray;
                    pnlSysinfoIon1.Font.Color := clBlack;
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  3 : begin  //3: StausNG
                    ledSysinfoIon1.FalseColor := clRed;
                    ledSysinfoIon1.Value      := False;
                    if sMsg <> '' then pnlSysInfoIon1.Caption := sMsg;
                    pnlSysinfoIon1.Color      := clRed;
                    pnlSysinfoIon1.Font.Color := clYellow;
                    if Common.SystemInfo.IonizerCntPerCH = 2 then sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer-1'
                    else                                          sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer';
                    sNgMsg := sNgMsg + ' Status NG'+#13+#10+'    - Check Ionizer Device Device Status';
                    if (not Common.AlarmList[DefPocb.ALARM_CH1_IONIZER_STATUS_NG].bIsOn) then ShowNgMessage(sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER_STATUS_NG,True{bIsAlarmOn},sNgMsg);
                  end;
                  4 : begin  //4: StausINFO  //2021-05-26
                    if sMsg <> '' then begin
                      ledSysinfoIon1.TrueColor  := clLime;
                      ledSysinfoIon1.Value      := True;
                      pnlSysinfoIon1.Color      := clLime;
                      pnlSysinfoIon1.Font.Color := clBlack;
                      pnlSysinfoIon1.Caption    := sMsg;
                    end;
                  end;
                end;
              end
              else begin  //valid if Common.SystemInfo.IonizerCntPerCH = 2
                case nParam of   // <Param>  0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG
                  0 : begin  //0: Disconnected
                    ledSysinfoIon1_2.FalseColor := clRed;
                    ledSysinfoIon1_2.Value      := False;
                    if sMsg <> '' then pnlSysinfoIon1_2.Caption := sMsg;
                    pnlSysinfoIon1_2.Color      := clRed;
                    pnlSysinfoIon1_2.Font.Color := clYellow;
                    sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer-2 Communication NG'+#13+#10+'    - Check Ionizer Device Connection and Ionizer Device Status';
                    if (not Common.AlarmList[DefPocb.ALARM_CH1_IONIZER2_NOT_CONNECTED].bIsOn) then ShowNgMessage(sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER2_NOT_CONNECTED,True{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER2_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  1 : begin  //1: Connected(+StatusOK)
                    ledSysinfoIon1_2.TrueColor  := clLime;
                    ledSysinfoIon1_2.Value      := True;
                    if sMsg <> '' then pnlSysinfoIon1_2.Caption := sMsg;
                    pnlSysinfoIon1_2.Color      := clLime;
                    pnlSysinfoIon1_2.Font.Color := clBlack;
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER2_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER2_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  2 : begin  //2: Ionizer NONE
                    ledSysinfoIon1_2.FalseColor := clGray;
                    ledSysinfoIon1_2.Value      := False;
                    pnlSysinfoIon1_2.Caption    := 'NONE';
                    pnlSysinfoIon1_2.Color      := clGray;
                    pnlSysinfoIon1_2.Font.Color := clBlack;
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER2_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER2_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  3 : begin  //3: StausNG
                    ledSysinfoIon1_2.FalseColor := clRed;
                    ledSysinfoIon1_2.Value      := False;
                    if sMsg <> '' then pnlSysinfoIon1_2.Caption := sMsg;
                    pnlSysinfoIon1_2.Color      := clRed;
                    pnlSysinfoIon1_2.Font.Color := clYellow;
                    sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer-2 Status NG ('+sMsg+')'+#13+#10+'    - Check Ionizer Device Status';
                    if (not Common.AlarmList[DefPocb.ALARM_CH1_IONIZER2_STATUS_NG].bIsOn) then ShowNgMessage(sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER2_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH1_IONIZER2_STATUS_NG,True{bIsAlarmOn},sNgMsg);
                  end;
                  4 : begin  //4: StausINFO  //2021-05-26
                    if sMsg <> '' then begin
                      ledSysinfoIon1_2.TrueColor  := clLime;
                      ledSysinfoIon1_2.Value      := True;
                      pnlSysinfoIon1_2.Color      := clLime;
                      pnlSysinfoIon1_2.Font.Color := clBlack;
                      pnlSysinfoIon1_2.Caption    := sMsg;
                    end;
                  end;
                end;
              end;
            end;
            DefPocb.JIG_B: begin
              if nIonChIdx = 0 then begin
                case nParam of   // <Param>  0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG, 4: StausINFO
                  0 : begin  //0: Disconnected
                    ledSysinfoIon2.FalseColor := clRed;
                    ledSysinfoIon2.Value      := False;
                    if sMsg <> '' then pnlSysInfoIon2.Caption := sMsg;
                    pnlSysinfoIon2.Color      := clRed;
                    pnlSysinfoIon2.Font.Color := clYellow;
                    if Common.SystemInfo.IonizerCntPerCH = 2 then sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer-1'
                    else                                          sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer';
                    sNgMsg := sNgMsg + ' Communication NG'+#13+#10+'    - Check Ionizer Device Connection and Ionizer Device Status';
                    if (not Common.AlarmList[DefPocb.ALARM_CH2_IONIZER_NOT_CONNECTED].bIsOn) then ShowNgMessage(sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER_NOT_CONNECTED,True{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  1 : begin  //1: Connected(+StatusOK)
                    ledSysinfoIon2.TrueColor  := clLime;
                    ledSysinfoIon2.Value      := True;
                    if sMsg <> '' then pnlSysInfoIon2.Caption := sMsg;
                    pnlSysinfoIon2.Color      := clLime;
                    pnlSysinfoIon2.Font.Color := clBlack;
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  2 : begin  //2:NONE
                    ledSysinfoIon2.FalseColor := clGray;
                    ledSysinfoIon2.Value      := False;
                    pnlSysinfoIon2.Caption    := 'NONE';
                    pnlSysinfoIon2.Color      := clGray;
                    pnlSysinfoIon2.Font.Color := clBlack;
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  3 : begin  //3: StausNG
                    ledSysinfoIon2.FalseColor := clRed;
                    ledSysinfoIon2.Value      := False;
                    if sMsg <> '' then pnlSysInfoIon2.Caption := sMsg;
                    pnlSysinfoIon2.Color      := clRed;
                    pnlSysinfoIon2.Font.Color := clYellow;
                    if Common.SystemInfo.IonizerCntPerCH = 2 then sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer-1'
                    else                                          sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer';
                    sNgMsg := sNgMsg + ' Status NG'+#13+#10+'    - Check Ionizer Device Device Status';
                    if (not Common.AlarmList[DefPocb.ALARM_CH2_IONIZER_STATUS_NG].bIsOn) then ShowNgMessage(sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER_STATUS_NG,True{bIsAlarmOn},sNgMsg);
                  end;
                  4 : begin  //4: StausINFO   //2021-05-26
                    if sMsg <> '' then begin
                      ledSysinfoIon2.TrueColor  := clLime;
                      ledSysinfoIon2.Value      := True;
                      pnlSysInfoIon2.Caption    := sMsg;
                      pnlSysinfoIon2.Color      := clLime;
                      pnlSysinfoIon2.Font.Color := clBlack;
                    end;
                  end;
                end;
              end
              else begin  //valid if Common.SystemInfo.IonizerCntPerCH = 2
                case nParam of   // <Param>  0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG, 4: StausINFO
                  0 : begin  //0: Disconnected
                    ledSysinfoIon2_2.FalseColor := clRed;
                    ledSysinfoIon2_2.Value      := False;
                    if sMsg <> '' then pnlSysInfoIon2_2.Caption := sMsg;
                    pnlSysInfoIon2_2.Color      := clRed;
                    pnlSysInfoIon2_2.Font.Color := clYellow;
                    sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer-2 Communication NG'+#13+#10+'    - Check Ionizer Device Connection and Ionizer Device Status';
                    if (not Common.AlarmList[DefPocb.ALARM_CH2_IONIZER2_NOT_CONNECTED].bIsOn) then ShowNgMessage(sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER2_NOT_CONNECTED,True{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER2_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  1 : begin  //1: Connected(+StatusOK)
                    ledSysinfoIon2_2.TrueColor  := clLime;
                    ledSysinfoIon2_2.Value      := True;
                    if sMsg <> '' then pnlSysInfoIon2_2.Caption := sMsg;
                    pnlSysInfoIon2_2.Color      := clLime;
                    pnlSysInfoIon2_2.Font.Color := clBlack;
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER2_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER2_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  2 : begin  //2:NONE
                    ledSysinfoIon2_2.FalseColor := clGray;
                    ledSysinfoIon2_2.Value      := False;
                    pnlSysInfoIon2_2.Caption    := 'NONE';
                    pnlSysInfoIon2_2.Color      := clGray;
                    pnlSysInfoIon2_2.Font.Color := clBlack;
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER2_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER2_STATUS_NG,False{bIsAlarmOn},sNgMsg);
                  end;
                  3 : begin  //3: StausNG
                    ledSysinfoIon2_2.FalseColor := clRed;
                    ledSysinfoIon2_2.Value      := False;
                    if sMsg <> '' then pnlSysInfoIon2_2.Caption := sMsg;
                    pnlSysInfoIon2_2.Color      := clRed;
                    pnlSysInfoIon2_2.Font.Color := clYellow;
                    sNgMsg := 'Ch'+IntToStr(nCh+1)+' Ionizer-2 Status NG ('+sMsg+')'+#13+#10+'    - Check Ionizer Device Status';
                    if (not Common.AlarmList[DefPocb.ALARM_CH2_IONIZER2_STATUS_NG].bIsOn) then ShowNgMessage(sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER2_NOT_CONNECTED,False{bIsAlarmOn},sNgMsg);
                    UpdateAlarmStatus(DefPocb.ALARM_CH2_IONIZER2_STATUS_NG,True{bIsAlarmOn},sNgMsg);
                  end;
                  4 : begin  //4: StausINFO   //2021-05-26
                    if sMsg <> '' then begin
                      ledSysinfoIon2_2.TrueColor  := clLime;
                      ledSysinfoIon2_2.Value      := True;
                      pnlSysInfoIon2_2.Caption    := sMsg;
                      pnlSysInfoIon2_2.Color      := clLime;
                      pnlSysInfoIon2_2.Font.Color := clBlack;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;

  end;

end;

{$IFDEF REF_SDIP} //TBD???
// memory leak 때문에 삭제... SDIP dpr에 Mutex로 설정 되어 있음.
//Initialization
//begin
//  CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, 1024, 'LGD_POCB_AUTO');
//  if GetLastError = ERROR_ALREADY_EXISTS then begin
//    ShowMessage(ExtractFileName(Application.ExeName) + ' Already Running...(đã chạy)');
//    halt;
//  end;
////  CloseHandle(hF)
//end;
{$ELSE}
Initialization
begin
  FileMapObj := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0, 1024, 'LGD_POCB_AUTO');
  if GetLastError = ERROR_ALREADY_EXISTS then begin
    ShowMessage(ExtractFileName(Application.ExeName) + ' Already Running...(đã chạy)');
    halt;
  end;
end;
{$ENDIF}

end.
