object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'gmail smtp send'
  ClientHeight = 461
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object edt_id: TLabeledEdit
    Left = 16
    Top = 24
    Width = 177
    Height = 21
    EditLabel.Width = 36
    EditLabel.Height = 13
    EditLabel.Caption = #50500#51060#46356' '
    TabOrder = 0
    Text = 'gnuhacker'
  end
  object edt_pw: TLabeledEdit
    Left = 224
    Top = 24
    Width = 177
    Height = 21
    DoubleBuffered = False
    EditLabel.Width = 47
    EditLabel.Height = 13
    EditLabel.Caption = #48708#48128#48264#54840' '
    ParentDoubleBuffered = False
    PasswordChar = '*'
    TabOrder = 1
  end
  object btn_Send: TButton
    Left = 16
    Top = 376
    Width = 385
    Height = 57
    Caption = #47700#51068' '#48156#49569' '
    TabOrder = 10
    OnClick = btn_SendClick
  end
  object edt_body: TRichEdit
    Left = 16
    Top = 224
    Width = 385
    Height = 97
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    Zoom = 100
  end
  object edt_subject: TLabeledEdit
    Left = 16
    Top = 197
    Width = 385
    Height = 21
    EditLabel.Width = 22
    EditLabel.Height = 13
    EditLabel.Caption = #51228#47785
    TabOrder = 7
  end
  object ed_file: TLabeledEdit
    Left = 16
    Top = 349
    Width = 385
    Height = 21
    EditLabel.Width = 44
    EditLabel.Height = 13
    EditLabel.Caption = #52392#48512#54028#51068
    TabOrder = 9
    OnDblClick = ed_fileDblClick
  end
  object mStatus: TRichEdit
    Left = 432
    Top = 24
    Width = 354
    Height = 409
    Font.Charset = HANGEUL_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 11
    Zoom = 100
  end
  object edt_from_name: TLabeledEdit
    Left = 16
    Top = 64
    Width = 177
    Height = 21
    EditLabel.Width = 44
    EditLabel.Height = 13
    EditLabel.Caption = #48156#49888#51088#47749
    TabOrder = 2
    Text = #51060#52285#48124
  end
  object edt_to: TLabeledEdit
    Left = 16
    Top = 107
    Width = 385
    Height = 21
    EditLabel.Width = 44
    EditLabel.Height = 13
    EditLabel.Caption = #48155#51012#47700#51068
    TabOrder = 4
    Text = 'gnuhacker@gmail.com;ljh1942@empal.com'
  end
  object edt_cc: TLabeledEdit
    Left = 16
    Top = 152
    Width = 177
    Height = 21
    EditLabel.Width = 47
    EditLabel.Height = 13
    EditLabel.Caption = #52280#51312'[CC] '
    TabOrder = 5
  end
  object edt_bcc: TLabeledEdit
    Left = 224
    Top = 152
    Width = 177
    Height = 21
    EditLabel.Width = 75
    EditLabel.Height = 13
    EditLabel.Caption = #49704#51008#52280#51312'[BCC] '
    TabOrder = 6
  end
  object edt_from: TLabeledEdit
    Left = 224
    Top = 64
    Width = 177
    Height = 21
    EditLabel.Width = 44
    EditLabel.Height = 13
    EditLabel.Caption = #48156#49888#47700#51068
    TabOrder = 3
    Text = 'gnuhacker@gmail.com'
  end
  object MSG: TIdMessage
    AttachmentEncoding = 'MIME'
    BccList = <>
    CharSet = 'UTF-8'
    CCList = <>
    Encoding = meMIME
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 720
    Top = 56
  end
  object SMTP: TIdSMTP
    IOHandler = IO_OpenSSL
    Host = 'smtp.gmail.com'
    Port = 465
    SASLMechanisms = <>
    UseTLS = utUseImplicitTLS
    Left = 720
    Top = 112
  end
  object IO_OpenSSL: TIdSSLIOHandlerSocketOpenSSL
    Destination = 'smtp.gmail.com:465'
    Host = 'smtp.gmail.com'
    MaxLineAction = maException
    Port = 465
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 720
    Top = 9
  end
  object OD_FILE: TOpenDialog
    Left = 720
    Top = 168
  end
end
