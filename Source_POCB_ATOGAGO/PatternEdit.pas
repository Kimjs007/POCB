unit PatternEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ImgList,
  RzRadChk, RzGrids, Vcl.ExtCtrls, RzLstBox, RzPanel, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, Vcl.ComCtrls, Vcl.StdCtrls, RzButton, RzCmboBx, Vcl.Mask,
  RzEdit, RzTabs, RzShellDialogs, Vcl.Buttons, DongaPattern, CommonClass,
  DefPocb, Winapi.ShellAPI, System.UITypes, ScriptClass, ExPat;

type
  TfrmPatternEdit = class(TForm)
    PnlGroup: TRzPanel;
    grpPGrpSelection: TRzGroupBox;
    grpPGrpName: TRzGroupBox;
    edPGrpName: TRzEdit;
    grpPGrpList: TRzGroupBox;
    lstPGrplist: TRzListBox;
    grpResiPCnt: TRzGroupBox;
    pnlPCnt: TRzPanel;
    edPCnt: TRzEdit;
    btnPGrpNew: TRzBitBtn;
    btnPGrpReName: TRzBitBtn;
    btnPGrpCopy: TRzBitBtn;
    btnPGrpDel: TRzBitBtn;
    grpPInfo: TRzGroupBox;
    grpResiPList: TRzGroupBox;
    HdrTimes: THeader;
    gridPatternList: TRzStringGrid;
    grpPName: TRzGroupBox;
    cboPName: TRzComboBox;
    grpVSync: TRzGroupBox;
    edVSync: TRzEdit;
    pnlHz: TRzPanel;
    chkVSync: TRzCheckBox;
    btnPInfoAdd: TRzBitBtn;
    btnPInfoModify: TRzBitBtn;
    btnPInfoUp: TRzBitBtn;
    btnPInfoDown: TRzBitBtn;
    btnPInfoDel: TRzBitBtn;
    grpPType: TRzGroupBox;
    cboPType: TRzComboBox;
    grpTime: TRzGroupBox;
    pnlSec: TRzPanel;
    edTime: TRzEdit;
    chkTime: TRzCheckBox;
    cboResolution: TRzComboBox;
    grpPPreview: TRzGroupBox;
    RzPanel17: TRzPanel;
    btnPGrpSave: TRzBitBtn;
    btnPGrpClose: TRzBitBtn;
    btnSPC: TRzBitBtn;
    imgPPreview: TDongaPat;
    procedure btnPGrpNewClick(Sender: TObject);
    procedure cboPTypeChange(Sender: TObject);
    procedure btnPGrpCopyClick(Sender: TObject);
    procedure btnPGrpReNameClick(Sender: TObject);
    procedure btnPGrpDelClick(Sender: TObject);
    procedure lstPGrplistClick(Sender: TObject);
    procedure gridPatternListClick(Sender: TObject);
    procedure cboResolutionChange(Sender: TObject);
    procedure btnPInfoAddClick(Sender: TObject);
    procedure btnPInfoModifyClick(Sender: TObject);
    procedure btnPInfoUpClick(Sender: TObject);
    procedure btnPInfoDownClick(Sender: TObject);
    procedure btnPInfoDelClick(Sender: TObject);
    procedure btnPGrpSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSPCClick(Sender: TObject);
    procedure btnPGrpCloseClick(Sender: TObject);
  private
    g_bNewPatGr: Boolean;
    g_bRenPatGr: Boolean;

    EditPatGrp    : TPatternGroup;
    procedure Display_PatGroup_data(DisplayPatGrp : TPatternGroup);
    procedure PatInfoBtnControl;
    procedure Load_data;
    procedure AddAndFindItemToListbox(tList: TRzListbox; sItem: string; bAdd, bFind: Boolean);
  public
    procedure Pattern_Init;
  end;

var
  frmPatternEdit: TfrmPatternEdit;
  rate_h, rate_v: Integer;
  PreviewType: Integer;

implementation

{$R *.dfm}

procedure TfrmPatternEdit.AddAndFindItemToListbox(tList: TRzListbox; sItem: string; bAdd, bFind: Boolean);
var
  i : Integer;
begin
  if bAdd then begin
    tList.Sorted := False;
    tList.Items.Add(sItem);
    tList.Sorted := True;
  end;

  if bFind then begin
    if sItem = '' then begin
      tList.ItemIndex := 0;
    end
    else begin
      for i := 0 to tList.Items.Count - 1 do begin
        if tList.Items.Strings[i] = sItem then begin
          tList.ItemIndex := i;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TfrmPatternEdit.btnPGrpCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPatternEdit.btnPGrpCopyClick(Sender: TObject);
begin
  edPGrpName.ReadOnly := False;
  edPGrpName.SelectAll;
  edPGrpName.SetFocus;

  g_bNewPatGr := True;
end;

procedure TfrmPatternEdit.btnPGrpDelClick(Sender: TObject);
var
  idx : Integer;
begin
	if lstPGrplist.ItemIndex < 0 then Exit;

  if MessageDlg(#13#10 + 'Are you sure to DELETE this Pattern Group?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    idx := lstPGrplist.ItemIndex;
		if idx > -1 then begin
			DeleteFile(Common.GetFilePath(lstPGrplist.Items.Strings[idx], PATGR_PATH));
			lstPGrplist.Items.Delete(idx);
			lstPGrplist.ItemIndex := idx - 1;
			if (lstPGrplist.ItemIndex = -1) and (lstPGrplist.Items.Count > 0) then
        lstPGrplist.ItemIndex := 0;
      lstPGrplistClick(nil);

      if lstPGrplist.Items.Count < 1 then begin
        edPGrpName.Text := '';
        cboPType.Text := 'Pattern';
        cboPTypeChange(nil);
        ChkVSync.Checked := False;
        ChkTime.Checked := True;
        edVSync.Text := 'None';
        edTime.Text := 'None';
        gridPatternList.RowCount := 1;
        gridPatternList.Rows[0].Clear;
      end;
    end;
  end;
end;

procedure TfrmPatternEdit.btnPGrpNewClick(Sender: TObject);
begin
  edPGrpName.ReadOnly := False;
  edPGrpName.Text := '';
  edPGrpName.SetFocus;

  cboPType.Text := 'Pattern';
  cboPTypeChange(nil);
  chkVSync.Checked := False;
  chkTime.Checked := True;

  edVSync.Text := 'None';
  edTime.Text := 'None';
  gridPatternList.RowCount := 1;
  gridPatternList.Rows[0].Clear;

  g_bNewPatGr := True;
end;

procedure TfrmPatternEdit.btnPGrpReNameClick(Sender: TObject);
begin
  edPGrpName.ReadOnly := False;
  edPGrpName.SelectAll;
  edPGrpName.SetFocus;

  g_bRenPatGr := True;
end;

procedure TfrmPatternEdit.btnPGrpSaveClick(Sender: TObject);
var
  i : Integer;
  sOldName, sNewName : String;
  SavePatGrp : TPatternGroup;
begin
  if edPGrpName.Text = '' then begin
    MessageDlg(#13#10 + 'Input Error! Please Insert the Pattern Group name.', mtError, [mbOK], 0);
    edPGrpName.ReadOnly := False;
    edPGrpName.SetFocus;
    g_bNewPatGr := True;
    Exit;
  end;

  if g_bNewPatGr then begin
    if FileExists(Common.GetFilePath(Trim(edPGrpName.Text), PATGR_PATH)) then begin
      MessageDlg(#13#10 + 'Input Error! Pattern Group Name [' + Trim(edPGrpName.Text) + '] is already Exist!', mtError, [mbOk], 0);
      edPGrpName.SetFocus;
      Exit;
    end;
  end;

  if g_bRenPatGr then begin
    sOldName := lstPGrplist.Items.Strings[lstPGrplist.ItemIndex];
    sNewName := Trim(edPGrpName.Text);
    if not RenameFile(Common.GetFilePath(sOldName, PATGR_PATH), Common.GetFilePath(sNewName, PATGR_PATH)) then begin
      edPGrpName.SelectAll;
      edPGrpName.SetFocus;
      Exit;
    end;
  end;


  SavePatGrp.GroupName  := edPGrpName.Text;
  SavePatGrp.PatCount   := StrToIntDef(edPCnt.Text,0);
  if SavePatGrp.PatCount > 0 then begin
    SetLength(SavePatGrp.PatType,SavePatGrp.PatCount);
    SetLength(SavePatGrp.VSync,SavePatGrp.PatCount);
    SetLength(SavePatGrp.LockTime,SavePatGrp.PatCount);
    SetLength(SavePatGrp.Option,SavePatGrp.PatCount);
    SetLength(SavePatGrp.PatName,SavePatGrp.PatCount);
    for i := 0 to Pred(SavePatGrp.PatCount) do begin
      if gridPatternList.Cells[0, i] = 'Pattern' then SavePatGrp.PatType[i] := DefPocb.PTYPE_NORMAL
      else                                            SavePatGrp.PatType[i] := DefPocb.PTYPE_BITMAP;
      SavePatGrp.PatName[i]  := trim(gridPatternList.Cells[1, i]);
      if gridPatternList.Cells[2, i] = 'None' then  SavePatGrp.VSync[i] := 0
      else                                          SavePatGrp.VSync[i] := StrToIntDef(gridPatternList.Cells[2, i],0);
      SavePatGrp.LockTime[i] := StrToIntDef(gridPatternList.Cells[3, i],0);
    end;
  end;

  if g_bNewPatGr then begin     // 새로운 Pattern Group 일 경우 List 및 ComboBox에 추가한다.
    AddAndFindItemToListbox(lstPGrplist, edPGrpName.Text, True, True);
    g_bNewPatGr := False;
  end;

  if g_bRenPatGr then begin
    lstPGrplist.Sorted := False;
    lstPGrplist.Items.Strings[lstPGrplist.ItemIndex] := sNewName;
    lstPGrplist.Sorted := True;
    AddAndFindItemToListbox(lstPGrplist, sNewName, False, True);
    g_bRenPatGr := False;
  end;
  Common.SavePatGroup(Trim(edPGrpName.Text),SavePatGrp);
  edPGrpName.ReadOnly := True;

  MessageDlg(#13#10 + 'Pattern Group Registration File Saving OK!', mtInformation, [mbOk], 0);

end;

procedure TfrmPatternEdit.btnPInfoAddClick(Sender: TObject);
var
  idx : Integer;
begin
  if cboPType.Text = '' then begin
    MessageDlg(#13#10 + 'Input Error! Pattern Type is Empty.', mtError, [mbOK], 0);
    cboPType.SetFocus;
    Exit;
  end;

  if cboPName.Text = '' then begin
    MessageDlg(#13#10 + 'Input Error! Pattern Name is Empty.', mtError, [mbOK], 0);
    cboPName.SetFocus;
    Exit;
  end;

  if chkVSync.Checked then begin
    if (StrToIntDef((edVSync.Text),0) < 20) or (StrToIntDef(edVSync.Text,200) > 180) then begin
      MessageDlg(#13#10 + 'Input Error! Vertical Frequency Range : [20 ~ 180 Hz].', mtError, [mbOK], 0);
      edVSync.SelectAll;
      edVSync.SetFocus;
      Exit;
    end;
  end;

  if chkTime.Checked then begin
    if (StrToIntDef(edTime.Text,-1) < 0) or (StrToIntDef(edTime.Text,100) > 60) then begin
      MessageDlg(#13#10 + 'Input Error! Pattern Display Time Range : [0 ~ 60 Sec].', mtError, [mbOK], 0);
      edTime.SelectAll;
      edTime.SetFocus;
      Exit;
    end;
  end;

  if gridPatternList.RowCount = 1 then begin
    if gridPatternList.Cells[0, 0] = '' then begin
      idx := 0;
    end
    else begin
      gridPatternList.RowCount := 2;
      idx := 1;
    end;
  end
  else begin
    gridPatternList.RowCount := gridPatternList.RowCount + 1;
    idx := gridPatternList.RowCount - 1;
  end;

  gridPatternList.Cells[0, idx] := cboPType.Text;
  gridPatternList.Cells[1, idx] := cboPName.Text;
  if chkVSync.Checked then  gridPatternList.Cells[2, idx] := edVSync.Text
  else                      gridPatternList.Cells[2, idx] := 'None';

  if chkTime.Checked then gridPatternList.Cells[3, idx] := edTime.Text
  else                    gridPatternList.Cells[3, idx] := '0';

  gridPatternList.Row := idx;
  edPCnt.Text := IntToStr(gridPatternList.RowCount);
  PatInfoBtnControl;
end;

procedure TfrmPatternEdit.btnPInfoDelClick(Sender: TObject);
var
  idx, i : Integer;
begin
  idx := gridPatternList.Row;

  gridPatternList.Rows[idx].Clear;

  if idx < gridPatternList.RowCount - 1 then begin
    for i := gridPatternList.Row to gridPatternList.RowCount - 2 do begin
      gridPatternList.Cells[0, i] := gridPatternList.Cells[0, i + 1];
      gridPatternList.Cells[1, i] := gridPatternList.Cells[1, i + 1];
      gridPatternList.Cells[2, i] := gridPatternList.Cells[2, i + 1];
      gridPatternList.Cells[3, i] := gridPatternList.Cells[3, i + 1];
    end;
  end;

  gridPatternList.RowCount := gridPatternList.RowCount - 1;
  gridPatternListClick(nil);

  if gridPatternList.RowCount = 1 then begin
    if gridPatternList.Cells[0, 0] = '' then
      edPCnt.Text := '0'
    else
      edPCnt.Text := '1';
  end
  else
    edPCnt.Text := IntToStr(gridPatternList.RowCount);

  PatInfoBtnControl;
end;

procedure TfrmPatternEdit.btnPInfoDownClick(Sender: TObject);
var
  idx : Integer;
  sTempType, sTempName, sTempVSync, sTempTime, sTempPn : String;
begin
  idx := gridPatternList.Row;

  if idx > gridPatternList.RowCount - 2 then Exit;

  sTempType   := gridPatternList.Cells[0, idx];
  sTempName   := gridPatternList.Cells[1, idx];
  sTempVSync  := gridPatternList.Cells[2, idx];
  sTempTime   := gridPatternList.Cells[3, idx];
  sTempPn     := gridPatternList.Cells[4, idx];

  gridPatternList.Cells[0, idx] := gridPatternList.Cells[0, idx + 1];
  gridPatternList.Cells[1, idx] := gridPatternList.Cells[1, idx + 1];
  gridPatternList.Cells[2, idx] := gridPatternList.Cells[2, idx + 1];
  gridPatternList.Cells[3, idx] := gridPatternList.Cells[3, idx + 1];
  gridPatternList.Cells[4, idx] := gridPatternList.Cells[4, idx + 1];

  gridPatternList.Cells[0, idx + 1] := sTempType;
  gridPatternList.Cells[1, idx + 1] := sTempName;
  gridPatternList.Cells[2, idx + 1] := sTempVSync;
  gridPatternList.Cells[3, idx + 1] := sTempTime;
  gridPatternList.Cells[4, idx + 1] := sTempPn;

  gridPatternList.Row := idx + 1;

  PatInfoBtnControl;
end;

procedure TfrmPatternEdit.btnPInfoModifyClick(Sender: TObject);
var
  idx : Integer;
begin
  if cboPType.Text = '' then begin
    MessageDlg(#13#10 + 'Input Error! Pattern Type is Empty.', mtError, [mbOK], 0);
    cboPType.SetFocus;
    Exit;
  end;

  if cboPName.Text = '' then begin
    MessageDlg(#13#10 + 'Input Error! Pattern Name is Empty.', mtError, [mbOK], 0);
    cboPName.SetFocus;
    Exit;
  end;

  if chkVSync.Checked then begin
    if (StrToIntDef(edVSync.Text,0) < 20) or (StrToIntDef(edVSync.Text,200) > 180) then begin
      MessageDlg(#13#10 + 'Input Error! Vertical Frequency Range : [20 ~ 180 Hz].', mtError, [mbOK], 0);
      edVSync.SelectAll;
      edVSync.SetFocus;
      Exit;
    end;
  end;

  if chkTime.Checked then begin
    if (StrToIntDef(edTime.Text,-1) < 0) or (StrToIntDef(edTime.Text,100) > 60) then begin
      MessageDlg(#13#10 + 'Input Error! Pattern Display Time Range : [0 ~ 60 Sec].', mtError, [mbOK], 0);
      edTime.SelectAll;
      edTime.SetFocus;
      Exit;
    end;
  end;

  idx := gridPatternList.Row;
  gridPatternList.Cells[0, idx] := cboPType.Text;
  gridPatternList.Cells[1, idx] := cboPName.Text;
  if chkVSync.Checked then gridPatternList.Cells[2, idx] := edVSync.Text
  else                    gridPatternList.Cells[2, idx] := 'None';
  if chkTime.Checked then gridPatternList.Cells[3, idx] := edTime.Text
  else                    gridPatternList.Cells[3, idx] := '0';
end;

procedure TfrmPatternEdit.btnPInfoUpClick(Sender: TObject);
var
  idx : Integer;
  sTempType, sTempName, sTempVSync, sTempTime : String;
begin
  idx := gridPatternList.Row;

  if idx < 1 then Exit;

  sTempType   := gridPatternList.Cells[0, idx];
  sTempName   := gridPatternList.Cells[1, idx];
  sTempVSync  := gridPatternList.Cells[2, idx];
  sTempTime   := gridPatternList.Cells[3, idx];

  gridPatternList.Cells[0, idx] := gridPatternList.Cells[0, idx - 1];
  gridPatternList.Cells[1, idx] := gridPatternList.Cells[1, idx - 1];
  gridPatternList.Cells[2, idx] := gridPatternList.Cells[2, idx - 1];
  gridPatternList.Cells[3, idx] := gridPatternList.Cells[3, idx - 1];

  gridPatternList.Cells[0, idx - 1] := sTempType;
  gridPatternList.Cells[1, idx - 1] := sTempName;
  gridPatternList.Cells[2, idx - 1] := sTempVSync;
  gridPatternList.Cells[3, idx - 1] := sTempTime;

  gridPatternList.Row := idx - 1;

  PatInfoBtnControl;
end;

procedure TfrmPatternEdit.btnSPCClick(Sender: TObject);
//var
//  Handle, hSpcWnd : HWND;
//  sParam : String;
begin
//  Handle := 0;
//  sParam := '/h:PGManager';
//
//  hSpcWnd := FindWindow(nil, 'S.P.C.');
//  if hSpcWnd = 0 then begin
//    ShellExecute(Handle, 'open', 'SPC.exe', PChar(sParam), PChar(Common.Path.Spc), SW_SHOWNORMAL);
//  end
//  else begin
//    MessageDlg(#13#10 + 'Pattern Editor Program (SPC) is Already Executed!', mtError, [mbOk], 0);
//  end;

  frmExPat := TfrmExPat.Create(nil);
  try
    frmExPat.ShowModal;
  finally
    Freeandnil(frmExPat);
  end;
end;

procedure TfrmPatternEdit.cboPTypeChange(Sender: TObject);
var
  Rslt, i: Integer;
  sFindFile, sPatName: string;
  SearchRec: TSearchRec;
begin
  if cboPType.Text = '' then begin
    cboPName.Items.Clear;
    Exit;
  end;

  cboPName.Sorted := False;
  cboPName.Items.Clear;

  if cboPType.ItemIndex = PTYPE_NORMAL then begin
    cboResolution.Visible := False;
    sFindFile := Common.Path.Pattern + '*.pat';
    for i :=0 to MAX_PATTERN_CNT -1 do begin
      if imgPPreview.InfoPat[i].pat.Info.isRegistered then begin
        sPatName := string(imgPPreview.InfoPat[i].pat.Data.PatName);
        cboPName.Items.Add(sPatName) ;
      end;
    end;
  end
  else if cboPType.ItemIndex = PTYPE_BITMAP then begin
    cboResolution.Visible := True;
    if cboResolution.ItemIndex = 0 then begin
      sFindFile := Common.Path.BMP + '*.bmp';
    end;

  end;

  Rslt := FindFirst(sFindFile, faAnyFile, SearchRec);
  cboPName.DisableAlign;
  while Rslt = 0 do  begin   // Pattern Folder에서 Pattern Name을 검색하여 ComboBox 에 삽입
    if Length(SearchRec.Name) > 4 then begin
      if cboResolution.Visible then begin
        if cboPType.ItemIndex = 0 then    sPatName := Copy(SearchRec.Name, 1, Length(SearchRec.Name) - 4)
        else                              sPatName := SearchRec.Name;
      end
      else begin
         sPatName := SearchRec.Name;
      end;
      cboPName.Items.Add(sPatName);      // ComboBox에 Pattern Name 추가
    end;
    Rslt := FindNext(Searchrec);
  end;
  FindClose(SearchRec);
  cboPName.EnableAlign;
//      cboResolutionChange(Sender);
  cboPName.ItemIndex := 0;
end;

procedure TfrmPatternEdit.cboResolutionChange(Sender: TObject);
var
  sl: TStringList;
begin
  cboPName.Clear;
  cboPName.Sorted := False;
  sl := Common.BmpGetKeyValueList(cboResolution.Text);
  try
    cboPName.Items.Assign(sl);
  finally
    sl.Free;
  end;
  cboPName.ItemIndex := 0;
end;

procedure TfrmPatternEdit.Display_PatGroup_data(DisplayPatGrp : TPatternGroup);
var
  i: Integer;
begin
  gridPatternList.RowCount := 1;
  gridPatternList.Rows[0].Clear;
  edPGrpName.Text := DisplayPatGrp.GroupName;
  edPCnt.Text := Format('%d',[DisplayPatGrp.PatCount]);
  if DisplayPatGrp.PatCount > 0 then begin
    gridPatternList.RowCount := DisplayPatGrp.PatCount;
    for i := 0  to Pred(DisplayPatGrp.PatCount) do begin
      gridPatternList.Cells[1, i] := DisplayPatGrp.PatName[i];
      case DisplayPatGrp.PatType[i] of
        DefPocb.PTYPE_NORMAL  : gridPatternList.Cells[0, i] := 'Pattern';
        DefPocb.PTYPE_BITMAP  : gridPatternList.Cells[0, i] := 'Bitmap';
      end;
      if DisplayPatGrp.VSync[i] = 0 then  gridPatternList.Cells[2, i] := 'None'
      else                                gridPatternList.Cells[2, i] := Format('%d',[DisplayPatGrp.VSync[i]]);
      gridPatternList.Cells[3, i] := Format('%d',[DisplayPatGrp.LockTime[i]]);
    end;
  end;
  gridPatternList.Row := 0;
  
end;

procedure TfrmPatternEdit.FormCreate(Sender: TObject);
var
  i: Integer;
  sl: TStringList;
begin
    // Form 항상 중앙 위치
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;

  // image preview set.
  imgPPreview.DongaUseSpc  := False;
  imgPPreview.DongaPatPath := Common.Path.Pattern;
  imgPPreview.DongaBmpPath := Common.Path.BMP;
  imgPPreview.DongaImgWidth := imgPPreview.Width;
  imgPPreview.DongaImgHight := imgPPreview.Height;
  imgPPreview.Stretch := True;
  imgPPreview.LoadAllPatFile;

  cboResolution.Items.Clear;
  sl := Common.BmpGetSectionList;
  try
    cboResolution.Items.Assign(sl);
  finally
    sl.Free;
  end;
  cboResolution.ItemIndex := 0;

  Load_data;
  for i := 0 to Pred(lstPGrplist.Count) do begin
    if lstPGrplist.Items[i] = Script.m_sPatGroup then begin
      lstPGrplist.ItemIndex := i;
      lstPGrplist.OnClick(nil);
      Break;
    end;
  end;
end;

procedure TfrmPatternEdit.gridPatternListClick(Sender: TObject);
var
  idx : Integer;
begin
  if gridPatternList.RowCount < 1 then
    Exit;

  idx := gridPatternList.Row;
  if AnsiCompareText(gridPatternList.Cells[0, idx], 'Pattern') = 0 then
    cboPType.ItemIndex := PTYPE_NORMAL
  else if AnsiCompareText(gridPatternList.Cells[0, idx], 'Bitmap') = 0 then
    cboPType.ItemIndex := PTYPE_BITMAP;
  cboPTypeChange(nil);
  cboPName.FindItem(gridPatternList.Cells[1, idx]);

  if (gridPatternList.Cells[2, idx] = '') or (gridPatternList.Cells[2, idx] = 'None') then begin
    edVSync.Text := 'None';
    chkVSync.Checked := False;
  end
  else begin
    edVSync.Text := gridPatternList.Cells[2, idx];
    chkVSync.Checked := True;
  end;

  if (gridPatternList.Cells[3, idx] = '') or (gridPatternList.Cells[3, idx] = '0') then begin
    edTime.Text := '0';
    chkTime.Checked := False;
  end
  else begin
    edTime.Text := gridPatternList.Cells[3, idx];
    chkTime.Checked := True;
  end;

  PatInfoBtnControl;

  imgPPreview.DrawPatAllPat(cboPType.ItemIndex, gridPatternList.Cells[1, idx]);
end;

procedure TfrmPatternEdit.Load_data;
var
  Rslt: Integer;
  sPatGrName: string;
  sr: TSearchRec;
begin
  lstPGrplist.Items.Clear;
  Rslt := FindFirst(Common.Path.PATTERNGROUP + '*.grp', FaanyFile, sr);
  while Rslt = 0 do
  begin
    sPatGrName := Copy(sr.Name, 1, Length(sr.Name) - 4);
    lstPGrplist.Items.Add(sPatGrName);        // ListBox에 Pattern Group Name 추가
    Rslt := FindNext(sr);
  end;
  FindClose(sr);
end;

procedure TfrmPatternEdit.lstPGrplistClick(Sender: TObject);
var
  idx: Integer;
begin
  edPGrpName.ReadOnly := True;
  g_bNewPatGr := False;

  idx := lstPGrplist.ItemIndex;
  if idx > -1 then
  begin
    EditPatGrp :=  Common.LoadPatGroup(lstPGrplist.Items.Strings[idx]);
//    Common.read_pattern_data(lstPGrplist.Items.Strings[idx]);
    Display_PatGroup_data(EditPatGrp);
    if gridPatternList.RowCount > 0 then gridPatternList.Row := 0;
    gridPatternList.OnClick(nil);
  end;

end;
procedure TfrmPatternEdit.PatInfoBtnControl;
begin
  if StrToIntDef(edPCnt.Text,0) > 0 then begin
    btnPInfoModify.Enabled := True;
    btnPInfoDel.Enabled := True;
  end
  else begin
    btnPInfoModify.Enabled := False;
    btnPInfoDel.Enabled := False;
  end;

  if gridPatternList.Row = 0 then  btnPInfoUp.Enabled := False
  else                             btnPInfoUp.Enabled := True;

  if gridPatternList.Row = gridPatternList.RowCount - 1 then  btnPInfoDown.Enabled := False
  else                                                        btnPInfoDown.Enabled := True;
end;

procedure TfrmPatternEdit.Pattern_Init;
begin
//  if imgPPreview.Picture <> nil then
//    imgPPreview.Picture := nil;

end;

end.

