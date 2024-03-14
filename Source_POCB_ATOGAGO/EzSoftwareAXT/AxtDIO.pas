unit AxtDIO;

interface

uses Windows, Messages, AxtLIBDef, DIODef;

{------------------------------------------------------------------------------------------------*
	AXTDIO Library - Digital Input/Ouput module
	적용제품
		SIO-DI32  - 입력 32점
		SIO-DO32P - 출력 32점, 포토커플러 출력타입
		SIO-DO32T - 출력 32점, 파워TR 출력타입
		SIO-DB32P - 입력 16점 / 출력 32점, 포토커플러 출력타입
		SIO-DB32T - 입력 16점 / 출력 32점, 파워TR 출력타입
 *------------------------------------------------------------------------------------------------}

/// 초기화 함수군
// DIO모듈을 초기화한다. 열려있는 모든베이스보드에서 DIO모듈을 검색하여 초기화한다
function InitializeDIO () : Boolean; stdcall;
// DIO모듈을 사용할 수 있도록 라이브러리가 초기화되었는가 ?
function DIOIsInitialized () : Boolean; stdcall;
//void	PASCAL EXPORT DIOStopService();

// 인터럽트 메세지 및 핸들러를 설정한다.
procedure DIOSetWindowMessage (hWnd : HWND; wMsg : Word; proc : AXT_DIO_INTERRUPT_PROC); stdcall;

/// 인터럽트 관련 함수군
// 지정한 모듈의 인터럽트를 허용한다.
procedure DIOEnableInterrupt (nModuleNo : SmallInt); stdcall;
// 지정한 모듈의 인터럽트를 금지한다.
procedure DIODisableInterrupt (nModuleNo : SmallInt); stdcall;
// 모듈이 인터럽트 허용상태인지를 확인한다.
function DIOIsInterruptEnabled (nModuleNo : SmallInt) : Boolean; stdcall;

/// 보드 및 모듈 정보 함수군
// 지정한 베이스보드가 열려있는지(오픈되었는지)를 확인한다
function DIOIsOpenBoard (nBoardNo : SmallInt) : Boolean; stdcall;
// 지정한 DIO모듈이 열려있는지(오픈되었는지)를 확인한다
function DIOIsOpenModule (nModuleNo : SmallInt) : Boolean; stdcall;
// 유효한 모듈번호인지를 확인한다
function DIOIsValidModuleNo (nModuleNo : SmallInt) : Boolean; stdcall;
// DIO모듈이 장착된 베이스보드의 갯수를 리턴한다
function DIOget_board_count () : Word; stdcall;
// DIO모듈의 갯수를 리턴한다.
function DIOget_module_count () : Word; stdcall;
// 지정한 번지를 사용하는 베이스보드 번호를 리턴한다
function DIOget_boardno (address : DWord) : SmallInt; stdcall;
		{
			address : 절대번지
			리턴값
				0..베이스보드-1
				-1	= 유효하지 않는 번지
		}

// 지정한 모듈의 모델번호를 리턴한다
function DIOget_module_id (nModuleNo : SmallInt) : Word; stdcall;
		{
			리턴값
				97h(AXT_SIO_DI32)	= SIO-DI32
				98h(AXT_SIO_DO32P)	= SIO-DO32P
				99h(AXT_SIO_DB32P)	= SIO-DB32P
				9Eh(AXT_SIO_DO32T)	= SIO-DO32T
				9Fh(AXT_SIO_DB32T)	= SIO-DB32T
				00h	= 유효하지 않는 모듈번호
		}
// 지정한 모듈의 베이스보드내 모듈 위치를 리턴한다.
function DIOget_module_pos (nModuleNo : SmallInt) : SmallInt; stdcall;
// 지정한 모듈의 출력점수를 리턴한다.
function DIOget_output_number (nModuleNo : SmallInt) : Word; stdcall;
// 지정한 모듈의 입력점수를 리턴한다.
function DIOget_input_number (nModuleNo : SmallInt) : Word; stdcall;
// 지정한 베이스보드의 모듈위치에 있는 DIO모듈의 모듈번호를 리턴한다.
function DIOget_module_number (nBoardNo : SmallInt; nModulePos : SmallInt) : Word; stdcall;
// 지정한 모듈번호의 베이스보드번호와 모듈위치를 리턴한다
function DIOget_module_info (nModuleNo : SmallInt; pBoardNo : PSmallInt; nModulePos : PSmallInt) : Boolean; stdcall;
// 지정한 모델의 모듈의 갯수를 리턴한다.
function DIOget_open_module_count (ModuleID : SmallInt) : Word; stdcall;
		{
			ModuleID
				97h(AXT_SIO_DI32)	: SIO-DI32
				98h(AXT_SIO_DO32P)	: SIO-DO32P
				99h(AXT_SIO_DB32P)	: SIO-DB32P
				9Eh(AXT_SIO_DO32T)	: SIO-DO32T
				9Fh(AXT_SIO_DB32T)	: SIO-DB32T
				00h(DIO_MODULE_ALL)	: 모든 DIO모듈
			리턴값	: 모듈의 갯수를 리턴한다

		}

/// Write port(Register) 함수군
// 출력(Output) 포트로에 1비트의 데이터를 써넣는다. 점수 단위
procedure DIOwrite_outport (offset : Word; bValue : Boolean); stdcall;
// 출력(Output) 포트로에 1비트의 데이터를 써넣는다. 지정한 모듈의 점수 단위
procedure DIOwrite_outport_bit (nModuleNo : SmallInt; offset : Word; bValue : Boolean); stdcall;
// 출력(Output) 포트로에 1바이트의 데이터를 써넣는다. 지정한 모듈의 바이트 단위
procedure DIOwrite_outport_byte (nModuleNo : SmallInt; offset : Word; byValue : Byte); stdcall;
// 출력(Output) 포트로에 2바이트의 데이터를 써넣는다. 지정한 모듈의 워드 단위
procedure DIOwrite_outport_word (nModuleNo : SmallInt; offset : Word; wValue : Word); stdcall;
// 출력(Output) 포트로에 4바이트의 데이터를 써넣는다. 지정한 모듈의 더블워드 단위
procedure DIOwrite_outport_dword (nModuleNo : SmallInt; offset : Word; lValue : DWord); stdcall;
// 출력(Output) 포트로부터 1비트의 데이터를 읽어들인다, 점수 단위
function DIOread_outport (offset : Word) : Boolean; stdcall;
// 출력(Output) 포트로부터 1비트의 데이터를 읽어들인다. 지정한 모듈의 점수 단위
function DIOread_outport_bit (nModuleNo : SmallInt; offset : Word) : Boolean; stdcall;
// 출력(Output) 포트로부터 1바이트의 데이터를 읽어들인다, 지정한 모듈의 바이트 단위
function DIOread_outport_byte (nModuleNo : SmallInt; offset : Word) : Byte; stdcall;
// 출력(Output) 포트로부터 2바이트의 데이터를 읽어들인다, 지정한 모듈의 워드 단위
function DIOread_outport_word (nModuleNo : SmallInt; offset : Word) : Word; stdcall;
// 출력(Output) 포트로부터 4바이트의 데이터를 읽어들인다, 지정한 모듈의 더블워드 단위
function DIOread_outport_dword (nModuleNo : SmallInt; offset : Word) : DWord; stdcall;
		{
			offset
				DIOwrite_outport(),       DIOread_outport()			: 0부터 총출력점수-1까지 사용 가능
				DIOwrite_outport_bit(),   DIOread_outport_bit()		: SIO-DI32:사용불가, SIO-DB32:0..15, SIO-DO32:0..31
				DIOwrite_outport_byte(),  DIOread_outport_byte()	: SIO-DI32:사용불가, SIO-DB32:0..1,  SIO-DO32:0..3
				DIOwrite_outport_word(),  DIOread_outport_word()	: SIO-DI32:사용불가, SIO-DB32:0,     SIO-DO32:0..1
				DIOwrite_outport_dword(), DIOread_outport_dword()	: SIO-DI32:사용불가, SIO-DB32:0,     SIO-DO32:0
			리턴값
				DIOread_outport()		: 0(OFF), 1(ON)
				DIOread_outport_bit()	: 0(OFF), 1(ON)
				DIOread_outport_byte()	: 00h .. FFh
				DIOread_outport_word()	: 0000h .. FFFFh
				DIOread_outport_dword()	: 00000000h .. FFFFFFFFh
		}

/// Input port 함수군 - 읽기 전용 포트
// 입력(Input) 포트로부터 1비트의 데이터를 읽어들인다. 점수 단위
function DIOread_inport (offset : Word) : Boolean; stdcall;
// 입력(Input) 포트로부터 1비트의 데이터를 읽어들인다. 지정한 모듈의 점수 단위
function DIOread_inport_bit (nModuleNo : SmallInt; offset : Word) : Boolean; stdcall;
// 입력(Input) 포트로부터 1바이트의 데이터를 읽어들인다. 지정한 모듈의 바이트 단위
function DIOread_inport_byte (nModuleNo : SmallInt; offset : Word) : Byte; stdcall;
// 입력(Input) 포트로부터 2바이트의 데이터를 읽어들인다. 지정한 모듈의 워드 단위
function DIOread_inport_word (nModuleNo : SmallInt; offset : Word) : Word; stdcall;
// 입력(Input) 포트로부터 4바이트의 데이터를 읽어들인다. 지정한 모듈의 더블워드 단위
function DIOread_inport_dword (nModuleNo : SmallInt; offset : Word) : DWord; stdcall;
		{
			offset
				DIOread_inport()		: 0부터 총입력점수-1까지 사용 가능
				DIOread_inport_bit()	: SIO-DI32:0..31, SIO-DB32:0..15, SIO-DO32:사용불가
				DIOread_inport_byte()	: SIO-DI32:0..3,  SIO-DB32:0..1,  SIO-DO32:사용불가
				DIOread_inport_word()	: SIO-DI32:0..1,  SIO-DB32:0,     SIO-DO32:사용불가
				DIOread_inport_dword()	: SIO-DI32:0,     SIO-DB32:0,     SIO-DO32:사용불가
			리턴값
				DIOread_inport()		: 0(OFF), 1(ON)
				DIOread_inport_bit()	: 0(OFF), 1(ON)
				DIOread_inport_byte()	: 00h .. FFh
				DIOread_inport_word()	: 0000h .. FFFFh
				DIOread_inport_dword()	: 00000000h .. FFFFFFFFh
		}

/// Interrupt Up-edge port(Register) 함수군
// 상승에지(Upedge) 포트로에 1비트의 데이터를 써넣는다. 점수 단위
procedure DIOwrite_upedge (offset : Word; bValue : Boolean); stdcall;
// 상승에지(Upedge) 포트로에 1비트의 데이터를 써넣는다. 지정한 모듈의 점수 단위
procedure DIOwrite_upedge_bit (nModuleNo : SmallInt; offset : Word; bValue : Boolean); stdcall;
// 상승에지(Upedge) 포트로에 1바이트의 데이터를 써넣는다. 지정한 모듈의 바이트 단위
procedure DIOwrite_upedge_byte (nModuleNo : SmallInt; offset : Word; byValue : Byte); stdcall;
// 상승에지(Upedge) 포트로에 2바이트의 데이터를 써넣는다. 지정한 모듈의 워드 단위
procedure DIOwrite_upedge_word (nModuleNo : SmallInt; offset : Word; wValue : Word); stdcall;
// 상승에지(Upedge) 포트로에 4바이트의 데이터를 써넣는다. 지정한 모듈의 더블워드 단위
procedure DIOwrite_upedge_dword (nModuleNo : SmallInt; offset : Word; lValue : DWord); stdcall;
// 상승에지(Upedge) 포트로부터 1비트의 데이터를 읽어들인다, 점수 단위
function DIOread_upedge (offset : Word) : Boolean; stdcall;
// 상승에지(Upedge) 포트로부터 1비트의 데이터를 읽어들인다. 지정한 모듈의 점수 단위
function DIOread_upedge_bit (nModuleNo : SmallInt; offset : Word) : Boolean; stdcall;
// 상승에지(Upedge) 포트로부터 1바이트의 데이터를 읽어들인다, 지정한 모듈의 바이트 단위
function DIOread_upedge_byte (nModuleNo : SmallInt; offset : Word) : Byte; stdcall;
// 상승에지(Upedge) 포트로부터 2바이트의 데이터를 읽어들인다, 지정한 모듈의 워드 단위
function DIOread_upedge_word (nModuleNo : SmallInt; offset : Word) : Word; stdcall;
// 상승에지(Upedge) 포트로부터 4바이트의 데이터를 읽어들인다, 지정한 모듈의 더블워드 단위
function DIOread_upedge_dword (nModuleNo : SmallInt; offset : Word) : DWord; stdcall;
		{
			offset
				DIOwrite_upedge(),       DIOread_upedge()		: 0부터 총입력점수-1까지 사용 가능
				DIOwrite_upedge_bit(),   DIOread_upedge_bit()	: SIO-DI32:0..31, SIO-DB32:0..15, SIO-DO32:사용불가
				DIOwrite_upedge_byte(),  DIOread_upedge_byte()	: SIO-DI32:0..3,  SIO-DB32:0..1,  SIO-DO32:사용불가
				DIOwrite_upedge_word(),  DIOread_upedge_word()	: SIO-DI32:0..1,  SIO-DB32:0,     SIO-DO32:사용불가
				DIOwrite_upedge_dword(), DIOread_upedge_dword()	: SIO-DI32:0,     SIO-DB32:0,     SIO-DO32:사용불가
			리턴값
				DIOread_upedge()		: 0(OFF), 1(ON)
				DIOread_upedge_bit()	: 0(OFF), 1(ON)
				DIOread_upedge_byte()	: 00h .. FFh
				DIOread_upedge_word()	: 0000h .. FFFFh
				DIOread_upedge_dword()	: 00000000h .. FFFFFFFFh
		}

/// Interrupt Down-edge port(Register) 함수군
// 하강에지(Downedge) 포트로에 1비트의 데이터를 써넣는다. 점수 단위
procedure DIOwrite_downedge (offset : Word; bValue : Boolean); stdcall;
// 하강에지(Downedge) 포트로에 1비트의 데이터를 써넣는다. 지정한 모듈의 점수 단위
procedure DIOwrite_downedge_bit (nModuleNo : SmallInt; offset : Word; bValue : Boolean); stdcall;
// 하강에지(Downedge) 포트로에 1바이트의 데이터를 써넣는다. 지정한 모듈의 바이트 단위
procedure DIOwrite_downedge_byte (nModuleNo : SmallInt; offset : Word; byValue : Byte); stdcall;
// 하강에지(Downedge) 포트로에 2바이트의 데이터를 써넣는다. 지정한 모듈의 워드 단위
procedure DIOwrite_downedge_word (nModuleNo : SmallInt; offset : Word; wValue : Word); stdcall;
// 하강에지(Downedge) 포트로에 4바이트의 데이터를 써넣는다. 지정한 모듈의 더블워드 단위
procedure DIOwrite_downedge_dword (nModuleNo : SmallInt; offset : Word; lValue : DWord); stdcall;
// 하강에지(Downedge) 포트로부터 1비트의 데이터를 읽어들인다, 점수 단위
function DIOread_downedge (offset : Word) : Boolean; stdcall;
// 하강에지(Downedge) 포트로부터 1비트의 데이터를 읽어들인다. 지정한 모듈의 점수 단위
function DIOread_downedge_bit (nModuleNo : SmallInt; offset : Word) : Boolean; stdcall;
// 하강에지(Downedge) 포트로부터 1바이트의 데이터를 읽어들인다, 지정한 모듈의 바이트 단위
function DIOread_downedge_byte (nModuleNo : SmallInt; offset : Word) : Byte; stdcall;
// 하강에지(Downedge) 포트로부터 2바이트의 데이터를 읽어들인다, 지정한 모듈의 워드 단위
function DIOread_downedge_word (nModuleNo : SmallInt; offset : Word) : Word; stdcall;
// 하강에지(Downedge) 포트로부터 4바이트의 데이터를 읽어들인다, 지정한 모듈의 더블워드 단위
function DIOread_downedge_dword (nModuleNo : SmallInt; offset : Word) : DWord; stdcall;
		{
			offset
				DIOwrite_downedge(),       DIOread_downedge()		: 0부터 총입력점수-1까지 사용 가능
				DIOwrite_downedge_bit(),   DIOread_downedge_bit()	: SIO-DI32:0..31, SIO-DB32:0..15, SIO-DO32:사용불가
				DIOwrite_downedge_byte(),  DIOread_downedge_byte()	: SIO-DI32:0..3,  SIO-DB32:0..1,  SIO-DO32:사용불가
				DIOwrite_downedge_word(),  DIOread_downedge_word()	: SIO-DI32:0..1,  SIO-DB32:0,     SIO-DO32:사용불가
				DIOwrite_downedge_dword(), DIOread_downedge_dword()	: SIO-DI32:0,     SIO-DB32:0,     SIO-DO32:사용불가
			리턴값
				DIOread_downedge()		: 0(OFF), 1(ON)
				DIOread_downedge_bit()	: 0(OFF), 1(ON)
				DIOread_downedge_byte()	: 00h .. FFh
				DIOread_downedge_word()	: 0000h .. FFFFh
				DIOread_downedge_dword(): 00000000h .. FFFFFFFFh
		}	

/// Interrupt flag port(Register) 함수군
// 인터럽트플래그(Flag) 포트로부터 1비트의 데이터를 읽어들인다, 점수 단위
function DIOread_flag (offset : Word) : Boolean; stdcall;
// 인터럽트플래그(Flag) 포트로부터 1비트의 데이터를 읽어들인다. 지정한 모듈의 점수 단위
function DIOread_flag_bit (nModuleNo : SmallInt; offset : Word) : Boolean; stdcall;
// 인터럽트플래그(Flag) 포트로부터 1바이트의 데이터를 읽어들인다, 지정한 모듈의 바이트 단위
function DIOread_flag_byte (nModuleNo : SmallInt; offset : Word) : Byte; stdcall;
// 인터럽트플래그(Flag) 포트로부터 2바이트의 데이터를 읽어들인다, 지정한 모듈의 워드 단위
function DIOread_flag_word (nModuleNo : SmallInt; offset : Word) : Word; stdcall;
// 인터럽트플래그(Flag) 포트로부터 4바이트의 데이터를 읽어들인다, 지정한 모듈의 더블워드 단위
function DIOread_flag_dword (nModuleNo : SmallInt; offset : Word) : DWord; stdcall;
		{
			offset
				DIOread_flag()		: 0부터 총입력점수-1까지 사용 가능
				DIOread_flag_bit()	: SIO-DI32:0..31, SIO-DB32:0..15, SIO-DO32:사용불가
				DIOread_flag_byte()	: SIO-DI32:0..3,  SIO-DB32:0..1,  SIO-DO32:사용불가
				DIOread_flag_word()	: SIO-DI32:0..1,  SIO-DB32:0,     SIO-DO32:사용불가
				DIOread_flag_dword(): SIO-DI32:0,     SIO-DB32:0,     SIO-DO32:사용불가
			리턴값
				DIOread_flag()		: 0(OFF), 1(ON)
				DIOread_flag_bit()	: 0(OFF), 1(ON)
				DIOread_flag_byte()	: 00h .. FFh
				DIOread_flag_word()	: 0000h .. FFFFh
				DIOread_flag_dword(): 00000000h .. FFFFFFFFh
		}

{----------------------- 공통적으로 사용하는 인자(Parameter) ------------------------------------*
	nBoardNo	: 베이스보드번호, 검출된 순서대로 0부터 할당된다
	nModuleNo	: DIO모듈 번호, DIO모듈의 종류에 관계없이 검출된 순서대로 0부터 할당된다
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