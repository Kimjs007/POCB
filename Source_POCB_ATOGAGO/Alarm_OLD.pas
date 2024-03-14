unit Alarm;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages,  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,System.SysUtils, RzCommon, Vcl.StdCtrls, RzCmboBx, RzLstBox, RzChkLst,
  RzTabs, Vcl.Mask, RzEdit, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, RzLabel, RzPanel, RzButton, System.UITypes,
  Vcl.ExtCtrls, DefPocb, CommonClass, AdvUtil;

type
  TfrmAlarm = class(TForm)
    RzpnlHeader         : TRzPanel;
    RzpnlAlarm          : TRzPanel;
    RzgrpAlarmOn        : TRzGroupBox;
    lstAlarmOn          : TRzCheckList;
    btnAlarmSelect      : TRzBitBtn;
    btnAlarmClear       : TRzBitBtn;
    RzgrpAlarmTable     : TRzGroupBox;
    gridAlarmList       : TAdvStringGrid;
    btnReflesh          : TRzBitBtn;
    btnClose            : TRzBitBtn;
    RzFrameController1  : TRzFrameController;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAlarmSelectClick(Sender: TObject);
    procedure btnAlarmClearClick(Sender: TObject);
    procedure btnRefleshClick(Sender: TObject);
  private
    //
  public
    procedure DisplayAlarmTable;
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
  DisplayAlarmTable;
end;

procedure TfrmAlarm.FormDestroy(Sender: TObject);
begin
  frmAlarm := nil;
end;

procedure TfrmAlarm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmAlarm.btnAlarmSelectClick(Sender: TObject);  //TBD:ALARM?
begin
  Common.MLog(DefPocb.SYS_LOG,'<ALARM> Alarm Select Click ...TBD');
  lstAlarmOn.CheckAll;
end;

procedure TfrmAlarm.btnAlarmClearClick(Sender: TObject);  //TBD:ALARM?
begin
  Common.MLog(DefPocb.SYS_LOG,'<ALARM> Alarm Select Click ...TBD');
end;

procedure TfrmAlarm.btnRefleshClick(Sender: TObject);
begin
  DisplayAlarmTable;
end;

procedure TfrmAlarm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//******************************************************************************
// procedure/function: TfrmAlarm:
// 		-
//******************************************************************************
procedure TfrmAlarm.DisplayAlarmTable;
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

end.
