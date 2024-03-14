unit AxtLIBDef;

interface

uses Windows, Messages, SysUtils;

	type AXT_CAMC5M_INTERRUPT_PROC = procedure(nBoardNo : SmallInt; nModulePos : SmallInt; byFlag : Byte); stdcall;
	type AXT_CAMCFS_INTERRUPT_PROC = procedure(nBoardNo : SmallInt; nModulePos : SmallInt; byFlag : Byte); stdcall;
	type AXT_MCX312_INTERRUPT_PROC = procedure(nBoardNo : SmallInt; nModulePos : SmallInt; wFlag : Word); stdcall;
	type AXT_MCX314_INTERRUPT_PROC = procedure(nBoardNo : SmallInt; nModulePos : SmallInt; wFlag : Word); stdcall;
	type AXT_COMM_INTERRUPT_PROC = procedure(nChannelNo : SmallInt); stdcall;
	type AXT_DIO_INTERRUPT_PROC = procedure(nBoardNo : SmallInt; nModulePos : SmallInt; wFlag : Word); stdcall;
	type AXT_AIO_INTERRUPT_PROC = procedure(nChannelNo : SmallInt; nStatus : SmallInt); stdcall;
	type AXT_CAMCIP_INTERRUPT_PROC = procedure(nBoardNo : SmallInt; nModulePos : SmallInt; wFlag : Word); stdcall;


//	Console application 프로그램을 위해서 아래 부분을 정의함

//typedef int							BOOL;			// 0(FALSE), 1(TRUE)

// Bus type
const

	BUSTYPE_UNKNOWN								= -1;						// Unknown
	BUSTYPE_ISA									= 0;						// ISA(Industrial Standard Architecture)
	BUSTYPE_PCI									= 1;						// PCI
	BUSTYPE_VME									= 2;						// VME
	BUSTYPE_CPCI								= 3;						// Compact PCI
	BUSTYPE_MIN									= BUSTYPE_ISA;				// 0
	BUSTYPE_MAX									= BUSTYPE_CPCI;				// 3
	BUSTYPE_NUM									= 4;						// 4

// 베이스 보드 정의
	AXT_UNKNOWN									= $00;						// Unknown Baseboard
	AXT_BIHR									= $01;						// ISA bus, Half size
	AXT_BIFR									= $02;						// ISA bus, Full size
	AXT_BPHR									= $03;						// PCI bus, Half size
	AXT_BPFR									= $04;						// PCI bus, Full size
	AXT_BV3R									= $05;						// VME bus, 3U size
	AXT_BV6R									= $06;						// VME bus, 6U size
	AXT_BC3R									= $07;						// cPCI bus, 3U size
	AXT_BC6R									= $08;						// cPCI bus, 6U size
	AXT_FMNSH4D									= $52;						// ISA bus, Full size, DB-32T, SIO-2V03 * 2
	AXT_PCI_DI64R								= $43;						// PCI bus, Digital IN 64점
	AXT_PCI_DO64R								= $53;						// PCI bus, Digital OUT 64점
	AXT_PCI_DB64R								= $63;						// PCI bus, Digital IN 32점, OUT 32점
	AXT_BPHD									= $83;						// PCI bus, Half size, DB-32T

// 모듈 정의
	AXT_SMC_2V01								= $01;						// CAMC-5M, 2 Axis
	AXT_SMC_2V02								= $02;						// CAMC-FS, 2 Axis
	AXT_SMC_1V01								= $03;						// CAMC-5M, 1 Axis
	AXT_SMC_1V02								= $04;						// CAMC-FS, 1 Axis
	AXT_SMC_2V03								= $05;						// CAMC-IP, 2 Axis
	AXT_SMC_4V51								= $33;						// MCX314,  4 Axis
	AXT_SMC_2V53								= $35;						// PMD, 2 Axis
	AXT_SMC_2V54								= $36;						// MCX312,  2 Axis
	AXT_SIO_DI32								= $97;						// Digital IN  32점
	AXT_SIO_DO32P								= $98;						// Digital OUT 32점
	AXT_SIO_DB32P								= $99;						// Digital IN 16점 / OUT 16점
	AXT_SIO_DO32T								= $9E;						// Digital OUT 16점, Power TR 출력
	AXT_SIO_DB32T								= $9F;						// Digital IN 16점 / OUT 16점, Power TR 출력
	AXT_SIO_AI4R								= $A1;						// A1h(161) : AI 4Ch, 12 bit
	AXT_SIO_AO4R								= $A2;						// A2h(162) : AO 4Ch, 12 bit
	AXT_SIO_AI16H								= $A3;						// A3h(163) : AI 4Ch, 16 bit
	AXT_SIO_AO8H								= $A4;						// A4h(164) : AO 4Ch, 16 bit
	AXT_COM_234R								= $D3;						// COM-234R
	AXT_COM_484R								= $D4;						// COM-484R

// Module header info.
	REG_PREAMBLE								= $00;						// Preamble		: B6h
	REG_ID										= $02;						// Module ID	: 97h, 98h, 99h
	REG_VERSION									= $04;						// Version		: 0.0
	REG_SOFTWARE_RESET							= $06;						// bit 0 : 1(hi)로 Write시 Software reset

// -------------------------------------------------------------------------------------
	AXT_MODULE									= 5;						// 베이스보드의 모듈 갯수 
	MAX_AXT_BOARD								= 21;						// 장착할 수 있는 보드의 갯수
	MAX_AXT_MODULE								= (MAX_AXT_BOARD*5);		// 장착할 수 있는 모듈의 갯수 
	MAX_AXIS									= (MAX_AXT_MODULE*2);		// 최대 모션 축의 갯수

	DIO_MODULE_ALL								= 0;						//$$
	AIO_MODULE_ALL								= 0;						//$$

// Sync 및 Trigger 관련 Register
	AXT_SYNC_OFFSET								= $1800;
	AXT_BASE_EEPROM								= $1802;					// <+> 2002/03/07
	AXT_INTR_MASK								= $1804;
	AXT_INTR_FLAG								= $1806;

// 모듈의 어드레스 - 오프셋
	SUBMODULE0									= $0000;					// Module 0 offset
	SUBMODULE1									= $0400;					// Module 1 offset
	SUBMODULE2									= $0800;					// Module 2 offset
	SUBMODULE3									= $0C00;					// Module 3 offset
	SUBMODULE4									= $1000;					// Module 4 offset

//#define MODULE_NUM						4					// 베이스보드의 모듈 갯수

// 로그 레벨
	LEVEL_NONE									= 0;
	LEVEL_ERROR									= 1;
	LEVEL_RUNSTOP								= 2;
	LEVEL_FUNCTION								= 3;


	AJIN_PREAMBLE								= $B6;						// Preamble : B6h

	WM_USER										= $0400;

// CAMC-5M Module
	WM_CAMC5M_INTERRUPT							= (WM_USER + 2001);
//Example : void C5MInterruptProc(INT16 nBoardNo, INT16 nModulePos, UINT8 byFlag);

// CAMC-FS Module
	WM_CAMCFS_INTERRUPT							= (WM_USER + 2002);
//Example : void CFSInterruptProc(INT16 nBoardNo, INT16 nModulePos, UINT8 byFlag);

// MCX-312 Module
	WM_MCX312_INTERRUPT							= (WM_USER + 2003);
//Example : void M312InterruptProc(INT16 nBoardNo, INT16 nModulePos, UINT16 wFlag);

// MCX-314 Module
	WM_MCX314_INTERRUPT							= (WM_USER + 2004);
//Example : void M314InterruptProc(INT16 nBoardNo, INT16 nModulePos, UINT32 dwFlag);

{ Undefine
// PMD Module
#define WM_PMD_INTERRUPT				(WM_USER + 2005)
typedef void (*AXT_PMD_INTERRUPT_PROC)(INT16 nBoardNo, INT16 nModulePos, UINT32 dwFlag);
//Example : void PmdInterruptProc(INT16 nChannelNo);
}

// Comm Module
	WM_COMM_INTERRUPT							= (WM_USER + 2006);
//Example : void CommInterruptProc(INT16 nChannelNo);

// DIO Module
	WM_DIO_INTERRUPT							= (WM_USER + 2007);
//Example : void DioInterruptProc(INT16 nBoardNo, INT16 nModulePos, UINT32 dwFlag);

// AIO Module
	WM_AIO_INTERRUPT							= (WM_USER + 2008);
//Example : void AioInterruptProc(INT16 nChannelNo, INT16 nStatus);

// CAMC-IP Module
	WM_CAMCIP_INTERRUPT							= (WM_USER + 2009);
//Example : void CIPInterruptProc(INT16 nBoardNo, INT16 nModulePos, UINT8 byFlag);

{ Type 설정	}

//#ifndef BOOL
//#define BOOL    int						//INT16
//#endif

	LOW											= 0;
	HIGH										= 1;

	DISABLE										= 0;
	ENABLE										= 1;



implementation

function FltToInt(Value: Real) : Integer;
var
	Temp: string;
	I: Integer;
begin
	Temp := FloatToStr(Value);
	for I := 0 to Length(Temp)-1 do
	begin
		if Temp[I] = '.' then Break;
	end;
	Delete(Temp, Pos('.', Temp), Length(Temp) - I + 1);
	Result := StrToInt(Temp);
end;

//////////////////////////////
// VALUE가 MIN과 MAX 사이의 값인가 ?
{$IFNDEF InBound}
function InBound(MIN : LongInt; MAX : LongInt; VALUE : LongInt) : boolean;
begin
	if ((MIN <= VALUE) and (VALUE <= MAX)) then
		result := TRUE
	else
		result := FALSE;
end;
{$ENDIF}

//////////////////////////////
// VALUE가 MIN보다 작은 값이면 MIN, MAX보다 큰 값이면 MAX, MIN과 MAX사이의 값이면 VALUE를 리턴
{$IFNDEF Bound}
function Bound(MIN : LongInt; MAX : LongInt; VALUE : LongInt) : LongInt;
begin
	if (MIN > VALUE) then
		result := MIN
	else
	if (MAX < VALUE) then
		result := MAX
	else
		result := VALUE;
end;
{$ENDIF}

//////////////////////////////
{$IFNDEF round}
function round(x : Single) : LongInt;
begin
	if (x >= 0) then
		result := FltToInt(x + 0.5)
	else
		result := FltToInt(x - 0.5);
end;
{$ENDIF}

end.