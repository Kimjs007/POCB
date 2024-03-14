unit EziMLLIB;

interface

uses Windows, Messages, EziMLDef;

  //----------------------------------------------------------------------------
  // EziMotionPE - ����̹� ���� �Լ� (Connection Functions)
  //  - FAS_Connect          : ����̺� ���� UDP Protocol�� ������ �õ�
  //  - FAS_ConnectTCP       : ����̺� ���� TCP Protocol�� ������ �õ� (FW Ver V06.01.020.04 Library Ver 2.0.0.10 �̻󿡼� ����)
  //  - FAS_IsBdIDExist      ?
  //  - FAS_IsIPAddressExist ?
  //  - FAS_Reconnect        ?
  //  - FAS_SetAutoReconnect ?
  //  - FAS_Close            : ����̺� ���� ��� ������ �õ�
  //  - FAS_IsSlaveExist     : �ش� ����̺��� ���� ���θ� Ȯ�� (�ش� ����̺갡 ���� ���������� Ȯ��)
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
  // EziMotionPE - Log �Լ� (Log Functions)
  //    FAS_EnableLog      : ��� ���� ���� Log �� ����� ����
  //    FAS_SetLogPath     : ��µ� Log�� ����� ��θ� ����
  //    FAS_SetLogLevel    : ��µ� Log�� Level�� ���� (FW Ver V06.01.020.04 Library Ver 2.0.0.10 �̻󿡼� ����)
  //    FAS_PrintCustomLog : ������ Log�� ��� (FW Ver V06.01.020.04 Library Ver 2.0.0.10 �̻󿡼� ����)
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
  // EziMotionPE - Info �Լ� (Info Functions)
  //    FAS_GetSlaveInfo   : ����̺��� ������ ���α׷� Version ������ ����
  //    FAS_GetMotorInfo   : ����̺꿡 ����� ������ ������ �����翡 ���� ������ ����
  //    FAS_GetSlaveInfoEx ?
  //----------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_GetSlaveInfo(int iBdID, BYTE* pType, LPSTR lpBuff, int nBuffSize);
//EZI_PLUSE_API int WINAPI	FAS_GetMotorInfo(int iBdID, BYTE* pType, LPSTR lpBuff, int nBuffSize);
//EZI_PLUSE_API int WINAPI	FAS_GetSlaveInfoEx(int iBdID, DRIVE_INFO* lpDriveInfo)
  function FAS_GetSlaveInfo(iBdID: Integer; var pType: Byte; lpBuff: PAnsiChar; nBuffSize: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  function FAS_GetMotorInfo(iBdID: Integer; var pType: Byte; lpBuff: PAnsiChar; nBuffSize: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
//function FAS_GetSlaveInfoEx  TBD?
  //----------------------------------------------------------------------------
  // EziMotionPE - �Ķ���� ���� �Լ� (Parameter Functions)
  //    FAS_SaveAllParameters  : ���� ������ Parameter���� ROM�� ����
  //                  (���� �ӵ� , ������ �ð� , ���� ���� ���� ���� �Ķ���͸� ���� OFF �Ŀ��� �����ǵ��� ����)
  //    FAS_SetParameter       : ������ Parameter���� RAM ������ ������ ����
  //    FAS_GetParameter       : ������ Parameter���� RAM �������� ����
  //    FAS_GetROMParameter    : ������ Parameter���� ROM �������� ����
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
  // EziMotionPE - ���� ���� �Լ� (Servo Driver Control Functions)
  //    FAS_ServoEnable     : ������ ����̺��� Servo ���¸� ON/OFF ��ŵ�ϴ�.
  //    FAS_ServoAlarmReset : �˶��� �߻��� ����̺��� �˶��� ���� (�˶��� �߻��� ������ ������ �� �ǽ�)
  //    FAS_StepAlarmReset  ?
  //----------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_ServoEnable(int iBdID, BOOL bOnOff);
//EZI_PLUSE_API int WINAPI	FAS_ServoAlarmReset(int iBdID);
//EZI_PLUSE_API int WINAPI	FAS_StepAlarmReset(int iBdID, BOOL bReset);
  function  FAS_ServoEnable    (iBdID: Integer; bOnOff: BOOL): Integer; stdcall; external 'EziMotionPlusE.dll'; //!!!
  function  FAS_ServoAlarmReset(iBdID: Integer): Integer; stdcall; external 'EziMotionPlusE.dll';
  function  FAS_StepAlarmReset (iBdID: Integer; bReset: BOOL): Integer ; stdcall; external 'EziMotionPlusE.dll';
  //------------------------------------------------------------------
  // EziMotionPE - Alarm ���� ���� �Լ�	(Alarm Type History Functions)
  //    FAS_GetAlarmType   : ���� �˶��� �߻� ���� �� �˶��� ������ Ȯ��
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
  // EziMotionPE - ���� ����� �Լ� (IO Functions)
  //    FAS_SetIOInput     : ���� �Է´��� �Է� ��ȣ ������ ���� (�Է� ��ȣ�� ON �Ǵ� OFF ���·� ����)
  //    FAS_GetIOInput     : ���� �Է´��� ���� �Է� ��ȣ ���¸� ���� (�� �Է� ��ȣ�� ���� bit ������ ����)
  //    FAS_SetIOOutput    : ���� ��´��� ��� ��ȣ ������ ���� (��� ��ȣ�� ON �Ǵ� OFF ���·� ����)
  //    FAS_GetIOOutput    : ���� ��´��� ���� �Է� ��ȣ ���¸� �о� ���� (�� ��� ��ȣ�� ���� bit������ ����)
  //    FAS_SetIOAssignMap : ����� ��ȣ�� CN1 ���ڴ��� pin�� �Ҵ� �԰� ���ÿ� ��ȣ Level�� ���� (�Է� �� ��´��� ���� ������ ������ ���� 9���� ��ȣ�� ���� ���� ���)
  //    FAS_GetIOAssignMap : CN1 ���ڴ� pin�� ���� ���¸� �о���� (�Է� �� ��´��� ���� ������ ������ 9���� ��ȣ�� ���� ���� �� ���� bit ������ ����)
  //    FAS_IOAssignMapReadROM : �Է� �� ��´��� ���� ���¿� ��ȣ ���� ���°��� ROM �������κ��� RAM �������� �о� ����.
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
  // EziMotionPE - ��ġ ���� �Լ�  (Read Status and Position)
  //    FAS_SetCommandPos  : Motor�� ��ǥ(Command) ��ġ���� ������ ������ ����
  //    FAS_SetActualPos   : Motor�� ����(Actual) ��ġ���� ������ ������ ����
  //    FAS_GetCommandPos  : Motor�� ���� ��ǥ(Command) ��ġ���� ����
  //    FAS_GetActualPos   : Motor�� ����(Actual) ��ġ���� �о����
  //    FAS_GetPosError    : Motor�� Position Error��(Actual ��ġ���� Command ��ġ���� ����)�� ����
  //    FAS_GetActualVel   : Motor�� ���� �̵����� ������ ���� ���� �ӵ����� ����
  //    FAS_ClearPosition  : Motor�� ��ǥ(Command) ��ġ���� ����(Actual) ��ġ���� ��0������ ����
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
  // EziMotionPE - ����̺� ���� ���� �Լ�
  //    FAS_GetAxisStatus   : �ش� ����̺��� ���� ���� flag ���� ����
  //    FAS_GetIOAxisStatus : ���� ����� ���¿� ���� ���� flag ���� ���� (������ �Է� ���°�, ��� ���� ���°� �� �������� Flag ���� ����)
  //    FAS_GetMotionStatus : ���� ���� ���� ��Ȳ �� �������� PT ��ȣ�� ���� (Command position, Actual position, �ӵ��� ���� ����)
  //    FAS_GetAllStatus    : ���� ���¸� ��� �����Ͽ� �Ѳ����� ���� (FAS_GetIOAxisStatus+FAS_GetMotionStatus)
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
  // EziMotionPE - ���� ���� �Լ� (Motion Functions, Ex-Motion Functions, Trigger, ...)
  //    FAS_MoveStop              : �������� Motor�� �����ϸ鼭 ����
  //    FAS_EmergencyStop         : �������� Motor�� ���Ӿ��� ��� ����
  //    FAS_MovePause             : �������� ���¿��� ������ �Ͻ� ���� �� �Ͻ� ���� ���¿����� ���� �簳�� �ǽ�
  //    FAS_MoveOriginSingleAxis  : ���� ���� ������ ���� ('����� �Ŵ���_������ 9.3 ���� ����' ����)
  //    FAS_MoveSingleAxisAbsPos  : Motor��? �־��� ����(Absolute) ��ġ������ ������ �ǽ�
  //    FAS_MoveSingleAxisIncPos  : Motor��? �־��� ���(Incremental) ��ġ�� ��ŭ ������ �ǽ�
  //    FAS_MoveToLimit           : ������ �����Ǵ� ��ġ���� ������ �ǽ� (Motor���� �ش� Limit�� ã���� ���?)
  //    FAS_MoveVelocity          : �־��� �ӵ��� �������� ������ ���� (Jog ���� � ���)
  //    FAS_PositionAbsOverride   : Motor�� ���� ��ġ �̵� �� �����Ǿ��� ���� ��ġ���� ���� (�������� ���¿��� ��ǥ ���� ��ġ�� [pulse]�� ����)
  //    FAS_PositionIncOverride   : Motor�� ��� ��ġ �̵� �� �����Ǿ��� ���� ��ġ���� ���� (�������� ���¿��� ��ǥ ��� ��ġ�� [pulse]�� ����)
  //    FAS_VelocityOverride      : Motor�� �̵� �� �����Ǿ��� �ӵ����� ���� (�������� ���¿��� ���� �ӵ���[pps]�� ����)
  //    FAS_MoveLinearAbsPos ?
  //    FAS_MoveLinearIncPos ?
  //    FAS_MoveSingleAxisAbsPosEx: Motor�� Ư�� ���� ��ǥ������ �̵� (�־��� ���� ��ġ�� ��ŭ ������ �ǽ�, ���� �� ���� �ð��� ������ �� ����)
  //    FAS_MoveSingleAxisIncPosEx: Motor�� Ư�� ��� ��ǥ������ �̵� (�־��� ��� ��ġ�� ��ŭ ������ �ǽ�, ���� �� ���� �ð��� ������ �� ����)
  //    FAS_MoveVelocityEx        : Motor�� �־��� �ӵ��� �������� ������ ���� (Jog ����� ���, ���� �� ���� �ð��� ������ �� ����)
  //    FAS_TriggerOutput_RunA    : ��ġ ��ɿ� ���� ���� �� Ư�� ��ġ���� ������ ��½�ȣ(COMP pin)�� �߻�/���� ��Ŵ (Ư�� ��ġ(�ֱ�����)���� ��� ��ȣ�� �߻�) //TBD?
  //    FAS_TriggerOutput_Status  : ���� ��ȣ ��� ����� �۵� ������ ���θ� Ȯ�� (��� ��ȣ(COMP)�� �߻� ���θ� Ȯ��)
  //    FAS_SetTriggerOutputEx    : ������ ��¿� Ư�� ��ġ���� ����� �߻� (�ִ� 60���� �ٸ� ��ġ�� ����)
  //    FAS_GetTriggerOutputEx    : FAS_SetTriggerOutputEx���� ������ ���� �� ��� ���¸� Ȯ��
  //      - FAS_TriggerOutput_RunA, FAS_SetTriggerOutputEx�� ������ �Ŀ� ���� ���� �Լ��� �̿��� Moving �� �� ��� ��ȣ�� �߻�
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
  // EziMotionPE - ������ ���̺� ���� �Լ� (Position Table Functions)
  //    FAS_PosTableReadItem     : Ư�� ������ ���̺��� RAMRAMRAM������ �׸񰪵��� ����
  //    FAS_PosTableWriteItem    : Ư�� ������ ���̺��� �׸��� RAM ������ ����
  //    FAS_PosTableWriteROM     : ��� ������ ���̺� ���� ROM ������ ���� (256 ���� ��� PT ���� �����)
  //    FAS_PosTableReadROM      : ROM ������ ������ ���̺� ������ ���� (256 ���� ��� PT ���� ����)
  //    FAS_PosTableRunItem      : Position Table�� Ư�� Item�� �������� ����� ���� (������ ������ ���̺��� ���������� ������ ����)
  //    FAS_PosTableReadOneItem  : Position Table�� Ư�� Item�� ���� ���� (Ư�� ������ ���̺��� Ư�� �׸��� RAM ������ ���� ����)
  //    FAS_PosTableWriteOneItem : Position Table�� Ư�� Item�� ���� ���� (Ư�� ������ ���̺��� Ư�� �׸� ���� RAM ������ ����)
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
  // EziMotionPE - I/O Module ���� �Լ�	(I/O Module Functions)
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
