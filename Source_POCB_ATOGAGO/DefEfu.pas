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
// 2. Process Value (현재 구동 속도: PV) & ALARM(알람 데이터) & Setting Value(지정 속도: SV)를 요청할 때
//
// 2-1. Tx(PC에서 LV32에 상태요청을 위한 데이터 구조): HOST[Ask: PV & ALARM & SV] -> LV32
//    STX   MODE1  MODE2    LV32ID     DPUID  StartICUID    EndICUID     CheckSum  ETX
//    ----  -----  -----  -----------  -----  -----------  -----------  --------  ----
//		0x02  0x8A   0x87   (1~32)|0x80  0x9F   (1~32)|0x80  (1~32)|0x80  ?         0x03
//			- STX       : 0x02 (고정 값)
//			- MODE1     : 0x8A (고정 값: BLOCK READ)
//			- MODE2     : 0x87 (고정 값: Process Value(PV)/Alarm Data/Setting Value(SV))
//			- LV32ID    : 1 ~ 32 LV32 ID 선택, 데이터 전송 시 0x80으로 |(or) 연산.
//			- DPUID     : 0x9F(고정 값)
//			- StartICUID: 1 ~ 32 ICU ID 선택, 데이터 전송 시 0x80으로 |(or) 연산(Start ID는 End ID보다 작거나 같아야 함).
//			- EndICUID  : 1 ~ 32 ICU ID 선택, 데이터 전송 시 0x80으로 |(or) 연산(End ID는 Start ID보다 크거나 같아야 함).
//			- CheckSum  : STX와 ETX를 제외한 나머지 페킷의 총합의 하위 1Byte 사용함.
//			   ex) MODE1 + MODE2 + LV32_ID + DPU ID + Start ICU_ID + End ICU_ID => 하위 1Byte)
//
// 2-2. Rx(PC에서 상태요청에 의한 LV32 응답 데이터 구조): HOST -> LV32[Send: PV & ALARM & SV]
//    STX   MODE1  MODE2    LV32ID     DPUID  StartICU(ID,PV,ALARM,SV) ~ EndICU(ID,PV,ALARM,SV)  CheckSum  ETX
//    ----  -----  -----  -----------  -----  ------------------------ - ----------------------  --------  ----
//		0x02  0x8A   0x87   (1~32)|0x80  0x9F   ?                        ? ?                       ?         0x03
//		  -	STX          : 0x02 (고정 값)
//			-	MODE1        : 0x8A (고정 값: BLOCK READ)
//			- MODE2        : 0x87 (고정 값: Process Value(PV)/Alarm Data/Setting Value(SV))
//			-	LV32_ID      : 1 ~ 32 LV32 ID 선택, 데이터 전송 시 0x80으로 |(or) 연산.
//			-	DPU ID       : 0x9F(고정 값)
//			-	StartICU Data: [ID(1Byte), PV(1Byte), ALARM(1Byte), SV(1Byte)] ~
//			-	EndICU Data  : [ID(1Byte), PV(1Byte), ALARM(1Byte), SV(1Byte)]
//			-	CheckSum     : STX와 ETX를 제외한 나머지 v킷의 총합의 하위 1Byte 사용함.
//				  ex: MODE1 + MODE2 + LV32_ID + DPU ID + Start ICU Data ~ + End ICU Data => 하위 1Byte)
//    * ALARM (1 Byte)
//      - Bit 7: 통신연결상태:   1=통신정상,   0=통신알람
//      - Bit 6: 모터알람상태:   1=모터알람,   0=모터정상
//      - Bit 5: 과전류알람상태: 1=과전류알람, 0=과전류정상
//      - Bit 4: NotUsed
//      - Bit 3: NotUsed
//      - Bit 2: NotUsed
//      - Bit 1: 전원알람상태:   1=전원알람,   0=전원정상
//      - Bit 0: Local|Remote:   1=Local제어중,0=Remote제어중  //제어기 Local 제어상태에서는 상위에서 값을 변경 할 수 없음.
//
//  예) HOST에서 LV32_ID가 1이고 ICU 1번부터 3번까지 Process Value & ALARM & Setting Value를 요청.
//     (1) Tx : HOST -> LV32 (Ask PV & ALARM & SV)
//              0x02 0x8A 0x87 0x81 0x9F 0x81 0x83 0x35 0x03
//     (2) Rx : LV32 -> HOST (Send PV & ALARM & SV)
//              0x02 0x8A 0x87 0x81 0x9F / 0x81 0x46 0x80 0x46 / 0x82 0x46 0x80 0x46 / 0x83 0x46 0x80 0x46 / 0xDB 0x03
//      - 현재 구동 속도(Process Value): PV * 10(ex:PV는 70(0x46) -> 70(0x46)*10 = 700RPM)
//      - 설정 속도(Setting Value): SV * 10(ex:SV는 70(0x46) -> 70(0x46)*10 = 700RPM)

// 3. ICU의 지정 속도를 변경 할 때
//
// 3-1 Tx : HOST -> LV32 (Unit Command RPM)
//    STX   MODE1  MODE2    LV32ID     DPUID  StartICUID   EndICUID     SV     CheckSum  ETX
//    ----  -----  -----  -----------  -----  -----------  -----------  -----  --------  ----
//    0x02  0x89   0x84   (1~32)|0x80  0x9F   (1~32)|0x80  (1~32)|0x80  0~140  ?         0x03
//       - MODE1: 0x89 (고정 값)
//       - MODE2: 0x84 (고정 값: Setting Value(SV))
//       - SV   : 0 ~ 140 (ex: 1 -> 10 rpm, 100 -> 1000 rpm)
//
// 3-2 Rx : LV32 -> HOST (Send OK)
//    STX   MODE1  MODE2    LV32ID     DPUID  StartICUID   EndICUID     Flag(OK)  CheckSum  ETX
//    ----  -----  -----  -----------  -----  -----------  -----------  --------  --------  ----
//    0x02  0x89   0x84   (1~32)|0x80  0x9F   (1~32)|0x80  (1~32)|0x80  0xB9      ?         0x03
//
// 예) HOST에서 LV32_ID가 1이고 그 아래 1에서3번인 ICU의 Setting Value(지정 속도)를 변경할 때
//    (1) Tx : HOST -> LV32 (Unit Command RPM)
//             0x02 0x89 0x84 0x81 0x9F 0x81 0x83 0x46 0x77 0x03
//           - 구동 속도를 700RPM 으로 변경할 때(SV는 70 -> 0x46)
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
	//		- MODE1: 0x8A (고정 값: BLOCK READ)
	//		- MODE2: 0x87 (고정 값: Process Value(PV)/Alarm Data/Setting Value(SV))
	EFU_MODE1_BLOCK_READ  = $8A;
	EFU_MODE2_READ_STATUS = $87;

	// MODE1 & MODE2 (To Set SV)
	//		-	MODE1: 0x89 (고정 값: CLOCK WRITE)
	//		- MODE2: 0x84 (고정 값: Setting Value(SV))
	EFU_MODE1_BLOCK_WRITE = $89;
	EFU_MODE2_WRITE_SV    = $84;

	// LV32_ID
  //		- LV32ID: 1 ~ 32, 데이터 전송 시 0x80으로 |(or) 연산
  EFU_LV32ID      = 1;	// Default LV32ID  //TBD:EFU? SystemConfig로 관리 (ReadOnly)

	// ICU_ID
  //		- StartICUID: 1 ~ 32, 데이터 전송 시 0x80으로 |(or) 연산(Start ID는 End ID보다 작거나 같아야 함).
  //		- EndICUID  : 1 ~ 32, 데이터 전송 시 0x80으로 |(or) 연산(End ID는 Start ID보다 크거나 같아야 함).
  EFU_ICUID_MIN   = 1;  // StartICUID
  EFU_ICUID_MAX   = 4;  // 32;

	// DPU_ID
  //		- DPUID: 0x9F (고정 값)
  EFU_DPUID       = $9F; // DPUID: 0x9F (고정 값)

	// ACK_OK
  EFU_SET_OK      = $B9; // Flag(OK): 0xB9 (고정 값)

	// Etc(SV, SV_RPM)
	EFU_SV_MAX  = 140;	// SV : 0 ~ 140  (ex: 1 sv -> 10 rpm, 100 sv -> 1000 rpm)
	EFU_RPM_MAX = 1400;	// RPM: 0 ~ 1400 (ex: 1 sv -> 10 rpm, 100 sv -> 1000 rpm)

	// Etc(Alarm)
	EFU_ALARM_MASK_ALL          = $E2;
  EFU_ALARM_VALUE_NORMAL      = $81;  //Bit7(1:통신연결정상), Bit6(0:모터정상), Bit5(0:과전류정상), Bit1(0:전원정상), Bit0(1:Local제어중)

	EFU_ALARM_MASK_COMM_NORMAL  = $80;	// Bit 7: 통신연결상태:   1=통신정상,   0=통신알람
	EFU_ALARM_MASK_MOTOR        = $40;  // Bit 6: 모터알람상태:   1=모터알람,   0=모터정상
	EFU_ALARM_MASK_OVER_CURRENT = $20;  // Bit 5: 과전류알람상태: 1=과전류알람, 0=과전류정상
																			// Bit 4~2: Not Use
	EFU_ALARM_MASK_POWER        = $02;  // Bit 1: 전원알람상태:   1=전원알람,   0=전원정상
	EFU_ALARM_MASK_LOCAL_CTL    = $01;  // Bit 0: Local|Remote:   1=Local제어중,0=Remote제어중

  EFU_ALIVECHECK_TIMESEC	= 5;		// Default EFU Alie Check Cyclic Timer Value(Sec)    //TBD:EFU? SystemConfig로 관리 (ReadOnly)
  EFU_STATUSWAIT_TIMESEC	= 2;		// Default EFU Status Response Wait Timer Value(Sec) //TBD:EFU? SystemConfig로 관리 (ReadOnly)

implementation

end.

