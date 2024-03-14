unit POCBClass;

interface
{$I Common.inc}

uses
  UserUtils, DioCtl, IonizerCtl, 	CodeSiteLogging, SysUtils, DefIonizer, DefDio, DefPocb,
  CommonClass, Winapi.Windows;


type

TPSavingPreState = record
  IsPowerSaving : Boolean;
  IsIonizerOn : array[0..DefPocb.CH_MAX] of Boolean;
  TowerLamp_R : Boolean;
  TowerLamp_Y : Boolean;
  TowerLamp_G : Boolean;
end;

{
아래와 같은 이유로 해당 클래스 추가
 1. POCB 설비에 대해 전체 적용 가능한/ 각 채널이 아닌 POCB 설비 기능을 위한 클래스 부재
 2. GUI 표기 목적을 제외한 Control기능이 Form내에 혼재되어 있어서는 안됨
 3. 목적과 역할이 불분명한 Common Class
}

TPOCB = class(TObject)
private
  m_savingPreState : TPSavingPreState;

public
  constructor Create; virtual;
  destructor  Destroy; override;
  procedure SetPowerSaving(bValue : Boolean);
end;
var
  DongaPOCB : TPOCB;
implementation

constructor TPOCB.Create;
begin
  if Common.SystemInfo.ScreenSaverTime <> 0 then begin
    SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 1 , 0,  0);
    SystemParametersInfo(SPI_SETSCREENSAVETIMEOUT,Common.SystemInfo.ScreenSaverTime * 60, nil, 0);
  end;

  FillChar(m_savingPreState, SizeOf(TPSavingPreState), 0);
end;

destructor TPOCB.Destroy;
begin
  SystemParametersInfo(SPI_SETSCREENSAVEACTIVE, 0 , 0,  0);
end;

procedure TPOCB.SetPowerSaving(bValue: Boolean);
var
  sIonCmd : string;
  nIdx : Integer;
begin
  if not Common.SystemInfo.ScreenSaverTime = 0 then Exit;

  for nIdx := 0 to DefIonizer.ION_MAX do begin
    if DaeIonizer[nIdx] = nil then Continue;  //TBD:A2CHv4:ION? exit -> continue
  end;

  if m_savingPreState.IsPowerSaving = bValue then begin
    m_savingPreState.IsPowerSaving := bValue;
    Exit;
  end;

  m_savingPreState.IsPowerSaving   := bValue;                      //a

  CodeSite.Send(Format('Power Save %d',[Integer(bValue)]));

  with m_savingPreState do
  begin
    if bValue then begin
      TowerLamp_R := DongaDio.GetDoValue(DefDio.OUT_LAMP_RED)    <> 0;
      TowerLamp_Y := DongaDio.GetDoValue(DefDio.OUT_LAMP_YELLOW) <> 0;
      TowerLamp_G := DongaDio.GetDoValue(DefDio.OUT_LAMP_GREEN)  <> 0;

      //DongaDio.SetTowerLamp(False, False, False);
      for nIdx := 0 to DefIonizer.ION_MAX do begin
        if DaeIonizer[nIdx] = nil then Continue;
        IsIonizerOn[nIdx] := DaeIonizer[nIdx].IsRunning;
        DaeIonizer[nIdx].SetIonizer(False);

        if Common.SystemInfo.HasDioOutIonBar then begin
        DongaDio.SetDoValue(DefDio.OUT_STAGE1_IONBAR_ON,False); // IonBar ON //TBD:DIO:2024-01?  // Added by Kimjs007 2024-01-23 오후 3:22:33
        DongaDio.SetDoValue(DefDio.OUT_STAGE2_IONBAR_ON,False); // IonBar ON //TBD:DIO:2024-01?  // Added by Kimjs007 2024-01-23 오후 3:22:33
        end;
      end;
      //TBD: Robot.MoveHOME?
    end else begin
      for nIdx := 0 to DefIonizer.ION_MAX do begin
        if DaeIonizer[nIdx] = nil then Continue;
        DaeIonizer[nIdx].SetIonizer(IsIonizerOn[nIdx]);


        if Common.SystemInfo.HasDioOutIonBar then begin
        DongaDio.SetDoValue(DefDio.OUT_STAGE1_IONBAR_ON,True); // IonBar OFF //TBD:DIO:2024-01?  // Added by Kimjs007 2024-01-23 오후 3:22:33
        DongaDio.SetDoValue(DefDio.OUT_STAGE2_IONBAR_ON,True); // IonBar OFF //TBD:DIO:2024-01?  // Added by Kimjs007 2024-01-23 오후 3:22:33
        end;
             end;
    //DongaDio.SetTowerLamp(TowerLamp_R, TowerLamp_Y, TowerLamp_G);
    //TBD: Robot.MoveMODEL?
    end;
  end;
end;

end.
