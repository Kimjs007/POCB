// MES 통신 관련 Define.
///	<summary>
///	  LGD GMES 관련 Define class
///	  LENS MES 관련 Define class
///	</summary>
unit DefGmes;
{$I Common.inc}

interface
  const

    //--------------------------------------------------------------------------
    // MES Message Type Code (for Internal Use)
    //--------------------------------------------------------------------------
    MES_UNKNOWN      = 0;
{$IFDEF SITE_LENSVN}
    MES_UCHK         = 102;  // LENS : Login
    MES_PCHK         = 105;  // LENS : Start
		MES_EICR         = 106;  // LENS : End
    MES_EQCC         = 107;  // LENS : EqStatus
    MES_INS_PCHK     = 111;  // LENS : Start //TBD:LENS:MES?
		MES_RPR_EIJR     = 113;  // LENS : End   //TBD:LENS:MES?
    MES_ZSET         = 115;  // LENS : ReInput
{$ELSE}
    MES_EAYT         = 101;
    MES_UCHK         = 102;
    MES_EDTI         = 103;
    MES_FLDR         = 104;
    MES_PCHK         = 105;
		MES_EICR         = 106;
    MES_EQCC         = 107;
    MES_LPHI         = 108;
    MES_REPN         = 109;
    {$IFDEF USE_MES_APDR}
	  MES_APDR         = 110;
    {$ENDIF}
    MES_INS_PCHK     = 111;
		MES_RPR_VSIR     = 112;
		MES_RPR_EIJR     = 113;
		MES_EIJR         = 114;
    MES_ZSET         = 115;
    MES_TILR         = 116;
{$ENDIF}

    //--------------------------------------------------------------------------
    // EAS Message Type Code (for Internal Use)
    //--------------------------------------------------------------------------
    EAS_UNKNOWN      = 0;
    EAS_APDR         = 201;
    EAS_EICR         = 202;

    //--------------------------------------------------------------------------
    //
    BCR_TYPE_PID        = 0;
    BCR_TYPE_SERIAL_NO  = 1;
    BCR_TYPE_LCM_ID     = 2;
    BCR_TYPE_FOG_ID     = 3;
    BCR_TYPE_BLID       = 4;
    BCR_TYPE_CGID       = 5;
    BCR_TYPE_SPCB       = 6;  //2021-12-22 (Auto Lucid)

    SERIAL_USE_CARRIER_ID = 0;  //0:False, 1:True
    SERIAL_USE_ZIG_ID     = 0;  //0:False, 1:True

    POCB_MES_CODE_MAX     = 99;
{$IF Defined(PANEL_AUTO) or Defined(POCB_ATO) or Defined(POCB_GAGO)}
    //--------------------------------------------------------------------------
    // LGDVH(A2CH|A2CHv2|A2CHv3|A2CHv4), LENSVN(ATO|GAGO)
    //--------------------------------------------------------------------------
    //  Process	          Defect Types	  Defect Code	  Defect Name	                  MES Code
    //  POCB	            Camera Defect	  PD01	        Contact NG	                  상위보고 안함/UI상 NG만 표기
    //  POCB	            Camera Defect	  PD02	        START DPC NG	                A0G-B01-45D   //TBD:상위보고 안함/UI상 NG만 표기?
    //  POCB	            Camera Defect	  PD03	        No Response from DPC NG	      A0G-B01-45E   //TBD:상위보고 안함/UI상 NG만 표기?
    //  POCB	            Camera Defect	  PD04	        DPC WORK STOP NG	            A0G-B01-45F   //TBD:상위보고 안함/UI상 NG만 표기?
    //  POCB	            Camera Defect	  PD05	        RSTDONE NG	                  A0G-B01-45G   //TBD:상위보고 안함/UI상 NG만 표기?
    //  POCB	            Camera Defect	  PD06	        Calibraion Fail NG	          A06-B01-GN9
    //  POCB	            Camera Defect	  PD08	        Guess TRN Fail NG	            A0G-B01-45H
    //  POCB	            Camera Defect	  PD09	        Pattern Lighting Fail NG	    A0G-B01-45J
    //  POCB	            Camera Defect	  PD10	        Camera Operation Disorders	  A0G-B01-45K
    //  POCB	            Camera Defect	  PD11	        De-Mura Fail Defect Detected	A0G-B01-45L
    //  POCB	            Camera Defect	  PD12	        Pattern On Fail NG	          A0G-B01-45M
    //  POCB	            Camera Defect	  PD13	        CHKPOS ERROR	                A0G-B01-45N   //TBD:상위보고 안함/UI상 NG만 표기?
    //  POCB	            Camera Defect	  PD14	        NO PANELID	                  A0G-B01-45P   //TBD:상위보고 안함/UI상 NG만 표기?
    //  POCB	            Camera Defect	  PD15	        CONFIG FILE Unloaded	        A0G-B01-45Q   //TBD:상위보고 안함/UI상 NG만 표기?
    //  POCB/Uniformity	  Camera Defect	  PD16	        White Uniformity NG	          A0G-B01-2PQ
    POCB_MESCODE_PD01_SUMMARY = '';                                            //Contact NG   //상위보고 안함/UI상 NG만 표기
    POCB_MESCODE_PD02_SUMMARY = 'A0G-B01-45D';  //START DPC NG ***
    POCB_MESCODE_PD03_SUMMARY = 'A0G-B01-45E';  //No Response from DPC NG ***
    POCB_MESCODE_PD04_SUMMARY = 'A0G-B01-45F';  //DPC WORK STOP NG ***
    POCB_MESCODE_PD05_SUMMARY = 'A0G-B01-45G';  //RSTDONE NG ***
    POCB_MESCODE_PD06_SUMMARY = 'A0G-B01-GN9';  //Calibraion Fail NG
    POCB_MESCODE_PD07_SUMMARY = '';             //STOP by Operator or Alarm //상위보고 안함/UI상 NG만 표기
    POCB_MESCODE_PD08_SUMMARY = 'A0G-B01-45H';  //Guess TRN Fail NG
    POCB_MESCODE_PD09_SUMMARY = 'A0G-B01-45J';  //Pattern Lighting Fail NG
    POCB_MESCODE_PD10_SUMMARY = 'A0G-B01-45K';  //Camera Operation Disorders
    POCB_MESCODE_PD11_SUMMARY = 'A0G-B01-45L';  //De-Mura Fail Defect Detected
    POCB_MESCODE_PD12_SUMMARY = 'A0G-B01-45M';  //Pattern On Fail NG
    POCB_MESCODE_PD13_SUMMARY = 'A0G-B01-45N';  //CHKPOS ERROR
    POCB_MESCODE_PD14_SUMMARY = 'A0G-B01-45P';  //NO PANELID
    POCB_MESCODE_PD15_SUMMARY = 'A0G-B01-45Q';  //CONFIG FILE Unloaded
    POCB_MESCODE_PD16_SUMMARY = 'A0G-B01-2PD';  //White Uniformity NG ***
    POCB_MESCODE_PD17_SUMMARY = 'A06-B01-2LA';  //Communication NG
    POCB_MESCODE_PD18_SUMMARY = 'A06-B01-Z8Q';  //Flash Memory write NG
    POCB_MESCODE_PD19_SUMMARY = 'A06-B01-401';  //EEPROM WRITE NG
    POCB_MESCODE_PD20_SUMMARY = 'A06-B01-47C';  //POCB NG
    POCB_MESCODE_PD21_SUMMARY = 'A06-B01-ZJ9';  //MTF NG
    POCB_MESCODE_PD22_SUMMARY = 'A06-B01-ZJ1';  //GB Final NG
    POCB_MESCODE_PD23_SUMMARY = 'A06-B01-ZJA';  //Flash memory Read NG
    POCB_MESCODE_PD24_SUMMARY = 'A06-B01-ZJB';  //Fail to find result hex file
  //POCB_MESCODE_PD24_SUMMARY = '';             //Model Info Mismatch ???	

    {$IFDEF SITE_LENSVN}
    POCB_MESCODE_PD01_RWK = '';                                            //Contact NG   //상위보고 안함/UI상 NG만 표기
    POCB_MESCODE_PD02_RWK = 'A0G-B01-45D';  //START DPC NG ***
    POCB_MESCODE_PD03_RWK = 'A0G-B01-45E';  //No Response from DPC NG ***
    POCB_MESCODE_PD04_RWK = 'A0G-B01-45F';  //DPC WORK STOP NG ***
    POCB_MESCODE_PD05_RWK = 'A0G-B01-45G';  //RSTDONE NG ***
    POCB_MESCODE_PD06_RWK = 'A0G-B01-GN9';  //Calibraion Fail NG
    POCB_MESCODE_PD07_RWK = '';                                            //STOP by Operator or Alarm //상위보고 안함/UI상 NG만 표기
    POCB_MESCODE_PD08_RWK = 'A0G-B01-45H';  //Guess TRN Fail NG
    POCB_MESCODE_PD09_RWK = 'A0G-B01-45J';  //Pattern Lighting Fail NG
    POCB_MESCODE_PD10_RWK = 'A0G-B01-45K';  //Camera Operation Disorders
    POCB_MESCODE_PD11_RWK = 'A0G-B01-45L';  //De-Mura Fail Defect Detected
    POCB_MESCODE_PD12_RWK = 'A0G-B01-45M';  //Pattern On Fail NG
    POCB_MESCODE_PD13_RWK = 'A0G-B01-45N';  //CHKPOS ERROR
    POCB_MESCODE_PD14_RWK = 'A0G-B01-45P';  //NO PANELID
    POCB_MESCODE_PD15_RWK = 'A0G-B01-45Q';  //CONFIG FILE Unloaded
    POCB_MESCODE_PD16_RWK = 'A0G-B01-2PQ';  //White Uniformity NG ***
    POCB_MESCODE_PD17_RWK = 'A06-B01-2LA';  //Communication NG
    POCB_MESCODE_PD18_RWK = 'A06-B01-Z8Q';  //Flash Memory write NG
    POCB_MESCODE_PD19_RWK = 'A06-B01-401';  //EEPROM WRITE NG
    POCB_MESCODE_PD20_RWK = 'A06-B01-47C';  //POCB NG
    POCB_MESCODE_PD21_RWK = 'A06-B01-ZJ9';  //MTF NG
    POCB_MESCODE_PD22_RWK = 'A06-B01-ZJ1';  //GB Final NG
    POCB_MESCODE_PD23_RWK = 'A06-B01-ZJA';  //Flash memory Read NG
    POCB_MESCODE_PD24_RWK = 'A06-B01-ZJB';  //Fail to find result hex file
  //POCB_MESCODE_PD25_RWK = '';             //Model Info Mismatch ???		
    {$ELSE}
    POCB_MESCODE_PD01_RWK = '';                                            //Contact NG   //상위보고 안함/UI상 NG만 표기
    POCB_MESCODE_PD02_RWK = 'A0G-B01-----45D---------------------------';  //START DPC NG ***
    POCB_MESCODE_PD03_RWK = 'A0G-B01-----45E---------------------------';  //No Response from DPC NG ***
    POCB_MESCODE_PD04_RWK = 'A0G-B01-----45F---------------------------';  //DPC WORK STOP NG ***
    POCB_MESCODE_PD05_RWK = 'A0G-B01-----45G---------------------------';  //RSTDONE NG ***
    POCB_MESCODE_PD06_RWK = 'A0G-B01-----GN9---------------------------';  //Calibraion Fail NG
    POCB_MESCODE_PD07_RWK = '';                                            //STOP by Operator or Alarm //상위보고 안함/UI상 NG만 표기
    POCB_MESCODE_PD08_RWK = 'A0G-B01-----45H---------------------------';  //Guess TRN Fail NG
    POCB_MESCODE_PD09_RWK = 'A0G-B01-----45J---------------------------';  //Pattern Lighting Fail NG
    POCB_MESCODE_PD10_RWK = 'A0G-B01-----45K---------------------------';  //Camera Operation Disorders
    POCB_MESCODE_PD11_RWK = 'A0G-B01-----45L---------------------------';  //De-Mura Fail Defect Detected
    POCB_MESCODE_PD12_RWK = 'A0G-B01-----45M---------------------------';  //Pattern On Fail NG
    POCB_MESCODE_PD13_RWK = 'A0G-B01-----45N---------------------------';  //CHKPOS ERROR
    POCB_MESCODE_PD14_RWK = 'A0G-B01-----45P---------------------------';  //NO PANELID
    POCB_MESCODE_PD15_RWK = 'A0G-B01-----45Q---------------------------';  //CONFIG FILE Unloaded
    POCB_MESCODE_PD16_RWK = 'A0G-B01-----2PD---------------------------';  //White Uniformity NG ***

    POCB_MESCODE_PD17_RWK = 'A06-B01-----2LA---------------------------';  //Communication NG
    POCB_MESCODE_PD18_RWK = 'A06-B01-----Z8Q---------------------------';  //Flash Memory write NG
    POCB_MESCODE_PD19_RWK = 'A06-B01-----401---------------------------';  //EEPROM WRITE NG
    POCB_MESCODE_PD20_RWK = 'A06-B01-----47C---------------------------';  //POCB NG
    POCB_MESCODE_PD21_RWK = 'A06-B01-----ZJ9---------------------------';  //MTF NG
    POCB_MESCODE_PD22_RWK = 'A06-B01-----ZJ1---------------------------';  //GB Final NG
    POCB_MESCODE_PD23_RWK = 'A06-B01-----ZJA---------------------------';  //Flash memory Read NG
    POCB_MESCODE_PD24_RWK = 'A06-B01-----ZJB---------------------------';  //Fail to find result hex file
  //POCB_MESCODE_PD25_RWK = '';                                            //Model Info Mismatch ???
    {$ENDIF}
{$ELSEIF Defined(POCB_F2CH)} //LGDPJ-FOLD
    //--------------------------------------------------------------------------
    // F2CH  //2019-06-20
    //--------------------------------------------------------------------------
    POCB_MESCODE_PD01_SUMMARY = '';             //Contact NG   //상위보고 안함/UI상 NG만 표기
    POCB_MESCODE_PD02_SUMMARY = 'A0G-B01-45D';  //START DPC NG ***
    POCB_MESCODE_PD03_SUMMARY = 'A0G-B01-4WD';  //No Response from DPC NG ***
    POCB_MESCODE_PD04_SUMMARY = 'A0G-B01-4WE';  //DPC WORK STOP NG ***
    POCB_MESCODE_PD05_SUMMARY = 'A0G-B01-4WE';  //COMPENSATION DATA WRITE NG ***
    POCB_MESCODE_PD06_SUMMARY = 'A0G-B01-4WE';  //EEPROM WRITE NG
    POCB_MESCODE_PD07_SUMMARY = '';             //STOP by Operator or Alarm //상위보고 안함/UI상 NG만 표기
    POCB_MESCODE_PD08_SUMMARY = 'A0G-B01-4WF';  //CamPC: 01 Fail to init camera library
    POCB_MESCODE_PD09_SUMMARY = 'A0G-B01-4WF';  //CamPC: 02 Fail to connect camera.
    POCB_MESCODE_PD10_SUMMARY = 'A0G-B01-4WF';  //CamPC: 03 Fail to set exposure time.
    POCB_MESCODE_PD11_SUMMARY = 'A0G-B01-4WF';  //CamPC: 04 Fail to set trigger.
    POCB_MESCODE_PD12_SUMMARY = 'A0G-B01-4WF';  //CamPC: 05 Fail to init library.
    POCB_MESCODE_PD13_SUMMARY = 'A0G-B01-4WF';  //CamPC: 11 Unknown model name.
    POCB_MESCODE_PD14_SUMMARY = 'A0G-B01-4WF';  //CamPC: 12 The hard capacity is full.
    POCB_MESCODE_PD15_SUMMARY = 'A0G-B01-4WG';  //CamPC: 14 Fail to find result hex file.
    POCB_MESCODE_PD16_SUMMARY = 'A0G-B01-4WH';  //CamPC: 16 Timeout - Pattern Display (Pattern 0, Cal Pattern)
                                                //CamPC: 17 Timeout - Pattern Display (Pattern 1, G16)
                                                //CamPC: 18 Timeout - Pattern Display (Pattern 2, G32)
                                                //CamPC: 19 Timeout - Pattern Display (Pattern 3, G64)
                                                //CamPC: 20 Timeout - Pattern Display (Pattern 4, G128)
    POCB_MESCODE_PD17_SUMMARY = 'A0G-B01-4WJ';  //CamPC: 30 - Timeout - Write Pocb result file.
    POCB_MESCODE_PD18_SUMMARY = 'A0G-B01-4WK';  //CamPC: 37 Timeout - TEND.
    POCB_MESCODE_PD19_SUMMARY = 'A0G-B01-4WL';  //CamPC: 38 Error Brightness
    POCB_MESCODE_PD20_SUMMARY = 'A0G-B01-4WM';  //CamPC: 39 Error Darkness
    POCB_MESCODE_PD21_SUMMARY = 'A0G-B01-4WN';  //CamPC: 41 Error Compatation

    //TBD:GAGO? ...start
    POCB_MESCODE_PD22_SUMMARY = 'A06-B01-ZJ1';  //GB Final NG
    POCB_MESCODE_PD23_SUMMARY = 'A06-B01-ZJA';  //Flash memory Read NG
    POCB_MESCODE_PD24_SUMMARY = 'A06-B01-ZJB';  //Fail to find result hex file
    //TBD:GAGO? ...end

    POCB_MESCODE_PD01_RWK = '';                                            //Contact NG   //상위보고 안함/UI상 NG만 표기
    POCB_MESCODE_PD02_RWK = 'A0G-B01-----45D---------------------------';  //START DPC NG ***
    POCB_MESCODE_PD03_RWK = 'A0G-B01-----4WD---------------------------';  //No Response from DPC NG ***
    POCB_MESCODE_PD04_RWK = 'A0G-B01-----4WE---------------------------';  //DPC WORK STOP NG ***
    POCB_MESCODE_PD05_RWK = 'A0G-B01-----4WE---------------------------';  //COMPENSATION DATA WRITE NG ***
    POCB_MESCODE_PD06_RWK = 'A0G-B01-----4WE---------------------------';  //EEPROM WRITE NG
    POCB_MESCODE_PD07_RWK = '';                                            //STOP by Operator or Alarm //상위보고 안함/UI상 NG만 표기
    POCB_MESCODE_PD08_RWK = 'A0G-B01-----4WF---------------------------';  //CamPC: 01 Fail to init camera library
    POCB_MESCODE_PD09_RWK = 'A0G-B01-----4WF---------------------------';  //CamPC: 02 Fail to connect camera.
    POCB_MESCODE_PD10_RWK = 'A0G-B01-----4WF---------------------------';  //CamPC: 03 Fail to set exposure time.
    POCB_MESCODE_PD11_RWK = 'A0G-B01-----4WF---------------------------';  //CamPC: 04 Fail to set trigger.
    POCB_MESCODE_PD12_RWK = 'A0G-B01-----4WF---------------------------';  //CamPC: 05 Fail to init library.
    POCB_MESCODE_PD13_RWK = 'A0G-B01-----4WF---------------------------';  //CamPC: 11 Unknown model name.
    POCB_MESCODE_PD14_RWK = 'A0G-B01-----4WF---------------------------';  //CamPC: 12 The hard capacity is full.
    POCB_MESCODE_PD15_RWK = 'A0G-B01-----4WG---------------------------';  //CamPC: 14 Fail to find result hex file.
    POCB_MESCODE_PD16_RWK = 'A0G-B01-----4WH---------------------------';  //CamPC: 16 Timeout - Pattern Display (Pattern 0, Cal Pattern)
                                                                           //CamPC: 17 Timeout - Pattern Display (Pattern 1, G16)
                                                                           //CamPC: 18 Timeout - Pattern Display (Pattern 2, G32)
                                                                           //CamPC: 19 Timeout - Pattern Display (Pattern 3, G64)
                                                                           //CamPC: 20 Timeout - Pattern Display (Pattern 4, G128)
    POCB_MESCODE_PD17_RWK = 'A0G-B01-----4WJ---------------------------';  //CamPC: 30 - Timeout - Write Pocb result file.
    POCB_MESCODE_PD18_RWK = 'A0G-B01-----4WK---------------------------';  //CamPC: 37 Timeout - TEND.
    POCB_MESCODE_PD19_RWK = 'A0G-B01-----4WL---------------------------';  //CamPC: 38 Error Brightness
    POCB_MESCODE_PD20_RWK = 'A0G-B01-----4WM---------------------------';  //CamPC: 39 Error Darkness
    POCB_MESCODE_PD21_RWK = 'A0G-B01-----4WN---------------------------';  //CamPC: 41 Error Compatation

    //TBD:GAGO? ...start
    POCB_MESCODE_PD22_RWK = 'A06-B01-----ZJ1---------------------------';  //GB Final NG
    POCB_MESCODE_PD23_RWK = 'A06-B01-----ZJA---------------------------';  //Flash memory Read NG
    POCB_MESCODE_PD24_RWK = 'A06-B01-----ZJB---------------------------';  //Fail to find result hex file
    //TBD:GAGO? ...end
{$ENDIF}

  type
    enumMesStatus = (MesStatus_NONE=0, MesStatus_OFFLINE=1, MesStatus_ONLINE=2);

implementation

end.
