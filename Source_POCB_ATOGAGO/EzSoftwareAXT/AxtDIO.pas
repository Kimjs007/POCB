unit AxtDIO;

interface

uses Windows, Messages, AxtLIBDef, DIODef;

{------------------------------------------------------------------------------------------------*
	AXTDIO Library - Digital Input/Ouput module
	������ǰ
		SIO-DI32  - �Է� 32��
		SIO-DO32P - ��� 32��, ����Ŀ�÷� ���Ÿ��
		SIO-DO32T - ��� 32��, �Ŀ�TR ���Ÿ��
		SIO-DB32P - �Է� 16�� / ��� 32��, ����Ŀ�÷� ���Ÿ��
		SIO-DB32T - �Է� 16�� / ��� 32��, �Ŀ�TR ���Ÿ��
 *------------------------------------------------------------------------------------------------}

/// �ʱ�ȭ �Լ���
// DIO����� �ʱ�ȭ�Ѵ�. �����ִ� ��纣�̽����忡�� DIO����� �˻��Ͽ� �ʱ�ȭ�Ѵ�
function InitializeDIO () : Boolean; stdcall;
// DIO����� ����� �� �ֵ��� ���̺귯���� �ʱ�ȭ�Ǿ��°� ?
function DIOIsInitialized () : Boolean; stdcall;
//void	PASCAL EXPORT DIOStopService();

// ���ͷ�Ʈ �޼��� �� �ڵ鷯�� �����Ѵ�.
procedure DIOSetWindowMessage (hWnd : HWND; wMsg : Word; proc : AXT_DIO_INTERRUPT_PROC); stdcall;

/// ���ͷ�Ʈ ���� �Լ���
// ������ ����� ���ͷ�Ʈ�� ����Ѵ�.
procedure DIOEnableInterrupt (nModuleNo : SmallInt); stdcall;
// ������ ����� ���ͷ�Ʈ�� �����Ѵ�.
procedure DIODisableInterrupt (nModuleNo : SmallInt); stdcall;
// ����� ���ͷ�Ʈ ������������ Ȯ���Ѵ�.
function DIOIsInterruptEnabled (nModuleNo : SmallInt) : Boolean; stdcall;

/// ���� �� ��� ���� �Լ���
// ������ ���̽����尡 �����ִ���(���µǾ�����)�� Ȯ���Ѵ�
function DIOIsOpenBoard (nBoardNo : SmallInt) : Boolean; stdcall;
// ������ DIO����� �����ִ���(���µǾ�����)�� Ȯ���Ѵ�
function DIOIsOpenModule (nModuleNo : SmallInt) : Boolean; stdcall;
// ��ȿ�� ����ȣ������ Ȯ���Ѵ�
function DIOIsValidModuleNo (nModuleNo : SmallInt) : Boolean; stdcall;
// DIO����� ������ ���̽������� ������ �����Ѵ�
function DIOget_board_count () : Word; stdcall;
// DIO����� ������ �����Ѵ�.
function DIOget_module_count () : Word; stdcall;
// ������ ������ ����ϴ� ���̽����� ��ȣ�� �����Ѵ�
function DIOget_boardno (address : DWord) : SmallInt; stdcall;
		{
			address : �������
			���ϰ�
				0..���̽�����-1
				-1	= ��ȿ���� �ʴ� ����
		}

// ������ ����� �𵨹�ȣ�� �����Ѵ�
function DIOget_module_id (nModuleNo : SmallInt) : Word; stdcall;
		{
			���ϰ�
				97h(AXT_SIO_DI32)	= SIO-DI32
				98h(AXT_SIO_DO32P)	= SIO-DO32P
				99h(AXT_SIO_DB32P)	= SIO-DB32P
				9Eh(AXT_SIO_DO32T)	= SIO-DO32T
				9Fh(AXT_SIO_DB32T)	= SIO-DB32T
				00h	= ��ȿ���� �ʴ� ����ȣ
		}
// ������ ����� ���̽����峻 ��� ��ġ�� �����Ѵ�.
function DIOget_module_pos (nModuleNo : SmallInt) : SmallInt; stdcall;
// ������ ����� ��������� �����Ѵ�.
function DIOget_output_number (nModuleNo : SmallInt) : Word; stdcall;
// ������ ����� �Է������� �����Ѵ�.
function DIOget_input_number (nModuleNo : SmallInt) : Word; stdcall;
// ������ ���̽������� �����ġ�� �ִ� DIO����� ����ȣ�� �����Ѵ�.
function DIOget_module_number (nBoardNo : SmallInt; nModulePos : SmallInt) : Word; stdcall;
// ������ ����ȣ�� ���̽������ȣ�� �����ġ�� �����Ѵ�
function DIOget_module_info (nModuleNo : SmallInt; pBoardNo : PSmallInt; nModulePos : PSmallInt) : Boolean; stdcall;
// ������ ���� ����� ������ �����Ѵ�.
function DIOget_open_module_count (ModuleID : SmallInt) : Word; stdcall;
		{
			ModuleID
				97h(AXT_SIO_DI32)	: SIO-DI32
				98h(AXT_SIO_DO32P)	: SIO-DO32P
				99h(AXT_SIO_DB32P)	: SIO-DB32P
				9Eh(AXT_SIO_DO32T)	: SIO-DO32T
				9Fh(AXT_SIO_DB32T)	: SIO-DB32T
				00h(DIO_MODULE_ALL)	: ��� DIO���
			���ϰ�	: ����� ������ �����Ѵ�

		}

/// Write port(Register) �Լ���
// ���(Output) ��Ʈ�ο� 1��Ʈ�� �����͸� ��ִ´�. ���� ����
procedure DIOwrite_outport (offset : Word; bValue : Boolean); stdcall;
// ���(Output) ��Ʈ�ο� 1��Ʈ�� �����͸� ��ִ´�. ������ ����� ���� ����
procedure DIOwrite_outport_bit (nModuleNo : SmallInt; offset : Word; bValue : Boolean); stdcall;
// ���(Output) ��Ʈ�ο� 1����Ʈ�� �����͸� ��ִ´�. ������ ����� ����Ʈ ����
procedure DIOwrite_outport_byte (nModuleNo : SmallInt; offset : Word; byValue : Byte); stdcall;
// ���(Output) ��Ʈ�ο� 2����Ʈ�� �����͸� ��ִ´�. ������ ����� ���� ����
procedure DIOwrite_outport_word (nModuleNo : SmallInt; offset : Word; wValue : Word); stdcall;
// ���(Output) ��Ʈ�ο� 4����Ʈ�� �����͸� ��ִ´�. ������ ����� ������� ����
procedure DIOwrite_outport_dword (nModuleNo : SmallInt; offset : Word; lValue : DWord); stdcall;
// ���(Output) ��Ʈ�κ��� 1��Ʈ�� �����͸� �о���δ�, ���� ����
function DIOread_outport (offset : Word) : Boolean; stdcall;
// ���(Output) ��Ʈ�κ��� 1��Ʈ�� �����͸� �о���δ�. ������ ����� ���� ����
function DIOread_outport_bit (nModuleNo : SmallInt; offset : Word) : Boolean; stdcall;
// ���(Output) ��Ʈ�κ��� 1����Ʈ�� �����͸� �о���δ�, ������ ����� ����Ʈ ����
function DIOread_outport_byte (nModuleNo : SmallInt; offset : Word) : Byte; stdcall;
// ���(Output) ��Ʈ�κ��� 2����Ʈ�� �����͸� �о���δ�, ������ ����� ���� ����
function DIOread_outport_word (nModuleNo : SmallInt; offset : Word) : Word; stdcall;
// ���(Output) ��Ʈ�κ��� 4����Ʈ�� �����͸� �о���δ�, ������ ����� ������� ����
function DIOread_outport_dword (nModuleNo : SmallInt; offset : Word) : DWord; stdcall;
		{
			offset
				DIOwrite_outport(),       DIOread_outport()			: 0���� ���������-1���� ��� ����
				DIOwrite_outport_bit(),   DIOread_outport_bit()		: SIO-DI32:���Ұ�, SIO-DB32:0..15, SIO-DO32:0..31
				DIOwrite_outport_byte(),  DIOread_outport_byte()	: SIO-DI32:���Ұ�, SIO-DB32:0..1,  SIO-DO32:0..3
				DIOwrite_outport_word(),  DIOread_outport_word()	: SIO-DI32:���Ұ�, SIO-DB32:0,     SIO-DO32:0..1
				DIOwrite_outport_dword(), DIOread_outport_dword()	: SIO-DI32:���Ұ�, SIO-DB32:0,     SIO-DO32:0
			���ϰ�
				DIOread_outport()		: 0(OFF), 1(ON)
				DIOread_outport_bit()	: 0(OFF), 1(ON)
				DIOread_outport_byte()	: 00h .. FFh
				DIOread_outport_word()	: 0000h .. FFFFh
				DIOread_outport_dword()	: 00000000h .. FFFFFFFFh
		}

/// Input port �Լ��� - �б� ���� ��Ʈ
// �Է�(Input) ��Ʈ�κ��� 1��Ʈ�� �����͸� �о���δ�. ���� ����
function DIOread_inport (offset : Word) : Boolean; stdcall;
// �Է�(Input) ��Ʈ�κ��� 1��Ʈ�� �����͸� �о���δ�. ������ ����� ���� ����
function DIOread_inport_bit (nModuleNo : SmallInt; offset : Word) : Boolean; stdcall;
// �Է�(Input) ��Ʈ�κ��� 1����Ʈ�� �����͸� �о���δ�. ������ ����� ����Ʈ ����
function DIOread_inport_byte (nModuleNo : SmallInt; offset : Word) : Byte; stdcall;
// �Է�(Input) ��Ʈ�κ��� 2����Ʈ�� �����͸� �о���δ�. ������ ����� ���� ����
function DIOread_inport_word (nModuleNo : SmallInt; offset : Word) : Word; stdcall;
// �Է�(Input) ��Ʈ�κ��� 4����Ʈ�� �����͸� �о���δ�. ������ ����� ������� ����
function DIOread_inport_dword (nModuleNo : SmallInt; offset : Word) : DWord; stdcall;
		{
			offset
				DIOread_inport()		: 0���� ���Է�����-1���� ��� ����
				DIOread_inport_bit()	: SIO-DI32:0..31, SIO-DB32:0..15, SIO-DO32:���Ұ�
				DIOread_inport_byte()	: SIO-DI32:0..3,  SIO-DB32:0..1,  SIO-DO32:���Ұ�
				DIOread_inport_word()	: SIO-DI32:0..1,  SIO-DB32:0,     SIO-DO32:���Ұ�
				DIOread_inport_dword()	: SIO-DI32:0,     SIO-DB32:0,     SIO-DO32:���Ұ�
			���ϰ�
				DIOread_inport()		: 0(OFF), 1(ON)
				DIOread_inport_bit()	: 0(OFF), 1(ON)
				DIOread_inport_byte()	: 00h .. FFh
				DIOread_inport_word()	: 0000h .. FFFFh
				DIOread_inport_dword()	: 00000000h .. FFFFFFFFh
		}

/// Interrupt Up-edge port(Register) �Լ���
// ��¿���(Upedge) ��Ʈ�ο� 1��Ʈ�� �����͸� ��ִ´�. ���� ����
procedure DIOwrite_upedge (offset : Word; bValue : Boolean); stdcall;
// ��¿���(Upedge) ��Ʈ�ο� 1��Ʈ�� �����͸� ��ִ´�. ������ ����� ���� ����
procedure DIOwrite_upedge_bit (nModuleNo : SmallInt; offset : Word; bValue : Boolean); stdcall;
// ��¿���(Upedge) ��Ʈ�ο� 1����Ʈ�� �����͸� ��ִ´�. ������ ����� ����Ʈ ����
procedure DIOwrite_upedge_byte (nModuleNo : SmallInt; offset : Word; byValue : Byte); stdcall;
// ��¿���(Upedge) ��Ʈ�ο� 2����Ʈ�� �����͸� ��ִ´�. ������ ����� ���� ����
procedure DIOwrite_upedge_word (nModuleNo : SmallInt; offset : Word; wValue : Word); stdcall;
// ��¿���(Upedge) ��Ʈ�ο� 4����Ʈ�� �����͸� ��ִ´�. ������ ����� ������� ����
procedure DIOwrite_upedge_dword (nModuleNo : SmallInt; offset : Word; lValue : DWord); stdcall;
// ��¿���(Upedge) ��Ʈ�κ��� 1��Ʈ�� �����͸� �о���δ�, ���� ����
function DIOread_upedge (offset : Word) : Boolean; stdcall;
// ��¿���(Upedge) ��Ʈ�κ��� 1��Ʈ�� �����͸� �о���δ�. ������ ����� ���� ����
function DIOread_upedge_bit (nModuleNo : SmallInt; offset : Word) : Boolean; stdcall;
// ��¿���(Upedge) ��Ʈ�κ��� 1����Ʈ�� �����͸� �о���δ�, ������ ����� ����Ʈ ����
function DIOread_upedge_byte (nModuleNo : SmallInt; offset : Word) : Byte; stdcall;
// ��¿���(Upedge) ��Ʈ�κ��� 2����Ʈ�� �����͸� �о���δ�, ������ ����� ���� ����
function DIOread_upedge_word (nModuleNo : SmallInt; offset : Word) : Word; stdcall;
// ��¿���(Upedge) ��Ʈ�κ��� 4����Ʈ�� �����͸� �о���δ�, ������ ����� ������� ����
function DIOread_upedge_dword (nModuleNo : SmallInt; offset : Word) : DWord; stdcall;
		{
			offset
				DIOwrite_upedge(),       DIOread_upedge()		: 0���� ���Է�����-1���� ��� ����
				DIOwrite_upedge_bit(),   DIOread_upedge_bit()	: SIO-DI32:0..31, SIO-DB32:0..15, SIO-DO32:���Ұ�
				DIOwrite_upedge_byte(),  DIOread_upedge_byte()	: SIO-DI32:0..3,  SIO-DB32:0..1,  SIO-DO32:���Ұ�
				DIOwrite_upedge_word(),  DIOread_upedge_word()	: SIO-DI32:0..1,  SIO-DB32:0,     SIO-DO32:���Ұ�
				DIOwrite_upedge_dword(), DIOread_upedge_dword()	: SIO-DI32:0,     SIO-DB32:0,     SIO-DO32:���Ұ�
			���ϰ�
				DIOread_upedge()		: 0(OFF), 1(ON)
				DIOread_upedge_bit()	: 0(OFF), 1(ON)
				DIOread_upedge_byte()	: 00h .. FFh
				DIOread_upedge_word()	: 0000h .. FFFFh
				DIOread_upedge_dword()	: 00000000h .. FFFFFFFFh
		}

/// Interrupt Down-edge port(Register) �Լ���
// �ϰ�����(Downedge) ��Ʈ�ο� 1��Ʈ�� �����͸� ��ִ´�. ���� ����
procedure DIOwrite_downedge (offset : Word; bValue : Boolean); stdcall;
// �ϰ�����(Downedge) ��Ʈ�ο� 1��Ʈ�� �����͸� ��ִ´�. ������ ����� ���� ����
procedure DIOwrite_downedge_bit (nModuleNo : SmallInt; offset : Word; bValue : Boolean); stdcall;
// �ϰ�����(Downedge) ��Ʈ�ο� 1����Ʈ�� �����͸� ��ִ´�. ������ ����� ����Ʈ ����
procedure DIOwrite_downedge_byte (nModuleNo : SmallInt; offset : Word; byValue : Byte); stdcall;
// �ϰ�����(Downedge) ��Ʈ�ο� 2����Ʈ�� �����͸� ��ִ´�. ������ ����� ���� ����
procedure DIOwrite_downedge_word (nModuleNo : SmallInt; offset : Word; wValue : Word); stdcall;
// �ϰ�����(Downedge) ��Ʈ�ο� 4����Ʈ�� �����͸� ��ִ´�. ������ ����� ������� ����
procedure DIOwrite_downedge_dword (nModuleNo : SmallInt; offset : Word; lValue : DWord); stdcall;
// �ϰ�����(Downedge) ��Ʈ�κ��� 1��Ʈ�� �����͸� �о���δ�, ���� ����
function DIOread_downedge (offset : Word) : Boolean; stdcall;
// �ϰ�����(Downedge) ��Ʈ�κ��� 1��Ʈ�� �����͸� �о���δ�. ������ ����� ���� ����
function DIOread_downedge_bit (nModuleNo : SmallInt; offset : Word) : Boolean; stdcall;
// �ϰ�����(Downedge) ��Ʈ�κ��� 1����Ʈ�� �����͸� �о���δ�, ������ ����� ����Ʈ ����
function DIOread_downedge_byte (nModuleNo : SmallInt; offset : Word) : Byte; stdcall;
// �ϰ�����(Downedge) ��Ʈ�κ��� 2����Ʈ�� �����͸� �о���δ�, ������ ����� ���� ����
function DIOread_downedge_word (nModuleNo : SmallInt; offset : Word) : Word; stdcall;
// �ϰ�����(Downedge) ��Ʈ�κ��� 4����Ʈ�� �����͸� �о���δ�, ������ ����� ������� ����
function DIOread_downedge_dword (nModuleNo : SmallInt; offset : Word) : DWord; stdcall;
		{
			offset
				DIOwrite_downedge(),       DIOread_downedge()		: 0���� ���Է�����-1���� ��� ����
				DIOwrite_downedge_bit(),   DIOread_downedge_bit()	: SIO-DI32:0..31, SIO-DB32:0..15, SIO-DO32:���Ұ�
				DIOwrite_downedge_byte(),  DIOread_downedge_byte()	: SIO-DI32:0..3,  SIO-DB32:0..1,  SIO-DO32:���Ұ�
				DIOwrite_downedge_word(),  DIOread_downedge_word()	: SIO-DI32:0..1,  SIO-DB32:0,     SIO-DO32:���Ұ�
				DIOwrite_downedge_dword(), DIOread_downedge_dword()	: SIO-DI32:0,     SIO-DB32:0,     SIO-DO32:���Ұ�
			���ϰ�
				DIOread_downedge()		: 0(OFF), 1(ON)
				DIOread_downedge_bit()	: 0(OFF), 1(ON)
				DIOread_downedge_byte()	: 00h .. FFh
				DIOread_downedge_word()	: 0000h .. FFFFh
				DIOread_downedge_dword(): 00000000h .. FFFFFFFFh
		}	

/// Interrupt flag port(Register) �Լ���
// ���ͷ�Ʈ�÷���(Flag) ��Ʈ�κ��� 1��Ʈ�� �����͸� �о���δ�, ���� ����
function DIOread_flag (offset : Word) : Boolean; stdcall;
// ���ͷ�Ʈ�÷���(Flag) ��Ʈ�κ��� 1��Ʈ�� �����͸� �о���δ�. ������ ����� ���� ����
function DIOread_flag_bit (nModuleNo : SmallInt; offset : Word) : Boolean; stdcall;
// ���ͷ�Ʈ�÷���(Flag) ��Ʈ�κ��� 1����Ʈ�� �����͸� �о���δ�, ������ ����� ����Ʈ ����
function DIOread_flag_byte (nModuleNo : SmallInt; offset : Word) : Byte; stdcall;
// ���ͷ�Ʈ�÷���(Flag) ��Ʈ�κ��� 2����Ʈ�� �����͸� �о���δ�, ������ ����� ���� ����
function DIOread_flag_word (nModuleNo : SmallInt; offset : Word) : Word; stdcall;
// ���ͷ�Ʈ�÷���(Flag) ��Ʈ�κ��� 4����Ʈ�� �����͸� �о���δ�, ������ ����� ������� ����
function DIOread_flag_dword (nModuleNo : SmallInt; offset : Word) : DWord; stdcall;
		{
			offset
				DIOread_flag()		: 0���� ���Է�����-1���� ��� ����
				DIOread_flag_bit()	: SIO-DI32:0..31, SIO-DB32:0..15, SIO-DO32:���Ұ�
				DIOread_flag_byte()	: SIO-DI32:0..3,  SIO-DB32:0..1,  SIO-DO32:���Ұ�
				DIOread_flag_word()	: SIO-DI32:0..1,  SIO-DB32:0,     SIO-DO32:���Ұ�
				DIOread_flag_dword(): SIO-DI32:0,     SIO-DB32:0,     SIO-DO32:���Ұ�
			���ϰ�
				DIOread_flag()		: 0(OFF), 1(ON)
				DIOread_flag_bit()	: 0(OFF), 1(ON)
				DIOread_flag_byte()	: 00h .. FFh
				DIOread_flag_word()	: 0000h .. FFFFh
				DIOread_flag_dword(): 00000000h .. FFFFFFFFh
		}

{----------------------- ���������� ����ϴ� ����(Parameter) ------------------------------------*
	nBoardNo	: ���̽������ȣ, ����� ������� 0���� �Ҵ�ȴ�
	nModuleNo	: DIO��� ��ȣ, DIO����� ������ ������� ����� ������� 0���� �Ҵ�ȴ�
 *------------------------------------------------------------------------------------------------}

function DIOget_error_code () : SmallInt; stdcall;
function DIOget_error_msg (ErrorCode : SmallInt) : PChar; stdcall;

implementation

const

	dll_name	= 'AxtLib.dll';

	function InitializeDIO; external dll_name name 'InitializeDIO';
	function DIOIsInitialized; external dll_name name 'DIOIsInitialized';

	procedure DIOSetWindowMessage; external dll_name name 'DIOSetWindowMessage';

	procedure DIOEnableInterrupt; external dll_name name 'DIOEnableInterrupt';
	procedure DIODisableInterrupt; external dll_name name 'DIODisableInterrupt';
	function DIOIsInterruptEnabled; external dll_name name 'DIOIsInterruptEnabled';

	function DIOIsOpenBoard; external dll_name name 'DIOIsOpenBoard';
	function DIOIsOpenModule; external dll_name name 'DIOIsOpenModule';
	function DIOIsValidModuleNo; external dll_name name 'DIOIsValidModuleNo';
	function DIOget_board_count; external dll_name name 'DIOget_board_count';
	function DIOget_module_count; external dll_name name 'DIOget_module_count';
	function DIOget_boardno; external dll_name name 'DIOget_boardno';

	function DIOget_module_id; external dll_name name 'DIOget_module_id';
	function DIOget_module_pos; external dll_name name 'DIOget_module_pos';
	function DIOget_output_number; external dll_name name 'DIOget_output_number';
	function DIOget_input_number; external dll_name name 'DIOget_input_number';
	function DIOget_module_number; external dll_name name 'DIOget_module_number';
	function DIOget_module_info; external dll_name name 'DIOget_module_info';
	function DIOget_open_module_count; external dll_name name 'DIOget_open_module_count';

	procedure DIOwrite_outport; external dll_name name 'DIOwrite_outport';
	procedure DIOwrite_outport_bit; external dll_name name 'DIOwrite_outport_bit';
	procedure DIOwrite_outport_byte; external dll_name name 'DIOwrite_outport_byte';
	procedure DIOwrite_outport_word; external dll_name name 'DIOwrite_outport_word';
	procedure DIOwrite_outport_dword; external dll_name name 'DIOwrite_outport_dword';
	function DIOread_outport; external dll_name name 'DIOread_outport';
	function DIOread_outport_bit; external dll_name name 'DIOread_outport_bit';
	function DIOread_outport_byte; external dll_name name 'DIOread_outport_byte';
	function DIOread_outport_word; external dll_name name 'DIOread_outport_word';
	function DIOread_outport_dword; external dll_name name 'DIOread_outport_dword';

	function DIOread_inport; external dll_name name 'DIOread_inport';
	function DIOread_inport_bit; external dll_name name 'DIOread_inport_bit';
	function DIOread_inport_byte; external dll_name name 'DIOread_inport_byte';
	function DIOread_inport_word; external dll_name name 'DIOread_inport_word';
	function DIOread_inport_dword; external dll_name name 'DIOread_inport_dword';

	procedure DIOwrite_upedge; external dll_name name 'DIOwrite_upedge';
	procedure DIOwrite_upedge_bit; external dll_name name 'DIOwrite_upedge_bit';
	procedure DIOwrite_upedge_byte; external dll_name name 'DIOwrite_upedge_byte';
	procedure DIOwrite_upedge_word; external dll_name name 'DIOwrite_upedge_word';
	procedure DIOwrite_upedge_dword; external dll_name name 'DIOwrite_upedge_dword';
	function DIOread_upedge; external dll_name name 'DIOread_upedge';
	function DIOread_upedge_bit; external dll_name name 'DIOread_upedge_bit';
	function DIOread_upedge_byte; external dll_name name 'DIOread_upedge_byte';
	function DIOread_upedge_word; external dll_name name 'DIOread_upedge_word';
	function DIOread_upedge_dword; external dll_name name 'DIOread_upedge_dword';

	procedure DIOwrite_downedge; external dll_name name 'DIOwrite_downedge';
	procedure DIOwrite_downedge_bit; external dll_name name 'DIOwrite_downedge_bit';
	procedure DIOwrite_downedge_byte; external dll_name name 'DIOwrite_downedge_byte';
	procedure DIOwrite_downedge_word; external dll_name name 'DIOwrite_downedge_word';
	procedure DIOwrite_downedge_dword; external dll_name name 'DIOwrite_downedge_dword';
	function DIOread_downedge; external dll_name name 'DIOread_downedge';
	function DIOread_downedge_bit; external dll_name name 'DIOread_downedge_bit';
	function DIOread_downedge_byte; external dll_name name 'DIOread_downedge_byte';
	function DIOread_downedge_word; external dll_name name 'DIOread_downedge_word';
	function DIOread_downedge_dword; external dll_name name 'DIOread_downedge_dword';

	function DIOread_flag; external dll_name name 'DIOread_flag';
	function DIOread_flag_bit; external dll_name name 'DIOread_flag_bit';
	function DIOread_flag_byte; external dll_name name 'DIOread_flag_byte';
	function DIOread_flag_word; external dll_name name 'DIOread_flag_word';
	function DIOread_flag_dword; external dll_name name 'DIOread_flag_dword';


	function DIOget_error_code; external dll_name name 'DIOget_error_code';
	function DIOget_error_msg; external dll_name name 'DIOget_error_msg';
end.