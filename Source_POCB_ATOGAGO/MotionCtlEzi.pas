unit MotionCtlEzi;

interface
{$I Common.inc}

{$IFDEF USE_MOTION_EZIML}
uses
  Winapi.Windows, System.SysUtils,  System.Classes, Vcl.ExtCtrls,
  EziMLDef, EziMLLIB,  // 3rd-party Classes
  DefPocb, DefMotion, CommonClass;

//const

type
 
  TMotionEzi = class(TObject)
    private
      m_hMain       		: HWND;
    public
			m_nMotionID   		: Integer;	// A2CH: Axt(0~3), Ezi(4~5)
			m_nMotionDev   		: Integer;	// A2CH: Axt, EziMLPE
      m_nCh         		: Integer;	// A2CH: ch1~ch2
			m_nAxisType   		: Integer;	// A2CH: Z-axis, Y-axis, Focus
			m_nMotorNo   			: Integer;	// A2CH: nMotorNo(common) = nAxisNo(Axt) = nBdNo(Ezi)
			m_nAxisNo    			: Integer;	// A2CH: 'nAxisNo' for Axt(0~3), 'nBdNo' for Ezi(0~1)
			m_nBdNo    				: Integer;	// A2CH: 'nAxisNo' for Axt(0~3), 'nBdNo' for Ezi(0~1)
      //
      m_bConnected      : Boolean;
      m_bServoOn        : Boolean;
      m_sErrLibApi      : string;
      m_sDeviceVersion  : string;
      //
      constructor Create(hMain: THandle; nMotionID: Integer; nCh: Integer; nAxisType: Integer; nMotorNo: Integer); virtual;
      destructor Destroy; override;
			//---------------------- TMotionEzi: Connect/Close/MotorInit
			function Connect: Integer;
			procedure Close;
			function MotorInit: Integer;
			function MotorReset: Integer;
			function ServoOnOff(bIsOn: Boolean): Integer;
			//---------------------- TMotionEzi: Move Start/Stop
      function MoveStart(dVel: DWORD; dAccel: DWORD): Integer;
			function MoveStop(bIsEMS: Boolean = False): Integer;
			//---------------------- TMotionEzi: Move To Home/Limit/Position
			function MoveToHome(nSearchDir: Byte; bDoPreCheck: Boolean = False): Integer;
			function MoveToLimit(bPLusLimit: Boolean; dVel: DWORD): Integer;
			function MoveToPosition(dPos: LONG; dVel: DWORD): Integer;
			//---------------------- TMotorAxt: Move ABS/INC/JOG
			function MoveABS(dAbsPos: LONG; dVel: DWORD): Integer;
			function MoveINC(dIncPos: LONG; dVel: DWORD): Integer;
			function MoveJOG(bPlus: Boolean; dVel: DWORD): Integer;
			//---------------------- TMotionEzi: Get
			function GetActPos(var dActPos: LONG): Integer;
			function GetCmdPos(var dCmdPos: LONG): Integer;
			function IsMotorHome: Boolean;
			function IsMotorMoving: Boolean;
			//---------------------- TMotionEzi: Set
			function SetActPos(dActPos: LONG): Integer;
			function SetCmdPos(dCmdPos: LONG): Integer;
  end;

//var
  //m_bConnected : Boolean;  //TBD?
//MotionEzi 	: array[DefMotion.EziML_BDNO_BASE..DefMotion.EziML_BDNO_MAX] of TMotorEzi;
{$ENDIF}

implementation

{$IFDEF USE_MOTION_EZIML}
//##############################################################################
//
{ TMotionEzi }
//
//##############################################################################

//******************************************************************************
// procedure/function: TMotionEzi: Create/Destroy/Init
//		- constructor TMotionEzi.Create(hMain: THandle; nMotionID: Integer; nCh: Integer; nAxisType: Integer; nMotorNo: Integer);
//		- destructor TMotionEzi.Destroy;
//******************************************************************************

//------------------------------------------------------------------------------
constructor TMotionEzi.Create(hMain: THandle; nMotionID: Integer; nCh: Integer; nAxisType: Integer; nMotorNo: Integer);
begin
  m_hMain := hMain;
  //-------------------------- Motion Variables
	m_nMotionID 	:= nMotionID;
	m_nMotionDev 	:= DefMotion.MOTION_DEV_EziML;
	m_nCh 				:= nCh;
	m_nAxisType 	:= nAxisType;
	m_nMotorNo 		:= nMotorNo;
	m_nAxisNo 		:= nMotorNo;
	m_nBdNo 			:= nMotorNo;
  //-------------------------- Motion Parameters
  //TBD?
end;

//------------------------------------------------------------------------------
destructor TMotionEzi.Destroy;
begin
  //TBD? (� ���? � ���ǿ���?)
  //FAS_ServoEnable(m_nBdNo,False);
  //
  if m_bConnected then begin
    FAS_close(m_nBdNo);
    //
    m_bConnected := False;
  end;

  inherited;
end;

//******************************************************************************
// procedure/function: TMotionEzi: Connect/Close/MotorInit
//    -	function TMotionEzi.Connect: Integer;
//    -	procedure TMotionEzi.Close;
//		- function TMotionEzi.MotorInit: Integer;
//		- function TMotionEzi.MotorReset: Integer;
//		- function TMotionEzi.ServoOnOff(bIsOn: Boolean): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionEzi.Connect: Integer;
var
	nErrCode 	: Integer;
  nBuffSize : Integer;
  btBuff 		: array of byte;
  btSb1, btSb2, btSb3, btSb4, nType : Byte;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_CONNECT;
  //
  btSb1 := DefMotion.EziMLPE_IP_SB1;
  btSb2 := DefMotion.EziMLPE_IP_SB2;
  btSb3 := DefMotion.EziMLPE_IP_SB3;
  btSb4 := DefMotion.EziMLPE_IP_SB4_BASE + m_nBdNo;
  nBuffSize := 256;
  SetLength(btBuff,nBuffSize);
  m_bConnected := False;
  //-------------------------- �ش� ����̺꿡 ����
  // Return���� 0�̸� NG, 1�̸� OK.
  if (not FAS_Connect(btSb1,btSb2,btSb3,btSb4,m_nBdNo)) then begin
		Exit(nErrCode);	// ERR_EZIML_DEVICE_CONNECT);
	end;
  //-------------------------- �ش� ����̺��� ���� ���θ� Ȯ��
  if not FAS_IsSlaveExist(m_nBdNo) then begin
		Exit(nErrCode);	// ERR_EZIML_UNKNOWN_BOARD_ID);
	end;
  m_bConnected := True;
	m_sDeviceVersion := '';	// Clear
  //-------------------------- ����̺��� ������ ���α׷� Verion�� Ȯ��
  if (FAS_GetSlaveInfo(m_nBdNo,nType,PAnsiChar(btBuff),nBuffSize) <> EziMLDef.FMM_OK) then begin
		m_sErrLibApi := 'FAS_GetSlaveInfo('+IntToStr(m_nBdNo)+','+IntToStr(nType)+')';
		Exit(nErrCode);	// ERR_EZIML_UNKNOWN_BOARD_INFO);
  end;
	m_sDeviceVersion := StrPas(PAnsiChar(btBuff));
	//
	Result := ERR_OK;
end;

//------------------------------------------------------------------------------
procedure TMotionEzi.Close;
begin
  //if not m_bMotorConnected then Exit;
  //-------------------------- ����̺� ��ƫ�� ��� ������ �õ�
  FAS_Close(m_nBdNo);
  //-------------------------- 
  m_bConnected := False;
end;

//------------------------------------------------------------------------------
function TMotionEzi.MotorInit: Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_INIT;
	// 
	if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
	end;
  //-------------------------- Servo On 
	nRet := FAS_ServoEnable(m_nBdNo,True);
	if (nRet <> FMM_OK) then begin
		m_bServoOn 		:= False;
		m_sErrLibApi 	:= 'FAS_ServoEnable(True)';
		Exit(nErrCode);
	end;
	Sleep(500);
	m_bServoOn := True;
  //--------------------------
	Result := ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionEzi.MotorReset: Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_RESET;
	// 
	if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
	end;
  //--------------------------
	nRet := FMM_OK;
	if (nRet <> FMM_OK) then begin
		m_sErrLibApi 	:= 'TBD';
		Exit(nErrCode);
	end;
	Sleep(100);
	Result := ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionEzi.ServoOnOff(bIsOn: Boolean): Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
begin
	m_sErrLibApi 	:= '';
	if bIsOn then nErrCode := DefPocb.ERR_MOTION_SERVO_ON
	else  			  nErrCode := DefPocb.ERR_MOTION_SERVO_OFF;
	//
	// ���� ���� �Լ� -------------------
	//	- ������ ����̺��� Servo ���¸� ON/OFF ��ŵ�ϴ�.
	//		(Remarks: Enable �� Axis Status�� Servo ON flag�� ON�� �Ǵµ��� �����ð��� �ҿ��)
  //		FAS_ServoEnable(m_nBdNo,bIsOn);
	//	- �˶��� �߻��� ����̺��� �˶��� ������ŵ�ϴ�.
  //		int FAS_ServoAlarmReset(BYTE iBdID, BOOL bOnOff);
	//
  nRet := FAS_ServoEnable(m_nBdNo,bIsOn);
	if (nRet <> FMM_OK) then begin
		if bIsOn then m_sErrLibApi := 'FAS_ServoEnable(True)'
		else  			  m_sErrLibApi := 'FAS_ServoEnable(False)';
		Exit(nErrCode);
	end;
	Result := ERR_OK;
end;

//******************************************************************************
// procedure/function: TMotionEzi: Move Start/Stop
//		- function TMotionEzi.MoveStart(dVel: Double; dAccel: Double): Integer;
//		- function TMotionEzi.MoveStop(bIsEMS: Boolean = False): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionEzi.MoveStart(dVel: DWORD; dAccel: DWORD): Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_START;
	//
	nRet := 1;
	if (nRet <> FMM_OK) then begin
		m_sErrLibApi := 'TBD';
		Exit(nErrCode);
	end;
	Result := ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionEzi.MoveStop(bIsEMS: Boolean = False): Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_STOP;
	//
	// ���� ���� �Լ� (����)-------------------
	//  - Motor�� ������
	//		int FAS_EmergencyStop(BYTE iBdID);
	//  - Motor�� ����
	//		int FAS_MoveStop(BYTE iBdID);
	if (bIsEMS) then nRet := FAS_EmergencyStop(m_nBdNo)
	else 						 nRet := FAS_MoveStop(m_nBdNo);
	if (nRet <> FMM_OK) then begin
		if (bIsEMS) then m_sErrLibApi := 'FAS_EmergencyStop'
		else             m_sErrLibApi := 'FAS_MoveStop';
		Exit(nErrCode);
	end;
	Result := ERR_OK;
end;

//******************************************************************************
// procedure/function: TMotionEzi: Move To Home/Limit/Position
//		- function TMotionEzi.MoveToHome(nSearchDir: Byte, bDoPreCheck: Boolean = False): Integer;
//		- function TMotionEzi.MoveToLimit(bPLusLimit: Boolean, dVel: DWORD): Integer;
//		- function TMotionEzi.MoveToPosition(dPos: LONG; dVel: DWORD): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionEzi.MoveToHome(nSearchDir: Byte; bDoPreCheck: Boolean = False): Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_TO_HOME;
	//TBD? (bDoPreCheck)
	//TBD? (bSearchDir)
	//
	//TBD? if FAS_SetParameter(m_nPortNum,m_nBdNo,17 ?,1 ?) <> FMM_OK then begin	//TBD?
	//TBD?		m_sErrLibApi := 'FAS_SetParameter';
	//TBD?		Exit(nErrCode);
	//TBD? end;
	nRet := FAS_MoveOriginSingleAxis(m_nBdNo);
	if (nRet <> FMM_OK) then begin
		m_sErrLibApi := 'FAS_MoveOriginSingleAxis';
		Exit(nErrCode);
	end;
	Result := ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionEzi.MoveToLimit(bPLusLimit: Boolean; dVel: DWORD): Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
  nDirection: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_TO_LIMIT;
	//
  if bPlusLimit then nDirection := 1
  else          		 nDirection := 0;
	nRet := FAS_MoveToLimit(m_nBdNo,dVel,nDirection);
	if (nRet <> FMM_OK) then begin
		m_sErrLibApi := 'FAS_MoveToLimit';
		Exit(nErrCode);
	end;
	Result := ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionEzi.MoveToPosition(dPos: LONG; dVel: DWORD): Integer;	//TBD:MOTION:EZI?
var
	nRet 			: Integer;
	nErrCode 	: Integer;
//nDirection: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_TO_POS;
	//
	nRet := 1;	//TBD:MOTION:EZI?
	if (nRet <> FMM_OK) then begin
		m_sErrLibApi := 'TBD';
		Exit(nErrCode);
	end;
	Result := ERR_OK;
end;

//******************************************************************************
// procedure/function: TMotionEzi: Move ABS/INC/JOG
//		- function TMotionEzi.MoveABS(dAbsPos: LONG; dVel: DWORD): Integer;
//		- function TMotionEzi.MoveINC(dIncPos: LONG; dVel: DWORD): Integer;
//		- function TMotionEzi.MoveJOG(bPlus: Boolean; dVel: DWORD): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionEzi.MoveABS(dAbsPos: LONG; dVel: DWORD): Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_ABS;	//TBD?
	//
	nRet := FAS_MoveSingleAxisAbsPos(m_nBdNo,dAbsPos,dVel);
	if (nRet <> FMM_OK) then begin
		m_sErrLibApi := 'FAS_MoveSingleAxisAbsPos';
		Exit(nErrCode);
	end;
	Result := ERR_OK;
end;


//------------------------------------------------------------------------------
function TMotionEzi.MoveINC(dIncPos: LONG; dVel: DWORD): Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_INC;	//TBD?
	//
	nRet := FAS_MoveSingleAxisIncPos(m_nBdNo,dIncPos,dVel);
	if (nRet <> FMM_OK) then begin
		m_sErrLibApi := 'FAS_MoveSingleAxisIncPos';
		Exit(nErrCode);
	end;
	Result := ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionEzi.MoveJOG(bPlus: Boolean; dVel: DWORD): Integer;
var
	nRet 			: Integer;
	nErrCode 	: Integer;
  nDirection: Integer;	//TBD?
begin
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_MOVE_JOG;	//TBD?
	//
  if bPlus then nDirection := 1
  else          nDirection := 0;
	nRet := FAS_MoveVelocity(m_nBdNo,dVel,nDirection);	//TBD?
	if (nRet <> FMM_OK) then begin
		m_sErrLibApi := 'FAS_MoveVelocity';
		Exit(nErrCode);
	end;
	Result := ERR_OK;
end;

//******************************************************************************
// procedure/function: TMotionEzi: Get
//		- function TMotionEzi.GetActPos(var dActPos: LONG); Integer;	//TBD?
//		- function TMotionEzi.GetCmdPos(var dActPos: LONG); Integer;	//TBD?
//		- function TMotionEzi.IsMotorHome: Boolean;	//TBD?
//		- function TMotionEzi.IsMotorMoving: Boolean;	//TBD?
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionEzi.GetActPos(var dActPos: LONG): Integer;	//TBD?
var
	nRet 			: Integer;
  nErrCode  : Integer;
begin
	//TBD? (����Ȯ�� �ʿ����? b_Connected?)
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_GET_ACT_POS;	//TBD?
	//-------------------------- ������ ���¿��� �ܺ� ��ġ�� Ư�� ������ Ȯ��(position = Unit)
	//TBD? dActPos := 0;	//TBD?
	nRet := FAS_GetActualPos(m_nBdNo,dActPos);
	if (nRet <> FMM_OK) then begin
		m_sErrLibApi := 'FAS_GetActualPos';
		Exit(nErrCode);
	end;
	Result := ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionEzi.GetCmdPos(var dCmdPos: LONG): Integer;	//TBD?
var
	nRet 			: Integer;
  nErrCode  : Integer;
begin
	//TBD? (����Ȯ�� �ʿ����? b_Connected?)
	m_sErrLibApi 	:= '';
	nErrCode 			:= DefPocb.ERR_MOTION_GET_CMD_POS;	//TBD?
	//-------------------------- ������ ���¿��� �ܺ� ��ġ�� Ư�� ������ Ȯ��(position = Unit)
	//TBD? dCmdPos := 0;	//TBD?
	nRet := FAS_GetCommandPos(m_nBdNo,dCmdPos);
	if (nRet <> FMM_OK) then begin
		m_sErrLibApi := 'FAS_GetCommandPos';
		Exit(nErrCode);
	end;
	Result := ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionEzi.IsMotorHome: Boolean;	//TBD?
begin
	//TBD? (����Ȯ�� �ʿ����? b_Connected?)
	//-------------------------- �����˻� ���� �������� Ȯ��
	Result := False;	//TBD? (MotionEzi: ���� Home ���¿��� Ȯ��?)
end;

//------------------------------------------------------------------------------
function TMotionEzi.IsMotorMoving: Boolean;	//TBD?
begin
	//TBD? (����Ȯ�� �ʿ����? b_Connected?)
	//-------------------------- ���� ���� �޽� ����������� Ȯ��
	Result := False;	//TBD? (MotionEzi: ���� Motor ���� ����?)
end;

//******************************************************************************
// procedure/function: TMotionEzi: Set
//		- function TMotionEzi.SetActPos(dActPos: LONG): Integer;	//TBD?
//		- function TMotionEzi.SetCmdPos(dCmdPos: LONG): Integer;	//TBD?
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionEzi.SetActPos(dActPos: LONG): Integer;	//TBD?
var
	dReadPos : LONG;
begin
	//-------------------------- ������ ���¿��� �ܺ� ��ġ�� Ư�� ������ ����(position = Unit)
	//TBD? (EziMotor:������ ���¿��� ActPos�� Ư�������� Motion��⿡ Write)
	//-------------------------- ���� �ܺ� ��ġ�� ��ȸ�Ͽ� Ȯ��
	dReadPos := dActPos;
	if (dReadPos <> dActPos) then begin
		//Result := ERR_XXXXXXXX;	//TBD? (MotionEzi: AbnormalCase: ActPos: Write�� Read�� �� �ٸ� ���?)
	end;	
	Result := ERR_OK
end;

//------------------------------------------------------------------------------
function TMotionEzi.SetCmdPos(dCmdPos: LONG): Integer;	//TBD?
var
	dReadPos : LONG;
begin
	//-------------------------- ������ ���¿��� ���� ��ġ�� Ư�� ������ ����(position = Unit)
	//TBD? (EziMotor:������ ���¿��� CmdPos�� Ư�������� Motion��⿡ Write)
	//-------------------------- ���� ���� ��ġ�� ��ȸ�Ͽ� Ȯ��
	dReadPos := dCmdPos;	//TBD? (EziMotor:������ ActPos�� Read?)
	if (dReadPos <> dCmdPos) then begin
		//Result := ERR_XXXXXXXX;	//TBD? (MotionEzi: AbnormalCase: CmdPos: Write�� Read�� �� �ٸ� ���?)
	end;
	Result := ERR_OK
end;

{$ENDIF}
end.
