unit EziMLDef;

interface

uses  Winapi.Windows, System.SysUtils,  System.Classes;

const

  //----------------------------------------------------------------------------
  // EziMotionPE - API Error Code
  //  - Reference: EziMOTIONLINK PlusE Manual - Communication - 2.1 ~ 2.2
  //  - C:\Program Files (x86)\FASTECH\Ezi-MOTION Plus-E V6\Include\ReturnCodes_Define.h
  //----------------------------------------------------------------------------
  FMM_OK                  = 0;    //정상 (정상적으로 명령을 수행)
  FMM_NOT_OPEN            = 1;    //입력에러 (COM Port가 연결되지 않음) ...Not for EziMotionPE
  FMM_INVALID_PORT_NUM    = 2;    //입력에러 (연결되지 않은 Port 번호) ...Not for EziMotionPE
  FMM_INVALID_SLAVE_NUM   = 3;    //입력에러 (잘못된 Board 번호 입력)
  //
  FMC_DISCONNECTED        = 5;    //연결에러 (해당 Board가 연결 해제)
  FMC_TIMEOUT_ERROR       = 6;    //연결에러 (정해진 시간 100msec동안 응답이 없음)
  FMC_CRCFAILED_ERROR     = 7;    //연결에러 (통신 중 Checksum 에러 발생) ...Not for EziMotionPE
	FMC_RECVPACKET_ERROR    = 8;    //연결에러 (Ezi-XXXX로부터 받은 패킷에서 프로토콜 레벨의 에러 발생, e.g., Packet Size Error)
  FMM_POSTABLE_ERROR      = 9;    //운전에러 (포지션 테이블 관련 함수의 실행 중 오류 발생. 예, 읽기/쓰기 등)
  //
  FMP_FRAMETYPEERROR      = 128;  //입력에러 (Board가 인식하지 못하는 명령어) ..0x80
  FMP_DATAERROR           = 129;  //입력에러 (입력한 데이터가 범위를 벗어남)
	FMP_PACKETERROR         = 130;  //연결에러 (Ezi-XXXX가 받은 패킷에서 프로토콜 레벨의 에러 발생. 예, 길이 등)
  //
	FMP_RUNFAIL             = 133;  //운전에러 (모터가 이미 운전중이거나 운전할 수 있는 준비가 되어 있지 않는 등 잘못된 명령)
                                  //    - 현재 모터가 운전 중, 정지 명령 중, Servo OFF 상태,
                                  //    - 외부 엔코더없이 Z-pulse Origin을 시도, 기타 잘못된 운전 명령
  FMP_RESETFAIL           = 134;  //운전에러 (Servo ON 상태에서 Alaem Reset 명령을 실행할 수 없음)
                                  //    - Servo ON 상태, 외부 입력 신호에 의해 이미 Reset 상태
	FMP_SERVOONFAIL1        = 135;  //운전에러 (Alarm이 발생한 상태: 알람 발생 중에 Servo ON 명령을 시도)
	FMP_SERVOONFAIL2        = 136;  //운전에러 (Emergency Stop 중: 비상 정지 중에 Servo ON 명령을 시도)
	FMP_SERVOONFAIL3        = 137;  //운전에러 (Servo ON 신호가 외부 입력신호에 할당되어 있어 실행할 수 없음)
  FMP_SERVOOFF_FAIL       = 138;  //운전에러 (Servo ON 과정이 진행 중)  ..Not for EziMotionPE?
  FMP_ROMACCESS           = 139;  //운전에러 (Servo ON 과정이 진행 중)  ..Not for EziMotionPE?
  //
  FMP_PACKETCRCERROR      = 170;  //연결에러 (Ezi-XXXX가 받은 패킷의 CRC 계산값이 일치하지 않음) ...Not for EziMotionPE
  //
  FMM_UNKNOWN_ERROR       = 255;  //

  //============================================================================
  // Reference: \FASTECH\Ezi-MOTION Plus-E V6\Include\MOTION_DEFINE.h, Device Tye Defines
  //    - Device Type Definition
  //    - Motion Direction
  //    - Axis Status Flag
  //    - for GetAllStatusEx Function
  //    - Input/Output Assigning Defines
  //    - PT(POSITION TABLE) Defines (enum COMMAND_LIST, Offset, ...)
  //    - EX Commands Option Defines.
  //    - Alarm (enum ALARM_TYPE)
  //    - Drive Information Define
  //    - I/O Module Define
  //    - Ez-IO Plus-AD Defines
  //    - LOG Level (enum LOG_LEVEL)
  //============================================================================

  //----------------------------------------------------------------------------
  // Device Type Definition
  //  - for MotionLink
  DEVTYPE_EZI_MOTIONLINK			= 10;
  DEVNAME_EZI_MOTIONLINK			= 'Ezi-MotionLink';
  DEVTYPE_EZI_MOTIONLINK2			= 11;
  DEVNAME_EZI_MOTIONLINK2			= 'Ezi-MotionLink2';
  //  - for MotionLink (V8)
  DEVTYPEV8_EZI_MOTIONLINK		= 10;   // Driver Type B group : only Motion Controller (without Drive) family
  DEVNAMEV8_EZI_MOTIONLINK	  = 'Ezi-MotionLink';
  DEVTYPEV8_EZI_MOTIONLINK2		= 110;  // Driver Type F group : only Motion Controller (without Drive) family
  DEVNAMEV8_EZI_MOTIONLINK2		= 'Ezi-MotionLink2';
  //  - Etc
  DEVTYPE_BOOT_ROM						= $FF;
  DEVTYPE_BOOT_ROM_2					= $FE;

  //----------------------------------------------------------------------------
  // Motion Direction Defines
  EZI_MOTION_DIR_DEC      = 0;
  EZI_MOTION_DIR_INC      = 1;

  //----------------------------------------------------------------------------
  // Axis Status Flag
  EZI_MAX_AXIS_STATUS		  = 32;

  //----------------------------------------------------------------------------
  // for GetAllStatusEx Function
  EZI_ALLSTATUSEX_ITEM_COUNT	    =	12;
  //
  EZI_STATUSEX_TYPE_NONE			    = 0;
  EZI_STATUSEX_TYPE_INPUT			    = 1;
  EZI_STATUSEX_TYPE_OUTPUT		    = 2;
  EZI_STATUSEX_TYPE_AXISSTATUS	  = 3;
  EZI_STATUSEX_TYPE_CMDPOS		    = 4;
  EZI_STATUSEX_TYPE_ACTPOS		    = 5;
  EZI_STATUSEX_TYPE_ACTVEL		    = 6;
  EZI_STATUSEX_TYPE_POSERR		    = 7;
  EZI_STATUSEX_TYPE_PTNO			    = 8;
  EZI_STATUSEX_TYPE_ALARMTYPE		  = 9;
  EZI_STATUSEX_TYPE_TEMPERATURE   = 10;
  EZI_STATUSEX_TYPE_CURRENT		    = 11;
  EZI_STATUSEX_TYPE_LOAD			    = 12;
  EZI_STATUSEX_TYPE_PEAKLOAD		  = 13;
  EZI_STATUSEX_TYPE_ENCVEL		    = 14;
  EZI_STATUSEX_TYPE_INPUT_HIGH	  = 15;
  EZI_STATUSEX_TYPE_PTNO_RUNNING  = 16;

  //----------------------------------------------------------------------------
  // Input/Output Assigning Defines (BYTE)
  //
  EZI_IO_LEVEL_LOW_ACTIVE	  = 0;  // BYTE
  EZI_IO_LEVEL_HIGH_ACTIVE	= 1;  // BYTE
  //
  EZI_IO_IN_LOGIC_NONE	    = 0;  // BYTE
  EZI_IO_OUT_LOGIC_NONE	    = 0;  // BYTE

  //----------------------------------------------------------------------------
  // POSITION TABLE Defines
  //
  EZI_PT_MAX_LOOP_COUNT	        = 100;    // WORD
  EZI_PT_MAX_WAIT_TIME	        = 60000;  // WORD
  //
  EZI_PT_PUSH_RATIO_MIN	        = 20;     // WORD
  EZI_PT_PUSH_RATIO_MAX	        = 90;     // WORD
  //
  EZI_PT_PUSH_SPEED_MIN	        = 1;      // DWORD
  EZI_PT_PUSH_SPEED_MAX	        = 100000; // DWORD
  //
  EZI_PT_PUSH_PULSECOUNT_MIN	  = 1;      // DWORD
  EZI_PT_PUSH_PULSECOUNT_MAX	  = 10000;  // DWORD
  //
  EZI_PT_CMD_ABS_LOWSPEED       = 0;
	EZI_PT_CMD_ABS_HIGHSPEED      = 1;
	EZI_PT_CMD_ABS_HIGHSPEEDDECEL = 2;
	EZI_PT_CMD_ABS_NORMALMOTION   = 3;
  EZI_PT_CMD_INC_LOWSPEED       = 4;
	EZI_PT_CMD_INC_HIGHSPEED      = 5;
	EZI_PT_CMD_INC_HIGHSPEEDDECEL = 6;
	EZI_PT_CMD_INC_NORMALMOTION   = 7;
	EZI_PT_CMD_MOVE_ORIGIN        = 8;
	EZI_PT_CMD_COUNTERCLEAR       = 9;
	EZI_PT_CMD_PUSH_ABSMOTION     = 10;
	EZI_PT_CMD_STOP               = 11;
  EZI_PT_CMD_MAX_COUNT          = 12;
  EZI_PT_CMD_NO_COMMAND         = $FFFF;
  //
  EZI_PT_OFFSET_POSITION		    = 0;  // WORD
  EZI_PT_OFFSET_LOWSPEED		    = 4;
  EZI_PT_OFFSET_HIGHSPEED	      = 8;
  EZI_PT_OFFSET_ACCELTIME	      = 12;
  EZI_PT_OFFSET_DECELTIME	      = 14;
  EZI_PT_OFFSET_COMMAND		      = 16;
  EZI_PT_OFFSET_WAITTIME		    = 18;
  EZI_PT_OFFSET_CONTINUOUS	    = 20;
  EZI_PT_OFFSET_JUMPTABLENO	    = 22;
  EZI_PT_OFFSET_JUMPPT0		      = 24;
  EZI_PT_OFFSET_JUMPPT1		      = 26;
  EZI_PT_OFFSET_JUMPPT2		      = 28;
  EZI_PT_OFFSET_LOOPCOUNT		    = 30;
  EZI_PT_OFFSET_LOOPJUMPTABLENO = 32;
  EZI_PT_OFFSET_PTSET			      = 34;
  EZI_PT_OFFSET_LOOPCOUNTCLEAR	= 36;
  EZI_PT_OFFSET_CHECKINPOSITION	= 38;
  EZI_PT_OFFSET_TRIGGERPOSITION	= 40;
  EZI_PT_OFFSET_TRIGGERONTIME	  = 44;
  EZI_PT_OFFSET_PUSHRATIO		    = 46;
  EZI_PT_OFFSET_PUSHSPEED		    = 48;
  EZI_PT_OFFSET_PUSHPOSITION		= 52;
  EZI_PT_OFFSET_PUSHMODE			  = 56;
  EZI_PT_OFFSET_BLANK			      = 58;

  //----------------------------------------------------------------------------
  // Alarm
  //
  EZI_ALARM_NONE              = 0;
	EZI_ALARM_OVERCURRENT       = 1;  // Over Current
	EZI_ALARM_OVERSPEED         = 2;  // Over Speed
	EZI_ALARM_STEPOUT           = 3;  // Position Tracking
	EZI_ALARM_OVERLOAD          = 4;  // Over Load
	EZI_ALARM_OVERTEMPERATURE   = 5;  // Over Temperature
	EZI_ALARM_OVERBACKEMF       = 6;  // Over Back EMF
	EZI_ALARM_MOTORCONNECT      = 7;  // No Motor Connect
	EZI_ALARM_ENCODERCONNECT    = 8;  // No Encoder Connect
	EZI_ALARM_LOWMOTORPOWER     = 9;  // Low Motor Power
	EZI_ALARM_INPOSITION        = 10; // Inposition Error
	EZI_ALARM_SYSTEMHALT        = 11; // System Halt
	EZI_ALARM_ROMDEVICE         = 12; // ROM Device Error
	EZI_ALARM_RESERVED0         = 13; // Reserved
	EZI_ALARM_HIGHINPUTVOLTAGE  = 14; // High Input Voltage
	EZI_ALARM_POSITIONOVERFLOW  = 15; // Position Overflow
	EZI_ALARM_POSITIONCHANGED   = 16; // Position Changed
	EZI_MAX_ALARM_NUM           = EZI_ALARM_POSITIONCHANGED; //
  //
  EZI_MAX_ALARM_LOG		        = 30;

  //----------------------------------------------------------------------------
  // Ez-IO Plus-AD Defines    //TBD?
  //
  EZI_MAX_AD_CHANNEL	    =	16;
  //
  EZI_ADRANGE_10_to_10    = 0;	//  -10V ~  +10V [2.441mV]
	EZI_ADRANGE_5_to_5      = 1;	//   -5V ~   +5V [1.22mV]
	EZI_ADRANGE_2_5_to_2_5  = 2;	// -2.5V ~ +2.5V [0.61mV]
	EZI_ADRANGE_0_to_10     = 3;  //    0V ~  +10V [1.22mV]

  //----------------------------------------------------------------------------
  // LOG Level
  //
  EZI_LOG_LEVEL_COMM      = 0;  // Communication Log only
  EZI_LOG_LEVEL_PARAM     = 1;  // Communication Log and parameter functions
  EZI_LOG_LEVEL_MOTION    = 2;  // Communication Log and parameter, motion, I/O functions
  EZI_LOG_LEVEL_ALL       = 3;  // Communication Log and all function

type

  //----------------------------------------------------------------------------
  // POSITION TABLE Defines
  //
  PEziPT_ITEM_NODE = ^REziPT_ITEM_NODE;
  REziPT_ITEM_NODE = packed record
    // union WORD wBuffer[32]  ..64 bytes
		lPosition         : DWORD;
    //
		dwStartSpd        : DWORD;
		dwMoveSpd         : DWORD;
    //
		wAccelRate        : WORD;
		wDecelRate        : WORD;
    //
		wCommand          : WORD;
		wWaitTime         : WORD;
		wContinuous       : WORD;
		wBranch           : WORD;
    //
		wCond_branch0     : WORD;
		wCond_branch1     : WORD;
		wCond_branch2     : WORD;
		wLoopCount        : WORD;
		wBranchAfterLoop  : WORD;
		wPTSet            : WORD;
		wLoopCountCLR     : WORD;
    //
		bCheckInpos       : WORD;   // 0 : Check Inpos, 1 : Don't Check.
    //
		lTriggerPos       : LONG;
		wTriggerOnTime    : WORD;
    //
		wPushRatio        : WORD;
		dwPushSpeed       : DWORD;
		lPushPosition     : LONG;
		wPushMode         : WORD;
  end;

  //----------------------------------------------------------------------------
  // Alarm
  //
  PEzi_ALARM_LOG = ^REzi_ALARM_LOG;
  REzi_ALARM_LOG = record
	  nAlarmCount : BYTE;
	  arrAlarmLog : array[0..Pred(EZI_MAX_ALARM_LOG)] of BYTE;
  end;

  //----------------------------------------------------------------------------
  // Drive Information Define
  //
  //    typedef struct _DRIVE_INFO {
  //	    unsigned short nVersionNo[4];	// Drive Version Number (Major Ver/Minor Ver/Bug fix/Build No.) (?)
  //	    char sVersion[30];				// Drive Version string
  //    	unsigned short nDriveType;		// Drive Model
  //	    unsigned short nMotorType;		// Motor Model
  //    	char sMotorInfo[20];			// Motor Info.(?)
  //	    unsigned short nInPinNo;		// Input Pin Number
  //    	unsigned short nOutPinNo;		// Output Pin Number
  //    	unsigned short nPTNum;			// Position Table Item Number
  //    	unsigned short nFirmwareType;	// Firmware Type Information
  //    } DRIVE_INFO;
  //
  PEziDRIVE_INFO = ^REziDRIVE_INFO;
  REziDRIVE_INFO = packed record   //TBD?
    //TBD?
  end;

  //----------------------------------------------------------------------------
  // I/O Module Define
  //
  //    typedef union {
  //    	BYTE	byBuffer[12];
  //    	struct {
  //    		unsigned short	wPeriod;
  //    		unsigned short	wReserved1;
  //    		unsigned short	wOnTime;
  //    		unsigned short	wReserved2;
  //    		unsigned long	wCount;
  //    	};
  //    } TRIGGER_INFO
  //
  PEziTRIGGER_INFO = ^REziTRIGGER_INFO;
  REziTRIGGER_INFO = packed record
    //TBD?
  end;

  //----------------------------------------------------------------------------
  // EX Commands Option Defines
  //
  PEziMOTION_OPTION_EX = ^REziMOTION_OPTION_EX;
  REziMOTION_OPTION_EX = packed record      // union BYTE bBuffer[32]  ..32 bytes
//    typedef union {           //TBD?
//	    BYTE	byBuffer[32];
//	    struct {
//		    union {
//			    DWORD dwOptionFlag;
//			    struct {
//				    unsigned BIT_IGNOREEXSTOP	: 1;
//				    unsigned BIT_USE_CUSTOMACCEL	: 1;
//				    unsigned BIT_USE_CUSTOMDECEL	: 1;
//				    unsigned BITS_RESERVED	: 13;
//			    };
//		    } flagOption;
//		    WORD	wCustomAccelTime;
//		    WORD	wCustomDecelTime;
//        //BYTE	buffReserved[24];
//	    };
//    } MOTION_OPTION_EX
  end;
  //
  PEziVELOCITY_OPTION_EX = ^REziVELOCITY_OPTION_EX;
  REziVELOCITY_OPTION_EX = packed record      // union BYTE bBuffer[32]  ..32 bytes
//    typedef union {           //TBD?
//	    BYTE	byBuffer[32];
//	    struct {
//		    union {
//			    DWORD dwOptionFlag;
//			    struct {
//				    unsigned BIT_IGNOREEXSTOP	: 1;
//				    unsigned BIT_USE_CUSTOMACCEL	: 1;
//				    unsigned BIT_USE_CUSTOMDECEL	: 1;
//				    unsigned BITS_RESERVED	: 13;
//			    };
//		    } flagOption;
//		    WORD	wCustomAccelTime;
//		    WORD	wCustomDecelTime;
//        //BYTE	buffReserved[24];
//	    };
//    } MOTION_OPTION_EX
  end;

  //----------------------------------------------------------------------------
  // Ez-IO Plus-AD Defines    //TBD?
  //
  //    typedef union {
  //    	BYTE	byBuffer[48];
  //    	struct DATA	{
  //    		char	range;
  //		    short	rawdata;
  //    		float	converted;
  //    	} channel[16];
  //    } AD_RESULT
  PEziAD_RESULT = ^REziAD_RESULT;
  REziAD_RESULT = packed record   //TBD?
    //TBD?
  end;

implementation

end.
