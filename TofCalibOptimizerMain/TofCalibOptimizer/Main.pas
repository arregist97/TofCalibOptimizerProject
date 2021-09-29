unit Main;
////////////////////////////////////////////////////////////////////////////////
// Filename:  Main.pas
// Created:   8/1/2021
// Purpose:   This module contains the view class for the main window
//            (TMainView) for the TofCalibOptimizer.
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
  Vcl.StdCtrls,
  System.SysUtils,
  System.Variants,
  ViewPhi,
  Winapi.Windows;

type
  TMainView = class(TPhiView)
    OutputPanel: TPanel;
    InputPanel: TPanel;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    OpenItem: TMenuItem;
    SaveAsItem: TMenuItem;
    ExitItem: TMenuItem;
    Options1: TMenuItem;
    IsTextBoldItem: TMenuItem;
    FontSizeItem: TMenuItem;
    FontSize8Item: TMenuItem;
    FontSize10Item: TMenuItem;
    FontSize12Item: TMenuItem;
    FontSize14Item: TMenuItem;
    CurrentFolderCaption: TLabel;
    CurrentFolderLabel: TLabel;
    procedure ExitItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OpenItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IsTextBoldItemClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SaveAsItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FontSizeItemClick(Sender: TObject);
  private
    procedure OnUpdateTofCalibOptimizer(Hint: Integer);
  public
    OutputPanelSplitter: TSplitter;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OnUpdate(Name: String; Hint: Integer); override;
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

uses
  DocTofCalibOptimizer,
  ViewTofCalibOptimizer,
  ViewTofCalibOptimizerInput;

// Create
constructor TMainView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Instantiate the docs.
  g_TofCalibOptimizerDoc := TTofCalibOptimizerDoc.Create(AOwner);

  // Instantiate the views.
  g_TofCalibOptimizerView := TTofCalibOptimizerView.Create(AOwner);
  g_TofCalibOptimizerInputView := TTofCalibOptimizerInputView.Create(AOwner);

  // Initialize the docs.
  g_TofCalibOptimizerDoc.Initialize;

  // Initialize the views.
  g_TofCalibOptimizerView.Initialize;
  g_TofCalibOptimizerInputView.Initialize;

  // Create the splitter.
  OutputPanelSplitter := TSplitter.Create(AOwner);

  // Parent the TofCalibOptimizerView (to the OutputPanel)
  g_TofCalibOptimizerView.Parent := OutputPanel;
  g_TofCalibOptimizerView.Align := alClient;

  // Parent the OutputPanelSplitter (to the OutputPanel)
  OutputPanelSplitter.Parent := OutputPanel;
  OutputPanelSplitter.Align := alBottom;

  // Parent the TofCalibOptimizerInputView (to the InputPanel)
  g_TofCalibOptimizerInputView.Parent := InputPanel;
  g_TofCalibOptimizerInputView.Align := alTop;

  OutputPanelSplitter.Visible := False;

  // Align the main view.
  InputPanel.Align := alRight;
  OutputPanel.Align := alClient;

  if assigned(g_TofCalibOptimizerDoc) then
    g_TofCalibOptimizerDoc.AddView(Self);
end;

// Destroy
destructor TMainView.Destroy;
begin
  inherited;
end;

//FormShow
procedure TMainView.FormShow(Sender: TObject);
begin
  inherited;

  //Init any UI elements etc. here if necessary

  // Update the UI.
  OnUpdateTofCalibOptimizer(Ord(TofCalibOptimizerOnUpdateAll));
end;

// FormClose

procedure TMainView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  g_TofCalibOptimizerDoc.DeInitialize;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  inherited;
end;

// FormResize
procedure TMainView.FormResize(Sender: TObject);
begin
  if (not Visible) then
    Exit;

  // Maintain the input panel width
  InputPanel.Width := 200;
end;

// OnUpdate
procedure TMainView.OnUpdate(Name: String; Hint: Integer);
begin
  if (Name = c_TofCalibOptimizer) then
    OnUpdateTofCalibOptimizer(Hint);
end;

// OnUpdateTofCalibOptimizer
procedure TMainView.OnUpdateTofCalibOptimizer(Hint: Integer);
begin
  inherited OnUpdate(Hint);

  if not Visible then
    Exit;

  if (Hint = Ord(TofCalibOptimizerOnUpdateAll)) then
  begin
    g_TofCalibOptimizerDoc.IsTextBold.ToMenuItem(IsTextBoldItem);

    g_TofCalibOptimizerDoc.FontSize.ToMenuItem(FontSize8Item, c_FontSize_8);
    g_TofCalibOptimizerDoc.FontSize.ToMenuItem(FontSize10Item, c_FontSize_10);
    g_TofCalibOptimizerDoc.FontSize.ToMenuItem(FontSize12Item, c_FontSize_12);
    g_TofCalibOptimizerDoc.FontSize.ToMenuItem(FontSize14Item, c_FontSize_14);

    //Update other g_TofCalibOptimizerDoc things (if any on this view) below

  end;
end;

// ExitItemClick
procedure TMainView.ExitItemClick(Sender: TObject);
begin
  Close;
end;

// OpenItemClick
procedure TMainView.OpenItemClick(Sender: TObject);
begin
  if (OnUpdateChange) then
    Exit;

  g_TofCalibOptimizerDoc.OpenFileDialog;
end;

// SaveAsItemClick
procedure TMainView.SaveAsItemClick(Sender: TObject);
begin
  if (OnUpdateChange) then
    Exit;

  g_TofCalibOptimizerDoc.SaveAsFileDialog;
end;

// IsTextBoldItemClick
procedure TMainView.IsTextBoldItemClick(Sender: TObject);
begin
  if (OnUpdateChange) then
    Exit;

  g_TofCalibOptimizerDoc.SetIsTextBold(not IsTextBoldItem.Checked);
end;

// FontSizeItemClick
procedure TMainView.FontSizeItemClick(Sender: TObject);
var
  menuItem: TMenuItem;
  fontSizeStr: String;
begin
  if (OnUpdateChange) then
    Exit;

  menuItem := TMenuItem(Sender);
  fontSizeStr := StringReplace(menuItem.Caption, '&', '', []);
  g_TofCalibOptimizerDoc.SetFontSize(fontSizeStr);
end;

end.

