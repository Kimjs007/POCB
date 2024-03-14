unit AxtCAMCFS20;

interface

uses Windows, Messages, AxtLIBDef, CAMCFSDef;

{------------------------------------------------------------------------------------------------*
	AXTCAMCFS Library - CAMC-FS 2.0�̻� Motion module
	������ǰ
		SMC-1V02 - CAMC-FS Ver2.0 �̻� 1��
		SMC-2V02 - CAMC-FS Ver2.0 �̻� 2��
 *------------------------------------------------------------------------------------------------}

// ���� �ʱ�ȭ �Լ���        -======================================================================================
// CAMC-FS�� ������ ���(SMC-1V02, SMC-2V02)�� �˻��Ͽ� �ʱ�ȭ�Ѵ�. CAMC-FS 2.0�̻� �����Ѵ�
function InitializeCAMCFS20 (reset : Boolean) : Boolean; stdcall;
// reset	: 1(TRUE) = ��������(ī���� ��)�� �ʱ�ȭ�Ѵ�
//  reset(TRUE)�϶� �ʱ� ������.
//  1) ���ͷ�Ʈ ������� ����.
//  2) �������� ��� ������� ����.
//  3) �˶����� ��� ������� ����.
//  4) ������ ����Ʈ ��� ��� ��.
//  5) �������� ����Ʈ ��� ��� ��.            
//  6) �޽� ��� ��� : OneLowHighLow(Pulse : Active LOW, Direction : CW{High};CCW{LOW}).
//  7) �˻� ��ȣ : +������ ����Ʈ ��ȣ �ϰ� ����.
//  8) �Է� ���ڴ� ���� : 2��, 4 ü��.
//  9) �˶�, ��������, +-���� ���� ����Ʈ, +-������ ����Ʈ Active level : HIGH
// 10) ����/�ܺ� ī���� : 0.		
// CAMC-FS20 ����� ����� ���������� Ȯ���Ѵ�
function CFS20IsInitialized () : Boolean; stdcall;
// ���ϰ� :  1(TRUE) = CAMC-FS20 ����� ��� �����ϴ�
// CAMC-FS20�� ������ ����� ����� �����Ѵ�
procedure CFS20StopService (); stdcall;

/// ���� ���� ���� �Լ���        -===================================================================================
// ������ �ּҿ� ������ ���̽������� ��ȣ�� �����Ѵ�. ������ -1�� �����Ѵ�
function CFS20get_boardno (address : DWord) : SmallInt; stdcall;
// ���̽������� ������ �����Ѵ�
function CFS20get_numof_boards () : SmallInt; stdcall;
// ������ ���̽����忡 ������ ���� ������ �����Ѵ�
function CFS20get_numof_axes (nBoardNo : SmallInt) : SmallInt; stdcall;
// ���� ������ �����Ѵ�
function CFS20get_total_numof_axis () : SmallInt; stdcall;
// ������ ���̽������ȣ�� ����ȣ�� �ش��ϴ� ���ȣ�� �����Ѵ�
function CFS20get_axisno (nBoardNo : SmallInt; nModuleNo : SmallInt) : SmallInt; stdcall;
// ������ ���� ������ �����Ѵ�
// nBoardNo : �ش� ���� ������ ���̽������� ��ȣ.
// nModuleNo: �ش� ���� ������ ����� ���̽� ��峻 ��� ��ġ(0~3)
// bModuleID: �ش� ���� ������ ����� ID : SMC-2V02(0x02)
// nAxisPos : �ش� ���� ������ ����� ù��°���� �ι�° ������ ����.(0 : ù��°, 1 : �ι�°)
function CFS20get_axis_info (nAxisNo : SmallInt; nBoardNo : PSmallInt; nModuleNo : PSmallInt; bModuleID : PByte; nAxisPos : PSmallInt) : Boolean; stdcall;

// ���� ���� �Լ���        -========================================================================================
// ���� ���� �ʱⰪ�� ������ ���Ͽ��� �о �����Ѵ�
// Loading parameters.
//	1) 1Pulse�� �̵��Ÿ�(Move Unit / Pulse)
//	2) �ִ� �̵� �ӵ�, ����/���� �ӵ�
//	3) ���ڴ� �Է¹��, �޽� ��¹�� 
//	4) +������ ����Ʈ����, -������ ����Ʈ����, ������ ����Ʈ �������
//  5) +�������� ����Ʈ����,-�������� ����Ʈ����, �������� ����Ʈ �������
//  6) �˶�����, �˶� �������
//  7) ��������(��ġ�����Ϸ� ��ȣ)����, �������� �������
//  8) ������� �������
//  9) ���ڴ� �Է¹��2 ������
// 10) ����/�ܺ� ī���� : 0. 	
function CFS20load_parameter (axis : SmallInt; nfilename : PChar) : Boolean; stdcall;
// ���� ���� �ʱⰪ�� ������ ���Ͽ� �����Ѵ�.
// Saving parameters.
//	1) 1Pulse�� �̵��Ÿ�(Move Unit / Pulse)
//	2) �ִ� �̵� �ӵ�, ����/���� �ӵ�
//	3) ���ڴ� �Է¹��, �޽� ��¹�� 
//	4) +������ ����Ʈ����, -������ ����Ʈ����, ������ ����Ʈ �������
//  5) +�������� ����Ʈ����,-�������� ����Ʈ����, �������� ����Ʈ �������
//  6) �˶�����, �˶� �������
//  7) ��������(��ġ�����Ϸ� ��ȣ)����, �������� �������
//  8) ������� �������
//  9) ���ڴ� �Է¹��2 ������
function CFS20save_parameter (axis : SmallInt; nfilename : PChar) : Boolean; stdcall;
// ��� ���� �ʱⰪ�� ������ ���Ͽ��� �о �����Ѵ�
function CFS20load_parameter_all (nfilename : PChar) : Boolean; stdcall;
// ��� ���� �ʱⰪ�� ������ ���Ͽ� �����Ѵ�
function CFS20save_parameter_all (nfilename : PChar) : Boolean; stdcall;	

// ���ͷ�Ʈ �Լ���   -================================================================================================
//(���ͷ�Ʈ�� ����ϱ� ���ؼ��� 
//Window message & procedure
//    hWnd    : ������ �ڵ�, ������ �޼����� ������ ���. ������� ������ NULL�� �Է�.
//    wMsg    : ������ �ڵ��� �޼���, ������� �ʰų� ����Ʈ���� ����Ϸ��� 0�� �Է�.
//    proc    : ���ͷ�Ʈ �߻��� ȣ��� �Լ��� ������, ������� ������ NULL�� �Է�.
procedure CFS20SetWindowMessage (hWnd : HWND; wMsg : Word; proc : AXT_CAMCFS_INTERRUPT_PROC); stdcall;
//-===============================================================================
// ReadInterruptFlag���� ������ ���� flag������ �о� ���� �Լ�(���ͷ�Ʈ service routine���� ���ͷ��� �߻� ������ �Ǻ��Ѵ�.)
// ���ϰ�: ���ͷ�Ʈ�� �߻� �Ͽ����� �߻��ϴ� ���ͷ�Ʈ flag register(CAMC-FS20 �� INTFLAG ����.)
function CFS20read_interrupt_flag (axis : SmallInt) : DWord; stdcall;

// ���� ���� �ʱ�ȭ �Լ���        -==================================================================================
// ����Ŭ�� ����( ��⿡ ������ Oscillator�� ����� ��쿡�� ����)
procedure CFS20KeSetMainClk (nMainClk : LongInt); stdcall;
// Drive mode 1�� ����/Ȯ���Ѵ�.
procedure CFS20set_drive_mode1 (axis : SmallInt; decelstartpoint : Byte; pulseoutmethod : Byte; detectsignal : Byte); stdcall;
function CFS20get_drive_mode1 (axis : SmallInt) : Byte; stdcall;
// decelstartpoint : �����Ÿ� ���� ��� ����� ���� ��ġ ���� ��� ����(0 : �ڵ� ������, 1 : ���� ������)
// pulseoutmethod : ��� �޽� ��� ����(typedef : PULSE_OUTPUT)
// detecsignal : ��ȣ �˻�-1/2 ���� ��� ����� �˻� �� ��ȣ ����(typedef : DETECT_DESTINATION_SIGNAL)
// Drive mode 2�� ����/Ȯ���Ѵ�.
procedure CFS20set_drive_mode2 (axis : SmallInt; encmethod : Byte; inpactivelevel : Byte; alarmactivelevel : Byte; nslmactivelevel : Byte; pslmactivelevel : Byte; nelmactivelevel : Byte; pelmactivelevel : Byte); stdcall;
function CFS20get_drive_mode2 (axis : SmallInt) : Word; stdcall;
// Unit/Pulse ����/Ȯ���Ѵ�.
procedure CFS20set_moveunit_perpulse (axis : SmallInt; unitperpulse : Double); stdcall;
function CFS20get_moveunit_perpulse (axis : SmallInt) : Double; stdcall;
// Unit/Pulse : 1 pulse�� ���� system�� �̵��Ÿ��� ���ϸ�, �̶� Unit�� ������ ����ڰ� ���Ƿ� ������ �� �ִ�.
// Ex) Ball screw pitch : 10mm, ���� 1ȸ���� �޽��� : 10000 ==> Unit�� mm�� ������ ��� : Unit/Pulse = 10/10000.
// ���� unitperpulse�� 0.001�� �Է��ϸ� ��� ��������� mm�� ������. 
// Ex) Linear motor�� ���ش��� 1 pulse�� 2 uM. ==> Unit�� mm�� ������ ��� : Unit/Pulse = 0.002/1.
// Unit/Pulse�� ��������
// pulse/Unit ����/Ȯ���Ѵ�.
procedure CFS20set_movepulse_perunit (axis : SmallInt; pulseperunit : Double); stdcall;
function CFS20get_movepulse_perunit (axis : SmallInt) : Double; stdcall;
// ���� �ӵ� ����/Ȯ���Ѵ�.(Unit/Sec)
procedure CFS20set_startstop_speed (axis : SmallInt; velocity : Double); stdcall;
function CFS20get_startstop_speed (axis : SmallInt) : Double; stdcall;
// �ְ� �ӵ� ���� Unit/Sec. ���� system�� �ְ� �ӵ��� �����Ѵ�.
function CFS20set_max_speed (axis : SmallInt; max_velocity : Double) : Boolean; stdcall;
function CFS20get_max_speed (axis : SmallInt) : Double; stdcall;
// Unit/Pulse ������ ���ۼӵ� ���� ���Ŀ� �����Ѵ�.
// ������ �ְ� �ӵ� �̻����δ� ������ �Ҽ� �����Ƿ� �����Ѵ�.
// SW�� ����� ���� ����/Ȯ���Ѵ�. �̰����� S-Curve ������ percentage�� ���� �����ϴ�.
procedure CFS20set_s_rate (axis : SmallInt; a_percent : Double; b_percent : Double); stdcall;
procedure CFS20get_s_rate (axis : SmallInt; a_percent : PDouble; b_percent : PDouble); stdcall;
// ���� ������ ��忡�� �ܷ� �޽��� ����/Ȯ���Ѵ�.
procedure CFS20set_slowdown_rear_pulse (axis : SmallInt; ulData : DWord); stdcall;
function CFS20get_slowdown_rear_pulse (axis : SmallInt) : DWord; stdcall;
// ���� ���� ���� ���� ������ ���� ����� ����/Ȯ���Ѵ�.
function CFS20set_decel_point (axis : SmallInt; method : Byte) : Boolean; stdcall;
function CFS20get_decel_point (axis : SmallInt) : Byte; stdcall;
// 0x0 : �ڵ� ������.
// 0x1 : ���� ������.

// ���� ���� Ȯ�� �Լ���        -=====================================================================================
// ���� ���� �޽� ����������� Ȯ���Ѵ�.
function CFS20in_motion (axis : SmallInt) : Boolean; stdcall;
// ���� ���� �޽� ����� ����ƴ��� Ȯ���Ѵ�.
function CFS20motion_done (axis : SmallInt) : Boolean; stdcall;
// ���� ���� �������� ���� ��µ� �޽� ī���� ���� Ȯ���Ѵ�. (Pulse)
function CFS20get_drive_pulse_counts (axis : SmallInt) : LongInt; stdcall;
// ���� ���� DriveStatus �������͸� Ȯ���Ѵ�.
function CFS20get_drive_status (axis : SmallInt) : Word; stdcall;
// ���� ���� EndStatus �������͸� Ȯ���Ѵ�.
function CFS20get_end_status (axis : SmallInt) : Word; stdcall;
// End Status Bit�� �ǹ�
// 14bit : Limit(PELM, NELM, PSLM, NSLM, Soft)�� ���� ����
// 13bit : Limit ���� ������ ���� ����
// 12bit : Sensor positioning drive����
// 11bit : Preset pulse drive�� ���� ����(������ ��ġ/�Ÿ���ŭ �����̴� �Լ���)
// 10bit : ��ȣ ���⿡ ���� ����(Signal Search-1/2 drive����)
// 9 bit : ���� ���⿡ ���� ����
// 8 bit : Ż�� ������ ���� ����
// 7 bit : ����Ÿ ���� ������ ���� ����
// 6 bit : ALARM ��ȣ �Է¿� ���� ����
// 5 bit : ������ ��ɿ� ���� ����
// 4 bit : �������� ��ɿ� ���� ����
// 3 bit : ������ ��ȣ �Է¿� ���� ���� (EMG Button)
// 2 bit : �������� ��ȣ �Է¿� ���� ����
// 1 bit : Limit(PELM, NELM, Soft) �������� ���� ����
// 0 bit : Limit(PSLM, NSLM, Soft) ���������� ���� ����
// ���� ���� Mechanical �������͸� Ȯ���Ѵ�.
function CFS20get_mechanical_signal (axis : SmallInt) : Word; stdcall;
// Mechanical Signal Bit�� �ǹ�
// 12bit : ESTOP ��ȣ �Է� Level
// 11bit : SSTOP ��ȣ �Է� Level
// 10bit : MARK ��ȣ �Է� Level
// 9 bit : EXPP(MPG) ��ȣ �Է� Level
// 8 bit : EXMP(MPG) ��ȣ �Է� Level
// 7 bit : Encoder Up��ȣ �Է� Level(A�� ��ȣ)
// 6 bit : Encoder Down��ȣ �Է� Level(B�� ��ȣ)
// 5 bit : INPOSITION ��ȣ Active ����
// 4 bit : ALARM ��ȣ Active ����
// 3 bit : -Limit �������� ��ȣ Active ���� (Ver3.0���� ����������)
// 2 bit : +Limit �������� ��ȣ Active ���� (Ver3.0���� ����������)
// 1 bit : -Limit ������ ��ȣ Active ����
// 0 bit : +Limit ������ ��ȣ Active ����
// ���� ����  ���� �ӵ��� �о� �´�.(Unit/Sec)
function CFS20get_velocity (axis : SmallInt) : Double; stdcall;
// ���� ���� Command position�� Actual position�� ���� Ȯ���Ѵ�.
function CFS20get_error (axis : SmallInt) : Double; stdcall;
// ���� ���� ���� ����̺��� �̵� �Ÿ��� Ȯ�� �Ѵ�. (Unit)
function CFS20get_drivedistance (axis : SmallInt) : Double; stdcall;

// Encoder �Է� ��� ���� �Լ���        -=============================================================================
// ���� ���� Encoder �Է� ����� ����/Ȯ���Ѵ�.
function CFS20set_enc_input_method (axis : SmallInt; method : Byte) : Boolean; stdcall;
function CFS20get_enc_input_method (axis : SmallInt) : Byte; stdcall;
// method : typedef(EXTERNAL_COUNTER_INPUT)
// UpDownMode = 0x0    // Up/Down
// Sqr1Mode   = 0x1    // 1ü��
// Sqr2Mode   = 0x2    // 2ü��
// Sqr4Mode   = 0x3    // 4ü��
// ���� ���� �ܺ� ��ġ counter clear�� ����� ����/Ȯ���Ѵ�.
function CFS20set_enc2_input_method (axis : SmallInt; method : Byte) : Boolean; stdcall;
function CFS20get_enc2_input_method (axis : SmallInt) : Byte; stdcall;
// method : CAMC-FS chip �޴��� EXTCNTCLR �������� ����.
// ���� ���� �ܺ� ��ġ counter�� count ����� ����/Ȯ���Ѵ�.
function CFS20set_enc_reverse (axis : SmallInt; reverse : Byte) : Boolean; stdcall;
function CFS20get_enc_reverse (axis : SmallInt) : Boolean; stdcall;
// reverse :
// TRUE  : �Է� ���ڴ��� �ݴ�Ǵ� �������� count�Ѵ�.
// FALSE : �Է� ���ڴ��� ���� ���������� count�Ѵ�.

// �޽� ��� ��� �Լ���        -=====================================================================================
// �޽� ��� ����� ����/Ȯ���Ѵ�.
function CFS20set_pulse_out_method (axis : SmallInt; method : Byte) : Boolean; stdcall;
function CFS20get_pulse_out_method (axis : SmallInt) : Byte; stdcall;
// method : ��� �޽� ��� ����(typedef : PULSE_OUTPUT)
// OneHighLowHigh   = 0x0, 1�޽� ���, PULSE(Active High), ������(DIR=Low)  / ������(DIR=High)
// OneHighHighLow   = 0x1, 1�޽� ���, PULSE(Active High), ������(DIR=High) / ������(DIR=Low)
// OneLowLowHigh    = 0x2, 1�޽� ���, PULSE(Active Low),  ������(DIR=Low)  / ������(DIR=High)
// OneLowHighLow    = 0x3, 1�޽� ���, PULSE(Active Low),  ������(DIR=High) / ������(DIR=Low)
// TwoCcwCwHigh     = 0x4, 2�޽� ���, PULSE(CCW:������),  DIR(CW:������),  Active High 
// TwoCcwCwLow      = 0x5, 2�޽� ���, PULSE(CCW:������),  DIR(CW:������),  Active Low 
// TwoCwCcwHigh     = 0x6, 2�޽� ���, PULSE(CW:������),   DIR(CCW:������), Active High
// TwoCwCcwLow      = 0x7, 2�޽� ���, PULSE(CW:������),   DIR(CCW:������), Active Low

//��ġ Ȯ�� �� ��ġ �� ���� �Լ��� -===============================================================================
// �ܺ� ��ġ ���� �����Ѵ�. ������ ���¿��� �ܺ� ��ġ�� Ư�� ������ ����/Ȯ���Ѵ�.(position = Unit)
procedure CFS20set_actual_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_actual_position (axis : SmallInt) : Double; stdcall;
// ���� ��ġ ���� �����Ѵ�. ������ ���¿��� ���� ��ġ�� Ư�� ������ ����/Ȯ���Ѵ�.(position = Unit)
procedure CFS20set_command_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_command_position (axis : SmallInt) : Double; stdcall;

// ���� ����̹� ��� ��ȣ ���� �Լ���-===============================================================================
// ���� Enable��� ��ȣ�� Active Level�� ����/Ȯ���Ѵ�.
function CFS20set_servo_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_servo_level (axis : SmallInt) : Byte; stdcall;
// ���� Enable(On) / Disable(Off)�� ����/Ȯ���Ѵ�.
function CFS20set_servo_enable (axis : SmallInt; state : Byte) : Boolean; stdcall;
function CFS20get_servo_enable (axis : SmallInt) : Byte; stdcall;	

// ���� ����̹� �Է� ��ȣ ���� �Լ���-===============================================================================
// ���� ��ġ�����Ϸ�(inposition)�Է� ��ȣ�� ��������� ����/Ȯ���Ѵ�.
function CFS20set_inposition_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_inposition_enable (axis : SmallInt) : Byte; stdcall;
// ���� ��ġ�����Ϸ�(inposition)�Է� ��ȣ�� Active Level�� ����/Ȯ��/����Ȯ���Ѵ�.
function CFS20set_inposition_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_inposition_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_inposition_switch (axis : SmallInt) : Byte; stdcall;
function CFS20in_position (axis : SmallInt) : Boolean; stdcall;
// ���� �˶� �Է½�ȣ ����� ��������� ����/Ȯ���Ѵ�.
function CFS20set_alarm_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_alarm_enable (axis : SmallInt) : Byte; stdcall;
// ���� �˶� �Է� ��ȣ�� Active Level�� ����/Ȯ��/����Ȯ���Ѵ�.
function CFS20set_alarm_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_alarm_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_alarm_switch (axis : SmallInt) : Byte; stdcall;

// ����Ʈ ��ȣ ���� �Լ���-===========================================================================================
// ������ ����Ʈ ��� ��������� ����/Ȯ���Ѵ�.
function CFS20set_end_limit_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_end_limit_enable (axis : SmallInt) : Byte; stdcall;
// -������ ����Ʈ �Է� ��ȣ�� Active Level�� ����/Ȯ��/����Ȯ���Ѵ�.
function CFS20set_nend_limit_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_nend_limit_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_nend_limit_switch (axis : SmallInt) : Byte; stdcall;
// +������ ����Ʈ �Է� ��ȣ�� Active Level�� ����/Ȯ��/����Ȯ���Ѵ�.
function CFS20set_pend_limit_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_pend_limit_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_pend_limit_switch (axis : SmallInt) : Byte; stdcall;
// �������� ����Ʈ ��� ��������� ����/Ȯ���Ѵ�.
function CFS20set_slow_limit_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_slow_limit_enable (axis : SmallInt) : Byte; stdcall;
// -�������� ����Ʈ �Է� ��ȣ�� Active Level�� ����/Ȯ��/����Ȯ���Ѵ�.
function CFS20set_nslow_limit_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_nslow_limit_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_nslow_limit_switch (axis : SmallInt) : Byte; stdcall;
// +�������� ����Ʈ �Է� ��ȣ�� Active Level�� ����/Ȯ��/����Ȯ���Ѵ�.
function CFS20set_pslow_limit_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_pslow_limit_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_pslow_limit_switch (axis : SmallInt) : Byte; stdcall;
// -LIMIT ���� ������ ��/�������� ���θ� ����/Ȯ���Ѵ�. (Ver 3.0���� ����)
function CFS20set_nlimit_sel (axis : SmallInt; stop : Byte) : Boolean; stdcall;
function CFS20get_nlimit_sel (axis : SmallInt) : Byte; stdcall;
// stop:
// 0 : ������, 1 : ��������
// +LIMIT ���� ������ ��/�������� ���θ� ����/Ȯ���Ѵ�. (Ver 3.0���� ����)	
function CFS20set_plimit_sel (axis : SmallInt; stop : Byte) : Boolean; stdcall;
function CFS20get_plimit_sel (axis : SmallInt) : Byte; stdcall;
// stop:
// 0 : ������, 1 : ��������

// ����Ʈ���� ����Ʈ ���� �Լ���-=====================================================================================
// ����Ʈ���� ����Ʈ ��������� ����/Ȯ���Ѵ�.
procedure CFS20set_soft_limit_enable (axis : SmallInt; use : Byte); stdcall;
function CFS20get_soft_limit_enable (axis : SmallInt) : Byte; stdcall;
// ����Ʈ���� ����Ʈ ���� ������ġ������ ����/Ȯ���Ѵ�.
procedure CFS20set_soft_limit_sel (axis : SmallInt; sel : Byte); stdcall;
function CFS20get_soft_limit_sel (axis : SmallInt) : Byte; stdcall;
// sel :
// 0x0 : ������ġ�� ���Ͽ� ����Ʈ���� ����Ʈ ��� ����.
// 0x1 : �ܺ���ġ�� ���Ͽ� ����Ʈ���� ����Ʈ ��� ����.
// ����Ʈ���� ����Ʈ �߻��� ���� ��带 ����/Ȯ���Ѵ�.
procedure CFS20set_soft_limit_stopmode (axis : SmallInt; mode : Byte); stdcall;
function CFS20get_soft_limit_stopmode (axis : SmallInt) : Byte; stdcall;
// mode :
// 0x0 : ����Ʈ���� ����Ʈ ��ġ���� ������ �Ѵ�.
// 0x1 : ����Ʈ���� ����Ʈ ��ġ���� �������� �Ѵ�.
// ����Ʈ���� ����Ʈ -��ġ�� ����/Ȯ���Ѵ�.(position = Unit)
procedure CFS20set_soft_nlimit_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_soft_nlimit_position (axis : SmallInt) : Double; stdcall;
// ����Ʈ���� ����Ʈ +��ġ�� ����/Ȯ�� �Ѵ�.(position = Unit)
procedure CFS20set_soft_plimit_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_soft_plimit_position (axis : SmallInt) : Double; stdcall;

// ������� ��ȣ-=====================================================================================================
// ESTOP, SSTOP ��ȣ ��������� ����/Ȯ���Ѵ�.(Emergency stop, Slow-Down stop)
function CFS20set_emg_signal_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_emg_signal_enable (axis : SmallInt) : Byte; stdcall;
// ��������� ��/�������� ���θ� ����/Ȯ���Ѵ�.
function CFS20set_stop_sel (axis : SmallInt; stop : Byte) : Boolean; stdcall;
function CFS20get_stop_sel (axis : SmallInt) : Byte; stdcall;
// stop:
// 0 : ������, 1 : ��������

// ���� ���� �Ÿ� ����-===============================================================================================
// start_** : ���� �࿡�� ���� ������ �Լ��� return�Ѵ�. "start_*" �� ������ �̵� �Ϸ��� return�Ѵ�(Blocking).
// *r*_*    : ���� �࿡�� �Էµ� �Ÿ���ŭ(�����ǥ)�� �̵��Ѵ�. "*r_*�� ������ �Էµ� ��ġ(������ǥ)�� �̵��Ѵ�.
// *s*_*    : ������ �ӵ� ���������� "S curve"�� �̿��Ѵ�. "*s_*"�� ���ٸ� ��ٸ��� �������� �̿��Ѵ�.
// *a*_*    : ������ �ӵ� �����ӵ��� ���Ī���� ����Ѵ�. ���ӷ� �Ǵ� ���� �ð���  ���ӷ� �Ǵ� ���� �ð��� ���� �Է¹޴´�.
// *_ex     : ������ �����ӵ��� ���� �Ǵ� ���� �ð����� �Է� �޴´�. "*_ex"�� ���ٸ� �����ӷ��� �Է� �޴´�.
// �Է� ����: velocity(Unit/Sec), acceleration/deceleration(Unit/Sec^2), acceltime/deceltime(Sec), position(Unit)

// ��Ī �����޽�(Pulse Drive), ��ٸ��� ���� �Լ�, ����/�����ǥ(r), ������/���ӽð�(_ex)(�ð�����:Sec)
// Blocking�Լ� (������� �޽� ����� �Ϸ�� �� �Ѿ��)
function CFS20move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double) : Word; stdcall;
function CFS20move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double) : Word; stdcall;
function CFS20r_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double) : Word; stdcall;
function CFS20r_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double) : Word; stdcall;
// Non Blocking�Լ� (�������� ��� ���õ�)
function CFS20start_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double) : Boolean; stdcall;
function CFS20start_r_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_r_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double) : Boolean; stdcall;
// ���Ī �����޽�(Pulse Drive), ��ٸ��� ���� �Լ�, ����/�����ǥ(r), ������/���ӽð�(_ex)(�ð�����:Sec)
// Blocking�Լ� (������� �޽� ����� �Ϸ�� �� �Ѿ��)
function CFS20a_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double; deceleration : Double) : Word; stdcall;
function CFS20a_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double; deceltime : Double) : Word; stdcall;
function CFS20ra_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double) : Word; stdcall;
function CFS20ra_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double) : Word; stdcall;
// Non Blocking�Լ� (�������� ��� ���õ�)
function CFS20start_a_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20start_a_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;
function CFS20start_ra_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20start_ra_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;
// ��Ī �����޽�(Pulse Drive), S���� ����, ����/�����ǥ(r), ������/���ӽð�(_ex)(�ð�����:Sec)
// Blocking�Լ� (������� �޽� ����� �Ϸ�� �� �Ѿ��)
function CFS20s_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double) : Word; stdcall;
function CFS20s_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double) : Word; stdcall;
function CFS20rs_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double) : Word; stdcall;
function CFS20rs_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double) : Word; stdcall;
// Non Blocking�Լ� (�������� ��� ���õ�)
function CFS20start_s_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_s_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double) : Boolean; stdcall;
function CFS20start_rs_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_rs_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double) : Boolean; stdcall;
// ���Ī �����޽�(Pulse Drive), S���� ����, ����/�����ǥ(r), ������/���ӽð�(_ex)(�ð�����:Sec)
// Blocking�Լ� (������� �޽� ����� �Ϸ�� �� �Ѿ��)
function CFS20as_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double; deceleration : Double) : Word; stdcall;
function CFS20as_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double; deceltime : Double) : Word; stdcall;
function CFS20ras_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double) : Word; stdcall;
function CFS20ras_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double) : Word; stdcall;
// Non Blocking�Լ� (�������� ��� ���õ�), jerk���(���� : �ۼ�Ʈ) ���������� S�� �̵�����.
function CFS20start_as_move (axis : SmallInt; position : Double; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20start_as_move2 (axis : SmallInt; position : Double; velocity : Double; acceleration : Double; deceleration : Double; jerk : Double) : Boolean; stdcall;
function CFS20start_as_move_ex (axis : SmallInt; position : Double; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;
function CFS20start_ras_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20start_ras_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;

// ��Ī ���� �޽�(Pulse Drive), S���� ����, �����ǥ, ������,
// Non Blocking (�������� ��� ���õ�), ���� ��ġ�� �������� over_distance���� over_velocity�� �ӵ��� ���� �Ѵ�.
function CFS20start_rs_move_override (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; over_distance : Double; over_velocity : Double; Target : Boolean) : Boolean; stdcall;

// ���� ���� ����-====================================================================================================
// ���� �����ӵ� �� �ӵ��� ���� ������ �߻����� ������ ���������� �����Ѵ�.
// *s*_*    : ������ �ӵ� ���������� "S curve"�� �̿��Ѵ�. "*s_*"�� ���ٸ� ��ٸ��� �������� �̿��Ѵ�.
// *a*_*    : ������ �ӵ� �����ӵ��� ���Ī���� ����Ѵ�. ���ӷ� �Ǵ� ���� �ð���  ���ӷ� �Ǵ� ���� �ð��� ���� �Է¹޴´�.
// *_ex     : ������ �����ӵ��� ���� �Ǵ� ���� �ð����� �Է� �޴´�. "*_ex"�� ���ٸ� �����ӷ��� �Է� �޴´�.

// ���ӵ� ��ٸ��� ���� �Լ���, ������/���ӽð�(_ex)(�ð�����:Sec) - �������� ��쿡�� �ӵ��������̵�
// ��Ī ������ �����Լ�
function CFS20v_move (axis : SmallInt; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20v_move_ex (axis : SmallInt; velocity : Double; acceltime : Double) : Boolean; stdcall;
// ���Ī ������ �����Լ�
function CFS20v_a_move (axis : SmallInt; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20v_a_move_ex (axis : SmallInt; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;
// ���ӵ� S���� ���� �Լ���, ������/���ӽð�(_ex)(�ð�����:Sec) - �������� ��쿡�� �ӵ��������̵�
// ��Ī ������ �����Լ�
function CFS20v_s_move (axis : SmallInt; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20v_s_move_ex (axis : SmallInt; velocity : Double; acceltime : Double) : Boolean; stdcall;
// ���Ī ������ �����Լ�
function CFS20v_as_move (axis : SmallInt; velocity : Double; acceleration : Double; deceleration : Double) : Boolean; stdcall;
function CFS20v_as_move_ex (axis : SmallInt; velocity : Double; acceltime : Double; deceltime : Double) : Boolean; stdcall;

// ��ȣ ���� ����-====================================================================================================
// ���� ��ȣ�� ����/���� ������ �˻��Ͽ� ������ �Ǵ� ���������� �� �� �ִ�.
// detect_signal : �˻� ��ȣ ����(typedef : DETECT_DESTINATION_SIGNAL)
// PElmNegativeEdge    = 0x0,        // +Elm(End limit) �ϰ� edge
// NElmNegativeEdge    = 0x1,        // -Elm(End limit) �ϰ� edge
// PSlmNegativeEdge    = 0x2,        // +Slm(Slowdown limit) �ϰ� edge
// NSlmNegativeEdge    = 0x3,        // -Slm(Slowdown limit) �ϰ� edge
// In0DownEdge         = 0x4,        // IN0(ORG) �ϰ� edge
// In1DownEdge         = 0x5,        // IN1(Z��) �ϰ� edge
// In2DownEdge         = 0x6,        // IN2(����) �ϰ� edge
// In3DownEdge         = 0x7,        // IN3(����) �ϰ� edge
// PElmPositiveEdge    = 0x8,        // +Elm(End limit) ��� edge
// NElmPositiveEdge    = 0x9,        // -Elm(End limit) ��� edge
// PSlmPositiveEdge    = 0xa,        // +Slm(Slowdown limit) ��� edge
// NSlmPositiveEdge    = 0xb,        // -Slm(Slowdown limit) ��� edge
// In0UpEdge           = 0xc,        // IN0(ORG) ��� edge
// In1UpEdge           = 0xd,        // IN1(Z��) ��� edge
// In2UpEdge           = 0xe,        // IN2(����) ��� edge
// In3UpEdge           = 0xf         // IN3(����) ��� edge
// Signal Search1 : ���� ������ �Է� �ӵ����� �����Ͽ�, ��ȣ ������ ���� ����.
// Signal Search2 : ���� ������ ���Ӿ��� �Է� �ӵ��� �ǰ�, ��ȣ ������ ������. 
// ���� : Signal Search2�� �������� �����Ƿ� �ӵ��� ������� Ż���� �ⱸ���� ������ ���� �����Ƿ� �����Ѵ�.
// *s*_*    : ������ �ӵ� ���������� "S curve"�� �̿��Ѵ�. "*s_*"�� ���ٸ� ��ٸ��� �������� �̿��Ѵ�.
// *_ex     : ������ �����ӵ��� ���� �Ǵ� ���� �ð����� �Է� �޴´�. "*_ex"�� ���ٸ� �����ӷ��� �Է� �޴´�.

// ��ȣ����1(Signal search 1) ��ٸ��� ����, ������/���ӽð�(_ex)(�ð�����:Sec)
function CFS20start_signal_search1 (axis : SmallInt; velocity : Double; acceleration : Double; detect_signal : Byte) : Boolean; stdcall;
function CFS20start_signal_search1_ex (axis : SmallInt; velocity : Double; acceltime : Double; detect_signal : Byte) : Boolean; stdcall;
// ��ȣ����1(Signal search 1) S���� ����, ������/���ӽð�(_ex)(�ð�����:Sec)
function CFS20start_s_signal_search1 (axis : SmallInt; velocity : Double; acceleration : Double; detect_signal : Byte) : Boolean; stdcall;
function CFS20start_s_signal_search1_ex (axis : SmallInt; velocity : Double; acceltime : Double; detect_signal : Byte) : Boolean; stdcall;
// ��ȣ����2(Signal search 2) ��ٸ��� ����, ������ ����
function CFS20start_signal_search2 (axis : SmallInt; velocity : Double; detect_signal : Byte) : Boolean; stdcall;

// MPG(Manual Pulse Generation) ���� ����-===========================================================================
// ���� �࿡ MPG(Manual Pulse Generation) ����̹��� ���� ��带 ����/Ȯ���Ѵ�.
function CFS20set_mpg_drive_mode (axis : SmallInt; mode : Byte) : Boolean; stdcall;
function CFS20get_mpg_drive_mode (axis : SmallInt) : Byte; stdcall;
//0x1 : Slave �������, �ܺ� Differential ��ȣ�� ���� ���
//0x2 : ���� �޽� ����, �ܺ� �Է� ��ȣ�� ���� ���� �޽� ���� ����
//0x4 : ���� ���� ���, �ܺ� ���� �Է� ��ȣ�� Ư�� ���� ���� ����
// ���� �࿡ MPG(Manual Pulse Generation) ����̹��� ���� ���� ������带 ����/Ȯ���Ѵ�.
function CFS20set_mpg_dir_mode (axis : SmallInt; mode : Byte) : Boolean; stdcall;
function CFS20get_mpg_dir_mode (axis : SmallInt) : Byte; stdcall;
// mode
// 0x0 : �ܺ� ��ȣ�� ���� ���� ����
// 0x1 : ����ڿ� ���� ������ �������� ����
// ���� �࿡ MPG(Manual Pulse Generation) ����̹��� ���� ���� ������尡 ����ڿ� ����
// ������ �������� �����Ǿ��� �� �ʿ��� ������� ���� ���� ���� ���� ����/Ȯ���Ѵ�.
function CFS20set_mpg_user_dir (axis : SmallInt; mode : Byte) : Boolean; stdcall;
function CFS20get_mpg_user_dir (axis : SmallInt) : Byte; stdcall;
// mode
//0x0 : ����� ���� ���� ������ +�� ����
//0x1 : ����� ���� ���� ������ -�� ����
// ���� �࿡ MPG(Manual Pulse Generation) ����̹��� ���Ǵ� EXPP/EXMP �� �Է� ��带 �����Ѵ�.
//  2 bit : '0' : level input(���� �Է� 4 = EXPP, ���� �Է� 5 = EXMP�� �Է� �޴´�.)
//          '1' : Differential input(���� �Է����� EXPP, EXMP�� �Է� ����,)
//  1~0bit: "00" : 1 phase
//          "01" : 2 phase 1 times
//          "10" : 2 phase 2 times
//          "11" : 2 phase 4 times
function CFS20set_mpg_input_method (axis : SmallInt; method : Byte) : Boolean; stdcall;
function CFS20get_mpg_input_method (axis : SmallInt) : Byte; stdcall;
// MPG��ġ ���� �����Ѵ�. ������ ���¿��� MPG ��ġ�� Ư�� ������ ����/Ȯ���Ѵ�.(position = Unit)
function CFS20set_mpg_position (axis : SmallInt; position : Double) : Boolean; stdcall;
function CFS20get_mpg_position (axis : SmallInt) : Double; stdcall;

// MPG(Manual Pulse Generation) ���� -===============================================================================
// ������ �ӵ��� ��ٸ��� ����, ������/���ӽð�(_ex)(�ð�����:Sec)
function CFS20start_mpg (axis : SmallInt; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_mpg_ex (axis : SmallInt; velocity : Double; acceltime : Double) : Boolean; stdcall;
// ������ �ӵ��� S���� ����, ������/���ӽð�(_ex)(�ð�����:Sec)
function CFS20start_s_mpg (axis : SmallInt; velocity : Double; acceleration : Double) : Boolean; stdcall;
function CFS20start_s_mpg_ex (axis : SmallInt; velocity : Double; acceltime : Double) : Boolean; stdcall;

// �������̵�(������)-================================================================================================
// ���� ���� �Ÿ� ������ ���� ���۽������� �Է��� ��ġ(������ġ)�� ������ �ٲ۴�.
function CFS20position_override (axis : SmallInt; overrideposition : Double) : Boolean; stdcall;
// ���� ���� �Ÿ� ������ ���� ���۽������� �Է��� �Ÿ�(�����ġ)�� ������ �ٲ۴�.    
function CFS20position_r_override (axis : SmallInt; overridedistance : Double) : Boolean; stdcall;
// ������ ���� �ʱ� ������ �ӵ��� �ٲ۴�.(set_max_speed > velocity > set_startstop_speed)
function CFS20velocity_override (axis : SmallInt; velocity : Double) : Boolean; stdcall;
// ���� ���� ������ ����Ǳ� �� �Էµ� overrideposition���� �ּ� ��� �޽�(dec_pulse) �̻��� ��� override ������ �Ѵ�.
function CFS20position_override2 (axis : SmallInt; overrideposition : Double; dec_pulse : Double) : Boolean; stdcall;
// ���� �࿡ ����/���� ���� ������ ������ ���������� �ӵ� override ������ �Ѵ�.
function CFS20velocity_override2 (axis : SmallInt; velocity : Double; acceleration : Double; deceleration : Double; jerk : Double) : Boolean; stdcall; 

// ���� ���� Ȯ��-====================================================================================================
// ���� ���� ������ ����� ������ ��ٸ� �� �Լ��� �����.
function CFS20wait_for_done (axis : SmallInt) : Word; stdcall;

// ���� ���� ����-====================================================================================================
// ���� ���� �������Ѵ�.
function CFS20set_e_stop (axis : SmallInt) : Boolean; stdcall;
// ���� ���� ������ �������� �����Ѵ�.
function CFS20set_stop (axis : SmallInt) : Boolean; stdcall;
// ���� ���� �Էµ� �������� �����Ѵ�.
function CFS20set_stop_decel (axis : SmallInt; deceleration : Double) : Boolean; stdcall;
// ���� ���� �Էµ� ���� �ð����� �����Ѵ�.
function CFS20set_stop_deceltime (axis : SmallInt; deceltime : Double) : Boolean; stdcall;

// ���� ���� �������� ����-==========================================================================================
// Master/Slave link �Ǵ� ��ǥ�� link ���� �ϳ��� ����Ͽ��� �Ѵ�.
// Master/Slave link ����. (�Ϲ� ���� ������ master �� ������ slave�൵ ���� �����ȴ�.)
function CFS20link (master : SmallInt; slave : SmallInt; ratio : Double) : Boolean; stdcall;
// Master/Slave link ����
function CFS20endlink (slave : SmallInt) : Boolean; stdcall;

// ��ǥ�� link ����-================================================================================================
// ���� ��ǥ�迡 �� �Ҵ� - n_axes������ŭ�� ����� ����/Ȯ���Ѵ�.(coordinate�� 1..8���� ��� ����)
// n_axes ������ŭ�� ����� ����/Ȯ���Ѵ�. - (n_axes�� 1..4���� ��� ����)
function CFS20map_axes (coordinate : SmallInt; n_axes : SmallInt; map_array : PSmallInt) : Boolean; stdcall;
function CFS20get_mapped_axes (coordinate : SmallInt; n_axes : SmallInt; map_array : PSmallInt) : Boolean; stdcall;
// ���� ��ǥ���� ���/���� ��� ����/Ȯ���Ѵ�.
procedure CFS20set_coordinate_mode (coordinate : SmallInt; mode : SmallInt); stdcall;
function CFS20get_coordinate_mode (coordinate : SmallInt) : SmallInt; stdcall;
// mode:
// 0: �����ǥ����, 1: ������ǥ ����
// ���� ��ǥ���� �ӵ� �������� ����/Ȯ���Ѵ�.
procedure CFS20set_move_profile (coordinate : SmallInt; mode : SmallInt); stdcall;
function CFS20get_move_profile (coordinate : SmallInt) : SmallInt; stdcall;
// mode:
// 0: ��ٸ��� ����, 1: SĿ�� ����
// ���� ��ǥ���� �ʱ� �ӵ��� ����/Ȯ���Ѵ�.
procedure CFS20set_move_startstop_velocity (coordinate : SmallInt; velocity : Double); stdcall;
function CFS20get_move_startstop_velocity (coordinate : SmallInt) : Double; stdcall;
// Ư�� ��ǥ���� �ӵ��� ����/Ȯ���Ѵ�.
procedure CFS20set_move_velocity (coordinate : SmallInt; velocity : Double); stdcall;
function CFS20get_move_velocity (coordinate : SmallInt) : Double; stdcall;
// Ư�� ��ǥ���� �������� ����/Ȯ���Ѵ�.
procedure CFS20set_move_acceleration (coordinate : SmallInt; acceleration : Double); stdcall;
function CFS20get_move_acceleration (coordinate : SmallInt) : Double; stdcall;
// Ư�� ��ǥ���� ���� �ð�(Sec)�� ����/Ȯ���Ѵ�.
procedure CFS20set_move_acceltime (coordinate : SmallInt; acceltime : Double); stdcall;
function CFS20get_move_acceltime (coordinate : SmallInt) : Double; stdcall;
// ���� ��������  ��ǥ���� ���� �����ӵ��� ��ȯ�Ѵ�.
function CFS20co_get_velocity (coordinate : SmallInt) : Double; stdcall;

// ����Ʈ���� ���� ����(���� ��ǥ�迡 ���Ͽ�)-========================================================================
// Blocking�Լ� (������� �޽� ����� �Ϸ�� �� �Ѿ��)
// 2, 3, 4���� �����̵��Ѵ�.
function CFS20move_2 (coordinate : SmallInt; x : Double; y : Double) : Boolean; stdcall;
function CFS20move_3 (coordinate : SmallInt; x : Double; y : Double; z : Double) : Boolean; stdcall;
function CFS20move_4 (coordinate : SmallInt; x : Double; y : Double; z : Double; w : Double) : Boolean; stdcall;
// Non Blocking�Լ� (�������� ��� ���õ�)
// 2, 3, 4���� ���� �̵��Ѵ�.
function CFS20start_move_2 (coordinate : SmallInt; x : Double; y : Double) : Boolean; stdcall;
function CFS20start_move_3 (coordinate : SmallInt; x : Double; y : Double; z : Double) : Boolean; stdcall;
function CFS20start_move_4 (coordinate : SmallInt; x : Double; y : Double; z : Double; w : Double) : Boolean; stdcall;
// ���� ��ǥ���� ������� ��� �Ϸ� üũ    
function CFS20co_motion_done (coordinate : SmallInt) : Boolean; stdcall;
// ���� ��ǥ���� ������ �Ϸ�ɶ� ���� ��ٸ���.
function CFS20co_wait_for_done (coordinate : SmallInt) : Boolean; stdcall;

// ���� ����(���� ����) : Master/Slave�� link�Ǿ� ���� ��� ������ �߻� �� �� �ִ�.-==================================
// ���� ����� ���� �Ÿ� �� �ӵ� ���ӵ� ������ ���� ���� �����Ѵ�. ���� ���ۿ� ���� ����ȭ�� ����Ѵ�. 
// start_** : ���� �࿡�� ���� ������ �Լ��� return�Ѵ�. "start_*" �� ������ �̵� �Ϸ��� return�Ѵ�.
// *r*_*    : ���� �࿡�� �Էµ� �Ÿ���ŭ(�����ǥ)�� �̵��Ѵ�. "*r_*�� ������ �Էµ� ��ġ(������ǥ)�� �̵��Ѵ�.
// *s*_*    : ������ �ӵ� ���������� "S curve"�� �̿��Ѵ�. "*s_*"�� ���ٸ� ��ٸ��� �������� �̿��Ѵ�.
// *_ex     : ������ �����ӵ��� ���� �Ǵ� ���� �ð����� �Է� �޴´�. "*_ex"�� ���ٸ� �����ӷ��� �Է� �޴´�.

// ���� �����޽�(Pulse Drive)����, ��ٸ��� ����, ����/�����ǥ(r), ������/���ӽð�(_ex)(�ð�����:Sec)
// Blocking�Լ� (������� ��� �������� �޽� ����� �Ϸ�� �� �Ѿ��)
function CFS20move_all (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; accelerations : PDouble) : Byte; stdcall;
function CFS20move_all_ex (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; acceltimes : PDouble) : Byte; stdcall;
function CFS20r_move_all (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; accelerations : PDouble) : Byte; stdcall;
function CFS20r_move_all_ex (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; acceltimes : PDouble) : Byte; stdcall;
// Non Blocking�Լ� (�������� ���� ���õ�)
function CFS20start_move_all (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; accelerations : PDouble) : Boolean; stdcall;
function CFS20start_move_all_ex (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; acceltimes : PDouble) : Boolean; stdcall;
function CFS20start_r_move_all (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; accelerations : PDouble) : Boolean; stdcall;
function CFS20start_r_move_all_ex (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; acceltimes : PDouble) : Boolean; stdcall;
// ���� �����޽�(Pulse Drive)����, S���� ����, ����/�����ǥ(r), ������/���ӽð�(_ex)(�ð�����:Sec)
// Blocking�Լ� (������� ��� �������� �޽� ����� �Ϸ�� �� �Ѿ��)
function CFS20s_move_all (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; accelerations : PDouble) : Byte; stdcall;
function CFS20s_move_all_ex (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; acceltimes : PDouble) : Byte; stdcall;
function CFS20rs_move_all (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; accelerations : PDouble) : Byte; stdcall;
function CFS20rs_move_all_ex (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; acceltimes : PDouble) : Byte; stdcall;
// Non Blocking�Լ� (�������� ���� ���õ�)
function CFS20start_s_move_all (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; accelerations : PDouble) : Boolean; stdcall;
function CFS20start_s_move_all_ex (number : SmallInt; axes : PSmallInt; positions : PDouble; velocities : PDouble; acceltimes : PDouble) : Boolean; stdcall;
function CFS20start_rs_move_all (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; accelerations : PDouble) : Boolean; stdcall;
function CFS20start_rs_move_all_ex (number : SmallInt; axes : PSmallInt; distances : PDouble; velocities : PDouble; acceltimes : PDouble) : Boolean; stdcall;
//���� ��鿡 ���Ͽ� S���� ������ ���� �����ӽ��� SĿ���� ������ ����/Ȯ���Ѵ�.
procedure CFS20set_s_rate_all (number : SmallInt; axes : PSmallInt; a_percent : PDouble; b_percent : PDouble); stdcall;
procedure CFS20get_s_rate_all (number : SmallInt; axes : PSmallInt; a_percent : PDouble; b_percent : PDouble); stdcall;

// ���� ���� Ȯ��-====================================================================================================
// �Է� �ش� ����� ���� ���¸� Ȯ���ϰ� ������ ���� �� ���� ��ٸ���.
function CFS20wait_for_all (number : SmallInt; axes : PSmallInt) : Byte; stdcall;

// ���� ���� ����-====================================================================================================
// ���� ����� ���⸦ ������Ų��. - ��������� �������� ���������ʰ� �����.
function CFS20reset_axis_sync (nLen : SmallInt; aAxis : PSmallInt) : Boolean; stdcall;
// ���� ����� ���⸦ ������Ų��. - ��������� �������� ���������ʰ� �����.
function CFS20set_axis_sync (nLen : SmallInt; aAxis : PSmallInt) : Boolean; stdcall;
// ������ ���� ���� ����/����/Ȯ���Ѵ�.
function CFS20set_sync_axis (axis : SmallInt; sync : Byte) : Boolean; stdcall;
function CFS20get_sync_axis (axis : SmallInt) : Byte; stdcall;
// sync:
// 0: Reset - ���� �������� ����.
// 1: Set	- ���� ������.
// ������ ����� ���� ���� ����/����/Ȯ���Ѵ�.
function CFS20set_sync_module (axis : SmallInt; sync : Byte) : Boolean; stdcall;
function CFS20get_sync_module (axis : SmallInt) : Byte; stdcall;
// sync:
// 0: Reset - ���� �������� ����.
// 1: Set	- ���� ������.	

// ���� ���� ����-====================================================================================================
// Ȩ ��ġ �����嵵 ����
function CFS20emergency_stop () : Boolean; stdcall;

// -�����˻� =========================================================================================================
// ���̺귯�� �󿡼� Thread�� ����Ͽ� �˻��Ѵ�. ���� : ������ Ĩ���� StartStop Speed�� ���� �� �ִ�.
// �����˻��� �����Ѵ�.
function CFS20abort_home_search (axis : SmallInt; bStop : Byte) : Boolean; stdcall;
// bStop:
// 0: ��������
// 1: ������
// �����˻��� �����Ѵ�. �����ϱ� ���� �����˻��� �ʿ��� ������ �ʿ��ϴ�.
function CFS20home_search (axis : SmallInt) : Boolean; stdcall;
// �Է� ����� ���ÿ� �����˻��� �ǽ��Ѵ�.
function CFS20home_search_all (number : SmallInt; axes : PSmallInt) : Boolean; stdcall;
// �����˻� ���� �������� Ȯ���Ѵ�.
function CFS20get_home_done (axis : SmallInt) : Boolean; stdcall;
// ��ȯ��: 0: �����˻� ������, 1: �����˻� ����
// �ش� ����� �����˻� ���� �������� Ȯ���Ѵ�.
function CFS20get_home_done_all (number : SmallInt; axes : PSmallInt) : Boolean; stdcall;
// ���� ���� ���� �˻� ������ ���� ���¸� Ȯ���Ѵ�.
function CFS20get_home_end_status (axis : SmallInt) : Byte; stdcall;
// ��ȯ��: 0: �����˻� ����, 1: �����˻� ����
// ���� ����� ���� �˻� ������ ���� ���¸� Ȯ���Ѵ�.
function CFS20get_home_end_status_all (number : SmallInt; axes : PSmallInt; endstatus : PByte) : Boolean; stdcall;
// ���� �˻��� �� ���ܸ��� method�� ����/Ȯ���Ѵ�.
// Method�� ���� ���� 
//    0 Bit ���� ��뿩�� ���� (0 : ������� ����, 1: �����
//    1 Bit ������ ��� ���� (0 : ������, 1 : ���� �ð�)
//    2 Bit ������� ���� (0 : ���� ����, 1 : �� ����)
//    3 Bit �˻����� ���� (0 : cww(-), 1 : cw(+))
// 7654 Bit detect signal ����(typedef : DETECT_DESTINATION_SIGNAL)
function CFS20set_home_method (axis : SmallInt; nstep : SmallInt; method : PByte) : Boolean; stdcall;
function CFS20get_home_method (axis : SmallInt; nstep : SmallInt; method : PByte) : Boolean; stdcall;
// ���� �˻��� �� ���ܸ��� offset�� ����/Ȯ���Ѵ�.	
function CFS20set_home_offset (axis : SmallInt; nstep : SmallInt; offset : PDouble) : Boolean; stdcall;
function CFS20get_home_offset (axis : SmallInt; nstep : SmallInt; offset : PDouble) : Boolean; stdcall;
// �� ���� ���� �˻� �ӵ��� ����/Ȯ���Ѵ�.
function CFS20set_home_velocity (axis : SmallInt; nstep : SmallInt; velocity : PDouble) : Boolean; stdcall;
function CFS20get_home_velocity (axis : SmallInt; nstep : SmallInt; velocity : PDouble) : Boolean; stdcall;
// ���� ���� ���� �˻� �� �� ���ܺ� �������� ����/Ȯ���Ѵ�.
function CFS20set_home_acceleration (axis : SmallInt; nstep : SmallInt; acceleration : PDouble) : Boolean; stdcall;
function CFS20get_home_acceleration (axis : SmallInt; nstep : SmallInt; acceleration : PDouble) : Boolean; stdcall;
// ���� ���� ���� �˻� �� �� ���ܺ� ���� �ð��� ����/Ȯ���Ѵ�.
function CFS20set_home_acceltime (axis : SmallInt; nstep : SmallInt; acceltime : PDouble) : Boolean; stdcall;
function CFS20get_home_acceltime (axis : SmallInt; nstep : SmallInt; acceltime : PDouble) : Boolean; stdcall;
// ���� �࿡ ���� �˻����� ���ڴ� 'Z'�� ���� ��� �� ���� �Ѱ谪�� ����/Ȯ���Ѵ�.(Pulse) - ������ ����� �˻� ����
function CFS20set_zphase_search_range (axis : SmallInt; pulses : SmallInt) : Boolean; stdcall;
function CFS20get_zphase_search_range (axis : SmallInt) : SmallInt; stdcall;
// ���� ��ġ�� ����(0 Position)���� �����Ѵ�. - �������̸� ���õ�.
function CFS20home_zero (axis : SmallInt) : Boolean; stdcall;
// ������ ��� ���� ���� ��ġ�� ����(0 Position)���� �����Ѵ�. - �������� ���� ���õ�
function CFS20home_zero_all (number : SmallInt; axes : PSmallInt) : Boolean; stdcall;

// ���� �����-=======================================================================================================
// ���� ���
// 0 bit : ���� ��� 0(Servo-On)
// 1 bit : ���� ��� 1(ALARM Clear)
// 2 bit : ���� ��� 2
// 3 bit : ���� ��� 3
// 4 bit(PLD) : ���� ��� 4
// 5 bit(PLD) : ���� ��� 5
// ���� �Է�
// 0 bit : ���� �Է� 0(ORiginal Sensor)
// 1 bit : ���� �Է� 1(Z phase)
// 2 bit : ���� �Է� 2
// 3 bit : ���� �Է� 3
// 4 bit(PLD) : ���� �Է� 5
// 5 bit(PLD) : ���� �Է� 6
// On ==> ���ڴ� N24V, 'Off' ==> ���ڴ� Open(float).	

// ���� ���� ��°��� ����/Ȯ���Ѵ�.
function CFS20set_output (axis : SmallInt; value : Byte) : Boolean; stdcall;
function CFS20get_output (axis : SmallInt) : Byte; stdcall;
// ���� �Է� ���� Ȯ���Ѵ�.
// '1'('On') <== ���ڴ� N24V�� �����, '0'('Off') <== ���ڴ� P24V �Ǵ� Float.
function CFS20get_input (axis : SmallInt) : Byte; stdcall;
// �ش� ���� �ش� bit�� ����� On/Off ��Ų��.
// bitNo : 0 ~ 5.
function CFS20set_output_bit (axis : SmallInt; bitNo : Byte) : Boolean; stdcall;
function CFS20reset_output_bit (axis : SmallInt; bitNo : Byte) : Boolean; stdcall;
// �ش� ���� �ش� ���� ��� bit�� ��� ���¸� Ȯ���Ѵ�.
// bitNo : 0 ~ 5.
function CFS20output_bit_on (axis : SmallInt; bitNo : Byte) : Boolean; stdcall;
// �ش� ���� �ش� ���� ��� bit�� ���¸� �Է� state�� �ٲ۴�.
// bitNo : 0 ~ 5. 
function CFS20change_output_bit (axis : SmallInt; bitNo : Byte; state : Byte) : Boolean; stdcall;
// �ش� ���� �ش� ���� �Է� bit�� ���¸� Ȯ�� �Ѵ�.
// bitNo : 0 ~ 5.
function CFS20input_bit_on (axis : SmallInt; bitNo : Byte) : Boolean; stdcall;
// ���� �Է�(Universal input) 4 ��� ����/Ȯ���Ѵ�.
function CFS20set_ui4_mode (axis : SmallInt; state : Byte) : Boolean; stdcall;
function CFS20get_ui4_mode (axis : SmallInt) : Byte; stdcall;
// ���� �Է�(Universal input) 5 ��� ����/Ȯ���Ѵ�.
function CFS20set_ui5_mode (axis : SmallInt; state : Byte) : Boolean; stdcall;
function CFS20get_ui5_mode (axis : SmallInt) : Byte; stdcall;

// �ܿ� �޽� clear-===================================================================================================
// �ش� ���� ������ �ܿ� �޽� Clear ����� ��� ���θ� ����/Ȯ���Ѵ�.
// CLR ��ȣ�� Default ��� ==> ���ڴ� Open�̴�.
function CFS20set_crc_mask (axis : SmallInt; mask : SmallInt) : Boolean; stdcall;
function CFS20get_crc_mask (axis : SmallInt) : Byte; stdcall;
// �ش� ���� �ܿ� �޽� Clear ����� Active level�� ����/Ȯ���Ѵ�.
// Default Active level ==> '1' ==> ���ڴ� N24V
function CFS20set_crc_level (axis : SmallInt; level : SmallInt) : Boolean; stdcall;
function CFS20get_crc_level (axis : SmallInt) : Byte; stdcall;
// �ش� ���� -Emeregency End limit�� ���� Clear��� ��� ������ ����/Ȯ���Ѵ�.    
function CFS20set_crc_nelm_mask (axis : SmallInt; mask : SmallInt) : Boolean; stdcall;
function CFS20get_crc_nelm_mask (axis : SmallInt) : Byte; stdcall;
// �ش� ���� -Emeregency End limit�� Active level�� ����/Ȯ���Ѵ�. set_nend_limit_level�� �����ϰ� �����Ѵ�.    
function CFS20set_crc_nelm_level (axis : SmallInt; level : SmallInt) : Boolean; stdcall;
function CFS20get_crc_nelm_level (axis : SmallInt) : Byte; stdcall;
// �ش� ���� +Emeregency End limit�� ���� Clear��� ��� ������ ����/Ȯ���Ѵ�.
function CFS20set_crc_pelm_mask (axis : SmallInt; mask : SmallInt) : Boolean; stdcall;
function CFS20get_crc_pelm_mask (axis : SmallInt) : Byte; stdcall;
// �ش� ���� +Emeregency End limit�� Active level�� ����/Ȯ���Ѵ�. set_nend_limit_level�� �����ϰ� �����Ѵ�.
function CFS20set_crc_pelm_level (axis : SmallInt; level : SmallInt) : Boolean; stdcall;
function CFS20get_crc_pelm_level (axis : SmallInt) : Byte; stdcall;
// �ش� ���� �ܿ� �޽� Clear ����� �Է� ������ ���� ���/Ȯ���Ѵ�.
function CFS20set_programmed_crc (axis : SmallInt; data : SmallInt) : Boolean; stdcall;
function CFS20get_programmed_crc (axis : SmallInt) : Byte; stdcall;

// Ʈ���� ��� ======================================================================================================
// ����/�ܺ� ��ġ�� ���Ͽ� �ֱ�/���� ��ġ���� ������ Active level�� Trigger pulse�� �߻� ��Ų��.
// Ʈ���� ��� �޽��� Active level�� ����/Ȯ���Ѵ�.
// ('0' : 5V ���(0 V), 24V �͹̳� ���(Open); '1'(default) : 5V ���(5 V), 24V �͹̳� ���(N24V).
function CFS20set_trigger_level (axis : SmallInt; trigger_level : Byte) : Boolean; stdcall;
function CFS20get_trigger_level (axis : SmallInt) : Byte; stdcall;
// Ʈ���� ��ɿ� ����� ���� ��ġ�� �����Ѵ�.
// 0x0 : �ܺ� ��ġ External(Actual)
// 0x1 : ���� ��ġ Internal(Command)
function CFS20set_trigger_sel (axis : SmallInt; trigger_sel : Byte) : Boolean; stdcall;
function CFS20get_trigger_sel (axis : SmallInt) : Byte; stdcall;
// 0x00 : FS Chip Trigger Time Use
// 0x01 : 8msec
// 0x02 : 16msec
// 0x03	: 24msec
// ~
// 0x0A: 80msec
// 0x0B: 88msec
// ~
// 0x0F: 120msec
function CFS20set_trigger_time (axis : SmallInt; time : Byte) : Boolean; stdcall;
function CFS20get_trigger_time (axis : SmallInt) : Byte; stdcall;
// ���� �࿡ Ʈ���� �߻� ����� ����/Ȯ���Ѵ�.
// 0x0 : Ʈ���� ���� ��ġ���� Ʈ���� �߻�, ���� ��ġ ���
// 0x1 : Ʈ���� ��ġ���� ����� �ֱ� Ʈ���� ���
function CFS20set_trigger_mode (axis : SmallInt; mode_sel : Byte) : Boolean; stdcall;
function CFS20get_trigger_mode (axis : SmallInt) : Byte; stdcall;
// ���� �࿡ Ʈ���� �ֱ� �Ǵ� ���� ��ġ ���� ����/Ȯ���Ѵ�.
function CFS20set_trigger_position (axis : SmallInt; trigger_position : Double) : Boolean; stdcall;
function CFS20get_trigger_position (axis : SmallInt) : Double; stdcall;
// ���� ���� Ʈ���� ����� ��� ���θ� ����/Ȯ���Ѵ�.
function CFS20set_trigger_enable (axis : SmallInt; ena_status : Byte) : Boolean; stdcall;
function CFS20is_trigger_enabled (axis : SmallInt) : Byte; stdcall;
// ���� �࿡ Ʈ���� �߻��� ���ͷ�Ʈ�� �߻��ϵ��� ����/Ȯ���Ѵ�.
function CFS20set_trigger_interrupt_enable (axis : SmallInt; ena_int : Byte) : Boolean; stdcall;
function CFS20is_trigger_interrupt_enabled (axis : SmallInt) : Byte; stdcall;

// MARK ����̺� �����Լ� ===========================================================================================
// MARK, �����޽�(Pulse Drive) ��ٸ��� ����, �����ǥ, ������/���ӽð�(Sec)
function CFS20start_pr_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; drive : Byte) : Boolean; stdcall;
function CFS20start_pr_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; drive : Byte) : Boolean; stdcall;
// MARK, ���Ī �����޽�(Pulse Drive) ��ٸ��� ����, �����ǥ, ������/���ӽð�(Sec)
function CFS20start_pra_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double; drive : Byte) : Boolean; stdcall;
function CFS20start_pra_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double; drive : Byte) : Boolean; stdcall;
// �����޽�(Pulse Drive) ��ٸ��� ����, �����ǥ, ������/���ӽð�(Sec). ������ �Ϸ�ɶ����� ���
function CFS20pr_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; drive : Byte) : Word; stdcall;
function CFS20pr_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; drive : Byte) : Word; stdcall;
// MARK, ���Ī �����޽�(Pulse Drive) ��ٸ��� ����, �����ǥ, ������/���ӽð�(Sec). ������ �Ϸ�ɶ����� ���
function CFS20pra_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double; drive : Byte) : Word; stdcall;
function CFS20pra_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double; drive : Byte) : Word; stdcall;
// MARK, �����޽�(Pulse Drive) S���� ����, �����ǥ, ������/���ӽð�(Sec)
function CFS20start_prs_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; drive : Byte) : Boolean; stdcall;
function CFS20start_prs_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; drive : Byte) : Boolean; stdcall;
// MARK, ���Ī �����޽�(Pulse Drive) S���� ����, �����ǥ, ������/���ӽð�(Sec)
function CFS20start_pras_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double; drive : Byte) : Boolean; stdcall;
function CFS20start_pras_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double; drive : Byte) : Boolean; stdcall;
// MARK, �����޽�(Pulse Drive) S���� ����, �����ǥ, ������/���ӽð�(Sec). ������ �Ϸ�ɶ����� ���
function CFS20prs_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; drive : Byte) : Word; stdcall;
function CFS20prs_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; drive : Byte) : Word; stdcall;
// MARK, ���Ī �����޽�(Pulse Drive) S���� ����, �����ǥ, ������/���ӽð�(Sec). ������ �Ϸ�ɶ����� ���
function CFS20pras_move (axis : SmallInt; distance : Double; velocity : Double; acceleration : Double; deceleration : Double; drive : Byte) : Word; stdcall;
function CFS20pras_move_ex (axis : SmallInt; distance : Double; velocity : Double; acceltime : Double; deceltime : Double; drive : Byte) : Word; stdcall;
// MARK Signal�� Active level�� ����/Ȯ��/����Ȯ���Ѵ�.
function CFS20set_mark_signal_level (axis : SmallInt; level : Byte) : Boolean; stdcall;
function CFS20get_mark_signal_level (axis : SmallInt) : Byte; stdcall;
function CFS20get_mark_signal_switch (axis : SmallInt) : Byte; stdcall;	

function CFS20set_mark_signal_enable (axis : SmallInt; use : Byte) : Boolean; stdcall;
function CFS20get_mark_signal_enable (axis : SmallInt) : Byte; stdcall;

// ��ġ �񱳱� ���� �Լ��� ==========================================================================================
// Internal(Command) comparator���� ����/Ȯ���Ѵ�.
procedure CFS20set_internal_comparator_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_internal_comparator_position (axis : SmallInt) : Double; stdcall;
// External(Encoder) comparator���� ����/Ȯ���Ѵ�.
procedure CFS20set_external_comparator_position (axis : SmallInt; position : Double); stdcall;
function CFS20get_external_comparator_position (axis : SmallInt) : Double; stdcall;

// �����ڵ� �б� �Լ��� =============================================================================================
// ������ �����ڵ带 �д´�.
function CFS20get_error_code () : SmallInt; stdcall;
// �����ڵ��� ������ ���ڷ� ��ȯ�Ѵ�.
function CFS20get_error_msg (ErrorCode : SmallInt) : Char; stdcall;

implementation

const

	dll_name	= 'AxtLib.dll';

	function InitializeCAMCFS20; external dll_name name 'InitializeCAMCFS20';
	function CFS20IsInitialized; external dll_name name 'CFS20IsInitialized';
	procedure CFS20StopService; external dll_name name 'CFS20StopService';

	function CFS20get_boardno; external dll_name name 'CFS20get_boardno';
	function CFS20get_numof_boards; external dll_name name 'CFS20get_numof_boards';
	function CFS20get_numof_axes; external dll_name name 'CFS20get_numof_axes';
	function CFS20get_total_numof_axis; external dll_name name 'CFS20get_total_numof_axis';
	function CFS20get_axisno; external dll_name name 'CFS20get_axisno';
	function CFS20get_axis_info; external dll_name name 'CFS20get_axis_info';

	function CFS20load_parameter; external dll_name name 'CFS20load_parameter';
	function CFS20save_parameter; external dll_name name 'CFS20save_parameter';
	function CFS20load_parameter_all; external dll_name name 'CFS20load_parameter_all';
	function CFS20save_parameter_all; external dll_name name 'CFS20save_parameter_all';

	procedure CFS20SetWindowMessage; external dll_name name 'CFS20SetWindowMessage';
	function CFS20read_interrupt_flag; external dll_name name 'CFS20read_interrupt_flag';

	procedure CFS20KeSetMainClk; external dll_name name 'CFS20KeSetMainClk';
	procedure CFS20set_drive_mode1; external dll_name name 'CFS20set_drive_mode1';
	function CFS20get_drive_mode1; external dll_name name 'CFS20get_drive_mode1';
	procedure CFS20set_drive_mode2; external dll_name name 'CFS20set_drive_mode2';
	function CFS20get_drive_mode2; external dll_name name 'CFS20get_drive_mode2';
	procedure CFS20set_moveunit_perpulse; external dll_name name 'CFS20set_moveunit_perpulse';
	function CFS20get_moveunit_perpulse; external dll_name name 'CFS20get_moveunit_perpulse';
	procedure CFS20set_movepulse_perunit; external dll_name name 'CFS20set_movepulse_perunit';
	function CFS20get_movepulse_perunit; external dll_name name 'CFS20get_movepulse_perunit';
	procedure CFS20set_startstop_speed; external dll_name name 'CFS20set_startstop_speed';
	function CFS20get_startstop_speed; external dll_name name 'CFS20get_startstop_speed';
	function CFS20set_max_speed; external dll_name name 'CFS20set_max_speed';
	function CFS20get_max_speed; external dll_name name 'CFS20get_max_speed';
	procedure CFS20set_s_rate; external dll_name name 'CFS20set_s_rate';
	procedure CFS20get_s_rate; external dll_name name 'CFS20get_s_rate';
	procedure CFS20set_slowdown_rear_pulse; external dll_name name 'CFS20set_slowdown_rear_pulse';
	function CFS20get_slowdown_rear_pulse; external dll_name name 'CFS20get_slowdown_rear_pulse';
	function CFS20set_decel_point; external dll_name name 'CFS20set_decel_point';
	function CFS20get_decel_point; external dll_name name 'CFS20get_decel_point';

	function CFS20in_motion; external dll_name name 'CFS20in_motion';
	function CFS20motion_done; external dll_name name 'CFS20motion_done';
	function CFS20get_drive_pulse_counts; external dll_name name 'CFS20get_drive_pulse_counts';
	function CFS20get_drive_status; external dll_name name 'CFS20get_drive_status';
	function CFS20get_end_status; external dll_name name 'CFS20get_end_status';
	function CFS20get_mechanical_signal; external dll_name name 'CFS20get_mechanical_signal';
	function CFS20get_velocity; external dll_name name 'CFS20get_velocity';
	function CFS20get_error; external dll_name name 'CFS20get_error';
	function CFS20get_drivedistance; external dll_name name 'CFS20get_drivedistance';

	function CFS20set_enc_input_method; external dll_name name 'CFS20set_enc_input_method';
	function CFS20get_enc_input_method; external dll_name name 'CFS20get_enc_input_method';
	function CFS20set_enc2_input_method; external dll_name name 'CFS20set_enc2_input_method';
	function CFS20get_enc2_input_method; external dll_name name 'CFS20get_enc2_input_method';
	function CFS20set_enc_reverse; external dll_name name 'CFS20set_enc_reverse';
	function CFS20get_enc_reverse; external dll_name name 'CFS20get_enc_reverse';

	function CFS20set_pulse_out_method; external dll_name name 'CFS20set_pulse_out_method';
	function CFS20get_pulse_out_method; external dll_name name 'CFS20get_pulse_out_method';

	procedure CFS20set_actual_position; external dll_name name 'CFS20set_actual_position';
	function CFS20get_actual_position; external dll_name name 'CFS20get_actual_position';
	procedure CFS20set_command_position; external dll_name name 'CFS20set_command_position';
	function CFS20get_command_position; external dll_name name 'CFS20get_command_position';

	function CFS20set_servo_level; external dll_name name 'CFS20set_servo_level';
	function CFS20get_servo_level; external dll_name name 'CFS20get_servo_level';
	function CFS20set_servo_enable; external dll_name name 'CFS20set_servo_enable';
	function CFS20get_servo_enable; external dll_name name 'CFS20get_servo_enable';

	function CFS20set_inposition_enable; external dll_name name 'CFS20set_inposition_enable';
	function CFS20get_inposition_enable; external dll_name name 'CFS20get_inposition_enable';
	function CFS20set_inposition_level; external dll_name name 'CFS20set_inposition_level';
	function CFS20get_inposition_level; external dll_name name 'CFS20get_inposition_level';
	function CFS20get_inposition_switch; external dll_name name 'CFS20get_inposition_switch';
	function CFS20in_position; external dll_name name 'CFS20in_position';
	function CFS20set_alarm_enable; external dll_name name 'CFS20set_alarm_enable';
	function CFS20get_alarm_enable; external dll_name name 'CFS20get_alarm_enable';
	function CFS20set_alarm_level; external dll_name name 'CFS20set_alarm_level';
	function CFS20get_alarm_level; external dll_name name 'CFS20get_alarm_level';
	function CFS20get_alarm_switch; external dll_name name 'CFS20get_alarm_switch';

	function CFS20set_end_limit_enable; external dll_name name 'CFS20set_end_limit_enable';
	function CFS20get_end_limit_enable; external dll_name name 'CFS20get_end_limit_enable';
	function CFS20set_nend_limit_level; external dll_name name 'CFS20set_nend_limit_level';
	function CFS20get_nend_limit_level; external dll_name name 'CFS20get_nend_limit_level';
	function CFS20get_nend_limit_switch; external dll_name name 'CFS20get_nend_limit_switch';
	function CFS20set_pend_limit_level; external dll_name name 'CFS20set_pend_limit_level';
	function CFS20get_pend_limit_level; external dll_name name 'CFS20get_pend_limit_level';
	function CFS20get_pend_limit_switch; external dll_name name 'CFS20get_pend_limit_switch';
	function CFS20set_slow_limit_enable; external dll_name name 'CFS20set_slow_limit_enable';
	function CFS20get_slow_limit_enable; external dll_name name 'CFS20get_slow_limit_enable';
	function CFS20set_nslow_limit_level; external dll_name name 'CFS20set_nslow_limit_level';
	function CFS20get_nslow_limit_level; external dll_name name 'CFS20get_nslow_limit_level';
	function CFS20get_nslow_limit_switch; external dll_name name 'CFS20get_nslow_limit_switch';
	function CFS20set_pslow_limit_level; external dll_name name 'CFS20set_pslow_limit_level';
	function CFS20get_pslow_limit_level; external dll_name name 'CFS20get_pslow_limit_level';
	function CFS20get_pslow_limit_switch; external dll_name name 'CFS20get_pslow_limit_switch';
	function CFS20set_nlimit_sel; external dll_name name 'CFS20set_nlimit_sel';
	function CFS20get_nlimit_sel; external dll_name name 'CFS20get_nlimit_sel';
	function CFS20set_plimit_sel; external dll_name name 'CFS20set_plimit_sel';
	function CFS20get_plimit_sel; external dll_name name 'CFS20get_plimit_sel';

	procedure CFS20set_soft_limit_enable; external dll_name name 'CFS20set_soft_limit_enable';
	function CFS20get_soft_limit_enable; external dll_name name 'CFS20get_soft_limit_enable';
	procedure CFS20set_soft_limit_sel; external dll_name name 'CFS20set_soft_limit_sel';
	function CFS20get_soft_limit_sel; external dll_name name 'CFS20get_soft_limit_sel';
	procedure CFS20set_soft_limit_stopmode; external dll_name name 'CFS20set_soft_limit_stopmode';
	function CFS20get_soft_limit_stopmode; external dll_name name 'CFS20get_soft_limit_stopmode';
	procedure CFS20set_soft_nlimit_position; external dll_name name 'CFS20set_soft_nlimit_position';
	function CFS20get_soft_nlimit_position; external dll_name name 'CFS20get_soft_nlimit_position';
	procedure CFS20set_soft_plimit_position; external dll_name name 'CFS20set_soft_plimit_position';
	function CFS20get_soft_plimit_position; external dll_name name 'CFS20get_soft_plimit_position';

	function CFS20set_emg_signal_enable; external dll_name name 'CFS20set_emg_signal_enable';
	function CFS20get_emg_signal_enable; external dll_name name 'CFS20get_emg_signal_enable';
	function CFS20set_stop_sel; external dll_name name 'CFS20set_stop_sel';
	function CFS20get_stop_sel; external dll_name name 'CFS20get_stop_sel';


	function CFS20move; external dll_name name 'CFS20move';
	function CFS20move_ex; external dll_name name 'CFS20move_ex';
	function CFS20r_move; external dll_name name 'CFS20r_move';
	function CFS20r_move_ex; external dll_name name 'CFS20r_move_ex';
	function CFS20start_move; external dll_name name 'CFS20start_move';
	function CFS20start_move_ex; external dll_name name 'CFS20start_move_ex';
	function CFS20start_r_move; external dll_name name 'CFS20start_r_move';
	function CFS20start_r_move_ex; external dll_name name 'CFS20start_r_move_ex';
	function CFS20a_move; external dll_name name 'CFS20a_move';
	function CFS20a_move_ex; external dll_name name 'CFS20a_move_ex';
	function CFS20ra_move; external dll_name name 'CFS20ra_move';
	function CFS20ra_move_ex; external dll_name name 'CFS20ra_move_ex';
	function CFS20start_a_move; external dll_name name 'CFS20start_a_move';
	function CFS20start_a_move_ex; external dll_name name 'CFS20start_a_move_ex';
	function CFS20start_ra_move; external dll_name name 'CFS20start_ra_move';
	function CFS20start_ra_move_ex; external dll_name name 'CFS20start_ra_move_ex';
	function CFS20s_move; external dll_name name 'CFS20s_move';
	function CFS20s_move_ex; external dll_name name 'CFS20s_move_ex';
	function CFS20rs_move; external dll_name name 'CFS20rs_move';
	function CFS20rs_move_ex; external dll_name name 'CFS20rs_move_ex';
	function CFS20start_s_move; external dll_name name 'CFS20start_s_move';
	function CFS20start_s_move_ex; external dll_name name 'CFS20start_s_move_ex';
	function CFS20start_rs_move; external dll_name name 'CFS20start_rs_move';
	function CFS20start_rs_move_ex; external dll_name name 'CFS20start_rs_move_ex';
	function CFS20as_move; external dll_name name 'CFS20as_move';
	function CFS20as_move_ex; external dll_name name 'CFS20as_move_ex';
	function CFS20ras_move; external dll_name name 'CFS20ras_move';
	function CFS20ras_move_ex; external dll_name name 'CFS20ras_move_ex';
	function CFS20start_as_move; external dll_name name 'CFS20start_as_move';
	function CFS20start_as_move2; external dll_name name 'CFS20start_as_move2';
	function CFS20start_as_move_ex; external dll_name name 'CFS20start_as_move_ex';
	function CFS20start_ras_move; external dll_name name 'CFS20start_ras_move';
	function CFS20start_ras_move_ex; external dll_name name 'CFS20start_ras_move_ex';

	function CFS20start_rs_move_override; external dll_name name 'CFS20start_rs_move_override';


	function CFS20v_move; external dll_name name 'CFS20v_move';
	function CFS20v_move_ex; external dll_name name 'CFS20v_move_ex';
	function CFS20v_a_move; external dll_name name 'CFS20v_a_move';
	function CFS20v_a_move_ex; external dll_name name 'CFS20v_a_move_ex';
	function CFS20v_s_move; external dll_name name 'CFS20v_s_move';
	function CFS20v_s_move_ex; external dll_name name 'CFS20v_s_move_ex';
	function CFS20v_as_move; external dll_name name 'CFS20v_as_move';
	function CFS20v_as_move_ex; external dll_name name 'CFS20v_as_move_ex';


	function CFS20start_signal_search1; external dll_name name 'CFS20start_signal_search1';
	function CFS20start_signal_search1_ex; external dll_name name 'CFS20start_signal_search1_ex';
	function CFS20start_s_signal_search1; external dll_name name 'CFS20start_s_signal_search1';
	function CFS20start_s_signal_search1_ex; external dll_name name 'CFS20start_s_signal_search1_ex';
	function CFS20start_signal_search2; external dll_name name 'CFS20start_signal_search2';

	function CFS20set_mpg_drive_mode; external dll_name name 'CFS20set_mpg_drive_mode';
	function CFS20get_mpg_drive_mode; external dll_name name 'CFS20get_mpg_drive_mode';
	function CFS20set_mpg_dir_mode; external dll_name name 'CFS20set_mpg_dir_mode';
	function CFS20get_mpg_dir_mode; external dll_name name 'CFS20get_mpg_dir_mode';
	function CFS20set_mpg_user_dir; external dll_name name 'CFS20set_mpg_user_dir';
	function CFS20get_mpg_user_dir; external dll_name name 'CFS20get_mpg_user_dir';
	function CFS20set_mpg_input_method; external dll_name name 'CFS20set_mpg_input_method';
	function CFS20get_mpg_input_method; external dll_name name 'CFS20get_mpg_input_method';
	function CFS20set_mpg_position; external dll_name name 'CFS20set_mpg_position';
	function CFS20get_mpg_position; external dll_name name 'CFS20get_mpg_position';

	function CFS20start_mpg; external dll_name name 'CFS20start_mpg';
	function CFS20start_mpg_ex; external dll_name name 'CFS20start_mpg_ex';
	function CFS20start_s_mpg; external dll_name name 'CFS20start_s_mpg';
	function CFS20start_s_mpg_ex; external dll_name name 'CFS20start_s_mpg_ex';

	function CFS20position_override; external dll_name name 'CFS20position_override';
	function CFS20position_r_override; external dll_name name 'CFS20position_r_override';
	function CFS20velocity_override; external dll_name name 'CFS20velocity_override';
	function CFS20position_override2; external dll_name name 'CFS20position_override2';
	function CFS20velocity_override2; external dll_name name 'CFS20velocity_override2';

	function CFS20wait_for_done; external dll_name name 'CFS20wait_for_done';

	function CFS20set_e_stop; external dll_name name 'CFS20set_e_stop';
	function CFS20set_stop; external dll_name name 'CFS20set_stop';
	function CFS20set_stop_decel; external dll_name name 'CFS20set_stop_decel';
	function CFS20set_stop_deceltime; external dll_name name 'CFS20set_stop_deceltime';

	function CFS20link; external dll_name name 'CFS20link';
	function CFS20endlink; external dll_name name 'CFS20endlink';

	function CFS20map_axes; external dll_name name 'CFS20map_axes';
	function CFS20get_mapped_axes; external dll_name name 'CFS20get_mapped_axes';
	procedure CFS20set_coordinate_mode; external dll_name name 'CFS20set_coordinate_mode';
	function CFS20get_coordinate_mode; external dll_name name 'CFS20get_coordinate_mode';
	procedure CFS20set_move_profile; external dll_name name 'CFS20set_move_profile';
	function CFS20get_move_profile; external dll_name name 'CFS20get_move_profile';
	procedure CFS20set_move_startstop_velocity; external dll_name name 'CFS20set_move_startstop_velocity';
	function CFS20get_move_startstop_velocity; external dll_name name 'CFS20get_move_startstop_velocity';
	procedure CFS20set_move_velocity; external dll_name name 'CFS20set_move_velocity';
	function CFS20get_move_velocity; external dll_name name 'CFS20get_move_velocity';
	procedure CFS20set_move_acceleration; external dll_name name 'CFS20set_move_acceleration';
	function CFS20get_move_acceleration; external dll_name name 'CFS20get_move_acceleration';
	procedure CFS20set_move_acceltime; external dll_name name 'CFS20set_move_acceltime';
	function CFS20get_move_acceltime; external dll_name name 'CFS20get_move_acceltime';
	function CFS20co_get_velocity; external dll_name name 'CFS20co_get_velocity';

	function CFS20move_2; external dll_name name 'CFS20move_2';
	function CFS20move_3; external dll_name name 'CFS20move_3';
	function CFS20move_4; external dll_name name 'CFS20move_4';
	function CFS20start_move_2; external dll_name name 'CFS20start_move_2';
	function CFS20start_move_3; external dll_name name 'CFS20start_move_3';
	function CFS20start_move_4; external dll_name name 'CFS20start_move_4';
	function CFS20co_motion_done; external dll_name name 'CFS20co_motion_done';
	function CFS20co_wait_for_done; external dll_name name 'CFS20co_wait_for_done';


	function CFS20move_all; external dll_name name 'CFS20move_all';
	function CFS20move_all_ex; external dll_name name 'CFS20move_all_ex';
	function CFS20r_move_all; external dll_name name 'CFS20r_move_all';
	function CFS20r_move_all_ex; external dll_name name 'CFS20r_move_all_ex';
	function CFS20start_move_all; external dll_name name 'CFS20start_move_all';
	function CFS20start_move_all_ex; external dll_name name 'CFS20start_move_all_ex';
	function CFS20start_r_move_all; external dll_name name 'CFS20start_r_move_all';
	function CFS20start_r_move_all_ex; external dll_name name 'CFS20start_r_move_all_ex';
	function CFS20s_move_all; external dll_name name 'CFS20s_move_all';
	function CFS20s_move_all_ex; external dll_name name 'CFS20s_move_all_ex';
	function CFS20rs_move_all; external dll_name name 'CFS20rs_move_all';
	function CFS20rs_move_all_ex; external dll_name name 'CFS20rs_move_all_ex';
	function CFS20start_s_move_all; external dll_name name 'CFS20start_s_move_all';
	function CFS20start_s_move_all_ex; external dll_name name 'CFS20start_s_move_all_ex';
	function CFS20start_rs_move_all; external dll_name name 'CFS20start_rs_move_all';
	function CFS20start_rs_move_all_ex; external dll_name name 'CFS20start_rs_move_all_ex';
	procedure CFS20set_s_rate_all; external dll_name name 'CFS20set_s_rate_all';
	procedure CFS20get_s_rate_all; external dll_name name 'CFS20get_s_rate_all';

	function CFS20wait_for_all; external dll_name name 'CFS20wait_for_all';

	function CFS20reset_axis_sync; external dll_name name 'CFS20reset_axis_sync';
	function CFS20set_axis_sync; external dll_name name 'CFS20set_axis_sync';
	function CFS20set_sync_axis; external dll_name name 'CFS20set_sync_axis';
	function CFS20get_sync_axis; external dll_name name 'CFS20get_sync_axis';
	function CFS20set_sync_module; external dll_name name 'CFS20set_sync_module';
	function CFS20get_sync_module; external dll_name name 'CFS20get_sync_module';

	function CFS20emergency_stop; external dll_name name 'CFS20emergency_stop';

	function CFS20abort_home_search; external dll_name name 'CFS20abort_home_search';
	function CFS20home_search; external dll_name name 'CFS20home_search';
	function CFS20home_search_all; external dll_name name 'CFS20home_search_all';
	function CFS20get_home_done; external dll_name name 'CFS20get_home_done';
	function CFS20get_home_done_all; external dll_name name 'CFS20get_home_done_all';
	function CFS20get_home_end_status; external dll_name name 'CFS20get_home_end_status';
	function CFS20get_home_end_status_all; external dll_name name 'CFS20get_home_end_status_all';
	function CFS20set_home_method; external dll_name name 'CFS20set_home_method';
	function CFS20get_home_method; external dll_name name 'CFS20get_home_method';
	function CFS20set_home_offset; external dll_name name 'CFS20set_home_offset';
	function CFS20get_home_offset; external dll_name name 'CFS20get_home_offset';
	function CFS20set_home_velocity; external dll_name name 'CFS20set_home_velocity';
	function CFS20get_home_velocity; external dll_name name 'CFS20get_home_velocity';
	function CFS20set_home_acceleration; external dll_name name 'CFS20set_home_acceleration';
	function CFS20get_home_acceleration; external dll_name name 'CFS20get_home_acceleration';
	function CFS20set_home_acceltime; external dll_name name 'CFS20set_home_acceltime';
	function CFS20get_home_acceltime; external dll_name name 'CFS20get_home_acceltime';
	function CFS20set_zphase_search_range; external dll_name name 'CFS20set_zphase_search_range';
	function CFS20get_zphase_search_range; external dll_name name 'CFS20get_zphase_search_range';
	function CFS20home_zero; external dll_name name 'CFS20home_zero';
	function CFS20home_zero_all; external dll_name name 'CFS20home_zero_all';


	function CFS20set_output; external dll_name name 'CFS20set_output';
	function CFS20get_output; external dll_name name 'CFS20get_output';
	function CFS20get_input; external dll_name name 'CFS20get_input';
	function CFS20set_output_bit; external dll_name name 'CFS20set_output_bit';
	function CFS20reset_output_bit; external dll_name name 'CFS20reset_output_bit';
	function CFS20output_bit_on; external dll_name name 'CFS20output_bit_on';
	function CFS20change_output_bit; external dll_name name 'CFS20change_output_bit';
	function CFS20input_bit_on; external dll_name name 'CFS20input_bit_on';
	function CFS20set_ui4_mode; external dll_name name 'CFS20set_ui4_mode';
	function CFS20get_ui4_mode; external dll_name name 'CFS20get_ui4_mode';
	function CFS20set_ui5_mode; external dll_name name 'CFS20set_ui5_mode';
	function CFS20get_ui5_mode; external dll_name name 'CFS20get_ui5_mode';

	function CFS20set_crc_mask; external dll_name name 'CFS20set_crc_mask';
	function CFS20get_crc_mask; external dll_name name 'CFS20get_crc_mask';
	function CFS20set_crc_level; external dll_name name 'CFS20set_crc_level';
	function CFS20get_crc_level; external dll_name name 'CFS20get_crc_level';
	function CFS20set_crc_nelm_mask; external dll_name name 'CFS20set_crc_nelm_mask';
	function CFS20get_crc_nelm_mask; external dll_name name 'CFS20get_crc_nelm_mask';
	function CFS20set_crc_nelm_level; external dll_name name 'CFS20set_crc_nelm_level';
	function CFS20get_crc_nelm_level; external dll_name name 'CFS20get_crc_nelm_level';
	function CFS20set_crc_pelm_mask; external dll_name name 'CFS20set_crc_pelm_mask';
	function CFS20get_crc_pelm_mask; external dll_name name 'CFS20get_crc_pelm_mask';
	function CFS20set_crc_pelm_level; external dll_name name 'CFS20set_crc_pelm_level';
	function CFS20get_crc_pelm_level; external dll_name name 'CFS20get_crc_pelm_level';
	function CFS20set_programmed_crc; external dll_name name 'CFS20set_programmed_crc';
	function CFS20get_programmed_crc; external dll_name name 'CFS20get_programmed_crc';

	function CFS20set_trigger_level; external dll_name name 'CFS20set_trigger_level';
	function CFS20get_trigger_level; external dll_name name 'CFS20get_trigger_level';
	function CFS20set_trigger_sel; external dll_name name 'CFS20set_trigger_sel';
	function CFS20get_trigger_sel; external dll_name name 'CFS20get_trigger_sel';
	function CFS20set_trigger_time; external dll_name name 'CFS20set_trigger_time';
	function CFS20get_trigger_time; external dll_name name 'CFS20get_trigger_time';
	function CFS20set_trigger_mode; external dll_name name 'CFS20set_trigger_mode';
	function CFS20get_trigger_mode; external dll_name name 'CFS20get_trigger_mode';
	function CFS20set_trigger_position; external dll_name name 'CFS20set_trigger_position';
	function CFS20get_trigger_position; external dll_name name 'CFS20get_trigger_position';
	function CFS20set_trigger_enable; external dll_name name 'CFS20set_trigger_enable';
	function CFS20is_trigger_enabled; external dll_name name 'CFS20is_trigger_enabled';
	function CFS20set_trigger_interrupt_enable; external dll_name name 'CFS20set_trigger_interrupt_enable';
	function CFS20is_trigger_interrupt_enabled; external dll_name name 'CFS20is_trigger_interrupt_enabled';

	function CFS20start_pr_move; external dll_name name 'CFS20start_pr_move';
	function CFS20start_pr_move_ex; external dll_name name 'CFS20start_pr_move_ex';
	function CFS20start_pra_move; external dll_name name 'CFS20start_pra_move';
	function CFS20start_pra_move_ex; external dll_name name 'CFS20start_pra_move_ex';
	function CFS20pr_move; external dll_name name 'CFS20pr_move';
	function CFS20pr_move_ex; external dll_name name 'CFS20pr_move_ex';
	function CFS20pra_move; external dll_name name 'CFS20pra_move';
	function CFS20pra_move_ex; external dll_name name 'CFS20pra_move_ex';
	function CFS20start_prs_move; external dll_name name 'CFS20start_prs_move';
	function CFS20start_prs_move_ex; external dll_name name 'CFS20start_prs_move_ex';
	function CFS20start_pras_move; external dll_name name 'CFS20start_pras_move';
	function CFS20start_pras_move_ex; external dll_name name 'CFS20start_pras_move_ex';
	function CFS20prs_move; external dll_name name 'CFS20prs_move';
	function CFS20prs_move_ex; external dll_name name 'CFS20prs_move_ex';
	function CFS20pras_move; external dll_name name 'CFS20pras_move';
	function CFS20pras_move_ex; external dll_name name 'CFS20pras_move_ex';
	function CFS20set_mark_signal_level; external dll_name name 'CFS20set_mark_signal_level';
	function CFS20get_mark_signal_level; external dll_name name 'CFS20get_mark_signal_level';
	function CFS20get_mark_signal_switch; external dll_name name 'CFS20get_mark_signal_switch';

	function CFS20set_mark_signal_enable; external dll_name name 'CFS20set_mark_signal_enable';
	function CFS20get_mark_signal_enable; external dll_name name 'CFS20get_mark_signal_enable';

	procedure CFS20set_internal_comparator_position; external dll_name name 'CFS20set_internal_comparator_position';
	function CFS20get_internal_comparator_position; external dll_name name 'CFS20get_internal_comparator_position';
	procedure CFS20set_external_comparator_position; external dll_name name 'CFS20set_external_comparator_position';
	function CFS20get_external_comparator_position; external dll_name name 'CFS20get_external_comparator_position';

	function CFS20get_error_code; external dll_name name 'CFS20get_error_code';
	function CFS20get_error_msg; external dll_name name 'CFS20get_error_msg';
end.