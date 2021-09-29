object TofCalibOptimizerInputView: TTofCalibOptimizerInputView
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'TofCalibOptimizerInputView'
  ClientHeight = 654
  ClientWidth = 193
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
    Width = 193
    Height = 489
    Align = alTop
    TabOrder = 0
    object FullListPanel: TPanel
      Left = 1
      Top = 162
      Width = 191
      Height = 328
      Align = alTop
      TabOrder = 0
      object AddStringButton: TSpeedButton
        Left = 23
        Top = 140
        Width = 142
        Height = 30
        Hint = 'Refresh the display.'
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Add String'
        ParentShowHint = False
        ShowHint = True
        OnClick = AddStringButtonClick
      end
      object FontSizeCaption: TLabel
        Left = 32
        Top = 200
        Width = 45
        Height = 13
        Caption = 'FontSize:'
      end
      object IsTextBoldCaption: TLabel
        Left = 56
        Top = 256
        Width = 45
        Height = 13
        Caption = 'Bold Text'
      end
      object IsTextItalicCaption: TLabel
        Left = 56
        Top = 280
        Width = 48
        Height = 13
        Caption = 'Italic Text'
      end
      object FullListSearchGroupBox: TGroupBox
        Left = 1
        Top = 1
        Width = 189
        Height = 104
        Align = alTop
        Caption = 'Search'
        TabOrder = 0
        object FullListNotFoundLabel: TLabel
          Left = 59
          Top = 79
          Width = 74
          Height = 19
          Caption = 'Not Found'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
      end
      object FontSizeComboBox: TComboBox
        Left = 32
        Top = 216
        Width = 121
        Height = 21
        ItemIndex = 0
        TabOrder = 1
        Text = 'example1'
        Items.Strings = (
          'example1'
          'example2')
      end
      object IsTextBoldCheck: TCheckBox
        Left = 32
        Top = 255
        Width = 16
        Height = 17
        TabOrder = 2
      end
      object IsTextItalicCheck: TCheckBox
        Left = 32
        Top = 279
        Width = 16
        Height = 17
        TabOrder = 3
      end
    end
    object TopPanel: TPanel
      Left = 1
      Top = 1
      Width = 191
      Height = 161
      Align = alTop
      TabOrder = 1
      object GroupBox1: TGroupBox
        Left = 1
        Top = 1
        Width = 189
        Height = 159
        Align = alClient
        TabOrder = 0
        object OpenCsvFileButton: TSpeedButton
          Left = 10
          Top = 12
          Width = 142
          Height = 30
          Hint = 'Refresh the display.'
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Open Csv File'
          ParentShowHint = False
          ShowHint = True
          OnClick = OpenCsvFileButtonClick
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 66
    Top = 99
  end
end
