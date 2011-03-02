object ResponseForm: TResponseForm
  Left = 355
  Top = 168
  Width = 254
  Height = 170
  Caption = 'Response'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Log: TMemo
    Left = 24
    Top = 8
    Width = 25
    Height = 25
    TabOrder = 3
    Visible = False
    WordWrap = False
  end
  object StartBtn: TButton
    Left = 24
    Top = 8
    Width = 201
    Height = 49
    Caption = 'Start Timer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = StartBtnClick
  end
  object Panel: TPanel
    Left = 32
    Top = 64
    Width = 185
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object MinsLbl: TLabel
      Left = 72
      Top = 5
      Width = 38
      Height = 20
      Alignment = taCenter
      Caption = 'Mins'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SecsLbl: TLabel
      Left = 136
      Top = 5
      Width = 41
      Height = 20
      Alignment = taCenter
      Caption = 'Secs'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object HrsLbl: TLabel
      Left = 16
      Top = 5
      Width = 29
      Height = 20
      Alignment = taCenter
      Caption = 'Hrs'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Seperator2Lbl: TLabel
      Left = 56
      Top = 5
      Width = 6
      Height = 20
      Caption = ':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Seperator1Lbl: TLabel
      Left = 120
      Top = 5
      Width = 6
      Height = 20
      Caption = ':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object ReturnBtn: TButton
    Left = 32
    Top = 104
    Width = 185
    Height = 25
    Caption = 'Stop Timer && Return'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = ReturnBtnClick
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 8
    Top = 8
  end
end
