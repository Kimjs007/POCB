unit GMesCom;

interface
{$I Common.inc}

uses
  Winapi.Windows, System.Classes, Vcl.Dialogs,
{$IFDEF WIN32}
  ModuleECS_CommTibRV_TLB,
{$ENDIF}
  Winapi.WinSock, IdFTPCommon,
{$IFDEF INSPECTOR_POCB}
  DefPocb,
{$ELSE}
  DefCommon,
{$ENDIF}
  Vcl.OleServer, Vcl.ExtCtrls, DefGmes, IdFTPList, IdFTP, System.SysUtils, Winapi.Messages, CommonClass, CodeSiteLogging;

type

//TGmesDataPack = record   //2019-06-19 jhhwang (Move from GMesCom to Common for DFS without GMES)

  PSyncHost = ^RSyncHost;
  RSyncHost = record
    MsgType : Integer;
    Channel	: Integer;
    MsgMode : Integer;
    bError  : Boolean;
    Msg     : string;
  end;

  TGmesEvent = procedure(nMsgType, nPg: Integer; bError : Boolean; sErrMsg : string) of object;

  TGmes = class(TObject)
{$IFDEF WIN32}
  mesCommTibRv : TCommTibRv;
  {$IFDEF USE_EAS}
  easCommTibRv : TCommTibRv;
  {$ENDIF}
{$ENDIF}

  private
		//---------------------------------- MES and EAS Config
    m_sLocal       		: string;
    m_sRemote      		: string;
    m_sEasLocal       : string;
    m_sEasRemote   		: string;
    m_sServicePort 		: string;
{$IFDEF USE_MES_FLDR}
		//---------------------------------- MES FLDR
    m_bCombiDown      : Boolean;
    m_bDefectDown     : Boolean;
    m_bFullDefectDown : Boolean;
    m_bRepairDown     : Boolean;
    m_bFullRepairDown : Boolean;
{$ENDIF}
		//---------------------------------- MES Message Paramter Values (System-based)
    FSystemNo      		: string;
    FUserId        		: string;
    FMesUserName			: string;
		//---------------------------------- MES Message Paramter Values (Channel-based)
    FMesPID         	: string;		// XXXX.PID 
    FMesSerialNo			: string; 	// XXXX.SERIAL_NO
    FMesLcmId					: string;		// XXXX.LCM_ID
    FMesFogId					: string;		// XXXX.FOG_ID
    FMesBLID					: string;		// XXXX.BLID
    FMesCGID					: string;		// XXXX.COVER_GLASS_ID(PCHK) or CGID(EICR)
    FMesPCBID         : string;		// XXXX.PCBID
    FMesPf         		: string;		// XXXX.PF (EICR)
		FMesPatInfo				: string;		// XXXX.PATTERN_INFO (EICR)
    FMesRtnCd					: string;		// XXXX_R.RTN_CD
    FMesErrMsgLoc			: string; 	// XXXX_R.ERR_MSG_LOG
    FMesErrMsgEng			: string;		// XXXX_R.ERR_MSG_ENG
    FMesHostDate			: string;		// XXXX_R.HOST_DATE
    FMesRtnPID				: string;		// XXXX_R.RTN_PID
    FMesRtnSerialNo		: string;		// XXXX_R.RTN_SERIAL_NO
    FMesRtnLcmId			: string;		// XXXX_R.RTN_LCM_ID
    FMesRtnBLID				: string;		// XXXX_R.RTN_BLID
    FMesRtnCGID				: string;		// XXXX_R.RTN_CGID or XXXX_R.RTN_COVER_GLASS_ID(INS_PCHK)
    FMesRtnPCBID  		: string;		// XXXX_R.RTN_PCBID
    FMesRtnModel   		: string;		// XXXX_R.MODEL (PCHK, INS_PCHK, RPR_PCHK,
    FMesRtnInspInfo 	: string;		// XXXX_R.INSP_INFO (PCHK, INS_PCHK, TILR)
    FMesRtnSubPID			: string;		// XXXX_R.RTN_SUB_PID  //A2CHv3:ASSYPOCB:MES
		//---------------------------------- 
    FPmMode        		: Boolean;
    FCanUseHost    		: Boolean;
    FCanUseEas     		: Boolean;
    FEayt          		: Boolean;
    FMesCh						: Integer;
    FEasCh				    : Integer;
    FOnGmsEvent				: TGmesEvent;
		//---------------------------------- Timer
	//tmEqcc  					: TTimer;
    tmGmesChMsg     	: TTimer;
    tmGmesResponse  	: TTimer;
		//---------------------------------- RemoteUpdate
    {$IFDEF REMOTE_UPDATE}
    FRcpInfo, FRcpInfo2 : string;
    FIsEdtiOn: boolean;
    {$ENDIF}

{$IFDEF IMD_FI}
    FMesGIBCode: string;
  //FFtpCombiPath: string
    ////////////// For TILR //////////////////////////////////////
    FMesDefLoc: string;
    FMesMthdCode: string;
    FMesObjLoc: string;
    FMesMthdLoc: string;
    FMesDefHando: string;
    FMesDefLevel: string;
    FMesObjEng: string;
    FMesCalling: string;
    FMesDefMulti: string;
    FMesMthdEng: string;
    FMesObjCode: string;
    ////////////////////////////////////////////////////////////////
{$ENDIF}
		//---------------------------------- TX MES Message
    function  ConvertTxSerialNo(sSerialNo: string): string;
    function  MakeSerialParams(nCh: Integer; nMsgType: Integer; sSerialNo: string): string;
    procedure SEND_MESG2HOST(const nMsgType: Integer; sSerialNo: string = ''; sZigId : string = ''; nCh: Integer = -1; bIsDelayed : Boolean = False);
		//---------------------------------- RX MES Messages (Common)
    procedure ReadMsgHost(ASender: TObject; const sMessage: WideString);
    procedure GetHostData(sMsg : string);
{$IFDEF USE_EAS}
    procedure ReadMsgEas(ASender: TObject; const sMessage: WideString);
    procedure GetEasData(sMsg : string);
{$ENDIF}
    procedure SeperateData(sMsg: string; var nRtnCh: Integer);
		function GetMesRxCh(nRtnCh: Integer; var nCh: Integer): Boolean;
		//---------------------------------- RX MES Messages (System-base)
    procedure parse_EAYT; // 1.상위 통신 시작
    procedure parse_UCHK; // 2.사용자 로그인
    procedure parse_EDTI; // 3.검사기 시간 동기화.
    procedure parse_EQCC;
		//---------------------------------- RX MES Messages (Channel-base)
		procedure parse_APDR(nRtnCh: Integer; sMsg: string; bMes: Boolean);
		procedure parse_PCHK(nRtnCh: Integer; sMsg: string);
		procedure parse_EICR(nRtnCh: Integer; sMsg: string);
		procedure parse_EIJR(nRtnCh: Integer; sMsg: string);
		procedure parse_INS_PCHK(nRtnCh: Integer; sMsg: string);
    procedure parse_RPR_EIJR(nRtnCh: Integer; sMsg: string);
{$IFDEF IMD_FI}
    procedure parse_TILR(nRtnCh: Integer; sMsg: string);
{$ENDIF}
		procedure parse_ZSET(nRtnCh: Integer; sMsg: string);
		//----------------------------------
    procedure OnGmesChMsgTimer(Sender: TObject);
    procedure OnGemsResponseTimer(Sender: TObject);
    procedure ReturnDataToTestForm(nMode,nCh: Integer; bError: Boolean; sMsg: string);
    procedure SetOnGmsEvent(const Value: TGmesEvent);
		//----------------------------------
    function GetLocalIp : string;
    procedure SetDateTime(Year, Month, Day, Hour, Minu, Sec, MSec: Word);
		//---------------------------------- RemoteUpdate
    {$IFDEF REMOTE_UPDATE}
    procedure SetRcpInfo(const Value: string);
    procedure SetRcpInfo2(const Value: string);
    procedure SetIsEdtiOn(const Value: boolean);
    {$ENDIF}

{$IFDEF IMD_FI}
    {
    procedure SetMesCalling(const Value: string);
    procedure SetMesDefHando(const Value: string);
    procedure SetMesDefLevel(const Value: string);
    procedure SetMesDefLoc(const Value: string);
    procedure SetMesDefMulti(const Value: string);
    procedure SetMesMthdCode(const Value: string);
    procedure SetMesMthdEng(const Value: string);
    procedure SetMesMthdLoc(const Value: string);
    procedure SetMesObjCode(const Value: string);
    procedure SetMesObjEng(const Value: string);
    procedure SetMesObjLoc(const Value: string);
    procedure SetMesRtnPID(const Value: string);
    procedure SetMesGIBCode(const Value: string);
    }
{$ENDIF}
  public
  //MesData       : array[DefPocb.CH_1..DefPocb.CH_MAX] of TGmesDataPack;  //2019-06-19 Move to Common
    hMainHandle   : HWND;
{$IFDEF INSPECTOR_POCB}
    hTestHandle   : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of HWND;
{$ELSE} // IMD_FI, IMD_GB or IMD_AC
    hTestHandle1  : HWND;
    hTestHandle2  : HWND;
{$ENDIF}
{$IFDEF IMD_FI}
    m_sLotNo      : string;
{$ENDIF}
		//---------------------------------- 
    constructor Create(AOwner : TComponent; MainHandle : HWND); virtual;
    destructor Destroy; override;
    procedure ClearMesChParam;
    function HOST_Initial(sServicePort, sNetwork, sDemonPort, sLocal, sRemote, sPath: string) : Boolean;
{$IFDEF USE_EAS}
    function EAS_Initial(sServicePort, sNetwork, sDemonPort, sLocal, sRemote, sPath: string) : Boolean;
{$ENDIF}
		//---------------------------------- TX MES Messages 
    procedure SendHostStart;
		// TX MES Messages (System-based)
    procedure SendHostEayt;
    procedure SendHostUchk;
    procedure SendHostEqcc;
    procedure SendHostFldr(sMsg: string);
		// TX MES Messages (Channel-based)
    procedure SendHostPchk    (sSerialNo: string; nCh: Integer; bIsDelayed: Boolean = False);
    procedure SendHostIns_Pchk(sSerialNo: string; nCh: Integer; bIsDelayed: Boolean = False);
    procedure SendHostEicr    (sSerialNo: string; nCh: Integer; sJigId: string = ''; bIsDelayed: Boolean = False);
    procedure SendHostZset    (sSerialNo: string; nCh: Integer; sJigId: string = ''; bIsDelayed: Boolean = False);
    procedure SendHostEijr    (sSerialNo: string; nCh: Integer; sJigId: string = ''; bIsDelayed: Boolean = False);
    procedure SendHostRpr_Eijr(sSerialNo: string; nCh: Integer; sJigId: string = ''; bIsDelayed: Boolean = False);
    procedure SendHostTilr    (sSerialNo: string; nCh: Integer; bIsDelayed: Boolean = False);
{$IFDEF USE_MES_APDR}
		procedure SendHostApdr    (sSerialNo: string; nCh: Integer; bIsDelayed: Boolean = False);
{$ENDIF}
    procedure SendEasApdr     (sSerialNo: string; nCh: Integer; bIsDelayed: Boolean = False);
		//---------------------------------- 
    function IsMesWaiting(bIsChMsg : Boolean; nThisChNo : Integer): Boolean;
		//---------------------------------- MES Message Parameters
		// System-based
    property MesSystemNo 		: string read FSystemNo 			write FSystemNo;
    property MesUserId   		: string read FUserId 				write FUserId;
    property MesUserName  	: string read FMesUserName 		write FMesUserName;
		// Channel-based
    property MesPID         : string read FMesPID 				write FMesPID;
    property MesSerialNo		: string read FMesSerialNo 		write FMesSerialNo;
    property MesLcmId				: string read FMesLcmId 			write FMesLcmId;
    property MesFogId				: string read FMesFogId 			write FMesFogId;
    property MesBLID				: string read FMesBLID 				write FMesBLID;
    property MesCGID				: string read FMesCGID 				write FMesCGID;
    property MesPCBID				: string read FMesPCBID 			write FMesPCBID;
    property MesRtnCd				: string read FMesRtnCd 			write FMesRtnCd;
    property MesErrMsgLoc		: string read FMesErrMsgLoc 	write FMesErrMsgLoc;
    property MesErrMsgEng		: string read FMesErrMsgEng 	write FMesErrMsgEng;
    property MesHostDate 		: string read FMesHostDate 		write FMesHostDate;
    property MesRtnPID			: string read FMesRtnPID 			write FMesRtnPID;
    property MesRtnSerialNo	: string read FMesRtnSerialNo write FMesRtnSerialNo;
    property MesRtnLcmId		: string read FMesRtnLcmId 		write FMesRtnLcmId;
    property MesRtnBLID			: string read FMesRtnBLID 		write FMesRtnBLID;
    property MesRtnCGID			: string read FMesRtnCGID 		write FMesRtnCGID;
    property MesRtnPCBID  	: string read FMesRtnPCBID 		write FMesRtnPCBID;
    property MesRtnModel 		: string read FMesRtnModel 		write FMesRtnModel;
    property MesRtnInspInfo : string read FMesRtnInspInfo write FMesRtnInspInfo;
		//
    property MesPmMode 			: Boolean read FPmMode 				write FPmMode 		default False;
    property CanUseHost 		: Boolean read FCanUseHost 		write FCanUseHost default False;
    property CanUseEAS 			: Boolean read FCanUseEAS 		write FCanUseEAS 	default False;
    property MesEayt   			: Boolean read FEayt 					write FEayt 			default False;
    property MesCh        	: Integer read FMesCh 				write FMesCh;
    property EasCh    	    : Integer read FEasCh 		    write FEasCh;
		//
    property OnGmsEvent     : TGmesEvent read FOnGmsEvent write SetOnGmsEvent;
		//---------------------------------- RemoteUpdate
    {$IFDEF REMOTE_UPDATE}
    property RcpInfo   : string read FRcpInfo write SetRcpInfo;
    property RcpInfo2  : string read FRcpInfo2 write SetRcpInfo2;
    property IsEdtiOn : boolean read FIsEdtiOn write SetIsEdtiOn;
    {$ENDIF}

{$IFDEF IMD_FI}
    property MesGIBCode    	: string read FMesGIBCode     write FMesGIBCode;
  //property  FtpAddr     	: string read FFtpAddr write FFtpAddr;
  //property  FtpUser     	: string read FFtpUser write FFtpUser;
  //property  FtpPass     	: string read FFtpPass write FFtpPass;
  //property  FtpCombiPath  : string read FFtpCombiPath write FFtpCombiPath;
    ///////////////////////////////// TILR //////////////////////////////////////////
    property MesObjCode    	: string read FMesObjCode 	write FMesObjCode;
    property MesObjEng     	: string read FMesObjEng  	write FMesObjEng;
    property MesObjLoc     	: string read FMesObjLoc 		write FMesObjLoc;
    property MesMthdCode   	: string read FMesMthdCode 	write FMesMthdCode;
    property MesMthdEng    	: string read FMesMthdEng 	write FMesMthdEng;
    property MesMthdLoc    	: string read FMesMthdLoc 	write FMesMthdLoc;
    property MesDefMulti   	: string read FMesDefMulti 	write FMesDefMulti;
    property MesDefLoc     	: string read FMesDefLoc 		write FMesDefLoc;
    property MesDefLevel   	: string read FMesDefLevel 	write FMesDefLevel;
    property MesDefHando   	: string read FMesDefHando 	write FMesDefHando;
    property MesCalling    	: string read FMesCalling 	write FMesCalling;
    /////////////////////////////////////////////////////////////////////////////////
{$ENDIF}
  end;
var
  DongaGmes : TGmes;

implementation

//==============================================================================
//
//==============================================================================

constructor TGmes.Create(AOwner : TComponent; MainHandle : HWND);
begin
  mesCommTibRv := TCommTibRv.Create(AOwner);
  mesCommTibRv.OnMessageReceive := ReadMsgHost;
{$IFDEF USE_EAS}
  if Common.SystemInfo.EAS_UseAPDR then begin
    easCommTibRv := TCommTibRv.Create(AOwner);
    easCommTibRv.OnMessageReceive := ReadMsgEas;
  end;
{$ENDIF}
  ZeroMemory(@Common.MesData,SizeOf(Common.MesData));
  // Clear Fxxxx property -
  FSystemNo     := '';
  FUserId       := '';
  FMesUserName  := '';
  // Clear Fxxxx property - Message Parameters
  ClearMesChParam;
  //
  FPmMode       := True;  //2018-06-20 False->True
  FCanUseHost   := False;
  FCanUseEas    := False;
  FEayt         := False;
  FMesCh			  := 0;
  FEasCh	      := 0;
	//---------------------------------- RemoteUpdate
  {$IFDEF REMOTE_UPDATE}
  FRcpInfo  := '';
  FIsEdtiOn := False;
	{$ENDIF}
  //
{$IFDEF IMD_FI}
//FEiJRSend := False;
{$ENDIF}

  // GMES CH MEssage timer
  tmGmesChMsg := TTimer.Create(nil);
  tmGmesChMsg.Interval := 100;  // 100 msec
  tmGmesChMsg.OnTimer := OnGmesChMsgTimer;
  tmGmesChMsg.Enabled := False;

  tmGmesResponse := TTimer.Create(nil);
  tmGmesResponse.Interval := 3000;  // 3000 msec
  tmGmesResponse.OnTimer := OnGemsResponseTimer;
  tmGmesResponse.Enabled := False;
end;

destructor TGmes.Destroy;
begin
  ZeroMemory(@Common.MesData,SizeOf(Common.MesData));
  //
  if tmGmesChMsg <> nil then begin
    tmGmesChMsg.Enabled := False;
    tmGmesChMsg.Free;
    tmGmesChMsg := nil;
  end;
  if tmGmesResponse <> nil then begin
    tmGmesResponse.Enabled := False;
    tmGmesResponse.Free;
    tmGmesResponse := nil;
  end;
//if tmEqcc <> nil then begin
//	tmEqcc.Enabled  := False;
//  tmEqcc.Free;
//  tmEqcc := nil;
//end;

{$IFDEF WIN32}
  if mesCommTibRv <> nil then begin
    mesCommTibRv.Terminate;
    mesCommTibRv.Free;
    mesCommTibRv := nil;
  end;
{$IFDEF USE_EAS}
  if easCommTibRv <> nil then begin
    easCommTibRv.Terminate;
    easCommTibRv.Free;
    easCommTibRv := nil;
  end;
{$ENDIF}
{$ENDIF}

  inherited;
end;

procedure TGmes.ClearMesChParam;
begin
  //
  FMesPID         	:= '';
  FMesSerialNo			:= '';
  FMesLcmId					:= '';
  FMesFogId					:= '';
  FMesBLID					:= '';
  FMesCGID					:= '';
  FMesPCBID					:= '';
  FMesPf         		:= '';
	FMesPatInfo				:= '';
  //
  FMesRtnCd					:= '';
  FMesErrMsgLoc			:= '';
  FMesErrMsgEng			:= '';
  FMesHostDate			:= '';
  FMesRtnPID				:= '';
  FMesRtnSerialNo		:= '';
  FMesRtnLcmId			:= '';
  FMesRtnBLID				:= '';
  FMesRtnCGID				:= '';
  FMesRtnPCBID			:= '';
  FMesRtnModel   		:= '';
  FMesRtnInspInfo 	:= '';
end;

function TGmes.HOST_Initial(sServicePort, sNetwork, sDemonPort, sLocal, sRemote, sPath: string): Boolean;
var
  nCh : Integer;
begin
{$IFDEF WIN32}
  mesCommTibRv.IS_LOG := True;
  mesCommTibRv.IS_LOG_PATH := sPath;
  FCanUseHost := mesCommTibRv.Init(sServicePort, sNetwork, sDemonPort, sLocal, sRemote);
{$ENDIF}

  m_sLocal  := sLocal;
  m_sRemote := sRemote;
  m_sServicePort  := sServicePort;

  // 전역변수는 Send할때 쓰임
  if not FCanUseHost then begin
    ShowMessage('[HOST initialization failure - Confirm HOST environment setup]');
  end
  else begin
    if not fEAYT then SEND_MESG2HOST(DefGmes.MES_EAYT)
    else              SEND_MESG2HOST(DefGmes.MES_UCHK);
    //EAYT 가 처음 INITIAL 하고 테스트 하는 쪽인듯?
  end;
  Result := FCanUseHost;
end;

{$IFDEF USE_EAS}
function TGmes.EAS_Initial(sServicePort, sNetwork, sDemonPort, sLocal, sRemote, sPath: string): Boolean;
var
  nCh : Integer;
begin
{$IFDEF WIN32}
  easCommTibRv.IS_LOG := True;
  easCommTibRv.IS_LOG_PATH := sPath;
  m_sEasLocal  := sLocal;
  m_sEasRemote := sRemote;
  FCanUseEAS := easCommTibRv.Init(sServicePort, sNetwork, sDemonPort, sLocal, sRemote);
{$ENDIF}
  if not FCanUseEAS then begin
    ShowMessage('[EAS initialization failure - Confirm HOST environment setup]');
  end;
  Result := FCanUseEAS;
end;
{$ENDIF}

//==============================================================================
// SEND
//==============================================================================

//------------------------------------------------------------------------------
// System-based Messages
//------------------------------------------------------------------------------

procedure TGmes.SendHostStart;
begin
  if not FCanUseHost then begin
    ShowMessage('[HOST initialization failure - Confirm HOST environment setup]');
  end
  else begin
    if not fEAYT then SEND_MESG2HOST(DefGmes.MES_EAYT)
    else              SEND_MESG2HOST(DefGmes.MES_UCHK);
  end;
end;

procedure TGmes.SendHostEayt;
begin
  FMesCh := 0;
  FEasCh := 0;
  SEND_MESG2HOST(DefGmes.MES_EAYT);
end;

procedure TGmes.SendHostUchk;
begin
  FMesCh := 0;
  FEasCh := 0;
  SEND_MESG2HOST(DefGmes.MES_UCHK);
end;

procedure TGmes.SendHostEqcc;
begin
  SEND_MESG2HOST(DefGmes.MES_EQCC);
end;

procedure TGmes.SendHostFldr(sMsg : string);
begin
  SEND_MESG2HOST(DefGmes.MES_FLDR, sMsg);
end;

//------------------------------------------------------------------------------
// Channel-based Messages
//------------------------------------------------------------------------------

function TGmes.ConvertTxSerialNo(sSerialNo: string): string;
var
  sConvertSerial : string;
begin
  sConvertSerial := StringReplace(sSerialNo,#$24,#$0a,[rfReplaceAll]);
  sConvertSerial := StringReplace(sConvertSerial,#$25,#$0d,[rfReplaceAll]);
  Result := sConvertSerial;
end;

procedure TGmes.SendHostPchk(sSerialNo: string; nCh: Integer; bIsDelayed: Boolean = False);
var
  sConvertSerial : string;
begin
  if Length(sSerialNo) = 0 then Exit;
  FMesCh  := nCh;
  sConvertSerial := ConvertTxSerialNo(sSerialNo);
  Common.MesData[nCh].TxSerial := sConvertSerial;
  SEND_MESG2HOST(DefGmes.MES_PCHK, sConvertSerial, '' ,nCh, bIsDelayed);
end;

procedure TGmes.SendHostIns_Pchk(sSerialNo: string; nCh: Integer; bIsDelayed : Boolean = False);
var
  sConvertSerial : string;
begin
  if Length(sSerialNo) = 0 then Exit;
  FMesCh  := nCh;
  sConvertSerial := ConvertTxSerialNo(sSerialNo);
  Common.MesData[nCh].TxSerial := sConvertSerial;
  SEND_MESG2HOST(DefGmes.MES_INS_PCHK, sConvertSerial, '', nCh, bIsDelayed);
end;

procedure TGmes.SendHostEicr(sSerialNo: string; nCh: Integer; sJigId: string = ''; bIsDelayed: Boolean = False);
var
  sConvertSerial : string;
  sConvertZig    : string;
begin
  if Length(sSerialNo) = 0 then Exit;
  FMesCh  := nCh;
  sConvertSerial := ConvertTxSerialNo(sSerialNo);
  sConvertZig    := '';
  if Length(sJigId) > 0 then sConvertZig := ConvertTxSerialNo(sJigId);
  Common.MesData[nCh].TxSerial := sConvertSerial;
  SEND_MESG2HOST(DefGmes.MES_EICR, sConvertSerial, sConvertZig, nCh, bIsDelayed);
end;

procedure TGmes.SendHostEijr(sSerialNo: string; nCh: Integer; sJigId: string = ''; bIsDelayed: Boolean = False);
var
  sConvertSerial : string;
  sConvertZig    : string;
begin
  if Length(sSerialNo) = 0 then Exit;
  FMesCh  := nCh;
  sConvertSerial := ConvertTxSerialNo(sSerialNo);
  sConvertZig    := '';
  if Length(sJigId) > 0 then sConvertZig := ConvertTxSerialNo(sJigId);
  Common.MesData[nCh].TxSerial := sConvertSerial;
  SEND_MESG2HOST(DefGmes.MES_EIJR, sConvertSerial, sConvertZig, nCh, bIsDelayed);
end;

procedure TGmes.SendHostRpr_Eijr(sSerialNo: string; nCh: Integer; sJigId: string = ''; bIsDelayed: Boolean = False);
var
  sConvertSerial : string;
  sConvertZig    : string;
begin
  if Length(sSerialNo) = 0 then Exit;
  FMesCh  := nCh;
  sConvertSerial := ConvertTxSerialNo(sSerialNo);
  sConvertZig    := '';
  if Length(sJigId) > 0 then sConvertZig := ConvertTxSerialNo(sJigId);
  Common.MesData[nCh].TxSerial := sConvertSerial;
  SEND_MESG2HOST(DefGmes.MES_RPR_EIJR, sConvertSerial, sConvertZig, nCh, bIsDelayed);
end;

procedure TGmes.SendHostTilr(sSerialNo: string; nCh: Integer; bIsDelayed: Boolean = False);
var
  sConvertSerial : string;
begin
  if Length(sSerialNo) = 0 then Exit;
  FMesCh  := nCh;
  sConvertSerial := ConvertTxSerialNo(sSerialNo);
  Common.MesData[nCh].TxSerial := sConvertSerial;
  SEND_MESG2HOST(DefGmes.MES_TILR, sConvertSerial, '', nCh, bIsDelayed);
end;

procedure TGmes.SendHostZset(sSerialNo: string; nCh: Integer; sJigId: string = ''; bIsDelayed: Boolean = False);
var
  sConvertSerial : string;
  sConvertZig    : string;
begin
  if Length(sSerialNo) = 0 then Exit;
  FMesCh  := nCh;
  sConvertSerial := ConvertTxSerialNo(sSerialNo);
  sConvertZig    := '';
  if Length(sJigId) > 0 then sConvertZig := ConvertTxSerialNo(sJigId);
  Common.MesData[nCh].TxSerial := sConvertSerial;
  SEND_MESG2HOST(DefGmes.MES_ZSET, sConvertSerial, sConvertZig, nCh, bIsDelayed);
end;

{$IFDEF USE_MES_APDR}
procedure TGmes.SendHostApdr(sSerialNo: string; nCh: Integer; bIsDelayed: Boolean = False);
var
  sConvertSerial : string;
begin
  if Length(sSerialNo) = 0 then Exit;
  FMesCh := nCh;
  sConvertSerial := ConvertTxSerialNo(sSerialNo);
  Common.MesData[nCh].TxSerial := sConvertSerial;
  SEND_MESG2HOST(DefGmes.MES_APDR, sConvertSerial, '', nCh, bIsDelayed);
end;
{$ENDIF}

procedure TGmes.SendEasApdr(sSerialNo: string; nCh: Integer; bIsDelayed : Boolean = False);
var
  sConvertSerial : string;
begin
  if Length(sSerialNo) = 0 then Exit;
  FEasCh := nCh;
  sConvertSerial := ConvertTxSerialNo(sSerialNo);
  Common.MesData[nCh].TxSerial := sConvertSerial;
  SEND_MESG2HOST(DefGmes.EAS_APDR, sConvertSerial,'', nCh, bIsDelayed);
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------


procedure TGmes.SEND_MESG2HOST(const nMsgType: Integer; sSerialNo: string; sZigId : string; nCh: Integer; bIsDelayed : Boolean);
var
  sSendMsg, sOldDate, sSnParams : string;
  yyyy,mm,dd, hh,nn, ss : Word;
  bRtn                  : Boolean;
  // for FLDR.
  sFldrFile, sFldrType    : string;
  sDownTime, sDebug  : string;
  bIsChMsg : Boolean;
  sInspType : string; //2019-11-08
  nChMain, nChSub : Integer;
begin
  bIsChMsg := False;
  case nMsgType of
  	//
    DefGmes.MES_PCHK : begin
      sSendMsg := 'PCHK';
			sSendMsg := sSendMsg + ' ADDR=' + m_sLocal + ',' + m_sLocal;
			sSendMsg := sSendMsg + ' EQP=' + FSystemNo;
      sSnParams := MakeSerialParams(nCh,nMsgType,sSerialNo);  //PID, SERIAL_NO, LCM_ID, FOG_ID, BLID, COVER_GLASS_ID, PCBID
      sSendMsg := sSendMsg + sSnParams;
      sSendMsg := sSendMsg + ' PAIR_PID=';  //PAIR_PID: PAIR_PID가 올라오는 경우, PID와 장입조건 사전체크
      sSendMsg := sSendMsg + ' ZIG_ID=';
			sSendMsg := sSendMsg + Format(' INSPCHANEL_A=%d',[nCh+1]);  //병렬처리 검사기처리 Unit: 검사기만 사용
      {$IFDEF REMOTE_UPDATE}
      sSendMsg := sSendMsg + FRcpInfo;
      {$ENDIF}
			sSendMsg := sSendMsg + ' USER_ID=' + FUserId;
			sSendMsg := sSendMsg + ' MODE=AUTO';  //MODE(전송모드): AUTO|MANUAL
			sSendMsg := sSendMsg + ' CLIENT_DATE=' + FormatDateTime('yyyymmddhhnnss', Now);
			sSendMsg := sSendMsg + ' COMMENT=[]';
      bIsChMsg := True; //!!!
    end;
		//
    DefGmes.MES_EICR : begin
      sSendMsg := 'EICR';
      sSendMsg := sSendMsg + ' ADDR=' + m_sLocal + ',' + m_sLocal;
      sSendMsg := sSendMsg + ' EQP=' + FSystemNo;
      sSnParams := MakeSerialParams(nCh,nMsgType,sSerialNo);  //PID, SERIAL_NO, LCM_ID, FOG_ID, BLID, COVER_GLASS_ID, PCBID
      sSendMsg := sSendMsg  + sSnParams;
{$IFDEF ISPD_EEPROM}
      if Length(sZigId) > 0 then
        sSendMsg := sSendMsg + ' JIG_ID=['+ sZigId+ '_' + IntToStr(nCh+1) + ']'
	  else
        sSendMsg := sSendMsg + ' ZIG_ID=';
{$ELSE}
      sSendMsg := sSendMsg + ' ZIG_ID=';
{$ENDIF}
      // PF: P(양품), F(불량,등급선검출), R(최종검사 불량품), S(공정진행없이,검사이력남김), E(공정이동없이 공정이력 생성), M(정보 불일치)
{$IFDEF INSPECTOR_FI}
      if Common.DfsInfo.bGJudge then begin
        Common.MesData[nCh].Pf := 'P';
        sSendMsg := sSendMsg + ' PF='+ Common.MesData[nCh].Pf;
        sSendMsg := sSendMsg + ' RWK_CD=[]';
      end
      else begin
{$ENDIF}
        if Trim(Common.MesData[nCh].Pf) = '' then begin
          if Common.MesData[nCh].Rwk = '' then Common.MesData[nCh].Pf := 'P'
          else                                 Common.MesData[nCh].Pf := 'F'
        end;
        sSendMsg := sSendMsg  + ' PF='+ Common.MesData[nCh].Pf;
        // RWK_CD: PF=F인 경우 필수입력, Pilot품인 경우에 한해 다수의 불량코드 입력가능
        sSendMsg := sSendMsg  + ' RWK_CD=['+ Common.MesData[nCh].Rwk+ ']';
{$IFDEF INSPECTOR_FI}
			end;
{$ENDIF}
    	sSendMsg := sSendMsg  + ' EXPECTED_RWK=';   //EXPECTED_RWK: 등급 선검출 코드 (A:포인트, B:얼룩, C:기타, X:수리)
      sSendMsg := sSendMsg  + ' PATTERN_INFO=[]'; //PATTERN_INFO: PATTERN 검사 순서, PATTERN명, 검사 TACT
{$IFDEF IMD_FI}
			sSendMsg := sSendMsg  + ' DEFECT_PATTERN=' + Common.MesData[nCh].DefectPat;
      sSendMsg := sSendMsg  + ' EDID=';           //EDID: 최종검사기 (P:OK, F:NG, N:N/A)
{$ELSE}
      sSendMsg := sSendMsg  + ' DEFECT_PATTERN='; //DEFECT_PATTERN: PF=F일 경우 필수입력
      sSendMsg := sSendMsg  + ' EDID=N';          //EDID: 최종검사기 (P:OK, F:NG, N:N/A)
{$ENDIF}
      sSendMsg := sSendMsg  + ' MODE=AUTO';       //OVERHAUL_FLAG(정밀검사여부): Y|N
      sSendMsg := sSendMsg  + ' USER_ID='+ FUserId;
      sSendMsg := sSendMsg  + ' CLIENT_DATE='+FormatDateTime('yyyymmddhhnnss', Now);
      sSendMsg := sSendMsg  + Format(' INSPCHANEL_A=%d',[nCh+1]);
{$IFDEF INSPECTOR_FI}
      if (Common.SystemInfo.InspectionType = 0) and (Common.DfsInfo.bGJudge) then begin // 초검 and 강제G판정
        sSendMsg := sSendMsg  + ' RE_INSP_FLAG=' + Common.MesData[nCh].ReInsFlag;
      end
      else begin
        sSendMsg := sSendMsg  + ' RE_INSP_FLAG=';
      end;
{$ELSE}
    //sSendMsg := sSendMsg  + ' RE_INSP_FLAG=';   //RE_INSP_FLAG(재검사 여부): Y|N (단, 검사판정 코드는 P여야함)
{$IFEND}
    //sSendMsg := sSendMsg  + ' PPALLET=';
    //sSendMsg := sSendMsg  + ' OVERHAUL_FLAG=';  //OVERHAUL_FLAG(정밀검사여부): Y|N
    //sSendMsg := sSendMsg  + ' BA_EXI_FLAG=';    //BA_EXI_FLAG(B/A 외관검사 여부): Y|N
    //sSendMsg := sSendMsg  + ' BUYER_SERIAL_NO=';
    //sSendMsg := sSendMsg  + ' HISTORY_FLAG=';   //HISTORY_FLAG(이력저장 여부): Y|N
    //sSendMsg := sSendMsg  + ' EDID_CUST_SN=';   //EDID_CUST_SN(모델 중 EEPROM에 고객 Serial을 Writing하는 경우, Writing값을 전송함)
    //sSendMsg := sSendMsg  + ' TACT=';           //TACT(TACT TIME): SS.SS (단취:초, 소수 둘째까지)
    //sSendMsg := sSendMsg  + ' RWK_CD_LIST=[]';  //RWK_CD_LIST(다중 불량코드 LIST): e.g., [불량코드1:Y,불량코드2:N]
    //sSendMsg := sSendMsg  + ' COLOR_BINNING=';  //COLOR_BINNING
    //sSendMsg := sSendMsg  + ' OC_VALUE=';       //OC_VALUE
      sSendMsg := sSendMsg  + ' COMMENT=[]';
      bIsChMsg := True; //!!!
    end;
		//
    DefGmes.MES_INS_PCHK : begin
      sSendMsg := 'INS_PCHK';
			sSendMsg := sSendMsg  + ' ADDR=' + m_sLocal + ',' + m_sLocal;
			sSendMsg := sSendMsg  + ' EQP=' + FSystemNo;
      sSnParams := MakeSerialParams(nCh,nMsgType,sSerialNo);  //PID, SERIAL_NO, LCM_ID, FOG_ID, BLID, COVER_GLASS_ID, PCBID
      sSendMsg := sSendMsg  + sSnParams;
    //sSendMsg := sSendMsg  + ' PAIR_PID=';  //PAIR_PID: PAIR_PID가 올라오는 경우, PID와 장입조건 사전체크
    //sSendMsg := sSendMsg  + ' ZIG_ID=';
			sSendMsg := sSendMsg  + Format(' INSPCHANEL_A=%d',[nCh+1]);  //병렬처리 검사기처리 Unit: 검사기만 사용
      {$IFDEF REMOTE_UPDATE}
      sSendMsg := sSendMsg  + FRcpInfo;
      {$ENDIF}
			sSendMsg := sSendMsg  + ' USER_ID=' + FUserId;
			sSendMsg := sSendMsg  + ' MODE=AUTO';  //MODE(전송모드): AUTO|MANUAL
			sSendMsg := sSendMsg  + ' CLIENT_DATE=' + FormatDateTime('yyyymmddhhnnss', Now);
			sSendMsg := sSendMsg  + ' COMMENT=[]';
      bIsChMsg := True; //!!!
    end;
		//
    DefGmes.MES_EIJR : begin
      sSendMsg := 'EIJR';
			sSendMsg := sSendMsg  + ' ADDR=' + m_sLocal + ',' + m_sLocal;
			sSendMsg := sSendMsg  + ' EQP=' + FSystemNo;
      sSnParams := MakeSerialParams(nCh,nMsgType,sSerialNo);  //PID, SERIAL_NO, LCM_ID, FOG_ID, BLID, COVER_GLASS_ID, PCBID
      sSendMsg := sSendMsg  + sSnParams;
      sSendMsg := sSendMsg  + Format(' INSPCHANEL_A=%d',[nCh+1]);
{$IFDEF IMD_FI}
			if Common.MesData[nCh].Rwk = '' then sSendMsg := sSendMsg  + ' SUBJUDGE_INFO=[TOUCH:P]'  //2019-01-19
			else                                 sSendMsg := sSendMsg  + ' SUBJUDGE_INFO=[TOUCH:F:' + Common.MesData[nCh].Rwk + ']';
{$ENDIF}
      if Trim(Common.MesData[nCh].Pf) = '' then begin
        if Common.MesData[nCh].Rwk = '' then Common.MesData[nCh].Pf := 'P'
        else                                 Common.MesData[nCh].Pf := 'F';
      end;
			sSendMsg := sSendMsg  + ' PF='+ Common.MesData[nCh].Pf;
			sSendMsg := sSendMsg  + ' PPALLET=';
			sSendMsg := sSendMsg  + ' EDID=N';
			sSendMsg := sSendMsg  + ' OVERHAUL_FLAG=';
			sSendMsg := sSendMsg  + ' MODE=AUTO';
			sSendMsg := sSendMsg  + ' CLIENT_DATE='+FormatDateTime('yyyymmddhhnnss', Now);
			sSendMsg := sSendMsg  + ' USER_ID='+ FUserId;
			sSendMsg := sSendMsg  + ' COMMENT=[]';
      bIsChMsg := True; //!!!
    end;
		//
    DefGmes.MES_RPR_EIJR : begin
      sSendMsg := 'RPR_EIJR';
			sSendMsg := sSendMsg  + ' ADDR=' + m_sLocal + ',' + m_sLocal;
			sSendMsg := sSendMsg  + ' EQP=' + FSystemNo;
      sSnParams := MakeSerialParams(nCh,nMsgType,sSerialNo);  //PID, SERIAL_NO, LCM_ID, FOG_ID, BLID, COVER_GLASS_ID, PCBID
      sSendMsg := sSendMsg  + sSnParams;
    //sSendMsg := sSendMsg  + ' ZIG_ID=';
      sSendMsg := sSendMsg  + Format(' INSPCHANEL_A=%d',[nCh+1]);
      if Trim(Common.MesData[nCh].Pf) = '' then begin
        if Common.MesData[nCh].Rwk = '' then Common.MesData[nCh].Pf := 'P'
        else                                 Common.MesData[nCh].Pf := 'F';
      end;
      // MES RPR_EIJR INSP_TYPE Type Code (for VH/GM Auto, 2019-10-31)
      //   INSP_TYPE	EQUIPMENT_GROUP_ID	EQP_GROUP_DESC
      //   ----------+-------------------+----------------------
      //   ABF	      APBF	              조립 등급 열화보상
      //   ABF	      ARBF	              조립 수리 열화보상
      //   AGB	      APGB	              ASY 등급 광학보상
      //   AGB	      ARGB	              ASY 수리 광학보상
      //   ALU	      APLU	              조립 등급 면광학 측정
      //   ALU	      ARLU	              조립 수리 면광학 측정
      //   ASI	      APSI	              ASY 등급 화상 검사
      //   ASI	      ARSI	              ASY 수리 화상 검사
      //   TCB	      TPCB	              TAB 등급 POCB
      //   TCB	      TRCB	              TAB 수리 POCB
      //   TGB	      TPGB	              TAB 등급 광학보상
      //   TGB	      TRGB	              TAB 수리 광학보상
      //   TLU	      TPLU	              TAB 등급 면광학 측정
      //   TLU	      TRLU	              TAB 수리 면광학 측정
      //   TSI	      TPSI	              TAB 등급 화상 검사
      //   TSI	      TRSI	              TAB 수리 화상 검사
{$IF Defined(INSPECTOR_POCB)}
  {$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
      sInspType := 'TCB';	 //A2CH|A2CHv2:TCB
	{$ELSE}
      sInspType := 'TCB'; //A2CHv3|A2CHv4:POCB //2023-01-31 POCB->TCB
	{$ENDIF}
{$ELSEIF Defined(IMD_GB)}
      sInspType := 'AGB'; //AGB or TGB
{$ELSEIF Defined(IMD_AC)}
      sInspType := 'ABF';
{$ELSE}
      sInspType := 'XXX';
{$ENDIF}

      {$IFDEF SUPPORT_1CG2PANEL}
      if not Common.SystemInfo.UseAssyPOCB then begin
      {$ENDIF}
			  if Common.MesData[nCh].Rwk = '' then begin
				  sSendMsg := sSendMsg  + ' SUBJUDGE_INFO=[' + sInspType + ':P:]';
			  end
			  else begin
				  sSendMsg := sSendMsg  + ' SUBJUDGE_INFO=[' + sInspType + ':F:' + Common.MesData[nCh].Rwk + ']';
			  end;
      {$IFDEF SUPPORT_1CG2PANEL}
      end
      else begin
        if Common.TestModelInfo2[DefPocb.CH_1].AssyModelInfo.UseMainPidCh1 then begin
          nChMain := DefPocb.CH_1; nChSub := DefPocb.CH_2;
        end
        else begin
          nChMain := DefPocb.CH_2; nChSub := DefPocb.CH_1;
        end;
        // Main	Sub	PF	RWK_CD	         SUB_RWK_CD
        // ----+---+--+-----------------+------------------
        //  OK	OK	P	  ''	             ''
        //  OK	NG	F	  RWK_CD(Specific) RWK_CD(SUB)
        //  NG	OK	F	  RWK_CD(MAIN)     RWK_CD(Specific)
        //  NG	NG	F	  RWK_CD(MAIN)	   RWK_CD(SUB)
        if (Common.MesData[nChMain].Rwk = '') and (Common.MesData[nChSub].Rwk = '') then begin  // OK OK
          sSendMsg := sSendMsg  + ' SUBJUDGE_INFO=['+sInspType+':P:]';
          sSendMsg := sSendMsg  + ' SUB_SUBJUDGE_INFO=['+Common.MesData[nChMain].PchkRtnSubPid+':'+sInspType+':P::]';
        end
        else if (Common.MesData[nChMain].Rwk = '') and (Common.MesData[nChSub].Rwk <> '') then begin  // OK NG
          sSendMsg := sSendMsg  + ' SUBJUDGE_INFO=['+sInspType+':F:A0S-B0L-----UF0---------------------------]';
          sSendMsg := sSendMsg  + ' SUB_SUBJUDGE_INFO=['+Common.MesData[nChMain].PchkRtnSubPid+':'+sInspType+':F:'+Common.MesData[nChSub].Rwk+':]';
        end
        else if (Common.MesData[nChMain].Rwk <> '') and (Common.MesData[nChSub].Rwk = '') then begin  // NG OK
          sSendMsg := sSendMsg  + ' SUBJUDGE_INFO=[' + sInspType + ':F:' + Common.MesData[nChMain].Rwk + ']';
          sSendMsg := sSendMsg  + ' SUB_SUBJUDGE_INFO=['+Common.MesData[nChMain].PchkRtnSubPid+':'+sInspType+':F:A0S-B0L-----UF0---------------------------:]';
        end
        else begin // NG NG
          sSendMsg := sSendMsg  + ' SUBJUDGE_INFO=[' + sInspType + ':F:' + Common.MesData[nChMain].Rwk + ']';
          sSendMsg := sSendMsg  + ' SUB_SUBJUDGE_INFO=['+Common.MesData[nChMain].PchkRtnSubPid+':'+sInspType+':F:'+Common.MesData[nChSub].Rwk+':]';
        end;
      end;
      {$ENDIF} //SUPPORT_1CG2PANEL
      sSendMsg := sSendMsg  + ' USER_ID='+ FUserId;
			sSendMsg := sSendMsg  + ' MODE=AUTO';
			sSendMsg := sSendMsg  + ' CLIENT_DATE='+FormatDateTime('yyyymmddhhnnss', Now);
			sSendMsg := sSendMsg  + ' COMMENT=[]';
      bIsChMsg := True; //!!!
    end;
		//
{$IFDEF USE_MES_APDR}
    DefGmes.MES_APDR,
{$ENDIF}
    DefGmes.EAS_APDR : begin
      sSendMsg := 'APDR';
			if nMsgType = DefGmes.MES_APDR then sSendMsg := sSendMsg  + ' ADDR=' + m_sLocal + ',' + m_sLocal
			else sSendMsg := sSendMsg  + ' ADDR=' + m_sEasLocal + ',' + m_sEasLocal;
      sSendMsg := sSendMsg  + ' EQP=' + FSystemNo;
      if Length(Common.MesData[nCh].PchkRtnModel) > 0 then sSendMsg := sSendMsg  + ' MODEL='+Common.MesData[nCh].PchkRtnModel //2019-07-25
      else                                                 sSendMsg := sSendMsg  + ' MODEL='+Common.MesData[nCh].Model;
      sSnParams := MakeSerialParams(nCh,nMsgType,sSerialNo);  //PID, SERIAL_NO, LCM_ID, FOG_ID, BLID, COVER_GLASS_ID 중 하나는 필수 입력
      sSendMsg := sSendMsg  + sSnParams;
    //sSendMsg := sSendMsg  + ' PCB_ID=';
    //sSendMsg := sSendMsg  + ' HINGE_ID=';
      sSendMsg := sSendMsg  + ' APD_INFO=['+ Common.MesData[nCh].ApdrApdInfo+']';
      sSendMsg := sSendMsg  + Format(' INSPCHANEL_A=%d',[nCh+1]);
      sSendMsg := sSendMsg  + ' USER_ID=' + FUserId ;
			sSendMsg := sSendMsg  + ' MODE=AUTO';  //MODE(전송모드): AUTO|MANUAL
			sSendMsg := sSendMsg  + ' CLIENT_DATE=' + FormatDateTime('yyyymmddhhnnss', Now);
      if nMsgType = DefGmes.EAS_APDR then sSendMsg := sSendMsg  + ' END_TIME=' + FormatDateTime('yyyymmddhhnnss', Now); //2019-11-08 9EAS서버로 APDR 메세지 작성시 CLINET_DATE, END_TIME 모두 작성)
			sSendMsg := sSendMsg  + ' COMMENT=[]';
      bIsChMsg := True; //!!!
    end;
		//
    DefGmes.MES_TILR : begin
      sSendMsg := 'TILR';
      sSendMsg := sSendMsg  + ' ADDR=' + m_sLocal + ',' + m_sLocal;
			sSendMsg := sSendMsg  + ' EQP=' + FSystemNo;
      sSnParams := MakeSerialParams(nCh,nMsgType,sSerialNo);
      sSendMsg := sSendMsg  + sSnParams;
      sSendMsg := sSendMsg  + ' PCBID=';
      sSendMsg := sSendMsg  + Format(' INSPCHANEL_A=%d',[nCh+1]);
      sSendMsg := sSendMsg  + ' USER_ID=' + FUserId;
      sSendMsg := sSendMsg  + ' MODE=AUTO';
      sSendMsg := sSendMsg  + ' CLIENT_DATE='+FormatDateTime('yyyymmddhhnnss', Now);
      bIsChMsg := True;	//!!!
    end;
		//
    DefGmes.MES_ZSET : begin
      sSendMsg := 'ZSET';
      sSendMsg := sSendMsg  + ' ADDR=' + m_sLocal + ',' + m_sLocal;
      sSendMsg := sSendMsg  + ' EQP=' + FSystemNo;
      sSnParams := MakeSerialParams(nCh,nMsgType,sSerialNo);  //PID, SERIAL_NO, LCM_ID, FOG_ID, BLID, COVER_GLASS_ID
      sSendMsg := sSendMsg  + sSnParams;
      if Length(sZigId) > 0 then sSendMsg := sSendMsg  + ' ZIG_ID='+sZigId
	    else                       sSendMsg := sSendMsg  + ' ZIG_ID=';
      sSendMsg := sSendMsg  + ' ACT_FLAG=A';      //A(체결),D(해제),U(업데이트)
      sSendMsg := sSendMsg  + ' MODE=AUTO';       //OVERHAUL_FLAG(정밀검사여부): Y|N
      sSendMsg := sSendMsg  + ' USER_ID='+ FUserId;
      sSendMsg := sSendMsg  + ' CLIENT_DATE='+FormatDateTime('yyyymmddhhnnss', Now);
      sSendMsg := sSendMsg  + Format(' INSPCHANEL_A=%d',[nCh+1]);
      sSendMsg := sSendMsg  + ' COMMENT=[]';
      bIsChMsg := True; //!!!
    end;
		//
    DefGmes.MES_EAYT : begin  // 장비 ID 등록
      sSendMsg := 'EAYT';
      sSendMsg := sSendMsg  + ' ADDR=' + m_sLocal + ',' + m_sLocal;
      sSendMsg := sSendMsg  + ' EQP=' + FSystemNo;
      sSendMsg := sSendMsg  + ' NET_IP=' + Common.SystemInfo.LocalIP_GMES + ' NET_PORT=' + m_sServicePort;
      sSendMsg := sSendMsg  + ' MODE=AUTO';
      sSendMsg := sSendMsg  + ' CLIENT_DATE='+FormatDateTime('yyyymmddhhnnss', Now);
    end;
		//
    DefGmes.MES_UCHK : begin  // USER ID 등록 -> RETURN으로 USER NAME RECEIVE
      sSendMsg := 'UCHK';
      sSendMsg := sSendMsg  + ' ADDR=' + m_sLocal + ',' + m_sLocal;
      sSendMsg := sSendMsg  + ' EQP=' + FSystemNo;
      sSendMsg := sSendMsg  + ' USER_ID=' + FUserId;
      sSendMsg := sSendMsg  + ' MODE=AUTO';
      sSendMsg := sSendMsg  + ' CLIENT_DATE='+FormatDateTime('yyyymmddhhnnss', Now);
    end;
		//
    DefGmes.MES_EDTI : begin
      sOldDate := FormatDateTime('yyyymmddhhnnss', Now);
      // Make Host data.
      yyyy := StrToInt(Copy(FMesHostDate,1,4));
      mm := StrToInt(Copy(FMesHostDate,5,2));
      dd := StrToInt(Copy(FMesHostDate,7,2));
      hh := StrToInt(Copy(FMesHostDate,9,2));
      nn := StrToInt(Copy(FMesHostDate,11,2));
      ss := StrToInt(Copy(FMesHostDate,13,2));
      SetDateTime(yyyy,mm,dd,hh,nn,ss,0);
			//
      sSendMsg := 'EDTI' ;
      sSendMsg := sSendMsg  + ' ADDR=' + m_sLocal + ',' + m_sLocal;
      sSendMsg := sSendMsg  + ' EQP=' + FSystemNo;
      sSendMsg := sSendMsg  + ' USER_ID=' + FUserId ;
      sSendMsg := sSendMsg  + ' OLD_DATE=' + sOldDate;
      sSendMsg := sSendMsg  + ' NEW_DATE=' + FormatDateTime('yyyymmddhhnnss', Now) ;
      sSendMsg := sSendMsg  + ' MODE=AUTO';
      sSendMsg := sSendMsg  + ' CLIENT_DATE='+FormatDateTime('yyyymmddhhnnss', Now);
    end;
		//
    DefGmes.MES_EQCC : begin
      sSendMsg := 'EQCC';
      sSendMsg := sSendMsg  + ' EQP=' + FSystemNo;
      sSendMsg := sSendMsg  + ' USER_ID=' + FUserId ;
      sSendMsg := sSendMsg  + ' MODE=AUTO';
      sSendMsg := sSendMsg  + ' CLIENT_DATE='+FormatDateTime('yyyymmddhhnnss', Now);
    end;
    else begin
      //TBD:GMES? (Not Supported MsgType?)
    end;
  end;

  if FCanUseHost then begin
    if bIsChMsg then begin
    //if (Common.MesData[nCh].MesSentMsg <> MES_UNKNOWN) then begin
    //  // 2018-06-28:OPTIC:BCR Retry하면서 2번 보내는 경우 2번쨰 무시하기 위함
    //  Exit;
    //end;
      if (not bIsDelayed) and IsMesWaiting(bIsChMsg,nCh) then begin
{$IFDEF INSPECTOR_POCB}
        if nCh in [DefPocb.CH_1..DefPocb.CH_MAX] then begin
{$ELSE}
        if nCh in [DefCommon.CH1..DefCommon.MAX_CH] then begin
{$ENDIF}
          Common.MesData[nCh].MesPendingMsg := nMsgType;
        //Common.MesData[nCh].MesSentMsg    := MES_UNKNOWN;
          Common.MesData[nCh].SerialNo      := sSerialNo;
          Common.MesData[nCh].CarrierId     := sZigId;
        //Common.MesData[nCh].MesSendRcvWaitTick := 0;   //  1 tick = 100 msec
          if not tmGmesChMsg.Enabled then tmGmesChMsg.Enabled := True;
          Exit;
        end;
      end;
      Common.MesData[nCh].MesSentMsg    := nMsgType;
      Common.MesData[nCh].MesPendingMsg := MES_UNKNOWN;
      Common.MesData[nCh].SerialNo      := sSerialNo;
      Common.MesData[nCh].CarrierId     := sZigId;
      Common.MesData[nCh].MesSendRcvWaitTick := 0;   //  1 tick = 100 msec
      if (not tmGmesChMsg.Enabled) then tmGmesChMsg.Enabled := True;
    end;
{$IFDEF USE_EAS}
    case nMsgType of
     DefGmes.EAS_APDR: bRtn := easCommTibRv.MessageSend(sSendMsg, m_sEasRemote);
     else              bRtn := mesCommTibRv.MessageSend(sSendMsg, m_sRemote);
    end;
{$ELSE}
    bRtn := mesCommTibRv.MessageSend(sSendMsg, m_sRemote);
{$ENDIF}
  end
  else begin
    bRtn := False;
  end;
	//
  if bIsChMsg then begin
    if (not tmGmesChMsg.Enabled) then tmGmesChMsg.Enabled := True;
    case nMsgType of
     DefGmes.MES_APDR: sSendMsg := 'MES ' + sSendMsg;
     DefGmes.EAS_APDR: sSendMsg := 'EAS ' + sSendMsg;
    end;
		//
  	sDebug := StringReplace(sSendMsg,#$0a, #$24, [rfReplaceAll]);
  	sDebug := StringReplace(sDebug,#$0d, #$25, [rfReplaceAll]);
    if not bRtn then Common.MLog(nCh,'TibRvError: '+sSendMsg)
    else             Common.MLog(nCh,sSendMsg);
  end;
end;

function TGmes.MakeSerialParams(nCh: Integer; nMsgType: Integer; sSerialNo: string): string;
var
  sRet : string;
  MES_PCHK_SN_TYPE : Integer;
begin
  sRet := '';
  
{$IF Defined(PANEL_AUTO)}
  MES_PCHK_SN_TYPE := DefGmes.BCR_TYPE_PID;      //Auto
	{$IFDEF FEATURE_BCR_SCAN_SPCB}
  if Common.TestModelInfo2[nCh].BcrScanMesSPCB then MES_PCHK_SN_TYPE := DefGmes.BCR_TYPE_SPCB; //A2CHv4
	{$ENDIF}
{$ELSEIF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
  MES_PCHK_SN_TYPE := DefGmes.BCR_TYPE_FOG_ID;   //Foldable, Mobile
{$ELSEIF Defined(ISPD_EEPROM)}
  MES_PCHK_SN_TYPE := DefGmes.BCR_TYPE_FOG_ID;   //Foldable, Mobile
{$ELSE}
  MES_PCHK_SN_TYPE := DefGmes.BCR_TYPE_PID;
{$IFEND}

  //
  case MES_PCHK_SN_TYPE of
    DefGmes.BCR_TYPE_PID: begin  //A2CH|A2CHv2
      sRet := sRet  + ' PID=' + sSerialNo;
      sRet := sRet  + ' SERIAL_NO=';
      sRet := sRet  + ' LCM_ID=';
      sRet := sRet  + ' FOG_ID=';
      sRet := sRet  + ' BLID=[]';
      if (nMsgType = DefGmes.MES_EICR) or (nMsgType = DefGmes.MES_RPR_EIJR) then
        sRet := sRet  + ' CGID='
      else
        sRet := sRet  + ' COVER_GLASS_ID=';
      sRet := sRet  + ' PCBID=';
    end;
    DefGmes.BCR_TYPE_SERIAL_NO: begin
      sRet := sRet  + ' PID=';
      sRet := sRet  + ' SERIAL_NO=' + sSerialNo;
      sRet := sRet  + ' LCM_ID=';
      sRet := sRet  + ' FOG_ID=';
      sRet := sRet  + ' BLID=[]';
      if (nMsgType = DefGmes.MES_EICR) or (nMsgType = DefGmes.MES_RPR_EIJR) then
        sRet := sRet  + ' CGID='
      else
        sRet := sRet  + ' COVER_GLASS_ID=';
      sRet := sRet  + ' PCBID=';
    end;
    DefGmes.BCR_TYPE_LCM_ID: begin
      sRet := sRet  + ' PID=';
      sRet := sRet  + ' SERIAL_NO=';
      sRet := sRet  + ' LCM_ID=' + sSerialNo;
      sRet := sRet  + ' FOG_ID=';
      if (nMsgType = DefGmes.MES_EICR) or (nMsgType = DefGmes.MES_RPR_EIJR) then
        sRet := sRet  + ' CGID='
      else
        sRet := sRet  + ' COVER_GLASS_ID=';
      sRet := sRet  + ' PCBID=';
    end;
    DefGmes.BCR_TYPE_FOG_ID: begin  //F2CH
      case nMsgType of
{$IFDEF USE_MES_APDR}
        DefGmes.MES_APDR,
{$ENDIF}
        DefGmes.EAS_APDR: sRet := sRet  + ' PID=' + Common.MesData[nCh].PchkRtnPid;  //TBD?
        else sRet := sRet  + ' PID=';
      end;
      sRet := sRet  + ' SERIAL_NO=';
      sRet := sRet  + ' LCM_ID=';
      sRet := sRet  + ' FOG_ID=' + sSerialNo;
      sRet := sRet  + ' BLID=[]';
      case nMsgType of
        DefGmes.MES_EICR, DefGmes.MES_RPR_EIJR,
{$IFDEF USE_MES_APDR}
        DefGmes.MES_APDR,
{$ENDIF}
        DefGmes.EAS_APDR: sRet := sRet  + ' CGID=';
        else sRet := sRet  + ' COVER_GLASS_ID=';
      end;
      sRet := sRet  + ' PCBID=';
    end;
    DefGmes.BCR_TYPE_BLID: begin
      sRet := sRet  + ' PID=';
      sRet := sRet  + ' SERIAL_NO=';
      sRet := sRet  + ' LCM_ID=';
      sRet := sRet  + ' FOG_ID=';
      sRet := sRet  + ' BLID=[' + sSerialNo + ']';
      case nMsgType of
        DefGmes.MES_EICR, DefGmes.MES_RPR_EIJR,
{$IFDEF USE_MES_APDR}
        DefGmes.MES_APDR,
{$ENDIF}
        DefGmes.EAS_APDR: sRet := sRet  + ' CGID=';
        else sRet := sRet  + ' COVER_GLASS_ID=';
      end;
      sRet := sRet  + ' PCBID=';
    end;
    DefGmes.BCR_TYPE_CGID: begin
      sRet := sRet  + ' PID=';
      sRet := sRet  + ' SERIAL_NO=';
      sRet := sRet  + ' LCM_ID=';
      sRet := sRet  + ' FOG_ID=';
      sRet := sRet  + ' BLID=[]';
      case nMsgType of
        DefGmes.MES_EICR, DefGmes.MES_RPR_EIJR,
{$IFDEF USE_MES_APDR}
        DefGmes.MES_APDR,
{$ENDIF}
        DefGmes.EAS_APDR: sRet := sRet  + ' CGID=' + sSerialNo;
        else sRet := sRet  + ' COVER_GLASS_ID=' + sSerialNo;
      end;
      sRet := sRet  + ' PCBID=';
    end;
    DefGmes.BCR_TYPE_SPCB: begin  //2021-12-21 (A2CHv4: SPCB -> PCBID)
      case nMsgType of
        DefGmes.MES_PCHK, DefGmes.MES_INS_PCHK: sRet := sRet  + ' PID=';
        else                                    sRet := sRet  + ' PID=' + Common.MesData[nCh].PchkRtnPid;
      end;
      sRet := sRet  + ' SERIAL_NO=';
      sRet := sRet  + ' LCM_ID=';
      sRet := sRet  + ' FOG_ID=';
      sRet := sRet  + ' BLID=[]';
      case nMsgType of
        DefGmes.MES_EICR, DefGmes.MES_RPR_EIJR,
{$IFDEF USE_MES_APDR}
        DefGmes.MES_APDR,
{$ENDIF}
        DefGmes.EAS_APDR: sRet := sRet  + ' CGID=';
        else              sRet := sRet  + ' COVER_GLASS_ID=';
      end;
      sRet := sRet  + ' PCBID=' + sSerialNo; //2021-12-21 (A2CHv4: SPCB -> PCBID)
    end
    else begin
      sRet := sRet  + ' PID=' + sSerialNo;
      sRet := sRet  + ' SERIAL_NO=';
      sRet := sRet  + ' LCM_ID=';
      sRet := sRet  + ' FOG_ID=';
      sRet := sRet  + ' BLID=[]';
      case nMsgType of
        DefGmes.MES_EICR, DefGmes.MES_RPR_EIJR,
{$IFDEF USE_MES_APDR}
        DefGmes.MES_APDR,
{$ENDIF}
        DefGmes.EAS_APDR: sRet := sRet  + ' CGID=';
        else sRet := sRet  + ' COVER_GLASS_ID=';
      end;
      sRet := sRet  + ' PCBID=';
    end;
  end;
  Result := sRet;
end;

//==============================================================================
// RECEIVE
//==============================================================================

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------

procedure TGmes.ReadMsgHost(ASender: TObject; const sMessage: WideString);
begin
  {$IF Defined(SITE_LGDPJ) or Defined(SITE_LGDGM)}
  GetHostData(sMessage); //LGDPJ|LGDGM
  {$ELSE}
  GetHostData(UTF8ToString(sMessage)); //LGDVH|LENSVN
  {$ENDIF}
end;

procedure TGmes.GetHostData(sMsg: string);
var
  sMsgName	: string;
  nRtnCh   	: Integer;
begin
  if Length(sMsg) < 6 then Exit;
  sMsgName := Copy(sMsg,1,6);
  SeperateData(sMsg,nRtnCh);
	//
  if      CompareStr(sMsgName,'PCHK_R') = 0 then parse_PCHK(nRtnCh,sMsg)
  else if CompareStr(sMsgName,'EICR_R') = 0 then parse_EICR(nRtnCh,sMsg)
  else if CompareStr(sMsgName,'APDR_R') = 0 then parse_APDR(nRtnCh,sMsg,True{bMes})
  else if CompareStr(sMsgName,'INS_PC') = 0 then parse_INS_PCHK(nRtnCh,sMsg)  //INS_PCHK_R
  else if CompareStr(sMsgName,'EIJR_R') = 0 then parse_EIJR(nRtnCh,sMsg)
  else if CompareStr(sMsgName,'RPR_EI') = 0 then parse_RPR_EIJR(nRtnCh,sMsg)  //RPR_EIJR_R
{$IFDEF IMD_FI}
	else if CompareStr(sMsgName,'TILR_R') = 0 then parse_TILR(nRtnCh,sMsg)
{$ENDIF}
  else if CompareStr(sMsgName,'ZSET_R') = 0 then parse_ZSET(nRtnCh,sMsg)
	//
	else if CompareStr(sMsgName,'EAYT_R') = 0 then parse_EAYT
  else if CompareStr(sMsgName,'UCHK_R') = 0 then parse_UCHK
  else if CompareStr(sMsgName,'EDTI_R') = 0 then parse_EDTI
  else if CompareStr(sMsgName,'EQCC_R') = 0 then parse_EQCC
  ;
end;

{$IFDEF USE_EAS}
procedure TGmes.ReadMsgEas(ASender: TObject; const sMessage: WideString);
begin
  GetEasData(sMessage);
end;

procedure TGmes.GetEasData(sMsg: string);
var
  sMsgName	: string;
  nRtnCh  	: Integer;
begin
  if Length(sMsg) < 6 then Exit;
  sMsgName := Copy(sMsg,1,6);
  SeperateData(sMsg,nRtnCh);
	//
  if CompareStr(sMsgName,'APDR_R') = 0 then parse_APDR(nRtnCh,sMsg,False{bMes});
end;
{$ENDIF}

procedure TGmes.SeperateData(sMsg: string; var nRtnCh: Integer);
var
  nSpacePos, nEqPos : Integer;
  sParamId,sParamCont, sNext, sMsgName : string;// AnsiString;
  sSubMsg, sRtnCh : string; //WideString;
begin
  sMsgName := Copy(sMsg,1,6);
  sSubMsg := trim(Copy(sMsg,7,Length(sMsg)-6));
  nEqPos := pos('=',sSubMsg);
  nSpacePos := pos(' ',sSubMsg);
  nRtnCh := -1;  sRtnCh := '';
  repeat
    sParamId := Copy(sSubMsg,1,nEqPos-1);
    sParamCont := Copy(sSubMsg,nEqPos+1,nSpacePos-nEqPos-1);
    sSubMsg := trim(Copy(sSubMsg,Length(sParamCont) + 2 + Length(sParamId) ,Length(sSubMsg)-Length(sParamCont)-1 - Length(sParamId)));
    nEqPos := pos('=',sSubMsg);
    if nEqPos = 0 then sParamCont := sParamCont +' '+ sSubMsg;
    nSpacePos := pos(' ',sSubMsg);
    while (nEqPos > nSpacePos) and (nSpacePos > 0) do begin
      sNext := Copy(sSubMsg,1,nSpacePos-1);
      sParamCont := sParamCont +' '+ sNext;
      sSubMsg := Copy(sSubMsg,Length(sNext)+2,Length(sSubMsg)-Length(sNext));
      nEqPos := pos('=',sSubMsg);
      nSpacePos := pos(' ',sSubMsg);
    end;
		//
    if      Uppercase(string(sParamId))= 'PID'            		then FMesPID          := Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'SERIAL_NO'					then FMesSerialNo    	:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'LCM_ID'							then FMesLcmId    		:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'FOG_ID'         		then FMesFogId     		:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'BLID'         			then FMesBLID     		:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'CGID'         			then FMesCGID     		:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'COVER_GLASS_ID'     then FMesCGID     		:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'PCBID'              then FMesPCBID     		:= Trim(string(sParamCont))
		else if Uppercase(string(sParamId))= 'RTN_CD'         		then FMesRtnCd      	:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'ERR_MSG_LOC'    		then FMesErrMsgLoc  	:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'ERR_MSG_ENG'    		then FMesErrMsgEng  	:= Trim(string(sParamCont))
    {$IFNDEF SIMULATOR}
    else if Uppercase(string(sParamId))= 'RTN_PID'        		then FMesRtnPID     	:= Trim(string(sParamCont))
    {$ENDIF}
    else if UpperCase(string(sParamId))= 'RTN_SUB_PID'        then begin  //A2CHv3:ASSYPOCB:MES
      sParamCont := StringReplace(sParamCont,'[', '', [rfReplaceAll]);
      sParamCont := StringReplace(sParamCont,']', '', [rfReplaceAll]);
      FMesRtnSubPID := Trim(string(sParamCont));
    end
    else if Uppercase(string(sParamId))= 'RTN_SERIAL_NO'  		then FMesRtnSerialNo	:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'RTN_LCM_ID'  				then FMesRtnLcmId   	:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'RTN_BLID'  					then FMesRtnBLID    	:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'RTN_CGID'  					then FMesRtnCGID    	:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'RTN_COVER_GLASS_ID' then FMesRtnCGID    	:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'RTN_PCBID'          then FMesRtnPCBID    	:= Trim(string(sParamCont))
    else if UpperCase(string(sParamId))= 'INSPCHANEL_A'   		then sRtnCh         	:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'USER_NAME'      		then FMesUserName     := Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'HOST_DATE'      		then FMesHostDate     := Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'MODEL'          		then FMesRtnModel  		:= Trim(string(sParamCont))
    else if Uppercase(string(sParamId))= 'PF'                 then FMesPf           := Trim(string(sParamCont))
    ;
  Until nEqPos = 0 ;
  if sRtnCh <> '' then begin
    nRtnCh := StrToIntDef(sRtnCh, 0) - 1; //INSPCHANEL_A=1~(sRtnCh), nRtnCh:0~ 
  end;
  // 영어 Error Message가 정상적으로 뜨지 않아 수동으로 재정리.
  nEqPos := Pos('ERR_MSG_ENG',sMsg)+1+Length('ERR_MSG_ENG');
  if nEqPos <> 0 then begin
    sSubMsg := Copy(sMsg,nEqPos,Length(sMsg)-nEqPos);
    nSpacePos := Pos(']', sSubMsg);
    FMesErrMsgEng := Copy(sSubMsg,2,nSpacePos-2);
  end
  else
    FMesErrMsgEng := '';
  FMesErrMsgEng := StringReplace(FMesErrMsgEng,'[','', [rfReplaceAll]);
  FMesErrMsgEng := StringReplace(FMesErrMsgEng,']','', [rfReplaceAll]);
  FMesErrMsgLoc := StringReplace(FMesErrMsgLoc,'[','', [rfReplaceAll]);
  FMesErrMsgLoc := StringReplace(FMesErrMsgLoc,']','', [rfReplaceAll]);
end;

function TGmes.GetMesRxCh(nRtnCh: Integer; var nCh: Integer): Boolean;
var
  MES_PCHK_SN_TYPE : Integer;
	sSerialNo, sDebug : string;
	bRet : Boolean;
  i : Integer;
begin
	nCh  := -1;	//abnormal

{$IF Defined(PANEL_AUTO)}
  MES_PCHK_SN_TYPE := DefGmes.BCR_TYPE_PID;      //Auto
	{$IFDEF FEATURE_BCR_SCAN_SPCB}
  if Common.TestModelInfo2[nCh].BcrScanMesSPCB then MES_PCHK_SN_TYPE := DefGmes.BCR_TYPE_SPCB; //A2CHv4
	{$ENDIF}
{$ELSEIF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
  MES_PCHK_SN_TYPE := DefGmes.BCR_TYPE_FOG_ID;   //Foldable, Mobile
{$ELSEIF Defined(ISPD_EEPROM)}
  MES_PCHK_SN_TYPE := DefGmes.BCR_TYPE_FOG_ID;   //Foldable, Mobile
{$ELSE}
  MES_PCHK_SN_TYPE := DefGmes.BCR_TYPE_PID;
{$ENDIF}

  case MES_PCHK_SN_TYPE of
    DefGmes.BCR_TYPE_PID: 			sSerialNo := FMesPID;
    DefGmes.BCR_TYPE_SERIAL_NO:	sSerialNo := FMesSerialNo;
    DefGmes.BCR_TYPE_LCM_ID:		sSerialNo := FMesLcmId;
    DefGmes.BCR_TYPE_FOG_ID:		sSerialNo := FMesFogId;
    DefGmes.BCR_TYPE_BLID:			sSerialNo := FMesBLID;
    DefGmes.BCR_TYPE_CGID:			sSerialNo := FMesCGID;
    DefGmes.BCR_TYPE_SPCB:			sSerialNo := FMesPCBID;
		else Exit(False);
	end;
	//
  sSerialNo := StringReplace(sSerialNo, #$0a, #$24, [rfReplaceAll]);
  sSerialNo := StringReplace(sSerialNo, #$0d, #$25, [rfReplaceAll]);
{$IFDEF INSPECTOR_POCB}
  if nRtnCh in [DefPocb.CH_1..DefPocb.CH_MAX] then begin
{$ELSE}
  if nRtnCh in [DefCommon.CH1..DefCommon.MAX_CH] then begin
{$ENDIF}
    nCh := nRtnCh;
	end
	else begin
    nCh := FMesCh;	//for default?
{$IFDEF INSPECTOR_POCB}
    for i := DefPocb.CH_1 to DefPocb.CH_MAX do begin
{$ELSE}
    for i := DefCommon.CH1 to DefCommon.MAX_CH do begin
{$ENDIF}
{$IFDEF IMD_FI}	//IFNDEF ISPD_L_OPTIOC
      if pred(Common.SystemInfo.ChCountUsed) < i then break;
{$ENDIF}
      if sSerialNo = Common.MesData[i].TxSerial then begin
        nCh := i;
        Break;
      end;
    end;
  end;
	//2019-07-05 TBD:GMES:RXCH? (디버깅을 위한 Check루틴)
	//
	Result := True; 
end;

//------------------------------------------------------------------------------
// MES Messages (Channel-base)
//------------------------------------------------------------------------------

procedure TGmes.parse_APDR(nRtnCh: Integer; sMsg: string; bMes: Boolean);
var
  nCh			: Integer;
	ErrMsg 	: string;
begin
	if not GetMesRxCh(nRtnCh,nCh) then Exit;
  if bMes then begin
    if Common.MesData[nCh].MesSentMsg <> MES_APDR then begin Common.MLog(nCh,'MES '+sMsg+'...ignore'); Exit; end;  //2019-09-18
  end
  else begin
    if Common.MesData[nCh].MesSentMsg <> EAS_APDR then begin Common.MLog(nCh,'EAS '+sMsg+'...ignore'); Exit; end;  //2019-09-18
  end;
  //
  Common.MesData[nCh].MesSentMsg    := MES_UNKNOWN;
//Common.MesData[nCh].MesPendingMsg	:= MES_UNKNOWN;
  if bMes then begin Common.MesData[nCh].MesApdrRtnCd := FMesRtnCd; Common.MLog(nCh,'MES '+sMsg); end  // (MES) APDR_R.RTN_CD
  else         begin Common.MesData[nCh].EasApdrRtnCd := FMesRtnCd;	Common.MLog(nCh,'EAS '+sMsg); end; // (EAS) APDR_R.RTN_CD
  //
	if FMesRtnCd = '0' then begin
{$IFDEF USE_MES_APDR}
    if bMes then ReturnDataToTestForm(DefGmes.MES_APDR, nCh, False{bError}, 'MES APDR OK')
    else         ReturnDataToTestForm(DefGmes.EAS_APDR, nCh, False{bError}, 'EAS APDR OK');
{$ELSE}
    ReturnDataToTestForm(DefGmes.EAS_APDR, nCh, False{bError}, 'EAS APDR OK');
{$ENDIF}
	end
	else begin
		ErrMsg := 'Error code:'+FMesRtnCd+' : '+ FMesErrMsgLoc + '('+ FMesErrMsgEng + ')';
{$IFDEF USE_MES_APDR}
    if bMes then ReturnDataToTestForm(DefGmes.MES_APDR, nCh, True{bError}, ErrMsg)
    else         ReturnDataToTestForm(DefGmes.EAS_APDR, nCh, True{bError}, ErrMsg);
{$ELSE}
    ReturnDataToTestForm(DefGmes.EAS_APDR, nCh, True{bError}, ErrMsg);
{$ENDIF}
	end;
end;

procedure TGmes.parse_EICR(nRtnCh: Integer; sMsg: string);
var
  nCh  		: Integer;
  ErrMsg 	: string;
begin
	if not GetMesRxCh(nRtnCh,nCh) then Exit;
  if Common.MesData[nCh].MesSentMsg <> MES_EICR then begin Common.MLog(nCh,sMsg+'...ignore'); Exit; end;  //2019-09-18
  //
  Common.MesData[nCh].MesSentMsg    := MES_UNKNOWN;
//Common.MesData[nCh].MesPendingMsg := MES_UNKNOWN;
  Common.MesData[nCh].EicrRtnCd    	:= FMesRtnCd;   // EICR_R.RTN_CD
  Common.MLog(nCh,sMsg);
	//
  if FMesRtnCd = '0' then begin
    ReturnDataToTestForm(DefGmes.MES_EICR, nCh, False{bError}, 'EICR OK');
  end
  else begin
    ErrMsg := 'Error code:'+FMesRtnCd+' : '+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
    ReturnDataToTestForm(DefGmes.MES_EICR, nCh, True{bError}, ErrMsg);
  //OnGmsEvent(DefGmes.MES_EICR, 0,	True{bError}, ErrMsg);	//TBD?
  end;
end;

procedure TGmes.parse_EIJR(nRtnCh: Integer; sMsg: string);
var
  nCh 		: Integer;
  ErrMsg 	: string;
begin
	if not GetMesRxCh(nRtnCh,nCh) then Exit;
  if Common.MesData[nCh].MesSentMsg <> MES_EIJR then begin Common.MLog(nCh,sMsg+'...ignore'); Exit; end;  //2019-09-18
  //
  Common.MesData[nCh].MesSentMsg     := MES_UNKNOWN;
//Common.MesData[nCh].MesPendingMsg  := MES_UNKNOWN;
//Common.MesData[nCh].EijrRtnCd    	:= FMesRtnCd;   // EIJR_R.RTN_CD  //TBD:GMES:EIJR
//FEiJRSend := False; ?
  Common.MLog(nCh,sMsg);
	//
  if FMesRtnCd = '0' then begin
    ReturnDataToTestForm(DefGmes.MES_EIJR, nCh, False{bError}, 'EIJR OK');
  end
  else begin
    ErrMsg := 'Error code:'+FMesRtnCd+' : '+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
    ReturnDataToTestForm(DefGmes.MES_EIJR, nCh, True{bError}, ErrMsg);
  end;
end;

procedure TGmes.parse_PCHK(nRtnCh: Integer; sMsg: string); //A2CHv3:MULTIPLE_MODEL
var
  nCh			: Integer;
	ErrMsg 	: string;
  sRCP, sRtnRCP : string;
  sProcCode, sRtnProcCode, sPidFromBcr : string;
  sList : TStringList;
begin
	if not GetMesRxCh(nRtnCh,nCh) then Exit;
  if Common.MesData[nCh].MesSentMsg <> MES_PCHK then begin Common.MLog(nCh,sMsg+'...ignore'); Exit; end;  //2019-09-18

{$IFDEF SIMULATOR_GMES}
	{$IFDEF FEATURE_BCR_SCAN_SPCB}
  if Common.TestModelInfo2[nCh].BcrScanMesSPCB then begin
    if (nCh = DefPOCB.CH_1) then FMesRtnPID := 'POCBSIMRTNPID1'
    else                         FMesRtnPID := 'POCBSIMRTNPID2';
  end;
	{$ENDIF}
{$ENDIF}
  //
  Common.MesData[nCh].MesSentMsg      := MES_UNKNOWN;
//Common.MesData[nCh].MesPendingMsg   := MES_UNKNOWN;
  Common.MesData[nCh].PchkRtnCd	      := FMesRtnCd;     // PCHK_R.RTN_CD
  Common.MesData[nCh].PchkRtnSerialNo := FMesSerialNo;  // PCHK_R.RTN_SERIAL_NO	--> PchkRtnSerialNo? RtnSerialNo?
  if FMesRtnPID <> '' then begin
    Common.MesData[nCh].PchkRtnPid    := FMesRtnPID;    // PCHK_R.RTN_PID
    Common.MesData[nCh].bRxPchkRtnPid := True;
  end;
  Common.MesData[nCh].PchkRtnPcbid    := FMesRtnPCBID;  // PCHK_R.RTN_PCBID
  Common.MesData[nCh].PchkRtnModel    := FMesRtnModel;  // PCHK_R.MODEL    2019-07-25
//Common.MesData[nCh].bPCHK := True;
  if Pos('-',FMesRtnModel) <> 0 then begin
		Common.MesData[nCh].Model := Copy(FMesRtnModel, 0, 8);
{$IFDEF USE_DFS}
  end
  else begin
    if Length(Common.CombiCodeData.sRcpName[nCh]) > 8 then Common.MesData[nCh].Model := Copy(Common.CombiCodeData.sRcpName[nCh], 0, 8)
    else                                                   Common.MesData[nCh].Model := Common.CombiCodeData.sRcpName[nCh];
{$ENDIF}
  end;
  Common.MLog(nCh,sMsg);
  //
{$IFNDEF FEATURE_BCR_SCAN_SPCB} //A2CHv4: DELETED_20211223
  if Trim(Common.MesData[nCh].PchkRtnPid) = '' then begin
    try
      sList := TStringList.Create;
      try
        ExtractStrings(['-'],[],PWideChar(Common.MesData[nCh].TXSerial),sList);
        sPidFromBcr := sList[0];
        Common.MesData[nCh].PchkRtnPid    := sPidFromBcr;
        Common.MesData[nCh].bRxPchkRtnPid := False; //TBD:MERGE?
      except
      end;
    finally
      sList.Free;
    end;
  end;
{$ENDIF}
  //
	if FMesRtnCd = '0' then begin
{$IFDEF MES_INTERLOCK}
  	// 2019-05-22 ksw : Interlock 기능 (Rcp, Process Code) 모두 해제 --> 현장 검증 후 적용 바람 (추후 TAB 공정까지 확대 가능성 있음)
		// Get Model RCP (Combi.RcpName, MES XXXX_R.?????)  Ex) LH588WF1-SD02
		sRCP := ''; sRtnRCP := '';
		if (Common.SystemInfo.ProcessName = 'FI') or (Common.SystemInfo.ProcessName = 'FP') or
			(Common.SystemInfo.ProcessName = 'FM') or (Common.SystemInfo.ProcessName = 'FR') then begin
			if Pos('-',FMesRtnModel) <> 0 then begin
				sRCP 		:= Copy(Common.CombiCodeData.sRcpName, 0, 8);
				sRtnRCP := Copy(FMesRtnModel, 0, 8);
			end;
		end;
		// Get ProcessNo (Combi.ProcessNo, MES XXXX_R.?????? 공정번호 InterLock. Process Code 비교. Ex) 33830
		sProcCode := ''; sRtnProcCode := '';
		if FMesRtnProcess <> '' then begin
			sProcCode 	 := Common.CombiCodeData.sProcessNo;
			sRtnProcCode := FMesRtnProcess;
		end;
    // Interlock (Model Rcp and Process Code)
		if (sRCP <> sRtnRCP) then begin
			ErrMsg := Format('Model RCP is different!! Setting RCP(%s), MES Return RCP(%s)',[sRCP, sRtnRCP]);
			ReturnDataToTestForm(DefGmes.MES_PCHK, nCh, True{bError}, ErrMsg);
		end
		else if (sProcCode <> sRtnProcCode) then begin
			ErrMsg := Format('Process Code is different!! Setting Code(%s), MES Return Code(%s)',[sProcCode, sRtnProcCode]);
			ReturnDataToTestForm(DefGmes.MES_PCHK, nCh, True{bError}, ErrMsg);
		end
		else begin 	// (sRCP = sRtnRCP) and (sProcCode = sRtnProcCode) {FMesPf <> 'F' }
			ReturnDataToTestForm(DefGmes.MES_PCHK, nCh, False{bError}, 'PCHK OK');
		end;
{$ELSE}
		ReturnDataToTestForm(DefGmes.MES_PCHK, nCh, False{bError}, 'PCHK OK');
{$ENDIF}
	end
	else begin
		ErrMsg := 'Error code:'+FMesRtnCd+':'+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
		ReturnDataToTestForm(DefGmes.MES_PCHK, nCh, True, ErrMsg);
	end;
end;

procedure TGmes.parse_INS_PCHK(nRtnCh: Integer; sMsg: string);  //A2CHv3:MULTIPLE_MODEL
var
  nCh			: Integer;
	ErrMsg 	: string;
  sRCP, sRtnRCP : string;
  sProcCode, sRtnProcCode, sPidFromBcr : string;
  sList : TStringList;
begin
	if not GetMesRxCh(nRtnCh,nCh) then Exit;
  if Common.MesData[nCh].MesSentMsg <> MES_INS_PCHK then begin Common.MLog(nCh,sMsg+'...ignore'); Exit; end;

{$IFDEF SIMULATOR_GMES}
  {$IFDEF SUPPORT_1CG2PANEL}
  if Common.SystemInfo.UseAssyPOCB then begin
    if (nCh = DefPOCB.CH_1) then FMesRtnSubPID := 'POCBSIMCH2222'
    else                         FMesRtnSubPID := 'POCBSIMCH1111';
  end;
  {$ENDIF}
  {$IFDEF FEATURE_BCR_SCAN_SPCB}
  if Common.TestModelInfo2[nCh].BcrScanMesSPCB then begin
    if (nCh = DefPOCB.CH_1) then FMesRtnPID := 'POCBSIMRTNPID1'
    else                         FMesRtnPID := 'POCBSIMRTNPID2';
  end;
  {$ENDIF}
{$ENDIF}

  //
  Common.MesData[nCh].MesSentMsg      := MES_UNKNOWN;
//Common.MesData[nCh].MesPendingMsg   := MES_UNKNOWN;
  Common.MesData[nCh].PchkRtnCd	      := FMesRtnCd;     // PCHK_R.RTN_CD
  Common.MesData[nCh].PchkRtnSerialNo := FMesSerialNo;  // PCHK_R.RTN_SERIAL_NO	--> PchkRtnSerialNo? RtnSerialNo?
  if FMesRtnPID <> '' then begin
    Common.MesData[nCh].PchkRtnPid    := FMesRtnPID;    // PCHK_R.RTN_PID
    Common.MesData[nCh].bRxPchkRtnPid := True;
  end;
  Common.MesData[nCh].PchkRtnPcbid    := FMesRtnPCBID;  // PCHK_R.RTN_PCBID  2021-12-21	--> PchkRtnPID? RtnPID?
  Common.MesData[nCh].PchkRtnModel    := FMesRtnModel;  // PCHK_R.MODEL    2019-07-25
  Common.MesData[nCh].PchkRtnSubPid   := FMesRtnSubPID; //A2CHv3:ASSYPOCB:MES
//Common.MesData[nCh].bPCHK := True;

  if Pos('-',FMesRtnModel) <> 0 then begin
		Common.MesData[nCh].Model := Copy(FMesRtnModel, 0, 8);
{$IFDEF USE_DFS}
  end
  else begin
    if Length(Common.CombiCodeData.sRcpName[nCh]) > 8 then Common.MesData[nCh].Model := Copy(Common.CombiCodeData.sRcpName[nCh], 0, 8)  // A2CHv3:MULTIPLE_MODEL
    else                                                   Common.MesData[nCh].Model := Common.CombiCodeData.sRcpName[nCh];
{$ENDIF}
  end;
  Common.MLog(nCh,sMsg);
  //
{$IFNDEF FEATURE_BCR_SCAN_SPCB} //A2CHv4: DELETED_20211223
  if Trim(Common.MesData[nCh].PchkRtnPid) = '' then begin
    try
      sList := TStringList.Create;
      try
        ExtractStrings(['-'],[],PWideChar(Common.MesData[nCh].TXSerial),sList);
        sPidFromBcr := sList[0];
        Common.MesData[nCh].PchkRtnPid    := sPidFromBcr;
        Common.MesData[nCh].bRxPchkRtnPid := False; //TBD:MERGE?
      except
      end;
    finally
      sList.Free;
    end;
  end;
{$ENDIF}
  //
	if FMesRtnCd = '0' then begin
    {$IFDEF SUPPORT_1CG2PANEL}
    if Common.SystemInfo.UseAssyPOCB and (Common.MesData[nCh].PchkRtnSubPid = '') then begin
      ErrMsg := '(INS_PCHK_R -- No SUB_PID) !!!';
		  ReturnDataToTestForm(DefGmes.MES_INS_PCHK, nCh, True{bError}, ErrMsg);
      Exit;
    end;
    {$ENDIF}
    {$IFDEF MES_INTERLOCK}
  	// 2019-05-22 ksw : Interlock 기능 (Rcp, Process Code) 모두 해제 --> 현장 검증 후 적용 바람 (추후 TAB 공정까지 확대 가능성 있음)
		// Get Model RCP (Combi.RcpName, MES XXXX_R.?????)  Ex) LH588WF1-SD02
		sRCP := ''; sRtnRCP := '';
		if (Common.SystemInfo.ProcessName = 'FI') or (Common.SystemInfo.ProcessName = 'FP') or
			(Common.SystemInfo.ProcessName = 'FM') or (Common.SystemInfo.ProcessName = 'FR') then begin
			if Pos('-',FMesRtnModel) <> 0 then begin
				sRCP 		:= Copy(Common.CombiCodeData.sRcpName[nCh], 0, 8);
				sRtnRCP := Copy(FMesRtnModel, 0, 8);
			end;
		end;
		// Get ProcessNo (Combi.ProcessNo, MES XXXX_R.?????? 공정번호 InterLock. Process Code 비교. Ex) 33830
		sProcCode := ''; sRtnProcCode := '';
		if FMesRtnProcess <> '' then begin
			sProcCode 	 := Common.CombiCodeData.sProcessNo;
			sRtnProcCode := FMesRtnProcess;
		end;
    // Interlock (Model Rcp and Process Code)
		if (sRCP <> sRtnRCP) then begin
			ErrMsg := Format('Model RCP is different!! Setting RCP(%s), MES Return RCP(%s)',[sRCP, sRtnRCP]);
			ReturnDataToTestForm(DefGmes.MES_INS_PCHK, nCh, True{bError}, ErrMsg);
		end
		else if (sProcCode <> sRtnProcCode) then begin
			ErrMsg := Format('Process Code is different!! Setting Code(%s), MES Return Code(%s)',[sProcCode, sRtnProcCode]);
			ReturnDataToTestForm(DefGmes.MES_INS_PCHK, nCh, True{bError}, ErrMsg);
		end
		else begin 	// (sRCP = sRtnRCP) and (sProcCode = sRtnProcCode) {FMesPf <> 'F' }
			ReturnDataToTestForm(DefGmes.MES_INS_PCHK, nCh, False{bError}, 'INS_PCHK OK');
		end;
    {$ELSE}
		ReturnDataToTestForm(DefGmes.MES_INS_PCHK, nCh, False{bError}, 'INS_PCHK OK');
    {$ENDIF} //MES_INTERLOCK
	end
	else begin
		ErrMsg := 'Error code:'+FMesRtnCd+':'+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
		ReturnDataToTestForm(DefGmes.MES_INS_PCHK, nCh, True, ErrMsg);
	end;
end;

procedure TGmes.parse_RPR_EIJR(nRtnCh: Integer; sMsg: string);
var
  nCh  		: Integer;
  ErrMsg 	: string;
begin
	if not GetMesRxCh(nRtnCh,nCh) then Exit;
  if Common.MesData[nCh].MesSentMsg <> DefGmes.MES_RPR_EIJR then begin Common.MLog(nCh,sMsg+'...ignore'); Exit; end;
  //
  Common.MesData[nCh].MesSentMsg    := DefGmes.MES_UNKNOWN;
//Common.MesData[nCh].MesPendingMsg := DefGmes.MES_UNKNOWN;
  Common.MesData[nCh].EicrRtnCd    	:= FMesRtnCd;   // RPR_EIJR_R.RTN_CD
  Common.MLog(nCh,sMsg);
	//
  if FMesRtnCd = '0' then begin
    ReturnDataToTestForm(DefGmes.MES_RPR_EIJR, nCh, False{bError}, 'RPR_EIJR OK');
  end
  else begin
    ErrMsg := 'Error code:'+FMesRtnCd+' : '+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
    ReturnDataToTestForm(DefGmes.MES_RPR_EIJR, nCh, True{bError}, ErrMsg);
  //OnGmsEvent(DefGmes.MES_RPR_EIJR, 0,	True{bError}, ErrMsg);	//TBD?
  end;
end;

{$IFDEF IMD_FI}
procedure TGmes.parse_TILR(nRtnCh: Integer; sMsg: string);
var
  ErrMsg : String;
  i, nCh : Integer;
  sSerialNo : string;
  sList : TStringList;
begin
	if not GetMesRxCh(nRtnCh,nCh) then Exit;
  if Common.MesData[nCh].MesSentMsg <> MES_TILR then begin Common.MLog(nCh,sMsg+'...ignore'); Exit; end;  //2019-09-18
  //
  Common.MesData[nCh].MesSentMsg      := MES_UNKNOWN;
//Common.MesData[nCh].MesPendingMsg   := MES_UNKNOWN;
  Common.MLog(nCh,sMsg);
  //
  ErrMsg := 'Error code:'+FMesRtnCd+' : '+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
  if trim(FMesRtnCd) = '0' then begin // OK
    if FMesObjCode <> '' then begin
      try
        sList := TStringList.Create;
        ExtractStrings([','],[','],PWideChar(FMesRtnInspInfo), sList);
        for i := 0 to Pred(sList.Count) do begin
          if Pos('DEFECT_LEVEL_FLAG', sList[i]) > 0 then begin
            FMesDefLevel := sList[i].Substring(Pos(':',sList[i]));
          end
          else if Pos('DEFECT_HANDO_FLAG', sList[i]) > 0 then begin
            FMesDefHando := sList[i].Substring(Pos(':',sList[i]));
          end;
        end;
      finally
        sList.Free;
        sList := nil;
      end;
      Common.MesData[nCh].bTILR     := True; // 표적검사 대상
      Common.MesData[nCh].ObjCode   := FMesObjCode;
      Common.MesData[nCh].ObjEng    := FMesObjEng;
      Common.MesData[nCh].ObjLoc    := FMesObjLoc;
      Common.MesData[nCh].MthdCode  := FMesMthdCode;
      Common.MesData[nCh].MthdEng   := FMesMthdEng;
      Common.MesData[nCh].MthdLoc   := FMesMthdLoc;
      Common.MesData[nCh].DefMulti  := FMesDefMulti;
      Common.MesData[nCh].DefLoc    := FMesDefLoc;
      Common.MesData[nCh].DefLevel  := FMesDefLevel;
      Common.MesData[nCh].DefHando  := FMesDefHando;
      Common.MesData[nCh].Calling   := FMesCalling;
    end;
    ReturnDataToTestForm(DefGmes.MES_TILR,nCh,False{bError},ErrMsg);
  end
  else begin  // NG
    ReturnDataToTestForm(DefGmes.MES_TILR,nCh,True{bError},ErrMsg);
  //OnGmsEvent(DefGmes.MES_TILR, 0,	True, ErrMsg);
  end;
end;
{$ENDIF}

procedure TGmes.parse_ZSET(nRtnCh: Integer; sMsg: string);
var
  nCh  		: Integer;
  ErrMsg 	: string;
begin
	if not GetMesRxCh(nRtnCh,nCh) then Exit;
  if Common.MesData[nCh].MesSentMsg <> MES_ZSET then begin Common.MLog(nCh,sMsg+'...ignore'); Exit; end;  //2019-09-18
  //
  Common.MesData[nCh].MesSentMsg     := MES_UNKNOWN;
//Common.MesData[nCh].MesPendingMsg  := MES_UNKNOWN;
  Common.MesData[nCh].ZsetRtnCd    	 := FMesRtnCd;   // ZSET_R.RTN_CD
  Common.MLog(nCh,sMsg);
	//
  if FMesRtnCd = '0' then begin
    ReturnDataToTestForm(DefGmes.MES_ZSET, nCh, False{bError}, 'ZSET OK');
  end
  else begin
    ErrMsg := 'Error code:'+FMesRtnCd+' : '+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
    ReturnDataToTestForm(DefGmes.MES_ZSET, nCh, True{bError}, ErrMsg);
  //OnGmsEvent(DefGmes.MES_ZSET, 0,	True{bError}, ErrMsg);	//TBD?
  end;
end;

//------------------------------------------------------------------------------
// MES Messages (System-base)
//------------------------------------------------------------------------------

procedure TGmes.parse_EAYT;
var
	ErrMsg	: string;
begin
  if FMesRtnCd = '0' then begin
    FEayt := True;
    SEND_MESG2HOST(DefGmes.MES_UCHK);
    OnGmsEvent(DefGmes.MES_EAYT, 0, False{bError}, '');
  end
  else begin
		ErrMsg := 'Error code:'+FMesRtnCd+':'+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
    OnGmsEvent(DefGmes.MES_EAYT, 0,	True{bError}, ErrMsg);
  end;
end;

procedure TGmes.parse_EDTI;
var
	ErrMsg	: string;
begin
  if FMesRtnCd = '0' then begin 	// HOST Server Connected Successfully
    {$IFDEF REMOTE_UPDATE}
    FIsEdtiOn := True;
    {$ENDIF}
    OnGmsEvent(DefGmes.MES_EDTI, 0, False{bError}, '');
  end
  else begin 		// Error 처리 할것.
		ErrMsg := 'Error code:'+FMesRtnCd+':'+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
    OnGmsEvent(DefGmes.MES_EDTI, 0, True{bError}, ErrMsg);
  end;
end;

procedure TGmes.parse_EQCC;
var
	ErrMsg	: string;
begin
  if FMesRtnCd <> '0' then begin
		ErrMsg := 'Error code:'+FMesRtnCd+':'+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
    OnGmsEvent(DefGmes.MES_EQCC, 0, True{bError}, ErrMsg);
  end;
end;

procedure TGmes.parse_UCHK;
var
	ErrMsg : string;
begin
  if FMesRtnCd = '0' then begin
    MesHostDate := FMesHostDate;
    FPmMode := False;
    SEND_MESG2HOST(DefGmes.MES_EDTI);
 		ErrMsg := 'Error code:'+FMesRtnCd+':'+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
    OnGmsEvent(DefGmes.MES_UCHK, 0, False{bError}, ErrMsg);
  end
  else begin
		ErrMsg := 'Error code:'+FMesRtnCd+':'+FMesErrMsgLoc+'('+FMesErrMsgEng+')';
    OnGmsEvent(DefGmes.MES_UCHK, 0, True{bError}, ErrMsg);
  end;
end;

//==============================================================================
//
//==============================================================================

//procedure TGmes.OnEqccTimer(Sender: TObject);
//begin
//  SEND_MESG2HOST(DefGmes.MES_EQCC);
//end;
//

procedure TGmes.OnGemsResponseTimer(Sender: TObject);
begin
end;

procedure TGmes.OnGmesChMsgTimer(Sender: TObject);
var
  nCh : Integer;
  bWaitResponse  : Boolean;
  bStopTimer : Boolean;
begin
  // Check MES Timer Tick for each Ch
  bWaitResponse := False;
{$IFDEF INSPECTOR_POCB}
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
{$ELSE}
  for nCh := DefCommon.CH1 to DefCommon.MAX_CH do begin
{$ENDIF}
    //
    if (Common.MesData[nCh].MesSentMsg = MES_UNKNOWN) then Common.MesData[nCh].MesSendRcvWaitTick := 0
    else                                              Inc(Common.MesData[nCh].MesSendRcvWaitTick);
    //
    if Common.MesData[nCh].MesSendRcvWaitTick > 5*10 then begin
      Common.MesData[nCh].MesSendRcvWaitTick := 0; //2019-07-25
      if (Common.MesData[nCh].MesSentMsg = MES_PCHK) or (Common.MesData[nCh].MesPendingMsg = MES_PCHK) then begin
        Common.MesData[nCh].PchkSendNg:= True;
      //Common.MesData[nCh].bPCHK     := False;
        ReturnDataToTestForm(DefGmes.MES_PCHK, nCh, True{bError}, 'No Response');
      end
      else if (Common.MesData[nCh].MesSentMsg = MES_EICR) or (Common.MesData[nCh].MesPendingMsg = MES_EICR) then begin
        Common.MesData[nCh].EicrSendNg  := True;
        ReturnDataToTestForm(DefGmes.MES_EICR, nCh, True{bError}, 'No Response');
      end
      else if (Common.MesData[nCh].MesSentMsg = MES_ZSET) or (Common.MesData[nCh].MesPendingMsg = MES_ZSET) then begin
        Common.MesData[nCh].ZsetSendNg  := True;
        ReturnDataToTestForm(DefGmes.MES_ZSET, nCh, True{bError}, 'No Response');
      end
{$IFDEF USE_EAS}
{$IFDEF USE_MES_APDR}
      else if (Common.MesData[nCh].MesSentMsg = MES_APDR) or (Common.MesData[nCh].MesPendingMsg = MES_APDR) then begin
        Common.MesData[nCh].MesApdrSendNg := True;
        ReturnDataToTestForm(DefGmes.MES_APDR, nCh, True{bError}, 'No Response');
      end
{$ENDIF}
      else if (Common.MesData[nCh].MesSentMsg = EAS_APDR) or (Common.MesData[nCh].MesPendingMsg = EAS_APDR) then begin
        Common.MesData[nCh].EasApdrSendNg  := True;
        ReturnDataToTestForm(DefGmes.EAS_APDR, nCh, True{bError}, 'No Response');
      end
{$ENDIF}
      else if (Common.MesData[nCh].MesSentMsg = MES_INS_PCHK) or (Common.MesData[nCh].MesPendingMsg = MES_INS_PCHK) then begin  //2019-11-08
        Common.MesData[nCh].PchkSendNg:= True;
      //Common.MesData[nCh].bPCHK     := False;
        ReturnDataToTestForm(DefGmes.MES_INS_PCHK, nCh, True{bError}, 'No Response');
      end
      else if (Common.MesData[nCh].MesSentMsg = MES_RPR_EIJR) or (Common.MesData[nCh].MesPendingMsg = MES_RPR_EIJR) then begin  //2019-11-08
        Common.MesData[nCh].EicrSendNg  := True;
        ReturnDataToTestForm(DefGmes.MES_RPR_EIJR, nCh, True{bError}, 'No Response');
      end
      ;
    //Common.MesData[nCh].MesPendingMsg := MES_UNKNOWN;  //here!!!
      Common.MesData[nCh].MesSentMsg    := MES_UNKNOWN;  //here!!!
      //sDebug := Format('TGmes.OnGmesChMsgTimer: CH(%d) timeout ...TBD',[nCh]); Common.MLog(DefPocb.SYS_LOG,sDebug);
      Continue;
    end;
    //
    if Common.MesData[nCh].MesSentMsg <> MES_UNKNOWN then
      bWaitResponse := True;
  end;
  if bWaitResponse then begin
    //Common.MLog(DefCommon.SYS_LOG,'TGmes.OnGmesChMsgTimer: WaitResponse ...Exit');
    Exit;
  end;

  // Send MES Message if exist
{$IFDEF INSPECTOR_POCB}
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
{$ELSE}
  for nCh := DefCommon.CH1 to DefCommon.MAX_CH do begin
{$ENDIF}
    if Common.MesData[nCh].MesPendingMsg <> MES_UNKNOWN then begin
      case Common.MesData[nCh].MesPendingMsg of
        DefGmes.MES_PCHK : begin
          SendHostPChk(Common.MesData[nCh].SerialNo, nCh, True);
          Break;
        end;
        DefGmes.MES_EICR : begin
          SendHostEicr(Common.MesData[nCh].SerialNo, nCh, Common.MesData[nCh].CarrierId, True);
          Break;
        end;
        DefGmes.MES_ZSET : begin
          SendHostZset(Common.MesData[nCh].SerialNo, nCh, Common.MesData[nCh].CarrierId, True);
          Break;
        end;
        DefGmes.MES_INS_PCHK : begin  //For GIB (PCHK -> INS_PCHK)
          SendHostIns_Pchk(Common.MesData[nCh].SerialNo, nCh,True);
          Break;
        end;
        DefGmes.MES_RPR_EIJR : begin  //For GIB (EICR -> RPR_EIJR)
          SendHostRpr_Eijr(Common.MesData[nCh].SerialNo, nCh, Common.MesData[nCh].CarrierId, True);  //2019-11-08
          Break;
        end;
{$IFDEF USE_EAS}
{$IFDEF USE_MES_APDR}
        DefGmes.MES_APDR : begin
          SendHostApdr(Common.MesData[nCh].SerialNo, nCh,True);
          Break;
        end;
{$ENDIF}
        DefGmes.EAS_APDR : begin
          SendEasApdr(Common.MesData[nCh].SerialNo, nCh,True);
          Break;
        end;
{$ENDIF}
      end;
    end;
  end;

  // STOP if no more MES message send/receive
  bStopTimer := True;
{$IFDEF INSPECTOR_POCB}
  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
{$ELSE}
  for nCh := DefCommon.CH1 to DefCommon.MAX_CH do begin
{$ENDIF}
    if (Common.MesData[nCh].MesPendingMsg = MES_UNKNOWN) and (Common.MesData[nCh].MesSentMsg = MES_UNKNOWN) then
      Common.MesData[nCh].MesSendRcvWaitTick := 0
    else begin
      bStopTimer := False;
      Break;
    end;
  end;
  if bStopTimer then begin
    tmGmesChMsg.Enabled := False;
    //Common.MLog(DefCommon.SYS_LOG,'TGmes.OnGmesChMsgTimer: STOP TImer');
  end;
end;

function TGmes.IsMesWaiting(bIsChMsg : Boolean; nThisChNo : Integer): Boolean;
var
  nCh  : Integer;
  nRet : Boolean;
begin
  nRet := False;
  if bIsChMsg then begin
{$IFDEF INSPECTOR_POCB}
    for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
{$ELSE}
    for nCh := DefCommon.CH1 to DefCommon.MAX_CH do begin
{$ENDIF}
      if {2018-06-28:GB:Bcr Read Retry에 따라 2번 발생 (nPgNo <> nThisPgNo) and} 
				(Common.MesData[nCh].MesSentMsg <> MES_UNKNOWN) then
        nRet := True;
    end;
  end;
  Result := nRet;
end;

//==============================================================================
// GMES <-> FrmMain & TestCh
//==============================================================================

// GMES -> FrmMain
procedure TGmes.SetOnGmsEvent(const Value: TGmesEvent);
begin
  FOnGmsEvent := Value;
end;

{$IFDEF REMOTE_UPDATE}
procedure TGmes.SetIsEdtiOn(const Value: boolean);
begin
  FIsEdtiOn := Value;
end;

procedure TGmes.SetRcpInfo(const Value: string);
begin
  FRcpInfo := Value;
end;

procedure TGmes.SetRcpInfo2(const Value: string);
begin
  FRcpInfo2 := Value;
end;
{$ENDIF}

// GMES -> TestCh
procedure TGmes.ReturnDataToTestForm(nMode, nCh: Integer; bError: Boolean; sMsg: string);
var
  ccd         : TCopyDataStruct;
  HostUiMsg   : RSyncHost;
  nJig        : Integer;
begin
  HostUiMsg.MsgType := MSG_TYPE_HOST;
  HostUiMsg.MsgMode := nMode;
  HostUiMsg.Channel	:= nCh;
  HostUiMsg.bError  := bError;
  HostUiMsg.Msg     := sMsg;
  ccd.dwData        := 0;
  ccd.cbData        := SizeOf(HostUiMsg);
  ccd.lpData        := @HostUiMsg;
{$IFDEF INSPECTOR_POCB}
  nJig := nCh;	//POCB-specific
{$ELSE}
  nJig := nCh;	//default
{$ENDIF}

{$IF Defined(INSPECTOR_POCB)}
  SendMessage(hTestHandle[nJig],WM_COPYDATA,0,LongInt(@ccd));
{$ELSEIF Defined(IMD_FI) or Defined(ISPD_EEPROM)}
  SendMessage(hMainHandle ,WM_COPYDATA,0, LongInt(@ccd));
{$ELSE}	// IMD_GB|IMD_AC
  SendMessage(hTestHandle1 ,WM_COPYDATA,0, LongInt(@ccd));
{$IFEND}

{$IF not (Defined(INSPECTOR_POCB) or Defined(ISPD_EEPROM))}
  if bError then begin
    OnGmsEvent(nMode, 0,	True{bError}, sMsg);
  end;
{$IFEND}
end;

//==============================================================================
// ETC
//==============================================================================

function TGmes.GetLocalIp: string;
var
  pHostInfo : pHostEnt;
  pszHostName : array[0..40] of AnsiChar;
begin
  GetHostName(pszHostName, 40);
  pHostInfo := GetHostByName(pszHostName);
  if Assigned(pHostInfo) then
  begin
    Result := IntToStr(ord(pHostInfo.h_addr_list^[0])) + '.' +
              IntToStr(ord(pHostInfo.h_addr_list^[1])) + '.' +
              IntToStr(ord(pHostInfo.h_addr_list^[2])) + '.' +
              IntToStr(ord(pHostInfo.h_addr_list^[3]));
  end;
end;

procedure TGmes.SetDateTime(Year, Month, Day, Hour, Minu, Sec, MSec: Word);
var
  NewDateTime: TSystemTime;
begin
  try
    FillChar(NewDateTime, SizeOf(NewDateTime), #0);
    NewDateTime.wYear := Year;
    NewDateTime.wMonth := Month;
    NewDateTime.wDay := Day;
    NewDateTime.wHour := Hour;
    NewDateTime.wMinute := Minu;
    NewDateTime.wSecond := Sec;
    NewDateTime.wMilliseconds := MSec;

    SetLocalTime(NewDateTime);
  except
    OutputDebugString(PChar('Exception Error in SetDateTime()'));
  end;
end;

end.
