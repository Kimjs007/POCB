unit MotionCtlAxt;
{
Mainter				              MotionCtl/DioCtl	MotionCtlAxt		      AXT:CFS20
btnMotorMoveAbsClick  		  -> MoveABS 		    -> MoveABS(aPos)	    : CFS20start_move
btnMotorMoveDecClick 		    -> MoveINC 		    -> MoveINC(rPos)	    : CFS20start_r_move
btnMotorMoveIncClick  		  -> MoveINC 		    -> MoveINC(-rPos)	    : CFS20start_r_move
btnMotorMoveJogDecClick     -> MoveJOG        -> MoveJOG?           :
btnMotoMoverJogIncClick     -> MoveJOG        -> MoveJOG?           :
btnMotorMoveLimitMinusClick	-> MoveLIMIT 		  -> MoveLIMIT(-)       :
btnMotorMoveLimitPlusClick 	-> MoveLIMIT  		-> MoveLIMIT(+)       :
btnMotorOriginClick       	-> MoveHOME		    -> MoveHOME           :
btnMotorStopClick      		  -> MoveSTOP 		  -> MoveSTOP           : CFS20set_stop
btnMotorStopEmsClick		    -> MoveSTOP(EMS)	-> MoveSTOP(EMS)	    : CFS20set_e_stop
btnMotorServoOnClick		    -> ServoOnOff		  -> ServoOnOff(on)     :
btnMotorServoOffClick		    -> ServoOnOff		  -> ServoOnOff(Off)    :

btnStageForwardCh1Click		  -> MoveFORWARD		-> MoveABS(ModelPos)  : CFS20start_move
btnStageForwardCh1Click		  -> MoveFORWARD		-> MoveABS(ModelPos)  : CFS20start_move
btnStageBackwardCh1Click	  -> MoveBACKWARD		-> MoveABS(0)         : CFS20start_move
btnStageBackwardCh2Click	  -> MoveBACKWARD		-> MoveABS(0          : CFS20start_move
}
interface
{$I Common.inc}

uses
  Winapi.Windows, System.SysUtils,  System.Classes, Vcl.ExtCtrls,
  // 3rd-party Classes
	AxtLIBDef, AxtLIB, AxtCAMCFS20,
  //
  DefPocb, DefMotion, CommonClass, CodeSiteLogging;

//const

type

  AxtApiStatusRec = record
    m_bAxtInitialized       : Boolean;
    m_bAxtDeviceOpened      : Boolean;
    m_bAxtCFS20Initialized  : Boolean;
    m_bAxtConnected         : Boolean;
    m_sDeviceVersion        : string;
  end;

  TMotionAxt = class(TObject)
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
      m_sErrLibApi      : string;
      m_bConnected      : Boolean;
      m_bServoOn        : Boolean;
      //
      m_bAxtInitialized       : Boolean;
      m_bAxtDeviceOpened      : Boolean;
      m_bAxtCFS20Initialized  : Boolean;
      m_bAxtConnected         : Boolean;
      m_sDeviceVersion        : string;
      //
      m_AxtApiStatusRec : AxtApiStatusRec;
      //DEL!! m_MotionStatus, m_MotionStatusOld : AxtMCStatusRec;
      //
      constructor Create(hMain: THandle; nMotionID: Integer; nCh: Integer; nAxisType: Integer; nMotorNo: Integer); virtual;
      destructor Destroy; override;
			//---------------------- TMotorAxt: Connect/Close/MotionInit
			function Connect: Integer;
			procedure CloseAxt;
			function MotionInit: Integer;
			function MotionReset: Integer;
			function ServoOnOff(bIsOn: Boolean): Integer;
			//---------------------- TMotorAxt: Move Start/Stop
      function MoveSTART(MotionParam: RMotionParam): Integer;
			function MoveSTOP(MotionParam: RMotionParam; bIsEMS: Boolean = False): Integer;
			//---------------------- TMotorAxt: Move ABS/INC/JOG/LIMIT/HOME
			function MoveABS(MotionParam: RMotionParam; dAbsPos: Double): Integer;
      function MoveINC(MotionParam: RMotionParam; dIncDecPos: Double): Integer;
			function MoveJOG(MotionParam: RMotionParam; bIsPlus: Boolean): Integer;
      function MoveLIMIT(MotionParam: RMotionParam; bIsPlus: Boolean): Integer;
			function MoveHOME(MotionParam: RMotionParam; bDoPreCheck: Boolean = False): Integer;
			//---------------------- TMotorAxt: Get
      function GetMotionStatus(var MotionStatus: MotionStatusRec): Boolean;
			function GetActPos(var dActPos: Double): Integer;
			function GetCmdPos(var dCmdPos: Double): Integer;
			function SetActPos(dActPos: Double): Integer;
			function SetCmdPos(dCmdPos: Double): Integer;
			function IsMotionHome: Boolean;
			function IsMotionMoving: Boolean;
      function IsMotionAlarmOn: Boolean;
  end;

implementation

//##############################################################################
//
{ TMotionAxt }
//
//##############################################################################

//******************************************************************************
// procedure/function: TMotorAxt: Create/Destroy/Init
//		- constructor TMotorAxt.Create(hMain: THandle; nMotionID: Integer; nCh: Integer; nAxisType: Integer; nMotorNo: Integer)
//		- destructor TMotorAxt.Destroy
//******************************************************************************

//------------------------------------------------------------------------------
constructor TMotionAxt.Create(hMain: THandle; nMotionID: Integer; nCh: Integer; nAxisType: Integer; nMotorNo: Integer);
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
  //TBD?
end;

//------------------------------------------------------------------------------
destructor TMotionAxt.Destroy;
begin
  //TBD? (어떤 제어가? 어떤 조건에서?)
  m_bConnected := False;

  inherited;
end;

//******************************************************************************
// procedure/function: TMotorAxt: Connect/Close/MotionInit
//		- function TMotorAxt.Connect: Integer;
//		- procedure TMotorAxt.CloseAxt;
//		- function TMotorAxt.MotionInit: Integer;
//		- function TMotorAxt.MotionReset: Integer;
//		- function TMotorAxt.ServoOnOff(bIsOn: Boolean): Integer;
//******************************************************************************

// <<통합라이브러리 초기화 및 종료>> ============================================================================
// 	- 통합 라이브러리를 초기화 한다..
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

//------------------------------------------------------------------------------
function TMotionAxt.Connect: Integer;
var
	nErrCode 	: Integer;
begin
	m_sErrLibApi := '';
	nErrCode 		 := DefPocb.ERR_MOTION_CONNECT;
	//-------------------------- 통합라이브러리 초기화
{$IFNDEF SIMULATOR_MOTION}
	if (not AxtIsInitialized) then begin 		// 통합라이브러리가 사용 가능하지(초기화가 되었는지)를 확인
		if (not AxtInitialize(0{HWND}, 0{nIrqNo})) then begin	// 통합 라이브러리를 초기화
			m_bAxtInitialized := False;
			m_sErrLibApi := 'AxtInitialize';
			Exit(nErrCode);
		end;
	end;
{$ENDIF}
	m_bAxtInitialized := True;
	//-------------------------- 베이스보드 오픈 (BUSTYPE_PCI:1)
{$IFNDEF SIMULATOR_MOTION}
	if (AxtIsInitializedBus(AxtLIBDef.BUSTYPE_PCI{BusType}) = 0) then begin			// 지정한 버스(PCI)가 초기화 되었는지를 확인
		if (AxtOpenDeviceAuto(AxtLIBDef.BUSTYPE_PCI{BusType}) = 0) then begin			// 새로운 베이스보드를 자동으로 통합라이브러리에 추가
			m_bAxtDeviceOpened := False;
			m_sErrLibApi := 'AxtOpenDeviceAuto('+IntToStr(AxtLIBDef.BUSTYPE_PCI)+')';
			Exit(nErrCode);
		end;
		AxtDisableInterrupt(0);
	end;
{$ENDIF}
	m_bAxtDeviceOpened := True;
	//-------------------------- CAMC-FS(SMC-2V02) Board 초기화
{$IFNDEF SIMULATOR_MOTION}
	// - CAMC-FS20 모듈의 사용이 가능한지를 확인
	if (not CFS20IsInitialized) then begin
		// - CAMC-FS가 장착된 모듈(SMC-1V02, SMC-2V02)을 검색하여 초기화(CAMC-FS 2.0이상만 검출)
		//	reset : 1(TRUE) = 레지스터(카운터 등)를 초기화.
		//  	reset(TRUE)일때 초기 설정값.
		//  	1) 인터럽트 사용하지 않음.
		//  	2) 인포지션 기능 사용하지 않음.
		//  	3) 알람정지 기능 사용하지 않음.
		//  	4) 급정지 리미트 기능 사용 함.
		//  	5) 감속정지 리미트 기능 사용 함.
		//  	6) 펄스 출력 모드 : OneLowHighLow(Pulse : Active LOW, Direction : CW{High};CCW{LOW}).
		//  	7) 검색 신호 : +급정지 리미트 신호 하강 에지.
		//  	8) 입력 인코더 설정 : 2상, 4 체배.
		//  	9) 알람, 인포지션, +-감속 정지 리미트, +-급정지 리미트 Active level : HIGH
		// 	 10) 내부/외부 카운터 : 0.  //TBD:MOTION:AXT? 프로그램 재구동시 Reset하면서 Cmd/Act Pos가 0으로 변경됨???
		if (not InitializeCAMCFS20(True{reset})) then begin
			m_bAxtCFS20Initialized := False;
			m_sErrLibApi := 'InitializeCAMCFS20(True)';
			Exit(nErrCode);
		end;
	end;
{$ENDIF}
	m_bAxtCFS20Initialized := True;
	//-------------------------- Board 초기화 파일 Load	//TBD?
//string sInitFileName = String.Format('%s\\Camc5M.mot',Environment.CurrentDirectory);
//byte[] nFilename = new byte[255];
//nFilename = StringToByte(sInitFileName);
//if (CAxtCAMCFS20.CFS20load_parameter_all(ref nFilename[0]) != 1) then begin
//	MotionCtl.m_bAxtCFS20ParamLoaded := False;
//	m_sErrLibApi := 'CFS20load_parameter_all(True)';
//	Exit(ERR_AXTMC_MOTION_PARAM_LOAD);
//end;
//MotionCtl.m_bAxtCFS20paramLoaded := True;
	//
	m_bAxtConnected := True;
	//
	//-------------------------- AXIS 개별에 대한 ???
	m_bConnected := True;
	m_sDeviceVersion 	:= '';	// Clear
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
procedure TMotionAxt.CloseAxt;
begin
  //-------------------------- 통합라이브러리 사용을 종료
	AxtClose;
  //-------------------------- 
	m_bAxtInitialized 			:= False;
	m_bAxtDeviceOpened 			:= False;
	m_bAxtCFS20Initialized 	:= False;
//m_bAxtCFS20paramLoaded 	:= False;
	m_bAxtConnected 				:= False;
  m_bConnected := False
end;

//------------------------------------------------------------------------------
function TMotionAxt.MotionInit: Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
begin
	m_sErrLibApi := '';
	nErrCode 		 := DefPocb.ERR_MOTION_INIT;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Servo On
	nRet := ServoOnOff(True);
	if (nRet <> DefPocb.ERR_OK) then begin
		Exit(nErrCode);
	end;
  m_bServoOn := True;
	Sleep(500);
  //-------------------------- 서보 알람 입력 신호의 Active Level을 설정
{$IFNDEF SIMULATOR_MOTION}
	if (not CFS20set_alarm_level(m_nAxisNo, 0{level})) then begin
		m_sErrLibApi := 'CFS20set_alarm_level(0)';
		Exit(nErrCode);
	end;
{$ENDIF}
	m_bServoOn := True;
	Sleep(500);
  //--------------------------
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxt.MotionReset: Integer;
var
	bRet 			: Boolean;
	nErrCode 	: Integer;
begin
	m_sErrLibApi := '';
	nErrCode 		 := DefPocb.ERR_MOTION_RESET;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
	//-------------------------- 해당 축의 Alarm Clear 출력을 On (1: Alarm Clear) -> Off
{$IFNDEF SIMULATOR_MOTION}
	bRet := CFS20set_output_bit(m_nAxisNo, DefMotion.AxMC_SIG_OUT_ALARM_CLEAR);
{$ELSE}
  bRet := True; //TBD:SIM:MOTION?
{$ENDIF}
	if (not bRet) then begin
		m_sErrLibApi 	:= 'CFS20set_output_bit('+IntToStr(DefMotion.AxMC_SIG_OUT_ALARM_CLEAR)+')';
		Exit(nErrCode);
	end;
	Sleep(100);
{$IFNDEF SIMULATOR_MOTION}
	bRet := CFS20reset_output_bit(m_nAxisNo, DefMotion.AxMC_SIG_OUT_ALARM_CLEAR);
{$ELSE}
  bRet := True; //TBD:SIM:MOTION?
{$ENDIF}
	if (not bRet) then begin
		m_sErrLibApi 	:= 'CFS20reset_output_bit('+IntToStr(DefMotion.AxMC_SIG_OUT_ALARM_CLEAR)+')';
		Exit(nErrCode);
	end;
	Sleep(100);
	//-------------------------- 펄스 출력 방식을 설정
	// 	- method : 출력 펄스 방식 설정(typedef : PULSE_OUTPUT)
	// 	- OneHighLowHigh   = 0x0, 1펄스 방식, PULSE(Active High), 정방향(DIR=Low)  / 역방향(DIR=High)
	// 	- OneHighHighLow   = 0x1, 1펄스 방식, PULSE(Active High), 정방향(DIR=High) / 역방향(DIR=Low)
	// 	- OneLowLowHigh    = 0x2, 1펄스 방식, PULSE(Active Low),  정방향(DIR=Low)  / 역방향(DIR=High)
	// 	- OneLowHighLow    = 0x3, 1펄스 방식, PULSE(Active Low),  정방향(DIR=High) / 역방향(DIR=Low)
	// 	- TwoCcwCwHigh     = 0x4, 2펄스 방식, PULSE(CCW:역방향),  DIR(CW:정방향),  Active High
	// 	- TwoCcwCwLow      = 0x5, 2펄스 방식, PULSE(CCW:역방향),  DIR(CW:정방향),  Active Low
	// 	- TwoCwCcwHigh     = 0x6, 2펄스 방식, PULSE(CW:정방향),   DIR(CCW:역방향), Active High
	// 	- TwoCwCcwLow      = 0x7, 2펄스 방식, PULSE(CW:정방향),   DIR(CCW:역방향), Active Low
{$IFNDEF SIMULATOR_MOTION}
	bRet := CFS20set_pulse_out_method(m_nAxisNo, 4);	//펄스 출력 방식
{$ELSE}
  bRet := True; //TBD:SIM:MOTION?
{$ENDIF}
	if (not bRet) then begin
		m_sErrLibApi 	:= 'CFS20set_pulse_out_method(4)';
		Exit(nErrCode);
	end;
	Sleep(100);
  //--------------------------
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxt.ServoOnOff(bIsOn: Boolean): Integer;
var
	bRet 			: Boolean;
	nErrCode 	: Integer;
  sTemp     : string;
  dReadUnitPerPulse : Double;
  MotionParam : RMotionParam;
begin
	m_sErrLibApi 	:= '';
	if bIsOn then nErrCode := DefPocb.ERR_MOTION_SERVO_ON
	else  			  nErrCode := DefPocb.ERR_MOTION_SERVO_OFF;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
	//
  Common.GetMotionParam(m_nMotionID,MotionParam);
	if (not bIsOn) then begin		//------------------------------- Servo Off
		//------------------------ 해당 축의 해당 bit의 출력을 Off (Servo Off)
{$IFNDEF SIMULATOR_MOTION}
		bRet := CFS20reset_output_bit(m_nAxisNo, DefMotion.AxMC_SIG_OUT_SERVO_ON); 	// Servo Off
{$ELSE}
    bRet := True;
{$ENDIF}
		if (not bRet) then begin
			m_sErrLibApi 	:= 'CFS20reset_output_bit('+IntToStr(DefMotion.AxMC_SIG_OUT_SERVO_ON)+')';
			Exit(nErrCode);
		end;
  end
	else begin                 //-------------------------------- Servo On

		//------------------------ 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정

    sTemp := '<MOTION> '+Common.GetStrMotionID2ChAxis(m_nMotionID)+': unit/pulse('+FloatToStr(MotionParam.dUnitPerPulse)+') startStopSpeed('+FloatToStr(MotionParam.dStartStopSpeed)+') velocity('+FloatToStr(MotionParam.dVelocity)+')';
    //Common.MLog(SYS_LOG,sTemp,DefPocb.DEBUG_LEVEL_INFO);
{$IFNDEF SIMULATOR_MOTION}
    bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dVelocityMax);
{$ELSE}
    bRet := True;   //TBD:SIM:MOTION?
{$ENDIF}
		if (not bRet) then begin
			m_sErrLibApi 	:= 'CFS20set_max_speed';
			Exit(nErrCode);
		end;
    Sleep(100);
{$IFNDEF SIMULATOR_MOTION}
    CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
{$ENDIF}
    //------------------------ 해당 축의 해당 bit의 출력을 On (Servo On)
{$IFNDEF SIMULATOR_MOTION}
		bRet := CFS20set_output_bit(m_nAxisNo, DefMotion.AxMC_SIG_OUT_SERVO_ON);  // Servo On
{$ELSE}
    bRet := True;
{$ENDIF}
		if (not bRet) then begin
			m_sErrLibApi 	:= 'CFS20reset_output_bit('+IntToStr(DefMotion.AxMC_SIG_OUT_SERVO_ON)+')';
			Exit(nErrCode);
		end;
    Sleep(100);
		//------------------------ Signal Level 설정
{$IFNDEF SIMULATOR_MOTION}
    CFS20set_pend_limit_level(m_nAxisNo, 0);    //POCB_A2CH-specfic (전장 후 MotionControl GUI 값 참고)
    CFS20set_nend_limit_level(m_nAxisNo, 0);    //POCB_A2CH-specfic (전장 후 MotionControl GUI 값 참고)
    CFS20set_pslow_limit_level(m_nAxisNo, 1);   //POCB_A2CH-specfic (전장 후 MotionControl GUI 값 참고)
    CFS20set_nslow_limit_level(m_nAxisNo, 1);   //POCB_A2CH-specfic (전장 후 MotionControl GUI 값 참고)
    CFS20set_inposition_level(m_nAxisNo, 1);    //POCB_A2CH-specfic (전장 후 MotionControl GUI 값 참고)
    CFS20set_alarm_level(m_nAxisNo, 0);         //POCB_A2CH-specfic (전장 후 MotionControl GUI 값 참고)
{$ENDIF}
		//------------------------ Unit/Pulse 설정
{$IFNDEF SIMULATOR_MOTION}
    CFS20set_moveunit_perpulse(m_nAxisNo, MotionParam.dUnitPerPulse);
{$ENDIF}
    Sleep(100);
{$IFNDEF SIMULATOR_MOTION}
    dReadUnitPerPulse := CFS20get_moveunit_perpulse(m_nAxisNo);
{$ELSE}
    dReadUnitPerPulse := MotionParam.dUnitPerPulse;
{$ENDIF}
    sTemp := '<MOTION> '+Common.GetStrMotionID2ChAxis(m_nMotionID)+': Read unit/pulse('+FloatToStr(dReadUnitPerPulse)+')';
    //Common.MLog(SYS_LOG,sTemp,DefPocb.DEBUG_LEVEL_INFO);
		//------------------------ Motor Reset
		Result := MotionReset;
		if (Result <> DefPocb.ERR_OK) then begin
			Exit(nErrCode);
    end;
	end;
	Result := DefPocb.ERR_OK;
end;

//******************************************************************************
// procedure/function: TMotorAxt: Move Start/Stop
//		- function TMotionAxt.MoveStart(MotionParam: RMotionParam): Integer;
//		- function TMotionAxt.MoveStop(MotionParam: RMotionParam; bIsEMS: Boolean = False): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionAxt.MoveStart(MotionParam: RMotionParam): Integer;
var
	bRet 			: Boolean;
	nErrCode 	: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_START;
  //-------------------------- Motion 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm 상태 확인
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
	//
{$IFNDEF SIMULATOR_MOTION}
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dVelocityMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
{$ENDIF}
  Sleep(100);
{$IFNDEF SIMULATOR_MOTION}
	bRet := CFS20v_s_move(m_nAxisNo, MotionParam.dVelocity, MotionParam.dAccel);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20v_s_move';
		Exit(nErrCode);
	end;
{$ENDIF}
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxt.MoveSTOP(MotionParam: RMotionParam; bIsEMS: Boolean = False): Integer;
var
	bRet 			: Boolean;
	nErrCode 	: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_STOP;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
	// 단축 구동 확인 ---------------------
	// 	- 지정 축의 구동이 종료될 때까지 기다린 후 함수를 벗어난다.
	//		function CFS20wait_for_done (axis : SmallInt) : Word; stdcall;
	//
	// 단축 구동 정지 함수군 --------------
	// 	- 지정 축을 급정지한다.
	//		function CFS20set_e_stop (axis : SmallInt) : Boolean; stdcall;
	// 	- 지정 축을 구동시 감속율로 정지한다.
	//		function CFS20set_stop (axis : SmallInt) : Boolean; stdcall;
	// 	- 지정 축을 입력된 감속율로 정지한다.
	//		function CFS20set_stop_decel (axis : SmallInt; deceleration : Double) : Boolean; stdcall;
	// 	- 지정 축을 입력된 감속 시간으로 정지한다.
	//		function CFS20set_stop_deceltime (axis : SmallInt; deceltime : Double) : Boolean; stdcall;
	//
{$IFNDEF SIMULATOR_MOTION}
  //-------------------------- 원점검색을 중지
  CFS20abort_home_search(m_nAxisNo, 1);
  //-------------------------- 급정지 또는 감속정지
	if (bIsEMS) then bRet := CFS20set_e_stop(m_nAxisNo)  // 급정지
	else 						 bRet := CFS20set_stop(m_nAxisNo);   // 감속정지
	if (not bRet) then begin
		if (bIsEMS) then m_sErrLibApi := 'CFS20set_e_stop'
    else             m_sErrLibApi := 'CFS20set_stop';
		Exit(nErrCode);
	end;
{$ELSE}
  //TBD:SIM:MOTION?
{$ENDIF}
	Result := DefPocb.ERR_OK;
end;

//******************************************************************************
// procedure/function: TMotorAxt: Move ABS/INC/JOG
//		- function TMotionAxt.MoveABS(MotionParam: RMotionParam; dAbsPos: Double): Integer;
//		- function TMotionAxt.MoveINC(MotionParam: RMotionParam; dIncDecPos: Double): Integer;
//		- function TMotionAxt.MoveJOG(MotionParam: RMotionParam; bIsPlus: Boolean): Integer;
//    - function TMotionAxt.MoveLIMIT(MotionParam: RMotionParam; bIsPlus: Boolean): Integer;
//    - function TMotionAxt.MoveHOME(MotionParam: RMotionParam; bDoPreCheck: Boolean = False): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionAxt.MoveABS(MotionParam: RMotionParam; dAbsPos: Double): Integer;
var
	bRet 					: Boolean;
	nErrCode 			: Integer;
begin
  //CodeSite.Send('<MOTIONAXT> '+IntToStr(m_nMotionID)+':MoveABS ...start');
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
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- Start/Stop 속도 설정
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정
	bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dVelocityMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
	//-------------------------- 단축 지정 거리 구동
	// 	- start_** : 지정 축에서 구동 시작후 함수를 return한다. 'start_*' 가 없으면 이동 완료후 return한다(Blocking).
	// 	- *r*_*    : 지정 축에서 입력된 거리만큼(상대좌표)로 이동한다. '*r_*'이 없으면 입력된 위치(절대좌표)로 이동한다.
	// 	- *s*_*    : 구동중 속도 프로파일을 'S curve'를 이용한다. '*s_*'가 없다면 사다리꼴 가감속을 이용한다.
	// 	- *a*_*    : 구동중 속도 가감속도를 비대칭으로 사용한다. 가속률 또는 가속 시간과  감속률 또는 감속 시간을 각각 입력받는다.
	// 	- *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. '*_ex'가 없다면 가감속률로 입력 받는다.
	// 	- 입력 값들: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
	//
  bRet := CFS20start_move(m_nAxisNo, dAbsPos, MotionParam.dVelocity, MotionParam.dAccel);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20start_move';
		Exit(nErrCode);
	end;
  Sleep(10);
  while (CFS20in_motion(m_nAxisNo)) do begin
    Sleep(100);
  end;
  Sleep(100);
{$ENDIF}
	Result := DefPocb.ERR_OK;
  //CodeSite.Send('<MOTIONAXT> '+IntToStr(m_nMotionID)+':MoveABS ...end');
end;

//------------------------------------------------------------------------------
function TMotionAxt.MoveINC(MotionParam: RMotionParam; dIncDecPos: Double): Integer;
var
	bRet 					: Boolean;
	nErrCode 			: Integer;
begin
	m_sErrLibApi 	:= '';
  if (dIncDecPos < 0) then	nErrCode := DefPocb.ERR_MOTION_MOVE_DEC
  else                      nErrCode := DefPocb.ERR_MOTION_MOVE_INC;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm 상태 확인  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- Start/Stop 속도 설정
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정
	bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dVelocityMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- 단축 지정 거리 구동
	// 	- start_** : 지정 축에서 구동 시작후 함수를 return한다. 'start_*' 가 없으면 이동 완료후 return한다(Blocking).
	// 	- *r*_*    : 지정 축에서 입력된 거리만큼(상대좌표)로 이동한다. '*r_*'이 없으면 입력된 위치(절대좌표)로 이동한다.
	// 	- *s*_*    : 구동중 속도 프로파일을 'S curve'를 이용한다. '*s_*'가 없다면 사다리꼴 가감속을 이용한다.
	// 	- *a*_*    : 구동중 속도 가감속도를 비대칭으로 사용한다. 가속률 또는 가속 시간과  감속률 또는 감속 시간을 각각 입력받는다.
	// 	- *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. '*_ex'가 없다면 가감속률로 입력 받는다.
	// 	- 입력 값들: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
	//
	bRet := CFS20start_r_move(m_nAxisNo, dIncDecPos, MotionParam.dVelocity, MotionParam.dAccel);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20start_r_move';
		Exit(nErrCode);
	end;
{$ENDIF}
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxt.MoveJOG(MotionParam: RMotionParam; bIsPlus: Boolean): Integer;
var
  dJogVel   : Double;
	bRet 			: Boolean;
	nErrCode 	: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_JOG;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
 //-------------------------- Motion Alarm 상태 확인  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
 {$IFNDEF SIMULATOR_MOTION}
	//-------------------------- Start/Stop 속도 설정
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정
	bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dJogVelocityMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
	//-------------------------- 단축 지정 거리 구동
	// 	- start_** : 지정 축에서 구동 시작후 함수를 return한다. 'start_*' 가 없으면 이동 완료후 return한다(Blocking).
	// 	- *r*_*    : 지정 축에서 입력된 거리만큼(상대좌표)로 이동한다. '*r_*'이 없으면 입력된 위치(절대좌표)로 이동한다.
	// 	- *s*_*    : 구동중 속도 프로파일을 'S curve'를 이용한다. '*s_*'가 없다면 사다리꼴 가감속을 이용한다.
	// 	- *a*_*    : 구동중 속도 가감속도를 비대칭으로 사용한다. 가속률 또는 가속 시간과  감속률 또는 감속 시간을 각각 입력받는다.
	// 	- *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. '*_ex'가 없다면 가감속률로 입력 받는다.
	// 	- 입력 값들: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
	//
  if bIsPlus then dJogVel := Abs(MotionParam.dVelocity)
  else            dJogVel := Abs(MotionParam.dVelocity) * -1;  //TBD:MOTION:JOG?
	bRet := CFS20v_move(m_nAxisNo, dJogVel, Abs(MotionParam.dJogAccel));  //TBD:MOTION:JOG?
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20v_move';
		Exit(nErrCode);
	end;
 {$ENDIF}
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxt.MoveLIMIT(MotionParam: RMotionParam; bIsPlus: Boolean): Integer;
var
  dAbsPos  : Double;
	bRet 		 : Boolean;
	nErrCode : Integer;
begin
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
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- Start/Stop 속도 설정
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정
	bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dJogVelocityMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
	//-------------------------- 단축 지정 거리 구동
	// 	- start_** : 지정 축에서 구동 시작후 함수를 return한다. 'start_*' 가 없으면 이동 완료후 return한다(Blocking).
	// 	- *r*_*    : 지정 축에서 입력된 거리만큼(상대좌표)로 이동한다. '*r_*'이 없으면 입력된 위치(절대좌표)로 이동한다.
	// 	- *s*_*    : 구동중 속도 프로파일을 'S curve'를 이용한다. '*s_*'가 없다면 사다리꼴 가감속을 이용한다.
	// 	- *a*_*    : 구동중 속도 가감속도를 비대칭으로 사용한다. 가속률 또는 가속 시간과  감속률 또는 감속 시간을 각각 입력받는다.
	// 	- *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. '*_ex'가 없다면 가감속률로 입력 받는다.
	// 	- 입력 값들: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
	//
  if bIsPlus then dAbsPos := MotionParam.dSoftLimitPlus  + 2000  //TBD:MOTION:toLIMIT?
  else            dAbsPos := MotionParam.dSoftLimitMinus - 2000; //TBD:MOTION:toLIMIT?
  bRet := CFS20start_move(m_nAxisNo, dAbsPos, MotionParam.dJogVelocity, MotionParam.dJogAccel);  //TBD:MOTION:toLIMIT?
  if bRet then begin
		m_sErrLibApi := 'CFS20start_move';
		Exit(nErrCode);
	end;
{$ENDIF}
  //
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
// 원점검색 ====================================================================
//	라이브러리 상에서 Thread를 사용하여 검색한다. 주의 : 구동후 칩내의 StartStop Speed가 변할 수 있다.
//	-	원점검색을 종료한다.
//		function CFS20abort_home_search (axis : SmallInt; bStop : Byte) : Boolean; stdcall;
// 				bStop: 0(감속정지), 1(급정지)
//	-	원점검색을 시작한다. 시작하기 전에 원점검색에 필요한 설정이 필요하다.
//		function CFS20home_search (axis : SmallInt) : Boolean; stdcall;
//	-	입력 축들을 동시에 원점검색을 실시한다.
//		function CFS20home_search_all (number : SmallInt; axes : PSmallInt) : Boolean; stdcall;
//	-	원점검색 진행 중인지를 확인한다.
//		function CFS20get_home_done (axis : SmallInt) : Boolean; stdcall;
// 				반환값: 0(원점검색 진행중), 1(원점검색 종료)
//	-	해당 축들의 원점검색 진행 중인지를 확인한다.
//		function CFS20get_home_done_all (number : SmallInt; axes : PSmallInt) : Boolean; stdcall;
//	-	지정 축의 원점 검색 실행후 종료 상태를 확인한다.
//		function CFS20get_home_end_status (axis : SmallInt) : Byte; stdcall;
// 				반환값: 0(원점검색 실패), 1(원점검색 성공)
//	-	지정 축들의 원점 검색 실행후 종료 상태를 확인한다.
//		function CFS20get_home_end_status_all (number : SmallInt; axes : PSmallInt; endstatus : PByte) : Boolean; stdcall;
//	-	원점 검색시 각 스텝마다 method를 설정/확인한다.
//		function CFS20set_home_method (axis : SmallInt; nstep : SmallInt; method : PByte) : Boolean; stdcall;
//		function CFS20get_home_method (axis : SmallInt; nstep : SmallInt; method : PByte) : Boolean; stdcall;
// 				Method에 대한 설명
//    				0 Bit 스텝 사용여부 설정 (0 : 사용하지 않음, 1: 사용함)
//    				1 Bit 가감속 방법 설정 (0 : 가속율, 1 : 가속 시간)
//    				2 Bit 정지방법 설정 (0 : 감속 정지, 1 : 급 정지)
//    				3 Bit 검색방향 설정 (0 : cww(-), 1 : cw(+))
// 				 7654 Bit detect signal 설정(typedef : DETECT_DESTINATION_SIGNAL)
//	-	원점 검색시 각 스텝마다 offset을 설정/확인한다.
//		function CFS20set_home_offset (axis : SmallInt; nstep : SmallInt; offset : PDouble) : Boolean; stdcall;
//		function CFS20get_home_offset (axis : SmallInt; nstep : SmallInt; offset : PDouble) : Boolean; stdcall;
//	-	각 축의 원점 검색 속도를 설정/확인한다.
//		function CFS20set_home_velocity (axis : SmallInt; nstep : SmallInt; velocity : PDouble) : Boolean; stdcall;
//		function CFS20get_home_velocity (axis : SmallInt; nstep : SmallInt; velocity : PDouble) : Boolean; stdcall;
//	-	지정 축의 원점 검색 시 각 스텝별 가속율을 설정/확인한다.
//		function CFS20set_home_acceleration (axis : SmallInt; nstep : SmallInt; acceleration : PDouble) : Boolean; stdcall;
//		function CFS20get_home_acceleration (axis : SmallInt; nstep : SmallInt; acceleration : PDouble) : Boolean; stdcall;
//	-	지정 축의 원점 검색 시 각 스텝별 가속 시간을 설정/확인한다.
//		function CFS20set_home_acceltime (axis : SmallInt; nstep : SmallInt; acceltime : PDouble) : Boolean; stdcall;
//		function CFS20get_home_acceltime (axis : SmallInt; nstep : SmallInt; acceltime : PDouble) : Boolean; stdcall;
//	-	지정 축에 원점 검색에서 엔코더 'Z'상 검출 사용 시 구동 한계값를 설정/확인한다.(Pulse) - 범위를 벗어나면 검색 실패
//		function CFS20set_zphase_search_range (axis : SmallInt; pulses : SmallInt) : Boolean; stdcall;
//		function CFS20get_zphase_search_range (axis : SmallInt) : SmallInt; stdcall;
//	-	현재 위치를 원점(0 Position)으로 설정한다. - 구동중이면 무시됨.
//		function CFS20home_zero (axis : SmallInt) : Boolean; stdcall;
//	-	설정한 모든 축의 현재 위치를 원점(0 Position)으로 설정한다. - 구동중인 축은 무시됨
//		function CFS20home_zero_all (number : SmallInt; axes : PSmallInt) : Boolean; stdcall;
//
function TMotionAxt.MoveHOME(MotionParam: RMotionParam; bDoPreCheck: Boolean = False): Integer;
var
	bRet 					: Boolean;
	nErrCode 			: Integer;
  nSearchDir    : Integer;
	nHomeStep			: SmallInt;
	dHomeVelMax 	: Double;
	methods 			: array[0..Pred(DefMotion.AxMC_SEARCH_HOME_STEP_MAX)] of Byte;
	velocities 		: array[0..Pred(DefMotion.AxMC_SEARCH_HOME_STEP_MAX)] of Double;
	accelerations : array[0..Pred(DefMotion.AxMC_SEARCH_HOME_STEP_MAX)] of Double;
  sTemp : string;
begin
  //CodeSite.Send('<MOTIONAXT> '+IntToStr(m_nMotionID)+':MoveHOME ...start');
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_TO_HOME;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm 상태 확인  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
	//-------------------------- 원점 검색 전, 사전 확인 (Home 상태, Moving)
	if (bDoPreCheck) then begin
  { //TBD? if (not IsMotorHome) then begin
			//LogMessage('AXT_MotorHome -> Searching Home Motor Position Now !');
			Exit(nErrCode);
		end; }
		if (IsMotionMoving) then begin
		//LogMessage('AXT_MotorHome -> Motor Moving Error !');
			Exit(nErrCode);
		end;
	end;
{$IFNDEF SIMULATOR_MOTION}
  //-------------------------- Unit/Pulse 설정
  CFS20set_moveunit_perpulse(m_nAxisNo, MotionParam.dUnitPerPulse{unitperpulse});
  sTemp := FloatToStr(CFS20get_moveunit_perpulse(m_nAxisNo));
	//-------------------------- Start/Stop 속도 설정
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정
	bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dVelocityMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
  //Common.MLog(SYS_LOG,'GetUnitPerPulse('+sTemp+')',DefPocb.DEBUG_LEVEL_INFO);
  Sleep(100);

  //------------------------ -Limit으로 이동
  bRet := CFS20start_move(m_nAxisNo, MotionParam.dSoftLimitMinus-10000{TBD:MOTION:toLIMIT?}, MotionParam.dJogVelocity, MotionParam.dJogAccel);
  Sleep(100);  //TBD? 2018-12-04
  while (bRet and CFS20in_motion(m_nAxisNo)) do begin
    Sleep(100);
  end;

	//-------------------------- 원점 검색시 스텝 수 결정
{$IFDEF ORG_SAVE}
	nHomeStep := 4;
	//-------------------------- 원점 검색시 각 스텝마다 method를 설정한다.
	if (nSearchDir = DefMotion.AxtMC_SEARCH_HOME_DIR_CCW) then begin
		//----- Step.0: (+)방향으로 홈 센서의 상승에지 신호를 검색함, 정지시 가속정지, 원점센서가 감지되어 있을 때 Step0를 사용하지 않음
		if (not CFS20input_bit_on(m_nAxisNo, DefMotion.AxtMC_SIG_IN_HOME)) then		// 원점센서가 감지되어 있지않을 때
			methods[0] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_IN0_UPEDGE
		else 			// 원점센서가 감지되어 있을 때
			methods[0] := $00;
		//----- Step.1: (-)방향으로 홈 센서의 하강에지 신호를 검색함, 정지시 급정지
		methods[1] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN0_DNEDGE or DefMotion.AxtMC_HOME_METHOD_DIR_CW;
		//----- Step.2: (+)방향으로 홈 센서의 상승에지 신호를 검색함, 정지시 급정지
		methods[2] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN0_UPEDGE;
	 	//----- Step.3: (-)방향으로 Z상 센서의 하강에지 신호를 검색함, 정지시 급정지
		methods[3] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN1_DNEDGE or DefMotion.AxtMC_HOME_METHOD_DIR_CW;
	end
	else begin
		//----- Step.0: (+)방향으로 홈 센서의 상승에지 신호를 검색함, 정지시 감속정지, 원점센서가 감지되어 있을 때 Step0를 사용하지 않음
		if (not CFS20input_bit_on(m_nAxisNo, DefMotion.AxtMC_SIG_IN_HOME)) then		// 원점센서가 감지되어 있지않을 때
			methods[0] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_IN0_UPEDGE or DefMotion.AxtMC_HOME_METHOD_DIR_CW
		else 			// 원점센서가 감지되어 있을 때
			methods[0] := $00;
		//----- Step.1: (+)방향으로 홈 센서의 하강에지 신호를 검색함, 정지시 급정지
		methods[1] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN0_DNEDGE;
		//----- Step.2: (-)방향으로 홈 센서의 상승에지 신호를 검색함, 정지시 급정지
		methods[2] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN0_UPEDGE or DefMotion.AxtMC_HOME_METHOD_DIR_CW;
	 	//----- Step.3: (+)방향으로 Z상 센서의 하강에지 신호를 검색함, 정지시 급정지
		methods[3] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN1_DNEDGE;
	end;
{$ELSE}
  nHomeStep := 3; //DefMotion.AxtMC_SEARCH_HOME_STEP_DEFAULT;	//TBD? (4 -> 3 변경시 MUTING Lamp On 됨)
//nHomeStep := 4; //DefMotion.AxtMC_SEARCH_HOME_STEP_DEFAULT;	//TBD? (4 -> 3 변경시 MUTING Lamp On 됨)
	//-------------------------- 원점 검색시 각 스텝마다 method를 설정한다.
  //2018-11-27 if (m_nMotionID = DefMotion.MOTIONID_AxtMC_STAGE2_Y) then nSearchDir := AxtMC_SEARCH_HOME_DIR_CW;  //TBD? (2018-11-15 CH2-Y축은 반대로 움직임)
  nSearchDir := DefMotion.AxMC_SEARCH_HOME_DIR_CCW;
	if (nSearchDir = DefMotion.AxMC_SEARCH_HOME_DIR_CCW) then begin
		//----- Step.0: (+)방향으로 홈 센서의 상승에지 신호를 검색함, 정지시 가속정지, 원점센서가 감지되어 있을 때 Step0를 사용하지 않음
		if (not {CAxtCAMCFS20}CFS20input_bit_on(m_nAxisNo{axis}, DefMotion.AxMC_SIG_IN_HOME{bitNo})) then		// 원점센서가 감지되어 있지않을 때
			methods[0] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_IN0_UPEDGE
		else 			// 원점센서가 감지되어 있을 때
			methods[0] := $00;
		//----- Step.1: (-)방향으로 홈 센서의 하강에지 신호를 검색함, 정지시 급정지
		methods[1] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_DNEDGE or DefMotion.AxMC_HOME_METHOD_DIR_CW;
		//----- Step.2: (+)방향으로 홈 센서의 상승에지 신호를 검색함, 정지시 급정지
		methods[2] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_UPEDGE;
	 	//----- Step.3: (-)방향으로 Z상 센서의 하강에지 신호를 검색함, 정지시 급정지
    methods[3] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_DNEDGE or DefMotion.AxMC_HOME_METHOD_DIR_CW;
  //methods[3] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN1_DNEDGE or DefMotion.AxMC_HOME_METHOD_DIR_CW;
	end
	else begin
		//----- Step.0: (+)방향으로 홈 센서의 상승에지 신호를 검색함, 정지시 감속정지, 원점센서가 감지되어 있을 때 Step0를 사용하지 않음
		if (not {CAxtCAMCFS20}CFS20input_bit_on(m_nAxisNo{axis}, DefMotion.AxMC_SIG_IN_HOME{bitNo})) then		// 원점센서가 감지되어 있지않을 때
			methods[0] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_IN0_DNEDGE or DefMotion.AxMC_HOME_METHOD_DIR_CW
		else 			// 원점센서가 감지되어 있을 때
			methods[0] := $00;
		//----- Step.1: (+)방향으로 홈 센서의 하강에지 신호를 검색함, 정지시 급정지
		methods[1] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_UPEDGE;
		//----- Step.2: (-)방향으로 홈 센서의 상승에지 신호를 검색함, 정지시 급정지
		methods[2] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_DNEDGE or DefMotion.AxMC_HOME_METHOD_DIR_CW;
	 	//----- Step.3: (+)방향으로 Z상 센서의 하강에지 신호를 검색함, 정지시 급정지
    methods[3] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_UPEDGE;
	//methods[3] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN1_DNEDGE;
	end;
{$ENDIF}
	bRet := CFS20set_home_method(m_nAxisNo, nHomeStep, @methods); // 축별로 홈검색 방법을 설정한다..
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_home_method';
		Exit(nErrCode);
	end;
  Sleep(50);
	//-------------------------- 원점 검색을 위한 각 Step별 속도 설정, 기구에 맞는 속도로 정의
	case m_nAxisType of
{$IFDEF HAS_MOTION_CAM_Z}
		DefMotion.MOTION_AXIS_Z: begin
      dHomeVelMax := 10*1.2;  //TBD? Common.MotionInfo.ZaxisVelocity;
			//----- Step.0
			velocities[0] := 5;	accelerations[0] := 1;    //2018-12-11 10->5
			//----- Step.1
			velocities[1] := 3;   accelerations[1] := 1;  //2018-12-11 5->3
			//----- Step.2
			velocities[2] := 2;   accelerations[2] := 1;  //2018-12-11 3->2
			//----- Step.3
			velocities[3] := 1;   accelerations[3] := 1;  //2018-12-11 3->2
		end;
{$ENDIF}
		DefMotion.MOTION_AXIS_Y: begin
      dHomeVelMax := 10*1.2;  //TBD? Common.MotionInfo.YaxisVelocity;
			//----- Step.0
			velocities[0] := 5;	accelerations[0] := 1;  //2018-12-11 10->5
			//----- Step.1
			velocities[1] := 3;   accelerations[1] := 1;  //2018-12-11 5->3
			//----- Step.2
			velocities[2] := 2;   accelerations[2] := 1;  //2018-12-11 3->2
			//----- Step.3
			velocities[3] := 1;   accelerations[3] := 1;  //2018-12-11 3->2
    end;
    else
   		Exit(nErrCode);
	end;
	//-------------------------- 축의 원점 검색시 최고속도 설정
	bRet := CFS20set_max_speed(m_nAxisNo, dHomeVelMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
  Sleep(50);
	//-------------------------- 축의 원점 검색 시 각 스텝별 속도 설정
	bRet := CFS20set_home_velocity(m_nAxisNo, nHomeStep, @velocities);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_home_velocity';
		Exit(nErrCode);
	end;
    Sleep(50);
	//-------------------------- 축의 원점 검색 시 각 스텝별 가속율을 설정
	bRet := CFS20set_home_acceleration(m_nAxisNo, nHomeStep, @accelerations);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_home_acceleration';
		Exit(nErrCode);
	end;
    Sleep(50);
	//-------------------------- 원점검색을 시작한다. 시작하기 전에 원점검색에 필요한 설정이 필요
	// 	- 원점검색 (라이브러리상에서 Thread를 사용하여 검색. 주의: 구동후 칩내의 StartStop Speed가 변할 수 있다)
	bRet := CFS20home_search(m_nAxisNo{axis});
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20home_search';
		Exit(nErrCode);
	end;
  sleep(50);
  while (CFS20in_motion(m_nAxisNo)) do begin
    Sleep(10);  //sleep은 짧게
  end;
  sleep(400);
  CFS20set_actual_position(m_nAxisNo, 0{position});
  CFS20set_command_position(m_nAxisNo, 0{position}); //2018-12-10
{$ELSE}
  sleep(100);
{$ENDIF}
  //CodeSite.Send('<MOTIONAXT> '+IntToStr(m_nMotionID)+':MoveHOME ...end');
	Result := DefPocb.ERR_OK;
end;

//******************************************************************************
// procedure/function: TMotorAxt: Set
//		- function TMotorAxt.SetActPos(dActPos: Double): Integer;
//		- function TMotorAxt.SetCmdPos(dCmdPos: Double): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionAxt.SetActPos(dActPos: Double): Integer;
var
	dReadPos    : Double;
begin
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- 현재의 상태에서 외부 위치를 특정 값으로 설정(position = Unit)
	CFS20set_actual_position(m_nAxisNo, dActPos{position});
	//-------------------------- 현재 외부 위치를 조회하여 확인
  dReadPos := CFS20get_actual_position(m_nAxisNo);
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
function TMotionAxt.SetCmdPos(dCmdPos: Double): Integer;
var
	dReadPos   : Double;
begin
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- 현재의 상태에서 내부 위치를 특정 값으로 설정(position = Unit)
	CFS20set_command_position(m_nAxisNo, dCmdPos{position});
  //CodeSite.Send('SetCmdPos:'+FloatToStr(dCmdPos));
	//-------------------------- 현재 내부 위치를 조회하여 확인
  dReadPos := CFS20get_command_position(m_nAxisNo);
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
// procedure/function: TMotorAxt: Get Motor
//		- function TMotorAxt.GetActPos(var dCmdPos: Double): Integer;
//		- function TMotorAxt.GetCmdPos(var dCmdPos: Double): Integer;
//		- function TMotorAxt.IsMotorHome: Boolean;
//		- function TMotorAxt.IsMotorMoving: Boolean;
//    - function TMotorAxt.Get
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionAxt.GetActPos(var dActPos: Double): Integer;
begin
	m_sErrLibApi 	:= '';
//nErrCode 			:= DefPocb.ERR_MOTION_GET_ACT_POS;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
	//-------------------------- 현재의 상태에서 외부 위치를 특정 값으로 확인(position = Unit)
  dActPos := CFS20get_actual_position(m_nAxisNo);
	Result  := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxt.GetCmdPos(var dCmdPos: Double): Integer;
begin
	m_sErrLibApi 	:= '';
//nErrCode 			:= DefPocb.ERR_MOTION_GET_CMD_POS;
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
	//-------------------------- 현재의 상태에서 내부 위치를 특정 값으로 확인(position = Unit)
  dCmdPos := CFS20get_command_position(m_nAxisNo);
	Result  := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxt.IsMotionHome: Boolean;
begin
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(False);  //TBD? ERR_MOTION_NOT_CONNECTED?
  end;
	//TBD? (사전확인 필요사항? b_Connected?)
	//-------------------------- 원점검색 진행 중인지를 확인
	// 	- 반환값: 0: 원점검색 진행중, 1: 원점검색 종료
	Result := CFS20get_home_done(m_nAxisNo);
end;

//------------------------------------------------------------------------------
function TMotionAxt.IsMotionMoving: Boolean;
begin
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(False);  //TBD? ERR_MOTION_NOT_CONNECTED?
  end;
	//TBD? (사전확인 필요사항? b_Connected?)
	//-------------------------- 지정 축의 펄스 출력중인지를 확인
	Result := CFS20in_motion(m_nAxisNo);
end;

//------------------------------------------------------------------------------
function TMotionAxt.IsMotionAlarmOn: Boolean;
var
  MechSignal : WORD;
begin
  //-------------------------- Motor 제어 연결 상태 확인
  //if (not m_bConnected) then begin
  //	Exit(True);  //TBD? ERR_MOTION_NOT_CONNECTED?
  //end;
{$IFNDEF SIMULATOR_MOTION}
  //------------------------------------------------------------------------------
  MechSignal := CFS20get_mechanical_signal(m_nAxisNo);
  if (MechSignal and (1 shl 4)) <> 0 then begin
    Exit(True);  //TBD? ERR_MOTION_ALARM_ON
  end;
{$ENDIF}
  Result := False;
end;

//------------------------------------------------------------------------------
function TMotionAxt.GetMotionStatus(var MotionStatus: MotionStatusRec): Boolean;
{$IFDEF SIMULATOR_MOTION}
var
  MotionParam : RMotionParam;
{$ENDIF}
begin
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(False);
  end;
{$IFDEF SIMULATOR_MOTION}
  Common.GetMotionParam(m_nMotionID,MotionParam);
{$ENDIF}

  //----- 구동 설정 초기화
  // Unit/Pulse 설정
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.UnitPerPulse := CFS20get_moveunit_perpulse(m_nAxisNo);
                              //    Unit/Pulse : 1 pulse에 대한 system의 이동거리 (Unit의 기준은 사용자가 임의로 생각)
                              // Ex) Ball screw pitch : 10mm, 모터 1회전당 펄스수 : 10000
                              //      ==> Unit을 mm로 생각할 경우 : Unit/Pulse = 10/10000.
                              //      따라서 unitperpulse에 0.001을 입력하면 모든 제어단위가 mm로 설정됨.
                              // Ex) Linear motor의 분해능이 1 pulse당 2 uM.
                              //      ==> Unit을 mm로 생각할 경우 : Unit/Pulse = 0.002/1
{$ELSE}
  MotionStatus.UnitPerPulse := MotionParam.dUnitPerPulse;  //TBD:SIM:MOTION?
{$ENDIF}
  // 시작 속도 설정 (Unit/Sec)
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.StartStopSpeed := CFS20get_startstop_speed(m_nAxisNo);
{$ELSE}
  MotionStatus.StartStopSpeed := MotionParam.dStartStopSpeed;  //TBD:SIM:MOTION?
{$ENDIF}
  // 최고 속도 설정 (Unit/Sec, 제어 system의 최고 속도)
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.MaxSpeed := CFS20get_max_speed(m_nAxisNo);
{$ELSE}
  MotionStatus.MaxSpeed := MotionParam.dStartStopSpeedMax;  //TBD:SIM:MOTION?
{$ENDIF}
  //----- 구동 상태 확인
  // 지정 축의 펄스 출력중인지
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.IsInMotion := CFS20in_motion(m_nAxisNo);
{$ELSE}
  MotionStatus.IsInMotion := False;  //TBD:SIM:MOTION?
{$ENDIF}
  // 지정 축의 펄스 출력이 종료됐는지
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.IsMotionDone := CFS20motion_done(m_nAxisNo);
{$ELSE}
  MotionStatus.IsMotionDone := True;  //TBD:SIM:MOTION?
{$ENDIF}
  // 지정 축의 EndStatus 레지스터를 확인
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.EndStatus    := CFS20get_end_status(m_nAxisNo); // Word
                              //  - End Status (16 bit) Bit별 의미
                              //      14bit : Limit(PELM, NELM, PSLM, NSLM, Soft)에 의한 종료
                              //      13bit : Limit 완전 정지에 의한 종료
                              //      12bit : Sensor positioning drive종료
                              //      11bit : Preset pulse drive에 의한 종료(지정한 위치/거리만큼 움직이는 함수군)
                              //      10bit : 신호 검출에 의한 종료(Signal Search-1/2 drive종료)
                              //      9 bit : 원점 검출에 의한 종료
                              //      8 bit : 탈조 에러에 의한 종료
                              //      7 bit : 데이타 설정 에러에 의한 종료
                              //      6 bit : ALARM 신호 입력에 의한 종료
                              //      5 bit : 급정지 명령에 의한 종료
                              //      4 bit : 감속정지 명령에 의한 종료
                              //      3 bit : 급정지 신호 입력에 의한 종료 (EMG Button)
                              //      2 bit : 감속정지 신호 입력에 의한 종료
                              //      1 bit : Limit(PELM, NELM, Soft) 급정지에 의한 종료
                              //      0 bit : Limit(PSLM, NSLM, Soft) 감속정지에 의한 종료
{$ELSE}
  MotionStatus.EndStatus := $00;  //TBD:SIM:MOTION?
{$ENDIF}
  // 지정 축의 Mechanical 레지스터
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.MechSignal   := CFS20get_mechanical_signal(m_nAxisNo);
                              //  - Mechanical Signal Bit별 의미
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
{$ELSE}
  MotionStatus.MechSignal := (1 shl 5);   //TBD:SIM:MOTION?
{$ENDIF}
  //----- 위치 확인
  // 외부 위치 값 (position: Unit)
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.ActualPos  := CFS20get_actual_position(m_nAxisNo);
{$ELSE}
  MotionStatus.ActualPos := $00;   //TBD:SIM:MOTION?
{$ENDIF}
  // 내부 위치 값 (position: Unit)
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.CommandPos := CFS20get_command_position(m_nAxisNo);
{$ELSE}
  case m_nMotionID of
  {$IFDEF HAS_MOTION_CAM_Z}
    DefMotion.MOTIONID_AxMC_STAGE1_Z: MotionStatus.CommandPos := MotionParam.dConfigZModelPos;
    DefMotion.MOTIONID_AxMC_STAGE2_Z: MotionStatus.CommandPos := MotionParam.dConfigZModelPos;
  {$ENDIF}
    DefMotion.MOTIONID_AxMC_STAGE1_Y: MotionStatus.CommandPos := MotionParam.dConfigYLoadPos;
    DefMotion.MOTIONID_AxMC_STAGE2_Y: MotionStatus.CommandPos := MotionParam.dConfigYCamPos;
  {$IFDEF HAS_MOTION_TILTING}
    DefMotion.MOTIONID_AxMC_STAGE1_T: MotionStatus.CommandPos := MotionParam.dConfigTFlatPos;
    DefMotion.MOTIONID_AxMC_STAGE2_T: MotionStatus.CommandPos := MotionParam.dConfigTUpPos;
  {$ENDIF}
  end;
{$ENDIF}
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.ActCmdPosDiff := CFS20get_error(m_nAxisNo);
{$ELSE}
  MotionStatus.ActCmdPosDiff := 0.0;
{$ENDIF}
  //----- 서보 드라이버
  // 서보 Enable(On) / Disable(Off)
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.ServoEnable := CFS20get_servo_enable(m_nAxisNo);
{$ELSE}
  MotionStatus.ServoEnable := 1; //TBD:SIM:MOTION?
{$ENDIF}
  // 서보 위치결정완료(inposition)입력 신호의 사용유무
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.UseInPosSig := CFS20get_inposition_enable (m_nAxisNo);
{$ELSE}
  MotionStatus.UseInPosSig := 0;  //TBD:SIM:MOTION?
{$ENDIF}
  // 서보 알람 입력신호 기능의 사용유무
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.UseAlarmSig := CFS20get_alarm_enable(m_nAxisNo);
{$ELSE}
  MotionStatus.UseAlarmSig := 0; //TBD:SIM:MOTION?
{$ENDIF}
  //----- 범용 입출력
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.UnivInSignal  := CFS20get_input (m_nAxisNo);
                              //      0 bit : 범용 입력 0(ORiginal Sensor)
                              //      1 bit : 범용 입력 1(Z phase)
                              //      2 bit : 범용 입력 2
                              //      3 bit : 범용 입력 3
                              //      4 bit(PLD) : 범용 입력 5
                              //      5 bit(PLD) : 범용 입력 6
                              //        On ==> 단자대 N24V, 'Off' ==> 단자대 Open(float).
{$ELSE}
  MotionStatus.UnivInSignal := {(1 shl 0) or} (1 shl 1) or (1 shl 2);      //TBD:SIM:MOTION?
{$ENDIF}
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.UnivOutSignal := CFS20get_output(m_nAxisNo);  // Byte
                              //      0 bit : 범용 출력 0(Servo-On)
                              //      1 bit : 범용 출력 1(ALARM Clear)
                              //      2 bit : 범용 출력 2
                              //      3 bit : 범용 출력 3
                              //      4 bit(PLD) : 범용 출력 4
                              //      5 bit(PLD) : 범용 출력 5
{$ELSE}
  MotionStatus.UnivOutSignal := (1 shl 0);      //TBD:SIM:MOTION?;
{$ENDIF}
  //--------------------------
  Result := True;
end;

end.

