unit UpdateSupport;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.Classes, System.SysUtils,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, Vcl.ExtCtrls,
  IdExplicitTLSClientServerBase, IdFTP, IdFTPCommon, IdFTPListParseWindowsNT,
  IdFTPList, Math, StrUtils, Vcl.Forms, Vcl.Dialogs, defAimf, WarningMsgAutoUpdate,
  System.Zip;
//  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,

type
  //============================================================================

  TCallBackEvent = procedure(nIdx : Integer;var nRet : Integer; sMsg : AnsiString) ; cdecl;//stdcall;

//  PUpdateSupportData = ^RUpdateSupportData;
//  RUpdateSupportData = record
//    MsgType       : Integer;
//    Channel       : Integer;
//    Mode          : Integer;
//    Param         : Integer;
//    Param2        : Integer;
////    hHandle       : HWND;
//    // Send message로 String 으로 처리 하니 글자 깨짐. --- PC 껏다가 다시 키니깐. 100% 발생.
//    Msg           : string[250];
//  end;

  RInspectorInfo = record
    Param : array[0.. defAimf.MSG_PARA_REQ_MAX] of Integer;
    Data  : array[0.. defAimf.MSG_PARA_REQ_MAX] of string;
  end;

  //
  InFtpConnEvnt = procedure(bConnected : Boolean) of object;
  InFtpErrMsg = procedure(nCh: Integer; sMsg: string) of object;
  InCallBackAimf = procedure(nMode : Integer; var nRet : Integer; sMsg : string) of object;

  TUpdateSupports = class(TObject)

//    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
  private
    fMsgHandlerHWND : HWND;
    m_nMsgType : Integer;
    FIsGuiColorBlack: Boolean;
    FIsSubSwWork : Boolean;
    FIsUpdateFolder : Boolean;
    FInspectInfo : RInspectorInfo;
    FOnCallBackAimf: InCallBackAimf;

    FMcModelName: string;
    FIsAutoLogin: Integer;
    tmrSendSigAimEayt : TTimer;
    tmrCheckingUpdateSw : TTimer;
    FModelInfo  : string;
    FInfoRecipe, FInfoLine, FInfoProduct : string;
    FSetInpectReady: Boolean;
    FFinishRet: Integer;
    FCloseMainApp: Boolean;
    FIsUpdateSwConnectCheck : boolean;
    FIsUpdateSwRestart : boolean;
    FIsDllFunc : Boolean;
    FInfoRecipe2: string;
    FMesLogInId: string;
    FIs1Cg2Panel: Boolean;
    FModelFile2: string;

//    procedure SendMessageMain(nMode,nParam : Integer;sMsg : string);
    procedure GetEventFromAimfSw(nMode : Integer; nParam : Integer; sData : string);
    procedure SetOnCallBackAimf(const Value: InCallBackAimf);
    procedure SetMcModelName(const Value: string);
    procedure SetIsAutoLogin(const Value: Integer);
    procedure OnEaytDelayed(Sender: TObject);
    procedure OnCheckUpdateSw(Sender: TObject);
    procedure SetSetInpectReady(const Value: Boolean);
    procedure SetFinishRet(const Value: Integer);
    procedure SetCloseMainApp(const Value: Boolean);
    procedure delay(Time: Integer);
    procedure SetIs1Cg2Panel(const Value: Boolean);
    procedure SetModelFile2(const Value: string);
  public
    m_hMain, m_hSubSw : HWND;
    function RunSubProgram : Integer;
    function CheckSubProgram : Integer;
    function InitGmesSubSw : Integer;
    procedure InitDllCallbackFunc(ClientCallBackFunc :   TCallBackEvent);
    procedure GetMsgHandle;
    // Common for FTP
    constructor Create(nMsgType : Integer; IsdllFunc : Boolean = False); virtual;
    destructor Destroy; override;
    procedure SendMessageSubSw(nMode,nParam : Integer;sMsg : string = ''; nParam2: Integer = 0);
    procedure ShowWarningMsg;
    procedure SetInspectInfo(nIdx : Integer; Data : string;nParam : Integer = 0);
    procedure TurnOffUpdateSw;
    procedure SendInspectInfoToUdateSw;
    procedure SendInspectInfoToUdateSwAuto;
    function GetRcpFileInfoMobile : string;
    procedure SetModelInfoForGMES(sModelInfoFile : string);
    property OnCallBackAimf :InCallBackAimf read FOnCallBackAimf write SetOnCallBackAimf;
    property MesLogInId : string read FMesLogInId;
    property McModelName : string read FMcModelName write SetMcModelName;
    property IsAutoLogin : Integer read FIsAutoLogin write SetIsAutoLogin;
    property InfoRecipe : string read FInfoRecipe;
    property InfoRecipe2 : string read FInfoRecipe2;
    property InfoLine : string read FInfoLine;
    property InfoProduct : string read FInfoProduct;
    property SetInpectReady : Boolean read FSetInpectReady write SetSetInpectReady;
    property FinishRet : Integer read FFinishRet write SetFinishRet;
    property CloseMainApp : Boolean read FCloseMainApp write SetCloseMainApp;
    property IsSubSwWork  : Boolean read FIsSubSwWork;
    property Is1Cg2Panel : Boolean read FIs1Cg2Panel write SetIs1Cg2Panel;
    property ModelFile2  : string read FModelFile2 write SetModelFile2;
  end;
  procedure FCallBackFunc(nIdx : Integer;var nRet : Integer; sMsg : AnsiString) ; cdecl;
var
  UsObject      : TUpdateSupports;
  clsCallBack   : TCallBackEvent;

implementation

{ TDaeFtp }

function TUpdateSupports.CheckSubProgram: Integer;
var
  hWindow, hShellExec : THandle;
  sExeFile, sDebug : string;
  sDir, sFullDir, sClassName : string;
  bStart : boolean;
begin
  sDir := '\' + defAimf.APP_PATH_AIMF + '\';
  FIsSubSwWork := False;
  FIsUpdateFolder := False;
//  sDebug := 'CheckSubProgram';
//  CodeSite.SendMsg(csmBlue,sDebug);
  sFullDir := ExtractFileDir(ExtractFilePath(Application.ExeName))+ sDir;
  if not DirectoryExists(sFullDir) then begin
    Exit(1);
  end;
  sExeFile := sFullDir + AIMF_APP_FILE_NAME;//'DAE_Auto_Inspector_Upgrate.exe'; //'DAE_Inspector_Upgrade.exe';

  if not FileExists(sExeFile) then Exit(2);
  FIsUpdateFolder := True;
  hWindow := FindWindow(PWideChar(defAimf.AIMF_APP_INS_CLASS), nil);
  hShellExec := 0;
  // 프로그램 실행.
  if hWindow < 1 then begin
    if not FileExists(sExeFile) then begin
      Exit(2);
    end;
    hWindow := ShellExecute(hShellExec, 'open', PChar(sExeFile), nil, nil, SW_SHOW);
    
//    // 1초 주니깐 다음에 인식 못하네요. 충분히 2초.
    self.delay(2000);
    FIsUpdateSwRestart := True;
    hWindow := FindWindow(PWideChar(defAimf.AIMF_APP_INS_CLASS), nil);
  end;
  if hWindow > 0 then begin
    m_hSubSw := hWindow;
    FIsSubSwWork := True;
    FIsUpdateSwRestart := True;
    // reset 되었기 때문에 ( 검사기는 그대로 ) ==> GMES Init 까지 해주어야함.
    Result := 0;
  end
  else begin

    Result := 3;
  end;
end;

constructor TUpdateSupports.Create(nMsgType: Integer; IsdllFunc : Boolean);
begin
  inherited Create;
  FIsSubSwWork := False;
  FCloseMainApp := False;
  FIsUpdateFolder := False;
  FIsdllFunc := IsdllFunc;
//  m_hMain  := hMain;
  m_nMsgType := nMsgType;
  FModelInfo := '';
  FSetInpectReady := False;
  FIsUpdateSwConnectCheck := False;
  FIsUpdateSwRestart := False;
  FIs1Cg2Panel       := False;

  FIsAutoLogin := defAimf.AIMF_IDX_LOG_OFF;
//  if frmWarnMsgAim <> nil then begin
//    frmWarnMsgAim.Free;
//    frmWarnMsgAim := nil;
//  end;
  frmWarnMsgAim := TfrmWarnMsgAim.Create(nil);
  frmWarnMsgAim.OnEventMsgData := GetEventFromAimfSw;
  frmWarnMsgAim.Caption := defAimf.INS_COMM_CAPTION;

  tmrSendSigAimEayt := TTimer.Create(nil);
  tmrSendSigAimEayt.OnTimer := OnEaytDelayed;
  tmrSendSigAimEayt.Interval := 1000;
  tmrSendSigAimEayt.Enabled := False;

  tmrCheckingUpdateSw := TTimer.Create(nil);
  tmrCheckingUpdateSw.OnTimer := OnCheckUpdateSw;
  tmrCheckingUpdateSw.Interval := 1000;
  tmrCheckingUpdateSw.Enabled := False;

//  // Handle값 잃어 버리는 case 때문.
//  frmWarnMsgAim.Show;
//  frmWarnMsgAim.Hide;
//  frmWarnMsgAim.Visible := False;
//  frmWarnMsgAim.Hide;
end;

procedure TUpdateSupports.delay(Time: Integer);
var
   PastCount: LongInt;
begin
  PastCount := GetTickCount;
  repeat
    Sleep(1);
    Application.ProcessMessages;
  until ((GetTickCount-PastCount) >= LongInt(Time));
end;

destructor TUpdateSupports.Destroy;
begin
  inherited;
  if tmrCheckingUpdateSw <> nil then begin
    tmrCheckingUpdateSw.Enabled := False;
    tmrCheckingUpdateSw.Free;
    tmrCheckingUpdateSw := nil;
  end;

  if tmrSendSigAimEayt <> nil then begin
    tmrSendSigAimEayt.Enabled := False;
    tmrSendSigAimEayt.Free;
    tmrSendSigAimEayt := nil;
  end;
  if frmWarnMsgAim <> nil then begin
    frmWarnMsgAim.OnEventMsgData := nil;
    frmWarnMsgAim.Free;
    frmWarnMsgAim := nil;
  end;

end;


procedure TUpdateSupports.GetEventFromAimfSw(nMode, nParam: Integer; sData: string);
var
  nRet : Integer;
  sDebug : string;
//  th  : TThread;
begin
  FIsSubSwWork := True;
//  sDebug := format('[INSP] RX - GetEventFromAimfSw - nMode(%d), nParam(%d),sData:',[nMode, nParam, sData]);
//  CodeSite.SendMsg(csmBlue,sDebug);
  case nMode of
    defAimf.MSG_MODE_UPDATE_CALL_STATUS : begin
      if FIsDllFunc then FCallBackFunc(nMode,nRet,sData)
      else               OnCallBackAimf(nMode,nRet,sData);
      SendMessageSubSw(defAimf.MSG_MODE_SEND_INSPECT_STATUS , nRet);
    end;
    defAimf.MSG_MODE_UPDATE_CALL_STATUS2 : begin
      if FIsDllFunc then FCallBackFunc(nMode,nRet,sData)
      else               OnCallBackAimf(nMode,nRet,sData);
      SendMessageSubSw(defAimf.MSG_MODE_SEND_INSPECT_STATUS , nRet);
    end;
    defAimf.MSG_MODE_EAYT_INFO_CALL : begin
      if FIsDllFunc then FCallBackFunc(nMode,nRet,sData)
      else               OnCallBackAimf(nMode,nRet,sData);
      SendMessageSubSw(defAimf.MSG_MODE_EAYT_INSPECT_STATUS , nRet);
      if FIsUpdateSwRestart then begin
        FIsUpdateSwRestart := False;
        InitGmesSubSw;
      end;
    end;
    defAimf.MSG_MODE_EADR_INFO   : begin
      case nParam of
        defAimf.MSG_PARAM_EADR_INFO_RECIPE : begin
          FInfoRecipe := Trim(UpperCase(sData));
        end;
        defAimf.MSG_PARAM_EADR_INFO_RECIPE2 : begin
          FInfoRecipe2 := Trim(UpperCase(sData));
        end;
        defAimf.MSG_PARAM_EADR_INFO_LINE : begin
          FInfoLine  := Trim(UpperCase(sData));
        end;
        defAimf.MSG_PARAM_EADR_INFO_PRODUCT : begin
          FInfoProduct  := Trim(UpperCase(sData));
        end;
        defAimf.MSG_PARAM_EADR_MODEL_FILE2 : begin
          FModelFile2   := Trim(sData);
        end;
      end;
    end;
    defAimf.MSG_MODE_INSP_UPDATE_FINISH : begin

      TThread.CreateAnonymousThread(procedure begin
        TThread.Synchronize(TThread.CurrentThread, procedure() begin
          FFinishRet := frmWarnMsgAim.DownloadRet;
          if FIsDllFunc then FCallBackFunc(defAimf.MSG_MODE_INSP_UPDATE_FINISH,nRet,sData)
          else               OnCallBackAimf(defAimf.MSG_MODE_INSP_UPDATE_FINISH,nRet,sData);
        end);
      end).Start;

    end;
    defAimf.MSG_MODE_CONNECT_INTERVAL : begin
      FIsUpdateSwConnectCheck := False;
      tmrCheckingUpdateSw.Enabled := False;
      if nParam <> 0 then begin
        tmrCheckingUpdateSw.Interval := nParam * 1000;
        tmrCheckingUpdateSw.Enabled := True;
        FIsUpdateSwConnectCheck := True;
      end;
    end;
    defAimf.MSG_MODE_INSPECT_OFF : begin  // SW 강제 OFF.
      CloseMainApp := True;
      if FIsDllFunc then FCallBackFunc(nMode,nRet,sData)
      else               OnCallBackAimf(nMode,nRet,sData);
    end;
    defAimf.MSG_MODE_1CG_PANEL : begin
      FIs1Cg2Panel := nParam <> 0;
    end;

    defAimf.MSG_MODE_UPDATE_AUTO_LOGIN : begin
      FMesLogInId := sData;
      FIsAutoLogin := nParam;
//      OnCallBackAimf(nMode,nRet,sData);
    end
    else begin
//      OnCallBackAimf(nMode,nRet,sData);
      if FIsDllFunc then FCallBackFunc(nMode,nRet,sData)
      else               OnCallBackAimf(nMode,nRet,sData);
    end;
  end;

end;

procedure TUpdateSupports.SetModelFile2(const Value: string);
begin
  FModelFile2 := Value;
end;

procedure TUpdateSupports.SetModelInfoForGMES(sModelInfoFile: string);
var
  dtTime : TDateTime;
  sAppPath : string;
  sFileName : string;

begin
  FModelInfo := '';
  sAppPath := ExtractFilePath(Application.ExeName);
  sFileName := UpperCase(ExtractFileName( sModelInfoFile)) ;
  if FileExists(sModelInfoFile) then begin
    FileAge(sModelInfoFile,dtTime);
    FModelInfo := sFileName + FormatDateTime('_yyyymmddhhnnss', dtTime);
  end;
end;

procedure TUpdateSupports.GetMsgHandle;
var
  sMsg : string;
begin
  //sMsg := Format('Handle : %d ',[frmWarnMsgAim.Handle]);
  SendMessageSubSw(defAimf.MSG_MODE_UPDATE_HANDLE_SEND, DefAimf.MSG_PARA_GMES_INIT);
end;

function TUpdateSupports.GetRcpFileInfoMobile: string;
var
  sRet, sAppPath, sCurModelPath, sCurPattern, s : string;
  sFileName : string;
  dtTime : TDateTime;
begin
  if not FIsUpdateFolder then Exit('');

  sAppPath := ExtractFilePath(Application.ExeName);

  sRet := ' RCP_FILE_INFO=[';
  sRet := sRet + 'SCRIPT:'+FModelInfo+',';

  // Check for pattern file.
  sCurPattern := sAppPath + '\pattern\';
  if DirectoryExists(sCurPattern) then begin
    sFileName := sCurPattern + 'AllPat.dat';
    if FileExists(sFileName) then begin
      FileAge(sFileName,dtTime);
      sRet := sRet + 'ALLPAT:ALLPAT.DAT'+FormatDateTime('_yyyymmddhhnnss', dtTime)+',';
    end;
  end;

  // Check for UI.
  sAppPath := UpperCase(ExtractFileName(Application.ExeName));
  FileAge(Application.ExeName,dtTime);

  sRet := sRet + 'UI:'+sAppPath+FormatDateTime('_yyyymmddhhnnss', dtTime);
  sRet := sRet + '] EQP_MAKER=DAE';
  Result := sRet;
end;

procedure TUpdateSupports.InitDllCallbackFunc(ClientCallBackFunc: TCallBackEvent);
begin
  clsCallBack := ClientCallBackFunc;
end;

function TUpdateSupports.InitGmesSubSw: Integer;
begin
  if not FIsSubSwWork then Exit(2);
  tmrSendSigAimEayt.Enabled := True;

  Result := 0;
end;

procedure TUpdateSupports.OnCheckUpdateSw(Sender: TObject);
begin
  tmrCheckingUpdateSw.Enabled := False;
  CheckSubProgram;
  if FIsUpdateSwConnectCheck then tmrCheckingUpdateSw.Enabled := True;
end;

procedure TUpdateSupports.OnEaytDelayed(Sender: TObject);
begin
  tmrSendSigAimEayt.Enabled := False;
  SendMessageSubSw(MSG_MODE_UPDATE_SEQ_START, DefAimf.MSG_PARA_GMES_INIT);
end;

function TUpdateSupports.RunSubProgram : Integer;
var
  hWindow, hShellExec : THandle;
  sExeFile : string;
  sDir, sFullDir : string;
begin
  sDir := '\' + defAimf.APP_PATH_AIMF + '\';
  FIsSubSwWork := False;
  FIsUpdateFolder := False;
  sFullDir := ExtractFileDir(ExtractFilePath(Application.ExeName))+ sDir;
  if not DirectoryExists(sFullDir) then begin
    //MessageDlg(#13#10 + 'There is no the Path(' +sFullDir+')!!!', mtError, [mbOk], 0);
    Exit(1);
  end;
  sExeFile := sFullDir + AIMF_APP_FILE_NAME; // 'DAE_Inspector_Upgrade.exe';   // DAE_Auto_Inspector_Upgrate
//  sClassName := 'TfrmAutoUpdateExe';
  if not FileExists(sExeFile) then Exit(2);
  FIsUpdateFolder := True;

  hWindow := FindWindow(PWideChar(defAimf.AIMF_APP_INS_CLASS), nil);
  hShellExec := 0;
  // 프로그램 실행.
  if hWindow < 1 then begin
    if not FileExists(sExeFile) then begin
      //MessageDlg(#13#10 + 'There is no the Exe file('+#13#10+sExeFile+')!!!', mtError, [mbOk], 0);
      Exit(2);
    end;
    hWindow := ShellExecute(hShellExec, 'open', PChar(sExeFile), nil, nil, SW_SHOW);
//    // 1초 주니깐 다음에 인식 못하네요. 충분히 2초.
    Sleep(2000);
    if hWindow < 1 then begin
      hWindow := FindWindow(PWideChar(defAimf.AIMF_APP_INS_CLASS), nil);
    end;
  end;
  if hWindow > 0 then begin
    m_hSubSw := hWindow;
    SendMessageSubSw(MSG_MODE_UPDATE_SEQ_START, DefAimf.MSG_PARA_CONNECT_INSPECTOR);
    FIsSubSwWork := True;
    Result := 0;
  end
  else begin
    Result := 3;
  end;

end;

procedure TUpdateSupports.SendInspectInfoToUdateSw;
var
  th : TThread; 
begin
  th := TThread.CreateAnonymousThread( procedure var nIdx, nParam : Integer; sData : string; begin
    nIdx := DefAimf.MSG_PARA_REQ_USER_ID;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_CUR_EQPID;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_OLD_SW_VERSION;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_OLD_MODEL_CH1;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_APP_PATH;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_INSPECT_MODEL;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_LINE_MODE;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);
  end);
  th.Start;
end;

procedure TUpdateSupports.SendInspectInfoToUdateSwAuto;
var
  th : TThread; 
begin
  th := TThread.CreateAnonymousThread( procedure var nIdx, nParam : Integer; sData : string; begin
    nIdx := DefAimf.MSG_PARA_REQ_USER_ID;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_CUR_EQPID;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_OLD_SW_VERSION;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_OLD_MODEL_CH1;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);
    nIdx := DefAimf.MSG_PARA_REQ_OLD_MODEL_CH2;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);
    
    nIdx := DefAimf.MSG_PARA_REQ_APP_PATH;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_INSPECT_MODEL;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_INSPECT_MODEL2;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);

    nIdx := DefAimf.MSG_PARA_REQ_LINE_MODE;
    sData := FInspectInfo.Data[nIdx];  nParam := FInspectInfo.Param[nIdx];
    SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,sData,nParam);
  end);
  th.Start;
end;

procedure TUpdateSupports.SendMessageSubSw(nMode, nParam: Integer; sMsg: string; nParam2: Integer);
var
  cds       : TCopyDataStruct;
  UsData    : RGuiAimfComm;
  hWindow   : HWND;
  sClassName, sDebug : string;
begin
//  sClassName := 'TfrmAutoUpdateExe';
  hWindow := FindWindow(PWideChar(defAimf.AIMF_APP_INS_CLASS), nil);
  if hWindow < 1 then Exit;


  UsData.MsgType := m_nMsgType;
  UsData.Channel := 0;
  UsData.Mode    := nMode;
  UsData.Param   := nParam;
  UsData.Param2  := nParam2;
  UsData.Msg     := sMsg;
  if frmWarnMsgAim <> nil then begin
    UsData.Handle  := frmWarnMsgAim.Handle;
  end
  else begin
    UsData.Handle := 0;
  end;
//  UsData.Class_Handle := fMsgHandlerHWND;
  cds.dwData      := 0;
  cds.cbData      := SizeOf(UsData);
  cds.lpData      := @UsData;
//  sDebug := format('[INSP] TX - SendMessageSubSw - mode(%d), param(%d), sMsg(%s)',[nMode, nParam, sMsg]);
//  CodeSite.SendMsg(csmBlue,sDebug);
  SendMessage(hWindow, WM_COPYDATA, 0, LongInt(@cds));
end;


procedure TUpdateSupports.SetCloseMainApp(const Value: Boolean);
begin
  FCloseMainApp := Value;
end;

procedure TUpdateSupports.SetFinishRet(const Value: Integer);
begin
  FFinishRet := Value;
end;

procedure TUpdateSupports.SetInspectInfo(nIdx: Integer; Data: string;nParam : Integer);
begin
  FInspectInfo.Data[nIdx]  := Data;
  FInspectInfo.Param[nIdx] := nParam;
  SendMessageSubSw(MSG_MODE_SYSTEM_INFO_REQ,nIdx,Data,nParam);
  SendMessageSubSw(MSG_MODE_MSG_LOG,0,'Param Set : '+Data);
end;

procedure TUpdateSupports.SetIs1Cg2Panel(const Value: Boolean);
begin
  FIs1Cg2Panel := Value;
end;

procedure TUpdateSupports.SetIsAutoLogin(const Value: Integer);
begin
  FIsAutoLogin := Value;
end;

procedure TUpdateSupports.SetMcModelName(const Value: string);
begin
  FMcModelName := Value;
end;

procedure TUpdateSupports.SetOnCallBackAimf(const Value: InCallBackAimf);
begin
  FOnCallBackAimf := Value;
  FIsSubSwWork := True;
end;

procedure TUpdateSupports.SetSetInpectReady(const Value: Boolean);
begin
  FSetInpectReady := Value;
  if Value then begin
    SendMessageSubSw(defAimf.MSG_MODE_INSPECTOR_READY_RTN , 0);
  end;

end;

procedure TUpdateSupports.ShowWarningMsg;
begin
  if frmWarnMsgAim <> nil then begin
    frmWarnMsgAim.Show;
  end;
end;

procedure TUpdateSupports.TurnOffUpdateSw;
begin
  if not FCloseMainApp then
    SendMessageSubSw(DefAimf.MSG_MODE_UPDATE_SW_CLOSE,0);
end;

procedure FCallBackFunc(nIdx : Integer;var nRet : Integer; sMsg : AnsiString) ; cdecl;
begin
  if Assigned(clsCallBack)  then begin
    clsCallBack(nIdx,nRet,sMsg);
  end;
end;

end.
