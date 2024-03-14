unit UserId;

interface
{$I Common.inc}

uses
  Winapi.Windows, System.SysUtils, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, {System.UITypes,}
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Graphics, System.Classes, Winapi.ShellAPI, RzPanel, RzButton,
  RzEdit, Vcl.ImgList, Vcl.Mask, DefPocb, AdvSmoothTouchKeyBoard, CommonClass, System.ImageList;
//  Mask, RzEdit,  RzRadChk, Vcl.Buttons, RzSpnEdt, Vcl.ImgList, Vcl.StdCtrls;

type
  TUserIdDlg = class(TForm)
    RzPanel2: TRzPanel;
    Btn_Cancel: TRzBitBtn;
    Btn_OK: TRzBitBtn;
    RzpnlMesUserId: TRzPanel;
    edMesUserId: TRzEdit;
    il1: TImageList;
    btn1: TRzBitBtn;
    RzPanel1: TRzPanel;
    Image_Pat1: TImage;
    AdvSmoothPopupTouchKeyBoard1: TAdvSmoothPopupTouchKeyBoard;
    lblLbManFlag: TLabel;
    RzpnlMesPwd: TRzPanel;
    edMesPwd: TRzEdit;
    procedure Btn_OKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Btn_CancelClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UserIdDlg: TUserIdDlg;

implementation


{$R *.DFM}

procedure TUserIdDlg.Btn_OKClick(Sender: TObject);
begin
  if not (Length(edMesUserId.Text) in [5..20]) then begin
    if UpperCase(edMesUserId.Text) = 'PM' then begin
      {$IFDEF SITE_LENSVN}
      if CompareText(edMesPwd.Text, Common.SystemInfo.Password_PM) <> 0 then begin
        MessageDlg('Retry to input PM Password !', mtWarning, [mbOk], 0);
        edMesUserId.Text := '';
        if edMesUserId.CanFocus then edMesUserId.SetFocus;
        ModalResult := mrNone;
      end
      else begin
      {$ENDIF}
        Common.m_sUserId := 'PM';
        ModalResult := mrOK;
      {$IFDEF SITE_LENSVN}
      end;
      {$ENDIF}
    end
    else begin
      MessageDlg('Retry to input User ID number !', mtWarning, [mbOk], 0);
      edMesUserId.Text := '';
      if edMesUserId.CanFocus then edMesUserId.SetFocus;
      ModalResult := mrNone;
    end;
  end
  else begin
    Common.m_sUserId  := Trim(edMesUserId.Text);
{$IFDEF SITE_LENSVN}
    Common.m_sUserPwd := Trim(edMesPwd.Text);
{$ENDIF}
    ModalResult := mrOK;
  end;
end;

procedure TUserIdDlg.btn1Click(Sender: TObject);
begin
  AdvSmoothPopupTouchKeyBoard1.Show;
  SelectNext(ActiveControl, True, True);
//  AdvSmoothPopupTouchKeyBoard1.ShowAtXY(self.Top div 2,Self.Left);
end;

procedure TUserIdDlg.Btn_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TUserIdDlg.FormShow(Sender: TObject);
begin
//  UserId.MaxLength := 9;    //사번 9자 제한
  //Password.MaxLength := 32; //암호 32자 제한

//  lblLbManFlag.Caption := 'Input User ID';
  edMesUserId.SetFocus;
end;

procedure TUserIdDlg.FormCreate(Sender: TObject);
begin
{$IFDEF SITE_LENSVN}
  RzpnlMesPwd.Visible := True;
  edMesPwd.Visible    := True;
{$ELSE}
  RzpnlMesPwd.Visible := False;
  edMesPwd.Visible    := False;
{$ENDIF}

  if Common.SystemInfo.Language = DefPocb.LANGUAGE_KOREA then begin
    lblLbManFlag.Caption := 'Input User ID';
    RzpnlMesUserId.Caption := 'User ID';
  end
  else if Common.SystemInfo.Language = DefPocb.LANGUAGE_VIETNAM then begin
    lblLbManFlag.Caption := 'Input User ID (Mã nhân viên)' + #13#10 + 'and Password';
    RzpnlMesUserId.Caption  := 'USER ID (Mã nhân viên)';
{$IFDEF SITE_LENSVN}
    RzpnlMesPwd.Caption  := 'Password';;
{$ENDIF}
  end
  else begin
    lblLbManFlag.Caption := 'Input User ID';
    RzpnlMesUserId.Caption := 'User ID';
  end;
end;

procedure TUserIdDlg.FormKeyPress(Sender: TObject; var Key: Char);
var
  Handle:THandle;
begin
  if key = #27 { ESC } then
    ModalResult := mrCancel
  else if (ActiveControl is TRzEdit) and (key = #13) then begin
    Handle := GetFocus;
    if Handle = edMesUserId.Handle then
      Btn_OKClick(Self)
    else
      SelectNext(ActiveControl, True, True);
  end
  else if (ActiveControl is TRzBitBtn) and (key = #13) then
    Btn_OKClick(Self);
end;

end.
