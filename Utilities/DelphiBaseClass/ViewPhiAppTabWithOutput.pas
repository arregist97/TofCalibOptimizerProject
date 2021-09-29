unit ViewPhiAppTabWithOutput;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ViewPhiAppTabProp.pas
// Created:   January 16, 2003 by John Baker
// Purpose:   This module supports a property dialog box with tabs.  Each tab
//             is a application view.
//*********************************************************
// Copyright © 2000 Physical Electronics, Inc.
// Created in 2000 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////
interface

uses
  Windows,Controls, StdCtrls, ExtCtrls, Classes, Forms, ComCtrls, Buttons,
  ViewPhi,
  ParameterAutoTool;

type
  TPhiAppTabWithOutputView = class(TPhiView)
    MainPanel: TPanel;
    ButtonPanel: TPanel;
    TabControl: TTabControl;
    TabPanel: TPanel;
    ApplicationPanel: TPanel;
    CloseButton: TButton;
    OutputTabControl: TTabControl;
    OutputTabPanel: TPanel;
    OutputPanel: TPanel;
    ShowDetailsButton: TSpeedButton;
    ShowRibbonPanel: TPanel;
    RibbonTabControl: TTabControl;
    RibbonPanel: TPanel;
    RibbonSplitter: TSplitter;
    procedure TabControlChange(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure OutputTabControlChange(Sender: TObject);
    procedure ShowDetailsButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RibbonTabControlChange(Sender: TObject);
    procedure ShowRibbonPanelClick(Sender: TObject);
  private
    m_Application: TPhiView;
    m_OutputApplication: TPhiView;
    m_RibbonApplication: TPhiView;

    m_NumberOfTabs: Integer;
    m_NumberOfOutputTabs: Integer;
    m_NumberOfRibbonTabs: Integer;

    m_OutputApplicationWidth: Integer;
    m_MaxHeight: Integer;
    m_MinNumberOfTabs: Integer;

    m_OnCloseButton: TNotifyEvent;

    m_TabList: TStringList;
    m_AutoToolList: TStringList;

    m_FirstDisplay: Boolean;

    procedure OnTabChange(Application: TPhiView);
    procedure OnOutputTabChange(Application: TPhiView);
    procedure OnRibbonTabChange(Application: TPhiView);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Clear();
    procedure AddTab(TabLabel: String; Application: TPhiView); overload;
    procedure AddTab(TabLabel: String; Application: TPhiView; AutoToolPtr: String); overload;
    procedure AddOutput(TabLabel: String; Application: TPhiView);
    procedure AddRibbon(RibbonLabel: String; Application: TPhiView);
    procedure SetTab(TabLabel: String); overload;
    procedure SetTab(Application: TPhiView); overload;
    procedure SetOutputTab(TabLabel: String); overload;
    procedure SetOutputTab(Application: TPhiView); overload;
    procedure ShowDetails(Value: Boolean); override;

    procedure SetObject(AutoToolPtr: String);

    property OnCloseButton: TNotifyEvent read m_OnCloseButton write m_OnCloseButton;

    property MinNumberOfTabs: Integer read m_MinNumberOfTabs write m_MinNumberOfTabs;
    property MaxHeight: Integer read m_MaxHeight write m_MaxHeight;
  end;

var
  PhiAppTabWithOutputView: TPhiAppTabWithOutputView;

implementation

{$R *.DFM}

uses
 Messages;

const
  c_MaxTabsPerRow = 4;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Class constructor.
// Inputs:       AOwner - parent component
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TPhiAppTabWithOutputView.Create(AOwner: TComponent);
begin
  inherited;

  // Set MainPanel to a large number > 1024, will resize when filled with applications
  MainPanel.Height := 2000;

  m_Application := nil;
  m_OutputApplication := nil;
  m_RibbonApplication := nil;

  m_NumberOfTabs := 0;
  m_NumberOfOutputTabs := 0;
  m_NumberOfRibbonTabs := 0;

  m_MinNumberOfTabs := 2;
  m_MaxHeight := 0;
  m_FirstDisplay := True;
  m_OutputApplicationWidth := 0;

  m_Details := True;

  TabControl.MultiLine := True;
  TabControl.RaggedRight := False;
  TabControl.Visible := True;

  OutputTabControl.MultiLine := True;
  OutputTabControl.RaggedRight := False;

  RibbonTabControl.MultiLine := True;
  RibbonTabControl.RaggedRight := False;
  RibbonTabControl.Visible := False;

  ShowDetailsButton.Down := True;
  ShowDetailsButton.Visible := False;
  RibbonSplitter.Visible := False;

  // AutoTool Editor
  m_TabList := TStringList.Create ;
  m_TabList.Duplicates := dupAccept;

  m_AutoToolList := TStringList.Create ;
  m_AutoToolList.Duplicates := dupAccept;

  m_OnCloseButton := nil;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Class destructor.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TPhiAppTabWithOutputView.Destroy;
begin
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Clear tabs.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.Clear;
begin
  TabControl.Tabs.Clear();
  OutputTabControl.Tabs.Clear();

  m_Application := nil;
  m_OutputApplication := nil;
  m_RibbonApplication := nil;

  m_NumberOfTabs := 0;
  m_NumberOfOutputTabs := 0;
  m_NumberOfRibbonTabs := 0;

  m_MaxHeight := 0;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Show event callback
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.FormShow(Sender: TObject);
var
  index: Integer;
  application: TPhiView;
begin
  if m_FirstDisplay = True then
  begin
    for index := 0 to TabControl.Tabs.Count - 1 do
    begin
      application := TPhiView(TabControl.Tabs.Objects[index]);
      application.OnTabInitialize();
    end;

    for index := 0 to OutputTabControl.Tabs.Count - 1 do
    begin
      application := TPhiView(OutputTabControl.Tabs.Objects[index]);
      application.OnTabInitialize();
    end;

    for index := 0 to RibbonTabControl.Tabs.Count - 1 do
    begin
      application := TPhiView(RibbonTabControl.Tabs.Objects[index]);
      application.OnTabInitialize();
    end;

    // This is a sizable container view; Only set the height once
    Height := m_MaxHeight + (TabControl.TabHeight * TabControl.RowCount) + ButtonPanel.Height + 24 {6x4 - Border Width:6 * AppTop+AppBottom+MainTop+MainBottom: 4};

    // Adjust for title bar
    Height := Height + 45;

    m_FirstDisplay := False;
  end;

  // Input Tab
  if TabControl.Tabs.Count > 0 then
  begin
    if (not assigned(m_Application)) then
    begin
      if TabControl.Tabs.Count > 0 then
      begin
        // Set, and show, the current application for the first time
        application := TPhiView(TabControl.Tabs.Objects[0]);
        OnTabChange(application);
      end;
    end
    else
    begin
      // Show the current application
      m_Application.OnTabShow();
    end;
  end;

  // Output Tab
  if OutputTabControl.Tabs.Count > 0 then
  begin
    if (not assigned(m_OutputApplication)) then
    begin
      // Set, and show, the current application for the first time
      application := TPhiView(OutputTabControl.Tabs.Objects[0]);
      OnOutputTabChange(application);
    end
    else
    begin
      // Show the current application
      m_OutputApplication.OnTabShow();
    end;
  end;

  // Ribbon Tab
  if RibbonTabControl.Tabs.Count > 0 then
  begin
    if (not assigned(m_RibbonApplication)) then
    begin
      // Set, and show, the current application for the first time
      application := TPhiView(RibbonTabControl.Tabs.Objects[0]);
      OnRibbonTabChange(application);
    end
    else
    begin
      // Show the current application
      m_RibbonApplication.OnTabShow();
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Hide event callback
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.FormHide(Sender: TObject);
begin
  if assigned(m_Application) then
    m_Application.OnTabHide();

  if assigned(m_OutputApplication) then
    m_OutputApplication.OnTabHide();

  if assigned(m_RibbonApplication) then
    m_RibbonApplication.OnTabHide();
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  CanResize event callback
// Inputs:       None
// Outputs:      None
// Note:         CanResize event must be used instead of Show or Paint when resizing form
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
var
  NumberOfTabs: Integer;
begin
  inherited;

  if(m_NumberOfTabs < m_MinNumberOfTabs) then
    NumberOfTabs := m_MinNumberOfTabs
  else
    NumberOfTabs := m_NumberOfTabs;

  // Space tabs evenly across the top of the control
  if(NumberOfTabs = 1) then
    TabControl.TabWidth:= (TabControl.Width div 2) - 3
  else if (NumberOfTabs > 1) and (NumberOfTabs <= c_MaxTabsPerRow) then
    TabControl.TabWidth:= (TabControl.Width div NumberOfTabs) - 3
  else
    TabControl.TabWidth := 0;

  if(m_NumberOfOutputTabs = 1) then
    OutputTabControl.TabWidth:= (OutputTabControl.Width div m_NumberOfOutputTabs) - 9
  else if (m_NumberOfOutputTabs > 1) and (m_NumberOfOutputTabs <= c_MaxTabsPerRow) then
    OutputTabControl.TabWidth:= (OutputTabControl.Width div m_NumberOfOutputTabs) - 3
  else
    OutputTabControl.TabWidth := 0;

  if(m_NumberOfRibbonTabs = 1) then
    RibbonTabControl.TabWidth:= (RibbonTabControl.Width div m_NumberOfRibbonTabs) - 9
  else if (m_NumberOfRibbonTabs > 1) and (m_NumberOfRibbonTabs <= c_MaxTabsPerRow) then
    RibbonTabControl.TabWidth:= (RibbonTabControl.Width div m_NumberOfRibbonTabs) - 3
  else
    RibbonTabControl.TabWidth := 0;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Callback when Application is changed.
// Inputs:       TObject as TPhiAppView.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.OnTabChange(Application: TPhiView);
begin
  // Hide the previous view
  if (m_Application <> nil) then
  begin
    m_Application.OnTabHide();
  end;

  // Set the new view (tab)
  m_Application := Application;

  // Show the new view
  if (m_Application <> nil) then
  begin
    m_Application.Parent:= ApplicationPanel;
    if Visible and TabControl.Visible then
      m_Application.OnTabShow();

    // Set the new application tab
    TabControl.TabIndex:= TabControl.Tabs.IndexOfObject(m_Application);
  end;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Callback when Application is changed.
// Inputs:       TObject as TPhiAppView.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.OnOutputTabChange(Application: TPhiView);
begin
  // Hide the previous view
  if (m_OutputApplication <> nil) then
  begin
    m_OutputApplication.OnTabHide();
  end;

  // Set the new view (tab)
  m_OutputApplication := Application;

  // Show the new view
  if (m_OutputApplication <> nil) then
  begin
    m_OutputApplication.Parent:= OutputPanel;
    if Visible and OutputTabControl.Visible then
      m_OutputApplication.OnTabShow();

    // Set the new application tab
    OutputTabControl.TabIndex:= OutputTabControl.Tabs.IndexOfObject(m_OutputApplication);
  end;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Callback when Application is changed.
// Inputs:       TObject as TPhiAppView.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.OnRibbonTabChange(Application: TPhiView);
begin
  // Hide the previous view
  if (m_RibbonApplication <> nil) then
  begin
    m_RibbonApplication.OnTabHide();
  end;

  // Set the new view (tab)
  m_RibbonApplication := Application;

  // Show the new view
  if (m_RibbonApplication <> nil) then
  begin
    m_RibbonApplication.Parent:= RibbonPanel;
    if Visible and RibbonTabControl.Visible then
      m_RibbonApplication.OnTabShow();

    // Set the new application tab
    RibbonTabControl.TabIndex := RibbonTabControl.Tabs.IndexOfObject(m_RibbonApplication);
  end;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  TabControl Changed callback
// Inputs:       Sender as TTabControl.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.TabControlChange(Sender: TObject);
var
  Application: TPhiView;
begin
  if not (Sender is TTabControl) then
    Exit;

  // Get the object of the selected input tab
  Application := TPhiView(TTabControl(Sender).Tabs.Objects[TTabControl(Sender).TabIndex]) ;

  OnTabChange(Application);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  OutputTabControl Changed callback
// Inputs:       Sender as TTabControl.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.OutputTabControlChange(Sender: TObject);
var
  Application: TPhiView;
begin
  if not (Sender is TTabControl) then
    Exit;

  // Get the object of the selected input tab
  Application := TPhiView(TTabControl(Sender).Tabs.Objects[TTabControl(Sender).TabIndex]) ;

  OnOutputTabChange(Application);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  RibbonTabControlChange Changed callback
// Inputs:       Sender as TTabControl.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.RibbonTabControlChange(Sender: TObject);
var
  Application: TPhiView;
begin
  if not (Sender is TTabControl) then
    Exit;

  // Get the object of the selected input tab
  Application := TPhiView(TTabControl(Sender).Tabs.Objects[TTabControl(Sender).TabIndex]) ;

  OnRibbonTabChange(Application);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Callback when application and tab is added
// Inputs:       None
// Outputs:      None
// Note:         Parenting the application using the OnTabChange() will change
//               the application Visible state to True, even though the application
//               is not actually visible.  This is, however, needed for the
//               tab control to work properly, at least for the initial dipslay.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.AddTab(TabLabel: String; Application: TPhiView);
begin
  TabControl.Tabs.AddObject(TabLabel, Application);
  m_NumberOfTabs := m_NumberOfTabs + 1;

  if (Application.Height > m_MaxHeight) then
    m_MaxHeight := Application.Height;
end;

procedure TPhiAppTabWithOutputView.AddTab(TabLabel: String; Application: TPhiView; AutoToolPtr: String);
begin
  TabControl.Tabs.AddObject(TabLabel, Application);
  m_NumberOfTabs := m_NumberOfTabs + 1;

  if (Application.Height > m_MaxHeight) then
    m_MaxHeight := Application.Height;

  m_TabList.AddObject(TabLabel, Application);
  m_AutoToolList.Add(AutoToolPtr);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Callback when application and tab is added
// Inputs:       None
// Outputs:      None
// Note:         Parenting the application using the OnTabChange() will change
//               the application Visible state to True, even though the application
//               is not actually visible.  This is, however, needed for the
//               tab control to work properly, at least for the initial dipslay.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.AddOutput(TabLabel: String; Application: TPhiView);
begin
  // Application on output are expected to size to window
  Application.Align := alClient;

  OutputTabControl.Tabs.AddObject(TabLabel, Application);
  m_NumberOfOutputTabs := m_NumberOfOutputTabs + 1;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Callback when application and tab is added
// Inputs:       None
// Outputs:      None
// Note:         Parenting the application using the OnTabChange() will change
//               the application Visible state to True, even though the application
//               is not actually visible.  This is, however, needed for the
//               tab control to work properly, at least for the initial dipslay.
///////////////////////////////////////////////////////////////////////////////////////////////////////

// AddRibbon
procedure TPhiAppTabWithOutputView.AddRibbon(RibbonLabel: String; Application: TPhiView);
begin
  // Application on ribbon are expected to size to window
  Application.Align := alClient;

  ShowRibbonPanel.Visible := True;

  RibbonTabControl.Tabs.AddObject(RibbonLabel, Application);
  m_NumberOfRibbonTabs := m_NumberOfRibbonTabs + 1;
end;

// ShowRibbonPanelClick
procedure TPhiAppTabWithOutputView.ShowRibbonPanelClick(Sender: TObject);
begin
  if RibbonTabControl.Visible then
  begin
    RibbonTabControl.Visible := False;
    RibbonSplitter.Visible := False;
    ShowRibbonPanel.Caption := '>';
  end
  else
  begin
    RibbonTabControl.Visible := True;
    RibbonTabControl.Left := ShowRibbonPanel.Left + ShowRibbonPanel.Width + 10;

    RibbonSplitter.Visible := True;
    RibbonSplitter.Left := RibbonTabControl.Left + RibbonTabControl.Width + 10;

    ShowRibbonPanel.Caption := '<';
  end;

  OnRibbonTabChange(m_RibbonApplication);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current application tab
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.SetTab(TabLabel: String);
var
  Index: Integer;
  Application: TPhiView;
begin
  // Get the object of the TabLabel
  Index := TabControl.Tabs.IndexOf(TabLabel);
  if Index <> -1 then
  begin
    Application := TPhiView(TabControl.Tabs.Objects[TabControl.Tabs.IndexOf(TabLabel)]);
    OnTabChange(Application);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current application tab
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.SetTab(Application: TPhiView);
var
  Index: Integer;
begin
  // Get the object of the TabLabel
  Index := TabControl.Tabs.IndexOfObject(Application);
  if Index <> -1 then
  begin
    OnTabChange(Application);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current application tab
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.SetOutputTab(TabLabel: String);
var
  Index: Integer;
  Application: TPhiView;
begin
  // Get the object of the TabLabel
  Index := OutputTabControl.Tabs.IndexOf(TabLabel);
  if Index <> -1 then
  begin
    Application := TPhiView(OutputTabControl.Tabs.Objects[Index]);
    OnOutputTabChange(Application);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current application tab
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.SetOutputTab(Application: TPhiView);
begin
  OnOutputTabChange(Application);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current application tab
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.SetObject(AutoToolPtr: String);
var
  index: Integer;
  autoToolParameterPtr: String;
  application: TPhiView;

  NumberOfTabs: Integer;
  s_CurrentTab: String;
begin
  LockRefresh(True);

  if TabControl.TabIndex >= 0 then
    s_CurrentTab := TabControl.Tabs.Strings[TabControl.TabIndex]
  else
    s_CurrentTab := '';

  TabControl.Tabs.Clear();
  m_NumberOfTabs := 0;

  for index := 0 to m_AutoToolList.Count - 1 do
  begin
    autoToolParameterPtr := m_AutoToolList.Strings[index];

    if AutoToolPtr = autoToolParameterPtr then
    begin
      TabControl.Tabs.AddObject(m_TabList.Strings[index], m_TabList.Objects[index]);
      m_NumberOfTabs := m_NumberOfTabs + 1;
    end;
  end;

  if TabControl.Tabs.IndexOf(s_CurrentTab) >= 0 then
    application := TPhiView(TabControl.Tabs.Objects[TabControl.Tabs.IndexOf(s_CurrentTab)])
  else if TabControl.Tabs.Count > 0 then
    application := TPhiView(TabControl.Tabs.Objects[0])
  else
    application := nil;
  OnTabChange(application);

  if(m_NumberOfTabs < m_MinNumberOfTabs) then
    NumberOfTabs := m_MinNumberOfTabs
  else
    NumberOfTabs := m_NumberOfTabs;

  // Space tabs evenly across the top of the control
  if(NumberOfTabs = 1) then
    TabControl.TabWidth:= (TabControl.Width div 2) - 3
  else if (NumberOfTabs > 1) and (NumberOfTabs <= c_MaxTabsPerRow) then
    TabControl.TabWidth:= (TabControl.Width div NumberOfTabs) - 3
  else
    TabControl.TabWidth := 0;

  LockRefresh(False);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Callback when 'Extend Tab' button is selected
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.ShowDetailsButtonClick(Sender: TObject);
begin
  ShowDetails(ShowDetailsButton.Down);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Show view details; Tab view overrided baseclass ShowDetails
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.ShowDetails(Value: Boolean);
var
  bStateChange: Boolean;
begin
  bStateChange := False;
  if m_Details <> Value then
    bStateChange := True;

  if bStateChange then
  begin
    m_Details := Value;

    if m_Details = False then
    begin
      TabControl.Visible := False;
      ShowDetailsButton.Down := False;

      Width := Width - TabControl.Width;
    end
    else
    begin
      TabControl.Visible := True;
      ShowDetailsButton.Down := True;

      Width := Width + TabControl.Width;
    end;
  end;

  OnTabChange(m_Application);
  OnOutputTabChange(m_OutputApplication);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Callback when 'Close' button is selected
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.CloseButtonClick(Sender: TObject);
var
  bValidClose: Boolean;
begin
  bValidClose := True;

  if Assigned(m_OnCloseButton) then
  begin
    try
      m_OnCloseButton(Self);
    except
      bValidClose := False;
    end;
  end;

  if bValidClose then
    Hide;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Callback when 'X' button is selected
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiAppTabWithOutputView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(m_OnCloseButton) then
  begin
    try
      m_OnCloseButton(Self);
    except
      Action := caNone;
    end;
  end;
end;

end.
