unit SafetyScreen;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, Vcl.ExtCtrls, RzPanel, DioCtl, LogIn;

type
  TFrmSafetyMsg = class(TForm)
    btnExit: TRzButton;
    rzpnl_Msg: TRzPanel;
    rzpnl_Top: TRzPanel;
    rzpnl_Top_Line_KR: TRzPanel;
    rzpnl_Top_Line_VN: TRzPanel;
    rzpnl_Top_Line_CN: TRzPanel;
    rzpnl_Mid: TRzPanel;
    rzpnl_Mid_Line1_KR: TRzPanel;
    rzpnl_Mid_Line1_VN: TRzPanel;
    rzpnl_Mid_Line1_CN: TRzPanel;
    rzpnl_Mid_Line2_KR: TRzPanel;
    rzpnl_Mid_Line2_VN: TRzPanel;
    rzpnl_Mid_Line2_CN: TRzPanel;
    rzpnl_Mid_Line3: TRzPanel;
    Rzpnl_Mid_Line3_Phone_EN: TRzPanel;
    Rzpnl_Mid_Line3_Phone_VN: TRzPanel;
    Rzpnl_Mid_Line3_Phone_CN: TRzPanel;
    Rzpnl_Mid_Line3_Name_KR: TRzPanel;
    Rzpnl_Mid_Line3_Name_VN: TRzPanel;
    Rzpnl_Mid_Line3_Name_CN: TRzPanel;
    rzpnl_Bot: TRzPanel;
    rzpnl_Bot_Line_KR: TRzPanel;
    rzpnl_Bot_Line_VN: TRzPanel;
    rzpnl_Bot_Line_CN: TRzPanel;
    btnStopBuzzer: TRzButton;
    procedure btnExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnStopBuzzerClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmWorkingMsg: TFrmSafetyMsg;

implementation

{$R *.dfm}

procedure TFrmSafetyMsg.btnExitClick(Sender: TObject);
begin
  if not TfrmLogIn.CheckAdminPasswd then Exit;

  Self.Close;
end;

procedure TFrmSafetyMsg.btnStopBuzzerClick(Sender: TObject);
begin
  DongaDio.SetBuzzer(False);
end;

procedure TFrmSafetyMsg.FormShow(Sender: TObject);
var
  nX, nY : Integer;
begin
  nX := Trunc((Self.Height/2) - (rzpnl_Msg.Height/2));
  nY := Trunc((Self.Width/2)  - (rzpnl_Msg.Width/2));

  {$IFDEF SITE_LENSVN}
  Rzpnl_Top_Line_CN.Visible  := True;
  Rzpnl_Mid_Line1_CN.Visible := True;
  Rzpnl_Mid_Line2_CN.Visible := True;
  Rzpnl_Mid_Line3_Phone_CN.Visible := True;
  Rzpnl_Mid_Line3_Name_CN.Visible  := True;
  Rzpnl_Bot_Line_CN.Visible  := True;
  {$ENDIF}

  rzpnl_Msg.ClientToScreen(Point(nX, nY));
end;

end.
