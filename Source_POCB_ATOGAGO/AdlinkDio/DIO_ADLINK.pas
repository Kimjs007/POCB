{$IFDEF DIO_ADLINK}
unit DIO_ADLINK;        //TBD:POCB_A2CH# DIO?

interface

uses
  System.SysUtils, System.Classes, System.UITypes, Winapi.Windows,
  Vcl.Dialogs, Vcl.ExtCtrls,
  Dask, DefPocb, DefDio;

type
  ADioStatus    = array[0..pred(DefDio.MAX_DIO_CNT)] of boolean;
  InDioEvent    = procedure(InDio, OutDio: ADioStatus) of object;
  DioErrEvent   = procedure(IsDioIn: Boolean; Idx: Integer; sMsg: string) of object;
  ArrivedEvent  = procedure(nParam: Integer) of object;
  //
  TDongaDio = class(TObject)
  private
    //NEW----
    m_nCardId         : Integer;
    //
    FInDioStatus      : InDioEvent;
    FMaintInDioStatus : InDioEvent;
    FMaintInDioUse    : Boolean;
    FArrivedUnload    : ArrivedEvent;
    FSetErrMsg        : DioErrEvent;
    FIsReadyToTurn    : Boolean;
    //OLD----
    m_nDOValue, m_nDIValue, m_nOldDIValue  : Integer;
    m_nDIOErr         : Integer;
    m_bEmsFlag        : Boolean;
    m_bStopFlag       : Boolean;
    m_bRestart        : Boolean;
    //NEW---
    procedure SetInDioStatus (const Value: InDioEvent);
    procedure SetMaintInDioStatus(const Value: InDioEvent);
    procedure SetMaintInDioUse(const Value: Boolean);
    procedure SetSetErrMsg(const Value: DioErrEvent);
    procedure SetArrivedUnload(const Value: ArrivedEvent);
    procedure SetIsReadyToTurn(const Value: Boolean);   // for AutoMode? TBD?
    //OLD---
    procedure GetAllDio;
    function CheckIoBeforeOutSig(const wSig : LongWord) : Boolean;
  //function IsSignal(lwInOutSig,wSig : LongWord) : Boolean;  //TBD? NOT-USED?
  public
    //NEW---
    tmCheckDio : TTimer;
    //OLD---
    m_nSetDio,m_nGetDio : ADioStatus;
{$IFDEF POCB_A2CH}
    m_nAutoFlow   : array [DefPocb.JIG_A..DefPocb.JIG_MAX] of Integer;     //TBD:POCB_A2CH# 2CH?
{$ELSE}
    m_nAutoFlow   : Integer;     //TBD:POCB_A2CH# 2CH
{$ENDIF}
    //NEW---
    constructor Create(nScanTime: Integer); virtual;
    destructor Destroy; override;
    property InDioStatus      : InDioEvent read FInDioStatus write SetInDioStatus;
    property MaintInDioStatus : InDioEvent read FMaintInDioStatus write SetMaintInDioStatus;
    property MaintInDioUse    : Boolean read FMaintInDioUse write SetMaintInDioUse;
    property SetErrMsg        : DioErrEvent read FSetErrMsg write SetSetErrMsg;
    property ArrivedUnload    : ArrivedEvent read FArrivedUnload write SetArrivedUnload;
    property IsReadyToTurn    : Boolean read FIsReadyToTurn write SetIsReadyToTurn; // for AutoMode? TBD?
    //OLD---
    procedure GetDioStatus;
    procedure OntmCheckDioTimer(Sender: TObject);
    function  SetDio(lwSignal : LongWord; bAllSet : Boolean = False) : Integer;
  //procedure SetInDioForSimulator; // TBD?: NOT-USED? AutoMode?
  end;
var
  AdLinkDio : TDongaDio;

implementation

{ TDongaDio }

//******************************************************************************
// procedure/function:
//    - constructor TDongaDio.Create(nScanTime: Integer)
//    - destructor TDongaDio.Destroy
//******************************************************************************

constructor TDongaDio.Create(nScanTime: Integer);
var
  i : Integer;
begin
  m_nCardId     := -1;
{$IFNDEF SIMULATOR_DIO}
  m_nCardId := Register_Card(PCI_7230, DefDio.CARDNUMBER_1);  //TBD???
  if m_nCardId < 0 then begin
    MessageDlg('Cannot Find DIO Card(PCI-7230) !', mtError, [mbOk], 0); //TBD???
  end;
{$ELSE}
  m_nCardId     := 0;
{$ENDIF}

  m_nDOValue    := 0;
  m_nDIValue    := 0;
  m_nOldDIValue := 0;
  m_nDIOErr     := 0;

  FMaintInDioUse := False;
  FIsReadyToTurn := False;

  for i := 0 to Pred(DefDio.MAX_DIO_CNT) do begin
    m_nSetDio[i] := False;
    m_nGetDio[i] := False;
  end;
  m_bRestart    := False;
  m_bStopFlag   := False;
  m_bEmsFlag := False;
  //
  tmCheckDio := TTimer.Create(nil);
  tmCheckDio.Enabled  := False;
  tmCheckDio.Interval := nScanTime; // msec
  tmCheckDio.OnTimer  := OntmCheckDioTimer;
end;

destructor TDongaDio.Destroy;
begin
  //
//if tmCheckDio is TTimer then begin
  if tmCheckDio <> nil then begin
    tmCheckDio.Enabled := False;
    tmCheckDio.Free;
    tmCheckDio := nil;
  end;
  //
  Release_Card(DefDio.CARDNUMBER_1);  //TBD???
  if m_nCardId >=0 then Release_Card(m_nCardId);  //EndDio
  //
  inherited;
end;

//******************************************************************************
// procedure/function:
//    - procedure TDongaDio.SetInDioStatus(const Value: InDioEvent)
//    - procedure TDongaDio.SetMaintInDioStatus(const Value: InDioEvent);
//    - procedure TDongaDio.SetMaintInDioUse(const Value: Boolean);
//    - procedure TDongaDio.SetArrivedUnload(const Value: ArrivedEvent);
//    - procedure TDongaDio.SetSetErrMsg(const Value: DioErrEvent);
//    - procedure TDongaDio.SetIsReadyToTurn(const Value: Boolean);
//******************************************************************************

procedure TDongaDio.SetInDioStatus(const Value: InDioEvent);
begin
  FInDioStatus := Value;
end;

procedure TDongaDio.SetMaintInDioStatus(const Value: InDioEvent);
begin
  FMaintInDioStatus := Value;
end;

procedure TDongaDio.SetMaintInDioUse(const Value: Boolean);
begin
  FMaintInDioUse := Value;
  if Value then begin
    if Assigned(MaintInDioStatus) then  MaintInDioStatus(m_nGetDio, m_nSetDio);
  end;
end;

procedure TDongaDio.SetSetErrMsg(const Value: DioErrEvent);
begin
  FSetErrMsg := Value;
end;

procedure TDongaDio.SetArrivedUnload(const Value: ArrivedEvent);
begin
  FArrivedUnload := Value;
end;

{$IFDEF TBD_NOT_UESED}
procedure TDongaDio.SetInDioForSimulator;
var
  i , nTemp: Integer;
  wTemp : word;
begin
  wTemp := 0;
  nTemp := 0;
  for i := 0 to Pred(defDio.MAX_DIO_CNT) do begin
    if m_nGetDio[i] then wTemp := 1 shl i;
    nTemp := nTemp or wTemp;
	end;
  m_nDIValue := nTemp;
end;
{$ENDIF}

procedure TDongaDio.SetIsReadyToTurn(const Value: Boolean);
var
  cdOutSig : Cardinal;
begin
  if Value then begin
    // back Sensor가 들어왔을때만 Set 될수 있도록 하자.
    if (m_nDIValue and  (1 shl DefDio.IN_STAGE1_BACKWARD_SENSOR)) <> 0 then begin
      FIsReadyToTurn := Value;
      m_nAutoFlow[DefPocb.CH_1] := DefDio.IO_AUTO_FLOW_READY;
      cdOutSig := m_nDOValue or (1 shl DefDio.OUT_STAGE1_READY_SWITCH_LED);
      SetDio(cdOutSig,True);
    end;
  end
  else begin
    FIsReadyToTurn := Value;
    m_nAutoFlow[DefPocb.CH_1] := DefDio.IO_AUTO_FLOW_NONE;
    cdOutSig := m_nDOValue and  (not (1 shl DefDio.OUT_STAGE1_READY_SWITCH_LED));
    SetDio(cdOutSig,True);
  end;
end;

//******************************************************************************
// procedure/function: Timer
//    - procedure TDongaDio.OntmCheckDioTimer(Sender: TObject)
//    - procedure TDongaDio.GetAllDio;
//******************************************************************************

procedure TDongaDio.OntmCheckDioTimer(Sender: TObject);
begin
  tmCheckDio.Enabled := False;
  GetAllDio;
  //
  tmCheckDio.Enabled := True;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TDongaDio.GetAllDio
//    Called-by: procedure TDongaDio.OntmCheckDioTimer(Sender: TObject);
//
procedure TDongaDio.GetAllDio;
var
  cdTemp, cdTarget, cdOutSig  : Cardinal;
  i       : Integer;
  wTemp   : Word;
//nTemp   : Integer;
  sErrMsg : string;
//bTemp   : Boolean;
begin
  cdTemp := m_nDIValue;
{$IFNDEF SIMULATOR_DIO}
  m_nDIOErr := DI_ReadPort(word(m_nCardId),word(DefDio.DIPORT),cdTemp);
  m_nDIValue := cdTemp;
{$ENDIF}
  for i := 0 to Pred(defDio.MAX_DIO_CNT) do begin
    wTemp := 1 shl i;
    if (wTemp and cdTemp) <> 0  then m_nGetDio[i] := True
    else                             m_nGetDio[i] := False;
  end;
  if m_nDIValue <> m_nOldDIValue then begin
    InDioStatus(m_nGetDio, m_nSetDio);
    if FMaintInDioUse then begin
      if Assigned(MaintInDioStatus) then  MaintInDioStatus(m_nGetDio, m_nSetDio);
    end;

    // Logic 추가.
    // EMS 신호가 들어오면, 모든 out Signal Off ==> Lamp RED, Buzzer ON.
    cdTarget := 1 shl DefDio.IN_EQUIP_EMS;
    if (cdTemp and cdTarget) <> 0 then begin
      // vacuum을 살려 놔야 함.

      cdOutSig := (1 shl DefDio.OUT_EQUIP_LAMP_RED) or (1 shl DefDio.OUT_EQUIP_BUZZER);
      cdOutSig := cdOutSig or (m_nDOValue and (1 shl DefDio.OUT_STAGE1_VACUUM));  //TBD???
      m_bEmsFlag := True;
      SetDio(cdOutSig,True);
      m_nOldDIValue := cdTemp;
      sErrMsg := 'EMS - please press reset button after taking measures';
      sErrMsg := sErrMsg + #$0d  + '비상정지. 조치후 Reset 버튼 눌러주시기 바랍니다';
      if Assigned(SetErrMsg) then SetErrMsg(True,DefDio.IN_EQUIP_EMS,sErrMsg);
      Exit;
    end;

    // Reset 신호가 들어오면, ( Lamp RED, Buzzer Off ).
    cdTarget := 1 shl DefDio.IN_EQUIP_RESET_EMS;
    if (cdTemp and cdTarget) <> 0 then begin
      cdOutSig := m_nDOValue and ( not((1 shl DefDio.OUT_EQUIP_LAMP_RED) or (1 shl DefDio.OUT_EQUIP_BUZZER)));
      if FIsReadyToTurn and (m_bEmsFlag or m_bStopFlag) then begin
        m_bRestart := True;
        m_bStopFlag := False;
      end;
      m_bEmsFlag := False;
      SetDio(cdOutSig,True);
      m_nOldDIValue := cdTemp;
      if Assigned(SetErrMsg) then SetErrMsg(True,DefDio.IN_EQUIP_RESET_EMS,'');
      Exit;
    end;

    // Area Sensor가 꺼지면  Front Back stage off. Shuttor up / down signal off.
    cdTarget := (1 shl DefDio.IN_STAGE1_AREA_SENSOR);
    if (cdTemp and cdTarget) = 0 then begin    // 0 주의.
      cdOutSig := (1 shl DefDio.OUT_STAGE1_FORWARD_STAGE) or (1 shl DefDio.OUT_STAGE1_BACKWARD_STAGE);
//      cdOutSig := cdOutSig or (1 shl DefDio.OUT_SHUTTER_UP) or (1 shl DefDio.OUT_SHUTTER_DOWN) ;
      cdOutSig := m_nDOValue and (not cdOutSig);
      SetDio(cdOutSig,True);
      m_nOldDIValue := cdTemp;
      m_bStopFlag := True;
      if (m_nAutoFlow[DefPocb.CH_1] in [DefDio.IO_AUTO_FLOW_FRONT, DefDio.IO_AUTO_FLOW_BACK]) then begin //TBD???
        sErrMsg := 'Detect Area Sensor - please press reset button';
        sErrMsg := sErrMsg + #$0d  + '움직임 감지. Reset 버튼 눌러주시기 바랍니다';
        if Assigned(SetErrMsg) then SetErrMsg(True,DefDio.IN_STAGE1_AREA_SENSOR,sErrMsg);
      end;
      Exit;
    end;
    // Door Sensor가 들어오면 Front Back stage off. Shuttor up / down signal off.
    cdTarget := (1 shl DefDio.IN_STAGE1_DOOR_SENSOR_1) or (1 shl DefDio.IN_STAGE1_DOOR_SENSOR_2);
    if (cdTemp and cdTarget) <> 0 then begin
      cdOutSig := (1 shl DefDio.OUT_STAGE1_FORWARD_STAGE) or (1 shl DefDio.OUT_STAGE1_BACKWARD_STAGE);
//      cdOutSig := cdOutSig or (1 shl DefDio.OUT_SHUTTER_UP) or (1 shl DefDio.OUT_SHUTTER_DOWN) ;
      cdOutSig := m_nDOValue and (not cdOutSig);
      SetDio(cdOutSig,True);
      m_nOldDIValue := cdTemp;
      m_bStopFlag := True;
      if not (m_nAutoFlow[DefPocb.CH_1] in [DefDio.IO_AUTO_FLOW_NONE, DefDio.IO_AUTO_FLOW_CAMERA, DefDio.IO_AUTO_FLOW_UNLOAD]) then begin
        sErrMsg := 'DOOR OPEN - please press reset button after close the door';
        sErrMsg := sErrMsg + #$0d  + '문 열림 오류. 문을 닫은 후 Reset 버튼 눌러주시기 바랍니다';
        if Assigned(SetErrMsg) then SetErrMsg(True,DefDio.IN_STAGE1_DOOR_SENSOR_1,sErrMsg);
      end;

      Exit;
    end;

    // Stage front 신호가 들어 오면, Stage front out sig Off 하자.
    cdTarget := 1 shl DefDio.IN_STAGE1_FORWARD_SENSOR;
    cdOutSig := (1 shl DefDio.OUT_STAGE1_FORWARD_STAGE);
    if  ((cdTemp and cdTarget) <> 0) and ((cdOutSig and m_nDOValue) <> 0 ) then begin
      cdOutSig := m_nDOValue and (not (1 shl DefDio.OUT_STAGE1_FORWARD_STAGE));

      if FIsReadyToTurn then begin
        if m_nAutoFlow[DefPocb.CH_1] = DefDio.IO_AUTO_FLOW_FRONT then begin
          m_nAutoFlow[DefPocb.CH_1] := DefDio.IO_AUTO_FLOW_SHUTTER_DOWN;
          cdOutSig := cdOutSig or (1 shl DefDio.OUT_STAGE1_SHUTTER_DOWN);
        end;
      end;
      SetDio(cdOutSig,True);
      m_bStopFlag := False;
      m_nOldDIValue := cdTemp;
      Exit;
    end;

    // Stage back 신호가 들어오면, Stage back out Sig Off 하자.
    cdTarget := 1 shl DefDio.IN_STAGE1_BACKWARD_SENSOR;
    cdOutSig := 1 shl DefDio.OUT_STAGE1_BACKWARD_STAGE;
    if  ((cdTemp and cdTarget) <> 0) and ((cdOutSig and m_nDOValue) <> 0 ) then begin
      cdOutSig := m_nDOValue and (not (1 shl DefDio.OUT_STAGE1_BACKWARD_STAGE));
      if FIsReadyToTurn then begin
        if m_nAutoFlow[DefPocb.CH_1] = DefDio.IO_AUTO_FLOW_BACK then begin
          m_nAutoFlow[DefPocb.CH_1] := DefDio.IO_AUTO_FLOW_UNLOAD;
          if Assigned(ArrivedUnload) then ArrivedUnload(m_nAutoFlow[DefPocb.CH_1]);
          m_nAutoFlow[DefPocb.CH_1] := DefDio.IO_AUTO_FLOW_NONE;
        end;
      end
      else begin
        m_nAutoFlow[DefPocb.CH_1] := DefDio.IO_AUTO_FLOW_NONE;
      end;
      FIsReadyToTurn := False;
      SetDio(cdOutSig,True);
      m_nOldDIValue := cdTemp;
      Exit;
    end;

    // Door Up 신호가 들어 오면, Door Up out sig Off 하자.
    cdTarget := 1 shl DefDio.IN_STAGE1_SHUTTER_UP_SENSOR;
    cdOutSig := (1 shl DefDio.OUT_STAGE1_SHUTTER_UP);
    if  ((cdTemp and cdTarget) <> 0) and ((cdOutSig and m_nDOValue) <> 0 ) then begin
      cdOutSig := m_nDOValue and (not (1 shl DefDio.OUT_STAGE1_SHUTTER_UP));
      if FIsReadyToTurn then begin
        if m_nAutoFlow[DefPocb.CH_1] = DefDio.IO_AUTO_FLOW_SHUTTER_UP then begin
          m_nAutoFlow[DefPocb.CH_1] := DefDio.IO_AUTO_FLOW_BACK;
          cdOutSig := cdOutSig or (1 shl DefDio.OUT_STAGE1_BACKWARD_STAGE);
        end;
      end;
      SetDio(cdOutSig,True);
      m_nOldDIValue := cdTemp;

      Exit;
    end;

    // Door Down 신호가 들어오면, Door Down out Sig Off 하자.
    cdTarget := 1 shl DefDio.IN_STAGE1_SHUTTER_DOWN_SENSOR;
    cdOutSig := 1 shl DefDio.OUT_STAGE1_SHUTTER_DOWN;
    if ((cdTemp and cdTarget) <> 0) and ((cdOutSig and m_nDOValue) <> 0 ) then begin
      cdOutSig := m_nDOValue and (not (1 shl DefDio.OUT_STAGE1_SHUTTER_DOWN));
      if FIsReadyToTurn then begin
        if m_nAutoFlow[DefPocb.CH_1] = DefDio.IO_AUTO_FLOW_SHUTTER_DOWN then begin
          m_nAutoFlow[DefPocb.CH_1] := DefDio.IO_AUTO_FLOW_CAMERA;
        end;
      end;
      SetDio(cdOutSig,True);
      m_nOldDIValue := cdTemp;
      Exit;
    end;

    // Power On - Pattern Display가 되면 Camera Zone으로 턴할수 있도록 Ready Sig Out 상태 설정.
    if FIsReadyToTurn then begin
      if m_bRestart then begin
        case m_nAutoFlow[DefPocb.CH_1] of
          DefDio.IO_AUTO_FLOW_READY : begin
            // Switch LED.
            cdTarget := 1 shl DefDio.OUT_STAGE1_READY_SWITCH_LED;
            // SWITCH가 안켜져 있으면 스위치 키자.
            if ((m_nDOValue and cdTarget) = 0)  then begin
              cdOutSig := m_nDOValue or (1 shl DefDio.OUT_STAGE1_READY_SWITCH_LED);
              SetDio(cdOutSig,True);
            end
          end;
          DefDio.IO_AUTO_FLOW_FRONT : begin
            cdTarget := 1 shl DefDio.OUT_STAGE1_FORWARD_STAGE;
            // Front로 안가고 있으면 계속 가자.
            if ((m_nDOValue and cdTarget) = 0)  then begin
              cdOutSig := m_nDOValue or (1 shl DefDio.OUT_STAGE1_FORWARD_STAGE);
              cdOutSig := cdOutSig and (not (1 shl DefDio.OUT_STAGE1_READY_SWITCH_LED));
              SetDio(cdOutSig,True);
            end;

          end;
          DefDio.IO_AUTO_FLOW_SHUTTER_DOWN : begin
            cdTarget := 1 shl DefDio.OUT_STAGE1_SHUTTER_DOWN;
            // Front로 안가고 있으면 계속 가자.
            if ((m_nDOValue and cdTarget) = 0)  then begin
              cdOutSig := m_nDOValue or (1 shl DefDio.OUT_STAGE1_SHUTTER_DOWN);
              SetDio(cdOutSig,True);
            end;
          end;
          DefDio.IO_AUTO_FLOW_SHUTTER_UP : begin
            cdTarget := 1 shl DefDio.OUT_STAGE1_SHUTTER_UP;
            // Front로 안가고 있으면 계속 가자.
            if ((m_nDOValue and cdTarget) = 0)  then begin
              cdOutSig := m_nDOValue or (1 shl DefDio.OUT_STAGE1_SHUTTER_UP);
              SetDio(cdOutSig,True);
            end;
          end;
          DefDio.IO_AUTO_FLOW_BACK : begin
            cdTarget := 1 shl DefDio.OUT_STAGE1_BACKWARD_STAGE;
            // Front로 안가고 있으면 계속 가자.
            if ((m_nDOValue and cdTarget) = 0)  then begin
              cdOutSig := m_nDOValue or (1 shl DefDio.OUT_STAGE1_BACKWARD_STAGE);
              SetDio(cdOutSig,True);
            end;
          end;
        end;
        m_bRestart := False;
      end;
      case m_nAutoFlow[DefPocb.CH_1] of
        DefDio.IO_AUTO_FLOW_READY : begin
          cdOutSig := 1 shl DefDio.OUT_STAGE1_FORWARD_STAGE;
          if ((cdOutSig and m_nDOValue) = 0) then begin
            // Switch LED.
            cdTarget := 1 shl DefDio.OUT_STAGE1_READY_SWITCH_LED;
            // 전진 상태가 아니고, SWITCH가 안켜져 있으면 스위치 키자.
            if ((m_nDOValue and cdTarget) = 0)  then begin
              cdOutSig := m_nDOValue or (1 shl DefDio.OUT_STAGE1_READY_SWITCH_LED);
              SetDio(cdOutSig,True);
            end
            else begin
              // LED 불이 들어온 상태에서...    Ready switch 2개가 감지 되면 Turn.
              if ((cdTemp and (1 shl DefDio.IN_STAGE1_READY_1)) <> 0) and ((cdTemp and (1 shl DefDio.IN_STAGE1_READY_2)) <> 0) then begin
                cdOutSig := m_nDOValue or (1 shl DefDio.OUT_STAGE1_FORWARD_STAGE);
                cdOutSig := cdOutSig and (not (1 shl DefDio.OUT_STAGE1_READY_SWITCH_LED));
                SetDio(cdOutSig,True);
                m_nAutoFlow[DefPocb.CH_1] := DefDio.IO_AUTO_FLOW_FRONT;
              end;
            end;
          end;
        end;
      end;


    end;
  end;
  m_nOldDIValue := cdTemp;
end;

//******************************************************************************
// procedure/function:
//    - procedure TDongaDio.GetDioStatus;
//    - function TDongaDio.CheckIoBeforeOutSig(const wSig: LongWord): Boolean;
//    - function TDongaDio.SetDio(lwSignal: LongWord; bAllSet: Boolean = False): Integer;
//    - //function TDongaDio.IsSignal(lwInOutSig,wSig: LongWord): Boolean;  //TBD? NOT-USED?
//******************************************************************************

//------------------------------------------------------------------------------
// [PROC/FUNC] TDongaDio.GetDioStatus
//    Called-by: procedure TfrmMain.CreateClassData;
//
procedure TDongaDio.GetDioStatus;
begin
  tmCheckDio.Enabled := True;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TDongaDio.CheckIoBeforeOutSig(const wSig: LongWord): Boolean
//    Called-by: function TDongaDio.SetDio(lwSignal: LongWord; bAllSet : Boolean = False): Integer;
//
function TDongaDio.CheckIoBeforeOutSig(const wSig: LongWord): Boolean;
var
  wInSig, wInTarget, wOutTarget, wOutSig : LongWord;
  bRen   : Boolean;
begin
  wInSig := m_nDIValue;
  wOutSig := wSig;// 1 shl wSig;
  bRen := True;

// test용.
//  wInSig := wInSig or (1 shl DefDio.IN_STAGE_FORWARD_SENSOR) or (1 shl DefDio.IN_AREA_SENSOR) or (1 shl DefDio.IN_SHUTTER_UP_SENSOR);

  // In case of Stage font & back.
  wOutTarget := (1 shl DefDio.OUT_STAGE1_FORWARD_STAGE) or (1 shl DefDio.OUT_STAGE1_BACKWARD_STAGE);
  if (wOutSig and wOutTarget) <> 0 then begin
    // EMS일 경우 신호 나가면 안됨.
    wInTarget := 1 shl DefDio.IN_EQUIP_EMS;
    if (wInSig and wInTarget) <> 0 then Exit(False);
    // Area Sensor가 없을 경우 신호 나가면 안됨.
    wInTarget := 1 shl DefDio.IN_STAGE1_AREA_SENSOR;
    if (wInSig and wInTarget) = 0 then Exit(False);
    // Door Sensor 1 & 2 경우 신호 나가면 안됨.
    wInTarget := (1 shl DefDio.IN_STAGE1_DOOR_SENSOR_1) or (1 shl DefDio.IN_STAGE1_DOOR_SENSOR_2);
    if (wInSig and wInTarget) <> 0 then Exit(False);
    // EMS일 경우 Reset 하기전에 신호 나가면 안됨.
    if m_bEmsFlag then Exit(False);

    // Door Down 신호가 있으면 움직이면 안됨.
    wInTarget := 1 shl DefDio.IN_STAGE1_SHUTTER_DOWN_SENSOR;
    if (wInSig and wInTarget) <> 0 then Exit(False);

    // Shutter UP Sig가 없으면 움직이면 안됨.
    wInTarget := 1 shl DefDio.IN_STAGE1_SHUTTER_UP_SENSOR;
    if (wInSig and wInTarget) = 0 then Exit(False);

    // front stage sig가 있을때 Front Signal이 동작 하면 안됨.
    wOutTarget := (1 shl DefDio.OUT_STAGE1_FORWARD_STAGE);
    if (wOutSig and wOutTarget) <> 0 then begin
      // EMS일 경우 신호 나가면 안됨.
      wInTarget := 1 shl DefDio.IN_STAGE1_FORWARD_SENSOR;
      if (wInSig and wInTarget) <> 0 then Exit(False);
    end;

    // back stage sig가 있을때 back Signal이 동작 하면 안됨.
    wOutTarget := (1 shl DefDio.OUT_STAGE1_BACKWARD_STAGE);
    if (wOutSig and wOutTarget) <> 0 then begin
      // EMS일 경우 신호 나가면 안됨.
      wInTarget := 1 shl DefDio.IN_STAGE1_BACKWARD_SENSOR;
      if (wInSig and wInTarget) <> 0 then Exit(False);
    end;
  end;

  // In case of Shutter down.
  wOutTarget := (1 shl DefDio.OUT_STAGE1_SHUTTER_DOWN);
  if (wOutSig and wOutTarget) <> 0 then begin
    // EMS일 경우 신호 나가면 안됨.
    wInTarget := 1 shl DefDio.IN_EQUIP_EMS;
    if (wInSig and wInTarget) <> 0 then Exit(False);
    // Area Sensor가 없을 경우 신호 나가면 안됨.
    wInTarget := 1 shl DefDio.IN_STAGE1_AREA_SENSOR;
    if (wInSig and wInTarget) = 0 then Exit(False);
    // Door Sensor 1 & 2 경우 신호 나가면 안됨.
    wInTarget := (1 shl DefDio.IN_STAGE1_DOOR_SENSOR_1) or (1 shl DefDio.IN_STAGE1_DOOR_SENSOR_2);
    if (wInSig and wInTarget) <> 0 then Exit(False);
    // EMS일 경우 Reset 하기전에 신호 나가면 안됨.
    if m_bEmsFlag then Exit(False);

    // front stage signal이 없으면 shutter down 하지 말자.
    wInTarget := 1 shl DefDio.IN_STAGE1_FORWARD_SENSOR;
    if (wInSig and wInTarget) = 0 then Exit(False);

    // front or Back stage 신호가 있으면 움직이면 안됨.
    wOutTarget := (1 shl DefDio.OUT_STAGE1_FORWARD_STAGE) or (1 shl DefDio.OUT_STAGE1_BACKWARD_STAGE);
    if (wOutTarget and wInTarget) <> 0 then Exit(False);
  end;

  // In case of Shutter down.
  wOutTarget := (1 shl DefDio.OUT_STAGE1_SHUTTER_UP);
  if (wOutSig and wOutTarget) <> 0 then begin
    if FIsReadyToTurn then begin
      if m_nAutoFlow[DefPocb.CH_1] = DefDio.IO_AUTO_FLOW_CAMERA then begin //TBD???
        m_nAutoFlow[DefPocb.CH_1] := DefDio.IO_AUTO_FLOW_SHUTTER_UP;
      end;
    end;
  end;

  Result := bRen;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TDongaDio.SetDio(lwSignal: LongWord; bAllSet: Boolean = False): Integer;
//    Called-by: procedure TLogic.CamProcess; //OUT_STAGE1_SHUTTER_UP
//    Called-by: procedure TfrmMainter.btnDioOutClick(Sender: TObject);
//    Called-by: procedure TfrmTest1Ch.RevSwDataJig(sGetData: String);  //
//    Called-by: procedure TfrmTest1Ch.btnRcbSimKey7VacummClick(Sender: TObject);  //OUT_STAGE1_VACUUM
//    Called-by: procedure TfrmTest1Ch.WorkStart; //OUT_STAGE1_VACUUM
//
function TDongaDio.SetDio(lwSignal: LongWord; bAllSet: Boolean = False): Integer;
var
  nRet, i : Integer;
  lwTemp : LongWord;
begin
  // Logic 추가.
  //Door Down Signal 이거나 Door Up Signal이 없을때, switch Ready와 stage front, back 신호 주지 말자.
  if not bAllSet then begin
    lwTemp := 1 shl lwSignal;
    if not CheckIoBeforeOutSig(lwTemp) then Exit;
  end
  else begin
    if not CheckIoBeforeOutSig(lwSignal) then Exit;
  end;

  if bAllSet then begin
    m_nDOValue := lwSignal;
    for i := 0 to Pred(DefDio.MAX_DIO_CNT) do begin
      lwTemp := 1 shl i;
      if (lwTemp and lwSignal) <> 0 then begin
        m_nSetDio[i] := True;
      end
      else begin
        m_nSetDio[i] := False;
      end;
    end;

  end
  else begin
    if ((m_nDOValue shr lwSignal) and $01) > 0 then begin
      m_nDOValue := m_nDOValue - (1 shl lwSignal);
      m_nSetDio[lwSignal] := False;
      nRet :=0;
    end
    else begin
      m_nDOValue := m_nDOValue + (1 shl lwSignal);
      m_nSetDio[lwSignal] := True;
      nRet :=1;
    end;
  end;

{$IFNDEF SIMULATOR_DIO}
  m_nDIOErr := DO_WritePort(m_nCardId, DefDio.DOPORT, m_nDOValue);
{$ELSE}
  m_nDIOErr := 0;
{$ENDIF}
  if m_nDIOErr > 0 then Result := 2
  else begin
    InDioStatus(m_nGetDio,m_nSetDio);
    if FMaintInDioUse then begin
      if Assigned(MaintInDioStatus) then  MaintInDioStatus(m_nGetDio, m_nSetDio);
    end;
    Result := nRet;
  end;
end;

{$IFDEF TBD_NOT_USED}
function TDongaDio.IsSignal(lwInOutSig,wSig: LongWord): Boolean;  //TBD? NOT-USED?
var
  bRet : boolean;
begin
  bRet := False;
  if ((lwInOutSig shr wSig) and $01) > 0 then begin
    bRet := True;
  end;
  Result := bRet;
end;
{$ENDIF}

end.
{$ENDIF}  // DIO_ADLINK
