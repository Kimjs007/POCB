object frmAlarm: TfrmAlarm
  Left = 553
  Top = 91
  BorderIcons = [biSystemMenu]
  Caption = 'Alarm'
  ClientHeight = 665
  ClientWidth = 934
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
    Width = 934
    Height = 35
    Align = alTop
    Alignment = taLeftJustify
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
    ExplicitWidth = 877
  end
  object RzpnlAlarm: TRzPanel
    Left = 0
    Top = 35
    Width = 934
    Height = 630
    Align = alClient
    Alignment = taLeftJustify
    BorderInner = fsPopup
    BorderOuter = fsPopup
    BorderSides = [sdBottom]
    Color = 16768443
    FlatColor = 10524310
    Font.Charset = ANSI_CHARSET
    Font.Color = 9856100
    Font.Height = -21
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    GradientColorStyle = gcsCustom
    GradientColorStart = 16768443
    GradientColorStop = 16768443
    TextMargin = 4
    ParentFont = False
    TabOrder = 1
    VisualStyle = vsGradient
    WordWrap = False
    ExplicitWidth = 877
    ExplicitHeight = 534
    object RzgrpAlarmTable: TRzGroupBox
      Left = 362
      Top = 6
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
      TabOrder = 0
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
    object RzgrpAlarmOn: TRzGroupBox
      Left = 8
      Top = 6
      Width = 348
      Height = 611
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
      TabOrder = 1
      Transparent = True
      object lstAlarmOn: TRzCheckList
        Left = 0
        Top = 20
        Width = 348
        Height = 545
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
      object btnAlarmSelect: TRzBitBtn
        Left = 9
        Top = 588
        Width = 90
        Height = 27
        Hint = 'Create New Model'
        FrameColor = clGradientActiveCaption
        Caption = 'Select All'
        Color = 16776176
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 1
        TextStyle = tsRecessed
        Visible = False
        OnClick = btnAlarmSelectClick
      end
      object btnAlarmClear: TRzBitBtn
        Left = 105
        Top = 588
        Width = 90
        Height = 27
        Hint = 'Create New Model'
        FrameColor = clGradientActiveCaption
        Caption = 'Clear'
        Color = 16776176
        Font.Charset = ANSI_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        HotTrack = True
        ParentFont = False
        TabOrder = 2
        TextStyle = tsRecessed
        Visible = False
        OnClick = btnAlarmClearClick
      end
    end
    object btnClose: TRzBitBtn
      Left = 757
      Top = 577
      Width = 164
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
      TabOrder = 2
      TextStyle = tsRecessed
      OnClick = btnCloseClick
    end
    object btnReflesh: TRzBitBtn
      Left = 362
      Top = 577
      Width = 164
      Height = 42
      FrameColor = clGradientActiveCaption
      Caption = 'Reflesh'
      Font.Charset = ANSI_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      HotTrack = True
      ParentFont = False
      TabOrder = 3
      TextStyle = tsRecessed
      OnClick = btnRefleshClick
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
end
