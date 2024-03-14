unit SystemSetup;

interface
{$I Common.inc}

uses
  Winapi.Messages, Winapi.Windows,
  System.Classes, System.ImageList, System.SysUtils, System.Variants, System.UITypes,
  AdvObj, AdvGrid, BaseGrid, IniFiles, UserID,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.Controls, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.Graphics, Vcl.Grids, Vcl.ImgList, Vcl.Mask, Vcl.StdCtrls, Vcl.ToolWin,
  RzButton, RzCmboBx, RzEdit, RzLstBox, RzPanel, RzRadChk, RzShellDialogs, RzTabs, RzLabel,
  CommonClass, DefPocb, DefPG, DownloadBmpPg, DownloadFwPg, DownloadFwSpi, LogIn, PwdChange,
  DfsFtpPocb, FolderDialog;   //2019-01-23 DFS_FTP
type
  TfrmSystemSetup = class(TForm)
    pcSysConfig							: TRzPageControl;
    RztabSystemConfig: TRzTabSheet;
    btnSave									: TRzBitBtn;
    btnClose								: TRzBitBtn;
    // SYSTEM
    RzgrpSystem							: TRzGroupBox;
    RzpnlStationID					: TRzPanel;
    RzpnlUIType							: TRzPanel;
    RzpnlLanguage						: TRzPanel;
    edStationID							: TRzEdit;
    cmbxUIType							: TRzComboBox;
    cmbxLanguage						: TRzComboBox;
    btnSysConfPwdSetupAdmin: TRzBitBtn;
    btnSysConfPgBmpDown     : TRzBitBtn;
    btnSysConfPgFwDown      : TRzBitBtn;
    // Compensation Files Share Folder
    RzgrpShareFolder				: TRzGroupBox;
    btnSharefolder					: TRzBitBtn;
    edSharefolder						: TRzEdit;
    dlgOpen									: TRzSelectFolderDialog;
    // Auto Backup
    RzgrpAutoBackup					: TRzGroupBox;
    cbAutoBackup						: TRzCheckBox;
    btnAutoBackup						: TRzBitBtn;
    edAutoBackup						: TRzEdit;
    // Channel Usage
    RzgrpUseCh							: TRzGroupBox;
    cbUseCh1								: TRzCheckBox;
    cbUseCh2								: TRzCheckBox;
    // Serial Port
    RzgrpSerialSetting			: TRzGroupBox;
    RzpnlBCR								: TRzPanel;
    RzpnlRCB1								: TRzPanel;
    RzpnlRCB2								: TRzPanel;
    RzpnlExLight: TRzPanel;
    RzpnlEFU: TRzPanel;
    cmbxBCR									: TRzComboBox;
    cmbxRCB1								: TRzComboBox;
    cmbxRCB2								: TRzComboBox;
    cmbxExLight: TRzComboBox;
    cmbxEFU: TRzComboBox;
    // Etc, Gage RR
  //cbSysConfPwrLogUse			: TRzCheckBox;  //TBD:A2CHv3:A2CHv2:GRR?
  //RzgrpGRR								: TRzGroupBox;  //TBD:A2CHv3:A2CHv2:GRR?
//{$IFDEF USE_FPC_LIMIT}
    RzgrpFPCUsageLimit: TRzGroupBox;
    RzlblFpcUsageMaxTitle: TRzLabel;
    cbFpcUsageLimit: TRzCheckBox;
    edFpcUsageLimit: TRzEdit;
//{$ENDIF}
    // DFS_FTP
    il1                     : TImageList;
    RztabDfsConfig          : TRzTabSheet;
    RzgrpDfsFtpConfig       : TRzGroupBox;    // DFS FTP Config Setting
    cbDfsFtpUse             : TRzCheckBox;
    pnlDfsServerIP          : TRzPanel;
    pnlDfsUserName          : TRzPanel;
    pnlDfsPW                : TRzPanel;
    edDfsServerIP           : TRzEdit;
    edDfsUserName           : TRzEdit;
    edDfsPW                 : TRzEdit;
    btnLoadDfsConfig        : TBitBtn;
    btnDfsFtpConnect        : TRzBitBtn;     // DFS FTP Connect/Disconnect/Status
    btnDfsFtpDisconnect     : TRzBitBtn;
    pnlDfsFtpStatus         : TPanel;
    RzgrpDfsFtpFileUpload   : TRzGroupBox;   // DFS FTP File - Host/Local
    RzgrpDfsFtpHost         : TRzGroupBox;   // DFS FTP File - Host/Local - Host
    RzpnlDfsFtpHostCtrl     : TRzPanel;
    tlbDfsFtpHostBtns       : TToolBar;
    btnDfsFtpHostDirUp      : TToolButton;
    btnDfsFtpHostDirBack    : TToolButton;
    btnDfsFtpHostDirHome    : TToolButton;
    btnDfsFtpHostNull1      : TToolButton;
    btnDfsFtpHostFileDownload: TToolButton;
    btnDfsFtpHostNull2      : TToolButton;
    btnDfsFtpHostDirCreate  : TToolButton;
    btnDfsFtpHostFileDelete : TToolButton;
    edDfsFtpHostDirNow      : TEdit;
    btnDfsFtpHostDirGo      : TBitBtn;
    lstDfsFtpHostFiles      : TListBox;
    RzgrepDfsFtpLocal       : TRzGroupBox;   // DFS FTP File - Host/Local - Local
    RzpnlDfsFtpLocalCtrl    : TRzPanel;
    tlbDfsFtpLocalBtns      : TToolBar;
    btnDfsFtpLocalDirUp     : TToolButton;
    btnDfsFtpLocalDirBack   : TToolButton;
    btnDfsFtpLocalDirHome   : TToolButton;
    btnDfsFtpLocalNull1     : TToolButton;
    btnDfsFtpLocalFileUpload: TToolButton;
    btnDfsFtpLocalNull2     : TToolButton;
    btnDfsFtpLocalDirCreate : TToolButton;
    btnDfsFtpLocalFileDelete: TToolButton;
    edDfsFtpLocalDirNow     : TEdit;
    btnDfsFtpLocalDirGo     : TBitBtn;
    lstDfsFtpLocalFiles     : TListBox;
    btnDfsFtpHost2LocalDownload : TRzBitBtn;
    btnDfsFtpLocal2HostUpload   : TRzBitBtn;
    cbDfsHexCompress: TRzCheckBox;
    cbDfsHexDelete: TRzCheckBox;
    cbUseCombiDown: TRzCheckBox;
    RzpnlCombiPath: TRzPanel;
    edCombiDownPath: TRzEdit;
    RztabMesEasConfig: TRzTabSheet;
    RzgrpGmes: TRzGroupBox;
    RzpnlGmesServicePort: TRzPanel;
    RzpnlGmesNetwork: TRzPanel;
    RzpnlGmesDeamonPort: TRzPanel;
    edGmesServicePort: TRzEdit;
    edGmesNetwork: TRzEdit;
    edGmesDeamonPort: TRzEdit;
    RzpnlGmesLocalSubject: TRzPanel;
    RzpnlGmesRemoteSubject: TRzPanel;
    edGmesLocalSubject: TRzEdit;
    edGmesRemoteSubject: TRzEdit;
    cbGmesUseEQCC: TRzCheckBox;
    RzpnlGmesEqccInterval: TRzPanel;
    edGmesEqccInterval: TRzEdit;
    RzpnlGmesEqccIntMsec: TRzPanel;
    btnGmesLoadConfig: TRzBitBtn;
    RzgrpEAS: TRzGroupBox;
    RzpnlEasServicePortTilte: TRzPanel;
    RzpnlEasNetworkTitle: TRzPanel;
    RzpnlEasSaemonPortTitle: TRzPanel;
    edEasServicePort: TRzEdit;
    edEasNetwork: TRzEdit;
    edEasDeamonPort: TRzEdit;
    RzpnlEasRemoteSubjectTitle: TRzPanel;
    edEasRemoteSubject: TRzEdit;
    cbEasUseAPDR: TRzCheckBox;
    RzpnlIonizer1: TRzPanel;
    cmbxION1: TRzComboBox;
    RzpnlIonizer2: TRzPanel;
    cmbxION2: TRzComboBox;
    RzpnlEasLocalSubjectTitle: TRzPanel;
    edEasLocalSubject: TRzEdit;
    cbGmesUseGib: TRzCheckBox;
    RzGroupBox1: TRzGroupBox;
    chkSerialMatch: TRzCheckBox;
    RzPanel2: TRzPanel;
    edSerialMatch: TRzEdit;
    btnMatchSerialFolder: TRzBitBtn;
    edMatchSerialFolder: TRzEdit;
    RzgrpSysConfEtc: TRzGroupBox;
    RzpnlScreenSaver: TRzPanel;
    edScreenSaverTime: TRzEdit;
    chkConfirmHost: TRzCheckBox;
    dlgSelectFile: TFileOpenDialog;
    Label1: TLabel;
    Max1000: TLabel;
    RzgrpGRR: TRzGroupBox;
    cbUseGRR: TRzCheckBox;
    RztabRobotCOnfig: TRzTabSheet;
    RzgrpRobotComm: TRzGroupBox;
    RzpnlRobot1IPAddr: TRzPanel;
    RzpnlRobot2IPAddr: TRzPanel;
    RzpnlRobotModbusTcpPort: TRzPanel;
    edRobot1IPAddr: TRzEdit;
    edRobot2IPAddr: TRzEdit;
    edRobotModbusTcpPort: TRzEdit;
    RzpnlRobotCmdTcpPort: TRzPanel;
    edRobotCommandTcpPort: TRzEdit;
    RzgrpRobotTcpCommands: TRzGroupBox;
    RzpnlRobotCmdReady: TRzPanel;
    RzpnlRobotMoveHome: TRzPanel;
    RzpnlRobotCmdMoveRelative: TRzPanel;
    edRobotCmdReadyCheck: TRzEdit;
    RzpnlRobotCmdMoveToHome: TRzEdit;
    edRobotCmdMoveRelative: TRzEdit;
    RzpnlRobotCmdMoveToStandby: TRzPanel;
    edRobotCmdMoveToStdLight: TRzEdit;
    cmbxION1_2: TRzComboBox;
    cmbxION2_2: TRzComboBox;
    btnSysConfSpiDownload: TRzBitBtn;
    grpPgSpiOptions: TRzGroupBox;
    RzpnlPgType: TRzPanel;
    cmbxPgType: TRzComboBox;
    RzpnlSpiType: TRzPanel;
    cmbxSpiType: TRzComboBox;
    RzgrpAssyPOCB: TRzGroupBox;
    cbUseAssyPOCB: TRzCheckBox;
    cbUseSkipPocbConfirm: TRzCheckBox;
    RztabLensMesConfig: TRzTabSheet;
    RzgrpLensMesConfig: TRzGroupBox;
    RzpnlLenMesSite: TRzPanel;
    RzpnlLensMesUrlIF: TRzPanel;
    RzpnlLensMesUrlToken: TRzPanel;
    edLenMesSite: TRzEdit;
    edLensMesUrlIF: TRzEdit;
    edLensMesUrlLogin: TRzEdit;
    RzpnlLensMesUrlStart: TRzPanel;
    RzpnlLensMesUrlEnd: TRzPanel;
    edLensMesUrlStart: TRzEdit;
    edLensMesUrlEnd: TRzEdit;
    RzpnlLensMesWaitSec: TRzPanel;
    edLensMesWaitSec: TRzEdit;
    btnLensMesLoadConfig: TRzBitBtn;
    cbLensMesGIB: TRzCheckBox;
    cbLensMesConfirmHost: TRzCheckBox;
    RzpnlLensMesOperation: TRzPanel;
    RzpnlLensMesMO: TRzPanel;
    RzpnlLensMesITEM: TRzPanel;
    RzpnlLensMesSHIFT: TRzPanel;
    edLensMesSHIFT: TRzEdit;
    edLensMesITEM: TRzEdit;
    edLensMesMO: TRzEdit;
    edLensMesOperation: TRzEdit;
    RzpnlLensMesTimeoutSec: TRzLabel;
    RzpnlLensMesUrlEqStatus: TRzPanel;
    edLensMesUrlEqStatus: TRzEdit;
    RzpnlLensMesUrlReInput: TRzPanel;
    edLensMesUrlReInput: TRzEdit;
    btnSysConfPwdSetupPM: TRzBitBtn;
    RzpnlIdlePmModeLogInPopUp: TRzPanel;
    edIdlePmModeLogInPopUpTime: TRzNumericEdit;

		//
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
		//
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
		//
    procedure btnSysConfPwdSetupAdminClick(Sender: TObject);
    procedure btnSysConfPwdSetupPMClick(Sender: TObject);
    procedure btnSysConfPgBmpDownClick(Sender: TObject);
    procedure btnSysConfPgFwDownClick(Sender: TObject);
    procedure btnAutoBackupClick(Sender: TObject);
    procedure cbAutoBackupClick(Sender: TObject);
    procedure btnSharefolderClick(Sender: TObject);
    procedure btnGmesLoadConfigClick(Sender: TObject);
    procedure btnGmesNGSetupClick(Sender: TObject);
    procedure FindItemToListbox(tList: TRzListbox; sItem: string);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
//{$IFDEF USE_FPC_LIMIT}
    procedure cbFpcUsageLimitClick(Sender: TObject);
//{$ENDIF}
//{$IFDEF DFS_HEX}
    procedure btnDfsFtpConnectClick(Sender: TObject);
    procedure btnDfsFtpDisconnectClick(Sender: TObject);
		procedure btnDfsFtpHostDirUpClick(Sender: TObject);
    procedure btnDfsFtpHostDirBackClick(Sender: TObject);
    procedure btnDfsFtpHostDirHomeClick(Sender: TObject);
    procedure btnDfsFtpHostFileDownloadClick(Sender: TObject);
    procedure btnDfsFtpHostDirCreateClick(Sender: TObject);
    procedure btnDfsFtpHostFileDeleteClick(Sender: TObject);
    procedure btnDfsFtpHostDirGoClick(Sender: TObject);
    procedure lstDfsFtpHostFilesDblClick(Sender: TObject);
    procedure btnDfsFtpLocalDirUpClick(Sender: TObject);
    procedure btnDfsFtpLocalDirBackClick(Sender: TObject);
    procedure btnDfsFtpLocalDirHomeClick(Sender: TObject);
    procedure btnDfsFtpLocalFileUploadClick(Sender: TObject);
    procedure btnDfsFtpLocalDirCreateClick(Sender: TObject);
    procedure btnDfsFtpLocalFileDeleteClick(Sender: TObject);
    procedure btnDfsFtpLocalDirGoClick(Sender: TObject);
    procedure lstDfsFtpLocalFilesDblClick(Sender: TObject);
    procedure btnDfsFtpHost2LocalDownloadClick(Sender: TObject);
    procedure btnDfsFtpLocal2HostUploadClick(Sender: TObject);
    procedure btnMatchSerialFolderClick(Sender: TObject);
    procedure btnSysConfSpiDownloadClick(Sender: TObject);
//{$ENDIF}

  private
    // Added by ClintPark 2019-01-11 DFS functions.
    FHostLastDirStack   : TStringList;
    FHostRootDir        : String;
    FLocalLastDirStack  : TStringList;
    FLocalRootDir       : String;
    procedure ShowSystemInfo;
//{$IFDEF DFS_HEX}
    procedure ChangeFTPDir(NewDir : String);
    procedure ChangeLocalDir(NewDir: string);
    procedure DisplayFTP;
    procedure DisplayLocal;
    procedure FtpConnection(bConn : Boolean);
//{$ENDIF}
  public
    { Public declarations }
  end;

var
  frmSystemSetup: TfrmSystemSetup;

implementation

{$R *.dfm}

uses DefRobot;

//******************************************************************************
// procedure/function:
//******************************************************************************

procedure TfrmSystemSetup.FormCreate(Sender: TObject);
begin
  Common.MLog(DefPocb.SYS_LOG,'<SETUP> Window Open');
{$IFDEF SITE_LENSVN}
  btnSysConfPwdSetupPM.Visible := True;
{$ENDIF}
  ShowSystemInfo;
end;

procedure TfrmSystemSetup.FormDestroy(Sender: TObject);
begin
//Self := nil;
end;

procedure TfrmSystemSetup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  //2019-02-08 DFS_FTP (Setup√¢ CloseΩ√)
  if DfsFtpCommon <> nil then begin
    if DfsFtpCommon.IsConnected then DfsFtpCommon.DisConnect;
    DfsFtpCommon.Free;
    DfsFtpCommon := nil;
  end;
  FHostLastDirStack.Free;
  FHostLastDirStack := nil;
  FLocalLastDirStack.Free;
  FLocalLastDirStack := nil;
end;

procedure TfrmSystemSetup.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if DfsFtpCommon <> nil then begin
    if DfsFtpCommon.IsConnected then DfsFtpCommon.DisConnect;
    DfsFtpCommon.Free;
    DfsFtpCommon := nil;
  end;
  FHostLastDirStack.Free;
  FHostLastDirStack := nil;
  FLocalLastDirStack.Free;
  FLocalLastDirStack := nil;
  CanClose := True;
  //
  Common.MLog(DefPocb.SYS_LOG,'<SETUP> Window Close');
end;

procedure TfrmSystemSetup.FormShow(Sender: TObject);
begin
  pcSysConfig.ActivePage := RztabSystemConfig;
end;

//******************************************************************************
// procedure/function:
//******************************************************************************

procedure TfrmSystemSetup.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSystemSetup.btnSaveClick(Sender: TObject);
var
  nTemp : Integer;
begin
  Common.MLog(DefPOCB.SYS_LOG,'<SETUP> Save Clicked');
  with Common.SystemInfo do begin
    // SYSTEM
    EQPId           := edStationID.Text;
    UIType 		    	:= cmbxUIType.itemIndex;
    Language      	:= cmbxLanguage.ItemIndex;
    // PG/SPI Board
  //PGSPI_MAIN     	:= cmbxPgSpiMain.ItemIndex;
    PG_TYPE       	:= cmbxPgType.ItemIndex;
    SPI_TYPE       	:= cmbxSpiType.ItemIndex;
    // Compensation File Share Folder
    ShareFolder   	:= edSharefolder.Text;  //2019-02-08
    // Match Serial Folder
    MatchSerialFolder := edMatchSerialFolder.Text;
    // Auto Backup
    AutoBackupUse  	:= cbAutoBackup.Checked;
    AutoBackupList 	:= edAutoBackup.Text;
    // CH Use
    UseCh[DefPocb.CH_1] := cbUseCh1.Checked;
    UseCh[DefPocb.CH_2] := cbUseCh2.Checked;
    // Serial Port Setting
    Com_HandBCR   					:= cmbxBCR.ItemIndex;
    Com_RCB[DefPocb.JIG_A] 	:= cmbxRCB1.ItemIndex;
    Com_RCB[DefPocb.JIG_B] 	:= cmbxRCB2.ItemIndex;
    {$IF Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
    if Common.SystemInfo.IonizerCntPerCH = 2 then begin
      Com_ION[0] := cmbxION1.ItemIndex;    //JIG_A
      Com_ION[1] := cmbxION1_2.ItemIndex;
      Com_ION[2] := cmbxION2.ItemIndex;    //JIG_B
      Com_ION[3] := cmbxION2_2.ItemIndex;
    end
    else begin
      Com_ION[0] := cmbxION1.ItemIndex;   //JIG_A
      Com_ION[1] := cmbxION2.ItemIndex;   //JIG_B
      Com_ION[2] := 0;
      Com_ION[3] := 0;
    end;
    {$ELSE}
      Com_ION[DefPocb.JIG_A] := cmbxION1.ItemIndex;   //JIG_A
      Com_ION[DefPocb.JIG_B] := cmbxION2.ItemIndex;   //JIG_B
    {$ENDIF}
    Com_ExLight             := cmbxExLight.ItemIndex; //2019-04-17 ExLight
 	  Com_EFU                 := cmbxEFU.ItemIndex;     //2019-05-02 EFU

{$IFDEF SITE_LENSVN}
    // LENS MES (HTTP/JSON)
    LensMesUrlIF        := Trim(edLensMesUrlIF.Text);
    LensMesUrlLogin     := Trim(edLensMesUrlLogin.Text);
    LensMesUrlStart     := Trim(edLensMesUrlStart.Text);
    LensMesUrlEnd       := Trim(edLensMesUrlEnd.Text);
    LensMesUrlEqStatus  := Trim(edLensMesUrlEqStatus.Text);
    LensMesUrlReInput   := Trim(edLensMesUrlReInput.Text);
    LenMesSITE          := Trim(edLenMesSITE.Text);
    LensMesOPERATION    := Trim(edLensMesOPERATION.Text);
    LensMesMO           := Trim(edLensMesMO.Text);
    LensMesITEM         := Trim(edLensMesITEM.Text);
    LensMesSHIFT        := Trim(edLensMesSHIFT.Text);
    LensMesWaitSec      := StrToIntDef(Trim(edLensMesWaitSec.Text),5);
{$ELSE}
    // LGD GMES
    MES_ServicePort   := edGmesServicePort.Text;
    MES_Network       := edGmesNetwork.Text;
    MES_DaemonPort    := edGmesDeamonPort.Text;
    MES_LocalSubject  := edGmesLocalSubject.Text;
    MES_RemoteSubject := edGmesRemoteSubject.Text;
    EqccInterval      := edGmesEqccInterval.Text;
    UseEQCC           := cbGmesUseEQCC.Checked;
{$ENDIF}

{$IFDEF SITE_LENSVN}
    UseGIB         := cbLensMesGIB.Checked;
    UseConfirmHost := cbLensMesConfirmHost.Checked;
{$ELSE}
    UseGIB         := cbGmesUseGIB.Checked;  //2019-11-08
    UseConfirmHost := chkConfirmHost.Checked;
{$ENDIF}

{$IFDEF SUPPORT_1CG2PANEL}
    UseAssyPOCB   := cbUseAssyPOCB.Checked;  //A2CHv3:ASSY-POCB
    if UseAssyPOCB then UseSkipPocbConfirm := cbUseSkipPocbConfirm.Checked else UseSkipPocbConfirm := False; //A2CHv3:ASSY-POCB //2022-06-XX
{$ENDIF}

    UseGRR        := cbUseGRR.Checked;
    UseSeialMatch := chkSerialMatch.Checked;
    PrevSerial    := StrToIntDef(Trim(edSerialMatch.Text),200);
    if PrevSerial > 1000 then PrevSerial := 1000;
    ScreenSaverTime := StrToIntDef(Trim(edScreenSaverTime.Text),30);

    IdlePmModeLogInPopUpTime := StrToIntDef(Trim(edIdlePmModeLogInPopUpTime.Text),30); //2023-10-12 IDLE_PMMODE_LOGIN_POPUP (0:Disable, 10~)
    if (IdlePmModeLogInPopUpTime > 0) and (IdlePmModeLogInPopUpTime < 10) then begin //(0:Disable, 10~)
      IdlePmModeLogInPopUpTime := 10;
      edIdlePmModeLogInPopUpTime.Text := IntToStr(IdlePmModeLogInPopUpTime);
    end;

  {$IFDEF USE_EAS}
    EAS_UseAPDR       := cbEasUseAPDR.Checked;
    EAS_ServicePort   := edEasServicePort.Text;
    EAS_Network       := edEasNetwork.Text;
    EAS_DaemonPort    := edEasDeamonPort.Text;
    EAS_LocalSubject  := edEasLocalSubject.Text;  //2019-11-08
    EAS_RemoteSubject := edEasRemoteSubject.Text;
  {$ENDIF}
    // GRR
    // ETC ?? TBD??
		//
{$IFDEF USE_FPC_LIMIT}
    // FPC Usage Limit //2019-04-11
    FPCUsageLimitUse   := cbFPCUsageLimit.Checked;
    FPCUsageLimitValue := StrToIntDef(edFPCUsageLimit.Text,0);
{$ENDIF}
  end;
{$IFDEF DFS_HEX}
  with Common.DfsConfInfo do begin
    bUseDfs         := cbDfsFtpUse.Checked;
    bDfsHexCompress := cbDfsHexCompress.Checked;
    bDfsHexDelete   := cbDfsHexDelete.Checked;
    sDfsServerIP    := edDfsServerIP.Text;
    sDfsUserName    := edDfsUserName.Text;
    sDfsPassword    := edDfsPW.Text;
    //
    bUseCombiDown   := cbUseCombiDown.Checked;
    sCombiDownPath  := edCombiDownPath.Text;
  end;
{$ENDIF}

{$IFDEF HAS_ROBOT_CAM_Z}
  with Common.RobotSysInfo do begin  //A2CHv3:ROBOT
  //MyIpAddr                                              // [ROBOT_DATA] RobotMyIpAddr
    IPAddr[DefPocb.JIG_A] := edRobot1IPAddr.Text;         // [ROBOT_DATA] Robot1IPAddr
    IPAddr[DefPocb.JIG_B] := edRobot2IPAddr.Text;         // [ROBOT_DATA] Robot2IAddr
    TcpPortModbus         := StrToIntDef(edRobotModbusTcpPort.Text, DefRobot.ROBOT_TCPPORT_MODBUS);     // [ROBOT_DATA] RobotTcpPortModbus
    TcpPortListenNode     := StrToIntDef(edRobotCommandTcpPort.Text,DefRobot.ROBOT_TCPPORT_LISTENNODE); // [ROBOT_DATA] RobotTcpPortListenNode
  //SpeedMax                                              // [ROBOT_DATA] RobotSpeedMax
  //StartupMoveType                                       // [ROBOT_DATA] RobotStartupMoveType // 0:NONE(default), 1:HOME, 2:MODEL
  //HomeCoord[DefPocb.JIG_A] := { };                      // [ROBOT_DATA] Robot1HomeCoord_X/Y/Z/Rx/Ry/Rz
  //HomeCoord[DefPocb.JIG_B] := { };                      // [ROBOT_DATA] Robot2HomeCoord_X/Y/Z/Rx/Ry/Rz
  end;
{$ENDIF}

  Common.SaveSystemInfo;
  Common.m_bNeedInitial := True;
  MessageDlg('Save OK. Start This Program again.', mtInformation, [mbOk], 0);
end;

//******************************************************************************
// procedure/function: 
//******************************************************************************

procedure TfrmSystemSetup.btnSysConfPwdSetupAdminClick(Sender: TObject);
begin
  if TfrmLogIn.CheckAdminPasswd then begin
    frmChangePassword := TfrmChangePassword.Create(Application,DefPocb.PWD_TYPE_ADMIN);
    try
      frmChangePassword.ShowModal;
    finally
      frmChangePassword.Free;
      frmChangePassword := nil;
    end;
  end;
end;

procedure TfrmSystemSetup.btnSysConfPwdSetupPMClick(Sender: TObject);
begin
  if TfrmLogIn.CheckAdminPasswd then begin
    frmChangePassword := TfrmChangePassword.Create(Application,DefPocb.PWD_TYPE_PM);
    try
      frmChangePassword.ShowModal;
    finally
      frmChangePassword.Free;
      frmChangePassword := nil;
    end;
  end;
end;

procedure TfrmSystemSetup.btnSysConfSpiDownloadClick(Sender: TObject);
begin
  frmDownloadFwSpi :=  TfrmDownloadFwSpi.Create(nil);
  try
    frmDownloadFwSpi.ShowModal;
  finally
    frmDownloadFwSpi.Free;
    frmDownloadFwSpi := nil;
  end;
end;

procedure TfrmSystemSetup.btnSysConfPgBmpDownClick(Sender: TObject);
begin
{$IFDEF REF_SDIP}
  if TfrmLogIn.CheckAdminPasswd then begin
{$ENDIF}
    Common.Make_Bmp_List;
    Common.Delay(500);

    frmDownloadBmpPg := TfrmDownloadBmpPg.Create(Application);  //#TfrmFileTrans
    try
      frmDownloadBmpPg.ShowModal;
    finally
      frmDownloadBmpPg.Free;
      frmDownloadBmpPg := nil;
    end;
{$IFDEF REF_SDIP}
  end;
{$ENDIF}
end;

procedure TfrmSystemSetup.btnSysConfPgFwDownClick(Sender: TObject);
begin
  frmDownloadFwPg :=  TfrmDownloadFwPg.Create(nil);
  try
    frmDownloadFwPg.ShowModal;
  finally
    frmDownloadFwPg.Free;
    frmDownloadFwPg := nil;
  end;
end;

procedure TfrmSystemSetup.cbAutoBackupClick(Sender: TObject);
begin
  btnAutoBackup.Enabled := cbAutoBackup.Checked;
end;

{$IFDEF USE_FPC_LIMIT}
procedure TfrmSystemSetup.cbFpcUsageLimitClick(Sender: TObject);
begin
  edFpcUsageLimit.Enabled := cbFpcUsageLimit.Checked;
end;
{$ELSE}
procedure TfrmSystemSetup.cbFpcUsageLimitClick(Sender: TObject);
begin
end;
{$ENDIF}

procedure TfrmSystemSetup.btnAutoBackupClick(Sender: TObject);
begin
//dlgOpen.InitialDir := 'D:\';
  if dlgOpen.Execute then begin
    edAutoBackup.Text := dlgOpen.SelectedPathName;
  end;
end;

procedure TfrmSystemSetup.btnSharefolderClick(Sender: TObject);
begin
  //if dlgOpen.Execute then begin
  if dlgSelectFile.Execute then begin
    edSharefolder.Text := dlgSelectFile.FileName+'\';
  end;
end;

procedure TfrmSystemSetup.btnGmesLoadConfigClick(Sender: TObject);
var
  txFile : TextFile;
  sReadData, sTemp, sTemp2, sSearchIp : string;
begin
{$IFDEF NEW_XXXXX}  //2019-06-25
  dlgOpenGmes.InitialDir := Common.Path.Ini;
  dlgOpenGmes.Filter := 'Open GMES Setup File (*.txt)|*.txt';
  dlgOpenGmes.DefaultExt := dlgOpenGmes.Filter;
  if dlgOpenGmes.Execute then begin
    AssignFile(txFile,dlgOpenGmes.FileName);
    sSearchIp := '';
    try
      Reset(txFile);
      while not Eof(txFile) do begin
        Readln(txFile,sReadData);
        if Pos('MES_SERVICEPORT=',sReadData) <> 0 then begin
          sTemp := Trim(StringReplace(sReadData,'MES_SERVICEPORT=','',[rfReplaceAll]) );
          edGmesServicePort.Text := sTemp;
        end
        else if Pos('MES_NETWORK=',sReadData) <> 0 then begin
          sTemp := Trim(StringReplace(sReadData,'MES_NETWORK=','',[rfReplaceAll]) );
          edGmesNetwork.Text := sTemp;
        end
        else if Pos('MES_DAEMONPORT=',sReadData) <> 0 then begin
          sTemp := Trim(StringReplace(sReadData,'MES_DAEMONPORT=','',[rfReplaceAll]) );
          edGmesDeamonPort.Text := sTemp;
        end
        else if Pos('EAS_SERVICEPORT=',sReadData) <> 0 then begin
          sTemp := Trim(StringReplace(sReadData,'EAS_SERVICEPORT=','',[rfReplaceAll]) );
          edEasServicePort.Text := sTemp;
        end
        else if Pos('EAS_NETWORK=',sReadData) <> 0 then begin
          sTemp := Trim(StringReplace(sReadData,'EAS_NETWORK=','',[rfReplaceAll]) );
          edEasNetwork.Text := sTemp;
        end
        else if Pos('EAS_DAEMONPORT=',sReadData) <> 0 then begin
          sTemp := Trim(StringReplace(sReadData,'EAS_DAEMONPORT=','',[rfReplaceAll]) );
          edEasDeamonPort.Text := sTemp;
        end
        else if Pos('EAS_LOCALSUBJECT=',sReadData) <> 0 then begin  //2019-11-08
          sTemp := Trim(StringReplace(sReadData,'EAS_LOCALSUBJECT=','',[rfReplaceAll]) );
          edEasLocalSubject.Text := sTemp;
        end
        else if Pos('EAS_REMOTESUBJECT=',sReadData) <> 0 then begin
          sTemp := Trim(StringReplace(sReadData,'EAS_REMOTESUBJECT=','',[rfReplaceAll]) );
          edEasRemoteSubject.Text := sTemp;
        end

        else if Pos('LOCAL_MES_IP=',sReadData) <> 0 then begin
          sSearchIp := Trim(StringReplace(sReadData,'LOCAL_MES_IP=','',[rfReplaceAll]) );
        end
        else if Pos('MES_LOCALSUBJECT=',sReadData) <> 0 then begin
          sTemp := Trim(Common.GetLocalIpList(DefPocb.IP_LOCAL_GMES,sSearchIp));
          Common.SystemInfo.LocalIP_GMES := sTemp;
          Common.SaveLocalIpToSys(DefPocb.IP_LOCAL_GMES);
          sTemp2 := StringReplace( sTemp,'.','_',[rfReplaceAll] );
          sTemp := Trim(StringReplace(sReadData,'MES_LOCALSUBJECT=','',[rfReplaceAll]) );
          edGmesLocalSubject.Text := sTemp + sTemp2;
        end
        else if Pos('MES_REMOTESUBJECT=',sReadData) <> 0 then begin
          sTemp := Trim(StringReplace(sReadData,'MES_REMOTESUBJECT=','',[rfReplaceAll]) );
          edGmesRemoteSubject.Text := sTemp;
        end;
      end;
    finally
      CloseFile(txFile);
    end;
  end;
{$ENDIF}  //2019-06-25
end;

procedure TfrmSystemSetup.btnGmesNGSetupClick(Sender: TObject);
begin
//  Common.MLog('<SEQ> Quality Code Environment Setting Dialog Open!');
 {$IFDEF WIN32}
  ShowCodeSetDlg(5);
 {$ENDIF}
end;

procedure TfrmSystemSetup.btnMatchSerialFolderClick(Sender: TObject);
begin
  //if dlgOpen.Execute then begin
  if dlgSelectFile.Execute then begin
    edMatchSerialFolder.Text := dlgSelectFile.FileName+'\';
  end;
end;

procedure TfrmSystemSetup.FindItemToListbox(tList: TRzListbox; sItem: string);
var
  i : Integer;
begin
  if DfsFtpCommon <> nil then DfsFtpCommon.IsSetUpWindow := False;

  for i := 0 to tList.Items.Count - 1 do begin
    if tList.Items.Strings[i] = sItem then begin
      tList.ItemIndex := i;
      Break;
    end;
  end;
end;

//******************************************************************************
// procedure/function:
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] TfrmSystemSetup.ShowSystemInfo; 
//      Called-by: procedure TfrmSystemSetup.FormCreate(Sender: TObject);
//
procedure TfrmSystemSetup.ShowSystemInfo;   // DisplaySystemInfo -> ShowSystemInfo
begin
  FHostLastDirStack := TStringList.Create;
  FLocalLastDirStack := TStringList.Create;

  with Common.SystemInfo do begin
    // SYSTEM
    edStationID.Text      	:= EQPId;
    cmbxUIType.ItemIndex  	:= UIType;
    cmbxLanguage.ItemIndex	:= Language;
    {$IFDEF SUPPORT_1CG2PANEL}
    RzgrpAssyPOCB.Visible   := True;
    {$ELSE}
    RzgrpAssyPOCB.Visible   := False;
    {$ENDIF}
    // PG/SPI Board
  //{$IF Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
    {$IF Defined(POCB_A2CHv4)}
    grpPgSpiOptions.Visible := True;
    {$ELSE}
    grpPgSpiOptions.Visible := False;
    {$ENDIF}
    cmbxPgType.ItemIndex    := PG_TYPE;
    cmbxSpiType.ItemIndex   := SPI_TYPE;
    btnSysConfSpiDownload.Visible := (SPI_TYPE <> DefPG.SPI_TYPE_DJ023_SPI);

    // Compensation File Share Folder
    edSharefolder.Text    	:= ShareFolder;
    // Match Serial Folder
    edMatchSerialFolder.Text:= MatchSerialFolder;
    // Auto Backup
    cbAutoBackup.Checked 		:= AutoBackupUse;
    edAutoBackup.Text     	:= AutoBackupList;
    btnAutoBackup.Enabled 	:= cbAutoBackup.Checked;
    edAutoBackup.Enabled 		:= cbAutoBackup.Checked;
    // CH Use
  //cbUseCh1.Checked        := UseCh[DefPocb.CH_1];   //TBD:GUI?
  //cbUseCh2.Checked        := UseCh[DefPocb.CH_2];   //TBD:GUI?
    // Serial Port Setting
    cmbxBCR.ItemIndex       := Com_HandBCR;
    cmbxRCB1.ItemIndex      := Com_RCB[DefPocb.JIG_A];
    cmbxRCB2.ItemIndex      := Com_RCB[DefPocb.JIG_B];
    if Common.SystemInfo.IonizerCntPerCH = 2 then begin
      cmbxION1.ItemIndex    := Com_ION[0];
      cmbxION1_2.ItemIndex  := Com_ION[1];
      cmbxION1_2.Visible    := True;
      cmbxION2.ItemIndex    := Com_ION[2];
      cmbxION2_2.ItemIndex  := Com_ION[3];
      cmbxION2_2.Visible    := True;
    end
    else begin
      cmbxION1.Width        := cmbxBCR.Width;
      cmbxION1.ItemIndex    := Com_ION[0];
      cmbxION1_2.Visible    := False;
      cmbxION1_2.ItemIndex  := 0;
      cmbxION2.Width        := cmbxBCR.Width;
      cmbxION2.ItemIndex    := Com_ION[1];
      cmbxION2_2.Visible    := False;
      cmbxION2_2.ItemIndex  := 0;
    end;
    cmbxExLight.ItemIndex   := Com_ExLight; //2019-04-17 ExLight
    cmbxEFU.ItemIndex       := Com_EFU;     //2019-05-02 EFU

    chkSerialMatch.Checked  := UseSeialMatch;
    edSerialMatch.Text      := Format('%d',[PrevSerial]);
    edScreenSaverTime.Text  := Format('%d',[ScreenSaverTime]);
    edIdlePmModeLogInPopUpTime.Text  := Format('%d',[IdlePmModeLogInPopUpTime]); //2023-10-12 IDLE_PMMODE_LOGIN_POPUP

{$IFDEF SITE_LENSVN}
    // LENS MES (HTTP/JSON)
    RztabMesEasConfig.TabVisible  := False;
    RztabDfsConfig.TabVisible     := False;
    RztabLensMesConfig.TabVisible := True;
    //
    edLensMesUrlIF.Text				:= LensMesUrlIF;
    edLensMesUrlLogin.Text		:= LensMesUrlLogin;
    edLensMesUrlStart.Text		:= LensMesUrlStart;
    edLensMesUrlEnd.Text			:= LensMesUrlEnd;
    edLensMesUrlEqStatus.Text	:= LensMesUrlEqStatus;
    edLensMesUrlReInput.Text	:= LensMesUrlReInput;
    edLenMesSITE.Text					:= LenMesSITE;
    edLensMesOPERATION.Text		:= LensMesOPERATION;
    edLensMesMO.Text					:= LensMesMO;
    edLensMesITEM.Text				:= LensMesITEM;
    edLensMesSHIFT.Text				:= LensMesSHIFT;
    edLensMesWaitSec.Text			:= IntToStr(LensMesWaitSec);
{$ELSE}
    // LGD MES
    RztabMesEasConfig.TabVisible  := True;
    RztabDfsConfig.TabVisible     := True;
    RztabLensMesConfig.TabVisible := False;
    //
    edGmesServicePort.Text  := MES_ServicePort;
    edGmesNetwork.Text      := MES_Network;
    edGmesDeamonPort.Text   := MES_DaemonPort;
    edGmesLocalSubject.Text := MES_LocalSubject;
    edGmesRemoteSubject.Text:= MES_RemoteSubject;
    edGmesEqccInterval.Text := EqccInterval;
    cbGmesUseEQCC.Checked   := UseEQCC;
{$ENDIF}

{$IFDEF SITE_LENSVN}
    cbLensMesGIB.Checked := UseGIB;
    cbLensMesConfirmHost.Checked := UseConfirmHost;
{$ELSE}
    cbGmesUseGIB.Checked := UseGIB;  //2019-11-08
    chkConfirmHost.Checked := UseConfirmHost;
{$ENDIF}

{$IFDEF SUPPORT_1CG2PANEL}
    cbUseAssyPOCB.Checked   := UseAssyPOCB;  //A2CHv3:ASSY-POCB
    if UseAssyPOCB then cbUseSkipPocbConfirm.Checked := UseSkipPocbConfirm else cbUseSkipPocbConfirm.Checked := False; //A2CHv3:ASSY-POCB //2022-06-XX
{$ENDIF}

    cbUseGRR.Checked        := UseGRR;
{$IFDEF USE_EAS}
    cbEasUseAPDR.Checked    := EAS_UseAPDR;
    edEasServicePort.Text   := EAS_ServicePort;
    edEasNetwork.Text       := EAS_Network;
    edEasDeamonPort.Text    := EAS_DaemonPort;
    if EAS_LocalSubject = '' then EAS_LocalSubject := MES_LocalSubject;
    edEasLocalSubject.Text  := EAS_LocalSubject;  //2019-11-08
    edEasRemoteSubject.Text := EAS_RemoteSubject;
{$ENDIF}

{$IFDEF USE_FPC_LIMIT}
    // FPC Usage Limit //2019-04-11
    cbFPCUsageLimit.Checked := FPCUsageLimitUse;
    edFPCUsageLimit.Text    := Format('%d',[FPCUsageLimitValue]);
    edFPCUsageLimit.Enabled := cbFPCUsageLimit.Checked;
    RzgrpFPCUsageLimit.Visible := True;
{$ELSE}
    RzgrpFPCUsageLimit.Visible := False;
{$ENDIF}
  end;

{$IFDEF DFS_HEX}
  RztabDfsConfig.TabVisible := True;
  with Common.DfsConfInfo do begin
    cbDfsFtpUse.Checked       := bUseDfs;      //2019-02-01 DFS_FTP
    cbDfsHexCompress.Checked  := bDfsHexCompress;
    cbDfsHexDelete.Checked    := bDfsHexDelete;
    edDfsServerIP.Text        := sDfsServerIP;
    edDfsUserName.Text        := sDfsUserName;
    edDfsPW.Text              := sDfsPassword;
    //
    cbUseCombiDown.Checked    := bUseCombiDown;
    edCombiDownPath.Text      := sCombiDownPath;
  end;
{$ELSE}
  RztabDfsConfig.TabVisible := False;
{$ENDIF}

{$IFDEF HAS_ROBOT_CAM_Z}
  RztabRobotConfig.TabVisible := True; // Hidden
  with Common.RobotSysInfo do begin
  //MyIpAddr                                              // [ROBOT_DATA] RobotMyIpAddr
    edRobot1IPAddr.Text        := IPAddr[DefPocb.JIG_A];  // [ROBOT_DATA] Robot1IPAddr
    edRobot2IPAddr.Text        := IPAddr[DefPocb.JIG_B];  // [ROBOT_DATA] Robot2IAddr
    edRobotModbusTcpPort.Text  := IntToStr(TcpPortModbus);     // [ROBOT_DATA] RobotTcpPortModbus
    edRobotCommandTcpPort.Text := IntToStr(TcpPortListenNode); // [ROBOT_DATA] RobotTcpPortListenNode
  //SpeedMax                                              // [ROBOT_DATA] RobotSpeedMax
  //StartupMoveType                                       // [ROBOT_DATA] RobotStartupMoveType // 0:NONE(default), 1:HOME, 2:MODEL
  //HomeCoord[DefPocb.JIG_A] := { };                      // [ROBOT_DATA] Robot1HomeCoord_X/Y/Z/Rx/Ry/Rz  //TBD:A2CHV3:ROBOT? (HomeCoord)
  //HomeCoord[DefPocb.JIG_B] := { };                      // [ROBOT_DATA] Robot2HomeCoord_X/Y/Z/Rx/Ry/Rz  //TBD:A2CHV3:ROBOT? (HomeCoord)
  end;
{$ENDIF}

end;

//******************************************************************************
// procedure/function: DFS FTP Connection
//******************************************************************************

procedure TfrmSystemSetup.btnDfsFtpConnectClick(Sender: TObject);
var
  sServerIP, sUserName, sPassword : string;
begin
{$IFDEF DFS_HEX}
  // DFS Server
  sServerIP := edDfsServerIP.Text;
  sUserName := edDfsUserName.Text;
  sPassword := edDfsPW.Text;
  if (DfsFtpCommon = nil) then begin
    // in case of PM Mode.
    DfsFtpCommon := TDfsFtp.Create(sServerIP, sUserName, sPassword, -1{nCh:dummy for DfsFtpCommon});
    DfsFtpCommon.IsConnectCheck := False;
  end;
  DfsFtpCommon.OnConnectedSetup := FtpConnection;
  DfsFtpCommon.IsSetUpWindow := True;
  if DfsFtpCommon.IsConnected then DfsFtpCommon.Disconnect;
  DfsFtpCommon.Connect;
  //
  RzgrpDfsFtpFileUpload.Visible := True;
{$ENDIF}
end;

procedure TfrmSystemSetup.btnDfsFtpDisconnectClick(Sender: TObject);
begin
{$IFDEF DFS_HEX}
  if DfsFtpCommon <> nil then begin
    DfsFtpCommon.Disconnect;
  end;
  RzgrpDfsFtpFileUpload.Visible := False;
{$ENDIF}
end;

procedure TfrmSystemSetup.FtpConnection(bConn: Boolean);
begin
{$IFDEF DFS_HEX}
  if bConn then begin
    pnlDfsFtpStatus.Caption := 'Connected';
    pnlDfsFtpStatus.Font.Color := clLime;
    FHostRootDir  := DfsFtpCommon.RetrieveCurrentDir;
    FLocalRootDir := Common.Path.DfsDefect;   //TBD? Common.SystemInfo.ShareFolder;
    edDfsFtpHostDirNow.Text := FHostRootDir;
    if (edDfsFtpHostDirNow.Text[Length(edDfsFtpHostDirNow.Text)] <> '/') then
      edDfsFtpHostDirNow.Text := edDfsFtpHostDirNow.Text + '/';
    edDfsFtpLocalDirNow.Text := FLocalRootDir + '\';
    if (edDfsFtpLocalDirNow.Text[Length(edDfsFtpLocalDirNow.Text)] <> '\') then
      edDfsFtpLocalDirNow.Text := edDfsFtpLocalDirNow.Text + '\';
    DisplayFTP;
    DisplayLocal;
  end
  else begin
    pnlDfsFtpStatus.Caption := 'Disonnected';
    pnlDfsFtpStatus.Font.Color := clRed;
  end;
{$ENDIF}
end;

//******************************************************************************
// procedure/function: DFS FTP Host/Local File
//******************************************************************************

procedure TfrmSystemSetup.btnDfsFtpHostDirBackClick(Sender: TObject);
var
  sTemp : String;
begin
  if FHostLastDirStack.Count > 0 then begin
    sTemp := FHostLastDirStack[FHostLastDirStack.Count -1];
    ChangeFTPDir(sTemp);
    // Delete S
    FHostLastDirStack.Delete(FHostLastDirStack.Count -1);
    // Delete the jump from S
    FHostLastDirStack.Delete(FHostLastDirStack.Count -1);
//    SetControls;
  end;
end;

procedure TfrmSystemSetup.btnDfsFtpLocalDirBackClick(Sender: TObject);
var
  sTemp : String;
begin
  if FLocalLastDirStack.Count > 0 then begin
    sTemp := FLocalLastDirStack[FLocalLastDirStack.Count -1];
    ChangeLocalDir(sTemp);
    // Delete S
    FLocalLastDirStack.Delete(FLocalLastDirStack.Count -1);
    // Delete the jump from S
    FLocalLastDirStack.Delete(FLocalLastDirStack.Count -1);
//    SetControls;
  end;
end;

procedure TfrmSystemSetup.btnDfsFtpHostDirHomeClick(Sender: TObject);
begin
  ChangeFTPDir(FHostRootDir);
end;

procedure TfrmSystemSetup.btnDfsFtpLocalDirHomeClick(Sender: TObject);
begin
  ChangeLocalDir(FLocalRootDir);
end;

procedure TfrmSystemSetup.btnDfsFtpLocalDirUpClick(Sender: TObject);
var
  i : Integer;
  slTemp : TStringList;
  sNewPath : string;
begin
  slTemp := TStringList.Create;
  try
    ExtractStrings(['\','/'],[], PWideChar(edDfsFtpLocalDirNow.Text), slTemp);
    if slTemp.Count > 0 then begin
      sNewPath := '';
      for i := 0 to (slTemp.Count-2) do begin
        sNewPath := sNewPath + slTemp[i] + '\';
      end;
    end;
    edDfsFtpLocalDirNow.Text := sNewPath;
    DisplayLocal;
  finally
    slTemp.Free;
  //slTemp := nil;
  end;
end;

procedure TfrmSystemSetup.btnDfsFtpHostDirUpClick(Sender: TObject);
begin
  DfsFtpCommon.ChangeDirUp;
  DisplayFTP;
end;

procedure TfrmSystemSetup.btnDfsFtpLocalDirCreateClick(Sender: TObject);
var
  sTemp : String;
begin
  sTemp := 'New Folder';
  if InputQuery('New folder', 'New folder name:', sTemp) then begin
    CreateDir(edDfsFtpLocalDirNow.Text + sTemp + '\');
    ChangeLocalDir(edDfsFtpLocalDirNow.Text + sTemp + '\');
  end;
end;

procedure TfrmSystemSetup.btnDfsFtpHostDirCreateClick(Sender: TObject);
var
  sTemp : String;
begin
  sTemp := 'New Folder';
  if InputQuery('New folder', 'New folder name:', sTemp) then begin
    DfsFtpCommon.MakeDir(sTemp);
    ChangeFTPDir(sTemp);
  end;
end;

procedure TfrmSystemSetup.btnDfsFtpLocalFileDeleteClick(Sender: TObject);
var
  i : Integer;
  sTemp : String;
begin
  try
    i := lstDfsFtpLocalFiles.ItemIndex;
  except
    ShowMessage('Please Select File.');
    exit;
  end;
  if i <> -1 then begin
    sTemp := lstDfsFtpLocalFiles.Items[i];
    if MessageDlg('Are you sure you want to delete ' + sTemp + '?', mtWarning, [mbYes,mbNo], 0) = mrYes then
      DeleteFile(edDfsFtpLocalDirNow.Text + sTemp);
    DisplayLocal;
  end
  else
    MessageDlg('You must first select a file or folder to delete from the site.', mtWarning, [mbOK], 0);
end;

procedure TfrmSystemSetup.btnDfsFtpHostFileDeleteClick(Sender: TObject);
var
  i : Integer;
  sTemp : String;
begin
  try
    i := lstDfsFtpHostFiles.ItemIndex;
  except
    ShowMessage('Please Select File.');
    exit;
  end;
  if i <> -1 then begin
    sTemp := lstDfsFtpHostFiles.Items[i];
    if MessageDlg('Are you sure you want to delete ' + sTemp + '?', mtWarning, [mbYes,mbNo], 0) = mrYes then
      DfsFtpCommon.Delete(sTemp);
    DisplayFTP;
  end
  else
    MessageDlg('You must first select a file or folder to delete from the site.', mtWarning, [mbOK], 0);
end;

procedure TfrmSystemSetup.btnDfsFtpHostFileDownloadClick(Sender: TObject);
var
  i, idx, nSize : Integer;
  //b : boolean;
  sTemp : String;
begin
  idx := -1;
  for i := 0 to Pred(lstDfsFtpHostFiles.Count) do begin
    if lstDfsFtpHostFiles.Selected[i] then begin
      idx := i;
      Break;
    end;
  end;

  if idx <> -1 then begin
    sTemp := lstDfsFtpHostFiles.Items[i];
    nSize := DfsFtpCommon.Size(sTemp);
    if nSize = -1 then
      ChangeFTPDir(sTemp)
    else begin
      if FileExists(edDfsFtpLocalDirNow.Text + sTemp) then
        if MessageDlg('File exists overwrite?', mtWarning, [mbYes,mbNo], 0) = mrYes then
          DeleteFile(edDfsFtpLocalDirNow.Text + sTemp);

      DfsFtpCommon.Get(sTemp, edDfsFtpLocalDirNow.Text + sTemp);
      DisplayLocal;
    end;
  end
  else begin
    MessageDlg('You must first select a file to download from the site.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmSystemSetup.btnDfsFtpLocalFileUploadClick(Sender: TObject);
begin
  ChangeLocalDir(FLocalRootDir);
end;

procedure TfrmSystemSetup.btnDfsFtpLocalDirGoClick(Sender: TObject);
begin
  if (Length(edDfsFtpLocalDirNow.Text) < 1) then begin  //2019-02-08
    btnDfsFtpLocalDirHomeClick(Sender);
    Exit;
  end;
  if (edDfsFtpLocalDirNow.Text[Length(edDfsFtpLocalDirNow.Text)] <> '\') then
    edDfsFtpLocalDirNow.Text := edDfsFtpLocalDirNow.Text + '\';
  DisplayLocal;
end;

procedure TfrmSystemSetup.btnDfsFtpHostDirGoClick(Sender: TObject);
begin
  if (Length(edDfsFtpHostDirNow.Text) < 1) then begin  //2019-02-08
    btnDfsFtpHostDirHomeClick(Sender);
    Exit;
  end;
  if (edDfsFtpHostDirNow.Text[Length(edDfsFtpHostDirNow.Text)] <> '/') then
    edDfsFtpHostDirNow.Text := edDfsFtpHostDirNow.Text + '/';
  ChangeFTPDir(edDfsFtpHostDirNow.Text);
end;

procedure TfrmSystemSetup.lstDfsFtpLocalFilesDblClick(Sender: TObject);
var
  sPath, sSubPath : string;
  i : integer;
  nFileAttrs : integer;
begin
  if DfsFtpCommon = nil then Exit;

  for i := 0 to Pred(lstDfsFtpLocalFiles.Items.Count) do begin
    if lstDfsFtpLocalFiles.Selected[i] then begin
      sSubPath := Trim(lstDfsFtpLocalFiles.Items[i]);
      Break;
    end;
  end;
  if sSubPath = '.' then exit;
  if sSubPath = '' then exit;
  //if sSubPath = '..' then exit;
  nFileAttrs := FileGetAttr(edDfsFtpLocalDirNow.Text + sSubPath);
  if (nFileAttrs and faDirectory) = 0 then begin // Not Directory
    Exit;
  end;
  if (edDfsFtpLocalDirNow.Text[Length(edDfsFtpLocalDirNow.Text)] <> '\') then
    edDfsFtpLocalDirNow.Text := edDfsFtpLocalDirNow.Text + '\';
  edDfsFtpLocalDirNow.Text := edDfsFtpLocalDirNow.Text + sSubPath + '\';
  sPath := edDfsFtpLocalDirNow.Text;
  ChangeLocalDir(sPath);
end;

procedure TfrmSystemSetup.lstDfsFtpHostFilesDblClick(Sender: TObject);
var
  sPath, sSubPath : string;
  i : integer;
begin
//  btnDownloadClick(Sender);
  if DfsFtpCommon = nil then Exit;

  for i := 0 to Pred(lstDfsFtpHostFiles.Items.Count) do begin
    if lstDfsFtpHostFiles.Selected[i] then begin
      sSubPath := Trim(lstDfsFtpHostFiles.Items[i]);
      Break;
    end;
  end;
  if sSubPath = '.' then exit;
  if sSubPath = '' then exit;
  //if sSubPath = '..' then exit;
  if (edDfsFtpHostDirNow.Text[Length(edDfsFtpHostDirNow.Text)] <> '/') then
    edDfsFtpHostDirNow.Text := edDfsFtpHostDirNow.Text + '/';
  edDfsFtpHostDirNow.Text := edDfsFtpHostDirNow.Text + sSubPath + '/';
  sPath := edDfsFtpHostDirNow.Text;
  ChangeFTPDir(sPath);
end;

procedure TfrmSystemSetup.btnDfsFtpHost2LocalDownloadClick(Sender: TObject);
var
  i, idx, nSize : Integer;
  sTemp : String;
begin
  idx := -1;
  for i := 0 to Pred(lstDfsFtpHostFiles.Count) do begin
    if lstDfsFtpHostFiles.Selected[i] then begin
      idx := i;
      Break;
    end;
  end;

  if idx <> -1 then begin
    sTemp := lstDfsFtpHostFiles.Items[i];
    nSize := DfsFtpCommon.Size(sTemp);
    if nSize = -1 then
      ChangeFTPDir(sTemp)
    else begin
      if FileExists(edDfsFtpLocalDirNow.Text + sTemp) then
        if MessageDlg('File exists overwrite?', mtWarning, [mbYes,mbNo], 0) = mrYes then
          DeleteFile(edDfsFtpLocalDirNow.Text + sTemp);

      DfsFtpCommon.Get(sTemp, edDfsFtpLocalDirNow.Text + sTemp);
      DisplayLocal;
    end;
  end
  else begin
    MessageDlg('You must first select a file to download from the site.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmSystemSetup.btnDfsFtpLocal2HostUploadClick(Sender: TObject);
var
  i, idx : Integer;
  nTemp : Integer;
  sTemp : String;
  nFileAttrs : Integer;
begin
  idx := -1;
  for i := 0 to Pred(lstDfsFtpLocalFiles.Count) do begin
    if lstDfsFtpLocalFiles.Selected[i] then begin
      idx := i;
      Break;
    end;
  end;

  if idx <> -1 then begin
    sTemp := lstDfsFtpLocalFiles.Items[i];
    nFileAttrs := FileGetAttr(edDfsFtpLocalDirNow.Text + sTemp);
    if (nFileAttrs and faDirectory) <> 0 then begin // Directory
      MessageDlg('Directory is selected. You must select a file to upload from the local PC.', mtWarning, [mbOK], 0);
    end
    else begin  // Not Directory
      nTemp := FileOpen(edDfsFtpLocalDirNow.Text + sTemp, fmOpenRead);
      if nTemp = -1 then begin
        FileClose(nTemp);
        MessageDlg('File Open Error (' + edDfsFtpLocalDirNow.Text + sTemp + ')', mtWarning, [mbOK], 0);
      end
      else begin
        FileClose(nTemp);
        DfsFtpCommon.Put(edDfsFtpLocalDirNow.Text + sTemp, sTemp);
        DisplayFTP;
      end;
    end;
  end
  else begin
    MessageDlg('You must first select a file to upload from the local PC.', mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmSystemSetup.ChangeLocalDir(NewDir: string);
begin
  FLocalLastDirStack.Add(edDfsFtpLocalDirNow.Text);
  edDfsFtpLocalDirNow.Text := NewDir;
  DisplayLocal;
end;

procedure TfrmSystemSetup.ChangeFTPDir(NewDir: String);
begin
  FHostLastDirStack.Add(DfsFtpCommon.RetrieveCurrentDir);
  DfsFtpCommon.ChangeDir(NewDir);
  DisplayFTP;
end;

procedure TfrmSystemSetup.DisplayFTP;
var
  i: Integer;
  sTemp : TStringList;
begin
  lstDfsFtpHostFiles.Items.Clear;
  try
    sTemp := TStringList.Create;
    DfsFtpCommon.List(sTemp);
    edDfsFtpHostDirNow.Text := DfsFtpCommon.RetrieveCurrentDir;
    for i := 0 to Pred(sTemp.Count) do begin
      if DfsFtpCommon.Size(sTemp[i]) = -1 then
        lstDfsFtpHostFiles.Items.Add(sTemp[i]);
    end;
    for i := 0 to Pred(sTemp.Count) do begin
      if DfsFtpCommon.Size(sTemp[i]) <> -1 then
        lstDfsFtpHostFiles.Items.Add(sTemp[i]);
    end;
  finally
    sTemp.Free;
    sTemp := nil;
  end;
end;

procedure TfrmSystemSetup.DisplayLocal;
var
  Rslt : Integer;
  SearchRec : TSearchRec;
begin
  lstDfsFtpLocalFiles.Items.Clear;
  Rslt := FindFirst(edDfsFtpLocalDirNow.Text + '*.*', faAnyFile, SearchRec);
  while Rslt = 0 do begin
    if not ((SearchRec.Name = '.') or (SearchRec.Name = '..')) then begin
      lstDfsFtpLocalFiles.Items.Add(SearchRec.Name);
    end;
    Rslt := FindNext(Searchrec);
  end;
  FindClose(SearchRec);
end;

end.
