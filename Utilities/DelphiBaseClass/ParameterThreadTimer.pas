unit ParameterThreadTimer;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterThreadTimer.pas
// Created:   November, 2015 by Dan Hennen
// Purpose:   ParameterThreadTimer implements a timer in a separate thread.
//*********************************************************
// Copyright © 1999-2015 Physical Electronics, Inc.
// Created in 2015 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////
interface

uses
  Classes, StdCtrls, ComCtrls, Extctrls, Buttons, Menus, Windows,
  Parameter,
  ParameterBoolean,
  ParameterContainer,
  ParameterSelectData;

type
  // TParameterThreadTimer
  TParameterThreadTimer = class(TParameterContainer)
  private
    m_State: TParameterBoolean;
    m_Interval: TParameterSelectData;
    m_OnTimer: TThreadMethod;
    m_TimerThread: TThread;
    m_ThreadPriority: TThreadPriority;
    m_MinWaitTimeInMSec: Cardinal;
    m_ExecuteOnceMode: Boolean;
    m_ExecuteAtTimeMode: Boolean;
    m_ExecuteAtTimeIntervalInMSec: Cardinal;

    procedure SetThreadPriority(const Value: TThreadPriority);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure SetTimer(Value: Boolean);
    procedure ExecuteOnce;
    procedure ExecuteAtTime(Hour: Integer; Minute: Integer; Second: Integer);

    procedure ToButton(ButtonPtr: TSpeedButton);
    procedure ToPopupMenu(PopupMenuPtr: TPopupMenu; OnChangeEvent: TNotifyEvent = nil);
    procedure ToStickyButton(ButtonPtr: TSpeedButton);

    property State: TParameterBoolean read m_State;
    property Interval: TParameterSelectData read m_Interval;  
    property OnTimer: TThreadMethod read m_OnTimer write m_OnTimer;
    property Priority: TThreadPriority read m_ThreadPriority write SetThreadPriority;
    property MinWaitTimeInMSec: Cardinal read m_MinWaitTimeInMSec write m_MinWaitTimeInMSec;
    property ExecuteOnceMode: Boolean read m_ExecuteOnceMode write m_ExecuteOnceMode;
    property ExecuteAtTimeMode: Boolean read m_ExecuteAtTimeMode write m_ExecuteAtTimeMode;
    property ExecuteAtTimeIntervalInMSec: Cardinal read m_ExecuteAtTimeIntervalInMSec write m_ExecuteAtTimeIntervalInMSec;
    function GetThreadID: Cardinal;
  end;

  // TTimerThread
  TTimerThread = class(TThread)
  private
    m_Event: THandle;
    m_IntervalInMsec: Cardinal;
    m_ParameterThreadTimer: TParameterThreadTimer;
    m_ThreadPriority: TThreadPriority;
    m_Synchronizing: Boolean;
    m_MinWaitTimeInMSec: Cardinal;
  protected
    procedure Execute; override;
  public
    constructor Create(ParameterThreadTimer: TParameterThreadTimer);
    destructor Destroy; override;
    procedure StopTimer;
    property IntervalInMsec: Cardinal read m_IntervalInMsec;
    property ParameterThreadTimer: TParameterThreadTimer read m_ParameterThreadTimer;
    property Synchronizing: Boolean read m_Synchronizing;
  end;

implementation

uses
  System.Contnrs, System.SysUtils, System.Math,
  Graphics, MMSystem;

// Create
constructor TParameterThreadTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Initialize member variables.
  m_State:= TParameterBoolean.Create(Self);
  m_State.Name:= 'State';
  m_State.Caption:= 'State';
  m_State.Hint:= 'State';
  m_State.Value := False;
  Container.Add(m_State);

  m_Interval:= TParameterSelectData.Create(Self);
  m_Interval.Name:= 'Interval(sec)';
  m_Interval.Caption:= 'Interval (sec)';
  m_Interval.Hint:= 'Interval (sec)';
  m_Interval.Precision := 0;
  m_Interval.AddValue(1.0);
  m_Interval.AddValue(2.0);
  m_Interval.AddValue(5.0);
  m_Interval.AddValue(10.0);
  m_Interval.AddValue(30.0);
  m_Interval.AddValue(60.0);
  m_Interval.ValueAsFloat := 2.0;
  Container.Add(m_Interval);

  m_TimerThread := nil;
  m_OnTimer := nil;
  m_ThreadPriority := tpNormal;
  m_MinWaitTimeInMSec := 1000;
  m_ExecuteOnceMode := False;
  m_ExecuteAtTimeMode := False;
end;

// Destroy
destructor TParameterThreadTimer.Destroy();
begin
  // Disable the timer.
  if Assigned(m_TimerThread) then
  begin
    TTimerThread(m_TimerThread).StopTimer;
    m_TimerThread := nil;
  end;

  inherited Destroy;
end;

// SetTimer
procedure TParameterThreadTimer.SetTimer(Value: Boolean);
begin
  // Check if the timer state has changed.
  if m_State.Value <> Value then
  begin
    // Save the timer state value.
    m_State.Value := Value;

    // Check if turning the timer on.
    if m_State.Value then
    begin
      if m_Interval.ValueAsInt > 0 then
      begin
        // If currently executing an Execute Once command, set the flag to
        // false to get it to act like a normal periodic timer.
        if m_ExecuteOnceMode then
        begin
          m_ExecuteOnceMode := False;
        end
        else  // Nothing running, create a new timer thread.
        begin
          m_TimerThread := TTimerThread.Create(Self);
        end;
      end;
    end
    else   // Turning the timer off.
    begin
      if Assigned(m_TimerThread) then
      begin
        TTimerThread(m_TimerThread).StopTimer;
        m_TimerThread := nil;
      end;
    end;
  end;
end;

// ExecuteOnce
procedure TParameterThreadTimer.ExecuteOnce;
begin
  // If the timer is active, ignore the request.
  if (m_State.Value) or (m_ExecuteOnceMode) then
    Exit;

  // Free the timer thread from the last time.
  if Assigned(m_TimerThread) then
    m_TimerThread.Free;

  // Set the flag to execute the timer once and create the timer thread object.
  m_ExecuteOnceMode := True;
  m_TimerThread := TTimerThread.Create(Self);
end;

// ExecuteAtTime
procedure TParameterThreadTimer.ExecuteAtTime(Hour: Integer; Minute: Integer; Second: Integer);
var
  currentTime: TDateTime;
  startOfNextDay: TDateTime;
  archiveTimeOfDay: TDateTime;
  nextArchiveTime: TDateTime;
  timerInterval: TDateTime;
  timerIntervalInMsec: Integer;
begin
  // Get the number of milliseconds to the specified time.
  // Calculate the next time to schedule the Database Archive.
  currentTime := Now();
  startOfNextDay := Floor(currentTime) + 1.0;
  archiveTimeOfDay := EncodeTime(Hour, Minute, Second, 0);
  nextArchiveTime := startOfNextDay + archiveTimeOfDay;

  // If the next archive time is more than a day away, subtract a day.
  if (nextArchiveTime - currentTime) > 1.0  then
    nextArchiveTime := nextArchiveTime - 1.0;

  // Calculate the number of milliseconds to the next timer execution.
  timerInterval := nextArchiveTime - currentTime;
  timerIntervalInMsec :=  Round(timerInterval * SecsPerDay * MSecsPerSec);

  // Set the flag to execute the timer once and create the timer thread object.
  m_ExecuteAtTimeMode := True;
  m_ExecuteAtTimeIntervalInMSec := timerIntervalInMsec;
  m_TimerThread := TTimerThread.Create(Self);
end;

// SetThreadPriority
procedure TParameterThreadTimer.SetThreadPriority(const Value: TThreadPriority);
begin
  if m_ThreadPriority <> Value then
  begin
    m_ThreadPriority := Value;
    if m_TimerThread <> nil then
      m_TimerThread.Priority := m_ThreadPriority;
  end;
end;

// ToButton
procedure TParameterThreadTimer.ToButton(ButtonPtr: TSpeedButton);
begin
  if (Hint <> c_DefaultHint) then
  begin
    ButtonPtr.ShowHint := True;
    ButtonPtr.Hint := Hint;
  end;
  ButtonPtr.Visible := Visible;
  ButtonPtr.Enabled := Enabled;

  if m_State.Value then
  begin
    ButtonPtr.Caption := Caption + ': ' + m_Interval.ValueAsString + ' sec';
    ButtonPtr.Down := True;
  end
  else
  begin
    ButtonPtr.Caption := Caption;
    ButtonPtr.Down := False;
  end;
end;

// ToPopupMenu
procedure TParameterThreadTimer.ToPopupMenu(PopupMenuPtr: TPopupMenu; OnChangeEvent: TNotifyEvent);
begin
  m_Interval.ToPopupMenu(PopupMenuPtr, OnChangeEvent);
end;

// ToStickyButton
procedure TParameterThreadTimer.ToStickyButton(ButtonPtr: TSpeedButton);
begin
  if (Hint <> c_DefaultHint) then
  begin
    ButtonPtr.ShowHint := True;
    ButtonPtr.Hint := 'Continuous Read';
  end;
  ButtonPtr.Visible := Visible;
  ButtonPtr.Enabled := Enabled;

  try
    // Load the glyph for continuous,  swallow any exception
    if ButtonPtr.Glyph.Empty then
      ButtonPtr.Glyph.LoadFromResourceName(HInstance, 'CONTINUOUS');
  except
  end;

  if m_State.Value then
    ButtonPtr.Down := True
  else
    ButtonPtr.Down := False;
end;

// GetThreadID
function TParameterThreadTimer.GetThreadID: Cardinal;
begin
  if Assigned(m_TimerThread) then
    Result := m_TimerThread.ThreadID
  else
    Result := 0;
end;

// TTimerThread Methods
// Create
constructor TTimerThread.Create(ParameterThreadTimer: TParameterThreadTimer);
begin
  inherited Create(False);

  FreeOnTerminate := True;

  m_Event := CreateEvent(nil,    // EventAttributes
                         False,  // ManualReset
                         False,  // InitialState
                         nil);   // Name
  if m_Event = 0 then
    RaiseLastOSError;

  m_IntervalInMsec := ParameterThreadTimer.Interval.ValueAsInt * 1000;
  m_ParameterThreadTimer := ParameterThreadTimer;
  m_ThreadPriority := ParameterThreadTimer.Priority;
  m_MinWaitTimeInMSec := ParameterThreadTimer.MinWaitTimeInMSec;
end;

// Destroy
destructor TTimerThread.Destroy;
begin
  StopTimer;
  inherited Destroy;
  if m_Event <> 0 then
    CloseHandle(m_Event);
end;

// StopTimer
procedure TTimerThread.StopTimer;
begin
  // Set the thread terminate flag.
  Terminate;

  // Set an event to stop the Execute loop.
  SetEvent(m_Event);
end;

// Execute
procedure TTimerThread.Execute;
var
  startTimeInTicks: Cardinal;
  endTimeInTicks: Cardinal;
  durationInTicks: Cardinal;
  waitTimeInMsec: Cardinal;
  waitStatus: Cardinal;
begin
  Priority := m_ThreadPriority;

  while not Terminated do
  begin
    // Check if the execute at time option is set.
    if (m_ParameterThreadTimer.ExecuteAtTimeMode) then
    begin
      // Wait for the timeout.
      waitTimeInMsec := m_ParameterThreadTimer.ExecuteAtTimeIntervalInMSec;
      waitStatus := WaitForSingleObject(m_Event, waitTimeInMsec);

      // If this was a normal timeout, call the user-supplied worker thread procedure.
      if (waitStatus = WAIT_TIMEOUT) then
      begin
        if Assigned(m_ParameterThreadTimer.OnTimer) then
          m_ParameterThreadTimer.OnTimer;
        Exit;
      end;
      Continue;
    end;

    // Get the time before calling the event handlers.
    startTimeInTicks := GetTickCount;

    // Call the user-supplied worker thread procedure.
    if Assigned(m_ParameterThreadTimer.OnTimer) then
      m_ParameterThreadTimer.OnTimer;

    // Get the time after calling the event handlers.
    endTimeInTicks := GetTickCount;

    // If the execute once mode flag is set, exit the procedure.
    if m_ParameterThreadTimer.ExecuteOnceMode then
    begin
      m_ParameterThreadTimer.ExecuteOnceMode := False;
      Exit;
    end;

    // Calculate the amount of time it took to execute the event handlers.
    // GetTickCount returns the number of milliseconds since Windows was last
    // started. It will overflow every 49.7 days, so the code must handle this.
    if endTimeInTicks >= startTimeInTicks then
      durationInTicks := endTimeInTicks - startTimeInTicks
    else
      durationInTicks := (High(Cardinal) - startTimeInTicks) + endTimeInTicks;

    // Calculate the wait time. Don't allow a wait time less than 1 second.
    if durationInTicks > m_IntervalInMsec then
      waitTimeInMsec := m_MinWaitTimeInMSec
    else
    begin
      waitTimeInMsec := m_IntervalInMsec - durationInTicks;
      if waitTimeInMsec < m_MinWaitTimeInMSec then
        waitTimeInMsec := m_MinWaitTimeInMSec;
    end;

    // Wait for the timeout.
    if Terminated or (WaitForSingleObject(m_Event, waitTimeInMsec) <> WAIT_TIMEOUT) then
      Exit;
  end;
end;

end.

