//*****************************************************************************
//*****************************************************************************
//**
//** File Name
//** ---------
//**
//** AXD.PAS
//**
//** COPYRIGHT (c) AJINEXTEK Co., LTD
//**
//*****************************************************************************
//*****************************************************************************
//**
//** Description
//** -----------
//** Ajinextek Digital Library Header File
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

unit AXD;

interface
uses Windows, Messages, AXHS;

//========== Board and module information ======================================
// Verify if DIO module exists
function AxdInfoIsDIOModule (upStatus : PDWord) : DWord; stdcall;

// Verify DIO in/output module number
function AxdInfoGetModuleNo (lBoardNo : LongInt; lModulePos : LongInt; lpModuleNo : PLongInt) : DWord; stdcall;

// Verify the number of DIO in/output module
function AxdInfoGetModuleCount (lpModuleCount : PLongInt) : DWord; stdcall;

// Verify the number of input contacts of specified module
function AxdInfoGetInputCount (lModuleNo : LongInt; lpCount : PLongInt) : DWord; stdcall;

// Verify the number of output contacts of specified module
function AxdInfoGetOutputCount (lModuleNo : LongInt; lpCount : PLongInt) : DWord; stdcall;

// Verify the base board number, module position and module ID with specified module number
function AxdInfoGetModule (lModuleNo : LongInt; lpBoardNo : PLongInt; lpModulePos : PLongInt; upModuleID : PDWord) : DWord; stdcall;

function AxdInfoGetModuleStatus(lModuleNo : LongInt) : DWord; stdcall;

//========== Verification group for input interrupt setting ==================== 
// Use window message, callback API or event method in order to get interrupt message into specified module
function AxdiInterruptSetModule (lModuleNo : LongInt; hWnd : HWND; uMessage : DWord; pProc : AXT_INTERRUPT_PROC; pEvent : PDWord) : DWord; stdcall;

// Set whether to use interrupt of specified module
//======================================================
// uUse   : DISABLE(0)   // Interrupt Disable
//        : ENABLE(1)    // Interrupt Enable
//======================================================
function AxdiInterruptSetModuleEnable (lModuleNo : LongInt; uUse : DWord) : DWord; stdcall;

// Verify whether to use interrupt of specified module
//======================================================
// *upUse : DISABLE(0)   // Interrupt Disable
//        : ENABLE(1)    // Interrupt Enable
//======================================================
function AxdiInterruptGetModuleEnable (lModuleNo : LongInt; upUse : PDWord) : DWord; stdcall;

// Verify the position interrupt occurred
function AxdiInterruptRead (lpModuleNo : PLongInt; upFlag : PDWord) : DWord; stdcall;

//========== Input interrupt rising / Verification group for setting of interrupt occurrence in falling edge

// Set the rising or falling edge value by bit unit in specified input contact module and Offset position of Interrupt Rising / Falling Edge register
//======================================================
// uMode  : DOWN_EDGE(0)
//        : UP_EDGE(1)
// uValue : DISABLE(0)
//        : ENABLE(1)
//======================================================
function AxdiInterruptEdgeSetBit (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; uValue : DWord) : DWord; stdcall;

// Set the rising or falling edge value by byte unit in specified input contact module and Offset position of Interrupt Rising / Falling Edge register
//======================================================
// uMode  : DOWN_EDGE(0)
//        : UP_EDGE(1)
// uValue : 0x00 ~ 0x0FF
//======================================================
function AxdiInterruptEdgeSetByte (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; uValue : DWord) : DWord; stdcall;

// Set the rising or falling edge value by word unit in specified input contact module and Offset position of Interrupt Rising / Falling Edge register
//======================================================
// uMode  : DOWN_EDGE(0)
//        : UP_EDGE(1)
// uValue : 0x00 ~ 0x0FFFF
//======================================================
function AxdiInterruptEdgeSetWord (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; uValue : DWord) : DWord; stdcall;

// Set the rising or falling edge value by double word unit in specified input contact module and Offset position of Interrupt Rising / Falling Edge register
//======================================================
// uMode  : DOWN_EDGE(0)
//        : UP_EDGE(1)
// uValue : 0x00 ~ 0x0FFFFFFFF
//======================================================
function AxdiInterruptEdgeSetDword (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; uValue : DWord) : DWord; stdcall;

// Verify the rising or falling edge value by bit unit in specified input contact module and Offset position of Interrupt Rising / Falling Edge register
//======================================================
// uMode    : DOWN_EDGE(0)
//          : UP_EDGE(1)
// *upValue : 0x00 ~ 0x0FF
//======================================================
function AxdiInterruptEdgeGetBit (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; upValue : PDWord) : DWord; stdcall;

// Verify the rising or falling edge value by byte unit in specified input contact module and Offset position of Interrupt Rising / Falling Edge register
//======================================================
// uMode    : DOWN_EDGE(0)
//          : UP_EDGE(1)
// *upValue : 0x00 ~ 0x0FF
//======================================================
function AxdiInterruptEdgeGetByte (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; upValue : PDWord) : DWord; stdcall;

// Verify the rising or falling edge value by word unit in specified input contact module and Offset position of Interrupt Rising / Falling Edge register
//======================================================
// uMode    : DOWN_EDGE(0)
//          : UP_EDGE(1)
// *upValue : 0x00 ~ 0x0FFFFFFFF
//======================================================
function AxdiInterruptEdgeGetWord (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; upValue : PDWord) : DWord; stdcall;

// Verify the rising or falling edge value by double word unit in specified input contact module and Offset position of Interrupt Rising / Falling Edge register
//======================================================
// uMode    : DOWN_EDGE(0)
//          : UP_EDGE(1)
// *upValue : 0x00 ~ 0x0FFFFFFFF
//======================================================
function AxdiInterruptEdgeGetDword (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; upValue : PDWord) : DWord; stdcall;

// Set the rising or falling edge value by bit unit in entire input contact module and Offset position of Interrupt Rising / Falling Edge register
//======================================================
// uMode    : DOWN_EDGE(0)
//          : UP_EDGE(1)
// uValue   : DISABLE(0)
//          : ENABLE(1)
//======================================================
function AxdiInterruptEdgeSet (lOffset : LongInt; uMode : DWord; uValue : DWord) : DWord; stdcall;

// Verify the rising or falling edge value by bit unit in entire input contact module and Offset position of Interrupt Rising / Falling Edge register
//======================================================
// uMode    : DOWN_EDGE(0)
//          : UP_EDGE(1)
// *upValue : DISABLE(0)
//          : ENABLE(1)
//======================================================
function AxdiInterruptEdgeGet (lOffset : LongInt; uMode : DWord; upValue : PDWord) : DWord; stdcall;

//========== Verification group of input / output signal level setting =========
//==Verification group of input signal level setting
// Set data level by bit unit in Offset position of specified input contact module
//======================================================
// uLevel   : LOW(0)
//          : HIGH(1)
//======================================================
function AxdiLevelSetInportBit (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Set data level by byte unit in Offset position of specified input contact module
//======================================================
// uLevel   : 0x00 ~ 0x0FF
//======================================================
function AxdiLevelSetInportByte (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Set data level by word unit in Offset position of specified input contact module
//======================================================
// uLevel   : 0x00 ~ 0x0FFFF
//======================================================
function AxdiLevelSetInportWord (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Set data level by double word unit in Offset position of specified input contact module
//======================================================
// uLevel   : 0x00 ~ 0x0FFFFFFFF
//======================================================
function AxdiLevelSetInportDword (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Verify data level by bit unit in Offset position of specified input contact module
//======================================================
// *upLevel : LOW(0)
//          : HIGH(1)
//======================================================
function AxdiLevelGetInportBit (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// Verify data level by byte unit in Offset position of specified input contact module
//======================================================
// *upLevel : 0x00 ~ 0x0FF
//======================================================
function AxdiLevelGetInportByte (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// Verify data level by word unit in Offset position of specified input contact module
//======================================================
// *upLevel : 0x00 ~ 0x0FFFF
//======================================================
function AxdiLevelGetInportWord (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// Verify data level by double word unit in Offset position of specified input contact module
//======================================================
// *upLevel : 0x00 ~ 0x0FFFFFFFF
//======================================================
function AxdiLevelGetInportDword (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// Set data level by bit unit in Offset position of entire input contact module
//======================================================
// uLevel   : LOW(0)
//          : HIGH(1)
//======================================================
function AxdiLevelSetInport (lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Verify data level by bit unit in Offset position of entire input contact module
//======================================================
// *upLevel : LOW(0)
//          : HIGH(1)
//======================================================
function AxdiLevelGetInport (lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

//==Verification group of output signal level setting ==========================
// Set data level by bit unit in Offset position of specified output contact module
//======================================================
// uLevel   : LOW(0)
//          : HIGH(1)
//======================================================
function AxdoLevelSetOutportBit (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Set data level by byte unit in Offset position of specified output contact module
//======================================================
// uLevel   : 0x00 ~ 0x0FF
//======================================================
function AxdoLevelSetOutportByte (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Set data level by word unit in Offset position of specified output contact module
//======================================================
// uLevel   : 0x00 ~ 0x0FFFF
//======================================================
function AxdoLevelSetOutportWord (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Set data level by double word unit in Offset position of specified output contact module
//======================================================
// uLevel   : 0x00 ~ 0x0FFFFFFFF
//======================================================
function AxdoLevelSetOutportDword (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Verify data level by bit unit in Offset position of specified output contact module
//======================================================
// *upLevel : LOW(0)
//          : HIGH(1)
//======================================================
function AxdoLevelGetOutportBit (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// Verify data level by byte unit in Offset position of specified output contact module
//======================================================
// uLevel   : 0x00 ~ 0x0FF
//======================================================
function AxdoLevelGetOutportByte (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// Verify data level by word unit in Offset position of specified output contact module
//======================================================
// uLevel   : 0x00 ~ 0x0FFFF
//======================================================
function AxdoLevelGetOutportWord (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// Verify data level by double word unit in Offset position of specified output contact module
//======================================================
// uLevel   : 0x00 ~ 0x0FFFFFFFF
//======================================================
function AxdoLevelGetOutportDword (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// Set data level by bit unit in Offset position of entire output contact module
//======================================================
// uLevel   : LOW(0)
//          : HIGH(1)
//======================================================
function AxdoLevelSetOutport (lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Verify data level by bit unit in Offset position of entire output contact module
//======================================================
// *upLevel : LOW(0)
//          : HIGH(1)
//======================================================
function AxdoLevelGetOutport (lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

//========== Input / Output signal reading / writing ===========================
//==Output signal writing
// Output data by bit unit in Offset position of entire output contact module
//======================================================
// uLevel   : LOW(0)
//          : HIGH(1)
//======================================================
function AxdoWriteOutport (lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// Output data by bit unit in Offset position of specified output contact module
//======================================================
// uLevel   : LOW(0)
//          : HIGH(1)
//======================================================
function AxdoWriteOutportBit (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// Output data by byte unit in Offset position of specified output contact module
//======================================================
// uValue   : 0x00 ~ 0x0FF
//======================================================
function AxdoWriteOutportByte (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// Output data by word unit in Offset position of specified output contact module
//======================================================
// uValue   : 0x00 ~ 0x0FFFF
//======================================================
function AxdoWriteOutportWord (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// Output data by double word unit in Offset position of specified output contact module
//======================================================
// uValue   : 0x00 ~ 0x0FFFFFFFF
//======================================================
function AxdoWriteOutportDword (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

//==Output signal reading ======================================================
// Read data by bit unit in Offset position of entire output contact module
//======================================================
// *upLevel : LOW(0)
//          : HIGH(1)
//======================================================
function AxdoReadOutport (lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data by bit unit in Offset position of specified output contact module
//======================================================
// *upLevel : LOW(0)
//          : HIGH(1)
//======================================================
function AxdoReadOutportBit (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data by byte unit in Offset position of specified output contact module
//======================================================
// *upValue : 0x00 ~ 0x0FF
//======================================================
function AxdoReadOutportByte (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data by word unit in Offset position of specified output contact module
//======================================================
// *upValue : 0x00 ~ 0x0FFFF
//======================================================
function AxdoReadOutportWord (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data by double word unit in Offset position of specified output contact module
//======================================================
// *upValue  : 0x00 ~ 0x0FFFFFFFF
//======================================================
function AxdoReadOutportDword (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

//==Input signal reading =======================================================
// Read data level by bit unit in Offset position of entire input contact module
//======================================================
// *upValue  : LOW(0)
//           : HIGH(1)
//======================================================
function AxdiReadInport (lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data level by bit unit in Offset position of specified input contact module
//======================================================
// *upValue   : LOW(0)
//            : HIGH(1)
//======================================================
function AxdiReadInportBit (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data level by byte unit in Offset position of specified input contact module
//======================================================
// *upValue   : 0x00 ~ 0x0FF
//======================================================
function AxdiReadInportByte (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data level by wordt unit in Offset position of specified input contact module
//======================================================
// *upValue   : 0x00 ~ 0x0FFFF
//======================================================
function AxdiReadInportWord (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data level by double word unit in Offset position of specified input contact module
//======================================================
// *upValue   : 0x00 ~ 0x0FFFFFFFF
//======================================================
function AxdiReadInportDword (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

//== Only for MLII, M-Systems DIO(R7 series)
// Read data level by bit unit in Offset position of specified extended input contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by bit unit between input index.(0~15)
// *upValue    : LOW(0)
//             : HIGH(1)
//===============================================================================================//
function AxdReadExtInportBit (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data level by byte unit in Offset position of specified extended input contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : offset position by byte unit between input index.(0~1)
// *upValue    : 0x00 ~ 0x0FF
//===============================================================================================//
function AxdReadExtInportByte (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data level by word unit in Offset position of specified extended input contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : offset position by word unit between input index.(0)
// *upValue    : 0x00 ~ 0x0FFFF
//===============================================================================================//
function AxdReadExtInportWord (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data level by double word unit in Offset position of specified extended input contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : offset position by dword unit between input index.(0)
// *upValue    : 0x00 ~ 0x00000FFFF
//===============================================================================================//
function AxdReadExtInportDword (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data level by bit unit in Offset position of specified extended output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by bit unit between output index.(0~15)
// *upValue    : LOW(0)
//             : HIGH(1)
//===============================================================================================//
function AxdReadExtOutportBit (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data level by byte unit in Offset position of specified extended output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by byte unit between output index.(0~1)
// *upValue    : 0x00 ~ 0x0FF
//===============================================================================================//
function AxdReadExtOutportByte (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data level by word unit in Offset position of specified extended output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by word unit between output index.(0)
// *upValue    : 0x00 ~ 0x0FFFF
//===============================================================================================//
function AxdReadExtOutportWord (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Read data level by double word unit in Offset position of specified extended output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by dword unit between output index.(0)
// *upValue    : 0x00 ~ 0x0000FFFF
//===============================================================================================//
function AxdReadExtOutportDword (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Output data by bit unit in Offset position of specified extended output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by bit unit between output index.(0~15)
// uValue      : LOW(0)
//             : HIGH(1)
//===============================================================================================//
function AxdWriteExtOutportBit (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// Output data by byte unit in Offset position of specified extended output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by byte unit between output index.(0~1)
// uValue      : 0x00 ~ 0x0FF
//===============================================================================================//
function AxdWriteExtOutportByte (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// Output data by word unit in Offset position of specified extended output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by word unit between output index.(0~1)
// uValue      : 0x00 ~ 0x0FFFF
//===============================================================================================//
function AxdWriteExtOutportWord (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// Output data by dword unit in Offset position of specified extended output contact module
//==============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by dword unit between output index.(0)
// uValue    : 0x00 ~ 0x00000FFFF
//===============================================================================================//
function AxdWriteExtOutportDword (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// Set data level by bit unit in Offset position of specified extended input/output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by bit unit between input/output index.(0~15)
// uLevel      : LOW(0)
//             : HIGH(1)
//===============================================================================================//
function AxdLevelSetExtportBit (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Set data level by byte unit in Offset position of specified extended input/output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by byte unit between input/output index.(0~1)
// uLevel      : 0x00 ~ 0xFF
//===============================================================================================//
function AxdLevelSetExtportByte (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Set data level by word unit in Offset position of specified extended input/output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by word unit between input/output index.(0)
// uLevel      : 0x00 ~ 0xFFFF
//===============================================================================================//
function AxdLevelSetExtportWord (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Set data level by dword unit in Offset position of specified extended input/output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by dword unit between input/output index.(0)
// uLevel      : 0x00 ~ 0x0000FFFF
//===============================================================================================//
function AxdLevelSetExtportDword (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// Verify data level by bit unit in Offset position of specified extended input/output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by bit unit between input/output index.(0~15)
// uLevel      : LOW(0)
//             : HIGH(1)
//===============================================================================================//
function AxdLevelGetExtportBit (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;                              

// Verify data level by byte unit in Offset position of specified extended input/output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by byte unit between input/output index.(0~1)
// uLevel      : 0x00 ~ 0xFF
//===============================================================================================//
function AxdLevelGetExtportByte (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// Verify data level by word unit in Offset position of specified extended input/output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by word unit between input/output index.(0)
// uLevel      : 0x00 ~ 0xFFFF
//===============================================================================================//
function AxdLevelGetExtportWord (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// Verify data level by dword unit in Offset position of specified extended input/output contact module
//===============================================================================================//
// lModuleNo   : Module number
// lOffset     : Offset position by dword unit between input/output index.(0)
// uLevel      : 0x00 ~ 0x0000FFFF
//===============================================================================================//
function AxdLevelGetExtportDword (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

//========== Advanced API ======================================================
// Verify if the signal was switched from Off to On in Offset position of specified input contact module
//======================================================
// *upValue   : FALSE(0)
//            : TRUE(1)
//======================================================
function AxdiIsPulseOn (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Verify if the signal was switched from On to Off in Offset position of specified input contact module
//======================================================
// *upValue   : FALSE(0)
//            : TRUE(1)
//======================================================
function AxdiIsPulseOff (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// Verify if the signal is maintained On state during the calling time as much as count in Offset position of specified input contact module
//======================================================
// lCount     : 0 ~ 0x7FFFFFFF(2147483647)
// *upValue   : FALSE(0)
//            : TRUE(1)
// lStart     : 1
//            : 0
//======================================================
function AxdiIsOn (lModuleNo : LongInt; lOffset : LongInt; lCount : LongInt; upValue : PDWord; lStart : LongInt) : DWord; stdcall;

// Verify if the signal is maintained Off state during the calling time as much as count in Offset position of specified input contact module
//======================================================
// lCount     : 0 ~ 0x7FFFFFFF(2147483647)
// *upValue   : FALSE(0)
//            : TRUE(1)
// lStart     : 1
//            : 0
//======================================================
function AxdiIsOff (lModuleNo : LongInt; lOffset : LongInt; lCount : LongInt; upValue : PDWord; lStart : LongInt) : DWord; stdcall;

// Maintain On state during mSec set in Offset position of specified output contact module, then turns Off
//======================================================
// lCount     : 0 ~ 0x7FFFFFFF(2147483647)
// lmSec      : 1 ~ 30000
//======================================================
function AxdoOutPulseOn (lModuleNo : LongInt; lOffset : LongInt; lmSec : LongInt) : DWord; stdcall;

// Maintain Off state during mSec set in Offset position of specified output contact module, then turns On
//======================================================
// lCount     : 0 ~ 0x7FFFFFFF(2147483647)
// lmSec      : 1 ~ 30000
//======================================================
function AxdoOutPulseOff (lModuleNo : LongInt; lOffset : LongInt; lmSec : LongInt) : DWord; stdcall;

// Toggling by numbers and interval which are set in Offset position of specified output contact module, then afterward maintaining the original output state
//======================================================
// lInitState : Off(0)
//            : On(1)
// lmSecOn    : 1 ~ 30000
// lmSecOff   : 1 ~ 30000
// lCount     : 1 ~ 0x7FFFFFFF(2147483647)
//            : -1
//======================================================
function AxdoToggleStart (lModuleNo : LongInt; lOffset : LongInt; lInitState : LongInt; lmSecOn : LongInt; lmSecOff : LongInt; lCount : LongInt) : DWord; stdcall;

// Toggling by numbers and interval which are set in Offset position of specified output contact module, then afterward maintaining the original output state
//======================================================
// uOnOff     : Off(0)
//            : On(1)
//======================================================
function AxdoToggleStop (lModuleNo : LongInt; lOffset : LongInt; uOnOff : DWord) : DWord; stdcall;

// In disconnect cases Set output status of specified module by byte.
//===============================================================================================//
// lModuleNo   : Module number
// dwSize      : Set Byte Number(ex. RTEX-DB32 : 2, RTEX-DO32 : 4)
// dwaSetValue : Set Value(Default는 Network 끊어 지기 전 상태 유지)
//             : 0 --> Disconnect before Status
//             : 1 --> On
//             : 2 --> Off
//===============================================================================================//
function AxdoSetNetworkErrorAct(lModuleNo: LongInt; dwSize : DWord; dwaSetValue : PDWord) : DWord; stdcall;

function AxdSetContactNum(lModuleNo : LongInt; dwInputNum : DWord; dwOutputNum : DWord) : DWord; stdcall;

function AxdGetContactNum(lModuleNo : LongInt; dwpInputNum : PDWord; dwpOutputNum : PDWord) : DWord; stdcall;

implementation

const

    dll_name    = 'AXL.dll';

    function AxdInfoIsDIOModule; external dll_name name 'AxdInfoIsDIOModule';
    function AxdInfoGetModuleNo; external dll_name name 'AxdInfoGetModuleNo';
    function AxdInfoGetModuleCount; external dll_name name 'AxdInfoGetModuleCount';
    function AxdInfoGetInputCount; external dll_name name 'AxdInfoGetInputCount';
    function AxdInfoGetOutputCount; external dll_name name 'AxdInfoGetOutputCount';
    function AxdInfoGetModule; external dll_name name 'AxdInfoGetModule';
    function AxdInfoGetModuleStatus; external dll_name name 'AxdInfoGetModuleStatus';
    function AxdiInterruptSetModule; external dll_name name 'AxdiInterruptSetModule';
    function AxdiInterruptSetModuleEnable; external dll_name name 'AxdiInterruptSetModuleEnable';
    function AxdiInterruptGetModuleEnable; external dll_name name 'AxdiInterruptGetModuleEnable';
    function AxdiInterruptRead; external dll_name name 'AxdiInterruptRead';
    function AxdiInterruptEdgeSetBit; external dll_name name 'AxdiInterruptEdgeSetBit';
    function AxdiInterruptEdgeSetByte; external dll_name name 'AxdiInterruptEdgeSetByte';
    function AxdiInterruptEdgeSetWord; external dll_name name 'AxdiInterruptEdgeSetWord';
    function AxdiInterruptEdgeSetDword; external dll_name name 'AxdiInterruptEdgeSetDword';
    function AxdiInterruptEdgeGetBit; external dll_name name 'AxdiInterruptEdgeGetBit';
    function AxdiInterruptEdgeGetByte; external dll_name name 'AxdiInterruptEdgeGetByte';
    function AxdiInterruptEdgeGetWord; external dll_name name 'AxdiInterruptEdgeGetWord';
    function AxdiInterruptEdgeGetDword; external dll_name name 'AxdiInterruptEdgeGetDword';
    function AxdiInterruptEdgeSet; external dll_name name 'AxdiInterruptEdgeSet';
    function AxdiInterruptEdgeGet; external dll_name name 'AxdiInterruptEdgeGet';
    function AxdiLevelSetInportBit; external dll_name name 'AxdiLevelSetInportBit';
    function AxdiLevelSetInportByte; external dll_name name 'AxdiLevelSetInportByte';
    function AxdiLevelSetInportWord; external dll_name name 'AxdiLevelSetInportWord';
    function AxdiLevelSetInportDword; external dll_name name 'AxdiLevelSetInportDword';
    function AxdiLevelGetInportBit; external dll_name name 'AxdiLevelGetInportBit';
    function AxdiLevelGetInportByte; external dll_name name 'AxdiLevelGetInportByte';
    function AxdiLevelGetInportWord; external dll_name name 'AxdiLevelGetInportWord';
    function AxdiLevelGetInportDword; external dll_name name 'AxdiLevelGetInportDword';
    function AxdiLevelSetInport; external dll_name name 'AxdiLevelSetInport';
    function AxdiLevelGetInport; external dll_name name 'AxdiLevelGetInport';
    function AxdoLevelSetOutportBit; external dll_name name 'AxdoLevelSetOutportBit';
    function AxdoLevelSetOutportByte; external dll_name name 'AxdoLevelSetOutportByte';
    function AxdoLevelSetOutportWord; external dll_name name 'AxdoLevelSetOutportWord';
    function AxdoLevelSetOutportDword; external dll_name name 'AxdoLevelSetOutportDword';
    function AxdoLevelGetOutportBit; external dll_name name 'AxdoLevelGetOutportBit';
    function AxdoLevelGetOutportByte; external dll_name name 'AxdoLevelGetOutportByte';
    function AxdoLevelGetOutportWord; external dll_name name 'AxdoLevelGetOutportWord';
    function AxdoLevelGetOutportDword; external dll_name name 'AxdoLevelGetOutportDword';
    function AxdoLevelSetOutport; external dll_name name 'AxdoLevelSetOutport';
    function AxdoLevelGetOutport; external dll_name name 'AxdoLevelGetOutport';
    function AxdoWriteOutport; external dll_name name 'AxdoWriteOutport';
    function AxdoWriteOutportBit; external dll_name name 'AxdoWriteOutportBit';
    function AxdoWriteOutportByte; external dll_name name 'AxdoWriteOutportByte';
    function AxdoWriteOutportWord; external dll_name name 'AxdoWriteOutportWord';
    function AxdoWriteOutportDword; external dll_name name 'AxdoWriteOutportDword';
    function AxdoReadOutport; external dll_name name 'AxdoReadOutport';
    function AxdoReadOutportBit; external dll_name name 'AxdoReadOutportBit';
    function AxdoReadOutportByte; external dll_name name 'AxdoReadOutportByte';
    function AxdoReadOutportWord; external dll_name name 'AxdoReadOutportWord';
    function AxdoReadOutportDword; external dll_name name 'AxdoReadOutportDword';
    function AxdiReadInport; external dll_name name 'AxdiReadInport';
    function AxdiReadInportBit; external dll_name name 'AxdiReadInportBit';
    function AxdiReadInportByte; external dll_name name 'AxdiReadInportByte';
    function AxdiReadInportWord; external dll_name name 'AxdiReadInportWord';
    function AxdiReadInportDword; external dll_name name 'AxdiReadInportDword';
    function AxdReadExtInportBit; external dll_name name 'AxdReadExtInportBit';
    function AxdReadExtInportByte; external dll_name name 'AxdReadExtInportByte';
    function AxdReadExtInportWord; external dll_name name 'AxdReadExtInportWord';
    function AxdReadExtInportDword; external dll_name name 'AxdReadExtInportDword';
    function AxdReadExtOutportBit; external dll_name name 'AxdReadExtOutportBit';
    function AxdReadExtOutportByte; external dll_name name 'AxdReadExtOutportByte';
    function AxdReadExtOutportWord; external dll_name name 'AxdReadExtOutportWord';
    function AxdReadExtOutportDword; external dll_name name 'AxdReadExtOutportDword';
    function AxdWriteExtOutportBit; external dll_name name 'AxdWriteExtOutportBit';
    function AxdWriteExtOutportByte; external dll_name name 'AxdWriteExtOutportByte';
    function AxdWriteExtOutportWord; external dll_name name 'AxdWriteExtOutportWord';
    function AxdWriteExtOutportDword; external dll_name name 'AxdWriteExtOutportDword';
    function AxdLevelSetExtportBit; external dll_name name 'AxdLevelSetExtportBit';
    function AxdLevelSetExtportByte; external dll_name name 'AxdLevelSetExtportByte';
    function AxdLevelSetExtportWord; external dll_name name 'AxdLevelSetExtportWord';
    function AxdLevelSetExtportDword; external dll_name name 'AxdLevelSetExtportDword';
    function AxdLevelGetExtportBit; external dll_name name 'AxdLevelGetExtportBit';
    function AxdLevelGetExtportByte; external dll_name name 'AxdLevelGetExtportByte';
    function AxdLevelGetExtportWord; external dll_name name 'AxdLevelGetExtportWord';
    function AxdLevelGetExtportDword; external dll_name name 'AxdLevelGetExtportDword';
    function AxdiIsPulseOn; external dll_name name 'AxdiIsPulseOn';
    function AxdiIsPulseOff; external dll_name name 'AxdiIsPulseOff';
    function AxdiIsOn; external dll_name name 'AxdiIsOn';
    function AxdiIsOff; external dll_name name 'AxdiIsOff';
    function AxdoOutPulseOn; external dll_name name 'AxdoOutPulseOn';
    function AxdoOutPulseOff; external dll_name name 'AxdoOutPulseOff';
    function AxdoToggleStart; external dll_name name 'AxdoToggleStart';
    function AxdoToggleStop; external dll_name name 'AxdoToggleStop';
    function AxdoSetNetworkErrorAct; external dll_name name 'AxdoSetNetworkErrorAct';
    function AxdSetContactNum; external dll_name name 'AxdSetContactNum';
    function AxdGetContactNum; external dll_name name 'AxdGetContactNum';
end.
