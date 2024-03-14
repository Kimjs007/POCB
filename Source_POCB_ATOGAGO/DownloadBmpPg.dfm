object frmDownloadBmpPg: TfrmDownloadBmpPg
  Left = 553
  Top = 91
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'BMP Download'
  ClientHeight = 747
  ClientWidth = 1117
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TRzPanel
    Left = 0
    Top = 0
    Width = 1117
    Height = 35
    Align = alTop
    Alignment = taLeftJustify
    BorderOuter = fsFlat
    BorderSides = [sdBottom]
    Caption = 'Data File Transmission'
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
    ExplicitWidth = 1107
  end
  object pnlTail: TRzPanel
    Left = 0
    Top = 693
    Width = 1117
    Height = 54
    Align = alBottom
    Alignment = taLeftJustify
    BorderOuter = fsFlat
    BorderSides = [sdBottom]
    FlatColor = 10524310
    Font.Charset = ANSI_CHARSET
    Font.Color = 9856100
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    GradientColorStart = 11855600
    GradientColorStop = 9229030
    TextMargin = 4
    ParentFont = False
    TabOrder = 1
    VisualStyle = vsGradient
    WordWrap = False
    ExplicitTop = 683
    ExplicitWidth = 1107
    object btnClose: TRzBitBtn
      Left = 408
      Top = 12
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
      TabOrder = 0
      TextStyle = tsRecessed
      OnClick = btnCloseClick
    end
  end
  object pnlDownload: TRzPanel
    Left = 0
    Top = 35
    Width = 1117
    Height = 658
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
    TabOrder = 2
    VisualStyle = vsGradient
    WordWrap = False
    ExplicitWidth = 1107
    ExplicitHeight = 648
    object grpDownStatus: TRzGroupBox
      Left = 550
      Top = 33
      Width = 547
      Height = 471
      Caption = 'Download Status Information of Pattern Generator'
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
      object lblmsec: TRzLabel
        Left = 384
        Top = 435
        Width = 46
        Height = 13
        Caption = '(msec)'
        Font.Charset = ANSI_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
        BlinkIntervalOff = 1000
        BlinkIntervalOn = 1000
      end
      object lblWaitTime: TRzLabel
        Left = 238
        Top = 436
        Width = 77
        Height = 13
        Caption = 'TimeToWait'
        Font.Charset = ANSI_CHARSET
        Font.Color = 7879740
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
        BlinkIntervalOff = 1000
        BlinkIntervalOn = 1000
      end
      object btnSelAllIP: TRzBitBtn
        Left = 1
        Top = 427
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
        TabOrder = 0
        TextStyle = tsRecessed
        OnClick = btnSelAllIPClick
      end
      object btnClearIP: TRzBitBtn
        Left = 96
        Top = 427
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
        TabOrder = 1
        TextStyle = tsRecessed
        OnClick = btnClearIPClick
      end
      object gridPGList: TAdvStringGrid
        Left = 0
        Top = 21
        Width = 545
        Height = 403
        Cursor = crDefault
        ColCount = 4
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
        TabOrder = 2
        OnSelectCell = gridPGListSelectCell
        HoverRowCells = [hcNormal, hcSelected]
        OnCheckBoxClick = gridPGListCheckBoxClick
        ActiveCellFont.Charset = ANSI_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Verdana'
        ActiveCellFont.Style = [fsBold]
        Bands.PrimaryColor = 16771304
        CellNode.TreeColor = clSilver
        ColumnHeaders.Strings = (
          'PG IP Address'
          'Connection'
          'Down Status'
          'Message')
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
        FixedColWidth = 118
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
          118
          94
          100
          212)
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
      object edTime: TRzNumericEdit
        Left = 311
        Top = 430
        Width = 68
        Height = 22
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        FrameController = RzFrameController1
        ImeName = 'Microsoft Office IME 2007'
        MaxLength = 3
        ParentFont = False
        TabOrder = 3
        Visible = False
        Max = 900.000000000000000000
        DisplayFormat = '0'
        Value = 10.000000000000000000
      end
    end
    object tcDownType: TRzTabControl
      Left = 9
      Top = 6
      Width = 538
      Height = 636
      Hint = ''
      BackgroundColor = clBtnFace
      Color = clAqua
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentBackgroundColor = False
      ParentColor = False
      ParentFont = False
      TabColors.HighlightBar = 33023
      TabColors.Unselected = clMedGray
      TabIndex = 0
      TabOrder = 1
      Tabs = <
        item
          Caption = 'BMP'
          Tag = 1
        end
        item
          Caption = 'PRG'
          Visible = False
        end
        item
          Caption = 'PG-FPGA'
          Tag = 3
          Visible = False
        end
        item
          Caption = 'PG-FW'
          Tag = 2
          Visible = False
        end
        item
          Caption = 'Pallet-FPGA'
          Tag = 4
          Visible = False
        end
        item
          Caption = 'Pallet-FW'
          Tag = 5
          Visible = False
        end>
      Transparent = True
      OnChange = tcDownTypeChange
      FixedDimension = 22
      object pnlListCtrl: TRzPanel
        Left = 1
        Top = 23
        Width = 534
        Height = 610
        Align = alClient
        Alignment = taLeftJustify
        BorderOuter = fsFlat
        BorderSides = [sdBottom]
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
        object grpPCFilelist: TRzGroupBox
          Left = 7
          Top = 7
          Width = 286
          Height = 594
          Caption = 'BMP File List'
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
          TabOrder = 0
          Transparent = True
          object lstPCFileList: TRzCheckList
            Left = -1
            Top = 20
            Width = 280
            Height = 538
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
          object btnSelAllPC: TRzBitBtn
            Left = 1
            Top = 564
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
            OnClick = btnSelAllPCClick
          end
          object btnClearPC: TRzBitBtn
            Left = 97
            Top = 564
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
            OnClick = btnClearPCClick
          end
          object btnDeletePC: TRzBitBtn
            Left = 189
            Top = 564
            Width = 90
            Height = 27
            Hint = 'Create New Model'
            FrameColor = clGradientActiveCaption
            Caption = 'Delete'
            Color = 16776176
            Font.Charset = ANSI_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            HotTrack = True
            ParentFont = False
            TabOrder = 3
            TextStyle = tsRecessed
            OnClick = btnDeletePCClick
          end
        end
        object pnlScreenPanel: TRzPanel
          Left = 292
          Top = 7
          Width = 241
          Height = 594
          BorderOuter = fsStatus
          BorderHighlight = clWhite
          FlatColorAdjustment = 0
          Font.Charset = ANSI_CHARSET
          Font.Color = 9856100
          Font.Height = -21
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object btnDownload: TRzBitBtn
            Left = 11
            Top = 165
            Width = 222
            Height = 163
            Hint = 'Create New Model'
            FrameColor = clGradientActiveCaption
            Caption = 'Download'
            Color = 16776176
            Font.Charset = ANSI_CHARSET
            Font.Color = clNavy
            Font.Height = -17
            Font.Name = 'Verdana'
            Font.Style = [fsBold]
            HotTrack = True
            ParentFont = False
            TabOrder = 0
            TextStyle = tsRecessed
            OnClick = btnDownloadClick
            Glyph.Data = {
              36080000424D3608000000000000360400002800000020000000200000000100
              0800000000000004000000000000000000000001000000000000C4C4C400EBA9
              5200EAA54B00E8A24500E69F3E00EDAC5800EFAF5F00E49C3800E3983200F1B2
              6500E1952B00F2B66B00F4B97200DF922500E19E3D00E1A04100E2A14500F6BC
              7800DE8F2000FEE2C400DF962D00E5A54D00E5A85100E3A44900EBB26500F0F0
              F000E1952C00E7AA5500E9B06000EFBA7500C7C7C700E9AD5B00EDB56A00EEB7
              6F00F4C58A00F5C58900F8C99300FBCA9200ECAC5900F3BB7500F4CA9300FBD0
              9F00E4A34600DB8F2000E6A44800FDDDB900DD912300FACD9B00E5A54B00FAC8
              8F00FAC48700F5BE7C00F7BF7D00FDD3A600E29B3600DAA95F00EAA95400DF92
              2600F8C48600DC8D1B00F8D4A700E39D3C00F9CC9700DD912500F1C07F00F9C1
              8200F5C88F00E7E7E700DB8F1E00F7C07F00E5A04200DE952B00F6BC7900DD93
              2600F4BA7400DC902100DC8D1C00DB8E1D00FBD3A400F9C28300F7F7F700DE93
              2800E8A74D00FCD3A700F2B77000F2B76D00E0983100E4A34700FBDAB400E5A6
              4C00DE8F2100E5A64D00DB8A1700E6A74F00FCDCB700E7A95100FAD0A000F2B6
              6C00E1983100E7A95400F8D5AA00E6A74E00FDD6AD00F6C78E00F5CF9F00C1C1
              C100FBD9B100EDB06000FEDEBC00DB8D1C00F0B56A00F4B97300DD922500F6BD
              7A00F1B36700FAD7AE00EEB26400F9C58B00ECECEC00EDAD5A00E09D3B00F7C9
              9400FDDBB600E7A85000E3A24500DE942900F3C28600F9CE9C00F1B26600F7C1
              8200E29E3D00F7BF7E00F8CC9900FCD1A200F7D1A300E0972F00E4A44900EFB0
              6100E0942800EDAC5900EBA95300F2BF7F00E69F3F00B37C3100E0AF6700D481
              0700EFAF6000D98D2100B9791D00B46E0600E4A85400EAA54C00E39D3A00F4C1
              8400B3874A00C7954D00E8A24600D8963A00E3983300D3933F00E19A3700E096
              3200F1BD7900D18F3400E8E8E800C5780600D69F5400C17C1800A5650500E49C
              3900EAEAEA00BD8A4100FCFCFC00E7B56D00D7830700FFFFFF00000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000AFAF507619AC
              AFAFAFAFAFAFAFAF507619ACAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF43691EAA
              ACAFAFAFAFAFAFAF43691EAAACAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF37AEAB00
              AAACAFAFAFAFAFAF37AEAB00AAACAFAFAFAFAFAFAFAFAFAFAFAFAFAFAE786DAB
              00AAACAFAFAFAFAFAE786DAB00AAACAFAFAFAFAFAFAFAFAFAFAFAFAFAE0E0E4D
              AB00AAACAFAFAFAFAE0E0E4DAB00AAACAFAFAFAFAFAFAFAFAFAFAFAFAE0F3F0F
              44AB00AAACAFAFAFAE0F3F0F44AB00AAACAFAFAFAFAFAFAFAFAFAFAFAE105C51
              102BAB00AAACAFAFAE105C51102BAB00AAACAFAFAFAFAFAFAFAFAFAFAE174C3B
              14174BAB00AAACAFAE174C3B14174BAB00AAACAFAFAFAFAFAFAFAFAFAE155A12
              1262152EAB00AAACAE155A121262152EAB00AAACAFAFAFAFAFAFAFAFAE16390D
              0D0D361670AB00AA9116390D0D0D361670AB00AAACAFAFAFAFAFAFAFAE1B1A0A
              0A0A0A3D1B49AB00A5961A0A0A0A0A3D1B49AB00AAACAFAFAFAFAFAFAE1F9E08
              08080808461F7DABA8A6A10808080808461F7DAB00AAACAFAFAFAFAFAE1CA907
              07070707072C1C47959AA3A007070707072C1C47AB00AAACAFAFAFAFAE188E04
              040404040404521814948F9D040404040404521814AB1E19AFAFAFAFAE209C03
              03030303030303382087A79F030303030303033820879BA4AFAFAFAFAE219702
              020202020202020226215693020202020202020226215690AFAFAFAFAE1D8C01
              0101010101010101016B1DAE0101010101010101016B1DAEAFAFAFAFAEA28B05
              05050505050577744028828A0505050505057774402882ADAFAFAFAFAE8D9206
              0606060606896E7E687C1A060606060606896E7E687CADAFAFAFAFAFAE998009
              09090909725422862A98800909090909725422862AADAFAFAFAFAFAFAE23610B
              0B0B0B5527423C57AE23610B0B0B0B5527423C57ADAFAFAFAFAFAFAFAE676F0C
              0C0C4A33796488ADAE676F0C0C0C4A33796488ADAFAFAFAFAFAFAFAFAE244811
              117181847330ADAFAE244811117181847330ADAFAFAFAFAFAFAFAFAFAE3E8334
              453A7F6A59ADAFAFAE3E8334453A7F6A59ADAFAFAFAFAFAFAFAFAFAFAE2F414F
              7560585BADAFAFAFAE2F414F7560585BADAFAFAFAFAFAFAFAFAFAFAFAE293231
              4E5E65ADAFAFAFAFAE2932314E5E65ADAFAFAFAFAFAFAFAFAFAFAFAFAE852553
              2D5DADAFAFAFAFAFAE8525532D5DADAFAFAFAFAFAFAFAFAFAFAFAFAFAE35666C
              7BADAFAFAFAFAFAFAE35666C7BADAFAFAFAFAFAFAFAFAFAFAFAFAFAFAE7A135F
              ADAFAFAFAFAFAFAFAE7A135FADAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAE1363AD
              AFAFAFAFAFAFAFAFAE1363ADAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFADAEADAF
              AFAFAFAFAFAFAFAFADAEADAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF
              AFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF}
            Layout = blGlyphTop
            Margin = 20
          end
        end
      end
    end
    object grpSplitOption: TRzGroupBox
      Left = 553
      Top = 493
      Width = 409
      Height = 94
      Caption = 'BMP Split Option Setting'
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
      Visible = False
      object pnlHoriValue: TRzPanel
        Left = 0
        Top = 21
        Width = 288
        Height = 22
        BorderOuter = fsFlat
        BorderHighlight = clWhite
        BorderShadow = 6080734
        Caption = 'Horizontal Division Dummy Value'
        Color = 11855600
        FlatColorAdjustment = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        GradientColorStyle = gcsCustom
        GradientColorStop = clLime
        ParentFont = False
        TabOrder = 0
      end
      object edHorDmy: TRzNumericEdit
        Left = 290
        Top = 21
        Width = 110
        Height = 22
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        FrameController = RzFrameController1
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 1
        DisplayFormat = '0'
        Value = 32.000000000000000000
      end
      object pnlVertiValue: TRzPanel
        Left = 0
        Top = 45
        Width = 288
        Height = 22
        BorderOuter = fsFlat
        BorderHighlight = clWhite
        BorderShadow = 6080734
        Caption = 'Vertical Division Dummy Value'
        Color = 11855600
        FlatColorAdjustment = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        GradientColorStyle = gcsCustom
        GradientColorStop = clLime
        ParentFont = False
        TabOrder = 2
      end
      object edVerDmy: TRzNumericEdit
        Left = 290
        Top = 47
        Width = 110
        Height = 22
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        FrameController = RzFrameController1
        ImeName = 'Microsoft Office IME 2007'
        ParentFont = False
        TabOrder = 3
        DisplayFormat = '0'
        Value = 26.000000000000000000
      end
      object cboSplitBit: TRzComboBox
        Tag = 2
        Left = 290
        Top = 69
        Width = 110
        Height = 22
        Style = csDropDownList
        Ctl3D = False
        DropDownCount = 10
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        FrameController = RzFrameController1
        ImeName = 'Microsoft Office IME 2007'
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 4
        Text = '8 Bit Split'
        Items.Strings = (
          '8 Bit Split'
          '4 Bit Split')
        ItemIndex = 0
      end
      object pnlBitType: TRzPanel
        Left = 0
        Top = 69
        Width = 288
        Height = 22
        BorderOuter = fsFlat
        BorderHighlight = clWhite
        BorderShadow = 6080734
        Caption = 'Split Bit Type (VBy1)'
        Color = 11855600
        FlatColorAdjustment = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        GradientColorStyle = gcsCustom
        GradientColorStop = clLime
        ParentFont = False
        TabOrder = 5
      end
    end
    object grpBMPResolution: TRzGroupBox
      Left = 334
      Top = 441
      Width = 185
      Height = 65
      Caption = 'BMP Resolution'
      Font.Charset = ANSI_CHARSET
      Font.Color = 9856100
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Transparent = True
      Visible = False
      object cboResolution: TRzComboBox
        Tag = 2
        Left = 11
        Top = 27
        Width = 166
        Height = 22
        Ctl3D = False
        DropDownCount = 10
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        FrameController = RzFrameController1
        ImeName = 'Microsoft Office IME 2007'
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        OnChange = cboResolutionChange
      end
    end
  end
  object RzFrameController1: TRzFrameController
    ReadOnlyColor = clBtnFace
    FocusColor = clInfoBk
    FrameHotTrack = True
    FrameVisible = True
    FramingPreference = fpCustomFraming
    Left = 1042
    Top = 580
  end
end
