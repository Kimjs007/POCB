//*****************************************************************************
//*****************************************************************************
//**
//** File Name
//** ----------
//**
//** AXM.PAS
//**
//** COPYRIGHT (c) AJINEXTEK Co., LTD
//**
//*****************************************************************************
//*****************************************************************************
//**
//** Description
//** -----------
//** Ajinextek Motion Library Header File
//** 
//**
//*****************************************************************************
//*****************************************************************************
//**
//** Source Change Indices
//** ---------------------
//** 
//** (None)
//**
//**
//*****************************************************************************
//*****************************************************************************
//**
//** Website
//** ---------------------
//**
//** http://www.ajinextek.com
//**
//*****************************************************************************
//*****************************************************************************

unit AXM;

interface

uses Windows, Messages, AXHS;

//========== 보드 및 모듈 확인함수(Info) - Infomation =================================================================================

// 해당 축의 보드번호, 모듈 위치, 모듈 아이디를 반환한다.
function AxmInfoGetAxis (lAxisNo : LongInt; lpBoardNo : PLongInt; lpModulePos : PLongInt; upModuleID : PDWord) : DWord; stdcall;
// 모션 모듈이 존재하는지 반환한다.
function AxmInfoIsMotionModule (upStatus : PDWord) : DWord; stdcall;
// 해당 축이 유효한지 반환한다.
function AxmInfoIsInvalidAxisNo (lAxisNo : LongInt) : DWord; stdcall;
// CAMC-IP, CAMC-QI 축 개수, 시스템에 장착된 유효한 모션 축수를 반환한다.
function AxmInfoGetAxisCount (lpAxisCount : PLongInt) : DWord; stdcall;
// 해당 보드/모듈의 첫번째 축번호를 반환한다.
function AxmInfoGetFirstAxisNo (lBoardNo : LongInt; lModulePos : LongInt; lpAxisNo : PLongInt) : DWord; stdcall;    

//========= 가상 축 함수 ============================================================================================    
// 초기 상태에서 AXM 모든 함수의 축번호 설정은 0 ~ (실제 시스템에 장착된 축수 - 1) 범위에서 유효하지만
// 이 함수를 사용하여 실제 장착된 축번호 대신 임의의 축번호로 바꿀 수 있다.
// 이 함수는 제어 시스템의 H/W 변경사항 발생시 기존 프로그램에 할당된 축번호를 그대로 유지하고 실제 제어 축의
// 물리적인 위치를 변경하여 사용을 위해 만들어진 함수이다.
// 주의사항 : 여러 개의 실제 축번호에 대하여 같은 번호로 가상 축을 중복해서 맵핑할 경우
//            실제 축번호가 낮은 축만 가상 축번호로 제어 할 수 있으며,
//            나머지 같은 가상축 번호로 맵핑된 축은 제어가 불가능한 경우가 발생 할 수 있다.

// 가상축을 설정한다.
function AxmVirtualSetAxisNoMap (lRealAxisNo : LongInt; lVirtualAxisNo : LongInt) : DWord; stdcall;
// 설정한 가상채널(축) 번호를 반환한다.
function AxmVirtualGetAxisNoMap (lRealAxisNo : LongInt; lpVirtualAxisNo : PLongInt) : DWord; stdcall;
// 멀티 가상축을 설정한다.
function AxmVirtualSetMultiAxisNoMap (lSize : LongInt; lpRealAxesNo : PLongInt; lpVirtualAxesNo : PLongInt) : DWord; stdcall;
// 설정한 멀티 가상채널(축) 번호를 반환한다.
function AxmVirtualGetMultiAxisNoMap (lSize : LongInt; lpRealAxesNo : PLongInt; lpVirtualAxesNo : PLongInt) : DWord; stdcall;
// 가상축 설정을 해지한다.
function AxmVirtualResetAxisMap () : DWord; stdcall;

//========= 인터럽트 관련 함수 ======================================================================================    
// 콜백 함수 방식은 이벤트 발생 시점에 즉시 콜백 함수가 호출 됨으로 가장 빠르게 이벤트를 통지받을 수 있는 장점이 있으나
// 콜백 함수가 완전히 종료 될 때까지 메인 프로세스가 정체되어 있게 된다.
// 즉, 콜백 함수 내에 부하가 걸리는 작업이 있을 경우에는 사용에 주의를 요한다. 
// 이벤트 방식은 쓰레드등을 이용하여 인터럽트 발생여부를 지속적으로 감시하고 있다가 인터럽트가 발생하면 
// 처리해주는 방법으로, 쓰레드 등으로 인해 시스템 자원을 점유하고 있는 단점이 있지만
// 가장 빠르게 인터럽트를 검출하고 처리해줄 수 있는 장점이 있다.
// 일반적으로는 많이 쓰이지 않지만, 인터럽트의 빠른처리가 주요 관심사인 경우에 사용된다. 
// 이벤트 방식은 이벤트의 발생 여부를 감시하는 특정 쓰레드를 사용하여 메인 프로세스와 별개로 동작되므로
// MultiProcessor 시스템등에서 자원을 가장 효율적으로 사용할 수 있게 되어 특히 권장하는 방식이다.

// 인터럽트 메시지를 받아오기 위하여 윈도우 메시지 또는 콜백 함수를 사용한다.
// (메시지 핸들, 메시지 ID, 콜백함수, 인터럽트 이벤트)
//    hWnd    : 윈도우 핸들, 윈도우 메세지를 받을때 사용. 사용하지 않으면 NULL을 입력.
//    wMsg    : 윈도우 핸들의 메세지, 사용하지 않거나 디폴트값을 사용하려면 0을 입력.
//    proc    : 인터럽트 발생시 호출될 함수의 포인터, 사용하지 않으면 NULL을 입력.
//    pEvent  : 이벤트 방법사용시 이벤트 핸들
function AxmInterruptSetAxis (lAxisNo : LongInt; hWnd : HWND; uMessage : DWord; pProc : AXT_INTERRUPT_PROC; pEvent : PDWord) : DWord; stdcall;

// 설정 축의 인터럽트 사용 여부를 설정한다
// 해당 축에 인터럽트 설정 / 확인
// uUse : 사용 유무 => DISABLE(0), ENABLE(1)
function AxmInterruptSetAxisEnable (lAxisNo : LongInt; uUse : DWord) : DWord; stdcall;
// 설정 축의 인터럽트 사용 여부를 반환한다
function AxmInterruptGetAxisEnable (lAxisNo : LongInt; upUse : PDWord) : DWord; stdcall;

//인터럽트를 이벤트 방식으로 사용할 경우 해당 인터럽트 정보 읽는다.
function AxmInterruptRead (lpAxisNo : PLongInt; upFlag : PDWord) : DWord; stdcall;    

// 해당 축의 인터럽트 플래그 값을 반환한다.
function AxmInterruptReadAxisFlag (lAxisNo : LongInt; lBank : LongInt; upFlag : PDWord) : DWord; stdcall;

// 지정 축의 사용자가 설정한 인터럽트 발생 여부를 설정한다.
// lBank         : 인터럽트 뱅크 번호 (0 - 1) 설정가능.
// uInterruptNum : 인터럽트 번호 설정 비트번호로 설정 hex값 혹은 define된값을 설정
// AXHS.h파일에 IP, QI INTERRUPT_BANK1, 2 DEF를 확인한다.
function AxmInterruptSetUserEnable (lAxisNo : LongInt; lBank : LongInt; uInterruptNum : DWord) : DWord; stdcall;

// 지정 축의 사용자가 설정한 인터럽트 발생 여부를 확인한다.
function AxmInterruptGetUserEnable (lAxisNo : LongInt; lBank : LongInt; upInterruptNum : PDWord) : DWord; stdcall;

//======== 모션 파라메타 설정 ===========================================================================================================================================================
// AxmMotLoadParaAll로 파일을 Load 시키지 않으면 초기 파라메타 설정시 기본 파라메타 설정. 
// 현재 PC에 사용되는 모든축에 똑같이 적용된다. 기본파라메타는 아래와 같다. 
// 00:AXIS_NO.             =0       01:PULSE_OUT_METHOD.    =4      02:ENC_INPUT_METHOD.    =3     03:INPOSITION.          =2
// 04:ALARM.               =0       05:NEG_END_LIMIT.       =0      06:POS_END_LIMIT.       =0     07:MIN_VELOCITY.        =1
// 08:MAX_VELOCITY.        =700000  09:HOME_SIGNAL.         =4      10:HOME_LEVEL.          =1     11:HOME_DIR.            =-1
// 12:ZPHASE_LEVEL.        =1       13:ZPHASE_USE.          =0      14:STOP_SIGNAL_MODE.    =0     15:STOP_SIGNAL_LEVEL.   =0
// 16:HOME_FIRST_VELOCITY. =10000   17:HOME_SECOND_VELOCITY.=10000  18:HOME_THIRD_VELOCITY. =2000  19:HOME_LAST_VELOCITY.  =100
// 20:HOME_FIRST_ACCEL.    =40000   21:HOME_SECOND_ACCEL.   =40000  22:HOME_END_CLEAR_TIME. =1000  23:HOME_END_OFFSET.     =0
// 24:NEG_SOFT_LIMIT.      =0.000   25:POS_SOFT_LIMIT.      =0      26:MOVE_PULSE.          =1     27:MOVE_UNIT.           =1
// 28:INIT_POSITION.       =1000    29:INIT_VELOCITY.       =200    30:INIT_ACCEL.          =400   31:INIT_DECEL.          =400
// 32:INIT_ABSRELMODE.     =0       33:INIT_PROFILEMODE.    =4

// 00=[AXIS_NO             ]: 축 (0축 부터 시작함)
// 01=[PULSE_OUT_METHOD    ]: Pulse out method TwocwccwHigh = 6
// 02=[ENC_INPUT_METHOD    ]: disable = 0   1체배 = 1  2체배 = 2  4체배 = 3, 결선 관련방향 교체시(-).1체배 = 11  2체배 = 12  4체배 = 13
// 03=[INPOSITION          ], 04=[ALARM     ], 05,06 =[END_LIMIT   ]  : 0 = A접점 1= B접점 2 = 사용안함. 3 = 기존상태 유지
// 07=[MIN_VELOCITY        ]: 시작 속도(START VELOCITY)
// 08=[MAX_VELOCITY        ]: 드라이버가 지령을 받아들일수 있는 지령 속도. 보통 일반 Servo는 700k
// Ex> screw : 20mm pitch drive: 10000 pulse 모터: 400w
// 09=[HOME_SIGNAL         ]: 4 - Home in0 , 0 :PosEndLimit , 1 : NegEndLimit // _HOME_SIGNAL참조.
// 10=[HOME_LEVEL          ]: 0 = A접점 1= B접점 2 = 사용안함. 3 = 기존상태 유지
// 11=[HOME_DIR            ]: 홈 방향(HOME DIRECTION) 1:+방향, 0:-방향
// 12=[ZPHASE_LEVEL        ]: 0 = A접점 1= B접점 2 = 사용안함. 3 = 기존상태 유지
// 13=[ZPHASE_USE          ]: Z상사용여부. 0: 사용안함 , 1: -방향, 2: +방향 
// 14=[STOP_SIGNAL_MODE    ]: ESTOP, SSTOP 사용시 0:감속정지, 1:급정지 
// 15=[STOP_SIGNAL_LEVEL   ]: ESTOP, SSTOP 사용 레벨.  0 = A접점 1= B접점 2 = 사용안함. 3 = 기존상태 유지 
// 16=[HOME_FIRST_VELOCITY ]: 1차구동속도 
// 17=[HOME_SECOND_VELOCITY]: 검출후속도 
// 18=[HOME_THIRD_VELOCITY ]: 마지막 속도 
// 19=[HOME_LAST_VELOCITY  ]: index검색및 정밀하게 검색하기위한 속도. 
// 20=[HOME_FIRST_ACCEL    ]: 1차 가속도 , 21=[HOME_SECOND_ACCEL   ] : 2차 가속도 
// 22=[HOME_END_CLEAR_TIME ]: 원점 검색 Enc 값 Set하기 위한 대기시간,  23=[HOME_END_OFFSET] : 원점검출후 Offset만큼 이동.
// 24=[NEG_SOFT_LIMIT      ]: - SoftWare Limit 같게 설정하면 사용안함, 25=[POS_SOFT_LIMIT ]: + SoftWare Limit 같게 설정하면 사용안함.
// 26=[MOVE_PULSE          ]: 드라이버의 1회전당 펄스량              , 27=[MOVE_UNIT  ]: 드라이버 1회전당 이동량 즉:스크류 Pitch
// 28=[INIT_POSITION       ]: 에이젼트 사용시 초기위치  , 사용자가 임의로 사용가능
// 29=[INIT_VELOCITY       ]: 에이젼트 사용시 초기속도  , 사용자가 임의로 사용가능
// 30=[INIT_ACCEL          ]: 에이젼트 사용시 초기가속도, 사용자가 임의로 사용가능
// 31=[INIT_DECEL          ]: 에이젼트 사용시 초기감속도, 사용자가 임의로 사용가능
// 32=[INIT_ABSRELMODE     ]: 에이젼트 사용시 절대(0)/상대(1) 위치 설정
// 33=[INIT_PROFILEMODE    ]: 에이젼트 사용시 프로파일모드(0 - 4) 까지 설정
//                            '0': 대칭 Trapezode, '1': 비대칭 Trapezode, '2': 대칭 Quasi-S Curve, '3':대칭 S Curve, '4':비대칭 S Curve    

// AxmMotSaveParaAll로 저장 되어진 .mot파일을 불러온다. 해당 파일은 사용자가 Edit 하여 사용 가능하다.
function AxmMotLoadParaAll (szFilePath : PChar) : DWord; stdcall;
// 모든축에 대한 모든 파라메타를 축별로 저장한다. .mot파일로 저장한다.
function AxmMotSaveParaAll (szFilePath : PChar) : DWord; stdcall;

// 파라메타 28 - 31번까지 사용자가 프로그램내에서  이 함수를 이용해 설정 한다
function AxmMotSetParaLoad (lAxisNo : LongInt; dInitPos : Double; dInitVel : Double; dInitAccel : Double; dInitDecel : Double) : DWord; stdcall;
// 파라메타 28 - 31번까지 사용자가 프로그램내에서  이 함수를 이용해 확인 한다.
function AxmMotGetParaLoad (lAxisNo : LongInt; dpInitPos : PDouble; dpInitVel : PDouble; dpInitAccel : PDouble; dpInitDecel : PDouble) : DWord; stdcall;

// 지정 축의 펄스 출력 방식을 설정한다.
//uMethod  0 :OneHighLowHigh, 1 :OneHighHighLow, 2 :OneLowLowHigh, 3 :OneLowHighLow, 4 :TwoCcwCwHigh
//         5 :TwoCcwCwLow, 6 :TwoCwCcwHigh, 7 :TwoCwCcwLow, 8 :TwoPhase, 9 :TwoPhaseReverse
//    OneHighLowHigh                = 0x0,            // 1펄스 방식, PULSE(Active High), 정방향(DIR=Low)  / 역방향(DIR=High)
//    OneHighHighLow                = 0x1,            // 1펄스 방식, PULSE(Active High), 정방향(DIR=High) / 역방향(DIR=Low)
//    OneLowLowHigh                  = 0x2,            // 1펄스 방식, PULSE(Active Low),  정방향(DIR=Low)  / 역방향(DIR=High)
//    OneLowHighLow                  = 0x3,            // 1펄스 방식, PULSE(Active Low),  정방향(DIR=High) / 역방향(DIR=Low)
//    TwoCcwCwHigh                  = 0x4,            // 2펄스 방식, PULSE(CCW:역방향),  DIR(CW:정방향),  Active High
//    TwoCcwCwLow                      = 0x5,            // 2펄스 방식, PULSE(CCW:역방향),  DIR(CW:정방향),  Active Low
//    TwoCwCcwHigh                  = 0x6,            // 2펄스 방식, PULSE(CW:정방향),   DIR(CCW:역방향), Active High
//    TwoCwCcwLow                      = 0x7,            // 2펄스 방식, PULSE(CW:정방향),   DIR(CCW:역방향), Active Low
//    TwoPhase                        = 0x8,            // 2상(90' 위상차),  PULSE lead DIR(CW: 정방향), PULSE lag DIR(CCW:역방향)
//    TwoPhaseReverse                = 0x9              // 2상(90' 위상차),  PULSE lead DIR(CCW: 정방향), PULSE lag DIR(CW:역방향)
function AxmMotSetPulseOutMethod (lAxisNo : LongInt; uMethod : DWord) : DWord; stdcall;
// 지정 축의 펄스 출력 방식 설정을 반환한다,
function AxmMotGetPulseOutMethod (lAxisNo : LongInt; upMethod : PDWord) : DWord; stdcall;

// 지정 축의 외부(Actual) 카운트의 증가 방향 설정을 포함하여 지정 축의 Encoder 입력 방식을 설정한다.
// uMethod : 0 - 7 설정.
// ObverseUpDownMode            = 0x0,            // 정방향 Up/Down
// ObverseSqr1Mode                = 0x1,            // 정방향 1체배
// ObverseSqr2Mode                = 0x2,            // 정방향 2체배
// ObverseSqr4Mode              = 0x3,            // 정방향 4체배
// ReverseUpDownMode            = 0x4,            // 역방향 Up/Down
// ReverseSqr1Mode                 = 0x5,            // 역방향 1체배
// ReverseSqr2Mode                 = 0x6,            // 역방향 2체배
// ReverseSqr4Mode                 = 0x7              // 역방향 4체배
function AxmMotSetEncInputMethod (lAxisNo : LongInt; uMethod : DWord) : DWord; stdcall;
// 지정 축의 외부(Actual) 카운트의 증가 방향 설정을 포함하여 지정 축의 Encoder 입력 방식을 반환한다.
function AxmMotGetEncInputMethod (lAxisNo : LongInt; upMethod : PDWord) : DWord; stdcall;

// 설정 속도 단위가 RPM(Revolution Per Minute)으로 맞추고 싶다면.
// ex>    rpm 계산:
// 4500 rpm ?
// unit/ pulse = 1 : 1이면      pulse/ sec 초당 펄스수가 되는데
// 4500 rpm에 맞추고 싶다면     4500 / 60 초 : 75회전/ 1초
// 모터가 1회전에 몇 펄스인지 알아야 된다. 이것은 Encoder에 Z상을 검색해보면 알수있다.
// 1회전:1800 펄스라면 75 x 1800 = 135000 펄스가 필요하게 된다.
// AxmMotSetMoveUnitPerPulse에 Unit = 1, Pulse = 1800 넣어 동작시킨다.
// 주의할점 : rpm으로 제어하게 된다면 속도와 가속도 도 rpm단위로 바뀌게 된다.

// 지정 축의 펄스 당 움직이는 거리를 설정한다.
function AxmMotSetMoveUnitPerPulse (lAxisNo : LongInt; dUnit : Double; lPulse : LongInt) : DWord; stdcall;
// 지정 축의 펄스 당 움직이는 거리를 반환한다.
function AxmMotGetMoveUnitPerPulse (lAxisNo : LongInt; dpUnit : PDouble; lpPulse : PLongInt) : DWord; stdcall;    

// 지정 축에 감속 시작 포인트 검출 방식을 설정한다.
//uMethod : 0 -1 설정
// AutoDetect = 0x0 : 자동 가감속.
// RestPulse  = 0x1 : 수동 가감속.

function AxmMotSetDecelMode (lAxisNo : LongInt; uMethod : DWord) : DWord; stdcall;
// 지정 축의 감속 시작 포인트 검출 방식을 반환한다
function AxmMotGetDecelMode (lAxisNo : LongInt; upMethod : PDWord) : DWord; stdcall;    

// 지정 축에 수동 감속 모드에서 잔량 펄스를 설정한다.
function AxmMotSetRemainPulse (lAxisNo : LongInt; uData : DWord) : DWord; stdcall;
// 지정 축의 수동 감속 모드에서 잔량 펄스를 반환한다.
function AxmMotGetRemainPulse (lAxisNo : LongInt; upData : PDWord) : DWord; stdcall;

// 지정 축에 등속도 구동 함수에서의 최고 속도를 설정한다.
function AxmMotSetMaxVel (lAxisNo : LongInt; dVel : Double) : DWord; stdcall;
// 지정 축의 등속도 구동 함수에서의 최고 속도를 반환한다.
function AxmMotGetMaxVel (lAxisNo : LongInt; dpVel : PDouble) : DWord; stdcall;

// 지정 축의 이동 거리 계산 모드를 설정한다.
//uAbsRelMode : POS_ABS_MODE '0' - 절대 좌표계
//              POS_REL_MODE '1' - 상대 좌표계
function AxmMotSetAbsRelMode (lAxisNo : LongInt; uAbsRelMode : DWord) : DWord; stdcall;
// 지정 축의 설정된 이동 거리 계산 모드를 반환한다
function AxmMotGetAbsRelMode (lAxisNo : LongInt; upAbsRelMode : PDWord) : DWord; stdcall;

//지정 축의 구동 속도 프로파일 모드를 설정한다.
//ProfileMode : SYM_TRAPEZOIDE_MODE    '0' - 대칭 Trapezode
//              ASYM_TRAPEZOIDE_MODE   '1' - 비대칭 Trapezode
//              QUASI_S_CURVE_MODE     '2' - 대칭 Quasi-S Curve
//              SYM_S_CURVE_MODE       '3' - 대칭 S Curve
//              ASYM_S_CURVE_MODE      '4' - 비대칭 S Curve
function AxmMotSetProfileMode (lAxisNo : LongInt; uProfileMode : DWord) : DWord; stdcall;
// 지정 축의 설정한 구동 속도 프로파일 모드를 반환한다.
function AxmMotGetProfileMode (lAxisNo : LongInt; upProfileMode : PDWord) : DWord; stdcall;    

//지정 축의 가속도 단위를 설정한다.
//AccelUnit : UNIT_SEC2   '0' - 가감속 단위를 unit/sec2 사용
//            SEC         '1' - 가감속 단위를 sec 사용
function AxmMotSetAccelUnit (lAxisNo : LongInt; uAccelUnit : DWord) : DWord; stdcall;
// 지정 축의 설정된 가속도단위를 반환한다.
function AxmMotGetAccelUnit (lAxisNo : LongInt; upAccelUnit : PDWord) : DWord; stdcall;

// 지정 축에 초기 속도를 설정한다.
function AxmMotSetMinVel (lAxisNo : LongInt; dMinVel : Double) : DWord; stdcall;
// 지정 축의 초기 속도를 반환한다.
function AxmMotGetMinVel (lAxisNo : LongInt; dpMinVel : PDouble) : DWord; stdcall;
// 지정 축의 가속 저크값을 설정한다.[%].
function AxmMotSetAccelJerk (lAxisNo : LongInt; dAccelJerk : Double) : DWord; stdcall;
// 지정 축의 설정된 가속 저크값을 반환한다.
function AxmMotGetAccelJerk (lAxisNo : LongInt; dpAccelJerk : PDouble) : DWord; stdcall;
// 지정 축의 감속 저크값을 설정한다.[%].
function AxmMotSetDecelJerk (lAxisNo : LongInt; dDecelJerk : Double) : DWord; stdcall;
// 지정 축의 설정된 감속 저크값을 반환한다.
function AxmMotGetDecelJerk (lAxisNo : LongInt; dpDecelJerk : PDouble) : DWord; stdcall;    

// 지정 축의 속도 Profile결정시 우선순위(속도 Or 가속도)를 설정한다.
// Priority : PRIORITY_VELOCITY   '0' - 속도 Profile결정시 지정한 속도값에 가깝도록 계산함(일반장비 및 Spinner에 사용).
//            PRIORITY_ACCELTIME  '1' - 속도 Profile결정시 지정한 가감속시간에 가깝도록 계산함(고속 장비에 사용).
function AxmMotSetProfilePriority(lAxisNo : LongInt; uPriority : DWord) : DWord; stdcall;
// 지정 축의 속도 Profile결정시 우선순위(속도 Or 가속도)를 반환한다.
function AxmMotGetProfilePriority(lAxisNo : LongInt; upPriority : PDWord) : DWord; stdcall;

//=========== 입출력 신호 관련 설정함수 ================================================================================

// 지정 축의 Z 상 Level을 설정한다.
// uLevel : LOW(0), HIGH(1)
function AxmSignalSetZphaseLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// 지정 축의 Z 상 Level을 반환한다.
function AxmSignalGetZphaseLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;

// 지정 축의 Servo-On신호의 출력 레벨을 설정한다.
// uLevel : LOW(0), HIGH(1)
function AxmSignalSetServoOnLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// 지정 축의 Servo-On신호의 출력 레벨 설정을 반환한다.
function AxmSignalGetServoOnLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;

// 지정 축의 Servo-Alarm Reset 신호의 출력 레벨을 설정한다.
// uLevel : LOW(0), HIGH(1)
function AxmSignalSetServoAlarmResetLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// 지정 축의 Servo-Alarm Reset 신호의 출력 레벨을 설정을 반환한다.
function AxmSignalGetServoAlarmResetLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;

//    지정 축의 Inpositon 신호 사용 여부 및 신호 입력 레벨을 설정한다
// uLevel : LOW(0), HIGH(1), UNUSED(2), USED(3)
function AxmSignalSetInpos (lAxisNo : LongInt; uUse : DWord) : DWord; stdcall;
// 지정 축의 Inpositon 신호 사용 여부 및 신호 입력 레벨을 반환한다.
function AxmSignalGetInpos (lAxisNo : LongInt; upUse : PDWord) : DWord; stdcall;
// 지정 축의 Inpositon 신호 입력 상태를 반환한다.
function AxmSignalReadInpos (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;

//    지정 축의 알람 신호 입력 시 비상 정지의 사용 여부 및 신호 입력 레벨을 설정한다.
// uLevel : LOW(0), HIGH(1), UNUSED(2), USED(3)
function AxmSignalSetServoAlarm (lAxisNo : LongInt; uUse : DWord) : DWord; stdcall;
// 지정 축의 알람 신호 입력 시 비상 정지의 사용 여부 및 신호 입력 레벨을 반환한다.
function AxmSignalGetServoAlarm (lAxisNo : LongInt; upUse : PDWord) : DWord; stdcall;
// 지정 축의 알람 신호의 입력 레벨을 반환한다.
function AxmSignalReadServoAlarm (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;

//    지정 축의 end limit sensor의 사용 유무 및 신호의 입력 레벨을 설정한다. 
//  end limit sensor 신호 입력 시 감속정지 또는 급정지에 대한 설정도 가능하다.
//정지 모드 => 급정지, 감속정지
// uStopMode: EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// uPositiveLevel, uNegativeLevel : LOW(0), HIGH(1), UNUSED(2), USED(3)
function AxmSignalSetLimit (lAxisNo : LongInt; uStopMode : DWord; uPositiveLevel : DWord; uNegativeLevel : DWord) : DWord; stdcall;
// 지정 축의 end limit sensor의 사용 유무 및 신호의 입력 레벨, 신호 입력 시 정지모드를 반환한다
function AxmSignalGetLimit (lAxisNo : LongInt; upStopMode : PDWord; upPositiveLevel : PDWord; upNegativeLevel : PDWord) : DWord; stdcall;
// 지정축의 end limit sensor의 입력 상태를 반환한다.
function AxmSignalReadLimit (lAxisNo : LongInt; upPositiveStatus : PDWord; upNegativeStatus : PDWord) : DWord; stdcall;

// 지정 축의 Software limit의 사용 유무, 사용할 카운트, 그리고 정지 방법을 설정한다
// uUse       : DISABLE(0), ENABLE(1)
// uStopMode  : EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// uSelection : COMMAND(0), ACTUAL(1)
function AxmSignalSetSoftLimit (lAxisNo : LongInt; uUse : DWord; uStopMode : DWord; uSelection : DWord; dPositivePos : Double; dNegativePos : Double) : DWord; stdcall;
// 지정 축의 Software limit의 사용 유무, 사용할 카운트, 그리고 정지 방법을 반환한다
function AxmSignalGetSoftLimit (lAxisNo : LongInt; upUse : PDWord; upStopMode : PDWord; upSelection : PDWord; dpPositivePos : PDouble; dpNegativePos : PDouble) : DWord; stdcall;

// 비상 정지 신호의 정지 방법 (급정지/감속정지) 또는 사용 유무를 설정한다.
// uStopMode  : EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// uLevel : LOW(0), HIGH(1), UNUSED(2), USED(3)
function AxmSignalSetStop (lAxisNo : LongInt; uStopMode : DWord; uLevel : DWord) : DWord; stdcall;
// 비상 정지 신호의 정지 방법 (급정지/감속정지) 또는 사용 유무를 반환한다.
function AxmSignalGetStop (lAxisNo : LongInt; upStopMode : PDWord; upLevel : PDWord) : DWord; stdcall;
// 비상 정지 신호의 입력 상태를 반환한다.
function AxmSignalReadStop (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;

// 지정 축의 Servo-On 신호를 출력한다.
// uOnOff : FALSE(0), TRUE(1) ( 범용 0출력에 해당됨)
function AxmSignalServoOn (lAxisNo : LongInt; uOnOff : DWord) : DWord; stdcall;
// 지정 축의 Servo-On 신호의 출력 상태를 반환한다.
function AxmSignalIsServoOn (lAxisNo : LongInt; upOnOff : PDWord) : DWord; stdcall;

// 지정 축의 Servo-Alarm Reset 신호를 출력한다.
// uOnOff : FALSE(0), TRUE(1) ( 범용 1출력에 해당됨)
function AxmSignalServoAlarmReset (lAxisNo : LongInt; uOnOff : DWord) : DWord; stdcall;    

//    범용 출력값을 설정한다.
//  uValue : Hex Value 0x00
function AxmSignalWriteOutput (lAxisNo : LongInt; uValue : DWord) : DWord; stdcall;
// 범용 출력값을 반환한다.
function AxmSignalReadOutput (lAxisNo : LongInt; upValue : PDWord) : DWord; stdcall;

// lBitNo : Bit Number(0 - 4)
// uOnOff : FALSE(0), TRUE(1)
// 범용 출력값을 비트별로 설정한다.
function AxmSignalWriteOutputBit (lAxisNo : LongInt; lBitNo : LongInt; uOnOff : DWord) : DWord; stdcall;
// 범용 출력값을 비트별로 반환한다.
function AxmSignalReadOutputBit (lAxisNo : LongInt; lBitNo : LongInt; upOnOff : PDWord) : DWord; stdcall;


// 범용 입력값을 Hex값으로 반환한다.
function AxmSignalReadInput (lAxisNo : LongInt; upValue : PDWord) : DWord; stdcall;

// lBitNo : Bit Number(0 - 4)
// 범용 입력값을 비트별로 반환한다.
function AxmSignalReadInputBit (lAxisNo : LongInt; lBitNo : LongInt; upOn : PDWord) : DWord; stdcall;

//========== 모션 구동중 및 구동후에 상태 확인하는 함수============================================================

// 지정 축의 펄스 출력 상태를 반환한다.
function AxmStatusReadInMotion (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;

//  구동시작 이후 지정 축의 구동 펄스 카운터 값을 반환한다.
function AxmStatusReadDrivePulseCount (lAxisNo : LongInt; lpPulse : PLongInt) : DWord; stdcall;    

// 지정 축의 DriveStatus(모션중 상태) 레지스터를 반환한다
// 주의사항 : 각 제품별로 하드웨어적인 신호가 다르기때문에 매뉴얼 및 AXHS.xxx 파일을 참고해야한다.
function AxmStatusReadMotion (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;    

// 지정 축의 EndStatus(정지 상태) 레지스터를 반환한다.
// 주의사항 : 각 제품별로 하드웨어적인 신호가 다르기때문에 매뉴얼 및 AXHS.xxx 파일을 참고해야한다.
function AxmStatusReadStop (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;    

// 지정 축의 Mechanical Signal Data(현재 기계적인 신호상태) 를 반환한다.
// 주의사항 : 각 제품별로 하드웨어적인 신호가 다르기때문에 매뉴얼 및 AXHS.xxx 파일을 참고해야한다.
function AxmStatusReadMechanical (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;    

// 지정 축의 현재 구동 속도를 읽어온다.
function AxmStatusReadVel (lAxisNo : LongInt; dpVel : PDouble) : DWord; stdcall;    

// 지정 축의 Command Pos과 Actual Pos의 차를 반환한다.
function AxmStatusReadPosError (lAxisNo : LongInt; dpError : PDouble) : DWord; stdcall;    

// 최종 드라이브로 이동하는(이동한) 거리를 확인 한다
function AxmStatusReadDriveDistance (lAxisNo : LongInt; dpUnit : PDouble) : DWord; stdcall;

// 지정 축의 Actual 위치를 설정한다.
function AxmStatusSetActPos (lAxisNo : LongInt; dPos : Double) : DWord; stdcall;
// 지정 축의 Actual 위치를 반환한다.
function AxmStatusGetActPos (lAxisNo : LongInt; dpPos : PDouble) : DWord; stdcall;

// 지정 축의 Command 위치를 설정한다.
function AxmStatusSetCmdPos (lAxisNo : LongInt; dPos : Double) : DWord; stdcall;
// 지정 축의 Command 위치를 반환한다.
function AxmStatusGetCmdPos (lAxisNo : LongInt; dpPos : PDouble) : DWord; stdcall;

//======== 홈관련 함수=================================================================================================

// 지정 축의 Home 센서 Level 을 설정한다.
// uLevel : LOW(0), HIGH(1)
function AxmHomeSetSignalLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// 지정 축의 Home 센서 Level 을 반환한다.
function AxmHomeGetSignalLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;

// 현재 홈 신호 입력상태를 확인한다. 홈신호는 사용자가 임의로 AxmHomeSetMethod 함수를 이용하여 설정할수있다.
// upStatus : OFF(0), ON(1)
function AxmHomeReadSignal (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;

// 해당 축의 원점검색을 수행하기 위해서는 반드시 원점 검색관련 파라메타들이 설정되어 있어야 됩니다. 
// 만약 MotionPara설정 파일을 이용해 초기화가 정상적으로 수행됐다면 별도의 설정은 필요하지 않다. 
// 원점검색 방법 설정에는 검색 진행방향, 원점으로 사용할 신호, 원점센서 Active Level, 엔코더 Z상 검출 여부 등을 설정 한다.
// (자세한 내용은 AxmMotSaveParaAll 설명 부분 참조)
// 홈레벨은 AxmSignalSetHomeLevel 사용한다.
// HClrTim : HomeClear Time : 원점 검색 Encoder 값 Set하기 위한 대기시간 
// HmDir(홈 방향): DIR_CCW (0) -방향 , DIR_CW(1) +방향
// HOffset - 원점검출후 이동거리.
// uZphas: 1차 원점검색 완료 후 엔코더 Z상 검출 유무 설정  0: 사용안함 , 1: +방향, 2: -방향 
// HmSig : PosEndLimit(0) -> +Limit
//         NegEndLimit(1) -> -Limit
//         HomeSensor (4) -> 원점센서(범용 입력 0)

function AxmHomeSetMethod (lAxisNo : LongInt; lHmDir : LongInt; uHomeSignal : DWord; uZphas : DWord; dHomeClrTime : Double; dHomeOffset : Double) : DWord; stdcall;
// 설정되어있는 홈 관련 파라메타들을 반환한다.
function AxmHomeGetMethod (lAxisNo : LongInt; lpHmDir : PLongInt; upHomeSignal : PDWord; upZphas : PDWord; dpHomeClrTime : PDouble; dpHomeOffset : PDouble) : DWord; stdcall;


// 원점을 빠르고 정밀하게 검색하기 위해 여러 단계의 스탭으로 검출한다. 이때 각 스탭에 사용 될 속도를 설정한다. 
// 이 속도들의 설정값에 따라 원점검색 시간과, 원점검색 정밀도가 결정된다. 
// 각 스탭별 속도들을 적절히 바꿔가면서 각 축의 원점검색 속도를 설정하면 된다. 
// (자세한 내용은 AxmMotSaveParaAll 설명 부분 참조)
// 원점검색시 사용될 속도를 설정하는 함수
// [dVelFirst]- 1차구동속도   [dVelSecond]-검출후속도   [dVelThird]- 마지막 속도  [dvelLast]- index검색및 정밀하게 검색하기위해. 
// [dAccFirst]- 1차구동가속도 [dAccSecond]-검출후가속도 
function AxmHomeSetVel (lAxisNo : LongInt; dVelFirst : Double; dVelSecond : Double; dVelThird : Double; dVelLast : Double; dAccFirst : Double; dAccSecond : Double) : DWord; stdcall;
// 설정되어있는 원점검색시 사용될 속도를 반환한다.
function AxmHomeGetVel (lAxisNo : LongInt; dpVelFirst : PDouble; dpVelSecond : PDouble; dpVelThird : PDouble; dpVelLast : PDouble; dpAccFirst : PDouble; dpAccSecond : PDouble) : DWord; stdcall;

// 원점검색을 시작한다.
// 원점검색 시작함수를 실행하면 라이브러리 내부에서 해당축의 원점검색을 수행 할 쓰레드가 자동 생성되어 원점검색을 순차적으로 수행한 후 자동 종료된다.
function AxmHomeSetStart (lAxisNo : LongInt) : DWord; stdcall;
// 원점검색 결과를 사용자가 임의로 설정한다.
// 원점검색 함수를 이용해 성공적으로 원점검색이 수행되고나면 검색 결과가 HOME_SUCCESS로 설정됩니다.
// 이 함수는 사용자가 원점검색을 수행하지않고 결과를 임의로 설정할 수 있다. 
// uHomeResult 설정
// HOME_SUCCESS                    = 0x01         // 홈 완료
// HOME_SEARCHING                = 0x02         // 홈검색중
// HOME_ERR_GNT_RANGE          = 0x10         // 홈 검색 범위를 벗어났을경우
// HOME_ERR_USER_BREAK        = 0x11         // 속도 유저가 임의로 정지명령을 내렸을경우
// HOME_ERR_VELOCITY          = 0x12         // 속도 설정 잘못했을경우
// HOME_ERR_AMP_FAULT          = 0x13         // 서보팩 알람 발생 에러
// HOME_ERR_NEG_LIMIT          = 0x14         // (-)방향 구동중 (+)리미트 센서 감지 에러
// HOME_ERR_POS_LIMIT          = 0x15         // (+)방향 구동중 (-)리미트 센서 감지 에러
// HOME_ERR_NOT_DETECT        = 0x16         // 지정한 신호 검출하지 못 할 경우 에러
// HOME_ERR_UNKNOWN              = 0xFF
function AxmHomeSetResult (lAxisNo : LongInt; uHomeResult : DWord) : DWord; stdcall;
// 원점검색 결과를 반환한다.
// 원점검색 함수의 검색 결과를 확인한다. 원점검색이 시작되면 HOME_SEARCHING으로 설정되며 원점검색에 실패하면 실패원인이 설정된다. 실패 원인을 제거한 후 다시 원점검색을 진행하면 된다.
function AxmHomeGetResult (lAxisNo : LongInt; upHomeResult : PDWord) : DWord; stdcall;

// 원점검색 진행률을 반환한다.
// 원점검색 시작되면 진행율을 확인할 수 있다. 원점검색이 완료되면 성공여부와 관계없이 100을 반환하게 된다. 원점검색 성공여부는 GetHome Result함수를 이용해 확인할 수 있다.
// upHomeMainStepNumber : Main Step 진행율이다.
// 겐트리 FALSE일 경우upHomeMainStepNumber : 0 일때면 선택한 축만 진행사항이고 홈 진행율은 upHomeStepNumber 표시한다.
// 겐트리 TRUE일 경우 upHomeMainStepNumber : 0 일때면 마스터 홈을 진행사항이고 마스터 홈 진행율은 upHomeStepNumber 표시한다.
// 겐트리 TRUE일 경우 upHomeMainStepNumber : 10 일때면 슬레이브 홈을 진행사항이고 마스터 홈 진행율은 upHomeStepNumber 표시한다.
// upHomeStepNumber     : 선택한 축에대한 진행율을 표시한다.
// 겐트리 FALSE일 경우  : 선택한 축만 진행율을 표시한다.
// 겐트리 TRUE일 경우 마스터축, 슬레이브축 순서로 진행율을 표시된다.
function AxmHomeGetRate (lAxisNo : LongInt; upHomeMainStepNumber : PDWord; upHomeStepNumber : PDWord) : DWord; stdcall;

//========= 위치 구동함수 ===============================================================================================================

// 설정 속도 단위가 RPM(Revolution Per Minute)으로 맞추고 싶다면.
// ex>    rpm 계산:
// 4500 rpm ?
// unit/ pulse = 1 : 1이면      pulse/ sec 초당 펄스수가 되는데
// 4500 rpm에 맞추고 싶다면     4500 / 60 초 : 75회전/ 1초
// 모터가 1회전에 몇 펄스인지 알아야 된다. 이것은 Encoder에 Z상을 검색해보면 알수있다.
// 1회전:1800 펄스라면 75 x 1800 = 135000 펄스가 필요하게 된다.
// AxmMotSetMoveUnitPerPulse에 Unit = 1, Pulse = 1800 넣어 동작시킨다.

// 설정한 거리만큼 또는 위치까지 이동한다.
// 지정 축의 절대 좌표/ 상대좌표 로 설정된 위치까지 설정된 속도와 가속율로 구동을 한다.
// 속도 프로파일은 AxmMotSetProfileMode 함수에서 설정한다.
// 펄스가 출력되는 시점에서 함수를 벗어난다.
function AxmMoveStartPos (lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// 설정한 거리만큼 또는 위치까지 이동한다.
// 지정 축의 절대 좌표/상대좌표로 설정된 위치까지 설정된 속도와 가속율로 구동을 한다.
// 속도 프로파일은 AxmMotSetProfileMode 함수에서 설정한다.
// 펄스 출력이 종료되는 시점에서 함수를 벗어난다
function AxmMovePos (lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// 설정한 속도로 구동한다.
// 지정 축에 대하여 설정된 속도와 가속율로 지속적으로 속도 모드 구동을 한다.
// 펄스 출력이 시작되는 시점에서 함수를 벗어난다.
// Vel값이 양수이면 CW, 음수이면 CCW 방향으로 구동.
function AxmMoveVel (lAxisNo : LongInt; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// 지정된 다축에 대하여 설정된 속도와 가속율로 지속적으로 속도 모드 구동을 한다.
// 펄스 출력이 시작되는 시점에서 함수를 벗어난다.
// PCI-Nx04 제품만 함수사용가능.
// SMC-2V03 module 경우 2축만 사용가능.
// Vel값이 양수이면 CW, 음수이면 CCW 방향으로 구동.
function AxmMoveStartMultiVel (lArraySize : LongInt; lpAxesNo : PLongInt; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble) : DWord; stdcall;

// 특정 Input 신호의 Edge를 검출하여 즉정지 또는 감속정지하는 함수.
// lDetect Signal : edge 검출할 입력 신호 선택.
// lDetectSignal  : PosEndLimit(0), NegEndLimit(1), HomeSensor(4), EncodZPhase(5), UniInput02(6), UniInput03(7)
// Signal Edge    : 선택한 입력 신호의 edge 방향 선택 (rising or falling edge).
//                  SIGNAL_DOWN_EDGE(0), SIGNAL_UP_EDGE(1)
// 구동방향       : Vel값이 양수이면 CW, 음수이면 CCW.
// SignalMethod   : 급정지 EMERGENCY_STOP(0), 감속정지 SLOWDOWN_STOP(1)
// 주의사항: SignalMethod를 EMERGENCY_STOP(0)로 사용할경우 가감속이 무시되며 지정된 속도로 가속 급정지하게된다.
//           PCI-Nx04를 사용할 경우 lDetectSignal이 PosEndLimit , NegEndLimit(0,1) 을 찾을경우 신호의레벨 Active 상태를 검출하게된다.
function AxmMoveSignalSearch (lAxisNo : LongInt; dVel : Double; dAccel : Double; lDetectSignal : LongInt; lSignalEdge : LongInt; lSignalMethod : LongInt) : DWord; stdcall;    

// 지정 축에서 설정된 신호를 검출하고 그 위치를 저장하기 위해 이동하는 함수이다.
// 원하는 신호를 골라 찾아 움직이는 함수 찾을 경우 그 위치를 저장시켜놓고 AxmGetCapturePos사용하여 그값을 읽는다.
// Signal Edge   : 선택한 입력 신호의 edge 방향 선택 (rising or falling edge).
//                 SIGNAL_DOWN_EDGE(0), SIGNAL_UP_EDGE(1)
// 구동방향      : Vel값이 양수이면 CW, 음수이면 CCW.
// SignalMethod  : 급정지 EMERGENCY_STOP(0), 감속정지 SLOWDOWN_STOP(1)
// lDetect Signal: edge 검출할 입력 신호 선택.SIGNAL_DOWN_EDGE(0), SIGNAL_UP_EDGE(1)
// lDetectSignal : PosEndLimit(0), NegEndLimit(1), HomeSensor(4), EncodZPhase(5), UniInput02(6), UniInput03(7)
// lTarget       : COMMAND(0), ACTUAL(1)
// 주의사항: SignalMethod를 EMERGENCY_STOP(0)로 사용할경우 가감속이 무시되며 지정된 속도로 가속 급정지하게된다.
//           PCI-Nx04를 사용할 경우 lDetectSignal이 PosEndLimit , NegEndLimit(0,1) 을 찾을경우 신호의레벨 Active 상태를 검출하게된다.
//           SMC-2V03모듈 IP의 경우 한축만 동작 가능하며 한축 이상 구동할경우 위치가 저장이 안된다.
function AxmMoveSignalCapture (lAxisNo : LongInt; dVel : Double; dAccel : Double; lDetectSignal : LongInt; lSignalEdge : LongInt; lTarget : LongInt; lSignalMethod : LongInt) : DWord; stdcall;
// 'AxmMoveSignalCapture' 함수에서 저장된 위치값을 확인하는 함수이다.
// 주의사항: 함수 실행 결과가 "AXT_RT_SUCCESS"일때 저장된 위치가 유효하며, 이 함수를 한번 실행하면 저장 위치값이 초기화된다.
function AxmMoveGetCapturePos (lAxisNo : LongInt; dpCapPotition : PDouble) : DWord; stdcall;

// 설정한 거리만큼 또는 위치까지 이동하는 함수.
// 함수를 실행하면 해당 Motion 동작을 시작한 후 Motion 이 완료될때까지 기다리지 않고 바로 함수를 빠져나간다.
function AxmMoveStartMultiPos (lArraySize : LongInt; lpAxisNo : PLongInt; dpPos : PDouble; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble) : DWord; stdcall;    

// 다축을 설정한 거리만큼 또는 위치까지 이동한다.
// 지정 축들의 절대 좌표로 설정된 위치까지 설정된 속도와 가속율로 구동을 한다.
function AxmMoveMultiPos (lArraySize : LongInt; lpAxisNo : PLongInt; dpPos : PDouble; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble) : DWord; stdcall;

// 지정 축을 설정한 감속도로 감속 정지 한다.
// dDecel : 정지 시 감속율값
function AxmMoveStop (lAxisNo : LongInt; dDecel : Double) : DWord; stdcall;
// 지정 축을 급 정지 한다.
function AxmMoveEStop (lAxisNo : LongInt) : DWord; stdcall;
// 지정 축을 감속 정지한다.
function AxmMoveSStop (lAxisNo : LongInt) : DWord; stdcall;

//========= 오버라이드 함수 ============================================================================

// 위치 오버라이드 한다.
// 지정 축의 구동이 종료되기 전 지정된 출력 펄스 수를 조정한다.
// PCI-Nx04 사용시주의사항: 오버라이드할 위치를 넣을때는 구동 시점의 위치를 기준으로한 Relative 형태의 위치값으로 넣어준다.
//                          구동시작후 같은방향의 경우 오버라이드를 계속할수있지만 반대방향으로 오버라이드할경우에는 오버라이드를 계속할수없다.

function AxmOverridePos (lAxisNo : LongInt; dOverridePos : Double) : DWord; stdcall;

// 지정 축의 속도오버라이드 하기전에 오버라이드할 최고속도를 설정한다.
// 주의점 : 속도오버라이드를 5번한다면 그중에 최고 속도를 설정해야된다. 
function AxmOverrideSetMaxVel (lAxisNo : LongInt; dOverrideMaxVel : Double) : DWord; stdcall;    

// 속도 오버라이드 한다.
// 지정 축의 구동 중에 속도를 가변 설정한다. (반드시 모션 중에 가변 설정한다.)
// 주의점: AxmOverrideVel 함수를 사용하기전에. AxmOverrideMaxVel 최고로 설정할수있는 속도를 설정해놓는다.
// EX> 속도오버라이드를 두번한다면 
// 1. 두개중에 높은 속도를 AxmOverrideMaxVel 설정 최고 속도값 설정.
// 2. AxmMoveStartPos 실행 지정 축의 구동 중(Move함수 모두 포함)에 속도를 첫번째 속도로 AxmOverrideVel 가변 설정한다.
// 3. 지정 축의 구동 중(Move함수 모두 포함)에 속도를 두번째 속도로 AxmOverrideVel 가변 설정한다.
function AxmOverrideVel (lAxisNo : LongInt; dOverrideVel : Double) : DWord; stdcall;    

// SMC-2V03 module은 지원안함. PCI-Nx04 만 지원함.
// 가속도, 속도, 감속도를  오버라이드 한다.
// 지정 축의 구동 중에 가속도, 속도, 감속도를 가변 설정한다. (반드시 모션 중에 가변 설정한다.)
// 주의점: AxmOverrideAccelVelDecel 함수를 사용하기전에. AxmOverrideMaxVel 최고로 설정할수있는 속도를 설정해놓는다.
// EX> 속도오버라이드를 두번한다면 
// 1. 두개중에 높은 속도를 AxmOverrideMaxVel 설정 최고 속도값 설정.
// 2. AxmMoveStartPos 실행 지정 축의 구동 중(Move함수 모두 포함)에 가속도, 속도, 감속도를 첫번째 속도로 AxmOverrideAccelVelDecel 가변 설정한다.
// 3. 지정 축의 구동 중(Move함수 모두 포함)에 가속도, 속도, 감속도를 두번째 속도로 AxmOverrideAccelVelDecel 가변 설정한다.
function AxmOverrideAccelVelDecel (lAxisNo : LongInt; dOverrideVel : Double; dMaxAccel : Double; dMaxDecel : Double) : DWord; stdcall;    

// 어느 시점에서 속도 오버라이드 한다.
// 어느 위치 지점과 오버라이드할 속도를 입력시켜 그위치에서 속도오버라이드 되는 함수
// lTarget : COMMAND(0), ACTUAL(1)
// 주의점: AxmOverrideVelAtPos 함수를 사용하기전에. AxmOverrideMaxVel 최고로 설정할수있는 속도를 설정해놓는다.
function AxmOverrideVelAtPos (lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double; dOverridePos : Double; dOverrideVel : Double; lTarget : LongInt) : DWord; stdcall;    

function AxmOverrideVelAtMultiPos (lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double; lArraySize : LongInt; dpOverridePos : PDouble; dpOverrideVel : PDouble; lTarget : LongInt; uOverrideMode : DWord) : DWord; stdcall;    

//========= 마스터, 슬레이브  기어비로 구동 함수 ===========================================================================

// Electric Gear 모드에서 Master 축과 Slave 축과의 기어비를 설정한다.
// dSlaveRatio : 마스터축에 대한 슬레이브의 기어비( 0 : 0% , 0.5 : 50%, 1 : 100%)
function AxmLinkSetMode (lMasterAxisNo : LongInt; lSlaveAxisNo : LongInt; dSlaveRatio : Double) : DWord; stdcall;
// Electric Gear 모드에서 설정된 Master 축과 Slave 축과의 기어비를 반환한다.
function AxmLinkGetMode (lMasterAxisNo : LongInt; lpSlaveAxisNo : PLongInt; dpGearRatio : PDouble) : DWord; stdcall;
// Master 축과 Slave축간의 전자기어비를 설정 해제 한다.
function AxmLinkResetMode (lMasterAxisNo : LongInt) : DWord; stdcall;

//======== 겐트리 관련 함수===========================================================================================================================================================
// 모션모듈은 두 축이 기구적으로 Link되어있는 겐트리 구동시스템 제어를 지원한다. 
// 이 함수를 이용해 Master축을 겐트리 제어로 설정하면 해당 Slave축은 Master축과 동기되어 구동됩니다. 
// 만약 겐트리 설정 이후 Slave축에 구동명령이나 정지 명령등을 내려도 모두 무시됩니다.
// uSlHomeUse     : 슬레이축 홈사용 우뮤 ( 0 - 2)
//             (0 : 슬레이브축 홈을 사용안하고 마스터축을 홈을 찾는다.)
//             (1 : 마스터축 , 슬레이브축 홈을 찾는다. 슬레이브 dSlOffset 값 적용해서 보정함.)
//             (2 : 마스터축 , 슬레이브축 홈을 찾는다. 슬레이브 dSlOffset 값 적용해서 보정안함.)
// dSlOffset      : 슬레이브축 옵셋값
// dSlOffsetRange : 슬레이브축 옵셋값 레인지 설정
// PCI-Nx04 사용시주의사항: 갠트리 ENABLE시 슬레이브축은 모션중 AxmStatusReadMotion 함수로 확인하면 True(Motion 구동 중)로 확인되야 정상동작이다. 
//                   슬레이브축에 AxmStatusReadMotion로 확인했을때 InMotion 이 False이면 Gantry Enable이 안된것이므로 알람 혹은 리밋트 센서 등을 확인한다.

function AxmGantrySetEnable (lMasterAxisNo : LongInt; lSlaveAxisNo : LongInt; uSlHomeUse : DWord; dSlOffset : Double; dSlOffsetRange : Double) : DWord; stdcall;

// Slave축의 Offset값을 알아내는방법.
// A. 마스터, 슬레이브를 두개다 서보온을 시킨다.         
// B. AxmGantrySetEnable함수에서 uSlHomeUse = 2로 설정후 AxmHomeSetStart함수를 이용해서 홈을 찾는다. 
// C. 홈을 찾고 나면 마스터축의 Command값을 읽어보면 마스터축과 슬레이브축의 틀어진 Offset값을 볼수있다.
// D. Offset값을 읽어서 AxmGantrySetEnable함수의 dSlOffset인자에 넣어준다. 
// E. dSlOffset값을 넣어줄때 마스터축에 대한 슬레이브 축 값이기때문에 부호를 반대로 -dSlOffset 넣어준다.
// F. dSIOffsetRange 는 Slave Offset의 Range 범위를 말하는데 Range의 한계를 지정하여 한계를 벗어나면 에러를 발생시킬때 사용한다.        
// G. AxmGantrySetEnable함수에 Offset값을 넣어줬으면  AxmGantrySetEnable함수에서 uSlHomeUse = 1로 설정후 AxmHomeSetStart함수를 이용해서 홈을 찾는다.         

// 겐트리 구동에 있어 사용자가 설정한 파라메타를 반환한다.
function AxmGantryGetEnable (lMasterAxisNo : LongInt; upSlHomeUse : PDWord; dpSlOffset : PDouble; dpSlORange : PDouble; upGatryOn : PDWord) : DWord; stdcall;
// 모션 모듈은 두 축이 기구적으로 Link되어있는 겐트리 구동시스템 제어를 해제한다.
function AxmGantrySetDisable (lMasterAxisNo : LongInt; lSlaveAxisNo : LongInt) : DWord; stdcall;

//====일반 보간함수 ============================================================================================================================================;
// 주의사항1: AxmContiSetAxisMap함수를 이용하여 축맵핑후에 낮은순서축부터 맵핑을 하면서 사용해야된다.
//           원호보간의 경우에는 반드시 낮은순서축부터 축배열에 넣어야 동작 가능하다.
    
// 주의사항2: 위치를 설정할경우 반드시 마스터축과 슬레이브 축의 UNIT/PULSE의 맞추어서 설정한다.
//           위치를 UNIT/PULSE 보다 작게 설정할 경우 최소단위가 UNIT/PULSE로 맞추어지기때문에 그위치까지 구동이 될수없다.

// 주의사항3: 원호 보간을 할경우 반드시 한칩내에서 구동이 될수있으므로 
//            SMC-2V03 모듈은 2축만 가능며 N404, N804 보드는 4축내에서만 선택해서 사용해야된다.

// 주의사항4: 보간 구동 시작/중에 비정상 정지 조건(+- Limit신호, 서보 알람, 비상정지 등)이 발생하면 
//            구동 방향에 상관없이 구동을 시작하지 않거나 정지 된다.


// 직선 보간 한다.
// 시작점과 종료점을 지정하여 다축 직선 보간 구동하는 함수이다. 구동 시작 후 함수를 벗어난다.
// AxmContiBeginNode, AxmContiEndNode와 같이사용시 지정된 좌표계에 시작점과 종료점을 지정하여 직선 보간 구동하는 Queue에 저장함수가된다. 
// 직선 프로파일 연속 보간 구동을 위해 내부 Queue에 저장하여 AxmContiStart함수를 사용해서 시작한다.
function AxmLineMove (lCoord : LongInt; dpEndPos : PDouble; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// 2축 원호보간 한다.
// 시작점, 종료점과 중심점을 지정하여 원호 보간 구동하는 함수이다. 구동 시작 후 함수를 벗어난다.
// AxmContiBeginNode, AxmContiEndNode, 와 같이사용시 지정된 좌표계에 시작점, 종료점과 중심점을 지정하여 구동하는 원호 보간 Queue에 저장함수가된다.
// 프로파일 원호 연속 보간 구동을 위해 내부 Queue에 저장하여 AxmContiStart함수를 사용해서 시작한다.
// lAxisNo = 두축 배열 , dCenterPos = 중심점 X,Y 배열 , dEndPos = 종료점 X,Y 배열.
// uCWDir   DIR_CCW(0): 반시계방향, DIR_CW(1) 시계방향

function AxmCircleCenterMove (lCoord : LongInt; lAxisNo : PLongInt; dCenterPos : PDouble; dEndPos : PDouble; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord) : DWord; stdcall;

// 중간점, 종료점을 지정하여 원호 보간 구동하는 함수이다. 구동 시작 후 함수를 벗어난다.
// AxmContiBeginNode, AxmContiEndNode와 같이사용시 지정된 좌표계에 중간점, 종료점을 지정하여 구동하는 원호 보간 Queue에 저장함수가된다.
// 프로파일 원호 연속 보간 구동을 위해 내부 Queue에 저장하여 AxmContiStart함수를 사용해서 시작한다.
// lAxisNo = 두축 배열 , dMidPos = 중간점 X,Y 배열 , dEndPos = 종료점 X,Y 배열, lArcCircle = 아크(0), 원(1)

function AxmCirclePointMove (lCoord : LongInt; lAxisNo : PLongInt; dMidPos : PDouble; dEndPos : PDouble; dVel : Double; dAccel : Double; dDecel : Double; lArcCircle : LongInt) : DWord; stdcall;

// 시작점, 종료점과 반지름을 지정하여 원호 보간 구동하는 함수이다. 구동 시작 후 함수를 벗어난다.
// AxmContiBeginNode, AxmContiEndNode와 같이사용시 지정된 좌표계에 시작점, 종료점과 반지름을 지정하여 원호 보간 구동하는 Queue에 저장함수가된다.
// 프로파일 원호 연속 보간 구동을 위해 내부 Queue에 저장하여 AxmContiStart함수를 사용해서 시작한다.
// lAxisNo = 두축 배열 , dRadius = 반지름, dEndPos = 종료점 X,Y 배열 , uShortDistance = 작은원(0), 큰원(1)
// uCWDir   DIR_CCW(0): 반시계방향, DIR_CW(1) 시계방향

function AxmCircleRadiusMove (lCoord : LongInt; lAxisNo : PLongInt; dRadius : Double; dEndPos : PDouble; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord; uShortDistance : DWord) : DWord; stdcall;

// 시작점, 회전각도와 반지름을 지정하여 원호 보간 구동하는 함수이다. 구동 시작 후 함수를 벗어난다.
// AxmContiBeginNode, AxmContiEndNode와 같이사용시 지정된 좌표계에 시작점, 회전각도와 반지름을 지정하여 원호 보간 구동하는 Queue에 저장함수가된다.
// 프로파일 원호 연속 보간 구동을 위해 내부 Queue에 저장하여 AxmContiStart함수를 사용해서 시작한다.
// lAxisNo = 두축 배열 , dCenterPos = 중심점 X,Y 배열 , dAngle = 각도.
// uCWDir   DIR_CCW(0): 반시계방향, DIR_CW(1) 시계방향

function AxmCircleAngleMove (lCoord : LongInt; lAxisNo : PLongInt; dCenterPos : PDouble; dAngle : Double; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord) : DWord; stdcall;

//====연속 보간 함수 ============================================================================================================================================;
//지정된 좌표계에 연속보간 축 맵핑을 설정한다.
//(축맵핑 번호는 0 부터 시작))
// 주의점: 축맵핑할때는 반드시 실제 축번호가 작은 숫자부터 큰숫자를 넣는다.
//         가상축 맵핑 함수를 사용하였을 때 가상축번호를 실제 축번호가 작은 값 부터 lpAxesNo의 낮은 인텍스에 입력하여야 한다.
//         가상축 맵핑 함수를 사용하였을 때 가상축번호에 해당하는 실제 축번호가 다른 값이라야 한다.
//         SMC-2V03의 경우 lSize는 2로 입력하여야 한다.
//         같은 축을 다른 Coordinate에 중복 맵핑하지 말아야 한다.

function AxmContiSetAxisMap (lCoord : LongInt; lSize : LongInt; lpRealAxesNo : PLongInt) : DWord; stdcall;
//지정된 좌표계에 연속보간 축 맵핑을 반환한다.
function AxmContiGetAxisMap (lCoord : LongInt; lpSize : PLongInt; lpRealAxesNo : PLongInt) : DWord; stdcall;    
    
// 지정된 좌표계에 연속보간 축 절대/상대 모드를 설정한다.
// (주의점 : 반드시 축맵핑 하고 사용가능)
// 지정 축의 이동 거리 계산 모드를 설정한다.
//uAbsRelMode : POS_ABS_MODE '0' - 절대 좌표계
//              POS_REL_MODE '1' - 상대 좌표계

function AxmContiSetAbsRelMode (lCoord : LongInt; uAbsRelMode : DWord) : DWord; stdcall;
// 지정된 좌표계에 연속보간 축 절대/상대 모드를 반환한다.
function AxmContiGetAbsRelMode (lCoord : LongInt; upAbsRelMode : PDWord) : DWord; stdcall;
// 지정된 좌표계에 보간 구동을 위한 내부 Queue가 비어 있는지 확인하는 함수이다.
function AxmContiReadFree (lCoord : LongInt; upQueueFree : PDWord) : DWord; stdcall;
// 지정된 좌표계에 보간 구동을 위한 내부 Queue에 저장되어 있는 보간 구동 개수를 확인하는 함수이다.
function AxmContiReadIndex (lCoord : LongInt; lpQueueIndex : PLongInt) : DWord; stdcall;
// 지정된 좌표계에 연속 보간 구동을 위해 저장된 내부 Queue를 모두 삭제하는 함수이다.
function AxmContiWriteClear (lCoord : LongInt) : DWord; stdcall;

// 지정된 좌표계에 연속보간에서 수행할 작업들의 등록을 시작한다. 이함수를 호출한후,
// AxmContiEndNode함수가 호출되기 전까지 수행되는 모든 모션작업은 실제 모션을 수행하는 것이 아니라 연속보간 모션으로 등록 되는 것이며,
// AxmContiStart 함수가 호출될 때 비로소 등록된모션이 실제로 수행된다.
function AxmContiBeginNode (lCoord : LongInt) : DWord; stdcall;
// 지정된 좌표계에서 연속보간을 수행할 작업들의 등록을 종료한다.
function AxmContiEndNode (lCoord : LongInt) : DWord; stdcall;

// 연속 보간 시작 한다.
// SMC-2V03 module :  dwProfileset, lAngle 값을 0으로 입력함. 
// PCI-Nx04 : dwProfileset(CONTI_NODE_VELOCITY(0) : 연속 보간 사용, CONTI_NODE_MANUAL(1) : 프로파일 보간 사용, CONTI_NODE_AUTO(2) : 자동 프로파일 보간, 3 : 속도보상 모드 사용) 
function AxmContiStart (lCoord : LongInt; dwProfileset : DWord; lAngle : LongInt) : DWord; stdcall;
// 지정된 좌표계에 연속 보간 구동 중인지 확인하는 함수이다.
function AxmContiIsMotion (lCoord : LongInt; upInMotion : PDWord) : DWord; stdcall;
// 지정된 좌표계에 연속 보간 구동 중 현재 구동중인 연속 보간 인덱스 번호를 확인하는 함수이다.
function AxmContiGetNodeNum (lCoord : LongInt; lpNodeNum : PLongInt) : DWord; stdcall;
// 지정된 좌표계에 설정한 연속 보간 구동 총 인덱스 갯수를 확인하는 함수이다.
function AxmContiGetTotalNodeNum (lCoord : LongInt; lpNodeNum : PLongInt) : DWord; stdcall;

//====================트리거 함수 ===============================================================================================================================

// 주의사항: 트리거 위치를 설정할경우 반드시 UNIT/PULSE의 맞추어서 설정한다.
//           위치를 UNIT/PULSE 보다 작게할 경우 최소단위가 UNIT/PULSE로 맞추어지기때문에 그위치에 출력할수없다.

// 지정 축에 트리거 기능의 사용 여부, 출력 레벨, 위치 비교기, 트리거 신호 지속 시간 및 트리거 출력 모드를 설정한다.
// 트리거 기능 사용을 위해서는 먼저  AxmTriggerSetTimeLevel 를 사용하여 관련 기능 설정을 먼저 하여야 한다.
//  dTrigTime  : 트리거 출력 시간 
//               SMC-2V03 module : 1usec - 최대 4msec ( 1 - 4000 까지 설정)
//               PCI-Nx04 : 1usec - 최대 50msec ( 1 - 50000 까지 설정)
//  upTriggerLevel  : 트리거 출력 레벨 유무  => LOW(0), HIGH(1)
//  uSelect         : 사용할 기준 위치       => COMMAND(0), ACTUAL(1)
//  uInterrupt      : 인터럽트 설정          => DISABLE(0), ENABLE(1)

// 지정 축에 트리거 신호 지속 시간 및 트리거 출력 레벨, 트리거 출력방법을 설정한다.
function AxmTriggerSetTimeLevel (lAxisNo : LongInt; dTrigTime : Double; uTriggerLevel : DWord; uSelect : DWord; uInterrupt : DWord) : DWord; stdcall;
// 지정 축에 트리거 신호 지속 시간 및 트리거 출력 레벨, 트리거 출력방법을 반환한다.
function AxmTriggerGetTimeLevel (lAxisNo : LongInt; dpTrigTime : PDouble; upTriggerLevel : PDWord; upSelect : PDWord; upInterrupt : PDWord) : DWord; stdcall;    

// 지정 축의 트리거 출력 기능을 설정한다.
//  uMethod : PERIOD_MODE      0x0 : 현재 위치를 기준으로 dPos를 위치 주기로 사용한 주기 트리거 방식
//            ABS_POS_MODE     0x1 : 트리거 절대 위치에서 트리거 발생, 절대 위치 방식

//  dPos : 주기 선택시 : 위치마다위치마다 출력하기때문에 그 위치
//         절대 선택시 : 출력할 그 위치, 이 위치와같으면 무조건 출력이 나간다. 
//  주의사항: N404, N804의 경우에는 AxmTriggerSetAbsPeriod의 주기모드로 설정할경우 처음 그위치가 범위 안에 있으므로 
//            트리거 출력이 한번 발생한다.
function AxmTriggerSetAbsPeriod (lAxisNo : LongInt; uMethod : DWord; dPos : Double) : DWord; stdcall;

// 지정 축에 트리거 기능의 사용 여부, 출력 레벨, 위치 비교기, 트리거 신호 지속 시간 및 트리거 출력 모드를 반환한다.
// 주의사항: IP에서는 AxmTriiggerSetBlock함수를 호출시 내부라이브러리에서 설정값이 ABS_POS_MODE로 사용하기 때문에 
// 이함수를 반환하는값이 1로 반환한다.
function AxmTriggerGetAbsPeriod (lAxisNo : LongInt; upMethod : PDWord; dpPos : PDouble) : DWord; stdcall;

// 사용자가 지정한 시작위치부터 종료위치까지 일정구간마다 트리거를 출력 한다.
// 주의사항: SMC-2V03모듈 IP의 경우 트리거 시작 위치를 지나지 않으면 트리거 발생하지 않는다.
//           SMC-2V03모듈 IP의 경우 트리거 종료 위치를 지나서 다시 트리거 범위안에 들어오면 트리거 발생하지않는다.
function AxmTriggerSetBlock (lAxisNo : LongInt; dStartPos : Double; dEndPos : Double; dPeriodPos : Double) : DWord; stdcall;
// 'AxmTriggerSetBlock' 함수의 트리거 설정한 값을 읽는다..
function AxmTriggerGetBlock (lAxisNo : LongInt; dpStartPos : PDouble; dpEndPos : PDouble; dpPeriodPos : PDouble) : DWord; stdcall;
// 사용자가 한 개의 트리거 펄스를 출력한다.
function AxmTriggerOneShot (lAxisNo : LongInt) : DWord; stdcall;
// 사용자가 한 개의 트리거 펄스를 몇초후에 출력한다.
function AxmTriggerSetTimerOneshot (lAxisNo : LongInt; lmSec : LongInt) : DWord; stdcall;
// 절대위치 트리거 무한대 절대위치 출력한다.
function AxmTriggerOnlyAbs (lAxisNo : LongInt; lTrigNum : LongInt; dpTrigPos : PDouble) : DWord; stdcall;
// 트리거 설정을 리셋한다.
function AxmTriggerSetReset (lAxisNo : LongInt) : DWord; stdcall;

//======== CRC( 잔여 펄스 클리어 함수)=====================================================================    

//Level   : LOW(0), HIGH(1), UNUSED(2), USED(3)
//uMethod : 잔여펄스 제거 출력 신호 펄스 폭 2 - 6까지 설정가능.(QI만 사용, IP사용안함)
//          0: Don't care , 1: Don't care, 2: 500 uSec, 3: 1 mSec, 4: 10 mSec, 5: 50 mSec, 6: 100 mSec
    
//지정 축에 CRC 신호 사용 여부 및 출력 레벨을 설정한다.
function AxmCrcSetMaskLevel (lAxisNo : LongInt; uLevel : Dword; lMethod : Dword) : DWord; stdcall;
// 지정 축의 CRC 신호 사용 여부 및 출력 레벨을 반환한다.
function AxmCrcGetMaskLevel (lAxisNo : LongInt; upLevel : PDWord; upMethod : PDword) : DWord; stdcall;

//uOnOff  : CRC 신호를 Program으로 발생 여부  (FALSE(0),TRUE(1))

// 지정 축에 CRC 신호를 강제로 발생 시킨다.
function AxmCrcSetOutput (lAxisNo : LongInt; uOnOff : DWord) : DWord; stdcall;
// 지정 축의 CRC 신호를 강제로 발생 여부를 반환한다.
function AxmCrcGetOutput (lAxisNo : LongInt; upOnOff : PDWord) : DWord; stdcall;    

//-----------    SMC-2V03 module 전용 함수 : EndLimit을 만날때 강제로 신호를 발생시킨다. --------
// uPositiveUse : Positive Emeregency End limit에 대한 Clear출력 사용 레벨
// uNegativeUse : Negative Emeregency End limit에 대한 Clear출력 사용 레벨
// Level   : LOW(0), HIGH(1), UNUSED(2)
// 지정 축에 리미트에 대한 CRC 신호의 사용 여부 및 출력 레벨을 설정한다.
function AxmCrcSetEndLimit (lAxisNo : LongInt; uPositiveLevel : DWord; uNegativeLevel : DWord) : DWord; stdcall;
// 지정 축의 리미트에 대한 CRC 신호의 사용 여부 및 출력 레벨을 반환한다.
function AxmCrcGetEndLimit (lAxisNo : LongInt; upPositiveLevel : PDWord; upNegativeLevel : PDWord) : DWord; stdcall;

//======MPG(Manual Pulse Generation) 함수===========================================================

//================ SMC-2V03 module ===========================================================
// lInputMethod : 0-7 까지 설정가능. 0:OnePhase, 1:TwoPhase1, 2:TwoPhase2, 3:TwoPhase4
//                                   4:Level One Phase, 5:Level Two Phase1, 6: Level Two Phase2, 7:Level Two Phase4
// lDriveMode   : 0-2 까지 설정가능 (0 :MPG 슬레이브 모드 ,1 :MPG PRESET 모드, 2 :MPG 연속 모드)
// MPGPos        : MPG 입력신호마다 이동하는 거리
// dMPGdenominator, dMPGnumerator 사용안함.
//================ PCI-Nx04 ============================================================
// lInputMethod : 0-3 까지 설정가능. 0:OnePhase, 1:TwoPhase1(IP만가능, QI지원안함) , 2:TwoPhase2, 3:TwoPhase4
// lDriveMode   : 0만 설정가능(0 :MPG 연속모드)

// MPGPos        : MPG 입력신호마다 이동하는 거리

// MPGdenominator: MPG(수동 펄스 발생 장치 입력)구동 시 나누기 값
// dMPGnumerator : MPG(수동 펄스 발생 장치 입력)구동 시 곱하기 값
// dwNumerator   : 최대(1 에서    64) 까지 설정 가능
// dwDenominator : 최대(1 에서  4096) 까지 설정 가능
// dMPGdenominator = 4096, MPGnumerator=1 가 의미하는 것은 
// MPG 한바퀴에 200펄스면 그대로 1:1로 1펄스씩 출력을 의미한다. 
// 만약 dMPGdenominator = 4096, MPGnumerator=2 로 했을경우는 1:2로 2펄스씩 출력을 내보낸다는의미이다. 
// 여기에 MPG PULSE = ((Numerator) * (Denominator)/ 4096 ) 칩내부에 출력나가는 계산식이다.


// 지정 축에 MPG 입력방식, 드라이브 구동 모드, 이동 거리, MPG 속도 등을 설정한다.
function AxmMPGSetEnable (lAxisNo : LongInt; lInputMethod : LongInt; lDriveMode : LongInt; dMPGPos : Double; dVel : Double; dAcc : Double) : DWord; stdcall;
// 지정 축에 MPG 입력방식, 드라이브 구동 모드, 이동 거리, MPG 속도 등을 반환한다.
function AxmMPGGetEnable (lAxisNo : LongInt; lpInputMethod : PLongInt; lpDriveMode : PLongInt; dpMPGPos : PDouble; dpVel : PDouble) : DWord; stdcall;

// IP 사용안함, QI 전용 함수.
// 지정 축에 MPG 드라이브 구동 모드에서 한펄스당 이동할 펄스 비율을 설정한다.
function AxmMPGSetRatio (lAxisNo : LongInt; dMPGnumerator : LongInt; dMPGdenominator : LongInt) : DWord; stdcall;
// 지정 축에 MPG 드라이브 구동 모드에서 한펄스당 이동할 펄스 비율을 반환한다.
function AxmMPGGetRatio (lAxisNo : LongInt; dpMPGnumerator : PLongInt; dpMPGdenominator : PLongInt) : DWord; stdcall;
// 지정 축에 MPG 드라이브 설정을 해지한다.
function AxmMPGReset (lAxisNo : LongInt) : DWord; stdcall;    

//======= 헬리컬 이동  (PCI-Nx04 전용 함수)===========================================================================
// 지정된 좌표계에 시작점, 종료점과 중심점을 지정하여 헬리컬 보간 구동하는 함수이다.
// AxmContiBeginNode, AxmContiEndNode와 같이사용시 지정된 좌표계에 시작점, 종료점과 중심점을 지정하여 헬리컬 연속보간 구동하는 함수이다. 
// 원호 연속 보간 구동을 위해 내부 Queue에 저장하는 함수이다. AxmContiStart함수를 사용해서 시작한다. (연속보간 함수와 같이 이용한다)
// dCenterPos = 중심점 X,Y  , dEndPos = 종료점 X,Y .

// uCWDir   DIR_CCW(0): 반시계방향, DIR_CW(1) 시계방향
function AxmHelixCenterMove (lCoord : LongInt; dCenterXPos : Double; dCenterYPos : Double; dEndXPos : Double; dEndYPos : Double; dZPos : Double; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord) : DWord; stdcall;

// 지정된 좌표계에 시작점, 종료점과 반지름을 지정하여 헬리컬 보간 구동하는 함수이다. 
// AxmContiBeginNode, AxmContiEndNode와 같이사용시 지정된 좌표계에 중간점, 종료점을 지정하여 헬리컬연속 보간 구동하는 함수이다. 
// 원호 연속 보간 구동을 위해 내부 Queue에 저장하는 함수이다. AxmContiStart함수를 사용해서 시작한다. (연속보간 함수와 같이 이용한다.)
// dMidPos = 중간점 X,Y  , dEndPos = 종료점 X,Y 
function AxmHelixPointMove (lCoord : LongInt; dMidXPos : Double; dMidYPos : Double; dEndXPos : Double; dEndYPos : Double; dZPos : Double; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// 지정된 좌표계에 시작점, 종료점과 반지름을 지정하여 헬리컬 보간 구동하는 함수이다.
// AxmContiBeginNode, AxmContiEndNode와 같이사용시 지정된 좌표계에 시작점, 종료점과 반지름을 지정하여 헬리컬연속 보간 구동하는 함수이다. 
// 원호 연속 보간 구동을 위해 내부 Queue에 저장하는 함수이다. AxmContiStart함수를 사용해서 시작한다. (연속보간 함수와 같이 이용한다.)
// dRadius = 반지름, dEndPos = 종료점 X,Y  , uShortDistance = 작은원(0), 큰원(1)
// uCWDir   DIR_CCW(0): 반시계방향, DIR_CW(1) 시계방향
function AxmHelixRadiusMove (lCoord : LongInt; dRadius : Double; dEndXPos : Double; dEndYPos : Double; dZPos : Double; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord; uShortDistance : DWord) : DWord; stdcall;

// 지정된 좌표계에 시작점, 회전각도와 반지름을 지정하여 헬리컬 보간 구동하는 함수이다
// AxmContiBeginNode, AxmContiEndNode와 같이사용시 지정된 좌표계에 시작점, 회전각도와 반지름을 지정하여 헬리컬연속 보간 구동하는 함수이다. 
// 원호 연속 보간 구동을 위해 내부 Queue에 저장하는 함수이다. AxmContiStart함수를 사용해서 시작한다. (연속보간 함수와 같이 이용한다.)
//dCenterPos = 중심점 X,Y  , dAngle = 각도.
// uCWDir   DIR_CCW(0): 반시계방향, DIR_CW(1) 시계방향
function AxmHelixAngleMove (lCoord : LongInt; dCenterXPos : Double; dCenterYPos : Double; dAngle : Double; dZPos : Double; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord) : DWord; stdcall;

//======== 스플라인 이동 (PCI-Nx04 전용 함수)=========================================================================== 

// AxmContiBeginNode, AxmContiEndNode와 같이사용안함. 
// 스플라인 연속 보간 구동하는 함수이다. 원호 연속 보간 구동을 위해 내부 Queue에 저장하는 함수이다.
// AxmContiStart함수를 사용해서 시작한다. (연속보간 함수와 같이 이용한다.)    
// lPosSize : 최소 3개 이상.
// 2축으로 사용시 dPoZ값을 0으로 넣어주면 됨.
// 3축으로 사용시 축맵핑을 3개및 dPosZ 값을 넣어준다.
function AxmSplineWrite (lCoord : LongInt; lPosSize : LongInt; dpPosX : PDouble; dpPosY : PDouble; dVel : Double; dAccel : Double; dDecel : Double; dPosZ : Double; lPointFactor : LongInt) : DWord; stdcall;    

//--------------------------------------------------------------------------------------------------------------------------------

implementation

const

    dll_name    = 'Axl.dll';

    function AxmInfoGetAxis; external dll_name name 'AxmInfoGetAxis';
    function AxmInfoIsMotionModule; external dll_name name 'AxmInfoIsMotionModule';
    function AxmInfoIsInvalidAxisNo; external dll_name name 'AxmInfoIsInvalidAxisNo';
    function AxmInfoGetAxisCount; external dll_name name 'AxmInfoGetAxisCount';
    function AxmInfoGetFirstAxisNo; external dll_name name 'AxmInfoGetFirstAxisNo';

    function AxmVirtualSetAxisNoMap; external dll_name name 'AxmVirtualSetAxisNoMap';
    function AxmVirtualGetAxisNoMap; external dll_name name 'AxmVirtualGetAxisNoMap';
    function AxmVirtualSetMultiAxisNoMap; external dll_name name 'AxmVirtualSetMultiAxisNoMap';
    function AxmVirtualGetMultiAxisNoMap; external dll_name name 'AxmVirtualGetMultiAxisNoMap';
    function AxmVirtualResetAxisMap; external dll_name name 'AxmVirtualResetAxisMap';

    function AxmInterruptSetAxis; external dll_name name 'AxmInterruptSetAxis';
    function AxmInterruptSetAxisEnable; external dll_name name 'AxmInterruptSetAxisEnable';
    function AxmInterruptGetAxisEnable; external dll_name name 'AxmInterruptGetAxisEnable';
    function AxmInterruptRead; external dll_name name 'AxmInterruptRead';
    function AxmInterruptReadAxisFlag; external dll_name name 'AxmInterruptReadAxisFlag';
    function AxmInterruptSetUserEnable; external dll_name name 'AxmInterruptSetUserEnable';
    function AxmInterruptGetUserEnable; external dll_name name 'AxmInterruptGetUserEnable';

    function AxmMotLoadParaAll; external dll_name name 'AxmMotLoadParaAll';
    function AxmMotSaveParaAll; external dll_name name 'AxmMotSaveParaAll';
    function AxmMotSetParaLoad; external dll_name name 'AxmMotSetParaLoad';
    function AxmMotGetParaLoad; external dll_name name 'AxmMotGetParaLoad';
    function AxmMotSetPulseOutMethod; external dll_name name 'AxmMotSetPulseOutMethod';
    function AxmMotGetPulseOutMethod; external dll_name name 'AxmMotGetPulseOutMethod';
    function AxmMotSetEncInputMethod; external dll_name name 'AxmMotSetEncInputMethod';
    function AxmMotGetEncInputMethod; external dll_name name 'AxmMotGetEncInputMethod';
    function AxmMotSetMoveUnitPerPulse; external dll_name name 'AxmMotSetMoveUnitPerPulse';
    function AxmMotGetMoveUnitPerPulse; external dll_name name 'AxmMotGetMoveUnitPerPulse';
    function AxmMotSetDecelMode; external dll_name name 'AxmMotSetDecelMode';
    function AxmMotGetDecelMode; external dll_name name 'AxmMotGetDecelMode';
    function AxmMotSetRemainPulse; external dll_name name 'AxmMotSetRemainPulse';
    function AxmMotGetRemainPulse; external dll_name name 'AxmMotGetRemainPulse';
    function AxmMotSetMaxVel; external dll_name name 'AxmMotSetMaxVel';
    function AxmMotGetMaxVel; external dll_name name 'AxmMotGetMaxVel';
    function AxmMotSetAbsRelMode; external dll_name name 'AxmMotSetAbsRelMode';
    function AxmMotGetAbsRelMode; external dll_name name 'AxmMotGetAbsRelMode';
    function AxmMotSetProfileMode; external dll_name name 'AxmMotSetProfileMode';
    function AxmMotGetProfileMode; external dll_name name 'AxmMotGetProfileMode';
    function AxmMotSetAccelUnit; external dll_name name 'AxmMotSetAccelUnit';
    function AxmMotGetAccelUnit; external dll_name name 'AxmMotGetAccelUnit';
    function AxmMotSetMinVel; external dll_name name 'AxmMotSetMinVel';
    function AxmMotGetMinVel; external dll_name name 'AxmMotGetMinVel';
    function AxmMotSetAccelJerk; external dll_name name 'AxmMotSetAccelJerk';
    function AxmMotGetAccelJerk; external dll_name name 'AxmMotGetAccelJerk';
    function AxmMotSetDecelJerk; external dll_name name 'AxmMotSetDecelJerk';
    function AxmMotGetDecelJerk; external dll_name name 'AxmMotGetDecelJerk';
    function AxmMotSetProfilePriority; external dll_name name 'AxmMotSetProfilePriority';
    function AxmMotGetProfilePriority; external dll_name name 'AxmMotGetProfilePriority';

    function AxmSignalSetZphaseLevel; external dll_name name 'AxmSignalSetZphaseLevel';
    function AxmSignalGetZphaseLevel; external dll_name name 'AxmSignalGetZphaseLevel';
    function AxmSignalSetServoOnLevel; external dll_name name 'AxmSignalSetServoOnLevel';
    function AxmSignalGetServoOnLevel; external dll_name name 'AxmSignalGetServoOnLevel';
    function AxmSignalSetServoAlarmResetLevel; external dll_name name 'AxmSignalSetServoAlarmResetLevel';
    function AxmSignalGetServoAlarmResetLevel; external dll_name name 'AxmSignalGetServoAlarmResetLevel';
    function AxmSignalSetInpos; external dll_name name 'AxmSignalSetInpos';
    function AxmSignalGetInpos; external dll_name name 'AxmSignalGetInpos';
    function AxmSignalReadInpos; external dll_name name 'AxmSignalReadInpos';
    function AxmSignalSetServoAlarm; external dll_name name 'AxmSignalSetServoAlarm';
    function AxmSignalGetServoAlarm; external dll_name name 'AxmSignalGetServoAlarm';
    function AxmSignalReadServoAlarm; external dll_name name 'AxmSignalReadServoAlarm';
    function AxmSignalSetLimit; external dll_name name 'AxmSignalSetLimit';
    function AxmSignalGetLimit; external dll_name name 'AxmSignalGetLimit';
    function AxmSignalReadLimit; external dll_name name 'AxmSignalReadLimit';
    function AxmSignalSetSoftLimit; external dll_name name 'AxmSignalSetSoftLimit';
    function AxmSignalGetSoftLimit; external dll_name name 'AxmSignalGetSoftLimit';
    function AxmSignalSetStop; external dll_name name 'AxmSignalSetStop';
    function AxmSignalGetStop; external dll_name name 'AxmSignalGetStop';
    function AxmSignalReadStop; external dll_name name 'AxmSignalReadStop';
    function AxmSignalServoOn; external dll_name name 'AxmSignalServoOn';
    function AxmSignalIsServoOn; external dll_name name 'AxmSignalIsServoOn';
    function AxmSignalServoAlarmReset; external dll_name name 'AxmSignalServoAlarmReset';
    function AxmSignalWriteOutput; external dll_name name 'AxmSignalWriteOutput';
    function AxmSignalReadOutput; external dll_name name 'AxmSignalReadOutput';
    function AxmSignalWriteOutputBit; external dll_name name 'AxmSignalWriteOutputBit';
    function AxmSignalReadOutputBit; external dll_name name 'AxmSignalReadOutputBit';
    function AxmSignalReadInput; external dll_name name 'AxmSignalReadInput';
    function AxmSignalReadInputBit; external dll_name name 'AxmSignalReadInputBit';

    function AxmStatusReadInMotion; external dll_name name 'AxmStatusReadInMotion';
    function AxmStatusReadDrivePulseCount; external dll_name name 'AxmStatusReadDrivePulseCount';
    function AxmStatusReadMotion; external dll_name name 'AxmStatusReadMotion';
    function AxmStatusReadStop; external dll_name name 'AxmStatusReadStop';
    function AxmStatusReadMechanical; external dll_name name 'AxmStatusReadMechanical';
    function AxmStatusReadVel; external dll_name name 'AxmStatusReadVel';
    function AxmStatusReadPosError; external dll_name name 'AxmStatusReadPosError';
    function AxmStatusReadDriveDistance; external dll_name name 'AxmStatusReadDriveDistance';
    function AxmStatusSetActPos; external dll_name name 'AxmStatusSetActPos';
    function AxmStatusGetActPos; external dll_name name 'AxmStatusGetActPos';
    function AxmStatusSetCmdPos; external dll_name name 'AxmStatusSetCmdPos';
    function AxmStatusGetCmdPos; external dll_name name 'AxmStatusGetCmdPos';

    function AxmHomeSetSignalLevel; external dll_name name 'AxmHomeSetSignalLevel';
    function AxmHomeGetSignalLevel; external dll_name name 'AxmHomeGetSignalLevel';
    function AxmHomeReadSignal; external dll_name name 'AxmHomeReadSignal';
    function AxmHomeSetMethod; external dll_name name 'AxmHomeSetMethod';
    function AxmHomeGetMethod; external dll_name name 'AxmHomeGetMethod';
    function AxmHomeSetVel; external dll_name name 'AxmHomeSetVel';
    function AxmHomeGetVel; external dll_name name 'AxmHomeGetVel';
    function AxmHomeSetStart; external dll_name name 'AxmHomeSetStart';
    function AxmHomeSetResult; external dll_name name 'AxmHomeSetResult';
    function AxmHomeGetResult; external dll_name name 'AxmHomeGetResult';
    function AxmHomeGetRate; external dll_name name 'AxmHomeGetRate';

    function AxmMoveStartPos; external dll_name name 'AxmMoveStartPos';
    function AxmMovePos; external dll_name name 'AxmMovePos';
    function AxmMoveVel; external dll_name name 'AxmMoveVel';
    function AxmMoveStartMultiVel; external dll_name name 'AxmMoveStartMultiVel';
    function AxmMoveSignalSearch; external dll_name name 'AxmMoveSignalSearch';
    function AxmMoveSignalCapture; external dll_name name 'AxmMoveSignalCapture';
    function AxmMoveGetCapturePos; external dll_name name 'AxmMoveGetCapturePos';
    function AxmMoveStartMultiPos; external dll_name name 'AxmMoveStartMultiPos';
    function AxmMoveMultiPos; external dll_name name 'AxmMoveMultiPos';
    function AxmMoveStop; external dll_name name 'AxmMoveStop';
    function AxmMoveEStop; external dll_name name 'AxmMoveEStop';
    function AxmMoveSStop; external dll_name name 'AxmMoveSStop';

    function AxmOverridePos; external dll_name name 'AxmOverridePos';
    function AxmOverrideSetMaxVel; external dll_name name 'AxmOverrideSetMaxVel';
    function AxmOverrideVel; external dll_name name 'AxmOverrideVel';
    function AxmOverrideAccelVelDecel; external dll_name name 'AxmOverrideAccelVelDecel';
    function AxmOverrideVelAtPos; external dll_name name 'AxmOverrideVelAtPos';
    function AxmOverrideVelAtMultiPos; external dll_name name 'AxmOverrideVelAtMultiPos';

    function AxmLinkSetMode; external dll_name name 'AxmLinkSetMode';
    function AxmLinkGetMode; external dll_name name 'AxmLinkGetMode';
    function AxmLinkResetMode; external dll_name name 'AxmLinkResetMode';

    function AxmGantrySetEnable; external dll_name name 'AxmGantrySetEnable';
    function AxmGantryGetEnable; external dll_name name 'AxmGantryGetEnable';
    function AxmGantrySetDisable; external dll_name name 'AxmGantrySetDisable';

    function AxmLineMove; external dll_name name 'AxmLineMove';
    
    function AxmCircleCenterMove; external dll_name name 'AxmCircleCenterMove';
    function AxmCirclePointMove; external dll_name name 'AxmCirclePointMove';
    function AxmCircleRadiusMove; external dll_name name 'AxmCircleRadiusMove';
    function AxmCircleAngleMove; external dll_name name 'AxmCircleAngleMove';
    function AxmContiSetAxisMap; external dll_name name 'AxmContiSetAxisMap';
    function AxmContiGetAxisMap; external dll_name name 'AxmContiGetAxisMap';

    function AxmContiSetAbsRelMode; external dll_name name 'AxmContiSetAbsRelMode';
    function AxmContiGetAbsRelMode; external dll_name name 'AxmContiGetAbsRelMode';

    function AxmContiReadFree; external dll_name name 'AxmContiReadFree';
    function AxmContiReadIndex; external dll_name name 'AxmContiReadIndex';
    function AxmContiWriteClear; external dll_name name 'AxmContiWriteClear';

    function AxmContiBeginNode; external dll_name name 'AxmContiBeginNode';
    function AxmContiEndNode; external dll_name name 'AxmContiEndNode';

    function AxmContiStart; external dll_name name 'AxmContiStart';
    function AxmContiIsMotion; external dll_name name 'AxmContiIsMotion';
    function AxmContiGetNodeNum; external dll_name name 'AxmContiGetNodeNum';
    function AxmContiGetTotalNodeNum; external dll_name name 'AxmContiGetTotalNodeNum';

    function AxmTriggerSetTimeLevel; external dll_name name 'AxmTriggerSetTimeLevel';
    function AxmTriggerGetTimeLevel; external dll_name name 'AxmTriggerGetTimeLevel';

    function AxmTriggerSetAbsPeriod; external dll_name name 'AxmTriggerSetAbsPeriod';
    function AxmTriggerGetAbsPeriod; external dll_name name 'AxmTriggerGetAbsPeriod';

    function AxmTriggerSetBlock; external dll_name name 'AxmTriggerSetBlock';
    function AxmTriggerGetBlock; external dll_name name 'AxmTriggerGetBlock';
    function AxmTriggerOneShot; external dll_name name 'AxmTriggerOneShot';
    function AxmTriggerSetTimerOneshot; external dll_name name 'AxmTriggerSetTimerOneshot';
    function AxmTriggerOnlyAbs; external dll_name name 'AxmTriggerOnlyAbs';
    function AxmTriggerSetReset; external dll_name name 'AxmTriggerSetReset';

    function AxmCrcSetMaskLevel; external dll_name name 'AxmCrcSetMaskLevel';
    function AxmCrcGetMaskLevel; external dll_name name 'AxmCrcGetMaskLevel';
    function AxmCrcSetOutput; external dll_name name 'AxmCrcSetOutput';
    function AxmCrcGetOutput; external dll_name name 'AxmCrcGetOutput';

    function AxmCrcSetEndLimit; external dll_name name 'AxmCrcSetEndLimit';
    function AxmCrcGetEndLimit; external dll_name name 'AxmCrcGetEndLimit';

    function AxmMPGSetEnable; external dll_name name 'AxmMPGSetEnable';
    function AxmMPGGetEnable; external dll_name name 'AxmMPGGetEnable';
    function AxmMPGSetRatio; external dll_name name 'AxmMPGSetRatio';
    function AxmMPGGetRatio; external dll_name name 'AxmMPGGetRatio';
    function AxmMPGReset; external dll_name name 'AxmMPGReset';

    function AxmHelixCenterMove; external dll_name name 'AxmHelixCenterMove';
    function AxmHelixPointMove; external dll_name name 'AxmHelixPointMove';
    function AxmHelixRadiusMove; external dll_name name 'AxmHelixRadiusMove';
    function AxmHelixAngleMove; external dll_name name 'AxmHelixAngleMove';
    function AxmSplineWrite; external dll_name name 'AxmSplineWrite';

end.
