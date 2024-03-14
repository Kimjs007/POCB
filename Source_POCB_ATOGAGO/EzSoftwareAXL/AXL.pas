//****************************************************************************
//****************************************************************************
//**
//** File Name
//** ----------
//**
//** AXL.PAS
//**
//** COPYRIGHT (c) AJINEXTEK Co., LTD
//**
//*****************************************************************************
//*****************************************************************************
//**
//** Description
//** -----------
//** Ajinextek Library Header File
//** 
//**
//*****************************************************************************
//*****************************************************************************
//**
//** Source Change Indices
//** ---------------------
//** 
//** (None)
//**
//**
//*****************************************************************************
//*****************************************************************************
//**
//** Website
//** ---------------------
//**
//** http://www.ajinextek.com
//**
//*****************************************************************************
//*****************************************************************************

unit AXL;

interface

uses Windows, Messages, AXHS, AXA, AXD, AXM;
//========== 라이브러리 초기화 =================================================================================

// 라이브러리 초기화
function AxlOpen (lIrqNo : LongInt) : DWord; stdcall;
// 라이브러리 초기화시 하드웨어 칩에 리셋을 하지 않음.
function AxlOpenNoReset (lIrqNo : LongInt) : DWord; stdcall;
// 라이브러리 사용을 종료
function AxlClose () : Boolean; stdcall;
// 라이브러리가 초기화 되어 있는 지 확인
function AxlIsOpened () : Boolean; stdcall;

// 인터럽트를 사용한다.
function AxlInterruptEnable () : DWord; stdcall;
// 인터럽트를 사용안한다.
function AxlInterruptDisable () : DWord; stdcall;

//========== 라이브러리 및 베이스 보드 정보 =================================================================================

// 등록된 베이스 보드의 개수 확인
function AxlGetBoardCount (lpBoardCount : PLongInt) : DWord; stdcall;
// 라이브러리 버전 확인
function AxlGetLibVersion (szVersion : PChar) : DWord; stdcall;

//========== 로그 레벨 =================================================================================

// EzSpy에 출력할 메시지 레벨 설정
// uLevel : 0 - 3 설정
// LEVEL_NONE(0)    : 모든 메시지를 출력하지 않는다.
// LEVEL_ERROR(1)   : 에러가 발생한 메시지만 출력한다.
// LEVEL_RUNSTOP(2) : 모션에서 Run / Stop 관련 메시지를 출력한다.
// LEVEL_FUNCTION(3): 모든 메시지를 출력한다.
function AxlSetLogLevel (uLevel : DWord) : DWord; stdcall;
// EzSpy에 출력할 메시지 레벨 확인
function AxlGetLogLevel (upLevel : PDWord) : DWord; stdcall;

implementation

const

	dll_name	= 'AXL.dll';

	function AxlOpen; external dll_name name 'AxlOpen';
	function AxlOpenNoReset; external dll_name name 'AxlOpenNoReset';
	function AxlClose; external dll_name name 'AxlClose';
	function AxlIsOpened; external dll_name name 'AxlIsOpened';

	function AxlInterruptEnable; external dll_name name 'AxlInterruptEnable';
	function AxlInterruptDisable; external dll_name name 'AxlInterruptDisable';

	function AxlGetBoardCount; external dll_name name 'AxlGetBoardCount';
	function AxlGetLibVersion; external dll_name name 'AxlGetLibVersion';

	function AxlSetLogLevel; external dll_name name 'AxlSetLogLevel';
	function AxlGetLogLevel; external dll_name name 'AxlGetLogLevel';
end.
