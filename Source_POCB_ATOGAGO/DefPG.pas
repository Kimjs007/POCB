unit DefPG;

interface
{$I Common.inc}

const

  //============================================================================
  // PG/SPI Common
  //============================================================================

  //----------------------------------------------------------------------------
  PGSPI_MAIN_PG   = 0;
  PGSPI_MAIN_QSPI = 1;
  {$IF (Defined(INSPECTOR_GB) or Defined(INSPECTOR_AC))}  //AutoGB|AutoAC
  PGSPI_MAIN_TYPE = PGSPI_MAIN_QSPI;
  {$ELSE}
  PGSPI_MAIN_TYPE = PGSPI_MAIN_PG;
  {$ENDIF}

  //
  PG_TYPE_NONE  = 0;
  PG_TYPE_DP489 = 1;  //TBD:FoldPOCB(PG_TYPE_DP489=0;PG_TYPE_DP200=1),SystemConfig > Device Option > PG Type?
  PG_TYPE_DP201 = 2;  // DP201 (1PG1CH)
  PG_TYPE_DP200 = 3;  // DP200 (1PG2CH)

  //
  SPI_TYPE_NONE       = 0;
  SPI_TYPE_DJ023_SPI  = 1;
  SPI_TYPE_DJ201_QSPI = 2;
  SPI_TYPE_DJ021_QSPI = 3;

  //----------------------------------------------------------------------------
  IPADDR_PC_BASE      = 10;
  UDP_BINDING_IDX_PG  = 0;
  UDP_BINDING_IDX_SPI = 1;

{$IFDEF SIMULATOR_PG}
  IPADDR_PG_PREFIX  = '123.168.100';
{$ELSE}
  IPADDR_PG_PREFIX  = '123.168.10';
{$ENDIF}
  IPADDR_PG_BASE    = 1;

{$IFDEF SIMULATOR_SPI}
  IPADDR_DJ023_PREFIX = '123.168.100'; //SPI(DJ023)
  IPADDR_QSPI_PREFIX  = '192.168.99';  //QSPI(DJ021|DJ201)
{$ELSE}
  IPADDR_DJ023_PREFIX = '123.168.10';  //SPI(DJ023)
  IPADDR_QSPI_PREFIX  = '192.168.199'; //QSPI(DJ021|DJ201)
{$ENDIF}
  IPADDR_DJ023_BASE   = 31;
  IPADDR_QSPI_BASE    = 11;

  PGSPI_DEFAULT_PORT = 6889;
  PGSPI_PACKET_SIZE  = 1024;

  //----------------------------------------------------------------------------

  // Power On/Off
	CMD_POWER_OFF = 0;
	CMD_POWER_ON  = 1;

  // I2C Command Ack Waiting Time
  PG_I2CCMD_WAIT_MSEC   = 3000;
  SPI_I2CCMD_WAIT_MSEC  = 3000;

  // PG BMP Max
  MAX_BMP_CNT        = 40;

  // Power Items
  PWR_VCC     = 0;
  PWR_VDD_VEL = 1;  //Auto(VDD),Foldable(VEL) //=PWR_ELVDD,PWR_VBL
  PWR_VBR     = 2;
  PWR_ICC     = 3;
  PWR_IDD_IEL = 4;  //Auto(IDD),Foldable(IEL) //=PWR_ELIDD,PWR_IBL
  PWR_MAX     = PWR_IDD_IEL;
  PWR_VDDXXX  = 2;    //SPI (NOT-USED) //TBD:MERGE?

  // Pattern Type
  PTYPE_NORMAL = 0;   //일반패턴
  PTYPE_BITMAP = 1;   //BMP
  PTYPE_NONE   = $ff; //Initial

  // PG/SPI Download Status?
  PGSPI_DOWNLOAD_START        = 1; // 'S' //PG/SPI|QSPI
  PGSPI_DOWNLOAD_END          = 2; // 'E' //PG/SPI|QSPI
  PGSPI_DOWNLOAD_BOOT         = 3; // 'B' //DJ021|DJ201: BOOT //TBD:MERGE?
  PGSPI_DOWNLOAD_FLASH_CBDATA = 4; //POCB(SPI:FLASH_CBDATA)   //TBD:MERGE?

  //
  FLASH_UNITDATABUF_MAX = 9;        //FOLD(EDNA):FLASH (Flash Acces Address for Write, except CBDATA)
  FLASH_DATAUNIT_SIZE   = 4*1024;   //FOLD(EDNA):FLASH (FLash Erase/Write Unit: EDNA=4k) //TBD:MERGE?
  FLASH_READ_WAIT_MSEC  = 3000;     //FOLD(EDNA):FLASH (ReadWaitTime?)

  //============================================================================
  // DP489(PG)/DP200(PG)
  //    - ETHERNET, 10/100/1000 Mbps
  //    - UDP (PG:Client,PC:Server), Port(6889)
  //    - IP  (PC:123.168.10.10, PG:123.168.10.1~), Subnet(255.255.255.0)
  //============================================================================

  //----------------------------------------------------------------------------
  CMD_PG_READY      = $01;  // #CMD_READY
  CMD_PG_RESULT_ACK = $04;  //DP489|DP200|DP201	#SIG_CMD_OK #CMD_RESULT_ACK
  CMD_PG_RESULT_NAK = $05;  //DP489|DP200|DP201	#SIG_CMD_NG #CMD_RESULT_NAK

  //----------------------------------------------------------------------------
  SIG_PG_OP_MODEL         = $06;  //DP489|DP200|DP201 //OpModelLoad
  SIG_PG_OP_ALDP_MODEL    = $07;  //-----|DP200|DP201 //Op2ModelLoad
//SIG_PG_FREQ_CHANGE      = $08;  //DP489|DP200|DP201 //Frequency Change(Fpga Timing & Clock Delay)
  SIG_PG_DISPLAY_PAT      = $10;  //DP489|DP200|DP201 //DisplayPattern
      PGSIG_DISPLAY_OFF = 0;
      PGSIG_DISPLAY_ON  = 1;
  SIG_PG_READ_VOLTCUR     = $11;  //DP489|DP200|DP201 //StatusMode
  SIG_PG_PWR_ON           = $12;  //DP489|DP200|DP201 //StartMode
  SIG_PG_PWR_OFF          = $13;  //DP489|DP200|DP201 //StopMode
  SIG_PG_SETCOLOR_PALLET  = $14;  //DP489|DP200|DP201 //SetColorPallet?  //FoldFI(FEATURE_GRAY_CHANGE) //R#/G#/B# OffsetValue: -4095(-255*16)~4095(255*16)
  SIG_PG_LVDS_BITCHECK    = $15;  //DP489|DP200|DP201 //LVDS Bit Check Mode //A2CHv2:GM(LVDS checking function is required. But, NOT-USED)
  SIG_PG_I2C_MODE         = $17;  //DP489|DP200|DP201 //I2C Data Chipcheck/Read/Write Mode //FoldFI(PG_I2C)
  SIG_PG_EXT_POWER_SEQ    = $19;  //-----|DP200|DP201 //Ext_PWR_SeqMode
//SIG_PG_CHANNEL_SET      = $30;  //DP489|DP200|DP201 //Channel Set Mode
  SIG_PG_WP_ONOFF         = $33;  //DP489|DP200|DP201 //WPOnOffMode //TBD:MERGE?
  SIG_PG_SET_DIMMING      = $36;  //DP489|DP200|DP201 //VBR Min/Max Setting //FoldFI|FoldPOCB(Dimming)
  SIG_PG_PWR_OFFSET_WRITE = $40;  //DP489|DP200|DP201 //Voltage/Current Offset Setting
    //  PC -> PG: SigId(0x40) - Voltage/Current Offset Setting(Write)
    //    - unsigned char VCC Polarity;       /* ‘-‘ or ‘+’ */
    //    - unsigned char VCC Offset;         /* 0 ~ 25 (0~2.5 V) */
    //    - unsigned char ICC Polarity;       /* ‘-‘ or ‘+’ */
    //    - unsigned char ICC Offset;         /* 0 ~ 255(0~255 mA) */
    //    - unsigned char VDD/VBL Polarity;   /* ‘-‘ or ‘+’ */
    //    - unsigned char VDD/VBL Offset;     /* 0 ~ 50(0~5.0 V) */
    //    - unsigned char IDD/IBL Polarity;   /* ‘-‘ or ‘+’ */
    //    - unsigned char IDD/IBL Offset;     /* 0 ~ 255(0~2.55A) */
    //  PG -> PC: SigId (0x04) for OK or SigId (0x05) for NOK
    //    - unsigned char 0x40 (Voltage/Current Offset Setting)
  SIG_PG_PWR_OFFSET_READ  = $41;  //DP489|DP200|DP201 //Voltage/Current Offset ReadMode
    //  PC -> PG: SigId(0x41) - Voltage/Current Offset Read
    //  PG -> PC: OK(0x04), NOK(0x05)
    //    - unsigned char 0x41 (Voltage/Current Offset Read)
    //    - unsigned char VCC Polarity;       /* ‘-‘ or ‘+’ */
    //    - unsigned char VCC Offset;         /* 0 ~ 25 (0~2.5 V) */
    //    - unsigned char ICC Polarity;       /* ‘-‘ or ‘+’ */
    //    - unsigned char ICC Offset;         /* 0 ~ 255(0~255 mA) */
    //    - unsigned char VDD/VBL Polarity;   /* ‘-‘ or ‘+’ */
    //    - unsigned char VDD/VBL Offset;     /* 0 ~ 50(0~5.0 V) */
    //    - unsigned char IDD/IBL Polarity;   /* ‘-‘ or ‘+’ */
    //    - unsigned char IDD/IBL Offset;     /* 0 ~ 255(0~2.55A) */
//SIG_PG_DIMMING_MODE     = $43;  //DP489|DP200|DP201 //DimmingMode
//SIG_PG_FAILSAFE_MODE    = $44;  //DP489|DP200|DP201 //FailsafeMode
  SIG_PG_DISPLAY_ONOFF    = $51;  //DP489|DP200|DP201 //DisplayOff  //AutoPOCB(A2CHv3:ASSY:FLOW)
//SIG_PG_CURSOR_ONOFF     = $60;  //DP489|DP200|DP201 //Cursor OnOff
  SIG_PG_SETCOLOR_RGB     = $61;  //DP489|DP200|DP201 //SetColorPallet? //R#/G#/B# Value: 0~255 //2022-08-01 AutoPOCB(UNIFORMITY_PUCONOFF)
      SETCOLOR_RGB_PALLET_DEFAULT   = 0;
      SETCOLOR_RGB_PALLET1_FG       = 1;
      SETCOLOR_RGB_PALLET2_BG       = 2;
      SETCOLOR_RGB_PALLET3_BG       = 3;
      SETCOLOR_RGB_PALLET4_POSCOLOR = 4;
//SIG_PG_MEASURE_MODE     = $70;  //DP489|DP200|DP201 //Measure Mode	#SIG_MEASURE_MODE
  SIG_PG_POWERCAL_MODE    = $80;  //DP489|DP200|DP201 //Calibration Mode
    //  PC -> PG: SigId(0x80) - Power Calibration
    //    - unsigned char ‘cals’;       /* vcr0~2,vdr0~2,vbr0~1,icr0~1,idr0~1,ibr0~1,cale,‘+’,’-‘*/
    //  PG -> PC: OK(0x04), NOK(0x05)
    //    - unsigned char 0x80 (Power Calibrarion)
    //    - unsigned char VCC Polarity;       /* ‘-‘ or ‘+’ */
    //    - unsigned char VCC Offset;         /* 0 ~ 25 (0~2.5 V) */
    //    - unsigned char ICC Polarity;       /* ‘-‘ or ‘+’ */
    //    - unsigned char ICC Offset;         /* 0 ~ 255(0~255 mA) */
    //    - unsigned char VDD/VBL Polarity;   /* ‘-‘ or ‘+’ */
    //    - unsigned char VDD/VBL Offset;     /* 0 ~ 50(0~5.0 V) */
    //    - unsigned char IDD/IBL Polarity;   /* ‘-‘ or ‘+’ */
    //    - unsigned char IDD/IBL Offset;     /* 0 ~ 255(0~2.55A) */
  SIG_PG_PWR_AUTOCAL_MODE = $81;  //DP489|DP200|DP201 //Power AutoCal Mode //#SIG_AUTO_CALIBRATION
{$IFDEF PANEL_AUTO}
  SIG_PG_PWR_AUTOCAL_DATA = $82;  //DP489|DP200|DP201 //Power CalData Check Mode(AUTO|ATO)
{$ELSE}
  SIG_PG_PWR_AUTOCAL_DATA = $83;  //DP489|DP200|DP201 //Power CalData Chekc Mode(FOLD|GA)
{$ENDIF}
  SIG_PG_FIRST_CONNREQ    = $91;  //DP489|DP200|DP201 //Connection Request
  SIG_PG_CONN_CHECK       = $92;  //DP489|DP200|DP201 //Connection Check Mode
  SIG_PG_RESET            = $94;  //DP489|DP200|DP201 //RestartMode
  SIG_PG_BMP_DOWNLOAD     = $fa;  //DP489|DP200|DP201 //BMP Download Mode
      PGSIG_BMPDOWN_TYPE_BMP     = 1; //BMP, RAW데이터: 자체 변환 포맷//FUSING_TYPE_BMP->
      PGSIG_BMPDOWN_TYPE_COMPBMP = 2; //POCB CompBMP(2~)              //FUSING_TYPE_BMP_DATA->
  SIG_PG_FW_ALL_FUSING    = $fc;  //DP489|DP200|DP201
  SIG_PG_FW_VER_REQ       = $fe;  //DP489|DP200|DP201
  SIG_PG_FW_DOWNLOAD      = $ff;  //DP489|DP200|DP201 //FW DownLoad Mode
      //DP489
      PGSIG_DP489_FWDOWN_TYPE_FW   = 0; //#FUSING_TYPE_PG_DP489_FW     = 0;
      PGSIG_DP489_FWDOWN_TYPE_FPGA = 1; //#FUSING_TYPE_PG_DP489_FPGA   = 1;
      //DP200|DP201
      PGSIG_DP20X_FWDOWN_TYPE_FPGA = 0; //#FUSING_TYPE_PG_DP200_FPGA   = 0;
      PGSIG_DP20X_FWDOWN_TYPE_FW   = 1; //#FUSING_TYPE_PG_DP200_FW     = 1;
      PGSIG_DP20X_FWDOWN_TYPE_ALDP = 2; //#FUSING_TYPE_PG_DP200_ALDP   = 2;
      PGSIG_DP20X_FWDOWN_TYPE_DLPU = 3; //2023-07-01

  //---------------------------------------------------------------------------- OpModel
  // frmModelInfo.cmbxDispModeSignalType=SigType (0:LVDS,1:QUAD,2:eDP4Lane,3:eDP8Lane), PGSIG.OpModel.model[3:0] (1:LVDS,5:QUAD,2:eDP4Lane,9:eDP8Lane)
  PG_MODELINFO_SIGTYPE_LVDS     = 0;   PGSIG_OPMODEL_SIGTYPE_LVDS     = 1;
  PG_MODELINFO_SIGTYPE_QUAD     = 1;   PGSIG_OPMODEL_SIGTYPE_QUAD     = 5;
  PG_MODELINFO_SIGTYPE_eDP4Lane = 2;   PGSIG_OPMODEL_SIGTYPE_eDP4Lane = 2; //ALDP
  PG_MODELINFO_SIGTYPE_eDP8Lane = 3;   PGSIG_OPMODEL_SIGTYPE_eDP8Lane = 9; //ALDP

  //============================================================================
  // DJ021(QSPI)/DJ023(SPI)
  //    - ETHERNET, 10/100/1000Mbps
  //    - UDP (PG:Client,PC:Server), Port(6889)
  //    - IP  (PC:123.168.10.10,  SPI:123.168.10.31~),   Subnet(255.255.255.0) //DJ023: A2CH|A2CHv2|A2CHv3
  //    - IP  (PC:192.168.199.10, QSPI:192.168.199.11~), Subnet(255.255.255.0) //DJ201: A2CHv4
  //============================================================================

  //----------------------------------------------------------------------------
  CMD_SPI_READY      = $01;
  CMD_SPI_RESULT_ACK = $06; //DJ021|DJ201|DJ023	#CMD_SPI_RESULT_ACK
  CMD_SPI_RESULT_NAK = $15; //DJ021|DJ201|DJ023	#CMD_SPI_RESULT_NAK

  //----------------------------------------------------------------------------
  SIG_SPI_FIRST_CONN           = $0001; //DJ021|DJ201|DJ023
  SIG_SPI_CONN_CHECK_REQ       = $0002; //DJ021|DJ201|DJ023
  SIG_SPI_CONN_CHECK_ACK       = $0003; //DJ021|DJ201|DJ023

  //DJ021|DJ201_QSPI
  SIG_DJ021_MODEL_INFO_REQ     = $0012; //DJ021|DJ201|-----
  SIG_DJ021_MODEL_INFO_ACK     = $0013; //DJ021|DJ201|-----
  SIG_DJ021_MODEL_CRC_REQ      = $0014; //DJ021|DJ201|-----
  SIG_DJ021_MODEL_CRC_ACK      = $0015; //DJ021|DJ201|-----
  //DJ023_SPI
  SIG_DJ023_MODEL_INFO_REQ     = $0006; //-----|-----|DJ023
  SIG_DJ023_MODEL_INFO_ACK     = $0007; //-----|-----|DJ023

  SIG_SPI_I2C_REQ              = $0016; //DJ021|DJ201|DJ023
  SIG_SPI_I2C_ACK              = $0017; //DJ021|DJ201|DJ023
//SIG_SPI_SENSING_REQ          = $0018; //DJ021|DJ201|DJ023 //TBD?
//SIG_SPI_SENSING_ACK          = $0019; //DJ021|DJ201|DJ023 //TBD?
  SIG_SPI_FLASH_ACCESS_REQ     = $0020; //DJ021|DJ201|DJ023 #SIG_SPI_EXT_FLASH_ACC
  SIG_SPI_FLASH_ACCESS_ACK     = $0021; //DJ021|DJ201|DJ023 #SIG_SPI_EXT_FLASH_ACC_REV

  //DJ021|DJ201_QSPI
  SIG_DJ021_EEPROM_WP_REQ      = $0022; //DJ021|DJ201|-----
  SIG_DJ021_EEPROM_WP_ACK      = $0023; //DJ021|DJ201|-----

  SIG_SPI_FLASH_ERASE_REQ      = $0024; //DJ021|DJ201|DJ023 #SIG_SPI_QSPI_ERASE_REQ
  SIG_SPI_FLASH_ERASE_ACK      = $0025; //DJ021|DJ201|DJ023 #SIG_SPI_QSPI_ERASE_REV
  SIG_SPI_FLASH_WRITE_REQ      = $0026; //DJ021|DJ201|DJ023 #SIG_SPI_QSPI_WRITE_REQ
  SIG_SPI_FLASH_WRITE_ACK      = $0027; //DJ021|DJ201|DJ023 #SIG_SPI_QSPI_WRITE_REV
  SIG_SPI_FLASH_READ_REQ       = $0028; //DJ021|DJ201|DJ023 #SIG_SPI_QSPI_READ_REQ
  SIG_SPI_FLASH_READ_ACK       = $0029; //DJ021|DJ201|DJ023 #SIG_SPI_QSPI_READ_REV
//SIG_SPI_QSPI_AUTO_REQ        = $0030; //DJ021|DJ201|DJ023 //TBD?
//SIG_SPI_QSPI_AUTO_REV        = $0031; //DJ021|DJ201|DJ023 //TBD?

  //DJ023_SPI
  SIG_DJ023_FLASH_INIT_REQ     = $0032; //-----|-----|DJ023
  SIG_DJ023_FLASH_INIT_ACK     = $0033; //-----|-----|DJ023

//SIG_SPI_SENS_ENABLE_REQ      = $0040; //DJ021|DJ201|DJ023 //TBD?
//SIG_SPI_SENS_ENABLE_ACK      = $0041; //DJ021|DJ201|DJ023 //TBD?

  //QSPI_DJ021|DJ201
//SIG_DJ021_GPIO_READ_REQ      = $0042; //DJ021|DJ201|-----
//SIG_DJ021_GPIO_READ_ACK      = $0043; //DJ021|DJ201|-----
  SIG_DJ021_DIMMING_REQ        = $0044; //DJ021|DJ201|----- //TBD?
  SIG_DJ021_DIMMING_ACK        = $0045; //DJ021|DJ201|----- //TBD?

  //DJ023_SPI
  SIG_DJ023_DATA_DOWN_ACK      = $0050; //-----|-----|DJ023 //LVDS_Gain_Packet_Ack?? #SIG_SPI_DATA_DOWN_REV(0050) //TBD:SPI? 
  SIG_DJ023_SIG_SOURCE_SEL_REQ = $0050; //-----|-----|DJ023
  SIG_DJ023_SIG_SOURCE_SEL_ACK = $0051; //-----|-----|DJ023
//SIG_DJ023_DISPLAY_PAT_REQ    = $0052; //-----|-----|DJ023 //TBD?
//SIG_DJ023_DISPLAY_PAT_ACK    = $0053; //-----|-----|DJ023 //TBD?
  SIG_DJ023_SIG_ON_OFF_REQ     = $0054; //-----|-----|DJ023 #SIG_SPI_SIG_ON_OFF_REQ
  SIG_DJ023_SIG_ON_OFF_ACK     = $0055; //-----|-----|DJ023 #SIG_SPI_SIG_ON_OFF_REV

  //QSPI_DJ021|DJ201
  SIG_DJ021_NG_STATUS_REQ      = $0052; //DJ021|DJ201|-----
  SIG_DJ021_NG_STATUS_ACK      = $0053; //DJ021|DJ201|-----
  SIG_DJ021_POWER_ON_AUTO_REQ  = $0076; //DJ021|DJ201|-----
  SIG_DJ021_POWER_ON_AUTO_ACK  = $0077; //DJ021|DJ201|-----
  SIG_DJ021_POWER_ON_REQ       = $0078; //DJ021|DJ201|-----
  SIG_DJ021_POWER_ON_ACK       = $0079; //DJ021|DJ201|-----
  SIG_DJ021_POWER_OFF_REQ      = $0080; //DJ021|DJ201|-----
  SIG_DJ021_POWER_OFF_ACK      = $0081; //DJ021|DJ201|-----
  SIG_DJ021_READ_POWER_REQ     = $0082; //DJ021|DJ201|----- #SIG_READ_VOLTCUR_REQ
  SIG_DJ021_READ_POWER_ACK     = $0083; //DJ021|DJ201|----- #SIG_READ_VOLTCUR_ACK
  SIG_DJ021_POWER_OFFSET_W_REQ = $0086; //DJ021|DJ201|----- #SIG_SPI_OFFSET_WT_REQ
  SIG_DJ021_POWER_OFFSET_W_ACK = $0087; //DJ021|DJ201|----- #SIG_SPI_OFFSET_WT_REV
  SIG_DJ021_POWER_OFFSET_R_REQ = $0088; //DJ021|DJ201|----- #SIG_SPI_OFFSET_RD_REQ
  SIG_DJ021_POWER_OFFSET_R_ACK = $0089; //DJ021|DJ201|----- #SIG_SPI_OFFSET_RD_REV

  SIG_SPI_RESET_REQ            = $0090; //DJ021|DJ201|DJ023
  SIG_SPI_RESET_ACK            = $0091; //DJ021|DJ201|DJ023
//SIG_SPI_CONNECTION_REQ       = $00D0; //DJ021|DJ201|DJ023
//SIG_SPI_CONNECTION_ACK       = $00D1; //DJ021|DJ201|DJ023

  //DJ021|DJ201_QSPI
  SIG_DJ021_UPLOAD_START_REQ   = $00E0; //DJ021|DJ201|-----
  SIG_DJ021_UPLOAD_START_ACK   = $00E1; //DJ021|DJ201|-----
  SIG_DJ021_UPLOAD_DATA_REQ    = $00E2; //DJ021|DJ201|-----
  SIG_DJ021_UPLOAD_DATA_ACK    = $00E3; //DJ021|DJ201|-----

  //QSPI_DJ021|DJ201
  {$IFDEF PANEL_AUTO}
  SIG_DJ021_PWR_AUTOCAL_MODE_REQ = $00E4; //DJ021|DJ201|----- #SIG_SPI_POWER_AUTO_CAL_REQ #SIG_DJ021_POWERCAL_AUTO_REQ
  SIG_DJ021_PWR_AUTOCAL_MODE_ACK = $00E5; //DJ021|DJ201|----- #SIG_SPI_POWER_AUTO_CAL_REV
  SIG_DJ021_PWR_AUTOCAL_DATA_REQ = $00E6; //DJ021|DJ201|----- #SIG_SPI_POWER_AUTO_CAL_DATA_REQ #SIG_DJ021_POWERCAL_DATA_REQ
  SIG_DJ021_PWR_AUTOCAL_DATA_ACK = $00E7; //DJ021|DJ201|----- #SIG_SPI_POWER_AUTO_CAL_DATA_REV
  {$ELSE}
  SIG_DJ021_PWR_AUTOCAL_MODE_REQ = $00D4; //DJ021|DJ201|----- #SIG_SPI_POWER_AUTO_CAL_REQ
  SIG_DJ021_PWR_AUTOCAL_MODE_ACK = $00D5; //DJ021|DJ201|----- #SIG_SPI_POWER_AUTO_CAL_REV
  SIG_DJ021_PWR_AUTOCAL_DATA_REQ = $00D6; //DJ021|DJ201|----- #SIG_SPI_POWER_AUTO_CAL_DATA_REQ
  SIG_DJ021_PWR_AUTOCAL_DATA_ACK = $00D7; //DJ021|DJ201|----- #SIG_SPI_POWER_AUTO_CAL_DATA_REV
  {$ENDIF}

  SIG_SPI_FW_VER_REQ           = $00F0; //DJ021|DJ201|DJ023
  SIG_SPI_FW_VER_ACK           = $00F1; //DJ021|DJ201|DJ023

  //QSPI_DJ021|DJ201
  SIG_SPI_FW_DOWN_REQ          = $00F2; //DJ021|DJ201|-----
  SIG_SPI_FW_DOWN_ACK          = $00F3; //DJ021|DJ201|-----
      SPISIG_FWDOWN_TYPE_FW   = 0;
      SPISIG_FWDOWN_TYPE_BOOT = 1;

//============================================================================
// PG/SPI Debug Log
//============================================================================

  DEBUG_LOG_DEVTYPE_PG         = 0;
  DEBUG_LOG_DEVTYPE_SPI        = 1;
  {$IFDEF DF136_USE}
  DEBUG_LOG_DEVTYPE_DF136      = 2; //FoldableFI-Only
  DEBUG_LOG_DEVTYPE_MAX        = DEBUG_LOG_DEVTYPE_DF136;
  {$ELSE}
  DEBUG_LOG_DEVTYPE_MAX        = DEBUG_LOG_DEVTYPE_SPI;
  {$ENDIF}

  DEBUG_LOG_MSGTYPE_UNKNOWN    = 0;
  DEBUG_LOG_MSGTYPE_INSPECT    = 1;
  DEBUG_LOG_MSGTYPE_POWERREAD  = 2;
  DEBUG_LOG_MSGTYPE_CONNCHECK  = 3;
  DEBUG_LOG_MSGTYPE_DOWNDATA   = 4;
  DEBUG_LOG_MSGTYPE_MAX        = DEBUG_LOG_MSGTYPE_DOWNDATA;

  DEBUG_LOG_LEVEL_CONFIG_INI   = -1; // set to SystemConfig.DEBUG
  DEBUG_LOG_LEVEL_NONE         = 0;  // None
  DEBUG_LOG_LEVEL_INSPECT      = 1;  // INSPECT
  DEBUG_LOG_LEVEL_POWERREAD    = 2;  // INSPECT+POWERREAD
  DEBUG_LOG_LEVEL_CONNCHECK    = 3;  // INSPECT+POWERREAD+CONNCHECK
  DEBUG_LOG_LEVEL_DOWNDATA     = 4;  // INSPECT+POWERREAD+CONNCHECK_DOWNDATA(FW|BMP|FLASH)
  DEBUG_LOG_LEVEL_MAX          = DEBUG_LOG_LEVEL_DOWNDATA;
	
//******************************************************************************
// below.................TBD
//******************************************************************************

implementation

end.


