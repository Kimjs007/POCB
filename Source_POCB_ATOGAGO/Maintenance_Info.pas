unit Maintenance_Info;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  AdvOfficePager,
  AdvOfficePagerStylers,
  AdvGlowButton,
  Vcl.ExtCtrls,
  Vcl.Imaging.pngimage,
  AdvGlassButton;

type
  TFrm_M_INFO = class(TForm)
    PG_MOR: TAdvOfficePager;
    PG_RF: TAdvOfficePage;
    IMG_RF: TImage;
    STY: TAdvOfficePagerOfficeStyler;
    PL_BUTTON: TPanel;
    Btn_OPEN: TAdvGlowButton;
    Btn_SAVE: TAdvGlowButton;
    OD: TOpenDialog;
    BtnClose: TAdvGlassButton;
    procedure PG_MORTabDblClick(Sender: TObject; PageIndex: Integer);
    procedure Btn_OPENClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_M_INFO: TFrm_M_INFO;

implementation

uses
  MainPocb_A2CH;

{$R *.dfm}

procedure TFrm_M_INFO.BtnCloseClick(Sender: TObject);
begin
  Close();
end;

procedure TFrm_M_INFO.Btn_OPENClick(Sender: TObject);
begin
  try
    with OD do begin
      Title := 'Select Image File';
    //  DefaultExt := GetAppDir('DATA');  // 시스템 이미지

      if Execute then begin
        case PG_MOR.ActivePageIndex of

          0:
            begin

              //Save INI
            end;
          1:
            begin
              IMG_RF.Hint := OD.FileName;
              IMG_RF.Picture.LoadFromFile(IMG_RF.Hint);
              //Save INI
            end;
        end;
      end;
    end;
  except
  end;
end;

procedure TFrm_M_INFO.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.AlphaBlendValue := 255;
end;

procedure TFrm_M_INFO.PG_MORTabDblClick(Sender: TObject; PageIndex: Integer);
begin
  if PL_BUTTON.Visible then
    PL_BUTTON.Visible := False
  else
    PL_BUTTON.Visible := True;
end;

end.

