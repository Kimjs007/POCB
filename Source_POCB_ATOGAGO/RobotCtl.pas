unit RobotCtl;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.Math, Vcl.ExtCtrls,
	IdContext, IdGlobal, IdSync, IdTCPClient, IdTCPServer, Vcl.Graphics,
  IdComponent, IdCustomTCPServer,
  DefPocb, CommonClass, DefDio, DefRobot, UserUtils,
  CodeSiteLogging;

type

  //============================================================================

  PMainGuiRobotData = ^RMainGuiRobotData;   // Robot -> MainPocb
  RMainGuiRobotData = record
    MsgType   : Integer;
    Channel   : Integer;
    Mode      : Integer;
    Param     : Integer;  // nRobot
    Param2    : Integer;  // DefPocb.MSG_MODE_ROBOT_xxxxxx;
    Param3    : Integer;  // ERR_ROBOT_xxxxxx
    Msg       : string;
  end;

  PTestGuiRobotData = ^RTestGuiRobotData;   // Robot -> frmTest1Ch
  RTestGuiRobotData = record
    MsgType   : Integer;
    Channel   : Integer;
    Mode      : Integer;
    Param     : Integer;
    Msg       : string;
    RobotStatusCoord : TRobotStatusCoord;
  end;

  TRxModbusReq = record
    //TBD?
  end;

  TRxModbusRsp = record
    //TBD?
  end;

  TTxListenNodeCmd = record
    CmdId   : Integer;  
    CmdStr  : string;  
  end;

  TRxListenNodeAck = record //TBD:ROBOT?
    CmdId   : Integer;  
    NgOrYes : Integer;  
    Data    : string;  
  end;

  TRobotTM = class(TObject)
    private
      m_hMain  : HWND;
      m_nJig   : Integer;
      m_nCh    : Integer;
      m_nRobot : Integer;
      m_sRobot : string;
      m_hListenNodeCmdEvent  : HWND;
      tmrCheckModbus     : TTimer;
      tmrCheckListenNode : TTimer;
      //
      procedure ModBusGetCoilsFromBuffer(const Buffer: PByte; const Count: Word; var Data: array of Word);
      procedure ModBusGetRegistersFromBuffer(const Buffer: PWord; const Count: Word; var Data: array of Word);
      procedure ModbusPutCoilsIntoBuffer(const Buffer: PByte; const Count: Word; const Data: array of Word);
      procedure ModbusPutRegistersIntoBuffer(const Buffer: PWord; const Count: Word; const Data: array of Word);
      //
      function SendListenNodeCmd(sCmd: string): Boolean;
      procedure ReadListenNodeCmd(nRobot, nLen: Integer; ABuff: TidBytes);  //TBD:ROBOT?
      function CheckListenNodeCmdAck(Task: TProc; sCmd: string; nCmdId,nWaitMsec,nRetry: Integer): DWORD; //TBD(ROBOT?)
      //
      procedure OnCheckModbusTimer(Sender: TObject);
      procedure OnCheckListenNodeTimer(Sender: TObject);
      procedure SendRobotEvent(nRobotCtlMode: Integer; nErrCode: Integer; sMsg: string);
      procedure SendMainGuiRobotDisplay(nGuiMode, nRobotCtlMode, nErrCode: Integer; sMsg: string);
      procedure SendTestGuiRobotDisplay(nGuiMode: Integer; sMsg: string);
      procedure ThreadTask(task: TProc);
    public
      //
      m_bModbusFirstReadDone      : Boolean;
    //m_CoordState, m_CoordStateOld : enumRobotCoordState;  //TBD:ROBOT?
      m_RobotStatusCoord, m_RobotStatusCoordOld : TRobotStatusCoord;
{$IFDEF SIMULATOR_ROBOT}
      RobotSimModBus_CoordCurrent : TRobotCoord;
      RobotSimModBus_CoordStart   : TRobotCoord;
      RobotSimModBus_CoordHome    : TRobotCoord;
      RobotSimModBus_CoordModel   : TRobotCoord;
      RobotSimModBus_CoordStandby : TRobotCoord;
{$ENDIF}
      //
      m_bListenNodeFirstReadyDone : Boolean;
      m_bHomeDone            : Boolean;
      m_bIsOnListenNodeCmd   : Boolean;
      FTxListenNodeCmd       : TTxListenNodeCmd;
      FRxListenNodeAck       : TRxListenNodeAck;
      m_sListenNodeTxCmd : string; //TBD:ROBOT?
      m_sListenNodeRxAck : string; //TBD:ROBOT?
      //
      constructor Create(hMain: THandle; nRobot: Integer); virtual;
      destructor Destroy; override;
      //------------------------- TRobot: RobotInit/RobotReset
      //---------------------- TRobotTM: ModBus
      //
      procedure InitModbusRobotStatus;
      function GetModbusRobotStatus(var RobotStatus: TRobotStatus): Boolean;
      function GetModbusRobotCoord(var RobotCoord: TRobotCoord): Boolean;
      function GetModbusRobotLight(var RobotLight: UInt16): Boolean;
      function GetModbusRunSpeedMode(var RunSpeed: UInt16; var RunMode: UInt16): Boolean;
      function GetModbusRobotExtra(var RobotExtra: TRobotExtra): Boolean;
      //
      function ModBusReadCoils(const nTranId: Word; const nReadAddr: Word; const nReadCnt: Word; out ReadData: array of Boolean): Boolean;
      function ModBusReadInputBits(const nTranId: Word; const nReadAddr: Word; const nReadCnt: Word; out ReadData: array of Boolean): Boolean;
      function ModBusReadHoldingRegisters(const nTranId: Word; const nReadAddr: Word; const nReadCnt: Word; out ReadData: array of Word): Boolean;
      function ModBusReadInputRegisters(const nTranId: Word; const nReadAddr: Word; const nReadCnt: Word; var ReadData: array of Word): Boolean;
      function ModBusWriteOneCoil(const nTranId: Word; const nWriteAddr: Word; const bOn: Boolean): Boolean;
      function ModBusWriteOneRegister(const nTranId: Word; const nWriteAddr: Word; const nValue: Word): Boolean;
      function ModBusWriteMultiCoils(const nTranId: Word; const nWriteAddr: Word; const nWriteCnt: Word; const WriteData: array of Boolean): Boolean;
      function ModBusWriteMultiRegisters(const nTranId: Word; const nWriteAddr: Word; const nWriteCnt: Word; const WriteData: array of Word): Boolean;
      function SendModbusCommand(const nTranId: Word; const btFuncCode: Byte; const nAddress: Word; const nCount: Word; var Data: array of Word): Boolean;
      //---------------------- TRobotTM: ListenNode: Move(JOG-/JOG+), Move(Relative), Move(Home/Model) 
      //
      function CheckRobotMovable(var sMsg: string; bStandbyCoord: Boolean = False): Boolean;
      function MoveJOG(RobotJog: TRobotJog; bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): Boolean;
      function MoveRELATIVE(CoordRelative: TRobotCoord; bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): Boolean;
      function MoveHOME(bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): Boolean;
      function MoveMODEL(bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): Boolean;
      function MoveSTANDBY(bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): Boolean;
      //
      function GetListenNodeCmdStr2CmdId(sCmd: string): Integer;
      function ListenNodeCmdReq(sCmd: string; bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): DWORD;
      //---------------------- TRobotTM: Get
    //function IsRobotHome: Boolean;    //TBD:ROBOT?
    //function IsRobotModel: Boolean;   //TBD:ROBOT?
    //function IsRobotMoving: Boolean;  //TBD:ROBOT?
    //function IsRobotAlarmOn: Boolean; //TBD:ROBOT?
{$IFDEF SIMULATOR_ROBOT}
      procedure SimRobotModbus(TxBuf: TModBusPktBuf; var RxBuffer: TIdBytes);
      procedure SimRobotListenNode(sCmd: string);
{$ENDIF}
  end;

  //============================================================================ TRobotCtl

  InMaintRobotStatus = procedure(nRobot: Integer; nMode,nErrCode: Integer; sMsg: String) of object;  //TBD:ROBOT?

  TRobotCtl = class(TObject)
    private
      m_hMain            : HWND;
      tmrRobotCheckStart : TTimer;
      //
      FMaintRobotStatus  : InMaintRobotStatus;
      FMaintRobotUse     : Boolean;
      FRobotDioIN        : UInt64;
      procedure SetMaintRobotStatus(const Value: InMaintRobotStatus);
      procedure SetMaintRobotUse(const Value: Boolean);
      procedure SetRobotDioIN(const Value: UInt64);
      procedure OnRobotCheckStartTimer(Sender: TObject);
    //function  GetIsHomeDoneAll : Boolean;    //TBD:ROBOT?
    //function  GetIsAnyRobotMoving : Boolean; //TBD:ROBOT?
      //------------------------------- private for Robot Connection (from CamComm)
      procedure ModbusClientConnected(Sender: TObject);
      procedure ModbusClientDisconnected(Sender: TObject);
      procedure ListenNodeServerExecute(AContext: TIdContext);
      procedure ListenNodeServerConnected(AContext: TIdContext);
      procedure ListenNodeServerDisconnected(AContext: TIdContext);
    //procedure ListenNodeServerException(AThread: TIdListenerThread; AException: Exception); //TBD:CamComm?
    //procedure ListenNodeServerListenStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string); //TBD:CamComm?
      function ListenNode2RobotId(sClientIp: string; var nRobot: Integer): Boolean;
    public
      ModbusClients           : array[DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX] of TIdTCPClient;
      m_bConnectedModbus      : array[DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX] of Boolean;
      m_bGetFailCntModbus     : array[DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX] of Integer;
      ListenNodeServer        : TIdTCPServer;
      ListenNodePeerContext   : array[DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX] of TIdContext;
      m_bConnectedListenNode  : array[DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX] of Boolean;
      m_bGetFailCntListenNode : array[DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX] of Integer;
      //
      m_hTest : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of HWND;
      m_bRobotControlStarted  : Boolean;
      Robot   : array[DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX] of TRobotTM;
      property MaintRobotUse    : Boolean read FMaintRobotUse write SetMaintRobotUse;
      property MaintRobotStatus : InMaintRobotStatus read FMaintRobotStatus write SetMaintRobotStatus;
      property RobotDioIN       : UInt64 read FRobotDioIN write SetRobotDioIN;

    //property IsHomeDoneAll    : Boolean read GetIsHomeDoneAll;      //TBD?
    //property IsAnyRobotMoving : Boolean read GetIsRobotRobotMoving; //TBD?
      constructor Create(hMain: THandle); virtual;
      destructor Destroy; override;
      procedure Connect;
      procedure SetRobotTimers(bEnable: Boolean);
      function GetRobotControlStatus(nRobot: Integer; var sMsg: string): Boolean;  //TBD:A2CHV3:ROBOT?
      function CheckRobotDioStickControlable(nRobot: Integer; nRobotDioCtlType: enumRobotDioCtlType): Boolean; //TBD:A2CHV3:ROBOT? (FailCode)
  end;

var
  DongaRobot : TRobotCtl;

implementation

uses OtlTaskControl, OtlParallel;

//##############################################################################
//##############################################################################
//
{ TRobotCtl }
//
//##############################################################################
//##############################################################################

//******************************************************************************
// procedure/function: 
//
//******************************************************************************

//------------------------------------------------------------------------------
//
constructor TRobotCtl.Create(hMain: THandle);
var
  nRobot : Integer;
begin
  Common.MLog(DefPocb.SYS_LOG,'<RobotCtl> Create');
  //
  m_hMain := hMain;
  for nRobot := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_MAX do begin
    m_hTest[nRobot] := 0;
    m_bConnectedListenNode[nRobot]  := False;
    m_bConnectedModbus[nRobot]      := False;
    m_bGetFailCntModbus[nRobot]     := 0;
    m_bGetFailCntListenNode[nRobot] := 0;
  end;
  m_bRobotControlStarted := False;
  FMaintRobotUse := False;
  //
  tmrRobotCheckStart          := TTimer.Create(nil);
  tmrRobotCheckStart.OnTimer  := OnRobotCheckStartTimer;
  tmrRobotCheckStart.Interval := DefRobot.ROBOT_CHECK_START_TIMEMSEC;
  tmrRobotCheckStart.Enabled  := False;

  // Create TCP server for (ROBOT_TM) ListenNode
  ListenNodeServer := TIdTCPServer.Create(nil);
  ListenNodeServer.OnExecute         := ListenNodeServerExecute;
  ListenNodeServer.OnConnect         := ListenNodeServerConnected;
  ListenNodeServer.OnDisconnect      := ListenNodeServerDisconnected;
  ListenNodeServer.Bindings.Clear;
  ListenNodeServer.Bindings.Add.IP   := Common.RobotSysInfo.MyIpAddr;
  ListenNodeServer.Bindings.Add.Port := Common.RobotSysInfo.TcpPortListenNode;
//??? ListenNodeServer.ReuseSocket   := rsFalse;  //Add 2019-01-17 //TBD:ROBOT?
//ListenNodeServer.OnListenException := RobotServerListenException;
//ListenNodeServer.OnStatus          := RobotServerStatus;
  // TIdReuseSocket is an enumerated type that represents the manner in which socket reuse is supported in Indy TCP servers.
  // TIdReuseSocket can contain one of the following values and associated meanings:
  //    Value  		      Meaning
  //    rsOSDependent  	Reuse IP addersses and port numbers when the OS platform is Linux. (default)
  //    rsTrue  	      Always resuse IP addersses and port numbers.
  //    rsFalse  	      Never resuse IP addersses and port numbers.
  try
    ListenNodeServer.Active := True;
  except
    //TBD:ROBOT?
    CodeSite.Send('<RobotCtl> RobotCtl.Create: ListenNode TCPServer.Active Failed !!!');
  end;

  // Create TCP Client for (ROBOT_TM) Modbus
  for nRobot := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_MAX do begin
    ModbusClients[nRobot] := TIdTCPClient.Create(nil);
{$IFDEF SIMULATOR_ROBOT}
    ModbusClients[nRobot].Host := Format('%s%d',[DefRobot.ROBOT_IPADDR_NETWORK,ROBOT_IPADDR_BASE+nRobot]);
    ModbusClients[nRobot].Port := Common.RobotSysInfo.TcpPortModbus + nRobot;
{$ELSE}
    ModbusClients[nRobot].Host := Common.RobotSysInfo.IPAddr[nRobot];
    ModbusClients[nRobot].Port := Common.RobotSysInfo.TcpPortModbus;
{$ENDIF}
    ModbusClients[nRobot].Tag    := nRobot;
  //ModbusClients[nRobot].IOHanClosedGracefully; //TBD?
  //ModbusClients[nRobot].ReuseSocket := rsTrue; //TBD?
  //ModbusClients[nRobot].ManagedIOHandler := True; //TBD?
    ModbusClients[nRobot].OnConnected    := ModbusClientConnected;
    ModbusClients[nRobot].OnDisconnected := ModbusClientDisconnected;
    ModbusClients[nRobot].ConnectTimeout := ROBOT_MODBUS_CONNWAIT_TIMEMSEC; //TBD:ROBOT?
    ModbusClients[nRobot].ReadTimeout    := ROBOT_MODBUS_RESPWAIT_TIMEMSEC; //TBD:ROBOT?
    //
    { //--> RobotCtl.Connect
    try
      ModbusClients[nRobot].Connect; //TBD:ROBOT?
    except
      //TBD:ROBOT?
      Common.MLog(DefPocb.SYS_LOG,'<RobotCtl> ROBOTx: ModbusClients Init Connection Failed !!!');
    end;
    }
  end;

  // Create Robot/RobotTM
  for nRobot := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_MAX do begin
{$IFDEF USE_ROBOT_TM}
    Robot[nRobot] := TRobotTM.Create(hMain,nRobot);
{$ENDIF}
  end;
end;

//------------------------------------------------------------------------------
//
destructor TRobotCtl.Destroy;
var
  nRobot : Integer;
begin
  CodeSite.Send('<RobotCtl> RobotCtl.Destroy');

  if ListenNodeServer <> nil then begin
    ListenNodeServer.OnConnect    := nil;
    ListenNodeServer.OnDisconnect := nil;
    try
      ListenNodeServer.Active := False;
    except
    end;
    ListenNodeServer.Free;
    ListenNodeServer := nil;
  end;

  //
  for nRobot := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_MAX do begin
    if ModbusClients[nRobot] <> nil then begin
      ModbusClients[nRobot].OnConnected    := nil;
      ModbusClients[nRobot].OnDisconnected := nil;
      try
        if ModbusClients[nRobot].Connected then ModbusClients[nRobot].Disconnect;
      except
      end;
      ModbusClients[nRobot].Free;
      ModbusClients[nRobot] := nil;
    end;
  end;
  //
  for nRobot := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_MAX do begin
    if (Robot[nRobot] <> nil) then begin
      Robot[nRobot].Free;
      Robot[nRobot] := nil;
    end;
  end;
end;

//------------------------------------------------------------------------------
//
procedure TRobotCtl.SetRobotTimers(bEnable: Boolean); //2023-08-04 //TBD:ROBOT?
var
  nRobot : Integer;
begin
  CodeSite.Send('<RobotCtl> RobotCtl.SetRobotTimers('+TernaryOp(bEnable,'ON','OFF')+')...TBD');
{$IFDEF TBD_ROBOT} //TBD:2023-08-XX?
  for nRobot := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_MAX do begin
    with Robot[nRobot] do begin
      tmrCheckModbus.Enabled := bEnable;
      tmrCheckListenNode.Enabled := bEnable;
      //
      if (not bEnable) then begin
        if m_bIsOnListenNodeCmd then CloseHandle(m_hListenNodeCmdEvent);
      end;
    end;
  end;
{$ENDIF}
end;

procedure TRobotCtl.Connect;
var
  nRobot : Integer;
begin
  CodeSite.Send('<RobotCtl> RobotCtl.Connect');
  for nRobot := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_MAX do begin
    try
      ModbusClients[nRobot].Connect; //TBD:ROBOT?
    except
      //TBD:ROBOT?
      CodeSite.Send('<RobotCtl> ROBOT'+IntToStr(nRobot+1)+': RobotCtl.Connect: ModbusClient.Connect Failed !!!');
    end;
  end;
  //
  tmrRobotCheckStart.Enabled := True;
end;

procedure TRobotCtl.OnRobotCheckStartTimer(Sender: TObject);
var
  nRobot : Integer;
  sMsg   : string;
begin
  CodeSite.Send('<RobotCtl> OnRobotCheckStartTimer: RobotCheckStartTimer Expired');
  tmrRobotCheckStart.Enabled := False;
  //
  for nRobot := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_MAX do begin
    if not m_bConnectedModbus[nRobot] then begin
      sMsg := '<ROBOT> CH'+IntToStr(nRobot+1)+': ModBus TCP-Client Disconnected !!!';
      Robot[nRobot].SendRobotEvent(DefPocb.MSG_MODE_ROBOT_CONNECT_MODBUS, DefPocb.ERR_ROBOT_CONNECT, sMsg);
      m_bGetFailCntModbus[nRobot] := 0;
    end;
    if not m_bConnectedListenNode[nRobot] then begin
      sMsg := '<ROBOT> CH'+IntToStr(nRobot+1)+': Command TCP-Server Disconnected !!!';
      Robot[nRobot].SendRobotEvent(DefPocb.MSG_MODE_ROBOT_CONNECT_COMMAND, DefPocb.ERR_ROBOT_CONNECT, sMsg);
      m_bGetFailCntListenNode[nRobot] := 0;
    end;
  end;
  //
  for nRobot := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_MAX do begin
    Robot[nRobot].tmrCheckModbus.Enabled := True;
    Robot[nRobot].tmrCheckListenNode.Enabled := True;
  end;
  m_bRobotControlStarted := True;
end;

//******************************************************************************
// procedure/function: 
//

//
function TRobotCtl.ListenNode2RobotId(sClientIp: string; var nRobot: Integer): Boolean;
var
  sTemp : string;
  i : Integer;
begin
  Result := False;
  nRobot := -1;   //TBD?
  for i := DefRobot.ROBOT_CH1 to DefRobot.ROBOT_MAX do begin
    sTemp := Common.RobotSysInfo.IPAddr[i];
    if sClientIp = sTemp then begin
      nRobot := i;
      Break;
    end;
  end;
  Result := (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]);
end;

procedure TRobotCtl.ModbusClientConnected(Sender: TObject);
var
  nRobot : Integer;
  sMsg   : string;
begin
  nRobot := (Sender as TIdTCPClient).Tag;
  CodeSite.Send('<RobotCtl> ROBOT'+IntToStr(nRobot+1)+': RobotCtl.ModbusClientConnected');
  //
  ModbusClients[nRobot].Socket.Binding.SetKeepAliveValues(True,10000,1000);  //TBD:ROBOT?
  //
  if not m_bConnectedModbus[nRobot] then begin  // 2020-12-18 (무응답으로 Disc->Conn한 경우, 아래 루틘 생략)
    m_bConnectedModbus[nRobot]  := True; // before SendRobotEvent !!!
    m_bGetFailCntModbus[nRobot] := 0;
    Robot[nRobot].InitModbusRobotStatus;
    sMsg := '<ROBOT> CH'+IntToStr(nRobot+1)+': Modbus TCP-Client Connected';
    Robot[nRobot].SendRobotEvent(DefPocb.MSG_MODE_ROBOT_CONNECT_MODBUS, DefPocb.ERR_OK, sMsg);
  end;
end;

procedure TRobotCtl.ModbusClientDisconnected(Sender: TObject);
var
  nRobot : Integer;
  sMsg   : string;
begin
  nRobot := (Sender as TIdTCPClient).Tag;
  CodeSite.Send('<RobotCtl> ROBOT'+IntToStr(nRobot+1)+': RobotCtl.ModbusClientDisconnected !!!');
  //
  m_bConnectedModbus[nRobot]  := False; // before SendRobotEvent !!!
  m_bGetFailCntModbus[nRobot] := 0;
  Robot[nRobot].InitModbusRobotStatus;
  sMsg := '<ROBOT> CH'+IntToStr(nRobot+1)+': Modbus TCP-Client Disconnected !!!';
  Robot[nRobot].SendRobotEvent(DefPocb.MSG_MODE_ROBOT_CONNECT_MODBUS, DefPocb.ERR_ROBOT_CONNECT, sMsg);
end;

procedure TRobotCtl.ListenNodeServerConnected(AContext: TIdContext);
var
  nRobot : Integer;
  sMsg   : string;
begin
  if not ListenNode2RobotId(AContext.Connection.Socket.Binding.PeerIP,nRobot) then Exit;
  CodeSite.Send('<RobotCtl> ROBOT'+IntToStr(nRobot+1)+': RobotCtl.ListenNodeServerConnected');
  //
  m_bConnectedListenNode[nRobot]  := True; // before SendRobotEvent !!!
  m_bGetFailCntListenNode[nRobot] := 0;
  ListenNodePeerContext[nRobot] := AContext; //TBD:ROBOT?
  sMsg := '<ROBOT> CH'+IntToStr(nRobot+1)+': Command TCP-Server Connected';
  Robot[nRobot].m_bListenNodeFirstReadyDone := False;
  Robot[nRobot].SendRobotEvent(DefPocb.MSG_MODE_ROBOT_CONNECT_COMMAND, DefPocb.ERR_OK, sMsg);
  //
  Robot[nRobot].ListenNodeCmdReq('READY', False{bCheckAck},ROBOT_LISTENNODE_CONNCHECK_TIMEMSEC,0{nRetry});
end;

procedure TRobotCtl.ListenNodeServerDisconnected(AContext: TIdContext);
var
  nRobot : Integer;
  sMsg   : string;
begin
  if not ListenNode2RobotId(AContext.Connection.Socket.Binding.PeerIP,nRobot) then Exit;
  CodeSite.Send('<RobotCtl> ROBOT'+IntToStr(nRobot+1)+': RobotCtl.ListenNodeServerDisconnected !!!');
  //
  m_bConnectedListenNode[nRobot]  := False; //before SendRobotEvent !!!
  m_bGetFailCntListenNode[nRobot] := 0;
  ListenNodePeerContext[nRobot] := nil; //TBD:ROBOT?
  sMsg := '<ROBOT> CH'+IntToStr(nRobot+1)+': Command TCP-Server Disconnected !!!';
  Robot[nRobot].SendRobotEvent(DefPocb.MSG_MODE_ROBOT_CONNECT_COMMAND, DefPocb.ERR_ROBOT_CONNECT, sMsg);
end;

{
procedure TRobotCtl.RobotServerListenException(AThread: TIdListenerThread; AException: Exception);
begin
  CodeSite.Send('<RobotCtl> RobotServerListenException');
end;

procedure TRobotCtl.RobotServerStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
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
  CodeSite.Send('<RobotCtl> RobotServerStatus: '+sStatus+': '+AStatusText);
end;
}

procedure TRobotCtl.ListenNodeServerExecute(AContext: TIdContext);
var
  nRobot  : Integer;
  LBuffer : TidBytes;
begin
  try
  //AContext.Connection.IOHandler.ReadTimeout := ROBOT_LISTENNODE_RESPWAIT_TIMEMSEC; //TBD:ROBOT?
    AContext.Connection.IOHandler.CheckForDataOnSource(ROBOT_LISTENNODE_MAXDATAWAIT_TIMEMSEC); // Wait max msecs for available data !!!
    if not AContext.Connection.IOHandler.InputBufferIsEmpty then begin
      // TCP-Server RX Message Processing
      AContext.Connection.IOHandler.InputBuffer.ExtractToBytes(LBuffer);
      if Length(LBuffer) <= 0 then Exit;
      if not ListenNode2RobotId(AContext.Connection.Socket.Binding.PeerIP,nRobot) then Exit;  // Search ROBOT#
      DongaRobot.Robot[nRobot].ReadListenNodeCmd(nRobot,Length(LBuffer),LBuffer);
    end;
  except
  end;
end;

//******************************************************************************
// procedure/function:

procedure TRobotCtl.SetMaintRobotStatus(const Value: InMaintRobotStatus);
begin
  FMaintRobotStatus := Value;
end;

procedure TRobotCtl.SetMaintRobotUse(const Value: Boolean);
begin
  FMaintRobotUse := Value;
end;

procedure TRobotCtl.SetRobotDioIN(const Value: UInt64);
begin
  FRobotDioIN := Value;
end;

function TRobotCtl.GetRobotControlStatus(nRobot: Integer; var sMsg: string): Boolean;  //TBD:ROBOT?
begin
  Result := False;
  sMsg   := '';
  if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  // Check Modbus Connection
  if (not m_bConnectedModbus[nRobot]) then begin
    if m_bConnectedListenNode[nRobot] then sMsg := 'ModB-Disc' else sMsg := 'ModB/CMD-Disc';
    Exit;
  end;
  //
  with Robot[nRobot] do begin //TBD:A2CHv3:ROBOT (Robot Status Display Message - Priority?)
    // ModBus Connection
    if (not m_bModbusFirstReadDone) then begin sMsg := 'ModB-Conn'; Exit; end;
    // RobotLight (except 04_AutoMode)
    case m_RobotStatusCoord.RobotLight of
      ROBOT_TM_LIGHT_00_Off_EStop:                             sMsg := '00_EStop';
      ROBOT_TM_LIGHT_01_SolidRed_FatalError:                   sMsg := '01_FatalError';
      ROBOT_TM_LIGHT_02_FlashingRed_Initializing:              sMsg := '02_Initializing';
      ROBOT_TM_LIGHT_03_SolidBlue_StandbyInAutoMode:           sMsg := '03_StandbyInAutoMode';
    //ROBOT_TM_LIGHT_04_FlashingBlue_AutoMode:                 sMsg := '04_AutoMode';
      ROBOT_TM_LIGHT_05_SloidGreen_StandbyInManualMode:        sMsg := '05_StandbyInManualMode';
      ROBOT_TM_LIGHT_06_FlashingGreen_ManualMode:              sMsg := '06_ManualMode';
      ROBOT_TM_LIGHT_09_AlterBlueRed_AutoModeError:            sMsg := '09_AutoModeError';
      ROBOT_TM_LIGHT_10_AlterGreenRed_ManualModeError:         sMsg := '10_ManualModeError';
      ROBOT_TM_LIGHT_13_AlterPurpleGreen_HmiInManualMode:      sMsg := '13_HmiInManualMode';
      ROBOT_TM_LIGHT_14_AlterPurpleBlue_HmiInAutoMode:         sMsg := '14_HmiInAutoMode';
      ROBOT_TM_LIGHT_18_AlterWhiteBlue_ReducedSpaceInAutoMode: sMsg := '18_ReducedSpaceInAutoMode';
      ROBOT_TM_LIGHT_19_FlashingLightBlue_SafeStartupMode:     sMsg := '19_SafeStartupMode';
    end;
    if sMsg <> '' then Exit;
    // ModBus RobotStatus
    if m_RobotStatusCoord.RobotStatus.EStop                then begin sMsg := 'E-STOP';      Exit; end;
    if m_RobotStatusCoord.RobotStatus.FatalError           then begin sMsg := 'FatalError';  Exit; end;
  //if m_RobotStatusCoord.RobotStatus.SafetyIO             then begin sMsg := 'SafetyIO';    Exit; end;
    if m_RobotStatusCoord.RunMode <> ROBOT_TM_MB_RUNMODE_AUTO then begin
      if m_RobotStatusCoord.RunMode = ROBOT_TM_MB_RUNMODE_MANUAL then sMsg := 'ManualMode'
      else                                                            sMsg := 'UnknownMode';
      Exit;
    end;
		//
    if m_RobotStatusCoord.RobotExtra.CannotMove            then begin sMsg := 'CannotMove';  Exit; end;  //2021-03-06
    //
		if m_RobotStatusCoord.RobotStatus.GetControl           then begin sMsg := 'GetControl';  Exit; end;
    if m_RobotStatusCoord.RobotStatus.ProjectEditing       then begin sMsg := 'ProjEdit';    Exit; end;
    if (not m_RobotStatusCoord.RobotStatus.ProjectRunning) then begin sMsg := 'Not-ProjRun'; Exit; end;
    if m_RobotStatusCoord.RobotStatus.ProjectPause         then begin sMsg := 'ProjPause';   Exit; end;
  //if m_RobotStatusCoord.RobotStatus.CameraLight          then begin sMsg := 'CameraLight'; Exit; end;
    //
    if (not m_bConnectedListenNode[nRobot]) then begin sMsg := 'CMD-Disc'; Exit; end;
    if (not m_bListenNodeFirstReadyDone) then begin sMsg := 'CMD-WaitReady'; Exit; end;

    //
    case m_RobotStatusCoord.CoordState of
      coordHome:    sMsg := 'Coord(Home)';
      coordModel:   sMsg := 'Ready(Model)';
      coordStandby: sMsg := 'Coord(Standby)';
      else          sMsg := 'Coord(Unknown)';
    end;
  end;
  Result := True;
end;

function TRobotCtl.CheckRobotDioStickControlable(nRobot: Integer; nRobotDioCtlType: enumRobotDioCtlType): Boolean; //TBD:A2CHV3:ROBOT? (FailCode)
var
  sDebug : string;
begin
  Result := False; //TBD:A2CHV3:ROBOT? (FailCode)
  //
  sDebug := Format('<ROBOT> ROBOT%d: CheckRobotDioStickControlable(%d)',[nRobot,Ord(nRobotDioCtlType)]);
  if (not DongaRobot.m_bConnectedModbus[nRobot]) then begin
    CodeSite.Send(sDebug+': False(m_bConnectedModbus=False)');
    Exit;
  end;
  //
  case nRobotDioCtlType of
    MakePlay, MakePause: begin  // Pause <--> Play
      if (Robot[nRobot].m_RobotStatusCoord.RunMode <> DefRobot.ROBOT_TM_MB_RUNMODE_AUTO) then begin  // [REF] LMK_202011
        CodeSite.Send(sDebug+': False(RunMode<>Auto)');
        Exit;
      end;
    //if (not m_RobotStatusCoord.RobotStatus.ProjectRunning) then begin  // [REF] LMK_202011 //TBD:A2CHV3:ROBOT?
    //  CodeSite.Send(sDebug+': False(ProjRunning=False) ...TBD');
    //  Exit;
    //end;
      if (nRobotDioCtlType = MakePlay) then begin
        if (not Robot[nRobot].m_RobotStatusCoord.RobotStatus.ProjectPause) then begin
          CodeSite.Send(sDebug+': False(Already Not-Pause)');
          Exit;
        end;
      end
      else begin
        if DongaRobot.Robot[nRobot].m_RobotStatusCoord.RobotStatus.ProjectPause then begin
          CodeSite.Send(sDebug+': False(Already Pause)');
          Exit;
        end;
      end;
    end;
    MakeAutoMode: begin // Manual -> Auto //TBD:A2CHv3:ROBOT (RobotDioControl:Manual->Auto)
      if (DongaRobot.Robot[nRobot].m_RobotStatusCoord.RunMode = DefRobot.ROBOT_TM_MB_RUNMODE_AUTO) then begin
        CodeSite.Send(sDebug+': False(Alreay Auto)');
        Exit;
      end;
    end;
    MakeManualMode: begin  // Auto -> Manual //TBD:A2CHv3:ROBOT (RobotDioControl:Auto->Manual)
      if (DongaRobot.Robot[nRobot].m_RobotStatusCoord.RunMode <> DefRobot.ROBOT_TM_MB_RUNMODE_AUTO) then begin
        CodeSite.Send(sDebug+': False(Alreay Manual)');
        Exit;
      end;
    end;
  end;
  //
  Result := True;
end;

//******************************************************************************
// procedure/function:
//    -
//******************************************************************************

//##############################################################################
//##############################################################################
//
{ TRobotTM }
//
//##############################################################################
//##############################################################################

//******************************************************************************
// TRobotTM - Create/Destroy
//

//------------------------------------------------------------------------------
constructor TRobotTM.Create(hMain: THandle; nRobot: Integer);
begin
  m_hMain  := hMain;
  m_nJig   := nRobot;
  m_nCh    := nRobot;
  m_nRobot := nRobot;
  m_sRobot := 'ROBOT'+IntToStr(nRobot+1);
  //-------------------------- TBD:ROBOT?
  m_RobotStatusCoord.CoordState := coordUndefined;
  m_bListenNodeFirstReadyDone := False;
  m_bHomeDone := False;
  //-------------------------- Timer
  // Modbus - Robot Status Check Timer
  tmrCheckModbus          := TTimer.Create(nil);
  tmrCheckModbus.OnTimer  := OnCheckModbusTimer;
  tmrCheckModbus.Interval := DefRobot.ROBOT_MODBUS_CONNCHECK_TIMEMSEC;
  tmrCheckModbus.Enabled  := False; //!!!
  // ListenNode - Check Timer
  tmrCheckListenNode          := TTimer.Create(nil);
  tmrCheckListenNode.OnTimer  := OnCheckListenNodeTimer;
  tmrCheckListenNode.Interval := DefRobot.ROBOT_LISTENNODE_CONNCHECK_TIMEMSEC; //5sec? TBD:ROBOT?
  tmrCheckListenNode.Enabled  := False; //!!!
  //
  InitModbusRobotStatus;
end;

//------------------------------------------------------------------------------
destructor TRobotTM.Destroy;  //TBD:ROBOT?
begin
  if m_bIsOnListenNodeCmd then CloseHandle(m_hListenNodeCmdEvent); //2023-06-XX

  //-------------------------- Timer
  tmrCheckModbus.Enabled := False;
  tmrCheckModbus.Free;
  tmrCheckModbus := nil;

  tmrCheckListenNode.Enabled := False;
  tmrCheckListenNode.Free;
  tmrCheckListenNode := nil;

  inherited;
end;

//******************************************************************************
// TRobotTM - Connect/Init/Close
//

//******************************************************************************
// TRobotTM - ModBus
//

//------------------------------------------------------------------------------
//
procedure TRobotTM.InitModbusRobotStatus;
begin
  //
  m_bModbusFirstReadDone := False;
//m_CoordState := coordUndefined; //TBD:ROBOT?
  //
  with m_RobotStatusCoord do begin
    // RobotStatus
    RobotStatus.FatalError     := False;
    RobotStatus.ProjectRunning := True;
    RobotStatus.ProjectEditing := False;
    RobotStatus.ProjectPause   := False;
    RobotStatus.GetControl     := False;
  //RobotStatus.CameraLight    := False;
  //RobotStatus.SafetyIO       := False;
    RobotStatus.EStop          := False;
    // RobotJoint
    RobotJoint.Joint1 := 0.0;
    RobotJoint.Joint2 := 0.0;
    RobotJoint.Joint3 := 0.0;
    RobotJoint.Joint4 := 0.0;
    RobotJoint.Joint5 := 0.0;
    RobotJoint.Joint6 := 0.0;
    // RobotCoord
    RobotCoord.X  := 0.0;
    RobotCoord.Y  := 0.0;
    RobotCoord.Z  := 0.0;
    RobotCoord.Rx := 0.0;
    RobotCoord.Ry := 0.0;
    RobotCoord.Rz := 0.0;
    // RobotLight
  //???  //TBD:ROBOT?
    // RunSpeed
  //???  //TBD:ROBOT?
    // RunMode
    RunMode := ROBOT_TM_MB_RUNMODE_AUTO;
    //
    RobotExtra.CannotMove     := False;		
  end;

{$IFDEF SIMULATOR_ROBOT}
  RobotSimModBus_CoordCurrent.X  := 0.0;
  RobotSimModBus_CoordCurrent.Y  := 0.0;
  RobotSimModBus_CoordCurrent.Z  := 0.0;
  RobotSimModBus_CoordCurrent.Rx := 0.0;
  RobotSimModBus_CoordCurrent.Ry := 0.0;
  RobotSimModBus_CoordCurrent.Rz := 0.0;

  RobotSimModBus_CoordStart.X  := 0.0;
  RobotSimModBus_CoordStart.Y  := 0.0;
  RobotSimModBus_CoordStart.Z  := 0.0;
  RobotSimModBus_CoordStart.Rx := 0.0;
  RobotSimModBus_CoordStart.Ry := 0.0;
  RobotSimModBus_CoordStart.Rz := 0.0;

  case m_nRobot of
    ROBOT_CH1: begin
      RobotSimModBus_CoordHome.X   := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_A].X;
      RobotSimModBus_CoordHome.Y   := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_A].Y;
      RobotSimModBus_CoordHome.Z   := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_A].Z;
      RobotSimModBus_CoordHome.Rx  := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_A].Rx;
      RobotSimModBus_CoordHome.Ry  := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_A].Ry;
      RobotSimModBus_CoordHome.Rz  := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_A].Rz;

      RobotSimModBus_CoordStandby.X   := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_A].X;
      RobotSimModBus_CoordStandby.Y   := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_A].Y;
      RobotSimModBus_CoordStandby.Z   := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_A].Z;
      RobotSimModBus_CoordStandby.Rx  := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_A].Rx;
      RobotSimModBus_CoordStandby.Ry  := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_A].Ry;
      RobotSimModBus_CoordStandby.Rz  := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_A].Rz;

      RobotSimModBus_CoordModel.X  := Common.TestModelInfo2[DefPocb.JIG_A].RobotModelInfo.Coord.X;
      RobotSimModBus_CoordModel.Y  := Common.TestModelInfo2[DefPocb.JIG_A].RobotModelInfo.Coord.Y;
      RobotSimModBus_CoordModel.Z  := Common.TestModelInfo2[DefPocb.JIG_A].RobotModelInfo.Coord.Z;
      RobotSimModBus_CoordModel.Rx := Common.TestModelInfo2[DefPocb.JIG_A].RobotModelInfo.Coord.Rx;
      RobotSimModBus_CoordModel.Ry := Common.TestModelInfo2[DefPocb.JIG_A].RobotModelInfo.Coord.Ry;
      RobotSimModBus_CoordModel.Rz := Common.TestModelInfo2[DefPocb.JIG_A].RobotModelInfo.Coord.Rz;
    end;
    ROBOT_CH2: begin
      RobotSimModBus_CoordHome.X   := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_B].X;
      RobotSimModBus_CoordHome.Y   := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_B].Y;
      RobotSimModBus_CoordHome.Z   := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_B].Z;
      RobotSimModBus_CoordHome.Rx  := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_B].Rx;
      RobotSimModBus_CoordHome.Ry  := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_B].Ry;
      RobotSimModBus_CoordHome.Rz  := Common.RobotSysInfo.HomeCoord[DefPocb.JIG_B].Rz;

      RobotSimModBus_CoordStandby.X   := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_B].X;
      RobotSimModBus_CoordStandby.Y   := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_B].Y;
      RobotSimModBus_CoordStandby.Z   := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_B].Z;
      RobotSimModBus_CoordStandby.Rx  := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_B].Rx;
      RobotSimModBus_CoordStandby.Ry  := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_B].Ry;
      RobotSimModBus_CoordStandby.Rz  := Common.RobotSysInfo.StandbyCoord[DefPocb.JIG_B].Rz;

      RobotSimModBus_CoordModel.X  := Common.TestModelInfo2[DefPocb.JIG_B].RobotModelInfo.Coord.X;
      RobotSimModBus_CoordModel.Y  := Common.TestModelInfo2[DefPocb.JIG_B].RobotModelInfo.Coord.Y;
      RobotSimModBus_CoordModel.Z  := Common.TestModelInfo2[DefPocb.JIG_B].RobotModelInfo.Coord.Z;
      RobotSimModBus_CoordModel.Rx := Common.TestModelInfo2[DefPocb.JIG_B].RobotModelInfo.Coord.Rx;
      RobotSimModBus_CoordModel.Ry := Common.TestModelInfo2[DefPocb.JIG_B].RobotModelInfo.Coord.Ry;
      RobotSimModBus_CoordModel.Rz := Common.TestModelInfo2[DefPocb.JIG_B].RobotModelInfo.Coord.Rz;
    end;
  end;
{$ENDIF}
end;

function TRobotTM.GetModbusRobotStatus(var RobotStatus: TRobotStatus): Boolean;
var
  nTranId, nReadAddr, nReadCnt : Word;
  Data : array[0..(ROBOT_TM_MB_DATACNT_RobotStatus-1)] of Boolean;
begin
  Result := False;
  if not DongaRobot.m_bConnectedModbus[m_nRobot] then begin  //TBD?
    CodeSite.Send('#RobotCtl# ROBOT'+IntToStr(m_nRobot+1)+': RobotTM.GetModbusRobotStatus: Modbus Disconnected');
    Exit;
  end;
  //
  nTranId   := ROBOT_TM_TRANID_1_ROBOTSTATUS;
  nReadAddr := ROBOT_TM_MB_DEVADDR_RobotStatus;
  nReadCnt  := ROBOT_TM_MB_DATACNT_RobotStatus;
  if not ModBusReadInputBits(nTranId, nReadAddr, nReadCnt, Data) then begin
    CodeSite.Send('#RobotCtl# ROBOT'+IntToStr(m_nRobot+1)+': RobotTM.GetModbusRobotStatus: ModBusReadInputBits Failed');
    Exit;
  end;
  //
  RobotStatus.FatalError     := Data[ROBOT_TM_MB_RobotStatus1_FatalError];
  RobotStatus.ProjectRunning := Data[ROBOT_TM_MB_RobotStatus1_ProjectRunning];
  RobotStatus.ProjectEditing := Data[ROBOT_TM_MB_RobotStatus1_ProjectEditing];
  RobotStatus.ProjectPause   := Data[ROBOT_TM_MB_RobotStatus1_ProjectPause];
  RobotStatus.GetControl     := Data[ROBOT_TM_MB_RobotStatus1_GetControl];
//RobotStatus.CameraLight    := Data[ROBOT_TM_MB_RobotStatus1_CameraLight];
//RobotStatus.SafetyIO       := Data[ROBOT_TM_MB_RobotStatus1_SafetyIO];
  RobotStatus.EStop          := Data[ROBOT_TM_MB_RobotStatus1_EStop];
  //
//RobotStatus.AutoRemoteEnable := Data[ROBOT_TM_MB_RobotStatus2_AutoRemoteEnabla];
//RobotStatus.AutoRemoteActive := Data[ROBOT_TM_MB_RobotStatus2_AutoRemoteActiva];
//RobotStatus.SpeedAdjEnable   := Data[ROBOT_TM_MB_RobotStatus2_SpeedAdjEnabla];
  //
  Result := True;
end;

function TRobotTM.GetModbusRobotExtra(var RobotExtra: TRobotExtra): Boolean;
var
  nTranId, nReadAddr, nReadCnt : Word;
  Data : array[0..(ROBOT_TM_MB_DATACNT_RobotExtra-1)] of Boolean;
begin
  Result := False;
  if not DongaRobot.m_bConnectedModbus[m_nRobot] then begin  //TBD?
    CodeSite.Send('#RobotCtl# ROBOT'+IntToStr(m_nRobot+1)+': RobotTM.GetModbusRobotStatus: Modbus Disconnected');
    Exit;
  end;
  //
  nTranId   := ROBOT_TM_TRANID_5_ROBOTEXTRA;
  nReadAddr := ROBOT_TM_MB_DEVADDR_RobotExtra;
  nReadCnt  := ROBOT_TM_MB_DATACNT_RobotExtra;
  if not ModBusReadCoils(nTranId, nReadAddr, nReadCnt, Data) then begin
    CodeSite.Send('#RobotCtl# ROBOT'+IntToStr(m_nRobot+1)+': RobotTM.GetModbusRobotStatus: ModBusReadCoils Failed');
    Exit;
  end;
  //
  RobotExtra.CannotMove := Data[ROBOT_TM_MB_RobotEatra_00_CannoMove];
  //
  Result := True;
end;

//
function TRobotTM.GetModbusRobotCoord(var RobotCoord: TRobotCoord): Boolean;
var
  nTranId, nReadAddr, nReadCnt : Word;
  Data    : array[0..11] of Word;
  nSingle : TSingleWordsBytes;
begin
  Result := False;
  if not DongaRobot.m_bConnectedModbus[m_nRobot] then begin
    CodeSite.Send('#RobotCtl# ROBOT'+IntToStr(m_nRobot+1)+': RobotTM.GetModbusRobotCoord: Modbus Disconnected');
    Exit;
  end;
  //
  nTranId := ROBOT_TM_TRANID_2_ROBOTCOORD;
  nReadAddr := ROBOT_TM_MB_DEVADDR_RobotCoord;
  nReadCnt  := ROBOT_TM_MB_DATACNT_RobotCoord * 2; // Single# -> Word#
  if not ModbusReadInputRegisters(nTranId, nReadAddr, nReadCnt, Data) then begin
    CodeSite.Send('#RobotCtl# ROBOT'+IntToStr(m_nRobot+1)+': RobotTM.GetModbusRobotCoord: ModbusReadInputRegisters Failed');
    Exit;
  end;
  //
  nSingle.dabWords[1] := Data[ROBOT_TM_MB_RobotCoord_X*2];
  nSingle.dabWords[0] := Data[ROBOT_TM_MB_RobotCoord_X*2+1];
  RobotCoord.X := nSingle.dabSingle;
  nSingle.dabWords[1] := Data[ROBOT_TM_MB_RobotCoord_Y*2];
  nSingle.dabWords[0] := Data[ROBOT_TM_MB_RobotCoord_Y*2+1];
  RobotCoord.Y := nSingle.dabSingle;
  nSingle.dabWords[1] := Data[ROBOT_TM_MB_RobotCoord_Z*2];
  nSingle.dabWords[0] := Data[ROBOT_TM_MB_RobotCoord_Z*2+1];
  RobotCoord.Z := nSingle.dabSingle;
  nSingle.dabWords[1] := Data[ROBOT_TM_MB_RobotCoord_Rx*2];
  nSingle.dabWords[0] := Data[ROBOT_TM_MB_RobotCoord_Rx*2+1];
  RobotCoord.Rx := nSingle.dabSingle;
  nSingle.dabWords[1] := Data[ROBOT_TM_MB_RobotCoord_Ry*2];
  nSingle.dabWords[0] := Data[ROBOT_TM_MB_RobotCoord_Ry*2+1];
  RobotCoord.Ry := nSingle.dabSingle;
  nSingle.dabWords[1] := Data[ROBOT_TM_MB_RobotCoord_Rz*2];
  nSingle.dabWords[0] := Data[ROBOT_TM_MB_RobotCoord_Rz*2+1];
  RobotCoord.Rz := nSingle.dabSingle;
  //
  Result := True;
end;

//
function TRobotTM.GetModbusRunSpeedMode(var RunSpeed: UInt16; var RunMode: UInt16): Boolean;
var
  nTranId, nReadAddr, nReadCnt : Word;
  Data : array[0..1] of Word;
begin
  Result := False;
  if not DongaRobot.m_bConnectedModbus[m_nRobot] then begin
    CodeSite.Send('#RobotCtl# ROBOT'+IntToStr(m_nRobot+1)+': RobotTM.GetModbusRunSpeedMode: Modbus Disconnected');
    Exit;
  end;
  //
  nTranId   := ROBOT_TM_TRANID_3_ROBOTSPEED;
  nReadAddr := ROBOT_TM_MB_DEVADDR_RunSpeedMode;
  nReadCnt  := ROBOT_TM_MB_DATACNT_RunSpeedMode;
  if not ModBusReadInputRegisters(nTranId, nReadAddr, nReadCnt, Data) then begin
    CodeSite.Send('#RobotCtl# ROBOT'+IntToStr(m_nRobot+1)+': RobotTM.GetModbusRunSpeedMode: ModbusReadInputRegisters Failed');
    Exit;
  end;
  //
  RunSpeed := Data[0]; // ROBOT_TM_MB_RunSpeedMode_Speed
  RunMode  := Data[1]; // ROBOT_TM_MB_RunSpeedMode_Mode
  //
  Result := True;
end;

//
function TRobotTM.GetModbusRobotLight(var RobotLight: UInt16): Boolean;  //TBD:ROBOT?
var
  nTranId, nReadAddr, nReadCnt : Word;
  Data : array[0..0] of Word;
begin
  Result := False;
  if not DongaRobot.m_bConnectedModbus[m_nRobot] then begin
    CodeSite.Send('#RobotCtl# ROBOT'+IntToStr(m_nRobot+1)+': RobotTM.GetModbusRobotLight: Modbus Disconnected');
    Exit;
  end;
  //
  nTranId   := ROBOT_TM_TRANID_4_ROBOTLIGHT;
  nReadAddr := ROBOT_TM_MB_DEVADDR_RobotLight;
  nReadCnt  := ROBOT_TM_MB_DATACNT_RobotLight;
  if not ModBusReadInputRegisters(nTranId, nReadAddr, nReadCnt, Data) then begin
    CodeSite.Send('#RobotCtl# ROBOT'+IntToStr(m_nRobot+1)+': RobotTM.GetModbusRobotLight: ModBusReadInputRegisters Failed');
    Exit;
  end;
  //
  RobotLight := Data[0];
  //
  Result := True;
end;

//------------------------------------------------------------------------------
//
function TRobotTM.ModBusReadCoils(const nTranId: Word; const nReadAddr: Word; const nReadCnt: Word; out ReadData: array of Boolean): Boolean;
var
  i      : Integer;
  RxData : array of Word;
begin
  SetLength(RxData, nReadCnt);
  FillChar(RxData[0], Length(RxData), 0);
  // 
  Result := SendModbusCommand(nTranId, MODBUS_FC_01_ReadCoils, nReadAddr, nReadCnt, RxData);
  for i := 0 to (nReadCnt - 1) do
    ReadData[i] := (RxData[i] = 1);
end;

//
function TRobotTM.ModBusReadInputBits(const nTranId: Word; const nReadAddr: Word; const nReadCnt: Word; out ReadData: array of Boolean): Boolean;
var
  i      : Integer;
  RxData : array of Word;
begin
  SetLength(RxData, nReadCnt);
  FillChar(RxData[0], Length(RxData), 0);
  //
  Result := SendModbusCommand(nTranId, MODBUS_FC_02_ReadInputBits, nReadAddr, nReadCnt, RxData);
  for i := 0 to (nReadCnt - 1) do
    ReadData[i] := (RxData[i] = 1);
end;

//
function TRobotTM.ModBusReadHoldingRegisters(const nTranId: Word; const nReadAddr: Word; const nReadCnt: Word; out ReadData: array of Word): Boolean;
var
  i      : Integer;
  RxData : array of Word;
begin
  SetLength(RxData, nReadCnt);
  FillChar(RxData[0], Length(RxData), 0);
  Result := SendModbusCommand(nTranId, MODBUS_FC_03_ReadHoldingRegs, nReadAddr, nReadCnt, RxData);
  for i := Low(RxData) to High(RxData) do
    ReadData[i] := RxData[i];
end;

//
function TRobotTM.ModBusReadInputRegisters(const nTranId: Word; const nReadAddr: Word; const nReadCnt: Word; var ReadData: array of Word): Boolean;
begin
  FillChar(ReadData[0], Length(ReadData), 0);
  Result := SendModbusCommand(nTranId, MODBUS_FC_04_ReadInputRegs, nReadAddr, nReadCnt, ReadData);
end;

//
function TRobotTM.ModBusWriteOneCoil(const nTranId: Word; const nWriteAddr: Word; const bOn: Boolean): Boolean;
var
  TxData: array[0..0] of Word;
begin
  if bOn then TxData[0] := 1 else TxData[0] := 0;
  //
  Result := SendModbusCommand(nTranId, MODBUS_FC_05_WriteOneCoil, nWriteAddr, 0, TxData);
end;

//
function TRobotTM.ModBusWriteOneRegister(const nTranId: Word; const nWriteAddr: Word; const nValue: Word): Boolean;
var
  TxData: array[0..0] of Word;
begin
  TxData[0] := nValue;
  Result := SendModbusCommand(nTranId, MODBUS_FC_06_WriteOneReg, nWriteAddr, 1, TxData);
end;

//
function TRobotTM.ModBusWriteMultiCoils(const nTranId: Word; const nWriteAddr: Word; const nWriteCnt: Word; const WriteData: array of Boolean): Boolean;
var
  i      : Integer;
  TxLen  : Integer;
  TxData : array of Word;
begin
  TxLen := High(WriteData) - Low(WriteData) + 1;
  //
  SetLength(TxData, Length(WriteData));
  for i := Low(WriteData) to High(WriteData) do begin
    if WriteData[i] then
      TxData[i] := 1
    else
      TxData[i] := 0;
  end;
  Result := SendModbusCommand(nTranId, MODBUS_FC_15_WriteMultiCoils, nWriteAddr, TxLen, TxData);
end;

//
function TRobotTM.ModBusWriteMultiRegisters(const nTranId: Word; const nWriteAddr: Word; const nWriteCnt: Word; const WriteData: array of Word): Boolean;
var
  i      : Integer;
  TxLen  : Integer;
  TxData : array of Word;
begin
  TxLen := High(WriteData) - Low(WriteData) + 1;
  //
  SetLength(TxData, Length(WriteData));
  for i := Low(WriteData) to High(WriteData) do
    TxData[i] := WriteData[i];
  Result := SendModbusCommand(nTranId, MODBUS_FC_16_WriteMultiRegs, nWriteAddr, TxLen, TxData);
end;

//==============================================================================
//
function TRobotTM.SendModbusCommand(const nTranId: Word; const btFuncCode: Byte; const nAddress: Word; const nCount: Word; var Data: array of Word): Boolean;
var
  dtTimeOut   : TDateTime;
  msecTimeout : Integer;
  sModbusCmd  : string;
  //
  TxRec : TModBusReqRec; // record
  TxBuf : TModBusPktBuf; // array of bytes
  RxRec : TModBusRspRec; // record
  RxBuf : TModBusPktBuf; // array of bytes
  nDataLen : Word;
//{$IFDEF DMB_INDY10}
  TxBuffer : TIdBytes;
  RxBuffer : TIdBytes;
  iSize: Integer;
//{$ENDIF}
begin
  Result     := False;
  sModbusCmd := Format('(TranID=%d,FC=%d,Addr=0x%04x,Count=%d)',[nTranId,btFuncCode,nAddress,nCount]);
  //
  try
{$IFNDEF SIMULATOR_ROBOT}
    if DongaRobot.m_bConnectedModbus[m_nRobot] and DongaRobot.ModbusClients[m_nRobot].Connected then
      DongaRobot.ModbusClients[m_nRobot].CheckForGracefulDisconnect(True);  //TBD:A2CHv3:ROBOT?
{$ELSE}
    if DongaRobot.m_bConnectedModbus[m_nRobot] {and DongaRobot.ModbusClients[m_nRobot].Connected} then
      DongaRobot.ModbusClients[m_nRobot].CheckForGracefulDisconnect(True);  //TBD:A2CHv3:ROBOT?
{$ENDIF}
  except
    CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.SendModbusCommand'+sModBusCmd+'): ModBus Not Connected');
    Exit;  //TBD:A2CHv3:ROBOT?
  end;

  //---------------------------------------------- ModBus Header
  TxRec.Header.TranID  := nTranId;              // ModBus Header - Transaction ID
  TxBuf[MODBUS_PKTBUF_IDX_TRANID+0]  := Byte((TxRec.Header.TranID shr 8) and $FF);
  TxBuf[MODBUS_PKTBUF_IDX_TRANID+1]  := Byte(TxRec.Header.TranID and $FF);
  TxRec.Header.ProtoID := MODBUS_PROTOCOLID_0;  // ModBus Header - Protocol ID
  TxBuf[MODBUS_PKTBUF_IDX_PROTOID+0] := Byte((TxRec.Header.ProtoID shr 8) and $FF);
  TxBuf[MODBUS_PKTBUF_IDX_PROTOID+1] := Byte(TxRec.Header.ProtoID and $FF);
  TxRec.Header.ProtoID := MODBUS_PROTOCOLID_0;  // ModBus Header - Protocol ID
  TxRec.Header.Length  := 0;
//TxBuf[MODBUS_PKTBUF_IDX_LENGTH+0]  := Byte((??? shr 8) and $FF);
//TxBuf[MODBUS_PKTBUF_IDX_LENGTH+1]  := Byte(??? and $FF);
  TxRec.Header.UnitID  := MODBUS_UNITID_1;      // ModBus Header - Unit ID
  TxBuf[MODBUS_PKTBUF_IDX_UNITID]    := Byte(TxRec.Header.UnitID and $FF);

  //---------------------------------------------- ModBus PDU
  TxRec.PduFuncCode := Byte(btFuncCode);        // ModBus PDU - FunctionCode
  TxBuf[MODBUS_PKTBUF_IDX_PDU_FC] := Byte(TxRec.PduFuncCode and $FF);
  //
  nDataLen := nCount;
  case btFuncCode of                            // ModBus PDU - Data
    //--------------------------------------------
    MODBUS_FC_01_ReadCoils,
    MODBUS_FC_02_ReadInputBits: begin
      if (nDataLen > MODBUS_MAX_COILS) then nDataLen := MODBUS_MAX_COILS;
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0] := Hi(nAddress);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1] := Lo(nAddress);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2] := Hi(nDataLen);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3] := Lo(nDataLen);
      TxRec.PduData[0] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0];
      TxRec.PduData[1] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1];
      TxRec.PduData[2] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2];
      TxRec.PduData[3] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3];
      //
      TxRec.Header.Length := 6;  // Header.UnitID(1)+FunctionCode(1)+PDUData(4)
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+0] := Byte((TxRec.Header.Length shr 8) and $FF);
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+1] := Byte(TxRec.Header.Length and $FF);
    end;
    //--------------------------------------------
    MODBUS_FC_03_ReadHoldingRegs,
    MODBUS_FC_04_ReadInputRegs: begin
      if (nDataLen > MODBUS_MAX_REGISTERS) then nDataLen := MODBUS_MAX_REGISTERS;
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0] := Hi(nAddress);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1] := Lo(nAddress);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2] := Hi(nDataLen); // # of Registers (1~125)
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3] := Lo(nDataLen);
      TxRec.PduData[0] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0];
      TxRec.PduData[1] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1];
      TxRec.PduData[2] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2];
      TxRec.PduData[3] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3];
      //
      TxRec.Header.Length := 6;  // Header.UnitID(1)+FunctionCode(1)+PDUData(4)
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+0] := Byte((TxRec.Header.Length shr 8) and $FF);
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+1] := Byte(TxRec.Header.Length and $FF);
    end;
    //--------------------------------------------
    MODBUS_FC_05_WriteOneCoil: begin
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0] := Hi(nAddress);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1] := Lo(nAddress);
      if (Data[0] <> 0) then TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2] := $FF else TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2] := $00; // ON(0xFF00), OFF(0x0000)
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3] := $00;
      TxRec.PduData[0] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0];
      TxRec.PduData[1] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1];
      TxRec.PduData[2] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2];
      TxRec.PduData[3] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3];
      //
      TxRec.Header.Length := 6;  // Header.UnitID(1)+FunctionCode(1)+PDUData(4)
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+0] := Byte((TxRec.Header.Length shr 8) and $FF);
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+1] := Byte(TxRec.Header.Length and $FF);
    end;
    //--------------------------------------------
    MODBUS_FC_06_WriteOneReg: begin
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0] := Hi(nAddress);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1] := Lo(nAddress);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2] := Hi(Data[0]);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3] := Lo(Data[0]);
      TxRec.PduData[0] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0];
      TxRec.PduData[1] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1];
      TxRec.PduData[2] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2];
      TxRec.PduData[3] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3];
      //
      TxRec.Header.Length := 6;  // Header.UnitID(1)+FunctionCode(1)+PDUData(4)
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+0] := Byte((TxRec.Header.Length shr 8) and $FF);
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+1] := Byte(TxRec.Header.Length and $FF);
    end;
    //--------------------------------------------
    MODBUS_FC_15_WriteMultiCoils: begin
      if (Length(Data) < ((nDataLen div 16) - 1)) or (Length(Data) = 0) or (nDataLen = 0) then begin //TBD?
      //raise Exception.Create('PutCoilsIntoBuffer: Data array length cannot be less then Count');
        CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.SendModbusCommand'+sModBusCmd+'): FC_15_WriteMultiCoils: Data array length error');
        Exit;
      end;
      //
      if (nDataLen > 1968) then nDataLen := 1968; //TBD:ROBOT? 1698?
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0] := Hi(nAddress);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1] := Lo(nAddress);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2] := Hi(nDataLen);  // # of Output Bits
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3] := Lo(nDataLen);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+4] := Byte((nDataLen + 7) div 8);  // Byte Count
      TxRec.PduData[0] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0];
      TxRec.PduData[1] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1];
      TxRec.PduData[2] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2];
      TxRec.PduData[3] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3];
      TxRec.PduData[4] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+4];
      ModbusPutCoilsIntoBuffer(@TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+5], nDataLen, Data);
      //
      TxRec.Header.Length := 7 + TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+4]; // Header.UnitID(1)+FunctionCode(1)+PDUData(5+PduData[4])
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+0] := Byte((TxRec.Header.Length shr 8) and $FF);
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+1] := Byte(TxRec.Header.Length and $FF);
    end;
    //--------------------------------------------
    MODBUS_FC_16_WriteMultiRegs: begin
      if (Length(Data) < (nDataLen - 1)) or (Length(Data) = 0) or (nDataLen = 0) then begin  //TBD?
      //raise Exception.Create('PutRegistersIntoBuffer: Data array length cannot be less then Count');
        CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.SendModbusCommand'+sModBusCmd+'): FC_16_WriteMultiRegs: Data array length error');
        Exit;
      end;
      if (nDataLen > 120) then nDataLen := 120; //TBD:ROBOT? 120?
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0] := Hi(nAddress);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1] := Lo(nAddress);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2] := Hi(nDataLen);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3] := Lo(nDataLen);
      TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+4] := Byte(nDataLen shl 1); // Byte count
      TxRec.PduData[0] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0];
      TxRec.PduData[1] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1];
      TxRec.PduData[2] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2];
      TxRec.PduData[3] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3];
      TxRec.PduData[4] := TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+4];
      ModbusPutRegistersIntoBuffer(@TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+5], nDataLen, Data);
      //
      TxRec.Header.Length := 7 + TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+4]; // Header.UnitID(1)+FunctionCode(1)+PDUData(5+PduData[4])
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+0] := Byte((TxRec.Header.Length shr 8) and $FF);
      TxBuf[MODBUS_PKTBUF_IDX_LENGTH+1] := Byte(TxRec.Header.Length and $FF);
    end;
    //--------------------------------------------
    ELSE begin
      CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.SendModbusCommand'+sModBusCmd+'): TX Unknown_FC');
      //TBD:ROBOT?
      Exit;
    end;
  end;

  // Writeout the data to the connection
  with DongaRobot do begin
    try
      TxBuffer := RawToBytes(TxBuf, MODBUS_PKTBUF_IDX_UNITID + TxRec.Header.Length);
      try
        ModbusClients[m_nRobot].IOHandler.WriteDirect(TxBuffer);  //TBD:ROBOT?
        //
      //ModbusClients[m_nRobot].IOHandler.WriteBufferOpen;
      //ModbusClients[m_nRobot].IOHandler.WriteBufferFlush;
      //ModbusClients[m_nRobot].IOHandler.Write(TxBuf, MODBUS_PKTBUF_IDX_UNITID + TxRec.Header.Length);
      //ModbusClients[m_nRobot].IOHandler.WriteBufferClose;
      //
      //ModbusClients[m_nRobot].IOHandler.WriteBuffer(TxBuf, MODBUS_PKTBUF_IDX_UNITID + TxRec.Header.Length);
      except
        ModbusClients[m_nRobot].IOHandler.WriteBufferCancel;
      end;
    except
      CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.SendModbusCommand'+sModBusCmd+'): TX Write Error');
      //TBD:ROBOT?
      Exit;
    end;
  end;

{$IFDEF SIMULATOR_ROBOT}
  SetLength(RxBuffer,300);
  SimRobotModbus(TxBuf, RxBuffer);
  iSize := (RxBuffer[4] shl 8) + RxBuffer[5] + 6;
  Move(RxBuffer[0], RxBuf, iSize);
//CopyMemory(@RxBuf, @RxBuffer[0], iSize);
{$ELSE}
  // Wait for data from the ModBus Server
  try
    msecTimeout := DefRobot.ROBOT_MODBUS_RESPWAIT_TIMEMSEC;
  //if (FTimeOut > 0) then begin //TBD:ROBOT?
    if (msecTimeout > 0) then begin //TBD:ROBOT?
      dtTimeOut := Now + (msecTimeout / 86400000);
      while (DongaRobot.ModbusClients[m_nRobot].IOHandler.InputBuffer.Size = 0) do begin
      //DongaRobot.ModbusClients[m_nRobot].IOHandler.CheckForDataOnSource(FReadTimeout);
        DongaRobot.ModbusClients[m_nRobot].IOHandler.CheckForDataOnSource(1);
        if (Now > dtTimeOut) then begin
          CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.SendModbusCommand'+sModBusCmd+'): RX Ack Timeout');
          //TBD:ROBOT?
          Exit;
        end;
      end;
    end;
    iSize := DongaRobot.ModbusClients[m_nRobot].IOHandler.InputBuffer.Size;
    DongaRobot.ModbusClients[m_nRobot].IOHandler.ReadBytes(RxBuffer, iSize);
    Move(RxBuffer[0], RxBuf, iSize);
  except
    CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.SendModbusCommand'+sModBusCmd+'): RX Read Error');
    //TBD:ROBOT?
    Exit;
  end;
{$ENDIF}
  Result := True;
  // Check if the result has the same function code as the request
  if (btFuncCode = RxBuf[MODBUS_PKTBUF_IDX_PDU_FC]) then begin
    case btFuncCode of
      //--------------------------------------------
      MODBUS_FC_01_ReadCoils,
      MODBUS_FC_02_ReadInputBits: begin
        nDataLen := RxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0] * 8; // # of Byte --> # of Coils
        if (nDataLen > MODBUS_MAX_COILS) then nDataLen := MODBUS_MAX_COILS;
        ModbusGetCoilsFromBuffer(@RxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1], nDataLen, Data);
      end;
      //--------------------------------------------
      MODBUS_FC_03_ReadHoldingRegs,
      MODBUS_FC_04_ReadInputRegs: begin
        nDataLen := (RxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0] shr 1); // # of bytes --> # of Words
        if (nDataLen > MODBUS_MAX_REGISTERS) then nDataLen := MODBUS_MAX_REGISTERS;
        ModbusGetRegistersFromBuffer(@RxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1], nDataLen, Data);
      end;
      //--------------------------------------------
      ELSE begin
        CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.SendModbusCommand'+sModBusCmd+'): RX: Unknown FC');
        Result := False; //TBD?
      end;
    end;
  end
  else begin
    CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.SendModbusCommand'+sModBusCmd+'): TX.FC <> RX.FC');
    //if ((btFuncCode or $80) = RxBuf.PduFuncCode) then
      //DoResponseError(btFuncCode, RxBuf.PDUData[0], RxBuf)  //TBD:ROBOT?
    //else
      //DoResponseMismatch(btFuncCode, RxBuf.FunctionCode, RxBuf); //TBD:ROBOT?
    Result := False;
  end;
end;

//
{
function TRobotTM.Swap16(const DataToSwap: Word): Word;
begin
  Result := (DataToSwap div 256) + ((DataToSwap mod 256) * 256);
end;
}

//
procedure TRobotTM.ModBusGetCoilsFromBuffer(const Buffer: PByte; const Count: Word; var Data: array of Word);
var
  BytePtr: PByte;
  BitMask: Byte;
  i: Integer;
begin
  if (Length(Data) < ((Count div 16) - 1)) or (Length(Data) = 0) or (Count = 0) then begin
  //raise Exception.Create('GetCoilsFromBuffer: Data array length cannot be less then Count');
    CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.ModBusGetCoilsFromBuffer: Data array length cannot be less then Count');
    Exit;
  end;

  BytePtr := Buffer;
  BitMask := 1;

  for i := 0 to (Count - 1) do
  begin
    if (i < Length(Data)) then
    begin
      if ((BytePtr^ and BitMask) <> 0) then
        Data[i] := 1
      else
        Data[i] := 0;
      if (BitMask = $80) then
      begin
        BitMask := 1;
        Inc(BytePtr);
      end
      else
        BitMask := (Bitmask shl 1);
    end;
  end;
end;

procedure TRobotTM.ModbusPutCoilsIntoBuffer(const Buffer: PByte; const Count: Word; const Data: array of Word);
var
  BytePtr: PByte;
  BitMask: Byte;
  i: Word;
begin
  if (Length(Data) < ((Count div 16) - 1)) or (Length(Data) = 0) or (Count = 0) then begin
  //raise Exception.Create('PutCoilsIntoBuffer: Data array length cannot be less then Count');
    CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.ModbusPutCoilsIntoBuffer: Data array length cannot be less then Count');
    Exit;
  end;

  BytePtr := Buffer;
  BitMask := 1;
  for i := 0 to (Count - 1) do
  begin
    if (i < Length(Data)) then
    begin
      if (BitMask = 1) then
        BytePtr^ := 0;
      if (Data[i] <> 0) then
        BytePtr^ := BytePtr^ or BitMask;
      if (BitMask = $80) then
      begin
        BitMask := 1;
        Inc(BytePtr);
      end
      else
        BitMask := (Bitmask shl 1);
    end;
  end;
end;

//
procedure TRobotTM.ModBusGetRegistersFromBuffer(const Buffer: PWord; const Count: Word; var Data: array of Word);
var
  WordPtr: PWord;
  i: Word;
begin
  if (Length(Data) < (Count - 1)) or (Length(Data) = 0) or (Count = 0) then begin
  //raise Exception.Create('GetRegistersFromBuffer: Data array length cannot be less then Count');
    CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.ModBusGetRegistersFromBuffer: Data array length cannot be less then Count');
    Exit;
  end;

  WordPtr := Buffer;
  for i := 0 to (Count - 1) do begin
    Data[i] := ((WordPtr^ and $FF) shl 8) + (WordPtr^ shr 8);
    Inc(WordPtr);
  end;
end;

procedure TRobotTM.ModbusPutRegistersIntoBuffer(const Buffer: PWord; const Count: Word; const Data: array of Word);
var
  WordPtr: PWord;
  i: Word;
begin
  if (Length(Data) < (Count - 1)) or (Length(Data) = 0) or (Count = 0) then begin
  //raise Exception.Create('PutRegistersIntoBuffer: Data array length cannot be less then Count');
    CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.ModbusPutRegistersIntoBuffer: Data array length cannot be less then Count');
    Exit;
  end;

  WordPtr := Buffer;
  for i := 0 to (Count - 1) do begin
    WordPtr^ := ((Data[i] and $FF) shl 8) + (Data[i] shr 8);
    Inc(WordPtr);
  end;
end;

{
//
procedure TRobotTM.ModBusDoResponseError(const FunctionCode: Byte; const ErrorCode: Byte;
  const ResponseBuffer: TModBusResponseBuffer);
begin
  if Assigned(FOnResponseError) then
    FOnResponseError(FunctionCode, ErrorCode, ResponseBuffer);
end;

//
procedure TRobotTM.ModBusDoResponseMismatch(const RequestFunctionCode: Byte;
  const ResponseFunctionCode: Byte; const ResponseBuffer: TModBusResponseBuffer);
begin
  if Assigned(FOnResponseMismatch) then
    FOnResponseMismatch(RequestFunctionCode, ResponseFunctionCode, ResponseBuffer);
end;
}

//******************************************************************************
// procedure/function: TRobotTM - ListenNode(TCP Server) Command
//******************************************************************************

function TRobotTM.CheckRobotMovable(var sMsg: string; bStandbyCoord: Boolean = False): Boolean;  //TBD:A2CHv3:ROBOT? (CanMoveRobot)
var
  nCh, nRobot : Integer;
begin
  nCh    := m_nRobot;
  nRobot := m_nRobot;

  sMsg   := '';
  Result := False;

  // Check DIO - Doors  //REF(TDioCtl.IsDoorOpened)
  case nCh of
    DefPocb.CH_1: begin
      if ((DongaRobot.RobotDioIN and DefDio.MASK_IN_STAGE1_DOOR1_OPEN) <> 0) or ((DongaRobot.RobotDioIN and DefDio.MASK_IN_STAGE1_DOOR2_OPEN) <> 0) then begin
        sMsg := 'Check Doors';
        Exit;
      end;
    end;
    DefPocb.CH_2: begin
      if ((DongaRobot.RobotDioIN and DefDio.MASK_IN_STAGE2_DOOR1_OPEN) <> 0) and ((DongaRobot.RobotDioIN and DefDio.MASK_IN_STAGE2_DOOR2_OPEN) <> 0) then begin
        sMsg := 'Check Doors';
        Exit;
      end;
    end;
  end;

  {$IFDEF SUPPORT_1CG2PANEL}
  // Check CamZone Door|Partition //REF(TDioCtl.CheckCamZonePartDoor)
  if not bStandbyCoord then begin
    if not Common.SystemInfo.UseAssyPOCB then begin
      if ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_PARTITION_UP1) <> 0) or ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_PARTITION_UP2) <> 0) or
         ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_PARTITION_DOWN1) = 0) or ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_PARTITION_DOWN2) = 0) or
         ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_INNERT_DOOR_OPEN) <> 0) or ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_INNERT_DOOR_CLOSE) = 0) then begin
        sMsg := 'Check CamZone Partition and InnerDoor';
        Exit;
       end;
    end
    else begin
      if ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_PARTITION_UP1) = 0) or ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_PARTITION_UP2) = 0) or
         ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_PARTITION_DOWN1) <> 0) or ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_PARTITION_DOWN2) <> 0) or
         ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_INNERT_DOOR_OPEN) = 0) or ((DongaRobot.RobotDioIN and DefDio.MASK_IN_CAMZONE_INNERT_DOOR_CLOSE) <> 0) then begin
        sMsg := 'Check CamZone Partition and InnerDoor';
        Exit;
      end;
    end;
  end;
  {$ENDIF} //SUPPORT_1CG2PANEL

  // //REF(FrmMain.tmrAutoRobotMoveModelPos)
  if (not DongaRobot.m_bConnectedModbus[nRobot]) then begin
    sMsg := 'ModBus Disconnected';
    Exit;
  end;
  //
  if (not DongaRobot.Robot[nRobot].m_bModbusFirstReadDone) then begin
    sMsg := 'Robot Status Not Received';
    Exit;
  end;
  //
  with DongaRobot.Robot[nRobot].m_RobotStatusCoord do begin
    // Robot Status - FatalError
    if RobotStatus.FatalError then begin
      sMsg := 'Fatal Error';
      Exit;
    end;
    // Robot Status - EStop
    if RobotStatus.EStop then begin
      sMsg := 'E-STOP';
      Exit;
    end;
    // Robot Status - AutoMode/ManualMode
    if RunMode <> DefRobot.ROBOT_TM_MB_RUNMODE_AUTO then begin
      sMsg := 'Not AutoMode';
      Exit;
    end;
    // Robot Extra - CannotMove  //A2CHv3:2021-03-06
    if RobotExtra.CannotMove then begin
      sMsg := 'Cannot Move';
      Exit;
    end;
    //
    if RobotStatus.ProjectEditing then begin
      sMsg := 'Project Editing';
      Exit;
    end;
    //
    if RobotStatus.GetControl then begin
      sMsg := 'Not GetControl';
      Exit;
    end;
    //
    if (RobotLight <> ROBOT_TM_LIGHT_03_SolidBlue_StandbyInAutoMode) and (RobotLight <> ROBOT_TM_LIGHT_04_FlashingBlue_AutoMode) then begin
      sMsg := 'Neither StandbyInAutoMode Nor AutoMode';
      Exit;
    end;
    //
    if (not RobotStatus.ProjectRunning) or RobotStatus.ProjectPause then begin
      sMsg := 'Not Project Running';
      Exit;
    end;
    //
    if (not DongaRobot.m_bConnectedListenNode[nRobot]) then begin
      sMsg := 'Command ListenNode Disconnected';
      Exit;
    end;
    //
    if (not DongaRobot.Robot[nRobot].m_bListenNodeFirstReadyDone) then begin
      sMsg := 'Command ListenNode Not Ready';
      Exit;
    end;
  end;
  //
  Result := True;
end;

//
function TRobotTM.MoveJOG(RobotJog: TRobotJog; bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): Boolean;
var
  nMode : integer;
  nRet  : Integer;
  sMsg, sTemp : string;
  sCmd    : string;
  coord   : enumRobotCoordAttr;
  nValue  : Single;
  nCmdRet : DWORD;
begin
  nMode := DefPocb.MSG_MODE_ROBOT_MOVE_JOG;
  nRet  := DefPocb.ERR_ROBOT_MOVE_JOG;
  sMsg  := Format('<ROBOT> CH%d',[m_nRobot+1]);
  //
  Result := False;
  if RobotJog.bIsPlus then nValue := RobotJog.nDistance else nValue := (0 - RobotJog.nDistance);
  sMsg := sMsg +': MoveJOG ('+Common.GetRobotCoordAttrStr(RobotJog.nCoordAttr)+', '+FormatFloat(ROBOT_FORMAT_COORD2,nValue)+')';
  //
  if not CheckRobotMovable(sTemp) then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG('+sTemp+')');
    Exit;
  end;
  //
  SendRobotEvent(nMode,DefPocb.ERR_ROBOT_MOVE_START_OK,sMsg+' START ...Wait');
  sCmd := 'MOVE';  //TBD(ROBOT_TM:get relative move command string)?
  nCmdRet := ListenNodeCmdReq(sCmd, bCheckAck,nWaitMsec,nRetry);
  if nCmdRet <> WAIT_OBJECT_0 then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG');
    Exit;
  end;
  //
  sCmd := '';
  for coord := Coord_X to Coord_Rz do begin
    if (coord > Coord_X) then sCmd := sCmd + ',';
    if (coord = RobotJog.nCoordAttr) then sCmd := sCmd + FormatFloat(ROBOT_FORMAT_COORD2,nValue)
    else                                  sCmd := sCmd + FormatFloat(ROBOT_FORMAT_COORD2,0.0);
  end;
  nCmdRet := ListenNodeCmdReq(sCmd, bCheckAck,nWaitMsec,nRetry);
  if nCmdRet <> WAIT_OBJECT_0 then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG');
    Exit;
  end;
  //
  SendRobotEvent(nMode,DefPocb.ERR_OK,sMsg+' OK');
  Result := True;
end;

//
function TRobotTM.MoveRELATIVE(CoordRelative: TRobotCoord; bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): Boolean;
var
  nMode : integer;
  nRet   : Integer;
  sMsg, sTemp : string;
  sCmd: string;
  nCmdRet: DWORD;
begin
  nMode := DefPocb.MSG_MODE_ROBOT_MOVE_REL;
  nRet  := DefPocb.ERR_ROBOT_MOVE_REL;
  sMsg  := Format('<ROBOT> CH%d',[m_nRobot+1])+': MoveREL';
  //
  Result := False;
  //
  if not CheckRobotMovable(sTemp) then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG('+sTemp+')');
    Exit;
  end;
  //
  SendRobotEvent(nMode,DefPocb.ERR_ROBOT_MOVE_START_OK,sMsg+' START ...Wait');
  sCmd := 'MOVE';  //TBD(ROBOT_TM:get relative move command string)?
  nCmdRet := ListenNodeCmdReq(sCmd, bCheckAck,nWaitMsec,nRetry);
  if nCmdRet <> WAIT_OBJECT_0 then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG');
    Exit;
  end;
  //
  sCmd := FormatFloat(ROBOT_FORMAT_COORD2,CoordRelative.X);
  sCmd := sCmd + ',' + FormatFloat(ROBOT_FORMAT_COORD2,CoordRelative.Y);
  sCmd := sCmd + ',' + FormatFloat(ROBOT_FORMAT_COORD2,CoordRelative.Z);
  sCmd := sCmd + ',' + FormatFloat(ROBOT_FORMAT_COORD2,CoordRelative.Rx);
  sCmd := sCmd + ',' + FormatFloat(ROBOT_FORMAT_COORD2,CoordRelative.Ry);
  sCmd := sCmd + ',' + FormatFloat(ROBOT_FORMAT_COORD2,CoordRelative.Rz);
  //
  nCmdRet := ListenNodeCmdReq(sCmd, bCheckAck,nWaitMsec,nRetry);
  if nCmdRet <> WAIT_OBJECT_0 then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG');
    Exit;
  end;
  //
  SendRobotEvent(nMode,DefPocb.ERR_OK,sMsg+' OK');
  Result := True;
end;

//
function TRobotTM.MoveHOME(bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): Boolean;
var
  nMode : Integer;
  nRet  : Integer;
  sMsg, sTemp : string;
  sCmd  : string;
  nCmdRet : DWORD;
begin
  nMode := DefPocb.MSG_MODE_ROBOT_MOVE_TO_HOME;
  nRet  := DefPocb.ERR_ROBOT_MOVE_TO_HOME;
  sMsg  := Format('<ROBOT> CH%d',[m_nRobot+1])+': MoveHOME:';
  //
  Result := False;
  //
  if not CheckRobotMovable(sTemp) then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG('+sTemp+')');
    Exit;
  end;
  //
  SendRobotEvent(nMode,DefPocb.ERR_ROBOT_MOVE_START_OK,sMsg+' START ...Wait');
  sCmd := 'MUTING';  //TBD(ROBOT_TM:get home pos command string)?
  nCmdRet := ListenNodeCmdReq(sCmd, bCheckAck,nWaitMsec,nRetry);
  if nCmdRet <> WAIT_OBJECT_0 then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG');
    Exit;
  end;
  //
  SendRobotEvent(nMode,DefPocb.ERR_OK,sMsg+' OK');
  Result := True;
end;

//
function TRobotTM.MoveMODEL(bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): Boolean;
var
  nMode : Integer;
  nRet  : Integer;
  sMsg, sTemp : string;
  sCmd  : string;
  nCmdRet : DWORD;
begin
  nMode := DefPocb.MSG_MODE_ROBOT_MOVE_TO_MODEL;
  nRet  := DefPocb.ERR_ROBOT_MOVE_TO_MODEL;
  sMsg  := Format('<ROBOT> CH%d',[m_nRobot+1])+': MoveMODEL';
  //
  Result := False;
  //
  if not CheckRobotMovable(sTemp) then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG('+sTemp+')');
    Exit;
  end;
  //
  SendRobotEvent(nMode,DefPocb.ERR_ROBOT_MOVE_START_OK,sMsg+' START ...Wait');
  sCmd := Common.TestModelInfo2[m_nCh].RobotModelInfo.ModelCmd;
  if sCmd = '' then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG(MoveToModelCoord Command is NOT defined');
    Exit;
  end;
  //
  nCmdRet := ListenNodeCmdReq(sCmd, bCheckAck,nWaitMsec,nRetry);
  if nCmdRet <> WAIT_OBJECT_0 then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG');
    Exit;
  end;
  //
  SendRobotEvent(nMode,DefPocb.ERR_OK,sMsg+' OK');
  Result := True;
end;

//
function TRobotTM.MoveSTANDBY(bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): Boolean;
var
  nMode : Integer;
  nRet  : Integer;
  sMsg, sTemp : string;
  sCmd  : string;
  nCmdRet : DWORD;
begin
  nMode := DefPocb.MSG_MODE_ROBOT_MOVE_TO_STANDBY;
  nRet  := DefPocb.ERR_ROBOT_MOVE_TO_STANDBY;
  sMsg  := Format('<ROBOT> CH%d',[m_nRobot+1])+': MoveSTANDBY:';
  //
  Result := False;
  //
  if not CheckRobotMovable(sTemp,True{bStandbyCoord}) then begin  //bStandby
    SendRobotEvent(nMode,nRet,sMsg+' NG('+sTemp+')');
    Exit;
  end;
  //
  SendRobotEvent(nMode,DefPocb.ERR_ROBOT_MOVE_START_OK,sMsg+' START ...Wait');
  sCmd := 'STANDBY';
  nCmdRet := ListenNodeCmdReq(sCmd, bCheckAck,nWaitMsec*2,nRetry);  //2021-03-14
  if nCmdRet <> WAIT_OBJECT_0 then begin
    SendRobotEvent(nMode,nRet,sMsg+' NG');
    Exit;
  end;
  //
  SendRobotEvent(nMode,DefPocb.ERR_OK,sMsg+' OK');
  Result := True;
end;
//------------------------------------------------------------------------------
function TRobotTM.GetListenNodeCmdStr2CmdId(sCmd: string): Integer;
var
  nCmdId : Integer;
begin
  nCmdId := 0;
  if      sCmd = 'READY'   then nCmdId := ROBOT_TM_CMD_READY
  else if sCmd = 'MUTING'  then nCmdId := ROBOT_TM_CMD_MOVE_TO_HOME
  else if sCmd = Common.TestModelInfo2[m_nRobot].RobotModelInfo.ModelCmd then nCmdId := ROBOT_TM_CMD_MOVE_TO_MODEL  //TBD????
  else if sCmd = 'STANDBY' then nCmdId := ROBOT_TM_CMD_MOVE_TO_STANDBY
  else if sCmd = 'MOVE'    then nCmdId := ROBOT_TM_CMD_MOVE_COMMAND
  else begin
    if True then nCmdId := ROBOT_TM_CMD_MOVE_TO_RELCOORD;     //TBD:ROBOT? (,,,,,,)
  end;
  Result := nCmdId;
end;

//------------------------------------------------------------------------------
// procedure/function: RoboTM - ListenNodeServer Commands
//

function TRobotTM.ListenNodeCmdReq(sCmd: string; bCheckAck: Boolean=True; nWaitMsec: Integer=ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC; nRetry: Integer=0): DWORD;
var
  nCmdId : Integer;
begin
  Result := WAIT_FAILED;
  if (not DongaRobot.m_bConnectedListenNode[m_nRobot]) then begin
    CodeSite.Send('#RobotTM# '+m_sRobot+': RobotTM.ListenNodeCmdReq: ListenNode NOT Connected');
    Exit;
  end;

  //
  tmrCheckListenNode.Enabled := False;
  try
    nCmdId := GetListenNodeCmdStr2CmdId(sCmd); //TBD:ROBOT?
    if bCheckAck then begin
      //
      if (nCmdId = DefRobot.ROBOT_TM_CMD_READY) then begin
        if (tmrCheckModbus.Interval <> DefRobot.ROBOT_MODBUS_CONNCHECK_TIMEMSEC) then
          tmrCheckModbus.Interval := DefRobot.ROBOT_MODBUS_CONNCHECK_TIMEMSEC;
      end
      else begin
        if (tmrCheckModbus.Interval <> DefRobot.ROBOT_MODBUS_GETSTATUS_TIMEMSEC) then
          tmrCheckModbus.Enabled  := False;
          tmrCheckModbus.Interval := DefRobot.ROBOT_MODBUS_GETSTATUS_TIMEMSEC;
          tmrCheckModbus.Enabled  := True;
      end;
      //
      Result := CheckListenNodeCmdAck(procedure begin SendListenNodeCmd(sCmd); end, sCmd,nCmdId, nWaitMsec,nRetry);
    end
    else begin
      SendListenNodeCmd(sCmd); //TBD:ROBOT?
    end;
  finally
    tmrCheckListenNode.Enabled := True;
  end;
end;

function TRobotTM.SendListenNodeCmd(sCmd: string): Boolean;
var
  TxBuf    : TIdBytes;
  nErrCode : Integer;
  nSize, nCheckSum : Integer;
  sAnsiCmd : AnsiString;
  sDebug : string;
begin
  Result := False;
  //
  if DongaRobot.ListenNodePeerContext[m_nRobot] = nil then Exit; //TBD:ROBOT?
  //
  nSize := Length(sCmd);
  SetLength(TxBuf,nSize);
  sAnsiCmd := AnsiString(sCmd); //TBD? +#$00;
  CopyMemory(@TxBuf[0],@sAnsiCmd[1],nSize);
  try
    if (not m_bListenNodeFirstReadyDone) or (sCmd <> 'READY') then begin
      sDebug := '<ROBOT> '+m_sRobot+': ListenNode: TX('+string(sAnsiCmd)+')'; CodeSite.Send(sDebug);
    end;
    DongaRobot.ListenNodePeerContext[m_nRobot].Connection.IOHandler.Write(TxBuf,nSize);
  //DongaRobot.ListenNodePeerContext[m_nRobot].Connection.Socket.WriteDirect(TxBuf,nSize);
  except
    try
      Sleep(10); //TBD:ROBOT? 1000->10
      DongaRobot.ListenNodePeerContext[m_nRobot].Connection.IOHandler.Write(TxBuf,nSize);
    //DongaRobot.ListenNodePeerContext[m_nRobot].Connection.Socket.WriteDirect(TxBuf,nSize);
    except
      sDebug := '#ROBOT# '+m_sRobot+': ListenNode: TX('+string(sAnsiCmd)+') Failed'; CodeSite.Send(sDebug);
      Exit;
    end;
  end;
  //
//if FLogEnabled then
//  LogResponseBuffer(AContext, SendBuffer, Swap16(SendBuffer.Header.RecLength) + 6);
//end;
//if not Result then begin
//  SendError(AContext, mbeServerFailure, ReceiveBuffer);
//end;
  //--------------------------
  m_sListenNodeTxCmd := sCmd; //TBD:ROBOT?
  Result := True;
end;

function TRobotTM.CheckListenNodeCmdAck(Task: TProc; sCmd: string; nCmdId,nWaitMsec,nRetry: Integer): DWORD; //TBD(ROBOT?)
var
 nRet   : DWORD;
 i      : Integer;
 sEvent : WideString;
begin
  try
    nRet := WAIT_FAILED;
    //
    if m_bIsOnListenNodeCmd then begin
      CodeSite.Send('#RobotCtl# '+m_sRobot+': TRobotTM.CheckListenNodeCmdAck: m_bIsOnListenNodeCmd=True !!!');
      Exit;
    end;
    //
    m_bIsOnListenNodeCmd  := True;
    sEvent := Format('ROBOT%d:%s',[m_nRobot+1,sCmd]);
    m_hListenNodeCmdEvent := CreateEvent(nil, False, False, PWideChar(sEvent));
    //
    for i := 0 to nRetry do begin
    //if m_nStatusRobot in [pgForceStop,pgDisconn] then Break; //TBD:ROBOT?
      FTxListenNodeCmd.CmdId  := nCmdId;
      FTxListenNodeCmd.CmdStr := sCmd;
      FRxListenNodeAck.NgOrYes := DefRobot.LISTENNODE_CMD_ACK_FAIL; //TBD:ROBOT?
      Task;
    {$IFDEF SIMULATOR_ROBOT}
      SimRobotListenNode(sCmd); //TBD:ROBOT?
    {$ENDIF}
      nRet := WaitForSingleObject(m_hListenNodeCmdEvent,nWaitMsec);
      case nRet of
        WAIT_OBJECT_0 : begin
          if FRxListenNodeAck.NgOrYes = DefRobot.LISTENNODE_CMD_ACK_OK then begin
            nRet := WAIT_OBJECT_0;
            if nCmdId in [ROBOT_TM_CMD_MOVE_TO_HOME, ROBOT_TM_CMD_MOVE_TO_MODEL, ROBOT_TM_CMD_MOVE_TO_STANDBY] then begin
            //{$IFDEF SIMULATOR_ROBOT}
              if tmrCheckModbus.Enabled then OnCheckModbusTimer(nil); //2022-10-05
            //{$ENDIF}
              Sleep(400);
            end;
            Break;
          end;
        end;
        WAIT_TIMEOUT : begin
          nRet := LISTENNODE_CMD_ACK_TIMEOUT;
        end
        else begin
          nRet := WAIT_FAILED; //TBD:ROBOT?
          Break;
        end;
      end;
    end;
  finally
    CloseHandle(m_hListenNodeCmdEvent);
    m_bIsOnListenNodeCmd := False;
  end;
  Result := nRet;
end;

procedure TRobotTM.ReadListenNodeCmd(nRobot, nLen: Integer; ABuff: TidBytes);  //TBD:ROBOT?
var
  nDataSize : Integer;
  sRxData, sDebug : string;
  i, nCmdId : Integer;
begin
  if not (nRobot in [DefRobot.ROBOT_CH1..DefRobot.ROBOT_MAX]) then Exit;
  //
  nDataSize := nLen;
  sDebug := ''; sRxData := '';
  for i := 0 to Pred(nDataSize) do begin
    if ABuff[i] = 0 then Break;
    sRxData := sRxData + Char(ABuff[i]);
  end;
  //
  if (not m_bListenNodeFirstReadyDone) or (sRxData <> 'READY') then begin
    sDebug := '<ROBOT> ROBOT'+IntToStr(nRobot+1)+': ListenNode: RX('+sRxData+')'; CodeSite.Send(sDebug);
  end;
  //
  nCmdId := GetListenNodeCmdStr2CmdId(sRxData);
  if sRxData = 'FAIL' then begin
    FRxListenNodeAck.NgOrYes := LISTENNODE_CMD_ACK_FAIL;            ///TBD:ROBOT?
    FRxListenNodeAck.CmdId   := FTxListenNodeCmd.CmdId;  //TBD:ROBOT?
  end
  else begin
    FRxListenNodeAck.CmdId   := GetListenNodeCmdStr2CmdId(sRxData);
    FRxListenNodeAck.NgOrYes := LISTENNODE_CMD_ACK_OK;              ///TBD:ROBOT?
  end;
  // 
  case nCmdId of 
    ROBOT_TM_CMD_READY: begin
      if m_bIsOnListenNodeCmd then SetEvent(m_hListenNodeCmdEvent);
    end;
    ROBOT_TM_CMD_MOVE_TO_HOME: begin
      if m_bIsOnListenNodeCmd then SetEvent(m_hListenNodeCmdEvent);
    end;
    ROBOT_TM_CMD_MOVE_TO_MODEL: begin
      if m_bIsOnListenNodeCmd then SetEvent(m_hListenNodeCmdEvent);
    end;
    ROBOT_TM_CMD_MOVE_TO_STANDBY: begin
      if m_bIsOnListenNodeCmd then SetEvent(m_hListenNodeCmdEvent);
    end;
    ROBOT_TM_CMD_MOVE_COMMAND: begin
      if m_bIsOnListenNodeCmd then SetEvent(m_hListenNodeCmdEvent);
    end;
    ROBOT_TM_CMD_MOVE_TO_RELCOORD: begin
      if m_bIsOnListenNodeCmd then SetEvent(m_hListenNodeCmdEvent);
    end;
    else begin
      if m_bIsOnListenNodeCmd then SetEvent(m_hListenNodeCmdEvent);
    end;
  end;
end;

//******************************************************************************
// procedure/function: TRobotTM - Timer
//******************************************************************************

procedure TRobotTM.OnCheckModbusTimer(Sender: TObject);
var
  bGetOK : Boolean;
  bChangedRobotStatus, bChangedRobotCoord, bChangedRunSpeed, bChangedRunMode, bChangedRobotLight : Boolean;
  RobotStatusCoordTemp : TRobotStatusCoord;
  sTempChange, sMsg : string;
begin
  if DongaRobot.m_hTest[m_nRobot] = 0 then Exit;  // During Initial //TBD:ROBOT?
//CodeSite.Send('<RobotCtl> ROBOT'+m_sRobot+': RobotTM.OnModbusCheckTimer Expired');
  //
  tmrCheckModbus.Enabled := False;
  try
    if (not DongaRobot.m_bConnectedModbus[m_nRobot]) then begin
{$IFDEF OLD}
      try
        DongaRobot.ModbusClients[m_nRobot].Connect;
      except
      //CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnModbusCheckTimer: ModBus Client Connect Fail');
      end;
{$ENDIF}
      Common.ThreadTask(procedure begin  //TBD:A2CHv3:ROBOT?
        try
          if not DongaRobot.m_bConnectedModbus[m_nRobot] then begin
            DongaRobot.ModbusClients[m_nRobot].Disconnect; //2023-08-02
            Sleep(50);                                     //2023-08-02
            DongaRobot.ModbusClients[m_nRobot].Connect;
          end;
        except
        //CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnModbusCheckTimer: ModBus Client Connect Fail');
        end;
      end);
      Exit;
    end;
    //
    bGetOK := False; sTempChange := ''; sMsg := '';
    //-------------------------- Get Robot Status/Coord from MODBUS
    m_RobotStatusCoordOld := m_RobotStatusCoord;
    if GetModbusRobotStatus(RobotStatusCoordTemp.RobotStatus) then begin
      m_RobotStatusCoord.RobotStatus := RobotStatusCoordTemp.RobotStatus;
      bGetOK := True;
    end;
    if GetModbusRunSpeedMode(RobotStatusCoordTemp.RunSpeed,RobotStatusCoordTemp.RunMode) then begin
      m_RobotStatusCoord.RunSpeed := RobotStatusCoordTemp.RunSpeed;
      m_RobotStatusCoord.RunMode  := RobotStatusCoordTemp.RunMode;
      bGetOK := True;
    end;
    if GetModbusRobotLight(RobotStatusCoordTemp.RobotLight) then begin
      m_RobotStatusCoord.RobotLight  := RobotStatusCoordTemp.RobotLight;
      bGetOK := True;
    end;
  //if GetModebusRobotJoint then begin
    if GetModbusRobotCoord(RobotStatusCoordTemp.RobotCoord) then begin
      m_RobotStatusCoord.RobotCoord := RobotStatusCoordTemp.RobotCoord;
      bGetOK := True;
    end;
    if GetModbusRobotExtra(RobotStatusCoordTemp.RobotExtra) then begin
      m_RobotStatusCoord.RobotExtra := RobotStatusCoordTemp.RobotExtra;
      bGetOK := True;
    end;
    if not bGetOK then begin
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnModbusCheckTimer: GetModbusXXXXX All Failed');
      Inc(DongaRobot.m_bGetFailCntModbus[m_nRobot]);
      if DongaRobot.m_bGetFailCntModbus[m_nRobot] > 5 then begin //TBD:A2CHv3:ROBOT? (5)
{$IFDEF OLD}
        try
        //if DongaRobot.ModbusClients[m_nRobot].Connected then begin
            DongaRobot.ModbusClients[m_nRobot].Disconnect;
            sleep(5);
        //end;
          DongaRobot.ModbusClients[m_nRobot].Connect;
        except
          //
          DongaRobot.m_bConnectedModbus[m_nRobot]  := False; //before SendRobotEvent !!!
          DongaRobot.m_bGetFailCntModbus[m_nRobot] := 0;
          sMsg := '<ROBOT> CH'+IntToStr(m_nRobot+1)+': Modbus TCP-Client Disconnected !!!';
          DongaRobot.Robot[m_nRobot].SendRobotEvent(DefPocb.MSG_MODE_ROBOT_CONNECT_MODBUS, DefPocb.ERR_ROBOT_CONNECT, sMsg);
          CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnModbusCheckTimer: ModBus Client Re-Connect Failed');
        end;
{$ENDIF}
        Common.ThreadTask(procedure begin  //TBD:A2CHv3:ROBOT? (Thread?)
          try
            DongaRobot.ModbusClients[m_nRobot].Disconnect;
            sleep(50); //2023-08-02 (5->50)
            //
            DongaRobot.ModbusClients[m_nRobot].Connect;
          except
            DongaRobot.m_bConnectedModbus[m_nRobot]  := False; //before SendRobotEvent !!!
            DongaRobot.m_bGetFailCntModbus[m_nRobot] := 0;
            sMsg := '<ROBOT> CH'+IntToStr(m_nRobot+1)+': Modbus TCP-Client Disconnected !!!';
            DongaRobot.Robot[m_nRobot].SendRobotEvent(DefPocb.MSG_MODE_ROBOT_CONNECT_MODBUS, DefPocb.ERR_ROBOT_CONNECT, sMsg);
            CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnModbusCheckTimer: ModBus Client Re-Connect Failed');
          end;
        end);
      end;
      Exit;
    end;

    //-------------------------- Check if Robot Status/Coord is changed
    if (not m_bModbusFirstReadDone) then begin
      m_bModbusFirstReadDone := True;
      //TBD:ROBOT?
    end;

    //-------------------------- Check if Robot Status/Coord is changed
    bChangedRobotStatus := False;
    bChangedRobotCoord  := False;
    bChangedRunSpeed    := False;
    bChangedRunMode     := False;
    bChangedRobotLight  := False;
    // Robot Status
    if m_RobotStatusCoordOld.RobotStatus.FatalError <> m_RobotStatusCoord.RobotStatus.FatalError then begin
      bChangedRobotStatus := True;
      sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotStatus.FatalError)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotStatus.FatalError)+')';
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotStatus.FatalError Changed: '+sTempChange);
    end;
    if m_RobotStatusCoordOld.RobotStatus.ProjectRunning <> m_RobotStatusCoord.RobotStatus.ProjectRunning then begin
      bChangedRobotStatus := True;
      sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotStatus.ProjectRunning)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotStatus.ProjectRunning)+')';
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotStatus.ProjectRunning Changed: '+sTempChange);
    end;
    if m_RobotStatusCoordOld.RobotStatus.ProjectEditing <> m_RobotStatusCoord.RobotStatus.ProjectEditing then begin
      bChangedRobotStatus := True;
      sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotStatus.ProjectEditing)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotStatus.ProjectEditing)+')';
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotStatus.ProjectEditing Changed: '+sTempChange);
    end;
    if m_RobotStatusCoordOld.RobotStatus.ProjectPause <> m_RobotStatusCoord.RobotStatus.ProjectPause then begin
      bChangedRobotStatus := True;
      sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotStatus.ProjectPause)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotStatus.ProjectPause)+')';
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotStatus.ProjectPause Changed: '+sTempChange);
    end;
    if m_RobotStatusCoordOld.RobotStatus.GetControl <> m_RobotStatusCoord.RobotStatus.GetControl then begin
      bChangedRobotStatus := True;
      sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotStatus.GetControl)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotStatus.GetControl)+')';
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotStatus.GetControl Changed: '+sTempChange);
    end;
  //if m_RobotStatusCoordOld.RobotStatus.CameraLight <> m_RobotStatusCoord.RobotStatus.CameraLight then begin
  //  bChangedRobotStatus := True;
  //  sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotStatus.CameraLight)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotStatus.CameraLight)+')';
  //  CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotStatus.CameraLight Changed: '+sTempChange);
  //end;
  //if m_RobotStatusCoordOld.RobotStatus.SafetyIO <> m_RobotStatusCoord.RobotStatus.SafetyIO then begin
  //  bChangedRobotStatus := True;
  //  sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotStatus.SafetyIO)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotStatus.SafetyIO)+')';
  //  CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotStatus.SafetyIO Changed: '+sTempChange);
  //end;
    if m_RobotStatusCoordOld.RobotStatus.EStop <> m_RobotStatusCoord.RobotStatus.EStop then begin
      bChangedRobotStatus := True;
      sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotStatus.EStop)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotStatus.EStop)+')';
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotStatus.EStop Changed: '+sTempChange);
    end;
  //if m_RobotStatusCoordOld.RobotStatus.AutoRemoteEnable <> m_RobotStatusCoord.RobotStatus.AutoRemoteEnable then begin
  //  bChangedRobotStatus := True;
  //  sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotStatus.AutoRemoteEnable)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotStatus.AutoRemoteEnable)+')';
  //  CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotStatus.AutoRemoteEnable Changed: '+sTempChange);
  //end;
  //if m_RobotStatusCoordOld.RobotStatus.AutoRemoteActive <> m_RobotStatusCoord.RobotStatus.AutoRemoteActive then begin
  //  bChangedRobotStatus := True;
  //  sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotStatus.AutoRemoteActive)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotStatus.AutoRemoteActive)+')';
  //  CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotStatus.AutoRemoteActive Changed: '+sTempChange);
  //end;
  //if m_RobotStatusCoordOld.RobotStatus.SpeedAdjEnable <> m_RobotStatusCoord.RobotStatus.SpeedAdjEnable then begin
  //  bChangedRobotStatus := True;
  //  sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotStatus.SpeedAdjEnable)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotStatus.SpeedAdjEnable)+')';
  //  CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotStatus.SpeedAdjEnable Changed: '+sTempChange);
  //end;
    if m_RobotStatusCoordOld.RobotExtra.CannotMove <> m_RobotStatusCoord.RobotExtra.CannotMove then begin
      bChangedRobotStatus := True;
      sTempChange := 'OLD('+BoolToStr(m_RobotStatusCoordOld.RobotExtra.CannotMove)+') NEW('+BoolToStr(m_RobotStatusCoord.RobotExtra.CannotMove)+')';
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotExtra.CannotMove Changed: '+sTempChange);
    end;
    // Robot Coord
  //if (RobotMovingStop) then begin //TBG:ROBOT?
      if (not SameValue(m_RobotStatusCoordOld.RobotCoord.X,  m_RobotStatusCoord.RobotCoord.X,  0.01)) or
         (not SameValue(m_RobotStatusCoordOld.RobotCoord.Y,  m_RobotStatusCoord.RobotCoord.Y,  0.01)) or
         (not SameValue(m_RobotStatusCoordOld.RobotCoord.Z,  m_RobotStatusCoord.RobotCoord.Z,  0.01)) or
         (not SameValue(m_RobotStatusCoordOld.RobotCoord.Rx, m_RobotStatusCoord.RobotCoord.Rx, 0.01)) or
         (not SameValue(m_RobotStatusCoordOld.RobotCoord.Ry, m_RobotStatusCoord.RobotCoord.Ry, 0.01)) or
         (not SameValue(m_RobotStatusCoordOld.RobotCoord.Rz, m_RobotStatusCoord.RobotCoord.Rz, 0.01)) then begin
        bChangedRobotCoord := True;
        sTempChange := 'OLD('+FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoordOld.RobotCoord.X)+','
                             +FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoordOld.RobotCoord.Y)+','
                             +FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoordOld.RobotCoord.Z)+','
                             +FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoordOld.RobotCoord.Rx)+','
                             +FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoordOld.RobotCoord.Ry)+','
                             +FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoordOld.RobotCoord.Rz)+')';
        sTempChange := sTempChange +' NEW('+FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoord.RobotCoord.X)+','
                                           +FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoord.RobotCoord.Y)+','
                                           +FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoord.RobotCoord.Z)+','
                                           +FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoord.RobotCoord.Rx)+','
                                           +FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoord.RobotCoord.Ry)+','
                                           +FormatFloat(ROBOT_FORMAT_COORD,m_RobotStatusCoord.RobotCoord.Rz)+')';
      //CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotCoord Changed: '+sTempChange);
      end;
      if bChangedRobotCoord then begin
        m_RobotStatusCoordOld.CoordState := m_RobotStatusCoord.CoordState;
				//2023-08-02  Check if HOME -> Standby -> Model
        if (Abs(Common.RobotSysInfo.HomeCoord[m_nRobot].X  - m_RobotStatusCoord.RobotCoord.X) <= Common.RobotSysInfo.RobotCoordTolerance) and
                (Abs(Common.RobotSysInfo.HomeCoord[m_nRobot].Y  - m_RobotStatusCoord.RobotCoord.Y) <= Common.RobotSysInfo.RobotCoordTolerance) and
                (Abs(Common.RobotSysInfo.HomeCoord[m_nRobot].Z  - m_RobotStatusCoord.RobotCoord.Z) <= Common.RobotSysInfo.RobotCoordTolerance) and
                (Common.GetRobotCoordDiffRxRyRz(Common.RobotSysInfo.HomeCoord[m_nRobot].Rx, m_RobotStatusCoord.RobotCoord.Rx) <= Common.RobotSysInfo.RobotCoordTolerance) and
                (Common.GetRobotCoordDiffRxRyRz(Common.RobotSysInfo.HomeCoord[m_nRobot].Ry, m_RobotStatusCoord.RobotCoord.Ry) <= Common.RobotSysInfo.RobotCoordTolerance) and
                (Common.GetRobotCoordDiffRxRyRz(Common.RobotSysInfo.HomeCoord[m_nRobot].Rz, m_RobotStatusCoord.RobotCoord.Rz) <= Common.RobotSysInfo.RobotCoordTolerance) then begin
          if m_RobotStatusCoord.CoordState <> coordHome then begin
            m_RobotStatusCoord.CoordState := coordHome;
            CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotCoord: HOME');
          end;
        end
        else if (Abs(Common.RobotSysInfo.StandbyCoord[m_nRobot].X  - m_RobotStatusCoord.RobotCoord.X) <= Common.RobotSysInfo.RobotCoordTolerance) and
                (Abs(Common.RobotSysInfo.StandbyCoord[m_nRobot].Y  - m_RobotStatusCoord.RobotCoord.Y) <= Common.RobotSysInfo.RobotCoordTolerance) and
                (Abs(Common.RobotSysInfo.StandbyCoord[m_nRobot].Z  - m_RobotStatusCoord.RobotCoord.Z) <= Common.RobotSysInfo.RobotCoordTolerance) and
                (Common.GetRobotCoordDiffRxRyRz(Common.RobotSysInfo.StandbyCoord[m_nRobot].Rx, m_RobotStatusCoord.RobotCoord.Rx) <= Common.RobotSysInfo.RobotCoordTolerance) and
                (Common.GetRobotCoordDiffRxRyRz(Common.RobotSysInfo.StandbyCoord[m_nRobot].Ry, m_RobotStatusCoord.RobotCoord.Ry) <= Common.RobotSysInfo.RobotCoordTolerance) and
                (Common.GetRobotCoordDiffRxRyRz(Common.RobotSysInfo.StandbyCoord[m_nRobot].Rz, m_RobotStatusCoord.RobotCoord.Rz) <= Common.RobotSysInfo.RobotCoordTolerance) then begin
          if m_RobotStatusCoord.CoordState <> coordStandby then begin
            m_RobotStatusCoord.CoordState := coordStandby;
            CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotCoord: STANDBY');
          end;
        end
        else if (Abs(Common.TestModelInfo2[m_nRobot].RobotModelInfo.Coord.X  - m_RobotStatusCoord.RobotCoord.X)  <= Common.RobotSysInfo.RobotCoordTolerance) and
           (Abs(Common.TestModelInfo2[m_nRobot].RobotModelInfo.Coord.Y  - m_RobotStatusCoord.RobotCoord.Y)  <= Common.RobotSysInfo.RobotCoordTolerance) and
           (Abs(Common.TestModelInfo2[m_nRobot].RobotModelInfo.Coord.Z  - m_RobotStatusCoord.RobotCoord.Z)  <= Common.RobotSysInfo.RobotCoordTolerance) and
           (Common.GetRobotCoordDiffRxRyRz(Common.TestModelInfo2[m_nRobot].RobotModelInfo.Coord.Rx, m_RobotStatusCoord.RobotCoord.Rx) <= Common.RobotSysInfo.RobotCoordTolerance) and
           (Common.GetRobotCoordDiffRxRyRz(Common.TestModelInfo2[m_nRobot].RobotModelInfo.Coord.Ry, m_RobotStatusCoord.RobotCoord.Ry) <= Common.RobotSysInfo.RobotCoordTolerance) and
           (Common.GetRobotCoordDiffRxRyRz(Common.TestModelInfo2[m_nRobot].RobotModelInfo.Coord.Rz, m_RobotStatusCoord.RobotCoord.Rz) <= Common.RobotSysInfo.RobotCoordTolerance) then begin
          if m_RobotStatusCoord.CoordState <> coordModel then begin
            m_RobotStatusCoord.CoordState := coordModel;
            CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotCoord: MODEL');
          end;
        end
        else begin
          if m_RobotStatusCoord.CoordState <> coordUndefined then begin
            m_RobotStatusCoord.CoordState := coordUndefined;
            CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotCoord: Undefined');
          end;
        end;
      end;
  //end; // if RobotMovingStop) //TBG:ROBOT?
    // Robot RunSpeed
    if m_RobotStatusCoordOld.RunSpeed <> m_RobotStatusCoord.RunSpeed then begin
      bChangedRunSpeed := True;
      sTempChange := 'OLD('+IntToStr(m_RobotStatusCoordOld.RunSpeed)+') NEW('+IntToStr(m_RobotStatusCoord.RunSpeed)+')';
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RunSpeed Changed: '+sTempChange);
    end;
    // Robot RunMode
    if m_RobotStatusCoordOld.RunMode <> m_RobotStatusCoord.RunMode then begin
      bChangedRobotStatus := True;
      sTempChange := 'OLD('+IntToStr(m_RobotStatusCoordOld.RunMode)+') NEW('+IntToStr(m_RobotStatusCoord.RunMode)+')';
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RunMode Changed: '+sTempChange);
    end;
    // Robot RobotLight
    if m_RobotStatusCoordOld.RobotLight <> m_RobotStatusCoord.RobotLight then begin
      bChangedRobotLight := True;
      sTempChange := 'OLD('+IntToStr(m_RobotStatusCoordOld.RobotLight)+') NEW('+IntToStr(m_RobotStatusCoord.RobotLight)+')';
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotLight Changed: '+sTempChange);
    end;

    //-------------------------- if Robot Status/Coord is changed //TBD:ROBOT?
    if (bChangedRobotStatus or bChangedRunMode or bChangedRobotLight or bChangedRunSpeed) then begin       //TBD:ROBOT?
      DongaRobot.Robot[m_nRobot].SendRobotEvent(DefPocb.MSG_MODE_ROBOT_GET_STATUS, DefPocb.ERR_OK, ''); //TBD:ROBOT?
    end
    else if bChangedRobotCoord then begin
      if m_RobotStatusCoordOld.CoordState <> m_RobotStatusCoord.CoordState then begin
        case m_RobotStatusCoord.CoordState of
          coordHome: begin
            SendMainGuiRobotDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,DefPocb.MSG_MODE_ROBOT_HOME_COORD,DefPocb.ERR_OK,'');
            m_bHomeDone := True;
          end;
          coordModel: begin
            SendMainGuiRobotDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,DefPocb.MSG_MODE_ROBOT_MODEL_COORD,DefPocb.ERR_OK,'');
            m_bHomeDone := True;
          end;
          coordStandby: begin
            SendMainGuiRobotDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,DefPocb.MSG_MODE_ROBOT_STANDBY_COORD,DefPocb.ERR_OK,'');
            m_bHomeDone := False;
          end;
          else begin //TBD:ROBOT?
            CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotCoord Changed(not HOME/MODEL) ...TBD');
          //m_bHomeDone := False;
          end;
        end;
      end;
      SendTestGuiRobotDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,'');
      if (DongaRobot.FMaintRobotUse and Assigned(DongaRobot.MaintRobotStatus)) then
        DongaRobot.MaintRobotStatus(m_nRobot,DefPocb.MSG_MODE_ROBOT_GET_COORD,DefPocb.ERR_OK,'');
    end;
  finally
    tmrCheckModbus.Enabled := True;
  end;
end;

procedure TRobotTM.OnCheckListenNodeTimer(Sender: TObject);
begin
  if DongaRobot.m_hTest[m_nRobot] = 0 then Exit;
  if (not DongaRobot.m_bConnectedListenNode[m_nRobot]) then Exit;
  //
  try
  //CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnCheckListenNodeTimer Expired');
    tmrCheckListenNode.Enabled := False;
    //
    if (not DongaRobot.m_bConnectedModbus[m_nRobot]) then begin  // [REF] LMK_202011
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnCheckListenNodeTimer: Skip(m_bConnectedModbus=False)');
      Exit;
    end;
{$IFDEF IMSI_DELETE}
    if (m_RobotStatusCoord.RunMode <> ROBOT_TM_MB_RUNMODE_AUTO) then begin  // [REF] LMK_202011
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnCheckListenNodeTimer: Skip(RunMode<>Auto)');
      Exit;
    end;
{$ENDIF}
    if (not m_RobotStatusCoord.RobotStatus.ProjectRunning) then begin  // [REF] LMK_202011
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnCheckListenNodeTimer: Skip(ProjRunning=False) ...TBD');
      Exit;
    end;
    if m_RobotStatusCoord.RobotStatus.ProjectPause then begin  // [REF] LMK_202011
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnCheckListenNodeTimer: RobotControl(Pause->Play)');
    //RobotDioControl(MakePlay); //TBD:A2CHv3:ROBOT?
      Exit;
    end;
    //
    if m_bIsOnListenNodeCmd then begin
      CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnCheckListenNodeTimer: Skip(m_bIsOnListenNodeCmd)');
      Exit;
    end;
    //
    ThreadTask(procedure
    var
      sCmd, sMsg: string; nCmdRet: DWORD;
    begin
      try
        sCmd    := 'READY';
        nCmdRet := ListenNodeCmdReq(sCmd, True{bCheckAck},ROBOT_LISTENNODE_CONNCHECK_TIMEMSEC,0{nRetry});
        if nCmdRet = WAIT_OBJECT_0 then begin
          if (not m_bListenNodeFirstReadyDone) then begin
            m_bListenNodeFirstReadyDone := True;
            sMsg := '<ROBOT> CH'+IntToStr(m_nRobot+1)+': Command TCP-Server READY OK';
            DongaRobot.Robot[m_nRobot].SendRobotEvent(DefPocb.MSG_MODE_ROBOT_GET_STATUS, DefPocb.ERR_OK, sMsg); //TBD:ROBOT?
          end;
        end;
      except
      //CodeSite.Send('<RobotCtl> '+m_sRobot+': RobotTM.OnCheckListenNodeTimer: TX/RX(READY) NG');
      end;
    end);
  finally
    tmrCheckListenNode.Enabled := True;
  end;
end;

//******************************************************************************
// procedure/function: TRobotTM - Robot-to-FrmMain/FrmTest/Mainter
//******************************************************************************

//
procedure TRobotTM.SendRobotEvent(nRobotCtlMode: Integer; nErrCode: Integer; sMsg: string);
begin
  SendMainGuiRobotDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,nRobotCtlMode,nErrCode,sMsg);
  SendTestGuiRobotDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,sMsg);
  if (DongaRobot.FMaintRobotUse and Assigned(DongaRobot.MaintRobotStatus)) then
    DongaRobot.MaintRobotStatus(m_nRobot,nRobotCtlMode,nErrCode,sMsg);
end;

//
procedure TRobotTM.SendMainGuiRobotDisplay(nGuiMode, nRobotCtlMode, nErrCode: Integer; sMsg: string);  //TBD:ROBOT?
var
  ccd : TCopyDataStruct;
  MainGuiRobotData : RMainGuiRobotData;
begin
  //Common.MLog(nCh,'<TRobot> SendMainGuiDisplay: Mode('+IntToStr(nGuiMode)+') Ch('+IntToStr(nCh+1)+') Param('+IntToStr(nParam)+')',DefPocb.DEBUG_LEVEL_INFO);
  MainGuiRobotData.MsgType := DefPocb.MSG_TYPE_ROBOT;
  MainGuiRobotData.Channel := m_nCh;
  MainGuiRobotData.Mode    := nGuiMode;
  MainGuiRobotData.Param   := m_nRobot;      // Robot
  MainGuiRobotData.Param2  := nRobotCtlMode; // MSG_MODE_ROBOT_xxxxxx;
  MainGuiRobotData.Param3  := nErrCode;      // ERR_ROBOT_xxxxxx
  MainGuiRobotData.Msg     := sMsg;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(MainGuiRobotData);
  ccd.lpData      := @MainGuiRobotData;
  SendMessage(DongaRobot.m_hMain,WM_COPYDATA,0,LongInt(@ccd));  //TBD:A2CH? (nCH->nJig)
end;

//
procedure TRobotTM.SendTestGuiRobotDisplay(nGuiMode: Integer; sMsg: string);  //TBD:ROBOT?
var
  ccd : TCopyDataStruct;
  TestGuiRobotData : RTestGuiRobotData;
begin
  //Common.MLog(nCh,'<TRobot> SendTestGuiDisplay: Mode('+IntToStr(nGuiMode)+') Ch('+IntToStr(nCh+1)+') Param('+IntToStr(nParam)+')',DefPocb.DEBUG_LEVEL_INFO);
  TestGuiRobotData.MsgType := DefPocb.MSG_TYPE_ROBOT;
  TestGuiRobotData.Channel := m_nCh;
  TestGuiRobotData.Mode    := nGuiMode;
  TestGuiRobotData.Param   := m_nRobot;
  TestGuiRobotData.Msg     := sMsg;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(TestGuiRobotData);
  ccd.lpData      := @TestGuiRobotData;
  SendMessage(DongaRobot.m_hTest[m_nCh],WM_COPYDATA,0,LongInt(@ccd));  //TBD:A2CH? (nCH->nJig)
end;

//******************************************************************************
// procedure/function: TRobotTM - Etc
//******************************************************************************

procedure TRobotTM.ThreadTask(task: TProc);
var
  th2 : TThread;
begin
  th2 := TThread.CreateAnonymousThread(procedure begin
    task;
  end);
  th2.FreeOnTerminate := True;
  th2.Start;
end;

//******************************************************************************
// procedure/function: TRobotTM - SIMULATOR_ROBOT
//******************************************************************************

{$IFDEF SIMULATOR_ROBOT}
procedure TRobotTM.SimRobotModbus(TxBuf: TModBusPktBuf; var RxBuffer: TIdBytes);
const
  RobotSimModBus_RobotStatus1  = $02; //Normal:0x02(ProjectRunning)
  RobotSimModBus_RobotStatus2  = $00; //TBD:ROBOT?
  RobotSimModBus_RobotRunSpeed = 10;    //TBD:ROBOT?
  RobotSimModBus_RobotRunMode  = ROBOT_TM_MB_RUNMODE_AUTO;    //TBD:ROBOT?
  RobotSimModBus_RobotLight    = 4;    //TBD:ROBOT?
var
  nSingle : TSingleWordsBytes;
  nLength, nAddress, nDataLen : Word;
begin
  //---------------------------------------------- ModBus Headder
  RxBuffer[MODBUS_PKTBUF_IDX_TRANID+0]  := TxBuf[MODBUS_PKTBUF_IDX_TRANID+0];
  RxBuffer[MODBUS_PKTBUF_IDX_TRANID+1]  := TxBuf[MODBUS_PKTBUF_IDX_TRANID+1];
  RxBuffer[MODBUS_PKTBUF_IDX_PROTOID+0] := TxBuf[MODBUS_PKTBUF_IDX_PROTOID+0];
  RxBuffer[MODBUS_PKTBUF_IDX_PROTOID+1] := TxBuf[MODBUS_PKTBUF_IDX_PROTOID+1];
//RxBuffer[MODBUS_PKTBUF_IDX_LENGTH+0]  := TxBuf[MODBUS_PKTBUF_IDX_LENGTH+0];
//RxBuffer[MODBUS_PKTBUF_IDX_LENGTH+1]  := TxBuf[MODBUS_PKTBUF_IDX_LENGTH+1];
  RxBuffer[MODBUS_PKTBUF_IDX_UNITID]    := TxBuf[MODBUS_PKTBUF_IDX_UNITID];
  RxBuffer[MODBUS_PKTBUF_IDX_PDU_FC]    := TxBuf[MODBUS_PKTBUF_IDX_PDU_FC];
  //---------------------------------------------- ModBus PDU
  case TxBuf[MODBUS_PKTBUF_IDX_PDU_FC] of
    MODBUS_FC_01_ReadCoils,
    MODBUS_FC_02_ReadInputBits: begin
      nAddress := (TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0] shl 8) or TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1];
      nDataLen := (TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2] shl 8) or TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3]; // # of Coils
      if nAddress = ROBOT_TM_MB_DEVADDR_RobotStatus then begin
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+0] := Byte((nDataLen + 7) div 8); // Byte Count
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+1] := RobotSimModBus_RobotStatus1;
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+2] := RobotSimModBus_RobotStatus2;
        //
        nLength := 3 + RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA]; //UnitID(1) + FunctionCode(1) + ByteCount(1) + PDUData(n)
        RxBuffer[MODBUS_PKTBUF_IDX_LENGTH+0] := Byte((nLength shr 8) and $FF);
        RxBuffer[MODBUS_PKTBUF_IDX_LENGTH+1] := Byte(nLength and $FF);
      end
      else if nAddress = ROBOT_TM_MB_DEVADDR_RobotExtra then begin
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+0] := Byte((nDataLen + 7) div 8); // Byte Count
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+1] := 0;
        //
        nLength := 3 + RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA]; //UnitID(1) + FunctionCode(1) + ByteCount(1) + PDUData(n)
        RxBuffer[MODBUS_PKTBUF_IDX_LENGTH+0] := Byte((nLength shr 8) and $FF);
        RxBuffer[MODBUS_PKTBUF_IDX_LENGTH+1] := Byte(nLength and $FF);
      end;
    end;
    MODBUS_FC_03_ReadHoldingRegs,
    MODBUS_FC_04_ReadInputRegs: begin
      nAddress := (TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+0] shl 8) or TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+1];
      nDataLen := (TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+2] shl 8) or TxBuf[MODBUS_PKTBUF_IDX_PDU_DATA+3]; // # of Registers
      RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+0] := Byte(nDataLen and $00FF) * 2; // Byte Count for Word
      if nAddress = ROBOT_TM_MB_DEVADDR_RobotCoord then begin
        nSingle.dabSingle := RobotSimModBus_CoordCurrent.X;
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+1] := nSingle.dabBytes[3];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+2] := nSingle.dabBytes[2];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+3] := nSingle.dabBytes[1];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+4] := nSingle.dabBytes[0];
        nSingle.dabSingle := RobotSimModBus_CoordCurrent.Y;
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+5] := nSingle.dabBytes[3];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+6] := nSingle.dabBytes[2];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+7] := nSingle.dabBytes[1];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+8] := nSingle.dabBytes[0];
        nSingle.dabSingle := RobotSimModBus_CoordCurrent.Z;
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+9] := nSingle.dabBytes[3];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+10]:= nSingle.dabBytes[2];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+11]:= nSingle.dabBytes[1];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+12]:= nSingle.dabBytes[0];
        nSingle.dabSingle := RobotSimModBus_CoordCurrent.Rx;
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+13] := nSingle.dabBytes[3];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+14] := nSingle.dabBytes[2];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+15] := nSingle.dabBytes[1];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+16] := nSingle.dabBytes[0];
        nSingle.dabSingle := RobotSimModBus_CoordCurrent.Ry;
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+17] := nSingle.dabBytes[3];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+18] := nSingle.dabBytes[2];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+19] := nSingle.dabBytes[1];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+20] := nSingle.dabBytes[0];
        nSingle.dabSingle := RobotSimModBus_CoordCurrent.Rz;
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+21] := nSingle.dabBytes[3];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+22] := nSingle.dabBytes[2];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+23] := nSingle.dabBytes[1];
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+24] := nSingle.dabBytes[0];
      end
      else if nAddress = ROBOT_TM_MB_DEVADDR_RunSpeedMode then begin
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+1] := Byte((RobotSimModBus_RobotRunSpeed shr 8) and $FF);
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+2] := Byte(RobotSimModBus_RobotRunSpeed and $FF);
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+3] := Byte((RobotSimModBus_RobotRunMode shr 8) and $FF);
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+4] := Byte(RobotSimModBus_RobotRunMode and $FF);
      end
      else if nAddress = ROBOT_TM_MB_DEVADDR_RobotLight then begin
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+1] := Byte((RobotSimModBus_RobotLight shr 8) and $FF);
        RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA+2] := Byte(RobotSimModBus_RobotLight and $FF);
      end;
      nLength := 3 + RxBuffer[MODBUS_PKTBUF_IDX_PDU_DATA]; //UnitID(1) + FunctionCode(1) + ByteCount(1) + PDUData(n)
      RxBuffer[MODBUS_PKTBUF_IDX_LENGTH+0] := Byte((nLength shr 8) and $FF);
      RxBuffer[MODBUS_PKTBUF_IDX_LENGTH+1] := Byte(nLength and $FF);
    end;
    //--------------------------------------------
    MODBUS_FC_05_WriteOneCoil: begin
      //TBD:ROBOT?
    end;
    //--------------------------------------------
    MODBUS_FC_06_WriteOneReg: begin
      //TBD:ROBOT?
    end;
    //--------------------------------------------
    MODBUS_FC_15_WriteMultiCoils: begin
      //TBD:ROBOT?
    end;
    //--------------------------------------------
    MODBUS_FC_16_WriteMultiRegs: begin
      //TBD:ROBOT?
    end;
    else begin
    end;
  end;
end;

procedure TRobotTM.SimRobotListenNode(sCmd: string);  //TBD:ROBOT?
begin
  ThreadTask(procedure
  var
    ABuff : TIdBytes;
    sAnsiCmd : AnsiString;
    nSize : Integer;
    targetCoord, startCoord, tempCoord : TRobotCoord;
    i: Integer;
    arrStr : TArray<string>;
  begin
    sAnsiCmd := AnsiString(sCmd); //TBD? +#$00;
    nSize := Length(sAnsiCmd);
    SetLength(ABuff,nSize);
    CopyMemory(@ABuff[0],@sAnsiCmd[1],nSize);
    //
    if sCmd = 'READY' then begin
      Sleep(100);
    //case m_CoordState of
    //  coordHome   : RobotSimModBus_CoordCurrent := RobotSimModBus_CoordHome;
    //  coordModel  : RobotSimModBus_CoordCurrent := RobotSimModBus_CoordModel;
    //  coordStandby: RobotSimModBus_CoordCurrent := RobotSimModBus_CoordStandby;
    //  else          RobotSimModBus_CoordCurrent := RobotSimModBus_CoordStart;
    //end;
      ReadListenNodeCmd(m_nRobot,nSize,ABuff);  //2021-01-15 SIMULATOR_ROBOT
    end
    else if sCmd = 'MUTING' then begin
      targetCoord := RobotSimModBus_CoordHome;
      startCoord  := RobotSimModBus_CoordCurrent;
      tempCoord   := RobotSimModBus_CoordCurrent;
      for i := 1 to 3 do begin
        tempCoord.X  := startCoord.X  + ((targetCoord.X  - startCoord.X)  / 4 * i);
        tempCoord.Y  := startCoord.Y  + ((targetCoord.Y  - startCoord.Y)  / 4 * i);
        tempCoord.Z  := startCoord.Z  + ((targetCoord.Z  - startCoord.Z)  / 4 * i);
        tempCoord.Rx := startCoord.Rx + ((targetCoord.Rx - startCoord.Rx) / 4 * i);
        tempCoord.Ry := startCoord.Ry + ((targetCoord.Ry - startCoord.Ry) / 4 * i);
        tempCoord.Rz := startCoord.Rz + ((targetCoord.Rz - startCoord.Rz) / 4 * i);
        RobotSimModBus_CoordCurrent := tempCoord;
        Sleep(150);
      end;
      RobotSimModBus_CoordCurrent := targetCoord;
    //Sleep(300); //2022-07-15
      //
      ReadListenNodeCmd(m_nRobot,nSize,ABuff);  //2021-01-15 SIMULATOR_ROBOT
    end
    else if sCmd = 'MOVE' then begin
      Sleep(100);
      ReadListenNodeCmd(m_nRobot,nSize,ABuff);  //2021-01-15 SIMULATOR_ROBOT
    end
    else if sCmd = Common.TestModelInfo2[m_nRobot].RobotModelInfo.ModelCmd then begin
      targetCoord := RobotSimModBus_CoordModel;
      startCoord  := RobotSimModBus_CoordCurrent;
      tempCoord   := RobotSimModBus_CoordCurrent;
      for i := 1 to 3 do begin
        tempCoord.X  := startCoord.X  + ((targetCoord.X  - startCoord.X)  / 4 * i);
        tempCoord.Y  := startCoord.Y  + ((targetCoord.Y  - startCoord.Y)  / 4 * i);
        tempCoord.Z  := startCoord.Z  + ((targetCoord.Z  - startCoord.Z)  / 4 * i);
        tempCoord.Rx := startCoord.Rx + ((targetCoord.Rx - startCoord.Rx) / 4 * i);
        tempCoord.Ry := startCoord.Ry + ((targetCoord.Ry - startCoord.Ry) / 4 * i);
        tempCoord.Rz := startCoord.Rz + ((targetCoord.Rz - startCoord.Rz) / 4 * i);
        RobotSimModBus_CoordCurrent := tempCoord;
        Sleep(150);
      end;
      RobotSimModBus_CoordCurrent := targetCoord;
    //Sleep(300); //2022-07-15
      //
      ReadListenNodeCmd(m_nRobot,nSize,ABuff);  //2021-01-15 SIMULATOR_ROBOT
    end
    else if sCmd = 'STANDBY' then begin
      targetCoord := RobotSimModBus_CoordStandby;
      startCoord  := RobotSimModBus_CoordCurrent;
      tempCoord   := RobotSimModBus_CoordCurrent;
      for i := 1 to 3 do begin
        tempCoord.X  := startCoord.X  + ((targetCoord.X  - startCoord.X)  / 4 * i);
        tempCoord.Y  := startCoord.Y  + ((targetCoord.Y  - startCoord.Y)  / 4 * i);
        tempCoord.Z  := startCoord.Z  + ((targetCoord.Z  - startCoord.Z)  / 4 * i);
        tempCoord.Rx := startCoord.Rx + ((targetCoord.Rx - startCoord.Rx) / 4 * i);
        tempCoord.Ry := startCoord.Ry + ((targetCoord.Ry - startCoord.Ry) / 4 * i);
        tempCoord.Rz := startCoord.Rz + ((targetCoord.Rz - startCoord.Rz) / 4 * i);
        RobotSimModBus_CoordCurrent := tempCoord;
        Sleep(150);
      end;
      RobotSimModBus_CoordCurrent := targetCoord;
    //Sleep(300); //2022-07-15
      //
      ReadListenNodeCmd(m_nRobot,nSize,ABuff);  //2021-01-15 SIMULATOR_ROBOT
    end
    else begin
      arrStr := Trim(sCmd).Split([',']);
      if Length(arrStr) = 6 then begin  //MoveRelative
        startCoord := RobotSimModBus_CoordCurrent;
        targetCoord.X  := SimpleRoundTo((startCoord.X  + StrToFloatDef(arrStr[0], 0.0)),-2);
        targetCoord.Y  := SimpleRoundTo((startCoord.Y  + StrToFloatDef(arrStr[1], 0.0)),-2);
        targetCoord.Z  := SimpleRoundTo((startCoord.Z  + StrToFloatDef(arrStr[2], 0.0)),-2);
        targetCoord.Rx := SimpleRoundTo((startCoord.Rx + StrToFloatDef(arrStr[3], 0.0)),-2);
        targetCoord.Ry := SimpleRoundTo((startCoord.Ry + StrToFloatDef(arrStr[4], 0.0)),-2);
        targetCoord.Rz := SimpleRoundTo((startCoord.Rz + StrToFloatDef(arrStr[5], 0.0)),-2);
        Sleep(150);
        RobotSimModBus_CoordCurrent := targetCoord;
      //Sleep(300); //2022-07-15
        //
        ReadListenNodeCmd(m_nRobot,nSize,ABuff);   //2021-01-15 SIMULATOR_ROBOT
      end
      else begin
        CodeSite.Send('#RobotCtl# '+m_sRobot+': RobotTM.SimRobotListenNode('+sCmd+') ...Ignore(Unknown Cmd)');
      end;
    end
  end);
end;
{$ENDIF}

end.
