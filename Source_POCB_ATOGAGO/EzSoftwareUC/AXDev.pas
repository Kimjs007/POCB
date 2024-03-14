unit AXDev;

interface
uses Windows, Messages, AXHD;

// Use Board Number and find Board Address
function AxlGetBoardAddress (lBoardNo : LongInt; upBoardAddress : PDWord) : DWord; stdcall;
// Use Board Number and find Board ID
function AxlGetBoardID (lBoardNo : LongInt; upBoardID : PDWord) : DWord; stdcall;
// Use Board Number and find Board Version
function AxlGetBoardVersion (lBoardNo : LongInt; upBoardVersion : PDWord) : DWord; stdcall;
// Use Board Number/Module Position and find Module ID
function AxlGetModuleID (lBoardNo : LongInt; lModulePos : LongInt; upModuleID : PDWord) : DWord; stdcall;
// Use Board Number/Module Position and find Module Version
function AxlGetModuleVersion (lBoardNo : LongInt; lModulePos : LongInt; upModuleVersion : PDWord) : DWord; stdcall;

function AxlGetModuleNodeInfo(lBoardNo : LongInt; lModulePos : LongInt; lpNetNo : PLongInt; upNodeAddr : PDWord) : DWord; stdcall;

// Only for PCI-R1604[RTEX]
// Writing user data to embedded flash memory
// lPageAddr(0 ~ 199)
// lByteNum(1 ~ 120)
// Note) Delay time is required for completing writing operation to Flash(Max. 17mSec)
function AxlSetDataFlash (lBoardNo : LongInt; lPageAddr : LongInt; lBytesNum : LongInt; bpSetData : PByte) : DWord; stdcall;
// Reading datas from embedded flash memory
// lPageAddr(0 ~ 199)
// lByteNum(1 ~ 120)
function AxlGetDataFlash (lBoardNo : LongInt; lPageAddr : LongInt; lBytesNum : LongInt; bpSetData : PByte) : DWord; stdcall;

// Use Board Number/Module Position and find AIO Module Number
function AxaInfoGetModuleNo (lBoardNo : LongInt; lModulePos : LongInt; lpModuleNo : PLongInt) : DWord; stdcall;
// Use Board Number/Module Position and find DIO Module Number
function AxdInfoGetModuleNo (lBoardNo : LongInt; lModulePos : LongInt; lpModuleNo : PLongInt) : DWord; stdcall;

// IPCOMMAND Setting at an appoint axis
function AxmSetCommand (lAxisNo : LongInt; sCommand : Byte) : DWord; stdcall;
// 8bit IPCOMMAND Setting at an appoint axis
function AxmSetCommandData08 (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// Get 8bit IPCOMMAND at an appoint axis
function AxmGetCommandData08 (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 16bit IPCOMMAND Setting at an appoint axis
function AxmSetCommandData16 (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// Get 16bit IPCOMMAND at an appoint axis
function AxmGetCommandData16 (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 24bit IPCOMMAND Setting at an appoint axis
function AxmSetCommandData24 (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// Get 24bit IPCOMMAND at an appoint axis
function AxmGetCommandData24 (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 32bit IPCOMMAND Setting at an appoint axis
function AxmSetCommandData32 (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// Get 32bit IPCOMMAND at an appoint axis
function AxmGetCommandData32 (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;

// QICOMMAND Setting at an appoint axis
function AxmSetCommandQi (lAxisNo : LongInt; sCommand : Byte) : DWord; stdcall;
// 8bit QICOMMAND Setting at an appoint axis
function AxmSetCommandData08Qi (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// Get 8bit QICOMMAND at an appoint axis
function AxmGetCommandData08Qi (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 16bit QICOMMAND Setting at an appoint axis
function AxmSetCommandData16Qi (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// Get 16bit QICOMMAND at an appoint axis
function AxmGetCommandData16Qi (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 24bit QICOMMAND Setting at an appoint axis
function AxmSetCommandData24Qi (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// Get 24bit QICOMMAND at an appoint axis
function AxmGetCommandData24Qi (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;
// 32bit QICOMMAND Setting at an appoint axis
function AxmSetCommandData32Qi (lAxisNo : LongInt; sCommand : Byte; uData : DWord) : DWord; stdcall;
// Get 32bit QICOMMAND at an appoint axis
function AxmGetCommandData32Qi (lAxisNo : LongInt; sCommand : Byte; upData : PDWord) : DWord; stdcall;

// Get Port Data at an appoint axis - IP
function AxmGetPortData(lAxisNo : LongInt; wOffset : WORD; upData : PDWord) : DWord; stdcall;
// Port Data Setting at an appoint axis - IP
function AxmSetPortData(lAxisNo : LongInt; wOffset : WORD; uData : DWord) : DWord; stdcall;

// Get Port Data at an appoint axis - QI
function AxmGetPortDataQi(lAxisNo : LongInt; WwOffset : WORD; upData : PDWord) : DWord; stdcall;
// Port Data Setting at an appoint axis - QI
function AxmSetPortDataQi(lAxisNo : LongInt; wOffset : WORD; uData : DWord) : DWord; stdcall;
////////////////////////////////////////////////////////////////////////////////
// Set the script at an appoint axis.  - IP
// sc    : Script number (1 - 4)
// event : Define an event SCRCON to happen.
//         Set event, a number of axis, axis which the event happens, event content 1, 2 attribute
// cmd   : Define a selection SCRCMD however we change any content
// data  : Selection to change any Data.
function AxmSetScriptCaptionIp(lAxisNo : LongInt; sc : LongInt; event : DWord; data : DWord) : DWord; stdcall;
// Return the script at an appoint axis.  - IP
function AxmGetScriptCaptionIp(lAxisNo : LongInt; sc : LongInt; event : PDWord; data : PDWord) : DWord; stdcall;
// Set the script at an appoint axis.  - QI
// sc    : Script number (1 - 4)
// event : Define an event SCRCON to happen.
//         Set event, a number of axis, axis which the event happens, event content 1, 2 attribute
// cmd   : Define a selection SCRCMD however we change any content
// data  : Selection to change any Data.
function AxmSetScriptCaptionQi(lAxisNo : LongInt; sc : LongInt; event : DWord; cmd : DWord; data : DWord) : DWord; stdcall;
// Return the script at an appoint axis. - QI
function AxmGetScriptCaptionQi(lAxisNo : LongInt; sc : LongInt; event : PDWord; cmd : PDWord; data : PDWord) : DWord; stdcall;
// Clear orders a script inside Queue Index at an appoint axis
// uSelect IP.
// uSelect(0): Script Queue Index Clear.
//        (1): Caption Queue Index Clear.
// uSelect QI.
// uSelect(0): Script Queue 1 Index Clear.
//        (1): Script Queue 2 Index Clear.
function AxmSetScriptCaptionQueueClear(lAxisNo : LongInt; uSelect : DWord) : DWord; stdcall;
// Return Index of a script inside Queue at an appoint axis.
// uSelect IP
// uSelect(0): Read Script Queue Index
//        (1): Read Caption Queue Index
// uSelect QI.
// uSelect(0): Read Script Queue 1 Index
//        (1): Read Script Queue 2 Index
function AxmGetScriptCaptionQueueCount(lAxisNo : LongInt; updata : PDWord; uSelect : DWord) : DWord; stdcall;
// Return Data number of a script inside Queue at an appoint axis.
// uSelect IP
// uSelect(0): Read Script Queue Data
//        (1): Read Caption Queue Data
// uSelect QI.
// uSelect(0): Read Script Queue 1 Data
//        (1): Read Script Queue 2 Data
function AxmGetScriptCaptionQueueDataCount(lAxisNo : LongInt; updata : PDWord; uSelect : DWord) : DWord; stdcall;
// Read an inside data.
function AxmGetOptimizeDriveData(lAxisNo : LongInt; dMinVel : Double; dVel : Double; dAccel : Double; dDecel : Double; wRangeData : PWord; wStartStopSpeedData : PWord; wObjectSpeedData : PWord; wAccelRate : PWord; wDecelRate : PWord) : DWord; stdcall;
// Setting up confirmes the register besides within the board by Byte.
function AxmBoardWriteByte(lBoardNo : LongInt; wOffset : Word; byData : Byte) : DWord; stdcall;
function AxmBoardReadByte(lBoardNo : LongInt; wOffset : Word; byData : PByte) : DWord; stdcall;
// Setting up confirmes the register besides within the board by Word.
function AxmBoardWriteWord(lBoardNo : LongInt; wOffset : Word; wData : Word) : DWord; stdcall;
function AxmBoardReadWord(lBoardNo : LongInt; wOffset : Word; wData : PWord) : DWord; stdcall;
// Setting up confirmes the register besides within the board by DWord.
function AxmBoardWriteDWord(lBoardNo : LongInt; wOffset : Word; dwData : DWord) : DWord; stdcall;
function AxmBoardReadDWord(lBoardNo : LongInt; wOffset : Word; dwData : PDWord) : DWord; stdcall;
// Setting up confirmes the register besides within the Module by Byte.
function AxmModuleWriteByte(lBoardNo : LongInt; lModulePos : LongInt; wOffset : Word; byData : Byte) : DWord; stdcall;
function AxmModuleReadByte(lBoardNo : LongInt; lModulePos : LongInt; wOffset : Word; byData : PByte) : DWord; stdcall;
// Setting up confirmes the register besides within the Module by Word.
function AxmModuleWriteWord(lBoardNo : LongInt; lModulePos : LongInt; wOffset : Word; wData : Word) : DWord; stdcall;
function AxmModuleReadWord(lBoardNo : LongInt; lModulePos : LongInt; wOffset : Word; wData : PWord) : DWord; stdcall;
// Setting up confirmes the register besides within the Module by DWord.
function AxmModuleWriteDWord(lBoardNo : LongInt; lModulePos : LongInt; wOffset : Word; dwData : DWord) : DWord; stdcall;
function AxmModuleReadDWord(lBoardNo : LongInt; lModulePos : LongInt; wOffset : Word; dwData : PDWord) : DWord; stdcall;
// Set EXCNT (Pos = Unit)
function AxmStatusSetActComparatorPos(lAxisNo : LongInt; dPos : Double) : DWord; stdcall;
// Return EXCNT (Positon = Unit)
function AxmStatusGetActComparatorPos(lAxisNo : LongInt; dpPos : PDouble) : DWord; stdcall;
// Set INCNT (Pos = Unit)
function AxmStatusSetCmdComparatorPos(lAxisNo : LongInt; dPos : Double) : DWord; stdcall;
// Return INCNT (Pos = Unit)
function AxmStatusGetCmdComparatorPos(lAxisNo : LongInt; dpPos : PDouble) : DWord; stdcall;
//=========== Append function. =================================================
// Increase a straight line interpolation at speed to the infinity.
// Must put the distance speed rate.
function AxmLineMoveVel(lCoord : LongInt; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;
//========= Sensor drive API( Read carefully: Available only PI , No function in QI)
// Set mark signal( used in sensor positioning drive)
function AxmSensorSetSignal(lAxisNo : LongInt; uLevel : DWord) : DWord; stdcall;
// Verify mark signal( used in sensor positioning drive)
function AxmSensorGetSignal(lAxisNo : LongInt; upLevel : PDWord) : DWord; stdcall;
// Verify mark signal( used in sensor positioning drive)state
function AxmSensorReadSignal(lAxisNo : LongInt; upStatus : PDWord) : DWord; stdcall;
// Drive API which moves from edge detection of sensor input pin during velocity mode driving as much as specified position, then stop. Applied motion is started upon the start of API, and escapes from the API after the motion is completed.
function AxmSensorMovePos(lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double; lMethod : LongInt) : DWord; stdcall;
// Drive API which moves from edge detection of sensor input pin during velocity mode driving as much as specified position, then stop. Applied motion is started upon the start of API, then escapes from the API immediately without waiting until the motion is completed.
function AxmSensorStartMovePos(lAxisNo : LongInt; dPos : Double; dVel : Double; dAccel : Double; dDecel : Double; lMethod : LongInt) : DWord; stdcall;

function AxmHomeGetStepTrace(lAxisNo : LongInt; lpStepCount : PLongInt; upMainStepNumber : PDWord; upStepNumber : PDWord; upStepBranch : PDWord) : DWord; stdcall;

//======= Additive home search (Applicable to PI-N804/404  only) ===============
// Set home setting parameters of axis specified by user. (Use exclusive-use register for QI chip).
// uZphasCount : Z phase count after home completion. (0 - 15)
// lHomeMode   : Home setting mode( 0 - 12)
// lClearSet   : Select use of position clear and remaining pulse clear (0 - 3)
//               0: No use of position clear, no use of remaining pulse clear
//               1: use of position clear, no use of remaining pulse clear
//               2: No use of position clear, use of remaining pulse clear
//               3: use of position clear, use of remaining pulse clear
// dOrgVel : Set Org  Speed related home
// dLastVel: Set Last Speed related home
//======= Additive home search (Applicable to PI-N804/404  only) ===============
// Set home setting parameters of axis specified by user. (Use exclusive-use register for QI chip).
// uZphasCount : Z phase count after home completion. (0 - 15)
// lHomeMode   : Home setting mode( 0 - 12)
// lClearSet   : Select use of position clear and remaining pulse clear (0 - 3)
//               0: No use of position clear, no use of remaining pulse clear
//               1: use of position clear, no use of remaining pulse clear
//               2: No use of position clear, use of remaining pulse clear
//               3: use of position clear, use of remaining pulse clear
// dOrgVel : Set Org  Speed related home
// dLastVel: Set Last Speed related home
function AxmHomeSetConfig(lAxisNo : LongInt; uZphasCount : DWord; lHomeMode : LongInt; lClearSet : LongInt; dOrgVel : Double; dLastVel : Double; dLeavePos : Double) : DWord; stdcall;
// Return home setting parameters of axis specified by user.
function AxmHomeGetConfig(lAxisNo : LongInt; upZphasCount : PDword; lpHomeMode : PLongInt; lpClearSet : PLongInt; dpOrgVel : PDouble; dpLastVel : PDouble; dpLeavePos : PDouble) : DWord; stdcall;
// Start home search of axis specified by user
// Set when use lHomeMode : Set 0 - 5 (Start search after Move Return.)
// If lHomeMode -1is used as it is, the setting is done as used in HomeConfig.
// Move direction      : CW when Vel value is positive, CCW when negative.
function AxmHomeSetMoveSearch(lAxisNo : LongInt; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;
// Start home return of axis specified by user.
// Set when lHomeMode is used: set 0 - 12
// If lHomeMode -1is used as it is, the setting is done as used in HomeConfig.
// Move direction      : CW when Vel value is positive, CCW when negative.
function AxmHomeSetMoveReturn(lAxisNo : LongInt; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;
// Home separation of axis specified by user is started.
// Move direction      : CW when Vel value is positive, CCW when negative.
function AxmHomeSetMoveLeave(lAxisNo : LongInt; dVel : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;
// User start home search of multi-axis specified by user.
// Set when use lHomeMode : Set 0 - 5 (Start search after Move Return.)
// If lHomeMode -1is used as it is, the setting is done as used in HomeConfig.
// Move direction      : CW when Vel value is positive, CCW when negative.
function AxmHomeSetMultiMoveSearch(lArraySize : LongInt; lpAxesNo : PLongInt; dpVel : PDouble; dpAccel : PDouble; dpDecel : PDouble) : DWord; stdcall;
//Set move velocity profile mode of specific coordinate system.
// (caution : Available to use only after axis mapping)
//ProfileMode : '0' - symmetry Trapezoid
//              '1' - asymmetric Trapezoid
//              '2' - symmetry Quasi-S Curve
//              '3' - symmetry S Curve
//              '4' - asymmetric S Curve
function AxmContiSetProfileMode(lCoord : LongInt; uProfileMode : DWord) : DWord; stdcall;
// Return move velocity profile mode of specific coordinate system.
function AxmContiGetProfileMode(lCoord : LongInt; upProfileMode : PDWord) : DWord; stdcall;

//========== Reading group for input interrupt occurrence flag =================
// Reading the interrupt occurrence state by bit unit in specified input contact module and Offset position of Interrupt Flag Register
function AxdiInterruptFlagReadBit(lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;
// Reading the interrupt occurrence state by byte unit in specified input contact module and Offset position of Interrupt Flag Register
function AxdiInterruptFlagReadByte(lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;
// Reading the interrupt occurrence state by word unit in specified input contact module and Offset position of Interrupt Flag Register
function AxdiInterruptFlagReadWord(lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;
// Reading the interrupt occurrence state by double word unit in specified input contact module and Offset position of Interrupt Flag Register
function AxdiInterruptFlagReadDword(lModuleNo : LongInt; lOffset : LongInt; upValue : PDWord) : DWord; stdcall;
// Reading the interrupt occurrence state by bit unit in entire input contact module and Offset position of Interrupt Flag Register
function AxdiInterruptFlagRead(lOffset : LongInt; upValue : PDWord) : DWord; stdcall;
//========= API related log ====================================================
// This API sets or resets in order to monitor the API execution result of set axis in EzSpy.
// uUse : use or not use => DISABLE(0), ENABLE(1)
function AxmLogSetAxis(lAxisNo : LongInt; uUse : DWord) : DWord; stdcall;
// This API verifies if the API execution result of set axis is monitored in EzSpy.
function AxmLogGetAxis(lAxisNo : LongInt; upUse : PDWord) : DWord; stdcall;
//==Log
// Set whether execute log output on EzSpy of specified module
function AxdLogSetModule(lModuleNo : LongInt; uUse : DWord) : DWord; stdcall;
// Verify whether execute log output on EzSpy of specified module
function AxdLogGetModule(lModuleNo : LongInt; upUse : PDWord) : DWord; stdcall;
//Set whether to log output to EzSpy of specified input channel
function AxaiLogSetChannel(lChannelNo : LongInt; uUse : DWord) : DWord; stdcall;
//Verify whether to log output to EzSpy of specified input channel
function AxaiLogGetChannel(lChannelNo : LongInt; upUse : PDWord) : DWord; stdcall;
//Set whether to log output in EzSpy of specified output channel
function AxaoLogSetChannel(lChannelNo : LongInt; uUse : DWord) : DWord; stdcall;
//Verify whether log output is done in EzSpy of specified output channel.
function AxaoLogGetChannel(lChannelNo : LongInt; upUse : PDWord) : DWord; stdcall;
    
//Verify whether to firmware version designated RTEX board.
function AxlGetFirmwareVersion(lBoardNo : LongInt; szVersion : PChar) : DWord; stdcall;
//Sent to firmware designated board.
function AxlSetFirmwareCopy(lBoardNo : LongInt; wData : PWord; wCmdData : PWord) : DWord; stdcall;
//Execute Firmware update to designated board.
function AxlSetFirmwareUpdate(lBoardNo : LongInt) : DWord; stdcall;
//Verify whether currently RTEX status Initialized.
function AxlCheckStatus(lBoardNo : LongInt; dwStatus : PDWord) : DWord; stdcall;
//To Initialized currently RTEX on designated board.
function AxlInitRtex(lBoardNo : LongInt; dwOption : DWord) : DWord; stdcall;
//Execute universal command designated axis of board.
function AxlRtexUniversalCmd(lBoardNo : LongInt; wCmd : Word; wOffset : Word; wData : PWord) : DWord; stdcall;
//Execute RTEX communication command designated axis.
function AxmRtexSlaveCmd(lAxisNo : LongInt; dwCmdCode : DWord; dwTypeCode : DWord; dwIndexCode : DWord; dwCmdConfigure : DWord; dwValue : DWord) : DWord; stdcall;
//Verify whether Result of RTEX communication command designated axis.
function AxmRtexGetSlaveCmdResult(lAxisNo : LongInt; dwIndex : PDWord; dwValue : PDWord) : DWord; stdcall;
//Verify whether RTEX status information designated axis.
function AxmRtexGetAxisStatus(lAxisNo : LongInt; dwStatus : PDWord) : DWord; stdcall;
//Verify whether RTEX communication return information designated axis.(Actual position, Velocity, Torque)
function AxmRtexGetAxisReturnData(lAxisNo : LongInt;  dwReturn1 : PDWord; dwReturn2 : PDWord; dwReturn3 : PDWord) : DWord; stdcall;
//Verify whether currently status information of RTEX slave axis.(mechanical, Inposition and etc)
function AxmRtexGetAxisSlaveStatus(lAxisNo : LongInt; dwStatus : PDWord) : DWord; stdcall;
function AxmSetAxisCmd(lAxisNo : LongInt; tagCommand : PDWord) : DWord; stdcall;
function AxmGetAxisCmdResult(lAxisNo : LongInt; tagCommand : PDWORD) : DWord; stdcall;
function AxlGetDpRamData(lBoardNo : LongInt; wAddress : Word; dwpRdData : PDWord) : DWord; stdcall;

function AxlBoardReadDpramWord(lBoardNo : LongInt; wOffset : Word; dwpRdData : PDWord) : DWord; stdcall;
function AxlSetSendBoardCommand(lBoardNo : LongInt; dwCommand : DWord; dwpSendData : PDWord; dwLength : DWord) : DWord; stdcall;
function AxlGetResponseBoardCommand(lBoardNo : LongInt; dwpReadData : PDWord) : DWord; stdcall;
function AxmInfoGetFirmwareVersion(lAxisNo : LongInt;  ucaFirmwareVersion : PWord) : DWord; stdcall;
function AxaInfoGetFirmwareVersion(lModuleNo : LongInt; ucaFirmwareVersion : PWord) : DWord; stdcall;
function AxdInfoGetFirmwareVersion(lModuleN : LongInt; ucaFirmwareVersion : PWord) : DWord; stdcall;
function AxmSetTorqFeedForward(lAxisNo : LongInt; dwTorqFeedForward : DWord) : DWord; stdcall;
function AxmGetTorqFeedForward(lAxisNo : LongInt; dwpTorqFeedForward : PDWord) : DWord; stdcall;
function AxmSetVelocityFeedForward(lAxisNo : LongInt; dwVelocityFeedForward : DWord) : DWord; stdcall;
function AxmGetVelocityFeedForward(lAxisNo : LongInt; dwpVelocityFeedForward : PDWord) : DWord; stdcall;

// Set Encoder type.
// Default value : 0(TYPE_INCREMENTAL)
// Setting range : 0 ~ 1
// dwEncoderType : 0(TYPE_INCREMENTAL), 1(TYPE_ABSOLUTE).
function AxmSignalSetEncoderType(lAxisNo : LongInt; dwEncoderType : DWord) : DWord; stdcall;

// Verify Encoder type.
function AxmSignalGetEncoderType(lAxisNo : LongInt; dwpEncoderType : PDWord) : DWord; stdcall;

// For updating the slave firmware(only for RTEX-PM).
//function AxmSetSendAxisCommand(lAxisNo : LongInt; wCommand : Word; wpSendData : PDWord; wLength : Word) : DWord; stdcall;

//======== Only for PCI-R1604-RTEX, RTEX-PM============================================================== 
// When Input Universal Input 2, 3, Set Jog move velocity
// Set only once execute after all drive setting (Ex, PulseOutMethod, MoveUnitPerPulse etc..)
function AxmMotSetUserMotion(lAxisNo : LongInt; dVelocity : Double; dAccel : Double; dDecel : Double) : DWord; stdcall;

// When Input Universal Input 2, 3, Set Jog move usage
// Setting value :  0(DISABLE), 1(ENABLE)
function AxmMotSetUserMotionUsage(lAxisNo: LongInt; dwUsage : DWord) : DWord; stdcall;

// Set Load/UnLoad Position to Automatically move use MPGP Input 
function  AxmMotSetUserPosMotion(lAxisNo : LongInt; dVelocity : Double; dAccel : Double; dDecel : Double; dLoadPos : Double; dUnLoadPos : Double; dwFilter : DWord; dwDelay : DWord) : DWord; stdcall;

// Set Usage Load/UnLoad Position to Automatically move use MPGP Input 
// Setting value :  0(DISABLE), 1(Position function A), 2(Position function B)
function  AxmMotSetUserPosMotionUsage(lAxisNo : LongInt; dwUsage : DWord) : DWord; stdcall;
//======================================================================================================== 

//======== SIO-CN2CH, Only for absolute position trigger module(B0) ================================================ 
function AxcKeWriteRamDataAddr(lChannelNo : LongInt; dwAddr : DWord; dwData : DWord) : DWord; stdcall;
function AxcKeReadRamDataAddr(lChannelNo : LongInt; dwAddr : DWord; dwpData : PDWord) : DWord; stdcall;
function AxcKeResetRamDataAll(lModuleNo : LongInt; dwData : DWord) : DWord; stdcall;
function AxcTriggerSetTimeout(lChannelNo : LongInt; dwTimeout : DWord) : DWord; stdcall;
function AxcTriggerGetTimeout(lChannelNo : LongInt; dwpTimeout : PDWord) : DWord; stdcall;
function AxcStatusGetWaitState(lChannelNo : LongInt; dwpState : PDWord) : DWord; stdcall;
function AxcStatusSetWaitState(lChannelNo : LongInt; dwState : DWord) : DWord; stdcall;
//======================================================================================================== 
	
//======== Only for PCI-N804/N404, Sequence Motion ===========================================================
// Set Axis Information of sequence Motion (min 1axis)
// lSeqMapNo : Sequence Motion Index Point
// lSeqMapSize : Number of axis
// long* LSeqAxesNo : Number of arrary
function AxmSeqSetAxisMap(lSeqMapNo : LongInt; lSeqMapSize : LongInt; lSeqAxesNo : PLongInt) : DWord; stdcall;
function AxmSeqGetAxisMap(lSeqMapNo : LongInt; lSeqMapSize : PLongInt; lSeqAxesNo : PLongInt) : DWord; stdcall;

// Set Standard(Master)Axis of Sequence Motion.
// By all means Set in AxmSeqSetAxisMap setting axis.
function AxmSeqSetMasterAxisNo(lSeqMapNo : LongInt; lMasterAxisNo : LongInt) : DWord; stdcall;

// Notifies the library node start loading of Sequence Motion.
function AxmSeqBeginNode(lSeqMapNo : LongInt) : DWord; stdcall;

// Notifies the library node end loading of Sequence Motion.
function AxmSeqEndNode(lSeqMapNo : LongInt) : DWord; stdcall;

// Start Sequence Motion Move.
function AxmSeqStart(lSeqMapNo : LongInt; dwStartOption : DWord) : DWord; stdcall;

// Set each profile node Information of Sequence Motion in Library.
// if used 1axis Sequence Motion, Must be Set *dPosition one Array.
function AxmSeqAddNode(lSeqMapNo : LongInt; dPosition : PDouble; dVelocity : Double; dAcceleration : Double; dDeceleration : Double; dNextVelocity : Double) : DWord; stdcall;

// Return Node Index number of Sequence Motion.
function AxmSeqGetNodeNum(lSeqMapNo : LongInt; lCurNodeNo : PLongInt) : DWord; stdcall;

// Return All node count of Sequence Motion.
function AxmSeqGetTotalNodeNum(lSeqMapNo : LongInt; lTotalNodeCnt : PLongInt) : DWord; stdcall;

// Return Sequence Motion drive status  of specific SeqMap.
// dwInMotion : 0(Drive end), 1(In drive)
function AxmSeqIsMotion(lSeqMapNo : LongInt; dwInMotion : PDWord) : DWord; stdcall;

// Clear Sequence Motion Memory.
function AxmSeqWriteClear(lSeqMapNo : LongInt) : DWord; stdcall;

// Stop sequence motion
// dwStopMode : 0(EMERGENCY_STOP), 1(SLOWDOWN_STOP) 
function AxmSeqStop(lSeqMapNo : LongInt; dwStopMode : DWord) : DWord; stdcall;
//======================================================================================================== 

implementation
const         
    dll_name    = 'AXL.dll';
    function AxlGetBoardAddress; external dll_name name 'AxlGetBoardAddress';
    function AxlGetBoardID; external dll_name name 'AxlGetBoardID';
    function AxlGetBoardVersion; external dll_name name 'AxlGetBoardVersion';
    function AxlGetModuleID; external dll_name name 'AxlGetModuleID';
    function AxlGetModuleVersion; external dll_name name 'AxlGetModuleVersion';
    function AxlGetModuleNodeInfo; external dll_name name 'AxlGetModuleNodeInfo';
    
    function AxlSetDataFlash; external dll_name name 'AxlSetDataFlash';
    function AxlGetDataFlash; external dll_name name 'AxlGetDataFlash';
    
    function AxaInfoGetModuleNo; external dll_name name 'AxaInfoGetModuleNo';
    function AxdInfoGetModuleNo; external dll_name name 'AxdInfoGetModuleNo';
    
    function AxmSetCommand; external dll_name name 'AxmSetCommand';
    function AxmSetCommandData08; external dll_name name 'AxmSetCommandData08';
    function AxmGetCommandData08; external dll_name name 'AxmGetCommandData08';
    function AxmSetCommandData16; external dll_name name 'AxmSetCommandData16';
    function AxmGetCommandData16; external dll_name name 'AxmGetCommandData16';
    function AxmSetCommandData24; external dll_name name 'AxmSetCommandData24';
    function AxmGetCommandData24; external dll_name name 'AxmGetCommandData24';
    function AxmSetCommandData32; external dll_name name 'AxmSetCommandData32';
    function AxmGetCommandData32; external dll_name name 'AxmGetCommandData32';
    function AxmSetCommandQi; external dll_name name 'AxmSetCommandQi';
    function AxmSetCommandData08Qi; external dll_name name 'AxmSetCommandData08Qi';
    function AxmGetCommandData08Qi; external dll_name name 'AxmGetCommandData08Qi';
    function AxmSetCommandData16Qi; external dll_name name 'AxmSetCommandData16Qi';
    function AxmGetCommandData16Qi; external dll_name name 'AxmGetCommandData16Qi';
    function AxmSetCommandData24Qi; external dll_name name 'AxmSetCommandData24Qi';
    function AxmGetCommandData24Qi; external dll_name name 'AxmGetCommandData24Qi';
    function AxmSetCommandData32Qi; external dll_name name 'AxmSetCommandData32Qi';
    function AxmGetCommandData32Qi; external dll_name name 'AxmGetCommandData32Qi';
    function AxmGetPortData; external dll_name name 'AxmGetPortData';
    function AxmSetPortData; external dll_name name 'AxmSetPortData';
    function AxmGetPortDataQi; external dll_name name 'AxmGetPortDataQi';
    function AxmSetPortDataQi; external dll_name name 'AxmSetPortDataQi';
    function AxmSetScriptCaptionIp; external dll_name name 'AxmSetScriptCaptionIp';
    function AxmGetScriptCaptionIp; external dll_name name 'AxmGetScriptCaptionIp';
    function AxmSetScriptCaptionQi; external dll_name name 'AxmSetScriptCaptionQi';
    function AxmGetScriptCaptionQi; external dll_name name 'AxmGetScriptCaptionQi';
    function AxmSetScriptCaptionQueueClear; external dll_name name 'AxmSetScriptCaptionQueueClear';
    function AxmGetScriptCaptionQueueCount; external dll_name name 'AxmGetScriptCaptionQueueCount';
    function AxmGetScriptCaptionQueueDataCount; external dll_name name 'AxmGetScriptCaptionQueueDataCount';
    function AxmGetOptimizeDriveData; external dll_name name  'AxmGetOptimizeDriveData';
    function AxmBoardWriteByte; external dll_name name 'AxmBoardWriteByte';
    function AxmBoardReadByte; external dll_name name 'AxmBoardReadByte';
    function AxmBoardWriteWord; external dll_name name 'AxmBoardWriteWord';
    function AxmBoardReadWord; external dll_name name 'AxmBoardReadWord';
    function AxmBoardWriteDWord; external dll_name name 'AxmBoardWriteDWord';
    function AxmBoardReadDWord; external dll_name name 'AxmBoardReadDWord';
    function AxmModuleWriteByte; external dll_name name 'AxmModuleWriteByte';
    function AxmModuleReadByte; external dll_name name 'AxmModuleReadByte';
    function AxmModuleWriteWord; external dll_name name 'AxmModuleWriteWord';
    function AxmModuleReadWord; external dll_name name 'AxmModuleReadWord';
    function AxmModuleWriteDWord; external dll_name name 'AxmModuleWriteDWord';
    function AxmModuleReadDWord; external dll_name name 'AxmModuleReadDWord';
    function AxmStatusSetActComparatorPos; external dll_name name 'AxmStatusSetActComparatorPos';
    function AxmStatusGetActComparatorPos; external dll_name name 'AxmStatusGetActComparatorPos';
    function AxmStatusSetCmdComparatorPos; external dll_name name 'AxmStatusSetCmdComparatorPos';
    function AxmStatusGetCmdComparatorPos; external dll_name name 'AxmStatusGetCmdComparatorPos';
    function AxmLineMoveVel; external dll_name name 'AxmLineMoveVel';
    function AxmSensorSetSignal; external dll_name name 'AxmSensorSetSignal';
    function AxmSensorGetSignal; external dll_name name 'AxmSensorGetSignal';
    function AxmSensorReadSignal; external dll_name name 'AxmSensorReadSignal';
    function AxmSensorMovePos; external dll_name name 'AxmSensorMovePos';
    function AxmSensorStartMovePos; external dll_name name 'AxmSensorStartMovePos';
    function AxmHomeGetStepTrace; external dll_name name 'AxmHomeGetStepTrace';
    function AxmHomeSetConfig; external dll_name name 'AxmHomeSetConfig';
    function AxmHomeGetConfig; external dll_name name 'AxmHomeGetConfig';
    function AxmHomeSetMoveSearch; external dll_name name 'AxmHomeSetMoveSearch';
    function AxmHomeSetMoveReturn; external dll_name name 'AxmHomeSetMoveReturn';
    function AxmHomeSetMoveLeave; external dll_name name 'AxmHomeSetMoveLeave';
    function AxmHomeSetMultiMoveSearch; external dll_name name 'AxmHomeSetMultiMoveSearch';
    function AxmContiSetProfileMode; external dll_name name 'AxmContiSetProfileMode';
    function AxmContiGetProfileMode; external dll_name name 'AxmContiGetProfileMode';

    function AxdiInterruptFlagReadBit; external dll_name name 'AxdiInterruptFlagReadBit';
    function AxdiInterruptFlagReadByte; external dll_name name 'AxdiInterruptFlagReadByte';
    function AxdiInterruptFlagReadWord; external dll_name name 'AxdiInterruptFlagReadWord';
    function AxdiInterruptFlagReadDword; external dll_name name 'AxdiInterruptFlagReadDword';
    function AxdiInterruptFlagRead; external dll_name name 'AxdiInterruptFlagRead';
    function AxmLogSetAxis; external dll_name name 'AxmLogSetAxis';
    function AxmLogGetAxis; external dll_name name 'AxmLogGetAxis';
    function AxaiLogSetChannel; external dll_name name 'AxaiLogSetChannel';
    function AxaiLogGetChannel; external dll_name name 'AxaiLogGetChannel';
    function AxaoLogSetChannel; external dll_name name 'AxaoLogSetChannel';
    function AxaoLogGetChannel; external dll_name name 'AxaoLogGetChannel';
    function AxdLogSetModule; external dll_name name 'AxdLogSetModule';
    function AxdLogGetModule; external dll_name name 'AxdLogGetModule';
    function AxlGetFirmwareVersion; external dll_name name 'AxlGetFirmwareVersion';
    function AxlSetFirmwareCopy; external dll_name name 'AxlSetFirmwareCopy';
    function AxlSetFirmwareUpdate; external dll_name name 'AxlSetFirmwareUpdate';
    function AxlCheckStatus; external dll_name name 'AxlCheckStatus';
    function AxlInitRtex; external dll_name name 'AxlInitRtex';
    function AxlRtexUniversalCmd; external dll_name name 'AxlRtexUniversalCmd';
    function AxmRtexSlaveCmd; external dll_name name 'AxmRtexSlaveCmd';
    function AxmRtexGetSlaveCmdResult; external dll_name name 'AxmRtexGetSlaveCmdResult';
    function AxmRtexGetAxisStatus; external dll_name name 'AxmRtexGetAxisStatus';
    function AxmRtexGetAxisReturnData; external dll_name name 'AxmRtexGetAxisReturnData';
    function AxmRtexGetAxisSlaveStatus; external dll_name name 'AxmRtexGetAxisSlaveStatus';

    function AxmSetAxisCmd; external dll_name name 'AxmSetAxisCmd'; 
    function AxmGetAxisCmdResult; external dll_name name 'AxmGetAxisCmdResult'; 
    function AxlGetDpRamData; external dll_name name 'AxlGetDpRamData'; 
    function AxlBoardReadDpramWord; external dll_name name 'AxlBoardReadDpramWord'; 
    function AxlSetSendBoardCommand; external dll_name name 'AxlSetSendBoardCommand'; 
    function AxlGetResponseBoardCommand; external dll_name name 'AxlGetResponseBoardCommand'; 
    function AxmInfoGetFirmwareVersion; external dll_name name 'AxmInfoGetFirmwareVersion'; 
    function AxaInfoGetFirmwareVersion; external dll_name name 'AxaInfoGetFirmwareVersion'; 
    function AxdInfoGetFirmwareVersion; external dll_name name 'AxdInfoGetFirmwareVersion'; 
    function AxmSetTorqFeedForward; external dll_name name 'AxmSetTorqFeedForward'; 
    function AxmGetTorqFeedForward; external dll_name name 'AxmGetTorqFeedForward'; 
    function AxmSetVelocityFeedForward; external dll_name name 'AxmSetVelocityFeedForward'; 
    function AxmGetVelocityFeedForward; external dll_name name 'AxmGetVelocityFeedForward'; 
    
    function AxmSignalSetEncoderType; external dll_name name 'AxmSignalSetEncoderType'; 
    function AxmSignalGetEncoderType; external dll_name name 'AxmSignalGetEncoderType'; 
    //function AxmSetSendAxisCommand; external dll_name name 'AxmSetSendAxisCommand';
    function AxmMotSetUserMotion; external dll_name name 'AxmMotSetUserMotion';
    function AxmMotSetUserMotionUsage; external dll_name name 'AxmMotSetUserMotionUsage';
    function AxmMotSetUserPosMotion; external dll_name name 'AxmMotSetUserPosMotion';
    function AxmMotSetUserPosMotionUsage; external dll_name name 'AxmMotSetUserPosMotionUsage';
    function AxcKeWriteRamDataAddr; external dll_name name 'AxcKeWriteRamDataAddr';
    function AxcKeReadRamDataAddr; external dll_name name 'AxcKeReadRamDataAddr';
    function AxcKeResetRamDataAll; external dll_name name 'AxcKeResetRamDataAll';
    function AxcTriggerSetTimeout; external dll_name name 'AxcTriggerSetTimeout';
    function AxcTriggerGetTimeout; external dll_name name 'AxcTriggerGetTimeout';
    function AxcStatusGetWaitState; external dll_name name 'AxcStatusGetWaitState';
    function AxcStatusSetWaitState; external dll_name name 'AxcStatusSetWaitState';
    function AxmSeqSetAxisMap; external dll_name name 'AxmSeqSetAxisMap';
    function AxmSeqGetAxisMap; external dll_name name 'AxmSeqGetAxisMap';
    function AxmSeqSetMasterAxisNo; external dll_name name 'AxmSeqSetMasterAxisNo';
    function AxmSeqBeginNode; external dll_name name 'AxmSeqBeginNode';
    function AxmSeqEndNode; external dll_name name 'AxmSeqEndNode';
    function AxmSeqStart; external dll_name name 'AxmSeqStart';
    function AxmSeqAddNode; external dll_name name 'AxmSeqAddNode';
    function AxmSeqGetNodeNum; external dll_name name 'AxmSeqGetNodeNum';
    function AxmSeqGetTotalNodeNum; external dll_name name 'AxmSeqGetTotalNodeNum';
    function AxmSeqIsMotion; external dll_name name 'AxmSeqIsMotion';
    function AxmSeqWriteClear; external dll_name name 'AxmSeqWriteClear';
    function AxmSeqStop; external dll_name name 'AxmSeqStop';
end.
