object PhiTunePropView: TPhiTunePropView
  Left = 742
  Top = 425
  BorderStyle = bsDialog
  BorderWidth = 6
  Caption = 'Tune Parameters'
  ClientHeight = 325
  ClientWidth = 358
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
    358
    325)
  PixelsPerInch = 96
  TextHeight = 16
  object TuneGroupBox: TGroupBox
    Left = -7
    Top = -8
    Width = 364
    Height = 297
    Caption = '.'
    TabOrder = 0
    object DataCaption: TLabel
      Left = 146
      Top = 27
      Width = 29
      Height = 16
      Alignment = taRightJustify
      Caption = 'Data'
    end
    object RangeCaption: TLabel
      Left = 134
      Top = 75
      Width = 41
      Height = 16
      Alignment = taRightJustify
      Caption = 'Range'
    end
    object ReadingFrequencyCaption: TLabel
      Left = 56
      Top = 139
      Width = 119
      Height = 16
      Alignment = taRightJustify
      Caption = 'Reading Frequency'
    end
    object StepSizeCaption: TLabel
      Left = 118
      Top = 107
      Width = 57
      Height = 16
      Alignment = taRightJustify
      Caption = 'Step Size'
    end
    object TuneButton: TSpeedButton
      Left = 72
      Top = 255
      Width = 120
      Height = 30
      Hint = 'Tune Supply'
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'Tune'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777770
        0007777777777777007777777777777700777777000007770077000000000777
        0077660FF000F77700776006FF0F6770000760FF0FFF077777776066F0F0F777
        777760FF0F0F0FF0707760F0F0F0FFF0F077606F0F6F0660F07760FFFF0FFFF0
        F07700FF00700FF0007770007777700077777777777777777777}
      ParentShowHint = False
      ShowHint = True
      OnClick = TuneButtonClick
    end
    object PlotButton: TSpeedButton
      Left = 198
      Top = 255
      Width = 120
      Height = 30
      Hint = 'Show Tuning Data in Plot'
      Caption = 'Plot...'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777770
        0007777777777777007777777777777700777777000007770077000000000777
        0077660FF000F77700776006FF0F6770000760FF0FFF077777776066F0F0F777
        777760FF0F0F0FF0707760F0F0F0FFF0F077606F0F6F0660F07760FFFF0FFFF0
        F07700FF00700FF0007770007777700077777777777777777777}
      ParentShowHint = False
      ShowHint = True
      OnClick = PlotButtonClick
    end
    object PeakMethodCaption: TLabel
      Left = 95
      Top = 171
      Width = 80
      Height = 16
      Alignment = taRightJustify
      Caption = 'Peak Method'
    end
    object AmmeterRangeCaption: TLabel
      Left = 50
      Top = 211
      Width = 124
      Height = 16
      Alignment = taRightJustify
      Caption = 'Picoammeter Range'
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
      DesignSize = (
        57
        25)
    end
    object RangeEdit: TRealEdit
      Left = 180
      Top = 72
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
      OnChanged = RangeEditChanged
      DesignSize = (
        57
        25)
    end
    object Panel9: TPanel
      Left = 72
      Top = 61
      Width = 209
      Height = 2
      BevelOuter = bvLowered
      TabOrder = 2
    end
    object ReadingFrequencyEdit: TRealEdit
      Left = 180
      Top = 136
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
      TabOrder = 3
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
      OnChanged = ReadingFrequencyEditChanged
      DesignSize = (
        57
        25)
    end
    object StepSizeEdit: TRealEdit
      Left = 180
      Top = 104
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
      TabOrder = 4
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
      OnChanged = StepSizeEditChanged
      DesignSize = (
        57
        25)
    end
    object Panel1: TPanel
      Left = 72
      Top = 241
      Width = 209
      Height = 2
      BevelOuter = bvLowered
      TabOrder = 5
    end
    object PeakMethodCombo: TComboBox
      Left = 180
      Top = 168
      Width = 135
      Height = 24
      Style = csDropDownList
      TabOrder = 6
      OnChange = PeakMethodComboChange
    end
    object Panel2: TPanel
      Left = 72
      Top = 200
      Width = 209
      Height = 2
      BevelOuter = bvLowered
      TabOrder = 7
    end
    object AmmeterRangeCombo: TComboBox
      Left = 180
      Top = 208
      Width = 100
      Height = 24
      Style = csDropDownList
      TabOrder = 8
      OnChange = AmmeterRangeComboChange
    end
  end
  object CloseButton: TButton
    Left = 265
    Top = 293
    Width = 93
    Height = 30
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Close'
    TabOrder = 1
    OnClick = CloseButtonClick
    ExplicitTop = 257
  end
  object TunePopup: TPopupMenu
    OnPopup = TunePopupPopup
    Left = 312
    Top = 88
    object StartTuningItem: TMenuItem
      Caption = 'Start Tuning'
      OnClick = StartTuningItemClick
    end
    object StopTuningItem: TMenuItem
      Caption = 'Stop Tuning'
      Checked = True
      OnClick = StopTuningItemClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object TunePropertiesItem: TMenuItem
      Caption = 'Tune Properties...'
      OnClick = TunePropertiesItemClick
    end
  end
end
