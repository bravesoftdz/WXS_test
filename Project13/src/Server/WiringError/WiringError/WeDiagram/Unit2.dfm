object Form2: TForm2
  Left = 0
  Top = 0
  Width = 935
  Height = 596
  AutoScroll = True
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 927
    Height = 41
    Align = alTop
    TabOrder = 1
    object ComboBox1: TComboBox
      Left = 272
      Top = 8
      Width = 201
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = #19977#30456#19977#32447'CT'#31616#21270
      OnChange = ComboBox1Change
      Items.Strings = (
        #19977#30456#19977#32447'CT'#31616#21270)
    end
    object btn1: TButton
      Left = 488
      Top = 6
      Width = 75
      Height = 25
      Caption = #23454#38469#22823#23567
      TabOrder = 1
      OnClick = btn1Click
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 41
    Width = 233
    Height = 521
    Align = alLeft
    Caption = 'pnl1'
    TabOrder = 2
  end
  object ScrollBox1: TScrollBox
    Left = 233
    Top = 41
    Width = 694
    Height = 521
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    object img1: TImage32
      Left = 0
      Top = 0
      Width = 673
      Height = 497
      Bitmap.ResamplerClassName = 'TDraftResampler'
      BitmapAlign = baTopLeft
      Color = 16709869
      ParentColor = False
      Scale = 1.000000000000000000
      ScaleMode = smStretch
      TabOrder = 0
      TabStop = True
      OnMouseDown = img1MouseDown
      OnMouseMove = img1MouseMove
      OnMouseUp = img1MouseUp
      OnMouseWheelDown = img1MouseWheelDown
      OnMouseWheelUp = img1MouseWheelUp
      OnResize = img1Resize
    end
  end
end
