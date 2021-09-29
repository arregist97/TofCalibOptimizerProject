inherited PhiAppTabWithOutputView: TPhiAppTabWithOutputView
  Left = 298
  Top = 278
  BorderStyle = bsSizeable
  BorderWidth = 6
  ClientHeight = 506
  ClientWidth = 849
  DefaultMonitor = dmActiveForm
  OldCreateOrder = True
  Position = poScreenCenter
  OnCanResize = FormCanResize
  OnClose = FormClose
  OnHide = FormHide
  OnShow = FormShow
  ExplicitWidth = 877
  ExplicitHeight = 556
  PixelsPerInch = 96
  TextHeight = 16
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 849
    Height = 506
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object RibbonSplitter: TSplitter
      Left = 179
      Top = 0
      Height = 469
      ExplicitLeft = 129
      ExplicitTop = 8
    end
    object ButtonPanel: TPanel
      Left = 0
      Top = 469
      Width = 849
      Height = 37
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        849
        37)
      object ShowDetailsButton: TSpeedButton
        Left = 0
        Top = 11
        Width = 24
        Height = 24
        Hint = 'Expanded Tab View'
        AllowAllUp = True
        GroupIndex = 1
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777777777777777777777777777777F007777777777777F0007777
          777777777F0007777777777777F0007777777777777F0007777777777777F000
          777777777777000F77777777777000F77777777777000F7777777777F000F777
          77777777F00F7777777777777FF7777777777777777777777777}
        ParentShowHint = False
        ShowHint = True
        OnClick = ShowDetailsButtonClick
      end
      object CloseButton: TButton
        Left = 749
        Top = 7
        Width = 100
        Height = 30
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = 'Close'
        TabOrder = 0
        OnClick = CloseButtonClick
      end
    end
    object TabControl: TTabControl
      Left = 469
      Top = 0
      Width = 380
      Height = 469
      Align = alRight
      RaggedRight = True
      TabHeight = 30
      TabOrder = 1
      OnChange = TabControlChange
      object TabPanel: TPanel
        Left = 4
        Top = 6
        Width = 372
        Height = 459
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 4
        ParentBackground = False
        TabOrder = 0
        object ApplicationPanel: TPanel
          Left = 4
          Top = 4
          Width = 364
          Height = 451
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
    end
    object OutputTabControl: TTabControl
      Left = 182
      Top = 0
      Width = 287
      Height = 469
      Align = alClient
      RaggedRight = True
      TabHeight = 30
      TabOrder = 2
      OnChange = OutputTabControlChange
      ExplicitLeft = 177
      ExplicitWidth = 292
      object OutputTabPanel: TPanel
        Left = 4
        Top = 6
        Width = 279
        Height = 459
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 4
        ParentBackground = False
        TabOrder = 0
        ExplicitWidth = 284
        object OutputPanel: TPanel
          Left = 4
          Top = 4
          Width = 271
          Height = 451
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 276
        end
      end
    end
    object RibbonTabControl: TTabControl
      Left = 9
      Top = 0
      Width = 170
      Height = 469
      Align = alLeft
      TabHeight = 30
      TabOrder = 3
      OnChange = RibbonTabControlChange
      object RibbonPanel: TPanel
        Left = 4
        Top = 6
        Width = 162
        Height = 459
        Align = alClient
        BevelOuter = bvNone
        Ctl3D = False
        ParentBackground = False
        ParentCtl3D = False
        TabOrder = 0
        ExplicitWidth = 157
      end
    end
    object ShowRibbonPanel: TPanel
      Left = 0
      Top = 0
      Width = 9
      Height = 469
      Hint = 'Tool Pallet'
      Align = alLeft
      BevelOuter = bvNone
      Caption = '>'
      Ctl3D = False
      ParentBackground = False
      ParentColor = True
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Visible = False
      OnClick = ShowRibbonPanelClick
    end
  end
end
