unit DefIonizer;

interface
{$I Common.inc}

const

//******************************************************************************
//
// << IONIZER : SBL_12A/SBL-15S (RS485 Communication) >>
//
// 1. Serial Port
//    - Data Bits    : 8Bit
//		- Parity       : None
//		- Stop Bit     : 1 Stop Bit
//		- Baud rate    : 9,600 bps
//		- Flow Control : None
//
// 2. Command
// 2.1 Data Request/Response
//   1) Data Request (PC --> SBL-15S)
//      Byte: 00 01 02 03 04 05 06 07 08 09 10 11 12 13
//      Code: $  C  2  ,  R  E  Q  ,  A  *  h  h  \r \n
//        Byte#  Information     Bytes  Values        Remarks
//        ------+---------------+------+-------------+-------------
//        00     Start Code        1
//        01     Product Type      1    C(BlowerType) A(Photo),B(Bar),C(Blower)
//        02     Ionizer Model     1    2             2(SBL-15S), 5(SBL-12A)
//        04~05  Command           3    REQ           REQ(DataRequest),RUN(Run),STP(Stop),CLN(TipCleaning)
//        08     Blower Address    1    1~8
//        09     End Code          1    *
//        10~11  Checksum          2                  $이후~*이전 XOR값(Byte# 1~8)
//        12~13  LineFeed+NewLine  2
//   2) Data Response (PC <-- SBL-15S|SBL-20W)
//      Byte: 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
//      Code: $  C  2  ,  A  ,  0  ,  0  ,  0  ,  0  ,  0  ,  TC , A/S , R/S *  h  h  \r \n
//      e.g.) $C2,1,0,0,0,0,4,0,0,1*22
//		  e.g.) $C6,1,0,0,0,0,4,0,0,1*22
//        Byte#  Information     Bytes  Values        Remarks
//        ------+---------------+------+-------------+-------------
//        00     Start Code        1
//        01     Product Type      1    C(BlowerType) A(Photo),B(Bar),C(Blower)
//        02     Ionizer Model     1    2             2(SBL-15S), 5(SBL-12A)
//        04     Blower Address    1    1~8
//        06     Reserved          1    0
//        08     Reserved          1    0
//        10     Reserved          1    0
//        12     Reserved          1    0
//        14     Reserved          1    0
//        16     Tip Clean State   1    0 or 1        0(Normal),1(TipCleaning)
//        18     Alarm State       1    0 or 1        0(Normal),1(Alarm)
//        20     Run/Stop State    1    0 or 1        0(Stop),1(Run)
//        21     End Code          1
//        22~23  Checksum          2
//        24~25  LineFeed+NewLine  2
// 2.2 Run
//   1) Run Request (PC --> SBL-15S)
//      Byte: 00 01 02 03 04 05 06 07 08 09 10 11 12 13
//      Code: $  C  2  ,  R  U  N  ,  A  *  h  h  \r \n
//   2) Run Response (PC <-- SBL-15S)
//      none
// 2.3 Stop
//   1) Stop Request (PC --> SBL-15S)
//      Byte: 00 01 02 03 04 05 06 07 08 09 10 11 12 13
//      Code: $  C  2  ,  S  T  P  ,  A  *  h  h  \r \n
//   2) Stop Response (PC <-- SBL-15S)
//      none
// 2.4 TIP Cleaning
//   1) TIP Cleaning Request (PC --> SBL-15S)
//      Byte: 00 01 02 03 04 05 06 07 08 09 10 11 12 13
//      Code: $  C  2  ,  C  L  N  ,  A  *  h  h  \r \n
//   2) TIP Cleaning Response (PC <-- SBL-15S)
//      none
//
//******************************************************************************

  //
  ION_MAX = 3;  // A2CHv4(2xCH), else (1xCH)

	// Ionizer Product Model
  ION_SBL_12A      = 'SBL-12A';
  ION_SBL_15S      = 'SBL-15S';
  ION_SBL_20W      = 'SBL-20W';  //2021-05-26
  ION_SIB5S      = 'SIB5S';  //2021-05-26

  // Ionizer Communication Protocol
  //  - Product Type  : A(Photo),B(Bar),C(Blower)
  //  - Ionizer Model : 2(SBL-15S), 5(SBL-12A), 6(SBL-20W)
  ION_CMD_TYPE_SBL15S = 'C2';
  ION_CMD_TYPE_SBL12A = 'C5';
  ION_CMD_TYPE_SBL20W = 'C6';  //2021-05-26
  ION_CMD_TYPE_SIB5S = 'BB';  // Added by Kimjs007 2024-02-06 ?? 5:03:54


	// Ionizer Control Command
  ION_CMD_DATAREQ  = 'REQ';
  ION_CMD_RUN      = 'RUN';
  ION_CMD_STOP     = 'STP';
  IOM_CMD_TIPCLEAN = 'CLN';

	// Ionizer Blower Address
	ION_BLOWER_ADDR_MIN = 1;
	ION_BLOWER_ADDR_MAX = 8;

  //
  ION_ALIVECHECK_TIMESEC	= 2;		// Default ION Alive Check Cyclic Timer Value(Sec)
  ION_STATUSWAIT_TIMESEC	= 1;		// Default ION Status Response Wait Timer Value(Sec)

implementation

end.

