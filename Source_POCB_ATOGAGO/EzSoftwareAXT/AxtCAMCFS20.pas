unit AxtCAMCFS20;

interface

uses Windows, Messages, AxtLIBDef, CAMCFSDef;

{------------------------------------------------------------------------------------------------*
	AXTCAMCFS Library - CAMC-FS 2.0이상 Motion module
	적용제품
		SMC-1V02 - CAMC-FS Ver2.0 이상 1축
		SMC-2V02 - CAMC-FS Ver2.0 이상 2축
 *------------------------------------------------------------------------------------------------}

// 보드 초기화 함수군        -======================================================================================
// CAMC-FS가 장착된 모듈(SMC-1V02, SMC-2V02)을 검색하여 초기화한다. CAMC-FS 2.0이상만 검출한다
function InitializeCAMCFS20 (reset : Boolean) : Boolean; stdcall;
// reset	: 1(TRUE) = 레지스터(카운터 등)를 초기화한다
//  reset(TRUE)일때 초기 설정값.
//  1) 인터럽트 사용하지 않음.
//  2) 인포지션 기능 사용하지 않음.
//  3) 알람정지 기능 사용하지 않음.
//  4) 급정지 리미트 기능 사용 함.
//  5) 감속정지 리미트 기능 사용 함.            
//  6) 펄스 출력 모드 : OneLowHighLow(Pulse : Active LOW, Direction : CW{High};CCW{LOW}).
//  7) 검색 신호 : +급정지 리미트 신호 하강 에지.
//  8) 입력 인코더 설정 : 2상, 4 체배.
//  9) 알람, 인포지션, +-감속 정지 리미트, +-급정지 리미트 Active level : HIGH
// 10) 내부/외부 카운터 : 0.		
// CAMC-FS20 모듈의 사용이 가능한지를 확인한다
function CFS20IsInitialized () : Boolean; stdcall;
// 리턴값 :  1(TRUE) = CAMC-FS20 모듈을 사용 가능하다
// CAMC-FS20이 장착된 모듈의 사용을 종료한다
procedure CFS20StopService (); stdcall;

/// 보드 정보 관련 함수군        -===================================================================================
// 지정한 주소에 장착된 베이스보드의 번호를 리턴한다. 없으면 -1을 리턴한다
function CFS20get_boardno (address : DWord) : SmallInt; stdcall;
// 베이스보드의 갯수를 리턴한다
function CFS20get_numof_boards () : SmallInt; stdcall;
// 지정한 베이스보드에 장착된 축의 갯수를 리턴한다
function CFS20get_numof_axes (nBoardNo : SmallInt) : SmallInt; stdcall;
// 축의 갯수를 리턴한다
function CFS20get_total_numof_axis () : SmallInt; stdcall;
// 지정한 베이스보드번호와 모듈번호에 해당하는 축번호를 리턴한다
function CFS20get_axisno (nBoardNo : SmallInt; nModuleNo : SmallInt) : SmallInt; stdcall;
// 지정한 축의 정보를 리턴한다
// nBoardNo : 해당 축이 장착된 베이스보드의 번호.
// nModuleNo: 해당 축이 장착된 모듈의 베이스 모드내 모듈 위치(0~3)
// bModuleID: 해당 축이 장착된 모듈의 ID : SMC-2V02(0x02)
// nAxisPos : 해당 축이 장착된 모듈의 첫번째인지 두번째 축인지 정보.(0 : 첫번째, 1 : 두번째)
function CFS20get_axis_info (nAxisNo : SmallInt; nBoardNo : PSmallInt; nModuleNo : PSmallInt; bModuleID : PByte; nAxisPos : PSmallInt) : Boolean; stdcall;

// 파일 관련 함수군        -========================================================================================
// 지정 축의 초기값을 지정한 파일에서 읽어서 설정한다
// Loading parameters.
//	1) 1Pulse당 이동거리(Move Unit / Pulse)
//	2) 최대 이동 속도, 시작/정지 속도
//	3) 엔코더 입력방식, 펄스 출력방식 
//	4) +급정지 리미트레벨, -급정지 리미트레벨, 급정지 리미트 사용유무
//  5) +감속정지 리미트레벨,-감속정지 리미트레벨, 감속정지 리미트 사용유무
//  6) 알람레벨, 알람 사용유무
//  7) 인포지션(위치결정완료 신호)레벨, 인포지션 사용유무
//  8) 비상정지 사용유무
//  9) 엔코더 입력방식2 설정값
// 10) 내부/외부 카운터 : 0. 	
function CFS20load_parameter (axis : SmallInt; nfilename : PChar) : Boolean; stdcall;
// 지정 축의 초기값을 지정한 파일에 저장한다.
// Saving parameters.
//	1) 1Pulse당 이동거리(Move Unit / Pulse)
//	2) 최대 이동 속도, 시작/정지 속도
//	3) 엔코더 입력방식, 펄스 출력방식 
//	4) +급정지 리미트레벨, -급정지 리미트레벨, 급정지 리미트 사용유무
//  5) +감속정지 리미트레벨,-감속정지 리미트레벨, 감속정지 리미트 사용유무
//  6) 알람레벨, 알람 사용유무
//  7) 인포지션(위치결정완료 신호)레벨, 인포지션 사용유무
//  8) 비상정지 사용유무
//  9) 엔코더 입력방식2 설정값
function CFS20save_parameter (axis : SmallInt; nfilename : PChar) : Boolean; stdcall;
// 모든 축의 초기값을 지정한 파일에서 읽어서 설정한다
function CFS20load_parameter_all (nfilename : PChar) : Boolean; stdcall;
// 모든 축의 초기값을 지정한 파일에 저장한다
function CFS20save_parameter_all (nfilename : PChar) : Boolean; stdcall;	

// 인터럽트 함수군   -================================================================================================
//(인터럽트를 사용하기 위해서는 
//Window message & procedure
//    hWnd    : 윈도우 핸들, 윈도우 메세지를 받을때 사용. 사용하지 않으면 NULL을 입력.
//    wMsg    : 윈도우 핸들의 메세지, 사용하지 않거나 디폴트값을 사용하려면 0을 입력.
//    proc    : 인터럽트 발생시 호출될 함수의 포인터, 사용하지 않으면 NULL을 입력.
procedure CFS20SetWindowMessage (hWnd : HWND; wMsg : Word; proc : AXT_CAMCFS_INTERRUPT_PROC); stdcall;
//-===============================================================================
// ReadInterruptFlag에서 설정된 내부 flag변수를 읽어 보는 함수(인터럽트 service routine에서 인터럽터 발생 요인을 판별한다.)
// 리턴값: 인터럽트가 발생 하였을때 발생하는 인터럽트 flag register(CAMC-FS20 의 INTFLAG 참조.)
function CFS20read_interrupt_flag (axis : SmallInt) : DWord; stdcall;

// 구동 설정 초기화 함수군        -==================================================================================
// 메인클럭 설정( 모듈에 장착된 Oscillator가 변경될 경우에만 설정)
procedure CFS20KeSetMainClk (nMainClk : LongInt); stdcall;
// Drive mode 1의 설정/확인한다.
procedure CFS20set_drive_mode1 (axis : SmallInt; decelstartpoint : Byte; pulseoutmethod : Byte; detectsignal : Byte); stdcall;
function CFS20get_drive_mode1 (axis : SmallInt) : Byte; stdcall;
// decelstartpoint : 지정거리 구동 기능 사용중 감속 위치 지정 방식 설정(0 : 자동 가감속, 1 : 수동 가감속)
// pulseoutmethod : 출력 펄스 방식 설정(typedef : PULSE_OUTPUT)
// detecsignal : 신호 검색-1/2 구동 기능 사용중 검색 할 신호 설정(typedef : DETECT_DESTINATION_SIGNAL)
// Drive mode 2의 설정/확인한다.
procedure CFS20set_drive_mode2 (axis : SmallInt; encmethod : Byte; inpactivelevel : Byte; alarmactivelevel : Byte; nslmactivelevel : Byte; pslmactivelevel : Byte; nelmactivelevel : Byte; pelmactivelevel : Byte); stdcall;
function CFS20get_drive_mode2 (axis : SmallInt) : Word; stdcall;
// Unit/Pulse 설정/확인한다.
procedure CFS20set_moveunit_perpulse (axis : SmallInt; unitperpulse : Double); stdcall;
function CFS20get_moveunit_perpulse (axis : SmallInt) : Double; stdcall;
// Unit/Pulse : 1 pulse에 대한 system의 이동거리를 말하며, 이때 Unit의 기준은 사용자가 임의로 생각할 수 있다.
// Ex) Ball screw pitch : 10mm, 모터 1회전당 펄스수 : 10000 ==> Unit을 mm로 생각할 경우 : Unit/Pulse = 10/10000.
// 따라서 unitperpulse에 0.001을 입력하면 모든 제어단위가 mm로 설정됨. 
// Ex) Linear motor의 분해능이 1 pulse당 2 uM. ==> Unit을 mm로 생각할 경우 : Unit/Pulse = 0.002/1.
// Unit/Pulse와 역수관계
// pulse/Unit 설정/확인한다.
procedure CFS20set_movepulse_perunit (axis : SmallInt; pulseperunit : Double); stdcall;
function CFS20get_movepulse_perunit (axis : SmallInt) : Double; stdcall;
// 시작 속도 설정/확인한다.(Unit/Sec)
procedure CFS20set_startstop_speed (axis : SmallInt; velocity : Double); stdcall;
function CFS20get_startstop_speed (axis : SmallInt) : Double; stdcall;
// 최고 속도 설정 Unit/Sec. 제어 system의 최고 속도를 설정한다.
function CFS20set_max_speed (axis : SmallInt; max_velocity : Double) : Boolean; stdcall;
function CFS20get_max_speed (axis : SmallInt) : Double; stdcall;
// Unit/Pulse 설정과 시작속도 설정 이후에 설정한다.
// 설정된 최고 속도 이상으로는 구동을 할수 없으므로 주의한다.
// SW에 관계된 값을 설정/확인한다. 이값으로 S-Curve 구간을 percentage로 설정 가능하다.
procedure CFS20set_s_rate (axis : SmallInt; a_percent : Double; b_percent : Double); stdcall;
procedure CFS20get_s_rate (axis : SmallInt; a_percent : PDouble; b_percent : PDouble); stdcall;
// 수동 가감속 모드에서 잔량 펄스를 설정/확인한다.
procedure CFS20set_slowdown_rear_pulse (axis : SmallInt; ulData : DWord); stdcall;
function CFS20get_slowdown_rear_pulse (axis : SmallInt) : DWord; stdcall;
// 지정 축의 감속 시작 포인터 검출 방식을 설정/확인한다.
function CFS20set_decel_point (axis : SmallInt; method : Byte) : Boolean; stdcall;
function CFS20get_decel_point (axis : SmallInt) : Byte; stdcall;
// 0x0 : 자동 가감속.
// 0x1 : 수동 가감속.

// 구동 상태 확인 함수군        -=====================================================================================
// 지정 축의 펄스 출력중인지를 확인한다.
function CFS20in_motion (axis : SmallInt) : Boolean; stdcall;
// 지정 축의 펄스 출력이 종료됐는지 확인한다.
function CFS20motion_done (axis : SmallInt) : Boolean; stdcall;
// 지정 축의 구동시작 이후 출력된 펄스 카운터 값을 확인한다. (Pulse)
function CFS20get_drive_pulse_counts (axis : SmallInt) : LongInt; stdcall;
// 지정 축의 DriveStatus 레지스터를 확인한다.
function CFS20get_drive_status (axis : SmallInt) : Word; stdcall;
// 지정 축의 EndStatus 레지스터를 확인한다.
function CFS20get_end_status (axis : SmallInt) : Word; stdcall;
// End Status Bit별 의미
// 14bit : Limit(PELM, NELM, PSLM, NSLM, Soft)에 의한 종료
// 13bit : Limit 완전 정지에 의한 종료
// 12bit : Sensor positioning drive종료
// 11bit : Preset pulse drive에 의한 종료(지정한 위치/거리만큼 움직이는 함수군)
// 10bit : 신호 검출에 의한 종료(Signal Search-1/2 drive종료)
// 9 bit : 원점 검출에 의한 종료
// 8 bit : 탈조 에러에 의한 종료
// 7 bit : 데이타 설정 에러에 의한 종료
// 6 bit : ALARM 신호 입력에 의한 종료
// 5 bit : 급정지 명령에 의한 종료
// 4 bit : 감속정지 명령에 의한 종료
// 3 bit : 급정지 신호 입력에 의한 종료 (EMG Button)
// 2 bit : 감속정지 신호 입력에 의한 종료
// 1 bit : Limit(PELM, NELM, Soft) 급정지에 의한 종료
// 0 bit : Limit(PSLM, NSLM, Soft) 감속정지에 의한 종료
// 지정 축의 Mechanical 레지스터를 확인한다.
function CFS20get_mechanical_signal (axis : SmallInt) : Word; stdcall;
// Mechanical Signal Bit별 의미
// 12bit : ESTOP 신호 입력 Level
// 11bit : SSTOP 신호 입력 Level
// 10bit : MARK 신호 입력 Level
// 9 bit : EXPP(MPG) 신호 입력 Level
// 8 bit : EXMP(MPG) 신호 입력 Level
// 7 bit : Encoder Up신호 입력 Level(A상 신호)
// 6 bit : Encoder Down신호 입력 Level(B상 신호)
// 5 bit : INPOSITION 신호 Active 상태
// 4 bit : ALARM 신호 Active 상태
// 3 bit : -Limit 감속정지 신호 Active 상태 (Ver3.0부터 사용되지않음)
// 2 bit : +Limit 감속정지 신호 Active 상태 (Ver3.0부터 사용되지않음)
// 1 bit : -Limit 급정지 신호 Active 상태
// 0 bit : +Limit 급정지 신호 Active 상태
// 지정 축의  현재 속도를 읽어 온다.(Unit/Sec)
function CFS20get_velocity (axis : SmallInt) : Double; stdcall;
// 지정 축의 Command position과 Actual position의 차를 확인한다.
function CFS20get_error (axis : SmallInt) : Double; stdcall;
// 지정 축의 최후 드라이브의 이동 거리를 확인 한다. (Unit)
function CFS20get_drivedistance (axis : SmallInt) : Double; stdcall;

// Encoder 입력 방식 설정 함수군        -=============================================================================
// 지정 축의 Encoder 입력 방식을 설정/확인한다.
function CFS20set_enc_input_method (axis : SmallInt; method : Byte) : Boolean; stdcall;
function CFS20get_enc_input_method (axis : SmallInt) : Byte; stdcall;
// method : typedef(EXTERNAL_COUNTER_INPUT)
// UpDownMode = 0x0    // Up/Down
// Sqr1Mode   = 0x1    // 1체배
// Sqr2Mode   = 0x2    // 2체배
// Sqr4Mode   = 0x3    // 4체배
// 지정 축의 외부 위치 counter clear의 기능을 설정/확인한다.
function CFS20set_enc2_input_method (axis : SmallInt; method : Byte) : Boolean; stdcall;
function CFS20get_enc2_input_method (axis : SmallInt) : Byte; stdcall;
// method : CAMC-FS chip 메뉴얼 EXTCNTCLR 레지스터 참조.
// 지정 축의 외부 위치 counter의 count 방식을 설정/확인한다.
function CFS20set_enc_reverse (axis : SmallInt; reverse : Byte) : Boolean; stdcall;
function CFS20get_enc_reverse (axis : SmallInt) : Boolean; stdcall;
// reverse :
// TRUE  : 입력 인코더에 반대되는 방향으로 count한다.
// FALSE : 입력 인코더에 따라 정상적으로 count한다.

// 펄스 출력 방식 함수군        -=====================================================================================
// 펄스 출력 방식을 설정/확인한다.
function CFS20set_pulse_out_method (axis : SmallInt; method : Byte) : Boolean; stdcall;
function CFS20get_pulse_out_method (axis : SmallInt) : Byte; stdcall;
// method : 출력 펄스 방식 설정(typedef : PULSE_OUTPUT)
// OneHighLowHigh   = 0x0, 1펄스 방식, PULSE(Active High), 정방향(DIR=Low)  / 역방향(DIR=High)
// OneHighHighLow   = 0x1, 1펄스 방식, PULSE(Active High), 정방향(DIR=High) / 역방향(DIR=Low)
// OneLowLowHigh    = 0x2, 1펄스 방식, PULSE(Active Low),  정방향(DIR=Low)  / 역방향(DIR=High)
// OneLowHighLow    = 0x3, 1펄스 방식, PULSE(Active Low),  정방향(DIR=High) / 역방향(DIR=Low)
// TwoCcwCwHigh     = 0x4, 2펄스 방식, PULSE(CCW:역방향),  DIR(CW:정방향),  Active High 
// TwoCcwCwLow      = 0x5, 2펄스 방식, PULSE(CCW:역방향),  DIR(CW:정방향),  Active Low 
// TwoCwCcwHigh     = 0x6, 2펄스 방식, PULSE(CW:정방향),   DIR(CCW:역방향), Active High
// TwoCwCcwLow      = 0x7, 2펄스 방식, PULSE(CW:정방향),   DIR(CCW:역방향), Active Low

//위치 확인 및 위치 비교 설정 함수군 -===============================================================================
// 외부 위치 값을 설정한다. 현재의 상태에서 외부 위치를 특정 값으로 설정/확인한다.(position = Unit)
procedure CFS20set_actual_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_actual_position (axis : SmallInt) : Double; stdcall;
// 내부 위치 값을 설정한다. 현재의 상태에서 내부 위치를 특정 값으로 설정/확인한다.(position = Unit)
procedure CFS20set_command_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_command_position (axis : SmallInt) : Double; stdcall;

// 서보 드라이버 출력 신호 설정 함수군-===============================================================================
// 서보 Enable출력 신호의 Active Level을 설정/확인한다.
function CFS20set_servo_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_servo_level (axis : SmallInt) : Byte; stdcall;
// 서보 Enable(On) / Disable(Off)을 설정/확인한다.
function CFS20set_servo_enable (axis : SmallInt; state : Byte) : Boolean; stdcall;
function CFS20get_servo_enable (axis : SmallInt) : Byte; stdcall;	

// 서보 드라이버 입력 신호 설정 함수군-===============================================================================
// 서보 위치결정완료(inposition)입력 신호의 사용유무를 설정/확인한다.
function CFS20set_inposition_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_inposition_enable (axis : SmallInt) : Byte; stdcall;
// 서보 위치결정완료(inposition)입력 신호의 Active Level을 설정/확인/상태확인한다.
function CFS20set_inposition_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_inposition_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_inposition_switch (axis : SmallInt) : Byte; stdcall;
function CFS20in_position (axis : SmallInt) : Boolean; stdcall;
// 서보 알람 입력신호 기능의 사용유무를 설정/확인한다.
function CFS20set_alarm_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_alarm_enable (axis : SmallInt) : Byte; stdcall;
// 서보 알람 입력 신호의 Active Level을 설정/확인/상태확인한다.
function CFS20set_alarm_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_alarm_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_alarm_switch (axis : SmallInt) : Byte; stdcall;

// 리미트 신호 설정 함수군-===========================================================================================
// 급정지 리미트 기능 사용유무를 설정/확인한다.
function CFS20set_end_limit_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_end_limit_enable (axis : SmallInt) : Byte; stdcall;
// -급정지 리미트 입력 신호의 Active Level을 설정/확인/상태확인한다.
function CFS20set_nend_limit_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_nend_limit_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_nend_limit_switch (axis : SmallInt) : Byte; stdcall;
// +급정지 리미트 입력 신호의 Active Level을 설정/확인/상태확인한다.
function CFS20set_pend_limit_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_pend_limit_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_pend_limit_switch (axis : SmallInt) : Byte; stdcall;
// 감속정지 리미트 기능 사용유무를 설정/확인한다.
function CFS20set_slow_limit_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_slow_limit_enable (axis : SmallInt) : Byte; stdcall;
// -감속정지 리미트 입력 신호의 Active Level을 설정/확인/상태확인한다.
function CFS20set_nslow_limit_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_nslow_limit_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_nslow_limit_switch (axis : SmallInt) : Byte; stdcall;
// +감속정지 리미트 입력 신호의 Active Level을 설정/확인/상태확인한다.
function CFS20set_pslow_limit_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_pslow_limit_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_pslow_limit_switch (axis : SmallInt) : Byte; stdcall;
// -LIMIT 센서 감지시 급/감속정지 여부를 설정/확인한다. (Ver 3.0부터 적용)
function CFS20set_nlimit_sel (axis : SmallInt; stop : Byte) : Boolean; stdcall;
function CFS20get_nlimit_sel (axis : SmallInt) : Byte; stdcall;
// stop:
// 0 : 급정지, 1 : 감속정지
// +LIMIT 센서 감지시 급/감속정지 여부를 설정/확인한다. (Ver 3.0부터 적용)	
function CFS20set_plimit_sel (axis : SmallInt; stop : Byte) : Boolean; stdcall;
function CFS20get_plimit_sel (axis : SmallInt) : Byte; stdcall;
// stop:
// 0 : 급정지, 1 : 감속정지

// 소프트웨어 리미트 설정 함수군-=====================================================================================
// 소프트웨어 리미트 사용유무를 설정/확인한다.
procedure CFS20set_soft_limit_enable (axis : SmallInt; use : Byte); stdcall;
function CFS20get_soft_limit_enable (axis : SmallInt) : Byte; stdcall;
// 소프트웨어 리미트 사용시 기준위치정보를 설정/확인한다.
procedure CFS20set_soft_limit_sel (axis : SmallInt; sel : Byte); stdcall;
function CFS20get_soft_limit_sel (axis : SmallInt) : Byte; stdcall;
// sel :
// 0x0 : 내부위치에 대하여 소프트웨어 리미트 기능 실행.
// 0x1 : 외부위치에 대하여 소프트웨어 리미트 기능 실행.
// 소프트웨어 리미트 발생시 정지 모드를 설정/확인한다.
procedure CFS20set_soft_limit_stopmode (axis : SmallInt; mode : Byte); stdcall;
function CFS20get_soft_limit_stopmode (axis : SmallInt) : Byte; stdcall;
// mode :
// 0x0 : 소프트웨어 리미트 위치에서 급정지 한다.
// 0x1 : 소프트웨어 리미트 위치에서 감속정지 한다.
// 소프트웨어 리미트 -위치값 설정/확인한다.(position = Unit)
procedure CFS20set_soft_nlimit_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_soft_nlimit_position (axis : SmallInt) : Double; stdcall;
// 소프트웨어 리미트 +위치값 설정/확인 한다.(position = Unit)
procedure CFS20set_soft_plimit_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_soft_plimit_position (axis : SmallInt) : Double; stdcall;

// 비상정지 신호-=====================================================================================================
// ESTOP, SSTOP 신호 사용유무를 설정/확인한다.(Emergency stop, Slow-Down stop)
function CFS20set_emg_signal_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_emg_signal_enable (axis : SmallInt) : Byte; stdcall;
// 비상정지의 급/감속정지 여부를 설정/확인한다.
function CFS20set_stop_sel (axis : SmallInt; stop : Byte) : Boolean; stdcall;
function CFS20get_stop_sel (axis : SmallInt) : Byte; stdcall;
// stop:
// 0 : 급정지, 1 : 감속정지

// 단축 지정 거리 구동-===============================================================================================
// start_** : 지정 축에서 구동 시작후 함수를 return한다. "start_*" 가 없으면 이동 완료후 return한다(Blocking).
// *r*_*    : 지정 축에서 입력된 거리만큼(상대좌표)로 이동한다. "*r_*이 없으면 입력된 위치(절대좌표)로 이동한다.
// *s*_*    : 구동중 속도 프로파일을 "S curve"를 이용한다. "*s_*"가 없다면 사다리꼴 가감속을 이용한다.
// *a*_*    : 구동중 속도 가감속도를 비대칭으로 사용한다. 가속률 또는 가속 시간과  감속률 또는 감속 시간을 각각 입력받는다.
// *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. "*_ex"가 없다면 가감속률로 입력 받는다.
// 입력 값들: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)

// 대칭 지정펄스(Pulse Drive), 사다리꼴 구동 함수, 절대/상대좌표(r), 가속율/가속시간(_ex)(시간단위:Sec)
// Blocking함수 (제어권이 펄스 출력이 완료된 후 넘어옴)
function CFS20move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double) : Word; stdcall;
function CFS20move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double) : Word; stdcall;
function CFS20r_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double) : Word; stdcall;
function CFS20r_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double) : Word; stdcall;
// Non Blocking함수 (구동중일 경우 무시됨)
function CFS20start_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double) : Boolean; stdcall;
function CFS20start_r_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_r_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double) : Boolean; stdcall;
// 비대칭 지정펄스(Pulse Drive), 사다리꼴 구동 함수, 절대/상대좌표(r), 가속율/가속시간(_ex)(시간단위:Sec)
// Blocking함수 (제어권이 펄스 출력이 완료된 후 넘어옴)
function CFS20a_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double; deceleration : Double) : Word; stdcall;
function CFS20a_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double; deceltime : Double) : Word; stdcall;
function CFS20ra_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double) : Word; stdcall;
function CFS20ra_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double) : Word; stdcall;
// Non Blocking함수 (구동중일 경우 무시됨)
function CFS20start_a_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20start_a_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;
function CFS20start_ra_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20start_ra_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;
// 대칭 지정펄스(Pulse Drive), S자형 구동, 절대/상대좌표(r), 가속율/가속시간(_ex)(시간단위:Sec)
// Blocking함수 (제어권이 펄스 출력이 완료된 후 넘어옴)
function CFS20s_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double) : Word; stdcall;
function CFS20s_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double) : Word; stdcall;
function CFS20rs_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double) : Word; stdcall;
function CFS20rs_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double) : Word; stdcall;
// Non Blocking함수 (구동중일 경우 무시됨)
function CFS20start_s_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_s_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double) : Boolean; stdcall;
function CFS20start_rs_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_rs_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double) : Boolean; stdcall;
// 비대칭 지정펄스(Pulse Drive), S자형 구동, 절대/상대좌표(r), 가속율/가속시간(_ex)(시간단위:Sec)
// Blocking함수 (제어권이 펄스 출력이 완료된 후 넘어옴)
function CFS20as_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double; deceleration : Double) : Word; stdcall;
function CFS20as_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double; deceltime : Double) : Word; stdcall;
function CFS20ras_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double) : Word; stdcall;
function CFS20ras_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double) : Word; stdcall;
// Non Blocking함수 (구동중일 경우 무시됨), jerk사용(단위 : 퍼센트) 포물선가속 S자 이동사용시.
function CFS20start_as_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20start_as_move2 (axis : SmallInt; position : Double; velocity : Double; acceleration : Double; deceleration : Double; jerk : Double) : Boolean; stdcall;
function CFS20start_as_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;
function CFS20start_ras_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20start_ras_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;

// 대칭 지정 펄스(Pulse Drive), S자형 구동, 상대좌표, 가속율,
// Non Blocking (구동중일 경우 무시됨), 현재 위치를 기준으로 over_distance에서 over_velocity로 속도를 변경 한다.
function CFS20start_rs_move_override (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; over_distance : Double; over_velocity : Double; Target : Boolean) : Boolean; stdcall;

// 단축 연속 구동-====================================================================================================
// 지정 가감속도 및 속도로 정지 조건이 발생하지 않으면 지속적으로 구동한다.
// *s*_*    : 구동중 속도 프로파일을 "S curve"를 이용한다. "*s_*"가 없다면 사다리꼴 가감속을 이용한다.
// *a*_*    : 구동중 속도 가감속도를 비대칭으로 사용한다. 가속률 또는 가속 시간과  감속률 또는 감속 시간을 각각 입력받는다.
// *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. "*_ex"가 없다면 가감속률로 입력 받는다.

// 정속도 사다리꼴 구동 함수군, 가속율/가속시간(_ex)(시간단위:Sec) - 구동중일 경우에는 속도오버라이드
// 대칭 가감속 구동함수
function CFS20v_move (axis : SmallInt; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20v_move_ex (axis : SmallInt; velocity : Double; acceltime : Double) : Boolean; stdcall;
// 비대칭 가감속 구동함수
function CFS20v_a_move (axis : SmallInt; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20v_a_move_ex (axis : SmallInt; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;
// 정속도 S자형 구동 함수군, 가속율/가속시간(_ex)(시간단위:Sec) - 구동중일 경우에는 속도오버라이드
// 대칭 가감속 구동함수
function CFS20v_s_move (axis : SmallInt; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20v_s_move_ex (axis : SmallInt; velocity : Double; acceltime : Double) : Boolean; stdcall;
// 비대칭 가감속 구동함수
function CFS20v_as_move (axis : SmallInt; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20v_as_move_ex (axis : SmallInt; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;

// 신호 검출 구동-====================================================================================================
// 지정 신호의 상향/하향 에지를 검색하여 급정지 또는 감속정지를 할 수 있다.
// detect_signal : 검색 신호 설정(typedef : DETECT_DESTINATION_SIGNAL)
// PElmNegativeEdge    = 0x0,        // +Elm(End limit) 하강 edge
// NElmNegativeEdge    = 0x1,        // -Elm(End limit) 하강 edge
// PSlmNegativeEdge    = 0x2,        // +Slm(Slowdown limit) 하강 edge
// NSlmNegativeEdge    = 0x3,        // -Slm(Slowdown limit) 하강 edge
// In0DownEdge         = 0x4,        // IN0(ORG) 하강 edge
// In1DownEdge         = 0x5,        // IN1(Z상) 하강 edge
// In2DownEdge         = 0x6,        // IN2(범용) 하강 edge
// In3DownEdge         = 0x7,        // IN3(범용) 하강 edge
// PElmPositiveEdge    = 0x8,        // +Elm(End limit) 상승 edge
// NElmPositiveEdge    = 0x9,        // -Elm(End limit) 상승 edge
// PSlmPositiveEdge    = 0xa,        // +Slm(Slowdown limit) 상승 edge
// NSlmPositiveEdge    = 0xb,        // -Slm(Slowdown limit) 상승 edge
// In0UpEdge           = 0xc,        // IN0(ORG) 상승 edge
// In1UpEdge           = 0xd,        // IN1(Z상) 상승 edge
// In2UpEdge           = 0xe,        // IN2(범용) 상승 edge
// In3UpEdge           = 0xf         // IN3(범용) 상승 edge
// Signal Search1 : 구동 시작후 입력 속도까지 가속하여, 신호 검출후 감속 정지.
// Signal Search2 : 구동 시작후 가속없이 입력 속도가 되고, 신호 검출후 급정지. 
// 주의 : Signal Search2는 가감속이 없으므로 속도가 높을경우 탈조및 기구부의 무리가 갈수 있으므로 주의한다.
// *s*_*    : 구동중 속도 프로파일을 "S curve"를 이용한다. "*s_*"가 없다면 사다리꼴 가감속을 이용한다.
// *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. "*_ex"가 없다면 가감속률로 입력 받는다.

// 신호검출1(Signal search 1) 사다리꼴 구동, 가속율/가속시간(_ex)(시간단위:Sec)
function CFS20start_signal_search1 (axis : SmallInt; velocity : Double; acceleration : Double; detect_signal : Byte) : Boolean; stdcall;
function CFS20start_signal_search1_ex (axis : SmallInt; velocity : Double; acceltime : Double; detect_signal : Byte) : Boolean; stdcall;
// 신호검출1(Signal search 1) S자형 구동, 가속율/가속시간(_ex)(시간단위:Sec)
function CFS20start_s_signal_search1 (axis : SmallInt; velocity : Double; acceleration : Double; detect_signal : Byte) : Boolean; stdcall;
function CFS20start_s_signal_search1_ex (axis : SmallInt; velocity : Double; acceltime : Double; detect_signal : Byte) : Boolean; stdcall;
// 신호검출2(Signal search 2) 사다리꼴 구동, 가감속 없음
function CFS20start_signal_search2 (axis : SmallInt; velocity : Double; detect_signal : Byte) : Boolean; stdcall;

// MPG(Manual Pulse Generation) 구동 설정-===========================================================================
// 지정 축에 MPG(Manual Pulse Generation) 드라이버의 구동 모드를 설정/확인한다.
function CFS20set_mpg_drive_mode (axis : SmallInt; mode : Byte) : Boolean; stdcall;
function CFS20get_mpg_drive_mode (axis : SmallInt) : Byte; stdcall;
//0x1 : Slave 구동모드, 외부 Differential 신호에 의한 출력
//0x2 : 지정 펄스 구동, 외부 입력 신호에 의한 지정 펄스 구동 시작
//0x4 : 연속 구동 모드, 외부 접점 입력 신호의 특정 레벨 동안 구동
// 지정 축에 MPG(Manual Pulse Generation) 드라이버의 구동 방향 결정모드를 설정/확인한다.
function CFS20set_mpg_dir_mode (axis : SmallInt; mode : Byte) : Boolean; stdcall;
function CFS20get_mpg_dir_mode (axis : SmallInt) : Byte; stdcall;
// mode
// 0x0 : 외부 신호에 의한 방향 결정
// 0x1 : 사용자에 의해 지정된 방향으로 구동
// 지정 축에 MPG(Manual Pulse Generation) 드라이버의 구동 방향 결정모드가 사용자에 의해
// 지정된 방향으로 설정되었을 때 필요한 사용자의 구동 방향 지정 값을 설정/확인한다.
function CFS20set_mpg_user_dir (axis : SmallInt; mode : Byte) : Boolean; stdcall;
function CFS20get_mpg_user_dir (axis : SmallInt) : Byte; stdcall;
// mode
//0x0 : 사용자 지정 구동 방향을 +로 설정
//0x1 : 사용자 지정 구동 방향을 -로 설정
// 지정 축에 MPG(Manual Pulse Generation) 드라이버에 사용되는 EXPP/EXMP 의 입력 모드를 설정한다.
//  2 bit : '0' : level input(범용 입력 4 = EXPP, 범용 입력 5 = EXMP로 입력 받는다.)
//          '1' : Differential input(차동 입력으로 EXPP, EXMP를 입력 받음,)
//  1~0bit: "00" : 1 phase
//          "01" : 2 phase 1 times
//          "10" : 2 phase 2 times
//          "11" : 2 phase 4 times
function CFS20set_mpg_input_method (axis : SmallInt; method : Byte) : Boolean; stdcall;
function CFS20get_mpg_input_method (axis : SmallInt) : Byte; stdcall;
// MPG위치 값을 설정한다. 현재의 상태에서 MPG 위치를 특정 값으로 설정/확인한다.(position = Unit)
function CFS20set_mpg_position (axis : SmallInt; position : Double) : Boolean; stdcall;
function CFS20get_mpg_position (axis : SmallInt) : Double; stdcall;

// MPG(Manual Pulse Generation) 구동 -===============================================================================
// 설정된 속도로 사다리꼴 구동, 가속율/가속시간(_ex)(시간단위:Sec)
function CFS20start_mpg (axis : SmallInt; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_mpg_ex (axis : SmallInt; velocity : Double; acceltime : Double) : Boolean; stdcall;
// 설정된 속도로 S자형 구동, 가속율/가속시간(_ex)(시간단위:Sec)
function CFS20start_s_mpg (axis : SmallInt; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_s_mpg_ex (axis : SmallInt; velocity : Double; acceltime : Double) : Boolean; stdcall;

// 오버라이드(구동중)-================================================================================================
// 단축 지정 거리 구동시 구동 시작시점에서 입력한 위치(절대위치)를 구동중 바꾼다.
function CFS20position_override (axis : SmallInt; overrideposition : Double) : Boolean; stdcall;
// 단축 지정 거리 구동시 구동 시작시점에서 입력한 거리(상대위치)를 구동중 바꾼다.    
function CFS20position_r_override (axis : SmallInt; overridedistance : Double) : Boolean; stdcall;
// 구동중 구동 초기 설정한 속도를 바꾼다.(set_max_speed > velocity > set_startstop_speed)
function CFS20velocity_override (axis : SmallInt; velocity : Double) : Boolean; stdcall;
// 지정 축의 구동이 종료되기 전 입력된 overrideposition까지 최소 출력 펄스(dec_pulse) 이상일 경우 override 동작을 한다.
function CFS20position_override2 (axis : SmallInt; overrideposition : Double; dec_pulse : Double) : Boolean; stdcall;
// 지정 축에 가속/감속 프로 파일을 가지는 가감속으로 속도 override 동작을 한다.
function CFS20velocity_override2 (axis : SmallInt; velocity : Double; acceleration : Double; deceleration : Double; jerk : Double) : Boolean; stdcall; 

// 단축 구동 확인-====================================================================================================
// 지정 축의 구동이 종료될 때까지 기다린 후 함수를 벗어난다.
function CFS20wait_for_done (axis : SmallInt) : Word; stdcall;

// 단축 구동 정지-====================================================================================================
// 지정 축을 급정지한다.
function CFS20set_e_stop (axis : SmallInt) : Boolean; stdcall;
// 지정 축을 구동시 감속율로 정지한다.
function CFS20set_stop (axis : SmallInt) : Boolean; stdcall;
// 지정 축을 입력된 감속율로 정지한다.
function CFS20set_stop_decel (axis : SmallInt; deceleration : Double) : Boolean; stdcall;
// 지정 축을 입력된 감속 시간으로 정지한다.
function CFS20set_stop_deceltime (axis : SmallInt; deceltime : Double) : Boolean; stdcall;

// 다축 동기 구동관련 설정-==========================================================================================
// Master/Slave link 또는 좌표계 link 둘중 하나를 사용하여야 한다.
// Master/Slave link 설정. (일반 단축 구동시 master 축 구동시 slave축도 같이 구동된다.)
function CFS20link (master : SmallInt; slave : SmallInt; ratio : Double) : Boolean; stdcall;
// Master/Slave link 해제
function CFS20endlink (slave : SmallInt) : Boolean; stdcall;

// 좌표계 link 설정-================================================================================================
// 지정 좌표계에 축 할당 - n_axes갯수만큼의 축수를 설정/확인한다.(coordinate는 1..8까지 사용 가능)
// n_axes 갯수만큼의 축수를 설정/확인한다. - (n_axes는 1..4까지 사용 가능)
function CFS20map_axes (coordinate : SmallInt; n_axes : SmallInt; map_array : PSmallInt) : Boolean; stdcall;
function CFS20get_mapped_axes (coordinate : SmallInt; n_axes : SmallInt; map_array : PSmallInt) : Boolean; stdcall;
// 지정 좌표계의 상대/절대 모드 설정/확인한다.
procedure CFS20set_coordinate_mode (coordinate : SmallInt; mode : SmallInt); stdcall;
function CFS20get_coordinate_mode (coordinate : SmallInt) : SmallInt; stdcall;
// mode:
// 0: 상대좌표구동, 1: 절대좌표 구동
// 지정 좌표계의 속도 프로파일 설정/확인한다.
procedure CFS20set_move_profile (coordinate : SmallInt; mode : SmallInt); stdcall;
function CFS20get_move_profile (coordinate : SmallInt) : SmallInt; stdcall;
// mode:
// 0: 사다리꼴 구동, 1: S커브 구동
// 지정 좌표계의 초기 속도를 설정/확인한다.
procedure CFS20set_move_startstop_velocity (coordinate : SmallInt; velocity : Double); stdcall;
function CFS20get_move_startstop_velocity (coordinate : SmallInt) : Double; stdcall;
// 특정 좌표계의 속도를 설정/확인한다.
procedure CFS20set_move_velocity (coordinate : SmallInt; velocity : Double); stdcall;
function CFS20get_move_velocity (coordinate : SmallInt) : Double; stdcall;
// 특정 좌표계의 가속율을 설정/확인한다.
procedure CFS20set_move_acceleration (coordinate : SmallInt; acceleration : Double); stdcall;
function CFS20get_move_acceleration (coordinate : SmallInt) : Double; stdcall;
// 특정 좌표계의 가속 시간(Sec)을 설정/확인한다.
procedure CFS20set_move_acceltime (coordinate : SmallInt; acceltime : Double); stdcall;
function CFS20get_move_acceltime (coordinate : SmallInt) : Double; stdcall;
// 보간 구동중인  좌표계의 현재 구동속도를 반환한다.
function CFS20co_get_velocity (coordinate : SmallInt) : Double; stdcall;

// 소프트웨어 보간 구동(지정 좌표계에 대하여)-========================================================================
// Blocking함수 (제어권이 펄스 출력이 완료된 후 넘어옴)
// 2, 3, 4축이 동시이동한다.
function CFS20move_2 (coordinate : SmallInt; x : Double; y : Double) : Boolean; stdcall;
function CFS20move_3 (coordinate : SmallInt; x : Double; y : Double; z : Double) : Boolean; stdcall;
function CFS20move_4 (coordinate : SmallInt; x : Double; y : Double; z : Double; w : Double) : Boolean; stdcall;
// Non Blocking함수 (구동중일 경우 무시됨)
// 2, 3, 4축이 동시 이동한다.
function CFS20start_move_2 (coordinate : SmallInt; x : Double; y : Double) : Boolean; stdcall;
function CFS20start_move_3 (coordinate : SmallInt; x : Double; y : Double; z : Double) : Boolean; stdcall;
function CFS20start_move_4 (coordinate : SmallInt; x : Double; y : Double; z : Double; w : Double) : Boolean; stdcall;
// 지정 좌표계의 모든축의 모션 완료 체크    
function CFS20co_motion_done (coordinate : SmallInt) : Boolean; stdcall;
// 지정 좌표계의 구동이 완료될때 까지 기다린다.
function CFS20co_wait_for_done (coordinate : SmallInt) : Boolean; stdcall;

// 다축 구동(동기 구동) : Master/Slave로 link되어 있을 경우 오류가 발생 할 수 있다.-==================================
// 지정 축들을 지정 거리 및 속도 가속도 정보로 동기 시작 구동한다. 구동 시작에 대한 동기화시 사용한다. 
// start_** : 지정 축에서 구동 시작후 함수를 return한다. "start_*" 가 없으면 이동 완료후 return한다.
// *r*_*    : 지정 축에서 입력된 거리만큼(상대좌표)로 이동한다. "*r_*이 없으면 입력된 위치(절대좌표)로 이동한다.
// *s*_*    : 구동중 속도 프로파일을 "S curve"를 이용한다. "*s_*"가 없다면 사다리꼴 가감속을 이용한다.
// *_ex     : 구동중 가감속도를 가속 또는 감속 시간으로 입력 받는다. "*_ex"가 없다면 가감속률로 입력 받는다.

// 다축 지정펄스(Pulse Drive)구동, 사다리꼴 구동, 절대/상대좌표(r), 가속율/가속시간(_ex)(시간단위:Sec)
// Blocking함수 (제어권이 모든 구동축의 펄스 출력이 완료된 후 넘어옴)
function CFS20move_all (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; accelerations : PDouble) : Byte; stdcall;
function CFS20move_all_ex (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; acceltimes : PDouble) : Byte; stdcall;
function CFS20r_move_all (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; accelerations : PDouble) : Byte; stdcall;
function CFS20r_move_all_ex (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; acceltimes : PDouble) : Byte; stdcall;
// Non Blocking함수 (구동중인 축은 무시됨)
function CFS20start_move_all (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; accelerations : PDouble) : Boolean; stdcall;
function CFS20start_move_all_ex (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; acceltimes : PDouble) : Boolean; stdcall;
function CFS20start_r_move_all (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; accelerations : PDouble) : Boolean; stdcall;
function CFS20start_r_move_all_ex (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; acceltimes : PDouble) : Boolean; stdcall;
// 다축 지정펄스(Pulse Drive)구동, S자형 구동, 절대/상대좌표(r), 가속율/가속시간(_ex)(시간단위:Sec)
// Blocking함수 (제어권이 모든 구동축의 펄스 출력이 완료된 후 넘어옴)
function CFS20s_move_all (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; accelerations : PDouble) : Byte; stdcall;
function CFS20s_move_all_ex (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; acceltimes : PDouble) : Byte; stdcall;
function CFS20rs_move_all (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; accelerations : PDouble) : Byte; stdcall;
function CFS20rs_move_all_ex (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; acceltimes : PDouble) : Byte; stdcall;
// Non Blocking함수 (구동중인 축은 무시됨)
function CFS20start_s_move_all (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; accelerations : PDouble) : Boolean; stdcall;
function CFS20start_s_move_all_ex (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; acceltimes : PDouble) : Boolean; stdcall;
function CFS20start_rs_move_all (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; accelerations : PDouble) : Boolean; stdcall;
function CFS20start_rs_move_all_ex (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; acceltimes : PDouble) : Boolean; stdcall;
//지정 축들에 대하여 S자형 구동을 위한 가감속시의 S커브의 비율을 설정/확인한다.
procedure CFS20set_s_rate_all (number : SmallInt; axes : PSmallInt; a_percent : PDouble; b_percent : PDouble); stdcall;
procedure CFS20get_s_rate_all (number : SmallInt; axes : PSmallInt; a_percent : PDouble; b_percent : PDouble); stdcall;

// 다축 구동 확인-====================================================================================================
// 입력 해당 축들의 구동 상태를 확인하고 구동이 끝날 때 까지 기다린다.
function CFS20wait_for_all (number : SmallInt; axes : PSmallInt) : Byte; stdcall;

// 다축 동기 설정-====================================================================================================
// 지정 축들의 동기를 해제시킨다. - 구동명령이 내려져도 구동되지않고 대기함.
function CFS20reset_axis_sync (nLen : SmallInt; aAxis : PSmallInt) : Boolean; stdcall;
// 지정 축들의 동기를 해제시킨다. - 구동명령이 내려져도 구동되지않고 대기함.
function CFS20set_axis_sync (nLen : SmallInt; aAxis : PSmallInt) : Boolean; stdcall;
// 지정한 축을 동기 설정/해제/확인한다.
function CFS20set_sync_axis (axis : SmallInt; sync : Byte) : Boolean; stdcall;
function CFS20get_sync_axis (axis : SmallInt) : Byte; stdcall;
// sync:
// 0: Reset - 모터 구동하지 않음.
// 1: Set	- 모터 구동함.
// 지정한 모듈의 축을 동기 설정/해제/확인한다.
function CFS20set_sync_module (axis : SmallInt; sync : Byte) : Boolean; stdcall;
function CFS20get_sync_module (axis : SmallInt) : Byte; stdcall;
// sync:
// 0: Reset - 모터 구동하지 않음.
// 1: Set	- 모터 구동함.	

// 다축 구동 정지-====================================================================================================
// 홈 서치 쓰레드도 정지
function CFS20emergency_stop () : Boolean; stdcall;

// -원점검색 =========================================================================================================
// 라이브러리 상에서 Thread를 사용하여 검색한다. 주의 : 구동후 칩내의 StartStop Speed가 변할 수 있다.
// 원점검색을 종료한다.
function CFS20abort_home_search (axis : SmallInt; bStop : Byte) : Boolean; stdcall;
// bStop:
// 0: 감속정지
// 1: 급정지
// 원점검색을 시작한다. 시작하기 전에 원점검색에 필요한 설정이 필요하다.
function CFS20home_search (axis : SmallInt) : Boolean; stdcall;
// 입력 축들을 동시에 원점검색을 실시한다.
function CFS20home_search_all (number : SmallInt; axes : PSmallInt) : Boolean; stdcall;
// 원점검색 진행 중인지를 확인한다.
function CFS20get_home_done (axis : SmallInt) : Boolean; stdcall;
// 반환값: 0: 원점검색 진행중, 1: 원점검색 종료
// 해당 축들의 원점검색 진행 중인지를 확인한다.
function CFS20get_home_done_all (number : SmallInt; axes : PSmallInt) : Boolean; stdcall;
// 지정 축의 원점 검색 실행후 종료 상태를 확인한다.
function CFS20get_home_end_status (axis : SmallInt) : Byte; stdcall;
// 반환값: 0: 원점검색 실패, 1: 원점검색 성공
// 지정 축들의 원점 검색 실행후 종료 상태를 확인한다.
function CFS20get_home_end_status_all (number : SmallInt; axes : PSmallInt; endstatus : PByte) : Boolean; stdcall;
// 원점 검색시 각 스텝마다 method를 설정/확인한다.
// Method에 대한 설명 
//    0 Bit 스텝 사용여부 설정 (0 : 사용하지 않음, 1: 사용함
//    1 Bit 가감속 방법 설정 (0 : 가속율, 1 : 가속 시간)
//    2 Bit 정지방법 설정 (0 : 감속 정지, 1 : 급 정지)
//    3 Bit 검색방향 설정 (0 : cww(-), 1 : cw(+))
// 7654 Bit detect signal 설정(typedef : DETECT_DESTINATION_SIGNAL)
function CFS20set_home_method (axis : SmallInt; nstep : SmallInt; method : PByte) : Boolean; stdcall;
function CFS20get_home_method (axis : SmallInt; nstep : SmallInt; method : PByte) : Boolean; stdcall;
// 원점 검색시 각 스텝마다 offset을 설정/확인한다.	
function CFS20set_home_offset (axis : SmallInt; nstep : SmallInt; offset : PDouble) : Boolean; stdcall;
function CFS20get_home_offset (axis : SmallInt; nstep : SmallInt; offset : PDouble) : Boolean; stdcall;
// 각 축의 원점 검색 속도를 설정/확인한다.
function CFS20set_home_velocity (axis : SmallInt; nstep : SmallInt; velocity : PDouble) : Boolean; stdcall;
function CFS20get_home_velocity (axis : SmallInt; nstep : SmallInt; velocity : PDouble) : Boolean; stdcall;
// 지정 축의 원점 검색 시 각 스텝별 가속율을 설정/확인한다.
function CFS20set_home_acceleration (axis : SmallInt; nstep : SmallInt; acceleration : PDouble) : Boolean; stdcall;
function CFS20get_home_acceleration (axis : SmallInt; nstep : SmallInt; acceleration : PDouble) : Boolean; stdcall;
// 지정 축의 원점 검색 시 각 스텝별 가속 시간을 설정/확인한다.
function CFS20set_home_acceltime (axis : SmallInt; nstep : SmallInt; acceltime : PDouble) : Boolean; stdcall;
function CFS20get_home_acceltime (axis : SmallInt; nstep : SmallInt; acceltime : PDouble) : Boolean; stdcall;
// 지정 축에 원점 검색에서 엔코더 'Z'상 검출 사용 시 구동 한계값를 설정/확인한다.(Pulse) - 범위를 벗어나면 검색 실패
function CFS20set_zphase_search_range (axis : SmallInt; pulses : SmallInt) : Boolean; stdcall;
function CFS20get_zphase_search_range (axis : SmallInt) : SmallInt; stdcall;
// 현재 위치를 원점(0 Position)으로 설정한다. - 구동중이면 무시됨.
function CFS20home_zero (axis : SmallInt) : Boolean; stdcall;
// 설정한 모든 축의 현재 위치를 원점(0 Position)으로 설정한다. - 구동중인 축은 무시됨
function CFS20home_zero_all (number : SmallInt; axes : PSmallInt) : Boolean; stdcall;

// 범용 입출력-=======================================================================================================
// 범용 출력
// 0 bit : 범용 출력 0(Servo-On)
// 1 bit : 범용 출력 1(ALARM Clear)
// 2 bit : 범용 출력 2
// 3 bit : 범용 출력 3
// 4 bit(PLD) : 범용 출력 4
// 5 bit(PLD) : 범용 출력 5
// 범용 입력
// 0 bit : 범용 입력 0(ORiginal Sensor)
// 1 bit : 범용 입력 1(Z phase)
// 2 bit : 범용 입력 2
// 3 bit : 범용 입력 3
// 4 bit(PLD) : 범용 입력 5
// 5 bit(PLD) : 범용 입력 6
// On ==> 단자대 N24V, 'Off' ==> 단자대 Open(float).	

// 현재 범용 출력값을 설정/확인한다.
function CFS20set_output (axis : SmallInt; value : Byte) : Boolean; stdcall;
function CFS20get_output (axis : SmallInt) : Byte; stdcall;
// 범용 입력 값을 확인한다.
// '1'('On') <== 단자대 N24V와 연결됨, '0'('Off') <== 단자대 P24V 또는 Float.
function CFS20get_input (axis : SmallInt) : Byte; stdcall;
// 해당 축의 해당 bit의 출력을 On/Off 시킨다.
// bitNo : 0 ~ 5.
function CFS20set_output_bit (axis : SmallInt; bitNo : Byte) : Boolean; stdcall;
function CFS20reset_output_bit (axis : SmallInt; bitNo : Byte) : Boolean; stdcall;
// 해당 축의 해당 범용 출력 bit의 출력 상태를 확인한다.
// bitNo : 0 ~ 5.
function CFS20output_bit_on (axis : SmallInt; bitNo : Byte) : Boolean; stdcall;
// 해당 축의 해당 범용 출력 bit의 상태를 입력 state로 바꾼다.
// bitNo : 0 ~ 5. 
function CFS20change_output_bit (axis : SmallInt; bitNo : Byte; state : Byte) : Boolean; stdcall;
// 해당 축의 해당 범용 입력 bit의 상태를 확인 한다.
// bitNo : 0 ~ 5.
function CFS20input_bit_on (axis : SmallInt; bitNo : Byte) : Boolean; stdcall;
// 범용 입력(Universal input) 4 모드 설정/확인한다.
function CFS20set_ui4_mode (axis : SmallInt; state : Byte) : Boolean; stdcall;
function CFS20get_ui4_mode (axis : SmallInt) : Byte; stdcall;
// 범용 입력(Universal input) 5 모드 설정/확인한다.
function CFS20set_ui5_mode (axis : SmallInt; state : Byte) : Boolean; stdcall;
function CFS20get_ui5_mode (axis : SmallInt) : Byte; stdcall;

// 잔여 펄스 clear-===================================================================================================
// 해당 축의 서보팩 잔여 펄스 Clear 출력의 사용 여부를 설정/확인한다.
// CLR 신호의 Default 출력 ==> 단자대 Open이다.
function CFS20set_crc_mask (axis : SmallInt; mask : SmallInt) : Boolean; stdcall;
function CFS20get_crc_mask (axis : SmallInt) : Byte; stdcall;
// 해당 축의 잔여 펄스 Clear 출력의 Active level을 설정/확인한다.
// Default Active level ==> '1' ==> 단자대 N24V
function CFS20set_crc_level (axis : SmallInt; level : SmallInt) : Boolean; stdcall;
function CFS20get_crc_level (axis : SmallInt) : Byte; stdcall;
// 해당 축의 -Emeregency End limit에 대한 Clear출력 사용 유무를 설정/확인한다.    
function CFS20set_crc_nelm_mask (axis : SmallInt; mask : SmallInt) : Boolean; stdcall;
function CFS20get_crc_nelm_mask (axis : SmallInt) : Byte; stdcall;
// 해당 축의 -Emeregency End limit의 Active level을 설정/확인한다. set_nend_limit_level과 동일하게 설정한다.    
function CFS20set_crc_nelm_level (axis : SmallInt; level : SmallInt) : Boolean; stdcall;
function CFS20get_crc_nelm_level (axis : SmallInt) : Byte; stdcall;
// 해당 축의 +Emeregency End limit에 대한 Clear출력 사용 유무를 설정/확인한다.
function CFS20set_crc_pelm_mask (axis : SmallInt; mask : SmallInt) : Boolean; stdcall;
function CFS20get_crc_pelm_mask (axis : SmallInt) : Byte; stdcall;
// 해당 축의 +Emeregency End limit의 Active level을 설정/확인한다. set_nend_limit_level과 동일하게 설정한다.
function CFS20set_crc_pelm_level (axis : SmallInt; level : SmallInt) : Boolean; stdcall;
function CFS20get_crc_pelm_level (axis : SmallInt) : Byte; stdcall;
// 해당 축의 잔여 펄스 Clear 출력을 입력 값으로 강제 출력/확인한다.
function CFS20set_programmed_crc (axis : SmallInt; data : SmallInt) : Boolean; stdcall;
function CFS20get_programmed_crc (axis : SmallInt) : Byte; stdcall;

// 트리거 기능 ======================================================================================================
// 내부/외부 위치에 대하여 주기/절대 위치에서 설정된 Active level의 Trigger pulse를 발생 시킨다.
// 트리거 출력 펄스의 Active level을 설정/확인한다.
// ('0' : 5V 출력(0 V), 24V 터미널 출력(Open); '1'(default) : 5V 출력(5 V), 24V 터미널 출력(N24V).
function CFS20set_trigger_level (axis : SmallInt; trigger_level : Byte) : Boolean; stdcall;
function CFS20get_trigger_level (axis : SmallInt) : Byte; stdcall;
// 트리거 기능에 사용할 기준 위치를 선택한다.
// 0x0 : 외부 위치 External(Actual)
// 0x1 : 내부 위치 Internal(Command)
function CFS20set_trigger_sel (axis : SmallInt; trigger_sel : Byte) : Boolean; stdcall;
function CFS20get_trigger_sel (axis : SmallInt) : Byte; stdcall;
// 0x00 : FS Chip Trigger Time Use
// 0x01 : 8msec
// 0x02 : 16msec
// 0x03	: 24msec
// ~
// 0x0A: 80msec
// 0x0B: 88msec
// ~
// 0x0F: 120msec
function CFS20set_trigger_time (axis : SmallInt; time : Byte) : Boolean; stdcall;
function CFS20get_trigger_time (axis : SmallInt) : Byte; stdcall;
// 지정 축에 트리거 발생 방식을 설정/확인한다.
// 0x0 : 트리거 절대 위치에서 트리거 발생, 절대 위치 방식
// 0x1 : 트리거 위치값을 사용한 주기 트리거 방식
function CFS20set_trigger_mode (axis : SmallInt; mode_sel : Byte) : Boolean; stdcall;
function CFS20get_trigger_mode (axis : SmallInt) : Byte; stdcall;
// 지정 축에 트리거 주기 또는 절대 위치 값을 설정/확인한다.
function CFS20set_trigger_position (axis : SmallInt; trigger_position : Double) : Boolean; stdcall;
function CFS20get_trigger_position (axis : SmallInt) : Double; stdcall;
// 지정 축의 트리거 기능의 사용 여부를 설정/확인한다.
function CFS20set_trigger_enable (axis : SmallInt; ena_status : Byte) : Boolean; stdcall;
function CFS20is_trigger_enabled (axis : SmallInt) : Byte; stdcall;
// 지정 축에 트리거 발생시 인터럽트를 발생하도록 설정/확인한다.
function CFS20set_trigger_interrupt_enable (axis : SmallInt; ena_int : Byte) : Boolean; stdcall;
function CFS20is_trigger_interrupt_enabled (axis : SmallInt) : Byte; stdcall;

// MARK 드라이브 구동함수 ===========================================================================================
// MARK, 지정펄스(Pulse Drive) 사다리꼴 구동, 상대좌표, 가속율/가속시간(Sec)
function CFS20start_pr_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; drive : Byte) : Boolean; stdcall;
function CFS20start_pr_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; drive : Byte) : Boolean; stdcall;
// MARK, 비대칭 지정펄스(Pulse Drive) 사다리꼴 구동, 상대좌표, 가속율/가속시간(Sec)
function CFS20start_pra_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double; drive : Byte) : Boolean; stdcall;
function CFS20start_pra_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double; drive : Byte) : Boolean; stdcall;
// 지정펄스(Pulse Drive) 사다리꼴 구동, 상대좌표, 가속율/가속시간(Sec). 구동이 완료될때까지 대기
function CFS20pr_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; drive : Byte) : Word; stdcall;
function CFS20pr_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; drive : Byte) : Word; stdcall;
// MARK, 비대칭 지정펄스(Pulse Drive) 사다리꼴 구동, 상대좌표, 가속율/가속시간(Sec). 구동이 완료될때까지 대기
function CFS20pra_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double; drive : Byte) : Word; stdcall;
function CFS20pra_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double; drive : Byte) : Word; stdcall;
// MARK, 지정펄스(Pulse Drive) S자형 구동, 상대좌표, 가속율/가속시간(Sec)
function CFS20start_prs_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; drive : Byte) : Boolean; stdcall;
function CFS20start_prs_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; drive : Byte) : Boolean; stdcall;
// MARK, 비대칭 지정펄스(Pulse Drive) S자형 구동, 상대좌표, 가속율/가속시간(Sec)
function CFS20start_pras_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double; drive : Byte) : Boolean; stdcall;
function CFS20start_pras_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double; drive : Byte) : Boolean; stdcall;
// MARK, 지정펄스(Pulse Drive) S자형 구동, 상대좌표, 가속율/가속시간(Sec). 구동이 완료될때까지 대기
function CFS20prs_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; drive : Byte) : Word; stdcall;
function CFS20prs_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; drive : Byte) : Word; stdcall;
// MARK, 비대칭 지정펄스(Pulse Drive) S자형 구동, 상대좌표, 가속율/가속시간(Sec). 구동이 완료될때까지 대기
function CFS20pras_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double; drive : Byte) : Word; stdcall;
function CFS20pras_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double; drive : Byte) : Word; stdcall;
// MARK Signal의 Active level을 설정/확인/상태확인한다.
function CFS20set_mark_signal_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_mark_signal_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_mark_signal_switch (axis : SmallInt) : Byte; stdcall;	

function CFS20set_mark_signal_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_mark_signal_enable (axis : SmallInt) : Byte; stdcall;

// 위치 비교기 관련 함수군 ==========================================================================================
// Internal(Command) comparator값을 설정/확인한다.
procedure CFS20set_internal_comparator_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_internal_comparator_position (axis : SmallInt) : Double; stdcall;
// External(Encoder) comparator값을 설정/확인한다.
procedure CFS20set_external_comparator_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_external_comparator_position (axis : SmallInt) : Double; stdcall;

// 에러코드 읽기 함수군 =============================================================================================
// 마지막 에러코드를 읽는다.
function CFS20get_error_code () : SmallInt; stdcall;
// 에러코드의 원인을 문자로 반환한다.
function CFS20get_error_msg (ErrorCode : SmallInt) : Char; stdcall;

implementation

const

	dll_name	= 'AxtLib.dll';

	function InitializeCAMCFS20; external dll_name name 'InitializeCAMCFS20';
	function CFS20IsInitialized; external dll_name name 'CFS20IsInitialized';
	procedure CFS20StopService; external dll_name name 'CFS20StopService';

	function CFS20get_boardno; external dll_name name 'CFS20get_boardno';
	function CFS20get_numof_boards; external dll_name name 'CFS20get_numof_boards';
	function CFS20get_numof_axes; external dll_name name 'CFS20get_numof_axes';
	function CFS20get_total_numof_axis; external dll_name name 'CFS20get_total_numof_axis';
	function CFS20get_axisno; external dll_name name 'CFS20get_axisno';
	function CFS20get_axis_info; external dll_name name 'CFS20get_axis_info';

	function CFS20load_parameter; external dll_name name 'CFS20load_parameter';
	function CFS20save_parameter; external dll_name name 'CFS20save_parameter';
	function CFS20load_parameter_all; external dll_name name 'CFS20load_parameter_all';
	function CFS20save_parameter_all; external dll_name name 'CFS20save_parameter_all';

	procedure CFS20SetWindowMessage; external dll_name name 'CFS20SetWindowMessage';
	function CFS20read_interrupt_flag; external dll_name name 'CFS20read_interrupt_flag';

	procedure CFS20KeSetMainClk; external dll_name name 'CFS20KeSetMainClk';
	procedure CFS20set_drive_mode1; external dll_name name 'CFS20set_drive_mode1';
	function CFS20get_drive_mode1; external dll_name name 'CFS20get_drive_mode1';
	procedure CFS20set_drive_mode2; external dll_name name 'CFS20set_drive_mode2';
	function CFS20get_drive_mode2; external dll_name name 'CFS20get_drive_mode2';
	procedure CFS20set_moveunit_perpulse; external dll_name name 'CFS20set_moveunit_perpulse';
	function CFS20get_moveunit_perpulse; external dll_name name 'CFS20get_moveunit_perpulse';
	procedure CFS20set_movepulse_perunit; external dll_name name 'CFS20set_movepulse_perunit';
	function CFS20get_movepulse_perunit; external dll_name name 'CFS20get_movepulse_perunit';
	procedure CFS20set_startstop_speed; external dll_name name 'CFS20set_startstop_speed';
	function CFS20get_startstop_speed; external dll_name name 'CFS20get_startstop_speed';
	function CFS20set_max_speed; external dll_name name 'CFS20set_max_speed';
	function CFS20get_max_speed; external dll_name name 'CFS20get_max_speed';
	procedure CFS20set_s_rate; external dll_name name 'CFS20set_s_rate';
	procedure CFS20get_s_rate; external dll_name name 'CFS20get_s_rate';
	procedure CFS20set_slowdown_rear_pulse; external dll_name name 'CFS20set_slowdown_rear_pulse';
	function CFS20get_slowdown_rear_pulse; external dll_name name 'CFS20get_slowdown_rear_pulse';
	function CFS20set_decel_point; external dll_name name 'CFS20set_decel_point';
	function CFS20get_decel_point; external dll_name name 'CFS20get_decel_point';

	function CFS20in_motion; external dll_name name 'CFS20in_motion';
	function CFS20motion_done; external dll_name name 'CFS20motion_done';
	function CFS20get_drive_pulse_counts; external dll_name name 'CFS20get_drive_pulse_counts';
	function CFS20get_drive_status; external dll_name name 'CFS20get_drive_status';
	function CFS20get_end_status; external dll_name name 'CFS20get_end_status';
	function CFS20get_mechanical_signal; external dll_name name 'CFS20get_mechanical_signal';
	function CFS20get_velocity; external dll_name name 'CFS20get_velocity';
	function CFS20get_error; external dll_name name 'CFS20get_error';
	function CFS20get_drivedistance; external dll_name name 'CFS20get_drivedistance';

	function CFS20set_enc_input_method; external dll_name name 'CFS20set_enc_input_method';
	function CFS20get_enc_input_method; external dll_name name 'CFS20get_enc_input_method';
	function CFS20set_enc2_input_method; external dll_name name 'CFS20set_enc2_input_method';
	function CFS20get_enc2_input_method; external dll_name name 'CFS20get_enc2_input_method';
	function CFS20set_enc_reverse; external dll_name name 'CFS20set_enc_reverse';
	function CFS20get_enc_reverse; external dll_name name 'CFS20get_enc_reverse';

	function CFS20set_pulse_out_method; external dll_name name 'CFS20set_pulse_out_method';
	function CFS20get_pulse_out_method; external dll_name name 'CFS20get_pulse_out_method';

	procedure CFS20set_actual_position; external dll_name name 'CFS20set_actual_position';
	function CFS20get_actual_position; external dll_name name 'CFS20get_actual_position';
	procedure CFS20set_command_position; external dll_name name 'CFS20set_command_position';
	function CFS20get_command_position; external dll_name name 'CFS20get_command_position';

	function CFS20set_servo_level; external dll_name name 'CFS20set_servo_level';
	function CFS20get_servo_level; external dll_name name 'CFS20get_servo_level';
	function CFS20set_servo_enable; external dll_name name 'CFS20set_servo_enable';
	function CFS20get_servo_enable; external dll_name name 'CFS20get_servo_enable';

	function CFS20set_inposition_enable; external dll_name name 'CFS20set_inposition_enable';
	function CFS20get_inposition_enable; external dll_name name 'CFS20get_inposition_enable';
	function CFS20set_inposition_level; external dll_name name 'CFS20set_inposition_level';
	function CFS20get_inposition_level; external dll_name name 'CFS20get_inposition_level';
	function CFS20get_inposition_switch; external dll_name name 'CFS20get_inposition_switch';
	function CFS20in_position; external dll_name name 'CFS20in_position';
	function CFS20set_alarm_enable; external dll_name name 'CFS20set_alarm_enable';
	function CFS20get_alarm_enable; external dll_name name 'CFS20get_alarm_enable';
	function CFS20set_alarm_level; external dll_name name 'CFS20set_alarm_level';
	function CFS20get_alarm_level; external dll_name name 'CFS20get_alarm_level';
	function CFS20get_alarm_switch; external dll_name name 'CFS20get_alarm_switch';

	function CFS20set_end_limit_enable; external dll_name name 'CFS20set_end_limit_enable';
	function CFS20get_end_limit_enable; external dll_name name 'CFS20get_end_limit_enable';
	function CFS20set_nend_limit_level; external dll_name name 'CFS20set_nend_limit_level';
	function CFS20get_nend_limit_level; external dll_name name 'CFS20get_nend_limit_level';
	function CFS20get_nend_limit_switch; external dll_name name 'CFS20get_nend_limit_switch';
	function CFS20set_pend_limit_level; external dll_name name 'CFS20set_pend_limit_level';
	function CFS20get_pend_limit_level; external dll_name name 'CFS20get_pend_limit_level';
	function CFS20get_pend_limit_switch; external dll_name name 'CFS20get_pend_limit_switch';
	function CFS20set_slow_limit_enable; external dll_name name 'CFS20set_slow_limit_enable';
	function CFS20get_slow_limit_enable; external dll_name name 'CFS20get_slow_limit_enable';
	function CFS20set_nslow_limit_level; external dll_name name 'CFS20set_nslow_limit_level';
	function CFS20get_nslow_limit_level; external dll_name name 'CFS20get_nslow_limit_level';
	function CFS20get_nslow_limit_switch; external dll_name name 'CFS20get_nslow_limit_switch';
	function CFS20set_pslow_limit_level; external dll_name name 'CFS20set_pslow_limit_level';
	function CFS20get_pslow_limit_level; external dll_name name 'CFS20get_pslow_limit_level';
	function CFS20get_pslow_limit_switch; external dll_name name 'CFS20get_pslow_limit_switch';
	function CFS20set_nlimit_sel; external dll_name name 'CFS20set_nlimit_sel';
	function CFS20get_nlimit_sel; external dll_name name 'CFS20get_nlimit_sel';
	function CFS20set_plimit_sel; external dll_name name 'CFS20set_plimit_sel';
	function CFS20get_plimit_sel; external dll_name name 'CFS20get_plimit_sel';

	procedure CFS20set_soft_limit_enable; external dll_name name 'CFS20set_soft_limit_enable';
	function CFS20get_soft_limit_enable; external dll_name name 'CFS20get_soft_limit_enable';
	procedure CFS20set_soft_limit_sel; external dll_name name 'CFS20set_soft_limit_sel';
	function CFS20get_soft_limit_sel; external dll_name name 'CFS20get_soft_limit_sel';
	procedure CFS20set_soft_limit_stopmode; external dll_name name 'CFS20set_soft_limit_stopmode';
	function CFS20get_soft_limit_stopmode; external dll_name name 'CFS20get_soft_limit_stopmode';
	procedure CFS20set_soft_nlimit_position; external dll_name name 'CFS20set_soft_nlimit_position';
	function CFS20get_soft_nlimit_position; external dll_name name 'CFS20get_soft_nlimit_position';
	procedure CFS20set_soft_plimit_position; external dll_name name 'CFS20set_soft_plimit_position';
	function CFS20get_soft_plimit_position; external dll_name name 'CFS20get_soft_plimit_position';

	function CFS20set_emg_signal_enable; external dll_name name 'CFS20set_emg_signal_enable';
	function CFS20get_emg_signal_enable; external dll_name name 'CFS20get_emg_signal_enable';
	function CFS20set_stop_sel; external dll_name name 'CFS20set_stop_sel';
	function CFS20get_stop_sel; external dll_name name 'CFS20get_stop_sel';


	function CFS20move; external dll_name name 'CFS20move';
	function CFS20move_ex; external dll_name name 'CFS20move_ex';
	function CFS20r_move; external dll_name name 'CFS20r_move';
	function CFS20r_move_ex; external dll_name name 'CFS20r_move_ex';
	function CFS20start_move; external dll_name name 'CFS20start_move';
	function CFS20start_move_ex; external dll_name name 'CFS20start_move_ex';
	function CFS20start_r_move; external dll_name name 'CFS20start_r_move';
	function CFS20start_r_move_ex; external dll_name name 'CFS20start_r_move_ex';
	function CFS20a_move; external dll_name name 'CFS20a_move';
	function CFS20a_move_ex; external dll_name name 'CFS20a_move_ex';
	function CFS20ra_move; external dll_name name 'CFS20ra_move';
	function CFS20ra_move_ex; external dll_name name 'CFS20ra_move_ex';
	function CFS20start_a_move; external dll_name name 'CFS20start_a_move';
	function CFS20start_a_move_ex; external dll_name name 'CFS20start_a_move_ex';
	function CFS20start_ra_move; external dll_name name 'CFS20start_ra_move';
	function CFS20start_ra_move_ex; external dll_name name 'CFS20start_ra_move_ex';
	function CFS20s_move; external dll_name name 'CFS20s_move';
	function CFS20s_move_ex; external dll_name name 'CFS20s_move_ex';
	function CFS20rs_move; external dll_name name 'CFS20rs_move';
	function CFS20rs_move_ex; external dll_name name 'CFS20rs_move_ex';
	function CFS20start_s_move; external dll_name name 'CFS20start_s_move';
	function CFS20start_s_move_ex; external dll_name name 'CFS20start_s_move_ex';
	function CFS20start_rs_move; external dll_name name 'CFS20start_rs_move';
	function CFS20start_rs_move_ex; external dll_name name 'CFS20start_rs_move_ex';
	function CFS20as_move; external dll_name name 'CFS20as_move';
	function CFS20as_move_ex; external dll_name name 'CFS20as_move_ex';
	function CFS20ras_move; external dll_name name 'CFS20ras_move';
	function CFS20ras_move_ex; external dll_name name 'CFS20ras_move_ex';
	function CFS20start_as_move; external dll_name name 'CFS20start_as_move';
	function CFS20start_as_move2; external dll_name name 'CFS20start_as_move2';
	function CFS20start_as_move_ex; external dll_name name 'CFS20start_as_move_ex';
	function CFS20start_ras_move; external dll_name name 'CFS20start_ras_move';
	function CFS20start_ras_move_ex; external dll_name name 'CFS20start_ras_move_ex';

	function CFS20start_rs_move_override; external dll_name name 'CFS20start_rs_move_override';


	function CFS20v_move; external dll_name name 'CFS20v_move';
	function CFS20v_move_ex; external dll_name name 'CFS20v_move_ex';
	function CFS20v_a_move; external dll_name name 'CFS20v_a_move';
	function CFS20v_a_move_ex; external dll_name name 'CFS20v_a_move_ex';
	function CFS20v_s_move; external dll_name name 'CFS20v_s_move';
	function CFS20v_s_move_ex; external dll_name name 'CFS20v_s_move_ex';
	function CFS20v_as_move; external dll_name name 'CFS20v_as_move';
	function CFS20v_as_move_ex; external dll_name name 'CFS20v_as_move_ex';


	function CFS20start_signal_search1; external dll_name name 'CFS20start_signal_search1';
	function CFS20start_signal_search1_ex; external dll_name name 'CFS20start_signal_search1_ex';
	function CFS20start_s_signal_search1; external dll_name name 'CFS20start_s_signal_search1';
	function CFS20start_s_signal_search1_ex; external dll_name name 'CFS20start_s_signal_search1_ex';
	function CFS20start_signal_search2; external dll_name name 'CFS20start_signal_search2';

	function CFS20set_mpg_drive_mode; external dll_name name 'CFS20set_mpg_drive_mode';
	function CFS20get_mpg_drive_mode; external dll_name name 'CFS20get_mpg_drive_mode';
	function CFS20set_mpg_dir_mode; external dll_name name 'CFS20set_mpg_dir_mode';
	function CFS20get_mpg_dir_mode; external dll_name name 'CFS20get_mpg_dir_mode';
	function CFS20set_mpg_user_dir; external dll_name name 'CFS20set_mpg_user_dir';
	function CFS20get_mpg_user_dir; external dll_name name 'CFS20get_mpg_user_dir';
	function CFS20set_mpg_input_method; external dll_name name 'CFS20set_mpg_input_method';
	function CFS20get_mpg_input_method; external dll_name name 'CFS20get_mpg_input_method';
	function CFS20set_mpg_position; external dll_name name 'CFS20set_mpg_position';
	function CFS20get_mpg_position; external dll_name name 'CFS20get_mpg_position';

	function CFS20start_mpg; external dll_name name 'CFS20start_mpg';
	function CFS20start_mpg_ex; external dll_name name 'CFS20start_mpg_ex';
	function CFS20start_s_mpg; external dll_name name 'CFS20start_s_mpg';
	function CFS20start_s_mpg_ex; external dll_name name 'CFS20start_s_mpg_ex';

	function CFS20position_override; external dll_name name 'CFS20position_override';
	function CFS20position_r_override; external dll_name name 'CFS20position_r_override';
	function CFS20velocity_override; external dll_name name 'CFS20velocity_override';
	function CFS20position_override2; external dll_name name 'CFS20position_override2';
	function CFS20velocity_override2; external dll_name name 'CFS20velocity_override2';

	function CFS20wait_for_done; external dll_name name 'CFS20wait_for_done';

	function CFS20set_e_stop; external dll_name name 'CFS20set_e_stop';
	function CFS20set_stop; external dll_name name 'CFS20set_stop';
	function CFS20set_stop_decel; external dll_name name 'CFS20set_stop_decel';
	function CFS20set_stop_deceltime; external dll_name name 'CFS20set_stop_deceltime';

	function CFS20link; external dll_name name 'CFS20link';
	function CFS20endlink; external dll_name name 'CFS20endlink';

	function CFS20map_axes; external dll_name name 'CFS20map_axes';
	function CFS20get_mapped_axes; external dll_name name 'CFS20get_mapped_axes';
	procedure CFS20set_coordinate_mode; external dll_name name 'CFS20set_coordinate_mode';
	function CFS20get_coordinate_mode; external dll_name name 'CFS20get_coordinate_mode';
	procedure CFS20set_move_profile; external dll_name name 'CFS20set_move_profile';
	function CFS20get_move_profile; external dll_name name 'CFS20get_move_profile';
	procedure CFS20set_move_startstop_velocity; external dll_name name 'CFS20set_move_startstop_velocity';
	function CFS20get_move_startstop_velocity; external dll_name name 'CFS20get_move_startstop_velocity';
	procedure CFS20set_move_velocity; external dll_name name 'CFS20set_move_velocity';
	function CFS20get_move_velocity; external dll_name name 'CFS20get_move_velocity';
	procedure CFS20set_move_acceleration; external dll_name name 'CFS20set_move_acceleration';
	function CFS20get_move_acceleration; external dll_name name 'CFS20get_move_acceleration';
	procedure CFS20set_move_acceltime; external dll_name name 'CFS20set_move_acceltime';
	function CFS20get_move_acceltime; external dll_name name 'CFS20get_move_acceltime';
	function CFS20co_get_velocity; external dll_name name 'CFS20co_get_velocity';

	function CFS20move_2; external dll_name name 'CFS20move_2';
	function CFS20move_3; external dll_name name 'CFS20move_3';
	function CFS20move_4; external dll_name name 'CFS20move_4';
	function CFS20start_move_2; external dll_name name 'CFS20start_move_2';
	function CFS20start_move_3; external dll_name name 'CFS20start_move_3';
	function CFS20start_move_4; external dll_name name 'CFS20start_move_4';
	function CFS20co_motion_done; external dll_name name 'CFS20co_motion_done';
	function CFS20co_wait_for_done; external dll_name name 'CFS20co_wait_for_done';


	function CFS20move_all; external dll_name name 'CFS20move_all';
	function CFS20move_all_ex; external dll_name name 'CFS20move_all_ex';
	function CFS20r_move_all; external dll_name name 'CFS20r_move_all';
	function CFS20r_move_all_ex; external dll_name name 'CFS20r_move_all_ex';
	function CFS20start_move_all; external dll_name name 'CFS20start_move_all';
	function CFS20start_move_all_ex; external dll_name name 'CFS20start_move_all_ex';
	function CFS20start_r_move_all; external dll_name name 'CFS20start_r_move_all';
	function CFS20start_r_move_all_ex; external dll_name name 'CFS20start_r_move_all_ex';
	function CFS20s_move_all; external dll_name name 'CFS20s_move_all';
	function CFS20s_move_all_ex; external dll_name name 'CFS20s_move_all_ex';
	function CFS20rs_move_all; external dll_name name 'CFS20rs_move_all';
	function CFS20rs_move_all_ex; external dll_name name 'CFS20rs_move_all_ex';
	function CFS20start_s_move_all; external dll_name name 'CFS20start_s_move_all';
	function CFS20start_s_move_all_ex; external dll_name name 'CFS20start_s_move_all_ex';
	function CFS20start_rs_move_all; external dll_name name 'CFS20start_rs_move_all';
	function CFS20start_rs_move_all_ex; external dll_name name 'CFS20start_rs_move_all_ex';
	procedure CFS20set_s_rate_all; external dll_name name 'CFS20set_s_rate_all';
	procedure CFS20get_s_rate_all; external dll_name name 'CFS20get_s_rate_all';

	function CFS20wait_for_all; external dll_name name 'CFS20wait_for_all';

	function CFS20reset_axis_sync; external dll_name name 'CFS20reset_axis_sync';
	function CFS20set_axis_sync; external dll_name name 'CFS20set_axis_sync';
	function CFS20set_sync_axis; external dll_name name 'CFS20set_sync_axis';
	function CFS20get_sync_axis; external dll_name name 'CFS20get_sync_axis';
	function CFS20set_sync_module; external dll_name name 'CFS20set_sync_module';
	function CFS20get_sync_module; external dll_name name 'CFS20get_sync_module';

	function CFS20emergency_stop; external dll_name name 'CFS20emergency_stop';

	function CFS20abort_home_search; external dll_name name 'CFS20abort_home_search';
	function CFS20home_search; external dll_name name 'CFS20home_search';
	function CFS20home_search_all; external dll_name name 'CFS20home_search_all';
	function CFS20get_home_done; external dll_name name 'CFS20get_home_done';
	function CFS20get_home_done_all; external dll_name name 'CFS20get_home_done_all';
	function CFS20get_home_end_status; external dll_name name 'CFS20get_home_end_status';
	function CFS20get_home_end_status_all; external dll_name name 'CFS20get_home_end_status_all';
	function CFS20set_home_method; external dll_name name 'CFS20set_home_method';
	function CFS20get_home_method; external dll_name name 'CFS20get_home_method';
	function CFS20set_home_offset; external dll_name name 'CFS20set_home_offset';
	function CFS20get_home_offset; external dll_name name 'CFS20get_home_offset';
	function CFS20set_home_velocity; external dll_name name 'CFS20set_home_velocity';
	function CFS20get_home_velocity; external dll_name name 'CFS20get_home_velocity';
	function CFS20set_home_acceleration; external dll_name name 'CFS20set_home_acceleration';
	function CFS20get_home_acceleration; external dll_name name 'CFS20get_home_acceleration';
	function CFS20set_home_acceltime; external dll_name name 'CFS20set_home_acceltime';
	function CFS20get_home_acceltime; external dll_name name 'CFS20get_home_acceltime';
	function CFS20set_zphase_search_range; external dll_name name 'CFS20set_zphase_search_range';
	function CFS20get_zphase_search_range; external dll_name name 'CFS20get_zphase_search_range';
	function CFS20home_zero; external dll_name name 'CFS20home_zero';
	function CFS20home_zero_all; external dll_name name 'CFS20home_zero_all';


	function CFS20set_output; external dll_name name 'CFS20set_output';
	function CFS20get_output; external dll_name name 'CFS20get_output';
	function CFS20get_input; external dll_name name 'CFS20get_input';
	function CFS20set_output_bit; external dll_name name 'CFS20set_output_bit';
	function CFS20reset_output_bit; external dll_name name 'CFS20reset_output_bit';
	function CFS20output_bit_on; external dll_name name 'CFS20output_bit_on';
	function CFS20change_output_bit; external dll_name name 'CFS20change_output_bit';
	function CFS20input_bit_on; external dll_name name 'CFS20input_bit_on';
	function CFS20set_ui4_mode; external dll_name name 'CFS20set_ui4_mode';
	function CFS20get_ui4_mode; external dll_name name 'CFS20get_ui4_mode';
	function CFS20set_ui5_mode; external dll_name name 'CFS20set_ui5_mode';
	function CFS20get_ui5_mode; external dll_name name 'CFS20get_ui5_mode';

	function CFS20set_crc_mask; external dll_name name 'CFS20set_crc_mask';
	function CFS20get_crc_mask; external dll_name name 'CFS20get_crc_mask';
	function CFS20set_crc_level; external dll_name name 'CFS20set_crc_level';
	function CFS20get_crc_level; external dll_name name 'CFS20get_crc_level';
	function CFS20set_crc_nelm_mask; external dll_name name 'CFS20set_crc_nelm_mask';
	function CFS20get_crc_nelm_mask; external dll_name name 'CFS20get_crc_nelm_mask';
	function CFS20set_crc_nelm_level; external dll_name name 'CFS20set_crc_nelm_level';
	function CFS20get_crc_nelm_level; external dll_name name 'CFS20get_crc_nelm_level';
	function CFS20set_crc_pelm_mask; external dll_name name 'CFS20set_crc_pelm_mask';
	function CFS20get_crc_pelm_mask; external dll_name name 'CFS20get_crc_pelm_mask';
	function CFS20set_crc_pelm_level; external dll_name name 'CFS20set_crc_pelm_level';
	function CFS20get_crc_pelm_level; external dll_name name 'CFS20get_crc_pelm_level';
	function CFS20set_programmed_crc; external dll_name name 'CFS20set_programmed_crc';
	function CFS20get_programmed_crc; external dll_name name 'CFS20get_programmed_crc';

	function CFS20set_trigger_level; external dll_name name 'CFS20set_trigger_level';
	function CFS20get_trigger_level; external dll_name name 'CFS20get_trigger_level';
	function CFS20set_trigger_sel; external dll_name name 'CFS20set_trigger_sel';
	function CFS20get_trigger_sel; external dll_name name 'CFS20get_trigger_sel';
	function CFS20set_trigger_time; external dll_name name 'CFS20set_trigger_time';
	function CFS20get_trigger_time; external dll_name name 'CFS20get_trigger_time';
	function CFS20set_trigger_mode; external dll_name name 'CFS20set_trigger_mode';
	function CFS20get_trigger_mode; external dll_name name 'CFS20get_trigger_mode';
	function CFS20set_trigger_position; external dll_name name 'CFS20set_trigger_position';
	function CFS20get_trigger_position; external dll_name name 'CFS20get_trigger_position';
	function CFS20set_trigger_enable; external dll_name name 'CFS20set_trigger_enable';
	function CFS20is_trigger_enabled; external dll_name name 'CFS20is_trigger_enabled';
	function CFS20set_trigger_interrupt_enable; external dll_name name 'CFS20set_trigger_interrupt_enable';
	function CFS20is_trigger_interrupt_enabled; external dll_name name 'CFS20is_trigger_interrupt_enabled';

	function CFS20start_pr_move; external dll_name name 'CFS20start_pr_move';
	function CFS20start_pr_move_ex; external dll_name name 'CFS20start_pr_move_ex';
	function CFS20start_pra_move; external dll_name name 'CFS20start_pra_move';
	function CFS20start_pra_move_ex; external dll_name name 'CFS20start_pra_move_ex';
	function CFS20pr_move; external dll_name name 'CFS20pr_move';
	function CFS20pr_move_ex; external dll_name name 'CFS20pr_move_ex';
	function CFS20pra_move; external dll_name name 'CFS20pra_move';
	function CFS20pra_move_ex; external dll_name name 'CFS20pra_move_ex';
	function CFS20start_prs_move; external dll_name name 'CFS20start_prs_move';
	function CFS20start_prs_move_ex; external dll_name name 'CFS20start_prs_move_ex';
	function CFS20start_pras_move; external dll_name name 'CFS20start_pras_move';
	function CFS20start_pras_move_ex; external dll_name name 'CFS20start_pras_move_ex';
	function CFS20prs_move; external dll_name name 'CFS20prs_move';
	function CFS20prs_move_ex; external dll_name name 'CFS20prs_move_ex';
	function CFS20pras_move; external dll_name name 'CFS20pras_move';
	function CFS20pras_move_ex; external dll_name name 'CFS20pras_move_ex';
	function CFS20set_mark_signal_level; external dll_name name 'CFS20set_mark_signal_level';
	function CFS20get_mark_signal_level; external dll_name name 'CFS20get_mark_signal_level';
	function CFS20get_mark_signal_switch; external dll_name name 'CFS20get_mark_signal_switch';

	function CFS20set_mark_signal_enable; external dll_name name 'CFS20set_mark_signal_enable';
	function CFS20get_mark_signal_enable; external dll_name name 'CFS20get_mark_signal_enable';

	procedure CFS20set_internal_comparator_position; external dll_name name 'CFS20set_internal_comparator_position';
	function CFS20get_internal_comparator_position; external dll_name name 'CFS20get_internal_comparator_position';
	procedure CFS20set_external_comparator_position; external dll_name name 'CFS20set_external_comparator_position';
	function CFS20get_external_comparator_position; external dll_name name 'CFS20get_external_comparator_position';

	function CFS20get_error_code; external dll_name name 'CFS20get_error_code';
	function CFS20get_error_msg; external dll_name name 'CFS20get_error_msg';
end.