unit DiSimul;

interface
{$I Common.inc}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, ALed, Vcl.ExtCtrls,
  DefDio, DioCtl, CommonClass;

type
  TTDiTestForm = class(TForm)
    tmrUpdate: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmrUpdateTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    ledDi : array[0..DefDio.MAX_DIO_CNT] of ThhALed;
    btnDi : array[0..DefDio.MAX_DIO_CNT] of TRzBitBtn;

    procedure btnDioClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  DiTestForm: TTDiTestForm;

implementation

{$R *.dfm}

procedure TTDiTestForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tmrUpdate.Enabled := False;
end;

procedure TTDiTestForm.FormCreate(Sender: TObject);
var
  arDioInStr : array of string; //array[0..Pred(DefDio.MAX_DIO_CNT)] of string; //2022-07-15 A2CHv4_#3
  i      : Integer;
  nWidth : Integer;
begin
  arDioInStr := [
{$IF Defined(POCB_A2CH)} //---------------------
       'S1:ReadySW'     // 0
      ,'S2:ReadySW'
      ,'EQ:EMS'
      ,'EQ:TeachMode'
      ,'EQ:LightCtn'    // 4
      ,'EQ:LeftDoor'
      ,'EQ:RightDoor'
      ,'EQ:UnderDoor'
      ,'EQ:LeftFanIn'   // 8
      ,'EQ:RightFanIn'
      ,'EQ:LeftFanOut'
      ,'EQ:RightFanOut'
      ,'EQ:Temperature' // 12
      ,'EQ:PowerAlarm'
      ,'EQ:MainRegu'
      ,'EQ:MC1'
      ,'EQ:MC2'         // 16
      ,'S1:ShutterUp'
      ,'S1:ShutterDown'
      ,'S2:ShutterUp'
      ,'S2:ShutterDown' // 20
      ,'S1:Vacuum1'
      ,'S1:Vacuum2'
      ,'S2:Vacuum1'
      ,'S2:Vacuum2'     // 24
      ,'S1:ExLight'
      ,'S2:ExLight'
      ,''
      ,''               // 28
      ,''
      ,''
      ,'' ];
{$ELSEIF Defined(POCB_A2CHv2)} //---------------------
      'S1:ReadySW'    // 0
      ,'S2:ReadySW'
      ,''
      ,''
      ,''
      ,''
      ,'EMS'
      ,'L-KeyAuto'
      ,'R-KeyAuto'      // 8
      ,'S1:LightC'
      ,'S2:LightC'
      ,'L-Door'
      ,'R-Door'        // 12
      ,'S1:Under1'
      ,'S1:Under2'
      ,'S2:Under1'
      ,'S2:Under2'     // 16
      ,'L-FanIn'
      ,'R-FanIn'
      ,'L-FanOut'
      ,'R-FanOut'      // 20
      ,'Temper'
      ,'Power'
      ,'Cyl-Reg'
      ,'Vac-Reg'       // 24
      ,'S1:ShutUp'
      ,'S1:ShutDn'
      ,'S2:ShutUp'
      ,'S2:ShutDn'     // 28
      ,'S1:Vac1'
      ,'S1:Vac2'
      ,'S2:Vac1'
      ,'S2:Vac2'       // 32
      ,'MC1'
      ,'MC2'
      ,'S1:Y-Home'
      ,'S2:Y-Home'     // 36
      ,'S1:Z-Home'
      ,'S2:Z-Home'
      ,''
      ,''
      ,'S1:PinClose'
      ,'S2:PinClose'    // 42
    {$IFDEF HAS_DIO_EXLIGHT_DETECT}
      ,'S1:ExLight'
      ,'S2:ExLight'    // 42
    {$ELSE}
      ,'',''
    {$ENDIF}
      ,'','','','','','','','','','','','','','','','','','','' ]; // 43~63
{$ELSEIF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)} //---------------------
       'S1:RdyBtn'     // 0
      ,'S2:RdyBtn'
      ,'EMO1-F'
      ,'EMO2-R'
      ,'EMO3-In-R'    // 4
      ,'EMO4-In-L'
      ,'EMO5-L'
    {$IFDEF HAS_DIO_IN_DOOR_LOCK}
      ,'S1:Door1Lock'
      ,'S1:Door2Lock' // 8
      ,'S2:Door1Lock'
      ,'S2:Door2Lock'
    {$ELSE}
      ,''
      ,''             // 8
      ,''
      ,''
    {$ENDIF}
      ,'S1:Muting'
      ,'S2:Muting'    // 12
      ,'S1:LightC'
      ,'S2:LightC'
      ,'S1:Key-A'
      ,'S1:Key-T'     // 16
      ,'S2:Key-A'
      ,'S2:Key-T'
      ,'S1:Door1Open'
      ,'S1:Door2Open' // 20
      ,'S2:Door1Open'
      ,'S2:Door2Open'
      ,'Cyl-Regul'
      ,'Temper'       // 24
      ,'PowerHigh'
      ,'MC1'
      ,'S1:ShutUP'
      ,'S1:ShutDn'    // 28
      ,'S2:ShutUP'
      ,'S2:ShutDn'
  {$IFDEF HAS_DIO_SCREW_SHUTTER} //2022-07-15 A2CHv4_#3			
      ,'S1:S.ShuUP'
      ,'S1:S.ShuDn'   // 32
      ,'S2:S.ShuUP'
      ,'S2:S.ShuDn'
  {$ELSE}
      ,''
      ,''             // 32
      ,''
      ,''
  {$ENDIF}			
  {$IFDEF SUPPORT_1CG2PANEL}
      ,'ShuGuideUP'
      ,'ShuGuideDn'   // 36
      ,'CamZPtUP1'
      ,'CamZPtUP2'
      ,'CamZPtDn1'
      ,'CamZPtDn2'    // 40
  {$ELSE}
	  {$IFDEF HAS_DIO_FAN_INOUT_PC} //2022-07-15 A2CHv4_#3
      ,'FanIn-GPC'
      ,'FanOut-GPC'   // 36
      ,'FanIn-DPC'
      ,'FanOut-DPC'			
		{$ELSE}
      ,''
      ,''             // 36
      ,''
      ,''
		{$ENDIF}
      ,''
      ,''             // 40
  {$ENDIF}
  {$IFDEF HAS_DIO_EXLIGHT_DETECT} //2022-07-15 A2CHv4_#3(X)
      ,'S1:ExLight'
      ,'S2:ExLight'
	{$ELSE}
      ,''
      ,''		
  {$ENDIF}
      ,'S1:Y-Load'
      ,'S2:Y-Load'    // 44
      ,'S1:Vacuum1'
      ,'S1:Vacuum2'
      ,'S2:Vacuum1'
      ,'S2:Vacuum2'   // 48
  {$IFDEF SUPPORT_1CG2PANEL}
      ,'CamZDOpen'
      ,'CamZDClose'
      ,'S1:AssyJig'
      ,'S2:AssyJig'   // 52
  {$ELSE}
      ,''
      ,''
      ,''
      ,''             // 52
  {$ENDIF}
      ,'MC2'
      ,'Vac-Regul'
  {$IFDEF SUPPORT_1CG2PANEL}
      ,'LoadZPt1'
      ,'LoadZPt2'     // 56
  {$ELSE}
      ,''
      ,''             // 56
  {$ENDIF}
      ,'FanIn-L'      // 57
      ,'FanIn-R'      // 58
      ,'FanOut-L'     // 59
      ,'FanOut-R'     // 60
    {$IFDEF HAS_DIO_Y_AXIS_MC}
      ,'S1:YAxisMC'   // 61
      ,'S2:YAxisMC'   // 62
    {$ELSE}
      ,'',''          // 61,62
    {$ENDIF}
      ,'' ];          // 63
{$ENDIF}

  //
  {$IFDEF HAS_DIO_EXLIGHT_DETECT}	
  if (not Common.SystemInfo.HasDioExLightDetect) then begin //2022-07-15 A2CHv4_#3
    arDioInStr[DefDio.IN_STAGE1_EXLIGHT_DETECT] := '';
    arDioInStr[DefDio.IN_STAGE2_EXLIGHT_DETECT] := '';
  end;
  {$ENDIF}	
	{$IFDEF HAS_DIO_FAN_INOUT_PC}		
  if (not Common.SystemInfo.HasDioFanInOutPC) then begin //2022-07-15 A2CHv4_#3
    arDioInStr[DefDio.IN_MAINPC_FAN_IN]  := '';
    arDioInStr[DefDio.IN_MAINPC_FAN_Out] := '';
    arDioInStr[DefDio.IN_CAMPC_FAN_IN]   := '';
    arDioInStr[DefDio.IN_CAMPC_FAN_Out]  := '';
  end;
  {$ENDIF}
  {$IFDEF HAS_DIO_SCREW_SHUTTER}			
  if (not Common.SystemInfo.HasDioScrewShutter) then begin //2022-07-15 A2CHv4_#3
    arDioInStr[DefDio.IN_STAGE1_SCREW_SHUTTER_UP]     := '';
    arDioInStr[DefDio.IN_STAGE1_SCREW_SHUTTER_DOWN]   := '';
    arDioInStr[DefDio.IN_STAGE2_SCREW_SHUTTER_UP]     := '';
    arDioInStr[DefDio.IN_STAGE2_SCREW_SHUTTER_DOWN]   := '';
  end;
  {$ENDIF}
  //
{$IFDEF SITE_LENSVN}
  if (not Common.SystemInfo.HasDioVacuum) then begin  //A2CHvX(True|ATO(False)|GAGO(True) //2023-04-10
    arDioInStr[DefDio.IN_STAGE1_VACUUM1]   := '';
    arDioInStr[DefDio.IN_STAGE1_VACUUM2]   := '';
    arDioInStr[DefDio.IN_STAGE2_VACUUM1]   := '';
    arDioInStr[DefDio.IN_STAGE2_VACUUM2]   := '';
    arDioInStr[DefDio.IN_VACUUM_REGULATOR] := '';
  end;
{$ENDIF}
  //
  nWidth := 120;

  for i := 0 to Pred(DefDio.MAX_DIO_CNT) do
  begin
    ledDi[i] := ThhALed.Create(Self);
    with ledDi[i] do begin
      Parent        := Self;
      Top           := (i mod 32) * Height;
      Left          := (nWidth + ledDi[i].Width) * Trunc(i / 32);
      StyleElements := [];
      ledDi[i].Blink:= False;
    end;

    btnDi[i] := TRzBitBtn.Create(Self);
    with btnDi[i] do begin
      Parent        := Self;
      Height        := ledDi[i].Height;
      Width         := nWidth;
      Top           := ledDi[i].Top;
      Left          := ledDi[i].Left + ledDi[i].Width;
      Font.Size     := 10;
      Cursor        := crHandPoint;
      HotTrack      := True;
      Color         := clBlack;   //TBD?
      Font.Color    := clYellow;  //TBD?
      Alignment     := taCenter;
      Caption       := arDioInStr[i];
      btnDi[i].Tag  := i;
      StyleElements := [];
      Enabled       := True;
      OnClick       := btnDioClick;
    end;
  end;

  Self.Width  := btnDi[DefDio.MAX_DIO_CNT - 1].Left + btnDi[0].Width + 20;
  Self.Height := btnDi[DefDio.MAX_DIO_CNT - 1].Top + btnDi[DefDio.MAX_DIO_CNT - 1].Height + 40;
end;

procedure TTDiTestForm.FormShow(Sender: TObject);
begin
  tmrUpdate.Enabled := True;
end;

procedure TTDiTestForm.tmrUpdateTimer(Sender: TObject);
var
  i    : Integer;
  bIn  : Boolean;
begin
  for i := 0 to Pred(DefDio.MAX_DIO_CNT) do
  begin
    if DongaDio = nil then break;
    bIn := DongaDio.GetDiValue(i) > 0;
    if bIn <> ledDi[i].Value then
      ledDi[i].Value := DongaDio.GetDiValue(i) > 0;
  end;
end;

procedure TTDiTestForm.btnDioClick(Sender: TObject);
var
  nNum : Integer;
  nBit : UInt64;
begin
{$IFDEF SIMULATOR_DIO}
  nNum := TRzBitBtn(Sender).Tag;
  nBit := UInt64(1) shl nNum;
  if DongaDio.GetDiValue(nNum) = 0 then
    DongaDio.m_nSimDioDIValue := DongaDio.m_nSimDioDIValue or nBit
  else
    DongaDio.m_nSimDioDIValue := DongaDio.m_nSimDioDIValue and (not nBit);

  DongaDio.GetDioStatus;
{$ENDIF}
end;

end.
