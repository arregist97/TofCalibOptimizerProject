unit EditList;
////////////////////////////////////////////////////////////////////////////////
// Filename:  EditList.pas
// Created:   on 00-9-6 by John Baker
// Purpose:   This module contains the TEditList component.
//            (TEditList).
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
  ExtCtrls, StdCtrls, Contnrs,
  ControlList ;

type
  TEditList = class(TControlList)
  private
    m_OnChangeEvent: TNotifyListEvent;
    m_OnClickEvent: TNotifyListEvent;
    m_OnDblClickEvent: TNotifyListEvent;
    m_OnReturnEvent: TNotifyListEvent;
    function CalculateWidth(): Integer;
    function GetControl(Index: Integer): TEdit ;

    procedure OnChangeEventHandler(Sender: TObject);
    procedure OnClickEventHandler(Sender: TObject);
    procedure OnContextPopupEventHandler(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure OnDblClickEventHandler(Sender: TObject);
    procedure OnReturnEventHandler(Sender: TObject; var Key: Char);
  public
    constructor Create(AOwner: TComponent); override ;
    function Add(): TWinControl; override;
    procedure ControlRecolor(Value: Integer); override;
    procedure ControlResize(); override;
    procedure SetFocus; override;

    property Control[Index: Integer]: TEdit read GetControl;
  published
    property OnChange: TNotifyListEvent read m_OnChangeEvent write m_OnChangeEvent ;
    property OnClick: TNotifyListEvent read m_OnClickEvent write m_OnClickEvent ;
    property OnDblClick: TNotifyListEvent read m_OnDblClickEvent write m_OnDblClickEvent ;
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
  RegisterComponents('PHI Library', [TEditList]);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Constructor to create this object.
// Inputs:       AOwner - component that owns this object.  If NIL is specified
//                        as owner, creator is responsible for destroying this
//                        object.
// Outputs:      Object
// Note:
////////////////////////////////////////////////////////////////////////////////
constructor TEditList.Create(AOwner: TComponent);
begin
  inherited;

  // Set memeber variables
  m_OnChangeEvent := EmptyEventHandler;
  m_OnClickEvent := EmptyEventHandler;
  m_OnDblClickEvent := EmptyEventHandler;
  m_OnReturnEvent := EmptyEventHandler;

  // Size the control width
  ControlWidth := 50;

  // Add a Control with no events
  Add();

  // Colorize and Size the Control
  ControlRecolor();
  ControlResize();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add control to the list of control associated to this view.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TEditList.Add(): TWinControl ;
var
  ControlPtr: TEdit ;
begin
  ControlPtr := TEdit.Create(nil) ;
  ControlPtr.Name := GetValidControlName();
  ControlPtr.BorderStyle := ControlBorderStyle;
  ControlPtr.Font := ControlFont;
  ControlPtr.Left := c_ControlLeft;
  ControlPtr.Height := ControlHeight;
  ControlPtr.ParentFont := False;
  if m_PopupUseSetAll then
    ControlPtr.PopupMenu := m_SetAllPopup
  else
    ControlPtr.PopupMenu := PopupMenu;
  ControlPtr.Top := ControlTop;
  ControlPtr.Width := CalculateWidth();
  ControlPtr.OnChange := OnChangeEventHandler ;
  ControlPtr.OnClick  := OnClickEventHandler ;
  ControlPtr.OnContextPopup := OnContextPopupEventHandler ;
  ControlPtr.OnDblClick := OnDblClickEventHandler ;
  ControlPtr.OnKeyPress := OnReturnEventHandler ;
  ControlPanel.InsertControl(ControlPtr);

  ControlList.Add(ControlPtr) ;

  // Update the for the top of the next panel
  ControlTop := ControlTop + ControlHeight ;

  Result := ControlPtr ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Calculate the Width for a EditList control
// Inputs:       None
// Outputs:      Width as Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TEditList.CalculateWidth(): Integer;
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
procedure TEditList.ControlRecolor(Value: Integer);
var
  ControlPtr: TEdit;
begin
  inherited;

  // Check for valid index
  if ((Value < 0) or (Value > ControlList.Count - 1)) then
    Exit;

  ControlPtr := (ControlList.Items[Value] as TEdit);

  // If using custom scroll box; update actual value offset by scroll box start
  if CustomScrollBoxActive then
    Value := CustomScrollBoxStartIndex + Value;

  // Set control color depending on 'Read Only' and 'Indicator' state
  if (ControlPtr.ReadOnly) then
  begin
    ControlPtr.Color := c_DisableColor ;
    ControlPtr.Font.Color := c_DisableFontColor ;
  end
  else if (Value = IndicatorIndex) and (Indicator) and
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
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Resize the control.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TEditList.ControlResize();
var
  Index: Integer ;
  ControlPtr: TEdit ;
begin
  inherited;

  // Position the panel that holds the controls
  if (ControlAutoAlignment) then
  begin
    CenteringPanel.Width := 0 ;
  end
  else
  begin
    // ReAlign the Labels
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
    ControlPtr := (ControlList.Items[Index] as TEdit) ;
    ControlPtr.BorderStyle := ControlBorderStyle;
    ControlPtr.Font := ControlFont;
    ControlPtr.Height := ControlHeight;
    ControlPtr.Top := ControlTop;
    ControlPtr.Width := CalculateWidth();

    // Update the for the top of the next panel
    ControlTop := ControlTop + ControlHeight ;
  end ;

end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set Focus
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TEditList.SetFocus();
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
// Description:  Get a TEdit control from the list.
// Inputs:       Index into list (0-Base Array)
// Outputs:      TEdit
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TEditList.GetControl(Index: Integer): TEdit;
begin
  Assert((Index >= 0) and (Index < ControlList.Count));

  Result := (ControlList.Items[Index] as TEdit) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  OnChange Event Handler
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TEditList.OnChangeEventHandler(Sender: TObject);
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
procedure TEditList.OnClickEventHandler(Sender: TObject);
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
procedure TEditList.OnContextPopupEventHandler(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
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
procedure TEditList.OnDblClickEventHandler(Sender: TObject);
begin
  if (EnableEvents) then
    m_OnDblClickEvent(Sender, CustomScrollBoxStartIndex + ControlList.IndexOf(Sender)) ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  OnReturn Event Handler
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TEditList.OnReturnEventHandler(Sender: TObject; var Key: Char);
begin
  if (EnableEvents) and (Key = Char(13)) then
    m_OnReturnEvent(Sender, CustomScrollBoxStartIndex + ControlList.IndexOf(Sender)) ;
end ;

end.
