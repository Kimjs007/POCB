unit CAMCFSDef;

interface

uses Windows, Messages;

{-------------------------------------------------------------------------------------------------*
 *        CAMC-FS (SMC-1V02, SMC-2V02)                                                             *
 *-------------------------------------------------------------------------------------------------}

{-------------------------------------------------------------------------------------------------*
 *        CAMC-5M, CAMC-FS 1.0 / 2.0���� �������� ����ϴ� ��ũ��...                               *
 *-------------------------------------------------------------------------------------------------}

{ Type ����	}

const

	POSITIVE_SENSE								= 1;
	NEGATIVE_SENSE								= -1;

// 2004�� 3�� 8�� �Ⱥ��� �߰�
	MASTER										= 1;
	SLAVE										= 0;

// 2004�� 3�� 9�� �Ⱥ��� �߰�
	UI4											= 0;
	UI5											= 0;
	JOG											= 1;
	MARK										= 2;


	DRIVE1										= 1;
	DRIVE2										= 2;
	DRIVE3										= 3;


	DIFF_INPUT									= $00;						// Differential input
	LEVEL_INPUT									= $01;						// Level input


	Phase										= $0;						// �ܻ�
	Mode1										= $1;						// 1ü��
	Mode2										= $2;						// 2ü��
	Mode4										= $3;						// 4ü��

{ Main clock							}
	F_33M_CLK									= 33000000;					{ 33.000 MHz }
	F_32_768M_CLK								= 32768000;					{ 32.768 MHz }
	F_20M_CLK									= 20000000;					{ 20.000 MHz }
	F_16_384M_CLK								= 16384000;					{ 16.384 MHz : Default }

{ MODE1 DATA							
 *
 *	���� ���� POINT ���� ���
 }

	AutoDetect									= $0;
	RestPulse									= $1;

{ Pulse Output Method					}

	OneHighLowHigh								= $0;						// 1�޽� ���, PULSE(Active High), ������(DIR=Low)  / ������(DIR=High)
	OneHighHighLow								= $1;						// 1�޽� ���, PULSE(Active High), ������(DIR=High) / ������(DIR=Low)
	OneLowLowHigh								= $2;						// 1�޽� ���, PULSE(Active Low),  ������(DIR=Low)  / ������(DIR=High)
	OneLowHighLow								= $3;						// 1�޽� ���, PULSE(Active Low),  ������(DIR=High) / ������(DIR=Low)
	TwoCcwCwHigh								= $4;						// 2�޽� ���, PULSE(CCW:������),  DIR(CW:������),  Active High	 
	TwoCcwCwLow									= $5;						// 2�޽� ���, PULSE(CCW:������),  DIR(CW:������),  Active Low	 
	TwoCwCcwHigh								= $6;						// 2�޽� ���, PULSE(CW:������),   DIR(CCW:������), Active High
	TwoCwCcwLow									= $7;						// 2�޽� ���, PULSE(CW:������),   DIR(CCW:������), Active Low

{ Detect Destination Signal			}

	PElmNegativeEdge							= $0;						// +Elm(End limit) �ϰ� edge
	NElmNegativeEdge							= $1;						// -Elm(End limit) �ϰ� edge
	PSlmNegativeEdge							= $2;						// +Slm(Slowdown limit) �ϰ� edge
	NSlmNegativeEdge							= $3;						// -Slm(Slowdown limit) �ϰ� edge
	In0DownEdge									= $4;						// IN0(ORG) �ϰ� edge
	In1DownEdge									= $5;						// IN1(Z��) �ϰ� edge
	In2DownEdge									= $6;						// IN2(����) �ϰ� edge
	In3DownEdge									= $7;						// IN3(����) �ϰ� edge
	PElmPositiveEdge							= $8;						// +Elm(End limit) ��� edge
	NElmPositiveEdge							= $9;						// -Elm(End limit) ��� edge
	PSlmPositiveEdge							= $a;						// +Slm(Slowdown limit) ��� edge
	NSlmPositiveEdge							= $b;						// -Slm(Slowdown limit) ��� edge
	In0UpEdge									= $c;						// IN0(ORG) ��� edge
	In1UpEdge									= $d;						// IN1(Z��) ��� edge
	In2UpEdge									= $e;						// IN2(����) ��� edge
	In3UpEdge									= $f;						// IN3(����) ��� edge

{ Mode2 Data   
 * External Counter Input 
 }

	UpDownMode									= $0;						// Up/Down
	Sqr1Mode									= $1;						// 1ü��
	Sqr2Mode									= $2;						// 2ü��
	Sqr4Mode									= $3;						// 4ü��


	InpActiveLow								= 0;
	InpActiveHigh								= 1;


	AlmActiveLow								= 0;
	AlmActiveHigh								= 1;


	NSlmActiveLow								= 0;
	NSlmActiveHigh								= 1;


	PSlmActiveLow								= 0;
	PSlmActiveHigh								= 1;


	NElmActiveLow								= 0;
	NElmActiveHigh								= 1;


	PElmActiveLow								= 0;
	PElmActiveHigh								= 1;

{ Universal Input/Output				}

	US_OUT0										= $01;
	US_OUT1										= $02;
	US_OUT2										= $04;
	US_OUT3										= $08;
	US_IN0										= $10;
	US_IN1										= $20;
	US_IN2										= $40;
	US_IN3										= $80;

{ BOARD SELECT							}
	BASE_ADDR									= 0;
	BOARD0_BASE_ADDR							= 0;
	BOARD1_BASE_ADDR							= 1;
	BOARD2_BASE_ADDR							= 2;
	BOARD3_BASE_ADDR							= 3;
	BOARD4_BASE_ADDR							= 4;
	BOARD5_BASE_ADDR							= 5;
	BOARD6_BASE_ADDR							= 6;
	BOARD7_BASE_ADDR							= 7;

{ CAMC CHIP SELECT						}

	CCA_CAMC0_ADDR								= $00;
	CCA_CAMC1_ADDR								= $10;
	CCA_CAMC2_ADDR								= $20;
	CCA_CAMC3_ADDR								= $30;
	CCA_CAMC4_ADDR								= $40;
	CCA_CAMC5_ADDR								= $50;
	CCA_CAMC6_ADDR								= $60;
	CCA_CAMC7_ADDR								= $70;

{ CHIP SELECT		}

	CS_CAMC0									= $00;
	CS_CAMC1									= $1;
	CS_CAMC2									= $2;
	CS_CAMC3									= $3;
	CS_CAMC4									= $4;
	CS_CAMC5									= $5;
	CS_CAMC6									= $6;
	CS_CAMC7									= $7;
	CS_CAMC8									= $8;
	CS_CAMC9									= $9;
	CS_CAMC10									= $a;
	CS_CAMC11									= $b;
	CS_CAMC12									= $c;
	CS_CAMC13									= $d;
	CS_CAMC14									= $e;
	CS_CAMC15									= $f;
	CS_CAMC16									= $10;
	CS_CAMC17									= $11;
	CS_CAMC18									= $12;
	CS_CAMC19									= $13;
	CS_CAMC20									= $14;
	CS_CAMC21									= $15;
	CS_CAMC22									= $16;
	CS_CAMC23									= $17;
	CS_CAMC24									= $18;
	CS_CAMC25									= $19;
	CS_CAMC26									= $1a;
	CS_CAMC27									= $1b;
	CS_CAMC28									= $1c;
	CS_CAMC29									= $1d;
	CS_CAMC30									= $1e;
	CS_CAMC31									= $1f;

{	AMCS Board �߰�		}
{	2000�� 12�� 16��	}
{	�ۼ��� : �̼���		}

	AMC1X										= $01;
	AMC2X										= $02;
	AMC3X										= $03;
	AMC4X										= $04;
	AMC6X										= $06;
	AMC8X										= $08;

{----------------------------------------------------------------------}
{						Ĩ �ʱ�ȭ ����ü								}
{----------------------------------------------------------------------}

{----------------------------------------------------------------------}
{						�̵�����										}
{----------------------------------------------------------------------}

	MoveLeft									= -1;
	MoveRight									= 1;

///////////////////////////////////////////////////////
// 2005/08/11 ���ȣ ����
// CAMC5MDef.h ���� �浹�� ���� ��ġ ����

	SLAVE_MODE									= 1;
	PRST_DRV_MODE								= 2;
	CONT_DRV_MODE								= 4;
////////////////////////////////////////////////////////

{ Write port							}

	FsData1Write								= $00;
	FsData2Write								= $01;
	FsData3Write								= $02;
	FsData4Write								= $03;
	FsCommandWrite								= $04;

{ Read port							}

	FsData1Read									= $00;
	FsData2Read									= $01;
	FsData3Read									= $02;
	FsData4Read									= $03;
	FsCommandRead								= $04;

{ FS Universal Input/Output			}

	FSUS_OUT0									= $0001;					// Bit 0
	FSUS_SVON									= $0001;					// Bit 0, Servo ON
	FSUS_OUT1									= $0002;					// Bit 1
	FSUS_ALMC									= $0002;					// Bit 1, Alarm Clear
	FSUS_OUT2									= $0004;					// Bit 2
	FSUS_OUT3									= $0008;					// Bit 3
	FSUS_IN0									= $0010;					// Bit 4
	FSUS_ORG									= $0010;					// Bit 4, Origin
	FSUS_IN1									= $0020;					// Bit 5
	FSUS_PZ										= $0020;					// Bit 5, Encoder Z��
	FSUS_IN2									= $0040;					// Bit 6
	FSUS_IN3									= $0080;					// Bit 7

// [V2.0�̻�]
	FSUS_OPCODE0								= $0100;					// Bit 8
	FSUS_OPCODE1								= $0200;					// Bit 9
	FSUS_OPCODE2								= $0400;					// Bit 10
	FSUS_OPDATA0								= $0800;					// Bit 11
	FSUS_OPDATA1								= $1000;					// Bit 12
	FSUS_OPDATA2								= $2000;					// Bit 13
	FSUS_OPDATA3								= $4000;					// Bit 14

{ FS End status : 0x0000�̸� ��������	}

	FSEND_STATUS_SLM							= $0001;					// Bit 0, limit �������� ��ȣ �Է¿� ���� ����
	FSEND_STATUS_ELM							= $0002;					// Bit 1, limit ������ ��ȣ �Է¿� ���� ����
	FSEND_STATUS_SSTOP_SIGNAL					= $0004;					// Bit 2, ���� ���� ��ȣ �Է¿� ���� ����
	FSEND_STATUS_ESTOP_SIGANL					= $0008;					// Bit 3, ������ ��ȣ �Է¿� ���� ����
	FSEND_STATUS_SSTOP_COMMAND					= $0010;					// Bit 4, ���� ���� ��ɿ� ���� ����
	FSEND_STATUS_ESTOP_COMMAND					= $0020;					// Bit 5, ������ ���� ��ɿ� ���� ����
	FSEND_STATUS_ALARM_SIGNAL					= $0040;					// Bit 6, Alarm ��ȣ �Է¿� ���� ����
	FSEND_STATUS_DATA_ERROR						= $0080;					// Bit 7, ������ ���� ������ ���� ����

//[V2.0�̻�]
	FSEND_STATUS_DEVIATION_ERROR				= $0100;					// Bit 8, Ż�� ������ ���� ����
	FSEND_STATUS_ORIGIN_DETECT					= $0200;					// Bit 9, ���� ���⿡ ���� ����
	FSEND_STATUS_SIGNAL_DETECT					= $0400;					// Bit 10, ��ȣ ���⿡ ���� ����(Signal search-1/2 drive ����)
	FSEND_STATUS_PRESET_PULSE_DRIVE				= $0800;					// Bit 11, Preset pulse drive ����
	FSEND_STATUS_SENSOR_PULSE_DRIVE				= $1000;					// Bit 12, Sensor pulse drive ����
	FSEND_STATUS_LIMIT							= $2000;					// Bit 13, Limit ���������� ���� ����
	FSEND_STATUS_SOFTLIMIT						= $4000;					// Bit 14, Soft limit�� ���� ����

{ FS Drive status						}

	FSDRIVE_STATUS_BUSY							= $0001;					// Bit 0, BUSY(����̺� ���� ��)
	FSDRIVE_STATUS_DOWN							= $0002;					// Bit 1, DOWN(���� ��)
	FSDRIVE_STATUS_CONST						= $0004;					// Bit 2, CONST(��� ��)
	FSDRIVE_STATUS_UP							= $0008;					// Bit 3, UP(���� ��)
	FSDRIVE_STATUS_ICL							= $0010;					// Bit 4, ICL(���� ��ġ ī���� < ���� ��ġ ī���� �񱳰�)
	FSDRIVE_STATUS_ICG							= $0020;					// Bit 5, ICG(���� ��ġ ī���� > ���� ��ġ ī���� �񱳰�)
	FSDRIVE_STATUS_ECL							= $0040;					// Bit 6, ECL(�ܺ� ��ġ ī���� < �ܺ� ��ġ ī���� �񱳰�)
	FSDRIVE_STATUS_ECG							= $0080;					// Bit 7, ECG(�ܺ� ��ġ ī���� > �ܺ� ��ġ ī���� �񱳰�)

//[V2.0�̻�]
	FSDRIVE_STATUS_DEVIATION_ERROR				= $0100;					// Bit 8, ����̺� ���� ��ȣ(0=CW/1=CCW)

{ FS Mechanical signal					}

	FSMECHANICAL_PELM_LEVEL						= $0001;					// Bit 0, +Limit ������ ��ȣ �Է� Level
	FSMECHANICAL_NELM_LEVEL						= $0002;					// Bit 1, -Limit ������ ��ȣ �Է� Level
	FSMECHANICAL_PSLM_LEVEL						= $0004;					// Bit 2, +limit �������� ��ȣ �Է� Level
	FSMECHANICAL_NSLM_LEVEL						= $0008;					// Bit 3, -limit �������� ��ȣ �Է� Level
	FSMECHANICAL_ALARM_LEVEL					= $0010;					// Bit 4, Alarm ��ȣ �Է� Level
	FSMECHANICAL_INP_LEVEL						= $0020;					// Bit 5, Inposition ��ȣ �Է� Level
	FSMECHANICAL_ENC_DOWN_LEVEL					= $0040;					// Bit 6, ���ڴ� DOWN(B��) ��ȣ �Է� Level
	FSMECHANICAL_ENC_UP_LEVEL					= $0080;					// Bit 7, ���ڴ� UP(A��) ��ȣ �Է� Level

//[V2.0�̻�]
	FSMECHANICAL_EXMP_LEVEL						= $0100;					// Bit 8, EXMP ��ȣ �Է� Level
	FSMECHANICAL_EXPP_LEVEL						= $0200;					// Bit 9, EXPP ��ȣ �Է� Level
	FSMECHANICAL_MARK_LEVEL						= $0400;					// Bit 10, MARK# ��ȣ �Է� Level
	FSMECHANICAL_SSTOP_LEVEL					= $0800;					// Bit 11, SSTOP ��ȣ �Է� Level
	FSMECHANICAL_ESTOP_LEVEL					= $1000;					// Bit 12, ESTOP ��ȣ �Է� Level

{ ����̺� ���� ����					}

	SYM_LINEAR									= $00;						// ��Ī ��ٸ���
	ASYM_LINEAR									= $01;						// ���Ī ��ٸ���
	SYM_CURVE									= $02;						// ��Ī ������(S-Curve)
	ASYM_CURVE									= $03;						// ���Ī ������(S-Curve)

{ FS COMMAND LIST							}

// PGM-1 Group Register
	FsRangeDataRead								= $00;						// PGM-1 RANGE READ, 16bit, 0xFFFF
	FsRangeDataWrite							= $80;						// PGM-1 RANGE WRITE
	FsStartStopSpeedDataRead					= $01;						// PGM-1 START/STOP SPEED DATA READ, 16bit, 
	FsStartStopSpeedDataWrite					= $81;						// PGM-1 START/STOP SPEED DATA WRITE
	FsObjectSpeedDataRead						= $02;						// PGM-1 OBJECT SPEED DATA READ, 16bit, 
	FsObjectSpeedDataWrite						= $82;						// PGM-1 OBJECT SPEED DATA WRITE
	FsRate1DataRead								= $03;						// PGM-1 RATE-1 DATA READ, 16bit, 0xFFFF
	FsRate1DataWrite							= $83;						// PGM-1 RATE-1 DATA WRITE
	FsRate2DataRead								= $04;						// PGM-1 RATE-2 DATA READ, 16bit, 0xFFFF
	FsRate2DataWrite							= $84;						// PGM-1 RATE-2 DATA WRITE
	FsRate3DataRead								= $05;						// PGM-1 RATE-3 DATA READ, 16bit, 0xFFFF
	FsRate3DataWrite							= $85;						// PGM-1 RATE-3 DATA WRITE
	FsRateChangePoint12Read						= $06;						// PGM-1 RATE CHANGE POINT 1-2 READ, 16bit, 0xFFFF
	FsRateChangePoint12Write					= $86;						// PGM-1 RATE CHANGE POINT 1-2 WRITE
	FsRateChangePoint23Read						= $07;						// PGM-1 RATE CHANGE POINT 2-3 READ, 16bit, 0xFFFF
	FsRateChangePoint23Write					= $87;						// PGM-1 RATE CHANGE POINT 2-3 WRITE
	FsSw1DataRead								= $08;						// PGM-1 SW-1 DATA READ, 15bit, 0x7FFF
	FsSw1DataWrite								= $88;						// PGM-1 SW-1 DATA WRITE
	FsSw2DataRead								= $09;						// PGM-1 SW-2 DATA READ, 15bit, 0x7FFF
	FsSw2DataWrite								= $89;						// PGM-1 SW-2 DATA WRITE
	FsPwmOutDataRead							= $0A;						// PGM-1 PWM ��� ���� DATA READ(0~6), 3bit, 0x00
	FsPwmOutDataWrite							= $8A;						// PGM-1 PWM ��� ���� DATA WRITE
	FsSlowDownRearPulseRead						= $0B;						// PGM-1 SLOW DOWN/REAR PULSE READ, 32bit, 0x00000000
	FsSlowDownRearPulseWrite					= $8B;						// PGM-1 SLOW DOWN/REAR PULSE WRITE
	FsCurrentSpeedDataRead						= $0C;						// PGM-1 ���� SPEED DATA READ, 16bit, 0x0000
	FsNoOperation_8C							= $8C;						// No operation
	FsCurrentSpeedComparateDataRead				= $0D;						// PGM-1 ���� SPEED �� DATA READ, 16bit, 0x0000
	FsCurrentSpeedComparateDataWrite			= $8D;						// PGM-1 ���� SPEED �� DATA WRITE
	FsDrivePulseCountRead						= $0E;						// PGM-1 DRIVE PULSE COUNTER READ, 32bit, 0x00000000
	FsNoOperation_8E							= $8E;						// No operation
	FsPresetPulseDataRead						= $0F;						// PGM-1 PRESET PULSE DATA READ, 32bit, 0x00000000
	FsNoOperation_8F							= $8F;						// No operation

// PGM-1 Update Group Register
	FsURangeDataRead							= $10;						// PGM-1 UP-DATE RANGE READ, 16bit, 0xFFFF
	FsURangeDataWrite							= $90;						// PGM-1 UP-DATE RANGE WRITE
	FsUStartStopSpeedDataRead					= $11;						// PGM-1 UP-DATE START/STOP SPEED DATA READ, 16bit, 
	FsUStartStopSpeedDataWrite					= $91;						// PGM-1 UP-DATE START/STOP SPEED DATA WRITE
	FsUObjectSpeedDataRead						= $12;						// PGM-1 UP-DATE OBJECT SPEED DATA READ, 16bit, 
	FsUObjectSpeedDataWrite						= $92;						// PGM-1 UP-DATE OBJECT SPEED DATA WRITE
	FsURate1DataRead							= $13;						// PGM-1 UP-DATE RATE-1 DATA READ, 16bit, 0xFFFF
	FsURate1DataWrite							= $93;						// PGM-1 UP-DATE RATE-1 DATA WRITE
	FsURate2DataRead							= $14;						// PGM-1 UP-DATE RATE-2 DATA READ, 16bit, 0xFFFF
	FsURate2DataWrite							= $94;						// PGM-1 UP-DATE RATE-2 DATA WRITE
	FsURate3DataRead							= $15;						// PGM-1 UP-DATE RATE-3 DATA READ, 16bit, 0xFFFF
	FsURate3DataWrite							= $95;						// PGM-1 UP-DATE RATE-3 DATA WRITE
	FsURateChange12DataRead						= $16;						// PGM-1 UP-DATE RATE CHANGE POINT 1-2 READ, 16bit, 0xFFFF
	FsURateChange12DataWrite					= $96;						// PGM-1 UP-DATE RATE CHANGE POINT 1-2 WRITE
	FsURateChange23DataRead						= $17;						// PGM-1 UP-DATE RATE CHANGE POINT 2-3 READ, 16bit, 0xFFFF
	FsURateChange23DataWrite					= $97;						// PGM-1 UP-DATE RATE CHANGE POINT 2-3 WRITE
	FsUSw1DataRead								= $18;						// PGM-1 UP-DATE SW-1 DATA READ, 15bit, 0x7FFF
	FsUSw1DataWrite								= $98;						// PGM-1 UP-DATE SW-1 DATA WRITE
	FsUSw2DataRead								= $19;						// PGM-1 UP-DATE SW-2 DATA READ, 15bit, 0x7FFF
	FsUSw2DataWrite								= $99;						// PGM-1 UP-DATE SW-2 DATA WRITE
	FsUCurrentSpeedChangeDataRead				= $1A;						// PGM-1 CURRENT SPEED CHANGE DATA READ
	FsUCurrentSpeedChangeDataWrote				= $9A;						// PGM-1 CURRENT SPEED CHANGE DATA WRITE
	FsUSlowDownRearPulseRead					= $1B;						// PGM-1 UP-DATE SLOW DOWN/REAR PULSE READ, 32bit, 0x00000000
	FsUSlowDownRearPulseWrite					= $9B;						// PGM-1 UP-DATE SLOW DOWN/REAR PULSE WRITE
	FsUCurrentSpeedDataRead						= $1C;						// PGM-1 ���� SPEED DATA READ, 16bit, 0x0000
	FsNoOperation_9C							= $9C;						// No operation
	FsUCurrentSpeedComparateDataRead			= $1D;						// PGM-1 UP-DATE ���� SPEED �� DATA READ, 16bit, 0x0000
	FsUCurrentSpeedComparateDataWrite			= $9D;						// PGM-1 UP-DATE ���� SPEED �� DATA WRITE
	FsUDrivePulseCounterDataRead				= $1E;						// PGM-1 DRIVE PULSE COUNTER READ, 32bit, 0x00000000
	FsNoOperation_9E							= $9E;						// No operation
	FsUPresetPulseDataRead						= $1F;						// PGM-1 UP-DATE PRESET PULSE DATA READ, 32bit, 0x00000000
	FsNoOperation_9F							= $9F;						// No operation

// PGM-2 Group Register
	FsNoOperation_20							= $20;						// No operation
	FsPresetPulseDriveP							= $A0;						// +PRESET PULSE DRIVE, 32
	FsNoOperation_21							= $21;						// No operation
	FsContinuousDriveP							= $A1;						// +CONTINUOUS DRIVE
	FsNoOperation_22							= $22;						// No operation
	FsSignalSearch1DriveP						= $A2;						// +SIGNAL SEARCH-1 DRIVE
	FsNoOperation_23							= $23;						// No operation
	FsSignalSearch2DriveP						= $A3;						// +SIGNAL SEARCH-2 DRIVE
	FsNoOperation_24							= $24;						// No operation
	FsOriginSearchDriveP						= $A4;						// +ORIGIN(����) SEARCH DRIVE
	FsNoOperation_25							= $25;						// No operation
	FsPresetPulseDriveN							= $A5;						// -PRESET PULSE DRIVE, 32
	FsNoOperation_26							= $26;						// No operation
	FsContinuousDriveN							= $A6;						// -CONTINUOUS DRIVE
	FsNoOperation_27							= $27;						// No operation
	FsSignalSearch1DriveN						= $A7;						// -SIGNAL SEARCH-1 DRIVE
	FsNoOperation_28							= $28;						// No operation
	FsSignalSearch2DriveN						= $A8;						// -SIGNAL SEARCH-2 DRIVE
	FsNoOperation_29							= $29;						// No operation
	FsOriginSearchDriveN						= $A9;						// -ORIGIN(����) SEARCH DRIVE
	FsNoOperation_2A							= $2A;						// No operation
	FsPresetPulseDataOverride					= $AA;						// PRESET PULSE DATA OVERRIDE(ON_BUSY)
	FsNoOperation_2B							= $2B;						// No operation
	FsSlowDownStop								= $AB;						// SLOW DOWN STOP
	FsNoOperation_2C							= $2C;						// No operation
	FsEmergencyStop								= $AC;						// EMERGENCY STOP
	FsDriveOperationSelectDataRead				= $2D;						// ����̺� ���� ���� DATA READ
	FsDriveOperationSelectDataWrite				= $AD;						// ����̺� ���� ���� DATA WRITE
	FsMpgOperationSettingDataRead				= $2E;						// MPG OPERATION SETTING DATA READ, 3bit, 0x00		<+> 2002-11-15 FS2.0 - JNS
	FsMpgOperationSettingDataWrite				= $AE;						// MPG OPERATION SETTING DATA WRITE					<+> 2002-11-15 FS2.0 - JNS
	FsMpgPresetPulseDataRead					= $2F;						// MPG PRESET PULSE DATA READ, 32bit, 0x00000000	<+> 2002-11-15 FS2.0 - JNS
	FsMpgPresetPulseDataWrite					= $AF;						// MPG PRESET PULSE DATA WRITE						<+> 2002-11-15 FS2.0 - JNS

	{ Extension Group Register }
	FsNoOperation_30							= $30;						// No operation
	FsSensorPositioningDrive1P					= $B0;						// +SENSOR POSITIONING DRIVE I
	FsNoOperation_31							= $31;						// No operation
	FsSensorPositioningDrive1N					= $B1;						// -SENSOR POSITIONING DRIVE I
	FsNoOperation_32							= $32;						// No operation
	FsSensorPositioningDrive2P					= $B2;						// +SENSOR POSITIONING DRIVE II
	FsNoOperation_33							= $33;						// No operation
	FsSensorPositioningDrive2N					= $B3;						// -SENSOR POSITIONING DRIVE II
	FsNoOperation_34							= $34;						// No operation
	FsSensorPositioningDrive3P					= $B4;						// +SENSOR POSITIONING DRIVE III
	FsNoOperation_35							= $35;						// No operation
	FsSensorPositioningDrive3N					= $B5;						// -SENSOR POSITIONING DRIVE III
	FsSoftlimitSettingDataRead					= $36;						// SOFT LIMIT ���� READ, 3bit, 0x00
	FsSoftlimitSettingDataWrite					= $B6;						// SOFT LIMIT ���� WRITE
	FsNegativeSoftlimitDataRead					= $37;						// -SOFT LIMIT �� �������� ���� READ, 32bit, 0x80000000
	FsNegativeSoftlimitDataWrite				= $B7;						// -SOFT LIMIT �� �������� ���� WRITE
	FsPositiveSoftlimitDataRead					= $38;						// +SOFT LIMIT �� �������� ���� READ, 32bit, 0x7FFFFFFF
	FsPositiveSoftlimitDataWrite				= $B8;						// +SOFT LIMIT �� �������� ���� WRITE
	FsTriggerModeSettingDataRead				= $39;						// TRIGGER MODE ���� READ, 32bit, 0x00010000
	FsTriggerModeSettingDataWrite				= $B9;						// TRIGGER MODE ���� WRITE
	FsTriggerComparatorDataRead					= $3A;						// TRIGGER �� ������ ���� READ, 32bit, 0x00000000
	FsTriggerComparatorDataWrite				= $BA;						// TRIGGER �� ������ ���� WRITE
	FsInternalCounterMDataRead					= $3B;						// INTERNAL M-DATA ���� READ, 32bit, 0x80000000
	FsInternalCounterMDataWrite					= $BB;						// INTERNAL M-DATA ���� WRITE
	FsExternalCounterMDataRead					= $3C;						// EXTERNAL M-DATA ���� READ, 32bit, 0x80000000
	FsExternalCounterMDataWrite					= $BC;						// EXTERNAL M-DATA ���� WRITE
	FsNoOperation_BD							= $BD;						// No operation
	FsNoOperation_3D							= $3D;						// No operation
	FsNoOperation_3E							= $3E;						// No operation
	FsNoOperation_BE							= $BE;						// No operation
	FsNoOperation_3F							= $3F;						// No operation
	FsNoOperation_BF							= $BF;						// No operation

	{ Scripter Group Register			}
	FsScriptOperSetReg1Read						= $40;						// ��ũ��Ʈ ���� ���� ��������-1 READ, 32bit, 0x00000000
	FsScriptOperSetReg1Write					= $C0;						// ��ũ��Ʈ ���� ���� ��������-1 WRITE
	FsScriptOperSetReg2Read						= $41;						// ��ũ��Ʈ ���� ���� ��������-2 READ, 32bit, 0x00000000
	FsScriptOperSetReg2Write					= $C1;						// ��ũ��Ʈ ���� ���� ��������-2 WRITE
	FsScriptOperSetReg3Read						= $42;						// ��ũ��Ʈ ���� ���� ��������-3 READ, 32bit, 0x00000000 
	FsScriptOperSetReg3Write					= $C2;						// ��ũ��Ʈ ���� ���� ��������-3 WRITE
	FsScriptOperSetRegQueueRead					= $43;						// ��ũ��Ʈ ���� ���� ��������-Queue READ, 32bit, 0x00000000
	FsScriptOperSetRegQueueWrite				= $C3;						// ��ũ��Ʈ ���� ���� ��������-Queue WRITE
	FsScriptOperDataReg1Read					= $44;						// ��ũ��Ʈ ���� ������ ��������-1 READ, 32bit, 0x00000000 
	FsScriptOperDataReg1Write					= $C4;						// ��ũ��Ʈ ���� ������ ��������-1 WRITE
	FsScriptOperDataReg2Read					= $45;						// ��ũ��Ʈ ���� ������ ��������-2 READ, 32bit, 0x00000000 
	FsScriptOperDataReg2Write					= $C5;						// ��ũ��Ʈ ���� ������ ��������-2 WRITE
	FsScriptOperDataReg3Read					= $46;						// ��ũ��Ʈ ���� ������ ��������-3 READ, 32bit, 0x00000000 
	FsScriptOperDataReg3Write					= $C6;						// ��ũ��Ʈ ���� ������ ��������-3 WRITE
	FsScriptOperDataRegQueueRead				= $47;						// ��ũ��Ʈ ���� ������ ��������-Queue READ, 32bit, 0x00000000 
	FsScriptOperDataRegQueueWrite				= $C7;						// ��ũ��Ʈ ���� ������ ��������-Queue WRITE
	FsNoOperation_48							= $48;						// No operation
	FsScriptOperQueueClear						= $C8;						// ��ũ��Ʈ Queue clear
	FsScriptOperSetQueueIndexRead				= $49;						// ��ũ��Ʈ ���� ���� Queue �ε��� READ, 4bit, 0x00
	FsNoOperation_C9							= $C9;						// No operation
	FsScriptOperDataQueueIndexRead				= $4A;						// ��ũ��Ʈ ���� ������ Queue �ε��� READ, 4bit, 0x00
	FsNoOperation_CA							= $CA;						// No operation
	FsScriptOperQueueFlagRead					= $4B;						// ��ũ��Ʈ Queue Full/Empty Flag READ, 4bit, 0x05
	FsNoOperation_CB							= $CB;						// No operation
	FsScriptOperQueueSizeSettingRead			= $4C;						// ��ũ��Ʈ Queue size ����(0~13) READ, 16bit, 0xD0D0
	FsScriptOperQueueSizeSettingWrite			= $CC;						// ��ũ��Ʈ Queue size ����(0~13) WRITE
	FsScriptOperQueueStatusRead					= $4D;						// ��ũ��Ʈ Queue status READ, 12bit, 0x005
	FsNoOperation_CD							= $CD;						// No operation
	FsNoOperation_4E							= $4E;						// No operation
	FsNoOperation_CE							= $CE;						// No operation
	FsNoOperation_4F							= $4F;						// No operation
	FsNoOperation_CF							= $CF;						// No operation

	{ Caption Group Register }
	FsCaptionOperSetReg1Read					= $50;						// ������ ���� ���� ��������-1 READ, 32bit, 0x00000000
	FsCaptionOperSetReg1Write					= $D0;						// ������ ���� ���� ��������-1 WRITE
	FsCaptionOperSetReg2Read					= $51;						// ������ ���� ���� ��������-2 READ, 32bit, 0x00000000
	FsCaptionOperSetReg2Write					= $D1;						// ������ ���� ���� ��������-2 WRITE
	FsCaptionOperSetReg3Read					= $52;						// ������ ���� ���� ��������-3 READ, 32bit, 0x00000000 
	FsCaptionOperSetReg3Write					= $D2;						// ������ ���� ���� ��������-3 WRITE
	FsCaptionOperSetRegQueueRead				= $53;						// ������ ���� ���� ��������-Queue READ, 32bit, 0x00000000
	FsCaptionOperSetRegQueueWrite				= $D3;						// ������ ���� ���� ��������-Queue WRITE
	FsCaptionOperDataReg1Read					= $54;						// ������ ���� ������ ��������-1 READ, 32bit, 0x00000000 
	FsNoOperation_D4							= $D4;						// No operation
	FsCaptionOperDataReg2Read					= $55;						// ������ ���� ������ ��������-2 READ, 32bit, 0x00000000 
	FsNoOperation_D5							= $D5;						// No operation
	FsCaptionOperDataReg3Read					= $56;						// ������ ���� ������ ��������-3 READ, 32bit, 0x00000000 
	FsNoOperation_D6							= $D6;						// No operation
	FsCaptionOperDataRegQueueRead				= $57;						// ������ ���� ������ ��������-Queue READ, 32bit, 0x00000000 
	FsNoOperation_D7							= $D7;						// No operation
	FsNoOperation_58							= $58;						// No operation
	FsCaptionOperQueueClear						= $D8;						// ������ Queue clear
	FsCaptionOperSetQueueIndexRead				= $59;						// ������ ���� ���� Queue �ε��� READ, 4bit, 0x00
	FsNoOperation_D9							= $D9;						// No operation
	FsCaptionOperDataQueueIndexRead				= $5A;						// ������ ���� ������ Queue �ε��� READ, 4bit, 0x00
	FsNoOperation_DA							= $DA;						// No operation
	FsCaptionOperQueueFlagRead					= $5B;						// ������ Queue Full/Empty Flag READ, 4bit, 0x05
	FsNoOperation_DB							= $DB;						// No operation
	FsCaptionOperQueueSizeSettingRead			= $5C;						// ������ Queue size ����(0~13) READ, 16bit, 0xD0D0
	FsCaptionOperQueueSizeSettingWrite			= $DC;						// ������ Queue size ����(0~13) WRITE
	FsCaptionOperQueueStatusRead				= $5D;						// ������ Queue status READ, 12bit, 0x005
	FsNoOperation_DD							= $DD;						// No operation
	FsNoOperation_5E							= $5E;						// No operation
	FsNoOperation_DE							= $DE;						// No operation
	FsNoOperation_5F							= $5F;						// No operation
	FsNoOperation_DF							= $DF;						// No operation

	{ BUS - 1 Group Register			}
	FsInternalCounterRead						= $60;						// INTERNAL COUNTER DATA READ(Signed), 32bit, 0x00000000
	FsInternalCounterWrite						= $E0;						// INTERNAL COUNTER DATA WRITE(Signed)
	FsInternalCounterComparatorDataRead			= $61;						// INTERNAL COUNTER COMPARATE DATA READ(Signed), 32bit, 0x00000000
	FsInternalCounterComparatorDataWrite		= $E1;						// INTERNAL COUNTER COMPARATE DATA WRITE(Signed)
	FsInternalCounterPreScaleDataRead			= $62;						// INTERNAL COUNTER PRE-SCALE DATA READ, 8bit, 0x00
	FsInternalCounterPreScaleDataWrite			= $E2;						// INTERNAL COUNTER PRE-SCALE DATA WRITE
	FsInternalCounterNCountDataRead				= $63;						// INTERNAL COUNTER P-DATA READ, 32bit, 0x7FFFFFFF
	FsInternalCounterNCountDataWrite			= $E3;						// INTERNAL COUNTER P-DATA WRITE
	FsExternalCounterRead						= $64;						// EXTERNAL COUNTER DATA READ READ(Signed), 32bit, 0x00000000
	FsExternalCounterWrite						= $E4;						// EXTERNAL COUNTER DATA READ WRITE(Signed)
	FsExternalCounterComparatorDataRead			= $65;						// EXTERNAL COUNTER COMPARATE DATA READ(Signed), 32bit, 0x00000000
	FsExternalCounterComparatorDataWrite		= $E5;						// EXTERNAL COUNTER COMPARATE DATA WRITE(Signed)
	FsExternalCounterPreScaleDataRead			= $66;						// EXTERNAL COUNTER PRE-SCALE DATA READ, 8bit, 0x00
	FsExternalCounterPreScaleDataWrite			= $E6;						// EXTERNAL COUNTER PRE-SCALE DATA WRITE
	FsExternalCounterNCountDataRead				= $67;						// EXTERNAL COUNTER P-DATA READ, 32bit, 0x7FFFFFFF
	FsExternalCounterNCountDataWrite			= $E7;						// EXTERNAL COUNTER P-DATA WRITE
	FsExternalSpeedDataRead						= $68;						// EXTERNAL SPEED DATA READ, 32bit, 0x00000000
	FsExternalSpeedDataWrite					= $E8;						// EXTERNAL SPEED DATA WRITE
	FsExternalSpeedComparateDataRead			= $69;						// EXTERNAL SPEED COMPARATE DATA READ, 32bit, 0x00000000
	FsExternalSpeedComparateDataWrite			= $E9;						// EXTERNAL SPEED COMPARATE DATA WRITE
	FsExternalSensorFilterBandWidthDataRead		= $6A;						// �ܺ� ���� ���� �뿪�� ���� DATA READ, 8bit, 0x05
	FsExternalSensorFilterBandWidthDataWrite	= $EA;						// �ܺ� ���� ���� �뿪�� ���� DATA WRITE
	FsOffRangeDataRead							= $6B;						// OFF-RANGE DATA READ, 8bit, 0x00
	FsOffRangeDataWrite							= $EB;						// OFF-RANGE DATA WRITE
	FsDeviationDataRead							= $6C;						// DEVIATION DATA READ, 16bit, 0x0000
	FsNoOperation_EC							= $EC;						// No operation
	FsPgmRegChangeDataRead						= $6D;						// PGM REGISTER CHANGE DATA READ
	FsPgmRegChangeDataWrite						= $ED;						// PGM REGISTER CHANGE DATA WRITE
	FsNoOperation_6E							= $6E;						// No operation
	FsCompareRegisterInputChangeDataWrite		= $EE;						// COMPARE REGISTER INPUT CHANGE
	FsNoOperation_6F							= $6F;						// No operation
	FsNoOperation_EF							= $EF;						// No operation
//?	FsCompareRegisterInputChangeDataRead= 0x6E,				//<+> 2002-11-15 FS2.0 - JNS

	{ BUS - 2 Group Register			}
	FsChipFunctionSetDataRead					= $70;						// Ĩ ��� ���� DATA READ, 13bit, 0x0C3E
	FsChipFunctionSetDataWrite					= $F0;						// Ĩ ��� ���� DATA WRITE
	FsMode1Read									= $71;						// MODE1 DATA READ, 8bit, 0x00
	FsMode1Write								= $F1;						// MODE1 DATA WRITE
	FsMode2Read									= $72;						// MODE2 DATA READ, 11bit, 0x200
	FsMode2Write								= $F2;						// MODE2 DATA WRITE
	FsUniversalSignalRead						= $73;						// UNIVERSAL IN READ, 11bit, 0x0000
	FsUniversalSignalWrite						= $F3;						// UNIVERSAL OUT WRITE
	FsEndStatusRead								= $74;						// END STATUS DATA READ, 15bit, 0x0000
	FsNoOperation_F4							= $F4;						// No operation
	FsMechanicalSignalRead						= $75;						// MECHANICAL SIGNAL DATA READ, 13bit
	FsNoOperation_F5							= $F5;						// No operation
	FsDriveStatusRead							= $76;						// DRIVE STATE DATA READ, 9bit
	FsNoOperation_F6							= $F6;						// No operation
	FsExternalCounterSetDataRead				= $77;						// EXTERNAL COUNTER ���� DATA READ, 9bit, 0x00
	FsExternalCounterSetDataWrite				= $F7;						// EXTERNAL COUNTER ���� DATA WRITE
	FsNoOperation_78							= $78;						// No operation
	FsRegisterClear								= $F8;						// REGISTER CLEAR(INITIALIZATION)
	FsInterruptFlagRead							= $79;						// Interrupt Flag READ, 32bit, 0x00000000
	FsInterruptOutCommand						= $F9;						// Interrupt �߻� Command
	FsInterruptMaskRead							= $7A;						// Interrupt Mask READ, 32bit, 0x00000001
	FsInterruptMaskWrite						= $FA;						// Interrupt Mask WRITE
	FsEMode1DataRead							= $7B;						// EMODE1 DATA READ, 8bit, 0x00
	FsEMode1DataWrite							= $FB;						// EMODE1 DATA WRITE
	FsEUniversalOutRead							= $7C;						// Extension UNIVERSAL OUT READ, 8bit, 0x00
	FsEUniversalOutWrite						= $FC;						// Extension UNIVERSAL OUT WRITE
	FsNoOperation_7D							= $7D;						// No operation
	FsLimitStopDisableWrite						= $FD;						// LIMIT �������� ����
	FsUserInterruptSourceSelectRegRead			= $7E;						// USER Interrupt source selection register READ, 32bit, 0x00000000
	FsUserInterruptSourceSelectRegWrite			= $FE;						// USER Interrupt source selection register WRITE
	FsNoOperation_7F							= $7F;						// No operation
	FsNoOperation_FF							= $FF;						// No operation

{
	����� Version :
		- CAMC-FS 1.0 �̸� 0	=> CFS
		- CAMC-FS 2.0 �̸� 2	=> CFS, CFS20
		- CAMC-FS 2.1 �̸� 4	=> CFS, CFS20
}
	CAMC_FS_VERSION_10							= 0;						// FS Ver 1.0
	CAMC_FS_VERSION_20							= 2;						// FS Ver 2.0
	CAMC_FS_VERSION_20_KDNS						= 3;						// FS Ver 2.0 - for KDNS
	CAMC_FS_VERSION_21							= 4;						// FS Ver 2.1
	CAMC_FS_VERSION_30							= 5;						// FS Ver 3.0

// ��ũ��Ʈ/������ ���� ���� ��������-1/2/3/Queue
	SCRIPT_REG1									= 1;						// ��ũ��Ʈ ��������-1
	SCRIPT_REG2									= 2;						// ��ũ��Ʈ ��������-2
	SCRIPT_REG3									= 3;						// ��ũ��Ʈ ��������-3
	SCRIPT_REG_QUEUE							= 4;						// ��ũ��Ʈ ��������-Queue
	CAPTION_REG1								= 11;						// ������ ��������-1
	CAPTION_REG2								= 12;						// ������ ��������-2
	CAPTION_REG3								= 13;						// ������ ��������-3
	CAPTION_REG_QUEUE							= 14;						// ������ ��������-Queue

// CFS20KeSetScriptCaption�� event�Է��� ���� �� define.
// bit 31 : 0=�ѹ�������, 1=��� ����
	OPERATION_ONCE_RUN							= $00000000;				// bit 31 OFF
	OPERATION_CONTINUE_RUN						= $80000000;				// bit 31 ON
// bit 30..26 : Don't care
// bit 25..24 : 00=1���̺�Ʈ������, 01=OR����, 10=AND����, 11=XOR����
	OPERATION_EVENT_NONE						= $00000000;				// bit 25=OFF, 24=OFF
	OPERATION_EVENT_OR							= $01000000;				// bit 25=OFF, 24=ON
	OPERATION_EVENT_AND							= $02000000;				// bit 25=ON,  24=OFF
	OPERATION_EVENT_XOR							= $03000000;				// bit 25=ON,  24=ON

// CFS20SetScriptCaption�� event_logic�Է��� ���� �� define.
// bit 7 : 0=�ѹ�������, 1=��� ����
	FSSC_ONE_TIME_RUN							= $00;						// bit 7 OFF
	FSSC_ALWAYS_RUN								= $80;						// bit 7 ON
// bit 6 bit : sc�� ���� ������ ���� �������� ����.
//	sc = SCRIPT_REG1, SCRIPT_REG2, SCRIPT_REG3 �� ��. Don't care.
//	sc = SCRIPT_REG_QUEUE �� ��. Script ���۽� ���ͷ�Ʈ ��� ����. �ش� ���ͷ�Ʈ mask�� enable �Ǿ� �־�� ��.
//		0(���ͷ�Ʈ �߻����� ����), 1(�ش� script ����� ���ͷ�Ʈ �߻�) 
//	sc = CAPTION_REG1, CAPTION_REG2, CAPTION_REG3 �� ��. Don't care.
//	sc = CAPTION_REG_QUEUE. Caption ���۽� ���ͷ�Ʈ ��� ����. �ش� ���ͷ�Ʈ mask�� enable�Ǿ� �־�� ��.
//		0(���ͷ�Ʈ �߻����� ����), 1(�ش� caption ����� ���ͷ�Ʈ �߻�) 
	IPSCQ_INTERRUPT_DISABLE						= $00;						// bit 6 OFF
	IPSCQ_INTERRUPT_ENABLE						= $40;						// bit 6 ON
// bit 1..0 bit : 00=1���̺�Ʈ������, 01=OR����, 10=AND����, 11=XOR����
	FSSC_EVENT_OP_NONE							= $00;						// bit 1=OFF, 0=OFF
	FSSC_EVENT_OP_OR							= $01;						// bit 1=OFF, 0=ON
	FSSC_EVENT_OP_AND							= $02;						// bit 1=ON,  0=OFF
	FSSC_EVENT_OP_XOR							= $03;						// bit 1=ON,  0=ON

{ EVENT LIST							}

	EVENT_NONE									= $00;						// ������� ����
	EVENT_DRIVE_END								= $01;						// ����̺� ����
	EVENT_PRESETDRIVE_START						= $02;						// �����޽� �� ����̺� ����
	EVENT_PRESETDRIVE_END						= $03;						// �����޽� �� ����̺� ����
	EVENT_CONTINOUSDRIVE_START					= $04;						// ���� ����̺� ����
	EVENT_CONTINOUSDRIVE_END					= $05;						// ���� ����̺� ����
	EVENT_SIGNAL_SEARCH_1_START					= $06;						// ��ȣ ����-1 ����̺� ����
	EVENT_SIGNAL_SEARCH_1_END					= $07;						// ��ȣ ����-1 ����̺� ����
	EVENT_SIGNAL_SEARCH_2_START					= $08;						// ��ȣ ����-2 ����̺� ����
	EVENT_SIGNAL_SEARCH_2_END					= $09;						// ��ȣ ����-2 ����̺� ����
	EVENT_ORIGIN_DETECT_START					= $0A;						// �������� ����̺� ����
	EVENT_ORIGIN_DETECT_END						= $0B;						// �������� ����̺� ����
	EVENT_SPEED_UP								= $0C;						// ����
	EVENT_SPEED_CONST							= $0D;						// ���
	EVENT_SPEED_DOWN							= $0E;						// ����
	EVENT_ICG									= $0F;						// ������ġī���� > ������ġ�񱳰�
	EVENT_ICE									= $10;						// ������ġī���� = ������ġ�񱳰�
	EVENT_ICL									= $11;						// ������ġī���� < ������ġ�񱳰�
	EVENT_ECG									= $12;						// �ܺ���ġī���� > �ܺ���ġ�񱳰�
	EVENT_ECE									= $13;						// �ܺ���ġī���� = �ܺ���ġ�񱳰�
	EVENT_ECL									= $14;						// �ܺ���ġī���� < �ܺ���ġ�񱳰�
	EVENT_EPCG									= $15;						// �ܺ��޽�ī���� > �ܺ��޽�ī���ͺ񱳰�
	EVENT_EPCE									= $16;						// �ܺ��޽�ī���� = �ܺ��޽�ī���ͺ񱳰�
	EVENT_EPCL									= $17;						// �ܺ��޽�ī���� < �ܺ��޽�ī���ͺ񱳰�
	EVENT_SPG									= $18;						// ����ӵ������� > ����ӵ��񱳵�����
	EVENT_SPE									= $19;						// ����ӵ������� = ����ӵ��񱳵�����
	EVENT_SPL									= $1A;						// ����ӵ������� < ����ӵ��񱳵�����
	EVENT_SP12G									= $1B;						// ����ӵ������� > Rate Change Point 1-2
	EVENT_SP12E									= $1C;						// ����ӵ������� = Rate Change Point 1-2
	EVENT_SP12L									= $1D;						// ����ӵ������� < Rate Change Point 1-2
	EVENT_SP23G									= $1E;						// ����ӵ������� > Rate Change Point 2-3
	EVENT_SP23E									= $1F;						// ����ӵ������� = Rate Change Point 2-3
	EVENT_SP23L									= $20;						// ����ӵ������� < Rate Change Point 2-3
	EVENT_OBJECT_SPEED							= $21;						// ����ӵ������� = ��ǥ�ӵ�������
	EVENT_SS_SPEED								= $22;						// ����ӵ������� = ���ۼӵ�������
	EVENT_ESTOP									= $23;						// �޼�����
	EVENT_SSTOP									= $24;						// ��������
	EVENT_PELM									= $25;						// +Emergency Limit ��ȣ �Է�
	EVENT_NELM									= $26;						// -Emergency Limit ��ȣ �Է�
	EVENT_PSLM									= $27;						// +Slow Down Limit ��ȣ �Է�
	EVENT_NSLM									= $28;						// -Slow Down Limit ��ȣ �Է�
	EVENT_DEVIATION_ERROR						= $29;						// Ż�� ���� �߻�
	EVENT_DATA_ERROR							= $2A;						// ������ ���� ���� �߻�
	EVENT_ALARM_ERROR							= $2B;						// Alarm ��ȣ �Է�
	EVENT_ESTOP_COMMAND							= $2C;						// �޼� ���� ��� ����
	EVENT_SSTOP_COMMAND							= $2D;						// ���� ���� ��� ����
	EVENT_ESTOP_SIGNAL							= $2E;						// �޼� ���� ��ȣ �Է�
	EVENT_SSTOP_SIGNAL							= $2F;						// ���� ���� ��ȣ �Է�
	EVENT_ELM									= $30;						// Emergency Limit ��ȣ �Է�
	EVENT_SLM									= $31;						// Slow Down Limit ��ȣ �Է�
	EVENT_INPOSITION							= $32;						// Inposition ��ȣ �Է�
	EVENT_IN0_HIGH								= $33;						// IN0 High ��ȣ �Է�
	EVENT_IN0_LOW								= $34;						// IN0 Low  ��ȣ �Է�
	EVENT_IN1_HIGH								= $35;						// IN1 High ��ȣ �Է�
	EVENT_IN1_LOW								= $36;						// IN1 Low  ��ȣ �Է�
	EVENT_IN2_HIGH								= $37;						// IN2 High ��ȣ �Է�
	EVENT_IN2_LOW								= $38;						// IN2 Low  ��ȣ �Է�
	EVENT_IN3_HIGH								= $39;						// IN3 High ��ȣ �Է�
	EVENT_IN3_LOW								= $3A;						// IN3 Low  ��ȣ �Է�
	EVENT_OUT0_HIGH								= $3B;						// OUT0 High ��ȣ �Է�
	EVENT_OUT0_LOW								= $3C;						// OUT0 Low  ��ȣ �Է�
	EVENT_OUT1_HIGH								= $3D;						// OUT1 High ��ȣ �Է�
	EVENT_OUT1_LOW								= $3E;						// OUT1 Low  ��ȣ �Է�
	EVENT_OUT2_HIGH								= $3F;						// OUT2 High ��ȣ �Է�
	EVENT_OUT2_LOW								= $40;						// OUT2 Low  ��ȣ �Է�
	EVENT_OUT3_HIGH								= $41;						// OUT3 High ��ȣ �Է�
	EVENT_OUT3_LOW								= $42;						// OUT3 Low  ��ȣ �Է�
	EVENT_SENSOR_DRIVE1_START					= $43;						// Sensor Positioning drive I ����
	EVENT_SENSOR_DRIVE1_END						= $44;						// Sensor Positioning drive I ����
	EVENT_SENSOR_DRIVE2_START					= $45;						// Sensor Positioning drive II ����
	EVENT_SENSOR_DRIVE2_END						= $46;						// Sensor Positioning drive II ����
	EVENT_SENSOR_DRIVE3_START					= $47;						// Sensor Positioning drive III ����
	EVENT_SENSOR_DRIVE3_END						= $48;						// Sensor Positioning drive III ����
	EVENT_1STCOUNTER_NDATA_CLEAR				= $49;						// 1'st counter N-data count clear
	EVENT_2NDCOUNTER_NDATA_CLEAR				= $4A;						// 2'nd counter N-data count clear
	EVENT_MARK_SIGNAL_HIGH						= $4B;						// Mark# signal high
	EVENT_MARK_SIGNAL_LOW						= $4C;						// Mark# signal low
	EVENT_EUIO0_HIGH							= $4D;						// EUIO0 High ��ȣ �Է�
	EVENT_EUIO0_LOW								= $4E;						// EUIO0 Low  ��ȣ �Է�
	EVENT_EUIO1_HIGH							= $4F;						// EUIO1 High ��ȣ �Է�
	EVENT_EUIO1_LOW								= $50;						// EUIO1 Low  ��ȣ �Է�
	EVENT_EUIO2_HIGH							= $51;						// EUIO2 High ��ȣ �Է�
	EVENT_EUIO2_LOW								= $52;						// EUIO2 Low  ��ȣ �Է�
	EVENT_EUIO3_HIGH							= $53;						// EUIO3 High ��ȣ �Է�
	EVENT_EUIO3_LOW								= $54;						// EUIO3 Low  ��ȣ �Է�
	EVENT_EUIO4_HIGH							= $55;						// EUIO4 High ��ȣ �Է�
	EVENT_EUIO4_LOW								= $56;						// EUIO4 Low  ��ȣ �Է�
	EVENT_SOFTWARE_PLIMIT						= $57;						// +Software Limit
	EVENT_SOFTWARE_NLIMIT						= $58;						// -Software Limit
	EVENT_SOFTWARE_LIMIT						= $59;						// Software Limit
	EVENT_TRIGGER_ENABLE						= $5A;						// Trigger enable
	EVENT_INT_GEN_SOURCE						= $5B;						// Interrupt Generated by any source
	EVENT_INT_GEN_CMDF9							= $5C;						// Interrupt Generated by Command "F9"
	EVENT_PRESETDRIVE_TRI_START					= $5D;						// Preset �ﰢ���� ����
	EVENT_BUSY_HIGH								= $5E;						// ����̺� busy High
	EVENT_BUSY_LOW								= $5F;						// ����̺� busy Low
	EVENT_UNCONDITIONAL_RUN						= $FF;						// ������ ����(Queue command ����)

implementation

// bit 23..16 : 2�� ���� �̺�Ʈ ����
function OPERATION_EVENT_2(Event : LongInt) : LongInt;
begin
	result := (Event and $FF) shl 16;
end;

// bit 15..8 : 1�� ���� �̺�Ʈ ����
function  OPERATION_EVENT_1(Event : LongInt) : LongInt;
begin
	result := (Event and $FF) shl 8;
end;

// bit 7..0 : �̺�Ʈ ���� �� ������ Command
function  OPERATION_EVENT_COMMAND(Command : LongInt) : LongInt;
begin
	result := (Command and $FF);
end;

end.