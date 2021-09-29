unit ParameterWobbleBase;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterWobbleBase.pas
// Created:   August, 2007 by John Baker
// Purpose:   This module defines the ParameterWobbleBase base class.
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
  ParameterData;

const
  c_WobbleOn = 'On';
  c_WobbleOff = 'Off';

type
  TWobbleDirection = (wobbleDirection_Increase,
                      wobbleDirection_Decrease);

  TWobbleSource = (wobbleSource_UI,
                    wobbleSource_Firmware);

  // List of view updates triggered using OnUpdate callback
  TWobbleOnUpdate = (wobbleOnUpdateAll,
                     wobbleOnUpdateWobble,
                     wobbleOnUpdateShowProperties);

  TParameterWobbleBase = class(TParameterContainer)
  private
    m_Status: TParameterBoolean;
    m_AutoMode: TParameterBoolean;

    m_Data: TParameterData;
    m_Amplitude: TParameterData;
    m_PeriodInMs: TParameterData;
    m_NumberOfSteps: TParameterData;
    m_Offset: TParameterData;
    m_Direction: TWobbleDirection;

    m_Source: TWobbleSource;

    procedure SetSource(const Value: TWobbleSource);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure Initialize(Sender: TParameter); override;

    property WobbleStatus: TParameterBoolean read m_Status;
    property WobbleAuto: TParameterBoolean read m_AutoMode;

    property Data: TParameterData read m_Data;
    property Amplitude: TParameterData read m_Amplitude;
    property PeriodInMs: TParameterData read m_PeriodInMs;
    property NumberOfSteps: TParameterData read m_NumberOfSteps;
    property Offset: TParameterData read m_Offset;
    property Direction: TWobbleDirection read m_Direction write m_Direction;

    property Source: TWobbleSource read m_Source write SetSource;
  end ;

implementation

uses
  System.SysUtils,
  System.Contnrs,

  Variants,
  Dialogs,
  ParameterPolarity;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterWobbleBase.Create(AOwner: TComponent) ;
begin
  inherited;

  // Initialize member variables
  m_Data := TParameterData.Create(Self);
  m_Data.Name:= 'Wobble Data';

  m_Amplitude := TParameterData.Create(Self);
  m_Amplitude.Name:= 'Amplitude';
  m_Amplitude.Caption:= 'Amplitude';
  m_Amplitude.Hint:= 'Amplitude';
  m_Amplitude.Min := 1.0;
  m_Amplitude.Max := 10000.0;
  m_Amplitude.Increment:= 1.0;
  m_Amplitude.Value := 1.0;
  Container.Add(m_Amplitude);

  m_PeriodInMs := TParameterData.Create(Self);
  m_PeriodInMs.Name:= 'Period (ms)';
  m_PeriodInMs.Caption:= 'Period (ms)';
  m_PeriodInMs.Hint:= 'Period (ms)';
  m_PeriodInMs.Min := 1;
  m_PeriodInMs.Max := 10000;
  m_PeriodInMs.Increment:= 100.0;
  m_PeriodInMs.Value := 1000;
  m_PeriodInMs.Precision := 0;
  Container.Add(m_PeriodInMs);

  m_NumberOfSteps:= TParameterData.Create(Self) ;
  m_NumberOfSteps.Name:= 'NumberOfSteps';
  m_NumberOfSteps.Caption:= 'Number Of Steps';
  m_NumberOfSteps.Hint:= 'Number Of Steps';
  m_NumberOfSteps.Min := 1.0;
  m_NumberOfSteps.Max := 10000.0;
  m_NumberOfSteps.Value := 1.0;
  m_NumberOfSteps.Precision := 0;
  Container.Add(m_NumberOfSteps);

  m_Offset := TParameterData.Create(Self);
  m_Offset.Name:= 'Offset';
  m_Offset.Caption:= 'Offset';
  m_Offset.Hint:= 'Offset';
  m_Offset.Precision := 1;
  m_Offset.Min := 0.0;
  m_Offset.Max := 0.9;
  m_Offset.Increment:= 0.1;
  m_Offset.Value := 0.2;
  Container.Add(m_Offset);

  m_Status := TParameterBoolean.Create(Self);
  m_Status.Name:= 'Status';
  m_Status.Caption:= 'Wobble';
  m_Status.Hint:= 'Wobble Status';
  m_Status.AddTrue(c_WobbleOn);
  m_Status.AddFalse(c_WobbleOff);
  m_Status.Value := False;

  m_AutoMode := TParameterBoolean.Create(Self);
  m_AutoMode.Name:= 'Auto';
  m_AutoMode.Caption:= 'Auto';
  m_AutoMode.Hint:= 'Auto';
  m_AutoMode.Value := False;
  Container.Add(m_AutoMode);

  m_Direction := wobbleDirection_Increase;
  m_Source := wobbleSource_UI;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy the memeber variables from the passed object
// Inputs:       TParameter
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterWobbleBase.Initialize(Sender: TParameter);
begin
  inherited;

  Name := Sender.Name + ' Wobble';

  m_Data.Name := Sender.Name + ':' + m_Data.Name;
  m_Data.Hint := Sender.Hint + ':' + m_Data.Hint;

  m_Amplitude.Name := Sender.Name + ':' + m_Amplitude.Name;
  m_Amplitude.Hint := Sender.Hint + ':' + m_Amplitude.Hint;

  m_PeriodInMs.Name := Sender.Name + ':' + m_PeriodInMs.Name;
  m_PeriodInMs.Hint := Sender.Hint + ':' + m_PeriodInMs.Hint;

  m_NumberOfSteps.Name := Sender.Name + ':' + m_NumberOfSteps.Name;
  m_NumberOfSteps.Hint := Sender.Hint + ':' + m_NumberOfSteps.Hint;

  m_Offset.Name := Sender.Name + ':' + m_Offset.Name;
  m_Offset.Hint := Sender.Hint + ':' + m_Offset.Hint;

  m_Status.Name := Sender.Name + ':' + m_Status.Name;
  m_Status.Hint := Sender.Hint + ':' + m_Status.Hint;

  m_AutoMode.Name := Sender.Name + ':' + m_AutoMode.Name;
  m_AutoMode.Hint := Sender.Hint + ':' + m_AutoMode.Hint;

  if (Sender is TParameterData) then
  begin
    m_Data.Value := (Sender as TParameterData).Value;
    m_Data.Min := (Sender as TParameterData).Min;
    m_Data.Max := (Sender as TParameterData).Max;
    m_Data.Increment := (Sender as TParameterData).Increment;
    m_Data.Precision := (Sender as TParameterData).Precision;

    m_Amplitude.Value := (Sender as TParameterData).Value;
    m_Amplitude.Min := 0.0;
    m_Amplitude.Max := ((Sender as TParameterData).Max - (Sender as TParameterData).Min) / 2.0;
    m_Amplitude.Increment := (Sender as TParameterData).Increment;
    m_Amplitude.Precision := (Sender as TParameterData).Precision;
  end;

  if (Sender is TParameterPolarity) then
  begin
    m_Data.Value := (Sender as TParameterPolarity).Value;
    m_Data.Min := (Sender as TParameterPolarity).Min;
    m_Data.Max := (Sender as TParameterPolarity).Max;
    m_Data.Increment := (Sender as TParameterPolarity).Increment;
    m_Data.Precision := (Sender as TParameterPolarity).Precision;

    m_Amplitude.Value := (Sender as TParameterPolarity).Value;
    m_Amplitude.Min := 0.0;
    m_Amplitude.Max := ((Sender as TParameterPolarity).Max - (Sender as TParameterPolarity).Min) / 2.0;
    m_Amplitude.Increment := (Sender as TParameterPolarity).Increment;
    m_Amplitude.Precision := (Sender as TParameterPolarity).Precision;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Used to determine if the wobbling is handle internal to this object,
//                or external to this object (e.g. in the .dll)
// Inputs:       TWobbleSource
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterWobbleBase.SetSource(const Value: TWobbleSource);
begin
  m_Source := Value;

  if m_Source = wobbleSource_UI then
  begin
    m_PeriodInMs.Enabled := True;
    m_NumberOfSteps.Enabled := True;
    m_Offset.Enabled := True;
  end
  else
  begin
    m_PeriodInMs.Enabled := False;
    m_NumberOfSteps.Enabled := False;
    m_Offset.Enabled := False;
  end;
end;

end.

