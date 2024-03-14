unit ModelSelect_A2CH;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, 
  RzButton, RzPanel, RzLstBox,
  DefPocb, LogicPocb, CommonClass;

type
  TfrmSelectModel = class(TForm)
    Panel_Header: TRzPanel;
    RzPanel1: TRzPanel;
    btnCancel: TRzBitBtn;
    btnOk: TRzBitBtn;
    RzgrpModelListCh1: TRzGroupBox;
    lstModelCh1: TRzListBox;
    RzgrpModelListCh2: TRzGroupBox;
    lstModelCh2: TRzListBox;
{$IFDEF REF_ISPD}	
    cbbModelType: TComboBox;
{$ENDIF}	
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure ModelListBoxKeyPress(Sender: TObject; var Key: Char);
    procedure IntegerKeyPress(Sender: TObject; var Key: Char);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lstModelCh1DblClick(Sender: TObject); //A2CHv3:MULTIPLE_MODEL
    procedure lstModelCh2DblClick(Sender: TObject); //A2CHv3:MULTIPLE_MODEL
    procedure lstModelCh1Click(Sender: TObject);    //A2CHv3:MULTIPLE_MODEL
    procedure lstModelCh2Click(Sender: TObject);    //A2CHv3:MULTIPLE_MODEL
    {$IFDEF SUPPORT_1CG2PANEL}
  //function GetAssyModelInfo(sModelName: string; var AssyModelInfo: TAssyModelInfo): Boolean; //TBD:REMOTE_UPDATE:MoveFromModelSelectToCommon?
    function CheckAssyPocbModelSelect: Boolean;
    {$ENDIF}
  private
    { Private declarations }
    procedure Load_Model;
    procedure FindItemToListbox(tList: TRzListbox; sItem: string);
//  function CheckModelDownload(sModelName : string) : Boolean;
  public
    { Public declarations }
    m_bClickOkBtn : Boolean;
  end;

var
  frmSelectModel: TfrmSelectModel;

implementation

{$R *.dfm}

//******************************************************************************
// procedure/function: Create/Destroy/Init
//******************************************************************************

procedure TfrmSelectModel.FormCreate(Sender: TObject);
begin
  Common.MLog(DefPocb.SYS_LOG,'<M/C> Window Open');
{$IFDEF REF_ISPD}
  cbbModelType.Clear;
  cbbModelType.Items.Add('ALL Model');
  cbbModelType.ItemIndex := 0;
{$ENDIF}
  Load_Model;
  m_bClickOkBtn := False;
end;

procedure TfrmSelectModel.FormActivate(Sender: TObject);
begin
  if lstModelCh1.CanFocus then lstModelCh1.SetFocus;
  if lstModelCh2.CanFocus then lstModelCh2.SetFocus;
end;

procedure TfrmSelectModel.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Common.MLog(DefPocb.SYS_LOG,'<M/C> Window Close');
  CanClose := True;
end;

//******************************************************************************
// procedure/function: Button
//******************************************************************************

procedure TfrmSelectModel.btnOkClick(Sender: TObject);   //A2CHv3:MULTIPLE_MODEL
var
  fNameCh1, fNameCh2 : String;
begin
  if (lstModelCh1.ItemIndex >= 0) and (lstModelCh2.ItemIndex >= 0) then begin
    if MessageDlg(#13#10 + 'Are you sure to change Model?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin //2023-06-07
      m_bClickOkBtn := False;
      Exit;
    end;
    //
    fNameCh1 := Trim(lstModelCh1.Items[lstModelCh1.Itemindex]);
    Common.SystemInfo.TestModel[DefPocb.CH_1] := fNameCh1;
    fNameCh2 := Trim(lstModelCh2.Items[lstModelCh2.Itemindex]);
    Common.SystemInfo.TestModel[DefPocb.CH_2] := fNameCh2;
    Common.SaveSystemInfo;
    //
    Common.LoadModelInfo(DefPocb.CH_1,fNameCh1);
    Common.LoadModelInfo(DefPocb.CH_2,fNameCh2);
    Common.SetEdModel2TestModel;
    //
    m_bClickOkBtn := True;
    //
    Close;
  end;
end;

procedure TfrmSelectModel.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSelectModel.ModelListBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btnOkClick(nil);
end;

procedure TfrmSelectModel.IntegerKeyPress(Sender: TObject; var Key: Char);
begin
  if not (AnsiChar(Key) in ['0'..'9', #8, #13]) then Key := #0;
end;

procedure TfrmSelectModel.lstModelCh1Click(Sender: TObject); //A2CHv3:MULTIPLE_MODEL
begin
  {$IFDEF SUPPORT_1CG2PANEL}
  if (not Common.SystemInfo.UseAssyPOCB) then begin
  {$ENDIF}
    lstModelCh2.ItemIndex := lstModelCh1.ItemIndex;
  {$IFDEF SUPPORT_1CG2PANEL}
  end
  else begin
    if CheckAssyPocbModelSelect then btnOK.Enabled := True   // CH1/CH2 ModelInfo Interlock
    else                             btnOK.Enabled := False;
  end;
  {$ENDIF}
end;

procedure TfrmSelectModel.lstModelCh2Click(Sender: TObject); //A2CHv3:MULTIPLE_MODEL
begin
  {$IFDEF SUPPORT_1CG2PANEL}
  if (not Common.SystemInfo.UseAssyPOCB) then begin
  {$ENDIF}
    lstModelCh1.ItemIndex := lstModelCh2.ItemIndex;
  {$IFDEF SUPPORT_1CG2PANEL}
  end
  else begin
    if CheckAssyPocbModelSelect then btnOK.Enabled := True   // CH1/CH2 ModelInfo Interlock
    else                             btnOK.Enabled := False;
  end;
  {$ENDIF}
end;

procedure TfrmSelectModel.lstModelCh1DblClick(Sender: TObject); //A2CHv3:MULTIPLE_MODEL
begin
  {$IFDEF SUPPORT_1CG2PANEL}
  if (not Common.SystemInfo.UseAssyPOCB) then begin
  {$ENDIF}
    lstModelCh2.ItemIndex := lstModelCh1.ItemIndex;
    btnOkClick(nil);
  {$IFDEF SUPPORT_1CG2PANEL}
  end
  else begin
    if CheckAssyPocbModelSelect then btnOK.Enabled := True   // CH1/CH2 ModelInfo Interlock
    else                             btnOK.Enabled := False;
  end;
  {$ENDIF}
end;

procedure TfrmSelectModel.lstModelCh2DblClick(Sender: TObject); //A2CHv3:MULTIPLE_MODEL
begin
  {$IFDEF SUPPORT_1CG2PANEL}
  if (not Common.SystemInfo.UseAssyPOCB) then begin
  {$ENDIF}
    lstModelCh1.ItemIndex := lstModelCh2.ItemIndex;
    btnOkClick(nil);
  {$IFDEF SUPPORT_1CG2PANEL}
  end
  else begin
    if CheckAssyPocbModelSelect then btnOK.Enabled := True   // CH1/CH2 ModelInfo Interlock
    else                             btnOK.Enabled := False;
  end;
  {$ENDIF}
end;

{$IFDEF SUPPORT_1CG2PANEL}
function TfrmSelectModel.CheckAssyPocbModelSelect: Boolean; //TBD:REMOTE_UPDATE:MoveFromModelSelectToCommon?
var
  sModelNameCh1, sModelNameCh2: string;
begin
  sModelNameCh1 := Trim(lstModelCh1.Items[lstModelCh1.Itemindex]);
  sModelNameCh2 := Trim(lstModelCh2.Items[lstModelCh2.Itemindex]);
  //
  Result := Common.CheckAssyPocbModelSelect(sModelNameCh1,sModelNameCh2);
end;
{$ENDIF} //SUPPORT_1CG2PANEL

//******************************************************************************
// procedure/function: Submethods
//******************************************************************************

procedure TfrmSelectModel.Load_Model;
var
  Rslt    : Integer;
  sr      : TSearchrec;
begin
  lstModelCh1.Clear;

  lstModelCh1.DisableAlign;
  Rslt := FindFirst(Common.Path.MODEL+ '*.mcf', FaAnyFile, sr);  //POCB-specific
  while Rslt = 0 do begin
    lstModelCh1.Items.Add(Copy(sr.Name, 1, pos('.mcf', sr.Name) - 1));
    Rslt := FindNext(sr);
  end;

  FindClose(sr);
  lstModelCh1.Sorted := True;

  if lstModelCh1.Items.Count > 0 then begin
    FindItemToListbox(lstModelCh1, Common.SystemInfo.TestModel[DefPocb.CH_1]);
  end;
  lstModelCh1.EnableAlign;

  // CH2    //A2CHv3:MULTIPLE_MODEL
  lstModelCh2.Clear;

  lstModelCh2.DisableAlign;
  Rslt := FindFirst(Common.Path.MODEL+ '*.mcf', FaAnyFile, sr);  //POCB-specific
  while Rslt = 0 do begin
    lstModelCh2.Items.Add(Copy(sr.Name, 1, pos('.mcf', sr.Name) - 1));
    Rslt := FindNext(sr);
  end;

  FindClose(sr);
  lstModelCh2.Sorted := True;

  if lstModelCh2.Items.Count > 0 then begin
    FindItemToListbox(lstModelCh2, Common.SystemInfo.TestModel[DefPocb.CH_2]);
  end;
  lstModelCh2.EnableAlign;
end;

procedure TfrmSelectModel.FindItemToListbox(tList: TRzListbox; sItem: string);
var
  i : Integer;
begin
  for i := 0 to tList.Items.Count - 1 do begin
    if tList.Items.Strings[i] = sItem then begin
      tList.ItemIndex := i;
      Break;
    end;
  end;
end;

end.
