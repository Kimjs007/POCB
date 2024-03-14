unit About;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzPanel, Vcl.StdCtrls, RzButton, CommonClass, DefPocb;

type
  TfrmAbout = class(TForm)
    btnOK: TRzButton;
    Panel1: TPanel;
    lblPtName: TLabel;
    lblVersionValue: TLabel;
    lblCopyright: TLabel;
    lblComments: TLabel;
    lblPValue: TLabel;
    lblVersionName: TLabel;
    lblCopyright2: TLabel;
    RzPanel1: TRzPanel;
    Image1: TImage;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
	lblPValue.Caption		 :=	DefPocb.PROGRAM_NAME;
	lblVersionValue.Caption  := 'Version '+ Common.m_sExeVerNameLog;
	lblComments.Caption := ' http://www.dongaeltek.co.kr' + #13#10 +
											' (14055) 12-24, Simin-daero 327beon-gil, Dongan-gu,' + #13#10 +
											' Anyang-si, Gyeonggi-do, South Korea' + #13#10 +
											' TEL : +82-31-345-1500' + #13#10 +
											' FAX : +82-31-421-4053';
end;
end.
