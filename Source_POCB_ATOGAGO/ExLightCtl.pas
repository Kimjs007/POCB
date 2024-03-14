unit ExLightCtl;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, VaComm, Vcl.Dialogs, CodeSiteLogging,
  DefSerialComm, DefPocb, DefDio, DioCtl,System.Generics.Collections, UserUtils,
  CommonClass;
type

  PMainGuiExLight  = ^RMainGuiExLight;
  RMainGuiExLight = packed record
    MsgType : Integer;
    Channel : Integer;
    Mode    : Integer;
    Param   : Integer;
    Msg     : string;
  end;

  InExLightEvnt = procedure(sGetData : String) of object;
  InExLightConn = procedure(bConnected : Boolean; sMsg : string) of object;

  TSerialExLight = class(TObject)
		ComExLight : TVaComm;
  private
    m_hMain       : THandle;
    FReadyExLight: Integer;
    FOnRevExLightData: InExLightEvnt;
    FOnRevExLightConn: InExLightConn;
    procedure SetOnRevExLightData(const Value: InExLightEvnt);
    procedure ReadVaCom(Sender: TObject; Count: Integer);
    procedure SetOnRevExLightConn(const Value: InExLightConn);
    procedure SendMainGuiDisplay(nGuiMode, nConnect : integer; sMsg : string);
    procedure TX_ExLightOnOffCmd(nExPhyCh: Integer; bOn: Boolean);  //JIG1: nExPhyCh=1~3, JIG2: nExPhyCh=4~6
    procedure TX_ExLightLevelSetCmd(nExPhyCh: Integer; nLevel{0~255}: Integer);  //JIG1: nExPhyCh=1~3, JIG2: nExPhyCh=4~6
  public
    m_bExLightConnection : boolean;
{$IF Defined(SIMULATOR_DIO) and Defined(HAS_DIO_EXLIGHT_DETECT)}
    m_nSimExPhyChOnOff : array[1..8] of Boolean;  //Dynamic 으로 해야 맞는데 굳이....
    m_nSimExPhyChLevel : array[1..8] of Integer;
{$ENDIF}
  //constructor Create(hMain :HWND); virtual;
    constructor Create(AOwner: TComponent); virtual;
    destructor Destroy; override;
    procedure ChangePort(nPort : Integer);
    property ReadyExLight : Integer read FReadyExLight write FReadyExLight;
    property OnRevExLightData : InExLightEvnt read FOnRevExLightData write SetOnRevExLightData;
    property OnRevExLightConn : InExLightConn read FOnRevExLightConn write SetOnRevExLightConn;
    procedure AllOff(nCam: Integer);
    function SendExLightChCtrl(nCam: Integer; nExCh: Integer; nLevel: Integer): Boolean;  //Cam#=JIG#: nExCh=1~3
    function SendExLightAllCtrl(nCam: Integer; nlLevel : TList<Integer>) : Boolean;
  end;

var
  DongaExLight : TSerialExLight;

implementation

{ TSerialExLight }

//******************************************************************************
// procedure/function:
//
//******************************************************************************

//constructor TSerialExLight.Create(hMain: HWND);
constructor TSerialExLight.Create(AOwner: TComponent);
begin
  FReadyExLight := 0;
  ComExLight := TVaComm.Create(AOwner);
  //
  Sleep(100);
  AllOff(-1{Cam1&Cam2});
end;

destructor TSerialExLight.Destroy;
begin
  if ComExLight <> nil then begin
    AllOff(-1{Cam1&Cam2});
    Sleep(100);
    //
    ComExLight.Close;
    ComExLight.Free;
    ComExLight := nil;
  end;
  inherited;
end;

procedure TSerialExLight.ReadVaCom(Sender: TObject; Count: Integer);
var
  sData : string;
begin
  sData := string(ComExLight.ReadText);
  //CodeSite.Send(sData);
  OnRevExLightData(sData);
end;

procedure TSerialExLight.SetOnRevExLightConn(const Value: InExLightConn);
begin
  FOnRevExLightConn := Value;
end;

procedure TSerialExLight.SetOnRevExLightData(const Value: InExLightEvnt);
begin
	FOnRevExLightData := Value;
end;

//******************************************************************************
// procedure/function:
//		- ChangePort(nPort: Integer);
//    - ReadVaCom(Sender: TObject; Count: Integer);
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] ChangePort(nPort: Integer);
//    Called-by: procedure TfrmTest1Ch.ShowGui(hMain: HWND);
//
procedure TSerialExLight.ChangePort(nPort: Integer);
var
  sTemp : string;
begin
  Common.MLog(DefPocb.SYS_LOG,'<ExLight> ChangePort:'+IntToStr(nPort));
  if nPort <> 0 then begin
    try
      sTemp := Format('COM%d',[nPort]);
      ComExLight.Close;
      m_bExLightConnection := False;
      ComExLight.Name      := Format('ComExLight%d',[nPort]);
      ComExLight.PortNum   := nPort;
      ComExLight.Parity    := paNone;
      ComExLight.Databits  := db8;
      ComExLight.BaudRate  := br19200;
      ComExLight.StopBits  := sb1;
      ComExLight.EventChars.EofChar := DefSerialComm.ETX;
    //ComSw.OnRxChar  := ReadVaCom; 
      ComExLight.Open;
      m_bExLightConnection := True;
      OnRevExLightConn(True,Format('COM%d',[nPort]));
    //SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,1,sTemp); //TBD:ExLight?
    except on E : Exception do
      OnRevExLightConn(False,Format('COM%d',[nPort]));
    //SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,0,sTemp); //TBD:ExLight?
    end;
  end
  else begin
    m_bExLightConnection := False;
    if ComExLight is TVaComm then begin
      ComExLight.Close;
    end;
    OnRevExLightConn(False,'NONE');
  //SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,2,'NONE');  //TBD:ExLight?
  end;
end;

//******************************************************************************
// procedure/function:
//		-
//******************************************************************************

procedure TSerialExLight.TX_ExLightOnOffCmd(nExPhyCh: Integer; bOn: Boolean);  //JIG1: nExPhyCh=1~3, JIG2: nExPhyCh=4~6
var
  nChCount  : Integer;
  sSendData : AnsiString;
{$IF Defined(SIMULATOR_DIO) and Defined(HAS_DIO_EXLIGHT_DETECT)}
  i         : Integer;
  bDioOn    : Boolean;
{$ENDIF}
begin
  nChCount := Common.SystemInfo.ExLightCh_Count;
  sSendData := AnsiChar(DefSerialComm.STX) + AnsiString(Format('%.2d',[nExPhyCh])) + AnsiString('ON');
  if bOn then sSendData := sSendData + AnsiString('1')  //'1': On
  else        sSendData := sSendData + AnsiString('0'); //'0': Off
  sSendData := sSendData + AnsiChar(DefSerialComm.ETX);
//ComExLight.WriteText(sSendData);
  if ComExLight.Active then begin
    try
      ComExLight.WriteText((sSendData));
{$IF Defined(SIMULATOR_DIO) and Defined(HAS_DIO_EXLIGHT_DETECT)}
      if (Common.SystemInfo.HasDioExLightDetect and Common.SystemInfo.UseDetectLight) then begin //2022-07-15 A2CHv4_#3
        m_nSimExPhyChOnOff[nExPhyCh] := bOn;
        if nExPhyCh in [1..nChCount] then begin
          bDioOn := False;
          for i := 1 to nChCount do begin
            if m_nSimExPhyChOnOff[i] and (m_nSimExPhyChLevel[i] > 0) then begin
              bDioOn := True;
              Break;
            end;
          end;
          if bDioOn then DongaDio.SimulatorDioSetIn(LongWord(DefDio.MASK_IN_STAGE1_EXLIGHT_DETECT))
          else           DongaDio.SimulatorDioClrIn(LongWord(DefDio.MASK_IN_STAGE1_EXLIGHT_DETECT));
        end
        else if nExPhyCh in [(nChCount + 1)..(nChCount * 2)] then begin
          for i := (nChCount + 1) to (nChCount * 2) do begin
            if m_nSimExPhyChOnOff[i] and (m_nSimExPhyChLevel[i] > 0) then begin
              bDioOn := True;
              Break;
            end;
          end;
          if bDioOn then DongaDio.SimulatorDioSetIn(LongWord(DefDio.MASK_IN_STAGE2_EXLIGHT_DETECT))
          else           DongaDio.SimulatorDioClrIn(LongWord(DefDio.MASK_IN_STAGE2_EXLIGHT_DETECT));
        end;
      end;
{$ENDIF}
    except
      if nExPhyCh in [1..nChCount] then Common.MLog(DefPocb.CH_1,'<ExLight> TX_ExLightOnOffCmd Fail')
      else                              Common.MLog(DefPocb.CH_2,'<ExLight> TX_ExLightOnOffCmd Fail');
    end
  end;
end;

procedure TSerialExLight.TX_ExLightLevelSetCmd(nExPhyCh: Integer; nLevel{0~255}: Integer);  //JIG1: nExPhyCh=1~3, JIG2: nExPhyCh=4~6
var
  nChCount  : Integer;
  sSendData : AnsiString;
begin
  nChCount := Common.SystemInfo.ExLightCh_Count;
  sSendData := AnsiChar(DefSerialComm.STX) + AnsiString(Format('%.2d',[nExPhyCh])) + AnsiString('WR') + AnsiString(Format('%.3d',[nLevel])) + AnsiChar(DefSerialComm.ETX);
  if ComExLight.Active then begin
    try
      ComExLight.WriteText((sSendData));
{$IF Defined(SIMULATOR_DIO) and Defined(HAS_DIO_EXLIGHT_DETECT)}
      m_nSimExPhyChLevel[nExPhyCh] := nLevel;
{$ENDIF}
    except
      if nExPhyCh in [1..nChCount] then Common.MLog(DefPocb.CH_1,'<ExLight> TX_ExLightLevelSetCmd Fail')
      else                              Common.MLog(DefPocb.CH_2,'<ExLight> TX_ExLightLevelSetCmd Fail');
    end
  end;
end;

//******************************************************************************
// procedure/function:
//		-
//******************************************************************************


procedure TSerialExLight.AllOff(nCam: Integer);
var
  nStartExPhyCh, nEndExPhyCh, nExPhyCh, nChCount : Integer;
begin
  if (not m_bExLightConnection) then Exit;

  nChCount := Common.SystemInfo.ExLightCh_Count;
  case nCam of
    DefPocb.CAM_1: begin nStartExPhyCh := 1; nEndExPhyCh := nChCount; end;
    DefPocb.CAM_2: begin nStartExPhyCh := nChCount + 1; nEndExPhyCh := nChCount * 2; end;
    else           begin nStartExPhyCh := 1; nEndExPhyCh := nChCount * 2; end;
  end;
  for nExPhyCh := nStartExPhyCh to nEndExPhyCh do begin
    TX_ExLightOnOffCmd(nExPhyCh,False{bOn});
    Sleep(50);
  end;
end;

function TSerialExLight.SendExLightChCtrl(nCam: Integer; nExCh: Integer; nLevel: Integer): Boolean;
var
  bOn       : Boolean;
  nExPhyCh  : Integer;
  sSendData : AnsiString;
begin
  if (not m_bExLightConnection) then Exit(False);
  if (nCam < DefPocb.CH_1) or (nCam > DefPocb.CH_2) then Exit(False);
  if (nExCh < 0) or (nExCh > Common.SystemInfo.ExLightCh_Count) then Exit(False);
  if (nLevel < 0) or (nLevel > 255) then Exit(False);
  //
  if nCam = DefPocb.CH_1 then nExPhyCh := nExCh
  else                        nExPhyCh := nExCh + Common.SystemInfo.ExLightCh_Count;
  //
  if nLevel = 0 then bOn := False
  else               bOn := True;
  //
  if bOn then begin
    TX_ExLightLevelSetCmd(nExPhyCh, nLevel);
    Sleep(50);
  end;
  TX_ExLightOnOffCmd(nExPhyCh, bOn);
  Sleep(50);

  Result := True;
end;

function TSerialExLight.SendExLightAllCtrl(nCam: Integer; nlLevel : TList<Integer>) : Boolean;
var
  nExCh,i, nSum   : Integer;
  func : TFunc<Boolean>;
begin
  if not m_bExLightConnection then Exit(False);
  if not (nCam in [DefPocb.CH_1..DefPocb.CH_2]) then Exit(False);
  if (nlLevel.Count = 0) then Exit(False);
     //or (nlLevel.Count < Common.SystemInfo.ExLightCh_Count) then Exit(False);
     //꼭 채널 만큼 안받아도 받은 만큼만 켜도 문제 없을 듯 하다

  for nExCh := 1 to nlLevel.Count do begin
		if (nlLevel[nExCh - 1] < 0) then continue; //2023-09-12
    SendExLightChCtrl(nCam, nExCh, nlLevel[nExCh - 1]);
  end;

  nSum := Sum(nlLevel);

  func := function : Boolean begin Result := DongaDio.CheckLightDetect(nCam, nSum > 0);end;
  if UserUtils.RetryFunc(func, 5) then
    Exit(True);

  Result := False;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] SendMainGuiDisplay(nGuiMode, nConnect: integer; sMsg: string);
//    Called-by: TSerialExLight.ChangePort(nPort: Integer);
//    Notes:
//            MODE = MSG_MODE_DISPLAY_CONNECTION
//                <Channel>   m_nJig
//                <Param>     0: disconnect, 1: Connect , 2: NONE
procedure TSerialExLight.SendMainGuiDisplay(nGuiMode, nConnect: integer; sMsg: string);
var
  ccd : TCopyDataStruct;
  MainGuiExLightData : RMainGuiExLight;
begin
  MainGuiExLightData.MsgType := DefPocb.MSG_TYPE_EXLIGHT;
  MainGuiExLightData.Channel := 0;  //dummy
  MainGuiExLightData.Mode    := nGuiMode;
  MainGuiExLightData.Param   := nConnect;  // 0 : disconnect, 1 : Connect , 2 : NONE
  MainGuiExLightData.Msg     := sMsg;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(MainGuiExLightData);
  ccd.lpData      := @MainGuiExLightData;
  SendMessage(m_hMain,WM_COPYDATA,0, LongInt(@ccd));
end;

end.
