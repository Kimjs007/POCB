unit CommonClass;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.ShellAPI, Winapi.Messages, Winapi.WinSock,
  System.Classes, System.IniFiles, System.UITypes, System.SysUtils, 
	{System.threading,} System.Math, System.zip, System.IOUtils,
  Generics.Collections, IdGlobal, IdSocketHandle, Graphics, DateUtils, StrUtils,
  AdvGrid, AdvObj, AdvGridWorkbook, Vcl.Forms, Vcl.Dialogs,
  DefPocb, DefCam, DefGmes, DefIonizer, DefDio, DefMotion, DefPG, UserUtils, DongaPattern,
{$IFDEF HAS_ROBOT_CAM_Z}
	DefRobot,
{$ENDIF}	
	CodeSiteLogging;

type

{$IFDEF DFS_HEX}
  TDfsConfInfo = record
    bUseDfs             : Boolean;
    bDfsHexCompress     : Boolean;
    bDfsHexDelete       : Boolean;  // valid if only bDfsHexCompress is True
    sDfsServerIP        : string;
    sDfsUserName        : string;
    sDfsPassword        : string;
    //
    bUseCombiDown       : Boolean;
    sCombiDownPath      : string;
  end;

  TCombiCodeData = record
    sINIFileName : string;
    sINIDownTime : string; // for FLDR
    sVersion     : string;
    nGridCol     : Integer;
    nGridRow     : Integer;
    nOrigin      : array [DefPocb.CH_1..DefPocb.CH_2] of Integer; //A2CHv3:MULTIPLE_MODEL
    sRcpName     : array [DefPocb.CH_1..DefPocb.CH_2] of string;  //A2CHv3:MULTIPLE_MODEL
    sProcessNo   : array [DefPocb.CH_1..DefPocb.CH_2] of string;  //A2CHv3:MULTIPLE_MODEL
    nRouterNo    : array [DefPocb.CH_1..DefPocb.CH_2] of Integer; //A2CHv3:MULTIPLE_MODEL
    MainButton   : array [0..4] of string;
    DefectMat    : array [0..4] of array [0..99] of string; //max 100
    Color        : array [0..4] of Integer;
    GibOK        : array of array of string;
    Priority     : array [0..4] of string;
    Origin       : Integer;
    bAuthority   : Boolean;
    DefectCnt    : Integer;
  end;
{$ENDIF}

  TGmesDataPack = record    //2019-06-19 jhhwang (Move from GMesCom to Common for DFS without GMES)
    //
    MesPendingMsg : Integer;
    MesSentMsg    : Integer;
    MesSendRcvWaitTick : Integer;
    TxSerial      : string;
    //
    SerialNo  : string;
    CarrierId : String;
    Model     : string;
    Pf        : string;
    Rwk       : string;
    DefectPat : string;
    //
  //bPCHK     : Boolean;
    PchkSendNg      : Boolean;
    bRxPchkRtnPid   : Boolean;//2021-12-23
    PchkRtnCd     	: String; // PCHK_R.RTN_CD
    PchkRtnSerialNo : String; // PCHK_R.RTN_SERIAL_NO
    PchkRtnPid      : String; // PCHK_R.RTN_PID
    PchkRtnModel    : String; // PCHK_R.MODEL //2019-07-25
    PchkRtnSubPid   : String; // PCHK_R.RTN_SUB_PID  //A2CHv3:ASSYPOCB:MES
    PchkRtnPcbid    : String; // PCHK_R.RTN_PCBID    //A2CHv4:Lucid
    EicrSendNg      : Boolean;
    EicrRtnCd				: String; // EICR_R.RTN_CD
    ZsetSendNg      : Boolean;
    ZsetRtnCd				: String; // ZSET_R.RTN_CD
    //
    ApdrApdInfo     : string;
    MesApdrSendNg   : Boolean;
    MesApdrRtnCd    : String; // (GMES) APDR_R.RTN_CD
    EasApdrSendNg   : Boolean;
    EasApdrRtnCd    : String; // (EAS) APDR_R.RTN_CD
  end;

{$IFDEF HAS_ROBOT_CAM_Z}
  TRobotSysInfo = record
    MyIpAddr          : string;  // [ROBOT_DATA] RobotMyIpAddr,
    IPAddr            : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of String; // [ROBOT_DATA] Robot1IPAddr, Robot2IPAddr
    TcpPortModbus     : Integer; // [ROBOT_DATA] RobotTcpPortModbus
    TcpPortListenNode : Integer; // [ROBOT_DATA] RobotTcpPortListenNode
    SpeedMax          : UInt16;  // [ROBOT_DATA] RobotSpeedMax
    StartupMoveType   : enumRobotStartupMoveType; // [ROBOT_DATA] RobotStartupMoveType // 0:NONE(default), 1:HOME, 2:MODEL
    HomeCoord         : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of TRobotCoord; // [ROBOT_DATA] RobotHomeCoord_X/Y/Z/Rx/Ry/Rz
    StandbyCoord      : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of TRobotCoord; // [ROBOT_DATA] RobotStandbyCoord_X/Y/Z/Rx/Ry/Rz
    RobotCoordTolerance : Single;  // [ROBOT_DATA] RobotCoordTolerance
  end;
{$ENDIF}

  TSystemInfo = record
    EQPId	  						: String;   // [SYSTEMDATA] StationID
    Password            : String;   // [SYSTEMDATA] PASSWORD(ADMIN)
    Password_PM         : String;   // [SYSTEMDATA] PASSWORD(PM) //2023-08-03 //LENS
    TestModel           : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of String;   // [SYSTEMDATA] TESTING_MODEL     //A2CHv3:MULTIPLE_MODEL
    PatGrp              : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of string;   // [SYSTEMDATA] TESTING_PAT_GROUP //A2CHv3:MULTIPLE_MODEL
    // PG
  //ChCountUsed         : Integer;  // [SYSTEMDATA]
    PGMemorySize        : Integer;  // [SYSTEMDATA] PG_MEMORY_SIZE  // PG Memory 128Mb, 256Mb, 512Mb
    IPAddr_PG           : array[DefPocb.PG_1..DefPocb.PG_MAX] of String;  // [SYSTEMDATA] IP_ADDR_PG1~IP_ADDR_PG2   //PG(DP489|DP200|DP201)
    IPAddr_SPI          : array[DefPocb.PG_1..DefPocb.PG_MAX] of String;  // [SYSTEMDATA] IP_ADDR_SPI1~IP_ADDR_SPI2 //SPI(DJ021|DJ201|DJ023)
    UseCh               : array[DefPocb.CH_1..DefPocb.CH_MAX] of Boolean; // [SYSTEMDATA] USE_CH_1~USE_CH_2

    PGSPI_MAIN          : Integer;  //TBD:MERGE:SYSINFO?
    PG_TYPE             : Integer;  // [SYSTEMDATA] PG_TYPE
    SPI_TYPE            : Integer;  // [SYSTEMDATA] SPI_TYPE

    // PG/SPI DOwnload
    PgFwDownStartWaitSec    : Integer; // [SYSTEMDATA]
    PgFwDownEndWaitSec      : Integer; // [SYSTEMDATA]
    PgFpgaDownStartWaitSec  : Integer; // [SYSTEMDATA]
    PgFpgaDownEndWaitSec    : Integer; // [SYSTEMDATA]
    PgALDPDownStartWaitSec  : Integer; // [SYSTEMDATA]
    PgALDPDownEndWaitSec    : Integer; // [SYSTEMDATA]
    PgDLPUDownStartWaitSec  : Integer; // [SYSTEMDATA]
    PgDLPUDownEndWaitSec    : Integer; // [SYSTEMDATA]
    PgBmpDownStartWaitSec   : Integer; // [SYSTEMDATA]
    PgBmpDownEndWaitSec     : Integer; // [SYSTEMDATA]
    PgBmpDownSetupInterDataMsec : Integer; // [SYSTEMDATA]
    PgBmpDownFlowInterDataMsec  : Integer; // [SYSTEMDATA]
    SpiFwDownStartWaitSec   : Integer; // [SYSTEMDATA]
    SpiFwDownEndWaitSec     : Integer; // [SYSTEMDATA]
    SpiBootDownStartWaitSec : Integer; // [SYSTEMDATA]
    SpiBootDownEndWaitSec   : Integer; // [SYSTEMDATA]

		// DIO //2022-07-XX A2CHv4_#3
	  DAE_VERSION_INI     : String;   //[SYSTEMDATA] DAE_VERSION_INI (e.g., 1) - read-only                        //2022-07-15 INI_ADD_INFO
	  DAE_SYSTEM_ID       : String;   //[SYSTEMDATA] DAE_SYSTEM_ID   (e.g., LGDVH_AUTO_LINE2_PUC3) - read-only    //2022-07-15 INI_ADD_INFO
		//
		HasDioExLightDetect : Boolean; //[SYSTEMDATA] HasDioExLightDetect - read-only (HAS_DIO_EXLIGHT_DETECT:default=True)                //A2CHv4_#1|#2(True),#3(False)
	  HasDioFanInOutPC    : Boolean; //[SYSTEMDATA] HasDioFanInOutPC    - read-only (HAS_DIO_FAN_INOUT_PC  :default=False)               //A2CHv4_#1|#2(False),#3(True)
	  HasDioScrewShutter  : Boolean; //[SYSTEMDATA] HasDioScrwShutter   - read-only (HAS_DIO_SCREW_SHUTTER :default=True)                //A2CHv4_#1|#2(True), #3(False)
	  HasDioVacuum        : Boolean; //[SYSTEMDATA] HasDioVacuum        - read-only (default:True)                                       //AUTO(True), LENS-ATO(False),LENS-GA(True)
    HasDioOutPGOff      : Boolean; //[SYSTEMDATA] HasDioOutPGOff      - read-only (HAS_DIO_PG_OFF        :default=False)               //2023.05~ ATO|GA~
    HasDioYAxisMC       : Boolean; //[SYSTEMDATA] HasDioYAxisMC       - read-only (HAS_DIO_Y_AXIS_MC     :default:False)               //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(True)
    HasDioInDoorLock    : Boolean; //[SYSTEMDATA] HasDioInDoorLock    - read-only (HAS_DIO_IN_DOOR_LOCK  :default=False)               //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(True)
    HasDioOutStageLamp  : Boolean; //[SYSTEMDATA] HasDioOutStageLamp  - read-only (HAS_DIO_OUT_STAGE_LAMP:default:False)               //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(True)
    HasDioOutIonBar     : Boolean; //[SYSTEMDATA] HasDioOutIonBar     - read-only (HAS_DIO_OUT_IONBAR    :default:False)               //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(True)
    KeepDioShutterUp    : Boolean; //[SYSTEMDATA] KeepDioShutterUp    - read-only (FEATURE_KEEP_SHUTTER_UP:default:True)               //2023-08-03
    UseDioLogShutter    : Boolean; //[SYSTEMDATA] UseDioLogShutter    - read-only (FEATURE_DIO_LOG_SHUTTER:default:False)              //2023-08-03
  //UseDioDoorUPS       : Boolean; //2022-07-20 ITOLED
    //
    BuzzerDefault       : Integer; //#BuzzerNo
		// Comm
    Com_RCB             : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Integer; // [SYSTEMDATA] COM_RCB1~COM_RCB2
    Com_ION             : array[0..DefIonizer.ION_MAX] of Integer;  // [SYSTEMDATA] COM_ION1~COM_ION2, COM_ION1_2~COM_ION2_2
    ION_PRODUCT_MODEL   : string;   // [SYSTEMDATA] ION_PRODUCT_MODEL // 2021-05-26
    Com_HandBCR         : Integer; 	// [SYSTEMDATA] COM_HandBCR //0:None 1:COM1, 2:COM2...
    Com_ExLight         : Integer; 	// [SYSTEMDATA] COM_ExLight //0:None 1:COM1, 2:COM2... //2019-04-16 ExLight
    Com_EFU             : Integer; 	// [SYSTEMDATA] COM_EFU     //0:None 1:COM1, 2:COM2... //2019-05-04 EFU
    ShareFolder         : string;   // [SYSTEMDATA] SHARE_FOLDER
    BmpShareFolder      : string;   // [SYSTEMDATA] BMP_SHARE_FOLDER  //2019-02-08
    PGFWName            : String;   // [SYSTEMDATA] PGFWName
    SPIFWName           : String;   // [SYSTEMDATA] SPIFWName
    MatchSerialFolder   : string;
{$IFDEF SITE_LENSVN}
    // LENS MES (HTTP/JSON)
    LensMesUrlIF        : string;  // [LENS_MES_CONFIG] LensMesUrlIF
    LensMesUrlLogin     : string;  // [LENS_MES_CONFIG] LensMesUrlToken
    LensMesUrlStart     : string;  // [LENS_MES_CONFIG] LensMesUrlStart
    LensMesUrlEnd       : string;  // [LENS_MES_CONFIG] LensMesUrlEnd
    LensMesUrlEqStatus  : string;  // [LENS_MES_CONFIG] LensMesUrlEqStatus
    LensMesUrlReInput   : string;  // [LENS_MES_CONFIG] LensMesUrlReInput
    LenMesSITE          : string;  // [LENS_MES_CONFIG] LenMesSITE
    LensMesOPERATION    : string;  // [LENS_MES_CONFIG] LensMesOPERATION
    LensMesMO           : string;  // [LENS_MES_CONFIG] LensMesMO
    LensMesITEM         : string;  // [LENS_MES_CONFIG] LensMesITEM
    LensMesSHIFT        : string;  // [LENS_MES_CONFIG] LensMesSHIFT
    LensMesWaitSec      : Integer; // [LENS_MES_CONFIG] LensMesWaitSec
{$ELSE}
    // LGD GMES
    MES_ServicePort     : String;   // [SYSTEMDATA] MES_SERVICEPORT
    MES_Network         : String;   // [SYSTEMDATA] MES_NETWORK
    MES_DaemonPort      : String;   // [SYSTEMDATA] MES_DAEMONPORT
    MES_LocalSubject    : String;   // [SYSTEMDATA] MES_LOCALSUBJECT
    MES_RemoteSubject   : String;   // [SYSTEMDATA] MES_REMOTESUBJECT
    LocalIP_GMES        : string;   // [SYSTEMDATA]
    EqccInterval        : String;   // [SYSTEMDATA]
{$ENDIF}

    UseGIB  						: Boolean;  // [SYSTEMDATA] USE_GIB  //2019-11-08
{$IFDEF SUPPORT_1CG2PANEL}
    UseAssyPOCB         : Boolean;  // [SYSTEMDATA] USE_ASSY_POCB  //A2CHv3:ASSY-POCB
    UseSkipPocbConfirm  : Boolean;  // [SYSTEMDATA] USE_SKIP_POCB_CONFIRM //A2CHv3:ASSY-POCB //2022-06-XX
{$ENDIF}
    UseEQCC             : Boolean;  // [SYSTEMDATA] USE_EQCC
    UseEicrPassOnly     : Boolean;  // [SYSTEMDATA] 2018-12-17
    UseGRR              : Boolean;
{$IFDEF USE_EAS}
    EAS_UseAPDR         : Boolean;  // [SYSTEMDATA] EAS_USE_APDR
    EAS_ServicePort     : string;   // [SYSTEMDATA] EAS_SERVICEPOR
    EAS_Network         : string;   // [SYSTEMDATA] EAS_NETWORK
    EAS_DaemonPort      : string;   // [SYSTEMDATA] EAS_DAEMONPORT
    EAS_LocalSubject    : string;   // [SYSTEMDATA] EAS_LOCALSUBJECT  //2019-11-08
    EAS_RemoteSubject   : string;   // [SYSTEMDATA] EAS_REMOTESUBJECT
{$ENDIF}
		// FTP
    HOST_FTP_IPAddr     : string;   // [SYSTEMDATA]
    HOST_FTP_User       : string;   // [SYSTEMDATA]
    HOST_FTP_Passwd     : string;   // [SYSTEMDATA]
    HOST_FTP_CombiPath  : string;   // [SYSTEMDATA]
    // GUI
    Language						: Integer;  // [SYSTEMDATA] LANGUAGE
    UIType              : Integer;  // [SYSTEMDATA] UI_TYPE // 0:Normal 1:Black
		// Etc
    AutoBackupList      : string;   // [SYSTEMDATA] AUTOBACKUP_PATH
    AutoBackupUse       : Boolean;  // [SYSTEMDATA] AUTOBACKUP_USE
    SpiResetWhenTimeout : Boolean;  // [SYSTEMDATA] SPI_RESET_WHEN_TIMEOUT //2019-04-26
    //
    UseManualSerial     : Boolean;  // [SYSTEMDATA] MANUAL_SERAIL_INPUT???
    DebugLogLevel       : Integer;  // [SYSTEMDATA] DEBUG_LOG_LEVEL
    ExLightCh_Count     : Integer;
{$IFDEF USE_FPC_LIMIT}
    // FPC Usage Limit
    FpcUsageLimitUse    : Boolean;  // [SYSTEMDATA] FPC_USAGE_LIMIT_USE   //2019-04-11
    FpcUsageLimitValue  : Integer;  // [SYSTEMDATA] FPC_USAGE_LIMIT_VALUE //2019-04-11
{$ENDIF}
{$IFDEF DFS_EXTRA}
    LogOutTime          : Integer;
{$ENDIF}
{$IFDEF DFS_HEX}
    InspectionType      : Integer;
    ProcessName         : String;
{$ENDIF}
    //
    UseBuzzer           : Boolean;  // [SYSTEMDATA] USE_BUZZER
    UseSeialMatch       : Boolean;
    PrevSerial          : Integer;
    UseAirKnife         : Boolean;
    ScreenSaverTime     : Integer;
    IdlePmModeLogInPopUpTime : Integer; //2023-10-12 IDLE_PMMODE_LOGIN_POPUP
    UseConfirmHost      : Boolean;  // ConfirmGost -> UseConfirmHost
    UseUniformityPoint  : Boolean;
    UsePinBlock         : Boolean;
    UseDetectLight      : Boolean;
    DefaultScanFist     : Boolean;
    BuzzerNo            : Integer;
    UseLogUploadPath    : Boolean; // [SYSTEMDATA] UseLogUploadPath (default:False) -- Read-only //2022-07-25 LOG_UPLOAD
  //GIB_ProcDevAddr     : Integer;  // USE_MODEL_PARAM_CSV
  //GIB_ProcRegAddr     : Integer;  // USE_MODEL_PARAM_CSV
  //GIB_ProcValue       : string;   // USE_MODEL_PARAM_CSV
    //
    EfuIcuCntPerCH      : Integer;  // [SYSTEMDATA] EfuIcuCntPerCH
    IonizerCntPerCH     : Integer;  // [SYSTEMDATA] IonizerCntPerCH
    //
    {$IFDEF FEATURE_DIO_LOG_SHUTTER}          //2023-05-02 DioLog:CH1:SHUTTER:UP
    UseDioLogShutter    : Boolean;  // [SYSTEMDATA] UseDioLogShutter
    {$ENDIF}
    //
    DebugSelfTestPg     : Boolean;  // [DEBUG] DebugSelfTestPg //2019-10-02
    DebugLogLevelConfig : array[DEBUG_LOG_DEVTYPE_PG..DEBUG_LOG_DEVTYPE_MAX] of Integer; //2020-09-16 DEBUG_LOG
  end;

  TFpgaData = record
    FpgaTime 	: Integer;
    STAD_Freq : Integer;
    H_CD_Freq : Integer;
    L_CD_Freq : Integer;
  end;

  TMODELINFO = packed record    // packed record
    PixelType    : Byte;
    Bit          : Byte;
    Rotate       : Byte;
    SigType  		 : Byte;  //cmbxDispModeSignalType=SigType (0:LVDS,1:QUAD,2:eDP4Lane,3:eDP8Lane), Sig.OpModel.model[3:0] (1:LVDS,5:QUAD,2:eDP4Lane,9:eDP8Lane)
    WP           : Byte;  //TBD:MERGE:MODELINFO_PG? AutoPOCB(X) FOldPOCB(O)
    Freq         : Integer;
    H_Total      : Word;
    H_Active     : Word;
    H_BP         : Word;
    H_Width      : Word;

    V_Total      : Word;
    V_Active     : Word;
    V_BP         : Word;
    V_Width      : Word;

    H_Polarity   : Byte;
    V_Polarity   : Byte;

    DE_Polarity  : Byte;
    Dot_edge	   : Byte;

    Pwm_freq     : Word;
    Pwm_duty     : Byte;
                                                                    // Auto(VCC,VDD,VBR,ICC,IDD) Foldable(VCC,VEL,VBR,ICC,IEL)
    PWR_VOL      : array[DefPG.PWR_VCC..DefPG.PWR_MAX] of Word;     // VCC, VDD_VEL, VBR
    PWR_OFFSET   : array[DefPG.PWR_VCC..DefPG.PWR_MAX] of Smallint; // VCC, VDD_VEL  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    PWR_LIMIT_H  : array[DefPG.PWR_VCC..DefPG.PWR_MAX] of Word;     // VCC, VDD_VEL, VBR, ICC, IDD_IEL
    PWR_LIMIT_L  : array[DefPG.PWR_VCC..DefPG.PWR_MAX] of Word;     // VCC, VDD_VEL, VBR, ICC, IDD_IEL

    Sequence     : Byte;
    I2cFreq      : Byte;
    ClockDelay   : Byte;
    I2cPullup    : Byte;
    DataLineOut  : Byte; //2018.05.16

    OpenCheck    : Byte; // 0:Disable, 1:Enable //2023-10-18 DP200|DP201
    ModelType    : Byte; // 0:Not USE, 1: FPD_340, 2: FPD_126, 3: FPD_340(New), 4: Tributo(QC), 5: Tributo(Intel) //2022-10-12 //2023-03-24 Tributo
    //
    PowerOnSeq   : array[0..3] of Word;
    PowerOffSeq  : array[0..3] of Word;
    //
    PwrSeqExtUse      : Boolean;              //2021-11-05 DP201 EXT_POWER_SEQ
    PwrSeqExtAvailCnt : Integer;
    PwrSeqExtOnIdx    : array[0..24] of Byte; // 6..24 (Reserved)
    PwrSeqExtOffIdx   : array[0..24] of Byte; // 6..24 (Reserved)
    PwrSeqExtOnDelay  : array[0..24] of Word; // 5..24 (Reserved)
    PwrSeqExtOffDelay : array[0..24] of Word; // 5..24 (Reserved)
    //
    FpgaTiming   : Word;
    PatGrpName   : string;
  end;

{$IFDEF HAS_ROBOT_CAM_Z}
  TRobotCoord = record  //A2CHv3:ROBOT
    X  : Single;
    Y  : Single;
    Z  : Single;
    Rx : Single;
    Ry : Single;
    Rz : Single;
  end;

  TRobotModelInfo = record  //A2CHv3:ROBOT
    Coord      : TRobotCoord;
    ModelCmd   : string;
  end;
{$ENDIF}

  enumLcmPosition  = (LcmPosCP=0, LcmPosLeft=1, LcmPosCenter=2, LcmPosRight=3);
  TAssyModelInfo = record  //A2CHv3:ASSY-POCB
    UseCh1     : Boolean;
    UseCh2     : Boolean;
    UseMainPidCh1 : Boolean;
    UseMainPidCh2 : Boolean;
    LcmPosCh1  : enumLcmPosition;  //0:CP/CP-GIB, 1:Left, 2:Center, 3:Right  //A2CHv3:ASSY
    LcmPosCh2  : enumLcmPosition;  //0:CP/CP-GIB, 1:Left, 2:Center, 3:Right  //A2CHv3:ASSY
  end;

  TModelParamCsvInfoRec = record  //2023-01-25
    bVersion       : Boolean; //
    nFormatType    : Integer; //0:ITOLED_AF9,1:ITOLED_TCON,2=AUTO,3=ATO,4=GAGO
    nFormatVersion : Integer; //
    sPanelModel    : string;  //
    sDate          : string;  //
  end;
  enumEepromDataType = (eepromCBParam=0, eepromProcMask=1, eepromGamma=2, eepromAfterPUC=3, eepromEtc=4);  //USE_MODEL_PARAM_CSV //2022-09-01 (add eepromAfterPUC)
  TEepromCheckRec = record
    nDevAddr, nRegAddr, nValue : Integer;
  end;
  TEepromWriteRec = record
    nDevAddr, nRegAddr, nStartValue, nEndValue : Integer;
    bStartValue, bEndValue : Boolean;
  end;
  TEepromDataRec = record
    nDevAddr, nRegAddr, nLength : Integer;
  end;
  TEepromFlashAccessRec = record
    nDevAddr, nRegAddr : Integer;
    bWriteBit : Boolean;
    nBit : Integer;  // valid if bWriteBit=True
    nByteEnable, nByteDisable : Integer; // valid if bWriteBit=False
  end;
  TFlashDataRec = record
    nFlashAddr, nLength : Integer;
  end;
  {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
  enumFlashDataType = ({flashCBParam=0, flashProcMask=1,} flashGamma=2, flashAfterPUC=3, flashEtc=4);  //USE_MODEL_PARAM_CSV //2022-09-01 (add eepromAfterPUC)
  TFlashWriteRec = record
    nFlashAddr, nValue : Integer;
    bValue : Boolean;
  end;
  TFlashWriteAfterPUCRec = record  //2023-01-25 (TModelParamPucParaFlash -> TModelParamPucParaFlashWrite)
    nAddr  : DWORD;
    nValue : array[DefCam.CAM_STEP_NONE..DefCam.CAM_STEP_MAX] of Byte;
    bValue : array[DefCam.CAM_STEP_NONE..DefCam.CAM_STEP_MAX] of Boolean;
  end;
  TFlashCBParaBlockRec = record //2023-01-25
    nAddr   : DWORD;
    nLength : DWORD;
  end;
  {$ENDIF}
  TFlashCBDataAddrRec = record
    nStartAddr, nEndAddr : Integer;
  end;
  TFlashAccessParamRec = record
    //
    EraseAckWaitSec           : Integer;
    DataStartAckWaitSec       : Integer;
    DataEndAckWaitSec         : Integer;
    DataSendInterDelayMsec    : Integer;
    //
    AccEnableBeforeDelayMsec  : Integer;
    AccEnableAfterDelayMsec   : Integer;
    InitBeforeDelayMsec       : Integer;
    InitAfterDelayMsec        : Integer;
    EraseBeforeDelayMsec      : Integer;
    EraseAfterDelayMsec       : Integer;
    DataStartBeforeDelayMsec  : Integer;
    DataStartAfterDelayMsec   : Integer;
    DataEndBeforeDelayMsec    : Integer;
    DataEndAfterDelayMsec     : Integer;
    AccDisableBeforeDelayMsec : Integer;
    AccDisableAfterDelayMsec  : Integer;
  end;
  TTConAccessParamRec = record //2022-07-15 UNIFORMITY_PUCONOFF
    Addr2DevRegConvMethod : string; //1(V2|MRA2|E2H|Lucid|Porsche|HKMC|...)
    //TBD
  end;
  TTConWriteRec = record //2022-07-15 UNIFORMITY_PUCONOFF
{$IFDEF PANEL_AUTO}
    nTConAddr          : Integer;
{$ELSE}
    nDevAddr, nRegAddr : Integer;
{$ENDIF}
  //nMask              : Integer;
    nValue             : Integer;
  //bMask              : Boolean;
    bValue             : Boolean;
  end;
  TTConParamRec = record //2022-07-15 UNIFORMITY_PUCONOFF
    PocbOnOff : array[0..1] of TTConWriteRec; //0:PocbOff, 1:PocbOn
    //TBD
  end;

  TModelInfo2 = record          //additional new items not related to Model Download with PG/SPI?
    //
    PgFwVer    : string;
    PgFpgaVer  : string;
    SpiFwVer   : string;
    SpiBootVer : string;

    //
    PwrOnDelayMSec, PwrOffDelayMSec : Integer;     //2021-12-29 (ModelInfo.PwrOffOnDelay -> ModelInfo2.PwrOnDelay/PwroffDelay)
    {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
    PowerOnAgingSec : Integer;         //2021-12-29
    {$ENDIF}
    //
    ComparedPat   : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of Integer;
		ComparePatName: array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of string;
    WhiteUniform  : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of Double;
    JudgeCount    : Integer;
    //2023-04-26 {$IFDEF FEATURE_UNIFORMITY_PUCONOFF}
    UsePucOnOff   : Boolean;
    //2023-04-26 {$ENDIF}
    //2023-04-26 {$IFDEF FEATURE_PUC_IMAGE}
    UsePucImage   : Boolean;
    //2023-04-26 {$ENDIF}
    BmpDownRetryCnt : Integer; //2021-07-07

    PowerOnPatNum    : Integer;  //2021-11-24 POWER_ON_PATTERN
    PwrMeasurePatNum : Integer;  //2022-09-06 POWER_MEASURE_PAT
  //{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
    VerifyPatNum   : Integer;
  //{$ENDIF}
    BcrLength        : Integer;  // 2018-11-22
    BcrPidChkIdx     : Integer;  //A2CHv3:BCR_PID_CHECK
    BcrPidChkStr     : string;   //A2CHv3:BCR_PID_CHECK
  //BcrMainPID       : Boolean;  //A2CHv3:BCR_PID_CHECK
    BcrScanMesSPCB   : Boolean;  //A2CHv4:Lucid:ScanSPCB
    BcrSPCBIdInterlock : Boolean; //VH#302(A2CHv4):ScanSPCB      //2023-05-19 A2CHv4:SPCB_ID_INTERLOCK
    BcrPIDInterlock    : Boolean; //VH#301(A2CHv1|A2CHv2|A2CHv3),LENS(ATO) //2023-09-26 VH#301(A2CHv1|A2CHv2|A2Chv3):PID_INTERLOCK //2023-10-10 LENS(ATO):PID_INTERLOCK
    //
    AssyModelInfo    : TAssyModelInfo;  //A2CHv3:MULTIPLE_MODEL

    UseCustumPatName : Boolean;
    UseScanFirst     : Boolean;

    //
    CamTEndWait     : Integer;
    CamCBCount      : Integer;  //2022-11-14 FOLDABLE_GIB_FLOW
    UseExLightFlow   : Boolean;       // 2022-08-24 EXLIGHT_FLOW(Aging after ExLight Off --> Power On --> Aging)
    {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
    UsePowerResetAfterEepromCBParaWrite : Boolean; //2021-12-29
    {$ENDIF}
    {$IFDEF HAS_DIO_PINBLOCK}
    UseCheckPinblock : Boolean; //2022-06-03
    {$ENDIF}
    UseVacuum       : Boolean;  //2019-06-24
    UseIonOnOff     : Boolean;  //2019-09-26 Ionizer On/Off

    //
    CamYCamPos 			: Double;                  //CamYCamPos  [CH1]=CamYCamPosCh1  [CH2]=CamYCamPosCh2      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    CamYLoadPos 		: Double;                  //CamYLoadPos [CH1]=CamYLoadPosCh1 [CH2]=CamYLoadPosCh2     //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    CamYCamPosCh1,   CamYCamPosCh2   : Double; //MULTIPLE_MODEL //For FrmModelInfo                         //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    CamYLoadPosCh1,  CamYLoadPosCh2  : Double; //MULTIPLE_MODEL //For FrmModelInfo                         //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    {$IFDEF HAS_MOTION_CAM_Z}
    CamZModelPos		: Double;                  //CamZModelPos [CH1]=CamZModelPosCh1 [CH2]=CamZModelPosCh2  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    CamZModelPosCh1, CamZModelPosCh2 : Double; //MULTIPLE_MODEL //For FrmModelInfo                         //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    {$ENDIF}
    {$IFDEF HAS_MOTION_TILTING}
    CamTFlatPos			: array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Double;  //F2CH  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    CamTUpPos 			: array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Double;  //F2CH  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    {$ENDIF}

    {$IFDEF HAS_ROBOT_CAM_Z}
    RobotModelInfo : TRobotModelInfo;                       //ROBOT [CH1]=RobotModelInfoCh1 [CH2]=RobotModelInfoCh2 //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    RobotModelInfoCh1, RobotModelInfoCh2 : TRobotModelInfo; //A2CHv3:MULTIPLE_MODEL //For FrmModelInfo              //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    {$ENDIF}

    EnablePwrMode          : Boolean; //TBD:USE_MODEL_PARAM_CSV?
    EnableProcMask         : Boolean; //TBD:USE_MODEL_PARAM_CSV?
    EnableFlashWriteCBData : Boolean; //TBD:USE_MODEL_PARAM_CSV?

    ParamCsvInfo        : TModelParamCsvInfoRec; //2022-07-15 MODEL_PARAM_ADD_INFO
    EepromCheckCBParam  : array of TEepromCheckRec;
    EepromWriteCBParam  : array of TEepromWriteRec;
    {$IF Defined(PANEL_AUTO)}
    EepromCheckProcMask : array of TEepromCheckRec;
    EepromWriteProcMask : array of TEepromWriteRec;
    EepromWriteAfterPUC : array of TEepromWriteRec;
    EepromGammaData     : array of TEepromDataRec;
    {$ELSEIF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
    FlashWriteAfterPUC  : array of TFlashWriteAfterPUCRec;
    FlashCBParaBlock    : array of TFlashCBParaBlockRec;
    FlashGammaData      : array of TFlashDataRec;
    {$ENDIF}
    EepromFlashAccess   : array of TEepromFlashAccessRec; //USE_MODEL_PARAM_CSV //2021-10-08 (to array)
    FlashCBDataAddr     : TFlashCBDataAddrRec;      //USE_MODEL_PARAM_CSV
    FlashAccessParam    : TFlashAccessParamRec;     //USE_MODEL_PARAM_CSV
    TConAccessParam     : TTConAccessParamRec;  //2022-07-15 UNIFORMITY_PUCONOFF
    TConParam           : TTConParamRec;        //2022-07-15 UNIFORMITY_PUCONOFF

    // DFS Option
    CombiModelInfoKey   : string; //2021-11-XX A2CHv4
    // Log Upload Option - PanelModelName
    LogUploadPanelModel : string; //2022-07-25 LOG_UPLOAD
  end;

  TModelInfoALDP = record  // DP200|DP201
    SPI_PULLUP          : Byte; // 0: disable, 1: enable
    SPI_SPEED           : Byte;	// 0: 400KHz, 1: 780KHz, 2: 1.5MHz, 3: 3MHz, 4: 6.25MHz, 5: 12.5MHz
    SPI_MODE            : Byte;	// 0: Library(0으로 고정), 1: GPIO
    SPI_LEVEL           : Byte;	// 0: 1.2V, 1:1.8V, 2: 3.3V(Default 0)
    I2C_LEVEL           : Byte;	// 0: 1.2V, 1:1.8V, 2: 3.3V(Default 0)
    //
    ALPDP_LINK_RATE     : Word;	// 5.56G(5560)
    ALPDP_H_FDP         : Word;	// 841
    ALPDP_H_SDP         : Word;	// 16
    ALPDP_H_PCNT        : Word;	// 876
    ALPDP_VB_SLEEP      : Word;	// 0
    ALPDP_VB_N2         : Word;	// 0
    ALPDP_VB_N3         : Word;	// 0
    ALPDP_VB_N4         : Word;	// 0
    ALPDP_VB_N5B        : Word;	// 122
    ALPDP_VB_N7         : Word;	// 0
    ALPDP_VB_N5A        : Word;	// 0
    ALPDP_MSA_MVID      : Word;	// 24
    ALPDP_MSA_NVID      : Word;	// 24
    ALPDP_MSA_HTOTAL    : Word;	// 16
    ALPDP_MSA_HSTART    : Word;	// 16
    ALPDP_MSA_HWIDTH    : Word;	// 16
    ALPDP_MSA_VTOTAL    : Word;	// 16
    ALPDP_MSA_VSTART    : Word;	// 16
    ALPDP_MSA_VHEIGHT   : Word;	// 16
    ALPDP_MSA_HSP_HSW   : Word;	// 16
    ALPDP_MSA_VSP_VSW   : Word;	// 16
    ALPDP_MSA_MISC0     : Word;	// 8
    ALPDP_MSA_MISC1     : Word;	// 8
    //
    ALPDP_SPECIAL_PANEL : Byte;	// 0
    ALPDP_ALPM          : Byte;	// 0: Disable, 1: Enable
    ALPDP_LINK_MODE     : Byte;	// 0: Manual, 1: Auto
    ALPDP_CHOP_SIZE     : Byte;
    ALPDP_CHOP_SECTION  : Byte;
    ALPDP_CHOP_ENABLE   : Byte;
    ALPDP_HPD_CHECK     : Byte;	// 0: HPD Check, 1: HPD Not Check(Default HPD Check)
    ALPDP_SCRAMBLE_SET  : Byte;	// 0: Disable, 1: Enable
    ALPDP_LANE_SETTING  : Byte;	// 1~8 Lane 설정
    ALPDP_SLAVE_ENABLE  : Byte;	// 0: Disable, 1: Enable
    //
    ALPDP_SWING_LEVEL       : Byte; //
    ALPDP_PRE_EMPHASIS_PRE  : Byte;	//
    ALPDP_PRE_EMPHASIS_POST : Byte;	//
    ALPDP_AUX_FREQ_SET      : Byte; //
    //
    DP141_IF_SET            : Byte; // 0~255
    DP141_CNT_SET           : Byte;	// 0~255
    EDID_SKIP               : Byte;	// 0:Disable(default), 1:Enable
    DEBUG_LEVEL             : Byte; // 0:None(default),1:Error, 2:Tace, 3:Warn, 4:Info
    eDP_SPEC_OPT            : Byte; // 0:Mode0, 1:Mode1, 2:Pola1, 3:Pola2 //2023-03-24 Tributo
    //
    Dummy : array [0..49] of Byte;  // Dummy[50]
  end;

  TModelInfoQSPI = packed record  // temporary to send ModelInfoDown to QSPI  //PWR_MAX_QSPI=2
    PWR_VOL      : array[0..2] of Word; // 1 = 10mV, 0~1200 = 0~12V
    PWR_VOL_HL   : array[0..2] of Word; // Voltage High Limit.  1 = 10mV, 0~1200 = 0~12V
    PWR_VOL_LL   : array[0..2] of Word; // Voltage Low Limit.   1 = 10mV, 0~1200 = 0~12V
    PWR_CUR_HL   : array[0..2] of Word; // CURRENT HIGH LIMIT.  1 = 1mA,  0~10000 = 0~10A
    PWR_CUR_LL   : array[0..2] of Word; // CURRENT LOW LIMIT.   1 = 1mA,  0~10000 = 0~10A
    PWR_SEQ      : array[0..3] of Word; // PWR_SEQ_MAX=3 (On1/On2/Off1/Off2)
    PWR_SEQ_TYPE : byte;
    Dummy        : byte;
    PWR_VOL_OFFS : array[0..1] of byte; //PWR_VDD_VEL=1
    Reverse      : array[0..15] of Byte;
  end;

  // for Pattern Group Download.
  // for save & display patter group.
  TPatternGroup = record
    GroupName : String[32];
    PatCount  : Integer;
    PatType		: array of Integer; //0:Pattern, 1:BMP
    VSync    	: array of Integer;
    LockTime 	: array of Integer;
  //Dimming 	: array of Integer; //TBD:PATTERN_PWM
    Option   	: array of Integer;
    PatName  	: array of String[50];
  end;

  TPatToolInfo = record
    ToolId      : Byte;
    Direction   : byte;
    Level       : Word;
    Sx,Sy,Ex,Ey : Word;
    Mx,My,R,G,B : Word;
  end;
  TPatternData = record
    PatNo     : Byte;
    PatType   : Byte;
    ToolCnt   : Byte;
    ToolInfo  : array of TPatToolInfo;
    CRC       : Word;
  end;

  TPath = record
    RootSW   		 	: string;
		// INI
    Ini 		     	: string;
    SysInfo     	: string;
    PatGrp      	: string;
		// DATA
    DATA         	: string;
    PG_FW				 	: string;
    PG_FPGA 		 	: string;
    PG_ALPDP      : string;
    PG_DLPU       : string; //2023-07-01
    SPI_FW  		 	: string;
    SPI_BOOT      : string;
		// LOG
    LOG     		 	: string;
    CBDATA   		 	: string; //compensation data from camera.
    CompBMP       : string; //compensation BMP from CamPC
    GMES     		 	: string; //GMES
    EAS     		 	: string; //EAS //2019-06-25
    MLOG     		 	: string; //Mlog
    SumCsv   		 	: string; //Summary
    DebugLOG      : string;
    MotionLOG     : string;
	  RobotLOG      : string; //A2CHv3:ROBOT
	  ApdrLog       : string; //2022-07-23
    ErrorLog      : string; //2022-12-07
    DioLog        : string; //2023-05-02

		// MODEL
    MODEL   		 	: string;
		// PATTERN
    Pattern 		 	: string;
    PATTERNGROUP	: string;
    BMP     		 	: string;
		// etc(TBD?)
    PANEL_img		 	: string;
    PANEL_hex		 	: string;
{$IFDEF DFS_HEX}
    QualityCode   : string;
    CombiCode     : string;
    CombiBackUp   : string;
    DfsDefect     : string; // LocalPC DFS Log Path for DFS DEFECT (default: C:\DEFECT)
    DfsHex        : string; // LocalPC DFS Log Path for DFS HEX (default: C:\DEFECT\HEX)
    DfsHexIndex   : string; // LocalPC DFS Log Path for DFS HEX (default: C:\DEFECT\HEX_INDEX)
    DfsSense      : string; // LocalPC DFS Log Path for DFS HEX (default: C:\DEFECT\SENSE)
    DfsSenseIndex : string; // LocalPC DFS Log Path for DFS HEX (default: C:\DEFECT\SENSE_INDEX)
{$ENDIF}
  end;

  TMotionSysInfo = record
    StartupHomeModelPos   : Boolean; // Motion Control Option.1: Whether to auto home search at program startup/initial)
    ServoAlarmHomeSearch  : Boolean; // Motion Control Option.2: Whether to auto home search at reset button pressed after light curtain detected)
    //
    YaxisUnit             : Double;  //F2CH|A2CHv2(AXM)
    YaxisPulse            : LongInt; //F2CH|A2CHv2(AXM)
    YaxisUnitPerPulse     : Double;
    YaxisStartStopSpeed   : Double;
    YaxisStartStopSpeedMax: Double;
    YaxisVelocity         : Double;
    YaxisVelocityMax      : Double;
    YaxisAccel            : Double;
    YaxisAccelMax         : Double;
    YaxisSoftLimitUse     : LongInt;
    YaxisSoftLimitMinus   : Double;
    YaxisSoftLimitPlus    : Double;
    YPulseOutMethod       : DWORD;   //2022-08-05
    YaxisServoHomeSpeed   : Double;
    YaxisServoHomeAcc   : Double;
    YaxisServoHomeDcc   : Double;

{$IFDEF HAS_MOTION_CAM_Z}
    ZaxisUnit             : Double;  //F2CH|A2CHv2(AXM)
    ZaxisPulse            : LongInt; //F2CH|A2CHv2(AXM)
    ZaxisUnitPerPulse     : Double;
    ZaxisStartStopSpeed   : Double;
    ZaxisStartStopSpeedMax: Double;
    ZaxisVelocity         : Double;
    ZaxisVelocityMax      : Double;
    ZaxisAccel            : Double;
    ZaxisAccelMax         : Double;
    ZaxisSoftLimitUse     : LongInt;
    ZaxisSoftLimitMinus   : Double;
    ZaxisSoftLimitPlus    : Double;
    ZPulseOutMethod       : DWORD;   //2022-08-05
{$ENDIF}
{$IFDEF HAS_MOTION_TILTING}
    SkipTaxisMotionCtl    : Boolean;
    TaxisUnit             : Double;  //F2CH|A2CHv2(AXM)
    TaxisPulse            : LongInt; //F2CH|A2CHv2(AXM)
    TaxisUnitPerPulse     : Double;
    TaxisStartStopSpeed   : Double;
    TaxisStartStopSpeedMax: Double;
    TaxisVelocity         : Double;
    TaxisVelocityMax      : Double;
    TaxisAccel            : Double;
    TaxisAccelMax         : Double;
    TaxisSoftLimitUse     : LongInt;
    TaxisSoftLimitMinus   : Double;
    TaxisSoftLimitPlus    : Double;
    TPulseOutMethod       : DWORD;   //2022-08-05
{$ENDIF}
    JogVelocity           : Double;  // JOG (Y/Z-Axis)
    JogVelocityMax        : Double;
    JogAccel              : Double;
    JogAccelMax           : Double;
  end;

  TMotionAlarmNo = record
    DISCONNECTED       : Integer;
    SIG_ALARM_ON       : Integer;
    INVALID_UNITPULSE  : Integer;
    NEED_HOME_SEARCH   : Integer;
    MODEL_POS_NG       : Integer;
  end;

{$IFDEF USE_ROBOT_TM}
  TRobotAlarmNo = record
    MODBUS_DISCONNECTED  : Integer;
    COMMAND_DISCONNECTED : Integer;
    FATAL_ERROR          : Integer;
    PROJECT_NOT_RUNNING  : Integer;
    PROJECT_EDITING      : Integer;
    PROJECT_PAUSE        : Integer;
    GET_NOT_CONTROL      : Integer;
    ESTOP                : Integer;
    CURR_COORD_NG        : Integer;
    NOT_AUTOMODE         : Integer;
    //
    CANNOT_MOVE          : Integer;
    //
    HOME_COORD_MISMATCH    : Integer;
    MODEL_COORD_MISMATCH   : Integer;
    STANDBY_COORD_MISMATCH : Integer;
  end;
{$ENDIF}

  TAlarmInfo = record
    AlarmNo     : Integer;
    AlarmClass  : Integer;
    sDioIN      : string;   //A2CHv3:ALARM (Integer -> String to support multiple DIO-IN#)
    bIsOn       : Boolean;
    AlarmName   : string;
    AlarmMsg    : string;   //Alarm Description
    AlarmMsg2   : string;   //2019-03-29    ImageFile   : string;   //2019-03-29    AlarmOnTime : TDateTime;//2019-04-02  end;

  TDpc2GpcNgCodes = record   //2019-01-15 CAM: DPC2GPC TEND NgCodes
  //DpcNgCode       : Integer   //index from TEND ErrorCode  e.g., 01 - XXXXXXXXXXX
    DefectCode      : string;   //e.g., PD06
    DefectName      : string;   //e.g., Calibraion Fail NG
    MesCodeSummary  : string;   //e.g., A0G-B01-GN9
    MesCodeRwk      : string;   //e.g., A0G-B01-----GN9---------------------------
    CamAlarmSuppMsg : string;   //2019-04-16 ALARM:CAM
  end;

  TMesNgCodes4POCB = record
    DefectCode      : string;   //e.g., PD06
    DefectName      : string;   //e.g., Calibraion Fail NG
    MesCodeSummary  : string;   //e.g., A0G-B01-GN9
    MesCodeRwk      : string;   //e.g., A0G-B01-----GN9---------------------------
  end;

                                         //Auto(Non-GIB)               //Auto(GIB)
  TPocbFlowSeqNo = record                // ScanFirst  //PowerOnFirst  // ScanFirst
    FLOW_SEQ_UNKNOWN         : Integer;  // 0(Header)    0(Header)
    //
    SCAN_BCR                 : Integer;  // 1            7             // 1
    MES_PCHK                 : Integer;  // 2            8             // 2
    INIT_POWER_ON            : Integer;  // 3            1             // 3
    CONFIRM_SKIP_POCB        : Integer;  // -            -             // 3* (ASSY+PM) //2022-06-XX
    CBPARA_BEFORE_WRITE      : Integer;  // 4            2             // 4
    INIT_POWER_RESET         : Integer;  // 5            3             // 5
    INIT_PATTERN_DISPLAY     : Integer;  // 6            4             // 6
    GAMMADATA_CHECK          : Integer;  // 7            5             // 7
    PROCMASK_BEFORE_CHECK    : Integer;  // 8            6             // 8
    PROCMASK_BEFORE_WRITE    : Integer;  // -(GIB)       -(GIB)        // 9
    PRESS_START              : Integer;  // 9            9             // 10
    STAGE_FWD                : Integer;  // 10           10            // 11
    START_CAMERA_ZONE        : Integer;  // 11           11            // 12
    CAMERA_PROC              : Integer;  // 12           12            // 13
    CBDATA_RECEIVE           : Integer;  // 13           13            // 14
    CBDATA_FILE_SAVE         : Integer;  // 14           14            // 15
    BMP_DOWNLOAD             : Integer;  // 15           15            // 16
    FLASH_CBDATA_WRITE       : Integer;  //
    CBPARA_AFTERPUC_WRITE    : Integer;  //2022-09-01
    PROCMASK_AFTER_WRITE     : Integer;  // 16           16            // 18
    CBPARA_AFTER_WRITE       : Integer;  // 17           17            // 19
    STAGE_BWD                : Integer;  // 18           18            // 20
    MES_EICR                 : Integer;  // 19           19            // 21
    POWER_OFF                : Integer;  // 20           20            // 22
    //
    FLOW_SEQ_MAX             : Integer;  // 20           20            // 22
  end;

  TModelCrc = record
    ModelMcf      : string; //GPC
    ModelParamCsv : string; //GPC
    CB_Algorithm  : string; //DPC
    Cam_Parameter : string; //DPC
  end;

  TActualResolution = record  //A2CHv3:MULTIPLE_MODEL? (PG DOWN MODELINFO)
    nH : Word;
    nV : Word;
  end;

  TCommon = class(TObject)
    m_hMainFrm 			: THandle;
    Path 						: TPath;
    SystemInfo   		: TSystemInfo;
    TempSystemInfo  : TSystemInfo;  //2019-02-20 DFS_FTP
    MotionInfo      : TMotionSysInfo;
{$IFDEF HAS_ROBOT_CAM_Z}
    RobotSysInfo    : TRobotSysInfo;
{$ENDIF}
    EdModelInfo,  TestModelInfo  : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of TMODELINFO;  // A2CHv3:MULTIPLE_MODEL
    EdModelInfo2, TestModelInfo2 : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of TModelInfo2; // A2CHv3:MULTIPLE_MODEL
    EdModelInfoALDP, TestModelInfoALDP : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of TModelInfoALDP;
    m_csvLine, m_csvFile : Integer;
    m_EERepeat 			: Integer;
    m_bMesOnline    : Boolean;       //2023-09-20 //#(not m_bMesPMMode)
    m_bPmModeProcMaskSkip : Boolean; //2023-09-20
    m_sUserId 			: string;
{$IFDEF SITE_LENSVN}
    m_sUserPwd      : string; //TBD:LENS:MES?
{$ENDIF}
    m_nCurPosYAxis 	: array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Double;
{$IFDEF HAS_MOTION_CAM_Z}
    m_nCurPosZAxis 	: array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Double;
{$ENDIF}
{$IFDEF HAS_ROBOT_CAM_Z}
    m_nCurRobotCoord_X  : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Single;
    m_nCurRobotCoord_Y  : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Single;
    m_nCurRobotCoord_Z  : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Single;
    m_nCurRobotCoord_Rx : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Single;
    m_nCurRobotCoord_Ry : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Single;
    m_nCurRobotCoord_Rz : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Single;
    m_nCurRobotSpeed    : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of UInt16;
{$ENDIF}
    m_bStopWork 		: boolean;
    PatGrpInfo   		: array [DefPocb.JIG_A..DefPocb.JIG_MAX] of TPatternGroup; // A2CHv3:MULTIPLE_MODEL
    _lcid     			: LCID;
    PatternData     : array[DefPocb.PG_1..DefPocb.PG_MAX] of TPATTERNDATA;
    dis_pattern_dat : array[DefPocb.PG_1..DefPocb.PG_MAX] of TPATTERNDATA;
    Conn_Chk_Cnt    : array[DefPocb.PG_1..DefPocb.PG_MAX] of Integer;
    download_pattern_cnt : array[DefPocb.PG_1..DefPocb.PG_MAX] of Word;
    errorDisplayCount, connCheckCount : Integer;
    // for Alarm
    m_bKeyTeachMode : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of Boolean; //A2CHv3:DIO
    m_bAlarmOn      : Boolean;
    m_bSafetyAlarmOn: Boolean;      //2019-04-17 ALARM:GUI
    AlarmList       : array[0..DefPocb.MAX_ALARM_NO] of TAlarmInfo;
    m_Dpc2GpcNgCodes   : array[0..DefCam.DPC2GPC_NGCODE_MAX] of TDpc2GpcNgCodes; //2019-01-15 CAM: DPC2GPC TEND NgCodes
    m_NgCodesList4Pocb : array[0..DefGmes.POCB_MES_CODE_MAX] of TMesNgCodes4POCB;
    m_ModelCrc         : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of TModelCrc;  //A2CHv3:MULTIPLE_MODEL

    {$IFDEF DFS_HEX}
    CombiCodeData   : TCombiCodeData;
    DfsConfInfo     : TDfsConfInfo;
    TempDfsConfInfo : TDfsConfInfo;
    {$ENDIF}
  private
    m_dtPreLogTm  : Extended;
    m_bStartGapTm : Boolean;
    m_slSerialNo  : TStringList;

    procedure SetResolution(nCh: Integer; nH,nV: Word);  //TBD:A2CHv3:MULTIPLE_MODEL? (PG DOWN MODEL)
    procedure LoadMesCode;
    procedure SaveSerialMatch;
    procedure LoadSerialMatch;

  public
    FpgaData 			: array[DefPocb.JIG_A..DefPocb.JIG_MAX] of TFpgaData;
    m_bNeedInitial: Boolean;
    loadAllPat    : TDongaPat;
    actual_resolution : array [DefPocb.CH_1..DefPocb.CH_MAX] of TActualResolution;  //TBD:A2CHv3:MULTIPLE_MODEL? (PG DOWN MODEL)
    m_sBinFullName : array [DefPocb.CH_1..DefPocb.CH_MAX] of string; //2019-01-23 DFS_FTP
    m_sBinFileName : array [DefPocb.CH_1..DefPocb.CH_MAX] of string; //2019-01-23 DFS_FTP
    m_sCBDataFullName : array [DefPocb.CH_1..DefPocb.CH_MAX] of string;      //USE_FLASH_WRITE
    m_bDfsUploadFileReady : array [DefPocb.CH_1..DefPocb.CH_MAX] of Boolean; //USE_FLASH_WRITE

{$IFDEF USE_FPC_LIMIT}
    m_nFpcUsageValue : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of Integer; //2019-04-11 FPC Usage Limit
{$ENDIF}
    m_sExeVerNameSummary : string; //2019-05-02 SUMMARY (No Space)
    m_sExeVerNameLog     : string; //2022-07-30
    PocbFlowSeqStr : array [0..DefPocb.POCB_SEQ_MAX] of string;
  //FlowSeqNo     : array [DefPocb.CH_1..DefPocb.CH_MAX] of TPocbFlowSeqNo; //A2CHv3:MULTIPLE_MODEL
    MesData       : array [DefPocb.CH_1..DefPocb.CH_MAX] of TGmesDataPack;  //2019-06-19 jhhwang (Move from GMesCom to Common for DFS without GMES
		//
    m_nDebugLogLevelActive : array[DEBUG_LOG_DEVTYPE_PG..DEBUG_LOG_DEVTYPE_MAX] of Integer;  // init(SystemConfig.ini) + change by SetDebugLogLevel() from script //TBD:DEBUG_LOG?

    constructor Create;
    destructor Destroy; override;
		//
    procedure LoadBaseData;
    procedure InitPath;
    procedure SetCodeLog;
    procedure InitSystemInfo;
    procedure ReadSystemInfo;
    procedure LoadFpgaTiming;
    function  LoadModelInfo(nCh: Integer; fName: String): Boolean; //A2CHv3:MULTIPLE_MODEL
{$IFDEF USE_FPC_LIMIT}
    procedure LoadFpcUsageValue; //2019-04-11 FPC Usage Limit
    procedure SaveFpcUsageValue(nJig: Integer); //2019-04-11 FPC Usage Limit
{$ENDIF}
		//
    procedure SaveSystemInfo;
    function GetStrMotionID2ChAxis(nModuleID: Integer): string;
    procedure GetMotionParam(nMotionID: Integer; var MotionParam: RMotionParam);
		// Alarm
    procedure MakeAlarmList;
    procedure SetAlarmInfo(alarmNo: Integer; nDioIN: Integer; alarmClass: Integer; alarmName: string; alarmMsg: string = ''; alarmMsg2: string = ''; sImageFile: string = ''); overload;
    procedure SetAlarmInfo(alarmNo: Integer; sDioIN: string; alarmClass: Integer; alarmName: string; alarmMsg: string = ''; alarmMsg2: string = ''; sImageFile: string = ''); overload;
    function SetAlarmOnOff(alarmNo: Integer; bIsOn: Boolean): Boolean;
    function IsAlarmOn(alarmNo: Integer): Boolean;  //2019-04-26
    procedure GetMotionAlarmNo(nMotionID: Integer; var MotionAlarmNo: TMotionAlarmNo);

    function LoadPatGroup(SelPatGroupName : string) : TPatternGroup;
    procedure MLog(nCh: Integer; const Msg: String);
    procedure ChangeDebugLogLevel(nDevType: Integer; nLogLevel: Integer);  //2020-09-16 DEBUG_LOG
    procedure DebugLog(nCh, nDevType, nMsgType: Integer; sRTX, sIP: string; buff: TIdBytes); //2020-09-16 DEBUG_LOG
    procedure MotionLog(nCh: Integer; sMsg : string);  //TBD:A2CHv3:MOTION?
    procedure RobotLog(nCh: Integer; sMsg : string);   //TBD:A2CHv3:ROBOT?
    {$IFDEF SITE_LENSVN}
    procedure MesLog(sMsg : string);
    {$ENDIF}
    procedure MakeDpc2GpcNgCodes;  //2019-01-15 CAM: DPC2GPC TEND NgCodes
    procedure Make_Bmp_List;
    procedure SavePatGroup(sPatGroup : string; SavePatGrp : TPatternGroup);
    function GetExeVerNameSummary: String; //2019-05-02 SUMMARY
    function GetExeVerNameLog : String;
{$IFDEF REF_ISPD}
    function GetPatGroup(fModel : string) : string;
{$ENDIF}
    function BmpGetSectionList : TStringList;
    function BmpGetKeyValueList(section : String) : TStringList;
    procedure Delay(msec: dword);
    procedure SleepMicro(nSec : Int64);
    procedure DebugMessage(const str: String);
    function  GetFilePath(FName: String; Path: Integer): String;
{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
    function GetPidFromBcr(sBcr: String): String;
{$ENDIF}
  //procedure SaveModelInfo(fName: String);  //TBD:MERGE? FoldPOCB(O) AutoPOCB(X)
    procedure DelateBmpRawFile;
    function CheckMakeDir(sPath: string; bForceDirectories: Boolean = False): Boolean; //2022-07-25 (add bForceDirectories)
    function IsfStrToTime(sTime: string): Integer;
    function SetTimeToStr(nTime: Int64): string;
    procedure MakePatternData(nCh: Integer; nIdx : Integer;makePatGrp : TPatternGroup; var dCheckSum: dword; var nTotalSize: Integer; var Data: TArray<System.Byte>);  //A2CHv3:MULTIPLE_MODEL
    function crc16(Str: AnsiString; len: Integer) : Word; overload;
    function crc16(pData : PAnsiChar ; len :integer): word; overload;
    function crc16(sFileName : string): word; overload;
    function GetModelMcfCrc(nCh: Integer): string;  //2022-09-15 (GetModelCrc -> GetModelMcfCrc)
    function GetModelParamCsvCrc(nCh: Integer): string;  //2022-09-15
    function Decrypt(const S: String; Key: Word): String;
    function Encrypt(const S: String; Key: Word): String;
    function ValueToHex(const S: String): String;
    function HexToValue(const S: String): String;
    procedure LoadCheckSumNData(sFileName : string; var dCheckSum : dword;var TotalSize : Integer; var Data : TArray<System.Byte> );
    procedure CalcCheckSum(p: pointer; byteCount:dword; var SumValue:dword);
    procedure MakeSummaryCsvLog(nCh: Integer; sHeader, sData: string);  //A2CHv3:MULTIPLE_MODEL
    procedure MakeApdrCsvLog(nCh: Integer; sHeader, sData: string);  //2022-07-30
    procedure MakeErrorLog(sHeader, sData: string);  //2022-12-06
    procedure MakeDioLog(sHeader, sData: string);  //2023-05-02
    procedure MakeFile(sFileName, sHeader, sData : string; nNo : Integer = 0; bForceDirectories: Boolean = False); //2022-07-25 (add bForceDirectories)
    function  DecToOct(nGetVal : Integer) : string;
    procedure TaskBar(bHide: Boolean);
    procedure CopyDirectoryAll(pSourceDir, pDestinationDir: string; pOverWrite: Boolean);
		{$IFDEF PANEL_AUTO}
    function GetTCon2DevRegAddr(nTConAddr: Integer; var nDevAddr, nRegAddr: Integer): Boolean; //2022-07-15 UNIFORMITY_PUCONOFF
		{$ENDIF}
    function  GetDrawPosPG(nCh: Integer; sPos: string): word;  //TBD:A2CHv3:MULTIPLE_MODEL?
    procedure makeRawData(bmpB : TBitmap; var RawData : TIdBytes);
    procedure SaveRawFile(fName: String; RawData: TIdBytes; nHeight, nWidth : Integer);
  //function GetLocalIpList(nIdx : Integer = DefPocb.IP_LOCAL_ALL; sSearchIp : string = '') : string;  //TBD:GMES?
	//procedure SaveLocalIpToSys(nIdx: Integer);   //TBD:GMES?
    procedure ThreadTask(task: TProc);
    procedure SyncThreadTask(task: TProc);

    function  CheckSerialMatch(sSerialNumber : string) : Boolean;
    procedure AddSerialNoMatch(sSerialNumber : string);

    procedure DelateFilesWithWildChar(sPath: string; sFileName: string);  //2019-02-11
{$IFDEF DFS_HEX}
    procedure FileCompress (sFullFileName: string; bDeleteOrgFile: Boolean);
    procedure FileDecompress (sFullZipName: string);
    procedure LoadCombiFile;
    procedure CheckAuthority(sID, sPassword: string);
{$ENDIF}
    procedure CodeSiteSend(msg: string = '');
{$IFDEF REF_ISPD_DFS}
    procedure CompareSetUpInfo;
    procedure CLog(const Msg : String); //log for config changes
{$ENDIF}
    function  GetMesCode4Pocb(nIdx : Integer): TMesNgCodes4POCB; overload;
    function  GetMesCode4Pocb(sCode : string) : TMesNgCodes4POCB; overload;
    procedure SetEdModel2TestModel;
{$IFDEF HAS_ROBOT_CAM_Z}
    procedure GetRobotAlarmNo(nJig: Integer; var RobotAlarmNo: TRobotAlarmNo); //A2CHv3:ROBOT
    function GetRobotCoordAttrStr(nCoordAttr: enumRobotCoordAttr): string;     //A2CHv3:ROBOT
    function GetRobotCoordDiffRxRyRz(nVal1, nVal2: Single): Single;   //TBD:A2CHv3:ROBOT? (Coord Diff)
{$ENDIF}
    function LoadModelParamCsv(nCh: Integer; fName: String; var ModelInfo2Buf: TModelInfo2): Boolean;  //USE_MODEL_PARAM_CSV
    function GetDataModelParamCsv(nCh: Integer; fn: string; var ModelInfo2Buf: TModelInfo2): Boolean;  //USE_MODEL_PARAM_CSV
    //
{$IFDEF SUPPORT_1CG2PANEL}
    function GetAssyModelInfo(sModelName: string; var AssyModelInfo: TAssyModelInfo): Boolean;  //TBD:REMOTE_UPDATE:MoveFromModelSelectToCommon?
    function CheckAssyPocbModelSelect(sModelNameCh1, sModelNameCh2: string): Boolean; //TBD:REMOTE_UPDATE:MoveFromModelSelectToCommon?
{$ENDIF}
    //
    procedure SendModelData(nCh: Integer; nPgSpi: integer=2); //nPgSPi(0:PG,1:SPI,2:ALL)
    //
    function FindCreateForm(sClassName: string): string; //REMOTE_UPDATE
  end;

var
  Common : TCommon;

 {$IFDEF WIN32}
  procedure ShowCodeSetDlg(nSite: Integer); cdecl; external 'IntegrationCode.dll' name 'ShowCodeSetDlg';  //delayed
  function  ShowMainDlg(nSite: Integer): PAnsiChar;cdecl; external 'IntegrationCode.dll' name 'ShowMainDlg';
  procedure CloseResultDlg(); cdecl; external 'IntegrationCode.dll'  name 'CloseResultDlg';
 {$ENDIF}

implementation

uses UdpServerPocb;

{ TCommon }

//******************************************************************************
// procedure/function: Create/Destroy/init/..
//******************************************************************************

constructor TCommon.Create;
var
  nJig, nCh : Integer;
begin
  _lcid := GetUserDefaultLCID;
  loadAllPat    := TDongaPat.Create(nil);
  LoadBaseData;
  //
  m_csvLine :=	0;
  m_csvFile :=	0;
  m_bStopWork := False;
  m_dtPreLogTm := now;
  m_bStartGapTm := False;
  m_bNeedInitial := False;  //TBD?
  m_sExeVerNameSummary := Common.GetExeVerNameSummary;
  m_sExeVerNameLog     := {DefPocb.PROGRAM_NAME + ' - ' +} Common.GetExeVerNameLog;
  m_slSerialNo := TStringList.Create;
  m_slSerialNo.Clear;

  LoadMesCode;

  //LoadSerialMatch;  //TBD:MERGE:SERIAL_MATCH?
  //
  for nJig := DefPocb.JIG_A to DefPocb.JIG_MAX do begin
    m_nCurPosYAxis[nJig] := 0;
    {$IFDEF HAS_MOTION_CAM_Z}
    m_nCurPosZAxis[nJig] := 0;
    {$ENDIF}
    {$IFDEF HAS_MOTION_TILTING}
    m_nCurPosTAxis[nJig] := 0;
    {$ENDIF}
    {$IFDEF HAS_ROBOT_CAM_Z}
    m_nCurRobotCoord_X[nJig]  := 0; //A2CHv3:ROBOT
    m_nCurRobotCoord_Y[nJig]  := 0;
    m_nCurRobotCoord_Z[nJig]  := 0;
    m_nCurRobotCoord_Rx[nJig] := 0;
    m_nCurRobotCoord_Ry[nJig] := 0;
    m_nCurRobotCoord_Rz[nJig] := 0;
    m_nCurRobotSpeed[nJig]    := 0;
    {$ENDIF}
  end;
	//
{$IFDEF DFS_HEX}
  LoadCombiFile;  //2019-04-09 TBD:COMBI? (initialize Combi data using the previous downloaded Combi Data?)
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    m_sBinFileName[nCh] := '';
	  m_sBinFullName[nCh] := '';
  end;
{$ENDIF}
end;

destructor TCommon.Destroy;
begin
  m_slSerialNo.Clear;
  m_slSerialNo.Free;
  m_bStopWork := True;
  //TBS? Delay(100);
  Sleep(200);
  loadAllPat.Free;
  loadAllPat := nil;
  inherited;
end;

function TCommon.FindCreateForm(sClassName: string): string;
var
  sRet : string;
  i    : Integer;
begin
  sRet := '';
  for i := 0 to Pred(Screen.FormCount) do begin
    if 0 <> CompareText(Screen.Forms[i].ClassName,sClassName) then Continue;
    sRet := Screen.Forms[i].ClassName;
  end;
  Result := sRet;
end;

//******************************************************************************
// procedure/function:
//    - TCommon.LoadBaseData
//    - TCommon.InitPath
//    - TCommon.SetCodeLog
//    - TCommon.InitSystemInfo
//    - TCommon.ReadSystemInfo
//    - TCommon.LoadFpgaTiming
//    - TCommon.LoadModelInfo(fName: String): Boolean
//******************************************************************************
//    - TCommon.SaveSystemInfo

//******************************************************************************
// procedure/function: SystemInfo
//******************************************************************************
//    - TCommon.InitSystemInfo
//    - TCommon.ReadSystemInfo
//    - TCommon.SaveSystemInfo

//******************************************************************************
// procedure/function: ModelInfo
//******************************************************************************
//    - TCommon.LoadModelInfo(fName: String): Boolean
//    - TCommon.MakeModelData(model_name: String): AnsiString
//    - TCommon.SaveModelInfo(fName: String)

//******************************************************************************
// procedure/function: Pattern
//******************************************************************************
//    - TCommon.SavePatGroup(sPatGroup : string; SavePatGrp : TPatternGroup)
//    - TCommon.LoadPatGroup(SelPatGroupName : string) : TPatternGroup
//    - TCommon.MakePatternData(nIdx : Integer;makePatGrp : TPatternGroup; var dCheckSum: dword; var nTotalSize: Integer; var Data: TArray<System.Byte>)
//    - TCommon.makeRawData(bmpB: TBitmap; var RawData: TIdBytes)
//    - TCommon.Make_Bmp_List;
//    - TCommon.GetDrawPosPG(sPos: string): word
//    - TCommon.SaveRawFile(fName: String; RawData: TIdBytes; nHeight, nWidth: Integer)
//
//    - TCommon.BmpGetKeyValueList(section: String): TStringList
//    - TCommon.BmpGetSectionList: TStringList;
//    - TCommon.CalcCheckSum(p: pointer; byteCount: dword; var SumValue: dword)
//    - TCommon.CheckDir(sPath: string): Boolean
//    - TCommon.CopyDirectoryAll(pSourceDir, pDestinationDir: string; pOverWrite: Boolean)
//    - TCommon.crc16(pData: PAnsiChar; len: integer): word
//    - TCommon.crc16(Str:  AnsiString; len: Integer): Word
//    - TCommon.DebugMessage(const str: String)
//    - TCommon.Decrypt(const S: String; Key: Word): String
//    - TCommon.DecToOct(nGetVal: Integer): string
//    - TCommon.DelateBmpRawFile
//    - TCommon.Encrypt(const S: String; Key: Word): String
//    - TCommon.GetFilePath(FName: String; Path: Integer): String
//    - TCommon.GetExeVerNameLog: String
//    - TCommon.HexToValue(const S: String): String
//    - TCommon.IsfStrToTime(sTime: string): Integer
//    - TCommon.SetTimeToStr(nTime: Int64): string
//    - TCommon.SleepMicro(nSec: Int64)
//    - TCommon.TaskBar(bHide: Boolean)
//    - TCommon.LoadCheckSumNData(sFileName: string; var dCheckSum: dword; var TotalSize: Integer; var Data: TArray<System.Byte>)
//    - TCommon.MakeSummaryCsvLog(sHeader, sData: string)
//    - TCommon.SetResolution(nH, nV: Word)
//    - TCommon.ValueToHex(const S: String): String;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.LoadBaseData
//    Called-by: constructor TCommon.Create;
//
procedure TCommon.LoadBaseData;
var
  nCh : Integer;
begin
	//
  InitPath;
  SetCodeLog;
	//
  ReadSystemInfo;
  LoadFpgaTiming;
{$IFDEF REF_ISPD_A}
  if not CheckModelFile(SystemInfo.TestModel) then begin
    MessageDlg(#13#10 + '[' + SystemInfo.TestModel + ']' + #13#10 +
               'Model file does not exist. Please Check Model File.' + #13#10 +
               'Tập tin mô hình không tồn tại. Vui lòng kiểm tra tập tin mô hình.'  , mtError, [mbOk], 0);
    Exit;
  end;
{$ENDIF}
  //LoadMesCode;

  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do    //A2CHv3:MULTIPLE_MODEL
    LoadModelInfo(nCh,SystemInfo.TestModel[nCh]);
  // load pattern Group file.
  // set path.
  loadAllPat.Visible := False;
  loadAllPat.DongaUseSpc  := False;
  loadAllPat.DongaPatPath := Path.Pattern;
  loadAllPat.DongaBmpPath := Path.BMP;
  loadAllPat.LoadAllPatFile;
  //
{$IFDEF USE_FPC_LIMIT}
  if SystemInfo.FpcUsageLimitUse then LoadFpcUsageValue;  //2019-04-11 FPC Usage Limit
{$ENDIF}
end;

procedure TCommon.InitPath;
begin
  Path.RootSW		    	:= ExtractFilePath(Application.ExeName);
  // INI
  Path.INI    		    := Path.RootSW + 'INI\';
  Path.SysInfo        := Path.INI + 'SysTemConfig.ini';
	// DATA
  PATH.DATA 					:= Path.RootSW + 'DATA\';
  Path.PG_FW       		:= Path.DATA + 'PG_FW\';
  Path.PG_FPGA     		:= Path.DATA + 'PG_FPGA\';
  Path.PG_ALPDP    		:= Path.DATA + 'PG_ALPDP\';
  Path.PG_DLPU    		:= Path.DATA + 'PG_DLPU\'; //2023-07-01
  Path.SPI_FW      		:= Path.DATA + 'SPI_FW\';
  Path.SPI_BOOT   		:= Path.DATA + 'SPI_BOOT\';
	// LOG
  Path.LOG        		:= Path.RootSW + 'LOG\';
  Path.CBDATA         := Path.LOG + 'CBDATA\';
  Path.CompBMP        := Path.LOG + 'CompBMP\';
  Path.GMES       		:= Path.LOG + 'MesLog\';
  Path.EAS        		:= Path.LOG + 'EasLog\';
  Path.MLOG           := Path.LOG + 'MLog\';
  Path.SumCsv         := Path.LOG + 'SummaryLog\';
  Path.DebugLOG       := Path.LOG + 'DebugLog\';
  Path.MotionLOG      := Path.LOG + 'MotionLog\';
  Path.RobotLOG       := Path.LOG + 'RobotLog\';
  Path.ApdrLog        := Path.LOG + 'ApdrLog\';
  Path.ErrorLog       := Path.LOG + 'ErrorLog\'; //2022-12-07
  Path.DioLog         := Path.LOG + 'DioLog\';   //2023-05-02
	// MODEL
  Path.MODEL      	  := Path.RootSW + 'MODEL\';
	// PATTERN
  Path.PATTERN        := Path.RootSW + 'pattern\';
  Path.PATTERNGROUP   := Path.PATTERN + 'group\';
  Path.BMP            := Path.PATTERN + 'bmp\';
{$IFDEF  REF_ISPD_DFS}
  Path.CLOG           := Path.LOG + 'CLog\';
{$ENDIF}
{$IFDEF DFS_HEX}
  Path.QualityCode    := Path.RootSW  + 'Quality Code\';
  Path.CombiCode      := Path.QualityCode + 'Combi Code\';
  Path.CombiBackUp    := Path.QualityCode + 'Backup\';
  Path.DfsDefect      := 'C:\DEFECT\';
  Path.DfsHex         := Path.DfsDefect  + 'HEX\';
  Path.DfsHexIndex    := Path.DfsDefect  + 'HEX_INDEX\';
  Path.DfsSense       := Path.DfsDefect  + 'SENSE\';
  Path.DfsSenseIndex  := Path.DfsDefect  + 'SENSE_INDEX\';
{$ENDIF}
	//
  CheckMakeDir(Path.INI);
  CheckMakeDir(Path.DATA);
  CheckMakeDir(Path.PG_FW);
  CheckMakeDir(Path.PG_FPGA);
  CheckMakeDir(Path.PG_ALPDP);
  CheckMakeDir(Path.PG_DLPU); //2023-07-01
  CheckMakeDir(Path.SPI_FW);
  CheckMakeDir(Path.SPI_BOOT);
  CheckMakeDir(Path.LOG);
  CheckMakeDir(Path.CBDATA);
  CheckMakeDir(Path.CompBMP);
  CheckMakeDir(Path.GMES);
  CheckMakeDir(Path.EAS);
  CheckMakeDir(Path.MLOG);
  CheckMakeDir(Path.SumCsv);
  CheckMakeDir(Path.DebugLOG);
  CheckMakeDir(Path.MotionLOG);
  CheckMakeDir(Path.RobotLOG);
  CheckMakeDir(Path.ApdrLog);  //2022-07-30
  CheckMakeDir(Path.ErrorLog); //2022-12-07
  CheckMakeDir(Path.DioLog);   //2023-05-02
  CheckMakeDir(Path.MODEL);
  CheckMakeDir(Path.PATTERN);
  CheckMakeDir(Path.PATTERNGROUP);
  CheckMakeDir(Path.BMP);
{$IFDEF REF_ISPD_DFS}
  CheckMakeDir(Path.CLOG);
{$ENDIF}
{$IFDEF DFS_HEX}
  CheckMakeDir(Path.QualityCode);
  CheckMakeDir(Path.CombiCode);
  CheckMakeDir(Path.CombiBackUp);
  CheckMakeDir(Path.DfsDefect);
  CheckMakeDir(Path.DfsHex);
  CheckMakeDir(Path.DfsHexIndex);
//CheckMakeDir(Path.DfsSense);
//CheckMakeDir(Path.DfsSenseIndex);
{$ENDIF}
end;

procedure TCommon.InitSystemInfo;
var
  i : Integer;
begin
  with SystemInfo do begin
    Password       := 'LCD';
    for i := DefPocb.JIG_A to DefPocb.JIG_MAX do begin
      TestModel[i]  := '';
      IPAddr_PG[i]  := IPADDR_PG_PREFIX  + Format('%d',[IPADDR_PG_BASE+i]);
      {$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2) or Defined(POCB_A2CHv3)}
      IPAddr_SPI[i] := IPADDR_DJ023_PREFIX + Format('%d',[IPADDR_DJ023_BASE+i]);
      {$ELSE}
      IPAddr_SPI[i] := IPADDR_QSPI_PREFIX + Format('%d',[IPADDR_QSPI_BASE+i]);
      {$ENDIF}
      Com_RCB[i]   := 0;
    end;
    for i := 0 to DefIonizer.ION_MAX do begin
      Com_ION[i]   := 0;
    end;
    Com_HandBCR := 0;
    Com_ExLight := 0;  //2019-04-16 ExLight
    Com_EFU     := 0;  //2019-05-02 EFU
    PGMemorySize := 512;//128;
  end;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.ReadSystemInfo
//    Called-by: procedure TCommon.LoadBaseData;
//
procedure TCommon.ReadSystemInfo;
var
  nIndex, i : Integer;
  fSys 	: TIniFile;
  sTemp : string;
begin
  if not FileExists(Path.SysInfo) then begin
    InitSystemInfo; 	// create SystemInfo with Default
    SaveSystemInfo;
  end
  else begin
    fSys := TIniFile.Create(Path.SysInfo);
{$IFDEF REF_ISPD_A}
    // For vietnamese, create new UFT-8 file if INI file is not UTF-8
    try
      fsys := TMemIniFile.Create(Path.SysInfo, TEncoding.UTF8);
    except
      RenameFile(Path.SysInfo, Path.Ini + 'Temp.ini');
      SaveToUTF_8(Path.Ini + 'Temp.ini', Path.SysInfo);
      DeleteFile(Path.Ini + 'Temp.ini');
      fsys := TMemIniFile.Create(Path.SysInfo, TEncoding.UTF8);
    end;
{$ENDIF}
    try
			// [SYSTEMDATA] ------------------------------
      SystemInfo.Password             := Decrypt(fSys.ReadString('SYSTEMDATA', 'PASSWORD', Encrypt('LCD', 17307)), 17307);
      SystemInfo.Password_PM          := Decrypt(fSys.ReadString('SYSTEMDATA', 'PASSWORD_PM', Encrypt('', 17307)), 17307);
      SystemInfo.EQPId             		:= fSys.ReadString ('SYSTEMDATA', 'StationID', ''); //EQPId=Station
      SystemInfo.TestModel[0]         := fSys.ReadString ('SYSTEMDATA', 'TESTING_MODEL_CH1', ''); //A2CHv3:MULTIPLE_MODEL
      SystemInfo.TestModel[1]         := fSys.ReadString ('SYSTEMDATA', 'TESTING_MODEL_CH2', ''); //A2CHv3:MULTIPLE_MODEL
    //SystemInfo.PatGrp            		:= //TBD?
			// PG
    //SystemInfo.ChCountUsed          := //TBD?
      SystemInfo.PGMemorySize         := fSys.ReadInteger('SYSTEMDATA', 'PG_MEMORY_SIZE',512);

      // PG/SPI Board Type
      SystemInfo.PGSPI_MAIN := fSys.ReadInteger('SYSTEMDATA', 'PGSPI_MAIN', 0);  // 0:PG,1:QSPI
      {$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2) or Defined(POCB_A2CHv3)}
      SystemInfo.PG_TYPE    := fSys.ReadInteger('SYSTEMDATA', 'PG_TYPE',    DefPG.PG_TYPE_DP489);       // 0:NONE,1:DP489,2:DP201,3:DP200
      SystemInfo.SPI_TYPE   := fSys.ReadInteger('SYSTEMDATA', 'SPI_TYPE',   DefPG.SPI_TYPE_DJ023_SPI);  // 0:NONE,1:DJ023SPI,2:DJ201QSPI,3:DJ021QSPI
      {$ELSE}
      SystemInfo.PG_TYPE    := fSys.ReadInteger('SYSTEMDATA', 'PG_TYPE',    DefPG.PG_TYPE_DP201);       // 0:NONE,1:DP489,2:DP201,3:DP200
      SystemInfo.SPI_TYPE   := fSys.ReadInteger('SYSTEMDATA', 'SPI_TYPE',   DefPG.SPI_TYPE_DJ201_QSPI); // 0:NONE,1:DJ023SPI,2:DJ201QSPI,3:DJ021QSPI
      {$ENDIF}
      // PG/SPI FW
      case SystemInfo.PG_TYPE of
        DefPG.PG_TYPE_DP489: sTemp := 'DP489';
        DefPG.PG_TYPE_DP200: sTemp := 'DP200';
        DefPG.PG_TYPE_DP201: sTemp := 'DP201';
        else                 sTemp := '';
      end;
      SystemInfo.PGFWName  := fSys.ReadString ('SYSTEMDATA', 'PG_FW_Name', sTemp);
      case SystemInfo.SPI_TYPE of
        DefPG.SPI_TYPE_DJ023_SPI : sTemp := 'DJ023';
        DefPG.SPI_TYPE_DJ021_QSPI: sTemp := 'DJ021';
        DefPG.SPI_TYPE_DJ201_QSPI: sTemp := 'DJ201';
        else                       sTemp := '';
      end;
      SystemInfo.SPIFWName := fSys.ReadString('SYSTEMDATA', 'SPI_FW_Name', sTemp);

      for i := DefPocb.PG_1 to DefPocb.PG_MAX do begin
        {$IFDEF SIMULATOR_PG}
        SystemInfo.IPAddr_PG[i] := Format('%s.%d',[IPADDR_PG_PREFIX, IPADDR_PG_BASE+i]);
        {$ELSE}
        SystemInfo.IPAddr_PG[i] := fSys.ReadString('SYSTEMDATA',  'IP_ADDR_PG'+IntToStr(i+1),  Format('%s.%d',[IPADDR_PG_PREFIX, IPADDR_PG_BASE+i]));
        if trim(SystemInfo.IPAddr_PG[i])  = '' then SystemInfo.IPAddr_PG[i]  := Format('%s.%d',[IPADDR_PG_PREFIX,  IPADDR_PG_BASE+i]);
        {$ENDIF}
        if trim(SystemInfo.IPAddr_PG[i])  = '' then SystemInfo.IPAddr_PG[i]  := Format('%s.%d',[IPADDR_PG_PREFIX,  IPADDR_PG_BASE+i]);
        if SystemInfo.SPI_TYPE = DefPG.SPI_TYPE_DJ023_SPI then begin
          {$IFDEF SIMULATOR_SPI}
          SystemInfo.IPAddr_SPI[i] := Format('%s.%d',[IPADDR_DJ023_PREFIX, IPADDR_DJ023_BASE+i]);
          {$ELSE}
          SystemInfo.IPAddr_SPI[i]    := fSys.ReadString('SYSTEMDATA',  'IP_ADDR_SPI'+IntToStr(i+1), Format('%s.%d',[IPADDR_DJ023_PREFIX,IPADDR_DJ023_BASE+i]));
          if trim(SystemInfo.IPAddr_SPI[i]) = '' then SystemInfo.IPAddr_SPI[i] := Format('%s.%d',[IPADDR_DJ023_PREFIX, IPADDR_DJ023_BASE+i]);
          {$ENDIF}
        end
        else begin
          {$IFDEF SIMULATOR_SPI}
          SystemInfo.IPAddr_SPI[i] := Format('%s.%d',[IPADDR_QSPI_PREFIX, IPADDR_QSPI_BASE+i]);
          {$ELSE}
          SystemInfo.IPAddr_SPI[i]    := fSys.ReadString('SYSTEMDATA',  'IP_ADDR_SPI'+IntToStr(i+1), Format('%s.%d',[IPADDR_QSPI_PREFIX,IPADDR_QSPI_BASE+i]));
          if trim(SystemInfo.IPAddr_SPI[i]) = '' then SystemInfo.IPAddr_SPI[i] := Format('%s.%d',[IPADDR_QSPI_PREFIX, IPADDR_QSPI_BASE+i]);
          {$ENDIF}
        end;
      end;
    //SystemInfo.UseCh[0]		          := //TBD?
    //SystemInfo.UseCh[1]		          := //TBD?

      // PG/SPI Download
      SystemInfo.PgFwDownStartWaitSec   := fSys.ReadInteger('SYSTEMDATA', 'PgFwDownStartWaitSec',   5);
      SystemInfo.PgFwDownEndWaitSec     := fSys.ReadInteger('SYSTEMDATA', 'PgFwDownEndWaitSec',    10);
      SystemInfo.PgFpgaDownStartWaitSec := fSys.ReadInteger('SYSTEMDATA', 'PgFpgaDownStartWaitSec', 5);
      SystemInfo.PgFpgaDownEndWaitSec   := fSys.ReadInteger('SYSTEMDATA', 'PgFpgaDownEndWaitSec',   5);
      SystemInfo.PgALDPDownStartWaitSec := fSys.ReadInteger('SYSTEMDATA', 'PgALDPDownStartWaitSec', 5);
      SystemInfo.PgALDPDownEndWaitSec   := fSys.ReadInteger('SYSTEMDATA', 'PgALDPDownEndWaitSec',  10);
      SystemInfo.PgDLPUDownStartWaitSec := fSys.ReadInteger('SYSTEMDATA', 'PgDLPUPDownStartWaitSec',10); //TBD:DLPU?
      SystemInfo.PgDLPUDownEndWaitSec   := fSys.ReadInteger('SYSTEMDATA', 'PgDLPUDownEndWaitSec',  120); //TBD:DLPU?
      SystemInfo.PgBmpDownStartWaitSec  := fSys.ReadInteger('SYSTEMDATA', 'PgBmpDownStartWaitSec', 30);
      SystemInfo.PgBmpDownEndWaitSec    := fSys.ReadInteger('SYSTEMDATA', 'PgBmpDownEndWaitSec',   30);
      SystemInfo.PgBmpDownSetupInterDataMsec := fSys.ReadInteger('SYSTEMDATA', 'PgBmpDownSetupInterDataMsec', 3); //2022-12-08 (default: 3 -> 2)
      SystemInfo.PgBmpDownFlowInterDataMsec  := fSys.ReadInteger('SYSTEMDATA', 'PgBmpDownFlowInterDataMsec',  2); //2022-12-08 (default: 3 -> 2)
      SystemInfo.SpiFwDownStartWaitSec  := fSys.ReadInteger('SYSTEMDATA', 'SpiFwDownStartWaitSec',  5);
      SystemInfo.SpiFwDownEndWaitSec    := fSys.ReadInteger('SYSTEMDATA', 'SpiFwDownEndWaitSec',   10);
      SystemInfo.SpiBootDownStartWaitSec:= fSys.ReadInteger('SYSTEMDATA', 'SpiBootDownStartWaitSec',5);
      SystemInfo.SpiBootDownEndWaitSec  := fSys.ReadInteger('SYSTEMDATA', 'SpiBootDownEndWaitSec',  5);

      //2022-07-15 INI_ADD_INFO
      SystemInfo.DAE_VERSION_INI      := Trim(fSys.ReadString('SYSTEMDATA', 'DAE_VERSION_INI', ''));  //Read-only			
      SystemInfo.DAE_SYSTEM_ID        := Trim(fSys.ReadString('SYSTEMDATA', 'DAE_SYSTEM_ID',   ''));  //Read-only
    {$IFDEF HAS_DIO_EXLIGHT_DETECT}
      SystemInfo.HasDioExLightDetect  := fSys.ReadBool  ('SYSTEMDATA', 'HasDioExLightDetect', True);  //Read-only //A2CHv4_#1|#2(True=default),A2CHv4_#3(False)
    {$ELSE}
      SystemInfo.HasDioExLightDetect  := fSys.ReadBool  ('SYSTEMDATA', 'HasDioExLightDetect', False); //Read-only
    {$ENDIF}
    {$IFDEF HAS_DIO_FAN_INOUT_PC}
      SystemInfo.HasDioFanInOutPC     := fSys.ReadBool  ('SYSTEMDATA', 'HasDioFanInOutPC',   False);  //Read-only //A2CHv4_#1|#2(False=default),A2CHv4_#3(True)
    {$ELSE}
      SystemInfo.HasDioFanInOutPC     := fSys.ReadBool  ('SYSTEMDATA', 'HasDioFanInOutPC',   False);  //Read-only
    {$ENDIF}
    {$IFDEF HAS_DIO_SCREW_SHUTTER}
      SystemInfo.HasDioScrewShutter   := fSys.ReadBool  ('SYSTEMDATA', 'HasDioScrewShutter', True);   //Read-only //A2CHv4_#1|#2(True=default),A2CHv4_#3(False)
    {$ELSE}
      SystemInfo.HasDioScrewShutter   := fSys.ReadBool  ('SYSTEMDATA', 'HasDioScrewShutter', False);  //Read-only
    {$ENDIF}
      SystemInfo.HasDioVacuum         := fSys.ReadBool  ('SYSTEMDATA', 'HasDioVacuum',       True);   //Read-only  //ATO(False),GAGO|else(True) //2023-04-10 HasDioVacuum
      //
    {$IFDEF HAS_DIO_PG_OFF}
      SystemInfo.HasDioOutPGOff     := fSys.ReadBool ('SYSTEMDATA', 'HasDioOutPGOff', False);  //Read-only
    {$ELSE}
      SystemInfo.HasDioOutPGOff     := False;
    {$ENDIF}
    {$IFDEF HAS_DIO_IN_DOOR_LOCK}
      SystemInfo.HasDioInDoorLock   := fSys.ReadBool ('SYSTEMDATA', 'HasDioInDoorLock', False); //Read-only //2024.01~ NEW(HasDioInDoorLock=True)
    {$ELSE}
      SystemInfo.HasDioInDoorLock   := False;
    {$ENDIF}
    {$IFDEF HAS_DIO_Y_AXIS_MC}
      SystemInfo.HasDioYAxisMC      := fSys.ReadBool ('SYSTEMDATA', 'HasDioYAxisMC', False); //Read-only //2024.01~ NEW(HasDioYAxisMC=True)
    {$ELSE}
      SystemInfo.HasDioYAxisMC      := False;
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_STAGE_LAMP}
      SystemInfo.HasDioOutStageLamp := fSys.ReadBool ('SYSTEMDATA', 'HasDioOutStageLamp', False); //Read-only //2024.01~ NEW(HasDioOutStageLamp=True)
    {$ELSE}
      SystemInfo.HasDioOutStageLamp := False;
    {$ENDIF}
    {$IFDEF HAS_DIO_OUT_IONBAR}
      SystemInfo.HasDioOutIonBar    := fSys.ReadBool ('SYSTEMDATA', 'HasDioOutIonBar', False); //Read-only //2024.01~ NEW(HasDioInDoorLock=True) //TBD:2024-01~ NEW?
    {$ELSE}
      SystemInfo.HasDioOutIonBar    := False;
    {$ENDIF}
      //
    {$IFDEF FEATURE_KEEP_SHUTTER_UP}
      SystemInfo.KeepDioShutterUp   := fSys.ReadBool ('SYSTEMDATA', 'KeepDioShutterUp', True);   //Read-only //2023-08-04
    {$ELSE}
      SystemInfo.KeepDioShutterUp   := False;
    {$ENDIF}

			// Comm
    {$IF Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
      SystemInfo.EfuIcuCntPerCH       := fSys.ReadInteger('SYSTEMDATA', 'EfuIcuCntPerCH',  2);
      SystemInfo.IonizerCntPerCH      := fSys.ReadInteger('SYSTEMDATA', 'IonizerCntPerCH', 2);
    {$ELSE}
      SystemInfo.EfuIcuCntPerCH       := fSys.ReadInteger('SYSTEMDATA', 'EfuIcuCntPerCH',  1);
      SystemInfo.IonizerCntPerCH      := fSys.ReadInteger('SYSTEMDATA', 'IonizerCntPerCH', 1);
    {$ENDIF}
      SystemInfo.Com_RCB[0]           := fSys.ReadInteger('SYSTEMDATA', 'COM_RCB1', 0);
      SystemInfo.Com_RCB[1]           := fSys.ReadInteger('SYSTEMDATA', 'COM_RCB2', 0);
			
      if SystemInfo.IonizerCntPerCH = 2 then begin
        SystemInfo.Com_ION[0]         := fSys.ReadInteger('SYSTEMDATA', 'COM_ION1',   0);
        SystemInfo.Com_ION[1]         := fSys.ReadInteger('SYSTEMDATA', 'COM_ION1_2', 0);
        SystemInfo.Com_ION[2]         := fSys.ReadInteger('SYSTEMDATA', 'COM_ION2',   0);
        SystemInfo.Com_ION[3]         := fSys.ReadInteger('SYSTEMDATA', 'COM_ION2_2', 0);
      end
      else begin
        SystemInfo.Com_ION[0]         := fSys.ReadInteger('SYSTEMDATA', 'COM_ION1', 0);
        SystemInfo.Com_ION[1]         := fSys.ReadInteger('SYSTEMDATA', 'COM_ION2', 0);
        SystemInfo.Com_ION[2]         := 0;
        SystemInfo.Com_ION[3]         := 0;
      end;

{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2) or Defined(POCB_F2CH)}
      SystemInfo.ION_PRODUCT_MODEL    := fSys.ReadString ('SYSTEMDATA', 'ION_PRODUCT_MODEL', 'SBL-12A'); //A2CH|A2CHv2|F2CH|A2CHv3(VH#2)
{$ELSE}
      SystemInfo.ION_PRODUCT_MODEL    := fSys.ReadString ('SYSTEMDATA', 'ION_PRODUCT_MODEL', 'SBL-20W'); //A2CHv3(VH#3)|A2CHv4
{$ENDIF}
      SystemInfo.Com_HandBCR          := fSys.ReadInteger('SYSTEMDATA', 'COM_HandBCR', 0);
      SystemInfo.Com_ExLight          := fSys.ReadInteger('SYSTEMDATA', 'COM_ExLight', 0); //2019-04-16 ExLight
      SystemInfo.Com_EFU              := fSys.ReadInteger('SYSTEMDATA', 'COM_EFU', 0);     //2019-05-02 EFU
      SystemInfo.ShareFolder      	  := fSys.ReadString ('SYSTEMDATA', 'SHARE_FOLDER', '');
      SystemInfo.BmpShareFolder       := fSys.ReadString ('SYSTEMDATA', 'BMP_SHARE_FOLDER', '');  //2019-02-08
      SystemInfo.MatchSerialFolder    := fSys.ReadString ('SYSTEMDATA', 'MATCH_SERIAL_FOLDER', '');

{$IFDEF SITE_LENSVN}
      // LENS MES (HTTP/JSON)
      SystemInfo.LensMesUrlIF		 		:= fSys.ReadString ('LENS_MES_CONFIG', 'LensMesUrlIF',      'http://10.13.6.153/');
      SystemInfo.LensMesUrlLogin		:= fSys.ReadString ('LENS_MES_CONFIG', 'LensMesUrlLogin',   'prod-api/auth/login');
      SystemInfo.LensMesUrlStart		:= fSys.ReadString ('LENS_MES_CONFIG', 'LensMesUrlStart',   'prod-api/v190/productSerialNumber/start');
      SystemInfo.LensMesUrlEnd		 	:= fSys.ReadString ('LENS_MES_CONFIG', 'LensMesUrlEnd',     'prod-api/v190/deviceApi/pass/complexPassStation');
      SystemInfo.LensMesUrlEqStatus	:= fSys.ReadString ('LENS_MES_CONFIG', 'LensMesUrlEqStatus','prod-api/v190/deviceApi/machineStatus/upload');
      SystemInfo.LensMesUrlReInput	:= fSys.ReadString ('LENS_MES_CONFIG', 'LensMesUrlReInput', 'prod-api/v190/deviceApi/snCheck/checkSnExitsAndOperationValid');
      SystemInfo.LenMesSITE		 			:= fSys.ReadString ('LENS_MES_CONFIG', 'LenMesSITE',      'V190');
      SystemInfo.LensMesOPERATION		:= fSys.ReadString ('LENS_MES_CONFIG', 'LensMesOPERATION','81000');
      SystemInfo.LensMesMO		 			:= fSys.ReadString ('LENS_MES_CONFIG', 'LensMesMO', '');
      SystemInfo.LensMesITEM		 		:= fSys.ReadString ('LENS_MES_CONFIG', 'LensMesITEM', '');
      SystemInfo.LensMesSHIFT		 		:= fSys.ReadString ('LENS_MES_CONFIG', 'LensMesSHIFT', 'A');
      SystemInfo.LensMesWaitSec		 	:= fSys.ReadInteger('LENS_MES_CONFIG', 'LensMesWaitSec', 3);
{$ELSE}
      // LGD GMES
      SystemInfo.MES_ServicePort		 	:= fSys.ReadString ('SYSTEMDATA', 'MES_SERVICEPORT', '');
      SystemInfo.MES_Network				 	:= fSys.ReadString ('SYSTEMDATA', 'MES_NETWORK', '');
      SystemInfo.MES_DaemonPort		   	:= fSys.ReadString ('SYSTEMDATA', 'MES_DAEMONPORT', '');
      SystemInfo.MES_LocalSubject	  	:= fSys.ReadString ('SYSTEMDATA', 'MES_LOCALSUBJECT', '');
      SystemInfo.MES_RemoteSubject	 	:= fSys.ReadString ('SYSTEMDATA', 'MES_REMOTESUBJECT', '');
      SystemInfo.EqccInterval 	 			:= fSys.ReadString ('SYSTEMDATA', 'MES_EQCC_INTERVAL', '60000');
      SystemInfo.UseEQCC              := fSys.ReadBool   ('SYSTEMDATA', 'USE_EQCC', False);
      SystemInfo.LocalIP_GMES					:= fSys.ReadString ('SYSTEMDATA', 'LocalIP_GMES','');
{$ENDIF}

      SystemInfo.UseGIB               := fSys.ReadBool   ('SYSTEMDATA', 'USE_GIB', False);  //2019-11-08
	{$IFDEF SUPPORT_1CG2PANEL}
      SystemInfo.UseAssyPOCB          := fSys.ReadBool   ('SYSTEMDATA', 'USE_ASSY_POCB', False);
			SystemInfo.UseSkipPocbConfirm   := False; //2022-06-XX
      if SystemInfo.UseAssyPOCB then begin
				SystemInfo.UseGIB := True;
        SystemInfo.UseSkipPocbConfirm := fSys.ReadBool('SYSTEMDATA', 'USE_SKIP_POCB_CONFIRM', False); //2022-06-XX
      end;
	{$ELSE}
    //SystemInfo.UseAssyPOCB          := False;
		//SystemInfo.UseSkipPocbConfirm   := False;
	{$ENDIF}

      SystemInfo.UseEicrPassOnly      := fSys.ReadBool   ('SYSTEMDATA', 'USE_EICR_PASS_ONLY', False);
      SystemInfo.UseGRR               := fSys.ReadBool   ('SYSTEMDATA', 'USE_GRR', False);
      SystemInfo.UsePinBlock          := fSys.ReadBool   ('SYSTEMDATA', 'USE_PINBLOCK', True);
      SystemInfo.UseDetectLight       := fSys.ReadBool   ('SYSTEMDATA', 'USE_DETECTLIGHT', True);
      SystemInfo.DefaultScanFist      := fSys.ReadBool   ('SYSTEMDATA', 'DEFAULT_SCANFIRST', True);
      SystemInfo.BuzzerNo             := fSys.ReadInteger('SYSTEMDATA', 'BUZZER_NO', 0);
	{$IFDEF USE_EAS}
      SystemInfo.EAS_UseAPDR          := fSys.ReadBool   ('SYSTEMDATA', 'EAS_USE_APDR', False);
      SystemInfo.EAS_ServicePort			:= fSys.ReadString ('SYSTEMDATA', 'EAS_SERVICEPORT', '');
      SystemInfo.EAS_Network		 			:= fSys.ReadString ('SYSTEMDATA', 'EAS_NETWORK', '');
      SystemInfo.EAS_DaemonPort		 		:= fSys.ReadString ('SYSTEMDATA', 'EAS_DAEMONPORT', '');
      SystemInfo.EAS_LocalSubject  	 	:= fSys.ReadString ('SYSTEMDATA', 'EAS_LOCALSUBJECT', '');  //2019-11-08
      if SystemInfo.EAS_LocalSubject = '' then SystemInfo.EAS_LocalSubject := SystemInfo.MES_LocalSubject; //2019-11-08
      SystemInfo.EAS_RemoteSubject	 	:= fSys.ReadString ('SYSTEMDATA', 'EAS_REMOTESUBJECT', '');
	{$ENDIF}
			// GUI
      SystemInfo.Language	 						:= fSys.ReadInteger('SYSTEMDATA', 'LANGUAGE', 0);
      SystemInfo.UIType         			:= fSys.ReadInteger('SYSTEMDATA', 'UI_TYPE', 0);
			// ETC
      SystemInfo.AutoBackupList      	:= fSys.ReadString ('SYSTEMDATA', 'AUTOBACKUP_PATH', '');
      SystemInfo.AutoBackupUse        := fSys.Readbool   ('SYSTEMDATA', 'AUTOBACKUP_USE', False);
      SystemInfo.UseManualSerial      := fSys.Readbool   ('SYSTEMDATA', 'MANUAL_SERAIL_INPUT', False);
      SystemInfo.SpiResetWhenTimeout  := fSys.Readbool   ('SYSTEMDATA', 'SPI_RESET_WHEN_TIMEOUT', True); //2019-04-27
      SystemInfo.UseSeialMatch        := fSys.Readbool   ('SYSTEMDATA', 'SERIAL_MATCH_USE',  False);
      SystemInfo.PrevSerial           := fSys.ReadInteger('SYSTEMDATA', 'PRE_SERIAL_MACTCH_CNT',  200);
      //
      SystemInfo.UseAirKnife          := fSys.Readbool   ('SYSTEMDATA', 'USE_AIRKNIFE',  False);
      SystemInfo.ScreenSaverTime      := fSys.ReadInteger('SYSTEMDATA', 'SCREENSAVERTIME', 0);
      SystemInfo.IdlePmModeLogInPopUpTime := fSys.ReadInteger('SYSTEMDATA', 'IdlePmModeLogInPopUpTime', 30); //2023-10-12 IDLE_PMMODE_LOGIN_POPUP (default:30 min)

      SystemInfo.UseConfirmHost       := fSys.Readbool   ('SYSTEMDATA', 'MES_CONFIRM_HOST',  False);
      SystemInfo.UseUniformityPoint   := fSys.Readbool   ('SYSTEMDATA', 'USE_UNIFORMITY_POINT',  False);
	{$IFDEF USE_FPC_LIMIT}
      // FPC Usage Limit //2019-04-11
      SystemInfo.FpcUsageLimitUse    	:= fSys.Readbool   ('SYSTEMDATA', 'FPC_USAGE_LIMIT_USE', False);
      SystemInfo.FpcUsageLimitValue   := fSys.ReadInteger('SYSTEMDATA', 'FPC_USAGE_LIMIT_VALUE', 0);
	{$ENDIF}
	{$IFDEF DFS_EXTRA}
      SystemInfo.LogOutTime           := fsys.ReadInteger('SYSTEMDATA', 'LOGOUT_TIME',5);
	{$ENDIF}
      SystemInfo.UseBuzzer            := fsys.Readbool   ('SYSTEMDATA', 'USE_BUZZER', True); //2019-09-03
	{$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2) or Defined(POCB_F2CH)}
      SystemInfo.ExLightCh_Count      := fSys.ReadInteger('SYSTEMDATA', 'ExLightCh_Count', 3); //A2CH|A2CHv2|F2CH
	{$ELSEIF Defined(POCB_ATO) or Defined(POCB_GAGO)}
      SystemInfo.ExLightCh_Count      := fSys.ReadInteger('SYSTEMDATA', 'ExLightCh_Count', 6); //LENS(ATO|GAGO)
	{$ELSE}
      SystemInfo.ExLightCh_Count      := fSys.ReadInteger('SYSTEMDATA', 'ExLightCh_Count', 2); //A2CHv3|A2CHv4
	{$ENDIF}
  {$IFDEF SITE_LENSVN}
      SystemInfo.UseLogUploadPath     := True; //2023-09-20
  {$ELSE}
      SystemInfo.UseLogUploadPath     := fsys.Readbool   ('SYSTEMDATA', 'UseLogUploadPath', False); //2022-07-25 LOG_UPLOAD
  {$ENDIF}
  {$IFDEF FEATURE_DIO_LOG_SHUTTER}          //2023-05-02 DioLog:CH1:SHUTTER:UP
      SystemInfo.UseDioLogShutter     := fsys.Readbool   ('SYSTEMDATA', 'UseDioLogShutter', False); //2023-05-02
	{$ENDIF}

	{$IFDEF DFS_HEX}
		  DfsConfInfo.bUseDfs         := fSys.Readbool('DFSDATA', 	 'USE_DFS',  False);
		  DfsConfInfo.bDfsHexCompress := fSys.Readbool('DFSDATA', 	 'USE_HEX_COMPRESS', False);
		  DfsConfInfo.bDfsHexDelete   := fSys.Readbool('DFSDATA',    'USE_HEX_DELETE', False);
      DfsConfInfo.sDfsServerIP    := fSys.ReadString('DFSDATA',  'DFS_SERVER_IP','');
      DfsConfInfo.sDfsUserName    := fSys.ReadString('DFSDATA',  'DFS_USER_NAME','');
      DfsConfInfo.sDfsPassword    := fSys.ReadString('DFSDATA',  'DFS_PASSWORD','');
      //
      DfsConfInfo.bUseCombiDown   := fSys.Readbool('DFSDATA', 	  'USE_COMBI_DOWN',  False);
      DfsConfInfo.sCombiDownPath  := fSys.ReadString('DFSDATA',  'COMBI_DOWN_PATH','');
	{$ENDIF}

			// [MOTION_DATA] ---------------------------
      // Common
      MotionInfo.StartupHomeModelPos  := fSys.Readbool('MOTION_DATA', 'StartupHomeModelPos', False);
      MotionInfo.ServoAlarmHomeSearch := fSys.Readbool('MOTION_DATA', 'ServoAlarmHomeSearch', False);
	{$IFDEF HAS_MOTION_TILTING}
      MotionInfo.SkipTaxisMotionCtl   := fSys.Readbool('MOTION_DATA', 'SkipTaxisMotionCtl', False);
	{$ENDIF}
			// Y-Axis
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisUnit', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisUnit := DefMotion.AxMC_Y_AXIS_UNIT
      else                      MotionInfo.YaxisUnit := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisPulse', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisPulse := DefMotion.AxMC_Y_AXIS_PULSE
      else                      MotionInfo.YaxisPulse := StrToInt(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisUnitPerPulse', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisUnitPerPulse := DefMotion.AxMC_Y_AXIS_UNITpPULSE
      else                      MotionInfo.YaxisUnitPerPulse := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisStartStopSpeed', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisStartStopSpeed := DefMotion.AxMC_Y_AXIS_STARTSTOPSPEED
      else                      MotionInfo.YaxisStartStopSpeed := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisStartStopSpeedMax', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisStartStopSpeedMax := DefMotion.AxMC_Y_AXIS_STARTSTOPSPEED*2
      else                      MotionInfo.YaxisStartStopSpeedMax := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisVelocity', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisVelocity := DefMotion.AxMC_Y_AXIS_VELOCITY
      else                      MotionInfo.YaxisVelocity := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisVelocityMax', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisVelocityMax := DefMotion.AxMC_Y_AXIS_VELOCITY*2
      else                      MotionInfo.YaxisVelocityMax := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisAcceleration', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisAccel := DefMotion.AxMC_Y_AXIS_ACCEL
      else                      MotionInfo.YaxisAccel := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisAccelerationMax', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisAccelMax := DefMotion.AxMC_Y_AXIS_ACCEL*2
      else                      MotionInfo.YaxisAccelMax := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisSoftLimitUse', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisSoftLimitUse := 0   //TBD:MOTION:IMSI toBe (0->1)
      else                      MotionInfo.YaxisSoftLimitUse := StrToInt(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisSoftLimitMinus', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisSoftLimitMinus := DefMotion.AxMC_Y_AXIS_POS_LIMIT_MINUS
      else                      MotionInfo.YaxisSoftLimitMinus := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'YaxisSoftLimitPlus', '');
      if Length(sTemp) = 0 then MotionInfo.YaxisSoftLimitPlus := DefMotion.AxMC_Y_AXIS_POS_LIMIT_PLUS
      else                      MotionInfo.YaxisSoftLimitPlus := StrToFloat(sTemp);
      MotionInfo.YPulseOutMethod := fSys.ReadInteger('MOTION_DATA', 'YPulseOutMethod', DefMotion.PULSE_OUT_METHOD_Y_AXIS); //2022-08-05
      MotionInfo.YaxisServoHomeSpeed := fSys.ReadFloat('MOTION_DATA', 'YaxisServoHomeSpeed',0); // Added by Kimjs007 2024-02-23 오후 4:45:56

      if MotionInfo.YaxisServoHomeSpeed > MAX_Y_AXIS_HOME_SPEED then
         MotionInfo.YaxisServoHomeSpeed := MAX_Y_AXIS_HOME_SPEED;          // Added by Kimjs007 2024-02-23 오후 4:54:49

      MotionInfo.YaxisServoHomeAcc := fSys.ReadFloat('MOTION_DATA', 'YaxisServoHomeAcc', 0);  // Added by Kimjs007 2024-02-23 오후 4:45:56
      MotionInfo.YaxisServoHomeDcc := fSys.ReadFloat('MOTION_DATA', 'YaxisServoHomeDcc', 0);  // Added by Kimjs007 2024-02-23 오후 4:45:56

			{$IFDEF HAS_MOTION_CAM_Z}
			// Z-Axis
    	MotionInfo.ZaxisMotorAmp  := fSys.ReadInteger('MOTION_DATA', 'ZaxisMotorAmp', DefMotion.AxMC_Z_AXIS_MOTOR_AMP);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisUnit', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisUnit := DefMotion.AxMC_Z_AXIS_UNIT
      else                      MotionInfo.ZaxisUnit := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisPulse', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisPulse := DefMotion.AxMC_Z_AXIS_PULSE
      else                      MotionInfo.ZaxisPulse := StrToInt(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisUnitPerPulse', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisUnitPerPulse := DefMotion.AxMC_Z_AXIS_UNITpPULSE
      else                      MotionInfo.ZaxisUnitPerPulse := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisStartStopSpeed', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisStartStopSpeed := DefMotion.AxMC_Z_AXIS_STARTSTOPSPEED
      else                      MotionInfo.ZaxisStartStopSpeed := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisStartStopSpeedMax', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisStartStopSpeedMax := DefMotion.AxMC_Z_AXIS_STARTSTOPSPEED*2
      else                      MotionInfo.ZaxisStartStopSpeedMax := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisVelocity', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisVelocity := DefMotion.AxMC_Z_AXIS_VELOCITY
      else                      MotionInfo.ZaxisVelocity := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisVelocityMax', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisVelocityMax := DefMotion.AxMC_Z_AXIS_VELOCITY*2
      else                      MotionInfo.ZaxisVelocityMax := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisAcceleration', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisAccel := DefMotion.AxMC_Z_AXIS_ACCEL
      else                      MotionInfo.ZaxisAccel := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisAccelerationMax', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisAccelMax := DefMotion.AxMC_Z_AXIS_ACCEL*2
      else                      MotionInfo.ZaxisAccelMax := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisSoftLimitUse', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisSoftLimitUse := 0   //TBD:MOTION:IMSI toBe (0->1)
      else                      MotionInfo.ZaxisSoftLimitUse := StrToInt(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisSoftLimitMinus', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisSoftLimitMinus := DefMotion.AxMC_Z_AXIS_POS_LIMIT_MINUS
      else                      MotionInfo.ZaxisSoftLimitMinus := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'ZaxisSoftLimitPlus', '');
      if Length(sTemp) = 0 then MotionInfo.ZaxisSoftLimitPlus := DefMotion.AxMC_Z_AXIS_POS_LIMIT_PLUS
      else                      MotionInfo.ZaxisSoftLimitPlus := StrToFloat(sTemp);
      MotionInfo.ZPulseOutMethod := fSys.ReadInteger('MOTION_DATA', 'ZPulseOutMethod', DefMotion.PULSE_OUT_METHOD_Z_AXIS); //2022-08-05
			{$ENDIF} //HAS_MOTION_CAM_Z
			{$IFDEF HAS_MOTION_TILTING}
			// Tilt-Axis
    	MotionInfo.TaxisMotorAmp  := fSys.ReadInteger('MOTION_DATA', 'TaxisMotorAmp', DefMotion.AxMC_T_AXIS_MOTOR_AMP);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisUnit', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisUnit := DefMotion.AxMC_T_AXIS_UNIT
      else                      MotionInfo.TaxisUnit := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisPulse', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisPulse := DefMotion.AxMC_T_AXIS_PULSE
      else                      MotionInfo.TaxisPulse := StrToInt(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisUnitPerPulse', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisUnitPerPulse := DefMotion.AxMC_T_AXIS_UNITpPULSE
      else                      MotionInfo.TaxisUnitPerPulse := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisStartStopSpeed', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisStartStopSpeed := DefMotion.AxMC_T_AXIS_STARTSTOPSPEED
      else                      MotionInfo.TaxisStartStopSpeed := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisStartStopSpeedMax', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisStartStopSpeedMax := DefMotion.AxMC_T_AXIS_STARTSTOPSPEED*2
      else                      MotionInfo.TaxisStartStopSpeedMax := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisVelocity', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisVelocity := DefMotion.AxMC_T_AXIS_VELOCITY
      else                      MotionInfo.TaxisVelocity := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisVelocityMax', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisVelocityMax := DefMotion.AxMC_T_AXIS_VELOCITY*2
      else                      MotionInfo.TaxisVelocityMax := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisAcceleration', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisAccel := DefMotion.AxMC_T_AXIS_ACCEL
      else                      MotionInfo.TaxisAccel := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisAccelerationMax', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisAccelMax := DefMotion.AxMC_T_AXIS_ACCEL*2
      else                      MotionInfo.TaxisAccelMax := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisSoftLimitUse', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisSoftLimitUse := 0   //TBD:MOTION:IMSI toBe (0->1)
      else                      MotionInfo.TaxisSoftLimitUse := StrToInt(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisSoftLimitMinus', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisSoftLimitMinus := DefMotion.AxMC_T_AXIS_POS_LIMIT_MINUS
      else                      MotionInfo.TaxisSoftLimitMinus := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'TaxisSoftLimitPlus', '');
      if Length(sTemp) = 0 then MotionInfo.TaxisSoftLimitPlus := DefMotion.AxMC_T_AXIS_POS_LIMIT_PLUS
      else                      MotionInfo.TaxisSoftLimitPlus := StrToFloat(sTemp);
      MotionInfo.TPulseOutMethod := fSys.ReadInteger('MOTION_DATA', 'TPulseOutMethod', DefMotion.PULSE_OUT_METHOD_T_AXIS); //2022-08-05
			{$ENDIF} //HAS_MOTION_TILTING
	  
      // Jog
      sTemp := fSys.ReadString ('MOTION_DATA', 'JogVelocity', '');
      if Length(sTemp) = 0 then MotionInfo.JogVelocity := (DefMotion.AxMC_JOG_VELOCITY_MAX / 2)
      else                      MotionInfo.JogVelocity := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'JogVelocityMax', '');
      if Length(sTemp) = 0 then MotionInfo.JogVelocityMax := DefMotion.AxMC_JOG_VELOCITY_MAX
      else                      MotionInfo.JogVelocityMax := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'JogAcceleration', '');
      if Length(sTemp) = 0 then MotionInfo.JogAccel := (DefMotion.AxMC_JOG_ACCEL_MAX / 2)
      else                      MotionInfo.JogAccel := StrToFloat(sTemp);
      sTemp := fSys.ReadString ('MOTION_DATA', 'JogAccelerationMax', '');
      if Length(sTemp) = 0 then MotionInfo.JogAccelMax := DefMotion.AxMC_JOG_ACCEL_MAX
      else                      MotionInfo.JogAccelMax := StrToFloat(sTemp);

			{$IFDEF HAS_ROBOT_CAM_Z}
			// [ROBOT_DATA] ---------------------------     //A2CHv3:ROBOT
      with RobotSysInfo do begin
        MyIpAddr          := fSys.ReadString ('ROBOT_DATA', 'RobotMyIPAddr', DefRobot.ROBOT_MY_IPDADDR);
        sTemp := DefRobot.ROBOT_IPADDR_NETWORK + IntToStr(DefRobot.ROBOT_IPADDR_BASE);
        IPAddr[JIG_A]     := fSys.ReadString ('ROBOT_DATA', 'Robot1IPAddr', sTemp);
        sTemp := DefRobot.ROBOT_IPADDR_NETWORK + IntToStr(DefRobot.ROBOT_IPADDR_BASE+1);
        IPAddr[JIG_B]     := fSys.ReadString ('ROBOT_DATA', 'Robot2IPAddr', sTemp);
        TcpPortModbus     := fSys.ReadInteger('ROBOT_DATA', 'RobotTcpPortModbus', DefRobot.ROBOT_TCPPORT_MODBUS);
        TcpPortListenNode := fSys.ReadInteger('ROBOT_DATA', 'RobotTcpPortListenNode', DefRobot.ROBOT_TCPPORT_LISTENNODE);
        //
        SpeedMax        := fSys.ReadInteger('ROBOT_DATA', 'RobotSpeedMax',      DefRobot.ROBOT_SPEED_MAX);
        StartupMoveType := enumRobotStartupMoveType(fSys.ReadInteger('ROBOT_DATA', 'RobotStartupMoveType', 2)); //0:None,1:Home,2:Model
        //
        sTemp := fSys.ReadString ('ROBOT_DATA', 'RobotCoordTolerance', '');
        if Length(sTemp) = 0 then RobotCoordTolerance := DefRobot.ROBOT_COORD_TOLERANCE
        else                      RobotCoordTolerance := SimpleRoundTo(StrToFloat(sTemp),-2);
        //
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1HomeCoord_X', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_A].X  := 0.0 else HomeCoord[JIG_A].X := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1HomeCoord_Y', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_A].Y  := 0.0 else HomeCoord[JIG_A].Y := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1HomeCoord_Z', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_A].Z  := 0.0 else HomeCoord[JIG_A].Z := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1HomeCoord_Rx', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_A].Rx := 0.0 else HomeCoord[JIG_A].Rx := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1HomeCoord_Ry', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_A].Ry := 0.0 else HomeCoord[JIG_A].Ry := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1HomeCoord_Rz', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_A].Rz := 0.0 else HomeCoord[JIG_A].Rz := SimpleRoundTo(StrToFloat(sTemp),-2);
        //
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2HomeCoord_X', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_B].X  := 0.0 else HomeCoord[JIG_B].X := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2HomeCoord_Y', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_B].Y  := 0.0 else HomeCoord[JIG_B].Y := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2HomeCoord_Z', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_B].Z  := 0.0 else HomeCoord[JIG_B].Z := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2HomeCoord_Rx', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_B].Rx := 0.0 else HomeCoord[JIG_B].Rx := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2HomeCoord_Ry', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_B].Ry := 0.0 else HomeCoord[JIG_B].Ry := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2HomeCoord_Rz', '');
        if Length(sTemp) = 0 then HomeCoord[JIG_B].Rz := 0.0 else HomeCoord[JIG_B].Rz := SimpleRoundTo(StrToFloat(sTemp),-2);
        //
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1StandbyCoord_X', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_A].X  := 0.0 else StandbyCoord[JIG_A].X := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1StandbyCoord_Y', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_A].Y  := 0.0 else StandbyCoord[JIG_A].Y := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1StandbyCoord_Z', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_A].Z  := 0.0 else StandbyCoord[JIG_A].Z := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1StandbyCoord_Rx', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_A].Rx := 0.0 else StandbyCoord[JIG_A].Rx := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1StandbyCoord_Ry', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_A].Ry := 0.0 else StandbyCoord[JIG_A].Ry := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot1StandbyCoord_Rz', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_A].Rz := 0.0 else StandbyCoord[JIG_A].Rz := SimpleRoundTo(StrToFloat(sTemp),-2);
        //
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2StandbyCoord_X', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_B].X  := 0.0 else StandbyCoord[JIG_B].X := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2StandbyCoord_Y', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_B].Y  := 0.0 else StandbyCoord[JIG_B].Y := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2StandbyCoord_Z', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_B].Z  := 0.0 else StandbyCoord[JIG_B].Z := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2StandbyCoord_Rx', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_B].Rx := 0.0 else StandbyCoord[JIG_B].Rx := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2StandbyCoord_Ry', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_B].Ry := 0.0 else StandbyCoord[JIG_B].Ry := SimpleRoundTo(StrToFloat(sTemp),-2);
        sTemp := fSys.ReadString ('ROBOT_DATA', 'Robot2StandbyCoord_Rz', '');
        if Length(sTemp) = 0 then StandbyCoord[JIG_B].Rz := 0.0 else StandbyCoord[JIG_B].Rz := SimpleRoundTo(StrToFloat(sTemp),-2);
      end;
			{$ENDIF}

			// [DEBUG] ---------------------------
      SystemInfo.DebugSelfTestPg  := fsys.Readbool   ('DEBUG', 'DebugSelfTestPg', False); //2019-10-02
      //2020-09-16 DEBUG_LOG
      SystemInfo.DebugLogLevelConfig[DefPG.DEBUG_LOG_DEVTYPE_PG] := fSys.ReadInteger('DEBUG', 'DEBUG_LOG_LEVEL_PG',  DefPG.DEBUG_LOG_LEVEL_INSPECT);
      m_nDebugLogLevelActive[DefPG.DEBUG_LOG_DEVTYPE_PG] := SystemInfo.DebugLogLevelConfig[DefPG.DEBUG_LOG_DEVTYPE_PG];
      SystemInfo.DebugLogLevelConfig[DefPG.DEBUG_LOG_DEVTYPE_SPI] := fSys.ReadInteger('DEBUG', 'DEBUG_LOG_LEVEL_SPI',DefPG.DEBUG_LOG_LEVEL_INSPECT);
      m_nDebugLogLevelActive[DefPG.DEBUG_LOG_DEVTYPE_SPI] := SystemInfo.DebugLogLevelConfig[DefPG.DEBUG_LOG_DEVTYPE_SPI];
      {$IFDEF DF136_USE}
      SystemInfo.DebugLogLevelConfig[DefPG.DEBUG_LOG_DEVTYPE_DF136] := fSys.ReadInteger('DEBUG', 'DEBUG_LOG_LEVEL_DF136',0);
      m_nDebugLogLevelActive[DefPG.DEBUG_LOG_DEVTYPE_DF136] := SystemInfo.DebugLogLevelConfig[DefPG.DEBUG_LOG_DEVTYPE_DF136];
      {$ENDIF}

    finally
      fSys.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.LoadFpgaTiming
//    Called-by: procedure TCommon.LoadBaseData;
//
procedure TCommon.LoadFpgaTiming;
var
  fn : String;
  modelF : TIniFile;
begin
  fn := Path.Ini  + 'fpga_timing.ini';
  modelF := TIniFile.Create(fn);  
  try
    FpgaData[0].FpgaTime   := StrToIntDef(StringReplace(modelF.ReadString('DUAL', 'FPGA_TIME_D',''),'0x','$',[rfReplaceAll]),0);
    FpgaData[0].STAD_Freq  := StrToIntDef(StringReplace(modelF.ReadString('DUAL', 'STAD_FREQ_D',''),'0x','$',[rfReplaceAll]),0);
    FpgaData[0].H_CD_Freq  := StrToIntDef(StringReplace(modelF.ReadString('DUAL', 'H_CD_FREQ_D',''),'0x','$',[rfReplaceAll]),0);
    FpgaData[0].L_CD_Freq  := StrToIntDef(StringReplace(modelF.ReadString('DUAL', 'L_CD_FREQ_D',''),'0x','$',[rfReplaceAll]),0);
    FpgaData[1].FpgaTime   := StrToIntDef(StringReplace(modelF.ReadString('QUAD', 'FPGA_TIME_Q',''),'0x','$',[rfReplaceAll]),0);
    FpgaData[1].STAD_Freq  := StrToIntDef(StringReplace(modelF.ReadString('QUAD', 'STAD_FREQ_Q',''),'0x','$',[rfReplaceAll]),0);
    FpgaData[1].H_CD_Freq  := StrToIntDef(StringReplace(modelF.ReadString('QUAD', 'H_CD_FREQ_Q',''),'0x','$',[rfReplaceAll]),0);
    FpgaData[1].L_CD_Freq  := StrToIntDef(StringReplace(modelF.ReadString('QUAD', 'L_CD_FREQ_Q',''),'0x','$',[rfReplaceAll]),0);
  finally
    modelF.Free;
  end;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.LoadModelInfo(fName: String): Boolean
//    Called-by: procedure TCommon.LoadBaseData;
//    Called-by: procedure TfrmMain.btnModelChangeClick(Sender: TObject);  //EF_OPTIC
//    Called-by: procedure TfrmMain.btnModelClick(Sender: TObject);
//    Called-by: procedure TfrmModelInfo.DisplayModelInfo(sModelName: string);
//    Called-by: procedure TfrmSelectModel.btnOkClick(Sender: TObject);
//
function TCommon.LoadModelInfo(nCh: Integer; fName: String): Boolean;  //A2CHv3:MULTIPLE_MODEL
var
  fn : String;
  modelF : TIniFile;
  i : Integer;
  sTemp : string;
  bIsPower_mVmA : Boolean;     //MODELINFO_POWER_mVmA  //TBD:MERGE:MODELINFO_PG? Fold(O)
  sFusingDataSection : string; //MODELINFO_POWER_mVmA  //TBD:MERGE:MODELINFO_PG? Fold(O)
  sList : TStringList;
begin
  Result := False;
  fn := Path.MODEL + fName + '.mcf';
//FillChar(EdModelInfo[nCh], SizeOf(EdModelInfo[nCh]), #0);  //TBD:MERGE?
  modelF := TIniFile.Create(fn);
  try
    with modelF do begin
      try
        //------------------------------------------------------------------- TMODELINFO & TModelInfo2
				// [MODEL_DATA] ------------------------------
        with EdModelInfo[nCh] do begin
  				//	- Model Parameters : Display Mode
          PixelType  	  			:= Byte(ReadInteger('MODEL_DATA', 'Pixel_Type', 				0));
          Bit  	        			:= Byte(ReadInteger('MODEL_DATA', 'Bit', 								0));
          Rotate  	    			:= Byte(ReadInteger('MODEL_DATA', 'Rotate', 				  	0));
          SigType  	    			:= Byte(ReadInteger('MODEL_DATA', 'Signal_Type', 				0));
          WP  	    			    := Byte(ReadInteger('MODEL_DATA', 'WP', 				        0)); //TBD:MERGE:MODELINFO_PG? FoldPOCB(O) AutoPOCB(X)
          I2cPullup  	    		:= Byte(ReadInteger('MODEL_DATA', 'I2C_PullUp', 		   	0)); //TBD:MERGE:MODELINFO_PG? FoldPOCB(O) AutoPOCB(X)
          DataLineOut   			:= Byte(ReadInteger('MODEL_DATA', 'DataLineOut',    		0));
          OpenCheck     			:= Byte(ReadInteger('MODEL_DATA', 'OpenCheck',    		  0));  //0:Disable, 1:Enable //2023-10-18 DP200|DP201
          ModelType     			:= Byte(ReadInteger('MODEL_DATA', 'ModelType',    		  0));  //0:NotUse, 1:FPD_340, 2:FDP_126, 3:FPD_340New, 4:Tributo(QC), 5:Tributo(Intel) //2022-10-12 //2023-03-24(Tributo)
				  //	- Model Parameters : Timing/Frequency
          Freq         				:= LongWord(ReadInteger('MODEL_DATA', 'Freq', 					0));
          H_Total      				:= Word(ReadInteger('MODEL_DATA', 'H_Total', 				  	0));
          H_Active     				:= Word(ReadInteger('MODEL_DATA', 'H_Active', 					0));
          H_Width      				:= Word(ReadInteger('MODEL_DATA', 'H_Width',  				  0));
          H_BP         				:= Word(ReadInteger('MODEL_DATA', 'H_BPo',							0));
          V_Total      				:= Word(ReadInteger('MODEL_DATA', 'V_Total', 				  	0));
          V_Active     				:= Word(ReadInteger('MODEL_DATA', 'V_Active',				    0));
          V_Width      				:= Word(ReadInteger('MODEL_DATA', 'V_Width',    			  0));
          V_BP         				:= Word(ReadInteger('MODEL_DATA', 'V_BPo',  					  0));
          ClockDelay   				:= Word(ReadInteger('MODEL_DATA', 'ClockDelay',    			0));
          I2cFreq      				:= Word(ReadInteger('MODEL_DATA', 'I2cFreq',  					0));
				  //	- Power Sequence
          Sequence     				:= Word(ReadInteger('MODEL_DATA', 'Sequence',  					0));

          //
				  // [FUSING_DATA] ------------------------------
				  //	- PWR_LIMIT_H_0 ~ PWR_LIMIT_H_5
				  //	- PWR_LIMIT_L_0 ~ PWR_LIMIT_L_5

          // For backward compatability: old-ModelInfo(1=100mV, 1=100mA), new-ModelInfo(1=1mV, 1=1mA)
          if ValueExists('FUSING_DATA_mVmA','PWR_VOL_0') then begin bIsPower_mVmA := True;  sFusingDataSection := 'FUSING_DATA_mVmA'; end
          else                                                begin bIsPower_mVmA := False; sFusingDataSection := 'FUSING_DATA';      end;

          for i := DefPG.PWR_VCC to DefPG.PWR_MAX do begin
            case i of
              DefPG.PWR_VCC, DefPG.PWR_VDD_VEL : begin
                if bIsPower_mVmA then begin
                  PWR_VOL[i]     := Word(ReadInteger(sFusingDataSection, Format('PWR_VOL_%d',[i]),    0));
                  PWR_LIMIT_H[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_H_%d',[i]),0));
                  PWR_LIMIT_L[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_L_%d',[i]),0));
                  PWR_OFFSET[i]  := Word(ReadInteger(sFusingDataSection, Format('PWR_OFFSET_%d',[i]), 0)); //2023-03-07 //TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
                end
                else begin
                  PWR_VOL[i]     := Word(ReadInteger(sFusingDataSection, Format('PWR_VOL_%d',[i]),    0) * 100);
                  PWR_LIMIT_H[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_H_%d',[i]),0) * 100);
                  PWR_LIMIT_L[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_L_%d',[i]),0) * 100);
                  PWR_OFFSET[i]  := Word(ReadInteger(sFusingDataSection, Format('PWR_OFFSET_%d',[i]), 0) * 100); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
                end;
              end;
              DefPG.PWR_VBR : begin
                if bIsPower_mVmA then
                  PWR_VOL[i]   := Word(ReadInteger(sFusingDataSection, Format('PWR_VOL_%d',[i]),    0))
                else
                  PWR_VOL[i]   := Word(3300); //3.30 * 1000
                PWR_OFFSET[i]  := Word(0); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
                PWR_LIMIT_H[i] := Word(0);
                PWR_LIMIT_L[i] := Word(0);
              end;
              DefPG.PWR_ICC, DefPG.PWR_IDD_IEL : begin
                PWR_VOL[i]     := Word(0);
                PWR_OFFSET[i]  := Word(0); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
                if bIsPower_mVmA then begin
                  PWR_LIMIT_H[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_H_%d',[i]),0));
                  PWR_LIMIT_L[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_L_%d',[i]),0));
                end
                else begin
                //if PWR_LIMIT_H[i] < 999 then begin
                    PWR_LIMIT_H[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_H_%d',[i-1]),0) * 100);
                    PWR_LIMIT_L[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_L_%d',[i-1]),0) * 100);
                //end;
                end;
              end;
            end;
          end;

          // Power Sequence
				  //    - PWR_ON_SEQ_0 ~ PWR_ON_SEQ_3, PWR_OFF_SEQ_0 ~ PWR_OFF_SEQ_3
          for i := 0 to 3 do begin
            PowerOnSeq[i]   :=  word(ReadInteger('FUSING_DATA', 	Format('PWR_ON_SEQ_%d',[i]),  0));
            PowerOffSeq[i]  :=  word(ReadInteger('FUSING_DATA', 	Format('PWR_OFF_SEQ_%d',[i]), 0));
          end;
				  // Ext Power Sequence  //2021-11-05 DP201 EXT_POWER_SEQ
          //    -
          if SystemInfo.PG_TYPE <> DefPG.PG_TYPE_DP489 then begin
            PwrSeqExtUse := ReadBool('EXT_POWER_SEQUENCE', 'PwrSeqExtUse', False);
          end
          else begin
            PwrSeqExtUse := False;
          end;
            PwrSeqExtAvailCnt := ReadInteger('EXT_POWER_SEQUENCE', 'PwrSeqExtAvailCnt', 1);
          for i := 0 to 5 do begin // 6~24 (Reserved)
            PwrSeqExtOnIdx[i]    := Byte(ReadInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOnIdx%d',   [i]), 0));
            PwrSeqExtOffIdx[i]   := Byte(ReadInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOffIdx%d',  [i]), 0));
            PwrSeqExtOnDelay[i]  := Word(ReadInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOnDelay%d', [i]), 0));
            PwrSeqExtOffDelay[i] := Word(ReadInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOffDelay%d',[i]), 0));
          end;

        end; // with EdModelInfo[nCh] do begin

        //
        with EdModelInfo2[nCh] do begin
          //	- Model Parameters : PG/SPI Version
          PgFwVer  	  			:= ReadString('MODEL_DATA', 'PG_FW_VER', 				'');  //2019-04-19 ALARM:FW_VERSION
          SpiFwVer  	      := ReadString('MODEL_DATA', 'SPI_FW_VER', 			'');  //2019-04-19 ALARM:FW_VERSION

          {$IFDEF SUPPORT_1CG2PANEL}
          if not SystemInfo.UseAssyPOCB then begin
          {$ENDIF}
            AssyModelInfo.UseCh1 := True; AssyModelInfo.LcmPosCh1 := LcmPosCP; AssyModelInfo.UseMainPidCh1 := True;
            AssyModelInfo.UseCh2 := True; AssyModelInfo.LcmPosCh2 := LcmPosCP; AssyModelInfo.UseMainPidCh2 := True;
          {$IFDEF SUPPORT_1CG2PANEL}
          end
          else begin
            AssyModelInfo.UseCh1        := ReadBool('ASSY_POCB_DATA', 'AssyPocbUseCh1', False);
            AssyModelInfo.LcmPosCh1     := enumLcmPosition(ReadInteger('ASSY_POCB_DATA', 'AssyPocbLcmPosCh1', 0));
            AssyModelInfo.UseMainPidCh1 := ReadBool('ASSY_POCB_DATA', 'UseMainPidCh1', False);
            AssyModelInfo.UseCh2        := ReadBool('ASSY_POCB_DATA', 'AssyPocbUseCh2', False);
            AssyModelInfo.LcmPosCh2     := enumLcmPosition(ReadInteger('ASSY_POCB_DATA', 'AssyPocbLcmPosCh2', 0));
            AssyModelInfo.UseMainPidCh2 := ReadBool('ASSY_POCB_DATA', 'UseMainPidCh2', False);
          end;
          {$ENDIF}

	  			  // 	- POCB Option
          CamYCamPosCh1   := ReadFloat('MODEL_DATA', 'CAM1_Y_CAM_POS',   0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          CamYCamPosCh2   := ReadFloat('MODEL_DATA', 'CAM2_Y_CAM_POS',   0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          CamYLoadPosCh1  := ReadFloat('MODEL_DATA', 'CAM1_Y_LOAD_POS',  0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          CamYLoadPosCh2  := ReadFloat('MODEL_DATA', 'CAM2_Y_LOAD_POS',  0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          {$IFDEF HAS_MOTION_CAM_Z}
          CamZModelPosCh1 := ReadFloat('MODEL_DATA', 'CAM1_Z_MODEL_POS', 0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          CamZModelPosCh2 := ReadFloat('MODEL_DATA', 'CAM2_Z_MODEL_POS', 0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          {$ENDIF}
          {$IFDEF HAS_ROBOT_CAM_Z}
          RobotModelInfoCh1.Coord.X  := ReadFloat ('ROBOT_DATA', 'Robot1Coord_X',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
          RobotModelInfoCh1.Coord.Y  := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Y',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          RobotModelInfoCh1.Coord.Z  := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Z',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          RobotModelInfoCh1.Coord.Rx := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Rx', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          RobotModelInfoCh1.Coord.Ry := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Ry', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          RobotModelInfoCh1.Coord.Rz := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Rz', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          RobotModelInfoCh1.ModelCmd := Trim(ReadString('ROBOT_DATA', 'Robot1ModelCmd', '')); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
          RobotModelInfoCh2.Coord.X  := ReadFloat ('ROBOT_DATA', 'Robot2Coord_X',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
          RobotModelInfoCh2.Coord.Y  := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Y',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          RobotModelInfoCh2.Coord.Z  := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Z',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          RobotModelInfoCh2.Coord.Rx := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Rx', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          RobotModelInfoCh2.Coord.Ry := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Ry', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          RobotModelInfoCh2.Coord.Rz := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Rz', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          RobotModelInfoCh2.ModelCmd := Trim(ReadString('ROBOT_DATA', 'Robot2ModelCmd', '')); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
          {$ENDIF}

          if nCh = DefPocb.CH_1 then begin
            CamYCamPos   := CamYCamPosCh1;
            CamYLoadPos  := CamYLoadPosCh1;
            {$IFDEF HAS_MOTION_CAM_Z}
            CamZModelPos := CamZModelPosCh1;
            {$ENDIF}
            {$IFDEF HAS_ROBOT_CAM_Z}
            RobotModelInfo := RobotModelInfoCh1;
            {$ENDIF}
          end
          else begin
            CamYCamPos   := CamYCamPosCh2;
            CamYLoadPos  := CamYLoadPosCh2;
            {$IFDEF HAS_MOTION_CAM_Z}
            CamZModelPos := CamZModelPosCh2;
            {$ENDIF}
            {$IFDEF HAS_ROBOT_CAM_Z}
            RobotModelInfo := RobotModelInfoCh2;
            {$ENDIF}
          end;

          //
          PowerOnPatNum    := ReadInteger('MODEL_DATA', 'PowerOnPatNum', 0);    //2021-11-24 POWER_ON_PATTERN
          PwrMeasurePatNum := ReadInteger('MODEL_DATA', 'PwrMeasurePatNum', 0); //2022-09-06 POWER_MEASURE_PAT
        //{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
          VerifyPatNum 		 := ReadInteger('MODEL_DATA', 'VerifyPatNum', 0); //2019-05-22
        //{$ENDIF}
          //
          BcrLength      := ReadInteger('MODEL_DATA', 'BCR_LENGTH', DefPocb.BCR_LENGTH_DEFAULT);
          BcrPidChkIdx   := ReadInteger('MODEL_DATA', 'BcrPidChkIdx', 0);    //A2CHv3:BCR_PID_CHECK
          BcrPidChkStr   := ReadString ('MODEL_DATA', 'BcrPidChkStr', '');   //A2CHv3:BCR_PID_CHECK
          {$IFDEF FEATURE_BCR_SCAN_SPCB}
          BcrScanMesSPCB     := ReadBool   ('MODEL_DATA', 'BcrScanMesSPCB',     True);  //A2CHv4:Lucid:ScanSPCB
          BcrSPCBIdInterlock := ReadBool   ('MODEL_DATA', 'BcrSPCBIdInterlock', False); //A2CHv4:Lucid:ScanSPCB //2023-05-19 VH#302:A2CHv4:SPCB_ID_INTERLOCK
          {$ELSE}
          BcrScanMesSPCB     := False;
          BcrSPCBIdInterlock := False;
          {$ENDIF}
          {$IFDEF FEATURE_BCR_PID_INTERLOCK}
          BcrPIDInterlock    := ReadBool   ('MODEL_DATA', 'BcrPIDInterlock', False); //2023-09-26 LGDVH#301:BCR_PID_INTERLOCK //2023-10-10 LENS:ATO:BCR_PID_INTERLOCK
          {$ELSE}
          BcrPIDInterlock    := False;
          {$ENDIF}

        //PocbRetryCnt := Word(ReadInteger('MODEL_DATA', 'PocbRetryCnt', 0));
          JudgeCount   := ReadInteger     ('MODEL_DATA', 'JUDGE_CNT',    1);

          for i := 0 to DefPocb.UNIFORMITY_PATTERN_MAX do begin
            sTemp := TernaryOp(i=0,'', (i+1).ToString);
            ComparedPat[i]  	:= ReadInteger     ('MODEL_DATA', 'COMPARED_PAT'+sTemp,    		0);
            WhiteUniform[i] 	:= ReadFloat       ('MODEL_DATA', 'WHITE_UNIFOM'+sTemp,    		70.0);
            ComparePatName[i] := ReadString      ('MODEL_DATA', Format('COMPARED_PAT%d_NAME',[i+1]), '');
          end;
          UseVacuum           := ReadBool        ('MODEL_DATA', 'USE_VACUUM', True);   //2019-06-24
          {$IFDEF FEATURE_UNIFORMITY_PUCONOFF}
          UsePucOnOff         := ReadBool        ('MODEL_DATA', 'UsePucOnOff', False); //2022-07-15
          {$ELSE}
          UsePucOnOff         := False;
          {$ENDIF}
          {$IFDEF FEATURE_PUC_IMAGE}
          UsePucImage         := ReadBool        ('MODEL_DATA', 'UsePucImage', False); //2023-04-07
          {$ELSE}
          UsePucImage         := False;
          {$ENDIF}
          BmpDownRetryCnt     := Word(ReadInteger('MODEL_DATA', 'BmpDownRetryCnt', 0)); //2021-07-07

          {$IFDEF PANEL_AUTO}
          PwrOnDelayMSec 	  	:= ReadInteger     ('MODEL_DATA', 'PWR_OFFON_DELAY',   1000); //for Backward-compatability
          PwrOnDelayMSec 	  	:= ReadInteger     ('MODEL_DATA', 'PwrOnDelayMSec',    PwrOnDelayMSec);
          PwrOffDelayMSec  		:= ReadInteger     ('MODEL_DATA', 'PwrOffDelayMSec',   PwrOnDelayMSec);
          {$ELSE}
          PwrOnDelayMSec 	  	:= ReadInteger     ('MODEL_DATA', 'PwrOnDelayMSec',    500);
          PwrOffDelayMSec  		:= ReadInteger     ('MODEL_DATA', 'PwrOffDelayMSec',   500);
          PowerOnAgingSec  		:= ReadInteger     ('MODEL_DATA', 'PowerOnAgingSec',   10);
          {$ENDIF}

          {$IFDEF PANEL_FOLD}
	        //  - PWM
  				Pwm_freq      			:= Word(ReadInteger('MODEL_DATA', 'PWMFreq',  					0));
        	Pwm_duty      			:= Word(ReadInteger('MODEL_DATA', 'PWMDuty',  					100));  //2019-10-11 DIMMING
        	UsePwm              := ReadBool        ('MODEL_DATA', 'UsePwm', False);					
          {$ENDIF}
          UseCustumPatName   := ReadBool        ('MODEL_DATA', 'USE_CUSTOM_NAME', False);
          UseVacuum          := ReadBool        ('MODEL_DATA', 'USE_VACUUM', True); //2019-06-24
          UseIonOnOff        := ReadBool        ('MODEL_DATA', 'USE_IONIZER_ON_OFF', False); //2019-09-26 Ionizer On/Off
          UseExLightFlow     := ReadBool        ('MODEL_DATA', 'UseExLightFlow',   False); // 2022-08-24 EXLIGHT_FLOW(Aging after ExLight Off --> Power On --> Aging)
          CamTEndWait				 := ReadInteger     ('MODEL_DATA', 'CAMERA_TEND_WAIT_MIN', 5); //2019-05-22
          CamCBCount         := ReadInteger     ('MODEL_DATA', 'CamCBCount',       1);
          {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
          UsePowerResetAfterEepromCBParaWrite := ReadBool ('MODEL_DATA', 'UsePowerResetAfterEepromCBParaWrite', False);
          {$ENDIF}
          {$IFDEF HAS_DIO_PINBLOCK}
          UseCheckPinblock   := ReadBool        ('MODEL_DATA', 'UseCheckPinblock', False);
          {$ENDIF}

          UseScanFirst       := ReadBool        ('MODEL_DATA', 'USE_SCANFISRT', SystemInfo.DefaultScanFist);

      {$IFDEF PANEL_AUTO}
        {$IFDEF SITE_LENSVN}
          EnablePwrMode 		     := True;
          EnableProcMask 		     := True;
          EnableFlashWriteCBData := True;
        {$ELSE} //LGDVH
          EnablePwrMode 		     := ReadBool('MODEL_DATA', 'ENABLE_PWR_OPT_MODE',    True);
          EnableProcMask 		     := ReadBool('MODEL_DATA', 'ENABLE_PROCESS_MASKING', True);
          {$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
					EnableFlashWriteCBData := False;
					{$ELSE}
          EnableFlashWriteCBData := ReadBool('MODEL_DATA', 'ENABLE_FLASH_WRITE_CBDATA', SystemInfo.UseGIB); //FLASH_WRITE_CBDATA
          {$ENDIF}
        {$ENDIF}
      {$ELSE} //FOLD|GAGO
          EnablePwrMode 		     := True;
          EnableProcMask 		     := False; // ReadBool('MODEL_DATA', 'ENABLE_PROCESS_MASKING',    False);
          EnableFlashWriteCBData := True;
      {$ENDIF}			
        end; //with EdModelInfo2[nCh]

				// [MODEL_INFO] ------------------------------
        with EdModelInfo[nCh] do begin
  				// Pattern_Group
          PatGrpName        :=  ReadString('MODEL_INFO','Pattern_Group','');
        end;
        with EdModelInfo2[nCh] do begin
          // DFS Option
          CombiModelInfoKey := Trim(ReadString('MODEL_INFO', 'COMBI_MODEL_INFO_KEY', ''));
          if CombiModelInfoKey = '' then begin
            sList := TStringList.Create;
            try
              ExtractStrings(['-'], ['-'], PWideChar(fName), sList);  //2019-04-07 (POCB: TestModel: e.g., LA177QD1-LT01)
              if sList.Count >= 1 then begin
                CombiModelInfoKey := sList[0]; //2019-04-07 (e.g., LA177QD1)
              end;
            finally
              sList.Free;
              sList := nil;
            end;
          end;
          // Log Upload Option
          LogUploadPanelModel  := Trim(ReadString('MODEL_INFO', 'LogUploadPanelModel', ''));
          if LogUploadPanelModel  = '' then begin
            sList := TStringList.Create;
            try
              ExtractStrings(['-'], ['-'], PWideChar(fName), sList);  // (POCB: TestModel: e.g., LA177QD1-LT01)
              if sList.Count >= 1 then begin
                LogUploadPanelModel  := sList[0]; // (e.g., LA177QD1)
              end;
            finally
              sList.Free;
              sList := nil;
            end;
          end;
        end;

        //DP200 ---------------------------------------------------------------- start
        if SystemInfo.PG_TYPE <> DefPG.PG_TYPE_DP489 then begin  //DP200|DP201
          with EdModelInfoALDP[nCh] do begin
            SPI_PULLUP := Byte(ReadInteger('ALDP_MODEL_DATA', 'SPI_PULLUP', 0)); // 0: disable, 1: enable
            SPI_SPEED  := Byte(ReadInteger('ALDP_MODEL_DATA', 'SPI_SPEED',  0)); // 0: 400KHz, 1: 780KHz, 2: 1.5MHz, 3: 3MHz, 4: 6.25MHz, 5: 12.5MHz
            SPI_MODE   := Byte(ReadInteger('ALDP_MODEL_DATA', 'SPI_MODE',   0)); // 0: Library(0으로 고정), 1: GPIO
            SPI_LEVEL  := Byte(ReadInteger('ALDP_MODEL_DATA', 'SPI_LEVEL',  0)); // 0: 1.2V, 1:1.8V, 2: 3.3V(Default 0)
            I2C_LEVEL  := Byte(ReadInteger('ALDP_MODEL_DATA', 'I2C_LEVEL',  0)); // 0: 1.2V, 1:1.8V, 2: 3.3V(Default 0)
            //
            ALPDP_LINK_RATE   := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_LINK_RATE', 5560)); // 5.56G(5560)
            ALPDP_H_FDP       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_H_FDP',     841));  // 841
            ALPDP_H_SDP       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_H_SDP',     16));   // 16
            ALPDP_H_PCNT      := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_H_PCNT',    876));  // 876
            ALPDP_VB_SLEEP    := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_SLEEP',  0));    // 0
            ALPDP_VB_N2       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N2',     0));    // 0
            ALPDP_VB_N3       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N3',     0));    // 0
            ALPDP_VB_N4       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N4',     0));    // 0
            ALPDP_VB_N5B      := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N5B',    122));  // 122
            ALPDP_VB_N7       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N7',     0));    // 0
            ALPDP_VB_N5A      := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N5A',    0));    // 0
            //
            ALPDP_MSA_MVID    := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_MVID',    24)); // 24
            ALPDP_MSA_NVID    := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_NVID',    24)); // 24
            ALPDP_MSA_HTOTAL  := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HTOTAL',  16)); // 16
            ALPDP_MSA_HSTART  := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HSTART',  16)); // 16
            ALPDP_MSA_HWIDTH  := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HWIDTH',  16)); // 16
            ALPDP_MSA_VTOTAL  := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VTOTAL',  16)); // 16
            ALPDP_MSA_VSTART  := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VSTART',  16)); // 16
            ALPDP_MSA_VHEIGHT := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VHEIGHT', 16)); // 16
            ALPDP_MSA_HSP_HSW := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HSP_HSW', 16)); // 16
            ALPDP_MSA_VSP_VSW := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VSP_VSW', 16)); // 16
            ALPDP_MSA_MISC0   := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_MISC0',   8));  // 8
            ALPDP_MSA_MISC1   := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_MISC1',   8));  // 8
            //
            ALPDP_SPECIAL_PANEL := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_SPECIAL_PANEL', 0)); // 0
            ALPDP_ALPM          := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_ALPM',          0)); // 0: Disable, 1: Enable
            ALPDP_LINK_MODE     := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_LINK_MODE',     0)); // 0: Manual, 1: Auto
            ALPDP_CHOP_SIZE     := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_CHOP_SIZE',     0));
            ALPDP_CHOP_SECTION  := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_CHOP_SECTION',  0));
            ALPDP_CHOP_ENABLE   := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_CHOP_ENABLE',   0));
            ALPDP_HPD_CHECK     := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_HPD_CHECK',     0)); // 0: HPD Check, 1: HPD Not Check(Default HPD Check)
            ALPDP_SCRAMBLE_SET  := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_SCRAMBLE_SET',  0)); // 0: Disable, 1: Enable
            ALPDP_LANE_SETTING  := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_LANE_SETTING',  4)); // 1~8 Lane
            ALPDP_SLAVE_ENABLE  := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_SLAVE_ENABLE',  0)); // 0: Disable, 1: Enable
            //
            ALPDP_SWING_LEVEL       := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_SWING_LEVEL',       6)); // default(6:600mVppd)
            ALPDP_PRE_EMPHASIS_PRE  := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_PRE_EMPHASIS_PRE',  7)); // default(7:1.67dB)
            ALPDP_PRE_EMPHASIS_POST := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_PRE_EMPHASIS_POST', 7)); // default(7:1.67dB)
            ALPDP_AUX_FREQ_SET      := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_AUX_FREQ_SET',      5)); // default(5:1MHz)
            //
            DP141_IF_SET  := Byte(ReadInteger('ALDP_MODEL_DATA', 'DP141_IF_SET',  0));
            DP141_CNT_SET := Byte(ReadInteger('ALDP_MODEL_DATA', 'DP141_CNT_SET', 0));
            EDID_SKIP     := Byte(ReadInteger('ALDP_MODEL_DATA', 'EDID_SKIP',     0));
            DEBUG_LEVEL   := Byte(ReadInteger('ALDP_MODEL_DATA', 'DEBUG_LEVEL',   0));
            eDP_SPEC_OPT  := Byte(ReadInteger('ALDP_MODEL_DATA', 'eDP_SPEC_OPT',  0)); //2023-03-24 Tributo
          end;
        end;
        //DP200 ---------------------------------------------------------------- end
      except
        ShowMessage(fn + ' structure is different,'+#13#10+' Make again.');
      end;

      //
      try
        Result := LoadModelParamCsv(nCh,fName, EdModelInfo2[nCh]); //USE_MODEL_PARAM_CSV
      except
        fn := Path.MODEL + fName + '_param.csv';
        ShowMessage(fn + ' file load fail.'+#13#10+' Check if file is opened or Check parameter values.');
      end;

    end;
  finally
    modelF.Free;
  //modelF := nil;
  end;
	//
  SetResolution(nCh,EdModelInfo[nCh].H_Active,EdModelInfo[nCh].V_Active); //A2CHv3:MULTIPLE_MODEL
//Result := True;
end;

function TCommon.LoadModelParamCsv(nCh: Integer; fName: String; var ModelInfo2Buf: TModelInfo2): Boolean; //USE_MODEL_PARAM_CSV
var
  fn : String;
  modelF : TIniFile;
  i : Integer;
  sErrMsg : string;
begin
  Result := False;
  fn := Path.MODEL + fName + '_param.csv';
  if (not FileExists(fn)) or (fn = '') then begin
    sErrMsg := #13#10 + 'Input Error! POCB Parameter File [' + fn + '] cannot be loaded!';
    MessageDlg(sErrMsg, mtError, [mbOk], 0);
    Exit;
  end;
  Result := GetDataModelParamCsv(nCh,fn, ModelInfo2Buf);
end;

function TCommon.GetDataModelParamCsv(nCh: Integer; fn: string; var ModelInfo2Buf: TModelInfo2): Boolean; //USE_MODEL_PARAM_CSV
var
  txtF    : Textfile;
  lstTemp : TStringList;
  sReadLine, sColGroup, sColItem, sColType : string;
  nLine  : Integer;
  sCsvLine, sErrMsg, sTempItem : string;
  sColAddr1, sColAddr2, sColAddr3, sColValue1, sColValue2 : string;
  i, nDevAddr, nRegAddr, nValue1, nValue2, nValue : Integer;
  bProcMask : Boolean;
  //
  EepromCheck : TEepromCheckRec;
  EepromWrite : TEepromWriteRec;
  EepromData  : TEepromDataRec;
  FlashData   : TFlashDataRec;
  FlashAccess : TEepromFlashAccessRec; //2021-10-08
  ParamInfo   : TModelParamCsvInfoRec; //2022-07-15 MODEL_PARAM_ADD_INFO
  TConAccess  : TTConAccessParamRec; //2022-07-15 UNIFORMITY_PUCONOFF
  TConWrite   : TTConWriteRec;       //2022-07-15UNIFORMITY_PUCONOFF
{$IF Defined(PANEL_GAGO)}
  FlashWrite    : TFlashWriteRec;
	FlashAfterPUC : TFlashWriteAfterPUCRec;
{$ENDIF}
begin
  Result := False;

	//-----------------------------------------------------------------------------
  with ModelInfo2Buf do begin
	//-----------------------------------------------------------------------------

  // Initial
  {$IF Defined(PANEL_AUTO)}
  SetLength(EepromCheckProcMask, 0);
  SetLength(EepromWriteProcMask, 0);
  SetLength(EepromWriteAfterPUC, 0);
  SetLength(EepromGammaData, 0);
  {$ELSEIF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
  SetLength(FlashWriteAfterPUC, 0);
  SetLength(FlashCBParaBlock,   0);
  SetLength(FlashGammaData,     0);
  {$ENDIF}
  SetLength(EepromCheckCBParam, 0);
  SetLength(EepromWriteCBParam, 0);
  SetLength(EepromFlashAccess,  0);
  FlashCBDataAddr.nStartAddr := 0;
//FlashCBDataAddr.nEndAddr   := 0;

  with FlashAccessParam do begin
    EraseAckWaitSec           := 60;
    DataStartAckWaitSec       := 10;
    DataEndAckWaitSec         := 180;
    DataSendInterDelayMsec    := 2;
    AccEnableBeforeDelayMsec  := 0;
    AccEnableAfterDelayMsec   := 100;
    InitBeforeDelayMsec       := 0;
    InitAfterDelayMsec        := 100;
    EraseBeforeDelayMsec      := 0;
    EraseAfterDelayMsec       := 100;
    DataStartBeforeDelayMsec  := 0;
    DataStartAfterDelayMsec   := 100;
    DataEndBeforeDelayMsec    := 0;
    DataEndAfterDelayMsec     := 100;
    AccDisableBeforeDelayMsec := 0;
    AccDisableAfterDelayMsec  := 100;
  end;

  //2022-07-15 MODEL_PARAM_ADD_INFO
  with ParamInfo do begin
    bVersion       := False;
    nFormatType    := 0;
    nFormatVersion := 0;
    sPanelModel    := '';
    sDate          := '';
  end;

  //2022-07-15 UNIFORMITY_PUCONOFF
  TConAccessParam.Addr2DevRegConvMethod := '';
  for i := 0 to 1 do begin
{$IFDEF PANEL_AUTO}
    TConParam.PocbOnOff[i].nTConAddr := 0;
{$ELSE}
    TConParam.PocbOnOff[i].nDevAddr  := 0;
    TConParam.PocbOnOff[i].nRegAddr  := 0;
{$ENDIF}
  //TConParam.PocbOnOff[i].nMask     := $FF;
    TConParam.PocbOnOff[i].nValue    := 0;
  //TConParam.PocbOnOff[i].bMask     := False;
    TConParam.PocbOnOff[i].bValue    := False;
  end;

  // Read param.csv
  sErrMsg := '';
  if IOResult = 0 then begin
		try
    	AssignFile(txtF, fn);
		except
			sErrMsg := Format('PARAM.CSV ERROR (file open error: %s',[fn]);
			MessageDlg(sErrMsg, mtError, [mbOk], 0);
			Exit;
		end;
    lstTemp := TStringList.Create;
    try
      Reset(txtF);
      nLine := 0;
      lstTemp.Delimiter       := ',';
      lstTemp.StrictDelimiter :=True;
      while not Eof(txtF) do begin
        Readln(txtF, sReadLine);
        Inc(nLine);
        sCsvLine := 'CH'+IntToStr(nCh+1)+':LINE'+IntToStr(nLine)+'('+sReadLine+'):';
        try
        //ExtractStrings([','], [], PWideChar(sReadLine), lstTemp); //TBD:???
          lstTemp.Clear;
          lstTemp.DelimitedText := sReadLine;
          //
          if lstTemp.Count <= 0 then Continue;  // ignore (empty line)
          //
          sColGroup := Trim(lstTemp[0]);
          if Length(sColGroup) < 2 then begin
            sErrMsg := Format('PARAM.CSV ERROR (line%2d: unknown Group[%s])',[nLine,sColGroup]);
            //Exit;  // NG (unknown Group)
          end;
          if (sColGroup[1] = '#') or ((nLine = 1) and (lstTemp.Count < 4)) then Continue; //  ignore (comment line)
          //
          if lstTemp.Count < 4 then begin
            sErrMsg := Format('PARAM.CSV ERROR (line%2d: less then minimum column count 4)',[nLine]);
            Exit;  // NG (min 4 if not comment line)
          end;
          sColItem := Trim(lstTemp[1]);
          sColType := Trim(lstTemp[2]);
          //
          // EepromParam, ProcMask, Verify, DeviceAddr#, RegisterAddr#, Value#, Comment
          // EepromParam, ProcMask, Write,  DeviceAddr#, RegisterAddr#, StartValue#, FinalValue#, Comment
          // EepromParam, CBParam,  Write,  DeviceAddr#, RegisterAddr#, StartValue#, FinalValue#, Comment
          // EepromParam, AfterPUCWrite, Write, DeviceAddr#, RegisterAddr#, Value#, Comment //2022-09-01
          // EepromParam, FlashAccessEnableDisable, Write, DeviceAddr#, RegisterAddr#, Bit#, Comment
          if UpperCase(sColGroup) = UpperCase('EepromParam') then begin
            {$IF Defined(PANEL_AUTO)}
            sTempItem := 'ProcMask|CBParam';
            if (UpperCase(sColItem) = UpperCase('ProcMask')) or (UpperCase(sColItem) = UpperCase('CBParam')) then
            {$ELSEIF Defined(PANEL_GAGO)}
            sTempItem := 'CBParam';
            if (UpperCase(sColItem) = UpperCase('CBParam')) then
            {$ENDIF}
            begin
              {$IF Defined(PANEL_AUTO)}
              if UpperCase(sColItem) = UpperCase('ProcMask') then bProcMask := True else bProcMask := False;
              {$ENDIF}
              if UpperCase(sColType) = UpperCase('Verify') then begin
                if lstTemp.Count >= 6 then begin
                  sColAddr1 := '';  sColAddr2 := ''; sColValue1 := ''; sColValue2 := '';
                  if lstTemp[3] <> '' then sColAddr1  := Trim(lstTemp[3]); //DeviceAddr
                  if lstTemp[4] <> '' then sColAddr2  := Trim(lstTemp[4]); //RegisterAddr
                  if lstTemp[5] <> '' then sColValue1 := Trim(lstTemp[5]); //Value
CodeSite.Send(sCsvLine+'EepromParam,'+sTempItem+',Verify:'+'DevAddr='+sColAddr1+',RegAddr='+sColAddr2+',Value='+sColValue1);
                  if (sColAddr1 = '') or (sColAddr2 = '') or (sColValue1 = '') then Continue;
                  //
                  EepromCheck.nDevAddr := StrToIntDef(StringReplace(sColAddr1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if (EepromCheck.nDevAddr = 0) then Continue;
                  EepromCheck.nRegAddr := StrToIntDef(StringReplace(sColAddr2,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  EepromCheck.nValue   := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  //
                  {$IF Defined(PANEL_AUTO)}
                  if bProcMask then begin
                    SetLength(ModelInfo2Buf.EepromCheckProcMask, Length(EepromCheckProcMask)+1);
                    EepromCheckProcMask[High(ModelInfo2Buf.EepromCheckProcMask)] := EepromCheck;
                  end
                  else begin
                  {$ENDIF}
                    SetLength(ModelInfo2Buf.EepromCheckCBParam, Length(EepromCheckCBParam)+1);
                    EepromCheckCBParam[High(ModelInfo2Buf.EepromCheckCBParam)] := EepromCheck;
                  {$IF Defined(PANEL_AUTO)}
                  end;
                  {$ENDIF}
                end
                else begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromParam,'+sTempItem+',Verify: less than the minimum column count[6])',[nLine]);
                  Exit;
                end;
              end
              else if UpperCase(sColType) = UpperCase('Write') then begin
                if lstTemp.Count >= 6 then begin
                  sColAddr1 := '';  sColAddr2 := ''; sColValue1 := ''; sColValue2 := '';
                  if lstTemp[3] <> '' then sColAddr1  := Trim(lstTemp[3]); //DeviceAddr
                  if lstTemp[4] <> '' then sColAddr2  := Trim(lstTemp[4]); //RegisterAddr
                  if lstTemp[5] <> '' then sColValue1 := Trim(lstTemp[5]); //StartValue
                  if (lstTemp.Count >= 7) and (lstTemp[6] <> '') then sColValue2 := Trim(lstTemp[6]); //FinalValue
CodeSite.Send(sCsvLine+'EepromParam,'+sTempItem+',Write:'+'DevAddr='+sColAddr1+',RegAddr='+sColAddr2+',StartValue='+sColValue1+',FinalValue='+sColValue2);
                  if (sColAddr1 = '') or (sColAddr2 = '') or ((sColValue1 = '') and (sColValue2 = '')) then Continue;
                  //
                  EepromWrite.nDevAddr := StrToIntDef(StringReplace(sColAddr1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if (EepromWrite.nDevAddr = 0) then Continue;
                  EepromWrite.nRegAddr := StrToIntDef(StringReplace(sColAddr2,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if sColValue1 = '' then EepromWrite.bStartValue := False else EepromWrite.bStartValue := True;
                  EepromWrite.nStartValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if sColValue2 = '' then EepromWrite.bEndValue := False else EepromWrite.bEndValue := True;
                  EepromWrite.nEndValue   := StrToIntDef(StringReplace(sColValue2,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  //
                  {$IF Defined(PANEL_AUTO)}
                  if bProcMask then begin
                    SetLength(ModelInfo2Buf.EepromWriteProcMask, Length(EepromWriteProcMask)+1);
                    EepromWriteProcMask[High(EepromWriteProcMask)] := EepromWrite;
                  end
                  else begin
                  {$ENDIF}
                    SetLength(ModelInfo2Buf.EepromWriteCBParam, Length(EepromWriteCBParam)+1);
                    EepromWriteCBParam[High(EepromWriteCBParam)] := EepromWrite;
                  {$IF Defined(PANEL_AUTO)}
                  end;
                  {$ENDIF}
                end
                else begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromParam,'+sTempItem+',Write: less than the minimum column count[6])',[nLine]);
                  Exit;
                end;
              end
              else begin
                sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromParam,'+sTempItem+': unknown operation[neither Verity nor Write])',[nLine]);
                Exit;
              end;
            end
            {$IF Defined(PANEL_AUTO)}
            else if (UpperCase(sColItem) = UpperCase('AfterPUCWrite')) then begin  //2022-09-01
              if UpperCase(sColType) = UpperCase('Write') then begin
                if lstTemp.Count >= 6 then begin
                  sColAddr1 := '';  sColAddr2 := ''; sColValue1 := '';
                  if lstTemp[3] <> '' then sColAddr1  := Trim(lstTemp[3]); //DeviceAddr
                  if lstTemp[4] <> '' then sColAddr2  := Trim(lstTemp[4]); //RegisterAddr
                  if lstTemp[5] <> '' then sColValue1 := Trim(lstTemp[5]); //Value
CodeSite.Send(sCsvLine+'EepromParam,AfterPUCWrite,Write:'+'DevAddr='+sColAddr1+',RegAddr='+sColAddr2+',Value='+sColValue1);
                  if (sColAddr1 = '') or (sColAddr2 = '') or (sColValue1 = '') then Continue;
                  //
                  EepromWrite.nDevAddr := StrToIntDef(StringReplace(sColAddr1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if (EepromWrite.nDevAddr = 0) then Continue;
                  EepromWrite.nRegAddr := StrToIntDef(StringReplace(sColAddr2,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if sColValue1 = '' then EepromWrite.bStartValue := False else EepromWrite.bStartValue := True;
                  EepromWrite.nStartValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  EepromWrite.bEndValue := False; // N/A
                  EepromWrite.nEndValue := 0;     // N/A
                  //
                  SetLength(ModelInfo2Buf.EepromWriteAfterPUC, Length(EepromWriteAfterPUC)+1);
                  EepromWriteAfterPUC[High(EepromWriteAfterPUC)] := EepromWrite;
                end
                else begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromParam,AfterPUCWrite,Write: less than the minimum column count[6])',[nLine]);
                  Exit;
                end;
              end
              else begin
                sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromParam,AfterPUCWrite: unknown operation[not Write])',[nLine]);
                Exit;
              end;
            end
            {$ENDIF}
            else if UpperCase(sColItem) = UpperCase('FlashAccessEnableDisable') then begin
              if UpperCase(sColType) = UpperCase('Write') then begin
                if lstTemp.Count >= 6 then begin
                  sColAddr1 := '';  sColAddr2 := ''; sColValue1 := ''; sColValue2 := '';
                  if lstTemp[3] <> '' then sColAddr1  := Trim(lstTemp[3]); //DeviceAddr
                  if lstTemp[4] <> '' then sColAddr2  := Trim(lstTemp[4]); //RegisterAddr
                  if lstTemp[5] <> '' then sColValue1 := Trim(lstTemp[5]); //Bit# or Value(AccessEnable)
                  if (lstTemp.Count >= 7) and (lstTemp[6] <> '') then sColValue2 := Trim(lstTemp[6]); // Null(if BIT#) or Value(AccessDisable)
                  if (sColValue2 <> '') and (sColValue2[1] = '#') then sColValue2 := ''; // if start char is '#', comment column
                  //
                  FlashAccess.nDevAddr := StrToIntDef(StringReplace(sColAddr1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  FlashAccess.nRegAddr := StrToIntDef(StringReplace(sColAddr2,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if (sColValue2 = '') then begin
                    FlashAccess.bWriteBit    := True;
                    FlashAccess.nBit         := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                    FlashAccess.nByteEnable  := 0; //default(N/A)
                    FlashAccess.nByteDisable := 0; //default(N/A)
CodeSite.Send(sCsvLine+'EepromParam,FlashAccessEnableDisable,Write:'+'DevAddr='+sColAddr1+',RegAddr='+sColAddr2+',Bit='+sColValue1+','+sColValue2);
                  end
                  else begin
                    FlashAccess.bWriteBit    := False;
                    FlashAccess.nBit         := 0; //default(N/A)
                    FlashAccess.nByteEnable  := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                    FlashAccess.nByteDisable := StrToIntDef(StringReplace(sColValue2,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
CodeSite.Send(sCsvLine+'EepromParam-FlashAccessEnableDisable-Write:'+'DevAddr='+sColAddr1+',RegAddr='+sColAddr2+',ValueEnable='+sColValue1+',ValueDisable='+sColValue2);
                  end;
                  //
                  if (sColAddr1 = '') or (sColAddr2 = '') or (sColValue1 = '') then Continue;
                  if FlashAccess.bWriteBit then begin
                    if (FlashAccess.nBit < 0) or (FlashAccess.nBit > 7) then begin
                      sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromParam,FlashAccessEnableDisable,Write: invalid bit#[6th column])',[nLine]);
                      Exit;
                    end;
                  end
                  else begin
                    if (FlashAccess.nByteEnable > 255) or (FlashAccess.nByteDisable > 255) then begin
                      sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromParam,FlashAccessEnableDisable,Write: invalid value[6th|7th column])',[nLine]);
                      Exit;
                    end;
                  end;
                  //
                  SetLength(EepromFlashAccess, Length(EepromFlashAccess)+1);
                  EepromFlashAccess[High(EepromFlashAccess)] := FlashAccess;
                end
                else begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromParam,FlashAccessEnableDisable,Write: less than the minimum column count[6]',[nLine]);
                  Exit;
                end;
              end
              else begin
                sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromParam,FlashAccessEnableDisable: unknown operation[not Write]',[nLine]);
                Exit;
              end;
            end
            else begin
            end;
          end
          //
          // EepromData, GammaData, Read, DeviceAddr#, RegisterAddr#, Length#, Comment
          {$IF Defined(PANEL_AUTO)}
          else if UpperCase(sColGroup) = UpperCase('EepromData') then begin
            if UpperCase(sColItem) = UpperCase('GammaData') then begin
              if UpperCase(sColType) = UpperCase('Read') then begin
                if lstTemp.Count >= 6 then begin
                  sColAddr1 := '';  sColAddr2 := ''; sColValue1 := ''; sColValue2 := '';
                  if lstTemp[3] <> '' then sColAddr1  := Trim(lstTemp[3]); //DeviceAddr
                  if lstTemp[4] <> '' then sColAddr2  := Trim(lstTemp[4]); //RegisterAddr
                  if lstTemp[5] <> '' then sColValue1 := Trim(lstTemp[5]); //Length
CodeSite.Send(sCsvLine+'EepromData-GammaData-Read:'+'DevAddr='+sColAddr1+',RegAddr='+sColAddr2+',Length='+sColValue1);
                  //
                  if (sColAddr1 = '') or (sColAddr2 = '') or (sColValue1 = '') then Continue;
                  EepromData.nDevAddr := StrToIntDef(StringReplace(sColAddr1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if (EepromData.nDevAddr = 0) then Continue;
                  EepromData.nRegAddr := StrToIntDef(StringReplace(sColAddr2,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  EepromData.nLength  := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if (EepromData.nLength = 0) then Continue;
                  //
                  SetLength(EepromGammaData, Length(EepromGammaData)+1);
                  EepromGammaData[High(EepromGammaData)] := EepromData;
                end
                else begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromData,GammaData,Read: less than the minimum column count[6]',[nLine]);
                  Exit;
                end;
              end
              else begin
                sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromData,GammaData: unknown operation[not Read]',[nLine]);
                Exit;
              end;
            end
            else begin
              sErrMsg := Format('PARAM.CSV ERROR (line%2d: EepromData: unknown data type[not Gamma]',[nLine]);
              Exit;
            end;
          end
          {$ENDIF}
          //
          // FlashData, CBData, Write, FlashStartAddr#, FlashEndAddr#, Comment
          // FlashData, GammaData, Read, FlashAddr, Length, Comment
          //
          else if UpperCase(sColGroup) = UpperCase('FlashData') then begin
            if UpperCase(sColItem) = UpperCase('CBData') then begin
              // FlashData, CBData, Write, FlashStartAddr#, FlashEndAddr#, Comment
              if UpperCase(sColType) = UpperCase('Write') then begin
                if lstTemp.Count >= 4 then begin
                  sColAddr1 := Trim(lstTemp[3]); //FlashStartAddr#
                //sColAddr2 := Trim(lstTemp[4]); //FlashEndAddr#
CodeSite.Send(sCsvLine+'FlashData-CBData-Write:'+'FlashStartAddr='+sColAddr1{+',FlashEndAddr='+sColAddr2});
                  //
                  if (sColAddr1 = '') {or (sColAddr2 = '')} then Continue;
                  FlashCBDataAddr.nStartAddr := StrToIntDef(StringReplace(sColAddr1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                //FlashCBDataAddr.nEndAddr   := StrToIntDef(StringReplace(sColAddr2,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                //if FlashCBDataAddr.nStartAddr < FlashCBDataAddr.nEndAddr then begin
                //  sErrorMsg := 'PARAM.CSV ERROR (line#, xxxxxxxx)';
                //  Exit;
                //end;
                end
                else begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: FlashData,CBData,Write: less than the minimum column count[4]',[nLine]);
                  Exit;
                end;
              end
              else begin
                sErrMsg := Format('PARAM.CSV ERROR (line%2d: FlashData,CBData: unknown operation[not Write]',[nLine]);
                Exit;
              end;
            end
            {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
            else if UpperCase(sColItem) = UpperCase('GammaData') then begin
              // FlashData, GammaData, Read, FlashAddr, Length, Comment
              if UpperCase(sColType) = UpperCase('Read') then begin
                if lstTemp.Count >= 5 then begin
                  sColAddr1 := ''; sColValue1 := '';
                  if lstTemp[3] <> '' then sColAddr1  := Trim(lstTemp[3]); //FlashAddr
                  if lstTemp[4] <> '' then sColValue1 := Trim(lstTemp[4]); //Length
CodeSite.Send(sCsvLine+'FlashData-GammaData-Read:'+'FlashAddr='+sColAddr1+',Length='+sColValue1);
                  //
                  if (sColAddr1 = '') or (sColValue1 = '') then Continue;
                  FlashData.nFlashAddr := StrToIntDef(StringReplace(sColAddr1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if (FlashData.nFlashAddr = 0) then Continue;
                  FlashData.nLength  := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if (FlashData.nLength = 0) then Continue;
                  //
                  SetLength(FlashGammaData, Length(FlashGammaData)+1);
                  FlashGammaData[High(FlashGammaData)] := FlashData;
                end
                else begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: FlashData,GammaData,Read: less than the minimum column count[5]',[nLine]);
                  Exit;
                end;
              end
              else begin
                sErrMsg := Format('PARAM.CSV ERROR (line%2d: FlashData,GammaData: unknown operation[not Read]',[nLine]);
                Exit;
              end;
            end
            {$ENDIF}
            else begin
              sErrMsg := Format('PARAM.CSV ERROR (line%2d: FlashData: unknown data type[not CBData]',[nLine]);
              Exit;
            end;
          end
          //
          // FlashParam, AfterPUCWrite, Write, #FlashAddr, #WriteValue(CB1), #WriteValue(CB2), #Commen
          //
          {$IF Defined(PANEL_GAGO)}
          else if UpperCase(sColGroup) = UpperCase('FlashParam') then begin
            if (UpperCase(sColItem) = UpperCase('AfterPUCWrite')) then begin  //2022-09-01
              if UpperCase(sColType) = UpperCase('Write') then begin
                if lstTemp.Count >= 5 then begin
                  sColAddr1 := '';  sColValue1 := ''; sColValue2 := '';
                  if lstTemp[3] <> '' then sColAddr1  := Trim(lstTemp[3]); //FlashAddr
                  if lstTemp[4] <> '' then sColValue1 := Trim(lstTemp[4]); //Value1
                  if lstTemp[5] <> '' then sColValue2 := Trim(lstTemp[5]); //Value2
CodeSite.Send(sCsvLine+'FlashParam,AfterPUCWrite,Write:'+'FlashAddr='+sColAddr1+',Value1='+sColValue1+',Value2='+sColValue2);
                  if (sColAddr1 = '') {or (sColAddr2 = '') or (sColValue1 = '')} then Continue;
                  //
                  FlashAfterPUC.nAddr   := StrToIntDef(StringReplace(sColAddr1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if (FlashAfterPUC.nAddr = 0) then Continue;
                  if sColValue1 = '' then FlashAfterPUC.bValue[DefCam.CAM_STEP_CB1] := False else FlashAfterPUC.bValue[DefCam.CAM_STEP_CB1] := True;
                  FlashAfterPUC.nValue[0] := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if sColValue2 = '' then FlashAfterPUC.bValue[DefCam.CAM_STEP_CB2] := False else FlashAfterPUC.bValue[DefCam.CAM_STEP_CB2] := True;
                  FlashAfterPUC.nValue[1] := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
                  if (not FlashAfterPUC.bValue[DefCam.CAM_STEP_CB1]) and (not FlashAfterPUC.bValue[DefCam.CAM_STEP_CB2]) then Continue;
                  //
                  SetLength(ModelInfo2Buf.FlashWriteAfterPUC, Length(FlashWriteAfterPUC)+1);
                  FlashWriteAfterPUC[High(FlashWriteAfterPUC)] := FlashAfterPUC;
                end
                else begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: FlashParam,AfterPUCWrite,Write: less than the minimum column count[5])',[nLine]);
                  Exit;
                end;
              end
              else begin
                sErrMsg := Format('PARAM.CSV ERROR (line%2d: FlashParam,AfterPUCWrite: unknown operation[not Write])',[nLine]);
                Exit;
              end;
            end;
          end
          {$ENDIF}
          //
          // FlashAccessParam, ...
          else if UpperCase(sColGroup) = UpperCase('FlashAccessParam') then begin
            if lstTemp.Count < 4 then begin
              sErrMsg := Format('PARAM.CSV ERROR (line%2d: FlashAccessParam: less than the minimum column count[4]',[nLine]);
              Exit;
            end;
            if UpperCase(sColItem) = UpperCase('EraseAckWaitSec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-EraseAckWaitSec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.EraseAckWaitSec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('DataStartAckWaitSec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-DataStartAckWaitSec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.DataStartAckWaitSec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('DataEndAckWaitSec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-DataEndAckWaitSec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.DataEndAckWaitSec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('DataSendInterDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-DataSendInterDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.DataSendInterDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('AccEnableBeforeDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-AccEnableBeforeDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.AccEnableBeforeDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('AccEnableAfterDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-AccEnableAfterDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.AccEnableAfterDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('InitBeforeDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-InitBeforeDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.InitBeforeDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('InitAfterDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-InitAfterDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.InitAfterDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('EraseBeforeDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-EraseBeforeDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.EraseBeforeDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('EraseAfterDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-EraseAfterDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.EraseAfterDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('DataStartBeforeDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-DataStartBeforeDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.DataStartBeforeDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('DataStartAfterDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-DataStartAfterDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.DataStartAfterDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('DataEndBeforeDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-DataEndBeforeDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.DataEndBeforeDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('DataEndAfterDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-DataEndAfterDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.DataEndAfterDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('AccDisableBeforeDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-AccDisableBeforeDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.AccDisableBeforeDelayMsec := nValue;
            end
            else if UpperCase(sColItem) = UpperCase('AccDisableAfterDelayMsec') then begin
              sColValue1 := Trim(lstTemp[3]); //Value#
CodeSite.Send(sCsvLine+'FlashAccessParam-AccDisableAfterDelayMsec-Delay:'+sColValue1);
              if (sColValue1 = '') then Continue;
              nValue := StrToIntDef(StringReplace(sColValue1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              FlashAccessParam.AccDisableAfterDelayMsec := nValue;
            end
            else begin
CodeSite.Send(sCsvLine+'FlashAccessParam ..Unknown');
            end;
          end
          //
          //--------- ParamCsvInfo
          else if UpperCase(sColGroup) = UpperCase('ParamCsvInfo') then begin
          	//--------- ParamCsvInfo,ParamCsv
            if UpperCase(sColItem) = UpperCase('Version') then begin
         			//--------- #ParamCsvInfo,Version,#FormatType(0:Unknown,1:ITOLED_AF9:2=ITOLED_TCON,3=AUTO,4=ATO,5=GAGO),#FormatVersion,#PanelModel,#Date,,,
              if lstTemp.Count < 6 then begin
                sErrMsg := Format('PARAM.CSV ERROR (line%2d: ParamCsvInfo,Version: less than the minimum column count[6]',[nLine]);
                Exit;
  						end;
              if lstTemp[2] <> '' then sColValue1 := Trim(lstTemp[2]);
              ParamInfo.nFormatType    := StrToIntDef(StringReplace(sColType,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              if lstTemp[3] <> '' then sColValue1 := Trim(lstTemp[3]);
              ParamInfo.nFormatVersion := StrToIntDef(StringReplace(sColType,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);
              if lstTemp[4] <> '' then sColValue1 := Trim(lstTemp[4]);
              ParamInfo.sPanelModel    := Trim(lstTemp[4]);
              if lstTemp[5] <> '' then sColValue1 := Trim(lstTemp[5]);
              ParamInfo.sDate          := Trim(lstTemp[5]);
              //
              {$IF Defined(PANEL_AUTO)}
              if (ParamInfo.nFormatType <> 3) and (ParamInfo.nFormatType <> 4) then
              {$ELSEIF Defined(PANEL_GAGO)}
              if (ParamInfo.nFormatType <> 5) then
              {$ELSE}
              if (ParamInfo.nFormatType = 0) then
              {$ENDIF}
              begin
                sErrMsg := Format('PARAM.CSV ERROR (line%2d: ParamCsvInfo,Version: invalid Col3[FormatType=%d]',[nLine,ParamInfo.nFormatType]);
                Exit;
  				    end;
              //
              ParamInfo.bVersion := True;
              ParamCsvInfo := ParamInfo;
CodeSite.Send(sCsvLine+'ParamCsvInfo,Version:'+'FormatType='+lstTemp[2]+'FormatVesion='+lstTemp[3]+',PanelModel='+lstTemp[4]+',Date='+lstTemp[5]);
            end
            else begin
              sErrMsg := Format('PARAM.CSV ERROR (line%2d: ParamCsvInfo: unknown Item type[not Version]',[nLine]);
              Exit;
            end;
          end
          //
          // TConAccessParam, Addr2DevRegConversion, Info, StringValue#, Comment
          else if UpperCase(sColGroup) = UpperCase('TConAccessParam') then begin  //2022-07-15 UNIFORMITY_PUCONOFF
            if (UpperCase(sColItem) = UpperCase('Addr2DevRegConversion')) and (UpperCase(sColType) = UpperCase('Method')) then begin
              sColValue1 := '';
              if lstTemp[3] <> '' then sColValue1 := Trim(lstTemp[3]); //Value
              if (sColValue1 = '') then begin
                sErrMsg := Format('PARAM.CSV ERROR (line%2d: TConParam,PucOnOff: unknown operation[%s]',[nLine,sColType]);
                Exit;
              end;
              TConAccessParam.Addr2DevRegConvMethod := sColValue1;
CodeSite.Send(sCsvLine+'TConAccessParam,Addr2DevRegConversion,Method:'+'Value='+sColValue1); //TBD???
            end
            else begin
              sErrMsg := Format('PARAM.CSV ERROR (line%2d: TConParam: unknown Item[%s]/Type[%s]',[nLine,sColItem,sColType]);
              Exit;
            end;
          end
          //
          // (AUTO)      TConParam, PucOnOff, Write, TConAddr#, OnValue#, OffValue#, Comment
          // (FOLD|GAGO) TConParam, PucOnOff, Write, DevAddr#,  RegAddr#, OnValue#, OffValue#, Comment1,,
          else if UpperCase(sColGroup) = UpperCase('TConParam') then begin  //2022-07-15 UNIFORMITY_PUCONOFF
            if UpperCase(sColItem) = UpperCase('PucOnOff') then begin
              if UpperCase(sColType) = UpperCase('Write') then begin
{$IFDEF PANEL_AUTO}
                // (AUTO) TConParam, PucOnOff, Write, TConAddr#, OnValue#, OffValue#, Comment
                if lstTemp.Count < 6 then begin
              		sErrMsg := Format('PARAM.CSV ERROR (line%2d: TConParam,PucOnOff,Write: less than the minimum column count[6]',[nLine]);
              		Exit;
                end;
                sColAddr1  := Trim(lstTemp[3]); //TConAddr#
                sColValue1 := Trim(lstTemp[4]); //OnValue#
                sColValue2 := Trim(lstTemp[5]); //OffValue#
                if (sColAddr1 = '') or (sColValue1 = '') or (sColValue2 = '') then begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: TConParam,PucOnOff,Write: invalid TConAddr(%s), OnValue(%s) or OffValue(%s)',[nLine,sColAddr1,sColValue1,sColValue2]);
                  Exit;
								end;
                TConParam.PocbOnOff[0].nTConAddr := StrToIntDef(StringReplace(sColAddr1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);  //Off
                TConParam.PocbOnOff[0].nValue    := StrToIntDef(stringreplace(sColValue2,'0x','$',[rfreplaceall,rfignorecase]),0);
                TConParam.PocbOnOff[1].nTConAddr := TConParam.PocbOnOff[0].nTConAddr;                                              //On
                TConParam.PocbOnOff[1].nValue    := StrToIntDef(stringreplace(scolValue1,'0x','$',[rfreplaceall,rfignorecase]),0);
                if (TConParam.PocbOnOff[0].nTConAddr = 0) then begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: TConParam,PucOnOff,Write: invalid TConAddr(%d)',[nLine,TConParam.PocbOnOff[0].nTConAddr]);
                  Exit;
								end;
                TConParam.PocbOnOff[0].bValue := True;
                TConParam.PocbOnOff[1].bValue := True;
CodeSite.Send(sCsvLine+'TConParam,PucOnOff,Write:'+'TConAddr='+sColAddr1+',OnVal='+sColValue1+',OffVal='+sColValue2);
{$ELSE}  //PANEL_FOLD|PANEL_GAGO
                // (FOLD|GAGO) TConParam, PucOnOff, Write, DevAddr#,  RegAddr#, OnValue#, OffValue#, Comment1,,
                if lstTemp.Count < 7 then begin
              		sErrMsg := Format('PARAM.CSV ERROR (line%2d: TConParam,PucOnOff,Write: less than the minimum column count[7]',[nLine]);
              		Exit;
                end;
                sColAddr1  := Trim(lstTemp[3]); //DevAddr#
                sColAddr2  := Trim(lstTemp[4]); //RegAddr#
                sColValue1 := Trim(lstTemp[5]); //OnValue#
                sColValue2 := Trim(lstTemp[6]); //OffValue#
                if (sColAddr1 = '') or (sColAddr2 = '') or (sColValue1 = '') or (sColValue2 = '') then begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: TConParam,PucOnOff,Write: invalid DevAddr(%s), DevAddr(%s), OnValue(%s) or OffValue(%s)',[nLine,sColAddr1,sColAddr2,sColValue1,sColValue2]);
                  Exit;
								end;
                TConParam.PocbOnOff[0].nDevAddr := StrToIntDef(StringReplace(sColAddr1,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);  //DevAddr
                TConParam.PocbOnOff[0].nRegAddr := StrToIntDef(StringReplace(sColAddr2,'0x','$',[rfReplaceAll,rfIgnoreCase]),0);  //RegAddr
                TConParam.PocbOnOff[0].nValue   := StrToIntDef(stringreplace(sColValue2,'0x','$',[rfreplaceall,rfignorecase]),0);
                TConParam.PocbOnOff[1].nDevAddr := TConParam.PocbOnOff[0].nDevAddr;                                              //On
                TConParam.PocbOnOff[1].nRegAddr := TConParam.PocbOnOff[0].nRegAddr;                                              //On
                TConParam.PocbOnOff[1].nValue   := StrToIntDef(stringreplace(scolValue1,'0x','$',[rfreplaceall,rfignorecase]),0);
                if (TConParam.PocbOnOff[0].nDevAddr = 0) or (TConParam.PocbOnOff[0].nRegAddr = 0) then begin
                  sErrMsg := Format('PARAM.CSV ERROR (line%2d: TConParam,PucOnOff,Write: invalid DevAddr(%d) RegAddr(%d)',[nLine,TConParam.PocbOnOff[0].nDevAddr,TConParam.PocbOnOff[0].nRegAddr]);
                  Exit;
								end;
                TConParam.PocbOnOff[0].bValue := True;
                TConParam.PocbOnOff[1].bValue := True;
CodeSite.Send(sCsvLine+'TConParam,PucOnOff,Write:'+'DevAddr='+sColAddr1+'RegAddr='+sColAddr2+',OnVal='+sColValue1+',OffVal='+sColValue2);
{$ENDIF}
              end
              else begin
                sErrMsg := Format('PARAM.CSV ERROR (line%2d: TConParam,PucOnOff: unknown operation[%s]',[nLine,sColType]);
                Exit;
              end;
            end
            else begin
              sErrMsg := Format('PARAM.CSV ERROR (line%2d: TConParam: unknown Item[%s]',[nLine,sColItem]);
              Exit;
            end;
          end
          else begin
            sErrMsg := Format('PARAM.CSV ERROR (line%2d: TConParam: unknown Group[%s]',[nLine,sColGroup]);
            Exit;
          end;
        finally
          //
        end;
      end;
      Result := True;
    finally
      CloseFile(txtF);
      lstTemp.Free;
			//
			if (not Result) and (sErrMsg <> '') then begin
        CodeSite.Send(sErrMsg);
				MessageDlg(fn+#13+#10+#13+#10+sErrMsg, mtError, [mbOk], 0);
			end;
    end;
  end;

	//-----------------------------------------------------------------------------
  end; // with ModeInfo2Buf
	//-----------------------------------------------------------------------------
end;

{$IFDEF SUPPORT_1CG2PANEL}
function TCommon.GetAssyModelInfo(sModelName: string; var AssyModelInfo: TAssyModelInfo): Boolean; //TBD:REMOTE_UPDATE:MoveFromModelSelectToCommon?
var
  fileName : String;
  modelF   : TIniFile;
  sTemp : string;
begin
  Result := False;

  fileName := Path.MODEL + sModelName + '.mcf';
  modelF := TIniFile.Create(fileName);
  if modelF = nil then begin
    ShowMessage('Model File('+fileName+') Open Failed !!!');
    Exit;
  end;

  try
    with modelF do begin
      try
        AssyModelInfo.UseCh1        := ReadBool('ASSY_POCB_DATA', 'AssyPocbUseCh1', False);
        AssyModelInfo.LcmPosCh1     := enumLcmPosition(ReadInteger('ASSY_POCB_DATA', 'AssyPocbLcmPosCh1', 0));
        AssyModelInfo.UseMainPidCh1 := ReadBool('ASSY_POCB_DATA', 'UseMainPidCh1', False);

        AssyModelInfo.UseCh2        := ReadBool('ASSY_POCB_DATA', 'AssyPocbUseCh2', False);
        AssyModelInfo.LcmPosCh2     := enumLcmPosition(ReadInteger('ASSY_POCB_DATA', 'AssyPocbLcmPosCh2', 0));
        AssyModelInfo.UseMainPidCh2 := ReadBool('ASSY_POCB_DATA', 'UseMainPidCh2', False);
        Result := True;
      except
        ShowMessage('Assy Model Info Failed : Model Info File('+fileName+') !!!');
      end;
    end;
  finally
    modelF.Free;
  end;
end;

function TCommon.CheckAssyPocbModelSelect(sModelNameCh1, sModelNameCh2: string): Boolean; //TBD:REMOTE_UPDATE:MoveFromModelSelectToCommon?
var
  AssyModelInfoCh1, AssyModelInfoCh2: TAssyModelInfo;
  bSameModel : Boolean;
begin
  Result := False;

  if CompareStr(sModelNameCh1,sModelNameCh2) = 0 then bSameModel := True
  else                                                bSameModel := False;

  if not GetAssyModelInfo(sModelNameCh1,{var}AssyModelInfoCh1) then Exit;
  if not GetAssyModelInfo(sModelNameCh2,{var}AssyModelInfoCh2) then Exit;

  // Check CH1
  if not AssyModelInfoCh1.UseCh1 then begin
    ShowMessage('Check CH1/CH2 Model Info : CH1/CH2 Useage !!!'+#13#10+#13#10+'Kiểm tra CH1/CH2 Thông tin mô hình: CH1/CH2 Sử dụng !!!');
    Exit;
  end
  else if ((not bSameModel) and AssyModelInfoCh1.UseCh2) then begin
    ShowMessage('Check CH1/CH2 Model Info : CH1/CH2 Useage !!!'+#13#10+#13#10+'Kiểm tra CH1/CH2 Thông tin mô hình: CH1/CH2 Sử dụng !!!');
    Exit;
  end;
  if (AssyModelInfoCh1.LcmPosCh1 <> LcmPosLeft) and (AssyModelInfoCh1.LcmPosCh1 <> LcmPosCenter) then begin
    ShowMessage('Check CH1 Model Info : LCM Position !!!'+#13#10+#13#10+'Kiểm tra CH1 Thông tin mô hình: LCM Vị trí');
    Exit;
  end;

  // Check CH2
  if not AssyModelInfoCh2.UseCh2 then begin
    ShowMessage('Check CH1/CH2 Model Info : CH1/CH2 Useage !!!'+#13#10+#13#10+'Kiểm tra CH1/CH2 Thông tin mô hình: CH1/CH2 Sử dụng !!!');
    Exit;
  end
  else if ((not bSameModel) and AssyModelInfoCh2.UseCh1) then begin
    ShowMessage('Check CH1/CH2 Model Info : CH1/CH2 Useage !!!'+#13#10+#13#10+'Kiểm tra CH1/CH2 Thông tin mô hình: CH1/CH2 Sử dụng !!!');
    Exit;
  end;
  if (AssyModelInfoCh2.LcmPosCh2 <> LcmPosCenter) and (AssyModelInfoCh2.LcmPosCh2 <> LcmPosRight) then begin
    ShowMessage('Check CH2 Model Info : LCM Position !!!'+#13#10+#13#10+'Kiểm tra CH2 Thông tin mô hình: LCM Vị trí');
    Exit;
  end;

  // check if (CH1=Center) and (CH2=Center)
  if (AssyModelInfoCh1.LcmPosCh1 = LcmPosCenter) and (AssyModelInfoCh2.LcmPosCh2 = LcmPosCenter) then begin
    ShowMessage('Check CH1/CH2 Model Info : Both Model has Center LCM Position !!!'+#13#10+#13#10+'Kiểm tra CH1/CH2 Thông tin mô hình: Cả hai Mô hình đều có Vị trí LCM Trung tâm !!!');
    Exit;
  end;

  // check if (CH1=Center) and (CH2=Center)
  if (AssyModelInfoCh1.LcmPosCh1 = LcmPosCenter) and (AssyModelInfoCh2.LcmPosCh2 = LcmPosCenter) then begin
    ShowMessage('Check CH1/CH2 Model Info : Both Model has Center LCM Position !!!'+#13#10+#13#10+'Kiểm tra CH1/CH2 Thông tin mô hình: Cả hai Mô hình đều có Vị trí LCM Trung tâm !!!');
    Exit;
  end;

  // check if (CH1=Center) and (CH2=Center)
  if (AssyModelInfoCh1.UseMainPidCh1 and AssyModelInfoCh2.UseMainPidCh2)
     or ((not AssyModelInfoCh1.UseMainPidCh1) and (not AssyModelInfoCh2.UseMainPidCh2)) then begin
    ShowMessage('Check CH1/CH2 Model Info : One of CH1 or CH2 must be Main PID !!!'+#13#10+#13#10+'Một trong các CH1 hoặc CH2 phải là PID chính !!!');
    Exit;
  end;

  Result := True;
end;
{$ENDIF} //SUPPORT_1CG2PANEL

{$IFDEF USE_FPC_LIMIT}
procedure TCommon.LoadFpcUsageValue;  //2019-04-11
var
  nJig : Integer;
  sFilePath : String;
  fpcF : TIniFile;
begin
  for nJig := DefPocb.JIG_A to DefPocb.JIG_B do begin
    sFilePath := Path.INI + 'FPC_Usage_CH' +IntToStr(nJig+1)+'.ini';  // e.g., FPC_Usage_CH1.ini
    fpcF := TIniFile.Create(sFilePath);
    try
      with fpcF do begin
        try
          m_nFpcUsageValue[nJig] := ReadInteger('FPC_USAGE', 'FPC_USAGE_CNT',0);
        except
          ShowMessage(sFilePath + ' structure is different,'+#13#10+' Make again.');
        end;
      end;
    finally
      fpcF.Free;
      fpcF := nil;
    end;
  end;
end;

procedure TCommon.SaveFpcUsageValue(nJig: Integer);
var
  sFilePath : String;
  fpcF : TIniFile;
begin
  sFilePath := Path.INI + 'FPC_Usage_CH' +IntToStr(nJig+1)+'.ini';  // e.g., FPC_Usage_CH1.ini
  fpcF := TIniFile.Create(sFilePath);
  with fpcF do begin
    try
      WriteInteger('FPC_USAGE', 'FPC_USAGE_CNT', Common.m_nFpcUsageValue[nJig]);
    except
    end;
  end;
  fpcF.Free;
  WritePrivateProfileString(nil, nil, nil, PChar(sFilePath));
end;
{$ENDIF}

//##############################################################################
//##############################################################################

procedure TCommon.AddSerialNoMatch(sSerialNumber: string);
var
  i: Integer;
  bMatched : Boolean;
begin
  if not SystemInfo.UseSeialMatch then Exit;
  LoadSerialMatch;

  bMatched := False;
  for i := 0 to Pred(m_slSerialNo.Count) do begin
    if m_slSerialNo[i] = sSerialNumber then begin
      bMatched := True;
      Break;
    end;
  end;
  // List에 해당 Serial No가 없으면
  if not bMatched then begin
    m_slSerialNo.Add(sSerialNumber);
    if SystemInfo.PrevSerial < m_slSerialNo.Count then begin
      m_slSerialNo.Delete(0);
    end;
    SaveSerialMatch;
  end;
end;
//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.BmpGetKeyValueList(section: String): TStringList
//    Called-by: TfrmFileTrans.cboResolutionChange(Sender: TObject);
//    Called-by: TfrmPatternEdit.cboResolutionChange(Sender: TObject);
//
function TCommon.BmpGetKeyValueList(section: String): TStringList;
var
  iniF : TIniFile;
  image_fn : String;
  dList : TStringList;
  Rslt      : Integer;
  sr : TSearchrec;
begin
  dList := TStringList.Create;
  if section = 'ALL' then begin
    image_fn := PATH.BMP + '*.bmp';
    Rslt := FindFirst(image_fn, faAnyFile, sr);
    while Rslt = 0 do begin
      if Length(sr.Name) > 4 then dList.Add(sr.Name);
      Rslt := FindNext(sr);
    end;
  end
  else begin
    image_fn := PATH.BMP + 'image.lst';
    iniF := TIniFile.Create(image_fn);
    try
      iniF.ReadSections(dList);
      iniF.ReadSection(section, dList);
    finally
      iniF.Free;
    end;
  end;

  Result := dList;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.BmpGetSectionList: TStringList;
//      Called-by: procedure TfrmFileTrans.FormCreate(Sender: TObject);
//      Called-by: procedure TfrmPatternEdit.FormCreate(Sender: TObject);
//
function TCommon.BmpGetSectionList: TStringList;
var
  iniF : TIniFile;
  image_fn : String;
  dList : TStringList;
begin
  image_fn := Path.BMP + 'image.lst';

  dList := TStringList.Create;
  iniF := TIniFile.Create(image_fn);
  try
    iniF.ReadSections(dList);
    dList.Insert(0, 'ALL');
  finally
    iniF.Free;
  end;

  Result := dList;
end;

//
procedure TCommon.CalcCheckSum(p: pointer; byteCount: dword; var SumValue: dword);
var
  i: dword;
  q: ^byte;
begin
  q := p;
  for i  := 0 to byteCount-1 do begin
    inc(SumValue, q^);
    inc(q);
  end;
end;

function TCommon.CheckMakeDir(sPath: string; bForceDirectories: Boolean = False): Boolean;
var
  bRtn : Boolean;
begin
  // Check & Make the Directory
  bRtn := System.SysUtils.DirectoryExists(sPath);
  if not bRtn then begin
    if bForceDirectories then bRtn := System.SysUtils.ForceDirectories(sPath)
    else                      bRtn := System.SysUtils.CreateDir(sPath);
    if not bRtn then begin
      MessageDlg(#13#10 + 'Cannot make the Path('+sPath+')!!!', mtError, [mbOk], 0);
    end;
  end;
  Result := bRtn;
end;

function TCommon.CheckSerialMatch(sSerialNumber: string): Boolean;
var
  i: Integer;
  bMatched : Boolean;
begin
  if not SystemInfo.UseSeialMatch then Exit(False);

  LoadSerialMatch;

  bMatched := False;
  for i := 0 to Pred(m_slSerialNo.Count) do begin
    if m_slSerialNo[i] = sSerialNumber then begin
      bMatched := True;
      Break;
    end;
  end;
  Result := bMatched;
end;

procedure TCommon.CopyDirectoryAll(pSourceDir, pDestinationDir: string; pOverWrite: Boolean);
var
  TempList : TSearchRec;
  bFailIfExists : Boolean;
begin
  if m_bStopWork then Exit;
  if FindFirst(pSourceDir + '\*', faAnyFile, TempList) = 0 then begin
    if not DirectoryExists(pDestinationDir) then ForceDirectories(pDestinationDir);
    repeat
      if m_bStopWork then Break;
      if ((TempList.attr and faDirectory) = faDirectory)
          and not (TempList.Name = '.')
          and not (TempList.Name = '..')
          and not (SameText(TempList.Name,'LOG')
          and not (SameText(TempList.Name,'Backup'))
          and not (SameText(TempList.Name,'Old'))) then
      begin
        if DirectoryExists(pSourceDir + '\' + TempList.Name) then begin
           CopyDirectoryAll(pSourceDir + '\' + TempList.Name, pDestinationDir + '\' + TempList.Name, pOverWrite);
        end;
      end
      else begin
        if FileExists(pSourceDir + '\' + TempList.Name) then begin
           if pOverWrite then bFailIfExists := False else  bFailIfExists := True;
           CopyFile(pChar(pSourceDir + '\' + TempList.Name), pChar(pDestinationDir + '\' + TempList.Name), bFailIfExists);
        end;
       end;
    until FindNext(TempList) <> 0;
    FindClose(TempList);
  end;
end;

function TCommon.crc16(pData: PAnsiChar; len: integer): word;
const
  CRC16POLY = $8408;
var
  i           : byte;
  nCount      : integer;
  wData, wCrc : word;//smallint;
  btaBuff     : array of byte;
begin
  wCrc  := $ffff;
  wData := 0;
  try
    SetLength(btaBuff,len);
    CopyMemory(@btaBuff[0],pData,len);
    nCount := 0;
    if not (len > 0) then begin
      result := not wCrc;
      Exit;
    end;
    repeat
      wData := $ff and btaBuff[nCount];
      for i:=0 to 7 do begin
        if ( (wCrc and $0001) Xor ( wData and $0001)) > 0 then wCrc  := word(wCrc shr 1) Xor CRC16POLY
        else                                                   wCrc  := word(wCrc shr 1);
        wData := word(wData shr 1);
      end;
      wData := word(wData shr 1);
      dec(len);
      inc(nCount);
    until len <= 0 ;

    wCrc  := not wCrc;
    wData := wCrc;
    wCrc  := word(wCrc shl 8) or (Word( wData shr 8 ) and $ff);
  finally
//    SetLength(btaBuff,0);
//    btaBuff := nil;
    result := wCrc;
  end;
end;

function TCommon.crc16(Str: AnsiString; len: Integer): Word;
const
  CRC16POLY = $8408;
var
  i, loop_len, cnt: Integer;
  crc, data: Longword;
begin
  crc := $FFFF;
  loop_len := len;
  cnt := 1;

  if len = 0 then begin
    crc16 := not crc;
    exit;
  end;

  while loop_len > 0 do begin
    data := $FF and Byte(Str[cnt]);
    Dec(loop_len);
    inc(cnt);
    for i := 1 to 8 do begin
      if ((crc and $1) xor (data and $1)) = 1 then crc := (crc shr 1) xor CRC16POLY
      else crc := crc shr 1;
      data := data shr 1;
    end;
  end;
  crc := not crc;
  data := crc;
  crc := (crc shl 8) or (data shr 8 and $FF);

  crc16 := Word(crc);  //2021-05
end;

function TCommon.crc16(sFileName : string): word;
var
  slFile : TStringList;
  sData : AnsiString;
  i     : Integer;
begin
  slFile := TStringList.Create;
  try
    slFile.LoadFromFile(sFileName);

    sData := '';
    for i := 0 to Pred(slFile.Count) do begin
      sData := sData + AnsiString( slFile.Strings[i]);
    end;

    Result := crc16(sData,Length(sData));
  finally
    slFile.Free;
  end;
end;

function TCommon.GetModelMcfCrc(nCh: Integer): string; //2022-09-15 (GetModelCrc -> GetModelMcfCrc)
var
  sFullName : string;
begin
  sFullName := Path.MODEL + SystemInfo.TestModel[nCh] + '.mcf';
  Result := Format('%0.4x',[crc16(sFullName)]);
end;

function TCommon.GetModelParamCsvCrc(nCh: Integer): string;  //2022-09-15
var
  sFullName : string;
begin
  Result := '';
  {$IFDEF USE_MODEL_PARAM_CSV}
  sFullName := Path.MODEL + SystemInfo.TestModel[nCh] + '_param.csv'; //TBD?
  Result := Format('%0.4x',[crc16(sFullName)]);
  {$ENDIF}
end;

procedure TCommon.DebugMessage(const str: String);
begin
  OutputDebugString(PChar(str));
end;

function TCommon.Decrypt(const S: String; Key: Word): String;
var
  i: byte;
  FirstResult : String;
begin
  FirstResult := HexToValue(S);
  SetLength( Result, Length(FirstResult) );
  for i := 1 to Length(FirstResult) do  begin
    Result[i] := char(byte(FirstResult[i]) xor (Key shr 8));
    Key := (byte(FirstResult[i]) + Key) * DefPocb.PASSWORD_KEY_C1 + DefPocb.PASSWORD_KEY_C2;
  end;
end;

function TCommon.DecToOct(nGetVal: Integer): string;
var
  sOct : string;
  nRest, nValue : Integer;
begin
  sOct := '';
  nValue := nGetVal;
  while nValue > 0 do begin
    nRest := nValue mod 8;
    nValue := nValue div 8;
    sOct := Format('%d',[nRest]) + sOct;
  end;
  if sOct = '' then sOct := '0';

  Result := sOct;
end;

procedure TCommon.DelateBmpRawFile;
var
  image_fn : String;
  Rslt      : Integer;
  sr : TSearchrec;
begin
  image_fn := Path.BMP + '*.raw';
  Rslt := FindFirst(image_fn, faAnyFile, sr);
  while Rslt = 0 do begin
    DeleteFile(Path.BMP + sr.Name);
    Rslt := FindNext(sr);
  end;
  FindClose(sr);
end;

procedure TCommon.Delay(msec: Cardinal);
var
  FirstTickCount: Cardinal;
  LastTickCount : Cardinal;
begin
  if msec <= 0 then Exit;
  FirstTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
    Sleep(1);
    LastTickCount := GetTickCount;
  until ((LastTickCount-FirstTickCount) >= msec);
end;

function TCommon.Encrypt(const S: String; Key: Word): String;
var
  i: byte;
  FirstResult : String;
begin
  SetLength(FirstResult, Length(S));
  for i := 1 to Length(S) do begin
    FirstResult[i] := char(byte(S[i]) xor (Key shr 8));
    Key := word((byte(FirstResult[i]) + Key) * DefPocb.PASSWORD_KEY_C1 + DefPocb.PASSWORD_KEY_C2);
  end;
  Result := ValueToHex(FirstResult);
end;

{$IFDEF PANEL_AUTO}
function TCommon.GetTCon2DevRegAddr(nTConAddr: Integer; var nDevAddr, nRegAddr: Integer): Boolean; //2022-07-15 UNIFORMITY_PUCONOFF
begin
//if Common.TestModelInfo2[FChNo].TConAccessParam.Addr2DevRegConvMethod = '1' then begin
//else
    if ((nTConAddr >= 0) and (nTConAddr <= 2047)) then begin
       nDevAddr  := $B0 + ((nTConAddr shr 8) shl 1);  // I2C_DEVICE_TCON (RegAddr<2048)
       nRegAddr  := nTConAddr - ((nTConAddr shr 8) shl 8);
    end
    else begin
       nTConAddr := nTConAddr - 2048;
       nDevAddr  := $C0 + ((nTConAddr shr 8) shl 1);  // I2C_DEVICE_TCON(RegAddr>=2048)
       nRegAddr  := nTConAddr - ((nTConAddr shr 8) shl 8);
    end;
//end;
  Result := True;
end;
{$ENDIF}

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.GetDrawPosPG(sPos: string): word
//      Sub-methods:
//          function GetToken(st: String) : Integer;
//          function Left_Position: Integer;
//          function Right_Position(iLeft: Integer) : Integer;
//          procedure Process_Calculator;
//      Called-by: procedure TCommon.MakePatternData(nIdx : Integer;makePatGrp : TPatternGroup; var dCheckSum: dword; var nTotalSize: Integer; var Data: TArray<System.Byte>);
//      Called-by: procedure TDongaPG.SendPatDisplayReq(nCmdType, nPatNum: Integer; nBmpCompensate : Byte = 0);
//
function TCommon.GetDrawPosPG(nCh: Integer; sPos: string): word;  //A2CHv3:MULTIPLE_MODEL
var
  totval: double;
	//internal var
	iTag, iToken, iLeft, iRight : Integer;
	aToken: array[1..100] of String;
  op_str : string;

	function GetToken(st: String) : Integer;
	var
		i: Integer;
		s: String;
	begin
		Result := 0; iTag := 0; s := '';
		st := Trim(st) + '+';
		for i:= 1 to Length(st) do begin
			inc(iTag);
			aToken[iTag] := Copy(st, i, 1);
		end;
		for i:= 1 to iTag do begin
			if (aToken[i] = '(') or (aToken[i] = ')') or
				(aToken[i] = '*') or (aToken[i] = '/') or
				(aToken[i] = '+') or (aToken[i] = '-') then begin
        if s <> '' then begin
          aToken[i-1] := s;
          s:= '';
				end;
      end
      else begin
        s := s + aToken[i];
        aToken[i] := '';
      end;
		end; //for...
		for i := 1 to iTag-1 do begin
			if aToken[i] <> '' then begin
				inc(Result);
				aToken[Result] := aToken[i];
			end;
    end;
	end; //function

	function Left_Position: Integer;
	var
    i: Integer;
	begin
		Result := 0;
		for i := 1 to iToken do
			if (aToken[i] = '(') then Result := i;
	end;

	function Right_Position(iLeft: Integer) : Integer;
	var
    i: Integer;
	begin
		Result := 0;
		for i := 1 + iLeft to iToken do
			if (aToken[i] = ')') then begin
				Result := i;
				Break;
			end;
	end;

	procedure Process_Calculator;
	var
		isDataExist: Boolean;
		sTemp: String;
		i,j, iMin, iMax: Integer;
	begin
		iLeft := Left_Position;
		iRight := Right_Position(iLeft);
		if iToken = 1 then Exit;
		if (iRight - iLeft) = 2 then begin
			aToken[iLeft] := ' ';
			aToken[iRight] := ' ';
			sTemp := '';
			for i := 1 to iToken do sTemp := sTemp + aToken[i];
			iToken := GetToken(sTemp);
			Exit;
		end;
		if iLeft = 0 then begin
			iMin := 1;
			iMax := iToken;
		end
		else begin
			iMin := iLeft + 1;
			iMax := iRight - 1;
		end;
		isDataExist := True;
		for i := iMin to iMax do begin
			if (aToken[i] = '*') or (aToken[i] = '/') then begin
				if aToken[i] = '*' then
					aToken[i] := FloatToStr(StrToFloat(aToken[i-1]) * StrToFloat(aToken[i+1]))
				else if aToken[i] = '/' then
					aToken[i] := FloatToStr(StrToFloat(aToken[i-1]) / StrToFloat(aToken[i+1]));
				aToken[i-1] := ' ';
				aToken[i+1] := ' ';
				sTemp := '';
				for j := 1 to iToken do sTemp := sTemp + aToken[j];
				iToken := GetToken(sTemp);
				isDataExist := False;
				Break;
			end;
		end;
		if not isDataExist then Exit;
		for i := iMin to iMax do begin
			if (aToken[i] = '+') OR (aToken[i] = '-') then begin
				if aToken[i] = '+' then
					aToken[i] := FloatToStr(StrToFloat(aToken[i-1]) + StrToFloat(aToken[i+1]))
				else
					aToken[i] := FloatToStr(StrToFloat(aToken[i-1]) - StrToFloat(aToken[i+1]));
				aToken[i-1] := ' ';
				aToken[i+1] := ' ';
				sTemp := '';
				for j := 1 to iToken do sTemp := sTemp + aToken[j];
				iToken := GetToken(sTemp);
				Break;
			end;
		end;
	end; //fuinction...
begin
	Result := 0;
	if length(sPos) = 0 then Exit;

	op_str := StringReplace(sPos, ' ', '', [rfReplaceAll]);

	op_str := StringReplace(op_str, 'H', IntToStr(actual_resolution[nCh].nH), [rfReplaceAll]);
	op_str := StringReplace(op_str, 'V', IntToStr(actual_resolution[nCh].nV), [rfReplaceAll]);


	iToken := GetToken(op_str);
	Repeat
		Process_Calculator;
	until iToken = 1;
	totval := StrToFloat(aToken[1]);
	Result := Trunc(totval);
end;

function TCommon.GetFilePath(FName: String; Path: Integer): String;
begin
  case Path of
    PATH_TYPE_MODEL       : Result := Self.Path.MODEL + FName + '.mcf';
    PATH_TYPE_MODEL_PARAM : Result := Self.Path.MODEL + FName + '_param.csv'; //2022-07-30
    PATH_TYPE_PATTERN     : Result := Self.Path.PATTERN + FName + '.pat';
    PATH_TYPE_PATGRP      : Result := Self.Path.PATTERNGROUP + FName + '.grp';
    PATH_TYPE_SCRIPT      : Result := Self.Path.MODEL+ FName + '.script';
  else
    Result := FName;
  end;
end;

{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
function TCommon.GetPidFromBcr(sBcr: String): String;
var
  sList : TStringList;
  sPid : String;
begin
  try
    sPid := '';
    sList := TStringList.Create;
    try
      ExtractStrings(['-'],[],PWideChar(sBcr),sList);
      sPid := sList[0];
    except
    end;
  finally
    sList.Free;
  end;
  Result := sPid;
end;
{$ENDIF}

function TCommon.GetExeVerNameLog: String;
begin
  Result := GetExeVerNameSummary + ' ('
           + FormatDateTime('yyyy.mm.dd hh:nn', FileDateToDateTime(FileAge(Application.ExeName))) + ')';
end;

function TCommon.GetExeVerNameSummary: String; //2019-05-02 SUMMARY
var
  sExeNameWithExt : string;
  sList : TStringList;
begin
  Result := '';
  sExeNameWithExt := ExtractFileName(Application.ExeName);
  sList := TStringList.Create;
  try
    ExtractStrings(['.'],[],PWideChar(sExeNameWithExt),sList);
    Result := sList[0];
  finally
    sList.Free;
    sList := nil;
  end;
  if Result = '' then begin
    Result := Application.ExeName;
  end;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.HexToValue(const S: String): String
//      Called-by: function TCommon.Decrypt(const S: String; Key: Word): String;
//
function TCommon.HexToValue(const S: String): String;
var
	i : Integer;
	sTemp : string;
begin
	SetLength(sTemp, Length(S) div 2);
	for i := 0 to (Length(S) div 2) - 1 do begin
		sTemp[i+1] := Char(StrToIntDef('$'+Copy(S,(i*2)+1, 2),0));
	end;
	Result := sTemp ;
end;


//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.IsfStrToTime(sTime: string): Integer
//      Called-by: none
//
function TCommon.IsfStrToTime(sTime: string): Integer;
var
  sTemp, sSub : string;
  nHour, nMin, nSec, nPos : Integer;
begin
//  sTemp := StringReplace(sTime,':', ':', [rfReplaceAll]);

  nPos := Pos(':',sTime);
  sTemp := Copy(sTime,1,nPos-1);
  sSub  := Copy(sTime,nPos+1, Length(sTime) - nPos);
  nHour := StrToIntDef(sTemp, 0)*60*60;

  nPos := Pos(':',sSub);
  sTemp := Copy(sSub,1,nPos-1);
  sSub  := Copy(sSub,nPos+1, Length(sSub) - nPos);
  nMin := StrToIntDef(sTemp, 0)*60;
  nSec := StrToIntDef(sSub, 0);

  Result := nHour + nMin + nSec;
end;

function TCommon.SetTimeToStr(nTime: Int64): string;
var
  nSec, nMin, nHour, nTemp : Integer;
  sTime : string;
begin
  nSec  := nTime mod 60;
  nTemp := nTime div 60; 
  nMin  := nTemp   mod 60;  //
  nHour := nTemp   div 60;  //
  sTime := Format('%0.2d:%0.2d:%0.2d',[nHour, nMin, nSec]);
//  if nTime = (nSecond)  then sRealAging := Format('%0.2d_%0.2d_%0.2d',[nHour, nMin, nSec]);
  Result := sTime;
end;

procedure TCommon.SleepMicro(nSec: Int64);
var
  mctStartTime,mctEndTime, mctFreq  : TLargeInteger;
  dDiff : Single;
begin
  if QueryPerformanceFrequency(mctFreq) then begin
    QueryPerformanceCounter(mctStartTime);
    repeat
      QueryPerformanceCounter(mctEndTime);
      // *1000 ==> 1 mili seconds.
      // *1000*1000 ==> 1 micro Seconds
      dDiff := ((mctEndTime - mctStartTime) / mctFreq)*1000*1000;
    until dDiff > nSec;
  end;
end;

procedure TCommon.TaskBar(bHide: Boolean);
var
  TaskHandle: THandle;
  AppBarData : TAppBarData;
begin
  // Get taskbar handle
  TaskHandle:=FindWindow('Shell_TrayWnd',nil);

  appBarData.cbSize := sizeof(appBarData);
  appBarData.hWnd   := TaskHandle;
  if bHide then begin
    appBarData.lParam := ABS_AUTOHIDE;
  end
  else begin
    appBarData.lParam := ABS_ALWAYSONTOP;
  end;
  SHAppBarMessage(ABM_SETSTATE,appBarData);
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] procedure TCommon.LoadCheckSumNData(sFileName: string; var dCheckSum: dword; var TotalSize: Integer; var Data: TArray<System.Byte>)
//      Called-by: procedure TfrmFileTrans.btnDownloadClick(Sender: TObject);
//      Called-by: procedure TfrmModelDownload.FormCreate(Sender: TObject);
//
procedure TCommon.LoadCheckSumNData(sFileName: string; var dCheckSum: dword; var TotalSize: Integer; var Data: TArray<System.Byte>);
var
  Stream: TMemoryStream;
  dGetCheckSum : dword;
begin
  Stream := TMemoryStream.Create;
  try
    try
      dCheckSum := 0;
      TotalSize := 0;
      dGetCheckSum := 0;
      if not FileExists(sFileName) then begin
        Exit;
      end;

      Stream.LoadFromFile(sFileName);
      if Stream.Size > 0 then begin
        CalcCheckSum(Stream.Memory, Stream.Size, dGetCheckSum);
      end;

      dCheckSum := dGetCheckSum;
      TotalSize := Stream.Size;
      SetLength(Data,TotalSize);
      CopyMemory(@Data[0],Stream.Memory,TotalSize);
    except {...} end;
  finally
    Stream.Free;
  //Stream := nil;
  end;
end;

function TCommon.LoadPatGroup(SelPatGroupName : string) : TPatternGroup;
var
  PatGrpFile : TIniFile;
  i          : Integer;
  {sPatName,} sPatGrpFileName : string;
  TempPatGrp : TPatternGroup;
begin
  sPatGrpFileName := Path.PATTERNGROUP + SelPatGroupName + '.grp';

  if FileExists(sPatGrpFileName) then begin
	  PatGrpFile := TIniFile.Create(sPatGrpFileName);
    try
      // Read data using Count vaule
      TempPatGrp.GroupName  := SelPatGroupName;
      TempPatGrp.PatCount   := PatGrpFile.ReadInteger('PatternData', 'pattern_count', 0);
      if TempPatGrp.PatCount > 0 then begin
        SetLength(TempPatGrp.PatType,TempPatGrp.PatCount);
        SetLength(TempPatGrp.PatName,TempPatGrp.PatCount);
        SetLength(TempPatGrp.VSync,TempPatGrp.PatCount);
        SetLength(TempPatGrp.LockTime,TempPatGrp.PatCount);
      //SetLength(TempPatGrp.Dimming,TempPatGrp.PatCount); //TBD:PATTERN_PWM
        SetLength(TempPatGrp.Option,TempPatGrp.PatCount);
        for i := 0 to Pred(TempPatGrp.PatCount) do begin
          TempPatGrp.PatType[i]  := PatGrpFile.ReadInteger('PatternData', Format('PatType%d',[i]), 0);
          TempPatGrp.PatName[i]  := PatGrpFile.ReadString ('PatternData', Format('PatName%d',[i]), '');
          TempPatGrp.VSync[i]    := PatGrpFile.ReadInteger('PatternData', Format('VSync%d',[i]), 0);
          TempPatGrp.LockTime[i] := PatGrpFile.ReadInteger('PatternData', Format('LockTime%d',[i]), 0);
        //TempPatGrp.Dimming[i]  := PatGrpFile.ReadInteger('PatternData', Format('Dimming%d',[i]), 100); //TBD:PATTERN_PWM
          TempPatGrp.Option[i]   := PatGrpFile.ReadInteger('PatternData', Format('Option%d',[i]), 0);
        end;
      end;

      {        WriteInteger('PATTERNDATA','PatType'+inttostr(j), PatType[j]);
        WriteString('PATTERNDATA','PatName'+inttostr(j), PatName[j]);}
    finally
      PatGrpFile.Free;
    end;
  end
  else begin // init if Pattern Group File does not exist
    TempPatGrp.GroupName := '';
    TempPatGrp.PatCount := 0;
  end;
  Result := TempPatGrp;
end;

procedure TCommon.GetMotionAlarmNo(nMotionID: Integer; var MotionAlarmNo: TMotionAlarmNo);
begin
  case nMotionID of
    DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
      MotionAlarmNo.DISCONNECTED       := DefPocb.ALARM_CH1_MOTION_Y_DISCONNECTED;
      MotionAlarmNo.SIG_ALARM_ON       := DefPocb.ALARM_CH1_MOTION_Y_SIG_ALARM_ON;
      MotionAlarmNo.INVALID_UNITPULSE  := DefPocb.ALARM_CH1_MOTION_Y_INVALID_UNITPULSE;
      MotionAlarmNo.NEED_HOME_SEARCH   := DefPocb.ALARM_CH1_MOTION_Y_NEED_HOME_SEARCH;
      MotionAlarmNo.MODEL_POS_NG       := DefPocb.ALARM_CH1_MOTION_Y_MODEL_POS_NG;
    end;
    DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
      MotionAlarmNo.DISCONNECTED       := DefPocb.ALARM_CH2_MOTION_Y_DISCONNECTED;
      MotionAlarmNo.SIG_ALARM_ON       := DefPocb.ALARM_CH2_MOTION_Y_SIG_ALARM_ON;
      MotionAlarmNo.INVALID_UNITPULSE  := DefPocb.ALARM_CH2_MOTION_Y_INVALID_UNITPULSE;
      MotionAlarmNo.NEED_HOME_SEARCH   := DefPocb.ALARM_CH2_MOTION_Y_NEED_HOME_SEARCH;
      MotionAlarmNo.MODEL_POS_NG       := DefPocb.ALARM_CH2_MOTION_Y_MODEL_POS_NG;
    end;
		{$IFDEF HAS_MOTION_CAM_Z}
    DefMotion.MOTIONID_AxMC_STAGE1_Z: begin
      MotionAlarmNo.DISCONNECTED       := DefPocb.ALARM_CH1_MOTION_Z_DISCONNECTED;
      MotionAlarmNo.SIG_ALARM_ON       := DefPocb.ALARM_CH1_MOTION_Z_SIG_ALARM_ON;
      MotionAlarmNo.INVALID_UNITPULSE  := DefPocb.ALARM_CH1_MOTION_Z_INVALID_UNITPULSE;
      MotionAlarmNo.NEED_HOME_SEARCH   := DefPocb.ALARM_CH1_MOTION_Z_NEED_HOME_SEARCH;
      MotionAlarmNo.MODEL_POS_NG       := DefPocb.ALARM_CH1_MOTION_Z_MODEL_POS_NG;
    end;
    DefMotion.MOTIONID_AxMC_STAGE2_Z: begin
      MotionAlarmNo.DISCONNECTED       := DefPocb.ALARM_CH2_MOTION_Z_DISCONNECTED;
      MotionAlarmNo.SIG_ALARM_ON       := DefPocb.ALARM_CH2_MOTION_Z_SIG_ALARM_ON;
      MotionAlarmNo.INVALID_UNITPULSE  := DefPocb.ALARM_CH2_MOTION_Z_INVALID_UNITPULSE;
      MotionAlarmNo.NEED_HOME_SEARCH   := DefPocb.ALARM_CH2_MOTION_Z_NEED_HOME_SEARCH;
      MotionAlarmNo.MODEL_POS_NG       := DefPocb.ALARM_CH2_MOTION_Z_MODEL_POS_NG;
    end;
		{$ENDIF}
		{$IFDEF HAS_MOTION_TILTING}
    DefMotion.MOTIONID_AxMC_STAGE1_T: begin
      MotionAlarmNo.DISCONNECTED       := DefPocb.ALARM_CH1_MOTION_T_DISCONNECTED;
      MotionAlarmNo.SIG_ALARM_ON       := DefPocb.ALARM_CH1_MOTION_T_SIG_ALARM_ON;
      MotionAlarmNo.INVALID_UNITPULSE  := DefPocb.ALARM_CH1_MOTION_T_INVALID_UNITPULSE;
      MotionAlarmNo.NEED_HOME_SEARCH   := DefPocb.ALARM_CH1_MOTION_T_NEED_HOME_SEARCH;
      MotionAlarmNo.MODEL_POS_NG       := DefPocb.ALARM_CH1_MOTION_T_MODEL_POS_NG;
    end;
    DefMotion.MOTIONID_AxMC_STAGE2_T: begin
      MotionAlarmNo.DISCONNECTED       := DefPocb.ALARM_CH2_MOTION_T_DISCONNECTED;
      MotionAlarmNo.SIG_ALARM_ON       := DefPocb.ALARM_CH2_MOTION_T_SIG_ALARM_ON;
      MotionAlarmNo.INVALID_UNITPULSE  := DefPocb.ALARM_CH2_MOTION_T_INVALID_UNITPULSE;
      MotionAlarmNo.NEED_HOME_SEARCH   := DefPocb.ALARM_CH2_MOTION_T_NEED_HOME_SEARCH;
      MotionAlarmNo.MODEL_POS_NG       := DefPocb.ALARM_CH2_MOTION_T_MODEL_POS_NG;
    end;
		{$ENDIF}
  end;
end;

//------------------------------------------------------------------------------
//
{$IFDEF HAS_ROBOT_CAM_Z}
procedure TCommon.GetRobotAlarmNo(nJIG: Integer; var RobotAlarmNo: TRobotAlarmNo);  //A2CHv3:ROBOT
begin
  if nJIG = DefPocb.JIG_A then begin
    RobotAlarmNo.MODBUS_DISCONNECTED    := DefPocb.ALARM_CH1_ROBOT_MODBUS_DISCONNECTED;
    RobotAlarmNo.COMMAND_DISCONNECTED   := DefPocb.ALARM_CH1_ROBOT_COMMAND_DISCONNECTED;
    RobotAlarmNo.FATAL_ERROR            := DefPocb.ALARM_CH1_ROBOT_FATAL_ERROR;
    RobotAlarmNo.PROJECT_NOT_RUNNING    := DefPocb.ALARM_CH1_ROBOT_PROJECT_NOT_RUNNING;
    RobotAlarmNo.PROJECT_EDITING        := DefPocb.ALARM_CH1_ROBOT_PROJECT_EDITING;
    RobotAlarmNo.PROJECT_PAUSE          := DefPocb.ALARM_CH1_ROBOT_PROJECT_PAUSE;
    RobotAlarmNo.GET_NOT_CONTROL        := DefPocb.ALARM_CH1_ROBOT_GET_CONTROL;
    RobotAlarmNo.ESTOP                  := DefPocb.ALARM_CH1_ROBOT_ESTOP;
    RobotAlarmNo.CURR_COORD_NG          := DefPocb.ALARM_CH1_ROBOT_CURR_COORD_NG;
    RobotAlarmNo.NOT_AUTOMODE           := DefPocb.ALARM_CH1_ROBOT_NOT_AUTOMODE;
    RobotAlarmNo.CANNOT_MOVE            := DefPocb.ALARM_CH1_ROBOT_CANNOT_MOVE;
    RobotAlarmNo.HOME_COORD_MISMATCH    := DefPocb.ALARM_CH1_ROBOT_HOME_COORD_MISMATCH;
    RobotAlarmNo.MODEL_COORD_MISMATCH   := DefPocb.ALARM_CH1_ROBOT_MODEL_COORD_MISMATCH;
    RobotAlarmNo.STANDBY_COORD_MISMATCH := DefPocb.ALARM_CH1_ROBOT_STANDBY_COORD_MISMATCH;
  end
  else begin
    RobotAlarmNo.MODBUS_DISCONNECTED    := DefPocb.ALARM_CH2_ROBOT_MODBUS_DISCONNECTED;
    RobotAlarmNo.COMMAND_DISCONNECTED   := DefPocb.ALARM_CH2_ROBOT_COMMAND_DISCONNECTED;
    RobotAlarmNo.FATAL_ERROR            := DefPocb.ALARM_CH2_ROBOT_FATAL_ERROR;
    RobotAlarmNo.PROJECT_NOT_RUNNING    := DefPocb.ALARM_CH2_ROBOT_PROJECT_NOT_RUNNING;
    RobotAlarmNo.PROJECT_EDITING        := DefPocb.ALARM_CH2_ROBOT_PROJECT_EDITING;
    RobotAlarmNo.PROJECT_PAUSE          := DefPocb.ALARM_CH2_ROBOT_PROJECT_PAUSE;
    RobotAlarmNo.GET_NOT_CONTROL        := DefPocb.ALARM_CH2_ROBOT_GET_CONTROL;
    RobotAlarmNo.ESTOP                  := DefPocb.ALARM_CH2_ROBOT_ESTOP;
    RobotAlarmNo.CURR_COORD_NG          := DefPocb.ALARM_CH2_ROBOT_CURR_COORD_NG;
    RobotAlarmNo.NOT_AUTOMODE           := DefPocb.ALARM_CH2_ROBOT_NOT_AUTOMODE;
    RobotAlarmNo.CANNOT_MOVE            := DefPocb.ALARM_CH2_ROBOT_CANNOT_MOVE;
    RobotAlarmNo.HOME_COORD_MISMATCH    := DefPocb.ALARM_CH2_ROBOT_HOME_COORD_MISMATCH;
    RobotAlarmNo.MODEL_COORD_MISMATCH   := DefPocb.ALARM_CH2_ROBOT_MODEL_COORD_MISMATCH;
    RobotAlarmNo.STANDBY_COORD_MISMATCH := DefPocb.ALARM_CH2_ROBOT_STANDBY_COORD_MISMATCH;
  end;
end;
{$ENDIF}

procedure TCommon.MakeAlarmList;
var
  i : Integer;
  sTempDioNo : string;
begin
  //
  for i := DefPocb.JIG_A to DefPocb.JIG_MAX do
    m_bKeyTeachMode[i] := False;
  m_bAlarmOn      := False;
  m_bSafetyAlarmOn:= False;  //2019-04-17 ALARM:GUI
//m_bDioMotionAlarmOn := False;  //2019-03-29
  //
  for i := 0 to DefPocb.MAX_ALARM_NO do begin  //2019-04-03
    AlarmList[i].AlarmNo    := i;
    AlarmList[i].AlarmClass := DefPocb.ALARM_CLASS_NONE;
    AlarmList[i].AlarmName  := '';
    AlarmList[i].AlarmMSg   := '';
    AlarmList[i].AlarmMSg2  := '';   //2019-03-29
    AlarmList[i].sDioIN     := '-1'; //A2CHv3:ALARM (Integer -> String for multiple dio)
    AlarmList[i].bIsOn      := False;
    AlarmList[i].ImageFile  := '';   //2019-03-29
  end;

  //           AlarmNo, DIO-INPUT#(From 1), AlarmClass, AlarmName, 
  //    AlarmMsg, AlarmMsg2, ImageFile
  SetAlarmInfo(DefPocb.ALARM_RESERVED0, -1, DefPocb.ALARM_CLASS_NONE, 'RESERVED0','','');
{$IF Defined(POCB_A2CH)}  //----------------------------------------------------
  SetAlarmInfo(DefPocb.ALARM_DIO_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'DIO_NOT_CONNECTED', 
        'DIO Control Device Disconnected', 'Check PCI DIO Control Device on PC');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO, DefDio.IN_EMO, DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO',
        'EMO Button Pressed', 'Relase EMO button after emergecy cause action', 'POCB_EMO');
  SetAlarmInfo(DefPocb.ALARM_DIO_TEACH_MODE_SWITCH, DefDio.IN_TEACH_MODE_SWITCH, DefPocb.ALARM_CLASS_SAFETY, 'DIO_TEACH_MODE_SWITCH',
        'Left and/or Right AUTO/TEACH Key is TEACH', 'To run or motion home search, Set all AUTO/TEACH key to AUTO mode', 'POCB_LeftModeKey');
  SetAlarmInfo(DefPocb.ALARM_DIO_LIGHT_CURTAIN, DefDio.IN_LIGHT_CURTAIN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_LIGHT_CURTAIN',
        'Light Curtain Alarm Detected', '', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_DOOR_LEFT, DefDio.IN_DOOR_LEFT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_DOOR_LEFT',
        'Left Door Opened', '', 'POCB_LeftDoor');
  SetAlarmInfo(DefPocb.ALARM_DIO_DOOR_RIGHT, DefDio.IN_DOOR_RIGHT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_DOOR_RIGHT',
        'Right Door Opened', '', 'POCB_RightDoor');
  SetAlarmInfo(DefPocb.ALARM_DIO_DOOR_UNDER, DefDio.IN_DOOR_UNDER, DefPocb.ALARM_CLASS_SAFETY, 'DIO_DOOR_UNDER',
        'Under Door Opened', '', 'POCB_UnderDoor');
  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_FAN_IN, DefDio.IN_LEFT_FAN_IN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_FAN_IN',
        'Left Fan(In) Stopped', 'Close Doors and Check Left Fan(In)', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_FAN_IN, DefDio.IN_RIGHT_FAN_IN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_FAN_IN',
        'Right Fan(In) Stopped', 'Close Doors and Check Right Fan(In)', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_FAN_OUT, DefDio.IN_LEFT_FAN_OUT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_FAN_OUT',
        'Left Fan(Out) Stopped', 'Close Doors and Check Left Fan(Out)', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_FAN_OUT, DefDio.IN_RIGHT_FAN_OUT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_FAN_OUT',
        'Right Fan(Out) Stopped', 'Close Doors and Check Right Fan(Out)', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_TEMPERATURE, DefDio.IN_TEMPERATURE_ALARM, DefPocb.ALARM_CLASS_SAFETY, 'DIO_TEMPERATURE',
        'System Temperature is High', 'Stop Operation and Check System Temperature', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_POWER_HIGH, DefDio.IN_POWER_HIGH_ALARM, DefPocb.ALARM_CLASS_SAFETY, 'DIO_POWER_HIGH',
        'System Power is High', 'Stop Operation and Check System Power', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_MAIN_REGULATOR, DefDio.IN_MAIN_REGULATOR, DefPocb.ALARM_CLASS_SAFETY, 'DIO_MAIN_REGULATOR',
        'Main Regulator is Abnormal', 'Check Main Regulator', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_MC1, DefDio.IN_MC1, DefPocb.ALARM_CLASS_SAFETY, 'DIO_MC1',
        'MC1 Down by Sefty PLC (Light Curtain, Door opened at AUTO Mode)', 'Press Reset button to recover MC1/MC2', 'POCB_ResetButton');
  SetAlarmInfo(DefPocb.ALARM_DIO_MC2, DefDio.IN_MC2, DefPocb.ALARM_CLASS_SAFETY, 'DIO_MC2',
        'MC2 Down by Sefty PLC (Light Curtain, Door opened at AUTO Mode)', 'Press Reset button to recover MC1/MC2', 'POCB_ResetButton');
{$ELSEIF Defined(POCB_A2CHv2)}  //----------------------------------------------
  SetAlarmInfo(DefPocb.ALARM_DIO_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'DIO_NOT_CONNECTED',
        'DIO Control Device Disconnected', 'Check PCI DIO Control Device on PC');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO, DefDio.IN_EMO, DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO',
        'EMO Button Pressed', 'Relase EMO button after emergecy cause action', 'POCB_EMO');
  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_SWITCH, DefDio.IN_LEFT_SWITCH, DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_KEY_TEACH',
        'Left AUTO/TEACH Key is TEACH', 'To run or motion home search, set AUTO/TEACH key to AUTO mode', 'POCB_LeftModeKey');
  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_SWITCH, DefDio.IN_RIGHT_SWITCH, DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_KEY_TEACH',
        'Right AUTO/TEACH Key is TEACH', 'To run or motion home search, set AUTO/TEACH key to AUTO mode', 'POCB_RightModeKey');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_LIGHT_CURTAIN, DefDio.IN_STAGE1_LIGHT_CURTAIN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_LIGHT_CURTAIN',
        'CH1 Light Curtain Detected', '', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_LIGHT_CURTAIN, DefDio.IN_STAGE2_LIGHT_CURTAIN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_LIGHT_CURTAIN',
        'CH2 Light Curtain Detected', '', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_DOOR_LEFT, DefDio.IN_DOOR_LEFT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_DOOR_LEFT',
        'Left Door Opened', '', 'POCB_LeftDoor');
  SetAlarmInfo(DefPocb.ALARM_DIO_DOOR_RIGHT, DefDio.IN_DOOR_RIGHT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_DOOR_RIGHT',
        'Right Door Opened', '', 'POCB_RightDoor');
  SetAlarmInfo(DefPocb.ALARM_DIO_DOOR_UNDER_LEFT1, DefDio.IN_DOOR_UNDER_LEFT1, DefPocb.ALARM_CLASS_SAFETY, 'DIO_DOOR_UNDER_LEFT1',
        'Left Under Door 1 Opened', '', 'POCB_LeftUnderDoor1');
  SetAlarmInfo(DefPocb.ALARM_DIO_DOOR_UNDER_LEFT2, DefDio.IN_DOOR_UNDER_LEFT2, DefPocb.ALARM_CLASS_SAFETY, 'DIO_DOOR_UNDER_LEFT2',
        'Left Under Door 2 Opened', '', 'POCB_LeftUnderDoor2');
  SetAlarmInfo(DefPocb.ALARM_DIO_DOOR_UNDER_RIGHT1, DefDio.IN_DOOR_UNDER_RIGHT1, DefPocb.ALARM_CLASS_SAFETY, 'DIO_DOOR_UNDER_RIGHT1',
        'Right Under Door 1 Opened', '', 'POCB_RightUnderDoor1');
  SetAlarmInfo(DefPocb.ALARM_DIO_DOOR_UNDER_RIGHT2, DefDio.IN_DOOR_UNDER_RIGHT2, DefPocb.ALARM_CLASS_SAFETY, 'DIO_DOOR_UNDER_RIGHT2',
        'Right Under Door 2 Opened', '', 'POCB_RightUnderDoor2');
  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_FAN_IN, DefDio.IN_LEFT_FAN_IN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_FAN_IN',
        'Left Fan(In) Stopped', 'Close Doors and Check Left Fan(In)', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_FAN_IN, DefDio.IN_RIGHT_FAN_IN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_FAN_IN',
        'Right Fan(In) Stopped', 'Close Doors and Check Right Fan(In)', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_FAN_OUT, DefDio.IN_LEFT_FAN_OUT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_FAN_OUT',
        'Left Fan(Out) Stopped', 'Close Doors and Check Left Fan(Out)', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_FAN_OUT, DefDio.IN_RIGHT_FAN_OUT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_FAN_OUT',
        'Right Fan(Out) Stopped', 'Close Doors and Check Right Fan(Out)', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_TEMPERATURE, DefDio.IN_TEMPERATURE_ALARM, DefPocb.ALARM_CLASS_SAFETY, 'DIO_TEMPERATURE',
        'System Temperature is High', 'Stop Operation and Check System Temperature', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_POWER_HIGH, DefDio.IN_POWER_HIGH_ALARM, DefPocb.ALARM_CLASS_SAFETY, 'DIO_POWER_HIGH',
        'System Power is High', 'Stop Operation and Check System Power', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_CYLINDER_REGULATOR, DefDio.IN_CYLINDER_REGULATOR, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CYLINDER_REGULATOR',
        'Cylinder Regulator is Abnormal', 'Check Cylinder Regulator', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_VACUUM_REGULATOR, DefDio.IN_VACUUM_REGULATOR, DefPocb.ALARM_CLASS_SAFETY, 'DIO_VACUUM_REGULATOR',
        'Vacuum Regulator is Abnormal', 'Check Vacuum Regulator', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_MC1, DefDio.IN_MC1, DefPocb.ALARM_CLASS_SAFETY, 'DIO_MC1',
        'MC1 Down by Sefty PLC (Light Curtain, Door opened at AUTO Mode)', 'Press Reset button to recover MC1/MC2', 'POCB_ResetButton');
  SetAlarmInfo(DefPocb.ALARM_DIO_MC2, DefDio.IN_MC2, DefPocb.ALARM_CLASS_SAFETY, 'DIO_MC2',
        'MC2 Down by Sefty PLC (Light Curtain, Door opened at AUTO Mode)', 'Press Reset button to recover MC1/MC2', 'POCB_ResetButton');
{$ELSEIF Defined(POCB_A2CHv3)}  //----------------------
  SetAlarmInfo(DefPocb.ALARM_DIO_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'DIO_NOT_CONNECTED',
        'DIO Control Device Disconnected', 'Check PCI DIO Control Device on PC');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO1_FRONT,       DefDio.IN_EMO1_FRONT,       DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO1_FRONT',
        'EMO1_FRONT Button Pressed', 'Relase EMO1_FRONT button after emergecy cause action', 'POCBv3_Emo1Front');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO2_RIGHT,       DefDio.IN_EMO2_RIGHT,       DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO2_RIGHT',
        'EMO2_RIGHT Button Pressed', 'Relase EMO2_RIGHT button after emergecy cause action', 'POCBv3_Emo2Right');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO3_INNER_RIGHT, DefDio.IN_EMO3_INNER_RIGHT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO3_INNER_RIGHT',
        'EMO3_INNER_RIGHT Button Pressed', 'Relase EMO3_INNER_RIGHT button after emergecy cause action', 'POCBv3_Emo3InnerRight');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO4_INNER_LEFT,  DefDio.IN_EMO4_INNER_LEFT,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO4_INNER_LEFT',
        'EMO4_INNER_LEFT Button Pressed', 'Relase EMO4_INNER_LEFT button after emergecy cause action', 'POCBv3_Emo4InnerLeft');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO5_LEFT,        DefDio.IN_EMO5_LEFT,        DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO5_LEFT',
        'EMO5_LEFT Button Pressed', 'Relase EMO5_LEFT button after emergecy cause action', 'POCBv3_Emo5Left');
  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_FAN_IN,   DefDio.IN_LEFT_FAN_IN,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_FAN_IN',
        'Left Fan(In) Stopped',   'Close Doors and Check Left Fan(In)', 'POCBv3_LeftFanIn');
  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_FAN_IN,  DefDio.IN_RIGHT_FAN_IN,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_FAN_IN',
        'Right Fan(In) Stopped',  'Close Doors and Check Right Fan(In)', 'POCBv3_RightFanIn');
  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_FAN_OUT,  DefDio.IN_LEFT_FAN_OUT,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_FAN_OUT',
        'Left Fan(Out) Stopped',  'Close Doors and Check Left Fan(Out)', 'POCBv3_LeftFanOut');
  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_FAN_OUT, DefDio.IN_RIGHT_FAN_OUT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_FAN_OUT',
        'Right Fan(Out) Stopped', 'Close Doors and Check Right Fan(Out)', 'POCBv3_RightFanOut');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_LIGHT_CURTAIN, DefDio.IN_STAGE1_LIGHT_CURTAIN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_LIGHT_CURTAIN',
        'CH1 Light Curtain Detected', '', '');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_LIGHT_CURTAIN, DefDio.IN_STAGE2_LIGHT_CURTAIN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_LIGHT_CURTAIN',
        'CH2 Light Curtain Detected', '', '');
  sTempDioNo := IntToStr(DefDio.IN_STAGE1_KEY_AUTO) + ',' + IntToStr(DefDio.IN_STAGE1_KEY_TEACH);
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_NOT_AUTOMODE, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_KEY_NOT_AUTO',
        'CH1 AUTO/TEACH Key is NOT AUTO', 'To run or robot/motion control, set CH1 AUTO/TEACH key to AUTO mode', 'POCBv3_Ch1KeyAutoTeach');
  sTempDioNo := IntToStr(DefDio.IN_STAGE2_KEY_AUTO) + ',' + IntToStr(DefDio.IN_STAGE2_KEY_TEACH);
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_NOT_AUTOMODE, sTempDioNo,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_KEY_NOT_AUTO',
        'CH2 AUTO/TEACH Key is NOT AUTO', 'To run or robot/motion control, set CH2 AUTO/TEACH key to AUTO mode', 'POCBv3_Ch2KeyAutoTeach');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_DOOR1, DefDio.IN_STAGE1_MAINT_DOOR1, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_MAINT_DOOR1',
        'CH1 Maint Door1 Opened', '', 'POCBv3_LeftMaintDoor1');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_DOOR2, DefDio.IN_STAGE1_MAINT_DOOR2, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_MAINT_DOOR2',
        'CH1 Maint Door2 Opened', '', 'POCBv3_LeftMaintDoor2');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_DOOR1, DefDio.IN_STAGE1_MAINT_DOOR1, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_MAINT_DOOR1',
        'CH2 Maint Door1 Opened', '', 'POCBv3_RightMaintDoor1');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_DOOR2, DefDio.IN_STAGE1_MAINT_DOOR2, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_MAINT_DOOR2',
        'CH2 Maint Door2 Opened', '', 'POCBv3_RightMaintDoor2');
  SetAlarmInfo(DefPocb.ALARM_DIO_CYLINDER_REGULATOR, DefDio.IN_CYLINDER_REGULATOR, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CYLINDER_REGULATOR',
        'Cylinder Regulator is Abnormal', 'Check Cylinder Regulator', 'POCBv3_CylinderRegulator');
  SetAlarmInfo(DefPocb.ALARM_DIO_VACUUM_REGULATOR,   DefDio.IN_VACUUM_REGULATOR,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_VACUUM_REGULATOR',
        'Vacuum Regulator is Abnormal',   'Check Vacuum Regulator', 'POCBv3_VacuumRegulator');
  SetAlarmInfo(DefPocb.ALARM_DIO_TEMPERATURE, DefDio.IN_TEMPERATURE_ALARM, DefPocb.ALARM_CLASS_SAFETY, 'DIO_TEMPERATURE',
        'System Temperature is High', 'Stop Operation and Check System Temperature', 'POCBv3_SystemTemperature');
  SetAlarmInfo(DefPocb.ALARM_DIO_POWER_HIGH, DefDio.IN_POWER_HIGH_ALARM, DefPocb.ALARM_CLASS_SAFETY, 'DIO_POWER_HIGH',
        'System Power is High', 'Stop Operation and Check System Power', 'POCBv3_SystemPower.bmp');
  SetAlarmInfo(DefPocb.ALARM_DIO_MC1, DefDio.IN_MC1, DefPocb.ALARM_CLASS_SAFETY, 'DIO_MC1',
        'MC1 Down by Sefty PLC (Light Curtain, Door opened at AUTO Mode)', 'Press Reset button to recover MC1/MC2', 'POCBv3_ResetButtons');
  SetAlarmInfo(DefPocb.ALARM_DIO_MC2, DefDio.IN_MC2, DefPocb.ALARM_CLASS_SAFETY, 'DIO_MC2',
        'MC2 Down by Sefty PLC (Light Curtain, Door opened at AUTO Mode)', 'Press Reset button to recover MC1/MC2', 'POCBv3_ResetButtons');
  // For non-ASSY
  sTempDioNo := IntToStr(DefDio.IN_SHUTTER_GUIDE_UP) + ',' + IntToStr(DefDio.IN_SHUTTER_GUIDE_DOWN);
  SetAlarmInfo(DefPocb.ALARM_DIO_SHUTTER_GUIDE_NOT_UP, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_SHUTTER_GUIDE_NOT_UP',
        '(Non-ASSY) ShutterGuide is NOT UP-state', 'Check ShutterGuide and ShutterGuide UP|DOWN detect sensor', 'POCBv3_ShutterGuideUp');
  sTempDioNo := IntToStr(DefDio.IN_CAMZONE_PARTITION_UP1) + ',' + IntToStr(DefDio.IN_CAMZONE_PARTITION_UP2) + ','
              + IntToStr(DefDio.IN_CAMZONE_PARTITION_DOWN1) + ',' + IntToStr(DefDio.IN_CAMZONE_PARTITION_DOWN2);
  SetAlarmInfo(DefPocb.ALARM_DIO_CAMZONE_PARTITION_NOT_DOWN, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CAMZONE_PARTITION_NOT_DOWN',
        '(Non-ASSY) CameraZonePartition is NOT DOWN-state', 'Check CameraZonePartition and CameraZonePartition UP1|UP2|DOWN1|DOWN2 detect sensor', 'POCBv3_CamZonePartitionDown');
  sTempDioNo := IntToStr(DefDio.IN_CAMZONE_INNER_DOOR_OPEN) + ',' + IntToStr(DefDio.IN_CAMZONE_INNER_DOOR_CLOSE);
  SetAlarmInfo(DefPocb.ALARM_DIO_CAMZONE_INNER_DOOR_NOT_CLOSE, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CAMZONE_INNER_DOOR_NOT_CLOSE',
        '(Non-ASSY) CameraZoneInnerDoor is NOT CLOSE-state', 'Check CameraZoneInnerDoor and CameraZoneInnerDoor OPEN|CLOSE detect sensor', 'POCBv3_CamZoneInnerDoorClose');
  sTempDioNo := IntToStr(DefDio.IN_LOADZONE_PARTITION1) + ',' + IntToStr(DefDio.IN_LOADZONE_PARTITION2);
  SetAlarmInfo(DefPocb.ALARM_DIO_LOADZONE_PARTITION_NOT_DETECTED, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_LOADZONE_PARTITION_NOT_DETECTED',
        '(Non-ASSY) LoadingZonePartition is NOT detected', 'Check LoadingZonePartition and LoadingZonePartition detect sensor1|2', 'POCBv3_LoadingZonePartExist');
  sTempDioNo := IntToStr(DefDio.IN_STAGE1_JIG_INTERLOCK) + ',' + IntToStr(DefDio.IN_STAGE2_JIG_INTERLOCK);
  SetAlarmInfo(DefPocb.ALARM_DIO_ASSY_JIG_DETECTED, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_ASSY_JIG_DETECTED',
        '(Non-ASSY) AssyJig is detected', 'Check JIG on Stages and Stage1/Stage2 Jig detect sensor', 'POCBv3_AssyJigOnStage');
  // For ASSY
  sTempDioNo := IntToStr(DefDio.IN_SHUTTER_GUIDE_UP) + ',' + IntToStr(DefDio.IN_SHUTTER_GUIDE_DOWN);
  SetAlarmInfo(DefPocb.ALARM_DIO_SHUTTER_GUIDE_NOT_DOWN, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_SHUTTER_GUIDE_NOT_DOWN',
        '(ASSY) ShutterGuide is NOT DOWN-state', 'Check ShutterGuide and ShutterGuide UP|DOWN detect sensor', 'POCBv3_ShutterGuideDown');
  sTempDioNo := IntToStr(DefDio.IN_CAMZONE_PARTITION_UP1) + ',' + IntToStr(DefDio.IN_CAMZONE_PARTITION_UP2) + ','
              + IntToStr(DefDio.IN_CAMZONE_PARTITION_DOWN1) + ',' + IntToStr(DefDio.IN_CAMZONE_PARTITION_DOWN2);
  SetAlarmInfo(DefPocb.ALARM_DIO_CAMZONE_PARTITION_NOT_UP, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CAMZONE_PARTITION_NOT_UP',
        '(ASSY) CameraZonePartition is NOT UP-state', 'Check CameraZonePartition and UP1|UP2|DOWN1|DOWN2 detect sensor', 'POCBv3_CamZonePartitionUp');
  sTempDioNo := IntToStr(DefDio.IN_CAMZONE_INNER_DOOR_OPEN) + ',' + IntToStr(DefDio.IN_CAMZONE_INNER_DOOR_CLOSE);
  SetAlarmInfo(DefPocb.ALARM_DIO_CAMZONE_INNER_DOOR_NOT_OPEN, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CAMZONE_INNER_DOOR_NOT_OPEN',
        '(ASSY) CameraZoneInnerDoor is NOT OPEN-state', 'Check CameraZoneInnerDoor and CameraZoneInnerDoor OPEN|CLOSE detect sensor', 'POCBv3_CamZoneInnerDoorOpen');
  sTempDioNo := IntToStr(DefDio.IN_LOADZONE_PARTITION1) + ',' + IntToStr(DefDio.IN_LOADZONE_PARTITION2);
  SetAlarmInfo(DefPocb.ALARM_DIO_LOADZONE_PARTITION_DETECTED, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_LOADZONE_PARTITION_DETECTED',
        '(ASSY) LoadingZonePartition is detected', 'Check LoadingZonePartition and LoadingZonePartition detect sensor1|2', 'POCBv3_LoadingZonePartExist');
  sTempDioNo := IntToStr(DefDio.IN_STAGE1_JIG_INTERLOCK) + ',' + IntToStr(DefDio.IN_STAGE2_JIG_INTERLOCK);
  SetAlarmInfo(DefPocb.ALARM_DIO_ASSY_JIG_STAGE_NOT_ALIGNED, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_ASSY_JIG_STAGE_NOT_ALIGNED',
        '(ASSY) Stage1/Stage2 is NOT aligned for AssyJig', 'Check JIG on Stages and Stage1/Stage2 Jig detect sensor', 'POCBv3_AssyJigNotAlign');
{$ELSEIF Defined(POCB_A2CHv4)}  //----------------------
  SetAlarmInfo(DefPocb.ALARM_DIO_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'DIO_NOT_CONNECTED',
        'DIO Control Device Disconnected', 'Check PCI DIO Control Device on PC');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO1_FRONT,       DefDio.IN_EMO1_FRONT,       DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO1_FRONT',
        'EMO1_FRONT Button Pressed', 'Relase EMO1_FRONT button after emergecy cause action', 'POCBv4_Emo1Front');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO2_RIGHT,       DefDio.IN_EMO2_RIGHT,       DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO2_RIGHT',
        'EMO2_RIGHT Button Pressed', 'Relase EMO2_RIGHT button after emergecy cause action', 'POCBv4_Emo2Right');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO3_INNER_RIGHT, DefDio.IN_EMO3_INNER_RIGHT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO3_INNER_RIGHT',
        'EMO3_INNER_RIGHT Button Pressed', 'Relase EMO3_INNER_RIGHT button after emergecy cause action', 'POCBv4_Emo3InnerRight');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO4_INNER_LEFT,  DefDio.IN_EMO4_INNER_LEFT,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO4_INNER_LEFT',
        'EMO4_INNER_LEFT Button Pressed', 'Relase EMO4_INNER_LEFT button after emergecy cause action', 'POCBv4_Emo4InnerLeft');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO5_LEFT,        DefDio.IN_EMO5_LEFT,        DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO5_LEFT',
        'EMO5_LEFT Button Pressed', 'Relase EMO5_LEFT button after emergecy cause action', 'POCBv4_Emo5Left');
  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_FAN_IN,   DefDio.IN_LEFT_FAN_IN,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_FAN_IN',
        'Left Fan(In) Stopped',   'Close Doors and Check Left Fan(In)', 'POCBv4_LeftFanIn');
  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_FAN_IN,  DefDio.IN_RIGHT_FAN_IN,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_FAN_IN',
        'Right Fan(In) Stopped',  'Close Doors and Check Right Fan(In)', 'POCBv4_RightFanIn');
  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_FAN_OUT,  DefDio.IN_LEFT_FAN_OUT,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_FAN_OUT',
        'Left Fan(Out) Stopped',  'Close Doors and Check Left Fan(Out)', 'POCBv4_LeftFanOut');
  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_FAN_OUT, DefDio.IN_RIGHT_FAN_OUT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_FAN_OUT',
        'Right Fan(Out) Stopped', 'Close Doors and Check Right Fan(Out)', 'POCBv4_RightFanOut');
  if Common.SystemInfo.HasDioFanInOutPC then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
    SetAlarmInfo(DefPocb.ALARM_DIO_MAINPC_FAN_IN,   DefDio.IN_MAINPC_FAN_IN,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_GPC_FAN_IN',
        'MainPC(GPC) Fan(In) Stopped',   'Close Doors and Check MainPC Fan(In)', 'POCBv4_MainPcFanIn');
    SetAlarmInfo(DefPocb.ALARM_DIO_MAINPC_FAN_OUT,  DefDio.IN_MAINPC_FAN_OUT,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_GPC_FAN_OUT',
        'MainPC(GPC) Fan(Out) Stopped',  'Close Doors and Check MainPC Fan(Out)', 'POCBv4_MainPcFanOut');
    SetAlarmInfo(DefPocb.ALARM_DIO_CAMPC_FAN_IN,  DefDio.IN_CAMPC_FAN_IN,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_DPC_FAN_IN',
        'CamPC(DPC) Fan(In) Stopped',  'Close Doors and Check CamPC Fan(In)', 'POCBv4_CamPcFanIn');
    SetAlarmInfo(DefPocb.ALARM_DIO_CAMPC_FAN_OUT, DefDio.IN_CAMPC_FAN_OUT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_DPC_FAN_OUT',
        'CamPC(DPC) Fan(Out) Stopped', 'Close Doors and Check CamPC Fan(Out)', 'POCBv4_CamPcFanOut');
  end;
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_LIGHT_CURTAIN, DefDio.IN_STAGE1_LIGHT_CURTAIN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_LIGHT_CURTAIN',
        'CH1 Light Curtain Detected', '', 'POCBv4_Ch1LightCurtain.bmp');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_LIGHT_CURTAIN, DefDio.IN_STAGE2_LIGHT_CURTAIN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_LIGHT_CURTAIN',
        'CH2 Light Curtain Detected', '', 'POCBv4_Ch2LightCurtain.bmp');
  sTempDioNo := IntToStr(DefDio.IN_STAGE1_KEY_AUTO) + ',' + IntToStr(DefDio.IN_STAGE1_KEY_TEACH);
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_NOT_AUTOMODE, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_KEY_NOT_AUTO',
        'CH1 AUTO/TEACH Key is NOT AUTO', 'To run or robot/motion control, set CH1 AUTO/TEACH key to AUTO mode', 'POCBv4_Ch1KeyAutoTeach');
  sTempDioNo := IntToStr(DefDio.IN_STAGE2_KEY_AUTO) + ',' + IntToStr(DefDio.IN_STAGE2_KEY_TEACH);
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_NOT_AUTOMODE, sTempDioNo,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_KEY_NOT_AUTO',
        'CH2 AUTO/TEACH Key is NOT AUTO', 'To run or robot/motion control, set CH2 AUTO/TEACH key to AUTO mode', 'POCBv4_Ch2KeyAutoTeach');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_DOOR1, DefDio.IN_STAGE1_MAINT_DOOR1, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_MAINT_DOOR1',
        'CH1 Maint Door1 Opened', '', 'POCBv4_LeftMaintDoor1');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_DOOR2, DefDio.IN_STAGE1_MAINT_DOOR2, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_MAINT_DOOR2',
        'CH1 Maint Door2 Opened', '', 'POCBv4_LeftMaintDoor2');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_DOOR1, DefDio.IN_STAGE1_MAINT_DOOR1, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_MAINT_DOOR1',
        'CH2 Maint Door1 Opened', '', 'POCBv4_RightMaintDoor1');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_DOOR2, DefDio.IN_STAGE1_MAINT_DOOR2, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_MAINT_DOOR2',
        'CH2 Maint Door2 Opened', '', 'POCBv4_RightMaintDoor2');
  SetAlarmInfo(DefPocb.ALARM_DIO_CYLINDER_REGULATOR, DefDio.IN_CYLINDER_REGULATOR, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CYLINDER_REGULATOR',
        'Cylinder Regulator is Abnormal', 'Check Cylinder Regulator', 'POCBv4_CylinderRegulator');
  if Common.SystemInfo.HasDioVacuum then begin //ATO(False),ATO-TRIBUTO(True) //2023-04-10 HasDioVacuum
    SetAlarmInfo(DefPocb.ALARM_DIO_VACUUM_REGULATOR, DefDio.IN_VACUUM_REGULATOR,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_VACUUM_REGULATOR',
        'Vacuum Regulator is Abnormal',   'Check Vacuum Regulator', 'POCBv4_VacuumRegulator');
  end;
  SetAlarmInfo(DefPocb.ALARM_DIO_TEMPERATURE, DefDio.IN_TEMPERATURE_ALARM, DefPocb.ALARM_CLASS_SAFETY, 'DIO_TEMPERATURE',
        'System Temperature is High', 'Stop Operation and Check System Temperature', 'POCBv4_SystemTemperature');
  SetAlarmInfo(DefPocb.ALARM_DIO_POWER_HIGH, DefDio.IN_POWER_HIGH_ALARM, DefPocb.ALARM_CLASS_SAFETY, 'DIO_POWER_HIGH',
        'System Power is High', 'Stop Operation and Check System Power', 'POCBv4_SystemPower.bmp');
  SetAlarmInfo(DefPocb.ALARM_DIO_MC1, DefDio.IN_MC1, DefPocb.ALARM_CLASS_SAFETY, 'DIO_MC1',
        'MC1 Down by Sefty PLC (Light Curtain, Door opened at AUTO Mode)', 'Press Reset button to recover MC1/MC2', 'POCBv4_ResetButtons');
  SetAlarmInfo(DefPocb.ALARM_DIO_MC2, DefDio.IN_MC2, DefPocb.ALARM_CLASS_SAFETY, 'DIO_MC2',
        'MC2 Down by Sefty PLC (Light Curtain, Door opened at AUTO Mode)', 'Press Reset button to recover MC1/MC2', 'POCBv4_ResetButtons');
{$ELSEIF Defined(POCB_ATO) or Defined(POCB_GAGO)}  //----------------------

  SetAlarmInfo(DefPocb.ALARM_DIO_CP1,   DefDio.IN_CP1,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_CP_1_IN',
        'CP 1(In) Stopped',   'Check CP 1 IO(In)', 'POCBv4_CP_1_In');
  SetAlarmInfo(DefPocb.ALARM_DIO_CP2,   DefDio.IN_CP2,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_CP_2_IN',
        'CP 2(In) Stopped',   'Check CP 2 IO(In)', 'POCBv4_CP_2_In');
  SetAlarmInfo(DefPocb.ALARM_DIO_CP3,   DefDio.IN_CP3,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_CP_3_IN',
        'CP 3(In) Stopped',   'Check CP 3 IO(In)', 'POCBv4_CP_3_In');
   SetAlarmInfo(DefPocb.ALARM_DIO_CP6,   DefDio.IN_CP6,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_CP_6_IN',
        'CP 6(In) Stopped',   'Check CP 6 IO(In)', 'POCBv4_CP_6_In');
  SetAlarmInfo(DefPocb.ALARM_DIO_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'DIO_NOT_CONNECTED',
        'DIO Control Device Disconnected', 'Check PCI DIO Control Device on PC');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO1_FRONT,       DefDio.IN_EMO1_FRONT,       DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO1_FRONT',
        'EMO1_FRONT Button Pressed', 'Relase EMO1_FRONT button after emergecy cause action', 'POCB_Emo1Front');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO2_RIGHT,       DefDio.IN_EMO2_RIGHT,       DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO2_RIGHT',
        'EMO2_RIGHT Button Pressed', 'Relase EMO2_RIGHT button after emergecy cause action', 'POCB_Emo2Right');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO3_INNER_RIGHT, DefDio.IN_EMO3_INNER_RIGHT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO3_INNER_RIGHT',
        'EMO3_INNER_RIGHT Button Pressed', 'Relase EMO3_INNER_RIGHT button after emergecy cause action', 'POCB_Emo3InnerRight');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO4_INNER_LEFT,  DefDio.IN_EMO4_INNER_LEFT,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO4_INNER_LEFT',
        'EMO4_INNER_LEFT Button Pressed', 'Relase EMO4_INNER_LEFT button after emergecy cause action', 'POCB_Emo4InnerLeft');
  SetAlarmInfo(DefPocb.ALARM_DIO_EMO5_LEFT,        DefDio.IN_EMO5_LEFT,        DefPocb.ALARM_CLASS_SAFETY, 'DIO_EMO5_LEFT',
        'EMO5_LEFT Button Pressed', 'Relase EMO5_LEFT button after emergecy cause action', 'POCB_Emo5Left');
  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_FAN_IN,   DefDio.IN_LEFT_FAN_IN,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_FAN_IN',
        'Left Fan(In) Stopped',   'Check Left Fan(In)', 'POCB_LeftFanIn');
  // Added by SHPARK 2024-01-16 오후 4:11:38 remove alarm message for close door.
  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_FAN_IN,  DefDio.IN_RIGHT_FAN_IN,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_FAN_IN',
        'Right Fan(In) Stopped',  'Check Right Fan(In)', 'POCB_RightFanIn');
  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_FAN_OUT,  DefDio.IN_LEFT_FAN_OUT,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_FAN_OUT',
        'Left Fan(Out) Stopped',  'Check Left Fan(Out)', 'POCB_LeftFanOut');

//  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_FAN_IN,  DefDio.IN_RIGHT_FAN_IN,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_FAN_IN',
//        'Right Fan(In) Stopped',  'Close Doors and Check Right Fan(In)', 'POCB_RightFanIn');
//  SetAlarmInfo(DefPocb.ALARM_DIO_LEFT_FAN_OUT,  DefDio.IN_LEFT_FAN_OUT,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_LEFT_FAN_OUT',
//        'Left Fan(Out) Stopped',  'Close Doors and Check Left Fan(Out)', 'POCB_LeftFanOut');
  SetAlarmInfo(DefPocb.ALARM_DIO_RIGHT_FAN_OUT, DefDio.IN_RIGHT_FAN_OUT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_RIGHT_FAN_OUT',
        'Right Fan(Out) Stopped', 'Check Right Fan(Out)', 'POCB_RightFanOut');
  if Common.SystemInfo.HasDioFanInOutPC then begin //2022-07-15 A2CHv4_#3(FanInOutPC)
    SetAlarmInfo(DefPocb.ALARM_DIO_MAINPC_FAN_IN,   DefDio.IN_MAINPC_FAN_IN,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_GPC_FAN_IN',
        'MainPC(GPC) Fan(In) Stopped',   'Check MainPC Fan(In)', 'POCB_MainPcFanIn');
    SetAlarmInfo(DefPocb.ALARM_DIO_MAINPC_FAN_OUT,  DefDio.IN_MAINPC_FAN_OUT,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_GPC_FAN_OUT',
        'MainPC(GPC) Fan(Out) Stopped',  'Check MainPC Fan(Out)', 'POCB_MainPcFanOut');
    SetAlarmInfo(DefPocb.ALARM_DIO_CAMPC_FAN_IN,  DefDio.IN_CAMPC_FAN_IN,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_DPC_FAN_IN',
        'CamPC(DPC) Fan(In) Stopped',  'Check CamPC Fan(In)', 'POCB_CamPcFanIn');
    SetAlarmInfo(DefPocb.ALARM_DIO_CAMPC_FAN_OUT, DefDio.IN_CAMPC_FAN_OUT, DefPocb.ALARM_CLASS_SAFETY, 'DIO_DPC_FAN_OUT',
        'CamPC(DPC) Fan(Out) Stopped', 'Check CamPC Fan(Out)', 'POCB_CamPcFanOut');
  end;
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_LIGHT_CURTAIN, DefDio.IN_STAGE1_LIGHT_CURTAIN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_LIGHT_CURTAIN',
        'CH1 Light Curtain Detected', '', 'POCB_Ch1LightCurtain.bmp');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_LIGHT_CURTAIN, DefDio.IN_STAGE2_LIGHT_CURTAIN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_LIGHT_CURTAIN',
        'CH2 Light Curtain Detected', '', 'POCB_Ch2LightCurtain.bmp');
  sTempDioNo := IntToStr(DefDio.IN_STAGE1_KEY_AUTO) + ',' + IntToStr(DefDio.IN_STAGE1_KEY_TEACH);
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_NOT_AUTOMODE, sTempDioNo, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_KEY_NOT_AUTO',
        'CH1 AUTO/TEACH Key is NOT AUTO', 'To run or robot/motion control, set CH1 AUTO/TEACH key to AUTO mode', 'POCB_Ch1KeyAutoTeach');
  sTempDioNo := IntToStr(DefDio.IN_STAGE2_KEY_AUTO) + ',' + IntToStr(DefDio.IN_STAGE2_KEY_TEACH);
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_NOT_AUTOMODE, sTempDioNo,  DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_KEY_NOT_AUTO',
        'CH2 AUTO/TEACH Key is NOT AUTO', 'To run or robot/motion control, set CH2 AUTO/TEACH key to AUTO mode', 'POCB_Ch2KeyAutoTeach');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_DOOR1_OPEN, DefDio.IN_STAGE1_DOOR1_OPEN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_MAINT_DOOR1_OPEN',
        'CH1 Maint Door1 Opened', '', 'POCB_LeftMaintDoor1');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_DOOR2_OPEN, DefDio.IN_STAGE1_DOOR2_OPEN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_MAINT_DOOR2_OPEN',
        'CH1 Maint Door2 Opened', '', 'POCB_LeftMaintDoor2');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_DOOR1_OPEN, DefDio.IN_STAGE1_DOOR1_OPEN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_MAINT_DOOR1_OPEN',
        'CH2 Maint Door1 Opened', '', 'POCB_RightMaintDoor1');
  SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_DOOR2_OPEN, DefDio.IN_STAGE1_DOOR2_OPEN, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_MAINT_DOOR2_OPEN',
        'CH2 Maint Door2 Opened', '', 'POCB_RightMaintDoor2');
  SetAlarmInfo(DefPocb.ALARM_DIO_CYLINDER_REGULATOR, DefDio.IN_CYLINDER_REGULATOR, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CYLINDER_REGULATOR',
        'Cylinder Regulator is Abnormal', 'Check Cylinder Regulator', 'POCB_CylinderRegulator');
  if Common.SystemInfo.HasDioVacuum then begin //ATO(False),ATO-TRIBUTO(True) //2023-04-10 HasDioVacuum
    SetAlarmInfo(DefPocb.ALARM_DIO_VACUUM_REGULATOR, DefDio.IN_VACUUM_REGULATOR,   DefPocb.ALARM_CLASS_SAFETY, 'DIO_VACUUM_REGULATOR',
        'Vacuum Regulator is Abnormal',   'Check Vacuum Regulator', 'POCB_VacuumRegulator');
  end;
  SetAlarmInfo(DefPocb.ALARM_DIO_TEMPERATURE, DefDio.IN_TEMPERATURE_ALARM, DefPocb.ALARM_CLASS_SAFETY, 'DIO_TEMPERATURE',
        'System Temperature is High', 'Stop Operation and Check System Temperature', 'POCB_SystemTemperature');
  SetAlarmInfo(DefPocb.ALARM_DIO_POWER_HIGH, DefDio.IN_POWER_HIGH_ALARM, DefPocb.ALARM_CLASS_SAFETY, 'DIO_POWER_HIGH',
        'System Power is High', 'Stop Operation and Check System Power', 'POCB_SystemPower.bmp');
  SetAlarmInfo(DefPocb.ALARM_DIO_MC1, DefDio.IN_MC1, DefPocb.ALARM_CLASS_SAFETY, 'DIO_MC1',
        'MC1 Down by Sefty PLC (Light Curtain, Door opened at AUTO Mode)', 'Press Reset button to recover MC1/MC2', 'POCB_ResetButtons');
  SetAlarmInfo(DefPocb.ALARM_DIO_MC2, DefDio.IN_MC2, DefPocb.ALARM_CLASS_SAFETY, 'DIO_MC2',
        'MC2 Down by Sefty PLC (Light Curtain, Door opened at AUTO Mode)', 'Press Reset button to recover MC1/MC2', 'POCB_ResetButtons');
{$ENDIF}

{$IFDEF HAS_DIO_IN_DOOR_LOCK}
  if Common.SystemInfo.HasDioInDoorLock then begin //2023-12-07 HasDioInDoorLock
    SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_DOOR1_LOCK, DefDio.IN_STAGE1_DOOR1_LOCK, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_MAINT_DOOR1_LOCK',
        'CH1 Maint Door1 Unlocked', '', 'POCB_LeftMaintDoor1');
    SetAlarmInfo(DefPocb.ALARM_DIO_STAGE1_DOOR2_LOCK, DefDio.IN_STAGE1_DOOR2_LOCK, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_MAINT_DOOR2_LOCK',
        'CH1 Maint Door2 Unlocked', '', 'POCB_LeftMaintDoor2');
    SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_DOOR1_LOCK, DefDio.IN_STAGE1_DOOR1_LOCK, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_MAINT_DOOR1_LOCK',
        'CH2 Maint Door1 Unlocked', '', 'POCB_RightMaintDoor1');
    SetAlarmInfo(DefPocb.ALARM_DIO_STAGE2_DOOR2_LOCK, DefDio.IN_STAGE1_DOOR2_LOCK, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_MAINT_DOOR2_LOCK',
        'CH2 Maint Door2 Unlocked', '', 'POCB_RightMaintDoor2');
  end;
{$ENDIF}

{$IFDEF HAS_DIO_Y_AXIS_MC}
  if Common.SystemInfo.HasDioYAxisMC then begin //2023-12-07 HasDioYAxisMC
    SetAlarmInfo(DefPocb.ALARM_DIO_Y_AXIS_MC_CH1, DefDio.IN_STAGE1_Y_AXIS_MC, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH1_Y_AXIS_MC',
        'CH1 Y-Axis MC Down', '', 'POCB_Ch1YAxisMC');
    SetAlarmInfo(DefPocb.ALARM_DIO_Y_AXIS_MC_CH2, DefDio.IN_STAGE2_Y_AXIS_MC, DefPocb.ALARM_CLASS_SAFETY, 'DIO_CH2_Y_AXIS_MC',
        'CH2 Y-Axis MC Down', '', 'POCB_Ch2YAxisMC');
  end;
{$ENDIF}

  SetAlarmInfo(DefPocb.ALARM_HANDBCR_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'HANDBCR_NOT_CONNECTED',
        'BCR Device Connection NG', 'Check BCR Device Connection to PC', '');
  SetAlarmInfo(DefPocb.ALARM_SWITCHBUTTON1_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_9BUTTONS_NOT_CONNECTED',
        'CH1, 9 Buttons Device Connection NG', 'Check 9Buttons Device Connection to PC', '');
  SetAlarmInfo(DefPocb.ALARM_SWITCHBUTTON2_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_9BUTTONS_NOT_CONNECTED',
        'CH2, 9 Buttons Device Connection NG', 'Check 9Buttons Device Connection to PC', '');
  SetAlarmInfo(DefPocb.ALARM_SHARED_FOLDER_NOT_EXIST, -1, DefPocb.ALARM_CLASS_SERIOUS, 'SHARED_FOLDER_NOT_EXIST',
        'Shared Folder Not Exist', 'Create SharedFolder Directory for Camera compensation data file', '');
  SetAlarmInfo(DefPocb.ALARM_CAMERA_PC1_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_CAMERA_PC_DISCONNECTED',
        'CH1, Camera PC Communication NG', 'Check Camera PC1 s/w status and/or network connection', '');
  SetAlarmInfo(DefPocb.ALARM_CAMERA_PC2_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_CAMERA_PC_DISCONNECTED',
        'CH2, Camera PC Communication NG', 'Check Camera PC2 s/w status and/or network connection', '');
  SetAlarmInfo(DefPocb.ALARM_MES_HOST_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'MES_DISCONNECTED',
        'MES Disconnected', 'Check MES connection (Network Cable, Network Card on PC)', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_PG_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_PG_DISCONNECTED',
        'CH1, PG Communication NG', 'Check PG Connection or Reset PG if required', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_PG_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_PG_DISCONNECTED',
        'CH2, PG Communication NG', 'Check PG connection or Reset PG if required', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_SPI_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_SPI_DISCONNECTED',
        'CH1, SPI Communication NG', 'Check SPI connection or Reset SPI if required', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_SPI_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_SPI_DISCONNECTED',
        'CH2, SPI Communication NG', 'Check SPI connection or Reset SPI if required', '');

  SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_Y_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_MOTION_Y_DISCONNECTED',
        'CH1, Y-Axis Control Device Disconnected', 'Check PCI Motion Control Device/Connection on PC', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_Y_SIG_ALARM_ON, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH1_MOTION_Y_SIG_ALARM_ON',
        'CH1, Y-Axis Servo Alarm Signal On', 'Press Reset button to clear Motion Alarm Signal and Search Home again', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_Y_INVALID_UNITPULSE, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH1_MOTION_Y_INVALID_UNITPULSE',
        'CH1, Y-Axis Unit/Pulse is invalid', 'Servo Off->On in Mainter and Search Motion Home again', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_Y_NEED_HOME_SEARCH, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_MOTION_Y_NEED_HOME_SEARCH',
        'CH1, Y-Axis Need Home Search', 'Search Motion Home again by SafetAlarmMotion or Mainter', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_Y_MODEL_POS_NG, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_MOTION_Y_MODEL_POS_NG',
        'CH1, Y-Axis Position is invalid', 'Move to normal Position after Home Search by SafetAlarmMotion or Mainter window', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_Y_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_MOTION_Y_DISCONNECTED',
        'CH2, Y-Axis Control Device Disconnected', 'Check PCI Motion Control Device/Connection on PC', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_Y_SIG_ALARM_ON, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH2_MOTION_Y_SIG_ALARM_ON',
        'CH2, Y-Axis Servo Alarm Signal On', 'Press Reset button to clear Motion Alarm Signal and Search Home again', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_Y_INVALID_UNITPULSE, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH2_MOTION_Y_INVALID_UNITPULSE',
        'CH2, Y-Axis Unit/Pulse is invalid', 'Servo Off->On in Mainter and Search Motion Home again', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_Y_NEED_HOME_SEARCH, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_MOTION_Y_NEED_HOME_SEARCH',
        'CH2, Y-Axis Need Home Search', 'Search Motion Home again by SafetAlarmMotion or Mainter', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_Y_MODEL_POS_NG, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_MOTION_Y_MODEL_POS_NG',
        'CH2, Y-Axis Position is invalid', 'Move to normal Position after Home Search by SafetAlarmMotion or Mainter window', '');

{$IFDEF HAS_MOTION_CAM_Z}
  SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_Z_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_MOTION_Z_DISCONNECTED',
        'CH1, Z-Axis Control Device Disconnected', 'Check PCI Motion Control Device/Connection on PC', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_Z_SIG_ALARM_ON, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH1_MOTION_Z_SIG_ALARM_ON',
        'CH1, Z-Axis Servo Alarm Signal On', 'Press Reset button to clear Motion Alarm Signal and Search Home again');
  SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_Z_INVALID_UNITPULSE, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH1_MOTION_Z_INVALID_UNITPULSE',
        'CH1, Z-Axis Unit/Pulse is invalid', 'Servo Off->On in Mainter and Search Motion Home again', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_Z_NEED_HOME_SEARCH, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_MOTION_Z_NEED_HOME_SEARCH',
        'CH1, Z-Axis Need Home Search', 'Search Motion Home again by SafetAlarmMotion or Mainter', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_Z_MODEL_POS_NG, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_MOTION_Z_MODEL_POS_NG',
        'CH1, Z-Axis Position is invalid', 'Move to normal Position after Home Search by SafetAlarmMotion or Mainter window', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_Z_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_MOTION_Z_DISCONNECTED',
        'CH2, Z-Axis Control Device Disconnected', 'Check PCI Motion Control Device/Connection on PC', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_Z_SIG_ALARM_ON, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH2_MOTION_Z_SIG_ALARM_ON',
        'CH2, Z-Axis Servo Alarm Signal On', 'Press Reset button to clear Motion Alarm Signal and Search Home again', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_Z_INVALID_UNITPULSE, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH2_MOTION_Z_INVALID_UNITPULSE',
        'CH2, Z-Axis Unit/Pulse is invalid', 'Servo Off->On in Mainter and Search Motion Home again', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_Z_NEED_HOME_SEARCH, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_MOTION_Z_NEED_HOME_SEARCH',
        'CH2, Z-Axis Need Home Search', 'Search Motion Home again by SafetAlarmMotion or Mainter', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_Z_MODEL_POS_NG, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_MOTION_Z_MODEL_POS_NG',
        'CH2, Z-Axis Position is invalid', 'Move to normal Position after Home Search by SafetAlarmMotion or Mainter window', '');
{$ENDIF}
{$IFDEF HAS_MOTION_TILTING}
	SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_T_DISCONNECTED,				-1,DefPocb.ALARM_CLASS_SERIOUS,	  'CH1_MOTION_T_DISCONNECTED',
					'CH1, Tilt-Axis Control Device Disconnected', 'Check PCI Motion Control Device/Connection on PC');
	SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_T_SIG_ALARM_ON,				-1,DefPocb.ALARM_CLASS_SAFETY,	  'CH1_MOTION_T_SIG_ALARM_ON',
					'CH1, Tilt-Axis Servo Alarm Signal On',       'Press Reset button to clear Motion Alarm Signal and Search Home again');
	SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_T_INVALID_UNITPULSE,	-1,DefPocb.ALARM_CLASS_SAFETY,  'CH1_MOTION_T_INVALID_UNITPULSE',
					'CH1, Tilt-Axis Unit/Pulse is invalid',       'Servo Off->On in Mainter and Search Motion Home again');
  SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_T_NEED_HOME_SEARCH,		-1,DefPocb.ALARM_CLASS_SERIOUS,	  'CH1_MOTION_T_NEED_HOME_SEARCH',
					'CH1, Tilt-Axis Need Home Search',            'Search Motion Home again by SafetyAlarmMotionStats window or Mainter');
	SetAlarmInfo(DefPocb.ALARM_CH1_MOTION_T_MODEL_POS_NG,	    	-1,DefPocb.ALARM_CLASS_SERIOUS,	  'CH1_MOTION_T_MODEL_POS_NG',
					'CH1, Tilt-Axis Position is invalid',         'Move to normal Position after Home Search by SafetAlarmMotion or Mainter');
	SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_T_DISCONNECTED,				-1,DefPocb.ALARM_CLASS_SERIOUS,	  'CH2_MOTION_T_DISCONNECTED',
					'CH2, Tilt-Axis Control Device Disconnected', 'Check PCI Motion Control Device/Connection on PC');
	SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_T_SIG_ALARM_ON,				-1,DefPocb.ALARM_CLASS_SAFETY,	  'CH2_MOTION_T_SIG_ALARM_ON',
					'CH2, Tilt-Axis Servo Alarm Signal On',       'Press Reset button to clear Motion Alarm Signal and Search Home again');
	SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_T_INVALID_UNITPULSE,	-1,DefPocb.ALARM_CLASS_SAFETY,  'CH2_MOTION_T_INVALID_UNITPULSE',
					'CH2, Tilt-Axis Unit/Pulse is invalid',       'Servo Off->On in Mainter and Search Motion Home again');
  SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_T_NEED_HOME_SEARCH,		-1,DefPocb.ALARM_CLASS_SERIOUS,   'CH2_MOTION_T_NEED_HOME_SEARCH',
					'CH2, Tilt-Axis Need Home Search',            'Search Motion Home again by SafetAlarmMotion or Mainter');
	SetAlarmInfo(DefPocb.ALARM_CH2_MOTION_T_MODEL_POS_NG,	    	-1,DefPocb.ALARM_CLASS_SERIOUS,   'CH2_MOTION_T_MODEL_POS_NG',
					'CH2, Tilt-Axis Position is invalid',         'Move to normal Position after Home Search by SafetAlarmMotion or Mainter');
{$ENDIF}

  //2019-04-19 ALARM:FW_VERSION
  SetAlarmInfo(DefPocb.ALARM_CH1_PG_VERSION_MISMATCH,  -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_PG_VERSION_MISMATCH',
        'CH1, PG FW Version Mismatch', '1) Check PG Fw Version, 2-1) Download FW to PG or 2-2) Update FW Version info on Model Information', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_PG_VERSION_MISMATCH,  -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_PG_VERSION_MISMATCH',
        'CH2, PG FW Version Mismatch', '1) Check PG Fw Version, 2-1) Download FW to PG or 2-2) Update FW Version info on Model Information', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_SPI_VERSION_MISMATCH, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_SPI_VERSION_MISMATCH',
        'CH1, SPI FW Version Mismatch', '1) Check SPI Fw Version, 2-1) Update SPI FW or 2-2) Update FW Version info on Model Information', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_SPI_VERSION_MISMATCH, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_SPI_VERSION_MISMATCH',
        'CH2, SPI FW Version Mismatch', '1) Check SPI Fw Version, 2-1) Update SPI FW or 2-2) Update FW Version info on Model Information', '');
  //2019-04-17 ExLight
  SetAlarmInfo(DefPocb.ALARM_EXLIGHT_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'EXLIGHT_NOT_CONNECTED',
        'ExLIGHT Device Disconnected', '1) Check ExLight Device Connection to PC, 2) Check ExLight Device Status (Power On, Remote Control)', 'POCB_ExLight');
  //2019-05-04 EFU
  SetAlarmInfo(DefPocb.ALARM_EFU_NOT_CONNECTED, -1,DefPocb.ALARM_CLASS_LIGHT, 'EFU_NOT_CONNECTED',
        'EFU Device Disconnected', '1) Check EFU LV32-BLDC Device Connection to PC, 2) Check EFU status on LV32-BLDC', 'POCB_EFU_LV32BLDC');
  if SystemInfo.EfuIcuCntPerCH = 2 then begin
    SetAlarmInfo(DefPocb.ALARM_CH1_EFU_STATUS_NG, -1,DefPocb.ALARM_CLASS_LIGHT, 'CH1_EFU1_STATUS_NG',
        'CH1, EFU-1 Status NG', '1) Check EFU LV32-BLDC Device Connection to PC, 2) Check EFU status and reset on LV32-BLDC', 'POCB_EFU_LV32BLDC');
    SetAlarmInfo(DefPocb.ALARM_CH1_EFU2_STATUS_NG, -1,DefPocb.ALARM_CLASS_LIGHT, 'CH1_EFU2_STATUS_NG',
        'CH1, EFU-2 Status NG', '1) Check EFU LV32-BLDC Device Connection to PC, 2) Check EFU status and reset on LV32-BLDC', 'POCB_EFU_LV32BLDC');
    SetAlarmInfo(DefPocb.ALARM_CH2_EFU_STATUS_NG, -1,DefPocb.ALARM_CLASS_LIGHT, 'CH2_EFU1_STATUS_NG',
        'CH2, EFU-1 Status NG', '1) Check EFU LV32-BLDC Device Connection to PC, 2) Check EFU status and reset on LV32-BLDC', 'POCB_EFU_LV32BLDC');
    SetAlarmInfo(DefPocb.ALARM_CH2_EFU2_STATUS_NG, -1,DefPocb.ALARM_CLASS_LIGHT, 'CH2_EFU_STATUS_NG',
        'CH2, EFU-2 Status NG', '1) Check EFU LV32-BLDC Device Connection to PC, 2) Check EFU status and reset on LV32-BLDC', 'POCB_EFU_LV32BLDC');
  end
  else begin
    SetAlarmInfo(DefPocb.ALARM_CH1_EFU_STATUS_NG, -1,DefPocb.ALARM_CLASS_LIGHT, 'CH1_EFU_STATUS_NG',
        'CH1, EFU Status NG', '1) Check EFU LV32-BLDC Device Connection to PC, 2) Check EFU status and reset on LV32-BLDC', 'POCB_EFU_LV32BLDC');
    SetAlarmInfo(DefPocb.ALARM_CH2_EFU_STATUS_NG, -1,DefPocb.ALARM_CLASS_LIGHT, 'CH2_EFU_STATUS_NG',
        'CH2, EFU Status NG', '1) Check EFU LV32-BLDC Device Connection to PC, 2) Check EFU status and reset on LV32-BLDC', 'POCB_EFU_LV32BLDC');
  end;

  //2019-08-23 Ionizer
  if SystemInfo.IonizerCntPerCH = 2 then begin
    SetAlarmInfo(DefPocb.ALARM_CH1_IONIZER_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_LIGHT, 'CH1_IONIZER1_NOT_CONNECTED',
        'CH1, Ionizer-1 Device Disconnected', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
    SetAlarmInfo(DefPocb.ALARM_CH1_IONIZER_STATUS_NG,-1,DefPocb.ALARM_CLASS_LIGHT,'CH1_IONIZER1_STATUS_NG',
        'CH1, Ionizer-1 Status NG', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
    SetAlarmInfo(DefPocb.ALARM_CH1_IONIZER2_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_LIGHT, 'CH1_IONIZER2_NOT_CONNECTED',
        'CH1, Ionizer-2 Device Disconnected', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
    SetAlarmInfo(DefPocb.ALARM_CH1_IONIZER2_STATUS_NG,-1,DefPocb.ALARM_CLASS_LIGHT,'CH1_IONIZER2_STATUS_NG',
        'CH1, Ionizer-2 Status NG', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
    SetAlarmInfo(DefPocb.ALARM_CH2_IONIZER_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_LIGHT, 'CH2_IONIZER1_NOT_CONNECTED',
        'CH2, Ionizer-1 Device Disconnected', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
    SetAlarmInfo(DefPocb.ALARM_CH2_IONIZER_STATUS_NG, -1, DefPocb.ALARM_CLASS_LIGHT, 'CH2_IONIZER1_STATUS_NG',
        'CH2, Ionizer-1 Status NG', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
    SetAlarmInfo(DefPocb.ALARM_CH2_IONIZER2_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_LIGHT, 'CH2_IONIZER2_NOT_CONNECTED',
        'CH2, Ionizer-2 Device Disconnected', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
    SetAlarmInfo(DefPocb.ALARM_CH2_IONIZER2_STATUS_NG, -1, DefPocb.ALARM_CLASS_LIGHT, 'CH2_IONIZER2_STATUS_NG',
        'CH2, Ionizer-2 Status NG', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
  end
  else begin
    SetAlarmInfo(DefPocb.ALARM_CH1_IONIZER_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_LIGHT, 'CH1_IONIZER_NOT_CONNECTED',
        'CH1, Ionizer Device Disconnected', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
    SetAlarmInfo(DefPocb.ALARM_CH1_IONIZER_STATUS_NG,-1,DefPocb.ALARM_CLASS_LIGHT,'CH1_IONIZER_STATUS_NG',
        'CH1, Ionizer Status NG', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
    SetAlarmInfo(DefPocb.ALARM_CH2_IONIZER_NOT_CONNECTED, -1, DefPocb.ALARM_CLASS_LIGHT, 'CH2_IONIZER_NOT_CONNECTED',
        'CH2, Ionizer Device Disconnected', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
    SetAlarmInfo(DefPocb.ALARM_CH2_IONIZER_STATUS_NG, -1, DefPocb.ALARM_CLASS_LIGHT, 'CH2_IONIZER_STATUS_NG',
        'CH2, Ionizer Status NG', '1) Check Ionizer Device Connection to PC, 2) Check Ionizer device status', '');
  end;

{$IFDEF HAS_ROBOT_CAM_Z}
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_MODBUS_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_ROBOT_MODBUS_DISCONNECTED',
        'CH1, Robot ModBus TCP-Client Disconnected', '1) Check Robot connection to PC, 2) Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_COMMAND_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_ROBOT_COMMAND_DISCONNECTED',
        'CH1, Robot Command TCP-Server Disconnected', '1) Check Robot connection to PC, 2) Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_FATAL_ERROR, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH1_ROBOT_FATAL_ERROR',
        'CH1, Robot Status - Fatal Error', 'Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_PROJECT_NOT_RUNNING, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_ROBOT_STAUS_PROJECT_NOT_RUNNING',
        'CH1, Robot Status - Project NOT Running', 'Check Robot status', '');  //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_PROJECT_EDITING, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_ROBOT_STAUS_PROJECT_EDITING',
        'CH1, Robot Status - Project Editing', 'Check Robot status', '');  //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_PROJECT_PAUSE, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_ROBOT_STAUS_PROJECT_PAUSE',
        'CH1, Robot Status - Project Pause', 'Check Robot status?', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_GET_CONTROL, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_ROBOT_STAUS_GET_CONTROL',
        'CH1, Robot Status - Get Control', '1) Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_ESTOP, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH1_ROBOT_STAUS_ESTOP',
        'CH1, Robot Status - E-STOP', 'Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_CURR_COORD_NG, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH1_ROBOT_CURR_COORD_NG',
        'CH1, Robot Status - Current Coord is neither HOME nor MODEL Posision.', 'Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_NOT_AUTOMODE, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH1_ROBOT_NOT_AUTOMODE',
        'CH1, Robot Status - Not AUTO-MODE', 'Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_CANNOT_MOVE, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH1_ROBOT_CANNOT_MOVE',
        'CH1, Robot Status - Cannot Move', '1) Change Robot to Manual Mode, 2) Move Robot Position into Working area', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_HOME_COORD_MISMATCH, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH1_ROBOT_HOME_COORD_MISMATCH',
        'CH1, Robot Information - Home Coord Mismatch', '1) Check Home Coord of Robot, 2) Update Home Coord Information in System Information (SystemConfig.ini)', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_MODEL_COORD_MISMATCH, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH1_ROBOT_MODEL_COORD_MISMATCH',
        'CH1, Robot Information - Model Coord Mismatch', '1) Check Model Coord of Robot, 2) Update Model Coord Information in Model Information', '');
  SetAlarmInfo(DefPocb.ALARM_CH1_ROBOT_STANDBY_COORD_MISMATCH, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH1_ROBOT_STANDBY_COORD_MISMATCH',
        'CH1, Robot Information - Standby Coord Mismatch', '1) Check Standby Coord of Robot, 2) Update Standby Coord Information in System Information (SystemConfig.ini)', '');

  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_MODBUS_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_ROBOT_MODBUS_DISCONNECTED',
        'CH2, Robot ModBus TCP-Client Disconnected', '1) Check Robot connection to PC, 2) Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_COMMAND_DISCONNECTED, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_ROBOT_COMMAND_DISCONNECTED',
        'CH2, Robot Command TCP-Server Disconnected', '1) Check Robot connection to PC, 2) Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_FATAL_ERROR, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH2_ROBOT_FATAL_ERROR',
        'CH2, Robot Status - Fatal Error', 'Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_PROJECT_NOT_RUNNING, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_ROBOT_STAUS_PROJECT_NOT_RUNNING',
        'CH2, Robot Status - Project NOT Running', 'Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_PROJECT_EDITING, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_ROBOT_STAUS_PROJECT_EDITING',
        'CH2, Robot Status - Project Editing', 'Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_PROJECT_PAUSE, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_ROBOT_STAUS_PROJECT_PAUSE',
        'CH2, Robot Status - Project Pause', 'Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_GET_CONTROL, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_ROBOT_STAUS_GET_CONTROL',
        'CH2, Robot Status - Get Control', 'Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_ESTOP, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH2_ROBOT_STAUS_ESTOP',
        'CH2, Robot Status - E-STOP', '1) Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_CURR_COORD_NG, -1, DefPocb.ALARM_CLASS_SERIOUS, 'CH2_ROBOT_CURR_COORD_NG',
        'CH2, Robot Status - Current Coord is neither HOME nor MODEL Posision.', 'Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_NOT_AUTOMODE, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH2_ROBOT_NOT_AUTOMODE',
        'CH2, Robot Status - Not AUTO-MODE', 'Check Robot status', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_CANNOT_MOVE, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH2_ROBOT_CANNOT_MOVE',
        'CH2, Robot Status - Cannot Move', '1) Change Robot to Manual Mode, 2) Move Robot Position into Working area', ''); //TBD:A2CHv3:ROBOT? (Message)
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_HOME_COORD_MISMATCH, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH2_ROBOT_HOME_COORD_MISMATCH',
        'CH2, Robot Information - Home Coord Mismatch', '1) Check Home Coord of Robot, 2) Update Home Coord Information in System Information (SystemConfig.ini)', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_MODEL_COORD_MISMATCH, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH2_ROBOT_MODEL_COORD_MISMATCH',
        'CH2, Robot Information - Model Coord Mismatch', '1) Check Model Coord of Robot, 2) Update Model Coord Information in Model Information', '');
  SetAlarmInfo(DefPocb.ALARM_CH2_ROBOT_STANDBY_COORD_MISMATCH, -1, DefPocb.ALARM_CLASS_SAFETY, 'CH2_ROBOT_STANDBY_COORD_MISMATCH',
        'CH2, Robot Information - Standby Coord Mismatch', '1) Check Standby Coord of Robot, 2) Update Standby Coord Information in System Information (SystemConfig.ini)', '');
{$ENDIF}
end;

procedure TCommon.SetAlarmInfo(alarmNo: Integer; nDioIN: Integer; alarmClass: Integer;
                                alarmName: string; alarmMsg: string = ''; alarmMsg2: string = ''; sImageFile: string = '');
begin
  if (alarmNo <= 0) or (alarmNo > DefPocb.MAX_ALARM_NO)or (alarmClass = DefPocb.ALARM_CLASS_NONE) then begin
    Exit;
  end;
  AlarmList[alarmNo].AlarmNo    := alarmNo;
  AlarmList[alarmNo].AlarmClass := alarmClass;
  AlarmList[alarmNo].AlarmName  := alarmName;
  AlarmList[alarmNo].AlarmMSg   := alarmMsg;
  AlarmList[alarmNo].AlarmMSg2  := alarmMsg2;   //2019-03-29
  AlarmList[alarmNo].sDioIN     := IntToStr(nDioIN); //A2CHv3:ALARM
  AlarmList[alarmNo].bIsOn      := False;
  AlarmList[alarmNo].ImageFile  := sImageFile;
end;

procedure TCommon.SetAlarmInfo(alarmNo: Integer; sDioIN: string; alarmClass: Integer;
                               alarmName: string; alarmMsg: string = ''; alarmMsg2: string = ''; sImageFile: string = '');
begin
  if (alarmNo <= 0) or (alarmNo > DefPocb.MAX_ALARM_NO)or (alarmClass = DefPocb.ALARM_CLASS_NONE) then begin
    Exit;
  end;
  AlarmList[alarmNo].AlarmNo    := alarmNo;
  AlarmList[alarmNo].AlarmClass := alarmClass;
  AlarmList[alarmNo].AlarmName  := alarmName;
  AlarmList[alarmNo].AlarmMSg   := alarmMsg;
  AlarmList[alarmNo].AlarmMSg2  := alarmMsg2;
  AlarmList[alarmNo].sDioIN     := sDioIN; //A2CHv3:ALARM
  AlarmList[alarmNo].bIsOn      := False;
  AlarmList[alarmNo].ImageFile  := sImageFile;
end;

function TCommon.SetAlarmOnOff(alarmNo: Integer; bIsOn: Boolean): Boolean;
var
  bDioMotionAlarmOnOff : Boolean;
  bOldAlarm : Boolean;
  i         : Integer;
  sTemp, sDioNo : string;
begin
  bDioMotionAlarmOnOff := False;
  if (alarmNo <= 0) or (alarmNo > DefPocb.MAX_ALARM_NO) then begin
    Exit(False);
  end;
  if AlarmList[alarmNo].AlarmClass = DefPocb.ALARM_CLASS_NONE then begin
    Exit(False);
  end;
  //
  bOldAlarm := AlarmList[alarmNo].bIsOn;
  AlarmList[alarmNo].bIsOn := bIsOn;
  if bOldAlarm <> bIsOn then begin
    if AlarmList[alarmNo].sDioIn <> '-1' then sDioNo := AlarmList[alarmNo].sDioIN
    else                                      sDioNo := '-';
    sTemp := '<ALARM> Alarm#'+Format('%02d',[alarmNo])+',Dio-IN#('+sDioNo+'),'+AlarmList[alarmNo].AlarmName;
    { //2019-04-04 TBD:MLOG?
    if (Common <> nil) then begin
      if bIsOn then Common.MLog(DefPocb.SYS_LOG,sTemp+',ON')
      else          Common.MLog(DefPocb.SYS_LOG,sTemp+',OFF');
    end; }
  end;
  //
  if bIsOn then begin
    m_bAlarmOn := True;
    AlarmList[alarmNo].AlarmOnTime := Now;  //2019-04-02
    if AlarmList[alarmNo].AlarmClass = DefPocb.ALARM_CLASS_SAFETY then m_bSafetyAlarmOn := True;
  end
  else begin
    m_bSafetyAlarmOn := False;  //2019-04-17
    for i := 1 to DefPocb.MAX_ALARM_NO do begin
      if AlarmList[i].AlarmClass = DefPocb.ALARM_CLASS_SAFETY then begin
        if AlarmList[i].bIsOn then begin
          m_bSafetyAlarmOn := True;
          Break;
        end;
      end;
    end;
    m_bAlarmOn := False;
    for i := 1 to DefPocb.MAX_ALARM_NO do begin
      if AlarmList[i].AlarmClass <> DefPocb.ALARM_CLASS_NONE then begin
        if AlarmList[i].bIsOn then begin
          m_bAlarmOn := True;
          Break;
        end;
      end;
    end;
  end;
  //
  if (alarmNo in [DefPocb.ALARM_DIO_FIRST..DefPocb.ALARM_DIO_LAST])
     or (alarmNo in [DefPocb.ALARM_CH1_MOTION_Y_DISCONNECTED..DefPocb.ALARM_CH1_MOTION_Y_MODEL_POS_NG])
     or (alarmNo in [DefPocb.ALARM_CH2_MOTION_Y_DISCONNECTED..DefPocb.ALARM_CH2_MOTION_Y_MODEL_POS_NG])
		{$IFDEF HAS_MOTION_CAM_Z}
     or (alarmNo in [DefPocb.ALARM_CH1_MOTION_Z_DISCONNECTED..DefPocb.ALARM_CH1_MOTION_Z_MODEL_POS_NG])
     or (alarmNo in [DefPocb.ALARM_CH2_MOTION_Z_DISCONNECTED..DefPocb.ALARM_CH2_MOTION_Z_MODEL_POS_NG])
		{$ENDIF}
		{$IFDEF HAS_ROBOT_CAM_Z}
     or (alarmNo in [DefPocb.ALARM_CH1_ROBOT_MODBUS_DISCONNECTED..DefPocb.ALARM_CH1_ROBOT_STANDBY_COORD_MISMATCH])
     or (alarmNo in [DefPocb.ALARM_CH2_ROBOT_MODBUS_DISCONNECTED..DefPocb.ALARM_CH2_ROBOT_STANDBY_COORD_MISMATCH])
		{$ENDIF}
  then begin
    bDioMotionAlarmOnOff := True;  end;  //  Result := bDioMotionAlarmOnOff;end;

function TCommon.IsAlarmOn(alarmNo: Integer): Boolean;  //2019-04-26
var
  bIsOn : Boolean;
begin
  if (alarmNo <= 0) or (alarmNo > DefPocb.MAX_ALARM_NO) then begin
    Exit(False);
  end;
  if AlarmList[alarmNo].AlarmClass = DefPocb.ALARM_CLASS_NONE then begin
    Exit(False);
  end;
  //
  bIsOn  := AlarmList[alarmNo].bIsOn;
  Result := bIsOn;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC]
//
procedure TCommon.MakeDpc2GpcNgCodes;  //2019-01-15 CAM: DPC2GPC TEND NgCodes (TEND ErrorCode)
var
  nTemp : Integer;
begin
	// Init Table
  for nTemp := 0 to DefCam.DPC2GPC_NGCODE_MAX do begin
    m_Dpc2GpcNgCodes[nTemp].DefectCode := '';
    m_Dpc2GpcNgCodes[nTemp].DefectName := 'Undefined TEND Error';
    m_Dpc2GpcNgCodes[nTemp].MesCodeSummary := '';
    m_Dpc2GpcNgCodes[nTemp].MesCodeRwk     := '';
    m_Dpc2GpcNgCodes[nTemp].CamAlarmSuppMsg:= '';
  end;

  // INI/MES_CODE.csv  ...AUTO

{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)} //2019-06-20
  //TBD:FOLD?
  //TBD:GAGO?
{$ENDIF}
end;

procedure TCommon.LoadSerialMatch;
var
  sFileName : string;
begin
  if not SystemInfo.UseSeialMatch then Exit;
  
  if SystemInfo.MatchSerialFolder = '' then Exit;
  
  sFileName := SystemInfo.MatchSerialFolder + 'SerialMatch.txt';

  m_slSerialNo.Clear;

  if FileExists(sFileName) then begin
    m_slSerialNo.LoadFromFile(sFileName);
  end;
end;

procedure TCommon.SetEdModel2TestModel;  //A2CHv3:MULTIPLE_MODEL
var
  nCh : Integer;
begin
  for nCh := DefPocb.CH_1 to DefPocb.CH_2 do begin
    Common.TestModelInfo[nCh]     := Common.EdModelInfo[nCh];
    Common.TestModelInfo2[nCh]    := Common.EdModelInfo2[nCh];
    Common.TestModelInfoALDP[nCh] := Common.EdModelInfoALDP[nCh];
    //
    Common.m_ModelCrc[nCh].ModelMcf      := Common.GetModelMcfCrc(nCh);      //2022-09-15 (GetModelCrc -> GetModelMcfCrc)
    Common.m_ModelCrc[nCh].ModelParamCsv := Common.GetModelParamCsvCrc(nCh); //2022-09-15
  end;
end;

procedure TCommon.SendModelData(nCh: Integer; nPgSpi: integer=2); //nPgSPi(0:PG,1:SPI,2:ALL)
begin
  // PG (DP489|DP200|DP201)
  if nPgSpi <> 1 then begin
    ThreadTask(procedure begin
      Pg[nCh].SendPgOpModel;  //#Logic.SendOpData
      Sleep(100);
      if Common.SystemInfo.PG_TYPE <> PG_TYPE_DP489 then begin //DP200|DP201
        case Common.TestModelInfo[nCh].SigType of
          DefPG.PG_MODELINFO_SIGTYPE_eDP4Lane,        //2 //ALDP
          DefPG.PG_MODELINFO_SIGTYPE_eDP8Lane: begin  //3 //ALDP
            Pg[nCh].SendPgOpModelALDP;
          end;
          else begin
            // No ALDP
          end;
        end;
      end;
    end);
  end;
  // SPI/QSPI (DJ021|DJ201|DJ023)
  if nPgSpi <> 0 then begin
    ThreadTask(procedure begin
      Pg[nCh].SendSpiModelInfo;
    end);
  end;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] procedureTCommon.MakePatternData(nIdx : Integer;makePatGrp : TPatternGroup; var dCheckSum: dword; var nTotalSize: Integer; var Data: TArray<System.Byte>)
//      Called-by: procedure TfrmModelDownload.FormCreate(Sender: TObject);
//
procedure TCommon.MakePatternData(nCh: Integer; nIdx : Integer;makePatGrp : TPatternGroup; var dCheckSum: dword; var nTotalSize: Integer; var Data: TArray<System.Byte>);  //A2CHv3:MULTIPLE_MODEL
var
  nToolCnt, nCnt : Integer;
//DownPatInfo             : RDownPatInfo;
  i, nPatNum              : Integer;
  sBmpName                : string[32];
  sCrcData   , sTemp      : AnsiString;
//btToolNo                : Byte;
  sPatName                : string;
  wTemp : Word;
begin
  dCheckSum := 0;
  nTotalSize := 0;

  if makePatGrp.PatType[nIdx] = PTYPE_BITMAP then begin
    nPatNum  := 0; //dummay for PTYPE_BITMAP
    nToolCnt := 0;
    nTotalSize := 32 ; // Pattern Name.
  end
  else begin
    sTemp := AnsiString(makePatGrp.PatName[nIdx]);
    for i := 0 to pred(MAX_PATTERN_CNT) do begin
      sPatName := StrPas(loadAllPat.InfoPat[i].pat.Data.PatName);
      nPatNum := i;
      if sPatName = sTemp then Break;
    end;
    nToolCnt := loadAllPat.InfoPat[nPatNum].pat.Data.ToolCnt;
    nTotalSize := 22 * nToolCnt;
  end;
  nTotalSize := nTotalSize + 3; // nIdx, pat type, tool count.
  SetLength(Data,nTotalSize);

  nCnt := 0;
  Data[nCnt] := Byte(nIdx);                          Inc(nCnt); // pattern No.
  Data[nCnt] := Byte(makePatGrp.PatType[nIdx]+1);    Inc(nCnt); // Pattern Type : 1 : Complex Pattern, 2 : BMP
  Data[nCnt] := Byte(nToolCnt);                      Inc(nCnt); // Tool Count.
  case makePatGrp.PatType[nIdx] of
    DefPG.PTYPE_BITMAP : begin
      sBmpName := makePatGrp.PatName[nIdx];
      CopyMemory(@Data[nCnt],@sBmpName[0],32);       // nCnt := nCnt + 32;
    end;
    DefPG.PTYPE_NORMAL : begin
      for i := 0 to Pred(nToolCnt) do begin
        Data[nCnt] := loadAllPat.InfoPat[nPatNum].Tool[i].Data.ToolType;   Inc(nCnt); // Tool Type.
        Data[nCnt] := loadAllPat.InfoPat[nPatNum].Tool[i].Data.Direction;  Inc(nCnt); // Direction.
        wTemp := loadAllPat.InfoPat[nPatNum].Tool[i].Data.Level;
        CopyMemory(@Data[nCnt],@wTemp,2);                               Inc(nCnt); Inc(nCnt); // Level

        sTemp := StrPas(loadAllPat.InfoPat[nPatNum].Tool[i].Data.sx);
        wTemp := GetDrawPosPG(nCh,sTemp);
        CopyMemory(@Data[nCnt],@wTemp,2);                               Inc(nCnt); Inc(nCnt); // sx

        sTemp := StrPas(loadAllPat.InfoPat[nPatNum].Tool[i].Data.sy);
        wTemp := GetDrawPosPG(nCh,sTemp);
        CopyMemory(@Data[nCnt],@wTemp,2);                               Inc(nCnt); Inc(nCnt); // sy

        sTemp := StrPas(loadAllPat.InfoPat[nPatNum].Tool[i].Data.ex);
        wTemp := GetDrawPosPG(nCh,sTemp);
        CopyMemory(@Data[nCnt],@wTemp,2);                               Inc(nCnt); Inc(nCnt); // ex

        sTemp := StrPas(loadAllPat.InfoPat[nPatNum].Tool[i].Data.ey);
        wTemp := GetDrawPosPG(nCh,sTemp);
        CopyMemory(@Data[nCnt],@wTemp,2);                               Inc(nCnt); Inc(nCnt); // ey

        sTemp := StrPas(loadAllPat.InfoPat[nPatNum].Tool[i].Data.mx);
        wTemp := GetDrawPosPG(nCh,sTemp);
        CopyMemory(@Data[nCnt],@wTemp,2);                               Inc(nCnt); Inc(nCnt); // mx

        sTemp := StrPas(loadAllPat.InfoPat[nPatNum].Tool[i].Data.my);
        wTemp := GetDrawPosPG(nCh,sTemp);
        CopyMemory(@Data[nCnt],@wTemp,2);                               Inc(nCnt); Inc(nCnt); // my

        wTemp := loadAllPat.InfoPat[nPatNum].Tool[i].Data.R;
        CopyMemory(@Data[nCnt],@wTemp,2);                               Inc(nCnt); Inc(nCnt); // r

        wTemp := loadAllPat.InfoPat[nPatNum].Tool[i].Data.G;
        CopyMemory(@Data[nCnt],@wTemp,2);                               Inc(nCnt); Inc(nCnt); // g

        wTemp := loadAllPat.InfoPat[nPatNum].Tool[i].Data.B;
        CopyMemory(@Data[nCnt],@wTemp,2);                               Inc(nCnt); Inc(nCnt); // b
      end;
    end;
  end;

  sCrcData := '';
  for i := 0 to Pred(nTotalSize) do begin
    sCrcData := sCrcData + AnsiChar(Data[i]);
  end;
  dCheckSum := crc16(sCrcData,nTotalSize);
//  nTotalSize := nTotalSize + 2; // Total size + crc.
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.MakeRawData(bmpB: TBitmap; var RawData: TIdBytes)
//      Called-by: procedure TCamComm.BmpDownload(nCam: Integer; const AContext: TIdContext);
//      Called-by: procedure TfrmMainter.BmpDownloadBuff(nCh: Integer; nIdx: Integer = 0);
//
procedure TCommon.MakeRawData(bmpB: TBitmap; var RawData: TIdBytes);
var
  i,j, nTemp, nType : Integer;
  nHeight, nWidth : Integer;
  nDiv, nMod : Integer;
  RawDataBmp : array of byte;
begin

  nHeight := bmpB.Height;
  nWidth  := bmpB.Width;
  SetLength(RawDataBmp,nHeight*nWidth*3);
  for i := 0 to Pred(nHeight) do begin
    CopyMemory(@RawDataBmp[i*nWidth*3],bmpB.ScanLine[i],nWidth*3);
  end;
  nDiv := (nWidth div 2048);
  nMod := (nWidth mod 2048);
  if nMod > 0 then nDiv := nDiv + 1;
  nType := nDiv * 2048;  //~2048(2048), ~4096(4096), ~6144(6144), ~8192(8192)  //TBD:A2CHv4:LUCID
  for i := 0 to Pred(nHeight) do begin
    nTemp := i*nType*3;
    for j := 0 to Pred(nType) do begin
      if nWidth > j then begin
        RawData[nTemp+j]             :=  RawDataBmp[nWidth*i*3+j*3];              // B
        RawData[nTemp + nType+j]     :=  RawDataBmp[nWidth*i*3+j*3+1];    // G
        RawData[nTemp + nType*2 +j]  :=  RawDataBmp[nWidth*i*3+j*3+2]; // R
      end
      else begin
        RawData[nTemp+j] :=  0;            // B
        RawData[nTemp + nType+j] :=  0;    // G
        RawData[nTemp + nType*2 +j] :=  0; // R
      end;
    end;
  end;
end;

procedure TCommon.MakeFile(sFileName, sHeader, sData : string; nNo : Integer = 0; bForceDirectories: Boolean = False);
var
  sTempFileName, sExt, sName : string;
	txtF : Textfile;
  bIOError : Boolean;
begin
  if not CheckMakeDir(ExtractFileDir(sFileName),bForceDirectories) then Exit;
  bIOError := False;

  if nNo > 0 then begin
    sExt          := ExtractFileExt(sFileName);
    sName         := sFileName.Substring(0, sFileName.LastDelimiter('.'));
    sTempFileName := Format('%s_%d%s',[sName, nNo, sExt])
  end
  else sTempFileName := sFileName;

  if IOResult = 0 then begin
    try
      try
        FileSetReadOnly(sTempFileName, False);
        AssignFile(txtF, sTempFileName);

        // File Check!
        if not FileExists(sTempFileName) then begin
          Rewrite(txtF);
          if sHeader <> '' then WriteLn(txtF, sHeader);
        end;

        Append(txtF); //Exception
        WriteLn(txtF, sData);
      except
        on e: EInOutError do
        begin
          if ExtractFileExt(sFileName) = 'csv' then begin
            if e.ErrorCode = 32 then begin
              bIOError := True;
              TThread.CreateAnonymousThread(procedure begin
                if nNo = 0 then MessageDlg('Opened File'+ #13 + #10 + ExtractFileName(sTempFileName),mtError,[mbOk], 0);
              end).Start;
              MakeFile(sFileName, sHeader, sData, nNo + 1);
            end;
          end;
        end;
      end;
    finally
      // Close the file
      try    //2022-12-06
        if not bIOError then begin
         CloseFile(txtF); //Exception
         FileSetReadOnly(sTempFileName, True);
        end;
      except //2022-12-06
      end;

    end;
  end;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.MakeSummaryCsvLog(sHeader, sData: string)
//      Called-by: procedure TfrmMain.WMCopyData(var Msg: TMessage); //MSG_TYPE_LOGIC/MSG_MODE_MAKE_SUMMARY_CSV
//
procedure TCommon.MakeSummaryCsvLog(nCh: Integer; sHeader, sData: string);  //A2CHv3:MULTIPLE_MODEL
var
  sFileName, sFilePath : string;
  nowDateTime : TDateTime;
begin
  if (sHeader = '') or (sData = '') then Exit;

  nowDateTime := Now;
  if SystemInfo.UseLogUploadPath then
    {$IFDEF SITE_LENSVN}
    sFilePath := Path.SumCsv + FormatDateTime('mm',nowDateTime)+'\' + FormatDateTime('dd',nowDateTime)+'\' + TestModelInfo2[nCh].LogUploadPanelModel+'\' + SystemInfo.EQPId+'\' //2023-09-20 LOG_UPLOAD (LENS:MM/DD/<PanelModeName>/)
    {$ELSE}
    sFilePath := Path.SumCsv + FormatDateTime('mm',nowDateTime)+'\' + SystemInfo.EQPId+'\' //2022-07-25 LOG_UPLOAD (VH:MM/)
    {$ENDIF}
  else
    sFilePath := Path.SumCsv + FormatDateTime('yyyymm',nowDateTime) + '\';

	{$IF Defined(PANEL_FOLD)}
	sFileName := sFilePath + SystemInfo.EQPId +'_POCB_'+ FormatDateTime('yyyymmdd',nowDateTime) + '_' + SystemInfo.TestModel + '.csv';
	{$ELSE}
    {$IFDEF SITE_LENSVN}
  sFileName := sFilePath + SystemInfo.EQPId +'_'+ TestModelInfo2[nCh].LogUploadPanelModel +'_'+ FormatDateTime('yyyymmdd', nowDateTime) + '.csv'; //2023-10-18
    {$ELSE}
  sFileName := sFilePath + SystemInfo.EQPId +'_'+FormatDateTime('yyyymmdd', nowDateTime)+'_'+ SystemInfo.TestModel[nCh] + '.csv';
    {$ENDIF}
	{$ENDIF}
  MakeFile(sFileName, sHeader, sData, 0, True{bForceDirectories}); //2022-07-25 LOG_UPLOAD (add bForceDirectories)
end;

procedure TCommon.MakeApdrCsvLog(nCh: Integer; sHeader, sData: string);  //2022-07-30
var
  sFileName, sFilePath : string;
  nowDateTime : TDateTime;
begin
  if (sHeader = '') or (sData = '') then Exit;

  nowDateTime := Now;
  if SystemInfo.UseLogUploadPath then
    {$IFDEF SITE_LENSVN}
    sFilePath := Path.ApdrLog + FormatDateTime('mm',nowDateTime)+'\' + FormatDateTime('dd',nowDateTime)+'\' + TestModelInfo2[nCh].LogUploadPanelModel+'\' + SystemInfo.EQPId+'\' //2023-09-20 LOG_UPLOAD (LENS:MM/DD/<PanelModeName>/)
    {$ELSE}
    sFilePath := Path.ApdrLog + FormatDateTime('mm',nowDateTime)+'\' + SystemInfo.EQPId+'\' //2022-07-25 LOG_UPLOAD (VH:MM/)
    {$ENDIF}
  else
    sFilePath := Path.ApdrLog + FormatDateTime('yyyymm',nowDateTime) + '\';
  {$IFDEF SITE_LENSVN}
  sFileName := sFilePath + 'ApdrLog_' + SystemInfo.EQPId +'_'+TestModelInfo2[nCh].LogUploadPanelModel +'_'+FormatDateTime('yyyymmdd', nowDateTime) + '.csv';
  {$ELSE}
  sFileName := sFilePath + 'ApdrLog_' + SystemInfo.EQPId +'_'+FormatDateTime('yyyymmdd', nowDateTime)+'_'+SystemInfo.TestModel[nCh] + '.csv';
  {$ENDIF}
  MakeFile(sFileName, sHeader, sData, 0, True{bForceDirectories}); //2022-07-25 LOG_UPLOAD (add bForceDirectories)
end;

procedure TCommon.MakeErrorLog(sHeader, sData: string);  //2022-12-06
var
  sFileName, sFilePath : string;
  nowDateTime : TDateTime;
begin
  if (sHeader = '') or (sData = '') then Exit;

  nowDateTime := Now;
  sFilePath := Path.ErrorLog + FormatDateTime('yyyymm',nowDateTime) + '\';
  sFileName := sFilePath + 'ErrorLog_' + SystemInfo.EQPId +'_'+FormatDateTime('yyyymmdd', nowDateTime) + '.txt';

  // Set R/W
{$IFDEF XXX}
  if FileExists(sFileName) then begin
  //if FileSetAttr(sFileName,FileGetAttr(sFileName) and (not faReadOnly)) <> NO_ERROR then begin
    if not FileSetReadOnly(sFileName, False) then begin
      //RaiseLastOSError;
    end;
  end;
{$ENDIF}

  MakeFile(sFileName, sHeader, sData, 0, True{bForceDirectories}); //2022-07-25 LOG_UPLOAD (add bForceDirectories)

  // Set R/O
{$IFDEF XXX}
  if System.SysUtils.FileSetAttr(sFileName,FileGetAttr(sFileName) or faReadOnly or faSysFile) <> NO_ERROR then begin
//if not FileSetReadOnly(sFileName, True) then begin
//if not FileSetAttr(sFileName, True) then begin
    //RaiseLastOSError;
  end;
{$ENDIF}
end;

procedure TCommon.MakeDioLog(sHeader,sData: string);  //2023-05-02
var
  sFileName, sFilePath : string;
  nowDateTime : TDateTime;
begin
  if (sHeader = '') or (sData = '') then Exit;

  nowDateTime := Now;
  sFilePath := Path.DioLog + FormatDateTime('yyyymm',nowDateTime) + '\';
  sFileName := sFilePath + 'DioLog_' + SystemInfo.EQPId +'_'+FormatDateTime('yyyymmdd', nowDateTime) + '.txt';

  // Set R/W
{$IFDEF XXX}
  if FileExists(sFileName) then begin
  //if FileSetAttr(sFileName,FileGetAttr(sFileName) and (not faReadOnly)) <> NO_ERROR then begin
    if not FileSetReadOnly(sFileName, False) then begin
      //RaiseLastOSError;
    end;
  end;
{$ENDIF}

  MakeFile(sFileName, sHeader, sData, 0, True{bForceDirectories}); //2022-07-25 LOG_UPLOAD (add bForceDirectories)

  // Set R/O
{$IFDEF XXX}
  if System.SysUtils.FileSetAttr(sFileName,FileGetAttr(sFileName) or faReadOnly or faSysFile) <> NO_ERROR then begin
//if not FileSetReadOnly(sFileName, True) then begin
//if not FileSetAttr(sFileName, True) then begin
    //RaiseLastOSError;
  end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.Make_Bmp_List;
//      Called-by: procedure TfrmSystemSetup.btnSysConfBmpDownClick(Sender: TObject);
//      Called-by: //NOT-USED?  procedure TfrmMain.Menu_DataDownloadClick(Sender: TObject);
//
procedure TCommon.Make_Bmp_List;
var
  iniF : TIniFile;
  image_fn : string;
  bList, sList, dList : TStringList;
  sr : TSearchrec;
  rslt, i : Integer;
  bmp1 : TBitmap;
begin

  image_fn := Path.BMP + 'image.lst';
  if FileExists(image_fn) then DeleteFile(image_fn);

  bList := TStringList.Create;
  sList := TStringList.Create;
  try
    rslt := FindFirst(Path.BMP + '*.bmp', FaanyFile, sr);
    while rslt = 0 do begin
     bList.Add(sr.Name);
     rslt := FindNext(sr);
    end;
    bmp1 := TBitmap.Create;
    try
      for i := 0 to bList.Count -1 do begin
         try
           bmp1.LoadFromFile(Path.BMP + bList[i]);
           if bmp1.PixelFormat = pf24bit then
             sList.Add(Format('%dx%d,%s',[bmp1.Width,bmp1.Height, bList[i]]));
         except end;
         Delay(2);
      end;
    finally
      bmp1.Free;
    end;
    sList.Sort;

    //Make Imagefile list
    iniF := TIniFile.Create(image_fn);
    try
      with iniF do begin
        dList := TStringList.Create;
        for i := 0 to sList.Count -1 do begin
          //DebugMessage(Format('bmpList %d: %s',[i, sList[i]]));
          dList.CommaText := sList[i];
          WriteString(dList[0], dList[1], '');
        end;
        dList.Free;

      end;
    finally
      iniF.Free;
      WritePrivateProfileString(nil, nil, nil, PChar(image_fn));
    end;
  finally
    sList.Free;
    bList.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TCommon.MLog(nCh: Integer; const Msg: String);
var
  sInputData, sFileName, sDate, sFilePath: String;
  nowDateTime : TDateTime;
  sLogUploadModelCh1, sLogUploadModelCh2 : string;
begin
  if (Self = nil) then Exit;
  if (Common = nil) then Exit;
  if (not (nCh in [DefPocb.CH_1, DefPocb.CH_2, DefPocb.CH_ALL])) and (nCh <> DefPocb.SYS_LOG) then Exit;

//  DebugMessage('[MLog] ' + Msg);
  if not CheckMakeDir(Path.MLOG) then begin
    Exit;
  end;
  //
  nowDateTime := Now;
  sDate := FormatDateTime('yyyymmdd', nowDateTime);

  //
  try
    sInputData := FormatDateTime('(hh:mm:ss.zzz) : ', nowDateTime) + Msg + #13#10;
    case nCh of
      DefPocb.SYS_LOG : begin
				nCh := DefPocb.CH_1; //!!!
        if SystemInfo.UseLogUploadPath then
          sFilePath := Path.MLOG + FormatDateTime('mm', nowDateTime)+'\'
                  {$IFDEF SITE_LENSVN}
                    + FormatDateTime('dd', nowDateTime)+'\' + TestModelInfo2[nCh].LogUploadPanelModel+'\'  //2023-09-20 LOG_UPLOAD (LENS:MM/DD/<PanelModeName>/<Station>)
                  {$ENDIF}
                    + Common.SystemInfo.EQPId+'\' //2022-07-25 LOG_UPLOAD (VH:MM/<Station>)
        else
          sFilePath := Path.MLOG + sDate + '\';
        if not CheckMakeDir(sFilePath,True{bForceDirectories}) then Exit;
        {$IFDEF SITE_LENSVN}
        sFileName := sFilePath + Format('MLog_%s_%s_%s_SYS.txt',[SystemInfo.EQPId,TestModelInfo2[nCh].LogUploadPanelModel,sDate]);
        {$ELSE}
        sFileName := sFilePath + Format('MLog_%s_%s_SYS.txt',[SystemInfo.EQPId,sDate]);
        {$ENDIF}
        TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
      end;

      DefPocb.CH_1, DefPocb.CH_2 : begin
        if SystemInfo.UseLogUploadPath then
          sFilePath := Path.MLOG + FormatDateTime('mm', nowDateTime)+'\'
                  {$IFDEF SITE_LENSVN}
                    + FormatDateTime('dd', nowDateTime)+'\' + TestModelInfo2[nCh].LogUploadPanelModel+'\'  //2023-09-20 LOG_UPLOAD (LENS:MM/DD/<PanelModeName>/<Station>)
                  {$ENDIF}
                    + Common.SystemInfo.EQPId+'\' //2022-07-25 LOG_UPLOAD (VH:MM/<Station>)
        else
          sFilePath := Path.MLOG + sDate + '\';
        if not CheckMakeDir(sFilePath,True{bForceDirectories}) then Exit;
        {$IFDEF SITE_LENSVN}
        sFileName := sFilePath + Format('MLog_%s_%s_%s_Ch%d.txt',[SystemInfo.EQPId,TestModelInfo2[nCh].LogUploadPanelModel,sDate,nCh+1]);
        {$ELSE}
        sFileName := sFilePath + Format('MLog_%s_%s_Ch%d.txt',[systemInfo.EQPId,sDate,nCh+1]);
        {$ENDIF}
        TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
      end;

      DefPocb.CH_ALL : begin
        if SystemInfo.UseLogUploadPath then
          sFilePath := Path.MLOG + FormatDateTime('mm', nowDateTime)+'\'
                  {$IFDEF SITE_LENSVN}
                    + FormatDateTime('dd', nowDateTime)+'\' + TestModelInfo2[DefPocb.CH_1].LogUploadPanelModel+'\'  //2023-09-20 LOG_UPLOAD (LENS:MM/DD/<PanelModeName>/<Station>)
                  {$ENDIF}
                    + Common.SystemInfo.EQPId+'\' //2022-07-25 LOG_UPLOAD (VH:MM/<Station>)
        else
          sFilePath := Path.MLOG + sDate + '\';
        if not CheckMakeDir(sFilePath,True{bForceDirectories}) then Exit;
        {$IFDEF SITE_LENSVN}
        sFileName := sFilePath + Format('MLog_%s_%s_%s_Ch1.txt',[SystemInfo.EQPId,TestModelInfo2[DefPocb.CH_1].LogUploadPanelModel,sDate]);
        {$ELSE}
        sFileName := sFilePath + Format('MLog_%s_%s_Ch1.txt',[SystemInfo.EQPId,sDate]);
        {$ENDIF}
        TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
        //
        if SystemInfo.UseLogUploadPath then
          sFilePath := Path.MLOG + FormatDateTime('mm', nowDateTime)+'\'
                  {$IFDEF SITE_LENSVN}
                    + FormatDateTime('dd', nowDateTime)+'\' + TestModelInfo2[DefPocb.CH_2].LogUploadPanelModel+'\'  //2023-09-20 LOG_UPLOAD (LENS:MM/DD/<PanelModeName>/<Station>)
                  {$ENDIF}
                    + Common.SystemInfo.EQPId+'\' //2022-07-25 LOG_UPLOAD (VH:MM/<Station>)
        else
          sFilePath := Path.MLOG + sDate + '\';
        if not CheckMakeDir(sFilePath,True{bForceDirectories}) then Exit;
        {$IFDEF SITE_LENSVN}
        sFileName := sFilePath + Format('MLog_%s_%s_%s_Ch2.txt',[SystemInfo.EQPId,TestModelInfo2[DefPocb.CH_2].LogUploadPanelModel,sDate]);
        {$ELSE}
        sFileName := sFilePath + Format('MLog_%s_%s_Ch2.txt',[systemInfo.EQPId,sDate]);
        {$ENDIF}
        TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
      end;
    end;
  except
  end;
end;

procedure TCommon.ChangeDebugLogLevel(nDevType: Integer; nLogLevel: Integer);  //2020-09-16 DEBUG_LOG
var
  _infile : TextFile;
  sDevType, sMonth, sDate, sFilePath, sFileName, sLogLevel, sLogData : String;
  nCh : Integer;
  nowDateTime : TDateTime;
begin
  if not (nDevType in [DEBUG_LOG_DEVTYPE_PG..DEBUG_LOG_DEVTYPE_MAX]) then Exit;
  //
  if (nLogLevel = DEBUG_LOG_LEVEL_CONFIG_INI) then begin
    m_nDebugLogLevelActive[nDevType] := Common.SystemInfo.DebugLogLevelConfig[nDevType];
  end
  else if (nLogLevel in [DEBUG_LOG_LEVEL_NONE..DEBUG_LOG_LEVEL_MAX]) then begin
    m_nDebugLogLevelActive[nDevType] := nLogLevel;
  end
  else begin
    Exit;
  end;
  //
  case nDevType of
    DEBUG_LOG_DEVTYPE_PG:    sDevType := 'PG';
    DEBUG_LOG_DEVTYPE_SPI:   sDevType := 'SPI';
    {$IFDEF DF136_USE}
    DEBUG_LOG_DEVTYPE_DF136: sDevType := 'DF136';
    {$ENDIF}
    else Exit;
  end;
  if (nLogLevel = DEBUG_LOG_LEVEL_CONFIG_INI) then sLogLevel := 'SystemConfig / ' else sLogLevel := '';
  case m_nDebugLogLevelActive[nDevType] of
    DEBUG_LOG_LEVEL_NONE:      sLogLevel := sLogLevel + 'NONE';
    DEBUG_LOG_LEVEL_INSPECT:   sLogLevel := sLogLevel + 'INSPECT';
    DEBUG_LOG_LEVEL_POWERREAD: sLogLevel := sLogLevel + 'INSPECT|POWERREAD';
    DEBUG_LOG_LEVEL_CONNCHECK: sLogLevel := sLogLevel + 'INSPECT|POWERREAD|CONNCHECK';
    DEBUG_LOG_LEVEL_DOWNDATA:  sLogLevel := sLogLevel + 'INSPECT|POWERREAD|CONNCHECK|DOWNDATA';
    else Exit;
  end;
  // write log to file
  nowDateTime := Now;
  sMonth := FormatDateTime('yyyymm', nowDateTime);
  sDate  := FormatDateTime('yyyymmdd', nowDateTime);
  sFilePath := Path.DebugLog + sMonth + '\'; //2022-07-25 (yyyymmdd -> yyyymm)
  if not CheckMakeDir(sFilePath) then Exit;		
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    sFileName := sFilePath + Format('DebugLog_%s_%s_Ch%d_%s.txt',[SystemInfo.EQPId,sDate,nCh+1,sDevType]);
    try
      try
        AssignFile(_infile, sFileName);
        if not FileExists(sFileName) then
          Rewrite(_infile)
        else
          Append(_infile);
        sLogData := FormatDateTime('(hh:mm:ss.zzz) : ', Now) + 'CHANGE DEBUG LOG LEVEL - ' + sLogLevel;
        WriteLn(_infile, sLogData);
      except
      end;
    finally
      CloseFile(_infile);
    end;
  end;
end;

procedure TCommon.DebugLog(nCh, nDevType, nMsgType: Integer; sRTX, sIP: string; buff: TIdBytes); //2020-09-16 DEBUG_LOG
var
  sInputData, sFileName, sMonth, sDate, sFilePath: String;
  nMsgLevel : Integer;
  sDevType  : String;
  sIpText   : string;
  nowDateTime : TDateTime;
begin
  if (Self = nil) then Exit;
  if (Common = nil) then Exit;
  if (not (nCh in [DefPocb.CH_1, DefPocb.CH_2, DefPocb.CH_ALL])) and (nCh <> DefPocb.SYS_LOG) then Exit;
  //
  if not (nDevType in [DEBUG_LOG_DEVTYPE_PG..DEBUG_LOG_DEVTYPE_MAX]) then Exit;
  if not (nMsgType in [DEBUG_LOG_MSGTYPE_INSPECT..DEBUG_LOG_MSGTYPE_MAX]) then Exit;
  // check if msg type is higher than active debug log level
  case nMsgType of
    DEBUG_LOG_MSGTYPE_INSPECT:   nMsgLevel := DEBUG_LOG_LEVEL_INSPECT;
    DEBUG_LOG_MSGTYPE_POWERREAD: nMsgLevel := DEBUG_LOG_LEVEL_POWERREAD;
    DEBUG_LOG_MSGTYPE_CONNCHECK: nMsgLevel := DEBUG_LOG_LEVEL_CONNCHECK;
    DEBUG_LOG_MSGTYPE_DOWNDATA:  nMsgLevel := DEBUG_LOG_LEVEL_DOWNDATA;
    else nMsgLevel := DEBUG_LOG_LEVEL_INSPECT;
  end;

  if (m_nDebugLogLevelActive[nDevType] < nMsgLevel) then Exit;
  //
  case nDevType of
    DEBUG_LOG_DEVTYPE_PG:    sDevType := 'PG';
    DEBUG_LOG_DEVTYPE_SPI:   sDevType := 'SPI';
    {$IFDEF DF136_USE}
    DEBUG_LOG_DEVTYPE_DF136: sDevType := 'DF136';    
    {$ENDIF}
    else Exit;
  end;
  // write log to file
  nowDateTime := Now;
  sMonth := FormatDateTime('yyyymm', nowDateTime);
  sDate  := FormatDateTime('yyyymmdd', nowDateTime);
  sFilePath := Path.DebugLog + sMonth + '\'; //2022-07-25 (yyyymmdd -> yyyymm)
  if not CheckMakeDir(sFilePath) then Exit;
  //
  try
    sIpText    := '[' + sRTX + ' - ' + sIP + '] : ';
    sInputData := FormatDateTime('(hh:mm:ss.zzz) : ', nowDateTime) + sIpText + UserUtils.Hex2String(buff) + #13#10;
    case nCh of
      DefPocb.SYS_LOG : begin
        sFileName := sFilePath + Format('DebugLog_%s_%s_SYS.txt',[SystemInfo.EQPId,sDate]);
        TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
      end;
      DefPocb.CH_1, DefPocb.CH_2, DefPocb.CH_ALL: begin
        if (nCh = DefPocb.CH_1) or (nCh = DefPocb.CH_ALL) then begin
          sFileName := sFilePath + Format('DebugLog_%s_%s_Ch%d_%s.txt',[SystemInfo.EQPId,sDate,DefPocb.CH_1+1,sDevType]);
          TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
        end;
        if (nCh = DefPocb.CH_2) or (nCh = DefPocb.CH_ALL) then begin
          sFileName := sFilePath + Format('DebugLog_%s_%s_Ch%d_%s.txt',[SystemInfo.EQPId,sDate,DefPocb.CH_2+1,sDevType]);
          TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
        end;
      end;
    end;
  except
  end;
end;

procedure TCommon.MotionLog(nCh: Integer; sMsg : string);
var
  sInputData, sFileName, sMonth, sDate, sFilePath: String;
  nowDateTime : TDateTime;
begin
  if (Self = nil) then Exit;
  if (Common = nil) then Exit;
  if (not (nCh in [DefPocb.CH_1, DefPocb.CH_2, DefPocb.CH_ALL])) and (nCh <> DefPocb.SYS_LOG) then Exit;

  if not CheckMakeDir(Path.MotionLOG) then begin
    Exit;
  end;

  nowDateTime := Now;
  sMonth := FormatDateTime('yyyymm', nowDateTime);
  sDate  := FormatDateTime('yyyymmdd', nowDateTime);
  sFilePath := Path.MotionLOG + sMonth + '\'; //2022-07-25 (yyyymmdd -> yyyymm)
  if not CheckMakeDir(sFilePath) then begin
    Exit;
  end;
  //
  try
    sInputData := FormatDateTime('(hh:mm:ss.zzz) : ', nowDateTime) + sMsg + #13#10;
    case nCh of
      DefPocb.SYS_LOG : begin
        sFileName := sFilePath + Format('MotionLog_%s_%s_SYS.txt',[SystemInfo.EQPId,sDate]);
        TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
      end;
      DefPocb.CH_1, DefPocb.CH_2, DefPocb.CH_ALL: begin
        if (nCh = DefPocb.CH_1) or (nCh = DefPocb.CH_ALL) then begin
          sFileName := sFilePath + Format('MotionLog_%s_%s_Ch%d.txt',[SystemInfo.EQPId,sDate,DefPocb.CH_1+1]);
          TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
        end;
        if (nCh = DefPocb.CH_2) or (nCh = DefPocb.CH_ALL) then begin
          sFileName := sFilePath + Format('MotionLog_%s_%s_Ch%d.txt',[SystemInfo.EQPId,sDate,DefPocb.CH_2+1]);
          TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
        end;
      end;
    end;
  except
  end;
end;

procedure TCommon.RobotLog(nCh: Integer; sMsg : string);
var
  sInputData, sFileName, sMonth, sDate, sFilePath: String;
  nowDateTime : TDateTime;
begin
  if (Self = nil) then Exit;
  if (Common = nil) then Exit;
  if (not (nCh in [DefPocb.CH_1, DefPocb.CH_2, DefPocb.CH_ALL])) and (nCh <> DefPocb.SYS_LOG) then Exit;

  if not CheckMakeDir(Path.RobotLOG) then begin
    Exit;
  end;

  nowDateTime := Now;
  sMonth := FormatDateTime('yyyymm', nowDateTime);
  sDate  := FormatDateTime('yyyymmdd', nowDateTime);
  sFilePath := Path.RobotLOG + sMonth + '\'; //2022-07-25 (yyyymmdd -> yyyymm)
  if not CheckMakeDir(sFilePath) then begin
    Exit;
  end;
  //
  try
    sInputData := FormatDateTime('(hh:mm:ss.zzz) : ', nowDateTime) + sMsg;
    case nCh of
      DefPocb.SYS_LOG : begin
        sFileName := sFilePath + Format('RobotLog_%s_%s_SYS.txt',[SystemInfo.EQPId,sDate]);
        TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
      end;
      DefPocb.CH_1, DefPocb.CH_2, DefPocb.CH_ALL: begin
        if (nCh = DefPocb.CH_1) or (nCh = DefPocb.CH_ALL) then begin
          sFileName := sFilePath + Format('RobotLog_%s_%s_Ch%d.txt',[SystemInfo.EQPId,sDate,DefPocb.CH_1+1]);
          TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
        end;
        if (nCh = DefPocb.CH_2) or (nCh = DefPocb.CH_ALL) then begin
          sFileName := sFilePath + Format('RobotLog_%s_%s_Ch%d.txt',[SystemInfo.EQPId,sDate,DefPocb.CH_2+1]);
          TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
        end;
      end;
    end;
  except
  end;
end;

{$IFDEF SITE_LENSVN}
procedure TCommon.MesLog(sMsg : string);
var
  sInputData, sFileName, sMonth, sDate, sFilePath: String;
  nowDateTime : TDateTime;
begin
  if (Self = nil) then Exit;
  if (Common = nil) then Exit;
//if (not (nCh in [DefPocb.CH_1, DefPocb.CH_2, DefPocb.CH_ALL])) and (nCh <> DefPocb.SYS_LOG) then Exit;

  if not CheckMakeDir(Path.GMES) then begin
    Exit;
  end;

  nowDateTime := Now;
  sMonth := FormatDateTime('yyyymm', nowDateTime);
  sDate  := FormatDateTime('yyyymmdd', nowDateTime);
  sFilePath := Path.GMES + sMonth + '\';
  if not CheckMakeDir(sFilePath) then begin
    Exit;
  end;
  //
  try
    sInputData := FormatDateTime('(hh:mm:ss.zzz) : ', nowDateTime) + sMsg + #13#10;
    sFileName := sFilePath + Format('MesLog_%s_%s.txt',[SystemInfo.EQPId,sDate]);
    TFile.AppendAllText(sFileName, sInputData, TEncoding.UTF8);
  except
  end;
end;
{$ENDIF}

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.SavePatGroup(sPatGroup : string; SavePatGrp : TPatternGroup)
//      Called-by: procedure TfrmModelInfo.btnPatternInfoSaveClick(Sender: TObject);
//      Called-by: procedure TfrmPatternEdit.btnPGrpSaveClick(Sender: TObject);
//
procedure TCommon.SavePatGroup(sPatGroup : string; SavePatGrp : TPatternGroup);
var
  PatGrpFile : TIniFile;
  i : Integer;
  PattName : String;
begin
  DebugMessage('save_pattern_data : ' + sPatGroup);
  PattName := Path.PATTERNGROUP + sPatGroup + '.grp';
  PatGrpFile := TIniFile.Create(PattName);
  try
    try
      if PatGrpFile.SectionExists('PatternData') then PatGrpFile.EraseSection('PatternData');
      PatGrpFile.WriteInteger('PatternData','pattern_count',SavePatGrp.PatCount);
      for i := 0 to Pred(SavePatGrp.PatCount) do begin
        PatGrpFile.WriteInteger('PatternData',Format('PatType%d',[i]),SavePatGrp.PatType[i]);
        PatGrpFile.WriteString('PatternData',Format('PatName%d',[i]),SavePatGrp.PatName[i]);
        PatGrpFile.WriteInteger('PatternData',Format('VSync%d',[i]),SavePatGrp.VSync[i]);
        PatGrpFile.WriteInteger('PatternData',Format('LockTime%d',[i]),SavePatGrp.LockTime[i]);
      //PatGrpFile.WriteInteger('PatternData',Format('Dimming%d',[i]),SavePatGrp.Dimming[i]); //TBD:PATTERN_PWM
        PatGrpFile.WriteInteger('PatternData',Format('Option%d',[i]),SavePatGrp.Option[i]);
      end;
      PatGrpFile.UpdateFile;
    except
      if _lcid = 1042 then
        ShowMessage('[SAVE ERROR] '+PattName+' failed to save!!')
      else
        ShowMessage('[SAVE ERROR] '+PattName+' failed to save!!');
    end;
  finally
    PatGrpFile.Free;
  end;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.SaveRawFile(fName: String; RawData: TIdBytes; nHeight, nWidth: Integer)
//      Called-by: procedure TfrmMainter.BmpDownloadBuff(nCh: Integer; nIdx: Integer = 0);
//
procedure TCommon.SaveRawFile(fName: String; RawData: TIdBytes; nHeight, nWidth: Integer);
var
  fi : TFileStream;
  saveFName : String;
  nType, nDiv, nMod : Integer;
begin
  saveFName := StringReplace(fName,'.bmp','.raw', [rfReplaceAll, rfIgnoreCase]);
//	saveFName := StringReplace(fName,'.bmp','.raw', [rfReplaceAll, rfIgnoreCase]);
  if FileExists(saveFname) then
    fi := TFileStream.Create(saveFName, fmOpenWrite or fmShareDenyNone)
  else
    fi := TFileStream.Create(saveFName, fmCreate);
  try
    nDiv := (nWidth div 2048);
    nMod := (nWidth mod 2048);
    if nMod > 0 then nDiv := nDiv + 1;
    nType := nDiv * 2048;  //~2048(2048), ~4096(4096), ~6144(6144), ~8192(8192)  //TBD:A2CHv4:LUCID
    fi.WriteBuffer(RawData[0],nHeight*nType*3);
  finally
    fi.Free;
  end;
end;

procedure TCommon.SaveSerialMatch;
var
  sFileName : string;
begin
  if SystemInfo.MatchSerialFolder = '' then Exit;

  sFileName := SystemInfo.MatchSerialFolder + 'SerialMatch.txt';
  m_slSerialNo.SaveToFile(sFileName);
end;
//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.SaveSystemInfo
//      Called-by: procedure TCommon.ReadSystemInfo;
//      Called-by: procedure TfrmModelInfo.btnModelInfoSaveClick(Sender: TObject);
//      Called-by: procedure TfrmSelectModel.btnOkClick(Sender: TObject);
//      Called-by: procedure TfrmChangePassword.btnChangeClick(Sender: TObject);
//      Called-by: procedure TfrmSystemSetup.btnSaveClick(Sender: TObject);
//
procedure TCommon.SaveSystemInfo;
var
{$IFDEF REF_ISPD_DFS}
  sysF : TMemIniFile;
  sTemp : String;
{$ELSE}
  sysF : TIniFile;
{$ENDIF}
  encrypt_passwd, sTemp : String;
  i, nIndex: Integer;
  sBackupPath, sBackupFullName : String;
begin
{$IFDEF REF_ISPD_DFS}
  // For vietnamese, create new UTF-8 file if INI file is not UTF-8
  try
    sysF := TMemIniFile.Create(Path.SysInfo, TEncoding.UTF8);
  except
    RenameFile(Path.SysInfo, Path.Ini + 'Temp.ini');
    SaveToUTF_8(Path.Ini + 'Temp.ini', Path.SysInfo);
    DeleteFile(Path.Ini + 'Temp.ini');
    sysF := TMemIniFile.Create(Path.SysInfo, TEncoding.UTF8);
  end;
{$ELSE}
  sysF := TIniFile.Create(Path.SysInfo);
{$ENDIF}
  with sysF do begin
    try
			// [SYSTEMDATA] ---------------------------
      WriteString ('SYSTEMDATA', 'StationID',  						SystemInfo.EQPId);
      encrypt_passwd := Encrypt(SystemInfo.Password, 17307);
      WriteString ('SYSTEMDATA', 'PASSWORD',      				encrypt_passwd);
      encrypt_passwd := Encrypt(SystemInfo.Password_PM, 17307);
      WriteString ('SYSTEMDATA', 'PASSWORD_PM',      				encrypt_passwd);      
      WriteString ('SYSTEMDATA', 'TESTING_MODEL_CH1', 		SystemInfo.TestModel[DefPocb.CH_1]); //A2CHv3:MULTIPLE_MODEL
      WriteString ('SYSTEMDATA', 'TESTING_MODEL_CH2', 		SystemInfo.TestModel[DefPocb.CH_2]); //A2CHv3:MULTIPLE_MODEL
	  //TBD? Save SystemInfo.PatGrp?
			// PG
      for i := DefPocb.PG_1 to DefPocb.PG_MAX do begin
        WriteString ('SYSTEMDATA', 'IP_ADDR_PG' +IntToStr(i+1), SystemInfo.IPAddr_PG[i]);  //TBD:MERGE:SYSINFO? //#PGIPAddr
        WriteString ('SYSTEMDATA', 'IP_ADDR_SPI'+IntToStr(i+1), SystemInfo.IPAddr_SPI[i]);
        WriteBool('SYSTEMDATA',Format('USE_CH_%d',[i+1]), SystemInfo.UseCh[i]);
      end;
      WriteInteger('SYSTEMDATA', 'PG_MEMORY_SIZE',  			SystemInfo.PGMemorySize);
    //WriteInteger('SYSTEMDATA', 'USED_CH_COUNT',  		 		SystemInfo.ChCountUsed);  //TBD:A2CH? REF_ISPD?

      // PG/SPI Board
    //WriteInteger('SYSTEMDATA', 'PGSPI_MAIN', 	   	      SystemInfo.PGSPI_MAIN); // 0:PG,1:QSPI
      WriteInteger('SYSTEMDATA', 'PG_TYPE', 	   	      	SystemInfo.PG_TYPE);    // 0:NONE,1:DP489,2:DP201,3:DP200
      WriteInteger('SYSTEMDATA', 'SPI_TYPE', 	   	      	SystemInfo.SPI_TYPE);   // 0:NONE,1:DJ023SPI,2:DP201QSPI,3:DP021QSPI

      WriteString ('SYSTEMDATA', 'PG_FW_Name',            SystemInfo.PGFWName);
      WriteString ('SYSTEMDATA', 'SPI_FW_Name',           SystemInfo.SPIFWName);

			//2022-07-15 INI_ADD_INFO
      WriteString ('SYSTEMDATA', 'DAE_VERSION_INI',       SystemInfo.DAE_VERSION_INI);	 		
      WriteString ('SYSTEMDATA', 'DAE_SYSTEM_ID',         SystemInfo.DAE_SYSTEM_ID);
			//
			{$IFDEF HAS_DIO_EXLIGHT_DETECT} 			
      WriteBool   ('SYSTEMDATA', 'HasDioExLightDetect', 	SystemInfo.HasDioExLightDetect); //2022-07-15 A2CHv4_#3(NoExLightDetectSensor)
			{$ENDIF}			
			{$IFDEF HAS_DIO_FAN_INOUT_PC} 
      WriteBool   ('SYSTEMDATA', 'HasDioFanInOutPC', 		  SystemInfo.HasDioFanInOutPC);    //2022-07-15 A2CHv4_#3(FanInOutPC)
			{$ENDIF}
			{$IFDEF HAS_DIO_SCREW_SHUTTER} 			
      WriteBool   ('SYSTEMDATA', 'HasDioScrewShutter', 	  SystemInfo.HasDioScrewShutter);	 //2022-07-15 A2CHv4_#3(NoScrewShutter)
			{$ENDIF}
      WriteBool   ('SYSTEMDATA', 'HasDioVacuum', 	        SystemInfo.HasDioVacuum);	//ATO(False),GAGO|else(True) //2023-04-10 HasDioVacuum
      {$IFDEF FEATURE_KEEP_SHUTTER_UP}
      WriteBool   ('SYSTEMDATA', 'KeepDioShutterUp', 	    SystemInfo.KeepDioShutterUp);   //Read-only //2023-08-04
      {$ENDIF}

			// ComPort
      WriteInteger('SYSTEMDATA', 'COM_RCB1',  					  SystemInfo.Com_RCB[0]);
      WriteInteger('SYSTEMDATA', 'COM_RCB2',  					  SystemInfo.Com_RCB[1]);
      if SystemInfo.IonizerCntPerCH = 2 then begin
        WriteInteger('SYSTEMDATA', 'COM_ION1', 					  SystemInfo.Com_ION[0]);
        WriteInteger('SYSTEMDATA', 'COM_ION1_2',  				SystemInfo.Com_ION[1]);
        WriteInteger('SYSTEMDATA', 'COM_ION2', 					  SystemInfo.Com_ION[2]);
        WriteInteger('SYSTEMDATA', 'COM_ION2_2',    			SystemInfo.Com_ION[3]);

      end
      else begin
        WriteInteger('SYSTEMDATA', 'COM_ION1',  				  SystemInfo.Com_ION[0]);
        WriteInteger('SYSTEMDATA', 'COM_ION1_2',  				0);
        WriteInteger('SYSTEMDATA', 'COM_ION2',  				  SystemInfo.Com_ION[1]);
        WriteInteger('SYSTEMDATA', 'COM_ION2_2',  				0);
      end;
      WriteString ('SYSTEMDATA', 'ION_PRODUCT_MODEL', 		SystemInfo.ION_PRODUCT_MODEL); //2021-05-26
      WriteInteger('SYSTEMDATA', 'COM_HandBCR',  					SystemInfo.Com_HandBCR);
      WriteInteger('SYSTEMDATA', 'COM_ExLight',  					SystemInfo.Com_ExLight); //2019-04-17 ExLight
	    WriteInteger('SYSTEMDATA', 'COM_EFU',  					    SystemInfo.Com_EFU);  //2019-05-04 EFU
      WriteString ('SYSTEMDATA', 'SHARE_FOLDER', 					SystemInfo.ShareFolder);
      WriteString ('SYSTEMDATA', 'BMP_SHARE_FOLDER', 			SystemInfo.BmpShareFolder); //2019-02-08
      WriteString ('SYSTEMDATA', 'MATCH_SERIAL_FOLDER', 	SystemInfo.MatchSerialFolder);

{$IFDEF SITE_LENSVN}
   		// LENS MES (HTTP/JSON)
			WriteString ('LENS_MES_CONFIG', 'LensMesUrlIF',  			SystemInfo.LensMesUrlIF);
			WriteString ('LENS_MES_CONFIG', 'LensMesUrlLogin',  	SystemInfo.LensMesUrlLogin);
			WriteString ('LENS_MES_CONFIG', 'LensMesUrlStart',  	SystemInfo.LensMesUrlStart);
			WriteString ('LENS_MES_CONFIG', 'LensMesUrlEnd',  		SystemInfo.LensMesUrlEnd);
			WriteString ('LENS_MES_CONFIG', 'LensMesUrlEqStatus', SystemInfo.LensMesUrlEqStatus);
			WriteString ('LENS_MES_CONFIG', 'LensMesUrlReInput',  SystemInfo.LensMesUrlReInput);
			WriteString ('LENS_MES_CONFIG', 'LenMesSITE',  				SystemInfo.LenMesSITE);
			WriteString ('LENS_MES_CONFIG', 'LensMesOPERATION',  	SystemInfo.LensMesOPERATION);
			WriteString ('LENS_MES_CONFIG', 'LensMesMO',  				SystemInfo.LensMesMO);
			WriteString ('LENS_MES_CONFIG', 'LensMesITEM',  			SystemInfo.LensMesITEM);
			WriteString ('LENS_MES_CONFIG', 'LensMesSHIFT',  			SystemInfo.LensMesSHIFT);
			WriteInteger('LENS_MES_CONFIG', 'LensMesWaitSec',  		SystemInfo.LensMesWaitSec);
{$ELSE}
    // LGD GMES
      WriteString ('SYSTEMDATA', 'MES_SERVICEPORT',  			SystemInfo.MES_ServicePort);
      WriteString ('SYSTEMDATA', 'MES_NETWORK',  					SystemInfo.MES_Network);
      WriteString ('SYSTEMDATA', 'MES_DAEMONPORT',  			SystemInfo.MES_DaemonPort);
      WriteString ('SYSTEMDATA', 'MES_LOCALSUBJECT',  		SystemInfo.MES_LocalSubject);
      WriteString ('SYSTEMDATA', 'MES_REMOTESUBJECT',  		SystemInfo.MES_RemoteSubject);
      WriteString ('SYSTEMDATA', 'MES_EQCC_INTERVAL',  		SystemInfo.EqccInterval);
			WriteBool   ('SYSTEMDATA', 'USE_EQCC', 		 	 	      SystemInfo.UseEQCC);
{$ENDIF}

      WriteBool   ('SYSTEMDATA', 'USE_GIB', 		 	 	      SystemInfo.UseGIB);  //2019-11-08
{$IFDEF SUPPORT_1CG2PANEL}
      WriteBool   ('SYSTEMDATA', 'USE_ASSY_POCB', 		 	 	SystemInfo.UseAssyPOCB);
      WriteBool   ('SYSTEMDATA', 'USE_SKIP_POCB_CONFIRM', SystemInfo.UseSkipPocbConfirm); //2022-06-XX //ASSY+PM
{$ENDIF}

      WriteBool   ('SYSTEMDATA', 'USE_GRR', 		 	 	      SystemInfo.UseGRR);
      WriteBool   ('SYSTEMDATA', 'USE_PINBLOCK', 		 	 	  SystemInfo.UsePinBlock);
      WriteBool   ('SYSTEMDATA', 'USE_DETECTLIGHT', 		 	SystemInfo.UseDetectLight);
      WriteBool   ('SYSTEMDATA', 'DEFAULT_SCANFIRST', 		SystemInfo.DefaultScanFist);
      WriteInteger('SYSTEMDATA', 'BUZZER_NO', 		        SystemInfo.BuzzerNo);
      WriteBool   ('SYSTEMDATA', 'USE_EICR_PASS_ONLY', 		SystemInfo.UseEicrPassOnly);
      Writebool   ('SYSTEMDATA', 'MES_CONFIRM_HOST', 	    SystemInfo.UseConfirmHost);  //2020-05-29 CONFIRM_MES_NG_REPORT
  {$IFDEF USE_EAS}
      WriteBool   ('SYSTEMDATA', 'EAS_USE_APDR', 		 	 	  SystemInfo.EAS_UseAPDR);
      WriteString ('SYSTEMDATA', 'EAS_SERVICEPORT',  		  SystemInfo.EAS_ServicePort);
      WriteString ('SYSTEMDATA', 'EAS_NETWORK',  				  SystemInfo.EAS_Network);
      WriteString ('SYSTEMDATA', 'EAS_DAEMONPORT',  			SystemInfo.EAS_DaemonPort);
      WriteString ('SYSTEMDATA', 'EAS_LOCALSUBJECT',  	  SystemInfo.EAS_LocalSubject);
      WriteString ('SYSTEMDATA', 'EAS_REMOTESUBJECT',  	  SystemInfo.EAS_RemoteSubject);
  {$ENDIF}
			// FTP
	  //TBD? Save SystemInfo.HOST_FTP_????
			// GUI
      WriteInteger('SYSTEMDATA', 'LANGUAGE',  						SystemInfo.Language);
      WriteInteger('SYSTEMDATA', 'UI_TYPE',  							SystemInfo.UIType);
			// Etc
      WriteString ('SYSTEMDATA', 'AUTOBACKUP_PATH', 			SystemInfo.AutoBackupList);
      Writebool   ('SYSTEMDATA', 'AUTOBACKUP_USE', 				SystemInfo.AutoBackupUse);
      Writebool   ('SYSTEMDATA', 'SPI_RESET_WHEN_TIMEOUT',SystemInfo.SpiResetWhenTimeout); //2019-04-27
      Writebool   ('SYSTEMDATA', 'MANUAL_SERAIL_INPUT', 	SystemInfo.UseManualSerial);
      Writebool   ('SYSTEMDATA', 'SERIAL_MATCH_USE', 	    SystemInfo.UseSeialMatch);
      WriteInteger('SYSTEMDATA', 'PRE_SERIAL_MACTCH_CNT', SystemInfo.PrevSerial);
      Writebool   ('SYSTEMDATA', 'USE_AIRKNIFE', 	        SystemInfo.UseAirKnife);
      WriteInteger('SYSTEMDATA', 'SCREENSAVERTIME',       SystemInfo.ScreenSaverTime);
      WriteInteger('SYSTEMDATA', 'IdlePmModeLogInPopUpTime', SystemInfo.IdlePmModeLogInPopUpTime); //2023-10-12 IDLE_PMMODE_LOGIN_POPUP

      Writebool   ('SYSTEMDATA', 'USE_UNIFORMITY_POINT', 	SystemInfo.UseUniformityPoint);

{$IFDEF USE_FPC_LIMIT}
      // FPC Usage Limit //2019-04-11
      Writebool   ('SYSTEMDATA', 'FPC_USAGE_LIMIT_USE', 	SystemInfo.FpcUsageLimitUse);
      WriteInteger('SYSTEMDATA', 'FPC_USAGE_LIMIT_VALUE', SystemInfo.FpcUsageLimitValue);
{$ENDIF}
      Writebool   ('SYSTEMDATA', 'USE_BUZZER', 	          SystemInfo.UseBuzzer); //2019-09-03
{$IFDEF REF_ISPD_DFS}
      WriteInteger('SYSTEMDATA', 'LOGOUT_TIME',  					SystemInfo.LogOutTime);
{$ENDIF}
      WriteInteger('SYSTEMDATA', 'ExLightCh_Count',  			SystemInfo.ExLightCh_Count);
      WriteInteger('SYSTEMDATA', 'EfuIcuCntPerCH',  			SystemInfo.EfuIcuCntPerCH);
      WriteInteger('SYSTEMDATA', 'IonizerCntPerCH',  			SystemInfo.IonizerCntPerCH);
      Writebool   ('SYSTEMDATA', 'UseLogUploadPath', 	    SystemInfo.UseLogUploadPath); //2022-07-25 LOG_UPLOAD
{$IFDEF FEATURE_DIO_LOG_SHUTTER}          //2023-05-02 DioLog:CH1:SHUTTER:UP
      Writebool   ('SYSTEMDATA', 'UseDioLogShutter', 	    SystemInfo.UseDioLogShutter); //2023-05-02
{$ENDIF}

			// [MOTION_DATA] ---------------------------
			//TBD:CONFIG? (MOTION Parameter - Read only?)

{$IFDEF DFS_HEX}
      WriteBool  ('DFSDATA', 'USE_DFS',                  DfsConfInfo.bUseDfs);
      WriteBool  ('DFSDATA', 'USE_HEX_COMPRESS',         DfsConfInfo.bDfsHexCompress);
      WriteBool  ('DFSDATA', 'USE_HEX_DELETE',           DfsConfInfo.bDfsHexDelete);
      WriteString('DFSDATA', 'DFS_SERVER_IP',            DfsConfInfo.sDfsServerIP);
      WriteString('DFSDATA', 'DFS_USER_NAME',            DfsConfInfo.sDfsUserName);
      WriteString('DFSDATA', 'DFS_PASSWORD',             DfsConfInfo.sDfsPassword);
      WriteBool  ('DFSDATA', 'USE_COMBI_DOWN',           DfsConfInfo.bUseCombiDown);
      WriteString('DFSDATA', 'COMBI_DOWN_PATH',          DfsConfInfo.sCombiDownPath);
{$ENDIF}

{$IFDEF HAS_ROBOT_CAM_Z}
      with RobotSysInfo do begin  //A2CHv3:ROBOT
        WriteString ('ROBOT_DATA', 'Robot1IPAddr',         IPAddr[DefPocb.JIG_A]);
        WriteString ('ROBOT_DATA', 'Robot2IPAddr',         IPAddr[DefPocb.JIG_B]);
      //WriteInteger('ROBOT_DATA', 'RobotModbusTcpPort',   ModbusTcpPort);   //Read-Only  //TBD:A2CHv3:ROBOT?
      //WriteInteger('ROBOT_DATA', 'RobotListenTcpPort',   ListenTcpPort);   //Read-Only  //TBD:A2CHv3:ROBOT?
      //WriteFloat  ('ROBOT_DATA', 'RobotSpeedDefault',    SpeedDefault);    //Read-Only  //TBD:A2CHv3:ROBOT?
      //WriteFloat  ('ROBOT_DATA', 'RobotSpeedMax',        SpeedMax);        //Read-Only  //TBD:A2CHv3:ROBOT?
      //WriteInteger('ROBOT_DATA', 'RobotStartupMoveType', StartupMoveType); //Read-Only  //TBD:A2CHv3:ROBOT?
      //WriteInteger('ROBOT_DATA', 'RobotCoordTolerance',  RobotCoordTolerance); //Read-Only  //TBD:A2CHv3:ROBOT?
        //
        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_A].X);
        WriteString('ROBOT_DATA', 'Robot1HomeCoord_X',  sTemp);
        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_A].Y);
        WriteString('ROBOT_DATA', 'Robot1HomeCoord_Y',  sTemp);
        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_A].Z);
        WriteString('ROBOT_DATA', 'Robot1HomeCoord_Z',  sTemp);
        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_A].Rx);
        WriteString('ROBOT_DATA', 'Robot1HomeCoord_Rx',  sTemp);
        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_A].Ry);
        WriteString('ROBOT_DATA', 'Robot1HomeCoord_Ry',  sTemp);
        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_A].Rz);
        WriteString('ROBOT_DATA', 'Robot1HomeCoord_Rz',  sTemp);

        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_B].X);
        WriteString('ROBOT_DATA', 'Robot2HomeCoord_X',  sTemp);
        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_B].Y);
        WriteString('ROBOT_DATA', 'Robot2HomeCoord_Y',  sTemp);
        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_B].Z);
        WriteString('ROBOT_DATA', 'Robot2HomeCoord_Z',  sTemp);
        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_B].Rx);
        WriteString('ROBOT_DATA', 'Robot2HomeCoord_Rx',  sTemp);
        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_B].Ry);
        WriteString('ROBOT_DATA', 'Robot2HomeCoord_Ry',  sTemp);
        sTemp := FormatFloat(ROBOT_FORMAT_COORD,HomeCoord[DefPocb.JIG_B].Rz);
        WriteString('ROBOT_DATA', 'Robot2HomeCoord_Rz',  sTemp);
      end;
{$ENDIF}

			// [DEBUG] ---------------------------
    //WriteBool  ('DEBUG', 'DebugSelfTestPg',        SystemInfo.DebugSelfTestPg);
      WriteInteger('DEBUG', 'DEBUG_LOG_LEVEL_PG',    SystemInfo.DebugLogLevelConfig[DefPG.DEBUG_LOG_DEVTYPE_PG]);
      WriteInteger('DEBUG', 'DEBUG_LOG_LEVEL_SPI',   SystemInfo.DebugLogLevelConfig[DefPG.DEBUG_LOG_DEVTYPE_SPI]);
      {$IFDEF DF136_USE}
      WriteInteger('DEBUG', 'DEBUG_LOG_LEVEL_DF136', SystemInfo.DebugLogLevelConfig[DefPG.DEBUG_LOG_DEVTYPE_DF136]);
      {$ENDIF}
    except
    end;
  end;
{$IFDEF REF_ISPD_DFS}
  sysF.UpdateFile;
{$ENDIF}
  sysF.Free;
  WritePrivateProfileString(nil, nil, nil, PChar(Path.SysInfo));
  //2019-05-11 Backup(SystemConfig.ini)
  sBackupPath := Path.INI+'backup_ini';
  CheckMakeDir(sBackupPath);
  if System.SysUtils.FileExists(Path.SysInfo) then begin
    sBackupFullName := sBackupPath + '\' + 'SystemConfig' + '_' + FormatDateTime('yyyymmdd_hhnnss',Now) + '.ini';
    CopyFile(PChar(Path.SysInfo), PChar(sBackupFullName), False);
  end;
end;

//------------------------------------------------------------------------------
function TCommon.GetStrMotionID2ChAxis(nModuleID: Integer): string;
var
  sTemp : string;
begin
  sTemp := '';
  case nModuleID of
    DefMotion.MOTIONID_AxMC_STAGE1_Y: sTemp := 'CH1:Y-axis';
    DefMotion.MOTIONID_AxMC_STAGE2_Y: sTemp := 'CH2:Y-axis';
		{$IFDEF HAS_MOTION_CAM_Z}
    DefMotion.MOTIONID_AxMC_STAGE1_Z: sTemp := 'CH1:Z-axis';
    DefMotion.MOTIONID_AxMC_STAGE2_Z: sTemp := 'CH2:Z-axis';
		{$ENDIF}
		{$IFDEF HAS_MOTION_TILTING}
    DefMotion.MOTIONID_AxMC_STAGE1_T: sTemp := 'CH1:T-axis';
    DefMotion.MOTIONID_AxMC_STAGE2_T: sTemp := 'CH2:T-axis';
		{$ENDIF}
  end;
  Result := sTemp;
end;

procedure TCommon.GetMotionParam(nMotionID: Integer; var MotionParam: RMotionParam);  //A2CHv3:MULTIPLE_MODEL
var
  nCh : Integer;
begin
  case nMotionID of
    DefMotion.MOTIONID_AxMC_STAGE1_Y, DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
      MotionParam.dUnit               := Common.MotionInfo.YaxisUnit;
      MotionParam.dPulse              := Common.MotionInfo.YaxisPulse;
      MotionParam.dUnitPerPulse       := Common.MotionInfo.YaxisUnitPerPulse;
      MotionParam.dStartStopSpeed     := Common.MotionInfo.YaxisStartStopSpeed;
      MotionParam.dStartStopSpeedMax  := Common.MotionInfo.YaxisStartStopSpeedMax;
      MotionParam.dVelocity           := Common.MotionInfo.YaxisVelocity;
      MotionParam.dVelocityMax        := Common.MotionInfo.YaxisVelocityMax;
      MotionParam.dAccel              := Common.MotionInfo.YaxisAccel;
      MotionParam.dAccelMax           := Common.MotionInfo.YaxisAccelMax;
      MotionParam.dSoftLimitUse       := Common.MotionInfo.YaxisSoftLimitUse;
      MotionParam.dSoftLimitMinus     := Common.MotionInfo.YaxisSoftLimitMinus;
      MotionParam.dSoftLimitPlus      := Common.MotionInfo.YaxisSoftLimitPlus;
      MotionParam.dPulseOutMethod     := Common.MotionInfo.YPulseOutMethod; //2022-08-05
      if nMotionID = DefMotion.MOTIONID_AxMC_STAGE1_Y then nCh := DefPocb.JIG_A
      else                                                 nCh := DefPocb.JIG_B;
      MotionParam.dConfigYLoadPos   := Double(Common.TestModelInfo2[nCh].CamYLoadPos);
      MotionParam.dConfigYCamPos    := Double(Common.TestModelInfo2[nCh].CamYCamPos);
    end;
    {$IFDEF HAS_MOTION_CAM_Z}
    DefMotion.MOTIONID_AxMC_STAGE1_Z, DefMotion.MOTIONID_AxMC_STAGE2_Z: begin
      MotionParam.dUnit               := Common.MotionInfo.ZaxisUnit;
      MotionParam.dPulse              := Common.MotionInfo.ZaxisPulse;
      MotionParam.dUnitPerPulse       := Common.MotionInfo.ZaxisUnitPerPulse;
      MotionParam.dStartStopSpeed     := Common.MotionInfo.ZaxisStartStopSpeed;
      MotionParam.dStartStopSpeedMax  := Common.MotionInfo.ZaxisStartStopSpeedMax;
      MotionParam.dVelocity           := Common.MotionInfo.ZaxisVelocity;
      MotionParam.dVelocityMax        := Common.MotionInfo.ZaxisVelocityMax;
      MotionParam.dAccel              := Common.MotionInfo.ZaxisAccel;
      MotionParam.dAccelMax           := Common.MotionInfo.ZaxisAccelMax;
      MotionParam.dSoftLimitUse       := Common.MotionInfo.ZaxisSoftLimitUse;
      MotionParam.dSoftLimitMinus     := Common.MotionInfo.ZaxisSoftLimitMinus;
      MotionParam.dSoftLimitPlus      := Common.MotionInfo.ZaxisSoftLimitPlus;
      MotionParam.dPulseOutMethod     := Common.MotionInfo.ZPulseOutMethod; //2022-08-05
      if nMotionID = DefMotion.MOTIONID_AxMC_STAGE1_Z then nCh := DefPocb.JIG_A
      else                                                 nCh := DefPocb.JIG_B;
      MotionParam.dConfigZModelPos := Double(Common.TestModelInfo2[nCh].CamZModelPos)
      MotionParam.dConfigZModelPos := Double(Common.TestModelInfo2[nCh].CamZModelPos);
    end;
    {$ENDIF}
    {$IFDEF HAS_MOTION_TILTING}
    DefMotion.MOTIONID_AxMC_STAGE1_T, DefMotion.MOTIONID_AxMC_STAGE2_T: begin  //F2CH
      MotionParam.dUnit               := Common.MotionInfo.TaxisUnit;
      MotionParam.dPulse              := Common.MotionInfo.TaxisPulse;
      MotionParam.dUnitPerPulse       := Common.MotionInfo.TaxisUnitPerPulse;
      MotionParam.dStartStopSpeed     := Common.MotionInfo.TaxisStartStopSpeed;
      MotionParam.dStartStopSpeedMax  := Common.MotionInfo.TaxisStartStopSpeedMax;
      MotionParam.dVelocity           := Common.MotionInfo.TaxisVelocity;
      MotionParam.dVelocityMax        := Common.MotionInfo.TaxisVelocityMax;
      MotionParam.dAccel              := Common.MotionInfo.TaxisAccel;
      MotionParam.dAccelMax           := Common.MotionInfo.TaxisAccelMax;
      MotionParam.dSoftLimitUse       := Common.MotionInfo.TaxisSoftLimitUse;
      MotionParam.dSoftLimitMinus     := Common.MotionInfo.TaxisSoftLimitMinus;
      MotionParam.dSoftLimitPlus      := Common.MotionInfo.TaxisSoftLimitPlus;
      MotionParam.dPulseOutMethod     := Common.MotionInfo.TPulseOutMethod; //2022-08-05
      if nMotionID = DefMotion.MOTIONID_AxMC_STAGE1_T then nCh := DefPocb.JIG_A
      else                                                 nCh := DefPocb.JIG_B;			
      MotionParam.dConfigTFlatPos   := Double(Common.TestModelInfo2[nCh].CamTFlatPos);
      MotionParam.dConfigTUpPos     := Double(Common.TestModelInfo2[nCh].CamTUpPos);
    end;
    {$ENDIF}
  end;
  MotionParam.dJogVelocity      := Common.MotionInfo.JogVelocity;
  MotionParam.dJogVelocityMax   := Common.MotionInfo.JogVelocityMax;
  MotionParam.dJogAccel         := Common.MotionInfo.JogAccel;
  MotionParam.dJogAccelMax      := Common.MotionInfo.JogAccelMax;
end;

{$IFDEF HAS_ROBOT_CAM_Z}
function TCommon.GetRobotCoordAttrStr(nCoordAttr: enumRobotCoordAttr): string;  //A2CHv3:ROBOT
var
  sTemp : string;
begin
  case nCoordAttr of
    Coord_X:  sTemp := 'X';
    Coord_Y:  sTemp := 'Y';
    Coord_Z:  sTemp := 'Z';
    Coord_Rx: sTemp := 'Rx';
    Coord_Ry: sTemp := 'Ry';
    Coord_Rz: sTemp := 'Rz';
    else sTemp := 'unknown';
  end;
  Result := sTemp;
end;

function TCommon.GetRobotCoordDiffRxRyRz(nVal1, nVal2: Single): Single;   //TBD:A2CHv3:ROBOT? (Coord Diff)
var
  nDiff : Single;
begin
  if (nVal1 >= 0) and (nVal2 >= 0) then  // +, +
    nDiff := Abs(nVal1 - nVal2)
  else if (nVal1 <= 0) and (nVal2 <= 0) then  // -, -
    nDiff := Abs(nVal1 - nVal2)
  else begin  // +, -
    if nVal1 >= 0 then begin
      if      (nVal1 >= 179.95) and (Abs(nVal2) >= 179.95) then nDiff := Abs(180-nVal1) + Abs(180-Abs(nVal2))
      else if (nVal1 <= 0.05) and (Abs(nVal2) <= 0.05)     then nDiff := nVal1 + Abs(nVal2)
      else nDiff := Abs(nVal1) + Abs(nVal2);
    end
    else begin  // -, +
      if      (nVal2 >= 179.95) and (Abs(nVal1) >= 179.95) then nDiff := Abs(180-nVal2) + Abs(180-Abs(nVal1))
      else if (nVal2 <= 0.05) and (Abs(nVal1) <= 0.05)   then nDiff := nVal2 + Abs(nVal1)
      else nDiff := Abs(nVal2) + Abs(nVal1);
    end;
  end;
  Result := nDiff;
end;
{$ENDIF}

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.SetResolution(nH, nV: Word)
//      Called-by: function TCommon.LoadModelInfo(fName: String): Boolean;
//      Called-by: procedure TCommon.SaveModelInfo(fName: String);
//
procedure TCommon.SetResolution(nCh: Integer; nH, nV: Word);  //A2CHv3:MULTIPLE_MODEL? (PG DOWN ModelInfo)
begin
  actual_resolution[nCh].nH := nH;
  actual_resolution[nCh].nV := nV;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.ValueToHex(const S: String): String
//      Called-by: function TCommon.Encrypt(const S: String; Key: Word): String;
//
function TCommon.ValueToHex(const S: String): String;
const
  HexaChar : array [0..15] of Char =( '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F' );
var
  i : Integer;
  sData : string;
begin
  SetLength(sData, Length(S)*2);
  for i := 0 to Length(S)-1 do
  begin
    sData[(i*2)+1] := HexaChar[Integer(S[i+1]) shr 4];
    sData[(i*2)+2] := HexaChar[Integer(S[i+1]) and $0f];
  end;
  Result := sData;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] 
//      Called-by: 
//
{ //TBD:GMES?
function TCommon.GetLocalIpList(nIdx : Integer; sSearchIp : string): string;  //TBD? REF_ISPD_DFS
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe : PHostEnt;
  pptr : PaPInAddr;
  Buffer : array[0..63] of AnsiChar;
  i : Integer;
  WSAData : TWSAData;
  slIpList : TStringList;
  sRet : string;
begin

  WSAStartup(MakeWord(2,2),WSAData);
  try
    slIpList := TStringList.Create ;
    slIpList.Clear;
    gethostname(Buffer, SizeOf(Buffer));
    phe := gethostbyname(buffer);
    if phe = nil then Exit;
    pptr := papinaddr(phe^.h_addr_list);
    i := 0;
    while pptr^[i] <> nil do begin
      slIpList.Add(inet_ntoa(pptr^[i]^));
      Inc(i);
    end;
    WSACleanup;
    sRet := '';
    for i := 0 to Pred(slIpList.Count) do begin
      if Trim(slIpList[i]) = '0.0.0.0' then Continue;
//      if Trim(slIpList[i]) = '192.168.0.11' then Continue;
      case nIdx of
        DefPocb.IP_LOCAL_GMES : begin
          if Pos(sSearchIp,Trim(slIpList[i])) <> 1 then Continue;
          sRet := Trim(slIpList[i]);
          Break;
        end;
        DefPocb.IP_LOCAL_PLC : begin
          if Pos(sSearchIp,Trim(slIpList[i])) <> 1 then Continue;
          sRet := Trim(slIpList[i]);
          Break;
        end;
      end;
      if sRet <> '' then sRet := sRet + ' / ';
      sRet := sRet + Trim(slIpList[i]);
    end;
  finally
    slIpList.Free;
    slIpList := nil;
  end;
  Result := sRet;
end;

//------------------------------------------------------------------------------
//
procedure TCommon.SaveLocalIpToSys(nIdx: Integer);	//TBD?
var
//fSys        : TIniFile;
  fSys        : TMemIniFile;  //REF_ISPD_A_DFS
begin
//fSys := TIniFile.Create(Path.SysInfo);
  fSys := TMemIniFile.Create(Path.SysInfo, TEncoding.UTF8);
  try
    case nIdx of
      DefPocb.IP_LOCAL_GMES : begin	//TBD?
        fSys.WriteString('SYSTEMDATA', 'LocalIP_GMES', SystemInfo.LocalIP_GMES);
      end;
      DefPocb.IP_EM_NUMBER : begin	//TBD?
        fSys.WriteString('SYSTEMDATA', 'EQPID', SystemInfo.EQPId);
      end;
    end;
  finally
    fSys.Free;
  end;
end;
}
//------------------------------------------------------------------------------
//
procedure TCommon.ThreadTask(task: TProc);
var
  th : TThread;
begin
  th := TThread.CreateAnonymousThread(task);
  th.FreeOnTerminate := True;
  th.Start;
end;

procedure TCommon.SyncThreadTask(task: TProc);
var
  th : TThread;
begin
  th := TThread.CreateAnonymousThread(procedure begin
    task;
    th.Synchronize(nil,procedure begin
      //NOP
    end);
  end);
  th.FreeOnTerminate := True;
  th.Start;
end;

procedure TCommon.DelateFilesWithWildChar(sPath: string; sFileName: string);
var
  Rslt  : Integer;
  srec  : TSearchRec;
begin
  if sPath[Length(sPath)] <> '\' then
    sPath := sPath + '\';
  Rslt := FindFirst(sPath+sFileName, faAnyFile, srec);
  while Rslt = 0 do begin
    DeleteFile(sPath+srec.Name);
    Rslt := FindNext(srec);
  end;
  FindClose(srec);
end;

{$IFDEF DFS_HEX}
//******************************************************************************
// DFS_FTP
//******************************************************************************
procedure TCommon.FileCompress (sFullFileName: string; bDeleteOrgFile: Boolean);
var
  zipFile : TZipFile;
  sPath, sFileName, sZipFullName, sExt : string;
begin
  if Length(sFullFileName) <= 0 then Exit;
  //
  zipFile := TZipFile.Create;
  try
    sPath     := ExtractFilePath(sFullFileName);
    sFileName := ExtractFileName(sFullFileName);
    sExt      := ExtractFileExt(sFileName);
    sZipFullName := sPath + '\' + StringReplace(sFileName,sExt,'.zip', [rfReplaceAll, rfIgnoreCase]);
    zipFile.Open(sZipFullName,zmWrite);
    zipFile.Add(sFullFileName);
    zipFile.Close;
    //
    if bDeleteOrgFile then begin
      DeleteFile(sFullFileName);
    end;
  finally
    zipFile.Free;
  end
end;

procedure TCommon.FileDecompress (sFullZipName: string);
var
  zipFile : TZipFile;
begin
  if Length(sFullZipName) <= 0 then Exit;
  //
  zipFile := TZipFile.Create;
  try
    zipFile.Open(sFullZipName,zmRead);
    zipFile.ExtractAll;
    zipFile.Close;
  finally
    zipFile.Free;
  end;
end;
{$ENDIF}

//------------------------------------------------------------------------------
procedure TCommon.CodeSiteSend(msg: string = '');
begin
  CodeSite.Send(msg);
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.SetCodeLog
//    Called-by: procedure TCommon.LoadBaseData;
//
procedure TCommon.SetCodeLog;
//{$IFDEF DEBUG}
//var
//  DestCode : TCodeSiteDestination;
//{$ENDIF}
begin
//{$IFDEF DEBUG}
//{$IFDEF USE_CODESITE}CodeSite.EnterMethod( Self, 'FormCreate' );{$ENDIF}
//  DestCode := TCodeSiteDestination.Create(nil);
//  DestCode.LogFile.Active := False;
//  CheckDir(Path.LOG+'\CodeLogs\');
//  DestCode.LogFile.FilePath := Path.LOG + '\CodeLogs\';
//  DestCode.LogFile.FileName := FormatDateTime('yyyymmdd',now) +'_CodeSite.csl';
//  CodeSiteManager.DefaultDestination  := DestCode;
//{$IFDEF USE_CODESITE}CodeSite.ExitMethod( Self, 'FormCreate' );{$ENDIF}
//CodeSite.Send('TEST');;
//{$ENDIF}
end;

procedure TCommon.LoadMesCode;
var
  sFileName,sErrMsg, sReadData  : string;
  txtF                          : Textfile;
  lstTemp                       : TArray<String>;
  nTemp, nIndex                 : Integer;
  mesCode4Pocb                  : TMesNgCodes4POCB;
begin
  sFileName := Path.Ini + 'MES_CODE.csv';
  if (not FileExists(sFileName)) or (sFileName = '') then begin
    sErrMsg := #13#10 + 'Input Error! MES CODE File [' + sFileName + '] cannot be loaded!';
    MessageDlg(sErrMsg, mtError, [mbOk], 0);
    Exit;
  end;

  for nTemp := 0 to DefGmes.POCB_MES_CODE_MAX do begin
    m_NgCodesList4Pocb[nTemp].DefectCode := '';
    m_NgCodesList4Pocb[nTemp].DefectName := 'Undefined Error';
    m_NgCodesList4Pocb[nTemp].MesCodeSummary := '';
    m_NgCodesList4Pocb[nTemp].MesCodeRwk     := '';
  end;

  if IOResult = 0 then begin
    AssignFile(txtF, sFileName);
    try
      Reset(txtF);
      Readln(txtF, sReadData); // Remove Header

      while not Eof(txtF) do begin
        Readln(txtF, sReadData);
        if Trim(sReadData) = '' then Continue;

        lstTemp := Trim(sReadData).Split([',']);

        if Length(lstTemp) < 3 then Continue;

        nIndex     := StrToIntDef(lstTemp[0],-1);
        if (nIndex = -1) or ( nIndex > DefGmes.POCB_MES_CODE_MAX) then break;

        m_NgCodesList4Pocb[nIndex].DefectCode := lstTemp[1];
        m_NgCodesList4Pocb[nIndex].DefectName := lstTemp[2];
        if Length(lstTemp) > 3 then m_NgCodesList4Pocb[nIndex].MesCodeSummary := lstTemp[3];
        if Length(lstTemp) > 4 then m_NgCodesList4Pocb[nIndex].MesCodeRwk     := lstTemp[4];
      end;

      for nTemp := 0 to DefCam.DPC2GPC_NGCODE_MAX do begin
        m_Dpc2GpcNgCodes[nTemp].DefectCode := '';
        m_Dpc2GpcNgCodes[nTemp].DefectName := 'Undefined TEND Error';
        m_Dpc2GpcNgCodes[nTemp].MesCodeSummary := '';
        m_Dpc2GpcNgCodes[nTemp].MesCodeRwk     := '';
        m_Dpc2GpcNgCodes[nTemp].CamAlarmSuppMsg:= '';
      end;

      while not Eof(txtF) do begin
        Readln(txtF, sReadData);
        if Trim(sReadData) = '' then Continue;

        lstTemp := Trim(sReadData).Split([',']);

        if Length(lstTemp) < 3 then Continue;

        nIndex     := StrToIntDef(lstTemp[0],-1);
        if (nIndex = -1) or ( nIndex > DefCam.DPC2GPC_NGCODE_MAX) then Continue;

        m_Dpc2GpcNgCodes[nIndex].DefectCode := lstTemp[1];
        mesCode4Pocb := GetMesCode4Pocb(m_Dpc2GpcNgCodes[nIndex].DefectCode);

        if mesCode4Pocb.DefectCode <> '' then begin
          m_Dpc2GpcNgCodes[nIndex].DefectName     := mesCode4Pocb.DefectName;
          m_Dpc2GpcNgCodes[nIndex].MesCodeSummary := mesCode4Pocb.MesCodeSummary;
          m_Dpc2GpcNgCodes[nIndex].MesCodeRwk     := mesCode4Pocb.MesCodeRwk;
        end else
        begin
          if (lstTemp[2] = '') and (Length(lstTemp) > 5) then
            m_Dpc2GpcNgCodes[nIndex].DefectName := lstTemp[5];

          if Length(lstTemp) > 3 then m_Dpc2GpcNgCodes[nIndex].MesCodeSummary := lstTemp[3];
          if Length(lstTemp) > 4 then m_Dpc2GpcNgCodes[nIndex].MesCodeRwk     := lstTemp[4];
        end;

        if Length(lstTemp) > 6 then m_Dpc2GpcNgCodes[nIndex].CamAlarmSuppMsg:= lstTemp[6];
      end;
    finally
      // Close the file
      CloseFile(txtF);
    end;
  end;
end;

function TCommon.GetMesCode4Pocb(nIdx : Integer): TMesNgCodes4POCB;
begin
  if nIdx > DefGmes.POCB_MES_CODE_MAX then Exit;

  Result := m_NgCodesList4Pocb[nIdx];
end;

function TCommon.GetMesCode4Pocb(sCode : string) : TMesNgCodes4POCB;
var
  nIdx         : Integer;
  mesCode4Pocb : TMesNgCodes4POCB;
begin
  mesCode4Pocb.DefectCode     := '';
  mesCode4Pocb.DefectName     := 'Undefined Error';
  mesCode4Pocb.MesCodeSummary := '';
  mesCode4Pocb.MesCodeRwk     := '';

  for nIdx := 0 to DefGmes.POCB_MES_CODE_MAX do
  begin
    if m_NgCodesList4Pocb[nIdx].DefectCode = sCode then
      Exit(m_NgCodesList4Pocb[nIdx]);
  end;

  Result := mesCode4Pocb;
end;

{$IFDEF DFS_HEX}
procedure TCommon.LoadCombiFile;  //A2CHv3:MULTIPLE_MODEL
var
  i, j, nCh, Rslt : Integer;
  sIniFile : string;
  fSys : TIniFile;
  sValue, sTemp, sModel : string;
  sLanguage : string;
  sList,sList2 : TStringList;
  SearchRec : TSearchRec;
  sPriority, sModelInfo : string;
begin
  if FindFirst(Path.CombiCode + '*.ini', faAnyFile, SearchRec) = 0 then begin

    if SystemInfo.Language = 0 then begin // KOREAN
      sLanguage := 'KR';
      sPriority := 'Judge Rank';  //2019-05-16 korean -> english
      sModelInfo := 'Model Info'; //2019-05-16 korean -> english
    end
    else if SystemInfo.Language = 1 then begin // VIETNAMESE
      sLanguage := 'VN';
      sPriority := 'Judge Rank';  //2019-05-16 vietnamese -> english
      sModelInfo := 'Model Info'; //2019-05-16 vietnamese -> english
    end;

    Rslt := 0;
    while Rslt = 0 do begin
      //TBD:GUI? (language option)
      if (Pos(sLanguage,SearchRec.Name) > 0) then begin
        CombiCodeData.sINIFileName := AnsiString(SearchRec.Name);
        CombiCodeData.sINIDownTime := FormatDateTime('yyyymmddhhnnss', Now);
        Break;
      end;
      Rslt := FindNext(Searchrec);
    end;
  end;
  FindClose(SearchRec);

  sIniFile := Path.CombiCode + CombiCodeData.sINIFileName;
  if not FileExists(sIniFile) then Exit;

  try
    fSys := TIniFile.Create(sIniFile);
    try
      CombiCodeData.sVersion := fSys.ReadString('VERSION', 'VERSION', '');

      sList := TStringList.Create;
      try
        sTemp := fSys.ReadString('MAIN BUTTON', 'BUTTON', '');
        ExtractStrings(['/'],['/'],PWideChar(sTemp),sList);

        if sList.Count = 5 then begin
          for i := 0 to 4 do begin
            CombiCodeData.MainButton[i] := sList[i];
          end;
        end;
      finally
        sList.Free;
        sList := nil;
      end;

      for i := 0 to 4 do begin
        //DefectName
        for j := 0 to 99 do begin
          sTemp := Format('MATRIX(%d,%d)',[(j div 10)+1, (j mod 10)+1]);
          CombiCodeData.DefectMat[i,j]  := fSys.ReadString(CombiCodeData.MainButton[i],    sTemp,  '');
        end;
        //Priority
        sTemp := Format('Rank%.2d',[i+1]);
        CombiCodeData.Priority[i] := fSys.ReadString(sPriority, sTemp, '');

        // Color
        CombiCodeData.Color[i] := fSys.ReadInteger('COLOR', CombiCodeData.MainButton[i], 0);
      end;

      sList := TStringList.Create;
      try
        fSys.ReadSection('GIB OK', sList);
        SetLength(CombiCodeData.GibOK, sList.Count);
        for i := 0 to Pred(sList.Count) do begin
          SetLength(CombiCodeData.GibOK[i], 3);
          sTemp := fSys.ReadString('GIB OK', sList[i], '');
          sList2 := TStringList.Create;
          try
            ExtractStrings(['/'],['/'], PWideChar(sTemp), sList2);
            CombiCodeData.GibOK[i,0] := sList[i];
            CombiCodeData.GibOK[i,1] := sList2[0];
            CombiCodeData.GibOK[i,2] := sList2[1];
          finally
            sList2.Free;
            sList2 := nil;
          end;
        end;
      finally
        sList.Free;
        sList := nil;
      end;

      for nCh := DefPocb.CH_1 to DefPocb.CH_2 do begin  //A2CHv3:MULTIPLE_MODEL ...start

      try
        sList := TStringList.Create;
        sList2 := TStringList.Create;
        ExtractStrings(['-'], ['-'], PWideChar(SystemInfo.TestModel[nCh]), sList);  //2019-04-07 (POCB: TestModel: e.g., LA177QD1-LT01)
        if sList.Count >= 1 then begin
        //sModel := sList[0]; //sList[2];   //2019-04-07 (e.g., LA177QD1)
          sModel := Common.TestModelInfo2[nCh].CombiModelInfoKey;
          SystemInfo.ProcessName := 'PC';   //2019-04-07 ('PC' for POCB)
          sModel := Format('%s_%s',[sModel, SystemInfo.ProcessName]);
          sValue := fSys.ReadString(sModelInfo, sModel, '');
          if sValue <> '' then begin
            ExtractStrings(['/'],[], PWideChar(sValue), sList2);
            if sList2.Count > 0 then begin
              CombiCodeData.nRouterNo[nCh] := StrToIntDef(sList2[0], 0);
              CombiCodeData.sRcpName[nCh] := sList2[1];
              CombiCodeData.nOrigin[nCh] := StrToIntDef(sList2[2], 4);
              if sList2.Count = 4 then begin // ProcessNo
                CombiCodeData.sProcessNo[nCh] := sList2[3];
              end
              else if sList2.Count = 5 then begin
                if SystemInfo.InspectionType = 0 then begin // first-inspection  //TBD:MERGE:DFS? Fold(X) Auto(O)
                  CombiCodeData.sProcessNo[nCh] := sList2[3];
                end
                else if SystemInfo.InspectionType = 1 then begin // re-inspection
                  CombiCodeData.sProcessNo[nCh] := sList2[4];
                end;
								{$IFDEF PANEL_FOLD}
							//{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)} //TBD:GAGO?
	            //if (not SystemInfo.UseGIB) then CombiCodeData.sProcessNo := sList2[3]  // 초검  //2020-04-27 (InspectionType -> UseGIB)  //TBD:MERGE:DFS? Fold(O) Auto(X)
              //else                            CombiCodeData.sProcessNo := sList2[4]; // 재검(GIB)
								{$ENDIF}
              end;
            end;
          end;
        end;
      finally
        sList.Free;
        sList := nil;
        sList2.Free;
        sList2 := nil;
      end;

      end;  //A2CHv3:MULTIPLE_MODEL ...end
    except

    end;
  finally
    fSys.Free;
    fSys := nil;
  end;
end;

procedure TCommon.CheckAuthority(sID, sPassword: string);
var
  sIniFile : string;
  fSys : TIniFile;
  sTemp : string;
begin
  CombiCodeData.bAuthority := False;
  if (sID = '') or (sPassword = '') then Exit;
  sIniFile := Path.CombiCode + CombiCodeData.sINIFileName;
  if FileExists(sIniFile) then begin
    fSys := TIniFile.Create(sIniFile);
    try
      sTemp := fSys.ReadString('AUTHORITY', sID, '');
      if sPassword = sTemp then begin
        CombiCodeData.bAuthority := True;
      end
      else begin
        CombiCodeData.bAuthority := False;
      end;
    finally
      fSys.Free;
    end;
  end;
  if (sID = '123123') and (sPassword = '1234') then begin
    CombiCodeData.bAuthority := True;
  end;
end;
{$ENDIF}  //DFS_HEX

end.
