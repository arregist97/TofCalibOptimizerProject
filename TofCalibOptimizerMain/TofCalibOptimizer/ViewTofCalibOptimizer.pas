unit ViewTofCalibOptimizer;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ViewTofCalibOptimizer.pas
// Created:   8/1/2021
// Purpose:   This module contains the view class for the TofCalibOptimizer.
//
//*********************************************************
////////////////////////////////////////////////////////////////////////////////

interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Winapi.Messages,
  Vcl.StdCtrls,
  System.SysUtils,
  System.Variants,
  ViewPhi,
  Winapi.Windows;

type
  TTofCalibOptimizerView = class(TPhiView)
    MainPanel: TPanel;
    ToolPanel: TPanel;
    ProgressGroupBox: TGroupBox;
    ProgressMemo: TMemo;
    AddButton: TButton;
    procedure FormShow(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
  private
    procedure OnUpdateTofCalibOptimizer(Hint: Integer);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy(); override;
    procedure OnUpdate(Name: String; Hint: Integer); override;
  end;

var
  g_TofCalibOptimizerView: TTofCalibOptimizerView;

implementation

{$R *.dfm}

uses
  DocTofCalibOptimizer;

// Create
constructor TTofCalibOptimizerView.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  if assigned(g_TofCalibOptimizerDoc) then
    g_TofCalibOptimizerDoc.AddView(Self);
end;

// Destroy
destructor TTofCalibOptimizerView.Destroy;
begin
  try
    if (assigned(g_TofCalibOptimizerDoc)) then
      g_TofCalibOptimizerDoc.RemoveView(Self);

    inherited;
  except
  end;
end;

// FormShow
procedure TTofCalibOptimizerView.FormShow(Sender: TObject);
begin
  OnShow := nil;
//  g_TofCalibOptimizerDoc.FullListMemo.Parent := MainPanel;

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
procedure TTofCalibOptimizerView.OnUpdate(Name: String; Hint: Integer);
begin
  if (Name = c_TofCalibOptimizer) then
    OnUpdateTofCalibOptimizer(Hint);
end;

// OnUpdateTofCalibOptimizer
procedure TTofCalibOptimizerView.OnUpdateTofCalibOptimizer(Hint: Integer);
begin
  inherited OnUpdate(Hint);

  if not Visible then
    Exit;
  if not assigned(g_TofCalibOptimizerDoc) then
    Exit;

  if (Hint = Ord(TofCalibOptimizerOnUpdateProgressString)) or
     (Hint = Ord(TofCalibOptimizerOnUpdateAll)) then
  begin
    //Update the TMemo
    g_TofCalibOptimizerDoc.ProgressString.ToMemo(ProgressMemo);
  end;

  if (Hint = Ord(TofCalibOptimizerOnUpdateAll)) then
  begin
    //Set the memo font size
    ProgressMemo.Font.Size := g_TofCalibOptimizerDoc.FontSize.ValueAsInt;

    //Set the memo font style
    if (g_TofCalibOptimizerDoc.IsTextBold.Value) then
      ProgressMemo.Font.Style := [fsBold]
    else
      ProgressMemo.Font.Style := []; //clear

    //Update other g_TofCalibOptimizerDoc things (if any on this view) below

  end;
end;

// AddButtonClick
procedure TTofCalibOptimizerView.AddButtonClick(Sender: TObject);
var
  InputString: string;
begin
  InputString:= InputBox('Add a string to the Progress Log', 'Enter your string', '');
  g_TofCalibOptimizerDoc.SetProgressString(g_TofCalibOptimizerDoc.ProgressString.Value + slinebreak + InputString);
end;


end.
