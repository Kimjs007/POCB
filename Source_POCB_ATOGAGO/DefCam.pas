unit DefCam;

interface
{$I Common.inc}

  const
    // GPC(Inspector-PC), DPC(Camera-PC)
{$IFDEF SIMULATOR_CAM}
    BASE_TCP_SERVER_IP  = '192.168.102.11';
    BASE_TCP_CLINT_IP   = '192.168.102.';
{$ELSE}
    BASE_TCP_SERVER_IP  = '192.168.2.11';
    BASE_TCP_CLINT_IP   = '192.168.2.';
{$ENDIF}
    BASE_DPC_IPADDR     = 31;

    BASE_SERVER_PORT    = 2291; // G Server
    BASE_CLINT_PORT     = 1961; // D Server // = DPC TCP Server Port

    //
    TIMEVAL_CAM_CONNWAIT  = 1000;  // msec
    TIMEVAL_CAM_RESPWAIT  = 10000; // msec  //2018-12-08 3000 -> 5000 //2023-06-22 5000 -> 10000

    TCP_BUFF_SIZE       = 700000;

    //m_nRevEvnt 에 대한 Return 값.
    RET_NONE = 1;
    RET_ACK  = 2;
    RET_NAK  = 3;

    CAM_CONNECT_FIRST_OK = 0;
    CAM_CONNECT_OK       = 1;
    CAM_CONNECT_NG       = 2;

    CAM_STEP_NONE  = 0;
    CAM_STEP_CB1   = 1;
    CAM_STEP_CB2   = 2;
    CAM_STEP_CB3   = 3;
    CAM_STEP_CB4   = 4;
    CAM_STEP_EXTRA = 5;
    CAM_STEP_MAX = CAM_STEP_EXTRA;

{ //2019-01-15 POCB DPC-to-GPC Error Code
  // Camera
  01 - Fail to init camera library.
  02 - Fail to connect camera.
  03 - Fail to set exposure time.
  04 - Fail to set trigger.
  // LGD Library
  05 - Fail to init library.
  06 - Fail to run pocb.
  07 - Fail to find result image. (BMP 1)
  08 - Fail to find result image. (BMP 2)
  09 - Fail to find result image. (BMP 3)
  10 - Fail to find result image. (BMP 4)
  // Sequence
  11 - Unknown model name.
  12 - Fail to read gamma data.
  13 - Fail to find result hex file.
  14 - Timeout - Read Gamma Data.
  15 - Timeout - Pattern Display (Pattern 0, Cal Pattern)
  16 - Timeout - Pattern Display (Pattern 1, R63)
  17 - Timeout - Pattern Display (Pattern 2, R127)
  18 - Timeout - Pattern Display (Pattern 3, R255)
  19 - Timeout - Pattern Display (Pattern 4, G63)
  20 - Timeout - Pattern Display (Pattern 5, G127)
  21 - Timeout - Pattern Display (Pattern 6, G255)
  22 - Timeout - Pattern Display (Pattern 7, B63)
  23 - Timeout - Pattern Display (Pattern 8, B127)
  24 - Timeout - Pattern Display (Pattern 9, B255)
  25 - Timeout - Result Display (BMP1)
  26 - Timeout - Result Display (BMP2)
  27 - Timeout - Result Display (BMP3)
  28 - Timeout - Result Display (BMP4)
  29 - Timeout - Write Pocb result file.
  30 - Timeout - Write Pocb result image. (BMP1)
  31 - Timeout - Write Pocb result image. (BMP2)
  32 - Timeout - Write Pocb result image. (BMP3)
  33 - Timeout - Write Pocb result image. (BMP4)
  34 - Timeout - TEND.
  35 - Error Brightness
  36 - Error Darkness
  37 - Error Uniformity
  //  LGD Algorithm
  51 - No Image
  52 - Abscent of Calibration Image
  53 - Abscent of Calibration dot pattern
  54 - Abscent of Shape pattern
  55 - Abscent of White Image
  56 - Abscent of RED PTN
  57 - Abscent of GREEN PTN
  58 - Abscent of BLUE PTN
  59 - Abscent of Golden Pose
  60 - Dot pattern error
  61 - Calibration, Dot No is different
  62 - Unknown Calibration Error
  63 - Too many black dots.
  64 - Left Top Dot is not Found
  65 - Right Bottom Dot is not Found
  66 - Both of Left Top Dot and Right Bottom Dot are not Found
  67 - Too large Input Image, One or more images are too large, Hex file cannot generated
}
  DPC2GPC_NGCODE_MAX  = 99;

type
  enumCamRetType = (camRetOk=0, camRetNak, camRetTimeout, camRetCommErr, camRetTendNG, camRetUnitformityNG, camRetStopByAlarm, camRetStopByOperator, camRetUnknown);

implementation

end.
