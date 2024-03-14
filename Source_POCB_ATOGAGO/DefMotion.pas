unit DefMotion;

interface
{$I Common.inc}

//==============================================================================
// A2CH Motion Controller
//    ǰ��        ǰ���      �԰�                                      ����
//                SMC-2V02    CAMC-FS 2Axes Motion Control Board        1EA
//    K62-00023   T68-PR      68Pin Motion Terminal Block, Screw Type   ?EA
//    K71-00066   C6868-3TS   68Pin to 68Pin Twiste Shielded Cable, 3M  ?EA
//
// F2CH Motion Controller
//    ǰ��        ǰ���      �԰�                                      ����
//    K62-00017   PCI-N804    CAMC-AI 8Axes Motion Control Board        1EA
//    K62-00023   T68-PR      68Pin Motion Terminal Block, Screw Type   3EA
//    K71-00066   C6868-3TS   68Pin to 68Pin Twiste Shielded Cable, 3M  3EA
//==============================================================================
// MR-J4
//    PA21 : (defualt) 0001   --> (����) 1001  // Control by Motion Controller
//    PA05 : (default) 10000                   // ����(10000) = UNITpPULSE(0.001)
//==============================================================================
const
  FORMAT_MOTIONPOS 	= '0.##0';  //2019-03-19
  MOTION_POS_TOLERANCE = 0.1;   //2021-10-27

  {$IF Defined(ITOLED_POCB)}
  PULSE_OUT_METHOD_Y_AXIS = 6;  //6=TwoCwCcwHigh //ServoMotor(Panasonic) ITOLED|A2CHv4#3|ATO Y-AXIS
  {$ELSEIF Defined(POCB_ATO) or Defined(POCB_GAGO)}
  PULSE_OUT_METHOD_Y_AXIS = 6;  //6=TwoCwCcwHigh //ServoMotor(Panasonic) ITOLED|A2CHv4#3|ATO Y-AXIS
  {$ELSE}
  PULSE_OUT_METHOD_Y_AXIS = 4;  //4=TwoCcwCwHigh //ServoMotor(Mitsubishi)
  {$ENDIF}
  PULSE_OUT_METHOD_Z_AXIS = 4;  //4=TwoCcwCwHigh
  PULSE_OUT_METHOD_T_AXIS = 4;  //4=TwoCcwCwHigh

  MAX_Y_AXIS_HOME_SPEED = 150;         // Added by Kimjs007 2024-02-23 ���� 4:53:47

type

  RMotionParam = record
    dUnit             : Double;   //for F2CH
    dPulse            : LongInt;  //for F2CH
    dUnitPerPulse     : Double;   // = Unit/Pulse (if dPulse is not 0)
    dStartStopSpeed   : Double;
    dStartStopSpeedMax: Double;
    dVelocity         : Double;
    dVelocityMax      : Double;
    dAccel            : Double;
    dAccelMax         : Double;
    dDecel            : Double;   //for F2CH (= dAccel) //TBD:MOTION:AXM?
    dSoftLimitUse     : LongInt;
    dSoftLimitMinus   : Double;
    dSoftLimitPlus    : Double;
    dJogVelocity      : Double;
    dJogVelocityMax   : Double;
    dJogAccel         : Double;
    dJogAccelMax      : Double;
{$IFDEF HAS_MOTION_CAM_Z}
    dConfigZModelPos  : Double;
{$ENDIF}
    dConfigYLoadPos   : Double;
    dConfigYCamPos    : Double;
{$IFDEF HAS_MOTION_TILTING}
    dConfigTFlatPos   : Double;
    dConfigTUpPos     : Double;
{$ENDIF}
    dPulseOutMethod   : Cardinal; //2022-08-05 (DOWRD=Cardinal)
  end;

  enumMotionSyncStatus = (SyncUnknown=0, SyncNone=1, SyncLinkMaster=2, SyncLinkSlave=3, SyncGantryMaster=4, SyncGantrySlave=5); //TBD:A2CHv3:MOTION:SYNC-MOVE?

  MotionStatusRec = record
    //--------------------------------------------------------------------------
    //----- ���� ���� �ʱ�ȭ
    // Unit/Pulse ����
    UnitPerPulse  : Double;   // CFS20get_moveunit_perpulse (axis : SmallInt) : Double;
                              //    Unit/Pulse : 1 pulse�� ���� system�� �̵��Ÿ� (Unit�� ������ ����ڰ� ���Ƿ� ����)
                              // Ex) Ball screw pitch : 10mm, ���� 1ȸ���� �޽��� : 10000
                              //      ==> Unit�� mm�� ������ ��� : Unit/Pulse = 10/10000.
                              //      ���� unitperpulse�� 0.001�� �Է��ϸ� ��� ��������� mm�� ������.
                              // Ex) Linear motor�� ���ش��� 1 pulse�� 2 uM.
                              //      ==> Unit�� mm�� ������ ��� : Unit/Pulse = 0.002/1.
    // ���� �ӵ� ���� (Unit/Sec)
    StartStopSpeed: Double;   // CFS20get_startstop_speed (axis : SmallInt) : Double;
    // �ְ� �ӵ� ���� (Unit/Sec, ���� system�� �ְ� �ӵ�)
    MaxSpeed      : Double;   // CFS20get_max_speed (axis : SmallInt) : Double;
    //----- ���� ���� Ȯ��
    // ���� ���� �޽� ���������
    IsInMotion    : Boolean;  // ActMC: CFS20in_motion (axis : SmallInt) : Boolean;
    // ���� ���� �޽� ����� ����ƴ���
    IsMotionDone  : Boolean;  // ActMC: CFS20motion_done (axis : SmallInt) : Boolean;
    // ���� ���� EndStatus �������͸� Ȯ��
    EndStatus     : WORD;     // AxtMC: CFS20get_end_status (axis : SmallInt) : Word; stdcall;
                              //  - End Status Bit�� �ǹ�
                              //      14bit : Limit(PELM, NELM, PSLM, NSLM, Soft)�� ���� ����
                              //      13bit : Limit ���� ������ ���� ����
                              //      12bit : Sensor positioning drive����
                              //      11bit : Preset pulse drive�� ���� ����(������ ��ġ/�Ÿ���ŭ �����̴� �Լ���)
                              //      10bit : ��ȣ ���⿡ ���� ����(Signal Search-1/2 drive����)
                              //      9 bit : ���� ���⿡ ���� ����
                              //      8 bit : Ż�� ������ ���� ����
                              //      7 bit : ����Ÿ ���� ������ ���� ����
                              //      6 bit : ALARM ��ȣ �Է¿� ���� ����
                              //      5 bit : ������ ��ɿ� ���� ����
                              //      4 bit : �������� ��ɿ� ���� ����
                              //      3 bit : ������ ��ȣ �Է¿� ���� ���� (EMG Button)
                              //      2 bit : �������� ��ȣ �Է¿� ���� ����
                              //      1 bit : Limit(PELM, NELM, Soft) �������� ���� ����
                              //      0 bit : Limit(PSLM, NSLM, Soft) ���������� ���� ����
    // ���� ���� Mechanical ��������
    MechSignal    : WORD;     // AxtMC: CFS20get_mechanical_signal(axis)
                              //  - Mechanical Signal Bit�� �ǹ�
                              //      12bit : ESTOP ��ȣ �Է� Level
                              //      11bit : SSTOP ��ȣ �Է� Level
                              //      10bit : MARK ��ȣ �Է� Level
                              //      9 bit : EXPP(MPG) ��ȣ �Է� Level
                              //      8 bit : EXMP(MPG) ��ȣ �Է� Level
                              //      7 bit : Encoder Up��ȣ �Է� Level(A�� ��ȣ)
                              //      6 bit : Encoder Down��ȣ �Է� Level(B�� ��ȣ)
                              //      5 bit : INPOSITION ��ȣ Active ����
                              //      4 bit : ALARM ��ȣ Active ����
                              //      3 bit : -Limit �������� ��ȣ Active ���� (Ver3.0���� ����������)
                              //      2 bit : +Limit �������� ��ȣ Active ���� (Ver3.0���� ����������)
                              //      1 bit : -Limit ������ ��ȣ Active ����
                              //      0 bit : +Limit ������ ��ȣ Active ��
    //----- ��ġ Ȯ��
    // �ܺ� ��ġ �� (position: Unit)
    ActualPos     : Double;   // CFS20get_actual_position (axis : SmallInt) : Double;
    // ���� ��ġ �� (position: Unit)
    CommandPos    : Double;   // CFS20get_command_position (axis : SmallInt) : Double;
    // ���� ���� Command position�� Actual position�� ���� Ȯ���Ѵ�.
    ActCmdPosDiff : Double;
    //----- ���� ����̹�
    // ���� Enable(On) / Disable(Off)
    ServoEnable   : BYTE;     // CFS20get_servo_enable (axis : SmallInt) : Byte;
    // ���� ��ġ�����Ϸ�(inposition)�Է� ��ȣ�� �������
    UseInPosSig   : BYTE;     // CFS20get_inposition_enable (axis : SmallInt) : Byte;
    // ���� �˶� �Է½�ȣ ����� �������
    UseAlarmSig   : BYTE;     // CFS20get_alarm_enable (axis : SmallInt) : Byte;
    //----- ���� �����
    UnivInSignal  : BYTE;     //
                              // AXT AxmMC Universal Input Signal   //
                              //      0 bit : Home Signal
                              //      1 bit : Encoder Z phase Signal
                              //      2~4 bit : Univesal Input Signal
                              // AXT AxtMC Universal Input Signal   // CFS20get_input (axis : SmallInt) : Byte
                              //      0 bit : ���� �Է� 0(ORiginal Sensor)
                              //      1 bit : ���� �Է� 1(Z phase)
                              //      2 bit : ���� �Է� 2
                              //      3 bit : ���� �Է� 3
                              //      4 bit(PLD) : ���� �Է� 5
                              //      5 bit(PLD) : ���� �Է� 6
                              //        On ==> ���ڴ� N24V, 'Off' ==> ���ڴ� Open(float).
    UnivOutSignal : BYTE;     // CFS20get_output (axis : SmallInt) : Byte
                              //      0 bit : ���� ��� 0(Servo-On)
                              //      1 bit : ���� ��� 1(ALARM Clear)
                              //      2 bit : ���� ��� 2
                              //      3 bit : ���� ��� 3
                              //      4 bit(PLD) : ���� ��� 4
                              //      5 bit(PLD) : ���� ��� 5

    //
    bMechSignalLimitPlusOn  : Boolean;  // (MechSignal and (1 shl 0))  //TBD:A2CHv3:MOTION?
    bMechSignalLimitMinusOn : Boolean;  // (MechSignal and (1 shl 1))
    bMechSignalAlarmOn      : Boolean;  // (MechSignal and (1 shl 4))
    bUnivInSignalHomeOn     : Boolean;  // (UnivInSignal and (1 shl 0))
    bUnivInSignalServoOn    : Boolean;  // (UnivInSignal and (1 shl 2))
    bUnivOutSignalServoOn   : Boolean;  // (UnivOutSignal and (1 shl 0))
    bUnivInSignalLoadPosOn  : Boolean;  // (UnivInSignal and (1 shl 3))

    //--------------------------------------------------------------------------
    {$IFDEF SUPPORT_1CG2PANEL} //MOTION_SYNCMOVE
    nSyncStatus          : enumMotionSyncStatus;
    nSyncOtherAxis       : LongInt;
    // for SyncLinkMaster|SyncLinkSlave
    dSyncLinkSlaveRatio  : Double;
    // for SyncGantryMaster|SyncGantrySlave
  //nSyncGantrySlHomeUse : Integer; // Master�� ���� Slave �൵ ���� �˻��� ���� �� ������ ���� �ϴ� ���� //DWORD  //TBD:A2CHv3:SYNC_MODE?
                                    //    00 : Master �ุ ���� �˻� ����
                                    //    01 : Master ��� Slave �� ��� ���� �˻� ����
                                    //    02 : Master ��� Slave ���� ������ ���� �� Ȯ��
  //dSyncGantrySlOffset      : Double; // Master���� ���� ������ Slave �� ���� ���� ���� �ⱸ���� ���� ��
  //dSyncGantrySlOffsetRange : Double; // �����˻� �� Master ���� ���� ������ Slave �� ���� ���� ���� ����� �ִ� ���� �� ����
    {$ENDIF}
  end;

const

  //****************************************************************************
  // LGD ���� �䱸��� (2018-11-13)
  //    - Jog max Speed   : 100 mm ����
  //    - ���� ���� ����  : mm
  //****************************************************************************

	//****************************************************************************
	//
	//****************************************************************************

	//-------------------------- Motion Device Type
  MOTION_DEV_Unknown		= 0;
  MOTION_DEV_AxtMC			= 1;	// AXT MotionControl - Stage 1&2, Y_Axis/Z_Axis //A2CH & F2CH
  MOTION_DEV_AxmMC			= 2;	// AXM MotionControl - Stage 1&2, Tinting       //F2CH
  MOTION_DEV_EziML			= 3;	// Ezi MotionLink PE - Stage 1&2, Focus

	//-------------------------- Motion Axis Type
  MOTION_AXIS_Y      		= 0;  // Motion Axis - Y-Axis   //A2CH & F2CH
  MOTION_AXIS_Z      		= 1;  // Motion Axis - Z-Axis   //A2CH & F2CH
  MOTION_AXIS_T     		= 2;  // Motion Axis - Tilting  //F2CH
{$IF Defined(HAS_MOTION_TILTING)}
  MOTION_AXIS_MAX    		= MOTION_AXIS_T;
{$ELSEIF Defined(HAS_MOTION_CAM_Z)}
  MOTION_AXIS_MAX    		= MOTION_AXIS_Z;
{$ELSE}
  MOTION_AXIS_MAX    		= MOTION_AXIS_Y;
{$ENDIF}
  MOTION_AXIS_CNT    		= MOTION_AXIS_MAX + 1;

  // Motion ID - nCh/mAxisType (POCB_X2CH-specific)
{$IFDEF HAS_MOTION_CAM_Z}
  MOTIONID_AxMC_STAGE1_Z	= 0;	// Ajinextek AXT/AXM MotionControl - Stage 2, Y_Axis  //A2CH|A2CHv2|F2CH
  MOTIONID_AxMC_STAGE2_Z	= 1;	// Ajinextek AXT/AXM MotionControl - Stage 2, Z_Axis  //A2CH|A2CHv2|F2CH
  MOTIONID_AxMC_STAGE1_Y	= 2;	// Ajinextek AXT/AXM MotionControl - Stage 1, Y_Axis  //A2CH|A2CHv2|F2CH
  MOTIONID_AxMC_STAGE2_Y	= 3;	// Ajinextek AXT/AXM MotionControl - Stage 1, Z_Axis  //A2CH|A2CHv2|F2CH
{$ELSE}
  MOTIONID_AxMC_STAGE1_Y	= 0;	// Ajinextek AXT/AXM MotionControl - Stage 1, Y_Axis  //A2CHv3|A2CHv4
  MOTIONID_AxMC_STAGE2_Y	= 1;	// Ajinextek AXT/AXM MotionControl - Stage 1, Z_Axis  //A2CHv3|A2CHv4
{$ENDIF}
{$IFDEF HAS_MOTION_TILTING}
  MOTIONID_AxMC_STAGE1_T	= 4;	// Ajinextek AXT/AXM MotionControl - Stage 1, Tilting_Axis  //F2CH
  MOTIONID_AxMC_STAGE2_T	= 5;	// Ajinextek AXT/AXM MotionControl - Stage 2, Tilting_Axis  //F2CH
{$ENDIF}
  MOTIONID_BASE					 	= 0;	// =
{$IF Defined(HAS_MOTION_TILTING)}
  MOTIONID_MAX					 	= MOTIONID_AxMC_STAGE2_T;	// = MOTIONID_AxMC_STAGE2_T //F2CH
{$ELSEIF Defined(HAS_MOTION_CAM_Z)}
  MOTIONID_MAX					 	= MOTIONID_AxMC_STAGE2_Y;	// = MOTIONID_AxMC_STAGE2_Y //A2CH|A2CHv2
{$ELSE}
  MOTIONID_MAX					 	= MOTIONID_AxMC_STAGE2_Y;	// = MOTIONID_AxMC_STAGE2_Y //A2CHv3|A2CHv4
{$ENDIF}
  MOTIONID_CNT					 	= MOTIONID_MAX + 1;

  MOTION_SYNCMODE_SLAVE_UNKNOWN = -1;  //A2CHv3:MOTION:SYNC-MOVE
  MOTION_SYNCMODE_SLAVE_RATIO   = 1.0; //A2CHv3:MOTION:SYNC-MOVE (Master:Slave = 1:1)

  // Ajinexttek Axt/Axm MotionControl - Module(Axis) No (POCB_X2CH-specific)
{$IFDEF HAS_MOTION_CAM_Z}
  AxMC_AXISNO_STAGE1_Z 		= MOTIONID_AxMC_STAGE1_Z;
  AxMC_AXISNO_STAGE2_Z 		= MOTIONID_AxMC_STAGE2_Z;
{$ENDIF}	
  AxMC_AXISNO_STAGE1_Y 		= MOTIONID_AxMC_STAGE1_Y;
  AxMC_AXISNO_STAGE2_Y 		= MOTIONID_AxMC_STAGE2_Y;
{$IFDEF HAS_MOTION_TILTING}
  AxMC_AXISNO_STAGE1_T 		= MOTIONID_AxMC_STAGE1_T;  //F2CH
  AxMC_AXISNO_STAGE2_T 		= MOTIONID_AxMC_STAGE2_T;  //F2CH
{$ENDIF}
  AxMC_AXISNO_BASE 				= MOTIONID_BASE; 	//
	
  AxMC_AXISNO_MAX 				= MOTIONID_MAX;
  AxMC_AXISNO_CNT 				= AxMC_AXISNO_MAX + 1;

  // Ezi MotionLink PE - Board ID
  EziML_BDNO_STAGE1_F   = 0;
  EziML_BDNO_STAGE2_F   = 1;
  EziML_BDNO_BASE    		= 0;	// = EziML_BDNO_STAGE1_F
  EziML_BDNO_MAX        = 1;	// = EziML_BDNO_STAGE2_F
  EziML_BDNO_CNT        = EziML_BDNO_MAX + 1;

  IN_MOTOR_STAGE1_FORWARD   = 0;
  IN_MOTOR_STAGE1_BACKWARD  = 1;
  IN_MOTOR_STAGE2_FORWARD   = 2;
  IN_MOTOR_STAGE2_BACKWARD  = 3;
{$IFDEF HAS_MOTION_TILTING}
  IN_MOTOR_STAGE1_TILTUP    = 4;   //F2CH
  IN_MOTOR_STAGE1_TILTDOWN  = 5;   //F2CH
  IN_MOTOR_STAGE2_TILTUP    = 6;   //F2CH
  IN_MOTOR_STAGE2_TILTDOWN  = 7;   //F2CH
{$ENDIF}

  MASK_IN_MOTOR_STAGE1_FORWARD   = $1;
  MASK_IN_MOTOR_STAGE1_BACKWARD  = $2;
  MASK_IN_MOTOR_STAGE2_FORWARD   = $4;
  MASK_IN_MOTOR_STAGE2_BACKWARD  = $8;
{$IFDEF HAS_MOTION_TILTING}
  MASK_IN_MOTOR_STAGE1_TILTUP    = $10;   //F2CH
  MASK_IN_MOTOR_STAGE1_TILTDOWN  = $20;   //F2CH
  MASK_IN_MOTOR_STAGE2_TILTUP    = $40;   //F2CH
  MASK_IN_MOTOR_STAGE2_TILTDOWN  = $80;   //F2CH
{$ENDIF}

  OUT_MOTOR_STAGE1_FORWARD  = 0;
  OUT_MOTOR_STAGE1_BACKWARD = 1;
  OUT_MOTOR_STAGE2_FORWARD  = 2;
  OUT_MOTOR_STAGE2_BACKWARD = 3;
{$IFDEF HAS_MOTION_TILTING}
  OUT_MOTOR_STAGE1_TILTUP   = 4;  //F2CH
  OUT_MOTOR_STAGE1_TILTDOWN = 5;  //F2CH
  OUT_MOTOR_STAGE2_TILTUP   = 6;  //F2CH
  OUT_MOTOR_STAGE2_TILTDOWN = 7;  //F2CH
{$ENDIF}

  MASK_OUT_MOTOR_STAGE1_FORWARD  = $1;
  MASK_OUT_MOTOR_STAGE1_BACKWARD = $2;
  MASK_OUT_MOTOR_STAGE2_FORWARD  = $4;
  MASK_OUT_MOTOR_STAGE2_BACKWARD = $8;
{$IFDEF HAS_MOTION_TILTING}
  MASK_OUT_MOTOR_STAGE1_TILTUP   = $10;  //F2CH
  MASK_OUT_MOTOR_STAGE1_TILTDOWN = $20;  //F2CH
  MASK_OUT_MOTOR_STAGE2_TILTUP   = $40;  //F2CH
  MASK_OUT_MOTOR_STAGE2_TILTDOWN = $80;  //F2CH
{$ENDIF}

{$IF Defined(USE_MOTION_AXM) or Defined(USE_MOTION_AXT)}
	//****************************************************************************
	// Ajinextek AXT MotionControl - CAMC-FS(SMC-2V02)
	// Ajinextek AXM MotionControl - CAMC-AI(PCI-N804)
	//****************************************************************************

  // Ajinextek AXT/AXM MotionControl - Default Motion Control Parameters, System COnfig ���Ϸ� ����  //POCB_X2CH-specific
  //  - Y ��
  //      unit/pulse    = 1 / 1000 * 20
  //          Amp Tuning �� : 1000    --> AMP������ü���� ���� �°� Tunning   ...pulse
  //          Motor ���尪  : 20 mm   --> �ⱸ������ ���� ����                  ...unit
  //      velocity      = 100 (�ʴ� �̵��ӵ�) --> �ʴ� 100mm �̵�
  //      acceleration  = 200 (velocity * 2)  --> AXT���� S/W���� �⺻�� ���� ��� (velocity *2)
  //      -Limit ~ Home = -21 (-Limit ~ Home Sensor, ���� mm), Stage Backward (Loading)
  //      Home ~ +Limit = 905 (Home Sensor ~ +Limit Sensor ������, ���� mm), Stage Forward
//AxMC_Y_AXIS_MOTOR_AMP        = 1000;   // Motor Amp Tunning ��
{$IF Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
  AxMC_Y_AXIS_UNIT             = 10;     // = 1 / 1000 * 20  //A2CHv3|A2CHv4
  AxMC_Y_AXIS_PULSE            = 10000;  // = 1 / 1000 * 20  //A2CHv3|A2CHv4
  AxMC_Y_AXIS_UNITpPULSE       = 0.001;  // = 1 / 1000 * 20  //A2CHv3|A2CHv4
{$ELSE}
  AxMC_Y_AXIS_UNIT             = 20;     // = 1 / 1000 * 20  //A2CH|A2CHv2|F2CH
  AxMC_Y_AXIS_PULSE            = 1000;   // = 1 / 1000 * 20  //A2CH|A2CHv2|F2CH
  AxMC_Y_AXIS_UNITpPULSE       = 0.02;   // = 1 / 1000 * 20  //A2CH|A2CHv2|F2CH
{$ENDIF}
  AxMC_Y_AXIS_STARTSTOPSPEED   = 1;      // =
  AxMC_Y_AXIS_VELOCITY         = 100;    // = �ʴ� 100mm �̵� (LGD �������: 100 ����?)
  AxMC_Y_AXIS_ACCEL            = 200;    // = Velocity

{$IF Defined(POCB_A2CH)}
  AxMC_Y_AXIS_POS_LIMIT_MINUS  = -21;    //������
  AxMC_Y_AXIS_POS_LIMIT_PLUS   = 890;    //������
{$ELSEIF Defined(POCB_A2CHv2)}
  AxMC_Y_AXIS_POS_LIMIT_MINUS  = -6;     //������
  AxMC_Y_AXIS_POS_LIMIT_PLUS   = 750;    //������
{$ELSEIF Defined(POCB_A2CHv3)}
  AxMC_Y_AXIS_POS_LIMIT_MINUS  = -39;    //������
  AxMC_Y_AXIS_POS_LIMIT_PLUS   = 779;    //������
{$ELSEIF Defined(POCB_A2CHv4) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
  AxMC_Y_AXIS_POS_LIMIT_MINUS  = -29;    //������
  AxMC_Y_AXIS_POS_LIMIT_PLUS   = 797;    //������
{$ENDIF}

  Y_AXIS_CMDPOS_HOME_START = 1.0; //TBD:A2CHv3:MOTION?

{$IFDEF HAS_MOTION_CAM_Z}
  //  - Z ��
  //      unit/pulse    = 1 / 1000 * 10
  //          Amp Tuning �� : 1000    --> AMP������ü���� ���� �°� Tunning   ...unit
  //          Motor ���尪  : 10 mm   --> �ⱸ������ ���� ����                  ...pulse
  //      velocity      = 100 (�ʴ� �̵��ӵ�) --> �ʴ� 100mm �̵�
  //      acceleration  = 200 (velocity * 2)  --> AXT���� S/W���� �⺻�� ���� ��� (velocity *2)
  //      -Limit ~ Home = -21 (-Limit ~ Home Sensor, ���� mm), Stage Backward (Loading)
  //      Home ~ +Limit = 905 (Home Sensor ~ +Limit Sensor ������, ���� mm), Stage Forward
  AxMC_Z_AXIS_MOTOR_AMP        = 1000;   // Motor Amp Tunning ��
  AxMC_Z_AXIS_UNIT             = 10;     // = 1 / 1000 * 10
  AxMC_Z_AXIS_PULSE            = 1000;   // = 1 / 1000 * 10
  AxMC_Z_AXIS_UNITpPULSE       = 0.01;   // = 1 / 1000 * 10
  AxMC_Z_AXIS_STARTSTOPSPEED   = 1;      // =
  AxMC_Z_AXIS_VELOCITY         = 100;    // = �ʴ� 100mm �̵� (LGD �������: 100 ����?)
  AxMC_Z_AXIS_ACCEL            = 200;    // = Velocity

  {$IF Defined(POCB_A2CH)}
  AxMC_Z_AXIS_POS_LIMIT_MINUS  = -21;    //A2CH = ������
  AxMC_Z_AXIS_POS_LIMIT_PLUS   = 543;    //A2CH = ������
  {$ELSEIF Defined(POCB_A2CHv2)}
  AxMC_Z_AXIS_POS_LIMIT_MINUS  = -6;     //F2CH = ������
  AxMC_Z_AXIS_POS_LIMIT_PLUS   = 580;    //F2CH = ������
  {$ELSEIF Defined(POCB_F2CH)}
  AxMC_Z_AXIS_POS_LIMIT_MINUS  = -6;     //F2CH = ������
  AxMC_Z_AXIS_POS_LIMIT_PLUS   = 580;    //F2CH = ������
  {$ENDIF}
{$ENDIF} //HAS_MOTION_CAM_Z

{$IFDEF HAS_MOTION_TILTING}
  //  - T ��  //F2CH
  //      unit/pulse    = 1 / 1000 * 10
  //          Amp Tuning �� : 1000     --> AMP������ü���� ���� �°� Tunning
  //          Motor ���尪  : 10 mm   --> �ⱸ������ ���� ����
  //      velocity      = 100 (�ʴ� �̵��ӵ�) --> �ʴ� 100mm �̵�
  //      acceleration  = 200 (velocity * 2)  --> AXT���� S/W���� �⺻�� ���� ��� (velocity *2)
  //      -Limit ~ Home = -21 (-Limit ~ Home Sensor, ���� mm), Stage Backward (Loading)
  //      Home ~ +Limit = 905 (Home Sensor ~ +Limit Sensor ������, ���� mm), Stage Forward
  AxMC_T_AXIS_MOTOR_AMP        = 1000;   // Motor Amp Tunning ��
  AxMC_T_AXIS_UNIT             = 10;     // = 1 / 1000 * 10
  AxMC_T_AXIS_PULSE            = 1000;   // = 1 / 1000 * 10
  AxMC_T_AXIS_UNITpPULSE       = 0.01;   // = 1 / 1000 * 10
  AxMC_T_AXIS_STARTSTOPSPEED   = 1;      //TBD:MOTION:T-AXIS??
  AxMC_T_AXIS_VELOCITY         = 10;     // = �ʴ� 100mm �̵� (LGD �������: 100 ����?)    //TBD:MOTION:T-AXIS?
  AxMC_T_AXIS_ACCEL            = 20;     // = Velocity                                     //TBD:MOTION:T-AXIS?
  AxMC_T_AXIS_POS_LIMIT_MINUS  = -21;    // = ������   //TBD:MOTION? (��Ȯ�ϰ� ���� �ʿ�)  //TBD:MOTION:T-AXIS?
  AxMC_T_AXIS_POS_LIMIT_PLUS   = 543;    // = ������   //TBD:MOTION? (��Ȯ�ϰ� ���� �ʿ�)  //TBD:MOTION:T-AXIS?
{$ENDIF} //HAS_MOTION_TILTING
  
  // JOG (y/Z)
  AxMC_JOG_VELOCITY_MAX  = 100.00;                     // = �ʴ� 100mm �̵� (LGD �������: 100 ����?)  //TBD:MOTION:T-AXIS?
  AxMC_JOG_ACCEL_MAX     = AxMC_JOG_VELOCITY_MAX*2;    // = Velocity

  // Ajinextek AXT/AXM MotionControl - Timer Value
  AxMC_TIMEVAL_CONN_CHECK      = 1000;
  AxMC_TIMEVAL_ALARM_CHECK     = 1000;
  AxMC_TIMEVAL_STATUS_CHECK    = 200;

  // AXT MotionControl - Signal IN (BitNo: 0~5)
  AxMC_SIG_IN_HOME					= 0;		// Original Sensor //TBD?
//AxMC_SIG_IN_XXX_BIT1			= 1;		// Z phase //TBD?
//AxMC_SIG_IN_XXX_BIT2			= 2;		//TBD?
//AxMC_SIG_IN_XXX_BIT3			= 3;		//TBD?
//AxMC_SIG_IN_XXX_BIT4			= 4;		//TBD?
//AxMC_SIG_IN_XXX_BIT5			= 5;		//TBD?

  // AXT/AXM MotionControl - Universal Signal OUT
  AxMC_SIG_OUT_SERVO_ON		  = 0;    //Servo On
  AxMC_SIG_OUT_ALARM_CLEAR	= 1;    //Alarm Clear
//AxMC_SIG_OUT_XXX_BIT2		  = 2;		//Universal output3
//AxMC_SIG_OUT_XXX_BIT3		  = 3;		//Universal output4
//AxMC_SIG_OUT_XXX_BIT4		  = 4;		//Universal output5

  // Ajinextek AXT/AXM MotionControl - Home Search Directions
  AxMC_SEARCH_HOME_DIR_CW 	= 0;  // +Limit ����
  AxMC_SEARCH_HOME_DIR_CCW 	= 1;  // -Limit ����

  // Ajinextek AXT/AXM MotionControl - Home Search Method Bits	//TBD? (�� �ະ, Home Search ���� ���� ������ Config�� ����?)
  AxMC_HOME_METHOD_USE_STEP 	 = $01;	// bit 0: Step ��� ���� (0: ������� ����, 1: �����)
  AxMC_HOME_METHOD_ACCEL_TIME	 = $02;	// bit 1: ������ ��� (0: ������, 1: ���� �ð�)
  AxMC_HOME_METHOD_STOP_EMG 	 = $04;	// bit 2: ���� ��� (0: ���� ����, 1: �� ����)
  AxMC_HOME_METHOD_DIR_CW 		 = $08;	// bit 3: �˻� ���� (0: CCW(-), CW(+))
  AxMC_HOME_METHOD_IN0_UPEDGE  = $C0;	//TBD?
  AxMC_HOME_METHOD_IN0_DNEDGE  = $40;	//TBD?
  AxMC_HOME_METHOD_IN1_UPEDGE  = $D0;	//TBD?
  AxMC_HOME_METHOD_IN1_DNEDGE  = $50;	//TBD?

  // Ajinextek AXT/AXM MotionControl - Home Search Step Count
  AxMC_SEARCH_HOME_STEP_DEFAULT	= 4;		//TBD? (�� �ະ, Home Search ���� ���� ������ Config�� ����?)
  AxMC_SEARCH_HOME_STEP_MAX			= 4;		//TBD? (�� �ະ, Home Search ���� ���� ������ Config�� ����?)

  // Ajinextek AXT/AXM MotionControl - Home Search Motor Parameters
  AxMC_SEARCH_HOME_VEL_MAX		  = 200;		//TBD? (�� �ະ, Home Search ���� ���� ������ Config�� ����?)
	
{$ENDIF}  // Defined(USE_MOTION_AXM) or Defined(USE_MOTION_AXT)

	//****************************************************************************
	// Ezi MotionLink
	//****************************************************************************
{$IFDEF USE_MOTION_EZIML}
  // Ezi MotionLink PE - IP Address (Common)
  EziMLPE_IP_BASE      = '192.168.0.20'; //TBD?
  EziMLPE_IP_SB1       = 192;
  EziMLPE_IP_SB2       = 168;
  EziMLPE_IP_SB3       = 0;
  EziMLPE_IP_SB4_BASE  = 20;   //TBD?

	// Ezi MotionLink PE - IP Port (Common)
  EziMLPE_TCP_PORT     = 2002; // GUI-S/W(2001), UserLibray(2002)
  EziMLPE_UDP_PORT     = 3002; // GUI-S/W(3001), UserLibray(3002)

  // Ezi MotionLink - Default ActPos (POCB_X2CH-specific)
  EziML_FOCUS_ACT_POS_DEFAULT   = -82763;

  EziML_DEFAULT_PULSE_F       = 1;    //TBD:MOTION?
  EziML_DEFAULT_VELOCITY_F    = 200;  //TBD:MOTION?
  EziML_DEFAULT_ACCEL_F       = 400;  //TBD:MOTION?

  // Ezi MotionLink - Timer Value (POCB_X2CH-specific)
  EziML_TIMEVAL_CONN_CHECK    = 1000; // msec TBD?
  EziML_TIMEVAL_ALARM_CHECK   = 1000; // msec TBD?
  EziML_TIMEVAL_STATUS_CHECK  = 200;  // msec TBD?
{$ENDIF}

implementation

end.


