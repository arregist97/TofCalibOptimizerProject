unit ParameterDataWobble;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterDataWobble.pas
// Created:   August, 2007 by John Baker
// Purpose:   This module defines the ParameterDataWobble base class.
//             classes are derived.
//*********************************************************
// Copyright © 1999-2007 Physical Electronics, Inc.
// Created in 2007 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////
interface

uses
  Classes,
  StdCtrls,
  IniFiles,
  Controls,
  Graphics,
  Menus,
  Extctrls,
  Parameter,
  ParameterBoolean,
  ParameterContainer,
  ParameterData,
  ParameterWobbleBase,
  ViewPhiWobbleProp,
  AppSettings_TLB,
  RealEdit;

type
  TWobbleStartEvent = procedure(Sender: TObject) of object;

  TParameterDataWobble = class(TParameterData)
  private
    m_Wobble: TParameterWobbleBase;

    m_OnWobbleTimer: TNotifyEvent;
    m_OnWobbleStart: TWobbleStartEvent;
    m_OnWobbleStop: TNotifyEvent;

    m_MaxWobbleValue: Double;
    m_MinWobbleValue: Double;
    m_StartWobbleValue: Double;    

    // Timers
    m_WobbleTimer: TTimer;
    m_WobbleTimerInProcess: Boolean;

    m_WobbleView: TPhiWobblePropView;

    procedure WobbleTimerTimer(Sender: TObject);
    function GetWobbleDelayInMsec(): Integer;

    procedure OnSetFocus(Sender: TObject);
    procedure OnKillFocus(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy() ; override ;

    procedure StartWobble(Sender: TObject);
    procedure StopWobble(Sender: TObject);
    procedure SetWobble();

    procedure DisplayWobbleProperties(Sender: TObject);

    property OnWobbleTimer: TNotifyEvent read m_OnWobbleTimer write m_OnWobbleTimer;
    property OnWobbleStart: TWobbleStartEvent read m_OnWobbleStart write m_OnWobbleStart;
    property OnWobbleStop: TNotifyEvent read m_OnWobbleStop write m_OnWobbleStop;

    procedure ToRealEdit(RealEditPtr: TRealEdit; UpdateWobbleView: Boolean = True); overload;

    procedure ToWobbleFocus(RealEditPtr: TRealEdit);
    procedure ToWobblePopupMenu(RealEditPtr: TRealEdit); overload;
    procedure ToWobblePopupMenu(LabelPtr: TLabel); overload;

    property Wobble: TParameterWobbleBase read m_Wobble;
  end ;

implementation

uses
  Variants,
  SysUtils,
  Dialogs;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterDataWobble.Create(AOwner: TComponent) ;
begin
  inherited;

  m_ParameterTypeWobble := True;

  // Initialize wobble timer
  m_WobbleTimer := TTimer.Create(Self);
  m_WobbleTimer.Enabled := False;
  m_WobbleTimer.OnTimer := WobbleTimerTimer;
  m_WobbleTimerInProcess := False;

  m_Wobble := TParameterWobbleBase.Create(Self);

  // Intialize callback
  m_OnWobbleTimer := nil;
  m_OnWobbleStart := nil;
  m_OnWobbleStop := nil;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TParameterDataWobble.Destroy() ;
begin
  // Disable the timers.
  m_WobbleTimer.Enabled := False;

  inherited Destroy ;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description: Start wobbling
// Inputs: Sender - not used
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TParameterDataWobble.StartWobble(Sender: TObject);
begin
  // Set the wobble status to wobbling.
  m_Wobble.WobbleStatus.Value := True;

  // Run the wobble start callback if one is defined.
  if Assigned(m_OnWobbleStart) then
  begin
    // Set the min, max, and value; Not used except for display
    m_Wobble.Data.Max := Max;
    m_Wobble.Data.Min := Min;
    m_Wobble.Data.Value := Value;

    m_OnWobbleStart(Self);
  end;

  // Check if a wobble timer callback is defined.
  if Assigned(m_OnWobbleTimer) then
  begin
    // Set the min and max values for the wobble.
    m_Wobble.Data.Max := Max;
    m_Wobble.Data.Min := Min;
    m_StartWobbleValue := Value;  // Save starting pt

    // Set the wobble start value and limits
    m_MaxWobbleValue := m_StartWobbleValue + (m_Wobble.Amplitude.Value * 0.5);
    if m_MaxWobbleValue > Max then
      m_MaxWobbleValue := Max;
    m_MinWobbleValue := m_StartWobbleValue - (m_Wobble.Amplitude.Value * 0.5);
    if m_MinWobbleValue < Min then
      m_MinWobbleValue := Min;

    m_Wobble.Data.Value := m_MinWobbleValue;

    // Start with an increasing wobble
    m_Wobble.Direction := wobbleDirection_Increase;

    // Start the wobble (called the first time by calling the timer callback directly)
    WobbleTimerTimer(Self);

    // Continue wobbling using the timer
    m_WobbleTimer.Interval := GetWobbleDelayInMsec();

    // Set the timer status to enabled.
    m_WobbleTimer.Enabled := True;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Stop wobbling
// Inputs: Sender - not used
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TParameterDataWobble.StopWobble(Sender: TObject);
begin
  // Set the wobble status to not wobbling.
  m_Wobble.WobbleStatus.Value := False;

  // Check if a wobble timer callback is defined.
  if Assigned(m_OnWobbleTimer) then
  begin
    // Cancel the wobble timer.
    m_WobbleTimer.Enabled := False;
    m_WobbleTimerInProcess := False;

    // Set the current value to start value
    m_Wobble.Data.Value := m_StartWobbleValue;
    Value := m_StartWobbleValue;

    // Call the OnWobbleTimer callback.
    m_OnWobbleTimer(Self);
  end;

  // Run the wobble stop callback if one is defined.
  if Assigned(m_OnWobbleStop) then
  begin
    m_OnWobbleStop(Self);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Set wobbling based on 'Focus' and 'AutoMode'
// Inputs: None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TParameterDataWobble.SetWobble();
begin
  if (m_Wobble.WobbleAuto.Value) then
  begin
    if Focus and m_Wobble.WobbleAuto.Value then
      StartWobble(nil)
    else
      StopWobble(nil);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Wobble delay in milliseconds is not evenly divided up and down.
//               This is what gives it the wobble
// Inputs: None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
function TParameterDataWobble.GetWobbleDelayInMsec: Integer;
begin
  // Start with an increasing wobble
  if m_Wobble.Direction = wobbleDirection_Increase then
    Result := trunc(m_Wobble.PeriodInMs.ValueAsInt + (m_Wobble.PeriodInMs.ValueAsInt * m_Wobble.Offset.Value))
  else
    Result := trunc(m_Wobble.PeriodInMs.ValueAsInt - (m_Wobble.PeriodInMs.ValueAsInt * m_Wobble.Offset.Value));
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Wobble using a timer
// Inputs: None
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TParameterDataWobble.WobbleTimerTimer(Sender: TObject);
begin
  // If the timer is already active, skip this one so that timeouts don't back up.
  if (not m_WobbleTimerInProcess) then
  begin    
    // Set the flag to indicate that the Wobble timer is in process.
    m_WobbleTimerInProcess := True;

    // Update max and min: amplitude may have changed
    m_MaxWobbleValue := m_StartWobbleValue + (m_Wobble.Amplitude.Value * 0.5);
    if m_MaxWobbleValue > Max then
      m_MaxWobbleValue := Max;
    m_MinWobbleValue := m_StartWobbleValue - (m_Wobble.Amplitude.Value * 0.5);
    if m_MinWobbleValue < Min then
      m_MinWobbleValue := Min;

    // Check if we are currently ramping the value up.
    if m_Wobble.Direction = wobbleDirection_Increase then
    begin
      // Increment the ramp step and reverse if the max wobble value was reached.
      m_Wobble.Data.Value := m_StartWobbleValue + (m_Wobble.Amplitude.Value * 0.5);
      m_Wobble.Direction := wobbleDirection_Decrease;
    end
    else   // Currently ramping the value down.
    begin
      // Decrement the ramp step and reverse if the min wobble value was reached.
      m_Wobble.Data.Value := m_StartWobbleValue - (m_Wobble.Amplitude.Value * 0.5);
      m_Wobble.Direction := wobbleDirection_Increase;
    end;

    // Call the OnWobbleTimer callback.
    if Assigned(m_OnWobbleTimer) then
      m_OnWobbleTimer(Self);

    // Set the timer interval (this makes it a wobble)
    m_WobbleTimer.Interval := GetWobbleDelayInMsec();

    // Set the flag to indicate that the Wobble timer processing is complete.
    m_WobbleTimerInProcess := False;
  end;
end;

// Lens1EditSetFocus
procedure TParameterDataWobble.OnSetFocus(Sender: TObject);
begin
  Focus := True;
  SetWobble();
end;

// Lens1EditKillFocus
procedure TParameterDataWobble.OnKillFocus(Sender: TObject);
begin
  Focus := False;
  SetWobble();
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TRealEdit component.
// Inputs:       TRealEdit
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterDataWobble.ToRealEdit(RealEditPtr: TRealEdit; UpdateWobbleView: Boolean);
begin

  // If the value is being ramped or wobbled, set the background color to yellow.
  if Wobble.WobbleStatus.Value then
  begin
    m_Wobble.Data.ToRealEdit(RealEditPtr);

    RealEditPtr.BackColor := clYellow;
  end
  else
  begin
    inherited ToRealEdit(RealEditPtr) ;

    RealEditPtr.BackColor := clWhite;
  end;

  if UpdateWobbleView and assigned(m_WobbleView) then
  begin
    m_WobbleView.OnUpdateWobble(ord(wobbleOnUpdateWobble));
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TRealEdit component.
// Inputs:       TRealEdit
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterDataWobble.ToWobbleFocus(RealEditPtr: TRealEdit);
begin
  RealEditPtr.OnSetFocus := OnSetFocus;
  RealEditPtr.OnKillFocus := OnKillFocus;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TRealEdit component.
// Inputs:       TRealEdit
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterDataWobble.ToWobblePopupMenu(RealEditPtr: TRealEdit);
begin
  if not assigned(m_WobbleView) then
    m_WobbleView := TPhiWobblePropView.Create(Self);

  RealEditPtr.PopupMenu := m_WobbleView.WobblePopup;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TRealEdit component.
// Inputs:       TRealEdit
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterDataWobble.ToWobblePopupMenu(LabelPtr: TLabel);
begin
  if not assigned(m_WobbleView) then
    m_WobbleView := TPhiWobblePropView.Create(Self);

  LabelPtr.PopupMenu := m_WobbleView.WobblePopup;
end;

procedure TParameterDataWobble.DisplayWobbleProperties(Sender: TObject);
begin
  if assigned(m_WobbleView) then
     m_WobbleView.OnUpdateWobble(Ord(wobbleOnUpdateShowProperties));
end;

end.

