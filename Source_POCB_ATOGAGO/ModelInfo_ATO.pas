unit ModelInfo_ATO;
{$I Common.inc}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, system.UITypes, System.Variants, System.Classes, System.Math, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
	RzGrids, RzCmboBx, RzButton, RzEdit, RzRadChk, RzLabel, RzPanel, RzLstBox,
	AdvOfficePager, AdvUtil, AdvObj, AdvGrid, BaseGrid, 
  DefPocb, DefCam, DefRobot, DefPG, DongaPattern,
  CommonClass, ExPat, LogicPocb, CamComm, UserUtils;

const
  GRID_PATLIST_COL_IDX   = 0;
  GRID_PATLIST_COL_TYPE  = 1;
  GRID_PATLIST_COL_PNAME = 2;
  GRID_PATLIST_COL_VSYNC = 3;
  GRID_PATLIST_COL_TIME  = 4;
  {$IFDEF FEATURE_DISPLAY_PWM}
  GRID_PATLIST_COL_PWM   = 5;	
	{$ENDIF}
	
type
  TfrmModelInfo = class(TForm)
    pnlModelInfoHeader            : TRzPanel;
    pnlModelNameInfo							: TPanel;
  	// Pages -------------------------------------------------------------------
    PagesModelInfos								: TAdvOfficePager;
    pgModelInfo										: TAdvOfficePage;
    pgPatternInfo									: TAdvOfficePage;
  	// Page (Model Information) ------------------------------------------------
    btnModelInfoSave							: TRzBitBtn;
    btnModelInfoClose							: TRzBitBtn;
		// - Model Selection
    RzGrpModelSelection						: TRzGroupBox; 	// Model Information > Model Selection
    RzGrpModelName								: TRzGroupBox;
    edModelName                   : TRzEdit;
    btnModelNew										: TRzBitBtn;		// Model Information > Model Selection > Model Create/Copy/Rename/Delete
    btnModelCopy									: TRzBitBtn;
    btnModelRename								: TRzBitBtn;
    btnModelDel										: TRzBitBtn;
    RzGrpModelList								: TRzGroupBox;
    lstbxModelList                : TRzListBox;
		// - Model Parameters
    RzGrpFwVer                    : TRzGroupBox;  // Model Information > Model Parameters > Display Mode
    RzpnlPgFwVer                  : TRzPanel;
    RzpnlSpiFwVer                 : TRzPanel;
    edPgFwVer                     : TRzEdit;
    edSpiFwVer                    : TRzEdit;
    RzGrpDispMode									: TRzGroupBox;	// Model Information > Model Parameters > Display Mode
    RzPnlDispModePixelType				: TRzPanel;
    RzPnlDispModeBit							: TRzPanel;
    RzPnlDispModeRotate						: TRzPanel;
    RzPnlDispModeSignalType				: TRzPanel;
    RzPnlDispModeI2cPullup				: TRzPanel;
    RzPnlDispModeDataLineOut			: TRzPanel;
    cmbxDispModePixelType         : TRzComboBox;
    cmbxDispModeBit               : TRzComboBox;
    cmbxDispModeRotate            : TRzComboBox;
    cmbxDispModeSignalType        : TRzComboBox;
    cmbxDispModeI2cPullup         : TRzComboBox;
    cmbxDispModeDataLineOut       : TRzComboBox;
    RzGrpTimingInfo								: TRzGroupBox;	// Model Information > Model Parameters > Timing Info
    RzPnlTimingInfoFrequence			: TRzPanel;
    RzPnlTimingInfoFreqMHz				: TRzPanel;
    RzPnlTimingInfoStdTiming			: TRzPanel;
    RzPnlTimingInfoStdHorizontal	: TRzPanel;
    RzPnlTimingInfoStdVertical		: TRzPanel;
    RzPnlTimingInfoTotalPeriod		: TRzPanel;
    RzPnlTimingInfoActiveArea			: TRzPanel;
    RzPnlTimingInfoPulseWidth			: TRzPanel;
    RzPnlTimingInfoBackPorch			: TRzPanel;
		RzPnlTimingInfoFrontPorch 		: TRzPanel;
    RzPnlTimingInfoClockDelay			: TRzPanel;
    RzPnlTimingInfoI2cFreq				: TRzPanel;
    edTimingInfoFreqency          : TRzEdit;
    edTimingInfoTotalPeriod_H     : TRzEdit;
    edTimingInfoTotalPeriod_V     : TRzEdit;
    edTimingInfoActiveArea_H      : TRzEdit;
    edTimingInfoActiveArea_V      : TRzEdit;
    edTimingInfoPulseWidth_H      : TRzEdit;
    edTimingInfoPulseWidth_V      : TRzEdit;
    edTimingInfoBackPorch_H       : TRzEdit;
    edTimingInfoBackPorch_V       : TRzEdit;
    edTimingInfoFrontPorch_H      : TRzEdit;
    edTimingInfoFrontPorch_V      : TRzEdit;
    cmbxTimingInfoClockDelay      : TRzComboBox;
    cmbxTimingInfoI2cFreq         : TRzComboBox;
    RzGrpPowerSeq									: TRzGroupBox;	// Model Information > Model Parameters > Power Sequence
    RzPnlPowerSeqOn								: TRzPanel;
    RzPnlPowerSeqOff							: TRzPanel;
    RzLblPowerSeqOnSeq1						: TRzLabel;
    RzLblPowerSeqOnSeq2						: TRzLabel;
    RzLblPowerSeqOnSeq3						: TRzLabel;
    RzLblPowerSeqOffSeq1					: TRzLabel;
    RzLblPowerSeqOffSeq2					: TRzLabel;
    RzLblPowerSeqOffSeq3					: TRzLabel;
    cmbxPowerSeq                  : TRzComboBox;
    edPowerSeqOnSeq1              : TRzEdit;
    edPowerSeqOnSeq2              : TRzEdit;
    edPowerSeqOnSeq3              : TRzEdit;
    edPowerSeqOffSeq1             : TRzEdit;
    edPowerSeqOffSeq2             : TRzEdit;
    edPowerSeqOffSeq3             : TRzEdit;
    RzGrpInputVoltage							: TRzGroupBox;	// Model Information > Model Parameters > Input Voltage
    RzPnlInputVoltagePower				: TRzPanel;
    RzpnlInputVotageValues: TRzPanel;
    RzPnlInputVoltageVcc					: TRzPanel;
    RzPnlInputVoltageVdd: TRzPanel;
    edInputVoltageVcc             : TRzNumericEdit;
    edInputVoltageVdd: TRzNumericEdit;
    RzGrpLimitSetting							: TRzGroupBox;	// Model Information > Model Parameters > Limit Setting
    RzPnlLimitSettingValues				: TRzPanel;
    RzPnlLimitSettingLow					: TRzPanel;
    RzPnlLimitSettingHigh					: TRzPanel;
    RzPnlLimitSettingVcc          : TRzPanel;
    RzPnlLimitSettingIcc          : TRzPanel;
    RzPnlLimitSettingVdd: TRzPanel;
    RzPnlLimitSettingIdd: TRzPanel;
		
    edLimitSettingVcc_Low         : TRzNumericEdit;
    edLimitSettingVcc_High        : TRzNumericEdit;
    edLimitSettingIcc_Low         : TRzEdit;
    edLimitSettingIcc_High        : TRzEdit;
    edLimitSettingVdd_Low: TRzNumericEdit;
    edLimitSettingVdd_High: TRzNumericEdit;
    edLimitSettingIdd_Low: TRzEdit;
    edLimitSettingIdd_High: TRzEdit;
    RzGrpPocbOption								: TRzGroupBox;  // Model Information > Model Parameters > POCB Option
    RzpnlPocbOptionMotionCh1Title : TRzPanel;         // Model Information > Model Parameters > POCB Option > Motion Position
    RzpnlPocbOptionMotionCh2Title : TRzPanel;
{$IFDEF HAS_MOTION_CAM_Z}
    RzpnlPocbOptionZAsixTitle     : TRzPanel;
{$ENDIF}
    RzpnlPocbOptionYAsixTitle     : TRzPanel;
    RzpnlPocbOptionYLoadPosTitle  : TRzPanel;
    RzpnlPocbOptionYCamPosTitle   : TRzPanel;
    RzpnlPocbOptionBcrLen         : TRzPanel;     // Model Information > Model Parameters > POCB Option > BCR Length
    edPocbOptionBcrLen            : TRzEdit;
    cbPocbOptionUseVacuum         : TRzCheckBox;  // Model Information > Model Parameters > POCB Option > Use Vacuum
    cbPocbOptionIonOnOff          : TRzCheckBox;  // Model Information > Model Parameters > POCB Option > Ionizer On/Off //2019-09-26
    RzPnlPocbOptionPatGrp					: TRzPanel;     // Model Information > Model Parameters > POCB Option > Pattern Group
    cmbxPocbOptionPatGrp          : TRzComboBox;
    RzpnlPocbOptionTEndWaittime   : TRzPanel;     // Model Information > Model Parameters > POCB Option > Camera TEnd Waittime
    RzLblPocbOptionTEndWaitMin    : TRzLabel;
    cmbxPocbOptionCamTEndWait     : TRzComboBox;
    RzgrpPocbOptionUniformityVerify: TRzGroupBox;
    RzPnlPocbOptionVerifyCount		: TRzPanel;     // Model Information > Model Parameters > POCB Option > Verification Count
    cmbxPocbOptionVerifyCnt       : TRzComboBox;
    RzPnlPocbOptionComparePat1		: TRzPanel;	    // Model Information > Model Parameters > POCB Option > Compared Pattern 1~4
    RzPnlPocbOptionComparePat2		: TRzPanel;
    RzpnlPocbOptionComparePat3    : TRzPanel;
    RzpnlPocbOptionComparePat4    : TRzPanel;
    cmbxPocbOptionComparePat1     : TRzComboBox;
    cmbxPocbOptionComparePat2     : TRzComboBox;
    cmbxPocbOptionComparePat3     : TRzComboBox;
    cmbxPocbOptionComparePat4     : TRzComboBox;
    RzPnlPocbOptionUniformityBase1: TRzPanel;		  // Model Information > Model Parameters > POCB Option > Uniformity Base 1~4
    RzPnlPocbOptionUniformityBase2: TRzPanel;
    RzpnlPocbOptionUniformityBase3: TRzPanel;
    RzpnlPocbOptionUniformityBase4: TRzPanel;
    RzLblPocbOptionWhiteLumi1			: TRzLabel;
    RzLblPocbOptionWhiteLumi2			: TRzLabel;
    RzLblPocbOptionWhiteLumi3     : TRzLabel;
    RzLblPocbOptionWhiteLumi4     : TRzLabel;
    edPocbOptionWhiteLumi1        : TRzEdit;
    edPocbOptionWhiteLumi2        : TRzEdit;
    edPocbOptionWhiteLumi3        : TRzEdit;
    edPocbOptionWhiteLumi4        : TRzEdit;
    RzPnlPocbOptionBmpDownRetryCnt: TRzPanel;
    cmbxPocbOptionBmpDownRetryCnt : TRzComboBox;
    RzgrpEepromFlashOption        : TRzGroupBox;  // Model Information > Model Parameters > EEPROM/FLASH
    cbPowerOnOffUseOption         : TRzCheckBox;
    cbProcMaskUseOption           : TRzCheckBox;
    cbCBDataWriteUseOption        : TRzCheckBox;

  	// Page (Pattern Information) ----------------------------------------------
    btnPatternInfoSave						: TRzBitBtn;
    btnPatternInfoClose						: TRzBitBtn;
		// - Pattern Group Selection
    RzGrpPatGrpSelection					: TRzGroupBox;
    btnPatGrpNew									: TRzBitBtn;		// Pattern Information > Pattern Group Selection > (Button) Group New/Copy/Rename/Delete
    btnPatGrpRename								: TRzBitBtn;
    btnPatGrpCopy									: TRzBitBtn;
    btnPatGrpDelete								: TRzBitBtn;
    RzGrpPatGrpName								: TRzGroupBox;
    edPatGrpName                  : TRzEdit;
    RzGrpPatGrpPatCnt             : TRzGroupBox;	// Pattern Information > Pattern Group Selection > Pattern Count
    RzPnlPatGrpPatCnt							: TRzPanel;
    edPatGrpPatCnt                : TRzEdit;
    RzGrpPatGrpList								: TRzGroupBox;
    lstbxPatGrpList               : TRzListBox;
    RzGrpPatInformation           : TRzGroupBox;
    btnPatternAdd									: TRzBitBtn;		// Pattern Information > Pattern Information > (Button) Pattern Add/Delete/Modify
    btnPatternDel									: TRzBitBtn;
    btnPatternModify							: TRzBitBtn;
    btnPatternUp									: TRzBitBtn;		// Pattern Information > Pattern Information > (Button) Pattern Up/Down
    btnPatternDown								: TRzBitBtn;
    btnPatternEdit								: TRzBitBtn;		// Pattern Information > Pattern Information > (Button) Pattern Edit
    RzGrpPatInfoType							: TRzGroupBox;
    cmbxPatInfoType               : TRzComboBox;
    RzGrpPatInfoName							: TRzGroupBox;
    cmbxPatInfoName               : TRzComboBox;
    RzGrpPatInfoVSync							: TRzGroupBox;	// Pattern Information > Pattern Information > VSync
    RzPnlPatInfoVSyncHz						: TRzPanel;
    cbPatInfoVSync                : TRzCheckBox;
    edPatInfoVSync                : TRzEdit;
    RzGrpPatInfoTime							: TRzGroupBox;	// Pattern Information > Pattern Information > Time
    RzPnlPatInfoTimeSec						: TRzPanel;
    cbPatInfoTime                 : TRzCheckBox;
    edPatInfoTime                 : TRzEdit;
    RzGrpPatInfoList							: TRzGroupBox;	// Pattern Information > Pattern Information > Pattern List
    RzHdrPatInfoList							: THeader;
    gridPatInfoList								: TRzStringGrid;
    RzGrpPatInfoPreview						: TRzGroupBox;	// Pattern Information > Pattern Information > Preview
    imgPatInfoPreview							: TDongaPat;
    cbPocbOptionUseCustomName: TRzCheckBox;
    edPocbOptionComparePatName1: TRzEdit;
    edPocbOptionComparePatName2: TRzEdit;
    edPocbOptionComparePatName3: TRzEdit;
    edPocbOptionComparePatName4: TRzEdit;
    cbPocbOptionScanFirst: TRzCheckBox;
    cbPocbOptionModelCh1Use: TRzCheckBox;
    cbPocbOptionModelCh2Use: TRzCheckBox;
    edPocbOptionYaxis1CamPos: TRzNumericEdit;
    edPocbOptionYaxis1LoadPos: TRzNumericEdit;
    edPocbOptionYaxis2CamPos: TRzNumericEdit;
    edPocbOptionYaxis2LoadPos: TRzNumericEdit;
    edPocbOptionRobot1CoordX: TRzNumericEdit;
    edPocbOptionRobot1CoordY: TRzNumericEdit;
    edPocbOptionRobot1CoordZ: TRzNumericEdit;
    edPocbOptionRobot1CoordRx: TRzNumericEdit;
    edPocbOptionRobot1CoordRy: TRzNumericEdit;
    edPocbOptionRobot1CoordRz: TRzNumericEdit;
    RzpnlPocbOptionRobotRxRyRz: TRzPanel;
    RzpnlPocbOptionRobotXYZ: TRzPanel;
    edPocbOptionRobot2CoordX: TRzNumericEdit;
    edPocbOptionRobot2CoordY: TRzNumericEdit;
    edPocbOptionRobot2CoordZ: TRzNumericEdit;
    edPocbOptionRobot2CoordRz: TRzNumericEdit;
    edPocbOptionRobot2CoordRy: TRzNumericEdit;
    edPocbOptionRobot2CoordRx: TRzNumericEdit;
    cmbxCh1AssyLcmPos: TRzComboBox;
    RzgrpPocbOptionMotionRobot: TRzGroupBox;
    cmbxCh2AssyLcmPos: TRzComboBox;
    RzpnlAssyLcmPos: TRzPanel;
    RzgrpPocbOptionEtc: TRzGroupBox;
    edPocbOptionRobot1ModelCmd: TRzEdit;
    edPocbOptionRobot2ModelCmd: TRzEdit;
    RzpnlPocbOptionBcrPidChk: TRzPanel;
    edPocbOptionBcrPidChkIdx: TRzEdit;
    edPocbOptionBcrPidChkStr: TRzEdit;
    cbPocbOptionBcrScanMesSPCB: TRzCheckBox;
    cbPocbOptionUseMainPidCh1: TRzCheckBox;
    cbPocbOptionUseMainPidCh2: TRzCheckBox;
    pgModelParamCsv: TAdvOfficePage;
    grpDefParam: TRzGroupBox;
    grdDefParam: TAdvStringGrid;
    btnModeParamClose: TRzBitBtn;
    btnShowModelPramCsv: TRzBitBtn;
    RzgrpVoltageOffset: TRzGroupBox;
    RzpnlVoltageOffsetVcc: TRzPanel;
    RzpnlVoltageOffsetVdd: TRzPanel;
    RzpnlVoltageOffsetTitle: TRzPanel;
    RzpnlVoltageOffsetValues: TRzPanel;
    edVoltageOffsetVcc: TRzNumericEdit;
    edVoltageOffsetVdd: TRzNumericEdit;
    RzpnlDispModeWP: TRzPanel;
    cmbxDispModeWP: TRzComboBox;
    RzPnlInputVoltageVBR: TRzPanel;
    pgModelDP200: TAdvOfficePage;
    grpPgDP200Info: TRzGroupBox;
    RzgrpDP200SpiI2c: TRzGroupBox;
    RzpnlDP200_SPI_PULLUP: TRzPanel;
    RzpnlDP200_SPI_SPEED: TRzPanel;
    RzpnlDP200_SPI_MODE: TRzPanel;
    cboDP200_SPI_PULLUP: TRzComboBox;
    cboDP200_SPI_SPEED: TRzComboBox;
    RzpnlDP200_SPI_LEVEL: TRzPanel;
    cboDP200_SPI_MODE: TRzComboBox;
    cboDP200_SPI_LEVEL: TRzComboBox;
    RzpnlDP200_I2C_LEVEL: TRzPanel;
    cboDP200_I2C_LEVEL: TRzComboBox;
    RzgrpDP200AlpdpSetting: TRzGroupBox;
    RzpnlDP200_ALPDP_ALPM: TRzPanel;
    RzpnlDP200_ALPDP_LINK_MODE: TRzPanel;
    cboDP200_ALPDP_ALPM: TRzComboBox;
    cboDP200_ALPDP_LINK_MODE: TRzComboBox;
    RzpnlDP200_ALPDP_HPD_CHECK: TRzPanel;
    cboDP200_ALPDP_HPD_CHECK: TRzComboBox;
    RzpnlDP200_ALPDP_SLAVE_ENABLE: TRzPanel;
    cboDP200_ALPDP_SLAVE_ENABLE: TRzComboBox;
    RzpnlDP200_ALPDP_LINK_RATE: TRzPanel;
    edDP200_ALPDP_LINK_RATE: TRzEdit;
    RzpnlDP200_ALPDP_H_FDP: TRzPanel;
    edDP200_ALPDP_H_FDP: TRzEdit;
    RzpnlDP200_ALPDP_H_SDP: TRzPanel;
    edDP200_ALPDP_H_SDP: TRzEdit;
    RzpnlDP200_ALPDP_VB_SLEEP: TRzPanel;
    edDP200_ALPDP_VB_SLEEP: TRzEdit;
    RzpnlDP200_ALPDP_VB_N5B: TRzPanel;
    edDP200_ALPDP_VB_N5B: TRzEdit;
    RzpnlDP200_ALPDP_VB_N7: TRzPanel;
    edDP200_ALPDP_VB_N7: TRzEdit;
    RzpnlDP200_ALPDP_VB_N5A: TRzPanel;
    edDP200_ALPDP_VB_N5A: TRzEdit;
    edDP200_ALPDP_VB_N4: TRzEdit;
    RzpnlDP200_ALPDP_VB_N4: TRzPanel;
    edDP200_ALPDP_VB_N3: TRzEdit;
    RzpnlDP200_ALPDP_VB_N3: TRzPanel;
    edDP200_ALPDP_VB_N2: TRzEdit;
    RzpnlDP200_ALPDP_VB_N2: TRzPanel;
    RzpnlDP200_ALPDP_MSA_VTOTAL: TRzPanel;
    RzpnlDP200_ALPDP_MSA_HSTART: TRzPanel;
    edDP200_ALPDP_MSA_HSTART: TRzEdit;
    RzpnlDP200_ALPDP_MSA_HWIDTH: TRzPanel;
    edDP200_ALPDP_MSA_HWIDTH: TRzEdit;
    edDP200_ALPDP_MSA_VTOTAL: TRzEdit;
    RzpnlDP200_ALPDP_MSA_HTOTAL: TRzPanel;
    edDP200_ALPDP_MSA_HTOTAL: TRzEdit;
    RzpnlDP200_ALPDP_MSA_NVID: TRzPanel;
    edDP200_ALPDP_MSA_NVID: TRzEdit;
    RzpnlDP200_ALPDP_MSA_MVID: TRzPanel;
    edDP200_ALPDP_MSA_MVID: TRzEdit;
    RzpnlDP200_ALPDP_MSA_VSTART: TRzPanel;
    edDP200_ALPDP_MSA_VSTART: TRzEdit;
    RzpnlDP200_ALPDP_MSA_VHEIGHT: TRzPanel;
    edDP200_ALPDP_MSA_VHEIGHT: TRzEdit;
    RzpnlDP200_ALPDP_MSA_HSP_HSW: TRzPanel;
    edDP200_ALPDP_MSA_HSP_HSW: TRzEdit;
    RzpnlDP200_ALPDP_MSA_VSP_VSW: TRzPanel;
    edDP200_ALPDP_MSA_VSP_VSW: TRzEdit;
    RzpnlDP200_ALPDP_MSA_MISC0: TRzPanel;
    edDP200_ALPDP_MSA_MISC0: TRzEdit;
    RzpnlDP200_ALPDP_MSA_MISC1: TRzPanel;
    edDP200_ALPDP_MSA_MISC1: TRzEdit;
    RzpnlDP200_ALPDP_SPECIAL_PANEL: TRzPanel;
    edDP200_ALPDP_SPECIAL_PANEL: TRzEdit;
    RzpnlDP200_ALPDP_CHOP_SECTION: TRzPanel;
    edDP200_ALPDP_CHOP_SECTION: TRzEdit;
    RzpnlDP200_ALPDP_CHOP_ENABLE: TRzPanel;
    RzpnlDP200_ALPDP_SCRAMBLE_SET: TRzPanel;
    cboDP200_ALPDP_SCRAMBLE_SET: TRzComboBox;
    RzpnlDP200_ALPDP_LANE_SETTING: TRzPanel;
    cboDP200_ALPDP_LANE_SETTING: TRzComboBox;
    edDP200_ALPDP_CHOP_SIZE: TRzEdit;
    RzpnlDP200_ALPDP_CHOP_SIZE: TRzPanel;
    RzpnlDP200_ALPDP_H_PCNT: TRzPanel;
    edDP200_ALPDP_H_PCNT: TRzEdit;
    RzpnlDP200_ALPDP_SWING_LEVEL: TRzPanel;
    cboDP200_ALPDP_SWING_LEVEL: TRzComboBox;
    RzpnlDP200_ALPDP_PRE_EMPHASIS_PRE: TRzPanel;
    cboDP200_ALPDP_PRE_EMPHASIS_PRE: TRzComboBox;
    RzpnlDP200_ALPDP_PRE_EMPHASIS_POST: TRzPanel;
    cboDP200_ALPDP_PRE_EMPHASIS_POST: TRzComboBox;
    RzpnlDP200_ALPDP_AUX_FREQ_SET: TRzPanel;
    cboDP200_ALPDP_AUX_FREQ_SET: TRzComboBox;
    RzpnlDP200_ALPDP_DP141_IF_SET: TRzPanel;
    RzpnlDP200_ALPDP_DP141_CNT_SET: TRzPanel;
    edDP200_ALPDP_DP141_IF_SET: TRzEdit;
    edDP200_ALPDP_DP141_CNT_SET: TRzEdit;
    RzpnlDP200_ALPDP_DP141_EDID_SKIP: TRzPanel;
    cboDP200_ALPDP_EDID_SKIP: TRzComboBox;
    RzpnlDP200_ALPDP_DEBUG_LEVEL: TRzPanel;
    cboDP200_ALPDP_DEBUG_LEVEL: TRzComboBox;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    btnSaveModelInfoDP200: TRzBitBtn;
    btnCloseDP200: TRzBitBtn;
    RzgrpModelNameDP200: TRzGroupBox;
    edModelNameDP200: TRzEdit;
    RzgrpPwrSeqBasic: TRzGroupBox;
    cbPwrSeqExtUse: TRzCheckBox;
    RzgrpPwrSeqExt: TRzGroupBox;
    RzpnlPwrSeqExtOff: TRzPanel;
    cmbxPwrSeqExtOnIdx0: TRzComboBox;
    cmbxPwrSeqExtOnIdx1: TRzComboBox;
    cmbxPwrSeqExtOnIdx2: TRzComboBox;
    cmbxPwrSeqExtOnIdx3: TRzComboBox;
    cmbxPwrSeqExtOnIdx4: TRzComboBox;
    RzpnlPwrSeqExtOn: TRzPanel;
    edPwrSeqExtOnDelay0: TRzEdit;
    edPwrSeqExtOnDelay4: TRzEdit;
    edPwrSeqExtOnDelay1: TRzEdit;
    edPwrSeqExtOnDelay2: TRzEdit;
    edPwrSeqExtOnDelay3: TRzEdit;
    RzLblPwrSeqExtOnMsec: TRzLabel;
    cmbxPwrSeqExtOnIdx5: TRzComboBox;
    cmbxPwrSeqExtOffIdx0: TRzComboBox;
    cmbxPwrSeqExtOffIdx1: TRzComboBox;
    cmbxPwrSeqExtOffIdx2: TRzComboBox;
    cmbxPwrSeqExtOffIdx3: TRzComboBox;
    cmbxPwrSeqExtOffIdx4: TRzComboBox;
    cmbxPwrSeqExtOffIdx5: TRzComboBox;
    edPwrSeqExtOffDelay0: TRzEdit;
    edPwrSeqExtOffDelay1: TRzEdit;
    edPwrSeqExtOffDelay2: TRzEdit;
    edPwrSeqExtOffDelay3: TRzEdit;
    edPwrSeqExtOffDelay4: TRzEdit;
    RzLblPwrSeqExtOffMsec: TRzLabel;
    cmbxPwrSeqExtAvailCnt: TRzComboBox;
    RzpnlPwrSeqExtAvailCnt: TRzPanel;
    edInputVoltageVBR: TRzNumericEdit;
    RzPnlPocbOptionPowerOnPat: TRzPanel;
    cmbxPocbOptionPowerOnPat: TRzComboBox;
    cbPocbOptionUsePucOnOff: TRzCheckBox;
    RzLabelVoltageOffsetRange: TRzLabel;
    RzgrpPocbOptionPat: TRzGroupBox;
    RzPnlPocbOptionPwrMeasurePat: TRzPanel;
    cmbxPocbOptionPwrMeasurePat: TRzComboBox;
    RzPnlDispModeModelType: TRzPanel;
    cmbxDispModeModelType: TRzComboBox;
    cboDP200_ALPDP_CHOP_ENABLE: TRzComboBox;
    btnModelInfo2SysInfo: TRzBitBtn;
    RzpnlDP200_ALPDP_eDP_SPEC_OPT: TRzPanel;
    cboDP200_ALPDP_eDP_SPEC_OPT: TRzComboBox;
    cbPocbOptionUsePucImage: TRzCheckBox;
    RzgrpDfsOptions: TRzGroupBox;
    RzpnlDfsOptionCombiModelInfo: TRzPanel;
    edDfsOptionCombiModelInfo: TRzEdit;
    edLogUploadOptionPanelModel: TRzEdit;
    RzpnlLogUploadOptionPanelName: TRzPanel;
    cbPocbOptionUseExLightFlow: TRzCheckBox;
    RzpnlPocbOptionVerifyPat: TRzPanel;
    cmbxPocbOptionVerifyPattern: TRzComboBox;
    RzPnlPocbOptionPowerOnDelay: TRzPanel;
    edPocbOptionPowerOnDelay: TRzEdit;
    RzLblPocbOptionPowerOnDelay: TRzLabel;
    RzPnlPocbOptionPowerOffDelay: TRzPanel;
    edPocbOptionPowerOffDelay: TRzEdit;
    RzLblPocbOptionPowerOffDelay: TRzLabel;
    cbPocbOptionBcrPIDInterlock: TRzCheckBox;
    RzgrpPocbOptionBCR: TRzGroupBox;
    cbPocbOptionBcrSPCBIDInterlock: TRzCheckBox;
    RzPnlDispModeOpenCheck: TRzPanel;
    cmbxDispModeOpenCheck: TRzComboBox;

		// Pages
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure pgModelInfoClick(Sender: TObject);
    procedure pgPatternInfoClick(Sender: TObject);
		// Page (Model Information)
    procedure btnModelInfoSaveClick(Sender: TObject);
    procedure btnModelInfoCloseClick(Sender: TObject);
    procedure btnModelNewClick(Sender: TObject);
    procedure btnModelCopyClick(Sender: TObject);
    procedure btnModelRenameClick(Sender: TObject);
    procedure btnModelDelClick(Sender: TObject);
    procedure lstbxModelListClick(Sender: TObject);
    procedure btnShowModelParamCsv(Sender: TObject); //USE_MODELPARAM_CSV
		// Page (Pattern Information)
    procedure btnPatternInfoSaveClick(Sender: TObject);
    procedure btnPatGrpNewClick(Sender: TObject);
    procedure btnPatGrpCopyClick(Sender: TObject);
    procedure btnPatGrpRenameClick(Sender: TObject);
    procedure btnPatGrpDeleteClick(Sender: TObject);
    procedure btnPatternAddClick(Sender: TObject);
    procedure btnPatternDelClick(Sender: TObject);
    procedure btnPatternEditClick(Sender: TObject);
    procedure btnPatternModifyClick(Sender: TObject);
    procedure btnPatternDownClick(Sender: TObject);
    procedure btnPatternUpClick(Sender: TObject);
    procedure lstbxPatGrpListClick(Sender: TObject);
    procedure cmbxPatInfoTypeChange(Sender: TObject);
    procedure gridPatInfoListClick(Sender: TObject);
    procedure cmbxDispModeSignalTypeChange(Sender: TObject); //TBD:MERGE? DP200
    //
    procedure OnModelInfoAttrChanged(Sender: TObject);  //A2CHv3:MODELINFO:GUI
    //2023-03-06 REMOTE_UPDATE ....start
    procedure btnGetModelInfo2SysInfoClick(Sender: TObject);
    //2023-03-06 REMOTE_UPDATE ....end
  private
    { Private declarations }
    m_bNewModel, m_bCopyModel, m_bRenModel : Boolean;
    m_bNewPatGr, m_bCopyPatGr, m_bRenPatGr : Boolean;
    EditPatGrp    : TPatternGroup;
    FileModelInfo      : TMODELINFO;      //A2CHv3:MODELINFO:GUI
    FileModelInfo2     : TModelInfo2;     //A2CHv3:MODELINFO:GUI
    FileModelInfoALDP  : TModelInfoALDP;  //DP200|DP201
    bModelInfoDispDone : Boolean;         //A2CHv3:MODELINFO:GUI
    procedure InitGui;
    procedure Load_data_model(sModel : string);
    procedure Load_data_pat(PatName : string);
    procedure AddAndFindItemToListbox(tList: TRzListbox; sItem: string; bAdd, bFind: Boolean);
    procedure AddAndFindItemToCombobox(tCombo: TRzCombobox; sItem: string; bAdd, bFind: Boolean);
    procedure DisplayModelInfo(sModelName : string);
    procedure SaveBufModelInfo;
    procedure Display_PatGroup_data(DisplayPatGrp : TPatternGroup);
    procedure PatInfoBtnControl;
    procedure AddComparedData(nCh: Integer; DisplayPatGrp: TPatternGroup); //A2CHv3:MULTIPLE_MODEL
    procedure ShowComparePatNameGui(bValue : Boolean);
    procedure ShowUsePucOnOffGui(bValue : Boolean); //2022-07-15 UNIFORMITY_PUCONOFF
    function LoadFileModelInfo(fName: String): Boolean; //A2CHv3:MODELINFO:GUI
    procedure SaveModelInfo(fName: String);  //A2CHv3:MODELINFO:GUI
    //2023-03-06 REMOTE_UPDATE ....start
    //2023-03-06 REMOTE_UPDATE ....end
  public
    { Public declarations }
  end;

var
  frmModelInfo: TfrmModelInfo;

implementation

uses OtlTaskControl, OtlParallel;

{$R *.dfm}

//******************************************************************************
// procedure/function: Create/Destroy/Init
//    - FormCreate(Sender: TObject)
//    - pgModelInfoClick(Sender: TObject)
//    - pgPatternInfoClick(Sender: TObject)
//******************************************************************************

procedure TfrmModelInfo.FormCreate(Sender: TObject);
var
  i, nCh : Integer;
  edPatList : TPatternGroup;
begin
  Common.MLog(DefPocb.SYS_LOG,'<MODELINFO> Window Open');
  //
  PagesModelInfos.ActivePage := pgModelInfo;  //2020-06-03
  if Common.SystemInfo.PG_TYPE = PG_TYPE_DP489 then pgModelDP200.TabVisible := False //DP489
  else                                              pgModelDP200.TabVisible := True; //DP200|DP201

  // Display form at center
  Self.Left := (Screen.Width - Self.Width) div 2;
  Self.Top := (Screen.Height - Self.Height) div 2;

  imgPatInfoPreview.DongaUseSpc  := False;
  imgPatInfoPreview.DongaPatPath := Common.Path.Pattern;
  imgPatInfoPreview.DongaBmpPath := Common.Path.BMP;
  imgPatInfoPreview.DongaImgWidth := imgPatInfoPreview.Width;
  imgPatInfoPreview.DongaImgHight := imgPatInfoPreview.Height;
  imgPatInfoPreview.Stretch := True;
  imgPatInfoPreview.LoadAllPatFile;

  InitGui;
  PagesModelInfos.ActivePage := pgModelInfo; //USE_MODEL_PARAM_CSV

  nCh := DefPocb.CH_1;
  Load_data_model(Common.SystemInfo.TestModel[nCh]);
  DisplayModelInfo(Common.SystemInfo.TestModel[nCh]);
  Load_data_pat(FileModelInfo.PatGrpName); //A2CHv3:MODELINFO:GUI

  for i := 0 to Pred(lstbxPatGrpList.Count) do begin
    if lstbxPatGrpList.Items[i] = FileModelInfo.PatGrpName then begin
      edPatGrpName.Text := FileModelInfo.PatGrpName;  //A2CHv3:MODELINFO:GUI
      lstbxPatGrpList.ItemIndex := i;
      lstbxPatGrpList.OnClick(nil);
      Break;
    end;
  end;

  cmbxPocbOptionPatGrp.Clear;
  for i := 0 to Pred(lstbxPatGrpList.Items.Count) do begin
    cmbxPocbOptionPatGrp.Items.Add(lstbxPatGrpList.Items.Strings[i]);
  end;

  for i := 0 to Pred(cmbxPocbOptionPatGrp.Items.Count) do begin
    if cmbxPocbOptionPatGrp.Items[i] = FileModelInfo.PatGrpName then begin  //A2CHv3:MODELINFO:GUI
      cmbxPocbOptionPatGrp.ItemIndex := i;
      edPatList := Common.LoadPatGroup(lstbxPatGrpList.Items.Strings[i]);
      AddComparedData(nCh,edPatList);
      Break;
    end;
  end;
end;

procedure TfrmModelInfo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Common.MLog(DefPocb.SYS_LOG,'<MODELINFO> Window Close');
  CanClose := True;
end;

procedure TfrmModelInfo.InitGui;
begin
  {$IFDEF POCB_A2CH}
  edPocbOptionYaxis1LoadPos.Enabled := False;
  edPocbOptionYaxis2LoadPos.Enabled := False;
  {$ENDIF}

  {$IFDEF SUPPORT_1CG2PANEL}
  if (not Common.SystemInfo.UseAssyPOCB) then begin
  {$ENDIF}
    cbPocbOptionModelCh1Use.Checked := True;
    cbPocbOptionModelCh1Use.Visible := False;
    cbPocbOptionModelCh2Use.Checked := True;
    cbPocbOptionModelCh2Use.Visible := False;
    cbPocbOptionUseMainPidCh1.Visible := False;
    cbPocbOptionUseMainPidCh2.Visible := False;
    RzpnlAssyLcmPos.Visible   := False;
    cmbxCh1AssyLcmPos.Visible := False;
    cmbxCh2AssyLcmPos.Visible := False;
  {$IFDEF SUPPORT_1CG2PANEL}
  end
  else begin
    cbPocbOptionModelCh1Use.Enabled := True;
    cbPocbOptionModelCh2Use.Visible := True;
    cbPocbOptionModelCh2Use.Enabled := True;
    cbPocbOptionModelCh2Use.Visible := True;
    cbPocbOptionUseMainPidCh1.Visible := True;
    cbPocbOptionUseMainPidCh2.Visible := True;
    RzpnlAssyLcmPos.Visible   := True;
    cmbxCh1AssyLcmPos.Visible := True;
    cmbxCh2AssyLcmPos.Visible := True;
  end;
  {$ENDIF}
  //
  {$IFDEF PANEL_AUTO}
  if Common.SystemInfo.PG_TYPE = PG_TYPE_DP489 then begin
    RzpnlDispModeWP.Visible := False;
    cmbxDispModeWP.Visible  := False;
  end;
  {$ENDIF}
  //
  bModelInfoDispDone       := False; //A2CHv3:MODELINFO:GUI //TBD:A2CH?A2CHv2?
  btnModelInfoSave.Enabled := False; //A2CHv3:MODELINFO:GUI //TBD:A2CH?A2CHv2?

  //
  {$IF Defined(SIMULATOR) and Defined(SITE_LGDVH)}
  btnModelInfo2SysInfo.Visible := True;
  {$ENDIF}
end;

procedure TfrmModelInfo.pgModelInfoClick(Sender: TObject);
begin
  pnlModelInfoHeader.Caption := 'Model Information Registration';
end;

procedure TfrmModelInfo.pgPatternInfoClick(Sender: TObject);
begin
  pnlModelInfoHeader.Caption := 'Pattern List Information Registration';
end;

//******************************************************************************
// procedure/function: Model Information
//    - btnModelInfoSaveClick(Sender: TObject)
//    - btnModelInfoCloseClick(Sender: TObject)
//    - btnModelNewClick(Sender: TObject)
//    - btnModelCopyClick(Sender: TObject)
//    - btnModelRenameClick(Sender: TObject)
//    - btnModelDelClick(Sender: TObject)
//    - lstbxModelListClick(Sender: TObject)

//******************************************************************************

procedure TfrmModelInfo.btnModelInfoSaveClick(Sender: TObject);
var
  sOldName, sNewName : string;
  i, nCh : Integer;
  sSelectedModelName : string; //A2CHv3:MODELINFO:GUI
  sActionNewCopyRen  : string;
begin

  if Trim(edModelName.Text) = '' then begin
    MessageDlg(#13#10 + 'Input Error! Please Insert the Model name.', mtError, [mbOK], 0);
    edModelName.SetFocus;
    Exit;
  end;

  if m_bNewModel or m_bRenModel or m_bCopyModel then begin
    //2022-07-30
    sOldName := lstbxModelList.Items.Strings[lstbxModelList.ItemIndex];
    sNewName := Trim(edModelName.Text);

    if m_bNewModel then       sActionNewCopyRen := 'Are you sure to CREATE new model ?' + #13#10 + #13#10 + 'New model('+sNewName+')'
    else if m_bCopyModel then sActionNewCopyRen := 'Are you sure to COPY this model ?' + #13#10 + #13#10 + 'Copy from ('+sOldName+')' + ' to ('+sNewName+')'
    else if m_bRenModel  then sActionNewCopyRen := 'Are you sure to RENAME this model ?' + #13#10 + #13#10 + 'Rename from ('+sOldName+')' + ' to ('+sNewName+')'
    else exit;

    if MessageDlg(#13#10 + sActionNewCopyRen, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin
      edModelName.Text     := lstbxModelList.Items.Strings[lstbxModelList.ItemIndex]; //recover edModelName to selected item
      edModelNameDP200.Text := edModelName.Text;
      edModelName.ReadOnly := True;
      //
      m_bNewModel  := False;
      m_bCopyModel := False;
      m_bRenModel  := False;
      //
      btnModelInfoSave.Enabled := False;
      Exit;
    end;

    // No save if already exist
    if FileExists(Common.GetFilePath(Trim(edModelName.Text), DefPocb.PATH_TYPE_MODEL)) then begin
      MessageDlg(#13#10 + 'Input Error! Model Name [' + Trim(edModelName.Text) + '] is already Exist!', mtError, [mbOk], 0);
      edModelName.SelectAll;
      edModelName.SetFocus;
      Exit;
    end;

    if m_bCopyModel then begin   // Add to list if new model
      // COPY MODEL?? ???? prg ???ϵ? ???? ?????ϵ??? ????? (BOE)
      sOldName := lstbxModelList.Items.Strings[lstbxModelList.ItemIndex];
      sNewName := Trim(edModelName.Text);
      // No save if same
      for i := 0 to Pred(lstbxModelList.Items.Count) do begin
        if lstbxModelList.Items.Strings[i] = sNewName then begin
          MessageDlg(#13#10 + 'Input Error! Model Name [' + Trim(edModelName.Text) + '] is already Exist!', mtError, [mbOk], 0);
          Exit;
        end;
      end;
      CopyFile(PChar(Common.Path.Model + sOldName + '.mcf'), PChar(Common.Path.MODEL + sNewName + '.mcf'), False);
      {$IFDEF USE_MODEL_PARAM_CSV}
      CopyFile(PChar(Common.Path.Model + sOldName + '_param.csv'), PChar(Common.Path.MODEL + sNewName + '_param.csv'), False);
      {$ENDIF}
    end;
  end
  else begin
    if MessageDlg(#13#10 + 'Are you sure to SAVE this Model Info?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin  //2023-06-07
      btnModelInfoSave.Enabled := False;
      Exit;
    end;
  end;

  if m_bRenModel then begin
    sOldName := lstbxModelList.Items.Strings[lstbxModelList.ItemIndex];
    sNewName := Trim(edModelName.Text);
    if (not RenameFile(Common.GetFilePath(sOldName, DefPocb.PATH_TYPE_MODEL), Common.GetFilePath(sNewName, DefPocb.PATH_TYPE_MODEL)))
      {$IFDEF USE_MODEL_PARAM_CSV}
      or (not RenameFile(Common.GetFilePath(sOldName, DefPocb.PATH_TYPE_MODEL_PARAM), Common.GetFilePath(sNewName, DefPocb.PATH_TYPE_MODEL_PARAM)))
      {$ENDIF}
    then begin
      edModelName.SelectAll;
      edModelName.SetFocus;
      Exit;
    end;
  end;
  //-----------------------------------------------------------------------------------

  if m_bNewModel or m_bCopyModel then begin   // Add to list if new model
    AddAndFindItemToListbox(lstbxModelList, edModelName.text, True, True);
  end;

  if m_bRenModel then begin
    lstbxModelList.Sorted := False;
    lstbxModelList.Items.Strings[lstbxModelList.ItemIndex] := sNewName;
    lstbxModelList.Sorted := True;
    AddAndFindItemToListbox(lstbxModelList, sNewName, False, True);
  end;

  sSelectedModelName := edModelName.Text;
  // Save to Buffer
  SaveBufModelInfo;
  // Save file
  SaveModelInfo(Trim(sSelectedModelName));

  Common.SaveSystemInfo;
  Common.SetEdModel2TestModel;

  // Display after save
  if m_bNewModel or m_bCopyModel or m_bRenModel then begin
    lstbxModelListClick(nil);
  end;

  for nCh := DefPocb.CH_1 to DefPocb.CH_MAX do begin
    Common.SendModelData(nCh);  // !!! index error if thread is in for-loop
  end;

  Common.m_bNeedInitial := True;  //TBD?
  MessageDlg(#13#10 + sSelectedModelName +' Model Information File Saving OK!', mtInformation, [mbOk], 0);
end;

procedure TfrmModelInfo.btnModelInfoCloseClick(Sender: TObject);
begin
//Common.MLog(DefPocb.SYS_LOG,'<MODELINFO> Window Close');
  Close;
end;

procedure TfrmModelInfo.btnModelNewClick(Sender: TObject);
begin
  edModelName.ReadOnly := False;
  edModelName.Text := '';
  edModelNameDP200.Text := '';
  edModelName.SetFocus;
  //
  m_bNewModel  := True;
  m_bCopyModel := False;
  m_bRenModel  := False;
  //
  btnModelInfoSave.Enabled := True;
end;

procedure TfrmModelInfo.btnModelCopyClick(Sender: TObject);
var
  nCurItemIndex : integer;
  nNewModelName : string;
begin
  edModelName.ReadOnly := False;
  edModelName.SetFocus;
  //
  m_bNewModel  := False;
  m_bCopyModel := True;
  m_bRenModel  := False;
  //
  btnModelInfoSave.Enabled := True;
end;

procedure TfrmModelInfo.btnModelRenameClick(Sender: TObject);
begin
  edModelName.ReadOnly := False;
  edModelName.SetFocus;
  //
  m_bNewModel  := False;
  m_bCopyModel := False;
  m_bRenModel  := True;
  //
  btnModelInfoSave.Enabled := True;
end;

procedure TfrmModelInfo.btnModelDelClick(Sender: TObject);
var
  idx : Integer;
begin
  if lstbxModelList.ItemIndex < 0 then Exit;

  if MessageDlg(#13#10 + 'Are you sure to DELETE this Model?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    idx := lstbxModelList.ItemIndex;
    if idx > -1 then begin
      DeleteFile(Common.GetFilePath(lstbxModelList.Items.Strings[idx], DefPocb.PATH_TYPE_MODEL));
      {$IFDEF USE_MODEL_PARAM_CSV}
      DeleteFile(Common.GetFilePath(lstbxModelList.Items.Strings[idx], DefPocb.PATH_TYPE_MODEL_PARAM)); //2022-07-30
      {$ENDIF}
      lstbxModelList.Items.Delete(idx);
      lstbxModelList.ItemIndex := idx - 1;
      if (lstbxModelList.ItemIndex = -1) and (lstbxModelList.Items.Count > 0) then
        lstbxModelList.ItemIndex := 0;
      lstbxModelListClick(nil);
    end;
  end;
end;

procedure TfrmModelInfo.lstbxModelListClick(Sender: TObject);
var
  sModel : string;
  i, nCh : integer;
  edPatList : TPatternGroup;
begin
  edModelName.ReadOnly := True;
  m_bNewModel := False;
  m_bCopyModel:= False;
  m_bRenModel := False;

  sModel := lstbxModelList.Items[lstbxModelList.ItemIndex];
  DisplayModelInfo(sModel);
  edModelName.Text := sModel;
  edModelNameDP200.Text := sModel;  //2021-06-21 DP200
  pnlModelNameInfo.Caption := sModel;

  nCh := DefPocb.CH_1;
  for i := 0 to Pred(cmbxPocbOptionPatGrp.Items.Count) do begin
    if cmbxPocbOptionPatGrp.Items[i] = FileModelInfo.PatGrpName then begin
      cmbxPocbOptionPatGrp.ItemIndex := i;
      edPatList :=  Common.LoadPatGroup(lstbxPatGrpList.Items.Strings[i]);
      AddComparedData(nCh,edPatList);
      Break;
    end;
  end;
  for i := 0  to Pred(lstbxPatGrpList.Items.Count) do begin
    if lstbxPatGrpList.Items[i] = FileModelInfo.PatGrpName then begin
      lstbxPatGrpList.ItemIndex := i;
      lstbxPatGrpListClick(nil);
      Break;
    end;
  end;

end;

procedure TfrmModelInfo.SaveBufModelInfo;  //TBD:A2CHv3:MULTIPLE_MODEL?
var
  nCh : Integer;
begin
    with FileModelInfo do begin
      // Model Information > Model Parameters > Display Mode
      PixelType  := Byte(cmbxDispModePixelType.ItemIndex);
      Bit        := Byte(cmbxDispModeBit.ItemIndex);
      Rotate     := Byte(cmbxDispModeRotate.ItemIndex);
      SigType    := Byte(cmbxDispModeSignalType.ItemIndex);
  		WP         := Byte(cmbxDispModeWP.ItemIndex);        //TBD:MERGE? FOldPOCB(O) AutoPOCB(X)
      I2cPullup  := Byte(cmbxDispModeI2cPullup.ItemIndex); //TBD:MERGE? FOldPOCB(O) AutoPOCB(X)
      DataLineOut:= Byte(cmbxDispModeDataLineOut.ItemIndex);
      OpenCheck  := Byte(cmbxDispModeOpenCheck.ItemIndex); //2023-10-18 DP200|DP201
      ModelType  := Byte(cmbxDispModeModelType.ItemIndex); //2022-10-12
      // Model Information > Model Parameters > Timing Info
      Freq       := Trunc(StrToFloatDef(edTimingInfoFreqency.Text,0.0)*100);
      H_Total    := StrToIntDef(edTimingInfoTotalPeriod_H.Text,0);
      V_Total    := StrToIntDef(edTimingInfoTotalPeriod_V.Text,0);
      H_Active   := StrToIntDef(edTimingInfoActiveArea_H.Text,0);
      V_Active   := StrToIntDef(edTimingInfoActiveArea_V.Text,0);
      H_Width    := StrToIntDef(edTimingInfoPulseWidth_H.Text,0);
      V_Width    := StrToIntDef(edTimingInfoPulseWidth_V.Text,0);
      H_BP       := StrToIntDef(edTimingInfoBackPorch_H.Text,0);
      V_BP       := StrToIntDef(edTimingInfoBackPorch_V.Text,0);
                             // edTimingInfoFrontPorch_H  //TBD?
                             // edTimingInfoFrontPorch_V  //TBD?
      ClockDelay := cmbxTimingInfoClockDelay.ItemIndex;
      I2cFreq    := cmbxTimingInfoI2cFreq.ItemIndex;

      // Model Information > Model Parameters > Power Sequence
      // - Power Sequence
      Sequence       := cmbxPowerSeq.ItemIndex;  //TBD?
      PowerOnSeq[0]  := StrToIntDef(edPowerSeqOnSeq1.Text,0);
			PowerOnSeq[1]  := StrToIntDef(edPowerSeqOnSeq2.Text,0); //TBD:MERGE? FoldPOCB(O) AutoPOCB(X)
      PowerOnSeq[2]  := StrToIntDef(edPowerSeqOnSeq3.Text,0);
      PowerOffSeq[0] := StrToIntDef(edPowerSeqOffSeq1.Text,0);
      PowerOffSeq[1] := StrToIntDef(edPowerSeqOffSeq2.Text,0); //TBD:MERGE? FoldPOCB(O) AutoPOCB(X)
      PowerOffSeq[2] := StrToIntDef(edPowerSeqOffSeq3.Text,0);
			// - Ext Power Sequence  //2021-11-05 DP201 EXT_POWER_SEQ
      PwrSeqExtUse         := cbPwrSeqExtUse.Checked;
      PwrSeqExtAvailCnt    := Integer(cmbxPwrSeqExtAvailCnt.ItemIndex);
      PwrSeqExtOnIdx[0]    := cmbxPwrSeqExtOnIdx0.ItemIndex;
      PwrSeqExtOnIdx[1]    := cmbxPwrSeqExtOnIdx1.ItemIndex;
      PwrSeqExtOnIdx[2]    := cmbxPwrSeqExtOnIdx2.ItemIndex;
      PwrSeqExtOnIdx[3]    := cmbxPwrSeqExtOnIdx3.ItemIndex;
      PwrSeqExtOnIdx[4]    := cmbxPwrSeqExtOnIdx4.ItemIndex;
      PwrSeqExtOnIdx[5]    := cmbxPwrSeqExtOnIdx5.ItemIndex;
    //PwrSeqExtOnIdx[X]    := cmbxPwrSeqExtOnIdxX.ItemIndex;
      PwrSeqExtOffIdx[0]   := cmbxPwrSeqExtOffIdx0.ItemIndex;
      PwrSeqExtOffIdx[1]   := cmbxPwrSeqExtOffIdx1.ItemIndex;
      PwrSeqExtOffIdx[2]   := cmbxPwrSeqExtOffIdx2.ItemIndex;
      PwrSeqExtOffIdx[3]   := cmbxPwrSeqExtOffIdx3.ItemIndex;
      PwrSeqExtOffIdx[4]   := cmbxPwrSeqExtOffIdx4.ItemIndex;
      PwrSeqExtOffIdx[5]   := cmbxPwrSeqExtOffIdx5.ItemIndex;
    //PwrSeqExtOffIdx[X]   := cmbxPwrSeqExtOffIdxX.ItemIndex;
      PwrSeqExtOnDelay[0]  := StrToIntDef(edPwrSeqExtOnDelay0.Text, 0);
      PwrSeqExtOnDelay[1]  := StrToIntDef(edPwrSeqExtOnDelay1.Text, 0);
      PwrSeqExtOnDelay[2]  := StrToIntDef(edPwrSeqExtOnDelay2.Text, 0);
      PwrSeqExtOnDelay[3]  := StrToIntDef(edPwrSeqExtOnDelay3.Text, 0);
      PwrSeqExtOnDelay[4]  := StrToIntDef(edPwrSeqExtOnDelay4.Text, 0);
    //PwrSeqExtOnDelay[X]  := StrToIntDef(edPwrSeqExtOnDelayX.Text, 0);
      PwrSeqExtOffDelay[0] := StrToIntDef(edPwrSeqExtOffDelay0.Text, 0);
      PwrSeqExtOffDelay[1] := StrToIntDef(edPwrSeqExtOffDelay1.Text, 0);
      PwrSeqExtOffDelay[2] := StrToIntDef(edPwrSeqExtOffDelay2.Text, 0);
      PwrSeqExtOffDelay[3] := StrToIntDef(edPwrSeqExtOffDelay3.Text, 0);
      PwrSeqExtOffDelay[4] := StrToIntDef(edPwrSeqExtOffDelay4.Text, 0);
    //PwrSeqExtOffDelay[X] := StrToIntDef(edPwrSeqExtOffDelayX.Text, 0);

		  // Model Information > Model Parameters > Input Voltage
		  PWR_VOL[DefPG.PWR_VCC]     := Trunc(StrToFloatDef(edInputVoltageVCC.Text,0.00)*1000);
		  PWR_VOL[DefPG.PWR_VDD_VEL] := Trunc(StrToFloatDef(edInputVoltageVdd.Text,0.00)*1000);
		  PWR_VOL[DefPG.PWR_VBR]     := Trunc(StrToFloatDef(edInputVoltageVBR.Text,0.00)*1000);

      // Model Information > Model Parameters > Voltage Offset //edVXX(x.xx V, xxxx mA), ModelInfo(mV,mA
      PWR_OFFSET[DefPG.PWR_VCC]     := Trunc(StrToFloatDef(edVoltageOffsetVcc.Text,0.00)*1000); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
      PWR_OFFSET[DefPG.PWR_VDD_VEL] := Trunc(StrToFloatDef(edVoltageOffsetVdd.Text,0.00)*1000); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)

		  // Model Information > Model Parameters > Limit Setting  //edVXX(x.xx V, xxxx mA), ModelInfo(mV,mA)
		  PWR_LIMIT_L[DefPG.PWR_VCC]     := Trunc(StrToFloatDef(edLimitSettingVcc_Low.Text, 0.00)*1000);
		  PWR_LIMIT_H[DefPG.PWR_VCC]     := Trunc(StrToFloatDef(edLimitSettingVcc_High.Text,0.00)*1000);
		  PWR_LIMIT_L[DefPG.PWR_VDD_VEL] := Trunc(StrToFloatDef(edLimitSettingVdd_Low.Text, 0.00)*1000);
		  PWR_LIMIT_H[DefPG.PWR_VDD_VEL] := Trunc(StrToFloatDef(edLimitSettingVdd_High.Text,0.00)*1000);
		//PWR_LIMIT_L[DefPG.PWR_VBR]     := Trunc(StrToFloatDef(edVBR_Low.Text, 0.00)*1000);
		//PWR_LIMIT_H[DefPG.PWR_VBR]     := Trunc(StrToFloatDef(edVBR_High.Text,0.00)*1000);

		  PWR_LIMIT_L[DefPG.PWR_ICC]     := Trunc(StrToIntDef(edLimitSettingIcc_Low.Text, 0));
		  PWR_LIMIT_H[DefPG.PWR_ICC]     := Trunc(StrToIntDef(edLimitSettingIcc_High.Text,0));
		  PWR_LIMIT_L[DefPG.PWR_IDD_IEL] := Trunc(StrToIntDef(edLimitSettingIdd_Low.Text, 0));
		  PWR_LIMIT_H[DefPG.PWR_IDD_IEL] := Trunc(StrToIntDef(edLimitSettingIdd_High.Text,0));

      //
      PatGrpName     := Trim(cmbxPocbOptionPatGrp.Items[cmbxPocbOptionPatGrp.ItemIndex]);
    end; //with FileModelInfo
    //
    with FileModelInfo2 do begin
      // Model Information > PG/SPI Version  //2019-04-19 ALARM:FW_VERSION
      PgFwVer   := Trim(edPgFwVer.Text);
      SpiFwVer  := Trim(edSpiFwVer.Text);

      // Model Information > Model Parameters > POCB Option
      {$IFDEF SUPPORT_1CG2PANEL}
			if (not Common.SystemInfo.UseAssyPOCB) then begin
      {$ENDIF}			
				AssyModelInfo.UseCh1        := True;
				AssyModelInfo.UseCh2        := True;
				AssyModelInfo.LcmPosCh1     := LcmPosCP;
				AssyModelInfo.LcmPosCh2     := LcmPosCP;
				AssyModelInfo.UseMainPidCh1 := True;
				AssyModelInfo.UseMainPidCh2 := True;
      {$IFDEF SUPPORT_1CG2PANEL}				
			end
			else begin
        AssyModelInfo.UseCh1 := cbPocbOptionModelCh1Use.Checked;
        if AssyModelInfo.UseCh1 then begin
          case cmbxCh1AssyLcmPos.ItemIndex of
            0: AssyModelInfo.LcmPosCh1 := LcmPosLeft;
            1: AssyModelInfo.LcmPosCh1 := LcmPosCenter;
          end;
          AssyModelInfo.UseMainPidCh1 := cbPocbOptionUseMainPidCh1.Checked;
        end
        else begin
          AssyModelInfo.LcmPosCh1     := LcmPosCP; //ASSY Not-UseCh
          AssyModelInfo.UseMainPidCh1 := False;
        end;
        AssyModelInfo.UseCh2 := cbPocbOptionModelCh2Use.Checked;
        if AssyModelInfo.UseCh2 then begin
          case cmbxCh2AssyLcmPos.ItemIndex of
            0: AssyModelInfo.LcmPosCh2 := LcmPosRight;
            1: AssyModelInfo.LcmPosCh2 := LcmPosCenter;
          end;
          AssyModelInfo.UseMainPidCh2 := cbPocbOptionUseMainPidCh2.Checked;
        end
        else begin
          AssyModelInfo.LcmPosCh2     := LcmPosCP; //ASSY Not-UseCh
          AssyModelInfo.UseMainPidCh2 := False;
				end;
      end;
      {$ENDIF} //SUPPORT_1CG2PANEL

      {$IFDEF HAS_MOTION_CAM_Z}
      CamZModelPosCh1 := SimpleRoundTo(StrToFloatDef(edPocbOptionZAxis1ModelPos.Text,0.0),-2);
      CamZModelPosCh2 := SimpleRoundTo(StrToFloatDef(edPocbOptionZAxis2ModelPos.Text,0.0),-2);
      {$ENDIF}
      CamYCamPosCh1   := SimpleRoundTo(StrToFloatDef(edPocbOptionYAxis1CamPos.Text,0.0), -2);
      CamYLoadPosCh1  := SimpleRoundTo(StrToFloatDef(edPocbOptionYAxis1LoadPos.Text,0.0),-2);
      CamYCamPosCh2   := SimpleRoundTo(StrToFloatDef(edPocbOptionYAxis2CamPos.Text,0.0), -2);
      CamYLoadPosCh2  := SimpleRoundTo(StrToFloatDef(edPocbOptionYAxis2LoadPos.Text,0.0),-2);
      {$IFDEF HAS_ROBOT_CAM_Z}
      RobotModelInfoCh1.Coord.X  := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot1CoordX.Text, 0.0),-2);
      RobotModelInfoCh1.Coord.Y  := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot1CoordY.Text, 0.0),-2);
      RobotModelInfoCh1.Coord.Z  := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot1CoordZ.Text, 0.0),-2);
      RobotModelInfoCh1.Coord.Rx := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot1CoordRx.Text,0.0),-2);
      RobotModelInfoCh1.Coord.Ry := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot1CoordRy.Text,0.0),-2);
      RobotModelInfoCh1.Coord.Rz := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot1CoordRz.Text,0.0),-2);
      RobotModelInfoCh1.ModelCmd := Trim(edPocbOptionRobot1ModelCmd.Text);
      RobotModelInfoCh2.Coord.X  := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot2CoordX.Text, 0.0),-2);
      RobotModelInfoCh2.Coord.Y  := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot2CoordY.Text, 0.0),-2);
      RobotModelInfoCh2.Coord.Z  := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot2CoordZ.Text, 0.0),-2);
      RobotModelInfoCh2.Coord.Rx := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot2CoordRx.Text,0.0),-2);
      RobotModelInfoCh2.Coord.Ry := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot2CoordRy.Text,0.0),-2);
      RobotModelInfoCh2.Coord.Rz := SimpleRoundTo(StrToFloatDef(edPocbOptionRobot2CoordRz.Text,0.0),-2);
      RobotModelInfoCh2.ModelCmd := Trim(edPocbOptionRobot2ModelCmd.Text);
      {$ENDIF}

      PowerOnPatNum    := cmbxPocbOptionPowerOnPat.ItemIndex;    //A2CHv4:POWER_ON_PATTERN
      PwrMeasurePatNum := cmbxPocbOptionPwrMeasurePat.ItemIndex; //2022-09-06 POWER_MEASURE_PAT
      VerifyPatNum     := cmbxPocbOptionVerifyPattern.ItemIndex;

      //
      BcrLength     := StrToIntDef(edPocbOptionBcrLen.Text,0);
      BcrPidChkIdx  := StrToIntDef(edPocbOptionBcrPidChkIdx.Text,0); //A2CHv3:BCR_PID_CHECK
      BcrPidChkStr  := Trim(edPocbOptionBcrPidChkStr.Text);          //A2CHv3:BCR_PID_CHECK
			{$IFDEF FEATURE_BCR_SCAN_SPCB}
      BcrScanMesSPCB     := cbPocbOptionBcrScanMesSPCB.Checked;      //A2CHv4:Lucid:ScanSPCB
      BcrSPCBIdInterlock := cbPocbOptionBcrSPCBIDInterlock.Checked;  //A2CHv4:Lucid:ScanSPCB //2023-05-19 A2CHv4:SPCB_ID_INTERLOCK
			{$ENDIF}
      {$IFDEF FEATURE_BCR_PID_INTERLOCK}
      BcrPIDInterlock    := cbPocbOptionBcrPIDInterlock.Checked;  //2023-09-26 VH#301:BCR_PID_INTERLOCK
      {$ENDIF}

      UseExLightFlow := cbPocbOptionUseExLightFlow.Checked;
      UseVacuum      := cbPocbOptionUseVacuum.Checked; //2019-06-24
      UseIonOnOff    := cbPocbOptionIonOnOff.Checked;  //2019-09-26 Ionizer On/Off
    //{$IF Defined(PANEL_AUTO)}
      UseScanFirst   := cbPocbOptionScanFirst.Checked;
		//{$ENDIF}

      CamTEndWait    := cmbxPocbOptionCamTEndWait.ItemIndex;
      {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
      CamCBCount     := cmbxPocbOptionCamCBCount.ItemIndex;
      UsePowerResetAfterEepromCBParaWrite  := cbPocbOptionPowerResetAfterEepCBParaWrite.Checked;
			{$ENDIF}
      {$IFDEF HAS_DIO_PINBLOCK}
      UseCheckPinblock  := cbPocbOptionCheckPinblock.Checked;
  		{$ENDIF}
			
      {$IFDEF FEATURE_UNIFORMITY_PUCONOFF}
      UsePucOnOff     := cbPocbOptionUsePucOnOff.Checked; //2022-07-15 FEATURE_UNIFORMITY_PUCONOFF
      {$ENDIF}
      {$IFDEF FEATURE_PUC_IMAGE}
      UsePucImage     := cbPocbOptionUsePucImage.Checked; //2023-04-07 FEATURE_PUC_IMAGE
      {$ENDIF}

      JudgeCount     := cmbxPocbOptionVerifyCnt.ItemIndex;
      UseCustumPatName := cbPocbOptionUseCustomName.Checked;
      ComparedPat[0] := cmbxPocbOptionComparePat1.ItemIndex;
      ComparedPat[1] := cmbxPocbOptionComparePat2.ItemIndex;
      ComparedPat[2] := cmbxPocbOptionComparePat3.ItemIndex;
      ComparedPat[3] := cmbxPocbOptionComparePat4.ItemIndex;
      ComparePatName[0] := edPocbOptionComparePatName1.Text;
      ComparePatName[1] := edPocbOptionComparePatName2.Text;
      ComparePatName[2] := edPocbOptionComparePatName3.Text;
      ComparePatName[3] := edPocbOptionComparePatName4.Text;
      WhiteUniform[0] := StrToFloatDef(edPocbOptionWhiteLumi1.Text,70.0);
      WhiteUniform[1] := StrToFloatDef(edPocbOptionWhiteLumi2.Text,70.0);
      WhiteUniform[2] := StrToFloatDef(edPocbOptionWhiteLumi3.Text,70.0);
      WhiteUniform[3] := StrToFloatDef(edPocbOptionWhiteLumi4.Text,70.0);

      {$IFDEF PANEL_AUTO}
      BmpDownRetryCnt := cmbxPocbOptionBmpDownRetryCnt.ItemIndex;
      {$ENDIF}

      {$IFDEF PANEL_AUTO}
      PwrOnDelayMSec  := StrToIntDef(edPocbOptionPowerOnDelay.Text,1000);
      PwrOffDelayMSec := StrToIntDef(edPocbOptionPowerOffDelay.Text,1000);
      {$ELSE}
      PwrOnDelayMSec  := StrToIntDef(edPocbOptionPowerOnDelay.Text,3000);
      PwrOffDelayMSec := StrToIntDef(edPocbOptionPowerOffDelay.Text,1000);
      {$ENDIF}
      {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
      PowerOnAgingSec := StrToIntDef(edPocbOptionPowerOnAgingSec.Text,10);
      {$ENDIF}

      // Model Information > Model Parameters
      EnablePwrMode  := cbPowerOnOffUseOption.Checked;
      EnableProcMask := cbProcMaskUseOption.Checked;
      EnableFlashWriteCBData := cbCBDataWriteUseOption.Checked;

		  {$IFDEF PANEL_FOLD}
			//  - PWM
			Pwm_freq   := StrToIntDef(edPWMOptionFreq.Text,0);
  		Pwm_duty   := StrToIntDef(edPWMOptionDuty.Text,100);  //2019-10-11 DIMMING
  		UsePwm     := cbPWMOptionUse.Checked;
			{$ENDIF}

      CombiModelInfoKey   := Trim(edDfsOptionCombiModelInfo.Text);  //2022-02-11
      LogUploadPanelModel := Trim(edLogUploadOptionPanelModel.Text); //2022-07-25 LOG_UPLOAD

    end; //with FileModelInfo2
		
    //DP200 ---------------------------------------------------------------- start
	  if Common.SystemInfo.PG_TYPE <> DefPG.PG_TYPE_DP489 then begin  //DP200|DP201
  	  with FileModelInfoALDP do begin
    	  SPI_PULLUP := Byte(cboDP200_SPI_PULLUP.ItemIndex);
	      SPI_SPEED  := Byte(cboDP200_SPI_SPEED.ItemIndex);
  	    SPI_MODE   := Byte(cboDP200_SPI_MODE.ItemIndex);
	      SPI_LEVEL  := Byte(cboDP200_SPI_LEVEL.ItemIndex);
	      I2C_LEVEL  := Byte(cboDP200_I2C_LEVEL.ItemIndex);
	      //  - DP200 ALPDP
	      ALPDP_LINK_RATE := StrToIntDef(edDP200_ALPDP_LINK_RATE.Text ,0);
	      ALPDP_H_FDP     := StrToIntDef(edDP200_ALPDP_H_FDP.Text     ,0);
	      ALPDP_H_SDP     := StrToIntDef(edDP200_ALPDP_H_SDP.Text     ,0);
	      ALPDP_H_PCNT    := StrToIntDef(edDP200_ALPDP_H_PCNT.Text    ,0);
	      ALPDP_VB_SLEEP  := StrToIntDef(edDP200_ALPDP_VB_SLEEP.Text  ,0);
	      ALPDP_VB_N2     := StrToIntDef(edDP200_ALPDP_VB_N2.Text     ,0);
	      ALPDP_VB_N3     := StrToIntDef(edDP200_ALPDP_VB_N3.Text     ,0);
	      ALPDP_VB_N4     := StrToIntDef(edDP200_ALPDP_VB_N4.Text     ,0);
	      ALPDP_VB_N5B    := StrToIntDef(edDP200_ALPDP_VB_N5B.Text    ,0);
	      ALPDP_VB_N7     := StrToIntDef(edDP200_ALPDP_VB_N7.Text     ,0);
  	    ALPDP_VB_N5A    := StrToIntDef(edDP200_ALPDP_VB_N5A.Text    ,0);
	      //
	      ALPDP_MSA_MVID      := StrToIntDef(edDP200_ALPDP_MSA_MVID.Text    ,0);
	      ALPDP_MSA_NVID      := StrToIntDef(edDP200_ALPDP_MSA_NVID.Text    ,0);
	      ALPDP_MSA_HTOTAL    := StrToIntDef(edDP200_ALPDP_MSA_HTOTAL.Text  ,0);
	      ALPDP_MSA_HSTART    := StrToIntDef(edDP200_ALPDP_MSA_HSTART.Text  ,0);
	      ALPDP_MSA_HWIDTH    := StrToIntDef(edDP200_ALPDP_MSA_HWIDTH.Text  ,0);
	      ALPDP_MSA_VTOTAL    := StrToIntDef(edDP200_ALPDP_MSA_VTOTAL.Text  ,0);
	      ALPDP_MSA_VSTART    := StrToIntDef(edDP200_ALPDP_MSA_VSTART.Text  ,0);
	      ALPDP_MSA_VHEIGHT   := StrToIntDef(edDP200_ALPDP_MSA_VHEIGHT.Text ,0);
	      ALPDP_MSA_HSP_HSW   := StrToIntDef(edDP200_ALPDP_MSA_HSP_HSW.Text ,0);
	      ALPDP_MSA_VSP_VSW   := StrToIntDef(edDP200_ALPDP_MSA_VSP_VSW.Text ,0);
	      ALPDP_MSA_MISC0     := StrToIntDef(edDP200_ALPDP_MSA_MISC0.Text   ,0);
	      ALPDP_MSA_MISC1     := StrToIntDef(edDP200_ALPDP_MSA_MISC1.Text   ,0);
	      //
	      ALPDP_SPECIAL_PANEL := StrToIntDef(edDP200_ALPDP_SPECIAL_PANEL.Text ,0);
	      ALPDP_ALPM          := Byte(cboDP200_ALPDP_ALPM.ItemIndex);
	      ALPDP_LINK_MODE     := Byte(cboDP200_ALPDP_LINK_MODE.ItemIndex);
	      ALPDP_CHOP_SIZE     := StrToIntDef(edDP200_ALPDP_CHOP_SIZE.Text    ,0);
	      ALPDP_CHOP_SECTION  := StrToIntDef(edDP200_ALPDP_CHOP_SECTION.Text ,0);
	      ALPDP_CHOP_ENABLE   := Byte(cboDP200_ALPDP_CHOP_ENABLE.ItemIndex);
	      ALPDP_HPD_CHECK     := Byte(cboDP200_ALPDP_HPD_CHECK.ItemIndex);
	      ALPDP_SCRAMBLE_SET  := Byte(cboDP200_ALPDP_SCRAMBLE_SET.ItemIndex);
	      ALPDP_LANE_SETTING  := Byte(cboDP200_ALPDP_LANE_SETTING.ItemIndex);
	      ALPDP_SLAVE_ENABLE  := Byte(cboDP200_ALPDP_SLAVE_ENABLE.ItemIndex);
        //
        ALPDP_SWING_LEVEL       := Byte(cboDP200_ALPDP_SWING_LEVEL.ItemIndex);
        ALPDP_PRE_EMPHASIS_PRE  := Byte(cboDP200_ALPDP_PRE_EMPHASIS_PRE.ItemIndex);
        ALPDP_PRE_EMPHASIS_POST := Byte(cboDP200_ALPDP_PRE_EMPHASIS_POST.ItemIndex);
        ALPDP_AUX_FREQ_SET      := Byte(cboDP200_ALPDP_AUX_FREQ_SET.ItemIndex);
        //
        DP141_IF_SET  := StrToIntDef('$'+edDP200_ALPDP_DP141_IF_SET.Text, 0);  //hex
        DP141_CNT_SET := StrToIntDef('$'+edDP200_ALPDP_DP141_CNT_SET.Text, 0); //hex
        EDID_SKIP     := Byte(cboDP200_ALPDP_EDID_SKIP.ItemIndex);
        DEBUG_LEVEL   := Byte(cboDP200_ALPDP_DEBUG_LEVEL.ItemIndex);
        eDP_SPEC_OPT  := Byte(cboDP200_ALPDP_eDP_SPEC_OPT.ItemIndex); // 0:Mode0, 1:Mode1, 2:Pola1, 3:Pola2 //2023-03-24 Tributo
	    end; // with FileModelInfoALDP
	  end;
	  //DP200 ---------------------------------------------------------------- end
//end;
end;

//------------------------------------------------------------------------------
// [PROC/FUNC] TCommon.SaveModelInfo(fName: String)
//      Called-by: procedure TfrmModelInfo.btnModelInfoSaveClick(Sender: TObject);
//
procedure TfrmModelInfo.SaveModelInfo(fName: String);  // A2CHv3:MULTIPLE_MODEL
var
  fn, sTemp : String;
  modelF : TIniFile;
  i : Integer;
  sBackupPath, sBackupFullName : string;
begin
  fn := Common.Path.MODEL + fName + '.mcf';
  modelF := TIniFile.Create(fn);
  try
    with modelF do begin
      try
      //-----------------------------
      with FileModelInfo do begin
      //SetResolution(nCh, H_Active, V_Active); //TBD:A2CHv3?
        //
        WriteInteger('MODEL_DATA', 'Signal_Type',  	  		SigType);
        WriteInteger('MODEL_DATA', 'Rotate',  	      		Rotate);				
        WriteInteger('MODEL_DATA', 'Bit',  	          		Bit);
        WriteInteger('MODEL_DATA', 'Pixel_Type',  	  		PixelType);
	      WriteInteger('MODEL_DATA', 'WP',  	      		    WP);        //TBD:MERGE? FOldPOCB(O) AutoPOCB(X)
        WriteInteger('MODEL_DATA', 'I2C_PullUp',  	      I2cPullup); //TBD:MERGE? FOldPOCB(O) AutoPOCB(X)

        WriteInteger('MODEL_DATA', 'Freq',  				 			Freq);
        WriteInteger('MODEL_DATA', 'H_Total',     	 			H_Total);
        WriteInteger('MODEL_DATA', 'H_Active',     	 			H_Active);
        WriteInteger('MODEL_DATA', 'H_BPo', 					 		H_BP);
        WriteInteger('MODEL_DATA', 'H_Width',    		 			H_Width);
        WriteInteger('MODEL_DATA', 'V_Total',     	 			V_Total);
        WriteInteger('MODEL_DATA', 'V_Active',			 			V_Active);
        WriteInteger('MODEL_DATA', 'V_BPo',  				 			V_BP);
        WriteInteger('MODEL_DATA', 'V_Width', 			 			V_Width);
        //
        WriteInteger('MODEL_DATA', 'Sequence',  		 			Sequence);
        //
        WriteInteger('MODEL_DATA', 'I2cFreq',  		 				I2cFreq);
        WriteInteger('MODEL_DATA', 'ClockDelay', 			 		ClockDelay);
        WriteInteger('MODEL_DATA', 'DataLineOut', 			 	DataLineOut);
        WriteInteger('MODEL_DATA', 'OpenCheck', 			 	  OpenCheck); //2023-10-18 DP200|DP201
        WriteInteger('MODEL_DATA', 'ModelType', 			 	  ModelType); //2022-10-12

        for i := DefPG.PWR_VCC to DefPG.PWR_MAX do begin
          if i in [DefPG.PWR_VCC .. DefPG.PWR_VBR] then begin
            WriteInteger('FUSING_DATA_mVmA', Format('PWR_VOL_%d',[i]),   PWR_VOL[i]);
						WriteInteger('FUSING_DATA_mVmA', Format('PWR_OFFSET_%d',[i]),PWR_OFFSET[i]);  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
					end;
          WriteInteger('FUSING_DATA_mVmA', Format('PWR_LIMIT_H_%d',[i]), PWR_LIMIT_H[i]);
          WriteInteger('FUSING_DATA_mVmA', Format('PWR_LIMIT_L_%d',[i]), PWR_LIMIT_L[i]);
        end;
        //2023-03-07 TBD:INI_FILE? (delete obsoleted Section/Key) ...start
				{
        if ValueExists('FUSING_DATA','PWR_VOL_0') then begin
          for i := DefPG.PWR_VCC to DefPG.PWR_MAX do begin
            if i in [DefPG.PWR_VCC .. DefPG.PWR_VBR] then begin
              DeleteKey('FUSING_DATA', Format('PWR_VOL_%d',[i]));
  						DeleteKey('FUSING_DATA', Format('PWR_OFFSET_%d',[i]));
  					end;
            DeleteKey('FUSING_DATA', Format('PWR_LIMIT_H_%d',[i]));
            DeleteKey('FUSING_DATA', Format('PWR_LIMIT_L_%d',[i]));
          end;
        end;
				}
        //2023-03-07 TBD:INI_FILE? (delete obsoleted Section/Key) ...end

        // Power Sequence
        //  -
        for i := 0 to 3 do begin
          WriteInteger('FUSING_DATA', Format('PWR_ON_SEQ_%d',[i]),  PowerOnSeq[i]);
          WriteInteger('FUSING_DATA', Format('PWR_OFF_SEQ_%d',[i]), PowerOffSeq[i]);
        end;
        //  - Ext Power Sequence
        if Common.SystemInfo.PG_TYPE <> DefPG.PG_TYPE_DP489 then begin
          WriteBool   ('EXT_POWER_SEQUENCE', 'PwrSeqExtUse',      PwrSeqExtUse);
          WriteInteger('EXT_POWER_SEQUENCE', 'PwrSeqExtAvailCnt', PwrSeqExtAvailCnt);
          for i := 0 to 5 do begin
            WriteInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOnIdx%d', [i]), PwrSeqExtOnIdx[i]);
            WriteInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOffIdx%d',[i]), PwrSeqExtOffIdx[i]);
          end;
          for i := 0 to 4 do begin
            WriteInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOnDelay%d', [i]), PwrSeqExtOnDelay[i]);
            WriteInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOffDelay%d',[i]), PwrSeqExtOffDelay[i]);
          end;
        end;

        //
        WriteString('MODEL_INFO','Pattern_Group',PatGrpName);
      end; // with EdModelInfo[nCh] do begin

      //-----------------------------

      with FileModelInfo2 do begin
        //	- Model Parameters : PG/SPI Version  //2019-04-19 ALARM:FW_VERSION_MISMATCH
        WriteString('MODEL_DATA', 'PG_FW_VER',  	  		PgFwVer);
        WriteString('MODEL_DATA', 'SPI_FW_VER',  	  		SpiFwVer);

        WriteInteger('MODEL_DATA', 'PowerOnPatNum',    PowerOnPatNum);    //2021-11-22 A2CHv4:LUCID
        WriteInteger('MODEL_DATA', 'PwrMeasurePatNum', PwrMeasurePatNum); //2022-09-06 POWER_MEASURE_PAT
        WriteInteger('MODEL_DATA', 'VerifyPatNum',     VerifyPatNum);

        WriteInteger('MODEL_DATA', 'BCR_LENGTH',    BcrLength);
        WriteInteger('MODEL_DATA', 'BcrPidChkIdx',  BcrPidChkIdx);  //A2CHv3:BCR_PID_CHECK
        WriteString ('MODEL_DATA', 'BcrPidChkStr',  BcrPidChkStr);  //A2CHv3:BCR_PID_CHECK
				{$IFDEF FEATURE_BCR_SCAN_SPCB}
        WriteBool   ('MODEL_DATA', 'BcrScanMesSPCB',    BcrScanMesSPCB);     //A2CHv4:LUCID:ScanSPCB
        WriteBool   ('MODEL_DATA', 'BcrSPCBIdInterlock',BcrSPCBIdInterlock); //A2CHv4:LUCID:ScanSPCB //2023-05-19 LGDVH:#302:SPCB_ID_INTERLOCK
				{$ENDIF}
        {$IFDEF FEATURE_BCR_PID_INTERLOCK}
        WriteBool   ('MODEL_DATA', 'BcrPIDInterlock', BcrPIDInterlock); //2023-09-26 LGDVH:#301:BCR_PID_INTERLOCK //2023-10-10 LENSVN:ATO:BCR_PID_INTERLOCK
        {$ENDIF}

        // Write [ASSY_POCB_DATA] !!!
      //if Common.SystemInfo.UseAssyPOCB then begin
          WriteBool   ('ASSY_POCB_DATA', 'AssyPocbUseCh1', AssyModelInfo.UseCh1);
          WriteBool   ('ASSY_POCB_DATA', 'AssyPocbUseCh2', AssyModelInfo.UseCh2);
          WriteInteger('ASSY_POCB_DATA', 'AssyPocbLcmPosCh1', Integer(AssyModelInfo.LcmPosCh1));
          WriteInteger('ASSY_POCB_DATA', 'AssyPocbLcmPosCh2', Integer(AssyModelInfo.LcmPosCh2));
          WriteBool   ('ASSY_POCB_DATA', 'UseMainPidCh1',  AssyModelInfo.UseMainPidCh1);
          WriteBool   ('ASSY_POCB_DATA', 'UseMainPidCh2',  AssyModelInfo.UseMainPidCh2);
      //end;


        // Motion (CH1/CH2)
        {$IFDEF HAS_MOTION_CAM_Z}
        WriteFloat('MODEL_DATA', 'CAM1_Z_MODEL_POS', 	CamZModelPosCh1); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteFloat('MODEL_DATA', 'CAM2_Z_MODEL_POS', 	CamZModelPosCh2); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        {$ENDIF}
        WriteFloat('MODEL_DATA', 'CAM1_Y_CAM_POS', 		CamYCamPosCh1);   //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteFloat('MODEL_DATA', 'CAM1_Y_LOAD_POS', 	CamYLoadPosCh1);  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteFloat('MODEL_DATA', 'CAM2_Y_CAM_POS', 		CamYCamPosCh2);   //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteFloat('MODEL_DATA', 'CAM2_Y_LOAD_POS', 	CamYLoadPosCh2);  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        // Robot (CH1/CH2)
        {$IFDEF HAS_ROBOT_CAM_Z}
        WriteString('ROBOT_DATA', 'Robot1Coord_X',  FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.X));  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot1Coord_Y',  FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.Y));  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot1Coord_Z',  FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.Z));  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot1Coord_Rx', FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.Rx)); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot1Coord_Ry', FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.Ry)); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot1Coord_Rz', FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.Rz)); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot1ModelCmd', RobotModelInfoCh1.ModelCmd);                                 //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot2Coord_X',  FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.X));  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot2Coord_Y',  FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.Y));  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot2Coord_Z',  FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.Z));  //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot2Coord_Rx', FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.Rx)); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot2Coord_Ry', FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.Ry)); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot2Coord_Rz', FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.Rz)); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        WriteString('ROBOT_DATA', 'Robot2ModelCmd', RobotModelInfoCh2.ModelCmd);                                 //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
        {$ENDIF}

        {$IFDEF PANEL_AUTO}
        WriteInteger('MODEL_DATA', 'PWR_OFFON_DELAY',  		PwrOnDelayMsec); //for Backward-compatability
        {$ENDIF}
        WriteInteger('MODEL_DATA', 'PwrOnDelayMsec',  	 	PwrOnDelayMsec);
        WriteInteger('MODEL_DATA', 'PwrOffDelayMsec',  	 	PwrOffDelayMsec);
        {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
        WriteInteger('MODEL_DATA', 'PowerOnAgingSec',  	 	PowerOnAgingSec);
        {$ENDIF}

        WriteInteger('MODEL_DATA', 'JUDGE_CNT', 	   			JudgeCount);
        WriteBool   ('MODEL_DATA', 'UseExLightFlow',      UseExLightFlow);

        WriteBool   ('MODEL_DATA', 'USE_CUSTOM_NAME',     UseCustumPatName);
        WriteBool   ('MODEL_DATA', 'USE_VACUUM',          UseVacuum);   //2019-06-24
        WriteBool   ('MODEL_DATA', 'USE_IONIZER_ON_OFF',  UseIonOnOff); //2019-09-26 Ionizer On/Off

        WriteInteger('MODEL_DATA', 'CAMERA_TEND_WAIT_MIN',CamTEndWait);   //2019-05-22
        {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
        WriteInteger('MODEL_DATA', 'CamCBCount',          CamCBCount);
        WriteBool   ('MODEL_DATA', 'UsePowerResetAfterEepromCBParaWrite', UsePowerResetAfterEepromCBParaWrite);
  			{$ENDIF}
        {$IFDEF HAS_DIO_PINBLOCK}
        WriteBool   ('MODEL_DATA', 'UseCheckPinblock',    UseCheckPinblock);
  			{$ENDIF}

      //{$IFDEF PANEL_AUTO}
        WriteBool   ('MODEL_DATA', 'USE_SCANFISRT',       UseScanFirst);
  		//{$ENDIF}

        for i := 0 to DefPocb.UNIFORMITY_PATTERN_MAX do begin
          sTemp := TernaryOp(i=0,'',(i+1).ToString);
          WriteFloat  ('MODEL_DATA', 'WHITE_UNIFOM'+sTemp,WhiteUniform[i]);
          WriteInteger('MODEL_DATA', 'COMPARED_PAT'+sTemp,ComparedPat[i]);
          WriteString('MODEL_DATA',  Format('COMPARED_PAT%d_NAME',[i+1]),  	ComparePatName[i]);
        end;
        {$IFDEF FEATURE_UNIFORMITY_PUCONOFF}
        WriteBool   ('MODEL_DATA', 'UsePucOnOff',         UsePucOnOff); //2022-07-15 UNIFORMITY_PUCONOFF
        {$ENDIF}
        {$IFDEF FEATURE_PUC_IMAGE}
        WriteBool   ('MODEL_DATA', 'UsePucImage',         UsePucImage); //2023-04-07 FEATURE_PUC_IMAGE
        {$ENDIF}
        WriteInteger('MODEL_DATA', 'BmpDownRetryCnt', 		BmpDownRetryCnt);

        WriteBool   ('MODEL_DATA', 'ENABLE_PWR_OPT_MODE',       EnablePwrMode);
        WriteBool   ('MODEL_DATA', 'ENABLE_PROCESS_MASKING',    EnableProcMask);
        WriteBool   ('MODEL_DATA', 'ENABLE_FLASH_WRITE_CBDATA', EnableFlashWriteCBData); //USE_MODEL_PARAM_CSV

        {$IFDEF PANEL_FOLD}
        //  - PWM
        WriteInteger('MODEL_DATA', 'PWMDuty',  		 				EdModelInfo.Pwm_duty);
        WriteInteger('MODEL_DATA', 'PWMFreq',  		 				EdModelInfo.Pwm_freq);
        WriteBool   ('MODEL_DATA', 'UsePwm',              EdModelInfo.UsePwm)
				{$ENDIF}

        // DFS Options
        WriteString('MODEL_INFO', 'COMBI_MODEL_INFO_KEY', CombiModelInfoKey); //2021-11-XX A2CHv4
        // Log Upload Options
        WriteString('MODEL_INFO', 'LogUploadPanelModel', LogUploadPanelModel); //2022-07-25 LOG_UPLOAD
      end; // with EdModelInfo2[nCh] do begin
      //----------------------------------

      //DP200 ---------------------------------------------------------------- start
    	  if Common.SystemInfo.PG_TYPE <> DefPG.PG_TYPE_DP489 then begin  //DP200|DP201
          with FileModelInfoALDP do begin
            WriteInteger('ALDP_MODEL_DATA', 'SPI_PULLUP', SPI_PULLUP);
            WriteInteger('ALDP_MODEL_DATA', 'SPI_SPEED',  SPI_SPEED);
            WriteInteger('ALDP_MODEL_DATA', 'SPI_MODE',   SPI_MODE);
            WriteInteger('ALDP_MODEL_DATA', 'SPI_LEVEL',  SPI_LEVEL);
            WriteInteger('ALDP_MODEL_DATA', 'I2C_LEVEL',  I2C_LEVEL);
            //
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_LINK_RATE', ALPDP_LINK_RATE);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_H_FDP',  	 ALPDP_H_FDP);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_H_SDP',  	 ALPDP_H_SDP);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_H_PCNT',  	 ALPDP_H_PCNT);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_VB_SLEEP',  ALPDP_VB_SLEEP);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N2',  	 ALPDP_VB_N2);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N3',  	 ALPDP_VB_N3);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N4',  	 ALPDP_VB_N4);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N5B',  	 ALPDP_VB_N5B);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N7',  	 ALPDP_VB_N7);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N5A',    ALPDP_VB_N5A);
            //
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_MVID',  	   ALPDP_MSA_MVID);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_NVID',  	   ALPDP_MSA_NVID);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HTOTAL',  	 ALPDP_MSA_HTOTAL);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HSTART',  	 ALPDP_MSA_HSTART);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HWIDTH',  	 ALPDP_MSA_HWIDTH);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VTOTAL',  	 ALPDP_MSA_VTOTAL);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VSTART',  	 ALPDP_MSA_VSTART);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VHEIGHT',   ALPDP_MSA_VHEIGHT);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HSP_HSW',   ALPDP_MSA_HSP_HSW);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VSP_VSW',   ALPDP_MSA_VSP_VSW);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_MISC0',  	 ALPDP_MSA_MISC0);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_MISC1',  	 ALPDP_MSA_MISC1);
            //
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_SPECIAL_PANEL', ALPDP_SPECIAL_PANEL);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_ALPM',  	       ALPDP_ALPM);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_LINK_MODE',  	 ALPDP_LINK_MODE);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_CHOP_SIZE',  	 ALPDP_CHOP_SIZE);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_CHOP_SECTION',  ALPDP_CHOP_SECTION);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_CHOP_ENABLE',   ALPDP_CHOP_ENABLE);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_HPD_CHECK',  	 ALPDP_HPD_CHECK);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_SCRAMBLE_SET',  ALPDP_SCRAMBLE_SET);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_LANE_SETTING',  ALPDP_LANE_SETTING);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_SLAVE_ENABLE',  ALPDP_SLAVE_ENABLE);
            //
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_SWING_LEVEL',       ALPDP_SWING_LEVEL);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_PRE_EMPHASIS_PRE',  ALPDP_PRE_EMPHASIS_PRE);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_PRE_EMPHASIS_POST', ALPDP_PRE_EMPHASIS_POST);
            WriteInteger('ALDP_MODEL_DATA', 'ALPDP_AUX_FREQ_SET',      ALPDP_AUX_FREQ_SET);
            //
            WriteInteger('ALDP_MODEL_DATA', 'DP141_IF_SET',  DP141_IF_SET);
            WriteInteger('ALDP_MODEL_DATA', 'DP141_CNT_SET', DP141_CNT_SET);
            WriteInteger('ALDP_MODEL_DATA', 'EDID_SKIP',     EDID_SKIP);
            WriteInteger('ALDP_MODEL_DATA', 'DEBUG_LEVEL',   DEBUG_LEVEL);
            WriteInteger('ALDP_MODEL_DATA', 'eDP_SPEC_OPT',  eDP_SPEC_OPT); //2023-03-24 Tributo
          end;
        end;
        //DP200 ---------------------------------------------------------------- end
				
      except
        ShowMessage(fn + ' store was failed!!');
      end;
    end;
  finally
    modelF.Free;
  end;
{$IFDEF REF_ISPD_DFS}
  modelF.UpdateFile;
{$ENDIF}
  WritePrivateProfileString(nil, nil, nil, PChar(fn));  //2019-05-11
  //2019-05-11 Backup(Model.mcf)
  sBackupPath := Common.Path.MODEL+'backup_model';
  Common.CheckMakeDir(sBackupPath);
  if System.SysUtils.FileExists(fn) then begin
    sBackupFullName := sBackupPath + '\' + fName + '_' + FormatDateTime('yyyymmdd_hhnnss',Now) + '.mcf';
    CopyFile(PChar(fn), PChar(sBackupFullName), False);
  end;
end;

//******************************************************************************
// procedure/function: Pattern Information
//    - btnPatternInfoSaveClick(Sender: TObject)  //
//    - btnPatGrpNewClick(Sender: TObject)        //
//    - btnPatGrpCopyClick(Sender: TObject)
//    - btnPatGrpRenameClick(Sender: TObject)
//    - btnPatGrpDeleteClick(Sender: TObject)
//    - lstbxPatGrpListClick(Sender: TObject)
//    - btnPatternAddClick(Sender: TObject)       //
//    - btnPatternDelClick(Sender: TObject)
//    - btnPatternModifyClick(Sender: TObject)
//    - btnPatternDownClick(Sender: TObject)
//    - btnPatternUpClick(Sender: TObject)
//    - btnPatternEditClick(Sender: TObject)
//    - cmbxPatInfoTypeChange(Sender: TObject)
//    - gridPatInfoListClick(Sender: TObject)
//******************************************************************************

procedure TfrmModelInfo.btnPatternInfoSaveClick(Sender: TObject);
var
  sOldName, sNewName, sPatGrpName : string;
  i : Integer;
  SavePatGrp : TPatternGroup;
begin
	//
  if Trim(edPatGrpName.Text) = '' then begin
    MessageDlg(#13#10 + 'Input Error! Please Insert the Pattern Group name.', mtError, [mbOK], 0);
    edModelName.SetFocus;
    Exit;
  end;

  if m_bNewPatGr or m_bRenPatGr or m_bCopyPatGr then begin
    sPatGrpName := Common.GetFilePath(Trim(edPatGrpName.Text), DefPocb.PATH_TYPE_PATGRP);
    if FileExists(sPatGrpName) then begin
      MessageDlg(#13#10 + 'Input Error! Pattern Group Name [' + Trim(edPatGrpName.Text) + '] is already Exist!', mtError, [mbOk], 0);
      lstbxPatGrpList.SelectAll;
      lstbxPatGrpList.SetFocus;
      Exit;
    end;

    if m_bCopyPatGr then begin   // Add to list if new model
      sOldName := lstbxPatGrpList.Items.Strings[lstbxPatGrpList.ItemIndex];
      sNewName := Trim(edPatGrpName.Text);
      // No save if already exist
      for i := 0 to Pred(lstbxPatGrpList.Items.Count) do begin
        if lstbxPatGrpList.Items.Strings[i] = sNewName then begin
          MessageDlg(#13#10 + 'Input Error! Pattern Group Name [' + Trim(edPatGrpName.Text) + '] is already Exist!', mtError, [mbOk], 0);
          Exit;
        end;
      end;
      CopyFile(PChar(Common.Path.Model + sOldName + '.grp'), PChar(Common.Path.MODEL + sNewName + '.grp'), False);
    end;
  end;

  if m_bRenPatGr then begin
    sOldName := lstbxPatGrpList.Items.Strings[lstbxPatGrpList.ItemIndex];
    sNewName := Trim(edPatGrpName.Text);
    if not RenameFile(Common.GetFilePath(sOldName, DefPocb.PATH_TYPE_PATGRP), Common.GetFilePath(sNewName, DefPocb.PATH_TYPE_PATGRP)) then begin
      edPatGrpName.SelectAll;
      edPatGrpName.SetFocus;
      Exit;
    end;
  end;

  if m_bNewPatGr or m_bCopyPatGr then begin  // Add to list if new model
    AddAndFindItemToListbox(lstbxPatGrpList, edPatGrpName.text, True, True);
  end;

  if m_bRenPatGr then begin
    lstbxPatGrpList.Sorted := False;
    lstbxPatGrpList.Items.Strings[lstbxPatGrpList.ItemIndex] := sNewName;
    lstbxPatGrpList.Sorted := True;
    AddAndFindItemToListbox(lstbxPatGrpList, sNewName, False, True);
  end;

  // Save to Buffer
  SavePatGrp.GroupName  := Trim(edPatGrpName.Text);
  SavePatGrp.PatCount   := StrToIntDef(edPatGrpPatCnt.Text,0);
  if SavePatGrp.PatCount > 0 then begin
    SetLength(SavePatGrp.PatType,SavePatGrp.PatCount);
    SetLength(SavePatGrp.PatName,SavePatGrp.PatCount);		
    SetLength(SavePatGrp.VSync,SavePatGrp.PatCount);
    SetLength(SavePatGrp.LockTime,SavePatGrp.PatCount);
		{$IFDEF FEATURE_DISPLAY_PWM}
  	SetLength(SavePatGrp.Dimming,SavePatGrp.PatCount);
		{$ENDIF}
    SetLength(SavePatGrp.Option,SavePatGrp.PatCount);

    for i := 0 to Pred(SavePatGrp.PatCount) do begin
      if gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE, i] = 'Pattern' then SavePatGrp.PatType[i] := DefPG.PTYPE_NORMAL
      else                                                                SavePatGrp.PatType[i] := DefPG.PTYPE_BITMAP;
      SavePatGrp.PatName[i]  := trim(gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, i]);
      if gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, i] = 'None' then  SavePatGrp.VSync[i] := 0
      else                                                               SavePatGrp.VSync[i] := StrToIntDef(gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, i],0);
      SavePatGrp.LockTime[i] := StrToIntDef(gridPatInfoList.Cells[GRID_PATLIST_COL_TIME, i],0);
			{$IFDEF FEATURE_DISPLAY_PWM}
    	SavePatGrp.Dimming[i]  := StrToIntDef(gridPatInfoList.Cells[GRID_PATLIST_COL_PWM, i],0);
			{$ENDIF}
    end;
  end;
  Common.SavePatGroup(Trim(edPatGrpName.Text),SavePatGrp);
  // Display after save
  if m_bNewPatGr or m_bCopyPatGr or m_bRenPatGr then begin
    lstbxPatGrpListClick(nil);
  end;
  Common.m_bNeedInitial := True;  //TBD?
  MessageDlg(#13#10 + 'Pattern List Information File Saving OK!', mtInformation, [mbOk], 0);
end;

procedure TfrmModelInfo.btnPatGrpNewClick(Sender: TObject);
begin
  edPatGrpName.ReadOnly := False;
  edPatGrpName.Text := '';
  edPatGrpName.SetFocus;
  m_bNewPatGr := True;
end;

procedure TfrmModelInfo.btnPatGrpCopyClick(Sender: TObject);
begin
  edPatGrpName.ReadOnly := False;
  edPatGrpName.SetFocus;
  m_bCopyPatGr := True;
end;

procedure TfrmModelInfo.btnPatGrpRenameClick(Sender: TObject);
begin
  edPatGrpName.ReadOnly := False;
  edPatGrpName.SetFocus;
  m_bRenPatGr := True;
end;

procedure TfrmModelInfo.btnPatGrpDeleteClick(Sender: TObject);
var
  idx : Integer;
begin
  if lstbxPatGrpList.ItemIndex < 0 then Exit;

  if MessageDlg(#13#10 + 'Are you sure to DELETE this Pattern Group?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    idx := lstbxPatGrpList.ItemIndex;
    if idx > -1 then begin
      DeleteFile(Common.GetFilePath(lstbxPatGrpList.Items.Strings[idx], DefPocb.PATH_TYPE_PATGRP));
      lstbxPatGrpList.Items.Delete(idx);
      lstbxPatGrpList.ItemIndex := idx - 1;
      if (lstbxPatGrpList.ItemIndex = -1) and (lstbxPatGrpList.Items.Count > 0) then
        lstbxPatGrpList.ItemIndex := 0;
      lstbxPatGrpListClick(nil);
    end;
  end;
end;

procedure TfrmModelInfo.lstbxPatGrpListClick(Sender: TObject);
var
  idx : Integer;
begin
  edPatGrpName.ReadOnly := True;
  m_bNewPatGr   := False;
  m_bRenPatGr   := False;
  m_bCopyPatGr  := False;

  idx := lstbxPatGrpList.ItemIndex;
  if idx > -1 then begin
    EditPatGrp :=  Common.LoadPatGroup(lstbxPatGrpList.Items.Strings[idx]);
//    Common.read_pattern_data(rzlstbxPatGrpList.Items.Strings[idx]);
    Display_PatGroup_data(EditPatGrp);
    if gridPatInfoList.RowCount > 0 then gridPatInfoList.Row := 0;
    gridPatInfoList.OnClick(nil);
  end;
end;

//==============================================================================

procedure TfrmModelInfo.btnPatternAddClick(Sender: TObject);
var
  idx : Integer;
begin
  if cmbxPatInfoType.Text = '' then begin
    MessageDlg(#13#10 + 'Input Error! Pattern Type is Empty.', mtError, [mbOK], 0);
    cmbxPatInfoType.SetFocus;
    Exit;
  end;

  if cmbxPatInfoName.Text = '' then begin
    MessageDlg(#13#10 + 'Input Error! Pattern Name is Empty.', mtError, [mbOK], 0);
    cmbxPatInfoName.SetFocus;
    Exit;
  end;

  if cbPatInfoVSync.Checked then begin
    if (StrToIntDef((edPatInfoVSync.Text),0) < 20) or (StrToIntDef(edPatInfoVSync.Text,200) > 180) then begin
      MessageDlg(#13#10 + 'Input Error! Vertical Frequency Range : [20 ~ 180 Hz].', mtError, [mbOK], 0);
      edPatInfoVSync.SelectAll;
      edPatInfoVSync.SetFocus;
      Exit;
    end;
  end;

  if cbPatInfoTime.Checked then begin
    if (StrToIntDef(edPatInfoTime.Text,-1) < 0) or (StrToIntDef(edPatInfoTime.Text,100) > 60) then begin
      MessageDlg(#13#10 + 'Input Error! Pattern Display Time Range : [0 ~ 60 Sec].', mtError, [mbOK], 0);
      edPatInfoTime.SelectAll;
      edPatInfoTime.SetFocus;
      Exit;
    end;
  end;

  {$IFDEF FEATURE_DISPLAY_PWM}
  if cbPatInfoDimming.Checked then begin
    if (StrToIntDef(edPatInfoDimming.Text,-1) < 0) or (StrToIntDef(edPatInfoDimming.Text,100) > 100) then begin
      MessageDlg(#13#10 + 'Input Error! Pattern Display Dimming Range : [1 ~ 100 %].', mtError, [mbOK], 0);
      edPatInfoDimming.SelectAll;
      edPatInfoDimming.SetFocus;
      Exit;
    end;
  end;
	{$ENDIF}

  if gridPatInfoList.RowCount = 1 then begin
    if gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE, 0] = '' then begin
      idx := 0;
    end
    else begin
      gridPatInfoList.RowCount := 2;
      idx := 1;
    end;
  end
  else begin
    gridPatInfoList.RowCount := gridPatInfoList.RowCount + 1;
    idx := gridPatInfoList.RowCount - 1;
  end;

  gridPatInfoList.Cells[GRID_PATLIST_COL_IDX,  idx] := Format('%d',[idx]); //2022-11-12
  gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE, idx] := cmbxPatInfoType.Text;
  gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx] := cmbxPatInfoName.Text;
  if cbPatInfoVSync.Checked then  gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx] := edPatInfoVSync.Text
  else                            gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx] := 'None';

  if cbPatInfoTime.Checked then gridPatInfoList.Cells[GRID_PATLIST_COL_TIME, idx] := edPatInfoTime.Text
  else                          gridPatInfoList.Cells[GRID_PATLIST_COL_TIME, idx] := '0';

  {$IFDEF FEATURE_DISPLAY_PWM}
	if cbPatInfoDimming.Checked then gridPatInfoList.Cells[GRID_PATLIST_COL_PWM, idx] := edPatInfoDimming.Text
	else                             gridPatInfoList.Cells[GRID_PATLIST_COL_PWM, idx] := '0';
	{$ENDIF}

  gridPatInfoList.Row := idx;
  edPatGrpPatCnt.Text := IntToStr(gridPatInfoList.RowCount);
  PatInfoBtnControl;
end;

procedure TfrmModelInfo.btnPatternDelClick(Sender: TObject);
var
  idx, i : Integer;
begin
  idx := gridPatInfoList.Row;

  gridPatInfoList.Rows[idx].Clear;

  if idx < gridPatInfoList.RowCount - 1 then begin
    for i := gridPatInfoList.Row to gridPatInfoList.RowCount - 2 do begin
      gridPatInfoList.Cells[GRID_PATLIST_COL_IDX,  i] := Format('%d',[i]); //2022-11-12
      gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE, i] := gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE, i+1];
      gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME,i] := gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME,i+1];
      gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC,i] := gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC,i+1];
      gridPatInfoList.Cells[GRID_PATLIST_COL_TIME, i] := gridPatInfoList.Cells[GRID_PATLIST_COL_TIME, i+1];
		  {$IFDEF FEATURE_DISPLAY_PWM}
    	gridPatInfoList.Cells[GRID_PATLIST_COL_PWM,  i] := gridPatInfoList.Cells[GRID_PATLIST_COL_PWM4, i+1];
			{$ENDIF}
    end;
  end;

  gridPatInfoList.RowCount := gridPatInfoList.RowCount - 1;
  gridPatInfoListClick(nil);

  if gridPatInfoList.RowCount = 1 then begin
    if gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE, 0] = '' then
      edPatGrpPatCnt.Text := '0'
    else
      edPatGrpPatCnt.Text := '1';
  end
  else
    edPatGrpPatCnt.Text := IntToStr(gridPatInfoList.RowCount);

  PatInfoBtnControl;
end;

procedure TfrmModelInfo.btnPatternModifyClick(Sender: TObject);
var
  idx : Integer;
begin
  if cmbxPatInfoType.Text = '' then begin
    MessageDlg(#13#10 + 'Input Error! Pattern Type is Empty.', mtError, [mbOK], 0);
    cmbxPatInfoType.SetFocus;
    Exit;
  end;

  if cmbxPatInfoName.Text = '' then begin
    MessageDlg(#13#10 + 'Input Error! Pattern Name is Empty.', mtError, [mbOK], 0);
    cmbxPatInfoName.SetFocus;
    Exit;
  end;

  if cbPatInfoVSync.Checked then begin
    if (StrToIntDef(edPatInfoVSync.Text,0) < 20) or (StrToIntDef(edPatInfoVSync.Text,200) > 180) then begin
      MessageDlg(#13#10 + 'Input Error! Vertical Frequency Range : [20 ~ 180 Hz].', mtError, [mbOK], 0);
      edPatInfoVSync.SelectAll;
      edPatInfoVSync.SetFocus;
      Exit;
    end;
  end;

  if cbPatInfoTime.Checked then begin
    if (StrToIntDef(edPatInfoTime.Text,-1) < 0) or (StrToIntDef(edPatInfoTime.Text,100) > 60) then begin
      MessageDlg(#13#10 + 'Input Error! Pattern Display Time Range : [0 ~ 60 Sec].', mtError, [mbOK], 0);
      edPatInfoTime.SelectAll;
      edPatInfoTime.SetFocus;
      Exit;
    end;
  end;
	
	{$IFDEF FEATURE_PATTERN_PWM}
	if cbPatInfoDimming.Checked then begin
	  if (StrToIntDef(edPatInfoDimming.Text,-1) < 0) or (StrToIntDef(edPatInfoDimming.Text,100) > 100) then begin
	    MessageDlg(#13#10 + 'Input Error! Pattern Display Dimming Range : [1 ~ 100 %].', mtError, [mbOK], 0);
	    edPatInfoDimming.SelectAll;
	    edPatInfoDimming.SetFocus;
	    Exit;
	  end;
	end;
	{$ENDIF}
	
  idx := gridPatInfoList.Row;
  gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE,  idx] := cmbxPatInfoType.Text;
  gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx] := cmbxPatInfoName.Text;
  if cbPatInfoVSync.Checked then gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx] := edPatInfoVSync.Text
  else                           gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx] := 'None';
  if cbPatInfoTime.Checked then  gridPatInfoList.Cells[GRID_PATLIST_COL_TIME,  idx] := edPatInfoTime.Text
  else                           gridPatInfoList.Cells[GRID_PATLIST_COL_TIME,  idx] := '0';
	{$IFDEF FEATURE_PATTERN_PWM}
	if cbPatInfoDimming.Checked then gridPatInfoList.Cells[GRID_PATLIST_COL_PWM, idx] := edPatInfoDimming.Text
	else                             gridPatInfoList.Cells[GRID_PATLIST_COL_PWM, idx] := '0';	
	{$ENDIF}
end;

procedure TfrmModelInfo.btnPatternDownClick(Sender: TObject);
var
  idx : Integer;
  sTempType, sTempName, sTempVSync, sTempTime : String;
	{$IFDEF FEATURE_PATTERN_PWM}
  sTempDimming : String;	
	{$ENDIF}
begin
  idx := gridPatInfoList.Row;

  if idx > gridPatInfoList.RowCount - 2 then Exit;

  sTempType   := gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE, idx];
  sTempName   := gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx];
  sTempVSync  := gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx];
  sTempTime   := gridPatInfoList.Cells[GRID_PATLIST_COL_TIME, idx];
	{$IFDEF FEATURE_PATTERN_PWM}
  sTempDimming:= gridPatInfoList.Cells[GRID_PATLIST_COL_PWM, idx]; //TBD:PATTERN_PWM
	{$ENDIF}
  gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE,  idx] := gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE,  idx + 1];
  gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx] := gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx + 1];
  gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx] := gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx + 1];
  gridPatInfoList.Cells[GRID_PATLIST_COL_TIME,  idx] := gridPatInfoList.Cells[GRID_PATLIST_COL_TIME,  idx + 1];
	{$IFDEF FEATURE_PATTERN_PWM}
	gridPatInfoList.Cells[GRID_PATLIST_COL_PWM,   idx] := gridPatInfoList.Cells[GRID_PATLIST_COL_PWM,   idx + 1]; //TBD:PATTERN_PWM
	{$ENDIF}
  gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE,  idx + 1] := sTempType;
  gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx + 1] := sTempName;
  gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx + 1] := sTempVSync;
  gridPatInfoList.Cells[GRID_PATLIST_COL_TIME,  idx + 1] := sTempTime;
	{$IFDEF FEATURE_PATTERN_PWM}
	gridPatInfoList.Cells[GRID_PATLIST_COL_PWM,   idx + 1] := sTempDimming; //TBD:PATTERN_PWM
	{$ENDIF}
  gridPatInfoList.Row := idx + 1;

  PatInfoBtnControl;
end;

procedure TfrmModelInfo.btnPatternUpClick(Sender: TObject);
var
  idx : Integer;
  sTempType, sTempName, sTempVSync, sTempTime : String;
	{$IFDEF FEATURE_PATTERN_PWM}
  sTempDimming : String;	
	{$ENDIF}
begin
  idx := gridPatInfoList.Row;

  if idx < 1 then Exit;

  sTempType   := gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE,  idx];
  sTempName   := gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx];
  sTempVSync  := gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx];
  sTempTime   := gridPatInfoList.Cells[GRID_PATLIST_COL_TIME,  idx];
	{$IFDEF FEATURE_PATTERN_PWM}
	sTempDimming:= gridPatInfoList.Cells[GRID_PATLIST_COL_PWM,   idx]; //TBD:PATTERN_PWM
	{$ENDIF}

  gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE,  idx] := gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE,  idx - 1];
  gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx] := gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx - 1];
  gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx] := gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx - 1];
  gridPatInfoList.Cells[GRID_PATLIST_COL_TIME,  idx] := gridPatInfoList.Cells[GRID_PATLIST_COL_TIME,  idx - 1];
	{$IFDEF FEATURE_PATTERN_PWM}
	gridPatInfoList.Cells[GRID_PATLIST_COL_PWM,   idx] := gridPatInfoList.Cells[GRID_PATLIST_COL_PWM,   idx + 1]; //TBD:PATTERN_PWM
	{$ENDIF}

  gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE,  idx - 1] := sTempType;
  gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx - 1] := sTempName;
  gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx - 1] := sTempVSync;
  gridPatInfoList.Cells[GRID_PATLIST_COL_TIME,  idx - 1] := sTempTime;
	{$IFDEF FEATURE_PATTERN_PWM}
	gridPatInfoList.Cells[GRID_PATLIST_COL_PWM,   idx + 1] := sTempDimming; //TBD:PATTERN_PWM
	{$ENDIF}

  gridPatInfoList.Row := idx - 1;

  PatInfoBtnControl;
end;

procedure TfrmModelInfo.btnPatternEditClick(Sender: TObject);
begin
  frmExPat := TfrmExPat.Create(nil);
  try
    frmExPat.ShowModal;
  finally
    Freeandnil(frmExPat);
  end;
end;

{$IFDEF FEATURE_PATTERN_PWM}
procedure TfrmModelInfo.cbPatInfoDimmingClick(Sender: TObject);
begin
  if cbPatInfoDimming.Checked then
    edPatInfoDimming.Text := Format('%d',[100])
  else
    edPatInfoDimming.Text := Format('%d',[0])
end;
{$ENDIF}

procedure TfrmModelInfo.btnShowModelParamCsv(Sender: TObject); //USE_MODELPARAM_CSV
begin
  PagesModelInfos.ActivePage := pgModelParamCsv;
end;

procedure TfrmModelInfo.ShowComparePatNameGui(bValue: Boolean);
begin
  edPocbOptionComparePatName1.Visible := bValue;
  edPocbOptionComparePatName2.Visible := bValue;
  edPocbOptionComparePatName3.Visible := bValue;
  edPocbOptionComparePatName4.Visible := bValue;
  cmbxPocbOptionComparePat1.Visible := not bValue;
  cmbxPocbOptionComparePat2.Visible := not bValue;
  cmbxPocbOptionComparePat3.Visible := not bValue;
  cmbxPocbOptionComparePat4.Visible := not bValue;
end;

procedure TfrmModelInfo.ShowUsePucOnOffGui(bValue: Boolean); //2022-07-15 UNIFORMITY_PUCONOFF
begin
{$IFDEF PANEL_AUTO}
  RzPnlPocbOptionBmpDownRetryCnt.Visible := (not bValue);
  cmbxPocbOptionBmpDownRetryCnt.Visible  := (not bValue);
{$ENDIF}
	//
	if bvalue then begin //UsePucOnOff
		cbPocbOptionUseCustomName.Checked := True;
		cbPocbOptionUseCustomName.Enabled := False;
    ShowComparePatNameGui(cbPocbOptionUseCustomName.Checked);
  end
  else begin
		cbPocbOptionUseCustomName.Enabled := True;
	end;
end;

procedure TfrmModelInfo.cmbxDispModeSignalTypeChange(Sender: TObject); //TBD:MERGE:MODELINFO_PG? (DP200?,DP201?,DP489?)
begin
  case cmbxDispModeSignalType.ItemIndex of  //TBD:MERGE:MODELINFO_PG?
    DefPG.PG_MODELINFO_SIGTYPE_LVDS : begin // LVDS
      RzpnlDispModeWP.Caption := 'WP';
      cmbxDispModeWP.Items.Clear;
      cmbxDispModeWP.Items.Add('Low');
      cmbxDispModeWP.Items.Add('High');
      cmbxDispModeWP.ItemIndex := FileModelInfo.WP;
    end;
    DefPG.PG_MODELINFO_SIGTYPE_QUAD,
    DefPG.PG_MODELINFO_SIGTYPE_eDP4Lane,       // eDP 4Lane
    DefPG.PG_MODELINFO_SIGTYPE_eDP8Lane: begin
      RzpnlDispModeWP.Caption := 'FRS_Mode'; //TBD:MERGE:MODELINFO_PG? Fold(O) AUto(??)
      cmbxDispModeWP.Items.Clear;
      cmbxDispModeWP.Items.Add('x2');
      cmbxDispModeWP.Items.Add('x4');
      cmbxDispModeWP.ItemIndex := FileModelInfo.WP;
    end;
  end;
end;

procedure TfrmModelInfo.cmbxPatInfoTypeChange(Sender: TObject);
var
  Rslt, i: Integer;
  sFindFile, sPatName: string;
  SearchRec: TSearchRec;
begin
  if cmbxPatInfoType.Text = '' then begin
    cmbxPatInfoName.Items.Clear;
    Exit;
  end;

  cmbxPatInfoName.Sorted := False;
  cmbxPatInfoName.Items.Clear;

  if cmbxPatInfoType.ItemIndex = PTYPE_NORMAL then begin
    sFindFile := Common.Path.Pattern + '*.pat';
    for i :=0 to MAX_PATTERN_CNT -1 do begin
      if imgPatInfoPreview.InfoPat[i].pat.Info.isRegistered then begin
        sPatName := string(imgPatInfoPreview.InfoPat[i].pat.Data.PatName);
        cmbxPatInfoName.Items.Add(sPatName) ;
      end;
    end;
  end
  else if cmbxPatInfoType.ItemIndex = PTYPE_BITMAP then begin

      sFindFile := Common.Path.BMP + '*.bmp';
  end;

  Rslt := FindFirst(sFindFile, faAnyFile, SearchRec);
  cmbxPatInfoName.DisableAlign;
  while Rslt = 0 do  begin   // Add PatternName(s) in Pattern folder into ComboBox
    if Length(SearchRec.Name) > 4 then begin
      sPatName := SearchRec.Name;
      cmbxPatInfoName.Items.Add(sPatName);
    end;
    Rslt := FindNext(Searchrec);
  end;
  FindClose(SearchRec);
  cmbxPatInfoName.EnableAlign;
  cmbxPatInfoName.ItemIndex := 0;
end;

procedure TfrmModelInfo.gridPatInfoListClick(Sender: TObject);
var
  idx: Integer;
begin
  if gridPatInfoList.RowCount < 1 then
    Exit;

  idx := gridPatInfoList.Row;
  if AnsiCompareText(gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE, idx], 'Pattern') = 0 then
    cmbxPatInfoType.ItemIndex := PTYPE_NORMAL
  else if AnsiCompareText(gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE, idx], 'Bitmap') = 0 then
    cmbxPatInfoType.ItemIndex := PTYPE_BITMAP;
  cmbxPatInfoTypeChange(nil);
  cmbxPatInfoName.FindItem(gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx]);

  if (gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx] = '') or (gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx] = 'None') then begin
    edPatInfoVSync.Text := 'None';
    cbPatInfoVSync.Checked := False;
  end
  else begin
    edPatInfoVSync.Text := gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, idx];
    cbPatInfoVSync.Checked := True;
  end;

  if (gridPatInfoList.Cells[GRID_PATLIST_COL_TIME, idx] = '') or (gridPatInfoList.Cells[GRID_PATLIST_COL_TIME, idx] = '0') then begin
    edPatInfoTime.Text := '0';
    cbPatInfoTime.Checked := False;
  end
  else begin
    edPatInfoTime.Text := gridPatInfoList.Cells[GRID_PATLIST_COL_TIME, idx];
    cbPatInfoTime.Checked := True;
  end;

  {$IFDEF FEATURE_PATTERN_PWM}
	if (gridPatInfoList.Cells[GRID_PATLIST_COL_PWM, idx] = '') or (gridPatInfoList.Cells[GRID_PATLIST_COL_PWM, idx] = '0') then begin
	  edPatInfoDimming.Text := '0';
	  cbPatInfoDimming.Checked := False;
	end
	else begin
	  edPatInfoDimming.Text := gridPatInfoList.Cells[GRID_PATLIST_COL_PWM, idx];
	  cbPatInfoDimming.Checked := True;
	end;
	{$ENDIF}
	
  PatInfoBtnControl;

  imgPatInfoPreview.DrawPatAllPat(cmbxPatInfoType.ItemIndex, gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, idx]);
end;

procedure TfrmModelInfo.OnModelInfoAttrChanged(Sender: TObject);  //A2CHv3:MODELINFO:GUI
var
  nTemp    : Integer;
  bVisible : Boolean;
begin
  if not bModelInfoDispDone then Exit;
  //
  if Sender is TRzEdit then begin
    TRzEdit(Sender).Color := clLime
  end
  else if Sender is TRzNumericEdit then begin
    TRzNumericEdit(Sender).Color := clLime
  end
  else if Sender is TRzCheckBox then begin
		if Sender = cbPocbOptionModelCh1Use then begin
      cmbxCh1AssyLcmPos.Visible := cbPocbOptionModelCh1Use.Checked;
	    if cbPocbOptionModelCh1Use.Checked then begin
	      if FileModelInfo2.AssyModelInfo.LcmPosCh1 = LcmPosCenter then cmbxCh1AssyLcmPos.ItemIndex := 1  //Center
	      else                                                          cmbxCh1AssyLcmPos.ItemIndex := 0; //Left
	    end;
	  end
		else if Sender = cbPocbOptionModelCh2Use then begin
	    cmbxCh2AssyLcmPos.Visible := cbPocbOptionModelCh2Use.Checked;
	    if cbPocbOptionModelCh2Use.Checked then begin
	      if FileModelInfo2.AssyModelInfo.LcmPosCh2 = LcmPosCenter then cmbxCh2AssyLcmPos.ItemIndex := 1  //Center
	      else                                                          cmbxCh2AssyLcmPos.ItemIndex := 0; //Right
	    end;
	  end
		else if Sender = cbPwrSeqExtUse then begin
      RzgrpPwrSeqExt.Visible   := cbPwrSeqExtUse.Checked;
      RzGrpPwrSeqBasic.Visible := (not cbPwrSeqExtUse.Checked);
    {$IFDEF FEATURE_UNIFORMITY_PUCONOFF}
    end
		else if Sender = cbPocbOptionUsePucOnOff then begin //2022-07-15 UNIFORMITY_PUCONOFF
      ShowUsePucOnOffGui(cbPocbOptionUsePucOnOff.Checked);
    {$ENDIF}
    end
		else if Sender = cbPocbOptionUseCustomName then begin
      ShowComparePatNameGui(cbPocbOptionUseCustomName.Checked);
    end;
    TRzCheckBox(Sender).Font.Color := clBlue
  end
  else if Sender is TRzComboBox then begin
    if Sender = cmbxPwrSeqExtAvailCnt then begin
      nTemp := cmbxPwrSeqExtAvailCnt.ItemIndex;
      //
	    if nTemp > 0 then bVisible := True else bVisible := False;
	    cmbxPwrSeqExtOnIdx0.Visible := bVisible;
 	    cmbxPwrSeqExtOffIdx0.Visible := bVisible;
      //
	    if nTemp > 1 then bVisible := True else bVisible := False;
	    edPwrSeqExtOnDelay0.Visible  := bVisible; cmbxPwrSeqExtOnIdx1.Visible  := bVisible;
	    edPwrSeqExtOffDelay0.Visible := bVisible; cmbxPwrSeqExtOffIdx1.Visible := bVisible;
      //
	    if nTemp > 2 then bVisible := True else bVisible := False;
	    edPwrSeqExtOnDelay1.Visible  := bVisible; cmbxPwrSeqExtOnIdx2.Visible  := bVisible;
	    edPwrSeqExtOffDelay1.Visible := bVisible; cmbxPwrSeqExtOffIdx2.Visible := bVisible;
      //
	    if nTemp > 3 then bVisible := True else bVisible := False;
	    edPwrSeqExtOnDelay2.Visible  := bVisible; cmbxPwrSeqExtOnIdx3.Visible  := bVisible;
	    edPwrSeqExtOffDelay2.Visible := bVisible; cmbxPwrSeqExtOffIdx3.Visible := bVisible;
      //
	    if nTemp > 4 then bVisible := True else bVisible := False;
      edPwrSeqExtOnDelay3.Visible  := bVisible; cmbxPwrSeqExtOnIdx4.Visible  := bVisible;
      edPwrSeqExtOffDelay3.Visible := bVisible; cmbxPwrSeqExtOffIdx4.Visible := bVisible;
      //
	    if nTemp > 5 then bVisible := True else bVisible := False;
	    edPwrSeqExtOnDelay4.Visible  := bVisible; cmbxPwrSeqExtOnIdx5.Visible  := bVisible;
	    edPwrSeqExtOffDelay4.Visible := bVisible; cmbxPwrSeqExtOffIdx5.Visible := bVisible;
	  end;
    TRzComboBox(Sender).Color := clLime;
	end;
  //
  btnModelInfoSave.Enabled := True;
end;

//******************************************************************************
// procedure/function:
//******************************************************************************

procedure TfrmModelInfo.AddAndFindItemToCombobox(tCombo: TRzCombobox; sItem: string; bAdd, bFind: Boolean);
var
  i : Integer;
begin
  if bAdd then begin
    tCombo.Sorted := False;
    tCombo.Items.Add(sItem);
    tCombo.Sorted := True;
  end;

  if bFind then begin
    for i := 0 to tCombo.Items.Count - 1 do begin
      if tCombo.Items.Strings[i] = sItem then begin
        tCombo.ItemIndex := i;
        Break;
      end;
    end;
  end;
end;

procedure TfrmModelInfo.AddAndFindItemToListbox(tList: TRzListbox; sItem: string; bAdd, bFind: Boolean);
var
  i : Integer;
begin
  if bAdd then begin
    tList.Sorted := False;
    tList.Items.Add(sItem);
    tList.Sorted := True;
  end;

  if bFind then begin
    if sItem = '' then begin
      tList.ItemIndex := 0;
    end
    else begin
      for i := 0 to tList.Items.Count - 1 do begin
        if tList.Items.Strings[i] = sItem then begin
          tList.ItemIndex := i;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TfrmModelInfo.AddComparedData(nCh: Integer; DisplayPatGrp: TPatternGroup); //A2CHv3:MODELINFO:GUI
var
  i : Integer;
begin
  cmbxPocbOptionPowerOnPat.Clear;    //2021-11-24 Power On Pattern
  cmbxPocbOptionPwrMeasurePat.Clear; //2022-09-06 POWER_MEASURE_PAT
  cmbxPocbOptionVerifyPattern.Clear;    //2019-05-22

  cmbxPocbOptionComparePat1.Clear;
  cmbxPocbOptionComparePat2.Clear;
  cmbxPocbOptionComparePat3.Clear;  //2019-03-27
  cmbxPocbOptionComparePat4.Clear;  //2019-03-27

  if DisplayPatGrp.PatCount > 0 then begin
    for i := 0  to Pred(DisplayPatGrp.PatCount) do begin
      cmbxPocbOptionPowerOnPat.Items.Add(DisplayPatGrp.PatName[i]);    //2021-11-24 Power On Pattern
      cmbxPocbOptionPwrMeasurePat.Items.Add(DisplayPatGrp.PatName[i]); //2022-09-06 POWER_MEASURE_PAT
      cmbxPocbOptionVerifyPattern.Items.Add(DisplayPatGrp.PatName[i]);

      cmbxPocbOptionComparePat1.Items.Add(DisplayPatGrp.PatName[i]);
      cmbxPocbOptionComparePat2.Items.Add(DisplayPatGrp.PatName[i]);
      cmbxPocbOptionComparePat3.Items.Add(DisplayPatGrp.PatName[i]);
      cmbxPocbOptionComparePat4.Items.Add(DisplayPatGrp.PatName[i]);
    end;
    with FileModelInfo2 do begin
      cmbxPocbOptionPowerOnPat.ItemIndex    := PowerOnPatNum;    //2021-11-24 POWER_ON_PATTERN
      cmbxPocbOptionPwrMeasurePat.ItemIndex := PwrMeasurePatNum; //2022-09-06 POWER_MEASURE_PAT
      cmbxPocbOptionVerifyPattern.ItemIndex := VerifyPatNum;

      cmbxPocbOptionComparePat1.ItemIndex := ComparedPat[0];
      cmbxPocbOptionComparePat2.ItemIndex := ComparedPat[1];
      cmbxPocbOptionComparePat3.ItemIndex := ComparedPat[2];
      cmbxPocbOptionComparePat4.ItemIndex := ComparedPat[3];
      edPocbOptionComparePatName1.Text := ComparePatName[0];
      edPocbOptionComparePatName2.Text := ComparePatName[1];
      edPocbOptionComparePatName3.Text := ComparePatName[2];
      edPocbOptionComparePatName4.Text := ComparePatName[3];
    end;
  end;
end;

procedure TfrmModelInfo.DisplayModelInfo(sModelName: string);  //TBD:A2CHv3:MULTIPLE_MODEL?
var
  nCh : Integer;
  nColorEdit, nColorCmbx, nColorCheckFont : TColor;
  sCsvFileName : string;
  nTemp : Integer;
  bVisible : Boolean;
begin
  nColorEdit  := clWindow;      //default
  nColorCmbx  := clWindow;      //default
  nColorCheckFont := $00783C3C; //default
  bModelInfoDispDone := False;  //TBD:A2CHv3:MULTIPLE_MODEL?
  //
  LoadFileModelInfo(sModelName);

  with FileModelInfo do begin
    // Model Information > Model Parameters > Display Mode
    cmbxDispModeSignalType.ItemIndex  := SigType;     cmbxDispModeSignalType.Color  := nColorCmbx;
    cmbxDispModeBit.ItemIndex         := Bit;         cmbxDispModeBit.Color         := nColorCmbx;
    cmbxDispModePixelType.ItemIndex   := PixelType;   cmbxDispModePixelType.Color   := nColorCmbx;
    cmbxDispModeRotate.ItemIndex      := Rotate;      cmbxDispModeRotate.Color      := nColorCmbx;
  	cmbxDispModeSignalTypeChange(nil); //TBD:MERGE:MODELINFO_PG?
	//cmbxDispModeWP.ItemIndex
  	cmbxDispModeI2cPullup.ItemIndex   := I2cPullup;   cmbxDispModeI2cPullup.Color   := nColorCmbx; //TBD:MERGE:MODELINFO_PG?
    cmbxDispModeDataLineOut.ItemIndex := DataLineOut; cmbxDispModeDataLineOut.Color := nColorCmbx;
    cmbxDispModeOpenCheck.ItemIndex   := OpenCheck;   cmbxDispModeOpenCheck.Color   := nColorCmbx; //2023-10-18 DP200|DP201
    cmbxDispModeModelType.ItemIndex   := ModelType;   cmbxDispModeModelType.Color   := nColorCmbx;

    // Model Information > Model Parameters > Timing Info
    edTimingInfoFreqency.Text          := Format('%0.2f',[Freq / 100]);  edTimingInfoFreqency.Color      := nColorEdit;
    edTimingInfoTotalPeriod_H.Text     := Format('%d',[H_Total]);        edTimingInfoTotalPeriod_H.Color := nColorEdit;
    edTimingInfoTotalPeriod_V.Text     := Format('%d',[V_Total]);        edTimingInfoTotalPeriod_V.Color := nColorEdit;
    edTimingInfoActiveArea_H.Text      := Format('%d',[H_Active]);       edTimingInfoActiveArea_H.Color  := nColorEdit;
    edTimingInfoActiveArea_V.Text      := Format('%d',[V_Active]);       edTimingInfoActiveArea_V.Color  := nColorEdit;
    edTimingInfoPulseWidth_H.Text      := Format('%d',[H_Width]);        edTimingInfoPulseWidth_H.Color  := nColorEdit;
    edTimingInfoPulseWidth_V.Text      := Format('%d',[V_Width]);        edTimingInfoPulseWidth_V.Color  := nColorEdit;
    edTimingInfoBackPorch_H.Text       := Format('%d',[H_BP]);           edTimingInfoBackPorch_H.Color   := nColorEdit;
    edTimingInfoBackPorch_V.Text       := Format('%d',[V_BP]);           edTimingInfoBackPorch_V.Color   := nColorEdit;
    edTimingInfoFrontPorch_H.Text      := Format('%d',[H_Total - H_Active - H_BP - H_Width]); edTimingInfoFrontPorch_H.Color := nColorEdit;
    edTimingInfoFrontPorch_V.Text      := Format('%d',[V_Total - V_Active - V_BP - V_Width]); edTimingInfoFrontPorch_V.Color := nColorEdit;
    cmbxTimingInfoClockDelay.ItemIndex := ClockDelay;                    cmbxTimingInfoClockDelay.Color  := nColorCmbx;
    cmbxTimingInfoI2cFreq.ItemIndex    := I2cFreq;                       cmbxTimingInfoI2cFreq.Color     := nColorCmbx;

    // Model Information > Model Parameters > Power Sequence
    //  - Power Seq Type
    cbPwrSeqExtUse.Visible := TernaryOp((Common.SystemInfo.PG_TYPE<>DefPG.PG_TYPE_DP489),True,False);
    cbPwrSeqExtUse.Checked   := PwrSeqExtUse;  cbPwrSeqExtUse.Font.Color := nColorCheckFont;
    RzgrpPwrSeqExt.Visible   := PwrSeqExtUse;
    RzgrpPwrSeqBasic.Visible := (not PwrSeqExtUse);
    //  - Basic Power Seq
    cmbxPowerSeq.ItemIndex := Sequence;                      cmbxPowerSeq.Color      := nColorCmbx;
    edPowerSeqOnSeq1.Text  := Format('%d',[PowerOnSeq[0]]);  edPowerSeqOnSeq1.Color  := nColorEdit;
    edPowerSeqOnSeq2.Text  := Format('%d',[PowerOnSeq[1]]);  edPowerSeqOnSeq2.Color  := nColorEdit; //TBD:MERGE:MODELINFO_PG?
    edPowerSeqOnSeq3.Text  := Format('%d',[PowerOnSeq[2]]);  edPowerSeqOnSeq3.Color  := nColorEdit;
    edPowerSeqOffSeq1.Text := Format('%d',[PowerOffSeq[0]]); edPowerSeqOffSeq1.Color := nColorEdit;
  	edPowerSeqOffSeq2.Text := Format('%d',[PowerOffSeq[1]]); edPowerSeqOffSeq2.Color := nColorEdit; //TBD:MERGE:MODELINFO_PG?
    edPowerSeqOffSeq3.Text := Format('%d',[PowerOffSeq[2]]); edPowerSeqOffSeq3.Color := nColorEdit;
    //  - Ext Power Seq
    cmbxPwrSeqExtAvailCnt.ItemIndex := PwrSeqExtAvailCnt; cmbxPwrSeqExtAvailCnt.Color := nColorCmbx;
    //
    if PwrSeqExtAvailCnt > 0 then bVisible := True else bVisible := False;
    cmbxPwrSeqExtOnIdx0.ItemIndex  := PwrSeqExtOnIdx[0];  cmbxPwrSeqExtOnIdx0.Color  := nColorCmbx;  cmbxPwrSeqExtOnIdx0.Visible  := bVisible;
    cmbxPwrSeqExtOffIdx0.ItemIndex := PwrSeqExtOffIdx[0]; cmbxPwrSeqExtOffIdx0.Color  := nColorCmbx; cmbxPwrSeqExtOffIdx0.Visible := bVisible;
    //
    if PwrSeqExtAvailCnt > 1 then bVisible := True else bVisible := False;
    edPwrSeqExtOnDelay0.Text   := Format('%d',[PwrSeqExtOnDelay[0]]);  edPwrSeqExtOnDelay0.Color  := nColorEdit; edPwrSeqExtOnDelay0.Visible  := bVisible;
    edPwrSeqExtOffDelay0.Text  := Format('%d',[PwrSeqExtOffDelay[0]]); edPwrSeqExtOffDelay0.Color := nColorEdit; edPwrSeqExtOffDelay0.Visible := bVisible;
    cmbxPwrSeqExtOnIdx1.ItemIndex  := PwrSeqExtOnIdx[1];  cmbxPwrSeqExtOnIdx1.Color  := nColorCmbx; cmbxPwrSeqExtOnIdx1.Visible  := bVisible;
    cmbxPwrSeqExtOffIdx1.ItemIndex := PwrSeqExtOffIdx[1]; cmbxPwrSeqExtOffIdx1.Color := nColorCmbx; cmbxPwrSeqExtOffIdx1.Visible := bVisible;
    //
    if PwrSeqExtAvailCnt > 2 then bVisible := True else bVisible := False;
    edPwrSeqExtOnDelay1.Text   := Format('%d',[PwrSeqExtOnDelay[1]]);  edPwrSeqExtOnDelay1.Color  := nColorEdit; edPwrSeqExtOnDelay1.Visible  := bVisible;
    edPwrSeqExtOffDelay1.Text  := Format('%d',[PwrSeqExtOffDelay[1]]); edPwrSeqExtOffDelay1.Color := nColorEdit; edPwrSeqExtOffDelay1.Visible := bVisible;
    cmbxPwrSeqExtOnIdx2.ItemIndex  := PwrSeqExtOnIdx[2];  cmbxPwrSeqExtOnIdx2.Color  := nColorCmbx; cmbxPwrSeqExtOnIdx2.Visible  := bVisible;
    cmbxPwrSeqExtOffIdx2.ItemIndex := PwrSeqExtOffIdx[2]; cmbxPwrSeqExtOffIdx2.Color := nColorCmbx; cmbxPwrSeqExtOffIdx2.Visible := bVisible;
    //
    if PwrSeqExtAvailCnt > 3 then bVisible := True else bVisible := False;
    edPwrSeqExtOnDelay2.Text   := Format('%d',[PwrSeqExtOnDelay[2]]);  edPwrSeqExtOnDelay2.Color  := nColorEdit; edPwrSeqExtOnDelay2.Visible  := bVisible;
    edPwrSeqExtOffDelay2.Text  := Format('%d',[PwrSeqExtOffDelay[2]]); edPwrSeqExtOffDelay2.Color := nColorEdit; edPwrSeqExtOffDelay2.Visible := bVisible;
    cmbxPwrSeqExtOnIdx3.ItemIndex  := PwrSeqExtOnIdx[3];  cmbxPwrSeqExtOnIdx3.Color  := nColorCmbx;  cmbxPwrSeqExtOnIdx3.Visible  := bVisible;
    cmbxPwrSeqExtOffIdx3.ItemIndex := PwrSeqExtOffIdx[3]; cmbxPwrSeqExtOffIdx3.Color := nColorCmbx;  cmbxPwrSeqExtOffIdx3.Visible := bVisible;
    //
    if PwrSeqExtAvailCnt > 4 then bVisible := True else bVisible := False;
    edPwrSeqExtOnDelay3.Text   := Format('%d',[PwrSeqExtOnDelay[3]]);  edPwrSeqExtOnDelay3.Color  := nColorEdit; edPwrSeqExtOnDelay3.Visible  := bVisible;
    edPwrSeqExtOffDelay3.Text  := Format('%d',[PwrSeqExtOffDelay[3]]); edPwrSeqExtOffDelay3.Color := nColorEdit; edPwrSeqExtOffDelay3.Visible := bVisible;
    cmbxPwrSeqExtOnIdx4.ItemIndex  := PwrSeqExtOnIdx[4];  cmbxPwrSeqExtOnIdx4.Color  := nColorCmbx;  cmbxPwrSeqExtOnIdx4.Visible  := bVisible;
    cmbxPwrSeqExtOffIdx4.ItemIndex := PwrSeqExtOffIdx[4]; cmbxPwrSeqExtOffIdx4.Color := nColorCmbx;  cmbxPwrSeqExtOffIdx4.Visible := bVisible;
    //
    if PwrSeqExtAvailCnt > 5 then bVisible := True else bVisible := False;
    edPwrSeqExtOnDelay4.Text   := Format('%d',[PwrSeqExtOnDelay[4]]);  edPwrSeqExtOnDelay4.Color  := nColorEdit; edPwrSeqExtOnDelay4.Visible  := bVisible;
    edPwrSeqExtOffDelay4.Text  := Format('%d',[PwrSeqExtOffDelay[4]]); edPwrSeqExtOffDelay4.Color := nColorEdit; edPwrSeqExtOffDelay4.Visible := bVisible;
    cmbxPwrSeqExtOnIdx5.ItemIndex  := PwrSeqExtOnIdx[5];  cmbxPwrSeqExtOnIdx5.Color  := nColorCmbx; cmbxPwrSeqExtOnIdx5.Visible  := bVisible;
    cmbxPwrSeqExtOffIdx5.ItemIndex := PwrSeqExtOffIdx[5]; cmbxPwrSeqExtOffIdx5.Color := nColorCmbx; cmbxPwrSeqExtOffIdx5.Visible := bVisible;
    //
  //if PwrSeqExtAvailCnt > X5 then bVisible := True else bVisible := False;
  //edPwrSeqExtOnDelay(X-1).Text   := Format('%d',[PwrSeqExtOnDelay[X-1]]); edPwrSeqExtOnDelay(X-1).Color  := nColorEdit; edPwrSeqExtOnDelay(X-1).Visible  := bVisible;
  //edPwrSeqExtOffDelay(X-1).Text  := Format('%d',[PwrSeqExtOffDelay[X-1]); edPwrSeqExtOffDelay)X-1).Color := nColorEdit; edPwrSeqExtOffDelay(X-1).Visible := bVisible;
  //cmbxPwrSeqExtOnIdxX.ItemIndex  := PwrSeqExtOnIdx[X];  cmbxPwrSeqExtOnIdxX.Color  := nColorCmbx; cmbxPwrSeqExtOnIdxX.Visible  := bVisible;
  //cmbxPwrSeqExtOffIdxX.ItemIndex := PwrSeqExtOffIdx[X]; cmbxPwrSeqExtOffIdxX.Color := nColorCmbx; cmbxPwrSeqExtOffIdxX.Visible := bVisible;

	  // Model Information > Model Parameters > Input Voltage
  	edInputVoltageVcc.Text := Format('%0.2f',[PWR_VOL[DefPG.PWR_VCC]     / 1000]); edInputVoltageVcc.Color := nColorEdit;
	  edInputVoltageVdd.Text := Format('%0.2f',[PWR_VOL[DefPG.PWR_VDD_VEL] / 1000]); edInputVoltageVdd.Color := nColorEdit;
	  edInputVoltageVbr.Text := Format('%0.2f',[PWR_VOL[DefPG.PWR_VBR]     / 1000]); edInputVoltageVbr.Color := nColorEdit;

    // Model Information > Model Parameters > Voltage Offset
    edVoltageOffsetVcc.Text := Format('%0.2f',[PWR_OFFSET[DefPG.PWR_VCC]     / 1000]); edVoltageOffsetVcc.Color := nColorEdit; //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
    edVoltageOffsetVdd.Text := Format('%0.2f',[PWR_OFFSET[DefPG.PWR_VDD_VEL] / 1000]); edVoltageOffsetVdd.Color := nColorEdit; //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)

	  // Model Information > Model Parameters > Limit Setting
	  edLimitSettingVcc_Low.Text  := Format('%0.2f',[PWR_LIMIT_L[DefPG.PWR_VCC]     / 1000]); edLimitSettingVcc_Low.Color  := nColorEdit;
	  edLimitSettingVcc_High.Text := Format('%0.2f',[PWR_LIMIT_H[DefPG.PWR_VCC]     / 1000]); edLimitSettingVcc_High.Color := nColorEdit;
	  edLimitSettingVdd_Low.Text  := Format('%0.2f',[PWR_LIMIT_L[DefPG.PWR_VDD_VEL] / 1000]); edLimitSettingVdd_Low.Color  := nColorEdit;
	  edLimitSettingVdd_High.Text := Format('%0.2f',[PWR_LIMIT_H[DefPG.PWR_VDD_VEL] / 1000]); edLimitSettingVdd_High.Color := nColorEdit;
	//edVBR_Low.Text  := Format('%0.2f',[PWR_LIMIT_L[DefPG.PWR_VBR] / 1000]); edVBR_Low.Color  := nColorEdit;
	//edVBR_High.Text := Format('%0.2f',[PWR_LIMIT_H[DefPG.PWR_VBR] / 1000]); edVBR_High.Color := nColorEdit;

	  edLimitSettingIcc_Low.Text  := Format('%d',[PWR_LIMIT_L[DefPG.PWR_ICC]]);     edLimitSettingIcc_Low.Color  := nColorEdit;
	  edLimitSettingIcc_High.Text := Format('%d',[PWR_LIMIT_H[DefPG.PWR_ICC]]);     edLimitSettingIcc_High.Color := nColorEdit;
	  edLimitSettingIdd_Low.Text  := Format('%d',[PWR_LIMIT_L[DefPG.PWR_IDD_IEL]]); edLimitSettingIdd_Low.Color  := nColorEdit;
	  edLimitSettingIdd_High.Text := Format('%d',[PWR_LIMIT_H[DefPG.PWR_IDD_IEL]]); edLimitSettingIdd_High.Color := nColorEdit;

    // Model Information > Model Parameters > POCB Option
    edPatGrpName.Text := PatGrpName; edPatGrpName.Color := nColorEdit;
//TBD?
  end; //with FileModelInfo

  with FileModelInfo2 do begin
    // Model Information > PG/SPI Version  //2019-04-19 ALARM:FW_VERSION
    edPgFwVer.Text  := PgFwVer;   edPgFwVer.Color  := nColorEdit;
    edSpiFwVer.Text := SpiFwVer;  edSpiFwVer.Color := nColorEdit;

    cbPocbOptionModelCh1Use.Checked := AssyModelInfo.UseCh1; cbPocbOptionModelCh1Use.Font.Color := nColorCheckFont;
    cbPocbOptionModelCh2Use.Checked := AssyModelInfo.UseCh2; cbPocbOptionModelCh2Use.Font.Color := nColorCheckFont;

    {$IFDEF HAS_MOTION_CAM_Z}
    edPocbOptionZaxis1ModelPos.Text := Format('%0.2f',[CamZModelPosCh1]); edPocbOptionZaxis1ModelPos.Color := nColorEdit;
    edPocbOptionZaxis2ModelPos.Text := Format('%0.2f',[CamZModelPosCh2]); edPocbOptionZaxis2ModelPos.Color := nColorEdit;
    {$ENDIF}
    edPocbOptionYaxis1LoadPos.Text  := Format('%0.2f',[CamYLoadPosCh1]);  edPocbOptionYaxis1LoadPos.Color := nColorEdit;
    edPocbOptionYaxis1CamPos.Text   := Format('%0.2f',[CamYCamPosCh1]);   edPocbOptionYaxis1CamPos.Color  := nColorEdit;
    edPocbOptionYaxis2LoadPos.Text  := Format('%0.2f',[CamYLoadPosCh2]);  edPocbOptionYaxis2LoadPos.Color := nColorEdit;
    edPocbOptionYaxis2CamPos.Text   := Format('%0.2f',[CamYCamPosCh2]);   edPocbOptionYaxis2CamPos.Color  := nColorEdit;
    {$IFDEF HAS_ROBOT_CAM_Z}
    edPocbOptionRobot1CoordX.Text   := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.X);  edPocbOptionRobot1CoordX.Color   := nColorEdit;
    edPocbOptionRobot1CoordY.Text   := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.Y);  edPocbOptionRobot1CoordY.Color   := nColorEdit;
    edPocbOptionRobot1CoordZ.Text   := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.Z);  edPocbOptionRobot1CoordZ.Color   := nColorEdit;
    edPocbOptionRobot1CoordRx.Text  := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.Rx); edPocbOptionRobot1CoordRx.Color  := nColorEdit;
    edPocbOptionRobot1CoordRy.Text  := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.Ry); edPocbOptionRobot1CoordRy.Color  := nColorEdit;
    edPocbOptionRobot1CoordRz.Text  := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh1.Coord.Rz); edPocbOptionRobot1CoordRz.Color  := nColorEdit;
    edPocbOptionRobot1ModelCmd.Text := RobotModelInfoCh1.ModelCmd;                                 edPocbOptionRobot1ModelCmd.Color := nColorEdit;
    edPocbOptionRobot2CoordX.Text   := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.X);  edPocbOptionRobot2CoordX.Color   := nColorEdit;
    edPocbOptionRobot2CoordY.Text   := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.Y);  edPocbOptionRobot2CoordY.Color   := nColorEdit;
    edPocbOptionRobot2CoordZ.Text   := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.Z);  edPocbOptionRobot2CoordZ.Color   := nColorEdit;
    edPocbOptionRobot2CoordRx.Text  := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.Rx); edPocbOptionRobot2CoordRx.Color  := nColorEdit;
    edPocbOptionRobot2CoordRy.Text  := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.Ry); edPocbOptionRobot2CoordRy.Color  := nColorEdit;
    edPocbOptionRobot2CoordRz.Text  := FormatFloat(ROBOT_FORMAT_COORD,RobotModelInfoCh2.Coord.Rz); edPocbOptionRobot2CoordRz.Color  := nColorEdit;
    edPocbOptionRobot2ModelCmd.Text := RobotModelInfoCh2.ModelCmd;                                 edPocbOptionRobot2ModelCmd.Color := nColorEdit;
    {$ENDIF}

    {$IFDEF SUPPORT_1CG2PANEL}
		if (not Common.SystemInfo.UseAssyPOCB) then begin
    {$ENDIF}
		  AssyModelInfo.UseCh1        := True;
	  	AssyModelInfo.UseCh2        := True;
	  	AssyModelInfo.LcmPosCh1     := LcmPosCP;
	  	AssyModelInfo.LcmPosCh2     := LcmPosCP;
	  	AssyModelInfo.UseMainPidCh1 := True;
		  AssyModelInfo.UseMainPidCh2 := True;
    {$IFDEF SUPPORT_1CG2PANEL}			
		end
		else begin
      cbPocbOptionUseMainPidCh1.Visible := AssyModelInfo.UseCh1;
      cbPocbOptionUseMainPidCh1.Checked := AssyModelInfo.UseMainPidCh1;
      cmbxCh1AssyLcmPos.Visible := AssyModelInfo.UseCh1;
      if AssyModelInfo.UseCh1 then begin
        case AssyModelInfo.LcmPosCh1 of
          LcmPosLeft   : cmbxCh1AssyLcmPos.ItemIndex := 0; //Left
          LcmPosCenter : cmbxCh1AssyLcmPos.ItemIndex := 1; //Center
        end;
        cmbxCh1AssyLcmPos.Color := nColorCmbx;
      end;
      cbPocbOptionUseMainPidCh2.Visible := AssyModelInfo.UseCh2;
      cbPocbOptionUseMainPidCh2.Checked := AssyModelInfo.UseMainPidCh2;
      cmbxCh2AssyLcmPos.Visible := AssyModelInfo.UseCh2;
      if AssyModelInfo.UseCh2 then begin
        case AssyModelInfo.LcmPosCh2 of
          LcmPosRight  : cmbxCh2AssyLcmPos.ItemIndex := 0; //Right
          LcmPosCenter : cmbxCh2AssyLcmPos.ItemIndex := 1; //Center
        end;
        cmbxCh2AssyLcmPos.Color := nColorCmbx;
  		end;
    end;
    {$ENDIF} //SUPPORT_1CG2PANEL

    cmbxPocbOptionPowerOnPat.ItemIndex    := PowerOnPatNum;    cmbxPocbOptionPowerOnPat.Color    := nColorCmbx; //2021-11-24 POWER_ON_PATTERN
    cmbxPocbOptionPwrMeasurePat.ItemIndex := PwrMeasurePatNum; cmbxPocbOptionPwrMeasurePat.Color := nColorCmbx; //2022-09-06 POWER_MEASURE_PAT
    cmbxPocbOptionVerifyPattern.ItemIndex := VerifyPatNum;     cmbxPocbOptionVerifyPattern.Color := nColorCmbx;

    edPocbOptionBcrLen.Text         := Format('%d',[BcrLength]); edPocbOptionBcrLen.Color := nColorEdit;
    edPocbOptionBcrPidChkIdx.Text   := Format('%d',[BcrPidChkIdx]); edPocbOptionBcrPidChkIdx.Color := nColorEdit; //A2CHv3:BCR_PID_CHECK
    edPocbOptionBcrPidChkStr.Text   := BcrPidChkStr;edPocbOptionBcrPidChkStr.Color := nColorEdit;                 //A2CHv3:BCR_PID_CHECK
		{$IFDEF FEATURE_BCR_SCAN_SPCB}
    cbPocbOptionBcrScanMesSPCB.Checked     := BcrScanMesSPCB;      cbPocbOptionBcrScanMesSPCB.Font.Color     := nColorCheckFont; //A2CHv4:Lucid:ScanSPCB
    cbPocbOptionBcrScanMesSPCB.Visible     := True;
    cbPocbOptionBcrSPCBIDInterlock.Checked := BcrSPCBIdInterlock ; cbPocbOptionBcrSPCBIDInterlock.Font.Color := nColorCheckFont; //A2CHv4:Lucid:ScanSPCB //2023-05-19 LGDVH:#302(A2CHv4):SPCB_ID_INTERLOCK
    cbPocbOptionBcrSPCBIDInterlock.Visible := True; //2023-05-19 LGDVH:#302(A2CHv4:SPCB_ID_INTERLOCK
    {$ELSE}
    cbPocbOptionBcrScanMesSPCB.Checked     := False;  cbPocbOptionBcrScanMesSPCB.Visible     := False;
    cbPocbOptionBcrSPCBIDInterlock.Checked := False;  cbPocbOptionBcrSPCBIDInterlock.Visible := False;
		{$ENDIF}
		{$IFDEF FEATURE_BCR_PID_INTERLOCK}
    cbPocbOptionBcrPIDInterlock.Checked := BcrPIDInterlock; cbPocbOptionBcrPIDInterlock.Font.Color := nColorCheckFont; //2023-09-26 LGDVH:#301:BCR_PID_INTERLOCK //2023-10-10 LENSVN:ATO:BCR_PID_INTERLOCK
    cbPocbOptionBcrPIDInterlock.Visible := True; //2023-09-26 LGDVH:#301:BCR_PID_INTERLOCK //2023-10-10 LENSVN:ATO:BCR_PID_INTERLOCK
    {$ELSE}
    cbPocbOptionBcrPIDInterlock.Checked := False;
    cbPocbOptionBcrPIDInterlock.Visible := False;
		{$ENDIF}

    cbPocbOptionUseExLightFlow.Checked := UseExLightFlow;    cbPocbOptionUseExLightFlow .Font.Color := nColorCheckFont;
    cbPocbOptionUseVacuum.Checked := UseVacuum;    cbPocbOptionUseVacuum.Font.Color := nColorCheckFont;  //2019-06-24
    cbPocbOptionIonOnOff.Checked  := UseIonOnOff;  cbPocbOptionIonOnOff.Font.Color  := nColorCheckFont;  //2019-09-26 Ionizer On/Off

    cmbxPocbOptionCamTEndWait.ItemIndex  := CamTEndWait;  cmbxPocbOptionCamTEndWait.Color := nColorCmbx;
    {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
    cmbxPocbOptionCamCBCount.ItemIndex := CamCBCount;        cmbxPocbOptionCamCBCount.Color := nColorCmbx;
    cbPocbOptionPowerResetAfterEepCBParaWrite.Checked := UsePowerResetAfterEepromCBParaWrite; cbPocbOptionPowerResetAfterEepCBParaWrite.Font.Color := nColorCheckFont;
  	{$ENDIF}
    {$IFDEF HAS_DIO_PINBLOCK}
    cbPocbOptionCheckPinblock.Checked  := UseCheckPinblock;  cbPocbOptionCheckPinblock.Font.Color := nColorCheckFont;
  	{$ENDIF}

  //{$IFDEF PANEL_AUTO}
    cbPocbOptionScanFirst.Checked := UseScanFirst; cbPocbOptionScanFirst.Font.Color := nColorCheckFont;
  //{$ENDIF}

 		{$IFDEF FEATURE_UNIFORMITY_PUCONOFF}
    cbPocbOptionUsePucOnOff.Checked := UsePucOnOff;   cbPocbOptionUsePucOnOff.Font.Color := nColorCheckFont; //2022-07-15 UNIFORMITY_PUCONOFF
    ShowUsePucOnOffGui(cbPocbOptionUsePucOnOff.Checked);
		if UsePucOnOff then cbPocbOptionUseCustomName.Enabled := False;
    {$ELSE}
    cbPocbOptionUsePucOnOff.Visible := False; cbPocbOptionUsePucOnOff.Checked := False;
    {$ENDIF}
		{$IFDEF FEATURE_PUC_IMAGE}
    cbPocbOptionUsePucImage.Checked := UsePucImage;   cbPocbOptionUsePucImage.Font.Color := nColorCheckFont; //2023-04-07 FEATURE_PUC_IMAGE
    {$ELSE}
    cbPocbOptionUsePucImage.Visible := False; cbPocbOptionUsePucImage.Checked := False;
    {$ENDIF}

    cbPocbOptionUseCustomName.Checked := UseCustumPatName;   cbPocbOptionUseCustomName.Font.Color := nColorCheckFont;
    ShowComparePatNameGui(cbPocbOptionUseCustomName.Checked);

    cmbxPocbOptionVerifyCnt.ItemIndex   := JudgeCount;     cmbxPocbOptionVerifyCnt.Color   := nColorCmbx;
    cmbxPocbOptionComparePat1.ItemIndex := ComparedPat[0]; cmbxPocbOptionComparePat1.Color := nColorCmbx;
    cmbxPocbOptionComparePat2.ItemIndex := ComparedPat[1]; cmbxPocbOptionComparePat2.Color := nColorCmbx;
    cmbxPocbOptionComparePat3.ItemIndex := ComparedPat[2]; cmbxPocbOptionComparePat3.Color := nColorCmbx;  //2019-03-27
    cmbxPocbOptionComparePat4.ItemIndex := ComparedPat[3]; cmbxPocbOptionComparePat4.Color := nColorCmbx;  //2019-03-27

    edPocbOptionComparePatName1.Text    := ComparePatName[0]; edPocbOptionComparePatName1.Color := nColorEdit;
    edPocbOptionComparePatName2.Text    := ComparePatName[1]; edPocbOptionComparePatName2.Color := nColorEdit;
    edPocbOptionComparePatName3.Text    := ComparePatName[2]; edPocbOptionComparePatName3.Color := nColorEdit;
    edPocbOptionComparePatName4.Text    := ComparePatName[3]; edPocbOptionComparePatName4.Color := nColorEdit;

    edPocbOptionWhiteLumi1.Text         := Format('%0.1f',[WhiteUniform[0]]); edPocbOptionWhiteLumi1.Color := nColorEdit;
    edPocbOptionWhiteLumi2.Text         := Format('%0.1f',[WhiteUniform[1]]); edPocbOptionWhiteLumi2.Color := nColorEdit;
    edPocbOptionWhiteLumi3.Text         := Format('%0.1f',[WhiteUniform[2]]); edPocbOptionWhiteLumi3.Color := nColorEdit;  //2019-03-27
    edPocbOptionWhiteLumi4.Text         := Format('%0.1f',[WhiteUniform[3]]); edPocbOptionWhiteLumi4.Color := nColorEdit;  //2019-03-27

		{$IFDEF PANEL_AUTO}
    cmbxPocbOptionBmpDownRetryCnt.ItemIndex := BmpDownRetryCnt; cmbxPocbOptionBmpDownRetryCnt.Color := nColorCmbx;
    {$ENDIF}

    edPocbOptionPowerOnDelay.Text       := Format('%d',[PwrOnDelayMsec]);  edPocbOptionPowerOnDelay.Color    := nColorEdit;
    edPocbOptionPowerOffDelay.Text      := Format('%d',[PwrOffDelayMsec]); edPocbOptionPowerOffDelay.Color   := nColorEdit;
    {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
    edPocbOptionPowerOnAgingSec.Text    := Format('%d',[PowerOnAgingSec]); edPocbOptionPowerOnAgingSec.Color := nColorEdit;
    {$ENDIF}

    // Model Information > Model Parameters
    cbPowerOnOffUseOption.Checked  := EnablePwrMode;          cbPowerOnOffUseOption.Font.Color  := nColorCheckFont;
    cbProcMaskUseOption.Checked    := EnableProcMask;         cbProcMaskUseOption.Font.Color    := nColorCheckFont;
    cbCBDataWriteUseOption.Checked := EnableFlashWriteCBData; cbCBDataWriteUseOption.Font.Color := nColorCheckFont;

    {$IFDEF PANEL_FOLD}
    edPWMOptionFreq.Text                := Format('%d',[Pwm_freq]);
    edPWMOptionDuty.Text                := Format('%d',[Pwm_duty]);
    cbPWMOptionUse.Checked              := UsePwm;
    {$ENDIF}

    // DFS Option
    edDfsOptionCombiModelInfo.Text  := CombiModelInfoKey;
    // Log Upload Option
    edLogUploadOptionPanelModel.Text := LogUploadPanelModel; //2022-07-25 LOG_UPLOAD
  end; //with FileModelInfo2

  //DP200 ---------------------------------------------------------------- start
  if Common.SystemInfo.PG_TYPE <> DefPG.PG_TYPE_DP489 then begin  //DP200|DP201
    with FileModelInfoALDP do begin
      //  - DP200 SPI & I2C
      cboDP200_SPI_PULLUP.ItemIndex := SPI_PULLUP;
      cboDP200_SPI_SPEED.ItemIndex  := SPI_SPEED;
      cboDP200_SPI_MODE.ItemIndex   := SPI_MODE;
      cboDP200_SPI_LEVEL.ItemIndex  := SPI_LEVEL;
      cboDP200_I2C_LEVEL.ItemIndex  := I2C_LEVEL;
      //  - DP200 ALPDP
      edDP200_ALPDP_LINK_RATE.Text  := Format('%d',[ALPDP_LINK_RATE]);
      edDP200_ALPDP_H_FDP.Text      := Format('%d',[ALPDP_H_FDP]);
      edDP200_ALPDP_H_SDP.Text      := Format('%d',[ALPDP_H_SDP]);
      edDP200_ALPDP_H_PCNT.Text     := Format('%d',[ALPDP_H_PCNT]);
      edDP200_ALPDP_VB_SLEEP.Text   := Format('%d',[ALPDP_VB_SLEEP]);
      edDP200_ALPDP_VB_N2.Text      := Format('%d',[ALPDP_VB_N2]);
      edDP200_ALPDP_VB_N3.Text      := Format('%d',[ALPDP_VB_N3]);
      edDP200_ALPDP_VB_N4.Text      := Format('%d',[ALPDP_VB_N4]);
      edDP200_ALPDP_VB_N5B.Text     := Format('%d',[ALPDP_VB_N5B]);
      edDP200_ALPDP_VB_N7.Text      := Format('%d',[ALPDP_VB_N7]);
      edDP200_ALPDP_VB_N5A.Text     := Format('%d',[ALPDP_VB_N5A]);
      //
      edDP200_ALPDP_MSA_MVID.Text    := Format('%d',[ALPDP_MSA_MVID]);
      edDP200_ALPDP_MSA_NVID.Text    := Format('%d',[ALPDP_MSA_NVID]);
      edDP200_ALPDP_MSA_HTOTAL.Text  := Format('%d',[ALPDP_MSA_HTOTAL]);
      edDP200_ALPDP_MSA_HSTART.Text  := Format('%d',[ALPDP_MSA_HSTART]);
      edDP200_ALPDP_MSA_HWIDTH.Text  := Format('%d',[ALPDP_MSA_HWIDTH]);
      edDP200_ALPDP_MSA_VTOTAL.Text  := Format('%d',[ALPDP_MSA_VTOTAL]);
      edDP200_ALPDP_MSA_VSTART.Text  := Format('%d',[ALPDP_MSA_VSTART]);
      edDP200_ALPDP_MSA_VHEIGHT.Text := Format('%d',[ALPDP_MSA_VHEIGHT]);
      edDP200_ALPDP_MSA_HSP_HSW.Text := Format('%d',[ALPDP_MSA_HSP_HSW]);
      edDP200_ALPDP_MSA_VSP_VSW.Text := Format('%d',[ALPDP_MSA_VSP_VSW]);
      edDP200_ALPDP_MSA_MISC0.Text   := Format('%d',[ALPDP_MSA_MISC0]);
      edDP200_ALPDP_MSA_MISC1.Text   := Format('%d',[ALPDP_MSA_MISC1]);
      //
      edDP200_ALPDP_SPECIAL_PANEL.Text      := Format('%d',[ALPDP_SPECIAL_PANEL]);
      cboDP200_ALPDP_ALPM.ItemIndex         := ALPDP_ALPM;
      cboDP200_ALPDP_LINK_MODE.ItemIndex    := ALPDP_LINK_MODE;
      edDP200_ALPDP_CHOP_SIZE.Text          := Format('%d',[ALPDP_CHOP_SIZE]);
      edDP200_ALPDP_CHOP_SECTION.Text       := Format('%d',[ALPDP_CHOP_SECTION]);
      cboDP200_ALPDP_CHOP_ENABLE.ItemIndex  := ALPDP_CHOP_ENABLE;
      cboDP200_ALPDP_HPD_CHECK.ItemIndex    := ALPDP_HPD_CHECK;
      cboDP200_ALPDP_SCRAMBLE_SET.ItemIndex := ALPDP_SCRAMBLE_SET;
      cboDP200_ALPDP_LANE_SETTING.ItemIndex := ALPDP_LANE_SETTING;
      cboDP200_ALPDP_SLAVE_ENABLE.ItemIndex := ALPDP_SLAVE_ENABLE;
      //
      cboDP200_ALPDP_SWING_LEVEL.ItemIndex       := ALPDP_SWING_LEVEL;
      cboDP200_ALPDP_PRE_EMPHASIS_PRE.ItemIndex  := ALPDP_PRE_EMPHASIS_PRE;
      cboDP200_ALPDP_PRE_EMPHASIS_POST.ItemIndex := ALPDP_PRE_EMPHASIS_POST;
      cboDP200_ALPDP_AUX_FREQ_SET.ItemIndex      := ALPDP_AUX_FREQ_SET;
      //
      edDP200_ALPDP_DP141_IF_SET.Text       := Format('%0.2x',[DP141_IF_SET]);
      edDP200_ALPDP_DP141_CNT_SET.Text      := Format('%0.2x',[DP141_CNT_SET]);
      cboDP200_ALPDP_EDID_SKIP.ItemIndex    := EDID_SKIP;
      cboDP200_ALPDP_DEBUG_LEVEL.ItemIndex  := DEBUG_LEVEL;
      cboDP200_ALPDP_eDP_SPEC_OPT.ItemIndex := eDP_SPEC_OPT; //2023-03-24 Tributo
    end;
  end;
  //DP200 ---------------------------------------------------------------- end	

  sCsvFileName := Common.Path.MODEL + Trim(sModelName)+'_param.csv';  //USE_MODEL_PARAM_CSV
  if FileExists(sCsvFileName) then begin
    grdDefParam.LoadFromCSV(sCsvFileName);
    grdDefParam.AutoSize := True;
  end;

  //
  bModelInfoDispDone       := True;
  btnModelInfoSave.Enabled := False;
end;

procedure TfrmModelInfo.Display_PatGroup_data(DisplayPatGrp: TPatternGroup);
var
  i: Integer;
begin
  gridPatInfoList.RowCount := 1;
  gridPatInfoList.Rows[0].Clear;
  edPatGrpName.Text := string(DisplayPatGrp.GroupName);
  edPatGrpPatCnt.Text := Format('%d',[DisplayPatGrp.PatCount]);

  if DisplayPatGrp.PatCount > 0 then begin
    gridPatInfoList.RowCount := DisplayPatGrp.PatCount;
    for i := 0  to Pred(DisplayPatGrp.PatCount) do begin
      gridPatInfoList.Cells[GRID_PATLIST_COL_IDX, i] := Format('%d',[i]); //2022-11-12
      case DisplayPatGrp.PatType[i] of
        DefPG.PTYPE_NORMAL  : gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE, i] := 'Pattern';
        DefPG.PTYPE_BITMAP  : gridPatInfoList.Cells[GRID_PATLIST_COL_TYPE, i] := 'Bitmap';
      end;
      gridPatInfoList.Cells[GRID_PATLIST_COL_PNAME, i] := DisplayPatGrp.PatName[i];
      if DisplayPatGrp.VSync[i] = 0 then  gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, i] := 'None'
      else                                gridPatInfoList.Cells[GRID_PATLIST_COL_VSYNC, i] := Format('%d',[DisplayPatGrp.VSync[i]]);
      gridPatInfoList.Cells[GRID_PATLIST_COL_TIME, i] := Format('%d',[DisplayPatGrp.LockTime[i]]);
			{$IFDEF FEATURE_PATTERN_PWM}
      gridPatInfoList.Cells[GRID_PATLIST_COL_PWM,  i] := Format('%d',[DisplayPatGrp.Dimming[i]]);
			{$ENDIF}
    end;
  end;
  gridPatInfoList.Row := 0;
end;

procedure TfrmModelInfo.Load_data_model(sModel : string);
var
  Rslt : Integer;
  sr  : TSearchRec;
begin
  lstbxModelList.DisableAlign;
  Rslt := FindFirst(Common.Path.MODEL+ '*.mcf', FaAnyFile, sr);
  while Rslt = 0 do begin
    lstbxModelList.Items.Add(Copy(sr.Name, 1, pos('.mcf', sr.Name) - 1));
    Rslt := FindNext(sr);
  end;
  FindClose(sr);
  lstbxModelList.Sorted := True;

  if lstbxModelList.Items.Count > 0 then begin
    AddAndFindItemToListbox(lstbxModelList, sModel, False, True);
    DisplayModelInfo(sModel);
    edModelName.Text := sModel;
    edModelNameDP200.Text := sModel;
    pnlModelNameInfo.Caption := sModel;
  end;
  lstbxModelList.EnableAlign;
end;

procedure TfrmModelInfo.Load_data_pat(PatName: string);
var
  Rslt: Integer;
  sPatGrName: string;
  sr: TSearchRec;
begin
  lstbxPatGrpList.Items.Clear;
  Rslt := FindFirst(Common.Path.PATTERNGROUP + '*.grp', FaanyFile, sr);
  while Rslt = 0 do
  begin
    sPatGrName := Copy(sr.Name, 1, Length(sr.Name) - 4);
    lstbxPatGrpList.Items.Add(sPatGrName);
    Rslt := FindNext(sr);
  end;
  FindClose(sr);
  if lstbxPatGrpList.Items.Count > 0 then begin
    AddAndFindItemToListbox(lstbxPatGrpList, PatName, False, True);
  end;
end;

procedure TfrmModelInfo.PatInfoBtnControl;
begin
  if StrToIntDef(edPatGrpPatCnt.Text,0) > 0 then begin
    btnPatternModify.Enabled := True;
    btnPatternDel.Enabled := True;
  end
  else begin
    btnPatternModify.Enabled := False;
    btnPatternDel.Enabled := False;
  end;

  if gridPatInfoList.Row = 0 then  btnPatternUp.Enabled := False
  else                             btnPatternUp.Enabled := True;

  if gridPatInfoList.Row = gridPatInfoList.RowCount - 1 then  btnPatternDown.Enabled := False
  else                                                        btnPatternDown.Enabled := True;
end;

function TfrmModelInfo.LoadFileModelInfo(fName: String): Boolean;  //A2CHv3:MULTIPLE_MODEL
var
  fn : String;
  modelF : TIniFile;
  i : Integer;
  sTemp : string;
  bIsPower_mVmA : Boolean;
  sFusingDataSection : string;
  sList : TStringList;
begin
  Result := False;
  fn := Common.Path.MODEL + fName + '.mcf';
//DebugMessage(Format('[LoadModelInfo] File=%s',[fn]));
//FillChar(EdModelInfo, SizeOf(EdModelInfo), #0);
  modelF := TIniFile.Create(fn);
  try
    with modelF do begin
      try
        //------------------------------------------------------------------- TMODELINFO & TModelInfo2
				// [MODEL_DATA] ------------------------------
        with FileModelInfo do begin
  				//	- Model Parameters : Display Mode
          PixelType  	  			:= Byte(ReadInteger('MODEL_DATA', 'Pixel_Type', 				0));
          Bit  	        			:= Byte(ReadInteger('MODEL_DATA', 'Bit', 								0));
          Rotate  	    			:= Byte(ReadInteger('MODEL_DATA', 'Rotate', 				  	0));
          SigType  	    			:= Byte(ReadInteger('MODEL_DATA', 'Signal_Type', 				0));
		      WP  	    			    := Byte(ReadInteger('MODEL_DATA', 'WP', 				        0));
          I2cPullup  	    		:= Byte(ReadInteger('MODEL_DATA', 'I2C_PullUp', 		   	0));
          DataLineOut   			:= Byte(ReadInteger('MODEL_DATA', 'DataLineOut',    		0));
          OpenCheck   			  := Byte(ReadInteger('MODEL_DATA', 'OpenCheck',    		  0)); //2022-10-18 DP200|DP201
          ModelType   			  := Byte(ReadInteger('MODEL_DATA', 'ModelType',    		  0)); //2022-1012
				  //	- Model Parameters : Timing/Frequency
          Freq         				:= LongWord(ReadInteger('MODEL_DATA', 'Freq', 					0));
          H_Total      				:= Word(ReadInteger('MODEL_DATA', 'H_Total', 				  	0));
          H_Active     				:= Word(ReadInteger('MODEL_DATA', 'H_Active', 					0));
          H_Width      				:= Word(ReadInteger('MODEL_DATA', 'H_Width',  				  0));
          H_BP         				:= Word(ReadInteger('MODEL_DATA', 'H_BPo',							0));
          V_Total      				:= Word(ReadInteger('MODEL_DATA', 'V_Total', 				  	0));
          V_Active     				:= Word(ReadInteger('MODEL_DATA', 'V_Active',				    0));
          V_Width      				:= Word(ReadInteger('MODEL_DATA', 'V_Width',    			  0));
          V_BP         				:= Word(ReadInteger('MODEL_DATA', 'V_BPo',  					  0));
          ClockDelay   				:= Word(ReadInteger('MODEL_DATA', 'ClockDelay',    			0));
          I2cFreq      				:= Word(ReadInteger('MODEL_DATA', 'I2cFreq',  					0));
				  //	- Power Sequence
          Sequence     				:= Word(ReadInteger('MODEL_DATA', 'Sequence',  					0));
					{$IFDEF PANEL_FOLD}
        	//  - PWM
        	Pwm_freq      			:= Word(ReadInteger('MODEL_DATA', 'PWMFreq',  					0));
        	Pwm_duty      			:= Word(ReadInteger('MODEL_DATA', 'PWMDuty',  					100));  //2019-10-11 DIMMING
        	UsePwm              := ReadBool        ('MODEL_DATA', 'UsePwm', False)					
					{$ENDIF}
          //
				  // [FUSING_DATA] ------------------------------
				  //	- PWR_LIMIT_H_0 ~ PWR_LIMIT_H_5
				  //	- PWR_LIMIT_L_0 ~ PWR_LIMIT_L_5

          //
				  // [FUSING_DATA] ------------------------------
				  //	- PWR_LIMIT_H_0 ~ PWR_LIMIT_H_5
				  //	- PWR_LIMIT_L_0 ~ PWR_LIMIT_L_5

          // For backward compatability: old-ModelInfo(1=100mV, 1=100mA), new-ModelInfo(1=1mV, 1=1mA)
          if ValueExists('FUSING_DATA_mVmA','PWR_VOL_0') then begin bIsPower_mVmA := True;  sFusingDataSection := 'FUSING_DATA_mVmA'; end
          else                                                begin bIsPower_mVmA := False; sFusingDataSection := 'FUSING_DATA';      end;

          for i := DefPG.PWR_VCC to DefPG.PWR_MAX do begin
            case i of
              DefPG.PWR_VCC, DefPG.PWR_VDD_VEL : begin
                if bIsPower_mVmA then begin
                  PWR_VOL[i]     := Word(ReadInteger(sFusingDataSection, Format('PWR_VOL_%d',[i]),    0));
                  PWR_LIMIT_H[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_H_%d',[i]),0));
                  PWR_LIMIT_L[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_L_%d',[i]),0));
                  PWR_OFFSET[i]  := Word(ReadInteger(sFusingDataSection, Format('PWR_OFFSET_%d',[i]), 0)); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
                end
                else begin
                  PWR_VOL[i]     := Word(ReadInteger(sFusingDataSection, Format('PWR_VOL_%d',[i]),    0) * 100);
                  PWR_LIMIT_H[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_H_%d',[i]),0) * 100);
                  PWR_LIMIT_L[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_L_%d',[i]),0) * 100);
                  PWR_OFFSET[i]  := Word(ReadInteger(sFusingDataSection, Format('PWR_OFFSET_%d',[i]), 0) * 100); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
                end;
              end;
              DefPG.PWR_VBR : begin
                if bIsPower_mVmA then
                  PWR_VOL[i]   := Word(ReadInteger(sFusingDataSection, Format('PWR_VOL_%d',[i]), 3300))
                else
                  PWR_VOL[i]   := Word(3300); //3.30 * 1000
                PWR_OFFSET[i]  := Word(0); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
                PWR_LIMIT_H[i] := Word(0);
                PWR_LIMIT_L[i] := Word(0);
              end;
              DefPG.PWR_ICC, DefPG.PWR_IDD_IEL : begin
                PWR_VOL[i]     := Word(0);
                PWR_OFFSET[i]  := Word(0); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
                if bIsPower_mVmA then begin
                  PWR_LIMIT_H[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_H_%d',[i]),0));
                  PWR_LIMIT_L[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_L_%d',[i]),0));
                end
                else begin
                  if PWR_LIMIT_H[i] < 999 then begin
                    PWR_LIMIT_H[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_H_%d',[i-1]),0) * 100);
                    PWR_LIMIT_L[i] := Word(ReadInteger(sFusingDataSection, Format('PWR_LIMIT_L_%d',[i-1]),0) * 100);
                  end;
                end;
              end;
            end;
          end;

          // Power Sequence
				  //    - PWR_ON_SEQ_0 ~ PWR_ON_SEQ_3, PWR_OFF_SEQ_0 ~ PWR_OFF_SEQ_3
          for i := 0 to 3 do begin
            PowerOnSeq[i]   :=  word(ReadInteger('FUSING_DATA', 	Format('PWR_ON_SEQ_%d',[i]),  0));
            PowerOffSeq[i]  :=  word(ReadInteger('FUSING_DATA', 	Format('PWR_OFF_SEQ_%d',[i]), 0));
          end;
				  // Ext Power Sequence  //2021-11-05 DP201 EXT_POWER_SEQ
          //    - AvailCnt, OnIdx[0..24], OffIdx[0..24], OnDelay[0..24], OffDelay[0..24]
          PwrSeqExtUse      := ReadBool   ('EXT_POWER_SEQUENCE', 'PwrSeqExtUse',      False);
          PwrSeqExtAvailCnt := ReadInteger('EXT_POWER_SEQUENCE', 'PwrSeqExtAvailCnt', 1);
          for i := 0 to 5 do begin // 6~24 (Reserved)
            PwrSeqExtOnIdx[i]    := Byte(ReadInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOnIdx%d',   [i]), 0));
            PwrSeqExtOffIdx[i]   := Byte(ReadInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOffIdx%d',  [i]), 0));
            PwrSeqExtOnDelay[i]  := Word(ReadInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOnDelay%d', [i]), 0));
            PwrSeqExtOffDelay[i] := Word(ReadInteger('EXT_POWER_SEQUENCE', Format('PwrSeqExtOffDelay%d',[i]), 0));
          end;

        end; // with EdModelInfo[nCh] do begin

        //
        with FileModelInfo2 do begin
          //	- Model Parameters : PG/SPI Version  //2019-04-19 ALARM:FW_VERSION_MISMATCH
          PgFwVer  := ReadString('MODEL_DATA', 'PG_FW_VER',  '');  //2019-04-19 ALARM:FW_VERSION
          SpiFwVer := ReadString('MODEL_DATA', 'SPI_FW_VER', '');  //2019-04-19 ALARM:FW_VERSION

          {$IFDEF SUPPORT_1CG2PANEL}
          if not Common.SystemInfo.UseAssyPOCB then begin
          {$ENDIF}
            AssyModelInfo.UseCh1 := True; AssyModelInfo.LcmPosCh1 := LcmPosCP; AssyModelInfo.UseMainPidCh1 := True;
            AssyModelInfo.UseCh2 := True; AssyModelInfo.LcmPosCh2 := LcmPosCP; AssyModelInfo.UseMainPidCh2 := True;
          {$IFDEF SUPPORT_1CG2PANEL}
          end
          else begin
            AssyModelInfo.UseCh1 := ReadBool('ASSY_POCB_DATA', 'AssyPocbUseCh1', False);
            if AssyModelInfo.UseCh1 then begin
              AssyModelInfo.LcmPosCh1     := enumLcmPosition(ReadInteger('ASSY_POCB_DATA', 'AssyPocbLcmPosCh1', 0));
              AssyModelInfo.UseMainPidCh1 := ReadBool('ASSY_POCB_DATA', 'UseMainPidCh1',  False);
            end
            else begin
              AssyModelInfo.LcmPosCh1     := LcmPosCP;
              AssyModelInfo.UseMainPidCh1 := False;
            end;
            AssyModelInfo.UseCh2 := ReadBool('ASSY_POCB_DATA', 'AssyPocbUseCh2', False);
            if AssyModelInfo.UseCh2 then begin
              AssyModelInfo.LcmPosCh2     := enumLcmPosition(ReadInteger('ASSY_POCB_DATA', 'AssyPocbLcmPosCh2', 0));
              AssyModelInfo.UseMainPidCh2 := ReadBool('ASSY_POCB_DATA', 'UseMainPidCh2',  False);
            end
            else begin
              AssyModelInfo.LcmPosCh2     := LcmPosCP;
              AssyModelInfo.UseMainPidCh2 := False;
            end;
          end;
          {$ENDIF} //SUPPORT_1CG2PANEL

  			  // 	- POCB Option
          CamYCamPosCh1   := ReadFloat('MODEL_DATA', 'CAM1_Y_CAM_POS',   0.0);
          CamYCamPosCh2   := ReadFloat('MODEL_DATA', 'CAM2_Y_CAM_POS',   0.0);
          CamYLoadPosCh1  := ReadFloat('MODEL_DATA', 'CAM1_Y_LOAD_POS',  0.0);
          CamYLoadPosCh2  := ReadFloat('MODEL_DATA', 'CAM2_Y_LOAD_POS',  0.0);
          {$IFDEF HAS_MOTION_CAM_Z}
          CamZModelPosCh1 := ReadFloat('MODEL_DATA', 'CAM1_Z_MODEL_POS', 0.0);
          CamZModelPosCh2 := ReadFloat('MODEL_DATA', 'CAM2_Z_MODEL_POS', 0.0);
          {$ENDIF}
          {$IFDEF HAS_ROBOT_CAM_Z}
          RobotModelInfoCh1.Coord.X  := ReadFloat ('ROBOT_DATA', 'Robot1Coord_X',  0.0);
          RobotModelInfoCh1.Coord.Y  := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Y',  0.0);
          RobotModelInfoCh1.Coord.Z  := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Z',  0.0);
          RobotModelInfoCh1.Coord.Rx := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Rx', 0.0);
          RobotModelInfoCh1.Coord.Ry := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Ry', 0.0);
          RobotModelInfoCh1.Coord.Rz := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Rz', 0.0);
          RobotModelInfoCh1.ModelCmd := Trim(ReadString('ROBOT_DATA', 'Robot1ModelCmd', ''));
          RobotModelInfoCh2.Coord.X  := ReadFloat ('ROBOT_DATA', 'Robot2Coord_X',  0.0);
          RobotModelInfoCh2.Coord.Y  := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Y',  0.0);
          RobotModelInfoCh2.Coord.Z  := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Z',  0.0);
          RobotModelInfoCh2.Coord.Rx := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Rx', 0.0);
          RobotModelInfoCh2.Coord.Ry := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Ry', 0.0);
          RobotModelInfoCh2.Coord.Rz := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Rz', 0.0);
          RobotModelInfoCh2.ModelCmd := Trim(ReadString('ROBOT_DATA', 'Robot2ModelCmd', ''));
          {$ENDIF}

          //
          PowerOnPatNum    := ReadInteger('MODEL_DATA', 'PowerOnPatNum',   0); //2021-11-24 POWER_ON_PATTERN  //InitPatNum --> PowerOnPatNum
          PwrMeasurePatNum := ReadInteger('MODEL_DATA', 'PwrMeasurePatNum',0); //2022-09-06 POWER_MEASURE_PAT
          VerifyPatNum     := ReadInteger('MODEL_DATA', 'VerifyPatNum',    0);

          BcrLength    := ReadInteger('MODEL_DATA', 'BCR_LENGTH', DefPocb.BCR_LENGTH_DEFAULT);
          BcrPidChkIdx := ReadInteger('MODEL_DATA', 'BcrPidChkIdx', 0);    //A2CHv3:BCR_PID_CHECK
          BcrPidChkStr := ReadString ('MODEL_DATA', 'BcrPidChkStr', '');   //A2CHv3:BCR_PID_CHECK
          {$IFDEF FEATURE_BCR_SCAN_SPCB}
          BcrScanMesSPCB     := ReadBool ('MODEL_DATA', 'BcrScanMesSPCB',     True);  //A2CHv4:Lucid:ScanSPCB
          BcrSPCBIdInterlock := ReadBool ('MODEL_DATA', 'BcrSPCBIdInterlock', False); //A2CHv4:Lucid:ScanSPCB //2023-05-19 LGDVH:#301(A2CHv4):SPCB_ID_INTERLOCK
          {$ELSE}
          BcrScanMesSPCB     := False;
          BcrSPCBIdInterlock := False;
          {$ENDIF}
          {$IFDEF FEATURE_BCR_PID_INTERLOCK}
          BcrPIDInterlock := ReadBool ('MODEL_DATA', 'BcrPIDInterlock', False); //2023-09-24 LGDVH:#301:BCR_PID_INTERLOCK //2023-10-10 LENSVN:ATO:BCR_PID_INTERLOCK
          {$ELSE}
          BcrPIDInterlock := False;
          {$ENDIF}

          JudgeCount   := ReadInteger ('MODEL_DATA', 'JUDGE_CNT',    1);
          {$IFDEF FEATURE_UNIFORMITY_PUCONOFF}
          UsePucOnOff  := ReadBool    ('MODEL_DATA', 'UsePucOnOff', False); //2022-07-15 UNIFORMITY_VERIFY
          {$ENDIF}
          {$IFDEF FEATURE_PUC_IMAGE}
          UsePucImage  := ReadBool    ('MODEL_DATA', 'UsePucImage', False); //2023-04-07 FEATURE_PUC_IMAGE
          {$ENDIF}

          UseCustumPatName := ReadBool('MODEL_DATA', 'USE_CUSTOM_NAME', False);
          {$IFDEF FEATURE_UNIFORMITY_PUCONOFF}
					if UsePucOnOff then UseCustumPatName := True; //2022-07-15 UNIFORMITY_VERIFY
          {$ENDIF}
          for i := 0 to DefPocb.UNIFORMITY_PATTERN_MAX do begin
            sTemp := TernaryOp(i=0,'', (i+1).ToString);
            ComparedPat[i]  	:= ReadInteger('MODEL_DATA', 'COMPARED_PAT'+sTemp,    		0);
            WhiteUniform[i] 	:= ReadFloat  ('MODEL_DATA', 'WHITE_UNIFOM'+sTemp,    		70.0);
            ComparePatName[i] := ReadString ('MODEL_DATA', Format('COMPARED_PAT%d_NAME',[i+1]), '');
          end;
          {$IFDEF PANEL_AUTO}
          BmpDownRetryCnt     := Word(ReadInteger('MODEL_DATA', 'BmpDownRetryCnt', 0));
          {$ENDIF}

          {$IFDEF PANEL_AUTO}
          PwrOnDelayMsec  	  := ReadInteger('MODEL_DATA', 'PWR_ONOFF_DELAY', 1000); //for Backward-compatability
          PwrOnDelayMsec  		:= ReadInteger('MODEL_DATA', 'PwrOnDelayMsec',  PwrOnDelayMsec);
          PwrOffDelayMsec  		:= ReadInteger('MODEL_DATA', 'PwrOffDelayMsec', PwrOnDelayMsec);
          {$ELSE}
          PwrOnDelayMsec  		:= ReadInteger('MODEL_DATA', 'PwrOnDelayMsec',  3000);
          PwrOffDelayMsec  		:= ReadInteger('MODEL_DATA', 'PwrOffDelayMsec', 1000);
          {$ENDIF}
          {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
          PowerOnAgingSec  		:= ReadInteger('MODEL_DATA', 'PowerOnAgingSec', 10);
          {$ENDIF}

          UseScanFirst        := ReadBool   ('MODEL_DATA', 'USE_SCANFISRT', Common.SystemInfo.DefaultScanFist);
          UseVacuum           := ReadBool   ('MODEL_DATA', 'USE_VACUUM', True); //2019-06-24
          UseIonOnOff         := ReadBool   ('MODEL_DATA', 'USE_IONIZER_ON_OFF', False); //2019-09-26 Ionizer On/Off
          {$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2) or Defined(POCB_A2CHv3) or Defined(POCB_A2CHv4)}
          UseExLightFlow      := ReadBool   ('MODEL_DATA', 'UseExLightFlow', True);
          {$ELSE}
          UseExLightFlow      := ReadBool   ('MODEL_DATA', 'UseExLightFlow', False);
          {$ENDIF}

          CamTEndWait				  := ReadInteger('MODEL_DATA', 'CAMERA_TEND_WAIT_MIN', 5); //2019-05-22
          {$IF Defined(PANEL_FOLD) or Defined(PANEL_GAGO)}
          CamCBCount				  := ReadInteger('MODEL_DATA', 'CamCBCount', 1);
          UsePowerResetAfterEepromCBParaWrite := ReadBool ('MODEL_DATA', 'UsePowerResetAfterEepromCBParaWrite', False);
        	{$ENDIF}
          {$IFDEF HAS_DIO_PINBLOCK}
          UseCheckPinblock    := ReadBool   ('MODEL_DATA', 'UseCheckPinblock', False);
        	{$ENDIF}

				  //	- Model Parameters - EEPROM/FLASH
      {$IFDEF PANEL_AUTO}
        {$IFDEF SITE_LENSVN}
          EnablePwrMode 		     := True;
          EnableProcMask 		     := True;
          EnableFlashWriteCBData := True;
        {$ELSE} //LGDVH
          EnablePwrMode 		     := ReadBool('MODEL_DATA', 'ENABLE_PWR_OPT_MODE',    True);
          EnableProcMask 		     := ReadBool('MODEL_DATA', 'ENABLE_PROCESS_MASKING', True);
          {$IF Defined(POCB_A2CH) or Defined(POCB_A2CHv2)}
					EnableFlashWriteCBData := False;
					{$ELSE}
          EnableFlashWriteCBData := ReadBool('MODEL_DATA', 'ENABLE_FLASH_WRITE_CBDATA', Common.SystemInfo.UseGIB); //FLASH_WRITE_CBDATA
          {$ENDIF}
        {$ENDIF}
      {$ELSE} //FOLD|GAGO
          EnablePwrMode 		     := True;
          EnableProcMask 		     := False; // ReadBool('MODEL_DATA', 'ENABLE_PROCESS_MASKING',    False);
          EnableFlashWriteCBData := True;
      {$ENDIF}

          // DFS Option
          CombiModelInfoKey := Trim(ReadString('MODEL_INFO', 'COMBI_MODEL_INFO_KEY', ''));
          if CombiModelInfoKey = '' then begin
            sList := TStringList.Create;
            try
              ExtractStrings(['-'], ['-'], PWideChar(fName), sList);  //2019-04-07 (POCB: TestModel: e.g., LA177QD1-LT01)
              if sList.Count >= 1 then begin
                CombiModelInfoKey := sList[0]; //2019-04-07 (POCB: TestModel: e.g., LA177QD1-LT01 -> LA177QD1)
              end;
            finally
              sList.Free;
              sList := nil;
            end;
          end;
          // Log Upload Option
          LogUploadPanelModel := Trim(ReadString('MODEL_INFO', 'LogUploadPanelModel', ''));
          if LogUploadPanelModel = '' then begin
            sList := TStringList.Create;
            try
              ExtractStrings(['-'], ['-'], PWideChar(fName), sList);  // (POCB: TestModel: e.g., LA177QD1-LT01)
              if sList.Count >= 1 then begin
                LogUploadPanelModel := sList[0]; // (POCB: TestModel: e.g., LA177QD1-LT01 -> LA177QD1)
              end;
            finally
              sList.Free;
              sList := nil;
            end;
          end;

        end; //with EdModelInfo2[nCh]

				// MODEL_INFO ------------------------------
        FileModelInfo.PatGrpName        :=  ReadString('MODEL_INFO','Pattern_Group','');

        //DP200 ---------------------------------------------------------------- start
        if Common.SystemInfo.PG_TYPE <> DefPG.PG_TYPE_DP489 then begin
          with FileModelInfoALDP do begin
            SPI_PULLUP := Byte(ReadInteger('ALDP_MODEL_DATA', 'SPI_PULLUP', 0)); // 0: disable, 1: enable
            SPI_SPEED  := Byte(ReadInteger('ALDP_MODEL_DATA', 'SPI_SPEED',  0)); // 0: 400KHz, 1: 780KHz, 2: 1.5MHz, 3: 3MHz, 4: 6.25MHz, 5: 12.5MHz
            SPI_MODE   := Byte(ReadInteger('ALDP_MODEL_DATA', 'SPI_MODE',   0)); // 0: Library(0:Fixed?), 1: GPIO
            SPI_LEVEL  := Byte(ReadInteger('ALDP_MODEL_DATA', 'SPI_LEVEL',  0)); // 0: 1.2V, 1:1.8V, 2: 3.3V(Default 0)
            I2C_LEVEL  := Byte(ReadInteger('ALDP_MODEL_DATA', 'I2C_LEVEL',  0)); // 0: 1.2V, 1:1.8V, 2: 3.3V(Default 0)
            //
            ALPDP_LINK_RATE   := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_LINK_RATE', 5560)); // 5.56G(5560)
            ALPDP_H_FDP       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_H_FDP',     841));  // 841
            ALPDP_H_SDP       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_H_SDP',     16));   // 16
            ALPDP_H_PCNT      := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_H_PCNT',    876));  // 876
            ALPDP_VB_SLEEP    := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_SLEEP',  0));    // 0
            ALPDP_VB_N2       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N2',     0));    // 0
            ALPDP_VB_N3       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N3',     0));    // 0
            ALPDP_VB_N4       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N4',     0));    // 0
            ALPDP_VB_N5B      := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N5B',    122));  // 122
            ALPDP_VB_N7       := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N7',     0));    // 0
            ALPDP_VB_N5A      := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_VB_N5A',    0));    // 0
            //
            ALPDP_MSA_MVID    := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_MVID',    24)); // 24
            ALPDP_MSA_NVID    := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_NVID',    24)); // 24
            ALPDP_MSA_HTOTAL  := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HTOTAL',  16)); // 16
            ALPDP_MSA_HSTART  := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HSTART',  16)); // 16
            ALPDP_MSA_HWIDTH  := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HWIDTH',  16)); // 16
            ALPDP_MSA_VTOTAL  := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VTOTAL',  16)); // 16
            ALPDP_MSA_VSTART  := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VSTART',  16)); // 16
            ALPDP_MSA_VHEIGHT := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VHEIGHT', 16)); // 16
            ALPDP_MSA_HSP_HSW := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_HSP_HSW', 16)); // 16
            ALPDP_MSA_VSP_VSW := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_VSP_VSW', 16)); // 16
            ALPDP_MSA_MISC0   := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_MISC0',   8));  // 8
            ALPDP_MSA_MISC1   := Word(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_MSA_MISC1',   8));  // 8
            //
            ALPDP_SPECIAL_PANEL := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_SPECIAL_PANEL', 0)); // 0
            ALPDP_ALPM          := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_ALPM',          0)); // 0: Disable, 1: Enable
            ALPDP_LINK_MODE     := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_LINK_MODE',     0)); // 0: Manual, 1: Auto
            ALPDP_CHOP_SIZE     := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_CHOP_SIZE',     0));
            ALPDP_CHOP_SECTION  := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_CHOP_SECTION',  0));
            ALPDP_CHOP_ENABLE   := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_CHOP_ENABLE',   0));
            ALPDP_HPD_CHECK     := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_HPD_CHECK',     0)); // 0: HPD Check, 1: HPD Not Check(Default HPD Check)
            ALPDP_SCRAMBLE_SET  := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_SCRAMBLE_SET',  0)); // 0: Disable, 1: Enable
            ALPDP_LANE_SETTING  := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_LANE_SETTING',  4)); // 1~8 Lane
            ALPDP_SLAVE_ENABLE  := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_SLAVE_ENABLE',  0)); // 0: Disable, 1: Enable
            //
            ALPDP_SWING_LEVEL       := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_SWING_LEVEL',       6)); // default(6:600mVppd)
            ALPDP_PRE_EMPHASIS_PRE  := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_PRE_EMPHASIS_PRE',  7)); // default(7:1.67dB)
            ALPDP_PRE_EMPHASIS_POST := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_PRE_EMPHASIS_POST', 7)); // default(7:1.67dB)
            ALPDP_AUX_FREQ_SET      := Byte(ReadInteger('ALDP_MODEL_DATA', 'ALPDP_AUX_FREQ_SET',      5)); // default(5:1MHz)
            //
            DP141_IF_SET  := Byte(ReadInteger('ALDP_MODEL_DATA', 'DP141_IF_SET',  0));
            DP141_CNT_SET := Byte(ReadInteger('ALDP_MODEL_DATA', 'DP141_CNT_SET', 0));
            EDID_SKIP     := Byte(ReadInteger('ALDP_MODEL_DATA', 'EDID_SKIP',     0));
            DEBUG_LEVEL   := Byte(ReadInteger('ALDP_MODEL_DATA', 'DEBUG_LEVEL',   0));
            eDP_SPEC_OPT  := Byte(ReadInteger('ALDP_MODEL_DATA', 'eDP_SPEC_OPT',  0)); //2023-03-24 Tributo
          end;
        end;
        //DP200 ---------------------------------------------------------------- end
				
      except
        ShowMessage(fn + ' structure is different,'+#13#10+' Make again.');
      end;
    end;
  finally
    modelF.Free;
  //modelF := nil;
  end;
	//
//SetResolution(nCh,EdModelInfo[nCh].H_Active,EdModelInfo[nCh].V_Active);  //TBD:A2CHv3:MULTIPLE_MODEL?
  Result := True;
end;

//2023-03-06 REMOTE_UPDATE ....start
procedure TfrmModelInfo.btnGetModelInfo2SysInfoClick(Sender: TObject);
var
  TempList : TSearchRec;
  sFileMcf, sPathMcf, sModel2SysCsv : String;
	//
  i : Integer;
  bIsPower_mVmA : Boolean;     //MODELINFO_POWER_mVmA  //TBD:MERGE:MODELINFO_PG? Fold(O)
  sFusingDataSection : string; //MODELINFO_POWER_mVmA  //TBD:MERGE:MODELINFO_PG? Fold(O)
  modelF : TIniFile;
	TempModelInfo  : TMODELINFO;
	TempModelInfo2 : TModelInfo2;
  //
  sModelRecipe, sPowerOffset, sMotionPos, sRobotCoord : string;
  sHeader, sData : string;
begin
  try
    //
    sModel2SysCsv := Common.Path.MODEL + 'AutoPocbModel2SysInfo.txt';
    try
      DeleteFile(sModel2SysCsv);
    except
    end;
    //
    if FindFirst(Common.Path.MODEL + '*.mcf', faAnyFile, TempList) = 0 then begin
      repeat
				sFileMcf := TempList.Name;
				sPathMcf := Common.Path.MODEL + sFileMcf;
        Common.CodeSiteSend('<MODEL:MCF> '+ sPathMcf);
				//
        sModelRecipe := Copy(sFileMcf,1,8);
        sPowerOffset := '';
        sMotionPos   := '';
        sRobotCoord  := '';
        //
        modelF := TIniFile.Create(sPathMcf);
    		with modelF do begin
      	try
					// [MODEL_DATA] ------------------------------
        	with TempModelInfo do begin
            // For backward compatability: old-ModelInfo(1=100mV, 1=100mA), new-ModelInfo(1=1mV, 1=1mA)
            if ValueExists('FUSING_DATA_mVmA','PWR_VOL_0') then begin bIsPower_mVmA := True;  sFusingDataSection := 'FUSING_DATA_mVmA'; end
            else                                                begin bIsPower_mVmA := False; sFusingDataSection := 'FUSING_DATA';      end;
            for i := DefPG.PWR_VCC to DefPG.PWR_MAX do begin
              case i of
                DefPG.PWR_VCC, DefPG.PWR_VDD_VEL : begin
                  if bIsPower_mVmA then begin
                    PWR_OFFSET[i]  := Word(ReadInteger(sFusingDataSection, Format('PWR_OFFSET_%d',[i]), 0)); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
                  end
                  else begin
                    PWR_OFFSET[i]  := Word(ReadInteger(sFusingDataSection, Format('PWR_OFFSET_%d',[i]), 0) * 100); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
                  end;
                end;
              end;
            end;
            // Make sPowerOffset
            sPowerOffset := Format('%d',[TernaryOp(bIsPower_mVmA,1,0)]);
            sPowerOffset := sPowerOffset + Format(',%d,%d',[PWR_OFFSET[DefPG.PWR_VCC],PWR_OFFSET[DefPG.PWR_VDD_VEL]]);
        	end; //with TempModelInfo

					// [MODEL_DATA] ------------------------------
        	with TempModelInfo2 do begin

  			  	// 	Motion Pos
          	CamYCamPosCh1   := ReadFloat('MODEL_DATA', 'CAM1_Y_CAM_POS',   0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	CamYCamPosCh2   := ReadFloat('MODEL_DATA', 'CAM2_Y_CAM_POS',   0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	CamYLoadPosCh1  := ReadFloat('MODEL_DATA', 'CAM1_Y_LOAD_POS',  0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	CamYLoadPosCh2  := ReadFloat('MODEL_DATA', 'CAM2_Y_LOAD_POS',  0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	{$IFDEF HAS_MOTION_CAM_Z}
          	CamZModelPosCh1 := ReadFloat('MODEL_DATA', 'CAM1_Z_MODEL_POS', 0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	CamZModelPosCh2 := ReadFloat('MODEL_DATA', 'CAM2_Z_MODEL_POS', 0.0);                //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
            {$ENDIF}
            // Make sMotionPos
            sMotionPos := Format('%0.2f,%0.2f,%0.2f,%0.2f',[CamYCamPosCh1, CamYCamPosCh2, CamYLoadPosCh1, CamYLoadPosCh2]);
          	{$IFDEF HAS_MOTION_CAM_Z}
            sMotionPos := sMotionPos + Format(',%0.2f,%0.2f',[CamZModelPosCh1, CamZModelPosCh2]);
            {$ELSE}
            sMotionPos := sMotionPos + ',n/a,n/a';
          	{$ENDIF}

  			  	// Robot Coord
          	{$IFDEF HAS_ROBOT_CAM_Z}
          	RobotModelInfoCh1.Coord.X  := ReadFloat ('ROBOT_DATA', 'Robot1Coord_X',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
          	RobotModelInfoCh1.Coord.Y  := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Y',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	RobotModelInfoCh1.Coord.Z  := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Z',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	RobotModelInfoCh1.Coord.Rx := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Rx', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	RobotModelInfoCh1.Coord.Ry := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Ry', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	RobotModelInfoCh1.Coord.Rz := ReadFloat ('ROBOT_DATA', 'Robot1Coord_Rz', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	RobotModelInfoCh1.ModelCmd := Trim(ReadString('ROBOT_DATA', 'Robot1ModelCmd', '')); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
          	RobotModelInfoCh2.Coord.X  := ReadFloat ('ROBOT_DATA', 'Robot2Coord_X',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
          	RobotModelInfoCh2.Coord.Y  := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Y',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	RobotModelInfoCh2.Coord.Z  := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Z',  0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	RobotModelInfoCh2.Coord.Rx := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Rx', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	RobotModelInfoCh2.Coord.Ry := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Ry', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	RobotModelInfoCh2.Coord.Rz := ReadFloat ('ROBOT_DATA', 'Robot2Coord_Rz', 0.0);      //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo
          	RobotModelInfoCh2.ModelCmd := Trim(ReadString('ROBOT_DATA', 'Robot2ModelCmd', '')); //2023-03-07 TBD:REMOTE_UPDATE? (FromModelInfoToSystemInfo)
          	{$ENDIF}
            //
          	{$IFDEF HAS_ROBOT_CAM_Z}
            sRobotCoord := Format('%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f',[RobotModelInfoCh1.Coord.X,RobotModelInfoCh1.Coord.Y,RobotModelInfoCh1.Coord.Z,RobotModelInfoCh1.Coord.Rx,RobotModelInfoCh1.Coord.Ry,RobotModelInfoCh1.Coord.Rz]);
            sRobotCoord := sRobotCoord + Format(',%s',[RobotModelInfoCh1.ModelCmd]);
            sRobotCoord := sRobotCoord + Format(',%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f',[RobotModelInfoCh2.Coord.X,RobotModelInfoCh2.Coord.Y,RobotModelInfoCh2.Coord.Z,RobotModelInfoCh2.Coord.Rx,RobotModelInfoCh2.Coord.Ry,RobotModelInfoCh2.Coord.Rz]);
            sRobotCoord := sRobotCoord + Format(',%s',[RobotModelInfoCh2.ModelCmd]);
            {$ELSE}
            sRobotCoord := 'n/a,n/a,n/a,n/a,n/a,n/a';
            sRobotCoord := sRobotCoord + ',n/a';
            sRobotCoord := sRobotCoord + ',n/a,n/a,n/a,n/a,n/a,n/a';
            sRobotCoord := sRobotCoord + ',n/a';
          	{$ENDIF}
        	end; //with TempModelInfo2

          //
          sHeader := 'ModelName,ProjName,RecipeName';
          sData   := Format('%s,%s,%s',[sFileMcf,'',sModelRecipe]);
          sHeader := sHeader + ',Motion,CAM1_Y_CAM_POS,CAM2_Y_CAM_POS,CAM1_Y_LOAD_POS,CAM2_Y_LOAD_POS,CAM1_Z_MODEL_POS,CAM2_Z_MODEL_POS';
          sData   := sData   + Format(',Motion,%s',[sMotionPos]);
          sHeader := sHeader + ',Robot,Robot1Coord_X,Robot1Coord_Y,Robot1Coord_Z,Robot1Coord_Rx,Robot1Coord_Ry,Robot1Coord_Rz,Robot1ModelCmd,Robot2Coord_X,Robot2Coord_Y,Robot2Coord_Z,Robot2Coord_Rx,Robot2Coord_Ry,Robot2Coord_Rz,Robot2ModelCmd';
          sData   := sData   + Format(',Robot,%s',[sRobotCoord]);
          sHeader := sHeader + ',PowerOffset,PWR_OFFSET_0,PWR_OFFSET_1';
          sData   := sData   + Format(',%s',[sPowerOffset]);
          Common.MakeFile(sModel2SysCsv, sHeader, sData, 0, True{bForceDirectories});
        //Common.CodeSiteSend('<MODEL:MCF> '+ sData);

  			finally
    			modelF.Free;
  			end;

        // Make PowerOffset
        // Make MotionPos
        // Make RobotCoord
        // ???


        end;
      until FindNext(TempList) <> 0;
    end;
  finally
    FindClose(TempList);
  end;
end;

end.
