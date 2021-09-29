unit ComboBoxList;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ComboBoxList.pas
// Created:   on 00-9-6 by John Baker
// Purpose:   This module contains the TComboBoxList component.
//            (TComboBoxList).
//*********************************************************
// Copyright © 1998 Physical Electronics, Inc.
// Created in 1998 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Contnrs, Menus,
  ControlList ;

type
  TComboBoxList = class(TControlList)
  private
    m_DropDownCount: Integer;
    m_OnChangeEvent: TNotifyListEvent;
    m_OnClickEvent: TNotifyListEvent;
    m_OnDblClickEvent: TNotifyListEvent;
    m_OnDropDownEvent: TNotifyListEvent;
    m_OnReturnEvent: TNotifyListEvent;
    function CalculateWidth(): Integer;
    function GetControl(Index: Integer): TComboBox;
    procedure OnChangeEventHandler(Sender: TObject);
    procedure OnClickEventHandler(Sender: TObject);
    procedure OnContextPopupEventHandler(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure OnDblClickEventHandler(Sender: TObject);
    procedure OnDropDownEventHandler(Sender: TObject);
    procedure OnReturnEventHandler(Sender: TObject; var Key: Char);
    function GetControlDropDownCount: Integer;
    procedure SetControlDropDownCount(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override ;
    function Add(): TWinControl; override;
    procedure ControlRecolor(Value: Integer); override;
    procedure ControlResize() ; override ;
    procedure SetFocus; override;

    property Control[Index: Integer]: TComboBox read GetControl ;
  published
    property ControlDropDownCount: Integer read GetControlDropDownCount write SetControlDropDownCount ;

    property OnChange: TNotifyListEvent read m_OnChangeEvent write m_OnChangeEvent ;
    property OnClick: TNotifyListEvent read m_OnClickEvent write m_OnClickEvent ;
    property OnDblClick: TNotifyListEvent read m_OnDblClickEvent write m_OnDblClickEvent ;
    property OnDropDown: TNotifyListEvent read m_OnDropDownEvent write m_OnDropDownEvent ;
    property OnReturn: TNotifyListEvent read m_OnReturnEvent write m_OnReturnEvent ;
  end;

procedure Register;

implementation

////////////////////////////////////////////////////////////////////////////////
// Description:  Registers this component so it appears in the PHI Library tab
//               on Delphi's Component Palette
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure Register;
begin
  RegisterComponents('PHI Library', [TComboBoxList]);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Constructor to create this object.
// Inputs:       AOwner - component that owns this object.  If NIL is specified
//                        as owner, creator is responsible for destroying this
//                        object.
// Outputs:      Object
// Note:
////////////////////////////////////////////////////////////////////////////////
constructor TComboBoxList.Create(AOwner: TComponent);
begin
  inherited;

  // Set memeber variables
  m_DropDownCount := 30;
  m_OnChangeEvent := EmptyEventHandler;
  m_OnClickEvent := EmptyEventHandler;
  m_OnDblClickEvent := EmptyEventHandler;
  m_OnDropDownEvent := EmptyEventHandler;
  m_OnReturnEvent := EmptyEventHandler;

  // Size the control width
  ControlWidth := 75;

  // Add a Control with no events
  Add();

  // Colorize and Size the Control
  ControlResize();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add control to the list of control associated to this view.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TComboBoxList.Add(): TWinControl ;
var
  ControlPtr: TComboBox ;
begin
  ControlPtr := TComboBox.Create(nil) ;
  ControlPtr.Name := GetValidControlName();
  ControlPtr.DropDownCount := m_DropDownCount;
  ControlPtr.Font := ControlFont;
  ControlPtr.Height := ControlHeight ;
  ControlPtr.Left := c_ControlLeft;
  ControlPtr.ParentFont := False;
  if m_PopupUseSetAll then
    ControlPtr.PopupMenu := m_SetAllPopup
  else
    ControlPtr.PopupMenu := PopupMenu;
  ControlPtr.Top := ControlTop ;
  ControlPtr.Width := CalculateWidth() ;
  ControlPtr.OnClick := OnChangeEventHandler ;
  ControlPtr.OnContextPopup := OnContextPopupEventHandler ;
  ControlPtr.OnEnter  := OnClickEventHandler ;
  ControlPtr.OnDblClick := OnDblClickEventHandler ;
  ControlPtr.OnDropDown := OnDropDownEventHandler;
  ControlPtr.OnKeyPress := OnReturnEventHandler ;
  ControlPanel.InsertControl(ControlPtr);

  ControlList.Add(ControlPtr) ;

  // Update the height of the panel
  ControlTop := ControlTop + ControlHeight ;

  Result := ControlPtr ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Calculate the Width for a ComboBoxList control
// Inputs:       None
// Outputs:      Width as Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TComboBoxList.CalculateWidth(): Integer;
begin
  // Calculate the size of the control
  if (ControlAutoAlignment) then
    Result := ControlPanel.Width - c_WidthCorrection - (2 * BorderWidth)
  else
    Result := ControlWidth ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the control color
// Inputs:       Value: Index of Control
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TComboBoxList.ControlRecolor(Value: Integer);
var
  ControlPtr: TComboBox ;
begin
  inherited;

  // Check for valid index
  if ((Value < 0) or (Value > ControlList.Count - 1)) then
    Exit;

  ControlPtr := (ControlList.Items[Value] as TComboBox);

  // If using custom scroll box; update actual value offset by scroll box start
  if CustomScrollBoxActive then
    Value := CustomScrollBoxStartIndex + Value;

  // Set control color depending on 'Enabled' and 'Indicator' state
  if (Value = IndicatorIndex) and (Indicator) and
    (Value = SecondaryIndicatorIndex) and (SecondaryIndicator) then
  begin
    if not (ControlPtr.Enabled) then
      ControlPtr.Color := Lighter(SecondaryIndicatorColor)
    else
      ControlPtr.Color := SecondaryIndicatorColor;
    ControlPtr.Font.Color := IndicatorColor ;
  end
  else if (Value = IndicatorIndex) and (Indicator) then
  begin
    if not (ControlPtr.Enabled) then
      ControlPtr.Color := Lighter(IndicatorColor)
    else
      ControlPtr.Color := IndicatorColor;
    ControlPtr.Font.Color := IndicatorFontColor ;
  end
  else if (Value = SecondaryIndicatorIndex) and (SecondaryIndicator) then
  begin
    if not (ControlPtr.Enabled) then
      ControlPtr.Color := Lighter(SecondaryIndicatorColor)
    else
      ControlPtr.Color := SecondaryIndicatorColor;
    ControlPtr.Font.Color := SecondaryIndicatorFontColor ;
  end ;

  try
    // Needed to remove blue highlighting from previously selected item.  Try block needed for design time
    ControlPtr.SelStart := 0;
  except
  end;

end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  ReSize/ReAlign the Column.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TComboBoxList.ControlResize() ;
var
  Index: Integer ;
  ControlPtr: TComboBox ;
begin
  inherited;

  // Position the panel that holds the controls
  if (ControlAutoAlignment) then
  begin
    CenteringPanel.Width := 0 ;
  end
  else
  begin
    if (ControlAlignment = taCenter) then
    begin
      if (Width > ControlWidth) then
        CenteringPanel.Width := (Width - ControlWidth) div 2
      else
        CenteringPanel.Width := 0 ;
    end
    else if (ControlAlignment = taRightJustify) then
    begin
      CenteringPanel.Width := round(Width - ControlWidth) - c_WidthCorrection - BorderWidth;
    end
    else
    begin
      CenteringPanel.Width := 0 ;
    end ;
  end ;

  // Size the controls
  ControlTop := 0;
  for Index := 0 to ControlList.Count - 1 do
  begin
    ControlPtr := (ControlList.Items[Index] as TCombobox) ;
    ControlPtr.Font := ControlFont;
    ControlPtr.Height := ControlHeight;
    ControlPtr.Top := ControlTop;
    ControlPtr.Width := CalculateWidth() ;

    // Update the for the top of the next panel
    if ControlPtr.Visible then
      ControlTop := ControlTop + ControlHeight ;
  end ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set Focus
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TComboBoxList.SetFocus();
var
  viewIndex: Integer;
begin
  if CustomScrollBoxActive then
  begin
    viewIndex := IndicatorIndex - CustomScrollBoxStartIndex;
    if (viewIndex >= 0) and (viewIndex < CustomScrollBoxSize) then
  end
  else
    viewIndex := IndicatorIndex;

  if Control[viewIndex].CanFocus() then
    Control[viewIndex].SetFocus();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get a TComboBox control from the list.
// Inputs:       Index into list (0-Base Array)
// Outputs:      TComboBox
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TComboBoxList.GetControl(Index: Integer): TComboBox;
begin
  Assert((Index >= 0) and (Index < ControlList.Count));

  Result := (ControlList.Items[Index] as TComboBox) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  OnChange Event Handler
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TComboBoxList.OnChangeEventHandler(Sender: TObject);
begin
  if (EnableEvents) then
    m_OnChangeEvent(Sender, CustomScrollBoxStartIndex + ControlList.IndexOf(Sender)) ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  OnClick Event Handler
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TComboBoxList.OnClickEventHandler(Sender: TObject);
begin
  if (EnableEvents) then
    m_OnClickEvent(Sender, CustomScrollBoxStartIndex + ControlList.IndexOf(Sender)) ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  OnContextPopup Event Handler
// Inputs:       None
// Outputs:      None
// Note:         Call the OnClick event handler, used typically to set the list index.
//               May eventually need to expose this event, and allow for more control
//               by the application developer.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TComboBoxList.OnContextPopupEventHandler(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  if (EnableEvents) then
  begin
    m_OnClickEvent(Sender, CustomScrollBoxStartIndex + ControlList.IndexOf(Sender)) ;

    if m_PopupUseSetAll then
    begin
      // Store the sender for SetAllEventHandler().  Sender is not available when SetAllEvent is fired.
      m_SetAllSender := Sender;
    end
    else
      m_OnContextPopupEvent(Sender, MousePos, Handled, CustomScrollBoxStartIndex + ControlList.IndexOf(Sender)) ;
  end;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  OnDblClick Event Handler
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TComboBoxList.OnDblClickEventHandler(Sender: TObject);
begin
  if (EnableEvents) then
    m_OnDblClickEvent(Sender, CustomScrollBoxStartIndex + ControlList.IndexOf(Sender)) ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  OnClick Event Handler
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TComboBoxList.OnDropDownEventHandler(Sender: TObject);
begin
  if (EnableEvents) then
    m_OnDropDownEvent(Sender, CustomScrollBoxStartIndex + ControlList.IndexOf(Sender)) ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  OnReturn Event Handler
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TComboBoxList.OnReturnEventHandler(Sender: TObject; var Key: Char);
begin
  if (EnableEvents) and (Key = Char(13)) then
    m_OnReturnEvent(Sender, CustomScrollBoxStartIndex + ControlList.IndexOf(Sender)) ;
end ;

function TComboBoxList.GetControlDropDownCount: Integer;
begin
  Result := m_DropDownCount;
end;

procedure TComboBoxList.SetControlDropDownCount(const Value: Integer);
var
  Index: Integer ;
  ControlPtr: TComboBox ;
begin
  m_DropDownCount := Value;

  for Index := 0 to ControlList.Count - 1 do
  begin
    ControlPtr := (ControlList.Items[Index] as TCombobox) ;
    ControlPtr.DropDownCount := m_DropDownCount;
  end ;
end;

end.
