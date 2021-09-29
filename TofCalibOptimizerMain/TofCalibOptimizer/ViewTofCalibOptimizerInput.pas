unit ViewTofCalibOptimizerInput;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ViewTofCalibOptimizerInput.pas
// Created:   8/1/2021
// Purpose:   This module contains the view class for the TofCalibOptimizerInput.
//
//*********************************************************
////////////////////////////////////////////////////////////////////////////////

interface

uses
  Vcl.Buttons,
  System.Classes,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Menus,
  Winapi.Messages,
  System.SysUtils,
  Vcl.StdCtrls,
  System.Variants,
  ViewPhi,
  Winapi.Windows;

type
  TTofCalibOptimizerInputView = class(TPhiView)
    MainPanel: TPanel;
    FullListPanel: TPanel;
    FullListSearchGroupBox: TGroupBox;
    TopPanel: TPanel;
    GroupBox1: TGroupBox;
    FullListNotFoundLabel: TLabel;
    OpenCsvFileButton: TSpeedButton;
    AddStringButton: TSpeedButton;
    FontSizeComboBox: TComboBox;
    FontSizeCaption: TLabel;
    IsTextBoldCaption: TLabel;
    IsTextItalicCaption: TLabel;
    IsTextBoldCheck: TCheckBox;
    IsTextItalicCheck: TCheckBox;
    OpenDialog1: TOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure OpenCsvFileButtonClick(Sender: TObject);
    procedure AddStringButtonClick(Sender: TObject);

  private
    procedure OnUpdateTofCalibOptimizer(Hint: Integer);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy(); override;
    procedure OnUpdate(Name: String; Hint: Integer); override;
  end;

var
  g_TofCalibOptimizerInputView: TTofCalibOptimizerInputView;

implementation

{$R *.dfm}

uses
  DocTofCalibOptimizer;

// Create
constructor TTofCalibOptimizerInputView.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  if assigned(g_TofCalibOptimizerDoc) then
    g_TofCalibOptimizerDoc.AddView(Self);
end;

// Destroy
destructor TTofCalibOptimizerInputView.Destroy;
begin
  try
    if (assigned(g_TofCalibOptimizerDoc)) then
      g_TofCalibOptimizerDoc.RemoveView(Self);

    inherited;
  except
  end;
end;

// FormShow
procedure TTofCalibOptimizerInputView.FormShow(Sender: TObject);
begin
  OnShow := nil;

  try
    // Update application (Note: Must disable/enable callbacks
    OnUpdateChange := True;
    OnUpdateTofCalibOptimizer(ord(TofCalibOptimizerOnUpdateAll));
  finally
    // Always reset OnUpdateChange to False
    OnUpdateChange := False;
  end;
end;

// OnUpdate
procedure TTofCalibOptimizerInputView.OnUpdate(Name: String; Hint: Integer);
begin
  if (Name = c_TofCalibOptimizer) then
    OnUpdateTofCalibOptimizer(Hint);
end;

// OnUpdateTofCalibOptimizer
procedure TTofCalibOptimizerInputView.OnUpdateTofCalibOptimizer(Hint: Integer);
begin
  inherited OnUpdate(Hint);

  if not Visible then
    Exit;
  if not assigned(g_TofCalibOptimizerDoc) then
    Exit;

  if (Hint = Ord(TofCalibOptimizerOnUpdateAll)) then
  begin
    g_TofCalibOptimizerDoc.IsTextBold.ToCheckBox(IsTextBoldCheck);
    g_TofCalibOptimizerDoc.IsTextBold.ToCaption(IsTextBoldCaption);

    //Update other g_TofCalibOptimizerDoc things (if any on this view) below

  end;
end;

// RefreshOnceButtonClick
procedure TTofCalibOptimizerInputView.OpenCsvFileButtonClick(Sender: TObject);
var
  newFileName: String;
begin
  if (OnUpdateChange) then
    Exit;
  opendialog1.Execute();
  newFileName := opendialog1.FileName;

//Implement Me!
//  g_TofCalibOptimizerDoc.

end;

// AddStringButtonClick
procedure TTofCalibOptimizerInputView.AddStringButtonClick(Sender: TObject);
begin
  if (OnUpdateChange) then
    Exit;

//Implement Me!
//  g_TofCalibOptimizerDoc.
end;

end.
