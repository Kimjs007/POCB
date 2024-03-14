unit DefSerialComm;

interface
const
  COMBUFF         = 4095;    //Comm Port¿ë Buffer Size
  MAX_RX_CNT      = 1000;
  STX             = #02;
  ETX             = #03;
  CR              = #13;
  LF              = #10;
  SYN             = #22;
  CRLF            = #13#10;
  LFCR            = #10#13;
  RCB_STX         = '[';
  RCB_ETX         = ']';
  SF5             = #$f5;
  SF1             = #$f1;
  PG_PRO_ST       = STX  + SF1+ SF5 ;
  MAX_SERIAL_NUM  = 100;
implementation

end.
