unit FormAutoCal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, DefPocb, RzPanel;

const
  TIMEOUT = 300;
type
  TForm_AutoCal = class(TForm)
    Panel_Second_Ch1: TRzPanel;
    Panel_Result_Ch1: TRzPanel;
    Button_Close: TButton;
    Timer_time: TTimer;
    Panel_Ch1: TRzPanel;
    Panel_Ch2: TRzPanel;
    Panel_Result_Ch2: TRzPanel;
    Panel_Second_Ch2: TRzPanel;
    procedure FormShow(Sender: TObject);
    procedure Timer_timeTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button_CloseClick(Sender: TObject);
  private
    m_nCh     : Integer;
    m_nSecond : array[0..DefPocb.CH_MAX] of Integer;
    m_bDone   : array[0..DefPocb.CH_MAX] of Boolean;
    { Private declarations }
  public
    { Public declarations }
    function ShowForm(nCh : Integer) : Integer;
    procedure SetResult(nCh : Integer; btValue : Byte);
  end;

var
  Form_AutoCal: TForm_AutoCal;

implementation

{$R *.dfm}

procedure TForm_AutoCal.Button_CloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TForm_AutoCal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer_time.Enabled := False;
end;

procedure TForm_AutoCal.FormShow(Sender: TObject);
begin
  Self.Caption := Format('%s (Timeout : %dsec)',[Self.Caption, TIMEOUT]);

  m_bDone[0] := False;
  m_bDone[1] := False;
  m_nSecond[0] := 0;
  m_nSecond[1] := 0;
  Timer_time.Enabled := True;
end;

function TForm_AutoCal.ShowForm(nCh : Integer) : Integer;
begin
  m_nCh  := nCh;

  if nCh = DefPocb.CH_2 then begin
    Panel_Ch1.Enabled := False;
    Panel_Result_Ch1.Enabled := False;
    Panel_Second_Ch1.Enabled := False;
  end;

  if nCh = DefPocb.CH_1 then begin
    Panel_Ch2.Enabled := False;
    Panel_Result_Ch2.Enabled := False;
    Panel_Second_Ch2.Enabled := False;
  end;

  Result := Self.ShowModal;
end;

procedure TForm_AutoCal.SetResult(nCh : Integer; btValue: Byte);
var
  lPanel : array[0..DefPocb.CH_MAX] of TRzPanel;
begin
  lPanel[DefPocb.CH_1] := Panel_Result_Ch1;
  lPanel[DefPocb.CH_2] := Panel_Result_Ch2;

  lPanel[nCh].Font.Color := clRed;

  case btValue of
    $00 :
    begin
      lPanel[nCh].Caption    := 'SUCCESS';
      lPanel[nCh].Font.Color := clLime;
    end;
    $01 :lPanel[nCh].Caption    := 'Loader ID Fail';
    $02 :lPanel[nCh].Caption    := 'Loader VCC Zero';
    $03 :lPanel[nCh].Caption    := 'VCC Over Voltage';
    $04 :lPanel[nCh].Caption    := 'Loader VBL Zero';
    $05 :lPanel[nCh].Caption    := 'VBL Over Voltage';
    $99 :lPanel[nCh].Caption    := 'Fail Loader Cal';
    else lPanel[nCh].Caption    := 'Time Out';
  end;

  m_bDone[nCh] := True;

  if m_nCh > DefPocb.CH_MAX then begin
    if m_bDone[DefPocb.CH_1] and m_bDone[DefPocb.CH_2] then begin
      Timer_time.Enabled   := False;
      Button_Close.Enabled := True;
    end;
  end
  else begin
    Timer_time.Enabled   := False;
    Button_Close.Enabled := True;
  end;
end;

procedure TForm_AutoCal.Timer_timeTimer(Sender: TObject);
begin
  if m_nCh <> DefPocb.CH_2 then begin
    if not m_bDone[DefPocb.CH_1] then Panel_Second_Ch1.Caption := m_nSecond[DefPocb.CH_1].ToString;
    m_nSecond[DefPocb.CH_1] := m_nSecond[DefPocb.CH_1] + 1;
    if m_nSecond[DefPocb.CH_1] > TIMEOUT then  SetResult(DefPocb.CH_1,$ff);
  end;

  if m_nCh <> DefPocb.CH_1 then begin
    if not m_bDone[DefPocb.CH_2] then Panel_Second_Ch2.Caption := m_nSecond[DefPocb.CH_2].ToString;
    m_nSecond[DefPocb.CH_2] := m_nSecond[DefPocb.CH_2] + 1;
    if m_nSecond[DefPocb.CH_2] > TIMEOUT then  SetResult(DefPocb.CH_2,$ff);
  end;
end;

end.
