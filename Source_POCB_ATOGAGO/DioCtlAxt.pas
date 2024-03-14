unit DioCtlAxt;

interface
{$I Common.inc}

uses
  Winapi.Windows, System.SysUtils,  System.Classes, Vcl.ExtCtrls,
  // 3rd-party Classes
	AxtLIBDef, AxtLIB, AxtDio,
  //
  DefPocb, DefDio, DefMotion, MotionCtl, CommonClass;

//const

type

  TDioAxt = class(TObject)
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
      m_nModuleNoDioIn  : Integer;
      m_nModuleNoDioOut : Integer;
      //
      m_bAxtInitialized : Boolean;
      m_bAxtDeviceOpened  : Boolean;
      m_bAxtDioInitialized  : Boolean;
      m_bAxtConnected : Boolean;
      m_sErrLibApi      : string;
      //
      m_bConnected      : Boolean;
    	m_dwDioInNew	: array[0..DefDio.DIO_MODULE_MAX] of DWORD; //NOT-USED
    	m_dwDioInOld 	: array[0..DefDio.DIO_MODULE_MAX] of DWORD; //NOT-USED
    	m_dwDioOutNew	: array[0..DefDio.DIO_MODULE_MAX] of DWORD; //NOT-USED
    	m_dwDioOutOld : array[0..DefDio.DIO_MODULE_MAX] of DWORD; //NOT-USED

			//---------------------- procedure/function: TDioAxt: Create/Destroy/Init
			constructor Create(hMain: THandle); virtual;
      destructor Destroy; override;
			//---------------------- procedure/function: TDioAxt: Connect/Close/Init
			function Connect: Integer;
			procedure CloseAxt;
			procedure InitDioSig;
			//---------------------- procedure/function: TDioAxt: Read/Write
      function ReadDioIn32(nDioInModuleOffset: Integer): DWORD;
      function ReadDioOut32(nDioOutModuleOffset: Integer): DWORD;
      function WriteDioOutBit(nDioOutModuleOffset : Integer; nSig32Bit: Integer; bIsOn: Boolean): Boolean;
      function WriteDioOut32(nDioOutModuleOffset: Integer; dwSig32: DWORD): Boolean;

  end;

implementation

//##############################################################################
//
{ TDioAxt }
//
//##############################################################################

//******************************************************************************
// procedure/function: TDioAxt: Create/Destroy/Init
//		- constructor TDioAxt.Create(hMain: THandle; nMotionID: Integer; nCh: Integer; nAxisType: Integer; nMotorNo: Integer)
//		- destructor TDioAxt.Destroy
//******************************************************************************

//------------------------------------------------------------------------------
constructor TDioAxt.Create(hMain: THandle);
begin
  m_hMain := hMain;
  //--------------------------
  m_nModuleNoDioIn  := 0; //A2CH
  m_nModuleNoDioOut := 0; //A2CH
end;

//------------------------------------------------------------------------------
destructor TDioAxt.Destroy;
begin
  //TBD? (� ���? � ���ǿ���?)
  //
  m_bConnected := False;
  inherited;
end;

//******************************************************************************
// procedure/function: TDioAxt: Connect/Close/Init
//		- function TDioAxt.Connect: Integer;
//		- procedure TDioAxt.CloseAxt;
//		- procedure TDioAxt.InitDioSig;
//******************************************************************************

//------------------------------------------------------------------------------
function TDioAxt.Connect: Integer;
var
//bRet 			: Boolean;
	nErrCode 	: Integer;
begin
	m_sErrLibApi := '';
	nErrCode 		 := DefPocb.ERR_DIO_CONNECT;
	//-------------------------- ���ն��̺귯�� �ʱ�ȭ
{$IFDEF SIMULATOR_DIO}
  //TBD:SIMULATOR:DIO?
{$ELSE}
	if (not {CAxtLib}AxtIsInitialized) then begin 		// ���ն��̺귯���� ��� ��������(�ʱ�ȭ�� �Ǿ�����)�� Ȯ��
		if (not {CAxtLib}AxtInitialize(0{HWND}, 0{nIrqNo})) then begin	// ���� ���̺귯���� �ʱ�ȭ
			m_bAxtInitialized := False;
			m_sErrLibApi := 'AxtInitialize';
			Exit(nErrCode);
		end;
	end;
{$ENDIF}
	m_bAxtInitialized := True;
	//-------------------------- ���̽����� ���� (BUSTYPE_PCI:1)
{$IFDEF SIMULATOR_DIO}
  //TBD:SIMULATOR:DIO?
{$ELSE}
	if ({CAxtLib}AxtIsInitializedBus(AxtLIBDef.BUSTYPE_PCI{BusType}) = 0) then begin			// ������ ����(PCI)�� �ʱ�ȭ �Ǿ������� Ȯ��
		if ({CAxtLib}AxtOpenDeviceAuto(AxtLIBDef.BUSTYPE_PCI{BusType}) = 0) then begin			// ���ο� ���̽����带 �ڵ����� ���ն��̺귯���� �߰�
			m_bAxtDeviceOpened := False;
			m_sErrLibApi := 'CAxtLib.AxtOpenDeviceAuto('+IntToStr(AxtLIBDef.BUSTYPE_PCI)+')';
			Exit(nErrCode);
		end;
		{CAxtLib}AxtDisableInterrupt(0);
	end;
{$ENDIF}
	m_bAxtDeviceOpened := True;
	//-------------------------- AXT DIO �ʱ�ȭ
{$IFDEF SIMULATOR_DIO}
  //TBD:SIMULATOR:DIO?
{$ELSE}
	if (not {CAxtDIO}DIOIsInitialized) then begin	// DIO ����� ����� �� �ֵ��� ���̺귯���� �ʱ�ȭ�Ǿ� �ִ��� Ȯ��
		if (not {CAxtDIO}InitializeDIO) then begin		// DIO����� �ʱ�ȭ (�����ִ� ��纣�̽����忡�� DIO����� �˻��Ͽ� �ʱ�ȭ)
			m_bAxtDioInitialized := False;
			m_sErrLibApi := 'CAxtDIO.InitializeDIO';
			Exit(nErrCode);
		end
	end;
{$ENDIF}
	m_bAxtDioInitialized := True;
	m_bConnected := True;
	//
	Result := DefPocb.ERR_OK;
end;

//------------------------------------------------------------------------------
procedure TDioAxt.CloseAxt;
begin
  //-------------------------- ���ն��̺귯�� ����� ����
{$IFDEF SIMULATOR_DIO}
  //TBD:SIMULATOR:DIO?
{$ELSE}
	{CAxtLib}AxtClose;
{$ENDIF}
  //--------------------------
	m_bAxtInitialized 			:= False;
	m_bAxtDeviceOpened 			:= False;
	m_bAxtDioInitialized 		:= False;
	m_bAxtConnected 				:= False;
  m_bConnected := False
end;

//------------------------------------------------------------------------------
procedure TDioAxt.InitDioSig;
var
	nModuleOffset : WORD;
begin
	for nModuleOffset := 0 to DefDio.DIO_MODULE_MAX do begin
		//-------------------------- ���(Output) ��Ʈ�ο� 4����Ʈ�� �����͸� ��ִ´�. ������ ����� ������� ����
{$IFDEF SIMULATOR_DIO}
    //TBD:SIMULATOR:DIO?
{$ELSE}
		{CAxtDIO}DIOwrite_outport_dword(0{nDioInModuleOffset}, 0{offset}, 0{dwValue});
{$ENDIF}
  	//
	  m_dwDioInOld[nModuleOffset]  := 0;  //NOT-USED
  	m_dwDioInNew[nModuleOffset]  := 0;  //NOT-USED
  	m_dwDioOutOld[nModuleOffset] := 0;  //NOT-USED
  	m_dwDioOutNew[nModuleOffset] := 0;  //NOT-USED
 	end;
end;

//******************************************************************************
// procedure/function: TDioAxt: Read/Write
//		- function TDioAxt.ReadDioIn32(nModuleOffset: Integer): DWORD;
//		- function TDioAxt.ReadDioOut32(nModuleOffset: Integer): DWORD;
//		- function TDioAxt.WriteDioOutBit(nSig: Integer; bIsOn: Boolean): Boolean;
//		- function TDioAxt.WriteDioOut32(nModuleOffset: Integer; dwSig32: DWORD): Boolean;
//	  //CAxtDIO.DIOread_inport_bit(nModuleNo, 0{offset});
//		//CAxtDIO.DIOread_inport_byte(nModuleNo, 0{offset});
//	  //CAxtDIO.DIOread_inport_word(nModuleNo, 0{offset});
//******************************************************************************

//------------------------------------------------------------------------------
function TDioAxt.ReadDioIn32(nDioInModuleOffset: Integer): DWORD;
var
	nModuleNo : WORD;
begin
	if (nDioInModuleOffset >= DefDio.DIO_IN_MODULE_CNT) then begin
		Exit(0);
   end;
	//-------------------------- �Է�(Input) ��Ʈ�κ��� 4����Ʈ�� �����͸� �о���δ�. ������ ����� ������� ����
	nModuleNo := DefDio.DIO_MODULENO_DIO_IN + nDioInModuleOffset;
{$IFDEF SIMULATOR_DIO}
  Result := 0; //TBD:SIMULATOR:DIO?
{$ELSE}
	Result := {CAxtDIO}DIOread_inport_dword(nModuleNo,0{offset});
{$ENDIF}
end;


//------------------------------------------------------------------------------
function TDioAxt.ReadDioOut32(nDioOutModuleOffset: Integer): DWORD;
var
	nModuleNo : WORD;
begin
	if (nDioOutModuleOffset >= DefDio.DIO_OUT_MODULE_CNT) then begin
		Exit(0);
	end;
	//-------------------------- ���(Output) ��Ʈ�κ��� 4����Ʈ�� �����͸� �о���δ�. ������ ����� ������� ����
	nModuleNo := DefDio.DIO_MODULENO_DIO_OUT + nDioOutModuleOffset;
{$IFDEF SIMULATOR_DIO}
  Result := 0;  //TBD:SIMULATOR:DIO?
{$ELSE}
	Result := {CAxtDIO}DIOread_outport_dword(nModuleNo,0{offset});
{$ENDIF}
end;

//------------------------------------------------------------------------------
function TDioAxt.WriteDioOutBit(nDioOutModuleOffset : Integer; nSig32Bit: Integer; bIsOn: Boolean): Boolean;
var
	nModuleNo : WORD;
  dwSig32   : DWORD;
begin
	if (nDioOutModuleOffset >= DefDio.DIO_OUT_MODULE_CNT) then begin
		Exit(False);
	end;
	//-------------------------- ���(Output) ��Ʈ�ο� 4����Ʈ�� �����͸� ��ִ´�. ������ ����� ������� ����
  nModuleNo   := DefDio.DIO_MODULENO_DIO_OUT + nDioOutModuleOffset;
{$IFDEF SIMULATOR_DIO}
  //TBD:SIMULATOR:DIO?
{$ELSE}
  //Common.MLog(DefPocb.SYS_LOG,'WriteDioBit');
	{CAxtDIO}DIOwrite_outport_bit(nModuleNo, nSig32Bit{offset}, bIsOn{bValue});
{$ENDIF}
  Result := True;
	//
	m_dwDioOutOld[nDioOutModuleOffset] := m_dwDioOutNew[nDioOutModuleOffset];
	dwSig32 := 1 shl (nSig32Bit mod DIO_OUT_BITpMODULE);
	if (bisOn) then
		m_dwDioOutNew[nDioOutModuleOffset] := m_dwDioOutNew[nDioOutModuleOffset] or dwSig32
	else
		m_dwDioOutNew[nDioOutModuleOffset] := m_dwDioOutNew[nDioOutModuleOffset] and ((not dwSig32) and $ffffffff);
end;

//------------------------------------------------------------------------------
function TDioAxt.WriteDioOut32(nDioOutModuleOffset: Integer; dwSig32: DWORD): Boolean;
var
	nModuleNo : WORD;
begin
	if (not m_bAxtDioInitialized) then begin
		Exit(False);
	end;
	//-------------------------- ���(Output) ��Ʈ�ο� 4����Ʈ�� �����͸� ��ִ´�. ������ ����� ������� ����
	nModuleNo := DefDio.DIO_MODULENO_DIO_OUT + nDioOutModuleOffset;
{$IFDEF SIMULATOR_DIO}
  //TBD:SIMULATOR:DIO?
{$ELSE}
  //Common.MLog(DefPocb.SYS_LOG,'WriteDio32');
	{CAxtDIO}DIOwrite_outport_dword(nModuleNo, 0{offset}, dwSig32{wValue});
{$ENDIF}
  Result := True;
	//
	m_dwDioOutOld[nDioOutModuleOffset] := m_dwDioOutNew[nDioOutModuleOffset];  //NOT-USED
	m_dwDioOutNew[nDioOutModuleOffset]  := dwSig32; //NOT-USED
end;

end.
