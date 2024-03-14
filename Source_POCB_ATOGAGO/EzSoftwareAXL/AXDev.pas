

unit AXDev;

interface

uses Windows, Messages, AXHD;

// Board Number를 이용하여 Board Address 찾기
function AxlGetBoardAddreas (lBoardNo : LongInt; upBoardAddress : PDWord) : DWord; stdcall;
// Board Number를 이용하여 Board ID 찾기
function AxlGetBoardID (lBoardNo : LongInt; upBoardID : PDWord) : DWord; stdcall;
// Board Number를 이용하여 Board Version 찾기
function AxlGetBoardVersion (lBoardNo : LongInt; upBoardVersion : PDWord) : DWord; stdcall;
// Board Number와 Module Position을 이용하여 Module ID 찾기
function AxlGetModuleID (lBoardNo : LongInt; lModulePos : LongInt; upModuleID : PDWord) : DWord; stdcall;
// Board Number와 Module Position을 이용하여 Module Version 찾기
function AxlGetModuleVersion (lBoardNo : LongInt; lModulePos : LongInt; upModuleVersion : PDWord) : DWord; stdcall;
// Board Number와 Module Position을 이용하여 AIO Module Number 찾기
function AxaGetModuleNo (lBoardNo : LongInt; lModulePos : LongInt; lpModuleNo : PLongInt) : DWord; stdcall;
// Board Number와 Module Position을 이용하여 DIO Module Number 찾기
function AxdGetModuleNo (lBoardNo : LongInt; lModulePos : LongInt; lpModuleNo : PLongInt) : DWord; stdcall;

// 지정 축에 IPCOMMAND Setting
function AxmSetCommand (lAxisNo : LongInt; sCommand : Byte) : DWord; stdcall;
// 지정 축에 8bit IPCOMMAND Setting
function AxmSetCommandData08 (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// 지정 축에 8bit IPCOMMAND 가져오기
function AxmGetCommandData08 (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 지정 축에 16bit IPCOMMAND Setting
function AxmSetCommandData16 (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// 지정 축에 16bit IPCOMMAND 가져오기
function AxmGetCommandData16 (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 지정 축에 24bit IPCOMMAND Setting
function AxmSetCommandData24 (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// 지정 축에 24bit IPCOMMAND 가져오기
function AxmGetCommandData24 (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 지정 축에 32bit IPCOMMAND Setting
function AxmSetCommandData32 (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// 지정 축에 32bit IPCOMMAND 가져오기
function AxmGetCommandData32 (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;

// 지정 축에 QICOMMAND Setting
function AxmSetCommandQi (lAxisNo : LongInt; sCommand : Byte) : DWord; stdcall;
// 지정 축에 8bit IPCOMMAND Setting
function AxmSetCommandData08Qi (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// 지정 축에 8bit IPCOMMAND 가져오기
function AxmGetCommandData08Qi (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 지정 축에 16bit IPCOMMAND Setting
function AxmSetCommandData16Qi (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// 지정 축에 16bit IPCOMMAND 가져오기
function AxmGetCommandData16Qi (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 지정 축에 24bit IPCOMMAND Setting
function AxmSetCommandData24Qi (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// 지정 축에 24bit IPCOMMAND 가져오기
function AxmGetCommandData24Qi (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 지정 축에 32bit IPCOMMAND Setting
function AxmSetCommandData32Qi (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// 지정 축에 32bit IPCOMMAND 가져오기
function AxmGetCommandData32Qi (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;

// 지정 축에 Port Data 가져오기 - IP
function AxmGetPortData(lAxisNo : LongInt; wOffset : WORD; upData : PDWord) : DWord; stdcall;
// 지정 축에 Port Data Setting - IP
function AxmSetPortData(lAxisNo : LongInt; wOffset : WORD; uData : DWord) : DWord; stdcall;

// 지정 축에 Port Data 가져오기 - QI
function AxmGetPortDataQi(lAxisNo : LongInt; WwOffset : WORD; upData : PDWord) : DWord; stdcall;
// 지정 축에 Port Data Setting - QI
function AxmSetPortDataQi(lAxisNo : LongInt; wOffset : WORD; uData : DWord) : DWord; stdcall;
implementation

const

	dll_name	= 'AXL.dll';

	function AxlGetBoardAddreas; external dll_name name 'AxlGetBoardAddreas';
	function AxlGetBoardID; external dll_name name 'AxlGetBoardID';
	function AxlGetBoardVersion; external dll_name name 'AxlGetBoardVersion';
	function AxlGetModuleID; external dll_name name 'AxlGetModuleID';
	function AxlGetModuleVersion; external dll_name name 'AxlGetModuleVersion';

	function AxaGetModuleNo; external dll_name name 'AxaGetModuleNo';

	function AxdGetModuleNo; external dll_name name 'AxdGetModuleNo';

	function AxmSetCommand; external dll_name name 'AxmSetCommand';
	function AxmSetCommandData08; external dll_name name 'AxmSetCommandData08';
	function AxmGetCommandData08; external dll_name name 'AxmGetCommandData08';
	function AxmSetCommandData16; external dll_name name 'AxmSetCommandData16';
	function AxmGetCommandData16; external dll_name name 'AxmGetCommandData16';
	function AxmSetCommandData24; external dll_name name 'AxmSetCommandData24';
	function AxmGetCommandData24; external dll_name name 'AxmGetCommandData24';
	function AxmSetCommandData32; external dll_name name 'AxmSetCommandData32';
	function AxmGetCommandData32; external dll_name name 'AxmGetCommandData32';

	function AxmSetCommandQi; external dll_name name 'AxmSetCommandQi';
	function AxmSetCommandData08Qi; external dll_name name 'AxmSetCommandData08Qi';
	function AxmGetCommandData08Qi; external dll_name name 'AxmGetCommandData08Qi';
	function AxmSetCommandData16Qi; external dll_name name 'AxmSetCommandData16Qi';
	function AxmGetCommandData16Qi; external dll_name name 'AxmGetCommandData16Qi';
	function AxmSetCommandData24Qi; external dll_name name 'AxmSetCommandData24Qi';
	function AxmGetCommandData24Qi; external dll_name name 'AxmGetCommandData24Qi';
	function AxmSetCommandData32Qi; external dll_name name 'AxmSetCommandData32Qi';
	function AxmGetCommandData32Qi; external dll_name name 'AxmGetCommandData32Qi';
	
	function AxmGetPortData; external dll_name name 'AxmGetPortData';
	function AxmSetPortData; external dll_name name 'AxmSetPortData';
	function AxmGetPortDataQi; external dll_name name 'AxmGetPortDataQi';
	function AxmSetPortDataQi; external dll_name name 'AxmSetPortDataQi';
	
	
end.
