unit DefAimf;

interface

uses
  Winapi.Windows;

const
{$DEFINE AUTO_INS_MODE}

  MSG_TYPE_AIMF     = 1;
  MSG_TYPE_CONFIG   = 2;
  MSG_TYPE_INSPECT  = 3;
  MSG_TYPE_GMES     = 4;

  AIMF_NG_CODE_OK               = 0;
  AIMF_NG_CODE_INSP_STATUS_NG   = 1;
  AIMF_NG_CODE_FTP_CONNECT_NG   = 2;
  AIMF_NG_CODE_DATA_DOWN_NG     = 3;
  AIMF_NG_CODE_COPY_VERIFY_NG   = 4;
  AIMF_NG_CODE_NEW_SW_RUN_NG    = 6;
  AIMF_NG_CODE_MC_NG            = 7;

  APP_PATH_AIMF       = 'UPDATE';
  UNZIP_FIRST_AIMF    = 'EQUIPMENT';

  AIMF_COMM_CAPTION   = 'AIMF - Automatically Install Multiple files';
  INS_COMM_CAPTION    = 'AIMF - WARNING MESSAGE';
  AIMF_APP_VER        = 'R1.0.0';
//  AIMF_APP_INS_CLASS  = 'TfrmAutoUpdateExeForAutoMobile';//'TfrmAutoUpdateExe';  //DAE_Auto_Inspector_Upgrate
{$IFDEF AUTO_INS_MODE}
  AIMF_APP_INS_CLASS  = 'TfrmAutoUpdateExeForAutoMobile';
  AIMF_APP_FILE_NAME  = 'DAE_Auto_Inspector_Upgrade.exe'; //'DAE_Auto_Inspector_Upgrate.exe'; // 'DAE_Inspector_Upgrade.exe';
{$ELSE}
  AIMF_APP_INS_CLASS  = 'TfrmAutoUpdateExe';
  AIMF_APP_FILE_NAME  = 'DAE_Inspector_Upgrade.exe';
{$ENDIF}
  AIMF_WARN_WIN_CLASS = 'TfrmWarnMsgAim';
  AIMF_APP_LOG_UPLOAD = 'TfrmMain_LogUploader';
  SYS_CONFIG_FILENAME = 'Config_update.ini';


  AIMF_RET_ALL_OK       = 0;  // RET OK.& EAAR OK
  AIMF_RET_NG_EAAR_OK   = 1;  // RET NG & EAAR NG
  AIMF_RET_OK_EAAR_NG   = 2;  // RET OK & EAAR NG
  AIMF_RET_NG_EAAR_NG   = 3;  // RET NG & EAAR NG
  AIMF_RET_ONLY_OK      = 4;  // Only Ret OK
  AIMF_RET_ONLY_NG      = 5;  // Only Ret NG
  AIMF_RET_NOT_READY_NG = 10; // Default


  AIMF_STATUS_NONE      = 0;
  AIMF_STATUS_IDLE      = 1;
  AIMF_STATUS_RUN       = 2;
  AIMF_STATUS_OFFLINE   = 3;
  AIMF_STATUS_MODEL_NG  = 4;
  AIMF_STATUS_SW_OFF    = 5;
  AIMF_STATUS_LINE_NG   = 6;

  AIMF_IDX_LOGIN_NONE   = 0;   // SW Ã³¸® Log In.
  AIMF_IDX_LOG_OFF      = 1;
  AIMF_IDX_LOG_ON       = 2;
  AIMF_IDX_LOG_PMMODE   = 3;

  DUT_TYPE_MOBILE       = 0;
  DUT_TYPE_WATCH        = 1;
  DUT_TYPE_AUTO         = 2;

  // 0:FOLDER, 1: .mcf, 2: .ini, 3:mod
  AIMF_MODEL_TYPE_FOLDER = 0;
  AIMF_MODEL_TYPE_MCF    = 1;
  AIMF_MODEL_TYPE_INI    = 2;
  AIMF_MODEL_TYPE_MOD    = 3;

  MSG_MODE_DISPLAY_CONNECTION = 1;
  MSG_MODE_MSG_LOG            = 3;
  MSG_MODE_SEND_CLASS_HANDEL  = 4;
  MSG_MODE_SYSTEM_INFO_REQ    = 5;
  MSG_MODE_UPDATE_SEQ_START   = 6;
  MSG_MODE_UPDATE_SEQ_STEP    = 7;
  MSG_MODE_INSPECT_ON         = 8;
  MSG_MODE_INSPECT_OFF        = 9;
  MSG_MODE_INSPECT_MC         = 10;
  MSG_MODE_UPDATE_CALL_STATUS   = 11;
  MSG_MODE_SEND_INSPECT_STATUS  = 12;
  MSG_MODE_UPDATE_AUTO_LOGIN    = 13;
  MSG_MODE_UPDATE_RESULT        = 14;
  MSG_MODE_SYSTEM_INFO_CALL     = 15;
  MSG_MODE_EAYT_INFO_CALL       = 18;
  MSG_MODE_EAYT_INSPECT_STATUS  = 19;
  MSG_MODE_UPDATE_HANDLE_SEND   = 20;
  MSG_MODE_EADR_INFO            = 21;
  MSG_MODE_INSPECTOR_READY      = 22;
  MSG_MODE_INSPECTOR_READY_RTN  = 23;
  MSG_MODE_INSP_UPDATE_FINISH   = 24;
  MSG_MODE_UPDATE_EAAR_RESULT   = 25;
  MSG_MODE_UPDATE_SW_CLOSE      = 26;
  MSG_MODE_CONNECT_INTERVAL     = 27;
  MSG_MODE_1CG_PANEL            = 28;
  MSG_MODE_MAX_INFO             = MSG_MODE_1CG_PANEL;

  MSG_PARAM_EADR_INFO_RECIPE    = 1;
  MSG_PARAM_EADR_INFO_LINE      = 2;
  MSG_PARAM_EADR_INFO_PRODUCT   = 3;
  MSG_PARAM_EADR_INFO_RECIPE2   = 4;
  MSG_PARAM_EADR_MODEL_FILE2    = 5;

  MSG_PARA_REQ_CUR_EQPID        = 1;
  MSG_PARA_REQ_USER_ID          = 2;
  MSG_PARA_REQ_OLD_SW_VERSION   = 3;
  MSG_PARA_REQ_NEW_SW_VERSION   = 4;
  MSG_PARA_REQ_OLD_MODEL_CH1    = 5;
  MSG_PARA_REQ_OLD_MODEL_CH2    = 6;
  MSG_PARA_REQ_NEW_MODEL_CH1    = 7;
  MSG_PARA_REQ_NEW_MODEL_CH2    = 8;
  MSG_PARA_REQ_EAYT_STATUS      = 9;
  MSG_PARA_REQ_APP_PATH         = 10;
  MSG_PARA_REQ_LINE_MODE        = 11;
  MSG_PARA_REQ_INSPECT_MODEL    = 12;
  MSG_PARA_REQ_INSPECT_MODEL2   = 13;
  MSG_PARA_REQ_EADR_MODEL       = 14;
  MSG_PARA_REQ_EADR_MODEL2      = 15;
//{$IFDEF AUTO_INS_MODE}
//
//
//{$ENDIF}

  MSG_PARA_REQ_MAX              = MSG_PARA_REQ_EADR_MODEL;

  MSG_PARA_REQ_LINE_INLINE      = 0;
  MSG_PARA_REQ_LINE_PGIB        = 1;
  MSG_PARA_REQ_LINE_MGIB        = 2;
  MSG_PARA_REQ_LINE_REPAIR      = 3;
  MSG_PARA_REQ_LINE_SELECT_NG   = 10;

  MSG_PARA_CALL_ALL_INFO        = 7;
  MSG_PARA_CALL_EAYT_INFO       = 8;

  MSG_PARA_CONNECT_INSPECTOR    = 10;
  MSG_PARA_DISCONNECT_INSPECTOR = 11;
  MSG_PARA_SHOW_WARNING_MESSAGE = 12;
  MSG_PARA_DLL_HANDLE           = 13;
  MSG_PARA_GMES_INIT            = 14;

  AIMF_PRODUCT_INLINE           = 'INLINE';
  AIMF_PRODUCT_PGIB             = 'PGIB';
  AIMF_PRODUCT_MGIB             = 'MGIB';
  AIMF_PRODUCT_REPAIR           = 'REPAIR';

type

  PGuiAimfComm = ^RGuiAimfComm;
  RGuiAimfComm = record
    MsgType   : Integer;
    Channel   : Integer;
    Mode      : Integer;
    Param     : Integer;
    Param2    : Integer;
    Handle    : HWND;
    //HandleSelf : Integer;
    Msg       : string[250];
  end;

implementation

end.
