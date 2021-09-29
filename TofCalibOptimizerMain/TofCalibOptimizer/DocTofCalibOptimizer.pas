unit DocTofCalibOptimizer;
////////////////////////////////////////////////////////////////////////////////
// Filename:  DocTofCalibOptimizer.pas
// Created:   8/1/2021
// Purpose:   This module contains the doc class for the TofCalibOptimizer.
//
//*********************************************************
////////////////////////////////////////////////////////////////////////////////

interface

uses
  System.Classes,
  ComCtrls,
  Dialogs,
  DocPhi,
  VCL.Forms,
  IniFiles,
  Parameter,
  ParameterBoolean,
  ParameterSelectData,
  ParameterString,
  Vcl.StdCtrls,
  System.SysUtils,
  System.UITypes;

const
  c_TofCalibOptimizer = 'TofCalibOptimizer';
  c_FontSize_8 = '8';
  c_FontSize_10 = '10';
  c_FontSize_12 = '12';
  c_FontSize_14 = '14';

type
  TTofCalibOptimizerOnUpdate = (TofCalibOptimizerOnUpdateAll,TofCalibOptimizerOnUpdateProgressString);

  TTofCalibOptimizerDoc = class(TPhiDoc)
  private
    FProgressString: TParameterString; //This string is intended to be shown on a TMemo
    FFontSize: TParameterSelectData;   //This is intended to set the font size of a TMemo
    FIsTextBold: TParameterBoolean;    //This is intended to set the font bold of a TMemo

    FFileName: String;
    FOpenFileDialog: TOpenDialog;
    FSaveFileDialog: TSaveDialog;

  public
    constructor Create(AOwner: TComponent; DocName: String = c_TofCalibOptimizer); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure DeInitialize; override;

    procedure OpenFileDialog;
    procedure SaveAsFileDialog;
    procedure LoadFile;

    property  ProgressString: TParameterString read FProgressString;
    procedure SetProgressString(Value: String);

    property FontSize: TParameterSelectData read FFontSize;
    procedure SetFontSize(Value: String);

    property IsTextBold: TParameterBoolean read FIsTextBold;
    procedure SetIsTextBold(Value: Boolean);

  end;

var
  g_TofCalibOptimizerDoc: TTofCalibOptimizerDoc;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Vcl.Controls,
  Main,
  Winapi.Messages,
  ObjectPhi,
  System.StrUtils,
  Winapi.Windows;

// Create
constructor TTofCalibOptimizerDoc.Create(AOwner: TComponent; DocName: String);
begin
  inherited Create(AOwner, DocName);

  FOpenFileDialog := nil;
  FSaveFileDialog := nil;

  // Create the TParameter objects.
  FProgressString := TParameterString.Create(Self);
  FProgressString.Name := 'ProgressString';
  FProgressString.Caption := 'Progress';
  FProgressString.Hint := 'Optimizer Progress Log';
  FProgressString.Value := 'This is an example of the progress text' + slinebreak + 'NumPeaks: 989; NumMatched: 300; NumPeaksInNPZ: 12;';
  FProgressString.ParameterType := ptNone;
  AddParameter(FProgressString);

  FFontSize := TParameterSelectData.Create(Self);
  FFontSize.Name := 'FontSize';
  FFontSize.AddValue(c_FontSize_8);
  FFontSize.AddValue(c_FontSize_10);
  FFontSize.AddValue(c_FontSize_12);
  FFontSize.AddValue(c_FontSize_14);
  FFontSize.Value:= c_FontSize_8;
  FFontSize.ParameterType := ptProperties;
  AddParameter(FFontSize);

  FIsTextBold := TParameterBoolean.Create(Self);
  FIsTextBold.Name := 'IsTextBold';
  FIsTextBold.Caption := 'Bold Text';
  FIsTextBold.Hint := 'Set bold property of font';
  FIsTextBold.Value := False;
  FIsTextBold.ParameterType := ptNone;
  AddParameter(FIsTextBold);

  FFileName := '';

  // Initialize the settings.
  InitializeSettings;
end;

// Destroy
destructor TTofCalibOptimizerDoc.Destroy;
begin
  inherited;
end;

// Initialize
procedure TTofCalibOptimizerDoc.Initialize;
begin
  inherited;
  //Init things here if necessary
end;

// DeInitialize
procedure TTofCalibOptimizerDoc.DeInitialize;
begin
  inherited;
  //DeInit things here if necessary
end;

// OpenFileDialog
procedure TTofCalibOptimizerDoc.OpenFileDialog;
begin
  // Create the Open File Dialog if not already created.
  if not assigned(FOpenFileDialog) then
  begin
    // Create the Open dialog.
    FOpenFileDialog := TOpenDialog.Create(Self);
    FOpenFileDialog.Title := 'Open System Log File';
    FOpenFileDialog.Options := [ofHideReadOnly, ofPathMustExist];
    FOpenFileDialog.FileName:= '*.log';
    FOpenFileDialog.DefaultExt:= '*.log';

    // Set up filters for .log files.
    FOpenFileDialog.Filter := 'System Log (*.log)|*.log|All Files (*.*)|*.*';
    FOpenFileDialog.FilterIndex := 1;
  end;

  // Show the dialog
  if (FOpenFileDialog.Execute) then
  begin
    // Save the file name.
    FFileName := FOpenFileDialog.FileName;

    // Open the file.
    LoadFile;
  end;
end;

// SaveAsFileDialog
procedure TTofCalibOptimizerDoc.SaveAsFileDialog;
begin
  // Create the Save File Dialog if not already created.
  if not assigned(FSaveFileDialog) then
  begin
    // Create the Open dialog.
    FSaveFileDialog := TSaveDialog.Create(Self);
  end;

  FSaveFileDialog.FileName := '';
  FSaveFileDialog.Title := 'Save Text File As';

  // Show the dialog
  if (FSaveFileDialog.Execute) then
  begin
      // Save the file.
  end;
end;

// LoadFile
procedure TTofCalibOptimizerDoc.LoadFile;
var
  fileStream: TFileStream;
begin
  // Check for an invalid system file name.
  if FFileName = '' then
    exit;

  // Set screen cursor to hourglass, and disable UI updates.
  Screen.Cursor := m_CursorWait;
  UpdateEnable := False;
  try

    // Read the file

  finally
    // Restore screen cursor, and enable UI updates.
    Screen.Cursor := m_CursorNormal;
    UpdateEnable := True;
  end;

  // Update the UI.
  UpdateAllViews(Ord(TofCalibOptimizerOnUpdateAll));
end;

// SetProgressString
procedure TTofCalibOptimizerDoc.SetProgressString(Value: String);
begin
  // Save the value.
  FProgressString.Value := Value;

  // Update the UI.
  UpdateAllViews(Ord(TofCalibOptimizerOnUpdateProgressString));
end;

// SetIsTextBold
procedure TTofCalibOptimizerDoc.SetIsTextBold(Value: Boolean);
begin
  // Save the value.
  FIsTextBold.Value := Value;

  // Update the UI.
  UpdateAllViews(Ord(TofCalibOptimizerOnUpdateAll));
end;

// SetFontSize
procedure TTofCalibOptimizerDoc.SetFontSize(Value: String);
begin
  // Save the value.
  FFontSize.Value := Value;

  // Update the UI.
  UpdateAllViews(Ord(TofCalibOptimizerOnUpdateAll));
end;


end.
