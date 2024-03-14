unit DownloadFwSpi;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzPrgres, RzPanel, Vcl.StdCtrls, RzCmboBx, RzShellDialogs, Vcl.Mask, RzEdit, RzButton,
  Vcl.ExtCtrls, DefPG, CommonClass, DefPocb, UdpServerPocb, RzRadChk;

const
  SPI_FWDOWN_ITEM_FW   = 0;  // cboDownType.ItemIndex
  SPI_FWDOWN_ITEM_BOOT = 1;  // cboDownType.ItemIndex

type
  TfrmDownloadFwSpi = class(TForm)
    RzGroupBox1: TRzGroupBox;
    btnFileOpen: TRzBitBtn;
    edFileName: TRzEdit;
    odglfile: TRzOpenDialog;
    pgrbDataDownload: TRzProgressBar;
    btnDownload: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    pnlDownload: TRzPanel;
    chkCh2: TRzCheckBox;
    chkCh1: TRzCheckBox;
    pgrbDataDownload2: TRzProgressBar;
    pnlDownload2: TRzPanel;
    cboDownType: TRzComboBox;
    procedure RzBitBtn2Click(Sender: TObject);
    procedure btnFileOpenClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_TransData :  TFileTranStr;
    procedure WMCopyData(var Msg : TMessage); message WM_COPYDATA;
    procedure SpiFwDownLoadStart(nCh, nType: Integer);
    function GetFileData(sFileName : string) : Boolean;
  public
    { Public declarations }
  end;

var
  frmDownloadFwSpi: TfrmDownloadFwSpi;

implementation

{$R *.dfm}

procedure TfrmDownloadFwSpi.btnDownloadClick(Sender: TObject);
var
  sFileName  : string;
  nTransType : Integer;
begin
  case cboDownType.ItemIndex of
    SPI_FWDOWN_ITEM_FW   : nTransType := DefPG.SPISIG_FWDOWN_TYPE_FW;
    SPI_FWDOWN_ITEM_BOOT : nTransType := DefPG.SPISIG_FWDOWN_TYPE_BOOT;
    else begin
      ShowMessage('Download type is NOT selected !!!');
      Exit;
    end;
  end;

  if Trim(edFileName.Text) <> '' then begin
    btnDownload.Enabled := False;
    sFileName := Trim(edFileName.Text);
    if FileExists(sFileName) then begin
      if chkCh1.Checked then SpiFwDownLoadStart(DefPocb.CH_1,nTransType);
      if chkCh2.Checked then SpiFwDownLoadStart(DefPocb.CH_2,nTransType);
    end
    else begin
      ShowMessage(sFileName + ' file does not exist !!!');
      btnDownload.Enabled := True;
    end;
  end;
end;

procedure TfrmDownloadFwSpi.btnFileOpenClick(Sender: TObject);
var
  sPgName : string;
begin
  //
  sPgName := '';
  case Common.SystemInfo.SPI_TYPE of
    SPI_TYPE_DJ023_SPI : sPgName := 'DJ023-SPI';
    SPI_TYPE_DJ201_QSPI: sPgName := 'DJ201-QSPI';
    SPI_TYPE_DJ021_QSPI: sPgName := 'DJ021-QSPI';
    else Exit;
  end;
  //
  case cboDownType.ItemIndex of
    SPI_FWDOWN_ITEM_FW : begin
      sPgName := sPgName+'-APP';
      odglfile.InitialDir := Common.Path.SPI_FW;
      odglfile.Filter     := 'bin files('+sPgName+'*.bin)|'+sPgName+'*.bin';
      odglfile.FilterIndex:= 1;
    end;
    SPI_FWDOWN_ITEM_BOOT : begin
      sPgName := sPgName+'-BOOT';
      odglfile.InitialDir := Common.Path.SPI_BOOT;
      odglfile.Filter     := 'bin files('+sPgName+'*.bin)|'+sPgName+'*.bin';
      odglfile.FilterIndex:= 1;
    end;
    else Exit;
  end;
  m_TransData.TotalSize := 0;
  if odglfile.Execute then begin
    edFileName.Text := odglfile.FileName;
    GetFileData(odglfile.FileName);
  end;
end;

procedure TfrmDownloadFwSpi.FormCreate(Sender: TObject);
begin
  Common.MLog(DefPocb.SYS_LOG,'<SPI_FW_DOWNLOAD> Window Open');
  //
  m_TransData.TotalSize := 0;
  //
  cboDownType.ItemIndex := SPI_FWDOWN_ITEM_FW;
end;

procedure TfrmDownloadFwSpi.SpiFwDownLoadStart(nCh, nType: Integer);
var
  thDownload : TThread;
begin
  if Pg[nCh] = nil then Exit;
  if m_TransData.TotalSize = 0 then Exit;
  if pg[nCh].StatusSpi = pgDisconnect  then Exit;

  PG[nCh].m_sFwVerSpi    := '';
  PG[nCh].m_sBootVerSpi  := '';
  PG[nCh].m_wModelCrcSpi := 0;
  PG[nCh].m_bFwVerReqSpi := False;

  PG[nCh].m_hGuiFrm := Self.Handle;

  thDownload := TThread.CreateAnonymousThread(procedure begin
    PG[nCh].SendSpiFwDownFlow(nType,m_TransData);  //TBD:MERGE?
  end);
  thDownload.Start;
end;

function TfrmDownloadFwSpi.GetFileData(sFileName: string): Boolean;
var
  trStream : TMemoryStream;
  bIsFileReadNg : boolean;
  dwCheckSum : DWORD;
begin
  bIsFileReadNg := True;
  trStream := TMemoryStream.Create;
  try
    trStream.LoadFromFile(sFileName);
    trStream.Position := 0;
    m_TransData.TotalSize := trStream.Size;
    pgrbDataDownload.Percent := 0;
    pgrbDataDownload2.Percent := 0;
    pnlDownload.Caption := '';
    pnlDownload.Caption := '';
    SetLength(m_TransData.Data,m_TransData.TotalSize);
    CopyMemory(@m_TransData.Data[0],trStream.Memory,m_TransData.TotalSize);
    dwCheckSum := 0;
    Common.CalcCheckSum(@m_TransData.Data[0],m_TransData.TotalSize,dwCheckSum);
    m_TransData.CheckSum := dwCheckSum;
    bIsFileReadNg := False;
  finally
    trStream.Free;
  end;
  Result := bIsFileReadNg;
end;

procedure TfrmDownloadFwSpi.RzBitBtn2Click(Sender: TObject);
begin
  Common.MLog(DefPocb.SYS_LOG,'<SPI_FW_DOWNLOAD> Window Close');
  Close;
end;

procedure TfrmDownloadFwSpi.WMCopyData(var Msg: TMessage);
var
  nType, nPgNo, nMode, nTotal, nCurPos : Integer;
  bIsDone : Boolean;
  sMsg, sDebug : string;
begin
  nType := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.MsgType;

  case nType of
    DefPocb.MSG_TYPE_PG : begin
      nMode   := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nPgNo   := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.PgNo;
      nTotal  := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.Total;
      nCurPos := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.CurPos;
      sMsg    := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.sMsg;
      bIsDone := PGuiPgDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.IsDone;
      case nMode of
        DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS : begin
          case nPgNo of
            DefPocb.CH_1 : begin
              pnlDownload.Caption := Format('%s (%d / %d) ',[sMsg, nCurPos,nTotal]);
              pgrbDataDownload.Percent := (nCurPos * 100)  div nTotal;
            end;
            DefPocb.CH_2 : begin
              pnlDownload2.Caption := Format('%s (%d / %d) ',[sMsg, nCurPos,nTotal]);
              pgrbDataDownload2.Percent := (nCurPos * 100)  div nTotal;
            end;
          end;
          btnDownload.Enabled := bIsDone;
        end;
      end;
    end;
  end;
  // SendDisplayGuiDisplay(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nTotalSize,nDiv,i);
end;

end.
