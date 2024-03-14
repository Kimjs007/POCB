unit MotionCtl;

interface
{$I Common.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,  System.Classes, Vcl.ExtCtrls,
  DefPocb, CommonClass, DefDio, DefMotion, UserUtils,
{$IFDEF USE_MOTION_AXT}
	AxtCAMCFS20, MotionCtlAxt,
{$ENDIF}
{$IFDEF USE_MOTION_AXM}
  MotionCtlAxm,
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
  MotionCtlEzi,
{$ENDIF}
CodeSiteLogging;

type
  //============================================================================
  InMotionStatus      = procedure(nMotionID: Integer; nMode,nErrCode: Integer; sMsg: String) of object;
  InMaintMotionStatus = procedure(nMotionID: Integer; nMode,nErrCode: Integer; sMsg: String) of object;

  //============================================================================
  PTestGuiMotionData = ^RTestGuiMotionData;   // to frmTest1Ch
  RTestGuiMotionData = record
    MsgType   : Integer;
    Channel   : Integer;
    Mode      : Integer;
    Param     : Integer;
    Msg       : string; //string[250];
    MotionStatus : MotionStatusRec;
  end;

  PMainGuiMotionData = ^RMainGuiMotionData;   // to MainPocb //2019-04-06
  RMainGuiMotionData = record
    MsgType   : Integer;
    Channel   : Integer;
    Mode      : Integer;
    Param     : Integer;  // MotionID : DefMotion.MOTIONID_xxxxxx
    Param2    : Integer;  // MotionControlMode : DefPocb.MSG_MODE_MOTION_xxxxxx;
    Param3    : Integer;  // ErrCode : DefPocb.ERR_MOTION_xxxxxx
    Msg       : string; //string[250];
  end;

  //============================================================================
  TMotion = class(TObject)
    private
      //
      m_hMain       		  : HWND;   // frmMain
      tmrGetMotionStatus  : TTimer;
      procedure OnGetMotionStatusTimer(Sender: TObject);
			procedure SendMotionEvent(nMotionCtlMode: Integer; nErrCode: Integer; sMsg: string);
      procedure SendTestGuiDisplay(nGuiMode, nCh: Integer; nAxisType: Integer; sMsg: string);
      procedure SendMainGuiDisplay(nGuiMode, nMotionCtlMode, nErrCode: Integer; sMsg: string);  //2019-004-07
      procedure ThreadTask(task: TProc);
    public
			m_nMotionID   		: Integer;	// A2CH: Axt(0~3), Ezi(4~5)
			m_nMotionDev   		: Integer;	// A2CH: Axt, EziMLPE
      m_nCh         		: Integer;	// A2CH: ch1~ch2
      m_nJig            : Integer;
			m_nAxisType   		: Integer;	// A2CH: Z-axis, Y-axis, Focus
			m_nMotorNo   			: Integer;	// A2CH: nMotorNo(common) = nAxisNo(Axt) = nBdNo(Ezi)
			m_nAxisNo    			: Integer;	// A2CH: 'nAxisNo' for Axt(0~3), 'nBdNo' for Ezi(0~1)
			m_nBdNo    				: Integer;	// A2CH: 'nAxisNo' for Axt(0~3), 'nBdNo' for Ezi(0~1)
      //
{$IFDEF USE_MOTION_AXM}
      MotionAxm 			  : TMotionAxm;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
      MotionAxt 			  : TMotionAxt;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
      MotionEzi 			  : TMotionEzi;
{$ENDIF}
      // Motor Status
      m_bConnected    	: Boolean;
      m_bServoOn    		: Boolean;
      m_nPreActPos      : Double;
      m_nActualPos    	: Double;
      m_sErrLibApi      : string;
      //
      m_bInitDone       : Boolean;  // 초기화 여부
      m_bHomeDone       : Boolean;  // Home Search 완료 여부
      m_bModelPos       : Boolean;  // Model Pos 위치 여부
      m_bServoRecover   : Boolean;
      m_bUpdatePos      : Boolean;
      m_bSyncMove       : Boolean; //TBD:A2CHv3:MOTION:SYNC-MOVE?
      m_bDioYaxisLoadPos: Boolean; //TBD:A2CHv3:MOTION:SYNC-MOVE?
      m_bHomeSearching  : Boolean; //2021-03-02
      //
      m_MotionStatus, m_MotionStatusOld : MotionStatusRec;
{$IFDEF  SIMULATOR_MOTION}
      m_SimulatorMotionStatus : MotionStatusRec;
{$ENDIF}
			// TMotionAxt-specific ------------> in TMotorAxt
			// TMotionEzi-specific ------------> in TMotorEzi
			//
      constructor Create(hMain: THandle; nMotionID: Integer); virtual;
      destructor Destroy; override;
			//------------------------- TMotion: Connect/Close/MotionInit/MotionReset/ServoOnOff
			function Connect: Boolean;
			procedure Close;
			function MotionInit: Boolean;
			function MotionReset: Boolean;
			function ServoOnOff(bIsOn: Boolean) : Boolean;
			//------------------------- TMotion: Move Start/Stop
			function MoveStop(bIsEMS: Boolean = False): Boolean;
			//---------------------- TMotion: Move ABS/INC/JOG/LIMIT/HOME
      function MoveABS(nMode: Integer; dAbsPos: Double; dVel: Double = 0; dAccel: Double = 0; dStartStop: Double = 0): Boolean;
      function MoveINC(dIncDecPos: Double; dVel: Double = 0; dAccel: Double = 0; dStartStop: Double = 0): Boolean;
      function MoveJOG(bIsPlus: Boolean; dJogVel: Double = 0; dJogAccel: Double = 0): Boolean;
      function MoveLIMIT(bIsPlus: Boolean; dJogVel: Double = 0; dJogAccel: Double = 0): Boolean;
      function MoveHOME: Boolean;
			//---------------------- TMotion: Y-Axis Move FORWARD/BACKWORD
      function MoveFORWARD: Boolean;
      function MoveBACKWARD: Boolean;
{$IFDEF HAS_MOTION_TILTING}
			//---------------------- TMotion: T-Axis Move Up/Down
      function MoveTILTUP: Boolean; //TBD:F2CH:MOTION:T-AXIS?
      function MoveTILTDOWN: Boolean; //TBD:F2CH:MOTION:T-AXIS?
{$ENDIF}
			//---------------------- TMotion: Get/Set
			function GetActPos: Double;
			function GetCmdPos: Double;
			function SetActPos(dActPos: Double): Boolean;
			function SetCmdPos(dCmdPos: Double): Boolean;
			function IsMotionMoving: Boolean;
{$IFDEF SIMULATOR_MOTION}
      function SimMotionMoveABS(MotionParam: RMotionParam; dAbsPos: Double): Integer;
      function SimMotionGetMotionStatus(var MotionStatus: MotionStatusRec): Boolean;
      procedure SimMotionSetUnitPerPulse(Value: Double);
      procedure SimMotionSetStartStopSpeed(Value: Double);
      procedure SimMotionSetMaxSpeed(Value: Double);
      procedure SimMotionSetIsInMotion(Value: Boolean);
      procedure SimMotionSetIsMotionDone(Value: Boolean);
      procedure SimMotionSetEndStatus(Value: WORD);
      procedure SimMotionSetMechSignal(Value: WORD);
      procedure SimMotionSetActualPos(Value: Double);
      procedure SimMotionSetCommandPos(Value: Double);
      procedure SimMotionSetActCmdPosDiff(Value: Double);
      procedure SimMotionSetServoEnable(Value: BYTE);
      procedure SimMotionSetUseInPosSig(Value: BYTE);
      procedure SimMotionSetUseAlarmSig(Value: BYTE);
      procedure SimMotionSetUnivInSignal(Value: BYTE);
      procedure SimMotionSetUnivOutSignal(Value: BYTE);
{$ENDIF}
  end;

  TMotionCtl = class(TObject)
    private
			// for FrmMain
      m_hMain           	: HWND;
      FMotionStatus      	: InMotionStatus;
			// for Mainter
    //FIsMainter        	: Boolean;
      FMaintMotionUse   	: Boolean;
      FMaintMotionStatus	: InMaintMotionStatus;
			// for FrmMain
      procedure SetMotionStatus(const Value: InMotionStatus);
			// for Mainter
    //procedure SetIsMainter(const Value: Boolean);
      procedure SetMaintMotionUse(const Value: Boolean);
      procedure SetMaintMotionStatus(const Value: InMaintMotionStatus);
      function  GetIsHomeDoneAll : Boolean;
      function  GetIsAnyMotorMoving : Boolean;
    public
			// 
      m_hTest : array[DefPocb.JIG_A..DefPocb.JIG_MAX] of HWND;  // for MotionCtl->frmTest1Ch
      Motion  : array[DefMotion.MOTIONID_BASE..DefMotion.MOTIONID_MAX] of TMotion;
      m_nOldMotorDIValue, m_nMotorDIValue, m_nMotorDOValue, m_nMotorPreEmsDOValue  : DWORD;
      m_bDioAssyJigOn      : Boolean; //TBD:A2CHv3:MOTION:SYNC-MOVE?
      m_bDioAssyJigAligned : Boolean; //TBD:A2CHv3:MOTION:SYNC-MOVE?
			// for FrmMain
      property MotionStatus : InMotionStatus read FMotionStatus write SetMotionStatus;
			// for Mainter
    //property IsMainter : Boolean read FIsMainter write SetIsMainter;
      property IsHomeDoneAll : Boolean read GetIsHomeDoneAll;
      property IsAnyMotorMoving : Boolean read GetIsAnyMotorMoving;
    	property MaintMotionUse    : Boolean read FMaintMotionUse write SetMaintMotionUse;
      property MaintMotionStatus : InMaintMotionStatus read FMaintMotionStatus write SetMaintMotionStatus;
			//
      constructor Create(hMain: THandle{; nBdCnt: Integer}); virtual;
      destructor Destroy; override;
      procedure Connect;
      //
      function GetChAxis2MotionID(nCh: Integer; nAxis: Integer; var nMotionID: Integer): Boolean;
      function GetMotionID2ChAxis(nMotionId: Integer; var nCh: Integer; var nAxis: Integer): Boolean;
      function GetMotionID2MotionDev(nMotionID: Integer; var nMotionDev: Integer): Boolean;
      function CheckMotionMovable(nCh: Integer; nAxis: Integer; var sReasonMsg: string): Boolean; overload;  //TBD:A2CHv3:MOTION?
      function CheckMotionMovable(nMotionID: Integer; var sReasonMsg: string): Boolean; overload;            //TBD:A2CHv3:MOTION?
      function CheckMotionPosForShutterDown(nCh: Integer): Boolean;
      function IsSameMotionPos(pos1, pos2: Double): Boolean;  //2021-10-27
      //
      {$IFDEF SUPPORT_1CG2PANEL}
      function SetYAxisSyncMode: Boolean; //TBD:A2CHv3:MOTION:SYNC-MOVE?
      function ResetYAxisSyncMode: Boolean;  //TBD:A2CHv3:MOTION:SYNC-MOVE?
      function GetYAxisSyncStatus(nMyAxisNo: LongInt; var nSyncStatus: enumMotionSyncStatus; var nOppAxisNo: LongInt; var dSlaveRatio: Double): Boolean; //TBD:A2CHv3:MOTION:SYNC-MOVE?
      {$ENDIF}
  end;

//const

var
  DongaMotion : TMotionCtl;

implementation

uses DioCtl;

//##############################################################################
//
{ TMotionCtl }
//
//##############################################################################

//******************************************************************************
// procedure/function: TMotionCtl: Create/Destroy/Init
// 		- constructor TMotionCtl.Create(hMain: THandle);
//		- destructor TMotionCtl.Destroy;
//    - procedure TMotionCtl.Connect;
//******************************************************************************

//------------------------------------------------------------------------------
//
constructor TMotionCtl.Create(hMain: THandle);
var
  nMotionID : Integer;
  nJig: Integer;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<MotionCtl> Create');
  m_hMain := hMain;
  for nJig := DefPocb.JIG_A to DefPocb.JIG_MAX do begin
    m_hTest[nJig] := 0;
  end;
  for nMotionID := DefMotion.MOTIONID_BASE to DefMotion.MOTIONID_MAX do begin
  	//-------------------------- Motion (Create)
		Motion[nMotionID] := TMotion.Create(hMain,nMotionID);
  	//-------------------------- MotionAxt|MotionEzi (Create)
  	case Motion[nMotionID].m_nMotionDev	of
      {$IFDEF USE_MOTION_AXM}
	  	DefMotion.MOTION_DEV_AxmMC:
        Motion[nMotionID].MotionAxm := TMotionAxm.Create(hMain,nMotionID,Motion[nMotionID].m_nCh,Motion[nMotionID].m_nAxisType,Motion[nMotionID].m_nAxisNo);
      {$ENDIF}
      {$IFDEF USE_MOTION_AXT}
	  	DefMotion.MOTION_DEV_AxtMC:
        Motion[nMotionID].MotionAxt := TMotionAxt.Create(hMain,nMotionID,Motion[nMotionID].m_nCh,Motion[nMotionID].m_nAxisType,Motion[nMotionID].m_nAxisNo);
      {$ENDIF}
      {$IFDEF USE_MOTION_EZIML}
		  DefMotion.MOTION_DEV_EziML:
        Motion[nMotionID].MotionEzi := TMotionEzi.Create(hMain,nMotionID,Motion[nMotionID].m_nCh,Motion[nMotionID].m_nAxisType,Motion[nMotionID].m_nBdNo);
      {$ENDIF}
  	end;
  end;
  m_nOldMotorDIValue  := 0;
  m_nMotorDIValue     := 0;
  m_nMotorDOValue     := 0;
	// for Mainter
  FMaintMotionUse	:= False;	
end;

//------------------------------------------------------------------------------
//
procedure TMotionCtl.Connect;
var
  nMotionID : Integer;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<MotionCtl> Connect');
  for nMotionID := DefMotion.MOTIONID_BASE to DefMotion.MOTIONID_MAX do begin
    //-------------------------- MotionAxt|MotionEzi (Connect & Initiailize)
  	if Motion[nMotionID].Connect then begin
	  	if Motion[nMotionID].MotionInit then begin
        Motion[nMotionID].m_bConnected := True;
		  	// Axt|Ezi Motion Device Connect & Init OK
  		end
  		else begin
        Motion[nMotionID].m_bConnected := False;
  			// Axt|Ezi Motion Device Init Fail //TBD?
	  	end;
  	end
	  else begin
        Motion[nMotionID].m_bConnected := False;
		  // Axt|Ezi Motion Device Connect Fail //TBD?
  		//TBD?
	  end;
  end;

  //
  {$IFDEF SUPPORT_1CG2PANEL}
  if Common.SystemInfo.UseAssyPOCB {and DongaMotion.m_bDioAssyJigOn} then begin  //2021-10-26 (ASSY-POCB:StartUp/Initial/MainterClose) SetYAxisSyncMode regardless of DioAssyJigOn
    if Motion[MOTIONID_AxMC_STAGE1_Y].m_bConnected and Motion[MOTIONID_AxMC_STAGE2_Y].m_bConnected then begin
      SetYAxisSyncMode;
    end;
  end
  else begin
    if Motion[MOTIONID_AxMC_STAGE1_Y].m_bConnected and Motion[MOTIONID_AxMC_STAGE2_Y].m_bConnected then begin
      ResetYAxisSyncMode;
    end;
  end;
  {$ENDIF}
end;

//------------------------------------------------------------------------------
//
destructor TMotionCtl.Destroy;
var
  nMotionID : Integer;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<MotionCtl> Destroy');
	//-------------------------- Motion (Destroy)
  for nMotionID := DefMotion.MOTIONID_BASE to DefMotion.MOTIONID_MAX do begin
		if (Motion[nMotionID] <> nil) then begin
     	case Motion[nMotionID].m_nMotionDev	of
        {$IFDEF USE_MOTION_AXM}
	  	  DefMotion.MOTION_DEV_AxmMC: begin
          Motion[nMotionID].MotionAxm.CloseAxm;
    			Motion[nMotionID].MotionAxm.Free;
          Motion[nMotionID].MotionAxm := nil;
        end;
        {$ENDIF}
        {$IFDEF USE_MOTION_AXT}
	    	DefMotion.MOTION_DEV_AxtMC: begin
          Motion[nMotionID].MotionAxt.CloseAxt;
    			Motion[nMotionID].MotionAxt.Free;
          Motion[nMotionID].MotionAxt := nil;
        end;
        {$ENDIF}
        {$IFDEF USE_MOTION_EZIML}
	  	  DefMotion.MOTION_DEV_EziML: begin
          Motion[nMotionID].MotionEzi.CloseEzi;
    			Motion[nMotionID].MotionEzi.Free;
          Motion[nMotionID].MotionEzi := nil;
        end;
        {$ENDIF}
    	end;
      //
			Motion[nMotionID].Close;
			Motion[nMotionID].Free;
			Motion[nMotionID] := nil;
		end;
	end;

  inherited;
end;

//******************************************************************************
// procedure/function: 
//		- procedure TMotionCtl.SetMotionStatus(const Value: InMotorEvnt);
//		- procedure TMotionCtl.SetMaintMotionStatus(const Value: InMotorEvntMaint);
//		- procedure TMotionCtl.SetIsMainter(const Value: Boolean);
//******************************************************************************

procedure TMotionCtl.SetMotionStatus(const Value: InMotionStatus);
begin
  FMotionStatus := Value;
end;

//procedure TMotionCtl.SetIsMainter(const Value: Boolean);
//begin
//  FIsMainter := Value;
//end;

procedure TMotionCtl.SetMaintMotionUse(const Value: Boolean);
begin
  FMaintMotionUse := Value;
  if Value then begin
    //TBD:MOTION:MAINT?  if Assigned(MaintMotionStatus) then MaintMotionStatus(m_nGetDio,m_nSetDio);
  end;
end;

procedure TMotionCtl.SetMaintMotionStatus(const Value: InMaintMotionStatus);
begin
  FMaintMotionStatus := Value;
end;


//******************************************************************************
// procedure/function: 
//		- function TMotionCtl.GetChAxis2MotionID(nCh: Integer; nAxis: Integer; var nMotionID: Integer): Boolean;
//		- function TMotionCtl.GetMotionID2ChAxis(nMotionId: Integer; var nCh: Integer; var nAxis: Integer): Boolean;
//		- function TMotionCtl.GetMotionID2MotionDev(nMotionID: Integer; var nMotionDev: Integer): Boolean;
//******************************************************************************

//------------------------------------------------------------------------------
function TMotionCtl.GetChAxis2MotionID(nCh: Integer; nAxis: Integer; var nMotionID: Integer): Boolean;
var
  bRet : Boolean;
begin
  bRet := True;
  case nCh of
    DefPocb.CH_1: begin
      case nAxis of
{$IFDEF HAS_MOTION_CAM_Z}
        DefMotion.MOTION_AXIS_Z: nMotionID := DefMotion.MOTIONID_AxMC_STAGE1_Z;
{$ENDIF}
        DefMotion.MOTION_AXIS_Y: nMotionID := DefMotion.MOTIONID_AxMC_STAGE1_Y;
{$IFDEF HAS_MOTION_TILTING}
        DefMotion.MOTION_AXIS_T: nMotionID := DefMotion.MOTIONID_AxMC_STAGE1_T;
{$ENDIF}
        else bRet := False;
      end;
    end;
    DefPocb.CH_2: begin
      case nAxis of
{$IFDEF HAS_MOTION_CAM_Z}
        DefMotion.MOTION_AXIS_Z: nMotionID := DefMotion.MOTIONID_AxMC_STAGE2_Z;
{$ENDIF}
        DefMotion.MOTION_AXIS_Y: nMotionID := DefMotion.MOTIONID_AxMC_STAGE2_Y;
{$IFDEF HAS_MOTION_TILTING}
        DefMotion.MOTION_AXIS_T: nMotionID := DefMotion.MOTIONID_AxMC_STAGE2_T;
{$ENDIF}
        else bRet := False;
      end;
    end;
    else begin
      bRet := False;
    end;
  end;
  Result := bRet;
end;

function TMotionCtl.GetIsAnyMotorMoving: Boolean;
var
  nIndex : Integer;
begin
  for nIndex := 0 to Pred(Length(Motion)) do begin
    if (Motion[nIndex].IsMotionMoving) then
      Exit(True);
  end;

  Exit(False);
end;

function TMotionCtl.GetIsHomeDoneAll: Boolean;
var
  nIndex : Integer;
begin
  for nIndex := 0 to Pred(Length(Motion)) do begin
    if (not Motion[nIndex].m_bHomeDone) then
      Exit(False);
  end;

  Exit(True);
end;

function TMotionCtl.CheckMotionPosForShutterDown(nCh: Integer): Boolean;
begin
  Result := False;

  if nCh in [DefPOCB.CH_1..DefPOCB.CH_2] then begin
    if (Motion[nCh].m_bHomeDone and Motion[nCh].m_bModelPos) and
       not (Motion[nCh].m_bDioYaxisLoadPos or                                        // LoadPos
          //((Motion[nCh].m_MotionStatus.UnivInSignal and (1 shl 0)) <> 0) or        // Home
            ((Motion[nCh].m_MotionStatus.MechSignal and (1 shl 1)) <> 0)) then begin // -Limit
      Result := True;
    end;
  end
  else begin
    if (Motion[DefPOCB.CH_1].m_bHomeDone and Motion[DefPOCB.CH_1].m_bModelPos) and
       (Motion[DefPOCB.CH_2].m_bHomeDone and Motion[DefPOCB.CH_2].m_bModelPos) and
       not (Motion[DefPOCB.CH_1].m_bDioYaxisLoadPos or   // LoadPos (CH1)
            Motion[DefPOCB.CH_2].m_bDioYaxisLoadPos or   // LoadPos (CH2)
          //((Motion[nCh].m_MotionStatus.UnivInSignal and (1 shl 0)) <> 0) or  // Home (CH1)
          //((Motion[nCh].m_MotionStatus.UnivInSignal and (1 shl 0)) <> 0) or  // Home (CH2)
            ((Motion[DefPOCB.CH_1].m_MotionStatus.MechSignal and (1 shl 1)) <> 0) or          //-Limit (CH1)
            ((Motion[DefPOCB.CH_2].m_MotionStatus.MechSignal and (1 shl 1)) <> 0)) then begin //-Limit (CH2)
      Result := True;
    end;
  end;
end;

//------------------------------------------------------------------------------
function TMotionCtl.GetMotionID2ChAxis(nMotionId: Integer; var nCh: Integer; var nAxis: Integer): Boolean;
var
  bRet : Boolean;
begin
  bRet := True;
  case nMotionID of
{$IFDEF HAS_MOTION_CAM_Z}
    DefMotion.MOTIONID_AxMC_STAGE1_Z: begin nCh := CH_1; nAxis := MOTION_AXIS_Z; end;
    DefMotion.MOTIONID_AxMC_STAGE2_Z: begin nCh := CH_2; nAxis := MOTION_AXIS_Z; end;
{$ENDIF}
    DefMotion.MOTIONID_AxMC_STAGE1_Y: begin nCh := CH_1; nAxis := MOTION_AXIS_Y; end;
    DefMotion.MOTIONID_AxMC_STAGE2_Y: begin nCh := CH_2; nAxis := MOTION_AXIS_Y; end;
{$IFDEF HAS_MOTION_TILTING}
    DefMotion.MOTIONID_AxMC_STAGE1_T: begin nCh := CH_1; nAxis := MOTION_AXIS_T; end;
    DefMotion.MOTIONID_AxMC_STAGE2_T: begin nCh := CH_2; nAxis := MOTION_AXIS_T; end;
{$ENDIF}
    else bRet := False;
  end;
  Result := bRet;
end;

//------------------------------------------------------------------------------
function TMotionCtl.GetMotionID2MotionDev(nMotionID: Integer; var nMotionDev: Integer): Boolean;
var
  bRet : Boolean;
begin
  bRet := True;
  case nMotionID of
{$IFDEF HAS_MOTION_TILTING}
    DefMotion.MOTIONID_AxMC_STAGE1_T,
    DefMotion.MOTIONID_AxMC_STAGE2_T,
{$ENDIF}
{$IFDEF HAS_MOTION_CAM_Z}
    DefMotion.MOTIONID_AxMC_STAGE1_Z,
    DefMotion.MOTIONID_AxMC_STAGE2_Z,
{$ENDIF}
    DefMotion.MOTIONID_AxMC_STAGE1_Y,
    DefMotion.MOTIONID_AxMC_STAGE2_Y:
{$IFDEF USE_MOTION_AXT}
      nMotionDev := MOTION_DEV_AxtMC;  //A2CH
{$ENDIF}
{$IFDEF USE_MOTION_AXM}
      nMotionDev := MOTION_DEV_AxmMC;  //F2CH|A2CHv2
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
    DefMotion.MOTIONID_EziML_STAGE1_F,
    DefMotion.MOTIONID_EziML_STAGE2_F:
      nMotionDev := MOTION_DEV_EziML;
{$ENDIF}
    else bRet := False;
	end;
  Result := bRet;
end;

function TMotionCtl.IsSameMotionPos(pos1, pos2: Double): Boolean;  //2021-10-27
begin
  Result := False;
  if Abs(pos1 - pos2) <= DefMotion.MOTION_POS_TOLERANCE then Result := True;
end;

{$IFDEF SUPPORT_1CG2PANEL}
//******************************************************************************
// procedure/function: TMotionCtl: SyncMode
//		-
//		-
//******************************************************************************

//------------------------------------------------------------------------------
//
function TMotionCtl.SetYAxisSyncMode: Boolean;  //TBD:A2CHv3:MOTION:SYNC? (실패시, ALARM???)
var
  nMode : integer;
  nRet  : Integer;
  sMsg  : string;
  //
  nMasterAxis, nSlaveAxisTarget, nSlaveAxisRead: LongInt;
  nSyncStatus : enumMotionSyncStatus;
  dSlaveRatioTarget, dSlaveRatioRead : Double;
  bSetOK, bGetOK : Boolean;
  sDebug : string;
begin
  nMode := DefPocb.MSG_MODE_MOTION_SYNCMODE_SET;
  nRet  := DefPocb.ERR_MOTION_SYNCMODE_SET;
  sMsg  := 'CH1/CH2:Y-axis: SyncMode ON';
  CodeSite.Send(sMsg+':start');
  //
  nMasterAxis       := DefMotion.AxMC_AXISNO_STAGE1_Y;  //A2CHv3: = MOTIONID_AxMC_STAGE1_Y
  nSlaveAxisTarget  := DefMotion.AxMC_AXISNO_STAGE2_Y;  //A2CHv3: = MOTIONID_AxMC_STAGE2_Y
  dSlaveRatioTarget := MOTION_SYNCMODE_SLAVE_RATIO;
  bSetOK := False;
  bGetOK := False;

  //------------------------- Check
  if (Motion[nMasterAxis].m_MotionStatus.nSyncStatus <> SyncNone) then begin
    sDebug := sMsg+Format(': Warning(MasterAxis%d.nSyncStatus=%d <>SyncNone)',[nMasterAxis,Ord(Motion[nMasterAxis].m_MotionStatus.nSyncStatus)]);
    CodeSite.Send(sDebug);
  end;
  if (Motion[nSlaveAxisTarget].m_MotionStatus.nSyncStatus <> SyncNone) then begin
    sDebug := sMsg+Format(': Warning(SlaveAxis%d.nSyncStatus=%d <>SyncNone)',[nSlaveAxisTarget,Ord(Motion[nSlaveAxisTarget].m_MotionStatus.nSyncStatus)]);
    CodeSite.Send(sDebug);
  end;

  //------------------------- Reset Sync
  nRet := Motion[nMasterAxis].MotionAxm.SetEGearLinkMode(nMasterAxis,nSlaveAxisTarget,dSlaveRatioTarget);
  if nRet = DefPocb.ERR_OK then begin
    bSetOK := True;
  end
  else begin
    sDebug := sMsg+Format(': SetEGearLinkMode(MasterAxis=%d,SlaveAxis=%d,SlaveRatio=%f: Failed',[nMasterAxis,nSlaveAxisTarget,dSlaveRatioTarget]);
    CodeSite.Send(sDebug);
    Sleep(10);
    nRet := Motion[nMasterAxis].MotionAxm.SetEGearLinkMode(nMasterAxis,nSlaveAxisTarget,dSlaveRatioTarget);
    if nRet <> DefPocb.ERR_OK then begin
      sDebug := sMsg+Format(': SetEGearLinkMode(MasterAxis=%d,SlaveAxis=%d,SlaveRatio=%f: Failed(retry)',[nMasterAxis,nSlaveAxisTarget,dSlaveRatioTarget]);
      CodeSite.Send(sDebug);
    end;
  end;

  if bSetOK then begin
    {$IFDEF SIMULATOR_MOTION}
    Motion[nSlaveAxisTarget].MotionAxm.m_nSimSyncStatus     := DefMotion.SyncLinkSlave;
    Motion[nSlaveAxisTarget].MotionAxm.m_nSimSyncSlaveAxis  := nSlaveAxisTarget;
    Motion[nSlaveAxisTarget].MotionAxm.m_dSimSyncSlaveRatio := MOTION_SYNCMODE_SLAVE_RATIO;
    {$ENDIF}
    // Get Motion Device Sync Status
    bGetOK := GetYAxisSyncStatus(nMasterAxis, nSyncStatus, nSlaveAxisRead, dSlaveRatioRead);
    if not bGetOK then begin
      sDebug := sMsg+Format(': GetYAxisSyncStatus(MasterAxis=%d): Failed',[nMasterAxis]);
      CodeSite.Send(sDebug);
      Sleep(10);
      bGetOK := GetYAxisSyncStatus(nMasterAxis, nSyncStatus, nSlaveAxisRead, dSlaveRatioRead); //Retry
    end;
    if bGetOK then begin
      // Compare Motion Device Sync Status
      if (nSyncStatus <> SyncLinkMaster) then begin
        sDebug := sMsg+Format(': GetYAxisSyncStatus(MasterAxis=%d): Error(nSyncStatus=%d <> SyncLinkMaster)',[nMasterAxis,Ord(nSyncStatus)]);
        CodeSite.Send(sDebug);
      end
      else if (nSlaveAxisRead <> nSlaveAxisTarget) then begin
        sDebug := sMsg+Format(': GetYAxisSyncStatus(MasterAxis=%d): Error(nSlaveAxisRead=%d <> nSlaveAxisTarget=%d)',[nMasterAxis,nSlaveAxisRead,nSlaveAxisTarget]);
        CodeSite.Send(sDebug);
      end
      else if (dSlaveRatioRead <> dSlaveRatioTarget) then begin
        sDebug := sMsg+Format(': GetYAxisSyncStatus(MasterAxis=%d): Error(dSlaveRatioRead=%f <> dSlaveRatioTarget=%f)',[nMasterAxis,dSlaveRatioRead,dSlaveRatioTarget]);
        CodeSite.Send(sDebug);
      end
      else begin
        nRet := DefPocb.ERR_OK; //OK
      end;
    end
    else begin
      sDebug := sMsg+Format(': GetYAxisSyncStatus(MasterAxis=%d): Failed(retry)',[nMasterAxis]);
      CodeSite.Send(sDebug);
    end;
  end;

  if (nRet = DefPocb.ERR_OK) then begin
    //------------------------- OK : Update MotionSync Status
    sDebug := sMsg+Format(': OK (Master=%d,Slave=%d,SlaveRatio=%f)',[nMasterAxis,nSlaveAxisRead,dSlaveRatioRead]);
    CodeSite.Send(sDebug);
    Motion[nMasterAxis].SendMotionEvent(nMode,nRet,sMsg+' OK');
    Result := True;
  end
  else begin
    //------------------------- NG
    Motion[nMasterAxis].SendMotionEvent(nMode,nRet,sMsg+' NG');
    Result := False;
  end;
end;

//------------------------------------------------------------------------------
//
function TMotionCtl.ResetYAxisSyncMode: Boolean;
var
  nMode : integer;
  nRet  : Integer;
  sMsg  : string;
  //
  nMasterAxis, nSlaveAxisTarget, nSlaveAxisRead: LongInt;
  nSyncStatus : enumMotionSyncStatus;
  dSlaveRatioRead : Double;
  bResetOK, bGetOK : Boolean;
  sDebug : string;
begin
  nMode := DefPocb.MSG_MODE_MOTION_SYNCMODE_RESET;
  nRet  := DefPocb.ERR_MOTION_SYNCMODE_RESET;
  sMsg  := 'CH1/CH2:Y-Axis SyncMode OFF';
  CodeSite.Send(sMsg+':start');
  //
  nMasterAxis       := DefMotion.AxMC_AXISNO_STAGE1_Y;  // = MOTIONID_AxMC_STAGE1_Y
  nSlaveAxisTarget  := DefMotion.AxMC_AXISNO_STAGE2_Y;  // = MOTIONID_AxMC_STAGE2_Y
  dSlaveRatioRead   := MOTION_SYNCMODE_SLAVE_RATIO;
  bResetOK := False;
  bGetOK   := False;

  //------------------------- Check Current SyncStatus
  if (Motion[nMasterAxis].m_MotionStatus.nSyncStatus <> SyncLinkMaster) then begin
    sDebug := sMsg+Format(': Warning(MasterAxis%d.nSyncStatus=%d <> SyncLinkMaster)',[nMasterAxis,Ord(Motion[nMasterAxis].m_MotionStatus.nSyncStatus)]);
    CodeSite.Send(sDebug);
  //Exit;
  end;
  if (Motion[nSlaveAxisTarget].m_MotionStatus.nSyncStatus <> SyncLinkSlave) then begin
    sDebug := sMsg+Format(': Warning(SlaveAxis%d.nSyncStatus=%d <> SyncLinkSlave)',[nSlaveAxisTarget,Ord(Motion[nSlaveAxisTarget].m_MotionStatus.nSyncStatus)]);
    CodeSite.Send(sDebug);
  //Exit;
  end;

  //------------------------- Reset Sync
  nRet := Motion[nMasterAxis].MotionAxm.ResetEGearLinkMode(nMasterAxis);
  if nRet= DefPocb.ERR_OK then begin
    bResetOK := True;
  end
  else begin
    sDebug := sMsg+Format(': ResetEGearLinkMode(MasterAxis=%d): Failed',[nMasterAxis]);
    CodeSite.Send(sDebug);
    Sleep(10);    
    nRet := Motion[nMasterAxis].MotionAxm.ResetEGearLinkMode(nMasterAxis);
    if nRet <> DefPocb.ERR_OK then begin
      sDebug := sMsg+Format(': ResetEGearLinkMode(MasterAxis=%d): Failed(retry)',[nMasterAxis]);
      CodeSite.Send(sDebug);
    end;
  end;

  //------------------------- Verify Motion SyncStatus if ResetOK
  if bResetOK then begin
    {$IFDEF SIMULATOR_MOTION}
    Motion[nSlaveAxisTarget].MotionAxm.m_nSimSyncStatus     := DefMotion.SyncNone;
    Motion[nSlaveAxisTarget].MotionAxm.m_nSimSyncSlaveAxis  := MOTION_SYNCMODE_SLAVE_UNKNOWN;
    Motion[nSlaveAxisTarget].MotionAxm.m_dSimSyncSlaveRatio := MOTION_SYNCMODE_SLAVE_RATIO;
    {$ENDIF}
    // Get Motion Device Sync Status
    bGetOK := GetYAxisSyncStatus(nMasterAxis, nSyncStatus, nSlaveAxisRead, dSlaveRatioRead);
    if not bGetOK then begin
      sDebug := sMsg+Format(': GetYAxisSyncStatus(MasterAxis=%d): Failed',[nMasterAxis]);
      CodeSite.Send(sDebug);
      Sleep(10);
      bGetOK := GetYAxisSyncStatus(nMasterAxis, nSyncStatus, nSlaveAxisRead, dSlaveRatioRead); //Retry
    end;
    // Compare Motion Device Sync Status if GetOK
    if bGetOK then begin
      if (nSyncStatus <> SyncNone) then begin
        sDebug := sMsg+Format(': GetYAxisSyncStatus(MasterAxis=%d): Error(nSyncStatus=%d <> SyncNone)',[nMasterAxis,Ord(nSyncStatus)]);
        CodeSite.Send(sDebug);
      end
      else begin
        nRet := DefPocb.ERR_OK; //OK
      end;
    end
    else begin
      sDebug := sMsg+Format(': GetYAxisSyncStatus(MasterAxis=%d): Failed(retry)',[nMasterAxis]);
      CodeSite.Send(sDebug);
    end;
  end;

  //------------------------- Update MotionSync Status if OK
  if (nRet = DefPocb.ERR_OK) then begin
    sDebug := sMsg+Format(': OK (Master=%d,Slave=%d,SlaveRatio=%f)',[nMasterAxis,nSlaveAxisRead,dSlaveRatioRead]);
    CodeSite.Send(sDebug);
    Motion[nMasterAxis].SendMotionEvent(nMode,nRet,sMsg+' OK');
    Result := True;
  end
  else begin
    Motion[nMasterAxis].SendMotionEvent(nMode,nRet,sMsg+' NG');
    Result := False;
  end;
end;

//------------------------------------------------------------------------------
//
function TMotionCtl.GetYAxisSyncStatus(nMyAxisNo: LongInt; var nSyncStatus: enumMotionSyncStatus; var nOppAxisNo: LongInt; var dSlaveRatio: Double): Boolean;
var
  nMode : integer;
  nRet  : Integer;
  sMsg  : string;
  //
  nMasterAxis, nSlaveAxisTarget, nSlaveAxisRead : LongInt;
  sDebug : string;
begin
  nMasterAxis      := DefMotion.MOTIONID_AxMC_STAGE1_Y;
  nSlaveAxisTarget := DefMotion.MOTIONID_AxMC_STAGE2_Y;
  nSlaveAxisRead   := MOTION_SYNCMODE_SLAVE_UNKNOWN;
  dSlaveRatio      := MOTION_SYNCMODE_SLAVE_RATIO;
  sMsg := '<MOTION> GetYAxisSyncStatus';
  //
  if (not Motion[nMasterAxis].m_bConnected) then begin
    sDebug := sMsg+Format(': Failed(MasterAxis=%d is not connected)',[nMasterAxis]);
    CodeSite.Send(sDebug);
    Exit(False);
  end;
  if (not Motion[nSlaveAxisTarget].m_bConnected) then begin
    sDebug := sMsg+Format(': Failed(nSlaveAxisTarget=%d is not connected)',[nMasterAxis]);
    CodeSite.Send(sDebug);
    Exit(False);
  end;

  // Get Motion Device Status & Decide SyncStatus
  nRet := Motion[nMasterAxis].MotionAxm.GetEGearLinkMode(nMasterAxis,nSlaveAxisRead,dSlaveRatio);
  if nRet = DefPocb.ERR_OK then begin
    if (nSlaveAxisRead = MOTION_SYNCMODE_SLAVE_UNKNOWN) then begin
      nSyncStatus := DefMotion.SyncNone;
    end
    else if (nSlaveAxisRead = nSlaveAxisTarget) then begin
      if nMyAxisNo = nMasterAxis then begin
        nSyncStatus := DefMotion.SyncLinkMaster;
        nOppAxisNo  := nSlaveAxisRead;
      end
      else begin
        nSyncStatus := DefMotion.SyncLinkSlave;
        nOppAxisNo  := nMasterAxis;
      end;
    end
    else begin
    //nSyncStatus := DefMotion.SyncUnknown;  //TBD:A2CHv3:MOTION:SYNC-MOVE? (Abnormal Case)
      Exit(False);
    end;
  end
  else begin
  //nSyncStatus := DefMotion.SyncUnknown;  //TBD:A2CHv3:MOTION:SYNC-MOVE? (Abnormal Case)
    Exit(False);
  end;
  Result := True;
end;
{$ENDIF} //SUPPORT_1CG2PANEL

function TMotionCtl.CheckMotionMovable(nCh: Integer; nAxis: Integer; var sReasonMsg: string): Boolean;  //TBD:A2CHv3:MOTION (Interlock)
var
  nMotionID : integer;
begin
  Result := False;
  if (not DongaMotion.GetChAxis2MotionID(nCh,nAxis,nMotionID)) then begin
    sReasonMsg := 'Invalid Ch/Axis';
    Exit;
  end;
  Result := CheckMotionMovable(nMotionID, sReasonMsg);
end;

function TMotionCtl.CheckMotionMovable(nMotionID: Integer; var sReasonMsg: string): Boolean;  //A2CHv3:MOTION(Interlock)
{$IFDEF SUPPORT_1CG2PANEL}
var
  bOppSyncMotionID : integer;
{$ENDIF}
begin
  Result     := False;
  sReasonMsg := '';
  //
  with Motion[nMotionID] do begin
    if m_MotionStatus.bMechSignalAlarmOn        then begin sReasonMsg := 'Servo Alarm'; Exit; end;
    if not m_bServoOn                           then begin sReasonMsg := 'Servo Off'; Exit; end;
    {$IFNDEF SIMULATOR_MOTION}
    if not m_MotionStatus.bUnivOutSignalServoOn then begin sReasonMsg := 'ServoOn Out Signal Off'; Exit; end;
    if not m_MotionStatus.bUnivInSignalServoOn  then begin sReasonMsg := 'ServoOn In Signal Off'; Exit; end;
    {$ENDIF}
    //
    {$IFDEF SUPPORT_1CG2PANEL}
    case nMotionID of
      DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
        case m_MotionStatus.nSyncStatus of
          DefMotion.SyncLinkMaster: begin
            bOppSyncMotionID := DefMotion.MOTIONID_AxMC_STAGE2_Y;
            if Motion[bOppSyncMotionID].m_MotionStatus.bMechSignalAlarmOn        then begin sReasonMsg := 'SlaveLink Servo Alarm'; Exit; end;
            if not Motion[bOppSyncMotionID].m_bServoOn                           then begin sReasonMsg := 'SlaveLink Servo Off'; Exit; end;
            {$IFNDEF SIMULATOR_MOTION}
            if not Motion[bOppSyncMotionID].m_MotionStatus.bUnivOutSignalServoOn then begin sReasonMsg := 'SlaveLink ServoOn Out Signal Off'; Exit; end;
            if not Motion[bOppSyncMotionID].m_MotionStatus.bUnivInSignalServoOn  then begin sReasonMsg := 'SlaveLink ServoOn In Signal Off'; Exit; end;
            {$ENDIF}
          end;
          else begin
            if {(not FMaintMotionUse) and} m_bDioAssyJigOn then begin sReasonMsg := 'AssyJig SyncMove Disabled'; Exit; end; //TBD:A2CHv3:MOTION (Interlock)
          end;
          //TBD:A2CHv3:MOTION (Interlock)
        end;
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
        case m_MotionStatus.nSyncStatus of
          DefMotion.SyncLinkSlave: begin
            sReasonMsg := 'SlaveLink on SyncMove';
            Exit;
          end;
          else begin
            if {(not FMaintMotionUse) and} m_bDioAssyJigOn then begin sReasonMsg := 'AssyJig SyncMove Disabled'; Exit; end; //TBD:A2CHv3:MOTION (Interlock)
          end;
        end;
        //TBD:A2CHv3:MOTION (Interlock)
      end;
      else begin
        //TBD:A2CHv3:MOTION (Interlock)
      end;
    end;
    {$ENDIF} //SUPPORT_1CG2PANEL
  end;
  //
  Result := True;
end;

//##############################################################################
//
{ TMotion }
//
//##############################################################################

//******************************************************************************
// procedure/function: TMotion: Create/Destroy
//			- constructor TMotion.Create(hMain: THandle; nMotionID: Integer);
//			- destructor TMotion.Destroy;
//******************************************************************************

//------------------------------------------------------------------------------
constructor TMotion.Create(hMain: THandle; nMotionID: Integer);
begin
  m_hMain 		:= hMain;
	m_nMotionID	:= nMotionID;
  //Common.MLog(DefPocb.SYS_LOG,'<MOTION> '+Common.GetStrMotionID2ChAxis(m_nMotionID)+': Create',DefPocb.DEBUG_LEVEL_INFO);
	//-------------------------- Motor Variables
{$IFDEF USE_MOTION_AXT}
	m_nMotionDev	:= DefMotion.MOTION_DEV_AxtMC;  //A2CH
{$ENDIF}
{$IFDEF USE_MOTION_AXM}
	m_nMotionDev	:= DefMotion.MOTION_DEV_AxmMC;  //F2CH|A2CHv2
{$ENDIF}
	case nMotionID of
{$IFDEF HAS_MOTION_CAM_Z}
		DefMotion.MOTIONID_AxMC_STAGE1_Z: begin			// Stage-1, Z-Axis
			m_nCh 				:= DefPocb.CH_1;
      m_nJig        := DefPocb.JIG_A;
			m_nAxisType 	:= DefMotion.MOTION_AXIS_Z;
			m_nMotorNo 		:= DefMotion.AxMC_AXISNO_STAGE1_Z;
		end;
		DefMotion.MOTIONID_AxMC_STAGE2_Z: begin			// Stage-2, Z-Axis
			m_nCh 				:= DefPocb.CH_2;
      m_nJig        := DefPocb.JIG_B;
			m_nAxisType 	:= DefMotion.MOTION_AXIS_Z;
			m_nMotorNo 		:= DefMotion.AxMC_AXISNO_STAGE2_Z;
		end;
{$ENDIF}
      DefMotion.MOTIONID_AxMC_STAGE1_Y: begin			// Stage-1, Y-Axis
			m_nCh 				:= DefPocb.CH_1;
      m_nJig        := DefPocb.JIG_A;
			m_nAxisType 	:= DefMotion.MOTION_AXIS_Y;
			m_nMotorNo 		:= DefMotion.AxMC_AXISNO_STAGE1_Y;
		end;
		DefMotion.MOTIONID_AxMC_STAGE2_Y: begin			// Stage-2, Y-Axis
			m_nCh 				:= DefPocb.CH_2;
      m_nJig        := DefPocb.JIG_B;
			m_nAxisType 	:= DefMotion.MOTION_AXIS_Y;
			m_nMotorNo 		:= DefMotion.AxMC_AXISNO_STAGE2_Y;
		end;
{$IFDEF HAS_MOTION_TILTING}
		DefMotion.MOTIONID_AxMC_STAGE1_T: begin			// Stage-1, Tilting-Axis
			m_nCh 				:= DefPocb.CH_1;
      m_nJig        := DefPocb.JIG_A;
			m_nAxisType 	:= DefMotion.MOTION_AXIS_T;
			m_nMotorNo 		:= DefMotion.AxMC_AXISNO_STAGE1_T;
    end;
		DefMotion.MOTIONID_AxMC_STAGE2_T: begin			// Stage-2, Tilting-Axis
			m_nCh 				:= DefPocb.CH_2;
      m_nJig        := DefPocb.JIG_B;
			m_nAxisType 	:= DefMotion.MOTION_AXIS_T;
			m_nMotorNo 		:= DefMotion.AxMC_AXISNO_STAGE2_T;
		end;
{$ENDIF}
	end;
	m_nAxisNo   	:= m_nMotorNo;  // for AxtMC
	m_nBdNo   		:= m_nMotorNo;  // for EziML
  //--------------------------
  m_bConnected    	:= False;
  m_bServoOn    		:= False;
  m_sErrLibApi      := '';
  m_bInitDone       := False;
  m_bHomeDone       := False;
  m_bModelPos       := False; //2018-12-03
  m_bServoRecover   := False;
  m_bSyncMove       := False; //TBD:A2CHv3:MOTION:SYNC-MOVE? NOT-USED?
  m_bDioYaxisLoadPos:= False; //TBD:A2CHv3:MOTION:SYNC-MOVE?
  m_bHomeSearching  := False;
	//-------------------------- Timer
  // Motion Status Check Timer
  tmrGetMotionStatus          := TTimer.Create(nil);
  tmrGetMotionStatus.OnTimer  := OnGetMotionStatusTimer;
  case m_nMotionDev	of
    DefMotion.MOTION_DEV_AxtMC: tmrGetMotionStatus.Interval := DefMotion.AxMC_TIMEVAL_STATUS_CHECK;
    DefMotion.MOTION_DEV_AxmMC: tmrGetMotionStatus.Interval := DefMotion.AxMC_TIMEVAL_STATUS_CHECK;
  //DefMotion.MOTION_DEV_EziML: tmrGetMotionStatus.Interval := DefMotion.EziML_TIMEVAL_STATUS_CHECK;
    else tmrGetMotionStatus.Interval := 200;  // 200ms
  end;
  tmrGetMotionStatus.Enabled  := False;

  m_bUpdatePos := False;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] 
//		Called-by: 
//
destructor TMotion.Destroy;
begin
  //Common.MLog(DefPocb.SYS_LOG,'<MOTION> '+Common.GetStrMotionID2ChAxis(m_nMotionID)+': Destroy',DefPocb.DEBUG_LEVEL_INFO);
	//-------------------------- Timer
  // - Motion Status
  tmrGetMotionStatus.Enabled := False;
  tmrGetMotionStatus.Free;
  tmrGetMotionStatus := nil;

  //TBD? (어떤 제어가? 어떤 조건에서?)
  //
  if m_bConnected then begin
    Close;
    //
    m_bConnected := False;
  end;

  inherited;
end;

//******************************************************************************
// procedure/function: TMotion: CONNNECT/Close/MotorInit/MotorReset/ServoOnOff
//		- function TMotion.CONNNECT: Boolean;
//		- procedure TMotion.Close;
//		- function TMotion.MotorInit: Boolean;
//		- function TMotion.MotorReset: Boolean;
//		- function TMotion.ServoOnOff(bIsOn: Boolean) : Boolean;
//******************************************************************************

//------------------------------------------------------------------------------
//
function TMotion.Connect: Boolean;
var
	nMode : integer;
	nRet 	: Integer;
	sMsg  : string;
begin
	nMode := DefPocb.MSG_MODE_MOTION_CONNECT;
  nRet 	:= DefPocb.ERR_MOTION_CONNECT;
	sMsg 	:= '<MOTION> '+Common.GetStrMotionID2ChAxis(m_nMotionID)+': Connect';

	case m_nMotionDev of
{$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
      nRet := MotionAxm.Connect;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
      nRet := MotionAxt.Connect;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
		DefMotion.MOTION_DEV_EziML: begin
  		if MotionEzi = nil then Exit(False);
      //TBD:MOTION:EZI?
    end;
{$ENDIF}
  end;
  if (nRet = DefPocb.ERR_OK) then begin SendMotionEvent(nMode,nRet,sMsg+' OK'); Result := True;  end
	else                            begin SendMotionEvent(nMode,nRet,sMsg+' NG'); Result := False; end;
	//-------------------------- Timer Enable
  tmrGetMotionStatus.Enabled  := True;
  m_bConnected := True;
end;

//------------------------------------------------------------------------------
//
procedure TMotion.Close;
begin
  tmrGetMotionStatus.Enabled := False;
  m_bConnected := False;
	case m_nMotionDev of
{$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit;
    	//TBD:MOTION:AXT?(Close?)	MotionAxt.Close;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit;
    	//TBD:MOTION:AXT?(Close?)	MotionAxt.Close;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
		DefMotion.MOTION_DEV_EziML: begin
  		if MotionEzi = nil then Exit;
      //TBD:MOTION:EZI;
    end;
{$ENDIF}
	end;
end;

//------------------------------------------------------------------------------
//
function TMotion.MotionInit: Boolean;
var
	nMode : integer;
	nRet 	: Integer;
	sMsg 	: string;
begin
	nMode := DefPocb.MSG_MODE_MOTION_INIT;
  nRet 	:= DefPocb.ERR_MOTION_INIT;
	sMsg 	:= '<MOTION> '+Common.GetStrMotionID2ChAxis(m_nMotionID)+': MotionInit';
	case m_nMotionDev of
{$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
   		nRet := MotionAxm.MotionInit;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
   		nRet := MotionAxt.MotionInit;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
		DefMotion.MOTION_DEV_EziML: begin
  		if MotionEzi = nil then Exit(False);
   		//TBD:MOTION:EZI?
    end;
{$ENDIF}
  end;
  if (nRet = DefPocb.ERR_OK) then begin SendMotionEvent(nMode,nRet,sMsg+' OK'); m_bInitDone := True;  m_bServoOn := True;  Result := True;  end
	else                            begin SendMotionEvent(nMode,nRet,sMsg+' NG'); m_bInitDone := False; m_bServoOn := False; Result := False; end;
end;

//------------------------------------------------------------------------------
//
function TMotion.MotionReset: Boolean;
var
	nMode : integer;
	nRet 	: Integer;
	sMsg 	: string;
begin
	nMode := DefPocb.MSG_MODE_MOTION_RESET;	
  nRet 	:= DefPocb.ERR_MOTION_RESET;	
	sMsg 	:= '<MOTION> '+Common.GetStrMotionID2ChAxis(m_nMotionID)+': MotionReset';
	case m_nMotionDev of
{$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
    	nRet := MotionAxm.MotionReset;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
    	nRet := MotionAxt.MotionReset;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
		DefMotion.MOTION_DEV_EziML: begin
  		if MotionEzi = nil then Exit(False);
    	//TBD:MOTION:EZI?
    end;
{$ENDIF}
  end;
  if (nRet = DefPocb.ERR_OK) then begin SendMotionEvent(nMode,nRet,sMsg+' OK'); Result := True;  end
	else                            begin SendMotionEvent(nMode,nRet,sMsg+' NG'); Result := False; end;
end;

//------------------------------------------------------------------------------
//
function TMotion.ServoOnOff(bIsOn: Boolean) : Boolean;
var
	nMode : integer;
	nRet 	: Integer;
	sMsg 	: string;
begin
	if bIsOn then begin
		nMode := DefPocb.MSG_MODE_MOTION_SERVO_ON;
		nRet  := DefPocb.ERR_MOTION_SERVO_ON;
		sMsg 	:= '<MOTION> '+Common.GetStrMotionID2ChAxis(m_nMotionID)+': ServoON';
	end
	else begin 
		nMode := DefPocb.MSG_MODE_MOTION_SERVO_OFF;
		nRet  := DefPocb.ERR_MOTION_SERVO_OFF;
		sMsg 	:= '<MOTION> '+Common.GetStrMotionID2ChAxis(m_nMotionID)+': ServoOFF';
	end;
	case m_nMotionDev of
{$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
    	nRet := MotionAxm.ServoOnOff(bIsOn);
		end;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
    	nRet := MotionAxt.ServoOnOff(bIsOn);
		end;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
		DefMotion.MOTION_DEV_EziML: begin
  		if MotionEzi = nil then Exit(False);
    	//TBD:MOTION:EZI?
    end;
{$ENDIF}
  end;
  if (nRet = DefPocb.ERR_OK) then begin SendMotionEvent(nMode,nRet,sMsg+' OK'); Result := True;  end
	else                            begin SendMotionEvent(nMode,nRet,sMsg+' NG'); Result := False; end;
  //
  if (nRet = DefPocb.ERR_OK) then m_bServoOn := bIsOn;
end;

//******************************************************************************
// procedure/function: TMotion: Move
//		- function TMotion.MoveStop(bIsEMS: Boolean = False): Boolean;
//******************************************************************************

//------------------------------------------------------------------------------
//
function TMotion.MoveSTOP(bIsEMS: Boolean = False): Boolean;
var
	nMode : integer;
	nRet 	: Integer;
	sMsg 	: string;
	MotionParam : RMotionParam;
//dioTarget : DWORD;
begin
	nMode := DefPocb.MSG_MODE_MOTION_MOVE_STOP;
	nRet 	:= DefPocb.ERR_MOTION_MOVE_STOP;
	sMsg  := Common.GetStrMotionID2ChAxis(m_nMotionID)+': MoveSTOP';
	if bIsEMS then sMsg := sMsg + '(EMS)';
	//
  Common.GetMotionParam(m_nMotionID,MotionParam);
	case m_nMotionDev of
{$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
    	nRet := MotionAxm.MoveSTOP(MotionParam,bIsEMS);
		end;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
    	nRet := MotionAxt.MoveSTOP(MotionParam,bIsEMS);
		end;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
		DefMotion.MOTION_DEV_EziML: begin
  		if MotionEzi = nil then Exit(False);
      //TBD:MOTION:EZI?
		end;
{$ENDIF}
  end;
	if (nRet = DefPocb.ERR_OK) then begin SendMotionEvent(nMode,nRet,sMsg+' OK'); Result := True;  end
	else                            begin SendMotionEvent(nMode,nRet,sMsg+' NG'); Result := False; end
	{ //TBD:DioCtl에서 OUT_MOTOR_XXX 변경 !!!
	if (nRet = DefPocb.ERR_OK) then begin
		case m_nMotionID of
      DefMotion.MOTIONID_AxtMC_STAGE1_Y: begin
        dioTarget := DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD or DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD;
        DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue and (not dioTarget);
      end;
      DefMotion.MOTIONID_AxtMC_STAGE2_Y: begin
        dioTarget := DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD) or DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD;
        DongaMotion.m_nMotorDOValue := DongaMotion.m_nMotorDOValue and (not dioTarget);
      end;
    end; 
	end; }
end;

//******************************************************************************
// procedure/function: TMotion: Move ABS/INC/JOG
//		-	function TMotion.MoveABS(nMode: Integer; dAbsPos: Double; dVel: Double = 0; dAccel: Double = 0; dStartStop: Double = 0): Boolean;
//		-	function TMotion.MoveINC(dIncDecPos: Double; dVel: Double = 0; dAccel: Double = 0; dStartStop: Double = 0): Boolean;
//		-	function TMotion.MoveJOG(bIsPlus: Boolean; dJogVel: Double = 0; dJogAccel: Double = 0): Boolean;
//    - function TMotion.MoveLIMIT(bIsPlus: Boolean; dJogVel: Double = 0; dJogAccel: Double = 0): Boolean;
//    - function TMotion.MoveHOME: Boolean;
//******************************************************************************

//------------------------------------------------------------------------------
//
function TMotion.MoveABS(nMode: Integer; dAbsPos: Double; dVel: Double = 0; dAccel: Double = 0; dStartStop: Double = 0): Boolean;
var
	nRet 	: Integer;
	sMsg, sReasonMsg : string;
	MotionParam : RMotionParam;
  bSyncMaster : Boolean;
  sFwdBwd : string;
begin
	sMsg := Common.GetStrMotionID2ChAxis(m_nMotionID);
  sFwdBwd := '';
	case nMode of
		DefPocb.MSG_MODE_MOTION_MOVE_ABS     : begin sMsg := sMsg+': MoveABS';      nRet := DefPocb.ERR_MOTION_MOVE_ABS; end;
		DefPocb.MSG_MODE_MOTION_MOVE_FORWARD : begin sMsg := sMsg+': MoveFORWARD';  nRet := DefPocb.ERR_MOTION_MOVE_FORWARD;  sFwdBwd := 'FORWARD';  end;
		DefPocb.MSG_MODE_MOTION_MOVE_BACKWARD: begin sMsg := sMsg+': MoveBACKWARD'; nRet := DefPocb.ERR_MOTION_MOVE_BACKWARD; sFwdBwd := 'BACKWARD'; end;
    {$IFDEF HAS_MOTION_TILTING}
		DefPocb.MSG_MODE_MOTION_MOVE_TILTUP  : begin sMsg := sMsg+': MoveTILTUP';   nRet := DefPocb.ERR_MOTION_MOVE_TILTUP; end;
		DefPocb.MSG_MODE_MOTION_MOVE_TILTDOWN: begin sMsg := sMsg+': MoveTILTDOWN'; nRet := DefPocb.ERR_MOTION_MOVE_TILTDOWN; end;
    {$ENDIF}
		else Exit(False);
	end;
  //
  if (not m_bHomeDone) then begin
    SendMotionEvent(nMode,nRet,sMsg+' NG (Not HomeSearch)');
    Exit(False);
  end;
  if (not DongaMotion.CheckMotionMovable(m_nMotionID,sReasonMsg)) then begin
    SendMotionEvent(nMode,nRet,sMsg+' NG ('+sReasonMsg+')');
    Exit(False);
  end;
  //
  Common.GetMotionParam(m_nMotionID,MotionParam);
  if dVel <> 0 then       MotionParam.dVelocity       := dVel;        // from input parameter
  if dAccel <> 0 then     MotionParam.dAccel          := dAccel;      // from input parameter
  if dStartStop <> 0 then MotionParam.dStartStopSpeed := dStartStop;  // from input parameter
	case m_nMotionDev of
    {$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
      {$IFDEF SUPPORT_1CG2PANEL}
      if (m_MotionStatus.nSyncStatus = SyncLinkSlave) then begin  //TBD:A2CHv3:MOTION:SYNC?
        CodeSite.Send(sMsg+' ...Skip(SyncLinkSlave)');
        Exit(False);
      end;
      {$ENDIF}
      if sFwdBwd <> '' then SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,m_nCh,m_nAxisType,'<MOTION> Stage '+sFwdBwd+' start');
      ThreadTask(procedure begin
				SendMotionEvent(nMode,DefPocb.ERR_MOTION_MOVE_START,sMsg+' START ...Wait');
        bSyncMaster := False;
        {$IFDEF SUPPORT_1CG2PANEL}
        if m_MotionStatus.nSyncStatus = SyncLinkMaster then bSyncMaster := True;
        {$ENDIF}
        {$IFNDEF SIMULATOR_MOTION}
        nRet := MotionAxm.MoveABS(MotionParam,dAbsPos,bSyncMaster);
        {$ELSE}
        nRet := SimMotionMoveABS(MotionParam,dAbsPos);
        {$ENDIF}
        SendMotionEvent(nMode,nRet,sMsg+TernaryOp((nRet = DefPocb.ERR_OK),' OK',' NG'));
        if sFwdBwd <> '' then SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,m_nCh,m_nAxisType,'<MOTION> Stage '+sFwdBwd+TernaryOp((nRet = DefPocb.ERR_OK),' OK',' NG'));
      end);
		end;
    {$ENDIF}
    {$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
      if sFwdBwd <> '' then SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,m_nCh,m_nAxisType,'<MOTION> Stage '+sFwdBwd+' start');
      ThreadTask(procedure begin
				SendMotionEvent(nMode,DefPocb.ERR_MOTION_MOVE_START_OK,sMsg+' START ...Wait');
        {$IFNDEF SIMULATOR_MOTION}
        nRet := MotionAxt.MoveABS(MotionParam,dAbsPos);
        {$ELSE}
        nRet := SimMotionMoveABS(MotionParam,dAbsPos);
        {$ENDIF}
        SendMotionEvent(nMode,nRet,sMsg+TernaryOp((nRet = DefPocb.ERR_OK),' OK',' NG'));
        if sFwdBwd <> '' then SendTestGuiDisplay(DefPocb.MSG_MODE_WORKING,m_nCh,m_nAxisType,'<MOTION> Stage '+sFwdBwd+TernaryOp((nRet = DefPocb.ERR_OK),' OK',' NG'));
      end);
		end;
    {$ENDIF}
  end;
	Result := True;
end;

//------------------------------------------------------------------------------
//
function TMotion.MoveINC(dIncDecPos: Double; dVel: Double = 0; dAccel: Double = 0; dStartStop: Double = 0): Boolean;
var
	nMode : integer;
	nRet 	: Integer;
	sMsg, sReasonMsg : string;
	MotionParam : RMotionParam;
  bSyncMaster : Boolean;
begin
	nMode := DefPocb.MSG_MODE_MOTION_MOVE_INC;
	nRet 	:= DefPocb.ERR_MOTION_MOVE_INC;
	sMsg  := Common.GetStrMotionID2ChAxis(m_nMotionID);
  if dIncDecPos > 0 then sMsg := sMsg + ': MoveINC'
  else                   sMsg := sMsg + ': MoveDEC';
  //
  if (not m_bHomeDone) then begin
    SendMotionEvent(nMode,nRet,sMsg+' NG (Not HomeSearch)');
    Exit(False);
  end;
  if (not DongaMotion.CheckMotionMovable(m_nMotionID,sReasonMsg)) then begin
    SendMotionEvent(nMode,nRet,sMsg+': NG ('+sReasonMsg+')');
    Exit(False);
  end;
  //
  Common.GetMotionParam(m_nMotionID,MotionParam);
  if dVel <> 0 then       MotionParam.dVelocity       := dVel;        // from input parameter
  if dAccel <> 0 then     MotionParam.dAccel          := dAccel;      // from input parameter
  if dStartStop <> 0 then MotionParam.dStartStopSpeed := dStartStop;  // from input parameter
	case m_nMotionDev of
    {$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
      {$IFDEF SUPPORT_1CG2PANEL}
      if (m_MotionStatus.nSyncStatus = SyncLinkSlave) then begin  //TBD:A2CHv3:MOTION:SYNC?
        CodeSite.Send(sMsg+' ...Skip(SyncLinkSlave)');
        Exit(False);
      end;
      {$ENDIF}
      ThreadTask(procedure begin
				SendMotionEvent(nMode,DefPocb.ERR_MOTION_MOVE_START,sMsg+' START ...Wait');
        bSyncMaster := False;
        {$IFDEF SUPPORT_1CG2PANEL}
        if m_MotionStatus.nSyncStatus = SyncLinkMaster then bSyncMaster := True;
        {$ENDIF}
    		nRet := MotionAxm.MoveINC(MotionParam,dIncDecPos,bSyncMaster);
        if (nRet = DefPocb.ERR_OK) then SendMotionEvent(nMode,nRet,sMsg+' OK')
				else                            SendMotionEvent(nMode,nRet,sMsg+' NG');
      end);
		end;
    {$ENDIF}
    {$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
      ThreadTask(procedure begin
				SendMotionEvent(nMode,DefPocb.ERR_MOTION_MOVE_START_OK,sMsg+' START ...Wait');
    		nRet := MotionAxt.MoveINC(MotionParam,dIncDecPos);
        if (nRet = DefPocb.ERR_OK) then SendMotionEvent(nMode,nRet,sMsg+' OK')
				else                            SendMotionEvent(nMode,nRet,sMsg+' NG');
      end);
		end;
    {$ENDIF}
  end;
	Result := True;
end;

//------------------------------------------------------------------------------
//
function TMotion.MoveJOG(bIsPlus: Boolean; dJogVel: Double = 0; dJogAccel: Double = 0): Boolean;
var
	nMode : integer;
	nRet 	: Integer;
	sMsg, sReasonMsg : string;
	MotionParam : RMotionParam;
  bSyncMaster : Boolean;
begin
	nMode := DefPocb.MSG_MODE_MOTION_MOVE_JOG;
	nRet 	:= DefPocb.ERR_MOTION_MOVE_JOG;
	sMsg := Common.GetStrMotionID2ChAxis(m_nMotionID);
	if bIsPlus then sMsg := sMsg +': MoveJOG+'
	else	  				sMsg := sMsg +': MoveJOG-';
  //
  if (not DongaMotion.CheckMotionMovable(m_nMotionID,sReasonMsg)) then begin
    SendMotionEvent(nMode,nRet,sMsg+': NG ('+sReasonMsg+')');
    Exit(False);
  end;
  //
  Common.GetMotionParam(m_nMotionID,MotionParam);
  if dJogVel <> 0 then   MotionParam.dJogVelocity := dJogVel;    // from input parameter
  if dJogAccel <> 0 then MotionParam.dJogAccel    := dJogAccel;  // from input parameter
	case m_nMotionDev of
    {$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin
  		if MotionAxm = nil then Exit(False);
      {$IFDEF SUPPORT_1CG2PANEL}
      if (m_MotionStatus.nSyncStatus = SyncLinkSlave) then begin //TBD:A2CHv3:MOTION:SYNC?
        CodeSite.Send(sMsg+' ...Skip(SyncLinkSlave)');
        Exit(False);
      end;
      {$ENDIF}
      ThreadTask(procedure begin
				SendMotionEvent(nMode,DefPocb.ERR_MOTION_MOVE_START,sMsg+' START ...Wait');
        bSyncMaster := False;
        {$IFDEF SUPPORT_1CG2PANEL}
        if m_MotionStatus.nSyncStatus = SyncLinkMaster then bSyncMaster := True;
        {$ENDIF}
    		nRet := MotionAxm.MoveJOG(MotionParam,bIsPlus,bSyncMaster);
        if (nRet = DefPocb.ERR_OK) then SendMotionEvent(nMode,nRet,sMsg+' OK')
				else                            SendMotionEvent(nMode,nRet,sMsg+' NG');
      end);
		end;
    {$ENDIF}
    {$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
      ThreadTask(procedure begin
				SendMotionEvent(nMode,DefPocb.ERR_MOTION_MOVE_START_OK,sMsg+' START ...Wait');
    		nRet := MotionAxt.MoveJOG(MotionParam,bIsPlus);
        if (nRet = DefPocb.ERR_OK) then SendMotionEvent(nMode,nRet,sMsg+' OK')
				else                            SendMotionEvent(nMode,nRet,sMsg+' NG');
      end);
		end;
    {$ENDIF}
  end;
	Result := True;
end;

//------------------------------------------------------------------------------
//
function TMotion.MoveLIMIT(bIsPlus: Boolean; dJogVel: Double = 0; dJogAccel: Double = 0): Boolean;
var
	nMode : integer;
	nRet 	: Integer;
	sMsg, sReasonMsg : string;
	MotionParam : RMotionParam;
  bSyncMaster : Boolean;
begin
	nMode := DefPocb.MSG_MODE_MOTION_MOVE_TO_LIMIT;
	nRet 	:= DefPocb.ERR_MOTION_MOVE_TO_LIMIT;
	sMsg := Common.GetStrMotionID2ChAxis(m_nMotionID);
	if bIsPlus then sMsg := sMsg + ': MoveLIMIT+'
	else	  				sMsg := sMsg + ': MoveLIMIT-';
	//
  if (not m_bHomeDone) then begin
    SendMotionEvent(nMode,nRet,sMsg+' Warning (Not HomeSearch)');
    //TBD:MOTION? 2019-03-05 Exit(False);
  end;
  if (not DongaMotion.CheckMotionMovable(m_nMotionID,sReasonMsg)) then begin
    SendMotionEvent(nMode,nRet,sMsg+': NG ('+sReasonMsg+')');
    Exit(False);
  end;
  //
  Common.GetMotionParam(m_nMotionID,MotionParam);
  if dJogVel <> 0 then   MotionParam.dJogVelocity := dJogVel;    // from input parameter
  if dJogAccel <> 0 then MotionParam.dJogAccel    := dJogAccel;  // from input parameter
	case m_nMotionDev of
    {$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
      {$IFDEF SUPPORT_1CG2PANEL}
      if (m_MotionStatus.nSyncStatus = SyncLinkSlave) then begin  //TBD:A2CHv3:MOTION:SYNC?
        CodeSite.Send(sMsg+' ...Skip(SyncLinkSlave)');
        Exit(False);
      end;
      {$ENDIF}
      ThreadTask(procedure begin
				SendMotionEvent(nMode,DefPocb.ERR_MOTION_MOVE_START,sMsg+' START ...Wait');
        bSyncMaster := False;
        {$IFDEF SUPPORT_1CG2PANEL}
        if m_MotionStatus.nSyncStatus = SyncLinkMaster then bSyncMaster := True;
        {$ENDIF}
        nRet  := MotionAxm.MoveLIMIT(MotionParam,bIsPlus,bSyncMaster);
        if (nRet = DefPocb.ERR_OK) then SendMotionEvent(nMode,nRet,sMsg+' OK')
        else                            SendMotionEvent(nMode,nRet,sMsg+' NG');
        {$IFDEF HAS_MOTION_TILTING}
        //F2CH Tilting-Axis
        //TBD? if (m_nAxisType = MOTION_AXIS_T) and (nRet = DefPocb.ERR_OK) then begin
        //TBD?   if bIsPlus then begin
        //TBD?     DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE2_TILTUP;
        //TBD?     DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE2_TILTDOWN);
        //TBD?   end;
        //end;
        {$ENDIF}
      end);
		end;
    {$ENDIF}
    {$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
      ThreadTask(procedure begin
				SendMotionEvent(nMode,DefPocb.ERR_MOTION_MOVE_START_OK,sMsg+' START ...Wait');
        nRet  := MotionAxt.MoveLIMIT(MotionParam,bIsPlus);
        if (nRet = DefPocb.ERR_OK) then SendMotionEvent(nMode,nRet,sMsg+' OK')
				else                            SendMotionEvent(nMode,nRet,sMsg+' NG');
      end);
		end;
    {$ENDIF}
  end;
	Result := True;
end;

//------------------------------------------------------------------------------
//
function TMotion.MoveHOME: Boolean;
var
	nMode : integer;
	nRet 	: Integer;
	sMsg, sReasonMsg : string;
	MotionParam : RMotionParam;
begin
  nMode := DefPocb.MSG_MODE_MOTION_MOVE_TO_HOME;
	nRet 	:= DefPocb.ERR_MOTION_MOVE_TO_HOME;
	sMsg  := Common.GetStrMotionID2ChAxis(m_nMotionID)+': MoveHOME';
	//
  Common.GetMotionParam(m_nMotionID,MotionParam);
	//
	if (not DongaMotion.CheckMotionMovable(m_nMotionID,sReasonMsg)) then begin
    SendMotionEvent(nMode,nRet,sMsg+': NG ('+sReasonMsg+')');
    Exit(False);
  end;
	//
	case m_nMotionDev of
    {$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
      {$IFDEF SUPPORT_1CG2PANEL}
      if (DongaMotion.Motion[DefPocb.CH_1].m_MotionStatus.nSyncStatus = SyncLinkMaster) then begin
        DongaMotion.Motion[DefPocb.CH_2].m_MotionStatus.nSyncStatus := SyncLinkSlave;
      end;
      if (m_MotionStatus.nSyncStatus = SyncLinkSlave) then begin  //TBD:A2CHv3:MOTION:SYNC?
        CodeSite.Send(sMsg+' ...Skip(SyncLinkSlave)');
        Exit(False);
      end;
      {$ENDIF} //SUPPORT_1CG2PANEL

      m_bHomeSearching := True; //2022-08-12 (Set before ThreadTask)
      m_bHomeDone := False;
      m_bModelPos := False; 

      ThreadTask(procedure var dCmdPos: Double; bUseSoftLimitMinus: Boolean; begin
				m_bHomeSearching := True;  //2021-03-02			
        m_bHomeDone := False;
        m_bModelPos := False;  //F2CH
        bUseSoftLimitMinus := False;
        //
				SendMotionEvent(nMode,DefPocb.ERR_MOTION_MOVE_START,sMsg+' START ...Wait');
				SendMotionEvent(DefPocb.MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_MOTION_MODEL_POS,'');

        //A2CHv3:MOTION
        dCmdPos := 0.0;
        if m_bDioYaxisLoadPos then dCmdPos := (Common.TestModelInfo2[m_nCh].CamYLoadPos + 0.1)   //A2CHv3:MOTION
        else if (m_MotionStatus.UnivInSignal and (1 shl 0)) <> 0 then dCmdPos := 0.1 // Home
      //else if (m_MotionStatus.UnivInSignal and (1 shl 3)) <> 0 then dCmdPos := Common.TestModelInfo2[m_nCh].CamYLoadPos // WorkZone Signal
        else if (m_MotionStatus.MechSignal and (1 shl 0)) <> 0 then   dCmdPos := Common.MotionInfo.YaxisSoftLimitPlus     // +Limit Signal
        else if (m_MotionStatus.MechSignal and (1 shl 1)) <> 0 then   dCmdPos := Common.MotionInfo.YaxisSoftLimitMinus;   // -Limit Signal

        if dCmdPos <> 0.0 then begin
          bUseSoftLimitMinus := True;
          SetCmdPos(dCmdPos);
        end;

        {$IFDEF SUPPORT_1CG2PANEL}
        if Common.SystemInfo.UseAssyPOCB and (DongaMotion.m_bDioAssyJigOn or (m_MotionStatus.nSyncStatus = SyncLinkMaster)) then begin  //A2CHv3:MOTION:SYNC?
          if bUseSoftLimitMinus then DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].SetCmdPos(dCmdPos);  //2021-05-31
          nRet := MotionAxm.MoveHOMEGantry(MotionParam,bUseSoftLimitMinus);
        end
        else begin
        {$ENDIF}
					nRet := MotionAxm.MoveHOME(MotionParam,bUseSoftLimitMinus);  //2021-03-10
        {$IFDEF SUPPORT_1CG2PANEL}
        end;
        {$ENDIF}
        m_bHomeSearching := False; //2021-03-02
        //
        if (nRet = DefPocb.ERR_OK) then begin m_bHomeDone := True;  SendMotionEvent(nMode,nRet,sMsg+' OK'); end
        else                            begin m_bHomeDone := False; SendMotionEvent(nMode,nRet,sMsg+' NG'); end;
        //
        {$IFDEF SUPPORT_1CG2PANEL}
        if Common.SystemInfo.UseAssyPOCB and (DongaMotion.m_bDioAssyJigOn or (m_MotionStatus.nSyncStatus = SyncLinkMaster)) then begin  //TBD:A2CHv3:MOTION:SYNC?
          sMsg := Common.GetStrMotionID2ChAxis(DefMotion.MOTIONID_AxMC_STAGE2_Y)+': MoveHOME';
          if (nRet = DefPocb.ERR_OK) then begin
            DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bHomeDone := True;
            DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].SendMotionEvent(nMode,nRet,sMsg+' OK');
          end
          else begin
            DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].m_bHomeDone := False;
            DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].SendMotionEvent(nMode,nRet,sMsg+' NG');
          end;
        end;
        {$ENDIF} //SUPPORT_1CG2PANEL
      end);
		end;
    {$ENDIF}
    {$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
      ThreadTask(procedure begin
        m_bHomeDone := False;
        if m_nAxisType = MOTION_AXIS_Z then m_bModelPos := False;
				SendMotionEvent(nMode,DefPocb.ERR_MOTION_MOVE_START_OK,sMsg+' START ...Wait');
				SendMotionEvent(DefPocb.MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_MOTION_MODEL_POS,'');
        nRet := MotionAxt.MoveHOME(MotionParam,False{bDoPreCheck});
        if (nRet = DefPocb.ERR_OK) then begin m_bHomeDone := True;  SendMotionEvent(nMode,nRet,sMsg+' OK'); end
				else                            begin m_bHomeDone := False; SendMotionEvent(nMode,nRet,sMsg+' NG'); end;
      end);
		end;
    {$ENDIF}
  end;
  Result := True;
end;

//******************************************************************************
// procedure/function: TMotion: Move Y-Axis Forward/Backward
//		-	function TMotion.MoveFORWARD: Boolean;
//		-	function TMotion.MoveBACKWARD: Boolean;
//******************************************************************************

//------------------------------------------------------------------------------
//
function TMotion.MoveFORWARD: Boolean;
var
  bRet  	: Boolean;
  dAbsPos : Double;
begin
  //CodeSite.Send('MoveFORWARD');
  if m_nAxisType <> DefMotion.MOTION_AXIS_Y then Exit(False);

  //DioCtl에서 OUT_MOTOR_XXX 변경
  dAbsPos := Common.TestModelInfo2[m_nCh].CamYCamPos;
  bRet := MoveABS(DefPocb.MSG_MODE_MOTION_MOVE_FORWARD,dAbsPos);
	Result := bRet;
end;

//------------------------------------------------------------------------------
//
function TMotion.MoveBACKWARD: Boolean;
var
  bRet  	: Boolean;
  dAbsPos : Double;
begin
  //CodeSite.Send('MoveBACKWARD');
  if m_nAxisType <> DefMotion.MOTION_AXIS_Y then Exit(False);

  //DioCtl에서 OUT_MOTOR_XXX 변경
  dAbsPos := Common.TestModelInfo2[m_nCh].CamYLoadPos;
  bRet := MoveABS(DefPocb.MSG_MODE_MOTION_MOVE_BACKWARD,dAbsPos);
	Result := bRet;
end;

{$IFDEF HAS_MOTION_TILTING}
//------------------------------------------------------------------------------
//
function TMotion.MoveTILTUP: Boolean;
var
  bRet  	: Boolean;
  dAbsPos : Double;
begin
  CodeSite.Send('MoveTILTUP');
  if m_nAxisType <> DefMotion.MOTION_AXIS_T then Exit(False);
  //DioCtl에서 OUT_MOTOR_XXX 변경
  dAbsPos := 0.0;
  case m_nMotionID of
    DefMotion.MOTIONID_AxMC_STAGE1_T: dAbsPos := Common.TestModelInfo2[m_nCh].CamTUpPos;
    DefMotion.MOTIONID_AxMC_STAGE2_T: dAbsPos := Common.TestModelInfo2[m_nCh].CamTUpPos;
  end;
  bRet   := MoveABS(DefPocb.MSG_MODE_MOTION_MOVE_TILTUP,dAbsPos);
	Result := bRet;
end;

function TMotion.MoveTILTDOWN: Boolean;
var
  bRet  	: Boolean;
  dAbsPos : Double;
begin
  CodeSite.Send('MoveTILTDOWN');
  if m_nAxisType <> DefMotion.MOTION_AXIS_T then Exit(False);
  //DioCtl에서 OUT_MOTOR_XXX 변경
  dAbsPos := 0.0;
  case m_nMotionID of
    DefMotion.MOTIONID_AxMC_STAGE1_T: dAbsPos := Common.TestModelInfo2[m_nCh].CamTFlatPos[DefPocb.JIG_A];
    DefMotion.MOTIONID_AxMC_STAGE2_T: dAbsPos := Common.TestModelInfo2[m_nCh].CamTFlatPos[DefPocb.JIG_B];
  end;
  bRet   := MoveABS(DefPocb.MSG_MODE_MOTION_MOVE_TILTDOWN,dAbsPos);
	Result := bRet;
end;
{$ENDIF}

//******************************************************************************
// procedure/function: TMotion: Get
//		-	function TMotion.IsMotionMoving: Boolean;
//		-	function TMotion.GetActPos: Double;
//		-	function TMotion.GetCmdPos: Double;
//		-	function Motion.SetActPos(dActPos: Double): Integer;
//		-	function Motion.SetCmdPos(dCmdPos: Double): Integer;
//******************************************************************************

//------------------------------------------------------------------------------
//
function TMotion.IsMotionMoving: Boolean;
var
	bIsMoving	: Boolean;
begin
	bIsMoving := False;
	case m_nMotionDev of
{$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
      bIsMoving := MotionAxm.IsMotionMoving;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
      bIsMoving := MotionAxt.IsMotionMoving;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
		DefMotion.MOTION_DEV_EziML: begin
  		if MotionEzi = nil then Exit(False);
      //TBD:MOTION:EZI?
		end;
{$ENDIF}
  end;
	Result := bIsMoving;
end;

//------------------------------------------------------------------------------
//
function TMotion.GetActPos: Double;
var
  nRet  : Integer;
	dPos	: Double;
begin
	dPos := -1;
	nRet := DefPocb.ERR_MOTION_GET_ACT_POS;
	case m_nMotionDev of
{$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm <> nil then begin
    		nRet := MotionAxm.GetActPos(dPos);
  		end;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt <> nil then begin
    		nRet := MotionAxt.GetActPos(dPos);
  		end;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
		DefMotion.MOTION_DEV_EziML: begin
  		if MotionEzi <> nil then begin
    		//TBD:MOTION:EZI?
  		end;
		end;
{$ENDIF}
  end;
  if (nRet <> DefPocb.ERR_OK) then begin
  //CodeSite.Send('<MOTION> '+Common.GetStrMotionID2ChAxis(m_nMotionID)+': GetActPos Error !!!');
  end;
	Result := dPos;
end;

//------------------------------------------------------------------------------
//
function TMotion.GetCmdPos: Double;
var
  nRet  : Integer;
	dPos	: Double;
begin
	dPos := -1;
	nRet := DefPocb.ERR_MOTION_GET_CMD_POS;
	case m_nMotionDev of
{$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm <> nil then begin
    		nRet := MotionAxm.GetCmdPos(dPos);
  		end;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt <> nil then begin
    		nRet := MotionAxt.GetCmdPos(dPos);
  		end;
		end;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
		DefMotion.MOTION_DEV_EziML: begin
  		if MotionEzi <> nil then begin
    		//TBD:MOTION:EZI?
  		end;
		end;
{$ENDIF}
  end;
  if (nRet <> DefPocb.ERR_OK) then begin
  //CodeSite.Send('<MOTION> '+Common.GetStrMotionID2ChAxis(m_nMotionID)+': GetCmdPos Error !!!');
  end;
	Result := dPos;
end;

//------------------------------------------------------------------------------
//
function TMotion.SetActPos(dActPos: Double): Boolean;
var
	nRet 	: Integer;
begin
	nRet 	:= DefPocb.ERR_MOTION_SET_ACT_POS;
	case m_nMotionDev of
{$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
    	nRet := MotionAxm.SetActPos(dActPos);
		end;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
    	nRet := MotionAxt.SetActPos(dActPos);
		end;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
		DefMotion.MOTION_DEV_EziML: begin
  		if MotionEzi = nil then Exit(False);
    	//TBD:MOTION:EZI?
		end;
{$ENDIF}
  end;
	if (nRet = DefPocb.ERR_OK) then Result := True
	else												 		Result := False;
end;

//------------------------------------------------------------------------------
//
function TMotion.SetCmdPos(dCmdPos: Double): Boolean;
var
	nRet 	: Integer;
begin
	nRet 	:= DefPocb.ERR_MOTION_SET_CMD_POS;
	case m_nMotionDev of
{$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin  //F2CH
  		if MotionAxm = nil then Exit(False);
    	nRet := MotionAxm.SetCmdPos(dCmdPos);
		end;
{$ENDIF}
{$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt = nil then Exit(False);
    	nRet := MotionAxt.SetCmdPos(dCmdPos);
		end;
{$ENDIF}
{$IFDEF USE_MOTION_EZIML}
		DefMotion.MOTION_DEV_EziML: begin
  		if MotionEzi = nil then Exit(False);
   		//TBD:MOTION:EZI?
		end;
{$ENDIF}
  end;
	if (nRet <> DefPocb.ERR_OK) then Exit(False);
  //
  case m_nMotionID of
    DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
    	if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamYLoadPos) then begin  // at Home : IN_BACKWARD On
      	DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE1_BACKWARD;
      	DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD);
      //CodeSite.Send('<MOTION> CH1,Y-Axis: BACKWARD');
    	end
    	else if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamYCamPos) then begin  // at ModelPos : IN_FORWARD On
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD;
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE1_BACKWARD);
      //CodeSite.Send('<MOTION> CH1,Y-Axis: FORWARD');
      end;
    end;
    DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
      if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamYLoadPos) then begin  // at Home : IN_BACKWARD On
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE2_BACKWARD;
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE2_FORWARD);
      //CodeSite.Send('<MOTION> CH2,Y-Axis: BACKWARD');
      end
      else if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamYCamPos) then begin  // at ModelPos : IN_FORWARD On
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE2_FORWARD;
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE2_BACKWARD);
      //CodeSite.Send('<MOTION> CH2,Y-Axis: FORWARD');
      end;
    end;
{$IFDEF HAS_MOTION_TILTING}
    DefMotion.MOTIONID_AxMC_STAGE1_T: begin
    	if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamTUpPos]) then begin
      	DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE1_TILTUP;
      	DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE1_TILTDOWN);
        CodeSite.Send('<MOTION> CH1,T-Axis: Titling-Up');
    	end
    	else if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamTFlatPos) then begin  // at ModelPos : Tilting Down
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE1_TILTDOWN;
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE1_TILTUP);
        CodeSite.Send('<MOTION> CH1,T-Axis: Titling-Down');
      end;
    end;
    DefMotion.MOTIONID_AxMC_STAGE2_T: begin
      if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamTUpPos) then begin
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE2_TILTUP;
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE2_TILTDOWN);
        CodeSite.Send('<MOTION> CH2,T-Axis: Titling-Up');
      end
      else if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamTFlatPos) then begin  // at ModelPos : Tilting Down
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE2_TILTDOWN;
        DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE2_TILTUP);
        CodeSite.Send('<MOTION> CH2,T-Axis: Titling-Down');
      end;
    end;
{$ENDIF}
  end;
  Result := True;
end;

//******************************************************************************
// procedure/function: TMotion: Timer
//******************************************************************************

procedure TMotion.OnGetMotionStatusTimer(Sender: TObject);
var
  bRet     : Boolean;
  bChanged : Boolean;
  {$IFDEF SUPPORT_1CG2PANEL}
  bSyncChanged : Boolean;
  {$ENDIF}
  MotionStatusTemp : MotionStatusRec;
  dioTarget : DWORD;
  maskUnivInSignal : Byte;
begin
  {$IFDEF SIMULATOR_DIO}
  if DongaDio = nil then Exit; //2023-09-20
  {$ENDIF}

  if DongaMotion.m_hTest[m_nJig] = 0 then begin
    Exit;
  end;

	if (not m_bConnected) then begin
    Exit;
  end;
	//
  bRet := False;
  bChanged := False;
  {$IFDEF SUPPORT_1CG2PANEL}
  bSyncChanged := False;
  {$ENDIF}
  tmrGetMotionStatus.Enabled := False;
	//-------------------------- Get Motion Status
	case m_nMotionDev of
    {$IFDEF USE_MOTION_AXM}
		DefMotion.MOTION_DEV_AxmMC: begin
  		if MotionAxm <> nil then begin
        {$IFNDEF SIMULATOR_MOTION}
   		  bRet := MotionAxm.GetMotionStatus(MotionStatusTemp);
        {$ELSE}
        bRet := SimMotionGetMotionStatus(MotionStatusTemp);
        {$ENDIF}
  		end;
		end;
    {$ENDIF}
    {$IFDEF USE_MOTION_AXT}
		DefMotion.MOTION_DEV_AxtMC: begin  //A2CH
  		if MotionAxt <> nil then begin
        {$IFNDEF SIMULATOR_MOTION}
        bRet := MotionAxt.GetMotionStatus(MotionStatusTemp);
        {$ELSE}
     		bRet := SimMotionGetMotionStatus(MotionStatusTemp);
        {$ENDIF}
  		end;
		end;
    {$ENDIF}
  end;
  if (not bRet) then begin
    tmrGetMotionStatus.Enabled := True;
    Exit;
  end;

  m_MotionStatusOld := m_MotionStatus;
  m_MotionStatus    := MotionStatusTemp;
  //
	//-------------------------- Check Motion Status Change
//if m_nMotionDev = DefMotion.MOTION_DEV_AxtMC then begin
    //----- 구동 설정 초기화
    // Unit/Pulse 설정
    if (m_MotionStatus.UnitPerPulse <> m_MotionStatusOld.UnitPerPulse) then begin
      bChanged := True;
    end;

    // 시작 속도 설정 (Unit/Sec)
//2019-03-23:NOT-USED  if (m_MotionStatus.StartStopSpeed <> m_MotionStatusOld.StartStopSpeed) then begin
//2019-03-23:NOT-USED  end;

    // 최고 속도 설정 (Unit/Sec, 제어 system의 최고 속도)
//2019-03-23:NOT-USED  if (m_MotionStatus.MaxSpeed <> m_MotionStatusOld.MaxSpeed) then begin
//2019-03-23:NOT-USED  end;

    //----- 구동 상태 확인
    // 지정 축의 펄스 출력이 종료됐는지
    if (m_MotionStatus.IsMotionDone <> m_MotionStatusOld.IsMotionDone) then begin
      bChanged := True;
    end;

    // 지정 축의 EndStatus 레지스터를 확인
    //TBD? if (m_MotionStatus.EndStatus <> m_MotionStatusOld.EndStatus) then begin
    //TBD? end;

    // 지정 축의 Mechanical 레지스터
    //  - Mechanical Signal Bit별 의미
    //      12bit : ESTOP 신호 입력 Level
    //      11bit : SSTOP 신호 입력 Level
    //      10bit : MARK 신호 입력 Level
    //      9 bit : EXPP(MPG) 신호 입력 Level
    //      8 bit : EXMP(MPG) 신호 입력 Level
    //      7 bit : Encoder Up신호 입력 Level(A상 신호)
    //      6 bit : Encoder Down신호 입력 Level(B상 신호)
    //      5 bit : INPOSITION 신호 Active 상태
    //      4 bit : ALARM 신호 Active 상태
    //      3 bit : -Limit 감속정지 신호 Active 상태 (Ver3.0부터 사용되지않음)
    //      2 bit : +Limit 감속정지 신호 Active 상태 (Ver3.0부터 사용되지않음)
    //      1 bit : -Limit 급정지 신호 Active 상태
    //      0 bit : +Limit 급정지 신호 Active 상
    if ((m_MotionStatus.MechSignal and $0033) <> (m_MotionStatusOld.MechSignal and $0033)) then begin
      bChanged := True;
    end;

    //----- 위치 확인
    // 외부 위치 값 (position: Unit)
    //if (m_MotionStatus.ActualPos <> m_MotionStatusOld.ActualPos) then begin
      //2018-12-05 bChanged := True; //TBD?
    //end;

    // 2018-11-30 (Servo Alarm Clear시, ActPos를 이용하여 CmdPos 위치 보정 (사유: EMS Stop시, CmdPos와 ActPos Gap 발생)
    // 2018-12-03 (Motion 동작 중 Safety Servo Off로 인한 반복시, Act/Cmd Pos간 Mismatch 발생) ???
    //  - 아래 CmdPos 관련 처리 이전에 수행 !!
    if ((m_MotionStatus.MechSignal and $0010) <> (m_MotionStatusOld.MechSignal and $0010)) then begin
      if (m_MotionStatus.MechSignal and $0010) = 0 then begin  // Servo Alarm Cleared
        //
      end
      else begin  // Servo Alarm On
        case m_nMotionID of
          DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
            DongaMotion.m_nMotorDOValue  := DongaMotion.m_nMotorDOValue and (not (DefMotion.MASK_OUT_MOTOR_STAGE1_FORWARD or DefMotion.MASK_OUT_MOTOR_STAGE1_BACKWARD));
          end;
          DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
            DongaMotion.m_nMotorDOValue  := DongaMotion.m_nMotorDOValue and (not (DefMotion.MASK_OUT_MOTOR_STAGE2_FORWARD or DefMotion.MASK_OUT_MOTOR_STAGE2_BACKWARD));
          end;
          {$IFDEF HAS_MOTION_TILTING}
          DefMotion.MOTIONID_AxMC_STAGE1_T: begin
            DongaMotion.m_nMotorDOValue  := DongaMotion.m_nMotorDOValue and (not (DefMotion.MASK_OUT_MOTOR_STAGE1_TILTUP or DefMotion.MASK_OUT_MOTOR_STAGE1_TILTDOWN));
          end;
          DefMotion.MOTIONID_AxMC_STAGE2_T: begin
            DongaMotion.m_nMotorDOValue  := DongaMotion.m_nMotorDOValue and (not (DefMotion.MASK_OUT_MOTOR_STAGE2_TILTUP or DefMotion.MASK_OUT_MOTOR_STAGE2_TILTDOWN));
          end;
          {$ENDIF}
        end;
        m_bServoRecover := False;
      end;
    end;

    // 내부 위치 값 (position: Unit)
    if m_bUpdatePos or (m_MotionStatus.CommandPos <> m_MotionStatusOld.CommandPos) then begin
      bChanged  := True;
      m_bUpdatePos := False;
      case m_nMotionID of
        DefMotion.MOTIONID_AxMC_STAGE1_Y, DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
          if (Common.m_nCurPosYAxis[m_nJig] <> m_MotionStatus.CommandPos) then begin
            Common.m_nCurPosYAxis[m_nJig] := m_MotionStatus.CommandPos;
            {$IFDEF SIMULATOR_DIO}
            if m_nJig = DefPocb.JIG_A then begin DongaDio.m_nSimDioDIValue := DongaDio.m_nSimDioDIValue and (not (DefDio.MASK_IN_STAGE1_MUTING_LAMP or DefDio.MASK_IN_STAGE1_WORKING_ZONE)) end
            else                           begin DongaDio.m_nSimDioDIValue := DongaDio.m_nSimDioDIValue and (not (DefDio.MASK_IN_STAGE2_MUTING_LAMP or DefDio.MASK_IN_STAGE2_WORKING_ZONE)) end;
            {$ENDIF}						
            if (not m_MotionStatus.IsInMotion) and m_bHomeDone and m_MotionStatus.IsMotionDone then begin
              if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nJig].CamYLoadPos) then begin  // Loading Pos
                {$IFDEF SIMULATOR_DIO}
                if m_nJig = DefPocb.JIG_A then begin DongaDio.m_nSimDioDIValue := DongaDio.m_nSimDioDIValue or (DefDio.MASK_IN_STAGE1_MUTING_LAMP or DefDio.MASK_IN_STAGE1_WORKING_ZONE) end
                else                           begin DongaDio.m_nSimDioDIValue := DongaDio.m_nSimDioDIValue or (DefDio.MASK_IN_STAGE2_MUTING_LAMP or DefDio.MASK_IN_STAGE2_WORKING_ZONE) end;
                {$ENDIF}							
                if not m_bModelPos then begin  //2019-03-23
                  m_bModelPos := True;
                  SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
                //TBD:A2CHv3:MOTION? DongaMotion.MotionStatus(m_nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
                  CodeSite.Send('OnGetMotionStatusTimer:'+IntToStr(m_nMotionID)+': bModelPos True Y-LoadPos');
                end;
              end
              else if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nJig].CamYCamPos) then begin  //Camera Pos
                if not m_bModelPos then begin  //2019-03-23
                  m_bModelPos := True;
                  SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,''); //TBD:A2CHv3:MOTION?
                //TBD:A2CHv3:MOTION? DongaMotion.MotionStatus(m_nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
                  CodeSite.Send('OnGetMotionStatusTimer:'+IntToStr(m_nMotionID)+': bModelPos True Y-CamPos');
                end;
              end
              {$IFDEF SUPPORT_1CG2PANEL}
              else if Common.SystemInfo.UseAssyPOCB and (m_nMotionID = DefMotion.MOTIONID_AxMC_STAGE2_Y) and //2021-05-28
                      (DongaMotion.Motion[m_nMotionID].m_MotionStatus.nSyncStatus = DefMotion.SyncLinkSlave) and
                      (DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nJig].CamYCamPos)) then begin  // at ModelPos : IN_FORWARD On //2021-05-28
                if not m_bModelPos then begin  //2019-03-23
                  m_bModelPos := True;
                  SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
                //TBD:A2CHv3:MOTION? DongaMotion.MotionStatus(m_nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
                  CodeSite.Send('OnGetMotionStatusTimer:'+IntToStr(m_nMotionID)+': bModelPos True Y-CamPos');
                end;
              end
              {$ENDIF} //SUPPORT_1CG2PANEL
              {$IFDEF HAS_MOTION_TILTING}
              else if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, 0) then begin  // Home for Tilting Pos
                if not m_bModelPos then begin  //2019-03-23
                  m_bModelPos := True;
                  SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
                //TBD:A2CHv3:MOTION? DongaMotion.MotionStatus(m_nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
                  CodeSite.Send('OnGetMotionStatusTimer:'+IntToStr(m_nMotionID)+': bModelPos True Y-HomePos');
                end;
              end
              {$ENDIF} //HAS_MOTION_TILTING
              else begin
                m_bModelPos := False;
                SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_MOTION_MODEL_POS,'');
              //TBD:A2CHv3:MOTION? DongaMotion.MotionStatus(m_nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_MOTION_MODEL_POS,'');
                CodeSite.Send('OnGetMotionStatusTimer:'+IntToStr(m_nMotionID)+': bModelPos False Y-PosNG');
              end;
            end;
          end;
        end;
        {$IFDEF HAS_MOTION_CAM_Z}
        DefMotion.MOTIONID_AxMC_STAGE1_Z, DefMotion.MOTIONID_AxMC_STAGE2_Z: begin
          if (Common.m_nCurPosZAxis[m_nJig] <> m_MotionStatus.CommandPos) then begin
            Common.m_nCurPosZAxis[m_nJig] := m_MotionStatus.CommandPos;
            if (not m_MotionStatus.IsInMotion) and m_bHomeDone and m_MotionStatus.IsMotionDone then begin
              if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nJig].CamZModelPos) then begin
                m_bModelPos := True;
                SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,''); //TBD:A2CHv3:MOTION?
              //TBD:A2CHv3:MOTION? DongaMotion.MotionStatus(m_nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
                CodeSite.Send('OnGetMotionStatusTimer:'+IntToStr(m_nMotionID)+': bModelPos True Z-ModelPos');
              end
              else begin
                m_bModelPos := False;
                SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_MOTION_MODEL_POS,''); //TBD:A2CHv3:MOTION?
              //TBD:A2CHv3:MOTION? DongaMotion.MotionStatus(m_nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_MOTION_MODEL_POS,'');
                CodeSite.Send('OnGetMotionStatusTimer:'+IntToStr(m_nMotionID)+': bModelPos False Z-PosNG');
              end;
            end;
          end;
        end;
        {$ENDIF} //HAS_MOTION_CAM_Z
        {$IFDEF HAS_MOTION_TILTING}
        DefMotion.MOTIONID_AxMC_STAGE1_T, DefMotion.MOTIONID_AxMC_STAGE2_T: begin
          if (Common.m_nCurPosTAxis[m_nJig] <> m_MotionStatus.CommandPos) then begin
            Common.m_nCurPosTAxis[m_nJig] := m_MotionStatus.CommandPos;
            if (not m_MotionStatus.IsInMotion) and m_bHomeDone and m_MotionStatus.IsMotionDone then begin
              if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nJig].CamTFlatPos) then begin
                if not m_bModelPos then begin  //2019-03-23
                  m_bModelPos := True;
                  SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,''); //TBD:A2CHv3:MOTION?
                //TBD:A2CHv3:MOTION? DongaMotion.MotionStatus(m_nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
                  CodeSite.Send('OnGetMotionStatusTimer:'+IntToStr(m_nMotionID)+': bModelPos True T-Flat');
                end;
              end
              else if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nJig].CamTUpPos) then begin
                if not m_bModelPos then begin  //2019-03-22
                  m_bModelPos := True;  //TBD?
                  SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,''); //TBD:A2CHv3:MOTION?
                //TBD:A2CHv3:MOTION? DongaMotion.MotionStatus(m_nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_OK,'');
                  CodeSite.Send('OnGetMotionStatusTimer:'+IntToStr(m_nMotionID)+': bModelPos True T-Up');
                end;
              end
              else begin
                m_bModelPos := False;
                SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_MOTION_MODEL_POS,''); //TBD:A2CHv3:MOTION?
              //TBD:A2CHv3:MOTION? DongaMotion.MotionStatus(m_nMotionID,MSG_MODE_MOTION_MODEL_POS,DefPocb.ERR_MOTION_MODEL_POS,'');
                CodeSite.Send('OnGetMotionStatusTimer:'+IntToStr(m_nMotionID)+': bModelPos False T-PosNG');
              end;
            end;
          end;
        end;
        {$ENDIF} //HAS_MOTION_TILTING
      end;
    end;

    //----- 서보 드라이버
    // 서보 Enable(On) / Disable(Off)
    //if (m_MotionStatus.ServoEnable <> m_MotionStatusOld.ServoEnable) then begin
      //2018-12-05 bChanged := True; //TBD?
    //end;

    // 서보 위치결정완료(inposition)입력 신호의 사용유무
    //TBD? if (m_MotionStatus.UseInPosSig <> m_MotionStatusOld.UseInPosSig) then begin
    //TBD? end;

    // 서보 알람 입력신호 기능의 사용유무
    //TBD? if (m_MotionStatus.UseAlarmSig <> m_MotionStatusOld.UseAlarmSig) then begin
    //TBD? end;

    //----- 범용 입출력
    //  *** 0 bit : 범용 입력 0(ORiginal Sensor)  ==> TBD:MOTION? (Home Sensor 감지?)
    //      1 bit : 범용 입력 1(Z phase)
    //  *** 2 bit : 범용 입력 2   //Servo Power On 상태
    //  *** 3 bit : 범용 입력 3   //F2CH (Work Position = Stage Backward)
    //      4 bit(PLD) : 범용 입력 5
    //      5 bit(PLD) : 범용 입력 6
    //        On ==> 단자대 N24V, 'Off' ==> 단자대 Open(float).
    //  *** 0 bit : 범용 출력 0(Servo-On)      ==>
    //      1 bit : 범용 출력 1(ALARM Clear)
    //      2 bit : 범용 출력 2
    //      3 bit : 범용 출력 3
    //      4 bit(PLD) : 범용 출력 4
    //      5 bit(PLD) : 범용 출력 5
{$IF Defined(POCB_A2CH)}
    maskUnivInSignal := $05; //A2CH-Y/Z
{$ELSE} //A2CHv2|A2CHv3|A2CHv4|F2CH
    if (m_nMotionID = DefMotion.MOTIONID_AxMC_STAGE1_Y) or (m_nMotionID = DefMotion.MOTIONID_AxMC_STAGE2_Y) then
      maskUnivInSignal := $0D   //A2CHv2|A2CHv3|A2CHv4|F2CH|ITOLED-Y
    else
      maskUnivInSignal := $05;  //A2CHv2-Z|F2CH-Z/T|ITOLED-Z
{$ENDIF}
    if (m_MotionStatus.UnivInSignal and maskUnivInSignal) <> (m_MotionStatusOld.UnivInSignal and maskUnivInSignal) then begin  //TBD:F2CH:MOTION?
      bChanged := True;
    end;

    if (m_MotionStatus.UnivOutSignal and $01) <> (m_MotionStatusOld.UnivOutSignal and $01) then begin
      bChanged := True;
    end;

    // 지정 축의 펄스 출력중인지
    //TBD? if (m_MotionStatus.IsInMotion <> m_MotionStatusOld.IsInMotion) then begin
    if bChanged then begin
      if (m_MotionStatus.IsInMotion) then begin  // Motion 동작 중이면, Y축 IN_FORWARD/IN_BACKWARD Off
        case m_nMotionID of
          DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
            dioTarget := DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD or DefMotion.MASK_IN_MOTOR_STAGE1_BACKWARD;
            DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not dioTarget);
          end;
          DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
            dioTarget := DefMotion.MASK_IN_MOTOR_STAGE2_FORWARD or DefMotion.MASK_IN_MOTOR_STAGE2_BACKWARD;
            DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not dioTarget);
          end;
          {$IFDEF HAS_MOTION_TILTING}
          DefMotion.MOTIONID_AxMC_STAGE1_T: begin
            dioTarget := DefMotion.MASK_IN_MOTOR_STAGE1_TILTUP or DefMotion.MASK_IN_MOTOR_STAGE1_TILTDOWN;
            DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not dioTarget);
          end;
          DefMotion.MOTIONID_AxMC_STAGE2_T: begin
            dioTarget := DefMotion.MASK_IN_MOTOR_STAGE2_TILTUP or DefMotion.MASK_IN_MOTOR_STAGE2_TILTDOWN;
            DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not dioTarget);
          end;
          {$ENDIF}
        end;
      end
      else begin  // Motion 동작 중이 아니면, Y축 IN_FORWARD/IN_BACKWARD 신호 설정
        case m_nMotionID of
          DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
    		    //DioCtl에서 OUT_MOTOR_XXX 변경 !!!
            if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamYLoadPos) then begin  // at Home : IN_BACKWARD On
              {$IFDEF SIMULATOR_DIO}
              if m_nJig = DefPocb.JIG_A then begin DongaDio.m_nSimDioDIValue := DongaDio.m_nSimDioDIValue or (DefDio.MASK_IN_STAGE1_MUTING_LAMP or DefDio.MASK_IN_STAGE1_WORKING_ZONE) end
              else                           begin DongaDio.m_nSimDioDIValue := DongaDio.m_nSimDioDIValue or (DefDio.MASK_IN_STAGE2_MUTING_LAMP or DefDio.MASK_IN_STAGE2_WORKING_ZONE) end;
              {$ENDIF}							
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE1_BACKWARD;
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD);
              //CodeSite.Send('CH1,Y-Axis: BACKWARD');
            end
            else if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamYCamPos) then begin  // at ModelPos : IN_FORWARD On
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE1_FORWARD;
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE1_BACKWARD);
              //CodeSite.Send('CH1,Y-Axis: FORWARD');
            end;
          end;
          DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
		        //DioCtl에서 OUT_MOTOR_XXX 변경 !!!
            if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamYLoadPos) then begin  // at Home : IN_BACKWARD On
              {$IFDEF SIMULATOR_DIO}
              if m_nJig = DefPocb.JIG_A then begin DongaDio.m_nSimDioDIValue := DongaDio.m_nSimDioDIValue or (DefDio.MASK_IN_STAGE1_MUTING_LAMP or DefDio.MASK_IN_STAGE1_WORKING_ZONE) end
              else                           begin DongaDio.m_nSimDioDIValue := DongaDio.m_nSimDioDIValue or (DefDio.MASK_IN_STAGE2_MUTING_LAMP or DefDio.MASK_IN_STAGE2_WORKING_ZONE) end;
              {$ENDIF}												
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE2_BACKWARD;
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE2_FORWARD); //2019-04-23
              //CodeSite.Send('CH2,Y-Axis: BACKWARD');
            end
            else if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamYCamPos) then begin  // at ModelPos : IN_FORWARD On
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE2_FORWARD;
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE2_BACKWARD); //2019-04-23
              //CodeSite.Send('CH2,Y-Axis: FORWARD');
            {$IFDEF SUPPORT_1CG2PANEL}
            end
            else if Common.SystemInfo.UseAssyPOCB and (m_nMotionID = DefMotion.MOTIONID_AxMC_STAGE2_Y) and  //2021-05-28
                    (DongaMotion.Motion[m_nMotionID].m_MotionStatus.nSyncStatus = DefMotion.SyncLinkSlave) and
                    (DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamYCamPos)) then begin  // at ModelPos : IN_FORWARD On //2021-05-28
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE2_FORWARD;
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE2_BACKWARD); //2019-04-23
              //CodeSite.Send('CH2,Y-Axis: FORWARD');
            {$ENDIF} //SUPPORT_1CG2PANEL
            end;
          end;

          {$IFDEF HAS_MOTION_TILTING}
          DefMotion.MOTIONID_AxMC_STAGE1_T: begin  //TBD:MOTION:T-AXIS?
		    //DioCtl에서 OUT_MOTOR_XXX 변경 !!!
            if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamTUpPos) then begin  //2019-04-07
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE1_TILTUP; //2019-04-07
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE1_TILTDOWN); //2019-04-07
              CodeSite.Send('CH1,T-Axis: Up');
            end
            else if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamTFlatPos) then begin  //2019-04-07
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE1_TILTDOWN;
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE1_TILTUP);
              CodeSite.Send('CH1,T-Axis: Flat');
            end;
          end;
          DefMotion.MOTIONID_AxMC_STAGE2_T: begin  //TBD?
		    //DioCtl에서 OUT_MOTOR_XXX 변경 !!!
            if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamTUpPos) then begin  //2019-04-07
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE2_TILTUP; //2019-04-07
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE2_TILTDOWN); //2019-04-07
              CodeSite.Send('CH2,T-Axis: Up');
            end
            else if DongaMotion.IsSameMotionPos(m_MotionStatus.CommandPos, Common.TestModelInfo2[m_nCh].CamTFlatPos) then begin  //2019-04-07
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue or DefMotion.MASK_IN_MOTOR_STAGE2_TILTDOWN;
              DongaMotion.m_nMotorDIValue := DongaMotion.m_nMotorDIValue and (not DefMotion.MASK_IN_MOTOR_STAGE2_TILTUP);
              CodeSite.Send('CH2,T-Axis: Flat');
            end;
          end;
          {$ENDIF} //HAS_MOTION_TILTING
        end;
      end;
    end;

    //--------------------------------------------------------------------------
    {$IFDEF SUPPORT_1CG2PANEL}
    case m_nAxisNo of
      DefMotion.MOTIONID_AxMC_STAGE1_Y: begin
        if (m_MotionStatus.nSyncStatus <> m_MotionStatusOld.nSyncStatus)
           or (m_MotionStatus.nSyncOtherAxis <> m_MotionStatusOld.nSyncOtherAxis)
           or (m_MotionStatus.dSyncLinkSlaveRatio <> m_MotionStatusOld.dSyncLinkSlaveRatio)
         //or (m_MotionStatus.nSyncGantrySlHomeUse <> m_MotionStatusOld.nSyncGantrySlHomeUse)
         //or (m_MotionStatus.dSyncGantrySlOffset <> m_MotionStatusOld.dSyncGantrySlOffset)
         //or (m_MotionStatus.dSyncGantrySlOffsetRange <> m_MotionStatusOld.dSyncGantrySlOffsetRange)
        then begin
          bSyncChanged := True;
        end;
        if (m_MotionStatus.nSyncStatus <> m_MotionStatusOld.nSyncStatus) then begin
          if (m_MotionStatus.nSyncStatus = SyncNone) then begin
            DongaMotion.Motion[MOTIONID_AxMC_STAGE2_Y].m_MotionStatus.nSyncStatus := SyncNone;
            DongaMotion.Motion[MOTIONID_AxMC_STAGE2_Y].m_MotionStatus.nSyncOtherAxis := DefMotion.MOTION_SYNCMODE_SLAVE_UNKNOWN;
          end
          else if (m_MotionStatus.nSyncStatus = SyncLinkMaster) then begin
            DongaMotion.Motion[MOTIONID_AxMC_STAGE2_Y].m_MotionStatus.nSyncStatus := SyncLinkSlave;
            DongaMotion.Motion[MOTIONID_AxMC_STAGE2_Y].m_MotionStatus.nSyncOtherAxis := DefMotion.MOTIONID_AxMC_STAGE1_Y;
            DongaMotion.Motion[MOTIONID_AxMC_STAGE2_Y].m_MotionStatus.DSyncLinkSlaveRatio := m_MotionStatus.dSyncLinkSlaveRatio;
          end;
        end;
      end;
      DefMotion.MOTIONID_AxMC_STAGE2_Y: begin
        if (m_MotionStatus.nSyncStatus <> m_MotionStatusOld.nSyncStatus) then begin
          bSyncChanged := True;
        end;
      end;
    end;
    {$ENDIF} //SUPPORT_1CG2PANEL
//end;
 //
  {$IFDEF SUPPORT_1CG2PANEL}
  if (bChanged or bSyncChanged) then
  {$ELSE}
  if (bChanged) then
  {$ENDIF}
  begin
    SendTestGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,m_nCh,m_nAxisType,'');
    if DongaMotion.FMaintMotionUse and Assigned(DongaMotion.MaintMotionStatus) then begin  //2019-01-19
      if bChanged then
         DongaMotion.MaintMotionStatus(m_nMotionID,DefPocb.MSG_MODE_MOTION_GET_CMD_POS,0,Format('%0.2f',[m_MotionStatus.CommandPos]));
      {$IFDEF SUPPORT_1CG2PANEL}
      if bSyncChanged and (m_nMotionID = DefMotion.MOTIONID_AxMC_STAGE1_Y) then
         DongaMotion.MaintMotionStatus(m_nMotionID,DefPocb.MSG_MODE_MOTION_SYNCMODE_GET,0,'');
      {$ENDIF}
    end;
  end;
  //
  tmrGetMotionStatus.Enabled := True;
end;

//******************************************************************************
// procedure/function: Motion-to-FrmMain/FrmTest/Mainter
//
//******************************************************************************

procedure TMotion.SendMotionEvent(nMotionCtlMode: Integer; nErrCode: Integer; sMsg: string);
begin
	// for Motion-to-FrmMain
  //2019-04-16  DongaMotion.MotionStatus(m_nMotionID,nMode,nErrCode,sMsg);
  SendMainGuiDisplay(DefPocb.MSG_MODE_DISPLAY_STATUS,nMotionCtlMode,nErrCode,sMsg);
	// for Motion-to-FrmTest1Ch
	//TBD:MOTION:MOTION2TEST? (SendTestGuiDisplay?)

	// for Motion-to-Mainter
  if (DongaMotion.FMaintMotionUse and Assigned(DongaMotion.MaintMotionStatus)) then
		DongaMotion.MaintMotionStatus(m_nMotionID,nMotionCtlMode,nErrCode,sMsg);
end;

procedure TMotion.SendMainGuiDisplay(nGuiMode, nMotionCtlMode, nErrCode: Integer; sMsg: string);  //2019-004-07
var
  ccd : TCopyDataStruct;
  MainGuiMotionData : RMainGuiMotionData;
begin
  //Common.MLog(nCh,'<TMotion> SendMainGuiDisplay: Mode('+IntToStr(nGuiMode)+') Ch('+IntToStr(nCh+1)+') Param('+IntToStr(nParam)+')',DefPocb.DEBUG_LEVEL_INFO);
  MainGuiMotionData.MsgType := DefPocb.MSG_TYPE_MOTION;
  MainGuiMotionData.Channel := m_nCh;
  MainGuiMotionData.Mode    := nGuiMode;
  MainGuiMotionData.Param   := m_nMotionID;     // MotionID : DefMotion.MOTIONID_xxxxxx
  MainGuiMotionData.Param2  := nMotionCtlMode;  // MotionControlMode : DefPocb.MSG_MODE_MOTION_xxxxxx;
  MainGuiMotionData.Param3  := nErrCode;        // ErrCode : DefPocb.ERR_MOTION_xxxxxx
  MainGuiMotionData.Msg     := sMsg;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(MainGuiMotionData);
  ccd.lpData      := @MainGuiMotionData;
  SendMessage(DongaMotion.m_hMain,WM_COPYDATA,0,LongInt(@ccd));  //TBD:A2CH? (nCH->nJig)
end;

procedure TMotion.SendTestGuiDisplay(nGuiMode, nCh: Integer; nAxisType: Integer; sMsg: string);
var
  ccd : TCopyDataStruct;
  TestGuiMotionData : RTestGuiMotionData;
begin
  //Common.MLog(nCh,'<TMotion> SendTestGuiDisplay: Mode('+IntToStr(nGuiMode)+') Ch('+IntToStr(nCh+1)+') Param('+IntToStr(nParam)+')',DefPocb.DEBUG_LEVEL_INFO);
  TestGuiMotionData.MsgType := DefPocb.MSG_TYPE_MOTION;
  TestGuiMotionData.Channel := nCh;
  TestGuiMotionData.Mode    := nGuiMode;
  TestGuiMotionData.Param   := nAxisType;  // DefMotion.MOTION_AXIS_x
  TestGuiMotionData.Msg     := sMsg;
  ccd.dwData      := 0;
  ccd.cbData      := SizeOf(TestGuiMotionData);
  ccd.lpData      := @TestGuiMotionData;
  SendMessage(DongaMotion.m_hTest[nCh],WM_COPYDATA,0,LongInt(@ccd));  //TBD:A2CH? (nCH->nJig)
end;

procedure TMotion.ThreadTask(task: TProc);
var
  th2 : TThread;
begin
  th2 := TThread.CreateAnonymousThread(procedure begin
    task;
  end);
  th2.FreeOnTerminate := True;
  th2.Start;
end;

//##############################################################################
//
//##############################################################################

{$IFDEF SIMULATOR_MOTION}
function TMotion.SimMotionMoveABS(MotionParam: RMotionParam; dAbsPos: Double): Integer;
var
  dOldPos, dDiffPos : Double;
begin
  //CodeSite.Send('<MOTION> '+IntToStr(m_nMotionID)+':MoveABS ...start');
	m_sErrLibApi 	:= '';
  //-------------------------- Motor 제어 연결 상태 확인
  if (not m_bConnected) then begin
		Exit(DefPocb.ERR_MOTION_NOT_CONNECTED);
  end;
  //-------------------------- Motion Alarm 상태 확인  // Alarm Signal   if (MechSignal and (1 shl 4)) <> 0 then begin)
//TBD? if IsMotionAlarmOn then begin
//TBD?   Exit(DefPocb.ERR_MOTION_ALARM_ON);
//TBD? end;
  //------------------------------------------------
  dOldPos  := m_SimulatorMotionStatus.CommandPos;
  dDiffPos := dAbsPos - dOldPos;
  SimMotionSetIsInMotion(True);
  {$IFDEF SUPPORT_1CG2PANEL}
  if m_MotionStatus.nSyncStatus = DefMotion.SyncLinkMaster then DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].SimMotionSetIsInMotion(True);
  {$ENDIF}

  //
  Sleep(500);
  SimMotionSetCommandPos(dAbsPos-dDiffPos/3*2);
  {$IFDEF SUPPORT_1CG2PANEL}
  if m_MotionStatus.nSyncStatus = DefMotion.SyncLinkMaster then DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].SimMotionSetCommandPos(dAbsPos-dDiffPos/3*2);
  {$ENDIF}

  Sleep(500);
  SimMotionSetCommandPos(dAbsPos-dDiffPos/3*1);
  {$IFDEF SUPPORT_1CG2PANEL}
  if m_MotionStatus.nSyncStatus = DefMotion.SyncLinkMaster then DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].SimMotionSetCommandPos(dAbsPos-dDiffPos/3*1);
  {$ENDIF}

  Sleep(500);
  SimMotionSetCommandPos(dAbsPos);
  {$IFDEF SUPPORT_1CG2PANEL}
  if m_MotionStatus.nSyncStatus = DefMotion.SyncLinkMaster then DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].SimMotionSetCommandPos(dAbsPos);
  {$ENDIF}

  SimMotionSetIsInMotion(False);
  {$IFDEF SUPPORT_1CG2PANEL}
  if m_MotionStatus.nSyncStatus = DefMotion.SyncLinkMaster then DongaMotion.Motion[DefMotion.MOTIONID_AxMC_STAGE2_Y].SimMotionSetIsInMotion(False);
  {$ENDIF}
//
	Result := DefPocb.ERR_OK;
  //CodeSite.Send('<MOTION> '+IntToStr(m_nMotionID)+':MoveABS ...end');
end;

function TMotion.SimMotionGetMotionStatus(var MotionStatus: MotionStatusRec): Boolean;
var
  MotionParam : RMotionParam;
begin
  if (m_SimulatorMotionStatus.UnitPerPulse = 0.0) and (m_SimulatorMotionStatus.StartStopSpeed = 0.0) and (m_SimulatorMotionStatus.MaxSpeed = 0.0) then begin
    //초기화
    Common.GetMotionParam(m_nMotionID,MotionParam);
    m_SimulatorMotionStatus.UnitPerPulse := MotionParam.dUnitPerPulse;
    m_SimulatorMotionStatus.StartStopSpeed := MotionParam.dStartStopSpeed;
    m_SimulatorMotionStatus.MaxSpeed := MotionParam.dVelocityMax;
    m_SimulatorMotionStatus.IsInMotion := False;
    m_SimulatorMotionStatus.IsMotionDone := True;
    m_SimulatorMotionStatus.EndStatus  := $00;
    m_SimulatorMotionStatus.MechSignal := (1 shl 5);
    m_SimulatorMotionStatus.ActualPos  := 0.0;
    m_SimulatorMotionStatus.CommandPos := 0.0;
   {case m_nMotionID of
      DefMotion.MOTIONID_AxMC_STAGE1_Z: m_SimulatorMotionStatus.CommandPos := MotionParam.dConfigZModelPos;
      DefMotion.MOTIONID_AxMC_STAGE2_Z: m_SimulatorMotionStatus.CommandPos := MotionParam.dConfigZModelPos;
      DefMotion.MOTIONID_AxMC_STAGE1_Y: m_SimulatorMotionStatus.CommandPos := MotionParam.dConfigYLoadPos;
      DefMotion.MOTIONID_AxMC_STAGE2_Y: m_SimulatorMotionStatus.CommandPos := MotionParam.dConfigYLoadPos;
      DefMotion.MOTIONID_AxMC_STAGE1_T: m_SimulatorMotionStatus.CommandPos := MotionParam.dConfigTFlatPos;
      DefMotion.MOTIONID_AxMC_STAGE2_T: m_SimulatorMotionStatus.CommandPos := MotionParam.dConfigTFlatPos
    end;}
    m_SimulatorMotionStatus.ActCmdPosDiff := 0.0;
  //m_SimulatorMotionStatus.ServoEnable := 1;
  //m_SimulatorMotionStatus.UseInPosSig := 0;
  //m_SimulatorMotionStatus.UseAlarmSig := 0;
    m_SimulatorMotionStatus.UnivInSignal := {(1 shl 0) or} (1 shl 1) or (1 shl 2);
    m_SimulatorMotionStatus.UnivOutSignal := (1 shl 0);
  end;
  {$IFDEF SUPPORT_1CG2PANEL}
  m_SimulatorMotionStatus.nSyncStatus         := MotionAxm.m_nSimSyncStatus;
  m_SimulatorMotionStatus.nSyncOtherAxis      := MotionAxm.m_nSimSyncSlaveAxis;
  m_SimulatorMotionStatus.dSyncLinkSlaveRatio := MotionAxm.m_dSimSyncSlaveRatio;
  {$ENDIF}
  MotionStatus := m_SimulatorMotionStatus;
  Result := True;
end;

procedure TMotion.SimMotionSetUnitPerPulse(Value: Double);
begin
  m_SimulatorMotionStatus.UnitPerPulse := Value;
end;
procedure TMotion.SimMotionSetStartStopSpeed(Value: Double);
begin
  m_SimulatorMotionStatus.StartStopSpeed := Value;
end;
procedure TMotion.SimMotionSetMaxSpeed(Value: Double);
begin
  m_SimulatorMotionStatus.MaxSpeed := Value;  // 최고 속도 설정 (Unit/Sec, 제어 system의 최고 속도)
end;
procedure TMotion.SimMotionSetIsInMotion(Value: Boolean);
begin
  m_SimulatorMotionStatus.IsInMotion := Value;  // 지정 축의 펄스 출력중인지
end;
procedure TMotion.SimMotionSetIsMotionDone(Value: Boolean);
begin
  m_SimulatorMotionStatus.IsMotionDone := Value;  // 지정 축의 펄스 출력이 종료됐는지
end;
procedure TMotion.SimMotionSetEndStatus(Value: WORD);
begin
  m_SimulatorMotionStatus.EndStatus := Value;  // 지정 축의 EndStatus 레지스터를 확인
end;
procedure TMotion.SimMotionSetMechSignal(Value: WORD);
begin
  m_SimulatorMotionStatus.MechSignal := Value;  // 지정 축의 Mechanical 레지스터
end;
procedure TMotion.SimMotionSetActualPos(Value: Double);
begin
  m_SimulatorMotionStatus.ActualPos := Value;  // 외부 위치 값 (position: Unit)
end;
procedure TMotion.SimMotionSetCommandPos(Value: Double);
begin
  m_SimulatorMotionStatus.CommandPos := Value;  // 내부 위치 값 (position: Unit)

  if Value = Common.TestModelInfo2[m_nCh].CamYLoadPos then begin
    m_bDioYaxisLoadPos := True; // LoadPos
    m_MotionStatus.UnivInSignal := (m_MotionStatus.UnivInSignal and not(1 shl 0));
    m_MotionStatus.MechSignal   := (m_MotionStatus.MechSignal and not(1 shl 1));
    m_MotionStatus.MechSignal   := (m_MotionStatus.MechSignal and not(1 shl 0));
  end
  else if Value <= Common.MotionInfo.YaxisSoftLimitPlus then begin
    m_bDioYaxisLoadPos := False;
    m_MotionStatus.UnivInSignal := (m_MotionStatus.UnivInSignal and not(1 shl 0));
    m_MotionStatus.MechSignal   := (m_MotionStatus.MechSignal or (1 shl 1));  // -Limit
    m_MotionStatus.MechSignal   := (m_MotionStatus.MechSignal and not(1 shl 0));
  end
  else if Value >= Common.MotionInfo.YaxisSoftLimitPlus then begin
    m_bDioYaxisLoadPos := False;
    m_MotionStatus.UnivInSignal := (m_MotionStatus.UnivInSignal and not(1 shl 0));
    m_MotionStatus.MechSignal   := (m_MotionStatus.MechSignal and not(1 shl 1));
    m_MotionStatus.MechSignal   := (m_MotionStatus.MechSignal or (1 shl 0));   // +Limit
  end
//else if Value = 0.0 then begin
//  m_bDioYaxisLoadPos := False;
//  m_MotionStatus.UnivInSignal := (m_MotionStatus.UnivInSignal or (1 shl 0)); // Home
//  m_MotionStatus.MechSignal   := (m_MotionStatus.MechSignal and not(1 shl 1));
//  m_MotionStatus.MechSignal   := (m_MotionStatus.MechSignal and not(1 shl 0));
//end
  else begin
    m_bDioYaxisLoadPos := False;
    m_MotionStatus.UnivInSignal := (m_MotionStatus.UnivInSignal and not(1 shl 0));
    m_MotionStatus.MechSignal   := (m_MotionStatus.MechSignal and not(1 shl 1));
    m_MotionStatus.MechSignal   := (m_MotionStatus.MechSignal and not(1 shl 0));   // +Limit
  end;
end;
procedure TMotion.SimMotionSetActCmdPosDiff(Value: Double);
begin
  m_SimulatorMotionStatus.ActCmdPosDiff := Value;  // 지정 축의 Command position과 Actual position의 차
end;
procedure TMotion.SimMotionSetServoEnable(Value: BYTE);
begin
  m_SimulatorMotionStatus.ServoEnable := Value;  // 서보 Enable(On) / Disable(Off)
end;
procedure TMotion.SimMotionSetUseInPosSig(Value: BYTE);
begin
  m_SimulatorMotionStatus.UseInPosSig := Value;  // 서보 위치결정완료(inposition)입력 신호의 사용유무
end;
procedure TMotion.SimMotionSetUseAlarmSig(Value: BYTE);
begin
  m_SimulatorMotionStatus.UseAlarmSig := Value;  // 서보 알람 입력신호 기능의 사용유무
end;
procedure TMotion.SimMotionSetUnivInSignal(Value: BYTE);
begin
  m_SimulatorMotionStatus.UnivInSignal := Value;  //----- 범용 입출력
                              // AXT AxmMC Universal Input Signal   //
                              //      0 bit : Home Signal
                              //      1 bit : Encoder Z phase Signal
                              //      2~4 bit : Univesal Input Signal
                              // AXT AxtMC Universal Input Signal   // CFS20get_input (axis : SmallInt) : Byte
                              //      0 bit : 범용 입력 0(ORiginal Sensor)
                              //      1 bit : 범용 입력 1(Z phase)
                              //      2 bit : 범용 입력 2
                              //      3 bit : 범용 입력 3
                              //      4 bit(PLD) : 범용 입력 5
                              //      5 bit(PLD) : 범용 입력 6
                              //        On ==> 단자대 N24V, 'Off' ==> 단자대 Open(float).
end;
procedure TMotion.SimMotionSetUnivOutSignal(Value: BYTE);
begin
  m_SimulatorMotionStatus.UnivOutSignal := Value;  //----- 범용 입출력
                              //      0 bit : 범용 출력 0(Servo-On)
                              //      1 bit : 범용 출력 1(ALARM Clear)
                              //      2 bit : 범용 출력 2
                              //      3 bit : 범용 출력 3
                              //      4 bit(PLD) : 범용 출력 4
                              //      5 bit(PLD) : 범용 출력 5
end;
{$ENDIF}
end.
