unit WarningMsgAutoUpdate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, defAimf, RzAnimtr, Vcl.WinXCtrls, Vcl.ExtCtrls,
  RzPanel, Vcl.Imaging.pngimage, System.ImageList, Vcl.ImgList, AdvProgressBar;


type
  EventMsg = procedure(nMode : Integer; nParam : Integer; sData : string) of object;


type
  TfrmWarnMsgAim = class(TForm)
//  const
//    WMAU_LIST_GROUP_IDX_DEFAULT = 0;
//    WMAU_LIST_ITEM_EQP_ID  = 0;
//    WMAU_LIST_ITEM_USER_ID = 1;
//    WMAU_LIST_ITEM_OLD_SW  = 2;
//    WMAU_LIST_ITEM_NEW_SW  = 3;
//    WMAU_LIST_ITEM_OLD_MODEL  = 4;
//    WMAU_LIST_ITEM_NEW_MODEL  = 5;

    RzPanel1: TRzPanel;
    Image1: TImage;
    btnExit: TRzBitBtn;
    Panel1: TPanel;
    pnlStatus: TPanel;
    progDownloadStatus: TAdvProgressBar;
    pnlDownloadStatus: TPanel;
    tmrUpdate: TTimer;
    Timer1: TTimer;
    pnlEaarRet: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure WMCopyData(var Msg: TMessage); message WM_COPYDATA;
    procedure btnExitClick(Sender: TObject);
    procedure lstStatusItemChanged(Sender: TObject; itemindex: Integer);
    procedure tmrUpdateTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_sEqpId, m_sUserId, m_sModelName, m_sSwVer : string;
    FOnEventMsgData: EventMsg;
    fHandle : HWND;
    fCnt    : Integer;
    // nRet : 마지막 결과값이 0 : OK, 1 : 100% but NG, 2: not 100% - ng, 3 : 결과 까지 처리 되지 않음.
    FnDownloadRet : Integer;
    FsAutoLogIn   : string;
    procedure ShowCurrentStatus;
    procedure ShowSeqStatus(nTotal, nStep: Integer;sMsg : string);
    procedure SetOnEventMsgData(const Value: EventMsg);
  public
    { Public declarations }
    procedure InitMsg(bBlack : Boolean);
    procedure ShowSubExe;
    procedure SetInspectorInfo(sEqpId, sUserId, sModelName, sSwVer : PAnsiChar);
    property OnEventMsgData : EventMsg read FOnEventMsgData write SetOnEventMsgData;
    property DownloadRet : Integer read FnDownloadRet;
  end;

var
  frmWarnMsgAim: TfrmWarnMsgAim;

implementation

{$R *.dfm}


procedure TfrmWarnMsgAim.FormCreate(Sender: TObject);
var
  sDebug : string;
begin
  FnDownloadRet := defAimf.AIMF_RET_NOT_READY_NG;// 3;
  FsAutoLogIn   := '';
  fHandle := Self.Handle;
  Timer1.Interval := 200;
  Timer1.Enabled  := True;
//  sDebug := format('[INSPECTOR] TfrmWarnMsgAim.FormCreate - fHandle(%d), fHandle(%d)',[fHandle, self.Handle]);
//  CodeSite.SendMsg(csmBlue,sDebug);
  Self.Caption :=  defAimf.INS_COMM_CAPTION;
  InitMsg(False);
end;

procedure TfrmWarnMsgAim.FormDestroy(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TfrmWarnMsgAim.InitMsg(bBlack : Boolean);
begin
  progDownloadStatus.Max := 10;
  progDownloadStatus.Min := 0;
  progDownloadStatus.Position := 0;
  pnlDownloadStatus.Caption := '';
  pnlStatus.Caption := '';
  pnlStatus.Caption := '';
  ShowCurrentStatus;
end;

procedure TfrmWarnMsgAim.lstStatusItemChanged(Sender: TObject; itemindex: Integer);
begin
  ShowCurrentStatus;
end;

procedure TfrmWarnMsgAim.btnExitClick(Sender: TObject);
begin
  TThread.CreateAnonymousThread(procedure begin
    TThread.Synchronize(TThread.CurrentThread, procedure() begin
      OnEventMsgData(defAimf.MSG_MODE_INSP_UPDATE_FINISH,FnDownloadRet,FsAutoLogIn);
    end);
  end).Start;

  Close;
end;

procedure TfrmWarnMsgAim.SetInspectorInfo(sEqpId, sUserId, sModelName, sSwVer: PAnsiChar);
begin
  m_sEqpId := string(AnsiString(sEqpId)); m_sUserId := string(AnsiString(sUserId));
  m_sSwVer := string(AnsiString(sSwVer));
  m_sModelName := string(AnsiString(sModelName));
end;

procedure TfrmWarnMsgAim.SetOnEventMsgData(const Value: EventMsg);
begin
  FOnEventMsgData := Value;
end;

procedure TfrmWarnMsgAim.ShowCurrentStatus;
//var
//  i, nCnt : Integer;
begin


//  progbStatus.Maximum := lstStatus.Items.Count;
//  nCnt := 0;
//  for i := 0 to Pred(lstStatus.Items.Count) do begin
//    if lstStatus.Items[i].Checked then Inc(nCnt);
//  end;
//
//  progbStatus.Position  := nCnt;
//
//  lstStatus.Footer.Caption := 'Finished tasks : ' + '<font size="10" color="clBlack">'+intToStr(nCnt)+'</font>';
end;

procedure TfrmWarnMsgAim.ShowSeqStatus(nTotal, nStep: Integer; sMsg : string);
begin
  progDownloadStatus.Max := nTotal;
  progDownloadStatus.Min := 0;
  progDownloadStatus.Position := nStep;
  pnlDownloadStatus.Caption := sMsg;
  if nTotal = nStep then begin
    tmrUpdate.Enabled := False;
  end;

end;

procedure TfrmWarnMsgAim.ShowSubExe;
begin

end;

procedure TfrmWarnMsgAim.Timer1Timer(Sender: TObject);
var
  sDebug : string;
begin
  if fHandle <> self.Handle then begin
//    sDebug := format('[INSPECTOR] TfrmWarnMsgAim.Timer1Timer - fHandle(%d), fHandle(%d)',[fHandle, self.Handle]);
//    CodeSite.SendMsg(csmRed,sDebug);
    fHandle := self.Handle;
    fCnt    := 0;
  end;
  if fCnt > 100 then begin
    fCnt := 0;
//    sDebug := format('[INSPECTOR] TfrmWarnMsgAim.Timer1Timer - Count check :  fHandle(%d)',[self.Handle]);
//    CodeSite.SendMsg(csmRed,sDebug);
  end;
  Inc(fCnt);
end;

procedure TfrmWarnMsgAim.tmrUpdateTimer(Sender: TObject);
begin
  pnlStatus.Color       := clBtnFace;
  pnlStatus.Font.Color  := clWindowText;

  pnlStatus.Caption := pnlStatus.Caption + '.';
  if Length(pnlStatus.Caption) > 11 then pnlStatus.Caption := 'Update';

end;

procedure TfrmWarnMsgAim.WMCopyData(var Msg: TMessage);
var
  nType, nMode, nParam, nParam2 : Integer;
  nTotal, nStep : Integer;
  sMsg, sDebug : string;
begin
  nType := PGuiAimfComm(PCopyDataStruct(Msg.LParam)^.lpData)^.MsgType;

  case nType of
    DefAimf.MSG_TYPE_AIMF : begin
      nMode := PGuiAimfComm(PCopyDataStruct(Msg.LParam)^.lpData)^.Mode;
      nParam := PGuiAimfComm(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;
      sMsg   := PGuiAimfComm(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg;

//      sDebug := format('[INSP] RX - TfrmWarnMsgAim.WMCopyData - mode(%d), param(%d), sMsg(%s)',[nMode, nParam, sMsg]);
//      CodeSite.SendMsg(csmBlue,sDebug);

      case nMode of
        defAimf.MSG_MODE_UPDATE_SEQ_STEP : begin
          nTotal := PGuiAimfComm(PCopyDataStruct(Msg.LParam)^.lpData)^.Param;
          nStep  := PGuiAimfComm(PCopyDataStruct(Msg.LParam)^.lpData)^.Param2;
          ShowSeqStatus(nTotal,nStep,sMsg);
        end;
        defAimf.MSG_MODE_UPDATE_RESULT : begin
          tmrUpdate.Enabled := False;
          case nParam of
            0 : begin
              pnlStatus.Color       := clBlue;
              pnlStatus.Font.Color  := clWhite;
              pnlStatus.Caption := 'The software update completed.';
            end
            else begin
              pnlStatus.Color       := clRed;
              pnlStatus.Font.Color  := clWhite;
              pnlStatus.Caption     := 'Auto Install Updates Failed !';
            end;
          end;
          // Final Return Result.
          FnDownloadRet := PGuiAimfComm(PCopyDataStruct(Msg.LParam)^.lpData)^.Param2;
          FsAutoLogIn   := Trim(PGuiAimfComm(PCopyDataStruct(Msg.LParam)^.lpData)^.Msg);
          btnExit.Visible := True;
        end;
        DefAimf.MSG_MODE_UPDATE_EAAR_RESULT : begin

          case nParam of
            2 : begin   // RX Number - Ready 0, Tx : 1, Rx :2, No Res : 3
              pnlEaarRet.Color       := $00FF5555;//clBlue;
              pnlEaarRet.Font.Color  := clWhite;
              pnlEaarRet.Caption := 'EAAR_R OK.';
            end
            else begin
              pnlEaarRet.Color       := clRed;
              pnlEaarRet.Font.Color  := clWhite;
              pnlEaarRet.Caption     := 'EAAR_R Time out error !';
            end;
          end;
        end;
        defAimf.MSG_MODE_UPDATE_SEQ_START : begin
          case nParam of
            defAimf.MSG_PARA_SHOW_WARNING_MESSAGE : begin
              pnlStatus.Color       := clBtnFace;
              pnlStatus.Font.Color  := clWindowText;

              pnlEaarRet.Color      := clBtnFace;
              pnlEaarRet.Font.Color := clWindowText;
              pnlEaarRet.Caption    := '';

              progDownloadStatus.Position := 0;
              pnlDownloadStatus.Caption := '';

              Self.Show;
              tmrUpdate.Enabled := True;
            end;
          end;
        end
        else begin
          OnEventMsgData(nMode,nParam,sMsg);
        end;
      end;
    end;
  end;
end;

end.
