object TofCalibOptimizerView: TTofCalibOptimizerView
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'TofCalibOptimizerView'
  ClientHeight = 504
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 651
    Height = 504
    Align = alClient
    TabOrder = 0
    object ToolPanel: TPanel
      Left = 1
      Top = 1
      Width = 649
      Height = 33
      Align = alTop
      Caption = 'Tool Panel'
      TabOrder = 0
      object AddButton: TButton
        Left = 16
        Top = 4
        Width = 65
        Height = 25
        Hint = 'Add a text string to the log'
        Caption = 'Add'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = AddButtonClick
      end
    end
    object ProgressGroupBox: TGroupBox
      Left = 1
      Top = 34
      Width = 649
      Height = 469
      Align = alClient
      Caption = 'Progress Log'
      Ctl3D = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      object ProgressMemo: TMemo
        Left = 2
        Top = 18
        Width = 645
        Height = 449
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
        ExplicitLeft = 1
      end
    end
  end
end
