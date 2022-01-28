object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 217
  ClientWidth = 422
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
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 161
    Height = 25
    Caption = '1. OnSuccess with anonymous'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 39
    Width = 137
    Height = 25
    Caption = '2. OnFail with anonymous'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 70
    Width = 145
    Height = 25
    Caption = '3. Currying with anonymous'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 100
    Width = 137
    Height = 25
    Caption = '4. If you prefer, use bind'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 264
    Top = 8
    Width = 145
    Height = 25
    Caption = '1. OnSuccess with declared'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 264
    Top = 39
    Width = 137
    Height = 25
    Caption = '2. OnFail with anonymous'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 264
    Top = 70
    Width = 145
    Height = 25
    Caption = '3. Currying with anonymous'
    TabOrder = 6
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 264
    Top = 100
    Width = 137
    Height = 25
    Caption = '4. If you prefer, use bind'
    TabOrder = 7
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 128
    Top = 148
    Width = 137
    Height = 25
    Caption = 'Receiving a return'
    TabOrder = 8
    OnClick = Button9Click
  end
end
