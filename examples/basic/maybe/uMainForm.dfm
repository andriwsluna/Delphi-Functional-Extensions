object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 245
  ClientWidth = 553
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 15
  object ButtonGetPersonWithAnonimous: TButton
    Left = 8
    Top = 8
    Width = 209
    Height = 25
    Caption = '1. Maybe OnSome with Anonymous'
    TabOrder = 0
    OnClick = ButtonGetPersonWithAnonimousClick
  end
  object Button1: TButton
    Left = 8
    Top = 39
    Width = 209
    Height = 25
    Caption = '2. Maybe OnNone with Anonymous'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 70
    Width = 193
    Height = 25
    Caption = '3. Currying OnSome and OnNone'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 101
    Width = 143
    Height = 25
    Caption = '4. If you prefer, use bind'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 328
    Top = 39
    Width = 185
    Height = 25
    Caption = '2. Maybe OnNone with Declared'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 328
    Top = 8
    Width = 185
    Height = 25
    Caption = '1. Maybe OnSome with Declared'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 328
    Top = 70
    Width = 193
    Height = 25
    Caption = '3. Currying OnSome and OnNone'
    TabOrder = 6
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 328
    Top = 101
    Width = 143
    Height = 25
    Caption = '4. If you prefer, use bind'
    TabOrder = 7
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 160
    Top = 152
    Width = 185
    Height = 25
    Caption = 'Receiving a boolean'
    TabOrder = 8
    OnClick = Button8Click
  end
end
