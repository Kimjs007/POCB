object frmChangePassword: TfrmChangePassword
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Change Password'
  ClientHeight = 204
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlPasswordChange: TRzPanel
    Left = 0
    Top = 0
    Width = 387
    Height = 35
    Align = alTop
    Alignment = taLeftJustify
    BorderOuter = fsFlat
    BorderSides = [sdBottom]
    Caption = 'Password Change'
    FlatColor = 10524310
    Font.Charset = ANSI_CHARSET
    Font.Color = 9856100
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    GradientColorStart = 11855600
    GradientColorStop = 9229030
    TextMargin = 4
    ParentFont = False
    TabOrder = 0
    VisualStyle = vsGradient
    WordWrap = False
  end
  object btnChange: TRzBitBtn
    Left = 58
    Top = 153
    Width = 120
    Height = 30
    FrameColor = clGradientActiveCaption
    Caption = 'Change'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    HotTrack = True
    ParentFont = False
    TabOrder = 1
    TextStyle = tsRecessed
    OnClick = btnChangeClick
  end
  object btnCancel: TRzBitBtn
    Left = 196
    Top = 153
    Width = 120
    Height = 30
    FrameColor = clGradientActiveCaption
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    HotTrack = True
    ParentFont = False
    TabOrder = 2
    TextStyle = tsRecessed
    OnClick = btnCancelClick
  end
  object grpSystem: TRzGroupBox
    Left = 12
    Top = 41
    Width = 355
    Height = 99
    Caption = 'Change Password'
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'Tahoma'
    CaptionFont.Style = [fsBold]
    Color = 16768443
    GradientColorStyle = gcsCustom
    GradientColorStop = 16768443
    GroupStyle = gsBanner
    TabOrder = 3
    object pnlCurrent: TRzPanel
      Left = 6
      Top = 24
      Width = 149
      Height = 21
      BorderOuter = fsFlatRounded
      Caption = 'Current Password'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object pnlChange: TRzPanel
      Left = 6
      Top = 48
      Width = 149
      Height = 21
      BorderOuter = fsFlatRounded
      Caption = 'Change Password'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object pnlConfirm: TRzPanel
      Left = 6
      Top = 71
      Width = 149
      Height = 21
      BorderOuter = fsFlatRounded
      Caption = 'Confirm Password'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object edCurPw: TRzEdit
      Left = 161
      Top = 24
      Width = 187
      Height = 22
      Text = ''
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      FocusColor = 14283263
      ImeName = 'Microsoft IME 2010'
      ParentFont = False
      TabOrder = 3
    end
    object edChangePw: TRzEdit
      Left = 161
      Top = 48
      Width = 187
      Height = 22
      Text = ''
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      FocusColor = 14283263
      ImeName = 'Microsoft IME 2010'
      ParentFont = False
      TabOrder = 4
    end
    object edConfirmPw: TRzEdit
      Left = 161
      Top = 72
      Width = 187
      Height = 22
      Text = ''
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      FocusColor = 14283263
      ImeName = 'Microsoft IME 2010'
      ParentFont = False
      TabOrder = 5
    end
  end
end
