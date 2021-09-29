unit ViewPhi;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  PHIView.pas
// Created:   on 98-12-10 by Mark Rosen
// Purpose:   This module defines the base class for all PHI Views.  The
//             base class TPHIView is derived from TForm and simply defines
//             a virtual function OnUpdate() to be called from the document
//             to update the view.  The implementation is left empty to ensure
//             that the function is implemented somewhere.
//*********************************************************
// Copyright © 1998 Physical Electronics, Inc.
// Created in 1998 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,
  ObjectPhi,
  Parameter,
  ParameterString;

const
  c_KeyPrefix_Cancel = 'Cancel';
  c_KeyPrefix_DblClick = 'DblClick';
  c_KeyPrefix_Return = 'Return';
  c_KeyPrefix_Select = 'Select';
  c_KeyPrefix_SetAll = 'SetAll';
  c_KeyPrefix_SelectAll = 'SelectAll';
  c_KeyPrefix_DeSelectAll = 'DeSelectAll';
  c_KeyPrefix_StartDock = 'StartDock';
  c_KeyPrefix_DockDrop = 'DockDrop';
  c_KeyPrefix_ListClick = 'ListClick';

  c_DefaultCategoryHeight = 20;

type
  TPhiView = class(TForm)
    procedure FormActivate(Sender: TObject);
  private
    m_PhiObject: TPhiObject; // PhiObject for supporting logging
    m_ParameterList: TList; // list of parameters that are registered with this view
    m_OnUpdateChange: Boolean;
    m_PropertyView: TPhiView;

    m_FirstDisplay: Boolean;
    m_IsLocked: Boolean;

    // Key click logging.
    m_OnWriteCircularBuffer: TNotifyEvent;
    m_EventLogMessageType: Integer;
    m_EventLogObjectID: Integer;
    m_EventLogMessageText: String;

    procedure RemoveTabStops(ParentControl: TWinControl);

  protected
    m_HideList: TList;
    m_ShowList: TList;
    m_Details: Boolean;

    m_HotSpotTop: Integer;
    m_HotSpotLeft: Integer;

    function  GetViewName : string;
    procedure SetViewName(strName: string);

    procedure CreateCategory(GroupBoxPtr: TGroupBox; ShowFlag: Boolean); overload;
    procedure CreateCategory(GroupBoxPtr: TGroupBox; HideList: TParameterString; ShowFlag: Boolean = False); overload;
    procedure CategoryButtonClick(Sender: TObject);

    procedure ResizePanelHeight(PanelPtr: TPanel);
    function GetPanelHeight(PanelPtr: TPanel): Integer;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Initialize(); virtual;
    procedure DeInitialize(); virtual;
    procedure OnUpdate(Hint : integer); overload; virtual;
    procedure OnUpdate(DocName: string; Hint : integer); reintroduce; overload; virtual;
    procedure OnTabShow(); virtual;
    procedure OnTabHide(); virtual;
    procedure OnTabInitialize(); virtual;
    procedure OnTabApply(); virtual;
    procedure OnTabCancel(); virtual;
    procedure ShowDialog();
    function ShowModalDialog(): Integer;
    procedure ShowDetails(Value: Boolean); virtual;

    procedure LockRefresh(Lock: Boolean);

    // Dialogs
    function ModalDialog(DialogType: TDialogType; Buttons: TDialogButtons; strMsg: string): TDialogResult;
    procedure ModelessDialog(DialogType: TDialogType; strMsg: string);
    function MessageDialog(DialogType : TDialogType; Buttons : TDialogButtons;
                        strMsg : string) : TDialogResult;

    // Error Logging
    function ErrorLog(Level : TErrorLevel; Code : HResult; Reported : boolean;
                        PrevError : TPHIResult; Msg : string) : TPHIResult;
    procedure TraceLog(Level : TTraceLevel; Msg: string); overload;
    procedure TraceLog(Level : TTraceLevel; Msg: string; Value: Double); overload;
    procedure TraceLog(Level : TTraceLevel; Msg: string; Value: String); overload;
    procedure TraceLog(Level : TTraceLevel; Msg: string; Value: Boolean); overload;
    function  GetTraceLevel : TTraceLevel;
    procedure SetTraceLevel(Level : TTraceLevel);
    function  GetErrorLevel : TErrorLevel;
    procedure SetErrorLevel(Level : TErrorLevel);

    procedure LogKeyClick(Sender: TObject; CustomComment: String = c_InvalidString);

    // Parameters
    procedure AddParameter(Parameter : TParameter);
    procedure RemoveParameter(Parameter : TParameter);
    procedure ClearParameter();
    procedure SaveUndo();
    procedure Undo();

    property OnUpdateChange: Boolean read m_OnUpdateChange write m_OnUpdateChange;
    property PropertyView: TPhiView read m_PropertyView write m_PropertyView;

    property HotSpotTop: Integer read m_HotSpotTop write m_HotSpotTop;
    property HotSpotLeft: Integer read m_HotSpotLeft write m_HotSpotLeft;

    // Key click logging.
    property OnWriteCircularBuffer: TNotifyEvent read m_OnWriteCircularBuffer write m_OnWriteCircularBuffer;
    property EventLogMessageType: Integer read m_EventLogMessageType write m_EventLogMessageType;
    property EventLogObjectID: Integer read m_EventLogObjectID write m_EventLogObjectID;
    property EventLogMessageText: String read m_EventLogMessageText write m_EventLogMessageText;

  published
    property ViewName: String read GetViewName write SetViewName;
  end;

var
  PhiView: TPhiView;

implementation

{$R *.DFM}

uses
  System.Types, StrUtils, Menus, Buttons, EditList, ComCtrls, FileCtrl, Mask,
  RealEdit,
  ViewPhiAppTabWithOutput,
  SlewButton,
  TrackEdit;

const
  c_PushOffscreen = 5000;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Class constructor.
// Inputs:       AOwner - parent component
//               ViewName -- view name
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TPhiView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // instantiate PhiObject (EnableLogging = True)
  m_PhiObject := TPhiObject.Create(Name, True);

  // Initialize list of parameters
  m_ParameterList := TList.Create();
  m_ParameterList.Clear();

  m_HideList := TList.Create();
  m_HideList.Clear();

  m_ShowList := TList.Create();
  m_ShowList.Clear();

  m_Details := False;
  m_OnUpdateChange := False;
  m_PropertyView := nil;
  m_FirstDisplay := True;
  m_IsLocked := False;
  m_HotSpotTop := 0;
  m_HotSpotLeft := 0;

  // Key click logging.
  m_OnWriteCircularBuffer := nil;
  m_EventLogMessageType := 0;
  m_EventLogObjectID := 0;
  m_EventLogMessageText := '';

  // Remove all tabstops from the code.
  RemoveTabStops(Self);
end;

procedure TPhiView.RemoveTabStops(ParentControl: TWinControl);
var
  idx: Integer;
  control: TControl;
begin
  for idx := 0 to ParentControl.ControlCount-1 do
  begin
    control := ParentControl.Controls[idx];

    // Controls with child controls.
    if control.ClassName = 'TCoolBar' then
    begin
      TCoolBar(control).TabStop := False;
      RemoveTabStops(TWinControl(control));
    end
    else if control.ClassName = 'TGroupBox' then
    begin
      TGroupBox(control).TabStop := False;
      RemoveTabStops(TWinControl(control));
    end
    else if control.ClassName = 'TPageControl' then
    begin
      TPageControl(control).TabStop := False;
      RemoveTabStops(TWinControl(control));
    end
    else if control.ClassName = 'TPanel' then
    begin
      TPanel(control).TabStop := False;
      RemoveTabStops(TWinControl(control));
    end
    else if control.ClassName = 'TTabControl' then
    begin
      TTabControl(control).TabStop := False;
      RemoveTabStops(TWinControl(control));
    end
    else if control.ClassName = 'TToolBar' then
    begin
      TToolBar(control).TabStop := False;
      RemoveTabStops(TWinControl(control));
    end

    // Controls without child controls.
    else if control.ClassName = 'TButton' then
      TButton(control).TabStop := False
    else if control.ClassName = 'TCheckBox' then
      TCheckBox(control).TabStop := False
    else if control.ClassName = 'TColorBox' then
      TColorBox(control).TabStop := False
    else if control.ClassName = 'TComboBox' then
      TComboBox(control).TabStop := False
    else if control.ClassName = 'TDateTimePicker' then
      TDateTimePicker(control).TabStop := False
    else if control.ClassName = 'TDirectoryListBox' then
      TDirectoryListBox(control).TabStop := False
    else if control.ClassName = 'TDriveComboBox' then
      TDriveComboBox(control).TabStop := False
    else if control.ClassName = 'TEdit' then
      TEdit(control).TabStop := False
    else if control.ClassName = 'TEditList' then
      TEditList(control).TabStop := False
    else if control.ClassName = 'TFileListBox' then
      TFileListBox(control).TabStop := False
    else if control.ClassName = 'TFilterComboBox' then
      TFilterComboBox(control).TabStop := False
    else if control.ClassName = 'TMaskEdit' then
      TMaskEdit(control).TabStop := False
    else if control.ClassName = 'TMemo' then
      TMemo(control).TabStop := False
    else if control.ClassName = 'TProgressBar' then
      TProgressBar(control).TabStop := False
    else if control.ClassName = 'TRadioButton' then
      TRadioButton(control).TabStop := False
    else if control.ClassName = 'TRealEdit' then
      TRealEdit(control).TabStops := False
    else if control.ClassName = 'TScrollBar' then
      TScrollBar(control).TabStop := False
    else if control.ClassName = 'TScrollBox' then
      TScrollBox(control).TabStop := False
    else if control.ClassName = 'TStaticText' then
      TStaticText(control).TabStop := False
    else if control.ClassName = 'TTrackEdit' then
      TTrackEdit(control).TabStop := False
    else
    begin
      // TFlowLine, TImage, TLabel, TPlaten, TRichEdit, TSettingGroupBox, TShape, TSlewButton, TSpeedButton, TSplitter
      // These controls don't support the TabStop feature.
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Class destructor.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TPhiView.Destroy;
begin
  // Clean up lists
  m_ParameterList.Free();
  m_ParameterList := nil;

  m_HideList.Free();
  m_HideList := nil;

  m_ShowList.Free();
  m_ShowList := nil;

  // Clean up PhiObject
  m_PhiObject.Free();

  inherited Destroy();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Initialize
// Inputs:      None
// Outputs:     None
// Note:        Initialize supports processing during startup, after this view,
//                and all other view, are created.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.Initialize;
begin
  // Implement in derived class
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: DeInitialize
// Inputs:      None
// Outputs:     None
// Note:        DeInitialize supports processing during shutdown, before this view,
//               or all other view, are destroyed.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.DeInitialize;
begin
  // Set OnUpdateChange flag to True; Disable any unexpected callback from view
  m_OnUpdateChange := True;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Callback when form is brought into focus
// Inputs:      None
// Outputs:     None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.FormActivate(Sender: TObject);
begin
  // Radio button controls will force a callback, possibly to the incorrect state, if left in focus
  if (ActiveControl is TRadioButton) then
    DefocusControl(ActiveControl, False);
end;

procedure TPhiView.OnUpdate(Hint : integer);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Called by the document whenever it changes to all views to
//                 update themselves.
// Inputs:       Hint - enum defined in the derived document class (derived from TPHIDoc)
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  // Implemented in derived class
end;

procedure TPhiView.OnUpdate(DocName: String; Hint : integer);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Called by the document whenever it changes to all views to
//                 update themselves.
// Inputs:       Hint - enum defined in the derived document class (derived from TPHIDoc)
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  // Implemented in derived class
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Called by the UI container objects, which provides more control
//               over when events happen.
// Inputs:       None
// Outputs:      None
// Note:         Method should be implemented in derived class
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.OnTabApply;
begin
  // Implemented in derived class
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Called by the UI container objects, which provides more control
//               over when events happen.
// Inputs:       None
// Outputs:      None
// Note:         Method should be implemented in derived class
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.OnTabCancel;
begin
  // Implemented in derived class
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Called by the UI container objects, which provides more control
//               over when events happen.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.OnTabHide;
begin
  Hide();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Called by the UI container objects, which provides more control
//               over when events happen.
// Inputs:       None
// Outputs:      None
// Note:         Method should be implemented in derived class
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.OnTabInitialize;
begin
  // Implemented in derived class
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Called by the UI container objects, which provides more control
//               over when events happen.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.OnTabShow;
begin
  Self.Show();

  if m_FirstDisplay = True then
    ShowDetails(m_Details);
  m_FirstDisplay := False;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Show dialog on top.
// Inputs:       None
// Outputs:      None
// Note:         This routine is used to force a dialog box to stay on top.
//               Occasionally, using only FormStyle=fsStayOnTop, a dialog box
//               will lose its stay on top property and be hidden behind the
//               main application.  Using this method to show a dialog box will
//               correct the problem.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.ShowDialog;
begin
  // Set form to stay on top
  SetWindowPos(Self.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE or SWP_NOSENDCHANGING);

  Self.Show();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Show modal dialog on top.
// Inputs:       None
// Outputs:      None
// Note:         SetViewOnTop() was removed because is causes the modal dialog to
//               lockup.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiView.ShowModalDialog: Integer;
begin
  // Set form to stay on top
  SetWindowPos(Self.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE or SWP_NOSENDCHANGING);

  Result := Self.ShowModal();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Show view details
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.ShowDetails(Value: Boolean);
var
  i: Integer;
begin
  m_Details := Value;

  if m_Details = True then
  begin
    for i := 0 to m_HideList.Count - 1 do
    begin
      if TObject(m_HideList.Items[i]) is TGroupBox then
        TGroupBox(m_HideList.Items[i]).Visible := False
      else if TObject(m_HideList.Items[i]) is TPanel then
        TPanel(m_HideList.Items[i]).Visible := False;
    end;

    for i := 0 to m_ShowList.Count - 1 do
    begin
      if TObject(m_ShowList.Items[i]) is TGroupBox then
      begin
        TGroupBox(m_ShowList.Items[i]).Visible := True;
        TGroupBox(m_ShowList.Items[i]).Top := c_PushOffscreen;
      end
      else if TObject(m_ShowList.Items[i]) is TPanel then
      begin
        TPanel(m_ShowList.Items[i]).Visible := True;
        TPanel(m_ShowList.Items[i]).Top := c_PushOffscreen;
        TPanel(m_ShowList.Items[i]).Parent.Height := TPanel(m_ShowList.Items[i]).Top + TPanel(m_ShowList.Items[i]).Height + 2;
      end;
    end;
  end
  else
  begin
    for i := 0 to m_ShowList.Count - 1 do
    begin
      if TObject(m_ShowList.Items[i]) is TGroupBox then
        TGroupBox(m_ShowList.Items[i]).Visible := False
      else if TObject(m_ShowList.Items[i]) is TPanel then
        TPanel(m_ShowList.Items[i]).Visible := False;
    end;

    for i := 0 to m_HideList.Count - 1 do
    begin
      if TObject(m_HideList.Items[i]) is TGroupBox then
      begin
        TGroupBox(m_HideList.Items[i]).Visible := True;
        TGroupBox(m_HideList.Items[i]).Top := c_PushOffscreen;
      end
      else if TObject(m_HideList.Items[i]) is TPanel then
      begin
        TPanel(m_HideList.Items[i]).Visible := True;
        TPanel(m_HideList.Items[i]).Top := c_PushOffscreen;
        TPanel(m_HideList.Items[i]).Parent.Height := TPanel(m_HideList.Items[i]).Top + TPanel(m_HideList.Items[i]).Height + 2;
      end;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Allow (unlock) or disallow (lock) UI refreshing.
// Inputs:       Lock
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.LockRefresh(Lock: Boolean);
begin
  if (Self.Handle = 0) then
    Exit;

  if Lock and Visible then
  begin
    SendMessage(Self.Handle, WM_SETREDRAW, 0, 0);
    m_IsLocked := True;
  end
  else
  begin
    if m_IsLocked then
    begin
      SendMessage(Self.Handle, WM_SETREDRAW, 1, 0);
      RedrawWindow(Self.Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
    end;
    m_IsLocked := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add Parameter to the list of Parameters associated to this view.
// Inputs:       Parameter as TParameter
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.AddParameter(Parameter : TParameter);
begin
  // Add the Parameter to list of Parameters
  if (Parameter <> nil) then
  begin
    m_ParameterList.Add(Parameter);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Remove a Parameter from the list of Parameters associated to this view.
// Inputs:       Parameter as TParameter
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.RemoveParameter(Parameter : TParameter);
begin
  // Remove the Parameter if it is in the list, otherwise do nothing
  m_ParameterList.Remove(Parameter);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Clear Parameter List
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.ClearParameter();
begin
  // Clear parameter list
  m_ParameterList.Clear();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Create a 'Modal' Dialog
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiView.ModalDialog(DialogType: TDialogType; Buttons: TDialogButtons;
  strMsg: string): TDialogResult;
begin
  // Delegate to PhiObject
  Result := m_PhiObject.ModalDialog(DialogType, Buttons, strMsg);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Create a 'Modeless' Dialog
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.ModelessDialog(DialogType : TDialogType; strMsg : string);
begin
  // Delegate to PhiObject
  m_PhiObject.ModelessDialog(DialogType, strMsg);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write trace message to system error log.
// Inputs:       Level - trace logging level
//               Msg - message to write to trace log
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiView.MessageDialog(DialogType : TDialogType; Buttons : TDialogButtons;
  strMsg : string) : TDialogResult;
begin
  // delegate to PhiObject
  Result := m_PhiObject.MessageDialog(DialogType, Buttons, strMsg);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write error message to the system error log.
// Inputs:       Level - error level for this error message
//               Code - HResult for this error
//               Reported - TRUE/FALSE if this error has been reported to the user
//               PrevError - previous error PHIResult
//               Msg - error message to log
// Return:       PHIResult - PHIResult for this error to be used in subsequent ErrorLog calls relating
//                to this error
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiView.ErrorLog(Level: TErrorLevel; Code: HResult;
  Reported: boolean; PrevError: TPHIResult; Msg: string): TPHIResult;
begin
  // delegate to PhiObject
  Result := m_PhiObject.ErrorLog(Level, Code, Reported, PrevError, Msg);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write trace message to system error log.
// Inputs:       Level - trace logging level
//               Msg - message to write to trace log
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.TraceLog(Level: TTraceLevel; Msg: string);
begin
  // delegate to PhiObject
  m_PhiObject.TraceLog(Level, Msg);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write trace message to system error log.
// Inputs:       Level - trace logging level
//               Msg - message to write to trace log
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.TraceLog(Level: TTraceLevel; Msg: string; Value: Double);
begin
  // delegate to PhiObject
  m_PhiObject.TraceLog(Level, Msg + ': ' + FloatToStr(Value));
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write trace message to system error log.
// Inputs:       Level - trace logging level
//               Msg - message to write to trace log
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.TraceLog(Level: TTraceLevel; Msg: string; Value: String);
begin
  // delegate to PhiObject
  m_PhiObject.TraceLog(Level, Msg + ': ' + Value);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write trace message to system error log.
// Inputs:       Level - trace logging level
//               Msg - message to write to trace log
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.TraceLog(Level: TTraceLevel; Msg: string; Value: Boolean);
begin
  // delegate to PhiObject
  m_PhiObject.TraceLog(Level, Msg + ': ' + BoolToStr(Value, True));
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get current Error Logging Level.
// Inputs:       None
// Return:       Current Error logging level
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiView.GetErrorLevel: TErrorLevel;
begin
  // delegate to PhiObject
  Result := m_PhiObject.GetErrorLevel;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set error logging level for this object.
// Inputs:       Level - error logging level
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.SetErrorLevel(Level: TErrorLevel);
begin
  // delegate to PhiObject
  m_PhiObject.SetErrorLevel(Level);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get current Trace Logging Level.
// Inputs:       None
// Return:       Current Trace logging level
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiView.GetTraceLevel: TTraceLevel;
begin
  // delegate to PhiObject
  Result := m_PhiObject.GetTraceLevel;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set trace logging level for this object.
// Inputs:       Level - trace logging level
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.SetTraceLevel(Level: TTraceLevel);
begin
  // delegate to PhiObject
  m_PhiObject.SetTraceLevel(Level);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get name of the view.
// Inputs:       None
// Return:       Name of this object
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiView.GetViewName: string;
begin
  // delegate to PhiObject
  Result := m_PhiObject.GetName;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get name of the view.
// Inputs:       None
// Return:       Name of this object
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.SetViewName(strName: string);
begin
  // delegate to PhiObject
  m_PhiObject.SetName(strName);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save the UndoValues for all Parameters registered to this view
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.SaveUndo();
var
  Index: integer;
  Item: TParameter;
begin
  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1];
    Item.SaveUndo;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Restore the UndoValues for all Parameters registered to this view
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiView.Undo();
var
  Index: integer;
  Item: TParameter;
begin
  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1];
    Item.Undo;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Category
////////////////////////////////////////////////////////////////////////////////

// CreateCategory
procedure TPhiView.CreateCategory(GroupBoxPtr: TGroupBox; ShowFlag: Boolean);
begin
  CreateCategory(GroupBoxPtr, nil, ShowFlag);
end;

// CreateCategory
procedure TPhiView.CreateCategory(GroupBoxPtr: TGroupBox; HideList: TParameterString; ShowFlag: Boolean);
var
  buttonPtr: TSpeedButton;
begin
  buttonPtr := TSpeedButton.Create(GroupBoxPtr);
  buttonPtr.Width := 15;
  buttonPtr.Height := 15;
  buttonPtr.Top := 1;
  buttonPtr.Left := 1;
  buttonPtr.Layout := blGlyphBottom;
  buttonPtr.Caption := '-';
  buttonPtr.AllowAllUp := False;
  if assigned(HideList) then
    buttonPtr.Tag := Integer(HideList);
  buttonPtr.OnClick := CategoryButtonClick;
  GroupBoxPtr.InsertControl(buttonPtr);
  GroupBoxPtr.Caption := '    ' + GroupBoxPtr.Caption;
  GroupBoxPtr.Tag := GroupBoxPtr.Height;
  GroupBoxPtr.ParentBackground := False;

  if assigned(HideList) then
  begin
    ShowFlag := True;
    if ContainsText(HideList.Value, GroupBoxPtr.Name) then
      ShowFlag := False;
  end;

  if ShowFlag = False then
  begin
    GroupBoxPtr.Height := c_DefaultCategoryHeight;
    GroupBoxPtr.Color := clGradientInactiveCaption;
    buttonPtr.Caption := '+';
  end;
end;

// CategoryButtonClick
procedure TPhiView.CategoryButtonClick(Sender: TObject);
var
  buttonPtr: TSpeedButton;
  groupBoxPtr: TGroupBox;
  hideList: TParameterString;
begin
  buttonPtr := TSpeedButton(Sender);
  groupBoxPtr := TGroupBox(buttonPtr.Parent);
  if groupBoxPtr.Height = c_DefaultCategoryHeight then
  begin
    groupBoxPtr.Height := groupBoxPtr.Tag;
    groupBoxPtr.Color := clBtnFace;
    buttonPtr.Caption := '-';
    if buttonPtr.Tag <> 0 then
    begin
      hideList := TParameterString(Pointer(buttonPtr.Tag));
      hideList.Value := StringReplace(hideList.Value, groupBoxPtr.Name, '', [rfReplaceAll]);
    end;
  end
  else
  begin
    groupBoxPtr.Height := c_DefaultCategoryHeight;
    groupBoxPtr.Color := clGradientInactiveCaption;
    buttonPtr.Caption := '+';
    if buttonPtr.Tag <> 0 then
    begin
      hideList := TParameterString(Pointer(buttonPtr.Tag));
      hideList.Value := hideList.Value + groupBoxPtr.Name;
    end;
  end;
end;

// ResizePanelHeight
procedure TPhiView.ResizePanelHeight(PanelPtr: TPanel);
var
  controlIndex: Integer;
begin
  PanelPtr.Height := 0;
  for controlIndex := 0 to PanelPtr.ControlCount - 1 do
  begin
    if PanelPtr.Controls[controlIndex].Visible then
      PanelPtr.Height := PanelPtr.Height + PanelPtr.Controls[controlIndex].Height;
  end;
end;

// GetPanelHeight
function TPhiView.GetPanelHeight(PanelPtr: TPanel): Integer;
var
  controlIndex: Integer;
  panelHeight: Integer;
begin
  panelHeight := 0;
  for controlIndex := 0 to PanelPtr.ControlCount - 1 do
  begin
    if PanelPtr.Controls[controlIndex].Visible then
      panelHeight := panelHeight + PanelPtr.Controls[controlIndex].Height;
  end;
  Result := panelHeight;
end;

////////////////////////////////////////////////////////////////////////////////
// Key Click Logging
////////////////////////////////////////////////////////////////////////////////

// LogKeyClick
procedure TPhiView.LogKeyClick(Sender: TObject; CustomComment: String);
var
  button: TButton;
  speedButton: TSpeedButton;
  checkBox: TCheckBox;
  comboBox: TComboBox;
  edit: TEdit;
  radioButton: TRadioButton;
  realEdit: TRealEdit;
  realEditStatus: Integer;
  realEditValue: Double;
  menuItem: TMenuItem;
  msgText: String;
  pageControl: TPageControl;
  buttonType: String;
  trackEdit: TTrackEdit;
  trackEditStatus: Integer;
  trackEditValue: Double;
  scrollbar: TScrollBar;
  slewButton: TSlewButton;
  contextMenuLabel: TLabel;
  toolButton: TToolButton;
  shape: TShape;
  image: TImage;
  panel: TPanel;
  directoryListBox: TDirectoryListBox;
  fileListBox: TFileListBox;
begin
  if not assigned(Sender) then
    Exit;

  // Construct the key click message based on the button type.
  msgText := '';
  if Sender.ClassType = TButton then
  begin
    button := Sender as TButton;
    msgText := button.Name + ', Clicked';
  end

  else if Sender.ClassType = TSpeedButton then
  begin
    speedButton := Sender as TSpeedButton;
    if speedButton.AllowAllUp then
    begin
      if speedButton.Down then
        msgText:= speedButton.Name + ', Pressed'
      else
        msgText:= speedButton.Name + ', Released';
    end
    else
      msgText:= speedButton.Name + ', Clicked';
  end

  else if Sender.ClassType = TCheckBox then
  begin
    checkBox := Sender as TCheckBox;
    if checkBox.Checked then
      msgText := checkBox.Name + ', Checked'
    else
      msgText := checkBox.Name + ', Unchecked';
  end

  else if Sender.ClassType = TComboBox then
  begin
    comboBox := Sender as TComboBox;
    msgText := comboBox.Name + ', ' + comboBox.Text;
  end

  else if Sender.ClassType = TEdit then
  begin
    edit := Sender as TEdit;
    msgText := edit.Name + ', ' + edit.Text;
  end

  else if Sender.ClassType = TRadioButton then
  begin
    radioButton := Sender as TRadioButton;
    msgText := radioButton.Name + ', Selected';
  end

  else if Sender.ClassType = TRealEdit then
  begin
    realEdit := Sender as TRealEdit;
    realEdit.GetDataValue(realEditStatus, realEditValue);
    msgText := realEdit.Name + ', ' + FloatToStr(realEditValue);
  end

  else if Sender.ClassType = TMenuItem then
  begin
    menuItem := Sender as TMenuItem;
    msgText := menuItem.Name + ', Clicked';
  end

  else if Sender.ClassType = TPageControl then
  begin
    pageControl := Sender as TPageControl;
    msgText := pageControl.Name + ', Selected';
  end

  else if Sender.ClassType = TTrackEdit then
  begin
    trackEdit := Sender as TTrackEdit;
    trackEdit.GetDataValue(trackEditStatus, trackEditValue);
    msgText := trackEdit.Name + ', ' + FloatToStr(trackEditValue);
  end

  else if Sender.ClassType = TSlewButton then
  begin
    slewButton := Sender as TSlewButton;
    msgText := slewButton.Name + ', Clicked';
  end

  else if Sender.ClassType = TLabel then
  begin
    contextMenuLabel := Sender as TLabel;
    msgText := contextMenuLabel.Name + ', Clicked';
  end

  else if Sender.ClassType = TToolButton then
  begin
    toolButton := Sender as TToolButton;
    msgText := toolButton.Name + ', Clicked';
  end

  else if Sender.ClassType = TShape then
  begin
    shape := Sender as TShape;
    msgText := shape.Name + ', Clicked';
  end

  else if Sender.ClassType = TImage then
  begin
    image := Sender as TImage;
    msgText := image.Name + ', Clicked';
  end

  else if Sender.ClassType = TPanel then
  begin
    panel := Sender as TPanel;
    msgText := panel.Name + ', Clicked';
  end

  else if Sender.ClassType = TScrollBar then
  begin
    scrollbar := Sender as TScrollBar;
    msgText := scrollbar.Name + ', Scroll';
  end

  else if Sender.ClassType = TDirectoryListBox then
  begin
    directoryListBox := Sender as TDirectoryListBox;
    msgText := directoryListBox.Name + ' - ' + directoryListBox.Directory + ', Clicked';
  end

  else if Sender.ClassType = TFileListBox then
  begin
    fileListBox := Sender as TFileListBox;
    msgText := fileListBox.Name + ' - ' + fileListBox.FileName + ', Clicked';
  end

  else if Sender.ClassName = 'TAdvCheckedTreeView' then
  begin
    msgText := 'TAdvCheckedTreeView, Clicked';
  end

  else
  begin
    buttonType := Sender.ClassName;
    TraceLog(traceOff, 'KeyClick: Unknown button type (' + buttonType + ') clicked');
  end;

  if (msgText <> '') then
  begin
    // Check if SEE data collection is active.
    //if Assigned(m_OnWriteCircularBuffer) then
    //begin
    //  // Add a packet to the event log circular buffer.
    //  m_EventLogMessageText := msgText;
    //  m_OnWriteCircularBuffer(Self);
    //end;

    // Custom comment; used if there is more than one callback for a single control (e.g. OnClick, OnChanged, OnSetAll)
    if (CustomComment <> c_InvalidString) then
      msgText := CustomComment + msgText;

    // Log a trace message.
    TraceLog(traceUser, 'KeyClick: ' + msgText);
  end;
end;

end.



