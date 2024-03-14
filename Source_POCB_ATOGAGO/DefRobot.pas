unit DefRobot;
// ROBOT - MODBUS

interface
{$I Common.inc}

//##############################################################################
//
// ROBOT - MODBUS
//
//##############################################################################

const
//ROBOT_TCPPORT_MODBUS = 502;
  MODBUS_PROTOCOLID_0  = 0;
  MODBUS_UNITID_1      = 1; //TBD:A2CHv3:ROBOR?

  MODBUS_MAX_COILS     = 2000; //MaxCoils = 2000;
  MODBUS_MAX_REGISTERS = 125;  //MaxBlockLength = 125;

  MODBUS_IGNORE_UNITID = 255;

  // Define constants for the ModBus functions 
  //
  //    Primary tables    | Object type | Type of    | Comments
  //    ------------------+-------------+------------+--------------------
  //    Discretes Input   | Single bit  | Read-Only  | This type of data can be provided by an I/O system.
  //    Coils             | Single bit  | Read-Write | This type of data can be alterable by an application program.
  //    Input Registers   | 16-bit word | Read-Only  | This type of data can be provided by an I/O system
  //    Holding Registers | 16-bit word | Read-Write | This type of data can be alterable by an application program.
  //
const
  MODBUS_FC_01_ReadCoils       = $01; // Read,  Single bit
  MODBUS_FC_02_ReadInputBits   = $02; // Read,  Single bit
  MODBUS_FC_03_ReadHoldingRegs = $03; // Read,  16-bit word
  MODBUS_FC_04_ReadInputRegs   = $04; // Read,  16-bit word
  MODBUS_FC_05_WriteOneCoil    = $05; // Write, Single bit
  MODBUS_FC_06_WriteOneReg     = $06; // Write, 16-bit word
  MODBUS_FC_15_WriteMultiCoils = $0F; // Write, (multiple) Single bit 
  MODBUS_FC_16_WriteMultiRegs  = $10; // Write, (multiple) 16-bit word
//MODBUS_FC_01_ReadFileRecord  = $14; // Read,  Single bit
//MODBUS_FC_01_WriteFileRecord = $15; // Write, Single bit
//MODBUS_FC_01_MaskWriteReg    = $16; // Read,  Single bit
//MODBUS_FC_01_ReadWriteRegs   = $17; // Read,  Single bit
//MODBUS_FC_01_ReadFiFoQueue   = $18; // Read,  Single bit

  // [Ref:MODBUS:Modbus_Messaging_Implementation_Guide_V1_0b] 4.4.2.5 MODBUS Response building
  // [REF:MODBUS:Modbus_Application_Protocol_V1_1b3] 7. MODBUS Exception Responses
  //
  //    Once the request has been processed, the MODBUS server has to build the response 
  //      using the adequate MODBUS server transaction and has to send it to the TCP management component.
  //    Depending on the result of the processing two types of response can be built :
  //      * A positive MODBUS response :
  //        - The response function code = The request function code
  //      * A MODBUS Exception response :
  //        - The objective is to provide to the client relevant information concerning theerror detected during the processing ;
  //        - The response function code = the request function code + 0x80 ;
  //        - The exception code is provided to indicate the reason of the error.
  //
  //    Exception Code | MODBUS name           | Comments
  //    ---------------+-----------------------+----------------------------------------
  //         01        | Illegal Function Code | The function code is unknown by the server
  //         02        | Illegal Data Address  | Dependant on the request
  //         03        | Illegal Data Value    | Dependant on the request
  //         04        | Server Failure        | The server failed during the execution
  //         05        | Acknowledge           | The server accepted the service invocation but the service requires 
  //                                           |   a relatively long time to execute. The server therefore returns only 
  //                                           |   an acknowledgement of the service invocation receipt.
  //         06        | Server Busy           | The server was unable to accept the MB Request PDU. The client application has 
  //                                           |   the responsibility of deciding if and when to re-send the request.
  //         0A        | Gateway problem       | Gateway paths not available.
  //         0B        | Gateway problem       | The targeted device failed to respond. The gateway generates this exception
  //      
  //      The MODBUS response PDU must be prefixed with the MBAP header which is built using data memorized in the transaction context.
  //      * Unit Identifier
  //        - The Unit Identifier is copied as it was given within the received MODBUS requestand memorized in the transaction context.
  //      * Length
  //        - The server calculates the size of the MODBUS PDU plus the Unit Identifier byte.This value is set in the "Length" field.
  //      * Protocol Identifier
  //        - The Protocol Identifier field is set to 0x0000 (MODBUS protocol), as it was givenwithin the received MODBUS request.
  //      * Transaction Identifier
  //        - This field is set to the "Transaction Identifier" value that was associated with theoriginal request 
  //          and memorized in the transaction context.
  //      Then the MODBUS response must be returned to the right MODBUS Client using the TCP connection memorized 
  //          in the transaction context. 
  //      When the response is sent, the transaction context must be free.
  //
const
  MODBUS_ERRCODE_OK               = $00;
  MODBUS_ERRCODE_IllegalFunction  = $01;
  MODBUS_ERRCODE_IllegalRegister  = $02;
  MODBUS_ERRCODE_IllegalDataValue = $03;
  MODBUS_ERRCODE_ServerFailure    = $04;
  MODBUS_ERRCODE_Acknowledge      = $05;
  MODBUS_ERRCODE_ServerBusy       = $06;
  MODBUS_ERRCODE_GatewayPathNotAvailable     = $0A;
  MODBUS_ERRCODE_GatewayNoResponseFromTarget = $0B;

  // [Ref:MODBUS:Modbus_Messaging_Implementation_Guide_V1_0b] 3.1.2 MODBUS On TCP/IP Application Data Unit
  //          <---------------------MODBUS TCP/IP ADU----------------------->
  //          MBAP-Header------Function-Code Data----------------------------
  //                           <---------------PDU-------------------------->
  //                Figure 3: MODBUS request/response over TCP/IP
  //    A dedicated header is used on TCP/IP to identify the MODBUS Application Data Unit.
  //       It is called the MBAP header (MODBUS Application Protocol header).
  //    This header provides some differences compared to the MODBUS RTU application data unit used on serial line:
  //      * The MODBUS 'slave address' field usually used on MODBUS Serial Line is replaced by a single byte
  //          'Unit Identifier' within the MBAP Header. The 'Unit Identifier' is used to communicate via devices 
  //           such as bridges, routers and gateways that use a single IP address to support multiple independent 
  //           MODBUS end units.
  //      * All MODBUS requests and responses are designed in such a way that the recipient can verify that 
  //           a message is finished. For function codes where the MODBUS PDU has a fixed length, the function 
  //           code alone is sufficient. For function codes carrying a variable amount of data in the request or response, 
  //           the data field includes a byte count.
  //      * When MODBUS is carried over TCP, additional length information is carried in the MBAP header to allow 
  //           the recipient to recognize message boundaries even if the message has been split into multiple 
  //           packets for transmission. The existence of explicit and implicit length rules, 
  //           and use of a CRC-32 error check code (on Ethernet) results in an infinitesimal chance of undetected 
  //           corruption to a request or response message.
  //
  // [Ref:MODBUS:Modbus_Messaging_Implementation_Guide_V1_0b] 3.1.3 MBAP Header description
  //      Fields                 | Length  | Description             | Client              | Server
  //      -----------------------+---------+-------------------------+---------------------+---------------------------
  //      Transaction Identifier | 2 Bytes | Identification of a     | Initialized by      | Recopied by the server 
  //                             |         | MODBUS Request/Response | the client          | from the received request
  //                             |         | transaction.            |                     | 
  //      Protocol Identifier    | 2 Bytes | 0 = MODBUS protocol     | Initialized by      | Recopied by the server 
  //                             |         |                         | the client          | from the received request
  //      Length                 | 2 Bytes | Number of following     | Initialized by      | Initialized by the server
  //                             |         | bytes                   | the client(request) | (Response)
  //      Unit Identifier        | 1 Byte  | Identification of a     | Initialized by      | Recopied by the server 
  //                             |         | remote slave connected  | the client          | from the received request
  //                             |         | on a serial line or on  |                     |
  //                             |         | other buses.            |                     |
  //    The header is 7 bytes long:
  //     * Transaction Identifier 
  //       - It is used for transaction pairing, the MODBUS server copies in the response the transaction identifier of the request.
  //     * Protocol Identifier 
  //       - It is used for intra-system multiplexing. The MODBUS protocol is identified by the value 0.
  //     * Length 
  //       - The length field is a byte count of the following fields, including the Unit Identifier and data fields.
  //     * Unit Identifier 
  //       - This field is used for intra-system routing purpose. 
  //       - It is typically used to communicate to a MODBUS+ or a MODBUS serial line slave through a gateway 
  //         between an Ethernet TCP-IP network and a MODBUS serial line. 
  //       - This field is set by the MODBUS Client in the request and must be returned with the same value inthe response by the server.
  //     # All MODBUS/TCP ADU are sent via TCP to registered port 502.
  //     # Remark : the different fields are encoded in Big-endian.
const
  MODBUS_PKTBUF_IDX_TRANID   = 0;
  MODBUS_PKTBUF_IDX_PROTOID  = 2;
  MODBUS_PKTBUF_IDX_LENGTH   = 4;
  MODBUS_PKTBUF_IDX_UNITID   = 6;
  MODBUS_PKTBUF_IDX_PDU_FC   = 7;
  MODBUS_PKTBUF_IDX_PDU_DATA = 8;

type
  TModBusPktBuf = array[0..268] of Byte;  // Header + PduFuncCode+PduData 
    // 0..1 : Header.TranID  // Big-edian
    // 2..3 : Header.ProtoID // Big-edian
    // 4..5 : Header.Length  // Big-edian
    // 6    : Header.UnitID
    // 7    : PduFuncCode
    // 8..  : PduData

  TModBusPduData = array[0..260] of Byte;

  TModBusHeaderRec = record
    TranID  : Word;
    ProtoID : Word;
    Length  : Word;
    UnitID  : Byte;
  end;

  TModBusReqRec = record
    Header        : TModBusHeaderRec;
    PduFuncCode   : Byte;  // 1 ~ 255
    PduData       : TModBusPduData;
  end;

  TModBusRspRec = record
    Header        : TModBusHeaderRec;
    PduFuncCode   : Byte;  // 1 ~ 255
    PduData       : TModBusPduData;
  end;

  TModBusExcepRec = record
    Header        : TModBusHeaderRec;
    ExceptionFC   : Byte;
    ExceptionCode : Byte;
  end;

  TSingleWordsBytes = Record
    case integer of
      0 : (dabSingle : Single);
      1 : (dabWords  : Array [0..1] Of Word);
      2 : (dabBytes  : Array [0..3] Of Byte);
  end;


{$IF Defined(USE_ROBOT_TM)}
//##############################################################################
//
// ROBOT - ROBOT_TM
//
//##############################################################################

  //****************************************************************************
  // ROBOT_TM
  //
  //    Model                             |   TM5-700    |   TM5-900
  //    ==================================+==============+===============
  //    Weight                            | 22.1 kg      | 22.6 kg
  //    Payload                           | 6 kg         | 4 kg
  //    Reach                             | 700 mm       | 900 mm
  //    -----------------------+----------+--------------+---------------
  //    Joint Ranges           | J1       |        +/- 270 degree
  //                           | J2,J4,J5 |        +/- 180 degree
  //                           | J3       |        +/- 155 degree
  //                           | J6       |        +/- 270 degree
  //    -----------------------+----------+------------------------------
  //    Speed J1~J2            | J1~J2    |        180 degree/sec
  //                           | J3       |        180 degree/sec
  //                           | J4~J5    |        225 degree/sec
  //                           | J6       |        225 degree/sec
  //    -----------------------+----------+------------------------------
  //    Repeatability                     |          +/- 0.05 mm
  //    Degrees of Freedom                |       6 Rotaring Joints
  //    ----------------------------------+------------------------------
  //    Robot Vision                      |
  //    Eye in Hand (Build-In)            | 1.2M/5M pixels, color camera
  //    Eye to Hand (option)              | Support Max 2 GigE cameras
  //    ----------------------------------+------------------------------
  //

  //****************************************************************************

  // ROBOT_TM: Table 21: Modbus - Robot Status1 ~ Status2 ----------------------
const
  ROBOT_TM_MB_DEVADDR_RobotStatus  = $1C21; // FC(2) ADDR(0x1C21=7201): FatalError(1C21)~
                                            // FC(2) ADDR(0x1C29=7209): AutoRemoteModeEnable(1C29), AutoRemoteModeActive(1C2A), SpeedAdjustmentEnable(1C2B)
  ROBOT_TM_MB_DATACNT_RobotStatus  = 8;     //
                                                  //  FC    Addr(dec)  Addr(hex)  Type  R/W  Note
  ROBOT_TM_MB_RobotStatus1_FatalError       = 0;  //  02    7201       1C21       Bool   R   Yes:1, No:0
  ROBOT_TM_MB_RobotStatus1_ProjectRunning   = 1;  //  02    7202       1C22       Bool   R   Yes:1, No:0
  ROBOT_TM_MB_RobotStatus1_ProjectEditing   = 2;  //  02    7203       1C23       Bool   R   Yes:1, No:0
  ROBOT_TM_MB_RobotStatus1_ProjectPause     = 3;  //  02    7204       1C24       Bool   R   Yes:1, No:0
  ROBOT_TM_MB_RobotStatus1_GetControl       = 4;  //  02    7205       1C25       Bool   R   Yes:1, No:0
  ROBOT_TM_MB_RobotStatus1_CameraLight      = 5;  // 01/05  7206       1C26       Bool  R/W  Enable:1, Disable:0
  ROBOT_TM_MB_RobotStatus1_SafetyIO         = 6;  //  02    7207       1C27       Bool   R   Triggered:1, Restored:0
  ROBOT_TM_MB_RobotStatus1_EStop            = 7;  //  02    7208       1C28       Bool   R   Triggered:1, Restored:0
                                                  //  FC    Addr(dec)  Addr(hex)  Type  R/W  Note
//ROBOT_TM_MB_RobotStatus2_AutoRemoteEnable = 8;  //  02    7209       1C29       Bool   R   Enable:1, Disable:0
//ROBOT_TM_MB_RobotStatus2_AutoRemoteActive = 9;  //  05    7210       1C2A       Bool   W   Active:1, Inactive:0  (Need Get Control, In Auto Mode)
                                                  //  02    7210       1C2A       Bool   R   Active:1, Inactive:0
//ROBOT_TM_MB_RobotStatus2_SpeedAdjEnable   = 10; //  02    7211       1C2B       Bool   R   Enable:1, Disable:0

  // ROBOT_TM: Table 23: Modbus - Control Box DIO ----------------------------------------
  // ROBOT_TM: Table 24: Modbus - End Module ---------------------------------------------
  // ROBOT_TM: Table 25: Modbus - Control Box AI/O ---------------------------------------
  // ROBOT_TM: Table 26: Modbus - External Module ----------------------------------------
  // ROBOT_TM: Table 27/28: Safety Connector ---------------------------------------------

  // ROBOT_TM: Table 29: Modbus - Robot Coordinate ---------------------------------------
const
  ROBOT_TM_MB_DEVADDR_RobotJoint   = $1B65; // Joint1 ~ Joint6
  ROBOT_TM_MB_DATACNT_RobotJoint   = 6;     //  
                                            // FC  Addr(dec)  Addr(hex)  Type  R/W  Note(Dword:4 bytes)
  ROBOT_TM_MB_RobotJoint_1         = 0;     // 04  7013~7014  1B65~1B66  Float  R   Dword degree  // Joints
  ROBOT_TM_MB_RobotJoint_2         = 1;     // 04  7015~7016  1B67~1B68  Float  R   Dword degree
  ROBOT_TM_MB_RobotJoint_3         = 2;     // 04  7017~7018  1B69~1B6A  Float  R   Dword degree
  ROBOT_TM_MB_RobotJoint_4         = 3;     // 04  7019~7020  1B6B~1B6C  Float  R   Dword degree
  ROBOT_TM_MB_RobotJoint_5         = 4;     // 04  7021~7022  1B6D~1B6E  Float  R   Dword degree
  ROBOT_TM_MB_RobotJoint_6         = 5;     // 04  7023~7024  1B6F~1B70  Float  R   Dword degree
  
  ROBOT_TM_MB_DEVADDR_RobotCoord   = $1B71; // FC(4) ADDR(0x1B71=7025): X(1B71~1B72), Y(1B73~1B74), Z(1B75~1B76), Rx(1B77~1B78), Ry(1B79~1B7A), Rz(1B7B~1B7C)
  ROBOT_TM_MB_DATACNT_RobotCoord   = 6;     //  
                                            // FC  Addr(dec)  Addr(hex)  Type  R/W  Note(Dword:4 bytes)
  ROBOT_TM_MB_RobotCoord_X         = 0;     // 04  7025~7026  1B71~1B72  Float  R   Dword mm      
  ROBOT_TM_MB_RobotCoord_Y         = 1;     // 04  7027~7028  1B73~1B74  Float  R   Dword mm
  ROBOT_TM_MB_RobotCoord_Z         = 2;     // 04  7029~7030  1B75~1B76  Float  R   Dword mm
  ROBOT_TM_MB_RobotCoord_Rx        = 3;     // 04  7031~7032  1B77~1B78  Float  R   Dword degree
  ROBOT_TM_MB_RobotCoord_Ry        = 4;     // 04  7033~7034  1B79~1B7A  Float  R   Dword degree
  ROBOT_TM_MB_RobotCoord_Rz        = 5;     // 04  7035~7036  1B7B~1B7C  Float  R   Dword degree

  //                                        // X,Y,Z,Rx,Ry,Rz (Cartesian coordinate w.r.t. Robot Base without tool)
  //                                        // X,Y,Z,Rx,Ry,Rz (Cartesian coordinate w.r.t. Robot Base with tool)

  // ROBOT_TM: Table 30: Modbus - Robot Coordinate (When Touch Stop node is triggered) ----
  // ROBOT_TM: Table 31: Modbus - Run Setting ---------------------------------------------
  // ROBOT_TM: Table 32: Modbus - TCP Value ----------------------------------------------

  // ROBOT_TM: Table 33: Modbus - Robot Stick --------------------------------------------
  // ROBOT_TM: Table 34: Modbus - Project Speed ----------------------------------------
const
  ROBOT_TM_MB_DEVADDR_RunSpeedMode = $1BBD; // FC(4) ADDR(0x1BBD=7101): ProjectRunningSpeed(1BBD), ManulAutoMode(1BBE)
  ROBOT_TM_MB_DATACNT_RunSpeedMode = 2; 
                                            //  FC    Addr(dec)  Addr(hex)  Type   R/W  Note
  ROBOT_TM_MB_RunSpeedMode_Speed   = 0;     //  04    7101       1BBD       Int16   R   %
  ROBOT_TM_MB_RunSpeedMode_Mode    = 1;     //  04    7102       1BBE       Int16   R   Auto:1; Manual:2

  ROBOT_TM_MB_RUNMODE_AUTO   = 1;  // ROBOT_TM M/A Mode
  ROBOT_TM_MB_RUNMODE_MANUAL = 2;

  // ROBOT_TM: Table 50: Modbus - Others 3 - Light -----------------------------
const
  ROBOT_TM_MB_DEVADDR_RobotLight   = $1CA4; // FC(4) ADDR(0x1CA4=7332): ProjectRunningSpeed(1BBD), ManulAutoMode(1BBE)
  ROBOT_TM_MB_DATACNT_RobotLight   = 1;     //  
  //
  ROBOT_TM_LIGHT_00_Off_EStop                                = 0;  //  0: Light off, when the emergency stop button is pressed.
  ROBOT_TM_LIGHT_01_SolidRed_FatalError                      = 1;  //  1: Solid Red, fatal error.
  ROBOT_TM_LIGHT_02_FlashingRed_Initializing                 = 2;  //  2: Flashing Red, Robot is initializing.
  ROBOT_TM_LIGHT_03_SolidBlue_StandbyInAutoMode              = 3;  //  3: Solid Blue, standby in Auto Mode.
  ROBOT_TM_LIGHT_04_FlashingBlue_AutoMode                    = 4;  //  4. Flashing Blue, in Auto Mode.
  ROBOT_TM_LIGHT_05_SloidGreen_StandbyInManualMode           = 5;  //  5: Solid Green, standby in Manual Mode.
  ROBOT_TM_LIGHT_06_FlashingGreen_ManualMode                 = 6;  //  6. Flashing Green, in Manual Mode.
  ROBOT_TM_LIGHT_09_AlterBlueRed_AutoModeError               = 9;  //  9: Alternating Blue&Red, Auto Mode error.
  ROBOT_TM_LIGHT_10_AlterGreenRed_ManualModeError            = 10; // 10: Alternating Green&Red, Manual Mode error.
  ROBOT_TM_LIGHT_13_AlterPurpleGreen_HmiInManualMode         = 13; // 13: Alternating Purple&Green, in Manual Mode
                                                                   //     (User Connected External Safeguard Input Port for Human - Machine Safety Settings trigger).
  ROBOT_TM_LIGHT_14_AlterPurpleBlue_HmiInAutoMode            = 14; // 14: Alternating Purple&Blue, in Auto Mode
                                                                   //     (User Connected External Safeguard Input Port for Human - Machine Safety Settings trigger).
  ROBOT_TM_LIGHT_17_AlterWhiteGreen_ReducedSpaceInManualMode = 17; // 17: Alternating White&Green, in Manual Mode & Reduced Space.
  ROBOT_TM_LIGHT_18_AlterWhiteBlue_ReducedSpaceInAutoMode    = 18; // 18: Alternating White&Blue, in Auto Mode & Reduced Space.
  ROBOT_TM_LIGHT_19_FlashingLightBlue_SafeStartupMode        = 19; // 19: Flashing light blue, representing that it enters the Safe Startup Mode.

  // ROBOT_TM: ETC -----------------------------
const
  ROBOT_TM_MB_DEVADDR_RobotExtra   = 9001; // FC(1) ADDR(0x2329=9001):  //2021-03-06 (ALARM)
  ROBOT_TM_MB_DATACNT_RobotExtra   = 1;

  ROBOT_TM_MB_RobotEatra_00_CannoMove = 0;

const
  ROBOT_TM_TRANID_1_ROBOTSTATUS = 1;
  ROBOT_TM_TRANID_2_ROBOTCOORD  = 2;
  ROBOT_TM_TRANID_3_ROBOTSPEED  = 3;
  ROBOT_TM_TRANID_4_ROBOTLIGHT  = 4;
  ROBOT_TM_TRANID_5_ROBOTEXTRA  = 5;

  ROBOT_TM_CMD_UNKNOWN          = 0;
  ROBOT_TM_CMD_READY            = 1;
  ROBOT_TM_CMD_MOVE_TO_HOME     = 2;
  ROBOT_TM_CMD_MOVE_TO_MODEL    = 3;
  ROBOT_TM_CMD_MOVE_TO_STANDBY  = 4;
  ROBOT_TM_CMD_MOVE_COMMAND     = 5;
  ROBOT_TM_CMD_MOVE_TO_RELCOORD = 6;

  LISTENNODE_CMD_ACK_OK      = 0; //TBD:A2CHv3:ROBOT?
  LISTENNODE_CMD_ACK_FAIL    = 1; //TBD:A2CHv3:ROBOT?
  LISTENNODE_CMD_ACK_TIMEOUT = 2; //TBD:A2CHv3:ROBOT?

{$ENDIF}

//##############################################################################
//
// ROBOT - COMMON
//
//##############################################################################

  //****************************************************************************
  // ROBOT COMMON
  //****************************************************************************
const
  ROBOT_FORMAT_COORD  = '0.00'; // e.g., 1.2300, -1.2300
  ROBOT_FORMAT_COORD2 = '0.##'; // e.g., 1.23,   -1.23

  //-------------------------- Robot Device Type
  ROBOT_DEV_UNKNOWN   = 0;
  ROBOT_DEV_TM        = 1; // ROBOT_TM

  //-------------------------- Robot SystemInfo
  // IP/Port
{$IFDEF SIMULATOR_ROBOT}
  ROBOT_MY_IPDADDR     = '192.168.103.11';
  ROBOT_IPADDR_NETWORK = '192.168.103.';
{$ELSE}
  ROBOT_MY_IPDADDR     = '192.168.3.11';
  ROBOT_IPADDR_NETWORK = '192.168.3.'; 
{$ENDIF}
  ROBOT_IPADDR_BASE    = 7;              // ROBOT1(192.168.3.7)/ROBOT2(192.168.3.8)
  ROBOT_TCPPORT_MODBUS     = 502;      // GPC(TCPClient) -> ROBOT(TCPServer)
  ROBOT_TCPPORT_LISTENNODE = 5890;     // GPC(TCPServer) <- ROBOT(TCPClient)

  // Parameters
  ROBOT_SPEED_DEFAULT = 10;   // %
  ROBOT_SPEED_MAX     = 100;  // % //TBD:A2CHv3:ROBOR?

  ROBOT_CH1 = 0;
  ROBOT_CH2 = 1;
  ROBOT_MAX = ROBOT_CH2;

  ROBOT_COORD_TOLERANCE = 0.1; // 2021-08-09 (LGD: 0.05 --> 0.1)

//ROBOT_CONNECTION_MODBUS     = 1;  --> enumRobotConnType
//ROBOT_CONNECTION_LISTENNODE = 2;

  //-------------------------- Robot Control
  ROBOT_CHECK_START_TIMEMSEC       = 3000;  //TBD:ROBOT?

  ROBOT_MODBUS_CONNCHECK_TIMEMSEC  = 2000;  // During Robot Normal (+ Get Status)  //TBD:A2CHv3:ROBOT?
  ROBOT_MODBUS_CONNWAIT_TIMEMSEC   = 500;   // (ROBOT_MODBUS_CONNCHECK_TIMEMSEC/2 >= ROBOT_MODBUS_CONNWAIT_TIMEMSEC) !!!
  ROBOT_MODBUS_GETSTATUS_TIMEMSEC  = 250;   // During Robot Initial/Move           //TBD:A2CHv3:ROBOT?
  ROBOT_MODBUS_RESPWAIT_TIMEMSEC   = 200;   //                                     //TBD:A2CHv3:ROBOT?

  ROBOT_LISTENNODE_CONNCHECK_TIMEMSEC   = 5000;  //TBD:A2CHv3:ROBOR?
  ROBOT_LISTENNODE_CONNWAIT_TIMEMSEC    = 2000;  // (ROBOT_LISTENNODE_CONNCHECK_TIMEMSEC/2 >= ROBOT_LISTENNODE_CONNWAIT_TIMEMSEC) !!!  //TBD:A2CHv3:ROBOR?
  ROBOT_LISTENNODE_ACKWAIT_TIMEMSEC     = 15000; //TBD:A2CHv3:ROBOR?
  ROBOT_LISTENNODE_MAXDATAWAIT_TIMEMSEC = 1;     // AContext.Connection.IOHandler.CheckForDataOnSource() // Wait max msec for available data from TCP server  //TBD:A2CHv3:ROBOR?

  // Robot Startup/Initial Move type
//ROBOT_STARTUP_MOVE_NONE  = 0;    //--> enumRobotStartupMoveType
//ROBOT_STARTUP_MOVE_HOME  = 1;
//ROBOT_STARTUP_MOVE_MODEL = 2;

  ROBOT_CONNECTION_OK = 1;
  ROBOT_CONNECTION_NG = 2;

  // Robot Coord Arrtibutes
//ROBOT_COORD_ATTR_X  = 0;  //--> enumRobotCoordAttr
//ROBOT_COORD_ATTR_Y  = 1;
//ROBOT_COORD_ATTR_Z  = 2;
//ROBOT_COORD_ATTR_Rx = 3;
//ROBOT_COORD_ATTR_Ry = 4;
//ROBOT_COORD_ATTR_Rz = 5;

  // Robot Jog Distance for Mainter
//ROBOT_JIG_DISTANCE_CONTINUE = 0;  //--> enumRobotJogDistance
//ROBOT_JIG_DISTANCE_0_01     = 1;
//ROBOT_JIG_DISTANCE_0_05     = 2;
//ROBOT_JIG_DISTANCE_0_1      = 3;
//ROBOT_JIG_DISTANCE_0_5      = 4;
//ROBOT_JIG_DISTANCE_1_0      = 5;
//ROBOT_JIG_DISTANCE_5_0      = 6;
//ROBOT_JIG_DISTANCE_10_0     = 7;

type

  enumRobotConnType    = (RobotConnModbus=0, RobotConnListenNode=1);
  enumRobotCoordAttr   = (Coord_X=0, Coord_Y=1, Coord_Z=2, Coord_Rx=3, Coord_Ry=4, Coord_Rz=5);
  enumRobotJogDistance = (JogDistance_Unknown=-1, JogDistance_0_01=0, JogDistance_0_05=1, JogDistance_0_1=2, JogDistance_0_5=3, JogDistance_1_0=4, JogDistance_5_0=5, JogDistance_10_0=6, JogDistance_Continue=7);
  enumRobotCoordState  = (coordUndefined=0, coordHome=1, coordModel=2, coordStandby=3);
  enumRobotDioCtlType  = (Unknown=0, MakePlay=1, MakePause=2, MakeAutoMode=3, MakeManualMode=4);  //TBD:A2CHv3:ROBOT?
  enumRobotStartupMoveType = (StartupMoveNone=0, StartupMoveToHome=1, StartupMoveToModel=2);

  TRobotStatus = record
    //
    FatalError       : Boolean;  // ROBOT_TM_MB_RobotStatus1_FatalError
    ProjectRunning   : Boolean;  // ROBOT_TM_MB_RobotStatus1_ProjectRunning
    ProjectEditing   : Boolean;  // ROBOT_TM_MB_RobotStatus1_ProjectEditing
    ProjectPause     : Boolean;  // ROBOT_TM_MB_RobotStatus1_ProjectPause
    GetControl       : Boolean;  // ROBOT_TM_MB_RobotStatus1_GetControl
    CameraLight      : Boolean;  // ROBOT_TM_MB_RobotStatus1_CameraLight      //TBD?
    SafetyIO         : Boolean;  // ROBOT_TM_MB_RobotStatus1_SafetyIO         //TBD?
    EStop            : Boolean;  // ROBOT_TM_MB_RobotStatus1_EStop
    //
    AutoRemoteEnable : Boolean;  // ROBOT_TM_MB_RobotStatus2_AutoRemoteEnable //TBD?
    AutoRemoteActive : Boolean;  // ROBOT_TM_MB_RobotStatus2_AutoRemoteActiv  //TBD?
    SpeedAdjEnable   : Boolean;  // ROBOT_TM_MB_RobotStatus2_SpeedAdjEnable   //TBD?
  end;

  TRobotJog = record
    nCoordAttr : enumRobotCoordAttr;
    nDistance  : Single;
    bIsPlus    : Boolean;
  end;

  TRobotJoint = record
    Joint1  : Single;            //
    Joint2  : Single;            //
    Joint3  : Single;            //
    Joint4  : Single;            //
    Joint5  : Single;            //
    Joint6  : Single;            //
  end;

  TRobotCoord = record
    //                           // <ROBOT_TM> X,Y,Z,Rx,Ry,Rz (Cartesian coordinate w.r.t. Robot Base without tool)
    X       : Single;            //
    Y       : Single;            //
    Z       : Single;            //
    Rx      : Single;            //
    Ry      : Single;            //
    Rz      : Single;            //
  end;

  TRobotExtra = record
    CannotMove  : Boolean;       // ROBOT_TM_MB_RobotStatus2_SpeedAdjEnable //2021-03-06
  end;

  TRobotStatusCoord = record    // ROBOT_TM
    RobotStatus : TRobotStatus; // ModBus: RobotStatus
    //
    RobotJoint  : TRobotJoint;
    RobotCoord  : TRobotCoord;  // ModBus: RobotStatus
    //
    RobotLight  : UInt16;       // ModBus: RobotStatus
    //                           
    RunSpeed    : UInt16;       // ModBus: RobotStatus
    RunMode     : UInt16;       // ModBus: RobotStatus
    //
    CoordState  : enumRobotCoordState;  //TBD:ROBOT?
    //
    RobotExtra  : TRobotExtra;  //2021-03-06
  end;

implementation

end.


