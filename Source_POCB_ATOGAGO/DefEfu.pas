unit DefEfu;

interface
{$I Common.inc}

//******************************************************************************
//
// << EFU : LV32-BLDC Host Protocol (RS485 Communication) >>
//
// 1. Serial Port 
//    - Data Bits    : 8Bit 
//		- Parity       : None
//		- Stop Bit     : 1 Stop Bit
//		- Baud rate    : 9,600 bps 
//		- Flow Control : None
//
// 2. Process Value (���� ���� �ӵ�: PV) & ALARM(�˶� ������) & Setting Value(���� �ӵ�: SV)�� ��û�� ��
//
// 2-1. Tx(PC���� LV32�� ���¿�û�� ���� ������ ����): HOST[Ask: PV & ALARM & SV] -> LV32
//    STX   MODE1  MODE2    LV32ID     DPUID  StartICUID    EndICUID     CheckSum  ETX
//    ----  -----  -----  -----------  -----  -----------  -----------  --------  ----
//		0x02  0x8A   0x87   (1~32)|0x80  0x9F   (1~32)|0x80  (1~32)|0x80  ?         0x03
//			- STX       : 0x02 (���� ��)
//			- MODE1     : 0x8A (���� ��: BLOCK READ)
//			- MODE2     : 0x87 (���� ��: Process Value(PV)/Alarm Data/Setting Value(SV))
//			- LV32ID    : 1 ~ 32 LV32 ID ����, ������ ���� �� 0x80���� |(or) ����.
//			- DPUID     : 0x9F(���� ��)
//			- StartICUID: 1 ~ 32 ICU ID ����, ������ ���� �� 0x80���� |(or) ����(Start ID�� End ID���� �۰ų� ���ƾ� ��).
//			- EndICUID  : 1 ~ 32 ICU ID ����, ������ ���� �� 0x80���� |(or) ����(End ID�� Start ID���� ũ�ų� ���ƾ� ��).
//			- CheckSum  : STX�� ETX�� ������ ������ ��Ŷ�� ������ ���� 1Byte �����.
//			   ex) MODE1 + MODE2 + LV32_ID + DPU ID + Start ICU_ID + End ICU_ID => ���� 1Byte)
//
// 2-2. Rx(PC���� ���¿�û�� ���� LV32 ���� ������ ����): HOST -> LV32[Send: PV & ALARM & SV]
//    STX   MODE1  MODE2    LV32ID     DPUID  StartICU(ID,PV,ALARM,SV) ~ EndICU(ID,PV,ALARM,SV)  CheckSum  ETX
//    ----  -----  -----  -----------  -----  ------------------------ - ----------------------  --------  ----
//		0x02  0x8A   0x87   (1~32)|0x80  0x9F   ?                        ? ?                       ?         0x03
//		  -	STX          : 0x02 (���� ��)
//			-	MODE1        : 0x8A (���� ��: BLOCK READ)
//			- MODE2        : 0x87 (���� ��: Process Value(PV)/Alarm Data/Setting Value(SV))
//			-	LV32_ID      : 1 ~ 32 LV32 ID ����, ������ ���� �� 0x80���� |(or) ����.
//			-	DPU ID       : 0x9F(���� ��)
//			-	StartICU Data: [ID(1Byte), PV(1Byte), ALARM(1Byte), SV(1Byte)] ~
//			-	EndICU Data  : [ID(1Byte), PV(1Byte), ALARM(1Byte), SV(1Byte)]
//			-	CheckSum     : STX�� ETX�� ������ ������ vŶ�� ������ ���� 1Byte �����.
//				  ex: MODE1 + MODE2 + LV32_ID + DPU ID + Start ICU Data ~ + End ICU Data => ���� 1Byte)
//    * ALARM (1 Byte)
//      - Bit 7: ��ſ������:   1=�������,   0=��ž˶�
//      - Bit 6: ���;˶�����:   1=���;˶�,   0=��������
//      - Bit 5: �������˶�����: 1=�������˶�, 0=����������
//      - Bit 4: NotUsed
//      - Bit 3: NotUsed
//      - Bit 2: NotUsed
//      - Bit 1: �����˶�����:   1=�����˶�,   0=��������
//      - Bit 0: Local|Remote:   1=Local������,0=Remote������  //����� Local ������¿����� �������� ���� ���� �� �� ����.
//
//  ��) HOST���� LV32_ID�� 1�̰� ICU 1������ 3������ Process Value & ALARM & Setting Value�� ��û.
//     (1) Tx : HOST -> LV32 (Ask PV & ALARM & SV)
//              0x02 0x8A 0x87 0x81 0x9F 0x81 0x83 0x35 0x03
//     (2) Rx : LV32 -> HOST (Send PV & ALARM & SV)
//              0x02 0x8A 0x87 0x81 0x9F / 0x81 0x46 0x80 0x46 / 0x82 0x46 0x80 0x46 / 0x83 0x46 0x80 0x46 / 0xDB 0x03
//      - ���� ���� �ӵ�(Process Value): PV * 10(ex:PV�� 70(0x46) -> 70(0x46)*10 = 700RPM)
//      - ���� �ӵ�(Setting Value): SV * 10(ex:SV�� 70(0x46) -> 70(0x46)*10 = 700RPM)

// 3. ICU�� ���� �ӵ��� ���� �� ��
//
// 3-1 Tx : HOST -> LV32 (Unit Command RPM)
//    STX   MODE1  MODE2    LV32ID     DPUID  StartICUID   EndICUID     SV     CheckSum  ETX
//    ----  -----  -----  -----------  -----  -----------  -----------  -----  --------  ----
//    0x02  0x89   0x84   (1~32)|0x80  0x9F   (1~32)|0x80  (1~32)|0x80  0~140  ?         0x03
//       - MODE1: 0x89 (���� ��)
//       - MODE2: 0x84 (���� ��: Setting Value(SV))
//       - SV   : 0 ~ 140 (ex: 1 -> 10 rpm, 100 -> 1000 rpm)
//
// 3-2 Rx : LV32 -> HOST (Send OK)
//    STX   MODE1  MODE2    LV32ID     DPUID  StartICUID   EndICUID     Flag(OK)  CheckSum  ETX
//    ----  -----  -----  -----------  -----  -----------  -----------  --------  --------  ----
//    0x02  0x89   0x84   (1~32)|0x80  0x9F   (1~32)|0x80  (1~32)|0x80  0xB9      ?         0x03
//
// ��) HOST���� LV32_ID�� 1�̰� �� �Ʒ� 1����3���� ICU�� Setting Value(���� �ӵ�)�� ������ ��
//    (1) Tx : HOST -> LV32 (Unit Command RPM)
//             0x02 0x89 0x84 0x81 0x9F 0x81 0x83 0x46 0x77 0x03
//           - ���� �ӵ��� 700RPM ���� ������ ��(SV�� 70 -> 0x46)
//    (2) Rx : LV32 -> HOST (Send OK)
//             0x02 0x89 0x84 0x81 0x9F 0x81 0x83 0xB9 0xEA 0x03
//
//******************************************************************************

const

	//----------------------------------------------------------
	// << EFU : LV32-BLDC Host Protocol (RS485 Communication) >>
	//----------------------------------------------------------
	//
	// MODE1 & MODE2 (To Get PV/Alarm/SV)
	//		- MODE1: 0x8A (���� ��: BLOCK READ)
	//		- MODE2: 0x87 (���� ��: Process Value(PV)/Alarm Data/Setting Value(SV))
	EFU_MODE1_BLOCK_READ  = $8A;
	EFU_MODE2_READ_STATUS = $87;

	// MODE1 & MODE2 (To Set SV)
	//		-	MODE1: 0x89 (���� ��: CLOCK WRITE)
	//		- MODE2: 0x84 (���� ��: Setting Value(SV))
	EFU_MODE1_BLOCK_WRITE = $89;
	EFU_MODE2_WRITE_SV    = $84;

	// LV32_ID
  //		- LV32ID: 1 ~ 32, ������ ���� �� 0x80���� |(or) ����
  EFU_LV32ID      = 1;	// Default LV32ID  //TBD:EFU? SystemConfig�� ���� (ReadOnly)

	// ICU_ID
  //		- StartICUID: 1 ~ 32, ������ ���� �� 0x80���� |(or) ����(Start ID�� End ID���� �۰ų� ���ƾ� ��).
  //		- EndICUID  : 1 ~ 32, ������ ���� �� 0x80���� |(or) ����(End ID�� Start ID���� ũ�ų� ���ƾ� ��).
  EFU_ICUID_MIN   = 1;  // StartICUID
  EFU_ICUID_MAX   = 4;  // 32;

	// DPU_ID
  //		- DPUID: 0x9F (���� ��)
  EFU_DPUID       = $9F; // DPUID: 0x9F (���� ��)

	// ACK_OK
  EFU_SET_OK      = $B9; // Flag(OK): 0xB9 (���� ��)

	// Etc(SV, SV_RPM)
	EFU_SV_MAX  = 140;	// SV : 0 ~ 140  (ex: 1 sv -> 10 rpm, 100 sv -> 1000 rpm)
	EFU_RPM_MAX = 1400;	// RPM: 0 ~ 1400 (ex: 1 sv -> 10 rpm, 100 sv -> 1000 rpm)

	// Etc(Alarm)
	EFU_ALARM_MASK_ALL          = $E2;
  EFU_ALARM_VALUE_NORMAL      = $81;  //Bit7(1:��ſ�������), Bit6(0:��������), Bit5(0:����������), Bit1(0:��������), Bit0(1:Local������)

	EFU_ALARM_MASK_COMM_NORMAL  = $80;	// Bit 7: ��ſ������:   1=�������,   0=��ž˶�
	EFU_ALARM_MASK_MOTOR        = $40;  // Bit 6: ���;˶�����:   1=���;˶�,   0=��������
	EFU_ALARM_MASK_OVER_CURRENT = $20;  // Bit 5: �������˶�����: 1=�������˶�, 0=����������
																			// Bit 4~2: Not Use
	EFU_ALARM_MASK_POWER        = $02;  // Bit 1: �����˶�����:   1=�����˶�,   0=��������
	EFU_ALARM_MASK_LOCAL_CTL    = $01;  // Bit 0: Local|Remote:   1=Local������,0=Remote������

  EFU_ALIVECHECK_TIMESEC	= 5;		// Default EFU Alie Check Cyclic Timer Value(Sec)    //TBD:EFU? SystemConfig�� ���� (ReadOnly)
  EFU_STATUSWAIT_TIMESEC	= 2;		// Default EFU Status Response Wait Timer Value(Sec) //TBD:EFU? SystemConfig�� ���� (ReadOnly)

implementation

end.

