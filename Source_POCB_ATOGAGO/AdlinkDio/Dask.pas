unit DASK;

interface

Const

(*-------- ADLink PCI Card Type -----------*)
  PCI_6208V  =  1;
  PCI_6208A  =  2;
  PCI_6308V  =  3;
  PCI_6308A  =  4;
  PCI_7200   =  5;
  PCI_7230   =  6;
  PCI_7233   =  7;
  PCI_7234   =  8;
  PCI_7248   =  9;
  PCI_7249   =  10;
  PCI_7250   = 11;
  PCI_7252   = 12;
  PCI_7296   = 13;
  PCI_7300A_RevA = 14;
  PCI_7300A_RevB = 15;
  PCI_7432   = 16;
  PCI_7433   = 17;
  PCI_7434   = 18;
  PCI_8554   = 19;
  PCI_9111DG = 20;
  PCI_9111HR = 21;
  PCI_9112   = 22;
  PCI_9113   = 23;
  PCI_9114DG = 24;
  PCI_9114HG = 25;
  PCI_9118DG = 26;
  PCI_9118HG = 27;
  PCI_9118HR = 28;
  PCI_9810   = 29;
  PCI_9812   = 30;
  PCI_7396   = 31;
  PCI_9116   = 32;
  PCI_7256   = 33;
  PCI_7258   = 34;

  MAX_CARD   = 32;

(*-------- Error Number -----------*)
  NoError                    =  0;
  ErrorUnknownCardType       = -1;
  ErrorInvalidCardNumber     = -2;
  ErrorTooManyCardRegistered = -3;
  ErrorCardNotRegistered     = -4;
  ErrorFuncNotSupport        = -5;
  ErrorInvalidIoChannel      = -6;
  ErrorInvalidAdRange        = -7;
  ErrorContIoNotAllowed      = -8;
  ErrorDiffRangeNotSupport   = -9;
  ErrorLastChannelNotZero    = -10;
  ErrorChannelNotDescending  = -11;
  ErrorChannelNotAscending   = -12;
  ErrorOpenDriverFailed      = -13;
  ErrorOpenEventFailed       = -14;
  ErrorTransferCountTooLarge = -15;
  ErrorNotDoubleBufferMode   = -16;
  ErrorInvalidSampleRate     = -17;
  ErrorInvalidCounterMode    = -18;
  ErrorInvalidCounter        = -19;
  ErrorInvalidCounterState   = -20;
  ErrorInvalidBinBcdParam    = -21;
  ErrorBadCardType           = -22;
  ErrorInvalidDaRefVoltage   = -23;
  ErrorAdTimeOut             = -24;
  ErrorNoAsyncAI             = -25;
  ErrorNoAsyncAO             = -26;
  ErrorNoAsyncDI             = -27;
  ErrorNoAsyncDO             = -28;
  ErrorNotInputPort          = -29;
  ErrorNotOutputPort         = -30;
  ErrorInvalidDioPort        = -31;
  ErrorInvalidDioLine        = -32;
  ErrorContIoActive          = -33;
  ErrorDblBufModeNotAllowed  = -34;
  ErrorConfigFailed          = -35;
  ErrorInvalidPortDirection  = -36;
  ErrorBeginThreadError      = -37;
  ErrorInvalidPortWidth      = -38;
  ErrorInvalidCtrSource      = -39;
  ErrorOpenFile              = -40;
  ErrorAllocateMemory        = -41;
  ErrorDaVoltageOutOfRange   = -42;
  ErrorDaExtRefNotAllowed    = -43;
  ErrorDIODataWidthError     = -44;
  ErrorTaskCodeError         = -45;
  ErrortriggercountError     = -46;
  ErrorInvalidTriggerMode    = -47;
  ErrorInvalidTriggerType    = -48;
  ErrorConfigIoctl           = -201;
  ErrorAsyncSetIoctl         = -202;
  ErrorDBSetIoctl            = -203;
  ErrorDBHalfReadyIoctl      = -204;
  ErrorContOPIoctl           = -205;
  ErrorContStatusIoctl       = -206;
  ErrorPIOIoctl              = -207;
  ErrorDIntSetIoctl          = -208;
  ErrorWaitEvtIoctl          = -209;
  ErrorOpenEvtIoctl          = -210;
  ErrorCOSIntSetIoctl        = -211;
  ErrorMemMapIoctl           = -212;
  ErrorMemUMapSetIoctl       = -213;
  ErrorCTRIoctl              = -214;
  ErrorGetResIoctl           = -215;

(*-------- Synchronous Mode -----------*)
  SYNCH_OP  = 1;
  ASYNCH_OP = 2;

(*-------- AD Range -----------*)
  AD_B_10_V     =  1;
  AD_B_5_V      =  2;
  AD_B_2_5_V    =  3;
  AD_B_1_25_V   =  4;
  AD_B_0_625_V  =  5;
  AD_B_0_3125_V =  6;
  AD_B_0_5_V    =  7;
  AD_B_0_05_V   =  8;
  AD_B_0_005_V  =  9;
  AD_B_1_V      = 10;
  AD_B_0_1_V    = 11;
  AD_B_0_01_V   = 12;
  AD_B_0_001_V  = 13;
  AD_U_20_V     = 14;
  AD_U_10_V     = 15;
  AD_U_5_V      = 16;
  AD_U_2_5_V    = 17;
  AD_U_1_25_V   = 18;
  AD_U_1_V      = 19;
  AD_U_0_1_V    = 20;
  AD_U_0_01_V   = 21;
  AD_U_0_001_V  = 22;

(*-------- Trigger Mode -----------*)
  TRIG_SOFTWARE         = 0;
  TRIG_INT_PACER        = 1;
  TRIG_EXT_STROBE       = 2;
  TRIG_HANDSHAKE        = 3;
  TRIG_CLK_10MHZ        = 4; (* PCI-7300A        *)
  TRIG_CLK_20MHZ        = 5; (* PCI-7300A        *)
  TRIG_DO_CLK_TIMER_ACK = 6; (* PCI-7300A Rev. B *)
  TRIG_DO_CLK_10M_ACK   = 7; (* PCI-7300A Rev. B *)
  TRIG_DO_CLK_20M_ACK   = 8; (* PCI-7300A Rev. B *)

(*-- Virtual Sampling Rate for using external clock as the clock source --*)
  CLKSRC_EXT_SampRate = 10000;

(*-------- Constants for PCI-6208A -----------*)
 (*-- Output Mode --*)
  P6208_CURRENT_0_20MA = 0;
  P6208_CURRENT_5_25MA = 1;
  P6208_CURRENT_4_20MA = 3;
(*-------- Constants for PCI-6308A/PCI-6308V -----------*)
 (*-- Output Mode --*)
  P6308_CURRENT_0_20MA = 0;
  P6308_CURRENT_5_25MA = 1;
  P6308_CURRENT_4_20MA = 3;
 (*-- AO Setting --*)
  P6308V_AO_CH0_3    = 0;
  P6308V_AO_CH4_7    = 1;
  P6308V_AO_UNIPOLAR = 0;
  P6308V_AO_BIPOLAR  = 1;
(*-------- Constants for PCI-7200 ------------*)
 (*-- InputMode --*)
  DI_WAITING   = $02;
  DI_NOWAITING = $00;

  DI_TRIG_RISING  = $04;
  DI_TRIG_FALLING = $00;

  IREQ_RISING  = $08;
  IREQ_FALLING = $00;

 (*------- Output Mode ---------------------- *)
  OREQ_ENABLE  = $10;
  OREQ_DISABLE = $00;

  OTRIG_HIGH = $20;
  OTRIG_LOW  = $00;

(*--------- Constants for PCI-7248/7296 ----------*)
 (*--- DIO Port Direction ---*)
  INPUT_PORT  = 1;
  OUTPUT_PORT = 2;

 (*--- Channel&Port ---*)
  Channel_P1A  = 0;
  Channel_P1B  = 1;
  Channel_P1C  = 2;
  Channel_P1CL = 3;
  Channel_P1CH = 4;
  Channel_P1AE = 10;
  Channel_P1BE = 11;
  Channel_P1CE = 12;
  Channel_P2A  = 5;
  Channel_P2B  = 6;
  Channel_P2C  = 7;
  Channel_P2CL = 8;
  Channel_P2CH = 9;
  Channel_P2AE = 15;
  Channel_P2BE = 16;
  Channel_P2CE = 17;
  Channel_P3A  = 10;
  Channel_P3B  = 11;
  Channel_P3C  = 12;
  Channel_P3CL = 13;
  Channel_P3CH = 14;
  Channel_P4A  = 15;
  Channel_P4B  = 16;
  Channel_P4C  = 17;
  Channel_P4CL = 18;
  Channel_P4CH = 19;
  Channel_P5A  = 20;
  Channel_P5B  = 21;
  Channel_P5C  = 22;
  Channel_P5CL = 23;
  Channel_P5CH = 24;
  Channel_P6A  = 25;
  Channel_P6B  = 26;
  Channel_P6C  = 27;
  Channel_P6CL = 28;
  Channel_P6CH = 29;
  Channel_P1   = 30;
  Channel_P2   = 31;
  Channel_P3   = 32;
  Channel_P4   = 33;
  Channel_P1E  = 34;
  Channel_P2E  = 35;
  Channel_P3E  = 36;
  Channel_P4E  = 37;

(*-------- Constants for PCI-7300A -------------------*)
 (*--- Wait Status ---*)
  P7300_WAIT_NO   = 0;
  P7300_WAIT_TRG  = 1;
  P7300_WAIT_FIFO = 2;
  P7300_WAIT_BOTH = 3;

 (*--- Terminator control ---*)
  P7300_TERM_OFF = 0;
  P7300_TERM_ON  = 1;

 (*--- DI control signals polarity for PCI-7300A Rev. B ---*)
  P7300_DIREQ_POS  = $00;
  P7300_DIREQ_NEG  = $01;
  P7300_DIACK_POS  = $00;
  P7300_DIACK_NEG  = $02;
  P7300_DITRIG_POS = $00;
  P7300_DITRIG_NEG = $04;

 (*--- DO control signals polarity for PCI-7300A Rev. B ---*)
  P7300_DOREQ_POS  = $00;
  P7300_DOREQ_NEG  = $08;
  P7300_DOACK_POS  = $00;
  P7300_DOACK_NEG  = $10;
  P7300_DOTRIG_POS = $00;
  P7300_DOTRIG_NEG = $20;

(*-------- Constants for PCI-7432/7433/7434 ---------------*)
  PORT_DI_LOW  = 0;
  PORT_DI_HIGH = 1;
  PORT_DO_LOW  = 0;
  PORT_DO_HIGH = 1;
  P7432R_DO_LED = 1;
  P7433R_DO_LED = 0;
  P7434R_DO_LED = 2;
  P7432R_DI_SLOT = 1;
  P7433R_DI_SLOT = 2;
  P7434R_DI_SLOT = 0;

(*-- Dual-Interrupt Source control for PCI-7248/29/96 & 7432/33 & 7230/7233 & 8554 & 7396--*)
  INT1_DISABLE       = -1;   (* INT1 Disabled *)
  INT1_COS           =  0;   (* INT1 COS : only available for PCI-7396, PCI-7256)
  INT1_FP1C0         =  1;   (* INT1 by Falling edge of P1C0 : only available for PCI7248/96/7396        *)
  INT1_RP1C0_FP1C3   =  2;   (* INT1 by P1C0 Rising or P1C3 Falling : only available for PCI7248/96/7396 *)
  INT1_EVENT_COUNTER =  3;   (* INT1 by Event Counter down to zero : only available for PCI7248/96/7396  *)
  INT1_EXT_SIGNAL    =  1;   (* INT1 by external signal: only available for PCI7432/33              *)
  INT1_COUT12        =  1;   (* INT1 COUT12 : only available for PCI8554                            *)
  INT1_CH0           =  1;   (* INT1 CH0 : only available for PCI7256)
  INT2_DISABLE       = -1;   (* INT2 Disabled *)
  INT2_COS           =  0;   (* INT2 COS : only available for PCI-7396)
  INT2_FP2C0         =  1;   (* INT2 by Falling edge of P2C0 : only available for PCI7248/96/7396        *)
  INT2_RP2C0_FP2C3   =  2;   (* INT2 by P2C0 Rising or P2C3 Falling : only available for PCI7248/96/7396 *)
  INT2_TIMER_COUNTER =  3;   (* INT2 by Timer Counter down to zero : only available for PCI7248/96/7396  *)
  INT2_EXT_SIGNAL    =  1;   (* INT2 by external signal: only available for PCI7432/33              *)
  INT2_CH1           =  2;   (* INT2 CH1 : only available for PCI7256)

(*-------- Constants for PCI-8554 ------ -----*)
 (*-- Clock Source of Cunter N --*)
  ECKN    = 0;
  COUTN_1 = 1;
  CK1     = 2;
  COUT10  = 3;

 (*-- Clock Source of CK1 --*)
  CK1_C8M    = 0;
  CK1_COUT11 = 1;

 (*-- Debounce Clock --*)
  DBCLK_COUT11 = 0;
  DBCLK_2MHZ   = 1;

(*-------- Constants for PCI-9111 ------------*)
 (*-- Dual Interrupt Mode --*)
  P9111_INT1_EOC     = 0;    (* Ending of AD conversion *)
  P9111_INT1_FIFO_HF = 1;    (* FIFO Half Full          *)
  P9111_INT2_PACER   = 0;    (* Every Timer tick        *)
  P9111_INT2_EXT_TRG = 1;    (* ExtTrig High->Low       *)

 (*-- Channel Count --*)
  P9111_CHANNEL_DO  = 0;
  P9111_CHANNEL_EDO = 1;
  P9111_CHANNEL_DI  = 0;
  P9111_CHANNEL_EDI = 1;

 (*-- EDO function  --*)
  P9111_EDO_INPUT   = 1;   (* EDO port set as Input port                *)
  P9111_EDO_OUT_EDO = 2;   (* EDO port set as Output port               *)
  P9111_EDO_OUT_CHN = 3;   (* EDO port set as channel number ouput port *)

 (*-- Trigger Mode  --*)
  P9111_TRGMOD_SOFT = 0;   (* Software Trigger Mode  *)
  P9111_TRGMOD_PRE =  1;   (* Pre-Trigger Mode       *)
  P9111_TRGMOD_POST = 2;   (* Post Trigger Mode      *)

 (*-- AO Setting --*)
  P9111_AO_UNIPOLAR = 0;
  P9111_AO_BIPOLAR  = 1;

(*-------- Constants for PCI-9116 ------------*)
  P9116_AI_LocalGND	= $00;
  P9116_AI_UserCMMD = $01;
  P9116_AI_SingEnded = $00;
  P9116_AI_Differential = $02;
  P9116_AI_BiPolar   = $00;
  P9116_AI_UniPolar  = $04;

  P9116_TRGMOD_SOFT = $00;  (* Software Trigger Mode *)
  P9116_TRGMOD_POST = $10;  (* Post Trigger Mode	 *)
  P9116_TRGMOD_DELAY = $20;  (* Delay Trigger Mode    *)
  P9116_TRGMOD_PRE = $30;    (* Pre-Trigger Mode      *)
  P9116_TRGMOD_MIDL = $40;   (* Middle Trigger Mode   *)
  P9116_AI_TrgPositive = $00;
  P9116_AI_TrgNegative = $80;
  P9116_AI_IntTimeBase = $00;
  P9116_AI_ExtTimeBase = $100;
  P9116_AI_DlyInSamples = $200;
  P9116_AI_DlyInTimebase = $000;
  P9116_AI_ReTrigEn = $400;
  P9116_AI_MCounterEn = $800;
  P9116_AI_SoftPolling = $0000;
  P9116_AI_INT = $1000;
  P9116_AI_DMA = $2000;

(*-------- Constants for PCI-9118 ------------*)
  P9118_AI_BiPolar  =       $00;
  P9118_AI_UniPolar =       $01;

  P9118_AI_SingEnded    =   $00;
  P9118_AI_Differential =   $02;

  P9118_AI_ExtG =           $04;

  P9118_AI_ExtTrig =        $08;

  P9118_AI_DtrgNegative =   $00;
  P9118_AI_DtrgPositive =   $10;

  P9118_AI_EtrgNegative =   $00;
  P9118_AI_EtrgPositive =   $20;

  P9118_AI_BurstModeEn =    $40;
  P9118_AI_SampleHold  =    $80;
  P9118_AI_PostTrgEn   =    $100;
  P9118_AI_AboutTrgEn  =    $200;

(*-------- Constants for PCI-9812 ------------*)
 (*-- Channel Count --*)
  P9812_CHANNEL_CNT1 = 1;    (* Channel 0 is enabled        *)
  P9812_CHANNEL_CNT2 = 2;    (* Channel 0 and 1 is enabled  *)
  P9812_CHANNEL_CNT4 = 4;    (* All channels are enabled    *)

 (*-- Trigger Mode --*)
  P9812_TRGMOD_SOFT  = $00;  (* Software Trigger Mode       *)
  P9812_TRGMOD_POST  = $01;  (* Post Trigger Mode           *)
  P9812_TRGMOD_PRE   = $02;  (* Pre-Trigger Mode            *)
  P9812_TRGMOD_DELAY = $03;  (* Delay Trigger Mode          *)
  P9812_TRGMOD_MIDL  = $04;  (* Middle Trigger Mode         *)

 (*-- Trigger Source --*)
  P9812_TRGSRC_CH0     = $00;   (* trigger source --CH0     *)
  P9812_TRGSRC_CH1     = $08;   (* trigger source --CH1     *)
  P9812_TRGSRC_CH2     = $10;   (* trigger source --CH2     *)
  P9812_TRGSRC_CH3     = $18;   (* trigger source --CH3     *)
  P9812_TRGSRC_EXT_DIG = $20;   (* External Digital Trigger *)

 (*-- Trigger Polarity --*)
  P9812_TRGSLP_POS = $00;   (* Positive slope trigger *)
  P9812_TRGSLP_NEG = $40;   (* Negative slope trigger *)

 (*-- Frequency Selection --*)
  P9812_AD2_GT_PCI = $80;   (* Freq. of A/D clock > PCI clock freq. *)
  P9812_AD2_LT_PCI = $00;   (* Freq. of A/D clock < PCI clock freq. *)

 (*-- Clock Source --*)
  P9812_CLKSRC_INT     = $000;   (* Internal clock             *)
  P9812_CLKSRC_EXT_SIN = $100;   (* External SIN wave clock    *)
  P9812_CLKSRC_EXT_DIG = $200;   (* External Square wave clock *)

 (*-- DAQ Event type for the event message --*)
  AIEnd = 0;
  DIEnd = 0;
  DOEnd = 0;
  DBEvent = 1;

(*-------- Timer/Counter -----------------------------*)
 (*-- Counter Mode (8254) --*)
  TOGGLE_OUTPUT          = 0;   (* Toggle output from low to high on terminal count *)
  PROG_ONE_SHOT          = 1;   (* Programmable one-shot      *)
  RATE_GENERATOR         = 2;   (* Rate generator             *)
  SQ_WAVE_RATE_GENERATOR = 3;   (* Square wave rate generator *)
  SOFT_TRIG              = 4;   (* Software-triggered strobe  *)
  HARD_TRIG              = 5;   (* Hardware-triggered strobe  *)

(* General Purpose Timer/Counter *)
 (* -- Counter Mode -- *)
 General_Counter  = $00;  (* general counter  *)
 Pulse_Generation = $01;  (* pulse generation *)
 (* -- GPTC clock source --*)
 GPTC_CLKSRC_EXT =  $08;
 GPTC_CLKSRC_INT =  $00;
 GPTC_GATESRC_EXT = $10;
 GPTC_GATESRC_INT = $00;
 GPTC_UPDOWN_SELECT_EXT	= $20;
 GPTC_UPDOWN_SELECT_SOFT = $00;
 GPTC_UP_CTR = $40;
 GPTC_DOWN_CTR = $00;
 GPTC_ENABLE = $80;
 GPTC_DISABLE = $00;

 (*-------- 16-bit binary or 4-decade BCD counter------------------*)
  BIN = 0;
  BCD = 1;

type
  TCallbackFunc = function : Integer;

(****************************************************************************)
(*          PCIS-DASK Functions Declarations                                *)
(****************************************************************************)
function Register_Card (CardType:Word; card_num:Word):Smallint;stdcall;
function Release_Card  (CardNumber:Word):Smallint;stdcall;
function GetActualRate (CardNumber:word; SampleRate:Double; var ActualRate:Double):Smallint;stdcall;
function GetCardType (CardNumber:word; var cardType:Word):Smallint;stdcall;
function GetBaseAddr (CardNumber:word; var BaseAddr:Cardinal; var BaseAddr2:Cardinal):Smallint;stdcall;
function GetLCRAddr (CardNumber:word; LcrAddr:Cardinal):Smallint;stdcall;
(*---------------------------------------------------------------------------*)
function AI_9111_Config (CardNumber:Word; TrigSource:Word; TrgMode:Word; TraceCnt:Word):Smallint;stdcall;
function AI_9112_Config (CardNumber:Word; TrigSource:Word):Smallint;stdcall;
function AI_9113_Config (CardNumber:Word; TrigSource:Word):Smallint;stdcall;
function AI_9114_Config (CardNumber:Word; TrigSource:Word):Smallint;stdcall;
function AI_9114_PreTrigConfig (CardNumber:Word; PreTrgEn:Word; TraceCnt:Word):Smallint;stdcall;
function AI_9116_Config (CardNumber:Word; ConfigCtrl:Word; TrigCtrl:Word; PostCnt:Word; MCnt:Word; ReTrgCnt:Word):Smallint;stdcall;
function AI_9118_Config (CardNumber:Word; ModeCtrl:Word; FunCtrl:Word; BurstCnt:Word; PostCnt:Word):Smallint;stdcall;
function AI_9812_Config (CardNumber:Word; TrgMode:Word; TrgSrc:Word; TrgPol:Word; ClkSel:Word; TrgLevel:Word; PostCnt:Word):Smallint;stdcall;
function AI_9812_SetDiv (CardNumber:Word; pacerVal:Cardinal):Smallint;stdcall;
function AI_9116_CounterInterval (CardNumber:Word; ScanIntrv:Cardinal; SampIntrv:Cardinal):Smallint;stdcall;
function AI_InitialMemoryAllocated (CardNumber:Word; var MemSize:Cardinal):Smallint;stdcall;
function AI_ReadChannel (CardNumber:Word; Channel:Word; AdRange:Word; var Value:Word):Smallint;stdcall;
function AI_VReadChannel (CardNumber:Word; Channel:Word; AdRange:Word; var voltage:Double):Smallint;stdcall;
function AI_VoltScale (CardNumber:Word; AdRange:Word; reading:Smallint; var voltage:Double):Smallint;stdcall;
function AI_ContReadChannel (CardNumber:Word; Channel:Word; AdRange:Word;
               var Buffer:Word; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall;
function AI_ContReadMultiChannels (CardNumber:Word; NumChans:Word; var Chans:Word;
               var AdRanges:Word; var Buffer:Word; ReadCount:Cardinal;
               SampleRate:Double; SyncMode:Word):Smallint;stdcall;
function AI_ContScanChannels (CardNumber:Word; Channel:Word; AdRange:Word;
               var Buffer:Word; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall;
function AI_ContReadChannelToFile (CardNumber:Word; Channel:Word; AdRange:Word;
               var FileName:Char; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall;
function AI_ContReadMultiChannelsToFile (CardNumber:Word; NumChans:Word; var Chans:Word;
               var AdRanges:Word; var FileName:Char; ReadCount:Cardinal;
               SampleRate:Double; SyncMode:Word):Smallint;stdcall;
function AI_ContScanChannelsToFile (CardNumber:Word; Channel:Word; AdRange:Word;
               var FileName:Char; ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall;
function AI_ContVScale (CardNumber:Word; AdRange:Word; var readingArray:Word; var voltageArray:Double; count:Longint):Smallint;stdcall;
function AI_ContStatus (CardNumber:Word; var Status:Word):Smallint;stdcall;
function AI_AsyncCheck (CardNumber:Word; var Stopped:Byte; var AccessCnt:Cardinal):Smallint;stdcall;
function AI_AsyncClear (CardNumber:Word; var AccessCnt:Cardinal):Smallint;stdcall;
function AI_AsyncDblBufferHalfReady (CardNumber:Word; var HalfReady:Byte; var StopFlag:Byte):Smallint;stdcall;
function AI_AsyncDblBufferMode (CardNumber:Word; Enable:Byte):Smallint;stdcall;
function AI_AsyncDblBufferTransfer (CardNumber:Word; var Buffer:Word):Smallint;stdcall;
function AI_AsyncDblBufferOverrun (CardNumber:Word; op:Word; var overrunFlag:Word):Smallint;stdcall;
function AI_EventCallBack (CardNumber:Word; mode:Smallint; EventType:Smallint; callbackAddr:Cardinal):Smallint;stdcall;
(*---------------------------------------------------------------------------*)
function AO_6208A_Config (CardNumber:Word; V2AMode:Word):Smallint;stdcall;
function AO_6308A_Config (CardNumber:Word; V2AMode:Word):Smallint;stdcall;
function AO_6308V_Config (CardNumber:Word; Channel:Word; OutputPolarity:Word; refVoltage:Double):Smallint;stdcall;
function AO_9111_Config (CardNumber:Word; OutputPolarity:Word):Smallint;stdcall;
function AO_9112_Config (CardNumber:Word; Channel:Word; refVoltage:Double):Smallint;stdcall;
function AO_WriteChannel (CardNumber:Word; Channel:Word; Value:Word):Smallint;stdcall;
function AO_VWriteChannel (CardNumber:Word; Channel:Word; Voltage:Double):Smallint;stdcall;
function AO_VoltScale (CardNumber:Word; Channel:Word; Voltage:Double; var binValue:Smallint):Smallint;stdcall;
function AO_SimuWriteChannel (CardNumber:Word; Group:Word; var valueArray:Word):Smallint;stdcall;
function AO_SimuVWriteChannel (CardNumber:Word; Group:Word; var voltageArray:Double):Smallint;stdcall;
(*---------------------------------------------------------------------------*)
function DI_7200_Config (CardNumber:Word; TrigSource:Word; ExtTrigEn:Word; TrigPol:Word; I_REQ_Pol:Word):Smallint;stdcall;
function DI_7300A_Config (CardNumber:Word; PortWidth:Word; TrigSource:Word; WaitStatus:Word; Terminator:Word; I_REQ_Pol:Word; clear_fifo:Byte; disable_di:Byte):Smallint;stdcall;
function DI_7300B_Config (CardNumber:Word; PortWidth:Word; TrigSource:Word; WaitStatus:Word; Terminator:Word; I_Cntrl_Pol:Word; clear_fifo:Byte; disable_di:Byte):Smallint;stdcall;
function DI_InitialMemoryAllocated (CardNumber:Word; var DmaSize:Cardinal):Smallint;stdcall;
function DI_ReadLine (CardNumber:Word; Port:Word; Line:Word; var State:Word):Smallint;stdcall;
function DI_ReadPort (CardNumber:Word; Port:Word; var Value:Cardinal):Smallint;stdcall;
function DI_ContReadPort (CardNumber:Word; Port:Word; var Buffer:Cardinal;
               ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall;
function DI_ContReadPortToFile (CardNumber:Word; Port:Word; var FileName:Byte;
               ReadCount:Cardinal; SampleRate:Double; SyncMode:Word):Smallint;stdcall;
function DI_ContStatus (CardNumber:Word; var Status:Word):smallint;stdcall;
function DI_AsyncCheck (CardNumber:Word; var Stopped:Byte; var AccessCnt:Cardinal):Smallint;stdcall;
function DI_AsyncClear (CardNumber:Word; var AccessCnt:Cardinal):Smallint;stdcall;
function DI_AsyncDblBufferHalfReady (CardNumber:Word; var HalfReady:Byte):Smallint;stdcall;
function DI_AsyncDblBufferMode (CardNumber:Word; Enable:Byte):Smallint;stdcall;
function DI_AsyncDblBufferTransfer (CardNumber:Word; var Buffer:Cardinal):Smallint;stdcall;
function DI_ContMultiBufferSetup (CardNumber:Word; var Buffer:Cardinal; ReadCount:Cardinal; var BufferId:Word):Smallint;stdcall;
function DI_ContMultiBufferStart (CardNumber:Word; Port:Word; SampleRate:Double):Smallint;stdcall;
function DI_AsyncMultiBufferNextReady (CardNumber:Word; var NextReady:Byte; var BufferId:Word):Smallint;stdcall;
function DI_AsyncDblBufferOverrun (CardNumber:Word; op:Word; var overrunFlag:Word):Smallint;stdcall;
function DI_EventCallBack (CardNumber:Word; mode:Smallint; EventType:Smallint; callbackAddr:Cardinal):Smallint;stdcall;
(*---------------------------------------------------------------------------*)
function DO_7200_Config (CardNumber:Word; TrigSource:Word; OutReqEn:Word; OutTrigSig:Word):Smallint;stdcall;
function DO_7300A_Config (CardNumber:Word; PortWidth:Word; TrigSource:Word; WaitStatus:Word; Terminator:Word; O_REQ_Pol:Word):Smallint;stdcall;
function DO_7300B_Config (CardNumber:Word; PortWidth:Word; TrigSource:Word; WaitStatus:Word; Terminator:Word; O_Cntrl_Pol:Word; FifoThreshold:Cardinal):Smallint;stdcall;
function DO_InitialMemoryAllocated (CardNumber:Word; var MemSize:Cardinal):Smallint;stdcall;
function DO_WriteLine (CardNumber:Word; Port:Word; Line:Word; Value:Word):Smallint;stdcall;
function DO_WritePort (CardNumber:Word; Port:Word; Value:Cardinal):Smallint;stdcall;
function DO_ReadLine (CardNumber:Word; Port:Word; Line:Word; var Value:Word):Smallint;stdcall;
function DO_ReadPort (CardNumber:Word; Port:Word; var Value:Cardinal):Smallint;stdcall;
function DO_ContWritePort (CardNumber:Word; Port:Word; var Buffer:Cardinal;
               WriteCount:Cardinal; Iterations:Word; SampleRate:Double; SyncMode:Word):Smallint;stdcall;
function DO_PGStart (CardNumber:Word; var Buffer:Cardinal; WriteCount:Cardinal;
               SampleRate:Double):Smallint;stdcall;
function DO_PGStop (CardNumber:Word):Smallint;stdcall;
function DO_ContStatus (CardNumber:Word; var Status:Word):Smallint;stdcall;
function DO_AsyncCheck (CardNumber:Word; var Stopped:Byte; var AccessCnt:Cardinal):Smallint;stdcall;
function DO_AsyncClear (CardNumber:Word; var AccessCnt:Cardinal):Smallint;stdcall;
function EDO_9111_Config (CardNumber:Word; EDO_Fun:Word):Smallint;stdcall;
function DO_WriteExtTrigLine (CardNumber:Word; Value:Word):Smallint;stdcall;
function DO_ContMultiBufferSetup (CardNumber:Word; var Buffer:Cardinal; WriteCount:Cardinal; var BufferId:Word):Smallint;stdcall;
function DO_ContMultiBufferStart (CardNumber:Word; Port:Word; SampleRate:Double):Smallint;stdcall;
function DO_AsyncMultiBufferNextReady (CardNumber:Word; var NextReady:Byte; var BufferId:Word):Smallint;stdcall;
function DO_EventCallBack (CardNumber:Word; mode:Smallint; EventType:Smallint; callbackAddr:Cardinal):Smallint;stdcall;
(*---------------------------------------------------------------------------*)
function DIO_PortConfig (CardNumber:Word; Port:Word; Direction:Word):Smallint;stdcall;
function DIO_SetDualInterrupt(CardNumber:Word; Int1Mode:Smallint; Int2Mode:Smallint; var hEvent:Cardinal):Smallint;stdcall;
function DIO_SetCOSInterrupt(CardNumber:Word; Port:Word; ctlA:Word; ctlB:Word; ctlC:Word):Smallint;stdcall;
function DIO_GetCOSLatchData (CardNumber:Word; var CosLData:Word):Smallint;stdcall;
function DIO_INT1_EventMessage (CardNumber:Word; Int1Mode:Smallint; windowHandle:Cardinal; message:Cardinal; callbackAddr:TCallbackFunc):Smallint;stdcall;
function DIO_INT2_EventMessage (CardNumber:Word; Int2Mode:Smallint; windowHandle:Cardinal; message:Cardinal; callbackAddr:TCallbackFunc):Smallint;stdcall;
function DIO_7300SetInterrupt(CardNumber:Word; AuxDIEn:Smallint; T2En:Smallint; var hEvent:Cardinal):Smallint;stdcall;
function DIO_AUXDI_EventMessage (CardNumber:Word; AuxDIEn:Smallint; windowHandle:Cardinal; message:Cardinal; callbackAddr:TCallbackFunc):Smallint;stdcall;
function DIO_T2_EventMessage (CardNumber:Word; T2En:Smallint; windowHandle:Cardinal; message:Cardinal; callbackAddr:TCallbackFunc):Smallint;stdcall;
(*---------------------------------------------------------------------------*)
function CTR_Setup (CardNumber:Word; Ctr:Word; Mode:Word; Count:Cardinal; BinBcd:Word):Smallint;stdcall;
function CTR_Clear (CardNumber:Word; Ctr:Word; State:Word):Smallint;stdcall;
function CTR_Read (CardNumber:Word; Ctr:Word; var Value:Cardinal):Smallint;stdcall;
function CTR_Update (CardNumber:Word; Ctr:Word; Count:Cardinal):Smallint;stdcall;
function CTR_8554_ClkSrc_Config (CardNumber:Word; Ctr:Word; ClockSource:Word):Smallint;stdcall;
function CTR_8554_CK1_Config (CardNumber:Word; ClockSource:Word):Smallint;stdcall;
function CTR_8554_Debounce_Config (CardNumber:Word; DebounceClock:Word):Smallint;stdcall;
function GCTR_Setup (CardNumber:Word; GCtr:Word; GCtrCtrl:Word; Count:Cardinal):Smallint;stdcall;
function GCTR_Clear (CardNumber:Word; GCtr:Word):Smallint;stdcall;
function GCTR_Read  (CardNumber:Word; GCtr:Word; var Value:Cardinal):Smallint;stdcall;
(*---------------------------------------------------------------------------*)
function AI_GetView (CardNumber:word; pView:Pointer):Smallint;stdcall;
function DI_GetView (CardNumber:word; pView:Pointer):Smallint;stdcall;
function DO_GetView (CardNumber:word; pView:Pointer):Smallint;stdcall;

function AI_GetEvent(CardNumber:Word; var hEvent:Cardinal):Smallint;stdcall;
function AO_GetEvent(CardNumber:Word; var hEvent:Cardinal):Smallint;stdcall;
function DI_GetEvent(CardNumber:Word; var hEvent:Cardinal):Smallint;stdcall;
function DO_GetEvent(CardNumber:Word; var hEvent:Cardinal):Smallint;stdcall;

implementation

function Register_Card; external 'Pci-Dask.dll';
function Release_Card; external 'Pci-Dask.dll';
function GetActualRate; external 'Pci-Dask.dll';
function GetCardType; external 'Pci-Dask.dll';
function GetBaseAddr; external 'Pci-Dask.dll';
function GetLCRAddr; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function AI_9111_Config; external 'Pci-Dask.dll';
function AI_9112_Config; external 'Pci-Dask.dll';
function AI_9113_Config; external 'Pci-Dask.dll';
function AI_9114_Config; external 'Pci-Dask.dll';
function AI_9114_PreTrigConfig; external 'Pci-Dask.dll';
function AI_9116_Config; external 'Pci-Dask.dll';
function AI_9118_Config; external 'Pci-Dask.dll';
function AI_9812_Config; external 'Pci-Dask.dll';
function AI_9812_SetDiv; external 'Pci-Dask.dll';
function AI_9116_CounterInterval; external 'Pci-Dask.dll';
function AI_InitialMemoryAllocated; external 'Pci-Dask.dll';
function AI_ReadChannel; external 'Pci-Dask.dll';
function AI_VReadChannel; external 'Pci-Dask.dll';
function AI_VoltScale; external 'Pci-Dask.dll';
function AI_ContReadChannel; external 'Pci-Dask.dll';
function AI_ContReadMultiChannels; external 'Pci-Dask.dll';
function AI_ContScanChannels; external 'Pci-Dask.dll';
function AI_ContReadChannelToFile; external 'Pci-Dask.dll';
function AI_ContReadMultiChannelsToFile; external 'Pci-Dask.dll';
function AI_ContScanChannelsToFile; external 'Pci-Dask.dll';
function AI_ContVScale; external 'Pci-Dask.dll';
function AI_ContStatus; external 'Pci-Dask.dll';
function AI_AsyncCheck; external 'Pci-Dask.dll';
function AI_AsyncClear; external 'Pci-Dask.dll';
function AI_AsyncDblBufferHalfReady; external 'Pci-Dask.dll';
function AI_AsyncDblBufferMode; external 'Pci-Dask.dll';
function AI_AsyncDblBufferTransfer; external 'Pci-Dask.dll';
function AI_AsyncDblBufferOverrun; external 'Pci-Dask.dll';
function AI_EventCallBack; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function AO_6208A_Config; external 'Pci-Dask.dll';
function AO_6308A_Config; external 'Pci-Dask.dll';
function AO_6308V_Config; external 'Pci-Dask.dll';
function AO_9111_Config; external 'Pci-Dask.dll';
function AO_9112_Config; external 'Pci-Dask.dll';
function AO_WriteChannel; external 'Pci-Dask.dll';
function AO_VWriteChannel; external 'Pci-Dask.dll';
function AO_VoltScale; external 'Pci-Dask.dll';
function AO_SimuWriteChannel; external 'Pci-Dask.dll';
function AO_SimuVWriteChannel; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function DI_7200_Config; external 'Pci-Dask.dll';
function DI_7300A_Config; external 'Pci-Dask.dll';
function DI_7300B_Config; external 'Pci-Dask.dll';
function DI_InitialMemoryAllocated; external 'Pci-Dask.dll';
function DI_ReadLine; external 'Pci-Dask.dll';
function DI_ReadPort; external 'Pci-Dask.dll';
function DI_ContReadPort; external 'Pci-Dask.dll';
function DI_ContReadPortToFile; external 'Pci-Dask.dll';
function DI_ContStatus; external 'Pci-Dask.dll';
function DI_AsyncCheck; external 'Pci-Dask.dll';
function DI_AsyncClear; external 'Pci-Dask.dll';
function DI_AsyncDblBufferHalfReady; external 'Pci-Dask.dll';
function DI_AsyncDblBufferMode; external 'Pci-Dask.dll';
function DI_AsyncDblBufferTransfer; external 'Pci-Dask.dll';
function DI_ContMultiBufferSetup; external 'Pci-Dask.dll';
function DI_ContMultiBufferStart; external 'Pci-Dask.dll';
function DI_AsyncMultiBufferNextReady; external 'Pci-Dask.dll';
function DI_AsyncDblBufferOverrun; external 'Pci-Dask.dll';
function DI_EventCallBack; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function DO_7200_Config; external 'Pci-Dask.dll';
function DO_7300A_Config; external 'Pci-Dask.dll';
function DO_7300B_Config; external 'Pci-Dask.dll';
function DO_InitialMemoryAllocated; external 'Pci-Dask.dll';
function DO_WriteLine; external 'Pci-Dask.dll';
function DO_WritePort; external 'Pci-Dask.dll';
function DO_ReadLine; external 'Pci-Dask.dll';
function DO_ReadPort; external 'Pci-Dask.dll';
function DO_ContWritePort; external 'Pci-Dask.dll';
function DO_PGStart; external 'Pci-Dask.dll';
function DO_PGStop; external 'Pci-Dask.dll';
function DO_ContStatus; external 'Pci-Dask.dll';
function DO_AsyncCheck; external 'Pci-Dask.dll';
function DO_AsyncClear; external 'Pci-Dask.dll';
function EDO_9111_Config; external 'Pci-Dask.dll';
function DO_WriteExtTrigLine; external 'Pci-Dask.dll';
function DO_ContMultiBufferSetup; external 'Pci-Dask.dll';
function DO_ContMultiBufferStart; external 'Pci-Dask.dll';
function DO_AsyncMultiBufferNextReady; external 'Pci-Dask.dll';
function DO_EventCallBack; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function DIO_PortConfig; external 'Pci-Dask.dll';
function DIO_SetDualInterrupt; external 'Pci-Dask.dll';
function DIO_SetCOSInterrupt; external 'Pci-Dask.dll';
function DIO_GetCOSLatchData; external 'Pci-Dask.dll';
function DIO_INT1_EventMessage; external 'Pci-Dask.dll';
function DIO_INT2_EventMessage; external 'Pci-Dask.dll';
function DIO_7300SetInterrupt; external 'Pci-Dask.dll';
function DIO_AUXDI_EventMessage; external 'Pci-Dask.dll';
function DIO_T2_EventMessage; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function CTR_Setup; external 'Pci-Dask.dll';
function CTR_Clear; external 'Pci-Dask.dll';
function CTR_Read; external 'Pci-Dask.dll';
function CTR_Update; external 'Pci-Dask.dll';
function CTR_8554_ClkSrc_Config; external 'Pci-Dask.dll';
function CTR_8554_CK1_Config; external 'Pci-Dask.dll';
function CTR_8554_Debounce_Config; external 'Pci-Dask.dll';
function GCTR_Setup; external 'Pci-Dask.dll';
function GCTR_Clear; external 'Pci-Dask.dll';
function GCTR_Read ; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function AI_GetEvent; external 'Pci-Dask.dll';
function AO_GetEvent; external 'Pci-Dask.dll';
function DI_GetEvent; external 'Pci-Dask.dll';
function DO_GetEvent; external 'Pci-Dask.dll';
(*---------------------------------------------------------------------------*)
function AI_GetView; external 'Pci-Dask.dll';
function DI_GetView; external 'Pci-Dask.dll';
function DO_GetView; external 'Pci-Dask.dll';

end.

