unit AxtLIB;

interface

uses Windows, Messages, AxtLIBDef;

{------------------------------------------------------------------------------------------------*
	AXTLIB Library - ���ն��̺귯�� �� ���̽����� ����
	������ǰ
		BIHR - ISA Half size, 2 module
		BIFR - ISA Full size, 4 module
		BPHR - PCI Half size, 2 module
		BPFR - PCI Full size, 4 module
		BV3R - VME 3U size, 2 module
		BV6R - VME 6U size, 4 module
		BC3R - CompactPCI 3U size, 2 module
		BC6R - CompactPCI 6U size, 4 module
 *------------------------------------------------------------------------------------------------}

/// <<���ն��̺귯�� �ʱ�ȭ �� ����>>
// ���� ���̺귯���� �ʱ�ȭ �Ѵ�..
function AxtInitialize (hWnd : HWND; nIrqNo : SmallInt) : Boolean; stdcall;
// ���� ���̺귯���� ��� �������� (�ʱ�ȭ�� �Ǿ�����)�� Ȯ���Ѵ�
function AxtIsInitialized () : Boolean; stdcall;
// ���� ���̺귯���� ����� �����Ѵ�.
procedure AxtClose (); stdcall;

/// <<���̽����� ���� �� �ݱ�>>
// ������ ����(ISA, PCI, VME, CompactPCI)�� �ʱ�ȭ �Ǿ������� Ȯ���Ѵ�
function AxtIsInitializedBus (BusType : SmallInt) : SmallInt; stdcall;
// ���ο� ���̽����带 ���ն��̺귯���� �߰��Ѵ�.
function AxtOpenDevice (BusType : SmallInt; dwBaseAddr : DWord) : SmallInt; stdcall;
// ���ο� ���̽����带 �迭�� �̿��Ͽ� �Ѳ����� ���ն��̺귯���� �߰��Ѵ�.
function AxtOpenDeviceAll (BusType : SmallInt; nLen : SmallInt; dwBaseAddr : PDWord) : SmallInt; stdcall;
// ���ο� ���̽����带 �ڵ����� ���ն��̺귯���� �߰��Ѵ�.
function AxtOpenDeviceAuto (BusType : SmallInt) : SmallInt; stdcall;
// �߰��� ���̽����带 ���� �ݴ´�
procedure AxtCloseDeviceAll (); stdcall;

/// <<���̽����������ͷ�Ʈ ����� �㰡 �� ����>>
// ���̽������� ���ͷ�Ʈ�� ����� �㰡�Ѵ�
procedure AxtEnableInterrupt (nBoardNo : SmallInt); stdcall;
// ���̽������� ���ͷ�Ʈ�� ��� ���������� Ȯ���Ѵ�
function AxtIsEnableInterrupt (nBoardNo : SmallInt) : Boolean; stdcall;
// ���̽������� ���ͷ�Ʈ�� ����� �����Ѵ�
procedure AxtDisableInterrupt (nBoardNo : SmallInt); stdcall;

// <<���̽������� ���ͷ�Ʈ ����ũ �� �÷��� ��������>>
// ���̽������� ���ͷ�Ʈ �÷��� �������͸� Ŭ���� �Ѵ�
procedure AxtInterruptFlagClear (nBoardNo : SmallInt); stdcall;
// ���̽����忡 ������ �� ����� ���ͷ�Ʈ�� ����� �� �ֵ��� �ش� ���� ����� ����Ѵ�
procedure AxtWriteInterruptMaskModule (nBoardNo : SmallInt; Mask : Byte); stdcall;
// ������ ���ͷ�Ʈ ����ũ �������͸� �д´�
function AxtReadInterruptMaskModule (nBoardNo : SmallInt) : Byte; stdcall;
// ���̽������� ���ͷ�Ʈ �÷��� ���������� ������ �д´�
function AxtReadInterruptFlagModule (nBoardNo : SmallInt) : Byte; stdcall;

/// <<���� ����>>
// ������ ������ (���µ�) ���̽����� ������ �����Ѵ�
function AxtGetBoardCounts () : SmallInt; stdcall;
// (���µ�) ��� ���̽����� ������ �����Ѵ�
function AxtGetBoardCountsBus (nBusType : SmallInt) : SmallInt; stdcall;
// ������ ���̽����忡 ������ ����� ID �� ����� ������ �����Ѵ�
function AxtGetModuleCounts (nBoardNo : SmallInt; ModuleID : PByte) : SmallInt; stdcall;
// ������ ���̽����忡 ������ ����� ������ ��� ID�� ������ �����Ѵ�
function AxtGetModelCounts (nBoardNo : SmallInt; ModuleID : Byte) : SmallInt; stdcall;
// ��� ���̽����忡 ������ ����� ������ ���ID�� ���� ����� ������ �����Ѵ�
function AxtGetModelCountsAll (ModuleID : Byte) : SmallInt; stdcall;
// ������ ���̽������� ID�� �����Ѵ�
function AxtGetBoardID (nBoardNo : SmallInt) : SmallInt; stdcall;
// ������ ���̽������� Adress�� �����Ѵ�.
function AxtGetBoardAddress (nBoardNo : SmallInt) : DWord; stdcall;

// Log Level�� �����Ѵ�.
procedure AxtSetLogLevel (nLogLevel : SmallInt); stdcall;
// Log Level�� Ȯ���Ѵ�.
function AxtGetLogLevel () : SmallInt; stdcall;

/// Library Version Infomation
function AxtGetLibVersion () : PChar; stdcall;
function AxtGetLibDate () : PChar; stdcall;

function Axtget_error_code () : SmallInt; stdcall;
function Axtget_error_msg (ErrorCode : SmallInt) : PChar; stdcall;

implementation

const

	dll_name	= 'AxtLib.dll';

	function AxtInitialize; external dll_name name 'AxtInitialize';
	function AxtIsInitialized; external dll_name name 'AxtIsInitialized';
	procedure AxtClose; external dll_name name 'AxtClose';

	function AxtIsInitializedBus; external dll_name name 'AxtIsInitializedBus';
	function AxtOpenDevice; external dll_name name 'AxtOpenDevice';
	function AxtOpenDeviceAll; external dll_name name 'AxtOpenDeviceAll';
	function AxtOpenDeviceAuto; external dll_name name 'AxtOpenDeviceAuto';
	procedure AxtCloseDeviceAll; external dll_name name 'AxtCloseDeviceAll';

	procedure AxtEnableInterrupt; external dll_name name 'AxtEnableInterrupt';
	function AxtIsEnableInterrupt; external dll_name name 'AxtIsEnableInterrupt';
	procedure AxtDisableInterrupt; external dll_name name 'AxtDisableInterrupt';

	procedure AxtInterruptFlagClear; external dll_name name 'AxtInterruptFlagClear';
	procedure AxtWriteInterruptMaskModule; external dll_name name 'AxtWriteInterruptMaskModule';
	function AxtReadInterruptMaskModule; external dll_name name 'AxtReadInterruptMaskModule';
	function AxtReadInterruptFlagModule; external dll_name name 'AxtReadInterruptFlagModule';

	function AxtGetBoardCounts; external dll_name name 'AxtGetBoardCounts';
	function AxtGetBoardCountsBus; external dll_name name 'AxtGetBoardCountsBus';
	function AxtGetModuleCounts; external dll_name name 'AxtGetModuleCounts';
	function AxtGetModelCounts; external dll_name name 'AxtGetModelCounts';
	function AxtGetModelCountsAll; external dll_name name 'AxtGetModelCountsAll';
	function AxtGetBoardID; external dll_name name 'AxtGetBoardID';
	function AxtGetBoardAddress; external dll_name name 'AxtGetBoardAddress';

	procedure AxtSetLogLevel; external dll_name name 'AxtSetLogLevel';
	function AxtGetLogLevel; external dll_name name 'AxtGetLogLevel';

	function AxtGetLibVersion; external dll_name name 'AxtGetLibVersion';
	function AxtGetLibDate; external dll_name name 'AxtGetLibDate';

	function Axtget_error_code; external dll_name name 'Axtget_error_code';
	function Axtget_error_msg; external dll_name name 'Axtget_error_msg';
end.