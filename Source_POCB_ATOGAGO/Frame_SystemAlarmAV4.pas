unit Frame_SystemAlarmAV4;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, CommonClass,
  DefPocb, CustomFrame;

type
  TFrame_SystemArmAV = class(TCustomFrame)
    GrpSystemAlarms: TGroupBox;
    pnlAlarmCh1Door1: TPanel;
    pnlAlarmMC1: TPanel;
    pnlAlarmMC2: TPanel;
    pnlAlarmCh1Robot: TPanel;
    pnlAlarmCylinderRegulator: TPanel;
    pnlAlarmCh1Yaxis: TPanel;
    pnlAlarmCh2Yaxis: TPanel;
    pnlAlarmCh2Robot: TPanel;
    pnlAlarmCh1Door2: TPanel;
    pnlAlarmCh2Door2: TPanel;
    pnlAlarmTemperature: TPanel;
    pnlAlarmPowerHigh: TPanel;
    pnlAlarmCh2Door1: TPanel;
    pnlAlarmVacuumRegulator: TPanel;
    pnlAlarmLeftFanIn: TPanel;
    pnlAlarmLeftFanOut: TPanel;
    pnlAlarmRightFanIn: TPanel;
    pnlAlarmRightFanOut: TPanel;
    pnlAlarmCh1NotAutoMode: TPanel;
    pnlAlarmCh2NotAutoMode: TPanel;
    pnlAlarmCh1Door1Lock: TPanel;
    pnlAlarmCh1Door2Lock: TPanel;
    pnlAlarmCh2Door1Lock: TPanel;
    pnlAlarmCh2Door2Lock: TPanel;
    pnlAlarmCh1YAxisMC: TPanel;
    pnlAlarmCh2YAxisMC: TPanel;
{$IFDEF SUPPORT_1CG2PANEL}
    pnlAlarmShutterGuide: TPanel;
    pnlAlarmAssyJig: TPanel;
    pnlAlarmCamZonePartition: TPanel;
    pnlAlarmCamZoneInnerDoor: TPanel;
    pnlAlarmLoadZonePartition: TPanel;		
{$ENDIF}
{$IFDEF HAS_DIO_FAN_INOUT_PC}		
    pnlAlarmMainPcFanIn: TPanel;
    pnlAlarmMainPcFanOut: TPanel;
    pnlAlarmCamPcFanIn: TPanel;
    pnlAlarmCamPcFanOut: TPanel;
{$ENDIF}		
  private
    { Private declarations }
  public
    procedure ReconfigGui; override;
    procedure UpdateGui(var sMsg : string); override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrame_SystemArmAV.ReconfigGui; //2022-07-15 A2CHv4_#3
var
  nHeight : Integer;
begin
{$IFDEF HAS_DIO_FAN_INOUT_PC}
  if Common.SystemInfo.HasDioFanInOutPC then begin
    pnlAlarmMainPcFanIn.Visible  := True;
    pnlAlarmMainPcFanOut.Visible := True;
    pnlAlarmCamPcFanIn.Visible   := True;
    pnlAlarmCamPcFanOut.Visible  := True;
    //
    nHeight := pnlAlarmMainPcFanIn.Height;
  end
  else begin
    pnlAlarmMainPcFanIn.Visible  := False;
    pnlAlarmMainPcFanOut.Visible := False;
    pnlAlarmCamPcFanIn.Visible   := False;
    pnlAlarmCamPcFanOut.Visible  := False;
    //
    nHeight := pnlAlarmPowerHigh.Height;
  end;
  //
  pnlAlarmLeftFanIn.Height    := nHeight;
  pnlAlarmLeftFanOut.Height   := nHeight;
  pnlAlarmRightFanIn.Height   := nHeight;
  pnlAlarmRightFanOut.Height  := nHeight;
{$ENDIF}
  //
  pnlAlarmVacuumRegulator.Visible := Common.SystemInfo.HasDioVacuum; //2023-04-10 HasDioVacuum

  //
//{$IFDEF HAS_DIO_FAN_INOUT_PC}
  if Common.SystemInfo.HasDioInDoorLock then begin //2023-12-07 HasDioInDoorLock
    pnlAlarmCh1Door1Lock.Visible := True;
    pnlAlarmCh1Door2Lock.Visible := True;
    pnlAlarmCh2Door1Lock.Visible := True;
    pnlAlarmCh2Door2Lock.Visible := True;
  end
  else begin
    pnlAlarmCh1Door1Lock.Visible := False;
    pnlAlarmCh1Door2Lock.Visible := False;
    pnlAlarmCh2Door1Lock.Visible := False;
    pnlAlarmCh2Door2Lock.Visible := False;
    //
    pnlAlarmCh1Door1.Top    := pnlAlarmCh1Robot.Top;
    pnlAlarmCh1Door1.Height := pnlAlarmCh1Robot.Height;
    pnlAlarmCh1Door2.Top    := pnlAlarmCh1Yaxis.Top;
    pnlAlarmCh1Door2.Height := pnlAlarmCh1Yaxis.Height;
    //
    pnlAlarmCh2Door1.Top    := pnlAlarmCh2Robot.Top;
    pnlAlarmCh2Door1.Height := pnlAlarmCh2Robot.Height;
    pnlAlarmCh2Door2.Top    := pnlAlarmCh2Yaxis.Top;
    pnlAlarmCh2Door2.Height := pnlAlarmCh2Yaxis.Height;
  end;
//{$ENDIF}

  //
//{$IFDEF HAS_DIO_Y_AXIS_MC}
  if Common.SystemInfo.HasDioYAxisMC then begin //2023-12-07 HasDioYAxisMC
    pnlAlarmCh1YaxisMC.Visible := True;
    pnlAlarmCh2YaxisMC.Visible := True;
  end
  else begin
    pnlAlarmCh1YaxisMC.Visible := False;
    pnlAlarmCh2YaxisMC.Visible := False;
    //
    pnlAlarmCh1Yaxis.Width  := pnlAlarmCh1Robot.Width;
    pnlAlarmCh2Yaxis.Left   := pnlAlarmCh2Robot.Left;
    pnlAlarmCh2Yaxis.Width  := pnlAlarmCh2Robot.Width;
  end;
//{$ENDIF}
end;

procedure TFrame_SystemArmAV.UpdateGui(var sMsg: string);
var
  nAlarmOnColor, nAlarmOnFontColor, nAlarmOffColor, nAlarmOffFontColor : TColor;
begin
  nAlarmOnColor       := clRed;       nAlarmOnFontColor      := clYellow;
  nAlarmOffColor      := clBtnFace;   nAlarmOffFontColor     := clSilver;

  if sMsg <> '' then sMsg := sMsg + #13 + #10;

  if Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_NOT_AUTOMODE].bIsOn then begin
    pnlAlarmCh1NotAutoMode.Color := nAlarmOnColor;  pnlAlarmCh1NotAutoMode.Font.Color := nAlarmOnFontColor;
    sMsg := {sOpMsg + #13 + #10 +} Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_NOT_AUTOMODE].AlarmMsg;
  end
  else begin
    pnlAlarmCh1NotAutoMode.Color := nAlarmOffColor; pnlAlarmCh1NotAutoMode.Font.Color := nAlarmOffFontColor;
  end;

  if Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_NOT_AUTOMODE].bIsOn then begin
    pnlAlarmCh2NotAutoMode.Color := nAlarmOnColor;  pnlAlarmCh2NotAutoMode.Font.Color := nAlarmOnFontColor;
    sMsg := {sOpMsg + #13 + #10 +} Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_NOT_AUTOMODE].AlarmMsg;
  end
  else begin
    pnlAlarmCh2NotAutoMode.Color := nAlarmOffColor; pnlAlarmCh2NotAutoMode.Font.Color := nAlarmOffFontColor;
  end;

  if Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_DOOR1_OPEN].bIsOn then begin
    pnlAlarmCh1Door1.Color := nAlarmOnColor;  pnlAlarmCh1Door1.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_DOOR1_OPEN].AlarmMsg;
  end
  else begin
    pnlAlarmCh1Door1.Color := nAlarmOffColor; pnlAlarmCh1Door1.Font.Color := nAlarmOffFontColor;
  end;
  if Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_DOOR2_OPEN].bIsOn then begin
    pnlAlarmCh1Door2.Color := nAlarmOnColor;  pnlAlarmCh1Door2.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_DOOR2_OPEN].AlarmMsg;
  end
  else begin
    pnlAlarmCh1Door2.Color := nAlarmOffColor; pnlAlarmCh1Door2.Font.Color := nAlarmOffFontColor;
  end;

  if Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_DOOR1_OPEN].bIsOn then begin
    pnlAlarmCh2Door1.Color := nAlarmOnColor;  pnlAlarmCh2Door1.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_DOOR1_OPEN].AlarmMsg;
  end
  else begin
    pnlAlarmCh2Door1.Color := nAlarmOffColor; pnlAlarmCh2Door1.Font.Color := nAlarmOffFontColor;
  end;
  if Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_DOOR2_OPEN].bIsOn then begin
    pnlAlarmCh2Door2.Color := nAlarmOnColor;  pnlAlarmCh2Door2.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_DOOR2_OPEN].AlarmMsg;
  end
  else begin
    pnlAlarmCh2Door2.Color := nAlarmOffColor; pnlAlarmCh2Door2.Font.Color := nAlarmOffFontColor;
  end;
  //
{$IFDEF HAS_DIO_IN_DOOR_LOCK}
  if Common.SystemInfo.HasDioInDoorLock then begin
    if Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_DOOR1_LOCK].bIsOn then begin
      pnlAlarmCh1Door1Lock.Color := nAlarmOnColor;  pnlAlarmCh1Door1Lock.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_DOOR1_LOCK].AlarmMsg;
    end
    else begin
      pnlAlarmCh1Door1Lock.Color := nAlarmOffColor; pnlAlarmCh1Door1Lock.Font.Color := nAlarmOffFontColor;
    end;
    if Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_DOOR2_LOCK].bIsOn then begin
      pnlAlarmCh1Door2Lock.Color := nAlarmOnColor;  pnlAlarmCh1Door2Lock.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_DOOR2_LOCK].AlarmMsg;
    end
    else begin
      pnlAlarmCh1Door2Lock.Color := nAlarmOffColor; pnlAlarmCh1Door2Lock.Font.Color := nAlarmOffFontColor;
    end;

    if Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_DOOR1_LOCK].bIsOn then begin
      pnlAlarmCh2Door1Lock.Color := nAlarmOnColor;  pnlAlarmCh2Door1Lock.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_DOOR1_LOCK].AlarmMsg;
    end
    else begin
      pnlAlarmCh2Door1Lock.Color := nAlarmOffColor; pnlAlarmCh2Door1Lock.Font.Color := nAlarmOffFontColor;
    end;
    if Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_DOOR2_LOCK].bIsOn then begin
      pnlAlarmCh2Door2Lock.Color := nAlarmOnColor;  pnlAlarmCh2Door2Lock.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_DOOR2_LOCK].AlarmMsg;
    end
    else begin
      pnlAlarmCh2Door2Lock.Color := nAlarmOffColor; pnlAlarmCh2Door2Lock.Font.Color := nAlarmOffFontColor;
    end;
  end;
{$ENDIF}
  //
  if Common.AlarmList[DefPocb.ALARM_DIO_LEFT_FAN_IN].bIsOn then begin
    pnlAlarmLeftFanIn.Color := nAlarmOnColor;  pnlAlarmLeftFanIn.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_LEFT_FAN_IN].AlarmMsg;
  end
  else begin
    pnlAlarmLeftFanIn.Color := nAlarmOffColor; pnlAlarmLeftFanIn.Font.Color := nAlarmOffFontColor;
  end;

  if Common.AlarmList[DefPocb.ALARM_DIO_LEFT_FAN_OUT].bIsOn then begin
    pnlAlarmLeftFanOut.Color := nAlarmOnColor;  pnlAlarmLeftFanOut.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_LEFT_FAN_OUT].AlarmMsg;
  end
  else begin
    pnlAlarmLeftFanOut.Color := nAlarmOffColor; pnlAlarmLeftFanOut.Font.Color := nAlarmOffFontColor;
  end;

  if Common.AlarmList[DefPocb.ALARM_DIO_RIGHT_FAN_IN].bIsOn then begin
    pnlAlarmRightFanIn.Color := nAlarmOnColor;  pnlAlarmRightFanIn.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_RIGHT_FAN_IN].AlarmMsg;
  end
  else begin
    pnlAlarmRightFanIn.Color := nAlarmOffColor; pnlAlarmRightFanIn.Font.Color := nAlarmOffFontColor;
  end;

  if Common.AlarmList[DefPocb.ALARM_DIO_RIGHT_FAN_OUT].bIsOn then begin
    pnlAlarmRightFanOut.Color := nAlarmOnColor;  pnlAlarmRightFanOut.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_RIGHT_FAN_OUT].AlarmMsg;
  end
  else begin
    pnlAlarmRightFanOut.Color := nAlarmOffColor; pnlAlarmRightFanOut.Font.Color := nAlarmOffFontColor;
  end;

  //
{$IFDEF HAS_DIO_FAN_INOUT_PC}
  if Common.SystemInfo.HasDioFanInOutPC then begin //2022-07-15 A2CHv4_#3
    if Common.AlarmList[DefPocb.ALARM_DIO_MAINPC_FAN_IN].bIsOn then begin
      pnlAlarmMainPcFanIn.Color := nAlarmOnColor;  pnlAlarmMainPcFanIn.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_MAINPC_FAN_IN].AlarmMsg;
    end
    else begin
      pnlAlarmMainPcFanIn.Color := nAlarmOffColor; pnlAlarmMainPcFanIn.Font.Color := nAlarmOffFontColor;
    end;

    if Common.AlarmList[DefPocb.ALARM_DIO_MAINPC_FAN_OUT].bIsOn then begin
      pnlAlarmMainPcFanOut.Color := nAlarmOnColor;  pnlAlarmMainPcFanOut.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_MAINPC_FAN_OUT].AlarmMsg;
    end
    else begin
      pnlAlarmMainPcFanOut.Color := nAlarmOffColor; pnlAlarmMainPcFanOut.Font.Color := nAlarmOffFontColor;
    end;

    if Common.AlarmList[DefPocb.ALARM_DIO_CAMPC_FAN_IN].bIsOn then begin
      pnlAlarmCamPcFanIn.Color := nAlarmOnColor;  pnlAlarmCamPcFanIn.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_CAMPC_FAN_IN].AlarmMsg;
    end
    else begin
      pnlAlarmCamPcFanIn.Color := nAlarmOffColor; pnlAlarmCamPcFanIn.Font.Color := nAlarmOffFontColor;
    end;

    if Common.AlarmList[DefPocb.ALARM_DIO_CAMPC_FAN_OUT].bIsOn then begin
      pnlAlarmCamPcFanOut.Color := nAlarmOnColor;  pnlAlarmCamPcFanOut.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_CAMPC_FAN_OUT].AlarmMsg;
    end
    else begin
      pnlAlarmCamPcFanOut.Color := nAlarmOffColor; pnlAlarmCamPcFanOut.Font.Color := nAlarmOffFontColor;
    end;
  end;
{$ENDIF}

  //
  if Common.AlarmList[DefPocb.ALARM_DIO_TEMPERATURE].bIsOn then begin
    pnlAlarmTemperature.Color := nAlarmOnColor;  pnlAlarmTemperature.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_TEMPERATURE].AlarmMsg;
  end
  else begin
    pnlAlarmTemperature.Color := nAlarmOffColor; pnlAlarmTemperature.Font.Color := nAlarmOffFontColor;
  end;

  if Common.AlarmList[DefPocb.ALARM_DIO_POWER_HIGH].bIsOn then begin
    pnlAlarmPowerHigh.Color := nAlarmOnColor;  pnlAlarmPowerHigh.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_POWER_HIGH].AlarmMsg;
  end
  else begin
    pnlAlarmPowerHigh.Color := nAlarmOffColor; pnlAlarmPowerHigh.Font.Color := nAlarmOffFontColor;
  end;

  if Common.AlarmList[DefPocb.ALARM_DIO_CYLINDER_REGULATOR].bIsOn then begin
    pnlAlarmCylinderRegulator.Color := nAlarmOnColor;  pnlAlarmCylinderRegulator.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_CYLINDER_REGULATOR].AlarmMsg;
  end
  else begin
    pnlAlarmCylinderRegulator.Color := nAlarmOffColor; pnlAlarmCylinderRegulator.Font.Color := nAlarmOffFontColor;
  end;

  if Common.AlarmList[DefPocb.ALARM_DIO_VACUUM_REGULATOR].bIsOn then begin
    pnlAlarmVacuumRegulator.Color := nAlarmOnColor;  pnlAlarmVacuumRegulator.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_VACUUM_REGULATOR].AlarmMsg;
  end
  else begin
    pnlAlarmVacuumRegulator.Color := nAlarmOffColor; pnlAlarmVacuumRegulator.Font.Color := nAlarmOffFontColor;
  end;

  if Common.AlarmList[DefPocb.ALARM_DIO_MC1].bIsOn then begin
    pnlAlarmMC1.Color := nAlarmOnColor;  pnlAlarmMC1.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_MC1].AlarmMsg;
  end
  else begin
    pnlAlarmMC1.Color := nAlarmOffColor; pnlAlarmMC1.Font.Color := nAlarmOffFontColor;
  end;

  if Common.AlarmList[DefPocb.ALARM_DIO_MC2].bIsOn then begin
    pnlAlarmMC2.Color := nAlarmOnColor;  pnlAlarmMC2.Font.Color := nAlarmOnFontColor;
    sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_MC2].AlarmMsg;
  end
  else begin
    pnlAlarmMC2.Color := nAlarmOffColor; pnlAlarmMC2.Font.Color := nAlarmOffFontColor;
  end;
  //
{$IFDEF HAS_DIO_Y_AXIS_MC}
  if Common.SystemInfo.HasDioYAxisMC then begin
    if Common.AlarmList[DefPocb.ALARM_DIO_Y_AXIS_MC_CH1].bIsOn then begin
      pnlAlarmCh1YAxisMC.Color := nAlarmOnColor;  pnlAlarmCh1YAxisMC.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_Y_AXIS_MC_CH1].AlarmMsg;
    end
    else begin
      pnlAlarmCh1YAxisMC.Color := nAlarmOffColor; pnlAlarmCh1YAxisMC.Font.Color := nAlarmOffFontColor;
    end;

    if Common.AlarmList[DefPocb.ALARM_DIO_Y_AXIS_MC_CH2].bIsOn then begin
      pnlAlarmCh2YAxisMC.Color := nAlarmOnColor;  pnlAlarmCh2YAxisMC.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_Y_AXIS_MC_CH2].AlarmMsg;
    end
    else begin
      pnlAlarmCh2YAxisMC.Color := nAlarmOffColor; pnlAlarmCh2YAxisMC.Font.Color := nAlarmOffFontColor;
    end;
  end;
{$ENDIF}

  //---------------------------------------------------------------------
  if Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_DISCONNECTED].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_MOTION_Y_SIG_ALARM_ON].bIsOn then begin
    pnlAlarmCh1Yaxis.Color := nAlarmOnColor;  pnlAlarmCh1Yaxis.Font.Color := nAlarmOnFontColor;
  end
  else begin
    pnlAlarmCh1Yaxis.Color := nAlarmOffColor; pnlAlarmCh1Yaxis.Font.Color := nAlarmOffFontColor;
  end;
  if Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_DISCONNECTED].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_MOTION_Y_SIG_ALARM_ON].bIsOn then begin
    pnlAlarmCh2Yaxis.Color := nAlarmOnColor;  pnlAlarmCh2Yaxis.Font.Color := nAlarmOnFontColor;
  end
  else begin
    pnlAlarmCh2Yaxis.Color := nAlarmOffColor; pnlAlarmCh2Yaxis.Font.Color := nAlarmOffFontColor;
  end;

	{$IFDEF HAS_ROBOT_CAM_Z}
  if Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_MODBUS_DISCONNECTED].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_COMMAND_DISCONNECTED].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_FATAL_ERROR].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_PROJECT_NOT_RUNNING].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_PROJECT_EDITING].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_PROJECT_PAUSE].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_GET_CONTROL].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_ESTOP].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_CURR_COORD_NG].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_NOT_AUTOMODE].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_CANNOT_MOVE].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_HOME_COORD_MISMATCH].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_MODEL_COORD_MISMATCH].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH1_ROBOT_STANDBY_COORD_MISMATCH].bIsOn
  then begin
    pnlAlarmCh1Robot.Color := nAlarmOnColor;  pnlAlarmCh1Robot.Font.Color := nAlarmOnFontColor;
  end
  else begin
    pnlAlarmCh1Robot.Color := nAlarmOffColor; pnlAlarmCh1Robot.Font.Color := nAlarmOffFontColor;
  end;
  if Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_MODBUS_DISCONNECTED].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_COMMAND_DISCONNECTED].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_FATAL_ERROR].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_PROJECT_NOT_RUNNING].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_PROJECT_EDITING].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_PROJECT_PAUSE].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_GET_CONTROL].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_ESTOP].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_CURR_COORD_NG].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_NOT_AUTOMODE].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_CANNOT_MOVE].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_HOME_COORD_MISMATCH].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_MODEL_COORD_MISMATCH].bIsOn or
     Common.AlarmList[DefPocb.ALARM_CH2_ROBOT_STANDBY_COORD_MISMATCH].bIsOn
  then begin
    pnlAlarmCh2Robot.Color := nAlarmOnColor;  pnlAlarmCh2Robot.Font.Color := nAlarmOnFontColor;
  end
  else begin
    pnlAlarmCh2Robot.Color := nAlarmOffColor; pnlAlarmCh2Robot.Font.Color := nAlarmOffFontColor;
  end;
	{$ENDIF}

  {$IFDEF SUPPORT_1CG2PANEL}
  if (not Common.SystemInfo.UseAssyPOCB) then begin
    // A2CHv3 non-ASSY
    if Common.AlarmList[DefPocb.ALARM_DIO_SHUTTER_GUIDE_NOT_UP].bIsOn then begin
      pnlAlarmShutterGuide.Color := nAlarmOnColor;  pnlAlarmShutterGuide.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_SHUTTER_GUIDE_NOT_UP].AlarmMsg;
    end
    else begin
      pnlAlarmShutterGuide.Color := nAlarmOffColor; pnlAlarmShutterGuide.Font.Color := nAlarmOffFontColor;
    end;
    if Common.AlarmList[DefPocb.ALARM_DIO_CAMZONE_PARTITION_NOT_DOWN].bIsOn then begin
      pnlAlarmCamZonePartition.Color := nAlarmOnColor;  pnlAlarmCamZonePartition.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_CAMZONE_PARTITION_NOT_DOWN].AlarmMsg;
    end
    else begin
      pnlAlarmCamZonePartition.Color := nAlarmOffColor; pnlAlarmCamZonePartition.Font.Color := nAlarmOffFontColor;
    end;
    if Common.AlarmList[DefPocb.ALARM_DIO_CAMZONE_INNER_DOOR_NOT_CLOSE].bIsOn then begin
      pnlAlarmCamZoneInnerDoor.Color := nAlarmOnColor;  pnlAlarmCamZoneInnerDoor.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_CAMZONE_INNER_DOOR_NOT_CLOSE].AlarmMsg;
    end
    else begin
      pnlAlarmCamZoneInnerDoor.Color := nAlarmOffColor; pnlAlarmCamZoneInnerDoor.Font.Color := nAlarmOffFontColor;
    end;
    if Common.AlarmList[DefPocb.ALARM_DIO_LOADZONE_PARTITION_NOT_DETECTED].bIsOn then begin
      pnlAlarmLoadZonePartition.Color := nAlarmOnColor;  pnlAlarmLoadZonePartition.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_LOADZONE_PARTITION_NOT_DETECTED].AlarmMsg;
    end
    else begin
      pnlAlarmLoadZonePartition.Color := nAlarmOffColor; pnlAlarmLoadZonePartition.Font.Color := nAlarmOffFontColor;
    end;
    if Common.AlarmList[DefPocb.ALARM_DIO_ASSY_JIG_DETECTED].bIsOn then begin
      pnlAlarmAssyJig.Color := nAlarmOnColor;  pnlAlarmAssyJig.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_ASSY_JIG_DETECTED].AlarmMsg;
    end
    else begin
      pnlAlarmAssyJig.Color := nAlarmOffColor; pnlAlarmAssyJig.Font.Color := nAlarmOffFontColor;
    end;
  end
  else begin
    if Common.AlarmList[DefPocb.ALARM_DIO_SHUTTER_GUIDE_NOT_DOWN].bIsOn then begin
      pnlAlarmShutterGuide.Color := nAlarmOnColor;  pnlAlarmShutterGuide.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_SHUTTER_GUIDE_NOT_DOWN].AlarmMsg;
    end
    else begin
      pnlAlarmShutterGuide.Color := nAlarmOffColor; pnlAlarmShutterGuide.Font.Color := nAlarmOffFontColor;
    end;
    if Common.AlarmList[DefPocb.ALARM_DIO_CAMZONE_PARTITION_NOT_UP].bIsOn then begin
      pnlAlarmCamZonePartition.Color := nAlarmOnColor;  pnlAlarmCamZonePartition.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_CAMZONE_PARTITION_NOT_UP].AlarmMsg;
    end
    else begin
      pnlAlarmCamZonePartition.Color := nAlarmOffColor; pnlAlarmCamZonePartition.Font.Color := nAlarmOffFontColor;
    end;
    if Common.AlarmList[DefPocb.ALARM_DIO_CAMZONE_INNER_DOOR_NOT_OPEN].bIsOn then begin
      pnlAlarmCamZoneInnerDoor.Color := nAlarmOnColor;  pnlAlarmCamZoneInnerDoor.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_CAMZONE_INNER_DOOR_NOT_OPEN].AlarmMsg;
    end
    else begin
      pnlAlarmCamZoneInnerDoor.Color := nAlarmOffColor; pnlAlarmCamZoneInnerDoor.Font.Color := nAlarmOffFontColor;
    end;
    if Common.AlarmList[DefPocb.ALARM_DIO_LOADZONE_PARTITION_DETECTED].bIsOn then begin
      pnlAlarmLoadZonePartition.Color := nAlarmOnColor;  pnlAlarmLoadZonePartition.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_LOADZONE_PARTITION_DETECTED].AlarmMsg;
    end
    else begin
      pnlAlarmLoadZonePartition.Color := nAlarmOffColor; pnlAlarmLoadZonePartition.Font.Color := nAlarmOffFontColor;
    end;
    if Common.AlarmList[DefPocb.ALARM_DIO_ASSY_JIG_STAGE_NOT_ALIGNED].bIsOn then begin
      pnlAlarmAssyJig.Color := nAlarmOnColor;  pnlAlarmAssyJig.Font.Color := nAlarmOnFontColor;
      sMsg := sMsg + #13 + #10 + Common.AlarmList[DefPocb.ALARM_DIO_ASSY_JIG_STAGE_NOT_ALIGNED].AlarmMsg;
    end
    else begin
      pnlAlarmAssyJig.Color := nAlarmOffColor; pnlAlarmAssyJig.Font.Color := nAlarmOffFontColor;
    end;
  end;
  {$ENDIF} //SUPPORT_1CG2PANEL
end;

end.
