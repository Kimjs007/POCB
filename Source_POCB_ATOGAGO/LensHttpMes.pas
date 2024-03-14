unit LensHttpMes;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, 
	System.Classes, System.SysUtils, 
	Vcl.Dialogs, Vcl.OleServer, Vcl.ExtCtrls, 
  IdHTTP, IdStream, IdURI, System.JSON,
	IdFTPCommon, IdFTPList, IdFTP, 
{$IFDEF INSPECTOR_POCB}
  DefPocb,
{$ELSE}
  DefCommon,
{$ENDIF}
	DefGmes, DefDio, CommonClass, UserUtils,
	CodeSiteLogging;

const
	MES_CH_MAX = 1; //CH_0..CH_1

	//------------------------------------- HTTP
	HTTP_STATUS_CODE_TX_ERR   = -1;		//
	HTTP_STATUS_CODE_TIMEOUT  = -2;		//
	// HTTP response status codes
	//		- Informational responses (100 – 199)
	//		- Successful responses (200 – 299)
	//		- Redirection messages (300 – 399)
	//		- Client error responses (400 – 499)
	//		- Server error responses (500 – 599)
	HTTP_STATUS_CODE_200  = 200;	// 200	successful invocation
	HTTP_STATUS_CODE_201  = 201;	// 201	object creation successful
	HTTP_STATUS_CODE_202  = 202;	// 202	The request has been accepted.
	HTTP_STATUS_CODE_400  = 400;	// 400	Parameter list error (missing, format mismatch)
	HTTP_STATUS_CODE_401  = 401;	// 401	unauthorized
	HTTP_STATUS_CODE_403  = 403;	// 403	Access restricted. Authorization expired.
	HTTP_STATUS_CODE_500  = 500;	// 500	server internal error

	//------------------------------------- LENS MES Message Type
  LENS_MES_MSG_LOGIN    = 0;
  LENS_MES_MSG_STATUS   = 1;
  		LENS_MES_STATUS_IDLE = 0;
			LENS_MES_STATUS_RUN  = 1;
  		LENS_MES_STATUS_WARN = 2;
  LENS_MES_MSG_START    = 2;
	LENS_MES_MSG_REINPUT  = 3;
  LENS_MES_MSG_END      = 4;
  LENS_MES_MSG_MAX      = LENS_MES_MSG_END;

	//------------------------------------- LENS MES Message Type
	//
  RESPONSE_WAITMSEC_LOGIN    = 1000; // msec
  RESPONSE_WAITMSEC_EQSTATUS = 1000; // msec
  RESPONSE_WAITMSEC_START    = 1000; // msec
  RESPONSE_WAITMSEC_END      = 1000; // msec

  // GUI LOG
	//	- COMMON|TX|RX
  LOG_TXRX_COMMON = 0;
  LOG_TXRX_TX     = 1;
  LOG_TXRX_RX     = 2;


type

  PSyncHost = ^RSyncHost;
  RSyncHost = record
    MsgType : Integer;
    Channel	: Integer;
    MsgMode : Integer;
    bError  : Boolean;
    Msg     : string;
    //
    Param   : Integer;
    Param2  : Integer;
  end;

	//
  TMsgTxRxStatus = (msgNone=0, msgTx=1, msgRespOK=2, msgRespNG=3);

  THttpMsgInfo = record
    MsgStatus   : TMsgTxRxStatus;
    sHttpPost   : string;
    sHttpResp   : string;
    sJsonPost   : TJSONObject;
    sJsonResp   : TJSONObject;
    ObjJsonResp : TJSONObject;
  end;

  THttpTokenInfo = record
    token : string;
  //acquireTime : TDataTime; //TBD?
    expires_in  : Integer; //TBD?
    //TBD?
  end;

  TLensHttpData = record
    // Token
    MesToken    : THttpTokenInfo;
    // Login
		MesLogin    : THttpMsgInfo;
    // EqStatus
    MesEqStatus : THttpMsgInfo;
    // Start|End
		MesStart    : array[0..MES_CH_MAX] of THttpMsgInfo;
    MesEnd      : array[0..MES_CH_MAX] of THttpMsgInfo;
  end;

  TGmesEvent = procedure(nMsgType, nPg: Integer; bError : Boolean; sErrMsg : string) of object; //TBD:LENS:MES?

  TGmes = class(TObject)

  private
		//------------------------------------
    idHttp      : TIdHTTP;
    idChHttp    : array[0..MES_CH_MAX] of TIdHTTP;
    FSendStart  : array[0..MES_CH_MAX] of Boolean;
		//
    FSystemNo   : string;
    FUserId     : string;
    FUserPwd  	: string;
    FMesUserName: string;
    FMesPostStatus : Integer;
    FMesStatusWarnRemarks : string;
		//
    FOnGmsEvent	: TGmesEvent;
		//---------------------------------- 
    procedure CreateHttpClient;
    function MakeMesJsonStr(MesMsgType: Integer; nCh: Integer=0; sSNorSTATUS: string=''; sRemark: string=''): string;
    function SendHttpPost(sURL: string; sJsonReq: string; var sJsonResponse: string; var sErrMsg: string): Integer;
    function SendHttpChPost(nCh: Integer; sURL: string; sJsonReq: string; var sJsonResponse: string; var sErrMsg: string): Integer;
		//
    procedure ReturnDataToTestForm(nMode,nCh: Integer; bError: Boolean; sMsg: string);
    procedure SetOnGmsEvent(const Value: TGmesEvent);
    procedure SetDateTime(Year, Month, Day, Hour, Minu, Sec, MSec: Word);

  public
		//----------------------------------
    hMainHandle : HWND;
    hTestHandle : array[0..MES_CH_MAX] of HWND;
		//
    LensHttpData : TLensHttpData;
		//
    constructor Create(AOwner: TComponent; hMain: HWND); virtual;
    destructor Destroy; override;
		//---------------------------------- 
    function SendLoginPost(sUserId, sUserPwd: string): Integer;
    function SendInspectStartPost(nCh: Integer; sSN: string): Integer;
    function SendInspectEndPost(nCh: Integer; sSN: string): Integer;
    function SendInspectReInputPost(nCh: Integer; sSN: string): Integer;
    function SendEqStatusPost(nCh: Integer; nEqStValue: Integer; sRemark: string): Integer;
		// for LGD-MES+LENS_MES Compatability
    function ConvertTxSerialNo(sSerialNo: string): string;
    procedure SendHostPchk(sSerialNo: string; nCh: Integer);
    procedure SendHostEicr(sSerialNo: string; nCh: Integer);
    // for LENS_MES EqStatus
    procedure SendHostStatus(nCh: Integer; nEqStValue: Integer; bForce: Boolean=False);
    function IsLensEqStChRun(nCh: Integer): Boolean;
    function GetLensEqStWarnRemarks: string;
		//---------------------------------- MES Message Parameters
    property MesSystemNo 		: string read FSystemNo 			write FSystemNo;
    property MesUserId   		: string read FUserId 				write FUserId;
    property MesUserPwd 		: string read FUserPwd				write FUserPwd;
    property MesUserName  	: string read FMesUserName 		write FMesUserName;
		//----------------------------------
    property MesPostStatus	: Integer read FMesPostStatus write FMesPostStatus;
    property MesStatusWarnRemarks	: string read FMesStatusWarnRemarks write FMesStatusWarnRemarks;
		//----------------------------------
    property OnGmsEvent     : TGmesEvent read FOnGmsEvent write SetOnGmsEvent;
  end;

var
  DongaGmes : TGmes;

implementation
{$r+} // memory range check.

uses LogicPocb, DioCtl;

{ TGmes }

//##############################################################################
//
//
//
//##############################################################################

//==============================================================================
//
//		- constructor TGmes.Create(AOwner: TComponent; hMain: HWND);
//		- destructor TGmes.Destroy;
//

constructor TGmes.Create(AOwner: TComponent; hMain: HWND);
var
	nCh : Integer;
begin
  hMainHandle := hMain;

  // Clear Fxxxx property
  FSystemNo    := '';
  FUserId      := '';
  FUserPwd     := '';
  FMesUserName := '';
  FMesPostStatus := LENS_MES_STATUS_IDLE;
  FMesStatusWarnRemarks := '';

  //
  CreateHttpClient;

  for nCh := 0 to MES_CH_MAX do
		FSendStart[nCh] := False;

end;

destructor TGmes.Destroy;
var
	nCh : Integer;
begin
  for nCh := 0 to MES_CH_MAX do begin
    if idChHttp[nCh] <> nil then FreeAndNil(idChHttp[nCh]);
  end;

  if idHttp <> nil then FreeAndNil(idHttp);

  inherited;
end;

//==============================================================================
// LENSVN MES - HTTP
//		- procedure TGmes.CreateHttpClient;
//		- function TGmes.SendHttpPost(sURL, sJsonReq: string; var sJsonResponse, sErrMsg: string): Integer;
//		- function TGmes.SendHttpChPost(nCh: Integer; sURL, sJsonReq: string; var sJsonResponse, sErrMsg: string): Integer;
//==============================================================================

//------------------------------------------------------------------------------
//
procedure TGmes.CreateHttpClient;
var
	nCh : Integer;
begin
	//
  ZeroMemory(@LensHttpData,SizeOf(LensHttpData));
  for nCh := 0 to MES_CH_MAX do
		FSendStart[nCh] := False;

	//
  for nCh := 0 to MES_CH_MAX do begin
    if idChHttp[nCh] <> nil then FreeAndNil(idChHttp[nCh]);
  end;
  if idHttp <> nil then FreeAndNil(idHttp);

  // idHttp
	idHttp := TIdHTTP.Create(nil);
  idHttp.HandleRedirects := true;
	idHttp.ReadTimeout     := 3000; //TBD:LENS:MES?
  idHttp.ConnectTimeout  := 3000; //TBD:LENS:MES?
//idHttp.MaxAuthRetries := 0;
//idHttp.HTTPOptions := [hoInProcessAuth];
//idHttp.HTTPOptions := idHttp.HTTPOptions + [hoNoProtocolErrorException]; //!!!
//idHttp.Request.BasicAuthentication := true;
//idHttp.Request.Accept := 'http';
//idHttp.Request.ContentType := 'application/json';
//idHttp.Request.ContentEncoding := 'utf-8';

  // idChHttp[]
  for nCh := 0 to MES_CH_MAX do begin
    idChHttp[nCh]  := TIdHTTP.Create(nil);
    idChHttp[nCh].HandleRedirects := true;
    idChHttp[nCh].ReadTimeout     := 3000; //TBD:LENS:MES?
    idChHttp[nCh].ConnectTimeout  := 3000; //TBD:LENS:MES?
  end;
end;

//------------------------------------------------------------------------------
//
function TGmes.SendHttpPost(sURL, sJsonReq: string; var sJsonResponse, sErrMsg: string): Integer;
var
	JsonReqStream, ResponseStream : TStringStream;
  sDebug : string;
begin
  sJsonResponse := '';
  sErrMsg       := '';
	//
	Result := HTTP_STATUS_CODE_TX_ERR; //TBD?
	//
	if idHttp = nil then begin
		//TBD:LENS:MES?
		Exit;
	end;

  JsonReqStream  := TStringStream.Create(sJsonReq, TEncoding.UTF8);
  ResponseStream := TStringStream.Create(EmptyStr, TEncoding.UTF8);
  try
		try
    	idHttp.ReadTimeout := 3000;
    	idHttp.HTTPOptions := [hoKeepOrigProtocol];
    	idHttp.HTTPOptions := idHttp.HTTPOptions + [hoNoProtocolErrorException]; //!!!
    	idHttp.Request.Clear;
    	idHttp.Request.CustomHeaders.Clear;
    	idHttp.Request.CustomHeaders.Add('Authorization: ' + LensHttpData.MesToken.token); //TBD:LENS:MES?
    	idHttp.Request.BasicAuthentication := False;
    	idHttp.Request.Accept := 'application/json';
    	idHttp.Request.ContentType := 'application/json; charset=utf-8';
    	idHttp.Request.UserAgent := 'Explorer'; //TBD:LENS:MES?
    	Common.MesLog('[TX] ' + sJsonReq);
    	JsonReqStream.Position := 0;
    	idHttp.Post(sURL, JsonReqStream, ResponseStream); //POST
    	sJsonResponse := ResponseStream.DataString;
    	Common.MesLog('[RX] ' + (idHttp.ResponseText + #$0D#$0A + ResponseStream.DataString));
    	Result := idHttp.ResponseCode;
    	if Result <> HTTP_STATUS_CODE_200 then begin
      	sErrMsg := idHttp.ResponseText;
    	end;
  	finally
    	idHttp.Response.Clear; //TBD:LENS:MES?
    	JsonReqStream.Free;
    	ResponseStream.Free;
  	end;
	except //TBD:LENS:MES?
		on E: EIdHTTPProtocolException do begin
      Result := idHttp.ResponseCode;
      sErrMsg := E.Message +'(' + E.ErrorMessage + ')';
      Common.MesLog('[RX] ' + sErrMsg);
		end;
  //on E: EIdSocketError do begin
    //if E.LastError = Id_WSAETIMEDOUT then
    //Request.OnRequestTimedOut();
  //end;
		on E: Exception do begin
      sErrMsg := E.Message;
      Common.MesLog('[RX] ' +E.Message);
		end;
	end;
end;

//------------------------------------------------------------------------------
//
function TGmes.SendHttpChPost(nCh: Integer; sURL, sJsonReq: string; var sJsonResponse, sErrMsg: string): Integer;
var
	JsonReqStream, ResponseStream : TStringStream;
  sDebug : string;
begin
  sJsonResponse := '';
  sErrMsg       := '';
	//
	Result := HTTP_STATUS_CODE_TX_ERR; //TBD?
	//
	if idChHttp[nCh] = nil then begin
		//TBD:LENS:MES?  Exit(0); ??
		Exit;
	end;

  JsonReqStream  := TStringStream.Create(sJsonReq, TEncoding.UTF8);
  ResponseStream := TStringStream.Create(EmptyStr, TEncoding.UTF8);
	try
  	try
    	idChHttp[nCh].ReadTimeout := 3000;
    	idChHttp[nCh].HTTPOptions := [hoKeepOrigProtocol];
    	idChHttp[nCh].HTTPOptions := idHttp.HTTPOptions + [hoNoProtocolErrorException]; //!!!
    	idChHttp[nCh].Request.Clear;
    	idChHttp[nCh].Request.CustomHeaders.Clear;
    	idChHttp[nCh].Request.CustomHeaders.Add('Authorization: ' + LensHttpData.MesToken.token);
    	idChHttp[nCh].Request.BasicAuthentication := False;
    	idChHttp[nCh].Request.ContentType := 'application/json; charset=utf-8';
    	idChHttp[nCh].Request.Method := 'POST';
    	idChHttp[nCh].Request.Accept := 'application/json';
    	idChHttp[nCh].Request.UserAgent := 'Explorer'; //TBD:LENS:MES?
    	Common.MesLog('[TX] ' + sJsonReq);
    	JsonReqStream.Position := 0;
    	idChHttp[nCh].Post(sURL, JsonReqStream, ResponseStream); //POST
    	sJsonResponse := ResponseStream.DataString;
    	Common.MesLog('[RX] ' + (idChHttp[nCh].ResponseText + #$0D#$0A + ResponseStream.DataString));
    	Result := idChHttp[nCh].ResponseCode;
    	if Result <> HTTP_STATUS_CODE_200 then begin
      	sErrMsg := idChHttp[nCh].ResponseText;
    	end;
  	finally
    	JsonReqStream.Free;
    	ResponseStream.Free;
  	end;
	except //TBD:LENS:MES?
		on E: EIdHTTPProtocolException do begin
      Result := idHttp.ResponseCode;
      sErrMsg := E.Message +'(' + E.ErrorMessage + ')';
      Common.MesLog('[RX] ' + sErrMsg);
		end;
  //on E: EIdSocketError do begin
    //if E.LastError = Id_WSAETIMEDOUT then
    //Request.OnRequestTimedOut();
  //end;
		on E: Exception do begin
      sErrMsg := E.Message;
      Common.MesLog('[RX] ' +E.Message);
		end;
	end;
end;

//==============================================================================
// LENSVN MES - HTTP
//		- function TGmes.SendLoginPost(sUserId, sUserPwd: string): Integer;
//		- function TGmes.SendInspectStartPost(nCh: Integer; sSN: string): Integer;
//		- function TGmes.SendInspectEndPost(nCh: Integer; sSN: string): Integer;
//		- function TGmes.SendInspectReInputPost(nCh: Integer; sSN: string): Integer;
//		- function TGmes.SendEqStatusPost(nCh: Integer; nEqStValue: Integer; sRemark: string): Integer;
//==============================================================================

//------------------------------------------------------------------------------
//
function TGmes.SendLoginPost(sUserId, sUserPwd: string): Integer;
var
  sURL, sErrMsg, sDebug : string;
  sJsonReq, sJsonResp : string;
  nHttpRespStatusCode : Integer;
  //
  JSonObject, tempJSonObj : TJSonObject;
  JSonValue, tempJSonVal : TJSonValue;
  //
  nMesRespCode : Integer;
  nMesRespDataToken : string;
begin
  //
  CreateHttpClient; //TBD:LENS:MES?

  // Make URL for 'Login'
	//	e,g., http://10.13.6.153/prod-api/auth/login
	sURL := Trim(Common.SystemInfo.LensMesUrlIF) + Trim(Common.SystemInfo.LensMesUrlLogin);
  // Make JsonData for 'Login'
  LensHttpData.MesToken.token := ''; //TBD:LENS:MES?
	sJsonReq := MakeMesJsonStr(LENS_MES_MSG_LOGIN);
  Common.MesLog('[Send Login] Token('+LensHttpData.MesToken.token+') URL('+sURL+')');
  Common.MLog(DefPocb.CH_ALL,Format('<MES> Send Login (token:%s) (%s)',[LensHttpData.MesToken.token,sJsonReq]));

  // Send Http POST
  sJsonResp := '';
  sErrMsg   := '';
  nMesRespCode := 0;

	nHttpRespStatusCode := SendHttpPost(sURL, sJsonReq, {var}sJsonResp, {var}sErrMsg);
  sJsonResp := StringReplace(sJsonResp, #$0D, '', [rfReplaceAll]);
  sJsonResp := StringReplace(sJsonResp, #$0A, '', [rfReplaceAll]);

	case nHttpRespStatusCode of
    //----------------------------------
		HTTP_STATUS_CODE_200 : begin
    	//  {
    	//    "code": 200,
    	//    "data": {
    	//        "access_token": "05975311-91f9-4885-8de1-5f5543b31011", -- 授权码Authorization
    	//        "site": "8812", -- 站点
    	//        "expires_in": "43200", -- access_token过期时间，如果过期了需要重新登录获取
    	//        "user_id": "1", -- 用户ID
    	//        "url": "http://10.210.196.42/8812/index", -- 忽略
    	//        "username": "admin"  -- 用户名
    	//    }
    	//  }
    	try
        Common.MLog(DefPocb.CH_ALL,Format('<MES> Response Login (%s)',[sJsonResp]));
        // Parsing Response(JSON)
      	JSonValue := TJSONObject.ParseJSONValue(sJsonResp);
    		if JSonValue <> nil then begin
        	try
						try
        			nMesRespCode := StrToInt(JSonValue.GetValue<string>('code'));
          		if nMesRespCode = HTTP_STATUS_CODE_200 then begin
            		tempJSonVal := JSonValue.GetValue<TJSonObject>('data');
          			LensHttpData.MesToken.token      := tempJSonVal.GetValue<string>('access_token'); //!!!
            		LensHttpData.MesToken.expires_in := StrToInt(tempJSonVal.GetValue<string>('expires_in')); //!!!
          		end
          		else begin
            		sErrMsg := 'JsonCode is not 200';
          		end;
						except
							sErrMsg := 'JsonValue Parse Error';
						end;
        	finally
          	JSONValue.Free;
        	end;
      	end
      	else begin
        	sErrMsg := 'JsonValue Parse Error';
      	end;
    	except
      	on E: Exception do begin
        	sErrMsg := E.Message; //TBD:LENS:MES?
      	end;
    	end;
      //
      if (nMesRespCode = HTTP_STATUS_CODE_200) then begin
				sDebug := 'MES LOGIN OK: '+ Format('UserId(%s): HttpRespCode(%s) JsonCode(%s)',[Common.m_sUserid,IntToStr(nHttpRespStatusCode),IntToStr(nMesRespCode)]);
				sDebug := sDebug + #$0D#$0A + 'MES LOGIN: token('+LensHttpData.MesToken.token+')';
				sDebug := sDebug + #$0D#$0A + 'MES LOGIN: expires_in('+IntToStr(LensHttpData.MesToken.expires_in)+')';
				OnGmsEvent(DefGmes.MES_UCHK, 0, False{bError}, sDebug);
        Exit;
      end;
		end;
    //----------------------------------
		HTTP_STATUS_CODE_TX_ERR : begin
			//TBD:LENS:MES? HTTP Post TX NG
		end;
    //----------------------------------
		HTTP_STATUS_CODE_TIMEOUT : begin
			//TBD:LENS:MES? HTTP Response NG (Response Timeout)
		end;
    //----------------------------------
		else begin
			//TBD:LENS:MES? HTTP Response NG (Status Code)
		end;
	end;

	// NG Case
  sErrMsg := StringReplace(sErrMsg, #$0D, ' ', [rfReplaceAll]);
  sErrMsg := StringReplace(sErrMsg, #$0A, ' ', [rfReplaceAll]);
  sDebug  := Format('  -- UserId(%s) UserPwd(%s)',[Common.m_sUserId,Common.m_sUserPwd]);
  if nHttpRespStatusCode <> HTTP_STATUS_CODE_TX_ERR then
    sDebug := sDebug + #$0D#$0A + Format('  -- HttpRespCode(%s) JsonCode(%s)',[IntToStr(nHttpRespStatusCode),IntToStr(nMesRespCode)]);
  sDebug := sDebug + #$0D#$0A + Format('  -- ErrMsg(%s)',[sErrMsg]);
	OnGmsEvent(DefGmes.MES_UCHK, 0, True{bError}, sDebug);
end;

//------------------------------------------------------------------------------
//
function TGmes.SendInspectStartPost(nCh: Integer; sSN: string): Integer;
var
  sURL, sDebug, sErrMsg, sReponseMsg : string;
  sJsonReq, sJsonResp : string;
  nHttpRespStatusCode : Integer;
  //
  JSonObject, tempJSonObj : TJSonObject;
  JSonValue, tempJSonVal : TJSonValue;
  //
  nMesRespCode : Integer;
begin
  if (idHttp = nil) or (idChHttp[nCh] = nil) then Exit; //TBD:LEMS:MES?

  // Make URL for 'Start'
	//	e,g., http://10.210.196.42/prod-api/v190/productSerialNumber/start
	sURL := Trim(Common.SystemInfo.LensMesUrlIF) + Trim(Common.SystemInfo.LensMesUrlStart);
  // Make JsonData for 'Start'
//if FSendStart[nCh] then  sJsonReq := MakeMesJsonStr(MES_LENS_REINPUT, nCh, sSN)
//else                     sJsonReq := MakeMesJsonStr(MES_LENS_START, nCh, sSN);
  sJsonReq := MakeMesJsonStr(LENS_MES_MSG_START, nCh, sSN);
  Common.MesLog('[Send Start] Token('+LensHttpData.MesToken.token+') URL('+sURL+')');

  Common.MesData[nCh].PchkSendNg := False; //!!!
  Common.MLog(nCh,Format('<MES> Send Start (token:%s) (%s)',[LensHttpData.MesToken.token,sJsonReq]));

  // Send Http POST
  sJsonResp := '';
  sErrMsg   := '';
  nMesRespCode := 0;

	nHttpRespStatusCode := SendHttpChPost(nCh,sURL, sJsonReq, {var}sJsonResp, {var}sErrMsg);
  sJsonResp := StringReplace(sJsonResp, #$0D, '', [rfReplaceAll]);
  sJsonResp := StringReplace(sJsonResp, #$0A, '', [rfReplaceAll]);

	case nHttpRespStatusCode of
    //----------------------------------
		HTTP_STATUS_CODE_200: begin
      FSendStart[nCh] := True;
      //
      try
        Common.MLog(nCh,Format('<MES> Response Start (%s)',[sJsonResp]));
        // Parsing Response(JSON)
        JSonValue := TJSONObject.ParseJSONValue(sJsonResp);
      	if JSonValue <> nil then begin
          try
            try
          	  nMesRespCode := StrToInt(JSonValue.GetValue<string>('code'));
              Common.MesData[nCh].PchkRtnCd := IntToStr(nMesRespCode); //!!!
              if nMesRespCode = HTTP_STATUS_CODE_200 then begin
            	  //tempJSonVal := JSonValue.GetValue<TJSonObject>('data');
            	  //TBD:LENS:MES? tempJSonVal.GetValue<string>('result')
  						  //TBD:LENS:MES? tempJSonVal.GetValue<string>('message')
  						  //TBD:LENS:MES? tempJSonVal.GetValue<string>('resultCode')
  						  //TBD:LENS:MES? tempJSonVal.GetValue<string>('Channel')
           		end
           		else begin
                tempJSonVal := JSonValue.GetValue<TJSonObject>('data');
                sReponseMsg := tempJSonVal.GetValue<string>('message');
              	sErrMsg := sReponseMsg;
            	end;
            except
              sErrMsg := 'JsonValue Parse Error';
            end;
          finally
            JSONValue.Free;
          end;
        end
        else begin
          sErrMsg := 'JsonValue Parse Error';
        end;
      except
        on E: Exception do begin
          sErrMsg := E.Message; //TBD:LENS:MES?
        end;
      end;
      //
      if (nMesRespCode = HTTP_STATUS_CODE_200) then begin
        ReturnDataToTestForm(DefGmes.MES_PCHK, nCh, False{bError}, '');
        Exit;
      end;
		end;
    //----------------------------------
		HTTP_STATUS_CODE_TX_ERR : begin
      Common.MesData[nCh].PchkSendNg := True;
			//TBD:LENS:MES? HTTP Post TX NG
		end;
    //----------------------------------
		HTTP_STATUS_CODE_TIMEOUT : begin
			//TBD:LENS:MES? HTTP Response NG (Response Timeout)
		end;
    //----------------------------------
		else begin
			//TBD:LENS:MES? HTTP Response NG (Status Code)
		end;
	end;

	// NG Case
  sErrMsg := StringReplace(sErrMsg, #$0D, ' ', [rfReplaceAll]);
  sErrMsg := StringReplace(sErrMsg, #$0A, ' ', [rfReplaceAll]);
  sDebug  := '';
  if nHttpRespStatusCode <> HTTP_STATUS_CODE_TX_ERR then
    sDebug := Format(' HttpRespCode(%s) JsonCode(%s)',[IntToStr(nHttpRespStatusCode),IntToStr(nMesRespCode)]);
  sDebug := sDebug + Format(' ErrMsg(%s) ',[sErrMsg]);
  ReturnDataToTestForm(DefGmes.MES_PCHK, nCh, True{bError}, sDebug);
end;

//------------------------------------------------------------------------------
//
function TGmes.SendInspectEndPost(nCh: Integer; sSN: string): Integer;
var
  sURL, sDebug, sErrMsg, sReponseMsg, sTemp : string;
  sJsonReq, sJsonResp : string;
  nHttpRespStatusCode : Integer;
  //
  JSonObject, tempJSonObj : TJSonObject;
  JSonValue, tempJSonVal : TJSonValue;
  //
  nMesRespCode : Integer;
	i : Integer;
begin
  if (idHttp = nil) or (idChHttp[nCh] = nil) then Exit; //TBD:LEMS:MES?

  if not FSendStart[nCh] then Exit;

 	// Make URL for 'End'
	sURL := Trim(Common.SystemInfo.LensMesUrlIF) + Trim(Common.SystemInfo.LensMesUrlEnd);
  // Make JsonData for 'End'
	sJsonReq := MakeMesJsonStr(LENS_MES_MSG_END, nCh, sSN);
  Common.MesLog('[Send End] Token('+LensHttpData.MesToken.token+') URL('+sURL+')');
  sTemp := '"keyParameters":[';
  sDebug := Copy(sJsonReq, 1, Pos(sTemp,sJsonReq)+Length(sTemp)-1);
  sDebug := '(' + sDebug + '......' + ']})';
  sDebug := sDebug + Format(' KeyParamInfo(%s)',[Common.MesData[nCh].ApdrApdInfo]);
  Common.MLog(nCh,Format('<MES> Send End (token:%s) (%s)',[LensHttpData.MesToken.token,sDebug]));
  //
  Common.MesData[nCh].EicrSendNg := False; //!!!
  FSendStart[nCh] := False; //TBD:LENS:MES?

  // Send Http POST
  sJsonResp := '';
  sErrMsg   := '';
  nMesRespCode := 0;

	nHttpRespStatusCode := SendHttpChPost(nCh, sURL, sJsonReq, {var}sJsonResp, {var}sErrMsg);
  sJsonResp := StringReplace(sJsonResp, #$0D, '', [rfReplaceAll]);
  sJsonResp := StringReplace(sJsonResp, #$0A, '', [rfReplaceAll]);

	case nHttpRespStatusCode of
    //----------------------------------
		HTTP_STATUS_CODE_200: begin
    	try
        Common.MLog(nCh,Format('<MES> Response End (%s)',[sJsonResp]));
  			// Parsing Response(JSON)
      	JSonValue := TJSONObject.ParseJSONValue(sJsonResp);
    		if JSonValue <> nil then begin
        	try
          	try
        	  	nMesRespCode := StrToInt(JSonValue.GetValue<string>('code'));
              Common.MesData[nCh].EicrRtnCd := IntToStr(nMesRespCode); //!!!
            	if nMesRespCode = HTTP_STATUS_CODE_200 then begin
          	  	//tempJSonVal := JSonValue.GetValue<TJSonObject>('data');
          	  	//TBD:LENS:MES? tempJSonVal.GetValue<string>('result')
						  	//TBD:LENS:MES? tempJSonVal.GetValue<string>('message')
						  	//TBD:LENS:MES? tempJSonVal.GetValue<string>('resultCode')
						  	//TBD:LENS:MES? tempJSonVal.GetValue<string>('Channel')
         			end
         			else begin
              	tempJSonVal := JSonValue.GetValue<TJSonObject>('data');
              	sReponseMsg := tempJSonVal.GetValue<string>('message');
              	sErrMsg := sReponseMsg;
          		end;
          	except
            	sErrMsg := 'JsonValue Parse Error';
          	end;
        	finally
          	JSONValue.Free;
        	end;
      	end
      	else begin
        	sErrMsg := 'JsonValue Parse Error';
      	end;
    	except
      	on E: Exception do begin
        	sErrMsg := E.Message; //TBD:LENS:MES?
      	end;
    	end;
      //
      if (nMesRespCode = HTTP_STATUS_CODE_200) then begin
        ReturnDataToTestForm(DefGmes.MES_EICR, nCh, False{bError}, '');
        Exit;
      end;
		end;
    //----------------------------------
		HTTP_STATUS_CODE_TX_ERR : begin
      Common.MesData[nCh].EicrSendNg := True;
		end;
    //----------------------------------
		HTTP_STATUS_CODE_TIMEOUT : begin
			//TBD:LENS:MES? HTTP Response NG (Response Timeout)
		end;
    //----------------------------------
		else begin
			//TBD:LENS:MES? HTTP Response NG (Status Code)
		end;
	end;

  // NG Case
  sErrMsg := StringReplace(sErrMsg, #$0D, ' ', [rfReplaceAll]);
  sErrMsg := StringReplace(sErrMsg, #$0A, ' ', [rfReplaceAll]);
  sDebug  := '';
  if nHttpRespStatusCode <> HTTP_STATUS_CODE_TX_ERR then
    sDebug := Format(' HttpRespCode(%s) JsonCode(%s)',[IntToStr(nHttpRespStatusCode),IntToStr(nMesRespCode)]);
  sDebug := sDebug + Format(' ErrMsg(%s) ',[sErrMsg]);
  ReturnDataToTestForm(DefGmes.MES_EICR, nCh, True{bError}, sDebug);
end;

//------------------------------------------------------------------------------
//
function TGmes.SendInspectReInputPost(nCh: Integer; sSN: string): Integer;
var
  sURL, sDebug, sErrMsg, sReponseMsg : string;
  sJsonReq, sJsonResp : string;
  nHttpRespStatusCode : Integer;
  //
  JSonObject, tempJSonObj : TJSonObject;
  JSonValue, tempJSonVal : TJSonValue;
  //
  nMesRespCode : Integer;
begin
  if (idHttp = nil) or (idChHttp[nCh] = nil) then Exit; //TBD:LEMS:MES?

  // Make URL for 'ReInput'
	//	e,g., http://10.210.196.42/prod-api/v190/productSerialNumber/start
	sURL := Trim(Common.SystemInfo.LensMesUrlIF) + Trim(Common.SystemInfo.LensMesUrlReInput);
  // Make JsonData for 'ReInput'
  sJsonReq := MakeMesJsonStr(LENS_MES_MSG_REINPUT, nCh, sSN);
  Common.MesLog('[Send ReInput] Token('+LensHttpData.MesToken.token+') URL('+sURL+')');
  Common.MLog(nCh,Format('<MES> Send ReInput (token:%s) (%s)',[LensHttpData.MesToken.token,sJsonReq]));

  FSendStart[nCh] := False;

  // Send Http POST
  sJsonResp := '';
  sErrMsg   := '';
  nMesRespCode := 0;

	nHttpRespStatusCode := SendHttpChPost(nCh,sURL, sJsonReq, {var}sJsonResp, {var}sErrMsg);
  sJsonResp := StringReplace(sJsonResp, #$0D, '', [rfReplaceAll]);
  sJsonResp := StringReplace(sJsonResp, #$0A, '', [rfReplaceAll]);

	case nHttpRespStatusCode of
    //----------------------------------
		HTTP_STATUS_CODE_200: begin
      try
        Common.MLog(nCh,Format('<MES> Response ReInput (%s)',[sJsonResp]));
        // Parsing Response(JSON)
        JSonValue := TJSONObject.ParseJSONValue(sJsonResp);
      	if JSonValue <> nil then begin
          try
            try
          	  nMesRespCode := StrToInt(JSonValue.GetValue<string>('code'));
              Common.MesData[nCh].PchkRtnCd := IntToStr(nMesRespCode); //!!!
              if nMesRespCode = HTTP_STATUS_CODE_200 then begin
            	  //tempJSonVal := JSonValue.GetValue<TJSonObject>('data');
            	  //TBD:LENS:MES? tempJSonVal.GetValue<string>('result')
  						  //TBD:LENS:MES? tempJSonVal.GetValue<string>('message')
  						  //TBD:LENS:MES? tempJSonVal.GetValue<string>('resultCode')
  						  //TBD:LENS:MES? tempJSonVal.GetValue<string>('Channel')
           		end
           		else begin
                tempJSonVal := JSonValue.GetValue<TJSonObject>('data');
                sReponseMsg := tempJSonVal.GetValue<string>('message');
              	sErrMsg := sReponseMsg;
            	end;
            except
              sErrMsg := 'JsonValue Parse Error';
            end;
          finally
            JSONValue.Free;
          end;
        end
        else begin
          sErrMsg := 'JsonValue Parse Error';
        end;
      except
        on E: Exception do begin
          sErrMsg := E.Message; //TBD:LENS:MES?
        end;
      end;
      //
      if (nMesRespCode = HTTP_STATUS_CODE_200) then begin
        ReturnDataToTestForm(DefGmes.MES_ZSET, nCh, False{bError}, ''); //TBD:LENS:MES?
        Exit;
      end;
		end;
    //----------------------------------
		HTTP_STATUS_CODE_TX_ERR : begin
      Common.MesData[nCh].PchkSendNg := True;
			//TBD:LENS:MES? HTTP Post TX NG
		end;
    //----------------------------------
		HTTP_STATUS_CODE_TIMEOUT : begin
			//TBD:LENS:MES? HTTP Response NG (Response Timeout)
		end;
    //----------------------------------
		else begin
			//TBD:LENS:MES? HTTP Response NG (Status Code)
		end;
	end;

  // NG Case
  sErrMsg := StringReplace(sErrMsg, #$0D, ' ', [rfReplaceAll]);
  sErrMsg := StringReplace(sErrMsg, #$0A, ' ', [rfReplaceAll]);
  sDebug  := '';
  if nHttpRespStatusCode <> HTTP_STATUS_CODE_TX_ERR then
    sDebug := Format(' HttpRespCode(%s) JsonCode(%s)',[IntToStr(nHttpRespStatusCode),IntToStr(nMesRespCode)]);
  sDebug := sDebug + Format(' ErrMsg(%s) ',[sErrMsg]);
  ReturnDataToTestForm(DefGmes.MES_ZSET, nCh, True{bError}, sDebug); //TBD:LENS:MES?
end;

//------------------------------------------------------------------------------
//
function TGmes.SendEqStatusPost(nCh: Integer; nEqStValue: Integer; sRemark: string): Integer;
var
  sURL, sDebug, sErrMsg, sReponseMsg, sStatus : string;
  sJsonReq, sJsonResp : string;
  nHttpRespStatusCode : Integer;
  //
  JSonObject, tempJSonObj : TJSonObject;
  JSonValue, tempJSonVal : TJSonValue;
  //
  nMesRespCode : Integer;
begin
  if (idHttp = nil) then Exit; //TBD:LEMS:MES?

  // Make URL for 'EqStatus'
	//	e,g., http://10.13.6.153/prod-api/v190/deviceApi/machineStatus/upload
	sURL := Trim(Common.SystemInfo.LensMesUrlIF) + Trim(Common.SystemInfo.LensMesUrlEqStatus);
  // Make JsonData for 'EqStatus'
  case nEqStValue of
    LENS_MES_STATUS_IDLE : sStatus := 'Idle';
    LENS_MES_STATUS_RUN  : sStatus := 'Run';
    LENS_MES_STATUS_WARN : sStatus := 'Warn';
    else Exit;
  end;
	sJsonReq := MakeMesJsonStr(LENS_MES_MSG_STATUS, 0, sStatus, sRemark);
  Common.MesLog('[Send EqStatus] Token('+LensHttpData.MesToken.token+') URL('+sURL+')');
  Common.MLog(nCh,Format('<MES> Send EqStatus (token:%s) (%s)',[LensHttpData.MesToken.token,sJsonReq]));

  // Send Http POST
  sJsonResp := '';
  sErrMsg   := '';
  nMesRespCode := 0;

	nHttpRespStatusCode := SendHttpPost(sURL, sJsonReq, {var}sJsonResp, {var}sErrMsg);
  sJsonResp := StringReplace(sJsonResp, #$0D, '', [rfReplaceAll]);
  sJsonResp := StringReplace(sJsonResp, #$0A, '', [rfReplaceAll]);

	case nHttpRespStatusCode of
    //----------------------------------
		HTTP_STATUS_CODE_200 : begin
    	try
        Common.MLog(nCh,Format('<MES> Response EqStatus (%s)',[sJsonResp]));
        // Parsing Response(JSON)
      	JSonValue := TJSONObject.ParseJSONValue(sJsonResp);
    		if JSonValue <> nil then begin
        	try
          	try
        	  	nMesRespCode := StrToInt(JSonValue.GetValue<string>('code'));
            	if nMesRespCode = HTTP_STATUS_CODE_200 then begin
                FMesPostStatus := nEqStValue;
                if nEqStValue = LENS_MES_STATUS_WARN then FMesStatusWarnRemarks := sRemark else FMesStatusWarnRemarks := '';
         			end
         			else begin
              	tempJSonVal := JSonValue.GetValue<TJSonObject>('data');
              	sReponseMsg := tempJSonVal.GetValue<string>('message');
              	sErrMsg := sReponseMsg;
          		end;
          	except
            	sErrMsg := 'JSONValue Parse Error';
          	end;
        	finally
          	JSONValue.Free;
        	end;
      	end
      	else begin
        	sErrMsg := 'JSONValue Parse Error';
      	end;
    	except
      	on E: Exception do begin
        	sErrMsg := E.Message; //TBD:LENS:MES?
      	end;
    	end;
      //
      if (nMesRespCode = HTTP_STATUS_CODE_200) then begin
      //ReturnDataToTestForm(DefGmes.MES_EQCC, nCh, False{bError}, sStatus); //TBD:LENS:MES?
        Exit;
      end;
		end;
    //----------------------------------
		HTTP_STATUS_CODE_TX_ERR : begin
			//TBD:LENS:MES? HTTP Post TX NG
		end;
    //----------------------------------
		HTTP_STATUS_CODE_TIMEOUT : begin
			//TBD:LENS:MES? HTTP Response NG (Response Timeout)
		end;
    //----------------------------------
		else begin
			//TBD:LENS:MES? HTTP Response NG (Status Code)
		end;
	end;

  // NG Case
  sErrMsg := StringReplace(sErrMsg, #$0D, ' ', [rfReplaceAll]);
  sErrMsg := StringReplace(sErrMsg, #$0A, ' ', [rfReplaceAll]);
  sDebug  := '('+sStatus+')';
  if nHttpRespStatusCode <> HTTP_STATUS_CODE_TX_ERR then
    sDebug := Format(' HttpRespCode(%s) JsonCode(%s)',[IntToStr(nHttpRespStatusCode),IntToStr(nMesRespCode)]);
  sDebug := sDebug + Format(' ErrMsg(%s) ',[sErrMsg]);
//ReturnDataToTestForm(DefGmes.MES_EQCC, nCh, False{bError}, sDebug);  //TBD:LENS:MES?
end;


{WebVrowser 에서 쿠키 갖어 오기
   mmResult.Lines.Text:= WebBrowser1.OleObject.Document.Cookie;

 idHttp 에 쿠기 저장하기 1.
    IdHTTP1.Response.RawHeaders.Add('Cookie: '+ mmResult.Lines.Text);
    이 때  Cookie: 또는 Set-Cookie: 등으로 바꿔서 사용하므로 선택하여 사용 필요(paros에서 확인)

idHttp 에 쿠기 저장하기 2.
  TWebBrowserHelper = class Helper for TWebBrowser
  public
    function GetCookieValue(Name: string): string;
    function GetSessionID(Const id:string): string;
  end;
  function TWebBrowserHelper.GetCookieValue(Name: string): string;
var
  Doc: IHTMLDocument2;
  sList, tList: TStringList;
  i: Integer;
begin
  Result := '';
  Doc := Self.Document as IHTMLDocument2;
  if not assigned(Doc) then exit;
  sList := TStringList.Create;
  tList := TStringList.Create;
  try
    ExtractStrings([';'], [], PChar(Doc.cookie), sList);
    for i := 0 to sList.Count - 1 do begin
      tList.Clear;
      ExtractStrings(['='], [], PChar(Trim(sList[i])), tList);
      if AnsiCompareText(tList[0], Name) = 0 then begin
        Result := tList[1];
        exit;
      end;
    end;
  finally
    FreeAndNil(sList);
    FreeAndNil(tList);
  end;
end;

function TWebBrowserHelper.GetSessionID(const id: string): string;
begin
  Result := Self.GetCookieValue(id);
end;

edSessionID.Text 에 PHPSessionID 등 세션 아이디가 있음
웹 개발자가 멋대로 만들기에 찾아서 기록, 또는 방법 1을 사용 하여 찾을 수 있음...
procedure TForm1.btSetCookieClick(Sender: TObject);
var IdURI: TIdUri;
begin
  IdURI := TIdUri.Create(WebBrowser1.LocationURL);
  edSessionValue.Text:= WebBrowser1.GetSessionID(Trim(edSessionID.Text));
  IdCookieManager1.AddServerCookie(edSessionID.Text+'='+edSessionValue.Text, IDUri);
  iduri.Free;
end;


http/1.1 302 Found 예외 에러 발생 하면 IdHttp 의 속성을 HandleRedirects := True; 해주면 됩니다.
}

//##############################################################################
//
// LENSVN MES - JSON
//
//##############################################################################

//------------------------------------------------------------------------------
//
function TGmes.MakeMesJsonStr(MesMsgType: Integer; nCh: Integer=0; sSNorSTATUS: string=''; sRemark: string=''): string;
var
  objJson, objTemp : TJSONObject;
  objTestData, objTestDetails : TJSONObject;
	objJsonArrayTestResult, objJsonArrayTestDetails, objJsonArrayKeyParam : TJSONArray;
	sJson : string;
  //
  slItems, slSubItem : TStringList; //for APD
  i : Integer;
begin
	sJson   := '';

  objJson := TJSONObject.Create;
	try
		case MesMsgType of
			//-------------------------------- Login/Token 
  		LENS_MES_MSG_LOGIN : begin
      	//{
      	//  "username": "LY514857",
      	//  "password": "123456",
      	//  "site": "V190"
      	//}
      	objJson.AddPair('username', Trim(Common.m_sUserId));
      	objJson.AddPair('password', Trim(Common.m_sUserPwd));
      	objJson.AddPair('site',     Trim(Common.SystemInfo.LenMesSITE));
			end;
			//-------------------------------- EqStatus
  		LENS_MES_MSG_STATUS : begin
      	//{
      	//  "site": "V190",
      	//  "resource": "EI",
      	//  "status": "Run",
      	//  "remark": ""
      	//}
      	objJson.AddPair('site',     Trim(Common.SystemInfo.LenMesSITE));
      	objJson.AddPair('resource', Trim(Common.SystemInfo.EQPId));
      	objJson.AddPair('status',   Trim(sSNorSTATUS){Status});
      	objJson.AddPair('remark',   Trim(sRemark){Remark});
			end;
			//-------------------------------- (Inspect) Start
  		LENS_MES_MSG_START : begin
      	//{
      	//  "site": "V190",
      	//  "mo": "om202306150001",
      	//  "resource": "V190F101CPFI01",
      	//  "item": "",
      	//  "shift": "A",
      	//  "sn": "test000000014",
      	//  "operation": "34000",
      	//  "businessType": "",
      	//  "channel": "1"
      	//}
      	objJson.AddPair('site',     Trim(Common.SystemInfo.LenMesSITE));
      	objJson.AddPair('mo',       Trim(Common.SystemInfo.LensMesMO));
      	objJson.AddPair('resource', Trim(Common.SystemInfo.EQPId));
      	objJson.AddPair('item',     Trim(Common.SystemInfo.LensMesITEM));
      	objJson.AddPair('shift',    Trim(Common.SystemInfo.LensMesSHIFT));
      	objJson.AddPair('sn',       Trim(sSNorSTATUS{SN}));
      	objJson.AddPair('operation',Trim(Common.SystemInfo.LensMesOPERATION));
      	objJson.AddPair('businessType', '');
      	objJson.AddPair('channel',  IntToStr(nCh+1));
			end;
			//-------------------------------- (Inspect) ReInput
      LENS_MES_MSG_REINPUT : begin
      	objJson.AddPair('site',     Trim(Common.SystemInfo.LenMesSITE));
      	objJson.AddPair('operation',Trim(Common.SystemInfo.LensMesOPERATION));
        objJson.AddPair('sn',       Trim(sSNorSTATUS{SN}));
      end;
			//-------------------------------- (Inspect) End
  		LENS_MES_MSG_END : begin
      	//{
      	//  "site": "V190",
      	//  "mo": "om202306150001",
      	//  "resource": "V190F101CPFI01",
      	//  "item": "",
      	//  "itemRevision": "",
      	//  "shift": "A",
      	//  "sn": "test000000014",
      	//  "operation": "34000",
      	//  "testResult": [],                           "testResult": [
      	//                                                {
      	//                                                  "ncCode": "A01-B05-G1D-R3B"
      	//                                                }
      	//                                              ],
      	//  "testData": {
      	//    "totalResult": "PASS",                    "totalResult": "FAIL",
      	//    "testStartTime": "2023-05-09 14:25:03",
      	//    "testEndTime": "2023-05-09 14:25:13",
      	//    "testDetails": [
      	//        {
      	//            "testSequence": "1",
      	//            "testItem": "AAAAA",
      	//            "subTestItem": "AAAAA1",
      	//            "itemResult": "PASS",
      	//            "testValue": "1",
      	//            "testLowerLimit": "",
      	//            "testUpperLimit": "",
      	//            "testUnits": "MM",
      	//            "testTime": "2023-05-09 14:25:13"
      	//        }
      	//    ]
      	//  }
      	//}
      	objJson.AddPair('site',     Trim(Common.SystemInfo.LenMesSITE));
      	objJson.AddPair('mo',       Trim(Common.SystemInfo.LensMesMO));
      	objJson.AddPair('resource', Trim(Common.SystemInfo.EQPId));
      	objJson.AddPair('item',     Trim(Common.SystemInfo.LensMesITEM));
      	objJson.AddPair('shift',    Trim(Common.SystemInfo.LensMesSHIFT));
      	objJson.AddPair('sn',       Trim(sSNorSTATUS{SN}));
      	objJson.AddPair('operation',Trim(Common.SystemInfo.LensMesOPERATION));
      	objJson.AddPair('businessType', '');
      	objJson.AddPair('channel',  IntToStr(nCh+1));
      	// TestResult
				objJsonArrayTestResult  := TJSONArray.Create;
				if (Logic[nCh].m_Inspect.Result <> 'PASS') then begin
      		//objJsonArrayTestResult.AddElement(TJSONObject.Create(TJSONPair.Create('ncCode',Common.MesData[nCh].Rwk)));
          objTemp :=  TJSONObject.Create;
          objTemp.AddPair('ncCode',Common.MesData[nCh].Rwk);
          objJsonArrayTestResult.AddElement(objTemp);
				end;
      	objJson.AddPair('testResult', objJsonArrayTestResult);
      	// TestData
      	objTestData := TJSONObject.Create;
				//    - testResult
      	objTestData.AddPair('totalResult',  TernaryOp((Logic[nCh].m_Inspect.Result = 'PASS'),'PASS','FAIL'));
				//    - testStartTime
      	objTestData.AddPair('testStartTime',FormatDateTime('YYYY-MM-DD hh:nn:ss',Logic[nCh].m_Inspect.TimeStart));
				//    - testEndTime
      	objTestData.AddPair('testEndTime',  FormatDateTime('YYYY-MM-DD hh:nn:ss',Logic[nCh].m_Inspect.TimeEnd));
				//    - testDetails
				objJsonArrayTestDetails := TJSONArray.Create; // testDeatails //TBD:LENS:MES?
        objTemp :=  TJSONObject.Create;
        objTemp.AddPair('testSequence',IntToStr(1));
        objTemp.AddPair('testItem','AAAAA'); //2023-07-27 paraItem->testItem
        objTemp.AddPair('subTestItem','AAAAA1');
        objTemp.AddPair('itemResult','PASS');
        objTemp.AddPair('testValue','1');
        objTemp.AddPair('testLowerLimit','0');
        objTemp.AddPair('testUpperLimit','2');
        objTemp.AddPair('testUnits','MM');
        objTemp.AddPair('testMessage','');
        objTemp.AddPair('testTime', FormatDateTime('YYYY-MM-DD hh:nn:ss',Logic[nCh].m_Inspect.TimeStart));
        objJsonArrayTestDetails.AddElement(objTemp);
        objTestData.AddPair('testDetails',objJsonArrayTestDetails);
        objJson.AddPair('testData', objTestData);
      	// KeyParameters (for LGD:APD_INFO)
        objJsonArrayKeyParam := TJSONArray.Create;
        slItems := TStringList.Create;
        try
          ExtractStrings([','], [], PWideChar(Common.MesData[nCh].ApdrApdInfo), slItems); //TBD:LENS:MES?
          for i := 0 to Pred(slItems.Count) do begin
            slSubItem := TStringList.Create;
            ExtractStrings([':'], [], PWideChar(slItems[i]), slSubItem);
            if slSubItem.Count < 2 then begin //2023-07-26
              slSubItem.Free;
              Continue;
            end;
            try
              objTemp :=  TJSONObject.Create;
              objTemp.AddPair('paraSequence', IntToStr(i+1));
              objTemp.AddPair('paraItem',     slSubItem[1]);
              objTemp.AddPair('paraResult',   'PASS');
              if slSubItem.Count >= 3 then objTemp.AddPair('paraValue', slSubItem[2]) //2023-07-26
              else                         objTemp.AddPair('paraValue', '');
              objTemp.AddPair('paraLowerLimit','');
              objTemp.AddPair('paraUpperLimit','');
              objTemp.AddPair('paraUnits','');
              objTemp.AddPair('paraMessage',''); //2023-07-27
              objJsonArrayKeyParam.AddElement(objTemp);
            finally
              slSubItem.Free;
            end;
          end;
        finally
          slItems.Free
        end;
        objJson.AddPair('keyParameters',objJsonArrayKeyParam);
			end;
			//-------------------------------- (Inspect) End
			else begin
				//TBD?
      end;
		end;
  finally
    sJson := objJson.ToString;
    objJson.Free;
  end;
	//
  Result := sJson;		
end;

//==============================================================================
// For LGD-MES+LENS-MES Conpatability
//    - function TGmes.ConvertTxSerialNo(sSerialNo: string): string;
//    - TGmes.SendHostPchk(sSerialNo: string; nCh: Integer);
//    - TGmes.SendHostEicr(sSerialNo: string; nCh: Integer);
//==============================================================================

function TGmes.ConvertTxSerialNo(sSerialNo: string): string;
var
  sConvertSerial : string;
begin
  sConvertSerial := StringReplace(sSerialNo,#$24,#$0a,[rfReplaceAll]);
  sConvertSerial := StringReplace(sConvertSerial,#$25,#$0d,[rfReplaceAll]);
  Result := sConvertSerial;
end;

procedure TGmes.SendHostPchk(sSerialNo: string; nCh: Integer);
var
  sConvertSerial : string;
begin
  if Length(sSerialNo) = 0 then Exit;
  sConvertSerial := ConvertTxSerialNo(sSerialNo);
  Common.MesData[nCh].TxSerial := sConvertSerial;
  //
  SendInspectReInputPost(nCh,sConvertSerial); //TBD:LENS:MES?
  //
  SendInspectStartPost(nCh,sConvertSerial);
  //
  //2023-08-16 Delete!!! SendEqStatusPost(nCh, LENS_MES_STATUS_RUN, ''{ReMark});
end;

procedure TGmes.SendHostEicr(sSerialNo: string; nCh: Integer);
var
  sConvertSerial : string;
  sConvertZig    : string;
begin
  if Length(sSerialNo) = 0 then Exit;
  sConvertSerial := ConvertTxSerialNo(sSerialNo);
  Common.MesData[nCh].TxSerial := sConvertSerial;
  SendInspectEndPost(nCh,sConvertSerial);
end;

//==============================================================================
// For LENS-MES EqStatus
//    - procedure TGmes.SendHostStatus(nCh: Integer; nEqStValue: Integer; bForce: Boolean=False);
//    - function TGmes.IsLensEqStChRun(nCh: Integer): Boolean;
//==============================================================================

procedure TGmes.SendHostStatus(nCh: Integer; nEqStValue: Integer; bForce: Boolean=False); //2023-08-21
var
  nOtherCh : Integer;
  sWarnRemarks : string;
begin
  if (not bForce) and (FMesPostStatus = nEqStValue) then begin
    // Already Send EqStatus
    Exit;
  end;

  case nEqStValue of
  	LENS_MES_STATUS_IDLE : begin
      if bForce then begin // StartExe/Initial
        sWarnRemarks := Trim(GetLensEqStWarnRemarks);
        if sWarnRemarks <> '' then SendEqStatusPost(DefPocb.CH_1{dummy}, LENS_MES_STATUS_WARN, sWarnRemarks{ReMarks})
        else                       SendEqStatusPost(DefPocb.CH_1{dummy}, LENS_MES_STATUS_IDLE, ''{ReMarks})
      end
      else begin //Idle(Unload)
        if (not IsLensEqStChRun(DefPocb.CH_1)) and (not IsLensEqStChRun(DefPocb.CH_2)) then begin
          SendEqStatusPost(nCh, LENS_MES_STATUS_IDLE, ''{ReMark});
        end;
      end;
    end;
    //
		LENS_MES_STATUS_RUN : begin
      SendEqStatusPost(nCh, LENS_MES_STATUS_RUN, ''{ReMarks});
    end;
    //
  	LENS_MES_STATUS_WARN : begin  // See also, Main.UpdateAlarmStatus()
      if bForce then begin //DIO_Disconnect|EMO(On), Door|Teach|CylinderRegulater|...(Off)
        sWarnRemarks := Trim(GetLensEqStWarnRemarks);
        if (sWarnRemarks = '') and (Trim(FMesStatusWarnRemarks) <> '') then // Warn->Idle
          SendEqStatusPost(DefPocb.CH_1{dummy}, LENS_MES_STATUS_IDLE, ''{ReMarks})
        else if sWarnRemarks <> Trim(FMesStatusWarnRemarks) then
          SendEqStatusPost(DefPocb.CH_1{dummy}, LENS_MES_STATUS_WARN, sWarnRemarks); //Idle->Warn
      end
      else begin
        if (not IsLensEqStChRun(DefPocb.CH_1)) and (not IsLensEqStChRun(DefPocb.CH_2)) then begin
          sWarnRemarks := Trim(GetLensEqStWarnRemarks);
          if (sWarnRemarks <> '') and (Trim(FMesStatusWarnRemarks) = '') then //Idle->Warn
            SendEqStatusPost(DefPocb.CH_1{dummy}, LENS_MES_STATUS_WARN, sWarnRemarks);
        end
        else begin
          // Skip (CH1|CH2 Run)
        end;
      end;
    end;
  end;
end;

function TGmes.IsLensEqStChRun(nCh: Integer): Boolean;
begin
  //IO_AUTO_FLOW_NONE         : LensEqStatus(Idle)
  //IO_AUTO_FLOW_READY        : LensEqStatus(Idle)
  //IO_AUTO_FLOW_FRONT        : LensEqStatus(Run)
  //IO_AUTO_FLOW_SHUTTER_DOWN : LensEqStatus(Run)
  //IO_AUTO_FLOW_CAMERA       : LensEqStatus(Run)
  //IO_AUTO_FLOW_SHUTTER_UP   : LensEqStatus(Run)
  //IO_AUTO_FLOW_BACK         : LensEqStatus(Run)
  //IO_AUTO_FLOW_UNLOAD       : LensEqStatus(Idle)
  Result := (DongaDio.m_nAutoFlow[nCh] in [DefDio.IO_AUTO_FLOW_FRONT, DefDio.IO_AUTO_FLOW_SHUTTER_DOWN, IO_AUTO_FLOW_CAMERA, IO_AUTO_FLOW_SHUTTER_UP, IO_AUTO_FLOW_BACK]);
end;

function TGmes.GetLensEqStWarnRemarks: string;
begin
  Result := '';

  //
  // 2023-08-21 LENS MES EqStatus(Warn)
  //  - LightCurtain, MC Down -> NOT send EqStatus(Warn) !!!
  //  - DIO_DISCONNECT -> EMO -> PowerHight/Temperature -> DoorOpen -> {TeachMode -> CylinderRegulator -> VacuumRegulator -> etc}
  //

  // DIO Control Connection
  if Common.AlarmList[DefPocb.ALARM_DIO_NOT_CONNECTED].bIsOn then begin
    Result := 'DIO Control Device Disconnected';
    Exit;
  end;
  // EMO
  if Common.AlarmList[DefPocb.ALARM_DIO_EMO1_FRONT].bIsOn or
     Common.AlarmList[DefPocb.ALARM_DIO_EMO2_RIGHT].bIsOn or
     Common.AlarmList[DefPocb.ALARM_DIO_EMO3_INNER_RIGHT].bIsOn or
     Common.AlarmList[DefPocb.ALARM_DIO_EMO4_INNER_LEFT].bIsOn or
     Common.AlarmList[DefPocb.ALARM_DIO_EMO5_LEFT].bIsOn then begin
    Result := 'EMO button pressed';
    Exit;
  end;

  //
  if Common.AlarmList[DefPocb.ALARM_DIO_TEMPERATURE].bIsOn then begin
    Result := 'System Temperature is High';
    Exit;
  end;
  if Common.AlarmList[DefPocb.ALARM_DIO_POWER_HIGH].bIsOn then begin
    Result := 'System Power is High';
    Exit;
  end;
  // Doors (CH1+CH2)
  if (Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_DOOR1_OPEN].bIsOn or Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_DOOR2_OPEN].bIsOn) and
     (Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_DOOR1_OPEN].bIsOn or Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_DOOR2_OPEN].bIsOn) then begin
    Result := 'All channels are door opened';
    Exit;
  end;
  // Teach Mode (CH1+CH2)
//if (Common.AlarmList[DefPocb.ALARM_DIO_STAGE1_NOT_AUTOMODE].bIsOn and Common.AlarmList[DefPocb.ALARM_DIO_STAGE2_NOT_AUTOMODE].bIsOn) then begin
//  Result := 'All channels are in teach mode';
//  Exit;
//end;
  // Cylinder Regulator
//if Common.AlarmList[DefPocb.ALARM_DIO_CYLINDER_REGULATOR].bIsOn then begin
//  Result := 'Cylinder Regulator is Abnormal';
//  Exit;
// end;
//if Common.AlarmList[DefPocb.ALARM_DIO_VACUUM_REGULATOR].bIsOn then begin
//  Result := 'Vacuum Regulator is Abnormal';
//  Exit;
//end;
  //
//if Common.AlarmList[DefPocb.ALARM_DIO_MC1].bIsOn and Common.AlarmList[DefPocb.ALARM_DIO_MC2].bIsOn then begin //if MC1/MC2 OK
//  //TBD:LENS:MES:EQSTATUS?
//end;
end;

//==============================================================================
// GMES <-> FrmMain & TestCh
//==============================================================================

// GMES -> FrmMain
procedure TGmes.SetOnGmsEvent(const Value: TGmesEvent);
begin
  FOnGmsEvent := Value;
end;

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
  nJig := nCh;	//POCB-specific

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
