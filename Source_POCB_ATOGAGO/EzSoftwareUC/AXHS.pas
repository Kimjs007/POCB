//****************************************************************************
//****************************************************************************
//**
//** File Name
//** ---------
//**
//** AXHS.PAS
//**
//** COPYRIGHT (c) AJINEXTEK Co., LTD
//**
//*****************************************************************************
//*****************************************************************************
//**
//** Description
//** -----------
//** Resource Define Header File
//** 
//**
//*****************************************************************************
//*****************************************************************************
//**
//** Source Change Indices
//** ---------------------
//** 
//** (None)
//**
//**
//*****************************************************************************
//*****************************************************************************
//**
//** Website
//** ---------------------
//**
//** http://www.ajinextek.com
//**
//*****************************************************************************
//*****************************************************************************

unit AXHS;

interface
uses Windows, Messages;

    type AXT_INTERRUPT_PROC = procedure(lActiveNo : LongInt; uFlag : DWord); stdcall;
    type AXT_EVENT_PROC = procedure(lActiveNo : LongInt; uFlag : DWord); stdcall;

const
    WM_USER                             = $0400;
    WM_AXL_INTERRUPT                    = (WM_USER + 1001);
    { Define Baseboard                  }
    AXT_UNKNOWN                         = $00;        // Unknown Baseboard
    AXT_BIHR                            = $01;        // ISA bus, Half size
    AXT_BIFR                            = $02;        // ISA bus, Full size
    AXT_BPHR                            = $03;        // PCI bus, Half size
    AXT_BPFR                            = $04;        // PCI bus, Full size
    AXT_BV3R                            = $05;        // VME bus, 3U size
    AXT_BV6R                            = $06;        // VME bus, 6U size
    AXT_BC3R                            = $07;        // cPCI bus, 3U size
    AXT_BC6R                            = $08;        // cPCI bus, 6U size
    AXT_BEHR                            = $09;        // PCIe bus, Half size
    AXT_BEFR                            = $0A;        // PCIe bus, Full size
    AXT_BEHD                            = $0B;        // PCIe bus, Half size, DB-32T
    AXT_FMNSH4D                         = $52;        // ISA bus, Full size, DB-32T, SIO-2V03 * 2
    AXT_PCI_DI64R                       = $43;        // PCI bus, Digital IN 64 point
    AXT_PCIE_DI64R                      = $44;        // PCIe bus, Digital IN 64 point
    AXT_PCI_DO64R                       = $53;        // PCI bus, Digital OUT 64 point
    AXT_PCIE_DO64R                      = $54;        // PCIe bus, Digital OUT 64 point
    AXT_PCI_DB64R                       = $63;        // PCI bus, Digital IN 32 point, OUT 32 point
    AXT_PCIE_DB64R                      = $64;        // PCIe bus, Digital IN 32 point, OUT 32 point
    AXT_PCIN204                         = $82;        // PCI bus, Half size On-Board 2 Axis controller.    
    AXT_BPHD                            = $83;        // PCI bus, Half size, DB-32T
    AXT_PCIN404                         = $84;        // PCI bus, Half size On-Board 4 Axis controller.
    AXT_PCIN804                         = $85;        // PCI bus, Half size On-Board 8 Axis controller.
    AXT_PCIEN804                        = $86;        // PCIe bus, Half size On-Board 8 Axis controller.
    AXT_PCIEN404                        = $87;        // PCIe bus, Half size On-Board 4 Axis controller.
    AXT_PCI_AIO1602HR                   = $93;        // PCI bus, Half size, AI-16ch, AO-2ch AI16HR
    AXT_PCI_R1604                       = $C1;        // PCI bus[PCI9030], Half size, RTEX based 16 axis controller
    AXT_PCI_R3204                       = $C2;        // PCI bus[PCI9030], Half size, RTEX based 32 axis controller
    AXT_PCI_R32IO                       = $C3;        // PCI bus[PCI9030], Half size, RTEX based IO only.
    AXT_PCI_REV2                        = $C4;        // Reserved.
    AXT_PCI_R1604MLII                   = $C5;        // PCI bus[PCI9030], Half size, Mechatrolink-II 16/32 axis controller.
    AXT_PCI_R0804MLII                   = $C6;        // PCI bus[PCI9030], Half size, Mechatrolink-II 08 axis controller.
    AXT_PCI_Rxx00MLIII                  = $C7;        // Master PCI Board, Mechatrolink III AXT, PCI Bus[PCI9030], Half size, Max.32 Slave module support
    AXT_PCIE_Rxx00MLIII                 = $C8;        // Master PCI Express Board, Mechatrolink III AXT, PCI Bus[], Half size, Max.32 Slave module support
    AXT_PCP2_Rxx00MLIII                 = $C9;        // Master PCI/104-Plus Board, Mechatrolink III AXT, PCI Bus[], Half size, Max.32 Slave module support
    AXT_PCI_R1604SIIIH                  = $CA;        // PCI bus[PCI9030], Half size, SSCNET III / H 16/32 axis controller.
    AXT_PCI_R32IOEV                     = $CB;        // PCI bus[PCI9030], Half size, RTEX based IO only. Economic version.
    AXT_PCIE_R0804RTEX                  = $CC;        // PCIe bus, Half size, Half size, RTEX based 08 axis controller.
    AXT_PCIE_R1604RTEX                  = $CD;        // PCIe bus, Half size, Half size, RTEX based 16 axis controller.
    AXT_PCIE_R2404RTEX                  = $CE;        // PCIe bus, Half size, Half size, RTEX based 24 axis controller.
    AXT_PCIE_R3204RTEX                  = $CF;        // PCIe bus, Half size, Half size, RTEX based 32 axis controller.
    AXT_PCIE_Rxx04SIIIH                 = $D0;        // PCIe bus, Half size, SSCNET III / H 16(or 32)-axis(CAMC-QI based) controller.
    AXT_PCIE_Rxx00SIIIH                 = $D1;        // PCIe bus, Half size, SSCNET III / H Max. 32-axis(DSP Based) controller.
	AXT_ETHERCAT_RTOSV5                 = $D2;        // EtherCAT, RTOS(On Time), Version 5.29
    AXT_PCI_Nx04_A                      = $D3;	      // PCI bus, Half size On-Board x Axis controller For Rtos.
    AXT_PCI_R3200MLIII_IO               = $D4;        // PCI Board, Mechatrolink III AXT, PCI Bus[PCI9030], Half size, Max.32 IO only	controller
    AXT_PCIE_R3205MLIII                 = $D5;        // PCIe bus, Half size, Mechatrolink III / H Max. 32-axis(DSP Based) controller.
    
    { Define Module                     }
    AXT_SMC_2V01                        = $01;        // CAMC-5M, 2 Axis
    AXT_SMC_2V02                        = $02;        // CAMC-FS, 2 Axis
    AXT_SMC_1V01                        = $03;        // CAMC-5M, 1 Axis
    AXT_SMC_1V02                        = $04;        // CAMC-FS, 1 Axis
    AXT_SMC_2V03                        = $05;        // CAMC-IP, 2 Axis
    AXT_SMC_4V04                        = $06;        // CAMC-QI, 4 Axis
    AXT_SMC_R1V04A4                     = $07;        // CAMC-QI, 1 Axis, For RTEX A4 slave only
    AXT_SMC_1V03                        = $08;        // CAMC-IP, 1 Axis
    AXT_SMC_R1V04                       = $09;        // CAMC-QI, 1 Axis, For RTEX SLAVE only
    AXT_SMC_R1V04MLIISV                 = $0A;        // CAMC-QI, 1 Axis, For Sigma-X series.          
    AXT_SMC_R1V04MLIIPM                 = $0B;        // 2 Axis, For Pulse output series(JEPMC-PL2910).
    AXT_SMC_2V04                        = $0C;        // CAMC-QI, 2 Axis
    AXT_SMC_R1V04A5                     = $0D;        // CAMC-QI, 1 Axis, For RTEX A5N slave only
    AXT_SMC_R1V04MLIICL                 = $0E;        // CAMC-QI, 1 Axis, For MLII Convex Linear only
    AXT_SMC_R1V04MLIICR                 = $0F;        // CAMC-QI, 1 Axis, For MLII Convex Rotary only
    AXT_SMC_R1V04PM2Q                   = $10;        // CAMC-QI, 2 Axis, For RTEX SLAVE only(Pulse Output Module)
    AXT_SMC_R1V04PM2QE                  = $11;        // CAMC-QI, 4 Axis, For RTEX SLAVE only(Pulse Output Module)
    AXT_SMC_R1V04MLIIORI                = $12;        // CAMC-QI, 1 Axis, For MLII Oriental Step Driver only
    AXT_SMC_R1V04SIIIHMIV               = $14;        // CAMC-QI, 1 Axis, For SSCNETIII/H MRJ4
    AXT_SMC_R1V04SIIIHMIV_R             = $15;          // CAMC-QI, 1 Axis, For SSCNETIII/H MRJ4
    AXT_SMC_R1V04MLIIISV                = $20;          // DSP, 1 Axis, For ML-3 SigmaV/YASKAWA only 
    AXT_SMC_R1V04MLIIIPM                = $21;          // DSP, 1 Axis, For ML-3 SLAVE/AJINEXTEK only(Pulse Output Module)
    AXT_SMC_R1V04MLIIISV_MD             = $22;          // DSP, 1 Axis, For ML-3 SigmaV-MD/YASKAWA only (Multi-Axis Control amp)
    AXT_SMC_R1V04MLIIIS7S               = $23;          // DSP, 1 Axis, For ML-3 Sigma7S/YASKAWA only
    AXT_SMC_R1V04MLIIIS7W               = $24;          // DSP, 2 Axis, For ML-3 Sigma7W/YASKAWA only(Dual-Axis control amp)
    AXT_SMC_R1V04MLIIIRS2               = $25;          // DSP, 1 Axis, For ML-3 RS2A/SANYO DENKY
    AXT_SMC_R1V04MLIIIS7_MD             = $26;          // DSP, 1 Axis, For ML-3 Sigma7-MD/YASKAWA only (Multi-Axis Control amp)
    AXT_SMC_PM2QSIIIH                   = $60;          // CAMC-QI, 2Axis For SSCNETIII/H SLAVE only(Pulse Output Module)
    AXT_SMC_PM4QSIIIH                   = $61;         // CAMC-QI, 4Axis For SSCNETIII/H SLAVE only(Pulse Output Module)
    AXT_SIO_CNT2SIIIH                   = $62;          // Counter slave module, Reversible counter, 2 channels, For SSCNETIII/H Only
    AXT_SIO_DI32SIIIH                   = $63;          // DI slave module, SSCNETIII AXT, IN 32-Channel
    AXT_SIO_DO32SIIIH                   = $64;          // DO slave module, SSCNETIII AXT, OUT 32-Channel
    AXT_SIO_DB32SIIIH                   = $65;          // DB slave module, SSCNETIII AXT, IN 16-Channel, OUT 16-Channel
    AXT_SIO_AI16SIIIH                   = $66;          // AI slave module, SSCNETIII AXT, Analog IN 16ch, 16 bit
    AXT_SIO_AO08SIIIH                   = $67;          // A0 slave module, SSCNETIII AXT, Analog OUT 8ch, 16 bit
    AXT_SMC_PM2QSIIIH_R                 = $68;          // CAMC-QI, 2Axis For SSCNETIII/H SLAVE only(Pulse Output Module)
    AXT_SMC_PM4QSIIIH_R                 = $69;          // CAMC-QI, 4Axis For SSCNETIII/H SLAVE only(Pulse Output Module)
    AXT_SIO_CNT2SIIIH_R                 = $6A;          // Counter slave module, Reversible counter, 2 channels, For SSCNETIII/H Only
    AXT_SIO_DI32SIIIH_R                 = $6B;          // DI slave module, SSCNETIII AXT, IN 32-Channel
    AXT_SIO_DO32SIIIH_R                 = $6C;          // DO slave module, SSCNETIII AXT, OUT 32-Channel
    AXT_SIO_DB32SIIIH_R                 = $6D;          // DB slave module, SSCNETIII AXT, IN 16-Channel, OUT 16-Channel
    AXT_SIO_AI16SIIIH_R                 = $6E;          // AI slave module, SSCNETIII AXT, Analog IN 16ch, 16 bit
    AXT_SIO_AO08SIIIH_R                 = $6F;          // A0 slave module, SSCNETIII AXT, Analog OUT 8ch, 16 bit
    AXT_SIO_RDI32MLIII                  = $70;          // DI slave module, MechatroLink III AXT, IN 32-Channel NPN
    AXT_SIO_RDO32MLIII                  = $71;          // DO slave module, MechatroLink III AXT, OUT 32-Channel  NPN
    AXT_SIO_RDB32MLIII                  = $72;          // DB slave module, MechatroLink III AXT, IN 16-Channel, OUT 16-Channel  NPN
    AXT_SIO_RDI32MSMLIII                = $73;          // DI slave module, MechatroLink III M-SYSTEM, IN 32-Channel
    AXT_SIO_RDO32AMSMLIII               = $74;          // DO slave module, MechatroLink III M-SYSTEM, OUT 32-Channel
    AXT_SIO_RDI32PMLIII                 = $75;          // DI slave module, MechatroLink III AXT, IN 32-Channel PNP
    AXT_SIO_RDO32PMLIII                 = $76;          // DO slave module, MechatroLink III AXT, OUT 32-Channel  PNP
    AXT_SIO_RDB32PMLIII                 = $77;          // DB slave module, MechatroLink III AXT, IN 16-Channel, OUT 16-Channel  PNP
    AXT_SIO_RDI16MLIII                  = $78;          // DI slave module, MechatroLink III M-SYSTEM, IN 16-Channel
    AXT_SIO_UNDEFINEMLIII               = $79;          // IO slave module, MechatroLink III Any, Max. IN 480-Channel, Max. OUT 480-Channel
    AXT_SIO_RDI32MLIIISFA	            = $7A;          // DI slave module, MechatroLink III AXT(SFA), IN 32-Channel NPN
	AXT_SIO_RDO32MLIIISFA	            = $7B;          // DO slave module, MechatroLink III AXT(SFA), OUT 32-Channel  NPN
	AXT_SIO_RDB32MLIIISFA	            = $7C;          // DB slave module, MechatroLink III AXT(SFA), IN 16-Channel, OUT 16-Channel  NPN
    AXT_SIO_RDB128MLIIIAI               = $7D;          // Intelligent I/O (Product by IAI), For MLII only
    AXT_SIO_RSIMPLEIOMLII               = $7E;          // Digital IN/Out xxÁ¡, Simple I/O sereies, MLII Àü¿ë.
    AXT_SIO_RDO16AMLIII                 = $7F;          // DO slave module, MechatroLink III M-SYSTEM, OUT 16-Channel, NPN
    AXT_SIO_RDI16MLII                   = $80;        // DISCRETE INPUT MODULE, 16 points (Product by M-SYSTEM), For MLII only
    AXT_SIO_RDO16AMLII                  = $81;        // NPN TRANSISTOR OUTPUT MODULE, 16 points (Product by M-SYSTEM), For MLII only
    AXT_SIO_RDO16BMLII                  = $82;        // PNP TRANSISTOR OUTPUT MODULE, 16 points (Product by M-SYSTEM), For MLII only    
    AXT_SIO_RDB96MLII                   = $83;        // Digital IN/OUT(Selectable), MAX 96 points, For MLII only
    AXT_SIO_RDO32RTEX                   = $84;        // Digital OUT  32 point
    AXT_SIO_RDI32RTEX                   = $85;        // Digital IN  32 point
    AXT_SIO_RDB32RTEX                   = $86;        // Digital IN/OUT  32 point
	AXT_SIO_RDO16BMLIII                 = $8A;        // DO slave module, MechatroLink III M-SYSTEM, OUT 16-Channel, PNP
	AXT_SIO_RDB32ML2NT1                 = $8B;        // DB slave module, MechatroLink2 AJINEXTEK NT1 Series
    AXT_SIO_RDB128YSMLIII               = $8C;        // IO slave module, MechatroLink III Any, Max. IN 480-Channel, Max. OUT 480-Channel
    AXT_SIO_DI32_P                      = $92;        // Digital IN  32 point, PNP type(source type)
    AXT_SIO_DO32T_P                     = $93;        // Digital OUT 32 point, Power TR, PNT type(source type)
    AXT_SIO_RDB128MLII                  = $94;        // Digital IN 64 point / OUT 64 point, MLII Only(JEPMC-IO2310)
    AXT_SIO_RDI32                       = $95;        // Digital IN  32 point, For RTEX only
    AXT_SIO_RDO32                       = $96;        // Digital OUT 32 point, For RTEX only
    AXT_SIO_DI32                        = $97;        // Digital IN  32 point
    AXT_SIO_DO32P                       = $98;        // Digital OUT 32 point
    AXT_SIO_DB32P                       = $99;        // Digital IN 16 point / OUT 16 point
    AXT_SIO_RDB32T                      = $9A;        // Digital IN 16 point / OUT 16 point, For RTEX only
    AXT_SIO_DO32T                       = $9E;        // Digital OUT 16 point, Power TR output
    AXT_SIO_DB32T                       = $9F;        // Digital IN 16 point / OUT 16 point, Power TR output
    AXT_SIO_RAI16RB                     = $A0;        // A0h(160) : AI 16Ch, 16 bit, For RTEX only
    AXT_SIO_AI4RB                       = $A1;        // A1h(161) : AI 4Ch, 12 bit
    AXT_SIO_AO4RB                       = $A2;        // A2h(162) : AO 4Ch, 12 bit
    AXT_SIO_AI16H                       = $A3;        // A3h(163) : AI 4Ch, 16 bit
    AXT_SIO_AO8H                        = $A4;        // A4h(164) : AO 4Ch, 16 bit
    AXT_SIO_AI16HB                      = $A5;        // A5h(165) : AI 16Ch, 16 bit (SIO-AI16HR(input module))
    AXT_SIO_AO2HB                       = $A6;        // A6h(166) : AO 2Ch, 16 bit  (SIO-AI16HR(output module))
    AXT_SIO_RAI8RB                      = $A7;        // A1h(167) : AI 8Ch, 16 bit, For RTEX only
    AXT_SIO_RAO4RB                      = $A8;        // A2h(168) : AO 4Ch, 16 bit, For RTEX only
    AXT_SIO_RAI4MLII                    = $A9;        // A9h(169) : AI 4Ch, 16 bit, For MLII only
    AXT_SIO_RAO2MLII                    = $AA;        // AAh(170) : AO 2Ch, 16 bit, For MLII only
    AXT_SIO_RAVCI4MLII                  = $AB;        // DC VOLTAGE/CURRENT INPUT MODULE, 4 points (Product by M-SYSTEM), For MLII only
    AXT_SIO_RAVO2MLII                   = $AC;        // DC VOLTAGE OUTPUT MODULE, 2 points (Product by M-SYSTEM), For MLII only
    AXT_SIO_RACO2MLII                   = $AD;        // DC CURRENT OUTPUT MODULE, 2 points (Product by M-SYSTEM), For MLII only
    AXT_SIO_RATI4MLII                   = $AE;        // THERMOCOUPLE INPUT MODULE, 4 points (Product by M-SYSTEM), For MLII only
    AXT_SIO_RARTDI4MLII                 = $AF;        // RTD INPUT MODULE, 4 points (Product by M-SYSTEM), For MLII only
    AXT_SIO_RCNT2MLII                   = $B0;        // Counter Module Reversible counter, 2 channels (Product by YASKWA)    
    AXT_SIO_CN2CH                       = $B1;        // Counter Module, 2 channels, Remapped ID, Actual ID is (0xA8)
    AXT_SIO_RCNT2RTEX                   = $B2;        // Counter slave module, Reversible counter, 2 channels, For RTEX Only
    AXT_SIO_RCNT2MLIII                  = $B3;        // Counter slave moudle, MechatroLink III AXT, 2 ch, Trigger per channel
    AXT_SIO_RHPC4MLIII                  = $B4;        // Counter slave moudle, MechatroLink III AXT, 4 ch
    AXT_SIO_RAI16RTEX                   = $C0;        // ANALOG VOLTAGE INPUT(+- 10V) 16 Channel RTEX
    AXT_SIO_RAO08RTEX                   = $C1;        // ANALOG VOLTAGE OUTPUT(+- 10V) 08 Channel RTEX
    AXT_SIO_RAI8MLIII                   = $C2;        // AI slave module, MechatroLink III AXT, Analog IN 8ch, 16 bit
    AXT_SIO_RAI16MLIII                  = $C3;        // AI slave module, MechatroLink III AXT, Analog IN 16ch, 16 bit
    AXT_SIO_RAO4MLIII                   = $C4;        // A0 slave module, MechatroLink III AXT, Analog OUT 4ch, 16 bit
    AXT_SIO_RAO8MLIII                   = $C5;        // A0 slave module, MechatroLink III AXT, Analog OUT 8ch, 16 bit
    AXT_SIO_RAVO4MLII                   = $C6;        // DC VOLTAGE OUTPUT MODULE, 4 points (Product by M-SYSTEM), For MLII only
    AXT_SIO_RAV04MLIII                  = $C7;        // AO Slave module, MechatroLink III M-SYSTEM Voltage output module
    AXT_SIO_RAVI4MLIII                  = $C8;        // AI Slave module, MechatroLink III M-SYSTEM Voltage/Current input module
    AXT_SIO_RAI16MLIIISFA               = $C9;        // AI slave module, MechatroLink III AXT(SFA), Analog IN 16ch, 16 bit	
    AXT_SIO_RDB32MSMLIII                = $CA;        // DIO slave module, MechatroLink III M-SYSTEM, IN 16-Channel, OUT 16-Channel
    AXT_COM_234R                        = $D3;        // COM-234R
    AXT_COM_484R                        = $D4;        // COM-484R
    AXT_SIO_RPI2                        = $D5;        // Pulse counter module(JEPMC-2900)
    AXT_SIO_HPC4                        = $D6;        // D6h : External Encoder module for 4Channel with Trigger function.
    AXT_SIO_AO4HB                       = $D7;        // D7h : AO 4Ch, 16 bit
    AXT_SIO_AI8HB                       = $D8;        // D8h : AI 8Ch, 16 bit
    AXT_SIO_AI8AO4HB                    = $D9;        // AI 8Ch, AO 4Ch, 16 bit
    
    { Define Function Result            }
    AXT_RT_SUCCESS                      = 0;          // API function executed successfully
    AXT_RT_OPEN_ERROR                   = 1001;       // Library is not open
    AXT_RT_OPEN_ALREADY                 = 1002;       // Library is already open
    AXT_RT_NOT_OPEN                     = 1053;       // Failed to initialize the library
    AXT_RT_NOT_SUPPORT_VERSION          = 1054;       // Hardware not supported
    AXT_RT_LOCK_FILE_MISMATCH           = 1055;       // Lock file mismatch
    
    AXT_RT_INVALID_BOARD_NO             = 1101;       // IInvalide board number
    AXT_RT_INVALID_MODULE_POS           = 1102;       // Invalid module position
    AXT_RT_INVALID_LEVEL                = 1103;       // Invalid level
    AXT_RT_INVALID_VARIABLE             = 1104;       // Invalid Variable
    AXT_RT_ERROR_VERSION_READ           = 1151;       // Failed to read library version
    AXT_RT_NETWORK_ERROR                = 1152;       // Hardware network error
    AXT_RT_NETWORK_LOCK_MISMATCH        = 1153;
    
    AXT_RT_1ST_BELOW_MIN_VALUE          = 1160;       // First parameter is below the minimum value
    AXT_RT_1ST_ABOVE_MAX_VALUE          = 1161;       // First parameter is above the maximum value
    AXT_RT_2ND_BELOW_MIN_VALUE          = 1170;       // Second parameter is below the minimum value
    AXT_RT_2ND_ABOVE_MAX_VALUE          = 1171;       // Second parameter is above the maximum value
    AXT_RT_3RD_BELOW_MIN_VALUE          = 1180;       // Third parameter is below the minimum value
    AXT_RT_3RD_ABOVE_MAX_VALUE          = 1181;       // Third parameter is above the maximum value
    AXT_RT_4TH_BELOW_MIN_VALUE          = 1190;       // Fourth parameter is below the minimum value
    AXT_RT_4TH_ABOVE_MAX_VALUE          = 1191;       // Fourth parameter is above the maximum value
    AXT_RT_5TH_BELOW_MIN_VALUE          = 1200;       // Fifth parameter is below the minimum value
    AXT_RT_5TH_ABOVE_MAX_VALUE          = 1201;       // Fifth parameter is above the maximum value
    AXT_RT_6TH_BELOW_MIN_VALUE          = 1210;       // Sixth parameter is below the minimum value
    AXT_RT_6TH_ABOVE_MAX_VALUE          = 1211;       // Sixth parameter is above the maximum value
    AXT_RT_7TH_BELOW_MIN_VALUE          = 1220;       // Seventh parameter is below the minimum value
    AXT_RT_7TH_ABOVE_MAX_VALUE          = 1221;       // Seventh parameter is above the maximum value
    AXT_RT_8TH_BELOW_MIN_VALUE          = 1230;       // Eighth parameter is below the minimum value
    AXT_RT_8TH_ABOVE_MAX_VALUE          = 1231;       // Eighth parameter is above the maximum value
    AXT_RT_9TH_BELOW_MIN_VALUE          = 1240;       // Ninth parameter is below the minimum value
    AXT_RT_9TH_ABOVE_MAX_VALUE          = 1241;       // Ninth parameter is above the maximum value
    AXT_RT_10TH_BELOW_MIN_VALUE         = 1250;       // Tenth parameter is above the minimum value
    AXT_RT_10TH_ABOVE_MAX_VALUE         = 1251;       // Tenth parameter is above the maximum value
    
    AXT_RT_AIO_OPEN_ERROR               = 2001;       // Filed to open AIO module
    AXT_RT_AIO_NOT_MODULE               = 2051;       // No AIO module
    AXT_RT_AIO_NOT_EVENT                = 2052;       // Failed to read AIO event
    AXT_RT_AIO_INVALID_MODULE_NO        = 2101;       // Invalid AIO module
    AXT_RT_AIO_INVALID_CHANNEL_NO       = 2102;       // Invalid AIO channel number
    AXT_RT_AIO_INVALID_USE              = 2106;       // Can not use AIO
    AXT_RT_AIO_INVALID_TRIGGER_MODE     = 2107;       // Invalid trigger mode
    AXT_RT_AIO_EXTERNAL_DATA_EMPTY      = 2108;
    
    AXT_RT_DIO_OPEN_ERROR               = 3001;       // Failed to open DIO module
    AXT_RT_DIO_NOT_MODULE               = 3051;       // No DIO module
    AXT_RT_DIO_NOT_INTERRUPT            = 3052;       // DIO Interrupt not set
    AXT_RT_DIO_INVALID_MODULE_NO        = 3101;       // Invalid DIO module number
    AXT_RT_DIO_INVALID_OFFSET_NO        = 3102;       // Invalid DIO OFFSET number
    AXT_RT_DIO_INVALID_LEVEL            = 3103;       // Invalid DIO level
    AXT_RT_DIO_INVALID_MODE             = 3104;       // Invalid DIO mode
    AXT_RT_DIO_INVALID_VALUE            = 3105;       // Invalid setting value
    AXT_RT_DIO_INVALID_USE              = 3106;       // Can not use DIO API function
    
    AXT_RT_CNT_OPEN_ERROR               = 3201;       // Fail to open CND module
    AXT_RT_CNT_NOT_MODULE               = 3251;       // No CNT module
    AXT_RT_CNT_NOT_INTERRUPT            = 3252;       // CNT Interrupt not set
    AXT_RT_CNT_INVALID_MODULE_NO        = 3301;       // Invalid CNT module number
    AXT_RT_CNT_INVALID_OFFSET_NO        = 3302;       // Invalid CNT OFFSET number
    AXT_RT_CNT_INVALID_LEVEL            = 3303;       // Invalid CNT level
    AXT_RT_CNT_INVALID_MODE             = 3304;       // Invalid CNT mode
    AXT_RT_CNT_INVALID_VALUE            = 3305;       // Invalid setting value
    AXT_RT_CNT_INVALID_USE              = 3306;       // Can not use CNT API function
    
    AXT_RT_MOTION_OPEN_ERROR            = 4001;       // Failed to open motion library
    AXT_RT_MOTION_NOT_MODULE            = 4051;       // No motion module is installed in the system
    AXT_RT_MOTION_NOT_INTERRUPT         = 4052;       // Failed to read the result of interrupt
    AXT_RT_MOTION_NOT_INITIAL_AXIS_NO   = 4053;       // Failed to initialize the motion of corresponding axis
    AXT_RT_MOTION_NOT_IN_CONT_INTERPOL  = 4054;       // Command to stop continuous interpolation while not in continuous interpolation motion
    AXT_RT_MOTION_NOT_PARA_READ         = 4055;       // Failed to load parameters for home return drive
    AXT_RT_MOTION_INVALID_AXIS_NO       = 4101;       // Corresponding axis does not exist
    AXT_RT_MOTION_INVALID_METHOD        = 4102;       // Invalid setting for corresponding axis drive
    AXT_RT_MOTION_INVALID_USE           = 4103;       // Invalid setting for 'uUse' parameter
    AXT_RT_MOTION_INVALID_LEVEL         = 4104;       // Invalid setting for 'uLevel' parameter
    AXT_RT_MOTION_INVALID_BIT_NO        = 4105;       // Invalid setting for general purpose input/output bit
    AXT_RT_MOTION_INVALID_STOP_MODE     = 4106;       // Invalid setting values for motion stop mode
    AXT_RT_MOTION_INVALID_TRIGGER_MODE  = 4107;       // Invalid setting for trigger setting mode
    AXT_RT_MOTION_INVALID_TRIGGER_LEVEL = 4108;       // Invalid setting for trigger output level
    AXT_RT_MOTION_INVALID_SELECTION     = 4109;       // 'uSelection' parameter is set to a value other than COMMAND or ACTUAL
    AXT_RT_MOTION_INVALID_TIME          = 4110;       // Invalid setting for Trigger output time value
    AXT_RT_MOTION_INVALID_FILE_LOAD     = 4111;       // Failed to load the file containing motion setting values
    AXT_RT_MOTION_INVALID_FILE_SAVE     = 4112;       // Failed to save the file containing motion setting values
    AXT_RT_MOTION_INVALID_VELOCITY      = 4113;       // Motion error occurred since the motion drive velocity value is set as zero
    AXT_RT_MOTION_INVALID_ACCELTIME     = 4114;       // Motion error occurred since motion drive acceleration time value is set as zero
    AXT_RT_MOTION_INVALID_PULSE_VALUE   = 4115;       // Input pulse value is set to a value less than zero when setting motion unit
    AXT_RT_MOTION_INVALID_NODE_NUMBER   = 4116;       // Called position or velocity override function while not in motion
    AXT_RT_MOTION_INVALID_TARGET        = 4117;       // Flag indicating the cause of multi axis motion stop
    AXT_RT_MOTION_ERROR_IN_NONMOTION    = 4151;       // Not in motion drive when it should be
    AXT_RT_MOTION_ERROR_IN_MOTION       = 4152;       // Called another motion drive function before the completion of current motion
    AXT_RT_MOTION_ERROR                 = 4153;       // Error occurred during the execution of multi axis motion stop function
    AXT_RT_MOTION_ERROR_GANTRY_ENABLE   = 4154;       // Gantry-enable is activated again while in motion with gantry enabled
    AXT_RT_MOTION_ERROR_GANTRY_AXIS     = 4155;       // Invalid input of gantry axis master channel (axis) number (starting from zero)
    AXT_RT_MOTION_ERROR_MASTER_SERVOON  = 4156;       // Servo ON is not enabled for the master axis
    AXT_RT_MOTION_ERROR_SLAVE_SERVOON   = 4157;       // Servo ON is not enabled for the slave axis
    AXT_RT_MOTION_INVALID_POSITION      = 4158;       // Not in a valid position
    AXT_RT_ERROR_NOT_SAME_MODULE        = 4159;       // Not in the same module
    AXT_RT_ERROR_NOT_SAME_BOARD         = 4160;       // Not in the same board
    AXT_RT_ERROR_NOT_SAME_PRODUCT       = 4161;       // When products are different each other
    AXT_RT_NOT_CAPTURED                 = 4162;       // Failed to capture the position
    AXT_RT_ERROR_NOT_SAME_IC            = 4163;       // Not in the same chip
    AXT_RT_ERROR_NOT_GEARMODE           = 4164;       // Failed to change to the gear mode
    AXT_ERROR_CONTI_INVALID_AXIS_NO     = 4165;       // Invalid axis during continuous interpolation axies mapping
    AXT_ERROR_CONTI_INVALID_MAP_NO      = 4166;       // Invalid mapping number during continuous interpolation mapping
    AXT_ERROR_CONTI_EMPTY_MAP_NO        = 4167;       // Continuous interpolation mapping number is empty
    AXT_RT_MOTION_ERROR_CACULATION      = 4168;       // Error in calculation
    AXT_RT_ERROR_MOVE_SENSOR_CHECK      = 4169; 
    
    AXT_ERROR_HELICAL_INVALID_AXIS_NO   = 4170;       // Invalid axis for helical axis mapping
    AXT_ERROR_HELICAL_INVALID_MAP_NO    = 4171;       // Invalid mapping number for helical mapping
    AXT_ERROR_HELICAL_EMPTY_MAP_NO      = 4172;       // Helical mapping number is empty
    
    AXT_ERROR_SPLINE_INVALID_AXIS_NO    = 4180;       // Invalid axis for spline axis mapping
    AXT_ERROR_SPLINE_INVALID_MAP_NO     = 4181;       // Invalid mapping number for spline mapping
    AXT_ERROR_SPLINE_EMPTY_MAP_NO       = 4182;       // Spline Mapping number is empty
    AXT_ERROR_SPLINE_NUM_ERROR          = 4183;       // Spline point value is inapplicable
    AXT_RT_MOTION_INTERPOL_VALUE        = 4184;       // Invalid input value for interpolation
    AXT_RT_ERROR_NOT_CONTIBEGIN         = 4185;       // CONTIBEGIN function is not called in continuous interpolation
    AXT_RT_ERROR_NOT_CONTIEND           = 4186;       // CONTIEND function is not called in continuous interpolation
    
    AXT_RT_MOTION_HOME_SEARCHING        = 4201;       // Other function is called while in home search motion
    AXT_RT_MOTION_HOME_ERROR_SEARCHING  = 4202;       // Home search motion is forced to stop by the user or something from external
    AXT_RT_MOTION_HOME_ERROR_START      = 4203;       // Failed to start home search drive due to Initialization  problem
    AXT_RT_MOTION_HOME_ERROR_GANTRY     = 4204;       // Failed to execute Gantry enable during home search motion
    
    AXT_RT_MOTION_READ_ALARM_WAITING    = 4210;       
    AXT_RT_MOTION_READ_ALARM_NO_REQUEST = 4211;       
    AXT_RT_MOTION_READ_ALARM_TIMEOUT    = 4212;       
    AXT_RT_MOTION_READ_ALARM_FAILED     = 4213;       
    AXT_RT_MOTION_READ_ALARM_UNKNOWN    = 4220;       
    AXT_RT_MOTION_READ_ALARM_FILES      = 4221;       
    
    AXT_RT_MOTION_POSITION_OUTOFBOUND   = 4251;       // Configured position is either above the maximum value or below the minimum value
    AXT_RT_MOTION_PROFILE_INVALID       = 4252;       // Invalid setting for velocity profile
    AXT_RT_MOTION_VELOCITY_OUTOFBOUND   = 4253;       // Configured velocity is either above the maximum value or below the minimum value
    AXT_RT_MOTION_MOVE_UNIT_IS_ZERO     = 4254;       // Unit of the motion values is set as zero
    AXT_RT_MOTION_SETTING_ERROR         = 4255;       // Invalid setting for Velocity, Acceleration, Jerk, or Profile
    AXT_RT_MOTION_IN_CONT_INTERPOL      = 4256;       // Execution of motion start or restart function before the completion of current continuous interpolated motion
    AXT_RT_MOTION_DISABLE_TRIGGER       = 4257;       // Trigger output is disabled
    AXT_RT_MOTION_INVALID_CONT_INDEX    = 4258;       // Invalid setting for continuous interpolation index value
    AXT_RT_MOTION_CONT_QUEUE_FULL       = 4259;       // Continuous Interpolation queue of motion chip is full
    AXT_RT_PROTECTED_DURING_SERVOON     = 4260;       // Protected during servo-on
    AXT_RT_HW_ACCESS_ERROR              = 4261;       // Failed memory Read / Write
    
    AXT_RT_HW_DPRAM_CMD_WRITE_ERROR_LV1 = 4262;       // DPRAM Command Write fail Level1
    AXT_RT_HW_DPRAM_CMD_WRITE_ERROR_LV2 = 4263;       // DPRAM Command Write fail Level2
    AXT_RT_HW_DPRAM_CMD_WRITE_ERROR_LV3 = 4264;       // DPRAM Command Write fail Level3
    AXT_RT_HW_DPRAM_CMD_READ_ERROR_LV1  = 4265;       // DPRAM Command Read fail Level1
    AXT_RT_HW_DPRAM_CMD_READ_ERROR_LV2  = 4266;       // DPRAM Command Read fail Level2
    AXT_RT_HW_DPRAM_CMD_READ_ERROR_LV3  = 4267;       // DPRAM Command Read fail Level3

    AXT_RT_COMPENSATION_SET_PARAM_FIRST = 4300;
    
    AXT_RT_SEQ_NOT_IN_SERVICE           = 4400;
    AXT_ERROR_SEQ_INVALID_MAP_NO        = 4401;
    AXT_ERROR_INVALID_AXIS_NO           = 4402;
    AXT_RT_ERROR_NOT_SEQ_NODE_BEGIN     = 4403;
    AXT_RT_ERROR_NOT_SEQ_NODE_END       = 4404;
    AXT_RT_ERROR_NO_NODE                = 4405;
    AXT_RT_ERROR_SEQ_STOP_TIMEOUT       = 4406;
    
    AXT_RT_M3_COMMUNICATION_FAILED             = 4500;   // ML3 Only
    AXT_RT_MOTION_ONE_OF_AXES_IS_NOT_M3        = 4501;   // ML3 Only
    AXT_RT_MOTION_BIGGER_VEL_THEN_MAX_VEL      = 4502;   // ML3 Only
    AXT_RT_MOTION_SMALLER_VEL_THEN_MAX_VEL     = 4503;   // ML3 Only
    AXT_RT_MOTION_ACCEL_MUST_BIGGER_THEN_ZERO  = 4504;   // ML3 Only
    AXT_RT_MOTION_SMALL_ACCEL_WITH_UNIT_PULSE  = 4505;   // ML3 Only
    AXT_RT_MOTION_INVALID_INPUT_ACCEL          = 4506;   // ML3 Only
    AXT_RT_MOTION_SMALL_DECEL_WITH_UNIT_PULSE  = 4507;   // ML3 Only
    AXT_RT_MOTION_INVALID_INPUT_DECEL          = 4508;   // ML3 Only
    AXT_RT_MOTION_SAME_START_AND_CENTER_POS    = 4509;   // ML3 Only
    AXT_RT_MOTION_INVALID_JERK                 = 4510;   // ML3 Only
    AXT_RT_MOTION_INVALID_INPUT_VALUE          = 4511;   // ML3 Only
    AXT_RT_MOTION_NOT_SUPPORT_PROFILE          = 4512;   // ML3 Only
    AXT_RT_MOTION_INPOS_UNUSED                 = 4513;   // ML3 Only
    AXT_RT_MOTION_AXIS_IN_SLAVE_STATE          = 4514;   // ML3 Only
    AXT_RT_MOTION_AXES_ARE_NOT_SAME_BOARD      = 4515;   // ML3 Only
    AXT_RT_MOTION_ERROR_IN_ALARM               = 4516;   // ML3 Only
    AXT_RT_MOTION_ERROR_IN_EMGN                = 4517;   // ML3 Only
    AXT_RT_MOTION_CAN_NOT_CHANGE_COORD_NO      = 4518;   // ML3 Only
    AXT_RT_MOTION_INVALID_INTERNAL_RADIOUS     = 4519;   // ML3 Only
    AXT_RT_MOTION_CONTI_QUEUE_FULL             = 4521;   // ML3 Only
    AXT_RT_MOTION_SAME_START_AND_END_POSITION  = 4522;   // ML3 Only
    AXT_RT_MOTION_INVALID_ANGLE                = 4523;   // ML3 Only
    AXT_RT_MOTION_CONTI_QUEUE_EMPTY            = 4524;   // ML3 Only
    AXT_RT_MOTION_ERROR_GEAR_ENABLE            = 4525;   // ML3 Only
    AXT_RT_MOTION_ERROR_GEAR_AXIS              = 4526;   // ML3 Only
    AXT_RT_MOTION_ERROR_NO_GANTRY_ENABLE       = 4527;   // ML3 Only
    AXT_RT_MOTION_ERROR_NO_GEAR_ENABLE         = 4528;   // ML3 Only
    AXT_RT_MOTION_ERROR_GANTRY_ENABLE_FULL     = 4529;   // ML3 Only
    AXT_RT_MOTION_ERROR_GEAR_ENABLE_FULL       = 4530;   // ML3 Only
    AXT_RT_MOTION_ERROR_NO_GANTRY_SLAVE        = 4531;   // ML3 Only
    AXT_RT_MOTION_ERROR_NO_GEAR_SLAVE          = 4532;   // ML3 Only
    AXT_RT_MOTION_ERROR_MASTER_SLAVE_SAME      = 4533;   // ML3 Only
    AXT_RT_MOTION_NOT_SUPPORT_HOMESIGNAL       = 4534;   // ML3 Only
    AXT_RT_MOTION_ERROR_NOT_SYNC_CONNECT       = 4535;   // ML3 Only
    AXT_RT_MOTION_OVERFLOW_POSITION            = 4536;   // ML3 Only
    AXT_RT_MOTION_ERROR_INVALID_CONTIMAPAXIS   = 4537;   // ML3 Only
    AXT_RT_MOTION_ERROR_INVALID_CONTIMAPSIZE   = 4538;   // ML3 Only
    AXT_RT_MOTION_ERROR_IN_SERVO_OFF           = 4539;   // ML3 Only
    AXT_RT_MOTION_ERROR_POSITIVE_LIMIT         = 4540;   // ML3 Only
    AXT_RT_MOTION_ERROR_NEGATIVE_LIMIT         = 4541;   // ML3 Only
    AXT_RT_MOTION_ERROR_OVERFLOW_SWPROFILE_NUM = 4542;   // ML3 Only
    AXT_RT_PROTECTED_DURING_INMOTION           = 4543;   // ML3 Only

    AXT_RT_DATA_FLASH_NOT_EXIST         = 5000;
    AXT_RT_DATA_FLASH_BUSY              = 5001;
    
    { Define Log Level                  }
    LEVEL_NONE                          = 0;
    LEVEL_ERROR                         = 1;
    LEVEL_RUNSTOP                       = 2;
    LEVEL_FUNCTION                      = 3;
    
    { Define Axis Status                }
    STATUS_NOTEXIST                     = 0;
    STATUS_EXIST                        = 1;
    
    { Define Use Flag                   }
    DISABLE                             = 0;
    ENABLE                              = 1;
    
    { Define Analog Input Trigger Mode  }
    DISABLE_MODE                        = 0;
    NORMAL_MODE                         = 1;
    TIMER_MODE                          = 2;
    EXTERNAL_MODE                       = 3;
    
    { Define Analog Input Fifo Control  }
    NEW_DATA_KEEP                       = 0;
    CURR_DATA_KEEP                      = 1;
    
    { Define Analog Input Event Mask    }
    DATA_EMPTY                          = $01;
    DATA_MANY                           = $02;
    DATA_SMALL                          = $04;
    DATA_FULL                           = $08;
    
    { Define Analog Input Interrupt Mask}
    ADC_DONE                            = $00;
    SCAN_END                            = $01;
    FIFO_HALF_FULL                      = $02;
    NO_SIGNAL                           = $03;
    
    { Define Analog Input Queue Event   } 
    AIO_EVENT_DATA_RESET                = $00;
    AIO_EVENT_DATA_UPPER                = $1;
    AIO_EVENT_DATA_LOWER                = $2;
    AIO_EVENT_DATA_FULL                 = $3;
    AIO_EVENT_DATA_EMPTY                = $4;
    
    { AI Module H/W FIFO Status Define  }   
    FIFO_DATA_EXIST                     = 0;
    FIFO_DATA_EMPTY                     = 1;
    FIFO_DATA_HALF                      = 2;
    FIFO_DATA_FULL                      = 6;

    { AI Module Conversion Status Define}   
    EXTERNAL_DATA_DONE                  = 0;
    EXTERNAL_DATA_FINE                  = 1;
    EXTERNAL_DATA_HALF                  = 2;
    EXTERNAL_DATA_FULL                  = 3;
    EXTERNAL_COMPLETE                   = 4;

    { Define Digital Input Edge         }
    DOWN_EDGE                           = 0;
    UP_EDGE                             = 1;
    
    { Define DIO Contact Status         }
    OFF_STATE                           = 0;
    ON_STATE                            = 1;
    
    { Define Motion Stop Mode           }
    EMERGENCY_STOP                      = 0;
    SLOWDOWN_STOP                       = 1;
    
    { Define Motion Edge                }
    SIGNAL_UP_EDGE                      = 0;
    SIGNAL_DOWN_EDGE                    = 1;
    SIGNAL_LOW_LEVEL                    = 2;
    SIGNAL_HIGH_LEVEL                   = 3;
    
    { Define Motion Position Type       }
    COMMAND                             = 0;
    ACTUAL                              = 1;
    
    { Define Motion Trigger Type        }
    PERIOD_MODE                         = 0;
    ABS_POS_MODE                        = 1;
    
    { Define Motion Signal Level        }
    LOW                                 = 0;
    HIGH                                = 1;
    UNUSED                              = 2;
    USED                                = 3;
    
    { Define Motion Coordinate Type     }
    POS_ABS_MODE                        = 0;
    POS_REL_MODE                        = 1;
    
    { Define Motion Profile Type        }
    SYM_TRAPEZOIDE_MODE                 = 0;
    ASYM_TRAPEZOIDE_MODE                = 1;
    QUASI_S_CURVE_MODE                  = 2;
    SYM_S_CURVE_MODE                    = 3;
    ASYM_S_CURVE_MODE                   = 4;
    
    { Define Motion Signal Status       }
    INACTIVE                            = 0;
    ACTIVE                              = 1;
    
    { Define Motion Home Result         }
    HOME_RESERVED                       = $00;
    HOME_SUCCESS                        = $01;
    HOME_SEARCHING                      = $02;
    HOME_ERR_GNT_RANGE                  = $10;
    HOME_ERR_USER_BREAK                 = $11;
    HOME_ERR_VELOCITY                   = $12;
    HOME_ERR_AMP_FAULT                  = $13;
    HOME_ERR_NEG_LIMIT                  = $14;
    HOME_ERR_POS_LIMIT                  = $15;
    HOME_ERR_NOT_DETECT                 = $16;
    HOME_ERR_SETTING                    = $17;
   	HOME_ERR_SERVO_OFF                  = $18;
    HOME_ERR_TIMEOUT                    = $20;
    HOME_ERR_FUNCALL                    = $30;
    HOME_ERR_COUPLING                   = $40;
    HOME_ERR_UNKNOWN                    = $FF;
    
    { Define Motion Universal Input     }
    UIO_INP0                            = 0;
    UIO_INP1                            = 1;
    UIO_INP2                            = 2;
    UIO_INP3                            = 3;
    UIO_INP4                            = 4;
    UIO_INP5                            = 5;
    
    { Define Motion Universal Output    }
    UIO_OUT0                            = 0;
    UIO_OUT1                            = 1;
    UIO_OUT2                            = 2;
    UIO_OUT3                            = 3;
    UIO_OUT4                            = 4;
    UIO_OUT5                            = 5;
    
    { Define Motion Deceleration Method }
    AutoDetect                          = 0;
    RestPulse                           = 1;
    
    { Define Motion Pulse Output Method }
    OneHighLowHigh                      = $0;         // 1 pulse method, PULSE(Active High), forward direction(DIR=Low)  / reverse direction(DIR=High)
    OneHighHighLow                      = $1;         // 1 pulse method, PULSE(Active High), forward direction (DIR=High) / reverse direction (DIR=Low)
    OneLowLowHigh                       = $2;         // 1 pulse method, PULSE(Active Low), forward direction (DIR=Low)  / reverse direction (DIR=High)
    OneLowHighLow                       = $3;         // 1 pulse method, PULSE(Active Low), forward direction (DIR=High) / reverse direction (DIR=Low)
    TwoCcwCwHigh                        = $4;         // 2 pulse method, PULSE(CCW: reverse direction),  DIR(CW: forward direction),  Active High
    TwoCcwCwLow                         = $5;         // 2 pulse method, PULSE(CCW: reverse direction),  DIR(CW: forward direction),  Active Low
    TwoCwCcwHigh                        = $6;         // 2 pulse method, PULSE(CW: forward direction),   DIR(CCW: reverse direction), Active High
    TwoCwCcwLow                         = $7;         // 2 pulse method, PULSE(CW: forward direction),   DIR(CCW: reverse direction), Active Low
    TwoPhase                            = $8;         // 2 phase (90' phase difference),  PULSE lead DIR(CW: forward direction), PULSE lag DIR(CCW: reverse direction)
    TwoPhaseReverse                     = $9;         // 2 phase(90' phase difference),  PULSE lead DIR(CCW: Forward diredtion), PULSE lag DIR(CW: Reverse direction)
    
    { Define Motion Encoder Input Method}
    ObverseUpDownMode                   = $0;         // Forward direction Up/Down
    ObverseSqr1Mode                     = $1;         // Forward direction 1 multiplication
    ObverseSqr2Mode                     = $2;         // Forward direction 2 multiplication
    ObverseSqr4Mode                     = $3;         // Forward direction 4 multiplication
    ReverseUpDownMode                   = $4;         // Reverse direction Up/Down
    ReverseSqr1Mode                     = $5;         // Reverse direction 1 multiplication
    ReverseSqr2Mode                     = $6;         // Reverse direction 2 multiplication
    ReverseSqr4Mode                     = $7;         // Reverse direction 4 multiplication
    
    { Define Motion Acceleration Unit   }
    UNIT_SEC2                           = $0;         // unit/sec2
    SEC                                 = $1;         // sec
    RPM_SEC2                            = $2;         // rpm/sec2
    
    { Define Motion Move Direction      }
    DIR_CCW                             = $0;         // Counterclockwise direction
    DIR_CW                              = $1;         // Clockwise direction
    
    { Define Motion Move Circular Method}
    SHORT_DISTANCE                      = $0;         // Short distance circular movement
    LONG_DISTANCE                       = $1;         // Lone distance circular movement
    
    { Define Motion Interpolation Axis  }
    INTERPOLATION_AXIS2                 = $0;         // When 2 axis is used for interpolation
    INTERPOLATION_AXIS3                 = $1;         // When 3 axis is used for interpolation
    INTERPOLATION_AXIS4                 = $2;         // When 4 axis is used for interpolation
    
    { Define Motion Interpolation Method}
    CONTI_NODE_VELOCITY                 = $0;         // Velocity assigned interpolation mode
    CONTI_NODE_MANUAL                   = $1;         // Node acceleration and deceleration interpolation mode
    CONTI_NODE_AUTO                     = $2;         // Automatic acceleration and deceleration interpolation mode
    
    { Define Motion Home Detect Signal  }
    PosEndLimit                         = $0;         // +Elm(End limit) + direction limit sensor signal
    NegEndLimit                         = $1;         // Elm(End limit) - direction limit sensor signal
    PosSloLimit                         = $2;         // +Slm(Decelerate limit) signal - Not-used
    NegSloLimit                         = $3;         // -Slm(Decelerate limit) signal - Not-used
    HomeSensor                          = $4;         // IN0(ORG)  home sensor signal
    EncodZPhase                         = $5;         // IN1(Z phase)  Encoder Z phase signal
    UniInput02                          = $6;         // IN2(universal) universal input number 2 signal
    UniInput03                          = $7;         // IN3(universal) universal input number 3 signal
    UniInput04                          = $8;         // IN4(universal) universal input number 4 signal

    { Define Motion Input Filter Signal }
    END_LIMIT                           = $10;        // +Elm(End limit)
    INP_ALARM                           = $11;        // -Elm(End limit)
    UIN_00_01                           = $12;        // +Slm(Slow Down limit)
    UIN_02_04                           = $13;        // -Slm(Slow Down limit)

    { Define Motion MPG Input Method    }
    MPG_DIFF_ONE_PHASE                  = $0;         // MPG input method One Phase
    MPG_DIFF_TWO_PHASE_1X               = $1;         // MPG input method TwoPhase1
    MPG_DIFF_TWO_PHASE_2X               = $2;         // MPG input method TwoPhase2
    MPG_DIFF_TWO_PHASE_4X               = $3;         // MPG input method TwoPhase4
    MPG_LEVEL_ONE_PHASE                 = $4;         // MPG input method Level One Phase
    MPG_LEVEL_TWO_PHASE_1X              = $5;         // MPG input method Level Two Phase1
    MPG_LEVEL_TWO_PHASE_2X              = $6;         // MPG input method Level Two Phase2
    MPG_LEVEL_TWO_PHASE_4X              = $7;         // MPG input method Level Two Phase4
    
    { Define Motion Sensor Move Mode    }
    SENSOR_METHOD1                      = $0;         // General drive
    SENSOR_METHOD2                      = $1;         // Slow speed drive before sensor signal detection. General drive after signal detection
    SENSOR_METHOD3                      = $2;         // Slow speed drive
    
    { Define Motion CRC Use Method      }
    CRC_SELECT1                         = $0;         // No use of position clear, no use of remaining pulse clear
    CRC_SELECT2                         = $1;         // Use of position clear, no use of remaining pulse clear 
    CRC_SELECT3                         = $2;         // No use of position clear, use of remaining pulse clear
    CRC_SELECT4                         = $3;         // Use of position clear, use of remaining pulse clear 
    
    { Define Motion Detect Signal Type  }
    PElmNegativeEdge                    = $0;         // +Elm(End limit) falling edge
    NElmNegativeEdge                    = $1;         // -Elm(End limit) falling edge
    PSlmNegativeEdge                    = $2;         // +Slm(Slowdown limit) falling edge - Not-used
    NSlmNegativeEdge                    = $3;         // -Slm(Slowdown limit) falling edge - Not-used
    In0DownEdge                         = $4;         // IN0(ORG) falling edge
    In1DownEdge                         = $5;         // IN1(Z phase) falling edge
    In2DownEdge                         = $6;         // IN2(universal) falling edge
    In3DownEdge                         = $7;         // IN3(universal) falling edge
    PElmPositiveEdge                    = $8;         // +Elm(End limit) rising edge
    NElmPositiveEdge                    = $9;         // -Elm(End limit) rising edge
    PSlmPositiveEdge                    = $a;         // +Slm(Slowdown limit) rising edge - Not-used
    NSlmPositiveEdge                    = $b;         // -Slm(Slowdown limit) rising edge - Not-used
    In0UpEdge                           = $c;         // IN0(ORG) rising edge
    In1UpEdge                           = $d;         // IN1(Z phase) rising edge
    In2UpEdge                           = $e;         // IN2(universal) rising edge
    In3UpEdge                           = $f;         // IN3(universal) rising edge
    
    { Define Motion IP(2V03) End Status }             // When 0x0000 after normal drive end.
    IPEND_STATUS_SLM                    = $0001;      // Bit 0, exit by limit decelerate stop signal input
    IPEND_STATUS_ELM                    = $0002;      // Bit 1, exit by limit emergency stop signal input
    IPEND_STATUS_SSTOP_SIGNAL           = $0004;      // Bit 2, exit by decelerate stop signal input
    IPEND_STATUS_ESTOP_SIGANL           = $0008;      // Bit 3, exit by emergency stop signal input
    IPEND_STATUS_SSTOP_COMMAND          = $0010;      // Bit 4, exit by decelerate stop command
    IPEND_STATUS_ESTOP_COMMAND          = $0020;      // Bit 5, exit by emergency stop command
    IPEND_STATUS_ALARM_SIGNAL           = $0040;      // Bit 6, exit by Alarm signal input
    IPEND_STATUS_DATA_ERROR             = $0080;      // Bit 7, exit by data setting error
    IPEND_STATUS_DEVIATION_ERROR        = $0100;      // Bit 8, exit by deviation error
    IPEND_STATUS_ORIGIN_DETECT          = $0200;      // Bit 9, exit by home search
    IPEND_STATUS_SIGNAL_DETECT          = $0400;      // Bit 10, exit by signal search(Signal search-1/2 drive exit)
    IPEND_STATUS_PRESET_PULSE_DRIVE     = $0800;      // Bit 11, Preset pulse drive exit
    IPEND_STATUS_SENSOR_PULSE_DRIVE     = $1000;      // Bit 12, Sensor pulse drive exit
    IPEND_STATUS_LIMIT                  = $2000;      // Bit 13, exit by Limit complete stop
    IPEND_STATUS_SOFTLIMIT              = $4000;      // Bit 14, exit by Soft limit
    IPEND_STATUS_INTERPOLATION_DRIVE    = $8000;      // Bit 15, Interpolation drive exit
    
    { Define Motion IP(2V03)Drive Status}
    IPDRIVE_STATUS_BUSY                 = $00001;     // Bit 0, BUSY (in DRIVE)
    IPDRIVE_STATUS_DOWN                 = $00002;     // Bit 1, DOWN(in deceleration DRIVE)
    IPDRIVE_STATUS_CONST                = $00004;     // Bit 2, CONST(in constant speed DRIVE)
    IPDRIVE_STATUS_UP                   = $00008;     // Bit 3, UP(in acceleration DRIVE)
    IPDRIVE_STATUS_ICL                  = $00010;     // Bit 4, ICL(ICM < INCNT)
    IPDRIVE_STATUS_ICG                  = $00020;     // Bit 5, ICG(ICM < INCNT)
    IPDRIVE_STATUS_ECL                  = $00040;     // Bit 6, ECL(ECM > EXCNT)
    IPDRIVE_STATUS_ECG                  = $00080;     // Bit 7, ECG(ECM < EXCNT)
    IPDRIVE_STATUS_DRIVE_DIRECTION      = $00100;     // Bit 8, drive direction signal (0=CW/1=CCW)
    IPDRIVE_STATUS_COMMAND_BUSY         = $00200;     // Bit 9, In execution of command
    IPDRIVE_STATUS_PRESET_DRIVING       = $00400;     // Bit 10, In drive of a specific pulse number
    IPDRIVE_STATUS_CONTINUOUS_DRIVING   = $00800;     // Bit 11, In continuous drive
    IPDRIVE_STATUS_SIGNAL_SEARCH_DRIVING= $01000;     // Bit 12, In signal search drive
    IPDRIVE_STATUS_ORG_SEARCH_DRIVING   = $02000;     // Bit 13, In home search drive
    IPDRIVE_STATUS_MPG_DRIVING          = $04000;     // Bit 14, In MPG drive
    IPDRIVE_STATUS_SENSOR_DRIVING       = $08000;     // Bit 15, In sensor position drive
    IPDRIVE_STATUS_L_C_INTERPOLATION    = $10000;     // Bit 16, In straight/circular interpolation drive
    IPDRIVE_STATUS_PATTERN_INTERPOLATION= $20000;     // Bit 17, In pattern interpolation drive
    IPDRIVE_STATUS_INTERRUPT_BANK1      = $40000;     // Bit 18, Interrupt occurrence in BANK1
    IPDRIVE_STATUS_INTERRUPT_BANK2      = $80000;     // Bit 19, Interrupt occurrence in BANK2
    
    { Define Motion IP(2V03)Int MASK1   }
    IPINTBANK1_DONTUSE                  = $00000000;  // INTERRUT DISABLED.
    IPINTBANK1_DRIVE_END                = $00000001;  // Bit 0, Drive end(default value : 1).
    IPINTBANK1_ICG                      = $00000002;  // Bit 1, INCNT is greater than INCNTCMP.
    IPINTBANK1_ICE                      = $00000004;  // Bit 2, INCNT is equal with INCNTCMP.
    IPINTBANK1_ICL                      = $00000008;  // Bit 3, INCNT is less than INCNTCMP.
    IPINTBANK1_ECG                      = $00000010;  // Bit 4, EXCNT is greater than EXCNTCMP.
    IPINTBANK1_ECE                      = $00000020;  // Bit 5, EXCNT is equal with EXCNTCMP.
    IPINTBANK1_ECL                      = $00000040;  // Bit 6, EXCNT is less than EXCNTCMP.
    IPINTBANK1_SCRQEMPTY                = $00000080;  // Bit 7, Script control queue is empty.
    IPINTBANK1_CAPRQEMPTY               = $00000100;  // Bit 8, Caption result data queue is empty.
    IPINTBANK1_SCRREG1EXE               = $00000200;  // Bit 9, Script control register-1 command is executed.
    IPINTBANK1_SCRREG2EXE               = $00000400;  // Bit 10, Script control register-2 command is executed.
    IPINTBANK1_SCRREG3EXE               = $00000800;  // Bit 11, Script control register-3 command is executed.
    IPINTBANK1_CAPREG1EXE               = $00001000;  // Bit 12, Caption control register-1 command is executed.
    IPINTBANK1_CAPREG2EXE               = $00002000;  // Bit 13, Caption control register-2 command is executed.
    IPINTBANK1_CAPREG3EXE               = $00004000;  // Bit 14, Caption control register-3 command is executed.
    IPINTBANK1_INTGGENCMD               = $00008000;  // Bit 15, Interrupt generation command is executed(0xFF)
    IPINTBANK1_DOWN                     = $00010000;  // Bit 16, At starting point for deceleration drive.
    IPINTBANK1_CONT                     = $00020000;  // Bit 17, At starting point for constant speed drive.
    IPINTBANK1_UP                       = $00040000;  // Bit 18, At starting point for acceleration drive.
    IPINTBANK1_SIGNALDETECTED           = $00080000;  // Bit 19, Signal assigned in MODE1 is detected.
    IPINTBANK1_SP23E                    = $00100000;  // Bit 20, Current speed is equal with rate change point RCP23.
    IPINTBANK1_SP12E                    = $00200000;  // Bit 21, Current speed is equal with rate change point RCP12.
    IPINTBANK1_SPE                      = $00400000;  // Bit 22, Current speed is equal with speed comparison data(SPDCMP).
    IPINTBANK1_INCEICM                  = $00800000;  // Bit 23, INTCNT(1'st counter) is equal with ICM(1'st count minus limit data)
    IPINTBANK1_SCRQEXE                  = $01000000;  // Bit 24, Script queue command is executed When SCRCONQ's 30 bit is '1'.
    IPINTBANK1_CAPQEXE                  = $02000000;  // Bit 25, Caption queue command is executed When CAPCONQ's 30 bit is '1'.
    IPINTBANK1_SLM                      = $04000000;  // Bit 26, NSLM/PSLM input signal is activated.
    IPINTBANK1_ELM                      = $08000000;  // Bit 27, NELM/PELM input signal is activated.
    IPINTBANK1_USERDEFINE1              = $10000000;  // Bit 28, Selectable interrupt source 0(refer "0xFE" command).
    IPINTBANK1_USERDEFINE2              = $20000000;  // Bit 29, Selectable interrupt source 1(refer "0xFE" command).
    IPINTBANK1_USERDEFINE3              = $40000000;  // Bit 30, Selectable interrupt source 2(refer "0xFE" command).
    IPINTBANK1_USERDEFINE4              = $80000000;  // Bit 31, Selectable interrupt source 3(refer "0xFE" command).
    
    { Define Motion IP(2V03)Int MASK2   }    
    IPINTBANK2_DONTUSE                  = $00000000;  // INTERRUT DISABLED.
    IPINTBANK2_L_C_INP_Q_EMPTY          = $00000001;  // Bit 0, Linear/Circular interpolation parameter queue is empty.
    IPINTBANK2_P_INP_Q_EMPTY            = $00000002;  // Bit 1, Bit pattern interpolation queue is empty.
    IPINTBANK2_ALARM_ERROR              = $00000004;  // Bit 2, Alarm input signal is activated.
    IPINTBANK2_INPOSITION               = $00000008;  // Bit 3, Inposition input signal is activated.
    IPINTBANK2_MARK_SIGNAL_HIGH         = $00000010;  // Bit 4, Mark input signal is activated.
    IPINTBANK2_SSTOP_SIGNAL             = $00000020;  // Bit 5, SSTOP input signal is activated.
    IPINTBANK2_ESTOP_SIGNAL             = $00000040;  // Bit 6, ESTOP input signal is activated.
    IPINTBANK2_SYNC_ACTIVATED           = $00000080;  // Bit 7, SYNC input signal is activated.
    IPINTBANK2_TRIGGER_ENABLE           = $00000100;  // Bit 8, Trigger output is activated.
    IPINTBANK2_EXCNTCLR                 = $00000200;  // Bit 9, External(2'nd) counter is cleard by EXCNTCLR setting.
    IPINTBANK2_FSTCOMPARE_RESULT_BIT0   = $00000400;  // Bit 10, ALU1's compare result bit 0 is activated.
    IPINTBANK2_FSTCOMPARE_RESULT_BIT1   = $00000800;  // Bit 11, ALU1's compare result bit 1 is activated.
    IPINTBANK2_FSTCOMPARE_RESULT_BIT2   = $00001000;  // Bit 12, ALU1's compare result bit 2 is activated.
    IPINTBANK2_FSTCOMPARE_RESULT_BIT3   = $00002000;  // Bit 13, ALU1's compare result bit 3 is activated.
    IPINTBANK2_FSTCOMPARE_RESULT_BIT4   = $00004000;  // Bit 14, ALU1's compare result bit 4 is activated.
    IPINTBANK2_SNDCOMPARE_RESULT_BIT0   = $00008000;  // Bit 15, ALU2's compare result bit 0 is activated.
    IPINTBANK2_SNDCOMPARE_RESULT_BIT1   = $00010000;  // Bit 16, ALU2's compare result bit 1 is activated.
    IPINTBANK2_SNDCOMPARE_RESULT_BIT2   = $00020000;  // Bit 17, ALU2's compare result bit 2 is activated.
    IPINTBANK2_SNDCOMPARE_RESULT_BIT3   = $00040000;  // Bit 18, ALU2's compare result bit 3 is activated.
    IPINTBANK2_SNDCOMPARE_RESULT_BIT4   = $00080000;  // Bit 19, ALU2's compare result bit 4 is activated.
    IPINTBANK2_L_C_INP_Q_LESS_4         = $00100000;  // Bit 20, Linear/Circular interpolation parameter queue is less than 4.
    IPINTBANK2_P_INP_Q_LESS_4           = $00200000;  // Bit 21, Pattern interpolation parameter queue is less than 4.
    IPINTBANK2_XSYNC_ACTIVATED          = $00400000;  // Bit 22, X axis sync input signal is activated.
    IPINTBANK2_YSYNC_ACTIVATED          = $00800000;  // Bit 23, Y axis sync input siangl is activated.
    IPINTBANK2_P_INP_END_BY_END_PATTERN = $01000000;  // Bit 24, Bit pattern interpolation is terminated by end pattern.
    //IPINTBANK2_                       = 0x02000000, // Bit 25, Don't care.
    //IPINTBANK2_                       = 0x04000000, // Bit 26, Don't care.
    //IPINTBANK2_                       = 0x08000000, // Bit 27, Don't care.
    //IPINTBANK2_                       = 0x10000000, // Bit 28, Don't care.
    //IPINTBANK2_                       = 0x20000000, // Bit 29, Don't care.
    //IPINTBANK2_                       = 0x40000000, // Bit 30, Don't care.
    //IPINTBANK2_                       = 0x80000000  // Bit 31, Don't care.
    
    { Define Motion IP(2V03)Drive Status}
    IPMECHANICAL_PELM_LEVEL             = $0001;      // Bit 0, +Limit emergency stop signal input Level
    IPMECHANICAL_NELM_LEVEL             = $0002;      // Bit 1, -Limit emergency stop signal input Level
    IPMECHANICAL_PSLM_LEVEL             = $0004;      // Bit 2, +limit decelerate stop signal input Level
    IPMECHANICAL_NSLM_LEVEL             = $0008;      // Bit 3, -limit decelerate stop signal input Level
    IPMECHANICAL_ALARM_LEVEL            = $0010;      // Bit 4, Alarm signal input Level
    IPMECHANICAL_INP_LEVEL              = $0020;      // Bit 5, InPos signal input Level
    IPMECHANICAL_ENC_DOWN_LEVEL         = $0040;      // Bit 6, encoder DOWN(B phase) signal input Level
    IPMECHANICAL_ENC_UP_LEVEL           = $0080;      // Bit 7, encoder UP(A phase) signal input Level
    IPMECHANICAL_EXMP_LEVEL             = $0100;      // Bit 8, EXMP signal input Level
    IPMECHANICAL_EXPP_LEVEL             = $0200;      // Bit 9, EXPP signal input Level
    IPMECHANICAL_MARK_LEVEL             = $0400;      // Bit 10, MARK# signal input Level
    IPMECHANICAL_SSTOP_LEVEL            = $0800;      // Bit 11, SSTOP signal input Level
    IPMECHANICAL_ESTOP_LEVEL            = $1000;      // Bit 12, ESTOP signal input Level
    IPMECHANICAL_SYNC_LEVEL             = $2000;      // Bit 13, SYNC signal input Level
    IPMECHANICAL_MODE8_16_LEVEL         = $4000;      // Bit 14, MODE8_16 signal input Level
    
    { Define Motion QI Detect Signal    }
    Signal_PosEndLimit                  = $0;         // +Elm(End limit) + direction limit sensor signal
    Signal_NegEndLimit                  = $1;         // -Elm(End limit) - direction limit sensor signal
    Signal_PosSloLimit                  = $2;         // +Slm(Slow Down limit) signal - Not-used
    Signal_NegSloLimit                  = $3;         // -Slm(Slow Down limit) signal - Not-used
    Signal_HomeSensor                   = $4;         // IN0(ORG)  home sensor signal
    Signal_EncodZPhase                  = $5;         // IN1(Z phase)  Encoder Z phase signal
    Signal_UniInput02                   = $6;         // IN2(universal) universal input number 2 signal
    Signal_UniInput03                   = $7;         // IN3(universal) universal input number 3 signal
    
    { Define Motion QI Drive status     }
    QIMECHANICAL_PELM_LEVEL             = $00001;     // Bit 0, +Limit emergency stop signal current state
    QIMECHANICAL_NELM_LEVEL             = $00002;     // Bit 1, -Limit emergency stop signal current state
    QIMECHANICAL_PSLM_LEVEL             = $00004;     // Bit 2, +limit decelerate stop signal current state
    QIMECHANICAL_NSLM_LEVEL             = $00008;     // Bit 3, -limit decelerate stop signal current state
    QIMECHANICAL_ALARM_LEVEL            = $00010;     // Bit 4, Alarm signal current state
    QIMECHANICAL_INP_LEVEL              = $00020;     // Bit 5, InPos signal current state
    QIMECHANICAL_ESTOP_LEVEL            = $00040;     // Bit 6, emergency stop signal(ESTOP) current state
    QIMECHANICAL_ORG_LEVEL              = $00080;     // Bit 7, home signal current state
    QIMECHANICAL_ZPHASE_LEVEL           = $00100;     // Bit 8, Z phase input signal current state
    QIMECHANICAL_ECUP_LEVEL             = $00200;     // Bit 9, ECUP terminal signal state
    QIMECHANICAL_ECDN_LEVEL             = $00400;     // Bit 10, ECDN terminal signal state
    QIMECHANICAL_EXPP_LEVEL             = $00800;     // Bit 11, EXPP terminal signal state
    QIMECHANICAL_EXMP_LEVEL             = $01000;     // Bit 12, EXMP terminal signal state
    QIMECHANICAL_SQSTR1_LEVEL           = $02000;     // Bit 13, SQSTR1 terminal signal state
    QIMECHANICAL_SQSTR2_LEVEL           = $04000;     // Bit 14, SQSTR2 terminal signal state
    QIMECHANICAL_SQSTP1_LEVEL           = $08000;     // Bit 15, SQSTP1 terminal signal state
    QIMECHANICAL_SQSTP2_LEVEL           = $10000;     // Bit 16, SQSTP2 terminal signal state
    QIMECHANICAL_MODE_LEVEL             = $20000;     // Bit 17, MODE terminal signal state
    
    { Define Motion QI End Status       }             // When 0x0000 after normal drive end.
    QIEND_STATUS_0                      = $00000001;  // Bit 0, exit by forward direction limit signal (PELM)
    QIEND_STATUS_1                      = $00000002;  // Bit 1, exit by reverse direction limit signal (NELM)
    QIEND_STATUS_2                      = $00000004;  // Bit 2, exit by forward direction additional limit signal (PSLM)
    QIEND_STATUS_3                      = $00000008;  // Bit 3, exit by reverse direction additional limit signal (NSLM)
    QIEND_STATUS_4                      = $00000010;  // Bit 4, exit by forward direction soft limit emergency stop function
    QIEND_STATUS_5                      = $00000020;  // Bit 5, exit by reverse direction soft limit emergency stop function
    QIEND_STATUS_6                      = $00000040;  // Bit 6, exit by forward direction soft limit decelerate stop function
    QIEND_STATUS_7                      = $00000080;  // Bit 7, exit by reverse direction soft limit decelerate stop function
    QIEND_STATUS_8                      = $00000100;  // Bit 8, drive exit by servo alarm function
    QIEND_STATUS_9                      = $00000200;  // Bit 9, drive exit by emergency stop signal input
    QIEND_STATUS_10                     = $00000400;  // Bit 10, drive exit by emergency stop command
    QIEND_STATUS_11                     = $00000800;  // Bit 11, drive exit by decelerate stop command
    QIEND_STATUS_12                     = $00001000;  // Bit 12, drive exit by entire axes emergency stop command
    QIEND_STATUS_13                     = $00002000;  // Bit 13, drive exit by sync stop function #1(SQSTP1)
    QIEND_STATUS_14                     = $00004000;  // Bit 14, drive exit by sync stop function #2(SQSTP2)
    QIEND_STATUS_15                     = $00008000;  // Bit 15, encoder input (ECUP,ECDN) error occurrence
    QIEND_STATUS_16                     = $00010000;  // Bit 16, MPG input (EXPP,EXMP) error occurrence
    QIEND_STATUS_17                     = $00020000;  // Bit 17, exit with successful home search
    QIEND_STATUS_18                     = $00040000;  // Bit 18, exit with successful signal search
    QIEND_STATUS_19                     = $00080000;  // Bit 19, drive exit by interpolation data abnormality
    QIEND_STATUS_20                     = $00100000;  // Bit 20, abnormal drive stop occurrence
    QIEND_STATUS_21                     = $00200000;  // Bit 21, MPG function block pulse buffer overflow occurrence
    QIEND_STATUS_22                     = $00400000;  // Bit 22, DON'CARE
    QIEND_STATUS_23                     = $00800000;  // Bit 23, DON'CARE
    QIEND_STATUS_24                     = $01000000;  // Bit 24, DON'CARE
    QIEND_STATUS_25                     = $02000000;  // Bit 25, DON'CARE
    QIEND_STATUS_26                     = $04000000;  // Bit 26, DON'CARE
    QIEND_STATUS_27                     = $08000000;  // Bit 27, DON'CARE
    QIEND_STATUS_28                     = $10000000;  // Bit 28, current/last move drive direction
    QIEND_STATUS_29                     = $20000000;  // Bit 29, in output of remaining pulse clear
    QIEND_STATUS_30                     = $40000000;  // Bit 30, abnormal drive stop cause state
    QIEND_STATUS_31                     = $80000000;  // Bit 31, interpolation drive data error state
    
    { Define Motion QI Drive Status     }
    QIDRIVE_STATUS_0                    = $0000001;   // Bit 0, BUSY(in drive move)
    QIDRIVE_STATUS_1                    = $0000002;   // Bit 1, DOWN(in deceleration)
    QIDRIVE_STATUS_2                    = $0000004;   // Bit 2, CONST(in constant speed)
    QIDRIVE_STATUS_3                    = $0000008;   // Bit 3, UP(in acceleration)
    QIDRIVE_STATUS_4                    = $0000010;   // Bit 4, in move of continuous drive
    QIDRIVE_STATUS_5                    = $0000020;   // Bit 5, in move of assigned distance drive
    QIDRIVE_STATUS_6                    = $0000040;   // Bit 6, in move of MPG drive
    QIDRIVE_STATUS_7                    = $0000080;   // Bit 7, in move of home search drive
    QIDRIVE_STATUS_8                    = $0000100;   // Bit 8, in move of signal search drive
    QIDRIVE_STATUS_9                    = $0000200;   // Bit 9, in move of interpolation drive
    QIDRIVE_STATUS_10                   = $0000400;   // Bit 10, in move of Slave drive
    QIDRIVE_STATUS_11                   = $0000800;   // Bit 11, current move drive direction (different indication information in interpolation drive)
    QIDRIVE_STATUS_12                   = $0001000;   // Bit 12, in waiting for servo position completion after pulse output
    QIDRIVE_STATUS_13                   = $0002000;   // Bit 13, in move of straight line interpolation drive
    QIDRIVE_STATUS_14                   = $0004000;   // Bit 14, in move of circular interpolation drive
    QIDRIVE_STATUS_15                   = $0008000;   // Bit 15, in pulse output
    QIDRIVE_STATUS_16                   = $0010000;   // Bit 16, drive reserved data number(start)(0-7)
    QIDRIVE_STATUS_17                   = $0020000;   // Bit 17, drive reserved data number (middle)(0-7)
    QIDRIVE_STATUS_18                   = $0040000;   // Bit 18, drive reserved data number (end)(0-7)
    QIDRIVE_STATUS_19                   = $0080000;   // Bit 19, drive reversed Queue is cleared
    QIDRIVE_STATUS_20                   = $0100000;   // Bit 20, drive reversed Queue is full
    QIDRIVE_STATUS_21                   = $0200000;   // Bit 21, velocity mode of current move drive (start)
    QIDRIVE_STATUS_22                   = $0400000;   // Bit 22, velocity mode of current move drive (end)
    QIDRIVE_STATUS_23                   = $0800000;   // Bit 23, MPG Buffer #1 Full
    QIDRIVE_STATUS_24                   = $1000000;   // Bit 24, MPG Buffer #2 Full
    QIDRIVE_STATUS_25                   = $2000000;   // Bit 25, MPG Buffer #3 Full
    QIDRIVE_STATUS_26                   = $4000000;   // Bit 26, MPG Buffer Data OverFlow
    
    { Define Motion QI Interrupt MASK1  }
    QIINTBANK1_DISABLE                  = $00000000;  // INTERRUT DISABLED.
    QIINTBANK1_0                        = $00000001;  // Bit 0,  when drive set interrupt occurrence use is exit
    QIINTBANK1_1                        = $00000002;  // Bit 1,  when drive is exited
    QIINTBANK1_2                        = $00000004;  // Bit 2,  when drive is started
    QIINTBANK1_3                        = $00000008;  // Bit 3,  counter #1 < comparator #1 event occurrence
    QIINTBANK1_4                        = $00000010;  // Bit 4,  counter #1 = comparator #1 event occurrence
    QIINTBANK1_5                        = $00000020;  // Bit 5,  counter #1 > comparator #1 event occurrence
    QIINTBANK1_6                        = $00000040;  // Bit 6,  counter #2 < comparator #2 event occurrence
    QIINTBANK1_7                        = $00000080;  // Bit 7,  counter #2 = comparator #2 event occurrence
    QIINTBANK1_8                        = $00000100;  // Bit 8,  counter #2 > comparator #2 event occurrence
    QIINTBANK1_9                        = $00000200;  // Bit 9,  counter #3 < comparator #3 event occurrence
    QIINTBANK1_10                       = $00000400;  // Bit 10, counter #3 = comparator #3 event occurrence
    QIINTBANK1_11                       = $00000800;  // Bit 11, counter #3 > comparator #3 event occurrence
    QIINTBANK1_12                       = $00001000;  // Bit 12, counter #4 < comparator #4 event occurrence
    QIINTBANK1_13                       = $00002000;  // Bit 13, counter #4 = comparator #4 event occurrence
    QIINTBANK1_14                       = $00004000;  // Bit 14, counter #4 < comparator #4 event occurrence
    QIINTBANK1_15                       = $00008000;  // Bit 15, counter #5 < comparator #5 event occurrence
    QIINTBANK1_16                       = $00010000;  // Bit 16, counter #5 = comparator #5 event occurrence
    QIINTBANK1_17                       = $00020000;  // Bit 17, counter #5 > comparator #5 event occurrence
    QIINTBANK1_18                       = $00040000;  // Bit 18, timer #1 event occurrence
    QIINTBANK1_19                       = $00080000;  // Bit 19, timer #2 event occurrence
    QIINTBANK1_20                       = $00100000;  // Bit 20, drive reservation setting Queue is cleared
    QIINTBANK1_21                       = $00200000;  // Bit 21, drive reservation setting Queue is full
    QIINTBANK1_22                       = $00400000;  // Bit 22, trigger occurring distance period/absolute position Queue is cleared
    QIINTBANK1_23                       = $00800000;  // Bit 23, trigger occurring distance period/absolute position Queue is full
    QIINTBANK1_24                       = $01000000;  // Bit 24, trigger signal occurrence event
    QIINTBANK1_25                       = $02000000;  // Bit 25, script #1 command reservation setting Queue is cleared
    QIINTBANK1_26                       = $04000000;  // Bit 26, script #2 command reservation setting Queue is cleared
    QIINTBANK1_27                       = $08000000;  // Bit 27, script #3 initialized with execution of command reservation setting register
    QIINTBANK1_28                       = $10000000;  // Bit 28, script #4 initialized with execution of command reservation setting register
    QIINTBANK1_29                       = $20000000;  // Bit 29, servo alarm signal is permitted
    QIINTBANK1_30                       = $40000000;  // Bit 30, |CNT1| - |CNT2| >= |CNT4| event occurrence
    QIINTBANK1_31                       = $80000000;  // Bit 31, interrupt occurrence command |INTGEN| execution
    
    { Define Motion QI Interrupt MASK2  }
    QIINTBANK2_DISABLE                  = $00000000;  // INTERRUT DISABLED.
    QIINTBANK2_0                        = $00000001;  // Bit 0,  script #1 reading command result Queue is full
    QIINTBANK2_1                        = $00000002;  // Bit 1,  script #2 reading command result Queue is full
    QIINTBANK2_2                        = $00000004;  // Bit 2,  script #3 reading command result register is renewed with new data
    QIINTBANK2_3                        = $00000008;  // Bit 3,  script #4 reading command result register is renewed with new data
    QIINTBANK2_4                        = $00000010;  // Bit 4,  when reservation command of script #1 is executed, command set by interrupt occurrence is executed
    QIINTBANK2_5                        = $00000020;  // Bit 5,  when reservation command of script #2 is executed, command set by interrupt occurrence is executed
    QIINTBANK2_6                        = $00000040;  // Bit 6,  when reservation command of script #3 is executed, command set by interrupt occurrence is executed
    QIINTBANK2_7                        = $00000080;  // Bit 7,  when reservation command of script #4 is executed, command set by interrupt occurrence is executed
    QIINTBANK2_8                        = $00000100;  // Bit 8,  start drive
    QIINTBANK2_9                        = $00000200;  // Bit 9,  drive using servo position determination completion(InPos) function, exit condition occurrence
    QIINTBANK2_10                       = $00000400;  // Bit 10, event selection #1 condition occurrence to use during event counter operation
    QIINTBANK2_11                       = $00000800;  // Bit 11, event selection #2 condition occurrence to use during event counter operation
    QIINTBANK2_12                       = $00001000;  // Bit 12, SQSTR1 signal is permitted
    QIINTBANK2_13                       = $00002000;  // Bit 13, SQSTR2 signal is permitted
    QIINTBANK2_14                       = $00004000;  // Bit 14, UIO0 terminal signal is changed to '1'
    QIINTBANK2_15                       = $00008000;  // Bit 15, UIO1 terminal signal is changed to '1'
    QIINTBANK2_16                       = $00010000;  // Bit 16, UIO2 terminal signal is changed to '1'
    QIINTBANK2_17                       = $00020000;  // Bit 17, UIO3 terminal signal is changed to '1'
    QIINTBANK2_18                       = $00040000;  // Bit 18, UIO4 terminal signal is changed to '1'
    QIINTBANK2_19                       = $00080000;  // Bit 19, UIO5 terminal signal is changed to '1'
    QIINTBANK2_20                       = $00100000;  // Bit 20, UIO6 terminal signal is changed to '1'
    QIINTBANK2_21                       = $00200000;  // Bit 21, UIO7 terminal signal is changed to '1'
    QIINTBANK2_22                       = $00400000;  // Bit 22, UIO8 terminal signal is changed to '1'
    QIINTBANK2_23                       = $00800000;  // Bit 23, UIO9 terminal signal is changed to '1'
    QIINTBANK2_24                       = $01000000;  // Bit 24, UIO10 terminal signal is changed to '1'
    QIINTBANK2_25                       = $02000000;  // Bit 25, UIO11 terminal signal is changed to '1'
    QIINTBANK2_26                       = $04000000;  // Bit 26, error stop condition (LMT, ESTOP, STOP, ESTOP, CMD, ALARM) occurrence
    QIINTBANK2_27                       = $08000000;  // Bit 27, data setting error is occurred during interpolation
    QIINTBANK2_28                       = $10000000;  // Bit 28, Don't Care
    QIINTBANK2_29                       = $20000000;  // Bit 29, limit signal (PELM, NELM) is inputted
    QIINTBANK2_30                       = $40000000;  // Bit 30, additional limit signal (PSLM, NSLM) is inputted
    QIINTBANK2_31                       = $80000000;  // Bit 31, emengency stop signal (ESTOP) is input
    
    { RTEX Network status define        }
    NET_STATUS_DISCONNECTED             = 1;
    NET_STATUS_LOCK_MISMATCH            = 5;
    NET_STATUS_CONNECTED                = 6;

    { (QI) Override position condition  }   
    OVERRIDE_POS_START                  = 0;
    OVERRIDE_POS_END                    = 1;

    { (QI) Profile priority             }   
    PRIORITY_VELOCITY                   = 0;
    PRIORITY_ACCELTIME                  = 1;

    { Function return type define       }
    FUNC_RETURN_IMMEDIATE               = 0;
    FUNC_RETURN_BLOCKING                = 1;
    FUNC_RETURN_NON_BLOCKING            = 2;

    { Max alarm history count           }
    MAX_SERVO_ALARM_HISTORY             = 15;
    
    F_50M_CLK                           = 50000000;
    
    {CNTPORT_DATA_WRITE}
    CnCommand                          = $10;
    CnData1                            = $12;
    CnData2	                           = $14;
    CnData3                            = $16;
    CnData4                            = $18;
    CnData12                           = $44;
    CnData34                           = $46;
    {CNTRAM_DATA}
    CnRamAddr1                         = $28;
    CnRamAddr2                         = $2A;
    CnRamAddr3                         = $2C;
    CnRamAddrx1                        = $48;
    CnRamAddr23                        = $4A;
    {PHASE_SEL}
    CnAbPhase                          = 0;
    CnZPhase                           = 1;
    {COUNTER_INPUT}
    CnUpDownMode                       = 0;    // Up/Down
    CnSqr1Mode                         = 1;    // 1
    CnSqr2Mode                         = 2;    // 2
    CnSqr4Mode                         = 3;    // 4
    {CNTCOMMAND}
    CnCh1CounterRead				   = $10;				// CH1 COUNTER READ, 24BIT
    CnCh1CounterWrite				   = $90;				// CH1 COUNTER WRITE
    CnCh1CounterModeRead			   = $11;				// CH1 COUNTER MODE READ, 8BIT
    CnCh1CounterModeWrite			   = $91;				// CH1 COUNTER MODE WRITE
    CnCh1TriggerRegionLowerDataRead	   = $12;				// CH1 TRIGGER REGION LOWER DATA READ, 24BIT
    CnCh1TriggerRegionLowerDataWrite   = $92;				// CH1 TRIGGER REGION LOWER DATA WRITE
    CnCh1TriggerRegionUpperDataRead	   = $13;				// CH1 TRIGGER REGION UPPER DATA READ, 24BIT
    CnCh1TriggerRegionUpperDataWrite   = $93;				// CH1 TRIGGER REGION UPPER DATA WRITE
    CnCh1TriggerPeriodRead			   = $14;				// CH1 TRIGGER PERIOD READ, 24BIT, RESERVED
    CnCh1TriggerPeriodWrite			   = $94;				// CH1 TRIGGER PERIOD WRITE
    CnCh1TriggerPulseWidthRead		   = $15;				// CH1 TRIGGER PULSE WIDTH READ
    CnCh1TriggerPulseWidthWrite		   = $95;				// CH1 RIGGER PULSE WIDTH WRITE
    CnCh1TriggerModeRead			   = $16;			// CH1 TRIGGER MODE READ
    CnCh1TriggerModeWrite			   = $96;				// CH1 RIGGER MODE WRITE
    CnCh1TriggerStatusRead			   = $17;				// CH1 TRIGGER STATUS READ
    CnCh1NoOperation_97				   = $97;				// 
    CnCh1TriggerEnable				   = $98;
    CnCh1TriggerDisable				   = $99;
    CnCh1TimeTriggerFrequencyRead	   = $1A;
    CnCh1TimeTriggerFrequencyWrite	   = $9A;
    CnCh1ComparatorValueRead		   = $1B;
    CnCh1ComparatorValueWrite		   = $9B;
    CnCh1CompareatorConditionRead	   = $1D;
    CnCh1CompareatorConditionWrite	   = $9D;

    // CH-2 Group Register
    CnCh2CounterRead				   = $20;				// CH2 COUNTER READ, 24BIT
    CnCh2CounterWrite				   = $A1;				// CH2 COUNTER WRITE
    CnCh2CounterModeRead			   = $21;				// CH2 COUNTER MODE READ, 8BIT
    CnCh2CounterModeWrite			   = $A1;				// CH2 COUNTER MODE WRITE
    CnCh2TriggerRegionLowerDataRead	   = $22;				// CH2 TRIGGER REGION LOWER DATA READ, 24BIT
    CnCh2TriggerRegionLowerDataWrite   = $A2;				// CH2 TRIGGER REGION LOWER DATA WRITE
    CnCh2TriggerRegionUpperDataRead	   = $23;				// CH2 TRIGGER REGION UPPER DATA READ, 24BIT
    CnCh2TriggerRegionUpperDataWrite   = $A3;				// CH2 TRIGGER REGION UPPER DATA WRITE
    CnCh2TriggerPeriodRead			   = $24;				// CH2 TRIGGER PERIOD READ, 24BIT, RESERVED
    CnCh2TriggerPeriodWrite			   = $A4;				// CH2 TRIGGER PERIOD WRITE
    CnCh2TriggerPulseWidthRead		   = $25;				// CH2 TRIGGER PULSE WIDTH READ, 24BIT
    CnCh2TriggerPulseWidthWrite		   = $A5;				// CH2 RIGGER PULSE WIDTH WRITE
    CnCh2TriggerModeRead			   = $26;				// CH2 TRIGGER MODE READ
    CnCh2TriggerModeWrite			   = $A6;				// CH2 RIGGER MODE WRITE
    CnCh2TriggerStatusRead			   = $27;				// CH2 TRIGGER STATUS READ
    CnCh2NoOperation_A7				   = $A7;
    CnCh2TriggerEnable				   = $A8;
    CnCh2TriggerDisable				   = $A9;
    CnCh2TimeTriggerFrequencyRead	   = $2A;
    CnCh2TimeTriggerFrequencyWrite	   = $AA;
    CnCh2ComparatorValueRead		   = $2B;
    CnCh2ComparatorValueWrite		   = $AB;
    CnCh2CompareatorConditionRead	   = $2D;
    CnCh2CompareatorConditionWrite	   = $AD;

    // Ram Access Group Register
    CnRamDataWithRamAddress			   = $30;				// READ RAM DATA WITH RAM ADDR PORT ADDRESS
    CnRamDataWrite					   = $B0;				// RAM DATA WRITE
    CnRamDataRead					   = $31;				// RAM DATA READ, 32BIT
    
    { HPCPORT DATA WRITE }
    HpcReset          = $06;            // Software reset.
    HpcCommand        = $10;
    HpcData12         = $12;            // MSB of data port(31 ~ 16 bit)
    HpcData34         = $14;            // LSB of data port(15 ~ 0 bit)
    HpcCmStatus       = $1C;
	
	{ HPCPORT CH STATUS }
	HpcCh1Mech        = $20;
    HpcCh1Status      = $22;
    HpcCh2Mech        = $30;
    HpcCh2Status      = $32;
    HpcCh3Mech        = $40;
    HpcCh3Status      = $42;
    HpcCh4Mech        = $50;
    HpcCh4Status      = $52;
	
	{ HPCPORT ETC }
	HpcDiIntFlag      = $60;
    HpcDiIntRiseMask  = $62;
    HpcDiIntFallMask  = $64;
    HpcCompIntFlag    = $66;
    HpcCompIntMask    = $68;
    HpcDinData        = $6A;
    HpcDoutData       = $6C;
	
	{ HPCRAM DATA }
	HpcRamAddr1        = $70;            // MSB of Ram address(31  ~ 16 bit)
    HpcRamAddr2        = $72;            // LSB of Ram address(15  ~ 0 bit)
	
{
--1) count_mode
--  0 bit : reverse.(0: normal, 1:reverse)
--  1 bit : count source selection.(0 : A/B 2 phase signal, 1 :  Z phase signal)
--  2~3 bit : count mode
--      "00" up/Down mode 
--      "01" 2 phase, 1times
--      "10" 2 phase, 2times
--      "11" 2 phase, 4times
}

{
-- Description : Trigger pulse generation block for SIO-CN2CH
-- trig_mode
-- 0 bit : trigger signal active level.
-- 1 bit : reserved.
-- 2 bit : trigger signal output method, valid when trig_mode(1) = '0', (0 : pulse out, 1 : level out)
-- 3 bit : reserved.
-- 5~4 bit : Trigger method
--    "00" : absolute mode[with ram data].
--    "01" : timer mode.
--    "10" : absolute mode[with fifo].
--    "11" : periodic mode.
-- 6 bit : direction valid check enable/disable when periodic mode.
-- 7 bit : direction valid when periodic mode.
}

	{ HPCCOMMAND }
	// CH-1 Group Register
    HpcCh1CounterRead                   = $10;                // CH1 COUNTER READ, 32BIT
    HpcCh1CounterWrite                  = $90;                // CH1 COUNTER WRITE, 32BIT
    HpcCh1CounterModeRead               = $11;                // CH1 COUNTER MODE READ, 4BIT
    HpcCh1CounterModeWrite              = $91;                // CH1 COUNTER MODE WRITE, 4BIT
    HpcCh1TriggerRegionLowerDataRead    = $12;                // CH1 TRIGGER REGION LOWER DATA READ, 31BIT
    HpcCh1TriggerRegionLowerDataWrite   = $92;                // CH1 TRIGGER REGION LOWER DATA WRITE
    HpcCh1TriggerRegionUpperDataRead    = $13;                // CH1 TRIGGER REGION UPPER DATA READ, 31BIT
    HpcCh1TriggerRegionUpperDataWrite   = $93;                // CH1 TRIGGER REGION UPPER DATA WRITE
    HpcCh1TriggerPeriodRead             = $14;                // CH1 TRIGGER PERIOD READ, 31BIT
    HpcCh1TriggerPeriodWrite            = $94;                // CH1 TRIGGER PERIOD WRITE
    HpcCh1TriggerPulseWidthRead         = $15;                // CH1 TRIGGER PULSE WIDTH READ, 31BIT
    HpcCh1TriggerPulseWidthWrite        = $95;                // CH1 RIGGER PULSE WIDTH WRITE
    HpcCh1TriggerModeRead               = $16;                // CH1 TRIGGER MODE READ, 8BIT
    HpcCh1TriggerModeWrite              = $96;                // CH1 RIGGER MODE WRITE
    HpcCh1TriggerStatusRead             = $17;                // CH1 TRIGGER STATUS READ, 8BIT
    HpcCh1NoOperation_97                = $97;                // Reserved.
    HpcCh1NoOperation_18                = $17;                // Reserved.
    HpcCh1TriggerEnable                 = $98;                // CH1 TRIGGER ENABLE.
    HpcCh1NoOperation_19                = $19;                // Reserved.
    HpcCh1TriggerDisable                = $99;                // CH1 TRIGGER DISABLE.
    HpcCh1TimeTriggerFrequencyRead      = $1A;                // CH1 TRIGGER FREQUNCE INFO. WRITE, 28BIT
    HpcCh1TimeTriggerFrequencyWrite     = $9A;                // CH1 TRIGGER FREQUNCE INFO. READ
    HpcCh1Comparator1ValueRead          = $1B;                // CH1 COMPAREATOR1 READ, 31BIT
    HpcCh1Comparator1ValueWrite         = $9B;                // CH1 COMPAREATOR1 WRITE, 31BIT
    HpcCh1Comparator2ValueRead          = $1C;                // CH1 COMPAREATOR2 READ, 31BIT
    HpcCh1Comparator2ValueWrite         = $9C;                // CH1 COMPAREATOR2 WRITE, 31BIT
    HpcCh1CompareatorConditionRead      = $1D;                // CH1 COMPAREATOR CONDITION READ, 4BIT
    HpcCh1CompareatorConditionWrite     = $9D;                // CH1 COMPAREATOR CONDITION WRITE, 4BIT
    HpcCh1AbsTriggerTopPositionRead     = $1E;                // CH1 ABS TRIGGER POSITION READ, 31BIT
    HpcCh1AbsTriggerPositionWrite       = $9E;                // CH1 ABS TRIGGER POSITION WRITE, 31BIT
    HpcCh1AbsTriggerFifoStatusRead      = $1F;                // CH1 ABS TRIGGER POSITION FIFO STATUS READ, 16BIT
    HpcCh1AbsTriggerPositionClear       = $9F;                // CH1 ABS TRIGGER POSITION FIFO CLEAR

    // CH-2 Group Register
    HpcCh2CounterRead                   = $20;                // CH2 COUNTER READ, 32BIT
    HpcCh2CounterWrite                  = $A0;                // CH2 COUNTER WRITE, 32BIT
    HpcCh2CounterModeRead               = $21;                // CH2 COUNTER MODE READ, 4BIT
    HpcCh2CounterModeWrite              = $A1;                // CH2 COUNTER MODE WRITE, 4BIT
    HpcCh2TriggerRegionLowerDataRead    = $22;                // CH2 TRIGGER REGION LOWER DATA READ, 31BIT
    HpcCh2TriggerRegionLowerDataWrite   = $A2;                // CH2 TRIGGER REGION LOWER DATA WRITE
    HpcCh2TriggerRegionUpperDataRead    = $23;                // CH2 TRIGGER REGION UPPER DATA READ, 31BIT
    HpcCh2TriggerRegionUpperDataWrite   = $A3;                // CH2 TRIGGER REGION UPPER DATA WRITE
    HpcCh2TriggerPeriodRead             = $24;                // CH2 TRIGGER PERIOD READ, 31BIT
    HpcCh2TriggerPeriodWrite            = $A4;                // CH2 TRIGGER PERIOD WRITE
    HpcCh2TriggerPulseWidthRead         = $25;                // CH2 TRIGGER PULSE WIDTH READ, 31BIT
    HpcCh2TriggerPulseWidthWrite        = $A5;                // CH2 RIGGER PULSE WIDTH WRITE
    HpcCh2TriggerModeRead               = $26;                // CH2 TRIGGER MODE READ, 8BIT
    HpcCh2TriggerModeWrite              = $A6;                // CH2 RIGGER MODE WRITE
    HpcCh2TriggerStatusRead             = $27;                // CH2 TRIGGER STATUS READ, 8BIT
    HpcCh2NoOperation_97                = $A7;                // Reserved.
    HpcCh2NoOperation_18                = $27;                // Reserved.
    HpcCh2TriggerEnable                 = $A8;                // CH2 TRIGGER ENABLE.
    HpcCh2NoOperation_19                = $29;                // Reserved.
    HpcCh2TriggerDisable                = $A9;                // CH2 TRIGGER DISABLE.
    HpcCh2TimeTriggerFrequencyRead      = $2A;                // CH2 TRIGGER FREQUNCE INFO. WRITE, 28BIT
    HpcCh2TimeTriggerFrequencyWrite     = $AA;                // CH2 TRIGGER FREQUNCE INFO. READ
    HpcCh2Comparator1ValueRead          = $2B;                // CH2 COMPAREATOR1 READ, 31BIT
    HpcCh2Comparator1ValueWrite         = $AB;                // CH2 COMPAREATOR1 WRITE, 31BIT
    HpcCh2Comparator2ValueRead          = $2C;                // CH2 COMPAREATOR2 READ, 31BIT
    HpcCh2Comparator2ValueWrite         = $AC;                // CH2 COMPAREATOR2 WRITE, 31BIT
    HpcCh2CompareatorConditionRead      = $2D;                // CH2 COMPAREATOR CONDITION READ, 4BIT
    HpcCh2CompareatorConditionWrite     = $AD;                // CH2 COMPAREATOR CONDITION WRITE, 4BIT
    HpcCh2AbsTriggerTopPositionRead     = $2E;                // CH2 ABS TRIGGER POSITION READ, 31BIT
    HpcCh2AbsTriggerPositionWrite       = $AE;                // CH2 ABS TRIGGER POSITION WRITE, 31BIT
    HpcCh2AbsTriggerFifoStatusRead      = $2F;                // CH2 ABS TRIGGER POSITION FIFO STATUS READ, 16BIT
    HpcCh2AbsTriggerPositionClear       = $AF;                // CH2 ABS TRIGGER POSITION FIFO CLEAR

    // CH-3 Group Register
    HpcCh3CounterRead                   = $30;                // CH3 COUNTER READ, 32BIT
    HpcCh3CounterWrite                  = $B0;                // CH3 COUNTER WRITE, 32BIT
    HpcCh3CounterModeRead               = $31;                // CH3 COUNTER MODE READ, 4BIT
    HpcCh3CounterModeWrite              = $B1;                // CH3 COUNTER MODE WRITE, 4BIT
    HpcCh3TriggerRegionLowerDataRead    = $32;                // CH3 TRIGGER REGION LOWER DATA READ, 31BIT
    HpcCh3TriggerRegionLowerDataWrite   = $B2;                // CH3 TRIGGER REGION LOWER DATA WRITE
    HpcCh3TriggerRegionUpperDataRead    = $33;                // CH3 TRIGGER REGION UPPER DATA READ, 31BIT
    HpcCh3TriggerRegionUpperDataWrite   = $B3;                // CH3 TRIGGER REGION UPPER DATA WRITE
    HpcCh3TriggerPeriodRead             = $34;                // CH3 TRIGGER PERIOD READ, 31BIT
    HpcCh3TriggerPeriodWrite            = $B4;                // CH3 TRIGGER PERIOD WRITE
    HpcCh3TriggerPulseWidthRead         = $35;                // CH3 TRIGGER PULSE WIDTH READ, 31BIT
    HpcCh3TriggerPulseWidthWrite        = $B5;                // CH3 RIGGER PULSE WIDTH WRITE
    HpcCh3TriggerModeRead               = $36;                // CH3 TRIGGER MODE READ, 8BIT
    HpcCh3TriggerModeWrite              = $B6;                // CH3 RIGGER MODE WRITE
    HpcCh3TriggerStatusRead             = $37;                // CH3 TRIGGER STATUS READ, 8BIT
    HpcCh3NoOperation_97                = $B7;                // Reserved.
    HpcCh3NoOperation_18                = $37;                // Reserved.
    HpcCh3TriggerEnable                 = $B8;                // CH3 TRIGGER ENABLE.
    HpcCh3NoOperation_19                = $39;                // Reserved.
    HpcCh3TriggerDisable                = $B9;                // CH3 TRIGGER DISABLE.
    HpcCh3TimeTriggerFrequencyRead      = $3A;                // CH3 TRIGGER FREQUNCE INFO. WRITE, 28BIT
    HpcCh3TimeTriggerFrequencyWrite     = $BA;                // CH3 TRIGGER FREQUNCE INFO. READ
    HpcCh3Comparator1ValueRead          = $3B;                // CH3 COMPAREATOR1 READ, 31BIT
    HpcCh3Comparator1ValueWrite         = $BB;                // CH3 COMPAREATOR1 WRITE, 31BIT
    HpcCh3Comparator2ValueRead          = $3C;                // CH3 COMPAREATOR2 READ, 31BIT
    HpcCh3Comparator2ValueWrite         = $BC;                // CH3 COMPAREATOR2 WRITE, 31BIT
    HpcCh3CompareatorConditionRead      = $3D;                // CH3 COMPAREATOR CONDITION READ, 4BIT
    HpcCh3CompareatorConditionWrite     = $BD;                // CH3 COMPAREATOR CONDITION WRITE, 4BIT
    HpcCh3AbsTriggerTopPositionRead     = $3E;                // CH3 ABS TRIGGER POSITION READ, 31BIT
    HpcCh3AbsTriggerPositionWrite       = $BE;                // CH3 ABS TRIGGER POSITION WRITE, 31BIT
    HpcCh3AbsTriggerFifoStatusRead      = $3F;                // CH3 ABS TRIGGER POSITION FIFO STATUS READ, 16BIT
    HpcCh3AbsTriggerPositionClear       = $BF;                // CH3 ABS TRIGGER POSITION FIFO CLEAR

    // CH-4 Group Register
    HpcCh4CounterRead                   = $40;                // CH4 COUNTER READ, 32BIT
    HpcCh4CounterWrite                  = $C0;                // CH4 COUNTER WRITE, 32BIT
    HpcCh4CounterModeRead               = $41;                // CH4 COUNTER MODE READ, 4BIT
    HpcCh4CounterModeWrite              = $C1;                // CH4 COUNTER MODE WRITE, 4BIT
    HpcCh4TriggerRegionLowerDataRead    = $42;                // CH4 TRIGGER REGION LOWER DATA READ, 31BIT
    HpcCh4TriggerRegionLowerDataWrite   = $C2;                // CH4 TRIGGER REGION LOWER DATA WRITE
    HpcCh4TriggerRegionUpperDataRead    = $43;                // CH4 TRIGGER REGION UPPER DATA READ, 31BIT
    HpcCh4TriggerRegionUpperDataWrite   = $C3;                // CH4 TRIGGER REGION UPPER DATA WRITE
    HpcCh4TriggerPeriodRead             = $44;                // CH4 TRIGGER PERIOD READ, 31BIT
    HpcCh4TriggerPeriodWrite            = $C4;                // CH4 TRIGGER PERIOD WRITE
    HpcCh4TriggerPulseWidthRead         = $45;                // CH4 TRIGGER PULSE WIDTH READ, 31BIT
    HpcCh4TriggerPulseWidthWrite        = $C5;                // CH4 RIGGER PULSE WIDTH WRITE
    HpcCh4TriggerModeRead               = $46;                // CH4 TRIGGER MODE READ, 8BIT
    HpcCh4TriggerModeWrite              = $C6;                // CH4 RIGGER MODE WRITE
    HpcCh4TriggerStatusRead             = $47;                // CH4 TRIGGER STATUS READ, 8BIT
    HpcCh4NoOperation_97                = $C7;                // Reserved.
    HpcCh4NoOperation_18                = $47;                // Reserved.
    HpcCh4TriggerEnable                 = $C8;                // CH4 TRIGGER ENABLE.
    HpcCh4NoOperation_19                = $49;                // Reserved.
    HpcCh4TriggerDisable                = $C9;                // CH4 TRIGGER DISABLE.
    HpcCh4TimeTriggerFrequencyRead      = $4A;                // CH4 TRIGGER FREQUNCE INFO. WRITE, 28BIT
    HpcCh4TimeTriggerFrequencyWrite     = $CA;                // CH4 TRIGGER FREQUNCE INFO. READ
    HpcCh4Comparator1ValueRead          = $4B;                // CH4 COMPAREATOR1 READ, 31BIT
    HpcCh4Comparator1ValueWrite         = $CB;                // CH4 COMPAREATOR1 WRITE, 31BIT
    HpcCh4Comparator2ValueRead          = $4C;                // CH4 COMPAREATOR2 READ, 31BIT
    HpcCh4Comparator2ValueWrite         = $CC;                // CH4 COMPAREATOR2 WRITE, 31BIT
    HpcCh4CompareatorConditionRead      = $4D;                // CH4 COMPAREATOR CONDITION READ, 4BIT
    HpcCh4CompareatorConditionWrite     = $CD;                // CH4 COMPAREATOR CONDITION WRITE, 4BIT
    HpcCh4AbsTriggerTopPositionRead     = $4E;                // CH4 ABS TRIGGER POSITION READ, 31BIT
    HpcCh4AbsTriggerPositionWrite       = $CE;                // CH4 ABS TRIGGER POSITION WRITE, 31BIT
    HpcCh4AbsTriggerFifoStatusRead      = $4F;                // CH4 ABS TRIGGER POSITION FIFO STATUS READ, 16BIT
    HpcCh4AbsTriggerPositionClear       = $CF;                // CH4 ABS TRIGGER POSITION FIFO CLEAR

    // Ram Access Group Register
    HpcRamDataWithRamAddress            = $51;                // READ RAM DATA WITH RAM ADDR PORT ADDRESS
    HpcRamDataWrite                     = $D0;                // RAM DATA WRITE
    HpcRamDataRead                      = $50;                // RAM DATA READ, 32BIT

    // Debugging Registers    
    HpcCh1TrigPosIndexRead              = $60;                // CH1 Current RAM trigger index position on 32Bit data, 8BIT
    HpcCh1TrigBackwardDataRead          = $61;                // CH1 Current RAM trigger backward position data, 32BIT
    HpcCh1TrigCurrentDataRead           = $62;                // CH1 Current RAM trigger current position data, 32BIT
    HpcCh1TrigForwardDataRead           = $63;                // CH1 Current RAM trigger next position data, 32BIT
    HpcCh1TrigRamAddressRead            = $64;                // CH1 Current RAM trigger address, 20BIT

    HpcCh2TrigPosIndexRead              = $65;                // CH2 Current RAM trigger index position on 32Bit data, 8BIT
    HpcCh2TrigBackwardDataRead          = $66;                // CH2 Current RAM trigger backward position data, 32BIT
    HpcCh2TrigCurrentDataRead           = $67;                // CH2 Current RAM trigger current position data, 32BIT
    HpcCh2TrigForwardDataRead           = $68;                // CH2 Current RAM trigger next position data, 32BIT
    HpcCh2TrigRamAddressRead            = $69;                // CH2 Current RAM trigger address, 20BIT

    HpcCh3TrigPosIndexRead              = $70;                // CH3 Current RAM trigger index position on 32Bit data, 8BIT
    HpcCh3TrigBackwardDataRead          = $71;                // CH3 Current RAM trigger backward position data, 32BIT
    HpcCh3TrigCurrentDataRead           = $72;                // CH3 Current RAM trigger current position data, 32BIT
    HpcCh3TrigForwardDataRead           = $73;                // CH3 Current RAM trigger next position data, 32BIT
    HpcCh3TrigRamAddressRead            = $74;                // CH3 Current RAM trigger address, 20BIT

    HpcCh4TrigPosIndexRead              = $75;                // CH4 Current RAM trigger index position on 32Bit data, 8BIT
    HpcCh4TrigBackwardDataRead          = $76;                // CH4 Current RAM trigger backward position data, 32BIT
    HpcCh4TrigCurrentDataRead           = $77;                // CH4 Current RAM trigger current position data, 32BIT
    HpcCh4TrigForwardDataRead           = $78;                // CH4 Current RAM trigger next position data, 32BIT
    HpcCh4TrigRamAddressRead            = $79;                // CH4 Current RAM trigger address, 20BIT

    HpcCh1TestEnable                    = $81;                // CH1 test enable(Manufacturer only)
    HpcCh2TestEnable                    = $82;                // CH2 test enable(Manufacturer only)
    HpcCh3TestEnable                    = $83;                // CH3 test enable(Manufacturer only)
    HpcCh4TestEnable                    = $84;                // CH4 test enable(Manufacturer only)

    HpcTestFrequency                    = $8C;                // Test counter output frequency(32bit)
    HpcTestCountStart                   = $8D;                // Start test counter output with position(32bit signed).
    HpcTestCountEnd                     = $8E;                // End counter output.

    HpcCh1TrigVectorTopDataOfFifo       = $54;                // CH1 UnitVector X positin of FIFO top.
    HpcCh1TrigVectorFifoStatus          = $55;                // CH1 UnitVector X FIFO Status.
    HpcCh2TrigVectorTopDataOfFifo       = $56;                // CH2 UnitVector Y positin of FIFO top.
    HpcCh2TrigVectorFifoStatus          = $57;                // CH2 UnitVector Y FIFO Status.
    HpcCh1TrigVectorFifoPush            = $D2;                // CH1 UnitVector X position, fifo data push.
    HpcCh2TrigVectorFifoPush            = $D3;                // CH2 UnitVector Y position, fifo data push.
    
implementation
end.
