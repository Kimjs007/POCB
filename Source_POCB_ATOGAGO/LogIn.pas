unit LogIn;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, {System.UITypes,} Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzPanel, Vcl.StdCtrls, Vcl.Mask, RzEdit, RzButton,
  AdvSmoothTouchKeyBoard, RzLabel, CommonClass, Vcl.Imaging.pngimage,
{$IFDEF DFS_DEFECT}
  Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
{$ENDIF}
  DefPocb;

type
  TfrmLogIn = class(TForm)
    AdvSmoothTouchKeyBoard1: TAdvSmoothTouchKeyBoard;
    btnCancel: TRzBitBtn;
    btnOK: TRzBitBtn;
    edUserID: TRzEdit;
    pnlUserID: TRzPanel;
    pnlPassword: TRzPanel;
    edPassword: TRzEdit;
    lblManFlag: TRzLabel;
    RzBitBtn1: TRzBitBtn;
    img1: TImage;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure RzBitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
{$IFDEF DFS_EXTRA}
    class function CheckAdminPasswd(nMode: Integer = 0): Boolean;
{$ELSE}
    class function CheckAdminPasswd: Boolean;
{$ENDIF}
{$IFDEF DFS_EXTRA}
    m_nMode : Integer;
{$ENDIF}
  end;

var
  frmLogIn: TfrmLogIn;

implementation

{$R *.dfm}

procedure TfrmLogIn.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
	Close;
end;

procedure TfrmLogIn.btnOKClick(Sender: TObject);
begin
{$IFDEF DFS_EXTRA}
  if m_nMode = 0 then begin
    if CompareText(edPassword.Text, Common.SystemInfo.Password) <> 0 then begin
      MessageDlg(#13#10 + 'Incorrect Admin Password!', mtError, [mbOk], 0);
      edPassword.Text := '';
      edPassword.SelectAll;
      edPassword.SetFocus;
    end
    else
      ModalResult := mrOK;
  end
  else begin
    if not (Length(edUserId.Text) in [5..9]) then begin
      if 'PM' = edUserId.Text then begin
        Common.m_sUserId := Trim(edUserId.Text);
        ModalResult := mrOK;
      end
      else begin
        MessageDlg('Retry to input User ID number !', mtWarning, [mbOk], 0);
        edUserId.Text := '';
        if edUserId.CanFocus then edUserId.SetFocus;
        ModalResult := mrNone;
      end;
    end
    else begin
      Common.m_sUserId := Trim(edUserId.Text);
      ModalResult := mrOK;
    end;
    Common.CheckAuthority(Trim(edUserId.Text), Trim(edPassword.Text));
  end;
{$ELSE}
  if CompareText(edPassword.Text, Common.SystemInfo.Password) <> 0 then begin
		MessageDlg(#13#10 + 'Incorrect Admin Password!', mtError, [mbOk], 0);
		edPassword.Text := '';
		edPassword.SelectAll;
		edPassword.SetFocus;
  end
  else
		ModalResult := mrOK;
{$ENDIF}
end;

procedure TfrmLogIn.edPasswordKeyPress(Sender: TObject; var Key: Char);
var
	Handle:THandle;
begin
	if key = #27 { ESC } then
		ModalResult := mrCancel
	else if (ActiveControl is TRzEdit) and (key = #13) then begin
		Handle := GetFocus;
		if Handle = edPassword.Handle then
			btnOKClick(Self)
		else
      SelectNext(ActiveControl, True, True);
	end
  else if (ActiveControl is TRzBitBtn) and (key = #13) then
		btnOKClick(Self);
end;

procedure TfrmLogIn.FormCreate(Sender: TObject);
begin
  self.Height := 164;
  case Common.SystemInfo.Language of
    DefPocb.LANGUAGE_KOREA : begin
      lblManFlag.Caption := 'Input User ID (사원번호)';
      pnlUserId.Caption := 'User ID';
    end;
    DefPocb.LANGUAGE_VIETNAM : begin
      lblManFlag.Caption := 'Input Admin password (Số nhân viên)';
      pnlUserId.Caption  := 'Số nhân viê';
    end;
  end;
end;

procedure TfrmLogIn.FormShow(Sender: TObject);
begin
{$IFDEF DFS_EXTRA}
//edUserID.MaxLength   := 6; //사번 6자 제한  // 2019-01-04 ksw : 제한 해제  //TBD:DFS?
//edPassword.MaxLength := 32; //암호 32자 제한  // 2019-01-04 ksw : 제한 해제  //TBD:DFS?
{$ELSE}
	edUserID.MaxLength := 6; //사번 6자 제한
	edPassword.MaxLength := 32; //암호 32자 제한
{$ENDIF}

	lblManFlag.Caption := 'Input Admin Password...';
{$IFDEF DFS_EXTRA}
  if m_nMode = 0 then begin
    edUserId.Text    := Common.m_sUserId;
    edUserId.Enabled := False;
    edPassword.SetFocus;
  end
  else begin
    edUserID.Enabled := True;
    edUserID.SetFocus;
  end;
{$ELSE}
	edUserId.Text    := 'ADMIN';
	edUserId.Enabled := False;
	edPassword.SetFocus;
{$ENDIF}
end;

procedure TfrmLogIn.RzBitBtn1Click(Sender: TObject);
begin
  if Self.Height = 164 then begin
    Self.Height  := 346;
  end
  else begin
    self.Height := 164;
  end;
{$IFDEF DFS_EXTRA}
  if edUserID.Text = '' then edUserID.SetFocus
  else                       edPassword.SetFocus;
{$ELSE}
  edPassword.SetFocus;
{$ENDIF}
end;

{$IFDEF DFS_EXTRA}
class function TfrmLogIn.CheckAdminPasswd(nMode: Integer = 0): Boolean;
{$ELSE}
class function TfrmLogIn.CheckAdminPasswd: Boolean;
{$ENDIF}
var
  frmLogIn : TfrmLogIn;
  bRet : Boolean;
begin
  bRet := False;
  frmLogIn := TfrmLogIn.Create(Application);
  try
    frmLogIn.Caption := 'Confirm Admin Password';
    {$IFDEF DFS_EXTRA}
    frmLogIn.m_nMode := nMode;
    {$ENDIF}
    if frmLogIn.ShowModal = mrOK then begin
      frmLogIn.Update;
	  bRet := True;
    end;
  finally
    frmLogIn.Free;
    frmLogIn := nil;
  end;
  Result := bRet;
end;

end.
