unit MotionCtlAxm;
{
Mainter				              MotionCtl/DioCtl	MotionCtlAxt		      AXT|AXM
btnMotorMoveAbsClick  		  -> MoveABS 		    -> MoveABS(aPos)	    ->
btnMotorMoveDecClick 		    -> MoveINC 		    -> MoveINC(rPos)	    ->
btnMotorMoveIncClick  		  -> MoveINC 		    -> MoveINC(-rPos)	    ->
btnMotorMoveJogDecClick     -> MoveJOG        -> MoveJOG?           ->
btnMotoMoverJogIncClick     -> MoveJOG        -> MoveJOG?           ->
btnMotorMoveLimitMinusClick	-> MoveLIMIT 		  -> MoveLIMIT(-)       ->
btnMotorMoveLimitPlusClick 	-> MoveLIMIT  		-> MoveLIMIT(+)       ->
btnMotorOriginClick       	-> MoveHOME		    -> MoveHOME           ->
btnMotorStopClick      		  -> MoveSTOP 		  -> MoveSTOP           ->
btnMotorStopEmsClick		    -> MoveSTOP(EMS)	-> MoveSTOP(EMS)	    ->
btnMotorServoOnClick		    -> ServoOnOff		  -> ServoOnOff(on)     ->
btnMotorServoOffClick		    -> ServoOnOff		  -> ServoOnOff(Off)    ->

btnStageForwardCh1Click		  -> MoveFORWARD		-> MoveABS(ModelPos)  ->
btnStageForwardCh1Click		  -> MoveFORWARD		-> MoveABS(ModelPos)  ->
btnStageBackwardCh1Click	  -> MoveBACKWARD		-> MoveABS(0)         ->
btnStageBackwardCh2Click	  -> MoveBACKWARD		-> MoveABS(0          ->
}
interface
{$I Common.inc}

uses
  Winapi.Windows, System.SysUtils,  System.Classes, Vcl.ExtCtrls,
  AXL, AXM, AXHS, AxDev, // 3rd-party Classes
  DefPocb, DefMotion, CommonClass, CodeSiteLogging;

//const

type

 {AxmApiStatusRec = record
    bAxmInitialized       : Boolean;
    bAxmDeviceOpened      : Boolean;
    bAxmCFS20Initialized  : Boolean;
    bAxmConnected         : Boolean;  //TBD?
    sDeviceVersion        : string;   //TBD?
    sErrLibApi            : string;
  end; }

  TMotionAxm = class(TObject)
    private
			m_hMain       		: HWND;
    public
			m_nMotionID   		: Integer;	// A2CH: Axt(0~3), Ezi(4~5)
			m_nMotionDev   		: Integer;	// A2CH: Axt, EziMLPE
      m_nCh         		: Integer;	// A2CH: ch1~ch2
			m_nAxisType   		: Integer;	// A2CH: Z-axis, Y-axis, Focus
			m_nMotorNo   			: Integer;	// A2CH: nMotorNo(common) = nAxisNo(Axt) = nBdNo(Ezi)
			m_nAxisNo    			: SmallInt;	// A2CH: 'nAxisNo' for Axt(0~3), 'nBdNo' for Ezi(0~1)
			m_nBdNo    				: Integer;	// A2CH: 'nAxisNo' for Axt(0~3), 'nBdNo' for Ezi(0~1)
      //
      m_bConnected      : Boolean;  //TBD???
      m_bServoOn        : Boolean;  //TBD??
      //
    //m_AxmApiStatus    : AxmApiStatusRec;
      m_sErrLibApi            : string;
      m_bAxmInitialized       : Boolean;
    //m_bAxmDeviceOpened      : Boolean;  //NOT-USED
    //m_bAxmConnected         : Boolean;  //NOT-USED
      m_sDeviceVersion        : string;   //TBD?
      {$IFDEF SUPPORT_1CG2PANEL}
      m_bGantryMode           : Boolean;
      {$ENDIF}
      {$IFDEF SIMULATOR_MOTION}
      m_nSimSyncStatus     : enumMotionSyncStatus; //A2CHv3:MOTION:SYNC-MOVE
      m_nSimSyncSlaveAxis  : LongInt;              //A2CHv3:MOTION:SYNC-MOVE
      m_dSimSyncSlaveRatio : Double;               //A2CHv3:MOTION:SYNC-MOVE
      {$ENDIF}
      //
      constructor Create(hMain: THandle; nMotionID: Integer; nCh: Integer; nAxisType: Integer; nMotorNo: Integer); virtual;
      destructor Destroy; override;
			//---------------------- TMotionAxm: Connect/Close/MotionInit
			function Connect: Integer;
			//TBD? procedure Close;
			procedure CloseAxm;
			function MotionInit: Integer;
			function MotionReset: Integer;
			function ServoOnOff(bIsOn: Boolean): Integer;
			//---------------------- TMotionAxm: Move Start/Stop
			function MoveSTOP(MotionParam: RMotionParam; bIsEMS: Boolean = False): Integer;
			//---------------------- TMotionAxm: Move ABS/INC/JOG/LIMIT/HOME
      function MoveABS(MotionParam: RMotionParam; dAbsPos: Double; bSyncMaster: Boolean): Integer;      //A2CHv3:MOTION:SYNC-MOVE
      function MoveINC(MotionParam: RMotionParam; dIncDecPos: Double; bSyncMaster: Boolean): Integer;   //A2CHv3:MOTION:SYNC-MOVE
			function MoveJOG(MotionParam: RMotionParam; bIsPlus: Boolean; bSyncMaster: Boolean): Integer;     //A2CHv3:MOTION:SYNC-MOVE
      function MoveLIMIT(MotionParam: RMotionParam; bIsPlus: Boolean; bSyncMaster: Boolean): Integer;   //A2CHv3:MOTION:SYNC-MOVE
			function MoveHOME(MotionParam: RMotionParam; bUseSoftLimitMinus: Boolean): Integer;               //A2CHv3:MOTION
      {$IFDEF SUPPORT_1CG2PANEL}
      function MoveHOMEGantry(MotionParam: RMotionParam; bUseSoftLimitMinus: Boolean): Integer;         //A2CHv3:MOTION:SYNC-MOVE
      {$ENDIF}
			//---------------------- TMotionAxm: Get/Set
      function GetMotionStatus(var MotionStatus: MotionStatusRec): Boolean;
			function GetActPos(var dActPos: Double): Integer;
			function GetCmdPos(var dCmdPos: Double): Integer;
			function SetActPos(dActPos: Double): Integer;
			function SetCmdPos(dCmdPos: Double): Integer;
		//function IsMotionHome: Boolean;	//TBD?
			function IsMotionMoving: Boolean;
      function IsMotionAlarmOn: Boolean;
      //---------------------- TMotionAxm: SyncMode
      {$IFDEF SUPPORT_1CG2PANEL}			
      function SetEGearLinkMode(nMasterAxis, nSlaveAxis: LongInt; dSlaveRatio: Double): Integer;  //A2CHv3:MOTION:SYNC-MOVE
      function ResetEGearLinkMode(nMasterAxis: LongInt): Integer;                                 //A2CHv3:MOTION:SYNC-MOVE
      function GetEGearLinkMode(nMasterAxis: LongInt; var nSlaveAxis: LongInt; var dSlaveRatio: Double): Integer;  //A2CHv3:MOTION:SYNC-MOVE
      {$ENDIF}
  end;

implementation

//##############################################################################
//
{ TMotionAxm }
//
//##############################################################################

//******************************************************************************
// procedure/function: TMotorAxm: Create/Destroy/Init
//		- constructor TMotorAxm.Create(hMain: THandle; nMotionID: Integer; nCh: Integer; nAxisType: Integer; nMotorNo: Integer)
//		- destructor TMotorAxm.Destroy	//TBD?
//******************************************************************************

//------------------------------------------------------------------------------
constructor TMotionAxm.Create(hMain: THandle; nMotionID: Integer; nCh: Integer; nAxisType: Integer; nMotorNo: Integer);
begin
  m_hMain := hMain;
  //-------------------------- Motion Variables
	m_nMotionID 	:= nMotionID;
	m_nMotionDev 	:= DefMotion.MOTION_DEV_AxtMC;
	m_nCh 				:= nCh;
	m_nAxisType 	:= nAxisType;
	m_nMotorNo 		:= nMotorNo;
	m_nAxisNo 		:= nMotorNo;
	m_nBdNo 			:= nMotorNo;
  //-------------------------- Motion Parameters
  {$IFDEF SUPPORT_1CG2PANEL}
  m_bGantryMode := False;
  {$ENDIF}
  //-------------------------- TBD?
end;

//------------------------------------------------------------------------------
destructor TMotionAxm.Destroy;	//TBD?
begin
  //TBD? (어떤 제어가? 어떤 조건에서?)
  if m_bConnected then begin  //TBD?
    // TBD?
    m_bConnected := False;
  end;

  inherited;
end;

//******************************************************************************
// procedure/function: TMotionAxm: Connect/Close/MotionInit
//		- function TMotorAxm.Connect: Integer;
//    -	//TBD? procedure TMotorAxm.Close;
//		- procedure TMotorAxm.CloseAxt;
//		- function TMotorAxm.MotionInit: Integer;
//		- function TMotorAxm.MotionReset: Integer;	//TBD?
//		- function TMotorAxm.ServoOnOff(bIsOn: Boolean): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionAxm.Connect: Integer;
var
	nRet 			: DWORD;
	nErrCode 	: Integer;
	//
//sDebug 		: String;
	lPulse 		: LongInt ;
	dAxisCounts, dwBoardNo, dwModulePos, dwStatus, dwProfile, dwModuleID, dwAbsRel : DWORD;
	dUnit, dMinVelocity, dInitpos, dInitvel, dInitaccel, dInitdecel : Double;
begin
	m_sErrLibApi := '';
	nErrCode 		 := DefPocb.ERR_MOTION_CONNECT;
	//-------------------------- 통합라이브러리 초기화
{$IFNDEF SIMULATOR_MOTION}
  if (not AxlIsOpened) then begin
		nRet := AxlOpen(7{nIrqNo});
    if nRet <> AXHS.AXT_RT_SUCCESS then begin
			m_bAxmInitialized := False;
			m_sErrLibApi := 'AxlOpen:Return='+IntToStr(nRet);
			Exit(nErrCode);
    end;
  end;
	nRet := AxmInfoIsMotionModule(@dwStatus);
  if nRet <> AXHS.AXT_RT_SUCCESS then begin
		m_bAxmInitialized := False;
		m_sErrLibApi := 'AxmInfoIsMotionModule:Return='+IntToStr(nRet);
		Exit(nErrCode);
  end
  else begin
    if dwStatus <> AXHS.STATUS_EXIST then begin
			m_bAxmInitialized := False;
			m_sErrLibApi := 'AxmInfoIsMotionModule:Status='+IntToStr(nRet);
			Exit(nErrCode);
    end;
  end;
{$ENDIF}
	m_bAxmInitialized := True;

	//-------------------------- Only for intial parameter information
{$IFNDEF SIMULATOR_MOTION}
  AxmInfoGetAxisCount(@dAxisCounts);
//for nAxisNo := 0 to dAxisCounts-1 do begin
	//AxmInfoGetAxis(nAxisNo, NIL, NIL, @dwModuleID);
	//CodeSite.Send('<MOTION> AxmInfoGetAxis(AxisNo:'+IntToStr(nAxisNo)+'): ModuleID='+IntToStr(dwModuleID));
		AxmInfoGetAxis(m_nAxisNo, @dwBoardNo, @dwModulePos, @dwModuleID);
		CodeSite.Send('<MOTION> AxmInfoGetAxis(AxisNo:'+IntToStr(m_nAxisNo)+'): BoardNo='+IntToStr(dwBoardNo)+', ModulePos='+IntToStr(dwModulePos)+', ModuleID='+IntToStr(dwModuleID));
		//
		lPulse := 1; dUnit := 1.0; dMinVelocity := 1.0; dInitpos := 1.0; dInitvel := 1.0; dInitaccel := 1.0; dInitdecel := 1.0;
		AxmMotGetParaLoad(m_nAxisNo, @dInitpos ,@dInitvel, @dInitaccel, @dInitdecel);
		CodeSite.Send('<MOTION> AxmMotGetParaLoad(AxisNo:'+IntToStr(m_nAxisNo)+'): initPos='+FormatFloat('0.##0',dInitpos)+', initVel='+FormatFloat('0.##0', dInitvel)+', initAccel='+FormatFloat('0.##0', dInitaccel)+', initDecel='+FormatFloat('0.##0',dInitdecel));
		AxmMotGetMoveUnitPerPulse(m_nAxisNo, @dUnit , @lPulse);
		if lPulse <> 0 then
			CodeSite.Send('<MOTION> AxmMotGetMoveUnitPerPulse(AxisNo:'+IntToStr(m_nAxisNo)+'): unit='+FormatFloat('0.####0', dUnit)+', pulse='+Format('%d',[lPulse]))
		else
			CodeSite.Send('<MOTION> AxmMotGetMoveUnitPerPulse(AxisNo:'+IntToStr(m_nAxisNo)+'): unit='+FormatFloat('0.####0', dUnit)+', pulse='+Format('%d',[lPulse]) +' unit/pulse='+FormatFloat('0.#####0', dUnit/lPulse));
		AxmMotGetMinVel(m_nAxisNo, @dMinVelocity);
		CodeSite.Send('<MOTION> AxmMotGetMinVel(AxisNo:'+IntToStr(m_nAxisNo)+'): minVel='+FormatFloat('0.####0', dMinVelocity));
		//
 		AxmMotGetProfileMode(m_nAxisNo, @dwProfile);
		CodeSite.Send('<MOTION> AxmMotGetProfileMode(AxisNo:'+IntToStr(m_nAxisNo)+'): profile='+IntToStr(dwProfile));
	//CodeSite.Send('<MOTION>    Profile    0   1   2   3   4');
	//CodeSite.Send('<MOTION>       SCurve  -   -   Y   Y   Y');
	//CodeSite.Send('<MOTION>       Decel   -   Y   -   -   Y');
	//CodeSite.Send('<MOTION>       Asym    -   Y   -   -   Y');
	//CodeSite.Send('<MOTION> 0: symmetry Trapezode, 1: asymmetric Trapezode, 2: symmetry Quasi-S Curve, 3:symmetry S Curve, 4:asymmetric S Curve');
		AxmMotGetAbsRelMode(m_nAxisNo, @dwAbsRel);
		CodeSite.Send('<MOTION> AxmMotGetAbsRelMode(AxisNo:'+IntToStr(m_nAxisNo)+'): AbsRelMode='+IntToStr(dwAbsRel)+'(0=Abs,1=Rel)');
		//
	//AxmSignalGetLimit(m_nAxisNo, @dwStopMode, @dwPositiveLevel, @dwNegativeLevel);
	//AxmSignalGetServoAlarm(m_nAxisNo, @dwAlarmLevel);
	//AxmSignalGetInpos(m_nAxisNo, @dwInposLevel);
	//AxmSignalGetStop(m_nAxisNo, @dwStopMode, @dwReadEmg);
	//AxmLinkGetMode(AXIS_EVN(m_nAxisNo), nil, @dGearRatio);
	//AxmGantryGetEnable(m_nAxisNo, @upSlHomeUse, nil, nil, nil);
//end;
{$ENDIF}

	//-------------------------- Board 초기화 파일 Load	//TBD?
	//-------------------------- AXIS 개별에 대한
	m_sDeviceVersion := '';	// Clear	//TBD?
	m_bConnected     := True;

	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
procedure TMotionAxm.CloseAxm;
var
	nAxisNo : Integer;
begin
  //-------------------------- 2019-02-26
	AxmMoveEStop(m_nAxisNo);
	AxmSignalWriteOutputBit(m_nAxisNo, 0, 0);
  //-------------------------- 통합라이브러리 사용을 종료
	AxlClose;
  //--------------------------
	m_bAxmInitialized  := False;
  m_bConnected := False
end;

//------------------------------------------------------------------------------
function TMotionAxm.MotionInit: Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
  sFunc, sTemp : string;
begin
  sFunc := '<MOTION> '+IntToStr(m_nMotionID)+': MotionInit: ';
  CodeSite.Send(sFunc+'...START');
  //
	m_sErrLibApi := '';
	nErrCode 		 := DefPocb.ERR_MOTION_INIT;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Servo On

  Sleep(100);
	nRet := ServoOnOff(True);
  if (nRet <> DefPocb.ERR_OK) then begin
    Exit(nErrCode);
  end;
  m_bServoOn := True;
  Sleep(500);
	//-------------------------- 서보 알람 입력 신호의 Active Level을 설정
{$IFDEF SIMULATOR_MOTION}
{$ELSE}	
  nRet := AxmSignalSetServoAlarm(m_nAxisNo, 0{uUse:0=NormalClose/Low,1=NormalOpen/High,2=NotUsed.High,3=MaintainCurrState/Used});	//TBD:MOTION:AXM?
  if (nRet <> AXHS.AXT_RT_SUCCESS) then begin
		m_sErrLibApi := 'AxmSignalSetServoAlarm(0)(Error='+IntToStr(nRet)+')';
		Exit(nErrCode);
  end;
{$ENDIF}

{$IFDEF SIMULATOR_MOTION}
  {$IFDEF SUPPORT_1CG2PANEL}
  m_nSimSyncStatus     := SyncNone;
  m_nSimSyncSlaveAxis  := MOTION_SYNCMODE_SLAVE_UNKNOWN;
//m_dSimSyncSlaveRatio := MOTION_SYNCMODE_SLAVE_RATIO;
  {$ENDIF}
{$ENDIF}

  CodeSite.Send(sFunc+'...END');
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxm.MotionReset: Integer;
var
	nRet 			: DWORD;
	nErrCode 	: Integer;
  sFunc, sTemp : string;
  MotionParam     : RMotionParam;
  nPulseOutMethod : DWORD;
  sPulseOutMethod : string;
begin
  sFunc := '<MOTION> '+IntToStr(m_nMotionID)+': MotionReset: ';
  CodeSite.Send(sFunc+'...START');
  //
	m_sErrLibApi := '';
	nErrCode 		 := DefPocb.ERR_MOTION_RESET;	//TBD?
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;

  Common.GetMotionParam(m_nMotionID,MotionParam);

  //-------------------------- 해당 축의 Alarm Clear 출력을 On (1: Alarm Clear) -> Off
{$IFDEF SIMULATOR_MOTION}
  nRet := AXT_RT_SUCCESS;
{$ELSE}
	nRet := AxmSignalServoAlarmReset(m_nAxisNo, 1{uOnOff:0=AlalrmRestOutoutOff,1:AlalrmRestOutoutOn});
{$ENDIF}
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmSignalServoAlarmReset(1=AlalrmRestOutoutOn): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
	Sleep(100);

{$IFDEF SIMULATOR_MOTION}
  nRet := AXT_RT_SUCCESS;
{$ELSE}
	nRet := AxmSignalServoAlarmReset(m_nAxisNo, 0{uOnOff:0=AlalrmRestOutoutOff,1:AlalrmRestOutoutOn});
{$ENDIF}
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmSignalServoAlarmReset(0=AlalrmRestOutoutOff): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
	Sleep(100);

	//-------------------------- 펄스 출력 방식을 설정
	// 	- Pulse output method : 출력 펄스 방식 설정(typedef : PULSE_OUTPUT)
	// 	  OneHighLowHigh   = 0x0, 1펄스 방식, PULSE(Active High), 정방향(DIR=Low)  / 역방향(DIR=High)
	// 	  OneHighHighLow   = 0x1, 1펄스 방식, PULSE(Active High), 정방향(DIR=High) / 역방향(DIR=Low)
	// 	  OneLowLowHigh    = 0x2, 1펄스 방식, PULSE(Active Low),  정방향(DIR=Low)  / 역방향(DIR=High)
	// 	  OneLowHighLow    = 0x3, 1펄스 방식, PULSE(Active Low),  정방향(DIR=High) / 역방향(DIR=Low)
	// 	  TwoCcwCwHigh     = 0x4, 2펄스 방식, PULSE(CCW:역방향),  DIR(CW:정방향),  Active High
	// 	  TwoCcwCwLow      = 0x5, 2펄스 방식, PULSE(CCW:역방향),  DIR(CW:정방향),  Active Low
	// 	  TwoCwCcwHigh     = 0x6, 2펄스 방식, PULSE(CW:정방향),   DIR(CCW:역방향), Active High
	// 	  TwoCwCcwLow      = 0x7, 2펄스 방식, PULSE(CW:정방향),   DIR(CCW:역방향), Active Low
  //    ????             = 0x8, 2 phase (90' phase difference), PULSE lead DIR(CW: forward direction), PULSE lag DIR(CCW: reverse direction) – Non-used of IP
  //    ????             = 0x9, 2 phase (90' phase difference), PULSE lead DIR(CCW: forward direction), PULSE lag DIR(CW: reverse direction) – Non-used of IP

  nPulseOutMethod := MotionParam.dPulseOutMethod;  //2022-08-05 default(4=TwoCcwCwHigh), ITOLED_Yaxis|A2CHv4#3_Yaxis(6=TwoCwCcwHigh)
  case nPulseOutMethod of
    0 : sPulseOutMethod := '0=OneHighLowHigh';
    1 : sPulseOutMethod := '1=OneHighHighLow';
    2 : sPulseOutMethod := '2=OneLowLowHigh';
    3 : sPulseOutMethod := '3=OneLowHighLow';
    4 : sPulseOutMethod := '4=TwoCcwCwHigh';
    5 : sPulseOutMethod := '5=TwoCcwCwLow';
    6 : sPulseOutMethod := '6=TwoCwCcwHigh';
    7 : sPulseOutMethod := '7=TwoCwCcwLow';
    else sPulseOutMethod := Format('%d=unknown',[nPulseOutMethod]);
  end;
//{$IFDEF POCB_ITOLED}
//  if m_nAxisType = DefMotion.MOTION_AXIS_Y then begin
//    nPulseOutMethod := 6; //6=TwoCwCcwHigh
//    sPulseOutMethod := '6=TwoCwCcwHigh';
//  end;
//{$ELSE}
//  {$IFDEF POCB_A2CHv4}
//  if Common.SystemInfo.DAE_SYSTEM_ID = 'LGDVH_AUTO_LINE2_PUC3' then begin //LINE2:PUC3 Y-Axis
//    nPulseOutMethod := nPulseOutMethod; //6=TwoCwCcwHigh
//    sPulseOutMethod := '6=TwoCwCcwHigh';
//  end;
//  {$ENDIF}
//{$ENDIF}
  CodeSite.Send(sFunc+' PulseOutMethod('+sPulseOutMethod+')');
	nRet := AxmMotSetPulseOutMethod(m_nAxisNo, nPulseOutMethod);
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetPulseOutMethod('+sPulseOutMethod+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
	Sleep(100);

{$IFDEF SIMULATOR_MOTION}
	Exit(DefPocb.ERR_OK);
{$ENDIF}

{$IFDEF POCB_A2CH}
{$ELSE} //A2CHv2|A2CHV3|A2CHv4|F2CH|ITOLED
  //-------------------------- 엔코더 입력 방식을 설정
  //    ObverseUpDownMode       = 0x0,        // Forward direction Up/Down
  //    ObverseSqr1Mode         = 0x1,        // Forward direction 1 multiplication
  //    ObverseSqr2Mode         = 0x2,        // Forward direction 2 multiplication
  //    ObverseSqr4Mode         = 0x3,        // Forward direction 4 multiplication
  //    ReverseUpDownMode       = 0x4,        // Reverse direction Up/Down
  //    ReverseSqr1Mode         = 0x5,        // Reverse direction 1 multiplication
  //    ReverseSqr2Mode         = 0x6,        // Reverse direction 2 multiplication
  //    ReverseSqr4Mode         = 0x7         // Reverse direction 4 multiplication
  nRet := AxmMotSetEncInputMethod(m_nAxisNo, 5);
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetEncInputMethod(5=ReverseSqr1Mode): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
  Sleep(100);

  //-------------------------- Emergency 동작 / 사용 유무 설정
  // uStopMode  : EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
  // uLevel     : LOW(0), HIGH(1), UNUSED(2), USED(3)
  nRet := AxmSignalSetStop(m_nAxisNo, 0{EStop}, 1{A/High});
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmSignalSetStop(0=EStop,1=High}): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
  Sleep(100);
{$ENDIF}
  //
	Result := DefPocb.ERR_OK;
  CodeSite.Send(sFunc+'...END');
end;

//------------------------------------------------------------------------------
function TMotionAxm.ServoOnOff(bIsOn: Boolean): Integer;
var
	nRet 			: DWord;
	nErrCode 	: Integer;
  MotionParam : RMotionParam;
  dReadUnit  : Double;
  dReadPulse : LongInt;
  dSoftLimitUse,       dReadSoftLimitUse       : DWORD;
  dSoftLimitStopMode,  dReadSoftLimitStopMode  : DWORD;
  dSoftLimitPosSelect, dReadSoftLimitPosSelect : DWORD;
  dSoftLimitPlus,      dReadSoftLimitPlus  : Double;
  dSoftLimitMinus,     dReadSoftLimitMinus : Double;
  sFunc, sTemp : string;
  nPulseOutMethod : DWORD;
  sPulseOutMethod : string;
begin
  sFunc := '<MOTION> '+IntToStr(m_nMotionID)+': ServoOnOff(bIsOn='+BoolToStr(bIsOn)+'): ';
  CodeSite.Send(sFunc+'...START');
  //
  m_sErrLibApi 	:= '';
	if bIsOn then nErrCode := DefPocb.ERR_MOTION_SERVO_ON
	else  			  nErrCode := DefPocb.ERR_MOTION_SERVO_OFF;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;

  Common.GetMotionParam(m_nMotionID,MotionParam);
  nPulseOutMethod := MotionParam.dPulseOutMethod; ////2022-08-05 default(4=TwoCcwCwHigh), ITOLED_Yaxis|A2CHv4#3_Yaxis|ATOGAGO_Yaxis(6=TwoCwCcwHigh)
  case nPulseOutMethod of
    0 : sPulseOutMethod := '0=OneHighLowHigh';
    1 : sPulseOutMethod := '1=OneHighHighLow';
    2 : sPulseOutMethod := '2=OneLowLowHigh';
    3 : sPulseOutMethod := '3=OneLowHighLow';
    4 : sPulseOutMethod := '4=TwoCcwCwHigh';
    5 : sPulseOutMethod := '5=TwoCcwCwLow';
    6 : sPulseOutMethod := '6=TwoCwCcwHigh';
    7 : sPulseOutMethod := '7=TwoCwCcwLow';
    else sPulseOutMethod := Format('%d=unknown',[nPulseOutMethod]);
  end;
  CodeSite.Send(sFunc+' PulseOutMethod('+sPulseOutMethod+')');

{$IFDEF SIMULATOR_MOTION}
  m_bServoOn := bIsOn;
	Exit(DefPocb.ERR_OK);
{$ENDIF}

  if (not bIsOn) then begin		//------------------------------- Servo Off
		nRet := AxmSignalServoOn(m_nAxisNo, 0{uOnOff:0=Off,1=On}); 	// Servo Off
    if nRet <> AXT_RT_SUCCESS then begin
			m_sErrLibApi := sFunc+'AxmSignalServoOn(0=Off): Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
			Exit(nErrCode);
    end;
  end

  else begin                 //-------------------------------- Servo On
		//------------------------ ProfileMode 설정
		nRet := AxmMotSetProfileMode(m_nAxisNo, 3{uProfileMode});
        // - [00h] Symmetrical Trapezode
        // - [01h] Asymmetrical Trapezode
        // - [02h] Reserved
        // - [03h] Symmetrical S Curve
        // - [04h] Asymmetrical S Curve
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetProfileMode(3=Symmetrical-S-Curv): ';
			m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
			Exit(nErrCode);
    end;
		//------------------------ Unit/Pulse 설정
    sTemp := 'AxmMotSetMoveUnitPerPulse(Unit='+FloatToStr(MotionParam.dUnit)+',Pulse='+IntToStr(MotionParam.dPulse)+',UnitPerPulse='+FloatToStr(MotionParam.dUnitPerPulse)+'): ';
		nRet := AxmMotSetMoveUnitPerPulse(m_nAxisNo, MotionParam.dUnit, MotionParam.dPulse);
    if (nRet <> AXT_RT_SUCCESS) then begin	// AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_MOVE_UNIT_IS_ZERO
			nRet := AxmMotSetMoveUnitPerPulse(m_nAxisNo, MotionParam.dUnit, MotionParam.dPulse);
      if (nRet <> AXT_RT_SUCCESS) then begin
				m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
        CodeSite.Send(m_sErrLibApi);
				Exit(nErrCode);
      end;
    end;
    CodeSite.Send(sFunc+sTemp);
    Sleep(100);
    //
		nRet := AxmMotGetMoveUnitPerPulse(m_nAxisNo, @dReadUnit, @dReadPulse);
    if (nRet <> AXT_RT_SUCCESS) then begin	// AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_INVALID_AXIS_NO
      sTemp := 'AxmMotGetMoveUnitPerPulse: ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
      Exit(nErrCode);
    end;
    if (dReadUnit <> MotionParam.dUnit) or (dReadPulse <> MotionParam.dPulse) then begin
      sTemp := 'AxmMotGetMoveUnitPerPulse: (Unit='+FloatToStr(dReadUnit)+',Pulse='+IntToStr(dReadPulse)+')';
      m_sErrLibApi := sFunc+sTemp+'Error(Mismatch SetValue<>GetValue)';
      CodeSite.Send(m_sErrLibApi);
      Exit(nErrCode);
    end;
    //------------------------ 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설
		nRet := AxmMotSetMaxVel(m_nAxisNo, MotionParam.dVelocityMax{dVel});
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetMaxVel(dVelMax='+FloatToStr(MotionParam.dVelocityMax)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
			Exit(nErrCode);
    end;
    Sleep(100);
		nRet := AxmMotSetMinVel(m_nAxisNo,MotionParam.dStartStopSpeed);
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetMinVel(dVelMax='+FloatToStr(MotionParam.dStartStopSpeed)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
			Exit(nErrCode);
    end;
    //------------------------ 해당 축의 해당 bit의 출력을 On (Servo On)
		nRet := AxmSignalServoOn(m_nAxisNo, 1{uOnOff:0=Off,1=On}); 	// Servo On
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmSignalServoOn(1:On): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
			Exit(nErrCode);
    end;
    Sleep(100);

		//------------------------ Signal Level 설정 (전장 후 Motion Control GUI 값 참고)
    {$IF Defined(POCB_A2CH)}
    AxmSignalSetLimit(m_nAxisNo, 0{uStopMode:0=Estop,1=SStop}, 0{uPositiveLevel:0=NormalClose/Low,1=NormalOpen/High,2=NotUsed,3=MaintainCurrState/Used}, 0{uNegativeLevel});
    {$ELSEIF Defined(POCB_A2CHv2)}
    AxmSignalSetLimit(m_nAxisNo, 0{uStopMode:0=Estop,1=SStop}, 0{uPositiveLevel:0=NormalClose/Low,1=NormalOpen/High,2=NotUsed,3=MaintainCurrState/Used}, 0{uNegativeLevel});
    AxmHomeSetSignalLevel(m_nAxisNo, 0{Low}); //A2CHv2
    {$ELSEIF Defined(POCB_A2CHv3)}
    AxmSignalSetLimit(m_nAxisNo, 0{uStopMode:0=Estop,1=SStop}, 1{uPositiveLevel:0=NormalClose/Low,1=NormalOpen/High,2=NotUsed,3=MaintainCurrState/Used}, 1{uNegativeLevel});
    AxmHomeSetSignalLevel(m_nAxisNo, 0{Low}); //A2CHv3
    {$ELSEIF Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
    AxmSignalSetLimit(m_nAxisNo, 0{uStopMode:0=Estop,1=SStop}, 0{uPositiveLevel:0=NormalClose/Low,1=NormalOpen/High,2=NotUsed,3=MaintainCurrState/Used}, 0{uNegativeLevel}); //for 안전사양
    AxmHomeSetSignalLevel(m_nAxisNo, 1{0:NormalClose=B,1:NormalOpe=A}); //A2CHv4  //2021-11-08 0-->1
    {$ELSEIF Defined(POCB_F2CH)}
    if (m_nAxisType <> DefMotion.MOTION_AXIS_T) then
      AxmSignalSetLimit(m_nAxisNo, 0{uStopMode:0=Estop,1=SStop}, 0{uPositiveLevel:0=NormalClose/Low,1=NormalOpen/High,2=NotUsed,3=MaintainCurrState/Used}, 0{uNegativeLevel})
    else
      AxmSignalSetLimit(m_nAxisNo, 0{uStopMode:0=Estop,1=SStop}, 1{uPositiveLevel:0=NormalClose/Low,1=NormalOpen/High,2=NotUsed,3=MaintainCurrState/Used}, 1{uNegativeLevel});
    {$ENDIF}
		AxmSignalSetInpos(m_nAxisNo, 1{uUse:0=NormalClose/Low,1=NormalOpen/High,2=NotUsed.High,3=MaintainCurrState/Used});
    AxmSignalSetServoAlarm(m_nAxisNo, 0{uUse:0=NormalClose/Low,1=NormalOpen/High,2=NotUsed.High,3=MaintainCurrState/Used});
		//------------------------ SoftLimit 설정  //2019-03-19
    //  - Sets use of Software limit, count to use, and stop method on a specific axis.
    //      AxmSignalSetSoftLimit(lAxisNo: LongInt; uUse{0=NotUsed,1=Used}: Dword; uStopMode{0=EStop,1:SStop}: Dword; uSelection(0=CmdPos,1=ActPos}: Dword; dPositivePos: Double; dNegativePos: Double) : DWord;
    //  - Returns use of Software limit, count to use, and stop method on a specific axis.
    //      AxmSignalGetSoftLimit (lAxisNo, @upUse, @upStopMode, @upSelection: DWord;, @dpPositivePos, @dpNegativePos: Double);
    dSoftLimitUse   := MotionParam.dSoftLimitUse;
    dSoftLimitStopMode  := 0; //{uStopMode:0=EStop,1:SStop}    //A2CHv3:MOTION (A2CHv2:E-STOP, A2CHv3:S-STOP)
    dSoftLimitPosSelect := 0; //{uSelection:0=CmdPos,1=ActPos}
    dSoftLimitPlus  := MotionParam.dSoftLimitPlus;
    dSOftLimitMinus := MotionParam.dSoftLimitMinus;
    sTemp := 'AxmSignalSetSoftLimit(dSoftLimitUse='+IntToStr(dSoftLimitUse)+',0=EStop,0=CmdPos,+Limit='+FloatToStr(dSoftLimitPlus)+',-Limit='+FloatToStr(dSoftLimitMinus)+'): ';
		nRet := AxmSignalSetSoftLimit(m_nAxisNo, dSoftLimitUse, dSoftLimitStopMode, dSoftLimitPosSelect, dSoftLimitPlus, dSoftLimitMinus);
    if (nRet <> AXT_RT_SUCCESS) then begin	// AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_INVALID_AXIS_NO
			nRet := AxmSignalSetSoftLimit(m_nAxisNo, dSoftLimitUse, dSoftLimitStopMode, dSoftLimitPosSelect, dSoftLimitPlus, dSoftLimitMinus);
      if (nRet <> AXT_RT_SUCCESS) then begin
        m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
        CodeSite.Send(m_sErrLibApi);
				Exit(nErrCode);
      end;
    end;
    CodeSite.Send(sFunc+sTemp);
    Sleep(100);
    //
    dReadSoftLimitUse       := 0;
    dReadSoftLimitStopMode  := 1;  //A2CHv3:MOTION (A2CHv2:E-STOP, A2CHv3:S-STOP)
    dReadSoftLimitPosSelect := 0;
    dReadSoftLimitMinus     := 0;
    dReadSoftLimitPlus      := 0;
		nRet := AxmSignalGetSoftLimit (m_nAxisNo, @dReadSoftLimitUse, @dReadSoftLimitStopMode, @dReadSoftLimitPosSelect, @dReadSoftLimitPlus, @dReadSoftLimitMinus);
    if (nRet <> AXT_RT_SUCCESS) then begin	// AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_INVALID_AXIS_NO
      nRet := AxmSignalGetSoftLimit (m_nAxisNo, @dReadSoftLimitUse, @dReadSoftLimitStopMode, @dReadSoftLimitPosSelect, @dReadSoftLimitPlus, @dReadSoftLimitMinus);
      if (nRet <> AXT_RT_SUCCESS) then begin
        sTemp := 'AxmSignalGetSoftLimit: ';
        m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
        CodeSite.Send(m_sErrLibApi);
				Exit(nErrCode);
      end;
    end;
    sTemp := 'AxmSignalGetSoftLimit: (dSoftLimitUse='+IntToStr(dReadSoftLimitUse)+',StopMode='+IntToStr(dReadSoftLimitStopMode)+'PosSelect='+IntToStr(dReadSoftLimitPosSelect)+'+Limit='+FloatToStr(dReadSoftLimitPlus)+',-Limit='+FloatToStr(dReadSoftLimitMinus)+')';
    if (dReadSoftLimitUse <> dSoftLimitUse{Used}) or (dReadSoftLimitStopMode <> dSoftLimitStopMode) or (dReadSoftLimitPosSelect <> dSoftLimitPosSelect) //A2CHv3:MOTION (A2CHv2:E-STOP, A2CHv3:S-STOP)
        or (dReadSoftLimitPlus <> dSoftLimitPlus) or (dReadSoftLimitMinus <> dSoftLimitMinus) then begin
      m_sErrLibApi := sFunc+sTemp+'Error(Mismatch SetValue<>GetValue)';
      CodeSite.Send(m_sErrLibApi);
      Exit(nErrCode);
    end;
		//------------------------ Motor Reset
		Result := MotionReset;
    if (Result <> DefPocb.ERR_OK) then begin
			Exit(nErrCode);
    end;
  end;
	
  m_bServoOn := bIsOn;
	Result := DefPocb.ERR_OK;
  CodeSite.Send(sFunc+'...END');
end;

//******************************************************************************
// procedure/function: TMotorAxm: Move Start/Stop
//		- function TMotionAxt.MoveStop(MotionParam: RMotionParam; bIsEMS: Boolean = False): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionAxm.MoveSTOP(MotionParam: RMotionParam; bIsEMS: Boolean = False): Integer;
var
	nRet 			  : DWORD;
  uHomeResult : DWORD;
	nErrCode 	  : Integer;
  sFunc    : string;
begin
  sFunc := '<MOTION> '+IntToStr(m_nMotionID)+': MoveSTOP(bIsEMS='+BoolToStr(bIsEMS)+'): ';
  CodeSite.Send(sFunc+'...START');
  //
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_STOP;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
{$IFDEF SIMULATOR_MOTION}
	Exit(DefPocb.ERR_OK);
{$ENDIF}

	// 단축 구동 확인 ---------------------
	// 	- 지정 축의 구동이 종료될 때까지 기다린 후 함수를 벗어난다.
	//		function CFS20wait_for_done (axis : SmallInt) : Word; stdcall;
	//
	// 단축 구동 정지 함수군 --------------
  //  - Slowdown stops by deceleration set for specific axis.
  //      function AxmMoveStop (lAxisNo : LongInt; dDecel : Double) : DWord; stdcall;
  //      function AxmMoveStopEx(lAxisNo : LongInt; dDecel : Double): DWord; stdcall;
  //          dDecel : Deceleration value when stop.
  //  - Stops specific axis emergently .
  //      function AxmMoveEStop (lAxisNo : LongInt) : DWord; stdcall;
  //          * Return values: AXT_RT_SUCCESS, AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_INVALID_AXIS_NO
  //  - Stops specific axis slow down.
  //      function AxmMoveSStop (lAxisNo : LongInt) : DWord; stdcall;
  //          * Return values: AXT_RT_SUCCESS, AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_INVALID_AXIS_NO
	//
  //-------------------------- 원점검색을 중지
  //TBD:MOTION:AXM? (No need to Abort Home Search to STOP)  //CFS20abort_home_search(m_nAxisNo, 1);
  nRet := AxmHomeGetResult(m_nAxisNo, @uHomeResult);
  if (nRet <> AXHS.AXT_RT_SUCCESS) then begin
    //No Exit!!!
  end
  else begin
    if (uHomeResult = AXHS.HOME_SEARCHING) then begin// Home search is in progress : 0
      CodeSite.Send('MoveSTOP: Home search is in progress');
    end;
  end;

  //-------------------------- 급정지 또는 감속정지
  if (bIsEMS) then nRet := AxmMoveEStop(m_nAxisNo)  // 급정지
  else 						 nRet := AxmMoveSStop(m_nAxisNo); // 감속정지
  if nRet <> AXT_RT_SUCCESS then begin
    if (bIsEMS) then m_sErrLibApi := 'AxmMoveEStop: Error('+IntToStr(nRet)+')'
    else             m_sErrLibApi := 'AxmMoveSStop: Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;

  CodeSite.Send(sFunc+'..END');
	Result := DefPocb.ERR_OK;
end;

//******************************************************************************
// procedure/function: TMotorAxm: Move ABS/INC/JOG
//		- function TMotionAxm.MoveABS(MotionParam: RMotionParam; dAbsPos: Double): Integer;
//		- function TMotionAxm.MoveINC(MotionParam: RMotionParam; dIncDecPos: Double): Integer;
//		- function TMotionAxm.MoveJOG(MotionParam: RMotionParam; bIsPlus: Boolean): Integer;
//    - function TMotionAxm.MoveLIMIT(MotionParam: RMotionParam; bIsPlus: Boolean): Integer;
//    - function TMotionAxm.MoveHOME(MotionParam: RMotionParam; bDoPreCheck: Boolean = False): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionAxm.MoveABS(MotionParam: RMotionParam; dAbsPos: Double; bSyncMaster: Boolean): Integer;  //A2CHv3:MOTION
var
	nRet 		 : DWORD;
	nErrCode : Integer;
  uStatus  : DWORD;
  sFunc, sTemp : string;
begin
  sFunc := '<MOTION> '+IntToStr(m_nMotionID)+': MoveABS(dAbsPos='+FloatToStr(dAbsPos)+',bSyncMaster='+BoolToStr(bSyncMaster)+'): ';
  CodeSite.Send(sFunc+'...START');
  //
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_ABS;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm 상태 확인  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
{$IFDEF SIMULATOR_MOTION}
	Exit(DefPocb.ERR_OK);
{$ENDIF}

	//-------------------------- Start/Stop 속도 설정
	nRet := AxmMotSetMinVel(m_nAxisNo, MotionParam.dStartStopSpeed);
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMinVel(AxisNo='+IntToStr(m_nAxisNo)+',dVelMin='+FloatToStr(MotionParam.dStartStopSpeed)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
  if bSyncMaster then begin  //A2CHv3:MOTION:SYNC-MOVE
	  nRet := AxmMotSetMinVel(m_nAxisNo+1, MotionParam.dStartStopSpeed);
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetMinVel(SlaveAxisNo='+IntToStr(m_nAxisNo+1)+',dVelMin='+FloatToStr(MotionParam.dStartStopSpeed)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;
  end;
	//-------------------------- 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정
	nRet := AxmMotSetMaxVel(m_nAxisNo, MotionParam.dVelocityMax{dVel});
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMaxVel(AxisNo='+IntToStr(m_nAxisNo)+',dVelMax='+FloatToStr(MotionParam.dVelocityMax)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
  if bSyncMaster then begin  //A2CHv3:MOTION:SYNC-MOVE
	  nRet := AxmMotSetMaxVel(m_nAxisNo+1, MotionParam.dVelocityMax{dVel});
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetMaxVel(SlaveAxisNo='+IntToStr(m_nAxisNo+1)+',dVelMax='+FloatToStr(MotionParam.dVelocityMax)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;
  end;

	//-------------------------- 단축 지정 거리 구동
	// 	- start_** : 지정 축에서 구동 시작후 함수를 return한다. 'start_*' 가 없으면 이동 완료후 return한다(Blocking).
	// 	- *r*_*    : 지정 축에서 입력된 거리만큼(상대좌표)로 이동한다. '*r_*'이 없으면 입력된 위치(절대좌표)로 이동한다.
	// 	- *s*_*    : 구동중 속도 프로파일을 'S curve'를 이용한다. '*s_*'가 없다면 사다리꼴 가감속을 이용한다.
	// 	- *a*_*    : 구동중 속도 가감속도를 비대칭으로 사용한다. 가속률 또는 가속 시간과  감속률 또는 감속 시간을 각각 입력받는다.
	// 	- *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. '*_ex'가 없다면 가감속률로 입력 받는다.
	// 	- 입력 값들: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
	//
  nRet := AxmMotSetAbsRelMode(m_nAxisNo, 0{uAbsRelMode:0=Abs,1=Rel});
  if nRet <> AXHS.AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetAbsRelMode(AxisNo='+IntToStr(m_nAxisNo)+',0=Abs): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;

  nRet := AxmMoveStartPos(m_nAxisNo, dAbsPos, MotionParam.dVelocity, MotionParam.dAccel, MotionParam.dAccel);
  if nRet <> AXHS.AXT_RT_SUCCESS then begin
    sTemp := 'AxmMoveStartPos(AxisNo='+IntToStr(m_nAxisNo)+',dAbsPos='+FloatToStr(dAbsPos)+',dVel='+FloatToStr(MotionParam.dVelocity)+',dAcc='+FloatToStr(MotionParam.dAccel)+',dDeacc='+FloatToStr(MotionParam.dAccel)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;

  repeat
    Sleep(100);
    nRet := AxmStatusReadInMotion(m_nAxisNo, @uStatus{0=Not in-motion, 1=In-motion});
    if (nRet <> AXHS.AXT_RT_SUCCESS) then uStatus := 1;
  until uStatus = 0;

  CodeSite.Send(sFunc+'...END');
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxm.MoveINC(MotionParam: RMotionParam; dIncDecPos: Double; bSyncMaster: Boolean): Integer;
var
  dVel, dVelMax, dAccel : Double;
	nRet 			: DWORD;
  uStatus   : DWORD;
	nErrCode 	: Integer;
  sFunc, sTemp : string;
begin
  sFunc := '<MOTION> '+IntToStr(m_nMotionID)+': MoveINC(dIncDecPos='+FloatToStr(dIncDecPos)+',bSyncMaster='+BoolToStr(bSyncMaster)+'): ';
  CodeSite.Send(sFunc+'...START');
  //
	m_sErrLibApi 	:= '';
  if (dIncDecPos < 0) then	nErrCode := DefPocb.ERR_MOTION_MOVE_DEC
  else                      nErrCode := DefPocb.ERR_MOTION_MOVE_INC;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm 상태 확인
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
{$IFDEF SIMULATOR_MOTION}
	Exit(DefPocb.ERR_OK);
{$ENDIF}

	//-------------------------- Start/Stop 속도 설정
	nRet := AxmMotSetMinVel(m_nAxisNo, MotionParam.dStartStopSpeed);
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMinVel(AxisNo='+IntToStr(m_nAxisNo)+',dVelMin='+FloatToStr(MotionParam.dStartStopSpeed)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
  if bSyncMaster then begin  //A2CHv3:MOTION:SYNC-MOVE
	  nRet := AxmMotSetMinVel(m_nAxisNo+1, MotionParam.dStartStopSpeed);
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetMinVel(SlaveAxisNo='+IntToStr(m_nAxisNo+1)+',dVelMin='+FloatToStr(MotionParam.dStartStopSpeed)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;
  end;
	//-------------------------- 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정
  if m_nAxisType = DefMotion.MOTION_AXIS_T then dVelMax := MotionParam.dVelocityMax
  else                                          dVelMax := MotionParam.dJogVelocityMax;
	nRet := AxmMotSetMaxVel(m_nAxisNo, dVelMax{dVel});
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMaxVel(AxisNo='+IntToStr(m_nAxisNo)+',dVelMax='+FloatToStr(dVelMax)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
  if bSyncMaster then begin  //A2CHv3:MOTION:SYNC-MOVE
	  nRet := AxmMotSetMaxVel(m_nAxisNo+1, dVelMax{dVel});
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetMaxVel(SlaveAxisNo='+IntToStr(m_nAxisNo+1)+',dVelMax='+FloatToStr(dVelMax)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;
  end;
	
	//-------------------------- 단축 지정 거리 구동
	// 	- start_** : 지정 축에서 구동 시작후 함수를 return한다. 'start_*' 가 없으면 이동 완료후 return한다(Blocking).
	// 	- *r*_*    : 지정 축에서 입력된 거리만큼(상대좌표)로 이동한다. '*r_*'이 없으면 입력된 위치(절대좌표)로 이동한다.
	// 	- *s*_*    : 구동중 속도 프로파일을 'S curve'를 이용한다. '*s_*'가 없다면 사다리꼴 가감속을 이용한다.
	// 	- *a*_*    : 구동중 속도 가감속도를 비대칭으로 사용한다. 가속률 또는 가속 시간과  감속률 또는 감속 시간을 각각 입력받는다.
	// 	- *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. '*_ex'가 없다면 가감속률로 입력 받는다.
	// 	- 입력 값들: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
	//
  //
  nRet := AxmMotSetAbsRelMode(m_nAxisNo, 1{uAbsRelMode:0=Abs,1=Rel});
  if nRet <> AXHS.AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetAbsRelMode(AxisNo='+IntToStr(m_nAxisNo)+',1=Rel): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
  //
  if m_nAxisType = DefMotion.MOTION_AXIS_T then begin dVel := MotionParam.dVelocity;     dAccel := MotionParam.dAccel;    end
  else                                          begin dVel := MotionParam.dJogVelocity;  dAccel := MotionParam.dJogAccel; end;  //2021-02-25 A2CHv3:MOTION
  nRet := AxmMoveStartPos(m_nAxisNo, dIncDecPos, dVel, dAccel, dAccel);
  if nRet <> AXHS.AXT_RT_SUCCESS then begin
    sTemp := 'AxmMoveStartPos(AxisNo='+IntToStr(m_nAxisNo)+',dIncDecPos='+FloatToStr(dIncDecPos)+',dVel='+FloatToStr(dVel)+',dAcc='+FloatToStr(dAccel)+',dDeacc='+FloatToStr(dAccel)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;

  repeat
    Sleep(100);
    nRet := AxmStatusReadInMotion(m_nAxisNo, @uStatus{0=Not in-motion, 1=In-motion});
    if (nRet <> AXHS.AXT_RT_SUCCESS) then uStatus := 1;
  until uStatus = 0;

  //
  nRet := AxmMotSetAbsRelMode(m_nAxisNo, 0{uAbsRelMode:0=Abs,1=Rel});
  if nRet <> AXHS.AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetAbsRelMode(AxisNo='+IntToStr(m_nAxisNo)+',0=Abs): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		//Exit(nErrCode);
  end;

  CodeSite.Send(sFunc+'...END');
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxm.MoveJOG(MotionParam: RMotionParam; bIsPlus: Boolean; bSyncMaster: Boolean): Integer;
var
  dVel, dVelMax, dAccel : Double;
	nErrCode : Integer;
	nRet 		 : DWORD;
  sFunc, sTemp : string;
begin
  sFunc := '<MOTION> '+IntToStr(m_nMotionID)+': MoveJOG(bIsPlus='+BoolToStr(bIsPlus)+',bSyncMaster='+BoolToStr(bSyncMaster)+'): ';
  CodeSite.Send(sFunc+'...START');
  //
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_JOG;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
 //-------------------------- Motion Alarm 상태 확인
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
{$IFDEF SIMULATOR_MOTION}
	Exit(DefPocb.ERR_OK);
{$ENDIF}

	//-------------------------- Start/Stop 속도 설정
	nRet := AxmMotSetMinVel(m_nAxisNo, MotionParam.dStartStopSpeed);
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMinVel(AxisNo='+IntToStr(m_nAxisNo)+',dVelMin='+FloatToStr(MotionParam.dStartStopSpeed)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
  if bSyncMaster then begin  //A2CHv3:MOTION:SYNC-MOVE
	  nRet := AxmMotSetMinVel(m_nAxisNo+1, MotionParam.dStartStopSpeed);
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetMinVel(SlaveAxisNo='+IntToStr(m_nAxisNo+1)+',dVelMin='+FloatToStr(MotionParam.dStartStopSpeed)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;
  end;
	
	//-------------------------- 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정
  if m_nAxisType = DefMotion.MOTION_AXIS_T then dVelMax := MotionParam.dVelocityMax
  else                                          dVelMax := MotionParam.dJogVelocityMax;
	nRet := AxmMotSetMaxVel(m_nAxisNo, dVelMax{dVel});
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMaxVel(AxisNo='+IntToStr(m_nAxisNo)+',dVelMax='+FloatToStr(dVelMax)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
  if bSyncMaster then begin  //A2CHv3:MOTION:SYNC-MOVE
	  nRet := AxmMotSetMaxVel(m_nAxisNo+1, dVelMax{dVel});
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetMaxVel(SlaveAxisNo='+IntToStr(m_nAxisNo+1)+',dVelMax='+FloatToStr(dVelMax)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;
  end;

	//-------------------------- 단축 지정 거리 구동
	// 	- start_** : 지정 축에서 구동 시작후 함수를 return한다. 'start_*' 가 없으면 이동 완료후 return한다(Blocking).
	// 	- *r*_*    : 지정 축에서 입력된 거리만큼(상대좌표)로 이동한다. '*r_*'이 없으면 입력된 위치(절대좌표)로 이동한다.
	// 	- *s*_*    : 구동중 속도 프로파일을 'S curve'를 이용한다. '*s_*'가 없다면 사다리꼴 가감속을 이용한다.
	// 	- *a*_*    : 구동중 속도 가감속도를 비대칭으로 사용한다. 가속률 또는 가속 시간과  감속률 또는 감속 시간을 각각 입력받는다.
	// 	- *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. '*_ex'가 없다면 가감속률로 입력 받는다.
	// 	- 입력 값들: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
  if m_nAxisType = DefMotion.MOTION_AXIS_T then begin dVel := MotionParam.dVelocity;     dAccel := MotionParam.dAccel;    end
  else                                          begin dVel := MotionParam.dJogVelocity;  dAccel := MotionParam.dJogAccel; end;
  if bIsPlus then dVel := Abs(dVel)
  else            dVel := Abs(dVel) * -1;
	nRet := AxmMoveVel(m_nAxisNo, dVel, Abs(dAccel), Abs(dAccel));
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMoveVel(AxisNo='+IntToStr(m_nAxisNo)+',dVel='+FloatToStr(dVel)+',dAcc='+FloatToStr(Abs(dAccel))+',dDeacc='+FloatToStr(Abs(dAccel))+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;

  CodeSite.Send(sFunc+'...END');
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxm.MoveLIMIT(MotionParam: RMotionParam; bIsPlus: Boolean; bSyncMaster: Boolean): Integer;
var
	nRet 			: DWORD;
  uStatus   : DWORD;
  dAbsPos, dVelMax, dVel, dAccel : Double;
  dDetectSignal : LongInt;
	nErrCode  : Integer;
  sFunc, sTemp : string;
begin
  sFunc := '<MOTION> '+IntToStr(m_nMotionID)+': MoveLIMIT(bIsPlus='+BoolToStr(bIsPlus)+',bSyncMaster='+BoolToStr(bSyncMaster)+'): ';
  CodeSite.Send(sFunc+'...START');
  //
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_TO_LIMIT;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
 //-------------------------- Motion Alarm 상태 확인  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
	//-------------------------- Motor Reset
//TBD? if (MotorReset(m_nBdNo) <> DefPocb.ERR_OK) then begin
//TBD? end;

	//-------------------------- Start/Stop 속도 설정
	nRet := AxmMotSetMinVel(m_nAxisNo, MotionParam.dStartStopSpeed);
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMinVel(AxisNo='+IntToStr(m_nAxisNo)+',dVelMin='+FloatToStr(MotionParam.dStartStopSpeed)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
  if bSyncMaster then begin  //A2CHv3:MOTION:SYNC-MOVE
	  nRet := AxmMotSetMinVel(m_nAxisNo+1, MotionParam.dStartStopSpeed);
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetMinVel(SlaveAxisNo='+IntToStr(m_nAxisNo+1)+',dVelMin='+FloatToStr(MotionParam.dStartStopSpeed)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;
  end;
	//-------------------------- 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정
  if m_nAxisType = DefMotion.MOTION_AXIS_T then dVelMax := MotionParam.dVelocityMax
  else                                          dVelMax := MotionParam.dJogVelocityMax;
	nRet := AxmMotSetMaxVel(m_nAxisNo, dVelMax{dVel});
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMaxVel(AxisNo='+IntToStr(m_nAxisNo)+',dVelMax='+FloatToStr(dVelMax)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
   if bSyncMaster then begin  //A2CHv3:MOTION:SYNC-MOVE
	  nRet := AxmMotSetMaxVel(m_nAxisNo+1, dVelMax{dVel});
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetMaxVel(SlaveAxisNo='+IntToStr(m_nAxisNo+1)+',dVelMax='+FloatToStr(dVelMax)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;
  end;
	
	//-------------------------- 단축 지정 거리 구동
	// 	- start_** : 지정 축에서 구동 시작후 함수를 return한다. 'start_*' 가 없으면 이동 완료후 return한다(Blocking).
	// 	- *r*_*    : 지정 축에서 입력된 거리만큼(상대좌표)로 이동한다. '*r_*'이 없으면 입력된 위치(절대좌표)로 이동한다.
	// 	- *s*_*    : 구동중 속도 프로파일을 'S curve'를 이용한다. '*s_*'가 없다면 사다리꼴 가감속을 이용한다.
	// 	- *a*_*    : 구동중 속도 가감속도를 비대칭으로 사용한다. 가속률 또는 가속 시간과  감속률 또는 감속 시간을 각각 입력받는다.
	// 	- *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. '*_ex'가 없다면 가감속률로 입력 받는다.
	// 	- 입력 값들: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
	//
  if m_nAxisType = DefMotion.MOTION_AXIS_T then begin dVel := MotionParam.dVelocity;     dAccel := MotionParam.dAccel;    end
  else                                          begin dVel := MotionParam.dJogVelocity;  dAccel := MotionParam.dJogAccel; end;
{$IFDEF POCB_A2CHv2}
  if bIsPlus then dAbsPos := MotionParam.dSoftLimitPlus  + 2000
  else            dAbsPos := MotionParam.dSoftLimitMinus - 2000;
  nRet := AxmMoveStartPos(m_nAxisNo, dAbsPos, dVel, dAccel, dAccel/2);   //TBD:DECEL?
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMoveStartPos(AxisNo='+IntToStr(m_nAxisNo)+',dAbsPos='+FloatToStr(dAbsPos)+',dVel='+FloatToStr(dVel)+',dAcc='+FloatToStr(dAccel)+',dDeacc='+FloatToStr(dAccel/2)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;
{$ELSE}
  if bIsPlus then dDetectSignal := 0                          // +EndLimit ( Velocity)
  else      begin dDetectSignal := 1; dVel := dVel * -1; end; // -EndLimit (-Velocity)  //TBD:A2CHv3:MOTION? (dVel/2)
//{$IFDEF POCB_A2CHv4}
//nRet := AxmMoveSignalSearch(m_nAxisNo, dVel, dAccel, dDetectSignal{0=+EndLimit,1=-EndLimit}, 0{signalEdge:0=downEdge,1=upEdge}, 0{0=EStop,1:SStop});  //TBD:A2CHv4:MOTION? (signalEdge,EStop?)
//{$ELSE}
  nRet := AxmMoveSignalSearch(m_nAxisNo, dVel, dAccel, dDetectSignal{0=+EndLimit,1=-EndLimit}, 1{signalEdge:0=downEdge,1=upEdge}, 0{0=EStop,1:SStop});  //TBD:A2CHv3:MOTION? (signalEdge,EStop?)
//{$ENDIF}
{$ENDIF}
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMoveSignalSearch(AxisNo='+IntToStr(m_nAxisNo)+',dVel='+FloatToStr(dVel)+',dAccel='+FloatToStr(dAccel)+',dDetectSignal='+IntToStr(dDetectSignal)+',signalEdge=upEdge?,EStop?)';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;

  repeat
    Sleep(100);
    nRet := AxmStatusReadInMotion(m_nAxisNo, @uStatus{0=Not in-motion, 1=In-motion});
    if (nRet <> AXHS.AXT_RT_SUCCESS) then uStatus := 1;
  until uStatus = 0;

  CodeSite.Send(sFunc+'...END');
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
//
function TMotionAxm.MoveHOME(MotionParam: RMotionParam; bUseSoftLimitMinus: Boolean): Integer;
var
	nRet 					: DWORD;
	nErrCode 			: Integer;
  dCmdPos, dVel, dVelMax, dAccel : Double;
  uStatus       : DWORD;
  bRun          : Boolean;
  sFunc, sTemp : string;
begin
  sFunc := '<MOTION> '+IntToStr(m_nMotionID)+': MoveHOME(bSoftLimit='+BoolToStr(bUseSoftLimitMinus)+'): ';
  CodeSite.Send(sFunc+'...START');
  //
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_TO_HOME;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
    CodeSite.Send(sFunc+'...NG(ERR_MOTION_NOT_CONNECTED)');
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm 상태 확인  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
  if IsMotionAlarmOn then begin
    CodeSite.Send(sFunc+'...NG(ERR_MOTION_ALARM_ON)');
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;

{$IFDEF SIMULATOR_MOTION}
  Sleep(500);
	Exit(DefPocb.ERR_OK);
{$ENDIF}

{$IFDEF OLD_START}
  CodeSite.Send(sFunc+'MoveLIMIT start');
  nRet := MoveLIMIT(MotionParam,False{bIsPlus},False{bSyncMaster});
  if (nRet <> AXHS.AXT_RT_SUCCESS) then begin
    m_sErrLibApi := sFunc+'MoveLIMIT: Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;
  CodeSite.Send(sFunc+'MoveLIMIT end');
{$ENDIF} // OLD_START

  if bUseSoftLimitMinus then begin  //-----------------------------------------

    CodeSite.Send(sFunc+'MoveLIMIT2SoftLimtMinus: start');
    AxmStatusGetCmdPos(m_nAxisNo, @dCmdPos{position});
    CodeSite.Send(sFunc+'AxmStatusGetCmdPos(AxisNo='+IntToStr(m_nAxisNo)+'):'+Format('%0.2f',[dCmdPos]));

    dVel   := MotionParam.dJogVelocity / 2;
    dAccel := MotionParam.dJogAccel / 2;
  //dVel   := dVel * -1;
    //
    nRet := AxmMotSetAbsRelMode(m_nAxisNo, 0{uAbsRelMode:0=Abs,1=Rel});
    if nRet <> AXHS.AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetAbsRelMode(AxisNo='+IntToStr(m_nAxisNo)+',0=Abs): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;
    //
    nRet := AxmMoveStartPos(m_nAxisNo, MotionParam.dSoftLimitMinus, dVel, dAccel, dAccel);
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMoveStartPos(AxisNo='+IntToStr(m_nAxisNo)+',dAbsPos='+FloatToStr(MotionParam.dSoftLimitMinus)+',dVel='+FloatToStr(dVel)+',dAcc='+FloatToStr(dAccel)+',dDeacc='+FloatToStr(dAccel)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;

    repeat
      nRet := AxmStatusReadInMotion(m_nAxisNo, @uStatus{0=Not in-motion, 1=In-motion});
      if (nRet <> AXHS.AXT_RT_SUCCESS) then uStatus := 1;
      Sleep(100);
    until uStatus = 0;
    CodeSite.Send(sFunc+'MoveLIMIT2SoftLimtMinus: end');

  end

  else begin   //-----------------------------------------

    nRet := AxmSignalSetSoftLimit(m_nAxisNo, 0{uUse:0=NotUsed,1=Used}, 0{uStopMode:0=EStop,1:SStop},0{uSelection:0=CmdPos,1=ActPos}, MotionParam.dSoftLimitPlus, MotionParam.dSoftLimitMinus);
    if (nRet <> AXT_RT_SUCCESS) then begin	// AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_INVALID_AXIS_NO
		  nRet := AxmSignalSetSoftLimit(m_nAxisNo, 0{uUse:0=NotUsed,1=Used}, 0{uStopMode:0=EStop,1:SStop},0{uSelection:0=CmdPos,1=ActPos}, MotionParam.dSoftLimitPlus, MotionParam.dSoftLimitMinus);
      if (nRet <> AXT_RT_SUCCESS) then begin
        sTemp := 'MoveLIMIT2SignalLimtMinus: AxmSignalSetSoftLimit(dSoftLimitUse=0{NotUse},uStopMode:0{EStop},uSelection:0{CmdPos})';
        m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
        CodeSite.Send(m_sErrLibApi);
			  Exit(nErrCode);
      end;
    end;
    Sleep(100);

		CodeSite.Send(sFunc+'MoveLIMIT2SignalLimtMinus: MoveLIMIT: ...start');
    nRet := MoveLIMIT(MotionParam,False{bIsPlus},False{bSyncMaster});  //!!!
    if (nRet <> AXHS.AXT_RT_SUCCESS) then begin
      m_sErrLibApi := sFunc+'MoveLIMIT2SignalLimtMinus: MoveLIMIT: Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
      Exit(nErrCode);
    end;
		CodeSite.Send(sFunc+'MoveLIMIT2SignalLimtMinus: MoveLIMIT: ...end');
    Sleep(100);

  end;  //-----------------------------------------

  CodeSite.Send(sFunc+'MoveLIMIT2SignalLimtMinus: MoveJOG: ...start');
  nRet := AxmMoveVel(m_nAxisNo, 50.0{dJogVel},100.0{dJogAccel},100.0{dJogAccel}); //TBD:2021-05-31
  if (nRet <> AXHS.AXT_RT_SUCCESS) then begin
    m_sErrLibApi := sFunc+'MoveLIMIT2SignalLimtMinus: MoveJOG(Error='+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
  //Exit(nErrCode);
  end;
  Sleep(400); //TBD:2021-05-31
  AxmMoveSStop(m_nAxisNo);
  repeat
    nRet := AxmStatusReadInMotion(m_nAxisNo, @uStatus{0=Not in-motion, 1=In-motion});
    if (nRet <> AXHS.AXT_RT_SUCCESS) then uStatus := 1;
    Sleep(100);
  until uStatus = 0;
	CodeSite.Send(sFunc+'MoveLIMIT2SignalLimtMinus: MoveJOG: ...end');

	//-------------------------- 원점 검색 전 Method 및 속도 설정
  case m_nAxisType of
{$IFDEF HAS_MOTION_CAM_Z}
    DefMotion.MOTION_AXIS_Z,
{$ENDIF}
    DefMotion.MOTION_AXIS_Y: begin
      //-------------------------- 원점 검색을 위한 각 Step별 속도 설정, 기구에 맞는 속도로 정의

      if Common.MotionInfo.YaxisServoHomeSpeed > 0 then begin
        nRet := AxmHomeSetVel(m_nAxisNo, Common.MotionInfo.YaxisServoHomeSpeed{dVelFirst}, 3{dvelSecond}, 2{dVelThird}, 1{dVelLast}, Common.MotionInfo.YaxisServoHomeAcc{dAccFirst}, Common.MotionInfo.YaxisServoHomeDcc{dAccSecond});
        sTemp := 'AxmHomeSetVel(AxisNo='+IntToStr(m_nAxisNo) + Common.MotionInfo.YaxisServoHomeSpeed.Tostring + '{dVelFirst},3{dvelSecond},2{dVelThird},1{dVelLast},'+ Common.MotionInfo.YaxisServoHomeAcc.Tostring +'{dAccFirst},'
                  + Common.MotionInfo.YaxisServoHomeDcc.Tostring +'{dAccSecond})';
      end
      else begin
        nRet := AxmHomeSetVel(m_nAxisNo, 5{dVelFirst}, 3{dvelSecond}, 2{dVelThird}, 1{dVelLast}, 1{dAccFirst}, 1{dAccSecond});
        sTemp := 'AxmHomeSetVel(AxisNo='+IntToStr(m_nAxisNo)+'5{dVelFirst},3{dvelSecond},2{dVelThird},1{dVelLast},1{dAccFirst},1{dAccSecond})';
      end;

      if nRet <> AXT_RT_SUCCESS then begin
        m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
        CodeSite.Send(m_sErrLibApi);
		    Exit(nErrCode);
      end;
      {$IF Defined(POCB_A2CHv3)}
      nRet := AxmHomeSetMethod(m_nAxisNo, 0{lHmDir:0=CCW-,1=CW+ ..Sets the direction to execute home search at initial stage}, //TBD:MOTION:AXM?
                    4{lHmSig:0=+EndLimit,1=-EndLimit,4=IN0(ORG)HomeSignal,5=IN1(Zphase),6:IN2,7:IN3 ...Sets the signal to be used for home search},
                    0{dwZphasDetection:0=NotUsed,1=UsedPositiveDir,2=UsedNegativeDir},
               1000.0{dHClrTim: Sets the standby time to clear the command position and the encoder position after home search is completed [per mSec: 1000.0]},
                  0.0{dHOffset: Position at which home will be reset after home search is completed and is moved to mechanical home});
      {$ELSEIF Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}   //TBD:A2CHv4? =A2CHv3?
      nRet := AxmHomeSetMethod(m_nAxisNo, 0{lHmDir:0=CCW-,1=CW+ ..Sets the direction to execute home search at initial stage},  //TBD:lHmDir? PUC#1&#1, PUC#3?
                    4{lHmSig:0=+EndLimit,1=-EndLimit,4=IN0(ORG)HomeSignal,5=IN1(Zphase),6:IN2,7:IN3 ...Sets the signal to be used for home search},
                    0{dwZphasDetection:0=NotUsed,1=UsedPositiveDir,2=UsedNegativeDir},
               1000.0{dHClrTim: Sets the standby time to clear the command position and the encoder position after home search is completed [per mSec: 1000.0]},
                  0.0{dHOffset: Position at which home will be reset after home search is completed and is moved to mechanical home});
      {$ELSE}
      nRet := AxmHomeSetMethod(m_nAxisNo, 1{lHmDir:0=CCW-,1=CW+ ..Sets the direction to execute home search at initial stage},  //TBD:lHmDir?
                    4{lHmSig:0=+EndLimit,1=-EndLimit,4=IN0(ORG)HomeSignal,5=IN1(Zphase),6:IN2,7:IN3 ...Sets the signal to be used for home search},
                    0{dwZphasDetection:0=NotUsed,1=UsedPositiveDir,2=UsedNegativeDir},
               1000.0{dHClrTim: Sets the standby time to clear the command position and the encoder position after home search is completed [per mSec: 1000.0]},
                  0.0{dHOffset: Position at which home will be reset after home search is completed and is moved to mechanical home});
      {$ENDIF}
      if nRet <> AXT_RT_SUCCESS then begin
        sTemp := 'AxmHomeSetMethod(AxisNo='+IntToStr(m_nAxisNo)+')';
        m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
        CodeSite.Send(m_sErrLibApi);
		    Exit(nErrCode);
      end;
    end;
    else
      Exit(nErrCode);
  end;
  Sleep(50);
	//-------------------------- 원점검색을 시작한다. 시작하기 전에 원점검색에 필요한 설정이 필요
	// 	- 원점검색 (라이브러리상에서 Thread를 사용하여 검색. 주의: 구동후 칩내의 StartStop Speed가 변할 수 있다)
	nRet := AxmHomeSetStart(m_nAxisNo{axis});
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmHomeSetStart(AxisNo='+IntToStr(m_nAxisNo)+')';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;
  //
  bRun := True;
  while bRun do begin
    AxmHomeGetResult(m_nAxisNo, @uStatus);
    case uStatus of
      AXHS.HOME_SUCCESS:        begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_SUCCESS)'; bRun := False; end;
    //AXHS.HOME_SEARCHING:      begin m_sErrLibApi:='Home search is now in progress'; bRun := False; end;
      AXHS.HOME_ERR_GNT_RANGE:  begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_GNT_RANGE'; bRun := False;end;
      AXHS.HOME_ERR_USER_BREAK: begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_USER_BREAK'; bRun := False; end;
      AXHS.HOME_ERR_VELOCITY:   begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_VELOCITY'; bRun := False; end;
      AXHS.HOME_ERR_AMP_FAULT:  begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_AMP_FAULT'; bRun := False; end;
      AXHS.HOME_ERR_NEG_LIMIT:  begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_NEG_LIMIT'; bRun := False; end;
      AXHS.HOME_ERR_POS_LIMIT:  begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_POS_LIMIT'; bRun := False; end;
      AXHS.HOME_ERR_NOT_DETECT: begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_NOT_DETECT'; bRun := False; end;
      AXHS.HOME_ERR_SETTING:    begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_SETTING'; bRun := False; end;
   	  AXHS.HOME_ERR_SERVO_OFF:  begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_SERVO_OFF'; bRun := False; end;
      AXHS.HOME_ERR_TIMEOUT:    begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_TIMEOUT'; bRun := False; end;
      AXHS.HOME_ERR_FUNCALL:    begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_FUNCALL'; bRun := False; end;
      AXHS.HOME_ERR_COUPLING:   begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_COUPLING'; bRun := False; end;
    //AXHS.HOME_ERR_UNKNOWN:    begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':Unknown'; bRun := False; end;
      else begin

      end;
    end;
    Sleep(100);
  end;
  CodeSite.Send(m_sErrLibApi);
  if uStatus <> AXHS.HOME_SUCCESS then Exit(uStatus);

  sleep(50);
  repeat
    nRet := AxmStatusReadInMotion(m_nAxisNo, @uStatus{0=Not in-motion, 1=In-motion});
    if (nRet <> AXHS.AXT_RT_SUCCESS) then uStatus := 1;
    Sleep(100);
  until uStatus = 0;

  sleep(400);
  if uStatus = AXHS.HOME_SUCCESS then begin
    //2019-03-13 DEL!!! AxmStatusSetActPos(0,0{position}); //TBD:F2CH:MOTION:AXM?  //CFS20set_actual_position(m_nAxisNo, 0{position});
    //2019-03-13 DEL!!! AxmStatusSetCmdPos(0,0{position}); //TBD:F2CH:MOTION:AXM?  //CFS20set_command_position(m_nAxisNo, 0{position});
    nRet := AxmSignalSetSoftLimit(m_nAxisNo, 1{uUse:0=NotUsed,1=Used}, 0{uStopMode:0=EStop,1:SStop},0{uSelection:0=CmdPos,1=ActPos}, MotionParam.dSoftLimitPlus, MotionParam.dSoftLimitMinus);  //TBD:A2CHv3:MOTION:SYNC-MOVE?
    if (nRet <> AXT_RT_SUCCESS) then begin	// AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_INVALID_AXIS_NO
      nRet := AxmSignalSetSoftLimit(m_nAxisNo, 1{uUse:0=NotUsed,1=Used}, 0{uStopMode:0=EStop,1:SStop},0{uSelection:0=CmdPos,1=ActPos}, MotionParam.dSoftLimitPlus, MotionParam.dSoftLimitMinus);
      if (nRet <> AXT_RT_SUCCESS) then begin
        sTemp := 'MoveLIMIT2SignalLimtMinus: AxmSignalSetSoftLimit(dSoftLimitUse=1{Used},uStopMode:0{EStop},uSelection:0{CmdPos})';
        m_sErrLibApi 	:= sFunc+'AxmSignalSetSoftLimit(Error='+IntToStr(nRet)+')';
        CodeSite.Send(m_sErrLibApi);
      //Exit(nErrCode);
      end;
    end;
  end
  else begin
    CodeSite.Send(m_sErrLibApi);
    //TBD:F2CH:MOTION:AXM?
  end;

  CodeSite.Send(sFunc+'...END');
	Result := DefPocb.ERR_OK;
end;

{$IFDEF SUPPORT_1CG2PANEL}  // GantryHome is only for A2CHv3
function TMotionAxm.MoveHOMEGantry(MotionParam: RMotionParam; bUseSoftLimitMinus: Boolean): Integer;  //A2CHv3:MOTION:SYNC-MOVE
var
	nRet 					: DWORD;
	nErrCode 			: Integer;
  dCmdPos, dVel, dVelMax, dAccel : Double;
  uStatus       : DWORD;
  bRun          : Boolean;
  sFunc, sTemp  : string;
begin
  sFunc := '<MOTION> '+IntToStr(m_nMotionID)+': MoveHOMEGantry(bSoftLimit='+BoolToStr(bUseSoftLimitMinus)+'): ';
	if m_nMotionID <> MOTIONID_AxMC_STAGE1_Y then begin
		CodeSite.Send(sFunc+'...NG(Not CH1 Y-Axis, ERR_MOTION_MOVE_TO_HOME)');
		Exit(DefPocb.ERR_MOTION_MOVE_TO_HOME);
	end;
	CodeSite.Send(sFunc+'...START');
	//
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_TO_HOME;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
    CodeSite.Send(sFunc+'...NG(ERR_MOTION_NOT_CONNECTED)');
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm 상태 확
  if IsMotionAlarmOn then begin
    CodeSite.Send(sFunc+'...NG(ERR_MOTION_ALARM_ON)');
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;

  {$IFDEF SIMULATOR_MOTION}
  Sleep(500);
	Exit(DefPocb.ERR_OK);
  {$ENDIF}

  //-------------------------- Unit/Pulse 설정
  sTemp := 'AxmMotSetMoveUnitPerPulse(AxisNo='+IntToStr(m_nAxisNo)+',Unit='+FloatToStr(MotionParam.dUnit)+',Pulse='+IntToStr(MotionParam.dPulse)+',UnitPerPulse='+FloatToStr(MotionParam.dUnitPerPulse)+'): ';
	nRet := AxmMotSetMoveUnitPerPulse(m_nAxisNo, MotionParam.dUnit, MotionParam.dPulse);
  if (nRet <> AXT_RT_SUCCESS) then begin	// AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_MOVE_UNIT_IS_ZERO
		nRet := AxmMotSetMoveUnitPerPulse(m_nAxisNo, MotionParam.dUnit, MotionParam.dPulse);
    if (nRet <> AXT_RT_SUCCESS) then begin
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
      Exit(nErrCode);
    end;
  end;
  sTemp := 'AxmMotSetMoveUnitPerPulse(SlaveAxisNo='+IntToStr(m_nAxisNo+1)+',Unit='+FloatToStr(MotionParam.dUnit)+',Pulse='+IntToStr(MotionParam.dPulse)+',UnitPerPulse='+FloatToStr(MotionParam.dUnitPerPulse)+'): ';
	nRet := AxmMotSetMoveUnitPerPulse(m_nAxisNo+1, MotionParam.dUnit, MotionParam.dPulse);
  if (nRet <> AXT_RT_SUCCESS) then begin	// AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_MOVE_UNIT_IS_ZERO
		nRet := AxmMotSetMoveUnitPerPulse(m_nAxisNo+1, MotionParam.dUnit, MotionParam.dPulse);
    if (nRet <> AXT_RT_SUCCESS) then begin
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
      Exit(nErrCode);
     end;
  end;
	//-------------------------- Start/Stop 속도 설정
	nRet := AxmMotSetMinVel(m_nAxisNo,MotionParam.dStartStopSpeed);
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMinVel(AxisNo='+IntToStr(m_nAxisNo)+',dVelMin='+FloatToStr(MotionParam.dStartStopSpeed)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
   end;
	nRet := AxmMotSetMinVel(m_nAxisNo+1,MotionParam.dStartStopSpeed);
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMinVel(SlaveAxisNo='+IntToStr(m_nAxisNo+1)+',dVelMin='+FloatToStr(MotionParam.dStartStopSpeed)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
   end;
  Sleep(100);
  //------------------------ 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정
	nRet := AxmMotSetMaxVel(m_nAxisNo,MotionParam.dJogVelocityMax);
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMaxVel(AxisNo='+IntToStr(m_nAxisNo)+',dVelMax='+FloatToStr(MotionParam.dVelocityMax)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
   end;
	nRet := AxmMotSetMaxVel(m_nAxisNo+1,MotionParam.dJogVelocityMax);
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmMotSetMaxVel(SlaveAxisNo='+IntToStr(m_nAxisNo+1)+',dVelMax='+FloatToStr(MotionParam.dVelocityMax)+'): ';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
   end;
  Sleep(100);

{$IFDEF OLD_START}
  CodeSite.Send(sFunc+'MoveLIMIT start');
  nRet := MoveLIMIT(MotionParam,False{bIsPlus},True{bSyncMaster});
  if (nRet <> AXHS.AXT_RT_SUCCESS) then begin
    m_sErrLibApi := sFunc+'MoveLIMIT: Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;
  CodeSite.Send(sFunc+'MoveLIMIT end');
{$ENDIF} // OLD_START

  if bUseSoftLimitMinus then begin  //-----------------------------------------

    CodeSite.Send(sFunc+'MoveLIMIT2SoftLimtMinus: start');
    AxmStatusGetCmdPos(m_nAxisNo, @dCmdPos{position}); //CH-1 Y
    CodeSite.Send(sFunc+'AxmStatusGetCmdPos(AxisNo='+IntToStr(m_nAxisNo)+'):'+Format('%0.2f',[dCmdPos]));

    dVel   := MotionParam.dJogVelocity / 2;
    dAccel := MotionParam.dJogAccel / 2;
  //dVel   := dVel * -1;
    //
    nRet := AxmMotSetAbsRelMode(m_nAxisNo, 0{uAbsRelMode:0=Abs,1=Rel});
    if nRet <> AXHS.AXT_RT_SUCCESS then begin
      sTemp := 'AxmMotSetAbsRelMode(AxisNo='+IntToStr(m_nAxisNo)+',0=Abs): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;
    //
    nRet := AxmMoveStartPos(m_nAxisNo, MotionParam.dSoftLimitMinus, dVel, dAccel, dAccel);
    if nRet <> AXT_RT_SUCCESS then begin
      sTemp := 'AxmMoveStartPos(AxisNo='+IntToStr(m_nAxisNo)+',dAbsPos='+FloatToStr(MotionParam.dSoftLimitMinus)+',dVel='+FloatToStr(dVel)+',dAcc='+FloatToStr(dAccel)+',dDeacc='+FloatToStr(dAccel)+'): ';
      m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;

    repeat
      nRet := AxmStatusReadInMotion(m_nAxisNo, @uStatus{0=Not in-motion, 1=In-motion});
      if (nRet <> AXHS.AXT_RT_SUCCESS) then uStatus := 1;
      Sleep(100);
    until uStatus = 0;
    CodeSite.Send(sFunc+'MoveLIMIT2SoftLimtMinus: end');

  end

  else begin   //-----------------------------------------

    nRet := AxmSignalSetSoftLimit(m_nAxisNo, 0{uUse:0=NotUsed,1=Used}, 0{uStopMode:0=EStop,1:SStop},0{uSelection:0=CmdPos,1=ActPos}, MotionParam.dSoftLimitPlus, MotionParam.dSoftLimitMinus);
    if (nRet <> AXT_RT_SUCCESS) then begin	// AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_INVALID_AXIS_NO
	  nRet := AxmSignalSetSoftLimit(m_nAxisNo, 0{uUse:0=NotUsed,1=Used}, 0{uStopMode:0=EStop,1:SStop},0{uSelection:0=CmdPos,1=ActPos}, MotionParam.dSoftLimitPlus, MotionParam.dSoftLimitMinus);
      if (nRet <> AXT_RT_SUCCESS) then begin
        sTemp := 'MoveLIMIT2SignalLimtMinus: AxmSignalSetSoftLimit(dSoftLimitUse=0{NotUse},uStopMode:0{EStop},uSelection:0{CmdPos})';
        m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
        CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
      end;
    end;
    Sleep(100);

	  CodeSite.Send(sFunc+'MoveLIMIT2SignalLimtMinus: MoveLIMIT: ...start');
    nRet := MoveLIMIT(MotionParam,False{bIsPlus},True{bSyncMaster});
    if (nRet <> AXHS.AXT_RT_SUCCESS) then begin
      m_sErrLibApi := sFunc+'MoveLIMIT2SignalLimtMinus: MoveLIMIT: Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
      Exit(nErrCode);
    end;
		CodeSite.Send(sFunc+'MoveLIMIT2SignalLimtMinus: MoveLIMIT: ...end');
    Sleep(100);

  end;

  CodeSite.Send(sFunc+'MoveLIMIT2SignalLimtMinus: MoveJOG: ...start');
  nRet := AxmMoveVel(m_nAxisNo, 50.0{dJogVel},100.0{dJogAccel},100.0{dJogAccel}); //TBD:2021-05-31
  if (nRet <> AXHS.AXT_RT_SUCCESS) then begin
    m_sErrLibApi := sFunc+'MoveLIMIT2SignalLimtMinus: MoveJOG(Error='+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
  //Exit(nErrCode);
  end;
  Sleep(400); //TBD:2021-05-31
  AxmMoveSStop(m_nAxisNo);
  repeat
    nRet := AxmStatusReadInMotion(m_nAxisNo, @uStatus{0=Not in-motion, 1=In-motion});
    if (nRet <> AXHS.AXT_RT_SUCCESS) then uStatus := 1;
    Sleep(100);
  until uStatus = 0;
	CodeSite.Send(sFunc+'MoveLIMIT2SignalLimtMinus: MoveJOG: ...end');

  try

  //========================================================
  if m_nAxisNo = 0 then begin
    // Sync Mode 해제
    nRet := ResetEGearLinkMode(m_nAxisNo);   //TBD:A2CHv3:MOTION:SYNC-MOVE?
    if nRet <> DefPocb.ERR_OK then begin
      m_sErrLibApi := sFunc+'ResetEGearLinkMode: Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
      Exit(nErrCode);
    end;
    CodeSite.Send(sFunc+'ResetEGearLinkMode');
    //TBD:A2CHv3:MOTION:SYNC-MOVE? SyncNone/SyncNone?
    Sleep(100);
    // Gantry Mode 설정
   	nRet := AxmGantrySetEnable(0{MasterAxisNo}, 1{SlaveAxisNo}, 0{Master축만}, 0{Offset}, 0);
    if nRet <> AXT_RT_SUCCESS then begin
      m_sErrLibApi := sFunc+'AxmGantrySetEnable: Error('+IntToStr(nRet)+')';
      CodeSite.Send(m_sErrLibApi);
      Exit(nErrCode);
    end;
    CodeSite.Send(sFunc+'AxmGantrySetEnable');
    m_bGantryMode := True;  //2021-05-31
    //TBD:A2CHv3:MOTION:SYNC-MOVE? SyncGantryMaster/SyncGantrySlave?
    Sleep(200);
  end;
  //========================================================

	//-------------------------- 원점 검색 전 Method 및 속도 설정
  case m_nAxisType of
    DefMotion.MOTION_AXIS_Y: begin
      //-------------------------- 원점 검색을 위한 각 Step별 속도 설정, 기구에 맞는 속도로 정의
      if Common.MotionInfo.YaxisServoHomeSpeed > 0 then begin
        nRet := AxmHomeSetVel(m_nAxisNo, Common.MotionInfo.YaxisServoHomeSpeed{dVelFirst}, 3{dvelSecond}, 2{dVelThird}, 1{dVelLast}, Common.MotionInfo.YaxisServoHomeAcc{dAccFirst}, Common.MotionInfo.YaxisServoHomeDcc{dAccSecond});
        sTemp := 'AxmHomeSetVel(AxisNo='+IntToStr(m_nAxisNo)+ m_nAxisNo, Common.MotionInfo.YaxisServoHomeSpeed.Tostring + '{dVelFirst},3{dvelSecond},2{dVelThird},1{dVelLast},'+ Common.MotionInfo.YaxisServoHomeAcc.Tostring +'{dAccFirst},'
                  + Common.MotionInfo.YaxisServoHomeDcc.Tostring +'{dAccSecond})';
      end
      else begin
        nRet := AxmHomeSetVel(m_nAxisNo, 10{dVelFirst}, 3{dvelSecond}, 2{dVelThird}, 1{dVelLast}, 1{dAccFirst}, 1{dAccSecond});
        sTemp := 'AxmHomeSetVel(AxisNo='+IntToStr(m_nAxisNo)+'10{dVelFirst},3{dvelSecond},2{dVelThird},1{dVelLast},1{dAccFirst},1{dAccSecond})';
      end;

      if nRet <> AXT_RT_SUCCESS then begin
        m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
        CodeSite.Send(m_sErrLibApi);
		    Exit(nErrCode);
      end;
      {$IF Defined(POCB_A2CHv3)}
      nRet := AxmHomeSetMethod(m_nAxisNo, 0{lHmDir:0=CCW-,1=CW+ ..Sets the direction to execute home search at initial stage}, //TBD:lHmDir?
                    4{lHmSig:0=+EndLimit,1=-EndLimit,4=IN0(ORG)HomeSignal,5=IN1(Zphase),6:IN2,7:IN3 ...Sets the signal to be used for home search},
                    0{dwZphasDetection:0=NotUsed,1=UsedPositiveDir,2=UsedNegativeDir},
               1000.0{dHClrTim: Sets the standby time to clear the command position and the encoder position after home search is completed [per mSec: 1000.0]},
                  0.0{dHOffset: Position at which home will be reset after home search is completed and is moved to mechanical home});
      {$ELSEIF Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
      nRet := AxmHomeSetMethod(m_nAxisNo, 0{lHmDir:0=CCW-,1=CW+ ..Sets the direction to execute home search at initial stage}, //TBD:lHmDir?
                    4{lHmSig:0=+EndLimit,1=-EndLimit,4=IN0(ORG)HomeSignal,5=IN1(Zphase),6:IN2,7:IN3 ...Sets the signal to be used for home search},
                    0{dwZphasDetection:0=NotUsed,1=UsedPositiveDir,2=UsedNegativeDir},
               1000.0{dHClrTim: Sets the standby time to clear the command position and the encoder position after home search is completed [per mSec: 1000.0]},
                  0.0{dHOffset: Position at which home will be reset after home search is completed and is moved to mechanical home});
      {$ELSE}
      nRet := AxmHomeSetMethod(m_nAxisNo, 1{lHmDir:0=CCW-,1=CW+ ..Sets the direction to execute home search at initial stage}, //TBD:lHmDir?
                    4{lHmSig:0=+EndLimit,1=-EndLimit,4=IN0(ORG)HomeSignal,5=IN1(Zphase),6:IN2,7:IN3 ...Sets the signal to be used for home search},
                    0{dwZphasDetection:0=NotUsed,1=UsedPositiveDir,2=UsedNegativeDir},
               1000.0{dHClrTim: Sets the standby time to clear the command position and the encoder position after home search is completed [per mSec: 1000.0]},
                  0.0{dHOffset: Position at which home will be reset after home search is completed and is moved to mechanical home});
      {$ENDIF}
      if nRet <> AXT_RT_SUCCESS then begin
        sTemp := 'AxmHomeSetMethod(AxisNo='+IntToStr(m_nAxisNo)+')';
        m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
        CodeSite.Send(m_sErrLibApi);
		    Exit(nErrCode);
      end;
    end;
    else
      Exit(nErrCode);
  end;
  Sleep(50);
	//-------------------------- 원점검색을 시작한다. 시작하기 전에 원점검색에 필요한 설정이 필요
	// 	- 원점검색 (라이브러리상에서 Thread를 사용하여 검색. 주의: 구동후 칩내의 StartStop Speed가 변할 수 있다)
	nRet := AxmHomeSetStart(m_nAxisNo{axis});
  if nRet <> AXT_RT_SUCCESS then begin
    sTemp := 'AxmHomeSetStart(AxisNo='+IntToStr(m_nAxisNo)+')';
    m_sErrLibApi := sFunc+sTemp+'Error('+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;

  //
  bRun := True;
  while bRun do begin
    AxmHomeGetResult(m_nAxisNo, @uStatus);
    case uStatus of
      AXHS.HOME_SUCCESS:        begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_SUCCESS)'; bRun := False; end;
    //AXHS.HOME_SEARCHING:      begin m_sErrLibApi:='Home search is now in progress'; bRun := False; end;
      AXHS.HOME_ERR_GNT_RANGE:  begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_GNT_RANGE'; bRun := False;end;
      AXHS.HOME_ERR_USER_BREAK: begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_USER_BREAK'; bRun := False; end;
      AXHS.HOME_ERR_VELOCITY:   begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_VELOCITY'; bRun := False; end;
      AXHS.HOME_ERR_AMP_FAULT:  begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_AMP_FAULT'; bRun := False; end;
      AXHS.HOME_ERR_NEG_LIMIT:  begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_NEG_LIMIT'; bRun := False; end;
      AXHS.HOME_ERR_POS_LIMIT:  begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_POS_LIMIT'; bRun := False; end;
      AXHS.HOME_ERR_NOT_DETECT: begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_NOT_DETECT'; bRun := False; end;
      AXHS.HOME_ERR_SETTING:    begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_SETTING'; bRun := False; end;
   	  AXHS.HOME_ERR_SERVO_OFF:  begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_SERVO_OFF'; bRun := False; end;
      AXHS.HOME_ERR_TIMEOUT:    begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_TIMEOUT'; bRun := False; end;
      AXHS.HOME_ERR_FUNCALL:    begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_FUNCALL'; bRun := False; end;
      AXHS.HOME_ERR_COUPLING:   begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':HOME_ERR_COUPLING'; bRun := False; end;
    //AXHS.HOME_ERR_UNKNOWN:    begin m_sErrLibApi:='AxmHomeGetResult('+IntToStr(uStatus)+':Unknown'; bRun := False; end;
      else begin

      end;
    end;
    Sleep(100);
  end;
  CodeSite.Send(m_sErrLibApi);
  if uStatus <> AXHS.HOME_SUCCESS then Exit(uStatus);

  sleep(50);
  repeat
    nRet := AxmStatusReadInMotion(m_nAxisNo, @uStatus{0=Not in-motion, 1=In-motion});
    if (nRet <> AXHS.AXT_RT_SUCCESS) then uStatus := 1;
    Sleep(100);
  until uStatus = 0;

  sleep(400);
  if uStatus = AXHS.HOME_SUCCESS then begin
    //2019-03-13 DEL!!! AxmStatusSetActPos(0,0{position}); //TBD:F2CH:MOTION:AXM?  //CFS20set_actual_position(m_nAxisNo, 0{position});
    //2019-03-13 DEL!!! AxmStatusSetCmdPos(0,0{position}); //TBD:F2CH:MOTION:AXM?  //CFS20set_command_position(m_nAxisNo, 0{position});
  end
  else begin
    CodeSite.Send(m_sErrLibApi);
    //TBD:F2CH:MOTION:AXM?
  end;

  finally
		//========================================================
  	nRet := AxmSignalSetSoftLimit(m_nAxisNo, 1{uUse:0=NotUsed,1=Used}, 0{uStopMode:0=EStop,1:SStop},0{uSelection:0=CmdPos,1=ActPos}, MotionParam.dSoftLimitPlus, MotionParam.dSoftLimitMinus);  //TBD:A2CHv3:MOTION:SYNC-MOVE?
    if (nRet <> AXT_RT_SUCCESS) then begin	// AXT_RT_MOTION_NOT_INITIAL_AXIS_NO, AXT_RT_MOTION_INVALID_AXIS_NO
		  nRet := AxmSignalSetSoftLimit(m_nAxisNo, 1{uUse:0=NotUsed,1=Used}, 0{uStopMode:0=EStop,1:SStop},0{uSelection:0=CmdPos,1=ActPos}, MotionParam.dSoftLimitPlus, MotionParam.dSoftLimitMinus);
      if (nRet <> AXT_RT_SUCCESS) then begin
        sTemp := 'MoveLIMIT2SignalLimtMinus: AxmSignalSetSoftLimit(dSoftLimitUse=1{Used},uStopMode:0{EStop},uSelection:0{CmdPos})';
				m_sErrLibApi 	:= sFunc+'AxmSignalSetSoftLimit(Error='+IntToStr(nRet)+')';
        CodeSite.Send(m_sErrLibApi);
		  //Exit(nErrCode);
      end;
    end;
    //========================================================
    if m_nAxisNo = 0 then begin  //TBD:A2CHv3:MOTION:SYNC-MOVE?
      // Gantry Mode 해제
     	nRet := AxmGantrySetDisable(DefMotion.MOTIONID_AxMC_STAGE1_Y{MasterAxisNo}, DefMotion.MOTIONID_AxMC_STAGE2_Y{SlaveAxisNo});
      if nRet <> AXT_RT_SUCCESS then begin
				nRet := AxmGantrySetDisable(DefMotion.MOTIONID_AxMC_STAGE1_Y{MasterAxisNo}, DefMotion.MOTIONID_AxMC_STAGE2_Y{SlaveAxisNo});
				if nRet <> AXT_RT_SUCCESS then begin
        	m_sErrLibApi := sFunc+'AxmGantrySetDisable: Error('+IntToStr(nRet)+')';
        	CodeSite.Send(m_sErrLibApi);
      	//Exit(nErrCode);  //TBD:A2CHv3:MOTION:SYNC-MOVE?
				end;
      end;
      CodeSite.Send(sFunc+'AxmGantrySetDisable');
      m_bGantryMode := False;  //2021-05-31
      //TBD:A2CHv3:MOTION:SYNC-MOVE?  SyncNone/SyncNone
      Sleep(100);
      // Sync Mode 설정
      nRet := SetEGearLinkMode(DefMotion.AxMC_AXISNO_STAGE1_Y,DefMotion.AxMC_AXISNO_STAGE2_Y,MOTION_SYNCMODE_SLAVE_RATIO);
      if nRet <> DefPocb.ERR_OK then begin
				nRet := SetEGearLinkMode(DefMotion.AxMC_AXISNO_STAGE1_Y,DefMotion.AxMC_AXISNO_STAGE2_Y,MOTION_SYNCMODE_SLAVE_RATIO);
      	if nRet <> DefPocb.ERR_OK then begin
       		m_sErrLibApi := sFunc+'SetEGearLinkMode: Error('+IntToStr(nRet)+')';
        	CodeSite.Send(m_sErrLibApi);
      	//Exit(nErrCode);  //TBD:A2CHv3:MOTION:SYNC-MOVE?
				end;
      end;
      CodeSite.Send(sFunc+'SetEGearLinkMode');
      //TBD:A2CHv3:MOTION:SYNC-MOVE?  SyncLinkMaster/SyncLinkSlave
    end;
    //========================================================
  end;

	CodeSite.Send(sFunc+'...END');
	Result := DefPocb.ERR_OK;
end;
{$ENDIF} //SUPPORT_1CG2PANEL

//******************************************************************************
// procedure/function: TMotionAxm: Set
//		- function TMotionAxm.SetActPos(dActPos: Double): Integer;
//		- function TMotionAxm.SetCmdPos(dCmdPos: Double): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionAxm.SetActPos(dActPos: Double): Integer;
var
	dReadPos    : Double;
begin
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- 현재의 상태에서 외부 위치를 특정 값으로 설정(position = Unit)
	AxmStatusSetActPos(m_nAxisNo, dActPos{position});	//CFS20set_actual_position(m_nAxisNo, dActPos{position});
	//-------------------------- 현재 외부 위치를 조회하여 확인
  AxmStatusGetActPos(m_nAxisNo, @dReadPos{position}); //CFS20get_actual_position(m_nAxisNo);
{$ELSE}
  dReadPos := dActPos;
{$ENDIF}
  //dReadPos := Round(nDoubleVal);
  if Abs(dReadPos - dActPos) > 1 then begin
		//Result := ERR_XXXXXXXX;	//TBD? (MotorAxt: AbnormalCase: ActPos: Write후 Read시 값 다른 경우?)
  end;
	Result := DefPocb.ERR_OK
end;

//------------------------------------------------------------------------------
function TMotionAxm.SetCmdPos(dCmdPos: Double): Integer;
var
	dReadPos   : Double;
begin
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- 현재의 상태에서 내부 위치를 특정 값으로 설정(position = Unit)
	AxmStatusSetCmdPos(m_nAxisNo, dCmdPos{position});
  //CodeSite.Send('SetCmdPos:'+FloatToStr(dCmdPos));
	//-------------------------- 현재 내부 위치를 조회하여 확인
  AxmStatusGetCmdPos(m_nAxisNo, @dReadPos{position});
{$ELSE}
  dReadPos := dCmdPos;
{$ENDIF}
  //CodeSite.Send('GetCmdPos:'+FloatToStr(dReadPos));
  //dReadPos   := Round(nDoubleVal);
  if Abs(dReadPos - dCmdPos) > 1 then begin
		//Result := ERR_XXXXXXXX;	//TBD? (MotorAxt: AbnormalCase: CmdPos: Write후 Read시 값 다른 경우?)
  end;
	Result := DefPocb.ERR_OK
end;

//******************************************************************************
// procedure/function: TMotionAxm: Get Motor
//		- function TMotionAxm.GetActPos(var dCmdPos: Double): Integer;
//		- function TMotionAxm.GetCmdPos(var dCmdPos: Double): Integer;
//		- function TMotionAxm.IsMotorHome: Boolean;
//		- function TMotionAxm.IsMotorMoving: Boolean;
//    - function TMotionAxm.Get
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionAxm.GetActPos(var dActPos: Double): Integer;
begin
	m_sErrLibApi 	:= '';
//nErrCode 			:= DefPocb.ERR_MOTION_GET_ACT_POS;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- 현재의 상태에서 외부 위치를 특정 값으로 확인(position = Unit)
  AxmStatusGetCmdPos(m_nAxisNo, @dActPos{position});  //CFS20get_actual_position(m_nAxisNo);
{$ENDIF}
	Result  := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxm.GetCmdPos(var dCmdPos: Double): Integer;
begin
	m_sErrLibApi 	:= '';
//nErrCode 			:= DefPocb.ERR_MOTION_GET_CMD_POS;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- 현재의 상태에서 내부 위치를 특정 값으로 확인(position = Unit)
  AxmStatusGetCmdPos(m_nAxisNo, @dCmdPos{position});  //CFS20get_command_position(m_nAxisNo);
{$ENDIF}
	Result  := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxm.IsMotionMoving: Boolean;
var
  dStatus : DWORD;
begin
  if (not m_bConnected) then begin
		Exit(False);
  end;
  Result := False;
	//-------------------------- 지정 축의 펄스 출력중인지를 확인
  if AxmStatusReadInMotion(m_nAxisNo, @dStatus{0=Not-InMotion,1=InMotion}) = AXHS.AXT_RT_SUCCESS then begin  //CFS20in_motion(m_nAxisNo)
    if dStatus = 0 then Result := False
    else                Result := True;
  end;
end;

//------------------------------------------------------------------------------
function TMotionAxm.IsMotionAlarmOn: Boolean;
var
  MechSignal : WORD;
begin
  if (not m_bConnected) then begin
    Exit(True);
  end;
  //--------------------------
  Result := False;
{$IFNDEF SIMULATOR_MOTION}
  if  AxmStatusReadMechanical(m_nAxisNo, @MechSignal) = AXHS.AXT_RT_SUCCESS then begin
    if (MechSignal and (1 shl 4)) <> 0 then begin
      Result := True;
    end;
  end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
function TMotionAxm.GetMotionStatus(var MotionStatus: MotionStatusRec): Boolean;
var
  nRet        : DWORD;
  tempDouble  : Double;
  tempInt     : LongInt;
  tempDWord   : DWORD;
//{$IFDEF SIMULATOR_MOTION}
  MotionParam : RMotionParam;
//{$ENDIF}
  {$IFDEF SUPPORT_1CG2PANEL}
  nSlaveAxisRead : LongInt;
  dSlaveRatio    : Double;
  {$ENDIF}
begin
  //-------------------------- Motor 제어 연결 상태 확인 (TBD?)
  if (not m_bConnected) then begin
		Exit(False);
  end;
//{$IFDEF SIMULATOR_MOTION}
  Common.GetMotionParam(m_nMotionID,MotionParam);
//{$ENDIF}

  //----- 구동 설정 초기화
  // Unit/Pulse 설정
{$IFNDEF SIMULATOR_MOTION}
	nRet := AxmMotGetMoveUnitPerPulse(m_nAxisNo, @tempDouble{dUnit}, @tempInt{dPulse});	//CFS20set_moveunit_perpulse(m_nAxisNo, MotionParam.dUnitPerPulse{unitperpulse});
                              //    Unit/Pulse : 1 pulse에 대한 system의 이동거리 (Unit의 기준은 사용자가 임의로 생각)
                              // Ex) Ball screw pitch : 10mm, 모터 1회전당 펄스수 : 10000
                              //      ==> Unit을 mm로 생각할 경우 : Unit/Pulse = 10/10000.
                              //      따라서 unitperpulse에 0.001을 입력하면 모든 제어단위가 mm로 설정됨.
                              // Ex) Linear motor의 분해능이 1 pulse당 2 uM.
                              //      ==> Unit을 mm로 생각할 경우 : Unit/Pulse = 0.002/1
  if (nRet = AXT_RT_SUCCESS) then begin
    if tempInt <> 0 then  MotionStatus.UnitPerPulse := tempDouble / tempInt  // uUnit / dPulse
    else                  MotionStatus.UnitPerPulse := 0;
  end
  else begin
    m_sErrLibApi := 'AxmMotGetMoveUnitPerPulse(Return='+IntToStr(nRet)+')(Error='+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    MotionStatus.UnitPerPulse := MotionParam.dUnitPerPulse;
  end;
{$ELSE}
  MotionStatus.UnitPerPulse := MotionParam.dUnitPerPulse;
{$ENDIF}
  // 시작 속도 설정 (Unit/Sec)
{$IFNDEF SIMULATOR_MOTION}
//2019-03-23:NOT-USED  nRet := AxmMotGetMinVel(m_nAxisNo, @tempDouble{dMinVel});  //CFS20get_startstop_speed(m_nAxisNo);
//2019-03-23:NOT-USED  if (nRet = AXT_RT_SUCCESS) then
//2019-03-23:NOT-USED    MotionStatus.StartStopSpeed := tempDouble
//2019-03-23:NOT-USED  else begin
//2019-03-23:NOT-USED    m_sErrLibApi := 'AxmMotGetMinVel(Return='+IntToStr(nRet)+')(Error='+IntToStr(nRet)+')';
//2019-03-23:NOT-USED    CodeSite.Send(m_sErrLibApi);
//2019-03-23:NOT-USED    MotionStatus.StartStopSpeed := MotionParam.dStartStopSpeed;
//2019-03-23:NOT-USED  end;
{$ELSE}
  MotionStatus.StartStopSpeed := MotionParam.dStartStopSpeed;
{$ENDIF}
  // 최고 속도 설정 (Unit/Sec, 제어 system의 최고 속도)
{$IFNDEF SIMULATOR_MOTION}
//2019-03-23:NOT-USED  nRet := AxmMotGetMaxVel(m_nAxisNo, @tempDouble{dMinVel});  //CFS20get_max_speed(m_nAxisNo);
//2019-03-23:NOT-USED  if (nRet = AXT_RT_SUCCESS) then
//2019-03-23:NOT-USED    MotionStatus.MaxSpeed := tempDouble
//2019-03-23:NOT-USED  else begin
//2019-03-23:NOT-USED    m_sErrLibApi := 'AxmMotGetMaxVel(Return='+IntToStr(nRet)+')(Error='+IntToStr(nRet)+')';
//2019-03-23:NOT-USED    CodeSite.Send(m_sErrLibApi);
//2019-03-23:NOT-USED    MotionStatus.MaxSpeed := MotionParam.dVelocityMax;
//2019-03-23:NOT-USED  end;
{$ELSE}
  MotionStatus.MaxSpeed := MotionParam.dVelocityMax;
{$ENDIF}
  //----- 구동 상태 확인
  // 지정 축의 펄스 출력중인지
{$IFNDEF SIMULATOR_MOTION}
  nRet := AxmStatusReadInMotion(m_nAxisNo, @tempDWord{dStatus:0=Not-InMotion,1=InMotion});  //CFS20in_motion(m_nAxisNo)
  if nRet = AXHS.AXT_RT_SUCCESS then begin  //CFS20in_motion(m_nAxisNo)
    if tempDWord = 0 then MotionStatus.IsInMotion := False
    else                  MotionStatus.IsInMotion := True;
  end
  else begin
    m_sErrLibApi := 'AxmStatusReadInMotion(Error='+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    MotionStatus.IsInMotion := False;     //TBD:MOTION:AXM?
  end;
{$ELSE}
  MotionStatus.IsInMotion := False;
{$ENDIF}
  // 지정 축의 펄스 출력이 종료됐는지
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.IsMotionDone := (not MotionStatus.IsInMotion); //CFS20motion_done(m_nAxisNo);  //TBD:MOTION:AXM?
{$ELSE}
  MotionStatus.IsMotionDone := True;
{$ENDIF}
  // 지정 축의 EndStatus 레지스터를 확인
{$IFNDEF SIMULATOR_MOTION}
  nRet := AxmStatusReadMotion(m_nAxisNo, @tempDWord{dStatus});  //CFS20get_end_status(m_nAxisNo)
                              //  - AXT AxmMC End Status Bit별 의미
                              //      [00000001h] Bit 0, BUSY (In DRIVE)
                              //      [00000002h] Bit 1, DOWN (In Deceleration)
                              //      [00000004h] Bit 2, CONST(In Constant Velocity)
                              //      [00000008h] Bit 3, UP(In Acceleration)
                              //      [00000010h] Bit 4, In Continuous Drive is in move
                              //      [00000020h] Bit 5, In Preset Distance Drive is in move
                              //      [00000040h] Bit 6, In MPG Drive is in move
                              //      [00000080h] Bit 7, In Home Search Drive is in move
                              //      [00000100h] Bit 8, In Signal Search Drive is in move
                              //      [00000200h] Bit 9, In Interpolation Drive is in move
                              //      [00000400h] Bit 10, In Slave Drive is in move
                              //      [00000800h] Bit 11, Currently Moving Drive Direction (Display information is different on interpolation drive)
                              //      [00001000h] Bit 12, Waiting for Servo Position Exit Signal after Pulse Out
                              //      [00002000h] Bit 13, In Linear Interpolation Drive is in move
                              //      [00004000h] Bit 14, In Circular Interpolation Drive is in move
                              //      [00008000h] Bit 15, In Pulse Out
                              //      [00010000h] Bit 16, Number of Moving-Reserved Data(Start)(0-7)
                              //      [00020000h] Bit 17, Number of Moving-Reserved Data(Middle)(0-7)
                              //      [00040000h] Bit 18, Number of Moving-Reserved Data(End)(0-7)
                              //      [00080000h] Bit 19, Moving-Reserved Queue is empty
                              //      [00100000h] Bit 20, Moving-Reserved Queue is full
                              //      [00200000h] Bit 21, Velocity mode of current moving drive(Start)
                              //      [00400000h] Bit 22, Velocity mode of current moving drive (End)
                              //      [00800000h] Bit 23, MPG Buffer #1 Full
                              //      [01000000h] Bit 24, MPG Buffer #2 Full
                              //      [02000000h] Bit 25, MPG Buffer #3 Full
                              //      [04000000h] Bit 26, MPG Buffer Data OverFlow
  if nRet = AXHS.AXT_RT_SUCCESS then begin
    MotionStatus.EndStatus := tempDWord
  end
  else begin
    m_sErrLibApi := 'AxmStatusReadMotion(Error='+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    //TBD:MOTION:AXM?
  end;
{$ELSE}
  MotionStatus.EndStatus := $00;  //TBD:SIM:MOTION?
{$ENDIF}
  // 지정 축의 Mechanical 레지스터
{$IFNDEF SIMULATOR_MOTION}
  nRet := AxmStatusReadMechanical(m_nAxisNo, @tempDWord{dStatus}); //CFS20get_mechanical_signal(m_nAxisNo))
                              //  - AXT AxtMC Mechanical Signal Bit별 의미
                              //      12bit : ESTOP 신호 입력 Level
                              //      11bit : SSTOP 신호 입력 Level
                              //      10bit : MARK 신호 입력 Level
                              //      9 bit : EXPP(MPG) 신호 입력 Level
                              //      8 bit : EXMP(MPG) 신호 입력 Level
                              //      7 bit : Encoder Up신호 입력 Level(A상 신호)
                              //      6 bit : Encoder Down신호 입력 Level(B상 신호)
                              //      5 bit : INPOSITION 신호 Active 상태
                              //      4 bit : ALARM 신호 Active 상태
                              //      3 bit : -Limit 감속정지 신호 Active 상태 (Ver3.0부터 사용되지않음)
                              //      2 bit : +Limit 감속정지 신호 Active 상태 (Ver3.0부터 사용되지않음)
                              //      1 bit : -Limit 급정지 신호 Active 상태
                              //      0 bit : +Limit 급정지 신호 Active 상
                              //  - AXT AxmMC Mechanical Signal Bit별 의미
                              //      12bit : ....
                              //      11bit : EXPP terminal signal state
                              //      10bit : ECDN terminal signal state
                              //      9 bit : ECUP terminal signal state
                              //      8 bit : Z phase input signal current state
                              //      7 bit : Home signal current state
                              //      6 bit : Emergency stop signal (ESTOP) current state
                              //      5 bit : InPos signal current state
                              //      4 bit : Alarm signal current state
                              //      3 bit : -limit deceleration stop current state
                              //      2 bit : +limit deceleration stop current state
                              //      1 bit : -Limit emergency stop signal current state
                              //      0 bit : +Limit emergency stop signal current state
  if nRet = AXHS.AXT_RT_SUCCESS then begin  //CFS20in_motion(m_nAxisNo)
    MotionStatus.MechSignal := tempDWord;
    //
    if (MotionStatus.MechSignal and (1 shl 0)) <> 0 then MotionStatus.bMechSignalLimitPlusOn  := True
    else                                                 MotionStatus.bMechSignalLimitPlusOn  := False;
    if (MotionStatus.MechSignal and (1 shl 1)) <> 0 then MotionStatus.bMechSignalLimitMinusOn := True
    else                                                 MotionStatus.bMechSignalLimitMinusOn := False;
    if (MotionStatus.MechSignal and (1 shl 4)) <> 0 then MotionStatus.bMechSignalAlarmOn      := True
    else                                                 MotionStatus.bMechSignalAlarmOn      := False;
  end
  else begin
    m_sErrLibApi := 'AxmStatusReadMechanical(Error='+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    //TBD:MOTION:AXM?
  end;
{$ELSE}
  MotionStatus.MechSignal := (1 shl 5);   //TBD:SIM:MOTION?
{$ENDIF}
  //----- 위치 확인
  // 외부 위치 값 (position: Unit)
{$IFNDEF SIMULATOR_MOTION}
//2019-03-23:NOT-USED  nRet := AxmStatusGetActPos(m_nAxisNo, @tempDouble{dActPos});  //CFS20get_actual_position(m_nAxisNo);
//2019-03-23:NOT-USED  if nRet = AXHS.AXT_RT_SUCCESS then begin  //CFS20in_motion(m_nAxisNo)
//2019-03-23:NOT-USED    MotionStatus.ActualPos := tempDouble
//2019-03-23:NOT-USED  end
//2019-03-23:NOT-USED  else begin
//2019-03-23:NOT-USED    m_sErrLibApi := 'AxmStatusGetActPos(Error='+IntToStr(nRet)+')';
//2019-03-23:NOT-USED    CodeSite.Send(m_sErrLibApi);
//2019-03-23:NOT-USED  end;
{$ELSE}
//MotionStatus.ActualPos := $00;   //TBD:SIM:MOTION?
{$ENDIF}
  // 내부 위치 값 (position: Unit)
{$IFNDEF SIMULATOR_MOTION}
  nRet := AxmStatusGetCmdPos(m_nAxisNo, @tempDouble{dCmdPos});  //CFS20get_command_position(m_nAxisNo);
  if nRet = AXHS.AXT_RT_SUCCESS then begin
    MotionStatus.CommandPos := tempDouble;
  end
  else begin
    m_sErrLibApi := 'AxmStatusGetCmdPos(Error='+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    //TBD:MOTION:AXM?
  end;
{$ELSE}
  case m_nMotionID of
  {$IFDEF HAS_MOTION_CAM_Z}
    DefMotion.MOTIONID_AxMC_STAGE1_Z: MotionStatus.CommandPos := MotionParam.dConfigZModelPos;
    DefMotion.MOTIONID_AxMC_STAGE2_Z: MotionStatus.CommandPos := MotionParam.dConfigZModelPos;
  {$ENDIF}
    DefMotion.MOTIONID_AxMC_STAGE1_Y: MotionStatus.CommandPos := MotionParam.dConfigYLoadPos;
    DefMotion.MOTIONID_AxMC_STAGE2_Y: MotionStatus.CommandPos := MotionParam.dConfigYLoadPos;
  {$IFDEF HAS_MOTION_TILTING}
    DefMotion.MOTIONID_AxMC_STAGE1_T: MotionStatus.CommandPos := MotionParam.dConfigTFlatPos;
    DefMotion.MOTIONID_AxMC_STAGE2_T: MotionStatus.CommandPos := MotionParam.dConfigTFlatPos;
  {$ENDIF}
  end;
{$ENDIF}
{$IFNDEF SIMULATOR_MOTION}
  nRet := AxmStatusReadPosError(m_nAxisNo, @tempDouble{dPosError});  //CFS20get_error(m_nAxisNo);
  if nRet = AXHS.AXT_RT_SUCCESS then begin
    MotionStatus.ActCmdPosDiff := tempDouble;
  end
  else begin
    m_sErrLibApi := 'AxmStatusReadPosError(Error='+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    MotionStatus.ActCmdPosDiff := 0.0;
  end;
{$ELSE}
  MotionStatus.ActCmdPosDiff := 0.0;
{$ENDIF}
  //----- 서보 드라이버
  // 서보 Enable(On) / Disable(Off)
{$IFNDEF SIMULATOR_MOTION}
//MotionStatus.ServoEnable := CFS20get_servo_enable(m_nAxisNo);
{$ELSE}
//MotionStatus.ServoEnable := 1; //TBD:SIM:MOTION?
{$ENDIF}
  // 서보 위치결정완료(inposition)입력 신호의 사용유무
{$IFNDEF SIMULATOR_MOTION}
//MotionStatus.UseInPosSig := CFS20get_inposition_enable (m_nAxisNo);
{$ELSE}
//MotionStatus.UseInPosSig := 0;  //TBD:SIM:MOTION?
{$ENDIF}
  // 서보 알람 입력신호 기능의 사용유무
{$IFNDEF SIMULATOR_MOTION}
//MotionStatus.UseAlarmSig := CFS20get_alarm_enable(m_nAxisNo);
{$ELSE}
//MotionStatus.UseAlarmSig := 0; //TBD:SIM:MOTION?
{$ENDIF}
  //----- 범용 입출력
{$IFNDEF SIMULATOR_MOTION}
  nRet := AxmSignalReadInput(m_nAxisNo, @tempDWord);  //CFS20get_input (m_nAxisNo);
                              // AXT AxmMC Universal Input Signal
                              //      0 bit : Home Signal
                              //      1 bit : Encoder Z phase Signal
                              //      2 bit : Univesal Input Signal
                              //      3 bit : WorkPosition (for )Y-axis only) //2019-03-08 F2CH
                              //      4 bit : Univesal Input Signal
                              // AXT AxtMC Universal Input Signal
                              //      0 bit : 범용 입력 0(ORiginal Sensor)
                              //      1 bit : 범용 입력 1(Z phase)
                              //      2 bit : 범용 입력 2
                              //      3 bit : 범용 입력 3
                              //      4 bit(PLD) : 범용 입력 5
                              //      5 bit(PLD) : 범용 입력 6
                              //        On ==> 단자대 N24V, 'Off' ==> 단자대 Open(float).
  if nRet = AXHS.AXT_RT_SUCCESS then begin
    MotionStatus.UnivInSignal := tempDWord;
    //
    if (MotionStatus.UnivInSignal and (1 shl 0)) <> 0 then MotionStatus.bUnivInSignalHomeOn  := True
    else                                                   MotionStatus.bUnivInSignalHomeOn  := False;
    if (MotionStatus.UnivInSignal and (1 shl 2)) <> 0 then MotionStatus.bUnivInSignalServoOn := True
    else                                                   MotionStatus.bUnivInSignalServoOn := False;
{$IFDEF POCB_A2CH}}
    if (MotionStatus.UnivInSignal and (1 shl 0)) <> 0 then MotionStatus.bUnivInSignalLoadPosOn := True
{$ELSE}
    if (MotionStatus.UnivInSignal and (1 shl 3)) <> 0 then MotionStatus.bUnivInSignalLoadPosOn := True
{$ENDIF}
    else                                                   MotionStatus.bUnivInSignalLoadPosOn := False;
  end
  else begin
    m_sErrLibApi := 'AxmSignalReadInput(Error='+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    //TBD:MOTION:AXM?
  end;
{$ELSE}
  MotionStatus.UnivInSignal := {(1 shl 0) or} (1 shl 1) or (1 shl 2);      //TBD:SIM:MOTION?
{$ENDIF}
{$IFNDEF SIMULATOR_MOTION}
  nRet := AxmSignalReadOutput(m_nAxisNo, @tempDWord);  //CFS20get_output(m_nAxisNo);
                              // AXT AxmMC Universal Output Signal
                              //      0 bit : Servo-On
                              //      1 bit : Alarm Clear
                              //      2~4 bit : General-purpose Output Signal
                              // AXT AxtMC Universal Output Signal
                              //      0 bit : Servo-On
                              //      1 bit : Alarm Clear
                              //      2 bit : 범용 출력 2
                              //      3 bit : 범용 출력 3
                              //      4 bit(PLD) : 범용 출력 4
                              //      5 bit(PLD) : 범용 출력 5
  if nRet = AXHS.AXT_RT_SUCCESS then begin
    MotionStatus.UnivOutSignal := tempDWord;
    if (MotionStatus.UnivOutSignal and (1 shl 0)) <> 0 then MotionStatus.bUnivOutSignalServoOn := True
    else                                                    MotionStatus.bUnivOutSignalServoOn := False;
  end
  else begin
    m_sErrLibApi := 'AxmSignalReadOutput(Error='+IntToStr(nRet)+')';
    CodeSite.Send(m_sErrLibApi);
    //TBD:MOTION:AXM?
  end;
{$ELSE}
  MotionStatus.UnivOutSignal := (1 shl 0);      //TBD:SIM:MOTION?;
{$ENDIF}
  //--------------------------
{$IFDEF SUPPORT_1CG2PANEL}
  if m_bGantryMode then begin
    if (m_nAxisNo = DefMotion.AxMC_AXISNO_STAGE1_Y) then begin
      MotionStatus.nSyncStatus         := DefMotion.SyncGantryMaster;
      MotionStatus.nSyncOtherAxis      := DefMotion.AxMC_AXISNO_STAGE2_Y;
    end
    else begin
      MotionStatus.nSyncStatus         := DefMotion.SyncGantrySlave;
      MotionStatus.nSyncOtherAxis      := DefMotion.AxMC_AXISNO_STAGE1_Y;
    end;
  end
  else begin
    nRet := GetEGearLinkMode(DefMotion.AxMC_AXISNO_STAGE1_Y,nSlaveAxisRead,dSlaveRatio);
    case nRet of
      DefPocb.ERR_OK : begin
        if (nSlaveAxisRead = MOTION_SYNCMODE_SLAVE_UNKNOWN) then begin
          MotionStatus.nSyncStatus := DefMotion.SyncNone;
        end
        else if (nSlaveAxisRead = DefMotion.AxMC_AXISNO_STAGE2_Y) then begin
          if (m_nAxisNo = DefMotion.AxMC_AXISNO_STAGE1_Y) then begin
            MotionStatus.nSyncStatus       := DefMotion.SyncLinkMaster;
            MotionStatus.nSyncOtherAxis    := DefMotion.AxMC_AXISNO_STAGE2_Y;
          end
          else begin
            MotionStatus.nSyncStatus       := DefMotion.SyncLinkSlave;
            MotionStatus.nSyncOtherAxis    := DefMotion.AxMC_AXISNO_STAGE1_Y;
          end;
          MotionStatus.dSyncLinkSlaveRatio := dSlaveRatio;
        end
        else begin
          MotionStatus.nSyncStatus := DefMotion.SyncUnknown;  //TBD:A2CHv3:MOTION:SYNC-MOVE? (Abnormal Case)
        end;
      end;
      DefPocb.ERR_MOTION_SYNCMODE_GET : begin
        //TBD?
      end;
    end;
  end;
{$ENDIF} //SUPPORT_1CG2PANEL
  //--------------------------
  Result := True;
end;

//******************************************************************************
// procedure/function: TMotionAxm: SyncMode
//		-
//		-
//******************************************************************************
{$IFDEF SUPPORT_1CG2PANEL}
function TMotionAxm.SetEGearLinkMode(nMasterAxis, nSlaveAxis: LongInt; dSlaveRatio: Double): Integer;  //TBD:A2CHv3:MOTION:SYNC-MOVE?
var
	nApiRtn  : DWORD;
	nErrCode : Integer;
begin
	m_sErrLibApi := Format('MotionAxm.SetEGearLinkMode(MasterAxis=%d,SlaveAxis=%d,SlaveRatio=%f)',[nMasterAxis,nSlaveAxis,dSlaveRatio]);
	nErrCode 		 := DefPocb.ERR_MOTION_SYNCMODE_SET;
  //-------------------------- Check Command param
  if (m_nAxisNo <> nMasterAxis) and (m_nAxisNo <> nSlaveAxis) then begin //TBD:A2CHv3:MOTION:SYNC-MOVE?
    m_sErrLibApi := m_sErrLibApi+Format(': Failed(Master/Slave <> MyAxis=%d)',[m_nAxisNo]);
    CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;
  if (nMasterAxis = nSlaveAxis) then begin //TBD:A2CHv3:MOTION:SYNC-MOVE?
    m_sErrLibApi := m_sErrLibApi+': Failed(Master=Slave)';
    CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;
  if (dSlaveRatio <> DefMotion.MOTION_SYNCMODE_SLAVE_RATIO) then begin //TBD:A2CHv3:MOTION:SYNC-MOVE?
    m_sErrLibApi := m_sErrLibApi+': Failed(Invalid SlaveRatio<>1.0)';
    CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //TBD:A2CHv3:MOTION:SYNC-MOVE? (추가 확인 필요한 것들은?)
	//--------------------------
  {$IFNDEF SIMULATOR_MOTION}
  nApiRtn := AxmLinkSetMode(nMasterAxis,nSlaveAxis,dSlaveRatio);
    // [0000] AXT_RT_SUCCESS : 함수 실행 성공
    // [4160] AXT_RT_ERROR_NOT_SAME_BOARD : 똑같은 보드 내에 있지 않을 경우
    // [4163] AXT_RT_ERROR_NOT_SAME_IC : 같은 칩 내에 존재하지 않을 때
  {$ELSE}
  if (m_nSimSyncStatus = SyncNone) then begin
    nApiRtn := AXT_RT_SUCCESS;
  end
  else begin
    nApiRtn := AXT_RT_MOTION_INVALID_AXIS_NO; //TBD:A2CHv3:MOTION_SYNC
  end;
  {$ENDIF}
  if nApiRtn <> AXT_RT_SUCCESS then begin
    nApiRtn := AxmLinkSetMode(nMasterAxis,nSlaveAxis,dSlaveRatio);
    if nApiRtn <> AXT_RT_SUCCESS then begin
	    m_sErrLibApi := m_sErrLibApi+Format(': AxmLinkSetMode: Error(ErrCode=%d)',[nApiRtn]);
      CodeSite.Send(m_sErrLibApi);
		  Exit(nErrCode);
    end;
  end;
  m_sErrLibApi := m_sErrLibApi+Format(': AxmLinkSetMode: OK(ErrCode=%d)',[nApiRtn]);
  CodeSite.Send(m_sErrLibApi);

  {$IFDEF SIMULATOR_MOTION}
  if (m_nAxisNo = nMasterAxis) then begin
    m_nSimSyncStatus     := DefMotion.SyncLinkMaster;
    m_nSimSyncSlaveAxis  := nSlaveAxis;
    m_dSimSyncSlaveRatio := dSlaveRatio;
  end;
  {$ENDIF}

	Result := DefPocb.ERR_OK;
end;

//
function TMotionAxm.ResetEGearLinkMode(nMasterAxis: LongInt): Integer;  //TBD:A2CHv3:MOTION:SYNC-MOVE?
var
	nApiRtn  : DWORD;
	nErrCode : Integer;
begin
	m_sErrLibApi := Format('TMotionAxm.ResetEGearLinkMode(MasterAxis=%d)',[nMasterAxis]);;
	nErrCode 		 := DefPocb.ERR_MOTION_SYNCMODE_RESET;
  if (m_nAxisNo <> nMasterAxis) then begin //TBD:A2CHv3:MOTION:SYNC-MOVE?
    m_sErrLibApi := m_sErrLibApi+Format(': Failed(MasterAxis <> MyAxis=%d)',[m_nAxisNo]);
    CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //TBD:A2CHv3:MOTION:SYNC-MOVE? (추가 확인 필요한 것들은?)
	//-------------------------- Reset SyncMode
  {$IFNDEF SIMULATOR_MOTION}
  nApiRtn := AxmLinkResetMode(nMasterAxis);
    // [0000] AXT_RT_SUCCESS : 함수 실행 성공
    // [4053] AXT_RT_MOTION_NOT_INITIAL_AXIS_NO : 해당 축 모션 초기화 실패
    // [4101] AXT_RT_MOTION_INVALID_AXIS_NO : 해당 축이 존재하지 않음
  {$ELSE}
  if m_nSimSyncStatus = SyncLinkMaster then begin
    nApiRtn := AXT_RT_SUCCESS;
  end
  else begin
    nApiRtn := AXT_RT_MOTION_INVALID_AXIS_NO; //TBD:A2CHv3:MOTION_SYNC
  end;
  {$ENDIF}
  if nApiRtn = AXT_RT_SUCCESS then begin
	  m_sErrLibApi := m_sErrLibApi+Format(': AxmLinkResetMode: OK(ErrCode=%d)',[nApiRtn]);
    CodeSite.Send(m_sErrLibApi);
  end
  else if nApiRtn = AXT_RT_MOTION_INVALID_AXIS_NO then begin  //TBD:A2CHv3:MOTION:SYNC-MOVE? (LinkSet안된 상태에서 return갑 호가인필요!!!)
	  m_sErrLibApi := m_sErrLibApi+Format(': AxmLinkResetMode: OK(ErrCode=%d) TBD???',[nApiRtn]);
    CodeSite.Send(m_sErrLibApi);
	//Exit(DefPocb.ERR_MOTION_RESET_SYNCMODE); //TBD???
  end
  else begin
	  m_sErrLibApi := m_sErrLibApi+Format(': AxmLinkResetMode: Error(ErrCode=%d)',[nApiRtn]);
    CodeSite.Send(m_sErrLibApi);
		Exit(nErrCode);
  end;

  {$IFDEF SIMULATOR_MOTION}
  if (m_nAxisNo = nMasterAxis) then begin
    m_nSimSyncStatus     := DefMotion.SyncNone;
    m_nSimSyncSlaveAxis  := MOTION_SYNCMODE_SLAVE_UNKNOWN;
    m_dSimSyncSlaveRatio := MOTION_SYNCMODE_SLAVE_RATIO;
  end;
  {$ENDIF}

  Result := DefPocb.ERR_OK;
end;

//
function TMotionAxm.GetEGearLinkMode(nMasterAxis: LongInt; var nSlaveAxis: LongInt; var dSlaveRatio: Double): Integer;  //TBD:A2CHv3:MOTION:SYNC-MOVE?
var
	nApiRtn : DWORD;
  sDebug  : string;
begin
	m_sErrLibApi := Format('TMotionAxm.GetEGearLinkMode(MasterAxis=%d)',[nMasterAxis]);
//if (m_nAxisNo <> nMasterAxis) then begin  //TBD:A2CHv3:MOTION:SYNC-MOVE?
//  m_sErrLibApi := m_sErrLibApi+Format(': Failed(MasterAxis is not myAxis=%d)',[m_nAxisNo]);
//  CodeSite.Send(m_sErrLibApi);
//  Exit(DefPocb.ERR_MOTION_SYNCMODE_GET);
//end;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- TBD:A2CHv3:MOTION:SYNC-MOVE? (추가 확인 필요한 것들은?)
  //TBD?
  //-------------------------- Get Motion Device LinkSet Status
  {$IFNDEF SIMULATOR_MOTION}
  nApiRtn := AxmLinkGetMode(nMasterAxis,@nSlaveAxis,@dSlaveRatio);
    // [0000] AXT_RT_SUCCESS : 함수 실행 성공
    // [4053] AXT_RT_MOTION_NOT_INITIAL_AXIS_NO : 해당 축 모션 초기화 실패
    // [4101] AXT_RT_MOTION_INVALID_AXIS_NO : 해당 축이 존재하지 않음
  {$ELSE}
  if m_nSimSyncStatus = DefMotion.SyncLinkMaster then begin
    if m_nAxisNo = DefMotion.AxMC_AXISNO_STAGE1_Y then begin
      nSlaveAxis  := DefMotion.AxMC_AXISNO_STAGE2_Y;
      dSlaveRatio := DefMotion.MOTION_SYNCMODE_SLAVE_RATIO; // 1.0
      nApiRtn := AXT_RT_SUCCESS;
    end
    else begin
      nApiRtn := AXT_RT_MOTION_INVALID_AXIS_NO;  //TBD:A2CHv3:MOTION:SYNC-MOVE? (LinkSet안된 상태혹은 Slave에서 return갑 호가인필요!!!)
    end;
  end
  else begin
    nApiRtn := AXT_RT_MOTION_INVALID_AXIS_NO;  //TBD:A2CHv3:MOTION:SYNC-MOVE? (LinkSet안된 상태에서 return갑 호가인필요!!!)
  end;
  {$ENDIF}
  if nApiRtn = AXT_RT_SUCCESS then begin
	  m_sErrLibApi := m_sErrLibApi+Format(': AxmLinkGetMode: OK(SlaveAxis=%d,SlaveRatio=%f)',[nSlaveAxis,dSlaveRatio]);
  //CodeSite.Send(m_sErrLibApi);
  end
  else if nApiRtn = AXT_RT_MOTION_INVALID_AXIS_NO then begin  //TBD:A2CHv3:MOTION:SYNC-MOVE? (LinkSet안된 상태에서 return갑 호가인필요!!!)
	  m_sErrLibApi := m_sErrLibApi+': AxmLinkGetMode: OK(SlaveAxis=None)';
    CodeSite.Send(m_sErrLibApi);
    nSlaveAxis := MOTION_SYNCMODE_SLAVE_UNKNOWN; // None & ERR_OK
  end
  else begin
	  m_sErrLibApi := m_sErrLibApi+Format(': AxmLinkGetMode: Error(ErrCode=%d)',[nApiRtn]);
    CodeSite.Send(m_sErrLibApi);
    nSlaveAxis := MOTION_SYNCMODE_SLAVE_UNKNOWN; // None & ERR_MOTION_GET_SYNCMODE
		Exit(DefPocb.ERR_MOTION_SYNCMODE_GET);
  end;
  Result := DefPocb.ERR_OK;
end;
{$ENDIF} //SUPPORT_1CG2PANEL

end.

//******************************************************************************
// Ajinextek AXL(AX Library) : AXM (AX Motion)
//******************************************************************************
//
// << Board and module verification API(Info) - Information >> =================
//  - Return board number, module position and module ID of relevant axis.
//      function AxmInfoGetAxis (lAxisNo : LongInt; lpBoardNo : PLongInt; lpModulePos : PLongInt; upModuleID : PDWord) : DWord; stdcall;
//  - Return whether the motion module exists.
//      function AxmInfoIsMotionModule (upStatus : PDWord) : DWord; stdcall;
//  - Return whether relevant axis is valid.
//      function AxmInfoIsInvalidAxisNo (szInvalidAxisNo : PChar) : DWord; stdcall;
//  - Return whether relevant axis status.
//      function AxmInfoGetAxisStatus (lAxisNo : LongInt) : DWord; stdcall;
//  - number of RTEX Products, return number of valid axis installed in system.
//      function AxmInfoGetAxisCount (lpAxisCount : PLongInt) : DWord; stdcall;
//  - Return the first axis number of relevant board/module
//      function AxmInfoGetFirstAxisNo (lBoardNo : LongInt; lModulePos : LongInt; lpAxisNo : PLongInt) : DWord; stdcall;
//    //function AxmInfoGetBoardFirstAxisNo (lBoardNo : LongInt; lModulePos : LongInt; lpAxisNo : PLongInt) : DWord; stdcall;
//
// << virtual axis function >> =================================================
//  - Set virtual axis.
//      function AxmVirtualSetAxisNoMap (lRealAxisNo : LongInt; lVirtualAxisNo : LongInt) : DWord; stdcall;
//  - Return the set virtual channel(axis) number.
//      function AxmVirtualGetAxisNoMap (lRealAxisNo : LongInt; lpVirtualAxisNo : PLongInt) : DWord; stdcall;
//  - Set multi-virtual axes.
//      function AxmVirtualSetMultiAxisNoMap (lSize : LongInt; lpRealAxesNo : PLongInt; lpVirtualAxesNo : PLongInt) : DWord; stdcall;
//  - Return the set multi-virtual channel(axis) number
//      function AxmVirtualGetMultiAxisNoMap (lSize : LongInt; lpRealAxesNo : PLongInt; lpVirtualAxesNo : PLongInt) : DWord; stdcall;
//  - Reset the virtual axis setting.
//      function AxmVirtualResetAxisMap () : DWord; stdcall;
//
// << API related interrupt >> =================================================
//  Call-back API method has the advantage which can be advised the event most fast timing
//    as the call-back API is called immediately when the event occurs, but
//    the main processor shall be congested until the call-back API is completed.
//    i.e, it shall be carefully used when there is any work loaded in the call-bak API.
//    Event method monitors if interrupt occurs continuously by using thread, and when interrupt is occurs
//  it manages, and even though this method has disadvantage which system resource is occupied by thread ,
//  it can detect interrupt most quickly and manage it.
//  It is not used a lot in general, but used when quick management of interrupt is the most concern.
//  Event method is operated using specific thread which monitors the occurrence of event separately from main processor,
//    so it able to use the resources efficiently in multi-processor system and expressly recommendable method.
//  - Window message or call back API is used for getting the interrupt message.
//          (message handle, message ID, call back API, interrupt event)
//      function AxmInterruptSetAxis (lAxisNo : LongInt; hWnd : HWND; uMessage : DWord; pProc : AXT_INTERRUPT_PROC; pEvent : PDWord) : DWord; stdcall;
//          hWnd    : use to get window handle and window message. Enter NULL if it is not used.
//          wMsg    : message of window handle, enter 0 if is not used or default value is used.
//          proc    : API pointer to be called when interrupted, enter NULL if not use
//          pEvent  : Event handle when event method is used.
//  - Set whether to use interrupt of set axis or not.
//  - Set interrupt in the relevant axis/ verification
//      function AxmInterruptSetAxisEnable (lAxisNo : LongInt; uUse : DWord) : DWord; stdcall;
//          uUse : use or not use => DISABLE(0), ENABLE(1)
//  - Return whether to use interrupt of set axis or not
//      function AxmInterruptGetAxisEnable (lAxisNo : LongInt; upUse : PDWord) : DWord; stdcall;
//  - Read relevant information when interrupt is used in event method
//      function AxmInterruptRead (lpAxisNo : PLongInt; upFlag : PDWord) : DWord; stdcall;
//  - Return interrupt flag value of relevant axis.
//      function AxmInterruptReadAxisFlag (lAxisNo : LongInt; lBank : LongInt; upFlag : PDWord) : DWord; stdcall;
//  - Set whether the interrupt set by user to specific axis occurs or not
//      function AxmInterruptSetUserEnable (lAxisNo : LongInt; lBank : LongInt; uInterruptNum : DWord) : DWord; stdcall;
//          lBank         : Enable to set interrupt bank number(0 - 1).
//          uInterruptNum : Enable to set interrupt number by setting bit number( 0 - 31 ).
//  - Verify whether the interrupt set by user of specific axis occurs or not
//      function AxmInterruptGetUserEnable (lAxisNo : LongInt; lBank : LongInt; upInterruptNum : PDWord) : DWord; stdcall;
//
// << Set motion parameter >> ==================================================
// 	If file is not loaded by AxmMotLoadParaAll, set default parameter in initial parameter setting.
// 	Apply to all axes which is being used in PC equally. 
//	Default parameters are as below.
// 			00:AXIS_NO.             =0       01:PULSE_OUT_METHOD.    =4      02:ENC_INPUT_METHOD.    =3     03:INPOSITION.          =2
// 			04:ALARM.               =0       05:NEG_END_LIMIT.       =0      06:POS_END_LIMIT.       =0     07:MIN_VELOCITY.        =1
// 			08:MAX_VELOCITY.        =700000  09:HOME_SIGNAL.         =4      10:HOME_LEVEL.          =1     11:HOME_DIR.            =-1
// 			12:ZPHASE_LEVEL.        =1       13:ZPHASE_USE.          =0      14:STOP_SIGNAL_MODE.    =0     15:STOP_SIGNAL_LEVEL.   =0
// 			16:HOME_FIRST_VELOCITY. =10000   17:HOME_SECOND_VELOCITY.=10000  18:HOME_THIRD_VELOCITY. =2000  19:HOME_LAST_VELOCITY.  =100
// 			20:HOME_FIRST_ACCEL.    =40000   21:HOME_SECOND_ACCEL.   =40000  22:HOME_END_CLEAR_TIME. =1000  23:HOME_END_OFFSET.     =0
// 			24:NEG_SOFT_LIMIT.      =0.000   25:POS_SOFT_LIMIT.      =0      26:MOVE_PULSE.          =1     27:MOVE_UNIT.           =1
// 			28:INIT_POSITION.       =1000    29:INIT_VELOCITY.       =200    30:INIT_ACCEL.          =400   31:INIT_DECEL.          =400
// 			32:INIT_ABSRELMODE.     =0       33:INIT_PROFILEMODE.    =4
// 	00=[AXIS_NO             ]: axis (start from 0axis)
// 	01=[PULSE_OUT_METHOD    ]: Pulse out method TwocwccwHigh = 6
// 	02=[ENC_INPUT_METHOD    ]: disable = 0   1 multiplication = 1  2 multiplication = 2  4 multiplication = 3, for replacing the direction of splicing (-).1 multiplication = 11  2 multiplication = 12  4 multiplication = 13
// 	03=[INPOSITION          ], 04=[ALARM     ], 05,06 =[END_LIMIT   ]  : 0 = A contact 1= B contact 2 = not use. 3 = keep current mode
// 	07=[MIN_VELOCITY        ]: START VELOCITY
// 	08=[MAX_VELOCITY        ]: command velocity which driver can accept. Generally normal servo is 700k
// 			Ex> screw : 20mm pitch drive: 10000 pulse motor: 400w
// 	09=[HOME_SIGNAL         ]: 4 - Home in0 , 0 :PosEndLimit , 1 : NegEndLimit // refer _HOME_SIGNAL.
// 	10=[HOME_LEVEL          ]: : 0 = A contact 1= B contact 2 = not use. 3 = keep current mode
// 	11=[HOME_DIR            ]: HOME DIRECTION 1:+direction, 0:-direction
// 	12=[ZPHASE_LEVEL        ]: : 0 = A contact 1= B contact 2 = not use. 3 = keep current mode
// 	13=[ZPHASE_USE          ]: use of Z phase. 0: not use , 1: - direction, 2: +direction
// 	14=[STOP_SIGNAL_MODE    ]: ESTOP, mode in use of SSTOP  0:slowdown stop, 1:emergency stop
// 	15=[STOP_SIGNAL_LEVEL   ]: ESTOP, SSTOP use level. : 0 = A contact 1= B contact 2 = not use. 3 = keep current mode
// 	16=[HOME_FIRST_VELOCITY ]: 1st move velocity
// 	17=[HOME_SECOND_VELOCITY]: velocity after detecting
// 	18=[HOME_THIRD_VELOCITY ]: the last velocity
// 	19=[HOME_LAST_VELOCITY  ]: velocity for index detecting and detail detecting
// 	20=[HOME_FIRST_ACCEL    ]: 1st acceleration, 21=[HOME_SECOND_ACCEL   ] : 2nd acceleration
// 	22=[HOME_END_CLEAR_TIME ]: queue time to set origin detecting Enc value,  23=[HOME_END_OFFSET] : move as much as offset after detecting of origin.
// 	24=[NEG_SOFT_LIMIT      ]: - not use if set same as SoftWare Limit , 25=[POS_SOFT_LIMIT ]: - not use if set same as SoftWare Limit.
// 	26=[MOVE_PULSE          ]: amount of pulse per driver revolution               , 27=[MOVE_UNIT  ]: travel distance per driver revolution :screw Pitch
// 	28=[INIT_POSITION       ]: initial position when use agent , user can use optionally
// 	29=[INIT_VELOCITY       ]: initial velocity when use agent, user can use optionally
// 	30=[INIT_ACCEL          ]: initial acceleration when use agent, user can use optionally
// 	31=[INIT_DECEL          ]: initial deceleration when use agent, user can use optionally
// 	32=[INIT_ABSRELMODE     ]: absolute(0)/relative(1) set position
// 	33=[INIT_PROFILEMODE    ]: set profile mode in (0 - 4)
//                            '0': symmetry Trapezode, '1': asymmetric Trapezode, '2': symmetry Quasi-S Curve, '3':symmetry S Curve, '4':asymmetric S Curve
// 	= Load .mot file which is saved as AxmMotSaveParaAll. Optional modification is available by user.
//			function AxmMotLoadParaAll (szFilePath : PChar) : DWord; stdcall;
// 	- Save all parameter for all current axis by axis. Save as .mot file. Load file by using  AxmMotLoadParaAll.
//			function AxmMotSaveParaAll (szFilePath : PChar) : DWord; stdcall;
// 	= In parameter 28 - 31, user sets by using this API in the program.
//			function AxmMotSetParaLoad (lAxisNo : LongInt; dInitPos : Double; dInitVel : Double; dInitAccel : Double; dInitDecel : Double) : DWord; stdcall;
// 	- In parameter 28 - 31, user verifys by using this API in the program.
//			function AxmMotGetParaLoad (lAxisNo : LongInt; dpInitPos : PDouble; dpInitVel : PDouble; dpInitAccel : PDouble; dpInitDecel : PDouble) : DWord; stdcall;
// 	= Set the pulse output method of specific axis.
//			function AxmMotSetPulseOutMethod (lAxisNo : LongInt; uMethod : DWord) : DWord; stdcall;
// 	- Return the setting of pulse output method of specific axis.
//			function AxmMotGetPulseOutMethod (lAxisNo : LongInt; upMethod : PDWord) : DWord; stdcall;
//					uMethod  0 :OneHighLowHigh, 1 :OneHighHighLow, 2 :OneLowLowHigh, 3 :OneLowHighLow, 4 :TwoCcwCwHigh
//         					 5 :TwoCcwCwLow,    6 :TwoCwCcwHigh,   7 :TwoCwCcwLow,   8 :TwoPhase,      9 :TwoPhaseReverse
//    			OneHighLowHigh          = 0x0,        // 1 pulse method, PULSE(Active High), forward direction(DIR=Low)  / reverse direction(DIR=High)
//    			OneHighHighLow          = 0x1,        // 1 pulse method, PULSE(Active High), forward direction (DIR=High) / reverse direction (DIR=Low)
//    			OneLowLowHigh           = 0x2,        // 1 pulse method, PULSE(Active Low), forward direction (DIR=Low)  / reverse direction (DIR=High)
//    			OneLowHighLow           = 0x3,        // 1 pulse method, PULSE(Active Low), forward direction (DIR=High) / reverse direction (DIR=Low)
//    			TwoCcwCwHigh            = 0x4,        // 2 pulse method, PULSE(CCW: reverse direction),  DIR(CW: forward direction),  Active High
//    			TwoCcwCwLow             = 0x5,        // 2 pulse method, PULSE(CCW: reverse direction),  DIR(CW: forward direction),  Active Low
//    			TwoCwCcwHigh            = 0x6,        // 2 pulse method, PULSE(CW: forward direction),   DIR(CCW: reverse direction), Active High
//    			TwoCwCcwLow             = 0x7,        // 2 pulse method, PULSE(CW: forward direction),   DIR(CCW: reverse direction), Active Low
//    			TwoPhase                = 0x8,        // 2 phase (90' phase difference),  PULSE lead DIR(CW: forward direction), PULSE lag DIR(CCW: reverse direction)
//    			TwoPhaseReverse         = 0x9         // 2 phase(90' phase difference),  PULSE lead DIR(CCW: Forward diredtion), PULSE lag DIR(CW: Reverse direction)
// 	= Set the Encoder input method including the setting of increase direction of actual count of specific axis.
//			function AxmMotSetEncInputMethod (lAxisNo : LongInt; uMethod : DWord) : DWord; stdcall;
// 	- Return the Encoder input method including the setting of increase direction of actual count of specific axis.
//			function AxmMotGetEncInputMethod (lAxisNo : LongInt; upMethod : PDWord) : DWord; stdcall;
//    			ObverseUpDownMode       = 0x0,        // Forward direction Up/Down
//    			ObverseSqr1Mode         = 0x1,        // Forward direction 1 multiplication
//    			ObverseSqr2Mode         = 0x2,        // Forward direction 2 multiplication
//    			ObverseSqr4Mode         = 0x3,        // Forward direction 4 multiplication
//    			ReverseUpDownMode       = 0x4,        // Reverse direction Up/Down
//    			ReverseSqr1Mode         = 0x5,        // Reverse direction 1 multiplication
//    			ReverseSqr2Mode         = 0x6,        // Reverse direction 2 multiplication
//    			ReverseSqr4Mode         = 0x7         // Reverse direction 4 multiplication
// 	= Set the travel distance of specific axis per pulse.
//			function AxmMotSetMoveUnitPerPulse (lAxisNo : LongInt; dUnit : Double; lPulse : LongInt) : DWord; stdcall;	//F2CH
// 	- Return the travel distance of specific axis per pulse.
//			function AxmMotGetMoveUnitPerPulse (lAxisNo : LongInt; dpUnit : PDouble; lpPulse : PLongInt) : DWord; stdcall;	//F2CH
// 		If you want to set specified velocity unit in RPM(Revolution Per Minute),
// 				ex>    calculate rpm : 4500 rpm ?
// 		When unit/ pulse = 1 : 1, then it becomes pulse per sec, and
// 		if you want to set at 4500 rpm , then  4500 / 60 sec : 75 revolution / 1sec
// 		The number of pulse per 1 revolution of motor shall be known. This can be know by detecting of Z phase in Encoder.
// 		If 1 revolution:1800 pulse,  75 x 1800 = 135000 pulses are required.
// 		Operate by input Unit = 1, Pulse = 1800 into AxmMotSetMoveUnitPerPulse.
// 		Caution : If it is controlled with rpm, velocity and acceleration will be changed to rpm unit as well.
// 	= Set deceleration starting point detecting method to specific axis.
//			function AxmMotSetDecelMode (lAxisNo : LongInt; uMethod : DWord) : DWord; stdcall;
// 	- Return the deceleration starting point detecting method of specific axis.
//			function AxmMotGetDecelMode (lAxisNo : LongInt; upMethod : PDWord) : DWord; stdcall;
// 					UpMethod : 	AutoDetect 0x0 : automatic acceleration/deceleration.
// 										 	RestPulse  0x1 : manual acceleration/deceleration.
// 	- Set remain pulse to the specific axis in manual deceleration mode.
//			function AxmMotSetRemainPulse (lAxisNo : LongInt; uData : DWord) : DWord; stdcall;
// 	- Return remain pulse of the specific axis in manual deceleration mode.
//			function AxmMotGetRemainPulse (lAxisNo : LongInt; upData : PDWord) : DWord; stdcall;
// 	- Set maximum velocity to the specific axis in uniform velocity movement API.	 	
//			function AxmMotSetMaxVel (lAxisNo : LongInt; dVel : Double) : DWord; stdcall;	//F2CH
// 	- Return maximum velocity of the specific axis in uniform velocity movement API
//			function AxmMotGetMaxVel (lAxisNo : LongInt; dpVel : PDouble) : DWord; stdcall;
// 	- Set travel distance calculation mode of specific axis.
//			function AxmMotSetAbsRelMode (lAxisNo : LongInt; uAbsRelMode : DWord) : DWord; stdcall;
// 	- Return travel distance calculation mode of specific axis.
//			function AxmMotGetAbsRelMode (lAxisNo : LongInt; upAbsRelMode : PDWord) : DWord; stdcall;
//					uAbsRelMode : POS_ABS_MODE '0' - absolute coordinate system
//              					POS_REL_MODE '1' - relative coordinate system
//	- Set move velocity profile mode of specific axis.
//			function AxmMotSetProfileMode (lAxisNo : LongInt; uProfileMode : DWord) : DWord; stdcall;
// 	- Return move velocity profile mode of specific axis.
//			function AxmMotGetProfileMode (lAxisNo : LongInt; upProfileMode : PDWord) : DWord; stdcall;
//					ProfileMode : SYM_TRAPEZOIDE_MODE  '0' - symmetry Trapezode
//              					ASYM_TRAPEZOIDE_MODE '1' - asymmetric Trapezode
//              					QUASI_S_CURVE_MODE   '2' - symmetry Quasi-S Curve
//              					SYM_S_CURVE_MODE     '3' - symmetry S Curve
//              					ASYM_S_CURVE_MODE    '4' - asymmetric S Curve
//	- Set acceleration unit of specific axis.
//			function AxmMotSetAccelUnit (lAxisNo : LongInt; uAccelUnit : DWord) : DWord; stdcall;
// 	- Return acceleration unit of specific axis.
//			function AxmMotGetAccelUnit (lAxisNo : LongInt; upAccelUnit : PDWord) : DWord; stdcall;
//					AccelUnit : UNIT_SEC2  '0' ? use unit/sec2 for the unit of acceleration/deceleration
//            					SEC        '1' - use sec for the unit of acceleration/deceleration
// 	= Set initial velocity to the specific axis.
//			function AxmMotSetMinVel (lAxisNo : LongInt; dMinVel : Double) : DWord; stdcall;	//F2CH?
// 	- Return initial velocity of the specific axis.
//			function AxmMotGetMinVel (lAxisNo : LongInt; dpMinVel : PDouble) : DWord; stdcall;
// 	= Set acceleration jerk value of specific axis.[%].
//			function AxmMotSetAccelJerk (lAxisNo : LongInt; dAccelJerk : Double) : DWord; stdcall;
// 	- Return acceleration jerk value of specific axis.
//			function AxmMotGetAccelJerk (lAxisNo : LongInt; dpAccelJerk : PDouble) : DWord; stdcall;
// 	= Set deceleration jerk value of specific axis.[%].
//			function AxmMotSetDecelJerk (lAxisNo : LongInt; dDecelJerk : Double) : DWord; stdcall;
// 	- Return deceleration jerk value of specific axis.
//			function AxmMotGetDecelJerk (lAxisNo : LongInt; dpDecelJerk : PDouble) : DWord; stdcall;
//	= ????
//		function AxmMotSetProfilePriority(lAxisNo : LongInt; uPriority : DWord) : DWord; stdcall;
//		function AxmMotGetProfilePriority(lAxisNo : LongInt; upPriority : PDWord) : DWord; stdcall;
//
// << Setting API related in/output signal >> ==================================
// 	= Set Z phase level of specific axis.
//			function AxmSignalSetZphaseLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// 	- Return Z phase level of specific axis.
//			function AxmSignalGetZphaseLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;
// 					uLevel : LOW(0), HIGH(1)
// 	= Set output level of Servo-On signal of specific axis.
//			function AxmSignalSetServoOnLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// 	- Return output level of Servo-On signal of specific axis.
//			function AxmSignalGetServoOnLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;
// 					uLevel : LOW(0), HIGH(1)
// 	= Set output level of Servo-Alarm Reset signal of specific axis.
//			function AxmSignalSetServoAlarmResetLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// 	- Return output level of Servo-Alarm Reset signal of specific axis.
//			function AxmSignalGetServoAlarmResetLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;
// 					uLevel : LOW(0), HIGH(1)
// 	= Set whether to use Inposition signal of specific axis and signal input level.
//			function AxmSignalSetInpos (lAxisNo : LongInt; uUse : DWord) : DWord; stdcall;
// 	- Return whether to use Inposition signal of specific axis and signal input level.
//			function AxmSignalGetInpos (lAxisNo : LongInt; upUse : PDWord) : DWord; stdcall;
// 	- Return inposition signal input mode of specific axis.
//			function AxmSignalReadInpos (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;
// 					uLevel : LOW(0), HIGH(1), UNUSED(2), USED(3)
// 	- Set whether to use emergency stop or not against to alarm signal input and set signal input level of specific axis.
//			function AxmSignalSetServoAlarm (lAxisNo : LongInt; uUse : DWord) : DWord; stdcall;
// 	- Return whether to use emergency stop or not against to alarm signal input and set signal input level of specific axis.
//			function AxmSignalGetServoAlarm (lAxisNo : LongInt; upUse : PDWord) : DWord; stdcall;
// 	- Return input level of alarm signal of specific axis.
//			function AxmSignalReadServoAlarm (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;
// 					uLevel : LOW(0), HIGH(1), UNUSED(2), USED(3)
// 	= Set whether to use end limit sensor of specific axis and input level of signal.
//			function AxmSignalSetLimit (lAxisNo : LongInt; uStopMode : DWord; uPositiveLevel : DWord; uNegativeLevel : DWord) : DWord; stdcall;
// 	- Return whether to use end limit sensor of specific axis , input level of signal and stop mode for signal input.
//			function AxmSignalGetLimit (lAxisNo : LongInt; upStopMode : PDWord; upPositiveLevel : PDWord; upNegativeLevel : PDWord) : DWord; stdcall;
// 	- Return the input state of end limit sensor of specific axis.
//			function AxmSignalReadLimit (lAxisNo : LongInt; upPositiveStatus : PDWord; upNegativeStatus : PDWord) : DWord; stdcall;
// 					Available to set of slow down stop or emergency stop when end limit sensor is input.
// 					uStopMode: EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// 					uPositiveLevel, uNegativeLevel : LOW(0), HIGH(1), UNUSED(2), USED(3)
// 	= Set whether to use software limit, count to use and stop method of specific axis.
//			function AxmSignalSetSoftLimit (lAxisNo : LongInt; uUse : DWord; uStopMode : DWord; uSelection : DWord; dPositivePos : Double; dNegativePos : Double) : DWord; stdcall;
// 	- Return whether to use software limit, count to use and stop method of specific axis.
//			function AxmSignalGetSoftLimit (lAxisNo : LongInt; upUse : PDWord; upStopMode : PDWord; upSelection : PDWord; dpPositivePos : PDouble; dpNegativePos : PDouble) : DWord; stdcall;
//			function AxmSignalReadSoftLimit(lAxisNo : LongInt; upPositiveStatus : PDWord; upNegativeStatus : PDWord) : DWord; stdcall;
// 					uUse       : DISABLE(0), ENABLE(1)
// 					uStopMode  : EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// 					uSelection : COMMAND(0), ACTUAL(1)
// 					Caution: When software limit is set in advance by using above API in origin detecting and is moving, if the detecting of origin is stopped during detecting, it becomes DISABLE.
// 	= Set the stop method of emergency stop(emergency stop/slowdown stop) ,or whether to use or not.
//			function AxmSignalSetStop (lAxisNo : LongInt; uStopMode : DWord; uLevel : DWord) : DWord; stdcall;
// 	- Return the stop method of emergency stop(emergency stop/slowdown stop) ,or whether to use or not.
//			function AxmSignalGetStop (lAxisNo : LongInt; upStopMode : PDWord; upLevel : PDWord) : DWord; stdcall;
// 	- Return input state of emergency stop.
//			function AxmSignalReadStop (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;
// 					uStopMode  : EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// 					uLevel     : LOW(0), HIGH(1), UNUSED(2), USED(3)
// 	= Output the Servo-On signal of specific axis.
//			function AxmSignalServoOn (lAxisNo : LongInt; uOnOff : DWord) : DWord; stdcall;	//F2CH
// 	- Return the output state of Servo-On signal of specific axis.
//			function AxmSignalIsServoOn (lAxisNo : LongInt; upOnOff : PDWord) : DWord; stdcall;
// 					uOnOff : FALSE(0), TRUE(1) ( The case of universal 0 output)
// 	= Output the Servo-Alarm Reset signal of specific axis.
//			function AxmSignalServoAlarmReset (lAxisNo : LongInt; uOnOff : DWord) : DWord; stdcall;	//F2CH?
// 					uOnOff : FALSE(0), TRUE(1) (The case of universal 1 output)
// 	= Set universal output value.
//			function AxmSignalWriteOutput (lAxisNo : LongInt; uValue : DWord) : DWord; stdcall;
// 	- Return universal output value.
//			function AxmSignalReadOutput (lAxisNo : LongInt; upValue : PDWord) : DWord; stdcall;	//F2CH?
// 					uValue : Hex Value 0x00
// 	- Set universal output values by bit.
//			function AxmSignalWriteOutputBit (lAxisNo : LongInt; lBitNo : LongInt; uOnOff : DWord) : DWord; stdcall;
// 	- Return universal output values by bit.
//		 	function AxmSignalReadOutputBit (lAxisNo : LongInt; lBitNo : LongInt; upOnOff : PDWord) : DWord; stdcall;	//F2CH?
// 					lBitNo : Bit Number(0 - 4)
// 					uOnOff : FALSE(0), TRUE(1)
// 	= Return universal input value in Hex value.
//			function AxmSignalReadInput (lAxisNo : LongInt; upValue : PDWord) : DWord; stdcall;	//F2CH
// 	- Return universal input value by bit.
//			function AxmSignalReadInputBit (lAxisNo : LongInt; lBitNo : LongInt; upOn : PDWord) : DWord; stdcall;
// 					lBitNo : Bit Number(0 - 4)
//	- ????
//			function AxmSignalSetFilterBandwidth(lAxisNo : LongInt; uSignal : DWord; dBandwidthUsec : Double) : DWord; stdcall;
// 					uSignal: END_LIMIT(0), INP_ALARM(1), UIN_00_01(2), UIN_02_04(3)
// 					dBandwidthUsec: 0.2uSec~26666uSec


//		function AxtInitialize (hWnd : HWND; nIrqNo : SmallInt) : Boolean; stdcall;
// 	- 통합 라이브러리가 사용 가능하지 (초기화가 되었는지)를 확인한다
//		function AxtIsInitialized () : Boolean; stdcall;
// 	- 통합 라이브러리의 사용을 종료한다.
//		procedure AxtClose (); stdcall;

// <<베이스보드 오픈 및 닫기>>
// 	- 지정한 버스(ISA, PCI, VME, CompactPCI)가 초기화 되었는지를 확인한다
//		function AxtIsInitializedBus (BusType : SmallInt) : SmallInt; stdcall;
// 	- 새로운 베이스보드를 통합라이브러리에 추가한다.
//		function AxtOpenDevice (BusType : SmallInt; dwBaseAddr : DWord) : SmallInt; stdcall;
// 	- 새로운 베이스보드를 배열을 이용하여 한꺼번에 통합라이브러리에 추가한다.
//		function AxtOpenDeviceAll (BusType : SmallInt; nLen : SmallInt; dwBaseAddr : PDWord) : SmallInt; stdcall;
// 	- 새로운 베이스보드를 자동으로 통합라이브러리에 추가한다.
//		function AxtOpenDeviceAuto (BusType : SmallInt) : SmallInt; stdcall;
// 	- 추가된 베이스보드를 전부 닫는다
//		procedure AxtCloseDeviceAll (); stdcall;
//
// << 보드 초기화 함수군 >> ======================================================================================
//	- CAMC-FS가 장착된 모듈(SMC-1V02, SMC-2V02)을 검색하여 초기화한다. CAMC-FS 2.0이상만 검출한다
//		function InitializeCAMCFS20 (reset : Boolean) : Boolean; stdcall;
// 					reset : 1(TRUE) = 레지스터(카운터 등)를 초기화한다
//  				reset(TRUE)일때 초기 설정값.
//  					1) 인터럽트 사용하지 않음.
//  					2) 인포지션 기능 사용하지 않음.
//  					3) 알람정지 기능 사용하지 않음.
//  					4) 급정지 리미트 기능 사용 함.
//  					5) 감속정지 리미트 기능 사용 함.
//  					6) 펄스 출력 모드 : OneLowHighLow(Pulse : Active LOW, Direction : CW=High;CCW=LOW).
//  					7) 검색 신호 : +급정지 리미트 신호 하강 에지.
//  					8) 입력 인코더 설정 : 2상, 4 체배.
//  					9) 알람, 인포지션, +-감속 정지 리미트, +-급정지 리미트 Active level : HIGH
// 				 	 10) 내부/외부 카운터 : 0.
//	- CAMC-FS20 모듈의 사용이 가능한지를 확인한다
//		function CFS20IsInitialized () : Boolean; stdcall;
// 					리턴값 :  1(TRUE) = CAMC-FS20 모듈을 사용 가능하다
//	- CAMC-FS20이 장착된 모듈의 사용을 종료한다
//		procedure CFS20StopService (); stdcall;

// << 보드 정보 관련 함수군 >> ===================================================================================
//	- 지정한 주소에 장착된 베이스보드의 번호를 리턴한다. 없으면 -1을 리턴한다
//		function CFS20get_boardno (address : DWord) : SmallInt; stdcall;
//	- 베이스보드의 갯수를 리턴한다
//		function CFS20get_numof_boards () : SmallInt; stdcall;
//	- 지정한 베이스보드에 장착된 축의 갯수를 리턴한다
//		function CFS20get_numof_axes (nBoardNo : SmallInt) : SmallInt; stdcall;
//	- 축의 갯수를 리턴한다
//		function CFS20get_total_numof_axis () : SmallInt; stdcall;
//	- 지정한 베이스보드번호와 모듈번호에 해당하는 축번호를 리턴한다
//		function CFS20get_axisno (nBoardNo : SmallInt; nModuleNo : SmallInt) : SmallInt; stdcall;
//	- 지정한 축의 정보를 리턴한다
//		function CFS20get_axis_info (nAxisNo : SmallInt; nBoardNo : PSmallInt; nModuleNo : PSmallInt; bModuleID : PByte; nAxisPos : PSmallInt) : Boolean; stdcall;
// 					nBoardNo : 해당 축이 장착된 베이스보드의 번호.
// 					nModuleNo: 해당 축이 장착된 모듈의 베이스 모드내 모듈 위치(0~3)
// 					bModuleID: 해당 축이 장착된 모듈의 ID : SMC-2V02(0x02)
// 					nAxisPos : 해당 축이 장착된 모듈의 첫번째인지 두번째 축인지 정보.(0 : 첫번째, 1 : 두번째)

// << 파일 관련 함수군 >> ========================================================================================
//	- 지정 축의 초기값을 지정한 파일에서 읽어서 설정한다
//		function CFS20load_parameter (axis : SmallInt; nfilename : PChar) : Boolean; stdcall;
// 					Loading parameters.
// 						1) 1Pulse당 이동거리(Move Unit / Pulse)
// 						2) 최대 이동 속도, 시작/정지 속도
// 						3) 엔코더 입력방식, 펄스 출력방식
// 						4) +급정지 리미트레벨, -급정지 리미트레벨, 급정지 리미트 사용유무
//  					5) +감속정지 리미트레벨,-감속정지 리미트레벨, 감속정지 리미트 사용유무
//  					6) 알람레벨, 알람 사용유무
//  					7) 인포지션(위치결정완료 신호)레벨, 인포지션 사용유무
//  					8) 비상정지 사용유무
//  					9) 엔코더 입력방식2 설정값
// 					 10) 내부/외부 카운터 : 0.
//	- 지정 축의 초기값을 지정한 파일에 저장한다.
//		function CFS20save_parameter (axis : SmallInt; nfilename : PChar) : Boolean; stdcall;
// 					Saving parameters.
// 						1) 1Pulse당 이동거리(Move Unit / Pulse)
// 						2) 최대 이동 속도, 시작/정지 속도
// 						3) 엔코더 입력방식, 펄스 출력방식
// 						4) +급정지 리미트레벨, -급정지 리미트레벨, 급정지 리미트 사용유무
//  					5) +감속정지 리미트레벨,-감속정지 리미트레벨, 감속정지 리미트 사용유무
//  					6) 알람레벨, 알람 사용유무
//  					7) 인포지션(위치결정완료 신호)레벨, 인포지션 사용유무
//  					8) 비상정지 사용유무
//  					9) 엔코더 입력방식2 설정값
//	- 모든 축의 초기값을 지정한 파일에서 읽어서 설정한다
//		function CFS20load_parameter_all (nfilename : PChar) : Boolean; stdcall;
//	- 모든 축의 초기값을 지정한 파일에 저장한다
//		function CFS20save_parameter_all (nfilename : PChar) : Boolean; stdcall;
// << 인터럽트 함수군 >> ================================================================================================
//		procedure CFS20SetWindowMessage (hWnd : HWND; wMsg : Word; proc : AXT_CAMCFS_INTERRUPT_PROC); stdcall;
//					인터럽트를 사용하기 위해서는 Window message & procedure
//    				hWnd    : 윈도우 핸들, 윈도우 메세지를 받을때 사용. 사용하지 않으면 NULL을 입력.
//    				wMsg    : 윈도우 핸들의 메세지, 사용하지 않거나 디폴트값을 사용하려면 0을 입력.
//    				proc    : 인터럽트 발생시 호출될 함수의 포인터, 사용하지 않으면 NULL을 입력.
//		function CFS20read_interrupt_flag (axis : SmallInt) : DWord; stdcall;
// 					ReadInterruptFlag에서 설정된 내부 flag변수를 읽어 보는 함수(인터럽트 service routine에서 인터럽터 발생 요인을 판별한다.)
// 					리턴값: 인터럽트가 발생 하였을때 발생하는 인터럽트 flag register(CAMC-FS20 의 INTFLAG 참조.)
// << API which verifies the state during motion moving and after moving >> ============
// 	* Return pulse output state of specific axis. (Status of move)
//			function AxmStatusReadInMotion (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;	//F2CH?
// 	- Return move pulse counter value of specific axis after start of move. (pulse count value)
//			function AxmStatusReadDrivePulseCount (lAxisNo : LongInt; lpPulse : PLongInt) : DWord; stdcall;    
// 	* Return DriveStatus register (status of in-motion) of specific Axis. 
//			function AxmStatusReadMotion (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall; //F2CH?
// 					Caution: All Motion Product is different Hardware bit signal. Refer Manual and AXHS.xxx
// 	- Return EndStatus(status of stop) register of specific axis.
//			function AxmStatusReadStop (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;    
// 					Caution: All Motion Product is different Hardware bit signal. Refer Manual and AXHS.xxx
// 	* Return Mechanical Signal Data(Current mechanical signal status)of specific axis.
//			function AxmStatusReadMechanical (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;  //F2CH?
// 					Caution: All Motion Product is different Hardware bit signal. Refer Manual and AXHS.xxx
// 	- Read current move velocity of specific axis.
//			function AxmStatusReadVel (lAxisNo : LongInt; dpVel : PDouble) : DWord; stdcall;    
// 	* Return the error between Command Pos and Actual Pos of specific axis.
//			function AxmStatusReadPosError (lAxisNo : LongInt; dpError : PDouble) : DWord; stdcall; //F2CH?
// 	- Verify the travel(traveled) distance to the final drive.
//			function AxmStatusReadDriveDistance (lAxisNo : LongInt; dpUnit : PDouble) : DWord; stdcall;
// 	= Set use the Position information Type of specific Axis. 
//			function AxmStatusSetPosType(lAxisNo : LongInt; uPosType : DWord; dPositivePos : Double; dNegativePos : Double) : DWord; stdcall;
// 	- Return the Position Information Type of of specific axis.
//			function AxmStatusGetPosType(lAxisNo : LongInt; upPosType : PDWord; dpPositivePos : PDouble; dpNegativePos : PDouble) : DWord; stdcall;
// 					uPosType  : Select Position Information Type (Actual position / Command position)
//    					POSITION_LIMIT '0' - Normal action, In all round action.
//    					POSITION_BOUND '1' - Position cycle type, dNegativePos ~ dPositivePos Range
// 					Caution(PCI-Nx04)
// 							BOUNT설정시 카운트 값이 Max값을 초과 할 때 Min값이되며 반대로 Min값을 초과 할 때 Max값이 된다.
// 							다시말해 현재 위치값이 설정한 값 밖에서 카운트 될 때는 위의 Min, Max값이 적용되지 않는다.
// 	- Set absolute encoder origin offset Position of specific axis. [Only for PCI-R1604-MLII]
//			function AxmStatusSetAbsOrgOffset(lAxisNo : LongInt; dOrgOffsetPos : Double) : DWord; stdcall;
// 	* Set the actual position of specific axis. 
//			function AxmStatusSetActPos (lAxisNo : LongInt; dPos : Double) : DWord; stdcall;	//F2CH?
// 	- Return the actual position of specific axis.
//			function AxmStatusGetActPos (lAxisNo : LongInt; dpPos : PDouble) : DWord; stdcall;	//F2CH?
// 	* Set command position of specific axis.
//			function AxmStatusSetCmdPos (lAxisNo : LongInt; dPos : Double) : DWord; stdcall;	//F2CH?
// 	- Return command position of specific axis.
//			function AxmStatusGetCmdPos (lAxisNo : LongInt; dpPos : PDouble) : DWord; stdcall;	//F2CH?
// 	- Set command position and actual position of specific axi (Only RTEX use)
//			function AxmStatusSetPosMatch(lAxisNo : LongInt; dPos : Double) : DWord; stdcall;
// 	- Network function.
//			function AxmStatusRequestServoAlarm(lAxisNo : LongInt) : DWord; stdcall;   
//			function AxmStatusReadServoAlarm(lAxisNo : LongInt; uReturnMode : DWord; upAlarmCode : PDWord) : DWord; stdcall;
//			function AxmStatusGetServoAlarmString(lAxisNo : LongInt; uAlarmCode : DWord; lAlarmStringSize : LongInt; szAlarmString : PChar) : DWord; stdcall;  
//			function AxmStatusRequestServoAlarmHistory(lAxisNo : LongInt) : DWord; stdcall;  
//			function AxmStatusReadServoAlarmHistory(lAxisNo : LongInt; uReturnMode : DWord; lpCount : PLongInt; upAlarmCode : PDWord) : DWord; stdcall;  
//			function AxmStatusClearServoAlarmHistory(lAxisNo : LongInt) : DWord; stdcall;  
//
// << API related home >> ==========================================================================================================================
// 	= Set home sensor level of specific axis. 
//			function AxmHomeSetSignalLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// 	- Return home sensor level of specific axis.
//			function AxmHomeGetSignalLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;
// 					uLevel : LOW(0), HIGH(1)
// 	- Verify current home signal input status. 
//			Home signal can be set by user optionally by using AxmHomeSetMethod API. 
//			function AxmHomeReadSignal (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;
// 					upStatus : OFF(0), ON(1)
// 	* Set Parameters related to origin detecting must be set in order to detect origin of relevant axis. 
// 			If the initialization is done properly by using MotionPara setting file, no separate setting is required.  
// 			In the setting of origin detecting method, direction of detecting proceed, signal to be used for origin, active level of origin sensor and detecting/no detecting of encoder Z phase are set. 
// 				Caution : When the level is set wrong, it may operate + direction even though ? direction is set, and may cause problem in finding home.
// 					(Refer the guide part of AxmMotSaveParaAll for detail information. )
//			function AxmHomeSetMethod (lAxisNo : LongInt; lHmDir : LongInt; uHomeSignal : DWord; uZphas : DWord; dHomeClrTime : Double; dHomeOffset : Double) : DWord; stdcall;
// 					Use AxmSignalSetHomeLevel for home level.
// 					HClrTime : HomeClear Time : Queue time for setting origin detecting Encoder value. 
// 					HmDir(Home direction): DIR_CCW(0): - direction    , DIR_CW(1) = + direction   // HOffset ? traveled distance after detecting of origin. 
// 					uZphas: Set whether to detect of encoder Z phase after completion of the 1st detecting of origin. 
// 					HmSig : PosEndLimit(0) -> +Limit
//         					NegEndLimit(1) -> -Limit
//         					HomeSensor (4) -> origin sensor(universal input 0)    
// 	* Return set parameters related to home.
//			function AxmHomeGetMethod (lAxisNo : LongInt; lpHmDir : PLongInt; upHomeSignal : PDWord; upZphas : PDWord; dpHomeClrTime : PDouble; dpHomeOffset : PDouble) : DWord; stdcall;
//	- ???
//			function AxmHomeSetFineAdjust(lAxisNo : LongInt; dHomeDogLength : Double; lLevelScanTime : LongInt; uFineSearchUse : DWord; uHomeClrUse : DWord) : DWord; stdcall;
//			function AxmHomeGetFineAdjust(lAxisNo : LongInt; dpHomeDogLength : PDouble; lpLevelScanTime : PLongInt; upFineSearchUse : PDWord; upHomeClrUse : PDWord) : DWord; stdcall;

// 	* Set velocity of origin detecting of each axis by changing velocities of each step.  
// 			API which sets velocity to be used in origin detecting. 
// 			Detect through several steps in order to detect origin quickly and precisely. Now, set velocities to be used for each step.  
// 			The time of origin detecting and the accuracy of origin detecting are decided by setting of these velocities. 
// 			(Refer the guide part of AxmMotSaveParaAll for detail information.)
//			function AxmHomeSetVel (lAxisNo : LongInt; dVelFirst : Double; dVelSecond : Double; dVelThird : Double; dVelLast : Double; dAccFirst : Double; dAccSecond : Double) : DWord; stdcall;
// 	- Return set velocity to be used in origin detecting. 
//			function AxmHomeGetVel (lAxisNo : LongInt; dpVelFirst : PDouble; dpVelSecond : PDouble; dpVelThird : PDouble; dpVelLast : PDouble; dpAccFirst : PDouble; dpAccSecond : PDouble) : DWord; stdcall;
// 						[dVelFirst]- 1st move velocity   
//						[dVelSecond]- velocity after detecting   
//						[dVelThird]- the last velocity  
//						[dvelLast]- index detecting and in order to detect precisely. 
// 						[dAccFirst]- 1st move acceleration 
//						[dAccSecond]-acceleration after detecting.  

// 	- Start to detect origin.
// 			When origin detecting start API is executed, thread which will detect origin of relevant axis in the library is created automatically 
//					and it is automatically closed after carrying out of the origin detecting in sequence. 
//			function AxmHomeSetStart (lAxisNo : LongInt) : DWord; stdcall;

// 	- User sets the result of origin detecting optionally. 
// 			When the detecting of origin is completed successfully by using origin detecting API, the result of detecting is set as HOME_SUCCESS.
// 					This API enables user to set result optionally without execution of origin detecting. 
//			function AxmHomeSetResult (lAxisNo : LongInt; uHomeResult : DWord) : DWord; stdcall;
// 					uHomeResult Setup
// 					HOME_SUCCESS              = 0x01,       
// 					HOME_SEARCHING            = 0x02,     
// 					HOME_ERR_GNT_RANGE        = 0x10, // Gantry Home Range Over
// 					HOME_ERR_USER_BREAK       = 0x11, // User Stop Command
// 					HOME_ERR_VELOCITY         = 0x12, // Velocity is very slow and fast
// 					HOME_ERR_AMP_FAULT        = 0x13, // Servo Drive Alarm 
// 					HOME_ERR_NEG_LIMIT        = 0x14, // (+)Limit sensor check (-)dir during Motion
// 					HOME_ERR_POS_LIMIT        = 0x15, // (-)Limit sensor check (+)dir during Motion
// 					HOME_ERR_NOT_DETECT       = 0x16, // not detect User set signal
// 					HOME_ERR_UNKNOWN          = 0xFF,
// 	- Return the result of origin detecting. 
// 			Verify detecting result of origin detection API. When detecting of origin is started, it sets as HOME_SEARCHING, 
//					and if the detecting of origin is failed the reason of failure is set. Redo origin detecting after eliminating of failure reasons.
//			function AxmHomeGetResult (lAxisNo : LongInt; upHomeResult : PDWord) : DWord; stdcall;
// 	- Return progress rate of origin detection.
// 			Progress rate can be verified when origin detection is commenced. 
//					When origin detection is completed, return 100% whether success or failure. 
//					The success or failure of origin detection result can be verified by using GetHome Result API.
//			function AxmHomeGetRate (lAxisNo : LongInt; upHomeMainStepNumber : PDWord; upHomeStepNumber : PDWord) : DWord; stdcall;
// 					upHomeMainStepNumber : Progress rate of Main Step . 
// 					In case of gentry FALSE upHomeMainStepNumber : When 0 , only selected axis is in proceeding, home progress rate is indicated upHomeStepNumber.
// 					In case of gentry TRUE upHomeMainStepNumber : When 0, master home is in proceeding, master home progress rate is indicated upHomeStepNumber. 
// 					In case of gentry TRUE upHomeMainStepNumber : When 10 , slave home is in proceeding, master home progress rate is indicated upHomeStepNumber .
// 					upHomeStepNumber     : Indicate progress rate against to selected axis. 
// 					In case of gentry FALSE  : Indicate progress rate against to selected axis only.
// 					In case of gentry TRUE, progress rate is indicated by sequence of master axis and slave axis.
//
// << Position move API >> ===============================================================================================================    
// 	If you want to set specified velocity unit in RPM(Revolution Per Minute),
// 			ex> calculate rpm : 4500 rpm ?
// 					When unit/ pulse = 1 : 1, then it becomes pulse per sec, and
// 					if you want to set at 4500 rpm , then  4500 / 60 sec : 75 revolution / 1sec
// 					The number of pulse per 1 revolution of motor shall be known. This can be know by detecting of Z phase in Encoder. 
// 					If 1 revolution:1800 pulse,  75 x 1800 = 135000 pulses are required. 
// 					Operate by input Unit = 1, Pulse = 1800 into AxmMotSetMoveUnitPerPulse.
// 	* Travel up to set distance or position.
//			function AxmMoveStartPos (lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;	//F2CH?
// 					It moves by set velocity and acceleration up to the position set by absolute coordinates/ relative coordinates of specific axis. 
// 					Velocity profile is set in AxmMotSetProfileMode API. 
// 					It separates from API at the timing of pulse output start.
// 	* Travel up to set distance or position.
//			function AxmMovePos (lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;	//F2CH?
// 					It moves by set velocity and acceleration up to the position set by absolute coordinates/ relative coordinates of specific axis.
// 					Velocity profile is set in AxmMotSetProfileMode API
// 					It separates from API at the timing of pulse output finish.
// 	- Move by set velocity.
//			function AxmMoveVel (lAxisNo : LongInt; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;
// 					It maintain velocity mode move by velocity and acceleration  set against to specific axis. 
// 					It separates from API at the timing of pulse output start.
// 					It moves toward to CW direction when Vel value is positive, CCW when negative.
//	- ????
//			function AxmMoveStartMultiVel (lArraySize : LongInt; lpAxesNo : PLongInt; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble) : DWord; stdcall;
//			function AxmMoveStartMultiVelEx(lArraySize : LongInt; lpAxesNo : PLongInt; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble; dwSyncMode : DWord) : DWord; stdcall;
//			function AxmMoveStartLineVel(lArraySize : LongInt; lpAxesNo : PLongInt; dpDis : PDouble; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;
// 					It maintain velocity mode move by velocity and acceleration  set against to specific multi-axis.
// 					It separates from API at the timing of pulse output start.
// 					It moves toward to CW direction when Vel value is positive, CCW when negative.
// 	- API which detects Edge of specific Input signal and makes emergency stop or slowdown stop. 
//			function AxmMoveSignalSearch (lAxisNo : LongInt; dVel : Double; dAccel : Double; lDetectSignal : LongInt; lSignalEdge : LongInt; lSignalMethod : LongInt) : DWord; stdcall; //F2CH?
// 					lDetect Signal : Select input signal to detect . 
// 					lDetectSignal  : PosEndLimit(0), NegEndLimit(1), HomeSensor(4), EncodZPhase(5), UniInput02(6), UniInput03(7)
// 					Signal Edge    : Select edge direction of selected input signal (rising or falling edge).
//         					         SIGNAL_DOWN_EDGE(0), SIGNAL_UP_EDGE(1)
// 					Move direction : CW when Vel value is positive, CCW when negative.
// 					SignalMethod   : EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// 					Caution: When SignalMethod is used as EMERGENCY_STOP(0), acceleration/deceleration is ignored and it is accelerated to specific velocity and emergency stop. 
//          lDetectSignal is PosEndLimit , in case of searching NegEndLimit(0,1) active status of signal level is detected.
// 	- API which detects signal set in specific axis and travels in order to save the position. 
//			function AxmMoveSignalCapture (lAxisNo : LongInt; dVel : Double; dAccel : Double; lDetectSignal : LongInt; lSignalEdge : LongInt; lTarget : LongInt; lSignalMethod : LongInt) : DWord; stdcall;
// 					In case of searching acting API to select and find desired signal, save the position and read the value using AxmGetCapturePos. 
// 					Signal Edge   : Select edge direction of selected input signal. (rising or falling edge).
//              SIGNAL_DOWN_EDGE(0), SIGNAL_UP_EDGE(1)
// 					Move direction      : CW when Vel value is positive, CCW when negative.
// 					SignalMethod  : EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// 					lDetect Signal: Select input signal to detect edge .SIGNAL_DOWN_EDGE(0), SIGNAL_UP_EDGE(1)
//					                Select the motion action which COMMON(0) or SOFTWARE(0) by upper 8bit. Only for SMP Board(PCIe-Rxx05-MLIII).
// 					lDetectSignal : PosEndLimit(0), NegEndLimit(1), HomeSensor(4), EncodZPhase(5), UniInput02(6), UniInput03(7)
// 					lTarget       : COMMAND(0), ACTUAL(1)
// 					Caution: When SignalMethod is used as EMERGENCY_STOP(0), acceleration/deceleration is ignored and it is accelerated to specific velocity and emergency stop. 
// 							lDetectSignal is PosEndLimit , in case of searching NegEndLimit(0,1) active status of signal level is detected.
// 	- API which verifies saved position value in 'AxmMoveSignalCapture' API.
//			function AxmMoveGetCapturePos (lAxisNo : LongInt; dpCapPotition : PDouble) : DWord; stdcall;
// 	- API which travels up to set distance or position.
//			function AxmMoveStartMultiPos (lArraySize : LongInt; lpAxisNo : PLongInt; dpPos : PDouble; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble) : DWord; stdcall;    
// 					When execute API, it starts relevant motion action and escapes from API without waiting until motion is completed ”
// 	- Travels up to the distance which sets multi-axis or position. 
//			function AxmMoveMultiPos (lArraySize : LongInt; lpAxisNo : PLongInt; dpPos : PDouble; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble) : DWord; stdcall;
// 					It moves by set velocity and acceleration up to the position set by absolute coordinates of specific axis. specific axes.
//	- ???
//			function AxmMoveStartTorque(lAxisNo : LongInt; dTorque : Double; dVel : Double; dwAccFilterSel : DWord; dwGainSel : DWord; dwSpdLoopSel : DWord) : DWord; stdcall;
// 					When execute API, it starts open-loop torque motion action of specific axis.(only for MLII, Sigma 5 servo drivers)
// 					dTroque        : Percentage value(%) of maximum torque. (negative value : CCW, positive value : CW)
// 					dVel           : Percentage value(%) of maximum velocity.
// 					dwAccFilterSel : LINEAR_ACCDCEL(0), EXPO_ACCELDCEL(1), SCURVE_ACCELDECEL(2)
// 					dwGainSel      : GAIN_1ST(0), GAIN_2ND(1)
// 					dwSpdLoopSel   : PI_LOOP(0), P_LOOP(1)
//	- ???
//			function AxmMoveTorqueStop(lAxisNo : LongInt; dwMethod : DWord) : DWord; stdcall;
// 					It stops motion during torque motion action.
// 					it can be only applied for AxmMoveStartTorque API.
// 	- To Move Set Position or distance
//			function AxmMoveStartPosWithList(lAxisNo : LongInt; dPosition : Double; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble; lListNum : LongInt) : DWord; stdcall;
// 					Absolute coordinates / position set to the coordinates relative to the set speed / acceleration rate to drive of specific Axis.
// 					Velocity Profile is fixed Asymmetric trapezoid.
// 					Accel/Decel Setting Unit is fixed Unit/Sec^2 
// 						dAccel != 0.0 and dDecel == 0.0 일 경우 이전 속도에서 감속 없이 지정 속도까지 가속.
// 						dAccel != 0.0 and dDecel != 0.0 일 경우 이전 속도에서 지정 속도까지 가속후 등속 이후 감속.
// 						dAccel == 0.0 and dDecel != 0.0 일 경우 이전 속도에서 다음 속도까지 감속.
// 					The following conditions must be satisfied.
// 						dVel[1] == dVel[3] must be satisfied.
// 						dVel [2] that can occur as a constant speed drive range is greater dPosition should be enough.
// 					Ex) dPosition = 10000;
// 						dVel[0] = 300., dAccel[0] = 200., dDecel[0] = 0.;    <== Acceleration
// 						dVel[1] = 500., dAccel[1] = 100., dDecel[1] = 0.;    <== Acceleration
// 						dVel[2] = 700., dAccel[2] = 200., dDecel[2] = 250.;  <== Acceleration, constant velocity, Deceleration
// 						dVel[3] = 500., dAccel[3] = 0.,   dDecel[3] = 150.;  <== Deceleration
// 						dVel[4] = 200., dAccel[4] = 0.,   dDecel[4] = 350.;  <== Deceleration
// 					Exits API at the point that pulse out starts.
// 	- Set by the distance to the target axis position or the position to increase or decrease the movement begins.
//			function AxmMoveStartPosWithPosEvent(lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDccel : Double; lEventAxisNo : LongInt; dComparePosition : Double; uPositionSource : DWord) : DWord; stdcall;
// 					lEvnetAxisNo    : Start condition occurs axis.
// 					dComparePosition: Conditions Occurrence Area of Start condition occurs axis.
// 					uPositionSource : Set Conditions Occurrence Area of Start condition occurs axis => COMMAND(0), ACTUAL(1)
// 					Cancellations after reservation AxmMoveStop, AxmMoveEStop, AxmMoveSStop use
// 					Motion Axis and Start condition occurs axis must be In same group(case by 2V04 In same module).
// 	- Slowdown stops by deceleration set for specific axis.
//			function AxmMoveStop (lAxisNo : LongInt; dDecel : Double) : DWord; stdcall;
//			function AxmMoveStopEx(lAxisNo : LongInt; dDecel : Double): DWord; stdcall;
// 					dDecel : Deceleration value when stop. 
// 	* Stops specific axis emergently .
//			function AxmMoveEStop (lAxisNo : LongInt) : DWord; stdcall;	//F2CH?
// 	* Stops specific axis slow down. 
//			function AxmMoveSStop (lAxisNo : LongInt) : DWord; stdcall;	//F2CH?
//
// << Overdrive API >> =========================================================
// << Move API by master, slave gear ration >> =================================
// << API related to gentry >> =================================================
// << Regular interpolation API >> =============================================
// << Continuous interpolation API >> ==========================================
//
// << trigger API >> ===========================================================
// 	Set whether to use of trigger function, output level, position comparator, trigger signal delay time and trigger output mode ino specific axis.
// 	- Set trigger signal delay time , trigger output level and trigger output method in specific axis. 
//			function AxmTriggerSetTimeLevel (lAxisNo : LongInt; dTrigTime : Double; uTriggerLevel : DWord; uSelect : DWord; uInterrupt : DWord) : DWord; stdcall;
// 	- Return trigger signal delay time , trigger output level and trigger output method to specific axis.
//			function AxmTriggerGetTimeLevel (lAxisNo : LongInt; dpTrigTime : PDouble; upTriggerLevel : PDWord; upSelect : PDWord; upInterrupt : PDWord) : DWord; stdcall;    
//  				dTrigTime  : trigger output time 
//   		 			         : 1usec - max 50msec ( set 1 - 50000)
//  				upTriggerLevel  : whether to use or not use     => LOW(0), HIGH(1), UNUSED(2), USED(3)
//  				uSelect         : Standard position to use    => COMMAND(0), ACTUAL(1)
//  				uInterrupt      : set interrupt        => DISABLE(0), ENABLE(1)
// 	- in case of absolute selection: The position on which to output, If same as this position then output goes out unconditionally. 
//			function AxmTriggerSetAbsPeriod (lAxisNo : LongInt; uMethod : DWord; dPos : Double) : DWord; stdcall;
//  				uMethod :   PERIOD_MODE   0x0 : cycle trigger method using trigger position value
//         				     ABS_POS_MODE  0x1 : Trigger occurs at trigger absolute position,  absolute position method
//  				dPos : in case of cycle selection : the relevant position  for output by position and position. 
// 	- Return whether to use of trigger function, output level, position comparator, trigger signal delay time and trigger output mode to specific axis.
//			function AxmTriggerGetAbsPeriod (lAxisNo : LongInt; upMethod : PDWord; dpPos : PDouble) : DWord; stdcall;
//  - Output the trigger by regular interval from the starting position to the ending position specified by user. 
//			function AxmTriggerSetBlock (lAxisNo : LongInt; dStartPos : Double; dEndPos : Double; dPeriodPos : Double) : DWord; stdcall;
// 	- Read trigger setting value of 'AxmTriggerSetBlock' API.
//			function AxmTriggerGetBlock (lAxisNo : LongInt; dpStartPos : PDouble; dpEndPos : PDouble; dpPeriodPos : PDouble) : DWord; stdcall;
// 	- User outputs a trigger pulse.
//			function AxmTriggerOneShot (lAxisNo : LongInt) : DWord; stdcall;
// 	- User outputs a trigger pulse after several seconds. 
//			function AxmTriggerSetTimerOneshot (lAxisNo : LongInt; lmSec : LongInt) : DWord; stdcall;
// 	- Output absolute position trigger infinite absolute position output.
//			function AxmTriggerOnlyAbs (lAxisNo : LongInt; lTrigNum : LongInt; dpTrigPos : PDouble) : DWord; stdcall;
// 	- Reset trigger settings.
//			function AxmTriggerSetReset (lAxisNo : LongInt) : DWord; stdcall;
//
// << CRC( Remaining pulse clear API) >> =======================================
//	= Set whether to use CRC signal in specific axis and output level.
//			function AxmCrcSetMaskLevel (lAxisNo : LongInt; uLevel : Dword; lMethod : Dword) : DWord; stdcall;
//					Level   : LOW(0), HIGH(1), UNUSED(2), USED(3) 
//					uMethod : Available to set the width of remaining pulse eliminating output signal pulse in 2 - 6.
//          		0: Don't care , 1: Don't care, 2: 500 uSec, 3:1 mSec, 4:10 mSec, 5:50 mSec, 6:100 mSec
// 	- Return whether to use CRC signal of specific axis and output level.
//			function AxmCrcGetMaskLevel (lAxisNo : LongInt; upLevel : PDWord; upMethod : PDword) : DWord; stdcall;
//					uOnOff  : Whether to generate CRC signal to the Program or not.  (FALSE(0),TRUE(1))

// 	= Force to generate CRC signal to the specific axis.
//			function AxmCrcSetOutput (lAxisNo : LongInt; uOnOff : DWord) : DWord; stdcall;
// 	- Return whether to forcedly generate CRC signal of specific axis.
//			function AxmCrcGetOutput (lAxisNo : LongInt; upOnOff : PDWord) : DWord; stdcall;    
//
// << MPG(Manual Pulse Generation) API >> ======================================
// << Helical move >> ==========================================================
// << Spline move >> ===========================================================
// << Compensation Table >> ====================================================
// << Electronic CAM >> ========================================================
//
// << Servo Status Monitor >> ==================================================
// 	- Set exception function of specific axis. (Only for MLII, Sigma-5)
//			function AxmStatusSetServoMonitor(lAxisNo : LongInt; dwSelMon : DWord; dActionValue : Double; dwAction : DWord) : DWord; stdcall;
// 	- Return exception function of specific axis. (Only for MLII, Sigma-5)
//			function AxmStatusGetServoMonitor(lAxisNo : LongInt; dwSelMon : DWord; dpActionValue : PDouble; dwpAction : PDWord) : DWord; stdcall;
// 	- Set exception function usage of specific axis. (Only for MLII, Sigma-5)
//			function AxmStatusSetServoMonitorEnable(lAxisNo : LongInt; dwEnable : DWord) : DWord; stdcall;
// 	- Return exception function usage of specific axis. (Only for MLII, Sigma-5)
//			function AxmStatusGetServoMonitorEnable(lAxisNo : LongInt; dwpEnable : PDWord) : DWord; stdcall;
// 	- Return exception function execution result Flag of specific axis. Auto reset after function execution. (Only for MLII, Sigma-5)
//			function AxmStatusReadServoMonitorFlag(lAxisNo : LongInt; dwSelMon : DWord; dwpMonitorFlag : PDWord; dpMonitorValue : PDouble) : DWord; stdcall;
// 	- Return exception function monitoring information of specific axis. (Only for MLII, Sigma-5)
//			function AxmStatusReadServoMonitorValue(lAxisNo : LongInt; dwSelMon : DWord; dpMonitorValue : PDouble) : DWord; stdcall;
// 	- Set load ratio monitor function of specific axis. (Only for MLII, Sigma-5)
//			function AxmStatusSetReadServoLoadRatio(lAxisNo : LongInt; dwSelMon : DWord) : DWord; stdcall;
// 					dwSelMon = 0 : Accumulated load ratio
// 					dwSelMon = 1 : Regenerative load ratio
// 					dwSelMon = 2 : Reference Torque load ratio
// 	- Return load ratio of specific axis. (Only for MLII, Sigma-5)
//			function AxmStatusReadServoLoadRatio(lAxisNo : LongInt; dpMonitorValue : PDouble) : DWord; stdcall;
//
// << Only for PCI-R1604-RTEX >> ===============================================
// << Only for PCI-R1604-MLII >> ===============================================
// << Only for PCI-R1604-SSCNETIIIH >> =========================================
// << Only For MLIII >> ========================================================
// << Only For SMP >> ==========================================================

