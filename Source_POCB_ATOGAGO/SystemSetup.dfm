object frmSystemSetup: TfrmSystemSetup
  Left = 817
  Top = 559
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'System Information'
  ClientHeight = 678
  ClientWidth = 844
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 704
    Top = 408
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object pcSysConfig: TRzPageControl
    Left = 0
    Top = 0
    Width = 844
    Height = 678
    Hint = ''
    ActivePage = RztabSystemConfig
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabIndex = 0
    TabOrder = 0
    FixedDimension = 22
    object RztabSystemConfig: TRzTabSheet
      Caption = 'System Configuration'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object RzgrpSystem: TRzGroupBox
        Left = 13
        Top = 8
        Width = 405
        Height = 99
        Caption = 'SYSTEM'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768443
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 0
        object RzpnlStationID: TRzPanel
          Left = 6
          Top = 24
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Station ID'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object RzpnlUIType: TRzPanel
          Left = 6
          Top = 48
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'U.I Type'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          Visible = False
        end
        object RzpnlLanguage: TRzPanel
          Left = 6
          Top = 71
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Local Language'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          Visible = False
        end
        object edStationID: TRzEdit
          Left = 111
          Top = 24
          Width = 280
          Height = 22
          Text = 'DONGAELTEK'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 1
        end
        object cmbxUIType: TRzComboBox
          Left = 111
          Top = 48
          Width = 60
          Height = 22
          Style = csDropDownList
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 2
          Visible = False
          Items.Strings = (
            'Normal'
            'Black')
        end
        object cmbxLanguage: TRzComboBox
          Left = 111
          Top = 71
          Width = 60
          Height = 22
          Style = csDropDownList
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 3
          Text = #54620#44397#50612
          Visible = False
          Items.Strings = (
            #54620#44397#50612
            'Ti'#7871'ng Vi'#7879't')
          ItemIndex = 0
        end
        object btnSysConfPwdSetupAdmin: TRzBitBtn
          Left = 302
          Top = 48
          Width = 90
          Height = 45
          Caption = 'ADMIN Password Setup'
          HotTrack = True
          TabOrder = 6
          OnClick = btnSysConfPwdSetupAdminClick
          Glyph.Data = {
            36060000424D3606000000000000360400002800000020000000100000000100
            08000000000000020000420B0000420B00000001000000000000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8787878E8E8E8E8E8E8E8E8E8E8E8E8E8818181E8E8E8E8E8E8E8E8
            E8E8E8E878A3A3CE78E8E8E8E8E8E8E8E8E8E8E881ACACE881E8E8E8E8E8E8E8
            E8E8E878A378CCCE78E8E8E8E8E8E8E8E8E8E881AC81E8E881E8E8E8E8E8E8E8
            E8E878A378CCA3CE78E8E8E8E8E8E8E8E8E881AC81E8ACE881E8E8E8E8E8E8E8
            7878A378CCA3CE78E8E8E8E8E8E8E8E88181AC81E8ACE881E8E8E8E878787878
            A3A378CCA3CE78E8E8E8E8E881818181ACAC81E8ACE881E8E8E8E878CCCCCCCC
            7878CCA3CE78E8E8E8E8E881E8E8E8E88181E8ACE881E8E8E8E878CCCCA3CCCC
            CCCCA3CE78E8E8E8E8E881E8E8ACE8E8E8E8ACE881E8E8E8E8E878CCA3CCA3CC
            CCCCCE78E8E8E8E8E8E881E8ACE8ACE8E8E8E881E8E8E8E8E8E878CCCCA3CCA3
            CCCCCE78E8E8E8E8E8E881E8E8ACE8ACE8E8E881E8E8E8E8E8E878CCCCCCA3CC
            A3CCCE78E8E8E8E8E8E881E8E8E8ACE8ACE8E881E8E8E8E8E8E878CC7878CCA3
            CCA3CE78E8E8E8E8E8E881E88181E8ACE8ACE881E8E8E8E8E8E878D5A378CCCC
            A3CCD578E8E8E8E8E8E881E8AC81E8E8ACE8E881E8E8E8E8E8E8E878D5CECECE
            CED578E8E8E8E8E8E8E8E881E8E8E8E8E8E881E8E8E8E8E8E8E8E8E878787878
            7878E8E8E8E8E8E8E8E8E8E8818181818181E8E8E8E8E8E8E8E8}
          NumGlyphs = 2
        end
        object btnSysConfPwdSetupPM: TRzBitBtn
          Left = 210
          Top = 48
          Width = 90
          Height = 45
          Caption = 'PM   Password Setup'
          HotTrack = True
          TabOrder = 7
          Visible = False
          OnClick = btnSysConfPwdSetupPMClick
          Glyph.Data = {
            36060000424D3606000000000000360400002800000020000000100000000100
            08000000000000020000420B0000420B00000001000000000000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8787878E8E8E8E8E8E8E8E8E8E8E8E8E8818181E8E8E8E8E8E8E8E8
            E8E8E8E878A3A3CE78E8E8E8E8E8E8E8E8E8E8E881ACACE881E8E8E8E8E8E8E8
            E8E8E878A378CCCE78E8E8E8E8E8E8E8E8E8E881AC81E8E881E8E8E8E8E8E8E8
            E8E878A378CCA3CE78E8E8E8E8E8E8E8E8E881AC81E8ACE881E8E8E8E8E8E8E8
            7878A378CCA3CE78E8E8E8E8E8E8E8E88181AC81E8ACE881E8E8E8E878787878
            A3A378CCA3CE78E8E8E8E8E881818181ACAC81E8ACE881E8E8E8E878CCCCCCCC
            7878CCA3CE78E8E8E8E8E881E8E8E8E88181E8ACE881E8E8E8E878CCCCA3CCCC
            CCCCA3CE78E8E8E8E8E881E8E8ACE8E8E8E8ACE881E8E8E8E8E878CCA3CCA3CC
            CCCCCE78E8E8E8E8E8E881E8ACE8ACE8E8E8E881E8E8E8E8E8E878CCCCA3CCA3
            CCCCCE78E8E8E8E8E8E881E8E8ACE8ACE8E8E881E8E8E8E8E8E878CCCCCCA3CC
            A3CCCE78E8E8E8E8E8E881E8E8E8ACE8ACE8E881E8E8E8E8E8E878CC7878CCA3
            CCA3CE78E8E8E8E8E8E881E88181E8ACE8ACE881E8E8E8E8E8E878D5A378CCCC
            A3CCD578E8E8E8E8E8E881E8AC81E8E8ACE8E881E8E8E8E8E8E8E878D5CECECE
            CED578E8E8E8E8E8E8E8E881E8E8E8E8E8E881E8E8E8E8E8E8E8E8E878787878
            7878E8E8E8E8E8E8E8E8E8E8818181818181E8E8E8E8E8E8E8E8}
          NumGlyphs = 2
        end
      end
      object RzgrpSerialSetting: TRzGroupBox
        Left = 424
        Top = 7
        Width = 400
        Height = 202
        Caption = 'Serial Port Setting'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768443
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 3
        object RzpnlBCR: TRzPanel
          Left = 6
          Top = 25
          Width = 114
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'BCR'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object cmbxRCB1: TRzComboBox
          Left = 126
          Top = 49
          Width = 269
          Height = 22
          Style = csDropDownList
          Color = clWhite
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FlatButtons = True
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 2
          Items.Strings = (
            'None'
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8'
            'COM9'
            'COM10'
            'COM11'
            'COM12'
            'COM13'
            'COM14'
            'COM15'
            'COM16'
            'COM17'
            'COM18'
            'COM19'
            'COM20')
          Values.Strings = (
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            '')
        end
        object RzpnlRCB1: TRzPanel
          Left = 6
          Top = 49
          Width = 114
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Swith Box (Ch1)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object cmbxBCR: TRzComboBox
          Left = 126
          Top = 24
          Width = 269
          Height = 22
          Style = csDropDownList
          Color = clWhite
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FlatButtons = True
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          Items.Strings = (
            'None'
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8'
            'COM9'
            'COM10'
            'COM11'
            'COM12'
            'COM13'
            'COM14'
            'COM15'
            'COM16'
            'COM17'
            'COM18'
            'COM19'
            'COM20'
            'COM21'
            'COM22'
            'COM23'
            'COM24'
            'COM25'
            'COM26'
            'COM27'
            'COM28'
            'COM29'
            'COM30')
          Values.Strings = (
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            '')
        end
        object cmbxRCB2: TRzComboBox
          Left = 126
          Top = 72
          Width = 269
          Height = 22
          Style = csDropDownList
          Color = clWhite
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FlatButtons = True
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 4
          Items.Strings = (
            'None'
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8'
            'COM9'
            'COM10'
            'COM11'
            'COM12'
            'COM13'
            'COM14'
            'COM15'
            'COM16'
            'COM17'
            'COM18'
            'COM19'
            'COM20')
          Values.Strings = (
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            '')
        end
        object RzpnlRCB2: TRzPanel
          Left = 6
          Top = 72
          Width = 114
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Swith Box (Ch2)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object RzpnlExLight: TRzPanel
          Left = 6
          Top = 97
          Width = 114
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'ExLight'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object cmbxExLight: TRzComboBox
          Left = 126
          Top = 97
          Width = 269
          Height = 22
          Style = csDropDownList
          Color = clWhite
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FlatButtons = True
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 7
          Items.Strings = (
            'None'
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8'
            'COM9'
            'COM10'
            'COM11'
            'COM12'
            'COM13'
            'COM14'
            'COM15'
            'COM16'
            'COM17'
            'COM18'
            'COM19'
            'COM20')
          Values.Strings = (
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            '')
        end
        object RzpnlEFU: TRzPanel
          Left = 6
          Top = 121
          Width = 114
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'EFU'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object cmbxEFU: TRzComboBox
          Left = 126
          Top = 121
          Width = 269
          Height = 22
          Style = csDropDownList
          Color = clWhite
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FlatButtons = True
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 9
          Items.Strings = (
            'None'
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8'
            'COM9'
            'COM10'
            'COM11'
            'COM12'
            'COM13'
            'COM14'
            'COM15'
            'COM16'
            'COM17'
            'COM18'
            'COM19'
            'COM20')
          Values.Strings = (
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            '')
        end
        object RzpnlIonizer1: TRzPanel
          Left = 6
          Top = 145
          Width = 114
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Ionizer (Ch1)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
        end
        object cmbxION1: TRzComboBox
          Left = 126
          Top = 145
          Width = 132
          Height = 22
          Style = csDropDownList
          Color = clWhite
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FlatButtons = True
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 11
          Items.Strings = (
            'None'
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8'
            'COM9'
            'COM10'
            'COM11'
            'COM12'
            'COM13'
            'COM14'
            'COM15'
            'COM16'
            'COM17'
            'COM18'
            'COM19'
            'COM20')
          Values.Strings = (
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            '')
        end
        object RzpnlIonizer2: TRzPanel
          Left = 6
          Top = 168
          Width = 114
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Ionizer (Ch2)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
        end
        object cmbxION2: TRzComboBox
          Left = 126
          Top = 168
          Width = 132
          Height = 22
          Style = csDropDownList
          Color = clWhite
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FlatButtons = True
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 13
          Items.Strings = (
            'None'
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8'
            'COM9'
            'COM10'
            'COM11'
            'COM12'
            'COM13'
            'COM14'
            'COM15'
            'COM16'
            'COM17'
            'COM18'
            'COM19'
            'COM20')
          Values.Strings = (
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            '')
        end
        object cmbxION1_2: TRzComboBox
          Left = 263
          Top = 145
          Width = 132
          Height = 22
          Style = csDropDownList
          Color = clWhite
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FlatButtons = True
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 14
          Items.Strings = (
            'None'
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8'
            'COM9'
            'COM10'
            'COM11'
            'COM12'
            'COM13'
            'COM14'
            'COM15'
            'COM16'
            'COM17'
            'COM18'
            'COM19'
            'COM20')
          Values.Strings = (
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            '')
        end
        object cmbxION2_2: TRzComboBox
          Left = 263
          Top = 168
          Width = 132
          Height = 22
          Style = csDropDownList
          Color = clWhite
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FlatButtons = True
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 15
          Items.Strings = (
            'None'
            'COM1'
            'COM2'
            'COM3'
            'COM4'
            'COM5'
            'COM6'
            'COM7'
            'COM8'
            'COM9'
            'COM10'
            'COM11'
            'COM12'
            'COM13'
            'COM14'
            'COM15'
            'COM16'
            'COM17'
            'COM18'
            'COM19'
            'COM20')
          Values.Strings = (
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            '')
        end
      end
      object RzgrpAutoBackup: TRzGroupBox
        Left = 13
        Top = 268
        Width = 405
        Height = 78
        Caption = 'Auto Backup'
        Color = 16768443
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        ParentFont = False
        TabOrder = 2
        object cbAutoBackup: TRzCheckBox
          Left = 6
          Top = 27
          Width = 148
          Height = 18
          Caption = 'Use Auto Backup'
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbUnchecked
          TabOrder = 0
          UseCustomGlyphs = True
          OnClick = cbAutoBackupClick
        end
        object btnAutoBackup: TRzBitBtn
          Left = 218
          Top = 24
          Width = 183
          Caption = 'Add'
          HotTrack = True
          TabOrder = 1
          OnClick = btnAutoBackupClick
          Glyph.Data = {
            36060000424D3606000000000000360400002800000020000000100000000100
            08000000000000020000830B0000830B00000001000000000000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            09090909E8E8E8E8E8E8E8E8E8E8E8E881818181E8E8E8E8E8E8E8E8E8E8E8E8
            09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
            09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
            09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E809090909
            0910100909090909E8E8E8E88181818181ACAC8181818181E8E8E8E809101010
            1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809101010
            1010101010101009E8E8E8E881ACACACACACACACACACAC81E8E8E8E809090909
            0910100909090909E8E8E8E88181818181ACAC8181818181E8E8E8E8E8E8E8E8
            09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
            09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
            09101009E8E8E8E8E8E8E8E8E8E8E8E881ACAC81E8E8E8E8E8E8E8E8E8E8E8E8
            09090909E8E8E8E8E8E8E8E8E8E8E8E881818181E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
          NumGlyphs = 2
        end
        object edAutoBackup: TRzEdit
          Left = 6
          Top = 51
          Width = 393
          Height = 21
          Text = ''
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          TabOrder = 2
        end
      end
      object btnSysConfPgBmpDown: TRzBitBtn
        Left = 305
        Top = 113
        Width = 100
        Height = 40
        Caption = 'PG BMP Download'
        HotTrack = True
        TabOrder = 1
        OnClick = btnSysConfPgBmpDownClick
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000630B0000630B00000001000000000000000000003300
          00006600000099000000CC000000FF0000000033000033330000663300009933
          0000CC330000FF33000000660000336600006666000099660000CC660000FF66
          000000990000339900006699000099990000CC990000FF99000000CC000033CC
          000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
          0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
          330000333300333333006633330099333300CC333300FF333300006633003366
          33006666330099663300CC663300FF6633000099330033993300669933009999
          3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
          330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
          66006600660099006600CC006600FF0066000033660033336600663366009933
          6600CC336600FF33660000666600336666006666660099666600CC666600FF66
          660000996600339966006699660099996600CC996600FF99660000CC660033CC
          660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
          6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
          990000339900333399006633990099339900CC339900FF339900006699003366
          99006666990099669900CC669900FF6699000099990033999900669999009999
          9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
          990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
          CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
          CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
          CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
          CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
          CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
          FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
          FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
          FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
          FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
          000000808000800000008000800080800000C0C0C00080808000191919004C4C
          4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
          6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000E8A3A3A3CECE
          CECECECECECECECECECEE8818181ACACACACACACACACACACACACCECEA3A3A3CE
          CECECECECECECECECECEACAC818181ACACACACACACACACACACACCECECE12D9D9
          CE79797979A3CECECE79ACACAC818181AC8181818181ACACAC81CECECE121ED9
          CEA3A4A4A3CECECECECEACACAC81AC81AC81ACAC81ACACACACACCECECE121ED9
          CECEA3A3CECE7979CECEACACAC81AC81ACAC8181ACAC8181ACACCECECE121E1E
          D9CECECECECECECECECEACACAC81ACAC81ACACACACACACACACACCECECE121E3D
          1ED9CECECECECECECECEACACAC81ACACAC81ACACACACACACACAC8962D91E1E12
          1E1E1289898989898989E8AC81ACAC81ACAC81E8E8E8E8E8E8E889121E121ED9
          121E1289898989898989E881AC81AC8181AC81E8E8E8E8E8E8E889121E121ED9
          62126289898989898989E881AC81AC81AC81ACE8E8E8E8E8E8E889121E121ED9
          8989898989CCCCCC8989E881AC81AC81E8E8E8E8E8818181E8E8896212121ED9
          89898989CCD4D4D4CC89E8AC8181AC81E8E8E8E881ACACAC81E8898989121ED9
          89898989CCD4D4D4CC89E8E8E881AC81E8E8E8E881ACACAC81E8898989621262
          89898989CCD4D4D4CC89E8E8E8AC81ACE8E8E8E881ACACAC81E8898989898989
          8989898989CCCCCC8989E8E8E8E8E8E8E8E8E8E8E8818181E8E8898989898989
          89898989898989898989E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
        NumGlyphs = 2
      end
      object btnSysConfPgFwDown: TRzBitBtn
        Left = 199
        Top = 113
        Width = 100
        Height = 40
        Caption = 'PG FW Download'
        HotTrack = True
        TabOrder = 4
        OnClick = btnSysConfPgFwDownClick
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000520B0000520B00000001000000000000000000003300
          00006600000099000000CC000000FF0000000033000033330000663300009933
          0000CC330000FF33000000660000336600006666000099660000CC660000FF66
          000000990000339900006699000099990000CC990000FF99000000CC000033CC
          000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
          0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
          330000333300333333006633330099333300CC333300FF333300006633003366
          33006666330099663300CC663300FF6633000099330033993300669933009999
          3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
          330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
          66006600660099006600CC006600FF0066000033660033336600663366009933
          6600CC336600FF33660000666600336666006666660099666600CC666600FF66
          660000996600339966006699660099996600CC996600FF99660000CC660033CC
          660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
          6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
          990000339900333399006633990099339900CC339900FF339900006699003366
          99006666990099669900CC669900FF6699000099990033999900669999009999
          9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
          990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
          CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
          CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
          CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
          CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
          CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
          FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
          FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
          FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
          FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
          000000808000800000008000800080800000C0C0C00080808000191919004C4C
          4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
          6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000E8E8E8E8E8AA
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E881E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8AA
          A2E8E8E8E8E8E8E8E8E8E8E8E8E8E88181E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          AAA2E8E8E8E8E8E8E8E8E8E8E8E8E8E88181E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          AAD5A2E8E8E8E8E8E8E8E8E8E8E8E8E881E381E8E8E8E8E8E8E8E8E8E8E8AAA2
          A2A2D4A2E8E8E8E8E8E8E8E8E8E881818181AC81E8E8E8E8E8E8E8E8E8E8AAD5
          D4D4D4D4A2E8E8E8E8E8E8E8E8E881E3ACACACAC81E8E8E8E8E8E8E8E8E8E8AA
          D5D4A2AAAAAAE8E8E8E8E8E8E8E8E881E3AC81818181E8E8E8E8E8E8E8E8E8AA
          D5D4D4A2E8E8E8E8E8E8E8E8E8E8E881E3ACAC81E8E8E8E8E8E8E8E8AAA2A2A2
          A2D5D4D4A2E8E8E8E8E8E8E88181818181E3ACAC81E8E8E8E8E8E8E8AAD5D5D4
          D4D4D4D4D4A2E8E8E8E8E8E881E3E3ACACACACACAC81E8E8E8E8E8E8E8AAD5D5
          D4D4A2AAAAAAE8E8E8E8E8E8E881E3E3ACAC81818181E8E8E8E8E8E8E8AAD5D5
          D5D4D4A2E8E8E8E8E8E8E8E8E881E3E3E3ACAC81E8E8E8E8E8E8E8E8E8E8AAD5
          D5D5D4D4A2E8E8E8E8E8E8E8E8E881E3E3E3ACAC81E8E8E8E8E8E8E8E8E8AAD5
          D5D5D4D4D4A2E8E8E8E8E8E8E8E881E3E3E3ACACAC81E8E8E8E8E8E8E8E8E8AA
          D5D5D5D4D4D4A2E8E8E8E8E8E8E8E881E3E3E3ACACAC81E8E8E8E8E8E8E8E8AA
          AAAAAAAAAAAAAAAAE8E8E8E8E8E8E8818181818181818181E8E8}
        NumGlyphs = 2
      end
      object RzgrpShareFolder: TRzGroupBox
        Left = 13
        Top = 352
        Width = 405
        Height = 80
        Caption = 'Compensation Files Share folder'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768443
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 5
        object btnSharefolder: TRzBitBtn
          Left = 6
          Top = 24
          Width = 183
          Caption = 'Open'
          HotTrack = True
          TabOrder = 0
          OnClick = btnSharefolderClick
          Glyph.Data = {
            36060000424D3606000000000000360400002800000020000000100000000100
            08000000000000020000430B0000430B00000001000000000000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8A378787878
            787878787878AAE8E8E8E88181818181818181818181ACE8E8E8A3A3D5CECECE
            CECECECECEA378E8E8E88181E3ACACACACACACACAC8181E8E8E8A3A3CED5D5D5
            D5D5D5D5D5CE78A3E8E88181ACE3E3E3E3E3E3E3E3AC8181E8E8A3A3CED5D5D5
            D5D5D5D5D5CEAA78E8E88181ACE3E3E3E3E3E3E3E3ACAC81E8E8A3CEA3D5D5D5
            D5D5D5D5D5CED578A3E881AC81E3E3E3E3E3E3E3E3ACE38181E8A3CEAAAAD5D5
            D5D5D5D5D5CED5AA78E881ACACACE3E3E3E3E3E3E3ACE3AC81E8A3D5CEA3D6D6
            D6D6D6D6D6D5D6D678E881E3AC81E3E3E3E3E3E3E3E3E3E381E8A3D5D5CEA3A3
            A3A3A3A3A3A3A3A3CEE881E3E3AC81818181818181818181ACE8A3D6D5D5D5D5
            D6D6D6D6D678E8E8E8E881E3E3E3E3E3E3E3E3E3E381E8E8E8E8E8A3D6D6D6D6
            A3A3A3A3A3E8E8E8E8E8E881E3E3E3E38181818181E8E8E8E8E8E8E8A3A3A3A3
            E8E8E8E8E8E8E8090909E8E881818181E8E8E8E8E8E8E8818181E8E8E8E8E8E8
            E8E8E8E8E8E8E8E80909E8E8E8E8E8E8E8E8E8E8E8E8E8E88181E8E8E8E8E8E8
            E8E8E809E8E8E809E809E8E8E8E8E8E8E8E8E881E8E8E881E881E8E8E8E8E8E8
            E8E8E8E8090909E8E8E8E8E8E8E8E8E8E8E8E8E8818181E8E8E8}
          NumGlyphs = 2
        end
        object edSharefolder: TRzEdit
          Left = 6
          Top = 51
          Width = 393
          Height = 21
          Text = ''
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          TabOrder = 1
        end
      end
      object RzgrpUseCh: TRzGroupBox
        Left = 424
        Top = 266
        Width = 400
        Height = 42
        Caption = 'CH Usage'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768443
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 6
        Visible = False
        object cbUseCh1: TRzCheckBox
          Left = 10
          Top = 19
          Width = 54
          Height = 18
          Caption = 'Ch1'
          Checked = True
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbChecked
          TabOrder = 0
          UseCustomGlyphs = True
          OnClick = cbAutoBackupClick
        end
        object cbUseCh2: TRzCheckBox
          Left = 102
          Top = 19
          Width = 54
          Height = 18
          Caption = 'Ch2'
          Checked = True
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbChecked
          TabOrder = 1
          UseCustomGlyphs = True
          OnClick = cbAutoBackupClick
        end
      end
      object RzgrpFPCUsageLimit: TRzGroupBox
        Left = 424
        Top = 214
        Width = 400
        Height = 48
        Caption = 'FPC Usage Limit'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768443
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 7
        object RzlblFpcUsageMaxTitle: TRzLabel
          Left = 247
          Top = 28
          Width = 25
          Height = 14
          Caption = 'max'
          Font.Charset = ANSI_CHARSET
          Font.Color = 7879740
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
          BlinkIntervalOff = 1000
          BlinkIntervalOn = 1000
        end
        object cbFpcUsageLimit: TRzCheckBox
          Left = 14
          Top = 25
          Width = 174
          Height = 18
          Caption = 'Use FPC Usage Limit'
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbUnchecked
          TabOrder = 0
          UseCustomGlyphs = True
        end
        object edFpcUsageLimit: TRzEdit
          Left = 278
          Top = 23
          Width = 100
          Height = 22
          Text = '0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 1
        end
      end
      object RzGroupBox1: TRzGroupBox
        Left = 424
        Top = 312
        Width = 400
        Height = 90
        Caption = 'Serial Number matching Check.'
        Color = 16768443
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 8
        object Max1000: TLabel
          Left = 272
          Top = 71
          Width = 56
          Height = 13
          Caption = 'MAX 1000'
        end
        object chkSerialMatch: TRzCheckBox
          Left = 10
          Top = 20
          Width = 229
          Height = 18
          Caption = 'Use Serial Number Matching'
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbUnchecked
          TabOrder = 0
          UseCustomGlyphs = True
        end
        object RzPanel2: TRzPanel
          Left = 8
          Top = 68
          Width = 155
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Previous Serial No Count'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object edSerialMatch: TRzEdit
          Left = 165
          Top = 68
          Width = 101
          Height = 21
          Text = ''
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          TabOrder = 2
        end
        object btnMatchSerialFolder: TRzBitBtn
          Left = 318
          Top = 39
          Height = 24
          Caption = 'Open'
          HotTrack = True
          TabOrder = 3
          OnClick = btnMatchSerialFolderClick
          Glyph.Data = {
            36060000424D3606000000000000360400002800000020000000100000000100
            08000000000000020000430B0000430B00000001000000000000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8A378787878
            787878787878AAE8E8E8E88181818181818181818181ACE8E8E8A3A3D5CECECE
            CECECECECEA378E8E8E88181E3ACACACACACACACAC8181E8E8E8A3A3CED5D5D5
            D5D5D5D5D5CE78A3E8E88181ACE3E3E3E3E3E3E3E3AC8181E8E8A3A3CED5D5D5
            D5D5D5D5D5CEAA78E8E88181ACE3E3E3E3E3E3E3E3ACAC81E8E8A3CEA3D5D5D5
            D5D5D5D5D5CED578A3E881AC81E3E3E3E3E3E3E3E3ACE38181E8A3CEAAAAD5D5
            D5D5D5D5D5CED5AA78E881ACACACE3E3E3E3E3E3E3ACE3AC81E8A3D5CEA3D6D6
            D6D6D6D6D6D5D6D678E881E3AC81E3E3E3E3E3E3E3E3E3E381E8A3D5D5CEA3A3
            A3A3A3A3A3A3A3A3CEE881E3E3AC81818181818181818181ACE8A3D6D5D5D5D5
            D6D6D6D6D678E8E8E8E881E3E3E3E3E3E3E3E3E3E381E8E8E8E8E8A3D6D6D6D6
            A3A3A3A3A3E8E8E8E8E8E881E3E3E3E38181818181E8E8E8E8E8E8E8A3A3A3A3
            E8E8E8E8E8E8E8090909E8E881818181E8E8E8E8E8E8E8818181E8E8E8E8E8E8
            E8E8E8E8E8E8E8E80909E8E8E8E8E8E8E8E8E8E8E8E8E8E88181E8E8E8E8E8E8
            E8E8E809E8E8E809E809E8E8E8E8E8E8E8E8E881E8E8E881E881E8E8E8E8E8E8
            E8E8E8E8090909E8E8E8E8E8E8E8E8E8E8E8E8E8818181E8E8E8}
          NumGlyphs = 2
        end
        object edMatchSerialFolder: TRzEdit
          Left = 8
          Top = 41
          Width = 306
          Height = 21
          Text = ''
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          TabOrder = 4
        end
      end
      object RzgrpSysConfEtc: TRzGroupBox
        Left = 424
        Top = 408
        Width = 400
        Height = 72
        Caption = 'ETC'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768700
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 9
        object RzpnlScreenSaver: TRzPanel
          Left = 4
          Top = 23
          Width = 353
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Screen Saver time(min)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object edScreenSaverTime: TRzEdit
          Left = 356
          Top = 23
          Width = 40
          Height = 21
          Text = ''
          Alignment = taRightJustify
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          TabOrder = 1
        end
        object RzpnlIdlePmModeLogInPopUp: TRzPanel
          Left = 4
          Top = 45
          Width = 353
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Login Pop-up after Idle PM mode time(min) [0:disable, 10~]'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object edIdlePmModeLogInPopUpTime: TRzNumericEdit
          Left = 356
          Top = 45
          Width = 40
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 7879740
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          IntegersOnly = False
          Max = 99999.000000000000000000
          DisplayFormat = '0;-0'
          Value = 30.000000000000000000
        end
      end
      object RzgrpGRR: TRzGroupBox
        Left = 13
        Top = 438
        Width = 105
        Height = 42
        Caption = 'Gage R&&R'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768700
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 10
        object cbUseGRR: TRzCheckBox
          Left = 10
          Top = 19
          Width = 85
          Height = 18
          Caption = 'Use GRR'
          Color = 16768700
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentColor = False
          ParentFont = False
          State = cbUnchecked
          TabOrder = 0
          UseCustomGlyphs = True
          OnClick = cbAutoBackupClick
        end
      end
      object btnSysConfSpiDownload: TRzBitBtn
        Left = 199
        Top = 154
        Width = 100
        Height = 40
        Caption = 'SPI FW/BOOT Download'
        HotTrack = True
        TabOrder = 11
        OnClick = btnSysConfSpiDownloadClick
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000520B0000520B00000001000000000000000000003300
          00006600000099000000CC000000FF0000000033000033330000663300009933
          0000CC330000FF33000000660000336600006666000099660000CC660000FF66
          000000990000339900006699000099990000CC990000FF99000000CC000033CC
          000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
          0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
          330000333300333333006633330099333300CC333300FF333300006633003366
          33006666330099663300CC663300FF6633000099330033993300669933009999
          3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
          330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
          66006600660099006600CC006600FF0066000033660033336600663366009933
          6600CC336600FF33660000666600336666006666660099666600CC666600FF66
          660000996600339966006699660099996600CC996600FF99660000CC660033CC
          660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
          6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
          990000339900333399006633990099339900CC339900FF339900006699003366
          99006666990099669900CC669900FF6699000099990033999900669999009999
          9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
          990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
          CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
          CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
          CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
          CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
          CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
          FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
          FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
          FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
          FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
          000000808000800000008000800080800000C0C0C00080808000191919004C4C
          4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
          6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000E8E8E8E8E8AA
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E881E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8AA
          A2E8E8E8E8E8E8E8E8E8E8E8E8E8E88181E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          AAA2E8E8E8E8E8E8E8E8E8E8E8E8E8E88181E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          AAD5A2E8E8E8E8E8E8E8E8E8E8E8E8E881E381E8E8E8E8E8E8E8E8E8E8E8AAA2
          A2A2D4A2E8E8E8E8E8E8E8E8E8E881818181AC81E8E8E8E8E8E8E8E8E8E8AAD5
          D4D4D4D4A2E8E8E8E8E8E8E8E8E881E3ACACACAC81E8E8E8E8E8E8E8E8E8E8AA
          D5D4A2AAAAAAE8E8E8E8E8E8E8E8E881E3AC81818181E8E8E8E8E8E8E8E8E8AA
          D5D4D4A2E8E8E8E8E8E8E8E8E8E8E881E3ACAC81E8E8E8E8E8E8E8E8AAA2A2A2
          A2D5D4D4A2E8E8E8E8E8E8E88181818181E3ACAC81E8E8E8E8E8E8E8AAD5D5D4
          D4D4D4D4D4A2E8E8E8E8E8E881E3E3ACACACACACAC81E8E8E8E8E8E8E8AAD5D5
          D4D4A2AAAAAAE8E8E8E8E8E8E881E3E3ACAC81818181E8E8E8E8E8E8E8AAD5D5
          D5D4D4A2E8E8E8E8E8E8E8E8E881E3E3E3ACAC81E8E8E8E8E8E8E8E8E8E8AAD5
          D5D5D4D4A2E8E8E8E8E8E8E8E8E881E3E3E3ACAC81E8E8E8E8E8E8E8E8E8AAD5
          D5D5D4D4D4A2E8E8E8E8E8E8E8E881E3E3E3ACACAC81E8E8E8E8E8E8E8E8E8AA
          D5D5D5D4D4D4A2E8E8E8E8E8E8E8E881E3E3E3ACACAC81E8E8E8E8E8E8E8E8AA
          AAAAAAAAAAAAAAAAE8E8E8E8E8E8E8818181818181818181E8E8}
        NumGlyphs = 2
      end
      object grpPgSpiOptions: TRzGroupBox
        Left = 13
        Top = 113
        Width = 180
        Height = 80
        Caption = 'PG/SPI Board'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768700
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 12
        object RzpnlPgType: TRzPanel
          Left = 4
          Top = 24
          Width = 50
          Height = 24
          BorderOuter = fsFlatRounded
          Caption = 'PG'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object cmbxPgType: TRzComboBox
          Left = 55
          Top = 24
          Width = 120
          Height = 24
          AutoDropDown = True
          Style = csDropDownList
          Color = clWhite
          Ctl3D = False
          DropDownCount = 12
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FlatButtons = True
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 1
          Items.Strings = (
            'None'
            'DP489'
            'DP201')
          Values.Strings = (
            '0'
            '1'
            '2')
        end
        object RzpnlSpiType: TRzPanel
          Left = 4
          Top = 51
          Width = 50
          Height = 24
          BorderOuter = fsFlatRounded
          Caption = 'SPI'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object cmbxSpiType: TRzComboBox
          Left = 55
          Top = 51
          Width = 120
          Height = 24
          AutoDropDown = True
          Style = csDropDownList
          Color = clWhite
          Ctl3D = False
          DropDownCount = 12
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FlatButtons = True
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 3
          Items.Strings = (
            'None'
            'DJ023_SPI'
            'DJ201_QSPI')
          Values.Strings = (
            '0'
            '1'
            '2')
        end
      end
      object RzgrpAssyPOCB: TRzGroupBox
        Left = 13
        Top = 200
        Width = 405
        Height = 62
        Caption = 'Assy-POCB (1CG 2Panel)'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768700
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 13
        object cbUseAssyPOCB: TRzCheckBox
          Left = 10
          Top = 20
          Width = 195
          Height = 18
          Caption = 'Use ASSY (1CG 2Panel)'
          Color = 16768700
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentColor = False
          ParentFont = False
          State = cbUnchecked
          TabOrder = 0
          UseCustomGlyphs = True
          OnClick = cbAutoBackupClick
        end
        object cbUseSkipPocbConfirm: TRzCheckBox
          Left = 10
          Top = 42
          Width = 393
          Height = 18
          Caption = 'Use Camera Process RUN/SKIP Confirm (PM Mode)'
          Color = 16768700
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentColor = False
          ParentFont = False
          State = cbUnchecked
          TabOrder = 1
          UseCustomGlyphs = True
          OnClick = cbAutoBackupClick
        end
      end
    end
    object RztabMesEasConfig: TRzTabSheet
      Caption = 'MES and EAS Configuration'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object RzgrpGmes: TRzGroupBox
        Left = 12
        Top = 9
        Width = 400
        Height = 252
        Caption = 'GEMS'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768443
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 0
        object RzpnlGmesServicePort: TRzPanel
          Left = 6
          Top = 25
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Service Port'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object RzpnlGmesNetwork: TRzPanel
          Left = 6
          Top = 49
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Network'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object RzpnlGmesDeamonPort: TRzPanel
          Left = 6
          Top = 72
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Deamon Port'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object edGmesServicePort: TRzEdit
          Left = 111
          Top = 25
          Width = 280
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 0
        end
        object edGmesNetwork: TRzEdit
          Left = 111
          Top = 49
          Width = 280
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 1
        end
        object edGmesDeamonPort: TRzEdit
          Left = 111
          Top = 72
          Width = 280
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 2
        end
        object RzpnlGmesLocalSubject: TRzPanel
          Left = 6
          Top = 96
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Local Subject'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object RzpnlGmesRemoteSubject: TRzPanel
          Left = 6
          Top = 120
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Remote Subject'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
        object edGmesLocalSubject: TRzEdit
          Left = 111
          Top = 96
          Width = 280
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 3
        end
        object edGmesRemoteSubject: TRzEdit
          Left = 111
          Top = 120
          Width = 280
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 4
        end
        object cbGmesUseEQCC: TRzCheckBox
          Left = 15
          Top = 195
          Width = 136
          Height = 18
          Caption = 'Use MES_EQCC'
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbUnchecked
          TabOrder = 10
          UseCustomGlyphs = True
          Visible = False
        end
        object RzpnlGmesEqccInterval: TRzPanel
          Left = 6
          Top = 147
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'EQCC Interval'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          Visible = False
        end
        object edGmesEqccInterval: TRzEdit
          Left = 111
          Top = 147
          Width = 229
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 12
          Visible = False
        end
        object RzpnlGmesEqccIntMsec: TRzPanel
          Left = 346
          Top = 148
          Width = 45
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'ms'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
          Visible = False
        end
        object btnGmesLoadConfig: TRzBitBtn
          Left = 211
          Top = 175
          Width = 183
          Caption = 'Load GMES Config file'
          HotTrack = True
          TabOrder = 14
          Visible = False
          Glyph.Data = {
            36060000424D3606000000000000360400002800000020000000100000000100
            08000000000000020000D30B0000D30B00000001000000000000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8818181
            81818181818181E8E8E8E8E8E881818181818181818181E8E8E8E8E881E2E2E2
            E2E281E281818181E8E8E8E881E2E2E2E2E281E281818181E8E8E8E881ACE2E2
            E2E2E281E2818181E8E8E8E881ACE2E2E2E2E281E2818181E8E8E8E881E2ACE2
            E2E2E2E281E28181E8E8E8E881E2ACE2E2E2E2E281E28181E8E8E8E881ACE2AC
            E2E2E2E2E281E281E8E8E8E881ACE2ACE2E2E2E2E281E281E8E8E8E881ACACE2
            ACE2E2E2E2E28181E8E8E8E881ACACE2ACE2E2E2E2E28181E8E8E8E881E3ACAC
            E2ACE2E2E2E2E281E8E8E8E881E3ACACE2ACE2E2E2E2E281E8E8E8E881E3E3AC
            ACE2ACE2E2E2E281E8E8E8E881E3E3ACACE2ACE2E2E2E281E8E8E8E8E8818181
            81818181818181E8E8E8E8E8E881818181818181818181E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
          NumGlyphs = 2
        end
        object cbGmesUseGib: TRzCheckBox
          Left = 15
          Top = 175
          Width = 83
          Height = 18
          Caption = 'Use GIB'
          Color = 16768700
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentColor = False
          ParentFont = False
          State = cbUnchecked
          TabOrder = 15
          UseCustomGlyphs = True
        end
        object chkConfirmHost: TRzCheckBox
          Left = 15
          Top = 219
          Width = 183
          Height = 18
          Caption = 'Confirm Sending Host'
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbUnchecked
          TabOrder = 16
          UseCustomGlyphs = True
        end
      end
      object RzgrpEAS: TRzGroupBox
        Left = 418
        Top = 9
        Width = 400
        Height = 168
        Caption = 'EAS'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768443
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 1
        object RzpnlEasServicePortTilte: TRzPanel
          Left = 6
          Top = 46
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Service Port'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object RzpnlEasNetworkTitle: TRzPanel
          Left = 6
          Top = 69
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Network'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object RzpnlEasSaemonPortTitle: TRzPanel
          Left = 6
          Top = 92
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Deamon Port'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object edEasServicePort: TRzEdit
          Left = 111
          Top = 45
          Width = 280
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 0
        end
        object edEasNetwork: TRzEdit
          Left = 111
          Top = 69
          Width = 280
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 1
        end
        object edEasDeamonPort: TRzEdit
          Left = 111
          Top = 92
          Width = 280
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 2
        end
        object RzpnlEasRemoteSubjectTitle: TRzPanel
          Left = 6
          Top = 140
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Remote Subject'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object edEasRemoteSubject: TRzEdit
          Left = 111
          Top = 140
          Width = 280
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 3
        end
        object cbEasUseAPDR: TRzCheckBox
          Left = 16
          Top = 22
          Width = 95
          Height = 18
          Caption = 'Use APDR'
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbUnchecked
          TabOrder = 8
          UseCustomGlyphs = True
        end
        object RzpnlEasLocalSubjectTitle: TRzPanel
          Left = 6
          Top = 116
          Width = 99
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Local Subject'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
        object edEasLocalSubject: TRzEdit
          Left = 111
          Top = 116
          Width = 280
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 10
        end
      end
    end
    object RztabDfsConfig: TRzTabSheet
      Caption = 'DFS Configuration'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object RzgrpDfsFtpConfig: TRzGroupBox
        Left = 17
        Top = 16
        Width = 610
        Height = 117
        BorderColor = 16768443
        Caption = 'DFS FTP Configuration Setting'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768443
        FlatColor = clBlack
        GradientColorStop = 16763080
        GroupStyle = gsStandard
        TabOrder = 0
        object pnlDfsServerIP: TRzPanel
          Left = 6
          Top = 46
          Width = 91
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Server IP'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object pnlDfsUserName: TRzPanel
          Left = 6
          Top = 69
          Width = 91
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'User Name'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object pnlDfsPW: TRzPanel
          Left = 6
          Top = 92
          Width = 91
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Password'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object edDfsServerIP: TRzEdit
          Left = 101
          Top = 46
          Width = 154
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 0
        end
        object edDfsUserName: TRzEdit
          Left = 101
          Top = 70
          Width = 154
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 1
        end
        object edDfsPW: TRzEdit
          Left = 101
          Top = 93
          Width = 154
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 2
        end
        object cbDfsFtpUse: TRzCheckBox
          Left = 8
          Top = 22
          Width = 193
          Height = 18
          Cursor = crHandPoint
          Caption = 'Use Defect File System'
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbUnchecked
          TabOrder = 6
          UseCustomGlyphs = True
        end
        object btnLoadDfsConfig: TBitBtn
          Left = 440
          Top = 14
          Width = 166
          Height = 26
          Caption = 'Load Config File'
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FDFDFD00F4F4F400E8E8E800E3E3E300E6E6
            E600E7E7E700DDDDDD00C6C6C600A9A9A9009D9D9D00BCBCBC00FF00FF00FF00
            FF00FF00FF00FEFEFE00F7F7F700E3E3E300C7C7C700A9A9A900A1A1A100A8A8
            A800A9A9A9008289930058667B00868D96008B8987009D9D9D00FF00FF00FF00
            FF00FBFBFB00ECECEC00CFCFCF00A3A3A200A0A0A100A6A6A600909191008181
            80009E9C9B0061718D002960A300548AC700C5C7C900B4B4B400FF00FF00FAFA
            FA00E3E3E300BFB3B0009B918E00C0C4C500DDC6B800F8C6A400F3CDB600CCC7
            C400B5B4B300D1D0CF005E99D500417BBC00ADADB000E2E2E200FDFDFD00E6E6
            E600D4A59500D6856A00BBBBBC00D5CAC600F7C79B00FFDBA600FFCC9800FCCC
            AD00BFBDBB00CCC9C7006A7C95008893A400E7E7E700FBFBFB00F4F4F400E0AE
            9B00FC9D7700D88D7200C7CCCE00D6C9C400F8D9AD00FFF2C400FFE3B200FFC7
            9400E2C5B700979899008E8F9100D6D6D600FAFAFA00FF00FF00EAD2C800FBA9
            8400FDB58E00DC937500D5D6D600DDDEDF00DECAB000FFF2C300FFE8B700FFC7
            9300E9CDBD00A2786E0088888800CACACA00F6F6F600FF00FF00F1B79D00FDBA
            9400FFCFA800EDA27C00D4B3A800F7FFFF00D4D2D100E0C2A600F8C79900F6C1
            9F00CECCCA00C8624700936F6600B6B6B600EEEEEE00FF00FF00FAB59100FFCC
            A500F9BD9700E8825C00D1593900DEC0B900EFF6F900D8DADD00CFCBC900C2BA
            B900C18C7C00D6533000A1645300ACACAC00E9E9E900FF00FF00FCC19C00F7B5
            8F00E3775300DC633F00E16C4700DF876400D6AA9500CCB4A800C7948300D06C
            4E00D9563100D8532F00B75D4600B2B2B200EBEBEB00FF00FF00FDC19D00E680
            5B00E3795500EE987300EC967000EEA88400FAD7B000F7CCA700F7B58E00E066
            4100DB5C3900D9573400AE665400C2C2C200F3F3F300FF00FF00F7C1A300E172
            4E00E57F5A00EA906B00F2A68000E8896500F4C39F00FFEEC800FBCAA300DE67
            4300DB5F3C00D8573300AD827700D9D9D900FBFBFB00FF00FF00F2C5B400DD65
            4100E47B5700E2745000E8876300EE9A7500EDA47F00EFA57F00F1A68100E680
            5B00DB5E3A00CD573700C4B9B700EFEFEF00FEFEFE00FF00FF00FAF0ED00E07F
            6400E06D4900E3785300E2765200E3775300E6835F00E06E4900DF6B4700FBC1
            9B00EC967300C89E9300E9E9E900FCFCFC00FF00FF00FF00FF00FF00FF00FBF0
            ED00E2886D00DC613D00DE694500DD654100E0704C00E0704C00E8876200F8C7
            A400DFCCBF00EDEDED00FCFCFC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FEFCFC00F1C4B600E28B7200DC674600E17B5700DB6D4D00E4AA9600EEE5
            DF00F7F7F700FEFEFE00FF00FF00FF00FF00FF00FF00FF00FF00}
          TabOrder = 7
          Visible = False
        end
        object cbUseCombiDown: TRzCheckBox
          Left = 267
          Top = 22
          Width = 147
          Height = 18
          Cursor = crHandPoint
          Caption = 'Use Combi Down'
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbUnchecked
          TabOrder = 8
          UseCustomGlyphs = True
        end
        object RzpnlCombiPath: TRzPanel
          Left = 266
          Top = 46
          Width = 158
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Combi Path (Server)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
        object edCombiDownPath: TRzEdit
          Left = 426
          Top = 46
          Width = 173
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 10
        end
        object cbDfsHexCompress: TRzCheckBox
          Left = 266
          Top = 74
          Width = 254
          Height = 18
          Cursor = crHandPoint
          Caption = 'Compress HEX before FTP Send'
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbUnchecked
          TabOrder = 11
          UseCustomGlyphs = True
        end
        object cbDfsHexDelete: TRzCheckBox
          Left = 267
          Top = 95
          Width = 242
          Height = 18
          Cursor = crHandPoint
          Caption = 'Delete HEX file after FTP Send'
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbUnchecked
          TabOrder = 12
          UseCustomGlyphs = True
        end
      end
      object btnDfsFtpConnect: TRzBitBtn
        Left = 648
        Top = 16
        Width = 176
        Height = 35
        Caption = 'DFS FTP Connect'
        HotTrack = True
        TabOrder = 1
        OnClick = btnDfsFtpConnectClick
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000E30E0000E30E00000001000000000000000000003300
          00006600000099000000CC000000FF0000000033000033330000663300009933
          0000CC330000FF33000000660000336600006666000099660000CC660000FF66
          000000990000339900006699000099990000CC990000FF99000000CC000033CC
          000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
          0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
          330000333300333333006633330099333300CC333300FF333300006633003366
          33006666330099663300CC663300FF6633000099330033993300669933009999
          3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
          330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
          66006600660099006600CC006600FF0066000033660033336600663366009933
          6600CC336600FF33660000666600336666006666660099666600CC666600FF66
          660000996600339966006699660099996600CC996600FF99660000CC660033CC
          660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
          6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
          990000339900333399006633990099339900CC339900FF339900006699003366
          99006666990099669900CC669900FF6699000099990033999900669999009999
          9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
          990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
          CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
          CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
          CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
          CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
          CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
          FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
          FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
          FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
          FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
          000000808000800000008000800080800000C0C0C00080808000191919004C4C
          4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
          6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8121212
          12121212121212E8E8E8E8E8E881818181818181818181E8E8E8E8E812181818
          1818121812121212E8E8E8E881E2E2E2E2E281E281818181E8E8E8E8121E1818
          1818181218121212E8E8E8E881ACE2E2E2E2E281E2818181E8E8E8E812181E18
          1818181812181212E8E8E8E881E2ACE2E2E2E2E281E28181E8E8E8E8121E181E
          1818181818121812E8E8E8E881ACE2ACE2E2E2E2E281E281E8E8E8E8121E1E18
          1E18181818181212E8E8E8E881ACACE2ACE2E2E2E2E28181E8E8E8E8128D1E1E
          181E181818181812E8E8E8E881E3ACACE2ACE2E2E2E2E281E8E8E8E8128D8D1E
          1E181E1818181812E8E8E8E881E3E3ACACE2ACE2E2E2E281E8E8E8E8E8121212
          12121212121212E8E8E8E8E8E881818181818181818181E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
        NumGlyphs = 2
      end
      object btnDfsFtpDisconnect: TRzBitBtn
        Left = 648
        Top = 57
        Width = 176
        Height = 35
        Caption = 'DFS FTP Disconnect'
        HotTrack = True
        TabOrder = 2
        OnClick = btnDfsFtpDisconnectClick
        Glyph.Data = {
          36060000424D3606000000000000360400002800000020000000100000000100
          08000000000000020000E30E0000E30E00000001000000000000000000003300
          00006600000099000000CC000000FF0000000033000033330000663300009933
          0000CC330000FF33000000660000336600006666000099660000CC660000FF66
          000000990000339900006699000099990000CC990000FF99000000CC000033CC
          000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
          0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
          330000333300333333006633330099333300CC333300FF333300006633003366
          33006666330099663300CC663300FF6633000099330033993300669933009999
          3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
          330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
          66006600660099006600CC006600FF0066000033660033336600663366009933
          6600CC336600FF33660000666600336666006666660099666600CC666600FF66
          660000996600339966006699660099996600CC996600FF99660000CC660033CC
          660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
          6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
          990000339900333399006633990099339900CC339900FF339900006699003366
          99006666990099669900CC669900FF6699000099990033999900669999009999
          9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
          990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
          CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
          CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
          CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
          CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
          CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
          FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
          FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
          FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
          FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
          000000808000800000008000800080800000C0C0C00080808000191919004C4C
          4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
          6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E86C6C6C
          6C6C6C6C6C6C6CE8E8E8E8E8E881818181818181818181E8E8E8E8E86C909090
          90906C906C6C6C6CE8E8E8E881E2E2E2E2E281E281818181E8E8E8E86CB49090
          9090906C906C6C6CE8E8E8E881ACE2E2E2E2E281E2818181E8E8E8E86C90B490
          909090906C906C6CE8E8E8E881E2ACE2E2E2E2E281E28181E8E8E8E86CB490B4
          90909090906C906CE8E8E8E881ACE2ACE2E2E2E2E281E281E8E8E8E86CB4B490
          B490909090906C6CE8E8E8E881ACACE2ACE2E2E2E2E28181E8E8E8E86CC9B4B4
          90B490909090906CE8E8E8E881E3ACACE2ACE2E2E2E2E281E8E8E8E86CC9C9B4
          B490B4909090906CE8E8E8E881E3E3ACACE2ACE2E2E2E281E8E8E8E8E86C6C6C
          6C6C6C6C6C6C6CE8E8E8E8E8E881818181818181818181E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
          E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
        NumGlyphs = 2
      end
      object pnlDfsFtpStatus: TPanel
        Left = 648
        Top = 96
        Width = 176
        Height = 35
        Caption = 'Disconnected'
        Color = clBackground
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
        StyleElements = []
      end
      object RzgrpDfsFtpFileUpload: TRzGroupBox
        Left = 13
        Top = 143
        Width = 830
        Height = 315
        BorderColor = clPurple
        Caption = 'DFS FTP File Upload'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        FlatColor = clRed
        GradientColorStop = 16763080
        GroupStyle = gsStandard
        TabOrder = 4
        Visible = False
        object RzgrpDfsFtpHost: TRzGroupBox
          Left = 6
          Top = 18
          Width = 385
          Height = 295
          Caption = 'Host Server (DFS FTP Server)'
          CaptionFont.Charset = DEFAULT_CHARSET
          CaptionFont.Color = clWindowText
          CaptionFont.Height = -11
          CaptionFont.Name = 'Tahoma'
          CaptionFont.Style = [fsBold]
          Color = 16768443
          GradientColorStop = 16763080
          GroupStyle = gsBanner
          TabOrder = 0
          object RzpnlDfsFtpHostCtrl: TRzPanel
            Left = 0
            Top = 24
            Width = 385
            Height = 65
            Align = alTop
            BorderOuter = fsFlatRounded
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            object tlbDfsFtpHostBtns: TToolBar
              Left = 2
              Top = 2
              Width = 209
              Height = 61
              Align = alLeft
              ButtonHeight = 25
              ButtonWidth = 25
              TabOrder = 0
              object btnDfsFtpHostDirUp: TToolButton
                Left = 0
                Top = 0
                Hint = 'Move up a folder'
                Caption = 'btnDfsFtpHostDirUp'
                ImageIndex = 8
                ParentShowHint = False
                ShowHint = True
                OnClick = btnDfsFtpHostDirUpClick
              end
              object btnDfsFtpHostDirBack: TToolButton
                Left = 25
                Top = 0
                Hint = 'Go back'
                Caption = 'btnDfsFtpHostDirBack'
                ImageIndex = 9
                ParentShowHint = False
                ShowHint = True
                OnClick = btnDfsFtpHostDirBackClick
              end
              object btnDfsFtpHostDirHome: TToolButton
                Left = 50
                Top = 0
                Hint = 'Return to this sites home folder'
                Caption = 'btnDfsFtpHostDirHome'
                ImageIndex = 10
                ParentShowHint = False
                ShowHint = True
                OnClick = btnDfsFtpHostDirHomeClick
              end
              object btnDfsFtpHostNull1: TToolButton
                Left = 75
                Top = 0
                Width = 14
                ImageIndex = 13
                Style = tbsSeparator
              end
              object btnDfsFtpHostFileDownload: TToolButton
                Left = 89
                Top = 0
                Hint = 'Download remote file to your local hard disk'
                Caption = 'btnDfsFtpHostFileDownload'
                ImageIndex = 7
                ParentShowHint = False
                ShowHint = True
                Visible = False
              end
              object btnDfsFtpHostNull2: TToolButton
                Left = 114
                Top = 0
                Width = 14
                ImageIndex = 6
                Style = tbsSeparator
              end
              object btnDfsFtpHostDirCreate: TToolButton
                Left = 128
                Top = 0
                Hint = 'Create a new folder on the remote system'
                Caption = 'btnDfsFtpHostDirCreate'
                ImageIndex = 11
                ParentShowHint = False
                ShowHint = True
                Visible = False
              end
              object btnDfsFtpHostFileDelete: TToolButton
                Left = 153
                Top = 0
                Hint = 'Delete file'
                Caption = 'btnDfsFtpHostFileDelete'
                ImageIndex = 5
                ParentShowHint = False
                ShowHint = True
                Visible = False
              end
            end
            object edDfsFtpHostDirNow: TEdit
              Left = 2
              Top = 30
              Width = 320
              Height = 24
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Verdana'
              Font.Style = []
              ImeName = 'Microsoft IME 2010'
              ParentFont = False
              TabOrder = 1
            end
            object btnDfsFtpHostDirGo: TBitBtn
              Left = 325
              Top = 27
              Width = 55
              Height = 30
              Caption = 'Go'
              Glyph.Data = {
                36040000424D3604000000000000360000002800000010000000100000000100
                2000000000000004000000000000000000000000000000000000FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FDFDFD00F4F4F400E8E8E800E3E3E300E6E6
                E600E7E7E700DDDDDD00C6C6C600A9A9A9009D9D9D00BCBCBC00FF00FF00FF00
                FF00FF00FF00FEFEFE00F7F7F700E3E3E300C7C7C700A9A9A900A1A1A100A8A8
                A800A9A9A9008289930058667B00868D96008B8987009D9D9D00FF00FF00FF00
                FF00FBFBFB00ECECEC00CFCFCF00A3A3A200A0A0A100A6A6A600909191008181
                80009E9C9B0061718D002960A300548AC700C5C7C900B4B4B400FF00FF00FAFA
                FA00E3E3E300BFB3B0009B918E00C0C4C500DDC6B800F8C6A400F3CDB600CCC7
                C400B5B4B300D1D0CF005E99D500417BBC00ADADB000E2E2E200FDFDFD00E6E6
                E600D4A59500D6856A00BBBBBC00D5CAC600F7C79B00FFDBA600FFCC9800FCCC
                AD00BFBDBB00CCC9C7006A7C95008893A400E7E7E700FBFBFB00F4F4F400E0AE
                9B00FC9D7700D88D7200C7CCCE00D6C9C400F8D9AD00FFF2C400FFE3B200FFC7
                9400E2C5B700979899008E8F9100D6D6D600FAFAFA00FF00FF00EAD2C800FBA9
                8400FDB58E00DC937500D5D6D600DDDEDF00DECAB000FFF2C300FFE8B700FFC7
                9300E9CDBD00A2786E0088888800CACACA00F6F6F600FF00FF00F1B79D00FDBA
                9400FFCFA800EDA27C00D4B3A800F7FFFF00D4D2D100E0C2A600F8C79900F6C1
                9F00CECCCA00C8624700936F6600B6B6B600EEEEEE00FF00FF00FAB59100FFCC
                A500F9BD9700E8825C00D1593900DEC0B900EFF6F900D8DADD00CFCBC900C2BA
                B900C18C7C00D6533000A1645300ACACAC00E9E9E900FF00FF00FCC19C00F7B5
                8F00E3775300DC633F00E16C4700DF876400D6AA9500CCB4A800C7948300D06C
                4E00D9563100D8532F00B75D4600B2B2B200EBEBEB00FF00FF00FDC19D00E680
                5B00E3795500EE987300EC967000EEA88400FAD7B000F7CCA700F7B58E00E066
                4100DB5C3900D9573400AE665400C2C2C200F3F3F300FF00FF00F7C1A300E172
                4E00E57F5A00EA906B00F2A68000E8896500F4C39F00FFEEC800FBCAA300DE67
                4300DB5F3C00D8573300AD827700D9D9D900FBFBFB00FF00FF00F2C5B400DD65
                4100E47B5700E2745000E8876300EE9A7500EDA47F00EFA57F00F1A68100E680
                5B00DB5E3A00CD573700C4B9B700EFEFEF00FEFEFE00FF00FF00FAF0ED00E07F
                6400E06D4900E3785300E2765200E3775300E6835F00E06E4900DF6B4700FBC1
                9B00EC967300C89E9300E9E9E900FCFCFC00FF00FF00FF00FF00FF00FF00FBF0
                ED00E2886D00DC613D00DE694500DD654100E0704C00E0704C00E8876200F8C7
                A400DFCCBF00EDEDED00FCFCFC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FEFCFC00F1C4B600E28B7200DC674600E17B5700DB6D4D00E4AA9600EEE5
                DF00F7F7F700FEFEFE00FF00FF00FF00FF00FF00FF00FF00FF00}
              TabOrder = 2
              OnClick = btnDfsFtpHostDirGoClick
            end
          end
          object lstDfsFtpHostFiles: TListBox
            Left = 0
            Top = 86
            Width = 385
            Height = 209
            Align = alBottom
            TabOrder = 1
            OnDblClick = lstDfsFtpHostFilesDblClick
          end
        end
        object RzgrepDfsFtpLocal: TRzGroupBox
          Left = 426
          Top = 18
          Width = 385
          Height = 295
          Caption = 'Local PC (GPC)'
          CaptionFont.Charset = DEFAULT_CHARSET
          CaptionFont.Color = clWindowText
          CaptionFont.Height = -11
          CaptionFont.Name = 'Tahoma'
          CaptionFont.Style = [fsBold]
          Color = 16768443
          GradientColorStop = 16763080
          GroupStyle = gsBanner
          TabOrder = 1
          object RzpnlDfsFtpLocalCtrl: TRzPanel
            Left = 0
            Top = 24
            Width = 385
            Height = 65
            Align = alTop
            BorderOuter = fsFlatRounded
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            object tlbDfsFtpLocalBtns: TToolBar
              Left = 0
              Top = 2
              Width = 209
              Height = 31
              Align = alNone
              ButtonHeight = 25
              ButtonWidth = 25
              Caption = 'Local PC Buttons'
              TabOrder = 0
              object btnDfsFtpLocalDirUp: TToolButton
                Left = 0
                Top = 0
                Hint = 'Move up a folder'
                Caption = 'btnDfsFtpLocalDirUp'
                ImageIndex = 8
                ParentShowHint = False
                ShowHint = True
                OnClick = btnDfsFtpLocalDirUpClick
              end
              object btnDfsFtpLocalDirBack: TToolButton
                Left = 25
                Top = 0
                Hint = 'Go back'
                Caption = 'btnDfsFtpLocalDirBack'
                ImageIndex = 9
                ParentShowHint = False
                ShowHint = True
                OnClick = btnDfsFtpLocalDirBackClick
              end
              object btnDfsFtpLocalDirHome: TToolButton
                Left = 50
                Top = 0
                Hint = 'Return to this sites home folder'
                Caption = 'btnDfsFtpLocalDirHome'
                ImageIndex = 10
                ParentShowHint = False
                ShowHint = True
                OnClick = btnDfsFtpLocalDirHomeClick
              end
              object btnDfsFtpLocalNull1: TToolButton
                Left = 75
                Top = 0
                Width = 14
                ImageIndex = 13
                Style = tbsSeparator
              end
              object btnDfsFtpLocalFileUpload: TToolButton
                Left = 89
                Top = 0
                Hint = 'Upload file from your local hard disk to the remote system'
                Caption = 'btnDfsFtpLocalFileUpload'
                ImageIndex = 12
                ParentShowHint = False
                ShowHint = True
                Visible = False
              end
              object btnDfsFtpLocalNull2: TToolButton
                Left = 114
                Top = 0
                Width = 14
                ImageIndex = 6
                Style = tbsSeparator
              end
              object btnDfsFtpLocalDirCreate: TToolButton
                Left = 128
                Top = 0
                Hint = 'Create a new folder on the remote system'
                Caption = 'btnDfsFtpLocalDirCreate'
                ImageIndex = 11
                ParentShowHint = False
                ShowHint = True
                Visible = False
              end
              object btnDfsFtpLocalFileDelete: TToolButton
                Left = 153
                Top = 0
                Hint = 'Delete file'
                Caption = 'btnDfsFtpLocalFileDelete'
                ImageIndex = 5
                ParentShowHint = False
                ShowHint = True
                Visible = False
              end
            end
            object edDfsFtpLocalDirNow: TEdit
              Left = 0
              Top = 30
              Width = 320
              Height = 24
              Font.Charset = ANSI_CHARSET
              Font.Color = clBlack
              Font.Height = -13
              Font.Name = 'Verdana'
              Font.Style = []
              ImeName = 'Microsoft IME 2010'
              ParentFont = False
              TabOrder = 1
            end
            object btnDfsFtpLocalDirGo: TBitBtn
              Left = 324
              Top = 26
              Width = 55
              Height = 30
              Caption = 'Go'
              Glyph.Data = {
                36040000424D3604000000000000360000002800000010000000100000000100
                2000000000000004000000000000000000000000000000000000FF00FF00FF00
                FF00FF00FF00FF00FF00FF00FF00FDFDFD00F4F4F400E8E8E800E3E3E300E6E6
                E600E7E7E700DDDDDD00C6C6C600A9A9A9009D9D9D00BCBCBC00FF00FF00FF00
                FF00FF00FF00FEFEFE00F7F7F700E3E3E300C7C7C700A9A9A900A1A1A100A8A8
                A800A9A9A9008289930058667B00868D96008B8987009D9D9D00FF00FF00FF00
                FF00FBFBFB00ECECEC00CFCFCF00A3A3A200A0A0A100A6A6A600909191008181
                80009E9C9B0061718D002960A300548AC700C5C7C900B4B4B400FF00FF00FAFA
                FA00E3E3E300BFB3B0009B918E00C0C4C500DDC6B800F8C6A400F3CDB600CCC7
                C400B5B4B300D1D0CF005E99D500417BBC00ADADB000E2E2E200FDFDFD00E6E6
                E600D4A59500D6856A00BBBBBC00D5CAC600F7C79B00FFDBA600FFCC9800FCCC
                AD00BFBDBB00CCC9C7006A7C95008893A400E7E7E700FBFBFB00F4F4F400E0AE
                9B00FC9D7700D88D7200C7CCCE00D6C9C400F8D9AD00FFF2C400FFE3B200FFC7
                9400E2C5B700979899008E8F9100D6D6D600FAFAFA00FF00FF00EAD2C800FBA9
                8400FDB58E00DC937500D5D6D600DDDEDF00DECAB000FFF2C300FFE8B700FFC7
                9300E9CDBD00A2786E0088888800CACACA00F6F6F600FF00FF00F1B79D00FDBA
                9400FFCFA800EDA27C00D4B3A800F7FFFF00D4D2D100E0C2A600F8C79900F6C1
                9F00CECCCA00C8624700936F6600B6B6B600EEEEEE00FF00FF00FAB59100FFCC
                A500F9BD9700E8825C00D1593900DEC0B900EFF6F900D8DADD00CFCBC900C2BA
                B900C18C7C00D6533000A1645300ACACAC00E9E9E900FF00FF00FCC19C00F7B5
                8F00E3775300DC633F00E16C4700DF876400D6AA9500CCB4A800C7948300D06C
                4E00D9563100D8532F00B75D4600B2B2B200EBEBEB00FF00FF00FDC19D00E680
                5B00E3795500EE987300EC967000EEA88400FAD7B000F7CCA700F7B58E00E066
                4100DB5C3900D9573400AE665400C2C2C200F3F3F300FF00FF00F7C1A300E172
                4E00E57F5A00EA906B00F2A68000E8896500F4C39F00FFEEC800FBCAA300DE67
                4300DB5F3C00D8573300AD827700D9D9D900FBFBFB00FF00FF00F2C5B400DD65
                4100E47B5700E2745000E8876300EE9A7500EDA47F00EFA57F00F1A68100E680
                5B00DB5E3A00CD573700C4B9B700EFEFEF00FEFEFE00FF00FF00FAF0ED00E07F
                6400E06D4900E3785300E2765200E3775300E6835F00E06E4900DF6B4700FBC1
                9B00EC967300C89E9300E9E9E900FCFCFC00FF00FF00FF00FF00FF00FF00FBF0
                ED00E2886D00DC613D00DE694500DD654100E0704C00E0704C00E8876200F8C7
                A400DFCCBF00EDEDED00FCFCFC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
                FF00FEFCFC00F1C4B600E28B7200DC674600E17B5700DB6D4D00E4AA9600EEE5
                DF00F7F7F700FEFEFE00FF00FF00FF00FF00FF00FF00FF00FF00}
              TabOrder = 2
              OnClick = btnDfsFtpLocalDirGoClick
            end
          end
          object lstDfsFtpLocalFiles: TListBox
            Left = 0
            Top = 86
            Width = 385
            Height = 209
            Align = alBottom
            TabOrder = 1
            OnDblClick = lstDfsFtpLocalFilesDblClick
          end
        end
        object btnDfsFtpHost2LocalDownload: TRzBitBtn
          Left = 394
          Top = 129
          Width = 30
          Height = 70
          Caption = 'btnDfsFtpHost2LocalDownload'
          HotTrack = True
          TabOrder = 2
          OnClick = btnDfsFtpHost2LocalDownloadClick
          Glyph.Data = {
            36060000424D3606000000000000360400002800000020000000100000000100
            08000000000000020000520B0000520B00000001000000000000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E809090909E8E8
            E809090909E8E8E8E8E881818181E8E8E881818181E8E8E8E8E80910101009E8
            E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E8E80910101009
            E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E8E809101010
            09E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E8E8091010
            1009E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E8E80910
            101009E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E80910
            101009E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8091010
            1009E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E809101010
            09E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E80910101009
            E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E80910101009E8
            E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E809090909E8E8
            E809090909E8E8E8E8E881818181E8E8E881818181E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
          NumGlyphs = 2
        end
        object btnDfsFtpLocal2HostUpload: TRzBitBtn
          Left = 394
          Top = 220
          Width = 30
          Height = 70
          Caption = 'btnDfsFtpLocal2HostUpload'
          HotTrack = True
          TabOrder = 3
          OnClick = btnDfsFtpLocal2HostUploadClick
          Glyph.Data = {
            36060000424D3606000000000000360400002800000020000000100000000100
            08000000000000020000620B0000620B00000001000000000000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E809
            090909E8E8E809090909E8E8E8E8E881818181E8E8E881818181E8E8E8E80910
            101009E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8091010
            1009E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E809101010
            09E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E80910101009
            E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E80910101009E8
            E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E80910101009E8
            E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E8E80910101009
            E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E8E809101010
            09E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E8E8091010
            1009E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E8E80910
            101009E8E80910101009E8E8E8E881ACACAC81E8E881ACACAC81E8E8E8E8E809
            090909E8E8E809090909E8E8E8E8E881818181E8E8E881818181E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
          NumGlyphs = 2
        end
      end
    end
    object RztabRobotCOnfig: TRzTabSheet
      Caption = 'Robot Configuration'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object RzgrpRobotComm: TRzGroupBox
        Left = 12
        Top = 9
        Width = 370
        Height = 136
        Caption = 'ROBOT Communication - IP/PORT'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768700
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 0
        object RzpnlRobot1IPAddr: TRzPanel
          Left = 8
          Top = 25
          Width = 150
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'ROBOT-1 IP Address'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object RzpnlRobot2IPAddr: TRzPanel
          Left = 8
          Top = 50
          Width = 150
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'ROBOT-2 IP Address'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object RzpnlRobotModbusTcpPort: TRzPanel
          Left = 8
          Top = 75
          Width = 150
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'ModBus TCP Port'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object edRobot1IPAddr: TRzEdit
          Left = 160
          Top = 25
          Width = 200
          Height = 22
          Text = '192.168.3.7'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 0
        end
        object edRobot2IPAddr: TRzEdit
          Left = 160
          Top = 50
          Width = 200
          Height = 22
          Text = '192.168.3.8'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 1
        end
        object edRobotModbusTcpPort: TRzEdit
          Left = 160
          Top = 75
          Width = 200
          Height = 22
          Text = '502'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 2
        end
        object RzpnlRobotCmdTcpPort: TRzPanel
          Left = 8
          Top = 100
          Width = 150
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Command TCP Port'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object edRobotCommandTcpPort: TRzEdit
          Left = 160
          Top = 100
          Width = 200
          Height = 22
          Text = '5890'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 7
        end
      end
      object RzgrpRobotTcpCommands: TRzGroupBox
        Left = 12
        Top = 152
        Width = 370
        Height = 130
        Caption = 'ROBOT Control - TCP Commands'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768700
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 1
        object RzpnlRobotCmdReady: TRzPanel
          Left = 8
          Top = 25
          Width = 150
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Ready Check'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object RzpnlRobotMoveHome: TRzPanel
          Left = 8
          Top = 50
          Width = 150
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Move to HOME Coord'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object RzpnlRobotCmdMoveRelative: TRzPanel
          Left = 8
          Top = 75
          Width = 150
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Move to Relative Coord'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object edRobotCmdReadyCheck: TRzEdit
          Left = 160
          Top = 25
          Width = 200
          Height = 22
          Text = 'READY'
          CharCase = ecUpperCase
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 0
        end
        object RzpnlRobotCmdMoveToHome: TRzEdit
          Left = 160
          Top = 50
          Width = 200
          Height = 22
          Text = 'MUTING'
          CharCase = ecUpperCase
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 1
        end
        object edRobotCmdMoveRelative: TRzEdit
          Left = 160
          Top = 75
          Width = 200
          Height = 22
          Text = 'MOVE'
          CharCase = ecUpperCase
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 2
        end
        object RzpnlRobotCmdMoveToStandby: TRzPanel
          Left = 8
          Top = 100
          Width = 150
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'Move to STANDBY Coord'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object edRobotCmdMoveToStdLight: TRzEdit
          Left = 160
          Top = 100
          Width = 200
          Height = 22
          Text = 'STANDBY'
          CharCase = ecUpperCase
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 7
        end
      end
    end
    object RztabLensMesConfig: TRzTabSheet
      Caption = 'LENS MES Configuration'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object RzgrpLensMesConfig: TRzGroupBox
        Left = 20
        Top = 17
        Width = 621
        Height = 408
        Caption = 'LENS MES'
        CaptionFont.Charset = DEFAULT_CHARSET
        CaptionFont.Color = clWindowText
        CaptionFont.Height = -11
        CaptionFont.Name = 'Tahoma'
        CaptionFont.Style = [fsBold]
        Color = 16768700
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        TabOrder = 0
        object RzpnlLensMesTimeoutSec: TRzLabel
          Left = 150
          Top = 292
          Width = 19
          Height = 14
          Caption = 'sec'
          Font.Charset = ANSI_CHARSET
          Font.Color = 7879740
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = True
          BlinkIntervalOff = 1000
          BlinkIntervalOn = 1000
        end
        object RzpnlLenMesSite: TRzPanel
          Left = 6
          Top = 24
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'SITE'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object RzpnlLensMesUrlIF: TRzPanel
          Left = 6
          Top = 51
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'I/F URL'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 6
        end
        object RzpnlLensMesUrlToken: TRzPanel
          Left = 6
          Top = 73
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'TOKEN URL'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object edLenMesSite: TRzEdit
          Left = 97
          Top = 24
          Width = 500
          Height = 22
          Text = 'V190'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 0
        end
        object edLensMesUrlIF: TRzEdit
          Left = 97
          Top = 51
          Width = 500
          Height = 22
          Text = 'http://10.13.6.153/'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 1
        end
        object edLensMesUrlLogin: TRzEdit
          Left = 97
          Top = 73
          Width = 500
          Height = 22
          Text = 'prod-api/auth/login'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 2
        end
        object RzpnlLensMesUrlStart: TRzPanel
          Left = 6
          Top = 95
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'START URL'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 8
        end
        object RzpnlLensMesUrlEnd: TRzPanel
          Left = 6
          Top = 117
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'END URL'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
        end
        object edLensMesUrlStart: TRzEdit
          Left = 97
          Top = 95
          Width = 500
          Height = 22
          Text = 'prod-api/v190/productSerialNumber/start'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 3
        end
        object edLensMesUrlEnd: TRzEdit
          Left = 97
          Top = 117
          Width = 500
          Height = 22
          Text = 'prod-api/v190/deviceApi/pass/complexPassStation'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 4
        end
        object RzpnlLensMesWaitSec: TRzPanel
          Left = 6
          Top = 287
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'TIME OUT'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
        end
        object edLensMesWaitSec: TRzEdit
          Left = 97
          Top = 287
          Width = 50
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 11
        end
        object btnLensMesLoadConfig: TRzBitBtn
          Left = 307
          Top = 368
          Width = 183
          Caption = 'Load MES Config file'
          HotTrack = True
          TabOrder = 12
          Visible = False
          Glyph.Data = {
            36060000424D3606000000000000360400002800000020000000100000000100
            08000000000000020000D30B0000D30B00000001000000000000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8818181
            81818181818181E8E8E8E8E8E881818181818181818181E8E8E8E8E881E2E2E2
            E2E281E281818181E8E8E8E881E2E2E2E2E281E281818181E8E8E8E881ACE2E2
            E2E2E281E2818181E8E8E8E881ACE2E2E2E2E281E2818181E8E8E8E881E2ACE2
            E2E2E2E281E28181E8E8E8E881E2ACE2E2E2E2E281E28181E8E8E8E881ACE2AC
            E2E2E2E2E281E281E8E8E8E881ACE2ACE2E2E2E2E281E281E8E8E8E881ACACE2
            ACE2E2E2E2E28181E8E8E8E881ACACE2ACE2E2E2E2E28181E8E8E8E881E3ACAC
            E2ACE2E2E2E2E281E8E8E8E881E3ACACE2ACE2E2E2E2E281E8E8E8E881E3E3AC
            ACE2ACE2E2E2E281E8E8E8E881E3E3ACACE2ACE2E2E2E281E8E8E8E8E8818181
            81818181818181E8E8E8E8E8E881818181818181818181E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
            E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
          NumGlyphs = 2
        end
        object cbLensMesGIB: TRzCheckBox
          Left = 15
          Top = 344
          Width = 83
          Height = 18
          Caption = 'Use GIB'
          Color = 16768700
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentColor = False
          ParentFont = False
          State = cbUnchecked
          TabOrder = 13
          UseCustomGlyphs = True
        end
        object cbLensMesConfirmHost: TRzCheckBox
          Left = 15
          Top = 368
          Width = 183
          Height = 18
          Caption = 'Confirm Sending Host'
          CustomGlyphs.Data = {
            C20E0000424DC20E0000000000003604000028000000B40000000F0000000100
            0800000000008C0A0000230B0000230B00000001000000010000000000003300
            00006600000099000000CC000000FF0000000033000033330000663300009933
            0000CC330000FF33000000660000336600006666000099660000CC660000FF66
            000000990000339900006699000099990000CC990000FF99000000CC000033CC
            000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
            0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
            330000333300333333006633330099333300CC333300FF333300006633003366
            33006666330099663300CC663300FF6633000099330033993300669933009999
            3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
            330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
            66006600660099006600CC006600FF0066000033660033336600663366009933
            6600CC336600FF33660000666600336666006666660099666600CC666600FF66
            660000996600339966006699660099996600CC996600FF99660000CC660033CC
            660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
            6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
            990000339900333399006633990099339900CC339900FF339900006699003366
            99006666990099669900CC669900FF6699000099990033999900669999009999
            9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
            990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
            CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
            CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
            CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
            CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
            CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
            FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
            FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
            FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
            FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF00000080000080
            000000808000800000008000800080800000C0C0C00080808000191919004C4C
            4C00B2B2B200E5E5E500C8AC2800E0CC6600F2EABF00B59B2400D8E9EC009933
            6600D075A300ECC6D900646F710099A8AC00E2EFF10000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000DADA08080808
            08080808080808DADADADADADADADADA0808080808080808080808DADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            080808DADADADADADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADAECECECECECECECECECECECDA
            DADADADADADADADAECECECECECECECECECECECDADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E1E1E1E09091E
            1E1E08DADADADADADADADADA081E090909090909091E08DADADADADADADADADA
            08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E8E8E80909E8E8E808DA
            DADADADADADADADA08E809090909090909E808DADADADADADADADADAECACACAC
            ACACACACACACECDADADADADADADADADAECACACACAC8181ACACACECDADADADADA
            DADADADAECAC81818181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA081E1E1E091010091E1E08DADADADADADADADADA
            081E091010101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADA08E8E8E809101009E8E808DADADADADADADADADA08E80910
            1010101009E808DADADADADADADADADAECACACACACACACACACACECDADADADADA
            DADADADAECACACAC81ACAC81ACACECDADADADADADADADADAECAC81ACACACACAC
            81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA
            081E1E0910101010091E08DADADADADADADADADA081E091010101010091E08DA
            DADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8E809
            1010101009E808DADADADADADADADADA08E809101010101009E808DADADADADA
            DADADADAECACACACACACACACACACECDADADADADADADADADAECACAC81ACACACAC
            81ACECDADADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA
            081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E091010101010100908DA
            DADADADADADADADA081E091010101010091E08DADADADADADADADADA08E8E8E8
            E8E8E8E8E8E808DADADADADADADADADA08E8091010101010100908DADADADADA
            DADADADA08E809101010101009E808DADADADADADADADADAECACACACACACACAC
            ACACECDADADADADADADADADAECAC81ACACACACACAC81ECDADADADADADADADADA
            ECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DA
            DADADADADADADADA081E091010090910101009DADADADADADADADADA081E0910
            10101010091E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADA
            DADADADA08E8091010090910101009DADADADADADADADADA08E8091010101010
            09E808DADADADADADADADADAECACACACACACACACACACECDADADADADADADADADA
            ECAC81ACAC8181ACACAC81DADADADADADADADADAECAC81ACACACACAC81ACECDA
            DADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADADADADADA081E0910
            091E1E0910101009DADADADADADADADA081E091010101010091E08DADADADADA
            DADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA08E8091009E8E809
            10101009DADADADADADADADA08E809101010101009E808DADADADADADADADADA
            ECACACACACACACACACACECDADADADADADADADADAECAC81AC81ACAC81ACACAC81
            DADADADADADADADAECAC81ACACACACAC81ACECDADADADADADADADADA081E1E1E
            1E1E1E1E1E1E08DADADADADADADADADA081E09091E1E1E1E0910101009DADADA
            DADADADA081E090909090909091E08DADADADADADADADADA08E8E8E8E8E8E8E8
            E8E808DADADADADADADADADA08E80909E8E8E8E80910101009DADADADADADADA
            08E809090909090909E808DADADADADADADADADAECACACACACACACACACACECDA
            DADADADADADADADAECAC8181ACACACAC81ACACAC81DADADADADADADAECAC8181
            8181818181ACECDADADADADADADADADA081E1E1E1E1E1E1E1E1E08DADADADADA
            DADADADA081E1E1E1E1E1E1E1E0910101009DADADADADADA081E1E1E1E1E1E1E
            1E1E08DADADADADADADADADA08E8E8E8E8E8E8E8E8E808DADADADADADADADADA
            08E8E8E8E8E8E8E8E80910101009DADADADADADA08E8E8E8E8E8E8E8E8E808DA
            DADADADADADADADAECACACACACACACACACACECDADADADADADADADADAECACACAC
            ACACACACAC81ACACAC81DADADADADADAECACACACACACACACACACECDADADADADA
            DADADADA0808080808080808080808DADADADADADADADADA0808080808080808
            08080910101009DADADADADA0808080808080808080808DADADADADADADADADA
            0808080808080808080808DADADADADADADADADA080808080808080808080910
            101009DADADADADA0808080808080808080808DADADADADADADADADAECECECEC
            ECECECECECECECDADADADADADADADADAECECECECECECECECECEC81ACACAC81DA
            DADADADAECECECECECECECECECECECDADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADA09101009DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADA09101009DADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADA81ACAC81DADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADA091009DADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADA091009DADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADA81AC81DADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DA0909DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADA0909DA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADA8181DADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADADA
            DADADADADADA}
          Font.Charset = ANSI_CHARSET
          Font.Color = clNavy
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          HotTrack = True
          ParentFont = False
          State = cbUnchecked
          TabOrder = 14
          UseCustomGlyphs = True
        end
        object RzpnlLensMesOperation: TRzPanel
          Left = 8
          Top = 194
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'OPERATION'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 15
        end
        object RzpnlLensMesMO: TRzPanel
          Left = 6
          Top = 216
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'MO'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 16
        end
        object RzpnlLensMesITEM: TRzPanel
          Left = 6
          Top = 238
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'ITEM'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 17
        end
        object RzpnlLensMesSHIFT: TRzPanel
          Left = 6
          Top = 260
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'SHIFT'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 18
        end
        object edLensMesSHIFT: TRzEdit
          Left = 97
          Top = 260
          Width = 400
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 19
        end
        object edLensMesITEM: TRzEdit
          Left = 97
          Top = 238
          Width = 400
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 20
        end
        object edLensMesMO: TRzEdit
          Left = 97
          Top = 216
          Width = 400
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 21
        end
        object edLensMesOperation: TRzEdit
          Left = 97
          Top = 194
          Width = 400
          Height = 22
          Text = ''
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 22
        end
        object RzpnlLensMesUrlEqStatus: TRzPanel
          Left = 6
          Top = 139
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'STATUS URL'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 23
        end
        object edLensMesUrlEqStatus: TRzEdit
          Left = 97
          Top = 139
          Width = 500
          Height = 22
          Text = 'prod-api/v190/deviceApi/machineStatus/upload'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 24
        end
        object RzpnlLensMesUrlReInput: TRzPanel
          Left = 6
          Top = 161
          Width = 90
          Height = 21
          BorderOuter = fsFlatRounded
          Caption = 'ReInput URL'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 25
        end
        object edLensMesUrlReInput: TRzEdit
          Left = 97
          Top = 161
          Width = 500
          Height = 22
          Text = 'prod-api/v190/deviceApi/snCheck/checkSnExitsAndOperationValid'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          FocusColor = 14283263
          FrameHotTrack = True
          FrameVisible = True
          ImeName = 'Microsoft IME 2010'
          ParentFont = False
          TabOrder = 26
        end
      end
    end
  end
  object btnClose: TRzBitBtn
    Left = 683
    Top = 625
    Width = 135
    Height = 35
    FrameColor = clBtnFace
    Caption = 'Close'
    Font.Charset = ANSI_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    HotTrack = True
    ParentFont = False
    TabOrder = 2
    TabStop = False
    OnClick = btnCloseClick
  end
  object btnSave: TRzBitBtn
    Left = 542
    Top = 625
    Width = 135
    Height = 35
    FrameColor = clBtnFace
    Caption = 'Save'
    Font.Charset = ANSI_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    HotTrack = True
    ParentFont = False
    TabOrder = 1
    TabStop = False
    OnClick = btnSaveClick
  end
  object dlgOpen: TRzSelectFolderDialog
    Left = 85
    Top = 549
  end
  object il1: TImageList
    Left = 44
    Top = 550
    Bitmap = {
      494C01010E001100040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      00000000000000000000000000000000000000000000078DBE00078DBE00078D
      BE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078D
      BE00078DBE00078DBE00000000000000000000000000078DBE00078DBE00078D
      BE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078D
      BE00078DBE00078DBE0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8898900B8898900B8898900B889
      8900B8898900B8898900B889890065CDF90065CDF80065CDF90065CDF80066CE
      F90039ADD800078DBE000000000000000000078DBE0063CBF800078DBE00A3E1
      FB0066CDF90065CDF80065CDF90065CDF90065CDF80065CDF90065CDF80066CD
      F8003AADD800ACE7F500078DBE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8898900FEFDFB00FEFDFB00FEFD
      FB00FEFDFB00FEFDFB004D8743000C8518000C8518000C85180051BDB6006ED4
      F9003EB1D90084D7EB00078DBE0000000000078DBE006AD1F900078DBE00A8E5
      FC006FD4FA006FD4F9006ED4FA006FD4F9006FD4FA006FD4FA006FD4FA006ED4
      F9003EB1D900B1EAF500078DBE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8898900FEF9F400FEF9F400FEF9
      F400FEF9F400FEF9F400B889890067CED6000C851800139825000C8518004BB7
      9A0042B4D400AEF1F900078DBE0000000000078DBE0072D6FA00078DBE00AEEA
      FC0079DCFB0079DCFB0079DCFB0079DCFB0079DCFB007ADCFB0079DCFA0079DC
      FA0044B5D900B6EEF600078DBE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8898900FEF6ED00FEF6ED00FEF6
      ED00FEF6ED00FEF6ED00B889890083E4FC0084E4FC000C85180026B73F000C85
      180036A8A100B3F4F900078DBE0000000000078DBE0079DDFB00078DBE00B5EE
      FD0083E4FB0084E4FB0083E4FC0083E4FC0084E4FC0083E4FC0083E4FB0084E5
      FC0048B9DA00BBF2F600078DBE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8898900FFF2E700FFF2E700FFF2
      E700FAE8DE00FAE8DE00B88989008DEBFD008DEBFD005DC0A7000C85180037C4
      58000C851800ACF0EB006DCAE000078DBE00078DBE0082E3FC00078DBE00BAF3
      FD008DEBFC009933000099330000993300009933000099330000993300009933
      000099330000BEF4F700078DBE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8898900FFEFE000FFEFE000FFEF
      E000D09F9E00D0A09E00C5939300ACE4DA009FDBCA0082AB81000C8518004EDB
      78000C85180098BA9900A3BFAC00078DBE00078DBE008AEAFC00078DBE00FFFF
      FF00C9F7FE0099330000FEFEFE00FEFEFE00FEFEFE008EA4FD00B8C6FD00FEFE
      FE0099330000DEF9FB00078DBE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8898900FFEBD900FFEBD900F3D7
      C900D5ABA800D1C8C200CD999900078780000C8518000C85180047D06E0059E3
      880042C667000C8518000C851800078DBE00078DBE0093F0FE00078DBE00078D
      BE00078DBE0099330000FEFEFE00FAFBFE007E98FC000335FB00597AFC00FEFE
      FE0099330000078DBE00078DBE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8898900FFE8D200FFE8D200F3D4
      C400D9AEAC00CD9999009AF6FE009BF5FE0063C5A4000C8518005DE88E0063EE
      98004CD075000C851800F0F1E700B8898900078DBE009BF5FE009AF6FE009AF6
      FE009BF5FD0099330000D6DEFE004368FC000335FB004066FC000436FB00D9E0
      FE00993300000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B8898900B8898900B8898900B889
      8900CD999900A1FAFE00A1FBFE00A0FAFE00A1FBFE00737E57000C85180046CB
      6E000C851800EFEDDF00FEF6ED00B8898900078DBE00FEFEFE00A0FBFF00A0FB
      FE00A0FBFE00993300005274FC001442FB00BCC9FD00EFF2FE001A47FB004F72
      FC00973304000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000078DBE00FEFEFE00A5FE
      FF00A5FEFF00A5FEFF00078DBE00078DBE00078DBE00B889890084B47B000C85
      1800EDE8D700FAE8DE00FAE8DE00B889890000000000078DBE00FEFEFE00A5FE
      FF00A5FEFF0099330000E4EAFE00D9E0FE00FEFEFE00FEFEFE0098ACFD000335
      FB00643459000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000078DBE00078D
      BE00078DBE00078DBE00000000000000000000000000B8898900FFEFE000FFEF
      E000FFEFE000D09F9E00D0A09E00C59393000000000000000000078DBE00078D
      BE00078DBE0099330000FEFEFE00FEFEFE00FEFEFE00FEFEFE00FEFEFE005677
      FC000335FB000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B8898900FFEBD900FFEB
      D900F3D7C900D5ABA800D1C8C200CD9999000000000000000000000000000000
      0000000000009933000099330000993300009933000099330000993300008F33
      11002235C8000335FB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B8898900FFE8D200FFE8
      D200F3D4C400D9AEAC00CD999900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000335FB000335FB000335FB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B8898900B8898900B889
      8900B8898900CD99990000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000335FB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000078DBE00078DBE00078D
      BE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078DBE00078D
      BE00078DBE00078DBE0000000000000000000000000000000000000000000000
      0000000000007F40260081412500814125008141250081412500814125000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008F8E8D008F8F8E008F8F8E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000078DBE0063CBF800078DBE00A3E1
      FB0066CDF90065CDF80065CDF90065CDF90065CDF80065CDF90065CDF80066CD
      F8003AADD800ACE7F500078DBE00000000000000000000000000000000008241
      250081412500CB660000CB660000CB660000CB660000CB660000CB6600008141
      2500814125000000000000000000000000000000000000000000000000000000
      0000918F8F00BDBCBC00EBEBEB00D2D2D1008F8F8E008F8F8E00878786000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000078DBE006AD1F900078DBE00A8E5
      FC006FD4FA006FD4F9006ED4FA006FD4F9006FD4FA006FD4FA006FD4FA006ED4
      F9003EB1D900B1EAF500078DBE000000000000000000000000009B4E1800C562
      0300CA650000CA650000CA650000CA650000CA650000CB660000CB660000CB66
      0000C56303008141250000000000000000000000000000000000000000009796
      9500C4C4C400FFFFFF00FAFAFA00EDEDED00EAECED00C5B4B200946D68008E76
      73008F8F8E008F8F8E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000078DBE0072D6FA00078DBE00AEEA
      FC0079DCFB0079DCFB0079DCFB0079DCFB0079DCFB007ADCFB0079DCFA0079DC
      FA0044B5D900B6EEF600078DBE000000000000000000994D1900C4620200C863
      0000C6610000C6610000C6610000C6610000C8630000C9640000CB660000CB66
      0000CB660000C56303008141250000000000000000000000000099989700D1D0
      D000FFFFFF00FFFFFF00FBFBFB00F0F0F000EEF1F100C9B8B600966862009665
      6000BDAEAD00C1C2C3008F8F8E007979780000000000C8D0D40000FFFF00C8D0
      D40000FFFF00C8D0D40000FFFF00C8D0D40000FFFF00C8D0D40000FFFF000000
      000000000000000000000000000000000000078DBE0079DDFB00078DBE00B5EE
      FD0083E4FB0044B181000A8313000C8D170044B0810079DBE90083E4FB0084E5
      FC0048B9DA00BBF2F600078DBE000000000000000000BB5D0600C6620100C460
      0200C25E0200C76F2200D18A4B00D6955B00D8965A00D4883F00C9640000CB66
      0000CB660000CB6600008241250000000000000000009D9C9B00E0E0E000FFFF
      FF00FFFFFF00FFFFFF00FDFDFD00F6F6F600F4F7F700CDBCBB00966863009566
      6100C2B3B200D6D8D800C3C3C300777776000000000000FFFF00C8D0D40000FF
      FF00C8D0D40000FFFF00C8D0D40000FFFF00C8D0D40000FFFF00C8D0D4000000
      000000000000000000000000000000000000078DBE0081E2F900078DBD00BAF3
      FD008DEBFC008DEBFC0053BE96000D9718000C981800279747008AE9F8008DEB
      FC004CBBDA00BEF4F700078DBE0000000000A8541100C9670700C7680A00C568
      0900D69A5C00FEFEFE00FEFEFE00FEFEFE00FEFEFE00E7C29F00C6610000C964
      0000CB660000CB660000CB6600007F402600000000009D9C9B00FDFDFD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FCFCFC00FBFEFE00D1C0BF00966863009565
      6000C6B7B600DADBDB00C4C4C3007777760000000000C8D0D40000FFFF00C8D0
      D40000FFFF00C8D0D40000FFFF00C8D0D40000FFFF00C8D0D40000FFFF000000
      000000000000000000000000000000000000078DBE0089EAFB00078DBD00FFFF
      FF00C9F7FE00C8F7FE00C9F7FE0073C396000E9D1B000C96170033994600C8F7
      FE009BD5E700DEF9FB00078DBE0000000000AC570F00CD711400CA721800C872
      1A00FEFEFE00E5BF9800CA7C2C00C7732000C36B1600C05F0800C35E0000C863
      0000CA650000CB660000CB66000082412500000000009D9C9B00FEFEFE00FFFF
      FF00C8C2C200A5979700DEDBDB00FFFFFF00FFFFFF00D2C0BF00905F5900905F
      5A00C9BBBA00E1E2E200C9C9C900767776000000000000FFFF00C8D0D40000FF
      FF00C8D0D40000FFFF00C8D0D40000FFFF00C8D0D40000FFFF00C8D0D4000000
      000000000000000000000000000000000000078DBE0093F0FE00078DBE00078D
      BE00078DBE00078DBE00078DBE0007868A000E9B1A000FA71C0008822200078A
      AF00078DBE00078DBE00078DBE0000000000AB581200D4843400CF7F2E00CD7E
      2D00FEFEFE00D0873C00CA782500C6701900C2680C00E6C3A000C15C0100C661
      0000CA650000CB660000CB66000082412500000000009D9C9B00EDEDEE009688
      88007D555500855555006E535300D8D5D500FFFFFF00F2EDEC00D0BEBC00B698
      9500D4C9C700E6E7E700D3D4D400716B6B0000000000C8D0D40000FFFF00C8D0
      D40000FFFF00C8D0D40000FFFF00C8D0D40000FFFF00C8D0D40000FFFF000000
      000000000000000000000000000000000000078DBE009BF5FE009AF6FE009AF6
      FE009BF5FD009BF6FE009AF6FE0076D4C1001698260016AF26000C94180064C5
      A7000989BA00000000000000000000000000AC591500DEA26400D7934D00D38B
      4100FEFEFE00E2B48400D0853700CB7B2A00C6701900FEFEFE00E5BE9800C560
      0000CA650000CB660000CB66000082412500000000009D9C9B00745B5B00A16F
      6F00EFABAB00E39D9D00946060006E535300D9D5D500FFFFFF00FFFFFF00F7F8
      F800EEEEEE00F2F3F300B8B2B2006B5252000000000000FFFF00C8D0D40000FF
      FF00C8D0D40000FFFF00C8D0D40000FFFF00C8D0D40000FFFF00C8D0D4000000
      000000000000000000000000000000000000078DBE00FEFEFE00A0FBFF00A0FB
      FE00A0FBFE00A1FAFE00A1FBFE0086E2D5001F9E340025BB3D0014A4230045AC
      6F000989BA00000000000000000000000000AA571100E6B48200E3B17C00DA98
      5400EFD2B500FEFEFE00F5E6D700F4E4D300F7ECE100FEFEFE00FEFEFE00EDCF
      B200CA650000CB660000CB660000824125000000000080616100D49D9E00FABB
      BB00F0ADAD00EDA4A400DB929300945F5F006B515100D9D5D500FFFFFF00FDFD
      FD00FFFFFF00C3BDBD005F4444008B62620000000000C8D0D40000FFFF00C8D0
      D40000FFFF00C8D0D40000FFFF00C8D0D40000FFFF00C8D0D40000FFFF000000
      00000000000000000000000000000000000000000000078DBE00FEFEFE00A5FE
      FF000C8518000C8518000C8518000C85180027A9420034C5520023B539000C85
      18000C8518000C8518000C85180000000000AA550E00E7B27D00F0D3B500E5B0
      7900E3AA6F00EAC39A00F0D6BB00EDD0B300F2DFCB00FEFEFE00FEFEFE00EBC8
      A600CA650000CB660000CB6600007F4026000000000093686800FFCDCD00F4B6
      B600EFACAC00EAA2A200E99A9B00D88A8A00915C5C006B525200DBD7D700FFFF
      FF00B5ACAC00614545008B616100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000078DBE00078D
      BE00078CAE000C8518002095320050D97B004BD575003ECB620032C1500026B8
      3E00159E24000C851800000000000000000000000000AF622100F3D9BF00F4D9
      BE00EABB8B00E3AA6F00DC9B5A00D58E4500D0823200FEFEFE00E7BD9200CA66
      0400CA650000CB66000082412500000000000000000093686800E3ACAC00F8BA
      BA00EFACAC00EAA2A200E5989900E28F8F00D1808000915C5C00715A5A008A7B
      7B005F4040008E6363000000000000000000000000000000000000FFFF00C8D0
      D40000FFFF00C8D0D40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000C85180032AE4E005CE68E004FD8780043D068002EBA
      4B000C85180000000000000000000000000000000000AA550E00E9B78200F8E7
      D500F6DFC800E9BB8B00DE9F5E00D78F4500D3843300E7BC9000CF741700CB68
      0800CB660000C56303007D3F270000000000000000000000000093686800E7AB
      AB00F4AFAF00EAA2A200E4989900E69A9B00FFCCCC00CF777700935A5A006341
      4100906565000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000C8518003EBE600061EA93004ED677000C85
      1800000000000000000000000000000000000000000000000000AB561000EBB9
      8600F6E0CA00F7E6D400F0D1B100E8B98A00E3AA7100DFA06000D98F4400CE71
      1100C56303008F481E0000000000000000000000000000000000000000009368
      6800E4A3A300EEA4A400E69A9B00EEABAB00FFCCCC00E3848500936868000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000C85180046C86C000C8518000000
      000000000000000000000000000000000000000000000000000000000000AC57
      0F00B3672800ECBC8B00F0CBA600EECAA400EABC8E00E1A26300D47E2800B05C
      1500894521000000000000000000000000000000000000000000000000000000
      000093686800EEA4A400E99C9D009368680093686800E3848500936868000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000C851800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AE591100B05D1700B2611D00B1601A00B05B14009C5019000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009368680093686800000000009368680093686800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FDFDFD00F4F4F400E8E8E800E3E3E300E6E6E600E7E7E700DDDD
      DD00C6C6C600A9A9A9009D9D9D00BCBCBC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000732DE000732DE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FEFE
      FE00F7F7F700E3E3E300C7C7C700A9A9A900A1A1A100A8A8A800A9A9A9008289
      930058667B00868D96008B8987009D9D9D00000000000732DE000732DE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000732DE000732DE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000097433F009743
      3F00B59A9B00B59A9B00B59A9B00B59A9B00B59A9B00B59A9B00B59A9B009330
      300097433F000000000000000000000000000000000000000000FBFBFB00ECEC
      EC00CFCFCF00A3A3A200A0A0A100A6A6A60090919100818180009E9C9B006171
      8D002960A300548AC700C5C7C900B4B4B400000000000732DE000732DE000732
      DE00000000000000000000000000000000000000000000000000000000000000
      00000732DE000732DE0000000000000000000000000000000000000000000000
      0000000000008080000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000097433F00D6686800C660
      6000E5DEDF0092292A0092292A00E4E7E700E0E3E600D9DFE000CCC9CC008F20
      1F00AF46460097433F00000000000000000000000000FAFAFA00E3E3E300BFB3
      B0009B918E00C0C4C500DDC6B800F8C6A400F3CDB600CCC7C400B5B4B300D1D0
      CF005E99D500417BBC00ADADB000E2E2E200000000000732DE000732DD000732
      DE000732DE000000000000000000000000000000000000000000000000000732
      DE000732DE000000000000000000000000000000000000000000000000000000
      000000000000FFFF000080800000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000097433F00D0656600C25F
      5F00E9E2E20092292A0092292A00E2E1E300E2E6E800DDE2E400CFCCCF008F22
      2200AD46460097433F000000000000000000FDFDFD00E6E6E600D4A59500D685
      6A00BBBBBC00D5CAC600F7C79B00FFDBA600FFCC9800FCCCAD00BFBDBB00CCC9
      C7006A7C95008893A400E7E7E700FBFBFB0000000000000000000534ED000732
      DF000732DE000732DE00000000000000000000000000000000000732DE000732
      DE00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000808000000000000000000000000000000000
      0000000000000000000000000000000000000000000097433F00D0656500C15D
      5D00ECE4E40092292A0092292A00DFDDDF00E1E6E800E0E5E700D3D0D2008A1E
      1E00AB44440097433F000000000000000000F4F4F400E0AE9B00FC9D7700D88D
      7200C7CCCE00D6C9C400F8D9AD00FFF2C400FFE3B200FFC79400E2C5B7009798
      99008E8F9100D6D6D600FAFAFA00000000000000000000000000000000000000
      00000732DE000732DE000732DD00000000000732DD000732DE000732DE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800000000000000000000000
      0000000000000000000000000000000000000000000097433F00D0656500C15B
      5C00EFE6E600EDE5E500E5DEDF00E0DDDF00DFE0E200E0E1E300D6D0D200962A
      2A00B24A4A0097433F000000000000000000EAD2C800FBA98400FDB58E00DC93
      7500D5D6D600DDDEDF00DECAB000FFF2C300FFE8B700FFC79300E9CDBD00A278
      6E0088888800CACACA00F6F6F600000000000000000000000000000000000000
      0000000000000732DD000633E6000633E6000633E9000732DC00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF000080800000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000097433F00CD626300C860
      6000C9676700CC727200CA727100C6696900C4646400CC6D6C00CA666700C55D
      5D00CD65650097433F000000000000000000F1B79D00FDBA9400FFCFA800EDA2
      7C00D4B3A800F7FFFF00D4D2D100E0C2A600F8C79900F6C19F00CECCCA00C862
      4700936F6600B6B6B600EEEEEE00000000000000000000000000000000000000
      000000000000000000000633E3000732E3000534EF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF000080800000808000000000000080808000000000000000
      0000000000000000000000000000000000000000000097433F00B6555300C27B
      7800D39D9C00D7A7A500D8A7A600D8A6A500D7A09F00D5A09F00D7A9A700D8AB
      AB00CC66670097433F000000000000000000FAB59100FFCCA500F9BD9700E882
      5C00D1593900DEC0B900EFF6F900D8DADD00CFCBC900C2BAB900C18C7C00D653
      3000A1645300ACACAC00E9E9E900000000000000000000000000000000000000
      0000000000000732DD000534ED000533E9000434EF000434F500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000808000008080000080808000808080000000
      0000000000000000000000000000000000000000000097433F00CC666700F9F9
      F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9
      F900CC66670097433F000000000000000000FCC19C00F7B58F00E3775300DC63
      3F00E16C4700DF876400D6AA9500CCB4A800C7948300D06C4E00D9563100D853
      2F00B75D4600B2B2B200EBEBEB00000000000000000000000000000000000000
      00000434F4000534EF000533EB0000000000000000000434F4000335F8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000FFFF00008080000000000000808080008080
      8000000000000000000000000000000000000000000097433F00CC666700F9F9
      F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9
      F900CC66670097433F000000000000000000FDC19D00E6805B00E3795500EE98
      7300EC967000EEA88400FAD7B000F7CCA700F7B58E00E0664100DB5C3900D957
      3400AE665400C2C2C200F3F3F300000000000000000000000000000000000335
      FC000534EF000434F800000000000000000000000000000000000335FC000335
      FB00000000000000000000000000000000000000000000000000000000000000
      0000808000000000000080808000808080000000000080800000000000008080
      8000000000000000000000000000000000000000000097433F00CC666700F9F9
      F900CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00F9F9
      F900CC66670097433F000000000000000000F7C1A300E1724E00E57F5A00EA90
      6B00F2A68000E8896500F4C39F00FFEEC800FBCAA300DE674300DB5F3C00D857
      3300AD827700D9D9D900FBFBFB000000000000000000000000000335FB000335
      FB000335FC000000000000000000000000000000000000000000000000000335
      FB000335FB000000000000000000000000000000000000000000000000000000
      0000FFFF00008080000000000000808080008080800080800000000000000000
      0000000000000000000000000000000000000000000097433F00CC666700F9F9
      F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9
      F900CC66670097433F000000000000000000F2C5B400DD654100E47B5700E274
      5000E8876300EE9A7500EDA47F00EFA57F00F1A68100E6805B00DB5E3A00CD57
      3700C4B9B700EFEFEF00FEFEFE0000000000000000000335FB000335FB000335
      FB00000000000000000000000000000000000000000000000000000000000000
      0000000000000335FB0000000000000000000000000000000000000000000000
      0000000000008080000080800000000000000000000080800000808000000000
      0000000000000000000000000000000000000000000097433F00CC666700F9F9
      F900CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00F9F9
      F900CC66670097433F000000000000000000FAF0ED00E07F6400E06D4900E378
      5300E2765200E3775300E6835F00E06E4900DF6B4700FBC19B00EC967300C89E
      9300E9E9E900FCFCFC0000000000000000000335FB000335FB000335FB000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000808000008080000080800000FFFF0000000000000000
      0000000000000000000000000000000000000000000097433F00CC666700F9F9
      F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9
      F900CC66670097433F00000000000000000000000000FBF0ED00E2886D00DC61
      3D00DE694500DD654100E0704C00E0704C00E8876200F8C7A400DFCCBF00EDED
      ED00FCFCFC000000000000000000000000000335FB000335FB00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000097433F00F9F9
      F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9F900F9F9
      F90097433F000000000000000000000000000000000000000000FEFCFC00F1C4
      B600E28B7200DC674600E17B5700DB6D4D00E4AA9600EEE5DF00F7F7F700FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D4CDF932846EEF917860EC9F9C8DF472F6F5FE0A000000000000
      00000000000000000000000000000000000000000000000000000B060337180C
      0678201108A2231209AE231209AF231209AF231209AF231209AF231209AF2312
      09AF231209AE201108A2180C06780B0603370000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000B000000230000
      002F0000002F0000002F0000002F0000002F0000002F0000002F0000002F0000
      002F0000002F000000230000000B00000000000000000000000000000000D2CB
      F9342802DFFD2500D9FF2500DAFF4115B6FFB46F43FFCC8823FFB58872CBFCF5
      E41B000000000000000000000000000000000000000000000000AE7B6EFFD9AD
      9DFFD6A89AFFD3A698FFD2A497FFCCA199FFC99E97FFC69C96FFC49995FFC196
      93FFB6918BFFB88E8BFF201108A10F07044A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000B0000003B000000770000
      008F0000008F0000008F0000008F0000008F0000008F0000008F0000008F0000
      008F0000008F000000770000003B0000000B0000000000000000856FEF902500
      D7FF2300CDFF1F49A2FF16C475FF12AE68FF0DA768FF26A95EFFD48F00FFD695
      00FFE9B94BB40000000000000000000000000000000000000000B58272FFFCE1
      CBFFFBE0C8FFFBDEC4FFFBDCC2FFFADABEFFFAD8BBFFFBD7B8FFFAD4B4FFF9D2
      B1FFFAD0AEFFEEBDA5FF231209AE1008044FA0502700954B2500944A2400944A
      2400944A2400944A2400944A2400944A2400944A2400944A2400944A2400944A
      2400944A2400964C2500A151270000000000000000230C72A5FF0C72A5FF0C72
      A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72A5FF0C72
      A5FF0C72A5FF0000009B000000770000002300000000A08FF2702500D6FF2200
      C7FF1F24ACFF14BA81FF00CFE7FF00D2EEFF168E48FF169652FF0BA667FFC785
      00FFCC8E00FFE0A721DE00000000000000000000000000000000BB8875FFFCE4
      CFFFFCE2CCFFFBE0C9FFFBDEC6FFFBDCC3FFFBDABFFFFBD9BCFFFAD6B8FFFAD5
      B5FFFAD3B1FFEFBFA8FF231209AF10080450AB4E2100FEF4E900FEF0E000FEEC
      D700FEE8CF00FEE4C700FEE1C100FEDEBB00FEDDB800FEDDB800FEDDB800FEDD
      B800FEDDB800FEDDB8009149230000000000189AC6FF1B9CC7FF9CFFFFFF6BD7
      FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7FFFF6BD7
      FFFF2899BFFF0C72A5FF0000008F0000002FFBFBFE042600D9FF2200C7FF1C00
      BDFF22A765FF0AC4B5FF00B3C7FF00B0C2FF07BAB0FF148441FF16934FFF2EA0
      54FFBD8200FFCD8E00FFEDC56996000000000000000000000000C28F79FFFCE7
      D4FFFCE4D1FFFCE3CEFFFCE1CAFFFBDFC7FFFBDCC4FFFBDBC0FFFADABCFFFBD7
      B9FFFBD5B6FFF0C1ABFF231209AF10080450AB4E2100FEF8F2004571FA004571
      FA004571FA00FEE9D200A23F0800A23F0800A23F0800FEDDB800059ACD00059A
      CD00059ACD00FEDDB8008F48230000000000189AC6FF199AC6FF79E4F0FF9CFF
      FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BE3FFFF7BDF
      FFFF42B2DEFF197A9DFF0000009B000000476044E9BB2300CFFF2000BCFF4E1F
      88FF13A964FF168E49FF00DDF9FF00D6EDFF0C8C60FF127837FF148946FF0FA2
      61FFB77600FFBF8600FFD69500FFFEFEFE010000000000000000C8957CFFFCE8
      D8FFFCE6D5FFFCE5D2FFFCE3CEFFFBE1CBFFFBE0C8FFFBDEC4FFFADCC1FFFBD9
      BEFFFAD8BBFFF0C3AFFF231209AF10080450AB4E2100FEFCF9004571FA004571
      FA004571FA00FEEEDC00A23F0800A23F0800A23F0800FEE0BE00059ACD00059A
      CD00059ACD00FEDDB8008F48230000000000189AC6FF25A2CFFF3FB8D7FF9CFF
      FFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84EBFFFF84E7
      FFFF42BAEFFF189AC6FF0000009B000000772600DCFF2300C8FF1D00B7FFC983
      1EFF13A663FF158E4CFF13752EFF0D7A42FF0E692AFF117534FF148745FF139F
      5CFFA27604FFB88000FFCF9000FFF1CF7F800000000000000000CF9C80FFFCEB
      DDFFFDEADAFFFCE7D6FFFCE6D3FFFCE4CFFFFCE2CCFFFBE0C9FFFBDEC6FFFBDC
      C2FFFADBBFFFF1C5B1FF231209AF10080450AB4E2100FEFEFE004571FA004571
      FA004571FA00FEF3E700A23F0800A23F0800A23F0800FEE3C600059ACD00059A
      CD00059ACD00FEDDB8008F48230000000000189AC6FF42B3E2FF20A0C9FFA5FF
      FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7FFFF94F7
      FFFF52BEE7FF5BBCCEFF0C72A5FF0000008F2500D8FF2200C2FF1600B7FFE49F
      03FF52A044FF179451FF138240FF117735FF117434FF137D3CFF158E4BFF13A6
      62FFA67102FFB67F00FFCC8F00FFE8AD25DA0000000000000000D5A283FFFDEE
      E0FFFDECDDFFFCEADBFFFCE8D7FFFCE6D3FFFCE4D1FFFBE2CDFFFBE1CAFFFBDF
      C6FFFBDDC3FFF2C8B5FF231209AF10080450AB4E2100FEFEFE00FEFEFE00FEFD
      FC00FEFBF700FEF7F000FEF4E800FEF0E100FEECD700FEE8D000FEE4C800FEE1
      C000FEDEBB00FEDDB8008F48230000000000189AC6FF6FD5FDFF189AC6FF89F0
      F7FF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFFFFFF9CFF
      FFFF5AC7FFFF96F9FBFF187A9BFF0000008F2500D7FF2100C1FF1800B4FFDA97
      0BFFD78E00FF0BA464FF16914DFF148745FF148644FF158D4AFF179B57FF11B2
      6FFFAF6F00FFB88000FFCE9000FFE8A915EA0000000000000000DCA987FFFEF0
      E5FFFDEEE1FFFDECDFFFFDEBDBFFFDE9D8FFFCE6D5FFFCE5D1FFFBE3CEFFFCE1
      CAFFFBDFC7FFF2C9B7FF231209AF10080450AB4E2100FEFEFE00CC9A9900CC9A
      9900CC9A9900FEFCF900E27E0300E27E0300E27E0300FEEDDA00029A0300029A
      0300029A0300FEDFBD008F48230000000000189AC6FF84D7FFFF189AC6FF6BBF
      DAFFFFFFFFFFFFFFFFFFF7FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF84E7FFFFFFFFFFFF187DA1FF000000772600D9FF2200C3FF1E00B2FF7B4E
      58FFD49400FFBE8605FF10A766FF179D59FF179B57FF18A25DFF13B06DFF7D82
      20FFAE7900FFBF8600FFD69500FFF0C04EB10000000000000000DCA987FFFDF3
      EAFFFDF1E6FFFDEFE3FFFDEDDFFFFCEBDCFFFDE9D9FFFDE7D6FFFCE5D3FFFCE4
      CFFFFCE1CBFFF3CCBAFF231209AF10080450AB4E2100FEFEFE00CC9A9900CC9A
      9900CC9A9900FEFEFE00E27E0300E27E0300E27E0300FEF2E500029A0300029A
      0300029A0300FEE2C4008F48230000000000189AC6FF84EBFFFF4FC1E2FF189A
      C6FF189AC6FF189AC6FF189AC6FF189AC6FF189AC6FF189AC6FF189AC6FF189A
      C6FF189AC6FF189AC6FF1889B1FF0000003B2500DEFF2300C9FF1F00B8FF1000
      B3FFECA700FFCA8D00FFC27F00FF85881FFF449E4BFF4D9B44FFA07507FFAE79
      00FFBA8200FFCB8E00FFE19D00FFFBF1D9260000000000000000DCA987FFFDF5
      EDFFFEF3EAFFFDF2E7FFFDEFE4FFFDEDE1FFFDECDEFFFCEADAFFFCE8D7FFFCE6
      D3FFFCE4D0FFF3CDBDFF23120AAA1008044DAB4E2100FEFEFE00CC9A9900CC9A
      9900CC9A9900FEFEFE00E27E0300E27E0300E27E0300FEF7EE00029A0300029A
      0300029A0300FEE7CD008E47220000000000189AC6FF9CF3FFFF8CF3FFFF8CF3
      FFFF8CF3FFFF8CF3FFFF8CF3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF189AC6FF197A9DFF0000003B0000000B4321E7DE2400D3FF2100C0FF1E00
      B1FF1B07A6FFECA600FFCA8D00FFBE8500FFB87F00FFB57E00FFB68000FFBE85
      00FFCB8E00FFDB9900FFECAF1EE1000000000000000000000000DCA987FFFEF8
      F2FFFEF5EEFFFDF4ECFFFDF2E8FFFDF0E5FFFDEEE2FFFDECDEFFFDEADAFFFCE8
      D8FFFCE6D4FFF4C9BAFF23130A9910090543AB4E2100E4E4E400E4E4E400E4E4
      E400E4E4E400E4E4E400E4E4E400E4E4E400E4E4E400E4E4E400E4E2E100E4E0
      DC00E4DED600E4DACF00944D290000000000189AC6FFFFFFFFFF9CFFFFFF9CFF
      FFFF9CFFFFFF9CFFFFFFFFFFFFFF189AC6FF189AC6FF189AC6FF189AC6FF189A
      C6FF189AC6FF000000230000000B00000000F4F2FD0D2700DEFF2300CDFF2100
      BDFF1F00B1FF1300B2FFC88A19FFDD9B00FFCD8F00FFCB8E00FFCD8F00FFD594
      00FFE29E00FFD7951BFF00000000000000000000000000000000DCA987FFFFFA
      F7FFFEF8F3FFFEF6F0FFFEF4ECFFFEF2E9FFFDF1E6FFFDEFE2FFFFD5CCFFFFD5
      CCFFF5B3AAFF94695FE01E120B740D07052EAE5C2700AE612200AD5F2000AD5F
      2000AD5F2000AD5F2000AD5F2000AD5F2000AD5F2100AF622500AE612200AF62
      2500AC602400AA6128008F482300000000000000000021A2CEFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF189AC6FF0000003B0000000B00000000000000000000
      00000000000000000000000000000000000000000000AEA0F55F2500DBFF2300
      CDFF2100C1FF2000B9FF1A00B8FF1E03B3FF7D4D60FFCB8B19FFDF9C06FFC789
      28FF5128ACFFE6E3FD1C00000000000000000000000000000000DCA987FFFFFD
      FBFFFFFBF7FFFEF9F4FFFEF7F1FFFEF5EDFFFDF3EBFFFDF1E7FFF7A643FFF7A6
      43FFDF9140FE28180F91160D094808050317AE5C2700EE973300EE973300EE97
      3300EE973300EE973300EE973300EE973300EE973300EE973300EE973300EE97
      3300EE973300EE973300B95D190000000000000000000000000021A2CEFF21A2
      CEFF21A2CEFF21A2CEFF000000230000000B0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CEC6F9392700
      DFFF2500D4FF2300CCFF2300C8FF2300C5FF2300C8FF2000D0FF1E00DBFF2400
      E2FFE4E0FB1F0000000000000000000000000000000000000000DCA987FFFFFF
      FFFFFFFEFBFFFFFBF8FFFEFAF5FFFEF8F1FFFEF6EEFFFDF3ECFFDCA987FFE9B2
      76FE4F3726C21F140E640C0805250302010900000000CB731A00CC731A00CC73
      1A00CC731A00CC731A00CC731A00CC731A00CC741A00CD751B00CC731800CD75
      1B00CA721A00C8721E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A99AF4653511E2EE2600DCFF2600DBFF2500DDFF2F0AE2F59987F2780000
      0000000000000000000000000000000000000000000000000000DCA987FFDCA9
      87FFDCA987FFDCA987FFDCA987FFDCA987FFDEAB88FFD6A384FFDCA987FF261E
      182D000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0080038003000000000003000100000000
      0001000100000000000100010000000000010001000000000000000100000000
      0000000100000000000000010000000000000007000000000000000700000000
      8000800700000000C380C00700000000FF80F80300000000FF81FFF800000000
      FF83FFFE00000000FFFFFFFF000000008003F81FF8FFFFFF0001E007F01FFFFF
      0001C003E003000F00018001C000000F000180018000000F000100008000000F
      000100008000000F000100008000000D000700008000000B0007000080000007
      800100008001001AC0038001800381D7FC078001C007C3ABFE0FC003E01FFF7D
      FF1FE007F01FFFEFFFBFF81FF93FFFFFF800FFFCFFFFFFFFE0009FF9FFFFC007
      C0008FF3F87F8003800087E7F87F80030000C3CFF8FF80030001F11FFC7F8003
      0001F83FF87F80030001FC7FF83F80030001F83FFC1F80030001F19FFA0F8003
      0001E3CFF08F80030001C7E7F01F800300018FFBF81F800300031FFFF83F8003
      80073FFFFFFFC007C00FFFFFFFFFFFFF0000F83F0000FFFF0000E00F0000FFFF
      0000C00700000001000080030000000100000001000000010000000000000001
      0000000000000001000000000000000100000000000000010000000000000001
      0000000000000001000000010000000100000003000000010000800300000001
      0000C007000080030000F01F0000FFFF00000000000000000000000000000000
      000000000000}
  end
  object dlgSelectFile: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders]
    Left = 129
    Top = 551
  end
end
