unit DioCtl;

interface
{$I Common.inc}

uses
  System.SysUtils, System.Classes, System.UITypes, System.DateUtils, System.Types,
	Winapi.Windows, Winapi.Messages, System.Diagnostics,
  Vcl.Dialogs, Vcl.ExtCtrls,
  DefPocb, CommonClass, DefDio, DefMotion, MotionCtl, DefRobot, RobotCtl, UserUtils,  //A2CHv3:ROBOT
{$IF Defined(USE_DIO_ADLINK)}
  Dask,
{$ELSEIF Defined(USE_DIO_AXT)}
  DioCtlAxt,
{$ELSEIF Defined(USE_DIO_AXD)}
  DioCtlAxd,
{$ENDIF}
  CodeSiteLogging;

{$IFDEF SIMULATOR_DIO}
const
  SimulatorDioCheckInterval = 20;
{$ENDIF}

type
  //============================================================================
  InDioConnSt         = procedure(nMode,nParam: Integer; sMsg: String) of object;
  InDioConnStMaint    = procedure(nMode,nParam: Integer; sMsg: String) of object;
  //
  ADioStatus          = array[0..pred(DefDio.MAX_DIO_CNT)] of boolean;
  InDioOutReadSt      = procedure(OutDio: ADioStatus) of object;
  InDioOutReadStMaint = procedure(OutDio: ADioStatus) of object;

  InDioEvent    = procedure(InDio, OutDio: ADioStatus) of object;
  DioErrEvent   = procedure(bIsEmsReset: Boolean; sMsg: string) of object;
  ArrivedEvent  = procedure(nParam: Integer) of object;

  PMainGuiDioData  = ^RMainGuiDioData;  // DioCtl -> frmMain
  RMainGuiDioData = packed record
    MsgType : Integer;
    Channel : Integer;
    Mode    : Integer;
    Param   : Integer;
    Msg     : string;
  end;

  PTestGuiDioData  = ^RTestGuiDioData;  // DioCtl -> frmTest1Ch
  RTestGuiDioData = packed record
    MsgType : Integer;
    Channel : Integer;
    Mode    : Integer;
    Param   : Integer;
    Param2  : Integer;  //2019-05-20 (for MSG_MODE_DISPLAY_FLOW_SEQ)
    Msg     : string;
  end;

{$IFDEF SIMULATOR_DIO}
  TSimulatorDioInOnOff = record
    nDelayOn  : Integer;
    nDelayOff : Integer;
  end;
{$ENDIF}

  //
  TDioCtl = class(TObject)
  const
    SHUTTER_UPDOWN_DELAY_TIME = 10000;
  private
    m_hMain            : THandle;
 // m_nCardId          : Integer;
    //
    FIsMainter         : Boolean;
    FDioConnSt         : InDioConnSt;           // DIO Connection Status
    FDioConnStMaint    : InDioConnStMaint;      // DIO Connection Status
    FDioOutReadSt      : InDioOutReadSt;       // (Device) DIO OUT Status
    FDioOutReadStMaint : InDioOutReadStMaint;  // (Device) DIO Out Status
    //
    FMainGuiDioData   : RMainGuiDioData;
    FInDioStatus      : InDioEvent;
    FMaintInDioStatus : InDioEvent;
    FMaintInDioUse    : Boolean;
    FArrivedUnload1   : ArrivedEvent;
    FArrivedUnload2   : ArrivedEvent;
    FSetErrMsg        : DioErrEvent;
    FIsReadyToTurn1   : Boolean;
    FIsReadyToTurn2   : Boolean;
    m_nDIOErr         : Integer;
    m_bEmsFlag        : Boolean;
    m_bStopFlag       : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of Boolean;
    m_bRestart        : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of Boolean;
  //m_tTime           : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of TDateTime;
    m_tTime           : array [DefPocb.JIG_A..DefPocb.JIG_MAX+1] of TDateTime; //TBD:MERGE?
    FstwSensorTT      : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of TStopWatch;
    FIsSensorTT       : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of Boolean;
		{$IFDEF FEATURE_DIO_LOG_SHUTTER}
    m_tShutterUpDownOut : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of TDateTime; //2023-05-02 DIO_LOG_SHUTTER
		{$ENDIF}
		{$IFDEF FEATURE_KEEP_SHUTTER_UP}
    m_bOnShutterUp    : array [DefPocb.JIG_A..DefPocb.JIG_MAX+1] of Boolean;   //FEATURE_KEEP_SHUTTER_UP
		{$ENDIF}
    {$IFDEF SIMULATOR_DIO}
    SimulatorDioInOnOff : array [0..DefDio.MAX_DIO_IN] of TSimulatorDioInOnOff;
    tmrSimulatorDio : TTimer;
    procedure OnSimulatorDioTimer(Sender: TObject);
    procedure SimulatorAddDioIn(nDioIn: UInt64; bOn: Boolean; nDelay: Integer);
    {$ENDIF}
    procedure SetIsMainter(const Value: Boolean);
    procedure SetDioConnSt(const Value: InDioConnSt);
    procedure SetDioConnStMaint(const Value: InDioConnStMaint);
    procedure SetDioOutReadSt(const Value: InDioOutReadSt);
    procedure SetDioOutReadStMaint(const Value: InDioOutReadStMaint);
    procedure SetInDioStatus (const Value: InDioEvent);
    procedure SetMaintInDioStatus(const Value: InDioEvent);
    procedure SetMaintInDioUse(const Value: Boolean);
    procedure SetSetErrMsg(const Value: DioErrEvent);
    procedure SetArrivedUnload1(const Value: ArrivedEvent);
    procedure SetArrivedUnload2(const Value: ArrivedEvent);
    procedure SetIsReadyToTurn1(const Value: Boolean);
    procedure SetIsReadyToTurn2(const Value: Boolean);
    procedure GetAllDio;
    function GetAllDioCh1: Boolean;
    function GetAllDioCh2: Boolean;
    {$IFDEF SUPPORT_1CG2PANEL}
    function GetAllDioChAssyPOCB: Boolean; //A2CHv3:DIO:ASSY-POCB
    {$ENDIF}
    {$IFDEF HAS_DIO_IN64}
    function CheckIoBeforeDioOutSig(const wDioSig : UInt64;out sEMsg : string) : Boolean;
    {$ELSE}
    function CheckIoBeforeDioOutSig(const wDioSig : DWORD;out sEMsg : string) : Boolean;
    {$ENDIF}
    procedure SendMainGuiDisplay(nGuiMode, nCH, nParam: Integer; sMsg: string = '');
    procedure SendTestGuiDisplay(nGuiMode, nCH: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0);

    procedure CheckShutterTimeout(nCh : Integer; value : ShutterState);
  public
    m_hTest       : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of HWND;  // for DioCtl->frmTest1Ch
    tmCheckDio    : TTimer;
		
    {$IF Defined(USE_DIO_AXT)}
    DioAxt        : TDioAxt;
    {$ELSEIF Defined(USE_DIO_AXD)}
    DioAxd        : TDioAxd;
    {$ENDIF}
		
    m_nGetDioOut  : ADioStatus;
		
    {$IFDEF HAS_DIO_IN64}
    m_nDOValue, m_nDIValue, m_nOldDIValue : UInt64;
    {$ELSE}
    m_nDOValue, m_nDIValue, m_nOldDIValue : DWORD;
    {$ENDIF}
		
    m_nSetDio,m_nGetDio : ADioStatus;
    m_nAutoFlow   : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of Integer;
    m_bDioFirstReadDone : Boolean; //2019-04-04
		
    {$IFDEF HAS_ROBOT_CAM_Z}
    m_IsOnDioRobotCtl : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of Boolean;
    {$ENDIF}
		
    {$IFDEF DIO_ALARM_THRESHOLD}
    m_nOldChangedDIValue, m_nChangedDIValue : UInt64;
		{$ENDIF}
		{$IFDEF POCB_A2CHv3}
    m_bAirKnifeSet : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Boolean;
		{$ENDIF}

    {$IFDEF SIMULATOR_DIO}
      {$IFDEF HAS_DIO_IN64}
    m_nSimDioDIValue : UInt64;
      {$ELSE}
    m_nSimDioDIValue : DWORD;
      {$ENDIF}
    {$ENDIF}

    constructor Create(hMain: THandle; nScanTime: Integer); virtual;
    destructor Destroy; override;
    function Connect: Boolean;
    // Added by SHPARK 2024-02-21 오전 10:54:39 For Unit T/T
    procedure GetUnitTTLog(nCh,nIdx : Integer);
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)} //#############################################
    function CheckIoBeforeMotorOutSig(const wMotorSig: DWORD): Boolean;
{$ELSE} //A2CHv3|A2CHv4  //#####################################################################
    function CheckIoBeforeMotorOutSig(const wMotorSig: DWORD; out sEMsg: string): Boolean; //A2CHv3:DIO
{$ENDIF}                 //#####################################################################
    //
    property IsMainter         : Boolean read FIsMainter write SetIsMainter;
    property DioConnSt         : InDioConnSt read FDioConnSt write SetDioConnSt;
    property DioConnStMaint    : InDioConnStMaint read FDioConnStMaint write SetDioConnStMaint;
    property DioOutReadSt      : InDioOutReadSt read FDioOutReadSt write SetDioOutReadSt;
    property DioOutReadStMaint : InDioOutReadStMaint read FDioOutReadStMaint write SetDioOutReadStMaint;

    property InDioStatus      : InDioEvent read FInDioStatus write SetInDioStatus;
    property MaintInDioStatus : InDioEvent read FMaintInDioStatus write SetMaintInDioStatus;
    property MaintInDioUse    : Boolean read FMaintInDioUse write SetMaintInDioUse;
    property SetErrMsg        : DioErrEvent read FSetErrMsg write SetSetErrMsg;
    property ArrivedUnload1   : ArrivedEvent read FArrivedUnload1 write SetArrivedUnload1;
    property ArrivedUnload2   : ArrivedEvent read FArrivedUnload2 write SetArrivedUnload2;
    property IsReadyToTurn1   : Boolean read FIsReadyToTurn1 write SetIsReadyToTurn1;
    property IsReadyToTurn2   : Boolean read FIsReadyToTurn2 write SetIsReadyToTurn2;

    function GetSelectedBuzzer : Byte;
    function GetDiValue(nNum : Byte) : UInt64; overload;
    function GetDiValue(nNums : array of byte) : UInt64; overload;
    function GetDoValue(nNum : Byte) : UInt64; overload;
    function GetDoValue(nNums : array of byte) : UInt64; overload;
    function SetDoValue(nNum : Byte; bValue : Boolean) : Integer;
    function CheckState(nNum : Byte; bValue : Boolean) : Boolean; overload;
    function CheckState(nArrNum : array of Byte; bValue : Boolean) : Boolean; overload;
    function SetBuzzer(bValue : Boolean) : Integer;
    function SetAirKnife(nCh : Integer; bValue : Boolean) : Integer;
    function SetShutter(nCh : Integer; value : ShutterState) : Integer;
    function CheckPinblock(nCh: Integer; bValue : Boolean): Boolean; //2019-04-24
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
    function IsShutterUp(nCh: Integer): Boolean;
{$ENDIF}
    function CheckShutterState(nCh: Integer; value : ShutterState): Boolean;
    function CheckVacuum(nCh : Integer; bValue : Boolean) : Boolean;
    function IsDoorClosed(bCheckUnderDoor: Boolean; nCh: Integer = -1): Boolean;
    {$IFDEF SUPPORT_1CG2PANEL}
    function CheckCamZonePartDoor(bIsOpen: Boolean): Boolean;  //A2CHv3:DIO
    {$ENDIF}
    function CheckLightDetect(nCh : Integer; bValue : Boolean) : Boolean;
    function SetBlow(nCh : Integer; nDelay : Integer = 500) : Integer;
    function SetStageLamp(nCh: Integer; bOn: Boolean): Integer;
    function SetTowerLamp(bRed, bYel, bGrn : Boolean; bBzr : Boolean = False) : Integer;
{$IFDEF HAS_ROBOT_CAM_Z}
    procedure RobotDioControl(nRobot: Integer; nRobotDioCtlType: enumRobotDioCtlType); //A2CHv3:ROBOT
{$ENDIF}
    //OLD---
    procedure GetDioStatus;
    procedure OntmCheckDioTimer(Sender: TObject);
{$IFDEF HAS_DIO_IN64}
    function  SetDio(lwSignal : UInt64; bAllSet : Boolean = False) : Integer;
{$ELSE}
    function  SetDio(lwSignal : LongWord; bAllSet : Boolean = False) : Integer;
{$ENDIF}
    function  SetAutoOffOut(lwSignal : Byte; nDelay : Integer = 500) : Integer;
{$IFDEF SIMULATOR_DIO}
{$IFDEF HAS_DIO_IN64}
    procedure SimulatorDioSetIn(nDioInMask : UInt64);
    procedure SimulatorDioClrIn(nDioInMask : UInt64);
{$ELSE}
    procedure SimulatorDioSetIn(nDioInMask : LongWord);
    procedure SimulatorDioClrIn(nDioInMask : LongWord);
{$ENDIF}
    procedure SimulatorDioOutEvent(nDioOut: Integer; bOn: Boolean);
{$ENDIF}
  end;
var
  DongaDio : TDioCtl;

implementation

uses OtlTaskControl, OtlParallel;

{ TDongaDio }

//******************************************************************************
// procedure/function:
//    - constructor TDioCtl.Create(nScanTime: Integer)
//    - destructor TDioCtl.Destroy
//    - function TDioCtl.Connect: Boolean;
//******************************************************************************

constructor TDioCtl.Create(hMain: THandle; nScanTime: Integer);
var
  i : Integer;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<DioCtl> DIO Create (scanTime:'+IntToStr(nScanTime)+'msec)');
  m_hMain   := hMain;
  //
{$IF Defined(USE_DIO_AXT)}      //A2CH
  DioAxt := TDioAxt.Create(hMain);
{$ELSEIF Defined(USE_DIO_AXD)}  //F2CH | A2CHv2
  DioAxd := TDioAxd.Create(hMain);
{$ELSEIF Defined(USE_DIO_ADLINK)}
  {$IFDEF SIMULATOR_DIO}
  m_nCardId     := 0;
  {$ELSE}
  m_nCardId     := -1;
  m_nCardId := Register_Card(PCI_7230, DefDio.CARDNUMBER_1);
  {$ENDIF}
  if m_nCardId < 0 then begin
    MessageDlg('Cannot Find DIO Card(PCI-7230) !', mtError, [mbOk], 0);
  end;
{$ENDIF}

  m_nDOValue    := 0;
//m_nDIValue    := 0; //2019-04-05 (TBD:DIO:InitValueForAlarm)
//m_nOldDIValue := 0; //2019-04-05 (TBD:DIO:InitValueForAlarm)
{$IF Defined(POCB_A2CH)}}
  m_nDIValue    := DefDio.MASK_IN_LIGHT_CURTAIN or
                   DefDio.MASK_IN_LEFT_FAN_IN or DefDio.MASK_IN_RIGHT_FAN_IN or
                   DefDio.MASK_IN_LEFT_FAN_OUT or DefDio.MASK_IN_RIGHT_FAN_OUT or
                   DefDio.MASK_IN_MAIN_REGULATOR or
                   DefDio.MASK_IN_MC1 or DefDio.MASK_IN_MC2 or
                   DefDio.MASK_IN_STAGE1_SHUTTER_DOWN or DefDio.MASK_IN_STAGE2_SHUTTER_DOWN; //초기화시, ShutterDown상태에서 Y축 이동 방지
{$ELSEIF Defined(POCB_A2CHv2)}
  m_nDIValue    := DefDio.MASK_IN_STAGE1_LIGHT_CURTAIN or DefDio.MASK_IN_STAGE2_LIGHT_CURTAIN or
                   DefDio.MASK_IN_LEFT_FAN_IN or DefDio.MASK_IN_RIGHT_FAN_IN or
                   DefDio.MASK_IN_LEFT_FAN_OUT or DefDio.MASK_IN_RIGHT_FAN_OUT or
                   DefDio.MASK_IN_CYLINDER_REGULATOR or DefDio.MASK_IN_VACUUM_REGULATOR or
                   DefDio.MASK_IN_MC1 or DefDio.MASK_IN_MC2 or
                   DefDio.MASK_IN_STAGE1_SHUTTER_DOWN or DefDio.MASK_IN_STAGE2_SHUTTER_DOWN; //초기화시, ShutterDown상태에서 Y축 이동 방지
{$ELSE} //POCB_A2CHv3|POCB_A2CHv4|POCB_ATO|POCB_GAGO
  m_nDIValue    :=  //DefDio.MASK_IN_EMO1_FRONT
                 //or DefDio.MASK_IN_EMO2_RIGHT
                 //or DefDio.MASK_IN_EMO3_INNER_RIGHT
                 //or DefDio.MASK_IN_EMO4_INNER_LEFT
                 //or DefDio.MASK_IN_EMO5_LEFT
                   DefDio.MASK_IN_LEFT_FAN_IN
                   or DefDio.MASK_IN_RIGHT_FAN_IN
                   or DefDio.MASK_IN_LEFT_FAN_OUT
                   or DefDio.MASK_IN_RIGHT_FAN_OUT
                 //or DefDio.MASK_IN_STAGE1_MUTING_LAMP
                 //or DefDio.MASK_IN_STAGE2_MUTING_LAMP
                   or DefDio.MASK_IN_STAGE1_LIGHT_CURTAIN
                   or DefDio.MASK_IN_STAGE2_LIGHT_CURTAIN
                   or DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE
                 //or DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE
                   or DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE
                 //or DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE
                 //or DefDio.MASK_IN_STAGE1_MAINT_DOOR1
                 //or DefDio.MASK_IN_STAGE1_MAINT_DOOR2
                 //or DefDio.MASK_IN_STAGE2_MAINT_DOOR1
                 //or DefDio.MASK_IN_STAGE2_MAINT_DOOR2
                   or DefDio.MASK_IN_CYLINDER_REGULATOR
                   or DefDio.MASK_IN_VACUUM_REGULATOR
                 //or DefDio.MASK_IN_TEMPERATURE_ALARM
                 //or DefDio.MASK_IN_POWER_HIGH_ALARM
                   or DefDio.MASK_IN_MC1
                   or DefDio.MASK_IN_MC2
                   or DefDio.MASK_IN_STAGE1_SHUTTER_DOWN  //초기화시, ShutterDown상태에서 Y축 이동 방지
                   or DefDio.MASK_IN_STAGE2_SHUTTER_DOWN; //초기화시, ShutterDown상태에서 Y축 이동 방지
  {$IFDEF HAS_DIO_FAN_INOUT_PC}
  if Common.SystemInfo.HasDioFanInOutPC then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
    m_nDIValue    :=  m_nDIValue
                   or DefDio.MASK_IN_MAINPC_FAN_IN
                   or DefDio.MASK_IN_MAINPC_FAN_OUT
                   or DefDio.MASK_IN_CAMPC_FAN_IN
                   or DefDio.MASK_IN_CAMPC_FAN_OUT;
  end;
  {$ENDIF}
  //
  if (not Common.SystemInfo.HasDioVacuum) then begin //A2CHvX(True), ATO(False),GAGO(True) //2023-04-10 HasDioVacuum
    m_nDIValue    :=  m_nDIValue and (not DefDio.MASK_IN_VACUUM_REGULATOR);
  end;
  //
  {$IFDEF HAS_DIO_IN_DOOR_LOCK}
  if Common.SystemInfo.HasDioInDoorLock then begin //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    m_nDIValue    :=  m_nDIValue
                   or DefDio.MASK_IN_STAGE1_DOOR1_LOCK //TBD:DIO:2024-01?
                   or DefDio.MASK_IN_STAGE1_DOOR2_LOCK
                   or DefDio.MASK_IN_STAGE2_DOOR1_LOCK
                   or DefDio.MASK_IN_STAGE2_DOOR2_LOCK;
  end;
  {$ENDIF}
  {$IFDEF HAS_DIO_Y_AXIS_MC}
  if Common.SystemInfo.HasDioYAxisMC then begin //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    m_nDIValue    :=  m_nDIValue
                   or DefDio.MASK_IN_STAGE1_Y_AXIS_MC //TBD:DIO:2024-01?
                   or DefDio.MASK_IN_STAGE2_Y_AXIS_MC;
  end;
  {$ENDIF}
{$ENDIF}

{$IFDEF SIMULATOR_DIO}  //--------------------------------------------------------- SIMULATOR_DIO ...start
  m_nDIValue := m_nDIValue and (not (DefDio.MASK_IN_STAGE1_SHUTTER_DOWN or DefDio.MASK_IN_STAGE2_SHUTTER_DOWN));
  {$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  m_nDIValue := m_nDIValue or
                {$IFDEF HAS_DIO_PINBLOCK}
                (DefDio.MASK_IN_STAGE1_PINBLOCK_CLOSE or DefDio.MASK_IN_STAGE2_PINBLOCK_CLOSE) or
                {$ENDIF}
                (DefDio.MASK_IN_STAGE1_SHUTTER_UP or DefDio.MASK_IN_STAGE2_SHUTTER_UP);
  {$ELSEIF Defined(POCB_A2CHv3)}
    //
    // A2CHv3 (CH1/CH2 SHUTTER/SCREW_SHUTTER/SHUTTER_GUIDE, CAMZONE_PARTITION_UP1/UP2, CALZONE_INNER_DOOR_OPEN/CLOSE
    //                             |         non-ASSY(Ready)      |         ASSY(Ready)
    //                             | CH1|CH2   CH1|CH2    CH1|CH2 | CH1&CH2   CH1&CH2    CH1&CH2
    //                             | (Ready)   (Y-asix)   (Cam)   | (Ready)   (Y-Asix)   (Cam)
    //   --------------------------+---------+----------+---------+---------+----------+---------+
    //   CH1/2 SHUTTER_UP          | ON        ON         -       | ON        ON         -
    //   CH1/2 SHUTTER_DOWN        | -         -          ON      | -         -          ON
    //   CH1/2 SCREW_SHUTTER_UP    | -         -          ON      | -         -          ON
    //   CH1/2 SCREW_SHUTTER_DOWN  | ON        ON         -       | ON        ON         -
    //   //
    //   SHUTTER_GUIDE_UP          | ON        ON         ON      | -         -          ON
    //   SHUTTER_GUIDE_DOWN        | -         -          -       | ON        ON         -
    //   //
    //   CAMZONE_PARTITION_UP1|2   | -         -          -       | ON        ON         ON
    //   CAMZONE_PARTITION_DOWN1|2 | ON        ON         ON      | -         -          -
    //   CAMZONE_INNER_DOOR_OPEN   | -         -          -       | ON        ON         ON
    //   CAMZONE_INNER_DOOR_CLOSE  | ON        ON         ON      | -         -          -
    //   LOADZONE_PARTITION1|2     | ON        ON         ON      | -         -          -
    //   //
    //   STAGE1_JIG_INTERLOCK      | -         -          -       | ON        ON         ON
    //   STAGE2_JIG_INTERLOCK      | -         -          -       | ON        ON         ON
  if not Common.SystemInfo.UseAssyPOCB then begin
    m_nDIValue := m_nDIValue
                   or DefDio.MASK_IN_STAGE1_SHUTTER_UP
                 //or DefDio.MASK_IN_STAGE1_SHUTTER_DOWN
                   or DefDio.MASK_IN_STAGE2_SHUTTER_UP
                 //or DefDio.MASK_IN_STAGE2_SHUTTER_DOWN
                   or DefDio.MASK_IN_SHUTTER_GUIDE_UP
                 //or DefDio.MASK_IN_SHUTTER_GUIDE_DOWN
                 //or DefDio.MASK_IN_CAMZONE_PARTITION_UP1
                 //or DefDio.MASK_IN_CAMZONE_PARTITION_UP2
                   or DefDio.MASK_IN_CAMZONE_PARTITION_DOWN1
                   or DefDio.MASK_IN_CAMZONE_PARTITION_DOWN2
                 //or DefDio.MASK_IN_STAGE1_EXLIGHT_DETECT
                 //or DefDio.MASK_IN_STAGE2_EXLIGHT_DETECT
                 //or DefDio.MASK_IN_STAGE1_WORKING_ZONE
                 //or DefDio.MASK_IN_STAGE2_WORKING_ZONE
                 //or DefDio.MASK_IN_STAGE1_VACUUM_1
                 //or DefDio.MASK_IN_STAGE1_VACUUM_2
                 //or DefDio.MASK_IN_STAGE2_VACUUM_1
                 //or DefDio.MASK_IN_STAGE2_VACUUM_2
                 //or DefDio.MASK_IN_CAMZONE_INNERT_DOOR_OPEN
                   or DefDio.MASK_IN_CAMZONE_INNERT_DOOR_CLOSE
                 //or DefDio.MASK_IN_STAGE1_JIG_INTERLOCK
                 //or DefDio.MASK_IN_STAGE2_JIG_INTERLOCK
                   or DefDio.MASK_IN_LOADZONE_PARTITION1
                   or DefDio.MASK_IN_LOADZONE_PARTITION2
                   ;
  end
  else begin
    m_nDIValue := m_nDIValue
                   or DefDio.MASK_IN_STAGE1_SHUTTER_UP
                 //or DefDio.MASK_IN_STAGE1_SHUTTER_DOWN
                   or DefDio.MASK_IN_STAGE2_SHUTTER_UP
                 //or DefDio.MASK_IN_STAGE2_SHUTTER_DOWN
                 //or DefDio.MASK_IN_SHUTTER_GUIDE_UP
                   or DefDio.MASK_IN_SHUTTER_GUIDE_DOWN
                   or DefDio.MASK_IN_CAMZONE_PARTITION_UP1
                   or DefDio.MASK_IN_CAMZONE_PARTITION_UP2
                 //or DefDio.MASK_IN_CAMZONE_PARTITION_DOWN1
                 //or DefDio.MASK_IN_CAMZONE_PARTITION_DOWN2
                 //or DefDio.MASK_IN_STAGE1_EXLIGHT_DETECT
                 //or DefDio.MASK_IN_STAGE2_EXLIGHT_DETECT
                 //or DefDio.MASK_IN_STAGE1_WORKING_ZONE
                 //or DefDio.MASK_IN_STAGE2_WORKING_ZONE
                 //or DefDio.MASK_IN_STAGE1_VACUUM_1
                 //or DefDio.MASK_IN_STAGE1_VACUUM_2
                 //or DefDio.MASK_IN_STAGE2_VACUUM_1
                 //or DefDio.MASK_IN_STAGE2_VACUUM_2
                   or DefDio.MASK_IN_CAMZONE_INNERT_DOOR_OPEN
                 //or DefDio.MASK_IN_CAMZONE_INNERT_DOOR_CLOSE
                   or DefDio.MASK_IN_STAGE1_JIG_INTERLOCK
                 //or DefDio.MASK_IN_STAGE2_JIG_INTERLOCK
                 //or DefDio.MASK_IN_LOADZONE_PARTITION1
                 //or DefDio.MASK_IN_LOADZONE_PARTITION2
                   ;
  end;
    {$IFDEF HAS_DIO_SCREW_SHUTTER}
  if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
    m_nDIValue := m_nDIValue
                 //or DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP   or DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP
                   or DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN or DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN;
  end;
    {$ENDIF}
  {$ELSEIF Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
    //
    // A2CHv4 (CH1/CH2 SHUTTER/SCREW_SHUTTER)
    //                             |         non-ASSY(Ready)
    //                             | CH1|CH2   CH1|CH2    CH1|CH2
    //                             | (Ready)   (Y-asix)   (Cam)
    //   --------------------------+---------+----------+---------
    //   CH1/2 SHUTTER_UP          | ON        ON         -
    //   CH1/2 SHUTTER_DOWN        | -         -          ON
    //   CH1/2 SCREW_SHUTTER_UP    | -         -          ON    //A2CHv4_#1&#2 //A2CHv4_#3(NoScrewShutter)
    //   CH1/2 SCREW_SHUTTER_DOWN  | ON        ON         -     //A2CHv4_#1&#2 //A2CHv4_#3(NoScrewShutter)
    //   //
    //   LOADZONE_PARTITION1|2     | ON        ON         ON
    //
    m_nDIValue := m_nDIValue   // Additional DI Set for simulation test
                 //or DefDio.MASK_IN_EMO1_FRONT
                 //or DefDio.MASK_IN_EMO2_RIGHT
                 //or DefDio.MASK_IN_EMO3_INNER_RIGHT
                 //or DefDio.MASK_IN_EMO4_INNER_LEFT
                 //or DefDio.MASK_IN_EMO5_LEFT
                 //or DefDio.MASK_IN_STAGE1_MUTING_LAMP
                 //or DefDio.MASK_IN_STAGE2_MUTING_LAMP
                 //or DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE
                 //or DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE
                 //or DefDio.MASK_IN_STAGE1_MAINT_DOOR1
                 //or DefDio.MASK_IN_STAGE1_MAINT_DOOR2
                 //or DefDio.MASK_IN_STAGE2_MAINT_DOOR1
                 //or DefDio.MASK_IN_STAGE2_MAINT_DOOR2
                 //or DefDio.MASK_IN_TEMPERATURE_ALARM
                 //or DefDio.MASK_IN_POWER_HIGH_ALARM
                   or DefDio.MASK_IN_STAGE1_SHUTTER_UP
                 //or DefDio.MASK_IN_STAGE1_SHUTTER_DOWN
                   or DefDio.MASK_IN_STAGE2_SHUTTER_UP
                 //or DefDio.MASK_IN_STAGE2_SHUTTER_DOWN
                 //or DefDio.MASK_IN_STAGE1_EXLIGHT_DETECT
                 //or DefDio.MASK_IN_STAGE2_EXLIGHT_DETECT
                 //or DefDio.MASK_IN_STAGE1_WORKING_ZONE
                 //or DefDio.MASK_IN_STAGE2_WORKING_ZONE
                 //or DefDio.MASK_IN_STAGE1_VACUUM_1
                 //or DefDio.MASK_IN_STAGE1_VACUUM_2
                 //or DefDio.MASK_IN_STAGE2_VACUUM_1
                 //or DefDio.MASK_IN_STAGE2_VACUUM_2
                  ;
    {$IFDEF HAS_DIO_SCREW_SHUTTER}
    if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
      m_nDIValue := m_nDIValue
                   //or DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP   or DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP
                     or DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN or DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN;
    end;
    {$ENDIF}
    //
    {$IFDEF HAS_DIO_IN_DOOR_LOCK}
    if Common.SystemInfo.HasDioInDoorLock then begin //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
      m_nDIValue    :=  m_nDIValue
                     or DefDio.MASK_IN_STAGE1_DOOR1_LOCK //TBD:DIO:2024-01?
                     or DefDio.MASK_IN_STAGE1_DOOR2_LOCK
                     or DefDio.MASK_IN_STAGE2_DOOR1_LOCK
                     or DefDio.MASK_IN_STAGE2_DOOR2_LOCK;
    end;
    {$ENDIF}
    {$IFDEF HAS_DIO_Y_AXIS_MC}
    if Common.SystemInfo.HasDioYAxisMC then begin //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
      m_nDIValue    :=  m_nDIValue
                     or DefDio.MASK_IN_STAGE1_Y_AXIS_MC //TBD:DIO:2024-01?
                     or DefDio.MASK_IN_STAGE1_Y_AXIS_MC;
    end;
    {$ENDIF}

    m_nDIValue := m_nDIValue and (not ($0  // Additional DI Clear for simulation test
                 //or DefDio.MASK_IN_LEFT_FAN_IN
                 //or DefDio.MASK_IN_RIGHT_FAN_IN
                 //or DefDio.MASK_IN_LEFT_FAN_OUT
                 //or DefDio.MASK_IN_RIGHT_FAN_OUT
                 //or DefDio.MASK_IN_STAGE1_LIGHT_CURTAIN
                 //or DefDio.MASK_IN_STAGE2_LIGHT_CURTAIN
                 //or DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE
                 //or DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE
                 //or DefDio.MASK_IN_CYLINDER_REGULATOR
                 //or DefDio.MASK_IN_VACUUM_REGULATOR
                 //or DefDio.MASK_IN_MC1
                 //or DefDio.MASK_IN_MC2
                 //or DefDio.MASK_IN_STAGE1_SHUTTER_DOWN  //초기화시, ShutterDown상태에서 Y축 이동 방지
                 //or DefDio.MASK_IN_STAGE2_SHUTTER_DOWN; //초기화시, ShutterDown상태에서 Y축 이동 방지
                 //or DefDio.MASK_IN_MAINPC_FAN_IN
                 //or DefDio.MASK_IN_MAINPC_FAN_OUT
                 //or DefDio.MASK_IN_CAMPC_FAN_IN
                 //or DefDio.MASK_IN_CAMPC_FAN_OUT
                 //
                 //or DefDio.MASK_IN_STAGE1_DOOR1_LOCK
                 //or DefDio.MASK_IN_STAGE1_DOOR2_LOCK
                 //or DefDio.MASK_IN_STAGE2_DOOR1_LOCK
                 //or DefDio.MASK_IN_STAGE2_DOOR2_LOCK
                 //or DefDio.MASK_IN_STAGE1_Y_AXIS_MC
                 //or DefDio.MASK_IN_STAGE2_Y_AXIS_MC
                ));
  {$ENDIF}

  m_nSimDioDIValue := m_nDIValue;
{$ENDIF} //SIMULATOR_DIO   //--------------------------------------------------------- SIMULATOR_DIO ...end

  m_nOldDIValue := m_nDIValue; //2019-04-05 (TBD:DIO:InitValueForAlarm)
  m_nDIOErr     := 0;
  m_bDioFirstReadDone := False;  //2019-04-04

  FMaintInDioUse := False;
  FIsReadyToTurn1 := False;
  FIsReadyToTurn2 := False;

  for i := 0 to Pred(DefDio.MAX_DIO_CNT) do begin
    m_nSetDio[i] := False;
    m_nGetDio[i] := False;
    m_nGetDioOut[i] := False;
  end;

  for i:= DefPocb.JIG_A to DefPocb.JIG_MAX do begin
    {$IFDEF POCB_A2CHv3}
    m_bAirKnifeSet[i] := False;
    {$ENDIF}
    m_bRestart[i]   := False;
    m_bStopFlag[i]  := False;
    m_IsOnDioRobotCtl[i] := False;
		{$IFDEF FEATURE_KEEP_SHUTTER_UP}
    m_bOnShutterUp[i] := False;
		{$ENDIF}
    FIsSensorTT[i] := False;
  end;
  m_bEmsFlag := False;
  //
  tmCheckDio := TTimer.Create(nil);
  tmCheckDio.Enabled  := False;
  tmCheckDio.Interval := nScanTime; // msec
  tmCheckDio.OnTimer  := OntmCheckDioTimer;
  //
{$IFDEF DIO_ALARM_THRESHOLD}
  m_nOldChangedDIValue := 0;
  m_nChangedDIValue    := 0;
{$ENDIF}
  //
{$IFDEF SIMULATOR_DIO}
  for i := 0 to Pred(DefDio.MAX_DIO_IN) do begin
    SimulatorDioInOnOff[i].nDelayOn  := 0;
    SimulatorDioInOnOff[i].nDelayOff := 0;
  end;
  tmrSimulatorDio := TTimer.Create(nil);
  tmrSimulatorDio.OnTimer  := OnSimulatorDioTimer;
  tmrSimulatorDio.Interval := SimulatorDioCheckInterval;
  tmrSimulatorDio.Enabled  := True;
{$ENDIF}
end;

destructor TDioCtl.Destroy;
begin
  //
//if tmCheckDio is TTimer then begin
  if tmCheckDio <> nil then begin
    tmCheckDio.Enabled := False;
    tmCheckDio.Free;
    tmCheckDio := nil;
  end;
  //
{$IFDEF SIMULATOR_DIO}
{$ELSE}
  {$IF Defined(USE_DIO_AXT)}      //A2CH
  //TBD:DIO:AXT? Distroy?
  {$ELSEIF Defined(USE_DIO_AXD)}  //F2CH|A2CHv2
  //TBD:DIO:AXD? Distroy?
  {$ELSEIF Defined(USE_DIO_ADLINK)}
  Release_Card(DefDio.CARDNUMBER_1);  //TBD???
  if m_nCardId >=0 then Release_Card(m_nCardId);  //EndDio
  {$IFEND}
{$ENDIF}
  //
  inherited;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC]
//    Called-by:
//
function TDioCtl.Connect: Boolean;
var
  nMode : integer;
  nRet  : Integer;
  sMsg  : string;
begin
  nMode := DefDio.MODE_DIO_CONNECT;
  sMsg  := 'DIO Connect';
  //--------------------------
{$IFDEF SIMULATOR_DIO}
  nRet := DefPocb.ERR_OK; //TBD:SIMULATOR:DIO?
{$ELSE}
  {$IF Defined(USE_DIO_AXT)}      //A2CH
  nRet := DioAxt.Connect;
  {$ELSEIF Defined(USE_DIO_AXD)}  //F2CH|A2CHv2
  nRet := DioAxd.Connect;
  {$ELSE}
  nRet := DefPocb.ERR_DIO_CONNECT;
  {$IFEND}
{$ENDIF}
  //--------------------------
  if (nRet = DefPocb.ERR_OK) then begin    // 0:OK, 1:TBD???
    //Common.MLog(DefPocb.SYS_LOG,'<DioCtl> '+sMSg+' OK');
    DongaDio.DioConnSt(nMode,1,sMsg);
    if Assigned(DongaDio.DioConnStMaint) then DongaDio.DioConnStMaint(nMode,1,sMsg);
    Result := True;
    Sleep(500); //500msec delay //2019-04-02
  end
  else begin
    //Common.MLog(DefPocb.SYS_LOG,'<DioCtl> '+sMSg+'Fail');
    DongaDio.DioConnSt(nMode,0,sMsg);
    if Assigned(DongaDio.DioConnStMaint) then DongaDio.DioConnStMaint(nMode,0,sMsg);
    Result := False;
  end;
  //-------------------------- Left/Right Switch Lock by default
{$IF Defined(POCB_A2CH)}
//SetDio(DefDio.OUT_DOOR_UNLOCK,False{bAllSet}); //TBD?
{$ELSEIF Defined(POCB_A2CHv2)}
  SetDio(DefDio.OUT_LEFT_LOCK_SWITCH,False{bAllSet});
  SetDio(DefDio.OUT_RIGHT_LOCK_SWITCH,False{bAllSet});
{$ELSE} //A2CHv3|A2CHv4
  SetDio(DefDio.OUT_STAGE1_SWITCH_UNLOCK,False{bAllSet});
  SetDio(DefDio.OUT_STAGE2_SWITCH_UNLOCK,False{bAllSet});
{$ENDIF}
  //-------------------------- AirKnife Off //2022-01-02
  SetAirKnife(DefPocb.JIG_A, False);
  SetAirKnife(DefPocb.JIG_B, False);

  //-------------------------- PG On/Off
  {$IFDEF HAS_DIO_PG_OFF}
  if Common.SystemInfo.HasDioOutPGOff then begin  //2023.05~ ATO|GA
    SetDoValue(DefDio.OUT_PG1_OFF,False); //PG ON
    SetDoValue(DefDio.OUT_PG2_OFF,False); //PG ON
  end;
  {$ENDIF}
  //-------------------------- Y-Axis MC ON
  {$IFDEF HAS_DIO_Y_AXIS_MC}
  if Common.SystemInfo.HasDioYAxisMC then begin  //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    SetDoValue(DefDio.OUT_STAGE1_Y_AXIS_MC_ON,True); //Y_AXIS_MC ON
    SetDoValue(DefDio.OUT_STAGE2_Y_AXIS_MC_ON,True); //Y_AXIS_MC ON
  end;
  {$ENDIF}
  //-------------------------- Stage Lamp Off
  {$IFDEF HAS_DIO_OUT_STAGE_LAMP}
  if Common.SystemInfo.HasDioOutStageLamp then begin //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    SetDoValue(DefDio.OUT_STAGE1_STAGE_LAMP_OFF,False); //Stage Lamp Off //TBD:DIO:2024-01?
    SetDoValue(DefDio.OUT_STAGE2_STAGE_LAMP_OFF,False); //Stage Lamp Off //TBD:DIO:2024-01?
  end;
  {$ENDIF}
  //-------------------------- IonBar ON
  {$IFDEF HAS_DIO_OUT_IONBAR}
  if Common.SystemInfo.HasDioOutIonBar then begin //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    SetDoValue(DefDio.OUT_STAGE1_IONBAR_ON,False); // IonBar ON //TBD:DIO:2024-01?
    SetDoValue(DefDio.OUT_STAGE2_IONBAR_ON,False); // IonBar ON //TBD:DIO:2024-01?
  end;
  {$ENDIF}
end;

procedure TDioCtl.GetUnitTTLog(nCh,nIdx : Integer);
var
  sLog : string;
begin
  sLog := '';
  case nIdx of
    DIO_IDX_GET_TT_START, DIO_IDX_GET_TT_CAM_RESET : begin
      FstwSensorTT[nCh] := TStopwatch.StartNew;
      FIsSensorTT[nCh]  := True;
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,'Start T/T Checking',DefPocb.LOG_TYPE_DIO);
    end
    else begin
      if not FIsSensorTT[nCh] then Exit;

      FstwSensorTT[nCh].Stop;
      case nIdx of
        DIO_IDX_GET_TT_FORWARD  : sLog := '[T/T] Arrived Forward ';
        DIO_IDX_GET_TT_SHT_DN   : sLog := '[T/T] Arrived Shutter Down ';
        DIO_IDX_GET_TT_SHT_UP   : sLog := '[T/T] Arrived Shutter UP ';
        DIO_IDX_GET_TT_BACKWARD : begin
          sLog := '[T/T] Arrived Backward ';
          FIsSensorTT[nCh] := False;
        end;
      end;

      sLog := sLog + Format('%0.3f Seconds',[FstwSensorTT[nCh].ElapsedMilliseconds / 1000]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sLog,DefPocb.LOG_TYPE_DIO);
      FstwSensorTT[nCh].Reset;

       case nIdx of
        DIO_IDX_GET_TT_FORWARD   :  begin
       {$IFDEF HAS_DIO_OUT_STAGE_LAMP}
         if Common.SystemInfo.HasDioOutStageLamp then DongaDio.SetStageLamp(nCh,False{LampOff});
       {$ENDIF}
        end;
        DIO_IDX_GET_TT_BACKWARD : begin
       {$IFDEF HAS_DIO_OUT_STAGE_LAMP}
         if Common.SystemInfo.HasDioOutStageLamp then DongaDio.SetStageLamp(nCh,True{LampON});
       {$ENDIF}
        end;
      end;




    end;
  end;
  FstwSensorTT[nCh].Start;
end;

//******************************************************************************
// procedure/function:
//******************************************************************************

//------------------------------------------------------------------------------
procedure TDioCtl.SetIsMainter(const Value: Boolean);
begin
  FIsMainter := Value;
end;


//------------------------------------------------------------------------------
procedure TDioCtl.SetDioConnSt(const Value: InDioConnSt);
begin
  FDioConnSt := Value;
end;

//------------------------------------------------------------------------------
procedure TDioCtl.SetDioConnStMaint(const Value: InDioConnStMaint);
begin
  FDioConnStMaint := Value;
end;

//------------------------------------------------------------------------------
procedure TDioCtl.SetDioOutReadSt(const Value: InDioOutReadSt);
begin
  FDioOutReadSt := Value;
end;

//------------------------------------------------------------------------------
procedure TDioCtl.SetDioOutReadStMaint(const Value: InDioOutReadStMaint);
begin
  FDioOutReadStMaint := Value;
end;

//******************************************************************************
// procedure/function:
//******************************************************************************

procedure TDioCtl.SetInDioStatus(const Value: InDioEvent);
begin
  FInDioStatus := Value;
end;

procedure TDioCtl.SetMaintInDioStatus(const Value: InDioEvent);
begin
  FMaintInDioStatus := Value;
end;

procedure TDioCtl.SetMaintInDioUse(const Value: Boolean);
begin
  FMaintInDioUse := Value;
  if Value then begin
    if Assigned(MaintInDioStatus) then  MaintInDioStatus(m_nGetDio, m_nSetDio);
  end;
end;

procedure TDioCtl.SetSetErrMsg(const Value: DioErrEvent);
begin
  FSetErrMsg := Value;
end;

procedure TDioCtl.SetArrivedUnload1(const Value: ArrivedEvent);
begin
  FArrivedUnload1 := Value;
end;

procedure TDioCtl.SetArrivedUnload2(const Value: ArrivedEvent);
begin
  FArrivedUnload2 := Value;
end;

function TDioCtl.SetAutoOffOut(lwSignal: Byte; nDelay : Integer): Integer;
var
  thLogic : TThread;
begin
  SetDoValue(lwSignal, True);

  thLogic := TThread.CreateAnonymousThread(
  procedure begin
    Common.Delay(nDelay);
    SetDoValue(lwSignal, False);
  end);

  thLogic.FreeOnTerminate := True;
  thLogic.Start;

  Result := 0;
end;

{$IFDEF SIMULATOR_DIO}

procedure TDioCtl.OnSimulatorDioTimer(Sender: TObject);
var
  nDioIn: UInt64;
  nDelay : Integer;
begin
  for nDioIn in [0..MAX_DIO_IN] do begin
    if SimulatorDioInOnOff[nDioIn].nDelayOn > 0 then begin
      nDelay := SimulatorDioInOnOff[nDioIn].nDelayOn - SimulatorDioCheckInterval;
      if nDelay > 0 then begin
        SimulatorDioInOnOff[nDioIn].nDelayOn := nDelay;
      end
      else begin
        m_nSimDioDIValue := m_nSimDioDIValue or (Uint64(1) shl nDioIn);
        SimulatorDioInOnOff[nDioIn].nDelayOn := 0;
      end;
    end;
    if SimulatorDioInOnOff[nDioIn].nDelayOff > 0 then begin
      nDelay := SimulatorDioInOnOff[nDioIn].nDelayOff - SimulatorDioCheckInterval;
      if nDelay > 0 then begin
        SimulatorDioInOnOff[nDioIn].nDelayOff := nDelay;
      end
      else begin
        m_nSimDioDIValue := m_nSimDioDIValue and (not (Uint64(1) shl nDioIn));
        SimulatorDioInOnOff[nDioIn].nDelayOff := 0;
      end;
    end;
  end;
end;

procedure TDioCtl.SimulatorAddDioIn(nDioIn: UInt64; bOn: Boolean; nDelay: Integer);
begin
  if bOn then SimulatorDioInOnOff[nDioIn].nDelayOn  := nDelay
  else        SimulatorDioInOnOff[nDioIn].nDelayOff := nDelay;
end;

{$IFDEF HAS_DIO_IN64}
procedure TDioCtl.SimulatorDioSetIn(nDioInMask: UInt64);
{$ELSE}
procedure TDioCtl.SimulatorDioSetIn(nDioInMask: DWORD);
{$ENDIF}
begin
  m_nSimDioDIValue := m_nDIValue or nDioInMask;
end;

{$IFDEF HAS_DIO_IN64}
procedure TDioCtl.SimulatorDioClrIn(nDioInMask: UInt64);
{$ELSE}
procedure TDioCtl.SimulatorDioClrIn(nDioInMask: DWORD);
{$ENDIF}
begin
  m_nSimDioDIValue := m_nDIValue and (not nDioInMask);
end;

procedure TDioCtl.SimulatorDioOutEvent(nDioOut: Integer; bOn: Boolean);
var
  cdDioOutTarget : UInt64;
begin
  case nDioOut of
    DefDio.OUT_STAGE1_READY_LED: begin
      if bOn then begin
      //CodeSite.Send('SIM:DIO::CH1:READY1:1');
        {$IFDEF SUPPORT_1CG2PANEL}
        if not Common.SystemInfo.UseAssyPOCB then begin
        {$ENDIF}
          //CodeSite.Send('SIM:DIO:CH1:READY:2');
          SimulatorAddDioIn(DefDio.IN_STAGE1_READY,True, 500);  //On
          SimulatorAddDioIn(DefDio.IN_STAGE1_READY,False,1000); //Off
        {$IFDEF SUPPORT_1CG2PANEL}
        end
        else begin
          cdDioOutTarget := MASK_OUT_STAGE1_READY_LED or MASK_OUT_STAGE2_READY_LED;
          if (m_nDOValue and cdDioOutTarget) = cdDioOutTarget then begin
						//CodeSite.Send('SIM:DIO:CH1:READY:2');
            SimulatorAddDioIn(DefDio.IN_STAGE1_READY,True, 500);  //On
            SimulatorAddDioIn(DefDio.IN_STAGE1_READY,False,1000); //Off
          end;
        end;
        {$ENDIF} //SUPPORT_1CG2PANEL
      end;
    end;
    DefDio.OUT_STAGE2_READY_LED: begin
      if bOn then begin
        //CodeSite.Send('SIM:DIO:CH2:READY:1');
        {$IFDEF SUPPORT_1CG2PANEL}
        if not Common.SystemInfo.UseAssyPOCB then begin
        {$ENDIF}
          //CodeSite.Send('SIM:DIO:CH2:READY:2');
          SimulatorAddDioIn(DefDio.IN_STAGE2_READY,True, 500);  //On
          SimulatorAddDioIn(DefDio.IN_STAGE2_READY,False,1000); //Off
        {$IFDEF SUPPORT_1CG2PANEL}
        end
        else begin
          cdDioOutTarget := MASK_OUT_STAGE1_READY_LED or MASK_OUT_STAGE2_READY_LED;
          if (m_nDOValue and cdDioOutTarget) = cdDioOutTarget then begin
						//CodeSite.Send('SIM:DIO:CH2:READY:2');
            SimulatorAddDioIn(DefDio.IN_STAGE2_READY,True, 500);  //On
            SimulatorAddDioIn(DefDio.IN_STAGE2_READY,False,1000); //Off
          end;
        end;
        {$ENDIF} //SUPPORT_1CG2PANEL
      end;
    end;
  //DefDio.OUT_MC_RESET_SW_LED:
  //DefDio.OUT_STAGE1_LED_LAMP:
  //DefDio.OUT_STAGE2_LED_LAMP:
  //DefDio.OUT_LAMP_RED:
  //DefDio.OUT_LAMP_YELLOW:
  //DefDio.OUT_LAMP_GREEN:
  //DefDio.OUT_MELODY1:
  //DefDio.OUT_MELODY2:
  //DefDio.OUT_MELODY3:
  //DefDio.OUT_MELODY4:
  //DefDio.OUT_STAGE1_SWITCH_UNLOCK:
  //DefDio.OUT_STAGE2_SWITCH_UNLOCK:
  //DefDio.OUT_STAGE1_MAINT_DOOR1_UNLOCK:
  //DefDio.OUT_STAGE1_MAINT_DOOR2_UNLOCK:
  //DefDio.OUT_STAGE2_MAINT_DOOR1_UNLOCK:
  //DefDio.OUT_STAGE2_MAINT_DOOR2_UNLOCK:
    DefDio.OUT_STAGE1_SHUTTER_UP: begin
      if bOn then begin
        SimulatorAddDioIn(DefDio.IN_STAGE1_SHUTTER_DOWN,False, 30);
        SimulatorAddDioIn(DefDio.IN_STAGE1_SHUTTER_UP,True,500);
      end;
    end;
    DefDio.OUT_STAGE1_SHUTTER_DOWN: begin
      if bOn then begin
        SimulatorAddDioIn(DefDio.IN_STAGE1_SHUTTER_UP,False, 30);
        SimulatorAddDioIn(DefDio.IN_STAGE1_SHUTTER_DOWN,True,500);
      end;
    end;
    DefDio.OUT_STAGE2_SHUTTER_UP: begin
      if bOn then begin
        SimulatorAddDioIn(DefDio.IN_STAGE2_SHUTTER_DOWN,False, 30);
        SimulatorAddDioIn(DefDio.IN_STAGE2_SHUTTER_UP,True,500);
      end;
    end;
    DefDio.OUT_STAGE2_SHUTTER_DOWN: begin
      if bOn then begin
        SimulatorAddDioIn(DefDio.IN_STAGE2_SHUTTER_UP,False, 30);
        SimulatorAddDioIn(DefDio.IN_STAGE2_SHUTTER_DOWN,True,500);
      end;
    end;
		
	{$IFDEF HAS_DIO_SCREW_SHUTTER} 
    DefDio.OUT_STAGE1_SCREW_SHUTTER_UP: begin
      if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
        if bOn then begin
          SimulatorAddDioIn(DefDio.IN_STAGE1_SCREW_SHUTTER_DOWN,False, 30);
          SimulatorAddDioIn(DefDio.IN_STAGE1_SCREW_SHUTTER_UP,True,200);
        end;
      end;
    end;
    DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN: begin
      if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
        if bOn then begin
          SimulatorAddDioIn(DefDio.IN_STAGE1_SCREW_SHUTTER_UP,False, 30);
          SimulatorAddDioIn(DefDio.IN_STAGE1_SCREW_SHUTTER_DOWN,True,200);
        end;
      end;
    end;
    DefDio.OUT_STAGE2_SCREW_SHUTTER_UP: begin
      if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
        if bOn then begin
          SimulatorAddDioIn(DefDio.IN_STAGE2_SCREW_SHUTTER_DOWN,False, 30);
          SimulatorAddDioIn(DefDio.IN_STAGE2_SCREW_SHUTTER_UP,True,200);
        end;
      end;
    end;
    DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN: begin
      if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
        if bOn then begin
          SimulatorAddDioIn(DefDio.IN_STAGE2_SCREW_SHUTTER_UP,False, 30);
          SimulatorAddDioIn(DefDio.IN_STAGE2_SCREW_SHUTTER_DOWN,True,200);
        end;
      end;
    end;
  {$ENDIF}
					
    {$IFDEF SUPPORT_1CG2PANEL}
    DefDio.OUT_SHUTTER_GUIDE_UP: begin
      if bOn then begin
        SimulatorAddDioIn(DefDio.IN_SHUTTER_GUIDE_DOWN,False, 30);
        SimulatorAddDioIn(DefDio.IN_SHUTTER_GUIDE_UP,True,500);
      end;
    end;
    DefDio.OUT_SHUTTER_GUIDE_DOWN: begin
      if bOn then begin
        SimulatorAddDioIn(DefDio.IN_SHUTTER_GUIDE_UP,False, 30);
        SimulatorAddDioIn(DefDio.IN_SHUTTER_GUIDE_DOWN,True,500);
      end;
    end;
    {$ENDIF} //SUPPORT_1CG2PANEL
    DefDio.OUT_STAGE1_VACUUM1: begin
      SimulatorAddDioIn(DefDio.IN_STAGE1_VACUUM1,bOn, 30);
    end;
    DefDio.OUT_STAGE1_VACUUM2: begin
      SimulatorAddDioIn(DefDio.IN_STAGE1_VACUUM2,bOn, 30);
    end;
    DefDio.OUT_STAGE2_VACUUM1: begin
      SimulatorAddDioIn(DefDio.IN_STAGE2_VACUUM1,bOn, 30);
    end;
    DefDio.OUT_STAGE2_VACUUM2: begin
      SimulatorAddDioIn(DefDio.IN_STAGE2_VACUUM2,bOn, 30);
    end;
  //DefDio.OUT_STAGE1_DESTRUCTION_SOL1:
  //DefDio.OUT_STAGE1_DESTRUCTION_SOL2:
  //DefDio.OUT_STAGE2_DESTRUCTION_SOL1:
  //DefDio.OUT_STAGE2_DESTRUCTION_SOL2:
  //DefDio.OUT_STAGE1_ROBOT_STICK_PLUS:
  //DefDio.OUT_STAGE1_ROBOT_STICK_MINUS:
  //DefDio.OUT_STAGE1_ROBOT_MANUAL_AUTO:
  //DefDio.OUT_STAGE1_ROBOT_PAUSE:
  //DefDio.OUT_STAGE1_ROBOT_STOP:
  //DefDio.OUT_STAGE2_ROBOT_STICK_PLUS:
  //DefDio.OUT_STAGE2_ROBOT_STICK_MINUS:
  //DefDio.OUT_STAGE2_ROBOT_MANUAL_AUTO:
  //DefDio.OUT_STAGE2_ROBOT_PAUSE:
  //DefDio.OUT_STAGE2_ROBOT_STOP:
  //DefDio.OUT_ROBOT_RESET_SW_LED:
  //DefDio.OUT_AIR_KNIFE:
	  {$IFDEF HAS_DIO_PG_OFF} //ATO|GAGO
  //DefDio.OUT_PG1_OFF:
  //DefDio.OUT_PG2_OFF:
    {$ENDIF}
    {$IFDEF HAS_DIO_Y_AXIS_MC}
    DefDio.OUT_STAGE1_Y_AXIS_MC_ON: begin
      SimulatorAddDioIn(DefDio.IN_STAGE1_Y_AXIS_MC,bOn, 10);
    end;
    DefDio.OUT_STAGE2_Y_AXIS_MC_ON: begin
      SimulatorAddDioIn(DefDio.IN_STAGE2_Y_AXIS_MC,bOn, 10);
    end;
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_STAGE_LAMP}
  //DefDio.OUT_STAGE1_STAGE_LAMP_OFF:
  //DefDio.OUT_STAGE2_STAGE_LAMP_OFF:
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_IONBAR}
  //DefDio.OUT_STAGE1_IONBAR_ON:
  //DefDio.OUT_STAGE2_IONBAR_ON:
    {$ENDIF}

  end;
end;
{$ENDIF}  // SIMULATOR_DIO

procedure TDioCtl.SetIsReadyToTurn1(const Value: Boolean);
var
{$IFDEF HAS_DIO_IN64}
  cdOutSig : UInt64;
{$ELSE}
  cdOutSig : Cardinal;
{$ENDIF}
begin
      if Value then begin
        // back Sensor가 들어왔을때만 Set 될수 있도록 하자.
        if (DongaMotion.m_nMotorDIValue and DefMotion.MASK_IN_MOTOR_STAGE1_BACKWARD) <> 0 then begin
          FIsReadyToTurn1 := Value;
          m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_READY;
          cdOutSig := m_nDOValue or DefDio.MASK_OUT_STAGE1_READY_LED;
          SetDio(cdOutSig,True);  //2021-01-XX (Trur->False)
        end;
      end
      else begin
        FIsReadyToTurn1 := Value;
        m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_NONE;
        cdOutSig := m_nDOValue and (not DefDio.MASK_OUT_STAGE1_READY_LED);
        SetDio(cdOutSig,True);
      end;
end;

procedure TDioCtl.SetIsReadyToTurn2(const Value: Boolean);
var
{$IFDEF HAS_DIO_IN64}
  cdOutSig : UInt64;
{$ELSE}
  cdOutSig : Cardinal;
{$ENDIF}
begin
  if Value then begin
    // back Sensor가 들어왔을때만 Set 될수 있도록 하자.
    if (DongaMotion.m_nMotorDIValue and DefMotion.MASK_IN_MOTOR_STAGE2_BACKWARD) <> 0 then begin
      FIsReadyToTurn2 := Value;
      m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_READY;
      cdOutSig := m_nDOValue or DefDio.MASK_OUT_STAGE2_READY_LED;
      SetDio(cdOutSig,True);
    end;
  end
  else begin
    FIsReadyToTurn2 := Value;
    m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_NONE;
    cdOutSig := m_nDOValue and (not DefDio.MASK_OUT_STAGE2_READY_LED);
    SetDio(cdOutSig,True);
  end;
end;

{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)} //##############################################
function TDioCtl.IsShutterUp(nCh: Integer): Boolean; //A2CH|A2CHv2
var
  bIsShutterUp: Boolean;
begin
  bIsShutterUp := False;
  case nCh of
    DefPocb.CH_1: begin
      if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) <> 0) and
         ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) = 0) and
       //((m_nDOValue and (1 shl DefDio.OUT_STAGE1_SHUTTER_UP)) = 0) and
         ((m_nDOValue and (1 shl DefDio.OUT_STAGE1_SHUTTER_DOWN)) = 0) then begin
         bIsShutterUp := True;
      end;
    end;
    DefPocb.CH_2: begin
      if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) <> 0) and
         ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) = 0) and
       //((m_nDOValue and (1 shl DefDio.OUT_STAGE2_SHUTTER_UP)) = 0) and
         ((m_nDOValue and (1 shl DefDio.OUT_STAGE2_SHUTTER_DOWN)) = 0) then begin
         bIsShutterUp := True;
      end;
    end;
  end;
  Result := bIsShutterUp;
end;

function TDioCtl.CheckShutterState(nCh: Integer; value : ShutterState): Boolean; //A2CH|A2CHv2
var
  arrUpDi : array[DefPocb.CH_1..DefPocb.CH_MAX] of Integer;
  arrDwDi : array[DefPocb.CH_1..DefPocb.CH_MAX] of Integer;
begin
  Result := False;

  arrUpDi[DefPocb.CH_1] := DefDio.IN_STAGE1_SHUTTER_UP;
  arrUpDi[DefPocb.CH_2] := DefDio.IN_STAGE2_SHUTTER_UP;

  arrDwDi[DefPocb.CH_1] := DefDio.IN_STAGE1_SHUTTER_DOWN;
  arrDwDi[DefPocb.CH_2] := DefDio.IN_STAGE2_SHUTTER_DOWN;

  case value of
    OFF:  Result := CheckState(arrUpDi[nCh],False) and CheckState(arrDwDi[nCh],False);
    UP:   Result := CheckState(arrUpDi[nCh],True)  and CheckState(arrDwDi[nCh],False);
    DOWN: Result := CheckState(arrUpDi[nCh],False) and CheckState(arrDwDi[nCh],True);
  end;
end;

{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}  //##############################################
function TDioCtl.CheckShutterState(nCh: Integer; value : ShutterState): Boolean; //A2CHv3|A2CHv4|ATO|GAGO
begin
  Result := False;

  case value of
    //
    ShutterState.UP: begin
      {$IFDEF SUPPORT_1CG2PANEL}
      if (not Common.SystemInfo.UseAssyPOCB) then begin  // [non-ASSY] ShutterUP+ScrewShutterDOWN(+ShuterGuideUP)
      {$ENDIF}
 			  {$IFDEF HAS_DIO_SCREW_SHUTTER}			
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          case nCh of
            DefPocb.CH_1: begin
              if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0)} and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0) and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) = 0) and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) = 0)} then 
							   Result := True;
            end;
            DefPocb.CH_2: begin
              if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0)} and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0) and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) = 0) and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) = 0)} then
                Result := True;
            end;
          end;
        end
        else begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
        {$ENDIF}											
          case nCh of
            DefPocb.CH_1: begin
              if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0)} and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0) then
                Result := True;
            end;
            DefPocb.CH_2: begin
              if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0)} and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0) then
                Result := True;
            end;
          end;
			  {$IFDEF HAS_DIO_SCREW_SHUTTER}								
        end;
        {$ENDIF}											
      {$IFDEF SUPPORT_1CG2PANEL}
      end
      else begin  // [ASSY] ShutterUP+ScrewShutterDOWN+ShutterGuideDOWN
        {$IFDEF SUPPORT_1CG2PANEL}			
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) <> 0)  {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) = 0)} then
            Result := True;
        end
        else begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
        {$ENDIF}															
          if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) = 0)} then
            Result := True;
        {$IFDEF SUPPORT_1CG2PANEL}										
        end;
        {$ENDIF}																			
      end;
      {$ENDIF} //SUPPORT_1CG2PANEL
    end;
    //
    ShutterState.DOWN: begin  // [non-ASSY] ShutterDOWN+ScrewShutterUP(+ShuterGuideUP)  [ASSY] ShutterDOWN+ScrewShutterUP+ShutterGuideUP
      {$IFDEF SUPPORT_1CG2PANEL}
      if (not Common.SystemInfo.UseAssyPOCB) then begin // [non-ASSY]
      {$ENDIF}
			  {$IFDEF HAS_DIO_SCREW_SHUTTER}																									
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          case nCh of
            DefPocb.CH_1: begin
              if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0) and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0)} and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) = 0)} and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) = 0) then
                Result := True;
            end;
            DefPocb.CH_2: begin
              if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0)  and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0) and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0)} and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) = 0)} and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN) = 0) then
                Result := True;
            end;
          end;
        end
        else begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
        {$ENDIF}																			
          case nCh of
            DefPocb.CH_1: begin
              if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0) and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0)} then
                Result := True;
            end;
            DefPocb.CH_2: begin
              if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0)  and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0) and
                 ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0)} then
                Result := True;
            end;
          end;
			  {$IFDEF HAS_DIO_SCREW_SHUTTER}													
        end;
        {$ENDIF}																			
      {$IFDEF SUPPORT_1CG2PANEL}
      end
      else begin
			  {$IFDEF HAS_DIO_SCREW_SHUTTER}											
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0)  and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) = 0) then
            Result := True;
        end
        else begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
        {$ENDIF}																			
          if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0)  and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0) and
             ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) <> 0) {and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0)} and
             ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) = 0) then
            Result := True;
			  {$IFDEF HAS_DIO_SCREW_SHUTTER}														
        end;
        {$ENDIF}																			
      end;
      {$ENDIF} //SUPPORT_1CG2PANEL
    end;
  end;
end;
{$ENDIF}

{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)} //########################################
function TDioCtl.IsDoorClosed(bCheckUnderDoor: Boolean; nCh: Integer = -1): Boolean; //A2CH|A2CHv2
begin
  case nCh of
    DefPocb.CH_1: begin
      if ((m_nDIValue and DefDio.MASK_IN_DOOR_LEFT) <> 0) then
        Exit(False);
      if bCheckUnderDoor then begin
  {$IFDEF POCB_A2CH}
        if ((m_nDIValue and DefDio.MASK_IN_DOOR_UNDER) <> 0) then
  {$ELSE} //F2CH|A2CHv2
        if ((m_nDIValue and DefDio.MASK_IN_DOOR_UNDER_LEFT1) <> 0) or ((m_nDIValue and DefDio.MASK_IN_DOOR_UNDER_LEFT2) <> 0) then
  {$ENDIF}
          Exit(False);
      end;
    end;
    DefPocb.CH_2: begin
      if ((m_nDIValue and DefDio.MASK_IN_DOOR_RIGHT) <> 0) then
        Exit(False);
      if bCheckUnderDoor then begin
  {$IFDEF POCB_A2CH}
        if ((m_nDIValue and DefDio.MASK_IN_DOOR_UNDER) <> 0) then
  {$ELSE} //F2CH|A2CHv2
        if ((m_nDIValue and DefDio.MASK_IN_DOOR_UNDER_RIGHT1) <> 0) or ((m_nDIValue and DefDio.MASK_IN_DOOR_UNDER_RIGHT2) <> 0) then
  {$ENDIF}
          Exit(False);
      end;
    end;
    else begin
      if ((m_nDIValue and DefDio.MASK_IN_DOOR_LEFT) <> 0) or ((m_nDIValue and DefDio.MASK_IN_DOOR_RIGHT) <> 0) then
        Exit(False);
      if bCheckUnderDoor then begin
  {$IFDEF POCB_A2CH}
        if ((m_nDIValue and DefDio.MASK_IN_DOOR_UNDER) <> 0) then
  {$ELSE} //F2CH|A2CHv2
        if ((m_nDIValue and DefDio.MASK_IN_DOOR_UNDER_LEFT1)  <> 0) or ((m_nDIValue and DefDio.MASK_IN_DOOR_UNDER_LEFT2)  <> 0) or
           ((m_nDIValue and DefDio.MASK_IN_DOOR_UNDER_RIGHT1) <> 0) or ((m_nDIValue and DefDio.MASK_IN_DOOR_UNDER_RIGHT2) <> 0) then
  {$ENDIF}
          Exit(False);
      end;
    end;
  end;
  Result := True;
end;

{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)} //########################################
function TDioCtl.IsDoorClosed(bCheckUnderDoor{dummy}: Boolean; nCh: Integer = -1): Boolean; //A2CHv3|A2CHv4|ATO|GAGO
begin
  Result := False;
  //
  case nCh of
    DefPocb.CH_1: begin
      if ((m_nDIValue and DefDio.MASK_IN_STAGE1_DOOR1_OPEN) = 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE1_DOOR2_OPEN) = 0) then
        Result := True;
    end;
    DefPocb.CH_2: begin
      if ((m_nDIValue and DefDio.MASK_IN_STAGE2_DOOR1_OPEN) = 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE2_DOOR2_OPEN) = 0) then
        Result := True;
    end;
    else begin
      if ((m_nDIValue and DefDio.MASK_IN_STAGE1_DOOR1_OPEN) = 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE1_DOOR2_OPEN) = 0) and
         ((m_nDIValue and DefDio.MASK_IN_STAGE2_DOOR1_OPEN) = 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE2_DOOR2_OPEN) = 0) then
        Result := True;
    end;
  end;
end;
{$ENDIF}

{$IFDEF SUPPORT_1CG2PANEL}  //A2CHv3
function TDioCtl.CheckCamZonePartDoor(bIsOpen: Boolean): Boolean;  //A2CHv3:DIO
begin
  Result := False;
  //
  if bIsOpen then begin
    if ((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_UP1) <> 0) and ((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_UP2) <> 0) and
       ((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_DOWN1) = 0) and ((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_DOWN2) = 0) and
       ((m_nDIValue and DefDio.MASK_IN_CAMZONE_INNERT_DOOR_OPEN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_CAMZONE_INNERT_DOOR_CLOSE) = 0) then begin
      Result := True;
    end;
  end
  else begin
    if ((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_UP1) = 0) and ((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_UP2) = 0) and
       ((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_DOWN1) <> 0) and ((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_DOWN2) <> 0) and
       ((m_nDIValue and DefDio.MASK_IN_CAMZONE_INNERT_DOOR_OPEN) = 0) and ((m_nDIValue and DefDio.MASK_IN_CAMZONE_INNERT_DOOR_CLOSE) <> 0) then begin
      Result := True;
    end;
  end;
end;
{$ENDIF} //SUPPORT_1CG2PANEL

//******************************************************************************
// procedure/function: Timer
//    - procedure TDongaDio.OntmCheckDioTimer(Sender: TObject)
//    - procedure TDongaDio.GetAllDio;
//    - procedure TDongaDio.GetAllDioCh1;
//    - procedure TDongaDio.GetAllDioCh2;
//******************************************************************************

procedure TDioCtl.OntmCheckDioTimer(Sender: TObject);
begin
  tmCheckDio.Enabled := False;
  GetAllDio;        // DI Read and Processing
  tmCheckDio.Enabled := True;
end;

//##############################################################################################
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)} //#############################################
//##############################################################################################

//##############################################################################################
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)} //#######################################
//##############################################################################################

procedure TDioCtl.GetAllDio;    //A2CHv3|A2CHv4|ATO|GAGO
var
  cdDioRead1, cdDioRead2 : DWORD;
  cdDioTemp, wDioTemp, cdDioTarget, cdDioOutSig : UInt64;
  dMaskDio, dMaskDioAlarms, dMaskThresholdAlarms : UInt64; //2022-07-15 A2CHv4_#3(No ScrewShutter)
  i, nJig : Integer;
  sErrMsg : string;
  sTemp   : string;
  bCh1GetDio : Boolean;
  bCh2GetDio : Boolean;
begin
  bCh1GetDio := True;
  bCh2GetDio := True;

  {$IFDEF SIMULATOR_DIO}
  cdDioTemp := m_nSimDioDIValue;
  {$ELSE}
  cdDioRead1  := DioAxd.ReadDioIn32(0{DioInModuleOffset});
  cdDioRead2  := DioAxd.ReadDioIn32(1{DioInModuleOffset});
  cdDioTemp   := ((UInt64(cdDioRead2) shl 32) or UInt64(cdDioRead1));
  //CodeSite.Send('DIO-IN:'+Format('1(%08x) 0(%08x) %016x',[cdDioRead2,cdDioRead1,cdDioTemp]));
  {$ENDIF}
  m_nDIValue  := cdDioTemp;
  DongaRobot.RobotDioIN := m_nDIValue;
  for i := 0 to MAX_DIO_IN do begin  //F2CH: Pred(DefDio.MAX_DIO_CNT) -> MAX_DIO_IN
    wDioTemp := (UInt64(1) shl i);    // For 64 bit operation on 32bit build, constant value should be cast to UInt64 !!!
    if (wDioTemp and cdDioTemp) <> 0 then m_nGetDio[i] := True
    else                                  m_nGetDio[i] := False;
  end;
  if not m_bDioFirstReadDone then begin //2019-04-04
    m_bDioFirstReadDone := True;
    InDioStatus(m_nGetDio, m_nSetDio);
    {$IFDEF FEATURE_KEEP_SHUTTER_UP}
    if Common.SystemInfo.KeepDioShutterUp then begin
      if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) <> 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0) then SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
      if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) <> 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0) then SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
    end;
    {$ENDIF}
  end;
  {$IFDEF DIO_ALARM_THRESHOLD}
  m_nOldChangedDIValue := m_nChangedDIValue;
  m_nChangedDIValue    := m_nDIValue xor m_nOldDIValue;
  {$ENDIF}

  //--------------------------------------------------------
  {$IFNDEF SIMULATOR_DIO}
  //2022-03-15 Move from (inner UseAssyPOCB)
  DongaMotion.Motion[MOTIONID_AxMC_STAGE1_Y].m_bDioYaxisLoadPos := ((m_nDIValue and DefDio.MASK_IN_STAGE1_MUTING_LAMP) <> 0);
  DongaMotion.Motion[MOTIONID_AxMC_STAGE2_Y].m_bDioYaxisLoadPos := ((m_nDIValue and DefDio.MASK_IN_STAGE2_MUTING_LAMP) <> 0);
  {$ENDIF}
  {$IFDEF SUPPORT_1CG2PANEL}
  if Common.SystemInfo.UseAssyPOCB and (DongaMotion <> nil) then begin
    if ((m_nDIValue and DefDio.MASK_IN_STAGE1_JIG_INTERLOCK) <> 0) then begin  //2021-05-31 (move from GetAllDioChAssyPOCB)
      DongaMotion.m_bDioAssyJigOn := True;
      if DongaMotion.Motion[MOTIONID_AxMC_STAGE1_Y].m_bConnected and DongaMotion.Motion[MOTIONID_AxMC_STAGE2_Y].m_bConnected then begin
        if DongaMotion.Motion[MOTIONID_AxMC_STAGE1_Y].m_MotionStatus.nSyncStatus = DefMotion.SyncLinkMaster then begin
          if ((m_nDIValue and DefDio.MASK_IN_STAGE2_JIG_INTERLOCK) <> 0) then begin
            if DongaMotion.Motion[MOTIONID_AxMC_STAGE1_Y].m_MotionStatus.IsInMotion then begin
              Common.CodeSiteSend('<DIO> GetAllDio:AssyJigDetected&AssyJigMisAligned:MOTION-ESTOP');
              DongaMotion.Motion[MOTIONID_AxMC_STAGE1_Y].MoveStop(True{bIsEMS});
            end;
          end;
        end
        else begin
          if (not FMaintInDioUse) then begin
            if (not DongaMotion.Motion[MOTIONID_AxMC_STAGE1_Y].m_bHomeSearching) and
               (not DongaMotion.Motion[MOTIONID_AxMC_STAGE1_Y].m_MotionStatus.IsInMotion) then begin
              Common.CodeSiteSend('<DIO> GetAllDio:AssyJigDetected:SetYAxisSyncMode');
              DongaMotion.SetYAxisSyncMode; //TBD:A2CHv3:MOTION? (SYNC-MOVE)
            end;
          end;
        end;
      end;
    end
    else begin
      DongaMotion.m_bDioAssyJigOn := False;
    end;
  end;
  {$ENDIF} //SUPPORT_1CG2PANEL

  //--------------------------------------------------------
  if (m_nDIValue <> m_nOldDIValue) or (DongaMotion.m_nOldMotorDIValue <> DongaMotion.m_nMotorDIValue)
      or DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_bServoRecover
      or DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bServoRecover then begin

    //----------------------------------
    if (m_nDIValue <> m_nOldDIValue) then begin
      InDioStatus(m_nGetDio, m_nSetDio);
      if FMaintInDioUse then begin
        if Assigned(MaintInDioStatus) then MaintInDioStatus(m_nGetDio, m_nSetDio);
      end;
      //---------------------- if Door Closed & LAMP On, then Lamp Turn Off
      {  //A2CHv3: N/A (CAMZONE_LED_LAMP is controlled by Safety PLC)
      if (m_nDIValue and DefDio.MASK_IN_STAGE1_MAINT_DOOR2) = 0 then begin  //closed
        if (m_nDOValue and DefDio.MASK_OUT_STAGE1_LED_LAMP) <> 0 then SetDio(DefDio.OUT_STAGE1_LED_LAMP);  //off
      end
      else begin
        if (m_nDOValue and DefDio.MASK_OUT_STAGE1_LED_LAMP) = 0 then SetDio(DefDio.OUT_STAGE1_LED_LAMP);   //on
      end;
      if (m_nDIValue and DefDio.MASK_IN_STAGE2_MAINT_DOOR2) = 0 then begin  //closed
        if (m_nDOValue and DefDio.MASK_OUT_STAGE2_LED_LAMP) <> 0 then SetDio(DefDio.OUT_STAGE2_LED_LAMP);  //off
      end
      else begin
        if (m_nDOValue and DefDio.MASK_OUT_STAGE2_LED_LAMP) = 0 then SetDio(DefDio.OUT_STAGE2_LED_LAMP);   //on
      end;
      }
      //---------------------- MC1/MC2 ON<->OFF
      if ((m_nDIValue and DefDio.MASK_IN_MC1) = 0) or ((m_nDIValue and DefDio.MASK_IN_MC2) = 0) then begin // MC1|MC2 down
        if (m_nDOValue and DefDio.MASK_OUT_RESET_SW_LED) = 0 then SetDio(DefDio.OUT_RESET_SW_LED); // ResetBtn Led ON
        if (m_nDOValue and DefDio.MASK_OUT_ROBOT_RESET_SW_LED) = 0 then SetDio(DefDio.OUT_ROBOT_RESET_SW_LED); // Robot ResetBtn ON
      end
      else begin
        if (m_nDOValue and DefDio.MASK_OUT_RESET_SW_LED) <> 0 then SetDio(DefDio.OUT_RESET_SW_LED); // ResetBtn Led OFF
        if (m_nDOValue and DefDio.MASK_OUT_ROBOT_RESET_SW_LED) <> 0 then begin  // Robot ResetBtn OFF  //TBD:A2CHv3:DIO? (RobotResetBtnLen Off?)
          if (DongaRobot.Robot[DefRobot.ROBOT_CH1].m_RobotStatusCoord.RobotLight in
                [ROBOT_TM_LIGHT_03_SolidBlue_StandbyInAutoMode, ROBOT_TM_LIGHT_04_FlashingBlue_AutoMode,
                 ROBOT_TM_LIGHT_05_SloidGreen_StandbyInManualMode, ROBOT_TM_LIGHT_06_FlashingGreen_ManualMode])
              and
             (DongaRobot.Robot[DefRobot.ROBOT_CH2].m_RobotStatusCoord.RobotLight in
                [ROBOT_TM_LIGHT_03_SolidBlue_StandbyInAutoMode, ROBOT_TM_LIGHT_04_FlashingBlue_AutoMode,
                 ROBOT_TM_LIGHT_05_SloidGreen_StandbyInManualMode, ROBOT_TM_LIGHT_06_FlashingGreen_ManualMode]) then
            SetDio(DefDio.OUT_ROBOT_RESET_SW_LED);
        end;
      end;
    end;

    //------------------------ EMS 신호가 들어오면, 모든 Out Signal Off ==> Lamp RED, Buzzer ON.
    cdDioTarget := DefDio.MASK_IN_EMO_ALL;
    if (m_nDIValue and cdDioTarget) <> 0 then begin
      // vacuum을 살려 놔야 함.
      DongaMotion.m_nMotorPreEmsDOValue := DongaMotion.m_nMotorDOValue;  //TBD:MOTION? (EMS Reset시, 이전 Motion 동작 지속 X)
      DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].MoveStop(True{bIsEMS});
      DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].MoveStop(True{bIsEMS});
    //TBD:ROBOT? (EMS_STOP)
      cdDioOutSig := DefDio.MASK_OUT_LAMP_RED;
      cdDioOutSig := cdDioOutSig or (UInt64(1) shl GetSelectedBuzzer);
      if Common.SystemInfo.HasDioVacuum then begin  //A2CH(True)|ATO(False)|GAGO(True) //2023-04-10
        cdDioOutSig := cdDioOutSig or (m_nDOValue and (DefDio.MASK_OUT_STAGE1_VACUUM1 or DefDio.MASK_OUT_STAGE1_VACUUM2 or DefDio.MASK_OUT_STAGE2_VACUUM1 or DefDio.MASK_OUT_STAGE2_VACUUM2));
      end;
      m_bEmsFlag := True;
      SetDio(cdDioOutSig,True);
      m_nOldDIValue := cdDioTemp;
      DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nMotorDIValue;
      sErrMsg := '';
      if (m_nDIValue and DefDio.MASK_IN_EMO1_FRONT) <> 0 then begin        //TBD:A2CHv3:DIO? (EMO)
        sErrMsg := 'EMO1_FRONT - please press reset button after clear emergency condition';
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,DefPocb.ALARM_DIO_EMO1_FRONT,0,sErrMsg);
      end;
      if (m_nDIValue and DefDio.MASK_IN_EMO2_RIGHT) <> 0 then begin
        sErrMsg := 'EMO2_RIGHT - please press reset button after clear emergency condition';
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,DefPocb.ALARM_DIO_EMO2_RIGHT,0,sErrMsg);
      end;
      if (m_nDIValue and DefDio.MASK_IN_EMO3_INNER_RIGHT) <> 0 then begin
        sErrMsg := 'EMO3_INNER_RIGHT - please press reset button after clear emergency condition';
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,DefPocb.ALARM_DIO_EMO3_INNER_RIGHT,0,sErrMsg);
      end;
      if (m_nDIValue and DefDio.MASK_IN_EMO4_INNER_LEFT) <> 0 then begin
        sErrMsg := 'EMO4_INNER_LEFT - please press reset button after clear emergency condition';
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,DefPocb.ALARM_DIO_EMO4_INNER_LEFT,0,sErrMsg);
      end;
      if (m_nDIValue and DefDio.MASK_IN_EMO5_LEFT) <> 0 then begin
        sErrMsg := 'EMO5_LEFT - please press reset button after clear emergency condition';
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,DefPocb.ALARM_DIO_EMO5_LEFT,0,sErrMsg);
      end;
      if Assigned(SetErrMsg) then SetErrMsg(False{bIsEmsReset:True,DefDio.IN_EMS},sErrMsg);
    //Common.CodeSiteSend('<DIO> GetAllDio:Exit(EMO)');
      Exit;
    end;

    //------------------------ Start EMS_RESET
    //  - PocbAuto: EMS Reset 신호가 들어오면, ( Lamp RED, Buzzer Off ).
    //  - PocbA2CH: EMS 신호가 1 -> 0이면, ( Lamp RED, Buzzer Off )
    cdDioTarget := DefDio.MASK_IN_EMO_ALL;
    if ((m_nOldDIValue and cdDioTarget) <> 0) and ((cdDioTemp and cdDioTarget) = 0) then begin
      cdDioOutSig := m_nDOValue and ( not(DefDio.MASK_OUT_LAMP_RED or DefDio.MASK_OUT_MELODY_ALL) );
      if FIsReadyToTurn1 and (m_bEmsFlag or m_bStopFlag[DefPocb.JIG_A]) then begin
        m_bRestart[DefPocb.JIG_A]  := True;
        m_bStopFlag[DefPocb.JIG_A] := False;
      end;
      if FIsReadyToTurn2 and (m_bEmsFlag or m_bStopFlag[DefPocb.JIG_B]) then begin
        m_bRestart[DefPocb.JIG_B]  := True;
        m_bStopFlag[DefPocb.JIG_B] := False;
      end;
      m_bEmsFlag := False;
      SetDio(cdDioOutSig,True);
      m_nOldDIValue := cdDioTemp;
      DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nMotorDIValue;
      if Assigned(SetErrMsg) then SetErrMsg(True{bIsEmsReset:True,DefDio.IN_EMS},'EMO RESET');
      Common.CodeSiteSend('<DIO> GetAllDio:Exit(EMO_RESET)');
      Exit;
    end;

    //------------------------ Mode Switch
    // CH1/CH2 Teach/Auto
    if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) or
       ((m_nDIValue and (not DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE)) = 0) then
      Common.m_bKeyTeachMode[DefPocb.JIG_A] := True   // Key=Teach인 경우, Maint창 Disable (by frmMain.SetFlow)
    else
      Common.m_bKeyTeachMode[DefPocb.JIG_A] := False;
    if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) or
       ((m_nDIValue and (not DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE)) = 0) then
      Common.m_bKeyTeachMode[DefPocb.JIG_B] := True   // Key=Teach인 경우, Maint창 Disable (by frmMain.SetFlow)
    else
      Common.m_bKeyTeachMode[DefPocb.JIG_B] := False;
    //
    {$IFDEF SUPPORT_1CG2PANEL}
    if not Common.SystemInfo.UseAssyPOCB then begin
    {$ENDIF}
      // CH1
      if not Common.m_bKeyTeachMode[DefPocb.JIG_A] then begin  // Auto Mode
        // if Key=Auto and Door=Open, "안전창" 표시& Exit
        cdDioTarget := DefDio.MASK_IN_STAGE1_DOOR1_OPEN or DefDio.MASK_IN_STAGE1_DOOR2_OPEN;
        if (m_nDIValue and cdDioTarget) <> 0 then begin
          sTemp := '';
          if (m_nDIValue and DefDio.MASK_IN_STAGE1_DOOR1_OPEN) <> 0 then sTemp := 'Ch1Maint1 ';
          if (m_nDIValue and DefDio.MASK_IN_STAGE1_DOOR2_OPEN) <> 0 then sTemp := sTemp + 'Ch1Maint2';
          //2019-02-13!!  SetDio(cdDioOutSig,True);
          m_nOldDIValue := cdDioTemp;
          DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nMotorDIValue;
          sErrMsg := '[AUTO/TEACH Key] AUTO Mode - plese close doors ('+sTemp+')';
          SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,DefPocb.ALARM_DIO_EXTRA_EMS,0,sErrMsg);
          if Assigned(SetErrMsg) then SetErrMsg(False{bIsEmsReset:True,DefDio.IN_EMS},sErrMsg);
          Common.CodeSiteSend('<DIO> GetAllDio:Exit(CH1 AUTO Mode - plese close door)');
          Exit;
        end;
        // if Key=Auto and Doors=Closed, Disable DoorUnlock
        cdDioTarget := DefDio.MASK_OUT_STAGE1_MAINT_DOOR1_UNLOCK or DefDio.MASK_OUT_STAGE1_MAINT_DOOR2_UNLOCK;
        if (m_nDOValue and cdDioTarget) <> 0 then begin   //TBD:A2CHv3:DIO?
          cdDioOutSig := m_nDOValue and (not cdDioTarget);
          SetDio(cdDioOutSig,True);
        end;
      end
      else begin  // Teach Mode
        cdDioTarget := DefDio.MASK_IN_STAGE1_DOOR1_OPEN or DefDio.MASK_IN_STAGE1_DOOR2_OPEN;
        if (m_nDIValue and cdDioTarget) <> 0 then begin
          // if Key=Manual and Door=Open, Disable KeyUnlock
          if (m_nDOValue and DefDio.MASK_OUT_STAGE1_SWITCH_UNLOCK) <> 0 then SetDio(DefDio.OUT_STAGE1_SWITCH_UNLOCK,False);
        end
        else begin
          // if Key=Manual and Door=Close, Enable KeyUnlock
          if (m_nDOValue and DefDio.MASK_OUT_STAGE1_SWITCH_UNLOCK) = 0 then SetDio(DefDio.OUT_STAGE1_SWITCH_UNLOCK,False);
        end;
      end;
      // CH2
      if not Common.m_bKeyTeachMode[DefPocb.JIG_B] then begin  // Auto Mode
        // if Key=Auto and Door=Open, "안전창" 표시& Exit
        cdDioTarget := DefDio.MASK_IN_STAGE2_DOOR1_OPEN or DefDio.MASK_IN_STAGE2_DOOR2_OPEN;
        if (m_nDIValue and cdDioTarget) <> 0 then begin
          sTemp := '';
          if (m_nDIValue and DefDio.MASK_IN_STAGE2_DOOR1_OPEN) <> 0 then sTemp := 'Ch2Maint1 ';
          if (m_nDIValue and DefDio.MASK_IN_STAGE2_DOOR2_OPEN) <> 0 then sTemp := sTemp + 'Ch2Maint2';
          //2019-02-13!!  SetDio(cdDioOutSig,True);
          m_nOldDIValue := cdDioTemp;
          DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nMotorDIValue;
          sErrMsg := '[AUTO/TEACH Key] AUTO Mode - plese close doors ('+sTemp+')';
          SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,DefPocb.ALARM_DIO_EXTRA_EMS,0,sErrMsg);
          if Assigned(SetErrMsg) then SetErrMsg(False{bIsEmsReset:True,DefDio.IN_EMS},sErrMsg);
          Common.CodeSiteSend('<DIO> GetAllDio:Exit(CH2 AUTO Mode - plese close door)');
          Exit;
        end;
        // if Key=Auto and Doors=Closed, Disable DoorUnlock
        cdDioTarget := DefDio.MASK_OUT_STAGE2_MAINT_DOOR1_UNLOCK or DefDio.MASK_OUT_STAGE2_MAINT_DOOR2_UNLOCK;
        if (m_nDOValue and cdDioTarget) <> 0 then begin   //TBD:A2CHv3:DIO?
          cdDioOutSig := m_nDOValue and (not cdDioTarget);
          SetDio(cdDioOutSig,True);
        end;
      end
      else begin  // Teach Mode
        cdDioTarget := DefDio.MASK_IN_STAGE2_DOOR1_OPEN or DefDio.MASK_IN_STAGE2_DOOR2_OPEN;
        if (m_nDIValue and cdDioTarget) <> 0 then begin
          // if Key=Manual and Door=Open, Disable KeyUnlock
          if (m_nDOValue and DefDio.MASK_OUT_STAGE2_SWITCH_UNLOCK) <> 0 then SetDio(DefDio.OUT_STAGE2_SWITCH_UNLOCK,False);
        end
        else begin
          // if Key=Manual and Door=Close, Enable KeyUnlock
          if (m_nDOValue and DefDio.MASK_OUT_STAGE2_SWITCH_UNLOCK) = 0 then SetDio(DefDio.OUT_STAGE2_SWITCH_UNLOCK,False);
        end;
      end;
    {$IFDEF SUPPORT_1CG2PANEL}
    end
    else begin  //ASSY
      // CH1/CH2
      if not Common.m_bKeyTeachMode[DefPocb.JIG_A] then begin  // Auto Mode
        // if Key=Auto and Door=Open, "안전창" 표시& Exit
        cdDioTarget := DefDio.MASK_IN_STAGE1_MAINT_DOOR1 or DefDio.MASK_IN_STAGE1_MAINT_DOOR2 or
                       DefDio.MASK_IN_STAGE2_MAINT_DOOR1 or DefDio.MASK_IN_STAGE2_MAINT_DOOR2;
        if (m_nDIValue and cdDioTarget) <> 0 then begin
          sTemp := '';
          if (m_nDIValue and DefDio.MASK_IN_STAGE1_MAINT_DOOR1) <> 0 then sTemp := 'Ch1Maint1 ';
          if (m_nDIValue and DefDio.MASK_IN_STAGE1_MAINT_DOOR2) <> 0 then sTemp := sTemp + 'Ch1Maint2';
          if (m_nDIValue and DefDio.MASK_IN_STAGE2_MAINT_DOOR1) <> 0 then sTemp := sTemp + 'Ch2Maint1';
          if (m_nDIValue and DefDio.MASK_IN_STAGE2_MAINT_DOOR2) <> 0 then sTemp := sTemp + 'Ch2Maint2';
          //2019-02-13!!  SetDio(cdDioOutSig,True);
          m_nOldDIValue := cdDioTemp;
          DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nMotorDIValue;
          sErrMsg := '[AUTO/TEACH Key] AUTO Mode - plese close doors ('+sTemp+')';
          SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,DefPocb.ALARM_DIO_EXTRA_EMS,0,sErrMsg);
          if Assigned(SetErrMsg) then SetErrMsg(False{bIsEmsReset:True,DefDio.IN_EMS},sErrMsg);
          Common.CodeSiteSend('<DIO> GetAllDio:Exit(CH1|CH2 AUTO Mode - plese close door)');
          Exit;
        end;
        // if Key=Auto and Doors=Closed, Disable DoorUnlock
        cdDioTarget := (DefDio.MASK_OUT_STAGE1_MAINT_DOOR1_UNLOCK or DefDio.MASK_OUT_STAGE1_MAINT_DOOR2_UNLOCK or
                        DefDio.MASK_OUT_STAGE2_MAINT_DOOR1_UNLOCK or DefDio.MASK_OUT_STAGE2_MAINT_DOOR2_UNLOCK);
        if (m_nDOValue and cdDioTarget) <> 0 then begin
          cdDioOutSig := m_nDOValue and (not cdDioTarget);
          SetDio(cdDioOutSig,True);
        end;
      end
      else begin  // Teach Mode
        //
        cdDioTarget := DefDio.MASK_IN_STAGE1_MAINT_DOOR1 or DefDio.MASK_IN_STAGE1_MAINT_DOOR2;
        if (m_nDIValue and cdDioTarget) <> 0 then begin
          // if Key=Manual and Door=Open, Disable KeyUnlock
          if (m_nDOValue and DefDio.MASK_OUT_STAGE1_SWITCH_UNLOCK) <> 0 then SetDio(DefDio.OUT_STAGE1_SWITCH_UNLOCK,False);
        end
        else begin
          // if Key=Manual and Door=Close, Enable KeyUnlock
          if (m_nDOValue and DefDio.MASK_OUT_STAGE1_SWITCH_UNLOCK) = 0 then SetDio(DefDio.OUT_STAGE1_SWITCH_UNLOCK,False);
        end;
        //
        cdDioTarget := DefDio.MASK_IN_STAGE2_MAINT_DOOR1 or DefDio.MASK_IN_STAGE2_MAINT_DOOR2;
        if (m_nDIValue and cdDioTarget) <> 0 then begin
          // if Key=Manual and Door=Open, Disable KeyUnlock
          if (m_nDOValue and DefDio.MASK_OUT_STAGE2_SWITCH_UNLOCK) <> 0 then SetDio(DefDio.OUT_STAGE2_SWITCH_UNLOCK,False);
        end
        else begin
          // if Key=Manual and Door=Close, Enable KeyUnlock
          if (m_nDOValue and DefDio.MASK_OUT_STAGE2_SWITCH_UNLOCK) = 0 then SetDio(DefDio.OUT_STAGE2_SWITCH_UNLOCK,False);
        end;
      end;
    end;
    {$ENDIF} //SUPPORT_1CG2PANEL

    //------------------------ Area Sensor가 꺼지면  Front Back stage off. Shuttor up / down signal off.
    cdDioTarget := DefDio.MASK_IN_STAGE1_LIGHT_CURTAIN or DefDio.MASK_IN_STAGE2_LIGHT_CURTAIN;
    if (m_nDIValue and cdDioTarget) = 0 then begin    // 0 주의.
      if (m_nDIValue and DefDio.MASK_IN_STAGE1_LIGHT_CURTAIN) = 0 then begin    // 0 주의.
        DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].MoveStop(True{bIsEMS});
        m_nOldDIValue := cdDioTemp;
        DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nMotorDIValue;
        m_bStopFlag[DefPocb.JIG_A] := True;
        if (m_nAutoFlow[DefPocb.CH_1] in [DefDio.IO_AUTO_FLOW_FRONT, DefDio.IO_AUTO_FLOW_BACK]) then begin
          sErrMsg := 'Detect Left Light Curtain - please press reset button';
        //sErrMsg := sErrMsg + #$0d  + '움직임 감지. Reset 버튼 눌러주시기 바랍니다';
          if Assigned(SetErrMsg) then SetErrMsg(True{bIsEmsReset:True,DefDio.IN_LIGHT_CURTAIN},sErrMsg);
        //DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_bServoRecover := False;
        end;
        Common.CodeSiteSend('<DIO> GetAllDio:Exit(CH1 LightCurtain)');
      end;
      if (m_nDIValue and DefDio.MASK_IN_STAGE2_LIGHT_CURTAIN) = 0 then begin    // 0 주의.
        DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].MoveStop(True{bIsEMS});
        m_nOldDIValue := cdDioTemp;
        DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nMotorDIValue;
        m_bStopFlag[DefPocb.JIG_B] := True;
        if (m_nAutoFlow[DefPocb.CH_2] in [DefDio.IO_AUTO_FLOW_FRONT, DefDio.IO_AUTO_FLOW_BACK]) then begin
          sErrMsg := 'Detect Right Light Curtain - please press reset button';
        //sErrMsg := sErrMsg + #$0d  + '움직임 감지. Reset 버튼 눌러주시기 바랍니다';
          if Assigned(SetErrMsg) then SetErrMsg(True{bIsEmsReset:True,DefDio.IN_LIGHT_CURTAIN},sErrMsg);
        //DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bServoRecover := False;
        end;
        Common.CodeSiteSend('<DIO> GetAllDio:Exit(CH2 LightCurtain)');
      end;
      Exit;
    end;

    //------------------------ Door Sensor가 들어오면 Front Back stage off. Shuttor up / down signal off.
    if not((m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) then begin  // Key: Not TeachMode //TBD:A2CHv3:DIO? (AutoMode?TeachMode?NotAutoMode?NotTeachMode?)
      cdDioTarget := DefDio.MASK_IN_STAGE1_DOOR1_OPEN or DefDio.MASK_IN_STAGE1_DOOR2_OPEN;
      if (cdDioTemp and cdDioTarget) <> 0 then begin
        DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue and (not (DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD or DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD));
        DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].MoveStop(True{bIsEMS});
        //TBD:ROOBOT? (EMS-STOP?)
        cdDioOutSig := DefDio.MASK_OUT_STAGE1_SHUTTER_UP or DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN
                       {$IFDEF SUPPORT_1CG2PANEL}
                       or DefDio.MASK_OUT_SHUTTER_GUIDE_UP or DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN
                       {$ENDIF}
                       ;
			  {$IFDEF HAS_DIO_SCREW_SHUTTER}																			 
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          cdDioOutSig := cdDioOutSig or (DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP or DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN);
        end;
				{$ENDIF}
        cdDioOutSig := m_nDOValue and (not cdDioOutSig); //2019-02-12
        SetDio(cdDioOutSig,True);
        m_nOldDIValue := cdDioTemp;
        DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nMotorDIValue;
        m_bStopFlag[DefPocb.JIG_A] := True;
        if (not (m_nAutoFlow[DefPocb.JIG_A] in [DefDio.IO_AUTO_FLOW_NONE, DefDio.IO_AUTO_FLOW_CAMERA, DefDio.IO_AUTO_FLOW_UNLOAD])) then begin
          sErrMsg := 'DOOR OPEN - please press reset button after close the door';
        //sErrMsg := sErrMsg + #$0d  + '문 열림 오류. 문을 닫은 후 Reset 버튼 눌러주시기 바랍니다';
          if Assigned(SetErrMsg) then SetErrMsg(False{bIsEmsReset:True,DefDio.IN_DOOR_LEFT},sErrMsg);   //TBD?
        end;
        Common.CodeSiteSend('<DIO> GetAllDio:Exit(CH1 TEACH/DoorOpen)');
        Exit;
      end;
    end;
    if not((m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) then begin  // Key: Not TeachMode //TBD:A2CHv3:DIO? (AutoMode?TeachMode?NotAutoMode?NotTeachMode?)
      cdDioTarget := DefDio.MASK_IN_STAGE2_DOOR1_OPEN or DefDio.MASK_IN_STAGE2_DOOR2_OPEN;
      if (cdDioTemp and cdDioTarget) <> 0 then begin
        DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue and (not (DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD or DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD));
        DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].MoveStop(True{bIsEMS});
        //TBD:ROOBOT? (EMS-STOP?)
        cdDioOutSig := DefDio.MASK_OUT_STAGE2_SHUTTER_UP or DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN
                       {$IFDEF SUPPORT_1CG2PANEL}
                       or DefDio.MASK_OUT_SHUTTER_GUIDE_UP or DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN
                       {$ENDIF}
                       ;
			  {$IFDEF HAS_DIO_SCREW_SHUTTER}											 
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          cdDioOutSig := cdDioOutSig or (DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP or DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN);
        end;
				{$ENDIF}
        cdDioOutSig := m_nDOValue and (not cdDioOutSig); //2019-02-12
        SetDio(cdDioOutSig,True);
        m_nOldDIValue := cdDioTemp;
        DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nMotorDIValue;
        m_bStopFlag[DefPocb.JIG_B] := True;
        if (not (m_nAutoFlow[DefPocb.JIG_B] in [DefDio.IO_AUTO_FLOW_NONE, DefDio.IO_AUTO_FLOW_CAMERA, DefDio.IO_AUTO_FLOW_UNLOAD])) then begin
          sErrMsg := 'DOOR OPEN - please press reset button after close the door';
        //sErrMsg := sErrMsg + #$0d  + '문 열림 오류. 문을 닫은 후 Reset 버튼 눌러주시기 바랍니다';
          if Assigned(SetErrMsg) then SetErrMsg(False{bIsEmsReset:True,DefDio.IN_DOOR_LEFT},sErrMsg);   //TBD?
        end;
        Common.CodeSiteSend('<DIO> GetAllDio:Exit(CH2 TEACH/DoorOpen)');
        Exit;
      end;
    end;

    //------------------------
    {$IFDEF SUPPORT_1CG2PANEL}
    if not Common.SystemInfo.UseAssyPOCB then begin
    {$ENDIF}
      bCh1GetDio := GetAllDioCh1;
      bCh2GetDio := GetAllDioCh2;
    {$IFDEF SUPPORT_1CG2PANEL}
    end
    else begin
      if ((m_nDIValue and DefDio.MASK_IN_STAGE1_JIG_INTERLOCK) = 0) then begin  //m_MotionStatus.nSyncStatus = SyncNone
        bCh1GetDio := GetAllDioCh1;
        bCh2GetDio := GetAllDioCh2;
      end
      else begin
        DongaMotion.m_bDioAssyJigOn := True;
        bCh1GetDio := GetAllDioChAssyPOCB;
        bCh2GetDio := bCh1GetDio;
      end;
    end;
    {$ENDIF} //SUPPORT_1CG2PANEL

    //------------------------ For Shutter Downing...
    {$IFDEF FEATURE_KEEP_SHUTTER_UP}
    if (not FMaintInDioUse) and (not Common.SystemInfo.KeepDioShutterUp) then //2023-08-04
    {$ELSE}
    if not FMaintInDioUse then
    {$ENDIF}
    begin
      if (m_nDIValue <> m_nOldDIValue) then begin
        // Stage.1
        if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0)  //TBD:A2CHv3:DIO? (SCREW_SHUTTER, GUIDE)?
            and ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) = 0)
            and ((m_nDIValue and (DefDio.MASK_IN_STAGE1_DOOR1_OPEN or MASK_IN_STAGE1_DOOR2_OPEN)) = 0)
            and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0)
            and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0)
            and ((DongaMotion.m_nMotorDOValue and DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD) = 0)
            and ((DongaMotion.m_nMotorDOValue and DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD) = 0)
            and (not FIsReadyToTurn1)
            and (m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_NONE) then begin
          SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
          Common.CodeSiteSend('<DIO> GetAllDio:ShutterForceUP(CH1):Set');
        end;
        if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) <> 0)
            and ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) = 0)
          //and (((m_nDIValue and (DefDio.MASK_IN_STAGE1_MAINT_DOOR1 or MASK_IN_STAGE1_MAINT_DOOR2)) = 0)
            and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) <> 0)
            and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0)
            and ((DongaMotion.m_nMotorDOValue and DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD) = 0)
            and ((DongaMotion.m_nMotorDOValue and DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD) = 0)
            and (not FIsReadyToTurn1)
            and (m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_NONE) then begin
          SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
          Common.CodeSiteSend('<DIO> GetAllDio:ShutterForceUP(CH1):Clear');
        end;
        // Stage.2
        if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0)       //TBD:A2CHv3:DIO? (SCREW_SHUTTER, GUIDE)?
            and ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) = 0)
            and ((m_nDIValue and (DefDio.MASK_IN_STAGE2_DOOR1_OPEN or MASK_IN_STAGE2_DOOR2_OPEN)) = 0)
            and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0)
            and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0)
            and ((DongaMotion.m_nMotorDOValue and DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD) = 0)
            and ((DongaMotion.m_nMotorDOValue and DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD) = 0)
            and (not FIsReadyToTurn2)
            and (m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_NONE) then begin
          SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
          Common.CodeSiteSend('<DIO> GetAllDio:ShutterForceUP(CH2):Set');
        end;
        if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) <> 0)
            and ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) = 0)
          //and (((m_nDIValue and (DefDio.MASK_IN_STAGE2_MAINT_DOOR1 or MASK_IN_STAGE2_MAINT_DOOR2)) = 0)
            and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) <> 0)
            and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0)
            and ((DongaMotion.m_nMotorDOValue and DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD) = 0)
            and ((DongaMotion.m_nMotorDOValue and DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD) = 0)
            and (not FIsReadyToTurn2)
            and (m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_NONE) then begin
          SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
          Common.CodeSiteSend('<DIO> GetAllDio:ShutterForceUP(CH2):Clear');
        end;
      end;
    end;
  {$IFDEF DIO_ALARM_THRESHOLD}
  end
  else begin  // if DIO-IN not changed
    dMaskThresholdAlarms := DefDio.MASK_IN_DIO_THREASHOLD_ALARMS;
  	{$IFDEF HAS_DIO_FAN_INOUT_PC}
    if Common.SystemInfo.HasDioFanInOutPC then dMaskThresholdAlarms := (dMaskThresholdAlarms or DefDio.MASK_IN_DIO_PC_FAN_ALARMS);  //2022-07-15 A2CHv4_#3(FanInOutPC)
		{$ENDIF}
    if (not Common.SystemInfo.HasDioVacuum) then dMaskThresholdAlarms := (dMaskThresholdAlarms and (not DefDio.MASK_IN_VACUUM_REGULATOR)); //2023-04-10 HasDioVacuum: A2CHvX(True)|ATO(False)|GAGO(True)
    if ((m_nOldChangedDIValue and dMaskThresholdAlarms) <> 0) then begin  // Threadhold Alarms & Keep Changed
      InDioStatus(m_nGetDio, m_nSetDio);
    end;
  {$ENDIF}
  end;

  if (bCh1GetDio) then begin //CH1-IN: True:Old<-New, False:NoChange
    dMaskDio := DefDio.MASK_IN_STAGE1_READY or DefDio.MASK_IN_STAGE1_SHUTTER_UP or DefDio.MASK_IN_STAGE1_SHUTTER_DOWN;
	  {$IFDEF HAS_DIO_SCREW_SHUTTER}
    if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
      dMaskDio := dMaskDio or (DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP or DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN);
    end;
    {$ENDIF}		
    {$IFDEF SUPPORT_1CG2PANEL}
    dMaskDio := dMaskDio or (DefDio.MASK_IN_SHUTTER_GUIDE_UP or DefDio.MASK_IN_SHUTTER_GUIDE_DOWN);
    {$ENDIF}
    dMaskDio := dMaskDio or (DefDio.MASK_IN_STAGE1_VACUUM1 or DefDio.MASK_IN_STAGE1_VACUUM2);
    m_nOldDIValue := m_nOldDIValue and (not dMaskDio);
    m_nOldDIValue := m_nOldDIValue or (m_nDIValue and dMaskDio);
    // IN_MOTOR_STAGE1_FORWARD, IN_MOTOR_STAGE1_BACKWARD
    DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nOldMotorDIValue and (not $03);
    DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nOldMotorDIValue or (DongaMotion.m_nMotorDIValue and $03);
  end;
  if (bCh2GetDio) then begin //CH2-IN: True:Old<-New, False:NoChange
    dMaskDio := DefDio.MASK_IN_STAGE2_READY or DefDio.MASK_IN_STAGE2_SHUTTER_UP or DefDio.MASK_IN_STAGE2_SHUTTER_DOWN;
	  {$IFDEF HAS_DIO_SCREW_SHUTTER}		
    if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
      dMaskDio := dMaskDio or (DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP or DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN);
    end;
    {$ENDIF}		
    {$IFDEF SUPPORT_1CG2PANEL}
    dMaskDio := dMaskDio or (DefDio.MASK_IN_SHUTTER_GUIDE_UP or DefDio.MASK_IN_SHUTTER_GUIDE_DOWN);
    {$ENDIF}
    dMaskDio := dMaskDio or (DefDio.MASK_IN_STAGE2_VACUUM1 or DefDio.MASK_IN_STAGE2_VACUUM2);
    m_nOldDIValue := m_nOldDIValue and (not dMaskDio);
    m_nOldDIValue := m_nOldDIValue or (m_nDIValue and dMaskDio);
    // IN_MOTOR_STAGE2_FORWARD, IN_MOTOR_STAGE2_BACKWARD
    DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nOldMotorDIValue and (not $0C);
    DongaMotion.m_nOldMotorDIValue := DongaMotion.m_nOldMotorDIValue or (DongaMotion.m_nMotorDIValue and $0C);
  end;
  if (bCh2GetDio and bCh1GetDio) then begin //COMMON: True:Old<-New, False:NoChange
    // for IN_EMS ~ IN_MC2
    dMaskDioAlarms := DefDio.MASK_IN_DIO_ALARMS;
  	{$IFDEF HAS_DIO_FAN_INOUT_PC}		
    if Common.SystemInfo.HasDioFanInOutPC then dMaskDioAlarms := (dMaskDioAlarms or DefDio.MASK_IN_DIO_PC_FAN_ALARMS); //2022-07-15 A2CHv4_#3(FanInOutPC)
		{$ENDIF}
    if (not Common.SystemInfo.HasDioVacuum) then dMaskDioAlarms := (dMaskDioAlarms and (not DefDio.MASK_IN_VACUUM_REGULATOR)); //2023-04-10 HasDioVacuum: A2CHvX(True)|ATO(False)|GAGO(True)
    m_nOldDIValue := m_nOldDIValue and (not dMaskDioAlarms);
    m_nOldDIValue := m_nOldDIValue or (m_nDIValue and dMaskDioAlarms);
  end;
end;

procedure TDioCtl.CheckShutterTimeout(nCh : Integer; value : ShutterState);
var
  bCond : Boolean;
  sMsg  : string;
begin
  bCond := False;

  case value of
    //
    ShutterState.UP: begin
      if not CheckShutterState(nCh,ShutterState.UP) then begin
        case nCh of
          DefPocb.CH_1: begin
            if (((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0))
               {$IFDEF HAS_DIO_SCREW_SHUTTER}		
               or (Common.SystemInfo.HasDioScrewShutter and (((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) = 0))) //2022-07-15 A2CHv4_#3(No ScrewShutter)
					     {$ENDIF}
               {$IFDEF SUPPORT_1CG2PANEL}
               or (Common.SystemInfo.UseAssyPOCB and (((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0))) // [ASSY]
               {$ENDIF}
            then
              bCond := True;
          end;
          DefPocb.CH_2: begin
            if (((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0))
               {$IFDEF HAS_DIO_SCREW_SHUTTER}
               or (Common.SystemInfo.HasDioScrewShutter and (((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) = 0))) //2022-07-15 A2CHv4_#3(No ScrewShutter)
               {$ENDIF}
               {$IFDEF SUPPORT_1CG2PANEL}
               or (Common.SystemInfo.UseAssyPOCB and (((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0))) // [ASSY]
               {$ENDIF}
            then
              bCond := True;
          end;
          else begin  //CH1&CH2
            if (((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0))
               or (((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0))						
               {$IFDEF HAS_DIO_SCREW_SHUTTER}									 
               or (Common.SystemInfo.HasDioScrewShutter and (((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) = 0))) //2022-07-15 A2CHv4_#3(No ScrewShutter)
               or (Common.SystemInfo.HasDioScrewShutter and (((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) = 0))) //2022-07-15 A2CHv4_#3(No ScrewShutter)
							 {$ENDIF}
               {$IFDEF SUPPORT_1CG2PANEL}
               or (Common.SystemInfo.UseAssyPOCB and (((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0))) // [ASSY]
               {$ENDIF}
            then
              bCond := True;
          end;
        end;
      end;
    end;
    //
    ShutterState.DOWN: begin
      if not CheckShutterState(nCh,ShutterState.DOWN) then begin
        case nCh of
          DefPocb.CH_1: begin
            if (((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) = 0))
               {$IFDEF HAS_DIO_SCREW_SHUTTER}									 						
               or (Common.SystemInfo.HasDioScrewShutter and (((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) = 0))) //2022-07-15 A2CHv4_#3(No ScrewShutter)
               {$ENDIF}
               {$IFDEF SUPPORT_1CG2PANEL}
               or (Common.SystemInfo.UseAssyPOCB and (((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) <> 0) and ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0))) // [ASSY]
               {$ENDIF}
            then
                bCond := True;
          end;
          DefPocb.CH_2: begin
            if (((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) = 0))
               {$IFDEF HAS_DIO_SCREW_SHUTTER}									 						
               or (Common.SystemInfo.HasDioScrewShutter and (((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) = 0))) //2022-07-15 A2CHv4_#3(No ScrewShutter)
               {$ENDIF}
               {$IFDEF SUPPORT_1CG2PANEL}
               or (Common.SystemInfo.UseAssyPOCB and (((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) <> 0) and ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0))) // [ASSY]
               {$ENDIF}
            then
                bCond := True;
          end;
          else begin  //CH1&CH2
            if (((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) = 0))
               or (((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) = 0))
               {$IFDEF HAS_DIO_SCREW_SHUTTER}									 							 
               or (Common.SystemInfo.HasDioScrewShutter and (((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) = 0))) //2022-07-15 A2CHv4_#3(No ScrewShutter)
               or (Common.SystemInfo.HasDioScrewShutter and (((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) <> 0) and ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) = 0))) //2022-07-15 A2CHv4_#3(No ScrewShutter)
               {$ENDIF}							 
               {$IFDEF SUPPORT_1CG2PANEL}
               or (Common.SystemInfo.UseAssyPOCB and (((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) <> 0) and ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0)))  // [ASSY]
               {$ENDIF}
            then // [ASSY]
                bCond := True;
          end;
        end;
      end;
    end;
  end;

  if bCond then begin
    if nCh in [DefPocb.CH_1..DefPocb.CH_2] then begin
      if MilliSecondsBetween(Now, m_tTime[nCh]) > SHUTTER_UPDOWN_DELAY_TIME then begin
        sMsg := UserUtils.TernaryOp(value = ShutterState.UP, 'Shutter(UP)', 'Shutter(DOWN)');
        {$IFDEF HAS_DIO_SCREW_SHUTTER}		
        if Common.SystemInfo.HasDioScrewShutter then //2022-07-15 A2CHv4_#3(No ScrewShutter)
				  sMsg := sMsg + UserUtils.TernaryOp(value = ShutterState.UP, '/ScrewShutter(DOWN)', '/ScrewShutter(UP)');
			  {$ENDIF}				
        sMsg := Format('Check Stage%d %s Sensor', [nCh+1, sMsg]);
        //Stop Init
        SendMainGuiDisplay(DefPocb.MSG_MODE_FLOW_STOP, nCh, 0 ,sMsg);
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS, nCh, 0 ,sMsg);
        m_nAutoFlow[nCh] := DefDio.IO_AUTO_FLOW_NONE;
        SetShutter(nCh, ShutterState.OFF);
        //Stop Inspection
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,nCh,sMsg,1);
        SendTestGuiDisplay(DefPocb.MSG_MODE_FLOW_STOP,nCh);
      end;
    end
    else begin
      if (MilliSecondsBetween(Now, m_tTime[DefPocb.CH_1]) > SHUTTER_UPDOWN_DELAY_TIME) or (MilliSecondsBetween(Now, m_tTime[DefPocb.CH_2]) > SHUTTER_UPDOWN_DELAY_TIME) then begin
        sMsg := UserUtils.TernaryOp(value = ShutterState.UP, 'Shutter(UP)', 'Shutter(DOWN)');
        {$IFDEF HAS_DIO_SCREW_SHUTTER}		
				if Common.SystemInfo.HasDioScrewShutter then //2022-07-15 A2CHv4_#3(No ScrewShutter)
				  sMsg := sMsg + UserUtils.TernaryOp(value = ShutterState.UP, '/ScrewShutter(DOWN)', '/ScrewShutter(UP)');
				{$ENDIF}						
        {$IFDEF SUPPORT_1CG2PANEL}
        if Common.SystemInfo.UseAssyPOCB then
          sMsg := sMsg + UserUtils.TernaryOp(value = ShutterState.UP, '/ShutterGuide(DOWN)', '/ShutterGuide(UP)');
        {$ENDIF}
        sMsg := Format('Check CH1/CH2 Stage %s Sensor', [sMsg]);
        //Stop Init
        SendMainGuiDisplay(DefPocb.MSG_MODE_FLOW_STOP, DefPocb.CH_1, 0 ,sMsg);
        SendMainGuiDisplay(DefPocb.MSG_MODE_FLOW_STOP, DefPocb.CH_2, 0 ,sMsg);
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS, DefPocb.CH_1, 0 ,sMsg);
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS, DefPocb.CH_2, 0 ,sMsg);
        m_nAutoFlow[DefPocb.CH_1] := DefDio.IO_AUTO_FLOW_NONE;
        m_nAutoFlow[DefPocb.CH_2] := DefDio.IO_AUTO_FLOW_NONE;
        SetShutter(DefPocb.CH_1, ShutterState.OFF);
        SetShutter(DefPocb.CH_2, ShutterState.OFF);
        //Stop Inspection
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.CH_1,sMsg,1);
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.CH_2,sMsg,1);
        SendTestGuiDisplay(DefPocb.MSG_MODE_FLOW_STOP,DefPocb.CH_1);
        SendTestGuiDisplay(DefPocb.MSG_MODE_FLOW_STOP,DefPocb.CH_2);
      end;
    end;
  end;
end;

function TDioCtl.GetAllDioCh1: Boolean;
var
  cdDioInTarget, cdDioOutTarget, cdDioOutSig : UInt64;  //F2CH|A2CHv2
  cdMotorInTarget, cdMotorOutTarget, cdMotorOutSig : DWORD;
  sEMsg : string;
  {$IFDEF FEATURE_DIO_LOG_SHUTTER}
  tShutterUpDownIn : TDateTime;
  sDioLogShutter   : string;
  {$ENDIF}
begin
    CheckShutterTimeout(DefPocb.JIG_A, ShutterState.UP);
    CheckShutterTimeout(DefPocb.JIG_A, ShutterState.DOWN);

    //------------------------ Stage front 신호가 들어 오면, Stage front out sig Off 하자.
    //-------------- State.1 Stage front 신호가 들어 오면
    cdMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD;
    cdMotorOutSig   := DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD;
    if ((DongaMotion.m_nMotorDIValue and cdMotorInTarget) <> 0) and ((cdMotorOutSig and DongaMotion.m_nMotorDOValue) <> 0) then begin
      DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue and (not DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD);
      SetAirKnife(DefPocb.JIG_A, False);
      if FIsReadyToTurn1 then begin
        if m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_FRONT then begin
          m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_SHUTTER_DOWN;
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) <> 0)  then SetDio(DefDio.OUT_STAGE1_SHUTTER_UP); //2023-08-11
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0) then SetDio(DefDio.OUT_STAGE1_SHUTTER_DOWN);
          {$IFDEF HAS_DIO_SCREW_SHUTTER}							
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
            if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) = 0) then SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP);
          end;
					{$ENDIF}
          {$IFDEF SUPPORT_1CG2PANEL}
          if Common.SystemInfo.UseAssyPOCB then begin
					  if ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0) then SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
					end;
          {$ENDIF}
          // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
          GetUnitTTLog(DefPocb.JIG_A,DefDio.DIO_IDX_GET_TT_FORWARD);
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_STAGE_FWD,DefPocb.SEQ_RESULT_PASS);
        end;
      end;
      m_bStopFlag[DefPocb.JIG_A] := False;
      Common.CodeSiteSend('<DIO> GetAllDioCh1:Exit(CH1 StageForward)');
      Exit(False);
    end;

    //------------------------ Stage back 신호가 들어오면, Stage back out Sig Off 하자.
    //-------------- Stage.1:  Stage back 신호가 들어오면,
    cdMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE1_BACKWARD;
    cdMotorOutSig   := DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD;
    if ((DongaMotion.m_nMotorDIValue and cdMotorInTarget) <> 0) and ((cdMotorOutSig and DongaMotion.m_nMotorDOValue) <> 0) then begin
      DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue and (not DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD);
      SetAirKnife(DefPocb.JIG_A, False);
      if FIsReadyToTurn1 then begin
        if m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_BACK then begin
          m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_UNLOAD;
          SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_STOP,DefPocb.JIG_A,'',0{dummy}); //2023-08-21 (for LENS EqStatus) after set to IO_AUTO_FLOW_UNLOAD !!!
          // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
          GetUnitTTLog(DefPocb.JIG_A,DefDio.DIO_IDX_GET_TT_BACKWARD);
          if Assigned(ArrivedUnload1) then ArrivedUnload1(m_nAutoFlow[DefPocb.JIG_A]);
          m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_NONE;  //TBD?
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_STAGE_BWD,DefPocb.SEQ_RESULT_PASS); //2019-05-20
        end
        else begin
          SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_STOP,DefPocb.JIG_A,'',0{dummy});
        end;
      end
      else begin
        m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_NONE;
      end;
      FIsReadyToTurn1 := False;
      Common.CodeSiteSend('<DIO> GetAllDioCh1:Exit(CH1 StageBackward)');
      Exit(False);
    end;

    //------------------------ Shutter Up 신호가 들어 오면, Shutter Up out sig Off 하자.
    //-------------- Stage.1: Shutter Up 신호가 들어오면,
    cdDioInTarget := DefDio.MASK_IN_STAGE1_SHUTTER_UP;
    cdDioOutSig   := DefDio.MASK_OUT_STAGE1_SHUTTER_UP;
		{$IFDEF FEATURE_KEEP_SHUTTER_UP}
    if Common.SystemInfo.KeepDioShutterUp and (not m_bOnShutterUp[DefPocb.JIG_A]) then cdDioOutSig := 0;
		{$ENDIF}
    {$IFDEF HAS_DIO_SCREW_SHUTTER}
    if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
			cdDioInTarget := cdDioInTarget or DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN;
      cdDioOutSig   := cdDioOutSig   or DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN;
		end;
		{$ENDIF}
    {$IFDEF SUPPORT_1CG2PANEL}
    if Common.SystemInfo.UseAssyPOCB then begin
      cdDioInTarget := cdDioInTarget or DefDio.MASK_IN_SHUTTER_GUIDE_DOWN;
      cdDioOutSig   := cdDioOutSig or DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN;
    end;
    {$ENDIF}
    if ((m_nDOValue and cdDioOutSig) <> 0) then begin
      if (CheckShutterState(DefPocb.JIG_A, ShutterState.UP)) then begin
        {$IFDEF FEATURE_DIO_LOG_SHUTTER}          //2023-05-02 DioLog:CH1:SHUTTER:UP
        if Common.SystemInfo.UseDioLogShutter then begin
          tShutterUpDownIn := Now;
          if CompareDateTime(m_tShutterUpDownOut[DefPocb.JIG_A],tShutterUpDownIn) = LessThanValue then begin
            sDioLogShutter := FormatDateTime('yyyy-mm-dd hh:mm:ss.zzz',tShutterUpDownIn)+',1,SHUTTER,UP,'+IntToStr(MilliSecondsBetween(Now, m_tShutterUpDownOut[DefPocb.JIG_A]));
            SendTestGuiDisplay(DefPocb.MSG_MODE_DIO_LOG,DefPocb.JIG_A,sDioLogShutter);
          end;
        end;
        {$ENDIF}
      //SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,DefPocb.JIG_A,'<DIO> Shutter UP Done'); //2022-08-01
        // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
        GetUnitTTLog(DefPocb.JIG_A,DefDio.DIO_IDX_GET_TT_SHT_UP);
				{$IFDEF FEATURE_KEEP_SHUTTER_UP}
        m_bOnShutterUp[DefPocb.JIG_A] := False;
        if (not Common.SystemInfo.KeepDioShutterUp) then begin
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
        end;
        {$ELSE}
        if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
        {$ENDIF}
        {$IFDEF HAS_DIO_SCREW_SHUTTER}
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) <> 0) then SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN);
        end;
        {$ENDIF}				
        {$IFDEF SUPPORT_1CG2PANEL}
        if Common.SystemInfo.UseAssyPOCB then begin  // ASSY (ShutterUP+ScrewShutterDOWN+ShutterGuideDOWN)
          if ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) then SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
        end;
        {$ENDIF}
				m_nOldDIValue := m_nOldDIValue or cdDioInTarget;
      //Common.CodeSiteSend('<DIO> GetAllDioCh1:Exit(CH1 Shutters Opened)');
        if FIsReadyToTurn1 then begin
          if m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_SHUTTER_UP then begin
            m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_BACK;
            if CheckIoBeforeMotorOutSig(OUT_MOTOR_STAGE1_BACKWARD,sEMsg) then begin
              DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue or DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD;
              Common.ThreadTask(procedure begin
                DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].MoveBACKWARD;
              end);
              SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_STAGE_BWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
            end
            else begin
              //TBD:A2CHv3:DIO?
            end;
          end;
        end;
      end;
      Exit(False);
    end;

    //------------------------ Shutter Down 신호가 들어오면, Shutter Down out Sig Off 하자.
    //-------------- Stage.1: Shutter Down 신호가 들어오면
    cdDioInTarget := DefDio.MASK_IN_STAGE1_SHUTTER_DOWN;
    cdDioOutSig   := DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN;	
    {$IFDEF HAS_DIO_SCREW_SHUTTER}																
    if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
			cdDioInTarget := cdDioInTarget or DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP;
      cdDioOutSig   := cdDioOutSig   or DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP;
		end;
		{$ENDIF}
    {$IFDEF SUPPORT_1CG2PANEL}
    if Common.SystemInfo.UseAssyPOCB then begin
      cdDioInTarget := cdDioInTarget or DefDio.MASK_IN_SHUTTER_GUIDE_UP;
      cdDioOutSig   := cdDioOutSig or DefDio.MASK_OUT_SHUTTER_GUIDE_UP;
    end;
    {$ENDIF}
    if ((m_nDOValue and cdDioOutSig) <> 0) then begin
      if CheckShutterState(DefPocb.JIG_A, ShutterState.DOWN) then begin
        {$IFDEF FEATURE_DIO_LOG_SHUTTER}          //2023-05-02 DioLog:CH1:SHUTTER:DOWN
        if Common.SystemInfo.UseDioLogShutter then begin
          tShutterUpDownIn := Now;
          if CompareDateTime(m_tShutterUpDownOut[DefPocb.JIG_A],tShutterUpDownIn) = LessThanValue then begin
            sDioLogShutter := FormatDateTime('yyyy-mm-dd hh:mm:ss.zzz',tShutterUpDownIn)+',1,SHUTTER,DOWN,'+IntToStr(MilliSecondsBetween(Now, m_tShutterUpDownOut[DefPocb.JIG_A]));
            SendTestGuiDisplay(DefPocb.MSG_MODE_DIO_LOG,DefPocb.JIG_A,sDioLogShutter);
          end;
        end;
        {$ENDIF}
      //SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,DefPocb.JIG_A,'<DIO> Shutter DOWN Done'); //2022-08-01
        if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) <> 0) then SetDio(DefDio.OUT_STAGE1_SHUTTER_DOWN);
        {$IFDEF HAS_DIO_SCREW_SHUTTER}				
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP);
        end;
				{$ENDIF}
        {$IFDEF SUPPORT_1CG2PANEL}
        if Common.SystemInfo.UseAssyPOCB then begin
          if ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) <> 0) then SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
        end;
        {$ENDIF}
				m_nOldDIValue := m_nOldDIValue or cdDioInTarget;
        Common.CodeSiteSend('<DIO> GetAllDioCh1:Exit(CH1 Shutters Closed)');
//        // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
//        GetUnitTTLog(DefPocb.JIG_A,DefDio.DIO_IDX_GET_TT_SHT_DN);
        if FIsReadyToTurn1 then begin
          //Common.CodeSiteSend('DIO:Exit:Stage.1: Shutter Down:FIsReadyToTurn1');
          if m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_SHUTTER_DOWN then begin
            //Common.CodeSiteSend('DIO:Exit:Stage.1: Shutter Down:FIsReadyToTurn1:IO_AUTO_FLOW_SHUTTER_DOWN');
            m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_CAMERA;
          end;
        end;
      end;
      Exit(False);
    end;

    //------------------------ Power On - Pattern Display가 되면 Camera Zone으로 턴할수 있도록 Ready Sig Out 상태 설정.
    //-------------- Stage.1: Power On - Pattern Display가 되면
    if FIsReadyToTurn1 then begin
      //Common.CodeSiteSend('DIO:FIsReadyToTurn1');
      //2018-11-30 (Reset버튼 누른 경우, 재개처리?)
      if DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_bServoRecover then begin
        m_bRestart[DefPocb.JIG_A] := True;
        m_bStopFlag[DefPocb.JIG_A] := False;
        DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_bServoRecover := False;
        Common.CodeSiteSend('<DIO> GetAllDioCh1:FIsReadyToTurn1:bServoRecover');
      end;
      if m_bRestart[DefPocb.JIG_A] then begin
        Common.CodeSiteSend('<DIO> GetAllDioCh1:m_bRestart');
        case m_nAutoFlow[DefPocb.JIG_A] of
          DefDio.IO_AUTO_FLOW_READY : begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_READY');
            // SWITCH가 안켜져 있으면 스위치 키자.
            if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_READY_LED) = 0)  then begin
              //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_READY:if');
              SetDio(DefDio.OUT_STAGE1_READY_LED);
            end
          end;
          DefDio.IO_AUTO_FLOW_FRONT : begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_FRONT');
            cdMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD;
            // Front로 안가고 있으면 계속 가자.
            if ((DongaMotion.m_nMotorDOValue and cdMotorOutTarget) = 0) or ((DongaMotion.m_nMotorDIValue and DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD) = 0) then begin
              //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_FRONT:if');
              if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_READY_LED) <> 0) then SetDio(DefDio.OUT_STAGE1_READY_LED);
              if CheckIoBeforeMotorOutSig(OUT_MOTOR_STAGE1_FORWARD,sEMsg) then begin
                SetAirKnife(DefPocb.JIG_A, True);
                SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_START,DefPocb.JIG_A,'',0{dummy}); //2019-01-02
                DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue or DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD;
                // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
                GetUnitTTLog(DefPocb.JIG_A,DefDio.DIO_IDX_GET_TT_START);
                Common.ThreadTask(procedure begin
                  DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].MoveFORWARD;
                end);
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_STAGE_FWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
              end
              else begin
                //TBD:A2CHV3:DIO?
              end;
            end;
          end;
          DefDio.IO_AUTO_FLOW_SHUTTER_DOWN : begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_SHUTTER_DOWN');
            // Front로 안가고 있으면 계속 가자.
            if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0) then begin
              //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_SHUTTER_DOWN:OUT_STAGE1_SHUTTER_DOWN:if');
              SetDio(DefDio.OUT_STAGE1_SHUTTER_DOWN);
            end;
            //
            {$IFDEF HAS_DIO_SCREW_SHUTTER}									
            if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
              if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) = 0) then begin
                //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_SHUTTER_DOWN:OUT_STAGE1_SCREW_SHUTTER_UP:if');
                SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP);
              end;
            end;
						{$ENDIF}
            //
            {$IFDEF SUPPORT_1CG2PANEL}
            if Common.SystemInfo.UseAssyPOCB then begin  // ASSY (ShutterDOWN+ScrewShutterUP+ShutterGuideUP)
              if ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0) then begin
                //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_SHUTTER_DOWN:OUT_SHUTTER_GUIDE_UP:if');
                SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
              end;
            end;
            {$ENDIF}
          end;
          DefDio.IO_AUTO_FLOW_SHUTTER_UP : begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_SHUTTER_UP');
            // Front로 안가고 있으면 계속 가자.
            if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) = 0) then begin
              //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_SHUTTER_UP:OUT_STAGE1_SHUTTER_UP:if');
              SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
            end;
            //
            {$IFDEF HAS_DIO_SCREW_SHUTTER}															
            if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
              if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) = 0) then begin
                //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_SHUTTER_UP:OUT_STAGE1_SCREW_SHUTTER_DOWN:if');
                SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN);
              end;
            end;
						{$ENDIF}
            //
            {$IFDEF SUPPORT_1CG2PANEL}
            if Common.SystemInfo.UseAssyPOCB then begin  // ASSY (ShutterUP+ScrewShutterDOWN+ShutterGuideDOWN)  //TBD:A2CHv3:DIO (SHUTTERS)
              if ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) = 0) then begin
                //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_SHUTTER_UP:OUT_SHUTTER_GUIDE_DOWN:if');
                SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
              end;
            end;
            {$ENDIF}
          end;
          DefDio.IO_AUTO_FLOW_BACK : begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_BACK');
            cdMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD;
            if ((DongaMotion.m_nMotorDOValue and cdMotorOutTarget) = 0) or ((DongaMotion.m_nMotorDIValue and DefMotion.MASK_IN_MOTOR_STAGE1_BACKWARD) = 0) then begin
              //Common.CodeSiteSend('DIO:FIsReadyToTurn1:m_bRestart:IO_AUTO_FLOW_BACK:if');
              if CheckIoBeforeMotorOutSig(OUT_MOTOR_STAGE1_BACKWARD,sEMsg) then begin
                SetAirKnife(DefPocb.JIG_A, True);
                DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue or DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD;
                Common.ThreadTask(procedure begin
                  DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].MoveBACKWARD;
                end);
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_STAGE_BWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
              end
              else begin
                //TBD:A1CHv3:DIO?
              end;
            end;
          end;
        end;
        m_bRestart[DefPocb.JIG_A] := False;
      end;
      case m_nAutoFlow[DefPocb.JIG_A] of
        DefDio.IO_AUTO_FLOW_READY : begin
          //Common.CodeSiteSend('DIO:FIsReadyToTurn1:IO_AUTO_FLOW_READY');
          cdMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD;
          if ((cdMotorInTarget and DongaMotion.m_nMotorDIValue) = 0) then begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn1:IO_AUTO_FLOW_READY:if:1');
            // 전진 상태가 아니고, SWITCH가 안켜져 있으면 스위치 키자.
            if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_READY_LED) = 0) then begin
              SetDio(DefDio.OUT_STAGE1_READY_LED);
              //Common.CodeSiteSend('DIO:FIsReadyToTurn1:IO_AUTO_FLOW_READY:if:2');
            end
            else begin
              //CodeSite.Send('DIO:FIsReadyToTurn1:IO_AUTO_FLOW_READY:if:3');
              // LED 불이 들어온 상태에서...    Ready switch 2개가 감지 되면 Turn.
              if ((m_nDIValue and DefDio.MASK_IN_STAGE1_READY) <> 0) then begin
                //Common.CodeSiteSend('DIO:FIsReadyToTurn1:IO_AUTO_FLOW_READY:if:4');
                // TEACT Mode, Door, Vacuum, CameraPC 상태 확인 ...start
                if not IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_1) then begin //F2CH|A2CHv2:CH1
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_A,'CH1 door(s) is opened. To run, close all doors',1);
                  Exit(False);
                end
                else if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) = 0) or ((m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_A,'CH1 SAFETY MODE key is not AUTO. To run, switch SAFTETY MODE key to AUTO',1);
                  Exit(False);
                end
                else if Common.TestModelInfo2[DefPocb.JIG_A].UseVacuum and  //2019-06-24 (GIB의 경우, Vacuum 불필요)
                        (((m_nDIValue and DefDio.MASK_IN_STAGE1_VACUUM1) = 0)
                      or ((m_nDIValue and DefDio.MASK_IN_STAGE1_VACUUM2) = 0)) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_A,'CH1 Vacuume(s) is not working. Check vacuum of CH1',1);
                  Exit(False);
              //{$IFNDEF SIMULATOR_CAM}
                end
                else if Common.IsAlarmOn(DefPocb.ALARM_CAMERA_PC1_DISCONNECTED) then begin //2019-04-26 (CamPC Disconn일 때)
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_A,'Camera-PC1 Communication NG. Check Camera-PC1 status',1);
                  Exit(False);
              //{$ENDIF}
                end;
                // TEACT Mode, Door, Vacuum, CameraPC 상태 확인 ...end
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_A,'',0{dummy});
                if CheckIoBeforeMotorOutSig(OUT_MOTOR_STAGE1_FORWARD,sEMsg) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_PRESS_START,DefPocb.SEQ_RESULT_PASS); //2019-05-20
                  if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_READY_LED) <> 0) then SetDio(DefDio.OUT_STAGE1_READY_LED);
                  SetAirKnife(DefPocb.JIG_A, True);  //2022-01-02
                  //Common.CodeSiteSend('DIO:FIsReadyToTurn1:IO_AUTO_FLOW_READY:if:5');
                  m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_FRONT; //2023-08-21 (for LENS EqStatus) Before JIG_TT_START
                  SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_START,DefPocb.JIG_A,'',0{dummy}); //2019-01-02
                  DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue or DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD;
                  // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
                  GetUnitTTLog(DefPocb.JIG_A,DefDio.DIO_IDX_GET_TT_START);
                  Common.ThreadTask(procedure begin
                    DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].MoveFORWARD;
                  end);
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_STAGE_FWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
                end
                else begin
                  //TBD:A2CHv3:DIO?
                end;
                m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_FRONT;
              end;
            end;
          end;
        end;
      end;
    end
    else begin
      //DongaMotion.Motion[DefMotion.MOTIONID_AxtMC_STAGE1_Y].m_bServoRecover := False;
    end;

  Result := True;
end;

function TDioCtl.GetAllDioCh2: Boolean;
var
  cdDioInTarget, cdDioOutTarget, cdDioOutSig : UInt64;  //F2CH|A2CHv2
  cdMotorInTarget, cdMotorOutTarget, cdMotorOutSig : DWORD;
  sEMsg : string;
  {$IFDEF FEATURE_DIO_LOG_SHUTTER}
  tShutterUpDownIn : TDateTime;
  sDioLogShutter   : string;
  {$ENDIF}
begin
    CheckShutterTimeout(DefPocb.JIG_B, ShutterState.UP);
    CheckShutterTimeout(DefPocb.JIG_B, ShutterState.DOWN);

    //------------------------ Stage front 신호가 들어 오면, Stage front out sig Off 하자.
    //-------------- State.2 Stage front 신호가 들어 오면
    cdMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE2_FORWARD;
    cdMotorOutSig   := DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD;
    if ((DongaMotion.m_nMotorDIValue and cdMotorInTarget) <> 0) and ((cdMotorOutSig and DongaMotion.m_nMotorDOValue) <> 0) then begin
      DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue and (not DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD);
      SetAirKnife(DefPocb.JIG_B, False);
      if FIsReadyToTurn2 then begin
        if m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_FRONT then begin
          m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_SHUTTER_DOWN;
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) <> 0)  then SetDio(DefDio.OUT_STAGE2_SHUTTER_UP); //2023-08-11
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0) then SetDio(DefDio.OUT_STAGE2_SHUTTER_DOWN);
          {$IFDEF HAS_DIO_SCREW_SHUTTER}														
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
            if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) = 0) then SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP);
          end;
					{$ENDIF}
          // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
          GetUnitTTLog(DefPocb.JIG_B,DefDio.DIO_IDX_GET_TT_FORWARD);
        //if Common.SystemInfo.UseAssyPOCB then begin
			  //  if ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0) then SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);  // by CH1
				//end;
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_STAGE_FWD,DefPocb.SEQ_RESULT_PASS); //2019-05-20
        end;
      end;
      m_bStopFlag[DefPocb.JIG_B] := False;
      Common.CodeSiteSend('<DIO> GetAllDioCh2:Exit(CH2 StageForward)'); 
      Exit(False);
    end;

    //------------------------ Stage back 신호가 들어오면, Stage back out Sig Off 하자.
    //-------------- Stage.2:  Stage back 신호가 들어오면,
    cdMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE2_BACKWARD;
    cdMotorOutSig   := DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD;
    if ((DongaMotion.m_nMotorDIValue and cdMotorInTarget) <> 0) and ((cdMotorOutSig and DongaMotion.m_nMotorDOValue) <> 0) then begin
      DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue and (not DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD);
      SetAirKnife(DefPocb.JIG_B, False);
      if FIsReadyToTurn2 then begin
        if m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_BACK then begin
          m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_UNLOAD;
          SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_STOP,DefPocb.JIG_B,'',0{dummy}); //2023-08-21 (for LENS EqStatus)  after set to IO_AUTO_FLOW_UNLOAD !!!
          // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
          GetUnitTTLog(DefPocb.JIG_B,DefDio.DIO_IDX_GET_TT_BACKWARD);
          if Assigned(ArrivedUnload2) then ArrivedUnload2(m_nAutoFlow[DefPocb.JIG_B]);
          m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_NONE;  //TBD?
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_STAGE_BWD,DefPocb.SEQ_RESULT_PASS); //2019-05-20
        end
        else begin
         SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_STOP,DefPocb.JIG_B,'',0{dummy});

        end;
      end
      else begin
        m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_NONE;
      end;
      FIsReadyToTurn2 := False;
      Common.CodeSiteSend('<DIO> GetAllDioCh2:Exit(CH2 StageBackward)'); 
      Exit(False);
    end;

    //------------------------ Shutter Up 신호가 들어 오면, Shutter Up out sig Off 하자. 
    //-------------- Stage.2: Shutter Up 신호가 들어오면,
    cdDioInTarget := DefDio.MASK_IN_STAGE2_SHUTTER_UP;
    cdDioOutSig   := DefDio.MASK_OUT_STAGE2_SHUTTER_UP;
    {$IFDEF FEATURE_KEEP_SHUTTER_UP}
    if Common.SystemInfo.KeepDioShutterUp and (not m_bOnShutterUp[DefPocb.JIG_B]) then cdDioOutSig := 0;
    {$ENDIF}
    {$IFDEF HAS_DIO_SCREW_SHUTTER}		
    if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
      cdDioInTarget := cdDioInTarget or DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN;
      cdDioOutSig   := cdDioOutSig   or DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN;
    end;
    {$ENDIF}		
    {$IFDEF SUPPORT_1CG2PANEL}
    if Common.SystemInfo.UseAssyPOCB then begin
      cdDioInTarget := cdDioInTarget or DefDio.MASK_IN_SHUTTER_GUIDE_DOWN;
      cdDioOutSig   := cdDioOutSig or DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN;
    end;
    {$ENDIF}
    if ((m_nDOValue and cdDioOutSig) <> 0) then begin
      if (CheckShutterState(DefPocb.JIG_B, ShutterState.UP)) then begin
        {$IFDEF FEATURE_DIO_LOG_SHUTTER}          //2023-05-02 DioLog:CH1:SHUTTER:DOWN
        if Common.SystemInfo.UseDioLogShutter then begin
          tShutterUpDownIn := Now;
          if CompareDateTime(m_tShutterUpDownOut[DefPocb.JIG_B],tShutterUpDownIn) = LessThanValue then begin
            sDioLogShutter := FormatDateTime('yyyy-mm-dd hh:mm:ss.zzz',tShutterUpDownIn)+',2,SHUTTER,UP,'+IntToStr(MilliSecondsBetween(Now, m_tShutterUpDownOut[DefPocb.JIG_B]));
            SendTestGuiDisplay(DefPocb.MSG_MODE_DIO_LOG,DefPocb.JIG_B,sDioLogShutter);
          end;
        end;
        {$ENDIF}
      //SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,DefPocb.JIG_B,'<DIO> Shutter UP Done'); //2022-08-01
        {$IFDEF FEATURE_KEEP_SHUTTER_UP}
        m_bOnShutterUp[DefPocb.JIG_B] := False;				
        if (not Common.SystemInfo.KeepDioShutterUp) then begin
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
        end;
        {$ELSE}
        if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
        {$ENDIF}
        {$IFDEF HAS_DIO_SCREW_SHUTTER}
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN) <> 0) then SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN);
        end;
				{$ENDIF}
      //if Common.SystemInfo.UseAssyPOCB then begin  // ASSY (ShutterUP+ScrewShutterDOWN+ShutterGuideDOWN)
      //  /if ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) then SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);  // by CH1
      //end;
				m_nOldDIValue := m_nOldDIValue or cdDioInTarget;
        Common.CodeSiteSend('<DIO> GetAllDioCh2:Exit(CH2 Shutters Opened)');
        if FIsReadyToTurn2 then begin
          if m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_SHUTTER_UP then begin
            m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_BACK;
            if CheckIoBeforeMotorOutSig(OUT_MOTOR_STAGE2_BACKWARD,sEMsg) then begin
              DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue or DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD;
              SetAirKnife(DefPocb.JIG_B, False);
              // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
              GetUnitTTLog(DefPocb.JIG_B,DefDio.DIO_IDX_GET_TT_SHT_UP);
              Common.ThreadTask(procedure begin
                DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].MoveBACKWARD;
              end);
              SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_STAGE_BWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
            end
            else begin
              Common.CodeSiteSend('###DIO:Stage.2: Shutter Up:1'+sEMsg);//TBD:A2CHv3:DIO?
            end;
          end;
        end;
      end
      else begin
        //TBD:A2CHv3:DIO?
      end;
      Exit(False);
    end;

    //------------------------ Shutter Down 신호가 들어오면, Shutter Down out Sig Off 하자.
    //-------------- Stage.2: Shutter Down 신호가 들어오면
    cdDioInTarget := DefDio.MASK_IN_STAGE2_SHUTTER_DOWN;
    cdDioOutSig   := DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN;
    {$IFDEF HAS_DIO_SCREW_SHUTTER}			
    if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
      cdDioInTarget := cdDioInTarget or DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP;
      cdDioOutSig   := cdDioOutSig   or DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP;
    end;
		{$ENDIF}
    {$IFDEF SUPPORT_1CG2PANEL}
    if Common.SystemInfo.UseAssyPOCB then begin
      cdDioInTarget := cdDioInTarget or DefDio.MASK_IN_SHUTTER_GUIDE_UP;
      cdDioOutSig   := cdDioOutSig or DefDio.MASK_OUT_SHUTTER_GUIDE_UP;
    end;
    {$ENDIF}
    if ((m_nDOValue and cdDioOutSig) <> 0) then begin
      if CheckShutterState(DefPocb.JIG_B, ShutterState.DOWN) then begin
        {$IFDEF FEATURE_DIO_LOG_SHUTTER}          //2023-05-02 DioLog:CH1:SHUTTER:DOWN
        if Common.SystemInfo.UseDioLogShutter then begin
          tShutterUpDownIn := Now;
          if CompareDateTime(m_tShutterUpDownOut[DefPocb.JIG_B],tShutterUpDownIn) = LessThanValue then begin
            sDioLogShutter := FormatDateTime('yyyy-mm-dd hh:mm:ss.zzz',tShutterUpDownIn)+',2,SHUTTER,DOWN,'+IntToStr(MilliSecondsBetween(Now, m_tShutterUpDownOut[DefPocb.JIG_B]));
            SendTestGuiDisplay(DefPocb.MSG_MODE_DIO_LOG,DefPocb.JIG_B,sDioLogShutter);
          end;
        end;
        {$ENDIF}
      //SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,DefPocb.JIG_B,'<DIO> Shutter DOWN Done'); //2022-08-01

        if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) <> 0) then SetDio(DefDio.OUT_STAGE2_SHUTTER_DOWN);
        {$IFDEF HAS_DIO_SCREW_SHUTTER}
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP);
        end;
				{$ENDIF}
        {$IFDEF SUPPORT_1CG2PANEL}
      //if Common.SystemInfo.UseAssyPOCB then begin
      //  /if ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) <> 0) then SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);  // by CH1
      //end;
        {$ENDIF}
				m_nOldDIValue := m_nOldDIValue or cdDioInTarget;
        Common.CodeSiteSend('<DIO> GetAllDioCh2:Exit(CH2 Shutters Closed)');
        if FIsReadyToTurn2 then begin

          //Common.CodeSiteSend('DIO:Exit:Stage.2: Shutter Down:FIsReadyToTurn2');
          if m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_SHUTTER_DOWN then begin
//            // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
//            GetUnitTTLog(DefPocb.JIG_B,DefDio.DIO_IDX_GET_TT_SHT_DN);
            //Common.CodeSiteSend('DIO:Exit:Stage.2: Shutter Down:FIsReadyToTurn2:IO_AUTO_FLOW_SHUTTER_DOWN');
            m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_CAMERA;
          end;
        end;
      end;
      Exit(False);
    end;

    //------------------------ Power On - Pattern Display가 되면 Camera Zone으로 턴할수 있도록 Ready Sig Out 상태 설정.
    //-------------- Stage.2: Power On - Pattern Display가 되면
    if FIsReadyToTurn2 then begin
      //Common.CodeSiteSend('DIO:FIsReadyToTurn2');
      //2018-11-30 (Reset버튼 누른 경우, 재개처리?)
      if DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bServoRecover then begin
        m_bRestart[DefPocb.JIG_B] := True;
        m_bStopFlag[DefPocb.JIG_B] := False;
        DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bServoRecover := False;
        Common.CodeSiteSend('<DIO> GetAllDioCh2:FIsReadyToTurn2:bServoRecover');
      end;
      if m_bRestart[DefPocb.JIG_B] then begin
        Common.CodeSiteSend('<DIO> GetAllDioCh2:m_bRestart');
        case m_nAutoFlow[DefPocb.JIG_B] of
          DefDio.IO_AUTO_FLOW_READY : begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_READY');
            // SWITCH가 안켜져 있으면 스위치 키자.
            if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_READY_LED) = 0)  then begin
              //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_READY:if');
              SetDio(DefDio.OUT_STAGE2_READY_LED);
            end
          end;
          DefDio.IO_AUTO_FLOW_FRONT : begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_FRONT');
            cdMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD;
            // Front로 안가고 있으면 계속 가자.
            if ((DongaMotion.m_nMotorDOValue and cdMotorOutTarget) = 0) or ((DongaMotion.m_nMotorDIValue and DefMotion.MASK_IN_MOTOR_STAGE2_FORWARD) = 0) then begin
              //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_FRONT:if');
              if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_READY_LED) <> 0) then begin
                SetDio(DefDio.OUT_STAGE2_READY_LED);
              end;
              if CheckIoBeforeMotorOutSig(DefMotion.OUT_MOTOR_STAGE2_FORWARD,sEMsg) then begin
                SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_START,DefPocb.JIG_B,'',0{dummy}); //2019-01-02
                DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue or DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD;
                SetAirKnife(DefPocb.JIG_B, True);
                // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
                  GetUnitTTLog(DefPocb.JIG_B,DefDio.DIO_IDX_GET_TT_START);
                Common.ThreadTask(procedure begin
                  DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].MoveFORWARD;
                end);
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_STAGE_FWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
              end
              else begin
                //TBD:A2CHv3:DIO?
              end;
            end;
          end;
          DefDio.IO_AUTO_FLOW_SHUTTER_DOWN : begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_SHUTTER_DOWN');
            // Front로 안가고 있으면 계속 가자.
            if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0) then begin
              //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_SHUTTER_DOWN:OUT_STAGE2_SHUTTER_DOWN:if');
              SetDio(DefDio.OUT_STAGE2_SHUTTER_DOWN);
            end;
            //
            {$IFDEF HAS_DIO_SCREW_SHUTTER}						
            if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
              if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) = 0) then begin //TBD:A2CHv3:DIO? (SHUTTER)
                //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_SHUTTER_DOWN:OUT_STAGE2_SCREW_SHUTTER_UP:if');
                SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP);
              end;
            end;
            {$ENDIF}						
            //
            {$IFDEF SUPPORT_1CG2PANEL}
            if Common.SystemInfo.UseAssyPOCB then begin  // ASSY (ShutterDOWN+ScrewShutterUP+ShutterGuideUP)  //TBD:A2CHv3:DIO (SHUTTERS)
              if ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0) then begin //TBD:A2CHv3:DIO? (SHUTTER, ASSY-Only)
                //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_SHUTTER_DOWN:OUT_SHUTTER_GUIDE_UP:if');
                SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
              end;
            end;
            {$ENDIF}
          end;
          DefDio.IO_AUTO_FLOW_SHUTTER_UP : begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_SHUTTER_UP');
            // Front로 안가고 있으면 계속 가자.
            if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) = 0) then begin
              //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_SHUTTER_UP:OUT_STAGE2_SHUTTER_UP:if');
              SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
            end;
            //
            {$IFDEF HAS_DIO_SCREW_SHUTTER}												
            if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
              if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN) = 0) then begin //TBD:A2CHv3:DIO? (SHUTTER)
                //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_SHUTTER_UP:OUT_STAGE2_SCREW_SHUTTER_DOWN:if');
                SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN);
              end;
            end;
            {$ENDIF}						
            //
            {$IFDEF SUPPORT_1CG2PANEL}
            if Common.SystemInfo.UseAssyPOCB then begin  // ASSY (ShutterUP+ScrewShutterDOWN+ShutterGuideDOWN)  //TBD:A2CHv3:DIO (SHUTTERS)
              if ((m_nDIValue and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0) and ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) = 0) then begin //TBD:A2CHv3:DIO? (SHUTTER, ASSY-Only)
                //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_SHUTTER_UP:OUT_SHUTTER_GUIDE_DOWN:if');
                SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
              end;
            end;
            {$ENDIF}
          end;
          DefDio.IO_AUTO_FLOW_BACK : begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_BACK');
            cdMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD;
            if ((DongaMotion.m_nMotorDOValue and cdMotorOutTarget) = 0) or ((DongaMotion.m_nMotorDIValue and DefMotion.MASK_IN_MOTOR_STAGE2_BACKWARD) = 0) then begin
              //Common.CodeSiteSend('DIO:FIsReadyToTurn2:m_bRestart:IO_AUTO_FLOW_BACK:if');
              if CheckIoBeforeMotorOutSig(OUT_MOTOR_STAGE2_BACKWARD,sEMsg) then begin
                DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue or DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD;
                SetAirKnife(DefPocb.JIG_B, False);
                Common.ThreadTask(procedure begin
                  DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].MoveBACKWARD;
                end);
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_STAGE_BWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
              end
              else begin
                //TBD:A2CHv3:DIO?
              end;
            end;
          end;
        end;
        m_bRestart[DefPocb.JIG_B] := False;
      end;
      case m_nAutoFlow[DefPocb.JIG_B] of
        DefDio.IO_AUTO_FLOW_READY : begin
          //Common.CodeSiteSend('DIO:FIsReadyToTurn2:IO_AUTO_FLOW_READY');
          cdMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE2_FORWARD;
          if ((cdMotorInTarget and DongaMotion.m_nMotorDIValue) = 0) then begin
            //Common.CodeSiteSend('DIO:FIsReadyToTurn2:IO_AUTO_FLOW_READY:if:1');
            // 전진 상태가 아니고, SWITCH가 안켜져 있으면 스위치 키자.
            if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_READY_LED) = 0) then begin
              SetDio(DefDio.OUT_STAGE2_READY_LED);
              //Common.CodeSiteSend('DIO:FIsReadyToTurn2:IO_AUTO_FLOW_READY:if:2');
            end
            else begin
              //CodeSite.Send('DIO:FIsReadyToTurn2:IO_AUTO_FLOW_READY:if:3');
              // LED 불이 들어온 상태에서...    Ready switch 2개가 감지 되면 Turn.
              if ((m_nDIValue and DefDio.MASK_IN_STAGE2_READY) <> 0) then begin
                //Common.CodeSiteSend('DIO:FIsReadyToTurn2:IO_AUTO_FLOW_READY:if:4');
                // TEACT Mode, Door, Vacuum, CameraPC 상태 확인 ...start
                if not IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_2) then begin //F2CH|A2CHv2:CH2
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_B,'CH2 door(s) is opened. To run, close all doors',1);
                  Exit(False);
                end
                else if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) = 0) or ((m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_B,'CH2 SAFETY MODE key is not AUTO. To run, switch SAFTETY MODE key to AUTO',1);
                  Exit(False);
                end
                else if Common.TestModelInfo2[DefPocb.JIG_B].UseVacuum and  //2019-06-24 (GIB의 경우, Vacuum 불필요)
                        (((m_nDIValue and DefDio.MASK_IN_STAGE2_VACUUM1) = 0)
                      or ((m_nDIValue and DefDio.MASK_IN_STAGE2_VACUUM2) = 0)) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_B,'CH2 Vacuume(s) is not working. Check vacuum of CH2',1);
                  Exit(False);
              //{$IFNDEF SIMULATOR_CAM}
                end
                else if Common.IsAlarmOn(DefPocb.ALARM_CAMERA_PC2_DISCONNECTED) then begin //2019-04-26 (CamPC Disconn일 때)
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_B,'Camera-PC2 Communication NG. Check Camera-PC2 status',1);
                  Exit(False);
              //{$ENDIF}
                end;
                // TEACT Mode, Door, Vacuum, CameraPC 상태 확인 ...end
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_B,'',0{dummy});
                if CheckIoBeforeMotorOutSig(OUT_MOTOR_STAGE2_FORWARD,sEMsg) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_PRESS_START,DefPocb.SEQ_RESULT_PASS); //2019-05-20
                  if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_READY_LED) <> 0) then SetDio(DefDio.OUT_STAGE2_READY_LED);
                  //Common.CodeSiteSend('DIO:FIsReadyToTurn2:IO_AUTO_FLOW_READY:if:5');
                  m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_FRONT;
                  SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_START,DefPocb.JIG_B,'',0{dummy}); //2019-01-02
                  DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue or DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD;
                  // Added by SHPARK 2024-02-21 오전 11:25:57 Unit T/T
                  GetUnitTTLog(DefPocb.JIG_B,DefDio.DIO_IDX_GET_TT_START);
                  SetAirKnife(DefPocb.JIG_B, True);  //2022-01-02
                  Common.ThreadTask(procedure begin
                    DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].MoveFORWARD;
                  end);
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_STAGE_FWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
                end
                else begin
                  Common.CodeSiteSend('###DIO:FIsReadyToTurn2:IO_AUTO_FLOW_READY:if:6'+sEMsg);//TBD:A2CHv3:DIO?
                end;
                m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_FRONT;
              end;
            end;
          end;
        end;
      end;
    end;

  Result := True;
end;

{$IFDEF SUPPORT_1CG2PANEL}
function TDioCtl.GetAllDioChAssyPOCB: Boolean;
var
  cdDioInTarget, cdDioOutTarget, cdDioOutSig : UInt64;
  cdMotorInTarget, cdMotorOutTarget, cdMotorOutSig : DWORD;
  nMotionID : Integer;
  sEMsg : string;
  bReadyExit : Boolean;

begin
    CheckShutterTimeout(DefPocb.CH_ALL, ShutterState.UP);
    CheckShutterTimeout(DefPocb.CH_ALL, ShutterState.DOWN);

    //------------------------ Stage front 신호가 들어 오면, Stage front out sig Off 하자.
    //-------------- State.1&2 Stage front 신호가 들어 오면
    cdMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD;
    cdMotorOutSig   := DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD;
    if ((DongaMotion.m_nMotorDIValue and cdMotorInTarget) <> 0) and ((cdMotorOutSig and DongaMotion.m_nMotorDOValue) <> 0) then begin
      DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue and (not DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD);
      SetAirKnife(DefPocb.JIG_A, False);
      SetAirKnife(DefPocb.JIG_B, False);
      if FIsReadyToTurn1 and FIsReadyToTurn2 then begin
        if (m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_FRONT) and (m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_FRONT) then begin
          m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_SHUTTER_DOWN;
          m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_SHUTTER_DOWN;
          DongaDio.SetShutter(DefPocb.JIG_A,ShutterState.DOWN);
        //if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) = 0) then SetDio(DefDio.OUT_STAGE1_SHUTTER_DOWN);
        //if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) = 0) then SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP);
        //if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) = 0) then SetDio(DefDio.OUT_STAGE2_SHUTTER_DOWN);
        //if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) = 0) then SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP);
        //if ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) = 0) then SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_STAGE_FWD,DefPocb.SEQ_RESULT_PASS); //2019-05-20
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_STAGE_FWD,DefPocb.SEQ_RESULT_PASS); //2019-05-20
        end;
      end;
      m_bStopFlag[DefPocb.JIG_A] := False;
      m_bStopFlag[DefPocb.JIG_B] := False;
      Common.CodeSiteSend('<DIO> GetAllDioChAssyPOCB:Exit(CH1/CH2 StageForward)');
      Exit(False);
    end;

    //------------------------ Stage back 신호가 들어오면, Stage back out Sig Off 하자.
    //-------------- Stage.1:  Stage back 신호가 들어오면,
    cdMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE1_BACKWARD;
    cdMotorOutSig   := DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD;
    if ((DongaMotion.m_nMotorDIValue and cdMotorInTarget) <> 0) and ((cdMotorOutSig and DongaMotion.m_nMotorDOValue) <> 0) then begin
      DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue and (not DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD);
      SetAirKnife(DefPocb.JIG_A, False);
      SetAirKnife(DefPocb.JIG_B, False);
      if FIsReadyToTurn1 and FIsReadyToTurn2 then begin
        if (m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_BACK) and (m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_BACK) then begin
          m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_UNLOAD;
          m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_UNLOAD;
          SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_STOP,DefPocb.JIG_A,'',0{dummy}); //2023-08-21 (for LENS EqStatus) after set to IO_AUTO_FLOW_UNLOAD !!!
          SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_STOP,DefPocb.JIG_B,'',0{dummy}); //2023-08-21 (for LENS EqStatus) after set to IO_AUTO_FLOW_UNLOAD !!!
          if Assigned(ArrivedUnload1) then ArrivedUnload1(m_nAutoFlow[DefPocb.JIG_A]);
          if Assigned(ArrivedUnload2) then ArrivedUnload2(m_nAutoFlow[DefPocb.JIG_B]);
          m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_NONE;  //TBD?
          m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_NONE;  //TBD?
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_STAGE_BWD,DefPocb.SEQ_RESULT_PASS); //2019-05-20
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_STAGE_BWD,DefPocb.SEQ_RESULT_PASS); //2019-05-20
        end
        else begin
          SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_STOP,DefPocb.JIG_A,'',0{dummy});
          SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_STOP,DefPocb.JIG_B,'',0{dummy});
        end;
      end
      else begin
        m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_NONE;
        m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_NONE;
      end;
      FIsReadyToTurn1 := False;
      FIsReadyToTurn2 := False;
      Common.CodeSiteSend('<DIO> GetAllDioChAssyPOCB:Exit(CH1/CH2 StageBackward)');
      Exit(False);
    end;

    //------------------------ Shutter Up 신호가 들어 오면, Shutter Up out sig Off 하자.  // ShutterUP+ScrewShutterDOWN(+ShutterGuideUP/ShutterGuideDOWN)
    //-------------- Stage.1: Shutter Up 신호가 들어오면,
    cdDioInTarget := (DefDio.MASK_IN_STAGE1_SHUTTER_UP or DefDio.MASK_IN_STAGE2_SHUTTER_UP);
    cdDioOutSig   := (DefDio.MASK_OUT_STAGE1_SHUTTER_UP or DefDio.MASK_OUT_STAGE2_SHUTTER_UP);
    {$IFDEF FEATURE_KEEP_SHUTTER_UP}
    if Common.SystemInfo.KeepDioShutterUp and ((not m_bOnShutterUp[DefPocb.JIG_A]) or (not m_bOnShutterUp[DefPocb.JIG_B])) then cdDioOutSig := 0;
    {$ENDIF}
    {$IFDEF HAS_DIO_SCREW_SHUTTER}			
    if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
      cdDioInTarget := cdDioInTarget or (DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN  or DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN);
      cdDioOutSig   := cdDioOutSig   or (DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN or DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN);
    end;
		{$ENDIF}
    if Common.SystemInfo.UseAssyPOCB then begin
      cdDioInTarget := cdDioInTarget or DefDio.MASK_IN_SHUTTER_GUIDE_DOWN;
      cdDioOutSig   := cdDioOutSig or DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN;
    end;
    if ((m_nDOValue and cdDioOutSig) <> 0) then begin
      if (CheckShutterState(DefPocb.CH_ALL, ShutterState.UP)) then begin
        {$IFDEF FEATURE_DIO_LOG_SHUTTER}          //2023-05-02 DioLog:ASSY?
        //2023-05-02 DioLog:ASSY:SHUTTER:UP? //TBD:DioLogShutter?			
				{$ENDIF}
        {$IFDEF FEATURE_KEEP_SHUTTER_UP}
        m_bOnShutterUp[DefPocb.JIG_A] := False;
        m_bOnShutterUp[DefPocb.JIG_B] := False;				
        if (not Common.SystemInfo.KeepDioShutterUp)) then begin
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
        end;
        {$ELSE}
        if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE1_SHUTTER_UP);
        if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE2_SHUTTER_UP);
        {$ENDIF}
        m_nOldDIValue := m_nOldDIValue or (DefDio.MASK_IN_STAGE1_SHUTTER_UP or DefDio.MASK_IN_STAGE2_SHUTTER_UP);
        {$IFDEF HAS_DIO_SCREW_SHUTTER}					
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN) <> 0) then SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN);
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN) <> 0) then SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN);
          m_nOldDIValue := m_nOldDIValue or (DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN or DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN);
        end;
				{$ENDIF}
        if Common.SystemInfo.UseAssyPOCB then begin  // ASSY (ShutterUP+ScrewShutterDOWN+ShutterGuideDOWN)
          if ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN) <> 0) then SetDio(DefDio.OUT_SHUTTER_GUIDE_DOWN);
          m_nOldDIValue := m_nOldDIValue or DefDio.MASK_IN_SHUTTER_GUIDE_DOWN;
        end;
      //Common.CodeSiteSend('<DIO> GetAllDioChAssyPOCB:Exit(CH1/CH2 Shutters Opened)');
        if FIsReadyToTurn1 and FIsReadyToTurn2 then begin
          if (m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_SHUTTER_UP) and (m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_SHUTTER_UP) then begin
            m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_BACK;
            m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_BACK;
            if CheckIoBeforeMotorOutSig(OUT_MOTOR_STAGE1_BACKWARD,sEMsg) then begin
              DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue or DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD;
              Common.ThreadTask(procedure begin
                DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].MoveBACKWARD;
              end);
              SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_STAGE_BWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
              SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_STAGE_BWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
            end
            else begin
              //TBD:A2CHv3:DIO?
            end;
          end;
        end;
      end;
      Exit(False);
    end;

    //------------------------ Shutter Down 신호가 들어오면, Shutter Down out Sig Off 하자. // ShutterDown+ScrewShutterUp(+GuideDown)
    //-------------- Stage.1: Shutter Down 신호가 들어오면
    cdDioInTarget := (DefDio.MASK_IN_STAGE1_SHUTTER_DOWN  or DefDio.MASK_IN_STAGE2_SHUTTER_DOWN);
    cdDioOutSig   := (DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN or DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN);
    {$IFDEF HAS_DIO_SCREW_SHUTTER}							
    if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
      cdDioInTarget := cdDioInTarget or (DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP  or DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP);
      cdDioOutSig   := cdDioOutSig   or (DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP or DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP);
    end;
		{$ENDIF}
    if Common.SystemInfo.UseAssyPOCB then begin
      cdDioInTarget := cdDioInTarget or DefDio.MASK_IN_SHUTTER_GUIDE_UP;
      cdDioOutSig   := cdDioOutSig or DefDio.MASK_OUT_SHUTTER_GUIDE_UP;
    end;
    if ((m_nDOValue and cdDioOutSig) <> 0) then begin
      if CheckShutterState(DefPocb.JIG_ALL, ShutterState.DOWN) then begin
        {$IFDEF FEATURE_DIO_LOG_SHUTTER}          //2023-05-02 DioLog:ASSY?
        //2023-05-02 DioLog:ASSY:SHUTTER:DOWN? //TBD:DioLogShutter?			
				{$ENDIF}			
        if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN) <> 0) then SetDio(DefDio.OUT_STAGE1_SHUTTER_DOWN);
        if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN) <> 0) then SetDio(DefDio.OUT_STAGE2_SHUTTER_DOWN);
        m_nOldDIValue := m_nOldDIValue or (DefDio.MASK_IN_STAGE1_SHUTTER_DOWN or DefDio.MASK_IN_STAGE2_SHUTTER_DOWN);
        {$IFDEF HAS_DIO_SCREW_SHUTTER}									
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_SCREW_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP);
          if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_SCREW_SHUTTER_UP) <> 0) then SetDio(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP);
          m_nOldDIValue := m_nOldDIValue or (DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP or DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP);
        end;
				{$ENDIF}
        if Common.SystemInfo.UseAssyPOCB then begin  // ASSY (ShutterDOWN+ScrewShutterUP+ShutterGuideUP)
          if ((m_nDOValue and DefDio.MASK_OUT_SHUTTER_GUIDE_UP) <> 0) then SetDio(DefDio.OUT_SHUTTER_GUIDE_UP);
          m_nOldDIValue := m_nOldDIValue or DefDio.MASK_IN_SHUTTER_GUIDE_UP;
        end;
        Common.CodeSiteSend('<DIO> GetAllDioChAssyPOCB:Exit(CH1/CH2 Shutters Closed)');
        if FIsReadyToTurn1 and FIsReadyToTurn2 then begin
          Common.CodeSiteSend('DIO:Exit:Stage.1: Shutter Down:FIsReadyToTurn1&2');
          if (m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_SHUTTER_DOWN) and (m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_SHUTTER_DOWN) then begin
            //Common.CodeSiteSend('DIO:Exit:Stage.1: Shutter Down:FIsReadyToTurn1:IO_AUTO_FLOW_SHUTTER_DOWN');
            m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_CAMERA;
            m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_CAMERA;
          end;
        end;
      end;
      Exit(False);
    end;

    //------------------------ Power On - Pattern Display가 되면 Camera Zone으로 턴할수 있도록 Ready Sig Out 상태 설정.
    //-------------- Stage.1&2 : Power On - Pattern Display가 되면
    if FIsReadyToTurn1 and FIsReadyToTurn2 then begin
    //Common.CodeSiteSend('DIO:GetAllDioChAssyPOCB:FIsReadyToTurn1&2');
      if (m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_READY) and (m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_READY) then begin
        //Common.CodeSiteSend('DIO:GetAllDioChAssyPOCB:FIsReadyToTurn1&2:IO_AUTO_FLOW_READY');
          cdMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD;
          if ((cdMotorInTarget and DongaMotion.m_nMotorDIValue) = 0) then begin
          //Common.CodeSiteSend('DIO:GetAllDioChAssyPOCB:FIsReadyToTurn1&2:IO_AUTO_FLOW_READY:if:1');
            // 전진 상태가 아니고, SWITCH가 안켜져 있으면 스위치 키자.
            if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_READY_LED) = 0) or ((m_nDOValue and DefDio.MASK_OUT_STAGE2_READY_LED) = 0) then begin
              if (m_nDOValue and DefDio.MASK_OUT_STAGE1_READY_LED) = 0 then SetDio(DefDio.OUT_STAGE1_READY_LED);
              if (m_nDOValue and DefDio.MASK_OUT_STAGE2_READY_LED) = 0 then SetDio(DefDio.OUT_STAGE2_READY_LED);
            //Common.CodeSiteSend('DIO:GetAllDioChAssyPOCB:FIsReadyToTurn1&2:IO_AUTO_FLOW_READY:if:2');
            end
            else begin
            //Common.CodeSiteSend('DIO:GetAllDioChAssyPOCB:FIsReadyToTurn1&2:IO_AUTO_FLOW_READY:if:3');
              // LED 불이 들어온 상태에서...    Ready switch 2개가 감지 되면 Turn.
              bReadyExit := False;
              if ((m_nDIValue and DefDio.MASK_IN_STAGE1_READY) <> 0) or ((m_nDIValue and DefDio.MASK_IN_STAGE2_READY) <> 0) then begin
                //Common.CodeSiteSend('DIO:FIsReadyToTurn1:IO_AUTO_FLOW_READY:if:4');
                // TEACT Mode, Door, Vacuum, CameraPC 상태 확인 ...start
                if not IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_1) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_A,'CH1 door(s) is opened. To run, close all doors',1);
                  bReadyExit := True;
                end;
                if not IsDoorClosed(True{bCheckUnderDoor},DefPocb.CH_2) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_B,'CH2 door(s) is opened. To run, close all doors',1);
                  bReadyExit := True;
                end;
                if bReadyExit then Exit(False);
                //
                if ((m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_AUTOMODE) = 0) or ((m_nDIValue and DefDio.MASK_IN_STAGE1_SWITCH_TEACHMODE) <> 0) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_A,'CH1 is not AUTO. To run, switch key to AUTO',1);
                  bReadyExit := True;
                end;
                if ((m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_AUTOMODE) = 0) or ((m_nDIValue and DefDio.MASK_IN_STAGE2_SWITCH_TEACHMODE) <> 0) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_B,'CH2 is not AUTO. To run, switch key to AUTO',1);
                  bReadyExit := True;
                end;
                if bReadyExit then Exit(False);
                //
                if Common.TestModelInfo2[DefPocb.JIG_A].UseVacuum and
                   (((m_nDIValue and DefDio.MASK_IN_STAGE1_VACUUM1) = 0) or ((m_nDIValue and DefDio.MASK_IN_STAGE1_VACUUM2) = 0)) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_A,'CH1 Vacuume(s) is not working. Check vacuum of CH1',1);
                  bReadyExit := True;
                end;
                if Common.TestModelInfo2[DefPocb.JIG_B].UseVacuum and
                   (((m_nDIValue and DefDio.MASK_IN_STAGE2_VACUUM1) = 0) or ((m_nDIValue and DefDio.MASK_IN_STAGE2_VACUUM2) = 0)) then begin
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_B,'CH2 Vacuume(s) is not working. Check vacuum of CH1',1);
                  bReadyExit := True;
                end;
                if bReadyExit then Exit(False);
              //{$IFNDEF SIMULATOR_CAM}
                if Common.IsAlarmOn(DefPocb.ALARM_CAMERA_PC1_DISCONNECTED) then begin //2019-04-26 (CamPC Disconn일 때)
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_A,'Camera-PC1 Communication NG. Check Camera-PC1 status',1);
                  bReadyExit := True;
                end;
                if Common.IsAlarmOn(DefPocb.ALARM_CAMERA_PC2_DISCONNECTED) then begin //2019-04-26 (CamPC Disconn일 때)
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_B,'Camera-PC2 Communication NG. Check Camera-PC2 status',1);
                  bReadyExit := True;
                end;
                if bReadyExit then Exit(False);
              //{$ENDIF}
                //
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_PRESS_START,DefPocb.SEQ_RESULT_PASS); //2019-05-20
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_PRESS_START,DefPocb.SEQ_RESULT_PASS); //2019-05-20
                // TEACT Mode, Door, Vacuum, CameraPC 상태 확인 ...end
                if ((m_nDOValue and DefDio.MASK_OUT_STAGE1_READY_LED) <> 0) then SetDio(DefDio.OUT_STAGE1_READY_LED);
                if ((m_nDOValue and DefDio.MASK_OUT_STAGE2_READY_LED) <> 0) then SetDio(DefDio.OUT_STAGE2_READY_LED);
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_A,'',0{dummy});
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_JIG_STATUS,DefPocb.JIG_B,'',0{dummy});
                if CheckIoBeforeMotorOutSig(OUT_MOTOR_STAGE1_FORWARD,sEMsg) then begin                       
                  //Common.CodeSiteSend('DIO:GetAllDioChAssyPOCB:FIsReadyToTurn1&2:IO_AUTO_FLOW_READY:if:5');								        
                  SetAirKnife(DefPocb.JIG_A, True); //2022-01-22
                  SetAirKnife(DefPocb.JIG_B, True); //2022-01-22
                  m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_FRONT;                                  //2023-08-21 (for LENS EqStatus)
                  m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_FRONT;                                  //2023-08-21 (for LENS EqStatus)
                  SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_START,DefPocb.JIG_A,'',0{dummy}); //2019-01-02 //2023-08-21 (for LENS EqStatus) after set to IO_AUTO_FLOW_FRONT !!!
                  SendTestGuiDisplay(DefPocb.MSG_MODE_JIG_TT_START,DefPocb.JIG_B,'',0{dummy}); //2019-01-02 //2023-08-21 (for LENS EqStatus) after set to IO_AUTO_FLOW_FRONT !!!
                  DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue or DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD;
                  Common.ThreadTask(procedure begin
                    DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].MoveFORWARD;
                  end);
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_A,'',DefPocb.POCB_SEQ_STAGE_FWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
                  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,DefPocb.JIG_B,'',DefPocb.POCB_SEQ_STAGE_FWD,DefPocb.SEQ_RESULT_WORKING); //2019-05-20
                end
                else begin
                  Common.CodeSiteSend('DIO:GetAllDioChAssyPOCB:FIsReadyToTurn1&2:IO_AUTO_FLOW_READY:if:6:CheckIoBeforeMotorOutSig Failed');
                end;
                m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_FRONT;
                m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_FRONT;
              end;
            end;
          end;
      end;
    end
    else begin
      //DongaMotion.Motion[DefMotion.MOTIONID_AxtMC_STAGE1_Y].m_bServoRecover := False;
    end;

  Result := True;
end;
{$ENDIF} //SUPPORT_1CG2PANEL

//##############################################################################################
{$ENDIF} //A2CHv3|A2CHv4 //#####################################################################
//##############################################################################################

//******************************************************************************
// procedure/function:
//    - procedure TDongaDio.GetDioStatus;
//    - function TDongaDio.CheckIoBeforeOutSig(const wSig: LongWord): Boolean;
//    - function TDongaDio.SetDio(lwSignal: LongWord; bAllSet: Boolean = False): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] TDongaDio.GetDioStatus
//    Called-by: procedure TfrmMain.CreateClassData;
//

procedure TDioCtl.GetDioStatus;
begin
  tmCheckDio.Enabled := True;
end;

function TDioCtl.GetDiValue(nNum: Byte): UInt64;
begin
  Result := m_nDIValue and (UInt64(1) shl nNum );
end;

function TDioCtl.GetDiValue(nNums: array of byte): UInt64;
var
  nIdx  : Integer;
  nSum : UInt64;
begin
  for nIdx := 0 to High(nNums) do
     nSum := nSum or (UInt64(1) shl nNums[nIdx]);

  Result := m_nDIValue and nSum;
end;

function TDioCtl.GetDoValue(nNum: Byte): UInt64;
begin
  Result := m_nDoValue and ( UInt64(1) shl nNum );
end;

function TDioCtl.GetDoValue(nNums: array of byte): UInt64;
var
  nIdx  : Integer;
  nSum : UInt64;
begin

  for nIdx := 0 to High(nNums) do
     nSum := nSum or (UInt64(1) shl nNums[nIdx]);

  Result := m_nDOValue and nSum;
end;

// if these state aren't the same each other, Set out signal ( xor )
function TDioCtl.SetDoValue(nNum: Byte; bValue : Boolean): Integer;
begin
  if (GetDoValue(nNum) <> 0) xor bValue then
    Result := SetDio(nNum) // ToggleDio
  else
    Result := 0;
end;

// if these state are the same each other, return True ( xnor )
function TDioCtl.CheckState(nNum: Byte; bValue: Boolean): Boolean;
begin

  Result := not ((DongaDio.GetDIValue(nNum) <> 0) xor bValue);
end;



function TDioCtl.CheckState(nArrNum : array of Byte; bValue : Boolean) : Boolean;
var
  nIdx : Integer;
begin
  for nIdx := 0 to High(nArrNum) do begin
    if not CheckState(nArrNum[nIdx], bValue) then Exit(False);
  end;

  Result := True;
end;

function TDioCtl.GetSelectedBuzzer: Byte;
var
  nTemp : Integer;
begin
{$IFDEF HAS_DIO_MULTIPLE_BUZZER}
  nTemp := 5;
  case nTemp of // Need to select in SystemInfo
    1: Result := OUT_MELODY1;
    2: Result := OUT_MELODY2;
    3: Result := OUT_MELODY3;
    4: Result := OUT_MELODY4;
  else
    Result := OUT_MELODY1; //OUT_BUZZER; //TBD:A2CHv3:DIO? (BUZZER)
  end;
{$ELSE}
   Result := OUT_BUZZER;
{$ENDIF}
end;

function TDioCtl.SetBuzzer(bValue: Boolean) : Integer;
begin
  Result := SetDoValue(GetSelectedBuzzer, bValue);
end;

function TDioCtl.SetAirKnife(nCh: Integer; bValue: Boolean) : Integer;
var
  nDioOut : Byte;
begin
  Result := 0;

{$IFNDEF HAS_DIO_AIRKNIFE}
  Exit;
{$ENDIF}
   if Common.SystemInfo.HasDioOutStageLamp then begin
     nDioOut := DefDio.OUT_STAGE1_STAGE_LAMP_OFF + nCh;
     SetDoValue(nDioOut,not bValue);
   end;
  if not Common.SystemInfo.UseAirKnife then Exit;
{$IFDEF POCB_A2CHv3} //A2CHv3: CH1&CH2 AirKnife
  nDioOut := DefDio.OUT_AIR_KNIFE;
  m_bAirKnifeSet[nCh] := bValue;
  if bValue then begin //On
    Result := SetDoValue(nDioOut,bValue);
  end
  else begin           //Off
    if not (m_bAirKnifeSet[nCh] or m_bAirKnifeSet[nCh]) then begin
      Result := SetDoValue(nDioOut,bValue); //Off if CH1&CH2 all off
    end;
  end;
{$ELSE}              //else: CH1/CH2 AirKnife
  case nCh of
    DefPocb.CH_1: nDioOut := DefDio.OUT_AIR_KNIFE1;
    DefPocb.CH_2: nDioOut := DefDio.OUT_AIR_KNIFE2;
    else Exit(-1)
  end;
  Result := SetDoValue(nDioOut,bValue);
{$ENDIF}
end;



function TDioCtl.CheckLightDetect(nCh : Integer; bValue : Boolean) : Boolean;
var
  arrDi : array[DefPocb.CH_1..DefPocb.CH_MAX] of Integer;
begin
{$IFDEF HAS_DIO_EXLIGHT_DETECT}
  if not Common.SystemInfo.HasDioExLightDetect then Exit(True); //2022-07-15 A2CHv4_#3(No ExLightDetectSensor)
  if not Common.SystemInfo.UseDetectLight then Exit(True);

  if not (nCh in [DefPocb.CH_1..DefPocb.CH_MAX]) then Exit(False);

  arrDi[DefPocb.CH_1] := DefDio.IN_STAGE1_EXLIGHT_DETECT;
  arrDi[DefPocb.CH_2] := DefDio.IN_STAGE2_EXLIGHT_DETECT;

  Result := CheckState(arrDi[nCh],bValue);
{$ELSE}
  Result := True;
{$ENDIF}
end;

//##############################################################################################
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)} //#############################################
//##############################################################################################
function TDioCtl.SetShutter(nCh : Integer; value : ShutterState) : Integer; //A2CH|A2CHv2
var
  arrDoUp   : array[DefPocb.CH_1..DefPocb.CH_MAX] of Integer;
  arrDoDown : array[DefPocb.CH_1..DefPocb.CH_MAX] of Integer;
begin
  if not (nCh in [DefPocb.CH_1..DefPocb.CH_MAX]) then Exit(-1);

  arrDoUp[DefPocb.CH_1] := DefDio.OUT_STAGE1_SHUTTER_UP;
  arrDoUp[DefPocb.CH_2] := DefDio.OUT_STAGE2_SHUTTER_UP;

  arrDoDown[DefPocb.CH_1] := DefDio.OUT_STAGE1_SHUTTER_DOWN;
  arrDoDown[DefPocb.CH_2] := DefDio.OUT_STAGE2_SHUTTER_DOWN;

  case value of
    ShutterState.OFF : begin
      SetDoValue(arrDoDown[nCh], False);
      SetDoValue(arrDoUp[nCh],   False);
    end;
    ShutterState.UP : begin
      SetDoValue(arrDoDown[nCh], False);
      SetDoValue(arrDoUp[nCh],   True);
    end;
    ShutterState.DOWN : begin
      SetDoValue(arrDoUp[nCh],   False);
      SetDoValue(arrDoDown[nCh], True);
    end;
  end;
  Result := 0;
end;

//##############################################################################################
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)} //#######################################
//##############################################################################################
function TDioCtl.SetShutter(nCh : Integer; value : ShutterState) : Integer; //A2CHv3|A2CHv4|ATO|GAGO
begin
  if not (nCh in [DefPocb.CH_1..DefPocb.CH_MAX]) then Exit(-1);

  {$IFDEF SUPPORT_1CG2PANEL}
  if not Common.SystemInfo.UseAssyPOCB then begin
  {$ENDIF}
    case value of
      ShutterState.OFF : begin
        if nCh = DefPocb.CH_1 then begin
          SetDoValue(DefDio.OUT_STAGE1_SHUTTER_UP,        False);
          SetDoValue(DefDio.OUT_STAGE1_SHUTTER_DOWN,      False);
	        {$IFDEF HAS_DIO_SCREW_SHUTTER}					
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
            SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP,  False);
            SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN,False);
          end;
					{$ENDIF}
        end
        else begin
          SetDoValue(DefDio.OUT_STAGE2_SHUTTER_UP,        False);
          SetDoValue(DefDio.OUT_STAGE2_SHUTTER_DOWN,      False);
	        {$IFDEF HAS_DIO_SCREW_SHUTTER}										
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
            SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP,  False);
            SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN,False);
          end;
					{$ENDIF}
        end;
      end;
      ShutterState.UP : begin  // Shutter-Up & ScrewShutter-Down
        if nCh = DefPocb.CH_1 then begin
          SetDoValue(DefDio.OUT_STAGE1_SHUTTER_UP,        True);
          SetDoValue(DefDio.OUT_STAGE1_SHUTTER_DOWN,      False);
	        {$IFDEF HAS_DIO_SCREW_SHUTTER}
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
            SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP,  False);
            SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN,True);
          end;
					{$ENDIF}					
        end
        else begin
          SetDoValue(DefDio.OUT_STAGE2_SHUTTER_UP,        True);
          SetDoValue(DefDio.OUT_STAGE2_SHUTTER_DOWN,      False);
	        {$IFDEF HAS_DIO_SCREW_SHUTTER}															
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
            SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP,  False);
            SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN,True);
          end;
					{$ENDIF}					
        end;
      end;
      ShutterState.DOWN : begin  // Shutter-Down & ScrewShutter-Up
        if nCh = DefPocb.CH_1 then begin
          SetDoValue(DefDio.OUT_STAGE1_SHUTTER_UP,        False);
          SetDoValue(DefDio.OUT_STAGE1_SHUTTER_DOWN,      True);
	        {$IFDEF HAS_DIO_SCREW_SHUTTER}															
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
            SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP,  True);
            SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN,False);
          end;
					{$ENDIF}					
        end
        else begin
          SetDoValue(DefDio.OUT_STAGE2_SHUTTER_UP,        False);
          SetDoValue(DefDio.OUT_STAGE2_SHUTTER_DOWN,      True);
	        {$IFDEF HAS_DIO_SCREW_SHUTTER}															
          if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
            SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP,  True);
            SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN,False);
          end;
					{$ENDIF}
        end;
      end;
    end;
  {$IFDEF SUPPORT_1CG2PANEL}
  end
  else begin
    case value of
      ShutterState.OFF : begin
        SetDoValue(DefDio.OUT_STAGE1_SHUTTER_UP,        False);
        SetDoValue(DefDio.OUT_STAGE1_SHUTTER_DOWN,      False);
        SetDoValue(DefDio.OUT_STAGE2_SHUTTER_UP,        False);
        SetDoValue(DefDio.OUT_STAGE2_SHUTTER_DOWN,      False);
        //
        {$IFDEF HAS_DIO_SCREW_SHUTTER}				
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
          SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP,  False);
          SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN,False);
          SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP,  False);
          SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN,False);
        end;
				{$ENDIF}				
        //
        SetDoValue(DefDio.OUT_SHUTTER_GUIDE_UP,         False);
        SetDoValue(DefDio.OUT_SHUTTER_GUIDE_DOWN,       False);
      end;
      ShutterState.UP : begin  // Shutter-Up & ScrewShutter-Down (+ ShutterGuide-Up)
        SetDoValue(DefDio.OUT_STAGE1_SHUTTER_UP,        True);
        SetDoValue(DefDio.OUT_STAGE1_SHUTTER_DOWN,      False);
        SetDoValue(DefDio.OUT_STAGE2_SHUTTER_UP,        True);
        SetDoValue(DefDio.OUT_STAGE2_SHUTTER_DOWN,      False);
        //
        {$IFDEF HAS_DIO_SCREW_SHUTTER}				
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
          SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP,  False);
          SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN,True);
          SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP,  False);
          SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN,True);
        end;
				{$ENDIF}				
        //
        SetDoValue(DefDio.OUT_SHUTTER_GUIDE_UP,         False);
        SetDoValue(DefDio.OUT_SHUTTER_GUIDE_DOWN,       True);
      end;
      ShutterState.DOWN : begin  // Shutter-Down & ScrewShutter-Up (+ ShutterGuide-Down)
        SetDoValue(DefDio.OUT_STAGE1_SHUTTER_UP,        False);
        SetDoValue(DefDio.OUT_STAGE1_SHUTTER_DOWN,      True);
        SetDoValue(DefDio.OUT_STAGE2_SHUTTER_UP,        False);
        SetDoValue(DefDio.OUT_STAGE2_SHUTTER_DOWN,      True);
        //
        {$IFDEF HAS_DIO_SCREW_SHUTTER}				
        if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
          SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_UP,  True);
          SetDoValue(DefDio.OUT_STAGE1_SCREW_SHUTTER_DOWN,False);
          SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_UP,  True);
          SetDoValue(DefDio.OUT_STAGE2_SCREW_SHUTTER_DOWN,False);
        end;
				{$ENDIF}
        //
        SetDoValue(DefDio.OUT_SHUTTER_GUIDE_UP,         True);
        SetDoValue(DefDio.OUT_SHUTTER_GUIDE_DOWN,       False);
      end;
    end;
  end;
  {$ENDIF} //SUPPORT_1CG2PANEL
  Result := 0;
end;
//##############################################################################################
{$ENDIF}                 //#####################################################################
//##############################################################################################

function TDioCtl.CheckPinblock(nCh: Integer; bValue : Boolean) : Boolean;
var
  arrDi : array[DefPocb.CH_1..DefPocb.CH_MAX] of Integer;
begin
{$IFDEF HAS_DIO_PINBLOCK}
  if not (nCh in [DefPocb.CH_1..DefPocb.CH_MAX]) then Exit(False);

  if not Common.SystemInfo.UsePinBlock then Exit(True);

  arrDi[DefPocb.CH_1] := DefDio.IN_STAGE1_PINBLOCK_CLOSE;
  arrDi[DefPocb.CH_2] := DefDio.IN_STAGE2_PINBLOCK_CLOSE;

  Result := CheckState(arrDi[nCh], bValue);
{$ELSE}
  Result := True;
{$ENDIF}
end;

function TDioCtl.CheckVacuum(nCh : Integer; bValue : Boolean): Boolean;
var
  arrDo1 : array[DefPocb.CH_1..DefPocb.CH_MAX] of Integer;
  arrDo2 : array[DefPocb.CH_1..DefPocb.CH_MAX] of Integer;
begin
{$IFDEF SIMULATOR_DIO}
  Exit(True);
{$ENDIF}
  if not (nCh in [DefPocb.CH_1..DefPocb.CH_MAX]) then Exit(False);

  arrDo1[DefPocb.CH_1] := DefDio.IN_STAGE1_VACUUM1;
  arrDo2[DefPocb.CH_1] := DefDio.IN_STAGE1_VACUUM2;

  arrDo1[DefPocb.CH_2] := DefDio.IN_STAGE2_VACUUM1;
  arrDo2[DefPocb.CH_2] := DefDio.IN_STAGE2_VACUUM2;

  Result := CheckState([arrDo1[nCh], arrDo2[nCh]], bValue);
end;

function TDioCtl.SetBlow(nCh : Integer; nDelay : Integer) : Integer;
var
  arrDo1 : array[DefPocb.CH_1..DefPocb.CH_MAX] of Integer;
  arrDo2 : array[DefPocb.CH_1..DefPocb.CH_MAX] of Integer;
begin
{$IFDEF HAS_DIO_DESTRUCT}
  if not (nCh in [DefPocb.CH_1..DefPocb.CH_MAX]) then Exit(-1);

  arrDo1[DefPocb.CH_1] := DefDio.OUT_STAGE1_DESTRUCTION_SOL1;
  arrDo1[DefPocb.CH_2] := DefDio.OUT_STAGE2_DESTRUCTION_SOL1;

  arrDo2[DefPocb.CH_1] := DefDio.OUT_STAGE1_DESTRUCTION_SOL2;
  arrDo2[DefPocb.CH_2] := DefDio.OUT_STAGE2_DESTRUCTION_SOL2;

  SetAutoOffOut(arrDo1[nCh], nDelay);
  SetAutoOffOut(arrDo2[nCh], nDelay);
{$ELSE}
  Result := 0;
{$ENDIF}
end;

function TDioCtl.SetStageLamp(nCh: Integer; bOn: Boolean): Integer;
begin
{$IFDEF HAS_DIO_OUT_STAGE_LAMP}
  if not (nCh in [DefPocb.CH_1..DefPocb.CH_MAX]) then Exit(-1);

  if nCh = DefPocb.CH_1 then SetDoValue(DefDio.OUT_STAGE1_STAGE_LAMP_OFF, not bOn)
  else                       SetDoValue(DefDio.OUT_STAGE2_STAGE_LAMP_OFF, not bOn)
{$ELSE}
  Result := 0;
{$ENDIF}
end;

function TDioCtl.SetTowerLamp(bRed, bYel, bGrn : Boolean; bBzr : Boolean = False) : Integer;
var
  nRet : Integer;
begin
  Result := 0;

  nRet := SetDoValue(DefDio.OUT_LAMP_RED,  bRed);
  if nRet <> 0 then Result := nRet;
  nRet := SetDoValue(DefDio.OUT_LAMP_YELLOW, bYel);
  if nRet <> 0 then Result := nRet;
  nRet := SetDoValue(DefDio.OUT_LAMP_GREEN,  bGrn);
  if nRet <> 0 then Result := nRet;
  nRet := SetBuzzer(bBzr);
  if nRet <> 0 then Result := nRet;
end;

//##############################################################################################
{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)} //#############################################
//##############################################################################################
{$IFDEF HAS_DIO_IN64}
function TDioCtl.CheckIoBeforeDioOutSig(const wDioSig: UInt64;out sEMsg: string): Boolean; //A2CH: DWORD, F2CH:UInt64;
{$ELSE}
function TDioCtl.CheckIoBeforeDioOutSig(const wDioSig: DWORD;out sEMsg: string): Boolean;
{$ENDIF}
function TDioCtl.CheckIoBeforeMotorOutSig(const wMotorSig: DWORD): Boolean;

//##############################################################################################
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)} //#######################################
//##############################################################################################
function TDioCtl.CheckIoBeforeDioOutSig(const wDioSig: UInt64;out sEMsg: string): Boolean; //A2CHv3|A2CHv4|ATO|GAGO
var
  wDioInSig, wDioInTarget, wDioOutTarget, wDioOutSig : UInt64; //A2CH: DWORD, F2CH:UInt64;
  wMaskOutSig : UInt64; //A2CH: DWORD, F2CH:UInt64; //2022-07-15 A2CHv4_#3
  wMotorInSig, wMotorInTarget, wMotorOutTarget, wMotorOutSig : DWORD;
  bRet : Boolean;
begin
  wDioInSig  := m_nDIValue;
  wDioOutSig := wDioSig;  // !!!
  if DongaMotion <> nil then begin  //2019-04-06
    wMotorInSig  := DongaMotion.m_nMotorDIValue;
    wMotorOutSig := DongaMotion.m_nMotorDOValue;
  end
  else begin
    wMotorInSig  := 0;
    wMotorOutSig := 0;
  end;
  bRet := True;
  sEMsg := '';
  //-------------------------- In case of Stage font & back.

  //-------------- Stage.1: Shutter down, Screw-shutter up, Shutter-guide up
  wMaskOutSig := DefDio.MASK_OUT_STAGE1_SHUTTER_DOWN;
  {$IFDEF HAS_DIO_SCREW_SHUTTER}
  if Common.SystemInfo.HasDioScrewShutter then wMaskOutSig := wMaskOutSig or MASK_OUT_STAGE1_SCREW_SHUTTER_UP; //2022-07-15 A2CHv4_#3(No ScrewShutter)
	{$ENDIF}
  {$IFDEF SUPPORT_1CG2PANEL}
  wMaskOutSig := wMaskOutSig or DefDio.MASK_OUT_SHUTTER_GUIDE_UP;
  {$ENDIF}
  if ((wDioOutSig and wMaskOutSig) <> 0) then begin
    //----- EMS일 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_EMO_ALL) <> 0 then begin
      sEMsg := 'EMO(s) sensor detected';
      Exit(False);  //TBD:A2CHv3:DIO? (EMO)
    end;
    //------ Stage1 Light Curtain 신호가 없을 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_STAGE1_LIGHT_CURTAIN) = 0 then begin
      sEMsg := 'CH1 Light Curtain sensor NOT detected';
      Exit(False);
    end;
    //------ CH1 Door Sensor 경우 신호 나가면 안됨.
    if (wDioInSig and (DefDio.MASK_IN_STAGE1_DOOR1_OPEN or DefDio.MASK_IN_STAGE1_DOOR2_OPEN)) <> 0 then begin
      sEMsg := 'CH1 Door(s) sensor detected';
      Exit(False);
    end;
    //----- EMS일 경우 Reset 하기전에 신호 나가면 안됨.
    if m_bEmsFlag then begin
      sEMsg := 'Reset EMO';
      Exit(False);  //TBD:A2CHv3:DIO? (EMS?)
    end;
    //----- Motion Control 초기화 이전 상태인 경우, shutter down 하지 않음  //2019-04-06
    if (DongaMotion = nil) or (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE1_Y].m_bConnected) then begin
      sEMsg := 'CH1 Y-Axis motion device NOT initialized';
      Exit(False);
    end;
    //----- front or Back stage out 신호가 있으면 움직이면 안됨.
    wMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD or DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD;
    if (wMotorOutSig and wMotorOutTarget) <> 0 then begin
      sEMsg := 'Stage1 is Moving or Undefined Position';
      Exit(False);
    end;
    //----- Front가 아니면, shutter down or shutter-guide up 발지
    wMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD;
    if (wMotorInSig and wMotorInTarget) = 0 then begin
		  {$IFDEF SUPPORT_1CG2PANEL}
		  wMaskOutSig := wMaskOutSig and (not DefDio.MASK_OUT_SHUTTER_GUIDE_UP); //clear OUT_SHUTTER_GUIDE_UP
		  {$ENDIF}		
      if (wDioOutSig and wMaskOutSig) <> 0 then begin // OUT_STAGE1_SHUTTER_DOWN (or OUT_STAGE1_SCREW_SHUTTER_UP) 
        sEMsg := 'Stage1 is NOT at Front';
        Exit(False);
      end;
    end;

    m_tTime[DefPocb.JIG_A] := Now;
		{$IFDEF FEATURE_KEEP_SHUTTER_UP}
    m_bOnShutterUp[DefPocb.JIG_A] := False;
		{$ENDIF}
  end;

  //-------------- Stage.2: Shutter down, Screw-shutter up, Shutter-guide up
  wMaskOutSig := DefDio.MASK_OUT_STAGE2_SHUTTER_DOWN;
  {$IFDEF HAS_DIO_SCREW_SHUTTER}	
  if Common.SystemInfo.HasDioScrewShutter then wMaskOutSig := wMaskOutSig or MASK_OUT_STAGE2_SCREW_SHUTTER_UP; //2022-07-15 A2CHv4_#3(No ScrewShutter)
  {$ENDIF}	
  {$IFDEF SUPPORT_1CG2PANEL}
  wMaskOutSig := wMaskOutSig or DefDio.MASK_OUT_SHUTTER_GUIDE_UP;
  {$ENDIF}
  if ((wDioOutSig and wMaskOutSig) <> 0) then begin
    //----- EMS일 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_EMO_ALL) <> 0 then begin
      sEMsg := 'EMO(s) sensor detected';
      Exit(False);  //TBD:A2CHv3:DIO? (EMO)
    end;
    //------ Stage2 Light Curtain 신호가 없을 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_STAGE2_LIGHT_CURTAIN) = 0 then begin
      sEMsg := 'CH2 Light Curtain sensor NOT detected';
      Exit(False);
    end;
    //------ CH2 Door Sensor 경우 신호 나가면 안됨.
    if (wDioInSig and (DefDio.MASK_IN_STAGE2_DOOR1_OPEN or DefDio.MASK_IN_STAGE2_DOOR2_OPEN)) <> 0 then begin
      sEMsg := 'CH2 Door(s) sensor detected';
      Exit(False);
    end;
    //----- EMS일 경우 Reset 하기전에 신호 나가면 안됨.
    if m_bEmsFlag then begin
      sEMsg := 'Reset EMO';
      Exit(False);  //TBD:A2CHv3:DIO? (EMS?)
    end;
    //----- Motion Control 초기화 이전 상태인 경우, shutter down 하지 않음  //2019-04-06
    if (DongaMotion = nil) or (not DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bConnected) then begin
      sEMsg := 'CH2 Y-Axis motion device NOT initialized';
      Exit(False);
    end;
    //----- front or Back stage out 신호가 있으면 움직이면 안됨.
    wMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD or DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD;
    if (wMotorOutSig and wMotorOutTarget) <> 0 then begin
      sEMsg := 'Stage2 is Moving or Undefined Position';
      Exit(False);
    end;
    //----- Font가 아니면, shutter down or shutter-guide up 발지
    wMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE2_FORWARD;
    if (wMotorInSig and wMotorInTarget) = 0 then begin
		  {$IFDEF SUPPORT_1CG2PANEL}
		  wMaskOutSig := wMaskOutSig and (not DefDio.MASK_OUT_SHUTTER_GUIDE_UP); //clear OUT_SHUTTER_GUIDE_UP
		  {$ENDIF}		
      if (wDioOutSig and wMaskOutSig) <> 0 then begin // OUT_STAGE2_SHUTTER_DOWN (or OUT_STAGE2_SCREW_SHUTTER_UP) 
        sEMsg := 'Stage1 is NOT at Front';
        Exit(False);
      end;
    end;

    m_tTime[DefPocb.JIG_B] := Now;
		{$IFDEF FEATURE_KEEP_SHUTTER_UP}		
    m_bOnShutterUp[DefPocb.JIG_B] := False;
		{$ENDIF}
  end;

  //-------------- Stage.1: Shutter up, Screw-shutter down, Shutter-guide down
  wMaskOutSig := DefDio.MASK_OUT_STAGE1_SHUTTER_UP;
  {$IFDEF HAS_DIO_SCREW_SHUTTER}		
  if Common.SystemInfo.HasDioScrewShutter then wMaskOutSig := wMaskOutSig or MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN; //2022-07-15 A2CHv4_#3(No ScrewShutter)
  {$ENDIF}	
  {$IFDEF SUPPORT_1CG2PANEL}
  wMaskOutSig := wMaskOutSig or DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN;
  {$ENDIF}
  if ((wDioOutSig and wMaskOutSig) <> 0) then begin
    //----- EMS일 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_EMO_ALL) <> 0 then begin
      sEMsg := 'EMO(s) sensor detected';
      Exit(False);  //TBD:A2CHv3:DIO? (EMO)
    end;
    //------ Stage1 Light Curtain 신호가 없을 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_STAGE1_LIGHT_CURTAIN) = 0 then begin
      sEMsg := 'CH1 Light Curtain1 NOT detected';
      Exit(False);
    end;
    //------ CH1 Door Sensor 경우 신호 나가면 안됨.
    if (wDioInSig and (DefDio.MASK_IN_STAGE1_DOOR1_OPEN or DefDio.MASK_IN_STAGE1_DOOR2_OPEN)) <> 0 then begin
      sEMsg := 'CH1 Door(s) sensor detected';
      Exit(False);
    end;
    //----- EMS일 경우 Reset 하기전에 신호 나가면 안됨.
    if m_bEmsFlag then begin   //TBD:A2CHv3:DIO? (EMS?)
      sEMsg := 'Reset EMO';
      Exit(False);
    end;

    //
    if FIsReadyToTurn1 then begin
      if m_nAutoFlow[DefPocb.JIG_A] = DefDio.IO_AUTO_FLOW_CAMERA then begin
        m_nAutoFlow[DefPocb.JIG_A] := DefDio.IO_AUTO_FLOW_SHUTTER_UP;
      end;
    end;

    m_tTime[DefPocb.JIG_A] := Now;
		{$IFDEF FEATURE_KEEP_SHUTTER_UP}		
    m_bOnShutterUp[DefPocb.JIG_A] := True;
		{$ENDIF}
  end;

  //-------------- Stage.2: Shutter up, Screw-shutter down, Shutter-guide down
  wMaskOutSig := DefDio.MASK_OUT_STAGE2_SHUTTER_UP;
  {$IFDEF HAS_DIO_SCREW_SHUTTER}		
  if Common.SystemInfo.HasDioScrewShutter then wMaskOutSig := wMaskOutSig or MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN; //2022-07-15 A2CHv4_#3(No ScrewShutter)
  {$ENDIF}	
  {$IFDEF SUPPORT_1CG2PANEL}
  wMaskOutSig := wMaskOutSig or DefDio.MASK_OUT_SHUTTER_GUIDE_DOWN;
  {$ENDIF}
  if ((wDioOutSig and wMaskOutSig) <> 0) then begin
    //----- EMS일 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_EMO_ALL) <> 0 then begin
      sEMsg := 'EMO(s) sensor detected';
      Exit(False);  //TBD:A2CHv3:DIO? (EMO)
    end;
    //------ Stage1 Light Curtain 신호가 없을 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_STAGE2_LIGHT_CURTAIN) = 0 then begin
      sEMsg := 'CH2 Light Curtain1 NOT detected';
      Exit(False);
    end;
    //------ CH2 Door Sensor 경우 신호 나가면 안됨.
    if (wDioInSig and (DefDio.MASK_IN_STAGE2_DOOR1_OPEN or DefDio.MASK_IN_STAGE2_DOOR2_OPEN)) <> 0 then begin
      sEMsg := 'CH2 Door(s) sensor detected';
      Exit(False);
    end;
    //----- EMS일 경우 Reset 하기전에 신호 나가면 안됨.
    if m_bEmsFlag then begin   //TBD:A2CHv3:DIO? (EMS?)
      sEMsg := 'Reset EMO';
      Exit(False);
    end;

    if FIsReadyToTurn2 then begin
      if m_nAutoFlow[DefPocb.JIG_B] = DefDio.IO_AUTO_FLOW_CAMERA then begin
        m_nAutoFlow[DefPocb.JIG_B] := DefDio.IO_AUTO_FLOW_SHUTTER_UP;
      end;
    end;

    m_tTime[DefPocb.JIG_B] := Now;
		{$IFDEF FEATURE_KEEP_SHUTTER_UP}		
    m_bOnShutterUp[DefPocb.JIG_B] := True;
		{$ENDIF}
  end;

  Result := bRet;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TDongaDio.CheckIoBeforeMotorOutSig(const wMotorSig: DWORD): Boolean
//
function TDioCtl.CheckIoBeforeMotorOutSig(const wMotorSig: DWORD; out sEMsg: string): Boolean;
var
  wDioInSig, wDioInTarget : UInt64;
  wMotorInSig, wMotorInTarget, wMotorOutTarget, wMotorOutSig : DWORD;
  bRet : Boolean;
begin
  wDioInSig    := m_nDIValue;
//wDioOutSig   := m_nDOValue;
  wMotorInSig  := DongaMotion.m_nMotorDIValue;
  wMotorOutSig := (1 shl wMotorSig);  // !!!
  bRet := True;

  sEMsg := '';

  //-------------- Stage.1: Stage forward & backward
  wMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD or DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD;
  if (wMotorOutSig and wMotorOutTarget) <> 0 then begin
    //----- EMS일 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_EMO_ALL) <> 0 then begin
      sEMsg := 'EMO(s) sensor detected';
      Exit(False);
    end;
    //----- EMS일 경우 Reset 하기전에 신호 나가면 안됨.
    if m_bEmsFlag then begin
      sEMsg := 'Reset EMO'; //TBD:A2CHv3:DIO? (EMS?
      Exit(False);
    end;

    //------ Stage1 Light Curtain 신호가 없을 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_STAGE1_LIGHT_CURTAIN) = 0 then begin
      sEMsg := 'CH1 Light Curtain sensor NOT detected';
      Exit(False);
    end;
    //------ CH1 Door Sensor 경우 신호 나가면 안됨.
    if (wDioInSig and (DefDio.MASK_IN_STAGE1_DOOR1_OPEN or DefDio.MASK_IN_STAGE1_DOOR2_OPEN)) <> 0 then begin
      sEMsg := 'CH1 Door(s) sensor detected';
      Exit(False);
    end;
    //----- EMS일 경우 Reset 하기전에 신호 나가면 안됨.
    if m_bEmsFlag then begin
      sEMsg := 'Reset EMO'; //TBD:A2CHv3:DIO? (EMS?
      Exit(False);
    end;

    // Shutter UP Sig가 없으면 움직이면 안됨.
    if (wDioInSig and DefDio.MASK_IN_STAGE1_SHUTTER_UP) = 0 then begin
      sEMsg := 'CH1 Shutter-UP sensor NOT detected';
      Exit(False);
    end;
    // Shutter Down 신호가 있으면 움직이면 안됨.
    if (wDioInSig and DefDio.MASK_IN_STAGE1_SHUTTER_DOWN) <> 0 then begin
      sEMsg := 'CH1 Shutter-DOWN sensor detected';
      Exit(False);
    end;

    {$IFDEF HAS_DIO_SCREW_SHUTTER}	
    if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
      // ScrewShutter Up 신호가 있으면 움직이면 안됨.
      if (wDioInSig and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_UP) <> 0 then begin
        sEMsg := 'CH1 ScrewShutter-UP sensor detected';
        Exit(False);
      end;
      // ScrewShutter Down Sig가 없으면 움직이면 안됨.
      if (wDioInSig and DefDio.MASK_IN_STAGE1_SCREW_SHUTTER_DOWN) = 0 then begin
        sEMsg := 'CH1 ScrewShutter-DOWN sensor NOT detected';
        Exit(False);
      end;
    end;
		{$ENDIF}

    {$IFDEF SUPPORT_1CG2PANEL}
    if not Common.SystemInfo.UseAssyPOCB then begin
      // ShutterGuide Up 신호가 없으면 움직이면 안됨.
      if (wDioInSig and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0 then begin
        sEMsg := 'ShutterGuide-UP sensor NOT detected';
        Exit(False);
      end;
      // ShutterGuide Down Sig가 있으면 움직이면 안됨.
      if (wDioInSig and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) <> 0 then begin
        sEMsg := 'ShutterGuide-DOWN sensor detected';
        Exit(False);
      end;
    end;

  //if (DongaMotion.Motion[DefPocb.CH_1].m_MotionStatus.nSyncStatus <> SyncNone) then begin
    if (wDioInSig and DefDio.MASK_IN_STAGE1_JIG_INTERLOCK) <> 0 then begin
      //
      if not (((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_UP1) <> 0) and ((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_UP2) <> 0) and
              ((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_DOWN1) = 0) and ((m_nDIValue and DefDio.MASK_IN_CAMZONE_PARTITION_DOWN2) = 0)) then begin
      	sEMsg := 'AssyJig Detected and CamZone Partition is NOT UP';
      	Exit(False);
      end;

    	// CH2 Shutter UP Sig가 없으면 움직이면 안됨.
    	if (wDioInSig and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0 then begin
      	sEMsg := 'CH2 Shutter-UP sensor NOT detected';
      	Exit(False);
    	end;

    	// CH2 Shutter UP Sig가 없으면 움직이면 안됨.
    	if (wDioInSig and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0 then begin
      	sEMsg := 'CH2 Shutter-UP sensor NOT detected';
      	Exit(False);
    	end;
   	 	// CH2 Shutter Down 신호가 있으면 움직이면 안됨.
      if (wDioInSig and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) <> 0 then begin
        sEMsg := 'CH2 Shutter-DOWN sensor detected';
        Exit(False);
      end;

      {$IFDEF HAS_DIO_SCREW_SHUTTER}
      if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
        // CH2 ScrewShutter Up 신호가 있으면 움직이면 안됨.
        if (wDioInSig and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) <> 0 then begin
          sEMsg := 'CH2 ScrewShutter-UP sensor detected';
          Exit(False);
        end;
        //CH2  ScrewShutter Down Sig가 없으면 움직이면 안됨.
        if (wDioInSig and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) = 0 then begin
          sEMsg := 'CH2 ScrewShutter-DOWN sensor NOT detected';
          Exit(False);
        end;
      end;
			{$ENDIF}

      // ShutterGuide Up 신호가 있으면 움직이면 안됨.
      if (wDioInSig and DefDio.MASK_IN_SHUTTER_GUIDE_UP) <> 0 then begin
        sEMsg := 'ShutterGuide-UP sensor detected';
        Exit(False);
      end;
      // ShutterGuide Down Sig가 없으면 움직이면 안됨.
      if (wDioInSig and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) = 0 then begin
        sEMsg := 'ShutterGuide-DOWN sensor NOT detected';
        Exit(False);
      end;
    end;
    {$ENDIF} //SUPPORT_1CG2PANEL

    {$IFDEF HAS_DIO_PINBLOCK}
    if Common.SystemInfo.UsePinBlock then begin
      // Pinblock Open Sig가 있으면 움직이면 안됨.
      if (wDioInSig and DefDio.MASK_IN_STAGE1_PINBLOCK_CLOSE) = 0 then begin
        sEMsg := 'CH1 PinBlock sensor NOT detected - Check PinBlock';
        Exit(False);
      end;
    end;
    {$ENDIF}

    // front stage sig가 있을때 Front Signal이 동작 하면 안됨.
    wMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD;
    if (wMotorOutSig and wMotorOutTarget) <> 0 then begin
      wMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD;
      if (wMotorInSig and wMotorInTarget) <> 0 then
      begin {CodeSite.Send('BeforeMotorOutSig:Ch1:FWD|BWD:EXIT(AlreadyFWD)');} Exit(False); end;
    end;
    // back stage sig가 있을때 back Signal이 동작 하면 안됨.
    wMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD;
    if (wMotorOutSig and wMotorOutTarget) <> 0 then begin
      wMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE1_BACKWARD;
      if (wMotorInSig and wMotorInTarget) <> 0 then
      begin {CodeSite.Send('BeforeMotorOutSig:Ch1:FWD|BWD:EXIT(AlreadyBWD)');} Exit(False); end;
    end;
  end;

  //-------------- Stage.2: Stage forward & backward
  wMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD or DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD;
  if (wMotorOutSig and wMotorOutTarget) <> 0 then begin
    //----- EMS일 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_EMO_ALL) <> 0 then begin
      sEMsg := 'EMO(s) sensor detected';
      Exit(False);
    end;
    //------ Stage2 Light Curtain 신호가 없을 경우 신호 나가면 안됨.
    if (wDioInSig and DefDio.MASK_IN_STAGE2_LIGHT_CURTAIN) = 0 then begin
      sEMsg := 'CH2 Light Curtain sensor NOT detected';
      Exit(False);
    end;
    //------ CH1 Door Sensor 경우 신호 나가면 안됨.
    if (wDioInSig and (DefDio.MASK_IN_STAGE2_DOOR1_OPEN or DefDio.MASK_IN_STAGE2_DOOR2_OPEN)) <> 0 then begin
      sEMsg := 'CH2 Door(s) sensor detected';
      Exit(False);
    end;
    //----- EMS일 경우 Reset 하기전에 신호 나가면 안됨.
    if m_bEmsFlag then begin
      sEMsg := 'Reset EMO'; //TBD:A2CHv3:DIO? (EMS?
      Exit(False);
    end;

    // Shutter UP Sig가 없으면 움직이면 안됨.
    if (wDioInSig and DefDio.MASK_IN_STAGE2_SHUTTER_UP) = 0 then begin
      sEMsg := 'CH2 Shutter-UP sensor NOT detected';
      Exit(False);
    end;
    // Shutter Down 신호가 있으면 움직이면 안됨.
    if (wDioInSig and DefDio.MASK_IN_STAGE2_SHUTTER_DOWN) <> 0 then begin
      sEMsg := 'CH2 Shutter-DOWN sensor detected';
      Exit(False);
    end;

    {$IFDEF HAS_DIO_SCREW_SHUTTER}
    if Common.SystemInfo.HasDioScrewShutter then begin //2022-07-15 A2CHv4_#3(No ScrewShutter)
      // ScrewShutter Up 신호가 있으면 움직이면 안됨.
      if (wDioInSig and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_UP) <> 0 then begin
        sEMsg := 'CH2 ScrewShutter-UP sensor detected';
        Exit(False);
      end;
      // ScrewShutter Down Sig가 없으면 움직이면 안됨.
      if (wDioInSig and DefDio.MASK_IN_STAGE2_SCREW_SHUTTER_DOWN) = 0 then begin
        sEMsg := 'CH2 ScrewShutter-DOWN sensor NOT detected';
        Exit(False);
      end;
    end;
		{$ENDIF}		

    {$IFDEF SUPPORT_1CG2PANEL}
    // ShutterGuide Up 신호가 없으면 움직이면 안됨.
    if (wDioInSig and DefDio.MASK_IN_SHUTTER_GUIDE_UP) = 0 then begin  //TBD:A2CHv3:DIO? (ASSY?)
      sEMsg := 'ShutterGuide-UP sensor NOT detected';
      Exit(False);
    end;
    // ShutterGuide Down Sig가 있으면 움직이면 안됨.
    if (wDioInSig and DefDio.MASK_IN_SHUTTER_GUIDE_DOWN) <> 0 then begin   //TBD:A2CHv3:DIO? (ASSY?)
      sEMsg := 'ShutterGuide-DOWN sensor detected';
      Exit(False);
    end;

    if Common.SystemInfo.UseAssyPOCB then begin
      // SYNC-MODE인 경우, CH1에서만 FWD/BWD
			if (DongaMotion.Motion[DefPocb.CH_1].m_MotionStatus.nSyncStatus <> SyncNone) then begin
        sEMsg := 'CH2 Y-Axis is on SYNC(Slave)';
        Exit(False);
      end;
		end;
    {$ENDIF} //SUPPORT_1CG2PANEL

    {$IFDEF HAS_DIO_PINBLOCK}
    if Common.SystemInfo.UsePinBlock then begin
      // Pinblock Open Sig가 있으면 움직이면 안됨.
      if (wDioInSig and DefDio.MASK_IN_STAGE2_PINBLOCK_CLOSE) = 0 then begin
        sEMsg := 'CH2 PinBlock sensor NOT detected - Check PinBlock';
        Exit(False);
      end;
    end;
    {$ENDIF}

    // front stage sig가 있을때 Front Signal이 동작 하면 안됨.
    wMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD;
    if (wMotorOutSig and wMotorOutTarget) <> 0 then begin
      wMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE2_FORWARD;
      if (wMotorInSig and wMotorInTarget) <> 0 then begin sEMsg := 'CH2 AlreadyFWD'; Exit(False); end;
    end;
    // back stage sig가 있을때 back Signal이 동작 하면 안됨.
    wMotorOutTarget := DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD;
    if (wMotorOutSig and wMotorOutTarget) <> 0 then begin
      wMotorInTarget := DefMotion.MASK_IN_MOTOR_STAGE2_BACKWARD;
      if (wMotorInSig and wMotorInTarget) <> 0 then begin sEMsg := 'CH2 AlreadyBWD'; Exit(False); end;
    end;
  end;
  //
  Result := bRet;
end;
//##############################################################################################
{$ENDIF}                 //#####################################################################
//##############################################################################################

{$IFDEF HAS_DIO_IN64}
function TDioCtl.SetDio(lwSignal: UInt64; bAllSet: Boolean = False): Integer;
{$ELSE}
function TDioCtl.SetDio(lwSignal: DWORD; bAllSet: Boolean = False): Integer;
{$ENDIF}
var
  nRet, i : Integer;
{$IFDEF HAS_DIO_IN64}
  lwTemp  : UInt64;   //A2CH: DWORD, F2CH:UInt64
{$ELSE}
  lwTemp  : DWORD;
{$ENDIF}
  sEMsg   : string;
begin
  // Logic 추가.
  //Door Down Signal 이거나 Door Up Signal이 없을때, switch Ready와 stage front, back 신호 주지 말자.
  nRet := 0; //2019-02-13
  if not bAllSet then begin
{$IFDEF HAS_DIO_IN64}
    lwTemp := UInt64(1) shl lwSignal;
{$ELSE}
    lwTemp := 1 shl lwSignal;
{$ENDIF}
    if not CheckIoBeforeDioOutSig(lwTemp,   sEMsg) then begin
      CodeSite.Send('<DIO> SetDio:CheckIoBeforeDioOutSig('+IntToStr(lwSignal)+': '+sEMsg);
      Exit(2);
    end;
  end
  else begin
    if not CheckIoBeforeDioOutSig(lwSignal, sEMsg) then Exit(2);
  end;

  if bAllSet then begin
    m_nDOValue := lwSignal;
{$IFDEF HAS_DIO_IN64}
    for i := 0 to MAX_DIO_OUT do begin  //F2CH: Pred(DefDio.MAX_DIO_CNT) -> MAX_DIO_OUT
      lwTemp := (UInt64(1) shl i);    // For 64 bit operation on 32bit build, constant value should be cast to UInt64 !!!
{$ELSE}
    for i := 0 to Pred(DefDio.MAX_DIO_CNT) do begin
      lwTemp := 1 shl i;
{$ENDIF}
      if (lwTemp and lwSignal) <> 0 then begin
{$IFDEF SIMULATOR_DIO}
        if not m_nSetDio[i] then SimulatorDioOutEvent(i, True{bOn}); //0->1
{$ENDIF}
        m_nSetDio[i] := True;
        {$IFDEF FEATURE_KEEP_SHUTTER_UP}
        if Common.SystemInfo.KeepDioShutterUp then begin
          if (i = DefDio.OUT_STAGE1_SHUTTER_DOWN)      then m_nSetDio[DefDio.OUT_STAGE1_SHUTTER_UP] := False
          else if (i = DefDio.OUT_STAGE2_SHUTTER_DOWN) then m_nSetDio[DefDio.OUT_STAGE2_SHUTTER_UP] := False;
        end;
        {$ENDIF}
      end
      else begin
{$IFDEF SIMULATOR_DIO}
        if m_nSetDio[i] then SimulatorDioOutEvent(i, False{bOn}); //0->1
{$ENDIF}
        m_nSetDio[i] := False;
      end;
    end;
  end
  else begin
    if ((m_nDOValue shr lwSignal) and $01) > 0 then begin
{$IFDEF HAS_DIO_IN64}
      m_nDOValue := m_nDOValue - (UInt64(1) shl lwSignal);
{$ELSE}
      m_nDOValue := m_nDOValue - (1 shl lwSignal);
{$ENDIF}
{$IFDEF SIMULATOR_DIO}
      if m_nSetDio[lwSignal] then SimulatorDioOutEvent(lwSignal, False{bOn});
{$ENDIF}
      m_nSetDio[lwSignal] := False;
      nRet :=0;
    end
    else begin
{$IFDEF HAS_DIO_IN64}
      m_nDOValue := m_nDOValue + (UInt64(1) shl lwSignal);
{$ELSE}
      m_nDOValue := m_nDOValue + (1 shl lwSignal);
{$ENDIF}
{$IFDEF SIMULATOR_DIO}
      if not m_nSetDio[lwSignal] then SimulatorDioOutEvent(lwSignal, True{bOn});
{$ENDIF}
      m_nSetDio[lwSignal] := True;
      {$IFDEF FEATURE_KEEP_SHUTTER_UP}
        if Common.SystemInfo.KeepDioShutterUp then begin
          if (lwSignal = DefDio.OUT_STAGE1_SHUTTER_DOWN)      then m_nSetDio[DefDio.OUT_STAGE1_SHUTTER_UP] := False
          else if (lwSignal = DefDio.OUT_STAGE2_SHUTTER_DOWN) then m_nSetDio[DefDio.OUT_STAGE2_SHUTTER_UP] := False;
        end;
      {$ENDIF}
			{$IFDEF FEATURE_DIO_LOG_SHUTTER} 
      if (lwSignal = DefDio.OUT_STAGE1_SHUTTER_DOWN) or (lwSignal = DefDio.OUT_STAGE1_SHUTTER_UP) then //2023-05-02 DioLog:CHx:SHUTTER:UP/DOWN
        m_tShutterUpDownOut[DefPocb.JIG_A] := Now
      else if (lwSignal = DefDio.OUT_STAGE2_SHUTTER_DOWN) or (lwSignal = DefDio.OUT_STAGE2_SHUTTER_UP) then
        m_tShutterUpDownOut[DefPocb.JIG_B] := Now;
			{$ENDIF}
      nRet :=1;
    end;
  end;

{$IFDEF SIMULATOR_DIO}
  //TBD:SIMULATOR_DIO?
  m_nDIOErr := 0;
{$ELSE}
{$IF Defined(USE_DIO_AXT)}      //A2CH
  if (not DioAxt.WriteDioOut32(0{nModuleDioOutOffset},m_nDOValue)) then begin
    m_nDIOErr := 1;
  end;
{$ELSEIF Defined(USE_DIO_AXD)}  //F2CH|A2CHv2
  if (not DioAxd.WriteDioOut64(m_nDOValue)) then begin
    m_nDIOErr := 1;
  end;
{$ELSEIF Defined(USE_DIO_ADLINK)}
  m_nDIOErr := DO_WritePort(m_nCardId, DefDio.DOPORT, m_nDOValue);
{$IFEND}
{$ENDIF}
  if m_nDIOErr > 0 then Result := 2
  else begin
    InDioStatus(m_nGetDio,m_nSetDio);
    if FMaintInDioUse then begin
      if Assigned(MaintInDioStatus) then MaintInDioStatus(m_nGetDio, m_nSetDio);
    end;
    Result := nRet;
  end;
end;

{$IFDEF HAS_ROBOT_CAM_Z}
//##############################################################################################
//
//  <<< TM5 HW Manual - Table 5: Robot Stick Basic Functions >>>
//        Items            |           Basic Function
//  -----------------------+-------------------------------------------------------
//  Emergency Switch       | Default emergency button for the robot
//  Power Button           | Power initiation (single press)/ Shutdown (long press)
//  -----------------------+-------------------------------------------------------
//  M/A Mode Switch Button | Toggle Manual/Auto Mode (single press). See Safety Manual for details.
//  Play/Pause Button      | Play/Pause Project (single press)
//  Stop Button            | Press this button to stop any project.
//  +/- Button             | Adjust project speed (single press) under Manual Trial Run Mode.
//                         | (See Safety Manual for details.)
//  -----------------------+-------------------------------------------------------
//  Power Indicator        | This indicator shows the robot's power status.
//                         | (Not on: Switched off, Flashing: Booting, Constant: Startup completed)
//  Mode Indicator Lights  | One is Manual Mode, the other one is Auto Mode. They show the robot's current operating mode.
//                         | Once boot up is complete only one will always be on.
//  Speed Indicator        | Display the current project speed.
//                         | Lit in green for 5% and in blue for 10% such as 4 in blue and 1 in green equals to 45%.
//  QR Code Label          | The content of the SSID is also the robot's name in TCP/IP network
//
//  <<< TM5 HW Manual - Table 6: Robot Stick Advanced Functions >>>
//        Items            |           Advanced Function
//  -----------------------+-------------------------------------------------------
//  Emergency Switch       | - Press and release, and then wait for 3 seconds to enter Safe Start up Mode.
//                         | - Press and release to enter Safe Start up Mode while booting.
//  -----------------------+-------------------------------------------------------
//  Play/Pause Button      | Play/pause visual calibration operation (single press)
//  Stop Button            | Stop visual calibration operation (single press)
//  +/- Button             | - Hold to jog the robot at the HMI robot controller page (Hold to Run).
//                         | (See Safety Manual for details.)
//                         | - Lock/ Unlock: press and hold both the + button and the - button until the mode indicator light flashes,
//                         | then follow the sequence "-, +, -, -, +" to lock/unlock the Robot Stick (except the Power Button)
//
procedure TDioCtl.RobotDioControl(nRobot: Integer; nRobotDioCtlType: enumRobotDioCtlType); //TBD:A2CHV3:ROBOT?
begin
  m_IsOnDioRobotCtl[nRobot] := True;
  //
  Common.ThreadTask(procedure var nDioNo, nDioMask : UInt64; sDebug : string;
  begin
    case nRobotDioCtlType of
      MakePlay, MakePause: begin  // Pause <--> Play
        if nRobot = DefRobot.ROBOT_CH1 then begin nDioNo := DefDio.OUT_STAGE1_ROBOT_PAUSE; nDioMask := DefDio.MASK_OUT_STAGE1_ROBOT_PAUSE; end
        else                                begin nDioNo := DefDio.OUT_STAGE2_ROBOT_PAUSE; nDioMask := DefDio.MASK_OUT_STAGE2_ROBOT_PAUSE; end;
        if ((m_nDOValue and nDioMask) <> 0) then begin
          SetDio(nDioNo,False{bAllSet});
          Common.Delay(2000); //TBD:A2CHV3:ROBOT?
        end;
        SetDio(nDioNo,False{bAllSet});
        Common.Delay(1000);  // 1 sec  //TBD:A2CHV3:ROBOT?
        SetDio(nDioNo,False{bAllSet});
      end;
      MakeAutoMode: begin     // Manual -> Auto
        //TBD:A2CHv3:ROBOT (RobotDioControl:Manual->Auto)
        CodeSite.Send(sDebug+': ....TBD(Manual->Auto)');
      end;
      MakeManualMode: begin   // Auto -> Manual//TBD:A2CHv3:ROBOT (RobotDioControl:Auto->Manual)
        //TBD:A2CHv3:ROBOT (RobotDioControl:Auto->Manual)
        CodeSite.Send(sDebug+': ....TBD(Auto->Manual)');
      end;
    end;
    m_IsOnDioRobotCtl[nRobot] := False;
  end);
end;
{$ENDIF} // HAS_ROBOT_CAM_Z

//##############################################################################################
//

procedure TDioCtl.SendMainGuiDisplay(nGuiMode, nCH, nParam: Integer; sMsg: string = '');
var
  ccd : TCopyDataStruct;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<DioCtl> SendMainGuiDisplay: nParam('+IntToStr(nParam)+')',DefPocb.DEBUG_LEVEL_INFO);
  FMainGuiDioData.MsgType := DefPocb.MSG_TYPE_DIO;
  FMainGuiDioData.Channel := nCH;
  FMainGuiDioData.Mode    := nGuiMode;
  FMainGuiDioData.Param   := nParam;
  FMainGuiDioData.Msg     := sMsg;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(FMainGuiDioData);
  ccd.lpData      := @FMainGuiDioData;
  SendMessage(m_hMain,WM_COPYDATA,0, LongInt(@ccd));
end;

procedure TDioCtl.SendTestGuiDisplay(nGuiMode, nCH: Integer; sMsg: string = ''; nParam: Integer = 0; nParam2: Integer = 0);
var
  ccd : TCopyDataStruct;
  TestGuiDioData : RTestGuiDioData;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<DioCtl> SendTestGuiDisplay: nParam('+IntToStr(nParam)+')',DefPocb.DEBUG_LEVEL_INFO);
  TestGuiDioData.MsgType := DefPocb.MSG_TYPE_DIO;
  TestGuiDioData.Channel := nCH;
  TestGuiDioData.Mode    := nGuiMode;
  TestGuiDioData.Msg     := sMsg;
  TestGuiDioData.Param   := nParam;
  TestGuiDioData.Param2  := nParam2;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(TestGuiDioData);
  ccd.lpData      := @TestGuiDioData;
  SendMessage(m_hTest[nCH],WM_COPYDATA,0, LongInt(@ccd));
end;
end.
