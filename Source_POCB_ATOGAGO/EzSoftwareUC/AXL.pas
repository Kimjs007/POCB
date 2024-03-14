//****************************************************************************
//****************************************************************************
//**
//** File Name
//** ---------
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

uses Windows, Messages, AXHS;
//========== Library initialization =================================================================================

// Library initialization
function AxlOpen (lIrqNo : LongInt) : DWord; stdcall;
// Do not do the lises at a library initialization hardware chip.
function AxlOpenNoReset (lIrqNo : LongInt) : DWord; stdcall;
// Exit from library use
function AxlClose () : Boolean; stdcall;
// Verify if the library is initialized
function AxlIsOpened () : Boolean; stdcall;

// Use Interrupt
function AxlInterruptEnable () : DWord; stdcall;
// Not use Interrput
function AxlInterruptDisable () : DWord; stdcall;

//========== library and base board information =================================================================================

// Verify the number of registered base board
function AxlGetBoardCount (lpBoardCount : PLongInt) : DWord; stdcall;
// Verify the library version
function AxlGetLibVersion (szVersion : PChar) : DWord; stdcall;
// Verify Network models Module Status
function AxlGetModuleNodeStatus(lBoardNo : LongInt; lModulePos : LongInt) : DWord; stdcall;
// Verify Board Status
function AxlGetBoardStatus(lBoardNo : LongInt) : DWord; stdcall;
// return Configuration Lock status of Network product.
// *wpLockMode  : DISABLE(0), ENABLE(1)
function AxlGetLockMode(lBoardNo : LongInt; wpLockMode : PWord) : DWord; stdcall;

//========== Log level =================================================================================
// Set message level to be output to EzSpy
// uLevel : 0 - 3 Set
// LEVEL_NONE(0)    : ALL Message don't Output
// LEVEL_ERROR(1)   : Error Message Output
// LEVEL_RUNSTOP(2) : Run/Stop relative Message Output during Motion.
// LEVEL_FUNCTION(3): ALL Message don't Output
function AxlSetLogLevel (uLevel : DWord) : DWord; stdcall;
// Verify message level to be output to EzSpy
function AxlGetLogLevel (upLevel : PDWord) : DWord; stdcall;

//========== MLIII =================================================================================
function AxlScanStart(lBoardNo : LongInt; lNet : LongInt) : DWord; stdcall;
function AxlBoardConnect(lBoardNo : LongInt; lNet : LongInt) : DWord; stdcall;
function AxlBoardDisconnect(lBoardNo : LongInt; lNet : LongInt) : DWord; stdcall;


implementation

const

    dll_name    = 'AXL.dll';

    function AxlOpen; external dll_name name 'AxlOpen';
    function AxlOpenNoReset; external dll_name name 'AxlOpenNoReset';
    function AxlClose; external dll_name name 'AxlClose';
    function AxlIsOpened; external dll_name name 'AxlIsOpened';
    function AxlInterruptEnable; external dll_name name 'AxlInterruptEnable';
    function AxlInterruptDisable; external dll_name name 'AxlInterruptDisable';
    function AxlGetBoardCount; external dll_name name 'AxlGetBoardCount';
    function AxlGetLibVersion; external dll_name name 'AxlGetLibVersion';
    function AxlGetModuleNodeStatus; external dll_name name 'AxlGetModuleNodeStatus';
    function AxlGetBoardStatus; external dll_name name 'AxlGetBoardStatus';
    function AxlGetLockMode; external dll_name name 'AxlGetLockMode';
    function AxlSetLogLevel; external dll_name name 'AxlSetLogLevel';
    function AxlGetLogLevel; external dll_name name 'AxlGetLogLevel';
    function AxlScanStart; external dll_name name 'AxlScanStart';
    function AxlBoardConnect; external dll_name name 'AxlBoardConnect';
    function AxlBoardDisconnect; external dll_name name 'AxlBoardDisconnect';
end.
