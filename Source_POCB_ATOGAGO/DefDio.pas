unit DefDio;

interface
{$I Common.inc}

//==============================================================================
// A2CH DIO Controller
//    품번        품목명          규격                                                수량
//    K62-00041   BPHR            PCI Half Sized Carrier Board(2Socket, 2Connector)   1EA
//    K62-00042   SIO-DI32        Isolated 32CH Digital Input Control Module          1EA
//    K62-00043   SIO-DO32P       Isolated 32CH Digital Output Control Module         1EA
//    K62-00044   APC-EI36 V1.2   36Pin Digital Input Terminal Block, Screw Type      1EA
//    K62-00045   APC-EO36 V1.2   36Pin Digital Output Terminal Block, Screw Type     1EA
//
// F2CH|A2CHv2|A2CHv3|A2CHv4 DIO Controller
//    품번        품목명          규격                                                수량
//    K62-00041   BPFR            PCI Full Sized Carrier Board(4Socket, 4Connector)   1EA
//    K62-00042   SIO-DI32        Isolated 32CH Digital Input Control Module          2EA
//    K62-00043   SIO-DO32P       Isolated 32CH Digital Output Control Module         2EA
//    K62-00044   APC-EI36 V1.2   36Pin Digital Input Terminal Block, Screw Type      2EA
//    K62-00045   APC-EO36 V1.2   36Pin Digital Output Terminal Block, Screw Type     2EA
//    K71-00065   C6836-3TS       68Pin to 36Pin Twisted Shielded Cale, 3M            4EA
//==============================================================================

{$IF Defined(USE_DIO_AXD) or Defined(USE_DIO_AXL)}
uses AXHS;
  // AXL : 초기화 등의 기초함수.
  // AXM : 모터 관련.
  // AXD : Digital I/O
  // AXA : Analog I/O.
{$ENDIF}
const

//==============================================================================
// Common
//==============================================================================

{$IFDEF POCB_A2CH}
  DIO_MODULENO_DIO_IN   = 0; //A2CH
  DIO_MODULENO_DIO_OUT  = 1; //A2CH
{$ELSE}
  DIO_MODULENO_DIO_IN   = 0; //F2CH|A2CHv2|A2CHv3
  DIO_MODULENO_DIO_OUT  = 2; //F2CH|A2CHv2|A2CHv3 (BPFR Connection 연결 순서)
{$ENDIF}

{$IFDEF USE_DIO_ADLINK}
  TYPE_CARD_7230      = 1;
  TYPE_CARD_7250      = 2; //TBD?  Normal use it.
{$ELSE}
  // AJINEXTEK
  //  - LGDVH 818 L2/점등 : SIO - DB 32 Model 사용, 디지털 입출력 모듈 디지털 입력(16)/출력(16)
  //  - LGDVH E5 광보     : PCI-DO64R, PCI-DI64R 사용
  //  - LGDVH Auto P2CH   : PCI-DB64R (IN 32CH + OUT 32CH)
  DONGA_16X16_CH      = 1;  // 16 CH: Card 1개 사용 // ISPD_A
  DONGA_32X32_CH      = 1;  // 32 CH: Card 1개 사용 // POCB_A2CH
  DONGA_60X60_CH      = 2;  // 60 CH: Card 2개 사용 // ISPD_OPTIC(_GIB)
  //
  MAX_MODULE_NO       = 32; // POCB_A2CH
{$ENDIF}

    // FrmMain: ShowDio???
  MODE_DIO_CONNECT    = 1;     //TBD?

  CARDNUMBER_1        = 0;  // For DIO Initial
//CARDNUMBER_2        = 1;  // For DIO Initial  // POCB_A2CH (1 PCI-DB64R, IN 32CH + OUT 32CH)

{$IFDEF POCB_A2CH}
    DIO_MODULE_MAX      = 1;  //A2CH
    DIO_IN_MODULE_CNT   = 1;  //A2CH
    DIO_OUT_MODULE_CNT  = 1;  //A2CH
{$ELSE}
    DIO_MODULE_MAX      = 3;  //F2CH|A2CHv2|A2CHv3
    DIO_IN_MODULE_CNT   = 2;  //F2CH|A2CHv2|A2CHv3
    DIO_OUT_MODULE_CNT  = 2;  //F2CH|A2CHv2|A2CHv3
{$ENDIF}

    //
    DIO_IN_VALUE        = 0;  //TBD?
    DIO_OUT_VALUE       = 1;

    //
    DOPORT              = 0;
    DIPORT              = 0;
{$IFDEF POCB_A2CH}
    MAX_DIO_CNT         = 32; //A2CH
{$ELSE}
    MAX_DIO_CNT         = 64; //F2CH|A2CHv2|A2CHv3
{$ENDIF}

    DIO_OUT_BITpMODULE  = 32;

    DIO_IDX_GET_TT_START    = 0;
    DIO_IDX_GET_TT_FORWARD  = 1;
    DIO_IDX_GET_TT_SHT_DN   = 2;
    DIO_IDX_GET_TT_CAM_RESET = 3;
    DIO_IDX_GET_TT_SHT_UP   = 4;
    DIO_IDX_GET_TT_BACKWARD = 5;
//==============================================================================
// DIO-IN
//==============================================================================

{$IF Defined(POCB_A2CH)} //-----------------------------------------------------
    MASK_DIO_IN_ALARMS          = $0001fffc; //A2CH (IN_EMS ~ IN_MC2)

    IN_STAGE1_READY             = 0;
    IN_STAGE2_READY             = 1;
    IN_EMS                      = 2;
    IN_TEACH_MODE_SWITCH        = 3;    // 1:Teach(Key1 or Key2가 Teach인 경우), 0:Auto
    IN_LIGHT_CURTAIN            = 4;
    IN_DOOR_LEFT                = 5;
    IN_DOOR_RIGHT               = 6;
    IN_DOOR_UNDER               = 7;
    IN_LEFT_FAN_IN              = 8;
    IN_RIGHT_FAN_IN             = 9;
    IN_LEFT_FAN_OUT             = 10;
    IN_RIGHT_FAN_OUT            = 11;
    IN_TEMPERATURE_ALARM        = 12;
    IN_POWER_HIGH_ALARM         = 13;
    IN_MAIN_REGULATOR           = 14;
    IN_MC1                      = 15;
    IN_MC2                      = 16;
    IN_STAGE1_SHUTTER_UP        = 17;
    IN_STAGE1_SHUTTER_DOWN      = 18;
    IN_STAGE2_SHUTTER_UP        = 19;
    IN_STAGE2_SHUTTER_DOWN      = 20;
    IN_STAGE1_VACUUM_1          = 21; // Stage1 - Active Area Gage.
    IN_STAGE1_VACUUM_2          = 22; // Stage1 - Outside Active Area Gage.
    IN_STAGE2_VACUUM_1          = 23; // Stage2 - Active Area Gage.
    IN_STAGE2_VACUUM_2          = 24; // Stage2 - Outside Active Area Gage.
    IN_STAGE1_EXLIGHT_DETECT    = 25; // Stage1 - ExLight
    IN_STAGE2_EXLIGHT_DETECT    = 26; // Stage2 - ExLight
    IN_STAGE1_PINBLOCK_CLOSE    = 27; //F2CH
    IN_STAGE2_PINBLOCK_CLOSE    = 28; //F2CH
    MAX_DIO_IN                  = IN_STAGE2_PINBLOCK_CLOSE;

    MASK_IN_STAGE1_READY        = $1;
    MASK_IN_STAGE2_READY        = $2;
    MASK_IN_EMS                 = $4;
    MASK_IN_TEACH_MODE_SWITCH   = $8;    // 1:Teach(Key1 or Key2가 Teach인 경우), 0:Auto
    MASK_IN_LIGHT_CURTAIN       = $10;
    MASK_IN_DOOR_LEFT           = $20;
    MASK_IN_DOOR_RIGHT          = $40;
    MASK_IN_DOOR_UNDER          = $80;
    MASK_IN_LEFT_FAN_IN         = $100;
    MASK_IN_RIGHT_FAN_IN        = $200;
    MASK_IN_LEFT_FAN_OUT        = $400;
    MASK_IN_RIGHT_FAN_OUT       = $800;
    MASK_IN_TEMPERATURE_ALARM   = $1000;
    MASK_IN_POWER_HIGH_ALARM    = $2000;
    MASK_IN_MAIN_REGULATOR      = $4000;
    MASK_IN_MC1                 = $8000;
    MASK_IN_MC2                 = $10000;
    MASK_IN_STAGE1_SHUTTER_UP   = $20000;
    MASK_IN_STAGE1_SHUTTER_DOWN = $40000;
    MASK_IN_STAGE2_SHUTTER_UP   = $80000;
    MASK_IN_STAGE2_SHUTTER_DOWN = $100000;
    MASK_IN_STAGE1_VACUUM_1     = $200000;   // Stage1 - Active Area Gage.
    MASK_IN_STAGE1_VACUUM_2     = $400000;   // Stage1 - Outside Active Area Gage.
    MASK_IN_STAGE2_VACUUM_1     = $800000;   // Stage2 - Active Area Gage.
    MASK_IN_STAGE2_VACUUM_2     = $1000000;  // Stage2 - Outside Active Area Gage.
    MASK_IN_STAGE1_EXLIGHT_DETECT = $2000000;  // Stage1 - ExLight
    MASK_IN_STAGE2_EXLIGHT_DETECT = $4000000;  // Stage1 - ExLight
    MASK_IN_STAGE1_PINBLOCK_CLOSE = $8000000; //F2CH (2019-03-08)
    MASK_IN_STAGE2_PINBLOCK_CLOSE = $10000000; //F2CH (2019-03-08)

{$ELSEIF Defined(POCB_A2CHv2)}  //----------------------------------------------
    MASK_DIO_IN_ALARMS          = $00000009fffffffc; //F2CH (IN_EMS ~ IN_MC2)

    IN_STAGE1_READY             = 0;
    IN_STAGE2_READY             = 1;
    IN_EMS                      = 6;
    IN_LEFT_SWITCH              = 8;  //new for F2CH (1:Teach, 0:Auto) //TBD:F2CH: 2019-03-06 (GM장비 배선 Left/Right 바뀜)
    IN_RIGHT_SWITCH             = 7;  //new for F2CH (1:Teach, 0:Auto) //TBD:F2CH: 2019-03-06 (GM장비 배선 Left/Right 바뀜)
    IN_STAGE1_LIGHT_CURTAIN     = 9;  //new for F2CH
    IN_STAGE2_LIGHT_CURTAIN     = 10; //new for F2CH
    IN_DOOR_LEFT                = 11;
    IN_DOOR_RIGHT               = 12;
    IN_DOOR_UNDER_LEFT1         = 13;  //F2CH
    IN_DOOR_UNDER_LEFT2         = 14;  //F2CH
    IN_DOOR_UNDER_RIGHT1        = 15;  //F2CH
    IN_DOOR_UNDER_RIGHT2        = 16;  //F2CH
    IN_LEFT_FAN_IN              = 17;
    IN_RIGHT_FAN_IN             = 18;
    IN_LEFT_FAN_OUT             = 19;
    IN_RIGHT_FAN_OUT            = 20;
    IN_TEMPERATURE_ALARM        = 21;
    IN_POWER_HIGH_ALARM         = 22;
    IN_CYLINDER_REGULATOR       = 23; //F2CH: CylinderRegulator: 1(OK), 0(NG)
    IN_VACUUM_REGULATOR         = 24; //F2CH: VacuumRegulator:   1(OK), 0(NG)
    IN_STAGE1_SHUTTER_UP        = 25;
    IN_STAGE1_SHUTTER_DOWN      = 26;
    IN_STAGE2_SHUTTER_UP        = 27;
    IN_STAGE2_SHUTTER_DOWN      = 28;
    IN_STAGE1_VACUUM_1          = 29; // Stage1 - Active Area Sol.
    IN_STAGE1_VACUUM_2          = 30; // Stage1 - Outside Active Area Sol.
    IN_STAGE2_VACUUM_1          = 31; // Stage2 - Active Area Sol.
    IN_STAGE2_VACUUM_2          = 32; // Stage2 - Outside Active Area Sol.
    IN_MC1                      = 33;
    IN_MC2                      = 34;
    IN_STAGE1_Y_AXIS_HOME       = 35;
    IN_STAGE2_Y_AXIS_HOME       = 36;
    IN_STAGE1_Z_AXIS_HOME       = 37;
    IN_STAGE2_Z_AXIS_HOME       = 38;
    IN_STAGE1_PINBLOCK_CLOSE    = 41; //F2CH
    IN_STAGE2_PINBLOCK_CLOSE    = 42; //F2CH
  {$IFDEF HAS_DIO_EXLIGHT_DETECT}
    IN_STAGE1_EXLIGHT_DETECT    = 43;
    IN_STAGE2_EXLIGHT_DETECT    = 44;
    MAX_DIO_IN                  = IN_STAGE2_EXLIGHT_DETECT;
  {$ELSE}
    MAX_DIO_IN                  = IN_STAGE2_PINBLOCK_CLOSE;
  {$ENDIF}

    MASK_IN_STAGE1_READY             = $1;
    MASK_IN_STAGE2_READY             = $2;
    MASK_IN_EMS                      = $40;
    MASK_IN_LEFT_SWITCH              = $80;  //new for F2CH (1:Teach, 0:Auto)
    MASK_IN_RIGHT_SWITCH             = $100;  //new for F2CH (1:Teach, 0:Auto)
    MASK_IN_STAGE1_LIGHT_CURTAIN     = $200;  //new for F2CH
    MASK_IN_STAGE2_LIGHT_CURTAIN     = $400; //new for F2CH
    MASK_IN_DOOR_LEFT                = $800;
    MASK_IN_DOOR_RIGHT               = $1000;
    MASK_IN_DOOR_UNDER_LEFT1         = $2000;  //new for F2CH
    MASK_IN_DOOR_UNDER_LEFT2         = $4000;  //new for F2CH
    MASK_IN_DOOR_UNDER_RIGHT1        = $8000;  //new for F2CH
    MASK_IN_DOOR_UNDER_RIGHT2        = $10000;  //new for F2CH
    MASK_IN_LEFT_FAN_IN              = $20000;
    MASK_IN_RIGHT_FAN_IN             = $40000;
    MASK_IN_LEFT_FAN_OUT             = $80000;
    MASK_IN_RIGHT_FAN_OUT            = $100000;
    MASK_IN_TEMPERATURE_ALARM        = $200000;
    MASK_IN_POWER_HIGH_ALARM         = $400000;
    MASK_IN_CYLINDER_REGULATOR       = $800000; //new for F2CH  //1:OK, 0:NG
    MASK_IN_VACUUM_REGULATOR         = $1000000; //new for F2CH  //1:OK, 0:NG
    MASK_IN_STAGE1_SHUTTER_UP        = $2000000;
    MASK_IN_STAGE1_SHUTTER_DOWN      = $4000000;
    MASK_IN_STAGE2_SHUTTER_UP        = $8000000;
    MASK_IN_STAGE2_SHUTTER_DOWN      = $10000000;
    MASK_IN_STAGE1_VACUUM_1          = $20000000; // Stage1 - Active Area Sol.
    MASK_IN_STAGE1_VACUUM_2          = $40000000; // Stage1 - Outside Active Area Sol.
    MASK_IN_STAGE2_VACUUM_1          = $80000000; // Stage2 - Active Area Sol.
    MASK_IN_STAGE2_VACUUM_2          = $100000000; // Stage2 - Outside Active Area Sol.
    MASK_IN_MC1                      = $200000000;
    MASK_IN_MC2                      = $400000000;
    MASK_IN_STAGE1_Y_AXIS_HOME       = $800000000;
    MASK_IN_STAGE2_Y_AXIS_HOME       = $1000000000;
    MASK_IN_STAGE1_Z_AXIS_HOME       = $2000000000;
    MASK_IN_STAGE2_Z_AXIS_HOME       = $4000000000;
    MASK_IN_STAGE1_TILTING_AXIS_HOME = $8000000000;
    MASK_IN_STAGE2_TILTING_AXIS_HOME = $10000000000;
    MASK_IN_STAGE1_PINBLOCK_CLOSE    = $20000000000; //F2CH (2019-03-08)
    MASK_IN_STAGE2_PINBLOCK_CLOSE    = $40000000000; //F2CH (2019-03-08)
  {$IFDEF HAS_DIO_EXLIGHT_DETECT}
    MASK_IN_STAGE1_EXLIGHT_DETECT    = $80000000000;
    MASK_IN_STAGE2_EXLIGHT_DETECT    = $100000000000;
  {$ENDIF}

{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}  //----------------------------------------------
    IN_STAGE1_READY              = 0;
    IN_STAGE2_READY              = 1;
    IN_EMO1_FRONT                = 2;  // A2CHv3|A2CHv4(IN_EMO1~IN_EMO5), A2CHv2(IN_EMS)
    IN_EMO2_RIGHT                = 3;  // A2CHv3|A2CHv4(IN_EMO1~IN_EMO5), A2CHv2(IN_EMS)
    IN_EMO3_INNER_RIGHT          = 4;  // A2CHv3|A2CHv4(IN_EMO1~IN_EMO5), A2CHv2(IN_EMS)
    IN_EMO4_INNER_LEFT           = 5;  // A2CHv3|A2CHv4(IN_EMO1~IN_EMO5), A2CHv2(IN_EMS)
    IN_EMO5_LEFT                 = 6;  // A2CHv3|A2CHv4(IN_EMO1~IN_EMO5), A2CHv2(IN_EMS)
	{$IFDEF HAS_DIO_IN_DOOR_LOCK}
    IN_STAGE1_DOOR1_LOCK         = 7;  // A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    IN_STAGE1_DOOR2_LOCK         = 8;  // A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    IN_STAGE2_DOOR1_LOCK         = 9;  // A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    IN_STAGE2_DOOR2_LOCK         = 10; // A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
  {$ELSE}
  //IN_LEFT_FAN_IN               = 7;  // A2CHv3|A2CHv4(Fan-In/Out:7~10 --> 57~60)
  //IN_RIGHT_FAN_IN              = 8;
  //IN_LEFT_FAN_OUT              = 9;
  //IN_RIGHT_FAN_OUT             = 10;
  {$ENDIF}
    IN_STAGE1_MUTING_LAMP        = 11; // A2CHv3(CH1 Light Curtain Disable), A2CHv2(---) //TBD:A2CHv3:DIO?
    IN_STAGE2_MUTING_LAMP        = 12; // A2CHv3(CH2 Light Curtain Disable), A2CHv2(---) //TBD:A2CHv3:DIO?
    IN_STAGE1_LIGHT_CURTAIN      = 13;
    IN_STAGE2_LIGHT_CURTAIN      = 14;
    IN_STAGE1_KEY_AUTO           = 15; // A2CHv3(CH1 AUTOMODE+TEACHMODE), A2CHv2(---)             //TBD:A2CHv3:DIO?
    IN_STAGE1_KEY_TEACH          = 16; // A2CHv3(CH1 AUTOMODE+TEACHMODE), A2CHv2(IN_LEFT_SWITCH)  //TBD:A2CHv3:DIO?
    IN_STAGE2_KEY_AUTO           = 17; // A2CHv3(CH1 AUTOMODE+TEACHMODE), A2CHv2(---)             //TBD:A2CHv3:DIO?
    IN_STAGE2_KEY_TEACH          = 18; // A2CHv3(CH1 AUTOMODE+TEACHMODE), A2CHv2(IN_RIGHT_SWITCH) //TBD:A2CHv3:DIO?
    IN_STAGE1_DOOR1_OPEN         = 19; // A2CHv3(CH1 MAINT_DOOR1+MAINT_DOOR2), A2CHv2(CH1 LEFT+UNDER_LEFT1+UNDER_LEFT2)    //TBD:A2CHv3:DIO?
    IN_STAGE1_DOOR2_OPEN         = 20; // A2CHv3(CH1 MAINT_DOOR1+MAINT_DOOR2), A2CHv2(CH1 LEFT+UNDER_LEFT1+UNDER_LEFT2)    //TBD:A2CHv3:DIO?
    IN_STAGE2_DOOR1_OPEN         = 21; // A2CHv3(CH2 MAINT_DOOR1+MAINT_DOOR2), A2CHv2(CH1 RIGHT+UNDER_RIGHT1+UNDER_RIGHT2) //TBD:A2CHv3:DIO?
    IN_STAGE2_DOOR2_OPEN         = 22; // A2CHv3(CH2 MAINT_DOOR1+MAINT_DOOR2), A2CHv2(CH1 RIGHT+UNDER_RIGHT1+UNDER_RIGHT2) //TBD:A2CHv3:DIO?
    IN_CYLINDER_REGULATOR        = 23; // 1:OK, 0:NG
    IN_TEMPERATURE_ALARM         = 24;
    IN_POWER_HIGH_ALARM          = 25;
    IN_MC1                       = 26;
                                       // A2CHv3 (CH1/CH2 SHUTTER/SCREW_SHUTTER/SHUTTER_GUIDE, CAMZONE_PARTITION_UP1/UP2, CALZONE_INNER_DOOR_OPEN/CLOSE
    IN_STAGE1_SHUTTER_UP         = 27;
    IN_STAGE1_SHUTTER_DOWN       = 28;
    IN_STAGE2_SHUTTER_UP         = 29;
    IN_STAGE2_SHUTTER_DOWN       = 30;
	{$IFDEF HAS_DIO_SCREW_SHUTTER}
    IN_STAGE1_SCREW_SHUTTER_UP   = 31; // A2CHv3|A2CHv4_#1&#2 ,A2CHv4_#3(NoScrewShutter)
    IN_STAGE1_SCREW_SHUTTER_DOWN = 32; // A2CHv3|A2CHv4_#1&#2 ,A2CHv4_#3(NoScrewShutter)
    IN_STAGE2_SCREW_SHUTTER_UP   = 33; // A2CHv3|A2CHv4_#1&#2 ,A2CHv4_#3(NoScrewShutter)
    IN_STAGE2_SCREW_SHUTTER_DOWN = 34; // A2CHv3|A2CHv4_#1&#2 ,A2CHv4_#3(NoScrewShutter)
	{$ENDIF}
  {$IFDEF SUPPORT_1CG2PANEL} //A2CHv3
    IN_SHUTTER_GUIDE_UP          = 35; // A2CHv3
    IN_SHUTTER_GUIDE_DOWN        = 36; // A2CHv3
    IN_CAMZONE_PARTITION_UP1     = 37; // A2CHv3
    IN_CAMZONE_PARTITION_UP2     = 38; // A2CHv3
    IN_CAMZONE_PARTITION_DOWN1   = 39; // A2CHv3
    IN_CAMZONE_PARTITION_DOWN2   = 40; // A2CHv3
	{$ELSE} //A2CHv4
		{$IFDEF HAS_DIO_FAN_INOUT_PC}
    IN_MAINPC_FAN_IN             = 35; //2022-07-15 A2CHv4_#3(FanInOutPC)
    IN_MAINPC_FAN_OUT            = 36; //2022-07-15 A2CHv4_#3(FanInOutPC)
    IN_CAMPC_FAN_IN              = 37; //2022-07-15 A2CHv4_#3(FanInOutPC)
    IN_CAMPC_FAN_OUT             = 38; //2022-07-15 A2CHv4_#3(FanInOutPC)
  //----                         = 39; 
  //----                         = 40;
    {$ENDIF}
  {$ENDIF}
	{$IFDEF HAS_DIO_EXLIGHT_DETECT}
    IN_STAGE1_EXLIGHT_DETECT     = 41; // A2CHv3|A2CHv4_#1&#2 ,A2CHv4_#3(NoExLightDetectSensor)
    IN_STAGE2_EXLIGHT_DETECT     = 42; // A2CHv3|A2CHv4_#1&#2 ,A2CHv4_#3(NoExLightDetectSensor)
  {$ENDIF}
    IN_STAGE1_WORKING_ZONE       = 43; // A2CHv3(CH1 Motion LoadingPositionSensor Detected)
    IN_STAGE2_WORKING_ZONE       = 44; // A2CHv3(CH2 Motion LoadingPositionSensor Detected)
    IN_STAGE1_VACUUM1            = 45; // Stage1 - Active Area Sol.
    IN_STAGE1_VACUUM2            = 46; // Stage1 - Outside Active Area Sol.
    IN_STAGE2_VACUUM1            = 47; // Stage2 - Active Area Sol.
    IN_STAGE2_VACUUM2            = 48; // Stage2 - Outside Active Area Sol.
    IN_CP1                       = 49;
    IN_CP2                       = 50;
    IN_CP3                       = 51;
    IN_CP6                       = 52;

  {$IFDEF SUPPORT_1CG2PANEL}
    IN_CAMZONE_INNER_DOOR_OPEN   = 49; // A2CHv3
    IN_CAMZONE_INNER_DOOR_CLOSE  = 50; // A2CHv3
    IN_STAGE1_JIG_INTERLOCK      = 51; // A2CHv3(조립용JIG감지 on CH1-Stage)
    IN_STAGE2_JIG_INTERLOCK      = 52; // A2CHv3(조립용JIG감지 on CH2-Stage)
  {$ENDIF}
    IN_MC2                       = 53;
    IN_VACUUM_REGULATOR          = 54;
  {$IFDEF SUPPORT_1CG2PANEL}
    IN_LOADZONE_PARTITION1       = 55;
    IN_LOADZONE_PARTITION2       = 56;
  {$ENDIF}
  //IN_STAGE1_PINBLOCK_CLOSE     = xx; // A2CHv3(---), A2CHv2(CH1_PINBLOCK_CLOSE)
  //IN_STAGE2_PINBLOCK_CLOSE     = xx; // A2CHv3(---), A2CHv2(CH2_PINBLOCK_CLOSE)
    IN_LEFT_FAN_IN               = 57; // A2CHv3|A2CHv4: 7-->57 //2021-01-11
    IN_RIGHT_FAN_IN              = 58; // A2CHv3|A2CHv4: 8-->58 //2021-01-11
    IN_LEFT_FAN_OUT              = 59; // A2CHv3|A2CHv4: 9-->59 //2021-01-11
    IN_RIGHT_FAN_OUT             = 60; // A2CHv3|A2CHv4:10-->60 //2021-01-11
  {$IFDEF HAS_DIO_Y_AXIS_MC}
    IN_STAGE1_Y_AXIS_MC          = 61; // 2024.01~
    IN_STAGE2_Y_AXIS_MC          = 62; // 2024.01~
    MAX_DIO_IN                   = IN_STAGE2_Y_AXIS_MC;
  {$ELSE}
    MAX_DIO_IN                   = IN_RIGHT_FAN_OUT;
  {$ENDIF}

    MASK_IN_STAGE1_READY              = $1;
    MASK_IN_STAGE2_READY              = $2;
    MASK_IN_EMO1_FRONT                = $4;
    MASK_IN_EMO2_RIGHT                = $8;
    MASK_IN_EMO3_INNER_RIGHT          = $10;
    MASK_IN_EMO4_INNER_LEFT           = $20;
    MASK_IN_EMO5_LEFT                 = $40;
	{$IFDEF HAS_DIO_IN_DOOR_LOCK}
    MASK_IN_STAGE1_DOOR1_LOCK         = $80;   // A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    MASK_IN_STAGE1_DOOR2_LOCK         = $100;  // A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    MASK_IN_STAGE2_DOOR1_LOCK         = $200;  // A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
    MASK_IN_STAGE2_DOOR2_LOCK         = $400;  // A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
  {$ELSE}
  //MASK_IN_LEFT_FAN_IN               = $80;
  //MASK_IN_RIGHT_FAN_IN              = $100;
  //MASK_IN_LEFT_FAN_OUT              = $200;
  //MASK_IN_RIGHT_FAN_OUT             = $400;
  {$ENDIF}
    MASK_IN_STAGE1_MUTING_LAMP        = $800;
    MASK_IN_STAGE2_MUTING_LAMP        = $1000;
    MASK_IN_STAGE1_LIGHT_CURTAIN      = $2000;
    MASK_IN_STAGE2_LIGHT_CURTAIN      = $4000;
    MASK_IN_STAGE1_SWITCH_AUTOMODE    = $8000;
    MASK_IN_STAGE1_SWITCH_TEACHMODE   = $10000;
    MASK_IN_STAGE2_SWITCH_AUTOMODE    = $20000;
    MASK_IN_STAGE2_SWITCH_TEACHMODE   = $40000;
    MASK_IN_STAGE1_DOOR1_OPEN         = $80000;
    MASK_IN_STAGE1_DOOR2_OPEN         = $100000;
    MASK_IN_STAGE2_DOOR1_OPEN         = $200000;
    MASK_IN_STAGE2_DOOR2_OPEN         = $400000;
    MASK_IN_CYLINDER_REGULATOR        = $800000;
    MASK_IN_TEMPERATURE_ALARM         = $1000000;
    MASK_IN_POWER_HIGH_ALARM          = $2000000;
    MASK_IN_MC1                       = $4000000;
    MASK_IN_STAGE1_SHUTTER_UP         = $8000000;
    MASK_IN_STAGE1_SHUTTER_DOWN       = $10000000;
    MASK_IN_STAGE2_SHUTTER_UP         = $20000000;
    MASK_IN_STAGE2_SHUTTER_DOWN       = $40000000;
	{$IFDEF HAS_DIO_SCREW_SHUTTER}
    MASK_IN_STAGE1_SCREW_SHUTTER_UP   = $80000000;   // A2CHv3|A2CHv4_#1&#2, A2CHv4_#3(NoScrewShutter)
    MASK_IN_STAGE1_SCREW_SHUTTER_DOWN = $100000000;  // A2CHv3|A2CHv4_#1&#2, A2CHv4_#3(NoScrewShutter)
    MASK_IN_STAGE2_SCREW_SHUTTER_UP   = $200000000;  // A2CHv3|A2CHv4_#1&#2, A2CHv4_#3(NoScrewShutter)
    MASK_IN_STAGE2_SCREW_SHUTTER_DOWN = $400000000;  // A2CHv3|A2CHv4_#1&#2, A2CHv4_#3(NoScrewShutter)
	{$ENDIF}
  {$IFDEF SUPPORT_1CG2PANEL}
    MASK_IN_SHUTTER_GUIDE_UP          = $800000000;
    MASK_IN_SHUTTER_GUIDE_DOWN        = $1000000000;
    MASK_IN_CAMZONE_PARTITION_UP1     = $2000000000;
    MASK_IN_CAMZONE_PARTITION_UP2     = $4000000000;
    MASK_IN_CAMZONE_PARTITION_DOWN1   = $8000000000;
    MASK_IN_CAMZONE_PARTITION_DOWN2   = $10000000000;
  {$ELSE}
  	{$IFDEF HAS_DIO_FAN_INOUT_PC}
    MASK_IN_MAINPC_FAN_IN             = $800000000;  //2022-07-15 A2CHv4_#3(FanInOutPC)
    MASK_IN_MAINPC_FAN_OUT            = $1000000000; //2022-07-15 A2CHv4_#3(FanInOutPC)
    MASK_IN_CAMPC_FAN_IN              = $2000000000; //2022-07-15 A2CHv4_#3(FanInOutPC)
    MASK_IN_CAMPC_FAN_OUT             = $4000000000; //2022-07-15 A2CHv4_#3(FanInOutPC)
  //MASK_IN_XXXXXXX_XXXXXXX           = $8000000000;
  //MASK_IN_XXXXXXX_XXXXXXX           = $10000000000;
    {$ENDIF}
  {$ENDIF}
	{$IFDEF HAS_DIO_EXLIGHT_DETECT}
    MASK_IN_STAGE1_EXLIGHT_DETECT     = $20000000000;  // A2CHv3|A2CHv4_#1&#2, A2CHv4_#3(NoExLightDetect)
    MASK_IN_STAGE2_EXLIGHT_DETECT     = $40000000000;  // A2CHv3|A2CHv4_#1&#2, A2CHv4_#3(NoExLightDetect)
  {$ENDIF}
    MASK_IN_STAGE1_WORKING_ZONE       = $80000000000;
    MASK_IN_STAGE2_WORKING_ZONE       = $100000000000;
    MASK_IN_STAGE1_VACUUM1            = $200000000000;
    MASK_IN_STAGE1_VACUUM2            = $400000000000;
    MASK_IN_STAGE2_VACUUM1            = $800000000000;
    MASK_IN_STAGE2_VACUUM2            = $1000000000000;

    MASK_IN_CP1                       = 1 shl IN_CP1;
    MASK_IN_CP2                       = 1 shl IN_CP2;
    MASK_IN_CP3                       = 1 shl IN_CP3;
    MASK_IN_CP6                       = 1 shl IN_CP6;

  {$IFDEF SUPPORT_1CG2PANEL}
    MASK_IN_CAMZONE_INNERT_DOOR_OPEN  = $2000000000000;
    MASK_IN_CAMZONE_INNERT_DOOR_CLOSE = $4000000000000;
    MASK_IN_STAGE1_JIG_INTERLOCK      = $8000000000000;
    MASK_IN_STAGE2_JIG_INTERLOCK      = $10000000000000;
  {$ENDIF}
    MASK_IN_MC2                       = $20000000000000;
    MASK_IN_VACUUM_REGULATOR          = $40000000000000;
  {$IFDEF SUPPORT_1CG2PANEL}
    MASK_IN_LOADZONE_PARTITION1       = $80000000000000;
    MASK_IN_LOADZONE_PARTITION2       = $100000000000000;
  {$ENDIF}
    MASK_IN_LEFT_FAN_IN               = $200000000000000;
    MASK_IN_RIGHT_FAN_IN              = $400000000000000;
    MASK_IN_LEFT_FAN_OUT              = $800000000000000;
    MASK_IN_RIGHT_FAN_OUT             = $1000000000000000;
  {$IFDEF HAS_DIO_Y_AXIS_MC}
    MASK_IN_STAGE1_Y_AXIS_MC          = $2000000000000000; // 2024.01~
    MASK_IN_STAGE2_Y_AXIS_MC          = $4000000000000000; // 2024.01~
  {$ENDIF}

  {$IF Defined(POCB_A2CHv3)}
    MASK_IN_DIO_ALARMS_TEMP1 = $1ffe01f807ffe07c;
  {$ELSE} //A2CHv4|ATO|GAGO
    MASK_IN_DIO_ALARMS_TEMP1 = $1fe0000007ffe07c or MASK_IN_CP1 or MASK_IN_CP2 or MASK_IN_CP3; //TBD:A2CHv4:DIO?
  {$ENDIF}
  {$IFDEF HAS_DIO_IN_DOOR_LOCK}
    MASK_IN_DIO_ALARMS_TEMP2 = MASK_IN_DIO_ALARMS_TEMP1 or (MASK_IN_STAGE1_DOOR1_LOCK or MASK_IN_STAGE1_DOOR2_LOCK or MASK_IN_STAGE2_DOOR1_LOCK or MASK_IN_STAGE1_DOOR2_LOCK);
  {$ELSE}
    MASK_IN_DIO_ALARMS_TEMP2 = MASK_IN_DIO_ALARMS_TEMP1;
  {$ENDIF}
  {$IFDEF HAS_DIO_Y_AXIS_MC}
    MASK_IN_DIO_ALARMS_TEMP3 = MASK_IN_DIO_ALARMS_TEMP2 or (MASK_IN_STAGE1_Y_AXIS_MC or MASK_IN_STAGE2_Y_AXIS_MC);
  {$ELSE}
    MASK_IN_DIO_ALARMS_TEMP3 = MASK_IN_DIO_ALARMS_TEMP2;
  {$ENDIF}
    MASK_IN_DIO_ALARMS = MASK_IN_DIO_ALARMS_TEMP3; //!!!

    MASK_IN_EMO_ALL = $7C; // = (MASK_IN_EMO1_FRONT or MASK_IN_EMO2_RIGHT or MASK_IN_EMO3_INNER_RIGHT or MASK_IN_EMO4_INNER_LEFT or MASK_IN_EMO5_LEFT)

    MASK_IN_DIO_THREASHOLD_ALARMS =  $1E4000000380007C;  // =  (MASK_IN_EMO1_FRONT or MASK_IN_EMO2_RIGHT or MASK_IN_EMO3_INNER_RIGHT or MASK_IN_EMO4_INNER_LEFT or MASK_IN_EMO5_LEFT)
                                                         // or (MASK_IN_CYLINDER_REGULATOR or MASK_IN_VACUUM_REGULATOR)
                                                         // or (MASK_IN_TEMPERATURE_ALARM or MASK_IN_POWER_HIGH_ALARM)
                                                         // or (MASK_IN_LEFT_FAN_IN or MASK_IN_RIGHT_FAN_IN or MASK_IN_LEFT_FAN_OUT or MASK_IN_RIGHT_FAN_OUT)

	{$IFDEF HAS_DIO_FAN_INOUT_PC}
    MASK_IN_DIO_PC_FAN_ALARMS = $0000007800000000;       // (MASK_IN_FAN5_MAINPC_IN or MASK_FAN6_MAINPC_OUT or MASK_IN_FAN7_CAMPC_IN or MASK_IN_FAN8_CAMPC_OUT) //2022-07-15 A2CHv4_#3(FanInOutPC)
  {$ENDIF}
{$ENDIF}

//==============================================================================
// DIO-OUT
//==============================================================================

{$IF Defined(POCB_A2CH)} //-----------------------------------------------------
    OUT_STAGE1_READY_LED        = 0;
    OUT_STAGE2_READY_LED        = 1;
    OUT_STAGE1_LED_LAMP         = 2;
    OUT_STAGE2_LED_LAMP         = 3;
    OUT_LAMP_RED                = 4;
    OUT_LAMP_YELLOW             = 5;
    OUT_LAMP_GREEN              = 6;
    OUT_BUZZER                  = 7;
    OUT_DOOR_UNLOCK             = 8;
    OUT_STAGE1_SHUTTER_UP       = 16;
    OUT_STAGE1_SHUTTER_DOWN     = 17;
    OUT_STAGE2_SHUTTER_UP       = 18;
    OUT_STAGE2_SHUTTER_DOWN     = 19;
    OUT_STAGE1_VACUUM1          = 20; // Stage1 - Active Area Sol.
    OUT_STAGE1_VACUUM2          = 21; // Stage1 - Outside Active Area Sol.
    OUT_STAGE2_VACUUM1          = 22; // Stage2 - Active Area Sol.
    OUT_STAGE2_VACUUM2          = 23; // Stage2 - Outside Active Area Sol.
    MAX_DIO_OUT                 = OUT_STAGE2_VACUUM_2;

{$ELSEIF Defined(POCB_A2CHv2)} //-----------------------------------------------
    OUT_STAGE1_READY_LED        = 0;
    OUT_STAGE2_READY_LED        = 1;
    OUT_STAGE1_LED_LAMP         = 2;
    OUT_STAGE2_LED_LAMP         = 3;
    OUT_LAMP_RED                = 4;
    OUT_LAMP_YELLOW             = 5;
    OUT_LAMP_GREEN              = 6;
    OUT_BUZZER                  = 7;
    OUT_DOOR_UNLOCK             = 8;
    OUT_LEFT_LOCK_SWITCH        = 9;  //F2CH|A2CHv2
    OUT_RIGHT_LOCK_SWITCH       = 10; //F2CH|A2CHv2
    OUT_MELODY1                 = 11; //A2CHv2
    OUT_MELODY2                 = 12; //A2CHv2
    OUT_MELODY3                 = 13; //A2CHv2
    OUT_MELODY4                 = 14; //A2CHv2
    OUT_STAGE1_DESTRUCTION_SOL1 = 15;
    OUT_STAGE1_DESTRUCTION_SOL2 = 16;
    OUT_STAGE2_DESTRUCTION_SOL1 = 17;
    OUT_STAGE2_DESTRUCTION_SOL2 = 18;
    OUT_STAGE1_AIR_KNIFE        = 19;
    OUT_STAGE2_AIR_KNIFE        = 20;
    OUT_STAGE1_SHUTTER_UP       = 24;
    OUT_STAGE1_SHUTTER_DOWN     = 25;
    OUT_STAGE2_SHUTTER_UP       = 26;
    OUT_STAGE2_SHUTTER_DOWN     = 27;
    OUT_STAGE1_VACUUM1          = 28; // Stage1 - Active Area Sol.
    OUT_STAGE1_VACUUM2          = 29; // Stage1 - Outside Active Area Sol.
    OUT_STAGE2_VACUUM1          = 30; // Stage2 - Active Area Sol.
    OUT_STAGE2_VACUUM2          = 31; // Stage2 - Outside Active Area Sol.
    MAX_DIO_OUT                 = OUT_STAGE2_VACUUM_2;

{$ELSE} //POCB_A2CHv3|POCB_A2CHv4|POCB_ATO|POCB_GAGO //------------------------------------
    OUT_STAGE1_READY_LED          = 0;
    OUT_STAGE2_READY_LED          = 1;
    OUT_RESET_SW_LED              = 2;
    OUT_STAGE1_SWITCH_UNLOCK      = 3;
    OUT_STAGE2_SWITCH_UNLOCK      = 4;
  //OUT_STAGE1_LED_LAMP           = -; // A2CHv3|A2CHv4: CamZone LED Lamp: by Safety PLC(Door ON -> Lamp On, Door Close -> Lamp Off)
  //OUT_STAGE2_LED_LAMP           = -; // A2CHv3|A2CHv4: CamZone LED Lamp: by Safety PLC(Door ON -> Lamp On, Door Close -> Lamp Off)
    OUT_LAMP_RED                  = 5;
    OUT_LAMP_YELLOW               = 6;
    OUT_LAMP_GREEN                = 7;
    OUT_MELODY1                   = 8;
    OUT_MELODY2                   = 9;
    OUT_MELODY3                   = 10;
    OUT_MELODY4                   = 11;
  //----                          = 12;
  //----                          = 13;
    OUT_STAGE1_MAINT_DOOR1_UNLOCK = 14;
    OUT_STAGE1_MAINT_DOOR2_UNLOCK = 15;
    OUT_STAGE2_MAINT_DOOR1_UNLOCK = 16;
    OUT_STAGE2_MAINT_DOOR2_UNLOCK = 17;
    OUT_STAGE1_SHUTTER_UP         = 18;
    OUT_STAGE1_SHUTTER_DOWN       = 19;
    OUT_STAGE2_SHUTTER_UP         = 20;
    OUT_STAGE2_SHUTTER_DOWN       = 21;
	{$IFDEF HAS_DIO_SCREW_SHUTTER}
    OUT_STAGE1_SCREW_SHUTTER_UP   = 22;  // A2CHv3|A2CHv4_#1&#2 A2CHv4_#3(NoScrewShutter)
    OUT_STAGE1_SCREW_SHUTTER_DOWN = 23;  // A2CHv3|A2CHv4_#1&#2 A2CHv4_#3(NoScrewShutter)
    OUT_STAGE2_SCREW_SHUTTER_UP   = 24;  // A2CHv3|A2CHv4_#1&#2 A2CHv4_#3(NoScrewShutter)
    OUT_STAGE2_SCREW_SHUTTER_DOWN = 25;  // A2CHv3|A2CHv4_#1&#2 A2CHv4_#3(NoScrewShutter)
	{$ENDIF}
  {$IFDEF SUPPORT_1CG2PANEL}
    OUT_SHUTTER_GUIDE_UP          = 26;
    OUT_SHUTTER_GUIDE_DOWN        = 27;
  {$ENDIF}
    OUT_STAGE1_VACUUM1            = 28; // Stage1 - Active Area Sol.
    OUT_STAGE1_VACUUM2            = 29; // Stage1 - Outside Active Area Sol.
    OUT_STAGE2_VACUUM1            = 30; // Stage2 - Active Area Sol.
    OUT_STAGE2_VACUUM2            = 31; // Stage2 - Outside Active Area Sol.
    OUT_STAGE1_DESTRUCTION_SOL1   = 32;
    OUT_STAGE1_DESTRUCTION_SOL2   = 33;
    OUT_STAGE2_DESTRUCTION_SOL1   = 34;
    OUT_STAGE2_DESTRUCTION_SOL2   = 35;
    OUT_STAGE1_ROBOT_STICK_PLUS   = 36; //ROBOT //A2CHv3|A2CHv4
    OUT_STAGE1_ROBOT_STICK_MINUS  = 37; //ROBOT //A2CHv3|A2CHv4
    OUT_STAGE1_ROBOT_MANUAL_AUTO  = 38; //ROBOT //A2CHv3|A2CHv4
    OUT_STAGE1_ROBOT_PAUSE        = 39; //ROBOT //A2CHv3|A2CHv4
    OUT_STAGE1_ROBOT_RESET        = 40; //ROBOT //A2CHv3|A2CHv4
    OUT_STAGE2_ROBOT_STICK_PLUS   = 41; //ROBOT //A2CHv3|A2CHv4
    OUT_STAGE2_ROBOT_STICK_MINUS  = 42; //ROBOT //A2CHv3|A2CHv4
    OUT_STAGE2_ROBOT_MANUAL_AUTO  = 43; //ROBOT //A2CHv3|A2CHv4
    OUT_STAGE2_ROBOT_PAUSE        = 44; //ROBOT //A2CHv3|A2CHv4
    OUT_STAGE2_ROBOT_RESET        = 45; //ROBOT // 3초 이상 //A2CHv3|A2CHv4
    OUT_ROBOT_RESET_SW_LED        = 46; //ROBOT // MC Off (MC_RESET_SW_LEN ON) -> MC ON (MC_RESET_SW_LEN OFF, ROBOT_RESET_SW_LED ON) -> ROBOT MODBUS CONN(ROBOT_RESET_SW_LED OFF)
  {$IF Defined(POCB_A2CHv3)}
    OUT_AIR_KNIFE                 = 47; //A2CHv3: CH1&CH2
    MAX_DIO_OUT                   = OUT_AIR_KNIFE;
  {$ELSE} //POCB_A2CHv4|POCB_ATO|POCB_GAGO
    OUT_AIR_KNIFE1                = 47; //A2CHv4|ATO|GAGO:CH1
    OUT_AIR_KNIFE2                = 48; //A2CHv4|ATO|GAGO:CH2
    //
	  {$IFDEF HAS_DIO_PG_OFF} //ATO|GAGO
    OUT_PG1_OFF                   = 49; //ATO
    OUT_PG2_OFF                   = 50; //ATO
    {$ENDIF}
    {$IFDEF HAS_DIO_Y_AXIS_MC}
    OUT_STAGE1_Y_AXIS_MC_ON       = 51;
    OUT_STAGE2_Y_AXIS_MC_ON       = 52;
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_STAGE_LAMP}
    OUT_STAGE1_STAGE_LAMP_OFF     = 53;
    OUT_STAGE2_STAGE_LAMP_OFF     = 54;
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_IONBAR}
    OUT_STAGE1_IONBAR_ON          = 55;
    OUT_STAGE2_IONBAR_ON          = 56;
    {$ENDIF}
		//
	  {$IF Defined(HAS_DIO_OUT_IONBAR)}
    MAX_DIO_OUT                   = OUT_STAGE2_IONBAR_ON;
	  {$ELSEIF Defined(HAS_DIO_OUT_STAGE_LAMP)}
    MAX_DIO_OUT                   = OUT_STAGE2_STAGE_LAMP_OFF;
	  {$ELSEIF Defined(HAS_DIO_Y_AXIS_MC)}
    MAX_DIO_OUT                   = OUT_STAGE2_Y_AXIS_MC_ON;
	  {$ELSEIF Defined(HAS_DIO_PG_OFF)}
    MAX_DIO_OUT                   = OUT_PG2_OFF;
	  {$ELSE}
    MAX_DIO_OUT                   = OUT_AIR_KNIFE2;
	  {$ENDIF}
  {$ENDIF}

    MASK_OUT_STAGE1_READY_LED          = $1;
    MASK_OUT_STAGE2_READY_LED          = $2;
    MASK_OUT_RESET_SW_LED              = $4;
    MASK_OUT_STAGE1_SWITCH_UNLOCK      = $8;
    MASK_OUT_STAGE2_SWITCH_UNLOCK      = $10;
  //MASK_OUT_STAGE1_LED_LAMP           = --;
  //MASK_OUT_STAGE2_LED_LAMP           = --;
    MASK_OUT_LAMP_RED                  = $20;
    MASK_OUT_LAMP_YELLOW               = $40;
    MASK_OUT_LAMP_GREEN                = $80;
    MASK_OUT_MELODY1                   = $100;
    MASK_OUT_MELODY2                   = $200;
    MASK_OUT_MELODY3                   = $400;
    MASK_OUT_MELODY4                   = $800;
  //----                               = $1000;
  //----                               = $2000;
    MASK_OUT_STAGE1_MAINT_DOOR1_UNLOCK = $4000;
    MASK_OUT_STAGE1_MAINT_DOOR2_UNLOCK = $8000;
    MASK_OUT_STAGE2_MAINT_DOOR1_UNLOCK = $10000;
    MASK_OUT_STAGE2_MAINT_DOOR2_UNLOCK = $20000;
    MASK_OUT_STAGE1_SHUTTER_UP         = $40000;
    MASK_OUT_STAGE1_SHUTTER_DOWN       = $80000;
    MASK_OUT_STAGE2_SHUTTER_UP         = $100000;
    MASK_OUT_STAGE2_SHUTTER_DOWN       = $200000;
	{$IFDEF HAS_DIO_SCREW_SHUTTER}
    MASK_OUT_STAGE1_SCREW_SHUTTER_UP   = $400000;  // A2CHv3|A2CHv4_#1&#2 A2CHv4_#3(NoScrewShutter)
    MASK_OUT_STAGE1_SCREW_SHUTTER_DOWN = $800000;  // A2CHv3|A2CHv4_#1&#2 A2CHv4_#3(NoScrewShutter)
    MASK_OUT_STAGE2_SCREW_SHUTTER_UP   = $1000000; // A2CHv3|A2CHv4_#1&#2 A2CHv4_#3(NoScrewShutter)
    MASK_OUT_STAGE2_SCREW_SHUTTER_DOWN = $2000000; // A2CHv3|A2CHv4_#1&#2 A2CHv4_#3(NoScrewShutter)
	{$ENDIF}
  {$IFDEF SUPPORT_1CG2PANEL}
    MASK_OUT_SHUTTER_GUIDE_UP          = $4000000;
    MASK_OUT_SHUTTER_GUIDE_DOWN        = $8000000;
  {$ENDIF}
    MASK_OUT_STAGE1_VACUUM1            = $10000000;
    MASK_OUT_STAGE1_VACUUM2            = $20000000;
    MASK_OUT_STAGE2_VACUUM1            = $40000000;
    MASK_OUT_STAGE2_VACUUM2            = $80000000;
    MASK_OUT_STAGE1_DESTRUCTION_SOL1   = $100000000;
    MASK_OUT_STAGE1_DESTRUCTION_SOL2   = $200000000;
    MASK_OUT_STAGE2_DESTRUCTION_SOL1   = $400000000;
    MASK_OUT_STAGE2_DESTRUCTION_SOL2   = $800000000;
    MASK_OUT_STAGE1_ROBOT_STICK_PLUS   = $1000000000;
    MASK_OUT_STAGE1_ROBOT_STICK_MINUS  = $2000000000;
    MASK_OUT_STAGE1_ROBOT_MANUAL_AUTO  = $4000000000;
    MASK_OUT_STAGE1_ROBOT_PAUSE        = $8000000000;
    MASK_OUT_STAGE1_ROBOT_RESET        = $10000000000;   //3초 이상 ON시켜야
    MASK_OUT_STAGE2_ROBOT_STICK_PLUS   = $20000000000;
    MASK_OUT_STAGE2_ROBOT_STICK_MINUS  = $40000000000;
    MASK_OUT_STAGE2_ROBOT_MANUAL_AUTO  = $80000000000;
    MASK_OUT_STAGE2_ROBOT_PAUSE        = $100000000000;
    MASK_OUT_STAGE2_ROBOT_RESET        = $200000000000;  //3초 이상 ON시켜야
    MASK_OUT_ROBOT_RESET_SW_LED        = $400000000000;
    {$IF Defined(POCB_A2CHv3)}
    MASK_OUT_AIR_KNIFE                 = $800000000000;  //A2CHv3: CH1&CH2
    {$ELSE} //A2CHv4|ATO|GAGO
    MASK_OUT_AIR_KNIFE1                = $800000000000;  //A2CHv4:CH1
    MASK_OUT_AIR_KNIFE2                = $1000000000000; //A2CHv4:CH2
    {$ENDIF}
	  {$IFDEF HAS_DIO_PG_OFF} //ATO|GAGO
    MASK_OUT_PG1_OFF                   = $2000000000000; //ATO|GAGO
    MASK_OUT_PG2_OFF                   = $4000000000000; //ATO|GAGO
    {$ENDIF}
    {$IFDEF HAS_DIO_Y_AXIS_MC}
    MASK_OUT_STAGE1_Y_AXIS_MC_ON       = $8000000000000;
    MASK_OUT_STAGE2_Y_AXIS_MC_ON       = $10000000000000;
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_STAGE_LAMP}
    MASK_OUT_STAGE1_STAGE_LAMP_OFF     = $20000000000000;
    MASK_OUT_STAGE2_STAGE_LAMP_OFF     = $40000000000000;
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_IONBAR}
    MASK_OUT_STAGE1_IONBAR_ON          = $80000000000000;
    MASK_OUT_STAGE2_IONBAR_ON          = $100000000000000;
    {$ENDIF}

    MASK_OUT_MELODY_ALL                = $F00;  // = (MASK_OUT_MELODY1 or MASK_OUT_MELODY2 or MASK_OUT_MELODY3 or MASK_OUT_MELODY4)
{$ENDIF} //A2CHv3|A2CHv4|ATO|GAGO

    //
    IO_AUTO_FLOW_NONE         = 0; //m_nAutoFlow 에 대한 Index.
    IO_AUTO_FLOW_READY        = 1; //m_nAutoFlow 에 대한 Index.
    IO_AUTO_FLOW_FRONT        = 2; //m_nAutoFlow 에 대한 Index.
    IO_AUTO_FLOW_SHUTTER_DOWN = 3; //m_nAutoFlow 에 대한 Index.
    IO_AUTO_FLOW_CAMERA       = 4; //m_nAutoFlow 에 대한 Index.
    IO_AUTO_FLOW_SHUTTER_UP   = 5; //m_nAutoFlow 에 대한 Index.
    IO_AUTO_FLOW_BACK         = 6; //m_nAutoFlow 에 대한 Index.
    IO_AUTO_FLOW_UNLOAD       = 7; //m_nAutoFlow 에 대한 Index.
type
  ShutterState = (OFF, UP, DOWN);
implementation

end.
