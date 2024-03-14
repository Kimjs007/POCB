
unit AXHD;

interface

uses Windows, Messages;

{ IP COMMAND LIST							}
const


// PGM-1 Group Register
	IPxyRANGERead								= $00;						// PGM-1 RANGE READ, 16bit, 0xFFFF
	IPxyRANGEWrite								= $80;						// PGM-1 RANGE WRITE
	IPxySTDRead									= $01;						// PGM-1 START/STOP SPEED DATA READ, 16bit, 
	IPxySTDWrite								= $81;						// PGM-1 START/STOP SPEED DATA WRITE
	IPxyOBJRead									= $02;						// PGM-1 OBJECT SPEED DATA READ, 16bit, 
	IPxyOBJWrite								= $82;						// PGM-1 OBJECT SPEED DATA WRITE
	IPxyRATE1Read								= $03;						// PGM-1 RATE-1 DATA READ, 16bit, 0xFFFF
	IPxyRATE1Write								= $83;						// PGM-1 RATE-1 DATA WRITE
	IPxyRATE2Read								= $04;						// PGM-1 RATE-2 DATA READ, 16bit, 0xFFFF
	IPxyRATE2Write								= $84;						// PGM-1 RATE-2 DATA WRITE
	IPxyRATE3Read								= $05;						// PGM-1 RATE-3 DATA READ, 16bit, 0xFFFF
	IPxyRATE3Write								= $85;						// PGM-1 RATE-3 DATA WRITE
	IPxyRCP12Read								= $06;						// PGM-1 RATE CHANGE POINT 1-2 READ, 16bit, 0xFFFF
	IPxyRCP12Write								= $86;						// PGM-1 RATE CHANGE POINT 1-2 WRITE
	IPxyRCP23Read								= $07;						// PGM-1 RATE CHANGE POINT 2-3 READ, 16bit, 0xFFFF
	IPxyRCP23Write								= $87;						// PGM-1 RATE CHANGE POINT 2-3 WRITE
	IPxySW1Read									= $08;						// PGM-1 SW-1 DATA READ, 15bit, 0x7FFF
	IPxySW1Write								= $88;						// PGM-1 SW-1 DATA WRITE
	IPxySW2Read									= $09;						// PGM-1 SW-2 DATA READ, 15bit, 0x7FFF
	IPxySW2Write								= $89;						// PGM-1 SW-2 DATA WRITE
	IPxyPWMRead									= $0A;						// PGM-1 PWM 출력 설정 DATA READ(0~6), 3bit, 0x00
	IPxyPWMWrite								= $8A;						// PGM-1 PWM 출력 설정 DATA WRITE
	IPxyREARRead								= $0B;						// PGM-1 SLOW DOWN/REAR PULSE READ, 32bit, 0x00000000
	IPxyREARWrite								= $8B;						// PGM-1 SLOW DOWN/REAR PULSE WRITE
	IPxySPDRead									= $0C;						// PGM-1 현재 SPEED DATA READ, 16bit, 0x0000
	IPxyNoOperation_8C							= $8C;						// No operation
	IPxySPDCMPRead								= $0D;						// PGM-1 현재 SPEED 비교 DATA READ, 16bit, 0x0000
	IPxySPDCMPWrite								= $8D;						// PGM-1 현재 SPEED 비교 DATA WRITE
	IPxyDRVPULSERead							= $0E;						// PGM-1 DRIVE PULSE COUNTER READ, 32bit, 0x00000000
	IPxyNoOperation_8E							= $8E;						// No operation
	IPxyPRESETPULSERead							= $0F;						// PGM-1 PRESET PULSE DATA READ, 32bit, 0x00000000
	IPxyNoOperation_8F							= $8F;						// No operation

// PGM-1 Update Group Register
	IPxyURANGERead								= $10;						// PGM-1 UP-DATE RANGE READ, 16bit, 0xFFFF
	IPxyURANGEWrite								= $90;						// PGM-1 UP-DATE RANGE WRITE
	IPxyUSTDRead								= $11;						// PGM-1 UP-DATE START/STOP SPEED DATA READ, 16bit, 
	IPxyUSTDWrite								= $91;						// PGM-1 UP-DATE START/STOP SPEED DATA WRITE
	IPxyUOBJRead								= $12;						// PGM-1 UP-DATE OBJECT SPEED DATA READ, 16bit, 
	IPxyUOBJWrite								= $92;						// PGM-1 UP-DATE OBJECT SPEED DATA WRITE
	IPxyURATE1Read								= $13;						// PGM-1 UP-DATE RATE-1 DATA READ, 16bit, 0xFFFF
	IPxyURATE1Write								= $93;						// PGM-1 UP-DATE RATE-1 DATA WRITE
	IPxyURATE2Read								= $14;						// PGM-1 UP-DATE RATE-2 DATA READ, 16bit, 0xFFFF
	IPxyURATE2Write								= $94;						// PGM-1 UP-DATE RATE-2 DATA WRITE
	IPxyURATE3Read								= $15;						// PGM-1 UP-DATE RATE-3 DATA READ, 16bit, 0xFFFF
	IPxyURATE3Write								= $95;						// PGM-1 UP-DATE RATE-3 DATA WRITE
	IPxyURCP12Read								= $16;						// PGM-1 UP-DATE RATE CHANGE POINT 1-2 READ, 16bit, 0xFFFF
	IPxyURCP12Write								= $96;						// PGM-1 UP-DATE RATE CHANGE POINT 1-2 WRITE
	IPxyURCP23Read								= $17;						// PGM-1 UP-DATE RATE CHANGE POINT 2-3 READ, 16bit, 0xFFFF
	IPxyURCP23Write								= $97;						// PGM-1 UP-DATE RATE CHANGE POINT 2-3 WRITE
	IPxyUSW1Read								= $18;						// PGM-1 UP-DATE SW-1 DATA READ, 15bit, 0x7FFF
	IPxyUSW1Write								= $98;						// PGM-1 UP-DATE SW-1 DATA WRITE
	IPxyUSW2Read								= $19;						// PGM-1 UP-DATE SW-2 DATA READ, 15bit, 0x7FFF
	IPxyUSW2Write								= $99;						// PGM-1 UP-DATE SW-2 DATA WRITE
	IPxyNoOperation_1A							= $1A;						// No operation
	IPxyNoOperation_9A							= $9A;						// No operation
	IPxyUREARRead								= $1B;						// PGM-1 UP-DATE SLOW DOWN/REAR PULSE READ, 32bit, 0x00000000
	IPxyUREARWrite								= $9B;						// PGM-1 UP-DATE SLOW DOWN/REAR PULSE WRITE
	IPxySPDRead_1C								= $1C;						// PGM-1 UP-DATA CURRENT SPEED READ(Same with 0x0C)
	IPxyNoOperation_9C							= $9C;						// No operation
	IPxySPDCMPRead_1D							= $1D;						// PGM-1 현재 SPEED 비교 DATA READ(Same with 0x0D) 
	IPxySPDCMPWrite_9D							= $9D;						// PGM-1 현재 SPEED 비교 DATA WRITE(Same with 0x8D) 
	IPxyACCPULSERead							= $1E;						// PGM-1 가속 PULSE COUNTER READ, 32bit, 0x00000000
	IPxyNoOperation_9E							= $9E;						// No operation
	IPxyPRESETPULSERead_1F						= $1F;						// PGM-1 PRESET PULSE DATA READ(Same with 0x0F)
	IPxyNoOperation_9F							= $9F;						// No operation

// PGM-2 Group Register
	IPxyNoOperation_20							= $20;						// No operation
	IPxyPPRESETDRV								= $A0;						// +PRESET PULSE DRIVE, 32
	IPxyNoOperation_21							= $21;						// No operation
	IPxyPCONTDRV								= $A1;						// +CONTINUOUS DRIVE
	IPxyNoOperation_22							= $22;						// No operation
	IPxyPSCH1DRV								= $A2;						// +SIGNAL SEARCH-1 DRIVE
	IPxyNoOperation_23							= $23;						// No operation
	IPxyPSCH2DRV								= $A3;						// +SIGNAL SEARCH-2 DRIVE
	IPxyNoOperation_24							= $24;						// No operation
	IPxyPORGDRV									= $A4;						// +ORIGIN(원점) SEARCH DRIVE
	IPxyNoOperation_25							= $25;						// No operation
	IPxyMPRESETDRV								= $A5;						// -PRESET PULSE DRIVE, 32
	IPxyNoOperation_26							= $26;						// No operation
	IPxyMCONTDRV								= $A6;						// -CONTINUOUS DRIVE
	IPxyNoOperation_27							= $27;						// No operation
	IPxyMSCH1DRV								= $A7;						// -SIGNAL SEARCH-1 DRIVE
	IPxyNoOperation_28							= $28;						// No operation
	IPxyMSCH2DRV								= $A8;						// -SIGNAL SEARCH-2 DRIVE
	IPxyNoOperation_29							= $29;						// No operation
	IPxyMORGDRV									= $A9;						// -ORIGIN(원점) SEARCH DRIVE
	IPxyPULSEOVERRead							= $2A;						// Preset/MPG drive override pulse data read
	IPxyPULSEOVERWrite							= $AA;						// PRESET PULSE DATA OVERRIDE(ON_BUSY)
	IPxyNoOperation_2B							= $2B;						// No operation
	IPxySSTOPCMD								= $AB;						// SLOW DOWN STOP
	IPxyNoOperation_2C							= $2C;						// No operation
	IPxyESTOPCMD								= $AC;						// EMERGENCY STOP
	IPxyDRIVEMODERead							= $2D;						// 드라이브 동작 설정 DATA READ
	IPxyDRIVEMODEWrite							= $AD;						// 드라이브 동작 설정 DATA WRITE
	IPxyMPGCONRead								= $2E;						// MPG OPERATION SETTING DATA READ, 3bit, 0x00	
	IPxyMPGCONWrite								= $AE;						// MPG OPERATION SETTING DATA WRITE				
	IPxyPULSEMPGRead							= $2F;						// MPG PRESET PULSE DATA READ, 32bit, 0x00000000
	IPxyPULSEMPGWrite							= $AF;						// MPG PRESET PULSE DATA WRITE					

	{ Extension Group Register }
	IPxyNoOperation_30							= $30;						// No operation
	IPxyPSPO1DRV								= $B0;						// +SENSOR POSITIONING DRIVE I
	IPxyNoOperation_31							= $31;						// No operation
	IPxyMSPO1DRV								= $B1;						// -SENSOR POSITIONING DRIVE I
	IPxyNoOperation_32							= $32;						// No operation
	IPxyPSPO2DRV								= $B2;						// +SENSOR POSITIONING DRIVE II
	IPxyNoOperation_33							= $33;						// No operation
	IPxyMSPO2DRV								= $B3;						// -SENSOR POSITIONING DRIVE II
	IPxyNoOperation_34							= $34;						// No operation
	IPxyPSPO3DRV								= $B4;						// +SENSOR POSITIONING DRIVE III
	IPxyNoOperation_35							= $35;						// No operation
	IPxyMSPO3DRV								= $B5;						// -SENSOR POSITIONING DRIVE III
	IPxySWLMTCONRead							= $36;						// SOFT LIMIT 설정 READ, 3bit, 0x00
	IPxySWLMTCONWrite							= $B6;						// SOFT LIMIT 설정 WRITE
	IPxyMSWLMTCOMPRead							= $37;						// -SOFT LIMIT 비교 레지스터 설정 READ, 32bit, 0x80000000
	IPxyMSWLMTCOMPWrite							= $B7;						// -SOFT LIMIT 비교 레지스터 설정 WRITE
	IPxyPSWLMTCOMPRead							= $38;						// +SOFT LIMIT 비교 레지스터 설정 READ, 32bit, 0x7FFFFFFF
	IPxyPSWLMTCOMPWrite							= $B8;						// +SOFT LIMIT 비교 레지스터 설정 WRITE
	IPxyTRGCONRead								= $39;						// TRIGGER MODE 설정 READ, 32bit, 0x00010000
	IPxyTRGCONWrite								= $B9;						// TRIGGER MODE 설정 WRITE
	IPxyTRGCOMPRead								= $3A;						// TRIGGER 비교 데이터 설정 READ, 32bit, 0x00000000
	IPxyTRGCOMPWrite							= $BA;						// TRIGGER 비교 데이터 설정 WRITE
	IPxyICMRead									= $3B;						// INTERNAL M-DATA 설정 READ, 32bit, 0x80000000
	IPxyICMWrite								= $BB;						// INTERNAL M-DATA 설정 WRITE
	IPxyECMRead									= $3C;						// EXTERNAL M-DATA 설정 READ, 32bit, 0x80000000
	IPxyECMWrite								= $BC;						// EXTERNAL M-DATA 설정 WRITE
	IPxySTOPPWRead								= $3D;						// Stop pulse width Read
	IPxySTOPPWWrite								= $BD;						// Stop pulse width Write
	IPxyNoOperation_3E							= $3E;						// No operation
	IPxyNoOperation_BE							= $BE;						// No operation
	IPxyNoOperation_3F							= $3F;						// No operation
	IPxyTRGCMD									= $BF;						// TRIG output signal generation command

	{ Interpolation Group	Registers	}
	IPxCIRXCRead								= $40;						// Circular interpolation X axis center point read
	IPxCIRXCWrite								= $C0;						// Circular interpolation X axis center point write 
	IPxCIRYCRead								= $41;						// Circular interpolation Y axis center point read 
	IPxCIRYCWrite								= $C1;						// Circular interpolation Y axis center point write  
	IPxENDXRead									= $42;						// Interpolation X axis end point read 
	IPxENDXWrite								= $C2;						// Interpolation X axis end point write  
	IPxENDYRead									= $43;						// Interpolation Y axis end point read  
	IPxENDYWrite								= $C3;						// Interpolation Y axis end point write  
	IPxPTXENDRead								= $44;						// Pattern interpolation X Queue data read
	IPxPTXENDWrite								= $C4;						// Pattern interpolation X Queue data with queue push 
	IPxPTYENDRead								= $45;						// Pattern interpolation Y Queue data read 
	IPxPTYENDWrite								= $C5;						// Pattern interpolation Y Queue data write
	IPxPTQUEUERead								= $46;						// Pattern interpolation Queue index read
	IPxNoOperation_C6							= $C6;						// No operation
	IPxNoOperation_47							= $47;						// No operation
	IPxNoOperation_C7							= $C7;						// No operation
	IPxNoOperation_48							= $48;						// No operation
	IPxNoOperation_C8							= $C8;						// No operation
	IPxNoOperation_49							= $49;						// No operation
	IPxNoOperation_C9							= $C9;						// No operation
	IPxINPSTATUSRead							= $4A;						// Interpolation Status register read
	IPxNoOperation_CA							= $CA;						// No operation
	IPxINPMODE_4B								= $4B;						// Interpolation mode in Queue TOP contets
	IPxLINPDRV									= $CB;						// Linear interpolation with Queue push
	IPxINPMODE_4C								= $4C;						// Interpolation mode in Queue TOP contets
	IPxCINPDRV									= $CC;						// Circular interpolation with Queue push 
	IPxBPINPMODE								= $4D;						// Bit Pattern Interpolation mode in Queue TOP contets
	IPxBPINPDRV									= $CD;						// Bit pattern Drive
	IPxNoOperation_4E							= $4E;						// No Operation
	IPxNoOperation_CE							= $CE;						// No Operation 
	IPxNoOperation_4F							= $4F;						// No Operation 
	IPxNoOperation_CF							= $CF;						// No Operation 

	{ Arithemetic Group Register }
	IPxNoOperation_50							= $50;						// No Operation
	IPxINPCLR									= $D0;						// Initialize all interpolation control block
	IPxINPMPOINTRead							= $51;						// Interpolation deceleration manual point(unsigned) read
	IPxINPMPOINTWrite							= $D1;						// Interpolation deceleration manual point(unsigned) write
	IPxNoOperation_52							= $52;						// No Operation
	IPxINPCLRSWrite								= $D2;						// Initialize interpolation control block with target selection
	IPxNoOperation_53							= $53;						// No Operation
	IPxINPDRVWrite								= $D3;						// linear/circular drive start with queue data(Hold on mode), Restart on pause
	IPxNoOperation_54							= $54;						// No operation
	IPxNoOperation_D4							= $D4;						// No operation
	IPxNoOperation_55							= $55;						// No operation
	IPxARTSHOT									= $D5;						// Arithmetic block One time execution
	IPxARTSHOPERRead							= $56;						// Arithmetic block shift and operation selection Read
	IPxARTSHOPERWrite							= $D6;						// Arithmetic block shift and operation selection Write
	IPxARTSHRead								= $57;						// Arithmetic block shift amount data Read
	IPxARTSHWrite								= $D7;						// Arithmetic block shift amount data Write
	IPxARTSOURCERead							= $58;						// Arithmetic block operand configure data Read
	IPxARTSOURCEWrite							= $D8;						// Arithmetic block operand configure data Write
	IPxARTCRESULT1Read							= $59;						// Arithmetic first compare result data Read
	IPxNoOperation_D9							= $D9;						// No Operation
	IPxARTCRESULT2Read							= $5A;						// Arithmetic second compare result data Read
	IPxNoOperation_DA							= $DA;						// No Operation
	IPxARTARESULT1Read							= $5B;						// Arithmetic first algebraic result data Read
	IPxNoOperation_DB							= $DB;						// No Operation
	IPxARTARESULT2Read							= $5C;						// Arithmetic second algebraic result data Read
	IPxNoOperation_DC							= $DC;						// No operation
	IPxARTUSERARead								= $5D;						// Arithmetic block User operand A Read
	IPxARTUSERAWrite							= $DD;						// Arithmetic block User operand A Write
	IPxARTUSERBRead								= $5E;						// Arithmetic block User operand B Read
	IPxARTUSERBWrite							= $DE;						// Arithmetic block User operand B Write
	IPxARTUSERCRead								= $5F;						// Arithmetic block User operand C Read
	IPxARTUSERCWrite							= $DF;						// Arithmetic block User operand C Write

	{ Scripter Group Register			}
	IPySCRCON1Read								= $40;						// 스크립트 동작 설정 레지스터-1 READ, 32bit, 0x00000000
	IPySCRCON1Write								= $C0;						// 스크립트 동작 설정 레지스터-1 WRITE
	IPySCRCON2Read								= $41;						// 스크립트 동작 설정 레지스터-2 READ, 32bit, 0x00000000
	IPySCRCON2Write								= $C1;						// 스크립트 동작 설정 레지스터-2 WRITE
	IPySCRCON3Read								= $42;						// 스크립트 동작 설정 레지스터-3 READ, 32bit, 0x00000000 
	IPySCRCON3Write								= $C2;						// 스크립트 동작 설정 레지스터-3 WRITE
	IPySCRCONQRead								= $43;						// 스크립트 동작 설정 레지스터-Queue READ, 32bit, 0x00000000
	IPySCRCONQWrite								= $C3;						// 스크립트 동작 설정 레지스터-Queue WRITE
	IPySCRDATA1Read								= $44;						// 스크립트 동작 데이터 레지스터-1 READ, 32bit, 0x00000000 
	IPySCRDATA1Write							= $C4;						// 스크립트 동작 데이터 레지스터-1 WRITE
	IPySCRDATA2Read								= $45;						// 스크립트 동작 데이터 레지스터-2 READ, 32bit, 0x00000000 
	IPySCRDATA2Write							= $C5;						// 스크립트 동작 데이터 레지스터-2 WRITE
	IPySCRDATA3Read								= $46;						// 스크립트 동작 데이터 레지스터-3 READ, 32bit, 0x00000000 
	IPySCRDATA3Write							= $C6;						// 스크립트 동작 데이터 레지스터-3 WRITE
	IPySCRDATAQRead								= $47;						// 스크립트 동작 데이터 레지스터-Queue READ, 32bit, 0x00000000 
	IPySCRDATAQWrite							= $C7;						// 스크립트 동작 데이터 레지스터-Queue WRITE
	IPyNoOperation_48							= $48;						// No operation
	IPySCRQCLR									= $C8;						// 스크립트 Queue clear
	IPySCRCQSIZERead							= $49;						// 스크립트 동작 설정 Queue 인덱스 READ, 4bit, 0x00
	IPyNoOperation_C9							= $C9;						// No operation
	IPySCRDQSIZERead							= $4A;						// 스크립트 동작 데이터 Queue 인덱스 READ, 4bit, 0x00
	IPyNoOperation_CA							= $CA;						// No operation
	IPySCRQFLAGRead								= $4B;						// 스크립트 Queue Full/Empty Flag READ, 4bit, 0x05
	IPyNoOperation_CB							= $CB;						// No operation
	IPySCRQSIZECONRead							= $4C;						// 스크립트 Queue size 설정(0~13) READ, 16bit, 0xD0D0
	IPySCRQSIZECONWrite							= $CC;						// 스크립트 Queue size 설정(0~13) WRITE
	IPySCRQSTATUSRead							= $4D;						// 스크립트 Queue status READ, 12bit, 0x005
	IPyNoOperation_CD							= $CD;						// No operation
	IPyNoOperation_4E							= $4E;						// No operation
	IPyNoOperation_CE							= $CE;						// No operation
	IPyNoOperation_4F							= $4F;						// No operation
	IPyNoOperation_CF							= $CF;						// No operation

	{ Caption Group Register }
	IPyCAPCON1Read								= $50;						// 갈무리 동작 설정 레지스터-1 READ, 32bit, 0x00000000
	IPyCAPCON1Write								= $D0;						// 갈무리 동작 설정 레지스터-1 WRITE
	IPyCAPCON2Read								= $51;						// 갈무리 동작 설정 레지스터-2 READ, 32bit, 0x00000000
	IPyCAPCON2Write								= $D1;						// 갈무리 동작 설정 레지스터-2 WRITE
	IPyCAPCON3Read								= $52;						// 갈무리 동작 설정 레지스터-3 READ, 32bit, 0x00000000 
	IPyCAPCON3Write								= $D2;						// 갈무리 동작 설정 레지스터-3 WRITE
	IPyCAPCONQRead								= $53;						// 갈무리 동작 설정 레지스터-Queue READ, 32bit, 0x00000000
	IPyCAPCONQWrite								= $D3;						// 갈무리 동작 설정 레지스터-Queue WRITE
	IPyCAPDATA1Read								= $54;						// 갈무리 동작 데이터 레지스터-1 READ, 32bit, 0x00000000 
	IPyNoOperation_D4							= $D4;						// No operation
	IPyCAPDATA2Read								= $55;						// 갈무리 동작 데이터 레지스터-2 READ, 32bit, 0x00000000 
	IPyNoOperation_D5							= $D5;						// No operation
	IPyCAPDATA3Read								= $56;						// 갈무리 동작 데이터 레지스터-3 READ, 32bit, 0x00000000 
	IPyNoOperation_D6							= $D6;						// No operation
	IPyCAPDATAQRead								= $57;						// 갈무리 동작 데이터 레지스터-Queue READ, 32bit, 0x00000000 
	IPyNoOperation_D7							= $D7;						// No operation
	IPyNoOperation_58							= $58;						// No operation
	IPyCAPQCLR									= $D8;						// 갈무리 Queue clear
	IPyCAPCQSIZERead							= $59;						// 갈무리 동작 설정 Queue 인덱스 READ, 4bit, 0x00
	IPyNoOperation_D9							= $D9;						// No operation
	IPyCAPDQSIZERead							= $5A;						// 갈무리 동작 데이터 Queue 인덱스 READ, 4bit, 0x00
	IPyNoOperation_DA							= $DA;						// No operation
	IPyCAPQFLAGRead								= $5B;						// 갈무리 Queue Full/Empty Flag READ, 4bit, 0x05
	IPyNoOperation_DB							= $DB;						// No operation
	IPyCAPQSIZECONRead							= $5C;						// 갈무리 Queue size 설정(0~13) READ, 16bit, 0xD0D0
	IPyCAPQSIZECONWrite							= $DC;						// 갈무리 Queue size 설정(0~13) WRITE
	IPyCAPQSTATUSRead							= $5D;						// 갈무리 Queue status READ, 12bit, 0x005
	IPyNoOperation_DD							= $DD;						// No operation
	IPyNoOperation_5E							= $5E;						// No operation
	IPyNoOperation_DE							= $DE;						// No operation
	IPyNoOperation_5F							= $5F;						// No operation
	IPyNoOperation_DF							= $DF;						// No operation

	{ BUS - 1 Group Register			}
	IPxyINCNTRead								= $60;						// INTERNAL COUNTER DATA READ(Signed), 32bit, 0x00000000
	IPxyINCNTWrite								= $E0;						// INTERNAL COUNTER DATA WRITE(Signed)
	IPxyINCNTCMPRead							= $61;						// INTERNAL COUNTER COMPARATE DATA READ(Signed), 32bit, 0x00000000
	IPxyINCNTCMPWrite							= $E1;						// INTERNAL COUNTER COMPARATE DATA WRITE(Signed)
	IPxyINCNTSCALERead							= $62;						// INTERNAL COUNTER PRE-SCALE DATA READ, 8bit, 0x00
	IPxyINCNTSCALEWrite							= $E2;						// INTERNAL COUNTER PRE-SCALE DATA WRITE
	IPxyICPRead									= $63;						// INTERNAL COUNTER P-DATA READ, 32bit, 0x7FFFFFFF
	IPxyICPWrite								= $E3;						// INTERNAL COUNTER P-DATA WRITE
	IPxyEXCNTRead								= $64;						// EXTERNAL COUNTER DATA READ READ(Signed), 32bit, 0x00000000
	IPxyEXCNTWrite								= $E4;						// EXTERNAL COUNTER DATA READ WRITE(Signed)
	IPxyEXCNTCMPRead							= $65;						// EXTERNAL COUNTER COMPARATE DATA READ(Signed), 32bit, 0x00000000
	IPxyEXCNTCMPWrite							= $E5;						// EXTERNAL COUNTER COMPARATE DATA WRITE(Signed)
	IPxyEXCNTSCALERead							= $66;						// EXTERNAL COUNTER PRE-SCALE DATA READ, 8bit, 0x00
	IPxyEXCNTSCALEWrite							= $E6;						// EXTERNAL COUNTER PRE-SCALE DATA WRITE
	IPxyEXPRead									= $67;						// EXTERNAL COUNTER P-DATA READ, 32bit, 0x7FFFFFFF
	IPxyEXPWrite								= $E7;						// EXTERNAL COUNTER P-DATA WRITE
	IPxyEXSPDRead								= $68;						// EXTERNAL SPEED DATA READ, 32bit, 0x00000000
	IPxyNoOperation_E8							= $E8;						// No operation
	IPxyEXSPDCMPRead							= $69;						// EXTERNAL SPEED COMPARATE DATA READ, 32bit, 0x00000000
	IPxyEXSPDCMPWrite							= $E9;						// EXTERNAL SPEED COMPARATE DATA WRITE
	IPxyEXFILTERDRead							= $6A;						// 외부 센서 필터 대역폭 설정 DATA READ, 32bit, 0x00050005
	IPxyEXFILTERDWrite							= $EA;						// 외부 센서 필터 대역폭 설정 DATA WRITE
	IPxyOFFREGIONRead							= $6B;						// OFF-RANGE DATA READ, 8bit, 0x00
	IPxyOFFREGIONWrite							= $EB;						// OFF-RANGE DATA WRITE
	IPxyDEVIATIONRead							= $6C;						// DEVIATION DATA READ, 16bit, 0x0000
	IPxyNoOperation_EC							= $EC;						// No operation
	IPxyPGMCHRead								= $6D;						// PGM REGISTER CHANGE DATA READ
	IPxyPGMCHWrite								= $ED;						// PGM REGISTER CHANGE DATA WRITE
	IPxyCOMPCONRead								= $6E;						// COMPARE REGISTER INPUT CHANGE DATA READ
	IPxyCOMPCONWrite							= $EE;						// COMPARE REGISTER INPUT CHANGE DATA WRITE
	IPxyNoOperation_6F							= $6F;						// No operation
	IPxyNoOperation_EF							= $EF;						// No operation

	{ BUS - 2 Group Register			}
	IPxyFUNCONRead								= $70;						// 칩 기능 설정 DATA READ,
	IPxyFUNCONWrite								= $F0;						// 칩 기능 설정 DATA WRITE
	IPxyMODE1Read								= $71;						// MODE1 DATA READ,
	IPxyMODE1Write								= $F1;						// MODE1 DATA WRITE
	IPxyMODE2Read								= $72;						// MODE2 DATA READ,
	IPxyMODE2Write								= $F2;						// MODE2 DATA WRITE
	IPxyUIODATARead								= $73;						// UNIVERSAL IN READ,
	IPxyUIODATAWrite							= $F3;						// UNIVERSAL OUT WRITE
	IPxyENDSTATUSRead							= $74;						// END STATUS DATA READ,
	IPxyCLIMCLR									= $F4;						// Complete limit stop clear command
	IPxyMECHRead								= $75;						// MECHANICAL SIGNAL DATA READ, 13bit
	IPxyNoOperation_F5							= $F5;						// No operation
	IPxyDRVSTATUSRead							= $76;						// DRIVE STATE DATA READ, 20bit
	IPxyNoOperation_F6							= $F6;						// No operation
	IPxyEXCNTCLRRead							= $77;						// EXTERNAL COUNTER 설정 DATA READ, 9bit, 0x00
	IPxyEXCNTCLRWrite							= $F7;						// EXTERNAL COUNTER 설정 DATA WRITE
	IPxyNoOperation_78							= $78;						// No operation
	IPxySWRESET									= $F8;						// REGISTER CLEAR(INITIALIZATION), Software reset
	IPxyINTFLAG1Read							= $79;						// Interrupt Flag1 READ, 32bit, 0x00000000
	IPxyINTFLAG1CLRWrite						= $F9;						// Interrupt Flag1 Clear data write command.
	IPxyINTMASK1Read							= $7A;						// Interrupt Mask1 READ, 32bit, 0x00000001
	IPxyINTMASK1Write							= $FA;						// Interrupt Mask1 WRITE
	IPxyUIOMODERead								= $7B;						// UIO MODE DATA READ, 12bit, 0x01F
	IPxyUIOMODEWrite							= $FB;						// UIO MODE DATA WRITE
	IPxyINTFLAG2Read							= $7C;						// Interrupt Flag2 READ, 32bit, 0x00000000
	IPxyINTFLAG2CLRWrite						= $FC;						// Interrupt Flag2 Clear data write command.
	IPxyINTMASK2Read							= $7D;						// Interrupt Mask2 READ, 32bit, 0x00000001
	IPxyINTMASK2Write							= $FD;						// Interrupt Mask2 WRITE
	IPxyINTUSERCONRead							= $7E;						// User interrupt selection control.
	IPxyINTUSERCONWrite							= $FE;						// User interrupt selection control. 
	IPxyNoOperation_7F							= $7F;						// No operation
	IPxyINTGENCMD								= $FF;						// Interrupt generation command.

//=======================================================================================================================;
implementation

end.
