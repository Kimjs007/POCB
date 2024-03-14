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
    {  ���̽����� ����                  }
    AXT_UNKNOWN                         = $00;        // Unknown Baseboard                                         
    AXT_BIHR                            = $01;        // ISA bus, Half size                                        
    AXT_BIFR                            = $02;        // ISA bus, Full size                                        
    AXT_BPHR                            = $03;        // PCI bus, Half size                                        
    AXT_BPFR                            = $04;        // PCI bus, Full size                                        
    AXT_BV3R                            = $05;        // VME bus, 3U size                                          
    AXT_BV6R                            = $06;        // VME bus, 6U size                                          
    AXT_BC3R                            = $07;        // cPCI bus, 3U size                                         
    AXT_BC6R                            = $08;        // cPCI bus, 6U size                                         
    AXT_FMNSH4D                         = $52;        // ISA bus, Full size, DB-32T, SIO-2V03 * 2                  
    AXT_PCI_DI64R                       = $43;        // PCI bus, Digital IN 64��                                  
    AXT_PCI_DO64R                       = $53;        // PCI bus, Digital OUT 64��                                 
    AXT_PCI_DB64R                       = $63;        // PCI bus, Digital IN 32��, OUT 32��                        
    AXT_BPHD                            = $83;        // PCI bus, Half size, DB-32T                                
    AXT_ISAN404                         = $84;        // ISA bus, Half size On-Board 4 Axis controller.            
    AXT_ISAN804                         = $85;        // ISA bus, Half size On-Board 8 Axis controller.            
    AXT_PCIN404                         = $84;        // PCI bus, Half size On-Board 4 Axis controller.            
    AXT_PCIN804                         = $85;        // PCI bus, Half size On-Board 8 Axis controller.            
    AXT_PCI_AIO1602HR                   = $93;        // PCI bus, Half size, AI-16ch, AO-2ch AI16HR                
    AXT_PCI_R1604                       = $C1;        // PCI bus[PCI9030], Half size, RTEX based 16 axis controller
    AXT_PCI_R3204                       = $C2;        // PCI bus[PCI9030], Half size, RTEX based 32 axis controller
    { �����ǰ ����                     }
    AXT_SMC_2V01                        = $01;        // CAMC-5M, 2 Axis                                       
    AXT_SMC_2V02                        = $02;        // CAMC-FS, 2 Axis                                       
    AXT_SMC_1V01                        = $03;        // CAMC-5M, 1 Axis                                       
    AXT_SMC_1V02                        = $04;        // CAMC-FS, 1 Axis                                       
    AXT_SMC_2V03                        = $05;        // CAMC-IP, 2 Axis                                       
    AXT_SMC_4V04                        = $06;        // CAMC-QI, 4 Axis                                       
    AXT_SMC_R1V04A4                     = $07;        // CAMC-QI, 1 Axis, For RTEX A4 slave only               
    AXT_SMC_1V03                        = $08;        // CAMC-IP, 1 Axis                                       
    AXT_SMC_R1V04                       = $09;        // CAMC-QI, 1 Axis, For RTEX SLAVE only                  
    AXT_SMC_2V04                        = 0x0C,       // CAMC-QI, 2 Axis
    AXT_SMC_4V51                        = $33;        // MCX314,  4 Axis                                       
    AXT_SMC_2V53                        = $35;        // PMD, 2 Axis                                           
    AXT_SMC_2V54                        = $36;        // MCX312,  2 Axis                                       
    AXT_SIO_RDI32                       = $95;        // Digital IN  32��, For RTEX only                       
    AXT_SIO_RDO32                       = $96;        // Digital OUT 32��, For RTEX only                       
    AXT_SIO_DI32                        = $97;        // Digital IN  32��                                      
    AXT_SIO_DO32P                       = $98;        // Digital OUT 32��                                      
    AXT_SIO_DB32P                       = $99;        // Digital IN 16�� / OUT 16��                            
    AXT_SIO_DO32T                       = $9E;        // Digital OUT 16��, Power TR ���                       
    AXT_SIO_DB32T                       = $9F;        // Digital IN 16�� / OUT 16��, Power TR ���             
    AXT_SIO_AI4RB                       = $A1;        // A1h(161) : AI 4Ch, 12 bit                             
    AXT_SIO_AO4RB                       = $A2;        // A2h(162) : AO 4Ch, 12 bit                             
    AXT_SIO_AI16H                       = $A3;        // A3h(163) : AI 4Ch, 16 bit                             
    AXT_SIO_AO8H                        = $A4;        // A4h(164) : AO 4Ch, 16 bit                             
    AXT_SIO_AI16HB                      = $A5;        // A5h(165) : AI 16Ch, 16 bit (SIO-AI16HR(input module)) 
    AXT_SIO_AO2HB                       = $A6;        // A6h(166) : AO 2Ch, 16 bit  (SIO-AI16HR(output module))
    AXT_SIO_RAI8RB                      = $A7;        // A1h(167) : AI 8Ch, 16 bit, For RTEX only              
    AXT_SIO_RAO4RB                      = $A8;        // A2h(168) : AO 4Ch, 16 bit, For RTEX only              
    AXT_COM_234R                        = $D3;        // COM-234R                                              
    AXT_COM_484R                        = $D4;        // COM-484R                                              
    { �Լ� ��ȯ�� ����                  }
    AXT_RT_SUCCESS                      = 0;          // API �Լ� ���� ����                                                
    AXT_RT_OPEN_ERROR                   = 1001;       // ���̺귯�� ���� ��������                                          
    AXT_RT_OPEN_ALREADY                 = 1002;       // ���̺귯�� ���� �Ǿ��ְ� ��� ����                                
    AXT_RT_NOT_OPEN                     = 1053;       // ���̺귯�� �ʱ�ȭ ����                                            
    AXT_RT_NOT_SUPPORT_VERSION          = 1054;       // ���������ʴ� �ϵ����                                             
    AXT_RT_INVALID_BOARD_NO             = 1101;       // ��ȿ���� �ʴ� ���� ��ȣ                                           
    AXT_RT_INVALID_MODULE_POS           = 1102;       // ��ȿ���� �ʴ� ��� ��ġ                                           
    AXT_RT_INVALID_LEVEL                = 1103;       // ��ȿ���� �ʴ� ����                                                
    AXT_RT_INVALID_VARIABLE             = 1104;       // ��ȿ���� �ʴ� ����                                                
    AXT_RT_ERROR_VERSION_READ           = 1151;       // ���̺귯�� ������ ������ ����                                     
    AXT_RT_NETWORK_ERROR                = 1152;       // �ϵ���� ��Ʈ��ũ ����                                            
    AXT_RT_1ST_BELOW_MIN_VALUE          = 1160;       // ù��° ���ڰ��� �ּҰ����� �� ����                                
    AXT_RT_1ST_ABOVE_MAX_VALUE          = 1161;       // ù��° ���ڰ��� �ִ밪���� �� ŭ                                  
    AXT_RT_2ND_BELOW_MIN_VALUE          = 1170;       // �ι�° ���ڰ��� �ּҰ����� �� ����                                
    AXT_RT_2ND_ABOVE_MAX_VALUE          = 1171;       // �ι�° ���ڰ��� �ִ밪���� �� ŭ                                  
    AXT_RT_3RD_BELOW_MIN_VALUE          = 1180;       // ����° ���ڰ��� �ּҰ����� �� ����                                
    AXT_RT_3RD_ABOVE_MAX_VALUE          = 1181;       // ����° ���ڰ��� �ִ밪���� �� ŭ                                  
    AXT_RT_4TH_BELOW_MIN_VALUE          = 1190;       // �׹�° ���ڰ��� �ּҰ����� �� ����                                
    AXT_RT_4TH_ABOVE_MAX_VALUE          = 1191;       // �׹�° ���ڰ��� �ִ밪���� �� ŭ                                  
    AXT_RT_5TH_BELOW_MIN_VALUE          = 1200;       // �ټ���° ���ڰ��� �ּҰ����� �� ����                              
    AXT_RT_5TH_ABOVE_MAX_VALUE          = 1201;       // �ټ���° ���ڰ��� �ִ밪���� �� ŭ                                
    AXT_RT_6TH_BELOW_MIN_VALUE          = 1210;       // ������° ���ڰ��� �ּҰ����� �� ����                              
    AXT_RT_6TH_ABOVE_MAX_VALUE          = 1211;       // ������° ���ڰ��� �ִ밪���� �� ŭ                                
    AXT_RT_7TH_BELOW_MIN_VALUE          = 1220;       // �ϰ���° ���ڰ��� �ּҰ����� �� ����                              
    AXT_RT_7TH_ABOVE_MAX_VALUE          = 1221;       // �ϰ���° ���ڰ��� �ִ밪���� �� ŭ                                
    AXT_RT_8TH_BELOW_MIN_VALUE          = 1230;       // ������° ���ڰ��� �ּҰ����� �� ����                              
    AXT_RT_8TH_ABOVE_MAX_VALUE          = 1231;       // ������° ���ڰ��� �ִ밪���� �� ŭ                                
    AXT_RT_9TH_BELOW_MIN_VALUE          = 1240;       // ��ȩ��° ���ڰ��� �ּҰ����� �� ����                              
    AXT_RT_9TH_ABOVE_MAX_VALUE          = 1241;       // ��ȩ��° ���ڰ��� �ִ밪���� �� ŭ                                
    AXT_RT_10TH_BELOW_MIN_VALUE         = 1250;       // ����° ���ڰ��� �ּҰ����� �� ����                                
    AXT_RT_10TH_ABOVE_MAX_VALUE         = 1251;       // ����° ���ڰ��� �ִ밪���� �� ŭ                                  
    AXT_RT_AIO_OPEN_ERROR               = 2001;       // AIO ��� ���½���                                                 
    AXT_RT_AIO_NOT_MODULE               = 2051;       // AIO ��� ����                                                     
    AXT_RT_AIO_NOT_EVENT                = 2052;       // AIO �̺�Ʈ ���� ����                                              
    AXT_RT_AIO_INVALID_MODULE_NO        = 2101;       // ��ȿ�������� AIO���                                              
    AXT_RT_AIO_INVALID_CHANNEL_NO       = 2102;       // ��ȿ�������� AIOä�ι�ȣ                                          
    AXT_RT_AIO_INVALID_USE              = 2106;       // AIO �Լ� ������                                                 
    AXT_RT_AIO_INVALID_TRIGGER_MODE     = 2107;       // ��ȿ�����ʴ� Ʈ���� ���                                          
    AXT_RT_AIO_EXTERNAL_DATA_EMPTY      = 2108;
    AXT_RT_DIO_OPEN_ERROR               = 3001;       // DIO ��� ���½���                                                 
    AXT_RT_DIO_NOT_MODULE               = 3051;       // DIO ��� ����                                                     
    AXT_RT_DIO_NOT_INTERRUPT            = 3052;       // DIO ���ͷ�Ʈ �����ȵ�                                             
    AXT_RT_DIO_INVALID_MODULE_NO        = 3101;       // ��ȿ�����ʴ� DIO ��� ��ȣ                                        
    AXT_RT_DIO_INVALID_OFFSET_NO        = 3102;       // ��ȿ�����ʴ� DIO OFFSET ��ȣ                                      
    AXT_RT_DIO_INVALID_LEVEL            = 3103;       // ��ȿ�����ʴ� DIO ����                                             
    AXT_RT_DIO_INVALID_MODE             = 3104;       // ��ȿ�����ʴ� DIO ���                                             
    AXT_RT_DIO_INVALID_VALUE            = 3105;       // ��ȿ�����ʴ� �� ����                                              
    AXT_RT_DIO_INVALID_USE              = 3106;       // DIO �Լ� ������                                                 
    AXT_RT_MOTION_OPEN_ERROR            = 4001;       // ��� ���̺귯�� Open ����                                         
    AXT_RT_MOTION_NOT_MODULE            = 4051;       // �ý��ۿ� ������ ��� ����� ����                                  
    AXT_RT_MOTION_NOT_INTERRUPT         = 4052;       // ���ͷ�Ʈ ��� �б� ����                                           
    AXT_RT_MOTION_NOT_INITIAL_AXIS_NO   = 4053;       // �ش� �� ��� �ʱ�ȭ ����                                          
    AXT_RT_MOTION_NOT_IN_CONT_INTERPOL  = 4054;       // ���� ���� ���� ���� �ƴ� ���¿��� ���Ӻ��� ���� ����� ���� �Ͽ���
    AXT_RT_MOTION_NOT_PARA_READ         = 4055;       // ���� ���� ���� �Ķ���� �ε� ����                                 
    AXT_RT_MOTION_INVALID_AXIS_NO       = 4101;       // �ش� ���� �������� ����                                           
    AXT_RT_MOTION_INVALID_METHOD        = 4102;       // �ش� �� ������ �ʿ��� ������ �߸���                               
    AXT_RT_MOTION_INVALID_USE           = 4103;       // 'uUse' ���ڰ��� �߸� ������                                       
    AXT_RT_MOTION_INVALID_LEVEL         = 4104;       // 'uLevel' ���ڰ��� �߸� ������                                     
    AXT_RT_MOTION_INVALID_BIT_NO        = 4105;       // ���� ����� �ش� ��Ʈ�� �߸� ������                               
    AXT_RT_MOTION_INVALID_STOP_MODE     = 4106;       // ��� ���� ��� �������� �߸���                                    
    AXT_RT_MOTION_INVALID_TRIGGER_MODE  = 4107;       // Ʈ���� ���� ��尡 �߸� ������                                    
    AXT_RT_MOTION_INVALID_TRIGGER_LEVEL = 4108;       // Ʈ���� ��� ���� ������ �߸���                                        
    AXT_RT_MOTION_INVALID_SELECTION     = 4109;       // 'uSelection' ���ڰ� COMMAND �Ǵ� ACTUAL �̿��� ������ �����Ǿ� ����   
    AXT_RT_MOTION_INVALID_TIME          = 4110;       // Trigger ��� �ð����� �߸� �����Ǿ� ����                              
    AXT_RT_MOTION_INVALID_FILE_LOAD     = 4111;       // ��� �������� ����� ������ �ε尡 �ȵ�                               
    AXT_RT_MOTION_INVALID_FILE_SAVE     = 4112;       // ��� �������� �����ϴ� ���� ���忡 ������                             
    AXT_RT_MOTION_INVALID_VELOCITY      = 4113;       // ��� ���� �ӵ����� 0���� �����Ǿ� ��� ���� �߻�                      
    AXT_RT_MOTION_INVALID_ACCELTIME     = 4114;       // ��� ���� ���� �ð����� 0���� �����Ǿ� ��� ���� �߻�                 
    AXT_RT_MOTION_INVALID_PULSE_VALUE   = 4115;       // ��� ���� ���� �� �Է� �޽����� 0���� ���������� ������               
    AXT_RT_MOTION_INVALID_NODE_NUMBER   = 4116;       // ��ġ�� �ӵ� �������̵� �Լ��� ��� ���� �߿� ���ܵ�                   
    AXT_RT_MOTION_INVALID_TARGET        = 4117;       // ���� ��� ���� ���ο� ���� �÷��׸� ��ȯ�Ѵ�.                         
    AXT_RT_MOTION_ERROR_IN_NONMOTION    = 4151;       // ��� �������̾�� �Ǵµ� ��� �������� �ƴ� ��                        
    AXT_RT_MOTION_ERROR_IN_MOTION       = 4152;       // ��� ���� �߿� �ٸ� ��� ���� �Լ��� ������                           
    AXT_RT_MOTION_ERROR                 = 4153;       // ���� ���� ���� �Լ� ���� �� ���� �߻���                               
    AXT_RT_MOTION_ERROR_GANTRY_ENABLE   = 4154;       // ��Ʈ�� enable�� �Ǿ��־� ������� �� �� ��Ʈ�� enable�� ������ ��     
    AXT_RT_MOTION_ERROR_GANTRY_AXIS     = 4155;       // ��Ʈ�� ���� ������ä��(��) ��ȣ(0 ~ (�ִ���� - 1))�� �߸� ���� ��
    AXT_RT_MOTION_ERROR_MASTER_SERVOON  = 4156;       // ������ �� �������� �ȵǾ����� ��                                      
    AXT_RT_MOTION_ERROR_SLAVE_SERVOON   = 4157;       // �����̺� �� �������� �ȵǾ����� ��                                    
    AXT_RT_MOTION_INVALID_POSITION      = 4158;       // ��ȿ�� ��ġ�� ���� ��                                                 
    AXT_RT_ERROR_NOT_SAME_MODULE        = 4159;       // �� ���� ��⳻�� ���� �������                                        
    AXT_RT_ERROR_NOT_SAME_BOARD         = 4160;       // �� ���� ���峻�� ���� �ƴҰ��                                        
    AXT_RT_ERROR_NOT_SAME_PRODUCT       = 4161;       // ��ǰ�� ���� �ٸ����                                                  
    AXT_RT_NOT_CAPTURED                 = 4162;       // ��ġ�� ������� ���� ��                                               
    AXT_RT_ERROR_NOT_SAME_IC            = 4163;       // ���� Ĩ���� ������������ ��                                           
    AXT_RT_ERROR_NOT_GEARMODE           = 4164;       // ������ ��ȯ�� �ȵ� ��                                             
    AXT_ERROR_CONTI_INVALID_AXIS_NO     = 4165;       // ���Ӻ��� ����� �� ��ȿ�� ���� �ƴ� ��                                
    AXT_ERROR_CONTI_INVALID_MAP_NO      = 4166;       // ���Ӻ��� ���� �� ��ȿ�� ���� ��ȣ�� �ƴ� ��                           
    AXT_ERROR_CONTI_EMPTY_MAP_NO        = 4167;       // ���Ӻ��� ���� ��ȣ�� ��� ���� ��                                     
    AXT_RT_MOTION_ERROR_CACULATION      = 4168;       // ������ ������ �߻����� ��                                           
    AXT_RT_ERROR_MOVE_SENSOR_CHECK      = 4169;       // ���� ������ Error������(Alarm, EMG, End Limit��) �����Ǿ��� ��    
    AXT_ERROR_HELICAL_INVALID_AXIS_NO   = 4170;       // �︮�� �� ���� �� ��ȿ�� ���� �ƴ� ��                                 
    AXT_ERROR_HELICAL_INVALID_MAP_NO    = 4171;       // �︮�� ���� �� ��ȿ�� ���� ��ȣ�� �ƴ�  ��                            
    AXT_ERROR_HELICAL_EMPTY_MAP_NO      = 4172;       // �︮�� ���� ��ȣ�� ��� ���� ��                                       
    AXT_ERROR_SPLINE_INVALID_AXIS_NO    = 4180;       // ���ö��� �� ���� �� ��ȿ�� ���� �ƴ� ��         
    AXT_ERROR_SPLINE_INVALID_MAP_NO     = 4181;       // ���ö��� ���� �� ��ȿ�� ���� ��ȣ�� �ƴ� ��     
    AXT_ERROR_SPLINE_EMPTY_MAP_NO       = 4182;       // ���ö��� ���� ��ȣ�� ������� ��                
    AXT_ERROR_SPLINE_NUM_ERROR          = 4183;       // ���ö��� �����ڰ� �������� ��                   
    AXT_RT_MOTION_INTERPOL_VALUE        = 4184;       // ������ �� �Է� ���� �߸��־����� ��             
    AXT_RT_ERROR_NOT_CONTIBEGIN         = 4185;       // ���Ӻ��� �� �� CONTIBEGIN�Լ��� ȣ������ ���� ��
    AXT_RT_ERROR_NOT_CONTIEND           = 4186;       // ���Ӻ��� �� �� CONTIEND�Լ��� ȣ������ ���� ��  
    AXT_RT_MOTION_HOME_SEARCHING        = 4201;       // Ȩ�� ã�� �ִ� ���� �� �ٸ� ��� �Լ����� ����� ��                            
    AXT_RT_MOTION_HOME_ERROR_SEARCHING  = 4202;       // Ȩ�� ã�� �ִ� ���� �� �ܺο��� ����ڳ� Ȥ�� ��Ϳ� ����  ������ �������� ��
    AXT_RT_MOTION_HOME_ERROR_START      = 4203;       // �ʱ�ȭ ������ Ȩ���� �Ұ��� ��                                                 
    AXT_RT_MOTION_HOME_ERROR_GANTRY     = 4204;       // Ȩ�� ã�� �ִ� ���� �� ��Ʈ�� enable �Ұ��� ��                                 
    AXT_RT_MOTION_POSITION_OUTOFBOUND   = 4251;       // ������ ��ġ���� ���� �ִ밪���� ũ�ų� �ּҰ����� ��������                     
    AXT_RT_MOTION_PROFILE_INVALID       = 4252;       // ���� �ӵ� �������� ������ �߸���                                               
    AXT_RT_MOTION_VELOCITY_OUTOFBOUND   = 4253;       // ���� �ӵ����� �ִ밪���� ũ�� ������                                           
    AXT_RT_MOTION_MOVE_UNIT_IS_ZERO     = 4254;       // ���� �������� 0���� ������                                                     
    AXT_RT_MOTION_SETTING_ERROR         = 4255;       // �ӵ�, ���ӵ�, ��ũ, �������� ������ �߸���                                     
    AXT_RT_MOTION_IN_CONT_INTERPOL      = 4256;       // ���� ���� ���� �� ���� ���� �Ǵ� ����� �Լ��� �����Ͽ���                      
    AXT_RT_MOTION_DISABLE_TRIGGER       = 4257;       // Ʈ���� ����� Disable ������                                                   
    AXT_RT_MOTION_INVALID_CONT_INDEX    = 4258;       // ���� ���� Index�� ������ �߸���                                                
    AXT_RT_MOTION_CONT_QUEUE_FULL       = 4259;       // ��� Ĩ�� ���� ���� ť�� Full ������                                           
    AXT_RT_PROTECTED_DURING_SERVOON     = 4260;       // ���� �� �Ǿ� �ִ� ���¿��� ��� �� ��                                          
    AXT_RT_HW_ACCESS_ERROR              = 4261;       // �޸� Read / Write ����                                                      
    { �α׷��� ����                     }
    LEVEL_NONE                          = 0;
    LEVEL_ERROR                         = 1;
    LEVEL_RUNSTOP                       = 2;
    LEVEL_FUNCTION                      = 3;
    { �����ǰ �� ���� ����               }
    STATUS_NOTEXIST                     = 0;
    STATUS_EXIST                        = 1;
    { ��� ���� ����                    }
    DISABLE                             = 0;
    ENABLE                              = 1;
    { AI��ǰ Ʈ���� �������            }
    DISABLE_MODE                        = 0;
    NORMAL_MODE                         = 1;
    TIMER_MODE                          = 2;
    EXTERNAL_MODE                       = 3;
    { AI��ǰ ����Ÿť ����� ����     }
    NEW_DATA_KEEP                       = 0;
    CURR_DATA_KEEP                      = 1;
    { AI��ǰ ����Ÿť ���� ����         }
    DATA_EMPTY                          = $01;
    DATA_MANY                           = $02;
    DATA_SMALL                          = $04;
    DATA_FULL                           = $08;
    { AI(16H)��ǰ ����Ÿť ���� ����    }
    ADC_DONE                            = $00;
    SCAN_END                            = $01;
    FIFO_HALF_FULL                      = $02;
    NO_SIGNAL                           = $03;
    { AI��ǰ ���ͷ�Ʈ ���� ����         } 
    AIO_EVENT_DATA_RESET                = $00;
    AIO_EVENT_DATA_UPPER                = $1;
    AIO_EVENT_DATA_LOWER                = $2;
    AIO_EVENT_DATA_FULL                 = $3;
    AIO_EVENT_DATA_EMPTY                = $4;
    { DI��ǰ �Է� ���� ����             }
    DOWN_EDGE                           = 0;
    UP_EDGE                             = 1;
    { DIO��ǰ ���� ���� ����            }
    OFF_STATE                           = 0;
    ON_STATE                            = 1;
    { �����ǰ ���� ��� ����           }
    EMERGENCY_STOP                      = 0;
    SLOWDOWN_STOP                       = 1;
    { �����ǰ ��ȣ ���� ����           }
    SIGNAL_UP_EDGE                      = 0;
    SIGNAL_DOWN_EDGE                    = 1;
    { �����ǰ ī��Ʈ ���� ����         }
    COMMAND                             = 0;
    ACTUAL                              = 1;
    { �����ǰ Ʈ���� ��� ����         }
    PERIOD_MODE                         = 0;
    ABS_POS_MODE                        = 1;
    { �����ǰ �Է½�ȣ ���� ����       }
    LOW                                 = 0;
    HIGH                                = 1;
    UNUSED                              = 2;
    USED                                = 3;
    { �����ǰ ���� ��ǥ�� ����         }
    POS_ABS_MODE                        = 0;
    POS_REL_MODE                        = 1;
    { �����ǰ ���� �������� ����       }
    SYM_TRAPEZOIDE_MODE                 = 0;
    ASYM_TRAPEZOIDE_MODE                = 1;
    QUASI_S_CURVE_MODE                  = 2;
    SYM_S_CURVE_MODE                    = 3;
    ASYM_S_CURVE_MODE                   = 4;
    { �����ǰ ��ȣ ���� ����           }
    INACTIVE                            = 0;
    ACTIVE                              = 1;
    { �����ǰ �����˻� ��� ����       }
    HOME_SUCCESS                        = $01;
    HOME_SEARCHING                      = $02;
    HOME_ERR_GNT_RANGE                  = $10;
    HOME_ERR_USER_BREAK                 = $11;
    HOME_ERR_VELOCITY                   = $12;
    HOME_ERR_AMP_FAULT                  = $13;        // ������ �˶� �߻� ����                  
    HOME_ERR_NEG_LIMIT                  = $14;        // (-)���� ������ (+)����Ʈ ���� ���� ����
    HOME_ERR_POS_LIMIT                  = $15;        // (+)���� ������ (-)����Ʈ ���� ���� ����
    HOME_ERR_NOT_DETECT                 = $16;        // ������ ��ȣ �������� �� �� ��� ����   
    HOME_ERR_UNKNOWN                    = $FF;
    { �����ǰ �Է����� ����            }
    UIO_INP0                            = 0;
    UIO_INP1                            = 1;
    UIO_INP2                            = 2;
    UIO_INP3                            = 3;
    UIO_INP4                            = 4;
    UIO_INP5                            = 5;
    { �����ǰ ������� ����            }
    UIO_OUT0                            = 0;
    UIO_OUT1                            = 1;
    UIO_OUT2                            = 2;
    UIO_OUT3                            = 3;
    UIO_OUT4                            = 4;
    UIO_OUT5                            = 5;
    { �����ǰ ������ ��� ����         }
    AutoDetect                          = 0;
    RestPulse                           = 1;
    { �����ǰ �޽� ��¹�� ����       }
    OneHighLowHigh                      = $0;         // 1�޽� ���; PULSE(Active High), ������(DIR=Low)  / ������(DIR=High)    
    OneHighHighLow                      = $1;         // 1�޽� ���, PULSE(Active High), ������(DIR=High) / ������(DIR=Low)     
    OneLowLowHigh                       = $2;         // 1�޽� ���, PULSE(Active Low),  ������(DIR=Low)  / ������(DIR=High)    
    OneLowHighLow                       = $3;         // 1�޽� ���, PULSE(Active Low),  ������(DIR=High) / ������(DIR=Low)     
    TwoCcwCwHigh                        = $4;         // 2�޽� ���, PULSE(CCW:������),  DIR(CW:������),  Active High           
    TwoCcwCwLow                         = $5;         // 2�޽� ���, PULSE(CCW:������),  DIR(CW:������),  Active Low            
    TwoCwCcwHigh                        = $6;         // 2�޽� ���, PULSE(CW:������),   DIR(CCW:������), Active High           
    TwoCwCcwLow                         = $7;         // 2�޽� ���, PULSE(CW:������),   DIR(CCW:������), Active Low            
    TwoPhase                            = $8;         // 2��(90' ������),  PULSE lead DIR(CW: ������), PULSE lag DIR(CCW:������)
    TwoPhaseReverse                     = $9;         // 2��(90' ������),  PULSE lead DIR(CCW: ������), PULSE lag DIR(CW:������)
    { �����ǰ ���ڴ� �Է¹�� ����     }
    ObverseUpDownMode                   = $0;         // ������ Up/Down 
    ObverseSqr1Mode                     = $1;         // ������ 1ü��   
    ObverseSqr2Mode                     = $2;         // ������ 2ü��   
    ObverseSqr4Mode                     = $3;         // ������ 4ü��   
    ReverseUpDownMode                   = $4;         // ������ Up/Down 
    ReverseSqr1Mode                     = $5;         // ������ 1ü��   
    ReverseSqr2Mode                     = $6;         // ������ 2ü��   
    ReverseSqr4Mode                     = $7;         // ������ 4ü��   
    { �����ǰ ������ ���� ����         }
    UNIT_SEC2                           = $0;         // unit/sec2
    SEC                                 = $1;         // sec
    RPM_SEC2                            = $2;         // rpm/sec2
    { �����ǰ �������� ����            }
    DIR_CCW                             = $0;         // �ݽð����
    DIR_CW                              = $1;         // �ð����  
    { �����ǰ ��ȣ���� ��� ����       }
    SHORT_DISTANCE                      = $0;         // ª�� �Ÿ��� ��ȣ �̵�
    LONG_DISTANCE                       = $1;         // �� �Ÿ��� ��ȣ �̵�  
    { �����ǰ ���� ����� ����         }
    INTERPOLATION_AXIS2                 = $0;         // 2���� �������� ����� ��
    INTERPOLATION_AXIS3                 = $1;         // 3���� �������� ����� ��
    INTERPOLATION_AXIS4                 = $2;         // 4���� �������� ����� ��
    { �����ǰ ���Ӻ��� ��� ����       }
    CONTI_NODE_VELOCITY                 = $0;         // �ӵ� ���� ���� ���  
    CONTI_NODE_MANUAL                   = $1;         // ��� ������ ���� ���
    CONTI_NODE_AUTO                     = $2;         // �ڵ� ������ ���� ���
    { �����ǰ �����ȣ ����            }
    PosEndLimit                         = $0;         // +Elm(End limit) +���� ����Ʈ ���� ��ȣ    
    NegEndLimit                         = $1;         // -Elm(End limit) -���� ����Ʈ ���� ��ȣ    
    PosSloLimit                         = $2;         // +Slm(Slow Down limit) ��ȣ - ������� ����
    NegSloLimit                         = $3;         // -Slm(Slow Down limit) ��ȣ - ������� ����
    HomeSensor                          = $4;         // IN0(ORG)  ���� ���� ��ȣ                  
    EncodZPhase                         = $5;         // IN1(Z��)  Encoder Z�� ��ȣ                
    UniInput02                          = $6;         // IN2(����) ���� �Է� 2�� ��ȣ              
    UniInput03                          = $7;         // IN3(����) ���� �Է� 3�� ��ȣ              
    { �����ǰ MPG ��ȣ �Է¹�� ����   }
    MPG_DIFF_ONE_PHASE                  = $0;         // MPG �Է� ��� One Phase       
    MPG_DIFF_TWO_PHASE_1X               = $1;         // MPG �Է� ��� TwoPhase1       
    MPG_DIFF_TWO_PHASE_2X               = $2;         // MPG �Է� ��� TwoPhase2       
    MPG_DIFF_TWO_PHASE_4X               = $3;         // MPG �Է� ��� TwoPhase4       
    MPG_LEVEL_ONE_PHASE                 = $4;         // MPG �Է� ��� Level One Phase 
    MPG_LEVEL_TWO_PHASE_1X              = $5;         // MPG �Է� ��� Level Two Phase1
    MPG_LEVEL_TWO_PHASE_2X              = $6;         // MPG �Է� ��� Level Two Phase2
    MPG_LEVEL_TWO_PHASE_4X              = $7;         // MPG �Է� ��� Level Two Phase4
    { �����ǰ �������� ������� ����   }
    SENSOR_METHOD1                      = $0;         // �Ϲ� ����                                            
    SENSOR_METHOD2                      = $1;         // ���� ��ȣ ���� ���� ���� ����. ��ȣ ���� �� �Ϲ� ����
    SENSOR_METHOD3                      = $2;         // ���� ����                                            
    { �����ǰ �ܿ��޽� ���� ��� ����  }
    CRC_SELECT1                         = $0;         // ��ġŬ���� ������, �ܿ��޽� Ŭ���� ��� ����
    CRC_SELECT2                         = $1;         // ��ġŬ���� �����, �ܿ��޽� Ŭ���� ��� ����  
    CRC_SELECT3                         = $2;         // ��ġŬ���� ������, �ܿ��޽� Ŭ���� �����   
    CRC_SELECT4                         = $3;         // ��ġŬ���� �����, �ܿ��޽� Ŭ���� �����     
    { �����ǰ(IP) ��ȣ���� ���� ����   }
    PElmNegativeEdge                    = $0;         // +Elm(End limit) �ϰ� edge     
    NElmNegativeEdge                    = $1;         // -Elm(End limit) �ϰ� edge     
    PSlmNegativeEdge                    = $2;         // +Slm(Slowdown limit) �ϰ� edge
    NSlmNegativeEdge                    = $3;         // -Slm(Slowdown limit) �ϰ� edge
    In0DownEdge                         = $4;         // IN0(ORG) �ϰ� edge            
    In1DownEdge                         = $5;         // IN1(Z��) �ϰ� edge            
    In2DownEdge                         = $6;         // IN2(����) �ϰ� edge           
    In3DownEdge                         = $7;         // IN3(����) �ϰ� edge           
    PElmPositiveEdge                    = $8;         // +Elm(End limit) ��� edge     
    NElmPositiveEdge                    = $9;         // -Elm(End limit) ��� edge     
    PSlmPositiveEdge                    = $a;         // +Slm(Slowdown limit) ��� edge
    NSlmPositiveEdge                    = $b;         // -Slm(Slowdown limit) ��� edge
    In0UpEdge                           = $c;         // IN0(ORG) ��� edge            
    In1UpEdge                           = $d;         // IN1(Z��) ��� edge            
    In2UpEdge                           = $e;         // IN2(����) ��� edge           
    In3UpEdge                           = $f;         // IN3(����) ��� edge           
    { �����ǰ(IP) �������� ���� ����   }             // When 0x0000 after normal drive end.
    IPEND_STATUS_SLM                    = $0001;      // Bit 0, limit �������� ��ȣ �Է¿� ���� ����                
    IPEND_STATUS_ELM                    = $0002;      // Bit 1, limit ������ ��ȣ �Է¿� ���� ����                  
    IPEND_STATUS_SSTOP_SIGNAL           = $0004;      // Bit 2, ���� ���� ��ȣ �Է¿� ���� ����                     
    IPEND_STATUS_ESTOP_SIGANL           = $0008;      // Bit 3, ������ ��ȣ �Է¿� ���� ����                        
    IPEND_STATUS_SSTOP_COMMAND          = $0010;      // Bit 4, ���� ���� ��ɿ� ���� ����                          
    IPEND_STATUS_ESTOP_COMMAND          = $0020;      // Bit 5, ������ ���� ��ɿ� ���� ����                        
    IPEND_STATUS_ALARM_SIGNAL           = $0040;      // Bit 6, Alarm ��ȣ �Է¿� ���� ����                         
    IPEND_STATUS_DATA_ERROR             = $0080;      // Bit 7, ������ ���� ������ ���� ����                        
    IPEND_STATUS_DEVIATION_ERROR        = $0100;      // Bit 8, Ż�� ������ ���� ����                               
    IPEND_STATUS_ORIGIN_DETECT          = $0200;      // Bit 9, ���� ���⿡ ���� ����                               
    IPEND_STATUS_SIGNAL_DETECT          = $0400;      // Bit 10, ��ȣ ���⿡ ���� ����(Signal search-1/2 drive ����)
    IPEND_STATUS_PRESET_PULSE_DRIVE     = $0800;      // Bit 11, Preset pulse drive ����                            
    IPEND_STATUS_SENSOR_PULSE_DRIVE     = $1000;      // Bit 12, Sensor pulse drive ����                            
    IPEND_STATUS_LIMIT                  = $2000;      // Bit 13, Limit ���������� ���� ����                         
    IPEND_STATUS_SOFTLIMIT              = $4000;      // Bit 14, Soft limit�� ���� ����                             
    IPEND_STATUS_INTERPOLATION_DRIVE    = $8000;      // Bit 15, Soft limit�� ���� ����                             
    { �����ǰ(IP) �������� ����        }
    IPDRIVE_STATUS_BUSY                 = $00001;     // Bit 0, BUSY(����̺� ���� ��)                         
    IPDRIVE_STATUS_DOWN                 = $00002;     // Bit 1, DOWN(���� ��)                                  
    IPDRIVE_STATUS_CONST                = $00004;     // Bit 2, CONST(��� ��)                                 
    IPDRIVE_STATUS_UP                   = $00008;     // Bit 3, UP(���� ��)                                    
    IPDRIVE_STATUS_ICL                  = $00010;     // Bit 4, ICL(���� ��ġ ī���� < ���� ��ġ ī���� �񱳰�)
    IPDRIVE_STATUS_ICG                  = $00020;     // Bit 5, ICG(���� ��ġ ī���� > ���� ��ġ ī���� �񱳰�)
    IPDRIVE_STATUS_ECL                  = $00040;     // Bit 6, ECL(�ܺ� ��ġ ī���� < �ܺ� ��ġ ī���� �񱳰�)
    IPDRIVE_STATUS_ECG                  = $00080;     // Bit 7, ECG(�ܺ� ��ġ ī���� > �ܺ� ��ġ ī���� �񱳰�)
    IPDRIVE_STATUS_DRIVE_DIRECTION      = $00100;     // Bit 8, ����̺� ���� ��ȣ(0=CW/1=CCW)                 
    IPDRIVE_STATUS_COMMAND_BUSY         = $00200;     // Bit 9, ��ɾ� ������                                  
    IPDRIVE_STATUS_PRESET_DRIVING       = $00400;     // Bit 10, Preset pulse drive ��                         
    IPDRIVE_STATUS_CONTINUOUS_DRIVING   = $00800;     // Bit 11, Continuouse speed drive ��                    
    IPDRIVE_STATUS_SIGNAL_SEARCH_DRIVING= $01000;     // Bit 12, Signal search-1/2 drive ��                    
    IPDRIVE_STATUS_ORG_SEARCH_DRIVING   = $02000;     // Bit 13, ���� ���� drive ��                            
    IPDRIVE_STATUS_MPG_DRIVING          = $04000;     // Bit 14, MPG drive ��                                  
    IPDRIVE_STATUS_SENSOR_DRIVING       = $08000;     // Bit 15, Sensor positioning drive ��                   
    IPDRIVE_STATUS_L_C_INTERPOLATION    = $10000;     // Bit 16, ����/��ȣ ���� ��                             
    IPDRIVE_STATUS_PATTERN_INTERPOLATION= $20000;     // Bit 17, ��Ʈ ���� ���� ��                             
    IPDRIVE_STATUS_INTERRUPT_BANK1      = $40000;     // Bit 18, ���ͷ�Ʈ bank1���� �߻�                       
    IPDRIVE_STATUS_INTERRUPT_BANK2      = $80000;     // Bit 19, ���ͷ�Ʈ bank2���� �߻�                       
    { �����ǰ(IP) ���ͷ�Ʈ ����        }
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
    { �����ǰ(IP) ��ȣ���� ���� ����   }
    IPMECHANICAL_PELM_LEVEL             = $0001;      // Bit 0, +Limit ������ ��ȣ�� ��Ƽ�� ��  
    IPMECHANICAL_NELM_LEVEL             = $0002;      // Bit 1, -Limit ������ ��ȣ ��Ƽ�� ��    
    IPMECHANICAL_PSLM_LEVEL             = $0004;      // Bit 2, +limit �������� ��ȣ ��Ƽ�� ��  
    IPMECHANICAL_NSLM_LEVEL             = $0008;      // Bit 3, -limit �������� ��ȣ ��Ƽ�� ��  
    IPMECHANICAL_ALARM_LEVEL            = $0010;      // Bit 4, Alarm ��ȣ ��Ƽ�� ��            
    IPMECHANICAL_INP_LEVEL              = $0020;      // Bit 5, Inposition ��ȣ ��Ƽ�� ��       
    IPMECHANICAL_ENC_DOWN_LEVEL         = $0040;      // Bit 6, ���ڴ� DOWN(B��) ��ȣ �Է� Level
    IPMECHANICAL_ENC_UP_LEVEL           = $0080;      // Bit 7, ���ڴ� UP(A��) ��ȣ �Է� Level  
    IPMECHANICAL_EXMP_LEVEL             = $0100;      // Bit 8, EXMP ��ȣ �Է� Level            
    IPMECHANICAL_EXPP_LEVEL             = $0200;      // Bit 9, EXPP ��ȣ �Է� Level            
    IPMECHANICAL_MARK_LEVEL             = $0400;      // Bit 10, MARK# ��ȣ ��Ƽ�� ��           
    IPMECHANICAL_SSTOP_LEVEL            = $0800;      // Bit 11, SSTOP ��ȣ ��Ƽ�� ��           
    IPMECHANICAL_ESTOP_LEVEL            = $1000;      // Bit 12, ESTOP ��ȣ ��Ƽ�� ��           
    IPMECHANICAL_SYNC_LEVEL             = $2000;      // Bit 13, SYNC ��ȣ �Է� Level           
    IPMECHANICAL_MODE8_16_LEVEL         = $4000;      // Bit 14, MODE8_16 ��ȣ �Է� Level       
    { �����ǰ(QI) ��ȣ���� ���� ����   }
    Signal_PosEndLimit                  = $0;         // +Elm(End limit) +���� ����Ʈ ���� ��ȣ    
    Signal_NegEndLimit                  = $1;         // -Elm(End limit) -���� ����Ʈ ���� ��ȣ    
    Signal_PosSloLimit                  = $2;         // +Slm(Slow Down limit) ��ȣ - ������� ����
    Signal_NegSloLimit                  = $3;         // -Slm(Slow Down limit) ��ȣ - ������� ����
    Signal_HomeSensor                   = $4;         // IN0(ORG)  ���� ���� ��ȣ                  
    Signal_EncodZPhase                  = $5;         // IN1(Z��)  Encoder Z�� ��ȣ                
    Signal_UniInput02                   = $6;         // IN2(����) ���� �Է� 2�� ��ȣ              
    Signal_UniInput03                   = $7;         // IN3(����) ���� �Է� 3�� ��ȣ              
    { �����ǰ(QI) ��ȣ���� ���� ����   }
    QIMECHANICAL_PELM_LEVEL             = $00001;     // Bit 0, +Limit ������ ��ȣ ���� ����    
    QIMECHANICAL_NELM_LEVEL             = $00002;     // Bit 1, -Limit ������ ��ȣ ���� ����    
    QIMECHANICAL_PSLM_LEVEL             = $00004;     // Bit 2, +limit �������� ���� ����.      
    QIMECHANICAL_NSLM_LEVEL             = $00008;     // Bit 3, -limit �������� ���� ����       
    QIMECHANICAL_ALARM_LEVEL            = $00010;     // Bit 4, Alarm ��ȣ ��ȣ ���� ����       
    QIMECHANICAL_INP_LEVEL              = $00020;     // Bit 5, Inposition ��ȣ ���� ����       
    QIMECHANICAL_ESTOP_LEVEL            = $00040;     // Bit 6, ��� ���� ��ȣ(ESTOP) ���� ����.
    QIMECHANICAL_ORG_LEVEL              = $00080;     // Bit 7, ���� ��ȣ ���� ����             
    QIMECHANICAL_ZPHASE_LEVEL           = $00100;     // Bit 8, Z �� �Է� ��ȣ ���� ����        
    QIMECHANICAL_ECUP_LEVEL             = $00200;     // Bit 9, ECUP �͹̳� ��ȣ ����.          
    QIMECHANICAL_ECDN_LEVEL             = $00400;     // Bit 10, ECDN �͹̳� ��ȣ ����.         
    QIMECHANICAL_EXPP_LEVEL             = $00800;     // Bit 11, EXPP �͹̳� ��ȣ ����          
    QIMECHANICAL_EXMP_LEVEL             = $01000;     // Bit 12, EXMP �͹̳� ��ȣ ����          
    QIMECHANICAL_SQSTR1_LEVEL           = $02000;     // Bit 13, SQSTR1 �͹̳� ��ȣ ����        
    QIMECHANICAL_SQSTR2_LEVEL           = $04000;     // Bit 14, SQSTR2 �͹̳� ��ȣ ����        
    QIMECHANICAL_SQSTP1_LEVEL           = $08000;     // Bit 15, SQSTP1 �͹̳� ��ȣ ����        
    QIMECHANICAL_SQSTP2_LEVEL           = $10000;     // Bit 16, SQSTP2 �͹̳� ��ȣ ����        
    QIMECHANICAL_MODE_LEVEL             = $20000;     // Bit 17, MODE �͹̳� ��ȣ ����.         
    {  �����ǰ(QI) �������� ���� ����  }             // When 0x0000 after normal drive end.
    QIEND_STATUS_0                      = $00000001;  // Bit 0, ������ ����Ʈ ��ȣ(PELM)�� ���� ����               
    QIEND_STATUS_1                      = $00000002;  // Bit 1, ������ ����Ʈ ��ȣ(NELM)�� ���� ����               
    QIEND_STATUS_2                      = $00000004;  // Bit 2, ������ �ΰ� ����Ʈ ��ȣ(PSLM)�� ���� ���� ����     
    QIEND_STATUS_3                      = $00000008;  // Bit 3, ������ �ΰ� ����Ʈ ��ȣ(NSLM)�� ���� ���� ����     
    QIEND_STATUS_4                      = $00000010;  // Bit 4, ������ ����Ʈ ����Ʈ ������ ��ɿ� ���� ���� ����  
    QIEND_STATUS_5                      = $00000020;  // Bit 5, ������ ����Ʈ ����Ʈ ������ ��ɿ� ���� ���� ����  
    QIEND_STATUS_6                      = $00000040;  // Bit 6, ������ ����Ʈ ����Ʈ �������� ��ɿ� ���� ���� ����
    QIEND_STATUS_7                      = $00000080;  // Bit 7, ������ ����Ʈ ����Ʈ �������� ��ɿ� ���� ���� ����
    QIEND_STATUS_8                      = $00000100;  // Bit 8, ���� �˶� ��ɿ� ���� ���� ����.                   
    QIEND_STATUS_9                      = $00000200;  // Bit 9, ��� ���� ��ȣ �Է¿� ���� ���� ����.              
    QIEND_STATUS_10                     = $00000400;  // Bit 10, �� ���� ��ɿ� ���� ���� ����.                    
    QIEND_STATUS_11                     = $00000800;  // Bit 11, ���� ���� ��ɿ� ���� ���� ����.                  
    QIEND_STATUS_12                     = $00001000;  // Bit 12, ���� ������ ��ɿ� ���� ���� ����                 
    QIEND_STATUS_13                     = $00002000;  // Bit 13, ���� ���� ��� #1(SQSTP1)�� ���� ���� ����.       
    QIEND_STATUS_14                     = $00004000;  // Bit 14, ���� ���� ��� #2(SQSTP2)�� ���� ���� ����.       
    QIEND_STATUS_15                     = $00008000;  // Bit 15, ���ڴ� �Է�(ECUP,ECDN) ���� �߻�                  
    QIEND_STATUS_16                     = $00010000;  // Bit 16, MPG �Է�(EXPP,EXMP) ���� �߻�                     
    QIEND_STATUS_17                     = $00020000;  // Bit 17, ���� �˻� ���� ����.                              
    QIEND_STATUS_18                     = $00040000;  // Bit 18, ��ȣ �˻� ���� ����.                              
    QIEND_STATUS_19                     = $00080000;  // Bit 19, ���� ������ �̻����� ���� ����.                   
    QIEND_STATUS_20                     = $00100000;  // Bit 20, ������ ���� �����߻�.                             
    QIEND_STATUS_21                     = $00200000;  // Bit 21, MPG ��� ��� �޽� ���� �����÷ο� �߻�           
    QIEND_STATUS_22                     = $00400000;  // Bit 22, DON'CARE                                          
    QIEND_STATUS_23                     = $00800000;  // Bit 23, DON'CARE                                          
    QIEND_STATUS_24                     = $01000000;  // Bit 24, DON'CARE                                          
    QIEND_STATUS_25                     = $02000000;  // Bit 25, DON'CARE                                          
    QIEND_STATUS_26                     = $04000000;  // Bit 26, DON'CARE                                          
    QIEND_STATUS_27                     = $08000000;  // Bit 27, DON'CARE                                          
    QIEND_STATUS_28                     = $10000000;  // Bit 28, ����/������ ���� ����̺� ����                    
    QIEND_STATUS_29                     = $20000000;  // Bit 29, �ܿ� �޽� ���� ��ȣ ��� ��.                      
    QIEND_STATUS_30                     = $40000000;  // Bit 30, ������ ���� ���� ���� ����                        
    QIEND_STATUS_31                     = $80000000;  // Bit 31, ���� ����̺� ����Ÿ ���� ����.                   
    {  �����ǰ(QI) �������� ����       }
    QIDRIVE_STATUS_0                    = $0000001;   // Bit 0, BUSY(����̺� ���� ��)                                      
    QIDRIVE_STATUS_1                    = $0000002;   // Bit 1, DOWN(���� ��)                                               
    QIDRIVE_STATUS_2                    = $0000004;   // Bit 2, CONST(��� ��)                                              
    QIDRIVE_STATUS_3                    = $0000008;   // Bit 3, UP(���� ��)                                                 
    QIDRIVE_STATUS_4                    = $0000010;   // Bit 4, ���� ����̺� ���� ��                                       
    QIDRIVE_STATUS_5                    = $0000020;   // Bit 5, ���� �Ÿ� ����̺� ���� ��                                  
    QIDRIVE_STATUS_6                    = $0000040;   // Bit 6, MPG ����̺� ���� ��                                        
    QIDRIVE_STATUS_7                    = $0000080;   // Bit 7, �����˻� ����̺� ������                                    
    QIDRIVE_STATUS_8                    = $0000100;   // Bit 8, ��ȣ �˻� ����̺� ���� ��                                  
    QIDRIVE_STATUS_9                    = $0000200;   // Bit 9, ���� ����̺� ���� ��                                       
    QIDRIVE_STATUS_10                   = $0000400;   // Bit 10, Slave ����̺� ������                                      
    QIDRIVE_STATUS_11                   = $0000800;   // Bit 11, ���� ���� ����̺� ����(���� ����̺꿡���� ǥ�� ���� �ٸ�)
    QIDRIVE_STATUS_12                   = $0001000;   // Bit 12, �޽� ����� ������ġ �Ϸ� ��ȣ �����.                     
    QIDRIVE_STATUS_13                   = $0002000;   // Bit 13, ���� ���� ����̺� ������.                                 
    QIDRIVE_STATUS_14                   = $0004000;   // Bit 14, ��ȣ ���� ����̺� ������.                                 
    QIDRIVE_STATUS_15                   = $0008000;   // Bit 15, �޽� ��� ��.                                              
    QIDRIVE_STATUS_16                   = $0010000;   // Bit 16, ���� ���� ������ ����(ó��)(0-7)                           
    QIDRIVE_STATUS_17                   = $0020000;   // Bit 17, ���� ���� ������ ����(�߰�)(0-7)                           
    QIDRIVE_STATUS_18                   = $0040000;   // Bit 18, ���� ���� ������ ����(��)(0-7)                             
    QIDRIVE_STATUS_19                   = $0080000;   // Bit 19, ���� ���� Queue ��� ����.                                 
    QIDRIVE_STATUS_20                   = $0100000;   // Bit 20, ���� ���� Queue ���� �H                                    
    QIDRIVE_STATUS_21                   = $0200000;   // Bit 21, ���� ���� ����̺��� �ӵ� ���(ó��)                       
    QIDRIVE_STATUS_22                   = $0400000;   // Bit 22, ���� ���� ����̺��� �ӵ� ���(��)                         
    QIDRIVE_STATUS_23                   = $0800000;   // Bit 23, MPG ���� #1 Full                                           
    QIDRIVE_STATUS_24                   = $1000000;   // Bit 24, MPG ���� #2 Full                                           
    QIDRIVE_STATUS_25                   = $2000000;   // Bit 25, MPG ���� #3 Full                                           
    QIDRIVE_STATUS_26                   = $4000000;   // Bit 26, MPG ���� ������ OverFlow                                   
    { �����ǰ(QI) ���ͷ�Ʈ ����1       }   
    QIINTBANK1_DISABLE                  = $00000000;  // INTERRUT DISABLED.                                               
    QIINTBANK1_0                        = $00000001;  // Bit 0,  ���ͷ�Ʈ �߻� ��� ������ ���� �����.                   
    QIINTBANK1_1                        = $00000002;  // Bit 1,  ���� �����                                              
    QIINTBANK1_2                        = $00000004;  // Bit 2,  ���� ���۽�.                                             
    QIINTBANK1_3                        = $00000008;  // Bit 3,  ī���� #1 < �񱳱� #1 �̺�Ʈ �߻�                        
    QIINTBANK1_4                        = $00000010;  // Bit 4,  ī���� #1 = �񱳱� #1 �̺�Ʈ �߻�                        
    QIINTBANK1_5                        = $00000020;  // Bit 5,  ī���� #1 > �񱳱� #1 �̺�Ʈ �߻�                        
    QIINTBANK1_6                        = $00000040;  // Bit 6,  ī���� #2 < �񱳱� #2 �̺�Ʈ �߻�                        
    QIINTBANK1_7                        = $00000080;  // Bit 7,  ī���� #2 = �񱳱� #2 �̺�Ʈ �߻�                        
    QIINTBANK1_8                        = $00000100;  // Bit 8,  ī���� #2 > �񱳱� #2 �̺�Ʈ �߻�                        
    QIINTBANK1_9                        = $00000200;  // Bit 9,  ī���� #3 < �񱳱� #3 �̺�Ʈ �߻�                        
    QIINTBANK1_10                       = $00000400;  // Bit 10, ī���� #3 = �񱳱� #3 �̺�Ʈ �߻�                        
    QIINTBANK1_11                       = $00000800;  // Bit 11, ī���� #3 > �񱳱� #3 �̺�Ʈ �߻�                        
    QIINTBANK1_12                       = $00001000;  // Bit 12, ī���� #4 < �񱳱� #4 �̺�Ʈ �߻�                        
    QIINTBANK1_13                       = $00002000;  // Bit 13, ī���� #4 = �񱳱� #4 �̺�Ʈ �߻�                        
    QIINTBANK1_14                       = $00004000;  // Bit 14, ī���� #4 < �񱳱� #4 �̺�Ʈ �߻�                        
    QIINTBANK1_15                       = $00008000;  // Bit 15, ī���� #5 < �񱳱� #5 �̺�Ʈ �߻�                        
    QIINTBANK1_16                       = $00010000;  // Bit 16, ī���� #5 = �񱳱� #5 �̺�Ʈ �߻�                        
    QIINTBANK1_17                       = $00020000;  // Bit 17, ī���� #5 > �񱳱� #5 �̺�Ʈ �߻�                        
    QIINTBANK1_18                       = $00040000;  // Bit 18, Ÿ�̸� #1 �̺�Ʈ �߻�.                                   
    QIINTBANK1_19                       = $00080000;  // Bit 19, Ÿ�̸� #2 �̺�Ʈ �߻�.                                   
    QIINTBANK1_20                       = $00100000;  // Bit 20, ���� ���� ���� Queue �����.                             
    QIINTBANK1_21                       = $00200000;  // Bit 21, ���� ���� ���� Queue ����H                              
    QIINTBANK1_22                       = $00400000;  // Bit 22, Ʈ���� �߻��Ÿ� �ֱ�/������ġ Queue �����.              
    QIINTBANK1_23                       = $00800000;  // Bit 23, Ʈ���� �߻��Ÿ� �ֱ�/������ġ Queue ����H               
    QIINTBANK1_24                       = $01000000;  // Bit 24, Ʈ���� ��ȣ �߻� �̺�Ʈ                                  
    QIINTBANK1_25                       = $02000000;  // Bit 25, ��ũ��Ʈ #1 ��ɾ� ���� ���� Queue �����.               
    QIINTBANK1_26                       = $04000000;  // Bit 26, ��ũ��Ʈ #2 ��ɾ� ���� ���� Queue �����.               
    QIINTBANK1_27                       = $08000000;  // Bit 27, ��ũ��Ʈ #3 ��ɾ� ���� ���� �������� ����Ǿ� �ʱ�ȭ ��.
    QIINTBANK1_28                       = $10000000;  // Bit 28, ��ũ��Ʈ #4 ��ɾ� ���� ���� �������� ����Ǿ� �ʱ�ȭ ��.
    QIINTBANK1_29                       = $20000000;  // Bit 29, ���� �˶���ȣ �ΰ���.                                    
    QIINTBANK1_30                       = $40000000;  // Bit 30, |CNT1| - |CNT2| >= |CNT4| �̺�Ʈ �߻�.                   
    QIINTBANK1_31                       = $80000000;  // Bit 31, ���ͷ�Ʈ �߻� ��ɾ�|INTGEN| ����.                       
    { �����ǰ(QI) ���ͷ�Ʈ ����2       }
    QIINTBANK2_DISABLE                  = $00000000;  // INTERRUT DISABLED.                                                                   
    QIINTBANK2_0                        = $00000001;  // Bit 0,  ��ũ��Ʈ #1 �б� ��� ��� Queue �� ����H.                                  
    QIINTBANK2_1                        = $00000002;  // Bit 1,  ��ũ��Ʈ #2 �б� ��� ��� Queue �� ����H.                                  
    QIINTBANK2_2                        = $00000004;  // Bit 2,  ��ũ��Ʈ #3 �б� ��� ��� �������Ͱ� ���ο� �����ͷ� ���ŵ�.                
    QIINTBANK2_3                        = $00000008;  // Bit 3,  ��ũ��Ʈ #4 �б� ��� ��� �������Ͱ� ���ο� �����ͷ� ���ŵ�.                
    QIINTBANK2_4                        = $00000010;  // Bit 4,  ��ũ��Ʈ #1 �� ���� ��ɾ� �� ���� �� ���ͷ�Ʈ �߻����� ������ ��ɾ� �����.
    QIINTBANK2_5                        = $00000020;  // Bit 5,  ��ũ��Ʈ #2 �� ���� ��ɾ� �� ���� �� ���ͷ�Ʈ �߻����� ������ ��ɾ� �����.
    QIINTBANK2_6                        = $00000040;  // Bit 6,  ��ũ��Ʈ #3 �� ���� ��ɾ� ���� �� ���ͷ�Ʈ �߻����� ������ ��ɾ� �����.   
    QIINTBANK2_7                        = $00000080;  // Bit 7,  ��ũ��Ʈ #4 �� ���� ��ɾ� ���� �� ���ͷ�Ʈ �߻����� ������ ��ɾ� �����.   
    QIINTBANK2_8                        = $00000100;  // Bit 8,  ���� ����                                                                    
    QIINTBANK2_9                        = $00000200;  // Bit 9,  ���� ��ġ ���� �Ϸ�(Inposition)����� ����� ����,���� ���� �߻�.            
    QIINTBANK2_10                       = $00000400;  // Bit 10, �̺�Ʈ ī���ͷ� ���� �� ����� �̺�Ʈ ���� #1 ���� �߻�.                     
    QIINTBANK2_11                       = $00000800;  // Bit 11, �̺�Ʈ ī���ͷ� ���� �� ����� �̺�Ʈ ���� #2 ���� �߻�.                     
    QIINTBANK2_12                       = $00001000;  // Bit 12, SQSTR1 ��ȣ �ΰ� ��.                                                         
    QIINTBANK2_13                       = $00002000;  // Bit 13, SQSTR2 ��ȣ �ΰ� ��.                                                         
    QIINTBANK2_14                       = $00004000;  // Bit 14, UIO0 �͹̳� ��ȣ�� '1'�� ����.                                               
    QIINTBANK2_15                       = $00008000;  // Bit 15, UIO1 �͹̳� ��ȣ�� '1'�� ����.                                               
    QIINTBANK2_16                       = $00010000;  // Bit 16, UIO2 �͹̳� ��ȣ�� '1'�� ����.                                               
    QIINTBANK2_17                       = $00020000;  // Bit 17, UIO3 �͹̳� ��ȣ�� '1'�� ����.                                               
    QIINTBANK2_18                       = $00040000;  // Bit 18, UIO4 �͹̳� ��ȣ�� '1'�� ����.                                               
    QIINTBANK2_19                       = $00080000;  // Bit 19, UIO5 �͹̳� ��ȣ�� '1'�� ����.                                               
    QIINTBANK2_20                       = $00100000;  // Bit 20, UIO6 �͹̳� ��ȣ�� '1'�� ����.                                               
    QIINTBANK2_21                       = $00200000;  // Bit 21, UIO7 �͹̳� ��ȣ�� '1'�� ����.                                               
    QIINTBANK2_22                       = $00400000;  // Bit 22, UIO8 �͹̳� ��ȣ�� '1'�� ����.                                               
    QIINTBANK2_23                       = $00800000;  // Bit 23, UIO9 �͹̳� ��ȣ�� '1'�� ����.                                               
    QIINTBANK2_24                       = $01000000;  // Bit 24, UIO10 �͹̳� ��ȣ�� '1'�� ����.                                              
    QIINTBANK2_25                       = $02000000;  // Bit 25, UIO11 �͹̳� ��ȣ�� '1'�� ����.                                              
    QIINTBANK2_26                       = $04000000;  // Bit 26, ���� ���� ����(LMT, ESTOP, STOP, ESTOP, CMD, ALARM) �߻�.                    
    QIINTBANK2_27                       = $08000000;  // Bit 27, ���� �� ������ ���� ���� �߻�.                                               
    QIINTBANK2_28                       = $10000000;  // Bit 28, Don't Care                                                                   
    QIINTBANK2_29                       = $20000000;  // Bit 29, ����Ʈ ��ȣ(PELM, NELM)��ȣ�� �Է� ��.                                       
    QIINTBANK2_30                       = $40000000;  // Bit 30, �ΰ� ����Ʈ ��ȣ(PSLM, NSLM)��ȣ�� �Է� ��.                                  
    QIINTBANK2_31                       = $80000000;  // Bit 31, ��� ���� ��ȣ(ESTOP)��ȣ�� �Էµ�.                                          
    { RTEX ��ũ������ ����              }
    NET_STATUS_DISCONNECTED             = 1;
    NET_STATUS_LOCK_MISMATCH            = 5;
    NET_STATUS_CONNECTED                = 6;
    { AI Module H/W FIFO ���� ����      }
    FIFO_DATA_EXIST                     = 0;
    FIFO_DATA_EMPTY                     = 1;
    FIFO_DATA_HALF                      = 2;
    FIFO_DATA_FULL                      = 6;
    { AI Module Conversion ��������     }
    EXTERNAL_DATA_DONE                  = 0;
    EXTERNAL_DATA_FINE                  = 1;
    EXTERNAL_DATA_HALF                  = 2;
    EXTERNAL_DATA_FULL                  = 3;
    EXTERNAL_COMPLETE                   = 4;
    { �����ǰ(QI) Override ��ġ ����   }
    OVERRIDE_POS_START                  = 0;
    OVERRIDE_POS_END                    = 1;
    { �����ǰ(QI) Profile �켱����     }
    PRIORITY_VELOCITY                   = 0;
    PRIORITY_ACCELTIME                  = 1;
implementation
end.
