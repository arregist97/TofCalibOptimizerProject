unit ParameterData;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterData.pas
// Created:   on 99-12-27 by John Baker
// Purpose:   ParameterData class is used in place of Float, Double, and Integer
//             types when defining member variables in the Doc.
//*********************************************************
// Copyright © 1999 Physical Electronics, Inc.
// Created in 1999 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////
interface

uses
  Classes,
  StdCtrls,
  RealEdit,
  TrackEdit,
  ComCtrls,
  Parameter,
  AppSettings;

const
  c_DefaultMin = -1000000000000000.0;  // -1e15
  c_DefaultMax = 1000000000000000.0;   // 1e15

{TParameterData}
type
  TParameterData = class(TParameter)
  private
    m_Value: Double;
    m_InitValue: Double;
    m_UndoValue: Double;
    m_Min: Double;
    m_Max: Double;
    m_SmallInc: Double;
    m_LargeInc: Double;
    m_WarningOffset: Double;
    m_ErrorOffset: Double;
    m_ValueChanged: TNotifyEvent;

    function MinMaxCheck(var FloatValue: Double): Boolean;
    procedure SetMin(MinValue: Double);
    procedure SetMax(MaxValue: Double);
    procedure ValueChangedTrigger(State: TParameterState=psOK);

    function GetReadback(): TParameterData;
  protected
    function GetPrecision(): Integer; override;
    function GetIncrement(): Double;
    function GetValueAsFloat(): Double; override;
    function GetValueAsInt(): Integer; override;
    function GetValueAsString(): String; override;
    function GetValueAsVariant(): OleVariant; override;
    function GetParameterState(): TParameterState; override;

    procedure SetValueAsFloat(FloatValue: Double); override;
    procedure SetValueAsInt(IntValue: Integer); override;
    procedure SetValueAsString(StringValue: String); override;
    procedure SetValueAsVariant(VariantValue: OleVariant); override;
    procedure SetParameterState(const Value: TParameterState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function Changed(): Boolean; override;
    procedure Initialize(Sender: TParameter); override;
    procedure InitHistory(); override;
    procedure InitReadback(); override;
    procedure SaveInit(); override;
    procedure SaveUndo(); override;
    procedure Undo(); override;

    // UI Update Methods
    procedure ToEditBox(EditPtr: TEdit);
    procedure ToProgressBar(ProgressBarPtr: TProgressBar);
    procedure ToRealEdit(RealEditPtr: TRealEdit); overload;
    procedure ToRealEdit(EditPtr: TEdit); overload;
    procedure ToStaticText(StaticTextPtr: TStaticText;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);
    procedure ToTrackBar(TrackBarPtr: TTrackBar);
    procedure ToTrackEdit(TrackEditPtr: TTrackEdit); override;

    function IsValidRealEdit(EditPtr: TEdit; Key: Word; Shift: TShiftState): Boolean;

    property DataValue: Double read m_Value write m_Value;
    property Increment: Double read m_SmallInc write m_SmallInc;
    property SlewIncrement: Double read m_SmallInc write m_SmallInc;
    property SmallIncrement: Double read m_SmallInc write m_SmallInc;
    property LargeIncrement: Double read m_LargeInc write m_LargeInc;
    property Max: Double read m_Max write SetMax;
    property Min: Double read m_Min write SetMin;
    property UndoValue: Double read m_UndoValue write m_UndoValue;
    property Value: Double read GetValueAsFloat write SetValueAsFloat;
    property ParameterState: TParameterState read GetParameterState write SetParameterState;
    property WarningOffset: Double read m_WarningOffset write m_WarningOffset;
    property ErrorOffset: Double read m_ErrorOffset write m_ErrorOffset;

    property OnValueChange: TNotifyEvent read m_ValueChanged write m_ValueChanged;

    procedure CheckReadbackValueLimits;
    property Readback: TParameterData read GetReadback;
  end;

implementation

uses
  System.UITypes,
  Windows,
  Messages,
  Dialogs,
  SysUtils,
  PhiMath,
  Math,
  Graphics,
  ParameterHistory;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Initialize member variables
  m_Value := 0.0;
  m_InitValue := m_Value;
  m_UndoValue := m_Value;
  m_Min := c_DefaultMin;
  m_Max := c_DefaultMax;
  m_SmallInc := 1.0;
  m_LargeInc := 1.0;
  m_ValueChanged := nil;
  m_WarningOffset := 0.0;
  m_ErrorOffset := 0.0;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TParameterData.Destroy();
begin
   inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if 'Value' has changed
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterData.Changed(): Boolean;
var
  ScaleFactor: Double;
begin
  ScaleFactor := power(10, GetPrecision());
  if ((round(m_InitValue * ScaleFactor)) <> (round(m_Value * ScaleFactor))) then
    Result := True
  else
    Result := False;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy the memeber variables from the passed object
// Inputs:       TParameter
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.Initialize(Sender: TParameter);
begin
  inherited;

  if (Sender is TParameterData) then
  begin
    m_Value := (Sender as TParameterData).m_Value;
    m_InitValue := (Sender as TParameterData).m_InitValue;
    m_UndoValue := (Sender as TParameterData).m_UndoValue;
    m_Min := (Sender as TParameterData).m_Min;
    m_Max := (Sender as TParameterData).m_Max;
    m_SmallInc := (Sender as TParameterData).m_SmallInc;
    m_LargeInc := (Sender as TParameterData).m_LargeInc; 
    m_WarningOffset := (Sender as TParameterData).m_WarningOffset;
    m_ErrorOffset := (Sender as TParameterData).m_ErrorOffset;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save the 'Init' value
// Inputs:       None
// Outputs:      None
// Note:         The 'Init' value is typically saved when a TParameter value is
//               changed as part of a 'Load' Setting or 'Load' File.  The 'Init'
//               value does not change during the running of an application and is
//               therefore, available as a check to see if the value has changed.
//               See the Changed() method above.  Note that the 'Undo' value is
//               also saved here.
////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.SaveInit();
begin
  m_InitValue := m_Value;
  m_UndoValue := m_Value;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save the 'Undo' value
// Inputs:       None
// Outputs:      None
// Note:         The 'Undo' value is also saved when a TParameter value is
//               changed as part of a 'Load' Setting or 'Load' File.  The 'Undo'
//               value, however, is typically changed many times during the
//               running of an application (each time a property dialog is displayed)
////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.SaveUndo();
begin
  m_UndoValue := m_Value;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Single step undo back to the 'Undo' value.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.Undo();
begin
  m_Value := m_UndoValue;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Check that the data value is within min/max range.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterData.MinMaxCheck(var FloatValue: Double): Boolean;
begin
  // Check if min or max was clipped
  Result := False;

  if (FloatValue < Min) then
  begin
    FloatValue := Min;
    Result := True;
  end
  else if (FloatValue > Max) then
  begin
    FloatValue := Max;
    Result := True;
  end;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the increment.
// Inputs:       Double
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterData.GetIncrement(): Double;
var
  fIncrement: Double;
  fValue: Double;
begin
  if StringFormat = fmtScientific then
  begin
    if (not bEffectivelyEquals(m_Value, m_Max, 1E-10)) and (not bEffectivelyEquals(m_Value, m_Min, 1E-10)) then
    begin
      // Not at an endpoint so recalculate the slew increment; otherwise will use the previous increment
      fValue := abs(m_Value);
      fIncrement := 1.0;

      if fValue > 1.0 then
      begin
        while (fIncrement < fValue) do
          fIncrement := fIncrement * 10.0;
      end
      else if (1.0 >= fValue) and (fValue > 0.0) then
      begin
        while not(bIsEffectivelyLTE(fIncrement, fValue, 1E-10)) do
          fIncrement := fIncrement / 10.0;
      end;
      m_SmallInc := fIncrement / power(10, Precision);
    end;
  end;

  Result := m_SmallInc;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the precision.
// Inputs:       Integer
// Outputs:      None
// Note:         Default precision is only possible the first time this routine
//               is called.  After that, precision is set.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterData.GetPrecision(): Integer;
var
  FloatValue: Double;
begin
  if (m_Precision = c_DefaultPrecision) then
  begin
    // Set default precision to match resolution of increment
    m_Precision := 0;
    FloatValue := 1;
    while FloatValue > abs(m_SmallInc) do
    begin
      FloatValue := FloatValue / 10.0;
      m_Precision := m_Precision + 1;
    end;
  end;
  Result := m_Precision;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return current value.
// Inputs:       None
// Outputs:      Value as Float
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterData.GetValueAsFloat(): Double;
begin
  result := m_Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return current value.
// Inputs:       None
// Outputs:      Value as Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterData.GetValueAsInt(): Integer;
begin
  result := round(m_Value);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return current value.
// Inputs:       None
// Outputs:      Value as String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterData.GetValueAsString(): String;
begin
  Result := ParameterFloatToStr(m_Value);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current value as a Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterData.GetValueAsVariant(): OleVariant;
begin
  case FileVariantType of
    variantValueAsDefault: Result := Value;
    variantValueAsString: Result := ValueAsString;
    variantValueAsFloat: Result := ValueAsFloat;
    variantValueAsInt: Result := ValueAsInt;
  else;
    Result := Value;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set minimum data value.
// Inputs:       Double
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.SetMin(MinValue: Double);
var
  ValueChanged: Boolean;
begin
  m_Min := MinValue;

  // Make sure m_Value is withing the new min/max range
  ValueChanged := MinMaxCheck(m_Value);

  if ValueChanged then
    ValueChangedTrigger;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set maximum data value.
// Inputs:       Double
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.SetMax(MaxValue: Double);
var
  ValueChanged: Boolean;
begin
  m_Max := MaxValue;

  // Make sure m_Value is withing the new min/max range
  ValueChanged := MinMaxCheck(m_Value);

  if ValueChanged then
    ValueChangedTrigger;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as a double.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.SetValueAsFloat(FloatValue: Double);
begin
  m_Value := FloatValue;

  // Make sure m_Value is withing min/max range
  MinMaxCheck(m_Value);

  // Check the readback value against the new value.
  CheckReadbackValueLimits;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as an integer.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.SetValueAsInt(IntValue: Integer);
begin
  m_Value := IntValue;

  // Make sure m_Value is withing min/max range
  MinMaxCheck(m_Value);

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as a string.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.SetValueAsString(StringValue: String);
var
  bValidConversion: Boolean;
begin
  bValidConversion := False;

  if not bValidConversion then
  begin
    if StringFormat = fmtHexadecimal then
    begin
      try
        m_Value := StrToInt(StringValue);
        bValidConversion := True;
      except
      end;
    end;
  end;

  if not bValidConversion then
  begin
    try
      m_Value := StrToFloat(StringValue);
      bValidConversion := True;
    except
    end;
  end;

  if not bValidConversion then
  begin
    try
      m_Value := StrToDateTime(StringValue);
      bValidConversion := True;
    except
    end;
  end;

  if not bValidConversion then
    m_Value := 0.0;

  // Make sure m_Value is withing min/max range
  MinMaxCheck(m_Value);

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current value to the value of the Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.SetValueAsVariant(VariantValue: OleVariant);
begin
  case FileVariantType of
    variantValueAsDefault: Value := VariantValue;
    variantValueAsString: ValueAsString := VariantValue;
    variantValueAsFloat: ValueAsFloat := VariantValue;
    variantValueAsInt: ValueAsInt := VariantValue;
  else;
    Value := VariantValue;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fire and event when the value changes
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.ValueChangedTrigger(State: TParameterState);
begin
  // Set the parameter state.
  m_ParameterState := State;

  if Assigned (m_History) then
    m_History.ParameterState := State;

  // Set the next time when another read will be allowed.
  SetReadbackTimeNextReadAllowed();

  // Save the value in the historical data database and the chart recorder.
  if Assigned(m_History) then
  begin
    TParameterHistory(m_History).Value := ValueAsFloat;
  end;

  // Call the value changed callback.
  if Assigned(m_ValueChanged) then
  begin
    m_ValueChanged(Self);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// History
////////////////////////////////////////////////////////////////////////////////

// InitHistory
procedure TParameterData.InitHistory;
begin
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
// Readback
////////////////////////////////////////////////////////////////////////////////

// InitReadback
procedure TParameterData.InitReadback;
var
  parameterData: TParameterData;
begin
  if not assigned(m_Readback) then
  begin
    parameterData := TParameterData.Create(Self);
    parameterData.Initialize(Self);

    parameterData.Name := GetReadbackName(Name);
    parameterData.Caption := Caption;
    parameterData.CaptionLong := CaptionLong;
    parameterData.Hint := GetReadbackHint(Hint);
    parameterData.Units := Units;

    // Open up limits for readback values
    parameterData.Min := c_DefaultMin;
    parameterData.Max := c_DefaultMax;
    parameterData.Increment := 1.0;

    m_Readback := TParameter(parameterData);
  end;
end;

// GetReadback
function TParameterData.GetReadback: TParameterData;
begin
  if not assigned(m_Readback) then
  begin
    InitReadback();
  end;

  Result := TParameterData(m_Readback)
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// UI Update Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TEdit component
// Inputs:       TEdit
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.ToEditBox(EditPtr: TEdit);
begin
  EditPtr.Color := GetBackgroundColor(c_ColorBackgroundEdit);
  EditPtr.Font.Color := GetForegroundColor(c_ColorForegroundEdit);

  if (Hint <> c_DefaultHint) then
  begin
    EditPtr.ShowHint := True;
    EditPtr.Hint := Hint;
  end;

  EditPtr.Visible := Visible;
  EditPtr.Enabled := Enabled;
  EditPtr.Text := GetValueAsString();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TProgressBar component
// Inputs:       TProgressBar
// Outputs:      None
// Note:  Will set up progress bars to display percentage values from 0-100%
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.ToProgressBar(ProgressBarPtr: TProgressBar);
begin
  if (Hint <> c_DefaultHint) then
  begin
    ProgressBarPtr.ShowHint := True;
    ProgressBarPtr.Hint := Hint;
  end;

  ProgressBarPtr.Visible := Visible;
  ProgressBarPtr.Enabled := Enabled and (not m_ReadOnly);

  // Set progress bar position in (%)
  ProgressBarPtr.Min := 0;
  ProgressBarPtr.Max := 100;
  try
    ProgressBarPtr.Position := Round(100 * ((m_Value - m_Min) / (m_Max - m_Min)));
  except
    ProgressBarPtr.Position := 0;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TRealEdit component.
// Inputs:       TRealEdit
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.ToRealEdit(RealEditPtr: TRealEdit);
var
  wiggleRoom: Double;
  status: Integer;
begin
  RealEditPtr.BackColor := GetBackgroundColor(BackgroundColor);
  RealEditPtr.ForeColor := GetForegroundColor(ForegroundColor);

  if (Hint <> c_DefaultHint) then
  begin
    RealEditPtr.ShowHint := True;
    RealEditPtr.Hint := Hint;
  end;

  RealEditPtr.Visible := Visible;
  RealEditPtr.Enabled := Enabled;
  RealEditPtr.ReadOnly := m_ReadOnly;
  RealEditPtr.Precision := GetPrecision();
  if StringFormat = fmtScientific then
  begin
    RealEditPtr.ScientificNotation := True;

    // Doesn't work for scientific notation
    wiggleRoom := 0.0;
  end
  else
  begin
    RealEditPtr.ScientificNotation := False;

    // Using the precision, give the min and max some wiggle room
    wiggleRoom := 1.0 / (power(10, GetPrecision()) * 10);
  end;

  // Set the actual data value and precision (Should really be handle by one call)
  RealEditPtr.Minimum := m_Min - wiggleRoom;
  RealEditPtr.Maximum := m_Max + wiggleRoom;
  RealEditPtr.SetDataValue(status, m_Value);

  // Set increment after Min and Max!
  RealEditPtr.Increment := GetIncrement();
end;
                
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TEdit component
// Inputs:       TEdit
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.ToRealEdit(EditPtr: TEdit);
begin
  EditPtr.Color := GetBackgroundColor(c_ColorBackgroundEdit);
  EditPtr.Font.Color := GetForegroundColor(c_ColorForegroundEdit);

  if m_ReadOnly then
  begin
    EditPtr.ShowHint := True;
    EditPtr.Hint := 'Read-only';
    EditPtr.ReadOnly := True;
   end
  else
  begin
    EditPtr.ShowHint := True;
    EditPtr.Hint := ParameterFloatToStr(m_Min) + ' <= Value <= ' + ParameterFloatToStr(m_Max);
  end;

  EditPtr.Visible := Visible;
  EditPtr.Enabled := Enabled;
  EditPtr.Text := GetValueAsString();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TLabel component
// Inputs:       TLabel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.ToStaticText(StaticTextPtr: TStaticText; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  StaticTextPtr.Color := GetBackgroundColor(c_ColorBackgroundLabel);
  StaticTextPtr.Font.Color := GetForegroundColor(c_ColorForegroundLabel);

  if (Hint <> c_DefaultHint) then
  begin
    StaticTextPtr.ShowHint := True;
    StaticTextPtr.Hint := GetHintUsingMode(HintMode);
  end;

  StaticTextPtr.Transparent := False;
  StaticTextPtr.Visible := GetVisibleUsingMode(VisibleMode);
  StaticTextPtr.Enabled := GetEnabledUsingMode(EnabledMode) and (not m_ReadOnly);
  StaticTextPtr.Caption := GetValueAsString();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TTrackBar component
// Inputs:       TTrackBar
// Outputs:      None
// Note:  Will set up progress bars to display percentage values from 0-100%
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.ToTrackBar(TrackBarPtr: TTrackBar);
begin
  if (Hint <> c_DefaultHint) then
  begin
    TrackBarPtr.ShowHint := True;
    TrackBarPtr.Hint := Hint;
  end;

  TrackBarPtr.Visible := Visible;
  TrackBarPtr.Enabled := Enabled and (not m_ReadOnly);

  // Set track bar position in (%); Note: This should be rewritten to handle actual
  // data values in final implementation.  Also should support accelerator key
  TrackBarPtr.Min := 0;
  TrackBarPtr.Max := 100;
  TrackBarPtr.Frequency := 10;
  try
    TrackBarPtr.Position := Round(100 * (m_Value / (m_Max - m_Min)));
  except
    TrackBarPtr.Position := 0;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TTrackEdit component.
// Inputs:       TTrackEdit
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.ToTrackEdit(TrackEditPtr: TTrackEdit);
var
  wiggleRoom: Double;
  status: Integer;
begin
//  TrackEditPtr.BackColor := GetBackgroundColor(BackgroundColor);
//  TrackEditPtr.ForeColor := GetForegroundColor(ForegroundColor);

  if (Hint <> c_DefaultHint) then
  begin
    TrackEditPtr.ShowHint := True;
    TrackEditPtr.Hint := Hint;
  end;

  TrackEditPtr.Visible := Visible;
  TrackEditPtr.Enabled := Enabled;
  TrackEditPtr.ReadOnly := m_ReadOnly;
  TrackEditPtr.Precision := GetPrecision();

  // Using the precision, give the min and max some wiggle room
  wiggleRoom := 1.0 / (power(10, GetPrecision()) * 10);

  // Min, max, increment (Should really be handle by one call)
  TrackEditPtr.Minimum := m_Min - wiggleRoom;
  TrackEditPtr.Maximum := m_Max + wiggleRoom;
  TrackEditPtr.Increment := GetIncrement();

  // Set the actual data value
  TrackEditPtr.SetDataValue(status, m_Value);
end;
                
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Expand TEdit behavior to look like TRealEdit
// Inputs:       TEdit
// Outputs:      None
// Note:         Used to mimic the real edit behavior.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterData.IsValidRealEdit(EditPtr: TEdit; Key: Word; Shift: TShiftState): Boolean;
var
  newValue: Double;
begin
  Result := False;

  if Key = 13 then // Return Key
  begin
    try
      newValue := StrToFloat(EditPtr.Text);

      if (newValue >= m_Min) and (newValue <= m_Max) then
        Result := True
      else
        EditPtr.Color := clRed;
    except
    end;
  end;

  if Key = 38 then // Up Arrow Key (slewing)
  begin
    // Update the slew increment as needed
    GetIncrement();

    if Shift = [ssShift] then
      newValue := m_Value + (m_SmallInc * 10.0)
    else if Shift = [ssCtrl] then
      newValue := m_Value + (m_SmallInc * 0.1)
    else
      newValue := m_Value + m_SmallInc;

    if newValue < m_Min then
      newValue := m_Min
    else if newValue > m_Max then
      newValue := m_Max;

    EditPtr.Text := FloatToStr(newValue);
    Result := True
  end;

  if Key = 40 then // Down Arrow Key (slewing)
  begin
    // Update the slew increment as needed
    GetIncrement();

    if Shift = [ssShift] then
      newValue := m_Value - (m_SmallInc * 10.0)
    else if Shift = [ssCtrl] then
      newValue := m_Value - (m_SmallInc * 0.1)
    else
      newValue := m_Value - m_SmallInc;

    if newValue < m_Min then
      newValue := m_Min
    else if newValue > m_Max then
      newValue := m_Max;

    EditPtr.Text := FloatToStr(newValue);
    Result := True
  end;

end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Check the readback value against the warning and error limits.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterData.CheckReadbackValueLimits;
begin
  if Assigned(m_Readback) then
  begin
    // Initialize the Parameter Value State to normal.
    Readback.ParameterValueState := pvsNormal;

    // If a warning offset is defined, check the readback value against the limit.
    if m_WarningOffset <> 0.0 then
    begin
      if (Readback.ValueAsFloat > (m_Value + m_WarningOffset)) or
         (Readback.ValueAsFloat < (m_Value - m_WarningOffset)) then
      begin
        Readback.ParameterValueState := pvsWarning;
      end;
    end;

    // If an error offset is defined, check the readback value against the limit.
    if m_ErrorOffset <> 0.0 then
    begin
      if (Readback.ValueAsFloat > (m_Value + m_ErrorOffset)) or
         (Readback.ValueAsFloat < (m_Value - m_ErrorOffset)) then
      begin
        Readback.ParameterValueState := pvsError;
      end;
    end;
  end;
end;

// GetParameterState
function TParameterData.GetParameterState(): TParameterState;
begin
  Result := m_ParameterState;
end;

// SetParameterState
procedure TParameterData.SetParameterState(const Value: TParameterState);
begin
  // Trigger a changed event to anyone listening; only if the parameter state changes
  if (Value <> m_ParameterState) then
    ValueChangedTrigger(Value);
end;

end.

