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
  //TBD? (� ���? � ���ǿ���?)
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

// <<���ն��̺귯�� �ʱ�ȭ �� ����>> ============================================================================
// 	- ���� ���̺귯���� �ʱ�ȭ �Ѵ�..
//		function AxtInitialize (hWnd : HWND; nIrqNo : SmallInt) : Boolean; stdcall;
// 	- ���� ���̺귯���� ��� �������� (�ʱ�ȭ�� �Ǿ�����)�� Ȯ���Ѵ�
//		function AxtIsInitialized () : Boolean; stdcall;
// 	- ���� ���̺귯���� ����� �����Ѵ�.
//		procedure AxtClose (); stdcall;
// <<���̽����� ���� �� �ݱ�>>
// 	- ������ ����(ISA, PCI, VME, CompactPCI)�� �ʱ�ȭ �Ǿ������� Ȯ���Ѵ�
//		function AxtIsInitializedBus (BusType : SmallInt) : SmallInt; stdcall;
// 	- ���ο� ���̽����带 ���ն��̺귯���� �߰��Ѵ�.
//		function AxtOpenDevice (BusType : SmallInt; dwBaseAddr : DWord) : SmallInt; stdcall;
// 	- ���ο� ���̽����带 �迭�� �̿��Ͽ� �Ѳ����� ���ն��̺귯���� �߰��Ѵ�.
//		function AxtOpenDeviceAll (BusType : SmallInt; nLen : SmallInt; dwBaseAddr : PDWord) : SmallInt; stdcall;
// 	- ���ο� ���̽����带 �ڵ����� ���ն��̺귯���� �߰��Ѵ�.
//		function AxtOpenDeviceAuto (BusType : SmallInt) : SmallInt; stdcall;
// 	- �߰��� ���̽����带 ���� �ݴ´�
//		procedure AxtCloseDeviceAll (); stdcall;
//
// << ���� �ʱ�ȭ �Լ��� >> ======================================================================================
//	- CAMC-FS�� ������ ���(SMC-1V02, SMC-2V02)�� �˻��Ͽ� �ʱ�ȭ�Ѵ�. CAMC-FS 2.0�̻� �����Ѵ�
//		function InitializeCAMCFS20 (reset : Boolean) : Boolean; stdcall;
// 					reset : 1(TRUE) = ��������(ī���� ��)�� �ʱ�ȭ�Ѵ�
//  				reset(TRUE)�϶� �ʱ� ������.
//  					1) ���ͷ�Ʈ ������� ����.
//  					2) �������� ��� ������� ����.
//  					3) �˶����� ��� ������� ����.
//  					4) ������ ����Ʈ ��� ��� ��.
//  					5) �������� ����Ʈ ��� ��� ��.
//  					6) �޽� ��� ��� : OneLowHighLow(Pulse : Active LOW, Direction : CW=High;CCW=LOW).
//  					7) �˻� ��ȣ : +������ ����Ʈ ��ȣ �ϰ� ����.
//  					8) �Է� ���ڴ� ���� : 2��, 4 ü��.
//  					9) �˶�, ��������, +-���� ���� ����Ʈ, +-������ ����Ʈ Active level : HIGH
// 				 	 10) ����/�ܺ� ī���� : 0.
//	- CAMC-FS20 ����� ����� ���������� Ȯ���Ѵ�
//		function CFS20IsInitialized () : Boolean; stdcall;
// 					���ϰ� :  1(TRUE) = CAMC-FS20 ����� ��� �����ϴ�
//	- CAMC-FS20�� ������ ����� ����� �����Ѵ�
//		procedure CFS20StopService (); stdcall;

// << ���� ���� ���� �Լ��� >> ===================================================================================
//	- ������ �ּҿ� ������ ���̽������� ��ȣ�� �����Ѵ�. ������ -1�� �����Ѵ�
//		function CFS20get_boardno (address : DWord) : SmallInt; stdcall;
//	- ���̽������� ������ �����Ѵ�
//		function CFS20get_numof_boards () : SmallInt; stdcall;
//	- ������ ���̽����忡 ������ ���� ������ �����Ѵ�
//		function CFS20get_numof_axes (nBoardNo : SmallInt) : SmallInt; stdcall;
//	- ���� ������ �����Ѵ�
//		function CFS20get_total_numof_axis () : SmallInt; stdcall;
//	- ������ ���̽������ȣ�� ����ȣ�� �ش��ϴ� ���ȣ�� �����Ѵ�
//		function CFS20get_axisno (nBoardNo : SmallInt; nModuleNo : SmallInt) : SmallInt; stdcall;
//	- ������ ���� ������ �����Ѵ�
//		function CFS20get_axis_info (nAxisNo : SmallInt; nBoardNo : PSmallInt; nModuleNo : PSmallInt; bModuleID : PByte; nAxisPos : PSmallInt) : Boolean; stdcall;
// 					nBoardNo : �ش� ���� ������ ���̽������� ��ȣ.
// 					nModuleNo: �ش� ���� ������ ����� ���̽� ��峻 ��� ��ġ(0~3)
// 					bModuleID: �ش� ���� ������ ����� ID : SMC-2V02(0x02)
// 					nAxisPos : �ش� ���� ������ ����� ù��°���� �ι�° ������ ����.(0 : ù��°, 1 : �ι�°)

// << ���� ���� �Լ��� >> ========================================================================================
//	- ���� ���� �ʱⰪ�� ������ ���Ͽ��� �о �����Ѵ�
//		function CFS20load_parameter (axis : SmallInt; nfilename : PChar) : Boolean; stdcall;
// 					Loading parameters.
// 						1) 1Pulse�� �̵��Ÿ�(Move Unit / Pulse)
// 						2) �ִ� �̵� �ӵ�, ����/���� �ӵ�
// 						3) ���ڴ� �Է¹��, �޽� ��¹��
// 						4) +������ ����Ʈ����, -������ ����Ʈ����, ������ ����Ʈ �������
//  					5) +�������� ����Ʈ����,-�������� ����Ʈ����, �������� ����Ʈ �������
//  					6) �˶�����, �˶� �������
//  					7) ��������(��ġ�����Ϸ� ��ȣ)����, �������� �������
//  					8) ������� �������
//  					9) ���ڴ� �Է¹��2 ������
// 					 10) ����/�ܺ� ī���� : 0.
//	- ���� ���� �ʱⰪ�� ������ ���Ͽ� �����Ѵ�.
//		function CFS20save_parameter (axis : SmallInt; nfilename : PChar) : Boolean; stdcall;
// 					Saving parameters.
// 						1) 1Pulse�� �̵��Ÿ�(Move Unit / Pulse)
// 						2) �ִ� �̵� �ӵ�, ����/���� �ӵ�
// 						3) ���ڴ� �Է¹��, �޽� ��¹��
// 						4) +������ ����Ʈ����, -������ ����Ʈ����, ������ ����Ʈ �������
//  					5) +�������� ����Ʈ����,-�������� ����Ʈ����, �������� ����Ʈ �������
//  					6) �˶�����, �˶� �������
//  					7) ��������(��ġ�����Ϸ� ��ȣ)����, �������� �������
//  					8) ������� �������
//  					9) ���ڴ� �Է¹��2 ������
//	- ��� ���� �ʱⰪ�� ������ ���Ͽ��� �о �����Ѵ�
//		function CFS20load_parameter_all (nfilename : PChar) : Boolean; stdcall;
//	- ��� ���� �ʱⰪ�� ������ ���Ͽ� �����Ѵ�
//		function CFS20save_parameter_all (nfilename : PChar) : Boolean; stdcall;
// << ���ͷ�Ʈ �Լ��� >> ================================================================================================
//		procedure CFS20SetWindowMessage (hWnd : HWND; wMsg : Word; proc : AXT_CAMCFS_INTERRUPT_PROC); stdcall;
//					���ͷ�Ʈ�� ����ϱ� ���ؼ��� Window message & procedure
//    				hWnd    : ������ �ڵ�, ������ �޼����� ������ ���. ������� ������ NULL�� �Է�.
//    				wMsg    : ������ �ڵ��� �޼���, ������� �ʰų� ����Ʈ���� ����Ϸ��� 0�� �Է�.
//    				proc    : ���ͷ�Ʈ �߻��� ȣ��� �Լ��� ������, ������� ������ NULL�� �Է�.
//		function CFS20read_interrupt_flag (axis : SmallInt) : DWord; stdcall;
// 					ReadInterruptFlag���� ������ ���� flag������ �о� ���� �Լ�(���ͷ�Ʈ service routine���� ���ͷ��� �߻� ������ �Ǻ��Ѵ�.)
// 					���ϰ�: ���ͷ�Ʈ�� �߻� �Ͽ����� �߻��ϴ� ���ͷ�Ʈ flag register(CAMC-FS20 �� INTFLAG ����.)

//------------------------------------------------------------------------------
function TMotionAxt.Connect: Integer;
var
	nErrCode 	: Integer;
begin
	m_sErrLibApi := '';
	nErrCode 		 := DefPocb.ERR_MOTION_CONNECT;
	//-------------------------- ���ն��̺귯�� �ʱ�ȭ
{$IFNDEF SIMULATOR_MOTION}
	if (not AxtIsInitialized) then begin 		// ���ն��̺귯���� ��� ��������(�ʱ�ȭ�� �Ǿ�����)�� Ȯ��
		if (not AxtInitialize(0{HWND}, 0{nIrqNo})) then begin	// ���� ���̺귯���� �ʱ�ȭ
			m_bAxtInitialized := False;
			m_sErrLibApi := 'AxtInitialize';
			Exit(nErrCode);
		end;
	end;
{$ENDIF}
	m_bAxtInitialized := True;
	//-------------------------- ���̽����� ���� (BUSTYPE_PCI:1)
{$IFNDEF SIMULATOR_MOTION}
	if (AxtIsInitializedBus(AxtLIBDef.BUSTYPE_PCI{BusType}) = 0) then begin			// ������ ����(PCI)�� �ʱ�ȭ �Ǿ������� Ȯ��
		if (AxtOpenDeviceAuto(AxtLIBDef.BUSTYPE_PCI{BusType}) = 0) then begin			// ���ο� ���̽����带 �ڵ����� ���ն��̺귯���� �߰�
			m_bAxtDeviceOpened := False;
			m_sErrLibApi := 'AxtOpenDeviceAuto('+IntToStr(AxtLIBDef.BUSTYPE_PCI)+')';
			Exit(nErrCode);
		end;
		AxtDisableInterrupt(0);
	end;
{$ENDIF}
	m_bAxtDeviceOpened := True;
	//-------------------------- CAMC-FS(SMC-2V02) Board �ʱ�ȭ
{$IFNDEF SIMULATOR_MOTION}
	// - CAMC-FS20 ����� ����� ���������� Ȯ��
	if (not CFS20IsInitialized) then begin
		// - CAMC-FS�� ������ ���(SMC-1V02, SMC-2V02)�� �˻��Ͽ� �ʱ�ȭ(CAMC-FS 2.0�̻� ����)
		//	reset : 1(TRUE) = ��������(ī���� ��)�� �ʱ�ȭ.
		//  	reset(TRUE)�϶� �ʱ� ������.
		//  	1) ���ͷ�Ʈ ������� ����.
		//  	2) �������� ��� ������� ����.
		//  	3) �˶����� ��� ������� ����.
		//  	4) ������ ����Ʈ ��� ��� ��.
		//  	5) �������� ����Ʈ ��� ��� ��.
		//  	6) �޽� ��� ��� : OneLowHighLow(Pulse : Active LOW, Direction : CW{High};CCW{LOW}).
		//  	7) �˻� ��ȣ : +������ ����Ʈ ��ȣ �ϰ� ����.
		//  	8) �Է� ���ڴ� ���� : 2��, 4 ü��.
		//  	9) �˶�, ��������, +-���� ���� ����Ʈ, +-������ ����Ʈ Active level : HIGH
		// 	 10) ����/�ܺ� ī���� : 0.  //TBD:MOTION:AXT? ���α׷� �籸���� Reset�ϸ鼭 Cmd/Act Pos�� 0���� �����???
		if (not InitializeCAMCFS20(True{reset})) then begin
			m_bAxtCFS20Initialized := False;
			m_sErrLibApi := 'InitializeCAMCFS20(True)';
			Exit(nErrCode);
		end;
	end;
{$ENDIF}
	m_bAxtCFS20Initialized := True;
	//-------------------------- Board �ʱ�ȭ ���� Load	//TBD?
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
	//-------------------------- AXIS ������ ���� ???
	m_bConnected := True;
	m_sDeviceVersion 	:= '';	// Clear
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
procedure TMotionAxt.CloseAxt;
begin
  //-------------------------- ���ն��̺귯�� ����� ����
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
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
  //-------------------------- ���� �˶� �Է� ��ȣ�� Active Level�� ����
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
	//-------------------------- �ش� ���� Alarm Clear ����� On (1: Alarm Clear) -> Off
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
	//-------------------------- �޽� ��� ����� ����
	// 	- method : ��� �޽� ��� ����(typedef : PULSE_OUTPUT)
	// 	- OneHighLowHigh   = 0x0, 1�޽� ���, PULSE(Active High), ������(DIR=Low)  / ������(DIR=High)
	// 	- OneHighHighLow   = 0x1, 1�޽� ���, PULSE(Active High), ������(DIR=High) / ������(DIR=Low)
	// 	- OneLowLowHigh    = 0x2, 1�޽� ���, PULSE(Active Low),  ������(DIR=Low)  / ������(DIR=High)
	// 	- OneLowHighLow    = 0x3, 1�޽� ���, PULSE(Active Low),  ������(DIR=High) / ������(DIR=Low)
	// 	- TwoCcwCwHigh     = 0x4, 2�޽� ���, PULSE(CCW:������),  DIR(CW:������),  Active High
	// 	- TwoCcwCwLow      = 0x5, 2�޽� ���, PULSE(CCW:������),  DIR(CW:������),  Active Low
	// 	- TwoCwCcwHigh     = 0x6, 2�޽� ���, PULSE(CW:������),   DIR(CCW:������), Active High
	// 	- TwoCwCcwLow      = 0x7, 2�޽� ���, PULSE(CW:������),   DIR(CCW:������), Active Low
{$IFNDEF SIMULATOR_MOTION}
	bRet := CFS20set_pulse_out_method(m_nAxisNo, 4);	//�޽� ��� ���
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
	//
  Common.GetMotionParam(m_nMotionID,MotionParam);
	if (not bIsOn) then begin		//------------------------------- Servo Off
		//------------------------ �ش� ���� �ش� bit�� ����� Off (Servo Off)
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

		//------------------------ �ְ� �ӵ� ���� Unit/Sec. ���� system�� �ְ� �ӵ��� ����

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
    //------------------------ �ش� ���� �ش� bit�� ����� On (Servo On)
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
		//------------------------ Signal Level ����
{$IFNDEF SIMULATOR_MOTION}
    CFS20set_pend_limit_level(m_nAxisNo, 0);    //POCB_A2CH-specfic (���� �� MotionControl GUI �� ����)
    CFS20set_nend_limit_level(m_nAxisNo, 0);    //POCB_A2CH-specfic (���� �� MotionControl GUI �� ����)
    CFS20set_pslow_limit_level(m_nAxisNo, 1);   //POCB_A2CH-specfic (���� �� MotionControl GUI �� ����)
    CFS20set_nslow_limit_level(m_nAxisNo, 1);   //POCB_A2CH-specfic (���� �� MotionControl GUI �� ����)
    CFS20set_inposition_level(m_nAxisNo, 1);    //POCB_A2CH-specfic (���� �� MotionControl GUI �� ����)
    CFS20set_alarm_level(m_nAxisNo, 0);         //POCB_A2CH-specfic (���� �� MotionControl GUI �� ����)
{$ENDIF}
		//------------------------ Unit/Pulse ����
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
  //-------------------------- Motion ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm ���� Ȯ��
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
	// ���� ���� Ȯ�� ---------------------
	// 	- ���� ���� ������ ����� ������ ��ٸ� �� �Լ��� �����.
	//		function CFS20wait_for_done (axis : SmallInt) : Word; stdcall;
	//
	// ���� ���� ���� �Լ��� --------------
	// 	- ���� ���� �������Ѵ�.
	//		function CFS20set_e_stop (axis : SmallInt) : Boolean; stdcall;
	// 	- ���� ���� ������ �������� �����Ѵ�.
	//		function CFS20set_stop (axis : SmallInt) : Boolean; stdcall;
	// 	- ���� ���� �Էµ� �������� �����Ѵ�.
	//		function CFS20set_stop_decel (axis : SmallInt; deceleration : Double) : Boolean; stdcall;
	// 	- ���� ���� �Էµ� ���� �ð����� �����Ѵ�.
	//		function CFS20set_stop_deceltime (axis : SmallInt; deceltime : Double) : Boolean; stdcall;
	//
{$IFNDEF SIMULATOR_MOTION}
  //-------------------------- �����˻��� ����
  CFS20abort_home_search(m_nAxisNo, 1);
  //-------------------------- ������ �Ǵ� ��������
	if (bIsEMS) then bRet := CFS20set_e_stop(m_nAxisNo)  // ������
	else 						 bRet := CFS20set_stop(m_nAxisNo);   // ��������
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm ���� Ȯ��  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- Start/Stop �ӵ� ����
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- �ְ� �ӵ� ���� Unit/Sec. ���� system�� �ְ� �ӵ��� ����
	bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dVelocityMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
	//-------------------------- ���� ���� �Ÿ� ����
	// 	- start_** : ���� �࿡�� ���� ������ �Լ��� return�Ѵ�. 'start_*' �� ������ �̵� �Ϸ��� return�Ѵ�(Blocking).
	// 	- *r*_*    : ���� �࿡�� �Էµ� �Ÿ���ŭ(�����ǥ)�� �̵��Ѵ�. '*r_*'�� ������ �Էµ� ��ġ(������ǥ)�� �̵��Ѵ�.
	// 	- *s*_*    : ������ �ӵ� ���������� 'S curve'�� �̿��Ѵ�. '*s_*'�� ���ٸ� ��ٸ��� �������� �̿��Ѵ�.
	// 	- *a*_*    : ������ �ӵ� �����ӵ��� ���Ī���� ����Ѵ�. ���ӷ� �Ǵ� ���� �ð���  ���ӷ� �Ǵ� ���� �ð��� ���� �Է¹޴´�.
	// 	- *_ex     : ������ �����ӵ��� ���� �Ǵ� ���� �ð����� �Է� �޴´�. '*_ex'�� ���ٸ� �����ӷ��� �Է� �޴´�.
	// 	- �Է� ����: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm ���� Ȯ��  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- Start/Stop �ӵ� ����
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- �ְ� �ӵ� ���� Unit/Sec. ���� system�� �ְ� �ӵ��� ����
	bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dVelocityMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- ���� ���� �Ÿ� ����
	// 	- start_** : ���� �࿡�� ���� ������ �Լ��� return�Ѵ�. 'start_*' �� ������ �̵� �Ϸ��� return�Ѵ�(Blocking).
	// 	- *r*_*    : ���� �࿡�� �Էµ� �Ÿ���ŭ(�����ǥ)�� �̵��Ѵ�. '*r_*'�� ������ �Էµ� ��ġ(������ǥ)�� �̵��Ѵ�.
	// 	- *s*_*    : ������ �ӵ� ���������� 'S curve'�� �̿��Ѵ�. '*s_*'�� ���ٸ� ��ٸ��� �������� �̿��Ѵ�.
	// 	- *a*_*    : ������ �ӵ� �����ӵ��� ���Ī���� ����Ѵ�. ���ӷ� �Ǵ� ���� �ð���  ���ӷ� �Ǵ� ���� �ð��� ���� �Է¹޴´�.
	// 	- *_ex     : ������ �����ӵ��� ���� �Ǵ� ���� �ð����� �Է� �޴´�. '*_ex'�� ���ٸ� �����ӷ��� �Է� �޴´�.
	// 	- �Է� ����: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
 //-------------------------- Motion Alarm ���� Ȯ��  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
 {$IFNDEF SIMULATOR_MOTION}
	//-------------------------- Start/Stop �ӵ� ����
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- �ְ� �ӵ� ���� Unit/Sec. ���� system�� �ְ� �ӵ��� ����
	bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dJogVelocityMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
	//-------------------------- ���� ���� �Ÿ� ����
	// 	- start_** : ���� �࿡�� ���� ������ �Լ��� return�Ѵ�. 'start_*' �� ������ �̵� �Ϸ��� return�Ѵ�(Blocking).
	// 	- *r*_*    : ���� �࿡�� �Էµ� �Ÿ���ŭ(�����ǥ)�� �̵��Ѵ�. '*r_*'�� ������ �Էµ� ��ġ(������ǥ)�� �̵��Ѵ�.
	// 	- *s*_*    : ������ �ӵ� ���������� 'S curve'�� �̿��Ѵ�. '*s_*'�� ���ٸ� ��ٸ��� �������� �̿��Ѵ�.
	// 	- *a*_*    : ������ �ӵ� �����ӵ��� ���Ī���� ����Ѵ�. ���ӷ� �Ǵ� ���� �ð���  ���ӷ� �Ǵ� ���� �ð��� ���� �Է¹޴´�.
	// 	- *_ex     : ������ �����ӵ��� ���� �Ǵ� ���� �ð����� �Է� �޴´�. '*_ex'�� ���ٸ� �����ӷ��� �Է� �޴´�.
	// 	- �Է� ����: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
 //-------------------------- Motion Alarm ���� Ȯ��  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
	//-------------------------- Motor Reset
//TBD? if (MotorReset(m_nBdNo) <> DefPocb.ERR_OK) then begin
//TBD? end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- Start/Stop �ӵ� ����
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- �ְ� �ӵ� ���� Unit/Sec. ���� system�� �ְ� �ӵ��� ����
	bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dJogVelocityMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
	//-------------------------- ���� ���� �Ÿ� ����
	// 	- start_** : ���� �࿡�� ���� ������ �Լ��� return�Ѵ�. 'start_*' �� ������ �̵� �Ϸ��� return�Ѵ�(Blocking).
	// 	- *r*_*    : ���� �࿡�� �Էµ� �Ÿ���ŭ(�����ǥ)�� �̵��Ѵ�. '*r_*'�� ������ �Էµ� ��ġ(������ǥ)�� �̵��Ѵ�.
	// 	- *s*_*    : ������ �ӵ� ���������� 'S curve'�� �̿��Ѵ�. '*s_*'�� ���ٸ� ��ٸ��� �������� �̿��Ѵ�.
	// 	- *a*_*    : ������ �ӵ� �����ӵ��� ���Ī���� ����Ѵ�. ���ӷ� �Ǵ� ���� �ð���  ���ӷ� �Ǵ� ���� �ð��� ���� �Է¹޴´�.
	// 	- *_ex     : ������ �����ӵ��� ���� �Ǵ� ���� �ð����� �Է� �޴´�. '*_ex'�� ���ٸ� �����ӷ��� �Է� �޴´�.
	// 	- �Է� ����: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)
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
// �����˻� ====================================================================
//	���̺귯�� �󿡼� Thread�� ����Ͽ� �˻��Ѵ�. ���� : ������ Ĩ���� StartStop Speed�� ���� �� �ִ�.
//	-	�����˻��� �����Ѵ�.
//		function CFS20abort_home_search (axis : SmallInt; bStop : Byte) : Boolean; stdcall;
// 				bStop: 0(��������), 1(������)
//	-	�����˻��� �����Ѵ�. �����ϱ� ���� �����˻��� �ʿ��� ������ �ʿ��ϴ�.
//		function CFS20home_search (axis : SmallInt) : Boolean; stdcall;
//	-	�Է� ����� ���ÿ� �����˻��� �ǽ��Ѵ�.
//		function CFS20home_search_all (number : SmallInt; axes : PSmallInt) : Boolean; stdcall;
//	-	�����˻� ���� �������� Ȯ���Ѵ�.
//		function CFS20get_home_done (axis : SmallInt) : Boolean; stdcall;
// 				��ȯ��: 0(�����˻� ������), 1(�����˻� ����)
//	-	�ش� ����� �����˻� ���� �������� Ȯ���Ѵ�.
//		function CFS20get_home_done_all (number : SmallInt; axes : PSmallInt) : Boolean; stdcall;
//	-	���� ���� ���� �˻� ������ ���� ���¸� Ȯ���Ѵ�.
//		function CFS20get_home_end_status (axis : SmallInt) : Byte; stdcall;
// 				��ȯ��: 0(�����˻� ����), 1(�����˻� ����)
//	-	���� ����� ���� �˻� ������ ���� ���¸� Ȯ���Ѵ�.
//		function CFS20get_home_end_status_all (number : SmallInt; axes : PSmallInt; endstatus : PByte) : Boolean; stdcall;
//	-	���� �˻��� �� ���ܸ��� method�� ����/Ȯ���Ѵ�.
//		function CFS20set_home_method (axis : SmallInt; nstep : SmallInt; method : PByte) : Boolean; stdcall;
//		function CFS20get_home_method (axis : SmallInt; nstep : SmallInt; method : PByte) : Boolean; stdcall;
// 				Method�� ���� ����
//    				0 Bit ���� ��뿩�� ���� (0 : ������� ����, 1: �����)
//    				1 Bit ������ ��� ���� (0 : ������, 1 : ���� �ð�)
//    				2 Bit ������� ���� (0 : ���� ����, 1 : �� ����)
//    				3 Bit �˻����� ���� (0 : cww(-), 1 : cw(+))
// 				 7654 Bit detect signal ����(typedef : DETECT_DESTINATION_SIGNAL)
//	-	���� �˻��� �� ���ܸ��� offset�� ����/Ȯ���Ѵ�.
//		function CFS20set_home_offset (axis : SmallInt; nstep : SmallInt; offset : PDouble) : Boolean; stdcall;
//		function CFS20get_home_offset (axis : SmallInt; nstep : SmallInt; offset : PDouble) : Boolean; stdcall;
//	-	�� ���� ���� �˻� �ӵ��� ����/Ȯ���Ѵ�.
//		function CFS20set_home_velocity (axis : SmallInt; nstep : SmallInt; velocity : PDouble) : Boolean; stdcall;
//		function CFS20get_home_velocity (axis : SmallInt; nstep : SmallInt; velocity : PDouble) : Boolean; stdcall;
//	-	���� ���� ���� �˻� �� �� ���ܺ� �������� ����/Ȯ���Ѵ�.
//		function CFS20set_home_acceleration (axis : SmallInt; nstep : SmallInt; acceleration : PDouble) : Boolean; stdcall;
//		function CFS20get_home_acceleration (axis : SmallInt; nstep : SmallInt; acceleration : PDouble) : Boolean; stdcall;
//	-	���� ���� ���� �˻� �� �� ���ܺ� ���� �ð��� ����/Ȯ���Ѵ�.
//		function CFS20set_home_acceltime (axis : SmallInt; nstep : SmallInt; acceltime : PDouble) : Boolean; stdcall;
//		function CFS20get_home_acceltime (axis : SmallInt; nstep : SmallInt; acceltime : PDouble) : Boolean; stdcall;
//	-	���� �࿡ ���� �˻����� ���ڴ� 'Z'�� ���� ��� �� ���� �Ѱ谪�� ����/Ȯ���Ѵ�.(Pulse) - ������ ����� �˻� ����
//		function CFS20set_zphase_search_range (axis : SmallInt; pulses : SmallInt) : Boolean; stdcall;
//		function CFS20get_zphase_search_range (axis : SmallInt) : SmallInt; stdcall;
//	-	���� ��ġ�� ����(0 Position)���� �����Ѵ�. - �������̸� ���õ�.
//		function CFS20home_zero (axis : SmallInt) : Boolean; stdcall;
//	-	������ ��� ���� ���� ��ġ�� ����(0 Position)���� �����Ѵ�. - �������� ���� ���õ�
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm ���� Ȯ��  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
  if IsMotionAlarmOn then begin
		Exit(DefPocb.ERR_MOTION_ALARM_ON);
  end;
	//-------------------------- ���� �˻� ��, ���� Ȯ�� (Home ����, Moving)
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
  //-------------------------- Unit/Pulse ����
  CFS20set_moveunit_perpulse(m_nAxisNo, MotionParam.dUnitPerPulse{unitperpulse});
  sTemp := FloatToStr(CFS20get_moveunit_perpulse(m_nAxisNo));
	//-------------------------- Start/Stop �ӵ� ����
  CFS20set_startstop_speed(m_nAxisNo,MotionParam.dStartStopSpeed);
	//-------------------------- �ְ� �ӵ� ���� Unit/Sec. ���� system�� �ְ� �ӵ��� ����
	bRet := CFS20set_max_speed(m_nAxisNo, MotionParam.dVelocityMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
  //Common.MLog(SYS_LOG,'GetUnitPerPulse('+sTemp+')',DefPocb.DEBUG_LEVEL_INFO);
  Sleep(100);

  //------------------------ -Limit���� �̵�
  bRet := CFS20start_move(m_nAxisNo, MotionParam.dSoftLimitMinus-10000{TBD:MOTION:toLIMIT?}, MotionParam.dJogVelocity, MotionParam.dJogAccel);
  Sleep(100);  //TBD? 2018-12-04
  while (bRet and CFS20in_motion(m_nAxisNo)) do begin
    Sleep(100);
  end;

	//-------------------------- ���� �˻��� ���� �� ����
{$IFDEF ORG_SAVE}
	nHomeStep := 4;
	//-------------------------- ���� �˻��� �� ���ܸ��� method�� �����Ѵ�.
	if (nSearchDir = DefMotion.AxtMC_SEARCH_HOME_DIR_CCW) then begin
		//----- Step.0: (+)�������� Ȩ ������ ��¿��� ��ȣ�� �˻���, ������ ��������, ���������� �����Ǿ� ���� �� Step0�� ������� ����
		if (not CFS20input_bit_on(m_nAxisNo, DefMotion.AxtMC_SIG_IN_HOME)) then		// ���������� �����Ǿ� �������� ��
			methods[0] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_IN0_UPEDGE
		else 			// ���������� �����Ǿ� ���� ��
			methods[0] := $00;
		//----- Step.1: (-)�������� Ȩ ������ �ϰ����� ��ȣ�� �˻���, ������ ������
		methods[1] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN0_DNEDGE or DefMotion.AxtMC_HOME_METHOD_DIR_CW;
		//----- Step.2: (+)�������� Ȩ ������ ��¿��� ��ȣ�� �˻���, ������ ������
		methods[2] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN0_UPEDGE;
	 	//----- Step.3: (-)�������� Z�� ������ �ϰ����� ��ȣ�� �˻���, ������ ������
		methods[3] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN1_DNEDGE or DefMotion.AxtMC_HOME_METHOD_DIR_CW;
	end
	else begin
		//----- Step.0: (+)�������� Ȩ ������ ��¿��� ��ȣ�� �˻���, ������ ��������, ���������� �����Ǿ� ���� �� Step0�� ������� ����
		if (not CFS20input_bit_on(m_nAxisNo, DefMotion.AxtMC_SIG_IN_HOME)) then		// ���������� �����Ǿ� �������� ��
			methods[0] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_IN0_UPEDGE or DefMotion.AxtMC_HOME_METHOD_DIR_CW
		else 			// ���������� �����Ǿ� ���� ��
			methods[0] := $00;
		//----- Step.1: (+)�������� Ȩ ������ �ϰ����� ��ȣ�� �˻���, ������ ������
		methods[1] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN0_DNEDGE;
		//----- Step.2: (-)�������� Ȩ ������ ��¿��� ��ȣ�� �˻���, ������ ������
		methods[2] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN0_UPEDGE or DefMotion.AxtMC_HOME_METHOD_DIR_CW;
	 	//----- Step.3: (+)�������� Z�� ������ �ϰ����� ��ȣ�� �˻���, ������ ������
		methods[3] := DefMotion.AxtMC_HOME_METHOD_USE_STEP or DefMotion.AxtMC_HOME_METHOD_STOP_EMG or DefMotion.AxtMC_HOME_METHOD_IN1_DNEDGE;
	end;
{$ELSE}
  nHomeStep := 3; //DefMotion.AxtMC_SEARCH_HOME_STEP_DEFAULT;	//TBD? (4 -> 3 ����� MUTING Lamp On ��)
//nHomeStep := 4; //DefMotion.AxtMC_SEARCH_HOME_STEP_DEFAULT;	//TBD? (4 -> 3 ����� MUTING Lamp On ��)
	//-------------------------- ���� �˻��� �� ���ܸ��� method�� �����Ѵ�.
  //2018-11-27 if (m_nMotionID = DefMotion.MOTIONID_AxtMC_STAGE2_Y) then nSearchDir := AxtMC_SEARCH_HOME_DIR_CW;  //TBD? (2018-11-15 CH2-Y���� �ݴ�� ������)
  nSearchDir := DefMotion.AxMC_SEARCH_HOME_DIR_CCW;
	if (nSearchDir = DefMotion.AxMC_SEARCH_HOME_DIR_CCW) then begin
		//----- Step.0: (+)�������� Ȩ ������ ��¿��� ��ȣ�� �˻���, ������ ��������, ���������� �����Ǿ� ���� �� Step0�� ������� ����
		if (not {CAxtCAMCFS20}CFS20input_bit_on(m_nAxisNo{axis}, DefMotion.AxMC_SIG_IN_HOME{bitNo})) then		// ���������� �����Ǿ� �������� ��
			methods[0] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_IN0_UPEDGE
		else 			// ���������� �����Ǿ� ���� ��
			methods[0] := $00;
		//----- Step.1: (-)�������� Ȩ ������ �ϰ����� ��ȣ�� �˻���, ������ ������
		methods[1] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_DNEDGE or DefMotion.AxMC_HOME_METHOD_DIR_CW;
		//----- Step.2: (+)�������� Ȩ ������ ��¿��� ��ȣ�� �˻���, ������ ������
		methods[2] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_UPEDGE;
	 	//----- Step.3: (-)�������� Z�� ������ �ϰ����� ��ȣ�� �˻���, ������ ������
    methods[3] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_DNEDGE or DefMotion.AxMC_HOME_METHOD_DIR_CW;
  //methods[3] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN1_DNEDGE or DefMotion.AxMC_HOME_METHOD_DIR_CW;
	end
	else begin
		//----- Step.0: (+)�������� Ȩ ������ ��¿��� ��ȣ�� �˻���, ������ ��������, ���������� �����Ǿ� ���� �� Step0�� ������� ����
		if (not {CAxtCAMCFS20}CFS20input_bit_on(m_nAxisNo{axis}, DefMotion.AxMC_SIG_IN_HOME{bitNo})) then		// ���������� �����Ǿ� �������� ��
			methods[0] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_IN0_DNEDGE or DefMotion.AxMC_HOME_METHOD_DIR_CW
		else 			// ���������� �����Ǿ� ���� ��
			methods[0] := $00;
		//----- Step.1: (+)�������� Ȩ ������ �ϰ����� ��ȣ�� �˻���, ������ ������
		methods[1] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_UPEDGE;
		//----- Step.2: (-)�������� Ȩ ������ ��¿��� ��ȣ�� �˻���, ������ ������
		methods[2] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_DNEDGE or DefMotion.AxMC_HOME_METHOD_DIR_CW;
	 	//----- Step.3: (+)�������� Z�� ������ �ϰ����� ��ȣ�� �˻���, ������ ������
    methods[3] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN0_UPEDGE;
	//methods[3] := DefMotion.AxMC_HOME_METHOD_USE_STEP or DefMotion.AxMC_HOME_METHOD_STOP_EMG or DefMotion.AxMC_HOME_METHOD_IN1_DNEDGE;
	end;
{$ENDIF}
	bRet := CFS20set_home_method(m_nAxisNo, nHomeStep, @methods); // �ະ�� Ȩ�˻� ����� �����Ѵ�..
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_home_method';
		Exit(nErrCode);
	end;
  Sleep(50);
	//-------------------------- ���� �˻��� ���� �� Step�� �ӵ� ����, �ⱸ�� �´� �ӵ��� ����
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
	//-------------------------- ���� ���� �˻��� �ְ�ӵ� ����
	bRet := CFS20set_max_speed(m_nAxisNo, dHomeVelMax);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_max_speed';
		Exit(nErrCode);
	end;
  Sleep(50);
	//-------------------------- ���� ���� �˻� �� �� ���ܺ� �ӵ� ����
	bRet := CFS20set_home_velocity(m_nAxisNo, nHomeStep, @velocities);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_home_velocity';
		Exit(nErrCode);
	end;
    Sleep(50);
	//-------------------------- ���� ���� �˻� �� �� ���ܺ� �������� ����
	bRet := CFS20set_home_acceleration(m_nAxisNo, nHomeStep, @accelerations);
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20set_home_acceleration';
		Exit(nErrCode);
	end;
    Sleep(50);
	//-------------------------- �����˻��� �����Ѵ�. �����ϱ� ���� �����˻��� �ʿ��� ������ �ʿ�
	// 	- �����˻� (���̺귯���󿡼� Thread�� ����Ͽ� �˻�. ����: ������ Ĩ���� StartStop Speed�� ���� �� �ִ�)
	bRet := CFS20home_search(m_nAxisNo{axis});
	if (not bRet) then begin
		m_sErrLibApi := 'CFS20home_search';
		Exit(nErrCode);
	end;
  sleep(50);
  while (CFS20in_motion(m_nAxisNo)) do begin
    Sleep(10);  //sleep�� ª��
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- ������ ���¿��� �ܺ� ��ġ�� Ư�� ������ ����(position = Unit)
	CFS20set_actual_position(m_nAxisNo, dActPos{position});
	//-------------------------- ���� �ܺ� ��ġ�� ��ȸ�Ͽ� Ȯ��
  dReadPos := CFS20get_actual_position(m_nAxisNo);
{$ELSE}
  dReadPos := dActPos;
{$ENDIF}
  //dReadPos := Round(nDoubleVal);
	if Abs(dReadPos - dActPos) > 1 then begin
		//Result := ERR_XXXXXXXX;	//TBD? (MotorAxt: AbnormalCase: ActPos: Write�� Read�� �� �ٸ� ���?)
	end;
	Result := DefPocb.ERR_OK
end;

//------------------------------------------------------------------------------
function TMotionAxt.SetCmdPos(dCmdPos: Double): Integer;
var
	dReadPos   : Double;
begin
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
{$IFNDEF SIMULATOR_MOTION}
	//-------------------------- ������ ���¿��� ���� ��ġ�� Ư�� ������ ����(position = Unit)
	CFS20set_command_position(m_nAxisNo, dCmdPos{position});
  //CodeSite.Send('SetCmdPos:'+FloatToStr(dCmdPos));
	//-------------------------- ���� ���� ��ġ�� ��ȸ�Ͽ� Ȯ��
  dReadPos := CFS20get_command_position(m_nAxisNo);
{$ELSE}
  dReadPos := dCmdPos;
{$ENDIF}
  //CodeSite.Send('GetCmdPos:'+FloatToStr(dReadPos));
  //dReadPos   := Round(nDoubleVal);
	if Abs(dReadPos - dCmdPos) > 1 then begin
		//Result := ERR_XXXXXXXX;	//TBD? (MotorAxt: AbnormalCase: CmdPos: Write�� Read�� �� �ٸ� ���?)
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
	//-------------------------- ������ ���¿��� �ܺ� ��ġ�� Ư�� ������ Ȯ��(position = Unit)
  dActPos := CFS20get_actual_position(m_nAxisNo);
	Result  := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxt.GetCmdPos(var dCmdPos: Double): Integer;
begin
	m_sErrLibApi 	:= '';
//nErrCode 			:= DefPocb.ERR_MOTION_GET_CMD_POS;
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
	//-------------------------- ������ ���¿��� ���� ��ġ�� Ư�� ������ Ȯ��(position = Unit)
  dCmdPos := CFS20get_command_position(m_nAxisNo);
	Result  := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
function TMotionAxt.IsMotionHome: Boolean;
begin
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(False);  //TBD? ERR_MOTION_NOT_CONNECTED?
  end;
	//TBD? (����Ȯ�� �ʿ����? b_Connected?)
	//-------------------------- �����˻� ���� �������� Ȯ��
	// 	- ��ȯ��: 0: �����˻� ������, 1: �����˻� ����
	Result := CFS20get_home_done(m_nAxisNo);
end;

//------------------------------------------------------------------------------
function TMotionAxt.IsMotionMoving: Boolean;
begin
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(False);  //TBD? ERR_MOTION_NOT_CONNECTED?
  end;
	//TBD? (����Ȯ�� �ʿ����? b_Connected?)
	//-------------------------- ���� ���� �޽� ����������� Ȯ��
	Result := CFS20in_motion(m_nAxisNo);
end;

//------------------------------------------------------------------------------
function TMotionAxt.IsMotionAlarmOn: Boolean;
var
  MechSignal : WORD;
begin
  //-------------------------- Motor ���� ���� ���� Ȯ��
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
  //-------------------------- Motor ���� ���� ���� Ȯ��
  if (not m_bConnected) then begin
		Exit(False);
  end;
{$IFDEF SIMULATOR_MOTION}
  Common.GetMotionParam(m_nMotionID,MotionParam);
{$ENDIF}

  //----- ���� ���� �ʱ�ȭ
  // Unit/Pulse ����
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.UnitPerPulse := CFS20get_moveunit_perpulse(m_nAxisNo);
                              //    Unit/Pulse : 1 pulse�� ���� system�� �̵��Ÿ� (Unit�� ������ ����ڰ� ���Ƿ� ����)
                              // Ex) Ball screw pitch : 10mm, ���� 1ȸ���� �޽��� : 10000
                              //      ==> Unit�� mm�� ������ ��� : Unit/Pulse = 10/10000.
                              //      ���� unitperpulse�� 0.001�� �Է��ϸ� ��� ��������� mm�� ������.
                              // Ex) Linear motor�� ���ش��� 1 pulse�� 2 uM.
                              //      ==> Unit�� mm�� ������ ��� : Unit/Pulse = 0.002/1
{$ELSE}
  MotionStatus.UnitPerPulse := MotionParam.dUnitPerPulse;  //TBD:SIM:MOTION?
{$ENDIF}
  // ���� �ӵ� ���� (Unit/Sec)
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.StartStopSpeed := CFS20get_startstop_speed(m_nAxisNo);
{$ELSE}
  MotionStatus.StartStopSpeed := MotionParam.dStartStopSpeed;  //TBD:SIM:MOTION?
{$ENDIF}
  // �ְ� �ӵ� ���� (Unit/Sec, ���� system�� �ְ� �ӵ�)
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.MaxSpeed := CFS20get_max_speed(m_nAxisNo);
{$ELSE}
  MotionStatus.MaxSpeed := MotionParam.dStartStopSpeedMax;  //TBD:SIM:MOTION?
{$ENDIF}
  //----- ���� ���� Ȯ��
  // ���� ���� �޽� ���������
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.IsInMotion := CFS20in_motion(m_nAxisNo);
{$ELSE}
  MotionStatus.IsInMotion := False;  //TBD:SIM:MOTION?
{$ENDIF}
  // ���� ���� �޽� ����� ����ƴ���
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.IsMotionDone := CFS20motion_done(m_nAxisNo);
{$ELSE}
  MotionStatus.IsMotionDone := True;  //TBD:SIM:MOTION?
{$ENDIF}
  // ���� ���� EndStatus �������͸� Ȯ��
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.EndStatus    := CFS20get_end_status(m_nAxisNo); // Word
                              //  - End Status (16 bit) Bit�� �ǹ�
                              //      14bit : Limit(PELM, NELM, PSLM, NSLM, Soft)�� ���� ����
                              //      13bit : Limit ���� ������ ���� ����
                              //      12bit : Sensor positioning drive����
                              //      11bit : Preset pulse drive�� ���� ����(������ ��ġ/�Ÿ���ŭ �����̴� �Լ���)
                              //      10bit : ��ȣ ���⿡ ���� ����(Signal Search-1/2 drive����)
                              //      9 bit : ���� ���⿡ ���� ����
                              //      8 bit : Ż�� ������ ���� ����
                              //      7 bit : ����Ÿ ���� ������ ���� ����
                              //      6 bit : ALARM ��ȣ �Է¿� ���� ����
                              //      5 bit : ������ ��ɿ� ���� ����
                              //      4 bit : �������� ��ɿ� ���� ����
                              //      3 bit : ������ ��ȣ �Է¿� ���� ���� (EMG Button)
                              //      2 bit : �������� ��ȣ �Է¿� ���� ����
                              //      1 bit : Limit(PELM, NELM, Soft) �������� ���� ����
                              //      0 bit : Limit(PSLM, NSLM, Soft) ���������� ���� ����
{$ELSE}
  MotionStatus.EndStatus := $00;  //TBD:SIM:MOTION?
{$ENDIF}
  // ���� ���� Mechanical ��������
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.MechSignal   := CFS20get_mechanical_signal(m_nAxisNo);
                              //  - Mechanical Signal Bit�� �ǹ�
                              //      12bit : ESTOP ��ȣ �Է� Level
                              //      11bit : SSTOP ��ȣ �Է� Level
                              //      10bit : MARK ��ȣ �Է� Level
                              //      9 bit : EXPP(MPG) ��ȣ �Է� Level
                              //      8 bit : EXMP(MPG) ��ȣ �Է� Level
                              //      7 bit : Encoder Up��ȣ �Է� Level(A�� ��ȣ)
                              //      6 bit : Encoder Down��ȣ �Է� Level(B�� ��ȣ)
                              //      5 bit : INPOSITION ��ȣ Active ����
                              //      4 bit : ALARM ��ȣ Active ����
                              //      3 bit : -Limit �������� ��ȣ Active ���� (Ver3.0���� ����������)
                              //      2 bit : +Limit �������� ��ȣ Active ���� (Ver3.0���� ����������)
                              //      1 bit : -Limit ������ ��ȣ Active ����
                              //      0 bit : +Limit ������ ��ȣ Active ��
{$ELSE}
  MotionStatus.MechSignal := (1 shl 5);   //TBD:SIM:MOTION?
{$ENDIF}
  //----- ��ġ Ȯ��
  // �ܺ� ��ġ �� (position: Unit)
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.ActualPos  := CFS20get_actual_position(m_nAxisNo);
{$ELSE}
  MotionStatus.ActualPos := $00;   //TBD:SIM:MOTION?
{$ENDIF}
  // ���� ��ġ �� (position: Unit)
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
  //----- ���� ����̹�
  // ���� Enable(On) / Disable(Off)
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.ServoEnable := CFS20get_servo_enable(m_nAxisNo);
{$ELSE}
  MotionStatus.ServoEnable := 1; //TBD:SIM:MOTION?
{$ENDIF}
  // ���� ��ġ�����Ϸ�(inposition)�Է� ��ȣ�� �������
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.UseInPosSig := CFS20get_inposition_enable (m_nAxisNo);
{$ELSE}
  MotionStatus.UseInPosSig := 0;  //TBD:SIM:MOTION?
{$ENDIF}
  // ���� �˶� �Է½�ȣ ����� �������
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.UseAlarmSig := CFS20get_alarm_enable(m_nAxisNo);
{$ELSE}
  MotionStatus.UseAlarmSig := 0; //TBD:SIM:MOTION?
{$ENDIF}
  //----- ���� �����
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.UnivInSignal  := CFS20get_input (m_nAxisNo);
                              //      0 bit : ���� �Է� 0(ORiginal Sensor)
                              //      1 bit : ���� �Է� 1(Z phase)
                              //      2 bit : ���� �Է� 2
                              //      3 bit : ���� �Է� 3
                              //      4 bit(PLD) : ���� �Է� 5
                              //      5 bit(PLD) : ���� �Է� 6
                              //        On ==> ���ڴ� N24V, 'Off' ==> ���ڴ� Open(float).
{$ELSE}
  MotionStatus.UnivInSignal := {(1 shl 0) or} (1 shl 1) or (1 shl 2);      //TBD:SIM:MOTION?
{$ENDIF}
{$IFNDEF SIMULATOR_MOTION}
  MotionStatus.UnivOutSignal := CFS20get_output(m_nAxisNo);  // Byte
                              //      0 bit : ���� ��� 0(Servo-On)
                              //      1 bit : ���� ��� 1(ALARM Clear)
                              //      2 bit : ���� ��� 2
                              //      3 bit : ���� ��� 3
                              //      4 bit(PLD) : ���� ��� 4
                              //      5 bit(PLD) : ���� ��� 5
{$ELSE}
  MotionStatus.UnivOutSignal := (1 shl 0);      //TBD:SIM:MOTION?;
{$ENDIF}
  //--------------------------
  Result := True;
end;

end.

