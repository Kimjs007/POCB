unit DfsFtpPocb;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.Classes, System.SysUtils,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, IdFTPCommon, IdFTPListParseWindowsNT,
  IdFTPList, CommonClass, Math, StrUtils,
  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
  DefPocb,
{$IFDEF SITE_LENSVN}
  LensHttpMes;
{$ELSE}
  GMesCom;
{$ENDIF}

type

  //============================================================================
  PMainGuiDfsData = ^RMainGuiDfsData;   // to FrmMain //2019-04-09
  RMainGuiDfsData = record
    MsgType   : Integer;
    Channel   : Integer;
    Mode      : Integer;
    Param     : Integer;
    Msg       : string; //string[250];
  end;

  //
  InFtpConnEvnt = procedure(bConnected : Boolean) of object;
  InFtpErrMsg = procedure(nCh: Integer; sMsg: string) of object;

  TDfsRetInfo = record
{$IFDEF DFS_HEX} //REF_ISPD_DFS
    HexFileName     : String;
{$ENDIF}
{$IFDEF DFS_DEFECT} //REF_ISPD_DFS
    nDefectCnt      : Integer;
    nPreDefectCnt   : Integer;
    PreSampling     : array of string; // ¢Æ| ~Dê³µì| ~U Sampling Rate
    PreDftName      : array of string; // ¢Æ| ~Dê³µì| ~U ë¶~H¢Æ~_~Iëª~E
    PreDftCode      : array of string; // ¢Æ| ~Dê³µì| ~U ë¶~H¢Æ~_~Iì½~T¢Æ~S~\
    PreDftLocation  : array of string; // ¢Æ| ~Dê³µì| ~U ë¶~H¢Æ~_~I ¢Æ~\~Dì¹~X
    PreGridMode     : array of string; // ¢Æ| ~Dê³µì| ~U Grid Mode
    PreDftLevel     : array of string; // ¢Æ| ~Dê³µì| ~U ë¶~H¢Æ~_~I ¢Æ~H~Xì¤~@
    PreHando        : array of string; // ¢Æ| ~Dê³µì| ~U ¢Æ~U~\¢Æ~O~D ¢Æ~L~@ë¹~D OK/NG
    bGibReport      : Boolean;
    GibOKName       : array of string; // ¢Æ| ~Dê³µì| ~U GIB OK ¢Æ~]´ì~\|
    GibOKCode       : array [0..99] of string; // ¢Æ| ~Dê³µì| ~U GIB OK ì½~T¢Æ~S~\
    TempDftCode     : array [0..99] of string; // ë¶~H¢Æ~_~I ì½~T¢Æ~S~\ ¢Æ~^~D¢Æ~K~\ ¢Æ| ~@¢Æ~^¢Æ
    DftRsltCode     : array [0..99] of string; // ¢Æ~X~Dê³µì| ~U ë¶~H¢Æ~_~I ì½~T¢Æ~S~\
    DftRsltName     : array of string; // ¢Æ~X~Dê³µì| ~U ë¶~H¢Æ~_~Iëª~E
    DftRsltLocation : array of string; // ¢Æ~X~Dê³µì| ~U ë¶~H¢Æ~_~I¢Æ~\~Dì¹~X
    DftRsltLevel    : array of string; // ¢Æ~X~Dê³µì| ~U ë¶~H¢Æ~_~I¢Æ~H~Xì¤~@
    DftRsltOKNG     : array of string; // ¢Æ~X~Dê³µì| ~U ¢Æ~U~\¢Æ~O~D ¢Æ~L~@ë¹~D OK/NG
    FinalDftNG      : Boolean;
    FinalDftName    : string;
    FinalDftCode    : string;
    DefectFileName  : string;
    LotID           : string;
{$ENDIF}
  end;

  TDfsFtp = class
//    ftp : TIdFTP;
    procedure FtpConnection(Sender : TObject);
    procedure FtpDisConnection(Sender : TObject);
  private
    ftp : TIdFTP;
    m_nCh : Integer;
    prSeed, LayerCount, LayerSize : Integer;
{$IFDEF DFS_DEFECT}    //TBD?
    m_XMLDefectFile : TXMLDocument;
  //iNodeRoot, iNodePanel, iNodeHeader, iNodeBody : IXMLNode;
  //iNodeAPInfo, iNodeDfInfo, iNodeTemp : IXMLNode;
{$ENDIF}
    FIsConnected: Boolean;
    FIsSetUpWindow: Boolean;
    FOnConnectedSetup: InFtpConnEvnt;
    FOnConnected: InFtpConnEvnt;
    FOnErrMsg: InFtpErrMsg;
    FIsConnectCheck: Boolean;
    // Common for FTP
    procedure SetIsConnected(const Value: Boolean);
    procedure SetIsSetUpWindow(const Value: Boolean);
    procedure SetOnConnectedSetup(const Value: InFtpConnEvnt);
    procedure SetOnConnected(const Value: InFtpConnEvnt);
    procedure SetOnErrMsg(const Value: InFtpErrMsg);
    procedure SetIsConnectCheck(const Value: Boolean);
    procedure SendMainGuiDisplay(nGuiMode, nCh: Integer; nParam{0:Disconnected,1:COnnected}: Integer; sMsg: string = ''); //2019-04-09

  public
    m_hMain : HWND;  //2019-04-09
    m_DfsRetInfo : TDfsRetInfo;
    m_DfsFtpServerHome : String;
    //
    property IsSetUpWindow : Boolean read FIsSetUpWindow write SetIsSetUpWindow;
    property IsConnectCheck : Boolean read FIsConnectCheck write SetIsConnectCheck;
    property IsConnected : Boolean read FIsConnected write SetIsConnected;
    property OnConnected : InFtpConnEvnt read FOnConnected write SetOnConnected;
    property OnConnectedSetup : InFtpConnEvnt read FOnConnectedSetup write SetOnConnectedSetup;
    property OnErrMsg : InFtpErrMsg read FOnErrMsg write SetOnErrMsg;
    // Common for FTP
    constructor Create(sIP, sUserName, sPassword : string; nCh : Integer); virtual;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    procedure List(var sList: TStringList);
    function Size(sFileName: string): Integer;
    procedure MakeDir(sPath: string);
    procedure MakeAndChangeDir(sDir: String);
    procedure Delete(sFile: string);
    procedure Get(sSource, sDest: string);
    procedure Put(sSource, sDest: string);
    procedure ChangeDirUp;
    function CheckChangeDir(sAddDir: string): Boolean;
    function RetrieveCurrentDir: string;
    procedure ChangeDir(sPath : string);
{$IFDEF DFS_HEX}
    // DFS COMMON : COMBI, HASH, ...
    function GetDfsHashPath(sPanelId: String): String;
    function GetDfsHashValue(pKeyStr: String) : Integer;
    function TranHashValue2NumberInLayer(hashValue, layerNumber: Integer): Double;
    procedure DownloadCombiFile;
    // DFS_HEX : DEFECT/HEX_INDEX & DEFECT/HEX, DEFECT/SENSE_INDEX & DEFECT/SENSE
    function GetDfsFullNameFromIdxFile(sIdxFile: string): string; // Defect(INDEX), Hex(HEX_INDEX|SENSE_INDEX)
    function UpdateDfsIdxFile(sHexSenseIndexDir, sIdxFileName, sAppendFullName: String): String; // Defect(INDEX), Hex(HEX_INDEX|SENSE_INDEX)
    function DfsHexFilesDownload(sPid: string; nHexType: Integer; sSubType: String = ''): Boolean; //Auto-AC(SENSE)
    function DfsHexFilesUpload(sPid: String; sStartTime: TDateTime; sBinFullName: String; nHexType: Integer; sSubType: String = '') : Boolean; //POCB(HEX), Auto-AC/Foldable-AC(SENSE)
{$ENDIF}
  end;

var
{$IFDEF INSPECTOR_POCB}
  DfsFtpCh : array [DefPocb.CH_1..DefPocb.CH_MAX] of TDfsFtp;
{$ELSE}
  DfsFtpCh : array [DefCommon.CH1 .. DefCommon.MAX_CH] of TDfsFtp;
{$ENDIF}
  DfsFtpCommon : TDfsFtp;
  DfsFtpConnOK : Boolean; //if ant FTP connect failed, then False

implementation

{ TDfsFtp }

//==============================================================================
// Common for FTP
//==============================================================================

procedure TDfsFtp.ChangeDir(sPath: string);
begin
  ftp.ChangeDir(sPath);
end;

procedure TDfsFtp.ChangeDirUp;
begin
  ftp.ChangeDirUp;
end;

function TDfsFtp.CheckChangeDir(sAddDir: string): Boolean;  //TBD? by Clint?
var
  i: Integer;
  slList : TStringList;
  bIsFolder : Boolean;
  sCurDir, sNewDir : string;
begin
  try
    slList := nil;
    try
      sCurDir := ftp.RetrieveCurrentDir + '/';
      slList := TStringList.Create;
      ftp.List(slList, '', False);
      bIsFolder := False;
      for i := 0 to Pred(slList.Count) do begin
        if sAddDir = Trim(slList[i]) then begin
          bIsFolder := True;
          Break;
        end;
      end;
      sNewDir := sCurDir+sAddDir+'/';
      if not bIsFolder then begin
        ftp.MakeDir(sNewDir);
        Sleep(50);
      end;
      ftp.ChangeDir(sNewDir);
      Sleep(50);
    finally
      slList.Free;
    end;
    Result := True;
  except
    Result := False;
  end;

{var

begin
  lstHostFiles.Items.Clear;

end;}
end;

procedure TDfsFtp.Connect;
begin
  try
    if ftp.Connected then ftp.Disconnect;
    ftp.Connect;
    DfsFtpConnOK := True;
{$IFDEF INSPECTOR_POCB}
    SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS, m_nCh, 1{0:Disconnected,1:Connected});
{$ELSE}
    SendMainGuiDisplay(DefCommon.MSG_MODE_DISPLAY_CONNECTION, m_nCh, 1{0:Disconnected,1:Connected});
{$ENDIF}
  except
    on E: Exception do begin
      Common.MLog(m_nCh, '<DFS> FTP Connect Error! E.Message=' + E.Message);
      if Assigned(OnErrMsg) then OnErrMsg(0, '<DFS> FTP Connect Error! E.Message=' + E.Message);
      ftp.DisConnect;
      DfsFtpConnOK := False;
{$IFDEF INSPECTOR_POCB}
      SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS, m_nCh, 0{0:Disconnected,1:Connected});
{$ELSE}
      SendMainGuiDisplay(DefCommon.MSG_MODE_DISPLAY_CONNECTION, m_nCh, 0{0:Disconnected,1:Connected});
{$ENDIF}	  
    end;
  end;
end;

constructor TDfsFtp.Create(sIP, sUserName, sPassword : string; nCh : Integer);
begin
  m_nCh := nCh;
{$IFDEF DFS_DEFECT}
  m_XMLDefectFile := frmMainXX.XMLDefectFile;
{$ENDIF}

  ftp := TIdFtp.Create(nil);
  ftp.AUTHCmd := tAuto;
  ftp.AutoIssueFEAT := True;
  ftp.ReadTimeout := 5000;
  ftp.Passive := True;

  ftp.Host := sIP;
  ftp.Port := 21;
  ftp.Username := sUserName;
  ftp.Password := sPassword;
  ftp.OnAfterClientLogin := FtpConnection;
  ftp.TransferType := ftBinary;
  ftp.OnDisconnected := FtpDisConnection;
  //
  m_DfsFtpServerHome := '';
end;


procedure TDfsFtp.Delete(sFile: string);
begin
  ftp.Delete(sFile);
end;

destructor TDfsFtp.Destroy;
begin
  if ftp <> nil then begin
    if ftp.Connected then ftp.Disconnect;
    ftp.Free;
    ftp := nil;
  end;
  inherited;
end;

procedure TDfsFtp.DisConnect;
begin
  if ftp.Connected then ftp.Disconnect;
end;

procedure TDfsFtp.FtpConnection(Sender: TObject);
begin
  FIsConnected := True;
  if FIsConnectCheck then OnConnected(True);
  if FIsSetUpWindow then Self.OnConnectedSetup(True);
end;

procedure TDfsFtp.FtpDisConnection(Sender: TObject);
begin
  FIsConnected := False;
  if FIsConnectCheck then OnConnected(False);
  if FIsSetUpWindow then Self.OnConnectedSetup(False);
//  if FIsSetUpWindow then Self.OnConnectedSetup(False)
//  else                   Self.OnConnected(False);
end;

procedure TDfsFtp.Get(sSource, sDest: string);
begin
  ftp.Get(sSource, sDest, True);
end;

procedure TDfsFtp.List(var sList: TStringList);
begin
  ftp.List(sList, '', False);
end;

procedure TDfsFtp.MakeAndChangeDir(sDir: String);
begin
  try
    //Common.MLog(m_nCh, '<DFS> DFS FOLDER DIRECTORY MAKE[' + sDir + ']');
    DfsFtpCh[m_nCh].MakeDir(sDir);
    Common.Delay(50);
    //Common.MLog(m_nCh, '<DFS> DFS FOLDER DIRECTORY CHANGE[' + sDir + ']');
    DfsFtpCh[m_nCh].ChangeDir(sDir);
    Common.Delay(50);
  except
    on E: Exception do begin
{$IFDEF DEBUG_DFS}
      if Trim(E.Message) <> 'Directory already exists' then
        Common.MLog(m_nCh, '<FILE_SVR> FTP MakeAndChangeDir Control Error! E.Message=' + Trim(E.Message));
{$ENDIF}
      DfsFtpCh[m_nCh].ChangeDir(sDir);
      Common.Delay(50);
    end;
  end;
end;

procedure TDfsFtp.MakeDir(sPath: string);
begin
  ftp.MakeDir(sPath);
end;

procedure TDfsFtp.Put(sSource, sDest: string);
begin
  try
    ftp.Put(sSource, sDest);
  except  //2019-02-08
    on E: Exception do begin
      Common.MLog(0, '<FILE_SVR> FTP PUT Error! E.Message=' + Trim(E.Message));
    end;
  end;
end;

function TDfsFtp.RetrieveCurrentDir: string;
begin
  Result := ftp.RetrieveCurrentDir;
end;

procedure TDfsFtp.SetIsConnectCheck(const Value: Boolean);
begin
  FIsConnectCheck := Value;
end;

procedure TDfsFtp.SetIsConnected(const Value: Boolean);
begin
  FIsConnected := Value;
end;

procedure TDfsFtp.SetIsSetUpWindow(const Value: Boolean);
begin
  FIsSetUpWindow := Value;
end;

procedure TDfsFtp.SetOnConnected(const Value: InFtpConnEvnt);
begin
  FOnConnected := Value;
end;

procedure TDfsFtp.SetOnConnectedSetup(const Value: InFtpConnEvnt);
begin
  FOnConnectedSetup := Value;
end;

procedure TDfsFtp.SetOnErrMsg(const Value: InFtpErrMsg);
begin
  FOnErrMsg := Value;
end;

function TDfsFtp.Size(sFileName: string): Integer;
begin
  Result := ftp.Size(sFileName);
end;

{$IFDEF DFS_HEX}
//==============================================================================
// DFS COMMON : COMBI, HASH, ...
//==============================================================================
procedure TDfsFtp.DownloadCombiFile;
var
  i : Integer;
  sList, sList2 : TStringList;
  Rslt : Integer;
  SearchRec : TSearchRec;
begin
  if not DfsFtpCommon.IsConnected then begin
    DfsFtpCommon.Connect;
  end;

  try
    sList := TStringList.Create;
    sList2 := TStringList.Create;
    try
      ExtractStrings(['\','/'],[],PWideChar(Common.DfsConfInfo.sCombiDownPath),sList);
      for i := 0 to Pred(sList.Count) do begin
        DfsFtpCommon.ChangeDir(sList[i]);
      end;

      DfsFtpCommon.List(sList2);

      Rslt := FindFirst(Common.Path.CombiCode + '*.ini', faAnyFile, SearchRec);
      while Rslt = 0 do begin
        MoveFile(PChar(Common.Path.CombiCode + SearchRec.Name), PChar(Common.Path.CombiBackUp + SearchRec.Name));
        DeleteFile(PChar(Common.Path.CombiCode + SearchRec.Name));
        Rslt := FindNext(SearchRec);
      end;
      FindClose(SearchRec);

      for i := 0 to Pred(sList2.Count) do begin
        if (Pos('.ini',sList2[i]) > 0) then begin
          Common.MLog(DefPocb.SYS_LOG, '<DFS> DOWNLOAD COMBI FILE NAME : ' + sList2[i]);
          DfsFtpCommon.Get(sList2[i], Common.Path.CombiCode + sList2[i]);
        end;
      end;

      Common.LoadCombiFile;
    except
      on E: Exception do begin
        Common.MLog(DefPocb.SYS_LOG, '<DFS> COMBICODE DOWNLOAD FAIL! E.Message=' + E.Message);

        DfsFtpCommon.DisConnect;
        Common.Delay(50);
      end;
    end;
  finally
    DfsFtpCommon.DisConnect;
    Common.Delay(50);
    sList.Free;
    sList2.Free;
  end;
end;

function TDfsFtp.GetDfsHashPath(sPanelId: String): String;
var
  IndexFilePath : string;
  dTemp         : Double;
  nDfsHashValue, nTemp : Integer;
begin
  try
    prSeed      := 7919;  // 1021  --> 7919
    LayerCount  := 1;
    if prSeed <= 157 then begin
      LayerSize     := prSeed;
    end
    else begin
      LayerCount  := 2;
      nTemp       := prSeed;
      LayerSize   := Trunc(nTemp / (Trunc(Power(prSeed, 0.5))));
    end;
    //
    nDfsHashValue := GetDfsHashValue(sPanelId);
    if LayerCount = 1 then begin
      dTemp         := TranHashValue2NumberInLayer(nDfsHashValue, 1);
      IndexFilePath := IndexFilePath + FormatFloat('00000000', dTemp);  //TBD:2021-05? (Memory Leak?)
    end
    else begin
      dTemp         := TranHashValue2NumberInLayer(nDfsHashValue, 0);
      IndexFilePath := IndexFilePath + FormatFloat('00000000', dTemp) + '\';  //TBD:2021-05? (Memory Leak? 000000045)
      dTemp         := TranHashValue2NumberInLayer(nDfsHashValue, 1);
      IndexFilePath := IndexFilePath + FormatFloat('00000000', dTemp);        //TBD:2021-05? (Memory Leak? 000000054)
    end;
    Result := IndexFilePath;
  except
    Result := '';
  end;
end;

function TDfsFtp.GetDfsHashValue(pKeyStr: String): Integer;
var
  i, tmpVal, strLength  : Integer;
  lTemp : Int64;
begin
  strLength := Length(pKeyStr);
  if strLength = 0 then begin
    Result := 0;
    Exit;
  end;
  //
  tmpVal := 0;
  for i := 0 to strLength - 1 do begin
    lTemp   := tmpVal;
    lTemp   := lTemp * $ff;
    lTemp   := lTemp + ($ff and Ord(pKeyStr[i+1]));
    tmpVal  := lTemp mod prSeed;
  end;
  Result := tmpVal;
end;

function TDfsFtp.TranHashValue2NumberInLayer(hashValue, layerNumber: Integer): Double;
var
  functionReturnValue : Double;
begin
  if layerNumber = 0 then begin
    functionReturnValue := hashValue / LayerSize;
    functionReturnValue := functionReturnValue - 0.49999;
  end
  else begin
    functionReturnValue := hashValue mod LayerSize;
  end;

  Result := functionReturnValue;
end;

function TDfsFtp.GetDfsFullNameFromIdxFile(sIdxFile: String): String; // Defect(INDEX), Hex(HEX_INDEX|SENSE_INDEX)
var
  fFs : TextFile;
  sFullName, sTemp : String;
begin
  AssignFile(fFs, sIdxFile);
  Reset(fFs);
  sFullName := '';
  try
    while not Eof(fFs) do begin
      ReadLn(fFs, sTemp);
      if sTemp <> '' then begin
        sFullName := sTemp;
      end;
    end;
  finally
    CloseFile(fFs);
  end;
  Result := sFullName;
end;

function TDfsFtp.UpdateDfsIdxFile(sHexSenseIndexDir, sIdxFileName, sAppendFullName: String): String; // Defect(INDEX), Hex(HEX_INDEX|SENSE_INDEX)
var
  fFs   : TextFile;
  hFile : Integer;
begin
{$IFDEF DEBUG_DFS}
  Common.MLog(m_nCh, '<DFS> Update '+sHexSenseIndexDir+' File ('+sIdxFileName+')');
{$ENDIF}
  try
    if not FileExists(sIdxFileName) then begin
      hFile := FileCreate(sIdxFileName);
      FileClose(hFile);
    end;
    AssignFile(fFs, sIdxFileName);
    Append(fFs);
    WriteLn(fFs, sAppendFullName);
    CloseFile(fFs);
    Sleep(10);  //2019-04-09
  except
  end;
end;
{$ENDIF}

{$IFDEF DFS_HEX}
//==============================================================================
// DFS_HEX : DEFECT/HEX_INDEX|SENSE_INDEX, DEFECT/HEX|SENSE
//    - function DfsHexFilesDownload;
//    - function DfsHexFilesUpload;
//==============================================================================
{$IFDEF DFS_DEFECT}}
procedure TDfsFtp.CreateDefectFile(bNew: Boolean; sDftFName: String);
var
  sDfsFileName, sDfsFullName : string;
begin
  sDfsFileName := PasScr[m_nCh].m_TestRet.RtnPId + '_'
                  + Common.CombiCodeData.sProcessNo
                  + '_' + FormatDateTime('YYYYMMDD_HHNNSS', PasScr[m_nCh].m_TestRet.StartTime)
                  + '.ZIP';     // For ZippedHexFile:ZIP, for DefectFile: Common.SystemInfo.EQPId

  sDfsFullName := Common.Path.INSPECTOR + FormatDateTime('MM', PasScr[m_nCh].m_TestRet.StartTime) + '\';
  Common.CheckDir(sDfsFullName);
  sDfsFullName := sDfsFullName + FormatDateTime('DD', PasScr[m_nCh].m_TestRet.StartTime) + '\';
  Common.CheckDir(sDfsFullName);
  sDfsFullName := sDfsFullName + Common.CombiCodeData.sRcpName + '\';
  Common.CheckDir(sDfsFullName);
  sDfsFullName := sDfsFullName + Common.SystemInfo.EQPId + '\';
  Common.CheckDir(sDfsFullName);
  sDfsFullName := sDfsFullName + sDfsFileName;

  if bNew then begin
    CreateXMLFile(sDfsFileName, sDfsFullName);
  end
  else begin
    RenameFile(PChar(sDftFName), PChar(sDfsFullName));
    OpenXMLFile(sDfsFullName);
  end;
end;
{$ENDIF}

function TDfsFtp.DfsHexFilesDownload(sPid: string; nHexType: Integer; sSubType: String = ''): Boolean;
var
  i, nDirIdx : Integer;
  {sPid,} sRootDir, sErrMsg : string;
  sHexIdxServerPath, sDfsHashPath, sHexIdxFileName, sHexIdxServerFullName, sHexIdxLocalFullName : string;
  sHexServerFullName, sHexServerPath, sHexFileName, sHexLocalFullName : string;
//? sDfFileName, sDownDirDFT, sDownFileDFT : string;
  sList, sList2 : TStringList;
  sHexSenseIndexDir, sHexSenseDir, sPathIdx, sPathBin : string;
begin
  case nHexType of
    0:   begin   //0:HEX
      sHexSenseIndexDir := 'HEX_INDEX';   sHexSenseDir := 'HEX';
      sPathIdx := Common.Path.DfsHexIndex; sPathBin := Common.Path.DfsHex;
    end;
    else begin   //1:SENSE
      sHexSenseIndexDir := 'SENSE_INDEX'; sHexSenseDir := 'SENSE';
      sPathIdx := Common.Path.DfsSenseIndex; sPathBin := Common.Path.DfsSense;
    end;
  end;
  //------------------------------------ Check PanelId
  sErrMsg  := '';
  //sRootDir := '\'
  if sPid = '' then begin
    sErrMsg := '<DFS> '+sHexSenseDir+' File Download Fail (Panel ID does NOT exist) !';
    Common.MLog(m_nCh,sErrMsg);  //TBD:DFS?  OnErrMsg(m_nCh,sErrMsg);
    Exit(False);
  end;

  //------------------------------------ for HEX_INDEX|SENSE_INDEX file
  sDfsHashPath         := GetDfsHashPath(sPid);
  sHexIdxServerPath    := 'DEFECT\'+sHexSenseIndexDir+'\' + sDfsHashPath; //HEX_INDEX|SENSE_INDEX
  sHexIdxFileName      := UpperCase(sPid) + '.IDX';
  sHexIdxServerFullName:= sHexIdxServerPath + '\' + sHexIdxFileName;
  sHexIdxLocalFullName := sPathIdx + sHexIdxFileName;
  if FileExists(sHexIdxLocalFullName) then begin
    DeleteFile(sHexIdxLocalFullName);
  end;

  //------------------------------------ Connect DFS FTP server if not connected
  if not DfsFtpCh[m_nCh].IsConnected then begin
    DfsFtpCh[m_nCh].Connect;
    Common.Delay(1000);
  end;
  if not DfsFtpCh[m_nCh].IsConnected then begin
  //DfsFtpCh[m_nCh].DisConnect;
    sErrMsg := '<DFS> '+sHexSenseIndexDir+' and '+sHexSenseDir+' File Download Fail (DFS Server Not Connected)';
    Common.MLog(m_nCh, sErrMsg);
    //TBD? OnErrMsg(m_nCh, sErrMsg);
    Exit(False);
  end;

  try
    //---------------------------------- Download HEX_INDEX|SENSE_INDEX File
    try
      //sRootDir := '\';
      //Common.MLog(m_nCh, '<DFS> '+sHexSenseIndexDir+' File Downloading ('+sHexIdxServerFullName+')');
      DfsFtpCh[m_nCh].ChangeDir('DEFECT');
      DfsFtpCh[m_nCh].ChangeDir(sHexSenseIndexDir);  //HEX_INDEX|SENSE_INDEX
      sList := TStringList.Create;
      try
        ExtractStrings(['\','/'],[],PWideChar(sDfsHashPath),sList);
        for i := 0 to Pred(sList.Count) do begin
          DfsFtpCh[m_nCh].ChangeDir(sList[i]);  //Common.Delay(50);
        end;
        DfsFtpCh[m_nCh].Get(sHexIdxFileName, sHexIdxLocalFullName); //Common.Delay(50);
      except
        on E: Exception do begin
        //DfsFtpCh[m_nCh].Disconnect; //Common.Delay(50);
          sErrMsg := '<DFS> '+sHexSenseIndexDir+' File Download Fail ('+sHexIdxServerFullName+', Error:'+E.Message+')';
          Common.MLog(m_nCh, sErrMsg);
          //TBD? OnErrMsg(m_nCh, sErrMsg);
          Exit(False);
        end;
      end;
    finally
      sList.Free;
    end;
    Common.MLog(m_nCh, '<DFS> '+sHexSenseIndexDir+' File Download OK ('+sHexIdxServerFullName+')');
    // Parse HEX_INDEX|SENSE_INDEX and Get HEX|SENSE File Location ---------------------
    sHexServerFullName := GetDfsFullNameFromIdxFile(sHexIdxLocalFullName);
{$IFDEF DEBUG_DFS}
    Common.MLog(m_nCh, '<DFS> FileName : ' + sHexServerFullName);
{$ENDIF}
    if sHexServerFullName = '' then begin
    //DfsFtpCh[m_nCh].Disconnect; //Common.Delay(50);
      sErrMsg := '<DFS> '+sHexSenseIndexDir+' File is Empty';
      Common.MLog(m_nCh, sErrMsg);
      //TBD? OnErrMsg(m_nCh, sErrMsg);
      Exit(False);
    end;

    // Download HEX|SENSE File ---------------------
    try
      nDirIdx        := LastDelimiter('\', sHexServerFullName);
      sHexServerPath := Copy(sHexServerFullName, 1, nDirIdx-1);
      sHexFileName   := Copy(sHexServerFullName, nDirIdx+1, Length(sHexServerFullName)-1);
      //Common.MLog(m_nCh, '<DFS> '+sHexSenseDir+' File Downloading (' + sHexServerFullName + ')');
      //
      m_DfsRetInfo.HexFileName := sPathBin + FormatDateTime('MM', now) + '\';
      Common.CheckMakeDir(m_DfsRetInfo.HexFileName);
      m_DfsRetInfo.HexFileName := m_DfsRetInfo.HexFileName + FormatDateTime('DD', now) + '\';
      Common.CheckMakeDir(m_DfsRetInfo.HexFileName);
      m_DfsRetInfo.HexFileName := m_DfsRetInfo.HexFileName + Common.CombiCodeData.sRcpName[m_nCh] + '\';  //A2CHv3:MULTIPLE_MODEL
      Common.CheckMakeDir(m_DfsRetInfo.HexFileName);
      m_DfsRetInfo.HexFileName := m_DfsRetInfo.HexFileName + Common.SystemInfo.EQPId + '\';
      Common.CheckMakeDir(m_DfsRetInfo.HexFileName);
      m_DfsRetInfo.HexFileName := m_DfsRetInfo.HexFileName + sHexFileName;
      if FileExists(m_DfsRetInfo.HexFileName) then begin
        DeleteFile(m_DfsRetInfo.HexFileName);
      end;
      //
      sList2 := TStringList.Create;
      try
        ExtractStrings(['\','/'],[],PWideChar(sHexServerPath),sList2);
        for i := 0 to Pred(sList2.Count) do begin
          DfsFtpCh[m_nCh].ChangeDir(sList2[i]); //Common.Delay(50);
        end;
        DfsFtpCh[m_nCh].Get(sHexFileName, m_DfsRetInfo.HexFileName); //Common.Delay(50);
      //DfsFtpCh[m_nCh].DisConnect; //Common.Delay(50);
      except
        on E: Exception do begin
        //DfsFtpCh[m_nCh].DisConnect; //Common.Delay(50);
          sErrMsg := '<DFS> '+sHexSenseDir+' File Download Fail ('+sHexServerFullName+', Error:'+E.Message+')';
          Common.MLog(m_nCh, sErrMsg); //TBD? OnErrMsg(m_nCh, sErrMsg);
          Exit(False);
        end;
      end;
    finally
      sList2.Free;
    end;
    Common.MLog(m_nCh, '<DFS> '+sHexSenseDir+' File Download OK ('+sHexServerFullName+')');
    Result := True;
  finally
    //------------------------------------ Disconnect DFS FTP server if connected
    if DfsFtpCh[m_nCh].IsConnected then begin  //2019-04-09
      DfsFtpCh[m_nCh].Disconnect;
    end;
  end;
end;

function TDfsFtp.DfsHexFilesUpload(sPid: string; sStartTime: TDateTime; sBinFullName: String; nHexType: integer; sSubType: string = ''): Boolean;
var
  sHexIdxFileName, sHexIdxLocalFullName, sDfsHashPath, sHexIdxServerPath, sHexIdxServerFullName : String;
  sHexFileName, sHexLocalFullName, sHexServerPath, sHexServerFullName : String;
  {sRootDir,} sTempDir, sErrMsg : String;
  sList, sList2 : TStringList;
  i, nIdxDirDepth : Integer;
  bIsOK, bHexIdxDirExistOnServer, bHexIdxFileExistOnServer : Boolean;
  sHexSenseIndexDir, sHexSenseDir, sPathIdx, sPathBin : string;
begin
  Result := False;

  try  //#############1

  try  //#############2

  case nHexType of
    0:   begin   //0:HEX
      sHexSenseIndexDir := 'HEX_INDEX';   sHexSenseDir := 'HEX';
      sPathIdx := Common.Path.DfsHexIndex; sPathBin := Common.Path.DfsHex;
    end;
    else begin   //1:SENSE
      sHexSenseIndexDir := 'SENSE_INDEX'; sHexSenseDir := 'SENSE';
      sPathIdx := Common.Path.DfsSenseIndex; sPathBin := Common.Path.DfsSense;
    end;
  end;
  sErrMsg  := '';
  //sRootDir := '\';
  // Check PanelId
  if sPid = '' then begin
    sErrMsg := '<DFS> '+sHexSenseIndexDir+' File Upload Fail (Panel ID does NOT exist) !';
    Common.MLog(m_nCh, sErrMsg);  //OnErrMsg(m_nCh, sErrMsg);
    Exit;
  end;

  //------------------------------------ for HEX_INDEX|SENSE_INDEX file
  // Make HexIndex filename and LocalPath
  sHexIdxFileName := UpperCase(sPid) + '.IDX';  //2019-07-29 (AC: R/I SENSE INDEX FileÀº 1°³·Î »ý¼º)
  Common.CheckMakeDir(sPathIdx);
  sHexIdxLocalFullName := sPathIdx + sHexIdxFileName;
  if FileExists(sHexIdxLocalFullName) then begin
    DeleteFile(sHexIdxLocalFullName);
  end;
  // Get DfsHashPath and Make HexIndex ServerPath
  sDfsHashPath         := GetDfsHashPath(sPid);
  sHexIdxServerPath    := 'DEFECT\' + sHexSenseIndexDir + '\' + sDfsHashPath;
  sHexIdxServerFullName:= sHexIdxServerPath + '\' + sHexIdxFileName;

  //------------------------------------ for HEX|SENSE file
  // Make HEX|SENSE filename (PID_<SENSE_I>_PROCNO_<CH#>_
  sHexFileName := sPid+'_'+Common.CombiCodeData.sProcessNo[m_nCh]; //A2CHv3:MULTIPLE_MODEL
  if nHexType = 1{SENSE} then begin
    if Length(sSubType) > 0 then sHexFileName := sHexFileName+'_'+sSubType;
    if Length(Common.CombiCodeData.sRcpName[m_nCh]) > 8 then sHexFileName := sHexFileName+'_'+Copy(Common.CombiCodeData.sRcpName[m_nCh], 0, 8)
    else                                                     sHexFileName := sHexFileName+'_'+Common.CombiCodeData.sRcpName[m_nCh];
  //if nCh >= 0 then sHexFileName := sHexFileName + Format('_%d', [nCh+1]);
  end;
  sHexFileName := sHexFileName+'_'+FormatDateTime('YYYYMMDD_HHNNSS',sStartTime);
  //
  if Common.DfsConfInfo.bDfsHexCompress then sHexFileName := sHexFileName + '.ZIP'
  else                                       sHexFileName := sHexFileName + '.' + Common.SystemInfo.EQPId;
  // Make HEX|SENSE LocalFullName and Check
  sHexLocalFullName := sPathBin;
  Common.CheckMakeDir(sHexLocalFullName);
  sHexLocalFullName := sHexLocalFullName + FormatDateTime('MM',sStartTime) + '\';
  Common.CheckMakeDir(sHexLocalFullName);
  sHexLocalFullName := sHexLocalFullName + FormatDateTime('DD',sStartTime) + '\';
  Common.CheckMakeDir(sHexLocalFullName);
  sHexLocalFullName := sHexLocalFullName + Format('%s\',[Common.CombiCodeData.sRcpName[m_nCh]]);  //A2CHv3:MULTIPLE_MODEL
  Common.CheckMakeDir(sHexLocalFullName);
  sHexLocalFullName := sHexLocalFullName + Format('%s\',[Common.SystemInfo.EQPId]);
  Common.CheckMakeDir(sHexLocalFullName);
  if nHexType = 1 then begin  //1:SENSE
    sHexLocalFullName := sHexLocalFullName + Format('%s\',[sPid]);
    Common.CheckMakeDir(sHexLocalFullName);
  end;
  sHexLocalFullName := sHexLocalFullName + sHexFileName;
  bIsOK := False;

  for i := 0 to 50 do begin
    if Common.m_bDfsUploadFileReady[m_nCh] and System.SysUtils.FileExists(sBinFullName) then Break;
    Sleep(100);
  end;
  Sleep(100);	

  if Common.m_bDfsUploadFileReady[m_nCh] and System.SysUtils.FileExists(sBinFullName) then begin
    bIsOK := CopyFile(PChar(sBinFullName), PChar(sHexLocalFullName), False);
    for i := 0 to 50 do begin
    //bIsOK := CopyFile(PChar(sBinFullName), PChar(sHexLocalFullName), False);
      if FileExists(sHexLocalFullName) then break;
      Sleep(100);
    end;
    Sleep(100);
  end
  else begin
    sErrMsg := '<DFS> '+sHexSenseDir+' File Upload Fail ('+sBinFullName+' does NOT exist) !';
    Common.MLog(m_nCh, sErrMsg);
    Exit;
  end;

  if not FileExists(sHexLocalFullName) then begin
    sErrMsg := '<DFS> '+sHexSenseDir+' File Upload Fail ('+sHexLocalFullName+' does NOT exist) !';
    Common.MLog(m_nCh, sErrMsg);
    Exit;
  end;

  // Make HEX|SENSE ServerFullName
  sHexServerFullName := 'DEFECT\'+sHexSenseDir+'\'
                   + FormatDateTime('MM', sStartTime) + '\'
                   + FormatDateTime('DD', sStartTime) + '\'
                   + Format('%s\%s\',[Common.CombiCodeData.sRcpName[m_nCh], Common.SystemInfo.EQPId]);  //A2CHv3:MULTIPLE_MODEL
  if nHexType = 1{SENSE} then sHexServerFullName := sHexServerFullName + sPid + '\';
  sHexServerFullName := sHexServerFullName + sHexFileName;
  //------------------------------------ Connect DFS FTP server if not connected
  if not DfsFtpCh[m_nCh].IsConnected then begin
    DfsFtpCh[m_nCh].Connect;
    Common.Delay(1000);
  end;
  if not DfsFtpCh[m_nCh].IsConnected then begin
  //DfsFtpCh[m_nCh].DisConnect;
    sErrMsg := '<DFS> '+sHexSenseIndexDir+' and '+sHexSenseDir+' File Upload Fail (DFS Server Not Connected)';
    Common.MLog(m_nCh, sErrMsg);
    Exit;
  end;

  //---------------------------------- Download HEX_INDEX|SENSE_INDEX File
  try
    bHexIdxDirExistOnServer  := False;
    bHexIdxFileExistOnServer := False;
    //Common.MLog(m_nCh, '<DFS> '+sHexSenseIndexDir+' File Downloading ('+sHexIdxServerFullName+')');
  //sRootDir := '\';
    nIdxDirDepth := 0;
    DfsFtpCh[m_nCh].ChangeDir('DEFECT');
    nIdxDirDepth := nIdxDirDepth + 1;
    DfsFtpCh[m_nCh].ChangeDir(sHexSenseIndexDir);
    nIdxDirDepth := nIdxDirDepth + 1;
    sList := TStringList.Create;
    try
      ExtractStrings(['\','/'],[],PWideChar(sDfsHashPath),sList);
      for i := 0 to Pred(sList.Count) do begin
        DfsFtpCh[m_nCh].ChangeDir(sList[i]);
        nIdxDirDepth := nIdxDirDepth + 1;
      end;
      bHexIdxDirExistOnServer := True;
      DfsFtpCh[m_nCh].ftp.List(nil, sHexIdxFileName, True);
      if ContainsText(DfsFtpCh[m_nCh].ftp.LastCmdResult.Text.Text,sHexIdxFileName) then begin
        bHexIdxFileExistOnServer := True;
      end;
      if bHexIdxFileExistOnServer then begin
        DfsFtpCh[m_nCh].Get(sHexIdxFileName, sHexIdxLocalFullName);
        //Common.MLog(m_nCh, '<DFS> '+sHexSenseIndexDir+' File Download OK');
      end;
    except
      on E: Exception do begin
      //sErrMsg := '<DFS> '+sHexSenseIndexDir+' File does NOT exist ('+sHexIdxServerFullName+', Error:'+E.Message+')';
      //Common.MLog(m_nCh, sErrMsg);
      end;
    end;
  finally
    sList.Free;
  end;

  for i := 0 to (nIdxDirDepth - 1) do begin
    DfsFtpCh[m_nCh].ChangeDirUp;
  end;

  //------------------------------------ Update HEX_INDEX|SENSE_INDEX file to upload
  UpdateDfsIdxFile(sHexSenseIndexDir, sHexIdxLocalFullName, sHexServerFullName);

  //------------------------------------ Upload HEX_INDEX|SENSE_INDEX File
  //Common.MLog(m_nCh, '<DFS> '+sHexSenseIndexDir+' File Uploading ('+sHexIdxServerFullName+')');
  try
    DfsFtpCh[m_nCh].ChangeDir('DEFECT');
    DfsFtpCh[m_nCh].ChangeDir(sHexSenseIndexDir); //HEX_INDEX|SENSE_INDEX

    sList := TStringList.Create;
    try
      ExtractStrings(['\','/'],[],PWideChar(sDfsHashPath),sList);
      for i := 0 to Pred(sList.Count) do begin
        MakeAndChangeDir(sList[i]);
      end;
      DfsFtpCh[m_nCh].Put(sHexIdxLocalFullName, sHexIdxFileName);
      for i := 0 to 3 do begin
        DfsFtpCh[m_nCh].ChangeDirUp;
      end;
    except
      on E: Exception do begin
      //DfsFtpCh[m_nCh].DisConnect;
        sErrMsg := '<DFS> '+sHexSenseIndexDir+' File Upload Fail ('+sHexIdxServerFullName+', Error:'+E.Message+')';
        Common.MLog(m_nCh, sErrMsg);
        Exit;
      end;
    end;
  finally
    sList.Free;
  end;
  Common.MLog(m_nCh, '<DFS> '+sHexSenseIndexDir+' File Upload OK ('+sHexIdxServerFullName+')');

  //------------------------------------ Upload HEX|SENSE file
  try
    //Common.MLog(m_nCh, '<DFS> '+sHexSenseDir+' File Uploading ('+sHexServerFullName+')');
    DfsFtpCh[m_nCh].ChangeDir('DEFECT');
    DfsFtpCh[m_nCh].ChangeDir(sHexSenseDir);     //HEX|SENSE
    sTempDir  := FormatDateTime('MM', sStartTime);
    MakeAndChangeDir(sTempDir);
    sTempDir  := FormatDateTime('DD', sStartTime);
    MakeAndChangeDir(sTempDir);
    sTempDir  := Common.CombiCodeData.sRcpName[m_nCh];  //A2CHv3:MULTIPLE_MODEL
    MakeAndChangeDir(sTempDir);
    sTempDir  := Common.SystemInfo.EQPId;
    MakeAndChangeDir(sTempDir);
    if nHexType = 1{SENSE} then begin
      sTempDir  := sPid;
      MakeAndChangeDir(sTempDir);
    end;
    DfsFtpCh[m_nCh].Put(sHexLocalFullName, sHexFileName);
    DfsFtpCh[m_nCh].DisConnect;
  except
    on E: Exception do begin
    //DfsFtpCh[m_nCh].DisConnect;
      sErrMsg := '<DFS> '+sHexSenseDir+' File Upload Fail ('+sHexServerFullName+', Error:'+E.Message+')';
      Common.MLog(m_nCh, sErrMsg);
      Exit;
    end;
  end;
  Common.MLog(m_nCh, '<DFS> '+sHexSenseDir+' File Upload OK ('+sHexServerFullName+')');
  Result := True;

  //------------------------------------ Delete HEX_INDEX/HEX file uploaded
  DeleteFile(sHexIdxLocalFullName);
  DeleteFile(sHexLocalFullName);

  except  //#############2
  end;    //#############2

  finally //#############1
  //------------------------------------ Disconnect DFS FTP Connection if connected
    if DfsFtpCh[m_nCh].IsConnected then begin
      DfsFtpCh[m_nCh].Disconnect;
    end;
  end;    //#############1

end;
{$ENDIF}


//******************************************************************************
// procedure/function: DfsFtp-to-FrmMain
//
//******************************************************************************

procedure TDfsFtp.SendMainGuiDisplay(nGuiMode, nCh: Integer; nParam: Integer; sMsg: string = ''); //2019-04-09
var
  ccd : TCopyDataStruct;
  MainGuiDfsData : RMainGuiDfsData;
begin
  //Common.MLog(nCh,'<DFS> SendMainGuiDisplay: Mode('+IntToStr(nGuiMode)+') Ch('+IntToStr(nCh+1)+') Param('+IntToStr(nParam)+')',DefPocb.DEBUG_LEVEL_INFO);
{$IFDEF INSPECTOR_POCB}
  MainGuiDfsData.MsgType := DefPocb.MSG_TYPE_DFS;
{$ELSE}
  MainGuiDfsData.MsgType := DefCommon.MSG_TYPE_DFS;
{$ENDIF}
  MainGuiDfsData.Channel := nCh;
  MainGuiDfsData.Mode    := nGuiMode; //
  MainGuiDfsData.Param   := nParam;   // 0:Disconnected, 1:Connected
  MainGuiDfsData.Msg     := sMsg;     //
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(MainGuiDfsData);
  ccd.lpData      := @MainGuiDfsData;
  SendMessage(m_hMain,WM_COPYDATA,0,LongInt(@ccd));  //TBD:A2CH? (nCH->nJig)
end;

//==============================================================================
// DFS_DEFECT : DEFECT/INDEX, DEFECT/INSPECTOR and more?
//==============================================================================

end.
