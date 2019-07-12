object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 544
  ClientWidth = 1104
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ScreenSnap = True
  OnCreate = FormCreate
  OnDragDrop = FormDragDrop
  OnMouseActivate = FormMouseActivate
  OnMouseMove = FormMouseMove
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SB: TStatusBar
    Left = 0
    Top = 525
    Width = 1104
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 140
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Alignment = taRightJustify
        Width = 50
      end>
  end
  object pnl_body: TPanel
    Left = 0
    Top = 39
    Width = 1104
    Height = 486
    Align = alClient
    TabOrder = 1
    object Splitter2: TSplitter
      AlignWithMargins = True
      Left = 314
      Top = 4
      Width = 2
      Height = 478
      Beveled = True
      ExplicitLeft = 309
      ExplicitTop = 1
      ExplicitHeight = 484
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 310
      Height = 484
      Align = alLeft
      Caption = 'Panel1'
      TabOrder = 0
      object Splitter1: TSplitter
        AlignWithMargins = True
        Left = 152
        Top = 4
        Height = 476
        Beveled = True
        ExplicitLeft = 85
        ExplicitTop = -3
        ExplicitHeight = 482
      end
      object FileListBox1: TFileListBox
        Left = 158
        Top = 1
        Width = 156
        Height = 482
        Align = alLeft
        ItemHeight = 13
        TabOrder = 0
        OnChange = FileListBox1Change
      end
      object dirlistbox: TDirectoryListBox
        Left = 1
        Top = 1
        Width = 148
        Height = 482
        Align = alLeft
        TabOrder = 1
        OnChange = dirlistboxChange
      end
    end
    object Panel2: TPanel
      Left = 319
      Top = 1
      Width = 784
      Height = 484
      Align = alClient
      TabOrder = 1
      object BeforFile: TSynMemo
        AlignWithMargins = True
        Left = 4
        Top = 102
        Width = 776
        Height = 378
        SingleLineMode = False
        Align = alClient
        ActiveLineColor = clSkyBlue
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #45208#45588#44256#46357#53076#46377
        Font.Pitch = fpFixed
        Font.Style = []
        TabOrder = 0
        CodeFolding.GutterShapeSize = 11
        CodeFolding.CollapsedLineColor = clGrayText
        CodeFolding.FolderBarLinesColor = clGrayText
        CodeFolding.IndentGuidesColor = clGray
        CodeFolding.IndentGuides = True
        CodeFolding.ShowCollapsedLine = True
        CodeFolding.ShowHintMark = True
        UseCodeFolding = False
        ExtraLineSpacing = 2
        Gutter.AutoSize = True
        Gutter.BorderStyle = gbsNone
        Gutter.Cursor = crHandPoint
        Gutter.DigitCount = 8
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.LeftOffset = 4
        Gutter.ShowLineNumbers = True
        Gutter.Width = 40
        Gutter.GradientEndColor = clBtnShadow
        Gutter.GradientSteps = 20
        HideSelection = True
        Highlighter = SynHTMLSyn1
        TabWidth = 4
        FontSmoothing = fsmClearType
        ExplicitLeft = 2
        ExplicitWidth = 782
        ExplicitHeight = 384
      end
      object AddFile: TSynMemo
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 776
        Height = 92
        SingleLineMode = False
        Align = alTop
        Anchors = [akLeft, akTop, akRight, akBottom]
        ActiveLineColor = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #45208#45588#44256#46357#53076#46377
        Font.Pitch = fpFixed
        Font.Style = []
        TabOrder = 1
        CodeFolding.GutterShapeSize = 11
        CodeFolding.CollapsedLineColor = clGrayText
        CodeFolding.FolderBarLinesColor = clGrayText
        CodeFolding.IndentGuidesColor = clGray
        CodeFolding.IndentGuides = True
        CodeFolding.ShowCollapsedLine = True
        CodeFolding.ShowHintMark = True
        UseCodeFolding = False
        ExtraLineSpacing = 2
        Gutter.AutoSize = True
        Gutter.BorderStyle = gbsNone
        Gutter.Cursor = crHandPoint
        Gutter.DigitCount = 8
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Gutter.LeftOffset = 4
        Gutter.ShowLineNumbers = True
        Gutter.Width = 40
        Gutter.GradientEndColor = clBtnShadow
        Gutter.GradientSteps = 20
        HideSelection = True
        Highlighter = SynVBScriptSyn1
        Lines.Strings = (
          '<% '#39'// CASTLE - KISA Web Attack Defense Tool'
          'Application("CASTLE_ASP_VERSION_BASE_DIR") = "/castle-asp"'
          
            'Server.Execute(Application("CASTLE_ASP_VERSION_BASE_DIR") & "/ca' +
            'stle_referee.asp")'
          '%>')
        TabWidth = 4
        FontSmoothing = fsmClearType
      end
    end
  end
  object pnl_head: TPanel
    Left = 0
    Top = 0
    Width = 1104
    Height = 39
    Align = alTop
    TabOrder = 2
    object edt_dir: TLabeledEdit
      Left = 77
      Top = 8
      Width = 414
      Height = 21
      DoubleBuffered = True
      EditLabel.Width = 47
      EditLabel.Height = 13
      EditLabel.Caption = #46356#47113#53664#47532' '
      EditLabel.Layout = tlCenter
      LabelPosition = lpLeft
      ParentDoubleBuffered = False
      TabOrder = 0
    end
    object edt_ext: TLabeledEdit
      Left = 548
      Top = 8
      Width = 50
      Height = 21
      DoubleBuffered = True
      EditLabel.Width = 36
      EditLabel.Height = 13
      EditLabel.Caption = #54869#51109#51088' '
      EditLabel.Layout = tlCenter
      LabelPosition = lpLeft
      ParentDoubleBuffered = False
      TabOrder = 1
      Text = '*.asp'
      OnChange = edt_extChange
    end
  end
  object SynVBScriptSyn1: TSynVBScriptSyn
    DefaultFilter = 'VBScript Files (*.asp)|*.asp'
    Options.AutoDetectEnabled = True
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    CommentAttri.Foreground = 4227072
    CommentAttri.Style = [fsBold, fsItalic]
    KeyAttri.Foreground = clRed
    NumberAttri.Foreground = clRed
    StringAttri.Style = [fsBold]
    SymbolAttri.Foreground = clHotLight
    SymbolAttri.Style = [fsBold]
    Left = 350
    Top = 165
  end
  object SynVBSyn1: TSynVBSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 348
    Top = 271
  end
  object SynHTMLSyn1: TSynHTMLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    CommentAttri.Foreground = clGreen
    CommentAttri.Style = [fsBold, fsItalic]
    KeyAttri.Foreground = clMaroon
    Left = 347
    Top = 220
  end
  object SynPasSyn1: TSynPasSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 535
    Top = 167
  end
end
