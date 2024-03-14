//##################################################################################################
//##################################################################################################
//
// (2018.11) LGDVH-H23F/POCB_A2CH          : LGDVH Auto POCB(2CH)                  //VH Auto POCB#1
// (2019.01) LGDGM-M41F/POCB_F2CH          : LGDPJ Foldable POCB(2CH) //GM->PJ     //PJ Foldable POCB#1
// (2019.10) LGDGM-M33F/POCB_A2CHv2        : LGDVH Auto POCB(2CH) Capa-Up //GM->VH //VH Auto POCB#4?
// (2021.01) LGDVH-H23F/POCB_A2CHv3        : LGDVH Auto POCB(2CH) Capa-Up/Robot    //VH Auto POCB#2 & POCB#3
// (2021.10) LGDVH-H23F/POCB_A2CHv4(#1|#2) : LGDVH Auto POCB(2CH) 2ndLine/Robot    //VH Auto POCB#5(2ndLine)
// (2022.07) LGDVH-H23F/POCB_A2CHv4(#3)    : LGDVH Auto POCB(2CH) 2ndLine/Robot    //VH Auto POCB#5(2ndLine) //Lucid|Porsche|HKMC
// (2023.04) LENSVN/POCB_ATO               : LENSVN Auto POCB(2CH)       / Robot   //LESNVN Auto POCB
// (2023.05) LENSVN/POCB_GAGO              : LENSVN GAGO POCB(2CH)       / Robot   //LESNVN GAGO POCB
//
//                          POCB_A2CH   POCB_A2CHv2 POCB_A2CHv3 POCB_A2CHv4          POCB_ATO     POCB_GAGO    POCB_F2CH
//                                                                                   (=A2CHv4#3)  (=POCB_ATO+
//                                                                                                Vacuum/Pinblock?)
//                          ----------+------------+-----------+--------------------+------------+------------+------------
//                                      LGDGM-M33F>                                  LENSVN       LENSVN       LGDGM-M41F>
//                          LGDVH-H23F  LGDVH-H23F  LGDVH-H23F  LGDVH-H23F                                     LGDPJ-M24F
//                          301#        301#        301#        302#
//                          v1          v2          v3#1~v3#3   v4#1~v4#2,v4#3
//                          ----------+------------+-----------+--------------------+------------+------------+------------
//                          +Motion:Y/Z +Motion:Y/Z +Motion:Y   +Motion:Y            +Motion:Y    +Motion:Y    +Motion:Y/Z/T
//                                                  +Robot(Cam) +Robot(Cam)          +Robot(Cam)  +Robot(Cam)
//                                                  +1CG2PANEL
//------------------------------------------------------------------------------------------------------------------------ SITE
// SITE_LGDVH               YES          YES         YES        YES                  -            -            -
// SITE_LGDPJ               -            -           -          -                    -            -            YES
// SITE_LENSVN              -            -           -          -                    YES          YES          -
//------------------------------------------------------------------------------------------------------------------------- LCM(Auto/Foldable/ATO)
// PANEL_AUTO               YES         YES         YES         YES                  YES          -            -            // USE_MODEL_AUTO -> PANEL_AUTO
// PANEL_FOLD               -           -           -           -                    -            YES???       YES          // USE_MODEL_FOLDABLE -> PANEL_FOLD
// PANEL_GAGO               -           -           -           -                    -            YES          -
//------------------------------------------------------------------------------------------------------------------------- Common(LCM/DIO/Feature)
// SUPPORT_1CG2PANEL        -           -           YES!!!      -                    -            -                          // 1CO2PANEL (= ASSY_POCB, MOTION-SYNCMODE)
//------------------------------------------------------------------------------------------------------------------------- DIO
// USE_DIO_AXD              -           YES         YES         YES                  YES          YES          YES           // AJINEXTEK - SIO-DI32,SIO-DO32P
// USE_DIO_AXT              YES         -           -           -                    -            -            -             // AJINEXTEK - SIO-DI32,SIO-DO32P
// USE_DIO_ADLINK           -           -           -           -                    -            -            -             // ADLINK
// HAS_DIO_IN32             YES         -           -           -                    -            -            -             // DIO-IN 32 bit
// HAS_DIO_IN64             -           YES         YES         YES                  YES          YES          YES           // DIO-IN 64 bit
// HAS_DIO_PINBLOCK         -           YES         -           -                    -            YES          YES           // DIO-IN PinBlock
// HAS_DIO_EXLIGHT_DETECT   YES         YES         YES         YES                  YES          YES          YES           // DIO-IN ExLightDetect (HAS_DIO_EXLIGHT,HAS_DIO_DETECT)
// HAS_DIO_DESTRUCT         -           YES         YES         YES                  -            YES          YES           // DIO
// HAS_DIO_AIRKNIFE         -           YES         YES         YES                  YES          YES          YES           // DIO
// HAS_DIO_MULTIPLE_BUZZER  -           YES         YES         YES                  YES          YES          -             // DIO
// HAS_DIO_SCREW_SHUTTER    -           -           YES         YES(v4#1|#2),-(v4#3) -            -            -             // DIO  //2022-07-15 A2CHv4_#3(NoScrewShutter)
// HAS_DIO_FAN_INOUT_PC     -           -           -           -(v4#1|#2),YES(v4#3) YES          YES          -             // DIO  //2022-07-15 A2CHv4_#3(FanInOutPC)
// HAS_DIO_PG_OFF           -           -           -           -                    YES          YES          -             // DIO  //2023-04-10 ATO|GAGO
// HAS_DIO_Y_AXIS_MC        -           -           -           -/YES(2024.01~)      -/YES(2024.01~)           -             // DIO  //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~ NEW(YES)
// HAS_DIO_IN_DOOR_LOCK     -           -           -           -/YES(2024.01~)      -/YES(2024.01~)           -             // DIO  //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~ NEW(YES)
// HAS_DIO_OUT_IONBAR       -           -           -           -/YES(2024.01~)      -/YES(2024.01~)           -             // DIO  //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~ NEW(YES)
// HAS_DIO_OUT_STAGE_LAMP   -           -           -           -/YES(2024.01~)      -/YES(2024.01~)           -             // DIO  //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~ NEW(YES)
// DIO_ALARM_THRESHOLD      -           -           YES         YES                  YES          YES          -
// FEATURE_DIO_LOG_SHUTTER  -           -           TBD?        TBD?                 YES           YES         -                                     //2024-04-27
// FEATURE_KEEP_SHUTTER_UP  TBD?        TBD?        YES         YES                  TBD?         TBD?         TBD?          // DIO  //2023-08-04 FEATURE_KEEP_SHUTTER_UP
//------------------------------------------------------------------------------------------------------------------------- MOTION
// USE_MOTION_AXM           -           YES         YES         YES                  YES          YES          YES           // AJINEXTEK AXM Motion Controller
// USE_MOTION_AXT           YES         -           -           -                    -            -            -             // AJINEXTEK - SMC-2V02 - CAMC-FS
// USE_MOTION_EZIML         -           -           -           -                    -            -            -             // EzServo
// HAS_MOTION_TILTING       -           -           -           -                    -            -            YES!!!        // AXIS-Tilting
// HAS_MOTION_CAM_Z         YES         YES         -           -                    -            -            YES           // AXIS-CamZ  //A2CHv3(CamZ: Motion->Robot)
//------------------------------------------------------------------------------------------------------------------------- ROBOT
// USE_ROBOT_TM             -           -           YES!!!      YES!!!               YES!!!       YES!!!       -             // ROBOT-TM        //2020-11-XX ROBOT-TM
// HAS_ROBOT_CAM_Z          -           -           YES!!!      YES!!!               YES!!!       YES!!!       -             // ROBOT for CAM-Z //2020-11-XX ROBOT-TM
//------------------------------------------------------------------------------------------------------------------------- BCR
// USE_BCR_COGNEX           YES         YES         YES         YES                  YES          YES          YES           // BCR-COGNEX
// USE_BCR_HONEYWELL        -           -           -           -                    -             -           -             // BCR-HONEYWELL
//------------------------------------------------------------------------------------------------------------------------- EAS
// USE_EAS                  YES         YES         YES         YES                  YES          YES          YES
// USE_MES_APDR             YES         YES         YES         YES                  YES          YES          YES
//------------------------------------------------------------------------------------------------------------------------- DFS
// USE_DFS                  YES         YES         YES         YES                  YES          YES          YES
// DFS_HEX                  YES         YES         YES         YES                  YES          YES          YES
// DFS_DEFECT               -           -           -           -                    -             -           -
// DFS_EXTRA                -           -           -           -                    -             -           -
//------------------------------------------------------------------------------------------------------------------------- Features
// USE_FPC_LIMIT            YES         YES         YES         YES                  YES           -           -
// USE_MODEL_PARAM_CSV      -           -           YES         YES                  YES           YES         -
// USE_FLASH_WRITE          -           -           YES(GIB)    YES(GIB)             YES           YES         YES
// FEATURE_BMP_SHARE        -           -           -           -                    -             -           -             //
// FEATURE_BCR_SCAN_SPCB    -           -           -           YES                  YES           -           -             // A2CHv4|ATO
// FEATURE_UNIFORMITY_PUCONOFF -        -           -           YES                  YES           YES         -             // A2CHv4|ATO|GAGO      //2022-07-15
// FEATURE_PUC_IMAGE        -           -           -           -                    YES           -           -             //        ATO|GAGO      //2023-04-04
// FEATURE_FLASH_UNIT_RW    -           -           -           -                    -             YES         YES           //        ATO|GAGO|FOLD
//------------------------------------------------------------------------------------------ Features (RemoteUpdate|SystemModel)
// FEATURE_SYSTEM_MODEL     TODO        TODO        TODO        YES                  TBD?          TBD?        -             // 2023-07-18
// FEATURE_REMOTE_UPDATE    TODO        TODO        TODO        YES                  n/a           n/a         n/a           // LGDVH(for REMOTE_UDPATE) //2023-07-18
//##################################################################################################
//##################################################################################################

//============================================================================== LGDVH-H23F/POCB_A2CH
//============================================================================== LGDVH-H23F/POCB_A2CHv2
//============================================================================== LGDVH-H23F/POCB_A2CHv3
//============================================================================== LGDVH-H23F/POCB_A2CHv4

//============================================================================== LENSVN/POCB_ATO
{$IFDEF POCB_ATO} // LENSVN/POCB_ATO
	//--------------- INSPECTOR_TYPE
  {$DEFINE INSPECTOR_POCB}
  {$DEFINE POCB_INSPECTOR}
  //--------------- SITE
  {$UNDEF  SITE_LGDVH}
  {$DEFINE SITE_LENSVN}
  //--------------- PANEL_TYPE
  {$DEFINE PANEL_AUTO}     //YES
  {$UNDEF  PANEL_FOLD} //-
  {$UNDEF  PANEL_GAGO}     //-
  //--------------- Common(LCM/DIO/Feature)
  {$UNDEF  SUPPORT_1CG2PANEL}  //-
  //--------------- DIO
  {$DEFINE USE_DIO_AXD}        //YES
  {$UNDEF  USE_DIO_AXT}        //-
  {$UNDEF  USE_DIO_ADLINK}     //-
  {$UNDEF  HAS_DIO_IN32}       //-
  {$DEFINE HAS_DIO_IN64}       //YES
  {$UNDEF  HAS_DIO_PINBLOCK}   //NO !!!
  {$DEFINE HAS_DIO_EXLIGHT_DETECT} //YES(A2CHv3,A2CHv4_#1|#2,ATO),-(A2CHv4_#3) //2022-07-15 A2CHv4_#3(NoExLightDetectSensor)
  {$UNDEF  HAS_DIO_DESTRUCT}   //-
  {$DEFINE HAS_DIO_AIRKNIFE}
  {$DEFINE HAS_DIO_MULTIPLE_BUZZER}
  {$UNDEF  HAS_DIO_SCREW_SHUTTER}  //YES(A2CHv3,A2CHv4_#1|#2),-(A2CHv4_#3|ATO) //2022-07-15 A2CHv4_#3(NoScrewShutter)
  {$DEFINE HAS_DIO_FAN_INOUT_PC}   //YES(A2CHv4_#3)                            //2022-07-15 A2CHv4_#3(FanInOutPC)
  {$DEFINE HAS_DIO_PG_OFF}         //YES(ATO)
  {$DEFINE HAS_DIO_Y_AXIS_MC}      //YES(ATO|GA) //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
  {$DEFINE HAS_DIO_IN_DOOR_LOCK}   //YES(ATO|GA) //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
  {$DEFINE HAS_DIO_OUT_IONBAR}     //YES(ATO|GA) //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
  {$DEFINE HAS_DIO_OUT_STAGE_LAMP} //YES(ATO|GA) //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
  {$DEFINE DIO_ALARM_THRESHOLD}
  {$DEFINE FEATURE_KEEP_SHUTTER_UP} //TBD:FEATURE_KEEP_SHUTTER_UP?
  {$UNDEF  FEATURE_DIO_LOG_SHUTTER} //TBD:FEATURE_DIO_LOG_SHUTTER?
  //--------------- BCR
  {$DEFINE USE_BCR_COGNEX}
  {$UNDEF  USE_BCR_HONEYWELL}
  //--------------- MOTION
  {$DEFINE USE_MOTION_AXM}     //YES
  {$UNDEF  USE_MOTION_AXT}     //-
  {$UNDEF  USE_MOTION_EZIML}   //-
  {$UNDEF  HAS_MOTION_TILTING} //-
  {$UNDEF  HAS_MOTION_CAM_Z}   //-
  //--------------- ROBOT
  {$DEFINE USE_ROBOT_TM}       //YES
  {$DEFINE HAS_ROBOT_CAM_Z}    //YES
  //--------------- EAS
  {$UNDEF  USE_EAS}            //NO!!! (LENSVN)
  {$UNDEF  USE_MES_APDR}       //NO!!! (LENSVN)
  //--------------- DFS
  {$UNDEF  USE_DFS}            //NO!!! (LENSVN)
  {$UNDEF  DFS_HEX}            //NO!!! (LENSVN)
  {$UNDEF  DFS_DEFECT}         //-
  {$UNDEF  DFS_EXTRA}          //-
  //--------------- Features
  {$UNDEF  USE_FPC_LIMIT}               //-
  {$DEFINE USE_MODEL_PARAM_CSV}         //YES
  {$DEFINE USE_FLASH_WRITE}             //YES
  {$UNDEF  FEATURE_BMP_SHARE}           //-
  {$UNDEF  FEATURE_BCR_SCAN_SPCB}       //-   //2023-10-10 LENS:ATO(YES->NO)
  {$DEFINE FEATURE_BCR_PID_INTERLOCK}   //YES //2023-10-10 LENS:ATO
  {$DEFINE FEATURE_UNIFORMITY_PUCONOFF} //YES
  {$DEFINE FEATURE_PUC_IMAGE}           //YES
  {$UNDEF  FEATURE_FLASH_UNIT_RW}   //-
  //--------------- REMOTE_UPDATE
  {$UNDEF  FEATURE_SYSTEM_MODEL}  //TBD?
  {$UNDEF  FEATURE_REMOTE_UPDATE} //n/a
{$ENDIF}

//============================================================================== LENSVN/POCB_GAGO
{$IFDEF POCB_GAGO} // LENSVN/POCB_GAGO
	//--------------- INSPECTOR_TYPE
  {$DEFINE INSPECTOR_POCB}
  {$DEFINE POCB_INSPECTOR}
  //--------------- SITE
  {$UNDEF  SITE_LGDVH}
  {$DEFINE SITE_LENSVN}
  //--------------- PANEL_TYPE
  {$UNDEF  PANEL_AUTO}     //-
  {$UNDEF  PANEL_FOLD} //YES /?TBD:GAGO?
  {$DEFINE PANEL_GAGO}     //YES
  //--------------- Common(LCM/DIO/Feature)
  {$UNDEF  SUPPORT_1CG2PANEL}  //-
  //--------------- DIO
  {$DEFINE USE_DIO_AXD}        //YES
  {$UNDEF  USE_DIO_AXT}        //-
  {$UNDEF  USE_DIO_ADLINK}     //-
  {$UNDEF  HAS_DIO_IN32}       //-
  {$DEFINE HAS_DIO_IN64}       //YES
  {$UNDEF  HAS_DIO_PINBLOCK}   //- //TBD:GAGO?
  {$DEFINE HAS_DIO_EXLIGHT_DETECT} //YES(A2CHv3,A2CHv4_#1|#2,ATO|GAGO),-(A2CHv4_#3) //2022-07-15 A2CHv4_#3(NoExLightDetectSensor)
  {$DEFINE HAS_DIO_DESTRUCT}   //YES
  {$DEFINE HAS_DIO_AIRKNIFE}   //YES
  {$DEFINE HAS_DIO_MULTIPLE_BUZZER}
  {$UNDEF  HAS_DIO_SCREW_SHUTTER}  //YES(A2CHv3,A2CHv4_#1|#2),-(A2CHv4_#3|ATO|GAGO) //2022-07-15 A2CHv4_#3(NoScrewShutter)
  {$DEFINE HAS_DIO_FAN_INOUT_PC}   //YES(A2CHv4_#3)                                 //2022-07-15 A2CHv4_#3(FanInOutPC)
  {$DEFINE HAS_DIO_PG_OFF}         //YES(ATO|GAGO)
  {$DEFINE HAS_DIO_Y_AXIS_MC}      //YES(ATO|GA) //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
  {$DEFINE HAS_DIO_IN_DOOR_LOCK}   //YES(ATO|GA) //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
  {$DEFINE HAS_DIO_OUT_IONBAR}     //YES(ATO|GA) //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
  {$DEFINE HAS_DIO_OUT_STAGE_LAMP} //YES(ATO|GA) //2024-01-XX A2CHv4_#1#2#3|LENS(#1~#4(-) //2024.01~(YES)
  {$DEFINE DIO_ALARM_THRESHOLD}
  {$DEFINE FEATURE_KEEP_SHUTTER_UP} //TBD:FEATURE_KEEP_SHUTTER_UP?
  {$UNDEF  FEATURE_DIO_LOG_SHUTTER} //TBD:FEATURE_DIO_LOG_SHUTTER?	
  //--------------- BCR
  {$DEFINE USE_BCR_COGNEX}
  {$UNDEF  USE_BCR_HONEYWELL}
  //--------------- MOTION
  {$DEFINE USE_MOTION_AXM}     //YES
  {$UNDEF  USE_MOTION_AXT}     //-
  {$UNDEF  USE_MOTION_EZIML}   //-
  {$UNDEF  HAS_MOTION_TILTING} //-
  {$UNDEF  HAS_MOTION_CAM_Z}   //-
  //--------------- ROBOT
  {$DEFINE USE_ROBOT_TM}       //YES
  {$DEFINE HAS_ROBOT_CAM_Z}    //YES
  //--------------- EAS
  {$UNDEF  USE_EAS}            //NO!!! (LENSVN)
  {$UNDEF  USE_MES_APDR}       //NO!!! (LENSVN)
  //--------------- DFS
  {$UNDEF  USE_DFS}            //NO!!! (LENSVN)
  {$UNDEF  DFS_HEX}            //NO!!! (LENSVN)
  {$UNDEF  DFS_DEFECT}         //-
  {$UNDEF  DFS_EXTRA}          //-
  //--------------- Features
  {$UNDEF  USE_FPC_LIMIT}               //-
  {$DEFINE USE_MODEL_PARAM_CSV}         //YES
  {$DEFINE USE_FLASH_WRITE}             //YES
  {$UNDEF  FEATURE_BMP_SHARE}           //-
  {$UNDEF  FEATURE_BCR_SCAN_SPCB}       //-
  {$UNDEF  FEATURE_BCR_PID_INTERLOCK}   //- //2023-10-10 LENS:ATO (GAGO:n/a)
  {$DEFINE FEATURE_UNIFORMITY_PUCONOFF} //YES //2023-06-08
  {$DEFINE FEATURE_PUC_IMAGE}           //YES //2023-06-08
  {$DEFINE FEATURE_FLASH_UNIT_RW}       //YES
  //--------------- REMOTE_UPDATE
  {$UNDEF  FEATURE_SYSTEM_MODEL}  //TBD?
  {$UNDEF  FEATURE_REMOTE_UPDATE} //n/a			
{$ENDIF}

//==============================================================================
//--------------- DEBUG
{$IFDEF DEBUG}
{$ENDIF}

//--------------- SIMULATOR
{$UNDEF SIMULATOR_CAM}
{$UNDEF SIMULATOR_DIO}
{$UNDEF SIMULATOR_MOTION}
{$UNDEF SIMULATOR_ROBOT}
{$UNDEF SIMULATOR_PG}
{$UNDEF SIMULATOR_SPI}
{$UNDEF SIMULATOR_PANEL}
{$UNDEF SIMULATOR_GMES}

{$IFDEF SIMULATOR}
  {$DEFINE SIMULATOR_CAM}
  {$DEFINE SIMULATOR_DIO}
  {$DEFINE SIMULATOR_MOTION}
  {$DEFINE SIMULATOR_ROBOT}
  {$DEFINE SIMULATOR_PG}
  {$DEFINE SIMULATOR_SPI}
  {$DEFINE SIMULATOR_PANEL}  // UNDEF (Use PANEL), DEFINE (No Use Panel/PG)
  {$DEFINE SIMULATOR_GMES}
  {$DEFINE SIMULATOR_ION}
{$ENDIF}

