unit EfuCtl;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, Vcl.ExtCtrls, System.Classes, VaComm, Vcl.Dialogs, IdGlobal, CodeSiteLogging,
  DefSerialComm, DefEfu, DefPocb, CommonClass;

type

{$IFDEF NOT_USED}
  PMainGuiEfuData  = ^RMainGuiEfuData;
  RMainGuiEfuData = packed record
    MsgType : Integer;
    ICU_ID  : Integer;
    Mode    : Integer;	// MSG_MODE_DISPLAY_STATUS
    Param   : Integer;	// 0: Disconnect, 1: Connect , 2:Status
		Param1  : Integer;  // Alarm Byte (Valid if 2:Status)
    Msg     : string;
  end;
{$ENDIF}

	REfuIcuStatus = record
		TX_SV	   : Integer;	// ICU에 요청한 Setting Value (SV:0~140 --> SV_RPM:0~1400)
		RX_PV	   : Integer;	// ICU의 Process Value (현재 구동 속도) (PV:0~140 --> PV_RPM:0~1400)
		RX_SV    : Integer; // ICU의 Setting Value (지정 속도)      (SV:0~140 --> SV_RPM:0~1400)
		RX_Alarm : Byte;    // ICU의 ALARM (알람 데이터)
	end;

  InEfuEvnt = procedure(sGetData: String) of object;
  InEfuConn = procedure(nConnected: Integer; sMsg: string; nIcuId: Integer = -1) of object;

  TSerialEFU = class(TObject)
		ComEfu : TVaComm;
  private
    m_hMain   : THandle;
    m_hTest   : THandle;
    m_myComPort : Integer;
    tmrEfuAliveCheck, tmrEfuWaitAck : TTimer;
    FReadyEfu : Integer;
    FOnRevEfuConn: InEfuConn;
    FOnRevEfuData: InEfuEvnt;
    procedure SetOnRevEfuConn(const Value: InEfuConn);
    procedure SetOnRevEfuData(const Value: InEfuEvnt);
    procedure ReadVaCom(Sender: TObject; Count: Integer);
    procedure OnTimeEfuAliveCheck(Sender: TObject);
    procedure OnTimeEfuWaitAck(Sender: TObject);
  //procedure RX_EfuGetStatusAck(RxBuff: TIdBytes; nDataCnt: Integer);  //TBD:EFU? (nAckValue: 0xB9 = OK);  //TBD:EFU?
    procedure RX_EfuGetStatusAck(RxBuf: array of Byte; nDataCnt: Integer);  //TBD:EFU? (nAckValue: 0xB9 = OK);  //TBD:EFU?
	//procedure RX_EfuSetVelAck(RxBuff: TIdBytes; nDataCnt: Integer);  //TBD:EFU? (nAckValue: 0xB9 = OK)
		procedure RX_EfuSetVelAck(RxBuff:  array of Byte; nDataCnt: Integer);  //TBD:EFU? (nAckValue: 0xB9 = OK)
    procedure EfuGetAndUpdateIcuStatus(nIcuId,nRxPV,nRxALARM,nRxSV: Integer);
{$IFDEF NOT_USED}
	  procedure SendMainGuiDisplay(nGuiMode, nCh, nConnect: integer; nEfuAlarm: Integer = 0; sMsg: string = '');
{$ENDIF}
  public
    EFU_ICUID_START: Integer;
    EFU_ICUID_END  : Integer;
    m_bConnected   : Boolean; //LV32-BLDC Connection (False:Disconnected, True:Connected)
		m_IcuSt        : array [DefEfu.EFU_ICUID_MIN..DefEfu.EFU_ICUID_MAX] of REfuIcuStatus;
    m_nTimeoutCnt  : Integer;
    //
    m_bStatusOK    : Boolean;
    m_nStatusNgCnt : Integer;
		//
    constructor Create(hMain: HWND); virtual;
    destructor Destroy; override;
    property ReadyEfu : Integer read FReadyEfu write FReadyEfu;
    property OnRevEfuConn : InEfuConn read FOnRevEfuConn write SetOnRevEfuConn;
    property OnRevEfuData : InEfuEvnt read FOnRevEfuData write SetOnRevEfuData;
		procedure ChangePort(nPort: Integer);
		function SendEfuGetStatus: Boolean;
    function SendEfuSetRPM(nLv32Id, nStartIcu, nEndIcu: Integer; nRPM: Integer): Boolean;  //NOT-USED
  end;

var
  DongaEfu : TSerialEFU;

implementation

//******************************************************************************
// << EFU : LV32-BLDC Host Protocol (RS485 Communication) >> ...See, DefEfu.pas
//******************************************************************************

{ TSerialEFU }

//******************************************************************************
// procedure/function:
//	- 
//******************************************************************************

constructor TSerialEFU.Create(hMain: HWND);
var
  i : Integer;
begin
  FReadyEfu := 0;
  m_hMain := hMain;
  ComEfu  := TVaComm.Create(nil);
  //
  tmrEfuAliveCheck := TTimer.Create(nil);
  tmrEfuAliveCheck.Interval := DefEfu.EFU_ALIVECHECK_TIMESEC * 1000;  //10 sec
  tmrEfuAliveCheck.Enabled  := False;
  tmrEfuAliveCheck.OnTimer  := OnTimeEfuAliveCheck;
  //
  tmrEfuWaitAck := TTimer.Create(nil);
  tmrEfuWaitAck.Interval := DefEfu.EFU_STATUSWAIT_TIMESEC * 1000;  //2 sec
  tmrEfuWaitAck.Enabled  := False;
  tmrEfuWaitAck.OnTimer  := OnTimeEfuWaitAck;
  //
  m_bConnected := False;
  EFU_ICUID_START := DefEfu.EFU_ICUID_MIN;
  EFU_ICUID_END   := DefPocb.CH_CNT * Common.SystemInfo.EfuIcuCntPerCH;

  for i := EFU_ICUID_START to EFU_ICUID_END do begin
		m_IcuSt[i].TX_SV	  := 100; // initial value  // ICU에 요청한 Setting Value (SV:0~140 --> SV_RPM:0~1400)
		m_IcuSt[i].RX_PV	  := 100; // initial value  // ICU의 Process Value (현재 구동 속도) (PV:0~140 --> PV_RPM:0~1400)
		m_IcuSt[i].RX_SV	  := 100; // initial value  // ICU의 Setting Value (지정 속도)      (SV:0~140 --> SV_RPM:0~1400)
		m_IcuSt[i].RX_Alarm := $80; // initial value  // ICU의 ALARM (알람 데이터)
  end;
  m_nTimeoutCnt := 0;
end;

destructor TSerialEFU.Destroy;
begin
  if tmrEfuAliveCheck <> nil then begin
    tmrEfuAliveCheck.Enabled := False;
    tmrEfuAliveCheck.Free;
    tmrEfuAliveCheck := nil;
  end;
  if tmrEfuWaitAck <> nil then begin
    tmrEfuWaitAck.Enabled := False;
    tmrEfuWaitAck.Free;
    tmrEfuWaitAck := nil;
  end;
  if ComEfu <> nil then begin
    ComEfu.Close;
    ComEfu.Free;
    ComEfu := nil;
  end;
  inherited;
end;

procedure TSerialEFU.ChangePort(nPort: Integer);
var
  sTemp : string;
begin
  Common.MLog(DefPocb.SYS_LOG,'<EFU> ChangePort:'+IntToStr(nPort));
  if nPort <> 0 then begin
    try
      m_myComPort := nPort;
      sTemp := Format('COM%d',[nPort]);
      ComEfu.Close;
      m_bConnected := False;
      ComEfu.Name      := Format('ComEfu%d',[nPort]);
      ComEfu.PortNum   := nPort;
      ComEfu.Parity    := paNone;
      ComEfu.Databits  := db8;
      ComEfu.BaudRate  := br9600; //EFU: 9600bps
      ComEfu.StopBits  := sb1;
      ComEfu.EventChars.EofChar := DefSerialComm.ETX; //TBD: STX?
      ComEfu.OnRxChar  := ReadVaCom;
      ComEfu.Open;
      m_bConnected := True;
      m_bStatusOK  := True;
      OnRevEfuConn(1{Connected},Format('COM%d',[nPort]),-1);
    //SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,-1{nCh},1{nConnect},0{TBD?:nEfuAlarm},sTemp);
    except
      m_bConnected  := False;
      m_bStatusOK   := False;
      OnRevEfuConn(0{Disonnected},Format('COM%d',[nPort]),-1);
    //SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,-1{nCh},0{nConnect},0{TBD?:nEfuAlarm},sTemp);
    end;
    tmrEfuAliveCheck.Enabled := True;
  end
  else begin
    m_bConnected  := False;
    m_bStatusOK   := False;
    tmrEfuAliveCheck.Enabled := False;
    if ComEfu is TVaComm then begin
      ComEfu.Close;
    end;
    OnRevEfuConn(2{NONE},'NONE',-1);
  //SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,-1{nCh},2{nConnect},0{TBD?:nEfuAlarm},'NONE');
  end;
  m_nTimeoutCnt := 0;
  m_nStatusNgCnt:= 0;
end;

procedure TSerialEFU.OnTimeEfuAliveCheck(Sender: TObject);
begin
  //CodeSite.Send('OnTimeEfuAliveCheck');
  if not ComEfu.Active then begin
    ChangePort(m_myComPort);
  end;
  SendEfuGetStatus;
  tmrEfuWaitAck.Enabled := True;
end;

procedure TSerialEFU.OnTimeEfuWaitAck(Sender: TObject);
begin
  //CodeSite.Send('OnTimeEfuWaitAck');
  if m_nTimeoutCnt > 1 then begin
    m_nTimeoutCnt := 10;
    if m_bConnected then begin
      m_bConnected := False;
      OnRevEfuConn(0{Disonnected},'',-1);
    //SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,-1{nCh},0{nConnect},0{TBD?:nEfuAlarm},'');
    end;
    m_bConnected := False;
  end;
  Inc(m_nTimeoutCnt);
end;

procedure TSerialEFU.SetOnRevEfuConn(const Value: InEfuConn);
begin
	FOnRevEfuConn := Value;
end;

procedure TSerialEFU.SetOnRevEfuData(const Value: InEfuEvnt);
begin
	FOnRevEfuData := Value;
end;

//******************************************************************************
// procedure/function:
//		- function TSerialEFU.SendEfuGetStatus: Boolean;
//		- function TSerialEFU.SendEfuSetRPM(nStartIcu, nEndIcu: Integer; nRPM: Integer): Boolean;
//******************************************************************************

function TSerialEFU.SendEfuGetStatus: Boolean;
var
	nLv32Id, nStartIcu, nEndIcu : Integer;
  sDebug     : String;
	bRet       : Boolean;
  TxBuf      : array[0..255] of byte;
	btCheckSum : byte;
  i, nWriteCnt : integer;
begin
  nLv32Id   := DefEfu.EFU_LV32ID;
	nStartIcu := EFU_ICUID_START;
	nEndIcu   := EFU_ICUID_END;
  Result := False;
	//
	sDebug := '<EFU> SendEfuGetStatus';
  if not ComEfu.Active then begin
		//CodeSite.Send(sDebug+' ...Error(Disconnected)');
		Exit(Result);
	end;
	if (nStartIcu < DefEfu.EFU_ICUID_MIN) or (nStartIcu > DefEfu.EFU_ICUID_MAX) then begin
  	//CodeSite.Send(sDebug+' ...Error(StartICU)');
		Exit(Result);
	end;
	if (nEndIcu < DefEfu.EFU_ICUID_MIN) or (nStartIcu > DefEfu.EFU_ICUID_MAX) then begin
  	//CodeSite.Send(sDebug+' ...Error(EndICU)');
		Exit(Result);
	end;
	if (nStartIcu > nEndIcu) then begin
  	//CodeSite.Send(sDebug+' ...Error(StartIcu>EndICU)');
		Exit(Result);
	end;
	//
	TxBuf[0] := Byte(DefSerialComm.STX);            // 0: STX
	TxBuf[1] := Byte(DefEfu.EFU_MODE1_BLOCK_READ);  // 1: MODE1 (0x8A)
	TxBuf[2] := Byte(DefEfu.EFU_MODE2_READ_STATUS); // 2: MODE2 (0x87)
	TxBuf[3] := Byte(nLv32Id or $80);               // 3: LV32_ID (1~32) | 0x80
	TxBuf[4] := Byte(DefEfu.EFU_DPUID);             // 4: DPU_ID (0x9F)
	TxBuf[5] := Byte(nStartIcu or $80);             // 5: StartICU_ID (ICU_ID | 0x80)
	TxBuf[6] := Byte(nEndIcu or $80);               // 6: EndICU_ID   (ICU_ID | 0x80)
	btCheckSum := 0;
  for i := 1 to 6 do begin
    btCheckSum := btCheckSum + Byte(TxBuf[i]);
  end;
	TxBuf[7] := Byte(btCheckSum and $FF);           // 7: CheckSum: 1 Byte
	TxBuf[8] := Byte(DefSerialComm.ETX);            // 8: ETX
  //
	if (ComEfu <> nil) then begin
    try
 		  //CodeSite.Send('<EFU> TX_EfuGetStatus');
  	  nWriteCnt := ComEfu.WriteBuf(TxBuf,9);
   		Result := True;
    except
      sDebug := '<EFU> TX_EfuGetStatus(WriteBuf) Fail';
 		  //CodeSite.Send(sDebug);
    end
	end;
end;

function TSerialEFU.SendEfuSetRPM(nLv32Id, nStartIcu, nEndIcu: Integer; nRPM: Integer): Boolean;   //NOT-USED
var
  sDebug     : String;
	bRet       : Boolean;
  TxBuf      : array[0..255] of byte;
	btCheckSum : byte;
  i, nWriteCnt : integer;
begin
  nLv32Id   := DefEfu.EFU_LV32ID;
	nStartIcu := EFU_ICUID_START;
	nEndIcu   := EFU_ICUID_END;
  Result := False;
  //
	sDebug := '<EFU> SendEfuSetRPM('+IntToStr(nStartIcu)+'~'+IntToStr(nEndIcu)+',RPM:'+IntToStr(nRPM)+')';
  if not ComEfu.Active then begin
		//CodeSite.Send(sDebug+'...Error(Disconnected)');
		Exit(False);
	end;
	if (nStartIcu < DefEfu.EFU_ICUID_MIN) or (nStartIcu > DefEfu.EFU_ICUID_MAX) then begin
		//CodeSite.Send(sDebug+'...Error(StartICU)');
		Exit(False);
	end;
	if (nEndIcu < DefEfu.EFU_ICUID_MIN) or (nStartIcu > DefEfu.EFU_ICUID_MAX) then begin
    //CodeSite.Send(sDebug+'...Error(EndICU)');
		Exit(False);
	end;
	if (nStartIcu > nEndIcu) then begin
    //CodeSite.Send(sDebug+'...Error(StartIcu>EndICU)');
		Exit(False);
	end;
	if (nRPM < 0) or (nRPM > DefEfu.EFU_RPM_MAX) then begin
    //CodeSite.Send(sDebug+'...Error(RPM>MaxRPM)');
		Exit(False);
	end;
	//
	TxBuf[0] := Byte(DefSerialComm.STX);						// 0: STX
	TxBuf[1] := Byte(DefEfu.EFU_MODE1_BLOCK_WRITE);	// 1: MODE1 (0x89)
	TxBuf[2] := Byte(DefEfu.EFU_MODE2_WRITE_SV);	  // 2: MODE2 (0x84)
	TxBuf[3] := Byte(nLv32Id or $80);						    // 3: LV32_ID (1~32) | 0x80
	TxBuf[4] := Byte(DefEfu.EFU_DPUID);							// 4: DPU_ID (0x9F)
	TxBuf[5] := Byte(nStartICU or $80);						  // 5: StartICU_ID (ICU_ID | 0x80)
	TxBuf[6] := Byte(nEndICU or $80);						    // 6: EndICU_ID   (ICU_ID | 0x80)
	TxBuf[7] := Byte(nRPM div 10);                  // 7: RPM(0~1400) -> SV (0~140)
	btCheckSum := 0;
  for i := 1 to 7 do begin
    btCheckSum := btCheckSum + byte(TxBuf[i]);
  end;
	TxBuf[8] := Byte(btCheckSum and $FF);           // 8: CheckSum: 1 Byte
	TxBuf[9] := Byte(DefSerialComm.ETX);            // 9: ETX
	//
	sDebug := '<EFU> TX:SetRPM('+IntToStr(nStartIcu)+'~'+IntToStr(nEndIcu)+',RPM:'+IntToStr(nRPM)+')';
	if (ComEfu <> nil) then begin
    try
 		  //CodeSite.Send(sDebug);
  	  nWriteCnt := ComEfu.WriteBuf(TxBuf,10);
   		Result := True;
    except
      sDebug := sDebug + '...TX Fail';
 		  //CodeSite.Send(sDebug);
      //Common.MLog(DefPocb.SYS_LOG,sDebug);
    end    
	end;
end;

//******************************************************************************
// procedure/function:
//		- procedure TSeirialEfu.RX_EfuGetStatusAck;  //TBD:EFU? 
//		- function TSerialEFU.TX_EfuSetRPM(nStartIcu, nEndIcu: Integer; nRPM: Integer): Boolean;
//		- procedure TSerialEFU.RX_EfuSetVelAck(nStartIcu, nEndIcu: Integer; nAckValue: Integer);  //TBD:EFU? (nAckValue: 0xB9 = OK)
//******************************************************************************

procedure TSerialEFU.ReadVaCom(Sender: TObject; Count: Integer);
var
  RxBuf : array[0..255] of Byte;
  sData : AnsiString;
  i, nDataCnt, nExpectedDataCnt : Integer;
  sDebug : String;
begin
  tmrEfuWaitAck.Enabled := False;
//CodeSite.Send('EFU.ReadVaCom:Count('+IntToStr(Count)+')');
  //
  sData := AnsiString(ComEfu.ReadText);
  nDataCnt := Length(sData);
  nExpectedDataCnt := (EFU_ICUID_END-EFU_ICUID_START+1)*4 + 7;
  for i := 0 to (nDataCnt-1) do begin
    RxBuf[i] := Byte(sData[i+2]); //from EFU_MODE1_BLOCK_READ (ignore STX)
  end;

  if nDataCnt <> nExpectedDataCnt then begin
    Common.MLog(DefPocb.SYS_LOG,'EFU.ReadVaCom:ReadText:Count('+IntToStr(nDataCnt)+') != ExpectedDataCnt('+IntToStr(nExpectedDataCnt)+')');
    Exit;
  end;

  //
  sDebug := '<EFU> RX('+IntToStr(nDataCnt)+') ';
  if (RxBuf[0] = DefEfu.EFU_MODE1_BLOCK_READ) and (RxBuf[1] = DefEfu.EFU_MODE2_READ_STATUS) then begin
    if not m_bConnected then begin
      m_bConnected  := True;
      m_nTimeoutCnt := 0;
      OnRevEfuConn(1{Connected},'',-1);
      //
      for i := EFU_ICUID_START to EFU_ICUID_END do begin
        m_IcuSt[i].RX_Alarm := $00; //for initial status (Comm Alarm)
      end;
    end;
    RX_EfuGetStatusAck(RxBuf,nDataCnt);
  end
{$IFDEF NOT_USED}
  else if (RxBuf[0] = DefEfu.EFU_MODE1_BLOCK_WRITE) and (RxBuf[1] = DefEfu.EFU_MODE2_WRITE_SV) then begin
    RX_EfuSetVelAck(RxBuf,nDataCnt);
  end
{$ENDIF}
  else begin
    if m_nTimeoutCnt > 1 then begin
      m_nTimeoutCnt := 0;
      if m_bConnected then begin
        m_bConnected  := False;
        OnRevEfuConn(0{Disonnected},'',-1);
      //SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_CONNECTION,0{nConnect},'');
      end;
    end
    else begin
      Inc(m_nTimeoutCnt);
    end;
  end;
end;

procedure TSerialEFU.RX_EfuGetStatusAck(RxBuf: array of byte; nDataCnt: Integer);
var
  nJig : Integer;
  nLv32Id, nIcuId : Integer;
  nRxPV,nRxALARM,nRxSV: Integer;
  i, idxIcu : Integer;
begin
  //CodeSite.Send('RX_EfuGetStatusAck');
//RxBuf[0]  //MODE1 = 0x8A
//RxBuf[1]  //MODE2 = 0x87
  nLv32Id  := RxBuf[2] and $3F;  //LV32_ID: (1~32)|0x80
//RxBuf[3]  //DPU_ID = 0x9F

  for i := EFU_ICUID_START to EFU_ICUID_END do begin
    idxIcu   := 4 + ((i-1) * 4);
    nIcuId   := RxBuf[idxIcu] and $7F;                         //ICU1~ICUx/ID: (1~32)|0x80
    nRxPV    := RxBuf[idxIcu+1];                               //ICU1~ICUx/PV
    nRxALARM := RxBuf[idxIcu+2] and DefEfu.EFU_ALARM_MASK_ALL; //ICU1~ICUx/ALARM
    nRxSV    := RxBuf[idxIcu+3];                               //ICU1~ICUx/SV
    EfuGetAndUpdateIcuStatus(nIcuId,nRxPV,nRxALARM,nRxSV);
  end;
end;

procedure TSerialEFU.RX_EfuSetVelAck(RxBuff: array of byte; nDataCnt: Integer);  //TBD:EFU? (nAckValue: 0xB9 = OK)
begin
	//TBD:EFU?
end;

procedure TSerialEFU.EfuGetAndUpdateIcuStatus(nIcuId,nRxPV,nRxALARM,nRxSV: Integer);
var
  nJig      : Integer;
  bChanged  : Boolean;
  sIcuAlarm : string;
begin
  if (nIcuId < EFU_ICUID_START) or (nIcuId > EFU_ICUID_END) then begin
    Exit;
  end;

  if (m_IcuSt[nIcuId].RX_Alarm <> nRxALARM) or (m_IcuSt[nIcuId].RX_PV <> nRxPV) then begin
    bChanged := True;
  end;
  //
  m_IcuSt[nIcuId].RX_PV    := nRxPV;
  m_IcuSt[nIcuId].RX_Alarm := nRxALARM;
  m_IcuSt[nIcuId].RX_SV    := nRxSV;
  //
  if bChanged then begin
    sIcuAlarm := '';
    if (nRxALARM and DefEfu.EFU_ALARM_MASK_COMM_NORMAL) <> 1 then  //bit7(Comm): 1=Normal,0:Alarm
      sIcuAlarm := 'Comm';
    if (nRxALARM and DefEfu.EFU_ALARM_MASK_MOTOR) <> 0 then begin //bit6(Motor): 1=Alarm,0:Normal
      if sIcuAlarm <> '' then sIcuAlarm := sIcuAlarm + ',';
      sIcuAlarm := 'Motor';
    end;
    if (nRxALARM and DefEfu.EFU_ALARM_MASK_OVER_CURRENT) <> 0 then begin //bit5(OverCurrent): 1=Alarm,0:Normal
      if sIcuAlarm <> '' then sIcuAlarm := sIcuAlarm + ',';
      sIcuAlarm := sIcuAlarm + 'OverCurr';
    end;
    if (nRxALARM and DefEfu.EFU_ALARM_MASK_POWER) <> 0 then begin //bit1(PowerOff): 1=Alarm,0:Normal
      if sIcuAlarm <> '' then sIcuAlarm := sIcuAlarm + ',';
      sIcuAlarm := sIcuAlarm + 'PwrOff'
    end;
    OnRevEfuConn(3{IcuStatus},sIcuAlarm,nIcuId);
  end;
end;

//******************************************************************************
// procedure/function:
//		- 
//******************************************************************************
{$IFDEF NOT_USED}
procedure TSerialEFU.SendMainGuiDisplay(nGuiMode, nIcuId, nConnect: integer; nEfuAlarm: Integer = 0; sMsg: string = '');
var
  ccd : TCopyDataStruct;
  MainGuiEfuData : RMainGuiEfuData;
begin
  MainGuiEfuData.MsgType := DefPocb.MSG_TYPE_EFU;
  MainGuiEfuData.ICU_ID  := nIcuId;
  MainGuiEfuData.Mode    := nGuiMode;		 // MSG_MODE_DISPLAY_CONNECTION
  MainGuiEfuData.Param   := nConnect;    // 0: Disconnect, 1: Connect , 2:Status
  MainGuiEfuData.Param1  := nEfuAlarm;   // Alarm Byte Value (valid if 2:Status)
  MainGuiEfuData.Msg     := sMsg;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(MainGuiEfuData);
  ccd.lpData      := @MainGuiEfuData;
  SendMessage(m_hMain,WM_COPYDATA,0, LongInt(@ccd));
end;
{$ENDIF}

end.
