unit Alarm;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages,  System.Variants, System.Classes, System.SysUtils, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzCommon, Vcl.StdCtrls, RzCmboBx, RzLstBox, RzChkLst,
  RzTabs, Vcl.Mask, RzEdit, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, RzLabel, RzPanel, RzButton, System.UITypes,
  Vcl.ExtCtrls, DefPocb, CommonClass, AdvUtil, RzShellDialogs;

type
  TfrmAlarm = class(TForm)
    RzpnlHeader         : TRzPanel;
    RzgrpAlarmOn        : TRzGroupBox;
    lstAlarmOn          : TRzCheckList;
    RzgrpAlarmTable     : TRzGroupBox;
    gridAlarmList       : TAdvStringGrid;
    btnAlarmListRefrlesh: TRzBitBtn;
    btnAlarmListClose: TRzBitBtn;
    RzFrameController1  : TRzFrameController;
    PageControlAlarm: TRzPageControl;
    tabAlarmList: TRzTabSheet;
    tabAlarmHistory: TRzTabSheet;
    btnAlarmHistoryFileOpen: TRzBitBtn;
    edAlarmHistoryFile: TRzEdit;
    grdAlarmHistory: TAdvStringGrid;
    btnAlarmHistoryClose: TRzBitBtn;
    RzOpenDialog1: TRzOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnAlarmListCloseClick(Sender: TObject);
    procedure btnAlarmListRefreshClick(Sender: TObject);
    procedure btnAlarmHistoryCloseClick(Sender: TObject);
    procedure btnAlarmHistoryFileOpenClick(Sender: TObject);
    procedure PageControlAlarmClick(Sender: TObject);
  private
    //
  public
    m_sAlarmFile : string;
    procedure DisplayAlarmList;
    procedure DisplayAlarmHistory;
    //
  end;
var
  frmAlarm: TfrmAlarm;

implementation

uses OtlTaskControl, OtlParallel;

{$R *.dfm}

//******************************************************************************
// procedure/function: TfrmAlarm: Create/Destroy/Close
// 		- procedure TfrmAlarm.FormCreate(Sender: TObject);
//		- procedure TfrmAlarm.FormDestroy(Sender: TObject);
//******************************************************************************

procedure TfrmAlarm.FormCreate(Sender: TObject);
begin
  PageControlAlarm.ActivePage := tabAlarmList; //2022-12-07
  RzpnlHeader.Caption := '(Current) Alarm List';
  m_sAlarmFile := '';
  //
  DisplayAlarmList;
end;

procedure TfrmAlarm.FormDestroy(Sender: TObject);
var
  sTemp : string;
begin
  sTemp := Common.Path.ErrorLog + 'AlarmHistoryShowTempFile.csv';
  if FileExists(sTemp) then DeleteFile(sTemp);
  //
  frmAlarm := nil;
end;

procedure TfrmAlarm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmAlarm.btnAlarmListRefreshClick(Sender: TObject);
begin
  DisplayAlarmList;
end;

procedure TfrmAlarm.btnAlarmListCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAlarm.btnAlarmHistoryCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAlarm.btnAlarmHistoryFileOpenClick(Sender: TObject);
begin
  RzOpenDialog1.InitialDir  := Common.Path.ErrorLog;
  RzOpenDialog1.Filter      := 'txt files(ErrorLog*.txt)|ErrorLog*.txt';
  RzOpenDialog1.FilterIndex := 1;
  //
  if RzOpenDialog1.Execute then begin
    m_sAlarmFile := Trim(RzOpenDialog1.FileName);
    edAlarmHistoryFile.Text := ExtractFileName(m_sAlarmFile);
    //
    DisplayAlarmHistory;
  end;
end;

procedure TfrmAlarm.PageControlAlarmClick(Sender: TObject);
begin
  if PageControlAlarm.ActivePage = tabAlarmList then begin
    RzpnlHeader.Caption := '(Current) Alarm List';
  end
  else if PageControlAlarm.ActivePage = tabAlarmHistory then begin
    RzpnlHeader.Caption := 'Alarm History';
  end;
end;

//******************************************************************************
// procedure/function: TfrmAlarm:
// 		-
//******************************************************************************
procedure TfrmAlarm.DisplayAlarmList;
var
  alarmNo : Integer;
  nRow    : Integer;
  sTemp   : string;
begin
  nRow := 0;
  lstAlarmOn.Items.Clear;
  gridAlarmList.RowCount  := DefPocb.MAX_ALARM_NO;
  with Common do begin
    for alarmNo := 1 to DefPocb.MAX_ALARM_NO do begin
      if AlarmList[alarmNo].alarmName = '' then Continue;
      //
      Inc(nRow);
      gridAlarmList.Cells[0,nRow] := IntToStr(alarmNo);
      gridAlarmList.Cells[1,nRow] := AlarmList[alarmNo].alarmName;
      if AlarmList[alarmNo].sDioIN <> '-1' then gridAlarmList.Cells[2,nRow] := AlarmList[alarmNo].sDioIN
      else                                      gridAlarmList.Cells[2,nRow] := '-';
      case AlarmList[alarmNo].alarmClass of
        DefPocb.ALARM_CLASS_SAFETY:  gridAlarmList.Cells[3,nRow] := 'SAFETY';
        DefPocb.ALARM_CLASS_SERIOUS: gridAlarmList.Cells[3,nRow] := 'SERIOUS';
        DefPocb.ALARM_CLASS_LIGHT:   gridAlarmList.Cells[3,nRow] := 'LIGHT';
        else                         gridAlarmList.Cells[3,nRow] := '-';
      end;
      if AlarmList[alarmNo].bIsOn then begin
        gridAlarmList.Cells[4,nRow] := 'ON';
        gridAlarmList.RowColor[nRow]     := clRed;
        gridAlarmList.RowFontColor[nRow] := clYellow;
        //
        sTemp := Format('%2d ',[alarmNo]) + AlarmList[alarmNo].alarmName;
        lstAlarmOn.Sorted := False;
        lstAlarmOn.Items.Add(sTemp);
      end
      else begin
        gridAlarmList.Cells[4,nRow] := 'OFF';
        gridAlarmList.RowColor[nRow]     := clBtnFace;
        gridAlarmList.RowFontColor[nRow] := clBlack;
      end;
    end;
  end;
end;

procedure TfrmAlarm.DisplayAlarmHistory;
var
  sFilePath, sCsvFile : string;
  bIsOK : Boolean;
begin
  if m_sAlarmFile = '' then Exit;
  if not FileExists(m_sAlarmFile) then Exit;

  //
  sFilePath := ExtractFilePath(m_sAlarmFile);
  sCsvFile  := Common.Path.ErrorLog + 'AlarmHistoryShowTempFile.csv';
  bIsOK := CopyFile(PChar(m_sAlarmFile), PChar(sCsvFile), False);
  if bIsOK then begin
    grdAlarmHistory.LoadFromCSV(sCsvFile);
    grdAlarmHistory.AutoSize := True;
    //
    DeleteFile(sCsvFile);
  end;
end;

end.
