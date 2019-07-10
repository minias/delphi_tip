object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'SFTP client demo'
  ClientHeight = 245
  ClientWidth = 579
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 212
    Top = 0
    Width = 367
    Height = 226
    Align = alRight
    Caption = 'Panel1'
    TabOrder = 0
    object lblCurDir: TLabel
      Left = 1
      Top = 1
      Width = 365
      Height = 13
      Align = alTop
      Caption = '::'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 6
    end
    object ListView1: TListView
      Left = 1
      Top = 14
      Width = 365
      Height = 211
      Align = alClient
      Columns = <
        item
          Caption = 'Name'
          Width = 150
        end
        item
          Caption = 'Type'
          Width = 60
        end
        item
          Alignment = taRightJustify
          Caption = 'Size (bytes)'
          Width = 80
        end
        item
          Caption = 'Date'
          Width = 150
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = ListView1DblClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 226
    Width = 579
    Height = 19
    Panels = <
      item
        Width = 600
      end
      item
        Width = 80
      end>
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 212
    Height = 226
    Align = alClient
    TabOrder = 2
    object edHost: TLabeledEdit
      Left = 8
      Top = 24
      Width = 91
      Height = 21
      EditLabel.Width = 26
      EditLabel.Height = 13
      EditLabel.Caption = 'Host:'
      TabOrder = 0
    end
    object edPort: TLabeledEdit
      Left = 105
      Top = 24
      Width = 42
      Height = 21
      EditLabel.Width = 24
      EditLabel.Height = 13
      EditLabel.Caption = 'Port:'
      TabOrder = 1
      Text = '22'
    end
    object edUser: TLabeledEdit
      Left = 8
      Top = 62
      Width = 91
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = 'Username:'
      TabOrder = 2
    end
    object edPass: TLabeledEdit
      Left = 105
      Top = 62
      Width = 91
      Height = 21
      EditLabel.Width = 50
      EditLabel.Height = 13
      EditLabel.Caption = 'Password:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      PasswordChar = #8226
      TabOrder = 3
    end
    object btn_AllDown: TButton
      Left = 105
      Top = 197
      Width = 91
      Height = 25
      Caption = 'All Down'
      TabOrder = 4
      OnClick = btn_AllDownClick
    end
    object edt_ServerDir: TLabeledEdit
      Left = 8
      Top = 107
      Width = 91
      Height = 21
      EditLabel.Width = 51
      EditLabel.Height = 13
      EditLabel.Caption = 'Server_Dir'
      TabOrder = 5
    end
    object btn_connect: TButton
      Left = 8
      Top = 197
      Width = 91
      Height = 25
      Caption = 'Connect'
      TabOrder = 6
      OnClick = btn_connectClick
    end
    object edt_ExeDir: TLabeledEdit
      Left = 8
      Top = 155
      Width = 91
      Height = 21
      EditLabel.Width = 34
      EditLabel.Height = 13
      EditLabel.Caption = 'Exe Dir'
      TabOrder = 7
      Text = '../Exec'
    end
    object edt_DllDir: TLabeledEdit
      Left = 105
      Top = 155
      Width = 91
      Height = 21
      EditLabel.Width = 33
      EditLabel.Height = 13
      EditLabel.Caption = 'DLL Dir'
      TabOrder = 8
      Text = '../DLL'
    end
  end
end
