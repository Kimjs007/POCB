unit DefEziServo;

interface

const

  //
  MODE_MOTOR_CONNECT      = 1;
  MODE_MOTOR_BOARD_CHECK  = 2;
  MODE_GET_SLAVE_INFO     = 3;
  MODE_ABS_AXIS_MOVE      = 4;
  MODE_INC_AXIS_MOVE      = 5;
  MODE_MOVE_STOP          = 6;
  MODE_GET_ACTUAL_POS     = 7;
  // Returncode define.h
  FMM_OK                  = 0;
  FMM_NOT_OPEN            = 1;
  FMM_INVALID_PORT_NUM    = 2;
  FMM_INVALID_SLAVE_NUM   = 3;

  FMC_DISCONNECTED        = 5;
  FMC_TIMEOUT_ERROR       = 6;
	FMC_CRCFAILED_ERROR     = 7;
	FMC_RECVPACKET_ERROR    = 8;
  FMM_POSTABLE_ERROR      = 9;

  FMP_FRAMETYPEERROR      = $80;
  FMP_DATAERROR           = FMP_FRAMETYPEERROR + 1;
	FMP_PACKETERROR         = FMP_FRAMETYPEERROR + 2;
	FMP_RUNFAIL             = $85;
	FMP_RESETFAIL           = FMP_RUNFAIL + 1;
	FMP_SERVOONFAIL1        = FMP_RUNFAIL + 2;
	FMP_SERVOONFAIL2        = FMP_RUNFAIL + 3;
	FMP_SERVOONFAIL3        = FMP_RUNFAIL + 4;
	FMP_SERVOOFF_FAIL       = FMP_RUNFAIL + 5;
	FMP_ROMACCESS           = FMP_RUNFAIL + 6;

  FMP_PACKETCRCERROR      = $AA;
  FMM_UNKNOWN_ERROR       = $FF;

implementation

end.
