object PhiWobblePropView: TPhiWobblePropView
  Left = 742
  Top = 425
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Wobble Parameters'
  ClientHeight = 270
  ClientWidth = 365
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnHide = FormHide
  OnShow = FormShow
  DesignSize = (
    365
    270)
  PixelsPerInch = 96
  TextHeight = 16
  object WobbleGroupBox: TGroupBox
    Left = 0
    Top = 0
    Width = 364
    Height = 229
    Caption = 'Wobble Parameter'
    TabOrder = 0
    object DataCaption: TLabel
      Left = 146
      Top = 27
      Width = 29
      Height = 16
      Alignment = taRightJustify
      Caption = 'Data'
    end
    object WobbleModeCaption: TLabel
      Left = 82
      Top = 59
      Width = 51
      Height = 16
      Alignment = taRightJustify
      Caption = 'Wobble:'
    end
    object AmplitudeCaption: TLabel
      Left = 115
      Top = 99
      Width = 60
      Height = 16
      Alignment = taRightJustify
      Caption = 'Amplitude'
    end
    object WobbleAutoCaption: TLabel
      Left = 320
      Top = 59
      Width = 27
      Height = 16
      Caption = 'Auto'
    end
    object PeriodCaption: TLabel
      Left = 135
      Top = 131
      Width = 40
      Height = 16
      Alignment = taRightJustify
      Caption = 'Period'
    end
    object OffsetCaption: TLabel
      Left = 141
      Top = 195
      Width = 34
      Height = 16
      Alignment = taRightJustify
      Caption = 'Offset'
    end
    object NumberOfStepsCaption: TLabel
      Left = 105
      Top = 163
      Width = 70
      Height = 16
      Alignment = taRightJustify
      Caption = 'No of Steps'
    end
    object DataEdit: TRealEdit
      Left = 180
      Top = 24
      Width = 57
      Height = 25
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = ''
      Enabled = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      TabStop = True
      TabStops = True
      BackColor = clWindow
      ForeColor = clWindowText
      Minimum = -100.000000000000000000
      Maximum = 50.000000000000000000
      Increment = 1.000000000000000000
      Flashing = 0
      ControlWidth = 5
      SpinControl = False
      Justification = 1
      Precision = 2
      DefaultValue = 18.000000000000000000
      ReadOnly = True
      HorizontalArrows = False
      MouseWheelActive = True
      SkipChangedEventWhenSlew = False
      OnChanged = DataEditChanged
      DesignSize = (
        57
        25)
    end
    object AmplitudeEdit: TRealEdit
      Left = 180
      Top = 96
      Width = 57
      Height = 25
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = ''
      Enabled = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TabStop = True
      TabStops = True
      BackColor = clWindow
      ForeColor = clWindowText
      Minimum = -100.000000000000000000
      Maximum = 5500.000000000000000000
      Increment = 10.000000000000000000
      Flashing = 0
      ControlWidth = 5
      SpinControl = False
      Justification = 1
      Precision = 0
      ReadOnly = False
      HorizontalArrows = False
      MouseWheelActive = True
      SkipChangedEventWhenSlew = False
      OnChanged = AmplitudeEditChanged
      DesignSize = (
        57
        25)
    end
    object Panel2: TPanel
      Left = 140
      Top = 59
      Width = 145
      Height = 17
      BevelOuter = bvNone
      TabOrder = 2
      object WobbleOffRadio: TRadioButton
        Left = 72
        Top = 0
        Width = 53
        Height = 17
        Caption = 'Off'
        TabOrder = 0
        OnClick = WobbleOffRadioClick
      end
      object WobbleOnRadio: TRadioButton
        Left = 0
        Top = 0
        Width = 57
        Height = 17
        Caption = 'On'
        TabOrder = 1
        OnClick = WobbleOnRadioClick
      end
    end
    object WobbleAutoCheck: TCheckBox
      Left = 298
      Top = 59
      Width = 17
      Height = 17
      TabOrder = 3
      OnClick = WobbleAutoCheckClick
    end
    object Panel9: TPanel
      Left = 72
      Top = 85
      Width = 209
      Height = 2
      BevelOuter = bvLowered
      TabOrder = 4
    end
    object PeriodEdit: TRealEdit
      Left = 180
      Top = 128
      Width = 57
      Height = 25
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = ''
      Enabled = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      TabStop = True
      TabStops = True
      BackColor = clWindow
      ForeColor = clWindowText
      Minimum = -100.000000000000000000
      Maximum = 5500.000000000000000000
      Increment = 10.000000000000000000
      Flashing = 0
      ControlWidth = 5
      SpinControl = False
      Justification = 1
      Precision = 0
      ReadOnly = False
      HorizontalArrows = False
      MouseWheelActive = True
      SkipChangedEventWhenSlew = False
      OnChanged = PeriodEditChanged
      DesignSize = (
        57
        25)
    end
    object OffsetEdit: TRealEdit
      Left = 180
      Top = 192
      Width = 57
      Height = 25
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = ''
      Enabled = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      TabStop = True
      TabStops = True
      BackColor = clWindow
      ForeColor = clWindowText
      Minimum = -100.000000000000000000
      Maximum = 5500.000000000000000000
      Increment = 10.000000000000000000
      Flashing = 0
      ControlWidth = 5
      SpinControl = False
      Justification = 1
      Precision = 0
      ReadOnly = False
      HorizontalArrows = False
      MouseWheelActive = True
      SkipChangedEventWhenSlew = False
      OnChanged = OffsetEditChanged
      DesignSize = (
        57
        25)
    end
    object NumberOfStepsEdit: TRealEdit
      Left = 180
      Top = 160
      Width = 57
      Height = 25
      Alignment = taRightJustify
      BevelOuter = bvNone
      Caption = ''
      Enabled = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      TabStop = True
      TabStops = True
      BackColor = clWindow
      ForeColor = clWindowText
      Minimum = -100.000000000000000000
      Maximum = 5500.000000000000000000
      Increment = 10.000000000000000000
      Flashing = 0
      ControlWidth = 5
      SpinControl = False
      Justification = 1
      Precision = 0
      ReadOnly = False
      HorizontalArrows = False
      MouseWheelActive = True
      SkipChangedEventWhenSlew = False
      OnChanged = NumberOfStepsEditChanged
      DesignSize = (
        57
        25)
    end
  end
  object CloseButton: TButton
    Left = 272
    Top = 238
    Width = 93
    Height = 30
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    TabOrder = 1
    OnClick = CloseButtonClick
  end
  object WobblePopup: TPopupMenu
    OnPopup = WobblePopupPopup
    Left = 192
    Top = 240
    object StartWobbleItem: TMenuItem
      Caption = 'Start Wobble'
      OnClick = StartWobbleItemClick
    end
    object StopWobbleItem: TMenuItem
      Caption = 'Stop Wobble'
      Checked = True
      OnClick = StopWobbleItemClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object WobblePropertiesItem: TMenuItem
      Caption = 'Wobble Properties...'
      OnClick = WobblePropertiesItemClick
    end
  end
end
