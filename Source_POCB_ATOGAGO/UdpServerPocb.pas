unit UdpServerPocb;

interface
{$I Common.inc}

uses
	System.Classes, System.SysUtils, Winapi.Messages, Winapi.Windows, Winapi.WinSock,
	GenQueue, IdGlobal, IdSocketHandle, IdUDPClient, IdUDPServer,
	Vcl.Dialogs, Vcl.ExtCtrls, 
	DefPG, DefPocb, DefSerialComm, CommonClass, DongaPattern,
  {$IFDEF DEBUG}
	CodeSiteLogging, 
  {$ENDIF}
	UserUtils;

type
  TPgStatus = (pgDisconnect, pgConnect, pgWait, pgDone, pgForceStop); // PG/SPI Status
//TPgStatus = (pgDiscon, pgConn, pgInitVer, pgInitModel, pgReady, pgForceStop);  // PG/SPI Status  ???	
           // pgDisconn --(RX:FIRST_CONN)--> pgConn --(TX:FW_VER)--> pgWaitVer --(RX:FW_VER)--> pgRxVer --(TX:MODEL)--> pgWaitModel --(RX:MODEL)--> pgReady

  //------------------------------------ PG/SPI RxData
  TRxDataPg = record
    btTxSigId : Byte;
    btRxSigId : Byte;
		NgOrYes   : Byte;
    RootCause : Integer;
    DataLen   : Word;
    Data      : array[0..8191] of Byte;
	end;

  TRxDataSpi = record
    wTxSigId  : Word;
    wRxSigId  : Word;
		NgOrYes   : Byte;
    RootCause : Integer;
    DataLen   : Integer;
    Data      : array[0..8191] of Byte;
	end;

  //------------------------------------ PG PowerData
  TRxPwrDataPg = record
    VCC     : word; // 1 = 1mV  //TBD:MERGE? Comment? 1=100mV?
    VDD_VEL : word; // 1 = 1mV   //ELVDD  //Auto(VDD),Foldable(VEL)
    VBR     : word; // 1 = 1mV   //VBRa
    ICC     : word; // 1 = 1mA
    IDD_IEL : word; // 1 = 1mA   //ELIDD  //Auto(IDD),Foldable(IEL)
    VddXXX  : byte;
    dummy1  : byte;
    dummy2  : byte;
    dummy3  : byte;
    dummy4  : byte;
    NG      : byte; // 0xFF: All OK
	end;

  TPwrDataPg = record
    VCC     : word; // 1 = 1mV
    VDD_VEL : word; // 1 = 1mV   //ELVDD  //Auto(VDD),Foldable(VEL)
    VBR     : word; // 1 = 1mV   //VBRa
    ICC     : word; // 1 = 1mA
    IDD_IEL : word; // 1 = 1mA   //ELIDD  //Auto(IDD),Foldable(IEL)
    VddXXX  : byte;
    dummy1  : byte;
    dummy2  : byte;
    dummy3  : byte;
    dummy4  : byte;
    NG      : byte; // 0xFF: All OK
	end;

  //------------------------------------ QSPI(DJ021|DJ201) PowerData
  TRxPwrDataSpi = record 
    VCC     : Word; // 1 = 10mV
    VDD1    : Word; // 1 = 10mV
    VDD2    : Word; // 1 = 10mV
    ICC     : Word; // 1 = 1mA
    IDD1    : Word; // 1 = 1mA
    IDD2    : Word; // 1 = 1mA
    ElVdd   : Word;
    ElIdd   : Word
	end;

  TPwrDataSpi = record
    VCC     : Word; // V
    VDD_VEL : Word; // V
    ICC     : Word; // A
    IDD_IEL : Word; // A
    ElVdd   : Word;
    ElIdd   : Word;
  end;

  PPwrCalDataSpi = ^TPwrCalDataSpi;
  TPwrCalDataSpi = packed record
    VCC     : array [0 .. 6] of Word;
    VDD     : array [0 .. 6] of Word;
    ICC_IEL : array [0 .. 6] of Word;
    IDD_IEL : array [0 .. 6] of Word;
  end;

  TPwrCalInfoSpi = record
    VCC    : string; 
    ICC    : string;
    VDD    : string;
    IDD    : string;
    Result : string;
    Log    : string;  
  end;

  //------------------------------------ PG/QSPI PowerCal(Offset)
  TPowerOffset = record  //2019-01-09 POWER_CAL
    VCC_Polarity  : Byte;	// ‘-‘ or ‘+’
    VCC_Offset    : Byte;	// 0 ~ 25 (0~2.5Volt)
    ICC_Polarity  : Byte;	// ‘-‘ or ‘+’ */
    ICC_Offset    : Byte;	// 0 ~ 255(0~255mA)
    VDD_Polarity  : Byte;	// ‘-‘ or ‘+’          //Auto(VDD),Foldable(VEL)
    VDD_Offset    : Byte;	// 0 ~ 50(0~5.0Volt)
    IDD_Polarity  : Byte;	// ‘-‘ or ‘+’ */       //Auto(IDD),Foldable(IEL)
    IDD_Offset    : Byte;	// 0 ~ 255(0~2.55A)
	end;

  //------------------------------------ SPI/QSPI FlashAccess
  TFlashAccessSts = (flashAccessUnknown=0, flashAccessDisabled=1, flashAccessEnabled=2);

  TFlashReadType = (flashReadNone=0, falshReadUnknown=1, flashReadUnit=2, flashReadGamma=3, flashReadLength=4); //Fold(FLASH_READ)  //TBD:MERGE? flashReadLength=4?
  TFlashRead = record
    ReadType       : TFlashReadType;
    ReadSize       : Integer;
    RxSize         : Integer;
    RxData         : array[0..8191] of Byte; //TBD:MERGE:FLASH_READ?
    ChecksumRx     : UInt32;
    ChecksumCalc   : UInt32;
    //
    bReadDone      : Boolean;
    SaveFilePath   : string;
    SaveFileName   : string;
  end;

  TFlashUnitStatus = (flashUnitEmpty=0, flashUnitRead=1, flashUnitUpdated=2, flashUnitWriteErr=3); //FoldPOCB(EDNA:USE_FLASH_CBPARA)
  TFlashUnitBuf = record
    UnitAddr       : UInt32;
    UnitSize       : UInt32;
    UnitStatus     : TFlashUnitStatus;
    Data           : array[0..(DefPG.FLASH_DATAUNIT_SIZE-1)] of Byte;
    Checksum       : UInt32;
  end;

  //------------------------------------ PG Display Pattern
  TCurrDisplayedPatInfo = record
    bPowerOn        : Boolean;
    bPatternOn      : Boolean;
    nCurrPatNum     : Integer;
    nCurrAllPatIdx  : Integer;  //index of AllPat
    bSimplepaPat    : Boolean;
    {$IFDEF FEATURE_GRAY_CHANGE}
    nGrayOffset     : Integer;  //Gray Change Offset Value (-255~255)
    bGrayChangeR, bGrayChangeG, bGrayChangeB : Boolean;  //if (Simple Pattern) and (R|G|B Valuse is not 0) then True else False
    {$ENDIF}
    {$IFDEF FEATURE_DIMMING_STEP}
    nCurrPwmDuty    : Integer; //0~100
    nCurrDimmingStep: Integer; //1~4
    {$ENDIF}
  end;

  TPatInfoStruct  = record
    PatInfo         : array[0..MAX_PATTERN_CNT-1] of TPatternInfo;
    CurrPat         : TCurrDisplayedPatInfo;  //FEATURE_GRAY_CHANGE, FEATURE_DIMMING_STEP
  end;

  //------------------------------------ I2C Addr/Value Info (Fold)
{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
  TI2CAddrData = record
    DevAddr : Integer;
    RegAddr : Integer;
    Value   : Integer; //TBD:QSPI:BYTE?
  end;
  TArrayI2CData = record
    Cnt     : Integer;
    Data    : array[0..9] of TI2CAddrData;
  end;
{$ENDIF}

  //------------------------------------
  TFileTranStr = record
    TransMode : Integer;
    // CamComm        : DOWNLOAD_TYPE_BMP, DOWNLOAD_TYPE_PANEL_FW_img
    // DownloadBmpPg  : tcDownType.TabIndex
    // LogicPocb      : DefPocb.DOWNLOAD_POCB_CBDATA
    // Mainter_A2CHvX : DefPocb.DOWNLOAD_TYPE_BMP
    TransType : Integer;
    // CamComm        : DefPG.FUSING_TYPE_BMP_DATA, DefPG.FUSING_TYPE_BMP_DATA, DefPG.FUSING_TYPE_PANEL_FW_img, DefPG.FUSING_TYPE_BMP_DATA+m_nBmpDownCnt[nCAM]
    // DownloadBmpPg  : DefPG.FUSING_TYPE_BMP
    // LogicPocb      : DefPG.FUSING_TYPE_FLASH_BIN_DATA
    // Mainter_A2CHvX : DefPG.FUSING_TYPE_BMP_DATA + nIdx;   -> PG_CMD_BMPDOWN_TYPE_COMPBMP_BASE
    // UdpServerPocb  : SendPgBmpDownStartEnd: TxBuf[0] := Byte(nTransType)
    TotalSize : Integer;
    fileName  : string[50];
    filePath  : string[100];
    CheckSum  : DWORD;
    BmpWidth  : DWORD; //2021-11-10 DP201:BMP_DOWN
    Data      : TIdBytes;
  end;

  //------------------------------------
  PMainGuiPgData = ^TMainGuiPgData; //frmMain //#TranStatus
  TMainGuiPgData = packed record
    MsgType : Integer;
    PgNo    : Integer;
    Mode    : Integer;
    Param   : Integer;
    sMsg    : string;
  end;

  PTestGuiPgData = ^TTestGuiPgData; //frmTest1Ch //#TransVoltage
  TTestGuiPgData = record
    MsgType : Integer;
    PgNo    : Integer;
    Mode    : Integer;
    Param   : Integer;
    sMsg    : string;
    PwrDataPg  : TPwrDataPg;
    PwrDataSpi : TPwrDataSpi;
  end;

  PGuiPgDownData = ^TGuiPgDownData; //DownloadBmpPg|DownloadFwSpi(QSPI)
  TGuiPgDownData = packed record //#TranStatus
    MsgType : Integer;
    PgNo    : Integer;
    Mode    : Integer;
    Total   : Integer;
    CurPos  : Integer;
    Param   : Integer;
    IsDone  : Boolean;
    sMsg    : string;
  end;

  //============================================================================ 
  TDongaPG = class(TObject)
  private
    //------------------------------------------------------ COMMON
    //------------------------------------------------------ PG(DP489|DP200|DP201), SPI(DJ021|DJ201|DJ023)
    //------------------------------------------------------ PG(DP489|DP200|DP201)
    //------------------------------------------------------ SPI(DJ021|DJ201|DJ023)
    //------------------------------------------------------ FLOW-SPECIFIC
    //------------------------------------------------------ ETC(GUI/...)
	public
    //------------------------------------------------------ COMMON
    m_hMain    : HWND;    //frmMain
    m_hTestFrm : HWND;    //frmTestCh
    m_hGuiFrm  : HWND;    //frmDownloadBmpPg,frmDownloadFwPg,TfrmDownloadFwSpi 
    m_nPgNo    : Integer; //POCB(PgNo=ChNo)
    //------------------------------------------------------ PG(DP489|DP200|DP201), SPI(DJ021|DJ201|DJ023)		
    m_ABindingPg,      m_ABindingSpi      : TIdSocketHandle;
    m_sPgIP,           m_sSpiIP           : string;
    m_nRemotePortPg,   m_nRemotePortSpi   : Integer;
		//
    m_sFwVerPg,        m_sFwVerSpi        : string;
    m_sBootVerPg,      m_sBootVerSpi      : string;
    m_sFpgaVerPg,      m_sFpgaVerSpi      : string;
    m_sALDPVerPg                          : string;
    m_sDLPUVerPg                          : string; //2023-07-01
    m_bFwVerReqPg,     m_bFwVerReqSpi     : Boolean;
    m_wModelCrcPg,     m_wModelCrcSpi     : Word;
		//
    m_hEventPg,        m_hEventSpi        : HWND;
    m_sEventPg,        m_sEventSpi        : string; //TBD:MERGE? (String? WideString?)
    m_bWaitEventPg,    m_bWaitEventSpi    : Boolean;
    m_hPwrEventPg,     m_hPwrEventSpi     : HWND;
    m_bWaitPwrEventPg, m_bWaitPwrEventSpi : Boolean;
		//
    StatusPg,          StatusSpi          : TPgStatus;
    m_bCyclicTimerPg,  m_bCyclicTimerSpi  : Boolean;  // AliveCheck|PowerMeasure
    tmAliveCheckPg,    tmAliveCheckSpi    : TTimer;
    m_nConnCheckPg,    m_nConnCheckSpi    : Integer;
    m_bPowerMeasurePg, m_bPowerMeasureSpi : boolean;
    tmPowerMeasurePg,  tmPowerMeasureSpi  : TTimer;
    //------------------------------------------------------ PG(DP489|DP200|DP201)
    FRxDataPg         : TRxDataPg;
    m_hEventPgDisplay : HWND;
    m_PwrDataPg       : TPwrDataPg;
		//
    FCurPatGrpInfo    : TPatternGroup;
    FDisPatStruct     : TPatInfoStruct;
    //
    m_bPowerOn        : Boolean;
    m_nOldPatNum      : Integer;
    m_bChkLVDS        : Boolean;  //AutoPOCB
    m_PwrOffsetWritePg, m_PwrOffsetReadPg : TPowerOffset;				
    //------------------------------------------------------ SPI(DJ021|DJ201|DJ023)
    FRxDataSpi       : TRxDataSpi;      //DJ021|DJ201|DJ023
    m_PwrDataSpi     : TPwrDataSpi;     //DJ021|DJ201|----- 
    //
    m_PwrCalDataSpi  : TPwrCalDataSpi;  //DJ021|DJ201|-----
    m_PwrCalInfoSpi  : TPwrCalInfoSpi;  //DJ021|DJ201|-----
    //
    m_FlashAccessSts : TFlashAccessSts;
    m_FlashRead      : TFlashRead;
		m_FlashUnitBuf    : array[0..FLASH_UNITDATABUF_MAX] of TFlashUnitBuf;		

    //------------------------------------------------------ ??????????????????	OLD	//TBD:MERGE?
    tmStartPgSpiCheck : TTimer; //TBD:QSPI?				
    m_bThreadLock   : Boolean;
    FForceStop  : Boolean;
		m_pgTest_Ack : Boolean;
		bThreadBreak  : Boolean;
		bManualTest		: Boolean;
		bReadyNextFlow : Boolean;

    //------------------------------------------------------ COMMON
    constructor Create(nPgNo : Integer; hMain: THandle); virtual;
    destructor Destroy; override;		
    //------------------------------------------------------ PG(DP489|DP200|DP201)
    //---------------------------------- PG Property
    procedure SetCurPatGrpInfo(const Value: TPatternGroup);
    procedure SetDisPatStruct(const Value: TPatInfoStruct);
    property CurPatGrpInfo : TPatternGroup  read FCurPatGrpInfo write SetCurPatGrpInfo;
    property DisPatStruct  : TPatInfoStruct read FDisPatStruct write SetDisPatStruct;		
    //---------------------------------- PG Timer
    procedure AliveCheckPgTimer(Sender: TObject);
    procedure PowerMeasurePgTimer(Sender: TObject);
    procedure SetCyclicTimerPg(bEnable: Boolean; nDisableSec: integer=0);
    procedure SetPowerMeasurePgTimer(bEnable: Boolean; nInterMS: Integer=0);
    //---------------------------------- PG TX/RX Common
    function LoadIpPG(ABinding: TIdSocketHandle): Boolean;
    function CheckPgCmdAck(Task: TProc; btSigId: Byte; nWaitMS: Integer; nRetry: Integer{=0}): DWORD;
    function CheckPgPwrCmdAck(Task: TProc; btSigId: Byte; nWaitMS: Integer; nRetry: Integer{=0}): DWORD;
{$IFDEF INSPECTOR_FI}
		function  CheckPgPwrLimit(ReadVal: ReadVoltCurrPg): Boolean; //TBD:MERGE? FoldFI(O) POXB(X)
{$ENDIF}
    function GetPgCrc16(buffer: array of Byte; nLen: Integer): Word;
    procedure ReadPgData(btRet, btSigId: Byte; wLen: Word; const btData: array of Byte);
    procedure SendPgData(btSigId: Byte; wLen: Word; TxBuf: TIdBytes);
    //---------------------------------- PG TX/RX SigId
    // PG(DP489|DP200|DP201) SIG_PG_OP_MODEL
    function SendPgOpModel: DWORD;
    procedure SendPgOpModelReq;
    function MakePgOpModelData(var btaBuff: TIdBytes): Word;
    // PG(-----|DP200|DP201) SIG_PG_OP_ALDP_MODEL
    function SendPgOpModelALDP: DWORD;
    procedure SendPgOpModel2ALDPReq;
    function MakePgOpModel2ALDPData(var btaBuff: TIdBytes): Word;
    // PG(-----|DP200|DP201) SIG_PG_EXT_POWER_SEQ
    procedure SendPgExtPowerSeqReq;
    function MakePgExtPowerSeqData(var btaBuff: TIdBytes): Word;
    // PG(DP489|DP200|DP201) SIG_PG_FREQ_CHANGE
    // PG(DP489|DP200|DP201) SIG_PG_DISPLAY_PAT
    function SendPgDisplayPatNum(nPatNum: Integer; nWaitMS: Integer=3000; nRetry: Integer=1): DWORD; //TBD:MERGE? (nRetry: 0? 1?)
    procedure SendPgDisplayPatReq(nCmdType, nPatNum: Integer; nBmpCompensate: Byte=0);
    function SendPgDisplayDownBmp(nCompBmpIdx: Integer; nWaitMS: Integer=3000; nRetry: Integer=1): DWORD;
    procedure SendPgDisplayDownBmpReq(nCompBmpIdx: Integer);
    // PG(DP489|DP200|DP201) SIG_PG_READ_VOLTCUR
    function SendPgPowerMeasure(bWaitAck: Boolean=False): DWORD; //FoldFI(bWaitAck=True) POCB(bWaitAck=False) //TBD:MERGE? 
    procedure SendPgPowerMeasureReq;
    // PG(DP489|DP200|DP201) SIG_PG_PWR_ON|SIG_PG_PWR_OFF
{$IFDEF PANEL_AUTO}
    function SendPgPowerOn(nMode: Integer; bFlashBufInit: Boolean=False; nWaitMS: Integer=5000; nRetry: Integer=0): DWORD; //AutoPOCB
{$ELSE}
    {$IFDEF 1PG2CH}
    function SendPgPowerOn(nMode: Integer; bFlashBufInit: Boolean=False; nWaitMS: Integer=10000; nRetry: Integer=0): DWORD; //FoldFI(1PG2CH:nWaitMS:3000->10000)
    {$ELSE}
    function SendPgPowerOn(nMode: Integer; bFlashBufInit: Boolean=True; nWaitMS: Integer=5000; nRetry: Integer=0): DWORD; //FoldPOCB
    {$ENDIF}
{$ENDIF}
    procedure SendPgPowerReq(nMode: Integer);
    // PG(DP489|DP200|DP201) SIG_PG_SETCOLOR_PALLET
    function SendPgSetColorPallet(nOffsetR,nOffsetG,nOffsetB: Integer): DWORD;
    procedure SendPgSetColorPalletReq(nOffsetR,nOffsetG,nOffsetB: Integer);
    // PG(DP489|DP200|DP201) SIG_PG_SETCOLOR_RGB
    function  SendPgSetColorRGB(nR,nG,nB: Integer; nPalletType: Integer=DefPG.SETCOLOR_RGB_PALLET_DEFAULT): DWORD;
    procedure SendPgSetColorRGBReq(nR,nG,nB: Integer; nPalletType: Integer=DefPG.SETCOLOR_RGB_PALLET_DEFAULT);
    // PG(DP489|DP200|DP201) SIG_PG_LVDS_BITCHECK
    function SendPgLVDS: Boolean;                        //TBD:AutoPOCB?
    function SendPgLVDSPowerOn(nMode: Integer): DWORD; //TBD:AutoPOCB?
    // PG(DP489|DP200|DP201) SIG_PG_I2C_MODE
    function SendPgI2CRead(nDevAddr,nRegAddr,nDataCnt: Integer; nWaitMS: Integer=PG_I2CCMD_WAIT_MSEC; nRetry: Integer=0): DWORD; //FoldFI(PG_I2C)
    function SendPgI2CWrite(nDevAddr,nRegAddr,nDataCnt: Integer; btaData: TIdBytes; nWaitMS: Integer=PG_I2CCMD_WAIT_MSEC; nRetry: Integer=0): DWORD; //FoldFI(PG_I2C)
    procedure SendPgI2CModeReq(buff: TIdBytes; nDataLen: Integer); //FoldFI(PG_I2C) POCB(N/A)
    // PG(DP489|DP200|DP201) SIG_PG_CHANNEL_SET?
    // PG(DP489|DP200|DP201) SIG_PG_WP_ONOFF
    // PG(DP489|DP200|DP201) SIG_PG_SET_DIMMING
    function SendPgDimming(nDimming: Integer): DWORD; //Fold(PG_DIMMING)
    procedure SendPgDimmingReq(nDimming: Integer);    //Fold(PG_DIMMING)
    // PG(DP489|DP200|DP201) SIG_PG_PWR_OFFSET_WRITE|SIG_PG_PWR_OFFSET_READ
    function SendPgPowerOffsetWrite: DWORD; 
    procedure SendPgPowerOffsetWriteReq;      
    function SendPgPowerOffsetRead: DWORD;
    procedure SendPgPowerOffsetReadReq;
    // PG(DP489|DP200|DP201) SIG_PG_DIMMING_MODE?
    // PG(DP489|DP200|DP201) SIG_PG_FAILSAFE_MODE
    // PG(DP489|DP200|DP201) SIG_PG_DISPLAY_ONOFF
    function SendPgDisplayOnOff(bOn: Boolean): DWORD;
    procedure SendPgDisplayOnOffReq(bOn: Boolean);
    // PG(DP489|DP200|DP201) SIG_PG_CURSOR_ONOFF?
    // PG(DP489|DP200|DP201) SIG_PG_SETCOLOR_PALLET?
    // PG(DP489|DP200|DP201) SIG_PG_MEASURE_MODE?
    // PG(DP489|DP200|DP201) SIG_PG_POWERCAL_MODE
    function SendPgPowerCalMode(sCalCmd: string): DWORD;
    procedure SendPgPowerCalModeReq(sCalCmd: string);
    // PG(DP489|DP200|DP201) SIG_PG_PWR_AUTOCAL_MODE
    procedure SendPgPowerAutoCalMode;
    // PG(DP489|DP200|DP201) SIG_PG_PWR_AUTOCAL_DATA
    procedure SendPgPowerAutoCalData;
    // PG(DP489|DP200|DP201) SIG_PG_FIRST_CONNREQ
    procedure SendPgFirstConnAck;
    // PG(DP489|DP200|DP201) SIG_PG_CONN_CHECK
    procedure SendPgConnCheckReq;
    // PG(DP489|DP200|DP201) SIG_PG_RESET
    function SendPgReset: DWORD;
    procedure SendPgResetReq;
    // PG(DP489|DP200|DP201) SIG_PG_BMP_DOWNLOAD
    function PgDownBmpFile(const transData: TFileTranStr; bSelfTestForceNG: Boolean=False): Boolean; 
    procedure PgDownBmpFiles(nFileCnt: Integer; const arTransData: TArray<TFileTranStr>);
    function SendPgBmpDownStartEnd(bStart: Boolean; nIndex: Integer; transData: TFileTranStr; nWaitMS: Integer=3000; nRetry: integer=0): DWORD;
    procedure SendPgRawDataPkt(btTxBuf: TIdBytes);
    procedure SendPgDownEscapeSequence;
    // PG(DP489|DP200|DP201) SIG_PG_FW_VER_REQ
    procedure SendPgFwVer;
    procedure SendPgFwVerReq;
    // PG(DP489|DP200|DP201) SIG_PG_FW_DOWNLOAD
    function  SendPgFwDownStartEnd(wLen: Word; TxBuf: TIdBytes; nWaitMS: Integer=3000; nRetry: Integer=0): DWORD; //DownloadFwPg

    //------------------------------------------------------ SPI(DJ021|DJ201|DJ023)
    //---------------------------------- SPI/QSPI Property
    //---------------------------------- SPI/QSPI Timer
    procedure AliveCheckSpiTimer(Sender: TObject);
    procedure SetCyclicTimerSpi(bEnable: Boolean; nDisableSec: Integer=0);
		procedure SetPowerMeasureSpiTimer(bEnable: Boolean; nInterMS: Integer=0);
    procedure PowerMeasureSpiTimer(Sender: TObject);
    //---------------------------------- SPI/QSPI TX/RX Common
    function LoadIpSpi(ABinding: TIdSocketHandle): Boolean;
    function CheckSpiCmdAck(Task: TProc; nSigId: Integer; nWaitMS: Integer; nRetry: Integer{= 0}): DWORD;
    function CheckSpiPwrCmdAck(Task: TProc; nSid, nDelay: Integer; nRetry: Integer{=0}): DWORD;	//DJ021|DJ201|-----
		function GetQspiAlarmStr(alarm_no: Integer; nCurVal: Integer = -1): String; //TBD:FoldGB
    procedure ReadSpiData(wSigId, wLen: Word; const btData: array of Byte); 
    procedure SendSpiData(wSigId, wLen: Word; TxBuf: TIdBytes; bIsData: Boolean=False);
    //---------------------------------- SPI/QSPI TX/RX SigId#
    // SPI(DJ021|DJ201|DJ023) SIG_SPI_FIRST_CONN
    // SPI(DJ021|DJ201|DJ023) SIG_SPI_CONN_CHECK_REQ
    procedure SendSpiConnCheckReq;
    // SPI(-----|-----|DJ023) SIG_DJ023_MODEL_INFO_REQ
    // SPI(DJ021|DJ201|-----) SIG_DJ021_MODEL_INFO_REQ
    procedure SendSpiModelInfo;
    procedure SendSpiModelInfoReq_DJ023;
    function  MakeSpiModelData_DJ023(var btaData: TIdBytes): Word;
    procedure SendSpiModelInfoReq_QSPI;
    procedure MakeSpiModelData_QSPI(var sModelData: AnsiString);
    // SPI(DJ021|DJ201|-----) SIG_DJ021_MODEL_CRC_REQ
    function SendSpiModelCrc: DWORD;
    procedure SendSpiModelCrcReq;
    // SPI(DJ021|DJ201|DJ023) SIG_SPI_I2C_REQ
    function SendSpiI2CRead(nDevAddr,nRegAddr,nDataCnt: Integer; bIs1ByteAddr: Boolean=False; nWaitMS: Integer=SPI_I2CCMD_WAIT_MSEC; nRetry: Integer=1): DWORD;
    function SendSpiI2CWrite(nDevAddr,nRegAddr,nDataCnt: Integer; btaData: TIdBytes; bIs1ByteAddr: Boolean=False; nWaitMS: Integer=SPI_I2CCMD_WAIT_MSEC; nRetry: Integer=1): DWORD;
    procedure SendSpiI2CModeReq(buff: TIdBytes; nDataLen: Integer);
    // SPI(DJ021|DJ201|-----) SIG_DJ021_EEPROM_WP_REQ
    function SendSpiEepromWp(nMode: Integer; nWaitMS: Integer): DWORD;
    procedure SendSpiEepromWpReq(nMode: Integer);
    // SPI(DJ021|DJ201|DJ023) SIG_SPI_FLASH_ACCESS_REQ
    function SendSpiFlashAccess(nMode: Integer): DWORD;
    procedure SendSpiFlashAccessReq(nMode: Integer);
    // SPI(DJ021|DJ201|DJ023) SIG_SPI_FLASH_ERASE_REQ
    function SendSpiFlashErase(nMode: Integer; nAddress, nSize: UInt32; nWaitMS: Integer): DWORD;
    procedure SendSpiFlashEraseReq(nMode: Integer; nAddress, nSize: UInt32);
    // SPI(DJ021|DJ201|DJ023) SIG_SPI_FLASH_WRITE_REQ
    function SendSpiFlashWrite_StartEnd(nMode: Integer; nAddrChksum,nSize: UInt32; nWaitMS: Integer): DWORD;
    procedure SendSpiFlashWrite_StartEndReq(wMode: Integer; nAddrChksum,nSize: UInt32);
    function SendSpiFlashWrite_Data(wLen: Integer; TxBuf: TIdBytes): DWORD;
    // SPI(DJ021|DJ201|DJ023) SIG_SPI_FLASH_READ_REQ
    function SendSpiFlashRead(nReadType: TFlashReadType; nAddress, nSize: UInt32; nWaitMS: Integer): DWORD; //#SendQSPIRead
    procedure SendSpiFlashReadReq(nAddress, nSize: UInt32); //#SendQSPIReadReq
    function SendSpiFlashDataUploadFlow(nFlashAddr, nDataLen, nWaitSec: integer): DWORD;
    // SPI(-----|-----|DJ023) SIG_DJ023_FLASH_INIT_REQ
    function  SendSpiFlashInit: DWORD;
    procedure SendSpiFlashInitReq;
    // SPI(DJ021|DJ201|-----) SIG_DJ021_DIMMING_REQ
    function SendSpiDimming(nDim: Integer): DWORD;
    procedure SendSpiDimmingReq(nDim: Integer);
    // SPI(-----|-----|DJ023) SIG_DJ023_SIG_ON_OFF_REQ
    function SendSpiSigOnOff(nMode: Integer): DWORD;
    procedure SendSpiSigOnOffReq(nMode: Integer);
    // SPI(DJ021|DJ201|-----) SIG_DJ021_POWER_ON_REQ|SIG_DJ021_POWER_OFF_REQ
		function  SendSpiPowerOnOff(nMode: Integer; nWaitMS: Integer; nRetry: Integer=0): DWORD;
    procedure SendSpiPowerOnOffReq(nMode: Integer);
    // SPI(DJ021|DJ201|-----) SIG_DJ021_READ_POWER_REQ
    function  SendSpiPowerMeasure: DWORD;
    procedure SendSpiPowerMeasureReq;
    // SPI(DJ021|DJ201|-----) SIG_DJ021_POWER_OFFSET_W_REQ
    function  SendSpiPowerOffsetWrite(nVcc, nVel, nIcc, nIel: Integer): DWORD;
    procedure SendSpiPowerOffsetWriteReq(nVcc, nVel, nIcc, nIel: Integer);
    // SPI(DJ021|DJ201|-----) SIG_DJ021_POWER_OFFSET_R_REQ
    function  SendSpiPowerOffsetRead: DWORD;
    procedure SendSpiPowerOffsetReadReq;
    // SPI(DJ021|DJ201|DJ023) SIG_SPI_RESET_REQ
    function  SendSpiReset: DWORD;
    procedure SendSpiResetReq;
    // SPI(DJ021|DJ201|DJ023) SIG_SPI_CONNECTION_REQ?
    // SPI(DJ021|DJ201|-----) SIG_DJ021_UPLOAD_START_REQ
    function  SendSpiDataUpload_Start: DWORD;
    procedure SendSpiDataUpload_StartReq;
    // SPI(DJ021|DJ201|-----) SIG_DJ021_UPLOAD_DATA_REQ
    function  SendSpiDataUpload_Data(nAddrOffset: UInt32; wPacketNo, wBuffSize: Word): DWORD;
    procedure SendSpiDataUpload_DataReq(nAddrOffset: UInt32; wPacketNo, wBuffSize: Word);
    // SPI(DJ021|DJ201|-----) SIG_DJ021_PWR_AUTOCAL_MODE_REQ
    function  SendSpiPwrAutoCalMode(nCh: Integer): DWORD;
    procedure SendSpiPwrAutoCalModeReq;
    // SPI(DJ021|DJ201|-----) SIG_DJ021_PWR_AUTOCAL_DATA_REQ
    function  SendSpiPwrAutoCalData: DWORD;
    procedure SendSpiPwrAutoCalDataReq;
    // SPI(DJ021|DJ201|DJ023) SIG_SPI_FW_VER_REQ
  //procedure SendSpiFwVer;
    procedure SendSpiFwVerReq;
    // SPI(DJ021|DJ201|-----) SIG_SPI_FW_DOWN_REQ
    procedure SendSpiFwDownFlow(nType: Integer; const transData: TFileTranStr);
    procedure SendSpiFwDownReq(nType: Integer; cMode: AnsiChar; nFileSize: integer); 

    //------------------------------------------------------ FLOW-SPECIFIC
    //---------------------------------- POWER_MEASURE (PG+QSPI)
    procedure SetPowerMeasureTimer(bEnable: Boolean; nInterMS: Integer=0);
    //---------------------------------- I2C(PG+SPI/QSPI)
    function SendI2cRead(wLen, wDeviceAddr, wRegisterAddr: Word; Is1Byte: Boolean=False): DWORD;
    function SendI2cWrite(wLen, wDeviceAddr, wRegisterAddr: Word; btBuffer: TIdBytes; Is1Byte: Boolean=False): DWORD;
    //---------------------------------- POCB(FLASH_WRITE_CBDATA)
    function  SendSpiFlashWriteCBData(const transData: TFileTranStr; nInterDataMS: Integer): DWORD; //#SendQSPIWriteCBData
    //---------------------------------- POCB(FLASH_WRITE_CBPARA) //FOLD|GAGO
    {$IFDEF FEATURE_FLASH_UNIT_RW}
    function  SendSpiFlashWriteUnitData(wTxLen: UInt32; TxData: array of Byte; nInterDataMS: Integer): DWORD;
    procedure FlashClearUnitBuf(nUnitIdx: Integer = -1);
    function FlashGetUnitAddr(nFlashAddr: UInt32): UInt32;
    function FlashGetUnitIdx(nFlashAddr, nUnitAddr: UInt32; var nUnitIdx: Integer): Boolean;
    function FlashGetEmptyUnitIdx(var nUnitIdx: Integer): Boolean;
    function FlashReadData(nFlashAddr: UInt32; nLen: Integer; bForce: Boolean = False): DWORD;
    function FlashReadDeviceUnit(nUnitIdx: Integer; nUnitAddr: UInt32; nUnitSize: Integer; nTryCnt: Integer = 1): DWORD;
    function FlashWriteData(nFlashAddr: UInt32; nLen: Integer; btaData: TIdBytes ; bForce: Boolean = False): DWORD;
    function FlashWriteDeviceUnit(nUnitIdx: Integer; bAccessEnable: Boolean = True; bAccessDisable: Boolean = True; nTryCnt: Integer = 1): DWORD;
    function FlashWriteDeviceCommit: DWORD;
    {$ENDIF}

    //---------------------------------- GRAY_CHANGE
		{$IFDEF FEATURE_GRAY_CHANGE} //FoldFI(FEATURE_GRAY_CHANGE)
    procedure SendPgGrayChange(nGrayOffset: Integer);		
    {$ENDIF}
    //---------------------------------- SET_DIMMING
		{$IFDEF FEATURE_SET_DIMMING} //FoldFI(FEATURE_SET_DIMMING)
    procedure SendDimming(nDimming: Integer; nRetry: Integer=0): DWORD;  //FOLD:DIMMING	
    {$ENDIF}					
    //------------------------------------------------------ ETC (GUI/...)
    procedure SendMainGuiDisplay(nGuiMode: Integer; sMsg: string; nParam: Integer=0);
    procedure SendTestGuiDisplay(nGuiMode: Integer; sMsg: string; nParam: Integer=0);
		procedure ShowPgBmpDownStatus(nGuiType, curPos, total: Integer; sMsg: string; bIsDone: Boolean=False); //DownloadBmpPg
		procedure ShowSpiDownLoadStatus(nGuiType,curPos, total: Integer; sMsg: string;bIsDone: Boolean=False); //DownloadFwSpi

    //------------------------------------------------------ FLOW-SPECIFIC
		//OLD----??????????????????
  //procedure StartPgSpiCheckTimer (Sender: TObject);
	//function FwBootCheckSpi: Boolean; //TBD:MERGE? FoldFI(QSPI)
	//procedure SendSpiFileTransReq(wSigId,wType,wMode,wIdx,wTxLen : Word; TxBuffer: array of Byte); //TBD:MERGE? FoldFI(QSPI)
	end;

  //============================================================================ 
  InRxMaintEvent = procedure (nDevType: Integer; nPgNo: Integer; nLen: Integer; RxData : array of byte) of object;
  InTxMaintEvent = procedure (nDevType: Integer; nPgNo: Integer; nLen: Integer; TxData : array of byte) of object;
{ //TBD:MERGE?	
  InPgConnEvent = procedure (nPgNo,nType : Integer;sMessage : string) of object;
  InPwrReadEventPg = procedure (nPgNo : Integer;PwrData : ReadVoltCurrPg) of object;
//TBD? InPwrReadEventSpi = procedure (nPgNo : Integer;PwrData : ReadVoltCurrSpi) of object;	//TBD:MERGE?
}

  TUdpServerPocb = class(TObject)
  private
    function IpToPgNo (sPeerIp: string): Integer;   //TBD:A2CH:NOT-USED?
    function IpToSpiNo(sPeerIp: String): Integer;   //TBD:A2CH:NOT-USED?
    procedure udpSvrUDPClsRead(AThread: TIdUDPListenerThread; const AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure udpSvrUDPErr(AThread: TIdUDPListenerThread; ABinding: TIdSocketHandle; const AMessage: String; const AExceptionClass: TClass);
		//
    procedure SetIsMainter(const Value: Boolean);
    procedure SetIsPowerAutoCal(const Value: Boolean);  //2020-06-15 //FoldPOCB
    procedure SetOnRxDataForMaint(const Value: InRxMaintEvent);
    procedure SetOnTxDataForMaint(const Value: InTxMaintEvent);
  public
    udpSvr : TIdUDPServer;
    FIsMainter      : Boolean;
    FIsPowerAutoCal : Boolean;  //2020-06-15 //FoldPOCB
    FIsReadyToRead  : Boolean;
    FOnTxDataForMaint: InTxMaintEvent;
    FOnRxDataForMaint: InRxMaintEvent;
    //
    constructor Create(hHandle: THandle; nPgCnt: Integer); virtual;
    destructor Destroy; override;
{ //TBD:MERGE?
    property OnRxPgConnEvent : InPgConnEvent read FOnPgConnEvent write SetOnPgConnEvent;
    property OnPwrReadEventPg  : InPwrReadEventPg  read FOnPwrReadEventPg  write SetOnPwrReadEventPg;
    //TBD? property OnPwrReadEventSpi : InPwrReadEventSpi read FOnPwrReadEventSpi write SetOnPwrReadEventSpi; //TBD:MERGE?
}
		property IsMainter : Boolean read FIsMainter write SetIsMainter;
		property IsPowerAutoCal : Boolean read FIsPowerAutoCal write SetIsPowerAutoCal;
    property OnRxDataForMaint : InRxMaintEvent read FOnRxDataForMaint write SetOnRxDataForMaint;
    property OnTxDataForMaint : InTxMaintEvent read FOnTxDataForMaint write SetOnTxDataForMaint;
  end;

var
  Pg        : array[DefPocb.CH_1 .. DefPocb.CH_MAX] of TDongaPG;
  UdpServer : TUdpServerPocb;

implementation

uses OtlTaskControl, OtlParallel;

//{$r+} // memory range check.

{ TUdpServer }

//##############################################################################
//##############################################################################
//###                                                                        ###
//##############################################################################
//##############################################################################

//==============================================================================
// procedure/function: 
//		- constructor TUdpServerPocb.Create(hHandle: THandle; nPgCnt: Integer);
//		- destructor TUdpServerPocb.Destroy;
//
constructor TUdpServerPocb.Create(hHandle: THandle; nPgCnt: Integer);
var
  nPg: Integer;
  sIPADDR_PC_PG, sIPADDR_PC_SPI : string;
  {$IF Defined(SIMULATOR_PG) and Defined(SIMULATOR_SPI)}
//UdpSocketHandle : TIdSocketHandle;
  {$ENDIF}
begin
  FIsReadyToRead  := False;
  FIsMainter      := False;
  FIsPowerAutoCal := False; //2020-06-15 //FoldPOCB
  for nPg := 0 to Pred(nPgCnt) do begin
    Pg[nPg] := TDongaPG.Create(nPg,hHandle);
  end;

  udpSvr := TIdUDPServer.Create(nil);
  udpSvr.BufferSize  := 1024*8; //TBD:MERGE? //1034 --> 8K
	udpSvr.DefaultPort := DefPG.PGSPI_DEFAULT_PORT;
	udpSvr.OnUDPException := udpSvrUDPErr;
	udpSvr.OnUDPRead      := udpSvrUDPClsRead;
  {$IF Defined(SIMULATOR_PG) and Defined(SIMULATOR_SPI)}
//UdpSocketHandle    := udpSvr.Bindings.Add;
//UdpSocketHandle.IP := DefPG.IPADDR_PG_PREFIX + '.10';
  {$ENDIF}
  udpSvr.ThreadedEvent := True;
	if not udpSvr.Active then udpSvr.Active := True;
end;

destructor TUdpServerPocb.Destroy;
var
  nPg: Integer;
begin
  for nPg := DefPocb.PG_1 to DefPocb.PG_MAX do begin
  //Pg[nPg].SendPgResetReq; //TBD:2023-09-XX
  //Sleep(10);
  end;

  if udpsvr <> nil then begin
    if udpSvr.Active then udpSvr.Active := False;
    udpSvr.Free;
    udpSvr := nil;
  end;

  for nPg := DefPocb.PG_1 to DefPocb.PG_MAX do begin
    if Pg[nPg] <> nil then begin
      Pg[nPg].Free;
      Pg[nPg] := nil;
    end;
  end;

  inherited;
end;

//==============================================================================
// procedure/function: 
//		- procedure TUdpServerPocb.SetIsMainter(const Value: Boolean);
//		- procedure TUdpServerPocb.SetIsPowerAutoCal(const Value: Boolean);
//    - procedure TUdpServerPocb.SetOnRxDataForMaint(const Value: InRxMaintEvent);
//    - procedure TUdpServerPocb.SetOnTxDataForMaint(const Value: InTxMaintEvent);
//
procedure TUdpServerPocb.SetIsMainter(const Value: Boolean);
begin
  FIsMainter := Value;
end;

procedure TUdpServerPocb.SetIsPowerAutoCal(const Value: Boolean);
begin
  FIsPowerAutoCal := Value;
end;

procedure TUdpServerPocb.SetOnRxDataForMaint(const Value: InRxMaintEvent);
begin
  FOnRxDataForMaint := Value;
end;

procedure TUdpServerPocb.SetOnTxDataForMaint(const Value: InTxMaintEvent);
begin
  FOnTxDataForMaint := Value;
end;

{ //TBD:MERGE?
procedure TUdpServerPocb.SetOnPwrReadEventPg(const Value: InPwrReadEventPg);	//TBD:NOT-USED?
begin
  FOnPwrReadEventPg := Value;
end;

procedure TUdpServerPocb.SetOnPgConnEvent(const Value: InPgConnEvent);	//TBD?
begin
  FOnPgConnEvent := Value;
end;
}

//==============================================================================

// procedure/function: 
//		- function TUdpServerPocb.IpToPgNo(sPeerIp: String): Integer;
//    - function TUdpServerPocb.IpToSpiNo(sPeerIp: String): Integer;
//
function TUdpServerPocb.IpToPgNo(sPeerIp: String): Integer;
var
  i : Integer;
begin
  if sPeerIp = '' then Exit(-1);
  try
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      if Pg[i] = nil then Continue;
      if sPeerIp = Common.SystemInfo.IPAddr_PG[i] then begin
        Result := i;
        Break;
      end;
    end;
  except
    i := -1;
  end;
  Result := i;
end;

function TUdpServerPocb.IpToSpiNo(sPeerIp: String): Integer;
var
  i : Integer;
begin
  if sPeerIp = '' then Exit(-1);
  try
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
      if Pg[i] = nil then Continue;
      if sPeerIp = Common.SystemInfo.IPAddr_SPI[i] then begin
        Result := i;
        Break;
      end;
    end;
  except
    i := -1;
  end;
  Result := i;
end;

//==============================================================================
// procedure/function:
//		- procedure TUdpServerPocb.udpSvrUDPClsRead(AThread: TIdUDPListenerThread;const AData: TIdBytes; ABinding: TIdSocketHandle);
//		- procedure TUdpServerPocb.udpSvrUDPErr(AThread: TIdUDPListenerThread; ABinding: TIdSocketHandle; const AMessage: String; const AExceptionClass: TClass);
//
procedure TUdpServerPocb.udpSvrUDPClsRead(AThread: TIdUDPListenerThread; const AData: TIdBytes; ABinding: TIdSocketHandle);
var
	sPeerIp : string;
	nPgNo, nSize : Word;	
	RxBuffer : array[0..8191] of Byte;
  btSigId, btCh, btSubSigId : Byte;
  wSigId, wTemp : Word;		
	wLength, wLen : Word;
  nDebugMsgType : integer;
const
  arSpiConnCheckAck : array[0..4] of Byte = ($03, $00, $01, $00, $06);
begin
  if not FIsReadyToRead then Exit;
	
	nSize   := Length(AData);
  sPeerIp := ABinding.PeerIP;

  //---------------------------------------------------------------------------- PG
  if (sPeerIP = Common.SystemInfo.IPAddr_PG[DefPocb.CH_1]) or (sPeerIP = Common.SystemInfo.IPAddr_PG[DefPocb.CH_2]) then begin
    //
    if (sPeerIP = Common.SystemInfo.IPAddr_PG[DefPocb.CH_1]) then nPgNo := 0 else nPgNo := 1;
    if nPgNo > DefPocb.PG_MAX then Exit;
	//if Pg[nPgNo] = nil then Exit;
		//
    if nSize < 8 then Exit; // STX(0x02) + 0xf5 + 0xf1 +  btSigId + btCh + Len(2byte) + Data + ETX ==> min 8 byte
    btSigId := AData[3];
    btCh    := AData[4]; //valid if 1PG2CH

    CopyMemory(@wLength, @AData[5], 2);
    wLen := htons(wLength);
    btSubSigId := 0;
    if (wLen = 1) then begin
      btSubSigId := byte(AData[7]);
    end;

    try
      if Pg[nPgNo] = nil then Exit;

      if btSigId = SIG_PG_FIRST_CONNREQ then begin
        Common.DebugLog(nPgNo, DEBUG_LOG_DEVTYPE_PG, DEBUG_LOG_MSGTYPE_INSPECT, 'RX', sPeerIp, AData);
        if FIsmainter and Assigned(UdpServer.OnTxDataForMaint) then UdpServer.OnRxDataForMaint(0{PG},nPgNo,Length(AData),AData);
        Pg[nPgNo].LoadIpPg(ABinding);
        Exit; //!!!
      end;
			//
      if Pg[nPgNo].m_ABindingPg = nil then begin
        Pg[nPgNo].LoadIpPg(ABinding);
      end;
      // 데이터는 7번째 부터...
      if wLen > 0 then begin
        if wLen > 8191 then begin
          ShowMessage( 'Please update RxBuffer memory at udpSvrUDPClsRead');
          Exit;
        end;
        CopyMemory(@RxBuffer[0], @AData[7], wLen);
        btSubSigId := RxBuffer[0];
      end;
      // Debug Log
      if (btSubSigId = DefPG.SIG_PG_CONN_CHECK)        then nDebugMsgType := DEBUG_LOG_MSGTYPE_CONNCHECK
      else if (btSubSigId = DefPG.SIG_PG_READ_VOLTCUR) then nDebugMsgType := DEBUG_LOG_MSGTYPE_POWERREAD
      else                                                  nDebugMsgType := DEBUG_LOG_MSGTYPE_INSPECT;
      if (Common.m_nDebugLogLevelActive[DEBUG_LOG_DEVTYPE_PG] >= nDebugMsgType) then
        Common.DebugLog(nPgNo, DEBUG_LOG_DEVTYPE_PG, nDebugMsgType, 'RX', sPeerIp, AData);
      // Maint Log
      if FIsMainter and Assigned(UdpServer.OnTxDataForMaint) and (nDebugMsgType = DEBUG_LOG_MSGTYPE_INSPECT) then
        UdpServer.OnRxDataForMaint(0{PG},nPgNo,Length(AData),AData);
      //
      Pg[nPgNo].ReadPgData(btSigId,btSubSigId,wLen,RxBuffer);
    except
      OutputDebugString(PChar('>> PGUDPServerUDPRead Exception Error!!'));
    end;
  end
	
  //---------------------------------------------------------------------------- SPI|QSPI
  else if (sPeerIP = Common.SystemInfo.IPAddr_SPI[DefPocb.CH_1]) or (sPeerIP = Common.SystemInfo.IPAddr_SPI[DefPocb.CH_2]) then begin
		//
    if (sPeerIP = Common.SystemInfo.IPAddr_SPI[DefPocb.CH_1]) then nPgNo := 0 else nPgNo := 1;
    if nPgNo > DefPocb.PG_MAX then Exit;
  //if Pg[nPgNo] = nil then Exit;
		//
    try
      if Pg[nPgNo] = nil then Exit;

      //-------------------------------- Check if FlashRead
			if Common.SystemInfo.SPI_TYPE = DefPG.SPI_TYPE_DJ023_SPI then begin
	      if (Pg[nPgNo].m_FlashRead.ReadType <> flashReadNone) and (not Pg[nPgNo].m_FlashRead.bReadDone) then begin
	        if (nSize = 5) and CompareMem(@AData[0],@arSpiConnCheckAck[0],nSize) then begin //ignore ConnCheckAck
  	        Common.DebugLog(nPgNo, DEBUG_LOG_DEVTYPE_SPI, DEBUG_LOG_MSGTYPE_INSPECT, 'RX', sPeerIP, AData);
	          Common.MLog(nPgNo,'FlashRead: RX ConnCheckAck ...ignore !!!');
	          Exit;
	        end;
	        // Debug Log
	        if (Common.m_nDebugLogLevelActive[DEBUG_LOG_DEVTYPE_SPI] >= DEBUG_LOG_MSGTYPE_DOWNDATA) then
	          Common.DebugLog(nPgNo, DEBUG_LOG_DEVTYPE_SPI, DEBUG_LOG_MSGTYPE_DOWNDATA, 'RX', sPeerIp, AData);
	        //
	        CopyMemory(@RxBuffer[0], @AData[0], nSize);
	        Pg[nPgNo].ReadSpiData(0{dummy},nSize,RxBuffer);
	        Exit; //!!!
	      end;
			end;
      //-------------------------------- non-FlashRead
      if nSize < 4 then Exit;
      CopyMemory(@wTemp, @AData[0], 2);
      wSigId := wTemp;
      CopyMemory(@wLength, @AData[2], 2);
      wLen := wLength;

      // degbug log
      if      (wSigId = DefPG.SIG_SPI_CONN_CHECK_ACK)   then nDebugMsgType := DEBUG_LOG_MSGTYPE_CONNCHECK
      else if (wSigId = DefPG.SIG_DJ021_READ_POWER_ACK) then nDebugMsgType := DEBUG_LOG_MSGTYPE_POWERREAD
      else if (wSigId = DefPG.SIG_DJ023_DATA_DOWN_ACK)  then nDebugMsgType := DEBUG_LOG_MSGTYPE_DOWNDATA
      else                                                   nDebugMsgType := DEBUG_LOG_MSGTYPE_INSPECT;
      if (Common.m_nDebugLogLevelActive[DEBUG_LOG_DEVTYPE_SPI] >= nDebugMsgType) then
        Common.DebugLog(nPgNo, DEBUG_LOG_DEVTYPE_SPI, nDebugMsgType, 'RX', sPeerIp, AData);
      // maint log
      if FIsMainter and Assigned(UdpServer.OnTxDataForMaint) and (nDebugMsgType = DEBUG_LOG_MSGTYPE_INSPECT) then
        UdpServer.OnRxDataForMaint(1{SPI},nPgNo,Length(AData),AData);
      //
      if wSigId = SIG_SPI_FIRST_CONN then begin
        Pg[nPgNo].LoadIpSpi(ABinding);
        Exit; //!!!
      end;
      //
      if Pg[nPgNo].m_ABindingSpi = nil then begin
        Pg[nPgNo].LoadIpSpi(ABinding);
      end;
      if wLen > 0 then begin
        if wLen > 8191 then begin
          ShowMessage( 'Please update RxBuffer memory at udpSvrUDPClsRead');
          Exit;
        end;
        CopyMemory(@RxBuffer[0], @AData[4], wLen);
      end;
      Pg[nPgNo].ReadSpiData(wSigId,wLen,RxBuffer);
    except
      OutputDebugString(PChar('>> PGUDPServerUDPRead Exception Error!!'));
    end;
  end
	
  //---------------------------------------------------------------------------- else
  else begin
{$IFDEF DEBUG}
    CodeSite.Send('Unknown PG/SPI: IP('+sPeerIp+')');
{$ENDIF}
  end;
end;

procedure TUdpServerPocb.udpSvrUDPErr(AThread: TIdUDPListenerThread; ABinding: TIdSocketHandle; const AMessage: String; const AExceptionClass: TClass);
begin
  OutputDebugString(PChar('>> TUdpServerPocb.udpSvrUDPErr !!'));
	//TBD?
end;

{ TDongaPG }

//##############################################################################
//##############################################################################
//###                                                                        ###
//###                            COMMON                                      ###
//###                                                                        ###
//##############################################################################
//##############################################################################

//==============================================================================
// procedure/function: Create/Destroy/init/..
//    - constructor TDongaPG.Create(nPgNo: Integer; hMain: THandle);
//		- destructor TDongaPG.Destroy;
//
constructor TDongaPG.Create(nPgNo: Integer; hMain: THandle);
begin
  //------------------------------------ COMMON
  m_nPgNo    := nPgNo;
  m_hMain    := hMain;
//m_hTestFrm := 
//m_hTrans   := 

  //------------------------------------ PG(DP489|DP200|DP201), SPI(DJ021|DJ201|DJ023)
  case m_nPgNo of
    DefPocb.PG_1: begin m_sPgIP := Common.SystemInfo.IPAddr_PG[DefPocb.CH_1]; m_sSpiIp := Common.SystemInfo.IPAddr_SPI[DefPocb.CH_1]; end;
    DefPocb.PG_2: begin m_sPgIP := Common.SystemInfo.IPAddr_PG[DefPocb.CH_2]; m_sSpiIp := Common.SystemInfo.IPAddr_SPI[DefPocb.CH_2]; end;
  end;
  m_ABindingPg     := nil;           m_ABindingSpi     := nil;
  m_nRemotePortPg  := 0;             m_nRemotePortSpi  := 0;
  m_sFwVerPg       := '';            m_sFwVerSpi       := '';
  m_sBootVerPg     := '';            m_sBootVerSpi     := '';
  m_sFpgaVerPg     := '';            m_sFpgaVerSpi     := '';
  m_bFwVerReqPg    := False;         m_bFwVerReqSpi    := False;
  m_wModelCrcPg    := 0;             m_wModelCrcSpi    := 0;
  m_hEventPg       := 0{NULL};       m_hEventSpi       := 0{NULL};
  m_sEventPg       := '';            m_sEventSpi       := '';
  m_bWaitEventPg   := False;         m_bWaitEventSpi   := False;
  m_hPwrEventPg    := 0{NULL};       m_hPwrEventSpi    := 0{NULL};
  m_bWaitPwrEventPg:= False;         m_bWaitPwrEventSpi:= False;
  StatusPg         := pgDisconnect;  StatusSpi         := pgDisconnect;

  m_nConnCheckPg   := 0;             m_nConnCheckSpi   :=0;
  m_bCyclicTimerPg := True;          m_bCyclicTimerSpi := True; //2022-10-14 False->True
  tmAliveCheckPg   := nil;           tmAliveCheckSpi   := nil;
  m_bPowerMeasurePg:= False;         m_bPowerMeasureSpi:= False;
  tmPowerMeasurePg := nil;           tmPowerMeasureSpi := nil;

  //---------------- PG(DP489|DP200|DP201)
  // AliveCheck Timer
  {$IFDEF 1PG2CH}
  if m_nPgNo = 0 then begin // PG가 1개 이므로 alive check는 1번 채널만  //TBD:1PG2CH?
  {$ENDIF}
    tmAliveCheckPg := TTimer.Create(nil);
	  tmAliveCheckPg.OnTimer  := AliveCheckPgTimer;
	  tmAliveCheckPg.Interval := 3000;
	  tmAliveCheckPg.Enabled  := True; //2022-10-14 False->True
    m_nConnCheckPg  := 0;
  {$IFDEF 1PG2CH}
  end;
  {$ENDIF}
  // PowerMeasure Timer
  m_bPowerMeasurePg := False;
  if (DefPocb.PGSPI_MAIN_TYPE = DefPocb.PGSPI_MAIN_PG) then begin
    tmPowerMeasurePg := TTimer.Create(nil);
    tmPowerMeasurePg.OnTimer  := PowerMeasurePgTimer;
    tmPowerMeasurePg.Interval := 1000;
	  tmPowerMeasurePg.Enabled  := False;
  end;

  //---------------- SPI(DJ021|DJ201|DJ023)
  // AliveCheck Timer
  tmAliveCheckSpi := TTimer.Create(nil);
	tmAliveCheckSpi.OnTimer  := AliveCheckSpiTimer;
	tmAliveCheckSpi.Interval := TernaryOp((Common.SystemInfo.SPI_TYPE = SPI_TYPE_DJ023_SPI), 3000, 2000);
	tmAliveCheckSpi.Enabled  := True; //2022-10-14 False->True
  m_nConnCheckSpi  := 0;
  // PowerMeasure Timer
  m_bPowerMeasureSpi := False;
  if (DefPG.PGSPI_MAIN_TYPE = DefPG.PGSPI_MAIN_QSPI) then begin
    tmPowerMeasureSpi := TTimer.Create(nil);  //TBD:MERGE? tmPowerMeasurePg->tmPowerMeasure?
    tmPowerMeasureSpi.OnTimer  := PowerMeasureSpiTimer;
    tmPowerMeasureSpi.Interval := 1000;
	  tmPowerMeasureSpi.Enabled  := False;
  end;

  //------------------------------------ ETC //TBD:MERGE?
  m_bPowerOn   := False;
  m_nOldPatNum := 0;
  m_bChkLVDS   := False; //TBD:MERGE? (AutoPOCB?)

  // Flash Acces and Read  //TBD:MERGE?
  m_FlashAccessSts := flashAccessUnknown;
  with m_FlashRead do begin
    ReadType       := flashReadNone;
    ReadSize       := 0;
    RxSize         := 0;
  //RxData         :=
    ChecksumRx     := 0;
    ChecksumCalc   := 0;
    //
    bReadDone      := False;
    SaveFilePath   := '';
    SaveFileName   := '';
  end;
  {$IFDEF FEATURE_FLASH_UNIT_RW}
  FlashClearUnitBuf;
  {$ENDIF}

{$IFDEF TBD_MERGE_XXXX} //??????????????????????????????????????START	
  // OLD???
  tmStartPgSpiCheck := TTimer.Create(nil); //TBD:MERGE? (FoldFI)
	tmStartPgSpiCheck.OnTimer  := StartPgSpiCheckTimer;
	tmStartPgSpiCheck.Interval := 10000; //TBD:MERGE?
	tmStartPgSpiCheck.Enabled  := True;

  m_bThreadLock := False;
  FForceStop := False;
	
  FCurPatGrpInfo: TPatternGroup;
  FDisPatStruct: TPatInfoStruct;
  FOnTxDataForMaint: TxMaintEvent;
  //FRxDataPg, ReadDataSpi: TRxData; //TBD:MERGE? (POCB)

	m_pgTest_Ack : Boolean;
	bThreadBreak  : Boolean;
	bManualTest		: Boolean;
  bReadyNextFlow : Boolean;
		
  m_PwrOffsetWrite : TPowerOffset;  //2019-01-09 POWER_CAL //TBD:MERGE?
  m_PwrOffsetRead  : TPowerOffset;  //2019-01-09 POWER_CAL //TBD:MERGE?		 
{$ENDIF} //TBD_MERGE_XXXX //??????????????????????????????????????END
	
end;

destructor TDongaPG.Destroy;
begin
  //---------------- Handle (WaitFor)
  if m_bWaitEventPg then CloseHandle(m_hEventPg);
  if m_bWaitPwrEventPg then CloseHandle(m_hPwrEventPg);
  if m_bWaitEventSpi then CloseHandle(m_hEventSpi);

  //---------------- PG(DP489|DP200|DP201)
  if (tmAliveCheckPg <> nil) then begin
    tmAliveCheckPg.Enabled := False;
    tmAliveCheckPg.Free;
    tmAliveCheckPg := nil;
  end;

  if (tmPowerMeasurePg <> nil) then begin
    tmPowerMeasurePg.Enabled := False;
    tmPowerMeasurePg.Free;
    tmPowerMeasurePg := nil;
  end;

  //---------------- SPI(DJ021|DJ201|DJ023)		
  if (tmAliveCheckSpi <> nil) then begin
    tmAliveCheckSpi.Enabled := False;
    tmAliveCheckSpi.Free;
    tmAliveCheckSpi := nil;
  end;

  if (tmPowerMeasureSpi <> nil) then begin
    tmPowerMeasureSpi.Enabled := False;
    tmPowerMeasureSpi.Free;
    tmPowerMeasureSpi := nil;
  end;

  inherited;
end;

//##############################################################################
//##############################################################################
//###                                                                        ###
//###               PG(DP489|DP200|DP201), SPI(DJ021|DJ201|DJ023)            ###
//###                                                                        ###
//##############################################################################
//##############################################################################

//==============================================================================
// procedure/function:
//    - procedure TDongaPG.SetPowerMeasureTimer(bEnable: Boolean; nInterMS: Integer=0);
//
procedure TDongaPG.SetPowerMeasureTimer(bEnable: Boolean; nInterMS: Integer=0);
begin
  if DefPG.PGSPI_MAIN_TYPE = DefPG.PGSPI_MAIN_PG then begin
		m_bPowerMeasurePg := bEnable;
    if nInterMS > 0 then tmPowerMeasurePg.Interval := nInterMS;
    tmPowerMeasurePg.Enabled := (m_bCyclicTimerPg and m_bPowerMeasurePg);
  end
  else begin
		m_bPowerMeasureSpi := bEnable;
    if nInterMS > 0 then tmPowerMeasureSpi.Interval := nInterMS;
    tmPowerMeasureSpi.Enabled := (m_bCyclicTimerSpi and m_bPowerMeasureSpi);
  end;
end;

//==============================================================================
// procedure/function:
//    - function TDongaPG.SendI2cRead(wLen , wDeviceAddr, wRegisterAddr: Word; Is1Byte: Boolean=False): DWORD;
//    - function TDongaPG.SendI2cWrite(wLen, wDeviceAddr, wRegisterAddr: Word; btBuffer: TIdBytes; Is1Byte: Boolean=False): DWORD;
//
function TDongaPG.SendI2cRead(wLen , wDeviceAddr, wRegisterAddr: Word; Is1Byte: Boolean=False): DWORD;
begin
  case Common.SystemInfo.SPI_TYPE of
    DefPG.SPI_TYPE_NONE : begin
      Result := SendPgI2CRead(wDeviceAddr,wRegisterAddr,wLen{,nWaitMS,nRetry}); //FoldFI(PG_I2C)
    end;
    else begin
      Result := SendSpiI2CRead(wDeviceAddr,wRegisterAddr, wLen, Is1Byte, SPI_I2CCMD_WAIT_MSEC, 1);
    end;
  end;
end;

function TDongaPG.SendI2cWrite(wLen, wDeviceAddr, wRegisterAddr: Word; btBuffer: TIdBytes; Is1Byte: Boolean=False): DWORD;
begin
  case Common.SystemInfo.SPI_TYPE of
    DefPG.SPI_TYPE_NONE : begin
      Result := SendPgI2CWrite(wDeviceAddr,wRegisterAddr, wLen,btBuffer, PG_I2CCMD_WAIT_MSEC, 1{nRetry}); //FoldFI(PG_I2C)
    end;
    else begin
      Result := SendSpiI2CWrite(wDeviceAddr,wRegisterAddr,wLen, btBuffer, Is1Byte, SPI_I2CCMD_WAIT_MSEC, 1{nRetry});
    end;
  end;
end;

//##############################################################################
//##############################################################################
//###                                                                        ###
//###                         PG(DP489|DP200|DP201)                          ###
//###                                                                        ###
//##############################################################################
//##############################################################################

//==============================================================================
// procedure/function: PG Property
//    - procedure TDongaPG.SetCurPatGrpInfo(const Value: TPatterGroup);
//    - procedure TDongaPG.SetDisPatStruct(const Value: TPatInfoStruct);
//
procedure TDongaPG.SetCurPatGrpInfo(const Value: TPatternGroup);
begin
  FCurPatGrpInfo := Value;
end;

procedure TDongaPG.SetDisPatStruct(const Value: TPatInfoStruct);
begin
  FDisPatStruct := Value;
end;

//==============================================================================
// procedure/function: PG Timer
//		- procedure TDongaPG.AliveCheckPgTimer(Sender: TObject);
//    - procedure TDongaPG.PowerMeasurePgTimer(Sender: TObject);
//		- procedure TDongaPG.SetCyclicTimerPg;
//    - procedure TDongaPG.SetPowerMeasurePgTimer(bEnable: Boolean; nInterval : Integer); //TBD:MERGE? FoldFI(O) POCB(X)
//
procedure TDongaPG.AliveCheckPgTimer(Sender: TObject);
{$IFDEF 1PG2CH}
var
	i : Integer;
  bTemp : Boolean;
{$ENDIF}
begin
  try
    // Check if AliveCheck can be sent
    if (not m_bCyclicTimerPg) then Exit;
    if m_bWaitEventPg then Exit;
    if m_bPowerMeasurePg and tmPowerMeasurePg.Enabled then Exit;
    if UdpServer.FIsMainter and UdpServer.FIsPowerAutoCal and (Pg[m_nPgNo].StatusPg in [pgConnect]) then Exit;   //2020-06-15 PG_POWER_AUTOCAL  //2020-06-15

    //
    if m_nConnCheckPg > 10 then begin 
      m_nConnCheckPg := 0;
      StatusPg := pgDisconnect;
      //
      m_sFwVerPg    := ''; //2020-09-21
      m_bFwVerReqPg := False;
    //m_ABindingPg  := nil; //TBD:MERGE? (FodFI:nil)(POCB:comment-out)
      //
      {$IFDEF 1PG2CH}
      Pg[1].m_sFwVerPg    := ''; //2020-09-21
      Pg[1].m_bFwVerReqPg := False;
      ShowMainWindow(DefPocb.MSG_MODE_DISPLAY_CONNECTION,'Disconnected',2); //TBD:MERGE? POCB(N/A), FOldFI(ShowMainWindow)
      Pg[0].ShowTestWindow(Defcommon.MSG_MODE_DISPLAY_CONNECTION,Integer(dispPgDisconn),'PG Disconnected');//TBD:MERGE? (FoldFI:PG:10~12),(POCB:PG:0~2)  dispPgDisconn
      Pg[1].ShowTestWindow(Defcommon.MSG_MODE_DISPLAY_CONNECTION,Integer(dispPgDisconn),'PG Disconnected');//TBD:MERGE? (FoldFI:PG:10~12),(POCB:PG:0~2)  dispPgDisconn
      {$ELSE}
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,'Disconnected',2{dispPgDisconn}); //TBD:MERGE? (FoldFI:PG:10~12),(POCB:PG:0~2)  dispPgDisconn
      {$ENDIF}
    end
    else begin
      {$IFDEF 1PG2CH}
      bTemp := True;
      for i := DefPocb.CH1 to DefPocb.MAX_CH do begin
        if Pg[i].m_bAliveCheckPg = False then begin
          bTemp := False;
          break;
        end;
      end;
      if bTemp then begin // 2ch Data Download시 Alive Check 끄는 용도
			//f (m_ABindingPg <> nil) then begin //2021-12-16
        	SendPgConnCheckReq;
        	Inc(m_nConnCheckPg);
      //end;
      end;
      {$ELSE}
		//if (m_ABindingPg <> nil) then begin //2021-12-16
        SendPgConnCheckReq;
        Inc(m_nConnCheckPg);
    //end;
      {$ENDIF}
    end;
	except
		OutputDebugString(PChar('>> AliveCheckPgTimer Exception Error!!'));
	end;
end;

procedure TDongaPG.PowerMeasurePgTimer(Sender: TObject);
begin
  {$IFDEF INSPECTOR_FI}
  SendPgPowerMeasure(True{bWaitAck)};
  tmPowerMeasurePg.Enabled := bEnable;
  {$ELSE}
  SendPgPowerMeasure(False{bWaitAck}); //POCB
//tmPowerMeasurePg.Enabled := True;
  {$ENDIF}
end;

procedure TDongaPG.SetCyclicTimerPg(bEnable: Boolean; nDisableSec: Integer=0);
begin
  //2022-02-17 if m_bCyclicTimerPg = bEnable then Exit;  // Already Enabled/Disabled
  //
  m_bCyclicTimerPg         := bEnable;
  tmAliveCheckPg.Enabled   := bEnable;
  tmPowerMeasurePg.Enabled := (bEnable and m_bPowerMeasurePg);
  //
  m_nConnCheckPg := 0;	
  if (not bEnable) and (nDisableSec > 0) then begin  // Disable(Duaration!=0)
    TThread.CreateAnonymousThread(procedure var nCnt : Integer;
    begin
      for nCnt := 1 to nDisableSec do begin
        if m_bCyclicTimerPg then Exit;
        Sleep(1000);
      end;
      // Enable after nDisableSec expired
      m_bCyclicTimerPg         := True;
      tmAliveCheckPg.Enabled   := True;
      tmPowerMeasurePg.Enabled := m_bPowerMeasurePg;
    end).Start;
  end;
end;

procedure TDongaPG.SetPowerMeasurePgTimer(bEnable: Boolean; nInterMS: Integer=0);
begin
  if DefPocb.PGSPI_MAIN_TYPE <> DefPocb.PGSPI_MAIN_PG then exit;
  //
  if bEnable then begin
		if (nInterMS <= 0) then nInterMS := 1000; //TBD:MERGE? POCB? FI?
    tmPowerMeasurePg.Interval := nInterMS;
  end;
  m_bPowerMeasurePg        := bEnable;
  tmPowerMeasurePg.Enabled := bEnable;
end;

//==============================================================================
// procedure/function: PG TX/RX Common
//    - function TDongaPG.LoadIpPG(ABinding: TIdSocketHandle) : Boolean;
//    - function TDongaPG.CheckPgCmdAck(Task: TProc; nSigId, nDelay: Integer; nRetry: Integer = 0): DWORD;
//    - function TDongaPG.CheckPgPwrCmdAck(Task: TProc; nSifId, nWaitMS: Integer; nRetry: Integer(= 0)): DWORD; //TBD:IMSI? (= 0} //TBD:GERGE? FoldFI(O) POCB(X)
//		- function TDongaPG.GetPgCrc16(buffer: array of Byte; nLen: Integer): Word;     //TBD:MERGE?
//		- procedure TDongaPG.ReadPgData(btRet, btSigId: Byte; wLen: Word; const btData: array of Byte);
//		- procedure TDongaPG.SendPgData(btSigId: Byte; wLen: Word; TxBuf: TIdBytes);
//

//------------------------------------------------------------------------------
//
function TDongaPG.LoadIpPG(ABinding: TIdSocketHandle): Boolean;
var
  i : Integer;
  sPgIP : string;
begin
  {$IFDEF 1PG2CH}
  if m_nPgNo = 0 then begin
  {$ENDIF}
    SetCyclicTimerPg(False{bEnable});
  {$IFDEF 1PG2CH}
  end;
  {$ENDIF}

  sPgIP := '';
  for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin //TBD:MERGE? FoldFI(O) POCB(X)
    if m_nPgNo = i then begin
      sPgIP := Common.SystemInfo.IPAddr_PG[i];
      break;
    end;
  end;

  Result := False;
  if (sPgIP = '') or (ABinding.PeerIP = '') or (sPgIP <> ABinding.PeerIP) then begin //TBD:MERGE? FoldFI(O) POCB(X)
    Exit;
  end;

  m_ABindingPg := ABinding;
  m_sPgIP := ABinding.PeerIP;
  {$IFDEF SIMULATOR_PG}
  m_nRemotePortPg := ABinding.PeerPort;
  {$ELSE}
  m_nRemotePortPg := DefPG.PGSPI_DEFAULT_PORT;
  {$ENDIF}

  if StatusPg = pgDisconnect then StatusPg := pgConnect;
  {$IFDEF 1PG2CH}
  if m_nPgNo = 0 then Pg[1].StatusPg := pgConnect;
  {$ENDIF}
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,''); //TBD:MERGE? FoldFI(X) POCB(O)

  SendPgFirstConnAck;
  Sleep(100);

  m_sFwVerPg := '';
  m_bFwVerReqPg := False;

  SendPgConnCheckReq;
  Sleep(100);

  {$IFDEF 1PG2CH}
  if m_nPgNo = 0 then
  {$ENDIF}
    SetCyclicTimerPg(True{bEnable});
  {$IFDEF 1PG2CH}
  end;
  {$ENDIF}

  Result := True;
end;

//------------------------------------------------------------------------------
//
function TDongaPG.CheckPgCmdAck(Task: TProc; btSigId: Byte; nWaitMS: Integer; nRetry: Integer): DWORD;
var
	dwRtn  : DWORD;
	i      : Integer;
  bDisplayPat : Boolean;
begin
  dwRtn := WAIT_FAILED;
  try
		if m_bWaitEventPg then Sleep(50) else if m_bWaitPwrEventPg then Sleep(150); //2020-12-16 //TBD:MERGE?
    // Create Event
    m_bWaitEventPg := True;
    m_sEventPg := Format('SendPg%d%0.2x',[self.m_nPgNo,btSigId]);
    if (DefPG.SIG_PG_DISPLAY_PAT <> btSigId) then bDisplayPat := False else bDisplayPat := True;
    if (not bDisplayPat) then m_hEventPg        := CreateEvent(nil, False, False, PWideChar(m_sEventPg))
    else                      m_hEventPgDisplay := CreateEvent(nil, False, False, PWideChar(m_sEventPg));
		//
    for i := 0 to nRetry do begin
    	if StatusPg in [pgForceStop,pgDisconnect] then break;
      //  Send and WaitAck
      FRxDataPg.NgOrYes   := DefPG.CMD_PG_READY;
      FRxDataPg.btTxSigId := btSigId;
      Task;
      try  //2021-11-25 Add try/except (remove exception message while initialize)
        if (not bDisplayPat) then dwRtn := WaitForSingleObject(m_hEventPg, nWaitMS)
        else                      dwRtn := WaitForSingleObject(m_hEventPgDisplay, nWaitMS);
        //  Check Result
        case dwRtn of
          WAIT_OBJECT_0 : begin
            if FRxDataPg.NgOrYes = DefPg.CMD_PG_RESULT_ACK then break
            else                                                dwRtn := WAIT_FAILED;
          end;
          WAIT_TIMEOUT : begin
          end
          else begin
            break;
          end;
        end;
      except
        Break;
      end;
    end;
  finally
    // Close Event
    if m_bWaitEventPg then begin
      if (not bDisplayPat) then CloseHandle(m_hEventPg)
      else                      CloseHandle(m_hEventPgDisplay);
    end;
    m_bWaitEventPg := False;
  end;

  Result := dwRtn;
end;

function TDongaPG.CheckPgPwrCmdAck(Task: TProc; btSigId: Byte; nWaitMS: Integer; nRetry: Integer{=0}): DWORD; //TBD:GERGE? FoldFI(O) POCB(X)
var
	dwRtn  : DWORD;
	i      : Integer;
	sEvent : WideString;
begin
  dwRtn  := WAIT_FAILED;
	try
    if m_bWaitEventPg then Sleep(50)           //2020-12-16 //TBD:MERGE?
    else if m_bWaitPwrEventPg then Sleep(150); //2020-12-16 //TBD:MERGE?
		//
    m_bWaitPwrEventPg := True;
		sEvent := Format('SendPG%d%0.2x',[Self.m_nPgNo,btSigId]);
		m_hPwrEventPg   := CreateEvent(nil, False, False, PWideChar(sEvent));
		//
		for i := 0 to nRetry do begin
			if StatusPg in [pgForceStop,pgDisconnect] then Break;
      //  Send and WaitAck
      FRxDataPg.NgOrYes := DefPG.CMD_PG_READY;
			Task;
      //  Check Result
      try  //2021-11-25 Add try/except (remove exception message while initialize)
  			dwRtn := WaitForSingleObject(m_hPwrEventPg,nWaitMS);
	  		case dwRtn of
  				WAIT_OBJECT_0 : begin
  					if FRxDataPg.NgOrYes = DefPg.CMD_PG_RESULT_ACK then Break
  					else                                     						dwRtn := WAIT_FAILED;
  				end;
  				WAIT_TIMEOUT : begin
  				end
  				else begin
  					Break;
          end;
  			end;
      except
        Break;
      end;
		end;
	finally
		CloseHandle(m_hPwrEventPg);
    m_bWaitPwrEventPg := False;
	end;
  Result := dwRtn;
end;

function TDongaPG.GetPgCrc16(buffer: array of Byte; nLen: Integer): Word;
const
  CRC16POLY = $8408;
var
  i, loop_len, cnt: Integer;
  crc, data: Word;
begin
  crc := $FFFF;
  loop_len := nLen;
  cnt := 0;

  if nLen = 0 then begin
    Result := not crc;
    exit;
  end;
  repeat
    for i := 1 to 8 do begin
      data := $FF and Byte(buffer[cnt]);
      if ((crc and $1) xor (data and $1))  > 0 then crc := (crc shr 1) xor CRC16POLY
      else crc := crc shr 1;
      data := data shr 1;
    end;
    inc(cnt);
    Dec(loop_len);
  until (loop_len > 0);
  crc := not crc;
  data := crc;
  crc := (crc shl 8) or ((data shr 8) and $FF);

  Result := crc;
end;

//------------------------------------------------------------------------------
//
procedure TDongaPG.ReadPgData(btRet, btSigId: Byte; wLen: Word; const btData: array of Byte);
const
  Bytes_8  : array[0..3] of byte = ($03,$ff,$03,$ff); // Why can't Dynamic Array be Initialized?
  Bytes_10 : array[0..3] of byte = ($33,$ff,$33,$ff);
var
//i : Integer;
  nLength : Integer;
  arrTemp : array of Byte;
  sDebug  : string;
  RxPwrData : TRxPwrDataPg;
  PwrOffset : TPowerOffset;
begin
  // 
  if (btRet <> DefPG.SIG_PG_FIRST_CONNREQ) and (btSigId <> DefPG.SIG_PG_CONN_CHECK) then begin  //2022-01-04 (Add SIG_PG_CONN_CHECK)
    FRxDataPg.NgOrYes := btRet;
  end;
  FRxDataPg.btRxSigId := btSigId;  //2022-01-04

  //
  case btSigId of

		//DP489|DP200|DP201 SIG_PG_OP_MODEL (0x06)
    DefPG.SIG_PG_OP_MODEL : begin
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//-----|DP200|DP201 SIG_PG_OP_ALDP_MODEL (0x07)
    DefPG.SIG_PG_OP_ALDP_MODEL : begin
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_DISPLAY_PAT (0x10)
    DefPG.SIG_PG_DISPLAY_PAT : begin
      if m_bWaitEventPg then SetEvent(m_hEventPgDisplay); //TBD:MERGE? m_hEventPgDisplay? m_hEventPg?
    end;

		//DP489|DP200|DP201 SIG_PG_READ_VOLTCUR (0x11)
    DefPG.SIG_PG_READ_VOLTCUR: begin
      CopyMemory(@RxPwrData, @btData[1], SizeOf(RxPwrData));
      //
      {$IFDEF SIMULATOR_PANEL}
      case Common.SystemInfo.PG_TYPE of
        DefPG.PG_TYPE_DP489: begin  //DP489: RxPwrDataPg(VCC/VDD:1=10mV,ICC/IDD:1=1mA) -> PwrDataPg(VCC/VDD:1=1mV,ICC/IDD:1=1mA)
          RxPwrData.VCC     := htons(Common.TestModelInfo[m_nPgNo].PWR_VOL[DefPG.PWR_VCC] div 10);
          RxPwrData.VDD_VEL := htons(Common.TestModelInfo[m_nPgNo].PWR_VOL[DefPG.PWR_VDD_VEL] div 10);
          RxPwrData.VBR     := htons(Common.TestModelInfo[m_nPgNo].PWR_VOL[DefPG.PWR_VBR] div 10);
          RxPwrData.ICC     := htons(Common.TestModelInfo[m_nPgNo].PWR_LIMIT_H[DefPG.PWR_ICC]);     //2023-10-16 DP489:RxPwrDataPg(ICC/IDD:1=1mA)
          RxPwrData.IDD_IEL := htons(Common.TestModelInfo[m_nPgNo].PWR_LIMIT_H[DefPG.PWR_IDD_IEL]); //2023-10-16 DP489:RxPwrDataPg(ICC/IDD:1=1mA)
        end;
        else begin                  //DP200|DP201: RxPwrDataPg&PwrDataPg (VCC/VDD:1=1mV,ICC/IDD:1=1mA)
          RxPwrData.VCC     := htons(Common.TestModelInfo[m_nPgNo].PWR_VOL[DefPG.PWR_VCC]);
          RxPwrData.VDD_VEL := htons(Common.TestModelInfo[m_nPgNo].PWR_VOL[DefPG.PWR_VDD_VEL]);
          RxPwrData.VBR     := htons(Common.TestModelInfo[m_nPgNo].PWR_VOL[DefPG.PWR_VBR]);
          RxPwrData.ICC     := htons(Common.TestModelInfo[m_nPgNo].PWR_LIMIT_H[DefPG.PWR_ICC]);
          RxPwrData.IDD_IEL := htons(Common.TestModelInfo[m_nPgNo].PWR_LIMIT_H[DefPG.PWR_IDD_IEL]);
        end;
      end;
      RxPwrData.VddXXX  := 0;
      RxPwrData.dummy1  := 0;
      RxPwrData.dummy2  := 0;
      RxPwrData.dummy3  := 0;
      RxPwrData.dummy4  := 0;
      RxPwrData.NG      := 255;  // All-OK
      {$ENDIF}
      //
      {$IFDEF INSPECTOR_FI}
      if m_bWaitPwrEventPg then begin //TBD:MERGE? FoldFI(O) POCB(X)
      {$ENDIF}
        case Common.SystemInfo.PG_TYPE of
          DefPG.PG_TYPE_DP489: begin //DP489: RxPwrDataPg(VCC/VDD:1=10mV,ICC/IDD:1=1mA) -> PwrDataPg(VCC/VDD:1=1mV,ICC/IDD:1=1mA)
            m_PwrDataPg.VCC     := htons(RxPwrData.VCC) * 10;
            m_PwrDataPg.VDD_VEL := htons(RxPwrData.VDD_VEL) * 10;
            m_PwrDataPg.VBR     := htons(RxPwrData.VBR) * 10;
            m_PwrDataPg.ICC     := htons(RxPwrData.ICC);     //2023-10-16 DP489:RxPwrDataPg(ICC/IDD:1=1mA)
            m_PwrDataPg.IDD_IEL := htons(RxPwrData.IDD_IEL); //2023-10-16 DP489:RxPwrDataPg(ICC/IDD:1=1mA)
            m_PwrDataPg.VddXXX  := RxPwrData.VddXXX;
            m_PwrDataPg.dummy1  := RxPwrData.dummy1;
            m_PwrDataPg.dummy2  := RxPwrData.dummy2;
            m_PwrDataPg.dummy3  := RxPwrData.dummy3;
            m_PwrDataPg.dummy4  := RxPwrData.dummy4;
            m_PwrDataPg.NG      := RxPwrData.NG;
          end;
          else begin                 //DP200|DP201: RxPwrDataPg&PwrDataPg (VCC/VDD:1=1mV,ICC/IDD:1=1mA)
            m_PwrDataPg.VCC     := htons(RxPwrData.VCC);
            m_PwrDataPg.VDD_VEL := htons(RxPwrData.VDD_VEL);
            m_PwrDataPg.VBR     := htons(RxPwrData.VBR);
            m_PwrDataPg.ICC     := htons(RxPwrData.ICC);
            m_PwrDataPg.IDD_IEL := htons(RxPwrData.IDD_IEL);
            m_PwrDataPg.VddXXX  := RxPwrData.VddXXX;
            m_PwrDataPg.dummy1  := RxPwrData.dummy1;
            m_PwrDataPg.dummy2  := RxPwrData.dummy2;
            m_PwrDataPg.dummy3  := RxPwrData.dummy3;
            m_PwrDataPg.dummy4  := RxPwrData.dummy4;
            m_PwrDataPg.NG      := RxPwrData.NG;
          end;
        end;
      {$IFDEF INSPECTOR_FI}
        FRxDataPg.NgOrYes := DefPg.CMD_PG_RESULT_ACK;
        SetEvent(m_hPwrEventPg); //TBD:MERGE? FoldFI(O) POCB(X)
      end;
      {$ENDIF}
      //
      {$IFDEF INSPECTOR_FI}
      CheckPgPwrLimit(m_PwrDaraPg);  //TBD:FoldFI:CheckPgPwrLimit
			SetPowerMeasureTimer(False,0); //TBD:FoldFI:CheckPgPwrLimit
      {$ENDIF}
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_VOLCUR,'');
    end;

		//DP489|DP200|DP201 SIG_PG_PWR_ON (0x12)
    DefPG.SIG_PG_PWR_ON : begin
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_PWR_OFF (0x13)
    DefPG.SIG_PG_PWR_OFF : begin
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_SETCOLOR_PALLET (0x14) //FoldFI(GRAY_CHANGE)
    DefPG.SIG_PG_SETCOLOR_PALLET : begin
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_SETCOLOR_RGB (0x61)
    DefPG.SIG_PG_SETCOLOR_RGB : begin
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;		

		//DP489|DP200|DP201 SIG_PG_LVDS_BITCHECK (0x15)
    DefPG.SIG_PG_LVDS_BITCHECK : begin
      // 2020-06-05 CHECK_LVDS [Ref] A2CHv2 for GM (LVDS checking function is required. BUT, not used) 
      SetLength(arrTemp,4);
      // 6,12의 경우 아예 요청 안하도록 적용
      case Common.TestModelInfo[m_nPgNo].Bit of
         //6Bit 보류
         1{8Bit} : CopyMemory(@arrTemp[0],@Bytes_8[0],4);
         2{10Bit}: CopyMemory(@arrTemp[0],@Bytes_10[0],4);
         //12Bit 보류
      end;
      nLength := TernaryOp(Common.TestModelInfo[m_nPgNo].SigType = 1{QUAD}, 4{QUAD}, 2{DUAL}); //cmbxDispModeSignalType=SigType (0:LVDS,1:QUAD,2:eDP4Lane)  //TBD:MERGE?
      if Equal(btData, 1, arrTemp, 0, nLength) then m_bChkLVDS := True else m_bChkLVDS := False;
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_I2C_MODE (0x17) 
    DefPG.SIG_PG_I2C_MODE : begin //FoldFI(PG-I2C)
      // For Read I2C Data
      if btData[1] = Ord('R') then begin  //bt[0]:Sigid, bt[1]:'R' or 'W', bt[2~]:ReadData
        if wLen > 2 then begin
          FRxDataPg.DataLen := wLen - 2;
        //SetLength(FRxDataPg.Data,Integer(FRxDataPg.DataLen)); //TBD:MERGE?
          CopyMemory(@FRxDataPg.Data[0],@btData[2],FRxDataPg.DataLen);
        end
        else begin
          FRxDataPg.NgOrYes := DefPg.CMD_PG_RESULT_NAK;  //2020-07-02 (PG에서 값을 못일고 ACK로 회신하는 경우 있음)
        end;
      end;
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//-----|DP200|DP201 SIG_PG_EXT_POWER_SEQ (0x19)
    DefPG.SIG_PG_EXT_POWER_SEQ : begin
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_CHANNEL_SET (0x39)
  //DefPG.SIG_PG_CHANNEL_SET : begin
  //end;                   

		//DP489|DP200|DP201 SIG_PG_WP_ONOFF (0x33) //TBD:MERGE?
    DefPG.SIG_PG_WP_ONOFF : begin                 
      if m_bWaitEventPg then SetEvent(m_hEventPg);		  
    end;                   

		//DP489|DP200|DP201 SIG_PG_SET_DIMMING (0x36) 
    DefPG.SIG_PG_SET_DIMMING : begin //FoldFI|FoldPOCB(Dimming)
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_PWR_OFFSET_WRITE (0x40)
    DefPG.SIG_PG_PWR_OFFSET_WRITE : begin
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_PWR_OFFSET_READ (0x41)
    DefPG.SIG_PG_PWR_OFFSET_READ : begin
      CopyMemory(@PwrOffset, @btData[1], SizeOf(PwrOffset));
      m_PwrOffsetReadPg := PwrOffset;
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_DIMMING_MODE (0x43)
  //DefPG.SIG_PG_DIMMING_MODE : begin
  //end;

		//DP489|DP200|DP201 SIG_PG_FAILSAFE_MODE (0x44)
  //DefPG.SIG_PG_FAILSAFE_MODE : begin
  //end;

		//DP489|DP200|DP201 SIG_PG_DISPLAY_ONOFF (0x51)
    DefPG.SIG_PG_DISPLAY_ONOFF : begin           //AutoPOCB(A2CHv3:ASSY)
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_CURSOR_ONOFF (0x60)
  //DefPG.SIG_PG_CURSOR_ONOFF : begin
  //end;

		//DP489|DP200|DP201 SIG_PG_SETCOLOR_PALLET (0x61)? (0x14)?
  //DefPG.SIG_PG_SETCOLOR_PALLET : begin
  //end;

		//DP489|DP200|DP201 SIG_PG_MEASURE_MODE (0x70)
  //DefPG.SIG_PG_MEASURE_MODE : begin
  //end;

		//DP489|DP200|DP201 SIG_PG_POWERCAL_MODE (0x80)
    DefPG.SIG_PG_POWERCAL_MODE : begin
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|-----|----- SIG_PG_PWR_AUTOCAL_MODE (0x81)
    DefPG.SIG_PG_PWR_AUTOCAL_MODE : begin
      //TBD:MERGE?
    end;
                 
		//DP489|-----|----- SIG_PG_PWR_AUTOCAL_DATA (Auto:0x92|Fold:0x83)
    DefPG.SIG_PG_PWR_AUTOCAL_DATA : begin
      //TBD:MERGE?
    end;

		//DP489|DP200|DP201 SIG_PG_FIRST_CONNREQ (0x91)
  //DefPG.SIG_PG_FIRST_CONNREQ : begin
  //  N/A (See, LoadPgIp)
  //end;

		//DP489|DP200|DP201 SIG_PG_CONN_CHECK (0x92)
    DefPG.SIG_PG_CONN_CHECK : begin
      m_nConnCheckPg := 0;
      if StatusPg = pgDisconnect then StatusPg := pgConnect;
      //
      {$IFDEF 1PG2CH} //TBD:1PG2CH
      if (Pg[0].m_sFwVerPg = '') and (not Pg[0].m_bTxFwVerReqPg) then begin
        SendFwVerReq;
        ShowMainWindow(DefPocb.MSG_MODE_DISPLAY_CONNECTION,'Connected',0); //FoldFI
      end;
      {$ELSE}
      if (m_sFwVerPg = '') and (not m_bFwVerReqPg) then begin
        m_bFwVerReqPg := True;
        Common.ThreadTask(procedure begin
        	SendPgFwVer;
        //if m_bAliveCheckPg then tmAliveCheckPg.Enabled := True;
        end);
      end;
      {$ENDIF}
    //if m_bAliveCheckPg then tmAliveCheckPg.Enabled := True;
    end;

		//DP489|DP200|DP201 SIG_PG_RESET (0x94)
    DefPG.SIG_PG_RESET : begin
      m_sFwVerPg    := '';
      m_bFwVerReqPg := False;
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    //ShowMainWindow(DefPocb.MSG_MODE_DISPLAY_CONNECTION,m_sFwVer,1);
      m_nConnCheckPg := 0;
      StatusPg := pgDisconnect; // 연결 끊김으로 판단.
    //SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,'',2);  //2020-01-21 TBD? (Comment처리?)
    end;

		//DP489|DP200|DP201 SIG_PG_BMP_DOWNLOAD (0xfa)
    DefPG.SIG_PG_BMP_DOWNLOAD : begin
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_FW_ALL_FUSING (0xfc)
  //Def.SIG_PG_FW_ALL_FUSING : begin
  //end;                   

		//DP489|DP200|DP201 SIG_PG_FW_VER_REQ (0xfe)
    DefPG.SIG_PG_FW_VER_REQ : begin
      if wLen > 4 then begin
        m_sFwVerPg   := Chr(btData[1]) + '.'+ Chr(btData[2]);
        m_sFpgaVerPg := '';
        CopyMemory(@m_wModelCrcPg,@btData[3],2); //TBD:MERGE? POCB(O) FoldFI(X)
        if wLen > 5 then m_sFwVerPg   :=  m_sFwVerPg + Chr(btData[5]);
        if wLen > 8 then m_sFpgaVerPg :=  Chr(btData[7]) + '.'+ Chr(btData[8]);
        if Common.SystemInfo.PG_TYPE <> DefPG.PG_TYPE_DP489 then begin  //DP200|DP201 //TBD:MERGE?
          if wLen > 11 then m_sALDPVerPg :=  Chr(btData[9])  + '.'+ Chr(btData[10]) + '.'+ Chr(btData[11]);
          {$IFDEF 1PG2CH}
          if wLen > 14 then Pg[1].m_sALDPVerPg :=  Chr(btData[12]) + '.'+ Chr(btData[13]) + '.'+ Chr(btData[14]);
          {$ENDIF}
          if wLen > 16 then m_sDLPUVerPg :=  Chr(btData[15])  + '.'+ Chr(btData[16]); //2023-07-01
        end;
      end;
      {$IFDEF 1PG2CH}
      ShowMainWindow(DefPocb.MSG_MODE_DISPLAY_CONNECTION,m_sFwVerPg,1);
    //ShowMainWindow(DefPocb.MSG_MODE_DISPLAY_CONNECTION,m_sFwVerPg+', FPGA '+m_sFpgaVerPg,1);
      Pg[0].m_bTxFwVerReqPg := False;
    //if m_sFPGAVer <> '' then  //2020-04-1 FPGA_VERSION                      //TBD
    //  ShowMainWindow(DefPocb.MSG_MODE_DISPLAY_CONNECTION,m_sFPGAVer,3);   //TBD
      Pg[0].ShowTestWindow(DefPocb.MSG_MODE_DISPLAY_CONNECTION,1,m_sFwVerPg);
      Pg[1].m_sFwVerPg   := m_sFwVerPg;
      Pg[1].m_sFpgaVerPg := m_sFpgaVerPg;
      Pg[1].ShowTestWindow(DefPocb.MSG_MODE_DISPLAY_CONNECTION,1,m_sFwVerPg); //TBD:QSPI? CH2(1PG2CH)
      {$ELSE}
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,'',1);
      {$ENDIF}
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

		//DP489|DP200|DP201 SIG_PG_FW_DOWNLOAD (0xff)
    DefPG.SIG_PG_FW_DOWNLOAD : begin
      if m_bWaitEventPg then SetEvent(m_hEventPg);
    end;

  end;
end;

//------------------------------------------------------------------------------
//
procedure TDongaPG.SendPgData(btSigId: Byte; wLen: Word; TxBuf: TIdBytes);
var
  TxBuffer : TIdBytes;
  nDebugMsgType : Integer;
begin
  SetLength(TxBuffer,wLen + 8); // wLen + 7 + 1
  TxBuffer[0] := Byte(DefSerialComm.STX);
  TxBuffer[1] := $f5;
  TxBuffer[2] := $f1;
  TxBuffer[3] := btSigId;
  {$IFDEF 1PG2CH}
  TxBuffer[4] := m_nPgNo;
  {$ELSE}
  TxBuffer[4] := 0;
  {$ENDIF}
  CopyMemory(@TxBuffer[5],@wLen,2);
  if wLen > 0 then CopyMemory(@TxBuffer[7],@TxBuf[0],wLen);
  TxBuffer[7 + wLen] := Byte(DefSerialComm.ETX);

	try
    {$IFDEF SIMULATOR_PG}
    if m_ABindingPg = nil then m_nRemotePortPg := TernaryOp((m_nPgNo=DefPocb.PG_1), 60000, 60001);
    {$ELSE}
    m_nRemotePortPg := DefPG.PGSPI_DEFAULT_PORT;
    {$ENDIF}

    if (btSigId = DefPG.SIG_PG_CONN_CHECK) or (btSigId = DefPG.SIG_PG_RESET) then begin
      UdpServer.udpSvr.SendBuffer(m_sPgIP,m_nRemotePortPg, TxBuffer);
    end
    else begin
      if m_ABindingPg <> nil then m_ABindingPg.SendTo(m_sPgIP, m_nRemotePortPg, TxBuffer)
      else                        Exit;
    end;
    // debug/maint log
    if (btSigId = DefPG.SIG_PG_CONN_CHECK)        then nDebugMsgType := DEBUG_LOG_MSGTYPE_CONNCHECK
    else if (btSigId = DefPG.SIG_PG_READ_VOLTCUR) then nDebugMsgType := DEBUG_LOG_MSGTYPE_POWERREAD
    else                                               nDebugMsgType := DEBUG_LOG_MSGTYPE_INSPECT;
    if (Common.m_nDebugLogLevelActive[DEBUG_LOG_DEVTYPE_PG] >= nDebugMsgType) then
      Common.DebugLog(m_nPgNo, DEBUG_LOG_DEVTYPE_PG, nDebugMsgType, 'TX', Self.m_sPgIP, TxBuffer);
    if UdpServer.FIsMainter and Assigned(UdpServer.OnTxDataForMaint) and (nDebugMsgType = DEBUG_LOG_MSGTYPE_INSPECT) then begin
      UdpServer.OnTxDataForMaint(DEBUG_LOG_DEVTYPE_PG,Self.m_nPgNo,Length(TxBuffer),TxBuffer);
    end;
    //
    if btSigId = DefPG.SIG_PG_PWR_AUTOCAL_DATA then begin   //#SIG_PG_POWERCAL_DATA //TBD:MERGE?
      Common.MLog(m_nPgNo, 'Request Cal Data : ' + UserUtils.Hex2String(TxBuffer));
    end;
	except
    //TBD?
	end;
end;

{$IFDEF INSPECTOR_FI} 
function TDongaPG.CheckPgPwrLimit(PwrDataPg: TPwrDataPg): Boolean; //TBD:MERGE? FoldFI(O) POCB(X)
var
  sMsg, sTemp : string;
  bRet : Boolean;
  nTemp, nLimit : Integer;
begin
  nTemp := 0;
  bRet := True;

  case Common.SystemInfo.PG_TYPE of
    PG_TYPE_DP489 : begin   // DP489: ModelInfo(1=1mV,1=1mA), Pg.ReadVal(1=10mV,1=10mA)
      with Common.TestModelInfoPGSPI do begin
        case PwrDataPg.NG of
          0: begin  // VCC_H
            nLimit := PWR_LIMIT_H[DefPocb.PWR_VCC];
            sMsg := Format('VCC High NG : Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',
                  [nLimit/1000, htons(PwrDataPg.VCC)/100, htons(PwrDataPg.VCC)/100 - nLimit/1000]);
            bRet := False;
          end;
          1: begin  // VCC_L
            nLimit := PWR_LIMIT_L[DefPocb.PWR_VCC];
            sMsg := Format('VCC Low NG : Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',
                  [nLimit/1000, htons(PwrDataPg.VCC)/100, htons(PwrDataPg.VCC)/100 - nLimit/1000]);
            bRet := False;
            nTemp := 1; // for Low Limit Count
          end;
          2: begin  // VEL_H
            nLimit := PWR_LIMIT_H[DefPocb.PWR_VEL];
            sMsg := Format('VEL High NG : Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',
                  [nLimit/1000, htons(PwrDataPg.VEL)/100, htons(PwrDataPg.VEL)/100 - nLimit/1000]);
            bRet := False;
          end;
          3: begin  // VEL_L
            nLimit := PWR_LIMIT_L[DefPocb.PWR_VEL];
            sMsg := Format('VEL Low NG : Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',
                  [nLimit/1000, htons(PwrDataPg.VEL)/100, htons(PwrDataPg.VEL)/100 - nLimit/1000]);
            bRet := False;
            nTemp := 1; // for Low Limit Count
          end;
        //4:        // VBR_H
        //5:        // VBR_L
          6: begin  // ICC_H
            nLimit := PWR_LIMIT_H[DefPocb.PWR_ICC];
            sMsg := Format('ICC High NG : Limit(%d mA), Measure(%d mA), Diff(%d mA)',
                  [nLimit, htons(PwrDataPg.ICC)*10, htons(PwrDataPg.ICC)*10 - nLimit]);
            bRet := False;
          end;
          7: begin  // ICC_L
            nLimit := PWR_LIMIT_L[DefPocb.PWR_ICC];
            sMsg := Format('ICC Low NG : Limit(%d mA), Measure(%d mA), Diff(%d mA)',
                  [nLimit, htons(PwrDataPg.ICC)*10, htons(PwrDataPg.ICC)*10 - nLimit]);
            bRet := False;
            nTemp := 1; // for Low Limit Count
          end;
          8: begin  // IEL_H
            nLimit := PWR_LIMIT_H[DefPocb.PWR_IEL];
            sMsg := Format('IEL High NG : Limit(%d mA), Measure(%d mA), Diff(%d mA)',
                  [nLimit, htons(PwrDataPg.IEL)*10, htons(PwrDataPg.IEL)*10 - nLimit]);
            bRet := False;
          end;
          9: begin  // IEL_L
            nLimit := PWR_LIMIT_L[DefPocb.PWR_IEL];
            sMsg := Format('IEL Low NG : Limit(%d mA), Measure(%d mA), Diff(%d mA)',
                  [nLimit, htons(PwrDataPg.IEL)*10, htons(PwrDataPg.IEL)*10 - nLimit]);
            bRet := False;
            nTemp := 1; // for Low Limit Count
          end;
        end;
      end;
    end;
    else begin  // DP200|DP201 : ModelInfo(1=1mV,1=1mA), Pg.ReadVal(1=1mV,1=1mA)
      with Common.TestModelInfoPGSPI do begin
        case ReadVal.NG of
          0: begin  // VCC_H
            nLimit := PWR_LIMIT_H[DefPocb.PWR_VCC];
            sMsg := Format('VCC High NG : Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',
                  [nLimit/1000, htons(PwrDataPg.VCC)/1000, htons(PwrDataPg.VCC)/1000 - nLimit/1000]);
            bRet := False;
          end;
          1: begin  // VCC_L
            nLimit := PWR_LIMIT_L[DefPocb.PWR_VCC];
            sMsg := Format('VCC Low NG : Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',
                  [nLimit/1000, htons(ReadVal.VCC)/1000, htons(PwrDataPg.VCC)/1000 - nLimit/1000]);
            bRet := False;
            nTemp := 1; // for Low Limit Count
          end;
          2: begin  // VEL_H
            nLimit := PWR_LIMIT_H[DefPocb.PWR_VDD_VEL];
            sMsg := Format('VEL High NG : Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',
                  [nLimit/1000, htons(PwrDataPg.VEL)/1000, htons(PwrDataPg.VEL)/1000 - nLimit/1000]);
            bRet := False;
          end;
          3: begin  // VEL_L
            nLimit := PWR_LIMIT_L[DefPocb.PWR_VDD_VEL];
            sMsg := Format('VEL Low NG : Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',
                  [nLimit/1000, htons(PwrDataPg.VEL)/1000, htons(PwrDataPg.VEL)/1000 - nLimit/1000]);
            bRet := False;
            nTemp := 1; // for Low Limit Count
          end;
        //4:        // VBR_H
        //5:        // VBR_L
          6: begin  // ICC_H
            nLimit := PWR_LIMIT_H[DefPocb.PWR_ICC];
            sMsg := Format('ICC High NG : Limit(%d mA), Measure(%d mA), Diff(%d mA)',
                  [nLimit, htons(PwrDataPg.ICC), htons(PwrDataPg.ICC) - nLimit]);
            bRet := False;
          end;
          7: begin  // ICC_L
            nLimit := PWR_LIMIT_L[DefPocb.PWR_ICC];
            sMsg := Format('ICC Low NG : Limit(%d mA), Measure(%d mA), Diff(%d mA)',
                  [nLimit, htons(PwrDataPg.ICC), htons(PwrDataPg.ICC) - nLimit]);
            bRet := False;
            nTemp := 1; // for Low Limit Count
          end;
          8: begin  // IEL_H
            nLimit := PWR_LIMIT_H[DefPocb.PWR_IDD_IEL];
            sMsg := Format('IEL High NG : Limit(%d mA), Measure(%d mA), Diff(%d mA)',
                  [nLimit, htons(PwrDataPg.IEL), htons(PwrDataPg.IEL) - nLimit]);
            bRet := False;
          end;
          9: begin  // IEL_L
            nLimit := PWR_LIMIT_L[DefPocb.PWR_IDD_IEL];
            sMsg := Format('IEL Low NG : Limit(%d mA), Measure(%d mA), Diff(%d mA)',
                  [nLimit, htons(PwrDataPg.IEL), htons(PwrDataPg.IEL) - nLimit]);
            bRet := False;
            nTemp := 1; // for Low Limit Count
          end;
        end;
      end;
    end;
  end;

  if not bRet then begin
    SetPgPowerMeasureTimer(False, 0);
    ShowTestWindow(DefPocb.MSG_MODE_DISPLAY_ALARM,nTemp,sMsg); //TBD:MERGE? FOldFI
  end;
  Result := bRet;
end;
{$ENDIF} //INSPECTOR_FI

//==============================================================================
// PG TX/RX MESSAGE
//==============================================================================

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_OP_MODEL
//		- function TDongaPG.SendPgOpModel: DWORD;
//		- procedure TDongaPG.SendPgOpModelReq;
//		- function TDongaPG.MakePgOpModelData(var btaBuff: TIdBytes): Word;
//
function TDongaPG.SendPgOpModel: DWORD;
var
  sDebug : string;
begin
  // DP489/DP200|DP201
  sDebug := 'PG Model Info Download ';
  Result := CheckPgCmdAck(SendPgOpModelReq, DefPG.SIG_PG_OP_MODEL, 5000{nWaitMS}, 1{nRetry});
  case Result of
    WAIT_OBJECT_0 : sDebug := sDebug + 'OK';
    WAIT_FAILED   : sDebug := sDebug + 'NG(NAK)';
    WAIT_TIMEOUT  : sDebug := sDebug + 'NG(TIME OUT)';
    else            sDebug := sDebug + 'NG(ELSE)';
  end;
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, TernaryOp(Result=WAIT_OBJECT_0,0,DefPocb.LOG_TYPE_NG));

  //-----|DP200|DP201
  if Common.TestModelInfo[m_nPgNo].PwrSeqExtUse then begin
    sDebug := 'PG Model Info(ExtPowerSeq) Download ';
    Result := CheckPgCmdAck(SendPgExtPowerSeqReq, DefPG.SIG_PG_EXT_POWER_SEQ, 3000{nWaitMS}, 1{nRetry});
    case Result of
      WAIT_OBJECT_0 : sDebug := sDebug + 'OK';
      WAIT_FAILED   : sDebug := sDebug + 'NG(NAK)';
      WAIT_TIMEOUT  : sDebug := sDebug + 'NG(TIME OUT)';
      else            sDebug := sDebug + 'NG(ELSE)';
    end;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, TernaryOp(Result=WAIT_OBJECT_0,0,DefPocb.LOG_TYPE_NG));
  end;
end;

procedure TDongaPG.SendPgOpModelReq;
var
  TxBuf   : TIdBytes;
  btSigId : Byte;
  wLen    : Word;
  btaData : TIdBytes;
begin
  SetLength(btaData, 1024);
  //
  btSigId := DefPG.SIG_PG_OP_MODEL;
  wLen    := MakePgOpModelData(btaData);
  //
  SetLength(TxBuf, wLen);
  CopyMemory(@TxBuf[0], @btaData[0], wLen);
  SendPgData(btSigId, wLen, TxBuf);
end;

function TDongaPG.MakePgOpModelData(var btaBuff: TIdBytes): Word;
var
  nCnt : Integer;
  i : Integer;
  btTemp : byte;
  wTemp, wCrc16, wLen : word;
begin
  nCnt := 0;
  wCrc16 := 0;

  with Common.TestModelInfo[m_nPgNo] do begin  //-----------------------------------

    // unsigned char mode0;  // bit[5:4](0:Atype,1:Btype,2:Ctype,3:LG), bit[3:2](0:6bit,1:8bit,2:10bit,3:12bit), bit[1:0](0:Single,1:Dual)
    btTemp := (Rotate shl 4) or (Bit shl 2) or PixelType; CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // mode 0

    // unsigned char mode1;  // bit[7:4](ClockDelay:0~15), bit[3:0](1:LVDS,2.eDP_4Lane,5:Quad)
    btTemp := 0;      //ModelInfo(cmbxDispModeSignalType=SigType) //Sig.OpModel.model[3:0]
    case SigType of   //  (0:LVDS,1:QUAD,2:eDP4Lane,3:eDP8Lane)   //  (1:LVDS,5:QUAD,2:eDP4Lane,9:eDP8Lane)
      DefPG.PG_MODELINFO_SIGTYPE_LVDS     : btTemp := DefPG.PGSIG_OPMODEL_SIGTYPE_LVDS;     // LVDS
      DefPG.PG_MODELINFO_SIGTYPE_QUAD     : btTemp := DefPG.PGSIG_OPMODEL_SIGTYPE_QUAD;     // Quad.
      DefPG.PG_MODELINFO_SIGTYPE_eDP4Lane : btTemp := DefPG.PGSIG_OPMODEL_SIGTYPE_eDP4Lane; // eDP_4Lane
      DefPG.PG_MODELINFO_SIGTYPE_eDP8Lane : btTemp := DefPG.PGSIG_OPMODEL_SIGTYPE_eDP8Lane; // eDP_8Lane  //DP200|DP201
    end;
    btTemp := (ClockDelay shl 4) or btTemp; btaBuff[nCnt] := btTemp;   Inc(nCnt);        // mode1

    wTemp := (Word(Round(Freq))); CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // Freq
    wTemp := (Word(H_Total));     CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // H_Total
    wTemp := (Word(H_Active));    CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // H_Active
    wTemp := (Word(H_BP));        CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // H_Bpo
    wTemp := (Word(H_Width));     CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // H_Width
    wTemp := (Word(V_Total));     CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // V_Total
    wTemp := (Word(V_Active));    CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // V_Active
    wTemp := (Word(V_BP));        CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // V_Bpo
    wTemp := (Word(V_Width));     CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // V_Width

    // MODELINFO_POWER_mVmA: ModelInfo(1=1mV,1=mA) -> DP200.Msg(1=1mV,1=1mA),DP489.Msg(1=100mV,1=100mA)
    case Common.SystemInfo.PG_TYPE of
      DefPG.PG_TYPE_DP489: begin //DP489
        btTemp := Byte((PWR_VOL[DefPG.PWR_VCC] + PWR_OFFSET[DefPG.PWR_VCC]) div 100);         btaBuff[nCnt] := btTemp;             Inc(nCnt); // VCC
        btTemp := 0;                                                                          btaBuff[nCnt] := btTemp;             Inc(nCnt); // VddXXX
        wTemp  := word((PWR_VOL[DefPG.PWR_VDD_VEL] + PWR_OFFSET[DefPG.PWR_VDD_VEL]) div 100); CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // VDD_VEL
      end;
      else begin //DP200|DP201
        wTemp := word(PWR_VOL[DefPG.PWR_VCC] + PWR_OFFSET[DefPG.PWR_VCC]);         CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // VCC
        wTemp := 0;                                                                CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // VddXXX
        wTemp := word(PWR_VOL[DefPG.PWR_VDD_VEL] + PWR_OFFSET[DefPG.PWR_VDD_VEL]); CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // VDD_VEL
      end;
    end;

    // FinalVBRa|FinalVBRb
    btTemp := Byte(PWR_VOL[DefPG.PWR_VBR] div 100); btaBuff[nCnt] := btTemp; Inc(nCnt); //FinalVBRa: PG(1PG2CH) 1CH VBR Voltage //DP489/DP200: ModelInfo(1=1mV) -> Pg(1=100mV)
    btTemp := Byte(PWR_VOL[DefPG.PWR_VBR] div 100); btaBuff[nCnt] := btTemp; Inc(nCnt); //FinalVBRb: PG(1PG2CH) 2CH VBR Voltage //DP489/DP200: ModelInfo(1=1mV) -> Pg(1=100mV)

    // Dummy(4 bytes)
    btTemp := 0;
    btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
    btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
    btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
    btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy

    // PWM_Freq|PWM_Duty
    {$IFDEF PANEL_FOLD}
    wTemp := TernaryOp(TestModelInfo2[m_nPgNo].UsePwm,Pwm_freq*10,0);      CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; //2022-07-25 (Pwm_freq: 100.0Hz -> 1000)
    wTemp := TernaryOp(TestModelInfo2[m_nPgNo].UsePwm,Pwm_duty*10,100*10); CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; //2022-07-25 (Pwm_duty: 1byte->2byte, 50.0% -> 500)
    {$ELSE}
    wTemp := 0; CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; //AutoPOCB(No Use PWM):(Pwm_freq: default=0)
    wTemp := 0; CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; //AutoPOCB(No Use PWM):(Pwm_duty: default=0)
    {$ENDIF}

		// PowerLimit
    // 	- MODELINFO_POWER_mVmA: ModelInfo(1=1mV,1=mA) -> DP200.Msg(1=1mV,1=1mA),DP489.Msg(1=100mV,1=100mA)
    case Common.SystemInfo.PG_TYPE of
      PG_TYPE_DP489: begin
        btTemp := Byte(PWR_LIMIT_H[DefPG.PWR_VCC] div 100);     btaBuff[nCnt] := btTemp;             Inc(nCnt);        // VCC_HL
        btTemp := Byte(PWR_LIMIT_L[DefPG.PWR_VCC] div 100);     btaBuff[nCnt] := btTemp;             Inc(nCnt);        // VCC_LL
        wTemp  := (PWR_LIMIT_H[DefPG.PWR_VDD_VEL] div 100);     CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // ELVdd_HL
        wTemp  := (PWR_LIMIT_L[DefPG.PWR_VDD_VEL] div 100);     CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // ELVdd_LL
        btTemp := Byte(PWR_LIMIT_H[DefPG.PWR_ICC] div 100);     btaBuff[nCnt] := btTemp;             Inc(nCnt);        // ICC_HL
        btTemp := Byte(PWR_LIMIT_L[DefPG.PWR_ICC] div 100);     btaBuff[nCnt] := btTemp;             Inc(nCnt);        // ICC_LL
        btTemp := Byte(PWR_LIMIT_H[DefPG.PWR_IDD_IEL] div 100); btaBuff[nCnt] := btTemp;             Inc(nCnt);        // ELidd_HL
        btTemp := Byte(PWR_LIMIT_L[DefPG.PWR_IDD_IEL] div 100); btaBuff[nCnt] := btTemp;             Inc(nCnt);        // ELidd_LL
      end;
      else begin  //DP200|DP201
        wTemp := Word(PWR_LIMIT_H[DefPG.PWR_VCC]);     CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // VCC_HL
        wTemp := Word(PWR_LIMIT_L[DefPG.PWR_VCC]);     CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // VCC_LL
        wTemp := Word(PWR_LIMIT_H[DefPG.PWR_VDD_VEL]); CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // ELVdd_HL
        wTemp := Word(PWR_LIMIT_L[DefPG.PWR_VDD_VEL]); CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // ELVdd_LL
        wTemp := Word(PWR_LIMIT_H[DefPG.PWR_ICC]);     CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // ICC_HL
        wTemp := Word(PWR_LIMIT_L[DefPG.PWR_ICC]);     CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // ICC_LL
        wTemp := Word(PWR_LIMIT_H[DefPG.PWR_IDD_IEL]); CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // ELidd_HL
        wTemp := Word(PWR_LIMIT_L[DefPG.PWR_IDD_IEL]); CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // ELidd_LL
      end;
    end;
		//TBD? A2CHv3: VBR_HL|VBR_LL=0 //TBD:MERGE?PG_MODEL?
    btTemp := Byte(PWR_LIMIT_H[DefPG.PWR_VBR] div 100);  btaBuff[nCnt] := btTemp; Inc(nCnt); // VBR_HL //DP489/DP200: ModelInfo(1=1mV) -> Pg(1=100mV)
    btTemp := Byte(PWR_LIMIT_L[DefPG.PWR_VBR] div 100);  btaBuff[nCnt] := btTemp; Inc(nCnt); // VBR_LL //DP489/DP200: ModelInfo(1=1mV) -> Pg(1=100mV)

		// Power Sequence (Timing)
    for i := 0 to 2 do begin
      wTemp := (PowerOnSeq[i]);  CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // OnSeqTime[3]
    end;
    for i := 0 to 2 do begin
      wTemp := (PowerOffSeq[i]); CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2; // OffSeqTime[3]
    end;

    // unsigned char sequence; //bit[7:4] I2C Clock Delay(0:2.5K, 1:5K, 2:10K, 3:18K, 4:34K, 5:75K, 6:125K, 7:240K, 8:300K) bit[3:0](0: Vcc->Sig->VEL->VEL_ON, 1:Sig->Vcc->VEL->VEL_ON)
    btTemp := (I2cFreq shl 4) or Sequence;                                         btaBuff[nCnt] := btTemp; Inc(nCnt); // Sequence
    // unsigned char option; (default:0) //bit[7]:InvCableCount, bit[6]OPC, bit[5]:LvdsSel, bit[4]:WP, bit[3]:ADsel?PDC?, bit[2]:InvCable, bit[1]:UserCable, bit[0]:LSDeven
    btTemp := TernaryOp((Common.SystemInfo.PG_TYPE=PG_TYPE_DP489), 0, (WP shl 4)); btaBuff[nCnt] := btTemp; Inc(nCnt); // Option //TBD:MERGE? DP489?

    btTemp := 3; btaBuff[nCnt] := btTemp; Inc(nCnt); // BRTI_sel (default=3) //2022-07-25 AutoPOCB(No Use PWM):(BRTI_sel: 0=FromLCM_VBR, 1=VBRa, 2=VBRb, 3=PWM/default)
    btTemp := 0; btaBuff[nCnt] := btTemp; Inc(nCnt); // BRTP                 //2022-07-25 AutoPOCB(No Use PWM):(BRTP_sel: 0=FromLCM_VBR/default, 1=VBRa, 2=VBRb, 3=PWM)

    case Common.SystemInfo.PG_TYPE of
      PG_TYPE_DP489: begin
        btTemp := Byte((PWR_VOL[DefPG.PWR_VCC] + PWR_OFFSET[DefPG.PWR_VCC]) mod 100);         btaBuff[nCnt] := btTemp; Inc(nCnt); // VCC LSB    (e.g, 12.15  V -> 50)
        btTemp := 0;                                                                          btaBuff[nCnt] := btTemp; Inc(nCnt); // VddXXX_LSB (e.g, 12.15  V -> 50)
        btTemp := Byte((PWR_VOL[DefPG.PWR_VDD_VEL] + PWR_OFFSET[DefPG.PWR_VDD_VEL]) mod 100); btaBuff[nCnt] := btTemp; Inc(nCnt); // VDD_VEL LSB  (e.g, 12.15  V -> 50)
        btTemp := Byte(PWR_LIMIT_H[DefPG.PWR_VCC] mod 100);     btaBuff[nCnt] := btTemp; Inc(nCnt); // VCC_HL_LSB (e.g, 12.15  V -> 50)
        btTemp := Byte(PWR_LIMIT_L[DefPG.PWR_VCC] mod 100);     btaBuff[nCnt] := btTemp; Inc(nCnt); // VCC_LL_LSB (e.g, 12.15  V -> 50)
        btTemp := Byte(PWR_LIMIT_H[DefPG.PWR_VDD_VEL] mod 100); btaBuff[nCnt] := btTemp; Inc(nCnt); // VEL_HL_LSB (e.g, 12.15  V -> 50)
        btTemp := Byte(PWR_LIMIT_L[DefPG.PWR_VDD_VEL] mod 100); btaBuff[nCnt] := btTemp; Inc(nCnt); // VEL_LL_LSB (e.g, 12.15  V -> 50)
        btTemp := Byte(PWR_LIMIT_H[DefPG.PWR_ICC] mod 100);     btaBuff[nCnt] := btTemp; Inc(nCnt); // ICC_HL_LSB (e.g,  1.198 A -> 98)
        btTemp := Byte(PWR_LIMIT_L[DefPG.PWR_ICC] mod 100);     btaBuff[nCnt] := btTemp; Inc(nCnt); // ICC_LL_LSB (e.g,  1.198 A -> 98)
        btTemp := Byte(PWR_LIMIT_H[DefPG.PWR_IDD_IEL] mod 100); btaBuff[nCnt] := btTemp; Inc(nCnt); // IEL_HL_LSB (e.g,  1.198 A -> 98)
        btTemp := Byte(PWR_LIMIT_L[DefPG.PWR_IDD_IEL] mod 100); btaBuff[nCnt] := btTemp; Inc(nCnt); // IEL_LL_LSB (e.g,  1.198 A -> 98)
        //
        btaBuff[nCnt] := Byte(PWR_OFFSET[DefPG.PWR_VCC] div 10);     ; Inc(nCnt); // VCC_OFFSET     ModelInfo(0~2.55)->PG_MSG(1=10mV) //2022-09-05
        btaBuff[nCnt] := Byte(PWR_OFFSET[DefPG.PWR_VDD_VEL] div 10); ; Inc(nCnt); // VDD_VEL_OFFSET ModelInfo(0~2.55)->PG_MSG(1=10mV) //2022-09-05
        // Dummy[1] (1 char --> 1 bytes)  //2022-09-05 (dummy: 3->1)
        btTemp := 0; btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
      end;
      else begin  //DP200|DP201
        // Dummy[6] (1 char, 2 short, 1 char --> 6 bytes)
        btTemp := 0; btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
        btTemp := 0; btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
        btTemp := 0; btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
        btTemp := 0; btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
        btTemp := 0; btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
        btTemp := 0; btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
      end;
    end;

    btTemp := 3; btaBuff[nCnt] := btTemp; Inc(nCnt); // Inverter type (Default=3)

    // Dummy[4] (4 char -> 4 bytes)
    btTemp := 0;         btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
    btTemp := 0;         btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
    btTemp := 0;         btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy
    btTemp := 0;         btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy

    btTemp := I2cPullup; btaBuff[nCnt] := btTemp; Inc(nCnt); // I2C Pullup.

    // Dummy[22]
    btTemp := 0;
    for i := 1 to 22 do begin
      btaBuff[nCnt] := btTemp; Inc(nCnt); //Dummy[23]
    end;

    btTemp := OpenCheck; btaBuff[nCnt] := btTemp; Inc(nCnt); // OpenCheck //2023-10-18 DP200|DP201
    btTemp := ModelType; btaBuff[nCnt] := btTemp; Inc(nCnt); // ModelType //2022-10-12

    case Common.SystemInfo.PG_TYPE of
      DefPG.PG_TYPE_DP489: btTemp := 0;  //DP489(Dummy)
      else                 btTemp := TernaryOp(PwrSeqExtUse, 1, 0);  //DP20x(Ext Power Sequence)
    end; 
		btaBuff[nCnt] := btTemp; Inc(nCnt);
    btTemp := DataLineOut; btaBuff[nCnt] := btTemp; Inc(nCnt); // Data_LineOut

    // FPGA Timing
    FpgaTiming := TernaryOp((SigType = 0), Common.FpgaData[0].FpgaTime{LVDS|Dual}, Common.FpgaData[1].FpgaTime{Quad|eDP4Lane|eDP8Lane}); // FPGA Timing. //TBD:MERGE?PG_MODEL?
    wTemp := (Word(FpgaTiming)); CopyMemory(@btaBuff[nCnt],@wTemp,2); nCnt := nCnt + 2;

  end; // with Common.TestModelInfo --------------------------------------

  // CRC16
  wCrc16 := Common.crc16(PAnsiChar(@btaBuff[0]), nCnt); //TBD:MERGE? FOld(AnsiString) POCB(PAnsiChar)
  CopyMemory(@btaBuff[nCnt],@wCrc16,2);  nCnt := nCnt + 2;
  wLen := word(nCnt);
  Result := wLen;
end;

//------------------------------------------------------------------------------
// PG(-----|DP200|DP201) SIG_PG_OP_ALDP_MODEL
//		- function TDongaPG.SendPgOpModelALDP: DWORD;
//		- procedure TDongaPG.SendPgOpModel2ALDPReq;
//		- function TDongaPG.MakePgOpModel2ALDPData(var btaBuff: TIdBytes): Word;
//
function TDongaPG.SendPgOpModelALDP: DWORD;
var
  sDebug : string;
begin
  sDebug := 'PG(ALDP) Model Info Download ';
  Result := CheckPgCmdAck(SendPgOpModel2ALDPReq, DefPG.SIG_PG_OP_ALDP_MODEL, 5000{nWaitMS}, 2{nRetry});
  case Result of
    WAIT_OBJECT_0 : sDebug := sDebug + 'OK';
    WAIT_FAILED   : sDebug := sDebug + 'NG(NAK)';
    WAIT_TIMEOUT  : sDebug := sDebug + 'NG(TIME OUT)';
    else            sDebug := sDebug + 'NG(ELSE)';
  end;
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, TernaryOp(Result=WAIT_OBJECT_0,0,DefPocb.LOG_TYPE_NG));
end;

procedure TDongaPG.SendPgOpModel2ALDPReq;
var
  TxBuf   : TIdBytes;
  btSigId : Byte;
  wLen    : Word;
  btaData : TIdBytes;
begin
  btSigId := DefPG.SIG_PG_OP_ALDP_MODEL;
  SetLength(btaData, 1024);
  wLen    := MakePgOpModel2ALDPData(btaData);
  //
  SetLength(TxBuf, wLen);
  CopyMemory(@TxBuf[0], @btaData[0], wLen);
  SendPgData(btSigId, wLen, TxBuf);
end;

// DP200/DP201
function TDongaPG.MakePgOpModel2ALDPData(var btaBuff: TIdBytes): Word;
var
  nCnt : Integer;
  i : Integer;
  btTemp : byte;
  wTemp, wCrc16, wLen : word;
begin
  nCnt   := 0;
  wCrc16 := 0;

  with Common.TestModelInfoALDP[m_nPgNo] do begin //--------------
    //
    btTemp := Byte(SPI_PULLUP);  CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 0: disable, 1: enable
    btTemp := Byte(SPI_SPEED);   CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 0: 400KHz, 1: 780KHz, 2: 1.5MHz, 3: 3MHz, 4: 6.25MHz, 5: 12.5MHz
    btTemp := Byte(SPI_MODE);    CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 0: Library(0으로 고정), 1: GPIO
    btTemp := Byte(SPI_LEVEL);   CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 0: 1.2V, 1:1.8V, 2: 3.3V(Default 0)
    btTemp := Byte(I2C_LEVEL);   CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 0: 1.2V, 1:1.8V, 2: 3.3V(Default 0)
    //
    wTemp := Word(ALPDP_LINK_RATE);   CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_H_FDP);       CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_H_SDP);       CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_H_PCNT);      CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_VB_SLEEP);    CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_VB_N2);       CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_VB_N3);       CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_VB_N4);       CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_VB_N5B);      CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_VB_N7);       CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_VB_N5A);      CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    //
    wTemp := Word(ALPDP_MSA_MVID);    CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_MSA_NVID);    CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_MSA_HTOTAL);  CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_MSA_HSTART);  CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_MSA_HWIDTH);  CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_MSA_VTOTAL);  CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_MSA_VSTART);  CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_MSA_VHEIGHT); CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_MSA_HSP_HSW); CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_MSA_VSP_VSW); CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_MSA_MISC0);   CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    wTemp := Word(ALPDP_MSA_MISC1);   CopyMemory(@btaBuff[nCnt],@wTemp,2);  nCnt := nCnt + 2;
    //
    btTemp := Byte(ALPDP_SPECIAL_PANEL); CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt);
    btTemp := Byte(ALPDP_ALPM);          CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 0: Disable, 1: Enable
    btTemp := Byte(ALPDP_LINK_MODE);     CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 0: Manual, 1: Auto
    btTemp := Byte(ALPDP_CHOP_SIZE);     CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt);
    btTemp := Byte(ALPDP_CHOP_SECTION);  CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt);
    btTemp := Byte(ALPDP_CHOP_ENABLE);   CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt);
    btTemp := Byte(ALPDP_HPD_CHECK);     CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 0: HPD Check, 1: HPD Not Check(Default HPD Check)
    btTemp := Byte(ALPDP_SCRAMBLE_SET);  CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 0: Disable, 1: Enable
    btTemp := Byte(ALPDP_LANE_SETTING);  CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 1~8 Lane
    btTemp := Byte(ALPDP_SLAVE_ENABLE);  CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 0: Disable, 1: Enable
    //
    btTemp := Byte(ALPDP_SWING_LEVEL);       CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); //
    btTemp := Byte(ALPDP_PRE_EMPHASIS_PRE);  CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); //
    btTemp := Byte(ALPDP_PRE_EMPHASIS_POST); CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); //
    btTemp := Byte(ALPDP_AUX_FREQ_SET);      CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); //
    //
    btTemp := Byte(DP141_IF_SET);   CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); //
    btTemp := Byte(DP141_CNT_SET);  CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); //
    btTemp := Byte(EDID_SKIP);      CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); //
    btTemp := Byte(DEBUG_LEVEL);    CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); //
    btTemp := Byte(eDP_SPEC_OPT);   CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); // 2023-03-24 Tributo
    // Dummy[50]
    for i := 0 to 49 do begin // 2023-03-24 50->49
      btaBuff[nCnt] := 0; Inc(nCnt);
    end;
    // CRC16
    wCrc16 := (Common.Crc16(Ansistring(@btaBuff[0]), nCnt));
    CopyMemory(@btaBuff[nCnt],@wCrc16,2);  nCnt := nCnt + 2;
  end; // with Common.TestModelInfoALDP
  //
  wLen := Word(nCnt);
  Result := wLen;
end;

//------------------------------------------------------------------------------
// PG(-----|DP200|DP201) SIG_PG_EXT_POWER_SEQ
//		- procedure TDongaPG.SendPgExtPowerSeqReq;
//		- function TDongaPG.MakePgExtPowerSeqData(var btaBuff: TIdBytes): Word;
//
procedure TDongaPG.SendPgExtPowerSeqReq;  // DP200/DP201
var
  TxBuf   : TIdBytes;
  btSigId : Byte;
  wLen    : Word;
  btaData : TIdBytes;
begin
  SetLength(btaData, 1024);
  //
  btSigId := DefPG.SIG_PG_EXT_POWER_SEQ;
  wLen    := MakePgExtPowerSeqData(btaData);
  //
  SetLength(TxBuf, wLen);
  CopyMemory(@TxBuf[0], @btaData[0], wLen);
  SendPgData(btSigId, wLen, TxBuf);
end;

function TDongaPG.MakePgExtPowerSeqData(var btaBuff: TIdBytes): Word; // DP200/DP201
var
  wTemp, wLen : Word;
  i, nCnt : Integer;
  btTemp  : byte;
begin
  nCnt := 0;
  with Common.TestModelInfo[m_nPgNo] do begin
    btTemp := Byte(PwrSeqExtAvailCnt);     CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); //Ext_Seqence_Count
    for i := 0 to 24 do begin
      btTemp := Byte(PwrSeqExtOnIdx[i]);   CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); //On_Index
    end;
    for i := 0 to 24 do begin
      btTemp := Byte(PwrSeqExtOffIdx[i]);  CopyMemory(@btaBuff[nCnt],@btTemp,1);  Inc(nCnt); //Off_Index
    end;
    for i := 0 to 24 do begin
      wTemp := Word(PwrSeqExtOnDelay[i]);  CopyMemory(@btaBuff[nCnt],@wTemp,2);   nCnt := nCnt + 2;  //On_Delay_Time
    end;
    for i := 0 to 24 do begin
      wTemp := Word(PwrSeqExtOffDelay[i]); CopyMemory(@btaBuff[nCnt],@wTemp,2);   nCnt := nCnt + 2;  //Off_Delay_Time
    end;
  end;
  //
  wLen := Word(nCnt);
  Result := wLen;
end;

//------------------------------------------------------------------------------
// PG(-----|DP200|DP201) SIG_PG_DISPLAY_PAT
//		- function TDongaPG.SendPgDisplayPatNum(nPatNum: Integer; nWaitMS: Integer = 3000; nRetry: Integer = 1): DWORD;
//		- procedure TDongaPG.SendPgDisplayPatReq(nCmdType, nPatNum: Integer; nBmpCompensate: Byte = 0);
//		- function TDongaPG.SendPgDisplayDownBmp(nIdx: Integer; nWaitMS: Integer = 3000; nRetry: Integer = 1): DWORD;
//		- procedure TDongaPG.SendPgDisplayDownBmpReq(nIdx : Integer);
//
function TDongaPG.SendPgDisplayPatNum(nPatNum: Integer; nWaitMS: Integer = 3000; nRetry: Integer=1): DWORD;
var
  sDebug : string;
begin
  sDebug := Format('Pattern Display PAT#%d (%s)',[nPatNum,FCurPatGrpInfo.PatName[nPatNum]]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
  {$IFDEF INSPECTOR_POCB}
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_PATTERN,'', nPatNum);
  {$ENDIF}
	//
  Result := CheckPgCmdAck(procedure begin SendPgDisplayPatReq(DefPG.PGSIG_DISPLAY_ON, nPatNum);end, DefPG.SIG_PG_DISPLAY_PAT,nWaitMS,nRetry);
end;

procedure TDongaPG.SendPgDisplayPatReq(nCmdType, nPatNum: Integer; nBmpCompensate: Byte = 0);
var
  btBuf             : TIdBytes;
  i, nPatIdx {, nBmp} : Integer;
  nToolType  : Integer;
  sPatName          : AnsiString;
  //dwTemp            : dword;
  wCnt, wTmp        : Word;
  wData             : Word;
begin
  try
    if nCmdType = DefPg.PGSIG_DISPLAY_OFF then begin
      SetLength(btBuf,6);
      btBuf[0]  := Byte(nCmdType);   // Off Command
      btBuf[1]  := 0;
      btBuf[2]  := 0;
      btBuf[3]  := 0;
      wCnt      := 4;
    end
    else begin  // PGSIG_DISPLAY_ON
      wCnt := 0;
      SetLength(btBuf,DefPG.PGSPI_PACKET_SIZE);
      sPatName    := ChangeFileExt(FCurPatGrpInfo.PatName[nPatNum],'');

      for nPatIdx := 0 to Pred(MAX_PATTERN_CNT) do begin
        if Trim(FDisPatStruct.PatInfo[nPatIdx].pat.Data.PatName) = sPatName then Break;
      end;

      btBuf[wCnt] := byte(nCmdType);   Inc(wCnt);
      case FCurPatGrpInfo.PatType[nPatNum] of
        0 : begin
          btBuf[wCnt] := 1;                                               Inc(wCnt);  //1:ComplexPattern
          btBuf[wCnt] := FDisPatStruct.PatInfo[nPatIdx].pat.Data.ToolCnt; Inc(wCnt);
        end;
        1 : begin
          btBuf[wCnt] := 3;                                               Inc(wCnt);  //3:BMP
          btBuf[wCnt] := nBmpCompensate;  Inc(wCnt);                                  //dummy
        end;
      end;
      // VSync
      if (FCurPatGrpInfo.VSync[nPatNum] <> 0) or
        (FCurPatGrpInfo.VSync[m_nOldPatNum] <> FCurPatGrpInfo.VSync[nPatNum]) then begin
        btBuf[wCnt] := FCurPatGrpInfo.VSync[nPatNum]; Inc(wCnt);
      end
      else  begin
        btBuf[wCnt] := 0; Inc(wCnt);
      end;
      // Vcc
      btBuf[wCnt] := 0;  Inc(wCnt);
      // Vdd
      btBuf[wCnt] := 0;  Inc(wCnt);
      // Vbr
      btBuf[wCnt] := 0;  Inc(wCnt);
      // Mclk
      wTmp := 0;
      CopyMemory(@btBuf[wCnt],@wTmp,2);                 wCnt := wCnt + 2;

      // Check Sum //TBD:MERGE? (Not Used?)
      wTmp := 0;
      for i := 0 to Pred(wCnt) do begin
        wTmp := wTmp + btBuf[i];
      end;
      CopyMemory(@btBuf[wCnt],@wTmp,2);                 wCnt := wCnt + 2;

      if FCurPatGrpInfo.PatType[nPatNum] = 0 then begin  //non-BMP
        for i:= 0 to FDisPatStruct.PatInfo[nPatIdx].pat.Data.ToolCnt-1 do begin
          btBuf[wCnt] := FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.ToolType;   Inc(wCnt);
          btBuf[wCnt] := FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.Direction;  Inc(wCnt);
          wTmp := (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.Level);
          CopyMemory(@btBuf[wCnt], @wTmp, 2);            wCnt := wCnt + 2;

          // SX
          if (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.sx <> '') then begin
            wData := (Common.GetDrawPosPG(m_nPgNo,FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.sx));
            CopyMemory(@btBuf[wCnt], @wData, 2);
          end;       wCnt := wCnt + 2;
          // SY
          if (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.sy <> '') then begin
            wData := (Common.GetDrawPosPG(m_nPgNo,FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.sy));
            CopyMemory(@btBuf[wCnt], @wData, 2);
          end;      wCnt := wCnt + 2;
          // EX
          if (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.ex <> '') then begin
            wData := (Common.GetDrawPosPG(m_nPgNo,FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.ex));
            CopyMemory(@btBuf[wCnt], @wData, 2);
          end;       wCnt := wCnt + 2;
          // EY
          if (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.ey <> '') then begin
            wData := (Common.GetDrawPosPG(m_nPgNo,FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.ey));
            CopyMemory(@btBuf[wCnt], @wData, 2);
          end;        wCnt := wCnt + 2;
          // MX
          if (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.mx <> '') then begin
            wData := (Common.GetDrawPosPG(m_nPgNo,FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.mx));
            CopyMemory(@btBuf[wCnt], @wData, 2);
          end;        wCnt := wCnt + 2;
          // MY
          if (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.my <> '') then begin
            wData := (Common.GetDrawPosPG(m_nPgNo,FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.my));
            CopyMemory(@btBuf[wCnt], @wData, 2);
          end;        wCnt := wCnt + 2;

          nToolType := FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.ToolType;
          if nToolType in [ ALL_H_GRAY, ALL_V_GRAY, ALL_C_GRAY,	ALL_H_GRAY2, ALL_V_GRAY2, ALL_C_GRAY2] then begin
            wTmp := (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.R);
            CopyMemory(@btBuf[wCnt], @wTmp, 2);       wCnt := wCnt + 2;
            wTmp := (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.G);
            CopyMemory(@btBuf[wCnt], @wTmp, 2);       wCnt := wCnt + 2;
            wTmp := (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.B);
            CopyMemory(@btBuf[wCnt], @wTmp, 2);       wCnt := wCnt + 2;
          end
          else begin
            wTmp := (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.R);// div 16);
            if wTmp < 0 then wTmp := 0;
            CopyMemory(@btBuf[wCnt], @wTmp, 2);       wCnt := wCnt + 2;
            wTmp := (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.G);// div 16);
            if wTmp < 0 then wTmp := 0;
            CopyMemory(@btBuf[wCnt], @wTmp, 2);       wCnt := wCnt + 2;
            wTmp := (FDisPatStruct.PatInfo[nPatIdx].Tool[i].Data.B);// div 16);
            if wTmp < 0 then wTmp := 0;
            CopyMemory(@btBuf[wCnt], @wTmp, 2);       wCnt := wCnt + 2;
          end;
        end;
      end
      else begin //BMP
        for i := 1 to 32 do begin  //TBD:MERGE?
          if Length(sPatName) < i then begin
            btBuf[wCnt] := 0;
          end
          else begin
            btBuf[wCnt] := Byte(sPatName[i]);
          end;
          Inc(wCnt);
        end;
      end;

      wTmp := (Common.crc16(PAnsiChar(@btBuf[0]), wCnt));  //TBD:MERGE? (FoldFI: wTmp := (Common.crc16(Ansistring(btBuf), wCnt)); ....
      CopyMemory(@btBuf[wCnt],@wTmp,2);                 wCnt := wCnt + 2;
      m_nOldPatNum := nPatNum;
    end;
    SendPgData(DefPG.SIG_PG_DISPLAY_PAT, wCnt, btBuf);

    FDisPatStruct.CurrPat.nCurrPatNum    := 0;
    FDisPatStruct.CurrPat.nCurrAllPatIdx := 0; //index of AllPat
    FDisPatStruct.CurrPat.bSimplepaPat   := False;
    {$IFDEF FEATURE_GRAY_CHANGE}
    FDisPatStruct.CurrPat.bGrayChangeR := False;
    FDisPatStruct.CurrPat.bGrayChangeG := False;
    FDisPatStruct.CurrPat.bGrayChangeB := False;
    FDisPatStruct.CurrPat.nGrayOffset  := 0;
    {$ENDIF}

    if nCmdType = DefPg.PGSIG_DISPLAY_OFF then begin
      FDisPatStruct.CurrPat.bPatternOn   := False;
    end
    else begin
      FDisPatStruct.CurrPat.bPatternOn     := True;
      FDisPatStruct.CurrPat.nCurrPatNum    := nPatNum;
      FDisPatStruct.CurrPat.nCurrAllPatIdx := nPatIdx;
      if (FCurPatGrpInfo.PatType[nPatNum] = 0) and
            (FDisPatStruct.PatInfo[nPatIdx].pat.Data.ToolCnt = 1) and
            (FDisPatStruct.PatInfo[nPatIdx].Tool[0].Data.ToolType = ALL_FILL_BOX) then begin
        FDisPatStruct.CurrPat.bSimplepaPat := True;
        //
        {$IFDEF FEATURE_GRAY_CHANGE}
        if (FDisPatStruct.PatInfo[nPatIdx].Tool[0].Data.R <> 0) then FDisPatStruct.CurrPat.bGrayChangeR := True;
        if (FDisPatStruct.PatInfo[nPatIdx].Tool[0].Data.G <> 0) then FDisPatStruct.CurrPat.bGrayChangeG := True;
        if (FDisPatStruct.PatInfo[nPatIdx].Tool[0].Data.B <> 0) then FDisPatStruct.CurrPat.bGrayChangeB := True;
        //
        if (FDisPatStruct.PatInfo[nPatIdx].Tool[0].Data.R = 0) and (FDisPatStruct.PatInfo[nPatIdx].Tool[0].Data.G = 0)
            and (FDisPatStruct.PatInfo[nPatIdx].Tool[0].Data.B = 0) then begin  //black
          FDisPatStruct.CurrPat.bGrayChangeR := True;
          FDisPatStruct.CurrPat.bGrayChangeG := True;
          FDisPatStruct.CurrPat.bGrayChangeB := True;
        end;
        {$ENDIF}
      end;
    end;
  except

  end;

end;

function TDongaPG.SendPgDisplayDownBmp(nCompBmpIdx: Integer; nWaitMS: Integer=3000; nRetry: Integer=1): DWORD;
begin
  Result := CheckPgCmdAck(procedure begin SendPgDisplayDownBmpReq(nCompBmpIdx); end, DefPG.SIG_PG_DISPLAY_PAT, nWaitMS,nRetry);
end;

procedure TDongaPG.SendPgDisplayDownBmpReq(nCompBmpIdx: Integer);
var
  btBuf      : TIdBytes;
  i          : Integer;
  sPatName   : AnsiString;
  wCnt, wTmp : Word;
  sBmpDownName : string;
begin
  wCnt := 0;
  try
    sBmpDownName := DefPocb.COMPBMP_DOWN_NAME + Format('%d',[nCompBmpIdx]) + '.raw';  //2021-11-29 (add nIdx) //TBD:MERGE?
    sPatName := AnsiString(ChangeFileExt(sBmpDownName,''));
    SetLength(btBuf,DefPG.PGSPI_PACKET_SIZE);
    btBuf[wCnt] := DefPG.PGSIG_DISPLAY_ON; Inc(wCnt); // command
    btBuf[wCnt] := 3;                      Inc(wCnt); // Type.
		btBuf[wCnt] := $ff - nCompBmpIdx;      Inc(wCnt); // Download Compensation BMP

    // Vsync
    btBuf[wCnt] := 0; Inc(wCnt);
    // Vcc
    btBuf[wCnt] := 0;  Inc(wCnt);
    // Vdd
    btBuf[wCnt] := 0;  Inc(wCnt);
    // Vbr
    btBuf[wCnt] := 0;  Inc(wCnt);
    // Mclk
    wTmp := 0;
    CopyMemory(@btBuf[wCnt],@wTmp,2); wCnt := wCnt + 2;

    // Check Sum ==> Not Used?
    wTmp := 0;
    for i := 0 to Pred(wCnt) do begin
      wTmp := wTmp + btBuf[i];
    end;
    CopyMemory(@btBuf[wCnt],@wTmp,2); wCnt := wCnt + 2;

    for i := 1 to 32 do begin
      if Length(sPatName) < i then begin
        btBuf[wCnt] := 0;
      end
      else begin
        btBuf[wCnt] := Byte(sPatName[i]);
      end;
      Inc(wCnt);
    end;
    wTmp := (Common.crc16(PAnsiChar(@btBuf[0]), wCnt));
    CopyMemory(@btBuf[wCnt],@wTmp,2); wCnt := wCnt + 2;
  except
    //
  end;
  SendPgData(DefPG.SIG_PG_DISPLAY_PAT, wCnt, btBuf);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_READ_VOLTCUR
//		- function TDongaPG.SendPgPowerMeasure(bWaitAck: Boolean=False): DWORD;
//		- procedure TDongaPG.SendPgPowerMeasureReq;
//
function TDongaPG.SendPgPowerMeasure(bWaitAck: Boolean=False): DWORD; //FoldFI(bWaitAck=True) POCB(bWaitAck=False)
begin
  if bWaitAck then begin
    Result := CheckPgPwrCmdAck(SendPgPowerMeasureReq, SIG_PG_READ_VOLTCUR,3000{nWaitMS},1{nRetry});
  end
  else begin
    SendPgPowerMeasureReq;
  end;
end;

procedure TDongaPG.SendPgPowerMeasureReq;
var
  TxBuf : TIdBytes;
begin
	SetLength(TxBuf,1);
  SendPgData(DefPG.SIG_PG_READ_VOLTCUR, 0, TxBuf);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_PWR_ON
// PG(DP489|DP200|DP201) SIG_PG_PWR_OFF
//		- function TDongaPG.SendPgPowerOn(nMode: Integer; bFlashBufInit: Boolean=False; nWaitMS: Integer=5000; nRetry: Integer=0): DWORD;  //Auto
//		- function TDongaPG.SendPgPowerOn(nMode: Integer; bFlashBufInit: Boolean=False; nWaitMS: Integer=10000; nRetry: Integer=0): DWORD; //FoldFI(1PG2CH)
//		- function TDongaPG.SendPgPowerOn(nMode: Integer; bFlashBufInit: Boolean=True;  nWaitMS: Integer=5000; nRetry: Integer=0): DWORD;  //FoldPOCB
//		- procedure TDongaPG.SendPgPowerReq(nMode: Integer);
//
{$IFDEF PANEL_AUTO}
function TDongaPG.SendPgPowerOn(nMode: Integer; bFlashBufInit: Boolean = False; nWaitMS: Integer = 5000;  nRetry: Integer = 0): DWORD;
{$ELSE}
  {$IFDEF 1PG2CH}
function TDongaPG.SendPgPowerOn(nMode: Integer; bFlashBufInit: Boolean = False; nWaitMS: Integer = 10000; nRetry: Integer = 0): DWORD; //FoldFI(DP200:nWaitMS:3000->10000)
  {$ELSE}
function TDongaPG.SendPgPowerOn(nMode: Integer; bFlashBufInit: Boolean = True;  nWaitMS: Integer = 5000;  nRetry: Integer = 0): DWORD; //FoldPOCB
  {$ENDIF}
{$ENDIF}
var
  dwRtn : DWORD;
begin
  tmPowerMeasurePg.Enabled := False;  //TBD:MERGE? FOldFI(X) POCB(O)

  {$IFDEF FEATURE_FLASH_UNIT_RW}
  if bFlashBufInit then FlashClearUnitBuf;
  {$ENDIF}

  if nMode = 1 then begin     // nMode : 1 (Power On), 0 : Power Off.
    m_bPowerOn := True; //A2CHv3:ASSY-POCB:FLOW
    if (Common.TestModelInfo[m_nPgNo].ModelType <> 0) and (nWaitMS < 10000) then nWaitMS := 10000;  //2022-10-12

    dwRtn := CheckPgCmdAck(procedure begin SendPgPowerReq(nMode);end, SIG_PG_PWR_ON, nWaitMS,nRetry);
  //if (Common.SystemInfo.PgSpiMain = DefPG.PGSPI_MAIN_PG) then begin //TBD:MERGE? PSSPI_MAIN_PG?
      Sleep(200); //TBD:MERGE? FoldFI(100) AutoPOCB(200) FoldPOCB(X)
      case Common.SystemInfo.SPI_TYPE of
        SPI_TYPE_DJ023_SPI: begin
          SendSpiSigOnOff(0); // Power On  --- External On //TBD:MERGE? DJ023_SPI?
          dwRtn := WAIT_OBJECT_0;
        end;
        else begin //DJ021|DJ201
          dwRtn := CheckSpiCmdAck(procedure begin SendSpiPowerOnOffReq(nMode);end, DefPG.SIG_DJ021_POWER_ON_REQ, nWaitMS ,nRetry);
					{$IFDEF PANEL_AUTO}
          if nMode = 1 then begin  //ON
            Sleep(200);
            SendSpiEepromWp(0,1000{nWaitMS});  //WP Disable
            Sleep(10);
          end;
					{$ENDIF}
        end;
      end;
			{$IFDEF PANEL_AUTO}
      Sleep(200);
      if Common.TestModelInfo2[m_nPgNo].EnableFlashWriteCBData then begin
        SendSpiFlashAccess(0{disable});
      end;
			{$ENDIF}
      SetPowerMeasurePgTimer(True); //2022-02-16
  //end;
  end
  else begin
    SetPowerMeasurePgTimer(False); //2022-02-16
    {$IFDEF PANEL_AUTO}
    if m_bPowerOn and Common.TestModelInfo2[m_nPgNo].EnableFlashWriteCBData then begin
    {$ENDIF}
      SendSpiFlashAccess(0{disable}); //TBD:MERGE? QSPI?SPI?
      Sleep(100);
    {$IFDEF PANEL_AUTO}
    end;
    {$ENDIF}
  //if (Common.SystemInfo.PgSpiMain = PGSPI_MAIN_PG) then begin //TBD:MERGE? PSSPI_MAIN_PG?
      case Common.SystemInfo.SPI_TYPE of
        SPI_TYPE_DJ023_SPI: begin
          SendSpiSigOnOff(2); // Power Off --- External Off	//TBD:MERGE? DJ023_SPI?
          dwRtn := WAIT_OBJECT_0;
        end;
        else begin  //DJ021|DJ201
          dwRtn := CheckSpiCmdAck(procedure begin SendSpiPowerOnOffReq(nMode);end, DefPG.SIG_DJ021_POWER_OFF_REQ, nWaitMS, nRetry);
        end;
      end;
  //end;
    Sleep(100);
    m_bPowerOn := False;  //A2CHv3:ASSY-POCB:FLOW
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_PATTERN,'', -1);  //2019-01-19 (-1:PowerOff) //TBD:MERGE? POCB(O) FOldFI(X)
    dwRtn := CheckPgCmdAck(procedure begin SendPgPowerReq(nMode);end, SIG_PG_PWR_OFF, 3000{nWaitMS},1{nRetry});
  end;

  Result := dwRtn;
end;

procedure TDongaPG.SendPgPowerReq(nMode: Integer);
var
  TxBuf : TIdBytes;
  wLen  : Word;
begin
  if nMode = 1 then begin
    wLen := 1;
    SetLength(TxBuf, wLen);
    TxBuf[0] := 0; //LCD (0: BL ON, 1: BL OFF)
    SendPgData(DefPG.SIG_PG_PWR_ON, wLen, TxBuf);
    //
    FDisPatStruct.CurrPat.bPowerOn     := True;
  //FDisPatStruct.CurrPat.bPatternOn   := False;
  //FDisPatStruct.CurrPat.nCurrPatNum  := 0;
  //FDisPatStruct.CurrPat.nCurrAllPatIdx := 0;
  //FDisPatStruct.CurrPat.bSimplepaPat := False;
	  //
    {$IFDEF FEATURE_GRAY_CHANGE}
  //FDisPatStruct.CurrPat.bGrayChangeR := False;
  //FDisPatStruct.CurrPat.bGrayChangeG := False;
  //FDisPatStruct.CurrPat.bGrayChangeB := False;
  //FDisPatStruct.CurrPat.nGrayOffset  := 0;
    {$ENDIF}
  end
  else begin
    wLen := 0;
    SetLength(TxBuf, 1);
    SendPgData(DefPG.SIG_PG_PWR_OFF, wLen, TxBuf);
    //
    FDisPatStruct.CurrPat.bPowerOn     := False;
    FDisPatStruct.CurrPat.bPatternOn   := False;
    FDisPatStruct.CurrPat.nCurrPatNum  := 0;
    FDisPatStruct.CurrPat.nCurrAllPatIdx := 0;
    FDisPatStruct.CurrPat.bSimplepaPat := False;
		//
    {$IFDEF FEATURE_GRAY_CHANGE}
    FDisPatStruct.CurrPat.bGrayChangeR := False;
    FDisPatStruct.CurrPat.bGrayChangeG := False;
    FDisPatStruct.CurrPat.bGrayChangeB := False;
    FDisPatStruct.CurrPat.nGrayOffset  := 0;
    {$ENDIF}
  end;
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_SETCOLOR_PALLET (0x14)
//		- procedure TDongaPG.SendPgGrayChange(nGrayOffset: Integer); 
//		- function TDongaPG.SendPgSetColorPallet(nOffsetR,nOffsetG,nOffsetB: Integer): Integer; 
//		- procedure TDongaPG.SendPgSetColorPalletReq(nOffsetR,nOffsetG,nOffsetB: Integer);
//
{$IFDEF FEATURE_GRAY_CHANGE} //FoldFIGRAY_CHANGE)
procedure TDongaPG.SendPgGrayChange(nGrayOffset: Integer); 
begin
  SendPgSetColorPallet(nGrayOffset,nGrayOffset,nGrayOffset);
  //
  FDisPatStruct.CurrPat.nGrayOffset := nGrayOffset;
end;
{$ENDIF}

function TDongaPG.SendPgSetColorPallet(nOffsetR,nOffsetG,nOffsetB: Integer): DWORD;
begin
{$IFDEF PANEL_AUTO}
  Result := CheckPgCmdAck(procedure begin SendPgSetColorPalletReq(nOffsetR,nOffsetG,nOffsetB); end, DefPG.SIG_PG_SETCOLOR_PALLET, 3000, 1); //PG->PC ACK //TBD:MERGE?
{$ELSE}
  SendPgSetColorPalletReq(nOffsetR,nOffsetG,nOffsetB); //No PG->PC ACK //TBD:MERGE?
  Result := WAIT_OBJECT_0;
{$ENDIF}
end;

procedure TDongaPG.SendPgSetColorPalletReq(nOffsetR,nOffsetG,nOffsetB: Integer);
var
  TxBuf  : TIdBytes;
  wLen   : Word;
  wValue : Int16;
begin
  wLen    := 6;
  SetLength(TxBuf, wLen);
  // nSetColorR|nSetColorG|nSetColorB : -255~255 --> PG Protocol: vR|vG|vB(:)-4095~4095)
  wValue  := Int16(nOffsetR*16);
  CopyMemory(@TxBuf[0], @wValue, 2);
  wValue  := Int16(nOffsetG*16);
  CopyMemory(@TxBuf[2], @wValue, 2);
  wValue  := Int16(nOffsetB*16);
  CopyMemory(@TxBuf[4], @wValue, 2);
  SendPgData( DefPG.SIG_PG_SETCOLOR_PALLET, wLen, TxBuf);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_SETCOLOR_RGB (0x61)
//		- function TDongaPG.SendPgSetColorRGB(nR,nG,nB: Integer; nPalletType: Integer=DefPG.SETCOLOR_RGB_PALLET_DEFAULT): DWORD;
//		- procedure TDongaPG.SendPgSetColorRGBReq(nR,nG,nB: Integer; nPalletType: Integer=DefPG.SETCOLOR_RGB_PALLET_DEFAULT);
//
function TDongaPG.SendPgSetColorRGB(nR,nG,nB: Integer; nPalletType: Integer=DefPG.SETCOLOR_RGB_PALLET_DEFAULT): DWORD;
var
  sDebug : string;
begin
  sDebug := Format('Pattern Display RGB (R:%d, G:%d, B:%d)',[nR,nG,nB]);
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
//{$IFDEF PANEL_AUTO}
  Result := CheckPgCmdAck(procedure begin SendPgSetColorRGBReq(nR,nG,nB, nPalletType); end, DefPG.SIG_PG_SETCOLOR_RGB, 3000, 1);
//{$ELSE}
//SendPgSetColorRGBReq(nR,nG,nB, nPalletType);
//Result := WAIT_OBJECT_0;
//{$ENDIF}
end;

procedure TDongaPG.SendPgSetColorRGBReq(nR,nG,nB: Integer; nPalletType: Integer=DefPG.SETCOLOR_RGB_PALLET_DEFAULT);
var
  TxBuf  : TIdBytes;
  wLen   : Word;
  wValue : Int16;
begin
  //
  if (nR < 0) then nR := 0 else if (nR > 255) then nR := 255;
  if (nG < 0) then nG := 0 else if (nG > 255) then nG := 255;
  if (nB < 0) then nB := 0 else if (nB > 255) then nB := 255;
  //
  wLen     := 7;
  SetLength(TxBuf, wLen);
  TxBuf[0] := Byte(nPalletType);  //unsigned char PalletType; (0:default, 1:Pallet1(FG), 2:Pallet2(BG), 3:Pallet3(BG), 4:PositionColor)
  wValue := Int16(TernaryOp(nR>=255, 4095, nR*16)); CopyMemory(@TxBuf[1], @wValue, 2);
  wValue := Int16(TernaryOp(nG>=255, 4095, nG*16)); CopyMemory(@TxBuf[3], @wValue, 2);
  wValue := Int16(TernaryOp(nB>=255, 4095, nB*16)); CopyMemory(@TxBuf[5], @wValue, 2);
  SendPgData( DefPG.SIG_PG_SETCOLOR_RGB, wLen, TxBuf);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_LVDS_BITCHECK //FoldFI(PG_I2C) POCB(N/A)
//		- function TDongaPG.SendPgLVDS: Boolean;
//		- function TDongaPG.SendPgLVDSPowerOn(nMode: Integer): Integer;
//
function TDongaPG.SendPgLVDS: Boolean; //TBD:MERGE? (Boolean? DWORD?)
var
  TxBuf : TIdBytes;
	nRet  : DWord;
begin
  SetLength(TxBuf, 1);
  nRet := CheckPgCmdAck(procedure begin SendPgData(DefPG.SIG_PG_LVDS_BITCHECK, 0, TxBuf); end, DefPG.SIG_PG_LVDS_BITCHECK, 3000{nWaitMS},1{nRetry});
  if (nRet = WAIT_OBJECT_0) and m_bChkLVDS then
     Exit(True);

  Result := False;
end;

function TDongaPG.SendPgLVDSPowerOn(nMode: Integer): DWORD;
begin
  if (nMode = 1) and (Common.TestModelInfo[m_nPgNo].Bit in [1,2]) then begin
    if SendPgLVDS then Exit(WAIT_FAILED);
  end;
  Result := SendPgPowerOn(nMode);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_I2C_MODE
//		- function TDongaPG.SendPgI2CRead(nDevAddr,nRegAddr,nDataCnt: Integer; nWaitMS: Integer=PG_I2CCMD_WAIT_MSEC; nRetry: Integer=0): DWORD;
//		- function TDongaPG.SendPgI2CWrite(nDevAddr,nRegAddr,nDataCnt: Integer; btaData: TIdBytes; nWaitMS: Integer=PG_I2CCMD_WAIT_MSEC; nRetry: Integer=0): DWORD;
//		- procedure TDongaPG.SendPgI2CModeReq(buff: TIdBytes; nDataLen: Integer);
//
function TDongaPG.SendPgI2CRead(nDevAddr,nRegAddr,nDataCnt: Integer; nWaitMS: Integer=PG_I2CCMD_WAIT_MSEC; nRetry: Integer=0): DWORD; //FoldFI(PG_I2C) POCB(N/A)
var
  TxBuf : TIdBytes;
  nLen, wTemp : Word;
begin
	nLen := 10;
	SetLength(TxBuf, nLen);
  TxBuf[0]  := $02;  // Line
  TxBuf[1]  := $40;  // PageCnt
  TxBuf[2]  := $01;  // CommandCnt
  TxBuf[3]  := $00;  // CommandDelay
  TxBuf[4] := Byte(ord('R'));       // Command('R':0x52, 'W':0x57)
  wTemp := nDataCnt;
  CopyMemory(@TxBuf[5], @wTemp, 2); // Read Data Length.
  TxBuf[7] := nDevAddr;             // Device Addr.
  wTemp := nRegAddr;
  CopyMemory(@TxBuf[8], @wTemp, 2); // Register Addr.
  Result := CheckPgCmdAck(procedure begin SendPgI2CModeReq(TxBuf,nLen); end, DefPG.SIG_PG_I2C_MODE, nWaitMS, nRetry);
end;

function TDongaPG.SendPgI2CWrite(nDevAddr,nRegAddr,nDataCnt: Integer; btaData: TIdBytes; nWaitMS: Integer=PG_I2CCMD_WAIT_MSEC; nRetry: Integer=0): DWORD; //FoldFI(PG_I2C) POCB(N/A)
var
  TxBuf : TIdBytes;
  nLen, wTemp, i : Word;
begin
	nLen := 10 + nDataCnt;
	SetLength(TxBuf, nLen);
  TxBuf[0] := $02;  // Line
  TxBuf[1] := $40;  // PageCnt
  TxBuf[2] := $01;  // CommandCnt
  TxBuf[3] := $00;  // CommandDelay
  TxBuf[4] := Byte(ord('W'));       // Command('R':0x52, 'W':0x57)
  wTemp    := nDataCnt;
  CopyMemory(@TxBuf[5], @wTemp, 2); // Read Data Length.
  TxBuf[7] := nDevAddr;             // Device Addr.
  wTemp    := nRegAddr;
  CopyMemory(@TxBuf[8], @wTemp, 2); // Register Addr.
  for i := 0 to Pred(nDataCnt) do
    TxBuf[i+10] := Byte(btaData[i]) and $FF;
  Result := CheckPgCmdAck(procedure begin SendPgI2CModeReq(TxBuf,nLen); end, DefPG.SIG_PG_I2C_MODE, nWaitMS, nRetry);
end;

procedure TDongaPG.SendPgI2CModeReq(buff: TIdBytes; nDataLen: Integer); //FoldFI(PG_I2C) POCB(N/A)
var
  TxBuf : TIdBytes;
  wLen, wCrc16 : Word;
begin
  wLen := 2{CRC16} + nDataLen;
  SetLength(TxBuf, wLen); //
  wCrc16 := GetPgCrc16(buff,nDataLen);
  CopyMemory(@TxBuf[0], @wCrc16, 2);
  CopyMemory(@TxBuf[2], @buff[0], nDataLen);
  SendPgData(DefPG.SIG_PG_I2C_MODE, wLen, TxBuf);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_CHANNEL_SET
//		-

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_WP_ONOFF
//		-

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_SET_DIMMING
//		- function TDongaPG.SendPgDimming(nDimming: Integer): Integer;
//		- procedure TDongaPG.SendPgDimmingReq(nDimming: Integer);
//
function TDongaPG.SendPgDimming(nDimming: Integer): DWORD; //Fold(PG_DIMMING)
var
  nDimmingStep : Integer;
begin
  CheckPgCmdAck(procedure begin SendPgDimmingReq(nDimming);end, DefPG.SIG_PG_SET_DIMMING, 3000{nWaitMS},1{nRetry});
  Result := WAIT_OBJECT_0;
end;

procedure TDongaPG.SendPgDimmingReq(nDimming: Integer); //Fold(PG_DIMMING)
const
  NBPC_VBR = 0;
var
  btBuf : TIdBytes;
  nLen  : Integer;
  VBR   : Integer;
begin
  nLen := 3;
  SetLength(btBuf,nLen);
  VBR := Common.TestModelInfo[m_nPgNo].PWR_VOL[DefPG.PWR_VBR] div 100;  //2020-10-06 ModelInfo(1=1mV), MSG.VBR(1=100mV) //TBD:MERGE? //TBD:100? 1000?
  btBuf[0]  := Byte(VBR);       // VBR 3.3V   // VBR 1 byte
  btBuf[1]  := Byte(nDimming);  // Duty 1 byte
  btBuf[2]  := Byte(NBPC_VBR);  // None
  SendPgData(DefPG.SIG_PG_SET_DIMMING, nLen, btBuf);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_PWR_OFFSET_WRITE
//		- function TDongaPG.SendPgPowerOffsetWrite: DWORD;
//		- procedure TDongaPG.SendPgPowerOffsetWriteReq;
// PG(DP489|DP200|DP201) SIG_PG_PWR_OFFSET_READ
//		- function TDongaPG.SendPgPowerOffsetRead: DWORD;
//		- procedure TDongaPG.SendPgPowerOffsetReadReq;
//
function TDongaPG.SendPgPowerOffsetWrite: DWORD;
begin
  Result := CheckPgCmdAck(procedure begin SendPgPowerOffsetWriteReq; end, DefPG.SIG_PG_PWR_OFFSET_WRITE, 3000{nWaitMS},0{nRetry});
end;

procedure TDongaPG.SendPgPowerOffsetWriteReq;  //2019-01-09 POWER_CAL //TBD:MERGE? FoldFI(X) POCB(O)
var
  TxBuf : TIdBytes;
  wLen  : Word;
begin
  wLen := 8;  // Sizeof(TPowerOffset)
  SetLength(TxBuf, 8);
  CopyMemory(@TxBuf[0], @m_PwrOffsetWritePg, wLen);
  SendPgData(DefPG.SIG_PG_PWR_OFFSET_WRITE,wLen,TxBuf);
end;

function TDongaPG.SendPgPowerOffsetRead: DWORD;
begin
  Result := CheckPgCmdAck(procedure begin SendPgPowerOffsetReadReq;end, DefPG.SIG_PG_PWR_OFFSET_READ, 3000{nWaitMS},0{nRetry});
end;

procedure TDongaPG.SendPgPowerOffsetReadReq;  //2019-01-09 POWER_CAL //TBD:MERGE? FoldFI(X) POCB(O)
var
  TxBuf : TIdBytes;
begin
  SetLength(TxBuf, 1);
  SendPgData(DefPG.SIG_PG_PWR_OFFSET_READ, 0, TxBuf);
end;

{$IFDEF INSPECOTR_FI}
function TDongaPG.SendPgPowerOffset(buff: TIdBytes): DWORD; //TBD:MERGE? FoldFI(O) POCB(X)
begin
  Result := CheckPgCmdAck(procedure begin SendPgPowerOffsetReq(buff); end, SIG_PG_PWR_OFFSET_WRITE, 3000, 1);
end;

procedure TDongaPG.SendPgPowerOffsetReq(buff: TIdBytes); //TBD:MERGE? FoldFI(O) POCB(X)
var
  wLen  : Word;
begin
  wLen := 8;
  SendPgData(DefPG.SIG_PG_PWR_OFFSET_WRITE, wLen, buff);
end;
{$ENDIF}

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_DIMMING_MODE
//		-

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_FAILSAFE_MODE
//		-

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_DISPLAY_ONOFF
//		- function TDongaPG.SendPgDisplayOnOff(bOn: Boolean): DWORD; 
//		- procedure TDongaPG.SendPgDisplayOnOffReq(bOn: Boolean);
//
function TDongaPG.SendPgDisplayOnOff(bOn: Boolean): DWORD; //A2CHv3:ASSY-POCB:FLOW
var
  dwRtn : integer;
begin
  CheckPgCmdAck(procedure begin SendPgDisplayOnOffReq(bOn);end, DefPG.SIG_PG_DISPLAY_ONOFF, 2000{nWaitMS},1{nRetry});
  Result := WAIT_OBJECT_0;
  //
  {$IFDEF INSPECTOR_POCB}
  if bOn then SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_PATTERN,'', -3{On})
  else        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_PATTERN,'', -2{Off}); // -1: PowerOff, -2: Display Off, -3: Display On  //TBD:MERGE?
  {$ENDIF}
end;

procedure TDongaPG.SendPgDisplayOnOffReq(bOn: Boolean);  //A2CHv3:ASSY-POCB:FLOW
var
  btBuf : TIdBytes;
  wCnt  : Word;
begin
  try
    SetLength(btBuf,1);
    if bOn then btBuf[0]:= 1 else btBuf[0]:= 0;
    wCnt := 1;
    SendPgData(DefPG.SIG_PG_DISPLAY_ONOFF, wCnt, btBuf);
  except
  end;
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_CURSOR_ONOFF?
//		-

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_SETCOLOR_PALLET?
//		-

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_MEASURE_MODE?
//		-

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_POWERCAL_MODE
//		- function TDongaPG.SendPgPowerCalMode(sCalCmd: string): DWORD;
//		- procedure TDongaPG.SendPgPowerCalModeReq(sCalCmd: string);
//
function TDongaPG.SendPgPowerCalMode(sCalCmd: string): DWORD; //TBD:MERGE? POCB(O) FoldFI(X) #SendPowerCalibration
begin
  Result := CheckPgCmdAck(procedure begin SendPgPowerCalModeReq(sCalCmd);end, DefPG.SIG_PG_POWERCAL_MODE,3000,1);
end;

procedure TDongaPG.SendPgPowerCalModeReq(sCalCmd: string);  ///TBD:MERGE? POCB(O) FoldFI(X) #SendPowerCalibrationReq
var
  TxBuf : TIdBytes;
  wLen : Word;
  sAnsiCalCmd : AnsiString;
  i : Integer;
begin
  wLen := Length(sCalCmd);
  sAnsiCalCmd := AnsiString(sCalCmd);
  SetLength(TxBuf, wLen);  // sig ID + total Length + total data
  for i := 0 to Pred(wlen) do
    TxBuf[i] := Byte(sAnsiCalCmd[i+1]);
  SendPgData(DefPG.SIG_PG_POWERCAL_MODE, wLen, TxBuf);
end;

{ //TBD|MERGE?
function TDongaPG.SendPgPowerCalMode(nMode: Integer): DWORD; //TBD:MERGE? FoldFI(SendPgCalData) POCB(X)
var
  dwRtn : DWORD;
  nLen : Integer;
  btBuff : TIdBytes;
begin
  SetLength(btbuff, 10);
  nLen := 0;
  case nMode of
    DefPG.CALIBRATION_START : begin
      btBuff[nLen] := Ord('c'); Inc(nLen);
      btBuff[nLen] := Ord('a'); Inc(nLen);
      btBuff[nLen] := Ord('l'); Inc(nLen);
      btBuff[nLen] := Ord('s'); Inc(nLen);
    end;
    DefPg.CALIBRATION_UP : begin
      btBuff[nLen] := Ord('+'); Inc(nLen);
    end;
    DefPg.CALIBRATION_DOWN : begin
      btBuff[nLen] := Ord('-'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_1CH_VCC33 : begin
      btBuff[nLen] := Ord('v'); Inc(nLen);
      btBuff[nLen] := Ord('c'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('0'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_1CH_VCC50 : begin
      btBuff[nLen] := Ord('v'); Inc(nLen);
      btBuff[nLen] := Ord('c'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('1'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_1CH_VCC120 : begin
      btBuff[nLen] := Ord('v'); Inc(nLen);
      btBuff[nLen] := Ord('c'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('2'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_2CH_VCC33 : begin
      btBuff[nLen] := Ord('v'); Inc(nLen);
      btBuff[nLen] := Ord('d'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('0'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_2CH_VCC50 : begin
      btBuff[nLen] := Ord('v'); Inc(nLen);
      btBuff[nLen] := Ord('d'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('1'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_2CH_VCC120 : begin
      btBuff[nLen] := Ord('v'); Inc(nLen);
      btBuff[nLen] := Ord('d'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('2'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_VEL150 : begin
      btBuff[nLen] := Ord('v'); Inc(nLen);
      btBuff[nLen] := Ord('b'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('0'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_VEL240 : begin
      btBuff[nLen] := Ord('v'); Inc(nLen);
      btBuff[nLen] := Ord('b'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('1'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_1CH_ICC200 : begin
      btBuff[nLen] := Ord('i'); Inc(nLen);
      btBuff[nLen] := Ord('c'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('0'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_1CH_ICC2000 : begin
      btBuff[nLen] := Ord('i'); Inc(nLen);
      btBuff[nLen] := Ord('c'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('1'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_2CH_ICC200 : begin
      btBuff[nLen] := Ord('i'); Inc(nLen);
      btBuff[nLen] := Ord('d'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('0'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_2CH_ICC2000 : begin
      btBuff[nLen] := Ord('i'); Inc(nLen);
      btBuff[nLen] := Ord('d'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('1'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_IEL200 : begin
      btBuff[nLen] := Ord('i'); Inc(nLen);
      btBuff[nLen] := Ord('b'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('0'); Inc(nLen);
    end;
    DefPg.CALIBRATION_SET_IEL2000 : begin
      btBuff[nLen] := Ord('i'); Inc(nLen);
      btBuff[nLen] := Ord('b'); Inc(nLen);
      btBuff[nLen] := Ord('r'); Inc(nLen);
      btBuff[nLen] := Ord('1'); Inc(nLen);
    end;
    DefPg.CALIBRATION_END : begin
      btBuff[nLen] := Ord('c'); Inc(nLen);
      btBuff[nLen] := Ord('a'); Inc(nLen);
      btBuff[nLen] := Ord('l'); Inc(nLen);
      btBuff[nLen] := Ord('e'); Inc(nLen);
    end;
  end;
  dwRtn := CheckPgCmdAck(procedure begin SendPgPowerCalModeReq(btBuff, nLen); end, SIG_PG_POWERCAL_MODE, 3000, 1);
end;

procedure TDongaPG.SendPgPowerCalModeReq(btBuff: TIdBytes; nLen: Integer); //TBD:MERGE? FoldFI(SendPgCalDataReq) POCB(X)
begin
  SendPgData(DefPG.SIG_PG_POWERCAL_MODE, nLen, btBuff);
end;
} //TBD:MERGE?

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_PWR_AUTOCAL_MODE
//		- procedure TDongaPG.SendPgPowerAutoCalMode;
// PG(DP489|DP200|DP201) SIG_PG_PWR_AUTOCAL_DATA
//		- procedure TDongaPG.SendPgPowerAutoCalData;
//
procedure TDongaPG.SendPgPowerAutoCalMode; //#SendPgPowerCalAuto
var
  TxBuf : TIdBytes;
begin
  SetCyclicTimerPg(False{bEnable},300); //300 sec
  //
	SetLength(TxBuf,1);
  SendPgData(DefPG.SIG_PG_PWR_AUTOCAL_MODE, 0, TxBuf);
end;

procedure TDongaPG.SendPgPowerAutoCalData; //#SendPgPowerCalData
var
  TxBuf : TIdBytes;
begin
  SetCyclicTimerPg(False{bEnable},300); //300 sec
  //
	SetLength(TxBuf,1);
  SendPgData(DefPG.SIG_PG_PWR_AUTOCAL_DATA, 0, TxBuf);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_FIRST_CONNREQ
//		- procedure TDongaPG.SendPgFirstConnAck;
//
procedure TDongaPG.SendPgFirstConnAck;
var
	TxBuf : TIdBytes;
  nLen  : Integer;
begin
  nLen := 1;
	SetLength(TxBuf, nLen);
  TxBuf[0] := DefPG.SIG_PG_FIRST_CONNREQ;
  SendPgData(DefPG.CMD_PG_RESULT_ACK, nLen, TxBuf);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_CONN_CHECK
//		- procedure TDongaPG.SendPgConnCheckReq;
//
procedure TDongaPG.SendPgConnCheckReq;
var
	TxBuf : TIdBytes;
	Sig_Id, nLen : Word;
begin
	SetLength(TxBuf, 4);
	nLen := 0;
	Sig_Id := DefPG.SIG_PG_CONN_CHECK;
	CopyMemory(@TxBuf[0], @Sig_Id, 2); //TBD:MERGE?
	CopyMemory(@TxBuf[2], @nLen, 2);
  SendPgData(DefPG.SIG_PG_CONN_CHECK,0,TxBuf);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_RESET
//		- function TDongaPG.SendPgReset: DWORD;
//		- procedure TDongaPG.SendPgResetReq;
//
function TDongaPG.SendPgReset: DWORD;
begin
  Result := CheckPgCmdAck(procedure begin SendPgResetReq; end, DefPG.SIG_PG_RESET, 5000{nWaitMS},0{nRetry});
end;

procedure TDongaPG.SendPgResetReq;
var
  TxBuf : TIdBytes;
begin
	SetLength(TxBuf,1);
  SendPgData(DefPG.SIG_PG_RESET, 0, TxBuf);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_BMP_DOWNLOAD
//
//    - function TDongaPG.PgDownBmpFile(const transData: TFileTranStr; bSelfTestForceNG: Boolean = False): Boolean; //#SendPgBuffData #SendBuffData
//    - procedure TDongaPG.PgDownBmpFiles(nFileCnt: Integer; const arTransData: TArray<TFileTranStr>); //called by DownloadBmpPg //#SendTransData #SendPgTransData
//    - function TDongaPG.SendPgBmpDownStartEnd(bStart: Boolean; nIndex: Integer; transData: TFileTranStr; nWaitMS: Integer = 3000; nRetry: integer = 0): DWORD;
//    - procedure TDongaPG.SendPgRawDataPkt(btTxBuf: TIdBytes); //#SendTransDataRaw #SendPgTransDataRaw
//    - procedure TDongaPG.SendPgDownEscapeSequence;
//
function TDongaPG.PgDownBmpFile(const transData: TFileTranStr; bSelfTestForceNG: Boolean = False): Boolean; //#SendPgBuffData //#SendBuffData
var
  dwRtn : DWORD;
  TxBuf : TIdBytes; 
  nFileSize, nDiv, nMod, j : Integer;
  sFileName  : AnsiString;
  sTemp : String;
begin
  try
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    SetCyclicTimerPg(False{bEnable});
    //
    Self.StatusPg := pgWait;
    sFileName := AnsiString(ChangeFileExt(Trim(transData.fileName),''));
    nFileSize := transData.TotalSize;

    // Send BMP_DOWN Start Message
    dwRtn := SendPgBmpDownStartEnd(True{bStart},0{nIndex},transData,Common.SystemInfo.PgBmpDownStartWaitSec*1000);
    if dwRtn <> WAIT_OBJECT_0 then begin
      sTemp := 'BMP Download Start';
		  case dwRtn of
		    WAIT_FAILED   : sTemp := sTemp + 'NG(NAK)';
		    WAIT_TIMEOUT  : sTemp := sTemp + 'NG(TIME OUT)'
		    else            sTemp := sTemp + 'NG(ELSE)';
		  end;		
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sTemp, DefPocb.LOG_TYPE_NG);
      Exit(False);
    end;
    Sleep(100);

    // Send BMP_DOWN Data Packets
    SetLength(TxBuf,DefPG.PGSPI_PACKET_SIZE);
    nDiv := nFileSize div DefPG.PGSPI_PACKET_SIZE;
    nMod := nFileSize mod DefPG.PGSPI_PACKET_SIZE;
    for j := 1 to nDiv do begin
      if Common.Systeminfo.DebugSelfTestPg and bSelfTestForceNG then begin //2021-07-08
        if j = nDiv then Continue;
      end;
      CopyMemory(@TxBuf[0],@transData.Data[(j-1)*DefPG.PGSPI_PACKET_SIZE],DefPG.PGSPI_PACKET_SIZE);
      SendPgRawDataPkt(TxBuf);
      Sleep(Common.SystemInfo.PgBmpDownFlowInterDataMsec);  //2021-06-25 (1 -> 2) //2021-12-17 (-> SystemInfo.PgBmpDOwnInterDataMsec, default:3msec)
      if Self.StatusPg = pgForceStop then Exit(False);
    end;
    if nMod > 0 then begin
      SetLength(TxBuf,nMod);
      CopyMemory(@TxBuf[0],@transData.Data[nDiv*DefPG.PGSPI_PACKET_SIZE],nMod);
      SendPgRawDataPkt(TxBuf);
      if Self.StatusPg = pgForceStop then Exit(False);
    end;
    Sleep(100);

    // Send BMP_DOWN End Message
    dwRtn := SendPgBmpDownStartEnd(False{bStart},0{nIndex},transData,Common.SystemInfo.PgBmpDownEndWaitSec*1000);
    if dwRtn <> WAIT_OBJECT_0 then begin
      sTemp := 'BMP Download End';
		  case dwRtn of
		    WAIT_FAILED   : sTemp := sTemp + 'NG(NAK)';
		    WAIT_TIMEOUT  : sTemp := sTemp + 'NG(TIME OUT)'
		    else            sTemp := sTemp + 'NG(ELSE)';
		  end;				
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sTemp, DefPocb.LOG_TYPE_NG);
      //
      SendPgDownEscapeSequence; //2021-07-08
      Exit(False);
    end;

    //
    sTemp := Format('BMP Download OK (%s)',[sFileName]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sTemp);

  finally
    //---------------------------------- Enable Cyclic Timers (AliveCheck, PowerMeasure)
    SetCyclicTimerPg(True{bEnable});
    Self.StatusPg := pgDone;
  end;

  Result := True;
end;

procedure TDongaPG.PgDownBmpFiles(nFileCnt: Integer; const arTransData: TArray<TFileTranStr>); //called by DownloadBmpPg //#SendTransData #SendPgTransData
var
  TxBuf : TIdBytes;
  dwRtn : DWORD;
  sTemp : string;
  sFileName : AnsiString;
  idxFile, nFileSize ,j : Integer;
  nDiv, nMod : Integer;
  nTotalPktCnt, nCurPktCnt : integer;
  nPercentagePre, nPerCentageNow : Integer;
begin
 	if (nFileCnt <= 0) then exit;

	try
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    SetCyclicTimerPg(False{bEnable});
  	Self.StatusPg := pgWait;

		// Get Totol Packet Count to download BMP Files
  	nTotalPktCnt := 0;
  	for idxFile := 0 to Pred(nFileCnt) do begin
   	 nTotalPktCnt := nTotalPktCnt + 2; // Start + End.
   	 nFileSize := arTransData[idxFile].TotalSize;
   	 nDiv := nFileSize div DefPG.PGSPI_PACKET_SIZE;
   	 nMod := nFileSize mod DefPG.PGSPI_PACKET_SIZE;
   	 nTotalPktCnt := nTotalPktCnt + nDiv;
   	 if nMod > 0 then nTotalPktCnt := nTotalPktCnt + 1;
  	end;

  	nCurPktCnt := 0;
  	for idxFile := 0 to Pred(nFileCnt) do begin
		  //
      if Self.StatusPg = pgForceStop then Exit;
   		sFileName := AnsiString(ChangeFileExt(Trim(arTransData[idxFile].fileName),''));
      nFileSize := arTransData[idxFile].TotalSize;

   		// Send BMP_DOWN Start Message
			Inc(nCurPktCnt);
   	  sTemp := Format('Start ...%s',[sfileName]);
   	  ShowPgBmpDownStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS,nCurPktCnt,nTotalPktCnt,sTemp);
   	  dwRtn := SendPgBmpDownStartEnd(True{bStart},idxFile{nIndex},arTransData[idxFile],Common.SystemInfo.PgBmpDownStartWaitSec*1000);
   	  if dwRtn <> WAIT_OBJECT_0 then begin
   	    sTemp := Format('Start Fail(%d)',[dwRtn]);
   	    ShowPgBmpDownStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS,nCurPktCnt,nTotalPktCnt,sTemp,True);
   	    Break;
   	  end;
   	  Sleep(100);

      // Send BMP_DOWN Data Packets
  	  SetLength(TxBuf,DefPG.PGSPI_PACKET_SIZE);
      nDiv := nFileSize div DefPG.PGSPI_PACKET_SIZE;
      nMod := nFileSize mod DefPG.PGSPI_PACKET_SIZE;
      for j := 1 to nDiv do begin
      //if Common.Systeminfo.DebugSelfTestPg and bSelfTestForceNG and (j = nDiv) then Continue;
        CopyMemory(@TxBuf[0],@arTransData[idxFile].Data[(j-1)*DefPG.PGSPI_PACKET_SIZE],DefPG.PGSPI_PACKET_SIZE);
        SendPgRawDataPkt(TxBuf);
        Sleep(Common.SystemInfo.PgBmpDownSetupInterDataMsec);  //2021-06-25 (1 -> 2) //2021-11-11 (2->3) //2021-12-17 (-> SystemInfo.PgBmpDOwnInterDataMsec, default:3msec)
        //
        Inc(nCurPktCnt);
        nPercentageNow := Round((j*100) / nDiv);
        if (nPerCentagePre < nPercentageNow) or (j = nDiv) then begin
          sTemp := Format('%d/%d KB...(%d/%d)',[j,nFileSize div DefPG.PGSPI_PACKET_SIZE,idxFile+1,nFileCnt]);
          ShowPgBmpDownStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS,nCurPktCnt,nTotalPktCnt,sTemp);
        end;
        nPerCentagePre := nPercentageNow;
        //
        if Self.StatusPg = pgForceStop then Exit;
      end;
      if nMod > 0 then begin
        SetLength(TxBuf,nMod);
        CopyMemory(@TxBuf[0],@arTransData[idxFile].Data[nDiv*DefPG.PGSPI_PACKET_SIZE],nMod);
        SendPgRawDataPkt(TxBuf);
        //
        Inc(nCurPktCnt);
        sTemp := Format('%d/%d Bytes...(%d/%d)',[nFileSize,nFileSize, idxFile+1,nFileCnt]);
        ShowPgBmpDownStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS,nCurPktCnt,nTotalPktCnt,sTemp);
        //
        if Self.StatusPg = pgForceStop then Exit;
      end;
      Sleep(100);

      // Send BMP_DOWN End Message
			Inc(nCurPktCnt);
   	  sTemp := Format('End ...%s',[sfileName]);
   	  ShowPgBmpDownStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS,nCurPktCnt,nTotalPktCnt,sTemp);
      dwRtn := SendPgBmpDownStartEnd(False{bStart},idxFile{nIndex},arTransData[idxFile],Common.SystemInfo.PgBmpDownEndWaitSec*1000);
      if dwRtn <> WAIT_OBJECT_0 then begin
        sTemp := Format('End Fail(%d)',[dwRtn]);
   	    ShowPgBmpDownStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS,nCurPktCnt,nTotalPktCnt,sTemp);
        //
        SendPgDownEscapeSequence; //2021-12-16
        Break;
   	  end;
      //
   	  if Self.StatusPg = pgForceStop then Break;
   	  Sleep(100);
  	end;

  	// PG Reset after all BMP download
  	ShowPgBmpDownStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS,nCurPktCnt,nTotalPktCnt,'Reset PG');
  	Sleep(500);
  	dwRtn := SendPgReset;
  	if dwRtn = WAIT_OBJECT_0 then sTemp := 'Reset OK' else sTemp := 'Reset Fail !!!';
  	ShowPgBmpDownStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS,nCurPktCnt,nTotalPktCnt,sTemp,True);

  finally
    //---------------------------------- Enable Cyclic Timers (AliveCheck, PowerMeasure)
    SetCyclicTimerPg(True{bEnable});
  	Self.StatusPg := pgDone;
  end;
end;

function TDongaPG.SendPgBmpDownStartEnd(bStart: Boolean; nIndex: Integer; transData: TFileTranStr; nWaitMS: Integer=3000; nRetry: integer=0): DWORD;
var
  TxBuf : TIdBytes;
  sFileName : AnsiString;
  nFileSize, nCheckSum : LongWord;
  nTransType, nFileNameLen : Integer;
begin
  sFileName  := AnsiString(ChangeFileExt(Trim(transData.fileName),''));
  nFileSize  := transData.TotalSize;
  nTransType := transData.TransType;
  nCheckSum  := transData.CheckSum;
	//
  nFileNameLen := Length(Trim(sFileName));
  case Common.SystemInfo.PG_TYPE of
    DefPG.PG_TYPE_DP489: begin if nFileNameLen > 31 then nFileNameLen := 31; end;
    else                 begin if nFileNameLen > 29 then nFileNameLen := 29; end;
	end;

  // Make BMP_DOWN Start/End Message
  SetLength(TxBuf,40);
  ClearDataBuf(TxBuf,40);
  TxBuf[0] := Byte(nTransType);                       // [0] TYPE
  if bStart then TxBuf[1] := Byte('S')                // [1] MODE
  else           TxBuf[1] := Byte('E');
  CopyMemory(@TxBuf[2], @nIndex, 2);                  // [2..3] INDEX
  TxBuf[4] := Byte(nFileNameLen);                     // [4..35] FILENAME: [4] - Length
  CopyMemory(@TxBuf[5],@sfileName[1],nFileNameLen);   //                   [5..5+nFileNameLen] FileName
  if (Common.SystemInfo.PG_TYPE <> DefPG.PG_TYPE_DP489) then begin
    TxBuf[34] := transData.BmpWidth and $FF;          //                   [34] Width(LSB) if DP200|DP201
    TxBuf[35] := (transData.BmpWidth shr 8) and $FF;  //                   [35] Width(MSB) if DP200|DP201
  end;
  if bStart then CopyMemory(@TxBuf[36],@nFileSize,4)  // [36..39] FILESIZE
  else           CopyMemory(@TxBuf[36],@nChecksum,4); // [36..39] CHECKSUM

  //
  Result := CheckPgCmdAck(procedure begin SendPgData(DefPG.SIG_PG_BMP_DOWNLOAD,40{wLen},TxBuf); end, SIG_PG_BMP_DOWNLOAD, nWaitMS,nRetry);
end;

procedure TDongaPG.SendPgRawDataPkt(btTxBuf: TIdBytes); //#SendTransDataRaw #SendPgTransDataRaw
begin
	try
    if (m_ABindingPg <> nil) then begin
      {$IFDEF SIMULATOR_PG}
   		m_ABindingPg.SendTo(m_sPgIP, m_nRemotePortPg, btTxbuf);
      {$ELSE}
   		m_ABindingPg.SendTo(m_sPgIP, DefPG.PGSPI_DEFAULT_PORT, btTxbuf);
      {$ENDIF}
      // debug log
      if (Common.m_nDebugLogLevelActive[DEBUG_LOG_DEVTYPE_PG] >= DEBUG_LOG_MSGTYPE_DOWNDATA) then
        Common.DebugLog(m_nPgNo, DEBUG_LOG_DEVTYPE_PG, DEBUG_LOG_MSGTYPE_DOWNDATA, 'TX', m_sPgIP, btTxbuf);
    end
    else begin
      //Common.MLog(m_nPgNo,'<PG/SPI> CH'+IntToStr(m_nPgNo+1)+': SendTransDataRaw ...Err(No Binding)');
    end;
  except

  end;
end;

procedure TDongaPG.SendPgDownEscapeSequence;
var
  TxBuff : TIdBytes;
  sTemp  : string;
  i : Integer;
begin
  sTemp := 'Send Download Escape Sequence to PG';
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sTemp);
  SetLength(TxBuff,1);
  for i := 1 to 10 do begin
    TxBuff[0] := Byte(i);
    SendPgRawDataPkt(TxBuff);
    Sleep(5);
  end;
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_FW_VER_REQ
//		- procedure TDongaPG.SendPgFwVer;
//		- procedure TDongaPG.SendPgFwVerReq;
//
procedure TDongaPG.SendPgFwVer; //TBD:MERGE?
var
  dwRtn : DWORD;
begin
//Self.StatusPg := pgWait; //TBD:MERGE?
  m_bFwVerReqPg := True;
  dwRtn := CheckPgCmdAck(procedure begin SendPgFwVerReq; end, DefPG.SIG_PG_FW_VER_REQ, 1000{nWaitMS},0{nRetry}); // No Retry!!!
  m_bFwVerReqPg := False; 
//StatusPg := pgDone; //TBD:MERGE?
end;

procedure TDongaPG.SendPgFwVerReq;
var
  TxBuf : TIdBytes;
  nLen  : Word;
begin
  nLen := 0;
  SetLength(TxBuf, 4);
  SendPgData(DefPG.SIG_PG_FW_VER_REQ, nLen, TxBuf);
end;

//------------------------------------------------------------------------------
// PG(DP489|DP200|DP201) SIG_PG_FW_ALL_FUSING
// PG(DP489|DP200|DP201) SIG_PG_FW_DOWNLOAD
//    - function TDongaPG.SendPgFwDownStartEnd(wLen: Word; TxBuf: TIdBytes; nWaitMS: Integer=3000; nRetry: integer=0): DWORD;
//
function TDongaPG.SendPgFwDownStartEnd(wLen: Word; TxBuf: TIdBytes; nWaitMS: Integer=3000; nRetry: integer=0): DWORD;
begin
  Result := CheckPgCmdAck(procedure begin SendPgData(DefPG.SIG_PG_FW_DOWNLOAD,wLen,TxBuf); end, DefPG.SIG_PG_FW_DOWNLOAD, nWaitMS,nRetry);
end;

//##############################################################################
//##############################################################################
//###                                                                        ###
//###                         SPI(DJ021|DJ201|DJ023)		                     ###
//###                                                                        ###
//##############################################################################
//##############################################################################

//==============================================================================
// procedure/function: Property
//

//==============================================================================
// procedure/function: Timer
//    - procedure TDongaPG.AliveCheckSpiTimer(Sender: TObject);
//    - procedure TDongaPG.SetCyclicTimerSpi(bEnable: Boolean; nDisableSec: Integer=0);
//    - procedure TDongaPG.SetPowerMeasureSpiTimer(bEnable: Boolean; nInterMS: Integer=0);
//    - procedure TDongaPG.PowerMeasureSpiTimer(Sender: TObject);
//
procedure TDongaPG.AliveCheckSpiTimer(Sender: TObject);
begin
	try
    // Check conditions if ALiveCheck should not be sent
    if (not m_bCyclicTimerSpi) then Exit;
    if m_bWaitEventSpi then Exit;
    if m_bPowerMeasureSpi and tmPowerMeasureSpi.Enabled then Exit;

    //
    if m_nConnCheckSpi > 2 then begin //2022-10-17 (6->2)
      m_nConnCheckSpi := 0;
      StatusSpi := pgDisconnect;
      //
      m_sFwVerSpi    := '';
      m_sBootVerSpi  := '';
      m_wModelCrcSpi := 0;
      m_bFwVerReqSpi := False;
    //!!! m_ABindingSpi  := nil;
      //
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,'Disconnected', 12{dispSpiDisconn});
    end
    else begin
      SendSpiConnCheckReq;
      Inc(m_nConnCheckSpi);
    end;
	except
		OutputDebugString(PChar('>> AliveCheckSpiTimer Exception Error!!'));
	end;
end;

procedure TDongaPG.SetCyclicTimerSpi(bEnable: Boolean; nDisableSec: Integer=0);
begin
  if m_bCyclicTimerSpi = bEnable then Exit; // Already Enabled/Disabled
  //
  m_nConnCheckSpi := 0;
  m_bCyclicTimerSpi := bEnable;
  tmAliveCheckSpi.Enabled := bEnable;
  if m_bPowerMeasureSpi then tmPowerMeasureSpi.Enabled := bEnable;
  //
  if (not bEnable) and (nDisableSec > 0) then begin  // Disable(Duaration!=0)
    TThread.CreateAnonymousThread(procedure var nCnt: Integer;
    begin
      for nCnt := 1 to nDisableSec do begin
        if m_bCyclicTimerSpi then Exit;
        Sleep(1000);
      end;
      // Enable after nDurationSec expired
      m_bCyclicTimerSpi := True;
      tmAliveCheckSpi.Enabled := True;
      if m_bPowerMeasureSpi then tmPowerMeasureSpi.Enabled := True;
    end).Start;
  end;
end;

procedure TDongaPG.SetPowerMeasureSpiTimer(bEnable: Boolean; nInterMS: Integer=0);
begin
  if DefPocb.PGSPI_MAIN_TYPE <> DefPocb.PGSPI_MAIN_QSPI then exit;
	//
  if bEnable then begin
  	if nInterMS <= 0 then nInterMS := 2000; //TBD:MERGE?
    tmPowerMeasureSpi.Interval := nInterMS;
  end;
  tmPowerMeasureSpi.Enabled := bEnable;
  m_bPowerMeasureSpi          := bEnable;
end;

procedure TDongaPG.PowerMeasureSpiTimer(Sender: TObject);
begin
  SendSpiPowerMeasureReq;
end;

//==============================================================================
// procedure/function: SPI/QSPI TX/RX Common
//    - function TDongaPG.LoadIpSpi(ABinding: TIdSocketHandle): Boolean;
//		- function TDongaPG.CheckSpiCmdAck(Task: TProc; nSigId: Integer; nWaitMS: Integer; nRetry: Integer{= 0}): DWORD;
//		- procedure TDongaPG.ReadSpiData(wSigId, wLen: Word; const btData: array of Byte);
//		- procedure TDongaPG.SendSpiData(wSigId, wLen: Word; TxBuf: TIdBytes; bIsData: Boolean=False); 
//
//		- function TDongaPG.CheckSpiPwrCmdAck(Task: TProc; nSid, nDelay, nRetry: Integer): DWORD;
//		- function TDongaPG.GetQspiAlarmStr(alarm_no: Integer; nCurVal : Integer = -1): String;
//

//------------------------------------------------------------------------------
function TDongaPG.LoadIpSpi(ABinding: TIdSocketHandle): Boolean; //DJ021|DJ201|DJ023
var
  i      : Integer;
  sSpiIP : string;
begin
  SetCyclicTimerSpi(False{bEnable});

  sSpiIP := '';
  for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin //TBD:MERGE? FoldFI(O) POCB(X)
    if m_nPgNo = i then begin
      sSpiIP := Common.SystemInfo.IPAddr_SPI[i];
      Break;
    end;
  end;

  Result := False;
  if (sSpiIP = '') or (ABinding.PeerIP = '') or (sSpiIP <> ABinding.PeerIP) then begin //TBD:MERGE? FoldFI(O) POCB(X)
    Exit;
  end;

  m_ABindingSpi := ABinding;
  m_sSpiIP := ABinding.PeerIP;
  {$IFDEF SIMULATOR_SPI}
  m_nRemotePortSpi := m_ABindingSpi.PeerPort;
  {$ELSE}
  m_nRemotePortSpi := DefPG.PGSPI_DEFAULT_PORT;
  {$ENDIF}

  if StatusSpi = pgDisconnect then StatusSpi := pgConnect;
  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,'', 10); //TBD:MERGE? FoldFI(X) POCB(O)

  m_sFwVerSpi    := '';
  m_sBootVerSpi  := '';
  m_wModelCrcSpi := 0;
  m_bFwVerReqSpi := False;

  if (Common.SystemInfo.SPI_TYPE <> SPI_TYPE_DJ023_SPI) then SendSpiConnCheckReq; //TBD:DJ023?
//Sleep(100);
	//
  SetCyclicTimerSpi(True{bEnable});
  Result := True;
end;

//------------------------------------------------------------------------------
function TDongaPG.CheckSpiCmdAck(Task: TProc; nSigId: Integer; nWaitMS: Integer; nRetry: Integer{= 0}): DWORD; //TBD:MERGE? nRetry
var
	dwRtn  : DWORD;
	i      : Integer;
begin
  dwRtn := WAIT_FAILED;
	try
    // Disable Power Measure Timer
    if m_bPowerMeasureSpi then begin
      tmPowerMeasureSpi.Enabled := False;
      Sleep(2);
    end;

    // Create Event
    m_bWaitEventSpi := True;
		m_sEventSpi := Format('SendSpi%d%0.4x',[self.m_nPgNo,nSigId]);
		m_hEventSpi := CreateEvent(nil, False, False, PWideChar(m_sEventSpi));

		for i := 0 to nRetry do begin
			if StatusSpi in [pgForceStop, pgDisconnect] then Break;
	    // Send and WaitAck
      FRxDataSpi.NgOrYes := DefPG.CMD_SPI_READY;
			Task;
      try  //2021-11-25 Add try/except (remove exception message while initialize)
  			dwRtn := WaitForSingleObject(m_hEventSpi,nWaitMS);
  			case dwRtn of
  				WAIT_OBJECT_0: begin
  					if FRxDataSpi.NgOrYes = DefPg.CMD_SPI_RESULT_ACK then Break
  					else dwRtn := WAIT_FAILED;
  				end;
  				WAIT_TIMEOUT: begin
  				end
  				else begin
  					Break;
          end;
  			end;
      except
        Break;
      end;
		end;
	finally
		if m_bWaitEventSpi then CloseHandle(m_hEventSpi);
    m_bWaitEventSpi := False;

		// Enable Power Measure Timer
    if m_bPowerMeasureSpi then tmPowerMeasureSpi.Enabled := True;
	end;

  Result := dwRtn;
end;

//------------------------------------------------------------------------------
procedure TDongaPG.ReadSpiData(wSigId, wLen: Word; const btData: array of Byte); //TBD:MERGE? POCB
var
  RxPwrDataSpi    : TRxPwrDataSpi;
  RxPwrCalDataSpi : TPwrCalDataSpi;
  sDebug, sTemp : string;
  i, nTemp : Integer;
  wTemp    : Word;
begin
  m_nConnCheckSpi := 0;

	if Common.SystemInfo.SPI_TYPE = DefPG.SPI_TYPE_DJ023_SPI then begin
	  if (m_FlashRead.ReadType <> flashReadNone) and (not m_FlashRead.bReadDone) then begin
  	  sTemp := Format('ReadSpiData: ReadType(%d): ',[Ord(m_FlashRead.ReadType)]);
	    CopyMemory(@m_FlashRead.RxData[m_FlashRead.RxSize], @btData[0], wLen);
	    m_FlashRead.RxSize := m_FlashRead.RxSize + wLen;
	    {$IFDEF DEBUG}
	    sDebug := sTemp + Format('RX.Len=%d (%d/%d)',[wLen,m_FlashRead.RxSize,m_FlashRead.ReadSize]);
	    CodeSite.Send(sDebug);
	    {$ENDIF}
	    if m_FlashRead.RxSize >= m_FlashRead.ReadSize then begin
	      m_FlashRead.bReadDone := True;
	      Common.CalcCheckSum(@m_FlashRead.RxData[0],m_FlashRead.RxSize,m_FlashRead.ChecksumCalc);
	    end;
	    Exit;
	  end;
	end;

  FRxDataSpi.wRxSigId := wSigId;

	if Common.SystemInfo.SPI_TYPE = DefPG.SPI_TYPE_DJ023_SPI then begin
	  if wSigId <> DefPG.SIG_SPI_FLASH_READ_ACK then begin
	    FRxDataSpi.NgOrYes := btData[0];
	    FRxDataSpi.DataLen := wLen - 1;
	    if (wLen > 1) and (wLen < 8192) then begin  //TBD:8192?
	      CopyMemory(@FRxDataSpi.Data[0],@btData[1],wLen - 1);
	    end;
	  end
	  else begin
	    FRxDataSpi.NgOrYes := DefPG.CMD_SPI_RESULT_ACK;
	    FRxDataSpi.DataLen := wLen;
	    if wLen > 1 then begin
	      CopyMemory(@FRxDataSpi.Data[0],@btData[0],wLen);
	    end;
	  end;
	end
	else begin
    FRxDataSpi.NgOrYes := btData[0];
    FRxDataSpi.DataLen := wLen - 1;
    if (wLen > 1) and (wLen < 8192) then begin  //TBD:8192?
      CopyMemory(@FRxDataSpi.Data[0],@btData[1],wLen - 1);
    end;
	end;
//m_nConnCheckSpi := 0;

  case wSigId of

    //DJ021|DJ201|DJ023 SIG_SPI_CONN_CHECK_ACK (0x0003)
    DefPG.SIG_SPI_CONN_CHECK_ACK : begin
      m_nConnCheckSpi := 0;
      if (m_sFwVerSpi = '') and (not m_bFwVerReqSpi) then begin
        m_bFwVerReqSpi := True;
        SendSpiFwVerReq;
        SetCyclicTimerSpi(True{bEnable});
        {$IFDEF OLD}
        Common.ThreadTask(procedure begin
          SendSpiFwVerReq;
          SetCyclicTimerSpi(True{bEnable});
        end);
        {$ENDIF}
      end;
      //
      if StatusSpi = pgDisconnect then begin
        StatusSpi   := pgConnect;
        m_sFwVerSpi := '';
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,'', 10);
      end;
    end;

//{$IFDEF USE_DJ021_QSPI}
    //DJ021|DJ201|----- SIG_DJ021_MODEL_INFO_ACK (0x0013)
    DefPG.SIG_DJ021_MODEL_INFO_ACK : begin
      SendSpiModelCrcReq;
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
    
    //DJ021|DJ201|----- SIG_DJ021_MODEL_CRC_ACK (0x0015)
    DefPG.SIG_DJ021_MODEL_CRC_ACK : begin
       if FRxDataSpi.DataLen >= 2 then begin
        CopyMemory(@wTemp,@FRxDataSpi.Data[0],2);
        m_wModelCrcSpi := htons(wTemp);
      end;
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,sDebug, 13); //ModelCrc //TBD:MERGE?
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
//{$ENDIF} //USE_DJ021_QSPI

//{$IFDEF USE_DJ023_SPI}
    //-----|-----|DJ023 SIG_DJ023_MODEL_INFO_ACK (0x0007)
    DefPG.SIG_DJ023_MODEL_INFO_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
//{$ENDIF} //USE_DJ023_SPI

    //DJ021|DJ201|DJ023 SIG_SPI_I2C_ACK (0x0017)
    DefPG.SIG_SPI_I2C_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;

    //DJ021|DJ201|DJ023 SIG_SPI_FLASH_ACCESS_ACK (0x0021)
    DefPG.SIG_SPI_FLASH_ACCESS_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;

//{$IFDEF USE_DJ021_QSPI}
    //DJ021|DJ201|----- SIG_DJ021_EEPROM_WP_ACK (0x0023)
    DefPG.SIG_DJ021_EEPROM_WP_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
//{$ENDIF} //USE_DJ021_QSPI

    //DJ021|DJ201|DJ023 SIG_SPI_FLASH_ERASE_ACK (0x0025)
    DefPG.SIG_SPI_FLASH_ERASE_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;

//{$IFDEF USE_DJ021_QSPI}
    //DJ021|DJ201|----- SIG_SPI_FLASH_WRITE_REQ (0x0026) // DJ021_SQPI Ack for Data Download Packet //TBD:MERGE? (FoldFI)
    DefPG.SIG_SPI_FLASH_WRITE_REQ : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
//{$ENDIF} //USE_DJ021_QSPI

    //DJ021|DJ201|DJ023 SIG_SPI_FLASH_WRITE_ACK (0x0027)
    DefPG.SIG_SPI_FLASH_WRITE_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;

    //DJ021|DJ201|DJ023 SIG_SPI_FLASH_READ_ACK (0x0029)
    DefPG.SIG_SPI_FLASH_READ_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;

//{$IFDEF USE_DJ023_SPI}
    //-----|DJ023 SIG_DJ023_FLASH_INIT_ACK (0x0033)
    DefPG.SIG_DJ023_FLASH_INIT_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
//{$ENDIF} //USE_DJ023_SPI

//{$IFDEF USE_DJ021_QSPI}
    //DJ021|DJ201|----- SIG_DJ021_DIMMING_ACK (0x0045)
    DefPG.SIG_DJ021_DIMMING_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
//{$ENDIF} //USE_DJ021_QSPI

//{$IFDEF USE_DJ023_SPI}
    //-----|-----|DJ023 SIG_DJ023_DATA_DOWN_ACK (0x0050) // DJ023_SPI Ack for Data Download Packet //TBD:MERGE? (POCB)
    DefPG.SIG_DJ023_DATA_DOWN_ACK : begin
      //!!! if m_bWaitEventSpi then SetEvent(m_hEvntSpi);
    end;
    //-----|DJ023 SIG_DJ023_SIG_SOURCE_SEL_ACK (0x0051) //TBD:MERGE?
  //DefPG.SIG_DJ023_SIG_SOURCE_SEL_ACK : begin
  //  //!!! if m_bWaitEventSpi then SetEvent(m_hEvntSpi);
  //end;
    //-----|DJ023 SIG_DJ023_SIG_ON_OFF_ACK (0x0055)
    DefPG.SIG_DJ023_SIG_ON_OFF_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
//{$ENDIF} //USE_DJ023_SPI

//{$IFDEF USE_DJ021_QSPI}
    //DJ021|DJ201|----- SIG_DJ021_NG_STATUS_ACK (0x0053)
    {$IFDEF TBD_MERGE_QSPI_POWER} //TBD:MERGE? QSPI:POWER?		
    DefPG.SIG_DJ021_NG_STATUS_ACK : begin
      if DefPocb.PGSPI_MAIN_TYPE = DefPocb.PGSPI_MAIN_PG then exit;
			//
      if FRxDataSpi.DataLen > 0 then begin
        nTemp := FRxDataSpi.Data[0];
        if nTemp <> 0 then begin
          //if FRxDataSpi.DataLen > 13 then begin
            CopyMemory(@wTemp, @FRxDataSpi.Data[1], 2);
            RxPwrDataSpi.VCC := htons(wTemp);
            CopyMemory(@wTemp, @FRxDataSpi.Data[5], 2);
            RxPwrDataSpi.VDD2 := htons(wTemp);
            CopyMemory(@wTemp, @FRxDataSpi.Data[7], 2);
            RxPwrDataSpi.ICC := htons(wTemp);
            CopyMemory(@wTemp, @FRxDataSpi.Data[11], 2);
            RxPwrDataSpi.IDD2 := htons(wTemp);
						// QSPI_RX_MSG(1=10mV,1=1mA) -> m_PwrDataSpi(1=mV,1=1mA)
            m_PwrDataSpi.VCC     := RxPwrDataSpi.VCC  * 10;
            m_PwrDataSpi.VDD_VEL := RxPwrDataSpi.VDD2 * 10;
            m_PwrDataSpi.ICC     := RxPwrDataSpi.ICC;
            m_PwrDataSpi.IDD_IEL := RxPwrDataSpi.IDD2;
            sTemp := GetQspiAlarmStr(nTemp,0);
            ShowTestWindow(DefPocb.MSG_MODE_DISPLAY_ALARM,0,sTemp);
            ShowTestWindow(DefPocb.MSG_MODE_DISPLAY_VOLCUR,0,'');
          //end;
        end;
      end;
    end;
    {$ENDIF} //TBD_MERGE_QSPI_POWER  //TBD:MERGE? QSPI:POWER?
		
    //DJ021|DJ201|----- SIG_DJ021_POWER_ON_AUTO_ACK (0x0077)
    DefPG.SIG_DJ021_POWER_ON_AUTO_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
		
    //DJ021|DJ201|----- SIG_DJ021_POWER_ON_ACK (0x0079)
    DefPG.SIG_DJ021_POWER_ON_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
		
    //DJ021|DJ201|----- SIG_DJ021_POWER_OFF_ACK (0x0081)
    DefPG.SIG_DJ021_POWER_OFF_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
		
    //DJ021|DJ201|----- SIG_DJ021_READ_POWER_ACK (0x0083)
    DefPG.SIG_DJ021_READ_POWER_ACK : begin
      if DefPocb.PGSPI_MAIN_TYPE = DefPocb.PGSPI_MAIN_PG then exit;
			//
      if FRxDataSpi.DataLen > 10 then begin
        //CopyMemory(@ReadPwrData, @btReadData[0], FRxDataSpi.DataLen);
        CopyMemory(@wTemp, @FRxDataSpi.Data[0], 2);
        RxPwrDataSpi.VCC := htons(wTemp);
        CopyMemory(@wTemp, @FRxDataSpi.Data[4], 2);
        RxPwrDataSpi.VDD2 := htons(wTemp);
        CopyMemory(@wTemp, @FRxDataSpi.Data[6], 2);
        RxPwrDataSpi.ICC := htons(wTemp);
        CopyMemory(@wTemp, @FRxDataSpi.Data[10], 2);
        RxPwrDataSpi.IDD2 := htons(wTemp);
			  // QSPI_RX_MSG(1=10mV,1=1mA) -> m_PwrDataSpi(1=mV,1=1mA)
        m_PwrDataSpi.VCC     := RxPwrDataSpi.VCC  * 10;
        m_PwrDataSpi.VDD_VEL := RxPwrDataSpi.VDD2 * 10;
        m_PwrDataSpi.ICC     := RxPwrDataSpi.ICC;
        m_PwrDataSpi.IDD_IEL := RxPwrDataSpi.IDD2;
        {$IFDEF PANEL_AUTO}
        if FRxDataSpi.DataLen > 14 then begin
          CopyMemory(@wTemp, @FRxDataSpi.Data[12], 2);
          RxPwrDataSpi.ELVDD := htons(wTemp);
          CopyMemory(@wTemp, @FRxDataSpi.Data[14], 2);
          RxPwrDataSpi.ELIDD := htons(wTemp);
        end
        else begin
          RxPwrDataSpi.ELVDD := 0;
          RxPwrDataSpi.ELIDD := 0;
        end;
				// QSPI_RX_MSG(1=10mV,1=1mA) -> m_PwrDataSpi(1=mV,1=1mA)
        m_PwrDataSpi.ELVDD := RxPwrDataSpi.ELVDD * 10;
    		m_PwrDataSpi.ELIDD := RxPwrDataSpi.ELIDD;
        {$ENDIF}
      end;
      if m_bWaitPwrEventSpi then SetEvent(m_hPwrEventSpi);
      //TBD:MERGE? ShowTestWindow(DefPocb.MSG_MODE_DISPLAY_VOLCUR,0,'');
      // for Mainter.
      if UdpServer.IsMainter then begin  //TBD?(REF_AUTO_GBAC?)
        UdpServer.OnRxDataForMaint(DEBUG_LOG_DEVTYPE_SPI,Self.m_nPgNo,FRxDataSpi.DataLen,FRxDataSpi.Data);
      end;
    end;

    //DJ021|DJ201|----- SIG_DJ021_POWER_OFFSET_W_ACK (0x0087)
    DefPG.SIG_DJ021_POWER_OFFSET_W_ACK : begin
      if DefPocb.PGSPI_MAIN_TYPE = DefPocb.PGSPI_MAIN_PG then exit;
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;

    //DJ021|DJ201|----- SIG_DJ021_POWER_OFFSET_R_ACK (0x0089)
    DefPG.SIG_DJ021_POWER_OFFSET_R_ACK : begin
      if DefPocb.PGSPI_MAIN_TYPE = DefPocb.PGSPI_MAIN_PG then exit;
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
//{$ENDIF} //USE_DJ021_QSPI

    //DJ021|DJ201|DJ023 SIG_SPI_RESET_ACK (0x0091)
    DefPG.SIG_SPI_RESET_ACK : begin
      if (FRxDataSpi.NgOrYes = DefPg.CMD_SPI_RESULT_ACK) then m_sFwVerSpi := '';  //TBD:MERGE? FoldFI(X) POCB(O)
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;

    //DJ021|DJ201|----- SIG_SPI_CONNECTION_ACK (0x00D1)
  //DefPG.SIG_SPI_CONNECTION_ACK : begin
  //  if m_bWaitEventSpi then SetEvent(m_hEventSpi);
  //end;

//{$IFDEF USE_DJ021_QSPI}
    //DJ021|DJ201|----- SIG_DJ021_UPLOAD_START_ACK (0x00E1)
    DefPG.SIG_DJ021_UPLOAD_START_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
		
    //DJ021|DJ201|----- SIG_DJ021_UPLOAD_DATA_ACK (0x00E3)
    DefPG.SIG_DJ021_UPLOAD_DATA_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;
		
    //DJ021|DJ201|----- SIG_DJ021_PWR_AUTOCAL_MODE_ACK (Auto:0x00E5,Foldable:0x00D5)
    {$IFDEF TBD_MERGE_QSPI_POWER} //TBD:MERGE? QSPI:POWER?		
    DefPG.SIG_DJ021_PWR_AUTOCAL_MODE_ACK : begin
      if DefPocb.PGSPI_MAIN_TYPE = DefPocb.PGSPI_MAIN_PG then exit;
			//
      m_PwrCalInfoSpi.Result := 'OK';
      m_PwrCalInfoSpi.Log    := '';
      nTemp := FRxDataSpi.NgOrYes;
      if nTemp <> DefPg.CMD_SPI_RESULT_ACK then begin
        m_PwrCalInfoSpi.Result := 'NG';
        case FRxDataSpi.Data[0] of
          $0 : m_PwrCalInfoSpi.Log := 'Save_offset';
          $1 : m_PwrCalInfoSpi.Log := 'Loader ID Fail';
          $2 : m_PwrCalInfoSpi.Log := 'Loader VCC Zero';
          $3 : m_PwrCalInfoSpi.Log := 'VCC Over Voltage';
          $4 : m_PwrCalInfoSpi.Log := 'Loader VDD Zero';
          $5 : m_PwrCalInfoSpi.Log := 'VDD Over Voltage';
          $6 : m_PwrCalInfoSpi.Log := 'Pwr Cal NG Case 6';
          $7 : m_PwrCalInfoSpi.Log := 'Pwr Cal NG Case 7';
        end;
      end;
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
      //tmAliveCheckSpi.Enabled := True;
    end;
    {$ENDIF} //TBD_MERGE_QSPI_POWER  //TBD:MERGE? QSPI:POWER?		
		
    //DJ021|DJ201|----- SIG_DJ021_PWR_AUTOCAL_DATA_ACK (Auto:0x00E7,Foldable:0x00D7)
    {$IFDEF TBD_MERGE_QSPI_POWER} //TBD:MERGE? QSPI:POWER?
    DefPG.SIG_DJ021_PWR_AUTOCAL_DATA_ACK : begin
      if DefPocb.PGSPI_MAIN_TYPE = DefPocb.PGSPI_MAIN_PG then exit;
			//
      m_PwrCalInfoSpi.Result := '';
      m_PwrCalInfoSpi.Log    := '';
      m_PwrCalInfoSpi.VCC := 'VCC,';
      m_PwrCalInfoSpi.ICC := 'ICC,';
      m_PwrCalInfoSpi.VDD := 'VDD,';
      m_PwrCalInfoSpi.IDD := 'IDD,';

      nTemp := FRxDataSpi.NgOrYes;
      if nTemp = DefPg.CMD_SPI_RESULT_ACK then begin
        for i := 0 to 6 do begin
          CopyMemory(@wTemp, @FRxDataSpi.Data[i*2], 2);
          RxPwrCalDataSpi.VCC[i] := (wTemp);
          m_PwrCalDataSpi.VCC[i] := RxPwrCalDataSpi.VCC[i];
          CopyMemory(@wTemp, @FRxDataSpi.Data[i*2+14], 2);
          RxPwrCalDataSpi.ICC_IEL[i] := (wTemp);
          m_PwrCalDataSpi.ICC_IEL[i] := RxPwrCalDataSpi.ICC_IEL[i];
          CopyMemory(@wTemp, @FRxDataSpi.Data[i*2+28], 2);
          RxPwrCalDataSpi.VDD[i] := (wTemp);
          m_PwrCalDataSpi.VDD[i] := RxPwrCalDataSpi.VDD[i];
          CopyMemory(@wTemp, @FRxDataSpi.Data[i*2+42], 2);
          RxPwrCalDataSpi.IDD_IEL[i] := (wTemp);
          m_PwrCalDataSpi.IDD_IEL[i] := RxPwrCalDataSpi.IDD_IEL[i];
        end;
      end
      else begin
        m_PwrCalInfoSpi.Result := 'NG';
      end;
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
      //tmAliveCheckSpi.Enabled := True;
    end;
    {$ENDIF} //TBD_MERGE_QSPI_POWER  //TBD:MERGE? QSPI:POWER?
//{$ENDIF} //USE_DJ021_QSPI

    //DJ021|DJ201|DJ023 SIG_SPI_FW_VER_ACK (0x00F1)
    DefPG.SIG_SPI_FW_VER_ACK : begin
      if Common.SystemInfo.SPI_TYPE = SPI_TYPE_DJ023_SPI then begin
        if wLen > 3 then begin  //FRxDataSpi.DataLen
          sTemp := Chr(btData[0]) + Chr(btData[1])+ Chr(btData[2]) + Chr(btData[3]);
          m_sFwVerSpi := Format('%0.1f',[StrToIntDef(sTemp,0)/100]);
          CopyMemory(@m_wModelCrcSpi,@btData[3],2);
        end;
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,m_sFwVerSpi, 11); //TBD:MERGE?
      end
      else begin //DJ021|DJ201
        if FRxDataSpi.DataLen > 3 then begin
          sTemp := Chr(FRxDataSpi.Data[0]) + Chr(FRxDataSpi.Data[1])+ Chr(FRxDataSpi.Data[2]) ;
          m_sFwVerSpi := Format('%0.1f',[StrToIntDef(sTemp,0)/10]);
          sTemp := '$'+ Chr(FRxDataSpi.Data[3]); // e.g., 1.3D : D -> 13
          nTemp := StrToIntDef(sTemp,0);
          m_sFwVerSpi := m_sFwVerSpi + Format('%0.2d',[nTemp]);
        end;
        if FRxDataSpi.DataLen > 7 then begin
          sTemp := Chr(FRxDataSpi.Data[4]) + Chr(FRxDataSpi.Data[5])+ Chr(FRxDataSpi.Data[6]) ;
          m_sBootVerSpi := Format('%0.1f',[StrtointDef(sTemp,0)/10])+ Chr(FRxDataSpi.Data[7]);
        end;
        if FRxDataSpi.DataLen > 9 then begin
          CopyMemory(@m_wModelCrcSpi,@FRxDataSpi.Data[8],2);
        end;
        sDebug := m_sFwVerSpi + ' ' + m_sBootVerSpi + ' ' + Format('%0.4x',[m_wModelCrcSpi]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,sDebug, 11); //TBD:MERGE?
      end;
    //if m_bWaitEventSpi then SetEvent(m_hEventSpi); //!!!!
    end;

    //DJ021|DJ201|DJ023 SIG_SPI_FW_DOWN_ACK (0x00F3) //DJ023:FPGA, DJ021:FW
    DefPG.SIG_SPI_FW_DOWN_ACK : begin
      if m_bWaitEventSpi then SetEvent(m_hEventSpi);
    end;

  end;
end;

//------------------------------------------------------------------------------
procedure TDongaPG.SendSpiData(wSigId, wLen: Word; TxBuf: TIdBytes; bIsData: Boolean = False);
var
  TxBuffer : TIdBytes;
  nDebugMsgType : Integer;
  nRemotePort : Integer;
begin
  if m_ABindingSpi = nil then Exit;

	try
    if bIsData then begin
      SetLength(TxBuffer,Length(TxBuf));
      CopyMemory(@TxBuffer[0],@TxBuf[0],Length(TxBuf));
    end
    else begin
      SetLength(TxBuffer, 4 + wLen);
      CopyMemory(@TxBuffer[0], @wSigId, 2);
      CopyMemory(@TxBuffer[2], @wLen, 2);
      CopyMemory(@TxBuffer[4], @TxBuf[0], wLen);
    end;

    FRxDataSpi.wTxSigId := wSigId;

    {$IFDEF SIMULATOR_SPI}
    if m_ABindingSpi <> nil then nRemotePort := m_nRemotePortSpi
    else                         nRemotePort := TernaryOp((m_nPgNo=DefPocb.PG_1), 60002, 60003);
    {$ELSE}
    nRemotePort := DefPG.PGSPI_DEFAULT_PORT;
    {$ENDIF}
    if (wSigId = DefPG.SIG_SPI_CONN_CHECK_REQ) or (wSigId = DefPG.SIG_SPI_RESET_REQ) then begin
      UdpServer.udpSvr.SendBuffer(m_sSpiIP, nRemotePort, TxBuffer);
    end
    else begin
      if m_ABindingSpi <> nil then m_ABindingSpi.SendTo(m_sSpiIP, nRemotePort, TxBuffer)
      else                         Exit;
    end;

    // debug/maint log
    if bIsData then begin
      nDebugMsgType := DEBUG_LOG_MSGTYPE_DOWNDATA;
    end
    else begin
      if (wSigId = DefPG.SIG_SPI_CONN_CHECK_REQ) then nDebugMsgType := DEBUG_LOG_MSGTYPE_CONNCHECK
      else                                            nDebugMsgType := DEBUG_LOG_MSGTYPE_INSPECT;
    end;
    if (Common.m_nDebugLogLevelActive[DEBUG_LOG_DEVTYPE_SPI] >= nDebugMsgType) then begin
      Common.DebugLog(m_nPgNo,DEBUG_LOG_DEVTYPE_SPI,nDebugMsgType,'TX',Self.m_sSpiIP,TxBuffer);
    end;
    if UdpServer.FIsMainter and Assigned(UdpServer.OnTxDataForMaint) and (nDebugMsgType = DEBUG_LOG_MSGTYPE_INSPECT) then begin
      UdpServer.OnTxDataForMaint(DEBUG_LOG_DEVTYPE_SPI,Self.m_nPgNo,Length(TxBuffer),TxBuffer);
    end;
	except

	end;
end;

function TDongaPG.CheckSpiPwrCmdAck(Task: TProc; nSid, nDelay, nRetry: Integer): DWORD; //TBD:MERGE? PGSPI_MAIN_QSPI? FoldFI(QSPI)
var
	dwRtn  : DWORD;
	i      : Integer;
	sEvent : WideString;
begin
	try
    // 통신중에 Power Sensing 했을 경우 중복 피하기 위함.
    if m_bPowerMeasureSpi then begin
      Sleep(2);
      tmPowerMeasureSpi.Enabled := False;
    end;

    dwRtn := WAIT_FAILED;
		sEvent := Format('SendSpi%d%x0.4',[self.m_nPgNo,nSid]);
		m_hPwrEventSpi := CreateEvent(nil, False, False, PWideChar(sEvent));
    m_bWaitPwrEventSpi := True;     // Create Event 했는지 확인 하는 Flag.
		for i := 0 to nRetry do begin
			if StatusSpi in [pgForceStop,pgDisconnect] then Break;  //2019-07-15 Task 수행 전으로 이동 (SPI 연결되어 있지 않은 경우 Exception 발생)
      FRxDataSpi.NgOrYes := DefPG.CMD_SPI_READY;
			Task;
      try
//{$IFNDEF SIMULATOR_PANEL}
  			dwRtn := WaitForSingleObject(m_hPwrEventSpi,nDelay);
//{$ELSE}
//    FRxDataSpi.NgOrYes := DefPg.CMD_SPI_RESULT_ACK;
//		nRet := WAIT_OBJECT_0;
//{$ENDIF}
	  		case dwRtn of
		  		WAIT_OBJECT_0 : begin
			  		if FRxDataSpi.NgOrYes = DefPg.CMD_SPI_RESULT_ACK then Break
  					else begin
  						dwRtn := WAIT_FAILED;
  					end;
  				end;
  				WAIT_TIMEOUT  : begin
  				end
  				else begin
  					Break;
          end;
	  		end;
      except
        Break;
      end;
		end;
	finally
		CloseHandle(m_hPwrEventSpi);
    m_bWaitPwrEventSpi := False;
    // 통신중에 Power Sensing 했을 경우 중복 피하기 위함.
    if m_bPowerMeasureSpi then begin
      tmPowerMeasureSpi.Enabled := True;
    end;
	end;
  Result := dwRtn;
end;

//------------------------------------------------------------------------------
function TDongaPG.GetQspiAlarmStr(alarm_no: Integer; nCurVal : Integer = -1): String;  //FoldGB
var
  sRet : string;
  dCur : Double;
  nLimit : Integer;
begin
  // Ng Message.
  sRet :='';
  case alarm_no of
    1 : sRet := 'VCC High';
    2 : sRet := 'VCC Low';
    3 : sRet := 'VDD High';
    4 : sRet := 'VDD Low';
    5 : begin
      {$IFDEF PANEL_AUTO}
        sRet := 'VDD High';
      {$ELSE}
        sRet := 'VEL High';
      {$ENDIF}
    end;
    6 : begin
      {$IFDEF PANEL_AUTO}
        sRet := 'VDD Low';
      {$ELSE}
        sRet := 'VEL Low';
      {$ENDIF}
    end;
    7 : sRet := 'ICC High';
    8 : sRet := 'ICC Low';
    9 : sRet := 'IDD High';
    10 : sRet := 'IDD Low';
    11 : begin
      {$IFDEF PANEL_AUTO}
        sRet := 'IDD High';
      {$ELSE}
        sRet := 'IEL High';
      {$ENDIF}
    end;
    12 : begin
      {$IFDEF PANEL_AUTO}
        sRet := 'IDD Low';
      {$ELSE}
        sRet := 'IEL Low';
      {$ENDIF}
    end
    else begin
      sRet := 'Unknown ';
    end;
  end;
  sRet := sRet + ' NG : ';

  // Limit
  case alarm_no of
    // Voltage: ModelInfo(1=1mV), QSPI_RX_MSG(1=10 mV) -> m_ReadVoltC(V)
    1 : begin
      nLimit := Common.TestModelInfo[Self.m_nPgNo].PWR_LIMIT_H[DefPG.PWR_VCC];
      sRet := sRet + Format('Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',[nLimit/1000, m_PwrDataSpi.VCC, m_PwrDataSpi.VCC - (nLimit/1000)]);
    end;
    2 : begin
      nLimit := Common.TestModelInfo[Self.m_nPgNo].PWR_LIMIT_L[DefPG.PWR_VCC];
      sRet := sRet + Format('Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',[nLimit/1000, m_PwrDataSpi.VCC, m_PwrDataSpi.VCC - (nLimit/1000)]);
    end;
    5 : begin
      nLimit := Common.TestModelInfo[Self.m_nPgNo].PWR_LIMIT_H[DefPG.PWR_VDD_VEL];
      sRet := sRet + Format('Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',[nLimit/1000, m_PwrDataSpi.VDD_VEL, m_PwrDataSpi.VDD_VEL - (nLimit/1000)]);
    end;
    6 : begin
      nLimit := Common.TestModelInfo[Self.m_nPgNo].PWR_LIMIT_L[DefPG.PWR_VDD_VEL];
      sRet := sRet + Format('Limit(%0.2f V), Measure(%0.2f V), Diff(%0.2f V)',[nLimit/1000, m_PwrDataSpi.VDD_VEL, m_PwrDataSpi.VDD_VEL - (nLimit/1000)]);
    end;
    // Current: QSPI_ModelInfo(1= 1mA), QSPI_RX_MSG(1= 1 mA) -> m_ReadVoltC(mA)
    7 : begin
      nLimit := Common.TestModelInfo[Self.m_nPgNo].PWR_LIMIT_H[DefPG.PWR_ICC];
      sRet := sRet + Format('Limit(%d mA), Measure(%d mA), Diff(%d mA)',[nLimit, m_PwrDataSpi.ICC, (m_PwrDataSpi.ICC - nLimit)]);
    end;
    8 : begin
      nLimit := Common.TestModelInfo[Self.m_nPgNo].PWR_LIMIT_L[DefPG.PWR_ICC];
      sRet := sRet + Format('Limit(%d mA), Measure(%d mA), Diff(%d mA)',[nLimit, m_PwrDataSpi.ICC, (m_PwrDataSpi.ICC - nLimit)]);
    end;
    11 : begin
      nLimit := Common.TestModelInfo[Self.m_nPgNo].PWR_LIMIT_H[DefPG.PWR_IDD_IEL];
      sRet := sRet + Format('Limit(%d mA), Measure(%d mA), Diff(%d mA)',[nLimit, m_PwrDataSpi.IDD_IEL, (m_PwrDataSpi.IDD_IEL - nLimit)]);
    end;
    12 : begin
      nLimit := Common.TestModelInfo[Self.m_nPgNo].PWR_LIMIT_L[DefPG.PWR_IDD_IEL];
      sRet := sRet + Format('Limit(%d mA), Measure(%d mA), Diff(%d mA)',[nLimit, m_PwrDataSpi.IDD_IEL, (m_PwrDataSpi.IDD_IEL - nLimit)]);
    end;
  end;
  Result := sRet;
end;

//==============================================================================
// SPI(DJ021|DJ201|DJ023) TX
//==============================================================================

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|DJ023) SIG_SPI_CONN_CHECK_REQ
//		- procedure TDongaPG.SendSpiConnCheckReq;
//
procedure TDongaPG.SendSpiConnCheckReq;
var
	TxBuf : TIdBytes;
	wSigId, wLen : Word;
begin
  wSigId := DefPG.SIG_SPI_CONN_CHECK_REQ;
  //
  case Common.SystemInfo.SPI_TYPE of
    SPI_TYPE_DJ023_SPI: begin
    	SetLength(TxBuf, 4);
    	wLen := 0;
    	CopyMemory(@TxBuf[0], @wSigId, 2);
    	CopyMemory(@TxBuf[2], @wLen, 2);
      //
      {$IFDEF SIMULATOR_SPI}
      if m_ABindingSpi = nil then m_nRemotePortSpi := TernaryOp((m_nPgNo=DefPocb.PG_1), 60002, 60003);
      {$ELSE}
      m_nRemotePortSpi := DefPG.PGSPI_DEFAULT_PORT;
      {$ENDIF}
      UdpServer.udpSvr.SendBuffer(m_sSpiIP,m_nRemotePortSpi,Id_IPv4,TxBuf);
      if (Common.m_nDebugLogLevelActive[DEBUG_LOG_DEVTYPE_SPI] >= DEBUG_LOG_MSGTYPE_CONNCHECK) then begin
        Common.DebugLog(m_nPgNo,DEBUG_LOG_DEVTYPE_SPI,DEBUG_LOG_MSGTYPE_CONNCHECK,'TX',Self.m_sSpiIP,TxBuf);
      end;
    end;
    else begin  //DJ021|DJ201
    	wLen := 0;
      SetLength(TxBuf, wLen);
      //
      SendSpiData(wSigId,wLen, TxBuf);
    end;
  end;
end;

//------------------------------------------------------------------------------
// SPI(-----|-----|DJ023) SIG_DJ023_MODEL_INFO_REQ
// SPI(DJ021|DJ201|-----) SIG_DJ021_MODEL_INFO_REQ
//		- procedure TDongaPG.SendSpiModelInfo;
//		- procedure TDongaPG.SendSpiModelInfoReq_DJ023;
//		- procedure TDongaPG.SendSpiModelInfoReq_QSPI;
//		- function TDongaPG.MakeSpiModelData_DJ023(var btaData: TIdBytes): Word;
//		- procedure TDongaPG.MakeSpiModelData_QSPI(var sModelData: AnsiString); 
//
procedure TDongaPG.SendSpiModelInfo;
var
  dwRtn  : DWORD;
  sDebug : string;
begin
//Common.ThreadTask(procedure var dwRtn: DWORD; sDebug: string;
//begin
  dwRtn := WAIT_FAILED;
  case Common.SystemInfo.SPI_TYPE of
    SPI_TYPE_DJ023_SPI : begin
      sDebug := 'SPI Model Info Download ';
      dwRtn := CheckSpiCmdAck(SendSpiModelInfoReq_DJ023, DefPG.SIG_DJ023_MODEL_INFO_REQ, 3000{nWaitMS},0{nRetry});  //TBD:IMSI(2->0)?
    end;
    else begin  //DJ021|DJ201
      sDebug := 'QSPI Model Info Download ';
      dwRtn := CheckSpiCmdAck(SendSpiModelInfoReq_QSPI,  DefPG.SIG_DJ021_MODEL_INFO_REQ, 2000{nWaitMS},2{nRetry});
    end;
  end;
  //
  case dwRtn of
    WAIT_OBJECT_0 : sDebug := sDebug + 'OK';
    WAIT_FAILED   : sDebug := sDebug + 'NG(NAK)';
    WAIT_TIMEOUT  : sDebug := sDebug + 'NG(TIME OUT)'
    else            sDebug := sDebug + 'NG(ELSE)';
  end;
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, TernaryOp(dwRtn=WAIT_OBJECT_0,0,DefPocb.LOG_TYPE_NG));
//end);
end;

procedure TDongaPG.SendSpiModelInfoReq_DJ023;
var
  TxBuf : TIdBytes;
  wSigId, wLen, nDataLen, crc16_dat : Word;
  btaData : TIdBytes;
begin
  SetLength(btaData, 1024);
  //
  wSigId := DefPG.SIG_DJ023_MODEL_INFO_REQ;
  wLen   := MakeSpiModelData_DJ023(btaData);
  //
  SetLength(TxBuf, wLen);
  CopyMemory(@TxBuf[0], @btaData[0], wLen);
  SendSpiData(wSigId,wLen, TxBuf);
end;

procedure TDongaPG.SendSpiModelInfoReq_QSPI;  //DJ021|DJ201
var
  TxBuf : TIdBytes;
  wSigId, wLen, nDataLen, crc16_dat : Word;
  sModelData : Ansistring;
begin
  wSigId   := DefPG.SIG_DJ021_MODEL_INFO_REQ;
  MakeSpiModelData_QSPI(sModelData); //TBD:MERGE? FoldFI:DJ021
  nDataLen := Length(sModelData);
  wLen     := nDataLen + 2; // + CRC
  //
  SetLength(TxBuf, wLen);
  CopyMemory(@TxBuf[0], @sModelData[1], nDataLen);
  crc16_dat := Common.Crc16(sModelData,nDataLen);
  CopyMemory(@TxBuf[0+nDataLen], @crc16_dat, 2);
  SendSpiData(wSigId,wLen, TxBuf);
end;

function TDongaPG.MakeSpiModelData_DJ023(var btaData: TIdBytes): Word;   //#SendModelSetSpi //TBD:MERGE?
var
  //TBD:MERGE? wLen : Word;
  nCnt, nTemp : Integer;
begin
{Bytes	Data          Name	Description
    1	  Mode	        0 ? Single, 1 - Dual
    4	  Dot Freq	    구동 주파수 (148.25MHz ? 14825)
    4	  H_Total	      수평 전체폭
    4	  H_Active	    수평 해상도
    4	  H_BackPorch	  수평 Back Porch
    4	  H_SyncWidth	  수평 동기 펄스 폭
    4	  V_Total	      수직 전체폭
    4	  V_Active	    수직 해상도
    4	  V_BackPorch	  수직 Back Porch
    4	  V_Sync_Width	수직 동기 펄스 폭
}
  with Common.TestModelInfo[m_nPgNo] do begin
    //TBD:MERGE? wLen := 37;
    //TBD:MERGE? SetLength(btaData,wLen);

    // DJ023
    // - cmbxDispModeSignalType=SigType  (0:LVDS,1:QUAD,2:eDP4Lane)
    // - cmbxDispModePixelType=PixelType (0:Single,1:Dual)
    // - OpModel.Mode: 0:Single, 1: Dual, 2: Quad
    nCnt := 0;
    btaData[nCnt] := TernaryOp((SigType = 0), PixelType, 2); nCnt := nCnt + 1; //Mode //cmbxDispModeSignalType=SigType (0:LVDS,1:QUAD,2:eDP4Lane)
    CopyMemory(@btaData[nCnt],@Freq,4);                      nCnt := nCnt + 4; //Freq

    nTemp := H_Total;  CopyMemory(@btaData[nCnt],@nTemp,4);  nCnt := nCnt + 4; //H_Total
    nTemp := H_Active; CopyMemory(@btaData[nCnt],@nTemp,4);  nCnt := nCnt + 4; //H_Active
    nTemp := H_BP;     CopyMemory(@btaData[nCnt],@nTemp,4);  nCnt := nCnt + 4; //H_BP
    nTemp := H_Width;  CopyMemory(@btaData[nCnt],@nTemp,4);  nCnt := nCnt + 4; //H_Width

    nTemp := V_Total;  CopyMemory(@btaData[nCnt],@nTemp,4);  nCnt := nCnt + 4; //V_Total
    nTemp := V_Active; CopyMemory(@btaData[nCnt],@nTemp,4);  nCnt := nCnt + 4; //V_Active
    nTemp := V_BP;     CopyMemory(@btaData[nCnt],@nTemp,4);  nCnt := nCnt + 4; //V_BP
    nTemp := V_Width;  CopyMemory(@btaData[nCnt],@nTemp,4);  nCnt := nCnt + 4; //V_Width
  end;
  Result := nCnt;
end;

procedure TDongaPG.MakeSpiModelData_QSPI(var sModelData: AnsiString);  //DJ021|DJ201
var
  modelQSPI : TModelInfoQSPI;
  i : Integer;
begin
  sModelData := '';
  with Common.TestModelInfo[m_nPgNo] do begin  //DJ021|DJ201_QSPI: 1=10mV,1=1mA
    // PWR_VOL      : array[0..2] of Word;
    modelQSPI.PWR_VOL[0]    := Round(PWR_VOL[DefPG.PWR_VCC]         / 10);
    modelQSPI.PWR_VOL[1]    := Round(PWR_VOL[DefPG.PWR_VDD_VEL]     / 10);
    modelQSPI.PWR_VOL[2]    := Round(PWR_VOL[DefPG.PWR_VBR]         / 10); //DJ021|DJ201 (N/A)

    if DefPocb.PGSPI_MAIN_TYPE = DefPocb.PGSPI_MAIN_PG then begin //2023-08-09		
	    // PWR_VOL_HL   : array[0..2] of Word;				
      modelQSPI.PWR_VOL_HL[0] := 0;
      modelQSPI.PWR_VOL_HL[1] := 0;
      modelQSPI.PWR_VOL_HL[2] := 0; //DJ021|DJ201 (N/A)		
	    // PWR_VOL_LL   : array[0..2] of Word;								
      modelQSPI.PWR_VOL_LL[0] := 0;
      modelQSPI.PWR_VOL_LL[1] := 0;
      modelQSPI.PWR_VOL_LL[2] := 0; //DJ021|DJ201 (N/A)
    end
    else begin					
	    // PWR_VOL_HL   : array[0..2] of Word;		
	    modelQSPI.PWR_VOL_HL[0] := Round(PWR_LIMIT_H[DefPG.PWR_VCC]     / 10);
	    modelQSPI.PWR_VOL_HL[1] := Round(PWR_LIMIT_H[DefPG.PWR_VDD_VEL] / 10);
	    modelQSPI.PWR_VOL_HL[2] := Round(PWR_LIMIT_H[DefPG.PWR_VBR]     / 10); //DJ021|DJ201 (N/A)
	    // PWR_VOL_LL   : array[0..2] of Word;					
      modelQSPI.PWR_VOL_LL[0] := Round(PWR_LIMIT_L[DefPG.PWR_VCC]     / 10);
      modelQSPI.PWR_VOL_LL[1] := Round(PWR_LIMIT_L[DefPG.PWR_VDD_VEL] / 10);
      modelQSPI.PWR_VOL_LL[2] := Round(PWR_LIMIT_L[DefPG.PWR_VBR]     / 10); //DJ021|DJ201 (N/A)		
    end;
		
    if DefPocb.PGSPI_MAIN_TYPE = DefPocb.PGSPI_MAIN_PG then begin //2023-08-09				
	    // PWR_CUR_HL   : array[0..2] of Word;		
      modelQSPI.PWR_CUR_HL[0] := 0;
      modelQSPI.PWR_CUR_HL[1] := 0;
      modelQSPI.PWR_CUR_HL[2] := 0;                                          //DJ021|DJ201 (N/A)
	    // PWR_CUR_LL   : array[0..2] of Word;			
      modelQSPI.PWR_CUR_LL[0] := 0;
      modelQSPI.PWR_CUR_LL[1] := 0;
      modelQSPI.PWR_CUR_LL[2] := 0;                                          //DJ021|DJ201 (N/A)
    end
    else begin
	    // PWR_CUR_HL   : array[0..2] of Word;
  	  modelQSPI.PWR_CUR_HL[0] := PWR_LIMIT_H[DefPG.PWR_ICC];
	    modelQSPI.PWR_CUR_HL[1] := PWR_LIMIT_H[DefPG.PWR_IDD_IEL];
	    modelQSPI.PWR_CUR_HL[2] := 0;                                          //DJ021|DJ201 (N/A)
	    // PWR_CUR_LL   : array[0..2] of Word;
      modelQSPI.PWR_CUR_LL[0] := PWR_LIMIT_L[DefPG.PWR_ICC];
      modelQSPI.PWR_CUR_LL[1] := PWR_LIMIT_L[DefPG.PWR_IDD_IEL];
      modelQSPI.PWR_CUR_LL[2] := 0;                                          //DJ021|DJ201 (N/A)
    end;
		
    // PWR_SEQ      : array[0..5] of Word;
    modelQSPI.PWR_SEQ[0]    := PowerOnSeq[0];
    modelQSPI.PWR_SEQ[1]    := PowerOnSeq[1];
    modelQSPI.PWR_SEQ[2]    := PowerOffSeq[0];
    modelQSPI.PWR_SEQ[3]    := PowerOffSeq[1];
    // PWR_SEQ_TYPE : byte;
    modelQSPI.PWR_SEQ_TYPE  := Sequence;
    // Dummy        : byte;
    modelQSPI.Dummy := 0;
    // PWR_VOL_OFFS : array[0..1] of byte;
    modelQSPI.PWR_VOL_OFFS[0] := Round(PWR_OFFSET[DefPG.PWR_VCC]     / 10);
    modelQSPI.PWR_VOL_OFFS[1] := Round(PWR_OFFSET[DefPG.PWR_VDD_VEL] / 10);
    // Reverse      : array[0..15] of Byte;
    for i := 0 to 15 do
      modelQSPI.Reverse[i] := 0;
  end;
  SetString(sModelData, PAnsiChar(@modelQSPI.PWR_VOL[0]), SizeOf(modelQSPI));
end;

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|-----) SIG_DJ021_MODEL_CRC_REQ
//		- function TDongaPG.SendSpiModelCrc: DWORD;
//		- procedure TDongaPG.SendSpiModelCrcReq;
//
//{$IF Defined(USE_DJ021_QSPI) or Defined(USE_DJ201_QSPI)}
function TDongaPG.SendSpiModelCrc: DWORD;
begin
  Result := CheckSpiCmdAck(SendSpiModelCrcReq, DefPG.SIG_DJ021_MODEL_CRC_REQ, 1000{nWaitMS},2{nRetry});
end;

procedure TDongaPG.SendSpiModelCrcReq;
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
begin
  wSigId := DefPG.SIG_DJ021_MODEL_CRC_REQ;
  wLen   := 0;
  //
  SetLength(TxBuf, wLen);
  SendSpiData(wSigId,wLen, TxBuf);
end;
//{$ENDIF} //DJ021|DJ201

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|DJ023) SIG_SPI_I2C_REQ
//		- function TDongaPG.SendSpiI2CRead(nDevAddr,nRegAddr,nDataCnt: Integer; bIs1ByteAddr: Boolean=False; nWaitMS: Integer=SPI_I2CCMD_WAIT_MSEC; nRetry: Integer=1): DWORD;
//		- function TDongaPG.SendSpiI2CWrite(nDevAddr,nRegAddr,nDataCnt: Integer; btaData: TIdBytes; bIs1ByteAddr: Boolean=False; nWaitMS: Integer=SPI_I2CCMD_WAIT_MSEC; nRetry: Integer=1): DWORD;
//		- procedure TDongaPG.SendSpiI2CModeReq(buff: TIdBytes; nDataLen: Integer);
//
function TDongaPG.SendSpiI2CRead(nDevAddr,nRegAddr,nDataCnt: Integer; bIs1ByteAddr: Boolean=False; nWaitMS: Integer=SPI_I2CCMD_WAIT_MSEC; nRetry: Integer=1): DWORD;
var
  TxBuf : TIdBytes;
  nLen  : Word;
begin
  case Common.SystemInfo.SPI_TYPE of
    DefPG.SPI_TYPE_DJ023_SPI: begin
      if (not bIs1ByteAddr) then begin
  	    nLen := 6;
  	    SetLength(TxBuf, nLen);
        TxBuf[0] := Byte(ord('R'));                   // Command('R':0x52, 'W':0x57)
        TxBuf[1] := Byte(nDataCnt and $FF);           // ReadCnt (LSB) //Little-Edian
        TxBuf[2] := Byte((nDataCnt and $FF00) shr 8); // ReadCnt (MSB)
        TxBuf[3] := Byte(nDevAddr);                   // DevAddr
        TxBuf[4] := Byte(nRegAddr and $FF);           // RegAddr (LSB) //Little-Edian
        TxBuf[5] := Byte((nRegAddr and $FF00) shr 8); // RegAddr (MSB)
      end
      else begin
  	    nLen := 5;
  	    SetLength(TxBuf, nLen);
        TxBuf[0] := Byte(ord('R'));                   // Command('R':0x52, 'W':0x57)
        TxBuf[1] := Byte(nDataCnt and $FF);           // ReadCnt (LSB) //Little-Edian
        TxBuf[2] := Byte((nDataCnt and $FF00) shr 8); // ReadCnt (MSB)
        TxBuf[3] := Byte(nDevAddr);                   // DevAddr
        TxBuf[4] := Byte(nRegAddr);                   // RegAddr
      end;
    end;
    else begin  //DJ021|DJ201
      if (not bIs1ByteAddr) then begin
    	  nLen := 7;
    	  SetLength(TxBuf, nLen);
        TxBuf[0] := TernaryOp((nDataCnt>1), Byte(ord('M')), Byte(ord('R'))); // Command('R':Read, 'M':Multi Read, 'K':PMIC Read, 'G':FS Read)
        TxBuf[1] := Byte($40);                        // Page Counter (0x01=1 Byte Address, 0x40=2 Byte Address)
        TxBuf[2] := Byte((nDataCnt and $FF00) shr 8); // ReadCnt (MSB)
        TxBuf[3] := Byte(nDataCnt and $FF);           // ReadCnt (LSB)
        TxBuf[4] := Byte(nDevAddr);                   // DevAddr
        TxBuf[5] := Byte((nRegAddr and $FF00) shr 8); // RegAddr (MSB)
        TxBuf[6] := Byte(nRegAddr and $FF);           // RegAddr (LSB)
      end
      else begin
    	  nLen := 6;
    	  SetLength(TxBuf, nLen);
        TxBuf[0] := TernaryOp((nDataCnt>1), Byte(ord('M')), Byte(ord('R'))); // Command('R':Read, 'M':Multi Read, 'K':PMIC Read, 'G':FS Read)
        TxBuf[1] := Byte($01);                        // Page Counter (0x01=1 Byte Address, 0x40=2 Byte Address)
        TxBuf[2] := Byte((nDataCnt and $FF00) shr 8); // ReadCnt (MSB)
        TxBuf[3] := Byte(nDataCnt and $FF);           // ReadCnt (LSB)
        TxBuf[4] := Byte(nDevAddr);                   // DevAddr
        TxBuf[5] := Byte(nRegAddr and $FF);           // RegAddr
      end;
    end;
  end;
  Result := CheckSpiCmdAck(procedure begin SendSpiI2CModeReq(TxBuf,nLen); end, DefPG.SIG_SPI_I2C_REQ, nWaitMS,nRetry);
end;

function TDongaPG.SendSpiI2CWrite(nDevAddr,nRegAddr,nDataCnt: Integer; btaData: TIdBytes; bIs1ByteAddr: Boolean=False; nWaitMS: Integer=SPI_I2CCMD_WAIT_MSEC; nRetry: Integer=1): DWORD;
var
  TxBuf : TIdBytes;
  nLen  : Word;
begin
  case Common.SystemInfo.SPI_TYPE of
    DefPG.SPI_TYPE_DJ023_SPI: begin //DJ023
      if (not bIs1ByteAddr) then begin
  	    nLen := 6 + nDataCnt;
  	    SetLength(TxBuf, nLen);
        TxBuf[0] := Byte(ord('W'));                   // Command('R':0x52, 'W':0x57)
        TxBuf[1] := Byte(nDataCnt and $FF);           // ReadCnt (LSB) //Little-Edian
        TxBuf[2] := Byte((nDataCnt and $FF00) shr 8); // ReadCnt (MSB)
        TxBuf[3] := Byte(nDevAddr);                   // DevAddr
        TxBuf[4] := Byte(nRegAddr and $FF);           // RegAddr (LSB) //Little-Edian
        TxBuf[5] := Byte((nRegAddr and $FF00) shr 8); // RegAddr (MSB)
        CopyMemory(@TxBuf[6], @btaData[0], nDataCnt); // Data
      end
      else begin
  	    nLen := 5 + nDataCnt;
  	    SetLength(TxBuf, nLen);
        TxBuf[0] := Byte(ord('R'));                   // Command('R':0x52, 'W':0x57)
        TxBuf[1] := Byte(nDataCnt and $FF);           // ReadCnt (LSB) //Little-Edian
        TxBuf[2] := Byte((nDataCnt and $FF00) shr 8); // ReadCnt (MSB)
        TxBuf[3] := Byte(nDevAddr);                   // DevAddr
        TxBuf[4] := Byte(nRegAddr);                   // RegAddr
        CopyMemory(@TxBuf[6], @btaData[0], nDataCnt); // Data
      end;
    end;
    else begin  //DJ021|DJ201
      if (not bIs1ByteAddr) then begin
    	  nLen := 7 + nDataCnt;
    	  SetLength(TxBuf, nLen);
        TxBuf[0] := Byte(ord('W'));                   // Command(''W':0x57:Write, 'P':FS Write, 'O':PMIC Write)
        TxBuf[1] := Byte($40);                        // Page Counter (0x01=1 Byte Address, 0x40=2 Byte Address)
        TxBuf[2] := Byte((nDataCnt and $FF00) shr 8); // ReadCnt (MSB)
        TxBuf[3] := Byte(nDataCnt and $FF);           // ReadCnt (LSB)
        TxBuf[4] := Byte(nDevAddr);                   // DevAddr
        TxBuf[5] := Byte((nRegAddr and $FF00) shr 8); // RegAddr (MSB)
        TxBuf[6] := Byte(nRegAddr and $FF);           // RegAddr (LSB)
        CopyMemory(@TxBuf[7], @btaData[0], nDataCnt); // Data
      end
      else begin
    	  nLen := 6 + nDataCnt;
    	  SetLength(TxBuf, nLen);
        TxBuf[0] := Byte(ord('W'));                   // Command('W':0x57:Write, 'P':FS Write, 'O':PMIC Write)
        TxBuf[1] := Byte($01);                        // Page Counter (0x01=1 Byte Address, 0x40=2 Byte Address)
        TxBuf[2] := Byte((nDataCnt and $FF00) shr 8); // ReadCnt (MSB)
        TxBuf[3] := Byte(nDataCnt and $FF);           // ReadCnt (LSB)
        TxBuf[4] := Byte(nDevAddr);                   // DevAddr
        TxBuf[5] := Byte(nRegAddr and $FF);           // RegAddr
        CopyMemory(@TxBuf[6], @btaData[0], nDataCnt); // Data
      end;
    end;
  end;
  Result := CheckSpiCmdAck(procedure begin SendSpiI2CModeReq(TxBuf,nLen); end, DefPG.SIG_SPI_I2C_REQ, nWaitMS,nRetry);
end;

procedure TDongaPG.SendSpiI2CModeReq(buff: TIdBytes; nDataLen: Integer);
var
  TxBuf : TIdBytes;
  wSigId, wLen : word;
begin
  wSigId := DefPG.SIG_SPI_I2C_REQ;
  wLen   := nDataLen;
  //
  SetLength(TxBuf, nDataLen);
  CopyMemory(@TxBuf[0], @buff[0], nDataLen);
  SendSpiData(wSigId,wLen, TxBuf);
end;

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|-----) SIG_DJ021_EEPROM_WP_REQ
//		- function TDongaPG.SendSpiEepromWp(nMode: Integer; nWaitMS: Integer): DWORD;
//		- procedure TDongaPG.SendSpiEepromWpReq(nMode: Integer);
//
//{$IF Defined(USE_DJ021_QSPI) or Defined(USE_DJ201_QSPI)}
function TDongaPG.SendSpiEepromWp(nMode: Integer; nWaitMS: Integer): DWORD;
begin
  Result := CheckSpiCmdAck(procedure begin SendSpiEepromWpReq(nMode); end, DefPG.SIG_DJ021_EEPROM_WP_REQ, nWaitMS,1{nRetry});
end;

procedure TDongaPG.SendSpiEepromWpReq(nMode: Integer);
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
begin
  wSigId := DefPG.SIG_DJ021_EEPROM_WP_REQ;
  wLen   := 1;
  //
  SetLength(TxBuf, wLen);
  TxBuf[0] := Byte(nMode); // Write_Protect // Enable : 1
  SendSpiData(wSigId,wLen, TxBuf);
end;
//{$ENDIF} //DJ021|DJ201

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|DJ023) SIG_SPI_FLASH_ACCESS_REQ
//		- function TDongaPG.SendSpiFlashAccess(nMode: Integer): DWORD;
//		- procedure TDongaPG.SendSpiFlashAccessReq(nMode: Integer);
//
function TDongaPG.SendSpiFlashAccess(nMode: Integer): DWORD;
begin
  Result := CheckSpiCmdAck(procedure begin SendSpiFlashAccessReq(nMode); end, DefPG.SIG_SPI_FLASH_ACCESS_REQ, 2000{nWaitMS},1{nRetry}); //TBD:MERGE? nWaitMS(POCB:3000,FoldFI:4000)
  //
  m_FlashAccessSts := flashAccessUnknown;
  if (Result = WAIT_OBJECT_0) then begin
    if      nMode = 0 then m_FlashAccessSts := flashAccessDisabled
    else if nMode = 1 then m_FlashAccessSts := flashAccessEnabled;
  end;
end;

procedure TDongaPG.SendSpiFlashAccessReq(nMode: Integer);
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
begin
  wSigId := DefPG.SIG_SPI_FLASH_ACCESS_REQ;
  wLen   := 1;
  //
  SetLength(TxBuf, wLen);
  TxBuf[0] := Byte(nMode); //nMode: 0=Disable,1=Enable
  SendSpiData(wSigId,wLen, TxBuf);
end;

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|DJ023) SIG_SPI_FLASH_ERASE_REQ
//		- function TDongaPG.SendSpiFlashErase(nMode: Integer; nAddress, nSize: UInt32; nWaitMS: Integer): DWORD;
//		- procedure TDongaPG.SendSpiFlashEraseReq(nMode: Integer; nAddress, nSize: UInt32);
//
function TDongaPG.SendSpiFlashErase(nMode: Integer; nAddress, nSize: UInt32; nWaitMS: Integer): DWORD;
begin
  Result := CheckSpiCmdAck(procedure begin SendSpiFlashEraseReq(nMode, nAddress,nSize); end, DefPG.SIG_SPI_FLASH_ERASE_REQ, nWaitMS,0{nRetry});
end;

procedure TDongaPG.SendSpiFlashEraseReq(nMode: Integer; nAddress, nSize: UInt32);
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
  dwAddr, dwSize : UInt32;
begin
  wSigId := DefPG.SIG_SPI_FLASH_ERASE_REQ;
  wLen   := 9;
  //
  SetLength(TxBuf, wLen);
  TxBuf[0]  := Byte(nMode);  // Mode: 0xC7=Chip,0xD8=Block,0x20=Sector //TBD:MERGE? Check nMode DJ021/DJ023???
  case Common.SystemInfo.SPI_TYPE of
    DefPG.SPI_TYPE_DJ023_SPI : begin
      dwAddr := nAddress;        //DJ023: Little Edian
      dwSize := nSize;           //DJ023: Little Edian
    end;
    else begin  //DJ021|DJ201
      dwAddr := htonl(nAddress); //DJ021|DJ201: Big Edian
      dwSize := htonl(nSize);    //DJ021|DJ201: Big Edian
    end;
  end;
  CopyMemory(@TxBuf[1], @dwAddr, 4);
  CopyMemory(@TxBuf[5], @dwSize, 4);
  SendSpiData(wSigId,wLen, TxBuf);
end;

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|DJ023) SIG_SPI_FLASH_WRITE_REQ
//		- function TDongaPG.SendSpiFlashWrite_StartEnd(nMode: Integer; nAddrChksum,nSize: UInt32; nChecksum: UInt32; nWaitMS: Integer): DWORD;
//		- procedure TDongaPG.SendSpiFlashWrite_StartEndReq(wMode: Integer; nAddrChksum,nSize: UInt32);
//		- function TDongaPG.SendSpiFlashWrite_Data(wLen: Integer; TxBuf: TIdBytes): DWORD;
//
function TDongaPG.SendSpiFlashWrite_StartEnd(nMode: Integer; nAddrChksum,nSize: UInt32; nWaitMS: Integer): DWORD; //#SendQSPIWriteStartEnd
var
  sDebug : string;
begin
  //TBD:MERGE? nWaitMS: FoldFI(START:3000,END:60000) POCB(3000->10000)
  Result := WAIT_FAILED;
  case nMode of
    DefPG.PGSPI_DOWNLOAD_START : begin
      sDebug := Format('SendSpiFlashWriteStartEnd(START,Addr=%d,Len=%d)',[nAddrChksum,nSize]);
      Result := CheckSpiCmdAck(procedure begin SendSpiFlashWrite_StartEndReq(nMode, nAddrChksum,nSize); end, SIG_SPI_FLASH_WRITE_REQ, nWaitMS,1{nRetry});
    end;
    DefPG.PGSPI_DOWNLOAD_END : begin
      sDebug := Format('SendSpiFlashWriteStartEnd(END,Chksum=0x%0.8x)',[nAddrChksum]);
      Result := CheckSpiCmdAck(procedure begin SendSpiFlashWrite_StartEndReq(nMode, nAddrChksum,0{nSize:dummy}); end, SIG_SPI_FLASH_WRITE_REQ, nWaitMS,0{nRetry});
    end;
  end;
  case Result of
    WAIT_OBJECT_0: sDebug := sDebug + ' OK';
    WAIT_TIMEOUT : sDebug := sDebug + ' NG(Timeout)';
    WAIT_FAILED  : sDebug := sDebug + ' NG(Failed)';
    else           sDebug := sDebug + ' NG(Etc)';
  end;
  Common.MLog(m_nPgNo,sDebug);
end;

procedure TDongaPG.SendSpiFlashWrite_StartEndReq(wMode: Integer; nAddrChksum,nSize: UInt32);  //#SendQSPIWriteStartEndReq #SendQspiDataDown_StartEndReq
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
  dwAddrChksum, dwSize : UInt32;
begin
  wSigId := DefPG.SIG_SPI_FLASH_WRITE_REQ;
  case wMode of
    DefPG.PGSPI_DOWNLOAD_START : wLen := 9; // 'S'(1) + Address(4) + Size(4)
    DefPG.PGSPI_DOWNLOAD_END   : wLen := 5; // 'E'(1) + Checksum(4)
    else Exit;
  end;
  //
  SetLength(TxBuf, wLen);
  case wMode of
    DefPG.PGSPI_DOWNLOAD_START : begin
      TxBuf[0] := Byte('S'); // ASCII: 'S'($53)
      case Common.SystemInfo.SPI_TYPE of
        DefPG.SPI_TYPE_DJ023_SPI : begin
          dwAddrChksum := nAddrChksum;        //DJ023: Little-Edian
          dwSize       := nSize;              //DJ023: Little-Edian
        end;
        else begin  //DJ021|DJ201
          dwAddrChksum := htonl(nAddrChksum); //DJ021|DJ201: Big-Edian
          dwSize       := htonl(nSize);       //DJ021|DJ201: Big-Edian
        end;
      end;
      CopyMemory(@TxBuf[1], @dwAddrChksum, 4);
      CopyMemory(@TxBuf[5], @dwSize, 4);
    end;
    DefPG.PGSPI_DOWNLOAD_END : begin
      TxBuf[0] := Byte('E'); // ASCII: 'E'($45)
      case Common.SystemInfo.SPI_TYPE of
        DefPG.SPI_TYPE_DJ023_SPI : begin
          dwAddrChksum := nAddrChksum;        //DJ023: Little-Edian
        end;
        else begin  //DJ021|DJ201
          dwAddrChksum := htonl(nAddrChksum); //DJ021|DJ201: Big-Edian
        end;
      end;
      CopyMemory(@TxBuf[1], @dwAddrChksum, 4);
    end;
  end;
  SendSpiData(wSigId,wLen, TxBuf);
end;

function TDongaPG.SendSpiFlashWrite_Data(wLen: Integer; TxBuf: TIdBytes): DWORD; //TBD:MERGE? FoldFI(#SendQspiDataDown_Data) #POCB(SendQSPIWriteDataReq)
begin
  case Common.SystemInfo.SPI_TYPE of
    DefPG.SPI_TYPE_DJ023_SPI : begin
      SendSpiData(0{wSigId},wLen,TxBuf, True{bDataBlock});
      Result := WAIT_OBJECT_0;
    end;
    else begin  //DJ021|DJ201
      Result := CheckSpiCmdAck(procedure begin SendSpiData(0{wSigId},wLen,TxBuf,True{bDataBlock}); end, DefPG.SIG_SPI_FLASH_WRITE_REQ, 1000{nWaitMS},0{nRetry});  //No Retry !!!
    end;
  end;
end;

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|DJ023) SIG_SPI_FLASH_READ_REQ
// 		- function TDongaPG.SendSpiFlashRead(nReadType: TFlashReadType; nAddress, nSize: UInt32; nWaitMS: Integer): DWORD;
//		- procedure TDongaPG.SendSpiFlashReadReq(nAddress, nSize: UInt32);
//
function TDongaPG.SendSpiFlashRead(nReadType: TFlashReadType; nAddress, nSize: UInt32; nWaitMS: Integer): DWORD;
var
  dwRtn : DWORD;
  sFunc, sDebug : string;
begin
  sFunc := Format('SendSpiFlashRead(ReadType=%d,Addr=0x%0.4x,Len=%d) ',[Ord(nReadType),nAddress,nSize]); //TBD:MERGE?
{$IFDEF DEBUG}
  CodeSite.Send(sFunc);
{$ENDIF}

  // Pre-setting for Flash Read //TBD:MERGE? DJ021_SPI|FoldPOCB(O) else(X)
  m_FlashRead.ReadType       := nReadType;
  m_FlashRead.ReadSize       := nSize;
  m_FlashRead.RxSize         := 0;
//m_FlashRead.RxData         :=
  m_FlashRead.ChecksumRx     := 0;
  m_FlashRead.ChecksumCalc   := 0;
  m_FlashRead.bReadDone      := False;
  m_FlashRead.SaveFilePath   := '';
  m_FlashRead.SaveFileName   := '';

  dwRtn := CheckSpiCmdAck(procedure begin SendSpiFlashReadReq(nAddress, nSize); end, DefPG.SIG_SPI_FLASH_READ_REQ, nWaitMS,1{nRetry}); //TBD:MERGE? nRetry?(1? 2?)

  // Post-setting for Flash Read //TBD:MERGE? DJ021_SPI|FoldPOCB(O) else(X)
  m_FlashRead.ReadType       := flashReadNone;
  m_FlashRead.bReadDone      := True;

  if dwRtn = WAIT_OBJECT_0 then begin
	  if Common.SystemInfo.SPI_TYPE = DefPG.SPI_TYPE_DJ023_SPI then begin
	    CopyMemory(@m_FlashRead.ChecksumRx,@FRxDataSpi.Data[0],4);
	    if m_FlashRead.RxSize > 0 then
	      Common.CalcCheckSum(@m_FlashRead.RxData[0],m_FlashRead.RxSize,m_FlashRead.ChecksumCalc);
	    if m_FlashRead.ReadSize <> m_FlashRead.RxSize then begin
	      sDebug := Format('...NG(ReadSize:%d <> RxSize:%d)',[m_FlashRead.ReadSize,m_FlashRead.RxSize]);
{$IFDEF DEBUG}
      CodeSite.Send(sFunc+sDebug);
{$ENDIF}
	      dwRtn := WAIT_FAILED;
	    end
	    else if (m_FlashRead.ChecksumRx and $FF) <> (m_FlashRead.ChecksumCalc and $FF) then begin  //TBD:FLASH_CHECKSUM(2021-02-22 PG->PC: valid only the lowest byte)
	      sDebug := Format('...NG(ChksumRx:0x%0.2x <> ChksumCalc:0x%0.2x)',[(m_FlashRead.ChecksumRx and $FF),(m_FlashRead.ChecksumCalc and $FF)]);
{$IFDEF DEBUG}
	      CodeSite.Send(sFunc+sDebug);
{$ENDIF}
	      dwRtn := WAIT_FAILED;
	    end;
		end;
  end;
  Result := dwRtn;
end;

procedure TDongaPG.SendSpiFlashReadReq(nAddress, nSize: UInt32); //TBD:MERGE? FoldFI(O) FoldPOCB(#SendQSPIReadReq) AutoPOCB(X)
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
  dwAddr, dwSize : UInt32;
begin
  wSigId := DefPG.SIG_SPI_FLASH_READ_REQ;
  wLen   := 8;
  //
  SetLength(TxBuf, wLen);
  case Common.SystemInfo.SPI_TYPE of
    DefPG.SPI_TYPE_DJ023_SPI : begin
      dwAddr := nAddress;        //DJ023: Little-Edian
      dwSize := nSize;           //DJ023: Little-Edian
    end;
    else begin  //DJ021|DJ201
      dwAddr := htonl(nAddress); //DJ021:DJ201: Big-Edian
      dwSize := nSize;           //DJ021|DJ201: Little-Edian
    end;
  end;
	
  SetLength(TxBuf, wLen);
  case Common.SystemInfo.SPI_TYPE of
    DefPG.SPI_TYPE_DJ023_SPI : begin
		  CopyMemory(@TxBuf[0], @dwAddr, 4);
		  CopyMemory(@TxBuf[4], @dwSize, 4);
    end;
    else begin  //DJ021|DJ201
		//dwAddr := htonl(nAddress);           //Big-Edian
		//CopyMemory(@TxBuf[4], @dwAddr, 4);   //Big-Edian
		  TxBuf[0] := Byte(nAddress shr 24) and $ff;
		  TxBuf[1] := Byte(nAddress shr 16) and $ff;
		  TxBuf[2] := Byte(nAddress shr  8) and $ff;
		  TxBuf[3] := Byte(nAddress shr  0) and $ff;
		  CopyMemory(@TxBuf[4], @dwSize, 4); //Little-Edian
    end;
  end;
  SendSpiData(wSigId,wLen, TxBuf);
end;

//------------------------------------------------------------------------------
// SPI(-----|-----|DJ023) SIG_DJ023_FLASH_INIT_REQ
//		- function TDongaPG.SendSpiFlashInit: DWORD;
//		- procedure TDongaPG.SendSpiFlashInitReq;
//
//{$IFDEF USE_DJ023_SPI}
function TDongaPG.SendSpiFlashInit: DWORD;
begin
  Result := CheckSpiCmdAck(procedure begin SendSpiFlashInitReq; end, SIG_DJ023_FLASH_INIT_REQ, 3000{nWaitMS},1{nRetry});
end;

procedure TDongaPG.SendSpiFlashInitReq;
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
begin
	wSigid := SIG_DJ023_FLASH_INIT_REQ;
	wLen := 0;
  //
	SetLength(TxBuf, wLen);
  SendSpiData(wSigId,wLen, TxBuf);
end;
//{$ENDIF} //DJ023

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|-----) SIG_DJ021_DIMMING_REQ
//		- function TDongaPG.SendSpiDimming(nDim: Integer): DWORD;
//		- procedure TDongaPG.SendSpiDimmingReq(nDim: Integer);
//
//{$IF Defined(USE_DJ021_QSPI) or Defined(USE_DJ201_QSPI)
function TDongaPG.SendSpiDimming(nDim: Integer): DWORD; //Fold(I2C_PWM)
begin
  Result := CheckSpiCmdAck(procedure begin SendSpiDimmingReq(nDim); end, DefPG.SIG_DJ021_DIMMING_REQ, 4000,1{nRetry}); //TBD:MERGE? (nRetry: 1? 2?)
end;

procedure TDongaPG.SendSpiDimmingReq(nDim: Integer);
var
  TxBuf : TIdBytes;
  wSigId, wLen, wDim : Word;
begin
  wSigId := DefPG.SIG_DJ021_DIMMING_REQ;
  wLen   := 2;
  //
  SetLength(TxBuf, wLen);
  wDim := htons(word(nDim));  // Big-Edian
  CopyMemory(@TxBuf[0], @wDim, 2);
  SendSpiData(wSigId,wLen, TxBuf);
end;
//{$ENDIF} //DJ021|DJ201

//------------------------------------------------------------------------------
// SPI(-----|-----|DJ023) SIG_DJ023_SIG_SOURCE_SEL_REQ
// SPI(-----|-----|DJ023) SIG_DJ023_SIG_ON_OFF_REQ
//		- function TDongaPG.SendSpiSigOnOff(nMode: Integer): DWORD;
//		- procedure TDongaPG.SendSpiSigOnOffReq(nMode: Integer);
//
//{$IFDEF USE_DJ023_SPI}
function TDongaPG.SendSpiSigOnOff(nMode: Integer): DWORD;	//DJ023 #SendSigSourceSel
begin
  Result := CheckSpiCmdAck(procedure begin SendSpiSigOnOffReq(nMode); end, DefPG.SIG_DJ023_SIG_ON_OFF_REQ, 3000{nWaitMS},1{nRetry});
end;

procedure TDongaPG.SendSpiSigOnOffReq(nMode: Integer);	//#SendSSSReq 
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
begin
	wSigId := SIG_DJ023_SIG_ON_OFF_REQ;
	wLen   := 1;
  //
	SetLength(TxBuf, wLen);
  TxBuf[0] := Byte(nMode);
  SendSpiData(wSigId,wLen, TxBuf);
end;
//{$ENDIF} //DJ023

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|-----) SIG_DJ021_NG_STATUS_REQ
// SPI(DJ021|DJ201|-----) SIG_DJ021_POWER_ON_AUTO_REQ
// SPI(DJ021|DJ201|-----) SIG_DJ021_POWER_ON_REQ
// SPI(DJ021|DJ201|-----) SIG_DJ021_POWER_OFF_REQ
//		- function TDongaPG.SendSpiPowerOnOff(nMode: Integer; nWaitMS: Integer; nRetry: Integer=0): DWORD;
//		- procedure TDongaPG.SendSpiPowerOnOffReq(nMode: Integer);
//
//{$IF Defined(USE_DJ021_QSPI) or Defined(USE_DJ201_QSPI)}
function TDongaPG.SendSpiPowerOnOff(nMode: Integer; nWaitMS: Integer; nRetry: Integer=0): DWORD; //TBD:MERGE? nWaitMS/nRetry?
var
  wSigId : Word;
begin
  Result := WAIT_FAILED;
  case nMode of
    0 :  wSigId := DefPG.SIG_DJ021_POWER_OFF_REQ;
    1 :  wSigId := DefPG.SIG_DJ021_POWER_ON_REQ;
  //2 :  wSigId := DefPG.SIG_DJ021_POWER_ON_AUTO_REQ; //TBD:MERGE? NOT-USED?
    else Exit;
  end;	
  {$IFDEF TBD_PGSPI} //TBD:MERGE?
  if (PG_TYPE <> PG_NONE) and (DefPG.PGSPI_MAIN = DefPG.PGSPI_MAIN_QSPI) begin //PG+SPI & PGSPI_MAIN_QSPI
	  case nMode of
   		0 : begin  //OFF
	      Result := CheckPgCmdAck(procedure begin SendPgPowerReq(nMode);end, DefPG.SIG_PG_PWR_OFF, nWaitMS,nRetry); // PG OFF
	      if Result = WAIT_OBJECT_0 then begin
	        dwRtn := CheckSpiCmdAck(procedure begin SendSpiPowerOnOffReq(nMode);end, wSigId, nWaitMS,nRetry);  // SPI OFF
	      end
	      else begin
	        CheckSpiCmdAck(procedure begin SendSpiPowerReq(nMode);end, wSigId, nWaitMS,nRetry);  // SPI OFF
	      end;
	    end;
	    1 : begin  //ON
   		  Result := CheckSpiCmdAck(procedure begin SendSpiPowerOnOffReq(nMode);end, wSigId, nWaitMS,nRetry);    // SPI ON
	      if Result = WAIT_OBJECT_0 then begin
	        Result := CheckPgCmdAck(procedure begin SendPgPowerReq(nMode);end, DefPG.SIG_PG_PWR_ON, nWaitMS,nRetry);  // PG ON
	      end;
	    end;
	  end;
  end
  else begin //SPI-Only or PGSPI_MAIN_PG
    Result := CheckSpiCmdAck(procedure begin SendSpiPowerOnOffReq(nMode); end, wSigId, nWaitMS,nRetry); // SPI ON/OFF
  end;
  {$ELSE}
  Result := CheckSpiCmdAck(procedure begin SendSpiPowerOnOffReq(nMode); end, wSigId, nWaitMS,nRetry); // SPI ON/OFF

  //DJ021|DJ201 (EEPROM WP Disable when Power On)
  if Common.SystemInfo.SPI_TYPE <> SPI_TYPE_DJ023_SPI then begin
    if nMode = 1 then begin  //Power ON
      Sleep(200);
      SendSpiEepromWp(0,1000{nWaitMS});  //EEPROM WP Disable
      Sleep(10);
    end;
  end;
  {$ENDIF}
end;

procedure TDongaPG.SendSpiPowerOnOffReq(nMode: Integer); //#SendSpiPowerReq
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
begin
  wSigId := DefPG.SIG_DJ021_POWER_ON_REQ;
  wLen   := 0;
  //
  SetLength(TxBuf, wLen);
  case nMode of
    0 : wSigId := DefPG.SIG_DJ021_POWER_OFF_REQ;
    1 : wSigId := DefPG.SIG_DJ021_POWER_ON_REQ;
    2 : wSigId := DefPG.SIG_DJ021_POWER_ON_AUTO_REQ;
  end;
  SendSpiData(wSigId,wLen, TxBuf);
end;
//{$ENDIF} //DJ021|DJ201

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|-----) SIG_DJ021_READ_POWER_REQ
//		- function TDongaPG.SendSpiPowerMeasure: DWORD;
//		- procedure TDongaPG.SendSpiPowerMeasureReq;
//
//{$IF Defined(USE_DJ021_QSPI) or Defined(USE_DJ201_QSPI)}
function TDongaPG.SendSpiPowerMeasure: DWORD;
begin
  Result := CheckSpiPwrCmdAck(SendSpiPowerMeasureReq, DefPG.SIG_DJ021_READ_POWER_REQ, 3000, 0);
end;

procedure TDongaPG.SendSpiPowerMeasureReq;
var
  TxBuf : TIdBytes;
  wLen, wSigId : Word;
begin
  wSigId := DefPG.SIG_DJ021_READ_POWER_REQ;
  wLen   := 1;
  //
	SetLength(TxBuf, wLen);
  TxBuf[0] := Byte(0);
  SendSpiData(wSigId,wLen, TxBuf);
end;
//{$ENDIF} //DJ021|DJ201

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|-----) SIG_DJ021_POWER_OFFSET_W_REQ
//		- function TDongaPG.SendSpiPowerOffsetWrite(nVcc, nVel, nIcc, nIel: Integer): DWORD;
//		- procedure TDongaPG.SendSpiPowerOffsetWriteReq(nVcc, nVel, nIcc, nIel: Integer);
//
//{$IF Defined(USE_DJ021_QSPI) or Defined(USE_DJ201_QSPI)}
function TDongaPG.SendSpiPowerOffsetWrite(nVcc, nVel, nIcc, nIel: Integer): DWORD; //FoldGB(#SendSpiPowerCal)
begin
  Result := CheckSpiCmdAck(procedure begin SendSpiPowerOffsetWriteReq(nVcc, nVel, nIcc, nIel); end, DefPG.SIG_DJ021_POWER_OFFSET_W_REQ, 30000{nWaitMS},0{nRetry});
end;

procedure TDongaPG.SendSpiPowerOffsetWriteReq(nVcc, nVel, nIcc, nIel: Integer); //FoldGB(#SendSpiPowerCalReq)
var
  TxBuf : TIdBytes;
  wLen, wSigId : Word;
begin
  wSigId := DefPG.SIG_DJ021_POWER_OFFSET_W_REQ;
  wLen   := 8;
  //
  SetLength(TxBuf, wLen);
  // Vcc
  if 0 > nVcc then TxBuf[0] := ord('-') else TxBuf[0] := ord('+');
  TxBuf[1] := Abs(nVcc) and $FF;
  // Icc
  if 0 > nIcc then TxBuf[2] := ord('-') else TxBuf[2] := ord('+');
  TxBuf[3] := Abs(nIcc) and $FF;
  // Vel
  if 0 > nVel then TxBuf[4] := ord('-') else TxBuf[4] := ord('+');
  TxBuf[5] := Abs(nVel) and $FF;
  // nIel
  if 0 > nIel then TxBuf[6] := ord('-') else TxBuf[6] := ord('+');
  TxBuf[7] := Abs(nIel) and $FF;
  SendSpiData(wSigId,wLen, TxBuf);
end;
//{$ENDIF} //DJ021|DJ201

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|-----) SIG_DJ021_POWER_OFFSET_R_REQ
//		- function TDongaPG.SendSpiPowerOffsetRead: DWORD;
//		- procedure TDongaPG.SendSpiPowerOffsetReadReq;
//
//{$IF Defined(USE_DJ021_QSPI) or Defined(USE_DJ201_QSPI)}
function TDongaPG.SendSpiPowerOffsetRead: DWORD;
begin
  Result := CheckSpiCmdAck(procedure begin SendSpiPowerOffsetReadReq; end, DefPG.SIG_DJ021_POWER_OFFSET_R_REQ, 30000{nWaitMS},0{nRetry});
end;

procedure TDongaPG.SendSpiPowerOffsetReadReq;
var
  TxBuf : TIdBytes;
  wLen, wSigId : Word;
begin
  wSigId := DefPG.SIG_DJ021_POWER_OFFSET_R_REQ;
  wLen   := 0;
  //
  SetLength(TxBuf, wLen);
  SendSpiData(wSigId,wLen, TxBuf);
end;
//{$ENDIF} //DJ021|DJ201

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|DJ023) SIG_SPI_RESET_REQ
//		- function TDongaPG.SendSpiReset: DWORD;
//		- procedure TDongaPG.SendSpiResetReq;
//
function TDongaPG.SendSpiReset: DWORD;
begin
  Result := CheckSpiCmdAck(SendSpiResetReq, DefPG.SIG_SPI_RESET_REQ, 3000{nWaitMS},1{nRetry});
end;

procedure TDongaPG.SendSpiResetReq;
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
begin
  wSigId := DefPG.SIG_SPI_RESET_REQ;
  wLen   := 0;
  //
  SetLength(TxBuf, wLen);
  SendSpiData(wSigId,wLen, TxBuf);
end;

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|DJ023) SIG_SPI_CONNECTION_REQ
//

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|-----) SIG_DJ021_UPLOAD_START_REQ
//		- function TDongaPG.SendSpiDataUpload_Start: DWORD;
//		- procedure TDongaPG.SendSpiDataUpload_StartReq;
// SPI(DJ021|DJ201|-----) SIG_DJ021_UPLOAD_DATA_REQ
//		- function TDongaPG.SendSpiDataUpload_Data(nAddrOffset: UInt32; wPacketNo, wBuffSize: Word): DWORD;
//		- procedure TDongaPG.SendSpiDataUpload_DataReq(nAddrOffset: UInt32; wPacketNo, wBuffSize: Word);
//
//{$IF Defined(USE_DJ021_QSPI) or Defined(USE_DJ201_QSPI)}
function TDongaPG.SendSpiDataUpload_Start: DWORD;
begin
  Result := CheckSpiCmdAck(SendSpiDataUpload_StartReq, DefPG.SIG_DJ021_UPLOAD_START_REQ, 3000{nWaitMS},1{nRetry}); //TBD:MERGE? (nRetry: 1? 10?)
end;

procedure TDongaPG.SendSpiDataUpload_StartReq; //TBD:MERGE? //#SendQspiDataUp_StartReq
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
begin
  wSigId := DefPG.SIG_DJ021_UPLOAD_START_REQ;
  wLen   := 0;
  //
  SetLength(TxBuf, wLen);
  SendSpiData(wSigId,wLen, TxBuf);
end;

function TDongaPG.SendSpiDataUpload_Data(nAddrOffset: UInt32; wPacketNo, wBuffSize: Word): DWORD;
begin
  Result := CheckSpiCmdAck(procedure begin SendSpiDataUpload_DataReq(nAddrOffset ,wPacketNo,wBuffSize); end, DefPG.SIG_DJ021_UPLOAD_DATA_REQ, 3000{nWaitMS},0{nRetry}); //TBD:MERGE? nWaitMS/nRetry?
end;

procedure TDongaPG.SendSpiDataUpload_DataReq(nAddrOffset: UInt32; wPacketNo, wBuffSize: Word);
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
  dwAddr : UInt32;
begin
  wSigId := DefPG.SIG_DJ021_UPLOAD_DATA_REQ;
  wLen   := 8;
  SetLength(TxBuf, wLen);
  //
  dwAddr := htonl(nAddrOffset);         //DataIdx: Big-Edian
  CopyMemory(@TxBuf[0], @dwAddr, 4);    
  TxBuf[4] := (wPacketNo shr 8);        //PacketNo: Big-Edian
  TxBuf[5] := (wPacketNo and $ff);      
  CopyMemory(@TxBuf[6], @wBuffSize, 2); //Size: Little-Edian
  SendSpiData(wSigId,wLen, TxBuf, False{bIsData});
end;
//{$ENDIF} //DJ021|DJ201

function TDongaPG.SendSpiFlashDataUploadFlow(nFlashAddr, nDataLen, nWaitSec: integer): DWORD;
const
  QSPI_UPDATA_PKTSIZE = 1024;
var
  dwRet, dwRxDataLen, dwRxChkSum, dwCrcCalc, dwDataIdx : DWORD;
  wRxPacketNo, wCrc16: Word;
  nDiv, nMod, i, j : Integer;
  sTemp: AnsiString;
  //
  nCrcPG, nCrcCalc : Integer;
begin
  try
    dwRet := WAIT_FAILED;
    nCrcPG   := 0;
    nCrcCalc := 0;
    //------------------------------------------------------
    // Start.
    dwRet := SendSpiDataUpload_Start;
    if dwRet <> WAIT_OBJECT_0 then Exit(dwRet);
    if FRxDataSpi.DataLen < 8 then Exit(dwRet);
    //------------------------------------------------------
    CopyMemory(@dwRxDataLen, @FRxDataSpi.Data[0], 4);
    CopyMemory(@dwRxChkSum,@FRxDataSpi.Data[4], 4);
    //------------------------------------------------------
    nDiv := nDataLen div QSPI_UPDATA_PKTSIZE;
    nMod := nDataLen Mod QSPI_UPDATA_PKTSIZE;
    for i := 0 to Pred(nDiv) do begin
      dwDataIdx := i * QSPI_UPDATA_PKTSIZE;
      dwRet     := SendSpiDataUpload_Data(dwDataIdx, i{wPacketNo}, QSPI_UPDATA_PKTSIZE);
      if dwRet <> WAIT_OBJECT_0 then begin
        Exit(dwRet);
      end;
      wRxPacketNo := Word((FRxDataSpi.Data[0] shl 8) or FRxDataSpi.Data[1]); //Big-Edian
      if i <> wRxPacketNo then begin
        Exit(WAIT_FAILED);
      end;
      if FRxDataSpi.DataLen < QSPI_UPDATA_PKTSIZE then begin
        Exit(WAIT_FAILED);
      end;
      for j := 0 to (QSPI_UPDATA_PKTSIZE-1) do
        m_FlashRead.RxData[dwDataIdx+j] := FRxDataSpi.Data[2+j];
      Sleep(10); //2023-10-18 T/T (10->10) //TBD?
    end;
    if nMod <> 0 then begin
      dwDataIdx := nDiv * QSPI_UPDATA_PKTSIZE;
      dwRet     := SendSpiDataUpload_Data(dwDataIdx, nDiv{wPacketno}, nMod);
      if dwRet <> WAIT_OBJECT_0 then begin
        Exit(dwRet);
      end;
      for j := 0 to (nMod-1) do
        m_FlashRead.RxData[dwDataIdx+j] := FRxDataSpi.Data[2+j];  //IMD_GB_PG: 0->2 !!! Need to change !!!
    end;
    //------------------------------------------------------ TBD:QSPI? Checksum?
  //TBD:QSPI? IMSI-DELETE? SetString(sTemp, PAnsiChar(@FlashDataBuf.Data[0]), dwRxDataLen);
  //TBD:QSPI? IMSI-DELETE? dwCrcCalc := Common.crc16(sTemp, dwRxDataLen);
    dwCrcCalc := dwRxChkSum; //TBD:QSPI? IMSI-INSERT
    nCrcPG   := dwRxChkSum;
{$IFDEF SIMULATOR_PANEL}
//  nCrcPG   := dwCrcCalc;
{$ENDIF}
  finally
    Result := dwRet;
  end;
end;

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|-----) SIG_DJ021_PWR_AUTOCAL_MODE_REQ
//		- function TDongaPG.SendSpiPwrAutoCalMode(nCh: Integer): DWORD; 
//		- procedure TDongaPG.SendSpiPwrAutoCalModeReq;
// SPI(DJ021|DJ201|-----) SIG_DJ021_PWR_AUTOCAL_DATA_REQ
//		- function TDongaPG.SendSpiPwrAutoCalData: DWORD;
//		- procedure TDongaPG.SendSpiPwrAutoCalDataReq;
//
//{$IF Defined(USE_DJ021_QSPI) or Defined(USE_DJ201_QSPI)}
function TDongaPG.SendSpiPwrAutoCalMode(nCh : Integer): DWORD; //#SendSpiPwrAutoCalStart
var
  sDebug : string;
begin
  SetCyclicTimerSpi(False{bEnable},300); //300 sec
  //  
  Result := CheckSpiCmdAck(SendSpiPwrAutoCalModeReq, DefPG.SIG_DJ021_PWR_AUTOCAL_MODE_REQ, 180000{nWaitMS},0{nRetry}); //TBD:MERGE? nWaitMS/nRetry
  if Pg[nCh].m_PwrCalInfoSpi.Result = 'OK' then begin
    Common.MLog(nCh,'Auto Cal : OK');
  end
  else begin
    sDebug := 'Auto Cal : NG (' + Pg[nCh].m_PwrCalInfoSpi.Log + ')';
    Common.MLog(nCh,sDebug);
  end;
  //
  SetCyclicTimerSpi(True{bEnable});
end;

procedure TDongaPG.SendSpiPwrAutoCalModeReq; //#SendSpiPowerAutoCalReq //TBD:MERGE?
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
begin
  wSigId := DefPG.SIG_DJ021_PWR_AUTOCAL_MODE_REQ;
  wLen   := 0;
  //
  SetLength(TxBuf, wLen);
  SendSpiData(wSigId,wLen, TxBuf);
end;

function TDongaPG.SendSpiPwrAutoCalData: DWORD; //#SendSpiPwrAutoCalDataLoading //TBD:MERGE?
var
  sDebug : string;
begin
  SetCyclicTimerSpi(False{bEnable},300); //300 sec
  //
  Result := CheckSpiCmdAck(SendSpiPwrAutoCalDataReq, DefPG.SIG_DJ021_PWR_AUTOCAL_DATA_REQ, 180000{nWaitMS},0{nRetry});
  if Result = WAIT_OBJECT_0 then begin
    Common.MLog(Self.m_nPgNo,'Auto Cal DATA Loading : OK');
    Common.MLog(Self.m_nPgNo,m_PwrCalInfoSpi.VCC);
    Common.MLog(Self.m_nPgNo,m_PwrCalInfoSpi.ICC);
    Common.MLog(Self.m_nPgNo,m_PwrCalInfoSpi.VDD);
    Common.MLog(Self.m_nPgNo,m_PwrCalInfoSpi.IDD);
  end
  else begin
    sDebug := 'Auto Cal DATA Loading : NG ';
    if Result = WAIT_FAILED then sDebug := sDebug + '(NAK)'
    else                         sDebug := sDebug + '(No Response)';
    Common.MLog(Self.m_nPgNo,sDebug);
  end;
  //
  SetCyclicTimerSpi(True{bEnable});
end;

procedure TDongaPG.SendSpiPwrAutoCalDataReq; //#SendSpiPowerAutoCalDataLoadingReq //TBD:MERGE?
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
begin
  wSigId := DefPG.SIG_DJ021_PWR_AUTOCAL_DATA_REQ;
  wLen   := 0;
  //
  SetLength(TxBuf, wLen);
  SendSpiData(wSigId,wLen, TxBuf);
end;
//{$ENDIF} //DJ021|DJ201

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|DJ023) SIG_SPI_FW_VER_REQ
//		- //procedure TDongaPG.SendSpiFwVer;
//		- procedure TDongaPG.SendSpiFwVerReq;
//
//procedure TDongaPG.SendSpiFwVer;
//var
//  dwRtn : DWORD;
//begin
//  m_bFwVerReqSpi := True;
//  dwRtn := CheckSpiCmdAck(SendSpiFwVerReq, DefPG.SIG_SPI_FW_VER_REQ, 1000{nWaitMS},0{nRetry}); // No Retry !!! //TBD:MERGE? (nRetry?)
//  m_bFwVerReqSpi := False;
//end;

procedure TDongaPG.SendSpiFwVerReq;
var
  TxBuf : TIdBytes;
  wSigId, wLen : Word;
begin
  wSigId := DefPG.SIG_SPI_FW_VER_REQ;
  wLen   := 0;
  //
  SetLength(TxBuf, wLen);
  SendSpiData(wSigId,wLen, TxBuf);
end;

//------------------------------------------------------------------------------
// SPI(DJ021|DJ201|-----) SIG_SPI_FW_DOWN_REQ
//		- procedure TDongaPG.SendSpiFwDownFlow(nType: Integer; const transData: TFileTranStr);
//		- procedure TDongaPG.SendSpiFwDownReq(nType: Integer; cMode: AnsiChar; nFileSize: integer); 
//
//{$IF Defined(USE_DJ021_QSPI) or Defined(USE_DJ201_QSPI)}
procedure TDongaPG.SendSpiFwDownFlow(nType : Integer; const transData: TFileTranStr); //#SendSpiTransData //TBD:MERGE?
var
  TxBuff                            : TIdBytes;
  wSigId  : Word;
  nTotalCnt, nCurPos                : Integer;
  cdCheckSum : LongWord;
  wRet                              : DWORD;
  sDebug                            : string;
  i, j, nFileSize, nTransType       : Integer;
  nDiv, nMod : Integer;
  sDownType  : string;
begin
	try
    SetCyclicTimerSpi(False{bEnable});

  	if nType = DefPG.SPISIG_FWDOWN_TYPE_FW then sDownType := 'FW' else sDownType := 'BOOT';

    SetLength(TxBuff, DefPG.PGSPI_PACKET_SIZE);

    nTotalCnt := 0;
    nCurPos   := 0;

    cdCheckSum := transData.CheckSum;
    nFileSize := transData.TotalSize;
    nTotalCnt := nTotalCnt + 4; // boot + PG Reset + Start + End.
    nDiv := nFileSize div DefPG.PGSPI_PACKET_SIZE;
    nMod := nFileSize mod DefPG.PGSPI_PACKET_SIZE;
    if nMod = 0 then nTotalCnt := nTotalCnt + nDiv
    else             nTotalCnt := nTotalCnt + nDiv + 1;

    if nType <> DefPG.SPISIG_FWDOWN_TYPE_BOOT then begin  // 0:FW, 1:BOOT
      ShowSpiDownLoadStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS,nCurPos,nTotalCnt,'SPI BOOT Start!');

      wSigId := DefPG.SIG_SPI_FW_DOWN_REQ;
      wRet := CheckSpiCmdAck(procedure begin SendSpiFwDownReq(nType,'B',nFileSize); end, DefPG.SIG_SPI_FW_DOWN_REQ, 5000{nWaitMS},0{nRetry}); //TBD:MERGE? (nRetry: 0? 1?)
      if wRet <> WAIT_OBJECT_0 then begin
        ShowSpiDownLoadStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS,nCurPos,nTotalCnt,'Download SPI BOOT Start NG', True);
        Exit;
      end;
      Inc(nCurPos);
      ShowSpiDownLoadStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS,nCurPos,nTotalCnt,'SPI Reset!');
      Sleep(6000); // Wait PG Reboot after download
      Inc(nCurPos);
    end
    else begin
      nTotalCnt := nTotalCnt - 2;  // boot + PG Reset + Start + End - boot - PG Reset.
    end;

    sDebug := 'SPI '+sDownType+' Download Start';
    ShowSpiDownLoadStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nCurPos, nTotalCnt, sDebug);

    wSigID := DefPG.SIG_SPI_FW_DOWN_REQ;
    wRet := CheckSpiCmdAck(procedure begin SendSpiFwDownReq(nType,'S',nFileSize); end, wSigId, 5000{nWaitMS},0{nRetry}); //TBD:MERGE? nRetry?
    if wRet <> WAIT_OBJECT_0 then begin
      sDebug := 'SPI '+sDownType+' Download Start NG';
      ShowSpiDownLoadStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nCurPos, nTotalCnt, sDebug, True);
      Exit;
    end;
    Sleep(2000);

    //
    for i := 0 to Pred(nDiv) do begin
      CopyMemory(@TxBuff[0],@transData.Data[i*DefPG.PGSPI_PACKET_SIZE],DefPG.PGSPI_PACKET_SIZE);
      SendSpiData(0{wSigId},0{wLen},TxBuff,True{bIsData});
      Sleep(50);
      Inc(nCurPos);
      sDebug := 'SPI '+sDownType+' File Downloading';
      ShowSpiDownLoadStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nCurPos, nTotalCnt, sDebug);
    end;
    if nMod <> 0 then begin
      CopyMemory(@TxBuff[0],@transData.Data[DefPG.PGSPI_PACKET_SIZE*nDiv],nMod);
      for i := nMod to Pred(DefPG.PGSPI_PACKET_SIZE) do TxBuff[i] := 0;  //2021-08-23
      SendSpiData(0{wSigId},0{wLen},TxBuff,True{bIsData});
      Sleep(50);
      Inc(nCurPos);
      sDebug := 'SPI '+sDownType+' File Downloading';
      ShowSpiDownLoadStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nCurPos, nTotalCnt, sDebug);
    end;

    //
    Inc(nCurPos);
    sDebug := 'SPI '+sDownType+' File Download Completed... Initializing';
    ShowSpiDownLoadStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nCurPos, nTotalCnt, sDebug);

    //
    wSigID := DefPG.SIG_SPI_FW_DOWN_REQ;
    wRet := CheckSpiCmdAck(procedure begin SendSpiFwDownReq(nType,'E',cdCheckSum); end, wSigID, 30000{nWaitMS},0{nRetry}); //TBD:MERGE? (nRetry: 0? 1?)
    if wRet <> WAIT_OBJECT_0 then begin
      sDebug := 'SPI '+sDownType+' Download End NG';
      ShowSpiDownLoadStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nCurPos, nTotalCnt, sDebug, True);
      Exit;
    end;

    Inc(nCurPos);
    sDebug := 'SPI '+sDownType+' Download OK';
    ShowSpiDownLoadStatus(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nCurPos, nTotalCnt, sDebug, True);
  finally
    SetCyclicTimerSpi(True{bEnable});
  end;
end;

procedure TDongaPG.SendSpiFwDownReq(nType: Integer; cMode : AnsiChar; nFileSize : integer); //#SendSpiFwStartReq //TBD:MERGE?
var
  TxBuf : TIdBytes;
  wSIgId, wLen : Word;
  nSize : Integer;
  btDownType : Byte;
begin
  wSigId := DefPG.SIG_SPI_FW_DOWN_REQ;
  wLen   := 6;
  //
  SetLength(TxBuf, wLen);
  btDownType := 0;
  case nType of
    0 : btDownType := 0;
    1 : btDownType := 2;
  end;
  TxBuf[0] := btDownType; 
  TxBuf[1] := ord(cMode);
  nSize := htonl(nFileSize);
  CopyMemory(@TxBuf[2], @nSize, 4);
  SendSpiData(wSigId,wLen, TxBuf);
end;
//{$ENDIF} //DJ021|DJ201

{$IFDEF TBD_QSPI}
function TDongaPG.FwBootCheckSpi: Boolean; //TBD:MERGE? FoldFI(QSPI)
var
  bRet : Boolean;
  dModel, dPg : Double;
  sDebug : string;
begin
  bRet := False;
  sDebug := '';
  dModel := StrToFloatDef(Common.TestModelInfo2[m_nPgNo].SpiFwVer,0.0);
  dPg    := StrToFloatDef(m_sFwVerSpi,0.0);
  if (dModel <= dPg) then begin
    bRet := True;
  end;
  if (dModel = 0.0) or (dPg = 0.0) then bRet := False;
  if not bRet then begin
    sDebug := Format('[PG FW] Model Info (%0.3f) >  SPI FW (%0.3f)',[dModel, dPg]);
  end;

  if bRet then begin

    dModel := StrToFloatDef(Common.TestModelInfo2[m_nPgNo].SpiBootVer,0.0);
    dPg    := StrToFloatDef(m_sBootVerSpi,0.0);
    if (dModel <= dPg) then bRet := True;
    if (dModel = 0.0) or (dPg = 0.0) then bRet := False;
    if not bRet then begin
      sDebug := Format('[PG BOOT] Model Info (%0.1f) >  SPI BOOT (%0.1f)',[dModel, dPg]);
    end;
  end;
  if not bRet then begin
    //TBD:MERGE?  ShowTestWindow(Defcommon.MSG_MODE_FW_CHECK,0,sDebug); //FoldFI(O)
  end;
  Result := bRet;
end;
{$ENDIF}


//##############################################################################
//##############################################################################
//###                                                                        ###
//###                FLOW-SPECIFIC (Flash Write - Unit)                      ###
//###                                                                        ###
//##############################################################################
//##############################################################################
{$IFDEF FEATURE_FLASH_UNIT_RW}
procedure TDongaPG.FlashClearUnitBuf(nUnitIdx: Integer = -1);
var
  i : Integer;
begin
  if nUnitIdx in [0..DefPG.FLASH_UNITDATABUF_MAX] then begin
		with m_FlashUnitBuf[nUnitIdx] do begin
    	UnitAddr     := 0;
      UnitSize     := 0;
      UnitStatus   := flashUnitEmpty;
      Checksum     := 0;
   	end;
	end
	else begin
  	for i := 0 to DefPG.FLASH_UNITDATABUF_MAX do begin
    	with m_FlashUnitBuf[i] do begin
      	UnitAddr     := 0;
      	UnitSize     := 0;
      	UnitStatus   := flashUnitEmpty;
      	Checksum     := 0;
    	end;
		end;
  end;
end;

function TDongaPG.FlashGetUnitAddr(nFlashAddr: UInt32): UInt32;
var
  nUnitAddr : UInt32;
  nUnitSize : Integer;
begin
  nUnitSize := FLASH_DATAUNIT_SIZE;  //TBD:EDNA:FLASH? (ModelInfo?)
  nUnitAddr := (nFlashAddr div nUnitSize) * nUnitSize;
  Result    := nUnitAddr;
end;

function TDongaPG.FlashGetUnitIdx(nFlashAddr, nUnitAddr: UInt32; var nUnitIdx: Integer): Boolean;
var
  i : Integer;
  sFunc : string;
begin
  sFunc := Format('FlashGetUnitIdx(nFlashAddr=0x%0.4x,nUnitAddr=0x%0.4x):(nUnitIdx=%d): ',[nFlashAddr,nUnitAddr,nUnitIdx]);
  for i := 0 to DefPG.FLASH_UNITDATABUF_MAX do begin
    if (m_FlashUnitBuf[i].UnitAddr = nUnitAddr) and (m_FlashUnitBuf[i].UnitStatus <> flashUnitEmpty) then begin
      nUnitIdx := i;
      Result   := True;
      Common.CodeSiteSend(sFunc+'FOUND');
      Exit;
    end;
  end;
  Common.CodeSiteSend(sFunc+'...NOT-FOUND');
  Result := False;
end;

function TDongaPG.FlashGetEmptyUnitIdx(var nUnitIdx: Integer): Boolean;
var
  i : Integer;
  sFunc : string;
begin
  sFunc := 'FlashGetEmptyUnitIdx: ';
  for i := 0 to DefPG.FLASH_UNITDATABUF_MAX do begin
    if (m_FlashUnitBuf[i].UnitStatus = flashUnitEmpty) then begin
      nUnitIdx := i;
      Result   := True;
      Common.CodeSiteSend(sFunc+'(UnitIdx='+IntToStr(nUnitIdx)+')');
      Exit;
    end;
  end;
  Common.CodeSiteSend(sFunc+'...FULL(');
  //
  for i := 0 to DefPG.FLASH_UNITDATABUF_MAX do begin
    if (m_FlashUnitBuf[i].UnitStatus <> flashUnitUpdated) and (m_FlashUnitBuf[i].UnitStatus <> flashUnitWriteErr) then begin
      nUnitIdx := i;
      m_FlashUnitBuf[i].UnitStatus := flashUnitEmpty;
      m_FlashUnitBuf[i].UnitAddr   := 0;
      m_FlashUnitBuf[i].UnitSize   := 0;
      m_FlashUnitBuf[i].Checksum   := 0;
      Result   := True;
      Common.CodeSiteSend(sFunc+'(UnitIdx='+IntToStr(nUnitIdx)+')');
      Exit;
    end;
  end;
  //
  Common.CodeSiteSend(sFunc+'...NG(ALL flashUnitUpdated) ...TBD(FlashCommit?)');
  Result := False;
end;

function TDongaPG.FlashReadData(nFlashAddr: UInt32; nLen: Integer; bForce: Boolean = False): DWORD;
var
  nRtn : DWORD;
  nUnitAddr : UInt32;
  nUnitIdx, nUnitSize, nUnitDataIdx : Integer;
  bNeedDeviceRead, bNeedFlashCommit : Boolean;
  nDataIdx : Integer;
  btaData  : array of Byte;
  sFunc, sTempFunc : string;
//sMLog : string;
begin
//sMLog := 'FLASH Data Read ';
  sFunc := Format('FlashReadData(FlashAddr=0x%0.4x,Len=%d,bForce=%s): ',[nFlashAddr,nLen,BoolToStr(bForce)]);
  Common.CodeSiteSend(sFunc+'##### START #####');
  //
  nDataIdx := 0;
  SetLength(btaData,nLen);
  //
  nUnitAddr := FlashGetUnitAddr(nFlashAddr);
  nUnitSize := FLASH_DATAUNIT_SIZE;
  while (nUnitAddr <= (nFlashAddr + nLen - 1)) do begin
    //
    bNeedDeviceRead  := True;
    bNeedFlashCommit := False;
    if FlashGetUnitIdx(nFlashAddr,nUnitAddr,nUnitIdx) then begin // Already in Buffer
      case m_FlashUnitBuf[nUnitIdx].UnitStatus of
        flashUnitRead : begin
          if (not bForce) then begin
            bNeedDeviceRead := False;
          end;
        end;
        flashUnitUpdated, flashUnitWriteErr : begin
          if (not bForce) then begin
            bNeedDeviceRead := False;
          end
          else begin
            sTempFunc := Format('(UnitIdx=%d,flashUnitUpdated): FlashUnitWrite-Before-Read: ',[nUnitIdx]);
            Common.CodeSiteSend(sFunc+sTempFunc);
            nRtn := FlashWriteDeviceUnit(nUnitIdx);
            if nRtn <> WAIT_OBJECT_0 then begin
              Common.CodeSiteSend(sFunc+sTempFunc+'...NG(FlashWriteErr before Read)');
             Exit(WAIT_FAILED);
             end;
          end;
        end;
      end;
    end
    else begin
      if not FlashGetEmptyUnitIdx(nUnitIdx) then begin
        Common.CodeSiteSend(sFunc+'...NG(FlashUnitBuf Full) ...TBD(Flash Commit?)');
        Exit(WAIT_FAILED);  //TBD:EDNA:FLASH? (Flash Commit?)
      end;
    end;
    //
    if bNeedDeviceRead then begin
      nRtn := FlashReadDeviceUnit(nUnitIdx,nUnitAddr,nUnitSize,1{nTryCnt});
      if nRtn <> WAIT_OBJECT_0 then begin
        Exit(nRtn); //TBD:EDNA:FLASH? (SPI READ)
      end;
    end;
    //
    if (nDataIdx = 0) then nUnitDataIdx := (nFlashAddr mod nUnitSize)  // 1st
    else                   nUnitDataIdx := 0;                          // 2nd~
    while (nDataIdx < nLen) and (nUnitDataIdx < nUnitSize) do begin
      btaData[nDataIdx] := m_FlashUnitBuf[nUnitIdx].Data[nUnitDataIdx];
    //sTempFunc := sFunc+Format('(FlashAddr=0x%0.4x,UnitIdx=%d,UnitAddr=0x%0.4x,UnitOffset=%d,Value=%0.2x)',[nFlashAddr+nDataIdx,nUnitIdx,nUnitAddr,nUnitDataIdx,btaData[nDataIdx]]);
    //Common.CodeSiteSend(sFunc+sTempFunc);
      Inc(nDataIdx);
      Inc(nUnitDataIdx);
    end;
    //
    nUnitAddr := nUnitAddr + nUnitSize;
    sleep(500); //2021-03-09 (10 -> 100)
  end;
  //
  CopyMemory(@Pg[m_nPgNo].FRxDataSpi.Data[0],@btaData[0],nLen);
  Pg[m_nPgNo].FRxDataSpi.DataLen := nLen;
  Pg[m_nPgNo].FRxDataSpi.NgOrYes := DefPG.CMD_SPI_RESULT_ACK;
  //
  Common.CodeSiteSend(sFunc+'##### END #####');
  Result := WAIT_OBJECT_0;
end;

function TDongaPG.FlashReadDeviceUnit(nUnitIdx: Integer; nUnitAddr: UInt32; nUnitSize: Integer; nTryCnt: Integer = 1): DWORD;  //TBD:EDNA:FLASH?
var
  dwRtn : DWORD;
  sFunc, sTempFunc, sMLog, sDebug, sReason : string;
  FlashAccessParam : TFlashAccessParamRec;
  nDataIdx : Integer;
begin
  sMLog := 'FLASH Data Read ';
  sFunc := Format('FlashReadDeviceUnit(nUnitIdx=%d,nUnitAddr=0x%0.4x,nUnitSize=%d,nTryCnt=%d): ',[nUnitIdx,nUnitAddr,nUnitSize,nTryCnt]);
  Common.CodeSiteSend(sFunc+'...START');

  try
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    SetCyclicTimerSpi(False{bEnable});

    //---------------------------------- Get Flash Access Info
    FlashAccessParam := Common.TestModelInfo2[m_nPgNo].FlashAccessParam;

    //---------------------------------- Ext_Flash_Access(0x0020) - Enable
    sFunc  := 'ExtFlashAccess(Enable)';
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

    Sleep(FlashAccessParam.AccEnableBeforeDelayMsec);
    dwRtn := SendSpiFlashAccess(1{nMode:0=Disable,1=Enable});
    if (dwRtn <> WAIT_OBJECT_0) then begin
      Sleep(100);
      dwRtn := SendSpiFlashAccess(1{nMode:0=Disable,1=Enable});
      if (dwRtn <> WAIT_OBJECT_0) then begin
        if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
        sDebug := sMLog+sFunc+' ...NG('+sReason+')';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
        Exit(dwRtn);
      end;
    end;
    Sleep(FlashAccessParam.AccEnableAfterDelayMsec);

    //---------------------------------- Ext_Flash_Init(0x0032) //DJ023_SPI
    if Common.SystemInfo.SPI_TYPE = SPI_TYPE_DJ023_SPI then begin
      sFunc  := 'ExtFlashInit';
      sDebug := sMLog+sFunc;
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      Sleep(FlashAccessParam.InitBeforeDelayMsec);
      dwRtn := SendSpiFlashInit;
      if (dwRtn <> WAIT_OBJECT_0) then begin
        Sleep(100);
        dwRtn := SendSpiFlashInit;
        if (dwRtn <> WAIT_OBJECT_0) then begin
          if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
          sDebug := sMLog+sFunc+' ...NG('+sReason+')';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          Exit(dwRtn);
        end;
      end;
      Sleep(FlashAccessParam.InitAfterDelayMsec);
    end;

    //---------------------------------- Flash Read
    if Common.SystemInfo.SPI_TYPE = SPI_TYPE_DJ023_SPI then begin
      sDebug := Format('Flash Data Read(DJ023): StartAddr(%d) Len(%d) ...TBD',[nUnitAddr,nUnitSize]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      dwRtn := WAIT_FAILED; //TBD:DJ023:FLASH_READ?
      Exit(dwRtn);
    end
    else begin
      sDebug := Format('Flash Data Read(Panel->QSPI): StartAddr(%d) Len(%d)',[nUnitAddr,nUnitSize]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      dwRtn := SendSpiFlashRead(flashReadUnit, nUnitAddr, nUnitSize, 3000{nWaitMsec});
      if dwRtn <> WAIT_OBJECT_0 then begin
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...NG');
        Exit(dwRtn);
      end;
      Sleep(100);

      nDataIdx := 0;
      sDebug := Format('Flash Data Upload(QSPI->PC): Index(%d) Len(%d)',[nDataIdx,nUnitSize]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      dwRtn := SendSpiFlashDataUploadFlow(nDataIdx,nUnitSize, 3000{nWaitMsec});
      if dwRtn <> WAIT_OBJECT_0 then begin
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug+' ...NG');
        Exit(dwRtn);
      end;
    end;
    //
    if dwRtn = WAIT_OBJECT_0 then begin
      CopyMemory(@m_FlashUnitBuf[nUnitIdx].Data[0],@m_FlashRead.RxData[0],nUnitSize);
      Common.CalcCheckSum(@m_FlashUnitBuf[nUnitIdx].Data[0],nUnitSize,m_FlashUnitBuf[nUnitIdx].Checksum);
      m_FlashUnitBuf[nUnitIdx].UnitAddr     := nUnitAddr;
      m_FlashUnitBuf[nUnitIdx].UnitSize     := nUnitSize;
      m_FlashUnitBuf[nUnitIdx].UnitStatus   := flashUnitRead;
    end;

  finally
    //---------------------------------- Ext_Flash_Access(0x0020) - Disable
    sFunc  := 'ExtFlashAccess(Disable)';
    sDebug := sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    Sleep(FlashAccessParam.AccDisableBeforeDelayMsec);
    dwRtn := SendSpiFlashAccess(0{nMode:0=Disable,1=Enable});
    if (dwRtn <> WAIT_OBJECT_0) then begin
      Sleep(100);
      dwRtn := SendSpiFlashAccess(0{nMode:0=Disable,1=Enable});
      if (dwRtn <> WAIT_OBJECT_0) then begin
        if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
        sDebug := sMLog+sFunc+' ('+sReason+')';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      end;
    end;
    Sleep(FlashAccessParam.AccDisableAfterDelayMsec);
    //---------------------------------- Enable Cyclic Timers (AliveCheck, PowerMeasure)
    SetCyclicTimerSpi(True{bEnable});

    Common.CodeSiteSend(sFunc+'...END');
  end;

  Result := dwRtn;
end;

function TDongaPG.FlashWriteData(nFlashAddr: UInt32; nLen: Integer; btaData: TIdBytes ; bForce: Boolean = False): DWORD;  //TBD:EDNA:FLASH?
var
  nRtn : DWORD;
  nUnitAddr : UInt32;
  nUnitIdx, nUnitSize : Integer;
  nDataIdx, nUnitDataOffset : Integer;
  bAlreadyRead : Boolean;
  sFunc, sTempFunc, sMLog : string;
begin
  sMLog := 'FLASH Write';
  sFunc := Format('FlashWriteData(nFlashAddr=0x%0.4x,nLen=%d,bForce=%s): ',[nFlashAddr,nLen,BoolToStr(bForce)]);
  Common.CodeSiteSend(sFunc+'##### START #####');
  //
  nDataIdx := 0;
  //
  nUnitAddr := FlashGetUnitAddr(nFlashAddr);
  nUnitSize := FLASH_DATAUNIT_SIZE;  //TBD:EDNA:FLASH? (ModelInfo?)
  while (nUnitAddr <= (nFlashAddr + nLen - 1)) do begin
    //
    bAlreadyRead := False;
    if FlashGetUnitIdx(nFlashAddr,nUnitAddr,nUnitIdx) then begin // Already in Buffer
      bAlreadyRead := True;
    end
    else begin
      if not FlashGetEmptyUnitIdx(nUnitIdx) then begin
        Common.CodeSiteSend(sFunc+'...NG(FlashUnitBuf Full) ...TBD(Flash Commit?)');
        Exit(WAIT_FAILED);  //TBD:EDNA:FLASH? (Flash Commit?)
      end;
    end;
    //
    if (not bAlreadyRead) or bForce then begin
      sTempFunc := Format('FlashReadDeviceUnit:UnitIdx=%d,UnitAddr=0x%0.4x): ',[nUnitIdx,nUnitAddr]);
      nRtn := FlashReadDeviceUnit(nUnitIdx,nUnitAddr,nUnitSize,1{nTryCnt});
      if nRtn <> WAIT_OBJECT_0 then begin
        Common.CodeSiteSend(sFunc+sTempFunc+'...NG(Flash Read Before Write)');
        Exit(WAIT_FAILED);
      end;
    end;
    //
    if (nDataIdx = 0) then nUnitDataOffset := (nFlashAddr mod nUnitSize)  // 1st
    else                   nUnitDataOffset := 0;                          // 2nd~
    while (nDataIdx < nLen) and (nUnitDataOffset < nUnitSize) do begin
      m_FlashUnitBuf[nUnitIdx].Data[nUnitDataOffset] := btaData[nDataIdx];
      sTempFunc :=Format('(FlashAddr=0x%0.4x,UnitIdx=%d,UnitAddr=0x%0.4x,UnitOffset=%d,Value=%0.2x)',[nFlashAddr+nDataIdx,nUnitIdx,nUnitAddr,nUnitDataOffset,btaData[nDataIdx]]);
      Common.CodeSiteSend(sFunc+sTempFunc);
      Inc(nDataIdx);
      Inc(nUnitDataOffset);
    end;
    //
  //Common.CalcCheckSum(@m_FlashUnitBuf[nUnitIdx].Data[0],DefPG.FLASH_DATAUNIT_SIZE,m_FlashUnitBuf[nUnitIdx].Checksum);
    m_FlashUnitBuf[nUnitIdx].UnitStatus := flashUnitUpdated;
    //
    nUnitAddr := nUnitAddr + nUnitSize;
    sleep(500); //2021-03-09 (10 -> 100)
  end;
  //
  if bForce then begin
    sTempFunc := 'FlashWriteDeviceCommit: ';
    nRtn := FlashWriteDeviceCommit;
    if nRtn <> WAIT_OBJECT_0 then begin
      Common.CodeSiteSend(sFunc+sTempFunc+'...NG');
      Exit(WAIT_FAILED);
    end;
  end;
  Common.CodeSiteSend(sFunc+'##### END #####');
  Result := WAIT_OBJECT_0;
end;

function TDongaPG.FlashWriteDeviceUnit(nUnitIdx: Integer; bAccessEnable: Boolean = True; bAccessDisable: Boolean = True; nTryCnt: Integer = 1): DWORD;  //TBD:EDNA:FLASH?
var
  dwRtn : DWORD;
  nUnitSize : Integer;
  nUnitAddr, nChecksum  : UInt32;
  sFunc, sMLog, sTempFunc, sDebug, sReason : string;
  FlashAccessParam : TFlashAccessParamRec;
begin
  sMLog := 'CBPARA Write ';
  sFunc := Format('FlashWriteDeviceUnit(UntIdx=%d,bAccessEnable=%s,bAccessDisable=%s,TRyCnt=%d): ',[nUnitIdx,BoolToStr(bAccessEnable),BoolToStr(bAccessDisable),nTryCnt]);
  Common.CodeSiteSend(sFunc+' ...START');

  if (nUnitIdx < 0) or (nUnitIdx > DefPG.FLASH_UNITDATABUF_MAX) then begin
    Common.CodeSiteSend(sFunc+'...NG(Invalid UnitIdx)');
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sMLog+'NG(Invalid Data)',DefPocb.LOG_TYPE_NG);
    Exit(WAIT_FAILED);
  end;
  sFunc := sFunc + Format('(UnitAddr=0x%0.4x): ',[m_FlashUnitBuf[nUnitIdx].UnitAddr]);
  if m_FlashUnitBuf[nUnitIdx].UnitStatus = flashUnitEmpty then begin
    Common.CodeSiteSend(sFunc+'...NG(flashUnitEmpty)');
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sMLog+'NG(Invalid Data)',DefPocb.LOG_TYPE_NG);
    Exit(WAIT_FAILED);
  end;

  nUnitAddr := m_FlashUnitBuf[nUnitIdx].UnitAddr;
  nUnitSize := m_FlashUnitBuf[nUnitIdx].UnitSize;
  m_FlashUnitBuf[nUnitIdx].Checksum := 0;
  Common.CalcCheckSum(@m_FlashUnitBuf[nUnitIdx].Data[0],m_FlashUnitBuf[nUnitIdx].UnitSize,m_FlashUnitBuf[nUnitIdx].Checksum);
  nChecksum := m_FlashUnitBuf[nUnitIdx].Checksum;

  try
    //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
    SetCyclicTimerSpi(False{bEnable});

    //---------------------------------- Get Flash Access Info
    FlashAccessParam := Common.TestModelInfo2[m_nPgNo].FlashAccessParam;

    //---------------------------------- Ext_Flash_Access(0x0020) - Enable
    sFunc  := 'ExtFlashAccess(Enable)';
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);

    Sleep(FlashAccessParam.AccEnableBeforeDelayMsec);
    dwRtn := SendSpiFlashAccess(1{nMode:0=Disable,1=Enable});
    if (dwRtn <> WAIT_OBJECT_0) then begin
      Sleep(100);
      dwRtn := SendSpiFlashAccess(1{nMode:0=Disable,1=Enable});
      if (dwRtn <> WAIT_OBJECT_0) then begin
        if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
        sDebug := sMLog+sFunc+' ...NG('+sReason+')';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
        Exit(dwRtn);
      end;
    end;
    Sleep(FlashAccessParam.AccEnableAfterDelayMsec);

    if Common.SystemInfo.SPI_TYPE = SPI_TYPE_DJ023_SPI then begin
      //---------------------------------- Ext_Flash_Init(0x0032)
      sFunc  := 'ExtFlashInit';
      sDebug := sMLog+sFunc;
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      Sleep(FlashAccessParam.InitBeforeDelayMsec);
      dwRtn := SendSpiFlashInit;
      if (dwRtn <> WAIT_OBJECT_0) then begin
        Sleep(100);
        dwRtn := SendSpiFlashInit;
        if (dwRtn <> WAIT_OBJECT_0) then begin
          if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
          sDebug := sMLog+sFunc+' ...NG('+sReason+')';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
          Exit(dwRtn);
        end;
      end;
      Sleep(FlashAccessParam.InitAfterDelayMsec);
    end;

   //---------------------------------- QSPI Erase(0x0024) - Block, start addr, file size
    // erase wait (param csv) & check erase ack
    sFunc  := Format('Erase(0x%0.8x,%d)',[nUnitAddr,nUnitSize]);
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    Sleep(FlashAccessParam.EraseBeforeDelayMsec);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE, '', DefPocb.FLASH_PROGRESS_ERASE_START); //2021-05
    dwRtn := SendSpiFlashErase($20{nMode:0xC7=Chip,0xD8=Block,0x20=Sector},nUnitAddr,nUnitSize,FlashAccessParam.EraseAckWaitSec*1000);
    if (dwRtn <> WAIT_OBJECT_0) then begin
    //Sleep(100);
    //nRtn := SendQSPIErase($D8{nMode:0xC7=Chip,0xD8=Block,0x20=Sector},nStartAddr,nSize,FlashAccessParam.EraseAckWaitSec*1000);
    //if (dwRtn <> WAIT_OBJECT_0) then begin
        if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
        sDebug := sMLog+sFunc+' ...NG('+sReason+')';
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
        Exit(dwRtn);
    //end;
    end;
    Sleep(FlashAccessParam.EraseAfterDelayMsec);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE, '', DefPocb.FLASH_PROGRESS_ERASE_END); //2021-05

    //---------------------------------- QSPI Write (0x0026) , 'S', start addr, file size <- flash write start
    sFunc  := Format('START(0x%0.8x,%d)',[nUnitAddr,nUnitSize]);
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    Sleep(FlashAccessParam.DataStartBeforeDelayMsec);
    dwRtn := SendSpiFlashWrite_StartEnd(DefPG.PGSPI_DOWNLOAD_START, nUnitAddr,nUnitSize,FlashAccessParam.DataStartAckWaitSec*1000);
    if (dwRtn <> WAIT_OBJECT_0) then begin
      if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
      sDebug := sMLog+sFunc+' NG('+sReason+')';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      Exit(dwRtn);
    end;
    Sleep(FlashAccessParam.DataStartAfterDelayMsec);

    //---------------------------------- TX Data (1024 bytes per packet)
    // inter-packet delay (param csv)
    sFunc  := 'TX_DATA';
  //sTempFunc := Format('SendSpiFlashWriteUnitData(Size=%d): ',[nUnitSize]);
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    dwRtn := SendSpiFlashWriteUnitData(nUnitSize,m_FlashUnitBuf[nUnitIdx].Data,FlashAccessParam.DataSendInterDelayMsec);
    if (dwRtn <> WAIT_OBJECT_0) then begin
      if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
      sDebug := sMLog+sFunc+' ...NG('+sReason+')';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      Exit(dwRtn);
    end;

   //---------------------------------- QSPI Write (0x0026) , 'E', chksum
    // end ack wait (param csv) & check erase ack
    sFunc  := Format('END(0x%0.8x,0x%0.8x)',[nUnitAddr,nChecksum]);  //TBD:GAGO? nChecksum?
    sDebug := sMLog+sFunc;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
    Sleep(FlashAccessParam.DataEndBeforeDelayMsec);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE, '', DefPocb.FLASH_PROGRESS_ENDACK_START); //2021-05
    dwRtn := SendSpiFlashWrite_StartEnd(DefPG.PGSPI_DOWNLOAD_END, nChecksum,0{nSize:dummy}, FlashAccessParam.DataEndAckWaitSec*1000);
    if (dwRtn <> WAIT_OBJECT_0) then begin
      if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
      sDebug := sMLog+sFunc+' ...NG('+sReason+')';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
      Exit(dwRtn);
    end;
    Sleep(FlashAccessParam.DataEndAfterDelayMsec);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE, '', DefPocb.FLASH_PROGRESS_ENDACK_END); //2021-05

    //
    Common.CodeSiteSend(sFunc+sTempFunc+'OK');
    m_FlashUnitBuf[nUnitIdx].UnitStatus := flashUnitRead;  //TBD:EDNA:FLASH?
    Result := WAIT_OBJECT_0;

  finally
    if (Result <> WAIT_OBJECT_0) or bAccessDisable then begin //#############################
      //---------------------------------- Ext_Flash_Access(0x0020) - Disable
      sFunc  := 'ExtFlashAccess(Disable)';
      sDebug := sMLog+sFunc;
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug);
      Sleep(FlashAccessParam.AccDisableBeforeDelayMsec);
      dwRtn := SendSpiFlashAccess(0{nMode:0=Disable,1=Enable});
      if (dwRtn <> WAIT_OBJECT_0) then begin
        Sleep(100);
        dwRtn := SendSpiFlashAccess(0{nMode:0=Disable,1=Enable});
        if (dwRtn <> WAIT_OBJECT_0) then begin
          if (dwRtn = WAIT_TIMEOUT) then sReason := 'Timeout' else sReason := 'Failed';
          sDebug := sMLog+sFunc+' ('+sReason+')';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,sDebug, DefPocb.LOG_TYPE_NG);
        end;
      end;
      Sleep(FlashAccessParam.AccDisableAfterDelayMsec);
    end;
    //---------------------------------- Enable Cyclic Timers (AliveCheck, PowerMeasure)
    SetCyclicTimerSpi(True{bEnable});

  end;
  Result := WAIT_OBJECT_0;
end;

function TDongaPG.FlashWriteDeviceCommit: DWORD;  //TBD:EDNA:FLASH?
var
  dwRtn  : DWORD;
  sFunc : string;
  nUnitIdx : Integer;
  nUnitAddr : UInt32;
  nStartUnit, nEndUnit : Integer;
  bAccessEnable, bAccessDisable : Boolean;
begin
  sFunc := 'FlashWriteDeviceCommit'; Common.CodeSiteSend(sFunc);
  //
  for nUnitIdx := 0 to DefPG.FLASH_UNITDATABUF_MAX do begin
    case m_FlashUnitBuf[nUnitIdx].UnitStatus of
      flashUnitUpdated, flashUnitWriteErr: begin
        nStartUnit := nUnitIdx;
        Break;
      end;
    end;
  end;
  for nUnitIdx := DefPG.FLASH_UNITDATABUF_MAX downto 0 do begin
    case m_FlashUnitBuf[nUnitIdx].UnitStatus of
      flashUnitUpdated, flashUnitWriteErr: begin
        nEndUnit := nUnitIdx;
        Break;
      end;
    end;
  end;
  //
  for nUnitIdx := 0 to DefPG.FLASH_UNITDATABUF_MAX do begin
    case m_FlashUnitBuf[nUnitIdx].UnitStatus of
      flashUnitUpdated, flashUnitWriteErr: begin
        if nUnitIdx = nStartUnit then bAccessEnable  := True else bAccessEnable  := False;
        if nUnitIdx = nEndUnit   then bAccessDisable := True else bAccessDisable := False;
        dwRtn := FlashWriteDeviceUnit(nUnitIdx,bAccessEnable,bAccessDisable);
        if dwRtn <> WAIT_OBJECT_0 then begin
          Exit(dwRtn); //TBD:EDNA:FLASH?
        end;
        sleep(500); //2021-03-09 (10 -> 100)
      end;
    end;
  end;
  Result := WAIT_OBJECT_0;
end;
{$ENDIF} //FEATURE_FLASH_UNIT_RW

//##############################################################################
//##############################################################################
//###                                                                        ###
//###                             FLOW-SPECIFIC                              ###
//###                                                                        ###
//##############################################################################
//##############################################################################

//------------------------------------------------------------------------------
//
function TDongaPG.SendSpiFlashWriteCBData(const transData: TFileTranStr; nInterDataMS: Integer): DWORD; //TBD:MERGE? AutoPOCB //#SendQSPIWriteCBData //TBD:Move to Logic?
var
  TxBuff : TIdbytes;
  j, nDiv, nMod, nFileSize : Integer;
  sMsg : string;
  txPercentage, displayPercentage : Integer;
begin
  Result := WAIT_FAILED;
  try
 	  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE,'0', DefPocb.FLASH_PROGRESS_DATA_PERCENTAGE);
    {$IFDEF SIMULATOR_PANEL}
 	  nInterDataMS := 20;  // for SimulatorCAM
 	  {$ENDIF}
 	  nFileSize := transData.TotalSize;
 	  SetLength(TxBuff, DefPG.PGSPI_PACKET_SIZE);

 	  ClearDataBuf(TxBuff,DefPG.PGSPI_PACKET_SIZE); //FillChar(TxBuff,DefPG.PGSPI_PACKET_SIZE,0);
 	  nDiv := nFileSize div DefPG.PGSPI_PACKET_SIZE;
 	  nMod := nFileSize mod DefPG.PGSPI_PACKET_SIZE;
 	  for j := 1 to nDiv do begin
 	    CopyMemory(@TxBuff[0],@transData.Data[(j-1)*DefPG.PGSPI_PACKET_SIZE],DefPG.PGSPI_PACKET_SIZE);
 	    SendSpiFlashWrite_Data(DefPG.PGSPI_PACKET_SIZE, TxBuff);
	    Sleep(nInterDataMS);
 	    txPercentage := Trunc((j / nDiv) * 100);
 	  //if ((txPercentage div 5) = 0) then begin
 	      if (txPercentage <> displayPercentage) then begin
 	        sMsg := IntToStr(txPercentage);
 	        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE,sMsg, DefPocb.FLASH_PROGRESS_DATA_PERCENTAGE);
 	        displayPercentage := txPercentage;
 	      end;
 	  //end;
      if self.StatusPg = pgForceStop then Exit;
 	  end;
 	  if nMod > 0 then begin
 	    ClearDataBuf(TxBuff,DefPG.PGSPI_PACKET_SIZE); //FillChar(TxBuff,DefPG.PGSPI_PACKET_SIZE,0);
 	    CopyMemory(@TxBuff[0],@transData.Data[nDiv*DefPG.PGSPI_PACKET_SIZE],nMod);
 	    SendSpiFlashWrite_Data(nMod, TxBuff);
 	    Sleep(nInterDataMS);
 	    if Self.StatusPg = pgForceStop then Exit;
 	  end;
 	  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLASH_WRITE,'100', DefPocb.FLASH_PROGRESS_DATA_PERCENTAGE);
 	  Result := WAIT_OBJECT_0;
	finally
  	//
  end;
end;

{$IFDEF FEATURE_FLASH_UNIT_RW}
function  TDongaPG.SendSpiFlashWriteUnitData(wTxLen: UInt32; TxData: array of Byte; nInterDataMS: Integer): DWORD;
var
  TxBuff : TIdbytes;
  j, nDiv, nMod, nFileSize : Integer;
  sMsg : string;
  txPercentage, displayPercentage : Integer;
begin
  Result := WAIT_FAILED;
  try
    {$IFDEF SIMULATOR_PANEL}
 	  nInterDataMS := 20;  // for SimulatorCAM
 	  {$ENDIF}
 	  SetLength(TxBuff, DefPG.PGSPI_PACKET_SIZE);

 	  nDiv := wTxLen div DefPG.PGSPI_PACKET_SIZE;
 	  nMod := wTxLen mod DefPG.PGSPI_PACKET_SIZE;
 	  for j := 1 to nDiv do begin
 	    CopyMemory(@TxBuff[0],@TxData[(j-1)*DefPG.PGSPI_PACKET_SIZE],DefPG.PGSPI_PACKET_SIZE);
 	    SendSpiFlashWrite_Data(DefPG.PGSPI_PACKET_SIZE, TxBuff);
	    Sleep(nInterDataMS);
      if self.StatusPg = pgForceStop then Exit;
 	  end;
 	  if nMod > 0 then begin
 	    CopyMemory(@TxBuff[0],@TxData[nDiv*DefPG.PGSPI_PACKET_SIZE],nMod);
 	    SendSpiFlashWrite_Data(nMod, TxBuff);
 	    Sleep(nInterDataMS);
 	    if Self.StatusPg = pgForceStop then Exit;
 	  end;
 	  Result := WAIT_OBJECT_0;
	finally
  	//
  end;
end;
{$ENDIF} //FEATURE_FLASH_UNIT_RW

{$IFDEF PANEL_FOLD}
//------------------------------------------------------------------------------
//		- function TDongaPG.SendPgDisplayPwmPat(nIdx: Integer; nWaitMS: Integer = 3000; nRetry: Integer = 0): DWORD;  //2019-10-11 DIMMING
//		- procedure TDongaPG.GetPwmI2cWriteData_EDNA(nDim: Integer; var arrI2c: TArrayI2CData);  //TBD:QSPI?
//		- function TDongaPG.SendPgI2cPwm_EDNA(nDim: Integer; nRetry: Integer = 1): DWORD;  //TBD:QSPI:PWM?
//		- function TDongaPG.SendSpiI2cPwm_EDNA(nDim: Integer; nRetry: integer = 1): DWORD; //TBD:QSPI:PWM?
//

function TDongaPG.SendPgDisplayPwmPat(npatNum: Integer; nWaitMS: Integer = 3000; nRetry: Integer = 0): DWORD; //FoldFI|FoldPOCB(DIMMING) //TBD:MERGE?
var
  nDim : Integer;
begin
  nDim := FCurPatGrpInfo.Dimming[nPatNum];
  if (Common.TestModelInfoFLOW.UsePwm) and (nDim > 0) and (nDim <= 100) then begin
    Result := SendPgDimming(nDim,nRetry);
    if Result <> WAIT_OBJECT_0 then Exit(Result);
  end;
  Result := CheckPgCmdAck(procedure begin SendPgDisplayPatReq(1, nPatNum);end, DefPG.SIG_PG_DISPLAY_PAT,nWaitMS,nRetry);
end;

procedure TDongaPG.GetPwmI2cWriteData_EDNA(nDim: Integer; var arrI2c: TArrayI2CData);
var
  nBandSelection,  nBandInValue  : Integer;
  btBandSelection, btBandInValue : Byte;
  sDebug : string;
begin
  if (nDim < 1)        then nDim := 1
  else if (nDim > 100) then nDim := 100;

  // EDNA PWM:
  //  - BandSelection : 1017[7:5], 8 Band (PWM 12.5% interval)  //1017=0x03F9
  //  - BandInValue   : 1017[4:0] 1018[7:5]                     //1018=0x03FA
  //  - Don't Care    : 1018[4:0]

  nBandSelection := Round(((nDim*10) div 125) - 1);
  if (nBandSelection < 0)      then nBandSelection := 0
  else if (nBandSelection > 7) then nBandSelection := 7;

  nBandInValue   := Round((255/12.5) * nDim);
  if (nBandInValue < 0)        then nBandInValue := 0
  else if (nBandInValue > 255) then nBandInValue := 255;

  btBandSelection := Byte(nBandSelection);
  btBandInValue   := Byte(nBandInValue);

  sDebug := Format('[PWM:%d] BandSelection(0x%0.2x) BandInValue(0x%0.2x)',[nDim,btBandSelection,btBandInValue]);
  Common.MLog(m_nPgNo,sDebug);

  arrI2c.Data[0].DevAddr := $50; arrI2c.Data[0].RegAddr := 1017; {0x3F9};
  arrI2c.Data[0].Value   := (((btBandSelection and $07) shl 5) or ((btBandInValue shr 3) and $1F));

  arrI2c.Data[1].DevAddr := $50; arrI2c.Data[1].RegAddr := 1018; {0x3F9};
  arrI2c.Data[1].Value   := (((btBandInValue and $07) shl 5) or $1F);

  arrI2c.Cnt := 2;
end;

function TDongaPG.SendPgI2cPwm_EDNA(nDim: Integer; nRetry: Integer = 0): DWORD;
var
  arrI2c : TArrayI2CData;
  i : Integer;
  wdRet : DWORD;
  sDebug, sTemp : string;
  nPwmEnableDevAddr, nPwmEnableRegAddr : integer;
  btPwmEnableValue : Byte;
begin
  Result := WAIT_FAILED;
  GetPwmI2cWriteData_EDNA(nDim, arrI2c);

  // 1379[0] <- 0
  nPwmEnableDevAddr := $50;
  nPwmEnableRegAddr := 1379;  //1379, ox017B
  btPwmEnableValue  := $FF;
  sDebug := Format('[PWM:%d] I2C Read: Dev(0x%0.2x) Addr(%d,0x%0.4x)',[nDim,nPwmEnableDevAddr,nPwmEnableRegAddr,nPwmEnableRegAddr]);
  {$IFNDEF SIMULATOR_PANEL}
  wdRet := SendPgI2CRead(nPwmEnableDevAddr,nPwmEnableRegAddr,1, PG_I2CCMD_WAIT_TIMESEC,nTryCnt);
  {$ELSE}
  wdRet := WAIT_OBJECT_0;
  {$ENDIF}
  if wdRet <> WAIT_OBJECT_0 then begin
    Common.MLog(m_nPgNo,sDebug+' ...NG(Read)');
    Exit;
  end;
  btPwmEnableValue := FRxDataPg.Data[0];
  if (btPwmEnableValue and $01) <> 0 then begin
    btPwmEnableValue := (btPwmEnableValue and $FE);  // set 1379[0] to 0
    arrI2c.Data[arrI2c.Cnt].DevAddr := nPwmEnableDevAddr;
    arrI2c.Data[arrI2c.Cnt].RegAddr := nPwmEnableRegAddr;
    arrI2c.Data[arrI2c.Cnt].Value   := Byte(btPwmEnableValue);
    Inc(arrI2c.Cnt)
  end;

  // Addr: 1017, 1018, (1379)
  for i := 0 to Pred(arrI2c.Cnt) do begin
    //
    sDebug := Format('[PWM:%d] I2C Write: Dev(0x%0.2x) Addr(%d) WriteValue(0x%0.2x)',[nDim,arrI2c.Data[i].DevAddr,arrI2c.Data[i].RegAddr,arrI2c.Data[i].Value]);
  {$IFNDEF SIMULATOR_PANEL}  //IMSI
    wdRet := SendPgI2CWrite(arrI2c.Data[i].DevAddr,arrI2c.Data[i].RegAddr,1, arrI2c.Data[i].Value, PG_I2CCMD_WAIT_TIMESEC,nTryCnt);
  {$ELSE}
    wdRet := WAIT_OBJECT_0;
  {$ENDIF}
    if wdRet <> WAIT_OBJECT_0 then begin
      Common.MLog(m_nPgNo,sDebug+' ...NG(Write)');
    //IMSI-DELETE   Exit;
    end;
    Common.MLog(m_nPgNo,sDebug);
    Sleep(200);
    //
    sDebug := Format('[PWM:%d] I2C Read: Dev(0x%0.2x) Addr(%d)',[nDim,arrI2c.Data[i].DevAddr,arrI2c.Data[i].RegAddr]);
    {$IFNDEF SIMULATOR_PANEL}
    wdRet := SendPgI2CRead(arrI2c.Data[i].DevAddr,arrI2c.Data[i].RegAddr,1, PG_I2CCMD_WAIT_TIMESEC,nTryCnt);
    {$ELSE}
    wdRet := WAIT_OBJECT_0;
    FRxDataPg.DataLen := 1;
    SetLength(FRxDataPg.Data,FRxDataPg.DataLen);
    FRxDataPg.Data[0] := arrI2c.Data[i].Value;
    {$ENDIF}
    if wdRet <> WAIT_OBJECT_0 then begin
      Common.MLog(m_nPgNo,sDebug+' ...NG(Read)');
    //IMSI-DELETE         Exit;
    end;
    //
    sDebug := sDebug + Format(' ReadValue(0x%0.2x)',[FRxDataPg.Data[0]]);
    if (FRxDataPg.DataLen <> 1) or (FRxDataPg.Data[0] <> arrI2c.Data[i].Value) then begin
      Common.MLog(m_nPgNo,sDebug+' ...NG(Verify)');
      Exit;
    end;
    Common.MLog(m_nPgNo,sDebug);
    Sleep(100);
  end;
  Result := WAIT_OBJECT_0;
end;

function TDongaPG.SendSpiI2cPwm_EDNA(nDim: Integer; nRetry: integer = 0): DWORD;
var
  arrI2c : TArrayI2CData;
  i : Integer;
  wdRet : DWORD;
  sDebug, sTemp : string;
  nPwmEnableDevAddr, nPwmEnableRegAddr : integer;
  btPwmEnableValue : Byte;
begin
  Result := WAIT_FAILED;
  GetPwmI2cWriteData_EDNA(nDim, arrI2c);

  // 1379[0] <- 0
  nPwmEnableDevAddr := $50;
  nPwmEnableRegAddr := 1379;  //1379, ox017B
  btPwmEnableValue  := $FF;
  sDebug := Format('[PWM:%d] I2C Read: Dev(0x%0.2x) Addr(%d,0x%0.4x)',[nDim,nPwmEnableDevAddr,nPwmEnableRegAddr,nPwmEnableRegAddr]);
  {$IFNDEF SIMULATOR_PANEL}
  wdRet := SendSpiI2CRead(nPwmEnableDevAddr,nPwmEnableRegAddr,1,SPI_I2CCMD_WAIT_TIMESEC,nTryCnt);
  {$ELSE}
  wdRet := WAIT_OBJECT_0;
  {$ENDIF}
  if wdRet <> WAIT_OBJECT_0 then begin
    Common.MLog(m_nPgNo,sDebug+' ...NG(Read)');
    Exit;
  end;
  btPwmEnableValue := FRxDataSpi.Data[0];
  if (btPwmEnableValue and $01) <> 0 then begin
    btPwmEnableValue := (btPwmEnableValue and $FE);  // set 1379[0] to 0
    arrI2c.Data[arrI2c.Cnt].DevAddr := nPwmEnableDevAddr;
    arrI2c.Data[arrI2c.Cnt].RegAddr := nPwmEnableRegAddr;
    arrI2c.Data[arrI2c.Cnt].Value   := Byte(btPwmEnableValue);
    Inc(arrI2c.Cnt)
  end;

  // Addr: 1017, 1018, (1379)
  for i := 0 to Pred(arrI2c.Cnt) do begin
    //
    sDebug := Format('[PWM:%d] I2C Write: Dev(0x%0.2x) Addr(%d) WriteValue(0x%0.2x)',[nDim,arrI2c.Data[i].DevAddr,arrI2c.Data[i].RegAddr,arrI2c.Data[i].Value]);
    {$IFNDEF SIMULATOR_PANEL}  //IMSI
    wdRet := SendSpiI2CWrite(arrI2c.Data[i].DevAddr,arrI2c.Data[i].RegAddr,1, arrI2c.Data[i].Value, SPI_I2CCMD_WAIT_TIMESEC,nTryCnt);
    {$ELSE}
    wdRet := WAIT_OBJECT_0;
    {$ENDIF}
    if wdRet <> WAIT_OBJECT_0 then begin
      Common.MLog(m_nPgNo,sDebug+' ...NG(Write)');
    //IMSI-DELETE   Exit;
    end;
    Common.MLog(m_nPgNo,sDebug);
    Sleep(200);
    //
    sDebug := Format('[PWM:%d] I2C Read: Dev(0x%0.2x) Addr(%d)',[nDim,arrI2c.Data[i].DevAddr,arrI2c.Data[i].RegAddr]);
    {$IFNDEF SIMULATOR_PANEL}
    wdRet := SendSpiI2CRead(arrI2c.Data[i].DevAddr,arrI2c.Data[i].RegAddr,1, SPI_I2CCMD_WAIT_TIMESEC,nTryCnt);
    {$ELSE}
    wdRet := WAIT_OBJECT_0;
    FRxDataSpi.DataLen := 1;
  //SetLength(FRxDataSpi.Data,FRxDataSpi.DataLen);
    FRxDataSpi.Data[0] := arrI2c.Data[i].Value;
    {$ENDIF}
    if wdRet <> WAIT_OBJECT_0 then begin
      Common.MLog(m_nPgNo,sDebug+' ...NG(Read)');
    //IMSI-DELETE         Exit;
    end;
    //
    sDebug := sDebug + Format(' ReadValue(0x%0.2x)',[FRxDataSpi.Data[0]]);
    if (FRxDataSpi.DataLen <> 1) or (FRxDataSpi.Data[0] <> arrI2c.Data[i].Value) then begin
      Common.MLog(m_nPgNo,sDebug+' ...NG(Verify)');
      Exit;
    end;
    Common.MLog(m_nPgNo,sDebug);
    Sleep(100);
  end;
  Result := WAIT_OBJECT_0;
end;
{$ENDIF} //PANEL_FOLD

{$IFDEF PANEL_FOLD}
//==============================================================================
// procedure/function: 
//		- function TDongaPG.SendDimming(nDimming: Integer; nTryCnt: Integer = 1): DWORD;  //TBD:MERGE? Auto(X) FOld(O)
//
function TDongaPG.SendDimming(nDimming: Integer; nTryCnt: Integer = 1): DWORD;  //TBD:MERGE? Auto(X) FOld(O)
var
  nDimmingStep : Integer;
begin
  Result := WAIT_FAILED;

  if ((Common.SystemInfo.ModelType = 'LP133QX1') or (Common.SystemInfo.ModelType = 'LARK')) then begin
    Result := SendPgDimming(nDimming); //LARK
  end
//else if ((Common.SystemInfo.ModelType = 'LP170QX1') or (Common.SystemInfo.ModelType = 'EDNA') or (Common.SystemInfo.ModelType = 'LP170EDNA')) then begin
  else if Pos('LP170',Common.SystemInfo.ModelType) = 1 then begin  //2021-07-21 EDNA
    case Common.SystemInfo.SPI_TYPE of
      DefPG.SPI_TYPE_NONE : begin
        Result := SendPgI2cPwm_EDNA(nDimming,nTryCnt); //TBD:QSPI:PWM?
      end;
      else begin
        Result := SendSpiI2cPwm_EDNA(nDimming,nTryCnt); //TBD:QSPI:PWM?
      end;
    end;
  end;
  //
  {$IFDEF FEATURE_DIMMING_STEP}
  if (Result = WAIT_OBJECT_0) then begin
    nDimmingStep := 0;
    if      nDimming = Common.TestModelInfoFLOW.DimmingStep1 then nDimmingStep := 1
    else if nDimming = Common.TestModelInfoFLOW.DimmingStep2 then nDimmingStep := 2
    else if nDimming = Common.TestModelInfoFLOW.DimmingStep3 then nDimmingStep := 3
    else if nDimming = Common.TestModelInfoFLOW.DimmingStep4 then nDimmingStep := 4;
    FDisPatStruct.CurrPat.nCurrDimmingStep := nDimmingStep;
  end;
  {$ENDIF}
end;
{$ENDIF} //PANEL_FOLD

{$IFDEF INSPECTOR_FI}
//==============================================================================
// procedure/function:
//    - procedure TDongaPG.SendPgGrayChange(nGrayOffset: Integer);
//
procedure TDongaPG.SendPgGrayChange(nGrayOffset: Integer); //FoldFI(GRAY_CHANGE)
begin
  SendPgSetColorPallet(nGrayOffset,nGrayOffset,nGrayOffset);
  //
  FDisPatStruct.CurrPat.nGrayOffset := nGrayOffset;
end;
{$ENDIF}

//##############################################################################
//##############################################################################
//###                                                                        ###
//###                             ETC (GUI/...)                              ###
//###                                                                        ###
//##############################################################################
//##############################################################################

//==============================================================================
// procedure/function:
//    - procedure TDongaPG.SendMainGuiDisplay(nGuiMode: Integer; sMsg: string; nParam: Integer=0);
//    - procedure TDongaPG.SendTestGuiDisplay(nGuiMode: Integer; sMsg: string; nParam: Integer=0);
//    - procedure TDongaPG.ShowPgBmpDownStatus(nGuiType, curPos, total: Integer; sMsg: string; bIsDone: Boolean = False);
//		- procedure TDongaPG.ShowSpiDownLoadStatus(nGuiType,curPos, total: Integer; sMsg: string;bIsDone: Boolean=False); //TBD:MERGE? FoldFI(QSPI)
//
procedure TDongaPG.SendMainGuiDisplay(nGuiMode: Integer; sMsg: string; nParam: Integer=0);
var
  ccd         : TCopyDataStruct;
  GuiMainData : TMainGuiPgData;
begin
  GuiMainData.MsgType := DefPocb.MSG_TYPE_PG;
  GuiMainData.Mode    := nGuiMode;
  GuiMainData.PgNo    := m_nPgNo;
  GuiMainData.sMsg    := sMsg;
  GuiMainData.Param   := nParam;
  //
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(GuiMainData);
  ccd.lpData      := @GuiMainData;
  SendMessage(m_hMain,WM_COPYDATA,0, LongInt(@ccd));
end;

procedure TDongaPG.SendTestGuiDisplay(nGuiMode: Integer; sMsg: string; nParam: Integer=0); // TBD:MERGE? FOldFO(ShowTestWindow) POCB(SendTestGuiDisplay)
var
  ccd         : TCopyDataStruct;
  GuiTestData : TTestGuiPgData;
begin
  GuiTestData.MsgType := DefPocb.MSG_TYPE_PG;
  GuiTestData.Mode    := nGuiMode;
  GuiTestData.PgNo    := m_nPgNo;
  GuiTestData.sMsg    := sMsg;
  GuiTestData.Param   := nParam;
  if (DefPocb.PGSPI_MAIN_TYPE = DefPocb.PGSPI_MAIN_PG)   then GuiTestData.PwrDataPg  := m_PwrDataPg;
  if (DefPocb.PGSPI_MAIN_TYPE = DefPocb.PGSPI_MAIN_QSPI) then GuiTestData.PwrDataSpi := m_PwrDataSpi;
  //
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(GuiTestData);
  ccd.lpData      := @GuiTestData;
  SendMessage(m_hTestFrm,WM_COPYDATA,0, LongInt(@ccd));

  {$IFDEF INSPECTOR_POCB}
  if (nGuiMode = DefPocb.MSG_MODE_DISPLAY_CONNECTION) then begin //POCB(SystemNG-Message)
    SendMainGuiDisplay(nGuiMode,sMsg, nParam);
  end;
	{$ENDIF}
end;
procedure TDongaPG.ShowPgBmpDownStatus(nGuiType, curPos, total: Integer; sMsg: string; bIsDone: Boolean = False);	//POCB(Setup/BmpDownload)
var
  ccd       : TCopyDataStruct;
  GuiPgDown : TGuiPgDownData;
begin
  GuiPgDown.MsgType := DefPocb.MSG_TYPE_PG;
  GuiPgDown.PgNo    := m_nPgNo;
  GuiPgDown.sMsg    := sMsg;
  GuiPgDown.Mode    := nGuiType;
  GuiPgDown.Total   := total;
  GuiPgDown.CurPos  := curPos;
  GuiPgDown.IsDone  := bIsDone; //TBD:MERGE? FoldFI(ShowSpiDownLoadStatus:O) POCB(X)
  //
  ccd.dwData := 0;
  ccd.cbData := SizeOf(GuiPgDown);
  ccd.lpData := @GuiPgDown;
  SendMessage(Self.m_hGuiFrm,WM_COPYDATA,0, LongInt(@ccd));
end;

procedure TDongaPG.ShowSpiDownLoadStatus(nGuiType,curPos, total: Integer; sMsg: string;bIsDone: Boolean=False);
var
  ccd       : TCopyDataStruct;
  GuiPgDown : TGuiPgDownData;
begin
  GuiPgDown.MsgType := DefPocb.MSG_TYPE_PG;
  GuiPgDown.PgNo    := m_nPgNo;
  GuiPgDown.sMsg    := sMsg;
  GuiPgDown.Mode    := nGuiType;
  GuiPgDown.Total   := total;
  GuiPgDown.CurPos  := curPos;
  GuiPgDown.IsDone  := bIsDone;
  //
  ccd.dwData := 0;
  ccd.cbData := SizeOf(GuiPgDown);
  ccd.lpData := @GuiPgDown;
  SendMessage(Self.m_hGuiFrm,WM_COPYDATA,0, LongInt(@ccd));
end;

end.
