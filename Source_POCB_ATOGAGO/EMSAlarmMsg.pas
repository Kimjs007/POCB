unit EMSAlarmMsg;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzButton, Vcl.StdCtrls, RzLabel,
  DefDio, DioCtl;

type
  TfrmEMSAlarmMsg = class(TForm)
    pnlSafetyAlarmMsg: TPanel;
    btnExit: TRzBitBtn;
    lblShow: TRzLabel;
    lblButtom: TRzLabel;
    lblTop: TRzLabel;
    btnBuzzerStop: TRzBitBtn;
    Label1: TLabel;
    Label3: TLabel;
    lbl1: TLabel;
    procedure btnExitClick(Sender: TObject);
    procedure btnBuzzerStopClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEMSAlarmMsg: TfrmEMSAlarmMsg;
implementation

{$R *.dfm}

procedure TfrmEMSAlarmMsg.btnBuzzerStopClick(Sender: TObject);
begin
  if (DongaDio = nil) then Exit;
  DongaDio.SetBuzzer(False);
end;

procedure TfrmEMSAlarmMsg.btnExitClick(Sender: TObject);
begin
  close;
end;

end.
