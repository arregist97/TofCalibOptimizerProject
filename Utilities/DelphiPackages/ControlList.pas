unit ControlList;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ControlList.pas
// Created:   on 00-9-6 by John Baker
// Purpose:   This module contains the TControlList component.
//            (TControlList).
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
  ExtCtrls, StdCtrls, Contnrs, Menus;

const
  c_ControlHeight = 24 ;
  c_ControlLeft = 2 ;
  c_WidthCorrection = 4 ;

  c_DisableColor = clBtnFace;
  c_DisableFontColor = clBlack;
type
  TNotifyListEvent = procedure(Sender: TObject; Index: Integer) of object;
  TContextPopupListEvent = procedure(Sender: TObject; MousePos: TPoint; var Handled: Boolean; Index: Integer) of object;

  TControlList = class(TCustomPanel)
  private
    m_Alignment: TAlignment ;
    m_AutoSize: Boolean ;
    m_CenteringPanel: TPanel ;
    m_ControlBorderStyle: TBorderStyle;
    m_ControlColor: TColor;
    m_ControlHeight: Integer ;
    m_ControlLeft: Integer ;
    m_ControlPanel: TPanel ;
    m_ControlTop: Integer ;
    m_ControlWidth: Integer ;
    m_EnableEvents: Boolean;
    m_Font: TFont ;
    m_List: TObjectList;
    m_Indicator: Boolean ;
    m_IndicatorColor: TColor;
    m_IndicatorFontColor: TColor;
    m_IndicatorIndex: Integer ;
    m_IndicatorListSize: Integer;

    m_PreviousIndicatorIndex: Integer ;
    m_PreviousIndicatorListSize: Integer ;

    m_SecondaryIndicator: Boolean ;
    m_SecondaryIndicatorColor: TColor;
    m_SecondaryIndicatorFontColor: TColor;
    m_SecondaryIndicatorIndex: Integer ;

    m_CustomScrollBoxActive: Boolean;
    m_CustomScrollBoxStartIndex: Integer;
    m_CustomScrollBoxSize: Integer;

    m_Title: TLabel ;
    m_OnResizeEvent: TNotifyEvent;
    function GetControlAlignment: TAlignment ;
    function GetControlAutoAlignment: Boolean ;
    function GetControlBorderStyle: TBorderStyle ;
    function GetControlColor: TColor;
    function GetControlFont: TFont;
    function GetControlHeight: Integer;
    function GetControlWidth(): Integer ;
    function GetIndicatorColor: TColor;
    function GetControlIndicator(): Boolean ;
    function GetIndicatorFontColor: TColor;
    function GetSecondaryIndicator(): Boolean ;
    function GetSecondaryIndicatorColor: TColor;
    function GetSecondaryIndicatorFontColor: TColor;
    function GetMarkerLeft: Integer;
    function GetMarkerTop: Integer;
    function GetTitle: String;
    procedure SetControlAutoAlignment(const Value: Boolean) ;
    procedure SetControlBorderStyle(const Value: TBorderStyle) ;
    procedure SetControlColor(const Value: TColor);
    procedure SetControlFont(const Value: TFont);
    procedure SetControlHeight(Value: Integer);
    procedure SetControlIndicator(Value: Boolean) ;
    procedure SetControlWidth(Value: Integer) ;
    procedure SetIndicatorColor(const Value: TColor);
    procedure SetIndicatorFontColor(const Value: TColor);
    procedure SetSecondaryIndicator(Value: Boolean) ;
    procedure SetSecondaryIndicatorColor(const Value: TColor);
    procedure SetSecondaryIndicatorFontColor(const Value: TColor);
    procedure SetTitle(const Value: String);
    procedure OnResizeEventHandler(Sender: TObject);
  protected
    m_PopupUseSetAll: Boolean;
    m_SetAllPopup: TPopupMenu;
    m_SetAllSender: TObject;

    m_OnContextPopupEvent: TContextPopupListEvent;
    m_OnSetAllEvent: TNotifyListEvent;

    procedure SetEnabled(Value: Boolean); override;
    function GetValidControlName(): String;

    procedure EmptyEventHandler(Sender: TObject; Index: Integer);
    procedure EmptyPopupEventHandler(Sender: TObject; MousePos: TPoint; var Handled: Boolean; Index: Integer);
    procedure SetControlAlignment(const Value: TAlignment); virtual ;

    procedure OnSetAllEventHandler(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override ;
    destructor Destroy() ; override ;
    procedure Capacity(Value: Integer) ;
    procedure Clear() ;
    function Add(): TWinControl ; virtual; abstract ;
    procedure Delete(Value: Integer) ;
    procedure ReInitialize(Value: Integer);
    procedure ControlRecolor(); overload;
    procedure ControlRecolor(Value: Integer); overload; virtual;
    procedure ControlResize(); virtual;
    procedure SetVisibleAlignLeft(State: Boolean);
    procedure RepositionWithVisibility();
    property CenteringPanel: TPanel read m_CenteringPanel write m_CenteringPanel ;
    property ControlList: TObjectList read m_List write m_List ;
    property ControlPanel: TPanel read m_ControlPanel write m_ControlPanel ;
    property ControlTop: Integer read m_ControlTop write m_ControlTop ;
    property EnableEvents: Boolean read m_EnableEvents write m_EnableEvents ;
    property IndicatorIndex: Integer read m_IndicatorIndex write m_IndicatorIndex ;
    property SecondaryIndicatorIndex: Integer read m_SecondaryIndicatorIndex write m_SecondaryIndicatorIndex ;

    // Custom Scroll Box
    property CustomScrollBoxActive: Boolean read m_CustomScrollBoxActive write m_CustomScrollBoxActive;
    property CustomScrollBoxStartIndex: Integer read m_CustomScrollBoxStartIndex write m_CustomScrollBoxStartIndex;
    property CustomScrollBoxSize: Integer read m_CustomScrollBoxSize write m_CustomScrollBoxSize;

    procedure ToScrollBar(ScrollBar: TScrollBar);

    property MarkerTop: Integer read GetMarkerTop;
    property MarkerLeft: Integer read GetMarkerLeft;
  published
    property Align;
    property Anchors;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property Color: TColor read GetControlColor write SetControlColor;
    property ControlAlignment: TAlignment read GetControlAlignment write SetControlAlignment ;
    property ControlAutoAlignment: Boolean read GetControlAutoAlignment write SetControlAutoAlignment ;
    property ControlBorderStyle: TBorderStyle read GetControlBorderStyle write SetControlBorderStyle ;
    property ControlFont: TFont read GetControlFont write SetControlFont;
    property ControlHeight: Integer read GetControlHeight write SetControlHeight;
    property ControlLeft: Integer read m_ControlLeft write m_ControlLeft ;
    property ControlWidth: Integer read GetControlWidth write SetControlWidth ;
    property Constraints;
    property Ctl3D;
    property Indicator: Boolean read GetControlIndicator write SetControlIndicator ;
    property IndicatorColor: TColor read GetIndicatorColor write SetIndicatorColor;
    property IndicatorFontColor: TColor read GetIndicatorFontColor write SetIndicatorFontColor;
    property SecondaryIndicator: Boolean read GetSecondaryIndicator write SetSecondaryIndicator ;
    property SecondaryIndicatorColor: TColor read GetSecondaryIndicatorColor write SetSecondaryIndicatorColor;
    property SecondaryIndicatorFontColor: TColor read GetSecondaryIndicatorFontColor write SetSecondaryIndicatorFontColor;
    property Locked;
    property PopupMenu;
    property PopupUseSetAll: Boolean  read m_PopupUseSetAll write m_PopupUseSetAll ;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Title: String read GetTitle write SetTitle;
    property Visible;

    property OnContextPopup: TContextPopupListEvent read m_OnContextPopupEvent write m_OnContextPopupEvent ;
    property OnSetAll: TNotifyListEvent read m_OnSetAllEvent write m_OnSetAllEvent ;
  end;

  function Lighter(Color: TColor; Percent: Byte = 60): TColor;

implementation

uses
  System.Math;

function Lighter(Color: TColor; Percent: Byte): TColor;
var
  r, g, b: Byte;
begin
  Color := ColorToRGB(Color);
  r := GetRValue(Color);
  g := GetGValue(Color);
  b := GetBValue(Color);
  r := r + muldiv(255 - r, Percent, 100); //Percent% closer to white
  g := g + muldiv(255 - g, Percent, 100);
  b := b + muldiv(255 - b, Percent, 100);
  result := RGB(r, g, b);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Constructor to create this object.
// Inputs:       AOwner - component that owns this object.  If NIL is specified
//                        as owner, creator is responsible for destroying this
//                        object.
// Outputs:      Object
// Note:
////////////////////////////////////////////////////////////////////////////////
constructor TControlList.Create(AOwner: TComponent);
var
  setAllMenuItem: TMenuItem;
begin
  inherited;

  // Set memeber variables (private)
  m_Alignment := taCenter ;
  m_AutoSize := True ;
  m_ControlBorderStyle := bsSingle ;
  m_ControlColor := clWhite ;
  m_ControlHeight := c_ControlHeight ;
  m_ControlLeft := 0 ;
  m_ControlTop := 0 ;
  m_ControlWidth := 75;
  m_EnableEvents := False;
  m_Font := TFont.Create() ;
  m_Indicator := True ;
  m_IndicatorColor := clNavy ;
  m_IndicatorFontColor := clWhite ;
  m_IndicatorIndex := 0 ;
  m_IndicatorListSize := 0 ;

  m_PreviousIndicatorIndex := 0 ;
  m_PreviousIndicatorListSize := 0 ;

  m_SecondaryIndicator := False ;
  m_SecondaryIndicatorColor := clBtnFace ;
  m_SecondaryIndicatorFontColor := clWhite ;
  m_SecondaryIndicatorIndex := 0 ;

  m_CustomScrollBoxActive := False;
  m_CustomScrollBoxStartIndex := 0;
  m_CustomScrollBoxSize := 0;
  m_List := nil ;
  m_OnResizeEvent := OnResizeEventHandler ;

  // Set memeber variables (protected)
  m_PopupUseSetAll := False;
  m_SetAllPopup := TPopupMenu.Create(Self);
  m_SetAllPopup.Name := 'SetAllPopup';
  setAllMenuItem := TMenuItem.Create(Self);
  setAllMenuItem.Name := 'SetAllMenuItem';
  setAllMenuItem.Caption := 'Set All';
  setAllMenuItem.OnClick := OnSetAllEventHandler;
  m_SetAllPopup.Items.Add(setAllMenuItem);
  m_SetAllSender := nil;
  m_OnContextPopupEvent := EmptyPopupEventHandler;
  m_OnSetAllEvent := EmptyEventHandler;

  // Main Panel
  Width := m_ControlWidth ;
  Align := alLeft ;
  AutoSize := False ;
  OnResize := m_OnResizeEvent ;
  Font := m_Font;

  // Column Title
  m_Title := TLabel.Create(Self);
  m_Title.Name := 'TitleLabel' ;
  m_Title.Caption := 'Title' ;
  m_Title.Align := alTop ;
  m_Title.Alignment := m_Alignment ;
  m_Title.AutoSize := True ;
  m_Title.Font := m_Font;
  m_Title.Layout := tlCenter ;
  m_Title.Width := Width ;
  m_Title.Top := 0 ;
  m_Title.Left := 0;
  InsertControl(m_Title);

  // Centering Panel (empty panel used to push Labels to the right when taRightJustify, or taCenter)
  m_CenteringPanel := TPanel.Create(Self);
  m_CenteringPanel.Name := 'CenteringPanel' ;
  m_CenteringPanel.Caption := '' ;
  m_CenteringPanel.Align := alLeft ;
  m_CenteringPanel.BevelInner := bvNone ;
  m_CenteringPanel.BevelOuter := bvNone ;
  m_CenteringPanel.BorderStyle := bsNone ;
  m_CenteringPanel.BorderWidth := 0 ;
  m_CenteringPanel.Width := 0 ;
  InsertControl(m_CenteringPanel);

  // Control Panel (holds the repeating column of Labels)
  m_ControlPanel := TPanel.Create(Self);
  m_ControlPanel.Name := 'ControlPanel' ;
  m_ControlPanel.Caption := '' ;
  m_ControlPanel.Align := alClient ;
  m_ControlPanel.BevelInner := bvNone ;
  m_ControlPanel.BevelOuter := bvNone ;
  m_ControlPanel.BorderStyle := bsNone ;
  m_ControlPanel.BorderWidth := 0 ;
  InsertControl(m_ControlPanel);

  // ObjectList to hold actual Label objects
  m_List := TObjectList.Create() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TControlList.Destroy() ;
begin
  m_List.Destroy() ;
  m_Font.Free();

  inherited Destroy() ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set number of Controls (Preallocate space).
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.Capacity(Value: Integer) ;
begin
  m_List.Capacity := Value ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Clear all Controls from list.  Objects are removed and freed.
// Inputs:       None
// Outputs:      None
// Note:         m_List uses a TObjectList which takes care of cleaning up after objects
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.Clear() ;
begin
  m_List.Clear;

  m_IndicatorIndex := 0;
  m_IndicatorListSize := 0 ;
  m_PreviousIndicatorIndex := 0 ;
  m_PreviousIndicatorListSize := 0 ;
  m_SecondaryIndicatorIndex := 0;

  m_CustomScrollBoxStartIndex := 0;
  m_CustomScrollBoxSize := 0;

  m_ControlTop := 0;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Recolor the control.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.ControlRecolor();
var
  Index: Integer ;
begin
  for Index := 0 to ControlList.Count - 1 do
    ControlRecolor(Index);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Recolor the control.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.ControlRecolor(Value: Integer);
begin
  // Override in derived class
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Resize the control.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.ControlResize;
begin
  if (m_Font.Size <= 8) then
    m_ControlHeight := 24
  else if (m_Font.Size = 10) then
    m_ControlHeight := 28
  else if (m_Font.Size = 12) then
    m_ControlHeight := 33
  else
    m_ControlHeight := 37;

  // Resize the title
  m_Title.Font := m_Font;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Remove a Controls from list.  Objects is removed and freed.
// Inputs:       Index
// Outputs:      None
// Note:         m_List uses a TObjectList which takes care of cleaning up after objects
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.Delete(Value: Integer) ;
begin
  // Remove the Control if in the list, otherwise do nothing
  m_List.Delete(Value) ;

  // Update the for the top of the next panel
  m_ControlTop := m_ControlTop - m_ControlHeight ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Resize the control list if needed.
// Inputs:       Number of Controls
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.ReInitialize(Value: Integer) ;
var
  bScrollInView: Boolean;
begin
  m_IndicatorListSize := Value;

  bScrollInView := False;

  // Check if the size has changed
  if m_IndicatorListSize <> m_PreviousIndicatorListSize then
    bScrollInView := True;
  m_PreviousIndicatorListSize := m_IndicatorListSize;

  // Check if the current item highlighted has changed
  if m_IndicatorIndex <> m_PreviousIndicatorIndex then
    bScrollInView := True;
  m_PreviousIndicatorIndex := m_IndicatorIndex;

  if m_CustomScrollBoxActive then
  begin
    // Custom scroll box is used to limit the number of controls to only those displayed
    m_CustomScrollBoxSize := min(round(Height / ControlHeight) - 1, m_IndicatorListSize) ;

    // Set the start index
    if ((m_CustomScrollBoxStartIndex + m_CustomScrollBoxSize) >= m_IndicatorListSize) then
      m_CustomScrollBoxStartIndex := max(m_IndicatorListSize - m_CustomScrollBoxSize, 0);

    // Check ScrollInView; only supported for custom scroll box
    if bScrollInView then
    begin
      if (m_IndicatorIndex < m_CustomScrollBoxStartIndex) or (m_IndicatorIndex > (m_CustomScrollBoxStartIndex + m_CustomScrollBoxSize - 1)) then
      begin
        m_CustomScrollBoxStartIndex := m_IndicatorIndex;

        // Recheck the start index
        if ((m_CustomScrollBoxStartIndex + m_CustomScrollBoxSize) >= m_IndicatorListSize) then
          m_CustomScrollBoxStartIndex := max(m_IndicatorListSize - m_CustomScrollBoxSize, 0);
      end;
    end;
  end
  else
  begin
    // Display all the controls and let the Delphi build in scroll box handle display
    m_CustomScrollBoxSize := m_IndicatorListSize;
    m_CustomScrollBoxStartIndex := 0;
  end;

  // Manage the current list of controls
  if (m_CustomScrollBoxSize <= 0) then
  begin
    // Empty Control List
    Clear();
  end
  else if (m_CustomScrollBoxSize > m_List.Count) then
  begin
    // Increase size of Control List
    Capacity(m_CustomScrollBoxSize) ;
    while (m_CustomScrollBoxSize > m_List.Count) do
      Add();
  end
  else if (m_CustomScrollBoxSize < m_List.Count) then
  begin
    // Decrease size of Control List
    while (m_CustomScrollBoxSize < m_List.Count) do
      Delete(m_List.Count - 1);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the column alignment.
// Inputs:       None
// Outputs:      TAlignment (taLeftJustify, taRightJustify, taCenter)
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetControlAlignment: TAlignment;
begin
  Result := m_Alignment ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Auto Size state.
// Inputs:       None
// Outputs:      Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetControlAutoAlignment: Boolean;
begin
  Result := m_AutoSize ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the border style.
// Inputs:       None
// Outputs:      Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetControlBorderStyle: TBorderStyle;
begin
  Result := m_ControlBorderStyle ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Control Color
// Inputs:       None
// Outputs:      TColor
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetControlColor: TColor;
begin
  Result := m_ControlColor ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Control Font.
// Inputs:       None
// Outputs:      TFont
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetControlFont: TFont;
begin
  Result := m_Font ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Control Height.
// Inputs:       None
// Outputs:      Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetControlHeight: Integer;
begin
  Result := m_ControlHeight ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Indicator state, which is used to represent the current control.
// Inputs:       None
// Outputs:      State: Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetControlIndicator: Boolean;
begin
  Result := m_Indicator ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Control Width.
// Inputs:       None
// Outputs:      Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetControlWidth: Integer;
begin
  Result := m_ControlWidth ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Control Indicator Color (Background)
// Inputs:       None
// Outputs:      TColor
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetIndicatorColor: TColor;
begin
  Result := m_IndicatorColor ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Control Indicator Font Color (Foreground)
// Inputs:       None
// Outputs:      TColor
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetIndicatorFontColor: TColor;
begin
  Result := m_IndicatorFontColor ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Secondary Indicator state, which is used to represent other information (e.g. AutoTool run position).
// Inputs:       None
// Outputs:      State: Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetSecondaryIndicator: Boolean;
begin
  Result := m_SecondaryIndicator ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Secondary Indicator Color (Background)
// Inputs:       None
// Outputs:      TColor
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetSecondaryIndicatorColor: TColor;
begin
  Result := m_SecondaryIndicatorColor ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Secondary Indicator Font Color (Foreground)
// Inputs:       None
// Outputs:      TColor
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetSecondaryIndicatorFontColor: TColor;
begin
  Result := m_SecondaryIndicatorFontColor ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get Marker Left
// Inputs:       None
// Outputs:      Integer
// Note:         Used to activate scroll bar
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetMarkerLeft: Integer;
begin
  Result := Left + Width + 1;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get Marker Top
// Inputs:       None
// Outputs:      Integer
// Note:         Used to activate scroll bar
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetMarkerTop: Integer;
begin
  Result := Top + m_Title.Height + m_ControlTop + 1;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get colunn Title.
// Inputs:       None
// Outputs:      String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TControlList.GetTitle: String;
begin
  Result := m_Title.Caption ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the column alignment.
// Inputs:       TAlignment (taLeftJustify, taRightJustify, taCenter)
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetControlAlignment(const Value: TAlignment);
begin
  m_Alignment := Value ;
  m_Title.Alignment := m_Alignment ;

  // Update column positioning
  ControlResize() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Auto Size state.
// Inputs:       Boolean
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetControlAutoAlignment(const Value: Boolean);
begin
  m_AutoSize := Value ;

  // Update column positioning
  ControlResize() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the border style.
// Inputs:       Boolean
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetControlBorderStyle(const Value: TBorderStyle);
begin
  m_ControlBorderStyle := Value ;

  // Update column positioning
  ControlResize() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Control Color
// Inputs:       TColor
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetControlColor(const Value: TColor);
begin
  m_ControlColor := Value ;

  // Update control color
  ControlRecolor() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Control Font
// Inputs:       TFont
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetControlFont(const Value: TFont);
begin
  m_Font.Assign(Value);

  // Update column positioning
  ControlResize() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Control Height.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetControlHeight(Value: Integer);
begin
  m_ControlHeight := Value ;

  // Update column positioning
  ControlResize() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Indicator state, which is used to represent the current control.
// Inputs:       State: Boolean
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetControlIndicator(Value: Boolean);
begin
  m_Indicator := Value ;

  // Update control color
  ControlRecolor() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Control Width.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetControlWidth(Value: Integer);
begin
  m_ControlWidth := Value ;

  // Update column positioning
  ControlResize() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Indicator Color (Background)
// Inputs:       TColor
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetIndicatorColor(const Value: TColor);
begin
  m_IndicatorColor := Value ;

  // Update control color
  ControlRecolor() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Indicator Font Color  (Foreground)
// Inputs:       TColor
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetIndicatorFontColor(const Value: TColor);
begin
  m_IndicatorFontColor := Value ;

  // Update control color
  ControlRecolor() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Secondary Indicator state, which is used to represent the current control.
// Inputs:       State: Boolean
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetSecondaryIndicator(Value: Boolean);
begin
  m_SecondaryIndicator := Value ;

  // Update control color
  ControlRecolor() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Secondary Indicator Color (Background)
// Inputs:       TColor
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetSecondaryIndicatorColor(const Value: TColor);
begin
  m_SecondaryIndicatorColor := Value ;

  // Update control color
  ControlRecolor() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Secondary Indicator Font Color  (Foreground)
// Inputs:       TColor
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetSecondaryIndicatorFontColor(const Value: TColor);
begin
  m_SecondaryIndicatorFontColor := Value ;

  // Update control color
  ControlRecolor() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set column Title.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetTitle(const Value: String);
begin
  m_Title.Caption := Value ;
  if (m_Title.Caption = '-1') then
    m_Title.Visible := False
  else
    m_Title.Visible := True ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the visible state of the control.  Use instead of Visible
//               property to maintain list order.
// Inputs:       State as Boolean (True-Visible, False-Not Visible)
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.SetVisibleAlignLeft(State: Boolean);
begin
  if State then
  begin
    Visible := True;
    Left := 1280;
    Align := alLeft;
  end
  else
  begin
    Visible := False;
    Align := alNone;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Reposition controls in the Column only showing those visible.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.RepositionWithVisibility() ;
var
  Index: Integer ;
  ControlPtr: TControl ;
begin
  // Reposition the controls
  ControlTop := 0;
  for Index := 0 to ControlList.Count - 1 do
  begin
    ControlPtr := (ControlList.Items[Index] as TControl) ;
    ControlPtr.Top := ControlTop;

    // Update the for the top of the next panel
    if ControlPtr.Visible then
      ControlTop := ControlTop + ControlHeight ;
  end ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  OnResize Event Handler
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.OnResizeEventHandler(Sender: TObject);
begin
  // Update column positioning
  ControlResize() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  OnClick Event Handler
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.OnSetAllEventHandler(Sender: TObject);
begin
  if (EnableEvents) then
    m_OnSetAllEvent(m_SetAllSender,  CustomScrollBoxStartIndex + ControlList.IndexOf(m_SetAllSender)) ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Empty Event Handler
// Inputs:       None
// Outputs:      None
// Note:         Events defaulted to this are to be set by application
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.EmptyEventHandler(Sender: TObject; Index: Integer);
begin
  // Events defaulted to this are to be set by application
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default Context Popup Event Handler
// Inputs:       None
// Outputs:      None
// Note:         Events defaulted to this are to be set by application
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.EmptyPopupEventHandler(Sender: TObject; MousePos: TPoint; var Handled: Boolean; Index: Integer);
begin
  // Events defaulted to this are to be set by application
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in ScrollBar parameters.
// Inputs:       TScrollBar
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TControlList.ToScrollBar(ScrollBar: TScrollBar) ;
begin
  try
    // Check if scrollbar is needed (list is greater than page size)
    if (m_IndicatorListSize > m_CustomScrollBoxSize) then
    begin
      ScrollBar.Min := 0;
      ScrollBar.PageSize := 0;
      ScrollBar.Position := 0;
      ScrollBar.Max := m_IndicatorListSize - 1;

      ScrollBar.PageSize := min(m_CustomScrollBoxSize, m_IndicatorListSize);
      ScrollBar.Position := max(m_CustomScrollBoxStartIndex, 0);

      ScrollBar.SmallChange := 1;
      ScrollBar.LargeChange := ScrollBar.PageSize - 1;

      ScrollBar.Visible := True;
    end
    else
    begin
      ScrollBar.Visible := False;
    end;
  except
  end;
end;

procedure TControlList.SetEnabled(Value: Boolean);
begin
  // Change title look only; control container remains active to show hint while individual list items are disabled
  if Value then
    m_Title.Font.Color := clWindowText
  else
    m_Title.Font.Color := clSilver;
end;

function TControlList.GetValidControlName(): String;
begin
  Result := Name + '_Row' + IntToStr(ControlList.Count + 1);
end;

end.
