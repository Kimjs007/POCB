unit Mainter_A2CH;

interface
{$I Common.inc}

uses
	System.Classes, System.SysUtils, System.Variants, System.UITypes, System.DateUtils,
  Winapi.Messages, Winapi.Windows, Winapi.WinSock, IdGlobal,
	Vcl.Controls, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.Grids, Vcl.Mask, Vcl.StdCtrls, Vcl.Imaging.pngimage,
	RzButton, RzCmboBx, RzCommon, RzEdit, RzLabel, RzLine, RzLstBox, RzPanel, RzRadChk, RzShellDialogs, RzTabs, RzRadGrp,
	ALed, AdvGrid, AdvObj, AdvUtil, BaseGrid, StrUtils, UserUtils,
	//
	DefPocb, DefPG, DefCam,
	CamComm, CommonClass, DongaPattern, LogicPocb, UdpServerPocb, 
	DefDio, DioCtl, ExLightCtl, EfuCtl, DefIonizer, IonizerCtl, DefMotion, MotionCtl, FormAutoCal,
{$IFDEF HAS_ROBOT_CAM_Z}
  DefRobot, RobotCtl,
{$ENDIF}
{$IFDEF SITE_LENSVN}
  LensHttpMes,
{$ELSE}
  GMesCom,
{$ENDIF}
  CodeSiteLogging;


const
  // TAB: PG/CAM : PG Commands
  MAINT_PG_CMD_POWER_ON_ONLY            = 0;
  MAINT_PG_CMD_POWER_OFF_ONLY           = 1;
  MAINT_PG_CMD_PATTERN_NUM              = 2;
  MAINT_PG_CMD_PATTERN_RGB              = 3;
  MAINT_PG_CMD_DISPLAY_ON               = 4;
  MAINT_PG_CMD_DISPLAY_OFF              = 5;
  MAINT_PG_CMD_POWER_MEASURE            = 6;
{$IFDEF PANEL_AUTO}
  MAINT_PG_CMD_EEPROM_READ              = 7;
  MAINT_PG_CMD_EEPROM_WRITE             = 8;
  MAINT_PG_CMD_EEPROM_PROCMASK_CHECK    = 9;  //AUTO|ATO  ----|----
  MAINT_PG_CMD_EEPROM_PROCMASK_BEFORE_W = 10; //AUTO|ATO  ----|----
  MAINT_PG_CMD_EEPROM_PROCMASK_AFTER_W  = 11; //AUTO|ATO  ----|----
  MAINT_PG_CMD_EEPROM_CBPARA_CHECK      = 12; //AUTO|ATO  FOLD|GAGO
  MAINT_PG_CMD_EEPROM_CBPARA_BEFORE_W   = 13; //AUTO|ATO  FOLD|GAGO
  MAINT_PG_CMD_EEPROM_CBPARA_AFTER_W    = 14; //AUTO|ATO  ----|----
  MAINT_PG_CMD_EEPROM_GAMMADATA_READ    = 15; //AUTO|ATO  ----|----
  MAINT_PG_CMD_TCON_READ                = 16;
  MAINT_PG_CMD_TCON_WRITE               = 17;
  MAINT_PG_CMD_TCON_AFTERPUC_READ       = 18; //AUTO|ATO  ----|----
  MAINT_PG_CMD_TCON_AFTERPUC_WRITE      = 19; //AUTO|ATO  ----|----
  MAINT_PG_CMD_FLASH_READ               = 20;
  MAINT_PG_CMD_FLASH_WRITE              = 21;
  MAINT_PG_CMD_FLASH_CBDATA_READ        = 22;
  MAINT_PG_CMD_FLASH_CBDATA_WRITE       = 23;
  MAINT_PG_CMD_COMPBMP_DOWNLOAD         = 24;
  MAINT_PG_CMD_COMPBMP_DISPLAY          = 25;
  MAINT_PG_CMD_COMPBMP_DOWNLOAD_DISPLAY = 26;
  MAINT_PG_CMD_PG_RESET                 = 27;
  MAINT_PG_CMD_SPI_RESET                = 28;
  MAINT_PG_CMD_POWERESET_IMAGERGB       = 29;
{$ELSEIF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
  MAINT_PG_CMD_EEPROM_READ              = 7;
  MAINT_PG_CMD_EEPROM_WRITE             = 8;
  MAINT_PG_CMD_EEPROM_CBPARA_CHECK      = 9;  //AUTO|ATO  FOLD|GAGO
  MAINT_PG_CMD_EEPROM_CBPARA_BEFORE_W   = 10; //AUTO|ATO  FOLD|GAGO
  MAINT_PG_CMD_FLASH_READ               = 11;
  MAINT_PG_CMD_FLASH_WRITE              = 12;
  MAINT_PG_CMD_FLASH_GAMMADATA_READ     = 13; //----|---  FOLD|GAGO
  MAINT_PG_CMD_FLASH_CBPARA_READ        = 14; //----|---  FOLD|GAGO
  MAINT_PG_CMD_FLASH_CBPARA_WRITE       = 15; //----|---  FOLD|GAGO
  MAINT_PG_CMD_FLASH_CBDATA_READ        = 16;
  MAINT_PG_CMD_FLASH_CBDATA_WRITE       = 17;
  MAINT_PG_CMD_COMPBMP_DOWNLOAD         = 18;
  MAINT_PG_CMD_COMPBMP_DISPLAY          = 19;
  MAINT_PG_CMD_COMPBMP_DOWNLOAD_DISPLAY = 20;
  MAINT_PG_CMD_PG_RESET                 = 21;
  MAINT_PG_CMD_SPI_RESET                = 22;
  MAINT_PG_CMD_POWERESET_IMAGERGB       = 23;
{$ELSE}
{$ENDIF}

  // TAB: PG/CAM : CAM Commands
  // CamPC(Laon)
  MAINT_CAM_CMD_TSTART      = 0;
  MAINT_CAM_CMD_RSTDONE     = 1;
  MAINT_CAM_CMD_TSTOP       = 2;

type

  PGuiMainter  = ^RGuiMainter;
  RGuiMainter = packed record
    MsgType : Integer;  // 1 : PG, 2 : Camera.
    Channel : Integer;  // Channel.
    Mode    : Integer;
    Msg     : string;
  end;

  TPwrCalInfo = record  //2019-01-07 TBD?
    nPg   : Integer;
    nStep : Integer;
  end;

  TfrmMainter = class(TForm)
    pnlMainter          : TRzPanel;
    btnClose            : TRzBitBtn;
    RzOpenDialog1       : TRzOpenDialog;
    tmr_CheckDoorUnlock: TTimer;
    PageControlMainter: TRzPageControl;
    tabPgCamComm: TRzTabSheet;
    RzgrpPgComm: TRzGroupBox;
    RzpnlPgCommand: TRzPanel;
    mmPgComm: TMemo;
    btnPgSendCmd: TRzBitBtn;
    cmbxPgCmd: TRzComboBox;
    edPgCmdParam: TRzEdit;
    RzpnlPgCmdParam: TRzPanel;
    btnPgCommClear: TRzBitBtn;
    btnPgFileOpen: TRzBitBtn;
    edPgFileSend: TRzEdit;
    btnPgPowerOff: TRzBitBtn;
    btnPgPowerOn: TRzBitBtn;
    RzpnlPgCommPG: TRzPanel;
    cmbxPgNo: TRzComboBox;
    RzgrpCamComm: TRzGroupBox;
    ledCam: ThhALed;
    RzpnlCamCommand: TRzPanel;
    mmCamComm: TMemo;
    btnCamSendCmd: TRzBitBtn;
    cmbxCamCmd: TRzComboBox;
    RzpnlCamCommRcv: TRzPanel;
    mmCamCommRcv: TMemo;
    btnCamCommClear: TRzBitBtn;
    btnCamConnect: TRzBitBtn;
    RzpnlCamNo: TRzPanel;
    cmbxCamNo: TRzComboBox;
    RzgrpPatternInfo: TRzGroupBox;
    DongaPat: TDongaPat;
    lnSigoff2: TRzLine;
    lnSigoff1: TRzLine;
    pnlPatternName: TPanel;
    RzgrpPatternList: TRzGroupBox;
    gridPatternList: TAdvStringGrid;
    pnlPatGrpName: TPanel;
    RzgrpExLightCtl: TRzGroupBox;
    btnExLightCtlSetLevel: TRzBitBtn;
    RzpnlExLightCtlCh: TRzPanel;
    cmbxExLightCtlCh: TRzComboBox;
    RzpnlExLightCtlExCh: TRzPanel;
    cmbxExLightCtlExCh: TRzComboBox;
    RzpnlExLightCtlLevel: TRzPanel;
    edExLightCtlLevel: TRzEdit;
    btnExLightCtlOn: TRzBitBtn;
    btnExLightCtlOff: TRzBitBtn;
    tabDioMotor: TRzTabSheet;
    RzgrpDioIn: TRzGroupBox;
    RzgrpDioOut: TRzGroupBox;
    RzgrpStageMoveCh1: TRzGroupBox;
    btnStageForwardCh1: TRzBitBtn;
    btnStageBackwardCh1: TRzBitBtn;
    RzgrpStageMoveCh2: TRzGroupBox;
    btnStageForwardCh2: TRzBitBtn;
    btnStageBackwardCh2: TRzBitBtn;
    cbCheckPin_Ch1: TRzCheckBox;
    cbCheckPin_Ch2: TRzCheckBox;
    tabSystemInfo: TRzTabSheet;
    RzgrpSystemInfoIP: TRzGroupBox;
    lstSystemInfoIP: TRzListBox;
    RzGroupBox_BCR_Honeywell: TRzGroupBox;
    img1: TImage;
    img2: TImage;
    pnl3: TPanel;
    pnl4: TPanel;
    RzGroupBox_Barcode_Cognex: TRzGroupBox;
    img_Rs232: TImage;
    img_Keyboard: TImage;
    pnl2: TPanel;
    Panel1: TPanel;
    tabPgPowerCal: TRzTabSheet;
    RzgrpPwrOffset: TRzGroupBox;
    mmPgPowerCal: TMemo;
    btnPwrOffsetMemoClear: TRzBitBtn;
    RzpnlPwrOffsetPGTitle: TRzPanel;
    cmbxPwrOffsetPG: TRzComboBox;
    RzgrpPowerOffsetWrite: TRzGroupBox;
    cmbxPwrOffsetWValueVCC: TRzComboBox;
    RzpnlPwrOffsetWTitleVCC: TRzPanel;
    RzpnlPwrOffsetWTitleICC: TRzPanel;
    cmbxPwrOffsetWValueICC: TRzComboBox;
    RzpnlPwrOffsetWTitleVDD: TRzPanel;
    RzpnlPwrOffsetWTitleIDD: TRzPanel;
    cmbxPwrOffsetWValueVDD: TRzComboBox;
    cmbxPwrOffsetWValueIDD: TRzComboBox;
    btnPwrOffsetWrite: TRzBitBtn;
    RzgrpPwrOffsetRead: TRzGroupBox;
    RzpnlPwrOffserRTitleVCC: TRzPanel;
    RzpnlPwrOffsetRTitleICC: TRzPanel;
    RzpnlPwrOffsetRTitleVDD: TRzPanel;
    RzpnlPwrOffsetRTitleIDD: TRzPanel;
    btnPwrOffsetRead: TRzBitBtn;
    edPwrOffserRValueVCC: TRzEdit;
    edPwrOffsetRValueICC: TRzEdit;
    edPwrOffsetRValueVDD: TRzEdit;
    edPwrOffsetRValueIDD: TRzEdit;
    RzgrpPwrCal: TRzGroupBox;
    RzgrpPwrCalFlow: TRzGroupBox;
    btnPwrCalFlowStart: TRzBitBtn;
    btnPwrCalFlowClose: TRzBitBtn;
    pnlPwrCalFlow1: TPanel;
    pnlPwrCalFlow2: TPanel;
    pnlPwrCalFlow3: TPanel;
    pnlPwrCalFlow4: TPanel;
    pnlPwrCalFlow5: TPanel;
    pnlPwrCalFlow6: TPanel;
    pnlPwrCalFlow7: TPanel;
    pnlPwrCalFlow8: TPanel;
    pnlPwrCalFlow9: TPanel;
    pnlPwrCalFlow10: TPanel;
    pnlPwrCalFlow11: TPanel;
    pnlPwrCalFlow12: TPanel;
    pnlPwrCalFlow13: TPanel;
    pnlPwrCalFlow14: TPanel;
    RzgrpPwrCalFlowUpDown: TRzGroupBox;
    btnPwrCalFlowStepOK: TRzBitBtn;
    pnlPwrCalFlowUpDownStep: TPanel;
    btnPwrCalFlowPwrUp: TPanel;
    btnPwrCalFlowPwrDown: TPanel;
    GrpPwrCalFlowCalOK: TPanel;
    lblPwrCalFlowCalOK: TLabel;
    btnPwrCalFlowCalOK: TRzBitBtn;
    btnPwrCalibration: TRzBitBtn;
    RzpnlPwrCalPgTitle: TRzPanel;
    cmbxPwrCalPgValue: TRzComboBox;
    GrpPwrCalRemovePanel: TPanel;
    lblPwrCalRemoveLcm: TLabel;
    btnPwrCalRemoveLcmOK: TRzBitBtn;
    tabDoorUnlock: TRzTabSheet;
    tabLoaderAutoCalibration: TRzTabSheet;
    RzgrpPwrAutoCal: TRzGroupBox;
    btnPgAutoCal: TRzBitBtn;
    btnPgCalData_Print: TRzBitBtn;
    RzPanel1: TRzPanel;
    cmbxPwrAutoCalPgValue: TRzComboBox;
    sgrid_AutoCalData: TAdvStringGrid;
    RzgrpIonCtl: TRzGroupBox;
    RzgrpIonCtlCh1: TRzGroupBox;
    btnIonCtlCh1Stop: TRzBitBtn;
    btnIonCtlCh1Run: TRzBitBtn;
    RzgrpIonCtlCh1_2: TRzGroupBox;
    btnIonCtlCh1_2Stop: TRzBitBtn;
    btnIonCtlCh1_2Run: TRzBitBtn;
    RzgrpIonCtlCh2: TRzGroupBox;
    btnIonCtlCh2Stop: TRzBitBtn;
    btnIonCtlCh2Run: TRzBitBtn;
    RzgrpIonCtlCh2_2: TRzGroupBox;
    btnIonCtlCh2_2Stop: TRzBitBtn;
    btnIonCtlCh2_2Run: TRzBitBtn;
    //
    RzgrpMotorRobot: TRzGroupBox;
    cmbxMotorRobotChNo: TRzComboBox;
    RzgrpRobotCoordSave: TRzGroupBox;
    //
    RzgrpMotorPostion: TRzGroupBox; // Y-asix Position
    pnlMotionCurrCmdPos: TPanel;
    RzgrpMotorParam: TRzGroupBox; // Y-axis Move
    RzlblMotorParamCmdPosTitle: TRzLabel;
    RzlblMotorParamVelocityTitle: TRzLabel;
    RzlblMotorParamAccelTitle: TRzLabel;
    RzlblMotorParamStartStopSpeedTitle: TRzLabel;
    edMotorParamAccel: TRzNumericEdit;
    edMotorParamCmdPos: TRzNumericEdit;
    edMotorParamStartStopSpeed: TRzNumericEdit;
    edMotorParamVelocity: TRzNumericEdit;
    btnMotorMoveAbs: TRzBitBtn;
    btnMotorMoveDec: TRzBitBtn;
    btnMotorMoveInc: TRzBitBtn;
    RzgrpMotorJogCtrl: TRzGroupBox; // Y-asix Jog
    RzlblMotorJogVelocityTitle: TRzLabel;
    RzlblMotorJogAccelTitle: TRzLabel;
    edMotorJogAccel: TRzNumericEdit;
    edMotorJogVelocity: TRzNumericEdit;
    btnMotorMoveJogDec: TRzBitBtn;
    btnMotorMoveJogInc: TRzBitBtn;
    btnMotorMoveLimitMinus: TRzBitBtn;
    btnMotorMoveLimitPlus: TRzBitBtn;
    RzgrpMotionDevCtrl: TRzGroupBox; // Y-asix Dev Control
    btnMotorServoOn: TRzBitBtn;
    btnMotorServoOff: TRzBitBtn;
    btnMotorOrigin: TRzBitBtn;
    btnMotorStop: TRzBitBtn;
    btnMotorStopEMS: TRzBitBtn;
    //
    RzgrpRobotCoordControl: TRzGroupBox;      // ROBOT Coordinate Control
    RzgrpRobotCoordJog: TRzGroupBox;  // ROBOT Coordinate Control - Robot Move(Jog)
    RzlblRobotJogDistance: TRzLabel;
    cmbxRobotCoordJogDistance: TRzComboBox;
    radioRobotCoordJogSelect: TRzRadioGroup;
    pnlRobotCoordCurX: TPanel;
    pnlRobotCoordCurY: TPanel;
    pnlRobotCoordCurZ: TPanel;
    pnlRobotCoordCurRx: TPanel;
    pnlRobotCoordCurRy: TPanel;
    pnlRobotCoordCurRz: TPanel;
    RzlblRobotCoordXUnit: TRzLabel;
    RzlblRobotCoordYUnit: TRzLabel;
    RzlblRobotCoordZUnit: TRzLabel;
    RzlblRobotCoordRxUnit: TRzLabel;
    RzlblRobotCoordRyUnit: TRzLabel;
    RzlblRobotCoordRzUnit: TRzLabel;
    btnRobotMoveJogDec: TRzBitBtn;
    btnRobotMoveJogInc: TRzBitBtn;
    RzgrpRobotCoordRelMove: TRzGroupBox;
    edRobotCoordMoveX: TRzNumericEdit;
    edRobotCoordMoveY: TRzNumericEdit;
    edRobotCoordMoveZ: TRzNumericEdit;
    edRobotCoordMoveRy: TRzNumericEdit;
    edRobotCoordMoveRx: TRzNumericEdit;
    edRobotCoordMoveRz: TRzNumericEdit;
    btnRobotMoveRel: TRzBitBtn;
    RzgrpRobotCoordMovePreDefined: TRzGroupBox; // ROBOT Coordinate Control - Robot Move(Pre-Defined)
    btnRobotMoveHome: TRzBitBtn;
    btnRobotMoveModel: TRzBitBtn;
    RzgrpRobotTcpCmd: TRzGroupBox; // ROBOT Command (TCP ListenNode)
    edRobotTcpCmd: TRzEdit;
    btnRobotTcpCmdSend: TRzBitBtn;
    RzgrpRobotStatus: TRzGroupBox; // ROBOT Status
    RzpnlRobotAutoMode: TRzPanel;
    RzpnlRobotManualMode: TRzPanel;
    RzpnlRobotError: TRzPanel;
    RzpnlRobotProjRunning: TRzPanel;
    RzpnlRobotGetControl: TRzPanel;
    RzpnlRobotEstop: TRzPanel;
    RzpnlRobotLightTitle: TRzPanel;
    RzpnlRobotSpeedTitle: TRzPanel;
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
    //
    mmMotorRObotRet : TRzMemo;
    RzgrpLeftDoorUnlock: TRzGroupBox;
    btnLeftSwitchLock: TRzButton;
    btnLeftDoorUnlock: TRzButton;
    RzpnlLeftSwitchTeach: TRzPanel;
    RzgrpRightDoorUnlock: TRzGroupBox;
    btnRightSwitchLock: TRzButton;
    btnRightDoorUnlock: TRzButton;
    RzpnlRightSwitchTeach: TRzPanel;
    btnShuttersAllCloseCh1: TRzBitBtn;
    btnShuttersAllOpenCh1: TRzBitBtn;
    btnShuttersAllOpenCh2: TRzBitBtn;
    btnShuttersAllCloseCh2: TRzBitBtn;
    RzgrpYasixSync: TRzGroupBox;
    btnMotionYAxisSyncOff: TRzBitBtn;
    btnMotionYAxisSyncOn: TRzBitBtn;
    pnlMotionYAxisSyncMode: TRzPanel;
    btnMotionYaxisSaveLoadPos: TRzBitBtn;
    btnMotionYaxisSaveCamPos: TRzBitBtn;
    btnRobotSaveHomeCoord: TRzBitBtn;
    btnRobotSaveModelCoord: TRzBitBtn;
    btnRobotProjPause: TRzBitBtn;
    RzpnlRobotCoordHome: TRzPanel;
    ledRobotCoordHome: ThhALed;
    RzpnlRobotCoordModel: TRzPanel;
    ledRobotCoordModel: ThhALed;
    btnRobotMoveStandby: TRzBitBtn;
    cbSelftestBmpDownForceNG: TRzCheckBox;
    pnlPgCmdParamDesc: TRzPanel;
    tabMesTest: TRzTabSheet;
    RzgrpMesTestPchkEicr: TRzGroupBox;
    RzpnlMesTestCH: TRzPanel;
    btnMesTestSendPchk: TRzBitBtn;
    edMesTestBCR1: TRzEdit;
    RzpnlMesTestBCR: TRzPanel;
    btnMesTestSendEicrNG: TRzBitBtn;
    btnMesTestSendEicrOK: TRzBitBtn;
    btnLensMesTestSendReInput: TRzBitBtn;
    btnLensMesTestSendStatus: TRzBitBtn;
    cbmxMesTestCH: TRzComboBox;
    cbmxLensMesTestSendStatus: TRzComboBox;
    edMesTestBCR2: TRzEdit;
    //
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCloseClick(Sender: TObject);
    // PG
    procedure cmbxPgCmdChange(Sender: TObject);
    procedure btnPgPowerOnClick(Sender: TObject);
    procedure btnPgPowerOffClick(Sender: TObject);
    procedure btnPgCommClearClick(Sender: TObject);
    procedure btnPgFileOpenClick(Sender: TObject);
    procedure btnPgSendCmdClick(Sender: TObject);
    procedure gridPatternListClick(Sender: TObject);
    procedure cmbxPgNoChange(Sender: TObject);
    procedure MaintEepromGammaDataRead(nCh: Integer);
    procedure MaintFlashCBDataFileWrite(nCh: Integer);
    procedure MaintFlashReadData(nCh: Integer; nFlashAddr: UInt32; nSize: Integer);
    procedure MaintAutoFlowTest(nCh: Integer);
    function  MaintWorkStart(nCh: Integer): Boolean;    
    // CAM
    procedure btnCamConnectClick(Sender: TObject);
    procedure btnCamCommClearClick(Sender: TObject);
    procedure btnCamSendCmdClick(Sender: TObject);
    // DIO
    procedure btnDioOutClick(Sender: TObject);
    procedure btnStageForwardCh1Click(Sender: TObject);
    procedure btnStageForwardCh2Click(Sender: TObject);
    procedure btnStageBackwardCh1Click(Sender: TObject);
    procedure btnStageBackwardCh2Click(Sender: TObject);
    procedure btnShuttersAllOpenCh1Click(Sender: TObject);  //A2CHv3:DIO
    procedure btnShuttersAllCloseCh1Click(Sender: TObject); //A2CHv3:DIO
    procedure btnShuttersAllOpenCh2Click(Sender: TObject);  //A2CHv3:DIO
    procedure btnShuttersAllCloseCh2Click(Sender: TObject); //A2CHv3:DIO
//{$ENDIF}
	//2019-05-02 ExLight
    procedure btnExLightCtlOnClick(Sender: TObject);
    procedure btnExLightCtlOffClick(Sender: TObject);
    procedure btnExLightCtlSetLevelClick(Sender: TObject);
    // MOTION & ROBOT
 	  procedure cmbxMotorRobotChNoChange(Sender: TObject);   //A2CHv3:MOTION
    // MOTION
    procedure btnMotionSaveLoadPosClick(Sender: TObject);  //TBD:A2CHv3:MOTION? (SaveMotionPos to SysInfo/Model)
    procedure btnMotionSaveCamPosClick(Sender: TObject);   //TBD:A2CHv3:MOTION? (SaveMotionPos to SysInfo/Model)
    procedure btnMotorMoveAbsClick(Sender: TObject);
    procedure btnMotorMoveDecIncClick(Sender: TObject);
    procedure btnMotorMoveJogDecMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnMotorMoveJogIncMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnMotorMoveJogIncMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnMotorMoveJogDecMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MotorMoveJogMouseDown(Sender: TObject);
    procedure MotorMoveJogMouseUp(Sender: TObject);
    procedure btnMotorMoveLimitClick(Sender: TObject);
    procedure btnMotorOriginClick(Sender: TObject);
    procedure btnMotorOriginAllClick(Sender: TObject);
    procedure btnMotorStopClick(Sender: TObject);
    procedure btnMotorStopEmsClick(Sender: TObject);
    procedure btnMotorStopEmsAllClick(Sender: TObject);
    procedure btnMotorServoOnClick(Sender: TObject);
    procedure btnMotorServoOffClick(Sender: TObject);
    procedure edMotorParamAccelChange(Sender: TObject);
    procedure edMotorParamVelocityChange(Sender: TObject);
    procedure edMotorJogVelocityChange(Sender: TObject);
    procedure edMotorJogAccelChange(Sender: TObject);

    // ROBOT
  //{$IFDEF HAS_ROBOT_CAM_Z}
    procedure btnRobotSaveHomeCoordClick(Sender: TObject);  //TBD:A2CHv3:ROBOT? (SaveRobotPos to SysInfo/Model)
    procedure btnRobotSaveModelCoordClick(Sender: TObject); //TBD:A2CHv3:ROBOT? (SaveRobotPos to SysInfo/Model)
    procedure btnRobotMoveJogDecMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); //A2CHv3:ROBOT
    procedure btnRobotMoveJogDecMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);   //A2CHv3:ROBOT
    procedure btnRobotMoveJogIncMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer); //A2CHv3:ROBOT
    procedure btnRobotMoveJogIncMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);   //A2CHv3:ROBOT
    procedure RobotMoveJogMouseDown(Sender: TObject);   //A2CHv3:ROBOT
    procedure RobotMoveJogMouseUp(Sender: TObject);     //A2CHv3:ROBOT
    procedure btnRobotMoveRelClick(Sender: TObject);    //A2CHv3:ROBOT
    procedure btnRobotMoveHomeClick(Sender: TObject);   //A2CHv3:ROBOT
    procedure btnRobotMoveModelClick(Sender: TObject);  //A2CHv3:ROBOT
    procedure btnRobotMoveStandbyClick(Sender: TObject); //A2CHv3:ROBOT
    procedure btnRobotTcpCmdSendClick(Sender: TObject); //A2CHv3:ROBOT
    procedure btnRobotProjPauseClick(Sender: TObject);  //A2CHv3:ROBOT
  //{$ENDIF}

    // Ionizer
    procedure btnIonCtlRunClick(Sender: TObject);
    procedure btnIonCtlStopClick(Sender: TObject);
    // Power Cal
    procedure btnPwrCalibrationClick(Sender: TObject);
    procedure btnPwrCalRemoveLcmOKClick(Sender: TObject);
    procedure btnPwrCalFlowStartClick(Sender: TObject);
    procedure btnPwrCalFlowPwrUpClick(Sender: TObject);
    procedure btnPwrCalFlowPwrDownClick(Sender: TObject);
    procedure btnPwrCalFlowStepOKClick(Sender: TObject);
    procedure btnPwrCalFlowCalOKClick(Sender: TObject);
    procedure btnPwrCalFlowCloseClick(Sender: TObject);
    procedure btnPwrOffsetWriteClick(Sender: TObject);
    procedure btnPwrOffsetReadClick(Sender: TObject);
    procedure btnPwrOffsetMemoClearClick(Sender: TObject);
    // Power Cal (Loader)
    procedure btnPgAutoCalClick(Sender: TObject);
    procedure btnPgCalData_PrintClick(Sender: TObject);
    // Door Unlock
    procedure tmr_CheckDoorUnlockTimer(Sender: TObject);
    procedure btnLeftSwitchLockClick(Sender: TObject);
    procedure btnRightSwitchLockClick(Sender: TObject);
    procedure btnLeftDoorUnlockClick(Sender: TObject);  //A2CHv3:DIO
    procedure btnRightDoorUnlockClick(Sender: TObject); //A2CHv3:DIO

    // MES Test
    procedure cbmxMesTestCHChange(Sender: TObject);
    procedure btnMesTestSendPchkClick(Sender: TObject);
    procedure btnMesTestSendEicrOKClick(Sender: TObject);
    procedure btnMesTestSendEicrNGClick(Sender: TObject);
    procedure btnLensMesTestSendReInputClick(Sender: TObject);
    procedure btnLensMesTestSendStatusClick(Sender: TObject);

    // Etc
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure PageControlMainterTabClick(Sender: TObject);

  //{$IFDEF SUPPORT_1CG2PANEL}
    procedure btnMotionYAxisSyncOnClick(Sender: TObject);  //A2CHv3:MOTION:SYNC
    procedure btnMotionYAxisSyncOffClick(Sender: TObject); //A2CHv3:MOTION:SYNC
	//{$ENDIF}
  private
    ledDioIn      : array of ThhALed;
    pnlDioInNo    : array of TRzPanel;
    pnlDioInItem  : array of TRzPanel;
    ledDioOut     : array of ThhALed;
    pnlDioOutNo   : array of TRzPanel;
    pnlDioOutItem : array of TRzPanel;
    btnDioOut     : array of TRzBitBtn;
    PwrCalInfo    : TPwrCalInfo;  //2018-09-07
    m_bMaintRobotMove : Boolean;  //TBD:A2CHv3:ROBOT?
    m_bMaintRobotStandbyMove : Boolean;
    m_nLoaderCalCnt : Integer;
    m_frmAutoCal  : TForm_AutoCal;
    // PG & CAM
    procedure PgCmdThread(nCh : Integer);
    procedure PgPowerOn(nCh: Integer);
    procedure PgPowerOff(nCh : Integer);
    procedure BmpDownloadBuff(nCh: Integer; nIdx: Integer = 0);
    procedure GetPgSpiRxData(nDevType: Integer; nPgNo, nLength: Integer; RxData: array of byte);
    procedure GetPgSpiTxData(nDevType: Integer; nPgNo, nLength: Integer; TxData: array of byte);
    procedure DisplayPgLog(nCh: Integer; sMsg: string);
    function DisplayPatList(sPatgrp: string) : TPatternGroup;
    // DIO
    procedure MakeDIOSignal;
    procedure DisplayDioTitle;
    procedure ShowDioOutReadSt(DioOut: ADioStatus);
    procedure ShowDioStatus(DioIn, DioOut: ADioStatus);
    // MOTION
    function CheckAndGetMotionStartStop(nAxis: Integer; dTempStartStop: Double; var dStartStop: Double): Boolean;
    function CheckMotionJogVelocityMaxOver(nAxis: Integer; dTempJogVel: Double; var dJogVel: Double): Boolean;
    function CheckMotionJogAccelMaxOver(nAxis: Integer; dTempJogAccel: Double; var dJogAccel: Double): Boolean;
    procedure DisplayMotionStatus(nCh: Integer; nAxis: Integer);
    procedure ShowMaintMotionStatus(nMotionID, nMode, nErrCode: Integer; sMsg: String);
    procedure ShowMotorRobotMsg(sMsg: string);
    // ROBOT
    procedure DisplayRobotStatus(nCh: Integer);           //A2CHv3:ROBOT
    procedure DisplayRobotMoveButtons(bEnable: Boolean);  //A2CHv3:ROBOT
    procedure ShowMaintRobotStatus(nRobot, nMode, nErrCode: Integer; sMsg: String);  //A2CHv3:ROBOT
    // Power Cal
    function  CheckInValue(const nRef : Integer; const nValue : Integer; nRatio : Integer = 3) : Boolean;
    procedure ClearCalData;
    procedure ShowCalData(nTryCnt : Integer; nCh : Integer; wLen : Word; btData : array of byte);
    procedure ExportCalData(gridView : TAdvStringGrid; nCh : Integer);
    //
    procedure MaintSendEcirOK(nCh: Integer; sSN: string);
    procedure MaintSendEcirNG(nCh: Integer; sSN: string);
    // Common
    procedure ThreadTask(task : TProc; btnObj : TRzBitBtn);
    procedure SendGuiDisplay(nCh: Integer; sMsg: string; nMode: Integer = 0);
    procedure InitializeGui;
    procedure InitialPowerCalLoadGrid;
  public
    { }
  end;

var
  frmMainter: TfrmMainter;

implementation

uses OtlTaskControl, OtlParallel;

{$R *.dfm}

//******************************************************************************
// procedure/function: Create/Close/...
//      FormCreate(Sender: TObject);
//      FormCloseQuery(Sender: TObject; var CanClose: Boolean);
//      btnCloseClick(Sender: TObject);
//******************************************************************************

procedure TfrmMainter.FormCreate(Sender: TObject);
var
  PatGrp : TPatternGroup;
  i : integer;
  bVisible : Boolean;
begin
  Common.MLog(DefPocb.SYS_LOG,'<MAINTER> Window Open');
  //  PG Comm
//if UdpServer <> nil then begin
    if (PageControlMainter.ActivePage = tabPgCamComm) or (PageControlMainter.ActivePage = tabLoaderAutoCalibration) then begin
      UdpServer.IsMainter := True;
      UdpServer.OnRxDataForMaint := GetPgSpiRxData;
      UdpServer.OnTxDataForMaint := GetPgSpiTxData;
    end
    else begin
      UdpServer.IsMainter := False;
      UdpServer.OnRxDataForMaint := nil;
      UdpServer.OnTxDataForMaint := nil;
    end;
//end;

  cmbxPgCmd.Clear;
  cmbxPgCmd.DisableAlign;
  cmbxPgCmd.Items.Add('Power.ON (w/o CBPARA-before Write)'); // MAINT_PG_CMD_POWER_ON_ONLY
  cmbxPgCmd.Items.Add('Power.OFF (w/o CBPARA-after Write');  // MAINT_PG_CMD_POWER_OFF_ONLY
  cmbxPgCmd.Items.Add('Display PAT#');                       // MAINT_PG_CMD_PATTERN_NUM
  cmbxPgCmd.Items.Add('Display RGB#');                       // MAINT_PG_CMD_PATTERN_RGB
  cmbxPgCmd.Items.Add('Display.ON');                         // MAINT_PG_CMD_DISPLAY_ON
  cmbxPgCmd.Items.Add('Display.OFF');                        // MAINT_PG_CMD_DISPLAY_OFF
  cmbxPgCmd.Items.Add('Power Measurement');                  // MAINT_PG_CMD_POWER_MEASURE
{$IFDEF PANEL_AUTO}
  cmbxPgCmd.Items.Add('EEPROM Read');                        // MAINT_PG_CMD_EEPROM_READ
  cmbxPgCmd.Items.Add('EEPROM Write');                       // MAINT_PG_CMD_EEPROM_WRITE
  cmbxPgCmd.Items.Add('EEPROM ProcMask Check');              // MAINT_PG_CMD_EEPROM_PROCMASK_CHECK
  cmbxPgCmd.Items.Add('EEPROM ProcMask-Before Write');       // MAINT_PG_CMD_EEPROM_PROCMASK_BEFORE_W
  cmbxPgCmd.Items.Add('EEPROM ProcMask-After Write');        // MAINT_PG_CMD_EEPROM_PROCMASK_AFTER_W
  cmbxPgCmd.Items.Add('EEPROM CBPARA Check');                // MAINT_PG_CMD_EEPROM_CBPARA_CHECK
  cmbxPgCmd.Items.Add('EEPROM CBPARA-Before Write');         // MAINT_PG_CMD_EEPROM_CBPARA_BEFORE_W
  cmbxPgCmd.Items.Add('EEPROM CBPARA-After Write');          // MAINT_PG_CMD_EEPROM_CBPARA_AFTER_W
  cmbxPgCmd.Items.Add('EEPROM GammaData Read');              // MAINT_PG_CMD_EEPROM_GAMMADATA_READ
  cmbxPgCmd.Items.Add('TCON Read');                          // MAINT_PG_CMD_TCON_READ
  cmbxPgCmd.Items.Add('TCON Write');                         // MAINT_PG_CMD_TCON_WRITE
  cmbxPgCmd.Items.Add('TCON AfterPUC Read');                 // MAINT_PG_CMD_TCON_AFTERPUC_READ
  cmbxPgCmd.Items.Add('TCON AfterPUC Write');                // MAINT_PG_CMD_TCON_AFTERPUC_WRITE
  cmbxPgCmd.Items.Add('FLASH Read');                         // MAINT_PG_CMD_FLASH_READ
  cmbxPgCmd.Items.Add('FLASH Write');                        // MAINT_PG_CMD_FLASH_WRITE
  cmbxPgCmd.Items.Add('FLASH CBDATA Read');                  // MAINT_PG_CMD_FLASH_CBDATA_READ
  cmbxPgCmd.Items.Add('FLASH CBDATA Write');                 // MAINT_PG_CMD_FLASH_CBDATA_WRITE
{$ELSEIF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
  cmbxPgCmd.Items.Add('EEPROM Read');                        // MAINT_PG_CMD_EEPROM_READ
  cmbxPgCmd.Items.Add('EEPROM Write');                       // MAINT_PG_CMD_EEPROM_WRITE
  cmbxPgCmd.Items.Add('EEPROM CBPARA Read');                 // MAINT_PG_CMD_EEPROM_CBPARA_READ
  cmbxPgCmd.Items.Add('EEPROM CBPARA-before Write');         // MAINT_PG_CMD_EEPROM_CBPARA_BEFORE_W
  cmbxPgCmd.Items.Add('FLASH Read');                         // MAINT_PG_CMD_FLASH_READ
  cmbxPgCmd.Items.Add('FLASH Write');                        // MAINT_PG_CMD_FLASH_WRITE
  cmbxPgCmd.Items.Add('FLASH GammaData Read');               // MAINT_PG_CMD_FLASH_GAMMADATA_READ
  cmbxPgCmd.Items.Add('FLASH CBPARA Read');                  // MAINT_PG_CMD_FLASH_CBPARA_READ
  cmbxPgCmd.Items.Add('FLASH CBPARA Write');                 // MAINT_PG_CMD_FLASH_CBPARA_WRITE
  cmbxPgCmd.Items.Add('FLASH CBDATA Read');                  // MAINT_PG_CMD_FLASH_CBDATA_READ
  cmbxPgCmd.Items.Add('FLASH CBDATA Write');                 // MAINT_PG_CMD_FLASH_CBDATA_WRITE
{$ELSE}
{$ENDIF}
  cmbxPgCmd.Items.Add('COMPBMPx Download');                  // MAINT_PG_CMD_COMPBMP_DOWNLOAD
  cmbxPgCmd.Items.Add('COMPBMPx Display');                   // MAINT_PG_CMD_COMPBMP_DISPLAY
  cmbxPgCmd.Items.Add('COMPBMPx Download/Display');          // MAINT_PG_CMD_COMPBMP_DOWNLOAD_DISPLAY
  cmbxPgCmd.Items.Add('PG Reset');                           // MAINT_PG_CMD_PG_RESET
  cmbxPgCmd.Items.Add('SPI Reset');                          // MAINT_PG_CMD_SPI_RESET
{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
  cmbxPgCmd.Items.Add('PowerReset/ImageRGB');                // MAINT_PG_CMD_POWERESET_IMAGE_RGB
{$ENDIF}
  // Logic
  if (PageControlMainter.ActivePage = tabPgCamComm) then begin
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      Logic[i].IsMainter := True;
      Logic[i].OnPgLogForMaint := DisplayPgLog;
    end;
  end;

  DongaPat.DongaImgWidth  := DongaPat.Width;
  DongaPat.DongaImgHight  := DongaPat.Height;
  DongaPat.DongaPatPath   := Common.Path.Pattern;// DongaYT.m_sPatFilePath;
  DongaPat.DongaBmpPath   := Common.Path.BMP;// DongaYT.m_sBmpPath;
  DongaPat.LoadPatFile('No Signal');
  DongaPat.LoadAllPatFile;
  PatGrp := DisplayPatList(Common.TestModelInfo[DefPocb.CH_1].PatGrpName); //A2CHv3:MULTIPLE_MODEL

  cbSelfTestBMpDownForceNG.Visible := Common.Systeminfo.DebugSelfTestPg;
  cbSelfTestBMpDownForceNG.checked := False;

  // DIO
  MakeDIOSignal;
  DisplayDioTitle;
  DongaDio.DioOutReadStMaint := ShowDioOutReadSt;
  DongaDio.MaintInDioStatus  := ShowDioStatus;
  DongaDio.MaintInDioUse     := True;

  // Motor
  DongaMotion.MaintMotionStatus := ShowMaintMotionStatus;
  DongaMotion.MaintMotionUse 		:= False;  //2019-01-19 True->False
  {$IFDEF SUPPORT_1CG2PANEL}
  RzgrpYasixSync.Visible := Common.SystemInfo.UseAssyPOCB;
  {$ELSE}
  RzgrpYasixSync.Visible := False;
  {$ENDIF}

  // Robot
  {$IFDEF HAS_ROBOT_CAM_Z}
  DongaRobot.MaintRobotStatus := ShowMaintRobotStatus; //A2CHv3:ROBOT
  DongaRobot.MaintRobotUse 		:= False;                //A2CHv3:ROBOT
  {$ENDIF}

  // ExLight
  if (Common.SystemInfo.Com_ExLight <> 0) then RzgrpExLightCtl.Visible := True
  else                                         RzgrpExLightCtl.Visible := False;
  // Ionizer
  if Common.SystemInfo.IonizerCntPerCH = 2 then begin
    for i := 0 to DefIonizer.ION_MAX do begin
      if (Common.SystemInfo.Com_ION[i] = 0) then bVisible := False else bVisible := True;
      case i of
        0: RzgrpIonCtlCh1.Visible   := bVisible;
        1: RzgrpIonCtlCh1_2.Visible := bVisible;
        2: RzgrpIonCtlCh2.Visible   := bVisible;
        3: RzgrpIonCtlCh2_2.Visible := bVisible;
      end;
    end;
  end
  else begin
    for i := DefPocb.JIG_A to DefPocb.JIG_B do begin
      if (Common.SystemInfo.Com_ION[i] = 0) then bVisible := False else bVisible := True;
      case i of
        0: RzgrpIonCtlCh1.Visible := bVisible;
        1: RzgrpIonCtlCh2.Visible := bVisible;
      end;
    end;
    RzgrpIonCtlCh1_2.Visible := False;
    RzgrpIonCtlCh2_2.Visible := False;
  end;

  {$IFDEF SITE_LENSVN}
  btnMesTestSendPchk.Caption   := 'Send Start';
  btnMesTestSendEicrOK.Caption := 'Send End(PASS)';
  btnMesTestSendEicrNG.Caption := 'Send End(FAIL)';
  btnLensMesTestSendReInput.Visible := True;
  btnLensMesTestSendStatus.Visible  := True;
  cbmxLensMesTestSendStatus.Visible := True;
  {$ENDIF}

  InitializeGui;
end;

procedure TfrmMainter.InitializeGui;
var
  i : Integer;
begin
  RzpnlExLightCtlExCh.Caption :=
  RzpnlExLightCtlExCh.Caption + Format('(1~%d)',[Common.SystemInfo.ExLightCh_Count]);

  for i := 0 to Pred(Common.SystemInfo.ExLightCh_Count) do
  begin
     cmbxExLightCtlExCh.Items.Add(Format('%d',[i+1]));
     cmbxExLightCtlExCh.Values.Add(Format('%d',[i]));
  end;

  cmbxExLightCtlExCh.Items.Add('All');
  cmbxExLightCtlExCh.Values.Add(Format('%d',[i+1]));

{$IFDEF USE_BCR_COGNEX}
  RzGroupBox_Barcode_Cognex.Visible := True;
{$ELSEIF Defined(USE_BCR_HONEYWELL)}
  RzGroupBox_BCR_Honeywell.Visible  := True;
{$ENDIF}

{$IFDEF POCB_A2CH}
  PageControlMainter.Pages[tabDoorUnlock.PageIndex].TabVisible := False;
{$ELSE}
  PageControlMainter.Pages[tabDoorUnlock.PageIndex].TabVisible := True;
{$ENDIF}

  InitialPowerCalLoadGrid;
  cbCheckPin_Ch1.Visible := Common.SystemInfo.UsePinBlock;
  cbCheckPin_Ch2.Visible := Common.SystemInfo.UsePinBlock;

  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then begin
	{$ENDIF}
    RzgrpStageMoveCh1.Caption := 'CH1';
    RzgrpStageMoveCh2.Visible := True;
  {$IFDEF SUPPORT_1CG2PANEL}		
  end
  else begin
    RzgrpStageMoveCh1.Caption := 'CH1/CH2';
    RzgrpStageMoveCh2.Visible := False;
  end;
  {$ENDIF}

{$IFDEF HAS_ROBOT_CAM_Z}
  ledRobotAutoMode.TrueColor    := clLime;   ledRobotAutoMode.FalseColor    := clBtnFace;
  ledRobotManualMode.TrueColor  := clYellow; ledRobotManualMode.FalseColor  := clBtnFace;
  ledRobotFatalError.TrueColor  := clRed;    ledRobotFatalError.FalseColor  := clBtnFace;
  ledRobotProjRunning.TrueColor := clLime;   ledRobotProjRunning.FalseColor := clBtnFace;
  ledRobotProjEditing.TrueColor := clYellow; ledRobotProjEditing.FalseColor := clBtnFace;
  ledRobotProjPause.TrueColor   := clYellow; ledRobotProjPause.FalseColor   := clBtnFace;
  ledRobotGetControl.TrueColor  := clYellow; ledRobotGetControl.FalseColor  := clBtnFace;
  ledRobotEStop.TrueColor       := clRed;    ledRobotEStop.FalseColor       := clBtnFace;
  ledRobotCoordHome.TrueColor   := clYellow; ledRobotCoordHome.FalseColor   := clBtnFace;
  ledRobotCoordModel.TrueColor  := clLime;   ledRobotCoordModel.FalseColor  := clBtnFace;
{$ENDIF}
end;

procedure TfrmMainter.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tmr_CheckDoorUnlock.Enabled := False;
  DongaDio.MaintInDioUse      := False;
  DongaMotion.MaintMotionUse 	:= False;
  {$IFDEF HAS_ROBOT_CAM_Z}
  DongaRobot.MaintRobotUse    := False;
  {$ENDIF}
  if UdpServer is TUdpServerPocb then UdpServer.IsMainter := False;
  Logic[0].IsMainter := False;
  Logic[1].IsMainter := False;
  //
  {$IFDEF SUPPORT_1CG2PANEL}
  if Common.SystemInfo.UseAssyPOCB {and DongaMotion.m_bDioAssyJigOn} then begin  //2021-10-27 (ASSY-POCB:StartUp/Initial/MainterClose) SetYAxisSyncMode regardless of DioAssyJigOn
    if (DongaMotion.Motion[MOTIONID_AxMC_STAGE1_Y].m_bConnected and DongaMotion.Motion[MOTIONID_AxMC_STAGE2_Y].m_bConnected)
        and (DongaMotion.Motion[MOTIONID_AxMC_STAGE1_Y].m_MotionStatus.nSyncStatus <> DefMotion.SyncLinkMaster) then begin
      DongaMotion.SetYAxisSyncMode;
    end;
  end;
  {$ENDIF}
  Common.MLog(DefPocb.SYS_LOG,'<MAINTER> Window Close');
end;

procedure TfrmMainter.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMainter.PageControlMainterTabClick(Sender: TObject); //2019-01-07
var
	nCh, nAxis : Integer;
begin
  tmr_CheckDoorUnlock.Enabled := False;
  DongaMotion.MaintMotionUse  := False;
  {$IFDEF HAS_ROBOT_CAM_Z}
  DongaRobot.MaintRobotUse    := False;
  {$ENDIF}
  UdpServer.IsPowerAutoCal    := False;
  Logic[0].IsMainter := False;
  Logic[1].IsMainter := False;

  if PageControlMainter.ActivePage = tabPgCamComm then begin
    Common.MLog(DefPocb.SYS_LOG,'<MAINTER> Communication PG and CameraPC');
    Logic[0].IsMainter := True;
    Logic[1].IsMainter := True;
  end
  else if PageControlMainter.ActivePage = tabDioMotor then begin
    Common.MLog(DefPocb.SYS_LOG,'<MAINTER> DIO, Motion/Robot Control');
    DongaDio.MaintInDioUse     := True;
    DongaMotion.MaintMotionUse := True;
  	nCh := cmbxMotorRobotChNo.ItemIndex;
    {$IFDEF HAS_MOTION_CAM_Z}
  	nAxis := cmbxMotorAxis.ItemIndex;
    {$ELSE}
  	nAxis := DefMotion.MOTION_AXIS_Y;
    {$ENDIF}
    DisplayMotionStatus(nCh,nAxis);
    //
    {$IFDEF SUPPORT_1CG2PANEL}
    ShowMaintMotionStatus(MOTIONID_AxMC_STAGE1_Y,DefPocb.MSG_MODE_MOTION_SYNCMODE_GET,0,'');
    {$ENDIF}
    //
    {$IFDEF HAS_ROBOT_CAM_Z}
    DongaRobot.MaintRobotUse := True;
    m_bMaintRobotMove        := False;
    m_bMaintRobotStandbyMove := False;
    DisplayRobotStatus(nCh);
    {$ENDIF}
  end
  else if PageControlMainter.ActivePage = tabPgPowerCal then begin
    Common.MLog(DefPocb.SYS_LOG,'<MAINTER> Power Offset Setting and Calibration');
    btnPwrCalibration.Visible     := True;
    btnPwrCalibration.Enabled     := True;
    GrpPwrCalRemovePanel.Visible  := False;
    RzgrpPwrCalFlow.Visible       := False;
  end
  else if PageControlMainter.ActivePage = tabSystemInfo then begin
    Common.MLog(DefPocb.SYS_LOG,'<MAINTER> System Information');
  end
  else if PageControlMainter.ActivePage = tabDoorUnlock then begin
    Common.MLog(DefPocb.SYS_LOG,'<MAINTER> Door Unlock');
    tmr_CheckDoorUnlock.Enabled := True;
  end
  else if PageControlMainter.ActivePage = tabLoaderAutoCalibration then begin
    Common.MLog(DefPocb.SYS_LOG,'<MAINTER> Power AutoCalibration (Loader)');
    UdpServer.IsPowerAutoCal := True;
  end;

end;

//******************************************************************************
// procedure/function:
//      btnPgPowerOnClick(Sender: TObject);
//      btnPgPowerOffClick(Sender: TObject)/
//      btnPgCommClearClick(Sender: TObject);
//      btnPgFileOpenClick(Sender: TObject);
//      btnPgSendCmdClick(Sender: TObject);
//      PgPowerOff(nCh: Integer);
//      BinDownloadToSpi(nCh: Integer);
//      BmpDownloadBuff(nCh: Integer; nIdx: Integer = 0);
//      PgCmdThread(nCh: Integer);
//      GetPgRevData(nPgNo, nLength: Integer; RevData: array of byte);
//      gridPatternListClick(Sender: TObject);
//      DisplayPatList(sPatgrp: string) : TPatternGroup;
//******************************************************************************

procedure TfrmMainter.btnPgPowerOnClick(Sender: TObject);
var
  nCh, i : Integer;
begin
  nCh := cmbxPgNo.ItemIndex;
  if nCh = -1 then Exit;
  btnPgPowerOn.Enabled := False;
  if nCh > DefPocb.CH_MAX then begin
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      PgPowerOn(i);
    end;
  end
  else begin
    PgPowerOn(nCh);
  end;
end;

procedure TfrmMainter.btnPgAutoCalClick(Sender: TObject);
var
  nCh, i : Integer;
begin
  nCh := cmbxPwrAutoCalPgValue.ItemIndex;
  if nCh = -1 then Exit;
  if Pg[nCh].StatusPg in [pgDisconnect,pgWait] then Exit;

  if m_frmAutoCal <> nil then begin
    m_frmAutoCal.Free;
    m_frmAutoCal := nil;
  end;

  m_frmAutoCal := TForm_AutoCal.Create(nil);

  if nCh > DefPocb.CH_MAX then begin
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      Pg[i].SendPgPowerAutoCalMode;
    end;
  end
  else begin
    Pg[nCh].SendPgPowerAutoCalMode;
  end;

  m_frmAutoCal.ShowForm(nCh);
end;

procedure TfrmMainter.InitialPowerCalLoadGrid;
var
  nCol : Integer;
begin
  sgrid_AutoCalData.RowCount := 15;
  sgrid_AutoCalData.ColCount := 13;   // 12 >> 13

  sgrid_AutoCalData.ClearAll;
  sgrid_AutoCalData.Cells[0,0]   := 'Station No';
  sgrid_AutoCalData.Cells[1,0]   := 'CH';
  sgrid_AutoCalData.Cells[2,0]   := 'Date/Time';

  // 2020-04-13
  sgrid_AutoCalData.Cells[3,0]   := 'Result';

  sgrid_AutoCalData.Cells[4,0]   := 'Power';

  // 2020-04-13
  sgrid_AutoCalData.Cells[5,0]   := 'Count';

  sgrid_AutoCalData.ColWidths[0] := 100;
  sgrid_AutoCalData.ColWidths[1] := 40;
  sgrid_AutoCalData.ColWidths[2] := 120;
  sgrid_AutoCalData.ColWidths[3] := 50;
  sgrid_AutoCalData.ColWidths[4] := 60;
  sgrid_AutoCalData.ColWidths[5] := 40;

  for nCol := 0 to 6 do begin
    sgrid_AutoCalData.ColWidths[6+nCol] := 110;
    sgrid_AutoCalData.Cells[6+nCol,0] := Format('Load%d (%d mA)',[nCol,nCol*500]);
  end;
end;

procedure TfrmMainter.btnPgCalData_PrintClick(Sender: TObject);
var
  nCh, i : Integer;
begin
  nCh := cmbxPwrAutoCalPgValue.ItemIndex;
  if nCh = -1 then Exit;

  if Pg[nCh].StatusPg in [pgDisconnect,pgWait] then Exit;

  m_nLoaderCalCnt := 0;

  ClearCalData;

  RzgrpPwrAutoCal.Enabled := False;

  if nCh > DefPocb.CH_MAX then begin
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      Pg[i].SendPgPowerAutoCalData;
    end;
  end
  else begin
    Pg[nCh].SendPgPowerAutoCalData;
  end;
end;

procedure TfrmMainter.btnPgPowerOffClick(Sender: TObject);
var
  nCh, i : Integer;
begin
  nCh := cmbxPgNo.ItemIndex;
  if nCh = -1 then Exit;
  btnPgPowerOff.Enabled := False;
  if nCh > DefPocb.CH_MAX then begin
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      PgPowerOff(i);
    end;
  end
  else begin
    PgPowerOff(nCh);
  end;
end;

procedure TfrmMainter.btnPgCommClearClick(Sender: TObject);
begin
  mmPgComm.Clear;
end;

procedure TfrmMainter.btnPgFileOpenClick(Sender: TObject);
begin
  if RzOpenDialog1.Execute then begin
    edPgFileSend.Text := RzOpenDialog1.FileName;
  end;

end;

procedure TfrmMainter.btnPgSendCmdClick(Sender: TObject);
var
  nPG, i : Integer;
begin
  nPG := cmbxPgNo.ItemIndex;
  if nPG = -1 then Exit;
//btnPgSendCmd.Enabled := False;
  if nPG in [DefPocb.PG_1..DefPocb.PG_2] then begin
  //if Pg[nPG].Status in [pgDisconnect,pgWait] then Exit;
    PgCmdThread(nPG);
  end
  else begin
    for i := DefPocb.PG_1 to DefPocb.PG_MAX do begin
  	//if Pg[i].Status in [pgDisconnect,pgWait] then Continue;
      PgCmdThread(i);
    end;
  end;
end;

procedure TfrmMainter.PgPowerOn(nCh: Integer);
begin
  ThreadTask( procedure var nPwrOnDelay: Integer; sDebug: string;
  begin
    DisplayPgLog(nCh,'Power ON');
    Logic[nCh].m_Inspect.PowerOn := True;
    Pg[nCh].SendPgPowerOn(1);
    //--------------------------------- Power On/Off Delay
    nPwrOnDelay := Common.TestModelInfo2[nCh].PwrOnDelayMsec;
    if nPwrOnDelay > 0 then begin
      sDebug := Format('Delay %d ms',[nPwrOnDelay]);
      DisplayPgLog(nCh,sDebug);
      Sleep(nPwrOnDelay);
    end;
    //--------------------------------- EEPROM FlashAccess Disable if GIB
    {$IFDEF PANEL_AUTO}
    if Common.TestModelInfo2[nCh].EnableFlashWriteCBData then begin
      if not Logic[nCh].EepromFlashAccessWrite(False{bEnable}) then begin
        sDebug := 'EEPROM Write Fail (Flash Access Disable)';
        DisplayPgLog(nCh,sDebug);
      end;
    end;
    {$ENDIF}
    //
    //--------------------------------- EEPROM Write (Power-On)
    {$IFDEF PANEL_AUTO}
    Logic[nCh].EepromDataWrite(eepromCBParam,True{bBefore}); //USE_MODEL_PARAM_CSV
    {$ELSE}
    Logic[nCh].EepromDataWrite(eepromCBParam,True{bBefore}); //FOLDABLE: No EEPROM Write //TBD:GAGO?
    {$ENDIF}
  end, btnPgPowerOn);
end;

procedure TfrmMainter.PgPowerOff(nCh: Integer);
begin
  ThreadTask( procedure begin
    DisplayPgLog(nCh,'Power OFF');
    {$IFDEF PANEL_AUTO}
    Logic[nCh].EepromDataWrite(eepromCBParam,False{bBefore}); //USE_MODEL_PARAM_CSV
    {$ELSE}
    //FOLDABLE: No EEPROM Write
    {$ENDIF}
    Logic[nCh].m_Inspect.PowerOn := False;
    Pg[nCh].SendPgPowerOn(0);
  end, btnPgPowerOff);
end;

procedure TfrmMainter.BmpDownloadBuff(nCh: Integer; nIdx: Integer = 0);
var
  mtData : TMemoryStream;
  bmp1   : TBitmap;
  nTotalSize : Integer;
  dGetCheckSum : DWORD;
  btBuff : TIdBytes;
  ftsData : TFileTranStr;
  nTryCnt : Integer;
  sTemp   : string;
  bRtn    : Boolean;
  nType, nDIv, nMod : Integer;
  sBmpDownName : string;
begin
  Pg[nCh].SetCyclicTimerPg(False); //2022-02-16
  //
  ftsData.TransMode := DefPocb.DOWNDATA_POCB_COMPBMP; //DefPocb.DOWNDATA_BMP;
  ftsData.TransType := DefPG.PGSIG_BMPDOWN_TYPE_COMPBMP + nIdx;
  ftsData.TotalSize := 0;
  ftsData.filePath  := Common.Path.RootSW;
  sBmpDownName      := DefPocb.COMPBMP_DOWN_NAME + Format('%d',[nIdx]) + '.raw'; //2021-11-29
  ftsData.fileName  := sBmpDownName; //2021-11-29
  mtData := TMemoryStream.Create;
  try
    mtData.LoadFromFile(Trim(edPgFileSend.Text));
    mtData.Position := 0;
    bmp1 := Tbitmap.Create;
    try
	    bmp1.LoadFromStream(mtData);
      nDiv := (bmp1.Width div 2048);
      nMod := (bmp1.Width mod 2048);
      if nMod > 0 then nDiv := nDiv + 1;
      nType := nDiv * 2048;  //~2048(2048), ~4096(4096), ~6144(6144), ~8192(8192)  //TBD:A2CHv4:LUCID
      nTotalSize := bmp1.Height * nType * 3;
      SetLength(btBuff,nTotalSize);
      Common.MakeRawData(bmp1,btBuff);
      Common.SaveRawFile(sBmpDownName,btBuff,bmp1.Height,bmp1.Width); //2021-11-29
      SetLength(ftsData.Data,nTotalSize);
      CopyMemory(@ftsData.Data[0],@btBuff[0],nTotalSize);
      ftsData.TotalSize := nTotalSize;
      ftsData.BmpWidth  := bmp1.Width;
      dGetCheckSum := 0;
      // for Check Sum.
      if ftsData.TotalSize > 0 then begin
        Common.CalcCheckSum(@ftsData.Data[0], ftsData.TotalSize, dGetCheckSum);
      end;
      ftsData.CheckSum := dGetCheckSum;
      for nTryCnt := 0 to Common.TestModelInfo2[nCh].BmpDownRetryCnt do begin  //2021-07-07 BMP Download Retry if Download NG
        if nTryCnt = 0 then begin sTemp := 'Start BMP download to PG' end
        else                begin Sleep(1000); sTemp := 'Start BMP download to PG (Retry)'; end;
        DisplayPgLog(nCh,sTemp);
        if not Common.Systeminfo.DebugSelfTestPg then
          bRtn := Pg[nCh].PgDownBmpFile(ftsData)
        else
          bRtn := Pg[nCh].PgDownBmpFile(ftsData,cbSelfTestBMpDownForceNG.checked);
        if bRtn then Break;
      end;
    finally
      bmp1.Free;
    end;
  finally
    Pg[nCh].SetCyclicTimerPg(True); //2022-02-16
    mtData.Free;
  end;
end;

procedure TfrmMainter.cmbxPgCmdChange(Sender: TObject);
var
  sParamDesc : string;
  bNotApplicable : Boolean;
  bFileSelect    : Boolean;
begin
  bNotApplicable := False;
  bFileSelect    := False;

	case cmbxPgCmd.ItemIndex of
    //------------------------------------------------ Power ON/OFF
    MAINT_PG_CMD_POWER_ON_ONLY,
    MAINT_PG_CMD_POWER_OFF_ONLY: begin
      sParamDesc := '';
    end;

    //------------------------------------------------ Pattern
    MAINT_PG_CMD_PATTERN_NUM: begin
      sParamDesc := 'Pattern# (e,g., 1)';
    end;
    MAINT_PG_CMD_PATTERN_RGB: begin
      sParamDesc := 'R# G# B# (e,g., 127 127 127)';
    end;
    //
    MAINT_PG_CMD_DISPLAY_ON,
    MAINT_PG_CMD_DISPLAY_OFF: begin
    end;

    //------------------------------------------------ PowerMeasure
    MAINT_PG_CMD_POWER_MEASURE: begin
      sParamDesc := '';
    end;

    //------------------------------------------------ EEPROM
    MAINT_PG_CMD_EEPROM_READ: begin
      {$IFDEF PANEL_AUTO}
      sParamDesc := 'Dev# Reg# Len# (e.g., 0xA0 1000 1)';
      {$ELSEIF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
      sParamDesc := 'Dev# Reg# Len# (e.g., 0x50 0x3E8 1)';
      {$ENDIF}
    end;
    MAINT_PG_CMD_EEPROM_WRITE: begin
      {$IFDEF PANEL_AUTO}
      sParamDesc := 'Dev# Reg# Data1# Data2# ... (e.g., 0xA0 1000 0x09 0x40 ...)';
      {$ELSEIF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
      sParamDesc := 'Dev# Reg# Data1# Data2# ... (e.g., 0x50 0x3E8 0x89 ...)';
      {$ENDIF}
    end;
    //
{$IFDEF PANEL_AUTO}
    MAINT_PG_CMD_EEPROM_PROCMASK_CHECK,
    MAINT_PG_CMD_EEPROM_PROCMASK_BEFORE_W,
    MAINT_PG_CMD_EEPROM_PROCMASK_AFTER_W: begin
      sParamDesc := '';
    end;
{$ENDIF}
    MAINT_PG_CMD_EEPROM_CBPARA_CHECK,
    MAINT_PG_CMD_EEPROM_CBPARA_BEFORE_W: begin
      sParamDesc := '';
    end;
{$IFDEF PANEL_AUTO}
    MAINT_PG_CMD_EEPROM_CBPARA_AFTER_W,
    MAINT_PG_CMD_EEPROM_GAMMADATA_READ: begin
      sParamDesc := '';
    end;
{$ENDIF}

    //------------------------------------------------ TCON
{$IFDEF PANEL_AUTO}
    MAINT_PG_CMD_TCON_READ: begin
      sParamDesc := 'Reg# Len# (e.g., 3988 1)';
    end;
    MAINT_PG_CMD_TCON_WRITE: begin
      sParamDesc := 'Reg# Data1# Data2# ... (e.g., 3988 0xFF)';
    end;
    MAINT_PG_CMD_TCON_AFTERPUC_READ,
    MAINT_PG_CMD_TCON_AFTERPUC_WRITE: begin
      sParamDesc := '';
    end;
{$ENDIF}

    //------------------------------------------------ FLASH
    MAINT_PG_CMD_FLASH_READ: begin
      sParamDesc := 'Addr# Len# (e.g., 0x1000 10)';
    end;
    MAINT_PG_CMD_FLASH_WRITE: begin
      sParamDesc := 'Addr# Data1# Data2# ... (e.g., 0x1000 0x01 0x02 ...)';
    end;
{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
    MAINT_PG_CMD_FLASH_GAMMADATA_READ,
    MAINT_PG_CMD_FLASH_CBPARA_READ: begin
      sParamDesc := '';
    end;
    //
    MAINT_PG_CMD_FLASH_CBPARA_WRITE: begin
      sParamDesc := 'CB#(1~2) (e,g., 1)';
    end;
{$ENDIF}
    MAINT_PG_CMD_FLASH_CBDATA_READ: begin
      sParamDesc := '';
    end;
    MAINT_PG_CMD_FLASH_CBDATA_WRITE: begin
      sParamDesc := 'Select CBDATA .bin file to Write';
      bFileSelect := True;
    end;

    //------------------------------------------------ CompBMP
    MAINT_PG_CMD_COMPBMP_DISPLAY: begin
      sParamDesc := 'CompBMP#(1~4) (e.g., 1)';
    end;
    MAINT_PG_CMD_COMPBMP_DOWNLOAD,
    MAINT_PG_CMD_COMPBMP_DOWNLOAD_DISPLAY: begin
      sParamDesc := 'CompBMP#(1~4) (e.g., 1)';
      bFileSelect := True;
    end;

    //------------------------------------------------ PG/SPI Reset
    MAINT_PG_CMD_PG_RESET,
    MAINT_PG_CMD_SPI_RESET: begin
      sParamDesc := '';
    end;

    MAINT_PG_CMD_POWERESET_IMAGERGB: begin
      sParamDesc := 'Pat-DelayMS#-Gray#-DelayMS#-PucOff-DelaySEC#-PucOn (e.g., 1000 32 1000 5)';
    end;

		else exit;
	end;

  if bNotApplicable then begin
    pnlPgCmdParamDesc.Visible := True;
    pnlPgCmdParamDesc.Caption := 'N/A';
    RzpnlPgCmdParam.Visible := False;
    edPgCmdParam.Visible    := False;
  end
  else begin
    if (sParamDesc <> '') then begin
      pnlPgCmdParamDesc.Visible := True;
      pnlPgCmdParamDesc.Caption := sParamDesc;
      RzpnlPgCmdParam.Visible := True;
      edPgCmdParam.Visible    := True;
    end
    else begin
      pnlPgCmdParamDesc.Visible := False;
      pnlPgCmdParamDesc.Caption := '';
      RzpnlPgCmdParam.Visible := False;
      edPgCmdParam.Visible    := False;
    end;
  end;

	if bFileSelect then edPgFileSend.Text := '';
  btnPgFileOpen.Visible := bFileSelect;
  edPgFileSend.Visible  := bFileSelect;
end;

procedure TfrmMainter.PgCmdThread(nCh: Integer);
var
  nSelect : Integer;
  i, nLenParam : Integer;
  sParam : string;
  slTemp : TStringList;
  naTemp : array of integer;
  nIdx : Integer;
begin
  nSelect := cmbxPgCmd.ItemIndex;

  if Pg[nCh].StatusPg in [pgDisconnect,pgWait] then begin
    DisplayPgLog(nCh,'Check PG');
    btnPgSendCmd.Enabled := True;
    Exit;
  end;

  if nSelect in [
      MAINT_PG_CMD_EEPROM_READ,
      MAINT_PG_CMD_EEPROM_WRITE,
      {$IFDEF PANEL_AUTO}
      MAINT_PG_CMD_EEPROM_PROCMASK_CHECK,
      MAINT_PG_CMD_EEPROM_PROCMASK_BEFORE_W,
      MAINT_PG_CMD_EEPROM_PROCMASK_AFTER_W,
      {$ENDIF}
      MAINT_PG_CMD_EEPROM_CBPARA_CHECK,
      MAINT_PG_CMD_EEPROM_CBPARA_BEFORE_W,
      {$IFDEF PANEL_AUTO}
      MAINT_PG_CMD_EEPROM_CBPARA_AFTER_W,
      MAINT_PG_CMD_EEPROM_GAMMADATA_READ,
      MAINT_PG_CMD_TCON_READ,
      MAINT_PG_CMD_TCON_WRITE,
      MAINT_PG_CMD_TCON_AFTERPUC_READ,
      MAINT_PG_CMD_TCON_AFTERPUC_WRITE,
      {$ENDIF}
      MAINT_PG_CMD_FLASH_READ,
      MAINT_PG_CMD_FLASH_WRITE,
      {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
      MAINT_PG_CMD_FLASH_GAMMADATA_READ,
      MAINT_PG_CMD_FLASH_CBPARA_READ,
      MAINT_PG_CMD_FLASH_CBPARA_WRITE,
      {$ENDIF}
      MAINT_PG_CMD_FLASH_CBDATA_READ,
      MAINT_PG_CMD_FLASH_CBDATA_WRITE,
      MAINT_PG_CMD_SPI_RESET,
      MAINT_PG_CMD_POWERESET_IMAGERGB
  ]
  then begin
    if Pg[nCh].StatusSpi in [pgDisconnect,pgWait] then begin
      DisplayPgLog(nCh,'Check SPI');
      btnPgSendCmd.Enabled := True;
      Exit;
    end;
  end;

  if nSelect in [ MAINT_PG_CMD_FLASH_CBDATA_WRITE, MAINT_PG_CMD_COMPBMP_DOWNLOAD, MAINT_PG_CMD_COMPBMP_DOWNLOAD_DISPLAY ] then begin
    if Trim(edPgFileSend.Text) = '' then begin
      btnPgSendCmd.Enabled := True;
      Exit;
    end;
    if not FileExists(edPgFileSend.Text) then begin
      btnPgSendCmd.Enabled := True;
      Exit;
    end;
  end;

  sParam := StringReplace(Trim(edPgCmdParam.Text),'0x','$',[rfReplaceAll]);
	
  if not (nSelect in [ MAINT_PG_CMD_FLASH_CBDATA_WRITE ]) then begin
    SetLength(naTemp,2048);
    slTemp := TStringList.Create;
    try
      slTemp := TStringList.Create;
      try
        ExtractStrings([' '],[],PChar(sParam),slTemp);
        nLenParam := slTemp.Count;
        for i := 0 to Pred(nLenParam) do begin
          if i > 20 then break;
          naTemp[i] := StrToIntDef(slTemp.Strings[i],0);
        end;
      except
      end;
    finally
      slTemp.Free;
    end;
  end;

  nIdx := gridPatternList.Row;
  if nIdx < 0 then begin
    btnPgSendCmd.Enabled := True;
    Exit;
  end;

  ThreadTask( procedure 
    var dwRtn: DWORD; btaTemp: TIdBytes; arrBytes: array of Byte; sTemp: string;
        nTConAddr, nDevAddr, nRegAddr, nFlashAddr, nLen : Integer;
        nGray, nPucOnSec, nPucOffSec : Integer;
        bRtn : Boolean;
        j : Integer;
    begin
    case nSelect of

      MAINT_PG_CMD_POWER_ON_ONLY : begin
        DisplayPgLog(nCh,'Power.ON (w/o CBPARA-Before Write)');
        Logic[nCh].m_Inspect.PowerOn := True;
        Pg[nCh].SendPgPowerOn(1); // power on
      end;
      MAINT_PG_CMD_POWER_OFF_ONLY : begin
{$IFDEF PANEL_AUTO}
        DisplayPgLog(nCh,'Power.OFF (w/o CBPARA-after Write');
{$ELSE}
        DisplayPgLog(nCh,'Power.OFF');
{$ENDIF}
        Logic[nCh].m_Inspect.PowerOn := False;
        Pg[nCh].SendPgPowerOn(0); // power off
      end;

      MAINT_PG_CMD_PATTERN_NUM : begin
        sTemp := Format('Pattern PAT#: Idx(%d)',[nIdx]);
        DisplayPgLog(nCh,sTemp);
        Pg[nCh].SendPgDisplayPatNum(nIdx);
      end;
      MAINT_PG_CMD_PATTERN_RGB : begin //2022-07-15 UNIFORMITY_VERIFY
        if Common.Systeminfo.DebugSelfTestPg and (nLenParam > 3) then begin
          sTemp := Format('Pattern RGB: R(%d) G(%d) B(%d) PalletType(%d)',[naTemp[0],naTemp[1],naTemp[2],naTemp[3]]);
          DisplayPgLog(nCh,sTemp);
          dwRtn := Pg[nCh].SendPgSetColorRGB(naTemp[0],naTemp[1],naTemp[2],naTemp[3]);
        end
        else begin
          sTemp := Format('Pattern RGB#: R(%d) G(%d) B(%d)',[naTemp[0],naTemp[1],naTemp[2]]);
          DisplayPgLog(nCh,sTemp);
          dwRtn := Pg[nCh].SendPgSetColorRGB(naTemp[0],naTemp[1],naTemp[2]);
        end;
        if dwRtn <> WAIT_OBJECT_0 then begin
        	case dwRtn of
          	WAIT_FAILED  : sTemp := sTemp + ' ...NG(Failed)';
          	WAIT_TIMEOUT : sTemp := sTemp + ' ...NG(Timeout)';
          	else           sTemp := sTemp + ' ...NG(Etc)';
      		end;
          DisplayPgLog(nCh,sTemp);
				end;
      end;

      MAINT_PG_CMD_DISPLAY_ON : begin
        sTemp := 'Display ON';
        DisplayPgLog(nCh,sTemp);
        Pg[nCh].SendPgDisplayOnOff(True);
      end;
      MAINT_PG_CMD_DISPLAY_OFF : begin
        sTemp := 'Display OFF';
        DisplayPgLog(nCh,sTemp);
        Pg[nCh].SendPgDisplayOnOff(False);
      end;

      MAINT_PG_CMD_POWER_MEASURE : begin
        sTemp := 'Power Measurement';
        DisplayPgLog(nCh,sTemp);
        Pg[nCh].SendPgPowerMeasure;
      end;

			//---------------------------------------------- EEPROM
      MAINT_PG_CMD_EEPROM_READ : begin
        if nLenParam < 3 then begin
          sTemp := 'EEPROM Read Parameter Error';
          DisplayPgLog(nCh,sTemp);
          Exit;
        end;			
				nDevAddr := naTemp[0];
				nRegAddr := naTemp[1];
				nLen		 := naTemp[2];
        sTemp := Format('EEPROM Read Dev(%0.2x)/Reg(%0.4x) Len(%0.2x) ',[nDevAddr,nRegAddr,nLen]);
        DisplayPgLog(nCh,sTemp);
        SetLength(btaTemp,nLen);
        dwRtn := Pg[nCh].SendI2cRead(nLen,nDevAddr,nRegAddr);
        if dwRtn <> WAIT_OBJECT_0 then begin
        	case dwRtn of
          	WAIT_FAILED  : sTemp := sTemp + ' ...NG(Failed)';
          	WAIT_TIMEOUT : sTemp := sTemp + ' ...NG(Timeout)';
          	else           sTemp := sTemp + ' ...NG(Etc)';
      		end;
          DisplayPgLog(nCh,sTemp);
				end;
      end;
      MAINT_PG_CMD_EEPROM_WRITE : begin
        if nLenParam < 3 then begin
          sTemp := 'EEPROM Write Parameter Error';
          DisplayPgLog(nCh,sTemp);
          Exit;
        end;			
				nDevAddr := naTemp[0];
				nRegAddr := naTemp[1];		
				nLen     := nLenParam - 2;
        sTemp := Format('EEPROM Write Dev(%0.2x)/Reg(%0.4x):',[nDevAddr,nRegAddr]);
        SetLength(btaTemp,nLen);
        for j := 0 to (nLen-1) do begin
          btaTemp[j] := Byte(naTemp[j+2]);
          sTemp := sTemp + Format(' 0x%0.2x',[btaTemp[j]]);
        end;
        DisplayPgLog(nCh,sTemp);
        dwRtn := Pg[nCh].SendI2cWrite(nLen,nDevAddr,nRegAddr,btaTemp); //RegAddr(2Byte)
        if dwRtn <> WAIT_OBJECT_0 then begin
        	case dwRtn of
          	WAIT_FAILED  : sTemp := sTemp + ' ...NG(Failed)';
          	WAIT_TIMEOUT : sTemp := sTemp + ' ...NG(Timeout)';
          	else           sTemp := sTemp + ' ...NG(Etc)';
      		end;
          DisplayPgLog(nCh,sTemp);
        end;
      end;

{$IFDEF PANEL_AUTO}
      MAINT_PG_CMD_EEPROM_PROCMASK_CHECK : begin
        sTemp := 'EEPROM ProcMask Check -------';
        DisplayPgLog(nCh,sTemp);
        Logic[nCh].EepromDataCheck(eepromProcMask);
      end;
      MAINT_PG_CMD_EEPROM_PROCMASK_BEFORE_W : begin
        sTemp := 'EEPROM ProcMask(Before) Write -------';
        DisplayPgLog(nCh,sTemp);
        Logic[nCh].EepromDataWrite(eepromProcMask,True{bBefore});
      end;
      MAINT_PG_CMD_EEPROM_PROCMASK_AFTER_W : begin
        sTemp := 'EEPROM ProcMask(After) Write -------';
        DisplayPgLog(nCh,sTemp);
        Logic[nCh].EepromDataWrite(eepromProcMask,False{bBefore});
      end;
{$ENDIF}
      MAINT_PG_CMD_EEPROM_CBPARA_CHECK : begin
        sTemp := 'EEPROM CBPARA Check ------- N/A';
        DisplayPgLog(nCh,sTemp);
        //TBD:GAGO?
      end;
      MAINT_PG_CMD_EEPROM_CBPARA_BEFORE_W : begin
        sTemp := 'EEPROM CBPARA(Before) Write -------';
        DisplayPgLog(nCh,sTemp);
        Logic[nCh].EepromDataWrite(eepromCBParam,True{bBefore});
      end;
{$IFDEF PANEL_AUTO}
      MAINT_PG_CMD_EEPROM_CBPARA_AFTER_W : begin
        sTemp := 'EEPROM CBPARA(After) Write -------';
        DisplayPgLog(nCh,sTemp);
        Logic[nCh].EepromDataWrite(eepromCBParam,False{bBefore});
      end;
      MAINT_PG_CMD_EEPROM_GAMMADATA_READ : begin
        sTemp := 'EEPROM GammaData Read -------';
        DisplayPgLog(nCh,sTemp);
        MaintEepromGammaDataRead(nCh);
      end;
{$ENDIF}

{$IFDEF PANEL_AUTO}
			//---------------------------------------------- TCON
      MAINT_PG_CMD_TCON_READ : begin //2022-07-15 UNIFORMITY_VERIFY
        if nLenParam < 2 then begin
          sTemp := 'TCON Read Parameter Error';
          DisplayPgLog(nCh,sTemp);
          Exit;
        end;
        nTConAddr := naTemp[0];
				nLen      := naTemp[1];
				{$IFDEF PANEL_AUTO}
        Common.GetTCon2DevRegAddr(nTConAddr, nDevAddr,nRegAddr);
        sTemp := Format('TCON Read Addr(%d) Len(%d) : Dev(0x%0.2x)/Reg(0x%0.2x) Len(%d) ',[nTConAddr,nLen,nDevAddr,nRegAddr,nLen]);
				{$ELSE} //PANEL_FOLD|PANEL_GAGO
        nDevAddr := $50;       //TBD:GAGO?
        nRegAddr := nTConAddr; //TBD:GAGO?
        sTemp := Format('TCON Read Dev(0x%0.2x)/Reg(0x%0.2x) Len(%d) ',[nTConAddr,nLen,nDevAddr,nRegAddr,nLen]);
				{$ENDIF}
        DisplayPgLog(nCh,sTemp);
				{$IFDEF PANEL_AUTO}
        dwRtn := Pg[nCh].SendI2cRead(nLen,nDevAddr,nRegAddr,True{Is1Byte}); //TCon:RegAddr(1Byte)
				{$ELSE} //PANEL_FOLD|PANEL_GAGO
        dwRtn := Pg[nCh].SendI2cRead(nLen,nDevAddr,nRegAddr,False{Is1Byte});
				{$ENDIF}
        if dwRtn <> WAIT_OBJECT_0 then begin
        	case dwRtn of
          	WAIT_FAILED  : sTemp := sTemp + ' ...NG(Failed)';
          	WAIT_TIMEOUT : sTemp := sTemp + ' ...NG(Timeout)';
          	else           sTemp := sTemp + ' ...NG(Etc)';
      		end;
          DisplayPgLog(nCh,sTemp);
				end;
      end;

      MAINT_PG_CMD_TCON_WRITE : begin //2022-07-15 UNIFORMITY_VERIFYF
        if nLenParam < 2 then begin
          sTemp := 'TCON Write Parameter Error';
          DisplayPgLog(nCh,sTemp);
          Exit;
        end;
        nTConAddr := naTemp[0];
				nLen      := nLenParam - 1;
				{$IFDEF PANEL_AUTO}
        Common.GetTCon2DevRegAddr(nTConAddr, nDevAddr,nRegAddr);
        sTemp := Format('TCON Write Addr(%d): Dev(0x%0.2x)/Reg(0x%0.2x):',[nTConAddr,nDevAddr,nRegAddr]);
				{$ELSE} //PANEL_FOLD|PANEL_GAGO
        nDevAddr := $50;       //TBD:GAGO?
        nRegAddr := nTConAddr; //TBD:GAGO?
        sTemp := Format('TCON Write Addr(%d): Dev(0x%0.2x)/Reg(0x%0.4x):',[nTConAddr,nDevAddr,nRegAddr]);
				{$ENDIF}
        SetLength(btaTemp,nLen);
        for j := 0 to (nLen-1) do begin
          btaTemp[j] := Byte(naTemp[j+1]);
          sTemp := sTemp + Format(' 0x%0.2x',[btaTemp[j]]);
        end;
        DisplayPgLog(nCh,sTemp);
				{$IFDEF PANEL_AUTO}
        dwRtn := Pg[nCh].SendI2cWrite(nLen,nDevAddr,nRegAddr,btaTemp,True{Is1Byte}); //TCon:RegAddr(1Byte)
				{$ELSE} //PANEL_FOLD|PANEL_GAGO
        dwRtn := Pg[nCh].SendI2cWrite(nLen,nDevAddr,nRegAddr,btaTemp,False{Is1Byte});
				{$ENDIF}
        if dwRtn <> WAIT_OBJECT_0 then begin
        	case dwRtn of
          	WAIT_FAILED  : sTemp := sTemp + ' ...NG(Failed)';
          	WAIT_TIMEOUT : sTemp := sTemp + ' ...NG(Timeout)';
          	else           sTemp := sTemp + ' ...NG(Etc)';
      		end;
          DisplayPgLog(nCh,sTemp);
				end;
      end;
{$ENDIF}

{$IFDEF PANEL_AUTO}
      MAINT_PG_CMD_TCON_AFTERPUC_READ : begin
        sTemp := 'TCON AfterPUC Read ----- TBD';
        DisplayPgLog(nCh,sTemp);
				//TBD?
      end;
      MAINT_PG_CMD_TCON_AFTERPUC_WRITE : begin
        sTemp := 'TCON AfterPUC Write ----- TBD';
        DisplayPgLog(nCh,sTemp);
				//TBD?
      end;
{$ENDIF}

			//---------------------------------------------- FLASH
      MAINT_PG_CMD_FLASH_READ : begin
        if nLenParam < 2 then begin
          sTemp := 'FLASH Read Parameter Error';
          DisplayPgLog(nCh,sTemp);
          Exit;
        end;
        nFlashAddr := naTemp[0];
        nLen       := naTemp[1];
        sTemp := Format('FLASH Read Addr(0x%0.8x=%d) Len(%d) ',[nFlashAddr,nFlashAddr,nLen]);
        DisplayPgLog(nCh,sTemp + '--- TBD');
        //TBD:GAGO? MaintFlashDataRead(nCh,nFlashAddr,nLen);
      end;
      MAINT_PG_CMD_FLASH_WRITE : begin
        if nLenParam < 2 then begin
          sTemp := 'FLASH Write Parameter Error';
          DisplayPgLog(nCh,sTemp);
          Exit;
        end;
        nFlashAddr := naTemp[0];
        nLen       := nLenParam - 1;
        sTemp := Format('FLASH Write Addr(0x%0.8x=%d)',[nFlashAddr,nFlashAddr]);
        SetLength(btaTemp,nLenParam - 1);
        for j := 0 to (nLen-1) do begin
          btaTemp[j] := Byte(naTemp[j+1]);
          sTemp := sTemp + Format(' %0.2x',[btaTemp[j]]);
        end;
        DisplayPgLog(nCh,sTemp + '--- TBD');
        //TBD:GAGO? MaintFlashDataWrite(nCh,nFlashAddr,nLen,btaTemp);
      end;
{$IFDEF PANEL_AUTO}
{$ELSE} //PANEL_FOLD|PANEL_GAGO
      MAINT_PG_CMD_FLASH_GAMMADATA_READ : begin
        sTemp := 'FLASH GammaData Read -----';
        DisplayPgLog(nCh,sTemp);
        try
          SetLength(arrBytes,8192);
          bRtn := Logic[nCh].FlashGammaDataRead({var}nLen,{var}arrBytes);
          if not bRtn then begin
            sTemp := 'FLASH Gamma Data Read NG';
            DisplayPgLog(nCh,sTemp);;
          end
          else begin
            sTemp := Format('FLASH Gamma Data Read OK (Len=%d)',[nLen]);
            DisplayPgLog(nCh,sTemp);;
          end;
        finally
        end;
      end;
      MAINT_PG_CMD_FLASH_CBPARA_READ : begin
        sTemp := 'FLASH CBPARA Read ----- TBD';
        DisplayPgLog(nCh,sTemp);
        Exit;
				//TBD:GAGO?
      end;
      MAINT_PG_CMD_FLASH_CBPARA_WRITE : begin
        sTemp := 'FLASH CBPARA Write ----- TBD';
				//TBD?FoldXXXXX? if Logic[nCh].PwrOptModeOn(True{bOn},True{bAfterCBDataWrite},sTemp2,True{bMainter}) //TBD:GAGO?
        DisplayPgLog(nCh,sTemp);
        Pg[nCh].SendSpiReset;
      end;
{$ENDIF}
      MAINT_PG_CMD_FLASH_CBDATA_READ : begin
        sTemp := 'FLASH CBDATA Read ------- TBD';
        DisplayPgLog(nCh,sTemp);
        //TBD?
      end;
      MAINT_PG_CMD_FLASH_CBDATA_WRITE : begin
        sTemp := 'FLASH CBDATA Write -------';
        if Common.TestModelInfo2[nCh].EnableFlashWriteCBData then begin
          DisplayPgLog(nCh,sTemp);
          MaintFlashCBDataFileWrite(nCh);
        end
        else begin
          DisplayPgLog(nCh,sTemp+' N/A');
        end;
      end;

{$IFDEF PANEL_AUTO}
			//---------------------------------------------- CompBMP
      MAINT_PG_CMD_COMPBMP_DOWNLOAD : begin
        sTemp := 'BMPX Download';
        DisplayPgLog(nCh,sTemp);
        BmpDownloadBuff(nCh,0);
      end;
      MAINT_PG_CMD_COMPBMP_DISPLAY : begin
        sTemp := 'BMPx Pattern Display';
        DisplayPgLog(nCh,sTemp);
        Pg[nCh].SendPgDisplayDownBmp(0); // BMP Pattern Display
      end;
      MAINT_PG_CMD_COMPBMP_DOWNLOAD_DISPLAY : begin
        sTemp := 'BMPx Download';
        DisplayPgLog(nCh,sTemp);
        BmpDownloadBuff(nCh,0);
        sTemp := 'BMPx Pattern Display';
        DisplayPgLog(nCh,sTemp);
        Pg[nCh].SendPgDisplayDownBmp(0); // BMP Pattern Display
      end;
{$ENDIF}

			//---------------------------------------------- PG/SPI Reset
      MAINT_PG_CMD_PG_RESET : begin
        sTemp := 'Reset PG -----';
        DisplayPgLog(nCh,sTemp);
        Pg[nCh].SendPgReset;
      end;
      MAINT_PG_CMD_SPI_RESET : begin
        sTemp := 'Reset SPI -----';
        DisplayPgLog(nCh,sTemp);
        Pg[nCh].SendSpiReset;
      end;

			//---------------------------------------------- 
      MAINT_PG_CMD_POWERESET_IMAGERGB : begin
        if nLenParam < 4 then begin
          sTemp := 'PowerReset/ImageRGB Param Error';
          DisplayPgLog(nCh,sTemp);
          Exit;
        end;
        sTemp := Format('Power Reset and Display Pat-Delay(%dms)-RGB#(%d)-Delay(%dms)-PucOff-Delay(%dsec)-PucOn -----',[naTemp[0],naTemp[1],naTemp[2],naTemp[3]]);
        DisplayPgLog(nCh,sTemp);
        //
        Logic[nCh].RunFlowSeq_PowerReset(1{CBIdx});
        Sleep(naTemp[0]);
        Pg[nCh].SendPgSetColorRGB(naTemp[1],naTemp[1],naTemp[1]);
        Sleep(naTemp[2]);
        Logic[nCh].PucCtrlPocbOnOff(False{bOn});
        Sleep(naTemp[3]*1000);
        Logic[nCh].PucCtrlPocbOnOff(True{bOn});
      end;

    end;
  end, btnPgSendCmd);
end;

procedure TfrmMainter.GetPgSpiRxData(nDevType: Integer; nPgNo, nLength: Integer; RxData: array of byte); //TBD:MERGE?
const
  NAK = $05;
var
  sDevType, sDebug, sTemp : string;
  i             : Integer;
  btData        : array[0..100] of byte;
  wLen          : Word;
begin
  if (nDevType = DEBUG_LOG_DEVTYPE_PG) then sDevType := 'PG ' else sDevType := 'SPI';
  sTemp := '';
  for i := 0 to Pred(nLength) do sTemp := sTemp + Format('%0.2x ',[RxData[i]]);
  sDebug := FormatDateTime('[hh:mm:ss.zzz] ',Now) + Format('CH%d %s RX: Len(%d) Data(%s)',[nPgNo+1, sDevType, nLength ,sTemp]);
  mmPgComm.Lines.Add(sDebug);

  if (nDevType <> DEBUG_LOG_DEVTYPE_PG) then Exit;

  case RxData[7] of
    DefPG.SIG_PG_PWR_AUTOCAL_MODE: begin
      Pg[nPgNo].SetCyclicTimerSpi(True{bEnable});
      if RxData[3] = NAK then begin
        m_frmAutoCal.SetResult(nPgNo, $99);
        Exit;
      end;

      if (m_frmAutoCal <> nil) and (Length(RxData )> 8) then begin
        m_frmAutoCal.SetResult(nPgNo, RxData[8]);
      end;
    end;
    DefPG.SIG_PG_PWR_AUTOCAL_DATA: begin
      Pg[nPgNo].SetCyclicTimerSpi(True{bEnable});
      if RxData[3] = NAK then begin
        RzgrpPwrAutoCal.Enabled := True;
        ShowMessage('Fail');
        Exit;
      end;

      wLen := Length(RxData) - 9{STX,Short,SidID,Ch,Len[Short],SubSigID,ETX};
      if wLen < 56 {total Length} then begin
        RzgrpPwrAutoCal.Enabled := True;
        ShowMessage(Format('Power Cal data length is Short : %d',[wLen]));
        Exit;
      end;

      CopyMemory(@btData[0], @RxData[8], wLen);
      ShowCalData(m_nLoaderCalCnt, nPgNo, wLen, btData);
      Common.MLog(nPgNo, 'Done Display Cal Data');

      if m_nLoaderCalCnt < 2 then
      begin
        TThread.CreateAnonymousThread(procedure
        begin
          Sleep(500);
          m_nLoaderCalCnt := m_nLoaderCalCnt + 1;
          Pg[nPgNo].SendPgPowerAutoCalData;
        end).Start;
      end
      else begin
        ExportCalData(sgrid_AutoCalData, nPgNo);
        RzgrpPwrAutoCal.Enabled := True;
      end;
    end;
  end;
end;

procedure TfrmMainter.GetPgSpiTxData(nDevType: Integer; nPgNo, nLength: Integer; TxData: array of byte);
var
  sDebug, sTemp, sDevType : string;
  i : Integer;
begin
  if (nDevType = DEBUG_LOG_DEVTYPE_PG) then sDevType := 'PG ' else sDevType := 'SPI';  
  sTemp := '';
  for i := 0 to Pred(nLength) do sTemp := sTemp + Format('%0.2x ',[TxData[i]]);
  sDebug := FormatDateTime('[hh:mm:ss.zzz] ',Now) + Format('CH%d %s TX: Len(%d) Data(%s)',[nPgNo+1, sDevType, nLength ,sTemp]);
  mmPgComm.Lines.Add(sDebug);
end;

procedure TfrmMainter.DisplayPgLog(nCh : Integer; sMsg: string);
var
  sDebug : string;
begin
  sDebug := FormatDateTime('[hh:mm:ss.zzz]',Now) + Format(' CH%d %s',[nCh+1, sMsg]);
  mmPgComm.Lines.Add(sDebug);
end;

function  TfrmMainter.CheckInValue(const nRef : Integer; const nValue : Integer; nRatio : Integer = 3) : Boolean;
begin
  if nRef = 0 then begin
    if (nValue >= -nRatio) and (nValue <= nRatio) then Exit(True);
  end
  else begin
    if Abs(nRef - nValue) <= (nRef/100)*nRatio then Exit(True);
  end;

  Result := False;
end;

procedure TfrmMainter.ClearCalData;
var
  nCol, nRow : Integer;
begin
  for nRow := 1 to Pred(sgrid_AutoCalData.RowCount) do begin
    for nCol := 0 to Pred(sgrid_AutoCalData.ColCount) do begin
      sgrid_AutoCalData.Cells[nCol, nRow] := '';
      if nCol > 0 then sgrid_AutoCalData.Colors[nCol, nRow] := clWhite;
    end;
  end;
end;

procedure TfrmMainter.ShowCalData(nTryCnt : Integer; nCh : Integer; wLen : Word; btData : array of byte);
const
  ICC = 2;
  IDD = 4;
var
  nValue           : Integer;
  nCol, nRow, nCnt : Integer;
  nCurRow          : Integer;
begin
  nCnt := 0;

  for nRow := 1 to 4 do begin
    nCurRow := nRow+(nTryCnt*5);
    for nCol := 0 to 6 do begin
      sgrid_AutoCalData.Cells[0,nCurRow]   := Common.SystemInfo.EQPId;
      sgrid_AutoCalData.Cells[1,nCurRow]   := Format('%d',[nCh+1]);
      sgrid_AutoCalData.Cells[2,nCurRow]   := FormatDateTime('yyyy-mm-dd hh:nn:ss',now);
    
      case nRow of
        1 : sgrid_AutoCalData.Cells[4,nCurRow]   := 'VCC(V)';
        2 : sgrid_AutoCalData.Cells[4,nCurRow]   := 'ICC(mA)';
        3 : sgrid_AutoCalData.Cells[4,nCurRow]   := 'VDD(V)';
        4 : sgrid_AutoCalData.Cells[4,nCurRow]   := 'IDD(mA)';
      end;

      sgrid_AutoCalData.Cells[5,nCurRow]   := Format('%d',[nTryCnt+1]);

      nValue := (btData[nCnt] shl 8) + btData[nCnt+1];

      if nRow in [ICC, IDD] then begin
        if not CheckInValue(500 * nCol, nValue) then begin
          sgrid_AutoCalData.Cells[3, nCurRow]  := 'NG';
          sgrid_AutoCalData.Colors[6 + nCol, nCurRow] := clRed;
        end;
        sgrid_AutoCalData.Cells[6 + nCol, nCurRow] := nValue.ToString;
      end
      else begin
        case Common.SystemInfo.PG_TYPE of
          DefPG.PG_TYPE_DP489: sgrid_AutoCalData.Cells[6 + nCol, nCurRow] := Format('%.2f', [Double(nValue)/100]);  //DP489: 1=10mV
          else                 sgrid_AutoCalData.Cells[6 + nCol, nCurRow] := Format('%.2f', [Double(nValue)/1000]); //DP200|DP201: 1=1mV  //2022-01-07
        end;
      end;
      nCnt   := nCnt + 2;
    end;
  end;
end;

procedure TfrmMainter.ExportCalData(gridView : TAdvStringGrid; nCh : Integer);
var
  nValue           : Integer;
  sHeader, sData, sFilePath : string;
  nCol, nRow       : Integer;
  txtF             : Textfile;
  bIsNG            : Boolean;
begin
  sHeader := '';
  for nCol := 0 to Pred(gridView.ColCount) do begin
    sHeader := sHeader + gridView.Cells[nCol,0] +',';
  end;

  sData := '';
  for nRow := 1 to Pred(gridView.RowCount) do begin
    for nCol := 0 to Pred(gridView.ColCount) do begin
      sData := sData + gridView.Cells[nCol,nRow] +',';
    end;
    sData := sData + #13#10;
  end;

  sFilePath  := Common.Path.LOG + 'PwrCal_Log\';
  sFilePath  := sFilePath + Format('PwrAutoCalData_POCB_CH%d',[nCh+1]);
  sFilePath  := sFilePath + formatDateTime('_yymmdd',now) + '.csv';

  Common.MakeFile(sFilePath, sHeader, sData);
end;

procedure TfrmMainter.gridPatternListClick(Sender: TObject);
var
  nIdx, nPatType : Integer;
begin
  Common.MLog(DefPocb.SYS_LOG,'<MAINTER> gridPatternListClick');
  if gridPatternList.RowCount < 1 then Exit;
  nIdx := gridPatternList.Row;
  nPatType := StrToInt(gridPatternList.Cells[0, nIdx]);
  lnSigoff1.Visible := False;
  lnSigoff2.Visible := False;
  DongaPat.DrawPatAllPat(nPatType, gridPatternList.Cells[1, nIdx]);
  pnlPatternName.Caption := gridPatternList.Cells[1, nIdx];
end;

function TfrmMainter.DisplayPatList(sPatgrp: string) : TPatternGroup;
var
  CurPatGrp   : TPatternGroup;
  i           : Integer;
begin
  gridPatternList.RowCount := 1;
  gridPatternList.ColCount := 5;
  gridPatternList.Rows[0].Clear;

//  sPatGrpName := DongaYT.ModelInfo.PatGrFuse;
  CurPatGrp   := Common.LoadPatGroup(sPatgrp);
  gridPatternList.HideColumn(0);
  gridPatternList.HideColumn(2);
  gridPatternList.HideColumn(3);
  gridPatternList.HideColumn(4);
  pnlPatGrpName.Caption := sPatgrp;
  if CurPatGrp.PatCount > 0 then begin
    gridPatternList.RowCount := CurPatGrp.PatCount;
    for i := 0 to pred(CurPatGrp.PatCount) do begin
      gridPatternList.Cells[0, i] := Format('%d',[CurPatGrp.PatType[i]]);
      gridPatternList.Cells[1, i] := String(CurPatGrp.PatName[i]);
    end;
  end;
end;

//******************************************************************************
// procedure/function:
//      btnCamConnectClick(Sender: TObject);
//      btnCamCommClearClick(Sender: TObject);
//      btnCamSendCmdClick(Sender: TObject);
//******************************************************************************

procedure TfrmMainter.btnCamConnectClick(Sender: TObject);
var
  nCam : Integer;
begin
  nCam := cmbxCamNo.ItemIndex;
  Common.MLog(nCam,'<MAINTER> PG/CAM: CAM'+IntToStr(nCam+1)+': Connect Click');
  if CameraComm.IdCamClients[nCam].Connected then
    CameraComm.ConnectCam(nCam,False)
  else
    CameraComm.ConnectCam(nCam);
end;

procedure TfrmMainter.btnCamCommClearClick(Sender: TObject);
begin
  mmCamComm.Clear;
end;

procedure TfrmMainter.btnCamSendCmdClick(Sender: TObject);
var
  nCam, {nJig,} nPg, nCh : Integer;
  nSelect : Integer;
  //slTemp : TStringList;
  //naTemp : array[0..10] of integer;
begin
  nCam    := cmbxCamNo.ItemIndex;
  nSelect := cmbxCamCmd.ItemIndex;
  Common.MLog(nCam,'<MAINTER> PG/CAM: CAM'+IntToStr(nCam+1)+': SendCmd Click');
  if not (nCam in [DefPocb.CH_1..DefPocb.CH_2]) then Exit;
  //
  btnCamSendCmd.Enabled := False;
  CameraComm.m_hTest[nCam] := Self.Handle;
  //
  Parallel.Async( procedure begin
      case nSelect of
        0 : begin CameraComm.SendCmd(nCam,'TSTART 12345678901234567'); end; //TBD?
        1 : begin CameraComm.SendCmd(nCam,'TSTART2 12345678901234567'); end; //TBD?
        2 : begin CameraComm.SendCmd(nCam,'TSTART3 12345678901234567'); end; //TBD?
        3 : begin CameraComm.SendCmd(nCam,'TSTART4 12345678901234567'); end; //TBD?
        4 : begin CameraComm.SendCmd(nCam,'RSTDONE'); end;
        5 : begin CameraComm.SendCmd(nCam,'TSTOP'); end;  //2018-12-11
      end;
    end,
    Parallel.TaskConfig.OnTerminated(
      procedure (const task: IOmniTaskControl)
      begin
        btnCamSendCmd.Enabled := True;
      end
    )
  );
end;

//******************************************************************************
// procedure/function:
//      MakeDIOSignal;
//      DisplayDioTitle;
//      ShowDioStatus;
//      btnDioOutClick(Sender: TObject);
//******************************************************************************

procedure TfrmMainter.MakeDIOSignal;
var
  i, nDiv: Integer;
begin
  // DIO-IN ----------------------------
  SetLength(ledDioIn,DefDio.MAX_DIO_CNT);
  SetLength(pnlDioInNo,DefDio.MAX_DIO_CNT);
  SetLength(pnlDioInItem,DefDio.MAX_DIO_CNT);
  nDiv := 32;
  for i := 0 to Pred(DefDio.MAX_DIO_CNT) do begin
    // DioIn - No
    pnlDioInNo[i]               := TRzPanel.Create(nil);
    pnlDioInNo[i].Parent        := RzgrpDioIn;
    if i < nDiv then pnlDioInNo[i].Left := 4
    else             pnlDioInNo[i].Left := 137;
    pnlDioInNo[i].BevelWidth    := 1;
    pnlDioInNo[i].FlatColor     := clBlack;
    pnlDioInNo[i].BorderInner   := TframeStyleEx(fsNone);
    pnlDioInNo[i].BorderOuter   := TframeStyleEx(fsFlat);
    pnlDioInNo[i].Width         := 16;
    pnlDioInNo[i].Height        := 18;
    if i in [0, nDiv] then pnlDioInNo[i].Top := 16
    else                   pnlDioInNo[i].Top := pnlDioInNo[i-1].Top + pnlDioInNo[i-1].Height + 2;
    pnlDioInNo[i].Visible       := True;
    pnlDioInNo[i].Font.Name     := 'Tahoma';
    pnlDioInNo[i].Font.Style    := [fsBold];
    pnlDioInNo[i].Font.Size     := 8;
    pnlDioInNo[i].Caption       := Format('%d',[i]);
    // DioIn - Led
    ledDioIn[i]                 := ThhALed.Create(nil);
    ledDioIn[i].Parent          := RzgrpDioIn;
    ledDioIn[i].Left            := pnlDioInNo[i].Left + pnlDioInNo[i].Width;
    ledDioIn[i].Top             := pnlDioInNo[i].Top - 1;
    ledDioIn[i].Height          := 18;
    ledDioIn[i].LEDStyle        := LEDSqLarge;
    ledDioIn[i].FalseColor      := clRed;
    ledDioIn[i].TrueColor       := clLime;
    ledDioIn[i].Blink           := False;
    ledDioIn[i].Visible         := True;
    ledDioIn[i].Value           := False;
    // DioIn - Item
    pnlDioInItem[i]             := TRzPanel.Create(nil);
    pnlDioInItem[i].Parent      := RzgrpDioIn;
    pnlDioInItem[i].Left        := ledDioIn[i].Left + ledDioIn[i].Width;
    pnlDioInItem[i].BevelWidth  := 1;
    pnlDioInItem[i].Top         := pnlDioInNo[i].Top;
    pnlDioInItem[i].FlatColor   := clBlack;
    pnlDioInItem[i].BorderInner := TframeStyleEx(fsNone);
    pnlDioInItem[i].BorderOuter := TframeStyleEx(fsFlat);
    pnlDioInItem[i].Width       := 93;
    pnlDioInItem[i].Height      := pnlDioInNo[i].Height;
    pnlDioInItem[i].Visible     := True;
    pnlDioInItem[i].Alignment   := taLeftJustify;
    pnlDioInItem[i].Font.Name   := 'Tahoma';
    pnlDioInItem[i].Font.Style  := [fsBold];
    pnlDioInItem[i].Font.Size   := 8;
  end;
  // DIO-OUT ---------------------------
  SetLength(ledDioOut,DefDio.MAX_DIO_CNT);
  SetLength(pnlDioOutNo,DefDio.MAX_DIO_CNT);
  SetLength(pnlDioOutItem,DefDio.MAX_DIO_CNT);
  SetLength(btnDioOut,DefDio.MAX_DIO_CNT);
  nDiv := 32;
  for i := 0 to Pred(DefDio.MAX_DIO_CNT) do begin
    // DioOut - No
    pnlDioOutNo[i]              := TRzPanel.Create(nil);
    pnlDioOutNo[i].Parent       := RzgrpDioOut;
    if i < nDiv then pnlDioOutNo[i].Left   := 4
    else             pnlDioOutNo[i].Left   := 187;
    pnlDioOutNo[i].BevelWidth   := 1;
    pnlDioOutNo[i].FlatColor    := clBlack;
    pnlDioOutNo[i].BorderInner  := TframeStyleEx(fsNone);
    pnlDioOutNo[i].BorderOuter  := TframeStyleEx(fsFlat);
    pnlDioOutNo[i].Width        := 16;
    pnlDioOutNo[i].Height       := 18;
    if i in [0, nDiv] then pnlDioOutNo[i].Top := 16
    else                   pnlDioOutNo[i].Top := pnlDioOutNo[i-1].Top + pnlDioOutNo[i-1].Height + 2;
    pnlDioOutNo[i].Visible      := True;
    pnlDioOutNo[i].Font.Name    := 'Tahoma';
    pnlDioOutNo[i].Font.Style   := [fsBold];
    pnlDioOutNo[i].Font.Size    := 8;
    pnlDioOutNo[i].Caption      := Format('%d',[i]);
    // DioOut - Led
    ledDioOut[i]            := ThhALed.Create(nil);
    ledDioOut[i].Parent     := RzgrpDioOut;
    ledDioOut[i].Left       := pnlDioOutNo[i].Left + pnlDioOutNo[i].Width;
    ledDioOut[i].Top        := pnlDioOutNo[i].Top - 1;
    ledDioOut[i].Height     := 18;
    ledDioOut[i].LEDStyle   := LEDSqLarge;
    ledDioOut[i].FalseColor := clRed;
    ledDioOut[i].TrueColor  := clLime;
    ledDioOut[i].Blink      := False;
    ledDioOut[i].Visible    := True;
    ledDioOut[i].Value      := False;
    // DioOut - Item
    pnlDioOutItem[i]              := TRzPanel.Create(nil);
    pnlDioOutItem[i].Parent       := RzgrpDioOut;
    pnlDioOutItem[i].Left         := ledDioOut[i].Left + ledDioOut[i].Width;
    pnlDioOutItem[i].BevelWidth   := 1;
    pnlDioOutItem[i].Top          := pnlDioOutNo[i].Top;
    pnlDioOutItem[i].FlatColor    := clBlack;
    pnlDioOutItem[i].BorderInner  := TframeStyleEx(fsNone);
    pnlDioOutItem[i].BorderOuter  := TframeStyleEx(fsFlat);
    pnlDioOutItem[i].Width        := 109;
    pnlDioOutItem[i].Height       := pnlDioOutNo[i].Height;
    pnlDioOutItem[i].Visible      := True;
    pnlDioOutItem[i].Alignment    := taLeftJustify;
    pnlDioOutItem[i].Font.Name    := 'Tahoma';
    pnlDioOutItem[i].Font.Style   := [fsBold];
    pnlDioOutItem[i].Font.Size    := 8;
    // DioOut - Button
    btnDioOut[i]            := TRzBitBtn.Create(nil);
    btnDioOut[i].Parent     := RzgrpDioOut;
    btnDioOut[i].Left       := pnlDioOutItem[i].Left + pnlDioOutItem[i].Width + 1;
    btnDioOut[i].Top        := pnlDioOutItem[i].Top;
    btnDioOut[i].Width      := 33;
    btnDioOut[i].Height     := pnlDioOutItem[i].Height;
    btnDioOut[i].OnClick    := btnDioOutClick;
    btnDioOut[i].Visible    := True;
    btnDioOut[i].Font.Name  := 'Tahoma';
    btnDioOut[i].Font.Style := [fsBold];
    btnDioOut[i].Font.Size  := 8;
    btnDioOut[i].Caption    := 'On';
    btnDioOut[i].Tag        := i;
  end;
end;

procedure TfrmMainter.DisplayDioTitle;
var
  arDioInStr  : array of string; //array [0..Pred(DefDio.MAX_DIO_CNT)] of string
  arDioOutStr : array of string; //array [0..Pred(DefDio.MAX_DIO_CNT)] of string
  i : Integer;
begin
  arDioInStr :=
    [  'S1:ReadyBtn'             // 0
      ,'S2:ReadyBtn'
      ,'EMO1-Front'
      ,'EMO2-Right'
      ,'EMO3-In-Right'          // 4
      ,'EMO4-In-Left'
      ,'EMO5-Left'
    {$IFDEF HAS_DIO_IN_DOOR_LOCK}
      ,'S1: Door1 Lock'
      ,'S1: Door2 Lock'         // 8
      ,'S2: Door1 Lock'
      ,'S2: Door2 Lock'
    {$ELSE}
      ,''
      ,''                       // 8
      ,''
      ,''
    {$ENDIF}
      ,'S1: Muting'
      ,'S2: Muting'              // 12
      ,'S1: LightCurtain'
      ,'S2: LightCurtain'
      ,'S1: Key-Auto'
      ,'S1: Key-Teach'           // 16
      ,'S2: Key-Auto'
      ,'S2: Key-Teach'
      ,'S1: Door1'
      ,'S1: Door2'               // 20
      ,'S2: Door1'
      ,'S2: Door2'
      ,'Cylinder-Regul'
      ,'Temperature'       // 24
      ,'Power High'
      ,'MC1'
      ,'S1: Shut UP'
      ,'S1: Shut down'        // 28
      ,'S2: Shut UP'
      ,'S2: Shut down'
    {$IFDEF HAS_DIO_SCREW_SHUTTER} //2022-07-15 A2CHv4_#3(No ScrewShutter)
      ,'S1: S.Shut UP'
      ,'S1: S.Shut down'    // 32
      ,'S2: S.Shut UP'
      ,'S2: S.Shut down'
    {$ELSE}
      ,''
			,''
      ,''                    //32
			,''			
    {$ENDIF}				
    {$IFDEF SUPPORT_1CG2PANEL} //A2CHv3
      ,'ShutGuide UP'
      ,'ShutGuide down'      // 36
      ,'CamZPt UP1'
      ,'CamZPt UP2'
      ,'CamZPt down1'
      ,'CamZPt down2'        // 40
    {$ELSE}
    	{$IFDEF HAS_DIO_FAN_INOUT_PC} //2022-07-15 A2CHv4_#3(FanInOutPC)
			,'Fan In-GPC'
			,'Fan Out-GPC'         // 36
			,'Fan In-DPC'
			,'Fan Out-DPC'									
			{$ELSE}			
      ,''
			,''                    // 36
			,''
			,''
			{$ENDIF}
			,''
			,''                    // 40  
    {$ENDIF}
    {$IFDEF HAS_DIO_EXLIGHT_DETECT}	//2022-07-15 A2CHv4_#3(No ExLightDetectSensor)		
      ,'S1: ExLight Det'
      ,'S2: ExLight Det'
    {$ELSE}
      ,''
			,''
    {$ENDIF}
      ,'S1: Y-Load'
      ,'S2: Y-Load'              // 44
      ,'S1: Vacuum1'
      ,'S1: Vacuum2'
      ,'S2: Vacuum1'
      ,'S2: Vacuum2'             // 48
    {$IFDEF SUPPORT_1CG2PANEL}
      ,'CamZInDr Open'
      ,'CamZInDr Close'
      ,'S1: AssyJig'
      ,'S2: AssyJig'             // 52
    {$ELSE}
      ,'CP1','CP2','CP3','CP6'      // 49,50,51
    {$ENDIF}
      ,'MC2'
      ,'Vacuum-Regul'
    {$IFDEF SUPPORT_1CG2PANEL}
      ,'LoadZPart1'
      ,'LoadZPart2'              // 56
    {$ELSE}
      ,'',''
    {$ENDIF}
      ,'Fan In-Left'             // 57
      ,'Fan In-Right'            // 58
      ,'Fan Out-Left'            // 59
      ,'Fan Out-Right'           // 60
    {$IFDEF HAS_DIO_Y_AXIS_MC}
      ,'S1: YAxis MC'            // 61
      ,'S2: YAxis MC'            // 62
    {$ELSE}
      ,'',''                     // 61,62
    {$ENDIF}
      ,''];                      // 63

  arDioOutStr :=
    [  'S1: ReadyBtn Led'  // 0
      ,'S2: ReadyBtn Led'
      ,'ResetBtn Led'
      ,'S1: Key UnLock'
      ,'S2: Key UnLock'    // 4
      ,'TowerLamp Red'
      ,'TowerLamp Yellow'
      ,'TowerLamp Green'
      ,'Buzzer Melody1'    // 8
      ,'Buzzer Melody2'
      ,'Buzzer Melody3'
      ,'Buzzer Melody4'
      ,''                  // 12
      ,''
      ,'S1: Door1 UnLock'
      ,'S1: Door2 UnLock'
      ,'S2: Door1 UnLock'  // 16
      ,'S2: Door2 UnLock'
      ,'S1: Shutter UP'
      ,'S1: Shutter down'
      ,'S2: Shutter UP'    // 20
      ,'S2: Shutter down'
    {$IFDEF HAS_DIO_SCREW_SHUTTER} //2022-07-15 A2CHv4_#3(No ScrewShutter)
      ,'S1: S.Shut UP'
      ,'S1: S.Shut down'
      ,'S2: S.Shut UP'     // 24
      ,'S2: S.Shut down'
    {$ELSE}
      ,''
			,''
      ,''                  //24
			,''			
    {$ENDIF}			
    {$IFDEF SUPPORT_1CG2PANEL}
      ,'ShutGuide UP'
      ,'ShutGuide down'
    {$ELSE}
      ,'',''
    {$ENDIF}
      ,'S1: Vacuum1'       // 28
      ,'S1: Vacuum2'
      ,'S2: Vacuum1'
      ,'S2: Vacuum2'
      ,'S1: Destruct Sol1' // 32
      ,'S1: Destruct Sol2'
      ,'S2: Destruct Sol1'
      ,'S2: Destruct Sol2'
      ,'S1: Robot Stick+'  // 36
      ,'S1: Robot Stick-'
      ,'S1: Robot M/A'
      ,'S1: Robot Pause'
      ,'S1: Robot Stop'    // 40
      ,'S2: Robot Stick+'
      ,'S2: Robot Stick-'
      ,'S2: Robot M/A'
      ,'S2: Robot Pause'   // 44
      ,'S2: Robot Stop'
      ,'Robot ResetB Led'
    {$IFDEF POCB_A2CHv3}
      ,'AirKnife'          // 47
      ,''                  // 48
    {$ELSE}
      ,'S1:AirKnife'       // 47
      ,'S2:AirKnife'       // 48
    {$ENDIF}
    {$IFDEF HAS_DIO_PG_OFF}
      ,'S1: PG OFF'        // 49
      ,'S2: PG OFF'        // 50
    {$ELSE}
      ,'',''               // 49~50
    {$ENDIF}
    {$IFDEF HAS_DIO_Y_AXIS_MC}
      ,'S1: YAxis MC'      // 51
      ,'S2: YAxis MC'      // 52
    {$ELSE}
      ,'',''               // 51,52
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_STAGE_LAMP}
      ,'S1: S.Lamp OFF'    // 53
      ,'S2: S.Lamp OFF'    // 54
    {$ELSE}
      ,'',''               // 53,54
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_IONBAR}
      ,'S1: IonBar'        // 55
      ,'S2: IonBar'        // 56
    {$ELSE}
      ,'',''               // 55,56
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
  if (not Common.SystemInfo.HasDioScrewShutter) then begin  //2022-07-15 A2CHv4_#3(No ScrewShutter)
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
  //
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
  for i := 0 to Pred(DefDio.MAX_DIO_CNT) do begin
    pnlDioInItem[i].Caption :=  Trim(arDioInStr[i]);
  end;
  for i := 0 to Pred(DefDio.MAX_DIO_CNT) do begin
    pnlDioOutItem[i].Caption :=  Trim(arDioOutStr[i]);
  end;
  tabDioMotor.Caption := 'DIO && Motor Control';
end;

procedure TfrmMainter.ShowMotorRobotMsg(sMsg: string);  //A2CHv3:ROBOT
begin
  if mmMotorRobotRet.Lines.Count > 100 then begin
    mmMotorRobotRet.Lines.Clear;
  end;
  mmMotorRobotRet.DisableAlign;
  mmMotorRobotRet.Lines.Add(sMsg);
  mmMotorRobotRet.Perform(EM_SCROLL,SB_LINEDOWN,0);
  mmMotorRobotRet.EnableAlign;
end;

procedure TfrmMainter.ShowDioOutReadSt(DioOut: ADioStatus);
var
  i : Integer;
begin
  for i := 0 to Pred(DefDio.MAX_DIO_CNT) do begin
    ledDioOut[i].Value := DioOut[i];
    //TBD? if DioOut[i] then btnDioOut[i].Caption := 'Off'
    //TBD? else              btnDioOut[i].Caption := 'On';
  end;
end;

procedure TfrmMainter.ShowDioStatus(DioIn, DioOut: ADioStatus);
var
  i : Integer;
  bEnable : Boolean;
begin
  for i := 0 to Pred(DefDio.MAX_DIO_CNT) do begin
    ledDioIn[i].Value  := DioIn[i];
    ledDioOut[i].Value := DioOut[i];
    if DioOut[i] then btnDioOut[i].Caption := 'off'
    else              btnDioOut[i].Caption := 'ON';
  end;
  // AUTO MODE인 경우, Door Open 방지 (Unlock Enable/Disable)
{$IF Defined(POCB_A2CH)}
  if (ledDioIn[DefDio.IN_TEACH_MODE_SWITCH].Value) then
    btnDioOut[DefDio.OUT_DOOR_UNLOCK].Enabled := True   // Key(Teach)
  else
    btnDioOut[DefDio.OUT_DOOR_UNLOCK].Enabled := False; // Key(Auto)
{$ELSEIF Defined(POCB_A2CHv2)}
  if (ledDioIn[DefDio.IN_LEFT_SWITCH].Value) and (ledDioIn[DefDio.IN_RIGHT_SWITCH].Value) then  //TBD:SAFETY: and? or?
    btnDioOut[DefDio.OUT_DOOR_UNLOCK].Enabled := True   // Key(Teach)
  else
    btnDioOut[DefDio.OUT_DOOR_UNLOCK].Enabled := False; // Key(Auto)
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
  {$IFDEF SUPPORT_1CG2PANEL}
  if (not Common.SystemInfo.UseAssyPOCB) then begin
  {$ENDIF}
    bEnable := ledDioIn[DefDio.IN_STAGE1_KEY_TEACH].Value;
    btnDioOut[DefDio.OUT_STAGE1_MAINT_DOOR1_UNLOCK].Enabled := bEnable;
    btnDioOut[DefDio.OUT_STAGE1_MAINT_DOOR2_UNLOCK].Enabled := bEnable;
    bEnable := ledDioIn[DefDio.IN_STAGE2_KEY_TEACH].Value;
    btnDioOut[DefDio.OUT_STAGE2_MAINT_DOOR1_UNLOCK].Enabled := bEnable;
    btnDioOut[DefDio.OUT_STAGE2_MAINT_DOOR2_UNLOCK].Enabled := bEnable;
  {$IFDEF SUPPORT_1CG2PANEL}
  end
  else begin
    bEnable := ledDioIn[DefDio.IN_STAGE1_KEY_TEACH].Value and ledDioIn[DefDio.IN_STAGE2_KEY_TEACH].Value;
    btnDioOut[DefDio.OUT_STAGE1_MAINT_DOOR1_UNLOCK].Enabled := bEnable;
    btnDioOut[DefDio.OUT_STAGE1_MAINT_DOOR2_UNLOCK].Enabled := bEnable;
    btnDioOut[DefDio.OUT_STAGE2_MAINT_DOOR1_UNLOCK].Enabled := bEnable;
    btnDioOut[DefDio.OUT_STAGE2_MAINT_DOOR2_UNLOCK].Enabled := bEnable;
  end;
  {$ENDIF}
{$ENDIF}
end;

procedure TfrmMainter.btnDioOutClick(Sender: TObject);
var
  sTemp : string;
begin
  sTemp := '>> [DIO-OUT: '+IntToStr((Sender as TRzBitBtn).Tag)+'] Click';
  ShowMotorRobotMsg(sTemp);
  // Fail = 2;
  DongaDio.SetDio((Sender as TRzBitBtn).Tag);
end;

procedure TfrmMainter.btnShuttersAllOpenCh1Click(Sender: TObject);  //A2CHv3:DIO
var
  nCh : Integer;
  bDoorClosed : Boolean;
  sTemp : string;
begin
  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then sTemp := 'Open CH1 All Shutters'
  else                                      sTemp := 'Open CH1/CH2 All Shutters';
  {$ELSE}
  sTemp := 'Open CH1 All Shutters';
  {$ENDIF}
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  nCh := DefPocb.CH_1;
  //
  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)
  else                                      bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},-1{AllDoors});
  {$ELSE}
  bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh);
  {$ENDIF}
  if not bDoorClosed then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Check Doors)');
    Exit;
  end;
	//
  if DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
    ShowMotorRobotMsg(sTemp+' ...Already Opened');
    Exit;
  end;
  //
  DongaDio.SetShutter(nCh,ShutterState.UP);
end;

procedure TfrmMainter.btnShuttersAllCloseCh1Click(Sender: TObject);  //A2CHv3:DIO
var
  nCh : Integer;
  bDoorClosed, bShutterDownable : Boolean;
  sTemp : string;
begin
  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then sTemp := 'Close CH1 All Shutters'
  else                                      sTemp := 'Close CH1/CH2 All Shutters';
  {$ELSE}
  sTemp := 'Close CH1 All Shutters';
  {$ENDIF}
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  nCh := DefPocb.CH_1;
  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)
  else                                      bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},-1{AllDoors});
  {$ELSE}
  bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh);
  {$ENDIF}

  if not bDoorClosed then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Check Doors)');
    Exit;
  end;
  //
  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then bShutterDownable := DongaMotion.CheckMotionPosForShutterDown(nCh)
  else                                      bShutterDownable := DongaMotion.CheckMotionPosForShutterDown(-1{AllCh});
  {$ELSE}
  bShutterDownable := DongaMotion.CheckMotionPosForShutterDown(nCh);
  {$ENDIF}

  if not bShutterDownable then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Stage is NOT Camera Position)');
    Exit;
  end;
  //
  if DongaDio.CheckShutterState(nCh,ShutterState.DOWN) then begin
    ShowMotorRobotMsg(sTemp+' ...Already Closed');
    Exit;
  end;
  //
  DongaDio.SetShutter(nCh,ShutterState.DOWN);
end;

procedure TfrmMainter.btnShuttersAllOpenCh2Click(Sender: TObject);  //A2CHv3:DIO
var
  nCh : Integer;
  sTemp : string;
begin
  sTemp := 'Open CH2 All Shutters';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  {$IFDEF SUPPORT_1CG2PANEL}
  if Common.SystemInfo.UseAssyPOCB then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Not applicable for ASSS_POCB)');
    Exit;
  end;
  {$ENDIF}
  //
  nCh := DefPocb.CH_2;
  if (not DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)) then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Check Doors)');
    Exit;
  end;
  if DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
    ShowMotorRobotMsg(sTemp+' ...Already Opened');
    Exit;
  end;
  //
  DongaDio.SetShutter(nCh,ShutterState.UP);
end;

procedure TfrmMainter.btnShuttersAllCloseCh2Click(Sender: TObject);  //A2CHv3:DIO
var
  nCh : Integer;
  sTemp : string;
begin
  sTemp := 'Close CH2 All Shutters';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  {$IFDEF SUPPORT_1CG2PANEL}
  if Common.SystemInfo.UseAssyPOCB then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Not applicable for ASSS_POCB)');
    Exit;
  end;
  {$ENDIF}

  //
  nCh   := DefPocb.CH_2;
  if (not DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)) then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Check Doors)');
    Exit;
  end;
  //
  if not DongaMotion.CheckMotionPosForShutterDown(nCh) then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Stage is NOT Camera Position)');
    Exit;
  end;
  //
  if DongaDio.CheckShutterState(nCh,ShutterState.DOWN) then begin
    ShowMotorRobotMsg(sTemp+' ...Already Closed');
    Exit;
  end;
  //
  DongaDio.SetShutter(nCh,ShutterState.DOWN);
end;

procedure TfrmMainter.btnStageForwardCh1Click(Sender: TObject);
var
  nCh, nAxis, nMotionID : Integer;
  YaxisMotionAlarmNo : TMotionAlarmNo;
  bDoorClosed : Boolean;
  sTemp, sTemp2 :string;
begin
  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then sTemp := 'CH1 Stage Forward'
  else                                      sTemp := 'CH1/CH2 Stage Forward';
  {$ELSE}
  sTemp := 'CH1 Stage Forward';
  {$ENDIF}
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  nCh   := DefPocb.CH_1;
  nAxis := DefMotion.MOTION_AXIS_Y;
  if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
    Exit;
  end;

  //
  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)
  else                                      bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},-1{AllDoors});
  {$ELSE}
  bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh);
  {$ENDIF}
  if not bDoorClosed then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Check Doors)');
    Exit;
  end;

  //
  {$IFDEF SUPPORT_1CG2PANEL}
  // CamZone Partition/InnerDoor if AssyJig ON
  if DongaMotion.m_bDioAssyJigOn and (not DongaDio.CheckCamZonePartDoor(True{bIsOpen})) then begin
    ShowMotorRobotMsg(sTemp+'...NG(AssyJIG ON - Check CamZone Partition/InnerDoor)');
    Exit;
  end;
  {$ENDIF}

  // Shutter
  if not DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
    sTemp2 := 'Check if Shutter(UP)';
	  {$IFDEF HAS_DIO_SCREW_SHUTTER}	
    if Common.SystemInfo.HasDioScrewShutter then sTemp2 := sTemp2 + '/ScrewShutter(Down)'; //2022-07-15 A2CHv4_#3(No ScrewShutter)
		{$ENDIF}
    {$IFDEF SUPPORT_1CG2PANEL}
    if not Common.SystemInfo.UseAssyPOCB then sTemp2 := sTemp2 + '/ShutterGuide(Down)';
    {$ENDIF}
    ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
    Exit;
  end;

  {$IFDEF HAS_DIO_PINBLOCK}
  // Pinblock Close가 아니면, 움직이면 안됨.
  if (not cbCheckPin_Ch1.Checked) and (not DongaDio.CheckPinBlock(nCh, True)) then begin
    ShowMotorRobotMsg(sTemp+'...NG(Check PinBlock)');
    Exit;
  end;
  {$ENDIF} //HAS_DIO_PINBLOCK

  // Ch1 Y-axis
  Common.GetMotionAlarmNo(nMotionID,YaxisMotionAlarmNo);
  if Common.AlarmList[YaxisMotionAlarmNo.SIG_ALARM_ON].bIsOn then begin
        ShowMotorRobotMsg(sTemp+'...NG(Check Y-Axis Servo Status)');
    Exit;
  end;
  if Common.AlarmList[YaxisMotionAlarmNo.NEED_HOME_SEARCH].bIsOn then begin
    ShowMotorRobotMsg(sTemp+'...NG(Y-Axis Need Home Search)');
    Exit;
  end;
	//
	if not DongaMotion.CheckMotionMovable(nMotionID,sTemp2) then begin
    ShowMotorRobotMsg(sTemp+'...NG('+sTemp2+')');
    Exit;
  end;
  //
  DongaDio.SetAirKnife(nCh,True);  //2022-01-02
  DongaMotion.Motion[nMotionID].MoveFORWARD;
//DongaDio.SetAirKnife(nCh,False); //2022-01-02 by ShowMaintMotionStatus
end;

procedure TfrmMainter.btnStageBackwardCh1Click(Sender: TObject);
var
  nCh, nAxis, nMotionID : Integer;
  YaxisMotionAlarmNo : TMotionAlarmNo;
  bDoorClosed : Boolean;
  sTemp, sTemp2 :string;
begin
  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then sTemp := 'CH1 Stage Forward'
  else                                      sTemp := 'CH1/CH2 Stage Forward';
  {$ELSE}
  sTemp := 'CH1 Stage Forward';
  {$ENDIF}
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  nCh   := DefPocb.CH_1;
  nAxis := DefMotion.MOTION_AXIS_Y;
  if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
    Exit;
  end;

  //
  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)
  else                                      bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},-1{AllDoors});
  {$ELSE}
  bDoorClosed := DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh);
  {$ENDIF} //SUPPORT_1CG2PANEL
  if not bDoorClosed then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Check Doors)');
    Exit;
  end;

  // Shutter
  if not DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
    sTemp2 := 'Check if Shutter(UP)';
	  {$IFDEF HAS_DIO_SCREW_SHUTTER}			
    if Common.SystemInfo.HasDioScrewShutter then sTemp2 := sTemp2 + '/ScrewShutter(Down)'; //2022-07-15 A2CHv4_#3(No ScrewShutter)
    {$ENDIF}											
    {$IFDEF SUPPORT_1CG2PANEL}
    if Common.SystemInfo.UseAssyPOCB then sTemp2 := sTemp2 + '/ShutterGuide(Down)';
    {$ENDIF}
    ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
    Exit;
  end;

  {$IFDEF HAS_DIO_PINBLOCK}
  // Pinblock Close가 아니면, 움직이면 안됨.
  if (not cbCheckPin_Ch1.Checked) and (not DongaDio.CheckPinBlock(nCh, True)) then begin
    ShowMotorRobotMsg(sTemp+'...NG(Check PinBlock)');
    Exit;
  end;
  {$ENDIF} //HAS_DIO_PINBLOCK

  // Ch1 Y-axis
  Common.GetMotionAlarmNo(nMotionID,YaxisMotionAlarmNo);  //TBD:A2CHv3:ASSY-POCB (MOTION? CH2)
  if Common.AlarmList[YaxisMotionAlarmNo.SIG_ALARM_ON].bIsOn then begin
    ShowMotorRobotMsg(sTemp+'...NG(Check Y-Axis Servo Status)');
    Exit;
  end;
  if Common.AlarmList[YaxisMotionAlarmNo.NEED_HOME_SEARCH].bIsOn then begin
    ShowMotorRobotMsg(sTemp+'...NG(Y-Axis Need Home Search)');
    Exit;
  end;
	//
	if not DongaMotion.CheckMotionMovable(nMotionID,sTemp2) then begin
    ShowMotorRobotMsg(sTemp+'...NG('+sTemp2+')');
    Exit;
  end;
  //
  DongaMotion.Motion[nMotionID].MoveBACKWARD;
end;

procedure TfrmMainter.btnStageForwardCh2Click(Sender: TObject);
var
  nCh, nAxis, nMotionID : Integer;
  YaxisMotionAlarmNo : TMotionAlarmNo;
  sTemp, sTemp2 : string;
begin
  sTemp := 'CH2 Stage Forward';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  {$IFDEF SUPPORT_1CG2PANEL}
//if Common.SystemInfo.UseAssyPOCB then begin
//  ShowMotorRobotMsg(sTemp+' ...NG(Not applicable for ASSS_POCB)');
//  Exit;
//end;
  {$ENDIF} //SUPPORT_1CG2PANEL

  nCh   := DefPocb.CH_2;
  nAxis := DefMotion.MOTION_AXIS_Y;
  if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
    Exit;
  end;

  // Doors
  {$IFDEF POCB_A2CH}
  if (not DongaDio.IsDoorClosed(False{bCheckUnderDoor},-1{nCh})) then begin
  {$ELSE}
  if (not DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)) then begin
  {$ENDIF}
    ShowMotorRobotMsg(sTemp+'...NG(Check Doors)');
    Exit;
  end;

  {$IFDEF SUPPORT_1CG2PANEL}
  // CamZone Partition/InnerDoor if AssyJig ON
  if DongaMotion.m_bDioAssyJigOn and (not DongaDio.CheckCamZonePartDoor(True{bIsOpen})) then begin
    ShowMotorRobotMsg(sTemp+'...NG(AssyJIG ON - Check CamZone Partition/InnerDoor)');
    Exit;
  end;
  {$ENDIF} //SUPPORT_1CG2PANEL

  // Shutters
  if not DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
    sTemp2 := 'Check if Shutter(UP)';
	  {$IFDEF HAS_DIO_SCREW_SHUTTER}			
    if Common.SystemInfo.HasDioScrewShutter then sTemp2 := sTemp2 + '/ScrewShutter(Down)'; //2022-07-15 A2CHv4_#3(No ScrewShutter)
    {$ENDIF}											
    {$IFDEF SUPPORT_1CG2PANEL}
    if Common.SystemInfo.UseAssyPOCB then sTemp2 := sTemp2 + '/ShutterGuide(Down)';
    {$ENDIF}
    ShowMotorRobotMsg(sTemp+'...NG('+sTemp2+')');
    Exit;
  end;

  {$IFDEF HAS_DIO_PINBLOCK}
  // Pinblock Close가 아니면, 움직이면 안됨.
  if (not cbCheckPin_Ch2.Checked) and (not DongaDio.CheckPinBlock(nCh, True)) then begin
    ShowMotorRobotMsg(sTemp+'...NG(Check PinBlock)');
    Exit;
  end;
  {$ENDIF} //HAS_DIO_PINBLOCK

  // Ch2 Y-axis
  Common.GetMotionAlarmNo(nMotionID,YaxisMotionAlarmNo);
  if Common.AlarmList[YaxisMotionAlarmNo.SIG_ALARM_ON].bIsOn then begin
    ShowMotorRobotMsg(sTemp+'...NG(Check Y-Axis Servo Status)');
    Exit;
  end;
  if Common.AlarmList[YaxisMotionAlarmNo.NEED_HOME_SEARCH].bIsOn then begin
    ShowMotorRobotMsg(sTemp+'...NG(Y-Axis Need Home Search)');
    Exit;
  end;
	//
	if not DongaMotion.CheckMotionMovable(nMotionID,sTemp2) then begin
    ShowMotorRobotMsg(sTemp+'...NG('+sTemp2+')');
    Exit;
  end;
  //
  DongaDio.SetAirKnife(nCh,True);  //2022-01-02
  DongaMotion.Motion[nMotionID].MoveFORWARD;
//DongaDio.SetAirKnife(nCh,False); //2022-01-02 by ShowMaintMotionStatus
end;

procedure TfrmMainter.btnStageBackwardCh2Click(Sender: TObject);
var
  nCh, nAxis, nMotionID : Integer;
  YaxisMotionAlarmNo : TMotionAlarmNo;
  sTemp, sTemp2 : string;
begin
  sTemp := 'CH2 Stage Backward';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  {$IFDEF SUPPORT_1CG2PANEL}
//if Common.SystemInfo.UseAssyPOCB then begin
//  ShowMotorRobotMsg(sTemp+' ...NG(Not applicable for ASSS_POCB)');
//  Exit;
//end;
  {$ENDIF} //SUPPORT_1CG2PANEL

  //
  nCh   := DefPocb.CH_2;
  nAxis := DefMotion.MOTION_AXIS_Y;
  if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
    Exit;
  end;

  // Doors
  {$IFDEF POCB_A2CH}
  if (not DongaDio.IsDoorClosed(False{bCheckUnderDoor},-1{nCh})) then begin
  {$ELSE}
  if (not DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)) then begin
  {$ENDIF}
    ShowMotorRobotMsg(sTemp+'...NG(Check Doors)');
    Exit;
  end;

  // Shutters
  if not DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
    sTemp2 := 'Check if Shutter(UP)';
	  {$IFDEF HAS_DIO_SCREW_SHUTTER}			
    if Common.SystemInfo.HasDioScrewShutter then sTemp2 := sTemp2 + '/ScrewShutter(Down)'; //2022-07-15 A2CHv4_#3(No ScrewShutter)
    {$ENDIF}									
    {$IFDEF SUPPORT_1CG2PANEL}
    if Common.SystemInfo.UseAssyPOCB then sTemp2 := sTemp2 + '/ShutterGuide(Down)';
    {$ENDIF}
    ShowMotorRobotMsg(sTemp+'...NG('+sTemp2+')');
    Exit;
  end;

  {$IFDEF HAS_DIO_PINBLOCK}
  // Pinblock Close가 아니면, 움직이면 안됨.
  if (not cbCheckPin_Ch2.Checked) and (not DongaDio.CheckPinBlock(nCh, True)) then begin
    ShowMotorRobotMsg(sTemp+'...NG(Check PinBlock)');
    Exit;
  end;
  {$ENDIF} //HAS_DIO_PINBLOCK

  // Ch2 Y-axis
  Common.GetMotionAlarmNo(nMotionID,YaxisMotionAlarmNo);
  if Common.AlarmList[YaxisMotionAlarmNo.SIG_ALARM_ON].bIsOn then begin
    ShowMotorRobotMsg(sTemp+'...NG(Check Y-Axis Servo Status)');
    Exit;
  end;
  if Common.AlarmList[YaxisMotionAlarmNo.NEED_HOME_SEARCH].bIsOn then begin
    ShowMotorRobotMsg(sTemp+'...NG(Y-Axis Need Home Search)');
    Exit;
  end;
	//
	if not DongaMotion.CheckMotionMovable(nMotionID,sTemp2) then begin
    ShowMotorRobotMsg(sTemp+'...NG('+sTemp2+')');
    Exit;
  end;
  //
  DongaMotion.Motion[nMotionID].MoveBACKWARD;
end;

//******************************************************************************
// procedure/function:
//
//******************************************************************************
procedure TfrmMainter.btnExLightCtlOffClick(Sender: TObject);  //2019-04-17 ExLight
var
  nCh, nExCh, nLevel, nChCount, i, j : Integer;
  sTemp : string;
begin
  nCh   := cmbxExLightCtlCh.ItemIndex;
  nExCh := cmbxExLightCtlExCh.ItemIndex;
  nLevel:= 0;  //Off
  //
  sTemp := '>> [ExLight Ch('+IntToStr(nCh)+') ExCh('+IntToStr(nExCh)+') OFF] Click';
  ShowMotorRobotMsg(sTemp);
  //
  if (nCh = -1) or (nExCh = -1) or ((nLevel < 0) or (nLevel > 255)) then Exit;
  //
  nExCh    := nExCh + 1; //Index(0~2) to ExCh(1~3)
  nChCount := Common.SystemInfo.ExLightCh_Count;
  btnExLightCtlOff.Enabled := False;
  if nCh > DefPocb.CH_MAX then begin
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      if nExCh > nChCount then begin
        for j := 1 to nChCount do begin
          DongaExLight.SendExLightChCtrl(i{nCam},j{nExCh},nLevel);
        end
      end
      else begin
        DongaExLight.SendExLightChCtrl(i{nCam},nExCh,nLevel);
      end;
    end;
  end
  else begin
    if nExCh > nChCount then begin
      for j := 1 to nChCount do begin
        DongaExLight.SendExLightChCtrl(nCh{nCam},j{nExCh},nLevel);
      end
    end
    else begin
      DongaExLight.SendExLightChCtrl(nCh{nCam},nExCh,nLevel);
    end;
  end;
  btnExLightCtlOff.Enabled := True;
end;

procedure TfrmMainter.btnExLightCtlOnClick(Sender: TObject);  //2019-04-17 ExLight
var
  nCh, nExCh, nLevel, nChCount , i, j : Integer;
  sTemp : string;
begin
  nCh   := cmbxExLightCtlCh.ItemIndex;
  nExCh := cmbxExLightCtlExCh.ItemIndex;
  nLevel:= StrToIntDef(edExLightCtlLevel.Text,255);
  //
  sTemp := '>> [ExLight Ch('+IntToStr(nCh)+') ExCh('+IntToStr(nExCh)+') Level('+IntToStr(nLevel)+') ON] Click';
  ShowMotorRobotMsg(sTemp);
  //
  if (nCh = -1) or (nExCh = -1) or ((nLevel < 0) or (nLevel > 255)) then Exit;
  //
  nChCount := Common.SystemInfo.ExLightCh_Count;
  nExCh    := nExCh + 1; //Index(0~2) to ExCh(1~3)
  btnExLightCtlOn.Enabled := False;
  if nCh > DefPocb.CH_MAX then begin
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      if nExCh > nChCount then begin
        for j := 1 to nChCount do begin
          DongaExLight.SendExLightChCtrl(i{nCam},j{nExCh},nLevel);
        end
      end
      else begin
        DongaExLight.SendExLightChCtrl(i{nCam},nExCh,nLevel);
      end;
    end;
  end
  else begin
    if nExCh > nChCount then begin
      for j := 1 to nChCount do begin
        DongaExLight.SendExLightChCtrl(nCh{nCam},j{nExCh},nLevel);
      end
    end
    else begin
      DongaExLight.SendExLightChCtrl(nCh{nCam},nExCh,nLevel);
    end;
  end;
  btnExLightCtlOn.Enabled := True;
end;

procedure TfrmMainter.btnExLightCtlSetLevelClick(Sender: TObject); //2019-04-17 ExLight
var
  nCh, nExCh, nLevel, nChCount, i, j : Integer;
  sTemp : string;
begin
  nCh   := cmbxExLightCtlCh.ItemIndex;
  nExCh := cmbxExLightCtlExCh.ItemIndex;
  nLevel:= StrToIntDef(edExLightCtlLevel.Text,255);
  //
  sTemp := '>> [ExLight Ch('+IntToStr(nCh)+') ExCh('+IntToStr(nExCh)+') Level('+IntToStr(nLevel)+') SetLevel] Click';
  ShowMotorRobotMsg(sTemp);
  //
  if (nCh = -1) or (nExCh = -1) or ((nLevel < 0) or (nLevel > 255)) then Exit;
  //
  nExCh    := nExCh + 1; //Index(0~2) to ExCh(1~3)
  nChCount := Common.SystemInfo.ExLightCh_Count;
  btnExLightCtlSetLevel.Enabled := False;
  if nCh > DefPocb.CH_MAX then begin
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      if nExCh > nChCount then begin
        for j := 1 to nChCount do begin
          DongaExLight.SendExLightChCtrl(i{nCam},j{nExCh},nLevel);
        end
      end
      else begin
        DongaExLight.SendExLightChCtrl(i{nCam},nExCh,nLevel);
      end;
    end;
  end
  else begin
    if nExCh > nChCount then begin
      for j := 1 to nChCount do begin
        DongaExLight.SendExLightChCtrl(nCh{nCam},j{nExCh},nLevel);
      end
    end
    else begin
      DongaExLight.SendExLightChCtrl(nCh{nCam},nExCh,nLevel);
    end;
  end;
  btnExLightCtlSetLevel.Enabled := True;
end;

//******************************************************************************
// procedure/function:
//
//******************************************************************************

procedure TfrmMainter.btnIonCtlRunClick(Sender: TObject);
var
  nIonTag, nIonSysIdx : Integer;
  sTemp : string;
begin
  nIonTag := (Sender as TRzBitBtn).Tag;
  if Common.SystemInfo.IonizerCntPerCH = 2 then begin
    nIonSysIdx := nIonTag;
    case nIonTag of
      0: sTemp := 'CH1 Ionizer-1';
      1: sTemp := 'CH1 Ionizer-2';
      2: sTemp := 'CH2 Ionizer-1';
      3: sTemp := 'CH2 Ionizer-2';
      else Exit;
    end;
  end
  else begin
    case nIonTag of
      0: begin nIonSysIdx := 0; sTemp := 'CH1 Ionizer'; end;
      2: begin nIonSysIdx := 1; sTemp := 'CH2 Ionizer'; end;
      else Exit;
    end;
  end;
  ShowMotorRobotMsg('>> ['+sTemp+' ON] Click');
  DaeIonizer[nIonSysIdx].SendMsg(DefIonizer.ION_CMD_RUN,1{nBlowerAddress});
end;

procedure TfrmMainter.btnIonCtlStopClick(Sender: TObject);
var
  nIonTag, nIonSysIdx : Integer;
  sTemp : string;
begin
  nIonTag := (Sender as TRzBitBtn).Tag;
  if Common.SystemInfo.IonizerCntPerCH = 2 then begin
    nIonSysIdx := nIonTag;
    case nIonTag of
      0: sTemp := 'CH1 Ionizer-1';
      1: sTemp := 'CH1 Ionizer-2';
      2: sTemp := 'CH2 Ionizer-1';
      3: sTemp := 'CH2 Ionizer-2';
      else Exit;
    end;
  end
  else begin
    case nIonTag of
      0: begin nIonSysIdx := 0; sTemp := 'CH1 Ionizer'; end;
      2: begin nIonSysIdx := 1; sTemp := 'CH2 Ionizer'; end;
      else Exit;
    end;
  end;
  ShowMotorRobotMsg('>> ['+sTemp+' OFF] Click');
  DaeIonizer[nIonSysIdx].SendMsg(DefIonizer.ION_CMD_STOP,1{nBlowerAddress});
end;

procedure TfrmMainter.cmbxPgNoChange(Sender: TObject);
var
	nCh : Integer;
  PatGrp : TPatternGroup;
begin
  nCh := cmbxPgNo.ItemIndex;
  if not(nCh in [DefPocb.CH_1..DefPocb.CH_2]) then Exit;
  PatGrp := DisplayPatList(Common.TestModelInfo[nCh].PatGrpName);
end;

procedure TfrmMainter.cmbxMotorRobotChNoChange(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  sTemp : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
	
	{$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
	{$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
	{$ENDIF}
  DisplayMotionStatus(nCh,nAxis);
	
  {$IFDEF HAS_ROBOT_CAM_Z}
  DisplayRobotStatus(nCh);
  {$ENDIF}
end;

procedure TfrmMainter.DisplayMotionStatus(nCh: Integer; nAxis: Integer);
var
  nMotionID : Integer;
  sTemp : string;
begin
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  // Current CommandPos
  sTemp := '---';
  if (DongaMotion.Motion[nMotionID].m_bConnected and DongaMotion.Motion[nMotionID].m_bHomeDone) then
    sTemp := Format('%0.2f',[DongaMotion.Motion[nMotionID].m_MotionStatus.CommandPos]);
  pnlMotionCurrCmdPos.Caption := sTemp;
  //
{$IFDEF SUPPORT_1CG2PANEL}
  ShowMaintMotionStatus(nMotionID,DefPocb.MSG_MODE_MOTION_SYNCMODE_GET,0,'');
{$ENDIF}
end;

{$IFDEF HAS_ROBOT_CAM_Z}
procedure TfrmMainter.DisplayRobotStatus(nCh: Integer);  //A2CHv3:ROBOT
var
  nRobot : Integer;
  sTemp  : string;
  bEnableMoveButtons : Boolean;
begin
  nRobot := nCh;
  if DongaRobot.m_bConnectedModbus[nRobot] then begin
    with DongaRobot.Robot[nRobot].m_RobotStatusCoord do begin
      pnlRobotCoordCurX.Caption  := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.X);
      pnlRobotCoordCurY.Caption  := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Y);
      pnlRobotCoordCurZ.Caption  := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Z);
      pnlRobotCoordCurRx.Caption := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Rx);
      pnlRobotCoordCurRy.Caption := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Ry);
      pnlRobotCoordCurRz.Caption := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Rz);
      //
      if RunMode = ROBOT_TM_MB_RUNMODE_AUTO then begin ledRobotAutoMode.Value := True;  ledRobotManualMode.Value := False; end
      else                                       begin ledRobotAutoMode.Value := False; ledRobotManualMode.Value := True;  end;
      ledRobotFatalError.Value   := RobotStatus.FatalError;
      ledRobotProjRunning.Value  := RobotStatus.ProjectRunning;
      ledRobotProjEditing.Value  := RobotStatus.ProjectEditing;
      ledRobotProjPause.Value    := RobotStatus.ProjectPause;
      ledRobotGetControl.Value   := RobotStatus.GetControl;
      ledRobotEStop.Value        := RobotStatus.EStop;
      case CoordState of
        coordHome:  begin ledRobotCoordHome.Value := True;  ledRobotCoordModel.Value := False; end;
        coordModel: begin ledRobotCoordHome.Value := False; ledRobotCoordModel.Value := True;  end;
        else        begin ledRobotCoordHome.Value := False; ledRobotCoordModel.Value := False; end;
      end;
      //
      pnlRobotSpeedValue.Caption := IntToStr(RunSpeed);
      pnlRobotLightValue.Caption := IntToStr(RobotLight);
    end;
  end
  else begin
    sTemp := '---';
    pnlRobotCoordCurX.Caption  := sTemp;
    pnlRobotCoordCurY.Caption  := sTemp;
    pnlRobotCoordCurZ.Caption  := sTemp;
    pnlRobotCoordCurRx.Caption := sTemp;
    pnlRobotCoordCurRy.Caption := sTemp;
    pnlRobotCoordCurRz.Caption := sTemp;
    //
    ledRobotAutoMode.Value     := False;
    ledRobotManualMode.Value   := False;
    ledRobotFatalError.Value   := False;
    ledRobotProjRunning.Value  := False;
    ledRobotProjEditing.Value  := False;
    ledRobotProjPause.Value    := False;
    ledRobotGetControl.Value   := False;
    ledRobotEStop.Value        := False;
    ledRobotCoordHome.Value    := False;
    ledRobotCoordModel.Value   := False;
    //
    pnlRobotSpeedValue.Caption := sTemp;
    pnlRobotLightValue.Caption := sTemp;
  end;
  //
  bEnableMoveButtons := True;
  if (not DongaRobot.m_bConnectedModbus[nRobot]) or (not DongaRobot.m_bConnectedListenNode[nRobot]) then
    bEnableMoveButtons := False
  else if m_bMaintRobotMove then
    bEnableMoveButtons := False;
  DisplayRobotMoveButtons(bEnableMoveButtons);
end;

procedure TfrmMainter.DisplayRobotMoveButtons(bEnable: Boolean); //A2CHv3:ROBOT
begin
  if bEnable then begin
    btnRobotMoveJogDec.Enabled := True;
    btnRobotMoveJogInc.Enabled := True;
    btnRobotMoveRel.Enabled    := True;
    btnRobotMoveHome.Enabled   := True;
    btnRobotMoveModel.Enabled  := True;
    btnRobotTcpCmdSend.Enabled := True;
  end
  else begin
    btnRobotMoveJogDec.Enabled := False;
    btnRobotMoveJogInc.Enabled := False;
    btnRobotMoveRel.Enabled    := False;
    btnRobotMoveHome.Enabled   := False;
    btnRobotMoveModel.Enabled  := False;
    btnRobotTcpCmdSend.Enabled := False;
  end;
end;
{$ENDIF}

//******************************************************************************
// procedure/function:
//    -
//******************************************************************************

procedure TfrmMainter.btnMotionSaveLoadPosClick(Sender: TObject);  //TBD:A2CHv3:MOTION? (SaveMotionPos to SysInfo/Model)
var
	nCh, nAxis, nMotionID : Integer;
  dLoadPos : Double;
  sTemp : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
{$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
{$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
{$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  sTemp := Common.GetStrMotionID2ChAxis(nMotionID) + ' Save LoadPos';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  //TBD:A2CHv3:MOTION? (SaveMotionPos to SysInfo/Model)
  //
  ShowMotorRobotMsg(sTemp+' ...TBD');
end;

procedure TfrmMainter.btnMotionSaveCamPosClick(Sender: TObject);  //TBD:A2CHv3:MOTION? (SaveMotionPos to SysInfo/Model)
var
	nCh, nAxis, nMotionID : Integer;
  dLoadPos : Double;
  sTemp : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
{$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
{$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
{$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  sTemp := Common.GetStrMotionID2ChAxis(nMotionID) + ' Save CamPos';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  //TBD:A2CHv3:MOTION? (SaveMotionPos to SysInfo/Model)
  //
  ShowMotorRobotMsg(sTemp+' ...TBD');
end;

procedure TfrmMainter.btnMotionYAxisSyncOffClick(Sender: TObject); //TBD:A2CHv3:MOTION:SYNC?
var
  nCh, nAxis, nMotionID : Integer;
  sTemp : string;
begin
  sTemp := 'CH1/CH2:Y-Axis SyncMode OFF';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');

  {$IFDEF SUPPORT_1CG2PANEL}
  nCh   := DefPocb.CH_1;
  nAxis := DefMotion.MOTION_AXIS_Y;
  if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
    Exit;
  end;
  // Check if AssyJig is ON
  if (DongaDio.m_nDIValue and DefDio.MASK_IN_STAGE1_JIG_INTERLOCK) <> 0 then begin
    ShowMotorRobotMsg('Check if Assy-JIG is on CH1 Stage !!!');
		Exit;
  end;
  //
  DongaMotion.ResetYAxisSyncMode;
  {$ENDIF} //SUPPORT_1CG2PANEL
end;

procedure TfrmMainter.btnMotionYAxisSyncOnClick(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  sTemp : string;
begin
  sTemp := 'CH1/CH2:Y-Axis SyncMode ON';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');

  {$IFDEF SUPPORT_1CG2PANEL}
	nCh 	:= DefPocb.CH_1;
	nAxis := DefMotion.MOTION_AXIS_Y;
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  // Check if Assy-POCB
  if not Common.SystemInfo.UseAssyPOCB then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Not ASSY-POCB)');
		Exit;
  end;
  //
  DongaMotion.SetYAxisSyncMode;
  {$ENDIF} //SUPPORT_1CG2PANEL
end;

procedure TfrmMainter.btnMotorMoveAbsClick(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  dCmdPos, dVel, dAccel, dStartStop, dTempVel, dTempAccel, dTempStartStop : Double;
  sTemp, sTemp2 : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
{$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
{$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
{$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' MoveABS';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
{$IFDEF POCB_A2CH}
  if (not DongaDio.IsDoorClosed(False{bCheckUnderDoor},-1{nCh})) then begin
{$ELSE}
  if (not DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)) then begin
{$ENDIF}
    ShowMotorRobotMsg(sTemp+' ...NG(Check Doors)');
    Exit;
  end;
  // Shutter
  if (nAxis <> DefMotion.MOTION_AXIS_Z) then begin
    if not DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
      sTemp2 := 'Check if Shutter(UP)';
 	    {$IFDEF HAS_DIO_SCREW_SHUTTER}				
      if Common.SystemInfo.HasDioScrewShutter then sTemp2 := sTemp2 + '/ScrewShutter(Down)'; //2022-07-15 A2CHv4_#3(No ScrewShutter)
      {$ENDIF}										
      {$IFDEF SUPPORT_1CG2PANEL}
      if Common.SystemInfo.UseAssyPOCB then sTemp2 := sTemp2 + '/ShutterGuide(Down)';
      {$ENDIF}
      ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
      Exit;
    end;
  end;
  //
  dCmdPos  := Double(StrToFloatDef(edMotorParamCmdPos.Text,0.0));
  dTempVel := Double(StrToFloatDef(edMotorParamVelocity.Text,1.0));
  if CheckMotionJogVelocityMaxOver(nAxis,dTempVel,dVel) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+Format('Velocity Over: Max=%0.2f',[Common.MotionInfo.JogVelocityMax])+')');
    Exit;
  end;
  dTempAccel := Double(StrToFloatDef(edMotorParamAccel.Text,1.0));
  if CheckMotionJogAccelMaxOver(nAxis,dTempAccel,dAccel) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+Format('Accel Over: Max=%0.2f',[Common.MotionInfo.JogAccelMax])+')');
    Exit;
  end;
  dTempStartStop := Double(StrToFloatDef(edMotorParamStartStopSpeed.Text,0.0));
  if CheckAndGetMotionStartStop(nAxis,dTempStartStop,dStartStop) then begin
    //TBD:MAINTER:LOG? (bIsMaxOver=True)
  end;
  DongaMotion.Motion[nMotionID].MoveABS(DefPocb.MSG_MODE_MOTION_MOVE_ABS,dCmdPos,dVel,dAccel,dStartStop);
end;

procedure TfrmMainter.btnMotorMoveDecIncClick(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  dMovePos, dVel, dAccel, dStartStop, dTempVel, dTempAccel, dTempStartStop : Double;
  bIsPlus : Boolean;
  sTemp, sTemp2 : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
{$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
{$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
{$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  //
  if (Sender as TRzBitBtn).Tag = 0 then bIsPlus := False //DEC
  else                                  bIsPlus := True; //INC
  if bIsPlus then sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' MoveINC'
  else            sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' MoveDEC';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  // Doors
{$IFDEF POCB_A2CH}
  if (not DongaDio.IsDoorClosed(False{bCheckUnderDoor},-1{nCh})) then begin
{$ELSE}
  if (not DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)) then begin
{$ENDIF}
    ShowMotorRobotMsg(sTemp+' ...NG(Check Doors)');
    Exit;
  end;
  // Shutter
  if (nAxis <> DefMotion.MOTION_AXIS_Z) then begin
    if not DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
      sTemp2 := 'Check if Shutter(UP)';
  	  {$IFDEF HAS_DIO_SCREW_SHUTTER}				
      if Common.SystemInfo.HasDioScrewShutter then sTemp2 := sTemp2 + '/ScrewShutter(Down)'; //2022-07-15 A2CHv4_#3(No ScrewShutter)
      {$ENDIF}										
      {$IFDEF SUPPORT_1CG2PANEL}
      if Common.SystemInfo.UseAssyPOCB then sTemp2 := sTemp2 + '/ShutterGuide(Down)';
      {$ENDIF}
      ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
      Exit;
    end;
  end;
  //
  if bIsPlus then dMovePos := Double(StrToFloatDef(edMotorParamCmdPos.Text,1.0))
  else            dMovePos := Double(StrToFloatDef(edMotorParamCmdPos.Text,1.0)*-1);
  dTempVel := Double(StrToFloatDef(edMotorParamVelocity.Text,1.0));
  if CheckMotionJogVelocityMaxOver(nAxis,dTempVel,dVel) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+Format('Velocity Over: Max=%0.2f',[Common.MotionInfo.JogVelocityMax])+')');
    Exit;
  end;
  dTempAccel := Double(StrToFloatDef(edMotorParamAccel.Text,1.0));
  if CheckMotionJogAccelMaxOver(nAxis,dTempAccel,dAccel) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+Format('Accel Over: Max=%0.2f',[Common.MotionInfo.JogAccelMax])+')');
    Exit;
  end;
  dTempStartStop := Double(StrToFloatDef(edMotorParamStartStopSpeed.Text,0.0));
  if CheckAndGetMotionStartStop(nAxis,dTempStartStop,dStartStop) then begin
    //TBD:MAINTER:LOG? (bIsMaxOver=True)
  end;
  DongaMotion.Motion[nMotionID].MoveINC(dMovePos,dVel,dAccel,dStartStop);
end;

procedure TfrmMainter.btnMotorMoveJogDecMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MotorMoveJogMouseDown(Sender);
end;

procedure TfrmMainter.btnMotorMoveJogDecMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MotorMoveJogMouseUp(Sender);
end;

procedure TfrmMainter.btnMotorMoveJogIncMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MotorMoveJogMouseDown(Sender);
end;

procedure TfrmMainter.btnMotorMoveJogIncMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MotorMoveJogMouseUp(Sender);
end;

procedure TfrmMainter.MotorMoveJogMouseDown(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  dJogVel, dJogAccel, dTempJogVel, dTempJogAccel : Double;
  bIsPlus : Boolean;
  sTemp, sTemp2 : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
{$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
{$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
{$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  if (Sender as TRzBitBtn).Tag = 0 then bIsPlus := False
  else                                  bIsPlus := True;
  if bIsPlus then sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' MoveJOG+'
  else            sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' MoveJOG-';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  // Doors
{$IFDEF POCB_A2CH}
  if (not DongaDio.IsDoorClosed(False{bCheckUnderDoor},-1{nCh})) then begin
{$ELSE}
  if (not DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)) then begin
{$ENDIF}
    ShowMotorRobotMsg(sTemp+' ...NG(Check Doors)');
    Exit;
  end;
  // Shutter
  if (nAxis <> DefMotion.MOTION_AXIS_Z) then begin
    if not DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
      sTemp2 := 'Check if Shutter(UP)';
  	  {$IFDEF HAS_DIO_SCREW_SHUTTER}				
      if Common.SystemInfo.HasDioScrewShutter then sTemp2 := sTemp2 + '/ScrewShutter(Down)'; //2022-07-15 A2CHv4_#3(No ScrewShutter)
      {$ENDIF}										
      {$IFDEF SUPPORT_1CG2PANEL}
      if Common.SystemInfo.UseAssyPOCB then sTemp2 := sTemp2 + '/ShutterGuide(Down)';
      {$ENDIF}
      ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
      Exit;
    end;
  end;
  //
  dTempJogVel   := Double(StrToFloatDef(edMotorJogVelocity.Text,1.0));
  if CheckMotionJogVelocityMaxOver(nAxis,dTempJogVel,dJogVel) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+Format('Velocity Over: Max=%0.2f',[Common.MotionInfo.JogVelocityMax])+')');
    Exit;
  end;
  dTempJogAccel := Double(StrToFloatDef(edMotorJogAccel.Text,1.0));
  if CheckMotionJogAccelMaxOver(nAxis,dTempJogAccel,dJogAccel) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+Format('Accel Over: Max=%0.2f',[Common.MotionInfo.JogAccelMax])+')');
    Exit;
  end;
  DongaMotion.Motion[nMotionID].MoveJOG(bIsPlus,dJogVel,dJogAccel); //2019-02-13
end;

procedure TfrmMainter.MotorMoveJogMouseUp(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  bIsPlus : Boolean;
  sTemp   : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
{$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
{$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
{$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  //
  if (Sender as TRzBitBtn).Tag = 0 then bIsPlus := False //DEC
  else                                  bIsPlus := True; //INC
  if bIsPlus then sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' MoveJOG+'
  else            sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' MoveJOG-';
//ShowMotorRobotMsg('>> ['+sTemp+'] Mouse UP');
  //
  DongaMotion.Motion[nMotionID].MoveStop(False{bIsEMS});  //TBD:MOTION? (Stop or E-Stop for JOG)
end;

procedure TfrmMainter.btnMotorMoveLimitClick(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  dJogVel, dJogAccel, dTempJogVel, dTempJogAccel : Double;
  bIsPlus : Boolean;
  sTemp, sTemp2 : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
{$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
{$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
{$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  //
  if (Sender as TRzBitBtn).Tag = 0 then bIsPlus := False
  else                                  bIsPlus := True;
  if bIsPlus then sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' MoveLIMIT+'
  else            sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' MoveLIMIT-';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  // Doors
{$IFDEF POCB_A2CH}
  if (not DongaDio.IsDoorClosed(False{bCheckUnderDoor},-1{nCh})) then begin
{$ELSE}
  if (not DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)) then begin
{$ENDIF}
    ShowMotorRobotMsg(sTemp+' ...NG(Check Doors)');
    Exit;
  end;
  // Shutter
  if (nAxis <> DefMotion.MOTION_AXIS_Z) then begin
    if not DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
      sTemp2 := 'Check if Shutter(UP)';
  	  {$IFDEF HAS_DIO_SCREW_SHUTTER}				
      if Common.SystemInfo.HasDioScrewShutter then sTemp2 := sTemp2 + '/ScrewShutter(Down)'; //2022-07-15 A2CHv4_#3(No ScrewShutter)
      {$ENDIF}										
      {$IFDEF SUPPORT_1CG2PANEL}
      if Common.SystemInfo.UseAssyPOCB then sTemp2 := sTemp2 + '/ShutterGuide(Down)';
      {$ENDIF}
      ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
      Exit;
    end;
  end;
  //
  dTempJogVel   := Double(StrToFloatDef(edMotorJogVelocity.Text,1.0));
  if CheckMotionJogVelocityMaxOver(nAxis,dTempJogVel,dJogVel) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+Format('Velocity Over: Max=%0.2f',[Common.MotionInfo.JogVelocityMax])+')');
    Exit;
  end;
  dTempJogAccel := Double(StrToFloatDef(edMotorJogAccel.Text,1.0));
  if CheckMotionJogAccelMaxOver(nAxis,dTempJogAccel,dJogAccel) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+Format('Accel Over: Max=%0.2f',[Common.MotionInfo.JogAccelMax])+')');
    Exit;
  end;
  DongaMotion.Motion[nMotionID].MoveLIMIT(bIsPlus,dJogVel,dJogAccel);
end;

procedure TfrmMainter.btnMotorOriginClick(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  sTemp, sTemp2 : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
{$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
{$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
{$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  //
  sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' MoveHOME';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  // Doors
{$IFDEF POCB_A2CH}
  if (not DongaDio.IsDoorClosed(False{bCheckUnderDoor},-1{nCh})) then begin
{$ELSE}
  if (not DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)) then begin
{$ENDIF}
    ShowMotorRobotMsg(sTemp+' ...NG(Check Doors)');
    Exit;
  end;
  // Shutter
  if (nAxis <> DefMotion.MOTION_AXIS_Z) then begin
    if not DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
      sTemp2 := 'Check if Shutter(UP)';
  	  {$IFDEF HAS_DIO_SCREW_SHUTTER}				
      if Common.SystemInfo.HasDioScrewShutter then sTemp2 := sTemp2 + '/ScrewShutter(Down)'; //2022-07-15 A2CHv4_#3(No ScrewShutter)
      {$ENDIF}							
      {$IFDEF SUPPORT_1CG2PANEL}
      if Common.SystemInfo.UseAssyPOCB then sTemp2 := sTemp2+ '/ShutterGuide(Down)';
      {$ENDIF}
      ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
      Exit;
    end;
  end;
  //
  DongaMotion.Motion[nMotionID].MoveHOME;
end;

procedure TfrmMainter.btnMotorOriginAllClick(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  sTemp, sTemp2 : string;
  bShutterDoorOK : Boolean;
begin
  sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' MoveHOME-ALL';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  bShutterDoorOK := True;
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
{$IFDEF HAS_ROBOT_CAM_Z}
    for nAxis := DefMotion.MOTION_AXIS_Y to DefMotion.MOTION_AXIS_Y do
{$ELSE}
    for nAxis := DefMotion.MOTION_AXIS_Y to DefMotion.MOTION_AXIS_Z do
{$ENDIF}
    begin
      if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then Continue;
      // Doors
{$IFDEF POCB_A2CH}
      if (not DongaDio.IsDoorClosed(False{bCheckUnderDoor},-1)) then
{$ELSE}
      if (not DongaDio.IsDoorClosed(True{bCheckUnderDoor},nCh)) then
{$ENDIF}
      begin
        sTemp2 := 'Check CH'+IntToStr(nCh+1)+' Doors';
        ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
        bShutterDoorOK := False;
		    break;
      end;
      // Shutters
      if not DongaDio.CheckShutterState(nCh,ShutterState.UP) then begin
        sTemp2 := 'Check if Shutter(UP)';
    	  {$IFDEF HAS_DIO_SCREW_SHUTTER}					
        if Common.SystemInfo.HasDioScrewShutter then sTemp2 := sTemp2 + '/ScrewShutter(Down)'; //2022-07-15 A2CHv4_#3(No ScrewShutter)
        {$ENDIF}				
        {$IFDEF SUPPORT_1CG2PANEL}
        if Common.SystemInfo.UseAssyPOCB then sTemp2 := sTemp2 + '/ShutterGuide(Down)';
        {$ENDIF}
        ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
        bShutterDoorOK := False;
		    break;
      end;
    end;
  end;
  if bShutterDoorOK then begin
    for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      {$IFDEF HAS_ROBOT_CAM_Z}
      for nAxis := DefMotion.MOTION_AXIS_Y to DefMotion.MOTION_AXIS_Y do
      {$ELSE}
      for nAxis := DefMotion.MOTION_AXIS_Y to DefMotion.MOTION_AXIS_Z do
      {$ENDIF}
      begin
        DongaMotion.Motion[nMotionID].MoveHOME;
      end;
    end;
  end;
end;

procedure TfrmMainter.btnMotorStopClick(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  sTemp : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
  {$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
  {$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
  {$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  //
  sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' STOP';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  DongaMotion.Motion[nMotionID].MoveStop(False{bIsEMS});
  ShowMotorRobotMsg(sTemp+' ...OK');
end;

procedure TfrmMainter.btnMotorStopEmsClick(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  sTemp : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
  {$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
  {$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
  {$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  //
  sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' E-STOP';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  DongaMotion.Motion[nMotionID].MoveStop(True{bIsEMS});
  ShowMotorRobotMsg(sTemp+' ...OK');
end;

procedure TfrmMainter.btnMotorStopEmsAllClick(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  sTemp : string;
begin
  sTemp := 'MOTION E-STOP ALL';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    {$IFDEF HAS_ROBOT_CAM_Z}
    for nAxis := DefMotion.MOTION_AXIS_Y to DefMotion.MOTION_AXIS_Y do begin
    {$ELSE}
    for nAxis := DefMotion.MOTION_AXIS_Y to DefMotion.MOTION_AXIS_Z do begin
    {$ENDIF}
      if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then Continue;
      DongaMotion.Motion[nMotionID].MoveStop(True{bIsEMS});
    end;
	end;
  ShowMotorRobotMsg(sTemp+' ...OK');
end;

procedure TfrmMainter.btnMotorServoOnClick(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  sTemp : string;
begin
  nCh 	:= cmbxMotorRobotChNo.ItemIndex;
  {$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
  {$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
  {$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' Servo ON';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  DongaMotion.Motion[nMotionID].ServoOnOff(True{bIsOn});
  ShowMotorRobotMsg(sTemp+' ...OK');
end;

procedure TfrmMainter.btnMotorServoOffClick(Sender: TObject);
var
	nCh, nAxis, nMotionID : Integer;
  sTemp : string;
begin
	nCh 	:= cmbxMotorRobotChNo.ItemIndex;
  {$IFDEF HAS_MOTION_CAM_Z}
	nAxis := cmbxMotorAxis.ItemIndex;
  {$ELSE}
	nAxis := DefMotion.MOTION_AXIS_Y;
  {$ENDIF}
	if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
		Exit;
	end;
  sTemp := Common.GetStrMotionID2ChAxis(nMotionID)+ ' Servo OFF';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  DongaMotion.Motion[nMotionID].ServoOnOff(False{bIsOn});
  ShowMotorRobotMsg(sTemp+' ...OK');
end;

procedure TfrmMainter.ShowMaintMotionStatus(nMotionID, nMode, nErrCode: Integer; sMsg: String);
var
	nCh, nAxis, nMaintMotionID : Integer;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<MAINTER> ShowMaintMotionStatus: '+sMsg,DefPocb.DEBUG_LEVEL_INFO);
  case nMode of
    DefPocb.MSG_MODE_MOTION_GET_CMD_POS: begin  //2019-01-19
  	  nCh 	:= cmbxMotorRobotChNo.ItemIndex;
      {$IFDEF HAS_MOTION_CAM_Z}
    	nAxis := cmbxMotorAxis.ItemIndex;
      {$ELSE}
  	  nAxis := DefMotion.MOTION_AXIS_Y;
      {$ENDIF}
      if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMaintMotionID)) then begin
		    Exit;
  	  end;
      if nMotionID = nMaintMotionID then begin
        pnlMotionCurrCmdPos.Caption := Format('%0.2f',[DongaMotion.Motion[nMotionID].m_MotionStatus.CommandPos]);
      end;
      Exit;
    end;

    {$IFDEF SUPPORT_1CG2PANEL}
    DefPocb.MSG_MODE_MOTION_SYNCMODE_GET: begin //TBD:A2CHv3:MOTION:SYNC?
  	  nCh 	:= DefPocb.CH_1;
  	  nAxis := DefMotion.MOTION_AXIS_Y;
      if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMaintMotionID)) then begin
		    Exit;
  	  end;
      case DongaMotion.Motion[nMaintMotionID].m_MotionStatus.nSyncStatus of
        DefMotion.SyncLinkMaster, DefMotion.SyncLinkSlave, DefMotion.SyncGantryMaster, DefMotion.SyncGantrySlave: begin
          pnlMotionYAxisSyncMode.Color  := clLime;
          btnMotionYAxisSyncOn.Enabled  := False;
          if DongaMotion.m_bDioAssyJigOn then btnMotionYAxisSyncOff.Enabled := False
          else                                btnMotionYAxisSyncOff.Enabled := True;
          //
          RzgrpStageMoveCh1.Caption := 'CH1/CH2';
          btnStageForwardCh1.Enabled  := True;
          btnStageBackwardCh1.Enabled := True;
          btnShuttersAllOpenCh1.Visible  := True;
          btnShuttersAllCloseCh1.Visible := True;
          //
          RzgrpStageMoveCh2.Visible := False;
        end;
        else {DefMotion.SyncNone:} begin
          pnlMotionYAxisSyncMode.Color  := clBtnFace;
          btnMotionYAxisSyncOn.Enabled  := True;
          btnMotionYAxisSyncOff.Enabled := False;
          //
          RzgrpStageMoveCh1.Caption := 'CH1';
        //btnShuttersAllOpenCh1.Visible  := True;
        //btnShuttersAllCloseCh1.Visible := True;
          RzgrpStageMoveCh2.Visible := True;
          //
          if DongaMotion.m_bDioAssyJigOn then begin
            btnStageForwardCh1.Enabled  := False;
            btnStageBackwardCh1.Enabled := False;
            btnStageForwardCh2.Enabled  := False;
            btnStageBackwardCh2.Enabled := False;
          end
          else begin
            btnStageForwardCh1.Enabled  := True;
            btnStageBackwardCh1.Enabled := True;
            btnStageForwardCh2.Enabled  := True;
            btnStageBackwardCh2.Enabled := True;
          end;
          //
          if Common.SystemInfo.UseAssyPOCB then begin
            btnShuttersAllOpenCh1.Visible  := False;
            btnShuttersAllCloseCh1.Visible := False;
            btnShuttersAllOpenCh2.Visible  := False;
            btnShuttersAllCloseCh2.Visible := False;
          end;
        end;
       {else begin
          pnlMotionYAxisSyncMode.Color  := clGray;
          btnMotionYAxisSyncOn.Enabled  := False;
          btnMotionYAxisSyncOff.Enabled := False;
          //
          RzgrpStageMoveCh1.Visible := False;
          RzgrpStageMoveCh2.Visible := False;
          //
          btnStageForwardCh1.Enabled  := False;
          btnStageBackwardCh1.Enabled := False;
          btnStageForwardCh2.Enabled  := False;
          btnStageBackwardCh2.Enabled := False;
        end; }
      end;
      Exit;
    end;
    {$ENDIF} //SUPPORT_1CG2PANEL
  end;
  if sMsg <> '' then begin
    // mmMotorRobotRet
    if mmMotorRobotRet.Lines.Count > 100 then begin
      mmMotorRobotRet.Lines.Clear;
    end;
    mmMotorRobotRet.DisableAlign;
    mmMotorRobotRet.Lines.Add(sMsg);
    mmMotorRobotRet.Perform(EM_SCROLL,SB_LINEDOWN,0);
    mmMotorRobotRet.EnableAlign;
  end;

  //2022-01-02
  if sMsg.Contains('MoveFORWARD') and (not sMsg.Contains('START')) then begin
    if (not DongaMotion.GetMotionID2ChAxis(nMotionID,nCh,nAxis)) then Exit;
    DongaDio.SetAirKnife(nCh,False); // AirKnife Off
  end;
end;

//******************************************************************************
// procedure/function: Tab: DIO and Motion Control
//    - function TfrmMainter.CheckAndGetMotionVelocity(nAxis: Integer; dTempVel: Double; var dVel: Double): Boolean;
//    - function TfrmMainter.CheckAndGetMotionAccelation(nAxis: Integer; dTempAccel: Double; var dAccel: Double): Boolean;
//    - function TfrmMainter.CheckAndGetMotionStartStop(nAxis: Integer; dTempStartStop: Double; var dStartStop: Double): Boolean;
//    - function TfrmMainter.CheckAndGetMotionJogVelocity(nAxis: Integer; dTempJogVel: Double; var dJogVel: Double): Boolean;
//    - function TfrmMainter.CheckAndGetMotionJogAccel(nAxis: Integer; dTempJogAccel: Double; var dJogAccel: Double): Boolean;
//******************************************************************************

procedure TfrmMainter.edMotorParamAccelChange(Sender: TObject);
var
  dAccel : Double;
begin
  dAccel := Double(StrToFloatDef(edMotorParamAccel.Text,1.0));
  if dAccel > DefMotion.AxMC_JOG_ACCEL_MAX then begin
    edMotorParamAccel.Text := Format('%0.2f',[DefMotion.AxMC_JOG_ACCEL_MAX]);
  end;
end;

procedure TfrmMainter.edMotorParamVelocityChange(Sender: TObject);
var
  dVelocity : Double;
begin
  dVelocity := Double(StrToFloatDef(edMotorParamVelocity.Text,1.0));
  if dVelocity > DefMotion.AxMC_JOG_VELOCITY_MAX then begin
    edMotorParamVelocity.Text := Format('%0.2f',[DefMotion.AxMC_JOG_VELOCITY_MAX]);
  end;
end;

procedure TfrmMainter.edMotorJogAccelChange(Sender: TObject);
var
  dAccel : Double;
begin
  dAccel := Double(StrToFloatDef(edMotorJogAccel.Text,1.0));
  if dAccel > DefMotion.AxMC_JOG_ACCEL_MAX then begin
    edMotorJogAccel.Text := Format('%0.2f',[DefMotion.AxMC_JOG_ACCEL_MAX]);
  end;
end;

procedure TfrmMainter.edMotorJogVelocityChange(Sender: TObject);
var
  dVelocity : Double;
begin
  dVelocity := Double(StrToFloatDef(edMotorJogVelocity.Text,1.0));
  if dVelocity > DefMotion.AxMC_JOG_VELOCITY_MAX then begin
    edMotorJogVelocity.Text := Format('%0.2f',[DefMotion.AxMC_JOG_VELOCITY_MAX]);
  end;
end;

function TfrmMainter.CheckAndGetMotionStartStop(nAxis: Integer; dTempStartStop: Double; var dStartStop: Double): Boolean;
var
  bIsMaxOver : Boolean;
begin
  dStartStop := dTempStartStop;
  bIsMaxOver := False;
  case nAxis of
    DefMotion.MOTION_AXIS_Y: begin
      if dTempStartStop > Common.MotionInfo.YaxisStartStopSpeedMax then begin
        dStartStop := Common.MotionInfo.YaxisStartStopSpeedMax;
        bIsMaxOver := True;
      end;
    end;
{$IFDEF HAS_MOTION_CAM_Z}
    DefMotion.MOTION_AXIS_Z: begin
      if dTempStartStop > Common.MotionInfo.ZaxisStartStopSpeedMax then begin
        dStartStop := Common.MotionInfo.ZaxisStartStopSpeedMax;
        bIsMaxOver := True;
      end;
    end;
{$ENDIF}
  end;
  Result := bIsMaxOver;
end;

function TfrmMainter.CheckMotionJogVelocityMaxOver(nAxis: Integer; dTempJogVel: Double; var dJogVel: Double): Boolean;
var
  bIsMaxOver : Boolean;
  JogVelMax  : Double;
begin
  JogVelMax := Common.MotionInfo.JogVelocityMax;
  if dTempJogVel > JogVelMax then begin
    dJogVel    := JogVelMax;
    bIsMaxOver := True;
  end
  else begin
    dJogVel    := dTempJogVel;
    bIsMaxOver := False;
  end;
  Result := bIsMaxOver;
end;

function TfrmMainter.CheckMotionJogAccelMaxOver(nAxis: Integer; dTempJogAccel: Double; var dJogAccel: Double): Boolean;
var
  bIsMaxOver : Boolean;
  JogAccMax  : Double;
begin
  JogAccMax := Common.MotionInfo.JogAccelMax;
  if dTempJogAccel > JogAccMax then begin
    dJogAccel  := JogAccMax;
    bIsMaxOver := True;
  end
  else begin
    dJogAccel  := dTempJogAccel;
    bIsMaxOver := False;
  end;
  Result := bIsMaxOver;
end;

{$IFDEF HAS_ROBOT_CAM_Z}
//******************************************************************************
// procedure/function: ROBOT
//
//******************************************************************************

procedure TfrmMainter.btnRobotSaveHomeCoordClick(Sender: TObject);  //TBD:A2CHv3:ROBOT? (SaveCoord to SysInfo/Model)
var
  nCh, nRobot : Integer;
  sTemp  : string;
begin
  nCh := cmbxMotorRobotChNo.ItemIndex;
  nRobot := nCh;
  if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  //
  sTemp := Format('CH%d:ROBOT: Save HomeCoord',[nCh+1]);;
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  ShowMotorRobotMsg(sTemp+' ...TBD');
end;

procedure TfrmMainter.btnRobotSaveModelCoordClick(Sender: TObject);  //TBD:A2CHv3:ROBOT? (SaveCoord to SysInfo/Model
var
  nCh, nRobot : Integer;
  sTemp  : string;
  CoordRelative : TRobotCoord;
begin
  nCh := cmbxMotorRobotChNo.ItemIndex;
  nRobot := nCh;
  if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  //
  sTemp := Format('CH%d:ROBOT: Save ModelCoord',[nCh+1]);;
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  ShowMotorRobotMsg(sTemp+' ...TBD');
end;

procedure TfrmMainter.btnRobotMoveJogDecMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  RobotMoveJogMouseDown(Sender);
end;

procedure TfrmMainter.btnRobotMoveJogDecMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  RobotMoveJogMouseUp(Sender);
end;

procedure TfrmMainter.btnRobotMoveJogIncMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  RobotMoveJogMouseDown(Sender);
end;

procedure TfrmMainter.btnRobotMoveJogIncMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);  //TBD:A2CHv3:ROBOT? (Check if Robot Movable?)
begin
  RobotMoveJogMouseUp(Sender);
end;

procedure TfrmMainter.RobotMoveJogMouseDown(Sender: TObject);  //TBD:A2CHv3:ROBOT? (Check if Robot Movable?, MoveJOG)
var
  nCh    : Integer;
  nRobot : Integer;
  RobotJog     : TRobotJog;
  enumDistance : enumRobotJogDistance;
  nValue : Single;
  sTemp, sTemp2 : string;
begin
  nCh := cmbxMotorRobotChNo.ItemIndex;
  nRobot := nCh;
  if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  //
  if (Sender as TRzBitBtn).Tag = 0 then RobotJog.bIsPlus := False
  else                                  RobotJog.bIsPlus := True;
  if RobotJog.bIsPlus then sTemp := Format('CH%d:ROBOT: MoveJOG+',[nCh+1])
  else                     sTemp := Format('CH%d:ROBOT: MoveJOG-',[nCh+1]);
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  // Check if Robot can move (DIO, RobotCOnnection, RobotStatus)
	if not DongaRobot.Robot[nRobot].CheckRobotMovable(sTemp2) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
    Exit;
	end;
	//
  RobotJog.nCoordAttr := enumRobotCoordAttr(radioRobotCoordJogSelect.ItemIndex);
  if (RobotJog.nCoordAttr < Coord_X) or (RobotJog.nCoordAttr > Coord_Rz) then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Select R/Y/Z/Rx/Ry/Rz)');
    Exit;
  end;
  enumDistance := enumRobotJogDistance(cmbxRobotCoordJogDistance.ItemIndex);
  case enumDistance of
    JogDistance_0_01:     RobotJog.nDistance := 0.01;
    JogDistance_0_05:     RobotJog.nDistance := 0.05;
    JogDistance_0_1:      RobotJog.nDistance := 0.1;
    JogDistance_0_5:      RobotJog.nDistance := 0.5;
    JogDistance_1_0:      RobotJog.nDistance := 1.0;
    JogDistance_5_0:      RobotJog.nDistance := 5.0;
    JogDistance_10_0:     RobotJog.nDistance := 10.0;
    JogDistance_Continue: RobotJog.nDistance := 0.01; //TBD????
    else begin
      ShowMotorRobotMsg(sTemp+' ...NG(Select Distance)');
      Exit;
    end;
  end;
  //
  m_bMaintRobotMove := True;
//DisplayRobotMoveButtons(False); //bEnable
  //
  ThreadTask(procedure
  begin
    try
      if RobotJog.bIsPlus then nValue := RobotJog.nDistance else nValue := (0 - RobotJog.nDistance);
      sTemp2 := Common.GetRobotCoordAttrStr(RobotJog.nCoordAttr)+', '+FormatFloat(ROBOT_FORMAT_COORD2,nValue);
    //ShowMotorRobotMsg(sTemp+' ('+sTemp2+') ...start');
      //
      DongaRobot.Robot[nRobot].MoveJOG(RobotJog);
    finally
      m_bMaintRobotMove := False;  //TBD:A2CHv3:ROBOT (MoveJOG)
      DisplayRobotMoveButtons(True); //bEnable
    //ShowMotorRobotMsg(sTemp+' ('+sTemp2+') ...end');  //TBD:A2CHv3:ROBOT (MoveJOG)
    end;
  end, btnRobotMoveJogInc);
end;

procedure TfrmMainter.RobotMoveJogMouseUp(Sender: TObject);  //TBD:A2CHv3:ROBOT? (Check if Robot Movable?, MoveJOG)
var
  nCh, nRobot : Integer;
  sTemp, sTemp2 : string;
  RobotJog     : TRobotJog;
  enumDistance : enumRobotJogDistance;
  nValue : Single;
begin
  nCh := cmbxMotorRobotChNo.ItemIndex;
  nRobot := nCh;
  if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  //
  if (Sender as TRzBitBtn).Tag = 0 then RobotJog.bIsPlus := False
  else                                  RobotJog.bIsPlus := True;
  if RobotJog.bIsPlus then sTemp := Format('CH%d:ROBOT: MoveJOG+',[nCh+1])
  else                     sTemp := Format('CH%d:ROBOT: MoveJOG-',[nCh+1]);
//ShowMotorRobotMsg('>> ['+sTemp+'] Mouse Button UP');  //TBD:A2CHv3:ROBOT? (MoveJOG)
  //
  if RobotJog.bIsPlus then nValue := RobotJog.nDistance else nValue := (0 - RobotJog.nDistance);
  sTemp2 := Common.GetRobotCoordAttrStr(RobotJog.nCoordAttr)+', '+FormatFloat(ROBOT_FORMAT_COORD2,nValue);
//ShowMotorRobotMsg(sTemp+' ('+sTemp2+') ...end');  //TBD:A2CHv3:ROBOT (MoveJOG)
  //
  m_bMaintRobotMove := False;
  DisplayRobotMoveButtons(True); //bEnable
end;

procedure TfrmMainter.btnRobotMoveRelClick(Sender: TObject);   //TBD:A2CHv3:ROBOT? (Check if Robot Movable?)
var
  nCh, nRobot : Integer;
  sTemp, sTemp2  : string;
  CoordRelative : TRobotCoord;
begin
  nCh := cmbxMotorRobotChNo.ItemIndex;
  nRobot := nCh;
  if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  //
  sTemp := Format('CH%d:ROBOT: MoveRELATIVE',[nCh+1]);
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  // Check if Robot can move (DIO, RobotCOnnection, RobotStatus)
	if not DongaRobot.Robot[nRobot].CheckRobotMovable(sTemp2) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
    Exit;
	end;
  //
  CoordRelative.X  := StrToFloatDef(edRobotCoordMoveX.Text,0.0);
  CoordRelative.Y  := StrToFloatDef(edRobotCoordMoveY.Text,0.0);
  CoordRelative.Z  := StrToFloatDef(edRobotCoordMoveZ.Text,0.0);
  CoordRelative.Rx := StrToFloatDef(edRobotCoordMoveRx.Text,0.0);
  CoordRelative.Ry := StrToFloatDef(edRobotCoordMoveRy.Text,0.0);
  CoordRelative.Rz := StrToFloatDef(edRobotCoordMoveRz.Text,0.0);
  //
  m_bMaintRobotMove := True;
  DisplayRobotMoveButtons(False); //bEnable
  //
  ThreadTask(procedure
  begin
    try
      DongaRobot.Robot[nRobot].MoveRELATIVE(CoordRelative);
    finally
      m_bMaintRobotMove := False;
      DisplayRobotMoveButtons(True); //bEnable
    end;
  end, btnRobotMoveRel);
end;

procedure TfrmMainter.btnRobotMoveHomeClick(Sender: TObject);  //TBD:A2CHv3:ROBOT? (Check if Robot Movable?)
var
  nCh, nRobot : Integer;
  sTemp, sTemp2 : string;
begin
  nCh := cmbxMotorRobotChNo.ItemIndex;
  nRobot := nCh;
  if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  //
  sTemp := Format('CH%d:ROBOT: MoveHOME',[nCh+1]);
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  // Check if Robot can move (DIO, RobotCOnnection, RobotStatus)
	if not DongaRobot.Robot[nRobot].CheckRobotMovable(sTemp2) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
    Exit;
	end;
  //
  m_bMaintRobotMove := True;
  DisplayRobotMoveButtons(False); //bEnable
  //
  ThreadTask(procedure
  begin
    try
      DongaRobot.Robot[nRobot].MoveHOME;
    finally
      m_bMaintRobotMove := False;
      DisplayRobotMoveButtons(True); //bEnable
    end;
  end, btnRobotMoveHome);
end;

procedure TfrmMainter.btnRobotMoveModelClick(Sender: TObject);  //TBD:A2CHv3:ROBOT? (Check if Robot Movable?)
var
  nCh, nRobot : Integer;
  sTemp, sTemp2 : string;
begin
  nCh := cmbxMotorRobotChNo.ItemIndex;
  nRobot := nCh;
  if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  //
  sTemp := Format('CH%d:ROBOT: MoveMODEL',[nCh+1]);
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  // Check if Robot can move (DIO, RobotCOnnection, RobotStatus)
	if not DongaRobot.Robot[nRobot].CheckRobotMovable(sTemp2) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
    Exit;
	end;
  //
  m_bMaintRobotMove := True;
  DisplayRobotMoveButtons(False); //bEnable
  //
  ThreadTask(procedure
  begin
    try
      if not (DongaRobot.Robot[nRobot].m_RobotStatusCoord.CoordState in [coordHome, coordModel]) then begin
        DongaRobot.Robot[nRobot].MoveHOME;
        Sleep(1000);
      end;
      //
      DongaRobot.Robot[nRobot].MoveMODEL;
    finally
      m_bMaintRobotMove := False;
      DisplayRobotMoveButtons(True); //bEnable
    end;
  end, btnRobotMoveModel);
end;

procedure TfrmMainter.btnRobotMoveStandbyClick(Sender: TObject);
var
  nCh, nRobot : Integer;
  sTemp, sTemp2 : string;
begin
//nCh := cmbxMotorRobotChNo.ItemIndex;
//nRobot := nCh;
//if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  //
//sTemp := Format('CH-:ROBOT: MoveSTANDBY',[nCh+1]);
  sTemp := 'CH1/CH2:ROBOT: MoveSTANDBY';
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
	//
//if not DongaRobot.Robot[nRobot].CheckRobotMovable(sTemp2,True{bStandbyCoord}) then begin
//  ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
//  Exit;
//end;
  //
  m_bMaintRobotMove := True;
  DisplayRobotMoveButtons(False); //bEnable
  //
  ThreadTask(procedure var nRobot : Integer;
  begin
    try
      m_bMaintRobotStandbyMove := True;
      for nRobot := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_CH2 do begin
        if not DongaRobot.Robot[nRobot].CheckRobotMovable(sTemp2,True{bStandbyCoord}) then begin
          ShowMotorRobotMsg('CH'+IntToStr(nRobot+1)+':ROBOT: MoveSTANDBY ...NG('+sTemp2+')');
          Continue;
	      end;
        DongaRobot.Robot[nRobot].MoveSTANDBY;
      end;
    finally
      m_bMaintRobotMove := False;
      m_bMaintRobotStandbyMove := False;
      DisplayRobotMoveButtons(True); //bEnable
    end;
  end, btnRobotMoveStandby);
end;

procedure TfrmMainter.btnRobotTcpCmdSendClick(Sender: TObject);
var
  nCh, nRobot : Integer;
  sCmd : string;
  sTemp, sTemp2 : string;
begin
  nCh := cmbxMotorRobotChNo.ItemIndex;
  nRobot := nCh;
  if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  //
  sCmd := edRobotTcpCmd.Text;
  sTemp := Format('CH%d:ROBOT: Send Command(%s)',[nCh+1,sCmd]);
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  if Length(sCmd) <= 0 then begin
    ShowMotorRobotMsg(sTemp+'...NG(No Command String)');
    Exit;
  end;
  // Check if Robot can move (DIO, RobotCOnnection, RobotStatus)
	if not DongaRobot.Robot[nRobot].CheckRobotMovable(sTemp2) then begin
    ShowMotorRobotMsg(sTemp+' ...NG('+sTemp2+')');
    Exit;
	end;
  //
  m_bMaintRobotMove := True;
  DisplayRobotMoveButtons(False); //bEnable
  //
  ThreadTask(procedure
  begin
    try
      ShowMotorRobotMsg(sTemp+' ...start');
      DongaRobot.Robot[nCh].ListenNodeCmdReq(sCmd);
    finally
      m_bMaintRobotMove := False;
      DisplayRobotMoveButtons(True); //bEnable
      ShowMotorRobotMsg(sTemp+' ...end');
    end;
  end, btnRobotTcpCmdSend);
end;

procedure TfrmMainter.btnRobotProjPauseClick(Sender: TObject); //TBD:ROBOT?
var
  nCh, nRobot : Integer;
  sTemp : string;
  nRobotDioCtlType : enumRobotDioCtlType;
begin
  nCh := cmbxMotorRobotChNo.ItemIndex;
  nRobot := nCh;
  if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  //
  if DongaRobot.Robot[nCh].m_RobotStatusCoord.RobotStatus.ProjectPause then begin
    nRobotDioCtlType := MakePlay;
    sTemp := Format('CH%d:ROBOT: Play/Pause: Pause->Play',[nCh+1]);
  end
  else begin
    nRobotDioCtlType := MakePause;
    sTemp := Format('CH%d:ROBOT: Play/Pause: Play->Pause',[nCh+1]);
  end;
  ShowMotorRobotMsg('>> ['+sTemp+'] Click');
  //
  if not DongaRobot.CheckRobotDioStickControlable(nCh,nRobotDioCtlType) then begin
    ShowMotorRobotMsg(sTemp+' ...NG(Check ROBOT status to change Play/Pause)');
    Exit;
  end;
  //
  ThreadTask(procedure
  begin
    try
      ShowMotorRobotMsg(sTemp+' ...start');
      DongaDio.RobotDioControl(nCh,nRobotDioCtlType); //TBD:A2CHv3:ROBOT? (DIO)
    finally
      ShowMotorRobotMsg(sTemp+' ...end');
    end;
  end, btnRobotProjPause);
end;

procedure TfrmMainter.ShowMaintRobotStatus(nRobot, nMode, nErrCode: Integer; sMsg: String);
var
	nCh : Integer;
begin
//CodeSite.Send('<MAINTER> ShowMaintRobotStatus: '+sMsg);
  nCh := cmbxMotorRobotChNo.ItemIndex;
  if (nCh <> nRobot) and (not m_bMaintRobotStandbyMove) then Exit;
  //
  case nMode of
    DefPocb.MSG_MODE_ROBOT_GET_COORD: begin
      with DongaRobot.Robot[nRobot].m_RobotStatusCoord do begin
        pnlRobotCoordCurX.Caption  := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.X);
        pnlRobotCoordCurY.Caption  := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Y);
        pnlRobotCoordCurZ.Caption  := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Z);
        pnlRobotCoordCurRx.Caption := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Rx);
        pnlRobotCoordCurRy.Caption := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Ry);
        pnlRobotCoordCurRz.Caption := FormatFloat(ROBOT_FORMAT_COORD,RobotCoord.Rz);
      end;
      Exit;
    end;
  end;
  //
  DisplayRobotStatus(nRobot);
  //
  if sMsg <> '' then begin
    if mmMotorRobotRet.Lines.Count > 100 then begin
      mmMotorRobotRet.Lines.Clear;
    end;
    mmMotorRobotRet.DisableAlign;
    mmMotorRobotRet.Lines.Add(sMsg);
    mmMotorRobotRet.Perform(EM_SCROLL,SB_LINEDOWN,0);
    mmMotorRobotRet.EnableAlign;
  end;
end;
{$ENDIF} //HAS_ROBOT_CAM_Z

//******************************************************************************
// procedure/function: Tab: Power Offset Setting and Calibration
//
//******************************************************************************

procedure TfrmMainter.btnPwrCalibrationClick(Sender: TObject);
var
  nPg : Integer;
begin
  nPg := cmbxPwrCalPgValue.ItemIndex;
  if not (nPg in [DefPocb.PG_1,DefPocb.PG_2]) then Exit;
  if Pg[nPG].StatusPg in [pgDisconnect,pgWait] then begin
    Common.MLog(nPG,'<Mainter> PowerOffsetCal: PowerCal: CH'+IntToStr(nPg+1)+': Calibration: Exit(pdDisconnect|pgWait)');
    Exit;
  end;
  Common.MLog(nPg,'<Mainter> PowerOffsetCal: PowerCal: CH'+IntToStr(nPg+1)+': Calibration');
  //
  GrpPwrCalRemovePanel.Visible  := True;
  RzgrpPwrCalFlow.Visible       := False;
  //
  PwrCalInfo.nPg   := nPg;
  PwrCalInfo.nStep := 0;    // 0~13 (CalFlow1~CalFlow14)
end;

{
    //  - Power Calibration
    RzgrpPwrCal             : TRzGroupBox;
    RzpnlPwrCalPgTitle      : TRzPanel;     //  - Power Calibration : PG
    cmbxPwrCalPgValue       : TRzComboBox;
    btnPwrCalibration       : TRzBitBtn;    //  - Power Calibration : Calibration: Start
    GrpPwrCalRemovePanel    : TPanel;       //  - Power Calibration : Calibrarion: RemoveLCM
    lblPwrCalRemoveLcm      : TLabel;
    btnPwrCalRemoveLcmOK    : TRzBitBtn;
    RzgrpPwrCalFlow         : TRzGroupBox;  //  - Power Calibration : CalFlow
    pnlPwrCalFlow1          : TPanel;       //  - Power Calibration : CalFlow: Steps
    pnlPwrCalFlow2          : TPanel;
    pnlPwrCalFlow3          : TPanel;
    pnlPwrCalFlow4          : TPanel;
    pnlPwrCalFlow5          : TPanel;
    pnlPwrCalFlow6          : TPanel;
    pnlPwrCalFlow7          : TPanel;
    pnlPwrCalFlow8          : TPanel;
    pnlPwrCalFlow9          : TPanel;
    pnlPwrCalFlow10         : TPanel;
    pnlPwrCalFlow11         : TPanel;
    pnlPwrCalFlow12         : TPanel;
    pnlPwrCalFlow13         : TPanel;
    pnlPwrCalFlow14         : TPanel;
    btnPwrCalFlowStart      : TRzBitBtn;    //  - Power Calibration : CalFlow: Start
    RzgrpPwrCalFlowUpDown   : TRzGroupBox;  //  - Power Calibration : CalFlow: Step Power Up/Down
    pnlPwrCalFlowUpDownStep : TPanel;
    btnPwrCalFlowPwrUp      : TPanel;
    btnPwrCalFlowPwrDown    : TPanel;
    btnPwrCalFlowStepOK     : TRzBitBtn;
    GrpPwrCalFlowCalOK      : TPanel;       //  - Power Calibration : CalFlow: OK
    lblPwrCalFlowCalOK      : TLabel;
    btnPwrCalFlowCalOK      : TRzBitBtn;
    btnPwrCalFlowClose      : TRzBitBtn;    //  - Power Calibration : CalFlow: Close
}
procedure TfrmMainter.btnPwrCalRemoveLcmOKClick(Sender: TObject);
begin
  Common.MLog(PwrCalInfo.nPg,'<Mainter> PowerOffsetCal: PowerCal: CH'+IntToStr(PwrCalInfo.nPg+1)+': RemoveLcmOK');
  //
  GrpPwrCalRemovePanel.Visible  := False;
  //
  RzgrpPwrCalFlow.Visible   := True;
  pnlPwrCalFlow1.Color      := clBtnFace;
  pnlPwrCalFlow2.Color      := clBtnFace;
  pnlPwrCalFlow3.Color      := clBtnFace;
  pnlPwrCalFlow4.Color      := clBtnFace;
  pnlPwrCalFlow5.Color      := clBtnFace;
  pnlPwrCalFlow6.Color      := clBtnFace;
  pnlPwrCalFlow7.Color      := clBtnFace;
  pnlPwrCalFlow8.Color      := clBtnFace;
  pnlPwrCalFlow9.Color      := clBtnFace;
  pnlPwrCalFlow10.Color     := clBtnFace;
  pnlPwrCalFlow11.Color     := clBtnFace;
  pnlPwrCalFlow12.Color     := clBtnFace;
  pnlPwrCalFlow13.Color     := clBtnFace;
  pnlPwrCalFlow14.Color     := clBtnFace;
  btnPwrCalFlowStart.Visible    := True;
  btnPwrCalFlowStart.Enabled    := True;
  RzgrpPwrCalFlowUpDown.Visible := False;
  GrpPwrCalFlowCalOK.Visible    := False;
  btnPwrCalFlowClose.Visible    := True;
  btnPwrCalFlowClose.Enabled    := True;
end;

procedure TfrmMainter.btnPwrCalFlowStartClick(Sender: TObject);
begin
  Common.MLog(PwrCalInfo.nPg,'<Mainter> PowerOffsetCal: PowerCal: CH'+IntToStr(PwrCalInfo.nPg+1)+': CalFlow: Start');
  PwrCalInfo.nStep := 0;    // 0~13 (CalFlow1~CalFlow14)
  //
  btnPwrCalFlowStart.Enabled    := False;
//btnPwrCalFlowClose.Enabled    := False;
  //
  //
  Pg[PwrCalInfo.nPg].SendPgPowerCalMode('cals');
  //
  Sleep(500);
  RzgrpPwrCalFlowUpDown.Visible := True;
  pnlPwrCalFlowUpDownStep.Caption := pnlPwrCalFlow1.Caption;
  pnlPwrCalFlow1.Color := clYellow;
end;

procedure TfrmMainter.btnPwrCalFlowPwrDownClick(Sender: TObject);
begin
  Common.MLog(PwrCalInfo.nPg,'<Mainter> PowerOffsetCal: PowerCal: CH'+IntToStr(PwrCalInfo.nPg+1)+': CalFlow: Step'+IntToStr(PwrCalInfo.nStep)+'('+pnlPwrCalFlowUpDownStep.Caption+'): DOWN');
  Pg[PwrCalInfo.nPg].SendPgPowerCalMode('-');
end;

procedure TfrmMainter.btnPwrCalFlowPwrUpClick(Sender: TObject);
begin
  Common.MLog(PwrCalInfo.nPg,'<Mainter> PowerOffsetCal: PowerCal: CH'+IntToStr(PwrCalInfo.nPg+1)+': CalFlow: Step'+IntToStr(PwrCalInfo.nStep)+'('+pnlPwrCalFlowUpDownStep.Caption+'): UP');
  Pg[PwrCalInfo.nPg].SendPgPowerCalMode('+');
end;

procedure TfrmMainter.btnPwrCalFlowStepOKClick(Sender: TObject);
var
  sStepName : string;
  sCalCmd   : string;
begin
  Common.MLog(PwrCalInfo.nPg,'<Mainter> PowerOffsetCal: PowerCal: CH'+IntToStr(PwrCalInfo.nPg+1)+': CalFlow: Step'+IntToStr(PwrCalInfo.nStep)+'('+pnlPwrCalFlowUpDownStep.Caption+'): OK');
  // for Current CalFlowStep
  RzgrpPwrCalFlowUpDown.Visible := False;
  case PwrCalInfo.nStep of
     0: begin pnlPwrCalFlow1.Color  := clLime; sCalCmd := 'vcr0'; end;
     1: begin pnlPwrCalFlow2.Color  := clLime; sCalCmd := 'vcr1'; end;
     2: begin pnlPwrCalFlow3.Color  := clLime; sCalCmd := 'vcr2'; end;
     3: begin pnlPwrCalFlow4.Color  := clLime; sCalCmd := 'vdr0'; end;
     4: begin pnlPwrCalFlow5.Color  := clLime; sCalCmd := 'vdr1'; end;
     5: begin pnlPwrCalFlow6.Color  := clLime; sCalCmd := 'vdr2'; end;
     6: begin pnlPwrCalFlow7.Color  := clLime; sCalCmd := 'vbr0'; end;
     7: begin pnlPwrCalFlow8.Color  := clLime; sCalCmd := 'vbr1'; end;
     8: begin pnlPwrCalFlow9.Color  := clLime; sCalCmd := 'icr0'; end;
     9: begin pnlPwrCalFlow10.Color := clLime; sCalCmd := 'icr1'; end;
    10: begin pnlPwrCalFlow11.Color := clLime; sCalCmd := 'idr0'; end;
    11: begin pnlPwrCalFlow12.Color := clLime; sCalCmd := 'idr1'; end;
    12: begin pnlPwrCalFlow13.Color := clLime; sCalCmd := 'ibr0'; end;
    13: begin pnlPwrCalFlow14.Color := clLime; sCalCmd := 'ibr1'; end; // Last Step
    else Exit;
  end;
  Common.ThreadTask(procedure begin
    Pg[PwrCalInfo.nPg].SendPgPowerCalMode(sCalCmd);
  end);
  // for Next CalFlowStep
  PwrCalInfo.nStep := PwrCalInfo.nStep + 1;
  case PwrCalInfo.nStep of
   //0: begin pnlPwrCalFlow2.Color  := clYellow; sStepName := pnlPwrCalFlow2.Caption;  end;
     1: begin pnlPwrCalFlow2.Color  := clYellow; sStepName := pnlPwrCalFlow2.Caption;  end;
     2: begin pnlPwrCalFlow3.Color  := clYellow; sStepName := pnlPwrCalFlow3.Caption;  end;
     3: begin pnlPwrCalFlow4.Color  := clYellow; sStepName := pnlPwrCalFlow4.Caption;  end;
     4: begin pnlPwrCalFlow5.Color  := clYellow; sStepName := pnlPwrCalFlow5.Caption;  end;
     5: begin pnlPwrCalFlow6.Color  := clYellow; sStepName := pnlPwrCalFlow6.Caption;  end;
     6: begin pnlPwrCalFlow7.Color  := clYellow; sStepName := pnlPwrCalFlow7.Caption;  end;
     7: begin pnlPwrCalFlow8.Color  := clYellow; sStepName := pnlPwrCalFlow8.Caption;  end;
     8: begin pnlPwrCalFlow9.Color  := clYellow; sStepName := pnlPwrCalFlow9.Caption;  end;
     9: begin pnlPwrCalFlow10.Color := clYellow; sStepName := pnlPwrCalFlow10.Caption; end;
    10: begin pnlPwrCalFlow11.Color := clYellow; sStepName := pnlPwrCalFlow11.Caption; end;
    11: begin pnlPwrCalFlow12.Color := clYellow; sStepName := pnlPwrCalFlow12.Caption; end;
    12: begin pnlPwrCalFlow13.Color := clYellow; sStepName := pnlPwrCalFlow13.Caption; end;
    13: begin pnlPwrCalFlow14.Color := clYellow; sStepName := pnlPwrCalFlow14.Caption; end;  // Last Step
    else begin
      GrpPwrCalFlowCalOK.Visible := True;
      Exit;
    end;
  end;
  RzgrpPwrCalFlowUpDown.Visible   := True;
  pnlPwrCalFlowUpDownStep.Caption := sStepName;
end;

procedure TfrmMainter.btnPwrCalFlowCalOKClick(Sender: TObject);
begin
  Common.MLog(DefPocb.SYS_LOG,'<Mainter> PowerOffsetCal: PowerCal: CalFlow: OK');
  btnPwrCalibration.Visible     := True;
  btnPwrCalibration.Enabled     := True;
  GrpPwrCalRemovePanel.Visible  := False;
  RzgrpPwrCalFlow.Visible       := False;
  //
  Common.ThreadTask(procedure begin
    Pg[PwrCalInfo.nPg].SendPgPowerCalMode('cale');
  end);
end;

procedure TfrmMainter.btnPwrCalFlowCloseClick(Sender: TObject);
begin
  Common.MLog(DefPocb.SYS_LOG,'<Mainter> PowerOffsetCal: PowerCal: CalFlow: Stop');
  btnPwrCalibration.Visible     := True;
  btnPwrCalibration.Enabled     := True;
  GrpPwrCalRemovePanel.Visible  := False;
  RzgrpPwrCalFlow.Visible       := False;
  //
  Common.ThreadTask(procedure begin
    Pg[PwrCalInfo.nPg].SendPgPowerCalMode('cale');
  end);
end;

procedure TfrmMainter.btnPwrOffsetMemoClearClick(Sender: TObject);
begin
  //Common.MLog(DefPocb.SYS_LOG,'<Mainter> PowerOffsetCal: PowerCal: CalFlow: Close');
  mmPgPowerCal.Clear;
end;

procedure TfrmMainter.btnPwrOffsetReadClick(Sender: TObject);
var
  nPg : Integer;
  nRtn : Integer;
begin
  nPg := cmbxPwrOffsetPG.ItemIndex;
  if not (nPg in [DefPocb.PG_1,DefPocb.PG_2]) then
    Exit;
  if Pg[nPg].StatusPg in [pgDisconnect,pgWait] then begin
    Common.MLog(nPg,'<Mainter> PowerOffsetCal: Offset: CH'+IntToStr(nPg+1)+': Read: Exit(pdDiscobbect|pgWait)');
    Exit;
  end;
  Common.MLog(nPg,'<Mainter> PowerOffsetCal: Offset: CH'+IntToStr(nPg+1)+': Read');
  btnPwrOffsetRead.Enabled := False;
  edPwrOffserRValueVCC.Text := '';
  edPwrOffsetRValueICC.Text := '';
  edPwrOffsetRValueVDD.Text := '';
  edPwrOffsetRValueIDD.Text := '';
  ThreadTask( procedure begin
    nRtn := Pg[nPg].SendPgPowerOffsetRead;
    if nRtn = WAIT_OBJECT_0 then begin
      SendGuiDisplay(nPg,'Power Offset Read',1{PowerOffsetRead});
    end;
  end, btnPwrOffsetRead);
end;

procedure TfrmMainter.btnPwrOffsetWriteClick(Sender: TObject);  //TBD:MAINTER:POWER-CAL?
var
  nPg : Integer;
  nVCC, nVDD : Double;
  nICC, nIDD : Integer;
begin
  nPg := cmbxPwrOffsetPG.ItemIndex;
  if not (nPg in [DefPocb.PG_1,DefPocb.PG_2]) then
    Exit;
  if Pg[nPg].StatusPg in [pgDisconnect,pgWait] then begin
    Common.MLog(nPg,'<Mainter> PowerOffsetCal: Offset: CH'+IntToStr(nPg+1)+': Write: Exit(pdDiscobbect|pgWait)');
    Exit;
  end;
  //
  Common.MLog(nPg,'<Mainter> PowerOffsetCal: Offset: CH'+IntToStr(nPg+1)+': Write');
  btnPwrOffsetWrite.Enabled := False;
  //
  with Pg[nPg].m_PwrOffsetWritePg do begin
    nVCC := StrToFloat(cmbxPwrOffsetWValueVCC.Value);
    if nVCC >= 0 then VCC_Polarity := Byte('+') else VCC_Polarity := Byte('-');
    VCC_Offset := Round(Abs(nVCC) * 10);
    //
    nVDD := StrToFloat(cmbxPwrOffsetWValueVDD.Value);
    if nVDD >= 0 then VDD_Polarity := Byte('+') else VDD_Polarity := Byte('-');
    VDD_Offset := Round(Abs(nVDD) * 10);
    //
    nICC := StrToInt(cmbxPwrOffsetWValueICC.Value);
    if nICC >= 0 then ICC_Polarity := Byte('+') else ICC_Polarity := Byte('-');
    ICC_Offset := Abs(nICC);
    //
    nIDD := StrToInt(cmbxPwrOffsetWValueIDD.Value);
    if nIDD >= 0 then IDD_Polarity := Byte('+') else IDD_Polarity := Byte('-');
    IDD_Offset := Abs(nIDD);
  end;
  //
  Common.MLog(nPg,'Power Offset Setting: Write: VCC('+FloatToStr(nVCC)+') ICC('+IntToStr(nICC)+') VDD('+FloatToStr(nVDD)+') IDD('+IntToStr(nIDD)+')');
  ThreadTask( procedure begin
    Pg[nPg].SendPgPowerOffsetWrite;
  end, btnPwrOffsetWrite);
end;

//******************************************************************************
// procedure/function: Tab: Door Unlock
//
//******************************************************************************

procedure TfrmMainter.tmr_CheckDoorUnlockTimer(Sender: TObject);
var
  sTemp : string;
begin
{$IF Defined(POCB_A2CHv2)}
  //A2CH_v2 외 미구현, A2CH_v2외 탭 안보임
  sTemp := TernaryOp(DongaDio.GetDoValue(DefDio.OUT_LEFT_LOCK_SWITCH).ToBoolean(),'Unlock','Lock');
  btnLeftSwitchLock.Caption  := Format('%s Left Switch',[sTemp]);
  sTemp := TernaryOp(DongaDio.GetDoValue(DefDio.OUT_RIGHT_LOCK_SWITCH).ToBoolean(),'Unlock','Lock');
  btnRightSwitchLock.Caption := Format('%s Right Switch',[sTemp]);

  if (DongaDio.GetDiValue(DefDio.IN_LEFT_SWITCH)  <> 0) and
     (DongaDio.GetDiValue(DefDio.IN_RIGHT_SWITCH) <> 0) then begin
     btnDoorUnlock.Enabled := True;
     sTemp := TernaryOp(DongaDio.GetDoValue(DefDio.OUT_DOOR_UNLOCK).ToBoolean(),'Lock','Unlock');
     btnDoorUnlock.Caption := Format('Door %s',[sTemp]);
  end
  else begin
    btnDoorUnlock.Enabled := False;
  end;
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
  // Left
  sTemp := TernaryOp(DongaDio.GetDoValue(DefDio.OUT_STAGE1_SWITCH_UNLOCK).ToBoolean(),'Lock','Unlock');
  btnLeftSwitchLock.Caption  := Format('%s Left Safety Mode (AUTO/TEACH) Key',[sTemp]);
  if sTemp = 'Lock' then btnLeftSwitchLock.Color := clYellow
  else                   btnLeftSwitchLock.Color := clLime;
  if (DongaDio.GetDiValue(DefDio.IN_STAGE1_KEY_TEACH) <> 0) then begin
    btnLeftDoorUnlock.Enabled := True;
    sTemp := TernaryOp(DongaDio.GetDoValue(DefDio.OUT_STAGE1_MAINT_DOOR1_UNLOCK).ToBoolean()
                       or DongaDio.GetDoValue(DefDio.OUT_STAGE1_MAINT_DOOR2_UNLOCK).ToBoolean()
                ,'Lock','Unlock');
    btnLeftDoorUnlock.Caption := Format('%s CH1 Maint Door1/2',[sTemp]);
    if sTemp = 'Lock' then btnLeftDoorUnlock.Color := clYellow
    else                   btnLeftDoorUnlock.Color := clLime;
  end
  else begin
    DongaDio.SetDoValue(DefDio.OUT_STAGE1_MAINT_DOOR2_UNLOCK, False);
    DongaDio.SetDoValue(DefDio.OUT_STAGE1_MAINT_DOOR2_UNLOCK, False);
    btnLeftDoorUnlock.Enabled := False;
    btnLeftDoorUnlock.Color   := clBtnFace;
  end;
  // Right
  sTemp := TernaryOp(DongaDio.GetDoValue(DefDio.OUT_STAGE2_SWITCH_UNLOCK).ToBoolean(),'Lock','Unlock');
  btnRightSwitchLock.Caption := Format('%s Right Safety Mode (AUTO/TEACH) Key',[sTemp]);
  if sTemp = 'Lock' then btnRightSwitchLock.Color := clYellow
  else                   btnRightSwitchLock.Color := clLime;
  if (DongaDio.GetDiValue(DefDio.IN_STAGE2_KEY_TEACH) <> 0) then begin
    btnRightDoorUnlock.Enabled := True;
    sTemp := TernaryOp(DongaDio.GetDoValue(DefDio.OUT_STAGE2_MAINT_DOOR1_UNLOCK).ToBoolean()
                       or DongaDio.GetDoValue(DefDio.OUT_STAGE2_MAINT_DOOR2_UNLOCK).ToBoolean()
                ,'Lock','Unlock');
    btnRightDoorUnlock.Caption := Format('%s CH2 Maint Door1/2',[sTemp]);
    if sTemp = 'Lock' then btnRightDoorUnlock.Color := clYellow
    else                   btnRightDoorUnlock.Color := clLime;
  end
  else begin
    DongaDio.SetDoValue(DefDio.OUT_STAGE2_MAINT_DOOR2_UNLOCK, False);
    DongaDio.SetDoValue(DefDio.OUT_STAGE2_MAINT_DOOR2_UNLOCK, False);
    btnRightDoorUnlock.Enabled := False;
    btnRightDoorUnlock.Color   := clBtnFace;
  end;
{$ENDIF}
end;

procedure TfrmMainter.btnLeftSwitchLockClick(Sender: TObject);
begin
{$IF Defined(POCB_A2CH)}
{$ELSE}
  DongaDio.SetDio(DefDio.OUT_STAGE1_SWITCH_UNLOCK);
{$ENDIF}
end;

procedure TfrmMainter.btnRightSwitchLockClick(Sender: TObject);
begin
{$IF Defined(POCB_A2CH)}
{$ELSE}
  DongaDio.SetDio(DefDio.OUT_STAGE2_SWITCH_UNLOCK);
{$ENDIF}
end;

procedure TfrmMainter.btnLeftDoorUnlockClick(Sender: TObject);
{$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
var
  sList : TStringList;
{$ENDIF}
begin
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  DongaDio.SetDio(DefDio.OUT_DOOR_UNLOCK);
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
  try
    sList := TStringList.Create;
    try
      ExtractStrings([' '],[],PWideChar(btnLeftDoorUnlock.Caption),sList);
      if CompareStr(sList[0],'Lock') = 0 then begin // Lock
        DongaDio.SetDoValue(DefDio.OUT_STAGE1_MAINT_DOOR1_UNLOCK, False);
        DongaDio.SetDoValue(DefDio.OUT_STAGE1_MAINT_DOOR2_UNLOCK, False);
      end
      else begin // Unlock
        DongaDio.SetDoValue(DefDio.OUT_STAGE1_MAINT_DOOR1_UNLOCK, True);
        DongaDio.SetDoValue(DefDio.OUT_STAGE1_MAINT_DOOR2_UNLOCK, True);
      end;
    finally
      sList.Free;
    end;
  except
  end;
{$ENDIF}
end;

procedure TfrmMainter.btnRightDoorUnlockClick(Sender: TObject);
{$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
var
  sList : TStringList;
{$ENDIF}
begin
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  DongaDio.SetDio(DefDio.OUT_DOOR_UNLOCK);
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
  try
    sList := TStringList.Create;
    try
      ExtractStrings([' '],[],PWideChar(btnRightDoorUnlock.Caption),sList);
      if CompareStr(sList[0],'Lock') = 0 then begin // Lock
        DongaDio.SetDoValue(DefDio.OUT_STAGE2_MAINT_DOOR1_UNLOCK, False);
        DongaDio.SetDoValue(DefDio.OUT_STAGE2_MAINT_DOOR2_UNLOCK, False);
      end
      else begin // Unlock
        DongaDio.SetDoValue(DefDio.OUT_STAGE2_MAINT_DOOR1_UNLOCK, True);
        DongaDio.SetDoValue(DefDio.OUT_STAGE2_MAINT_DOOR2_UNLOCK, True);
      end;
    finally
      sList.Free;
    end;
  except
  end;
{$ENDIF}
end;

procedure TfrmMainter.MaintEepromGammaDataRead(nCh: Integer);
var
  bRtn : boolean;
  nDataSize : Integer;
  tBuff : array of byte;
  sTemp : string;
begin
  try
    SetLength(tBuff,8192);
    {$IF Defined(PANEL_AUTO)}
    bRtn := Logic[nCh].EepromGammaDataRead({var}nDataSize,{var}tBuff);
    {$ELSEIF Defined(PANEL_GAGO)}
    bRtn := Logic[nCh].FlashGammaDataRead({var}nDataSize,{var}tBuff);
    {$ELSE}
    bRtn := False;
    {$ENDIF}
    if (not bRtn) and (nDataSize > 0) then begin
      sTemp := 'EEPROM GammaData Read NG';
      DisplayPgLog(nCh,sTemp);;
    end
    else begin
      sTemp := Format('EEPROM GammaData Read OK (Len=%d)',[nDataSize]);
      DisplayPgLog(nCh,sTemp);
      if (nDataSize > 0) and (nDataSize < 8192) then begin
        sTemp := 'GammaData: ' + UserUtils.Hex2String(tBuff,nDataSize);
        DisplayPgLog(nCh,sTemp);
      end;
    end;
  finally
  end;
end;

procedure TfrmMainter.MaintFlashCBDataFileWrite(nCh: Integer);  //USE_FLASH_WRITE
var
  sTemp, sBinFile : string;
  bOK : Boolean;
  nTotalCnt, nCnt, nOK, nNG, nPwrOnDelay, nPwrOffDelay : Integer;
  nTactOkTime, nTackOkTotal, nTactOkAverage : Integer;
  dateTimeStart : TDateTime;
begin
  if Length(edPgFileSend.Text) <= 0 then begin
    sTemp := 'Error: CBDATA bin file is NOT selected';
    DisplayPgLog(nCh,sTemp);
    Exit;
  end;
  sBinFile  := edPgFileSend.Text;
  nTotalCnt := StrToIntDef(edPgCmdParam.Text,1);
  nOK := 0;
  nNG := 0;

  nTackOkTotal   := 0;
  nTactOkAverage := 0;

  nCnt := 0;
  while (nCnt < nTotalCnt) do begin
    Inc(nCnt);

    dateTimeStart := Now;
    bOK := Logic[nCh].FlashCBDataFileWrite(sBinFile);
    if bOK then begin
      Inc(nOK);
      nTactOkTime    := SecondsBetween(Now, dateTimeStart) + 1;
      nTackOkTotal   := nTackOkTotal + nTactOkTime;
      nTactOkAverage := (nTackOkTotal div nOK) + 1;
      sTemp := Format('FLASH CBDATA Write OK (TT: %d)',[nTactOkTime]);
    end
    else begin
      Inc(nNG);
      sTemp := 'FLASH CBDATA Write NG !!!';
    end;
    DisplayPgLog(nCh,sTemp);

    sTemp := Format('FLASH CBDATA Write : Total(%d/%d) OK(%d) NG(%d) OK-TT(%d)---------',[nCnt,nTotalCnt,nOK,nNG,nTactOkAverage]);
    DisplayPgLog(nCh,sTemp);
    Sleep(500);

  //if (not bOK) then begin
      sTemp := 'Power Reset (start) ---------';
      DisplayPgLog(nCh,sTemp);
      //--------------------------------- Power Off & Delay
      DisplayPgLog(nCh,'Power Off (without CBPARA Write)');
      Logic[nCh].m_Inspect.PowerOn := False;
      Pg[nCh].SendPgPowerOn(0); // power off
      nPwrOffDelay := Common.TestModelInfo2[nCh].PwrOffDelayMsec;
      if nPwrOffDelay > 0 then begin
        sTemp := Format('Delay %d ms',[nPwrOffDelay]);
        DisplayPgLog(nCh,sTemp);
        Sleep(nPwrOffDelay);
      end;
      //--------------------------------- Power On & Delay
      DisplayPgLog(nCh,'Power ON');
      Logic[nCh].m_Inspect.PowerOn := True;
      Pg[nCh].SendPgPowerOn(1);
      nPwrOnDelay := Common.TestModelInfo2[nCh].PwrOnDelayMsec;
      if nPwrOnDelay > 0 then begin
        sTemp := Format('Delay %d ms',[nPwrOnDelay]);
        DisplayPgLog(nCh,sTemp);
        Sleep(nPwrOnDelay);
      end;
      //--------------------------------- EEPROM FlashAccess Disable if GIB
      if not Logic[nCh].EepromFlashAccessWrite(False{bEnable}) then begin
        sTemp := 'EEPROM Write Fail (Flash Access Disable)';
        DisplayPgLog(nCh,sTemp);
        Sleep(100);
      end;
      sTemp := 'Power Reset (end) ---------';
      DisplayPgLog(nCh,sTemp);
  //end;

    Pg[nCh].SendPgDisplayPatNum(gridPatternList.Row); // pattern display
    Sleep(1000);

    nTotalCnt := StrToIntDef(edPgCmdParam.Text,1);
  end;
end;

procedure TfrmMainter.MaintFlashReadData(nCh: Integer; nFlashAddr: UInt32; nSize: Integer);
var
  nRtn  : DWORD;
  sTemp : string;
  j : Integer;
begin
  try
  //nRtn := Pg[nCh].FlashReadData(nFlashAddr,nSize,True{bAfterFlashDisable},True{bForce});
    if nRtn <> WAIT_OBJECT_0 then begin
      sTemp := 'FLASH Data Read NG';
      DisplayPgLog(nCh,sTemp);
    end
    else begin
      sTemp := Format('FLASH Data Read OK (Len=%d)',[nSize]);
      for j := 0 to Pred(nSize) do begin
        sTemp := sTemp + Format(' %0.2x',[Pg[nCh].FRxDataSpi.Data[j]]);;
      end;
      DisplayPgLog(nCh,sTemp);
    end;
  finally
  end;
end;

procedure TfrmMainter.MaintAutoFlowTest(nCh: Integer);  //USE_FLASH_WRITE?
var
  sTemp : string;
  nTotalCnt, nCnt, nOK, nNG : Integer;
begin
  nTotalCnt := StrToIntDef(edPgCmdParam.Text,1);
  nOK := 0;
  nNG := 0;

  nCnt := 0;
  while (nCnt < nTotalCnt) do begin
    Inc(nCnt);
    if MaintWorkStart(nCh) then begin    // TfrmTest1Ch.btnStartTestClick
      Sleep(1000);
      if MaintWorkStart(nCh) then begin  // TfrmTest1Ch.btnStartTestClick
        while (True) do begin
          if (Logic[nCh].m_InsStatus = IsStop) and (not Logic[nCh].m_Inspect.PowerOn) then break;
          Sleep(100);
        end;
        if Trim(Logic[nCh].m_Inspect.Result) <> 'PASS' then Inc(nNG) else Inc(nOK);
      end;
    end;
    Sleep(200);
    sTemp := Format('Flow Test : Total(%d/%d) OK(%d) NG(%d) ---------',[nCnt,nTotalCnt,nOK,nNG]);
    DisplayPgLog(nCh,sTemp);
    Sleep(3000);

    nTotalCnt := StrToIntDef(edPgCmdParam.Text,1);
  end;
end;

function TfrmMainter.MaintWorkStart(nCh: Integer): Boolean;
var
  nOutDioVacuum1, nOutDioVacuum2 : Integer;
  sScanData : string;
begin
  if Common.TestModelInfo2[nCh].UseScanFirst then begin
    if Logic[nCh].m_InsStatus = IsLoading then begin
        if Logic[nCh].m_Inspect.IsScanned then begin
          Logic[nCh].SendStartSeq1;
        end
        else begin
          DisplayPgLog(nCh,'Scan Barcode before Connect PinBlock');
          Exit(False);
        end;
        Exit(True);
    end;
  end;
  
  // frmTest1Ch.CheckScanInterlock
  if (Logic[nCh].m_InsStatus = IsLoading) and (Logic[nCh].m_Inspect.IsScanned = False) then begin
    DisplayPgLog(nCh,'Another Ch is Scanning...');
    Exit(True);
  end;
  
  if Logic[nCh].m_InsStatus <> IsStop then begin  //2018-12-11
    DisplayPgLog(nCh,'Already Started');
    Exit(False);
  end;

  DisplayPgLog(nCh,'<TestCh> WorkStart');
//ClearChData(nCh); 

  if Common.SystemInfo.HasDioVacuum and Common.TestModelInfo2[nCh].UseVacuum then begin //2020-01-XX //2023-04-10 HasDioVacuum
    if (nCh = CH_1) then begin
      nOutDioVacuum1 := DefDio.OUT_STAGE1_VACUUM1; nOutDioVacuum2 := DefDio.OUT_STAGE1_VACUUM2;
    end
    else begin
      nOutDioVacuum1 := DefDio.OUT_STAGE2_VACUUM1; nOutDioVacuum2 := DefDio.OUT_STAGE2_VACUUM2;
    end;
    if (not DongaDio.m_nSetDio[nOutDioVacuum1]) then DongaDio.SetDio(nOutDioVacuum1);
    if (not DongaDio.m_nSetDio[nOutDioVacuum2]) then DongaDio.SetDio(nOutDioVacuum2);
  end;

  Logic[nCh].m_bAutoPowerOff := True;
  Logic[nCh].StartSeqInit;

  //TfrmTest1Ch.SetBcrSet ...start
  if nCh = CH_1 then sScanData := 'POCBSIMCH1111' else sScanData := 'POCBSIMCH2222';

  Logic[nCh].m_InsStatus := IsStart; //TBD???
  if Logic[nCh].m_InsStatus = IsStop then begin  //2018-12-11
    DisplayPgLog(nCh,'Press Start Key and Scan Barcode');
    Exit(False);
  end;
  //
  if Logic[nCh].m_Inspect.IsScanned then begin  //2018-12-11
    DisplayPgLog(nCh,'Already BCR Scanned');
    Exit(False);
  end;

  if not Common.TestModelInfo2[nCh].UseScanFirst then begin
    if Logic[nCh].m_InsStatus <> IsLoading then begin  //2018-12-11
      DisplayPgLog(nCh,'Scan Barcode again after Power-On completed');
      Exit(False);
    end;
  end;

  //
  if Logic[nCh].m_InsStatus = IsLoading then begin
    Logic[nCh].m_Inspect.SerialNo  := Trim(sScanData);
    Logic[nCh].m_Inspect.PanelID   := Trim(sScanData); //2021-12-23
    Logic[nCh].m_Inspect.IsScanned := True;

    if not Common.TestModelInfo2[nCh].UseScanFirst then begin
      if nCh = CH_1 then DongaDio.IsReadyToTurn1 := True
      else               DongaDio.IsReadyToTurn2 := True;
    end;
  end;
  //TfrmTest1Ch.SetBcrSet ...end

  if Common.TestModelInfo2[nCh].UseScanFirst then Logic[nCh].SendScanSeq
  else                                            Logic[nCh].SendStartSeq1;

  Result := True;
end;


//==============================================================================
// MES TEST
//

procedure TfrmMainter.cbmxMesTestCHChange(Sender: TObject);
var
	nCh : Integer;
  PatGrp : TPatternGroup;
begin
  nCh := cbmxMesTestCH.ItemIndex;
  edMesTestBCR2.Visible := (nCh > DefPocb.CH_2);
end;

procedure TfrmMainter.btnMesTestSendPchkClick(Sender: TObject);
var
  cbmxCh : Integer;
begin
  if not (DongaGmes is TGmes) then Exit;
  //
  cbmxCh := cbmxMesTestCH.ItemIndex;
  if cbmxCh = -1 then Exit;

  btnMesTestSendPchk.Enabled := False;
  //
  {$IFDEF SITE_LENSVN}
  case cbmxCh of
    DefPocb.CH_1 : begin
      if Trim(edMesTestBCR1.Text) <> '' then DongaGmes.SendInspectStartPost(DefPocb.CH_1, Trim(edMesTestBCR1.Text));
    end;
    DefPocb.CH_2 : begin
      if Trim(edMesTestBCR2.Text) <> '' then DongaGmes.SendInspectStartPost(DefPocb.CH_2, Trim(edMesTestBCR2.Text));
    end;
    else begin
      Common.ThreadTask(procedure begin
        if Trim(edMesTestBCR1.Text) <> '' then DongaGmes.SendInspectStartPost(DefPocb.CH_1, Trim(edMesTestBCR1.Text));
      end);
      if Trim(edMesTestBCR2.Text) <> '' then DongaGmes.SendInspectStartPost(DefPocb.CH_2, Trim(edMesTestBCR2.Text));
    end;
  end;
  {$ELSE}
  case cbmxCh of
    DefPocb.CH_1 : begin
      if Trim(edMesTestBCR1.Text) <> '' then DongaGmes.SendHostPchk(Trim(edMesTestBCR1.Text), DefPocb.CH_1);
    end;
    DefPocb.CH_2 : begin
      if Trim(edMesTestBCR2.Text) <> '' then DongaGmes.SendHostPchk(Trim(edMesTestBCR2.Text), DefPocb.CH_2);
    end;
    else begin
      Common.ThreadTask(procedure begin
        if Trim(edMesTestBCR1.Text) <> '' then DongaGmes.SendHostPchk(Trim(edMesTestBCR1.Text), DefPocb.CH_1);
      end);
      if Trim(edMesTestBCR2.Text) <> '' then DongaGmes.SendHostPchk(Trim(edMesTestBCR2.Text), DefPocb.CH_2);
    end;
  end;
  {$ENDIF}
  //
  btnMesTestSendPchk.Enabled := True;
end;

procedure TfrmMainter.MaintSendEcirOK(nCh: Integer; sSN: string);
var
  sTemp : string;
begin
  {$IFDEF SITE_LENSVN}
	Logic[nCh].m_Inspect.Result := 'PASS';
  Common.MesData[nCh].Rwk := '';
  Logic[nCh].m_Inspect.TimeStart := now;     //???
  Logic[nCh].m_Inspect.TimeEnd   := now;     //???

  sTemp := Format('PUC_INFO:USERID:%s,PUC_INFO:EQUIPMENT:%s,PUC_INFO:CH:%s,PUC_INFO:PANEL_ID:%s',[Common.m_sUserId,Common.SystemInfo.EQPId,IntToStr(nCh+1),Trim(sSN)]);
  sTemp := sTemp + ',PUC_INFO:FINAL_RESULT:PASS,PUC_INFO:FAILED_MSG:';
  sTemp := sTemp + ',PUC_INFO:STARTTIME:20230713175353,PUC_INFO:ENDTIME:20230713175601,PUC_INFO:TACTTIME:128,PUC_INFO:MEASURE_TACTTIME:106,PUC_INFO:JIG_TACTTIME:112';
  sTemp := sTemp + ',PUC_INFO:SW_UI_VER:POCB_ATO_Simulator,PUC_INFO:HW_PG_VER:FW_1.8C_FPGA_2.5_ALDP_1.2.3_DLPU_7.8,PUC_INFO:HW_SPI_VER:FW_1.203_BOOT_45.67,PUC_INFO:HW_SLOT_VER:';
  sTemp := sTemp + ',PUC_INFO:SCRIPT_NAME:LA130WF1-EL01-UL1-RGB,PUC_RAW:CRC_MODEL_MCF:F79A,PUC_RAW:CRC_MODEL_PARAMCSV:B00D';
  sTemp := sTemp + ',PUC_RAW:CB_ALGORITHM_VER:,PUC_RAW:CRC_CB_ALGORITHM:,PUC_RAW:CRC_CAM_PARAM:';
  sTemp := sTemp + ',PUC_RAW:VCC:3.40,PUC_RAW:ICC:3000,PUC_RAW:VDD:20.00,PUC_RAW:IDD:3000';
  sTemp := sTemp + ',PUC_RAW:JUDGE_COUNT:2';
  sTemp := sTemp + ',PUC_RAW:PTN1_RESULT_UNIFORMITY:OK,PUC_RAW:PTN1_JUDGE:Gray32,PUC_RAW:PTN1_PREUNIFORMITY:71.1,PUC_RAW:PTN1_POSTUNIFORMITY:91.1';
  sTemp := sTemp + ',PUC_RAW:PTN2_RESULT_UNIFORMITY:OK,PUC_RAW:PTN2_JUDGE:Gray63,PUC_RAW:PTN2_PREUNIFORMITY:72.2,PUC_RAW:PTN2_POSTUNIFORMITY:-1.0';
  sTemp := sTemp + ',PUC_RAW:PTN3_RESULT_UNIFORMITY:,PUC_RAW:PTN3_JUDGE_GRAY:,PUC_RAW:PTN3_PREUNIFORMITY:,PUC_RAW:PTN3_POSTUNIFORMITY:';
  sTemp := sTemp + ',PUC_RAW:PTN4_RESULT_UNIFORMITY:,PUC_RAW:PTN4_JUDGE_GRAY:,PUC_RAW:PTN4_PREUNIFORMITY:,PUC_RAW:PTN4_POSTUNIFORMITY:';
  Common.MesData[nCh].ApdrApdInfo := sTemp;

  DongaGmes.SendInspectEndPost(nCh, sSN);
  {$ELSE}
  DongaGmes.SendHostEicr(sSN, nCh, sSN, True);
  {$ENDIF}
end;

procedure TfrmMainter.btnMesTestSendEicrOKClick(Sender: TObject);
var
  cbmxCh : Integer;
begin
  if not (DongaGmes is TGmes) then Exit;
  //
  cbmxCh := cbmxMesTestCH.ItemIndex;
  if cbmxCh = -1 then Exit;

  btnMesTestSendEicrOK.Enabled := False;
  //
  case cbmxCh of
    DefPocb.CH_1 : begin
      if Trim(edMesTestBCR1.Text) <> '' then MaintSendEcirOK(DefPocb.CH_1, Trim(edMesTestBCR1.Text));
    end;
    DefPocb.CH_2 : begin
      if Trim(edMesTestBCR2.Text) <> '' then MaintSendEcirOK(DefPocb.CH_2, Trim(edMesTestBCR2.Text));
    end;
    else begin
      Common.ThreadTask(procedure begin
        if Trim(edMesTestBCR1.Text) <> '' then MaintSendEcirOK(DefPocb.CH_1, Trim(edMesTestBCR1.Text));
      end);
      if Trim(edMesTestBCR2.Text) <> '' then MaintSendEcirOK(DefPocb.CH_2, Trim(edMesTestBCR2.Text));
    end;
  end;
  //
  btnMesTestSendEicrOK.Enabled := True;
end;

procedure TfrmMainter.MaintSendEcirNG(nCh: Integer; sSN: string);
var
  sTemp : string;
begin
  {$IFDEF SITE_LENSVN}
	Logic[nCh].m_Inspect.Result := 'FAIL';
  Common.MesData[nCh].Rwk := 'A06-B01-ZJB';
  Logic[nCh].m_Inspect.TimeStart := now;    //???
  Logic[nCh].m_Inspect.TimeEnd   := now;    //???

  sTemp := Format('PUC_INFO:USERID:%s,PUC_INFO:EQUIPMENT:%s,PUC_INFO:CH:%s,PUC_INFO:PANEL_ID:%s',[Common.m_sUserId,Common.SystemInfo.EQPId,IntToStr(nCh+1),Trim(sSN)]);
  sTemp := sTemp + 'PUC_INFO:FINAL_RESULT:PD24,PUC_INFO:FAILED_MSG:20_Fail_to_find_result_hex_file';
  sTemp := sTemp + ',PUC_INFO:STARTTIME:20230713182158,PUC_INFO:ENDTIME:20230713182420,PUC_INFO:TACTTIME:141,PUC_INFO:MEASURE_TACTTIME:119,PUC_INFO:JIG_TACTTIME:125';
  sTemp := sTemp + ',PUC_INFO:SW_UI_VER:POCB_ATO_Simulator,PUC_INFO:HW_PG_VER:FW_1.8C_FPGA_2.5_ALDP_1.2.3_DLPU_7.8,PUC_INFO:HW_SPI_VER:FW_1.203_BOOT_45.67,PUC_INFO:HW_SLOT_VER:';
  sTemp := sTemp + ',PUC_INFO:SCRIPT_NAME:LA130WF1-EL01-UL1-RGB,PUC_RAW:CRC_MODEL_MCF:F79A,PUC_RAW:CRC_MODEL_PARAMCSV:B00D';
  sTemp := sTemp + ',PUC_RAW:CB_ALGORITHM_VER:,PUC_RAW:CRC_CB_ALGORITHM:,PUC_RAW:CRC_CAM_PARAM:';
  sTemp := sTemp + ',PUC_RAW:VCC:3.40,PUC_RAW:ICC:3000,PUC_RAW:VDD:20.00,PUC_RAW:IDD:3000';
  sTemp := sTemp + ',PUC_RAW:JUDGE_COUNT:2';
  sTemp := sTemp + ',PUC_RAW:PTN1_RESULT_UNIFORMITY:,PUC_RAW:PTN1_JUDGE:Gray32,PUC_RAW:PTN1_PREUNIFORMITY:0.0,PUC_RAW:PTN1_POSTUNIFORMITY:0.0';
  sTemp := sTemp + ',PUC_RAW:PTN2_RESULT_UNIFORMITY:,PUC_RAW:PTN2_JUDGE:Gray63,PUC_RAW:PTN2_PREUNIFORMITY:0.0,PUC_RAW:PTN2_POSTUNIFORMITY:0.0';
  sTemp := sTemp + ',PUC_RAW:PTN3_RESULT_UNIFORMITY:,PUC_RAW:PTN3_JUDGE_GRAY:,PUC_RAW:PTN3_PREUNIFORMITY:,PUC_RAW:PTN3_POSTUNIFORMITY:';
  sTemp := sTemp + ',PUC_RAW:PTN4_RESULT_UNIFORMITY:,PUC_RAW:PTN4_JUDGE_GRAY:,PUC_RAW:PTN4_PREUNIFORMITY:,PUC_RAW:PTN4_POSTUNIFORMITY:';
  Common.MesData[nCh].ApdrApdInfo := sTemp;

  DongaGmes.SendInspectEndPost(nCh, sSN);
  {$ELSE}
  DongaGmes.SendHostEicr(sSN, nCh, sSN, True);
  {$ENDIF}
end;


procedure TfrmMainter.btnMesTestSendEicrNGClick(Sender: TObject);
var
  cbmxCh : Integer;
begin
  if not (DongaGmes is TGmes) then Exit;
  //
  cbmxCh := cbmxMesTestCH.ItemIndex;
  if cbmxCh = -1 then Exit;

  btnMesTestSendEicrNG.Enabled := False;
  //
  case cbmxCh of
    DefPocb.CH_1 : begin
      if Trim(edMesTestBCR1.Text) <> '' then MaintSendEcirNG(DefPocb.CH_1, Trim(edMesTestBCR1.Text));
    end;
    DefPocb.CH_2 : begin
      if Trim(edMesTestBCR2.Text) <> '' then MaintSendEcirNG(DefPocb.CH_2, Trim(edMesTestBCR2.Text));
    end;
    else begin
      Common.ThreadTask(procedure begin
      if Trim(edMesTestBCR1.Text) <> '' then MaintSendEcirNG(DefPocb.CH_1, Trim(edMesTestBCR1.Text));
      end);
      if Trim(edMesTestBCR2.Text) <> '' then MaintSendEcirNG(DefPocb.CH_2, Trim(edMesTestBCR2.Text));
    end;
  end;
  //
  btnMesTestSendEicrNG.Enabled := True;
end;

procedure TfrmMainter.btnLensMesTestSendReInputClick(Sender: TObject);
var
  cbmxCh : Integer;
begin
{$IFDEF SITE_LENSVN}
  if not (DongaGmes is TGmes) then Exit;
  //
  cbmxCh := cbmxMesTestCH.ItemIndex;
  if cbmxCh = -1 then Exit;

  btnLensMesTestSendReInput.Enabled := False;
  //
  case cbmxCh of
    DefPocb.CH_1 : begin
      if Trim(edMesTestBCR1.Text) <> '' then DongaGmes.SendInspectReInputPost(DefPocb.CH_1, Trim(edMesTestBCR1.Text));
    end;
    DefPocb.CH_2 : begin
      if Trim(edMesTestBCR2.Text) <> '' then DongaGmes.SendInspectReInputPost(DefPocb.CH_2, Trim(edMesTestBCR2.Text));
    end;
    else begin
      Common.ThreadTask(procedure begin
        if Trim(edMesTestBCR1.Text) <> '' then DongaGmes.SendInspectReInputPost(DefPocb.CH_1, Trim(edMesTestBCR1.Text));
      end);
      if Trim(edMesTestBCR2.Text) <> '' then DongaGmes.SendInspectReInputPost(DefPocb.CH_2, Trim(edMesTestBCR2.Text));
    end;
  end;
  //
  btnLensMesTestSendReInput.Enabled := True;
{$ENDIF}
end;

procedure TfrmMainter.btnLensMesTestSendStatusClick(Sender: TObject);
var
  cbmxStatus, cbmxCh : Integer;
begin
{$IFDEF SITE_LENSVN}
  if not (DongaGmes is TGmes) then Exit;
  //
  cbmxStatus := cbmxLensMesTestSendStatus.ItemIndex;
  if cbmxStatus = -1 then Exit;

  cbmxCh := cbmxMesTestCH.ItemIndex;
  if cbmxCh = -1 then Exit;

  //
  btnLensMesTestSendStatus.Enabled := False;

  case cbmxCh of
    DefPocb.CH_1 : DongaGmes.SendEqStatusPost(DefPocb.CH_1, cbmxStatus, ''{Remark});
    DefPocb.CH_2 : DongaGmes.SendEqStatusPost(DefPocb.CH_2, cbmxStatus, ''{Remark});
  end;

  btnLensMesTestSendStatus.Enabled := True;
{$ENDIF}
end;

//******************************************************************************
// procedure/function: Etc
//      ThreadTask(task: TProc; btnObj : TRzBitBtn);
//      SendGuiDisplay(nCh: Integer; sMsg: string);
//      WMCopyData(var Msg: TMessage);
//          MSG_TYPE_PG
//          MSG_TYPE_CAMERA
//              MSG_MODE_WORKING
//******************************************************************************

procedure TfrmMainter.ThreadTask(task: TProc; btnObj: TRzBitBtn);
var
  th : TThread;
begin
  th := TThread.CreateAnonymousThread(procedure begin
    task;
    th.Synchronize(nil,procedure begin
      btnObj.Enabled := True;
    end);
  end);
  th.Start;
end;

procedure TfrmMainter.SendGuiDisplay(nCh: Integer; sMsg: string; nMode: Integer = 0);
var
  ccd         : TCopyDataStruct;
  CommData    : RGuiMainter;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<Mainter> PG/CAM: CH'+IntToStr(nCh)+': SendGuiDisplay');
  CommData.MsgType  := DefPocb.MSG_TYPE_PG;
  CommData.Channel  := nCh;
  CommData.Mode     := nMode; //2019-01-09  0:PgComm, 1:PowerOfssetRead
  CommData.Msg      := sMsg;
  ccd.dwData        := 0;
  ccd.cbData        := SizeOf(CommData);
  ccd.lpData        := @CommData;
  SendMessage(Self.Handle,WM_COPYDATA,0, LongInt(@ccd));
end;

procedure TfrmMainter.WMCopyData(var Msg: TMessage);
var
  nType, nCh, nMode : Integer;
  sMsg, sTemp : string;
begin
  nType := PGuiMainter(PCopyDataStruct(Msg.LParam)^.lpData)^.MsgType;
  nCh   := PGuiMainter(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
  case nType of
    DefPocb.MSG_TYPE_PG : begin   // PG
      nMode := PGuiMainter(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      case nMode of  //2018-01-09
        0: begin  // 0(default): PgCmd
          sMsg  := PGuiMainter(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
          sTemp := FormatDateTime('[hh:mm:ss.zzz]',Now);
          sTemp := sTemp + Format(' Ch%d, TX: ',[nCh+1]) + sMsg;
          if PageControlMainter.ActivePage = tabPgCamComm then begin      //2018-01-09
            mmPgComm.Lines.Add(sTemp);
          end
          else if PageControlMainter.ActivePage = tabPgPowerCal then begin
            mmPgPowerCal.Lines.Add(sTemp);
          end;
        end;
        1: begin  // 1: PowerOffsetRead
          if PageControlMainter.ActivePage <> tabPgPowerCal then Exit;
          //
          with Pg[nCh].m_PwrOffsetReadPg do begin
            if VCC_Offset = 0 then edPwrOffserRValueVCC.Text := '0'
            else begin
              if VCC_Polarity = Byte('+') then edPwrOffserRValueVCC.Text := Format('+ %0.2f',[VCC_Offset / 10])
              else                             edPwrOffserRValueVCC.Text := Format('- %0.2f',[VCC_Offset / 10]);
            end;
            //
            if ICC_Offset = 0 then edPwrOffsetRValueICC.Text := '0'
            else begin
              if ICC_Polarity = Byte('+') then edPwrOffsetRValueICC.Text := Format('+ %d',[ICC_Offset])
              else                             edPwrOffsetRValueICC.Text := Format('- %d',[ICC_Offset]);
            end;
            //
            if VDD_Offset = 0 then edPwrOffsetRValueVDD.Text := '0'
            else begin
              if VDD_Polarity = Byte('+') then edPwrOffsetRValueVDD.Text := Format('+ %0.2f',[VDD_Offset / 10])
              else                             edPwrOffsetRValueVDD.Text := Format('- %0.2f',[VDD_Offset / 10]);
            end;
            //
            if IDD_Offset = 0 then edPwrOffsetRValueIDD.Text := '0'
            else begin
              if IDD_Polarity = Byte('+') then edPwrOffsetRValueIDD.Text := Format('+ %d',[IDD_Offset])
              else                             edPwrOffsetRValueIDD.Text := Format('- %d',[IDD_Offset]);
            end;
          end;
        end;
      end;
    end;
    DefPocb.MSG_TYPE_CAMERA : begin   // Camera.
      if PageControlMainter.ActivePage <> tabPgCamComm then begin      //2018-01-09
        Exit;
      end;
      nMode := PTestGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      case nMode of
        DefPocb.MSG_MODE_WORKING : begin
          sMsg  := Trim(PTestGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg);
          sTemp := FormatDateTime('[hh:mm:ss.zzz] ',Now);
          sTemp := sTemp + Format('Ch%d : ',[nCh+1]) + sMsg;
          mmCamComm.Lines.Add(sTemp)
        end;
      end;
    end;
  end;
end;

end.
