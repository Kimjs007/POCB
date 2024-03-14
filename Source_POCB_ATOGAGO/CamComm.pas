unit CamComm; // TCP-IP Communication for DPC(Camera-PC) interworking

interface
{$I Common.inc}

uses
	System.Classes, System.Threading, System.SysUtils,Generics.Collections,
	Winapi.Messages, Winapi.Windows, Winapi.WinSock, {GenQueue,} UserUtils,
	IdContext, IdGlobal, IdSync, IdTCPClient, IdTCPServer, Vcl.Graphics,
  IdComponent, IdCustomTCPServer,
//{$IFDEF DEBUG}
	CodeSiteLogging,
//{$ENDIF}
	DefCam, DefPG, DefPocb, DefGmes, CommonClass, UdpServerPocb, ExLightCtl; //2019-04-17

type

  InCamConnEvnt = procedure(nCam : Integer; tcpPort: Integer; nConnect: Integer) of object;  //2018-12-14
  InCamReadWriteMsg = procedure(nCam, nParam, nErrCode : Integer; sMsg : string; ABuff : array of Byte) of object;
  InCamTEndEvnt = procedure(nCam: Integer; nCamRet: enumCamRetType) of object;

  CommRec = record
    msgSize   : Integer;
    CheckSum  : Integer;
    msgData   : array of Byte;
  end;

  PMainGuiCamData  = ^RMainGuiCamData;  //Cam -> FrmMain
  RMainGuiCamData = packed record
    MsgType : Integer;
    Channel : Integer;
    Mode    : Integer;
    Param   : Integer;
    Msg     : string;
  end;

  PTestGuiCamData  = ^RTestGuiCamData;  //Cam -> Test1Ch
  RTestGuiCamData = packed record
    MsgType : Integer;
    Channel : Integer;
    Mode    : Integer;
    Param   : Integer;
    Param2  : Integer;
    Msg     : string;
  end;

  RCsvCamData = record
    IsGRR      : Boolean;
    VerStr   : string;
    NgMsg    : string[200];
		// Uniformoty Verify
    UniformityPost       : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of Double; //Uniformity    -> UniformityPost
    UniformityPre        : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of Double; //PreUniformity -> UniformityPre
    UniformityResult     : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of string; //RetUniform    -> UniformityResult
    HasUniformityPoint   : Boolean;                                            //HasValues     -> HasUniformityPoint
    UniformityPointsPost : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of string; //Values        -> UniformityPointsPost
    UniformityPointsPre  : array[0..DefPocb.UNIFORMITY_PATTERN_MAX] of string; //PreValues     -> UniformityPointPre
  end;

  TCamComm = class (TObject)
    idCamServer   : TIdTCPServer;
    IdCamClients  : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of TIdTCPClient;
  private
    m_hMain       		: HWND;
    FOnCamConnection  : InCamConnEvnt;
    FOnRevData        : InCamReadWriteMsg;
    FOnTEndEvt        : InCamTEndEvnt;
    FOnTEndEvt1       : InCamTEndEvnt;
    //
    m_bIsGettingData  : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of Boolean;
    m_bFirstDataRecv  : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of Boolean; //2018-12-03
    //
    m_nLastPos : array[DefPocb.CAM_1 .. DefPocb.CAM_MAX] of Integer;  //TBD:SDIP?
    //
    // procedure/function: CamComm Create/Destroy/Init
    procedure SetOnCamConnection(const Value: InCamConnEvnt);
    procedure SetOnRevData(const Value: InCamReadWriteMsg);
    procedure SetOnTEndEvt(const Value: InCamTEndEvnt);
    procedure SetOnTEndEvt1(const Value: InCamTEndEvnt);
    // procedure/function: CamComm Client Callback (GPC:clint -> DPC:server)
    procedure CamClientConnected(Sender: TObject);      //2018-12-14
    procedure CamClientDisconnected(Sender: TObject);   //2018-12-14
    function GetTcpServer2CamNo(AContext: TIdContext): Integer; //2018-12-14
    procedure TcpServerExecute(AContext: TIdContext);
    procedure CamServerConnected(AContext: TIdContext);     //2018-12-14
    procedure CamServerDisconnected(AContext: TIdContext);  //2018-12-14
  //procedure CamServerListenException(AThread: TIdListenerThread; AException: Exception); //2019-01-02
  //procedure CamServerStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string); //2019-01-02
    // procedure/function:
    procedure ThreadTask(task: TProc);
    procedure ThreadCmd(nCh: Integer; sCamChange: string);
    // procedure/function: GPC --> DPC
    function SendDataByClient(nCam, nSize: Integer; ABuffer: TIdBytes): Boolean;
    function ReceiveBufferByClient(nCam, nWaitTime : Integer; var ABuffer : TIdBytes) : Boolean;
    function SendDataByServer(nCam: Integer; sRet : string;const AContext: TIdContext): Boolean;
    // procedure/function: GPC <--- DPC
    function SendPgmaByServer(nCam: Integer; const AContext : TIdContext;sCmd : string;Abuffer : Array of Byte) : Boolean;
    procedure ParseTendMsg(nCam : Integer; sRevData : string);
    function ParseUniformityMsg(nCam: Integer; sRevData : string) : Boolean;
  //function ServerReceiveBuffer(AContext: TIdContext;var nLen : Integer; var ABuffer: TIdBytes): Boolean;  //deleted
    // procedure/function: CamComm -> PG/SPI
    procedure BmpDownload(nCam: Integer; const AContext: TIdContext); //#BmpToDownload
    // procedure/function: CamComm <-> otherClasses
    procedure SendMainGuiDisplay(nGuiMode, nCh, nParam: Integer; sMsg: string);
    procedure SendTestGuiDisplay(nGuiMode, nCh: Integer; sMsg: string; nParam: Integer = 0; nParam2: Integer = 0);  //2019-05-20
  public
    m_hTest       : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of HWND;  // for CamComm->frmTest1Ch
    m_hMainter    : HWND; //TBD?
    m_hModelDown  : HWND; //TBD?
    m_bFirstConnect   : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of Boolean; //TBD?
    //
    m_nCurCBIdx   : array [0..DefPocb.CAM_MAX] of Integer; //TBD:GAGO:NEWFLOW?
    m_csvCamData  : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of RCsvCamData;
    m_sSerialNo   : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of string;  //2022-11-18
    m_sPanelID    : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of string;  //2021-12-23
    m_sCamNg      : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of string;
    m_nSendData   : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of TFileTranStr;
    m_bForceStop  : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of Boolean;  //2018-12-11
    m_bSendTSTOP  : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of Boolean;  //2018-12-11
    m_bCamClient  : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of Boolean;  //2019-01-10
    m_bCamServer  : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of Boolean;  //2019-01-10
    m_nBmpDownCnt : array[DefPocb.CAM_1 .. DefPocb.CAM_MAX] of Integer; //2019-02-08 BMP_SHARE:MoveFromPrivate
    m_bIsOnCamFlow : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of Boolean;  //A2CHv3:ASSY-POCB(Flow)
    m_bCamZoneDone : array[DefPocb.CAM_1..DefPocb.CAM_MAX] of Boolean;  //A2CHv3:ASSY-POCB(Flow)
    // procedure/function: CamComm Create/Destroy/Init
    constructor Create(hMain : THandle); virtual;
    destructor Destroy; override;
    property OnCamConnection : InCamConnEvnt read FOnCamConnection write SetOnCamConnection;
    property OnRevData : InCamReadWriteMsg read FOnRevData write SetOnRevData;
    property OnTEndEvt : InCamTEndEvnt read FOnTEndEvt write SetOnTEndEvt;
    property OnTEndEvt1 : InCamTEndEvnt read FOnTEndEvt1 write SetOnTEndEvt1;
    function CamNo2ChNo(nCam: Integer): Integer;
    function ChNo2CamNo(nCh: Integer): Integer;
    // procedure/function: CamComm Callback

    // procedure/function:

    procedure InitCamBuf(nCam: Integer);
    procedure CheckClientConnect(nCam: Integer);
    procedure ConnectCam(nCam: Integer; bConnect: boolean = True);
    // procedure/function: GPC --> DPC
    function SendCmd(nCam: Integer; sCommand: string; nWaitTime: Integer = TIMEVAL_CAM_RESPWAIT): boolean;
    // procedure/function: GPC <--- DPC
    procedure ReadSvr(nCam, nLen: Integer; ABuff: TidBytes; const AContext: TIdContext);
    procedure SaveCBDATAFile(nCam: Integer; const SBuffer: array of Byte);
    procedure SaveBmpData(nCam: Integer; const SBuffer: array of Byte);
    // procedure/function: CamComm -> PG/SPI
    // procedure/function: CamComm <-> otherClasses
    procedure SetModelSet;
    procedure SendTSTOP(nCam: Integer);

//******************************************************************************
// procedure/function: CamComm Create/Destroy/Init
//    - Create(hMain : THandle)
//    - Destroy
//    - SetOnCamConnection(const Value: InCamConnEvnt)
//    - SetOnRevData(const Value: InCamReadWriteMsg)
//    - SetOnTEndEvt(const Value: InCamTEndEvnt)
//    - SetOnTEndEvt1(const Value: InCamTEndEvnt)
//    - SetIsConnected(const Value: Boolean)   //TBD?: SDIP(X)
// procedure/function: CamComm Callback
//    - CamConneced(Sender: TObject)
//    - CamDisconneced(Sender: TObject)
//    - TcpServerExecute(AContext: TIdContext)
// procedure/function:
//    - InitCamBuf(nCAM : Integer)
//    - CheckClientConnect  // from MainPocb
//    - ConnectCam(nCAM: Integer; bConnect: boolean)  // from Mainter
//    - ThreadCmd(nIdx: Integer; sCamChange : string)
//    - ThreadTask(task: TProc)
// procedure/function: GPC --> DPC
//    - SendCmd(nCAM: Integer; sCommand: string; nWaitTime: Integer = TIMEVAL_CAM_RESPWAIT): boolean;
//    - SendDataByClient(nCAM, nSize: Integer; ABuffer: TIdBytes): Boolean;
//    - ReceiveBufferByClient(nCamCh, nWaitTime: Integer; var ABuffer: TIdBytes): Boolean;
//    - SendDataByServer(nCAM: Integer; sRet : string;const AContext: TIdContext): Boolean
// procedure/function: GPC <--- DPC
//    - ReadSvr(nCAM, nLen: Integer; ABuff: array of Byte; const AContext: TIdContext)
//    - SendPgmaByServer(const AContext: TIdContext; sCmd: string; Abuffer: array of Byte): Boolean   // Called-by ReadSvr
//    - ParseTendMsg(nCAM: Integer; sRevData: string)  // Called-by ReadSvr
//    - saveBmpData(nCh: Integer; const SBuffer: array of Byte)   // Called-by ReadSvr
//    - SaveCBDATAFile(nCh: Integer; const SBuffer: array of Byte)   // Called-by ReadSvr
// procedure/function: CamComm -> PG/SPI
//    - BmpDownload(nCam: Integer; const AContext: TIdContext)   // Called-by ReadSvr
// procedure/function: CamComm <-> otherClasses
//    - SendMainGuiDisplay(nGuiMode, nCH, nParam: Integer; sMsg: string)
//    - SendTestGuiDisplay(nGuiMode, nCH: Integer; sMsg: string; nParam: Integer = 0)
//    - SetModelSet
//******************************************************************************
  end;

var
  CameraComm  : TCamComm;

implementation

uses OtlTaskControl, OtlParallel, LogicPocb;

{ TCamComm }
//{$R+}

//******************************************************************************
// procedure/function: CamComm Create/Destroy/Init
//    - Create(hMain : THandle)
//    - Destroy
//    - SetOnCamConnection(const Value: InCamConnEvnt)
//    - SetOnRevData(const Value: InCamReadWriteMsg)
//    - SetOnTEndEvt(const Value: InCamTEndEvnt)
//    - SetOnTEndEvt1(const Value: InCamTEndEvnt)
//    - SetIsConnected(const Value: Boolean)   //TBD?: SDIP(X)
//******************************************************************************

constructor TCamComm.Create(hMain : THandle);
var
  nCam : Integer;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<CameraCtl> Create');
  m_hMain := hMain;

  // Create GPC TCP Server for DPC(Camera-PC)
  idCamServer := TIdTCPServer.Create(nil);
  idCamServer.OnExecute         := TcpServerExecute;
  idCamServer.Bindings.Clear;
  idCamServer.Bindings.Add.IP   := DefCam.BASE_TCP_SERVER_IP;
  idCamServer.Bindings.Add.Port := DefCam.BASE_SERVER_PORT;
  idCamServer.ReuseSocket       := rsTrue;                    //Add 2019-01-17 //2023-07-01 rsTrue->rsFalse?
  idCamServer.OnConnect         := CamServerConnected;        //2018-12-14
  idCamServer.OnDisconnect      := CamServerDisconnected;     //2018-12-14
//idCamServer.OnListenException := CamServerListenException;  //2019-01-02
//idCamServer.OnStatus          := CamServerStatus;           //2019-01-02
  // TIdReuseSocket is an enumerated type that represents the manner in which socket reuse is supported in Indy TCP servers.
  // TIdReuseSocket can contain one of the following values and associated meanings:
	//    Value  		      Meaning
	//    rsOSDependent  	Reuse IP addersses and port numbers when the OS platform is Linux. (default)
	//    rsTrue  	      Always resuse IP addersses and port numbers.
	//    rsFalse  	      Never resuse IP addersses and port numbers.

  for nCam := DefPocb.CAM_1 to DefPocb.CAM_MAX do begin
    m_bIsGettingData[nCam]  := False;
  	m_bFirstConnect[nCam]   := True;  //2018-12-14 TBD?
    m_bFirstDataRecv[nCam]  := False;
    m_bCamServer[nCam]      := False; //2019-01-10
    m_bCamClient[nCam]      := False; //2019-01-10
  end;
  try
    idCamServer.Active := True;
  except
    on e: Exception do
      begin
      //CodeSite.Send(e.Message);
      end;
  end;

  // Create GPC TCP Clients to each DPC(Camera-PC)
  for nCAM := DefPocb.CAM_1 to DefPocb.CAM_MAX do begin
    IdCamClients[nCam]         := TIdTCPClient.Create(nil);
  //2019-01-03 IdCamClients[nCam].BoundIP := DefCam.BASE_TCP_SERVER_IP;
    IdCamClients[nCam].Host    := DefCam.BASE_TCP_CLINT_IP + Format('%d',[nCAM+BASE_DPC_IPADDR]);
{$IFDEF SIMULATOR_CAM}
    IdCamClients[nCam].Port := DefCam.BASE_CLINT_PORT + nCam;
{$ELSE}
    IdCamClients[nCam].Port := DefCam.BASE_CLINT_PORT;
{$ENDIF}
   {//2019-01-03 TBD:CAM:TCP?  IdCamClients[nCam].IOHanClosedGracefully }
    //2018-12-18 TBD:CAM:TCP?  IdCamClients[nCam].ReuseSocket := rsTrue;
    //2018-12-18 TBD:CAM:TCP?  IdCamClients[nCam].ManagedIOHandler := True;
    IdCamClients[nCam].Tag    := nCam;
    IdCamClients[nCam].OnConnected    := CamClientConnected;                //2018-12-14
  //REMOVE!!!  IdCamClients[nCam].OnDisconnected := CamClientDisconnected;  //2018-12-14
    IdCamClients[nCam].ConnectTimeout := TIMEVAL_CAM_CONNWAIT;  // default: 1000 msec
    IdCamClients[nCam].ReadTimeout    := TIMEVAL_CAM_RESPWAIT;  // default: 3000 msec
    // Connection Check.
  end;
end;

destructor TCamComm.Destroy;
var
  nCAM : integer;
begin
  for nCAM := DefPocb.CAM_1 to DefPocb.CAM_MAX do begin
    if IdCamClients[nCam] <> nil then begin
      IdCamClients[nCam].OnConnected  := nil;  //2019-01-02
      if IdCamClients[nCAM].Connected then IdCamClients[nCAM].Disconnect; 
      IdCamClients[nCam].Free;
      IdCamClients[nCam] := nil;
    end;
  end;
  if idCamServer <> nil then  begin
    idCamServer.OnConnect         := nil;  //2019-01-02
    idCamServer.OnDisconnect      := nil;  //2019-01-02
  //idCamServer.OnListenException := nil;  //2019-01-02 TBD:CAM:TCP?
  //idCamServer.OnStatus          := nil;  //2019-01-02 TBD:CAM:TCP?
    //
    idCamServer.Active := False;
    idCamServer.Free;
    idCamServer := nil;
  end;
  inherited;
end;

procedure TCamComm.SetOnCamConnection(const Value: InCamConnEvnt);
begin
  FOnCamConnection := Value;
end;

procedure TCamComm.SetOnRevData(const Value: InCamReadWriteMsg);
begin
  FOnRevData := Value;
end;

procedure TCamComm.SetOnTEndEvt(const Value: InCamTEndEvnt);
begin
  FOnTEndEvt := Value;
end;

procedure TCamComm.SetOnTEndEvt1(const Value: InCamTEndEvnt);
begin
  FOnTEndEvt1 := Value;
end;

function TCamComm.CamNo2ChNo(nCam: Integer): Integer;
begin
  Result := nCam;   // A2CH|F2CH-specific: CamNo = ChNo
end;

function TCamComm.ChNo2CamNo(nCh: Integer): Integer;
begin
  Result := nCh;    // A2CH|F2CH-specific: CamNo = ChNo
end;

//******************************************************************************
// procedure/function: CamComm Callback
//    - CamConneced(Sender: TObject)
//    - CamDisconneced(Sender: TObject)
//    - TcpServerExecute(AContext: TIdContext)
//******************************************************************************

procedure TCamComm.CamClientConnected(Sender: TObject);
var
  nCam : Integer;
begin
  nCam := (Sender as TIdTCPClient).Tag;
  //CodeSite.Send('CAM'+IntToStr(nCam+1)+': GPC --> DPC(CameraPC) Connected');
  m_bCamClient[nCam] := True; //before OnCamConnection!!! //2019-01-10
  if m_bFirstConnect[nCam] then begin
    if Assigned(OnCamConnection) then OnCamConnection(nCam,DefCam.BASE_CLINT_PORT,DefCam.CAM_CONNECT_FIRST_OK);
  end
  else begin
    if Assigned(OnCamConnection) then OnCamConnection(nCam,DefCam.BASE_CLINT_PORT,DefCam.CAM_CONNECT_OK);
  end;
  m_bFirstConnect[nCam] := False;
end;

procedure TCamComm.CamClientDisconnected(Sender: TObject);
var
  nCam : Integer;
  sDebug : string;
begin
  nCam := (Sender as TIdTCPClient).Tag;
//CodeSite.Send('CAM'+IntToStr(nCam+1)+': GPC --> DPC(CameraPC) Disconnected');
  if m_bCamClient[nCam] then begin //2019-01-10 (if CamConn NG, NG Message and Stop Flow)
    sDebug := Format('Ch%d ',[nCAM + 1]) + 'GPC -> DPC(CameraPC) Communication NG';
    SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCam,0,sDebug); //GUI:SystemNgMsg
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCam,sDebug,1); //GUI:JigStatus & StopbyAlarm
  end;
  m_bCamClient[nCam] := False; //before OnCamConnection!!! //2019-01-10
  if Assigned(OnCamConnection) then OnCamConnection(nCam,DefCam.BASE_CLINT_PORT,DefCam.CAM_CONNECT_NG);
end;

procedure TCamComm.CamServerConnected(AContext: TIdContext);  //2018-12-14
var
  nCam : Integer;
begin
  nCam := GetTcpServer2CamNo(AContext);
  if not (nCam in [DefPocb.CAM_1..DefPocb.CAM_MAX]) then begin
    Exit;
  end;
//CodeSite.Send('CAM'+IntToStr(nCam+1)+': GPC <-- DPC(CameraPC) Connected');
  m_bCamServer[nCam] := True; //before OnCamConnection!!! //2019-01-10
  if Assigned(OnCamConnection) then OnCamConnection(nCam,DefCam.BASE_SERVER_PORT,DefCam.CAM_CONNECT_OK);
  //
  CheckClientConnect(nCam);  //2019-01-15 (TcpServer Session Conn/Disc��, TcpClient Session Check �߰�)
end;

procedure TCamComm.CamServerDisconnected(AContext: TIdContext);  //2018-12-14
var
  nCam : Integer;
  sDebug : string;
begin
  nCam := GetTcpServer2CamNo(AContext);
  if not (nCam in [DefPocb.CAM_1..DefPocb.CAM_MAX]) then begin
    Exit;
  end;
//CodeSite.Send('CAM'+IntToStr(nCam+1)+': GPC <-- DPC(CameraPC) Disconnected');

  if m_bCamServer[nCam] then begin //2019-01-10 (if CamConn NG, NG Message and Stop Flow)
    sDebug := Format('Ch%d ',[nCAM + 1]) + 'GPC <- DPC(CameraPC) Communication NG';
    SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCam,0,sDebug); //GUI:SystemNgMsg
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCam,sDebug,1); //GUI:JigStatus & StopbyAlarm
    SendTestGuiDisplay(DefPocb.MSG_MODE_STOP_CAMERA,nCam,sDebug,1);
  end;
  m_bCamServer[nCam] := False; //before OnCamConnection!!! //2019-01-10
  if Assigned(OnCamConnection) then OnCamConnection(nCam,DefCam.BASE_SERVER_PORT,DefCam.CAM_CONNECT_NG);
  //
  CheckClientConnect(nCam);  //2019-01-15 (TcpServer Session Conn/Disc��, TcpClient Session Check �߰�)
end;

{
procedure TCamComm.CamServerListenException(AThread: TIdListenerThread; AException: Exception);
begin
  CodeSite.Send('<CAM> CamServerListenException');
end;

procedure TCamComm.CamServerStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
var
  sStatus : string;
begin
  case AStatus of
    hsResolving     : sStatus := 'hsResolving';
    hsConnecting    : sStatus := 'hsConnecting';
    hsConnected     : sStatus := 'hsConnected';
    hsDisconnecting : sStatus := 'hsDisconnecting';
    hsDisconnected  : sStatus := 'hsDisconnected';
    hsStatusText    : sStatus := 'hsStatusText';
    ftpTransfer     : sStatus := 'ftpTransfer';
    ftpReady        : sStatus := 'ftpReady';
    ftpAborted      : sStatus := 'ftpAborted';
    else              sStatus := 'unknown';
  end;
  CodeSite.Send('<CAM> CamServerStatus: '+sStatus+': '+AStatusText);
end;
}

function TCamComm.GetTcpServer2CamNo(AContext: TIdContext): Integer;
var
  nCam, i : Integer;
  sClientIp, sTemp : string;
begin
  sClientIp := AContext.Connection.Socket.Binding.PeerIP;
  // Search CAM Channel
  nCAM := -1;
  for i := DefPocb.CAM_1 to DefPocb.CAM_MAX do begin
    sTemp := DefCam.BASE_TCP_CLINT_IP + Format('%d',[BASE_DPC_IPADDR+i]);
    if sClientIp = sTemp then begin
      nCam := i;
      Break;
    end;
  end;
  Result := nCam;
end;

procedure TCamComm.TcpServerExecute(AContext: TIdContext);
var
  nCam, i : Integer;
  LBuffer : TIdBytes;
  sClientIp, sTemp : string;
begin
  AContext.Connection.IOHandler.ReadTimeout := TIMEVAL_CAM_RESPWAIT;
  AContext.Connection.IOHandler.CheckForDataOnSource(1); // Wait max 1 msec for available data !!! //2021-04
  if not AContext.Connection.IOHandler.InputBufferIsEmpty then begin
    //  TCP-Server RX Message Processing
    AContext.Connection.IOHandler.InputBuffer.ExtractToBytes(LBuffer);
    //
    sClientIp := AContext.Connection.Socket.Binding.PeerIP;
    nCAM := -1;
    for i := DefPocb.CAM_1 to DefPocb.CAM_MAX do begin
      sTemp := DefCam.BASE_TCP_CLINT_IP + Format('%d',[BASE_DPC_IPADDR+i]);
      if sClientIp = sTemp then begin
        nCam := i;
        Break;
      end;
    end;
    if not (nCam in [DefPocb.CAM_1..DefPocb.CAM_MAX]) then Exit;
    //
    ReadSvr(nCAM,Length(LBuffer),LBuffer,AContext);
  end;
end;

//******************************************************************************
// procedure/function:
//    - CheckClientConnect  // from MainPocb
//    - ConnectCam(nCAM: Integer; bConnect: boolean)  // from Mainter
//******************************************************************************

procedure TCamComm.CheckClientConnect(nCam: Integer);
begin
  ThreadTask(procedure var sDebug : string; 
	begin  //----------------
	
  sDebug := '';
  if IdCamClients[nCam].Connected then begin  //2019-01-03
    Exit; //skip connection check if already connected
  end;
  IdCamClients[nCam].ConnectTimeout := DefCam.TIMEVAL_CAM_CONNWAIT;
  try
    IdCamClients[nCam].Connect;
  except
    sDebug := sDebug + Format('Ch%d ',[nCAM + 1]);
  end;
  if IdCamClients[nCam].Connected then begin
    IdCamClients[nCam].Disconnect;
    m_bCamClient[nCam] := True; //before OnCamConnection!!! //2019-01-10
    if Assigned(OnCamConnection) then OnCamConnection(nCam,DefCam.BASE_CLINT_PORT,DefCam.CAM_CONNECT_OK);
  end
  else begin
    m_bCamClient[nCam] := False; //before OnCamConnection!!! //2019-01-10
    if Assigned(OnCamConnection) then OnCamConnection(nCam,DefCam.BASE_CLINT_PORT,DefCam.CAM_CONNECT_NG);
  end;

  if sDebug <> '' then begin
    sDebug := sDebug + 'GPC -> DPC(CameraPC) Communication NG';
    SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCam,0,sDebug); //GUI:SystemNgMsg //2019-01-10 (nCam)
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCam,sDebug,1); //GUI:JigStatus & StopbyAlarm
  end;

  end);  //---------------------------
end;

procedure TCamComm.ConnectCam(nCAM: Integer; bConnect: boolean);
begin
  try
    if bConnect then IdCamClients[nCAM].Connect
    else             IdCamClients[nCAM].Disconnect;
  except
    //TBD?
  end;
end;

//******************************************************************************
// procedure/function: GPC --> DPC
//    - SendCmd(nCAM: Integer; sCommand: string; nWaitTime: Integer = TIMEVAL_CAM_RESPWAIT): boolean;
//    - SendDataByClient(nCAM, nSize: Integer; ABuffer: TIdBytes): Boolean;
//    - ReceiveBufferByClient(nCamCh, nWaitTime: Integer; var ABuffer: TIdBytes): Boolean;
//    - SendDataByServer(nCAM: Integer; sRet : string;const AContext: TIdContext): Boolean
//******************************************************************************

function TCamComm.SendCmd(nCam: Integer; sCommand: string; nWaitTime: Integer = TIMEVAL_CAM_RESPWAIT): boolean;
var
  nCh : Integer;
  sCmd : AnsiString;
  cmmData : CommRec;
  ABuffer, BBuffer : TIdBytes;
  nSizeCheckSum ,i : Integer;
  sDebug, sTemp, sReadData : string;
  slResponse : TArray<string>;
begin
  if not (nCam in [DefPocb.CAM_1..DefPocb.CAM_MAX]) then begin
    Exit(False);
  end;
  nCh := CamNo2ChNo(nCam);
  //
  try
    if (sCommand = 'TSTOP') then begin  //2018-12-12
      if not (m_bCamClient[nCam] and m_bCamServer[nCam]) then begin
      //if nCam = DefPocb.CAM_1 then OnTEndEvt(nCam,camRetCommErr) //TBD:GAGO?
      //else                         OnTEndEvt1(nCam,camRetCommErr);    //TBD:GAGO?
        Exit(False); //2019-02-13
      end;
      if m_bSendTSTOP[nCam] then Exit(False); //2019-02-13
      m_bSendTSTOP[nCam] := True;
    end;

    //------------------------------
    try
      if not IdCamClients[nCAM].Connected then begin
        try
          IdCamClients[nCAM].Connect;
        except
          sDebug := 'Cannot Connect DMURA PC';
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCH,sDebug, DefPocb.LOG_TYPE_NG);
          if nCam = DefPocb.CAM_1 then OnTEndEvt(nCam,camRetStopByAlarm)
          else                         OnTEndEvt1(nCam,camRetStopByAlarm);
          Exit(False);
        end;
      end;
      sDebug := 'Connected DMURA PC';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCH,sDebug);
    except
    end;

    //------------------------------
    m_nBmpDownCnt[nCAM] := 0;

    m_bIsGettingData[nCAM] := False;
    m_bFirstDataRecv[nCAM] := False;

    cmmData.msgSize := SizeOf(cmmData.msgSize) + SizeOf(cmmData.CheckSum) + Length(sCommand) +1;
    sCmd := AnsiString(sCommand)+#$00;
    // input data to buffer.
    SetLength(cmmData.msgData, Length(sCmd));
    CopyMemory(@cmmData.msgData[0],@sCmd[1],Length(sCmd));
    // check sum.
    nSizeCheckSum := ((cmmData.msgSize shr 24) and $ff) + ((cmmData.msgSize shr 16) and $ff) +
                     ((cmmData.msgSize shr 8) and $ff) +  (cmmData.msgSize and $ff);
    cmmData.CheckSum := nSizeCheckSum;
    // copy data to input buffer for send.
    SetLength(ABuffer,cmmData.msgSize);
    CopyMemory(@ABuffer[0],@cmmData.msgSize,8);
    CopyMemory(@ABuffer[8],@cmmData.msgData[0],cmmData.msgSize-8);

    //------------------------------
    sDebug := Format('(GPC ==> DPC) %s',[sCommand]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCH,sDebug);
    //    
    if not SendDataByClient(nCAM,cmmData.msgSize,ABuffer) then begin
      // 1 Write Error.
      if Assigned(OnRevData) then OnRevData(nCAM, cmmData.msgSize,1,'TX NG',ABuffer);
      sDebug := Format('(GPC ==> DPC) %s ...NG(TX)',[sCommand]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCH,sDebug, DefPocb.LOG_TYPE_NG);
      if (sCommand <> 'TSTOP') then begin
      	if nCam = DefPocb.CAM_1 then OnTEndEvt(nCam,camRetCommErr)
      	else                         OnTEndEvt1(nCam,camRetCommErr);
      end;
      Exit(False);
    end;
    //Do NOT insert any code between SendSendDataByClient and ReceiveBufferByClient)!!!
    if not ReceiveBufferByClient(nCAM,nWaitTime,BBuffer) then begin
      // 2 Read Error.
      if Assigned(OnRevData) then OnRevData(nCAM, cmmData.msgSize,2,'RX_ACK NG',BBuffer);
      sDebug := Format('(GPC <== DPC) ...RX_ACK(%s) NG',[sCommand]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCH,sDebug, DefPocb.LOG_TYPE_NG);
			if (sCommand <> 'TSTOP') then begin
        if nCam = DefPocb.CAM_1 then OnTEndEvt(nCam,camRetCommErr)
        else                         OnTEndEvt1(nCam,camRetCommErr);
			end;
      Exit(False);
    end;
    sTemp := '';
    for i := 0 to Length(BBuffer) do begin
      if i < 8 then continue; // 4byte : Length, 4 byte : Checksum Length.
      if BBuffer[i] = 0 then break;
      sTemp := sTemp + chr(BBuffer[i]);
    end;
    sReadData := trim(sTemp);
    if UpperCase(sReadData).Contains('ACK') then begin
      slResponse := sReadData.Split([' ']);
      if (Length(slResponse) >= 2) and (slResponse[1] <> '') then begin
      //CodeSite.Send(Format('CB Dll Ver : [%s]',[slResponse[1]]));
        m_csvCamData[nCam].VerStr := slResponse[1];
      end;
      if (Length(slResponse) >= 3) and (slResponse[2] <> '') then begin
      //CodeSite.Send(Format('CB Dll CRC : [%s]',[slResponse[2]]));
        Common.m_ModelCrc[nCAM].CB_Algorithm := slResponse[2];
      end;
      if (Length(slResponse) >= 4) and (slResponse[3] <> '') then begin
      //CodeSite.Send(Format('CB Param CRC : [%s]',[slResponse[3]]));
        Common.m_ModelCrc[nCAM].Cam_Parameter := slResponse[3];
      end;
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CAM_CRC, nCH, '');
      sDebug := Format('(GPC <== DPC) %s',[sReadData]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCH,sDebug);
      Result := True;
    end
    else begin
      if m_bIsOnCamFlow[nCam] then begin  // 2021-05-10 (ignore if CammFlowDone)
        if Length(sReadData) > 0 then sDebug := Format('(GPC <== DPC) %s ...NG(%s)',[sReadData,sCommand])
        else                          sDebug := Format('(GPC <== DPC) ...TIMEOUT(%s)',[sCommand]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCH,sDebug, DefPocb.LOG_TYPE_NG);
        sTemp := StringReplace(sReadData,'NAK','',[rfReplaceAll]);
        if (sTemp.Length > 2) or (sCommand <> 'TSTOP') then begin  //2019-01-21
          m_sCamNg[nCam] :=  Trim(sTemp);
          if nCam = DefPocb.CAM_1 then OnTEndEvt(nCam,camRetNak)
        	else                         OnTEndEvt1(nCam,camRetNak);
        end;
      end;
      Result := False;
    end;

  finally
    if (IdCamClients[nCam] <> nil) and IdCamClients[nCam].Connected then begin
      IdCamClients[nCam].Disconnect;
      if Assigned(OnCamConnection) then OnCamConnection(nCam,DefCam.BASE_CLINT_PORT,DefCam.CAM_CONNECT_OK);
    end;
  end;
end;

function TCamComm.SendDataByClient(nCam, nSize: Integer; ABuffer: TIdBytes): Boolean;
//var
//nPg, nCh : Integer;
begin
  if not (nCam in [DefPocb.CAM_1..DefPocb.CAM_MAX]) then begin
    Exit(False);
  end;
  //
  if IdCamClients[nCam].Connected then begin
    try
      IdCamClients[nCam].IOHandler.WriteBufferOpen;
      IdCamClients[nCam].IOHandler.WriteBufferFlush;
      IdCamClients[nCam].IOHandler.Write(ABuffer);
      IdCamClients[nCam].IOHandler.WriteBufferClose;
    except
      IdCamClients[nCam].IOHandler.WriteBufferCancel;
    end;
    Result := True;
  end
  else begin
    Result := False;
  end;
end;

function TCamComm.ReceiveBufferByClient(nCam, nWaitTime: Integer; var ABuffer: TIdBytes): Boolean;
var
  bNewConn : Boolean; //2018-12-10
begin
  if not (nCam in [DefPocb.CAM_1..DefPocb.CAM_MAX]) then begin
    Exit(False);
  end;
  bNewConn := False;
  //
  if not IdCamClients[nCam].Connected then begin
    IdCamClients[nCam].Connect;
    bNewConn := True;
  end;

  if IdCamClients[nCam].Connected then begin
    if (bNewConn and Assigned(OnCamConnection)) then OnCamConnection(nCam,DefCam.BASE_CLINT_PORT,DefCam.CAM_CONNECT_OK);
    try
        IdCamClients[nCam].IOHandler.CheckForDataOnSource(nWaitTime);
        IdCamClients[nCam].IOHandler.InputBuffer.ExtractToBytes(ABuffer);
      Result := True;
    except
      Result := False;
    end;
  end
  else begin
    Result := False;
  end;
end;

function TCamComm.SendDataByServer(nCam: Integer; sRet : string;const AContext: TIdContext): Boolean;
var
  ABuffer : TIdBytes;
  nSize, nCheckSum : Integer;
  sCmd : AnsiString;
begin
  if AContext = nil then Exit(False);

  nSize := 8+Length(sRet)+1;
  SetLength(ABuffer,nSize);
  sCmd := AnsiString(sRet)+#$00;
  // check sum.
  nCheckSum         := ((nSize shr 24) and $ff) + ((nSize shr 16) and $ff) +
                   ((nSize shr 8) and $ff) +  (nSize and $ff);

  CopyMemory(@ABuffer[0],@nSize,4);
  CopyMemory(@ABuffer[4],@nCheckSum,4);
  CopyMemory(@ABuffer[8],@sCmd[1],Length(sCmd));
  try
      AContext.Connection.IOHandler.Write(ABuffer,nSize);
      Result := True;
  except
    try
      Sleep(1000);
      AContext.Connection.IOHandler.Write(ABuffer,nSize);
    except
    end;
    Result := False;
  end;
{$IFDEF REF_SDIP}   //TBD:SDIP?
  try
      AContext.Connection.IOHandler.Write(ABuffer,nSize);
      Result := True;
  except
    try
      sDebug := '(GPC ==> DPC) '+sRet + ' : Send Data Failed!';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
      Sleep(1000);
      sDebug := '(GPC ==> DPC) '+sRet + ' : Send Data Retry!';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
      AContext.Connection.IOHandler.Write(ABuffer,nSize);
    except
      sDebug := '(GPC ==> DPC) '+sRet + ' : Send Data Failed!';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
    end;
    Result := False;
  end;
{$ENDIF}
end;

//******************************************************************************
// procedure/function: GPC <--- DPC
//    - InitCamBuf(nCAM : Integer)
//    - ReadSvr(nCAM, nLen: Integer; ABuff: array of Byte; const AContext: TIdContext)
//    - SendPgmaByServer(const AContext: TIdContext; sCmd: string; Abuffer: array of Byte): Boolean   // Called-by ReadSvr
//    - ParseTendMsg(nCAM: Integer; sRevData: string)  // Called-by ReadSvr
//    - saveBmpData(nCh: Integer; const SBuffer: array of Byte)   // Called-by ReadSvr
//    - SaveCBDATAFile(nCh: Integer; const SBuffer: array of Byte)   // Called-by ReadSvr
//******************************************************************************

procedure TCamComm.InitCamBuf(nCam : Integer);
begin
  m_sSerialNo[nCam] := '';
  m_sPanelID[nCam]  := '';

  FillChar(m_csvCamData[nCAM],SizeOf(m_csvCamData[nCam]),0);
end;

procedure TCamComm.ReadSvr(nCam, nLen: Integer; ABuff: TidBytes; const AContext: TIdContext);
var
  nPg, nCh : Integer;
  nDataSize, nSendSize, nCnt : Integer;
  bRet      : boolean;
  sDebug, sCmd, sSigId, sParam, sTemp, sRevData, sTemp2 : string;
  slTemp : TStringList;
  dGetCheckSum : dword;
  i, nPos, nSubPos : Integer;
  nRet : DWORD;
  bRtn : boolean;
  wTemp : Word;
  tBuff,eBuff : array of byte;
  sCmdTemp : string;
  nlExLightExch : TList<Integer>;
	nGray : Integer; //2022-07-15 UNIFORMITY_PUCONOFF
  nPwrOnDelay, nPwrOffDelay : Integer;
  //
  sFlowStep : string;
  nFlowSeq : Integer;
  nAgingLoopCnt : Integer;
begin
  if not (nCam in [DefPocb.CAM_1..DefPocb.CAM_MAX]) then Exit;

  nCh := nCam;
  nPg := nCam;

  if m_bForceStop[nCam] then begin  //2018-12-11
    if m_bSendTSTOP[nCam] then begin
      Exit;
    end;
  //CodeSite.Send('CAM'+IntToStr(nCam)+':ReadSvr: ForceStop');
    sCmdTemp := 'TSTOP';
    if not SendCmd(nCam,sCmdTemp) then begin
    end;
    //nRet := WAIT_OBJECT_0;
    //if nCam = DefPocb.CAM_1 then OnTEndEvt(nCam,1)     //2018-12-12 ???
    //else                         OnTEndEvt1(nCam,1);   //2018-12-12 ???
    Exit;
  end;
  //
  nDataSize := nLen;
  if m_bIsGettingData[nCam] then begin
    if not m_bFirstDataRecv[nCam] then begin  //2018-12-03
    //CodeSite.Send('(DPC ==> GPC) Recv File Data (1st)');
      m_bFirstDataRecv[nCam] := True;
    end;
    Copymemory(@m_nSendData[nCam].Data[m_nLastPos[nCam]],@ABuff[0],Length(ABuff));
    m_nLastPos[nCam] := m_nLastPos[nCam] + Length(ABuff);
    if m_nLastPos[nCam] < m_nSendData[nCam].TotalSize then begin
      //CodeSite.Send(Format('(DPC ==> GPC) Recv File... (%d/%d)', [m_nLastPos[nCam], m_nSendData[nCam].TotalSize]));
      Exit;
    end
    else begin
      m_bIsGettingData[nCam] := False;
      m_bFirstDataRecv[nCam] := False;
      case m_nSendData[nCam].TransMode of
        DefPocb.DOWNDATA_POCB_CBDATA : begin
          nFlowSeq := TernaryOp((CameraComm.m_nCurCBIdx[nCam] = DefCam.CAM_STEP_CB1), DefPocb.POCB_SEQ_CB1_CBDATA_RCV, DefPocb.POCB_SEQ_CB2_CBDATA_RCV);
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,nCam,'', nFlowSeq, DefPocb.SEQ_RESULT_PASS);
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCam,'CBDATA Recv Done');
          SaveCBDATAFile(nCam,m_nSendData[nCam].Data);
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCam,'CBDATA File Save OK');
          SendDataByServer(nCh,'ACK',AContext);
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCam,'(GPC ==> DPC) ACK');
          if nCam = DefPocb.CAM_1 then OnTEndEvt(nCam,camRetOk)
          else                         OnTEndEvt1(nCam,camRetOk);
        end;
        DefPocb.DOWNDATA_POCB_COMPBMP : begin
          SaveBmpData(nCam,m_nSendData[nCam].Data);
          BmpDownload(nCam,AContext);
        end;
      end;
      Exit;
    end;
  end;

  sDebug := '';  sRevData := '';
  if nDataSize > 8 then begin
    for i := 8 to Pred(nDataSize) do begin
      if i > 1024 then begin

        break;
      end;
      if ABuff[i] = 0 then Break;
      sRevData := sRevData + Char(ABuff[i]);
      sDebug := sDebug + Char(ABuff[i]);
    end;
  end;
  sCmd := trim(sDebug);
  nPos := Pos(' ',sCmd);
  if nPos > 0 then begin
    sSigId := Trim(Copy(sCmd,1,nPos-1)); // 0
    sTemp := Trim(Copy(sCmd,nPos+1,Length(sCmd)-nPos));// 1
    nSubPos := Pos(' ',sTemp);
    if nSubPos > 0 then begin
      sParam := Trim(Copy(sTemp,1,nSubPos-1));// 2
    end
    else begin
      sParam := sTemp; //1
    end;
  end
  else begin
    sSigId := Trim(sCmd);
  end;
  if sSigid <> 'ALIVECHECK' then begin  //2018-12-18 (TCP Connection Alive Check)
    sDebug := '(GPC <== DPC) '+sCmd;
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
  end;

  if sSigid = 'ALIVECHECK' then begin   //2018-12-18 (TCP Connection Alive Check)
    nRet := WAIT_OBJECT_0;
    SendDataByServer(nCh,'ACK',AContext); 
    Exit;
  end
  else if sSigId = 'PGON' then begin
    nRet := Pg[nPg].SendPgPowerOn(1);
    nPwrOnDelay := Common.TestModelInfo2[nCh].PwrOnDelayMSec;
    if nPwrOnDelay > 0 then begin
      sDebug := Format('Delay %d ms',[nPwrOnDelay]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
      Sleep(nPwrOnDelay);
    end;
  end
  else if sSigid = 'PGOFF' then begin
    nRet := Pg[nPg].SendPgPowerOn(0);
    nPwrOffDelay := Common.TestModelInfo2[nCh].PwrOffDelayMSec;
    if nPwrOffDelay > 0 then begin
      sDebug := Format('Delay %d ms',[nPwrOffDelay]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
      Sleep(nPwrOffDelay);
    end;
  end
  else if sSigid = 'PTNON' then begin
    nRet := Pg[nPg].SendPgDisplayPatNum(StrToIntDef(sParam,0));
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_PATTERN,nCh,'',StrToIntDef(sParam,0));
  end
  else if sSigid = 'PTNGRAY' then begin //2022-07-15 UNIFORMITY_PUCONOFF
		nGray := StrToIntDef(sParam,255);
    sTemp := Format('GRAY%d',[nGray]);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_PATTERN,nCh,sTemp,0);
    nRet := Pg[nCh].SendPgSetColorRGB(nGray,nGray,nGray);
  end
  else if (sSigid = 'PUCON') or (sSigid = 'POCBON') then begin //2022-07-15 UNIFORMITY_PUCONOFF //2023-05-22 AUTO(PUCON) FOLDABLE(POCBON)
    bRtn := Logic[nCh].PucCtrlPocbOnOff(True{bOn});
    nRet := TernaryOp(bRtn, WAIT_OBJECT_0, WAIT_FAILED);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_PATTERN,nCh,'PUC-ON',0);
  end
  else if (sSigid = 'PUCOFF') or (sSigid = 'POCBOFF') then begin //2022-07-15 UNIFORMITY_PUCONOFF //2023-05-22 AUTO(PUCOFF) FOLDABLE(POCBOFF)
    bRtn := Logic[nCh].PucCtrlPocbOnOff(False{bOn});
    nRet := TernaryOp(bRtn, WAIT_OBJECT_0, WAIT_FAILED);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_PATTERN,nCh,'PUC-OFF',0);
  end
  else if sSigid = 'TEND' then begin
    nRet := WAIT_OBJECT_0;
  end
  else if sSigid = 'GRRTEND' then begin
    nRet := WAIT_OBJECT_0;
  end
//else if sSigId = 'PGMA_RD' then begin  //DELETE(NOT_USED)
//end
  else if (sSigId = 'PGMA_RD') or (sSigId = 'PGMA_RD_BAND') then begin
    SetLength(tBuff,8192);  //TBD:GAGO? //TBD:AUTO?
    ClearDataBuf(tBuff,8192);  //FillChar(tBuff,8192,0);
    {$IF Defined(PANEL_AUTO)}
    bRtn := Logic[nCh].EepromGammaDataRead({var}nSendSize,{var}tBuff);
    {$ELSEIF Defined(PANEL_GAGO)}
    bRtn := Logic[nCh].FlashGammaDataRead({var}nSendSize,{var}tBuff);
    {$ELSE}
    bRtn := False;
    {$ENDIF}
    if not bRtn then begin
      SendDataByServer(nCh,'NAK',AContext);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,'(GPC ==> DPC) NAK', DefPocb.LOG_TYPE_NG);
      Exit;
    end
    else begin
      SetLength(eBuff,nSendSize);
      CopyMemory(@eBuff[0], @tBuff[0], nSendSize);
      sTemp := Format('ACK %d',[nSendSize]);
      SendPgmaByServer(nCam,AContext,sTemp,eBuff);
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,'(GPC ==> DPC) '+ sTemp);
    end;
    Exit;
  end
  else if sSigid = 'BMPON' then begin
    Pg[nPg].SetPowerMeasureTimer(False);  //2022-02-17 -> SetCyclicTimerPg(False);
    sCmd := '';
    for i := 8 to Pred(nDataSize) do begin
      if ABuff[i] = 0 then begin
        nPos := i+1;
        break;
      end;
      sCmd := sCmd + Char(ABuff[i]);
    end;
    slTemp := TStringList.Create;
    try
      ExtractStrings([' '],[],PChar(sCmd), slTemp);
      if slTemp.Count < 2 then  nRet := WAIT_FAILED
      else begin
        sSigid := slTemp[0];
        sTemp := slTemp[1];   // Data Size.

        m_nSendData[nCam].TransMode := DefPocb.DOWNDATA_POCB_COMPBMP;
        m_nSendData[nCam].TransType := DefPG.PGSIG_BMPDOWN_TYPE_COMPBMP;
        m_nSendData[nCam].TotalSize := StrToIntDef(sTemp,0);
        m_nSendData[nCam].filePath  := Common.Path.RootSW;
		  //if DP489 then m_nSendData[nCam].fileName  := DefPG.BMP_DOWN_NAME else //TBD:MERGE? A2CHv3+A2CHv4?
        m_nSendData[nCam].fileName  := DefPocb.COMPBMP_DOWN_NAME + Format('%d',[m_nBmpDownCnt[nCAM]]) + '.raw'; //2021-11-29 (Add m_nBmpDownCnt[nCAM]#)
        SetLength(m_nSendData[nCam].Data,m_nSendData[nCam].TotalSize);
        Copymemory(@m_nSendData[nCam].Data[0],@ABuff[nPos],Length(ABuff)-nPos);
        m_nLastPos[nCam] := Length(ABuff)-nPos;
        m_bIsGettingData[nCam] := True;
        m_bFirstDataRecv[nCam] := False;
        exit;

      end;
      sDebug := FormatDateTime('[HH:MM:SS]',now) + 'After send command';
    finally
      slTemp.Free;
    //slTemp := nil;
    end;
  end

  else if (sSigid = 'POCBWRT') or (sSigid = 'POCBWRT_LUT') then begin
    // CBDATA from DPC
    nFlowSeq := TernaryOp((CameraComm.m_nCurCBIdx[nCam] = DefCam.CAM_STEP_CB1), DefPocb.POCB_SEQ_CB1_CBDATA_RCV, DefPocb.POCB_SEQ_CB2_CBDATA_RCV);
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,nCam,'', nFlowSeq, DefPocb.SEQ_RESULT_WORKING);
    Pg[nPg].SetPowerMeasureTimer(False);
    sCmd := '';
    for i := 8 to Pred(nDataSize) do begin
      if ABuff[i] = 0 then begin
        nPos := i+1;
        break;
      end;
      sCmd := sCmd + Char(ABuff[i]);
    end;
    slTemp := TStringList.Create;	
    try
      ExtractStrings([' '],[],PChar(sCmd), slTemp);
      if slTemp.Count < 2 then  nRet := WAIT_FAILED
      else begin
        sSigid := slTemp[0];
        sParam := slTemp[1];  // Register Address
        sTemp  := slTemp[2];  // Data Size

        m_nSendData[nCam].TransMode := DefPocb.DOWNDATA_POCB_CBDATA;
        m_nSendData[nCam].TransType := DefPG.PGSPI_DOWNLOAD_FLASH_CBDATA;
        m_nSendData[nCam].TotalSize := StrToIntDef(sTemp,0);
        m_nSendData[nCam].filePath  := Common.Path.RootSW;
        m_nSendData[nCam].fileName  := Format('POCBWRT%d.img',[nPg]);
        SetLength(m_nSendData[nCam].Data,m_nSendData[nCam].TotalSize);
        Copymemory(@m_nSendData[nCam].Data[0],@ABuff[nPos],Length(ABuff)-nPos);
        m_nLastPos[nCam] := Length(ABuff)-nPos;
        m_bIsGettingData[nCam] := True;
        m_bFirstDataRecv[nCam] := False;
        Exit;
      end;
      sDebug := FormatDateTime('[HH:MM:SS]',now) + 'After send command';
    finally
      slTemp.Free;
    //slTemp := nil;
    end;
  end
	
  else if sSigId = 'EXLIGHTCH' then begin
		// EXLIGHTCH <ExCh#> <Level#>
		// 		e.g., EXLIGHTCH 1 100
    sCmd := '';
    nRet := WAIT_FAILED;
    for i := 8 to Pred(nDataSize) do begin
      if ABuff[i] = 0 then begin
        nPos := i+1;
        break;
      end;
      sCmd := sCmd + Char(ABuff[i]);
    end;
    slTemp := TStringList.Create;
    try
      ExtractStrings([' '],[],PChar(sCmd), slTemp);
      if slTemp.Count < 3 then  nRet := WAIT_FAILED
      else begin
        sSigid := slTemp[0];
        sParam := slTemp[1];   // ExCh#(1~3)
        sTemp  := slTemp[2];   // Level(0~255)
        {$IF Defined(POCB_A2CH) or Defined(POCB_F2CH) or Defined(POCB_A2CHv2) or Defined(POCB_A2CHv3)} //A2CH(ExCh1~ExCh3),A2CHv2|A2CHv3(ExCh1~ExCh2)
        if DongaExLight.SendExLightChCtrl(nCam,StrToInt(sParam){ExCh#},StrToInt(sTemp){Level#}) then begin
          nRet := WAIT_OBJECT_0; //OK
        end;
        {$ELSEIF Defined(POCB_A2CHv4)} //A2CHv4(ExCh1+ExCh2, ExCh3+ExCh4)
        if (sParam  = '1') then begin
          if DongaExLight.SendExLightChCtrl(nCam,1,StrToInt(sTemp){Level#}) and DongaExLight.SendExLightChCtrl(nCam,2,StrToInt(sTemp){Level#}) then begin
            nRet := WAIT_OBJECT_0; //OK
          end;
        end
        else begin //'2'
          if DongaExLight.SendExLightChCtrl(nCam,3,StrToInt(sTemp){Level#}) and DongaExLight.SendExLightChCtrl(nCam,4,StrToInt(sTemp){Level#}) then begin
            nRet := WAIT_OBJECT_0; //OK
          end;
        end;
        {$ELSEIF Defined(POCB_ATO) or Defined(POCB_GAGO)}
        if (sParam  = '1') then begin
          if DongaExLight.SendExLightChCtrl(nCam,1,StrToInt(sTemp){Level#}) then begin
            nRet := WAIT_OBJECT_0; //OK
          end;
        end
        else if (sParam  = '2') then begin
          if DongaExLight.SendExLightChCtrl(nCam,2,StrToInt(sTemp){Level#}) and DongaExLight.SendExLightChCtrl(nCam,3,StrToInt(sTemp){Level#}) then begin
            nRet := WAIT_OBJECT_0; //OK
          end;
        end
        else if (sParam  = '3') then begin
          if DongaExLight.SendExLightChCtrl(nCam,4,StrToInt(sTemp){Level#}) then begin
            nRet := WAIT_OBJECT_0; //OK
          end;
        end
        else begin //'4'
          if DongaExLight.SendExLightChCtrl(nCam,5,StrToInt(sTemp){Level#}) and DongaExLight.SendExLightChCtrl(nCam,6,StrToInt(sTemp){Level#}) then begin
            nRet := WAIT_OBJECT_0; //OK
          end;
        end;
        {$ELSE}
        if DongaExLight.SendExLightChCtrl(nCam,StrToInt(sParam){ExCh#},StrToInt(sTemp){Level#}) then begin
          nRet := WAIT_OBJECT_0; //OK
        end;
        {$ENDIF}
      end;
    finally
      slTemp.Free;
    //slTemp := nil;
    end;
  end
  else if sSigid = 'EXLIGHTALL' then begin //2019-04-17 ExLight
		// EXLIGHTALL <ExCh1Level#> <ExCh2Level#> <ExCh1Leve3#>
		// 		e.g., EXLIGHTALL 100 100 100
    nRet := WAIT_FAILED;
    sCmd := '';
    for i := 8 to Pred(nDataSize) do begin
      if ABuff[i] = 0 then begin
        nPos := i+1;
        break;
      end;
      sCmd := sCmd + Char(ABuff[i]);
    end;
    slTemp        := TStringList.Create;
    nlExLightExch := TList<Integer>.Create;
    try
      ExtractStrings([' '],[],PChar(sCmd), slTemp);
      if slTemp.Count < 2 then  nRet := WAIT_FAILED
      else begin
        sSigid := slTemp[0];

        nlExLightExch.Clear;
        for i := 1 to Pred(slTemp.Count) do begin
          {$IF Defined(POCB_A2CH) or Defined(POCB_F2CH) or Defined(POCB_A2CHv2) or Defined(POCB_A2CHv3)} //A2CH(ExCh1~ExCh3),A2CHv2|A2CHv3(ExCh1~ExCh2)
          nlExLightExch.Add(StrToInt(slTemp[i]));
          {$ELSEIF Defined(POCB_A2CHv4)} //A2CHv4(ExCh1+ExCh2, ExCh3+ExCh4)
          if      (i = 1) then begin nlExLightExch.Add(StrToInt(slTemp[1])); nlExLightExch.Add(StrToInt(slTemp[1])); end
          else if (i = 2) then begin nlExLightExch.Add(StrToInt(slTemp[2])); nlExLightExch.Add(StrToInt(slTemp[2])); end
          {$ELSEIF Defined(POCB_ATO) or Defined(POCB_GAGO)} //ATO|GAGO (ExCh1, ExCh2+ExCh3, ExCh4, ExCh5+ExCh6)
          if      (i = 1) then begin nlExLightExch.Add(StrToInt(slTemp[1])); end
          else if (i = 2) then begin nlExLightExch.Add(StrToInt(slTemp[2])); nlExLightExch.Add(StrToInt(slTemp[2])); end
          else if (i = 3) then begin nlExLightExch.Add(StrToInt(slTemp[3])); end
          else if (i = 4) then begin nlExLightExch.Add(StrToInt(slTemp[4])); nlExLightExch.Add(StrToInt(slTemp[4])); end;
          {$ELSE}
          nlExLightExch.Add(StrToInt(slTemp[i]));
          {$ENDIF}
        end;
        if DongaExLight.SendExLightAllCtrl(nCam, nlExLightExch) then begin
          if UserUtils.GetItemCount(nlExLightExch, 0) = nlExLightExch.Count then begin
            {$IFDEF EXLIGHT_ON_DISPLAY_OFF}
            nRet := Pg[nPg].SendPgDisplayOnOff(True{bOn}); //On
						{$ELSE}
            nRet := Pg[nPg].SendPgPowerOn(1); //Power-On
            if nRet = WAIT_OBJECT_0 then begin
              nPwrOnDelay := Common.TestModelInfo2[nCh].PwrOnDelayMsec;
              if nPwrOnDelay > 0 then begin
                sDebug := Format('Delay %d ms',[nPwrOnDelay]);
                SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
                Sleep(nPwrOnDelay);
              end;
            end;
            {$ENDIF}
            //
            {$IF Defined(POCB_FOLD) or Defined(POCB_GAGO)}
            if nRet = WAIT_OBJECT_0 then begin
              // CBPARA Write (EEPROM or FLASH) for POCB Start //2022-08-02
              if not Logic[nCh].EepromDataWrite(eepromCBParam,True{bBefore}) then begin
                nRet := WAIT_FAILED;
                sDebug := 'CBPARA-Before Write NG';
                Logic[nCh].SetMesResultInfo(19, sDebug, 'Fail', 'PD19', sDebug, DefGmes.POCB_MESCODE_PD19_SUMMARY, DefGmes.POCB_MESCODE_PD19_RWK);
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,nCh,sDebug,DefPocb.SEQ_RESULT_FAIL);  // NG
              end;
            end;
            {$ENDIF}
            //
            if nRet = WAIT_OBJECT_0 then begin
              Sleep(500); //TBD?
              nRet := Pg[nPg].SendPgDisplayPatNum(Common.TestModelInfo2[nCh].PowerOnPatNum); //2021-11-24 POWER_ON_PATTERN
              SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_PATTERN,nCh,'',Common.TestModelInfo2[nCh].PowerOnPatNum);
            //sDebug := Format(' Pattern Display %d',[Common.TestModelInfo2[nCh].PowerOnPatNum]);
            //SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
            end;
            // Aging						
            {$IF Defined(POCB_FOLD) or Defined(POCB_GAGO)}
            if Common.TestModelInfo2[nCh].UseExLightFlow and (Common.TestModelInfo2[nCh].PowerOnAgingSec > 0) then begin  //2022-08-24 (EXLIGHT_FLOW)
              Logic[nCh].SetPowerOnAgingTimer(Common.TestModelInfo2[nCh].PowerOnAgingSec);
              Common.ThreadTask(procedure begin
                // Aging
                nAgingLoopCnt := Common.TestModelInfo2[nCh].PowerOnAgingSec * 5; //*5 (200ms->1sec)
                while (Logic[nCh].m_Inspect.PowerOnAgingRemainSec > 0) and (nAgingLoopCnt > 0) do begin
                  if (Logic[nCh].m_InsStatus <> IsCamera) or (Logic[nCh].m_nStopReason = StopByOperator) or (Logic[nCh].m_nStopReason = StopByAlarm) then Exit;
                  if ((nAgingLoopCnt mod 5) = 0) then begin
                    sTemp := Format('Aging (%d)',[Logic[nCh].m_Inspect.PowerOnAgingRemainSec]);
                    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,nCh,sTemp,0);
                  end;
                  Sleep(200);
                  Dec(nAgingLoopCnt);
                end;
                SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CH_STATUS,nCh,'Camera Process',0);
                // send(ACK)
                SendDataByServer(nCh,'ACK',AContext);
                sDebug := '(GPC ==> DPC) ACK';
                SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
  						end);
              Exit; //TBD? (ACK after Aging Time)
            end;
            {$ENDIF}
          end
          else begin  //ExLight Any ExCh On
            {$IFDEF EXLIGHT_ON_DISPLAY_OFF}
            nRet := Pg[nPg].SendPgDisplayOnOff(False{bOn}); //Off  //2021-11-25 SendPgPowerOn(0) --> SendPgDisplayOnOff(False{bOn})
						{$ELSE}
            nRet := Pg[nPg].SendPgPowerOn(0); //Power-Off
            {$ENDIF}
          end;
        end
        else begin
          sDebug := Format('<EXLIGHT> Cannot turn %s ExLight',[TernaryOp(Sum(nlExLightExch)>0,'On','Off')]);
          SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug, DefPocb.LOG_TYPE_NG);
        end;
      end;
    finally
      slTemp.Free;
      nlExLightExch.Free;
    //slTemp := nil;
    end;
  end
  else begin
  //SendDataByServer(nCh,'NAK',AContext);
    sDebug := '(GPC ==> DPC) '+ sSigid + '...ignore(Unknown)';
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug{, DefPocb.LOG_TYPE_NG});
    Exit;
  end;

  if nRet <> WAIT_OBJECT_0 then begin
    SendDataByServer(nCh,'NAK',AContext);
    sDebug := '(GPC ==> DPC) NAK';
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug, DefPocb.LOG_TYPE_NG);
    if sSigid.Contains('TEND') then begin
      nRet := WAIT_OBJECT_0;
      ParseTendMsg(nCam,sRevData);
      if Common.TestModelInfo2[nCam].JudgeCount > 0 then ParseUniformityMsg(nCam,sRevData);
    end;
  end
  else begin
    SendDataByServer(nCh,'ACK',AContext);
    sDebug := '(GPC ==> DPC) ACK';
    if (sSigid <> 'ALIVECHECK') then SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
    if sSigid.Contains('TEND') then begin
      ParseTendMsg(nCam,sRevData);
      if Common.TestModelInfo2[nCam].JudgeCount > 0 then ParseUniformityMsg(nCam,sRevData);
    end;
  end;
end;

function TCamComm.SendPgmaByServer(nCam: Integer; const AContext: TIdContext;sCmd : string; Abuffer: array of Byte): Boolean;
var
//nPg, nCh : Integer;
  CBuffer : TIdBytes;
  nSize, nCheckSum, i , nLen : Integer;
  sParam : AnsiString;
  sDebug, sTemp : string;
begin
  nSize := 8+Length(sCmd)+1 + Length(Abuffer);
  SetLength(CBuffer,nSize);
  sParam := AnsiString(sCmd)+#$00;
  // check sum.
  nCheckSum     := ((nSize shr 24) and $ff) + ((nSize shr 16) and $ff) +
                   ((nSize shr 8) and $ff) +  (nSize and $ff);

  CopyMemory(@CBuffer[0],@nSize,4);
  CopyMemory(@CBuffer[4],@nCheckSum,4);
  CopyMemory(@CBuffer[8],@sParam[1],Length(sCmd)+1);
  CopyMemory(@CBuffer[9+Length(sCmd)],@Abuffer[0],Length(Abuffer));

  nLen := Length(ABuffer);
  sTemp := '';
  for i := 0 to Pred(nLen) do sTemp := sTemp + Format('%0.2x ',[Abuffer[i]]);
  sDebug := '(GPC ==> DPC) Send Pgma Data : ' + sTemp;
  try
      AContext.Connection.IOHandler.Write(CBuffer,nSize);
  except
    try
      Sleep(1000);
      AContext.Connection.IOHandler.Write(CBuffer,nSize);
    except
    end;
  end;
  Result := True;   //2019-02-13
end;

procedure TCamComm.ParseTendMsg(nCam: Integer; sRevData: string);
var
  nCh : Integer;
  i, nNgCnt, nCamNgCode : Integer;
  sRet : string;
  slstData : TStringList;
  sNgMsg, sDebug, sCamAlarmMsg : string;
  bRet : Boolean;
begin
  nCh := CamNo2ChNo(nCam);
  //
  slstData:= TStringList.create;
  try
    ExtractStrings([' '],[],PChar(sRevData), slstData);
		sNgMsg := '';
    nNgCnt := StrToIntDef(slstData[2],0);
    if (nNgCnt = 0) then begin
      if (Common.TestModelInfo2[nCh].JudgeCount > 0) then begin //2023-04-10 Uniformity(ReversedBMP|PucOnOff)
        // 0    1  2 3 4  5
        // TEND NG 0 Y 20 Fail to find result hex file.
        // TEND NG 0 Y 61 Error Darkness
        // TEND NG 0 N 50 Timeout - Write Pocb result file
        // TEND NG 0 N 94 Left Top Dot is not Found
        if (slstData.Count >= 5) and
          ((UpperCase(slstData[3]) = 'Y') or (UpperCase(slstData[3]) = 'N')) then begin  //20190-04-17 CamAlarm
          for i := 4 to pred(slstData.Count) do begin //2019-04-18 CAM:ALARM // e.g., 'TEND NG 0 Y 10 xxxxxxxxx'
            sNgMsg := sNgMsg + ' ' + slstData[i];
          end;
          nCamNgCode := StrToIntDef(slstData[4],0);
        //CodeSite.Send('nCamNgCode('+IntToStr(nCamNgCode)+')');
          if (slstData[1] <> 'OK') and (UpperCase(slstData[3]) = 'Y') then begin
            sCamAlarmMsg  := Common.m_Dpc2GpcNgCodes[nCamNgCode].DefectName;
            sCamAlarmMsg  := sCamAlarmMsg + #13 + #10 + '       - ' + Common.m_Dpc2GpcNgCodes[nCamNgCode].CamAlarmSuppMsg;
            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCam,0,sCamAlarmMsg); //GUI:SystemNgMsg
          end;
        end
        else begin
          for i := 3 to pred(slstData.Count) do begin // e.g., 'TEND NG 0 10 xxxxxxxxx'
            sNgMsg := sNgMsg + ' ' + slstData[i];
          end;
          if sNgMsg = '' then sNgMsg := 'No UNIFORMITY values'; //2023-09-25
        end;
        m_sCamNg[nCam] := Trim(sNgMsg);
        if nCam = DefPocb.CAM_1 then OnTEndEvt(nCam,camRetTEndNg)
        else                         OnTEndEvt1(nCam,camRetTEndNg);
      end
      else begin //2023-04-10 UsePucImage
        // 0    1  2 3 4  5
        // TEND OK 0
        sRet := slstData[1];
        if sRet <> 'OK' then begin
	        if (slstData.Count >= 5) and
	          ((UpperCase(slstData[3]) = 'Y') or (UpperCase(slstData[3]) = 'N')) then begin  //20190-04-17 CamAlarm
	          for i := 4 to pred(slstData.Count) do begin //2019-04-18 CAM:ALARM // e.g., 'TEND NG 0 Y 10 xxxxxxxxx'
	            sNgMsg := sNgMsg + ' ' + slstData[i];
	          end;
  	        nCamNgCode := StrToIntDef(slstData[4],0);
	          if (slstData[1] <> 'OK') and (UpperCase(slstData[3]) = 'Y') then begin
	            sCamAlarmMsg  := Common.m_Dpc2GpcNgCodes[nCamNgCode].DefectName;
	            sCamAlarmMsg  := sCamAlarmMsg + #13 + #10 + '       - ' + Common.m_Dpc2GpcNgCodes[nCamNgCode].CamAlarmSuppMsg;
	            SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_ALARM,nCam,0,sCamAlarmMsg);
	          end;
	        end
					else begin
	          for i := 3 to pred(slstData.Count) do begin // e.g., 'TEND NG 0 10 xxxxxxxxx'
	            sNgMsg := sNgMsg + ' ' + slstData[i];
	          end;
					end;
          m_sCamNg[nCam] := Trim(sNgMsg); //2023-11-26
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,nCh,Trim(sNgMsg), DefPocb.SEQ_RESULT_FAIL);
          if nCam = 0 then OnTEndEvt(nCAM,camRetTEndNg)
          else             OnTEndEvt1(nCAM,camRetTEndNg);
        end
        else begin
          if Common.TestModelInfo2[nCh].UsePucImage then sNgMsg := 'Compensation/ImageSave OK'
          else                                           sNgMsg := 'Compensation OK';
        //if Common.SystemInfo.UseGIB and Common.TestModelInfo2[nCh].EnableFlashWriteCBData then
        //  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,nCh,sNgMsg, DefPocb.SEQ_RESULT_PASS) // INFO //2021-05
        //else
            SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,nCh,sNgMsg, DefPocb.SEQ_RESULT_PASS); // OK
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,nCh,'',DefPocb.POCB_SEQ_CAM_PROC_EXTRA,DefPocb.SEQ_RESULT_PASS);
          if nCam = 0 then OnTEndEvt(nCam,camRetOk)
          else             OnTEndEvt1(nCam,camRetOk);
        end;
      end;
    end
    else begin
      // 0    1  2 3      4      5       6       7
      // TEND OK 2 89.88 87.88 89.88 87.88
      // TEND OK 1 91.407 91.337 507.344 504.424 495.085 495.376 489.837 503.840 515.228 521.069 511.432 499.752 492.461 491.878 487.505 501.212 521.069 533.333 527.785 518.732 0.000 0.000 0.000 499.168 500.336 492.752 487.796 484.881 498.292 509.096 512.308 503.548 498.876 491.586 484.881 483.131 495.959 514.644 528.953 523.113 510.556 0.000 0.000 0.000
      // GRRTEND OK 2 89.88 87.88
      // TEND OK 2 89.88 87.88 89.88 87.88
      m_csvCamData[nCam].IsGRR := UserUtils.TernaryOp('GRRTEND' = slstData[0], True, False);
      sRet := slstData[1];
      if sRet <> 'OK' then begin
        sNgMsg := 'UNIFORMITY NG';
        SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,nCh,Trim(sNgMsg), DefPocb.SEQ_RESULT_FAIL); // 1 : NG.
        m_sCamNg[nCam] :=  'UNIFORMITY NG';
        if nCam = 0 then OnTEndEvt(nCAM,camRetUnitformityNG)
        else             OnTEndEvt1(nCAM,camRetUnitformityNG);
      end
      else begin
        bRet := True;
        for i := 0 to DefPocb.UNIFORMITY_PATTERN_MAX do begin
          if (Common.TestModelInfo2[nCam].JudgeCount > i) and (nNgCnt > i) then begin
            if not m_csvCamData[nCam].IsGRR then begin
              m_csvCamData[nCam].UniformityPost[i] := StrToFloatDef(slstData[3+(i*2)],0.0);
              m_csvCamData[nCam].UniformityPre[i]  := StrToFloatDef(slstData[4+(i*2)],0.0);
            end
            else begin
              m_csvCamData[nCam].UniformityPost[i] := StrToFloatDef(slstData[3+i],0.0);
            end;

            if (m_csvCamData[nCam].UniformityPost[i] < Common.TestModelInfo2[nCam].WhiteUniform[i])
               and (m_csvCamData[nCam].UniformityPost[i] >= 0) //2023-06-21
            then begin m_csvCamData[nCam].UniformityResult[i] := 'NG'; bRet := False; end
            else begin m_csvCamData[nCam].UniformityResult[i] := 'OK'; end;

            sDebug := Format('ModelInfo.Uniformity%d(%.3f): ',[i+1,Common.TestModelInfo2[nCam].WhiteUniform[i]]);
            if m_csvCamData[nCam].UniformityPost[i] >= 0 then
              sDebug := sDebug + Format('Uniformity%d(%.3f)',[i+1,m_csvCamData[nCam].UniformityPost[i]])
            else
              sDebug := sDebug + Format('Uniformity%d(-1)',[i+1]);
            if not m_csvCamData[nCam].IsGRR then begin
              if m_csvCamData[nCam].UniformityPre[i] >= 0 then
                sDebug := sDebug + Format(', PreUniformity%d(%.3f)', [i+1,m_csvCamData[nCam].UniformityPre[i]])
              else
                sDebug := sDebug + Format(', PreUniformity%d(-1)', [i+1]);
            end;
            sDebug := sDebug + ' ' + m_csvCamData[nCam].UniformityResult[i];
            SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug, TernaryOp(bRet,DefPocb.LOG_TYPE_INFO,DefPocb.LOG_TYPE_NG));
          end;
        end;
        //
        if bRet then begin
          sNgMsg := 'UNIFORMITY OK';
        //if Common.SystemInfo.UseGIB and Common.TestModelInfo2[nCh].EnableFlashWriteCBData then
        //  SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,nCh,sNgMsg,DefPocb.SEQ_RESULT_PASS)
        //else
            SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,nCh,sNgMsg,DefPocb.SEQ_RESULT_PASS);
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,nCh,'',DefPocb.POCB_SEQ_CAM_PROC_EXTRA,DefPocb.SEQ_RESULT_PASS);
          if nCam = 0 then OnTEndEvt(nCam,camRetOk)
          else             OnTEndEvt1(nCam,camRetOk);
        end
        else begin
          sNgMsg := 'UNIFORMITY NG';
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,nCh,sNgMsg,DefPocb.SEQ_RESULT_FAIL);
          SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_FLOW_SEQ,nCh,'',DefPocb.POCB_SEQ_CAM_PROC_EXTRA,DefPocb.SEQ_RESULT_FAIL);
          m_sCamNg[nCam] := 'UNIFORMITY NG';
          if nCam = 0 then OnTEndEvt(nCam,camRetUnitformityNG)
          else             OnTEndEvt1(nCam,camRetUnitformityNG);
        end;
      end;
    end;

  finally
    slstData.Free;
  //slstData := nil;
  end;
end;

function TCamComm.ParseUniformityMsg(nCam: Integer; sRevData: string) : Boolean;
var
  sArrData : TArray<string>;
  nJudgeCnt : Integer;
  nIdx, nPos, nRCount : Integer;
  sBefore, sAfter : string;
  sNgMsg : string;
begin
  if not Common.SystemInfo.UseUniformityPoint then Exit(True);

  sArrData := sRevData.Split([' ']);

  //Delimiter : Space
  // GRRTEND OK JudgeCount (After)*JudgeCount (AfterPoint*21)*JudgeCount
  // GRRTEND OK 2 86.5 87.5 76.5 74.6....
  // TEND OK JudgeCount (After Before)*JudgeCount ((AfterPoint*21) (BeforePoint*21))* JudgeCount

  if Length(sArrData) > 2 then begin
    nJudgeCnt := StrToInt(sArrData[2]);
    nRCount   := UserUtils.TernaryOp(UpperCase(sArrData[0])='GRRTEND', 1, 2);
    nIdx      := nRCount * nJudgeCnt + 3{SigId + OK + JudgeCnt};

    if Length(sArrData) <= nIdx then Exit(True);

    m_csvCamData[nCam].HasUniformityPoint := True;

    sArrData  := Copy(sArrData, nIdx, Length(sArrData) - nIdx); // Values
    nPos      := 0;

    if Length(sArrData) >= (nJudgeCnt * DefPocb.UNIFORMITY_POINT_COUNT * nRCount{Before/After}) then begin
      for nIdx := 0 to Pred(nJudgeCnt) do begin
        m_csvCamData[nCam].UniformityPointsPost[nIdx] := UserUtils.ToString(Copy(sArrData, UserUtils.IncNum(nPos,21), 21),',');
        if nRCount = 2 then {TEND}
          m_csvCamData[nCam].UniformityPointsPre[nIdx] := UserUtils.ToString(Copy(sArrData, UserUtils.IncNum(nPos,21), 21),',');
      end;
      Result := True;
    end else begin
      sNgMsg := Format('Uniformity Data Lenth NG : %d/%d',[Length(sArrData),(nJudgeCnt * DefPocb.UNIFORMITY_POINT_COUNT * nRCount)]);
      SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_RESULT,nCam,sNgMsg,DefPocb.SEQ_RESULT_FAIL);
      Result := False;
    end;
  end
  else
    Result := False;
end;

procedure TCamComm.SaveBmpData(nCam: Integer; const SBuffer: array of Byte);
var
  nCh : Integer;
  fi : TFileStream;
  sTempFileName, sTempFullName : string;
  sFilePath, sBmpFileName, sBmpFullName, sShareFullName, sDebug : string;
  bIsOK : Boolean;
  nowDateTime : TDateTime;
begin
  //Common.MLog(nCam,'<CameraCtl> SaveBmpData: nCam('+IntToStr(nCam)+')');
  nCh := nCam;
  //
  Common.CheckMakeDir(Common.Path.CompBMP);
  if m_nBmpDownCnt[nCAM] = 0 then begin
    sTempFileName := Format('CH%d_*_TEMP.bmp',[nCam+1]);
    Common.DelateFilesWithWildChar(Common.Path.CompBMP,sTempFileName);
  end;
  sTempFileName := Format('CH%d_%d_TEMP.bmp',[nCam+1,m_nBmpDownCnt[nCAM]]);
  sTempFullName := Common.Path.CompBMP + sTempFileName;

  fi := TFileStream.Create(sTempFullName, fmCreate);
  try
    fi.WriteBuffer(SBuffer[0],Length(SBuffer));
  finally
    fi.Free;
  end;

  //2019-02-08 (BMP File: WriteBuffer -> CopyFile)
  nowDateTime := Now;
  if (not Common.SystemInfo.UseLogUploadPath) then begin
    sFilePath := Common.Path.CompBMP + FormatDateTime('yyyymmdd', nowDateTime)+'\';
  end
  else begin //2022-07-25 LOG_UPLOAD
    sFilePath := Common.Path.CompBMP + FormatDateTime('mm', nowDateTime) +'\' + FormatDateTime('dd', nowDateTime)+'\';
    sFilePath := sFilePath + Common.TestModelInfo2[nCh].LogUploadPanelModel+'\' + Common.SystemInfo.EQPId+'\';
    if Trim(m_sSerialNo[nCh]) = '' then m_sSerialNo[nCh] := Format('EMPTYPNID%d',[nCh+1]);
    if Trim(m_sPanelID[nCh]) = ''  then m_sPanelID[nCh]  := m_sSerialNo[nCh];
    sFilePath := sFilePath + m_sPanelID[nCh]+'\';
  end;
  Common.CheckMakeDir(sFilePath,True{bForceDirectories}); //2022-12-22 bForceDirectories=True!!!
  sBmpFileName := m_sSerialNo[nCh]+Format('_%d_',[m_nBmpDownCnt[nCAM]])+FormatDateTime('yyyymmddhhnnss', nowDateTime) + '.bmp';
  sBmpFullName := sFilePath + sBmpFileName;
  bIsOK := False; //2019-02-13
  if System.SysUtils.FileExists(sTempFullName) then begin
    bIsOK := CopyFile(PChar(sTempFullName), PChar(sBmpFullName), False);
  end;
  if bIsOK then begin
    sDebug := 'Create BMP'+Format('%d',[m_nBmpDownCnt[nCAM]])+' file to download OK';
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
  end
  else begin
    sDebug := 'Create BMP'+Format('%d',[m_nBmpDownCnt[nCAM]])+' file to download NG';
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug, DefPocb.LOG_TYPE_NG);
  end;
end;

procedure TCamComm.SaveCBDATAFile(nCam: Integer; const SBuffer: array of Byte);
var
  nCh : Integer;
  fi : TFileStream;
  sFileName, sFilePath, sFullName, sShareFullName : string;
  sExt, sZipFileName, sZipFullName, sDebug : string;
  bIsOK : Boolean;
  bDelete : Boolean;
  nowDateTime : TDateTime;
begin
  nCh := nCam;
  //
  nowDateTime := Now;
  if (not Common.SystemInfo.UseLogUploadPath) then begin
    sFilePath := Common.Path.CBDATA + FormatDateTime('yyyymmdd', nowDateTime)+'\';
  end
  else begin //2022-07-25 LOG_UPLOAD
    sFilePath := Common.Path.CBDATA + FormatDateTime('mm', nowDateTime)+'\' + FormatDateTime('dd', nowDateTime)+'\';
    sFilePath := sFilePath + Common.TestModelInfo2[nCh].LogUploadPanelModel+'\' + Common.SystemInfo.EQPId+'\';
    if Trim(m_sSerialNo[nCh]) = '' then m_sSerialNo[nCh] := Format('EMPTYPNID%d',[nCh+1]);
    if Trim(m_sPanelID[nCh]) = ''  then m_sPanelID[nCh]  := m_sSerialNo[nCh];
    sFilePath := sFilePath + m_sPanelID[nCh]+'\';
  end;
  Common.CheckMakeDir(sFilePath,True{bForceDirectories});

{$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
  sFileName := Common.MesData[nCh].PchkRtnPid+'_'+FormatDateTime('yyyymmddhhnnss', nowDateTime)+'.bin'; //2019-07-24 (Hex File: FOG ID -> PID)
{$ELSE}
  sFileName := m_sSerialNo[nCh]+'_'+FormatDateTime('yyyymmddhhnnss', nowDateTime)+'.bin';
{$ENDIF}
  sFullName := sFilePath + sFileName;
//{$IFDEF SIMULATOR_CAM}
//sDebug := Common.Path.CBDATA + Common.SystemInfo.TestModel[nCam] + '.bin';
//CopyFile(PChar(sDebug), PChar(sFullName), False);
//{$ELSE}
  fi := TFileStream.Create(sFullName, fmCreate);
  try
    fi.WriteBuffer(SBuffer[0],Length(SBuffer));
  finally
    fi.Free;
    fi := nil;
  end;
//{$ENDIF}
  sDebug := 'Create CBDATA File OK';
  SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
  Sleep(100);

  //
  if (Trim(Common.SystemInfo.ShareFolder) <> '') then begin
    bIsOK := False;
    if System.SysUtils.DirectoryExists(Common.SystemInfo.ShareFolder) then begin
      sShareFullName := Common.SystemInfo.ShareFolder + sFileName;
      try
        if System.SysUtils.FileExists(sFullName) then begin
          bIsOK := CopyFile(PChar(sFullName), PChar(sShareFullName), False);
        end;
      except
        bIsOK := False;
      end;
    end;
    if bIsOK then begin
      sDebug := 'Copy CBDATA File to ShareFolder OK';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug);
    end
    else begin
      sDebug := 'Copy CBDATA File to ShareFolder NG';
      SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sDebug, DefPocb.LOG_TYPE_NG);
    end;
  end;
  Sleep(100);

  Common.m_sCBDataFullName[nCh] := sFullName; //USE_FLASH_WRITE_CBDATA

{$IFDEF DFS_HEX}
	Common.m_sBinFileName[nCh] := '';
  Common.m_sBinFullName[nCh] := '';
  if Common.DfsConfInfo.bUseDfs then begin
    if Common.DfsConfInfo.bDfsHexCompress then begin
      Common.m_bDfsUploadFileReady[nCh] := False;
      Common.ThreadTask(procedure
      var bDelete : Boolean;
      begin
        bDelete := Common.DfsConfInfo.bDfsHexDelete and (not Common.TestModelInfo2[nCh].EnableFlashWriteCBData);  //USE_FLASH_WRITE_CBDATA
        Common.FileCompress(sFullName, bDelete); //USE_FLASH_WRITE_CBDATA
        //
        Common.m_bDfsUploadFileReady[nCh] := True;
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,'CBDATA File Compress OK');  //2021-03-04 (A2CHv2)
      end);
      //
      sExt := ExtractFileExt(sFileName);
      sZipFileName := StringReplace(sFileName,sExt,'.zip', [rfReplaceAll, rfIgnoreCase]);
      sZipFullName := sFilePath + sZipFileName; //Change file name to Zip
     	Common.m_sBinFileName[nCh] := sZipFileName;
     	Common.m_sBinFullName[nCh] := sZipFullName;
    end
    else begin
			Common.m_bDfsUploadFileReady[nCh] := True;
     	Common.m_sBinFileName[nCh] := sFileName;
     	Common.m_sBinFullName[nCh] := sFullName;
    end;
  end;
{$ENDIF}
end;

//******************************************************************************
// procedure/function: CamComm -> PG/SPI
//    - BmpDownload(nCam: Integer; const AContext: TIdContext)   // Called-by ReadSvr
//******************************************************************************

procedure TCamComm.BmpDownload(nCam: Integer; const AContext: TIdContext);  //#BmpToDownload
var
  nPg, nCh : Integer;
//  mtData : TMemoryStream;
  bmp1   : TBitmap;
  btBuff : TIdBytes;
  nTotalSize : Integer;
  bRtn : boolean;
  dGetCheckSum : dword;
  sTemp : string;
  nTryCnt : Integer;
  nType, nDiv, nMod : Integer;
begin
  nCh := nCam;
  nPg := nCam;
  //
  try
    SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,'Convert BMP data to Raw Data');
	  bmp1 := Tbitmap.Create;
    try
      sTemp := Format('CH%d_%d_TEMP.bmp',[nCam+1,m_nBmpDownCnt[nCAM]]);
      bmp1.LoadFromFile(Common.Path.CompBMP + sTemp);
      nDiv := bmp1.Width div 2048;
      nMod := bmp1.Width mod 2048;
      if nMod > 0 then nDiv := nDiv + 1;
      nType := nDiv * 2048;  //~2048(2048), ~4096(4096), ~6144(6144), ~8192(8192)
      nTotalSize := bmp1.Height * nType * 3;

      SetLength(btBuff,nTotalSize);
      Common.MakeRawData(bmp1,btBuff);
      SetLength(m_nSendData[nCam].Data,nTotalSize);
      CopyMemory(@m_nSendData[nCam].Data[0],@btBuff[0],nTotalSize);
      m_nSendData[nCh].TotalSize := nTotalSize;
      m_nSendData[nCh].TransType := DefPG.PGSIG_BMPDOWN_TYPE_COMPBMP + m_nBmpDownCnt[nCAM];
      m_nSendData[nCh].BmpWidth  := bmp1.Width; //DP201+BMP
      dGetCheckSum := 0;
      // for Check Sum.
      if m_nSendData[nCam].TotalSize > 0 then begin
        Common.CalcCheckSum(@m_nSendData[nCam].Data[0], m_nSendData[nCam].TotalSize, dGetCheckSum);
      end;
      m_nSendData[nCam].CheckSum := dGetCheckSum;
      // download data....
      for nTryCnt := 0 to Common.TestModelInfo2[nCh].BmpDownRetryCnt do begin  //2021-07-07 BMP Download Retry if Download NG
        if nTryCnt = 0 then begin sTemp := 'Start BMP Download to PG' end
        else                begin Sleep(1000); sTemp := 'Start BMP Download to PG (Retry)'; end;
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,sTemp);
        bRtn := Pg[nPg].PgDownBmpFile(m_nSendData[nCam]); //#SendBuffData
        if bRtn then Break;
      end;
      if bRtn then begin
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,'BMP Download OK');
        Pg[nPg].SendPgDisplayDownBmp(m_nBmpDownCnt[nCam]);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,'Display Downloaded BMP');
        SendDataByServer(nCh,'ACK',AContext);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,'(GPC ==> DPC) ACK');
      end
      else begin
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,'BMP Download NG', DefPocb.LOG_TYPE_NG);
        SendDataByServer(nCh,'NAK',AContext);
        SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,nCh,'(GPC ==> DPC) NAK', DefPocb.LOG_TYPE_NG);
      end;
    finally
      bmp1.Free;
    //bmp1 := nil;
      Inc(m_nBmpDownCnt[nCam]);
    end;
  finally
//    mtData.Free;
//    mtData := nil;
  end;
end;

//******************************************************************************
// procedure/function: CamComm <-> otherClasses
//    - SendMainGuiDisplay(nGuiMode, nCH, nParam: Integer; sMsg: string);
//    - SendTestGuiDisplay(nGuiMode, nCH: Integer; sMsg: string; nParam: Integer = 0)
//    - SetModelSet
//    - ThreadCmd(nIdx: Integer; sCamChange : string)
//    - ThreadTask(task: TProc)
//******************************************************************************

procedure TCamComm.SendMainGuiDisplay(nGuiMode, nCh, nParam: Integer; sMsg: string);
var
  ccd : TCopyDataStruct;
  MainGuiCamData : RMainGuiCamData;
begin
  //Common.CodeSiteSend('<CamComm> SendMainGuiDisplay: Mode('+IntToStr(nGuiMode)+') Ch('+IntToStr(nCh+1)+') Param('+IntToStr(nParam)+')');
  MainGuiCamData.MsgType := DefPocb.MSG_TYPE_CAMERA;
  MainGuiCamData.Channel := nCh;
  MainGuiCamData.Mode    := nGuiMode;
  MainGuiCamData.Param   := nParam;
  MainGuiCamData.Msg     := sMsg;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(MainGuiCamData);
  ccd.lpData      := @MainGuiCamData;
  SendMessage(m_hMain,WM_COPYDATA,0,LongInt(@ccd));
end;

procedure TCamComm.SendTestGuiDisplay(nGuiMode, nCh: Integer; sMsg: string; nParam: Integer = 0; nParam2: Integer = 0);
var
  ccd : TCopyDataStruct;
  TestGuiCamData : RTestGuiCamData;
begin
  //Common.CodeSiteSend('<CamComm> SendTestGuiDisplay: Mode('+IntToStr(nGuiMode)+') Ch('+IntToStr(nCh+1)+') Param('+IntToStr(nParam)+')');
  TestGuiCamData.MsgType := DefPocb.MSG_TYPE_CAMERA;
  TestGuiCamData.Channel := nCh;
  TestGuiCamData.Mode    := nGuiMode;
  TestGuiCamData.Msg     := sMsg;
  TestGuiCamData.Param   := nParam;
  TestGuiCamData.Param2  := nParam2;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(TestGuiCamData);
  ccd.lpData      := @TestGuiCamData;
  SendMessage(m_hTest[nCh],WM_COPYDATA,0,LongInt(@ccd));
end;

//------------------------------------------------------------------------------
// [PROC/FUNC]
//    Called-by:
//
procedure TCamComm.SetModelSet;
var
  nCh : Integer;
  sCamChange : string;
//slstData : TStringList;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<CameraCtl> SetModelSet');
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    sCamChange := 'MODELCHG ' + Common.SystemInfo.TestModel[nCh];
    ThreadCmd(nCh,sCamChange);
  end;
end;

procedure TCamComm.SendTSTOP(nCam: Integer);
begin
  ThreadCmd(nCam,'TSTOP');
end;

procedure TCamComm.ThreadCmd(nCh: Integer; sCamChange: string);   //TBD:SDIP?
var
  nCam : Integer;
begin
  nCam := ChNo2CamNo(nCh);
  ThreadTask(procedure begin
    SendCmd(nCam,sCamChange, 7000);
  end);
end;

procedure TCamComm.ThreadTask(task: TProc);
var
  thCam : TThread;
begin
  thCam := TThread.CreateAnonymousThread(task);
  thCam.FreeOnTerminate := True;
  thCam.Start;
end;

end.
