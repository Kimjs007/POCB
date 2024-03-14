object frmPatternEdit: TfrmPatternEdit
  Left = 2373
  Top = 301
  BorderIcons = [biSystemMenu]
  Caption = 'PatternEdit'
  ClientHeight = 741
  ClientWidth = 1025
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PnlGroup: TRzPanel
    Left = 0
    Top = 0
    Width = 1025
    Height = 741
    Align = alClient
    BorderOuter = fsNone
    BorderShadow = clBtnFace
    Color = 16119543
    TabOrder = 0
    object grpPGrpSelection: TRzGroupBox
      Left = 10
      Top = 8
      Width = 254
      Height = 685
      Caption = 'Pattern Group Selection'
      CaptionFont.Charset = ANSI_CHARSET
      CaptionFont.Color = 7879740
      CaptionFont.Height = -11
      CaptionFont.Name = 'Verdana'
      CaptionFont.Style = [fsBold]
      Font.Charset = ANSI_CHARSET
      Font.Color = 7879740
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      object grpPGrpName: TRzGroupBox
        Left = 12
        Top = 22
        Width = 230
        Height = 49
        Caption = 'Pattern Group Name'
        Ctl3D = True
        Font.Charset = ANSI_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        GradientColorStyle = gcsCustom
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        ParentColor = True
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        object edPGrpName: TRzEdit
          Left = 0
          Top = 21
          Width = 230
          Height = 22
          Text = ''
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ImeName = 'Microsoft Office IME 2007'
          ParentFont = False
          TabOrder = 0
        end
      end
      object grpPGrpList: TRzGroupBox
        Left = 12
        Top = 159
        Width = 230
        Height = 514
        Caption = 'Pattern Group List'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        GradientColorStyle = gcsCustom
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        ParentColor = True
        ParentFont = False
        TabOrder = 6
        object lstPGrplist: TRzListBox
          Left = 0
          Top = 28
          Width = 230
          Height = 488
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = []
          ImeName = 'Microsoft Office IME 2007'
          ItemHeight = 14
          ParentFont = False
          TabOrder = 0
          OnClick = lstPGrplistClick
        end
      end
      object grpResiPCnt: TRzGroupBox
        Left = 12
        Top = 106
        Width = 230
        Height = 49
        Caption = 'Registered Pattern Count'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        GradientColorStyle = gcsCustom
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        ParentColor = True
        ParentFont = False
        TabOrder = 5
        object pnlPCnt: TRzPanel
          Left = 0
          Top = 21
          Width = 110
          Height = 22
          BorderOuter = fsFlat
          BorderHighlight = clWhite
          BorderShadow = 6080734
          Caption = 'Pattern Count'
          Color = 11855600
          FlatColorAdjustment = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          GradientColorStyle = gcsCustom
          GradientColorStop = clLime
          ParentFont = False
          TabOrder = 0
        end
        object edPCnt: TRzEdit
          Left = 113
          Top = 21
          Width = 117
          Height = 22
          Text = ''
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ImeName = 'Microsoft Office IME 2007'
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
        end
      end
      object btnPGrpNew: TRzBitBtn
        Left = 12
        Top = 71
        Width = 57
        Hint = 'Create New Pattern Group'
        FrameColor = clGradientActiveCaption
        Caption = 'New'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 1
        TextStyle = tsRecessed
        OnClick = btnPGrpNewClick
      end
      object btnPGrpReName: TRzBitBtn
        Left = 126
        Top = 70
        Width = 59
        Hint = 'Rename Pattern Group'
        FrameColor = clGradientActiveCaption
        Caption = 'Rename'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 3
        TextStyle = tsRecessed
        OnClick = btnPGrpReNameClick
      end
      object btnPGrpCopy: TRzBitBtn
        Left = 69
        Top = 70
        Width = 57
        Hint = 'Create New Pattern Group'
        FrameColor = clGradientActiveCaption
        Caption = 'Copy'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 2
        TextStyle = tsRecessed
        OnClick = btnPGrpCopyClick
      end
      object btnPGrpDel: TRzBitBtn
        Left = 185
        Top = 70
        Width = 58
        Hint = 'Delete Pattern Group'
        FrameColor = clGradientActiveCaption
        Caption = 'Delete'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 4
        TextStyle = tsRecessed
        OnClick = btnPGrpDelClick
      end
    end
    object grpPInfo: TRzGroupBox
      Left = 267
      Top = 8
      Width = 516
      Height = 685
      Caption = 'Pattern Information'
      CaptionFont.Charset = ANSI_CHARSET
      CaptionFont.Color = 7879740
      CaptionFont.Height = -11
      CaptionFont.Name = 'Verdana'
      CaptionFont.Style = [fsBold]
      Font.Charset = ANSI_CHARSET
      Font.Color = 7879740
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = True
      ParentFont = False
      TabOrder = 1
      object grpResiPList: TRzGroupBox
        Left = 12
        Top = 106
        Width = 574
        Height = 565
        Caption = 'Registered Pattern List'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        GradientColorStyle = gcsCustom
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        ParentColor = True
        ParentFont = False
        TabOrder = 9
        object HdrTimes: THeader
          Left = 0
          Top = 21
          Width = 574
          Height = 19
          Align = alTop
          AllowResize = False
          BorderStyle = bsNone
          Font.Charset = ANSI_CHARSET
          Font.Color = 7879740
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          Sections.Sections = (
            #0'92'#0'Type'
            #0'235'#0'Pattern Name'
            #0'84'#0'VSync'
            #0'84'#0'Time')
          TabOrder = 0
        end
        object gridPatternList: TRzStringGrid
          Left = 0
          Top = 40
          Width = 574
          Height = 525
          Align = alClient
          FixedCols = 0
          RowCount = 1
          FixedRows = 0
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Verdana'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 1
          OnClick = gridPatternListClick
          ColWidths = (
            89
            234
            83
            100
            60)
        end
      end
      object grpPName: TRzGroupBox
        Left = 105
        Top = 22
        Width = 241
        Height = 44
        Caption = 'Pattern Name'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        GradientColorStyle = gcsCustom
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        ParentColor = True
        ParentFont = False
        TabOrder = 1
        object cboPName: TRzComboBox
          Tag = 2
          Left = 2
          Top = 21
          Width = 239
          Height = 22
          Style = csDropDownList
          Ctl3D = False
          DropDownCount = 20
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
        end
      end
      object grpVSync: TRzGroupBox
        Left = 349
        Top = 22
        Width = 67
        Height = 44
        Caption = 'VSync'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        GradientColorStyle = gcsCustom
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        ParentColor = True
        ParentFont = False
        TabOrder = 2
        object edVSync: TRzEdit
          Left = 3
          Top = 21
          Width = 44
          Height = 22
          Text = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ImeName = 'Microsoft Office IME 2007'
          ParentFont = False
          TabOrder = 0
        end
        object pnlHz: TRzPanel
          Left = 45
          Top = 21
          Width = 22
          Height = 22
          BorderOuter = fsFlat
          BorderHighlight = clWhite
          BorderShadow = 6080734
          Caption = 'Hz'
          Color = clMenu
          FlatColorAdjustment = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          GradientColorStyle = gcsCustom
          GradientColorStop = clLime
          ParentFont = False
          TabOrder = 1
        end
        object chkVSync: TRzCheckBox
          Left = 35
          Top = -2
          Width = 26
          Height = 17
          Hint = 'Check for Input Vertical Frequency Option'
          Alignment = taLeftJustify
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
          FocusColor = clInfoBk
          HotTrack = True
          HotTrackColor = clBtnShadow
          HotTrackStyle = htsFrame
          LightTextStyle = True
          ParentShowHint = False
          ReadOnlyColor = clBtnFace
          ShowHint = True
          State = cbChecked
          TabOrder = 2
          Transparent = True
          UseCustomGlyphs = True
          WordWrap = True
        end
      end
      object btnPInfoAdd: TRzBitBtn
        Left = 120
        Top = 72
        Width = 76
        Hint = 'Add Pattern'
        FrameColor = clGradientActiveCaption
        Caption = 'Add'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 4
        TextStyle = tsRecessed
        OnClick = btnPInfoAddClick
      end
      object btnPInfoModify: TRzBitBtn
        Left = 197
        Top = 72
        Width = 76
        Hint = 'Modify Pattern Infomation'
        FrameColor = clGradientActiveCaption
        Caption = 'Modify'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 5
        TextStyle = tsRecessed
        OnClick = btnPInfoModifyClick
      end
      object btnPInfoUp: TRzBitBtn
        Left = 275
        Top = 72
        Width = 76
        Hint = 'Move Up Pattern Order'
        FrameColor = clGradientActiveCaption
        Caption = 'Up'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 6
        TextStyle = tsRecessed
        OnClick = btnPInfoUpClick
      end
      object btnPInfoDown: TRzBitBtn
        Left = 352
        Top = 72
        Width = 76
        Hint = 'Move Down Pattern Order'
        FrameColor = clGradientActiveCaption
        Caption = 'Down'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 7
        TextStyle = tsRecessed
        OnClick = btnPInfoDownClick
      end
      object btnPInfoDel: TRzBitBtn
        Left = 430
        Top = 72
        Width = 76
        Hint = 'Delete Pattern'
        FrameColor = clGradientActiveCaption
        Caption = 'Delete'
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 8
        TextStyle = tsRecessed
        OnClick = btnPInfoDelClick
      end
      object grpPType: TRzGroupBox
        Left = 12
        Top = 22
        Width = 91
        Height = 44
        Caption = 'Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        GradientColorStyle = gcsCustom
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        ParentColor = True
        ParentFont = False
        TabOrder = 0
        object cboPType: TRzComboBox
          Tag = 2
          Left = 0
          Top = 21
          Width = 91
          Height = 22
          Style = csDropDownList
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ImeName = 'Microsoft Office IME 2007'
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          OnChange = cboPTypeChange
          Items.Strings = (
            'Pattern'
            'Bitmap')
        end
      end
      object grpTime: TRzGroupBox
        Left = 421
        Top = 22
        Width = 84
        Height = 44
        Caption = 'Time'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        GradientColorStyle = gcsCustom
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        ParentColor = True
        ParentFont = False
        TabOrder = 3
        object pnlSec: TRzPanel
          Left = 49
          Top = 21
          Width = 34
          Height = 22
          BorderOuter = fsFlat
          BorderHighlight = clWhite
          BorderShadow = 6080734
          Caption = 'Sec'
          Color = clMenu
          FlatColorAdjustment = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          GradientColorStyle = gcsCustom
          GradientColorStop = clLime
          ParentFont = False
          TabOrder = 0
        end
        object edTime: TRzEdit
          Left = 2
          Top = 21
          Width = 45
          Height = 22
          Text = '2'
          Alignment = taCenter
          AutoSelect = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ImeName = 'Microsoft Office IME 2007'
          MaxLength = 2
          ParentFont = False
          TabOrder = 1
        end
        object chkTime: TRzCheckBox
          Left = 40
          Top = -2
          Width = 26
          Height = 17
          Hint = 'Check for Input Display Time Option'
          Alignment = taLeftJustify
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
          FocusColor = clInfoBk
          HotTrack = True
          HotTrackColor = clBtnShadow
          HotTrackStyle = htsFrame
          LightTextStyle = True
          ParentShowHint = False
          ReadOnlyColor = clBtnFace
          ShowHint = True
          State = cbChecked
          TabOrder = 2
          Transparent = True
          UseCustomGlyphs = True
          WordWrap = True
        end
      end
      object cboResolution: TRzComboBox
        Tag = 2
        Left = 12
        Top = 73
        Width = 93
        Height = 22
        Style = csDropDownList
        Ctl3D = False
        DropDownCount = 10
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ImeName = 'Microsoft Office IME 2007'
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 10
        Visible = False
        OnChange = cboResolutionChange
      end
    end
    object grpPPreview: TRzGroupBox
      Left = 801
      Top = 30
      Width = 216
      Height = 447
      Caption = 'Pattern Preview'
      CaptionFont.Charset = ANSI_CHARSET
      CaptionFont.Color = 7879740
      CaptionFont.Height = -11
      CaptionFont.Name = 'Verdana'
      CaptionFont.Style = [fsBold]
      Font.Charset = ANSI_CHARSET
      Font.Color = 7879740
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      GradientColorStyle = gcsCustom
      GradientColorStop = 16763080
      GroupStyle = gsBanner
      ParentColor = True
      ParentFont = False
      TabOrder = 2
      object RzPanel17: TRzPanel
        Left = 0
        Top = 21
        Width = 216
        Height = 426
        Align = alClient
        BorderOuter = fsStatus
        Color = 16119543
        TabOrder = 0
        object imgPPreview: TDongaPat
          Left = 1
          Top = 1
          Width = 214
          Height = 424
          Align = alClient
          DongaImgWidth = 640
          DongaImgHight = 1136
          DongaUseSpc = True
          ExplicitLeft = 56
          ExplicitTop = 162
          ExplicitWidth = 105
          ExplicitHeight = 105
        end
      end
    end
    object btnPGrpSave: TRzBitBtn
      Left = 856
      Top = 593
      Width = 120
      Height = 30
      FrameColor = clGradientActiveCaption
      Caption = 'Save'
      Font.Charset = ANSI_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      HotTrack = True
      ParentFont = False
      TabOrder = 3
      TextStyle = tsRecessed
      OnClick = btnPGrpSaveClick
    end
    object btnPGrpClose: TRzBitBtn
      Left = 856
      Top = 663
      Width = 120
      Height = 30
      FrameColor = clGradientActiveCaption
      Caption = 'Close'
      Font.Charset = ANSI_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      HotTrack = True
      ParentFont = False
      TabOrder = 4
      TextStyle = tsRecessed
      OnClick = btnPGrpCloseClick
    end
    object btnSPC: TRzBitBtn
      Left = 801
      Top = 493
      Width = 215
      Height = 30
      FrameColor = clGradientActiveCaption
      Caption = 'Edit pattern'
      Font.Charset = ANSI_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      HotTrack = True
      ParentFont = False
      TabOrder = 5
      TextStyle = tsRecessed
      OnClick = btnSPCClick
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
        E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E80B0B0B0B0B
        0B0B0B0B0B0B0B0B0BE8E88181818181818181818181818181E8E80BD7D7D7D7
        D7D7D7D7D7D7D7D70BE8E881E8E8E8E8E8E8E8E8E8E8E8E881E8E80BD7D7D7D7
        D7D7D7818181D7D70BE8E881E8E8E8E8E8E8E8E2E2E2E8E881E8E80BD7D7D7D7
        D7D7D7D7D7D7D7D70BE8E881E8E8E8E8E8E8E8E8E8E8E8E881E8E80BD7D7D7D7
        D7D7D7515151D7D70BE8E881E8E8E8E8E8E8E8818181E8E881E8E80BD7D78181
        81D7D7515151D7D70BE8E881E8E8E2E2E2E8E8818181E8E881E8E80BD7D7D7D7
        D7D7D7515151D7D70BE8E881E8E8E8E8E8E8E8818181E8E881E8E80BD7D7C1C1
        C1D7D7D7D7D7D7D70BE8E881E8E8818181E8E8E8E8E8E8E881E8E80BD7D7C1C1
        C1D7D7D7D7D7D7D70BE8E881E8E8818181E8E8E8E8E8E8E881E8E80BD7D7C1C1
        C1D7D7D7D7D7D7D70BE8E881E8E8818181E8E8E8E8E8E8E881E8E80BD7D7D7D7
        D7D7D7D7D7D7D7D70BE8E881E8E8E8E8E8E8E8E8E8E8E8E881E8E80B0B0B0B0B
        0B0B0B0B0B0B0B0B0BE8E88181818181818181818181818181E8E80B0B0B0B0B
        0B0B0B0B0B0B0B0B0BE8E88181818181818181818181818181E8E8890B0B0B0B
        0B0B0B0B0B0B0B0B89E8E8AC818181818181818181818181ACE8E8E8E8E8E8E8
        E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8}
      NumGlyphs = 2
    end
  end
end
