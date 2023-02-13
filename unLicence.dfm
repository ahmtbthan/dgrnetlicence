object frmLicence: TfrmLicence
  Left = 0
  Top = 0
  Caption = 'Lisans Kontrol'
  ClientHeight = 162
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbKontrol: TLabel
    Left = 0
    Top = 82
    Width = 399
    Height = 33
    Align = alBottom
    Alignment = taCenter
    Caption = 'Lisans Kontrol Ediliyor...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 284
  end
  object lbKod: TLabel
    Left = 288
    Top = 8
    Width = 60
    Height = 13
    Caption = 'Lisans Kodu:'
  end
  object Memo1: TMemo
    Left = 0
    Top = -4
    Width = 185
    Height = 77
    TabOrder = 1
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 115
    Width = 399
    Height = 47
    Align = alBottom
    Max = 1000
    Step = 5
    TabOrder = 2
  end
  object etVeritabanı: TButton
    Left = 191
    Top = 36
    Width = 82
    Height = 35
    Caption = 'Veritaban'#305' '#304'le Sorgula'
    TabOrder = 3
    WordWrap = True
    OnClick = etVeritabanıClick
  end
  object eCompany: TEdit
    Left = 288
    Top = 23
    Width = 103
    Height = 21
    Alignment = taCenter
    TabOrder = 0
    Text = '11111'
  end
  object etManuel: TButton
    Left = 288
    Top = 46
    Width = 103
    Height = 25
    Caption = 'EditText '#304'le Sorgula'
    TabOrder = 4
    OnClick = etManuelClick
  end
  object Db: TUniConnection
    ProviderName = 'PostgreSQL'
    Port = 5432
    Database = 'lisans'
    Username = 'postgres'
    Server = '127.0.0.1'
    Left = 192
    EncryptedPassword = 'CEFFCDFFCCFFCBFFCAFFC9FFC8FFC7FFC6FF'
  end
  object Provider: TPostgreSQLUniProvider
    Left = 224
  end
  object qLicence: TUniQuery
    Connection = Db
    SQL.Strings = (
      'select * from sys_licence')
    Left = 256
  end
end
