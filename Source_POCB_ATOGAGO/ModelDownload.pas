unit ModelDownload;
{$I Common.inc}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, Vcl.ExtCtrls, DefPocb, RzPrgres, RzPanel, RzCommon,
  LogicPocb, CommonClass, UdpServerPocb, DefPG, CamComm;

type
  TfrmModelDownload = class(TForm)
    btnExit             : TRzBitBtn;
    pnlDpcConfigSet     : TPanel;
    pnlErrorDisplay     : TPanel;
    pnlManualFusing     : TPanel;
    pnl2: TPanel;
    pnl1: TPanel;
    pnl5: TPanel;
    pnl4: TPanel;
    tmrErrorDisplayOff  : TTimer;
    tmrFrmclose         : TTimer;
    //NEW(METHODS)------------------
    //OLD(METHODS)------------------
    procedure btnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WMCopyData(var Msg : TMessage); message WM_COPYDATA;
    procedure tmrErrorDisplayOffTimer(Sender: TObject);
    procedure tmrFrmcloseTimer(Sender: TObject);
  private
    //NEW(ATTIBUTES)------------------
    //OLD(ATTIBUTES)------------------

    //NEW(METHODS)------------------
    //OLD(METHODS)------------------
    { Private declarations }
    pnlDownLoadStatus     : array[DefPocb.CH_1..DefPocb.CH_MAX] of TRzPanel;
    pgbDownload           : array[DefPocb.CH_1..DefPocb.CH_MAX] of TRzProgressBar;
{$IFDEF REF_SDIP}  //TBD???
//    pnlGrpCamStatus       : TRzPanel;     //TBD?
{$ELSE}
    pnlGrpCamStatus       : TRzPanel;
{$ENDIF}
    pnlCamStatus          : array[DefPocb.CH_1..DefPocb.CH_MAX] of TRzPanel;  //TBD? CH?JIG?
    procedure SetCamModel;
  public
    { Public declarations }
  end;

var
  frmModelDownload: TfrmModelDownload;

implementation

{$R *.dfm}

//******************************************************************************
// procedure/function: Create/Destroy/Init
//    -
//******************************************************************************

procedure TfrmModelDownload.FormCreate(Sender: TObject);
var
  nPG, nCAM, nCH, i, nHeight : Integer;
  SetPatGrp           : TPatternGroup;
  sTemp : string;
  fileTrans           : TArray<TFileTranStr>; // init1, init2, init3, oprg
  nTotalSize          : Integer;
  dChecksum           : dword;
  getFileData         : TArray<System.Byte>;
  nTotalDownCnt       : Integer;
  bCheckConn          : boolean;  //TBD?: SDIP: no use bCheckConn
begin
  // GUI: PG Download -----------------
  //  - PG Download Status & Progress Bar
  nHeight := (pnlManualFusing.Height div DefPocb.CH_CNT) - 2;
  for nPG := DefPocb.PG_1 to DefPocb.PG_MAX do begin
    //
    pnlDownLoadStatus[nPG]              := TRzPanel.Create(nil);
    pnlDownLoadStatus[nPG].Parent       := pnlManualFusing;
    pnlDownLoadStatus[nPG].Top          := nPG*(nHeight+2);
    pnlDownLoadStatus[nPG].Height       := nHeight;
    pnlDownLoadStatus[nPG].Width        := pnlManualFusing.Width;
    pnlDownLoadStatus[nPG].Color        := clSkyBlue;//clMaroon;
    pnlDownLoadStatus[nPG].Font.Size    := 10;
    pnlDownLoadStatus[nPG].BorderOuter  := TframeStyleEx(fsFlat);
    pnlDownLoadStatus[nPG].Caption      := '';
    pnlDownLoadStatus[nPG].Visible      := True;
    pnlDownLoadStatus[nPG].Font.Color   := clBlack;
    pnlDownLoadStatus[nPG].Caption      := Format('PG CH %d',[nPG+1]);
    pnlDownLoadStatus[nPG].AlignmentVertical := avTop;
    //
    pgbDownload[nPG]            := TRzProgressBar.Create(nil);
    pgbDownload[nPG].Visible    := False;
    pgbDownload[nPG].Parent     := pnlDownLoadStatus[nPG];
    pgbDownload[nPG].Top        := nHeight - (pnlDownLoadStatus[nPG].Height  div 2); // 0;
    pgbDownload[nPG].Left       := 0;
    pgbDownload[nPG].Font.Size  := 8;
    pgbDownload[nPG].Height     := pnlDownLoadStatus[nPG].Height div 2;//pnlDownLoadStatus[i].Height div 4;
    pgbDownload[nPG].Width      := pnlDownLoadStatus[nPG].Width;
    pgbDownload[nPG].Visible    := True;
  end;

  // GUI: Camera Channel Info? -----------------
  nHeight := (pnlDpcConfigSet.Height div DefPocb.CH_CNT) - 2;
  for nCAM := DefPocb.CAM_1 to DefPocb.CAM_MAX do begin
    pnlCamStatus[nCAM]              := TRzPanel.Create(nil);
    pnlCamStatus[nCAM].Parent       := pnlDpcConfigSet;
    pnlCamStatus[nCAM].Top          := nCAM*(nHeight+2);
    pnlCamStatus[nCAM].Height       := nHeight;
    pnlCamStatus[nCAM].Width        := pnlDpcConfigSet.Width;
    pnlCamStatus[nCAM].Color        := clMoneyGreen;//clMaroon;
    pnlCamStatus[nCAM].Font.Color   := clBlack;
    pnlCamStatus[nCAM].Font.Size    := 10;
    pnlCamStatus[nCAM].BorderOuter  := TframeStyleEx(fsFlat);
    pnlCamStatus[nCAM].Caption      := '';
    pnlCamStatus[nCAM].Visible      := True;
    pnlCamStatus[nCAM].Caption      := Format('DPC CH %d',[nCAM+1]);
  end;

  // Load and Check Pattern Group -----------------
  SetPatGrp := Common.LoadPatGroup(Common.TestModelInfo.PatGrpName);  //TBD?: SDIP: Common.TempModelInfo2.PatGrpName
  for i := 0 to Pred(SetPatGrp.PatCount) do begin  // 해당 pattern File이 있는지 확인
    case SetPatGrp.PatType[i] of
      DefPocb.PTYPE_NORMAL : begin
        Continue;
      end;
      DefPocb.PTYPE_BITMAP : begin
        sTemp := Common.Path.BMP + Trim(string(SetPatGrp.PatName[i]));
      end;
    end;
    if not FileExists(sTemp) then begin
      pnlErrorDisplay.caption := Format('Please Check Pattern File(%s)',[sTemp]);
      pnlErrorDisplay.Visible := True;
      tmrErrorDisplayOff.Interval := 3000;
      tmrErrorDisplayOff.Enabled  := True;
      exit;
    end;
  end;

  nTotalDownCnt :=  3+SetPatGrp.PatCount;
  SetLength(fileTrans,nTotalDownCnt);
  for i := 0 to Pred(nTotalDownCnt) do begin
    fileTrans[i].filePath := AnsiString(Common.Path.ModelCode);
    fileTrans[i].TransMode  := DefPocb.DOWNLOAD_TYPE_PRG;
    case i of
      0 : fileTrans[i].fileName  := AnsiString(Common.SystemInfo.TestModel + '.oprg');
      1 : fileTrans[i].fileName  := AnsiString(Common.SystemInfo.TestModel + '.iprg1');
      2 : fileTrans[i].fileName  := AnsiString( Common.SystemInfo.TestModel + '.iprg2')
//    3 : fileTrans[i].fileName  := Common.SystemInfo.TestModel + '.iprg3'
      else begin
        fileTrans[i].fileName   := AnsiString(StringReplace(string(SetPatGrp.PatName[i-3]),'.bmp','.raw', [rfReplaceAll, rfIgnoreCase]));
        if SetPatGrp.PatType[i] = PTYPE_BITMAP then begin
          fileTrans[i].filePath   := AnsiString(Common.Path.BMP);
        end
        else begin
          fileTrans[i].filePath   := AnsiString(Common.Path.Pattern);
        end;
      end;
    end;
    case i of
      0 : fileTrans[i].TransType  := DefPG.FUSING_TYPE_OFF;
      1 : fileTrans[i].TransType  := DefPG.FUSING_TYPE_INI;
      2 : fileTrans[i].TransType  := DefPG.FUSING_TYPE_INI2
//    3 : fileTrans[i].TransType  := DefPG.FUSING_TYPE_INI3
      else begin
        fileTrans[i].TransType  := DefPG.FUSING_TYPE_PAT_INFO;
      end;
    end;
    dChecksum := 0;
    if i in [0,1,2] then begin
      Common.LoadCheckSumNData(string(fileTrans[i].filePath+fileTrans[i].fileName),dChecksum,nTotalSize,getFileData);
    end
    else begin
      Common.MakePatternData(i-3,SetPatGrp,dChecksum,nTotalSize,getFileData);
    end;

    fileTrans[i].CheckSum   := dChecksum;
    fileTrans[i].TotalSize  := nTotalSize;
    SetLength(fileTrans[i].Data, nTotalSize);
    CopyMemory(@fileTrans[i].Data[0],@getFileData[0],nTotalSize);
  end;

  Common.TestModelInfo := Common.EdModelInfo;
//주의. signal type은 시작이 1 부터임. 데이턴는 0으로 되어 있음.
//Common.TestModelInfo.SigType := Common.TempModelInfo.SigType + 1;
//Common.TestModelInfo.SPI_Bit := Common.TempModelInfo.SPI_Bit + 1;
//Common.TestModelInfo.I2C_bit := Common.TempModelInfo.I2C_bit + 1;
//if Common.TempModelInfo.SPI_Clock = 0 then Common.TestModelInfo.SPI_Clock := 50
//else if Common.TempModelInfo.SPI_Clock = 1 then Common.TestModelInfo.SPI_Clock := 100;
//if Common.TempModelInfo.Model_Type < 11 then Common.TempModelInfo.Model_Type := 10
//else                                         Common.TestModelInfo.Model_Type := Common.TempModelInfo.Model_Type;
//Common.TestModelInfo.Freq := Common.TempModelInfo.Freq;
  bCheckConn := False;

	for nPG := DefPocb.PG_1 to DefPocb.PG_MAX do begin
    if Logic[nCh].PgConnection then begin   //TBD?: nPG -> nCh(s)
      bCheckConn := True;  //TBD?: SDIP: comment-out
      pnlDownLoadStatus[nPG].Color      := clSkyBlue;
      pnlDownLoadStatus[nPG].Font.Color := clBlack;
    end
    else begin
      pnlDownLoadStatus[nPG].Color      := clMaroon;
      pnlDownLoadStatus[nPG].Font.Color := clYellow;
      pnlDownLoadStatus[nPG].Caption    := Format('CH%d - PG Disconnected',[nPG+1]);  //TBD?: nPG -> nCh(s)
    end;
    Logic[nPG].SendModelInfoDownLoad(Self.Handle,nTotalDownCnt,fileTrans);  //TBD?: nPG -> nCh(s)
	end;

  Common.TestModelInfo := Common.EdModelInfo;  //TBD?: SDIP: Common.TempModelInfo2.PatGrpName

//  if not bCheckConn then tmrFrmclose.Enabled := True;

  SetCamModel;  //TBD?
end;

procedure TfrmModelDownload.SetCamModel;
//var
//  nCAM : Integer;
//  sCamChange, sTemp : string;
//  slstData : TStringList;
begin
//  sTemp := 'MODELCHG '+ Common.SystemInfo.TestModel;
//  try
//    slstData:= TStringList.create;
//    ExtractStrings(['-'],[],PChar(sTemp), slstData);
//    if slstData.Count > 4 then begin
//      sCamChange := Format('%s-%s-%s',[slstData[2],slstData[3],slstData[4]]);
//      sTemp := 'MODELCHG '+ sCamChange; // model change command 빠지는 문제 때문에...
//    end;
//    sCamChange := sTemp;
    CameraComm.m_hModelDown := Self.Handle;  //TBD?
    CameraComm.SetModelSet;
//    for nCAM := DefPocb.CAM_1 to DefPocb.CAM_MAX do begin
//      if not CameraComm.SendCmd(nCAM,sCamChange) then Break; // False이면 연결 중지.
//    end;
//  finally
//    slstData.Free;
//    slstData := nil;
//  end;
end;

procedure TfrmModelDownload.btnExitClick(Sender: TObject);
begin
  Close;
end;

//******************************************************************************
// procedure/function:
//    -
//******************************************************************************

procedure TfrmModelDownload.tmrErrorDisplayOffTimer(Sender: TObject);
begin
  tmrErrorDisplayOff.Enabled := False;
  pnlErrorDisplay.Visible := False;
end;

procedure TfrmModelDownload.tmrFrmcloseTimer(Sender: TObject);
begin
  tmrFrmclose.Enabled := False;
  close;
end;

//******************************************************************************
// procedure/function:
//    - WMCopyData(var Msg: TMessage)
//        MSG_TYPE_LOGIC
//            MSG_MODE_MODEL_DOWN_START
//            MSG_MODE_MODEL_DOWN_END
//            MSG_MODE_MODEL_DOWNLOADING
//        MSG_TYPE_PG
//            MSG_MODE_TRANS_DOWNLOAD_STATUS
//        MSG_TYPE_CAMERA
//            MSG_MODE_WORKING
//            MSG_MODE_MODEL_DOWN_END //TBD:SDIP?
//******************************************************************************

procedure TfrmModelDownload.WMCopyData(var Msg: TMessage);
var
  nType, nPG, nCAM, nMode, nParam : Integer;
  bTemp : boolean;
  sMsg : string;
  i, nTotal, nCur: Integer;
begin
  nType := PGuiData(PCopyDataStruct(Msg.LParam)^.lpData)^.MsgType;
  nPg   := PGuiData(PCopyDataStruct(Msg.LParam)^.lpData)^.Channel;
//  sMsg  := PGuiData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;
  case nType of
    //--------------------------------------------
    DefPocb.MSG_TYPE_LOGIC : begin
      nMode := PGuiData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      case nMode of
        DefPocb.MSG_MODE_MODEL_DOWN_START : begin  //---------- from LogicPocb
//          if not pnlManualFusing.Visible then pnlManualFusing.Visible := True;
          nParam := PGuiData(PCopyDataStruct(Msg.LParam)^.lpData)^.Data[1];
          sMsg := Format('PG %d Start Model Info downloading ...',[nPg+1]);
          if nParam <> 0 then begin
            sMsg := sMsg + '(Download NG) Please Check Model Info or Connection';
            pnlDownLoadStatus[nPg].Color := clMaroon;
            pnlDownLoadStatus[nPg].Font.Color := clYellow;
          end
          else begin
            pnlDownLoadStatus[nPg].Color := clSkyBlue;
            pnlDownLoadStatus[nPg].Font.Color := clBlack;
          end;
          pnlDownLoadStatus[nPg].Visible := True;
          pnlDownLoadStatus[nPg].Caption := sMsg;
          pgbDownload[nPg].Percent := 0;
          pgbDownload[nPg].Visible := True;
        end;
        DefPocb.MSG_MODE_MODEL_DOWN_END : begin  //---------- from LogicPocb
          pgbDownload[nPg].Visible := False;
          pgbDownload[nPg].Percent :=0;
          pnlDownLoadStatus[nPg].Visible := False;
          pnlDownLoadStatus[nPg].Caption := '';
          bTemp := False;
          for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
            if pnlDownLoadStatus[nPg].Visible then begin
              bTemp := True;
              break;
            end;
          end;
{$IFDEF REF_SDIP}
          if not bTemp then begin
            for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
              if pnlCamStatus[i].Visible then begin
                bTemp := True;
                break;
              end;
            end;
          end;
{$ENDIF}
          if not bTemp then begin
            Common.Delay(1000);
            pnlManualFusing.Visible := False;
            Close;
          end;

        end;
        DefPocb.MSG_MODE_MODEL_DOWNLOADING : begin  //----------
          pnlDownLoadStatus[nPg].Caption := sMsg;
        end;

      end;
    end;
    //--------------------------------------------
    DefPocb.MSG_TYPE_PG : begin
      nMode := PTranStatus(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      case nMode of
        DefPocb.MSG_MODE_TRANS_DOWNLOAD_STATUS : begin  //----------
          nTotal  := PTranStatus(PCopyDataStruct(Msg.LParam)^.lpData)^.Total;
          nCur    := PTranStatus(PCopyDataStruct(Msg.LParam)^.lpData)^.CurPos;
          sMsg    := string(PTranStatus(PCopyDataStruct(Msg.LParam)^.lpData)^.sMsg);
          pnlDownLoadStatus[nPg].Caption := sMsg;
          pgbDownload[nPg].Percent := (nCur * 100) div nTotal;
        end;
      end;

    end;
    //--------------------------------------------
    DefPocb.MSG_TYPE_CAMERA : begin   // Camera.
      nMode := PGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      sMsg := Trim(PGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg);
      nParam := PGuiCamData(PCopyDataStruct(Msg.LParam)^.lpData)^.Param1;
      case nMode of
        DefPocb.MSG_MODE_WORKING : begin  //----------
        // 주의 ... Camera Ch과 PG Channel 다름.
          if nParam <> 0 then begin  // NG 처리.
            pnlCamStatus[nPg].Color := clMaroon;
            pnlCamStatus[nPg].Font.Color := clYellow;
          end
          else begin
            pnlCamStatus[nPg].Color := clMoneyGreen;
            pnlCamStatus[nPg].Font.Color := clBlack;
          end;
          pnlCamStatus[nPg].caption := Format('[DPC %d] : ',[nPg+1]) + sMsg;
          pnlCamStatus[nPg].Visible := True;

//          tmrDisplayOffMessage.Interval := 10000;
//          tmrDisplayOffMessage.Enabled := True;
        end;
{$IFDEF REF_SDIP}
        DefPocb.MSG_MODE_MODEL_DOWN_END : begin   //---------- //TBD:SDIP?
          pnlCamStatus[nPg].Visible := False;
          bTemp := False;
          for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
            if pnlDownLoadStatus[i].Visible then begin
              bTemp := True;
              break;
            end;
          end;

          if not bTemp then begin
            for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
              if pnlCamStatus[i].Visible then begin
                bTemp := True;
                break;
              end;
            end;
          end;
          if not bTemp then begin
            Common.Delay(1000);
            pnlManualFusing.Visible := False;
            Close;
          end;
        end;
{$ENDIF}
      end;
    end;
  end;
end;

end.
