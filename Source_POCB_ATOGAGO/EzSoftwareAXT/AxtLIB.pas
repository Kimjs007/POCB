unit AxtLIB;

interface

uses Windows, Messages, AxtLIBDef;

{------------------------------------------------------------------------------------------------*
	AXTLIB Library - 통합라이브러리 및 베이스보드 관리
	적용제품
		BIHR - ISA Half size, 2 module
		BIFR - ISA Full size, 4 module
		BPHR - PCI Half size, 2 module
		BPFR - PCI Full size, 4 module
		BV3R - VME 3U size, 2 module
		BV6R - VME 6U size, 4 module
		BC3R - CompactPCI 3U size, 2 module
		BC6R - CompactPCI 6U size, 4 module
 *------------------------------------------------------------------------------------------------}

/// <<통합라이브러리 초기화 및 종료>>
// 통합 라이브러리를 초기화 한다..
function AxtInitialize (hWnd : HWND; nIrqNo : SmallInt) : Boolean; stdcall;
// 통합 라이브러리가 사용 가능하지 (초기화가 되었는지)를 확인한다
function AxtIsInitialized () : Boolean; stdcall;
// 통합 라이브러리의 사용을 종료한다.
procedure AxtClose (); stdcall;

/// <<베이스보드 오픈 및 닫기>>
// 지정한 버스(ISA, PCI, VME, CompactPCI)가 초기화 되었는지를 확인한다
function AxtIsInitializedBus (BusType : SmallInt) : SmallInt; stdcall;
// 새로운 베이스보드를 통합라이브러리에 추가한다.
function AxtOpenDevice (BusType : SmallInt; dwBaseAddr : DWord) : SmallInt; stdcall;
// 새로운 베이스보드를 배열을 이용하여 한꺼번에 통합라이브러리에 추가한다.
function AxtOpenDeviceAll (BusType : SmallInt; nLen : SmallInt; dwBaseAddr : PDWord) : SmallInt; stdcall;
// 새로운 베이스보드를 자동으로 통합라이브러리에 추가한다.
function AxtOpenDeviceAuto (BusType : SmallInt) : SmallInt; stdcall;
// 추가된 베이스보드를 전부 닫는다
procedure AxtCloseDeviceAll (); stdcall;

/// <<베이스보드의인터럽트 사용의 허가 및 금지>>
// 베이스보드의 인터럽트의 사용을 허가한다
procedure AxtEnableInterrupt (nBoardNo : SmallInt); stdcall;
// 베이스보드의 인터럽트가 사용 가능한지를 확인한다
function AxtIsEnableInterrupt (nBoardNo : SmallInt) : Boolean; stdcall;
// 베이스보드의 인터럽트의 사용을 금지한다
procedure AxtDisableInterrupt (nBoardNo : SmallInt); stdcall;

// <<베이스보드의 인터럽트 마스크 및 플래그 레지스터>>
// 베이스보드의 인터럽트 플래그 레지스터를 클리어 한다
procedure AxtInterruptFlagClear (nBoardNo : SmallInt); stdcall;
// 베이스보드에 장착된 각 모듈의 인터럽트를 사용할 수 있도록 해당 핀의 사용을 허용한다
procedure AxtWriteInterruptMaskModule (nBoardNo : SmallInt; Mask : Byte); stdcall;
// 설정된 인터럽트 마스크 레지스터를 읽는다
function AxtReadInterruptMaskModule (nBoardNo : SmallInt) : Byte; stdcall;
// 베이스보드의 인터럽트 플래그 레지스터의 내용을 읽는다
function AxtReadInterruptFlagModule (nBoardNo : SmallInt) : Byte; stdcall;

/// <<보드 정보>>
// 지정한 버스의 (오픈된) 베이스보드 갯수를 리턴한다
function AxtGetBoardCounts () : SmallInt; stdcall;
// (오픈된) 모든 베이스보드 갯수를 리턴한다
function AxtGetBoardCountsBus (nBusType : SmallInt) : SmallInt; stdcall;
// 지정한 베이스보드에 장착된 모듈의 ID 및 모듈의 갯수를 리턴한다
function AxtGetModuleCounts (nBoardNo : SmallInt; ModuleID : PByte) : SmallInt; stdcall;
// 지정한 베이스보드에 장착된 모듈중 지정한 모듈 ID의 갯수를 리턴한다
function AxtGetModelCounts (nBoardNo : SmallInt; ModuleID : Byte) : SmallInt; stdcall;
// 모든 베이스보드에 장착된 모듈중 지정한 모듈ID를 가진 모듈의 갯수를 리턴한다
function AxtGetModelCountsAll (ModuleID : Byte) : SmallInt; stdcall;
// 지정한 베이스보드의 ID를 리턴한다
function AxtGetBoardID (nBoardNo : SmallInt) : SmallInt; stdcall;
// 지정한 베이스보드의 Adress를 리턴한다.
function AxtGetBoardAddress (nBoardNo : SmallInt) : DWord; stdcall;

// Log Level을 설정한다.
procedure AxtSetLogLevel (nLogLevel : SmallInt); stdcall;
// Log Level을 확인한다.
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