unit EziMLLIB;

interface

uses Windows, Messages, EziMLDef;

  //----------------------------------------------------------------------------
  // EziMotionPE - 드라이버 연결 함수 (Connection Functions)
  //  - FAS_Connect          : 드라이브 모듈과 UDP Protocol로 연결을 시도
  //  - FAS_ConnectTCP       : 드라이브 모듈과 TCP Protocol로 연결을 시도 (FW Ver V06.01.020.04 Library Ver 2.0.0.10 이상에서 지원)
  //  - FAS_IsBdIDExist      ?
  //  - FAS_IsIPAddressExist ?
  //  - FAS_Reconnect        ?
  //  - FAS_SetAutoReconnect ?
  //  - FAS_Close            : 드라이브 모듈과 통신 해지를 시도
  //  - FAS_IsSlaveExist     : 해당 드라이브의 존재 여부를 확인 (해당 드라이브가 연결 상태인지를 확인)
  //----------------------------------------------------------------------------
//EZI_PLUSE_API BOOL WINAPI	FAS_Connect(BYTE sb1, BYTE sb2, BYTE sb3, BYTE sb4, int iBdID);		// UDP Protocol
//EZI_PLUSE_API BOOL WINAPI	FAS_ConnectTCP(BYTE sb1, BYTE sb2, BYTE sb3, BYTE sb4, int iBdID);	// TCP Protocol
//EZI_PLUSE_API BOOL WINAPI	FAS_IsBdIDExist(int iBdID, BYTE* sb1, BYTE* sb2, BYTE* sb3, BYTE* sb4);
//EZI_PLUSE_API BOOL WINAPI	FAS_IsIPAddressExist(BYTE sb1, BYTE sb2, BYTE sb3, BYTE sb4, int* iBdID);
//EZI_PLUSE_API BOOL WINAPI	FAS_Reconnect(int iBdID);
//EZI_PLUSE_API void WINAPI	FAS_SetAutoReconnect(BOOL bSET);
//EZI_PLUSE_API void WINAPI	FAS_Close(int iBdID);
//EZI_PLUSE_API BOOL WINAPI	FAS_IsSlaveExist(int iBdID);
  function  FAS_Connect          (sb1,sb2,sb3,sb4: Byte; iBdID: Integer): BOOL; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_ConnectTCP       (sb1,sb2,sb3,sb4: Byte; iBdID: Integer): BOOL; stdcall; external 'EziMotionPlusE.dll'; //!!!
  function  FAS_IsBdIDExist      (iBdID: Integer; var sb1,sb2,sb3,sb4: Byte): BOOL; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_IsIPAddressExist (sb1,sb2,sb3,sb4: Byte; var iBdID: Integer): BOOL; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_Reconnect        (iBdID: Integer): BOOL; stdcall; external 'EziMotionPlusE.dll';
  procedure FAS_SetAutoReconnect (bSET: BOOL); stdcall; external 'EziMotionPlusE.dll';
  procedure FAS_Close            (iBdID: Integer); stdcall; external 'EziMotionPlusE.dll'; //!!!
  function  FAS_IsSlaveExist     (iBdID: Integer): BOOL; stdcall; external 'EziMotionPlusE.dll';
  //----------------------------------------------------------------------------
  // EziMotionPE - Log 함수 (Log Functions)
  //    FAS_EnableLog      : 통신 오류 관련 Log 의 출력을 제어
  //    FAS_SetLogPath     : 출력될 Log가 저장될 경로를 설정
  //    FAS_SetLogLevel    : 출력될 Log의 Level을 설정 (FW Ver V06.01.020.04 Library Ver 2.0.0.10 이상에서 지원)
  //    FAS_PrintCustomLog : 임의의 Log를 출력 (FW Ver V06.01.020.04 Library Ver 2.0.0.10 이상에서 지원)
  //----------------------------------------------------------------------------
//EZI_PLUSE_API void WINAPI	FAS_EnableLog(BOOL bEnable);
//EZI_PLUSE_API void WINAPI	FAS_SetLogLevel(enum LOG_LEVEL level);
//EZI_PLUSE_API BOOL WINAPI	FAS_SetLogPath(LPCTSTR lpPath);
//EZI_PLUSE_API void WINAPI	FAS_PrintCustomLog(int iBdID, enum LOG_LEVEL level, LPCTSTR lpszMsg);
  procedure FAS_EnableLog     (bEnable: BOOL); stdcall; external 'EziMotionPlusE.dll';
  procedure FAS_SetLogLevel   (level: Integer); stdcall; external 'EziMotionPlusE.dll';
  function  FAS_SetLogPath    (lpPath: PAnsiChar): BOOL; stdcall; external 'EziMotionPlusE.dll';
  procedure FAS_PrintCustomLog(iBdID: Integer; level: Integer; lpszMsg: PAnsiChar); stdcall; external 'EziMotionPlusE.dll';
  //----------------------------------------------------------------------------
  // EziMotionPE - Info 함수 (Info Functions)
  //    FAS_GetSlaveInfo   : 드라이브의 종류와 프로그램 Version 정보를 읽음
  //    FAS_GetMotorInfo   : 드라이브에 연결된 모터의 종류와 제조사에 대한 정보를 읽음
  //    FAS_GetSlaveInfoEx ?
  //----------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_GetSlaveInfo(int iBdID, BYTE* pType, LPSTR lpBuff, int nBuffSize);
//EZI_PLUSE_API int WINAPI	FAS_GetMotorInfo(int iBdID, BYTE* pType, LPSTR lpBuff, int nBuffSize);
//EZI_PLUSE_API int WINAPI	FAS_GetSlaveInfoEx(int iBdID, DRIVE_INFO* lpDriveInfo)
  function FAS_GetSlaveInfo(iBdID: Integer; var pType: Byte; lpBuff: PAnsiChar; nBuffSize: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_GetMotorInfo(iBdID: Integer; var pType: Byte; lpBuff: PAnsiChar; nBuffSize: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
//function FAS_GetSlaveInfoEx  TBD?
  //----------------------------------------------------------------------------
  // EziMotionPE - 파라메터 제어 함수 (Parameter Functions)
  //    FAS_SaveAllParameters  : 현재 상태의 Parameter들을 ROM에 저장
  //                  (운전 속도 , 가감속 시간 , 원점 복귀 관련 등의 파라미터를 전원 OFF 후에도 보존되도록 저장)
  //    FAS_SetParameter       : 지정한 Parameter값을 RAM 영역에 영역에 저장
  //    FAS_GetParameter       : 지정한 Parameter값을 RAM 영역에서 읽음
  //    FAS_GetROMParameter    : 지정한 Parameter값을 ROM 영역에서 읽음
  //----------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_SaveAllParameters(int iBdID);
//EZI_PLUSE_API int WINAPI	FAS_SetParameter(int iBdID, BYTE iParamNo, long lParamValue);
//EZI_PLUSE_API int WINAPI	FAS_GetParameter(int iBdID, BYTE iParamNo, long* lParamValue);
//EZI_PLUSE_API int WINAPI	FAS_GetROMParameter(int iBdID, BYTE iParamNo, long* lRomParam);
  function  FAS_SaveAllParameters(iBdID: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_SetParameter     (iBdID: Integer; iParamNo: Byte; lParamValue: LONG): Integer; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_GetParameter     (iBdID: Integer; iParamNo: Byte; var lParamValue: LONG): Integer; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_GetROMParameter  (iBdID: Integer; iParamNo: Byte; var lRomaram: LONG): Integer; stdcall; external 'EziMotionPlusE.dll';
  //----------------------------------------------------------------------------
  // EziMotionPE - 서보 제어 함수 (Servo Driver Control Functions)
  //    FAS_ServoEnable     : 지정한 드라이브의 Servo 상태를 ON/OFF 시킵니다.
  //    FAS_ServoAlarmReset : 알람이 발생한 드라이브의 알람을 해제 (알람이 발생한 원인을 제거한 후 실시)
  //    FAS_StepAlarmReset  ?
  //----------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_ServoEnable(int iBdID, BOOL bOnOff);
//EZI_PLUSE_API int WINAPI	FAS_ServoAlarmReset(int iBdID);
//EZI_PLUSE_API int WINAPI	FAS_StepAlarmReset(int iBdID, BOOL bReset);
  function  FAS_ServoEnable    (iBdID: Integer; bOnOff: BOOL): Integer; stdcall; external 'EziMotionPlusE.dll'; //!!!
  function  FAS_ServoAlarmReset(iBdID: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_StepAlarmReset (iBdID: Integer; bReset: BOOL): Integer ; stdcall; external 'EziMotionPlusE.dll';
  //------------------------------------------------------------------
  // EziMotionPE - Alarm 정보 제어 함수	(Alarm Type History Functions)
  //    FAS_GetAlarmType   : 현재 알람의 발생 여부 및 알람의 종류를 확인
  //    FAS_GetAlarmLogs   ?
  //    FAS_ResetAlarmLogs :
  //------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_GetAlarmType(int iBdID, BYTE* nAlarmType);
//EZI_PLUSE_API int WINAPI	FAS_GetAlarmLogs(int iBdID, ALARM_LOG* pAlarmLog);
//EZI_PLUSE_API int WINAPI	FAS_ResetAlarmLogs(int iBdID);
  function FAS_GetAlarmType  (iBdID: Integer; var nAlarmType: Byte): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_GetAlarmLogs  (iBdID: Integer; var pAlarmLog: PEzi_ALARM_LOG): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_ResetAlarmLogs(iBdID: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  //----------------------------------------------------------------------------
  // EziMotionPE - 제어 입출력 함수 (IO Functions)
  //    FAS_SetIOInput     : 제어 입력단의 입력 신호 레벨을 설정 (입력 신호를 ON 또는 OFF 상태로 만듬)
  //    FAS_GetIOInput     : 제어 입력단의 현재 입력 신호 상태를 읽음 (각 입력 신호에 대해 bit 단위로 리턴)
  //    FAS_SetIOOutput    : 제어 출력단의 출력 신호 레벨을 설정 (출력 신호를 ON 또는 OFF 상태로 만듬)
  //    FAS_GetIOOutput    : 제어 출력단의 현재 입력 신호 상태를 읽어 들임 (각 출력 신호에 대해 bit단위로 리턴)
  //    FAS_SetIOAssignMap : 입출력 신호를 CN1 단자대의 pin에 할당 함과 동시에 신호 Level을 설정 (입력 및 출력단의 가변 설정이 가능한 각각 9개의 신호에 설정 등을 명령)
  //    FAS_GetIOAssignMap : CN1 단자대 pin의 설정 상태를 읽어들임 (입력 및 출력단의 가변 설정이 가능한 9개의 신호에 설정 상태 값 등을 bit 단위로 리턴)
  //    FAS_IOAssignMapReadROM : 입력 및 출력단의 설정 상태와 신호 레벨 상태값을 ROM 영역으로부터 RAM 영역으로 읽어 들임.
  //----------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_SetIOInput(int iBdID, DWORD dwIOSETMask, DWORD dwIOCLRMask);
//EZI_PLUSE_API int WINAPI	FAS_GetIOInput(int iBdID, DWORD* dwIOInput);
//EZI_PLUSE_API int WINAPI	FAS_SetIOOutput(int iBdID, DWORD dwIOSETMask, DWORD dwIOCLRMask);
//EZI_PLUSE_API int WINAPI	FAS_GetIOOutput(int iBdID, DWORD* dwIOOutput);
//EZI_PLUSE_API int WINAPI	FAS_GetIOAssignMap(int iBdID, BYTE iIOPinNo, DWORD* dwIOLogicMask, BYTE* bLevel);
//EZI_PLUSE_API int WINAPI	FAS_SetIOAssignMap(int iBdID, BYTE iIOPinNo, DWORD dwIOLogicMask, BYTE bLevel);
//EZI_PLUSE_API int WINAPI	FAS_IOAssignMapReadROM(int iBdID);
  function  FAS_SetIOInput        (iBdID: Integer; dwIOSetMask: DWORD; dwIOCLRMask: DWORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_GetIOInput        (iBdID: Integer; var dwIOInput: DWORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_SetIOOutput       (iBdID: Integer; dwIOSetMask: DWORD; dwIOCLRMask: DWORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_GetIOOutput       (iBdID: Integer; var dwIOOutput: DWORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_GetIOAssignMap    (iBdID: Integer; iIOPinNo: Byte; var nIOLogic: Byte; var bLevel: Byte): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function  FAS_SetIOAssignMap    (iBdID: Integer; iIOPinNo: Byte; nIOLogic: Byte; bLevel: Byte): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function  FAS_IOAssignMapReadROM(iBdID: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  //----------------------------------------------------------------------------
  // EziMotionPE - 위치 제어 함수  (Read Status and Position)
  //    FAS_SetCommandPos  : Motor의 목표(Command) 위치값을 임의의 값으로 설정
  //    FAS_SetActualPos   : Motor의 실제(Actual) 위치값을 임의의 값으로 설정
  //    FAS_GetCommandPos  : Motor의 현재 목표(Command) 위치값을 읽음
  //    FAS_GetActualPos   : Motor의 실제(Actual) 위치값을 읽어들임
  //    FAS_GetPosError    : Motor의 Position Error값(Actual 위치값과 Command 위치값의 차이)를 읽음
  //    FAS_GetActualVel   : Motor의 현재 이동중인 운전의 실제 운전 속도값을 읽음
  //    FAS_ClearPosition  : Motor의 목표(Command) 위치값과 실제(Actual) 위치값을 ‘0’으로 설정
  //----------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_SetCommandPos(int iBdID, long lCmdPos);
//EZI_PLUSE_API int WINAPI	FAS_SetActualPos(int iBdID, long lActPos);
//EZI_PLUSE_API int WINAPI	FAS_ClearPosition(int iBdID);
//EZI_PLUSE_API int WINAPI	FAS_GetCommandPos(int iBdID, long* lCmdPos);
//EZI_PLUSE_API int WINAPI	FAS_GetActualPos(int iBdID, long* lActPos);
//EZI_PLUSE_API int WINAPI	FAS_GetPosError(int iBdID, long* lPosErr);
//EZI_PLUSE_API int WINAPI	FAS_GetActualVel(int iBdID, long* lActVel);
  function FAS_SetCommandPos(iBdID: Integer; lCmdPos: LONG): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_SetActualPos (iBdID: Integer; lActPos: LONG): Integer; stdcall; external 'EziMotionPlusE.dll'; //!!!
  function FAS_ClearPosition(iBdID: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_GetCommandPos(iBdID: Integer; var lCmdPos: LONG): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_GetActualPos (iBdID: Integer; var lActPos: LONG): Integer; stdcall; external 'EziMotionPlusE.dll'; //!!!
  function FAS_GetPosError  (iBdID: Integer; var lPosErr: LONG): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_GetActualVel (iBdID: Integer; var lActVel: LONG): Integer; stdcall; external 'EziMotionPlusE.dll';
  //----------------------------------------------------------------------------
  // EziMotionPE - 드라이브 상태 제어 함수
  //    FAS_GetAxisStatus   : 해당 드라이브의 운전 상태 flag 값을 읽음
  //    FAS_GetIOAxisStatus : 제어 입출력 상태와 운전 상태 flag 값을 읽음 (현재의 입력 상태값, 출력 설정 상태값 및 운전상태 Flag 값을 리턴)
  //    FAS_GetMotionStatus : 현재 운전 진행 상황 및 운전중인 PT 번호를 읽음 (Command position, Actual position, 속도값 등을 리턴)
  //    FAS_GetAllStatus    : 현재 상태를 모두 포함하여 한꺼번에 읽음 (FAS_GetIOAxisStatus+FAS_GetMotionStatus)
  //    FAS_GetAllStatusEx  : ?
  //----------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_GetAxisStatus(int iBdID, DWORD* dwAxisStatus);
//EZI_PLUSE_API int WINAPI	FAS_GetIOAxisStatus(int iBdID, DWORD* dwInStatus, DWORD* dwOutStatus, DWORD* dwAxisStatus);
//EZI_PLUSE_API int WINAPI	FAS_GetMotionStatus(int iBdID, long* lCmdPos, long* lActPos, long* lPosErr, long* lActVel, WORD* wPosItemNo);
//EZI_PLUSE_API int WINAPI	FAS_GetAllStatus(int iBdID, DWORD* dwInStatus, DWORD* dwOutStatus, DWORD* dwAxisStatus, long* lCmdPos, long* lActPos, long* lPosErr, long* lActVel, WORD* wPosItemNo);
//EZI_PLUSE_API int WINAPI	FAS_GetAllStatusEx(int iBdID, BYTE* pTypes, long* pDatas);
  function FAS_GetAxisStatus  (iBdID: Integer; var dwAxisStatus: DWORD): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function FAS_GetIOAxisStatus(iBdID: Integer; var dwInStatus: DWORD; var dwOutStatus: DWORD; var dwAxisStatus: DWORD): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function FAS_GetMotionStatus(iBdID: Integer; var lCmdPos: LONG; var lActPos: LONG; var lPosErr: LONG; var lActVel: LONG; var wPosItemNo: WORD): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function FAS_GetAllStatus   (iBdID: Integer; var dwInStatus: DWORD; var dwOutStatus: DWORD; var dwAxisStatus: DWORD; var lCmdPos: LONG; var lActPos: LONG; var lPosErr: LONG; var lActVel: LONG; var wPosItemNo: WORD): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function FAS_GetAllStatusEx (iBdID: Integer; var pTypes: array of Byte; var pDatas: array of LONG): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  //----------------------------------------------------------------------------
  // EziMotionPE - 운전 제어 함수 (Motion Functions, Ex-Motion Functions, Trigger, ...)
  //    FAS_MoveStop              : 운전중인 Motor를 감속하면서 정지
  //    FAS_EmergencyStop         : 운전중인 Motor를 감속없이 즉시 정지
  //    FAS_MovePause             : 운전중인 상태에서 운전의 일시 정지 및 일시 정지 상태에서의 운전 재개를 실시
  //    FAS_MoveOriginSingleAxis  : 원점 복귀 운전을 시작 ('사용자 매뉴얼_본문편 9.3 원점 복귀' 참조)
  //    FAS_MoveSingleAxisAbsPos  : Motor를? 주어진 절대(Absolute) 위치값으로 운전을 실시
  //    FAS_MoveSingleAxisIncPos  : Motor를? 주어진 상대(Incremental) 위치값 만큼 운전을 실시
  //    FAS_MoveToLimit           : 센서가 감지되는 위치까지 운전을 실시 (Motor에게 해당 Limit를 찾도록 명령?)
  //    FAS_MoveVelocity          : 주어진 속도와 방향으로 운전을 시작 (Jog 운전 등에 사용)
  //    FAS_PositionAbsOverride   : Motor의 절대 위치 이동 중 설정되었던 절대 위치값을 변경 (운전중인 상태에서 목표 절대 위치값 [pulse]을 변경)
  //    FAS_PositionIncOverride   : Motor의 상대 위치 이동 중 설정되었던 상태 위치값을 변경 (운전중인 상태에서 목표 상대 위치값 [pulse]을 변경)
  //    FAS_VelocityOverride      : Motor의 이동 중 설정되었던 속도값을 변경 (운전중인 상태에서 운전 속도값[pps]을 변경)
  //    FAS_MoveLinearAbsPos ?
  //    FAS_MoveLinearIncPos ?
  //    FAS_MoveSingleAxisAbsPosEx: Motor를 특정 절대 좌표값으로 이동 (주어진 절대 위치값 만큼 운전을 실시, 가속 및 감속 시간을 설정할 수 있음)
  //    FAS_MoveSingleAxisIncPosEx: Motor를 특정 상대 좌표값으로 이동 (주어진 상대 위치값 만큼 운전을 실시, 가속 및 감속 시간을 설정할 수 있음)
  //    FAS_MoveVelocityEx        : Motor를 주어진 속도와 방향으로 운전을 시작 (Jog 운전등에 사용, 가속 및 감속 시간을 설정할 수 있음)
  //    FAS_TriggerOutput_RunA    : 위치 명령에 의한 운전 중 특적 위치에서 디지털 출력신호(COMP pin)를 발생/종료 시킴 (특정 위치(주기적인)에서 출력 신호를 발생) //TBD?
  //    FAS_TriggerOutput_Status  : 현재 신호 출력 기능이 작동 중인지 여부를 확인 (출력 신호(COMP)의 발생 여부를 확인)
  //    FAS_SetTriggerOutputEx    : 설정된 출력에 특정 위치에서 출력을 발생 (최대 60개의 다른 위치를 지정)
  //    FAS_GetTriggerOutputEx    : FAS_SetTriggerOutputEx으로 설정된 정보 및 출력 상태를 확인
  //      - FAS_TriggerOutput_RunA, FAS_SetTriggerOutputEx로 설정한 후에 운전 제어 함수를 이용해 Moving 될 때 출력 신호가 발생
  //    FAS_MovePush ?
  //    FAS_GetPushStatus ?
  //----------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_MoveStop(int iBdID);
//EZI_PLUSE_API int WINAPI	FAS_EmergencyStop(int iBdID);
//EZI_PLUSE_API int WINAPI	FAS_MovePause(int iBdID, BOOL bPause);
//EZI_PLUSE_API int WINAPI	FAS_MoveOriginSingleAxis(int iBdID);
//EZI_PLUSE_API int WINAPI	FAS_MoveSingleAxisAbsPos(int iBdID, long lAbsPos, DWORD lVelocity);
//EZI_PLUSE_API int WINAPI	FAS_MoveSingleAxisIncPos(int iBdID, long lIncPos, DWORD lVelocity);
//EZI_PLUSE_API int WINAPI	FAS_MoveToLimit(int iBdID, DWORD lVelocity, int iLimitDir);
//EZI_PLUSE_API int WINAPI	FAS_MoveVelocity(int iBdID, DWORD lVelocity, int iVelDir);
//EZI_PLUSE_API int WINAPI	FAS_PositionAbsOverride(int iBdID, long lOverridePos);
//EZI_PLUSE_API int WINAPI	FAS_PositionIncOverride(int iBdID, long lOverridePos);
//EZI_PLUSE_API int WINAPI	FAS_VelocityOverride(int iBdID, DWORD lVelocity);
//EZI_PLUSE_API int WINAPI	FAS_MoveLinearAbsPos(BYTE nNoOfBds, int* iBdID, long* lplAbsPos, DWORD lFeedrate, WORD wAccelTime);
//EZI_PLUSE_API int WINAPI	FAS_MoveLinearIncPos(BYTE nNoOfBds, int* iBdID, long* lplIncPos, DWORD lFeedrate, WORD wAccelTime);
//EZI_PLUSE_API int WINAPI	FAS_MoveSingleAxisAbsPosEx(int iBdID, long lAbsPos, DWORD lVelocity, MOTION_OPTION_EX* lpExOption);
//EZI_PLUSE_API int WINAPI	FAS_MoveSingleAxisIncPosEx(int iBdID, long lIncPos, DWORD lVelocity, MOTION_OPTION_EX* lpExOption);
//EZI_PLUSE_API int WINAPI	FAS_MoveVelocityEx(int iBdID, DWORD lVelocity, int iVelDir, VELOCITY_OPTION_EX* lpExOption);
//EZI_PLUSE_API int WINAPI	FAS_TriggerOutput_RunA(int iBdID, BOOL bStartTrigger, long lStartPos, DWORD dwPeriod, DWORD dwPulseTime);
//EZI_PLUSE_API int WINAPI	FAS_TriggerOutput_Status(int iBdID, BYTE* bTriggerStatus);
//EZI_PLUSE_API int WINAPI	FAS_SetTriggerOutputEx(int iBdID, BYTE nOutputNo, BYTE bRun, WORD wOnTime, BYTE nTriggerCount, long* arrTriggerPosition);
//EZI_PLUSE_API int WINAPI	FAS_GetTriggerOutputEx(int iBdID, BYTE nOutputNo, BYTE* bRun, WORD* wOnTime, BYTE* nTriggerCount, long* arrTriggerPosition);
//EZI_PLUSE_API int WINAPI	FAS_MovePush(int iBdID, DWORD dwStartSpd, DWORD dwMoveSpd, long lPosition, WORD wAccel, WORD wDecel, WORD wPushRate, DWORD dwPushSpd, long lEndPosition, WORD wPushMode);
//EZI_PLUSE_API int WINAPI	FAS_GetPushStatus(int iBdID, BYTE* nPushStatus);
  function FAS_MoveStop            (iBdID: Integer): Integer; stdcall; external 'EziMotionPlusE.dll'; //!!!
  function FAS_EmergencyStop       (iBdID: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_MovePause           (iBdID: Integer; bPause: BOOL): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_MoveOriginSingleAxis(iBdID: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_MoveSingleAxisAbsPos(iBdID: Integer; lAbsPos: LONG; lVelocity: DWORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_MoveSingleAxisIncPos(iBdID: Integer; lIncPos: LONG; lVelocity: DWORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_MoveToLimit         (iBdID: Integer; lVelocity: DWORD; iLimitDir: Integer): Integer ; stdcall; external 'EziMotionPlusE.dll';
  function FAS_MoveVelocity        (iBdID: Integer; lVelocity: DWORD; iVelDir: Integer): Integer; stdcall; external 'EziMotionPlusE.dll'; //!!!
  function FAS_PositionAbsOverride (iBdID: Integer; lOverridePos: LONG): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_PositionIncOverride (iBdID: Integer; lOverridePos: LONG): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_VelocityOverride    (iBdID: Integer; lVelocity : DWORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_MoveLinearAbsPos    (nNoOfBds: Integer; var iBdID: Integer; var lplAbsPos: LONG; lFeedrate: DWORD; wAccelTime: WORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_MoveLinearIncPos    (nNoOfBds: Integer; var iBdID: Integer; var lplIncPos: LONG; lFeedrate: DWORD; wAccelTime: WORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_MoveSingleAxisAbsPosEx(iBdID: Integer; lAbsPos: LONG; lVelocity: DWORD; var lpExOption: PEziMOTION_OPTION_EX): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function FAS_MoveSingleAxisIncPosEx(iBdID: Integer; lAbsPos: LONG; lVelocity: DWORD; var lpExOption: PEziMOTION_OPTION_EX): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function FAS_MoveVelocityEx        (iBdID: Integer; lVelocity: DWORD; iVelDir: Integer; var lpExOption: PEziVELOCITY_OPTION_EX): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function FAS_TriggerOutput_RunA  (iBdID: Integer; bStartTrigger: BOOL; lStartPos: LONG; dwPeriod: DWORD; dwPulseTime: DWORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_TriggerOutput_Status(iBdID: Integer; var bTriggerStatus: Byte): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_SetTriggerOutputEx  (iBdID: Integer; nOutputNo: Byte; bRun: Byte; wOnTime: Word; nTriggerCount: Byte; var arrTriggerPosition: array of LONG): Integer; stdcall; external 'EziMotionPlusE.dll';  //TBD?
  function FAS_GetTriggerOutputEx  (iBdID: Integer; var nOutputNo: Byte; var bRun: Byte; var wOnTime: Word; var nTriggerCount: Byte; var arrTriggerPosition: array of LONG): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function FAS_MovePush            (iBdID: Integer; dwStartSpd: DWORD; dwMoveSpd: DWORD; lPosition: LONG; wAccel: WORD; wDecel: WORD; wPushRate: WORD; dwPushSpd: DWORD; lEndPosition: LONG; wPushMode: WORD): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function FAS_GetPushStatus       (iBdID: Integer; var nPushStatus: Byte): Integer; stdcall; external 'EziMotionPlusE.dll';
  //----------------------------------------------------------------------------
  // EziMotionPE - 포지션 테이블 제어 함수 (Position Table Functions)
  //    FAS_PosTableReadItem     : 특정 포지션 테이블의 RAMRAMRAM영역의 항목값들을 읽음
  //    FAS_PosTableWriteItem    : 특정 포지션 테이블의 항목값을 RAM 영역에 저장
  //    FAS_PosTableWriteROM     : 모든 포지션 테이블 값을 ROM 영역에 저장 (256 개의 모든 PT 값이 저장됨)
  //    FAS_PosTableReadROM      : ROM 영역의 포지션 테이블 값들을 읽음 (256 개의 모든 PT 값을 읽음)
  //    FAS_PosTableRunItem      : Position Table의 특정 Item을 시작으로 명령을 수행 (지정된 포지션 테이블에서 순차적으로 운전을 시작)
  //    FAS_PosTableReadOneItem  : Position Table의 특정 Item의 값을 읽음 (특정 포지션 테이블의 특정 항목의 RAM 영역의 값을 읽음)
  //    FAS_PosTableWriteOneItem : Position Table의 특정 Item의 값을 수정 (특정 포지션 테이블의 특정 항목 값을 RAM 영역에 저장)
  //    FAS_PosTableSingleRunItem ?
  //----------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_PosTableReadItem(int iBdID, WORD wItemNo, LPITEM_NODE lpItem);
//EZI_PLUSE_API int WINAPI	FAS_PosTableWriteItem(int iBdID, WORD wItemNo, LPITEM_NODE lpItem);
//EZI_PLUSE_API int WINAPI	FAS_PosTableWriteROM(int iBdID);
//EZI_PLUSE_API int WINAPI	FAS_PosTableReadROM(int iBdID);
//EZI_PLUSE_API int WINAPI	FAS_PosTableRunItem(int iBdID, WORD wItemNo);
//EZI_PLUSE_API int WINAPI	FAS_PosTableReadOneItem(int iBdID, WORD wItemNo, WORD wOffset, long* lPosItemVal);
//EZI_PLUSE_API int WINAPI	FAS_PosTableWriteOneItem(int iBdID, WORD wItemNo, WORD wOffset, long lPosItemVal);
//EZI_PLUSE_API int WINAPI	FAS_PosTableSingleRunItem(int iBdID, BOOL bNextMove, WORD wItemNo);
  function FAS_PosTableReadItem     (iBdID: Integer; wItemNo: WORD; var lpItem: PEziPT_ITEM_NODE): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function FAS_PosTableWriteItem    (iBdID: Integer; wItemNo: WORD; lpItem: PEziPT_ITEM_NODE): Integer; stdcall; external 'EziMotionPlusE.dll'; //TBD?
  function FAS_PosTableWriteROM     (iBdID: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_PosTableReadROM      (iBdID: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_PosTableRunItem      (iBdID: Integer; wItemNo: WORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_PosTableReadOneItem  (iBdID: Integer; wItemNo: WORD; wOffset: WORD; var lPosItemVal: LONG): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_PosTableWriteOneItem (iBdID: Integer; wItemNo: WORD; wOffset: WORD; lPosItemVal: LONG): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_PosTableSingleRunItem(iBdID: Integer; bNextMove: BOOL; wItemNo: WORD): Integer; stdcall; external 'EziMotionPlusE.dll';
  //------------------------------------------------------------------
  // EziMotionPE - I/O Module 제어 함수	(I/O Module Functions)
  //------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_GetInput(int iBdID, unsigned long* uInput, unsigned long* uLatch);
//EZI_PLUSE_API int WINAPI	FAS_ClearLatch(int iBdID, unsigned long uLatchMask);
//EZI_PLUSE_API int WINAPI	FAS_GetLatchCount(int iBdID, unsigned char iInputNo, unsigned long* uCount);
//EZI_PLUSE_API int WINAPI	FAS_GetLatchCountAll(int iBdID, unsigned long** ppuAllCount);
//EZI_PLUSE_API int WINAPI	FAS_ClearLatchCount(int iBdID, unsigned long uInputMask);
//EZI_PLUSE_API int WINAPI	FAS_GetOutput(int iBdID, unsigned long* uOutput, unsigned long* uStatus);
//EZI_PLUSE_API int WINAPI	FAS_SetOutput(int iBdID, unsigned long uSet, unsigned long uClear);
//EZI_PLUSE_API int WINAPI	FAS_SetTrigger(int iBdID, unsigned char uOutputNo, TRIGGER_INFO* pTrigger);
//EZI_PLUSE_API int WINAPI	FAS_SetRunStop(int iBdID, unsigned long uRun, unsigned long uStop);
//EZI_PLUSE_API int WINAPI	FAS_GetTriggerCount(int iBdID, unsigned char uOutputNo, unsigned long* uCount);
//EZI_PLUSE_API int WINAPI	FAS_GetIOLevel(int iBdID, unsigned long* uIOLevel);
//EZI_PLUSE_API int WINAPI	FAS_SetIOLevel(int iBdID, unsigned long uIOLevel);
//EZI_PLUSE_API int WINAPI	FAS_LoadIOLevel(int iBdID);
//EZI_PLUSE_API int WINAPI	FAS_SaveIOLevel(int iBdID);
//EZI_PLUSE_API int WINAPI	FAS_GetInputFilter(int iBdID, unsigned short* filter);
//EZI_PLUSE_API int WINAPI	FAS_SetInputFilter(int iBdID, unsigned short filter);
  //TBD?
  //------------------------------------------------------------------
  //					Ez-IO Plus-AD Functions
  //------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_GetAllADResult(int iBdID, AD_RESULT* result);
//EZI_PLUSE_API int WINAPI	FAS_GetADResult(int iBdID, BYTE channel, float* adresult);
//EZI_PLUSE_API int WINAPI	FAS_SetADRange(int iBdID, BYTE channel, AD_RANGE range);
  //TBD?

implementation

end.
