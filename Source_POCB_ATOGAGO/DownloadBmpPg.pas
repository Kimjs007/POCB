unit DownloadBmpPg;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages,  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,System.SysUtils, RzCommon, Vcl.StdCtrls, RzCmboBx, RzLstBox, RzChkLst,
  RzTabs, Vcl.Mask, RzEdit, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, RzLabel, RzPanel, RzButton, System.UITypes,
  Vcl.ExtCtrls, IdSocketHandle, UdpServerPocb, DefPocb, CommonClass, AdvUtil, CodeSiteLogging
{$IFDEF REF_ISPD}
  ,system.threading;
{$ELSE}
  ;
{$ENDIF}

const
  TAB_INDEX_BMP = 0;  // tcDownType.TabIndex

type
  TfrmDownloadBmpPg = class(TForm)
    pnlHeader: TRzPanel;
    pnlTail: TRzPanel;
    btnClose: TRzBitBtn;
    pnlDownload: TRzPanel;
    grpDownStatus: TRzGroupBox;
    lblmsec: TRzLabel;
    lblWaitTime: TRzLabel;
    btnSelAllIP: TRzBitBtn;
    btnClearIP: TRzBitBtn;
    gridPGList: TAdvStringGrid;
    edTime: TRzNumericEdit;
    tcDownType: TRzTabControl;
    pnlListCtrl: TRzPanel;
    grpPCFilelist: TRzGroupBox;
    lstPCFileList: TRzCheckList;
    btnSelAllPC: TRzBitBtn;
    btnClearPC: TRzBitBtn;
    btnDeletePC: TRzBitBtn;
    pnlScreenPanel: TRzPanel;
    btnDownload: TRzBitBtn;
    grpSplitOption: TRzGroupBox;
    pnlHoriValue: TRzPanel;
    edHorDmy: TRzNumericEdit;
    pnlVertiValue: TRzPanel;
    edVerDmy: TRzNumericEdit;
    cboSplitBit: TRzComboBox;
    pnlBitType: TRzPanel;
    grpBMPResolution: TRzGroupBox;
    cboResolution: TRzComboBox;
    RzFrameController1: TRzFrameController;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tcDownTypeChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnDownloadClick(Sender: TObject);
    procedure btnSelAllPCClick(Sender: TObject);
    procedure btnClearPCClick(Sender: TObject);
    procedure btnSelAllIPClick(Sender: TObject);
    procedure btnClearIPClick(Sender: TObject);
    procedure btnDeletePCClick(Sender: TObject);
    procedure gridPGListSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure gridPGListCheckBoxClick(Sender: TObject; ACol, ARow: Integer; State: Boolean);
    procedure cboResolutionChange(Sender: TObject);
    procedure WMCopyData(var Msg : TMessage); message WM_COPYDATA;
  private
    m_bLockUI : array[DefPocb.PG_1 .. DefPocb.PG_MAX] of Boolean;
    RawBgrData : array of byte;
    RawData : array of Byte;
    Timer_ConnCheck    : TTimer;
    m_sDownList  : TStringList;
    sCurrPath     : String;  //Current Path Directory
    Image_Pat1    : TImage;

    procedure MakeDownList;
    procedure ConnCheckTimer(Sender: TObject);
    function  IsCheckPGList : Boolean;
    function  CheckedPGCount : Integer;
    function  CheckDownloadBmpSize : Integer;
    procedure ConvertBmp2RawFile;
    procedure Clear_StringGrid_PGList;
    procedure SaveRawFile(fName : String);
    procedure MakeRawFile(fName : String);
    procedure DeleteDataFilePC(fName: String);
    procedure StartDataDownload(nPgNo, nFileCnt : Integer; const fileTransRec : TArray<TFileTranStr>);
    procedure ThreadTask(task : TProc);
    procedure unLockGui(nPg : Integer);
  public
    procedure SetDownLoadEnd(bSet : Boolean);
    procedure RefreshScreen;
  end;
var
  frmDownloadBmpPg: TfrmDownloadBmpPg;

implementation

uses OtlTaskControl, OtlParallel, DefPG;

{$R *.dfm}

procedure TfrmDownloadBmpPg.btnClearIPClick(Sender: TObject);

begin
  gridPGList.UnCheckAll(0);
  Clear_StringGrid_PGList;
end;

procedure TfrmDownloadBmpPg.btnClearPCClick(Sender: TObject);
begin
  lstPCFileList.UncheckAll;
end;

procedure TfrmDownloadBmpPg.btnCloseClick(Sender: TObject);
begin
	Common.DelateBmpRawFile;
  //
  Close;
end;

procedure TfrmDownloadBmpPg.btnDeletePCClick(Sender: TObject);
var
  i : Integer;
  Rslt : Integer;
begin
  if lstPCFileList.ItemsChecked < 1 then begin
    MessageDlg(#13#10 + 'Not Selected Any Files to Delete!', mtError, [mbOk], 0);
    Exit;
  end;

  if MessageDlg(#13#10 + 'Are you sure to Delete Selected Files?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;

  Rslt := mrNo;
  for i := 0 to lstPCFileList.Items.Count - 1 do begin
    if lstPCFileList.ItemChecked[i] then begin
      if Rslt <> mrYesToAll then begin
        Rslt := MessageDlg(#13#10 + 'File [' + lstPCFileList.Items[i] + '] Delete?', mtConfirmation,
                           [mbYesToAll, mbYes, mbAbort, mbCancel], 0);
        if      Rslt = mrAbort  then Continue
        else if Rslt = mrCancel then Break;
      end;
      DeleteDataFilePC(lstPCFileList.Items[i]);
    end;
  end;
  RefreshScreen;
end;

procedure TfrmDownloadBmpPg.btnDownloadClick(Sender: TObject);
var
  i, dnBmp_size   : Integer;
  //f_indx : array[0..MAX_PG_CNT-1] of Integer;
  isChecked, isStart  : Boolean;
  msg_str  : String;
  sFileName : AnsiString;
  fileTrans           : TArray<TFileTranStr>;
  nTotalSize          : Integer;
  dChecksum           : dword;
  getFileData         : TArray<System.Byte>;
  mtData : TMemoryStream;
  bmp1   : TBitmap;
begin
  if not IsCheckPGList then begin
    MessageDlg(#13#10 + 'Not Selected Any PG to Download!', mtError, [mbOk], 0);
    Exit;
  end;

  if lstPCFileList.Items.Count = 0 then begin
    MessageDlg(#13#10 + 'No Files to Download!', mtError, [mbOk], 0);
    Exit;
  end;

  if lstPCFileList.ItemsChecked < 1 then begin
    MessageDlg(#13#10 + 'Not Selected Any Files to Download!', mtError, [mbOk], 0);
    Exit;
  end;

  if CheckedPGCount > DefPocb.PG_CNT then begin
    MessageDlg(#13#10 + 'PG count to download a maximum number of PG.!', mtError, [mbOk], 0);
    Exit;
  end;

  SetDownLoadEnd(False);
  MakeDownList;

  if m_sDownList.Count > DefPG.MAX_BMP_CNT then begin
    MessageDlg(#13#10 + 'BMP count to download a maximum number of 40.!', mtError, [mbOk], 0);
    SetDownLoadEnd(True);
    Exit;
  end;
  // PG의 메모리 사이즈보다 큰 Bmp File Size는 다운로드를 할 수 없다.
  dnBmp_size := CheckDownloadBmpSize;
  if dnBmp_size > (Common.SystemInfo.PGMemorySize * (1024*1024)) then begin
    msg_str := #13#10 + 'BMP download size must less than the PG memory.!';
    msg_str := msg_str + #10#13#10#13 + Format('Bmp size : %dMb > PG memory : %dMb',
      [(dnBmp_size div (1024*1024)), Common.SystemInfo.PGMemorySize]);
    //MessageDlg(#13#10 + 'BMP download size must less than the PG memory.!', mtError, [mbOk], 0);
    MessageDlg(msg_str, mtError, [mbOk], 0);
    SetDownLoadEnd(True);
    Exit;
  end;
  ConvertBmp2RawFile;

  Clear_StringGrid_PGList;

  SetLength(fileTrans,SizeOf(fileTrans)*m_sDownList.Count);
  for i := 0 to Pred(m_sDownList.Count) do begin
    sFileName := AnsiString(m_sDownList.Strings[i]);
    fileTrans[i].TransMode := DefPOCB.DOWNDATA_BMP; //#DOWNLOAD_TYPE_BMP
    fileTrans[i].fileName  := AnsiString(StringReplace(string(sFileName),'.bmp','.raw', [rfReplaceAll, rfIgnoreCase]));
    fileTrans[i].filePath  := AnsiString(Common.Path.BMP);
    fileTrans[i].TransType := DefPG.PGSIG_BMPDOWN_TYPE_BMP; //#FUSING_TYPE_BMP
    //
    mtData := TMemoryStream.Create;
    try
      mtData.LoadFromFile(string(fileTrans[i].filePath+string(sFileName)));
      mtData.Position := 0;
      bmp1 := Tbitmap.Create;
      try
    	  bmp1.LoadFromStream(mtData);
        fileTrans[i].BmpWidth := bmp1.Width;
      finally
        bmp1.Free;
      end;
    finally
      mtData.Free;
    end;

    dChecksum := 0;
    Common.LoadCheckSumNData(string(fileTrans[i].filePath+fileTrans[i].fileName),dChecksum,nTotalSize,getFileData);
    fileTrans[i].CheckSum   := dChecksum;
    fileTrans[i].TotalSize  := nTotalSize;
    SetLength(fileTrans[i].Data, nTotalSize);
    CopyMemory(@fileTrans[i].Data[0],@getFileData[0],nTotalSize);
  end;
//  nTotalSize, nChecksum : Integer;
//  getFileData         : array of byte;
  isStart := False;
  // PG List.
  for i := 1 to Pred(gridPGList.RowCount) do begin
    if gridPGList.Cells[0,i] = '' then Continue;
    isChecked := False;
    gridPGList.GetCheckBoxState(0, i, isChecked);
    if isChecked then begin
      isStart := True;
      gridPGList.AddProgressFormatted(2,i,clLime,clBlack,clInfoBk,clBlue,'%d%%',0, 100);
      m_bLockUI[i-1] := True;
      StartDataDownload(i-1,m_sDownList.Count,fileTrans);
    end;
  end;
  // Start 못했을때 UI Lock 풀어 주자.
  if not isStart then begin
    SetDownLoadEnd(True);
  end;
end;

procedure TfrmDownloadBmpPg.btnSelAllIPClick(Sender: TObject);
begin
  gridPGList.CheckAll(0);
  Clear_StringGrid_PGList;
end;

procedure TfrmDownloadBmpPg.btnSelAllPCClick(Sender: TObject);
begin
  lstPCFileList.CheckAll;
end;

procedure TfrmDownloadBmpPg.cboResolutionChange(Sender: TObject);
var
  sl : TStringList;
begin
  lstPCFileList.Clear;
  lstPCFileList.Sorted := False;
  sl := Common.BmpGetKeyValueList(cboResolution.Text);
  try
    lstPCFileList.Items.Assign(sl);
  finally
   sl.Free;
  end;
end;

function TfrmDownloadBmpPg.CheckDownloadBmpSize: Integer;
var
  i, tot_bmp_size : Integer;
  bmp1 : TBitmap;
  nType, nDIv, nMod : Integer;
begin
  tot_bmp_size := 0;
  bmp1 := TBitmap.Create;
  try
    for i := 0 to m_sDownList.Count -1 do begin
      try //Type에 맞지않는 Bitmap인 경우 처리
        bmp1.LoadFromFile(sCurrPath + m_sDownList.Strings[i]);
        {$IFDEF OLD}
        tot_bmp_size := tot_bmp_size + (bmp1.Height*2048*3);
        {$ELSE}
        nDiv := bmp1.Width div 2048;
        nMod := bmp1.Width mod 2048;
        if nMod > 0 then nDiv := nDiv + 1;
        nType := nDiv * 2048;  //~2048(2048), ~4096(4096), ~6144(6144), ~8192(8192)  //TBD:A2CHv4:LUCID
        tot_bmp_size := tot_bmp_size + (bmp1.Height*nType*3);
        {$ENDIF}
      except end;
    end;
  finally
    bmp1.Free;
  end;
  Result := tot_bmp_size;
end;

function TfrmDownloadBmpPg.CheckedPGCount: Integer;
var
  i, num : Integer;
  State : Boolean;
begin
  num := 0;
  for i := 1 to gridPGList.RowCount-1 do begin
    if gridPGList.GetCheckBoxState(0, i, State) then
      if State then inc(num)
  end;
  Result := num;
end;

procedure TfrmDownloadBmpPg.Clear_StringGrid_PGList;
var
  i : Integer;
begin
  for i := 1 to gridPGList.RowCount-1 do begin
    gridPGList.Ints [2,i] := 0;
    gridPGList.Cells[3,i] := '';
  end;
end;

procedure TfrmDownloadBmpPg.ConnCheckTimer(Sender: TObject);
var
  i : Integer;
begin
  for i := DefPocb.PG_1 to DefPocb.PG_MAX do begin
    if pg[i] <> nil then begin

      if pg[i].StatusPg <> pgDisconnect then begin
        gridPGList.Cells[1,i+1] := 'CONNECT';
        gridPGList.RowColor[i+1] := clWindow;
{$IFDEF REF_SDIP}
        gridPGList.Cells[0,i+1]  := Common.SystemInfo.PGIPAddr[i];//PG[i].IP;
{$ELSE}
        gridPGList.Cells[0,i+1]  := PG[i].m_sPgIP;
{$ENDIF}
      end
      else begin
        gridPGList.Cells[1,i+1] := 'DISCONNECT';
        gridPGList.RowColor[i+1] := clGray;
        gridPGList.Cells[0,i+1]  := '';
      end;
    end;
  end;
end;

procedure TfrmDownloadBmpPg.ConvertBmp2RawFile;
var
  i : Integer;
begin
  // BMP 파일을 RAW파일로 변경
  for i := 0 to m_sDownList.Count -1 do begin
    MakeRawFile(m_sDownList.Strings[i]);
    SaveRawFile(m_sDownList.Strings[i]);
  end;
end;

procedure TfrmDownloadBmpPg.DeleteDataFilePC(fName: String);
begin
  try
    DeleteFile(sCurrPath + fName);
  except
    MessageDlg(#13#10 + 'File Delete Error! [' + sCurrPath + fName + ']', mtError, [mbOk], 0);
    Exit;
  end;
end;

procedure TfrmDownloadBmpPg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmDownloadBmpPg.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i : Integer;
  bWait : Boolean;
begin
  Timer_ConnCheck.Enabled := False;
  Timer_ConnCheck.Free;
  Timer_ConnCheck := nil;

  m_sDownList.Free;
  Image_Pat1.Free;

  bWait := False;
  // 동작중 강제 종료 하자.
  for i := DefPocb.PG_1 to DefPocb.PG_MAX do begin
    if PG[i].StatusPg = pgWait then begin
      PG[i].StatusPg := pgForceStop;
      bWait := True;
    end;
  end;
  // 강제 종료 한다면 기다렸다가 끄자.
  if bWait then Common.Delay(1000);
  Common.MLog(DefPocb.SYS_LOG,'<PG_BMP_DOWNLOAD> Window Close');
end;

procedure TfrmDownloadBmpPg.FormCreate(Sender: TObject);
var
  i : Integer;
  sl : TStringList;
begin
  Common.MLog(DefPocb.SYS_LOG,'<PG_BMP_DOWNLOAD> Window Open');

  sCurrPath := '';

  m_sDownList   := TStringList.Create;
  Image_Pat1  := TImage.Create(Self);

  gridPGList.RowCount  := DefPocb.PG_CNT+1;  //TBD:A2CH? +1 ???
  gridPGList.ProgressAppearance.CompletionSmooth := False;
  for i := DefPocb.PG_1 to DefPocb.PG_MAX do begin
    gridPGList.AddCheckBox(0,i+1, False, False);
    gridPGList.Cells[0,i+1]  := Common.SystemInfo.IPAddr_PG[i];
    if pg[i].StatusPg <> pgDisconnect then begin
      gridPGList.Cells[1,i+1] := 'CONNECT';
      gridPGList.RowColor[i+1] := clWindow;
    end
    else begin
      gridPGList.Cells[1,i+1] := 'DISCONNECT';
      gridPGList.RowColor[i+1] := clGray;
    end;

    gridPGList.Cells[1,i+1] := '';
    gridPGList.AddProgress(2,i+1, clLime, clWhite);
    gridPGList.Ints [2,i+1] := 0;
    gridPGList.Cells[3,i+1] := '';
    m_bLockUI[i] := False;
  end;
  // 연결상태 확인.
{$IFDEF REF_SDIP}
  Timer_ConnCheck := TTimer.Create(self);
{$ELSE}
  Timer_ConnCheck := TTimer.Create(nil);  //TBD:SDIP?
{$ENDIF}
  Timer_ConnCheck.OnTimer := ConnCheckTimer;
  Timer_ConnCheck.Interval := 1000;
  Timer_ConnCheck.Enabled   := True;

  gridPGList.DoubleBuffered := True;

  cboResolution.Items.Clear;
  sl := Common.BmpGetSectionList;
  try
   cboResolution.Items.Assign(sl);
  finally
   sl.Free;
  end;
  cboResolution.ItemIndex := 0;
end;

procedure TfrmDownloadBmpPg.FormDestroy(Sender: TObject);
begin
  frmDownloadBmpPg := nil;
end;

procedure TfrmDownloadBmpPg.FormShow(Sender: TObject);
begin
  tcDownType.TabIndex := TAB_INDEX_BMP; //#DOWNLOAD_TYPE_BMP
  tcDownTypeChange(nil);
end;

procedure TfrmDownloadBmpPg.gridPGListCheckBoxClick(Sender: TObject; ACol, ARow: Integer; State: Boolean);
var
  i : Integer;
  isChecked: Boolean;
begin

  for i := 1 to gridPGList.RowCount-1 do begin
    isChecked := False;
    gridPGList.GetCheckBoxState(0, i, isChecked);
    if isChecked then Break;
  end;
  if isChecked = False then btnClearIPClick(nil);
end;
procedure TfrmDownloadBmpPg.gridPGListSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if (ACol = 0)then
    gridPGList.Options := gridPGList.Options + [goEditing]
  else
    gridPGList.Options := gridPGList.Options - [goEditing];
end;

function TfrmDownloadBmpPg.IsCheckPGList: Boolean;
var
  i : Integer;
  isChecked: Boolean;
begin
  for i := 1 to gridPGList.RowCount-1 do begin
    isChecked := False;
    gridPGList.GetCheckBoxState(0, i, isChecked);
    if isChecked then Break;
  end;
  Result := isChecked;
end;


procedure TfrmDownloadBmpPg.MakeDownList;
var
  i : Integer;
begin
  m_sDownList.Clear;
  for i := 0 to lstPCFileList.Items.Count - 1 do begin
    if lstPCFileList.ItemChecked[i] then begin
        m_sDownList.Add(lstPCFileList.Items.Strings[i]);
    end;
  end;
end;

procedure TfrmDownloadBmpPg.MakeRawFile(fName: String);
var
  i,j, nTemp, nType : Integer;
  nHeight, nWidth : Integer;
  nDiv, nMod : Integer;
begin
  SetLength(RawData,0);    //Initial
  SetLength(RawBgrData,0); //Initial
  Image_Pat1.Picture := nil;
  try //Type에 맞지않는 Bitmap인 경우 처리
    Image_Pat1.Picture.LoadFromFile(sCurrPath + fName);
//		Image_Pat1.Picture.LoadFromFile(fName);
  except end;

  nHeight := Image_Pat1.Picture.Bitmap.Height;
  nWidth  := Image_Pat1.Picture.Bitmap.Width;

  nDiv := (nWidth div 2048);
  nMod := (nWidth mod 2048);
  if nMod > 0 then nDiv := nDiv + 1;
  nType := nDiv * 2048;  //~2048(2048), ~4096(4096), ~6144(6144), ~8192(8192)  //TBD:A2CHv4:LUCID

  SetLength(RawData,   (nHeight*nWidth*3)); //*3 (24bit)
  SetLength(RawBgrData,(nType*3*nHeight));
  for i := 0 to Pred(nHeight) do begin
    CopyMemory(@RawData[i*nWidth*3],Image_Pat1.Picture.Bitmap.ScanLine[i],nWidth*3);
  end;
  for i := 0 to Pred(nHeight) do begin
    nTemp := i*nType*3;
    for j := 0 to Pred(nType) do begin
      if nWidth > j then begin
        RawBgrData[nTemp+j] :=  RawData[nWidth*i*3+j*3];              // B
        RawBgrData[nTemp + nType+j] :=  RawData[nWidth*i*3+j*3+1];    // G
        RawBgrData[nTemp + nType*2 +j] :=  RawData[nWidth*i*3+j*3+2]; // R
      end
      else begin
        RawBgrData[nTemp+j] :=  0;            // B
        RawBgrData[nTemp + nType+j] :=  0;    // G
        RawBgrData[nTemp + nType*2 +j] :=  0; // R
      end;
    end;
  end;

{$IFDEF OLD}
  if nWidth <= 2048 then begin
    nType := 2048;
    SetLength(RawData,   (nHeight*nWidth*3));   //A2CH&F2CH(3:24bit)
    SetLength(RawBgrData,(nType*3*nHeight));
    for i := 0 to Pred(nHeight) do begin
      CopyMemory(@RawData[i*nWidth*3],Image_Pat1.Picture.Bitmap.ScanLine[i],nWidth*3);
    end;
    for i := 0 to Pred(nHeight) do begin
      nTemp := i*nType*3;
      for j := 0 to Pred(nType) do begin
        if nWidth > j then begin
          RawBgrData[nTemp+j] :=  RawData[nWidth*i*3+j*3];              // B
          RawBgrData[nTemp + nType+j] :=  RawData[nWidth*i*3+j*3+1];    // G
          RawBgrData[nTemp + nType*2 +j] :=  RawData[nWidth*i*3+j*3+2]; // R
        end
        else begin
          RawBgrData[nTemp+j] :=  0;            // B
          RawBgrData[nTemp + nType+j] :=  0;    // G
          RawBgrData[nTemp + nType*2 +j] :=  0; // R
        end;
      end;
    end;
  end
  else begin
    nType := 4096;
    SetLength(RawData,   (nHeight*nWidth*3));
    SetLength(RawBgrData,(nType*3*nHeight));
    for i := 0 to Pred(nHeight) do begin
      CopyMemory(@RawData[i*nWidth*3],Image_Pat1.Picture.Bitmap.ScanLine[i],nWidth*3);
//			CopyMemory(@RawData[i*2048*3],Image_Pat1.Picture.Bitmap.ScanLine[i],2048*3);
//			CopyMemory(@RawData[i*2049*3],Image_Pat1.Picture.Bitmap.ScanLine[i],2048*3);
    end;
    for i := 0 to Pred(nHeight) do begin
      nTemp := i*nType*3;
      for j := 0 to Pred(nType) do begin
        if nWidth > j then begin
          RawBgrData[nTemp+j] :=  RawData[nWidth*i*3+j*3];              // B
          RawBgrData[nTemp + nType+j] :=  RawData[nWidth*i*3+j*3+1];    // G
          RawBgrData[nTemp + nType*2 +j] :=  RawData[nWidth*i*3+j*3+2]; // R
        end
        else begin
          RawBgrData[nTemp+j] :=  0;            // B
          RawBgrData[nTemp + nType+j] :=  0;    // G
          RawBgrData[nTemp + nType*2 +j] :=  0; // R
        end;
      end;
    end;
  end;
{$ENDIF}

end;

procedure TfrmDownloadBmpPg.RefreshScreen;
begin
  tcDownTypeChange(nil);
end;

procedure TfrmDownloadBmpPg.SaveRawFile(fName: String);
var
  fi : TFileStream;
  saveFName : String;
  nType, nDiv, nMod : Integer;
begin
  saveFName := sCurrPath + StringReplace(fName,'.bmp','.raw', [rfReplaceAll, rfIgnoreCase]);
//	saveFName := StringReplace(fName,'.bmp','.raw', [rfReplaceAll, rfIgnoreCase]);
  if FileExists(saveFname) then
    fi := TFileStream.Create(saveFName, fmOpenWrite or fmShareDenyNone)
  else
    fi := TFileStream.Create(saveFName, fmCreate);
  try
    {$IFDEF OLD}}
    if Image_Pat1.Picture.Bitmap.Width <= 2048 then begin
      fi.WriteBuffer(RawBgrData[0],Image_Pat1.Picture.Bitmap.Height*2048*3)
    end
    else begin
      fi.WriteBuffer(RawBgrData[0],Image_Pat1.Picture.Bitmap.Height*4096*3)
    end;
    {$ELSE}
    nDiv := (Image_Pat1.Picture.Bitmap.Width div 2048);
    nMod := (Image_Pat1.Picture.Bitmap.Width mod 2048);
    if nMod > 0 then nDiv := nDiv + 1;
    nType := nDiv * 2048;  //~2048(2048), ~4096(4096), ~6144(6144), ~8192(8192)
    fi.WriteBuffer(RawBgrData[0],Image_Pat1.Picture.Bitmap.Height*nType*3);
    {$ENDIF}
  finally
    fi.Free;
  end;
end;

// bSet : True - Set Enable, False - Disable.
procedure TfrmDownloadBmpPg.SetDownLoadEnd(bSet : Boolean);
begin
  tcDownType.Enabled     := bSet;
  pnlListCtrl.Enabled    := bSet;
  grpDownStatus.Enabled  := bSet;
  btnClose.Enabled       := bSet;
end;

procedure TfrmDownloadBmpPg.StartDataDownload(nPgNo, nFileCnt: Integer;const fileTransRec: TArray<TFileTranStr>);
begin
  if Pg[nPgNo].StatusPg = pgDisconnect then begin
    unLockGui(nPgNo);
    Exit;
  end;

  ThreadTask(procedure begin
    Pg[nPgNo].m_hGuiFrm := Self.Handle;
    PG[nPgNo].PgDownBmpFiles(nFileCnt,fileTransRec);  //TBD:MERGE? #SendTransData #SendPgTransData
  end);
end;

procedure TfrmDownloadBmpPg.tcDownTypeChange(Sender: TObject);
var
  Rslt      : Integer;
  sFindFile : String;
  sr : TSearchrec;
begin
  sFindFile := '';
  grpBMPResolution.Visible := False;

  case tcDownType.TabIndex of
    TAB_INDEX_BMP : begin //#DOWNLOAD_TYPE_BMP
      sCurrPath := Common.Path.BMP;
      sFindFile := Common.Path.BMP + '*.bmp';
      grpBMPResolution.Visible := True;
    end;
    else begin
      Exit; //
    end;
  end;

  lstPCFileList.Clear;
  lstPCFileList.Sorted := False;

  Rslt := FindFirst(sFindFile, faAnyFile, sr);
  while Rslt = 0 do begin   // Pattern Folder에서 Pattern Name을 검색하여 ComboBox 에 삽입
    if Length(sr.Name) > 4 then
      lstPCFileList.Items.Add(sr.Name);      // ComboBox에 Pattern Name 추가

    Rslt := FindNext(sr);
  end;
  FindClose(sr);

  lstPCFileList.ItemIndex := -1;
end;

procedure TfrmDownloadBmpPg.ThreadTask(task: TProc);
{$IFDEF REF_SDIP}
var
  th1 : TThread;
begin
  th1 := TThread.CreateAnonymousThread(Task);
  th1.FreeOnTerminate := True;
  th1.Start;
//  Parallel.Async( procedure begin
//      task;
//    end,
//    Parallel.TaskConfig.OnTerminated(
//      procedure (const task: IOmniTaskControl)
//      begin
//      end
//    )
//  );
end;
{$ELSE}
begin
  Parallel.Async( procedure begin
      task;
    end,
    Parallel.TaskConfig.OnTerminated(
      procedure (const task: IOmniTaskControl)
      begin
      end
    )
  );
end;
{$ENDIF}

procedure TfrmDownloadBmpPg.unLockGui(nPg : Integer);
var
  i : Integer;
  bLockUi : Boolean;
begin
  m_bLockUI[nPg] := False;
  bLockUi := False;
  for i := DefPocb.PG_1 to DefPocb.PG_MAX do begin
    if m_bLockUI[i] then bLockUi := True;
  end;
  if not bLockUi then begin
    SetDownLoadEnd(True);
  end;
end;

procedure TfrmDownloadBmpPg.WMCopyData(var Msg: TMessage);
var
  nType, nPg, nMode : Integer;
  nTotal, nCur : Integer;
  sMessage : string;
  bIsDone : boolean;
begin
  nType := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.MsgType;
  nPg   := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.PgNo;
  case nType of
    DefPocb.MSG_TYPE_PG : begin
      nMode := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      case nMode of
        DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS : begin
          nTotal   := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.Total;
          nCur     := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.CurPos;
          sMessage := string(PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.sMsg);
          bIsDone  := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.IsDone;
          //
          gridPGList.Cells[3,nPg+1] := sMessage;
          gridPGList.Ints[2,nPg+1] := (nCur * 100) div nTotal;
          Common.MLog(nPg,sMessage); //2021-12-14
          if bIsDone then begin
            unLockGui(nPg);
          end;
        end;
      end;
    end;
  end;
end;

end.
