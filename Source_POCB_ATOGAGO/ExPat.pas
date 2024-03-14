unit ExPat;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, CommonClass, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DongaPattern, Vcl.Mask, RzEdit, RzButton, Vcl.Buttons, RzPanel, RzCmboBx, RzShellDialogs, Vcl.Menus;

const
	PAT_TOOL_EDIT					= 0;
	PAT_TOOL_ADD					= 1;
	PAT_TOOL_COPY					= 2;

type
  TfrmExPat = class(TForm)
    grpPatList: TGroupBox;
    lstPatList: TListBox;
    grp2: TGroupBox;
    DongaPat1: TDongaPat;
    pnlPatName: TPanel;
    pnl2: TPanel;
    grpToolList: TGroupBox;
    lstTool: TListBox;
    grp4: TGroupBox;
    btnSave: TRzBitBtn;
    btnClose: TRzBitBtn;
    pnl1: TPanel;
    GroupBox9: TRzGroupBox;
    btnDrawDelete: TBitBtn;
    btnDrawUp: TBitBtn;
    btnDrawDown: TBitBtn;
    btnDrawAdd: TRzBitBtn;
    btnDrawEdit: TRzBitBtn;
    GroupBox3: TRzGroupBox;
    btnBox: TSpeedButton;
    btnCircle: TSpeedButton;
    btnTriangle: TSpeedButton;
    btnLine: TSpeedButton;
    btnLoop: TSpeedButton;
    btnCopy: TSpeedButton;
    btnHGray: TSpeedButton;
    btnCGray: TSpeedButton;
    btnFBox: TSpeedButton;
    btnFCircle: TSpeedButton;
    btnFTriangle: TSpeedButton;
    btnXYLoop: TSpeedButton;
    btnPaste: TSpeedButton;
    btnVGray: TSpeedButton;
    btn2CGray: TSpeedButton;
    btn2HGray: TSpeedButton;
    btn2VGray: TSpeedButton;
    GroupBox6: TRzGroupBox;
    lblSX: TLabel;
    lblEX: TLabel;
    lblMX: TLabel;
    lblSY: TLabel;
    lblEY: TLabel;
    lblMY: TLabel;
    edSX: TRzEdit;
    edSY: TRzEdit;
    edEX: TRzEdit;
    edEY: TRzEdit;
    edMX: TRzEdit;
    edMY: TRzEdit;
    GroupBox4: TRzGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lblGl: TLabel;
    cboBColor: TRzComboBox;
    cboGColor: TRzComboBox;
    cboRColor: TRzComboBox;
    edBColor: TRzEdit;
    edGColor: TRzEdit;
    edRColor: TRzEdit;
    Btn8Bit: TRzBitBtn;
    GroupBox7: TRzGroupBox;
    lbl4: TLabel;
    lbl5: TLabel;
    CB_level: TRzComboBox;
    CB_direction: TRzComboBox;
    edPatName: TRzEdit;
    btnChangName: TBitBtn;
    btnPatternCreate: TBitBtn;
    btnPatternDelete: TBitBtn;
    btnPtnUp: TBitBtn;
    btnPtnDown: TBitBtn;
    pnlToolName: TPanel;
    PanelColor8: TRzPanel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    edR8: TRzEdit;
    edG8: TRzEdit;
    edB8: TRzEdit;
    BtnInput: TRzBitBtn;
    BtnColor8Cancel: TRzBitBtn;
    pm1: TPopupMenu;
    SaveAsSinglePattern1: TMenuItem;
    OpenSinglePattern1: TMenuItem;
    odlgSinglePattern: TRzOpenDialog;
    sdlgPopup: TRzSaveDialog;
    ClearAllPatternList1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure lstPatListClick(Sender: TObject);
    procedure lstToolClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnChangNameClick(Sender: TObject);
    procedure btnPatternCreateClick(Sender: TObject);
    procedure btnPatternDeleteClick(Sender: TObject);
    procedure btnPtnUpClick(Sender: TObject);
    procedure btnPtnDownClick(Sender: TObject);
    procedure btnDrawUpClick(Sender: TObject);
    procedure btnDrawDownClick(Sender: TObject);
    procedure btnDrawDeleteClick(Sender: TObject);
    procedure btnDrawEditClick(Sender: TObject);
    procedure ToolItemClick(Sender: TObject);
    procedure btnDrawAddClick(Sender: TObject);
    procedure Btn8BitClick(Sender: TObject);
    procedure BtnInputClick(Sender: TObject);
    procedure BtnColor8CancelClick(Sender: TObject);
    procedure SaveAsSinglePattern1Click(Sender: TObject);
    procedure OpenSinglePattern1Click(Sender: TObject);
    procedure ClearAllPatternList1Click(Sender: TObject);
  private
    { Private declarations }
    m_ToolSel, m_ToolType : Integer;

    procedure DisplayPatList;
    procedure DisplayToolList(nIdx : Integer);
    procedure MakeToolEdit(nPat, nTool : Integer);
    procedure CheckToolItem(nBtnIdx : Integer);
    procedure GetToolData(nEditType : Integer);
    procedure SetTextData(sSX, sSY, sEX, sEY, sMX, sMY: AnsiString);
    procedure SetPosition(sSX, sEX, sMX: AnsiString; bSX, bSY, bEX, bEY, bMX, bMY: Boolean);
    procedure SetTextGray(b1, b2: Boolean);
    procedure SetPalColor(pl, tl, pal_num: Integer);
    procedure SelectColor(nSel: Integer);
    procedure GetPalColor(pl, tl, pal_num: Integer);
    function  GetPalString(pal_num: Integer): AnsiString;
    procedure SetCopyToPat(nPatNum : Integer);
    procedure GetCopyfromPat(nPatNum : Integer);
    function SetConvertTool(sToolName: string; nToolIndex: Integer) : string;
    Function BitSetDiv(nGray : Integer) : Integer;
  public
    { Public declarations }
  end;

var
  frmExPat: TfrmExPat;

implementation

{$R *.dfm}
{$IFDEF REF_SDIP}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF}
{$WARN IMPLICIT_STRING_CAST OFF}
{$ENDIF}

function TfrmExPat.BitSetDiv(nGray: Integer): Integer;
begin
  if nGray > MAX_GRAY then nGray := MAX_GRAY;
  Result := nGray;
end;

procedure TfrmExPat.Btn8BitClick(Sender: TObject);
var
  nTemp : Integer;
begin
  try
    //R
    nTemp := StrToIntDef(edRColor.Text,0) div 16;
    if nTemp < 0 then nTemp := 0;
    if nTemp > 4095 then nTemp := 4095;
    edR8.Text := IntToStr(nTemp);

    //G
    nTemp := StrToIntDef(edGColor.Text,0) div 16;
    if nTemp < 0 then nTemp := 0;
    if nTemp > 4095 then nTemp := 4095;
    edG8.Text := IntToStr(nTemp);

    //B
    nTemp := StrToIntDef(edBColor.Text,0) div 16;
    if nTemp < 0 then nTemp := 0;
    if nTemp > 4095 then nTemp := 4095;
    edB8.Text := IntToStr(nTemp);
    PanelColor8.Visible := False;
  except
     edRColor.Text := '0';
     edGColor.Text := '0';
     edBColor.Text := '0';
  end;

  PanelColor8.Visible := true;
end;

procedure TfrmExPat.btnChangNameClick(Sender: TObject);
var
  sSelName : AnsiString;
  nSelPat  : Integer;
begin
  if not edPatName.Enabled then begin
    edPatName.Enabled := True;
    Exit;
  end;
  sSelName := AnsiString(edPatName.Text);
  nSelPat := lstPatList.ItemIndex;
  fillChar(DongaPat1.InfoPat[nSelPat].pat.Data.PatName,30,#0);
  move(sSelName[1],DongaPat1.InfoPat[nSelPat].pat.Data.PatName[0],Length(sSelName));
  DisplayPatList;
  lstPatList.Selected[nSelPat] := True;
  edPatName.Enabled := False;
end;

procedure TfrmExPat.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmExPat.BtnColor8CancelClick(Sender: TObject);
begin
  PanelColor8.Visible := False;
end;

procedure TfrmExPat.btnDrawAddClick(Sender: TObject);
begin
  GetToolData(PAT_TOOL_ADD);
end;

procedure TfrmExPat.btnDrawDeleteClick(Sender: TObject);
var
  i, nPat, nStart, nDelTotal, nListTotal: Integer;
  nSelList : integer;
begin
	nPat := lstPatList.ItemIndex;
  nSelList  := lstTool.ItemIndex;
	if nPat = -1 then Exit;
    i := 0; nStart := 0; nDelTotal := 0;
    nListTotal := lstTool.Items.Count;
    while i < nListTotal do begin
        if lstTool.Selected[i] then begin
            nStart := i;
            inc(nDelTotal);
        end;
        Inc(i);
    end;
    nStart := nStart - nDelTotal +1;

	for i := 0 to (nListTotal - (nStart+nDelTotal))-1 do
		DongaPat1.InfoPat[nPat].Tool[nStart+i] := DongaPat1.InfoPat[nPat].Tool[nStart+nDelTotal+i];
	for i := 0 to nDelTotal-1 do begin
		DongaPat1.InfoPat[nPat].Tool[nListTotal- nDelTotal +i].into.isRegistered := False;
		FillChar(DongaPat1.InfoPat[nPat].Tool[nListTotal- nDelTotal +i].into.ToolName,30,#0);
		FillChar(DongaPat1.InfoPat[nPat].Tool[nListTotal- nDelTotal +i],130,#0);
		dec(DongaPat1.InfoPat[nPat].Pat.Data.ToolCnt);
	end;

	while (nDelTotal <> 0) do begin
		lstTool.Items.Delete(nStart);
		dec(nDelTotal);
	end;
  if nSelList <> 0 then lstTool.ItemIndex := nSelList - 1;
end;

procedure TfrmExPat.btnDrawDownClick(Sender: TObject);
var
	nPat, nTool: Integer;
	i, nStart, nDnTotal, nLstTotal: Integer;
  TempPatInfo         : TPatternInfo;
begin
	nPat := lstPatList.ItemIndex;
	if nPat = -1 then Exit;
  nTool  := lstTool.ItemIndex;
  if nTool = -1 then exit;

	i := 0; nStart := 0; nDnTotal := 0;
	nLstTotal := lstTool.Items.Count;
    while i < nLstTotal do begin
        if lstTool.Selected[i] then begin
            nStart := i;
            inc(nDnTotal);
        end;
        Inc(i);
    end;
    nStart := nStart - nDnTotal +1;
	if (nStart = nLstTotal-1) then Exit;
	TempPatInfo.Tool[0] := DongaPat1.InfoPat[nPat].Tool[nStart+nDnTotal];
	for i := nDnTotal downto 1 do
		DongaPat1.InfoPat[nPat].Tool[nStart+i] := DongaPat1.InfoPat[nPat].Tool[nStart-1+i];
	DongaPat1.InfoPat[nPat].Tool[nStart] := TempPatInfo.Tool[0];
	lstTool.Items.Clear;
	for i := 0 to DongaPat1.InfoPat[nPat].Pat.Data.ToolCnt-1 do
		lstTool.Items.Insert(i, string(DongaPat1.InfoPat[nPat].Tool[i].into.ToolName));
	//lstTool.ItemIndex := lstTool.Items.Count -1;
  if nTool< lstTool.Items.Count then
    lstTool.ItemIndex := nTool+1;
  lstTool.SetFocus;
end;

procedure TfrmExPat.btnDrawEditClick(Sender: TObject);
begin
  if lstTool.ItemIndex < 0 then Exit;
  GetToolData(PAT_TOOL_EDIT);
end;

procedure TfrmExPat.btnDrawUpClick(Sender: TObject);
var
	nPat, nTool: Integer;
	i, nStart, nUpTotal: Integer;
  TempPatInfo         : TPatternInfo;
begin
	nPat := lstPatList.ItemIndex;
	if nPat = -1 then Exit;
  nTool  := lstTool.ItemIndex;
  if nTool = -1 then exit;

	i := 0; nStart := 0; nUpTotal := 0;
  while i < lstTool.Items.Count do begin
    if lstTool.Selected[i] then begin
      nStart := i;
      inc(nUpTotal);
    end;
    Inc(i);
  end;
  nStart := nStart - nUpTotal +1;
	if nStart = 0 then Exit;
	TempPatInfo.Tool[0] := DongaPat1.InfoPat[nPat].Tool[nStart-1];
	for i := 0 to nUpTotal-1 do
		DongaPat1.InfoPat[nPat].Tool[nStart-1+i] := DongaPat1.InfoPat[nPat].Tool[nStart+i];
	DongaPat1.InfoPat[nPat].Tool[nStart-1+nUpTotal] := TempPatInfo.Tool[0];
	lstTool.Items.Clear;
	for i := 0 to DongaPat1.InfoPat[nPat].pat.Data.ToolCnt-1 do
		lstTool.Items.Insert(i, string(DongaPat1.InfoPat[nPat].Tool[i].into.ToolName) );
//	lstTool.ItemIndex := lstTool.Items.Count -1;
  lstTool.ItemIndex := nTool-1;
  lstTool.SetFocus;
end;

procedure TfrmExPat.BtnInputClick(Sender: TObject);
var
  nTemp : Integer;
begin
  try
    //R
    nTemp := StrToIntDef(edR8.Text,0) * 16;
    if nTemp < 0 then nTemp := 0;
    if nTemp > 4095 then nTemp := 4095;
    edRColor.Text := IntToStr(nTemp);

    //G
    nTemp := StrToIntDef(edG8.Text,0) * 16;
    if nTemp < 0 then nTemp := 0;
    if nTemp > 4095 then nTemp := 4095;
    edGColor.Text := IntToStr(nTemp);

    //B
    nTemp := StrToIntDef(edB8.Text,0) * 16;
    if nTemp < 0 then nTemp := 0;
    if nTemp > 4095 then nTemp := 4095;
    edBColor.Text := IntToStr(nTemp);

    PanelColor8.Visible := False;

  except
     edRColor.Text := '0';
     edGColor.Text := '0';
     edBColor.Text := '0';
  end;
end;

procedure TfrmExPat.btnPatternCreateClick(Sender: TObject);
var
  nCnt, i   : Integer;
  sTemp : AnsiString;
begin
  if not edPatName.Enabled then begin
    edPatName.Enabled := True;
    edPatName.Text := '';
    Exit;
  end;
  if Length(Trim(edPatName.Text)) = 0 then begin
    MessageDlg('You should input Pattern name!!.', mtWarning,[mbOk],0);
    Exit;
  end;
  nCnt := lstPatList.Items.Count;
  lstTool.Items.Clear;
  DongaPat1.DrawPatAllClear;
  DongaPat1.InfoPat[nCnt].Pat.Info.isRegistered := True;
  sTemp := Trim(edPatName.Text);
  fillchar(DongaPat1.InfoPat[nCnt].Pat.Data.PatName[0],30,#0);
  move(sTemp[1],DongaPat1.InfoPat[nCnt].Pat.Data.PatName[0],length(sTemp));
  DongaPat1.InfoPat[nCnt].pat.Data.ToolCnt := 0;
  for i := 0 to MAX_TOOL_CNT-1 do begin
    DongaPat1.InfoPat[nCnt].Tool[i].into.isRegistered := False;
    FillChar(DongaPat1.InfoPat[nCnt].Tool[i].into.ToolName,30,#0);
    FillChar(DongaPat1.InfoPat[nCnt].Tool[i],134,#0);
  end;
  lstPatList.Items.Insert(nCnt, Trim(edPatName.Text));
  lstPatList.ItemIndex := lstPatList.Items.Count -1;

  edPatName.Enabled := False;
end;

procedure TfrmExPat.btnPatternDeleteClick(Sender: TObject);
var
  i, j, nStartList, nDelTotal, nListTotal: Integer;
  nSelList : Integer;
begin
  i := 0; nStartList := 0; nDelTotal := 0;
  if lstPatList.ItemIndex = -1 then
    MessageDlg('You should select Pattern first!!.', mtWarning,[mbOk],0);
  nSelList := lstPatList.ItemIndex;

  nListTotal := lstPatList.Items.Count;
  while i < nListTotal do begin
    if lstPatList.Selected[i] then begin
      nStartList := i;
      inc(nDelTotal);
    end;
    Inc(i);
  end;

  nStartList := nStartList - nDelTotal +1;
  if (nStartList < 0) or (nStartList > nListTotal -1) then
    MessageDlg('You should select Pattern first!!.', mtWarning,[mbOk],0)
  else begin
    for i := 0 to (nListTotal - (nStartList+nDelTotal))-1 do
      DongaPat1.InfoPat[nStartList+i] := DongaPat1.InfoPat[nStartList+nDelTotal+i];

    for i := 0 to nDelTotal-1 do begin
      DongaPat1.InfoPat[nListTotal-nDelTotal+i].pat.Info.isRegistered := False;
      FillChar(DongaPat1.InfoPat[nListTotal-nDelTotal+i].Pat.Data.PatName,30,#0);
      for j := 0 to DongaPat1.InfoPat[nListTotal-nDelTotal+i].pat.Data.ToolCnt-1 do
      begin
        DongaPat1.InfoPat[nListTotal-nDelTotal+i].Tool[j].into.isRegistered := False;
        FillChar(DongaPat1.InfoPat[nListTotal-nDelTotal+i].Tool[j].into.ToolName,30,#0);
        FillChar(DongaPat1.InfoPat[nListTotal-nDelTotal+i].Tool[j],134,#0);
      end;
    end;

		while (nDelTotal <> 0) do begin
      lstPatList.Items.Delete(nStartList);
			dec(nDelTotal);
		end;

    if nSelList <> 0 then begin
      lstPatList.ItemIndex := nSelList-1;
      lstPatList.OnClick(nil);
    end;
  end;
end;

procedure TfrmExPat.btnPtnDownClick(Sender: TObject);
var
	nSelPat       : Integer;
  strTmpPatInfo : TPatternInfo;
begin
	nSelPat := lstPatList.ItemIndex;
	if nSelPat >= lstPatList.Items.Count-1 then Exit;

  Move(DongaPat1.InfoPat[nSelPat+1],strTmpPatInfo,sizeof(strTmpPatInfo));
  move(DongaPat1.InfoPat[nSelPat],DongaPat1.InfoPat[nSelPat+1],sizeof(strTmpPatInfo));
  move(strTmpPatInfo,DongaPat1.InfoPat[nSelPat],sizeof(strTmpPatInfo));

  DisplayPatList;
  lstPatList.Selected[nSelPat +1] := True;
end;

procedure TfrmExPat.btnPtnUpClick(Sender: TObject);
var
	nSelPat       : Integer;
  strTmpPatInfo : TPatternInfo;
begin
	nSelPat := lstPatList.ItemIndex;
	if nSelPat < 1 then Exit;

  Move(DongaPat1.InfoPat[nSelPat-1],strTmpPatInfo,sizeof(strTmpPatInfo));
  move(DongaPat1.InfoPat[nSelPat],DongaPat1.InfoPat[nSelPat-1],sizeof(strTmpPatInfo));
  move(strTmpPatInfo,DongaPat1.InfoPat[nSelPat],sizeof(strTmpPatInfo));

  lstPatList.Clear;
  DisplayPatList;
  lstPatList.Selected[nSelPat -1] := true;
end;

procedure TfrmExPat.btnSaveClick(Sender: TObject);
begin
  if DongaPat1.SaveAllPatFile then ShowMessage('AllPat.dat Saved OK!');
end;

procedure TfrmExPat.CheckToolItem(nBtnIdx: Integer);
var
  sTemp : string;
begin
  btnLine.Flat       := False;
  btnBox.Flat        := False;
  btnFBox.Flat       := False;
  btnTriangle.Flat   := False;
  btnFTriangle.Flat  := False;
  btnCircle.Flat     := False;
  btnFCircle.Flat    := False;
  btnHGray.Flat      := False;
  btnVGray.Flat      := False;
  btnCGray.Flat      := False;
  btn2HGray.Flat     := False;
  btn2VGray.Flat     := False;
  btn2CGray.Flat     := False;
  btnCopy.Flat       := False;
  btnPaste.Flat      := False;
  btnLoop.Flat       := False;
  btnXYLoop.Flat     := False;

  case nBtnIdx of
    ALL_LINE        : btnLine.Flat      := True;
    ALL_BOX         : btnBox.Flat       := True;
    ALL_FILL_BOX    : btnFBox.Flat      := True;
    ALL_TRI         : btnTriangle.Flat  := True;
    ALL_FILL_TRI    : btnFTriangle.Flat := True;
    ALL_CIRCLE      : btnCircle.Flat    := True;
    ALL_FILL_CIRCLE : btnFCircle.Flat   := True;
    ALL_H_GRAY      : btnHGray.Flat     := True;
    ALL_V_GRAY      : btnVGray.Flat     := True;
    ALL_C_GRAY      : btnCGray.Flat     := True;
    ALL_BLK_COPY    : btnCopy.Flat      := True;
    ALL_BLK_PASTE   : btnPaste.Flat     := True;
    ALL_LOOP        : btnLoop.Flat      := True;
    ALL_XYLOOP      : btnXYLoop.Flat    := True;
    ALL_H_GRAY2     : btn2HGray.Flat     := True;
    ALL_V_GRAY2     : btn2VGray.Flat     := True;
    ALL_C_GRAY2     : btn2CGray.Flat     := True;
  end;

  case nBtnIdx of
    ALL_LINE        : sTemp := 'LINE';
    ALL_BOX         : sTemp := 'BOX';
    ALL_FILL_BOX    : sTemp := 'FILL_BOX';
    ALL_TRI         : sTemp := 'TRI';
    ALL_FILL_TRI    : sTemp := 'FILL_TRI';
    ALL_CIRCLE      : sTemp := 'CIRCLE';
    ALL_FILL_CIRCLE : sTemp := 'FILL_CIRCLE';
    ALL_H_GRAY      : sTemp := 'HORIZONTAL_GRAY';
    ALL_V_GRAY      : sTemp := 'VERTICAL_GRAY';
    ALL_C_GRAY      : sTemp := 'COLOR_GRAY';
    ALL_BLK_COPY    : sTemp := 'BLOCK_COPY';
    ALL_BLK_PASTE   : sTemp := 'BLOCK_PASTE';
    ALL_LOOP        : sTemp := 'LOOP';
    ALL_XYLOOP      : sTemp := 'XYLOOP';
    ALL_H_GRAY2     : sTemp := 'HORIZONTAL_GRAY2';
    ALL_V_GRAY2     : sTemp := 'VERTICAL_GRAY2';
    ALL_C_GRAY2     : sTemp := 'COLOR_GRAY2';
  end;
  pnlToolName.Caption := sTemp;
end;

procedure TfrmExPat.ClearAllPatternList1Click(Sender: TObject);
begin
  edPatName.Text := '';
  lstPatList.Clear;
  lstTool.Clear;
end;

procedure TfrmExPat.DisplayPatList;
var
  i         : Integer;
  sPatName  : string;
begin
  lstPatList.Clear;
  lstPatList.Sorted := False;
  for i :=0 to MAX_PATTERN_CNT -1 do begin
    if DongaPat1.InfoPat[i].pat.Info.isRegistered then begin
      sPatName := string(DongaPat1.InfoPat[i].pat.Data.PatName);
      lstPatList.Items.Add(sPatName) ;
    end;
  end;
//  lstPatList.Sorted := True;
  lstPatList.ItemIndex := 0;
end;

procedure TfrmExPat.DisplayToolList(nIdx : Integer);
var
  i     : Integer;
  sTool : string;
begin
  lstTool.Clear;
  for i := 0 to pred(DongaPat1.InfoPat[nIdx].pat.Data.ToolCnt) do begin
    sTool := string(DongaPat1.InfoPat[nIdx].Tool[i].into.ToolName);
    lstTool.Items.Add(sTool);
  end;
  if lstTool.ItemIndex > -1 then lstTool.ItemIndex := 0;
end;

procedure TfrmExPat.FormCreate(Sender: TObject);
begin
  if Common <> nil then begin
    DongaPat1.DongaPatPath  := Common.Path.Pattern;//.m_sPatFilePath;
    DongaPat1.DongaBmpPath  := Common.Path.BMP;//DongaYT.m_sBmpPath;
  end;
//  DongaPat1.DongaPatPath  := ExtractFilePath(Application.ExeName)+'Pattern\pat\';
  DongaPat1.DongaImgWidth := DongaPat1.Width;
  DongaPat1.DongaImgHight := DongaPat1.Height;
  DongaPat1.LoadAllPatFile;
  DisplayPatList;
  MakeToolEdit(0,0);
end;

procedure TfrmExPat.GetCopyfromPat(nPatNum: Integer);
var
  i : Integer;
  sTemp  : AnsiString;
begin
  DongaPat1.InfoPat[nPatNum].Pat.Info.isRegistered       := DongaPat1.InfoOnePat.Pat.Info.isRegistered;
  DongaPat1.InfoPat[nPatNum].Pat.Data.PatName            := DongaPat1.InfoOnePat.Pat.Data.PatName;
  DongaPat1.InfoPat[nPatNum].Pat.Data.ToolCnt            := DongaPat1.InfoOnePat.Pat.Data.ToolCnt;
  lstTool.Clear;
  for i := 0 to DongaPat1.InfoOnePat.Pat.Data.ToolCnt-1 do begin
    DongaPat1.InfoPat[nPatNum].Tool[i].Into.isRegistered := DongaPat1.InfoOnePat.Tool[i].Into.isRegistered;
    sTemp                                              := SetConvertTool(strPas(DongaPat1.InfoOnePat.Tool[i].Into.ToolName), i);
    move(sTemp[1],DongaPat1.InfoPat[nPatNum].Tool[i].Into.ToolName[0],Length(sTemp));
    lstTool.Items.Add(sTemp);
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.ToolType     := DongaPat1.InfoOnePat.Tool[i].Data.ToolType;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.Direction    := DongaPat1.InfoOnePat.Tool[i].Data.Direction;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.Level        := DongaPat1.InfoOnePat.Tool[i].Data.Level;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.sx           := DongaPat1.InfoOnePat.Tool[i].Data.sx;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.sy           := DongaPat1.InfoOnePat.Tool[i].Data.sy;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.ex           := DongaPat1.InfoOnePat.Tool[i].Data.ex;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.ey           := DongaPat1.InfoOnePat.Tool[i].Data.ey;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.mx           := DongaPat1.InfoOnePat.Tool[i].Data.mx;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.my           := DongaPat1.InfoOnePat.Tool[i].Data.my;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.R            := DongaPat1.InfoOnePat.Tool[i].Data.R;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.G            := DongaPat1.InfoOnePat.Tool[i].Data.G;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.B            := DongaPat1.InfoOnePat.Tool[i].Data.B;
    DongaPat1.InfoPat[nPatNum].Tool[i].Data.PalNum       := DongaPat1.InfoOnePat.Tool[i].Data.PalNum;
  end;
end;

procedure TfrmExPat.GetPalColor(pl, tl, pal_num: Integer);
var
    sR, sG, sB: String;
begin
  sR := edRColor.Text;
  sG := edGColor.Text;
  sB := edBColor.Text;

	DongaPat1.InfoPat[pl].Tool[tl].Data.R := strtointDef(sR,0);
	DongaPat1.InfoPat[pl].Tool[tl].Data.G := strtointDef(sG,0);
	DongaPat1.InfoPat[pl].Tool[tl].Data.B := strtointDef(sB,0);
end;

function TfrmExPat.GetPalString(pal_num: Integer): AnsiString;
var
  sR, sG, sB: String;
begin
  sR := edRColor.Text;
  sG := edGColor.Text;
  sB := edBColor.Text;
	Result := AnsiString('DC('+Trim(sR)+','+Trim(sG)+','+Trim(sB)+')');
end;

procedure TfrmExPat.GetToolData(nEditType: Integer);
var
	nGrayLevel, nToolType : Integer;
	sToolName             : AnsiString;
  nPat, nTool           : Integer;
begin
  //nGrayLevel := 8;
  nPat := lstPatList.ItemIndex;
	if nEditType = PAT_TOOL_EDIT then begin
		nTool := lstTool.ItemIndex;
		FillChar(DongaPat1.InfoPat[nPat].Tool[nTool].Data,134,#0);
		FillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,30,#0);
	end
	else if nEditType = PAT_TOOL_ADD then begin
    nTool := lstTool.Items.Count;
		inc(DongaPat1.InfoPat[nPat].pat.Data.ToolCnt);
	end
  else nTool := lstTool.Items.Count;
	DongaPat1.InfoPat[nPat].Tool[nTool].into.isRegistered := True;
  nToolType := m_ToolType;
	case nToolType of
		ALL_LINE: begin
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum := $ff;
			sToolName := AnsiString('LINE:'+ 'S('+edSX.Text+','+edSY.Text+'),E('+edEX.Text+','+edEY.Text+'),');
      sToolName := sToolName + GetPalString(DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			GetPalColor(nPat,nTool,DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex , AnsiString(edEX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey , AnsiString(edEY.Text));
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_BOX: begin
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum := $ff;
			sToolName := AnsiString('BOX:'+ 'S('+edSX.Text+','+edSX.Text+'),E('+edEX.Text+','+edEY.Text+'),');
      sToolName := sToolName + GetPalString(DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			GetPalColor(nPat,nTool,DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex , AnsiString(edEX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey , AnsiString(edEY.Text));
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_CIRCLE: begin
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum := $ff;
			sToolName := AnsiString('CIRCLE:'+'S('+edSX.Text+','+edSY.Text+'),R('+edMX.Text+','+edMY.Text+'),');
      sToolName := sToolName+GetPalString(DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			GetPalColor(nPat,nTool,DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.mx , AnsiString(edMX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.my , AnsiString(edMY.Text));
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_TRI: begin
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum := $ff;
			sToolName := AnsiString('TRI:'+ 'S('+edSX.Text+','+edSY.Text+'),E('+edEX.Text+','+edEY.Text+'),T(');
      sToolName := sToolName + AnsiString(edMX.Text+','+edMY.Text+'),');
      sToolName := sToolName + GetPalString(DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			GetPalColor(nPat,nTool,DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex , AnsiString(edEX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey , AnsiString(edEY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.mx , AnsiString(edMX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.my , AnsiString(edMY.Text));
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_LOOP: begin
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
			if nPat = PAT_TOOL_ADD then begin
				sToolName := AnsiString('LOOP:'+'TOOL('+inttostr(m_ToolSel+1)+'),CNT('+edEX.Text+'),STEP('+edSX.Text+','+edSY.Text+')');
				DongaPat1.InfoPat[nPat].Tool[nTool].Data.Direction := nToolType+1;
			end
			else begin
				sToolName := AnsiString('LOOP:'+'TOOL('+inttostr(m_ToolSel-1)+'),CNT('+edEX.Text+'),STEP('+edSX.Text+','+edSY.Text+')');
				DongaPat1.InfoPat[nPat].Tool[nTool].Data.Direction := m_ToolSel-1;
			end;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex , AnsiString(edEX.Text));
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_XYLOOP: begin
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
			if nEditType = PAT_TOOL_ADD then begin
				sToolName := AnsiString('XYLOOP:'+'TOOL('+inttostr(m_ToolSel)+'),CNT('+edEX.Text+','+edEY.Text);
        sToolName := sToolName +AnsiString('),STEP('+edSX.Text+','+edSY.Text+')');
				DongaPat1.InfoPat[nPat].Tool[nTool].Data.Direction := m_ToolSel;
			end
			else begin
				sToolName := AnsiString('XYLOOP:'+'TOOL('+inttostr(m_ToolSel-1)+'),CNT('+edEX.Text+','+edEY.Text);
        sToolName := sToolName +AnsiString('),STEP('+edSX.Text+','+edSY.Text+')');
				DongaPat1.InfoPat[nPat].Tool[nTool].Data.Direction := m_ToolSel-1;
			end;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex , AnsiString(edEX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey , AnsiString(edEY.Text));
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_FILL_BOX: begin
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum := $ff;
			sToolName := AnsiString('F_BOX:'+ 'S('+edSX.Text+','+edSY.Text+'),E('+edEX.Text+','+edEY.Text+'),');
      sToolName := sToolName + GetPalString(DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			GetPalColor(nPat,nTool,DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex , AnsiString(edEX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey , AnsiString(edEY.Text));
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_FILL_CIRCLE: begin
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum := $ff;
			sToolName := 'F_CIRCLE:'+AnsiString('S('+edSX.Text+','+edSY.Text+'),R('+edMX.Text+','+edMY.Text+'),');
      sToolName := sToolName + GetPalString(DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			GetPalColor(nPat,nTool,DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.mx , AnsiString(edMX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.my , AnsiString(edMY.Text));
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_FILL_TRI: begin
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum := $ff;
			sToolName := AnsiString('F_TRI:'+'S('+edSX.Text+','+edSY.Text+'),E('+edEX.Text+','+edEY.Text+')');
      sToolName := sToolName + AnsiString(',T('+edMX.Text+','+edMY.Text+'),');
      sToolName := sToolName + GetPalString(DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			GetPalColor(nPat,nTool,DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex , AnsiString(edEX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey , AnsiString(edEY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.mx , AnsiString(edMX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.my , AnsiString(edMY.Text));
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_BLK_COPY: begin
			sToolName := AnsiString('BLK_COPY:'+ 'S('+edSX.Text+','+edSY.Text+'),E('+edEX.Text+','+edEY.Text+')');
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex , AnsiString(edEX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey , AnsiString(edEY.Text));
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_BLK_PASTE: begin
      DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
			sToolName := AnsiString('BLK_PASTE:'+'S('+edSX.Text+','+edSY.Text+')');
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_H_GRAY, ALL_H_GRAY2: begin
      if nToolType = ALL_H_GRAY then   sToolName := 'H_GRAY:'
      else                          sToolName := 'H_GRAY2:';
			sToolName := sToolName + AnsiString('S('+edSX.Text+','+edSY.Text+'),E('+edEX.Text+','+edEY.Text+')');
      sToolName := sToolName + AnsiString(',GC('+inttostr(cboRColor.ItemIndex)+',');
      sToolName := sToolName + AnsiString(inttostr(cboGColor.ItemIndex)+','+ inttostr(cboBColor.ItemIndex)+')');
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum := $ff;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex , AnsiString(edEX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey , AnsiString(edEY.Text));
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.Direction := CB_direction.ItemIndex;
      nGrayLevel := strtointDef(CB_level.Text,0);
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.Level := nGrayLevel;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.R := cboRColor.ItemIndex;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.G := cboGColor.ItemIndex;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.B := cboBColor.ItemIndex;
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_V_GRAY, ALL_V_GRAY2: begin
      if nToolType = ALL_V_GRAY then   sToolName := 'V_GRAY:'
      else                          sToolName := 'V_GRAY2:';
			sToolName := sToolName + AnsiString('S('+edSX.Text+','+edSY.Text+'),E('+edEX.Text+','+edEY.Text+')');
      sToolName := sToolName + AnsiString(',GC('+inttostr(cboRColor.ItemIndex)+',');
      sToolName := sToolName + AnsiString(inttostr(cboGColor.ItemIndex)+','+ inttostr(cboBColor.ItemIndex)+')');
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum := $ff;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex , AnsiString(edEX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey , AnsiString(edEY.Text));
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.Direction := CB_direction.ItemIndex;
            nGrayLevel := strtointDef(CB_level.Text,0);
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.Level := nGrayLevel;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.R := cboRColor.ItemIndex;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.G := cboGColor.ItemIndex;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.B := cboBColor.ItemIndex;
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;
		ALL_C_GRAY, ALL_C_GRAY2: begin
      if nToolType = ALL_C_GRAY then   sToolName := 'C_GRAY:'
      else                             sToolName := 'C_GRAY2:';
			sToolName := sToolName + AnsiString('S('+edSX.Text+','+edSY.Text+'),E('+edEX.Text+','+edEY.Text+')');
      sToolName := sToolName + AnsiString(',GC('+inttostr(cboRColor.ItemIndex)+',');
      sToolName := sToolName + AnsiString(inttostr(cboGColor.ItemIndex)+','+ inttostr(cboBColor.ItemIndex)+')');
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum := $ff;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType := nToolType;
      strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx , AnsiString(edSX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy , AnsiString(edSY.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex , AnsiString(edEX.Text));
			strPCopy(DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey , AnsiString(edEY.Text));
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.Direction := CB_direction.ItemIndex;
            nGrayLevel := strtointDef(CB_level.Text,0);
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.Level := nGrayLevel;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.R := cboRColor.ItemIndex;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.G := cboGColor.ItemIndex;
			DongaPat1.InfoPat[nPat].Tool[nTool].Data.B := cboBColor.ItemIndex;
			fillChar(DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName,100,#0);
      Move(sToolName[1],DongaPat1.InfoPat[nPat].Tool[nTool].into.ToolName, Length(sToolName));
		end;

	end; //case...of
	/////////////
	if nEditType = PAT_TOOL_EDIT then lstTool.Items.Delete(nTool);
	lstTool.Items.Insert(nTool, string(sToolName));
  if nEditType = PAT_TOOL_EDIT then lstTool.ItemIndex := nTool;
  Sleep(100);
  DongaPat1.DrawPatAllClear;
  DongaPat1.DrawPatAllTool(nPat,nTool);
end;

procedure TfrmExPat.lstPatListClick(Sender: TObject);
var
  sSelPat   : string;
  nPatIdx   : Integer;
begin
  nPatIdx := lstPatList.ItemIndex;
  sSelPat := lstPatList.Items[nPatIdx];
  pnlPatName.Caption  := sSelPat;
  edPatName.Text      := sSelPat;
  DongaPat1.DrawPatAllPat(0,sSelPat);
  DisplayToolList(nPatIdx);
  MakeToolEdit(nPatIdx,0);
  grpPatList.Caption := 'User Pattern List ('+ IntToStr(lstPatList.Items.Count)+' EA)';
  grpToolList.Caption := 'Pattern Creating Tool ('+ IntToStr(lstTool.Items.Count)+' EA)';
end;

procedure TfrmExPat.lstToolClick(Sender: TObject);
var
  nPat, nTool : Integer;
begin
  nPat    := lstPatList.ItemIndex;
  nTool   := lstTool.ItemIndex;
  m_ToolSel := nTool;
  DongaPat1.DrawPatAllClear;
  DongaPat1.DrawPatAllTool(nPat,nTool);
  MakeToolEdit(nPat,nTool);
end;

procedure TfrmExPat.MakeToolEdit(nPat, nTool: Integer);
var
  nToolType : Integer;
begin
  nToolType := DongaPat1.InfoPat[nPat].Tool[nTool].Data.ToolType;
  m_ToolType  := nToolType;
  CheckToolItem(nToolType);
  case nToolType of
    ALL_LINE, ALL_BOX, ALL_FILL_BOX: begin
      SetPosition('Start X:','End X:','',True,True,True,True,False,False);
      SetTextGray(False,False);
      SetPalColor(nPat,nTool,DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
      SetTextData(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx, DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy,
                  DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex, DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey,
                  '', '');
    end;
    ALL_TRI, ALL_FILL_TRI: begin
      SetPosition('Start X:','End X:','Tri X:',True,True,True,True,True,True);
      SetTextGray(False,False);
      SetPalColor(nPat,nTool,DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
      SetTextData(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx, DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy,
                  DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex, DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey,
                  DongaPat1.InfoPat[nPat].Tool[nTool].Data.mx, DongaPat1.InfoPat[nPat].Tool[nTool].Data.my);
    end;
    ALL_CIRCLE, ALL_FILL_CIRCLE: begin
      SetPosition('Center X:','','Radius X:',True,True,False,False,True,True);
      SetTextGray(False,False);
      SetPalColor(nPat,nTool,DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
      SetTextData(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx, DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy,
                  '', '',
                  DongaPat1.InfoPat[nPat].Tool[nTool].Data.mx, DongaPat1.InfoPat[nPat].Tool[nTool].Data.my);
    end;
    ALL_H_GRAY, ALL_V_GRAY, ALL_C_GRAY, ALL_H_GRAY2, ALL_V_GRAY2, ALL_C_GRAY2: begin
      SetPosition('Start X:','End X:','',True,True,True,True,False,False);
      SetTextGray(False,True);
      SetPalColor(nPat,nTool,DongaPat1.InfoPat[nPat].Tool[nTool].Data.PalNum);
      SelectColor(GRAY_COLOR);
      SetTextData(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx, DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy,
                  DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex, DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey,
                  '', '');
      CB_direction.ItemIndex := DongaPat1.InfoPat[nPat].Tool[nTool].Data.Direction;

      case DongaPat1.InfoPat[nPat].Tool[nTool].Data.Level of
        8   : CB_level.ItemIndex := 0;
        16  : CB_level.ItemIndex := 1;
        32  : CB_level.ItemIndex := 2;
        64  : CB_level.ItemIndex := 3;
        128 : CB_level.ItemIndex := 4;
        256 : CB_level.ItemIndex := 5;
        512 : CB_level.ItemIndex := 6;
        1024: CB_level.ItemIndex := 7;
        2048: CB_level.ItemIndex := 8;
        4096: CB_level.ItemIndex := 9;
      end;
      //CB_level.Text := inttostr(DongaPat1.InfoPat[nPat].Tool[nTool].Data.Level);
      cboRColor.ItemIndex := DongaPat1.InfoPat[nPat].Tool[nTool].Data.R;
      cboGColor.ItemIndex := DongaPat1.InfoPat[nPat].Tool[nTool].Data.G;
      cboBColor.ItemIndex := DongaPat1.InfoPat[nPat].Tool[nTool].Data.B;
    end;
    ALL_BLK_COPY: begin
      SetPosition('Start X:','End X:','',True,True,True,True,False,False);
      SetTextGray(False,False);
      SelectColor(NO_COLOR);
      edRColor.Text := ''; edGColor.Text := ''; edBColor.Text := '';
      SetTextData(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx, DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy,
                  DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex, DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey,
                  '', '');
    end;
    ALL_BLK_PASTE: begin
      SetPosition('Start X:','End X:','',True,True,False,False,False,False);
      SetTextGray(False,False);
      SelectColor(NO_COLOR);
      edRColor.Text := ''; edGColor.Text := ''; edBColor.Text := '';
      SetTextData(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx, DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy,
                  '', '', '', '');
    end;
    ALL_LOOP: begin
      SetPosition('Step X:','Count X:','',True,True,True,False,False,False);
      SetTextGray(False,False);
      SelectColor(NO_COLOR);
      edRColor.Text := ''; edGColor.Text := ''; edBColor.Text := '';
      SetTextData(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx, DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy,
                  DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex, '', '', '');
    end;

    ALL_XYLOOP: begin
      SetPosition('Step X:','Count X:','',True,True,True,True,False,False);
      SetTextGray(False,False);
      SelectColor(NO_COLOR);
      edRColor.Text := ''; edGColor.Text := ''; edBColor.Text := '';
      SetTextData(DongaPat1.InfoPat[nPat].Tool[nTool].Data.sx, DongaPat1.InfoPat[nPat].Tool[nTool].Data.sy,
                  DongaPat1.InfoPat[nPat].Tool[nTool].Data.ex, DongaPat1.InfoPat[nPat].Tool[nTool].Data.ey,
                  '', '');
    end;
  end;
end;

procedure TfrmExPat.OpenSinglePattern1Click(Sender: TObject);
var
  nPatCnt : integer;
begin
  odlgSinglePattern.Filter := 'Open Pattern File (*.opt)|*.opt';
  odlgSinglePattern.InitialDir := Common.Path.Pattern;//.m_sPatFilePath;
  odlgSinglePattern.DefaultExt := odlgSinglePattern.Filter;
  if odlgSinglePattern.Execute then begin
    nPatCnt := lstPatList.Items.Count;
    DongaPat1.LoadAllPatOneFile(AnsiString(odlgSinglePattern.FileName));
    GetCopyfromPat(nPatCnt);
		edPatName.Text := strPas(DongaPat1.InfoPat[nPatCnt].pat.Data.PatName);
    lstPatList.Items.Add(strPas(DongaPat1.InfoPat[nPatCnt].Pat.Data.PatName));
    lstPatList.ItemIndex := nPatCnt;
  end;
end;

procedure TfrmExPat.SaveAsSinglePattern1Click(Sender: TObject);
var
  sFileName : AnsiString;
  nPatList : Integer;
begin
  nPatList  :=  lstPatList.ItemIndex;
  sFileName := StrPas(DongaPat1.InfoPat[nPatList].pat.Data.PatName);
  sFileName := stringReplace(sFileName,'/','div',[rfReplaceAll]);
  sdlgPopup.Filter := 'Save As File (*.opt)|*.opt';
  sdlgPopup.InitialDir  := Common.Path.Pattern;
  sdlgPopup.DefaultExt  := sdlgPopup.Filter;
  sdlgPopup.FileName    := sFileName +'.opt';
  if sdlgPopup.Execute then begin
    sFileName := ExtractFileName(sdlgPopup.FileName);
    fillChar(DongaPat1.InfoPat[nPatList].pat.Data.PatName,30,#0);
    move(sFileName[1],DongaPat1.InfoPat[nPatList].pat.Data.PatName[0],Length(sFileName)-4);
    SetCopyToPat(nPatList);
    DongaPat1.SaveAllPatOneFile(sdlgPopup.FileName);
    ShowMessage(sdlgPopup.FileName + ' was saved.');
  end;
end;

procedure TfrmExPat.SelectColor(nSel: Integer);
begin
  cboRColor.Visible := False;
  cboGColor.Visible := False;
  cboBColor.Visible := False;

  edRColor.Visible := False;
  edGColor.Visible := False;
  edBColor.Visible := False;

  case nSel of
    NO_COLOR,
    DIRECT_COLOR: begin
      edRColor.Visible := True;
      edGColor.Visible := True;
      edBColor.Visible := True;
      lblGl.Caption := '(0~4095)';
    end;
    PALLET_COLOR: begin
      edRColor.Visible := True;
      edGColor.Visible := True;
      edBColor.Visible := True;
      lblGl.Caption := '(0~4095)';
    end;
    GRAY_COLOR: begin
      cboRColor.Visible := True;
      cboGColor.Visible := True;
      cboBColor.Visible := True;
      lblGl.Caption := '(Gray)';
    end;
  end;
  if (nSel = NO_COLOR) then begin
    edRColor.Enabled := False;
    edGColor.Enabled := False;
    edBColor.Enabled := False;
    edRColor.Color := clSilver;
    edGColor.Color := clSilver;
    edBColor.Color := clSilver;
  end
  else begin
    edRColor.Enabled := True;
    edGColor.Enabled := True;
    edBColor.Enabled := True;
    edRColor.Color := clWindow;
    edGColor.Color := clWindow;
    edBColor.Color := clWindow;
  end;
end;

function TfrmExPat.SetConvertTool(sToolName: string; nToolIndex: Integer): string;
var
  nPos : integer;
  sNewToolName : string;
begin
  nPos := Pos('C(', sToolName);
  if  (nPos > 0) and
      (DongaPat1.InfoOnePat.Tool[nToolIndex].Data.ToolType <> ALL_H_GRAY) and
      (DongaPat1.InfoOnePat.Tool[nToolIndex].Data.ToolType <> ALL_V_GRAY) and
      (DongaPat1.InfoOnePat.Tool[nToolIndex].Data.ToolType <> ALL_C_GRAY) and
      (DongaPat1.InfoOnePat.Tool[nToolIndex].Data.ToolType <> ALL_H_GRAY2) and
      (DongaPat1.InfoOnePat.Tool[nToolIndex].Data.ToolType <> ALL_V_GRAY2) and
      (DongaPat1.InfoOnePat.Tool[nToolIndex].Data.ToolType <> ALL_C_GRAY2) then begin
    Delete(sToolName,nPos+2,Length(sToolName)-nPos+1);
    sNewToolName := sToolName +
                    IntToStr(BitSetDiv(DongaPat1.InfoOnePat.Tool[nToolIndex].Data.R)) + ',' +
                    IntToStr(BitSetDiv(DongaPat1.InfoOnePat.Tool[nToolIndex].Data.G)) + ',' +
                    IntToStr(BitSetDiv(DongaPat1.InfoOnePat.Tool[nToolIndex].Data.B)) + ')';
    Result := sNewToolName;
  end
  else Result := sToolName;
end;

procedure TfrmExPat.SetCopyToPat(nPatNum: Integer);
var
  i : Integer;
begin
  DongaPat1.InfoOnePat.Pat.Info.isRegistered       := DongaPat1.InfoPat[nPatNum].Pat.Info.isRegistered;
  DongaPat1.InfoOnePat.Pat.Data.PatName            := DongaPat1.InfoPat[nPatNum].Pat.Data.PatName;
  DongaPat1.InfoOnePat.Pat.Data.ToolCnt            := DongaPat1.InfoPat[nPatNum].Pat.Data.ToolCnt;
  for i := 0 to DongaPat1.InfoOnePat.Pat.Data.ToolCnt-1 do begin
    DongaPat1.InfoOnePat.Tool[i].into.isRegistered := DongaPat1.InfoPat[nPatNum].Tool[i].Into.isRegistered;
    DongaPat1.InfoOnePat.Tool[i].into.ToolName     := DongaPat1.InfoPat[nPatNum].Tool[i].into.ToolName;
    DongaPat1.InfoOnePat.Tool[i].Data.ToolType     := DongaPat1.InfoPat[nPatNum].Tool[i].Data.ToolType;
    DongaPat1.InfoOnePat.Tool[i].Data.Direction    := DongaPat1.InfoPat[nPatNum].Tool[i].Data.Direction;
    DongaPat1.InfoOnePat.Tool[i].Data.Level        := DongaPat1.InfoPat[nPatNum].Tool[i].Data.Level;
    DongaPat1.InfoOnePat.Tool[i].Data.sx           := DongaPat1.InfoPat[nPatNum].Tool[i].Data.sx;
    DongaPat1.InfoOnePat.Tool[i].Data.sy           := DongaPat1.InfoPat[nPatNum].Tool[i].Data.sy;
    DongaPat1.InfoOnePat.Tool[i].Data.ex           := DongaPat1.InfoPat[nPatNum].Tool[i].Data.ex;
    DongaPat1.InfoOnePat.Tool[i].Data.ey           := DongaPat1.InfoPat[nPatNum].Tool[i].Data.ey;
    DongaPat1.InfoOnePat.Tool[i].Data.mx           := DongaPat1.InfoPat[nPatNum].Tool[i].Data.mx;
    DongaPat1.InfoOnePat.Tool[i].Data.my           := DongaPat1.InfoPat[nPatNum].Tool[i].Data.my;
    DongaPat1.InfoOnePat.Tool[i].Data.R            := DongaPat1.InfoPat[nPatNum].Tool[i].Data.R;
    DongaPat1.InfoOnePat.Tool[i].Data.G            := DongaPat1.InfoPat[nPatNum].Tool[i].Data.G;
    DongaPat1.InfoOnePat.Tool[i].Data.B            := DongaPat1.InfoPat[nPatNum].Tool[i].Data.B;
    DongaPat1.InfoOnePat.Tool[i].Data.PalNum       := DongaPat1.InfoPat[nPatNum].Tool[i].Data.PalNum;
  end
end;

procedure TfrmExPat.SetPalColor(pl, tl, pal_num: Integer);
var
  sR, sG, sB : String;
begin
  sR := Format('%d',[DongaPat1.InfoPat[pl].Tool[tl].Data.R]);
  sG := Format('%d',[DongaPat1.InfoPat[pl].Tool[tl].Data.G]);
  sB := Format('%d',[DongaPat1.InfoPat[pl].Tool[tl].Data.B]);

  SelectColor(DIRECT_COLOR);
  edRColor.Text := sR;
  edGColor.Text := sG;
  edBColor.Text := sB;
end;

procedure TfrmExPat.SetPosition(sSX, sEX, sMX: AnsiString; bSX, bSY, bEX, bEY, bMX, bMY: Boolean);
begin
  lblSX.Caption := string(sSX);
  lblEX.Caption := string(sEX);
  lblMX.Caption := string(sMX);

  edSX.Enabled  := bSX; edSY.Enabled  := bSY;
  edEx.Enabled  := bEX; edEY.Enabled  := bEY;
  edMX.Enabled  := bMX; edMY.Enabled  := bMY;
  lblSX.Enabled := bSX; lblSY.Enabled := bSY;
  lblEX.Enabled := bEX; lblEY.Enabled := bEY;
  lblMX.Enabled := bMX; lblMY.Enabled := bMY;

	if bSX then edSX.Color := clWindow
	else        edSX.Color := clSilver;
	if bSY then edSY.Color := clWindow
	else        edSY.Color := clSilver;
	if bEX then edEX.Color := clWindow
	else        edEX.Color := clSilver;
	if bEY then edEY.Color := clWindow
	else        edEY.Color := clSilver;
	if bMX then edMX.Color := clWindow
	else        edMX.Color := clSilver;
	if bMY then edMY.Color := clWindow
	else        edMY.Color := clSilver;
end;

procedure TfrmExPat.SetTextData(sSX, sSY, sEX, sEY, sMX, sMY: AnsiString);
begin
  edSX.Text := string(sSX);
  edSY.Text := string(sSY);
  edEX.Text := string(sEX);
  edEY.Text := string(sEY);
  edMX.Text := string(sMX);
  edMY.Text := string(sMY);
end;

procedure TfrmExPat.SetTextGray(b1, b2: Boolean);
begin
  CB_direction.Enabled := b2; CB_level.Enabled := b2;
	if b2 then begin
		CB_direction.Color := clWindow; CB_level.Color := clWindow;
	end
	else begin
		CB_direction.Color := clSilver; CB_level.Color := clSilver;
	end;
end;

procedure TfrmExPat.ToolItemClick(Sender: TObject);
var
  nIndex: Integer;
begin
  nIndex := (Sender As TSpeedButton).Tag;
  CheckToolItem(nIndex);
  m_ToolType := nIndex;
  case nIndex of
    ALL_LINE, ALL_BOX, ALL_FILL_BOX     : begin
      SelectColor(DIRECT_COLOR);
      SetPosition('Start X:','End X:','',True,True,True,True,False,False);
      SetTextGray(False,False);
    end;
    ALL_TRI, ALL_FILL_TRI	          : begin
      SelectColor(DIRECT_COLOR);
      SetPosition('Start X:','End X:','Tri X:',True,True,True,True,True,True);
      SetTextGray(False,False);
    end;
    ALL_CIRCLE, ALL_FILL_CIRCLE	    :begin
      SelectColor(DIRECT_COLOR);
      SetPosition('Center X:','', 'Radius X:',True,True,False,False,True,True);
      SetTextGray(False,False);
    end;
    ALL_H_GRAY, ALL_V_GRAY, ALL_C_GRAY,	ALL_H_GRAY2, ALL_V_GRAY2, ALL_C_GRAY2: begin
      SelectColor(GRAY_COLOR);
      SetPosition('Start X:','End X:','Tri X',True,True,True,True,False,False);
      SetTextGray(False,True);
    end;
    ALL_BLK_COPY	: begin
//      m_PreviewType := PATTERN_PREVIEW;
//      PatPreview;  //현재까지 그려진 패턴 확인용
      SelectColor(NO_COLOR);
      SetPosition('Start X:','End X:','',True,True,True,True,False,False);
      SetTextGray(False,False);
    end;
	  ALL_BLK_PASTE	: begin
      SelectColor(NO_COLOR);
      SetPosition('Start X:','End X:','',True,True,False,False,False,False);
      SetTextGray(False,False);
    end;
		ALL_LOOP		:  begin
      SelectColor(NO_COLOR);
      SetPosition('Setp X:','Count:','',True,True,True,False,False,False);
      SetTextGray(False,False);
    end;
    ALL_XYLOOP		: begin
      SelectColor(NO_COLOR);
      SetPosition('Setp X:','Count X:','',True,True,True,True,False,False);
      SetTextGray(False,False);
    end;
  end;
end;

end.
