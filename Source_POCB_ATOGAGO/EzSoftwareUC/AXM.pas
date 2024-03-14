//*****************************************************************************
//*****************************************************************************
//**
//** File Name
//** ---------
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

//========== Board and module verification API(Info) - Information =================================================================================

// Return board number, module position and module ID of relevant axis. 
function AxmInfoGetAxis (lAxisNo : LongInt; lpBoardNo : PLongInt; lpModulePos : PLongInt; upModuleID : PDWord) : DWord; stdcall;
// Return whether the motion module exists.
function AxmInfoIsMotionModule (upStatus : PDWord) : DWord; stdcall;
// Return whether relevant axis is valid.
function AxmInfoIsInvalidAxisNo (szInvalidAxisNo : PChar) : DWord; stdcall;
// Return whether relevant axis status. 
function AxmInfoGetAxisStatus (lAxisNo : LongInt) : DWord; stdcall;
// number of RTEX Products, return number of valid axis installed in system.
function AxmInfoGetAxisCount (lpAxisCount : PLongInt) : DWord; stdcall;
// Return the first axis number of relevant board/module 
function AxmInfoGetFirstAxisNo (lBoardNo : LongInt; lModulePos : LongInt; lpAxisNo : PLongInt) : DWord; stdcall;    
//jhhwang!! function AxmInfoGetBoardFirstAxisNo (lBoardNo : LongInt; lModulePos : LongInt; lpAxisNo : PLongInt) : DWord; stdcall;

//========= virtual axis function ============================================================================================    

// Set virtual axis.
function AxmVirtualSetAxisNoMap (lRealAxisNo : LongInt; lVirtualAxisNo : LongInt) : DWord; stdcall;
// Return the set virtual channel(axis) number. 
function AxmVirtualGetAxisNoMap (lRealAxisNo : LongInt; lpVirtualAxisNo : PLongInt) : DWord; stdcall;
// Set multi-virtual axes. 
function AxmVirtualSetMultiAxisNoMap (lSize : LongInt; lpRealAxesNo : PLongInt; lpVirtualAxesNo : PLongInt) : DWord; stdcall;
// Return the set multi-virtual channel(axis) number.
function AxmVirtualGetMultiAxisNoMap (lSize : LongInt; lpRealAxesNo : PLongInt; lpVirtualAxesNo : PLongInt) : DWord; stdcall;
// Reset the virtual axis setting.
function AxmVirtualResetAxisMap () : DWord; stdcall;

//========= API related interrupt ======================================================================================    

// Call-back API method has the advantage which can be advised the event most fast timing as the call-back API is called immediately when the event occurs, but  
// the main processor shall be congested until the call-back API is completed. 
// i.e, it shall be carefully used when there is any work loaded in the call-bak API. 
// Event method monitors if interrupt occurs continuously by using thread, and when interrupt is occurs 
// it manages, and even though this method has disadvantage which system resource is occupied by thread , 
// it can detect interrupt most quickly and manage it. 
// It is not used a lot in general, but used when quick management of interrupt is the most concern. 
// Event method is operated using specific thread which monitors the occurrence of event separately from main processor , so 
// it able to use the resources efficiently in multi-processor system and expressly recommendable method. 

// Window message or call back API is used for getting the interrupt message. 
// (message handle, message ID, call back API, interrupt event)
//    hWnd    : use to get window handle and window message. Enter NULL if it is not used.
//    wMsg    : message of window handle, enter 0 if is not used or default value is used. 
//    proc    : API pointer to be called when interrupted, enter NULL if not use 
//    pEvent  : Event handle when event method is used. 
function AxmInterruptSetAxis (lAxisNo : LongInt; hWnd : HWND; uMessage : DWord; pProc : AXT_INTERRUPT_PROC; pEvent : PDWord) : DWord; stdcall;

// Set whether to use interrupt of set axis or not. 
// Set interrupt in the relevant axis/ verification
// uUse : use or not use => DISABLE(0), ENABLE(1)
function AxmInterruptSetAxisEnable (lAxisNo : LongInt; uUse : DWord) : DWord; stdcall;
// Return whether to use interrupt of set axis or not
function AxmInterruptGetAxisEnable (lAxisNo : LongInt; upUse : PDWord) : DWord; stdcall;

// Read relevant information when interrupt is used in event method
function AxmInterruptRead (lpAxisNo : PLongInt; upFlag : PDWord) : DWord; stdcall;    

// Return interrupt flag value of relevant axis.
function AxmInterruptReadAxisFlag (lAxisNo : LongInt; lBank : LongInt; upFlag : PDWord) : DWord; stdcall;

// Set whether the interrupt set by user to specific axis occurs or not
// lBank         : Enable to set interrupt bank number(0 - 1).
// uInterruptNum : Enable to set interrupt number by setting bit number( 0 - 31 ).
function AxmInterruptSetUserEnable (lAxisNo : LongInt; lBank : LongInt; uInterruptNum : DWord) : DWord; stdcall;

// Verify whether the interrupt set by user of specific axis occurs or not
function AxmInterruptGetUserEnable (lAxisNo : LongInt; lBank : LongInt; upInterruptNum : PDWord) : DWord; stdcall;

//======== set motion parameter ===========================================================================================================================================================
// If file is not loaded by AxmMotLoadParaAll, set default parameter in initial parameter setting. 
// Apply to all axes which is being used in PC equally. Default parameters are as below. 
// 00:AXIS_NO.             =0       01:PULSE_OUT_METHOD.    =4      02:ENC_INPUT_METHOD.    =3     03:INPOSITION.          =2
// 04:ALARM.               =0       05:NEG_END_LIMIT.       =0      06:POS_END_LIMIT.       =0     07:MIN_VELOCITY.        =1
// 08:MAX_VELOCITY.        =700000  09:HOME_SIGNAL.         =4      10:HOME_LEVEL.          =1     11:HOME_DIR.            =-1
// 12:ZPHASE_LEVEL.        =1       13:ZPHASE_USE.          =0      14:STOP_SIGNAL_MODE.    =0     15:STOP_SIGNAL_LEVEL.   =0
// 16:HOME_FIRST_VELOCITY. =10000   17:HOME_SECOND_VELOCITY.=10000  18:HOME_THIRD_VELOCITY. =2000  19:HOME_LAST_VELOCITY.  =100
// 20:HOME_FIRST_ACCEL.    =40000   21:HOME_SECOND_ACCEL.   =40000  22:HOME_END_CLEAR_TIME. =1000  23:HOME_END_OFFSET.     =0
// 24:NEG_SOFT_LIMIT.      =0.000   25:POS_SOFT_LIMIT.      =0      26:MOVE_PULSE.          =1     27:MOVE_UNIT.           =1
// 28:INIT_POSITION.       =1000    29:INIT_VELOCITY.       =200    30:INIT_ACCEL.          =400   31:INIT_DECEL.          =400
// 32:INIT_ABSRELMODE.     =0       33:INIT_PROFILEMODE.    =4

// 00=[AXIS_NO             ]: axis (start from 0axis)
// 01=[PULSE_OUT_METHOD    ]: Pulse out method TwocwccwHigh = 6
// 02=[ENC_INPUT_METHOD    ]: disable = 0   1 multiplication = 1  2 multiplication = 2  4 multiplication = 3, for replacing the direction of splicing (-).1 multiplication = 11  2 multiplication = 12  4 multiplication = 13
// 03=[INPOSITION          ], 04=[ALARM     ], 05,06 =[END_LIMIT   ]  : 0 = A contact 1= B contact 2 = not use. 3 = keep current mode
// 07=[MIN_VELOCITY        ]: START VELOCITY
// 08=[MAX_VELOCITY        ]: command velocity which driver can accept. Generally normal servo is 700k
// Ex> screw : 20mm pitch drive: 10000 pulse motor: 400w
// 09=[HOME_SIGNAL         ]: 4 - Home in0 , 0 :PosEndLimit , 1 : NegEndLimit // refer _HOME_SIGNAL.
// 10=[HOME_LEVEL          ]: : 0 = A contact 1= B contact 2 = not use. 3 = keep current mode
// 11=[HOME_DIR            ]: HOME DIRECTION 1:+direction, 0:-direction
// 12=[ZPHASE_LEVEL        ]: : 0 = A contact 1= B contact 2 = not use. 3 = keep current mode
// 13=[ZPHASE_USE          ]: use of Z phase. 0: not use , 1: - direction, 2: +direction 
// 14=[STOP_SIGNAL_MODE    ]: ESTOP, mode in use of SSTOP  0:slowdown stop, 1:emergency stop 
// 15=[STOP_SIGNAL_LEVEL   ]: ESTOP, SSTOP use level. : 0 = A contact 1= B contact 2 = not use. 3 = keep current mode 
// 16=[HOME_FIRST_VELOCITY ]: 1st move velocity 
// 17=[HOME_SECOND_VELOCITY]: velocity after detecting 
// 18=[HOME_THIRD_VELOCITY ]: the last velocity 
// 19=[HOME_LAST_VELOCITY  ]: velocity for index detecting and detail detecting 
// 20=[HOME_FIRST_ACCEL    ]: 1st acceleration, 21=[HOME_SECOND_ACCEL   ] : 2nd acceleration 
// 22=[HOME_END_CLEAR_TIME ]: queue time to set origin detecting Enc value,  23=[HOME_END_OFFSET] : move as much as offset after detecting of origin.
// 24=[NEG_SOFT_LIMIT      ]: - not use if set same as SoftWare Limit , 25=[POS_SOFT_LIMIT ]: - not use if set same as SoftWare Limit.
// 26=[MOVE_PULSE          ]: amount of pulse per driver revolution               , 27=[MOVE_UNIT  ]: travel distance per driver revolution :screw Pitch
// 28=[INIT_POSITION       ]: initial position when use agent , user can use optionally
// 29=[INIT_VELOCITY       ]: initial velocity when use agent, user can use optionally
// 30=[INIT_ACCEL          ]: initial acceleration when use agent, user can use optionally
// 31=[INIT_DECEL          ]: initial deceleration when use agent, user can use optionally
// 32=[INIT_ABSRELMODE     ]: absolute(0)/relative(1) set position
// 33=[INIT_PROFILEMODE    ]: set profile mode in (0 - 4) 
//                            '0': symmetry Trapezode, '1': asymmetric Trapezode, '2': symmetry Quasi-S Curve, '3':symmetry S Curve, '4':asymmetric S Curve
    
// load .mot file which is saved as AxmMotSaveParaAll. Optional modification is available by user. 
function AxmMotLoadParaAll (szFilePath : PChar) : DWord; stdcall;
// Save all parameter for all current axis by axis. Save as .mot file. Load file by using  AxmMotLoadParaAll. 
function AxmMotSaveParaAll (szFilePath : PChar) : DWord; stdcall;

// In parameter 28 - 31, user sets by using this API in the program. 
function AxmMotSetParaLoad (lAxisNo : LongInt; dInitPos : Double; dInitVel : Double; dInitAccel : Double; dInitDecel : Double) : DWord; stdcall;
// In parameter 28 - 31, user verifys by using this API in the program.
function AxmMotGetParaLoad (lAxisNo : LongInt; dpInitPos : PDouble; dpInitVel : PDouble; dpInitAccel : PDouble; dpInitDecel : PDouble) : DWord; stdcall;

//uMethod  0 :OneHighLowHigh, 1 :OneHighHighLow, 2 :OneLowLowHigh, 3 :OneLowHighLow, 4 :TwoCcwCwHigh
//         5 :TwoCcwCwLow,    6 :TwoCwCcwHigh,   7 :TwoCwCcwLow,   8 :TwoPhase,      9 :TwoPhaseReverse
//    OneHighLowHigh          = 0x0,        // 1 pulse method, PULSE(Active High), forward direction(DIR=Low)  / reverse direction(DIR=High)
//    OneHighHighLow          = 0x1,        // 1 pulse method, PULSE(Active High), forward direction (DIR=High) / reverse direction (DIR=Low)
//    OneLowLowHigh           = 0x2,        // 1 pulse method, PULSE(Active Low), forward direction (DIR=Low)  / reverse direction (DIR=High)
//    OneLowHighLow           = 0x3,        // 1 pulse method, PULSE(Active Low), forward direction (DIR=High) / reverse direction (DIR=Low)
//    TwoCcwCwHigh            = 0x4,        // 2 pulse method, PULSE(CCW: reverse direction),  DIR(CW: forward direction),  Active High
//    TwoCcwCwLow             = 0x5,        // 2 pulse method, PULSE(CCW: reverse direction),  DIR(CW: forward direction),  Active Low
//    TwoCwCcwHigh            = 0x6,        // 2 pulse method, PULSE(CW: forward direction),   DIR(CCW: reverse direction), Active High
//    TwoCwCcwLow             = 0x7,        // 2 pulse method, PULSE(CW: forward direction),   DIR(CCW: reverse direction), Active Low
//    TwoPhase                = 0x8,        // 2 phase (90' phase difference),  PULSE lead DIR(CW: forward direction), PULSE lag DIR(CCW: reverse direction)
//    TwoPhaseReverse         = 0x9         // 2 phase(90' phase difference),  PULSE lead DIR(CCW: Forward diredtion), PULSE lag DIR(CW: Reverse direction)
    
// Set the pulse output method of specific axis.
function AxmMotSetPulseOutMethod (lAxisNo : LongInt; uMethod : DWord) : DWord; stdcall;
// Return the setting of pulse output method of specific axis. 
function AxmMotGetPulseOutMethod (lAxisNo : LongInt; upMethod : PDWord) : DWord; stdcall;

// Set the Encoder input method including the setting of increase direction of actual count of specific axis. 
//    ObverseUpDownMode       = 0x0,        // Forward direction Up/Down
//    ObverseSqr1Mode         = 0x1,        // Forward direction 1 multiplication
//    ObverseSqr2Mode         = 0x2,        // Forward direction 2 multiplication
//    ObverseSqr4Mode         = 0x3,        // Forward direction 4 multiplication
//    ReverseUpDownMode       = 0x4,        // Reverse direction Up/Down
//    ReverseSqr1Mode         = 0x5,        // Reverse direction 1 multiplication
//    ReverseSqr2Mode         = 0x6,        // Reverse direction 2 multiplication
//    ReverseSqr4Mode         = 0x7         // Reverse direction 4 multiplication

function AxmMotSetEncInputMethod (lAxisNo : LongInt; uMethod : DWord) : DWord; stdcall;
// Return the Encoder input method including the setting of increase direction of actual count of specific axis.
function AxmMotGetEncInputMethod (lAxisNo : LongInt; upMethod : PDWord) : DWord; stdcall;

// If you want to set specified velocity unit in RPM(Revolution Per Minute),
// ex>    calculate rpm :
// 4500 rpm ?
// When unit/ pulse = 1 : 1, then it becomes pulse per sec, and
// if you want to set at 4500 rpm , then  4500 / 60 sec : 75 revolution / 1sec
// The number of pulse per 1 revolution of motor shall be known. This can be know by detecting of Z phase in Encoder. 
// If 1 revolution:1800 pulse,  75 x 1800 = 135000 pulses are required. 
// Operate by input Unit = 1, Pulse = 1800 into AxmMotSetMoveUnitPerPulse.
// Caution : If it is controlled with rpm, velocity and acceleration will be changed to rpm unit as well. 

// Set the travel distance of specific axis per pulse. 
function AxmMotSetMoveUnitPerPulse (lAxisNo : LongInt; dUnit : Double; lPulse : LongInt) : DWord; stdcall;
// Return the travel distance of specific axis per pulse.
function AxmMotGetMoveUnitPerPulse (lAxisNo : LongInt; dpUnit : PDouble; lpPulse : PLongInt) : DWord; stdcall;    

// Set deceleration starting point detecting method to specific axis. 
// AutoDetect 0x0 : automatic acceleration/deceleration.
// RestPulse  0x1 : manual acceleration/deceleration.
function AxmMotSetDecelMode (lAxisNo : LongInt; uMethod : DWord) : DWord; stdcall;
// Return the deceleration starting point detecting method of specific axis.
function AxmMotGetDecelMode (lAxisNo : LongInt; upMethod : PDWord) : DWord; stdcall;    

// Set remain pulse to the specific axis in manual deceleration mode.
function AxmMotSetRemainPulse (lAxisNo : LongInt; uData : DWord) : DWord; stdcall;
// Return remain pulse of the specific axis in manual deceleration mode.
function AxmMotGetRemainPulse (lAxisNo : LongInt; upData : PDWord) : DWord; stdcall;

// Set maximum velocity to the specific axis in uniform velocity movement API. 
function AxmMotSetMaxVel (lAxisNo : LongInt; dVel : Double) : DWord; stdcall;
// Return maximum velocity of the specific axis in uniform velocity movement API
function AxmMotGetMaxVel (lAxisNo : LongInt; dpVel : PDouble) : DWord; stdcall;

// Set travel distance calculation mode of specific axis.
//uAbsRelMode : POS_ABS_MODE '0' - absolute coordinate system
//              POS_REL_MODE '1' - relative coordinate system
function AxmMotSetAbsRelMode (lAxisNo : LongInt; uAbsRelMode : DWord) : DWord; stdcall;
// Return travel distance calculation mode of specific axis.
function AxmMotGetAbsRelMode (lAxisNo : LongInt; upAbsRelMode : PDWord) : DWord; stdcall;

//Set move velocity profile mode of specific axis. 
//ProfileMode : SYM_TRAPEZOIDE_MODE  '0' - symmetry Trapezode
//              ASYM_TRAPEZOIDE_MODE '1' - asymmetric Trapezode
//              QUASI_S_CURVE_MODE   '2' - symmetry Quasi-S Curve
//              SYM_S_CURVE_MODE     '3' - symmetry S Curve
//              ASYM_S_CURVE_MODE    '4' - asymmetric S Curve
function AxmMotSetProfileMode (lAxisNo : LongInt; uProfileMode : DWord) : DWord; stdcall;
// Return move velocity profile mode of specific axis.
function AxmMotGetProfileMode (lAxisNo : LongInt; upProfileMode : PDWord) : DWord; stdcall;    

//Set acceleration unit of specific axis.
//AccelUnit : UNIT_SEC2  '0' ? use unit/sec2 for the unit of acceleration/deceleration
//            SEC        '1' - use sec for the unit of acceleration/deceleration
function AxmMotSetAccelUnit (lAxisNo : LongInt; uAccelUnit : DWord) : DWord; stdcall;
// Return acceleration unit of specific axis.
function AxmMotGetAccelUnit (lAxisNo : LongInt; upAccelUnit : PDWord) : DWord; stdcall;

// Set initial velocity to the specific axis.
function AxmMotSetMinVel (lAxisNo : LongInt; dMinVel : Double) : DWord; stdcall;
// Return initial velocity of the specific axis.
function AxmMotGetMinVel (lAxisNo : LongInt; dpMinVel : PDouble) : DWord; stdcall;
// Set acceleration jerk value of specific axis.[%].
function AxmMotSetAccelJerk (lAxisNo : LongInt; dAccelJerk : Double) : DWord; stdcall;
// Return acceleration jerk value of specific axis.
function AxmMotGetAccelJerk (lAxisNo : LongInt; dpAccelJerk : PDouble) : DWord; stdcall;
// Set deceleration jerk value of specific axis.[%].
function AxmMotSetDecelJerk (lAxisNo : LongInt; dDecelJerk : Double) : DWord; stdcall;
// Return deceleration jerk value of specific axis.
function AxmMotGetDecelJerk (lAxisNo : LongInt; dpDecelJerk : PDouble) : DWord; stdcall;    

function AxmMotSetProfilePriority(lAxisNo : LongInt; uPriority : DWord) : DWord; stdcall;
function AxmMotGetProfilePriority(lAxisNo : LongInt; upPriority : PDWord) : DWord; stdcall;

//=========== Setting API related in/output signal ================================================================================

// Set Z phase level of specific axis.
// uLevel : LOW(0), HIGH(1)
function AxmSignalSetZphaseLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// Return Z phase level of specific axis.
function AxmSignalGetZphaseLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;

// Set output level of Servo-On signal of specific axis.
// uLevel : LOW(0), HIGH(1)
function AxmSignalSetServoOnLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// Return output level of Servo-On signal of specific axis.
function AxmSignalGetServoOnLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;

// Set output level of Servo-Alarm Reset signal of specific axis.
// uLevel : LOW(0), HIGH(1)
function AxmSignalSetServoAlarmResetLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// Return output level of Servo-Alarm Reset signal of specific axis.
function AxmSignalGetServoAlarmResetLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;

//    Set whether to use Inposition signal of specific axis and signal input level.
// uLevel : LOW(0), HIGH(1), UNUSED(2), USED(3)    
function AxmSignalSetInpos (lAxisNo : LongInt; uUse : DWord) : DWord; stdcall;
// Return whether to use Inposition signal of specific axis and signal input level.
function AxmSignalGetInpos (lAxisNo : LongInt; upUse : PDWord) : DWord; stdcall;
// Return inposition signal input mode of specific axis. 
function AxmSignalReadInpos (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;

//    Set whether to use emergency stop or not against to alarm signal input and set signal input level of specific axis. 
// uLevel : LOW(0), HIGH(1), UNUSED(2), USED(3)
function AxmSignalSetServoAlarm (lAxisNo : LongInt; uUse : DWord) : DWord; stdcall;
// Return whether to use emergency stop or not against to alarm signal input and set signal input level of specific axis.
function AxmSignalGetServoAlarm (lAxisNo : LongInt; upUse : PDWord) : DWord; stdcall;
// Return input level of alarm signal of specific axis.
function AxmSignalReadServoAlarm (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;

// Set whether to use end limit sensor of specific axis and input level of signal. 
// Available to set of slow down stop or emergency stop when end limit sensor is input.
// uStopMode: EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// uPositiveLevel, uNegativeLevel : LOW(0), HIGH(1), UNUSED(2), USED(3)
function AxmSignalSetLimit (lAxisNo : LongInt; uStopMode : DWord; uPositiveLevel : DWord; uNegativeLevel : DWord) : DWord; stdcall;
// Return whether to use end limit sensor of specific axis , input level of signal and stop mode for signal input. 
function AxmSignalGetLimit (lAxisNo : LongInt; upStopMode : PDWord; upPositiveLevel : PDWord; upNegativeLevel : PDWord) : DWord; stdcall;
// Return the input state of end limit sensor of specific axis. 
function AxmSignalReadLimit (lAxisNo : LongInt; upPositiveStatus : PDWord; upNegativeStatus : PDWord) : DWord; stdcall;

// Set whether to use software limit, count to use and stop method of specific axis.
// uUse       : DISABLE(0), ENABLE(1)
// uStopMode  : EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// uSelection : COMMAND(0), ACTUAL(1)
// Caution: When software limit is set in advance by using above API in origin detecting and is moving, if the detecting of origin is stopped during detecting, it becomes DISABLE.
function AxmSignalSetSoftLimit (lAxisNo : LongInt; uUse : DWord; uStopMode : DWord; uSelection : DWord; dPositivePos : Double; dNegativePos : Double) : DWord; stdcall;
// Return whether to use software limit, count to use and stop method of specific axis.
function AxmSignalGetSoftLimit (lAxisNo : LongInt; upUse : PDWord; upStopMode : PDWord; upSelection : PDWord; dpPositivePos : PDouble; dpNegativePos : PDouble) : DWord; stdcall;
function AxmSignalReadSoftLimit(lAxisNo : LongInt; upPositiveStatus : PDWord; upNegativeStatus : PDWord) : DWord; stdcall;

// Set the stop method of emergency stop(emergency stop/slowdown stop) ,or whether to use or not.
// uStopMode  : EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// uLevel     : LOW(0), HIGH(1), UNUSED(2), USED(3)
function AxmSignalSetStop (lAxisNo : LongInt; uStopMode : DWord; uLevel : DWord) : DWord; stdcall;
// Return the stop method of emergency stop(emergency stop/slowdown stop) ,or whether to use or not.
function AxmSignalGetStop (lAxisNo : LongInt; upStopMode : PDWord; upLevel : PDWord) : DWord; stdcall;
// Return input state of emergency stop.
function AxmSignalReadStop (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;

// Output the Servo-On signal of specific axis.
// uOnOff : FALSE(0), TRUE(1) ( The case of universal 0 output)
function AxmSignalServoOn (lAxisNo : LongInt; uOnOff : DWord) : DWord; stdcall;
// Return the output state of Servo-On signal of specific axis. 
function AxmSignalIsServoOn (lAxisNo : LongInt; upOnOff : PDWord) : DWord; stdcall;

// Output the Servo-Alarm Reset signal of specific axis.
// uOnOff : FALSE(0), TRUE(1) (The case of universal 1 output)
function AxmSignalServoAlarmReset (lAxisNo : LongInt; uOnOff : DWord) : DWord; stdcall;    

// Set universal output value.
// uValue : Hex Value 0x00
function AxmSignalWriteOutput (lAxisNo : LongInt; uValue : DWord) : DWord; stdcall;
// Return universal output value.
function AxmSignalReadOutput (lAxisNo : LongInt; upValue : PDWord) : DWord; stdcall;

// lBitNo : Bit Number(0 - 4)
// uOnOff : FALSE(0), TRUE(1)
// Set universal output values by bit.
function AxmSignalWriteOutputBit (lAxisNo : LongInt; lBitNo : LongInt; uOnOff : DWord) : DWord; stdcall;
// Return universal output values by bit.
function AxmSignalReadOutputBit (lAxisNo : LongInt; lBitNo : LongInt; upOnOff : PDWord) : DWord; stdcall;

// Return universal input value in Hex value.
function AxmSignalReadInput (lAxisNo : LongInt; upValue : PDWord) : DWord; stdcall;

// lBitNo : Bit Number(0 - 4)
// Return universal input value by bit. 
function AxmSignalReadInputBit (lAxisNo : LongInt; lBitNo : LongInt; upOn : PDWord) : DWord; stdcall;

// uSignal: END_LIMIT(0), INP_ALARM(1), UIN_00_01(2), UIN_02_04(3)
// dBandwidthUsec: 0.2uSec~26666uSec
function AxmSignalSetFilterBandwidth(lAxisNo : LongInt; uSignal : DWord; dBandwidthUsec : Double) : DWord; stdcall;

//========== API which verifies the state during motion moving and after moving. ============================================================

// Return pulse output state of specific axis. 
// (Status of move)
function AxmStatusReadInMotion (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;

//  Return move pulse counter value of specific axis after start of move. 
//  (pulse count value)
function AxmStatusReadDrivePulseCount (lAxisNo : LongInt; lpPulse : PLongInt) : DWord; stdcall;    

// Return DriveStatus register (status of in-motion) of specific Axis. 
// Caution: All Motion Product is different Hardware bit signal. Refer Manual and AXHS.xxx
function AxmStatusReadMotion (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;    

// Return EndStatus(status of stop) register of specific axis.
// Caution: All Motion Product is different Hardware bit signal. Refer Manual and AXHS.xxx
function AxmStatusReadStop (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;    

// Return Mechanical Signal Data(Current mechanical signal status)of specific axis.
// Caution: All Motion Product is different Hardware bit signal. Refer Manual and AXHS.xxx
function AxmStatusReadMechanical (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;    

// Read current move velocity oo specific axis.
function AxmStatusReadVel (lAxisNo : LongInt; dpVel : PDouble) : DWord; stdcall;    

// Return the error between Command Pos and Actual Pos of specific axis.
function AxmStatusReadPosError (lAxisNo : LongInt; dpError : PDouble) : DWord; stdcall;    

// Verify the travel(traveled) distance to the final drive.
function AxmStatusReadDriveDistance (lAxisNo : LongInt; dpUnit : PDouble) : DWord; stdcall;

// Set use the Position information Type of specific Axis. 
	// uPosType  : Select Position Information Type (Actual position / Command position)
	//    POSITION_LIMIT '0' - Normal action, In all round action.
	//    POSITION_BOUND '1' - Position cycle type, dNegativePos ~ dPositivePos Range
	// Caution(PCI-Nx04)
	// - BOUNT설정시 카운트 값이 Max값을 초과 할 때 Min값이되며 반대로 Min값을 초과 할 때 Max값이 된다.
	// - 다시말해 현재 위치값이 설정한 값 밖에서 카운트 될 때는 위의 Min, Max값이 적용되지 않는다.
function AxmStatusSetPosType(lAxisNo : LongInt; uPosType : DWord; dPositivePos : Double; dNegativePos : Double) : DWord; stdcall;
// Return the Position Information Type of of specific axis.
function AxmStatusGetPosType(lAxisNo : LongInt; upPosType : PDWord; dpPositivePos : PDouble; dpNegativePos : PDouble) : DWord; stdcall;
// Set absolute encoder origin offset Position of specific axis. [Only for PCI-R1604-MLII]
function AxmStatusSetAbsOrgOffset(lAxisNo : LongInt; dOrgOffsetPos : Double) : DWord; stdcall;

// Set the actual position of specific axis. 
function AxmStatusSetActPos (lAxisNo : LongInt; dPos : Double) : DWord; stdcall;
// Return the actual position of specific axis.
function AxmStatusGetActPos (lAxisNo : LongInt; dpPos : PDouble) : DWord; stdcall;

// Set command position of specific axis.
function AxmStatusSetCmdPos (lAxisNo : LongInt; dPos : Double) : DWord; stdcall;
// Return command position of specific axis.
function AxmStatusGetCmdPos (lAxisNo : LongInt; dpPos : PDouble) : DWord; stdcall;
// Set command position and actual position of specific axi
// Only RTEX use
function AxmStatusSetPosMatch(lAxisNo : LongInt; dPos : Double) : DWord; stdcall;

// Network function.
function AxmStatusRequestServoAlarm(lAxisNo : LongInt) : DWord; stdcall;   
function AxmStatusReadServoAlarm(lAxisNo : LongInt; uReturnMode : DWord; upAlarmCode : PDWord) : DWord; stdcall;
function AxmStatusGetServoAlarmString(lAxisNo : LongInt; uAlarmCode : DWord; lAlarmStringSize : LongInt; szAlarmString : PChar) : DWord; stdcall;  
function AxmStatusRequestServoAlarmHistory(lAxisNo : LongInt) : DWord; stdcall;  
function AxmStatusReadServoAlarmHistory(lAxisNo : LongInt; uReturnMode : DWord; lpCount : PLongInt; upAlarmCode : PDWord) : DWord; stdcall;  
function AxmStatusClearServoAlarmHistory(lAxisNo : LongInt) : DWord; stdcall;  

//======== API related home. ==========================================================================================================================
// Set home sensor level of specific axis. 
// uLevel : LOW(0), HIGH(1)
function AxmHomeSetSignalLevel (lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// Return home sensor level of specific axis.
function AxmHomeGetSignalLevel (lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;

// Verify current home signal input status. Hoe signal can be set by user optionally by using AxmHomeSetMethod API. 
// upStatus : OFF(0), ON(1)
function AxmHomeReadSignal (lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;

// Parameters related to origin detecting must be set in order to detect origin of relevant axis. 
// If the initialization is done properly by using MotionPara setting file, no separate setting is required.  
// In the setting of origin detecting method, direction of detecting proceed, signal to be used for origin, active level of origin sensor and detecting/no detecting of encoder Z phase are set. 
// Caution : When the level is set wrong, it may operate + direction even though ? direction is set, and may cause problem in finding home.
// (Refer the guide part of AxmMotSaveParaAll for detail information. )
// Use AxmSignalSetHomeLevel for home level.
// HClrTim : HomeClear Time : Queue time for setting origin detecting Encoder value. 
// HmDir(Home direction): DIR_CCW(0): - direction    , DIR_CW(1) = + direction   // HOffset ? traveled distance after detecting of origin. 
// uZphas: Set whether to detect of encoder Z phase after completion of the 1st detecting of origin. 
// HmSig : PosEndLimit(0) -> +Limit
//         NegEndLimit(1) -> -Limit
//         HomeSensor (4) -> origin sensor(universal input 0)    

function AxmHomeSetMethod (lAxisNo : LongInt; lHmDir : LongInt; uHomeSignal : DWord; uZphas : DWord; dHomeClrTime : Double; dHomeOffset : Double) : DWord; stdcall;
// Return set parameters related to home.
function AxmHomeGetMethod (lAxisNo : LongInt; lpHmDir : PLongInt; upHomeSignal : PDWord; upZphas : PDWord; dpHomeClrTime : PDouble; dpHomeOffset : PDouble) : DWord; stdcall;

function AxmHomeSetFineAdjust(lAxisNo : LongInt; dHomeDogLength : Double; lLevelScanTime : LongInt; uFineSearchUse : DWord; uHomeClrUse : DWord) : DWord; stdcall;
function AxmHomeGetFineAdjust(lAxisNo : LongInt; dpHomeDogLength : PDouble; lpLevelScanTime : PLongInt; upFineSearchUse : PDWord; upHomeClrUse : PDWord) : DWord; stdcall;

// Detect through several steps in order to detect origin quickly and precisely. Now, set velocities to be used for each step.  
// The time of origin detecting and the accuracy of origin detecting are decided by setting of these velocities. 
// Set velocity of origin detecting of each axis by changing velocities of each step.  
// (Refer the guide part of AxmMotSaveParaAll for detail information.)
// API which sets velocity to be used in origin detecting. 
// [dVelFirst]- 1st move velocity   [dVelSecond]- velocity after detecting   [dVelThird]- the last velocity  [dvelLast]- index detecting and in order to detect precisely. 
// [dAccFirst]- 1st move acceleration [dAccSecond]-acceleration after detecting.  
function AxmHomeSetVel (lAxisNo : LongInt; dVelFirst : Double; dVelSecond : Double; dVelThird : Double; dVelLast : Double; dAccFirst : Double; dAccSecond : Double) : DWord; stdcall;
// Return set velocity to be used in origin detecting. 
function AxmHomeGetVel (lAxisNo : LongInt; dpVelFirst : PDouble; dpVelSecond : PDouble; dpVelThird : PDouble; dpVelLast : PDouble; dpAccFirst : PDouble; dpAccSecond : PDouble) : DWord; stdcall;

// Start to detect origin.
// When origin detecting start API is executed, thread which will detect origin of relevant axis in the library is created automatically and it is automatically closed after carrying out of the origin detecting in sequence. 
function AxmHomeSetStart (lAxisNo : LongInt) : DWord; stdcall;
// User sets the result of origin detecting optionally. 
// When the detecting of origin is completed successfully by using origin detecting API, the result of detecting is set as HOME_SUCCESS.
// This API enables user to set result optionally without execution of origin detecting. 
// uHomeResult Setup
// HOME_SUCCESS              = 0x01,       
// HOME_SEARCHING            = 0x02,     
// HOME_ERR_GNT_RANGE        = 0x10, // Gantry Home Range Over
// HOME_ERR_USER_BREAK       = 0x11, // User Stop Command
// HOME_ERR_VELOCITY         = 0x12, // Velocity is very slow and fast
// HOME_ERR_AMP_FAULT        = 0x13, // Servo Drive Alarm 
// HOME_ERR_NEG_LIMIT        = 0x14, // (+)Limit sensor check (-)dir during Motion
// HOME_ERR_POS_LIMIT        = 0x15, // (-)Limit sensor check (+)dir during Motion
// HOME_ERR_NOT_DETECT       = 0x16, // not detect User set signal
// HOME_ERR_UNKNOWN          = 0xFF,

function AxmHomeSetResult (lAxisNo : LongInt; uHomeResult : DWord) : DWord; stdcall;
// Return the result of origin detecting. 
// Verify detecting result of origin detection API. When detecting of origin is started, it sets as HOME_SEARCHING, and if the detecting of origin is failed the reason of failure is set. Redo origin detecting after eliminating of failure reasons.
function AxmHomeGetResult (lAxisNo : LongInt; upHomeResult : PDWord) : DWord; stdcall;

// Return progress rate of origin detection.
// Progress rate can be verified when origin detection is commenced. When origin detection is completed, return 100% whether success or failure. The success or failure of origin detection result can be verified by using GetHome Result API.
// upHomeMainStepNumber : Progress rate of Main Step . 
// In case of gentry FALSE upHomeMainStepNumber : When 0 , only selected axis is in proceeding, home progress rate is indicated upHomeStepNumber.
// In case of gentry TRUE upHomeMainStepNumber : When 0, master home is in proceeding, master home progress rate is indicated upHomeStepNumber. 
// In case of gentry TRUE upHomeMainStepNumber : When 10 , slave home is in proceeding, master home progress rate is indicated upHomeStepNumber .
// upHomeStepNumber     : Indicate progress rate against to selected axis. 
// In case of gentry FALSE  : Indicate progress rate against to selected axis only.
// In case of gentry TRUE, progress rate is indicated by sequence of master axis and slave axis.
function AxmHomeGetRate (lAxisNo : LongInt; upHomeMainStepNumber : PDWord; upHomeStepNumber : PDWord) : DWord; stdcall;

//========= Position move API ===============================================================================================================    

// If you want to set specified velocity unit in RPM(Revolution Per Minute),
// ex>    calculate rpm :
// 4500 rpm ?
// When unit/ pulse = 1 : 1, then it becomes pulse per sec, and
// if you want to set at 4500 rpm , then  4500 / 60 sec : 75 revolution / 1sec
// The number of pulse per 1 revolution of motor shall be known. This can be know by detecting of Z phase in Encoder. 
// If 1 revolution:1800 pulse,  75 x 1800 = 135000 pulses are required. 
// Operate by input Unit = 1, Pulse = 1800 into AxmMotSetMoveUnitPerPulse.
    
// Travel up to set distance or position.
// It moves by set velocity and acceleration up to the position set by absolute coordinates/ relative coordinates of specific axis. 
// Velocity profile is set in AxmMotSetProfileMode API. 
// It separates from API at the timing of pulse output start.
function AxmMoveStartPos (lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// Travel up to set distance or position.
// It moves by set velocity and acceleration up to the position set by absolute coordinates/ relative coordinates of specific axis.
// Velocity profile is set in AxmMotSetProfileMode API
// It separates from API at the timing of pulse output finish.
function AxmMovePos (lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// Move by set velocity.
// It maintain velocity mode move by velocity and acceleration  set against to specific axis. 
// It separates from API at the timing of pulse output start.
// It moves toward to CW direction when Vel value is positive, CCW when negative.
function AxmMoveVel (lAxisNo : LongInt; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// It maintain velocity mode move by velocity and acceleration  set against to specific multi-axis.
// It separates from API at the timing of pulse output start.
// It moves toward to CW direction when Vel value is positive, CCW when negative.
function AxmMoveStartMultiVel (lArraySize : LongInt; lpAxesNo : PLongInt; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble) : DWord; stdcall;

function AxmMoveStartMultiVelEx(lArraySize : LongInt; lpAxesNo : PLongInt; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble; dwSyncMode : DWord) : DWord; stdcall;

function AxmMoveStartLineVel(lArraySize : LongInt; lpAxesNo : PLongInt; dpDis : PDouble; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// API which detects Edge of specific Input signal and makes emergency stop or slowdown stop. 
// lDetect Signal : Select input signal to detect . 
// lDetectSignal  : PosEndLimit(0), NegEndLimit(1), HomeSensor(4), EncodZPhase(5), UniInput02(6), UniInput03(7)
// Signal Edge    : Select edge direction of selected input signal (rising or falling edge).
//                  SIGNAL_DOWN_EDGE(0), SIGNAL_UP_EDGE(1)
// Move direction : CW when Vel value is positive, CCW when negative.
// SignalMethod   : EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// Caution: When SignalMethod is used as EMERGENCY_STOP(0), acceleration/deceleration is ignored and it is accelerated to specific velocity and emergency stop. 
//          lDetectSignal is PosEndLimit , in case of searching NegEndLimit(0,1) active status of signal level is detected.
function AxmMoveSignalSearch (lAxisNo : LongInt; dVel : Double; dAccel : Double; lDetectSignal : LongInt; lSignalEdge : LongInt; lSignalMethod : LongInt) : DWord; stdcall;    

// API which detects signal set in specific axis and travels in order to save the position. 
// In case of searching acting API to select and find desired signal, save the position and read the value using AxmGetCapturePos. 
// Signal Edge   : Select edge direction of selected input signal. (rising or falling edge).
//                 SIGNAL_DOWN_EDGE(0), SIGNAL_UP_EDGE(1)
// Move direction      : CW when Vel value is positive, CCW when negative.
// SignalMethod  : EMERGENCY_STOP(0), SLOWDOWN_STOP(1)
// lDetect Signal: Select input signal to detect edge .SIGNAL_DOWN_EDGE(0), SIGNAL_UP_EDGE(1)
//                 Select the motion action which COMMON(0) or SOFTWARE(0) by upper 8bit. Only for SMP Board(PCIe-Rxx05-MLIII).
// lDetectSignal : PosEndLimit(0), NegEndLimit(1), HomeSensor(4), EncodZPhase(5), UniInput02(6), UniInput03(7)
// lTarget       : COMMAND(0), ACTUAL(1)
// Caution: When SignalMethod is used as EMERGENCY_STOP(0), acceleration/deceleration is ignored and it is accelerated to specific velocity and emergency stop. 
// lDetectSignal is PosEndLimit , in case of searching NegEndLimit(0,1) active status of signal level is detected.
function AxmMoveSignalCapture (lAxisNo : LongInt; dVel : Double; dAccel : Double; lDetectSignal : LongInt; lSignalEdge : LongInt; lTarget : LongInt; lSignalMethod : LongInt) : DWord; stdcall;
// API which verifies saved position value in 'AxmMoveSignalCapture' API.
function AxmMoveGetCapturePos (lAxisNo : LongInt; dpCapPotition : PDouble) : DWord; stdcall;

// API which travels up to set distance or position.
// When execute API, it starts relevant motion action and escapes from API without waiting until motion is completed ”
function AxmMoveStartMultiPos (lArraySize : LongInt; lpAxisNo : PLongInt; dpPos : PDouble; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble) : DWord; stdcall;    

// Travels up to the distance which sets multi-axis or position. 
// It moves by set velocity and acceleration up to the position set by absolute coordinates of specific axis. specific axes.
function AxmMoveMultiPos (lArraySize : LongInt; lpAxisNo : PLongInt; dpPos : PDouble; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble) : DWord; stdcall;

// When execute API, it starts open-loop torque motion action of specific axis.(only for MLII, Sigma 5 servo drivers)
// dTroque        : Percentage value(%) of maximum torque. (negative value : CCW, positive value : CW)
// dVel           : Percentage value(%) of maximum velocity.
// dwAccFilterSel : LINEAR_ACCDCEL(0), EXPO_ACCELDCEL(1), SCURVE_ACCELDECEL(2)
// dwGainSel      : GAIN_1ST(0), GAIN_2ND(1)
// dwSpdLoopSel   : PI_LOOP(0), P_LOOP(1)
function AxmMoveStartTorque(lAxisNo : LongInt; dTorque : Double; dVel : Double; dwAccFilterSel : DWord; dwGainSel : DWord; dwSpdLoopSel : DWord) : DWord; stdcall;

// It stops motion during torque motion action.
// it can be only applied for AxmMoveStartTorque API.
function AxmMoveTorqueStop(lAxisNo : LongInt; dwMethod : DWord) : DWord; stdcall;

// To Move Set Position or distance
	// Absolute coordinates / position set to the coordinates relative to the set speed / acceleration rate to drive of specific Axis.
	// Velocity Profile is fixed Asymmetric trapezoid.
	// Accel/Decel Setting Unit is fixed Unit/Sec^2 
	// dAccel != 0.0 and dDecel == 0.0 일 경우 이전 속도에서 감속 없이 지정 속도까지 가속.
	// dAccel != 0.0 and dDecel != 0.0 일 경우 이전 속도에서 지정 속도까지 가속후 등속 이후 감속.
	// dAccel == 0.0 and dDecel != 0.0 일 경우 이전 속도에서 다음 속도까지 감속.

	// The following conditions must be satisfied.
	// dVel[1] == dVel[3] must be satisfied.
	// dVel [2] that can occur as a constant speed drive range is greater dPosition should be enough.
	// Ex) dPosition = 10000;
	// dVel[0] = 300., dAccel[0] = 200., dDecel[0] = 0.;    <== Acceleration
	// dVel[1] = 500., dAccel[1] = 100., dDecel[1] = 0.;    <== Acceleration
	// dVel[2] = 700., dAccel[2] = 200., dDecel[2] = 250.;  <== Acceleration, constant velocity, Deceleration
	// dVel[3] = 500., dAccel[3] = 0.,   dDecel[3] = 150.;  <== Deceleration
	// dVel[4] = 200., dAccel[4] = 0.,   dDecel[4] = 350.;  <== Deceleration
	// Exits API at the point that pulse out starts.
function AxmMoveStartPosWithList(lAxisNo : LongInt; dPosition : Double; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble; lListNum : LongInt) : DWord; stdcall;

// Is set by the distance to the target axis position or the position to increase or decrease the movement begins.
	// lEvnetAxisNo    : Start condition occurs axis.
	// dComparePosition: Conditions Occurrence Area of Start condition occurs axis.
	// uPositionSource : Set Conditions Occurrence Area of Start condition occurs axis => COMMAND(0), ACTUAL(1)
	// Cancellations after reservation AxmMoveStop, AxmMoveEStop, AxmMoveSStop use
	// Motion Axis and Start condition occurs axis must be In same group(case by 2V04 In same module).
function AxmMoveStartPosWithPosEvent(lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDccel : Double; lEventAxisNo : LongInt; dComparePosition : Double; uPositionSource : DWord) : DWord; stdcall;

// It slowdown stops by deceleration set for specific axis.
// dDecel : Deceleration value when stop. 
function AxmMoveStop (lAxisNo : LongInt; dDecel : Double) : DWord; stdcall;
function AxmMoveStopEx(lAxisNo : LongInt; dDecel : Double): DWord; stdcall;
// Stops specific axis emergently .
function AxmMoveEStop (lAxisNo : LongInt) : DWord; stdcall;
// Stops specific axis slow down. 
function AxmMoveSStop (lAxisNo : LongInt) : DWord; stdcall;

//========= Overdrive API ============================================================================

// Overdrives position.
// Adjust number of specific pulse before the move of specific axis is finished. 
// Cautions : In here when put in the position subjected to overdrive, as the travel distance is put into the position value of relative form,
//            position must be put in as position value of relative form.
function AxmOverridePos (lAxisNo : LongInt; dOverridePos : Double) : DWord; stdcall;

// Set the maximum velocity subjected to overdirve before velocity overdriving of specific axis. 
// Caution : If the velocity overdrive is done 5 times, the max velocity shall be set among them.  
function AxmOverrideSetMaxVel (lAxisNo : LongInt; dOverrideMaxVel : Double) : DWord; stdcall;    

// Overdrive velocity.
// Set velocity variably during the move of specific axis. (Make sure to set variably during the motion.)
// Caution: Before use of AxmOverrideVel API, set the maximum velocity which can be set by AxmOverrideMaxVel
// EX> If velocity overdrive two times, 
// 1. Set the highest velocity among the two as the highest setting velocity of AxmOverrideMaxVel.
// 2. Set the AxmOverrideVel  variably with the velocity in the moving of AxmMoveStartPos execution specific axis (including move API all) as the first velocity. 
// 3. Set the AxmOverrideVel  variably with the velocity in the moving of specific axis (including move API all) as the 2nd velocity.
function AxmOverrideVel (lAxisNo : LongInt; dOverrideVel : Double) : DWord; stdcall;    

// Overdrive velocity.
// Set velocity variably during the move of specific axis. (Make sure to set variably during the motion.)
// Caution: Before use of AxmOverrideAccelVelDecel API, set the maximum velocity which can be set by AxmOverrideMaxVel
// EX> If velocity overdrive two times, 
// 1. Set the highest velocity among the two as the highest setting velocity of AxmOverrideMaxVel.
// 2. Set the AxmOverrideAccelVelDecel  variably with the velocity in the moving of AxmMoveStartPos execution specific axis (including move API all) as the first velocity. 
// 3. Set the AxmOverrideAccelVelDecel  variably with the velocity in the moving of specific axis (including move API all) as the 2nd velocity.
function AxmOverrideAccelVelDecel (lAxisNo : LongInt; dOverrideVel : Double; dMaxAccel : Double; dMaxDecel : Double) : DWord; stdcall;    

// Velocity overdrive at certain timing. 
// API which becomes overdrive at the position when a certain position point and velocity to be overdrived
// lTarget : COMMAND(0), ACTUAL(1)
function AxmOverrideVelAtPos (lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double; dOverridePos : Double; dOverrideVel : Double; lTarget : LongInt) : DWord; stdcall;    
function AxmOverrideVelAtMultiPos (lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double; lArraySize : LongInt; dpOverridePos : PDouble; dpOverrideVel : PDouble; lTarget : LongInt; uOverrideMode : DWord) : DWord; stdcall;    
function AxmOverrideVelAtMultiPos2 (lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double; lArraySize : LongInt; dpOverridePos : PDouble; dpOverrideVel : PDouble; {dpOverrideVel : PDouble;} lTarget : LongInt; uOverrideMode : DWord) : DWord; stdcall;
//========= Move API by master, slave gear ration. ===========================================================================

// In Electric Gear mode, set gear ratio between master axis and slave axis. 
// dSlaveRatio : Gear ratio of slave against to master axis ( 0 : 0% , 0.5 : 50%, 1 : 100%)
function AxmLinkSetMode (lMasterAxisNo : LongInt; lSlaveAxisNo : LongInt; dSlaveRatio : Double) : DWord; stdcall;
// In Electric Gear mode, return gear ratio between master axis and slave axis.
function AxmLinkGetMode (lMasterAxisNo : LongInt; lpSlaveAxisNo : PLongInt; dpGearRatio : PDouble) : DWord; stdcall;
// Reset electric gear ration between Master axis and slave axis. 
function AxmLinkResetMode (lMasterAxisNo : LongInt) : DWord; stdcall;

//======== API related to gentry===========================================================================================================================================================
// Motion module supports gentry move system control which two axes are linked mechanically.. 
// When set master axis for gentry control by using this API, relevant slave axis synchronizes with master axis and moves.  
// However after setting of gentry, even if any move command or stop command is directed, they are ignored
// uSlHomeUse     : Whether to use home of slave axis or not ( 0 - 2)
//             (0 : Search home of master axis without using home of slave axis.)
//             (1 : Search home of master axis, slave axis. Compensating by applying slave dSlOffset value.)
//             (2 : Search home of master axis, slave axis. No compensating by applying slave dSlOffset value.))
// dSlOffset      : Offset value of slave axis
// dSlOffsetRange : Set offset value range of slave axis.
// Caution in use : When gentry is enabled, it is normal operation if the slave axis is verified as Inmotion by AxmStatusReadMotion API in its motion, and verified as True.  
 
//                When slave axis is verified by AxmStatusReadMotion, if InMotion is False then Gantry Enable is not available, therefore verify whether alarm hits limit. 

function AxmGantrySetEnable (lMasterAxisNo : LongInt; lSlaveAxisNo : LongInt; uSlHomeUse : DWord; dSlOffset : Double; dSlOffsetRange : Double) : DWord; stdcall;

// The method to know offset value of Slave axis.
// A. Servo-On both master and slave.         
// B. After set uSlHomeUse = 2 in AxmGantrySetEnableAPI, then search home by using  AxmHomeSetStart API. 
// C. After search home, twisted offset value of master axis and slave axis can be seen by reading command value of master axis.
// D. Read Offsetvalue, and put it into dSlOffset argument of AxmGantrySetEnable API.  
// E. As dSlOffset value is the slave axis value against to master axis, put its value with reversed sign as ?dSlOffset. 
// F. dSIOffsetRange means the range of Slave Offset, it is used to originate error when it is out of the specified range.    
// G. If the offset has been input into AxmGantrySetEnable API, in AxmGantrySetEnable API,after  set uSlHomeUse = 1 then search home by using AxmHomeSetStart API.          
    
// In gentry move, return parameter set by user. 
function AxmGantryGetEnable (lMasterAxisNo : LongInt; upSlHomeUse : PDWord; dpSlOffset : PDouble; dpSlORange : PDouble; upGatryOn : PDWord) : DWord; stdcall;
// Motion module releases gentry move system control which two axes are linked mechanically.
function AxmGantrySetDisable (lMasterAxisNo : LongInt; lSlaveAxisNo : LongInt) : DWord; stdcall;

//====Regular interpolation API ============================================================================================================================================;
// Do linear interpolate.
// API which moves multi-axis linear interpolation by specifying start point and ending point. It escapes from API after commencing of move.
// When it is used with AxmContiBeginNode and AxmContiEndNode, it becomes Save API in the queue which moves linear interpolation by specifying start point and ending point in the specified  coordinates system. 
// For the continuous interpolation move of linear profile, save it in internal queue and start by using AxmContiStart API.
function AxmLineMove (lCoord : LongInt; dpEndPos : PDouble; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// API which moves multi-axis linear interpolation by specifying start point and ending point. It escapes from API after commencing of move. (Software Core)
// When it is used with AxmContiBeginNode and AxmContiEndNode, it becomes Save API in the queue which moves linear interpolation by specifying start point and ending point in the specified  coordinates system. 
// For the continuous interpolation move of linear profile, save it in internal queue and start by using AxmContiStart API.
function AxmLineMoveEx2(lCoord : LongInt; dpEndPos : PDouble; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// Interpolate 2 axis arc
// API which moves arc interpolation by specifying start point, ending point and center point. It escapes from API after commencing of move.
// When it is used with AxmContiBeginNode and AxmContiEndNode, it becomes Save API in the arc interpolation queue which moves by specifying start point, ending point and center point in the specified  coordinates system. 
// For the profile arc continuous interpolation move, save it internal queue and start by using AxmContiStart API.
// lAxisNo = 2 axis array , dCenterPos = center point X,Y array , dEndPos = ending point X,Y array.
// uCWDir   DIR_CCW(0): Counterclockwise direction,   DIR_CW(1) Clockwise direction
function AxmCircleCenterMove (lCoord : LongInt; lAxisNo : PLongInt; dCenterPos : PDouble; dEndPos : PDouble; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord) : DWord; stdcall;

// API which arc interpolation moves by specifying middle point and ending point. It escapes from API after commencing of move.
// When it is used with AxmContiBeginNode and AxmContiEndNode, it becomes Save API in the arc interpolation queue which moves by specifying middle point and ending point in the specified  coordinates system. 
// For the profile arc continuous interpolation move, save it internal queue and start by using AxmContiStart API.
// lAxisNo = 2 axis array , dMidPos = middle point, X,Y array , dEndPos = ending point X,Y array, lArcCircle = arc(0), circle(1)
function AxmCirclePointMove (lCoord : LongInt; lAxisNo : PLongInt; dMidPos : PDouble; dEndPos : PDouble; dVel : Double; dAccel : Double; dDecel : Double; lArcCircle : LongInt) : DWord; stdcall;

// API which arc interpolation moves by specifying start point, ending point and radius. It escapes from API after commencing of move.
// When it is used with AxmContiBeginNode and AxmContiEndNode, it becomes Save API in the arc interpolation queue which moves by specifying start point, ending point and radius in the specified  coordinates system. 
// For the profile arc continuous interpolation move, save it internal queue and start by using AxmContiStart API.
// lAxisNo = 2 axis array , dRadius = radius, dEndPos = ending point X,Y array , uShortDistance = small circle(0), large circle(1)
// uCWDir   DIR_CCW(0): Counterclockwise direction,   DIR_CW(1) Clockwise direction
function AxmCircleRadiusMove (lCoord : LongInt; lAxisNo : PLongInt; dRadius : Double; dEndPos : PDouble; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord; uShortDistance : DWord) : DWord; stdcall;

// API which arc interpolation moves by specifying start point, revolution angle and radius. It escapes from API after commencing of move.
// When it is used with AxmContiBeginNode and AxmContiEndNode, 
// it becomes Save API in the arc interpolation queue which moves by specifying start point, revolution angle and radius in the specified  coordinates system. 
// For the profile arc continuous interpolation move, save it internal queue and start by using AxmContiStart API.
// lAxisNo = 2 axis array , dCenterPos = center point X,Y array , dAngle = angle.
// uCWDir   DIR_CCW(0): Counterclockwise direction,   DIR_CW(1) Clockwise direction
function AxmCircleAngleMove (lCoord : LongInt; lAxisNo : PLongInt; dCenterPos : PDouble; dAngle : Double; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord) : DWord; stdcall;

//==== continuous interpolation API ============================================================================================================================================;
//Set continuous interpolation axis mapping in specific coordinates system.
//(Start axis mapping number from 0)
// Caution: In the axis mapping, the input must be started from smaller number. 
//          In here, the axis of smallest number becomes master. 
function AxmContiSetAxisMap (lCoord : LongInt; lSize : LongInt; lpRealAxesNo : PLongInt) : DWord; stdcall;
// Return continuous interpolation axis mapping in specific coordinates system.
function AxmContiGetAxisMap (lCoord : LongInt; lpSize : PLongInt; lpRealAxesNo : PLongInt) : DWord; stdcall;    
    
// Set continuous interpolation axis absolute/relative mode in specific coordinates system.
// (Caution : available to use only after axis mapping)
// St travel distance calculation mode of specific axis.
//uAbsRelMode : POS_ABS_MODE '0' - absolute coordinate system
//              POS_REL_MODE '1' - relative coordinate system
function AxmContiSetAbsRelMode (lCoord : LongInt; uAbsRelMode : DWord) : DWord; stdcall;
// Return interpolation axis absolute/relative mode in specific coordinates system.
function AxmContiGetAbsRelMode (lCoord : LongInt; upAbsRelMode : PDWord) : DWord; stdcall;
// API which verifies whether internal Queue for the interpolation move is empty in specific coordinate system.
function AxmContiReadFree (lCoord : LongInt; upQueueFree : PDWord) : DWord; stdcall;
// API which verifies the number of interpolation move saved in internal Queue for the interpolation move in specific coordinate system 
function AxmContiReadIndex (lCoord : LongInt; lpQueueIndex : PLongInt) : DWord; stdcall;
// API which deletes all internal Queue saved for the continuous interpolation move in specific coordinate system 
function AxmContiWriteClear (lCoord : LongInt) : DWord; stdcall;

// Start registration of tasks to be executed in continuous interpolation at the specific  coordinate system. After call this API,
// all motion tasks to be executed before calling of AxmContiEndNode API are not execute actual motion, but are registered as continuous interpolation motion, 
// and when AxmContiStart API is called, then the registered motions execute actually
function AxmContiBeginNode (lCoord : LongInt) : DWord; stdcall;
// Finish registration of tasks to be executed in continuous interpolation at the specific  coordinate system.
function AxmContiEndNode (lCoord : LongInt) : DWord; stdcall;

// Start continuous interpolation.
// if dwProfileset is  CONTI_NODE_VELOCITY(0), use continuous interpolation.
//                     CONTI_NODE_MANUAL(1)  , set profile interpolation use. 
//                     CONTI_NODE_AUTO(2)    , use auto-profile interpolation.

function AxmContiStart (lCoord : LongInt; dwProfileset : DWord; lAngle : LongInt) : DWord; stdcall;
// API which verifies whether the continuous interpolation is moving in the specific coordinate system. 
function AxmContiIsMotion (lCoord : LongInt; upInMotion : PDWord) : DWord; stdcall;
// API which verifies the index number of the continuous interpolation that is being moving currently while the continuous interpolation is moving in the specific coordinate system. 
function AxmContiGetNodeNum (lCoord : LongInt; lpNodeNum : PLongInt) : DWord; stdcall;
// API which verifies the total number of continuous interpolation index that were set in  the specific coordinate system. 
function AxmContiGetTotalNodeNum (lCoord : LongInt; lpNodeNum : PLongInt) : DWord; stdcall;
//==================== trigger API ===============================================================================================================================

// Set whether to use of trigger function, output level, position comparator, trigger signal delay time and trigger output mode ino specific axis.
//  dTrigTime  : trigger output time 
//             : 1usec - max 50msec ( set 1 - 50000)
//  upTriggerLevel  : whether to use or not use     => LOW(0), HIGH(1), UNUSED(2), USED(3)
//  uSelect         : Standard position to use    => COMMAND(0), ACTUAL(1)
//  uInterrupt      : set interrupt        => DISABLE(0), ENABLE(1)
   
// Set trigger signal delay time , trigger output level and trigger output method in specific axis. 
function AxmTriggerSetTimeLevel (lAxisNo : LongInt; dTrigTime : Double; uTriggerLevel : DWord; uSelect : DWord; uInterrupt : DWord) : DWord; stdcall;
// Return trigger signal delay time , trigger output level and trigger output method to specific axis.
function AxmTriggerGetTimeLevel (lAxisNo : LongInt; dpTrigTime : PDouble; upTriggerLevel : PDWord; upSelect : PDWord; upInterrupt : PDWord) : DWord; stdcall;    

//  uMethod :   PERIOD_MODE   0x0 : cycle trigger method using trigger position value
//              ABS_POS_MODE  0x1 : Trigger occurs at trigger absolute position,  absolute position method
//  dPos : in case of cycle selection : the relevant position  for output by position and position. 
// in case of absolute selection: The position on which to output, If same as this position then output goes out unconditionally. 
function AxmTriggerSetAbsPeriod (lAxisNo : LongInt; uMethod : DWord; dPos : Double) : DWord; stdcall;

// Return whether to use of trigger function, output level, position comparator, trigger signal delay time and trigger output mode to specific axis.
function AxmTriggerGetAbsPeriod (lAxisNo : LongInt; upMethod : PDWord; dpPos : PDouble) : DWord; stdcall;

//  Output the trigger by regular interval from the starting position to the ending position specified by user. 
function AxmTriggerSetBlock (lAxisNo : LongInt; dStartPos : Double; dEndPos : Double; dPeriodPos : Double) : DWord; stdcall;
// Read trigger setting value of 'AxmTriggerSetBlock' API.
function AxmTriggerGetBlock (lAxisNo : LongInt; dpStartPos : PDouble; dpEndPos : PDouble; dpPeriodPos : PDouble) : DWord; stdcall;
// User outputs a trigger pulse.
function AxmTriggerOneShot (lAxisNo : LongInt) : DWord; stdcall;
// User outputs a trigger pulse after several seconds. 
function AxmTriggerSetTimerOneshot (lAxisNo : LongInt; lmSec : LongInt) : DWord; stdcall;
// Output absolute position trigger infinite absolute position output.
function AxmTriggerOnlyAbs (lAxisNo : LongInt; lTrigNum : LongInt; dpTrigPos : PDouble) : DWord; stdcall;
// Reset trigger settings.
function AxmTriggerSetReset (lAxisNo : LongInt) : DWord; stdcall;

//======== CRC( Remaining pulse clear API) =====================================================================    

//Level   : LOW(0), HIGH(1), UNUSED(2), USED(3) 
//uMethod : Available to set the width of remaining pulse eliminating output signal pulse in 2 - 6.
//          0: Don't care , 1: Don't care, 2: 500 uSec, 3:1 mSec, 4:10 mSec, 5:50 mSec, 6:100 mSec

//Set whether to use CRC signal in specific axis and output level.
function AxmCrcSetMaskLevel (lAxisNo : LongInt; uLevel : Dword; lMethod : Dword) : DWord; stdcall;
// Return whether to use CRC signal of specific axis and output level.
function AxmCrcGetMaskLevel (lAxisNo : LongInt; upLevel : PDWord; upMethod : PDword) : DWord; stdcall;

//uOnOff  : Whether to generate CRC signal to the Program or not.  (FALSE(0),TRUE(1))

// Force to generate CRC signal to the specific axis.
function AxmCrcSetOutput (lAxisNo : LongInt; uOnOff : DWord) : DWord; stdcall;
// Return whether to forcedly generate CRC signal of specific axis.
function AxmCrcGetOutput (lAxisNo : LongInt; upOnOff : PDWord) : DWord; stdcall;    

//====== MPG(Manual Pulse Generation) API ===========================================================

// lInputMethod : Available to set 0-3. 0:OnePhase, 1:TwoPhase1, 2:TwoPhase2, 3:TwoPhase4
// lDriveMode   : Available to set 0-5
//                0 : MPG continuous mode,             1 : MPG PRESET mode (Travel up to specific pulse), 2 : COMMAND ABSOLUTE MPG PRESET mode 
//                3 : ACTUAL ABSOLUTE MPG PRESET mode, 4 : COMMAND ABSOLUTE ZERO MPG PRESET mode,         5 : ACTUAL ABSOLUTE ZERO MPG PRESET mode 
// MPGPos        : the travel distance by every MPG input signal

// MPGdenominator: Divide value in MPG(Enter manual pulse generating device)movement
// dMPGnumerator : Product value in MPG(Enter manual pulse generating device)movement
// dwNumerator   : Available to set max(from 1 to  64) 
// dwDenominator : Available to set max(from 1 to  4096)
// dMPGdenominator = 4096 and MPGnumerator=1 mean that
// the output is 1 by 1 pulse as 1:1 if one turn of MPG is 200pulse. 
// If dMPGdenominator = 4096 and MPGnumerator=2 , then it means the output is 2 by 2 pulse as 1:2.  
// In here, MPG PULSE = ((Numerator) * (Denominator)/ 4096 ) It’s the calculation which outputs to the inside of chip.

// Set MPG input method, Drive move mode, travel distance, MPG velocity in specific axis.
function AxmMPGSetEnable (lAxisNo : LongInt; lInputMethod : LongInt; lDriveMode : LongInt; dMPGPos : Double; dVel : Double; dAcc : Double) : DWord; stdcall;
// Return MPG input method, Drive move mode, travel distance, MPG velocity in specific axis.
function AxmMPGGetEnable (lAxisNo : LongInt; lpInputMethod : PLongInt; lpDriveMode : PLongInt; dpMPGPos : PDouble; dpVel : PDouble) : DWord; stdcall;

// Set the pulse ratio to travel per pulse in MPG drive move mode to specific axis.
function AxmMPGSetRatio (lAxisNo : LongInt; dMPGnumerator : LongInt; dMPGdenominator : LongInt) : DWord; stdcall;
// Return the pulse ratio to travel per pulse in MPG drive move mode to specific axis.
function AxmMPGGetRatio (lAxisNo : LongInt; dpMPGnumerator : PLongInt; dpMPGdenominator : PLongInt) : DWord; stdcall;
// Release MPG drive settings to specific axis.
function AxmMPGReset (lAxisNo : LongInt) : DWord; stdcall;    

//======= Helical move ===========================================================================
// API which moves helical interpolation by specifying start point, ending point and center point to specific coordinate system.
// API which moves helical continuous interpolation by specifying start point, ending point and center point to specific coordinate system when it is used with AxmContiBeginNode and  AxmContiEndNode together.  
// API which saves in internal Queue in order to move the arc continuous interpolation. It is started using AxmContiStart API. ( It is used with continuous interpolation API together)
//dCenterPos = center point X,Y , dEndPos = ending point X,Y.
// uCWDir   DIR_CCW(0): Counterclockwise direction,   DIR_CW(1) Clockwise direction
function AxmHelixCenterMove (lCoord : LongInt; dCenterXPos : Double; dCenterYPos : Double; dEndXPos : Double; dEndYPos : Double; dZPos : Double; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord) : DWord; stdcall;

// API which moves helical interpolation by specifying start point, ending point and radius to specific coordinate system.
// API which moves helical continuous interpolation by specifying middle point and ending point to specific coordinate system when it is used with AxmContiBeginNode and  AxmContiEndNode together.  
// API which saves in internal Queue in order to move the arc continuous interpolation. It is started using AxmContiStart API. ( It is used with continuous interpolation API together)
// dMidPos = middle point X,Y  , dEndPos = ending point X,Y 
function AxmHelixPointMove (lCoord : LongInt; dMidXPos : Double; dMidYPos : Double; dEndXPos : Double; dEndYPos : Double; dZPos : Double; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// API which moves helical interpolation by specifying start point, ending point and radius to specific coordinate system.
// API which moves helical continuous interpolation by specifying middle point ,ending point and radius to specific coordinate system when it is used with AxmContiBeginNode and  AxmContiEndNode together.  
// API which saves in internal Queue in order to move the arc continuous interpolation. It is started using AxmContiStart API. ( It is used with continuous interpolation API together)
// dRadius = radius, dEndPos = ending point X,Y  , uShortDistance = small circle(0), large circle(1)
// uCWDir   DIR_CCW(0): Counterclockwise direction,   DIR_CW(1) Clockwise direction
function AxmHelixRadiusMove (lCoord : LongInt; dRadius : Double; dEndXPos : Double; dEndYPos : Double; dZPos : Double; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord; uShortDistance : DWord) : DWord; stdcall;

// API which moves helical interpolation by specifying start point, revolution angle and radius to specific coordinate system.
// API which moves helical continuous interpolation by specifying start point , revolution angle and radius to specific coordinate system when it is used with AxmContiBeginNode and  AxmContiEndNode together.
// API which saves in internal Queue in order to move the arc continuous interpolation. It is started using AxmContiStart API. ( It is used with continuous interpolation API together)
// dCenterPos = center point X,Y , dAngle = angle.
// uCWDir   DIR_CCW(0): Counterclockwise direction,   DIR_CW(1) Clockwise direction
function AxmHelixAngleMove (lCoord : LongInt; dCenterXPos : Double; dCenterYPos : Double; dAngle : Double; dZPos : Double; dVel : Double; dAccel : Double; dDecel : Double; uCWDir : DWord) : DWord; stdcall;

//======== Spline move =========================================================================== 

// It’s not used with AxmContiBeginNode and AxmContiEndNode together. 
// API which moves spline continuous interpolation. API which saves in internal Queue in order to move the arc continuous interpolation. 
//It is started using AxmContiStart API. ( It is used with continuous interpolation API together)

// lPosSize : Minimum more than 3 pieces.
// Enter 0 as for dPoZ value when it is used with 2 axes.
// Enter 3 piece as for axis mapping and dPosZ value when it is used with 3axes.
function AxmSplineWrite (lCoord : LongInt; lPosSize : LongInt; dpPosX : PDouble; dpPosY : PDouble; dVel : Double; dAccel : Double; dDecel : Double; dPosZ : Double; lPointFactor : LongInt) : DWord; stdcall;

//======== Compensation Table ====================================================================
// API which set the parameters for using the geometric compensation feature (Mechatrolink-II products)
// lNumEntry : minimum entries are 2, maximum entries are 512.
// dStartPos : starting relative position to apply the compensation.
// dpPosition, dpCorrection : arrays of position and correction values.
// bRollOver : enable/disable the roll over feature if the table can not cover the motor travel distance.
function AxmCompensationSet (lAxisNo : LongInt; lNumEntry : LongInt; dStartPos : Double; dpPosition : PDouble; dpCorrection : PDouble; lRollOver : LongInt) : DWord; stdcall;
// Return the number of entry, start position, array of position for moving, array of correction for compensating, setting RollOver feature on specific axis.
function AxmCompensationGet (lAxisNo : LongInt; lpNumEntry : PLongInt; dpStartPos : PDouble; dpPosition : PDouble; dpCorrection : PDouble; lpRollOver : PLongInt) : DWord; stdcall;
// API which enable/disable the compensation feature.
function AxmCompensationEnable (lAxisNo : LongInt; lEnable : LongInt) : DWord; stdcall;
// Return the setting enable/disable the compensation feature on specific axis.
function AxmCompensationIsEnable (lAxisNo : LongInt; lpEnable : PLongInt) : DWord; stdcall;
//jhhwang!! function AxmCompensationGetCorrection(lAxisNo : LongInt; dpCorrection : PDouble);

//======== Electronic CAM ========================================================================
// API which set the parameters for using the Ecam feature (Mechatrolink-II products)
// lAxisNo : one slave axis only has one master axis.
// lMasterAxis : one master axis can have more than one slave axis.
// lNumEntry : minimum entries are 2, maximum entries are 512.
// dMasterStartPos : starting relative position to apply Ecam on master axis.
// dpMasterPos, dpSlavePos : arrays of position values on master and slave axis.
function AxmEcamSet (lAxisNo : LongInt; lMasterAxis : LongInt; lNumEntry : LongInt; dMasterStartPos : Double; dpMasterPos : PDouble; dpSlavePos : PDouble) : DWord; stdcall;
//jhhwang!! function AxmEcamSetWithSource(lAxisNo : LongInt; lMasterAxis : LongInt; lNumEntry : LongInt; dMasterStartPos : Double; dpMasterPos : PDouble; dpSlavePos : PDouble;  dwSource : DWord);
// Return the number of master axis, entries, start position of master axis, array of position on master axis, array of position on slave axis.
function AxmEcamGet (lAxisNo : LongInt; lpMasterAxis : PLongInt; lpNumEntry : PLongInt; dpMasterStartPos : PDouble; dpMasterPos : PDouble; dpSlavePos : PDouble) : DWord; stdcall;
//jhhwang!! function AxmEcamGetWithSource(lAxisNo : LongInt; lpMasterAxis : PLongInt; lpNumEntry : PLongInt; dpMasterStartPos : PDouble; dpMasterPos : PDouble; dpSlavePos : PDouble; dwpSource : PDWord);
// API which enable the Ecam feature on slave axis.
function AxmEcamEnableBySlave (lAxisNo : LongInt; lEnable : LongInt) : DWord; stdcall;
// API which enable the Ecam feature on corresponding slave axes.
function AxmEcamEnableByMaster (lAxisNo : LongInt; lEnable : LongInt) : DWord; stdcall;
// Return the setting enable/disable the Ecam feature on slave axis.
function AxmEcamIsSlaveEnable (lAxisNo : LongInt; lpEnable : PLongInt) : DWord; stdcall;

//--------------------------------------------------------------------------------------------------------------------------------

//======== Servo Status Monitor =====================================================================================
// Set exception function of specific axis. (Only for MLII, Sigma-5)
function AxmStatusSetServoMonitor(lAxisNo : LongInt; dwSelMon : DWord; dActionValue : Double; dwAction : DWord) : DWord; stdcall;
// Return exception function of specific axis. (Only for MLII, Sigma-5)
function AxmStatusGetServoMonitor(lAxisNo : LongInt; dwSelMon : DWord; dpActionValue : PDouble; dwpAction : PDWord) : DWord; stdcall;
// Set exception function usage of specific axis. (Only for MLII, Sigma-5)
function AxmStatusSetServoMonitorEnable(lAxisNo : LongInt; dwEnable : DWord) : DWord; stdcall;
// Return exception function usage of specific axis. (Only for MLII, Sigma-5)
function AxmStatusGetServoMonitorEnable(lAxisNo : LongInt; dwpEnable : PDWord) : DWord; stdcall;

// Return exception function execution result Flag of specific axis. Auto reset after function execution. (Only for MLII, Sigma-5)
function AxmStatusReadServoMonitorFlag(lAxisNo : LongInt; dwSelMon : DWord; dwpMonitorFlag : PDWord; dpMonitorValue : PDouble) : DWord; stdcall;
// Return exception function monitoring information of specific axis. (Only for MLII, Sigma-5)
function AxmStatusReadServoMonitorValue(lAxisNo : LongInt; dwSelMon : DWord; dpMonitorValue : PDouble) : DWord; stdcall;
// Set load ratio monitor function of specific axis. (Only for MLII, Sigma-5)
// dwSelMon = 0 : Accumulated load ratio
// dwSelMon = 1 : Regenerative load ratio
// dwSelMon = 2 : Reference Torque load ratio
function AxmStatusSetReadServoLoadRatio(lAxisNo : LongInt; dwSelMon : DWord) : DWord; stdcall;
// Return load ratio of specific axis. (Only for MLII, Sigma-5)
function AxmStatusReadServoLoadRatio(lAxisNo : LongInt; dpMonitorValue : PDouble) : DWord; stdcall;

//======== Only for PCI-R1604-RTEX ==================================================================================
// Set RTEX A4Nx Scale Coefficient. (Only for RTEX, A4Nx)
function AxmMotSetScaleCoeff(lAxisNo : LongInt; lScaleCoeff : LongInt) : DWord; stdcall;
// Return RTEX A4Nx Scale Coefficient. (Only for RTEX, A4Nx)
function AxmMotGetScaleCoeff(lAxisNo : LongInt; lpScaleCoeff : PLongInt) : DWord; stdcall;
// Edge detection of specific Input Signal that stop or slow down to stop the function.
function AxmMoveSignalSearchEx(lAxisNo : LongInt; dVel : Double; dAccel : Double; lDetectSignal : LongInt; lSignalEdge : LongInt; lSignalMethod : LongInt) : DWord; stdcall;
//---------------------------------------------------------------------------------------------------------------------

//======== Only for PCI-R1604-MLII ==================================================================================
// Move to the set absolute position.
// Velocity profile use Trapezoid.
// Exits API at the point that pulse out starts.
// Always position(include -position), Velocity, Accel/Deccel Change possible.
function AxmMoveToAbsPos(lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;
// Return current drive velocity of specific axis.
function AxmStatusReadVelEx(lAxisNo : LongInt; dVel : Double; dAccel : Double; lDetectSignal : LongInt; lSignalEdge : LongInt; lSignalMethod : LongInt) : DWord; stdcall;

//======== Only for PCI-R1604-SSCNETIIIH ==================================================================================
// Set electric ratio. This parameter saved Non-volatile memory.
// Default value(lNumerator : 4194304(2^22), lDenominator : 10000)
// MR-J4-B is don't Setting electric ratio, Must be set from the host controller.
// No.PA06, No.PA07 of Existing Pulse type Servo Driver(MR-J4-A)
function AxmMotSetElectricGearRatio(lAxisNo : LongInt; lNumerator  : LongInt; lDenominator : LongInt) : DWord; stdcall;

// Return electric ratio of specific axis.
function AxmMotGetElectricGearRatio(lAxisNo : LongInt; lpNumerator : PLongInt; lpDenominator : PLongInt) : DWord; stdcall;

// Set limit torque value of specific axis.
// Forward, Backward drive torque limit function.
// Setting range 1 ~ 1000
// 0.1% of the maximum torque are controlled.
function AxmMotSetTorqueLimit(lAxisNo : LongInt; dbPluseDirTorqueLimit : Double; dbMinusDirTorqueLimit : Double) : DWord; stdcall;
// Return torque limit value of specific axis.
function AxmMotGetTorqueLimit(lAxisNo : LongInt; dbpPluseDirTorqueLimit : PDouble; dbpMinusDirTorqueLimit : PDouble) : DWord; stdcall;

function AxmOverridePosSetFunction(lAxisNo : LongInt; dwUsage : DWord; lDecelPosRatio: LongInt; dReserved : Double) : DWord; stdcall;

function AxmOverridePosGetFunction(lAxisNo : LongInt; dwpUsage : PDWord; lpDecelPosRatio: PLongInt; dpReserved : PDouble) : DWord; stdcall;

//======== Only For MLIII ==================================================================================================
//jhhwang!! function AxmServoCmdExecution(lAxisNo : LongInt; dwCommand : DWord; dwSize : DWord; pdwExcData : PDWord);

//======== Only For SMP ==================================================================================================
//jhhwang!! function AxmSignalSetInposRange(lAxisNo : LongInt; dInposRange : Double);
//jhhwang!! function AxmSignalGetInposRange(lAxisNo : LongInt; dpInposRange : PDouble);

//jhhwang!! function AxmMotSetOverridePosMode(lAxisNo : LongInt; dwAbsRelMode : DWord);
//jhhwang!! function AxmMotGetOverridePosMode(lAxisNo : LongInt; dwpAbsRelMode : PDWord);
//jhhwang!! function AxmMotSetOverrideLinePosMode(lCoordNo : LongInt; dwAbsRelMode : DWord);
//jhhwang!! function AxmMotGetOverrideLinePosMode(lCoordNo : LongInt; dwpAbsRelMode : PDWord);

//jhhwang!! function AxmMoveStartPosEx(lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double; dEndVel : Double);
//jhhwang!! function AxmMovePosEx(lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double; dEndVel : Double);

//jhhwang!! function AxmMoveCoordStop(lCoordNo : LongInt; dDecel : Double);
//jhhwang!! function AxmMoveCoordEStop(lCoordNo : LongInt);
//jhhwang!! function AxmMoveCoordSStop(lCoordNo : LongInt);

//jhhwang!! function AxmOverrideLinePos(lCoordNo : LongInt; dpOverridePos : PDouble);
//jhhwang!! function AxmOverrideLineVel(lCoordNo : LongInt; dOverrideVel : Double; dpDistance : PDouble);

//jhhwang!! function AxmOverrideLineAccelVelDecel(lCoordNo : LongInt; dOverrideVelocity : Double; dMaxAccel : Double; dMaxDecel : Double dpDistance : PDouble);
//jhhwang!! function AxmOverrideAccelVelDecelAtPos(lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double; dOverridePos : Double; dOverrideVel : Double; dOverrideAccel : Double; dOverrideDecel : Double; lTarget : LongInt);

//jhhwang!! function AxmEGearSet(lMasterAxisNo : LongInt; lSize : LongInt; lpSlaveAxisNo : LongInt; dpGearRatio : PDouble);
//jhhwang!! function AxmEGearGet(lMasterAxisNo : LongInt; lpSize : PLongInt; lpSlaveAxisNo : PLongInt; dpGearRatio : PDouble);
//jhhwang!! function AxmEGearReset(lMasterAxisNo : LongInt);
//jhhwang!! function AxmEGearEnable(lMasterAxisNo : LongInt; dwEnable : DWord);
//jhhwang!! function AxmEGearIsEnable(lMasterAxisNo : LongInt; dwpEnable : PDWord);

//jhhwang!! function AxmMotSetEndVel(lAxisNo : LongInt; dEndVelocity : Double);
//jhhwang!! function AxmMotGetEndVel(lAxisNo : LongInt; dpEndVelocity : PDouble);

//------------------------------------------------------------------------------------------------------------------

implementation

const

    dll_name    = 'Axl.dll';

    function AxmInfoGetAxis; external dll_name name 'AxmInfoGetAxis';
    function AxmInfoIsMotionModule; external dll_name name 'AxmInfoIsMotionModule';
    function AxmInfoIsInvalidAxisNo; external dll_name name 'AxmInfoIsInvalidAxisNo';
    function AxmInfoGetAxisStatus; external dll_name name 'AxmInfoGetAxisStatus';    
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
    function AxmSignalReadSoftLimit; external dll_name name 'AxmSignalReadSoftLimit';
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
    function AxmSignalSetFilterBandwidth; external dll_name name 'AxmSignalSetFilterBandwidth';

    function AxmStatusReadInMotion; external dll_name name 'AxmStatusReadInMotion';
    function AxmStatusReadDrivePulseCount; external dll_name name 'AxmStatusReadDrivePulseCount';
    function AxmStatusReadMotion; external dll_name name 'AxmStatusReadMotion';
    function AxmStatusReadStop; external dll_name name 'AxmStatusReadStop';
    function AxmStatusReadMechanical; external dll_name name 'AxmStatusReadMechanical';
    function AxmStatusReadVel; external dll_name name 'AxmStatusReadVel';
    function AxmStatusReadPosError; external dll_name name 'AxmStatusReadPosError';
    function AxmStatusReadDriveDistance; external dll_name name 'AxmStatusReadDriveDistance';
    function AxmStatusSetPosType; external dll_name name 'AxmStatusSetPosType';
    function AxmStatusGetPosType; external dll_name name 'AxmStatusGetPosType';
    function AxmStatusSetAbsOrgOffset; external dll_name name 'AxmStatusSetAbsOrgOffset';
    function AxmStatusSetActPos; external dll_name name 'AxmStatusSetActPos';
    function AxmStatusGetActPos; external dll_name name 'AxmStatusGetActPos';
    function AxmStatusSetCmdPos; external dll_name name 'AxmStatusSetCmdPos';
    function AxmStatusGetCmdPos; external dll_name name 'AxmStatusGetCmdPos';
    function AxmStatusSetPosMatch; external dll_name name 'AxmStatusSetPosMatch';
    function AxmStatusRequestServoAlarm; external dll_name name 'AxmStatusRequestServoAlarm';
    function AxmStatusReadServoAlarm; external dll_name name 'AxmStatusReadServoAlarm';
    function AxmStatusGetServoAlarmString; external dll_name name 'AxmStatusGetServoAlarmString';
    function AxmStatusRequestServoAlarmHistory; external dll_name name 'AxmStatusRequestServoAlarmHistory';
    function AxmStatusReadServoAlarmHistory; external dll_name name 'AxmStatusReadServoAlarmHistory';
    function AxmStatusClearServoAlarmHistory; external dll_name name 'AxmStatusClearServoAlarmHistory';

    function AxmHomeSetSignalLevel; external dll_name name 'AxmHomeSetSignalLevel';
    function AxmHomeGetSignalLevel; external dll_name name 'AxmHomeGetSignalLevel';
    function AxmHomeReadSignal; external dll_name name 'AxmHomeReadSignal';
    function AxmHomeSetMethod; external dll_name name 'AxmHomeSetMethod';
    function AxmHomeGetMethod; external dll_name name 'AxmHomeGetMethod';
    function AxmHomeSetFineAdjust; external dll_name name 'AxmHomeSetFineAdjust';
    function AxmHomeGetFineAdjust; external dll_name name 'AxmHomeGetFineAdjust';
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
    function AxmMoveStartMultiVelEx; external dll_name name 'AxmMoveStartMultiVelEx';    
    function AxmMoveStartLineVel; external dll_name name 'AxmMoveStartLineVel';
    function AxmMoveSignalSearch; external dll_name name 'AxmMoveSignalSearch';
    function AxmMoveSignalCapture; external dll_name name 'AxmMoveSignalCapture';
    function AxmMoveGetCapturePos; external dll_name name 'AxmMoveGetCapturePos';
    function AxmMoveStartMultiPos; external dll_name name 'AxmMoveStartMultiPos';
    function AxmMoveMultiPos; external dll_name name 'AxmMoveMultiPos';

    function AxmMoveStartTorque; external dll_name name 'AxmMoveStartTorque';
    function AxmMoveTorqueStop; external dll_name name 'AxmMoveTorqueStop';

    function AxmMoveStartPosWithList; external dll_name name 'AxmMoveStartPosWithList';
    function AxmMoveStartPosWithPosEvent; external dll_name name 'AxmMoveStartPosWithPosEvent';

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
//jhhwang!!     function AxmGantrySetCompensationGain; external dll_name name 'AxmGantrySetCompensationGain';
//jhhwang!!     function AxmGantryGetCompensationGain; external dll_name name 'AxmGantryGetCompensationGain';

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

    function AxmCompensationSet; external dll_name name 'AxmCompensationSet';
    function AxmCompensationGet; external dll_name name 'AxmCompensationGet';
    function AxmCompensationEnable; external dll_name name 'AxmCompensationEnable';
    function AxmCompensationIsEnable; external dll_name name 'AxmCompensationIsEnable';

    function AxmEcamSet; external dll_name name 'AxmEcamSet';
    function AxmEcamGet; external dll_name name 'AxmEcamGet';
    function AxmEcamEnableBySlave; external dll_name name 'AxmEcamEnableBySlave';
    function AxmEcamEnableByMaster; external dll_name name 'AxmEcamEnableByMaster';
    function AxmEcamIsSlaveEnable; external dll_name name 'AxmEcamIsSlaveEnable';   
    
    function AxmStatusSetServoMonitor; external dll_name name 'AxmStatusSetServoMonitor';   
    function AxmStatusGetServoMonitor; external dll_name name 'AxmStatusGetServoMonitor';   
    function AxmStatusSetServoMonitorEnable; external dll_name name 'AxmStatusSetServoMonitorEnable';   
    function AxmStatusGetServoMonitorEnable; external dll_name name 'AxmStatusGetServoMonitorEnable';   
    function AxmStatusReadServoMonitorFlag; external dll_name name 'AxmStatusReadServoMonitorFlag';   
    function AxmStatusReadServoMonitorValue; external dll_name name 'AxmStatusReadServoMonitorValue';
    function AxmStatusSetReadServoLoadRatio; external dll_name name 'AxmStatusSetReadServoLoadRatio';
    function AxmStatusReadServoLoadRatio; external dll_name name 'AxmStatusReadServoLoadRatio'; 
    function AxmMotSetScaleCoeff; external dll_name name 'AxmMotSetScaleCoeff';   
    function AxmMotGetScaleCoeff; external dll_name name 'AxmMotGetScaleCoeff';   
    function AxmMoveSignalSearchEx; external dll_name name 'AxmMoveSignalSearchEx';
    function AxmMoveToAbsPos; external dll_name name 'AxmMoveToAbsPos';
    function AxmStatusReadVelEx; external dll_name name 'AxmStatusReadVelEx';
    
    function AxmMotSetElectricGearRatio; external dll_name name 'AxmMotSetElectricGearRatio';
    function AxmMotGetElectricGearRatio; external dll_name name 'AxmMotGetElectricGearRatio';
    function AxmMotSetTorqueLimit; external dll_name name 'AxmMotSetTorqueLimit';
    function AxmMotGetTorqueLimit; external dll_name name 'AxmMotGetTorqueLimit';
    function AxmOverridePosSetFunction; external dll_name name 'AxmOverridePosSetFunction';
    function AxmOverridePosGetFunction; external dll_name name 'AxmOverridePosGetFunction';

    function AxmMoveStopEx; external dll_name name 'AxmMoveStopEx';
    function AxmLineMoveEx2; external dll_name name 'AxmLineMoveEx2';
//jhhwang!!     function AxmCompensationGetCorrection; external dll_name name 'AxmCompensationGetCorrection';
//jhhwang!!     function AxmEcamSetWithSource; external dll_name name 'AxmEcamSetWithSource';
//jhhwang!!     function AxmEcamGetWithSource; external dll_name name 'AxmEcamGetWithSource';
    function AxmOverrideVelAtMultiPos2; external dll_name name 'AxmOverrideVelAtMultiPos2';

//jhhwang!!     function AxmServoCmdExecution; external dll_name name 'AxmServoCmdExecution';

//jhhwang!!     function AxmSignalSetInposRange; external dll_name name 'AxmSignalSetInposRange';
//jhhwang!!     function AxmSignalGetInposRange; external dll_name name 'AxmSignalGetInposRange';
//jhhwang!!     function AxmMotSetOverridePosMode; external dll_name name 'AxmMotSetOverridePosMode';
//jhhwang!!     function AxmMotGetOverridePosMode; external dll_name name 'AxmMotGetOverridePosMode';
//jhhwang!!     function AxmMotSetOverrideLinePosMode; external dll_name name 'AxmMotSetOverrideLinePosMode';
//jhhwang!!     function AxmMotGetOverrideLinePosMode; external dll_name name 'AxmMotGetOverrideLinePosMode';
//jhhwang!!     function AxmMoveStartPosEx; external dll_name name 'AxmMoveStartPosEx';
//jhhwang!!     function AxmMovePosEx; external dll_name name 'AxmMovePosEx';
//jhhwang!!     function AxmMoveCoordStop; external dll_name name 'AxmMoveCoordStop';
//jhhwang!!     function AxmMoveCoordEStop; external dll_name name 'AxmMoveCoordEStop';
//jhhwang!!     function AxmMoveCoordSStop; external dll_name name 'AxmMoveCoordSStop';
//jhhwang!!     function AxmOverrideLinePos; external dll_name name 'AxmOverrideLinePos';
//jhhwang!!     function AxmOverrideLineVel; external dll_name name 'AxmOverrideLineVel';
//jhhwang!!     function AxmOverrideLineAccelVelDecel; external dll_name name 'AxmOverrideLineAccelVelDecel';
//jhhwang!!     function AxmOverrideAccelVelDecelAtPos; external dll_name name 'AxmOverrideAccelVelDecelAtPos';
//jhhwang!!     function AxmEGearSet; external dll_name name 'AxmEGearSet';
//jhhwang!!     function AxmEGearGet; external dll_name name 'AxmEGearGet';
//jhhwang!!     function AxmEGearReset; external dll_name name 'AxmEGearReset';
//jhhwang!!     function AxmEGearEnable; external dll_name name 'AxmEGearEnable';
//jhhwang!!     function AxmEGearIsEnable; external dll_name name 'AxmEGearIsEnable';
//jhhwang!!     function AxmMotSetEndVel; external dll_name name 'AxmMotSetEndVel';
//jhhwang!!     function AxmMotGetEndVel; external dll_name name 'AxmMotGetEndVel';
end.
