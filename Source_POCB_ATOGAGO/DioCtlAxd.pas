unit DioCtlAxd;

interface
{$I Common.inc}

uses
  Winapi.Windows, System.SysUtils,  System.Classes, Vcl.ExtCtrls,
{$IFDEF USE_DIO_AXD}
  AXL, AXHS, AXD, // 3rd-party Classes
{$ENDIF}
//{$IFDEF DEBUG}
  CodeSiteLogging,
//{$ENDIF}
  DefPocb, DefDio, DefMotion, MotionCtl, CommonClass;

//const

type

  TDioAxd = class(TObject)
    private
			m_hMain       		: HWND;
    public
		//m_nMotionID   		: Integer;	// A2CH: Axt(0~3), Ezi(4~5)
		//m_nMotionDev   		: Integer;	// A2CH: Axt, EziMLPE
      m_nCh         		: Integer;	// A2CH: ch1~ch2
		//m_nAxisType   		: Integer;	// A2CH: Z-axis, Y-axis, Focus
		//m_nMotorNo   			: Integer;	// A2CH: nMotorNo(common) = nAxisNo(Axt) = nBdNo(Ezi)
		//m_nAxisNo    			: Integer;	// A2CH: 'nAxisNo' for Axt(0~3), 'nBdNo' for Ezi(0~1)
			m_nBdNo    				: Integer;	// A2CH: 'nAxisNo' for Axt(0~3), 'nBdNo' for Ezi(0~1)
      //
    //m_nModuleNoDioIn  : Integer;
    //m_nModuleNoDioOut : Integer;
      //
    //m_bAxdInitialized : Boolean;  //TBD?
    //m_bAxdDeviceOpened    : Boolean;  //TBD?
    //m_bAxdDioInitialized  : Boolean;  //TBD?
    //m_bAxdConnected   : Boolean;  //TBD?
      m_sErrLibApi      : string;
      //
      m_bConnected      : Boolean;
    //m_dwDioInNew	: array[0..DefDio.DIO_MODULE_MAX] of DWORD; //TBD?
    //m_dwDioInOld 	: array[0..DefDio.DIO_MODULE_MAX] of DWORD; //TBD?
    //m_dwDioOutNew	: array[0..DefDio.DIO_MODULE_MAX] of DWORD; //TBD?
    //m_dwDioOutOld : array[0..DefDio.DIO_MODULE_MAX] of DWORD; //TBD?

			//---------------------- procedure/function: TDioAxt: Create/Destroy/Init
			constructor Create(hMain: THandle); virtual;
      destructor Destroy; override;
			//---------------------- procedure/function: TDioAxt: Connect/Close/Init
			function Connect: Integer;
			//TBD? procedure Close;
			procedure CloseAxt;
			procedure InitDioSig;
			//---------------------- procedure/function: TDioAxt: Read/Write
      function ReadDioIn32(nDioInModuleOffset: Integer): DWORD;
      function ReadDioOut32(nDioOutModuleOffset: Integer): DWORD;
      function WriteDioOutBit(nSigBit64: Integer; bIsOn: Boolean): Boolean;
      function WriteDioOut32(nDioOutModuleOffset: Integer; dwSig32: DWORD): Boolean;
      function WriteDioOut64(dSig64: UInt64): Boolean;

  end;

implementation

//##############################################################################
//
{ TDioAxd }
//
//##############################################################################

//******************************************************************************
// procedure/function: TDioAxl: Create/Destroy/Init
//		- constructor TDioAxt.Create(hMain: THandle; nMotionID: Integer; nCh: Integer; nAxisType: Integer; nMotorNo: Integer)
//		- destructor TDioAxt.Destroy	//TBD?
//******************************************************************************

//------------------------------------------------------------------------------
constructor TDioAxd.Create(hMain: THandle);
begin
  m_hMain := hMain;
  //-------------------------- TBD?
//m_nModuleNoDioIn  := 0; //TBD:A2CH:DIO:AXT:ModuleNo? 0
//m_nModuleNoDioOut := 0; //TBD:A2CH:DIO:AXT:ModuleNo? 0? 1?
end;

//------------------------------------------------------------------------------
destructor TDioAxd.Destroy;
begin
  AxlClose;
  //
  m_bConnected := False;
  inherited;
end;

//******************************************************************************
// procedure/function: TDioAxl: Connect/Close/Init
//		- function TDioAxt.Connect: Integer;
//    -	//TBD? procedure TDioAxt.Close;
//		- procedure TDioAxt.CloseAxt;
//		- procedure TDioAxt.InitDioSig;
//******************************************************************************

//------------------------------------------------------------------------------
function TDioAxd.Connect: Integer;
var
	nErrCode 	: Integer;
  dwStatus, dwModuleID, dwRet : DWORD;
  lModuleCount, lBoardNo, lModulePos : LongInt;
  i : Integer;
  strData, sDebug : String;
begin
//CodeSite.Send('<DIO> TDioAxd.Connect');
	m_sErrLibApi := '';
{$IFDEF SIMULATOR_DIO}
  nErrCode := DefPocb.ERR_OK; //TBD:SIMULATOR:DIO?
{$ELSE}
	nErrCode := DefPocb.ERR_DIO_CONNECT;
  if (not AxlIsOpened) then begin  	// Library initialize.
		dwRet := AxlOpen(7{nIrqNo});
    if dwRet <> AXHS.AXT_RT_SUCCESS then begin
			m_sErrLibApi := '<DIO> AxlOpen(7): Error('+IntToStr(dwRet)+')'; CodeSite.Send(m_sErrLibApi);
			Exit(nErrCode);
    end;
  end;
  //
//m_bAxdDeviceOpened := True;
  dwRet := AxdInfoIsDIOModule(@dwStatus);
  sDebug := Format('<DIO> AxdInfoIsDIOModule: dwRet(%d), dwStatus(%d)',[dwRet,dwStatus]); CodeSite.Send(sDebug);
  if (dwRet <> AXT_RT_SUCCESS) then begin
  	m_sErrLibApi := '<DIO> AxdInfoIsDIOModule: Error('+IntToStr(dwRet)+')'; CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;
  if (dwStatus <> STATUS_EXIST) then begin
		m_sErrLibApi := '<DIO> AxdInfoIsDIOModule: Error(dwStatus <> STATUS_EXIST)'; CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;
  //
  dwRet := AxdInfoGetModuleCount(@lModuleCount);
  sDebug := Format('<DIO> AxdInfoGetModuleCount: dwRet(%d), moduleCount(%d)',[dwRet,lModuleCount]); CodeSite.Send(sDebug);
  if (dwRet <> AXT_RT_SUCCESS) then begin
		m_sErrLibApi := '<DIO> AxdInfoGetModuleCount: Error('+IntToStr(dwRet)+')'; CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;
  if (lModuleCount <= 0) then begin
		m_sErrLibApi := '<DIO> AxdInfoGetModuleCount: Error(ModuleCount='+IntToStr(dwRet)+')'; CodeSite.Send(m_sErrLibApi);
    Exit(nErrCode);
  end;
  //
  for i := 0 to Pred(lModuleCount) do begin
    dwRet := AxdiInterruptSetModuleEnable(i, 0{dwUse:0=NotUseInterrupt,1:UseInterrupt});  //TBD:DIO:AXD?
    if dwRet <> AXHS.AXT_RT_SUCCESS then begin
  		m_sErrLibApi := '<DIO> AxdiInterruptSetModuleEnable: ModuleNo('+IntToStr(i)+') Error('+IntToStr(dwRet)+')'; CodeSite.Send(m_sErrLibApi);
    end;
    if (AxdInfoGetModule(i, @lBoardNo, @lModulePos, @dwModuleID) = AXT_RT_SUCCESS) then begin
      sDebug := Format('<DIO> AxdInfoGetModule: ModuleNo(%d),BoardNo(%d),ModulePos,ModuleID(%0.2x)',[i,lBoardNo,lModulePos,dwModuleID]); CodeSite.Send(sDebug);
      case dwModuleID of
        AXT_SIO_DI32:         strData := Format('[BD No:%d - MD No:%d] SIO_DI32',[lBoardNo,i]);
        AXT_SIO_DO32P:        strData := Format('[BD No:%d - MD No:%d] SIO-DO32P',[lBoardNo,i]);
        AXT_SIO_DB32P:        strData := Format('[BD No:%d - MD No:%d] SIO-DB32P',[lBoardNo,i]);
        AXT_SIO_DO32T:        strData := Format('[BD No:%d - MD No:%d] SIO_DO32T',[lBoardNo,i]);
        AXT_SIO_DB32T:        strData := Format('[BD No:%d - MD No:%d] SIO-DB32T',[lBoardNo,i]);
        AXT_SIO_RDI32:        strData := Format('[BD No:%d - MD No:%d] SIO_RDI32',[lBoardNo,i]);
        AXT_SIO_RDO32:        strData := Format('[BD No:%d - MD No:%d] SIO_RDO32',[lBoardNo,i]);
        AXT_SIO_RSIMPLEIOMLII:strData := Format('[BD No:%d - MD No:%d] SIO_RSIMPLEIOMLII',[lBoardNo,i]);
        AXT_SIO_RDI16MLII:    strData := Format('[BD No:%d - MD No:%d] SIO_RDI16MLII',[lBoardNo,i]);
        AXT_SIO_RDO16AMLII:   strData := Format('[BD No:%d - MD No:%d] SIO_RDO16AMLII',[lBoardNo,i]);
        AXT_SIO_RDO16BMLII:   strData := Format('[BD No:%d - MD No:%d] SIO_RDO16BMLII',[lBoardNo,i]);
        AXT_SIO_RDB96MLII:    strData := Format('[BD No:%d - MD No:%d] SIO_RDB96MLII',[lBoardNo,i]);
      //AXT_SIO_RDO32RTEX:    strData := '[BD No:' + IntToStr(lBoardNo) + ' - MD No:' + IntToStr(i) + '] SIO_RDO32RTEX';
        AXT_SIO_RDI32RTEX:    strData := Format('[BD No:%d - MD No:%d] SIO_RDI32RTEX',[lBoardNo,i]);
        AXT_SIO_RDB32RTEX:    strData := Format('[BD No:%d - MD No:%d] SIO_RDO32',[lBoardNo,i]);
        AXT_SIO_DI32_P:       strData := Format('[BD No:%d - MD No:%d] SIO_DI32_P',[lBoardNo,i]);
        AXT_SIO_DO32T_P:      strData := Format('[BD No:%d - MD No:%d] SIO_DO32T_P',[lBoardNo,i]);
        AXT_SIO_RDB32T:       strData := Format('[BD No:%d - MD No:%d] SIO_RDB32T',[lBoardNo,i]);
        AXT_SIO_RDI32MLIII:   strData := Format('[BD No:%d - MD No:%d] SIO_RDI32MLIII',[lBoardNo,i]);
        AXT_SIO_RDI32MSMLIII: strData := Format('[BD No:%d - MD No:%d] SIO_RDI32MSMLIII',[lBoardNo,i]);
        AXT_SIO_RDI32PMLIII:  strData := Format('[BD No:%d - MD No:%d] SIO_RDI32PMLIII',[lBoardNo,i]);
        AXT_SIO_RDO32MLIII:   strData := Format('[BD No:%d - MD No:%d] SIO_RDO32MLIII',[lBoardNo,i]);
        AXT_SIO_RDO32AMSMLIII:strData := Format('[BD No:%d - MD No:%d] SIO_RDO32AMSMLIII',[lBoardNo,i]);
        AXT_SIO_RDO32PMLIII:  strData := Format('[BD No:%d - MD No:%d] SIO_RDO32PMLIII',[lBoardNo,i]);
        AXT_SIO_RDB32MLIII:   strData := Format('[BD No:%d - MD No:%d] SIO_RDB32MLIII',[lBoardNo,i]);
        AXT_SIO_RDB32PMLIII:  strData := Format('[BD No:%d - MD No:%d] SIO_RDB32PMLIII',[lBoardNo,i]);
        AXT_SIO_RDB128MLIIIAI:strData := Format('[BD No:%d - MD No:%d] SIO_RDB128MLIIIAI',[lBoardNo,i]);
        AXT_SIO_RDB128MLII:   strData := Format('[BD No:%d - MD No:%d] SIO_RDB128MLII',[lBoardNo,i]);
        AXT_SIO_UNDEFINEMLIII:strData := Format('[BD No:%d - MD No:%d] SIO_UNDEFINEMLIII',[lBoardNo,i]);
      end;
      CodeSite.Send(strData);
    end;
  end;
  //TBD:F2CH:DIO?  if sErrMsg <> '' then
  //TBD:F2CH:DIO?    SendMainGuiDisplay(DefCommon.MSG_MODE_DISPLAY_CONNECTION, 1,sErrMsg)
  //TBD:F2CH:DIO?  else
  //TBD:F2CH:DIO?    SendMainGuiDisplay(DefCommon.MSG_MODE_DISPLAY_CONNECTION, 0,'Connected');
 	m_bConnected := True;	//TBD?
  nErrCode := DefPocb.ERR_OK;
{$ENDIF}
  Result := nErrCode;
end;

//------------------------------------------------------------------------------
procedure TDioAxd.CloseAxt;
begin
  //-------------------------- 통합라이브러리 사용을 종료
{$IFDEF SIMULATOR_DIO}
  //TBD:SIMULATOR:DIO?
{$ELSE}
	AxlClose;  //통합라이브러리 사용을 종료
{$ENDIF}
  //--------------------------
//m_bAxlInitialized 			:= False;
//m_bAxlDeviceOpened 			:= False;
//m_bAxlDioInitialized 		:= False;
//m_bAxlConnected 				:= False;	//TBD?
  m_bConnected := False;
end;

//------------------------------------------------------------------------------
procedure TDioAxd.InitDioSig;
var
  nModuleNo : LongInt;
	nDioOutModuleOffset : Integer;
begin
  for nDioOutModuleOffset := 0 to Pred(DefDio.DIO_OUT_MODULE_CNT) do begin
		//-------------------------- 출력(Output) 포트로에 4바이트의 데이터를 써넣는다. 지정한 모듈의 더블워드 단위
{$IFNDEF SIMULATOR_DIO}
    nModuleNo := DefDio.DIO_MODULENO_DIO_OUT + nDioOutModuleOffset;
    if not WriteDioOut32(nModuleNo,0{dwValue}) then begin
        //TBD?
    end;
{$ENDIF}
  end;
	//------------TBD?
end;

//******************************************************************************
// procedure/function: TDioAxt: Read/Write
//		- function TDioAxt.ReadDioIn32(nModuleOffset: Integer): DWORD;
//		- function TDioAxt.ReadDioOut32(nModuleOffset: Integer): DWORD;
//		- function TDioAxt.WriteDioOutBit(nSig: Integer; bIsOn: Boolean): Boolean;
//		- function TDioAxt.WriteDioOut32(nModuleOffset: Integer; dwSig32: DWORD): Boolean;
//	  //CAxtDIO.DIOread_inport_bit(nModuleNo, 0{offset});
//		//CAxtDIO.DIOread_inport_byte(nModuleNo, 0{offset});
//	  //CAxtDIO.DIOread_inport_word(nModuleNo, 0{offset});
//******************************************************************************

//------------------------------------------------------------------------------
function TDioAxd.ReadDioIn32(nDioInModuleOffset: Integer): DWORD;
var
  dwRet, dwData : DWORD;
	nModuleNo : LongInt;
begin
	if (nDioInModuleOffset >= DefDio.DIO_IN_MODULE_CNT) then begin
		Exit(0);
   end;
	//-------------------------- 입력(Input) 포트로부터 4바이트의 데이터를 읽어들인다. 지정한 모듈의 더블워드 단위
	nModuleNo := DefDio.DIO_MODULENO_DIO_IN + nDioInModuleOffset;
{$IFDEF SIMULATOR_DIO}
  Result := 0; //TBD:SIMULATOR:DIO?
{$ELSE}
  dwData := 0;
  dwRet :=	AxdiReadInportDword(nModuleNo, 0, @dwData);
  if dwRet <> AXT_RT_SUCCESS then begin
    //m_sErrLibApi := '<DIO> ReadDioIn32: Error('+IntToStr(dwRet)+')'; CodeSite.Send(m_sErrLibApi);
    Result := 0; //TBD:DIO:READ_ERROR?
  end
  else begin
    //CodeSite.Send('ReadDioIn32:'+IntToStr(nModuleNo)+':'+Format('%08x',[dwData])); //IMSI
    Result := dwData;
  end;
{$ENDIF}
end;


//------------------------------------------------------------------------------
function TDioAxd.ReadDioOut32(nDioOutModuleOffset: Integer): DWORD;
var
	nModuleNo : LongInt;
  dwRet, dwData : DWORD;
begin
  if (nDioOutModuleOffset >= DefDio.DIO_OUT_MODULE_CNT) then begin
		Exit(0);  //TBD:DIO? Abnormal Case
  end;
	//-------------------------- 출력(Output) 포트로부터 4바이트의 데이터를 읽어들인다. 지정한 모듈의 더블워드 단위
	nModuleNo := DefDio.DIO_MODULENO_DIO_OUT + nDioOutModuleOffset;
{$IFDEF SIMULATOR_DIO}
  Result := 0; //TBD:SIMULATOR:DIO?
{$ELSE}
  dwData := 0;
  dwRet :=	AxdoReadOutportDword(nModuleNo, 0, @dwData);
  if dwRet <> AXT_RT_SUCCESS then begin
    m_sErrLibApi := '<DIO> ReadDioOut32: Error('+IntToStr(dwRet)+')'; CodeSite.Send(m_sErrLibApi);
    Result := 0; //TBD:DIO:READ_ERROR?
  end
  else begin
    Result := dwData;
  end;
{$ENDIF}
end;

//------------------------------------------------------------------------------
function TDioAxd.WriteDioOutBit(nSigBit64: Integer; bIsOn: Boolean): Boolean;
var
  dwRet, dwValue : DWORD;
  nDioOutModuleOffset, nModuleNo, nSigBit32 : LongInt;
begin
	//-------------------------- 출력(Output) 포트로에 4바이트의 데이터를 써넣는다. 지정한 모듈의 더블워드 단위
  nDioOutModuleOffset := nSigBit64 div 32;
  nSigBit32 := nSigBit64 mod 32;
  if (nDioOutModuleOffset >= DefDio.DIO_OUT_MODULE_CNT) then begin
		Exit(False);
  end;
  //
  nModuleNo := DefDio.DIO_MODULENO_DIO_OUT + nDioOutModuleOffset;
  if bIsOn then dwValue := 1 else dwValue := 0;
{$IFNDEF SIMULATOR_DIO}
  dwRet := AxdoWriteOutportBit(nModuleNo, nSigBit32{offset}, dwValue{uValue});
  if dwRet <> AXT_RT_SUCCESS then begin
    m_sErrLibApi := '<DIO> WriteDioOutBit: Bit('+IntToStr(nSigBit64)+') Error('+IntToStr(dwRet)+')'; CodeSite.Send(m_sErrLibApi);
    //TBD:DIO:READ_ERROR?
    Exit(False);
  end;
{$ENDIF}
  Result := True;
end;

//------------------------------------------------------------------------------
function TDioAxd.WriteDioOut32(nDioOutModuleOffset: Integer; dwSig32: DWORD): Boolean;
var
	nModuleNo : LongInt;
  dwRet     : DWORD;
begin
  if (not m_bConnected) then begin
		Exit(False);
  end;
	//-------------------------- 출력(Output) 포트로에 4바이트의 데이터를 써넣는다. 지정한 모듈의 더블워드 단위
	nModuleNo := DefDio.DIO_MODULENO_DIO_OUT + nDioOutModuleOffset;
{$IFNDEF SIMULATOR_DIO}
  dwRet := AxdoWriteOutportDword(nModuleNo,0{offset},dwSig32);
  if dwRet <> AXT_RT_SUCCESS then begin
    m_sErrLibApi := '<DIO> WriteDioOut32: Error('+IntToStr(dwRet)+')'; CodeSite.Send(m_sErrLibApi);
    //TBD:DIO:WRITE_ERROR?
    Exit(False);
  end;
{$ENDIF}
  Result := True;
end;

//------------------------------------------------------------------------------
function TDioAxd.WriteDioOut64(dSig64: UInt64): Boolean;
var
	nModuleNo : LongInt;
  dwRet, dwTemp : DWORD;
begin
  if (not m_bConnected) then begin
		Exit(False);
  end;
  //
{$IFNDEF SIMULATOR_DIO}
  //
	nModuleNo := DefDio.DIO_MODULENO_DIO_OUT;
  dwTemp := dSig64 and $00000000ffffffff;
  dwRet := AxdoWriteOutportDword(nModuleNo,0{offset},dwTemp);
  if dwRet <> AXT_RT_SUCCESS then begin
    m_sErrLibApi := '<DIO> WriteDioOut64:0: Error('+IntToStr(dwRet)+')'; CodeSite.Send(m_sErrLibApi);
    //TBD:DIO:WRITE_ERROR?
    Exit(False);
  end;
  //
	nModuleNo := DefDio.DIO_MODULENO_DIO_OUT + 1;
  dwTemp := dSig64 shr 32;
  dwRet := AxdoWriteOutportDword(nModuleNo,0{offset},dwTemp);
  if dwRet <> AXT_RT_SUCCESS then begin
    m_sErrLibApi := '<DIO> WriteDioOut64:1: Error('+IntToStr(dwRet)+')'; CodeSite.Send(m_sErrLibApi);
    //TBD:DIO:WRITE_ERROR?
    //Exit(False);
  end;
{$ENDIF}
  Result := True;
end;

end.
