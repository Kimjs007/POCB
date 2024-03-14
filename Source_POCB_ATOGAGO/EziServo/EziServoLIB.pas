unit EziServo;

interface

uses
  Winapi.Windows, System.SysUtils,  System.Classes, Vcl.ExtCtrls, defEziServo;

type
  InMotorEvnt = procedure(nCam,nMode,nParam : Integer; sMsg : String) of object; //TBD? POCB_A2CH
  TEziMotor = class(TObject)
    private
      //NEW----
      //OLD----
      m_btBdId, m_nPortNum  : Byte;
      m_nPreActPos          : Integer;
      tmGetPos              : TTimer;
      FMotorStatus          : InMotorEvnt;
      FMotorStatusMaint     : InMotorEvnt;
      //NEW----
      //OLD----
      procedure SetMotorStatus(const Value: InMotorEvnt);
      procedure GetPosDataTimer(Sender: TObject);
      procedure SetMotorStatusMaint(const Value: InMotorEvnt);
    public
      //NEW----
      //OLD----
      m_nActualPos : Integer;
      m_bConnected : Boolean;
      //NEW----
      //OLD----
      constructor Create(btBdId : Byte); virtual;
      destructor Destroy; override;
      property MotorStatus : InMotorEvnt read FMotorStatus write SetMotorStatus;
      property MotorStatusMaint : InMotorEvnt read FMotorStatusMaint write SetMotorStatusMaint;
      procedure Connect(nPortNum,btBdId : Byte);
      procedure Close(nPortNum : Byte);
      procedure ABS_Move(lAbsPos : LONG; lVelocity : DWORD);
      procedure INC_Move(lIncPos : LONG; lVelocity : DWORD);
      procedure StopMove;
      procedure ServoOn(bEnable : Boolean);
      procedure SearchOrigin;
      procedure JogMove(bPlus : Boolean; lVelocity: DWORD);
      procedure LimitMove(bPlus : Boolean; lVelocity: DWORD);
  end;
//const
//{$Include COMM_Define.h}
// Driver 연결 함수.
//FAS_Connect 드라이브 모듈과 통신 연결을 시도합니다. 성공적으로 접속했다면 TRUE 를, 접속에 실패를 했다면 FALSE 를 리턴합니다.
//FAS_Close 드라이브 모듈과 통신 해지를 시도합니다.
//FAS_GetboardInfo  드라이브의 종류와 프로그램 Version 을 읽어들입니다. 드라이브 종류와 Version 정보를 리턴합니다.
//FAS_GetMotorInfo  드라이브에 연결된 모터의 종류와 제조사에 대한 정보를 읽어들입니다.
//FAS_IsboardExist  해당 드라이브의 존재 여부를 확인합니다.  존재하면 TRUE 를, 접속에 실패를 했다면 FALSE 를 리턴합니다.
//FAS_EnableLog     통신 오류 관련 Log 의 출력을 제어합니다. 존재하면 TRUE 를, 접속에 실패를 했다면 FALSE 를 리턴합니다.
//FAS_SetLogPath    출력될 Log 가 저장될 경로를 설정합니다.  존재하면 TRUE 를, 접속에 실패를 했다면 FALSE 를 리턴합니다.
//  EZI_PLUSE_API int WINAPI	FAS_GetSlaveInfo(BYTE iBdID, BYTE* pType, LPSTR lpBuff, int nBuffSize);
//  DLLCallTypeStdcall: function (AStr : string)  : PChar;  stdcall;

  function  FAS_Connect(nPortNo : Byte;dwBaud : DWORD) : Integer ; stdcall;   external 'EziMOTIONPlusR.dll';
  function  FAS_OpenPort(nPortNo : Byte;dwBaud : DWORD) : Integer ; stdcall;   external 'EziMOTIONPlusR.dll';
  procedure FAS_Close(nPortNo : Byte) ; stdcall;   external 'EziMOTIONPlusR.dll';

//  function  FAS_IsBdIDExist(iBdID : Byte;var sb1, sb2, sb3, sb4 : Byte) : Integer ; stdcall;   external 'EziMOTIONPlusR.dll';
//  function  FAS_IsIPAddressExist( sb1, sb2, sb3, sb4: Byte; var iBdID : Byte) : Integer ; stdcall;   external 'EziMOTIONPlusR.dll';
  function  FAS_IsSlaveExist(nPortNo : Byte; nSlaveNo : Byte) : Integer ; stdcall;   external 'EziMOTIONPlusR.dll';
  function  FAS_GetSlaveInfo(nPortNo,iBdID : Byte; var pType : Byte; lpBuff : PAnsiChar; nBuffSize : Integer) : Integer ; stdcall;   external 'EziMOTIONPlusR.dll';

////------------------------------------------------------------------------------
////			Servo Driver Control Functions
////------------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_ServoEnable(BYTE iBdID, BOOL bOnOff);
//EZI_PLUSE_API int WINAPI	FAS_ServoAlarmReset(BYTE iBdID);
//EZI_PLUSE_API int WINAPI	FAS_StepAlarmReset(BYTE iBdID, BOOL bReset);
// 서보 제어 함수
//FAS_ServoEnable 지정한 드라이브의 Servo 상태를 ON/OFF 시킵니다.
//FAS_ServoAlarmReset  알람이 발생한 드라이브의 알람을 해제시킵니다 , 알람이 발생한 원인을 제거한 후 실시하십시오.
//FAS_GetAlarmType 현재 알람의 발생 여부 및 알람의 종류를 확인합니다
  function  FAS_ServoEnable(nPortNo,nSlaveNo : Byte; bOnOff : BOOL) : Integer ; stdcall;   external 'EziMOTIONPlusR.dll';
  function  FAS_ServoAlarmReset(nPortNo,nSlaveNo : Byte) : Integer ; stdcall;   external 'EziMOTIONPlusR.dll';
  function  FAS_StepAlarmReset(nPortNo,nSlaveNo : Byte; bReset : BOOL) : Integer ; stdcall;   external 'EziMOTIONPlusR.dll';

  function  FAS_SetParameter(nPortNo,nSlaveNo : Byte;iParamNo : Byte; lParamValue : LongInt) : integer;stdcall;   external 'EziMOTIONPlusR.dll';

//// 위치 제어 함수
//FAS_SetCommandPos 목표(Command) 위치값을 임의의 값으로 설정합니다.
//FAS_SetActualPos 실제(Actual) 위치값을 임의의 값으로 설정합니다.
//FAS_GetCommandPos 현재 목표(Command) 위치값을 읽어들입니다.
//FAS_GetActualPos 실제(Actual) 위치값을 읽어들입니다.
//FAS_GetPosError  현재 실제(Actual) 위치값과 목표 위치(Command)값의 차이를 읽어들입니다.
//FAS_GetActualVel 현재 이동중인 운전의 실제 운전 속도값을 읽어들입니다.
//FAS_ClearPosition  목표(Command) 위치값과 실제(Actual) 위치값을 ‘0’으로   설정합니다.
//------------------------------------------------------------------------------
//		 Position
//------------------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_SetCommandPos(BYTE iBdID, long lCmdPos);
//EZI_PLUSE_API int WINAPI	FAS_SetActualPos(BYTE iBdID, long lActPos);
//EZI_PLUSE_API int WINAPI	FAS_ClearPosition(BYTE iBdID);
//EZI_PLUSE_API int WINAPI	FAS_GetCommandPos(BYTE iBdID, long* lCmdPos);
//EZI_PLUSE_API int WINAPI	FAS_GetActualPos(BYTE iBdID, long* lActPos);
//EZI_PLUSE_API int WINAPI	FAS_GetPosError(BYTE iBdID, long* lPosErr);
//EZI_PLUSE_API int WINAPI	FAS_GetActualVel(BYTE iBdID, long* lActVel);
//EZI_PLUSE_API int WINAPI	FAS_GetAlarmType(BYTE iBdID, BYTE* nAlarmType);
  function FAS_SetCommandPos (nPortNo, iBdID : Byte; lCmdPos : LONG) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_SetActualPos (nPortNo, iBdID : Byte; lActPos : LONG) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_ClearPosition (nPortNo, iBdID : Byte) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_GetCommandPos (nPortNo, iBdID : Byte;var lCmdPos : LONG) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_GetActualPos (nPortNo, iBdID : Byte;var lActPos : LONG) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_GetPosError (nPortNo, iBdID : Byte;var lPosErr : LONG) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_GetActualVel (nPortNo, iBdID : Byte;var lActVel : LONG) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_GetAlarmType (nPortNo, iBdID : Byte;var nAlarmType : Byte) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';

//FAS_MoveStop 운전중인 모터를 감속하면서 정지시킵니다.
//FAS_EmergencyStop 운전중인 모터를 감속없이 즉시 정지시킵니다.
//FAS_MoveOriginSingleAxis 원점 복귀 운전을 시작합니다.
//FAS_MoveSingleAxisAbsPos 주어진 절대(Absolute) 위치값 만큼 운전을 실시합니다.
//FAS_MoveSingleAxisIncPos 주어진 상대(Incremental) 위치값 만큼 운전을 실시합니다.
//FAS_MoveToLimit Limit 센서가 감지되는 위치까지 운전을 실시합니다.
//FAS_MoveVelocity      주어진 속도와 방향으로 운전을 시작합니다   Jog 운전 등에 사용됩니다.
//FAS_PositionAbsOverride 운전중인 상태에서 목표 절대 위치값 [pulse]을 변경 합니다.
//FAS_PositionIncOverride 운전중인 상태에서 목표 상대 위치값 [pulse]을 변경 합니다.
//FAS_VelocityOverride 운전중인 상태에서 운전 속도값[pps]을 변경 합니다.
//FAS_MoveSingleAxisAbsPosEx   주어진 절대(Absolute) 위치값 만큼 운전을 실시합니다.  가속 및 감속 시간을 설정할 수 있습니다.
//FAS_MoveSingleAxisIncPosEx   주어진 상대(Incremental) 위치값 만큼 운전을 실시합니다. 가속 및 감속 시간을 설정할 수 있습니다.
//FAS_MoveVelocityEx           주어진 속도와 방향으로 운전을 시작합니다 Jog 운전등에 사용됩니다. 가속 및 감속 시간을 설정할 수 있습니다.
//FAS_MovePause               운전중인 상태에서 운전의 일시 정지 및 일시 정지  상태에서의 운전 재개를 실시합니다.
//------------------------------------------------------------------
//			Motion Functions.
//------------------------------------------------------------------
//EZI_PLUSE_API int WINAPI	FAS_MoveStop(BYTE iBdID);
//EZI_PLUSE_API int WINAPI	FAS_EmergencyStop(BYTE iBdID);
//EZI_PLUSE_API int WINAPI	FAS_MovePause(BYTE iBdID, BOOL bPause);
//EZI_PLUSE_API int WINAPI	FAS_MoveOriginSingleAxis(BYTE iBdID);
//EZI_PLUSE_API int WINAPI	FAS_MoveSingleAxisAbsPos(BYTE iBdID, long lAbsPos, DWORD lVelocity);
//EZI_PLUSE_API int WINAPI	FAS_MoveSingleAxisIncPos(BYTE iBdID, long lIncPos, DWORD lVelocity);
//EZI_PLUSE_API int WINAPI	FAS_MoveToLimit(BYTE iBdID, DWORD lVelocity, int iLimitDir);
//EZI_PLUSE_API int WINAPI	FAS_MoveVelocity(BYTE iBdID, DWORD lVelocity, int iVelDir);
  function FAS_MoveStop (nPortNo, iBdID : Byte) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_EmergencyStop (nPortNo, iBdID : Byte) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_MovePause (nPortNo, iBdID : Byte; bPause : BOOL) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_MoveOriginSingleAxis (nPortNo, iBdID : Byte) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_MoveSingleAxisAbsPos (nPortNo, iBdID : Byte; lAbsPos : LONG; lVelocity : DWORD) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_MoveSingleAxisIncPos (nPortNo, iBdID : Byte; lIncPos : LONG; lVelocity : DWORD) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_MoveToLimit (nPortNo, iBdID : Byte; lVelocity: DWORD; iLimitDir : Integer) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_MoveVelocity (nPortNo, iBdID : Byte; lVelocity: DWORD; iVelDir : Integer) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';

//EZI_PLUSE_API int WINAPI	FAS_PositionAbsOverride(BYTE iBdID, long lOverridePos);
//EZI_PLUSE_API int WINAPI	FAS_PositionIncOverride(BYTE iBdID, long lOverridePos);
//EZI_PLUSE_API int WINAPI	FAS_VelocityOverride(BYTE iBdID, DWORD lVelocity);
//EZI_PLUSE_API int WINAPI	FAS_MoveLinearAbsPos(BYTE nNoOfBds, BYTE* iBdID, long* lplAbsPos, DWORD lFeedrate, WORD wAccelTime);
//EZI_PLUSE_API int WINAPI	FAS_MoveLinearIncPos(BYTE nNoOfBds, BYTE* iBdID, long* lplIncPos, DWORD lFeedrate, WORD wAccelTime);
//EZI_PLUSE_API int WINAPI	FAS_TriggerOutput_RunA(BYTE iBdID, BOOL bStartTrigger, long lStartPos, DWORD dwPeriod, DWORD dwPulseTime);
//EZI_PLUSE_API int WINAPI	FAS_TriggerOutput_Status(BYTE iBdID, BYTE* bTriggerStatus);
//EZI_PLUSE_API int WINAPI	FAS_SetTriggerOutputEx(BYTE iBdID, BYTE nOutputNo, BYTE bRun, WORD wOnTime, BYTE nTriggerCount, long* arrTriggerPosition);
//EZI_PLUSE_API int WINAPI	FAS_GetTriggerOutputEx(BYTE iBdID, BYTE nOutputNo, BYTE* bRun, WORD* wOnTime, BYTE* nTriggerCount, long* arrTriggerPosition);
//EZI_PLUSE_API int WINAPI	FAS_MovePush(BYTE iBdID, DWORD dwStartSpd, DWORD dwMoveSpd, long lPosition, WORD wAccel, WORD wDecel, WORD wPushRate, DWORD dwPushSpd, long lEndPosition, WORD wPushMode);
//EZI_PLUSE_API int WINAPI	FAS_GetPushStatus(BYTE iBdID, BYTE* nPushStatus);
  function FAS_PositionAbsOverride (nPortNo, iBdID : Byte; lOverridePos : LONG) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_PositionIncOverride (nPortNo, iBdID : Byte; lOverridePos : LONG) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_VelocityOverride (nPortNo, iBdID : Byte; lVelocity : DWORD) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_MoveLinearAbsPos (nPortNo, nNoOfBds : Byte; var iBdID : Byte; var lplAbsPos : LONG;  lFeedrate : DWORD; wAccelTime : Word) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_MoveLinearIncPos (nPortNo, nNoOfBds : Byte; var iBdID : Byte; var lplIncPos : LONG;  lFeedrate : DWORD; wAccelTime : Word) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  // 나중에... 지금은 많이 바쁨.
  //  function FAS_TriggerOutput_RunA ( iBdID : Byte) : Integer ; stdcall;  external 'EziMOTIONPlusE.dll';
//  function FAS_TriggerOutput_Status ( iBdID : Byte) : Integer ; stdcall;  external 'EziMOTIONPlusE.dll';
//  function FAS_SetTriggerOutputEx ( iBdID : Byte) : Integer ; stdcall;  external 'EziMOTIONPlusE.dll';
//  function FAS_GetTriggerOutputEx ( iBdID : Byte) : Integer ; stdcall;  external 'EziMOTIONPlusE.dll';
  function FAS_MovePush ( iBdID : Byte;  dwStartSpd,  dwMoveSpd :DWORD; lPosition : LONG; wAccel,  wDecel, wPushRate : Word; dwPushSpd : DWORD;lEndPosition : LONG; wPushMode : Word) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';
  function FAS_GetPushStatus ( iBdID : Byte; var nPushStatus : Byte) : Integer ; stdcall;  external 'EziMOTIONPlusR.dll';

var
 EziMotor :  TEziMotor;
implementation

{ TEziMotor }

procedure TEziMotor.ABS_Move(lAbsPos: LONG; lVelocity: DWORD);
var
  nRet : Integer;
  nCam : Integer;
begin
  nCam := 0;  //TBD?
  nRet := FAS_MoveSingleAxisAbsPos(m_nPortNum, m_btBdId,lAbsPos,lVelocity);
  if Assigned(MotorStatusMaint) then MotorStatusMaint(nCam,DefEziServo.MODE_ABS_AXIS_MOVE,nRet,'FAS_MoveSingleAxisAbsPos');  //TBD?
end;

procedure TEziMotor.Close(nPortNum: Byte);
begin
  if nPortNum = 0 then Exit;
  if m_nPortNum = 0 then Exit;
  if not m_bConnected then Exit;
  m_bConnected := False;
  FAS_Close(m_nPortNum);
end;

procedure TEziMotor.Connect(nPortNum,btBdId : Byte);
var
  btSb1, btSb2, btSb3, btSb4, nType : byte;
  nRet, nBuffSize, nActPos : Integer;
  btBuff : array of byte;
  sMsg : string;
  nCam : Integer; //TBD? POCB_A2CH
begin
//  btSb1 := 192; btSb2 := 168; btSb3 := 0; btSb4 := 2; // IP 192.168.0.2에 접속하도록 한다.
// m_btBdId ==> Slave no.
  m_btBdId := $ff; nBuffSize := 256;
  m_nPortNum := 0;
  nCam := 0;  //TBD? POCB_A2CH
  SetLength(btBuff,nBuffSize);
  m_bConnected := False;
  // Return값이 0이면 NG, 1이면 OK.
  if FAS_Connect(nPortNum,115200) <> 0 then begin
    // Connect.
    m_nPortNum := nPortNum;
    m_btBdId := btBdId;

    m_bConnected := True;
    sMsg := 'Connected';
    MotorStatus(nCam,DefEziServo.MODE_MOTOR_CONNECT,1,sMsg);  //TBD? POCB_A2CH
    if Assigned(MotorStatusMaint) then MotorStatusMaint(nCam,DefEziServo.MODE_MOTOR_CONNECT,1,sMsg);

    if FAS_IsSlaveExist(nPortNum,btBdId) = 0 then begin // board ID가 존재 하지 않으면,
      // 해당 board 번호는 존재하지 않습니다.
      // Ezi-SERVOⅡ의 board 번호를 확인하십시오.
      sMsg := '해당 board 번호는 존재하지 않습니다, Ezi-SERVOⅡ의 board 번호를 확인하십시오 ';
      MotorStatus(nCam,DefEziServo.MODE_MOTOR_BOARD_CHECK,0,sMsg);
      if Assigned(MotorStatusMaint) then MotorStatusMaint(nCam,DefEziServo.MODE_MOTOR_BOARD_CHECK,0,sMsg);
      Exit;
    end;
    if FAS_GetSlaveInfo(nPortNum,btBdId,nType,PAnsiChar(btBuff),nBuffSize) <> defEziServo.FMM_OK then begin
      sMsg := '해당 Board의 정보를 받을수 없습니다.';
      MotorStatus(nCam,DefEziServo.MODE_GET_SLAVE_INFO,nType,sMsg);
      if Assigned(MotorStatusMaint) then MotorStatusMaint(nCam,DefEziServo.MODE_GET_SLAVE_INFO,nType,sMsg);
      Exit;
    end;
    sMsg := 'Get Slave Info : '+ StrPas(PAnsiChar(btBuff));
    MotorStatus(nCam,DefEziServo.MODE_GET_SLAVE_INFO,1,sMsg);
    if Assigned(MotorStatusMaint) then MotorStatusMaint(nCam,DefEziServo.MODE_GET_SLAVE_INFO,1,sMsg);
    // Servo On 하자.
    FAS_ServoEnable(nPortNum,btBdId,True);
    MotorStatus(nCam,DefEziServo.MODE_GET_SLAVE_INFO,1,'Servo On');
    tmGetPos.Enabled := True;

//    {nRtn = FAS_GetSlaveInfo(iBdID, &nType, lpBuff, nBuffSize);
//if (nRtn != FMM_OK)
//{
//// 명령이 정상적으로 수행되지 않았습니다.
//// ReturnCodes_Define.h 를 참조하십시오.
//}
//printf("Port : %d (board %d) \n", iBdID);
//printf("\tType : %d \n", nType);
//printf("\tVersion : %d \n", lpBuff );
//}
  end
  else begin

    // 연결에 실패.
    sMsg := 'MOTOR 연결에 실패';
    MotorStatus(nCam,DefEziServo.MODE_MOTOR_CONNECT,0,sMsg);
  end;
end;

constructor TEziMotor.Create(btBdId : Byte);
begin
  m_btBdId := btBdId;
  m_nPortNum := 0;
  tmGetPos := TTimer.Create(nil);
  tmGetPos.OnTimer := GetPosDataTimer;
  tmGetPos.Interval := 500;
  tmGetPos.Enabled := False;
  // 임의값 설정.
  m_nPreActPos := -82763;
end;

destructor TEziMotor.Destroy;
var
  nCam : Integer;
begin
  nCam := 0; //TBD? POCB_A2CH
  // Servo Off.
//  if m_nPortNum <> 0 then FAS_ServoEnable(m_nPortNum,m_btBdId,False);
  tmGetPos.Enabled := False;
  tmGetPos.Free;
  tmGetPos := nil;
  if m_bConnected then begin
    FAS_close(m_nPortNum);
    m_bConnected := False;
    MotorStatus(nCam,DefEziServo.MODE_MOTOR_CONNECT,0,'Close Connection');
  end;
  MotorStatus(nCam,DefEziServo.MODE_MOTOR_CONNECT,0,'Close Class');
  inherited;
end;

procedure TEziMotor.GetPosDataTimer(Sender: TObject);
var
  nActPos : Integer;
  sDebug : string;
  nCam : Integer;
begin
  nCam := 0; //TBD? POCB_A2CH
  nActPos := 0;
  tmGetPos.Enabled := False;
  FAS_GetActualPos(m_nPortNum,m_btBdId,nActPos);
  // GUI의 부하를 줄이기 위해서 Event가 있을때만 Display.
  if m_nPreActPos <> nActPos then begin
    MotorStatus(nCam,DefEziServo.MODE_GET_ACTUAL_POS,nActPos,'');
    if Assigned(MotorStatusMaint) then begin
      sDebug := Format('Get Current Actual Position : %d',[nActPos]);
      MotorStatusMaint(nCam,DefEziServo.MODE_GET_ACTUAL_POS,nActPos,sDebug);
    end;
  end;
  m_nPreActPos :=  nActPos;
  tmGetPos.Enabled := True;
end;

procedure TEziMotor.INC_Move(lIncPos: LONG; lVelocity: DWORD);
var
  nRet : Integer;
  nCam : Integer;
begin
  nCam := 0; //TBD? POCB_A2CH
  nRet := FAS_MoveSingleAxisIncPos(m_nPortNum,m_btBdId,lIncPos,lVelocity);
  if Assigned(MotorStatusMaint) then MotorStatusMaint(nCam,DefEziServo.MODE_INC_AXIS_MOVE,nRet,'FAS_MoveSingleAxisIncPos');
end;

procedure TEziMotor.JogMove(bPlus: Boolean; lVelocity: DWORD);
var
  nDirection : Integer;
begin
  if bPlus then nDirection := 1
  else          nDirection := 0;
  FAS_MoveVelocity(m_nPortNum,m_btBdId,lVelocity,nDirection)
end;

procedure TEziMotor.LimitMove(bPlus: Boolean; lVelocity: DWORD);
var
  nDirection : Integer;
begin
  if bPlus then nDirection := 1
  else          nDirection := 0;
  FAS_MoveToLimit(m_nPortNum,m_btBdId,lVelocity,nDirection)
end;

procedure TEziMotor.SearchOrigin;
begin
//  if FAS_SetParameter(m_nPortNum,m_btBdId,17,1) = FMM_OK then begin
    FAS_MoveOriginSingleAxis(m_nPortNum,m_btBdId);
//  end;

end;

procedure TEziMotor.ServoOn(bEnable: Boolean);
begin
  FAS_ServoEnable(m_nPortNum,m_btBdId,bEnable);
  tmGetPos.Enabled := bEnable;
end;

procedure TEziMotor.SetMotorStatus(const Value: InMotorEvnt);
begin
  FMotorStatus := Value;
end;

procedure TEziMotor.SetMotorStatusMaint(const Value: InMotorEvnt);
begin
  FMotorStatusMaint := Value;
end;

procedure TEziMotor.StopMove;
var
  nRet : Integer;
  nCam : Integer;
begin
  nCam := 0;  //TBD? POCB_A2CH
  nRet := FAS_MoveStop(m_nPortNum,m_btBdId);
  if Assigned(MotorStatusMaint) then MotorStatusMaint(nCam,DefEziServo.MODE_MOVE_STOP,nRet,'Stop Move');
end;

end.
