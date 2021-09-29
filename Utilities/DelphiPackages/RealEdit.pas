unit RealEdit;
////////////////////////////////////////////////////////////////////////////////
// Filename:  RealEdit.pas
// Created:   on 11-01-06
// Purpose:   This module contains the RealEdit component.
//            (TRealEdit).
//
// History:     11-01-01 Initial version
//              - Larry Bot
//
//              09-16-08 Merged PHI changes.
//              - Melinda Caouette
//*********************************************************
// Copyright © 2008 Physical Electronics USA
//
// Created in 2006 (by ReVera) as an unpublished copyrighted work.  This program and the
// information contained in it are confidential and proprietary to Physical
// Electronics and may not be used, copied, or reproduced without the prior
// written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus;

const
  c_lSuccess = Integer($00FF0000);
  c_lFailure = Integer($80FF0000);
  c_lDataValueNotInRange = Integer($00000001);
  c_lAppFailure = Integer($80000000);

  c_dInitialIncrement = 1.0;

  c_dFontAspectRatio = 0.5;
  c_nBorderThickness = 6;

type
////////////////////////////////////////////////////////////////////////////////
//
// Classes declared in this file
//
//  TCustomEdit
      TMouseWheelEdit = class;
//  TPanel
      TRealEdit = class;
//
////////////////////////////////////////////////////////////////////////////////

  TMouseWheelEdit = class(TCustomEdit)
  private
    m_RealEdit: TRealEdit;    // parent of TMouseWheelEdit that handles event
    m_Alignment: TAlignment;

    procedure HandleMouseWheelEvent(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetAlignment(Value: TAlignment);

  public
    constructor Create(AOwner: TComponent); override;
    property Alignment: TAlignment read m_Alignment write SetAlignment default taRightJustify;
  end;

  TRealEditChanged =
    procedure(ASender: TObject; dCtrlValue: Double) of object;
  TRealEditOtherDimensionSlewed =
    procedure(ASender: TObject; dNumberOfIncrements: Double) of object;
  TRealEditSlewed =
    procedure(ASender: TObject; dCtrlValue: Double; dNumberOfIncrements: Double) of object;

  TRealEdit = class(TPanel)
  private
    m_dMinimum: Double;            // minimum and maximum define the valid range for edit control
    m_dMaximum: Double;
    m_dIncrement: Double;          // basic increment/decrement interval for slew, arrow keys
    m_nFlashing: Integer;          // flash background of edit box (NOT IMPLEMENTED)
    m_nWidth: Integer;             // Edit box width
    m_bUseSpinControl: Boolean;    // show spin control?
    m_nJustification: Integer;     // how to justify label?
                                   // 0 means left justified; 1 means right justified;  otherwise align to top
    m_nPrecision: Integer;         // how many decimal points
    m_dDefaultValue: Double;
    m_bEnabled: Boolean;           // Enabled
    m_bReadOnly: Boolean;          // Read Only
    m_bHorizontalArrows: Boolean;  // if true, use left/right arrows instead of up/down arrows to slew
    m_dSlewMultiplier: Double;     // multiplier for slew; special keys like shift and control can alter slewing rate
    m_BackColor: TColor;           // background color of edit box
    m_ForeColor: TColor;           // text color of edit box
    m_bMouseWheelActive: Boolean;  // allow developer to deactivate mouse wheel events
    m_bSkipChangedEventWhenSlew: Boolean; // skip fire changed event when slewing; that is for clients that
                                   // don't want to handle both on changed and on slew event
    m_bScientificNotation: Boolean;  // if true, show value in scientific notation

    m_dCtrlValue: Double;          // last valid value for control
    m_Edit: TMouseWheelEdit;       // edit box
    m_Label: TLabel;               // label

    m_bValueValid: Boolean;        // control value is currently within range?
    m_bHasFocus: boolean;          // control has focus?
    m_bLockRefresh: boolean;       // lock refresh?

    // event handlers
    m_OnChanged: TRealEditChanged;
    m_OnOtherDimensionSlewed: TRealEditOtherDimensionSlewed;
    m_OnEnter: TNotifyEvent;
    m_OnExit:  TNotifyEvent;
    m_OnSlewed: TRealEditSlewed;

    procedure FireChanged(dCtrlValue: Double);
    procedure FireSetFocus;
    procedure FireKillFocus;
    procedure FireOtherDimensionSlewed(dNumberOfIncrements: Double);
    procedure FireSlewed(dCtrlValue: Double; dNumberOfIncrements: Double);

    function  GetOnDelete: TNotifyEvent;
    procedure SetOnDelete(const Value: TNotifyEvent);
    procedure SetValue(dNewValue: Double; bFireOnChangedEvent: Boolean);

    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure EditContextPopUp(Sender: TObject; MousePos: TPoint; var Handled: Boolean);

    procedure VerticalSlewValue(dNumberOfIncrements: Double);
    procedure HorizontalSlewValue(dNumberOfIncrements: Double);
    procedure SetSlewMultiplier(dMultiplier: Double);
    procedure UpdateToolTip;
    function  FormatRealEditString(dValue: Double): string;

    procedure UpdateAll();
    procedure UpdateData();
    procedure UpdateJustification();
    procedure UpdateEditColor();
    procedure UpdateEditSize();

    function GetAlignment: TAlignment;
    procedure SetAlignment(const Value: TAlignment);

    function  GetCaption:string;
    procedure SetCaption(Caption: string);

    function GetPopupMenu: TPopupMenu; reintroduce;
    procedure SetPopupMenu(const Value: TPopupMenu);

    function GetTabStops: Boolean;
    procedure SetTabStops(const Value: Boolean);

    procedure SetBackColor(BackColor: TColor);
    procedure SetForeColor(ForeColor: TColor);
    procedure SetMinimum(dMinimum: Double);
    procedure SetMaximum(dMaximum: Double);
    procedure SetIncrement(dIncrement: Double);
    procedure SetFlashing(Flashing: Integer);
    procedure SetControlWidth(Width: Integer);
    procedure SetSpinControl(bUseSpinControl: Boolean);
    procedure SetJustification(Justification: Integer);
    procedure SetPrecision(nPrecision: Integer);
    procedure SetDefaultValue(DefaultValue: Double);
    procedure SetReadOnly(bReadOnly: Boolean);
    procedure SetHorizontalArrows(HorizontalArrows: Boolean);
    procedure SetScientificNotation(ScientificNotation: Boolean);

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
    property ScientificNotation: Boolean read m_bScientificNotation write SetScientificNotation;

  published
    property Alignment: TAlignment read GetAlignment write SetAlignment ;
    property Caption: string read GetCaption write SetCaption;
    property PopupMenu: TPopupMenu read GetPopupMenu write SetPopupMenu ;
    property TabStops: Boolean read GetTabStops write SetTabStops;

    property Align;
    property ShowHint;
    property Visible;
    property BackColor: TColor read m_BackColor write SetBackColor ;
    property ForeColor: TColor read m_ForeColor write SetForeColor ;
    property Minimum: Double read m_dMinimum write SetMinimum;
    property Maximum: Double read m_dMaximum write SetMaximum;
    property Increment: Double read m_dIncrement write SetIncrement;
    property Flashing: Integer read m_nFlashing write SetFlashing;
    property ControlWidth: integer read m_nWidth write SetControlWidth;
    property SpinControl: Boolean read m_bUseSpinControl write SetSpinControl;
    property Justification: Integer read m_nJustification write SetJustification;
    property Precision: Integer read m_nPrecision write SetPrecision;
    property DefaultValue: Double read m_dDefaultValue write SetDefaultValue;
    property Enabled: Boolean read m_bEnabled write SetEnabled;
    property ReadOnly: Boolean read m_bReadOnly write SetReadOnly;
    property HorizontalArrows: Boolean read m_bHorizontalArrows write SetHorizontalArrows;
    property MouseWheelActive: Boolean read m_bMouseWheelActive write m_bMouseWheelActive;
    property SkipChangedEventWhenSlew: Boolean read m_bSkipChangedEventWhenSlew write m_bSkipChangedEventWhenSlew;

    property OnChanged: TRealEditChanged read m_OnChanged write m_OnChanged;
    property OnOtherDimensionSlewed: TRealEditOtherDimensionSlewed
      read m_OnOtherDimensionSlewed write m_OnOtherDimensionSlewed;
    property OnSlewed: TRealEditSlewed read m_OnSlewed write m_OnSlewed;
    property OnDelete: TNotifyEvent read GetOnDelete write SetOnDelete;
    property OnSetFocus: TNotifyEvent read m_OnEnter write m_OnEnter ;
    property OnKillFocus: TNotifyEvent read m_OnExit write m_OnExit ;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('PHI Library', [TRealEdit]);
end;

// TRealEdit

////////////////////////////////////////////////////////////////////////////////
// Description: Constructor
// Inputs:  AOwner -
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
constructor TRealEdit.Create(AOwner: TComponent);
begin
  inherited;

  // Main Panel
  inherited Caption := ' ' ;
  Width := 200;
  Height := 25;
  Align := alNone ;
  BorderWidth := 0;
  BevelOuter := bvNone;
  Font.Size := 8 ;
  Font.Name := 'MS Sans Serif' ;

  m_BackColor := clWindow ;
  m_ForeColor := clWindowText ;
  m_dMinimum := -100.0 ;
  m_dMaximum := 100.0 ;
  m_dIncrement := 1.0 ;
  m_nFlashing := 0 ;
  m_nWidth := 5 ;
  m_bUseSpinControl := False ;
  m_nJustification := 1 ;
  m_nPrecision := 0 ;
  m_dDefaultValue := 0.0 ;
  m_bEnabled := True ;
  m_bReadOnly := False ;
  m_bHorizontalArrows := False ;
  m_dSlewMultiplier := 1.0 ;
  m_bMouseWheelActive := True;
  m_bSkipChangedEventWhenSlew := False;
  m_bScientificNotation := False;

  m_bValueValid := True ;
  m_bHasFocus := False;
  m_bLockRefresh := False;

  // edit box
  m_Edit := TMouseWheelEdit.Create(Self);
  m_Edit.Name := 'EditBox';
  m_Edit.Align := alNone ;
  m_Edit.Alignment := taRightJustify ;
  m_Edit.Anchors := [akTop,akRight];
  m_Edit.Text := FormatRealEditString(m_dCtrlValue);
  m_Edit.Height := 24;
  m_Edit.Width := 100;
  m_Edit.OnKeyPress := EditKeyPress ;
  m_Edit.OnKeyDown := EditKeyDown ;
  m_Edit.OnKeyUp := EditKeyUp ;
  m_Edit.OnEnter := EditEnter ;
  m_Edit.OnExit := EditExit ;
  m_Edit.OnContextPopup := EditContextPopUp;
  m_Edit.PopupMenu := PopupMenu;
  InsertControl(m_Edit);

  // label
  m_Label := TLabel.Create(Self);
  m_Label.Name := 'Label';
  m_Label.Align := alNone ;
  m_Label.Caption := Name ;
  m_Label.Transparent := False;
  m_Label.PopupMenu := PopupMenu;
  InsertControl(m_Label);
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Destructor
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
destructor TRealEdit.Destroy;
begin
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Event handler for edit box's OnEnter event
// Inputs:  Sender - not used
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.EditEnter(Sender: TObject);
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
procedure TRealEdit.EditExit(Sender: TObject);
var
  dValue: Double;
begin
  // proceed only if control is enabled and not read-only
  if (m_bEnabled) and (not m_bReadOnly) then
  begin
    // if the control value is not currently valid set it back to last valid value
    if (not m_bValueValid) then
      SetValue(m_dCtrlValue, False)
    else
    begin
      dValue := StrToFloat(m_Edit.Text);
      SetValue(dValue, True);
    end;

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
procedure TRealEdit.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  bHit: Boolean ;
begin

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
// Description: Context menu event handler for edit box
// Inputs:  Sender - not used
//          MousePos - mouse position where context menu is brought up
// Outputs: Handled - is the event handled?
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.EditContextPopUp(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := False;

  if (Enabled) then
  begin
    // don't want to pop up default context menu; if PopUpMenu is not assigned
    // mark it as Handled and don't pop up any context menu
    if (not assigned(PopupMenu)) then
      Handled := True;
  end;

end;

////////////////////////////////////////////////////////////////////////////////
// Description: Key press event handler for edit box
// Inputs:  Sender - not used
//          Key - which key is released
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.EditKeyPress(Sender: TObject; var Key: Char);
var
  dValue: Double;
  bValid: Boolean ;
begin

  // proceed only if control is enabled and not read-only
  if (m_bEnabled) and (not m_bReadOnly) then
  begin
    bValid := False ;

    // if digit or '.' and there is no other '.' in the field or if the '.' is highlighted pass on through
    if (((Key >= '0') and (Key <= '9')) or
        ((Key = '.') and ((Pos('.', m_Edit.Text) = 0)) or (Pos('.', m_Edit.SelText) <> 0))) then
      bValid := True

    // if '-' and there is no '-'
    else if ((Key = '-') and (Pos('-', m_Edit.Text) = 0)) then
      bValid := True

    // if scientific notation and 'e' or 'E' and there is no other 'e' or 'E' and
    // there is no leading '-' or this is not the first character then pass on through
    else if ((((Key = 'e') or (Key = 'E')) and
              ((Pos('e', m_Edit.Text) = 0)) and (Pos('E', m_Edit.Text) = 0))) then
      bValid := True

      // if '-' and there is no other '-' and this is the first character pass on through
    else if (Key = '-') then
      bValid := True   

    // if back space pass on through
    else if (Key = char(VK_BACK)) then
      bValid := True

    // if return then get and process current value
    else if (Key = char(VK_RETURN)) then
    begin
      try
        dValue := StrToFloat(m_Edit.Text);
        SetValue(dValue, True);
        bValid := True ;
        Key := #0;
      except
        SetValue(m_dCtrlValue, True);
      end;
    end ;
  
    // beep for all other characters which are illegal
    if (not bValid) then
    begin
      Key := #0;
      MessageBeep(MB_OK);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Key up event handler for edit box
// Inputs:  Sender - not used
//          Key - which key is released
//          Shift -  state of Alt, Ctrl, and Shift keys and the mouse buttons
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.EditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  bHit: Boolean ;
begin
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
procedure TRealEdit.Resize();
begin
  inherited;

  UpdateEditSize();
  UpdateJustification();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Return the delelt event (Not Implemented)
// Inputs:  None
// Outputs: None
//////////////////////////////////////////////////////////////////////////////////
function TRealEdit.GetOnDelete: TNotifyEvent;
begin
  Result := nil;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set the delelt event (Not Implemented)
// Inputs:  None
// Outputs: None
//////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetOnDelete(const Value: TNotifyEvent);
begin
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Get edit box alignment
// Inputs:  None
// Outputs: None
//////////////////////////////////////////////////////////////////////////////////
function TRealEdit.GetAlignment: TAlignment;
begin
  Result := m_Edit.Alignment ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set edit box alignment
// Inputs:  taLeftJustify, taRightJustify, taCenter
// Outputs: None
//////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetAlignment(const Value: TAlignment);
begin
  m_Edit.Alignment := Value ;
end;

function TRealEdit.GetPopupMenu: TPopupMenu;
begin
  Result := m_Edit.PopupMenu ;
end;

procedure TRealEdit.SetPopupMenu(const Value: TPopupMenu);
begin
  m_Label.PopupMenu := Value ;
  m_Edit.PopupMenu := Value ;
end;

function TRealEdit.GetTabStops: Boolean;
begin
  Result := m_Edit.TabStop;
end;

procedure TRealEdit.SetTabStops(const Value: Boolean);
begin
  TabStop := Value;
  m_Edit.TabStop := Value;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set edit box background color
// Inputs:  None
// Outputs: None
//////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetBackColor(BackColor: TColor);
begin
  m_BackColor := BackColor ;

  UpdateEditColor()
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Get caption
// Inputs:
// Outputs: Caption
////////////////////////////////////////////////////////////////////////////////
function TRealEdit.GetCaption: string;
begin
  Result := m_Label.Caption ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set caption
// Inputs:  Caption - new caption
//// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetCaption(Caption: string);
begin
  m_Label.Caption := Caption ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set edit box width
// Inputs:  Width - new width
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetControlWidth(Width: Integer);
begin
  m_nWidth := Width ;

  UpdateEditSize();

  UpdateJustification();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set data value.
// Inputs:  dNewValue - new value
// Outputs: Status - successful in setting requested value?
////////////////////////////////////////////////////////////////////////////////
function TRealEdit.SetDataValue(var Status: Integer; dNewValue: Double): Integer;
begin
  Result := c_lSuccess;
  Status := S_OK;

  SetValue(dNewValue, False);
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
function TRealEdit.GetDataValue(var Status: Integer; var dDataValue: Double): Integer;
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
function TRealEdit.SetDataRange(var Status: Integer; dMinimum, dMaximum: Double): Integer;
begin
  Result := c_lSuccess;
  Status := S_OK;

  m_dMinimum := dMinimum;
  m_dMaximum := dMaximum;

  UpdateData();

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
function TRealEdit.Slewed(var Status: Integer; dNumberOfIncrements: Double): Integer;
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
procedure TRealEdit.SetLockRefresh(bLock: Boolean);
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
procedure TRealEdit.SetDefaultValue(DefaultValue: Double);
begin
  m_dDefaultValue := DefaultValue ;

  SetValue(m_dDefaultValue, False);
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set flashing attribute (Not Implemented)
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetFlashing(Flashing: Integer);
begin
  m_nFlashing := Flashing ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set text color of edit box
// Inputs:  ForeColor - requested edit box text color (foreground)
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetForeColor(ForeColor: TColor);
begin
  m_ForeColor := ForeColor ;

  UpdateEditColor()
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set the option to use left/right instead of up/down arrows to slew.
// Inputs:  HorizontalArrows - if true, use left/right arrows to slew
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetHorizontalArrows(HorizontalArrows: Boolean);
begin
  m_bHorizontalArrows := HorizontalArrows ;
end;
                
// SetScientificNotation   
////////////////////////////////////////////////////////////////////////////////
// Description: Set the option to show the value in scientific notation.
// Inputs:  ScientificNotation - if true, use scientific notation.
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetScientificNotation(ScientificNotation: Boolean);
begin
  m_bScientificNotation := ScientificNotation;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set increment value
// Inputs:  Increment - requested increment value
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetIncrement(dIncrement: Double);
begin
  m_dIncrement := dIncrement ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set label justification to edit box
// Inputs:  Justification - new justification mode
//           0 means left justified; 1 means right justified;  otherwise align to top
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetJustification(Justification: Integer);
begin
  m_nJustification := Justification ;

  UpdateJustification();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set maximum value
// Inputs:  dMaximum - new maximum value
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetMaximum(dMaximum: Double);
begin
  m_dMaximum := dMaximum ;

  UpdateData();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set minimum value
// Inputs:  dMinimum - new minimum value
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetMinimum(dMinimum: Double);
begin
  m_dMinimum := dMinimum ;

  UpdateData();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set precision.
// Inputs:  nPrecision - number of precision.
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetPrecision(nPrecision: Integer);
begin
  m_nPrecision := nPrecision ;

  UpdateData();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set enabled mode
// Inputs:  bEnabled - true for enabled
// Outputs: None//
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetEnabled(bEnabled: Boolean);
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
procedure TRealEdit.SetReadOnly(bReadOnly: Boolean);
begin
  m_bReadOnly := bReadOnly ;

  // temp:
//  m_bEnabled := not bReadOnly;

  UpdateEditColor();

  UpdateToolTip();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set the option for using spin control
// Inputs:  bUseSpinControl - make spin control available (show)
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetSpinControl(bUseSpinControl: Boolean);
begin
  m_bUseSpinControl := bUseSpinControl ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set real edit value and have the option to fire on changed event.
// Inputs:  dNewValue - new control value
//          bFireOnChangedEvent - whether to fire on changed event
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetValue(dNewValue: Double; bFireOnChangedEvent: Boolean);
var
  sTrialValue: string ;
  dTrialValue: Double ;
begin
  sTrialValue := FormatRealEditString(dNewValue) ;

  dTrialValue := StrToFloat(sTrialValue);

  // check for valid range
  if ((dTrialValue < m_dMinimum) or (dTrialValue > m_dMaximum)) then
  begin
    m_bValueValid := False;
  end
  else  // valid
  begin
    m_bValueValid := True;
    m_Edit.Text := FormatRealEditString(dTrialValue) ;

    // if the value has changed
    if (dTrialValue <> m_dCtrlValue) then
    begin
      m_dCtrlValue := dTrialValue;
         
      if (bFireOnChangedEvent) then
        FireChanged(m_dCtrlValue);
    end;
  end;
   
  UpdateEditColor()
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Re-layout the whole real edit control.
// Inputs:  None
// Outputs: None//
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.UpdateAll();
begin
  UpdateEditColor();
  UpdateEditSize();
  UpdateJustification();
  UpdateData();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Update control justification
// Inputs:  None
// Outputs: None//
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.UpdateJustification();
begin
  if m_bLockRefresh then
    Exit;

  if (m_nJustification = 1) then
  begin
    m_Edit.Top := 0;
    m_Edit.Left := Width - m_Edit.Width;

    // label right justified
    m_Label.Top := m_Edit.Top;
    m_Label.Left := m_Edit.Left - (m_Label.Width + 2);
  end
  else if (m_nJustification = 0) then
  begin
    m_Edit.Top := 0;
    m_Edit.Left := Width - m_Edit.Width;

    // label left justified
    m_Label.Top := m_Edit.Top;
    m_Label.Left := 0;
  end
  else
  begin
    // label aligned to the top

    m_Edit.Top := m_Label.Height;
    if (Width > m_Edit.Width) then
      m_Edit.Left := Trunc((Width - m_Edit.Width) / 2)
    else
      m_Edit.Left := 0;
    m_Label.Top := 0;
    if (Width > m_Edit.Width) then
      m_Label.Left := Trunc((Width - m_Label.Width) / 2)
    else
      m_Label.Left := 0;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Redraw the edit box by changing its appearance based on
//              read-only, valid?, factors that affect edit box size.
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.UpdateEditColor();
begin
  if m_bLockRefresh then
    Exit;

  if (m_bReadOnly) then
  begin
    // give it the read-only look
    m_Edit.Color := clBtnFace ;
    m_Edit.Font.Color := m_ForeColor ;
  end
  else // not read only
  begin
    if (m_bValueValid) then
    begin
      m_Edit.Color := m_BackColor ;
      m_Edit.Font.Color := m_ForeColor ;
    end
    else // invalid value
    begin
      // give it the error look
      m_Edit.Color := clRed ;
      m_Edit.Font.Color := clBlack ;
    end;
  end;

  // Enabled
  m_Edit.Enabled := m_bEnabled;
  m_Label.Enabled := m_bEnabled;

  // Read only
  m_Edit.ReadOnly := m_bReadOnly;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Redraw the edit box by changing its appearance based on
//              read-only, valid?, factors that affect edit box size.
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.UpdateEditSize();
var
  nEditBoxWidth: Integer ;
begin
  if m_bLockRefresh then
    Exit;

  nEditBoxWidth := Trunc(abs(m_Edit.Font.Height) * c_dFontAspectRatio *
         (m_nWidth + 2) + c_nBorderThickness * 2);

  m_Edit.Width := nEditBoxWidth ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Format given double value.  Use scientific notation if number
//              < 1e-8 or > 1e8.
// Inputs:  dValue - the number to format
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
function TRealEdit.FormatRealEditString(dValue: Double): string;
begin
  // Check if option is set to use scientific notation or the min/max value is very large.
  if ((m_bScientificNotation) or (m_dMinimum < -1E+08) or (m_dMaximum > 1E+08)) then
    result := Format('%.*e', [m_nPrecision + 1, dValue]) // 1.00E-7 has a precision of 3; Includes a single number before the decimal point
  else
    result := Format('%.*f', [m_nPrecision, dValue]);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Update range in case m_dIncrement is too close to zero.
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.UpdateData();
var
   nMaximumCount: Integer;
   dMaximumCount: Double;
begin
  // Make sure increment is not zero
  if (Abs(m_dIncrement) < 1.0e-5) then
    m_dIncrement := c_dInitialIncrement ;

  dMaximumCount := (m_dMaximum - m_dMinimum) / Abs(m_dIncrement);
  if (dMaximumCount > MaxInt) then
  begin
    nMaximumCount := MaxInt;
    if (m_dIncrement > 0) then
      m_dIncrement := (m_dMaximum - m_dMinimum) / nMaximumCount
    else
      m_dIncrement := -(m_dMaximum - m_dMinimum) / nMaximumCount ;
  end;
   
  SetValue(m_dCtrlValue, False);

  UpdateToolTip();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Update tool tip
// Inputs:  none
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.UpdateToolTip();
begin
  if (not ReadOnly) then
    m_Edit.Hint := FormatRealEditString(m_dMinimum) + '  <= Value <=  ' +
                   FormatRealEditString(m_dMaximum)
  else
    m_Edit.Hint := 'Read-only';
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set slew multiplier
// Inputs:  dMultiplier - new multiplier value
// Outputs: None//
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.SetSlewMultiplier(dMultiplier: Double);
begin
  m_dSlewMultiplier := dMultiplier ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Doing vertical slew
// Inputs:  dNumberOfIncrements - slew by how many increments?
//            negative value means decrement
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.VerticalSlewValue(dNumberOfIncrements: Double);
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
procedure TRealEdit.HorizontalSlewValue(dNumberOfIncrements: Double);
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
procedure TRealEdit.FireChanged(dCtrlValue: Double);
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
procedure TRealEdit.FireOtherDimensionSlewed(dNumberOfIncrements: Double);
begin
  if Assigned(OnOtherDimensionSlewed) then
    OnOtherDimensionSlewed(self, dNumberOfIncrements) ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Fire slewed event
// Inputs:  dCtrlValue - new control value (after slew)
//          dNumberOfIncrements - ?
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.FireSlewed(dCtrlValue: Double; dNumberOfIncrements: Double);
begin
  if Assigned(OnSlewed) then
  begin
    OnSlewed(self, dCtrlValue, dNumberOfIncrements) ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Fire on enter event
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.FireSetFocus;
begin
  if Assigned(m_OnEnter) then
    m_OnEnter(self) ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Fire on exit event
// Inputs:  None
// Outputs: None//
////////////////////////////////////////////////////////////////////////////////
procedure TRealEdit.FireKillFocus;
begin
  if Assigned(m_OnExit) then
    m_OnExit(self) ;
end;

{ TMouseWheelEdit }

////////////////////////////////////////////////////////////////////////////////
// Description: Constructor
// Inputs:  AOwner - parent (TRealEdit)
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
constructor TMouseWheelEdit.Create(AOwner: TComponent);
begin
  inherited;

  if (assigned(AOwner)) then
    m_RealEdit := AOwner as TRealEdit
  else
    m_RealEdit := nil;

  OnMouseWheel := HandleMouseWheelEvent;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Implemented to add alignment to TEdit control
// Inputs:  None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TMouseWheelEdit.CreateParams(var Params: TCreateParams);
const Alignments: array[TAlignment] of Cardinal =
      (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);

  Params.Style := Params.Style or ES_MULTILINE or
                  Alignments[m_Alignment];
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set alignment
// Inputs:  taLeftJustify, taRightJustify, taCenter
// Outputs: None
//////////////////////////////////////////////////////////////////////////////////
procedure TMouseWheelEdit.SetAlignment(Value: TAlignment);
begin
  if m_Alignment <> Value then
  begin
    m_Alignment := Value;
    RecreateWnd;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Event handler for mouse wheel event.
// Inputs:  Sender - not used
//          Shift -  state of Alt, Ctrl, and Shift keys and the mouse buttons
//          WheelDelta - which way is the mouse wheel moving and how much
//          MousePos - where is the mouse?
// Outputs: Handled - is the event being handled?
////////////////////////////////////////////////////////////////////////////////
procedure TMouseWheelEdit.HandleMouseWheelEvent(
  Sender: TObject;
  Shift: TShiftState;
  WheelDelta: Integer;
  MousePos: TPoint;
  var Handled: Boolean
);
var
  Status: Integer;
begin
  Handled := False;

  // handle event only if control is enabled and there is a parent (RealEdit) to do the job
  if (Enabled) and (assigned(m_RealEdit)) and (m_RealEdit.MouseWheelActive) then
  begin
    if (WheelDelta > 0) then
      // rotate away from user
      m_RealEdit.Slewed(Status, 1.0)
    else
      m_RealEdit.Slewed(Status, -1.0);

    Handled := True;
  end;
end;

end.
