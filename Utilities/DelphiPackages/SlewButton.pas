{
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  SlewButton.pas
// Created:   on 98-12-03 by Mark Rosen
// Purpose:   The SlewButton is a button that allows event handlers on button down and
   button up events like a normal button, but also allows an event handler
   to be called once after the button is held depressed for SlewDelay
   milliseconds or once every SlewDelay milliseconds while the button is held
   down.

   The SlewButton is derived from a SpeedButton and has the additional properties
      SlewDelay - delay time between slew messages in milliseconds
      SlewRepeat - True - button calls the Slew event handler every SlewDelay
                           milliseconds while the button is held down
                   False - button calls the Slew event handler only once
                           if the button is held down for SlewDelay milliseconds
      Slew - Event handler for Slew events
//*********************************************************
// Copyright © 1998 Physical Electronics, Inc.
// Created in 1998 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////
}

unit SlewButton;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Buttons, ExtCtrls;

type
   { SlewButton class derived from a SpeedButton }
   TSlewButton = class(TSpeedButton)
   private
      m_SlewDelay : longint ;      { Delay in milliseconds between slew events }
      m_SlewRepeat : Boolean ;     { TRUE - slew event is posted repeatedly }
                                   { FALSE - slew event is posted once }
      m_Slew : TNotifyEvent ;      { Slew event procedure specified by user }
      m_Timer : TTimer ;           { Timer for sending slew events }

      procedure SetSlewDelay(SlewDelay : longint) ;
      procedure SetSlewRepeat(SlewRepeat : Boolean) ;
      procedure SetSlew(Slew : TNotifyEvent) ;
      procedure Slew(Sender : TObject) ;
   protected
      procedure MouseDown(Button : TMouseButton; Shift : TShiftState;
                X, Y : Integer) ; override;
      procedure MouseUp(Button : TMouseButton; Shift : TShiftState;
                X, Y : Integer) ; override;
   public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
   published
      property SlewDelay : longint read m_SlewDelay write SetSlewDelay ;
      property SlewRepeat : Boolean read m_SlewRepeat write SetSlewRepeat ;
      property OnSlew : TNotifyEvent read m_Slew write SetSlew ;
   end;

procedure Register;

implementation

procedure Register;
{
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Registers this component so it appears in the PHI tab in Delphi
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
}
begin
  RegisterComponents('PHI Library', [TSlewButton]);
end;

constructor TSlewButton.Create(AOwner: TComponent);
{
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Constructor for this component
// Inputs:       AOwner : Component that is the parent of this button
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
}
begin
  inherited Create(AOwner);
  { Initialize member variables }
  m_SlewDelay := 200 ;
  m_SlewRepeat := FALSE ;
  m_Slew := NIL ;
  { Create Timer and initialize it }
  m_Timer := TTimer.Create(Self) ;
  m_Timer.Enabled := FALSE ;
  m_Timer.Interval := m_SlewDelay ;
  m_Timer.OnTimer := Slew ;
end; { Create }

destructor TSlewButton.Destroy;
{
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Destructor for this component
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
}
begin
  { Destroy timer }
  m_Timer.Destroy() ;
  inherited Destroy;
end; { Destroy }

procedure TSlewButton.SetSlewDelay(SlewDelay : longint) ;
{
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Sets the slew delay for the button
// Inputs:       SlewDelay - delay in milliseconds
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
}
begin
   { Make sure SlewDelay is positive and nonzero }
   if (SlewDelay > 0) then
   begin
      m_SlewDelay := SlewDelay ;
      { Set timer interval to new SlewDelay }
      m_Timer.Interval := m_SlewDelay ;
   end;
end;  { SetSlewDelay }

procedure TSlewButton.MouseDown(Button : TMouseButton; Shift : TShiftState; X, Y : Integer) ;
{
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Override of the mouse down for this button.  Turns on the timer
//               to post slew events every SlewDelay milliseconds
// Inputs:       Standard Delphi MouseDown paramters
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
}
begin
   inherited MouseDown(Button, Shift, X, Y) ;
   { Turn on timer when button is depressed }
   m_Timer.Enabled := TRUE ;
end ;

procedure TSlewButton.MouseUp(Button : TMouseButton; Shift : TShiftState;
               X, Y : Integer) ;
{
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Override of the mouse up for this button.  Turns off the timer
//               that posts slew events every SlewDelay milliseconds
// Inputs:       Standard Delphi MouseUp paramters
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
}
begin
   { Turn off timer when button is released }
   m_Timer.Enabled := FALSE ;
   inherited MouseUp(Button, Shift, X, Y) ;
end ;

procedure TSlewButton.SetSlew(Slew : TNotifyEvent) ;
{
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Sets the user's slew event handler
// Inputs:       Slew - Event handler procedure
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
}
begin
   m_Slew := Slew ;
end ;

procedure TSlewButton.SetSlewRepeat(SlewRepeat : Boolean) ;
{
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Sets slew repeat on or off
// Inputs:       SlewRepeat - TRUE - Call slew event proc every SlewDelay milliseconds
//                            FALSE - Call slew event proc once after SlewDelay milliseconds
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
}
begin
   m_SlewRepeat := SlewRepeat ;
end ;

procedure TSlewButton.Slew(Sender : TObject) ;
{
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Calls user's Slew event proc and turns off timer if SlewRepeat is off
// Inputs:       Sender - object that sent the slew message
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
}begin
   { If the user has specified an event handler for Slew messages, call it }
   if (@m_Slew <> NIL) then
   begin
      m_Slew(Sender) ;
   end ;
   { If we're not repeating the slew message, turn off the timer }
   if (not m_SlewRepeat) then
   begin
      m_Timer.Enabled := FALSE ;
   end ;
end ;

end.



