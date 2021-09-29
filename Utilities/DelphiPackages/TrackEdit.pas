unit TrackEdit;
////////////////////////////////////////////////////////////////////////////////
// Filename:  TrackEdit.pas
// Created:   June 2010
// Purpose:   This module models much of the RealEdit behavior, in the slider bar.
//            (TTrackEdit).
//
// History:     June 23, 2010 Initial version
//              - John Baker
//
//*****************************************************************************************************
// Copyright © 1998-2010 Physical Electronics, Inc.
// Created in 2010 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons;

const
  c_lSuccess = Integer($00FF0000);
  c_lFailure = Integer($80FF0000);
  c_lDataValueNotInRange = Integer($00000001);
  c_lAppFailure = Integer($80000000);

  c_dInitialIncrement = 1.0;

  c_nButtonWidth = 20;
  c_nButtonHeight = 16;

type
////////////////////////////////////////////////////////////////////////////////
//
// Classes declared in this file
//
//  TTrackBar
      TTrackBarMouseWheel = class;
//  TPanel
      TTrackEdit = class;
//
////////////////////////////////////////////////////////////////////////////////

  TTrackBarMouseWheel = class(TTrackBar)
  private
    m_TrackEdit: TTrackEdit;
    procedure HandleSliderChangedEvent(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HandleMouseWheelEvent(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  protected
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TTrackEditChanged =
    procedure(ASender: TObject; dCtrlValue: Double) of object;
  TTrackEditOtherDimensionSlewed =
    procedure(ASender: TObject; dNumberOfIncrements: Double) of object;
  TTrackEditSlewed =
    procedure(ASender: TObject; dCtrlValue: Double; dNumberOfIncrements: Double) of object;

  TTrackEdit = class(TPanel)
  private
    m_dMinimum: Double;            // minimum and maximum define the valid range for edit control
    m_dMaximum: Double;
    m_dIncrement: Double;          // basic increment/decrement interval for slew, arrow keys
    m_nWidth: Integer;             // Edit box width
    m_nJustification: Integer;     // how to justify label?
                                   // 0 means left justified; 1 means right justified;  otherwise align to top
    m_nPrecision: Integer;         // how many decimal points
    m_dDefaultValue: Double;
    m_bEnabled: Boolean;           // Enabled
    m_bReadOnly: Boolean;          // Read Only
    m_bHorizontalArrows: Boolean;  // if true, use left/right arrows instead of up/down arrows to slew
    m_dSlewMultiplier: Double;     // multiplier for slew; special keys like shift and control can alter slewing rate
    m_bSkipChangedEventWhenSlew: Boolean; // skip fire changed event when slewing; that is for clients that
                                   // don't want to handle both on changed and on slew event
    m_bChangedEventOnSlider: Boolean;// fire changed event on slider; always fire on slider mouse up

    m_dCtrlValue: Double;          // last valid value for control
    m_TrackBar: TTrackBar;
    m_UpButton: TSpeedButton;
    m_DownButton: TSpeedButton;

    m_bValueValid: Boolean;        // control value is currently within range?
    m_bHasFocus: boolean;          // control has focus?
    m_bLockRefresh: boolean;       // lock refresh?

    // event handlers
    m_OnChanged: TTrackEditChanged;
    m_OnOtherDimensionSlewed: TTrackEditOtherDimensionSlewed;
    m_OnEnter: TNotifyEvent;
    m_OnExit:  TNotifyEvent;
    m_OnSlewed: TTrackEditSlewed;
    m_OnKeyDown: TKeyEvent;
    m_OnKeyUp: TKeyEvent;

    procedure FireChanged(dCtrlValue: Double);
    procedure FireSetFocus;
    procedure FireKillFocus;
    procedure FireOtherDimensionSlewed(dNumberOfIncrements: Double);
    procedure FireSlewed(dCtrlValue: Double; dNumberOfIncrements: Double);

    function  GetOnDelete: TNotifyEvent;
    procedure SetOnDelete(const Value: TNotifyEvent);
    procedure SetValue(dNewValue: Double; bFireOnChangedEvent: Boolean);

    procedure EditChanging(Sender: TObject);
    procedure UpButtonClick(Sender: TObject);
    procedure DownButtonClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure VerticalSlewValue(dNumberOfIncrements: Double);
    procedure HorizontalSlewValue(dNumberOfIncrements: Double);
    procedure SetSlewMultiplier(dMultiplier: Double);
    procedure UpdateToolTip;
    function  FormatRealEditString(dValue: Double): string;

    procedure UpdateAll();
    procedure UpdateData(dValue: Double);
    procedure UpdateEditColor();
    procedure UpdateEditSize();

    function GetOrientation: TTrackBarOrientation;
    procedure SetOrientation(const Value: TTrackBarOrientation);
    procedure SetMinimum(dMinimum: Double);
    procedure SetMaximum(dMaximum: Double);
    procedure SetIncrement(dIncrement: Double);
    procedure SetControlWidth(Width: Integer);
    procedure SetJustification(Justification: Integer);
    procedure SetPrecision(nPrecision: Integer);
    procedure SetDefaultValue(DefaultValue: Double);
    procedure SetReadOnly(bReadOnly: Boolean);
    procedure SetHorizontalArrows(HorizontalArrows: Boolean);
    function TrackBarToData(Value: Integer): Double;
    function DataToTrackBar(Value: Double): Integer;

  protected
    procedure Resize(); override;
    procedure SetEnabled(bEnabled: Boolean); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override ;

    function SetDataValue(var Status: Integer; dNewValue: Double): Integer;
    function SetDataRange(var Status: Integer; dMinimum, dMaximum: Double): Integer;
    function GetDataValue(var Status: Integer; var dDataValue: Double): Integer;
	  function Slewed(var Status: Integer; dNumberOfIncrements: Double): Integer;
    procedure SetLockRefresh(bLock: Boolean);
    procedure SetFocus(); override ;
    function Focused(): Boolean; override ;
    procedure EditChangeComplete();

  published
    property Align;
    property Orientation: TTrackBarOrientation read GetOrientation write SetOrientation ;
    property PopupMenu;
    property OnContextPopup;
    property ShowHint;
    property Visible;
    property Minimum: Double read m_dMinimum write SetMinimum;
    property Maximum: Double read m_dMaximum write SetMaximum;
    property Increment: Double read m_dIncrement write SetIncrement;
    property ControlWidth: integer read m_nWidth write SetControlWidth;
    property Justification: Integer read m_nJustification write SetJustification;
    property Precision: Integer read m_nPrecision write SetPrecision;
    property DefaultValue: Double read m_dDefaultValue write SetDefaultValue;
    property Enabled: Boolean read m_bEnabled write SetEnabled;
    property ReadOnly: Boolean read m_bReadOnly write SetReadOnly;
    property HorizontalArrows: Boolean read m_bHorizontalArrows write SetHorizontalArrows;
    property SkipChangedEventWhenSlew: Boolean read m_bSkipChangedEventWhenSlew write m_bSkipChangedEventWhenSlew;
    property ChangedEventOnSlider: Boolean read m_bChangedEventOnSlider write m_bChangedEventOnSlider;

    property OnChanged: TTrackEditChanged read m_OnChanged write m_OnChanged;
    property OnOtherDimensionSlewed: TTrackEditOtherDimensionSlewed
      read m_OnOtherDimensionSlewed write m_OnOtherDimensionSlewed;
    property OnSlewed: TTrackEditSlewed read m_OnSlewed write m_OnSlewed;
    property OnDelete: TNotifyEvent read GetOnDelete write SetOnDelete;
    property OnKeyDown: TKeyEvent read m_OnKeyDown write m_OnKeyDown;
    property OnKeyUp: TKeyEvent read m_OnKeyUp write m_OnKeyUp;
    property OnSetFocus: TNotifyEvent read m_OnEnter write m_OnEnter ;
    property OnKillFocus: TNotifyEvent read m_OnExit write m_OnExit ;
  end;

procedure Register;

implementation
{$R TRACKEDIT.RES }

procedure Register;
begin
  RegisterComponents('PHI Library', [TTrackEdit]);
end;

////////////////////////////////////////////////////////////////////////////////
// TTrackEdit
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Description: Constructor
// Inputs:  AOwner -
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
constructor TTrackEdit.Create(AOwner: TComponent);
begin
  inherited;

  // Main Panel
  Width := 35;
  Height := 153;
  Align := alNone ;
  BorderWidth := 0;
  BevelOuter := bvRaised;
  BevelWidth := 2;
  Font.Size := 8 ;
  Font.Name := 'MS Sans Serif' ;
  Color := clWhite;

  m_dMinimum := -100.0 ;
  m_dMaximum := 100.0 ;
  m_dIncrement := 1.0 ;
  m_nWidth := 12 ;
  m_nJustification := 1 ;
  m_nPrecision := 0 ;
  m_dDefaultValue := 0.0 ;
  m_bEnabled := True ;
  m_bReadOnly := False ;
  m_bHorizontalArrows := False ;
  m_dSlewMultiplier := 1.0 ;
  m_bSkipChangedEventWhenSlew := False;
  m_bChangedEventOnSlider := True;

  m_bValueValid := True ;
  m_bHasFocus := False;
  m_bLockRefresh := False;

  // up button
  m_UpButton := TSpeedButton.Create(Self);
  m_UpButton.Name := 'UpButton';
  m_UpButton.Align := alTop ;
  m_UpButton.Height := c_nButtonHeight;
  m_UpButton.OnClick := UpButtonClick;
  m_UpButton.Glyph.LoadFromResourceName(HInstance,'TRACKEDIT_PLUS');
  InsertControl(m_UpButton);

  // down button
  m_DownButton := TSpeedButton.Create(Self);
  m_DownButton.Name := 'DownButton';
  m_DownButton.Align := alBottom ;
  m_DownButton.Height := c_nButtonHeight;
  m_DownButton.OnClick := DownButtonClick;
  m_DownButton.Glyph.LoadFromResourceName(HInstance,'TRACKEDIT_MINUS');
  InsertControl(m_DownButton);

  // track bar
  m_TrackBar := TTrackBarMouseWheel.Create(Self);
  m_TrackBar.Name := 'TrackBox';
  m_TrackBar.Align := alClient ;
  m_TrackBar.Orientation := trVertical ;
  m_TrackBar.ThumbLength := m_nWidth ;
  m_TrackBar.TickMarks := tmBoth ;
  m_TrackBar.Min := 0 ;
  m_TrackBar.Max := 1000 ;
  m_TrackBar.Frequency := Round((m_TrackBar.Max - m_TrackBar.Min) / 10) ;
  m_TrackBar.OnChange := EditChanging ;
  m_TrackBar.OnKeyPress := EditKeyPress ;
  m_TrackBar.OnKeyDown := EditKeyDown ;
  m_TrackBar.OnKeyUp := EditKeyUp ;
  m_TrackBar.OnEnter := EditEnter ;
  m_TrackBar.OnExit := EditExit ;
  m_TrackBar.OnContextPopup := OnContextPopup ;
  InsertControl(m_TrackBar);
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Destructor
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
destructor TTrackEdit.Destroy;
begin
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Key press event handler for edit box
// Inputs:  Sender - not used
//          Key - which key is released
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.EditChanging(Sender: TObject);
var
  dValue: Double;
begin
  // proceed only if control is enabled and not read-only
  if (m_bEnabled) and (not m_bReadOnly) and (m_bChangedEventOnSlider = True) then
  begin
    try
      dValue := TrackBarToData(m_TrackBar.Position);
      SetValue(dValue, True);
    except
      SetValue(m_dCtrlValue, True);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Fire changed event
// Inputs:  dCtrlValue - new control value
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.EditChangeComplete();
var
  dValue: Double;
begin
  // proceed only if control is enabled and not read-only
  if (m_bEnabled) and (not m_bReadOnly) and (m_bChangedEventOnSlider = False) then
  begin
    try
      dValue := TrackBarToData(m_TrackBar.Position);
      SetValue(dValue, True);
    except
      SetValue(m_dCtrlValue, True);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Key press event handler for edit box
// Inputs:  Sender - not used
//          Key - which key is released
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.UpButtonClick(Sender: TObject);
var
  Status: Integer;
begin
  // handle event only if control is enabled and there is a parent (RealEdit) to do the job
  if (Enabled) then
  begin
    Slewed(Status, 1.0)
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Key press event handler for edit box
// Inputs:  Sender - not used
//          Key - which key is released
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.DownButtonClick(Sender: TObject);
var
  Status: Integer;
begin
  // handle event only if control is enabled and there is a parent (RealEdit) to do the job
  if (Enabled) then
  begin
    Slewed(Status, -1.0)
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Event handler for edit box's OnEnter event
// Inputs:  Sender - not used
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.EditEnter(Sender: TObject);
begin
  // proceed only if control is enabled and not read-only
  if (m_bEnabled) and (not m_bReadOnly) then
  begin
    m_bHasFocus := True ;

    // reset slew multiplier value
    m_dSlewMultiplier := 1.0;

    // fire get focus event
    FireSetFocus ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Event handler for edit box's OnExit event
// Inputs:  Sender - not used
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.EditExit(Sender: TObject);
begin
  // proceed only if control is enabled and not read-only
  if (m_bEnabled) and (not m_bReadOnly) then
  begin
    // reset slew multiplier value
    m_dSlewMultiplier := 1.0;

    if (m_bHasFocus) then
    begin
      m_bHasFocus := False ;

      // fire lose focus event
      FireKillFocus ;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Key down event handler for edit box
// Inputs:  Sender - not used
//          Key - which key is pressed
//          Shift -  state of Alt, Ctrl, and Shift keys and the mouse buttons
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  bHit: Boolean ;
begin
  if Assigned(m_OnKeyDown) then
    m_OnKeyDown(self, Key, Shift) ;

  // proceed only if control is enabled and not read-only
  if (m_bEnabled) and (not m_bReadOnly) then
  begin
    bHit := False ;
    if (Key = VK_UP) then              // up arrow has been pressed
    begin
      // we're slewing
      VerticalSlewValue(1.0) ;
      bHit := True ;
    end
    else if (Key = VK_DOWN) then       // down arrow has been pressed
    begin
      // we're slewing
      VerticalSlewValue(-1.0) ;
      bHit := True ;
    end
    else if (Key = VK_RIGHT) then      // right arrow has been pressed
    begin
      // we're slewing
      HorizontalSlewValue(1.0) ;
      bHit := True ;
    end
    else if (Key = VK_LEFT) then       // left arrow has been pressed
    begin
      // we're slewing
      HorizontalSlewValue(-1.0) ;
      bHit := True ;
    end
    else if (Key = VK_SHIFT) then      // shift has been pressed
    begin
      SetSlewMultiplier(10.0) ;
      bHit := True ;
    end
    else if (Key = VK_CONTROL) then    // control has been pressed
    begin
      SetSlewMultiplier(0.1) ;
      bHit := True ;
    end ;

    // clear out character and pass the rest on
    if (bHit) then
    begin
      Key := 0;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Key press event handler for edit box (Not Implemented)
// Inputs:  Sender - not used
//          Key - which key is released
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.EditKeyPress(Sender: TObject; var Key: Char);
begin
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Key up event handler for edit box
// Inputs:  Sender - not used
//          Key - which key is released
//          Shift -  state of Alt, Ctrl, and Shift keys and the mouse buttons
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  bHit: Boolean ;
begin
  if Assigned(m_OnKeyUp) then
    m_OnKeyUp(self, Key, Shift) ;

  // proceed only if control is enabled and not read-only
  if (m_bEnabled) and (not m_bReadOnly) then
  begin
    bHit := False ;
    if (Key = VK_SHIFT) then      // shift has been released
    begin
      SetSlewMultiplier(1.0) ;
      bHit := True ;
    end
    else if (Key = VK_CONTROL) then    // control has been released
    begin
      SetSlewMultiplier(1.0) ;
      bHit := True ;
    end ;

    // clear out character and pass the rest on
    if (bHit) then
    begin
      Key := 0;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Resize the control
// Inputs:  None
// Outputs: None
//////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.Resize();
begin
  inherited;

  UpdateEditSize();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Return the delelt event (Not Implemented)
// Inputs:  None
// Outputs: None
//////////////////////////////////////////////////////////////////////////////////
function TTrackEdit.GetOnDelete: TNotifyEvent;
begin
  Result := nil;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set the delelt event (Not Implemented)
// Inputs:  None
// Outputs: None
//////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetOnDelete(const Value: TNotifyEvent);
begin
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Get TrackBar alignment
// Inputs:  None
// Outputs: None
//////////////////////////////////////////////////////////////////////////////////
function TTrackEdit.GetOrientation: TTrackBarOrientation;
begin
  Result := m_TrackBar.Orientation ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set TrackBar alignment
// Inputs: trHorizontal, trVertical
// Outputs: None
//////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetOrientation(const Value: TTrackBarOrientation);
begin
  if Value = trHorizontal then
  begin
    m_DownButton.Align := alLeft;
    m_DownButton.Width := c_nButtonWidth;

    m_UpButton.Align := alRight;
    m_UpButton.Width := c_nButtonWidth;
  end
  else
  begin
    m_DownButton.Align := alBottom;
    m_DownButton.Height := c_nButtonHeight;

    m_UpButton.Align := alTop;
    m_UpButton.Height := c_nButtonHeight;
  end;

  m_TrackBar.Orientation := Value ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set TrackBar width
// Inputs:  Width - new width
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetControlWidth(Width: Integer);
begin
  m_nWidth := Width ;

  UpdateEditSize();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set data value.
// Inputs:  dNewValue - new value
// Outputs: Status - successful in setting requested value?
////////////////////////////////////////////////////////////////////////////////
function TTrackEdit.SetDataValue(var Status: Integer; dNewValue: Double): Integer;
begin
  Result := c_lSuccess;
  Status := S_OK;

  UpdateData(dNewValue);
  if (not m_bValueValid) then
  begin
    Result := c_lFailure or c_lDataValueNotInRange;
    Status := c_lAppFailure;
  end ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Get data value.
// Inputs:  None
// Outputs: Status - successful in setting requested value?
//          dDataValue - current data value
// Return:
////////////////////////////////////////////////////////////////////////////////
function TTrackEdit.GetDataValue(var Status: Integer; var dDataValue: Double): Integer;
begin
  result := c_lSuccess;
  Status := S_OK;

  dDataValue := m_dCtrlValue ;
  if (not m_bValueValid) then
  begin
    result := c_lFailure or c_lDataValueNotInRange;
    Status := c_lAppFailure;
  end ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set data range.
// Inputs:  dMinimum, dMaximum - new min and max values
// Outputs: Status - successful in setting new range?
////////////////////////////////////////////////////////////////////////////////
function TTrackEdit.SetDataRange(var Status: Integer; dMinimum, dMaximum: Double): Integer;
begin
  Result := c_lSuccess;
  Status := S_OK;

  m_dMinimum := dMinimum;
  m_dMaximum := dMaximum;

  UpdateData(m_dCtrlValue);

  if (not m_bValueValid) then
  begin
    result := c_lFailure or c_lDataValueNotInRange;
    Status := c_lAppFailure;
  end ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Do a slew.
// Inputs:  dNumberOfIncrements - how many increments to slew
// Outputs: Status - successful in setting new range?
////////////////////////////////////////////////////////////////////////////////
function TTrackEdit.Slewed(var Status: Integer; dNumberOfIncrements: Double): Integer;
begin

  // proceed only if control is enabled and not read-only
  if (m_bEnabled) and (not m_bReadOnly) then
  begin
    if (m_bHorizontalArrows) then
      HorizontalSlewValue(dNumberOfIncrements)
    else
      VerticalSlewValue(dNumberOfIncrements);
  end;

  Status := S_OK;
  Result := c_lSuccess;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Lock all method calls that would cause a control resize
// Inputs:
// Outputs:
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetLockRefresh(bLock: Boolean);
begin
  m_bLockRefresh := bLock;

  if not m_bLockRefresh then
  begin
    UpdateAll();
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set the default data value
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetDefaultValue(DefaultValue: Double);
begin
  m_dDefaultValue := DefaultValue ;

  SetValue(m_dDefaultValue, False);
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set focus
// Inputs:  Boolean
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetFocus();
begin
  // proceed only if control is enabled and not read-only
  if (m_bEnabled) and (not m_bReadOnly) then
  begin
    m_TrackBar.SetFocus();
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Focused
// Inputs:  None
// Outputs: Boolean
////////////////////////////////////////////////////////////////////////////////
function TTrackEdit.Focused(): Boolean;
begin
  Result := m_TrackBar.Focused();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set the option to use left/right instead of up/down arrows to slew.
// Inputs:  HorizontalArrows - if true, use left/right arrows to slew
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetHorizontalArrows(HorizontalArrows: Boolean);
begin
  m_bHorizontalArrows := HorizontalArrows ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set increment value
// Inputs:  Increment - requested increment value
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetIncrement(dIncrement: Double);
begin
  m_dIncrement := dIncrement ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set label justification to edit box
// Inputs:  Justification - new justification mode
//           0 means left justified; 1 means right justified;  otherwise align to top
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetJustification(Justification: Integer);
begin
  m_nJustification := Justification ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set maximum value
// Inputs:  dMaximum - new maximum value
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetMaximum(dMaximum: Double);
begin
  m_dMaximum := dMaximum ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set minimum value
// Inputs:  dMinimum - new minimum value
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetMinimum(dMinimum: Double);
begin
  m_dMinimum := dMinimum ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set precision.
// Inputs:  nPrecision - number of precision.
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetPrecision(nPrecision: Integer);
begin
  m_nPrecision := nPrecision ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set enabled mode
// Inputs:  bEnabled - true for enabled
// Outputs: None//
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetEnabled(bEnabled: Boolean);
begin
  m_bEnabled := bEnabled ;

  UpdateEditColor();
  UpdateToolTip();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set read-only mode
// Inputs:  bReadOnly - true for read-only
// Outputs: None//
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetReadOnly(bReadOnly: Boolean);
begin
  m_bReadOnly := bReadOnly ;

  UpdateEditColor();
  UpdateToolTip();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set real edit value and have the option to fire on changed event.
// Inputs:  dNewValue - new control value
//          bFireOnChangedEvent - whether to fire on changed event
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetValue(dNewValue: Double; bFireOnChangedEvent: Boolean);
var
  dTrialValue: Double;
  bEnable: Boolean;
begin
  try
    dTrialValue := dNewValue;

    // check for valid range
    if ((dTrialValue < m_dMinimum) or (dTrialValue > m_dMaximum)) then
    begin
      m_bValueValid := False;
    end
    else  // valid
    begin
      m_bValueValid := True;

      // Save the previous enable state
      bEnable := m_bEnabled;

      // Clear enabled state which will suppress callbacks when setting position
      m_bEnabled := False;
      m_TrackBar.Position := DataToTrackBar(dTrialValue) ;
      m_bEnabled := bEnable;

      // if the value has changed
      if (dTrialValue <> m_dCtrlValue) then
      begin
        m_dCtrlValue := dTrialValue;

        if (bFireOnChangedEvent) then
          FireChanged(m_dCtrlValue);
      end;
    end;

    UpdateEditColor()
  except
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Convert track bar data to data scale.
// Inputs:  Value - track bar value (integer)
// Outputs: Data Value
////////////////////////////////////////////////////////////////////////////////
function TTrackEdit.TrackBarToData(Value: Integer): Double;
var
  dataRange: Double;
  dataPosition: Double;
  trackBarRange: Integer;
  trackBarPosition: Double;
begin
  trackBarRange := m_TrackBar.Max - m_TrackBar.Min;
  dataRange := m_dMaximum - m_dMinimum;

  // TrackBar vertical orientation is inverted of what is expected (top-min; bottom-max); Invert this.
  if ((Orientation = trVertical) and (m_dIncrement > 0)) or
    ((Orientation = trHorizontal) and (m_dIncrement < 0))  then
    Value := trackBarRange - Value;
  trackBarPosition := (Value - m_TrackBar.Min) / trackBarRange;

  dataPosition :=  m_dMinimum + (trackBarPosition * dataRange);

  Result := dataPosition;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Convert data to track bar data scale.
// Inputs:  Value - data value
// Outputs: TrackBar Value
////////////////////////////////////////////////////////////////////////////////
function TTrackEdit.DataToTrackBar(Value: Double): Integer;
var
  dataRange: Double;
  dataPosition: Double;
  trackBarRange: Integer;
  trackBarPosition: Integer;
begin
  trackBarRange := m_TrackBar.Max - m_TrackBar.Min;
  dataRange := m_dMaximum - m_dMinimum;

  // Data position is the % of the full range
  if (dataRange <> 0.0) then
    dataPosition := (Value - m_dMinimum) / dataRange
  else
    dataPosition := 0.0;

  // TrackBar vertical orientation is inverted of what is expected (top-min; bottom-max); Invert this.
  trackBarPosition :=  round(m_TrackBar.Min + (dataPosition * trackBarRange));
  if ((Orientation = trVertical) and (m_dIncrement > 0)) or
    ((Orientation = trHorizontal) and (m_dIncrement < 0))  then
    trackBarPosition :=  trackBarRange - trackBarPosition;

  Result := trackBarPosition;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Re-layout the whole real edit control.
// Inputs:  None
// Outputs: None//
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.UpdateAll();
begin
  UpdateEditColor();
  UpdateEditSize();
  UpdateData(m_dCtrlValue);
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Redraw the edit box by changing its appearance based on
//              read-only, valid?, factors that affect edit box size.
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.UpdateEditColor();
begin
  if m_bLockRefresh then
    Exit;

  // Enabled
  m_UpButton.Enabled := m_bEnabled;
  m_DownButton.Enabled := m_bEnabled;
  m_TrackBar.Enabled := m_bEnabled;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Redraw the edit box by changing its appearance based on
//              read-only, valid?, factors that affect edit box size.
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.UpdateEditSize();
begin
  if m_bLockRefresh then
    Exit;

  m_TrackBar.ThumbLength := m_nWidth ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Update range in case m_dIncrement is too close to zero.
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.UpdateData(dValue: Double);
var
   nMaximumCount: Integer;
   dMaximumCount: Double;
begin
  // Make sure increment is not zero
  if (Abs(m_dIncrement) < 1.0e-5) then
    m_dIncrement := c_dInitialIncrement ;

  // Set the actual data scale (with limits on the number of steps=MaxInt)
  dMaximumCount := (m_dMaximum - m_dMinimum) / Abs(m_dIncrement);
  if (dMaximumCount > MaxInt) then
  begin
    nMaximumCount := MaxInt;
    if (m_dIncrement > 0) then
      m_dIncrement := (m_dMaximum - m_dMinimum) / nMaximumCount
    else
      m_dIncrement := -(m_dMaximum - m_dMinimum) / nMaximumCount ;
  end;

  // Set the scale for trackbar (with limits on the number of steps=10,000)
  nMaximumCount := round((m_dMaximum - m_dMinimum) / Abs(m_dIncrement));
  if (nMaximumCount > 10000) then
    nMaximumCount := 10000;

  m_TrackBar.Min := 0 ;
  m_TrackBar.Max := nMaximumCount ;
  m_TrackBar.Frequency := Round((m_TrackBar.Max - m_TrackBar.Min) / 10) ;

  // If the number of steps is less than the current frequency (number of tic marks) the set frequency to steps
  if m_TrackBar.Frequency < 1 then
    m_TrackBar.Frequency := 1;

  SetValue(dValue, False);

  UpdateToolTip();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Format given double value.  Use scientific notation if number
//              < 1e-8 or > 1e8.
// Inputs:  dValue - the number to format
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
function TTrackEdit.FormatRealEditString(dValue: Double): string;
begin
  // round off to desired precision
  if ((m_dMinimum < -1E+08) or (m_dMaximum > 1E+08)) then
    result := Format('%.*e', [m_nPrecision, dValue])
  else
    result := Format('%.*f', [m_nPrecision, dValue]);
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Update tool tip
// Inputs:  none
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.UpdateToolTip();
begin
  if (not ReadOnly) then
    m_TrackBar.Hint := FormatRealEditString(m_dMinimum) + ' <= ' +
                    FormatRealEditString(m_dCtrlValue) + ' <= ' +
                    FormatRealEditString(m_dMaximum)
  else
    m_TrackBar.Hint := 'Read-only';
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set slew multiplier
// Inputs:  dMultiplier - new multiplier value
// Outputs: None//
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.SetSlewMultiplier(dMultiplier: Double);
begin
  m_dSlewMultiplier := dMultiplier ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Doing vertical slew
// Inputs:  dNumberOfIncrements - slew by how many increments?
//            negative value means decrement
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.VerticalSlewValue(dNumberOfIncrements: Double);
var
  dNewValue: Double ;
  bFireChangedEvent: Boolean;
begin
  if (not m_bHorizontalArrows) then
  begin
    // calculate new value
    // m_dSlewMultiplier is altered if special key like shift, control is presssed down
    dNewValue := m_dIncrement * dNumberOfIncrements * m_dSlewMultiplier + m_dCtrlValue;

    // do not allow the value to exceed the valid range
    if (dNewValue > m_dMaximum) then
       dNewValue := m_dMaximum
    else if (dNewValue < m_dMinimum) then
       dNewValue := m_dMinimum;

    bFireChangedEvent := True;
    if (m_bSkipChangedEventWhenSlew) then
      bFireChangedEvent := False;

    SetValue(dNewValue, bFireChangedEvent);
    if ((m_dCtrlValue = m_dMaximum) or (m_dCtrlValue = m_dMinimum)) then
       MessageBeep(MB_OK);

    // always fire slew event
    FireSlewed(m_dCtrlValue, dNumberOfIncrements * m_dSlewMultiplier);
  end
  else
    // Fire other dimension slew event
    FireOtherDimensionSlewed(dNumberOfIncrements * m_dSlewMultiplier);
  end;

////////////////////////////////////////////////////////////////////////////////
// Description: Doing horizontal slew
// Inputs:  dNumberOfIncrements - slew by how many increments?
//            negative value means decrement
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.HorizontalSlewValue(dNumberOfIncrements: Double);
var
  dNewValue: Double ;
  bFireChangedEvent: Boolean;
begin
  if (m_bHorizontalArrows) then
  begin
    // calculate new value
    // m_dSlewMultiplier is altered if special key like shift, control is presssed down
    dNewValue := m_dIncrement * dNumberOfIncrements * m_dSlewMultiplier + m_dCtrlValue;

    // do not allow the value to exceed the valid range
    if (dNewValue > m_dMaximum) then
      dNewValue := m_dMaximum
    else if (dNewValue < m_dMinimum) then
      dNewValue := m_dMinimum;

    bFireChangedEvent := True;
    if (m_bSkipChangedEventWhenSlew) then
      bFireChangedEvent := False;

    SetValue(dNewValue, bFireChangedEvent);
    if ((m_dCtrlValue = m_dMaximum) or (m_dCtrlValue = m_dMinimum)) then
       MessageBeep(MB_OK);

    // always fire slew event
    FireSlewed(m_dCtrlValue, dNumberOfIncrements * m_dSlewMultiplier);
  end
  else
  begin
    // Fire other dimension slew event
    FireOtherDimensionSlewed(dNumberOfIncrements * m_dSlewMultiplier);
  end ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Fire changed event
// Inputs:  dCtrlValue - new control value
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.FireChanged(dCtrlValue: Double);
begin
  if Assigned(m_OnChanged) then
    m_OnChanged(self, dCtrlValue) ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Fire other dimension slewed event.  For example, it is fired
//              when slew mode is horizontal and up or down arrow is pressed.
// Inputs:  dNumberOfIncrements - number of increments
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.FireOtherDimensionSlewed(dNumberOfIncrements: Double);
begin
  if Assigned(m_OnOtherDimensionSlewed) then
    m_OnOtherDimensionSlewed(self, dNumberOfIncrements) ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Fire slewed event
// Inputs:  dCtrlValue - new control value (after slew)
//          dNumberOfIncrements - ?
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.FireSlewed(dCtrlValue: Double; dNumberOfIncrements: Double);
begin
  if Assigned(m_OnSlewed) then
  begin
    m_OnSlewed(self, dCtrlValue, dNumberOfIncrements) ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Fire on enter event
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.FireSetFocus;
begin
  if Assigned(m_OnEnter) then
    m_OnEnter(self) ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Fire on exit event
// Inputs:  None
// Outputs: None//
////////////////////////////////////////////////////////////////////////////////
procedure TTrackEdit.FireKillFocus;
begin
  if Assigned(m_OnExit) then
    m_OnExit(self) ;
end;

////////////////////////////////////////////////////////////////////////////////
// TTrackBarMouseWheel
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Description: Constructor
// Inputs:  AOwner - parent (TTrackEdit)
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
constructor TTrackBarMouseWheel.Create(AOwner: TComponent);
begin
  inherited;

  if (assigned(AOwner)) then
    m_TrackEdit := AOwner as TTrackEdit
  else
    m_TrackEdit := nil;

  OnMouseUp := HandleSliderChangedEvent;
  OnMouseWheel := HandleMouseWheelEvent;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Event handler for mouse up event.
// Inputs:  Sender - not used
//          Shift -  state of Alt, Ctrl, and Shift keys and the mouse buttons
//          WheelDelta - which way is the mouse wheel moving and how much
//          MousePos - where is the mouse?
// Outputs: Handled - is the event being handled?
// Notes:  The mouse wheel event cannot be connected directly to TTrackBar, and must
//          be implemented in a derived class (i.e. it's a protected event).
////////////////////////////////////////////////////////////////////////////////
procedure TTrackBarMouseWheel.HandleSliderChangedEvent(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // handle event only if control is enabled and there is a parent (RealEdit) to do the job
  if (Enabled) and assigned(m_TrackEdit) then
    begin
    m_TrackEdit.EditChangeComplete();
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Event handler for mouse wheel event.
// Inputs:  Sender - not used
//          Shift -  state of Alt, Ctrl, and Shift keys and the mouse buttons
//          WheelDelta - which way is the mouse wheel moving and how much
//          MousePos - where is the mouse?
// Outputs: Handled - is the event being handled?
// Notes:  The mouse wheel event cannot be connected directly to TTrackBar, and must
//          be implemented in a derived class (i.e. it's a protected event).
////////////////////////////////////////////////////////////////////////////////
procedure TTrackBarMouseWheel.HandleMouseWheelEvent(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
  Status: Integer;
begin
  Handled := False;

  // handle event only if control is enabled and there is a parent (RealEdit) to do the job
  if (Enabled) then
  begin
    if (WheelDelta > 0) then
      // rotate away from user
      m_TrackEdit.Slewed(Status, 1.0)
    else
      m_TrackEdit.Slewed(Status, -1.0);

    Handled := True;
  end;
end;

end.
