object frmAlarm: TfrmAlarm
  Left = 553
  Top = 91
  BorderIcons = [biSystemMenu]
  Caption = 'Alarm'
  ClientHeight = 685
  ClientWidth = 928
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object RzpnlHeader: TRzPanel
    Left = 0
    Top = 0
    Width = 928
    Height = 35
    Align = alTop
    BorderOuter = fsFlat
    BorderSides = [sdBottom]
    Caption = 'Alarm'
    FlatColor = 10524310
    Font.Charset = ANSI_CHARSET
    Font.Color = 9856100
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    GradientColorStart = clRed
    GradientColorStop = clRed
    GridColor = clRed
    TextMargin = 4
    ParentFont = False
    TabOrder = 0
    VisualStyle = vsGradient
    WordWrap = False
  end
  object PageControlAlarm: TRzPageControl
    Left = 0
    Top = 35
    Width = 928
    Height = 650
    Hint = ''
    ActivePage = tabAlarmHistory
    ActivePageDefault = tabAlarmList
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabIndex = 1
    TabOrder = 1
    TabStyle = tsDoubleSlant
    OnTabClick = PageControlAlarmClick
    FixedDimension = 19
    object tabAlarmList: TRzTabSheet
      Caption = '(Current) Alarm List'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      object btnAlarmListClose: TRzBitBtn
        Left = 746
        Top = 579
        Width = 170
        Height = 42
        FrameColor = clGradientActiveCaption
        Caption = 'Close'
        Font.Charset = ANSI_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 0
        TextStyle = tsRecessed
        OnClick = btnAlarmListCloseClick
      end
      object btnAlarmListRefrlesh: TRzBitBtn
        Left = 570
        Top = 579
        Width = 170
        Height = 42
        FrameColor = clGradientActiveCaption
        Caption = 'Refresh'
        Font.Charset = ANSI_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 1
        TextStyle = tsRecessed
        OnClick = btnAlarmListRefreshClick
      end
      object RzgrpAlarmOn: TRzGroupBox
        Left = 8
        Top = 8
        Width = 348
        Height = 565
        Caption = 'Current Alarms'
        CaptionFont.Charset = ANSI_CHARSET
        CaptionFont.Color = 7879740
        CaptionFont.Height = -11
        CaptionFont.Name = 'Verdana'
        CaptionFont.Style = [fsBold]
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        GradientColorStyle = gcsCustom
        GradientColorStop = 16763080
        GroupStyle = gsBanner
        ParentColor = True
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
        Transparent = True
        object lstAlarmOn: TRzCheckList
          Left = -5
          Top = 23
          Width = 348
          Height = 542
          Items.Strings = (
            'aa.pat')
          Items.ItemEnabled = (
            True)
          Items.ItemState = (
            0)
          Font.Charset = ANSI_CHARSET
          Font.Color = clMaroon
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = []
          FrameController = RzFrameController1
          ImeName = 'Microsoft Office IME 2007'
          ItemHeight = 18
          ParentFont = False
          TabOrder = 0
        end
      end
      object RzgrpAlarmTable: TRzGroupBox
        Left = 357
        Top = 8
        Width = 559
        Height = 565
        Caption = 'Alarm Table'
        CaptionFont.Charset = ANSI_CHARSET
        CaptionFont.Color = 7879740
        CaptionFont.Height = -11
        CaptionFont.Name = 'Verdana'
        CaptionFont.Style = [fsBold]
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
        TabOrder = 3
        Transparent = True
        object gridAlarmList: TAdvStringGrid
          Left = 0
          Top = 20
          Width = 561
          Height = 545
          Cursor = crDefault
          DefaultRowHeight = 21
          DrawingStyle = gdsClassic
          FixedCols = 0
          RowCount = 20
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Verdana'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
          HoverRowCells = [hcNormal, hcSelected]
          ActiveCellFont.Charset = ANSI_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Verdana'
          ActiveCellFont.Style = [fsBold]
          Bands.PrimaryColor = 16771304
          CellNode.TreeColor = clSilver
          ColumnHeaders.Strings = (
            'Alarm#'
            'Alarm Name'
            'DIO-IN#'
            'Class'
            'ON/OFF')
          ColumnSize.Stretch = True
          ControlLook.FixedGradientHoverFrom = clGray
          ControlLook.FixedGradientHoverTo = clWhite
          ControlLook.FixedGradientDownFrom = clGray
          ControlLook.FixedGradientDownTo = clSilver
          ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
          ControlLook.DropDownHeader.Font.Color = clWindowText
          ControlLook.DropDownHeader.Font.Height = -11
          ControlLook.DropDownHeader.Font.Name = 'Tahoma'
          ControlLook.DropDownHeader.Font.Style = []
          ControlLook.DropDownHeader.Visible = True
          ControlLook.DropDownHeader.Buttons = <>
          ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
          ControlLook.DropDownFooter.Font.Color = clWindowText
          ControlLook.DropDownFooter.Font.Height = -11
          ControlLook.DropDownFooter.Font.Name = 'MS Sans Serif'
          ControlLook.DropDownFooter.Font.Style = []
          ControlLook.DropDownFooter.Visible = True
          ControlLook.DropDownFooter.Buttons = <>
          Filter = <>
          FilterDropDown.Font.Charset = DEFAULT_CHARSET
          FilterDropDown.Font.Color = clWindowText
          FilterDropDown.Font.Height = -11
          FilterDropDown.Font.Name = 'MS Sans Serif'
          FilterDropDown.Font.Style = []
          FilterDropDownClear = '(All)'
          FilterEdit.TypeNames.Strings = (
            'Starts with'
            'Ends with'
            'Contains'
            'Not contains'
            'Equal'
            'Not equal'
            'Larger than'
            'Smaller than'
            'Clear')
          FixedColWidth = 53
          FixedRowHeight = 22
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
          HoverButtons.Buttons = <>
          HoverButtons.Position = hbLeftFromColumnLeft
          HTMLSettings.ImageFolder = 'images'
          HTMLSettings.ImageBaseName = 'img'
          PrintSettings.DateFormat = 'dd/mm/yyyy'
          PrintSettings.Font.Charset = DEFAULT_CHARSET
          PrintSettings.Font.Color = clWindowText
          PrintSettings.Font.Height = -11
          PrintSettings.Font.Name = 'MS Sans Serif'
          PrintSettings.Font.Style = []
          PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
          PrintSettings.FixedFont.Color = clWindowText
          PrintSettings.FixedFont.Height = -11
          PrintSettings.FixedFont.Name = 'MS Sans Serif'
          PrintSettings.FixedFont.Style = []
          PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
          PrintSettings.HeaderFont.Color = clWindowText
          PrintSettings.HeaderFont.Height = -11
          PrintSettings.HeaderFont.Name = 'MS Sans Serif'
          PrintSettings.HeaderFont.Style = []
          PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
          PrintSettings.FooterFont.Color = clWindowText
          PrintSettings.FooterFont.Height = -11
          PrintSettings.FooterFont.Name = 'MS Sans Serif'
          PrintSettings.FooterFont.Style = []
          PrintSettings.PageNumSep = '/'
          SearchFooter.FindNextCaption = 'Find next'
          SearchFooter.FindPrevCaption = 'Find previous'
          SearchFooter.Font.Charset = DEFAULT_CHARSET
          SearchFooter.Font.Color = clWindowText
          SearchFooter.Font.Height = -11
          SearchFooter.Font.Name = 'MS Sans Serif'
          SearchFooter.Font.Style = []
          SearchFooter.HighLightCaption = 'Highlight'
          SearchFooter.HintClose = 'Close'
          SearchFooter.HintFindNext = 'Find next occurence'
          SearchFooter.HintFindPrev = 'Find previous occurence'
          SearchFooter.HintHighlight = 'Highlight occurences'
          SearchFooter.MatchCaseCaption = 'Match case'
          SearchFooter.ResultFormat = '(%d of %d)'
          ShowSelection = False
          ShowDesignHelper = False
          SortSettings.DefaultFormat = ssAutomatic
          Version = '8.3.2.4'
          ColWidths = (
            53
            292
            102
            55
            55)
          RowHeights = (
            22
            21
            21
            21
            21
            21
            21
            21
            21
            21
            21
            21
            21
            21
            21
            21
            21
            21
            21
            21)
        end
      end
    end
    object tabAlarmHistory: TRzTabSheet
      Caption = 'Alarm History'
      object btnAlarmHistoryFileOpen: TRzBitBtn
        Left = 3
        Top = 579
        Width = 87
        Caption = 'Open'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 0
        OnClick = btnAlarmHistoryFileOpenClick
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
      object edAlarmHistoryFile: TRzEdit
        Left = 92
        Top = 579
        Width = 453
        Height = 21
        Text = ''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        FrameHotTrack = True
        FrameVisible = True
        ImeName = 'Microsoft IME 2010'
        ParentFont = False
        TabOrder = 1
      end
      object grdAlarmHistory: TAdvStringGrid
        Left = 3
        Top = 0
        Width = 921
        Height = 573
        Cursor = crDefault
        DrawingStyle = gdsClassic
        FixedCols = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 2
        HoverRowCells = [hcNormal, hcSelected]
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        AutoSize = True
        ColumnSize.StretchAll = True
        ControlLook.FixedGradientHoverFrom = clGray
        ControlLook.FixedGradientHoverTo = clWhite
        ControlLook.FixedGradientDownFrom = clGray
        ControlLook.FixedGradientDownTo = clSilver
        ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownHeader.Font.Color = clWindowText
        ControlLook.DropDownHeader.Font.Height = -11
        ControlLook.DropDownHeader.Font.Name = 'Tahoma'
        ControlLook.DropDownHeader.Font.Style = []
        ControlLook.DropDownHeader.Visible = True
        ControlLook.DropDownHeader.Buttons = <>
        ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
        ControlLook.DropDownFooter.Font.Color = clWindowText
        ControlLook.DropDownFooter.Font.Height = -11
        ControlLook.DropDownFooter.Font.Name = 'Tahoma'
        ControlLook.DropDownFooter.Font.Style = []
        ControlLook.DropDownFooter.Visible = True
        ControlLook.DropDownFooter.Buttons = <>
        Filter = <>
        FilterDropDown.Font.Charset = DEFAULT_CHARSET
        FilterDropDown.Font.Color = clWindowText
        FilterDropDown.Font.Height = -11
        FilterDropDown.Font.Name = 'Tahoma'
        FilterDropDown.Font.Style = []
        FilterDropDown.TextChecked = 'Checked'
        FilterDropDown.TextUnChecked = 'Unchecked'
        FilterDropDownClear = '(All)'
        FilterEdit.TypeNames.Strings = (
          'Starts with'
          'Ends with'
          'Contains'
          'Not contains'
          'Equal'
          'Not equal'
          'Larger than'
          'Smaller than'
          'Clear')
        FixedColWidth = 12
        FixedRowHeight = 22
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        HoverButtons.Buttons = <>
        HoverButtons.Position = hbLeftFromColumnLeft
        HTMLSettings.ImageFolder = 'images'
        HTMLSettings.ImageBaseName = 'img'
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'Tahoma'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'Tahoma'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'Tahoma'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'Tahoma'
        PrintSettings.FooterFont.Style = []
        PrintSettings.PageNumSep = '/'
        ScrollSynch = True
        ScrollType = ssFlat
        SearchFooter.FindNextCaption = 'Find &next'
        SearchFooter.FindPrevCaption = 'Find &previous'
        SearchFooter.Font.Charset = DEFAULT_CHARSET
        SearchFooter.Font.Color = clWindowText
        SearchFooter.Font.Height = -11
        SearchFooter.Font.Name = 'Tahoma'
        SearchFooter.Font.Style = []
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurrence'
        SearchFooter.HintFindPrev = 'Find previous occurrence'
        SearchFooter.HintHighlight = 'Highlight occurrences'
        SearchFooter.MatchCaseCaption = 'Match case'
        SearchFooter.ResultFormat = '(%d of %d)'
        SortSettings.DefaultFormat = ssAutomatic
        Version = '8.3.2.4'
        ColWidths = (
          12
          12
          12
          12
          12)
        RowHeights = (
          22
          22
          22
          22
          22
          22
          22
          22
          22
          22)
      end
      object btnAlarmHistoryClose: TRzBitBtn
        Left = 744
        Top = 579
        Width = 170
        Height = 40
        FrameColor = clGradientActiveCaption
        Caption = 'Close'
        Font.Charset = ANSI_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 3
        TextStyle = tsRecessed
        OnClick = btnAlarmHistoryCloseClick
      end
    end
  end
  object RzFrameController1: TRzFrameController
    ReadOnlyColor = clBtnFace
    FocusColor = clInfoBk
    FrameHotTrack = True
    FrameVisible = True
    FramingPreference = fpCustomFraming
    Left = 284
    Top = 510
  end
  object RzOpenDialog1: TRzOpenDialog
    Left = 708
    Top = 7
  end
end
