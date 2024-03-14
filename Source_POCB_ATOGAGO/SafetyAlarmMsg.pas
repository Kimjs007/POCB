unit SafetyAlarmMsg;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzButton, Vcl.StdCtrls, RzLabel, Math,
  DefPocb, DefDio, DioCtl, PngImage, CommonClass, AdvUtil, Vcl.Grids, AdvObj, BaseGrid, AdvGrid;  //2019-04-02

type
  TfrmSafetyAlarmMsg = class(TForm)
    pnlSafetyAlarmMsg: TPanel;
    btnExit: TRzBitBtn;
    lblButtom: TRzLabel;
    lblDioInTitle: TRzLabel;
    Label1: TLabel;
    btnBuzzerStop: TRzBitBtn;
    lblAlarmMsg1: TLabel;
    lblAlarmMsg2: TLabel;
    lblAlarmName: TRzLabel;
    lblDioInValue: TRzLabel;
    imgAlarmLoc: TImage;
    GrpAlarmInfo: TGroupBox;
    img_SF_ALL: TImage;
    SHP_AL: TShape;
    LB_SHP: TLabel;
    TM_ALL_VIEW: TTimer;
    GRD_AL_ALL: TAdvStringGrid;

    procedure btnExitClick(Sender: TObject);
    procedure btnBuzzerStopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure TM_ALL_VIEWTimer(Sender: TObject);
    procedure lblAlarmMsg2DblClick(Sender: TObject);
  private
    { Private declarations }
    m_alarmNo           : Integer;
    m_lDin              : UInt64;

    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    function  IsClose : Boolean;
    procedure SET_TOTAL_UI(sAlarmName: string);
  public
    { Public declarations }
    procedure SetAlarmInfo(sAlarmName: String; nDioInVal: Integer = -1; sAlarmMsg: String = ''; sAlarmMsg2: String = ''; sImageFullName: String = ''; sAlarmOnTime : String = ''); overload;
    procedure SetAlarmInfo(sAlarmName: String; sDioInVal: String = '-1';sAlarmMsg: String = ''; sAlarmMsg2: String = ''; sImageFullName: String = ''; sAlarmOnTime : String = ''); overload;
    procedure SetAlarmInfo(alarmInfo: TAlarmInfo; sImageFullName: String = ''; sAlarmOnTime: String = ''); overload;
  end;

const
  POS_SHP_X = 1;
  POS_SHP_Y = 2;
  POS_SHP_Width = 3;
  POS_SHP_Height = 4;
var
{$IFDEF OLD}
  frmSafetyAlarmMsg: TfrmSafetyAlarmMsg;
{$ELSE}
  frmSafetyAlarmMsg: array[0..DefPocb.MAX_ALARM_NO] of TfrmSafetyAlarmMsg;  //2019-04-02
{$ENDIF}

implementation

{$R *.dfm}

procedure TfrmSafetyAlarmMsg.SET_TOTAL_UI(sAlarmName: string);
var
  AL_CSV_PATH: string;
  Loc: TPoint;
  Fp: TFindParams;
begin
  AL_CSV_PATH := Common.Path.Ini + '\systemimage\AL_TOTOAL_VIEW.CSV';
  case FileExists(AL_CSV_PATH) of
    True:
      begin
        GRD_AL_ALL.LoadFromCSV(AL_CSV_PATH);

        Loc := Point(0, 0);
        Fp := [fnMatchFull, fnMatchFull];
        Loc := GRD_AL_ALL.Find(Loc, sAlarmName, Fp);

        if Loc.Y > 0 then begin
          SHP_AL.Left := GRD_AL_ALL.Ints[POS_SHP_X, Loc.Y];
          SHP_AL.Top := GRD_AL_ALL.Ints[POS_SHP_Y, Loc.Y];
          SHP_AL.Width := GRD_AL_ALL.Ints[POS_SHP_Width, Loc.Y];
          SHP_AL.Height := GRD_AL_ALL.Ints[POS_SHP_Height, Loc.Y];
          LB_SHP.Left := (SHP_AL.Left + Floor(SHP_AL.Width / 2) - Floor(LB_SHP.Width / 2));
          LB_SHP.Top := SHP_AL.Top + SHP_AL.Height + 10;
          LB_SHP.Caption := 'DI ' + lblDioInValue.Caption;
          Self.Height := 1004;
          TM_ALL_VIEW.Interval := 1;
          TM_ALL_VIEW.Enabled := True;
        end
        else begin
          Self.Height := 700;
        end;
      end;
    False:
      begin

      end;
  end;
end;

procedure TfrmSafetyAlarmMsg.TM_ALL_VIEWTimer(Sender: TObject);
begin
  TM_ALL_VIEW.Enabled := False;
  TM_ALL_VIEW.Interval := 1000;

  case SHP_AL.Brush.Style of
    bsSolid:
      SHP_AL.Brush.Style := bsBDiagonal;
    bsBDiagonal:
      SHP_AL.Brush.Style := bsSolid;
  end;
  TM_ALL_VIEW.Enabled := True;
end;

procedure TfrmSafetyAlarmMsg.SetAlarmInfo(sAlarmName: String; sDioInVal: String = '-1'; sAlarmMsg: String = ''; sAlarmMsg2: string = ''; sImageFullName: String = ''; sAlarmOnTime: String = '');   //2019-04-02
var
  Image : TBitmap;
begin
  lblAlarmName.Caption  := sAlarmName;
  if sDioInVal <> '-1' then lblDioInValue.Caption := sDioInVal
  else                      lblDioInValue.Caption := '';
  lblAlarmMsg1.Caption  := sAlarmMsg;
  lblAlarmMsg2.Caption  := sAlarmMsg2;
  if sImageFullName <> '' then begin
    if FileExists(sImageFullName) then begin
        Image := TBitmap.Create(); //2019-04-26
        try
          Image.LoadFromFile(sImageFullName);
          imgAlarmLoc.Picture.Assign(Image);
          imgAlarmLoc.Stretch := True;
          imgAlarmLoc.Visible := True;
        finally
          Image.Free;
        end;
    end;
  end;
  lblButtom.Caption := sAlarmOnTime;  //' ' + FormatDateTime('YYYY-MM-DD hh:mm:ss.zzz',Now);

   SET_TOTAL_UI(sAlarmName);
end;

procedure TfrmSafetyAlarmMsg.SetAlarmInfo(sAlarmName : String;
                                        nDioInVal  : Integer = -1;
                                        sAlarmMsg  : String = '';
                                        sAlarmMsg2 : string = '';
                                        sImageFullName : String = '';
                                        sAlarmOnTime : String = '');   //2019-04-02
var
  sDioInStr : string;
begin
  if nDioInVal >= 0 then sDioInStr := Format('%d',[nDioInVal])
  else                   sDioInStr := '';
  //
  SetAlarmInfo(sAlarmName, sDioInStr, sAlarmMsg, sAlarmMsg2, sImageFullName, sAlarmOnTime);
end;

procedure TfrmSafetyAlarmMsg.SetAlarmInfo(alarmInfo : TAlarmInfo;
                                          sImageFullName : String = '';
                                          sAlarmOnTime : String = '');
begin
  m_alarmNo := alarmInfo.AlarmNo;

  SetAlarmInfo(alarmInfo.AlarmName,alarmInfo.sDioIN,
          alarmInfo.AlarmMsg, alarmInfo.AlarmMsg2, sImageFullName, sAlarmOnTime);
end;

procedure TfrmSafetyAlarmMsg.FormDestroy(Sender: TObject);
begin
//Self := nil;
end;

procedure TfrmSafetyAlarmMsg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//Action := caFree;  //2019-04-04 TBD?
end;

procedure TfrmSafetyAlarmMsg.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := IsClose;
end;

procedure TfrmSafetyAlarmMsg.FormCreate(Sender: TObject);
begin
  m_alarmNo := -1;
  m_lDin    := 0;
  {$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
  m_lDin := m_lDin or DefDio.MASK_IN_EMS;
  {$ELSE} //A2CHv3|A2CHv4
  m_lDin := m_lDin or DefDio.MASK_IN_EMO_ALL;
  {$ENDIF}
  {$IFNDEF SIMULATOR_DIO}
  m_lDin := m_lDin or DefDio.MASK_IN_MC1;
  m_lDin := m_lDin or DefDio.MASK_IN_MC2;
  {$ENDIF}
  {
  m_lDin := m_lDin or (UInt64(1) shl DefDio.IN_DOOR_LEFT);
  m_lDin := m_lDin or (UInt64(1) shl DefDio.IN_DOOR_RIGHT);
  m_lDin := m_lDin or (UInt64(1) shl DefDio.IN_DOOR_UNDER_LEFT1);
  m_lDin := m_lDin or (UInt64(1) shl DefDio.IN_DOOR_UNDER_LEFT2);
  m_lDin := m_lDin or (UInt64(1) shl DefDio.IN_DOOR_UNDER_RIGHT1);
  m_lDin := m_lDin or (UInt64(1) shl DefDio.IN_DOOR_UNDER_RIGHT2);
  }
end;

procedure TfrmSafetyAlarmMsg.btnBuzzerStopClick(Sender: TObject);
begin
  if (DongaDio = nil) then Exit;
  DongaDio.SetBuzzer(False);
end;

procedure TfrmSafetyAlarmMsg.btnExitClick(Sender: TObject);
var
  bIsDoNotCloseIfAlarmOn : Boolean;
begin
  if not IsClose then Exit;
  //
  bIsDoNotCloseIfAlarmOn := False;
  {$IFDEF SUPPORT_1CG2PANEL}
  if m_alarmNo in [ALARM_DIO_CAMZONE_PARTITION_NOT_DOWN,
                   ALARM_DIO_CAMZONE_INNER_DOOR_NOT_CLOSE,
                   ALARM_DIO_LOADZONE_PARTITION_NOT_DETECTED,
                   ALARM_DIO_ASSY_JIG_DETECTED,
                   ALARM_DIO_CAMZONE_PARTITION_NOT_UP,
                   ALARM_DIO_CAMZONE_INNER_DOOR_NOT_OPEN,
                   ALARM_DIO_LOADZONE_PARTITION_DETECTED]
                 //ALARM_CH1_ROBOT_HOME_COORD_MISMATCH,
                 //ALARM_CH1_ROBOT_MODEL_COORD_MISMATCH,
                 //ALARM_CH1_ROBOT_STANDBY_COORD_MISMATCH,
                 //ALARM_CH2_ROBOT_HOME_COORD_MISMATCH,
                 //ALARM_CH2_ROBOT_MODEL_COORD_MISMATCH,
                 //ALARM_CH2_ROBOT_STANDBY_COORD_MISMATCH]
  then bIsDoNotCloseIfAlarmOn := True;
  {$ELSE}
    //TBD:A2CHv4?
  {$ENDIF}
  if (bIsDoNotCloseIfAlarmOn and Common.AlarmList[m_alarmNo].bIsOn) then Exit;
  //
  DongaDio.SetBuzzer(False); //2019-04-16 (Close½Ã Buzeer Off)
  //
  Close;
end;

function  TfrmSafetyAlarmMsg.IsClose : Boolean;
var
  arrStr : TArray<string>;
  nDioIN : Integer;
begin
  if m_alarmNo = -1 then Exit(True);

  arrStr := Trim(Common.AlarmList[m_alarmNo].sDioIN).Split([',']);
  if Length(arrStr) <> 1 then begin
    Exit(True);
  end;

  nDioIN := StrToInt(arrStr[0]);
  if 0 <> (m_lDin and (UInt64(1) shl nDioIN)) then
    Exit(not Common.AlarmList[m_alarmNo].bIsOn);

  Result := True;
end;

procedure TfrmSafetyAlarmMsg.lblAlarmMsg2DblClick(Sender: TObject);
begin
  if GRD_AL_ALL.Visible then
    GRD_AL_ALL.Visible := False
  else
    GRD_AL_ALL.Visible := True;
end;

end.
