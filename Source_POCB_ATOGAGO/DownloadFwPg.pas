unit DownloadFwPg;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzPrgres, RzPanel, Vcl.StdCtrls, RzCmboBx, RzShellDialogs, Vcl.Mask, RzEdit, RzButton,
  Vcl.ExtCtrls, CommonClass, DefPocb, DefPG, UdpServerPocb, IdGlobal;

const
  PG_FWDOWN_ITEM_FW   = 0;  // cboDownType.ItemIndex
  PG_FWDOWN_ITEM_FPGA = 1;  // cboDownType.ItemIndex
  PG_FWDOWN_ITEM_ALDP = 2;  // cboDownType.ItemIndex
  PG_FWDOWN_ITEM_DLPU = 3;  // cboDownType.ItemIndex

type

  PGuiFwDownData  = ^RGuiFwDownData;
  RGuiFwDownData = packed record
    MsgType : Integer;
    Channel : Integer;
    Mode    : Integer;
    DataLen : Integer;
    Data    : array[1..10] of Integer;  //TBD:MERGE? Defcommon.MAX_GUI_DATA_CNT = 10
    Msg     : string;
  end;

  TfrmDownloadFwPg = class(TForm)
    RzGroupBox1: TRzGroupBox;
    btnFileOpen: TRzBitBtn;
    edFileName: TRzEdit;
    odglfile: TRzOpenDialog;
    cboDownType: TRzComboBox;
    RzPanel1: TRzPanel;
    pgrbDataDownload1: TRzProgressBar;
    pgrbDataDownload2: TRzProgressBar;
    btnDownload: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    pnlDownload1: TRzPanel;
    pnlDownload2: TRzPanel;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure RzBitBtn2Click(Sender: TObject);
    procedure btnFileOpenClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
  private
    { Private declarations }
    FhDisplay : HWND;
    m_bDownloding : array [0..DefPocb.CH_MAX] of Boolean;
    function StartFileDownload(nPg: Integer; sFilName: string; nType: Integer): Boolean;
    procedure FWDownload_DP489(nPg: Integer;sFilName : string; nType : Integer);
    procedure FWDownload_DP200(nPg: Integer;sFilName : string; nType : Integer);
    procedure SendDisplayGuiDisplay(nGuiMode : Integer; nPg: Integer; nParam : Integer = 0; nParam2 : Integer = 0; nParam3 : Integer = 0);
    procedure WMCopyData(var Msg : TMessage); message WM_COPYDATA;
  public
    { Public declarations }
  end;

var
  frmDownloadFwPg: TfrmDownloadFwPg;

implementation

{$R *.dfm}

uses OtlTaskControl, OtlParallel;  //2020-07-16 Important to Tacttime (uses OtlTaskControl, OtlParallel in here) !!!

procedure TfrmDownloadFwPg.FormCreate(Sender: TObject);
var
  nPg : Integer;
begin
  Common.MLog(DefPocb.SYS_LOG,'<PG_FW_DOWNLOAD> Window Open');
  //
  FhDisplay := Self.Handle;
  for nPg := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    m_bDownloding[nPg] := False;
  end;
  //
  cboDownType.ItemIndex := PG_FWDOWN_ITEM_FW;
end;

procedure TfrmDownloadFwPg.FWDownload_DP489(nPg: Integer; sFilName: string; nType: Integer);
var
  btTxBuf, btTx1kBuf : TIdBytes;
  nTotalSize : Integer;
  btRawData : TIdBytes;
  StreamA : TMemoryStream;
  dGetCheckSum : dword;
  i, nDiv, nMod : Integer;
  nStartWaitSec, nEndWaitSec : Integer;
begin
  //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
  Pg[nPg].SetCyclicTimerPg(False{bEnable});

{$IFDEF 1PG2CH}
  nPg := 0;
{$ENDIF}

  case nType of
    DefPG.PGSIG_DP489_FWDOWN_TYPE_FW   : begin  //#FUSING_TYPE_PG_DP489_FW
			nStartWaitSec := Common.SystemInfo.PgFwDownStartWaitSec;   
			nEndWaitSec   := Common.SystemInfo.PgFwDownEndWaitSec;
		end;
    DefPG.PGSIG_DP489_FWDOWN_TYPE_FPGA : begin  //#FUSING_TYPE_PG_DP489_FPGA
			nStartWaitSec := Common.SystemInfo.PgFpgaDownStartWaitSec; 
			nEndWaitSec   := Common.SystemInfo.PgFpgaDownEndWaitSec;
		end
    else 
			Exit;
  end;

      // Read Raw file.
      // load file data
      StreamA := TMemoryStream.Create;
      try
        StreamA.LoadFromFile(sFilName);
        StreamA.Position := 0;
        nTotalSize := StreamA.Size;
        SetLength(btRawData,nTotalSize);
        CopyMemory(@btRawData[0],StreamA.Memory,nTotalSize);
      finally
        StreamA.Free;
        StreamA := nil;
      end;
      dGetCheckSum := 0;
      Common.CalcCheckSum(@btRawData[0],nTotalSize,dGetCheckSum);

      SetLength(btTxBuf,10);
      btTxBuf[0] := Byte(nType);
      btTxBuf[1] := $0; // 으로 고정하자.
      CopyMemory(@btTxBuf[2],@nTotalSize,4);
      CopyMemory(@btTxBuf[6],@dGetCheckSum,4);

      if Pg[nPg].SendPgFwDownStartEnd(10,btTxBuf,nStartWaitSec*1000) = WAIT_OBJECT_0 then begin
        nDiv := nTotalSize div 1024;
        SendDisplayGuiDisplay(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nPg,0,0,0);
        SetLength(btTx1kBuf,1024);
        for i  := 0 to pred(nDiv) do begin
          CopyMemory(@btTx1kBuf[0],@btRawData[i*1024],1024);
          Pg[nPg].SendPgRawDataPkt(btTx1kBuf);
          Sleep(10);
          SendDisplayGuiDisplay(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nPg,nTotalSize,nDiv,i);
        end;
        nMod := nTotalSize mod 1024;
        if nMod <> 0 then begin
          SetLength(btTx1kBuf,nMod);
          CopyMemory(@btTx1kBuf[0],@btRawData[nDiv * 1024],nMod);
          Pg[nPg].SendPgRawDataPkt(btTx1kBuf);
        end;
        Sleep(100);

        Pg[nPg].SendPgReset;
        SendDisplayGuiDisplay(DefPocb.MSG_MODE_TRANS_DOWNLOAD_END,nPg);
      end;

  //---------------------------------- Enable Cyclic Timers (AliveCheck, PowerMeasure)
  Pg[nPg].SetCyclicTimerPg(True{bEnable});
end;

procedure TfrmDownloadFwPg.FWDownload_DP200(nPg: Integer;sFilName: string; nType: Integer); //DP200|DP201
var
  dwRtn : DWORD;
  btTxBufStartEnd, btTxBufData : TIdBytes;
  nTotalSize : Integer;
  btRawData : TIdBytes;
  StreamA : TMemoryStream;
  dGetCheckSum : dword;
  i, nDiv, nMod : Integer;
  nIndex : Word;
  nStartWaitSec, nEndWaitSec : Integer;
begin
  //---------------------------------- Disable Cyclic Timers (AliveCheck, PowerMeasure)
  Pg[nPg].SetCyclicTimerPg(False{bEnable});

{$IFDEF 1PG2CH}
  nPg := 0;
{$ENDIF}

  case nType of
    DefPG.PGSIG_DP20X_FWDOWN_TYPE_FW : begin //#FUSING_TYPE_PG_DP200_FW
      nStartWaitSec := Common.SystemInfo.PgFwDownStartWaitSec;
      nEndWaitSec   := Common.SystemInfo.PgFwDownEndWaitSec;
    end;
    DefPG.PGSIG_DP20X_FWDOWN_TYPE_FPGA : begin //#FUSING_TYPE_PG_DP200_FPGA
      nStartWaitSec := Common.SystemInfo.PgFpgaDownStartWaitSec;
      nEndWaitSec   := Common.SystemInfo.PgFpgaDownEndWaitSec;
    end;
    DefPG.PGSIG_DP20X_FWDOWN_TYPE_ALDP : begin //#FUSING_TYPE_PG_DP200_ALDP
      nStartWaitSec := Common.SystemInfo.PgALDPDownStartWaitSec;
      nEndWaitSec   := Common.SystemInfo.PgALDPDownEndWaitSec;
    end;
    DefPG.PGSIG_DP20X_FWDOWN_TYPE_DLPU : begin //2023-07-01
      nStartWaitSec := Common.SystemInfo.PgDLPUDownStartWaitSec;
      nEndWaitSec   := Common.SystemInfo.PgDLPUDownEndWaitSec;
    end;
    else Exit;
  end;

  // Read Raw file.
  StreamA := TMemoryStream.Create;
  try
    StreamA.LoadFromFile(sFilName);
    StreamA.Position := 0;
    nTotalSize := StreamA.Size;
    SetLength(btRawData,nTotalSize);
    CopyMemory(@btRawData[0],StreamA.Memory,nTotalSize);
  finally
    StreamA.Free;
    StreamA := nil;
  end;
  dGetCheckSum := 0;
  Common.CalcCheckSum(@btRawData[0],nTotalSize,dGetCheckSum);

  // Make FW_FOWNLOAD Start Message
  SetLength(btTxBufStartEnd,40);
  btTxBufStartEnd[0] := Byte(nType);               // 0:FPGA, 1:FW, 2:ALDP, 3:DLPU
  btTxBufStartEnd[1] := Byte('S');                 // 'S':Start, 'E':End
  nIndex := 0;
  CopyMemory(@btTxBufStartEnd[2], @nIndex, 2);     // 0
  for i := 0 to 31 do btTxBufStartEnd[4+i] := 0;   // filename[32]: all 0
  CopyMemory(@btTxBufStartEnd[36],@nTotalSize,4);  // fileSize (if Start), checksum (if End)
  dwRtn := Pg[nPg].SendPgFwDownStartEnd(40,btTxBufStartEnd,nStartWaitSec*1000);
  if dwRtn = WAIT_OBJECT_0 then begin

    nDiv := nTotalSize div 1024;
    SendDisplayGuiDisplay(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nPg,0,0,0);
    SetLength(btTxBufData,1024);
    for i  := 0 to pred(nDiv) do begin
      CopyMemory(@btTxBufData[0],@btRawData[i*1024],1024);
      Pg[nPg].SendPgRawDataPkt(btTxBufData);
      Sleep(10);  //2021-11-11 (10->20)
      SendDisplayGuiDisplay(DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS, nPg,nTotalSize,nDiv,i);
    end;
    nMod := nTotalSize mod 1024;
    if nMod > 0 then begin
      SetLength(btTxBufData,nMod);
      CopyMemory(@btTxBufData[0],@btRawData[nDiv * 1024],nMod);
      Pg[nPg].SendPgRawDataPkt(btTxBufData);
    end;
    Sleep(100);

    // Make FW_FOWNLOAD End Message
  //btTxBufStartEnd[0] := Byte(nType);                 // 0:FPGA, 1:FW  //2021-07-09
    btTxBufStartEnd[1] := Byte('E');                   // 'S':Start, 'E':End
  //nIndex := 0;
  //CopyMemory(@btTxBufStartEnd[2], @nIndex, 2);       // 0
  //for i := 0 to 31 do btTxBufStartEnd[4+i] := 0;     // filename[32]: all 0
    CopyMemory(@btTxBufStartEnd[36],@dGetCheckSum,4);  // fileSize (if Start), checksum (if End)
    dwRtn := Pg[nPg].SendPgFwDownStartEnd(40,btTxBufStartEnd,nEndWaitSec*1000);
    if dwRtn = WAIT_OBJECT_0 then begin
    end;
    //
    Sleep(100);
  //TBD:MERGE? Pg[nPg].SendPgReset; //DP201(Delete?)
		SendDisplayGuiDisplay(DefPocb.MSG_MODE_TRANS_DOWNLOAD_END,nPg);
  end;

  //---------------------------------- Enable Cyclic Timers (AliveCheck, PowerMeasure)
  Pg[nPg].SetCyclicTimerPg(True{bEnable});
end;

procedure TfrmDownloadFwPg.btnDownloadClick(Sender: TObject);
var
  nPg, nFileType : Integer;
  bDownStart    : Boolean;
  sFileName     : string;
begin
  nFileType := -1;
  if Trim(edFileName.Text) <> '' then begin
    btnDownload.Enabled := False;

    bDownStart := False;

    case Common.SystemInfo.PG_TYPE of
      DefPG.PG_TYPE_DP489: begin  //DP489
        case cboDownType.ItemIndex of
          PG_FWDOWN_ITEM_FW   : nFileType := DefPG.PGSIG_DP489_FWDOWN_TYPE_FW;
          PG_FWDOWN_ITEM_FPGA : nFileType := DefPG.PGSIG_DP489_FWDOWN_TYPE_FPGA;
					else Exit;					
        end;
      end;
      DefPG.PG_TYPE_DP200, DefPG.PG_TYPE_DP201: begin
        case cboDownType.ItemIndex of
          PG_FWDOWN_ITEM_FW   : nFileType := DefPG.PGSIG_DP20X_FWDOWN_TYPE_FW;
          PG_FWDOWN_ITEM_FPGA : nFileType := DefPG.PGSIG_DP20X_FWDOWN_TYPE_FPGA;
          PG_FWDOWN_ITEM_ALDP : nFileType := DefPG.PGSIG_DP20X_FWDOWN_TYPE_ALDP;
          PG_FWDOWN_ITEM_DLPU : nFileType := DefPG.PGSIG_DP20X_FWDOWN_TYPE_DLPU; //2023-07-01
					else Exit;
        end;
      end;
      else begin
				Exit;
     end;
    end;
    if nFileType = -1 then begin
      ShowMessage('Unknown download type !!');
      btnDownload.Enabled := True;
      Exit;
    end;
    //
    sFileName := Trim(edFileName.Text);
    if FileExists(sFileName) then begin
{$IFDEF 1PG2CH}
			nPg := 0;		
      if not StartFileDownload(nPg,sFileName,nFileType) then begin
        btnDownload.Enabled := True;
      end;
{$ELSE}
      for nPg := DefPocb.CH_1 to DefPocb.CH_MAX do begin
        if not StartFileDownload(nPg,sFileName,nFileType) then begin
          m_bDownloding[nPg] := False;
        end
        else begin
          bDownStart := True;
          m_bDownloding[nPg] := True;
        end;
      end;
      if not bDownStart then btnDownload.Enabled := True;
{$ENDIF}
    end
    else begin
      ShowMessage(sFileName + ' file does not exist !!!');
      btnDownload.Enabled := True;
    end;
  end;
end;

procedure TfrmDownloadFwPg.btnFileOpenClick(Sender: TObject);
var
  sPgName : string;
begin
  //
  sPgName := '';
  case Common.SystemInfo.PG_TYPE of
    PG_TYPE_DP489: sPgName := 'DP489';
    PG_TYPE_DP200: sPgName := 'DP200';
    PG_TYPE_DP201: sPgName := 'DP201';
    else Exit;
  end;
  //
  case cboDownType.ItemIndex of
    PG_FWDOWN_ITEM_FW : begin  // PG-FW
      odglfile.InitialDir := Common.Path.PG_FW;
      odglfile.Filter     := 'bin files('+sPgName+'*.bin)|'+sPgName+'*.bin';
      odglfile.FilterIndex:= 1;
    end;
    PG_FWDOWN_ITEM_FPGA : begin  // PG-FPGA
      odglfile.InitialDir := Common.Path.PG_FPGA;
      odglfile.Filter     := 'bin files('+sPgName+'*.rbf)|'+sPgName+'*.rbf';
      odglfile.FilterIndex:= 1;
    end;
    PG_FWDOWN_ITEM_ALDP : begin  // PG-ALPDP
      sPgName := 'DF565'; //2022-10-28
      odglfile.InitialDir := Common.Path.PG_ALPDP;
      odglfile.Filter     := 'bin files('+sPgName+'*.bin)|'+sPgName+'*.bin';
      odglfile.FilterIndex:= 1;
    end;
    PG_FWDOWN_ITEM_DLPU : begin  // DLPU //TBD:DLPU? 2023-07-01
      sPgName := 'DLPU';
      odglfile.InitialDir := Common.Path.PG_DLPU;
      odglfile.Filter     := 'bin files('+sPgName+'*.bin)|'+sPgName+'*.bin';
      odglfile.FilterIndex:= 1;
    end;
    else Exit;
  end;
  if odglfile.Execute then begin
    edFileName.Text := odglfile.FileName;
//{$IFDEF 1PG2CH}
//    pgrbDataDownload.Percent := 0;
//{$ELSE}
    pgrbDataDownload1.Percent := 0;
    pgrbDataDownload2.Percent := 0;
//{$ENDIF}
  end;
end;

procedure TfrmDownloadFwPg.RzBitBtn2Click(Sender: TObject);
begin
  Common.MLog(DefPocb.SYS_LOG,'<PG_FW_DOWNLOAD> Window Close');
  Close;
end;

procedure TfrmDownloadFwPg.SendDisplayGuiDisplay(nGuiMode, nPg, nParam, nParam2, nParam3: Integer);
var
  ccd         : TCopyDataStruct;
  FGuiData    : RGuiFwDownData;
begin
{$IFDEF 1PG2CH}
	nPg := 0; //TBD:1PG2CH?
{$ENDIF}
  FGuiData.MsgType := DefPocb.MSG_TYPE_DOWNLOAD;
  FGuiData.Channel := nPg;
  FGuiData.Mode    := nGuiMode;
  FGuiData.Data[1] := nParam;
  FGuiData.Data[2] := nParam2;
  FGuiData.Data[3] := nParam3;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(FGuiData);
  ccd.lpData      := @FGuiData;
  SendMessage(FhDisplay,WM_COPYDATA,0, LongInt(@ccd));
end;

function TfrmDownloadFwPg.StartFileDownload(nPg: Integer; sFilName: string; nType: Integer): Boolean;
var
  thread : TThread;
begin
{$IFDEF 1PG2CH}
	nPg := 0; //TBD:1PG2CH?
{$ENDIF}

  if Pg[nPg].StatusPg = pgDisconnect then begin
    Exit(False);
  end;
  if not FileExists(sFilName) then begin
    Exit(False);
  end;

  PG[nPg].m_sFwVerPg    := '';
  PG[nPg].m_sFpgaVerPg  := '';
  PG[nPg].m_bFwVerReqPg := False;

  PG[nPg].m_hGuiFrm := Self.Handle;
  thread := TThread.CreateAnonymousThread(procedure begin
    case Common.SystemInfo.PG_TYPE of
      PG_TYPE_DP489: begin
        FWDownload_DP489(nPg,sFilName,nType);
      end;
      PG_TYPE_DP200, PG_TYPE_DP201: begin
        FWDownload_DP200(nPg,sFilName,nType);
      end;
    end;
  end);
  thread.FreeOnTerminate := True;
  thread.Start;
  Result := True;
end;

procedure TfrmDownloadFwPg.WMCopyData(var Msg: TMessage);
var
  nType, nMode, nCh, nTemp, nTemp2, nTemp3 : Integer;
begin
  nType := PGuiFwDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.MsgType;
  case nType of
    DefPocb.MSG_TYPE_DOWNLOAD : begin
      nMode  := PGuiFwDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nCh    := PGuiFwDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;  //TBD:GB_PG-Only?
      nTemp  := PGuiFwDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.Data[1];
      nTemp2 := PGuiFwDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.Data[2];
      nTemp3 := PGuiFwDownData(PCopyDataStruct(Msg.LParam)^.lpData)^.Data[3];
      case nMode of
        DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS : begin
//{$IFDEF 1PG2CH}
//          pnlDownload.Caption := Format(' %d / %d ',[1024*nTemp3,nTemp]);
//          if nTemp2 <> 0 then begin
//            pgrbDataDownload.Percent := (nTemp3 * 100)  div nTemp2;
//          end
//          else begin
//            pgrbDataDownload.Percent := 0;
//          end;
//{$ELSE}
          case nCh of
            DefPocb.CH_1: begin
              pnlDownload1.Caption := Format(' %d / %d ',[1024*nTemp3,nTemp]);
              if nTemp2 <> 0 then pgrbDataDownload1.Percent := (nTemp3 * 100)  div nTemp2
              else                pgrbDataDownload1.Percent := 0;
            end;
            DefPocb.CH_2: begin
              pnlDownload2.Caption := Format(' %d / %d ',[1024*nTemp3,nTemp]);
              if nTemp2 <> 0 then pgrbDataDownload2.Percent := (nTemp3 * 100)  div nTemp2
              else                pgrbDataDownload2.Percent := 0;
            end;
          end;
//{$ENDIF}
        end;
        DefPocb.MSG_MODE_TRANS_DOWNLOAD_END : begin
//{$IFDEF 1PG2CH}
//          pgrbDataDownload.Percent := 100;
//          pnlDownload.Caption := 'Download Done.';
//          btnDownload.Enabled := True;
//{$ELSE}
          case nCh of
            DefPocb.CH_1: begin
              pgrbDataDownload1.Percent := 100;
              pnlDownload1.Caption := 'Download Done.';
              m_bDownloding[DefPocb.CH_1] := False;
            end;
            DefPocb.CH_2: begin
              pgrbDataDownload2.Percent := 100;
              pnlDownload2.Caption := 'Download Done.';
              m_bDownloding[DefPocb.CH_2] := False;
            end;
          end;
          if (not m_bDownloding[DefPocb.CH_1]) and (not m_bDownloding[DefPocb.CH_2]) then begin
            btnDownload.Enabled := True;
          end;
//{$ENDIF}
        end;
      end;
    end;
  end;
end;

end.
