//*****************************************************************************
//*****************************************************************************
//**
//** File Name
//** ----------
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

//========== ���� �� ��� ���� =================================================================================

// DIO ����� �ִ��� Ȯ��
function AxdInfoIsDIOModule (upStatus : PDWord) : DWord; stdcall;

// DIO ��� No Ȯ��
function AxdInfoGetModuleNo (lBoardNo : LongInt; lModulePos : LongInt; lpModuleNo : PLongInt) : DWord; stdcall;

// DIO ����� ����� ���� Ȯ��
function AxdInfoGetModuleCount (lpModuleCount : PLongInt) : DWord; stdcall;

// ������ ����� �Է� ���� ���� Ȯ��
function AxdInfoGetInputCount (lModuleNo : LongInt; lpCount : PLongInt) : DWord; stdcall;

// ������ ����� ��� ���� ���� Ȯ��
function AxdInfoGetOutputCount (lModuleNo : LongInt; lpCount : PLongInt) : DWord; stdcall;

// ������ ��� ��ȣ�� ���̽� ���� ��ȣ, ��� ��ġ, ��� ID Ȯ��
function AxdInfoGetModule (lModuleNo : LongInt; lpBoardNo : PLongInt; lpModulePos : PLongInt; upModuleID : PDWord) : DWord; stdcall;

//========== ���ͷ�Ʈ ���� Ȯ�� =================================================================================

// ������ ��⿡ ���ͷ�Ʈ �޽����� �޾ƿ��� ���Ͽ� ������ �޽���, �ݹ� �Լ� �Ǵ� �̺�Ʈ ����� ���
	//========= ���ͷ�Ʈ ���� �Լ� ======================================================================================
    // �ݹ� �Լ� ����� �̺�Ʈ �߻� ������ ��� �ݹ� �Լ��� ȣ�� ������ ���� ������ �̺�Ʈ�� �������� �� �ִ� ������ ������
    // �ݹ� �Լ��� ������ ���� �� ������ ���� ���μ����� ��ü�Ǿ� �ְ� �ȴ�.
    // ��, �ݹ� �Լ� ���� ���ϰ� �ɸ��� �۾��� ���� ��쿡�� ��뿡 ���Ǹ� ���Ѵ�. 
    // �̺�Ʈ ����� ��������� �̿��Ͽ� ���ͷ�Ʈ �߻����θ� ���������� �����ϰ� �ִٰ� ���ͷ�Ʈ�� �߻��ϸ� 
    // ó�����ִ� �������, ������ ������ ���� �ý��� �ڿ��� �����ϰ� �ִ� ������ ������
    // ���� ������ ���ͷ�Ʈ�� �����ϰ� ó������ �� �ִ� ������ �ִ�.
    // �Ϲ������δ� ���� ������ ������, ���ͷ�Ʈ�� ����ó���� �ֿ� ���ɻ��� ��쿡 ���ȴ�. 
    // �̺�Ʈ ����� �̺�Ʈ�� �߻� ���θ� �����ϴ� Ư�� �����带 ����Ͽ� ���� ���μ����� ������ ���۵ǹǷ�
    // MultiProcessor �ý��۵�� �ڿ��� ���� ȿ�������� ����� �� �ְ� �Ǿ� Ư�� �����ϴ� ����̴�.
    // ���ͷ�Ʈ �޽����� �޾ƿ��� ���Ͽ� ������ �޽��� �Ǵ� �ݹ� �Լ��� ����Ѵ�.
    // (�޽��� �ڵ�, �޽��� ID, �ݹ��Լ�, ���ͷ�Ʈ �̺�Ʈ)
    //    hWnd    : ������ �ڵ�, ������ �޼����� ������ ���. ������� ������ NULL�� �Է�.
    //    uMessage: ������ �ڵ��� �޼���, ������� �ʰų� ����Ʈ���� ����Ϸ��� 0�� �Է�.
    //    proc    : ���ͷ�Ʈ �߻��� ȣ��� �Լ��� ������, ������� ������ NULL�� �Է�.
	  //    pEvent  : �̺�Ʈ ������� �̺�Ʈ �ڵ�
function AxdiInterruptSetModule (lModuleNo : LongInt; hWnd : HWND; uMessage : DWord; pProc : AXT_INTERRUPT_PROC; pEvent : PDWord) : DWord; stdcall;

// ������ ����� ���ͷ�Ʈ ��� ���� ����
	//======================================================//
	// uUse		: DISABLE(0)	// ���ͷ�Ʈ ����
	//		  	: ENABLE(1)		// ���ͷ�Ʈ ����
	//======================================================//
function AxdiInterruptSetModuleEnable (lModuleNo : LongInt; uUse : DWord) : DWord; stdcall;

// ������ ����� ���ͷ�Ʈ ��� ���� Ȯ��
	//======================================================//
	// *upUse	: DISABLE(0)	// ���ͷ�Ʈ ����
	//			  : ENABLE(1)		// ���ͷ�Ʈ ����
	//======================================================//
function AxdiInterruptGetModuleEnable (lModuleNo : LongInt; upUse : PDWord) : DWord; stdcall;

// ���ͷ�Ʈ �߻� ��ġ Ȯ��
function AxdiInterruptRead (lpModuleNo : PLongInt; upFlag : PDWord) : DWord; stdcall;

//========== ���ͷ�Ʈ ��� / �ϰ� ���� ���� Ȯ�� =================================================================================

// ������ �Է� ���� ���, Interrupt Rising / Falling Edge register�� Offset ��ġ���� bit ������ ��� �Ǵ� �ϰ� ���� ���� ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uMode	  	: DOWN_EDGE(0)
	//	    			: UP_EDGE(1)
	// uValue	  	: DISABLE(0)
	//		  	  	: ENABLE(1)
	//===============================================================================================//
function AxdiInterruptEdgeSetBit (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; uValue : DWord) : DWord; stdcall;

// ������ �Է� ���� ���, Interrupt Rising / Falling Edge register�� Offset ��ġ���� byte ������ ��� �Ǵ� �ϰ� ���� ���� ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uMode	  	: DOWN_EDGE(0)
	//			    	: UP_EDGE(1)
	// uValue	  	: 0x00 ~ 0x0FF ('1'�� Setting �� �κ� ���ͷ�Ʈ ����)
	//===============================================================================================//
function AxdiInterruptEdgeSetByte (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; uValue : DWord) : DWord; stdcall;

// ������ �Է� ���� ���, Interrupt Rising / Falling Edge register�� Offset ��ġ���� word ������ ��� �Ǵ� �ϰ� ���� ���� ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uMode	  	: DOWN_EDGE(0)
	//			    	: UP_EDGE(1)
	// uValue	  	: 0x00 ~ 0x0FFFF ('1'�� Setting �� �κ� ���ͷ�Ʈ ����)
	//===============================================================================================//
function AxdiInterruptEdgeSetWord (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; uValue : DWord) : DWord; stdcall;

// ������ �Է� ���� ���, Interrupt Rising / Falling Edge register�� Offset ��ġ���� double word ������ ��� �Ǵ� �ϰ� ���� ���� ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uMode	  	: DOWN_EDGE(0)
	//				    : UP_EDGE(1)
	// uValue		  : 0x00 ~ 0x0FFFFFFFF ('1'�� Setting �� �κ� ���ͷ�Ʈ ����)
	//===============================================================================================//
function AxdiInterruptEdgeSetDword (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; uValue : DWord) : DWord; stdcall;

// ������ �Է� ���� ���, Interrupt Rising / Falling Edge register�� Offset ��ġ���� bit ������ ��� �Ǵ� �ϰ� ���� ���� Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uMode	  	: DOWN_EDGE(0)
	//				    : UP_EDGE(1)
	// *upValue	 	: DISABLE(0)
	//		  	  	: ENABLE(1)
	//===============================================================================================//
function AxdiInterruptEdgeGetBit (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; upValue : PDWord) : DWord; stdcall;

// ������ �Է� ���� ���, Interrupt Rising / Falling Edge register�� Offset ��ġ���� byte ������ ��� �Ǵ� �ϰ� ���� ���� Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uMode	  	: DOWN_EDGE(0)
	//				    : UP_EDGE(1)
	// *upValue		: 0x00 ~ 0x0FF ('1'�� Setting �� �κ� ���ͷ�Ʈ ����)
	//===============================================================================================//
function AxdiInterruptEdgeGetByte (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; upValue : PDWord) : DWord; stdcall;

// ������ �Է� ���� ���, Interrupt Rising / Falling Edge register�� Offset ��ġ���� word ������ ��� �Ǵ� �ϰ� ���� ���� Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uMode	  	: DOWN_EDGE(0)
	//				    : UP_EDGE(1)
	// *upValue		: 0x00 ~ 0x0FFFF ('1'�� Setting �� �κ� ���ͷ�Ʈ ����)
	//===============================================================================================//
function AxdiInterruptEdgeGetWord (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; upValue : PDWord) : DWord; stdcall;

// ������ �Է� ���� ���, Interrupt Rising / Falling Edge register�� Offset ��ġ���� double word ������ ��� �Ǵ� �ϰ� ���� ���� Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uMode		  : DOWN_EDGE(0)
	//				    : UP_EDGE(1)
	// *upValue		: 0x00 ~ 0x0FFFFFFFF ('1'�� Setting �� �κ� ���ͷ�Ʈ ����)
	//===============================================================================================//
function AxdiInterruptEdgeGetDword (lModuleNo : LongInt; lOffset : LongInt; uMode : DWord; upValue : PDWord) : DWord; stdcall;

// ��ü �Է� ���� ���, Interrupt Rising / Falling Edge register�� Offset ��ġ���� bit ������ ��� �Ǵ� �ϰ� ���� ���� ����
	//===============================================================================================//
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uMode	  	: DOWN_EDGE(0)
	//		    		: UP_EDGE(1)
	// uValue	  	: DISABLE(0)
	//			    	: ENABLE(1)
	//===============================================================================================//
function AxdiInterruptEdgeSet (lOffset : LongInt; uMode : DWord; uValue : DWord) : DWord; stdcall;

// ��ü �Է� ���� ���, Interrupt Rising / Falling Edge register�� Offset �������� bit ������ ��� �Ǵ� �ϰ� ���� ���� Ȯ��
	//===============================================================================================//
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uMode	  	: DOWN_EDGE(0)
	//				    : UP_EDGE(1)
	// *upValue		: DISABLE(0)
	//			    	: ENABLE(1)
	//===============================================================================================//
function AxdiInterruptEdgeGet (lOffset : LongInt; uMode : DWord; upValue : PDWord) : DWord; stdcall;

//========== ����� ���� ���� Ȯ�� =================================================================================
//==�Է� ���� ���� Ȯ��
// ������ �Է� ���� ����� Offset ��ġ���� bit ������ ������ ������ ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uLevel		  : LOW(0)
	//				    : HIGH(1)
	//===============================================================================================//
function AxdiLevelSetInportBit (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� byte ������ ������ ������ ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uLevel		  : 0x00 ~ 0x0FF('1'�� ���� �� ��Ʈ�� HIGH, '0'���� ���� �� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdiLevelSetInportByte (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� word ������ ������ ������ ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uLevel		  : 0x00 ~ 0x0FFFF('1'�� ���� �� ��Ʈ�� HIGH, '0'���� ���� �� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdiLevelSetInportWord (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� double word ������ ������ ������ ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uLevel		  : 0x00 ~ 0x0FFFFFFFF('1'�� ���� �� ��Ʈ�� HIGH, '0'���� ���� �� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdiLevelSetInportDword (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� bit ������ ������ ������ Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upLevel		: LOW(0)
	//		     		: HIGH(1)
	//===============================================================================================//
function AxdiLevelGetInportBit (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� byte ������ ������ ������ Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upLevel		: 0x00 ~ 0x0FF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdiLevelGetInportByte (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� word ������ ������ ������ Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upLevel		: 0x00 ~ 0x0FFFF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdiLevelGetInportWord (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� double word ������ ������ ������ Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upLevel		: 0x00 ~ 0x0FFFFFFFF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdiLevelGetInportDword (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// ��ü �Է� ���� ����� Offset ��ġ���� bit ������ ������ ������ ����
	//===============================================================================================//
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// uLevel 		: LOW(0)
	//				    : HIGH(1)
	//===============================================================================================//
function AxdiLevelSetInport (lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// ��ü �Է� ���� ����� Offset ��ġ���� bit ������ ������ ������ Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upLevel		: LOW(0)
	//    				: HIGH(1)
	//===============================================================================================//
function AxdiLevelGetInport (lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

//==��� ���� ���� Ȯ��
// ������ ��� ���� ����� Offset ��ġ���� bit ������ ������ ������ ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uLevel 		: LOW(0)
	//			    	: HIGH(1)
	//===============================================================================================//
function AxdoLevelSetOutportBit (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� byte ������ ������ ������ ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uLevel	  	: 0x00 ~ 0x0FF('1'�� ���� �� ��Ʈ�� HIGH, '0'���� ���� �� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoLevelSetOutportByte (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� word ������ ������ ������ ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uLevel	  	: 0x00 ~ 0x0FFFF('1'�� ���� �� ��Ʈ�� HIGH, '0'���� ���� �� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoLevelSetOutportWord (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� double word ������ ������ ������ ����
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uLevel	  	: 0x00 ~ 0x0FFFFFFFF('1'�� ���� �� ��Ʈ�� HIGH, '0'���� ���� �� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoLevelSetOutportDword (lModuleNo : LongInt; lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� bit ������ ������ ������ Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// *upLevel		: LOW(0)
	//			    	: HIGH(1)
	//===============================================================================================//
function AxdoLevelGetOutportBit (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� byte ������ ������ ������ Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uLevel		: 0x00 ~ 0x0FF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoLevelGetOutportByte (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� word ������ ������ ������ Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uLevel		: 0x00 ~ 0x0FFFF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoLevelGetOutportWord (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� double word ������ ������ ������ Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uLevel	  	: 0x00 ~ 0x0FFFFFFFF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoLevelGetOutportDword (lModuleNo : LongInt; lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

// ��ü ��� ���� ����� Offset ��ġ���� bit ������ ������ ������ ����
	//===============================================================================================//
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uLevel	  	: LOW(0)
	//		  	   	: HIGH(1)
	//===============================================================================================//
function AxdoLevelSetOutport (lOffset : LongInt; uLevel : DWord) : DWord; stdcall;

// ��ü ��� ���� ����� Offset ��ġ���� bit ������ ������ ������ Ȯ��
	//===============================================================================================//
	// lOffset		: ��� ������ ���� Offset ��ġ
	// *upLevel		: LOW(0)
	//			    	: HIGH(1)
	//===============================================================================================//
function AxdoLevelGetOutport (lOffset : LongInt; upLevel : PDWord) : DWord; stdcall;

//========== ����� ��Ʈ ���� �б� =================================================================================
//==��� ��Ʈ ����
// ��ü ��� ���� ����� Offset ��ġ���� bit ������ �����͸� ���
	//===============================================================================================//
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uValue		  : LOW(0)
	//				    : HIGH(1)
	//===============================================================================================//
function AxdoWriteOutport (lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� bit ������ �����͸� ���
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uValue		  : LOW(0)
	//			    	: HIGH(1)
	//===============================================================================================//
function AxdoWriteOutportBit (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� byte ������ �����͸� ���
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uValue		  : 0x00 ~ 0x0FF('1'�� ���� �� ��Ʈ�� HIGH, '0'���� ���� �� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoWriteOutportByte (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� word ������ �����͸� ���
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uValue		  : 0x00 ~ 0x0FFFF('1'�� ���� �� ��Ʈ�� HIGH, '0'���� ���� �� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoWriteOutportWord (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� double word ������ �����͸� ���
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uValue	   	: 0x00 ~ 0x0FFFFFFFF('1'�� ���� �� ��Ʈ�� HIGH, '0'���� ���� �� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoWriteOutportDword (lModuleNo : LongInt; lOffset : LongInt; uValue : DWord) : DWord; stdcall;

//==��� ��Ʈ �б�
// ��ü ��� ���� ����� Offset ��ġ���� bit ������ �����͸� �б�
	//===============================================================================================//
	// lOffset		: ��� ������ ���� Offset ��ġ
	// *upValue		: LOW(0)
	//			    	: HIGH(1)
	//===============================================================================================//
function AxdoReadOutport (lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� bit ������ �����͸� �б�
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// *upValue		: LOW(0)
	//				    : HIGH(1)
	//===============================================================================================//
function AxdoReadOutportBit (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� byte ������ �����͸� �б�
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// *upValue		: 0x00 ~ 0x0FF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoReadOutportByte (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� word ������ �����͸� �б�
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// *upValue		: 0x00 ~ 0x0FFFF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoReadOutportWord (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� double word ������ �����͸� �б�
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// *upValue		: 0x00 ~ 0x0FFFFFFFF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdoReadOutportDword (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

//==�Է� ��Ʈ �б�
// ��ü �Է� ���� ����� Offset ��ġ���� bit ������ �����͸� �б�
	//===============================================================================================//
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upValue		: LOW(0)
	//			    	: HIGH(1)
	//===============================================================================================//
function AxdiReadInport (lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� bit ������ �����͸� �б�
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upValue		: LOW(0)
	//			    	: HIGH(1)
	//===============================================================================================//
function AxdiReadInportBit (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� byte ������ �����͸� �б�
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upValue		: 0x00 ~ 0x0FF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdiReadInportByte (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� word ������ �����͸� �б�
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upValue		: 0x00 ~ 0x0FFFF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdiReadInportWord (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� double word ������ �����͸� �б�
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upValue		: 0x00 ~ 0x0FFFFFFFF('1'�� ���� ��Ʈ�� HIGH, '0'���� ���� ��Ʈ�� LOW)
	//===============================================================================================//
function AxdiReadInportDword (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

//========== ���� �Լ� =================================================================================

// ������ �Է� ���� ����� Offset ��ġ���� ��ȣ�� Off���� On���� �ٲ������ Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upValue		: FALSE(0)
	//			    	: TRUE(1)
	//===============================================================================================//
function AxdiIsPulseOn (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� ��ȣ�� On���� Off���� �ٲ������ Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// *upValue		: FALSE(0)
	//		    		: TRUE(1)
	//===============================================================================================//
function AxdiIsPulseOff (lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� ��ȣ�� count ��ŭ ȣ��� ���� On ���·� �����ϴ��� Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: �Է� ������ ���� Offset ��ġ
	// lCount	  	: 0 ~ 0x7FFFFFFF(2147483647)
	// *upValue		: FALSE(0)
	//			    	: TRUE(1)
	// lStart	  	: 1(���� ȣ��)
	//				    : 0(�ݺ� ȣ��)
	//===============================================================================================//
function AxdiIsOn (lModuleNo : LongInt; lOffset : LongInt; lCount : LongInt; upValue : PDWord; lStart : LongInt) : DWord; stdcall;

// ������ �Է� ���� ����� Offset ��ġ���� ��ȣ�� count ��ŭ ȣ��� ���� Off ���·� �����ϴ��� Ȯ��
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// lCount		  : 0 ~ 0x7FFFFFFF(2147483647)
	// *upValue		: FALSE(0)
	//			    	: TRUE(1)
	// lStart	  	: 1(���� ȣ��)
	//				    : 0(�ݺ� ȣ��)
	//===============================================================================================//
function AxdiIsOff (lModuleNo : LongInt; lOffset : LongInt; lCount : LongInt; upValue : PDWord; lStart : LongInt) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� ������ mSec���� On�� �����ϴٰ� Off ��Ŵ
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// lCount	   	: 0 ~ 0x7FFFFFFF(2147483647)
	// lmSec	  	: 1 ~ 30000
	//===============================================================================================//
function AxdoOutPulseOn (lModuleNo : LongInt; lOffset : LongInt; lmSec : LongInt) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� ������ mSec���� Off�� �����ϴٰ� On ��Ŵ
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// lCount	  	: 0 ~ 0x7FFFFFFF(2147483647)
	// lmSec	  	: 1 ~ 30000
	//===============================================================================================//
function AxdoOutPulseOff (lModuleNo : LongInt; lOffset : LongInt; lmSec : LongInt) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� ������ Ƚ��, ������ �������� ����� �� ������ ��»��¸� ������
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// lInitState	: Off(0)
	//			    	: On(1)
	// lmSecOn		: 1 ~ 30000
	// lmSecOff		: 1 ~ 30000
	// lCount		  : 1 ~ 0x7FFFFFFF(2147483647)
	//			    	: -1 ���� ���
	//===============================================================================================//
function AxdoToggleStart (lModuleNo : LongInt; lOffset : LongInt; lInitState : LongInt; lmSecOn : LongInt; lmSecOff : LongInt; lCount : LongInt) : DWord; stdcall;

// ������ ��� ���� ����� Offset ��ġ���� ������� ����� ������ ��ȣ ���·� ���� ��Ŵ
	//===============================================================================================//
	// lModuleNo	: ��� ��ȣ
	// lOffset		: ��� ������ ���� Offset ��ġ
	// uOnOff	  	: Off(0)
	//			    	: On(1)
	//===============================================================================================//
function AxdoToggleStop (lModuleNo : LongInt; lOffset : LongInt; uOnOff : DWord) : DWord; stdcall;

implementation

const

	dll_name	= 'AXL.dll';

	function AxdInfoIsDIOModule; external dll_name name 'AxdInfoIsDIOModule';
	function AxdInfoGetModuleNo; external dll_name name 'AxdInfoGetModuleNo';
	function AxdInfoGetModuleCount; external dll_name name 'AxdInfoGetModuleCount';
	function AxdInfoGetInputCount; external dll_name name 'AxdInfoGetInputCount';
	function AxdInfoGetOutputCount; external dll_name name 'AxdInfoGetOutputCount';
	function AxdInfoGetModule; external dll_name name 'AxdInfoGetModule';
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
	function AxdiIsPulseOn; external dll_name name 'AxdiIsPulseOn';
	function AxdiIsPulseOff; external dll_name name 'AxdiIsPulseOff';
	function AxdiIsOn; external dll_name name 'AxdiIsOn';
	function AxdiIsOff; external dll_name name 'AxdiIsOff';
	function AxdoOutPulseOn; external dll_name name 'AxdoOutPulseOn';
	function AxdoOutPulseOff; external dll_name name 'AxdoOutPulseOff';
	function AxdoToggleStart; external dll_name name 'AxdoToggleStart';
	function AxdoToggleStop; external dll_name name 'AxdoToggleStop';
end.