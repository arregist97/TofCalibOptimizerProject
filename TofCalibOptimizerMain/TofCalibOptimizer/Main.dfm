inherited MainView: TMainView
  Left = 343
  Top = 154
  BorderStyle = bsSizeable
  Caption = 'TOF Calib Optimizer'
  ClientHeight = 634
  ClientWidth = 1384
  Constraints.MinHeight = 475
  Constraints.MinWidth = 575
  DefaultMonitor = dmMainForm
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 1400
  ExplicitHeight = 693
  PixelsPerInch = 96
  TextHeight = 16
  object OutputPanel: TPanel
    Left = 24
    Top = 72
    Width = 1072
    Height = 505
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object InputPanel: TPanel
    Left = 1168
    Top = 0
    Width = 216
    Height = 607
    Align = alRight
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
  end
  object StatusLinePanel: TPanel
    Left = 0
    Top = 607
    Width = 1384
    Height = 27
    Align = alBottom
    BorderWidth = 1
    BorderStyle = bsSingle
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    ExplicitTop = 613
    object CurrentFolderCaption: TLabel
      Left = 16
      Top = 5
      Width = 87
      Height = 16
      Caption = 'Current Folder:'
    end
    object CurrentFolderLabel: TLabel
      Left = 112
      Top = 5
      Width = 84
      Height = 16
      Caption = 'C:\Update-Me'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object MainMenu: TMainMenu
    Left = 24
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object OpenItem: TMenuItem
        Caption = '&Open...'
        OnClick = OpenItemClick
      end
      object SaveAsItem: TMenuItem
        Caption = 'Save As...'
        OnClick = SaveAsItemClick
      end
      object ExitItem: TMenuItem
        Caption = 'E&xit'
        OnClick = ExitItemClick
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object FontSizeItem: TMenuItem
        Caption = 'Font Size'
        object FontSize8Item: TMenuItem
          Caption = '8'
          OnClick = FontSizeItemClick
        end
        object FontSize10Item: TMenuItem
          Caption = '10'
          OnClick = FontSizeItemClick
        end
        object FontSize12Item: TMenuItem
          Caption = '12'
          OnClick = FontSizeItemClick
        end
        object FontSize14Item: TMenuItem
          Caption = '14'
          OnClick = FontSizeItemClick
        end
      end
      object IsTextBoldItem: TMenuItem
        Caption = 'Bold Text'
        OnClick = IsTextBoldItemClick
      end
    end
  end
end
