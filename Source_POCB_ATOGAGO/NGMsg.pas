unit NgMsg;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzButton, Vcl.StdCtrls, RzLabel;

type
  TfrmNgMsg = class(TForm)
    pnlNgMsg: TPanel;
    RzBitBtn1: TRzBitBtn;
    lblShow: TRzLabel;
    procedure RzBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNgMsg: TfrmNgMsg;
  frmPlcAlarm : TfrmNgMsg;
implementation

{$R *.dfm}

procedure TfrmNgMsg.RzBitBtn1Click(Sender: TObject);
begin
  close;
end;

end.
