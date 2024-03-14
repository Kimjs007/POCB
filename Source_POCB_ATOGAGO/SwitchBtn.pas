unit SwitchBtn;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, VaComm, Vcl.Dialogs, CodeSiteLogging,
  DefSerialComm, DefPocb, CommonClass;
type
  InSwEvent = procedure( sGetData : String) of object;

  PGuiSwitch  = ^RGuiSwitch;
  RGuiSwitch = packed record
    MsgType : Integer;
    Channel : Integer;
    Mode    : Integer;
    Param   : Integer;
    Msg     : string;
  end;

  TSerialSwitch = class(TObject)
		ComSw : TVaComm;
  private
    m_hMain       : THandle;
    m_nJig        : Integer;
    FOnRevSwData  : InSwEvent;
    FReadySwData  : Integer;  //TBD: NOT-USED?
    procedure SetOnRevSwData(const Value: InSwEvent);
    procedure ReadVaCom(Sender: TObject; Count: Integer);
    procedure SendMainGuiDisplay(nGuiMode, nConnect : integer; sMsg : string);
  public
    constructor Create(hMain :HWND; nJig: Integer); virtual;
    destructor Destroy; override;
    property OnRevSwData : InSwEvent read FOnRevSwData write SetOnRevSwData;
    property ReadyHandSw : Integer read FReadySwData write FReadySwData;  //TBD: NOT-USED?
    procedure ChangePort( nPort : Integer);
    procedure SendSwitchMsg(sData : string);  //TBD: NOT-USED?
  end;

//var
//  DongaSwitch : TSerialSwitch;

implementation

{ TSerialSwitch }

//******************************************************************************
// procedure/function:
//		- constructor TSerialSwitch.Create(hMain :HWND;nJigNo : Integer);
//		- destructor TSerialSwitch.Destroy;
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] constructor TSerialSwitch.Create(hMain: HWND; nJig: Integer);
//    Called-by: procedure TfrmTest1Ch.ShowGui(hMain: HWND);
//
constructor TSerialSwitch.Create(hMain: HWND; nJig: Integer);
begin
  //
  m_hMain := hMain;
  m_nJig  := nJig;
  //
  FReadySwData := 0;
  ComSw := TVaComm.Create(nil);
//ChangePort(nPort);
end;

destructor TSerialSwitch.Destroy;
begin
  if ComSw <> nil then begin
    ComSw.Close;
    ComSw.Free;
    ComSw := nil;
  end;
  inherited;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] SetOnRevSwData(const Value: InSwEvent);
//    Called-by: TfrmTest1Ch.ShowGui(hMain: HWND);
//
procedure TSerialSwitch.SetOnRevSwData(const Value: InSwEvent);
begin
	FOnRevSwData := Value;
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
procedure TSerialSwitch.ChangePort(nPort: Integer);
var
  sTemp : string;
begin
  Common.MLog(DefPocb.SYS_LOG,'<SwitchButton> JIG'+IntToStr(m_nJig+1)+': ChangePort'+IntToStr(nPort));
  if nPort <> 0 then begin
    try
      sTemp := Format('COM%d',[nPort]);
      ComSw.Close;
      ComSw.Name      := Format('ComSw%d',[nPort]);
      ComSw.PortNum   := nPort;
      ComSw.Parity    := paNone;
      ComSw.Databits  := db8;
      ComSw.BaudRate  := br115200;
      ComSw.StopBits  := sb1;
      ComSw.EventChars.EofChar := DefSerialComm.STX;  //DefSerialComm.ETX; // Enter 가 오면 Event 발생하도록..
      ComSw.OnRxChar  := ReadVaCom;
      ComSw.Open;
      SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,1,sTemp);
    except
      SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,0,sTemp);
    end;
  end
  else begin
    SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,2,'NONE');
    if ComSw is TVaComm then begin
      ComSw.Close;
    end;
  end;
end;

procedure TSerialSwitch.ReadVaCom(Sender: TObject; Count: Integer);
var
  sData : string;
begin
  sData := string(ComSw.ReadText);
//CodeSite.Send(sData);
  OnRevSwData(Trim(sData));
end;

procedure TSerialSwitch.SendSwitchMsg(sData: string);
var
  sSendData : AnsiString;
begin
  sSendData := AnsiChar(DefSerialComm.STX) + AnsiChar(DefSerialComm.SF5) + AnsiChar(DefSerialComm.SF1) + AnsiString(sSendData) + AnsiChar(DefSerialComm.ETX);
  ComSw.WriteText(sSendData);
end;

//******************************************************************************
// procedure/function:
//		-
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] SendMainGuiDisplay(nGuiMode, nConnect: integer; sMsg: string);
//    Called-by: TSerialSwitch.ChangePort(nPort: Integer);
//    Notes:
//            MODE = MSG_MODE_DISPLAY_CONNECTION
//                <Channel>   m_nJig
//                <Param>     0: disconnect, 1: Connect , 2: NONE
procedure TSerialSwitch.SendMainGuiDisplay(nGuiMode, nConnect: integer; sMsg: string);
var
  ccd : TCopyDataStruct;
  GuiSwitchData : RGuiSwitch;
begin
  GuiSwitchData.MsgType := DefPocb.MSG_TYPE_SWITCH;
  GuiSwitchData.Channel := m_nJig;
  GuiSwitchData.Mode    := nGuiMode;
  GuiSwitchData.Param   := nConnect;  // 0 : disconnect, 1 : Connect , 2 : NONE
  GuiSwitchData.Msg     := sMsg;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(GuiSwitchData);
  ccd.lpData      := @GuiSwitchData;
  SendMessage(m_hMain,WM_COPYDATA,0, LongInt(@ccd));
end;

end.
