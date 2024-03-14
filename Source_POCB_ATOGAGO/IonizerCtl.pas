unit IonizerCtl;

interface
{$I Common.inc}

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  Vcl.ExtCtrls,
  System.Classes,
  VaComm,
  Vcl.Dialogs,
  DefSerialComm,
  DefIonizer,
  CodeSiteLogging,
  UserUtils,
{$IFDEF INSPECTOR_POCB}
  DefPocb,
{$ELSE}
  DefCommon,
{$ENDIF}
  CommonClass;

type
  PMainGuiIonData = ^RMainGuiIonData;

  RMainGuiIonData = packed record
    MsgType: Integer;
    Channel: Integer;
    IonChIdx: Integer;
    Mode: Integer;
    Param: Integer;
    MSG: string;
  end;

  PTestGuiIonData = ^RTestGuiIonData;

  RTestGuiIonData = packed record
    MsgType: Integer;
    Channel: Integer;
    IonChIdx: Integer;
    Mode: Integer;
    Param: Integer;
    MSG: string;
  end;

  InIonizerEvent = procedure(bIsConnect: Boolean; sGetData: String) of object;

  TIonizer = class(TObject)
    ComIonizer: TVaComm;
  private
    m_hMain: THandle;
    m_hTest: THandle;
    m_nJig: Integer;  //POCB: nCh
    m_nIonChIdx: Integer;
    m_myComPort: Integer;
    m_bManualOff: Boolean;
    FIsRunning: Boolean;
    tmIonAliveCheck, tmIonWaitAck: TTimer;
    FReadyIonizer: Integer;
    FOnRevIonizerData: InIonizerEvent;
    procedure SetOnRevIonizerData(const Value: InIonizerEvent);
    procedure ReadVaCom(Sender: TObject; Count: Integer);
    procedure SendMainGuiDisplay(nGuiMode, nConnect: Integer; sMsg: string);
    procedure SendTestGuiDisplay(nGuiMode, nConnect: Integer; sMsg: string);  //NOT-USED
    procedure OnTimeIonAliveCheck(Sender: TObject);
    procedure OnTimeIonWaitAck(Sender: TObject);
  public
    m_bConnected: Boolean;
    m_bStatusOK: Boolean;
    m_nTimeoutCnt: Integer;
    m_nStatusNgCnt: Integer;
    m_sStatusMsg: string;    //2021-05-26
    m_sIonProductType: string; //2021-05-26
    {$IFDEF SIMULATOR_ION}
    SimIonCmdTX: string;
    SimIonFanSpeed: Integer;
    function SimIonGetRxData(sCmd: string): string;
    procedure SimIonSetRxData(sCmd: string);
    {$ENDIF}
    constructor Create(nJig, nIonChIdx: Integer; hMain, hTest: HWND); virtual;
    destructor Destroy; override;
    property ReadyIonizer: Integer read FReadyIonizer write FReadyIonizer;
    property OnRevIonizerData: InIonizerEvent read FOnRevIonizerData write SetOnRevIonizerData;
    property IsRunning: Boolean read FIsRunning;
    procedure ChangePort(nPort: Integer);
    procedure SendMsg(sCmd: string; nBlowerAddr: Integer);  //sCmd: REQ|RUN|STP|CLN
    procedure SetIonizer(bValue: Boolean);
  end;

var
  DaeIonizer: array[0..DefIonizer.ION_MAX] of TIonizer;

implementation

uses
  LogicPocb;  //2022-01-02

//******************************************************************************
// procedure/function:
//
//******************************************************************************

constructor TIonizer.Create(nJig, nIonChIdx: Integer; hMain, hTest: HWND);
begin
  FReadyIonizer := 0;
  m_hMain := hMain;
  m_hTest := hTest;
  m_nJig := nJig;
  m_nIonChIdx := nIonChIdx;
  ComIonizer := TVaComm.Create(nil);
  //
  tmIonAliveCheck := TTimer.Create(nil);
  tmIonAliveCheck.Interval := DefIonizer.ION_ALIVECHECK_TIMESEC * 1000;  //10 sec
  tmIonAliveCheck.Enabled := False;
  tmIonAliveCheck.OnTimer := OnTimeIonAliveCheck;
  //
  tmIonWaitAck := TTimer.Create(nil);
  tmIonWaitAck.Interval := DefIonizer.ION_STATUSWAIT_TIMESEC * 1000;  //2 sec
  tmIonWaitAck.Enabled := False;
  tmIonWaitAck.OnTimer := OnTimeIonWaitAck;
  //
  m_bConnected := False;
  m_bStatusOK := False;
  m_bManualOff := False;
  m_nTimeoutCnt := 0;
  m_nStatusNgCnt := 0;
  m_sStatusMsg := '';  //2021-05-26

  m_sIonProductType := '';  //2021-05-26
  if Common.SystemInfo.ION_PRODUCT_MODEL = ION_SBL_12A then
    m_sIonProductType := ION_CMD_TYPE_SBL12A
  else if Common.SystemInfo.ION_PRODUCT_MODEL = ION_SBL_15S then
    m_sIonProductType := ION_CMD_TYPE_SBL15S
  else if Common.SystemInfo.ION_PRODUCT_MODEL = ION_SBL_20W then
    m_sIonProductType := ION_CMD_TYPE_SBL20W
  else if Common.SystemInfo.ION_PRODUCT_MODEL = ION_SIB5S then
    m_sIonProductType := ION_CMD_TYPE_SIB5S                            // Added by Kimjs007 2024-02-06 오후 6:22:58
  else
    Common.MLog(DefPocb.SYS_LOG, '<Ionizer> Unknown IONIZER Product Model (' + Common.SystemInfo.ION_PRODUCT_MODEL + ')');

  {$IFDEF SIMULATOR_ION}
  SimIonCmdTX := '';
  SimIonFanSpeed := 4;
  {$ENDIF}
end;

destructor TIonizer.Destroy;
begin
  if tmIonAliveCheck <> nil then begin
    tmIonAliveCheck.Enabled := False;
    tmIonAliveCheck.Free;
    tmIonAliveCheck := nil;
  end;
  if tmIonWaitAck <> nil then begin
    tmIonWaitAck.Enabled := False;
    tmIonWaitAck.Free;
    tmIonWaitAck := nil;
  end;
  if ComIonizer is TVaComm then begin
    ComIonizer.Close;
    ComIonizer.Free;
    ComIonizer := nil;
  end;
  inherited;
end;

procedure TIonizer.SetOnRevIonizerData(const Value: InIonizerEvent);
begin
  FOnRevIonizerData := Value;
end;

//------------------------------------------------------------------------------
//
procedure TIonizer.ChangePort(nPort: Integer);
var
  sTemp: string;
begin
  Common.MLog(DefPocb.SYS_LOG, '<Ionizer> ChangePort:' + IntToStr(nPort));
  if nPort <> 0 then begin
    try
      m_myComPort := nPort;
      sTemp := Format('COM%d', [nPort]);
      ComIonizer.Close;
      m_bConnected := False;
      ComIonizer.Name := Format('ComInonizer%d', [nPort]);
      ComIonizer.PortNum := nPort;
      ComIonizer.Parity := paNone;
      ComIonizer.Databits := db8;
      ComIonizer.BaudRate := br9600;
      ComIonizer.StopBits := sb1;
      ComIonizer.EventChars.EofChar := DefSerialComm.CR; // Enter 가 오면 Event 발생하도록..
      ComIonizer.OnRxChar := ReadVaCom;
      ComIonizer.Open;
      SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION, 1, sTemp);   // 0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG
      m_bConnected := True;
      m_bStatusOK := True;
      //
      if ComIonizer.Active then begin
        SendMsg(DefIonizer.ION_CMD_RUN, 1{nBlowerAddress}); //2019-09-03
      end;
    except
      SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION, 0, sTemp);   // 0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG
      m_bConnected := False;
      m_bStatusOK := False;
      m_sStatusMsg := '';  //2021-05-26
    end;
    tmIonAliveCheck.Enabled := True;
  end
  else begin
    m_bConnected := False;
    m_bStatusOK := False;
    tmIonAliveCheck.Enabled := False;
    if ComIonizer is TVaComm then begin
      ComIonizer.Close;
    end;
    SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION, 2, 'NONE');  // 0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG
  end;
  m_nTimeoutCnt := 0;
  m_nStatusNgCnt := 0;
end;

procedure TIonizer.OnTimeIonAliveCheck(Sender: TObject);
begin
  //CodeSite.Send('OnTimeIonAliveCheck:Ch'+IntToStr(m_nIdx+1));
  if not ComIonizer.Active then begin
    ChangePort(m_myComPort);
  end;
  //
  if (not Common.TestModelInfo2[m_nJig].UseIonOnOff) or (Logic[m_nJig].m_InsStatus = IsStop) then begin  //2022-01-02 skip if On Inspection
    SendMsg(DefIonizer.ION_CMD_DATAREQ, 1{nBlowerAddress});
    tmIonWaitAck.Enabled := True;
  end;
end;

procedure TIonizer.OnTimeIonWaitAck(Sender: TObject);
var
  sTemp: string;
begin
  //CodeSite.Send('OnTimeIonWaitAck:Ch'+IntToStr(m_nIdx+1));
  {$IFDEF SIMULATOR_ION}
  if (m_nTimeoutCnt = 1) and (SimIonCmdTX = ION_CMD_DATAREQ) then begin
    ReadVaCom(nil, 0); //call
    Exit;
  end;
  {$ENDIF}

  if m_nTimeoutCnt > 5 then begin
    m_nTimeoutCnt := 10;
    if m_bConnected then begin
      m_bConnected := False;
      sTemp := Format('COM%d', [m_myComPort]);
      SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION, 0, sTemp); // 0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG
    end;
    m_bConnected := False;
  end;
  Inc(m_nTimeoutCnt);
end;

procedure TIonizer.ReadVaCom(Sender: TObject; Count: Integer);
var
  sData, sTemp: String;
  sList: TStringList;
  sIonStatus: String;
  bDataRxOk: Boolean;
begin
  tmIonWaitAck.Enabled := False;
  if not m_bConnected then begin
    SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION, 1, '');  // 0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG
    m_bConnected := True;
    m_nTimeoutCnt := 0;
    m_bStatusOK := True;
    m_nStatusNgCnt := 0;
    m_sStatusMsg := '';  //2021-05-26
  end;
  //
  sIonStatus := '';
  bDataRxOk := False;
  {$IFDEF SIMULATOR_ION}
  sData := SimIonGetRxData(SimIonCmdTX);
  SimIonCmdTX := '';
  if sData = '' then
    Exit;
  {$ELSE}
  sData := ComIonizer.ReadText;
  {$ENDIF}
  //CodeSite.Send(sData);  //DEBUG
  try
    sList := TStringList.Create;
    try
      {$IFDEF SIMULATOR_ION}
      ExtractStrings([',', '*'], [], PChar(sData), sList);
      {$ELSE}
      ExtractStrings([',', '*'], [], PWideChar(sData), sList);
      {$ENDIF}

      if sList.Count >= 10 then begin

        FIsRunning := True;

        // Alarm State
        //  - SBL-12A : 0(Normal),1(Alarm)
        //  - SBL-20W : 0(Normal),1(HW), 2(Fan))


        if sList[8] <> '0' then begin
          if sIonStatus <> '' then
            sIonStatus := sIonStatus + ',';
          if (m_sIonProductType <> ION_CMD_TYPE_SBL20W) then
            sIonStatus := sIonStatus + 'Alarm'
          else begin
            if sList[8] = '1' then
              sIonStatus := sIonStatus + TernaryOp((Common.SystemInfo.IonizerCntPerCH > 1), 'HW', 'Alarm(HW)')
            else if sList[8] = '2' then
              sIonStatus := sIonStatus + TernaryOp((Common.SystemInfo.IonizerCntPerCH > 1), 'Fan', 'Alarm(Fan)')
            else
              sIonStatus := sIonStatus + 'Alarm';
          end;
          FIsRunning := False;
        end;

        //Run/Stop State: 0(Stop),1(Run)
        if sList[9] <> '1' then begin
          if (not Common.TestModelInfo2[m_nJig].UseIonOnOff) and (not m_bManualOff) then begin //2019-09-26 Ionizer On/Off
            if sIonStatus <> '' then
              sIonStatus := sIonStatus + ',';
            sIonStatus := sIonStatus + 'Stop'
          end;
          FIsRunning := False;
        end;

        //
        if FIsRunning then begin
          // Fan Speed
          //  - SBL-12A : Reserved
          //  - SBL-20W : 0(Stop),FanSpeed(1~4)
          if (m_sIonProductType = ION_CMD_TYPE_SBL20W) then begin
            if sList[6] <> '0' then
              sIonStatus := TernaryOp((Common.SystemInfo.IonizerCntPerCH > 1), sList[6], 'Speed(' + sList[6] + ')')
            else begin
              sIonStatus := TernaryOp((Common.SystemInfo.IonizerCntPerCH > 1), 'STOP', 'Speed(STOP)');
              FIsRunning := False;
            end;
          end;
          // Tip Clean State: 0(Normal),1(TipCleaning)
          //if sList[7] <> '0' then begin
          //end;
        end;
      end
      else begin
            // $BB,1,RUN*78$BB,1,260,50 RUN
          // $BB,1,260,500,08,0,1*39  STATUS
      // $BB,1,STP*66$BB,1,260,50 STOP
        if m_sIonProductType = ION_CMD_TYPE_SIB5S then begin
          FIsRunning := True;
          sTemp := UpperCase(sList[0]);
          if sTemp = '$BB' then begin
            sTemp := UpperCase(sList[2]);
            if (sTemp = 'RUN') or (sTemp = 'STP') then begin

            end
            else begin
              sTemp := UpperCase(sList[5]);
                // 0: Normal, 1: HV, 2: Arc, 3: Tip Clean
              if sIonStatus <> '' then
                sIonStatus := sIonStatus + ',';
              if sTemp <> '0' then begin
                if sTemp = '1' then
                  sIonStatus := sIonStatus + 'Alarm(HV)';
                if sTemp = '2' then
                  sIonStatus := sIonStatus + 'Alarm(Arc)';
                if sTemp = '3' then
                  sIonStatus := sIonStatus + 'Alarm(Tip Clean)';
                FIsRunning := False;
              end
              else begin
                sTemp := UpperCase(sList[6]);  //Run/Stop State: 0(Stop),1(Run)
                if sTemp <> '1' then begin
                  if (not Common.TestModelInfo2[m_nJig].UseIonOnOff) and (not m_bManualOff) then begin
                    if sIonStatus <> '' then
                      sIonStatus := sIonStatus + ',';
                    sIonStatus := sIonStatus + 'Stop'
                  end;
                  FIsRunning := False;
                end;
              end;
            end;
          end
          else begin
            sIonStatus := sIonStatus + 'Alarm';
          end;
        end;
      end;

      bDataRxOk := True;
    except
    end;
  finally
    sList.Free;
  end;

  //
  if bDataRxOk and FIsRunning then begin
    m_nStatusNgCnt := 0;
    if not m_bStatusOK then begin
      SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION, 1, sIonStatus);   // 0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG
    end
    else begin
      if m_sStatusMsg <> sIonStatus then
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION, 4, sIonStatus); // 0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG, 4:INFO
    end;
    m_bStatusOK := True;
    m_sStatusMsg := sIonStatus;
  end
  else if (not m_bManualOff) then begin //2022-01-03 (add if)
    if m_nStatusNgCnt > 1 then begin
      m_nStatusNgCnt := 10;
      if m_bStatusOK then begin
        SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION, 3, sIonStatus); // 0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG
      end;
      m_bStatusOK := False;
      m_sStatusMsg := sIonStatus;
    end;
    Inc(m_nStatusNgCnt);
  end;
end;

procedure TIonizer.SendMsg(sCmd: string; nBlowerAddr: Integer);
var
  sSendData: AnsiString;
  TxBuf: array of AnsiChar;
  sProductModel, sBlowerAddr, sCheckSum: string;
  btCheckSum: Byte;
  i: Integer;
begin
  if (nBlowerAddr < DefIonizer.ION_BLOWER_ADDR_MIN) or (nBlowerAddr > DefIonizer.ION_BLOWER_ADDR_MAX) then
    Exit;
  if m_sIonProductType = '' then
    Exit;
  //
  sSendData := AnsiString(m_sIonProductType);                          // e.g., C2
  sSendData := sSendData + AnsiString(',') + AnsiString(sCmd);         // e.g., C2,REQ
  sBlowerAddr := Format('%d', [nBlowerAddr]);
  sSendData := sSendData + AnsiString(',') + AnsiString(sBlowerAddr);  // e.g., C2,REQ,1
  SetLength(TxBuf, Length(sSendData));
  CopyMemory(@TxBuf[0], @sSendData[1], Length(sSendData));
  //
  for i := 0 to Length(sSendData) - 1 do begin
    if i = 0 then
      btCheckSum := Byte(TxBuf[i])
    else
      btCheckSum := btCheckSum xor Byte(TxBuf[i]);
  end;
  sCheckSum := Format('%0.2x', [btCheckSum]);
  sSendData := AnsiString('$') + sSendData + AnsiString('*') + AnsiString(sCheckSum) + (DefSerialComm.CR) + (DefSerialComm.LF);
  if ComIonizer.Active then begin
    try
      ComIonizer.WriteText((sSendData));
      {$IFDEF SIMULATOR_ION}
      SimIonSetRxData(sCmd);
      {$ENDIF}
    except
      //Common.MLog(DefPocb.SYS_LOG,'<Ionizer> CH'+IntToStr(m_nIdx+1)+': Send Fail');
    end;
  end;
end;

procedure TIonizer.SetIonizer(bValue: Boolean);
var
  sCmd: string;
begin
  m_bManualOff := not bValue;

  sCmd := UserUtils.TernaryOp(bValue, DefIonizer.ION_CMD_RUN, DefIonizer.ION_CMD_STOP);
  SendMsg(sCmd, 1);
end;

{$IFDEF SIMULATOR_ION}
function TIonizer.SimIonGetRxData(sCmd: string): string;
var
  sSimIonRx: string;
begin
  sSimIonRx := '';
  if sCmd = ION_CMD_DATAREQ then begin
    sSimIonRx := '$' + m_sIonProductType + ',' + '1'{BlowerAddr};
    sSimIonRx := sSimIonRx + ',0,0,0,0';
    sSimIonRx := sSimIonRx + ',' + IntToStr(SimIonFanSpeed); //SBL20W
    sSimIonRx := sSimIonRx + ',0'{TipCleanStatus} + ',' + '0'{AlarmStatus:0=Normal,1=HW,2=Fan};
    sSimIonRx := sSimIonRx + ',' + TernaryOp(SimIonFanSpeed = 0, '0'{Stop}, '1'{Run});
    sSimIonRx := sSimIonRx + '*' + 'FF'{Checksum}; // + (DefSerialComm.CR)+ (DefSerialComm.LF);
  //else if sCmd = ION_CMD_RUN      then //No Response
  //else if sCmd = ION_CMD_STOP     then //No Response
  //else if sCmd = IOM_CMD_TIPCLEAN then //No Response
  end;
  Result := sSimIonRx;
end;

procedure TIonizer.SimIonSetRxData(sCmd: string);
begin
  if sCmd = ION_CMD_DATAREQ then begin
    SimIonCmdTX := sCmd;
  end
  else if sCmd = ION_CMD_RUN then begin
    SimIonFanSpeed := 4;
    SimIonCmdTX := '';
  end
  else if sCmd = ION_CMD_STOP then begin
    SimIonFanSpeed := 0;
    SimIonCmdTX := '';
  end
  else if sCmd = IOM_CMD_TIPCLEAN then begin
    SimIonCmdTX := '';
  end;
end;
{$ENDIF}

//------------------------------------------------------------------------------
//

procedure TIonizer.SendMainGuiDisplay(nGuiMode, nConnect: Integer; sMsg: string);
var
  ccd: TCopyDataStruct;
  MainGuiIonData: RMainGuiIonData;
begin
  MainGuiIonData.MsgType := DefPocb.MSG_TYPE_IONIZER;
  MainGuiIonData.Channel := m_nJig;
  MainGuiIonData.IonChIdx := m_nIonChIdx;
  MainGuiIonData.Mode := nGuiMode;
  MainGuiIonData.Param := nConnect; // MSG_MODE_DISPLAY_CONNECTION (0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG)
  MainGuiIonData.Msg := sMsg;
  ccd.dwData := 0;
  ccd.cbData := SizeOf(MainGuiIonData);
  ccd.lpData := @MainGuiIonData;
  SendMessage(m_hMain, WM_COPYDATA, 0, LongInt(@ccd));
end;

procedure TIonizer.SendTestGuiDisplay(nGuiMode, nConnect: Integer; sMsg: string);  //NOT-USED
var
  ccd: TCopyDataStruct;
  TestGuiIonData: RTestGuiIonData;
begin
  TestGuiIonData.MsgType := DefPocb.MSG_TYPE_IONIZER;
  TestGuiIonData.Channel := m_nJig;
  TestGuiIonData.IonChIdx := m_nIonChIdx;
  TestGuiIonData.Mode := nGuiMode;
  TestGuiIonData.Param := nConnect; // 0:Disconnected, 1:Connected(+StatusOK), 2:NONE, 3:StatusNG
  TestGuiIonData.Msg := sMsg;
  ccd.dwData := 0;
  ccd.cbData := SizeOf(TestGuiIonData);
  ccd.lpData := @TestGuiIonData;
  SendMessage(m_hTest, WM_COPYDATA, 0, LongInt(@ccd));
end;

end.

