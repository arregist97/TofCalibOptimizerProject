unit ParameterPolarity;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterPolarity.pas
// Created:   on 99-12-27 by John Baker
// Purpose:   ParameterPolarity class is used in place of Float, Double, and Integer
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
  IniFiles,
  Registry,
  Parameter,
  ParameterData,
  AppSettings;

const
  c_DefaultMin = -1000000000000000.0;  // -1e15
  c_DefaultMax = 1000000000000000.0;   // 1e15

  c_plPositive = '+';
  c_plNegative = '-';

{TParameterPolarity}
type
  TPolarityType = (plPositive, plNegative);

  // plPolarityStyleTwoValue: Two parameters with matching polarities.  The first
  //    value (m_PosValue) is returned when polarity is positve, and the second
  //    value (m_NegValue) is returned when the polarity is negative.  One can safely
  //    switch between TParameterData and TParameterPolarity data types.
  // plPolarityStylePositiveNegative: Two parameters with a positive and negative value.
  //    Both values are stored as absolute values (and displayed in the UI as
  //    absolute values).  The signed polarity is only returned when accessing
  //    using ValueAsPolarity.  ValueAsPolarity is typically needed when sending
  //    to hardware. Caution must be used when switching from TParameterData
  //    to TParameterPolarity as there will be multiple changes needed, most of which
  //    are not caught by the compiler.
  // plPolarityStyleInvertPositiveNegative: Two parameters with positive and
  //    negative values.  Same as plPolarityStylePositiveNegative except that
  //    ValueAsPolarity will return the negative value when polarity is
  //    positive and ViceVersa.
  TPolarityStyle = (plPolarityStyleTwoValue, plPolarityStylePositiveNegative, plPolarityStyleInvertPositiveNegative);

  TParameterPolarity = class(TParameter)
  private
    // Positive
    m_PosValue: Double;
    m_PosInitValue: Double;
    m_PosUndoValue: Double;

    // Negative
    m_NegValue: Double;
    m_NegInitValue: Double;
    m_NegUndoValue: Double;
    m_ValidNegativeValue: Boolean;

    m_Polarity: TPolarityType;
    m_PolarityStyle: TPolarityStyle;

    m_Min: Double;
    m_Max: Double;
    m_SlewInc: Double;

    m_ValueChanged: TNotifyEvent;

    procedure SetInitValue(dValue: Double);
    procedure SetUndoValue(dValue: Double);
    procedure SetMin(MinValue: Double);
    procedure SetMax(MaxValue: Double);

    function GetInitValue: Double;
    function GetUndoValue: Double;
    function GetMin: Double;
    function GetMax: Double;

    function MinMaxCheck(): Boolean;
    procedure ValueChangedTrigger;

    function ConstructString(): String;
    procedure DeConstructString(sValue: String; var fPosValue: Double; var fNegValue: Double);

    function GetReadback(): TParameterData;
  protected
    function GetCaption(): String; override;
    function GetHint(): String; override; 
    function GetIncrement(): Double;
    function GetPrecision(): Integer; override;

    function GetValueAsPolarity(): Double; overload;
    function GetValueAsFloat(): Double; override;
    function GetValueAsInt(): Integer; override;
    function GetValueAsString(): String; override;
    function GetValueAsVariant(): OleVariant; override;

    procedure SetValueAsPolarity(FloatValue: Double); overload;
    procedure SetValueAsPositive(FloatValue: Double);
    procedure SetValueAsNegative(FloatValue: Double);
    procedure SetValueAsFloat(FloatValue: Double); override;
    procedure SetValueAsInt(IntValue: Integer); override;
    procedure SetValueAsString(StringValue: String); override;
    procedure SetValueAsVariant(VariantValue: OleVariant); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    function Changed(): Boolean; override;
    procedure Initialize(Sender: TParameter); override;
    procedure InitReadback(); override;
    procedure SaveInit(); override;
    procedure SaveUndo(); override;
    procedure Undo(); override;

    procedure CopyPolarity();

    procedure ReadValueFromSetting(IniFile: TCustomIniFile); override;
    procedure ReadValueFromSetting(IniFile: TCustomIniFile; TagName: String); override;
    procedure ReadValueFromRegistry(RegIniFile: TRegIniFile); override;
    procedure WriteValueToSetting(IniFile: TCustomIniFile); override;
    procedure WriteValueToSetting(IniFile: TCustomIniFile; TagName: String); override;
    procedure WriteValueToSetting(var FileId: TextFile); override;
    procedure WriteValueToSetting(var FileId: TextFile; TagName: String); override; 
    procedure WriteValueToAcq(Section: String; AppSettings: TAppSettings); override;
    procedure WriteValueToRegistry(RegIniFile: TRegIniFile); override;

    // AppSettings Conversion
    function AppSettingsToFloat(AppSettings: TAppSettings; Section: String): Double; override;

    // UI Update Methods
    procedure ToLabel(LabelPtr: TLabel;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);
    procedure ToProgressBar(ProgressBarPtr: TProgressBar);
    procedure ToRealEdit(RealEditPtr: TRealEdit); overload;
    procedure ToStaticText(StaticTextPtr: TStaticText;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);
    procedure ToTrackBar(TrackBarPtr: TTrackBar);
    procedure ToTrackEdit(TrackEditPtr: TTrackEdit); override;

    property Min: Double read getMin write SetMin;
    property Max: Double read GetMax write SetMax;
    property Increment: Double read m_SlewInc write m_SlewInc;

    property Value: Double read GetValueAsFloat write SetValueAsFloat;
    property ValueAsPolarity: Double read GetValueAsPolarity write SetValueAsPolarity;
    property ValueAsPositive: Double read m_PosValue write SetValueAsPositive;
    property ValueAsNegative: Double read m_NegValue write SetValueAsNegative;
    property InitValue: Double read GetInitValue write SetInitValue;
    property UndoValue: Double read GetUndoValue write SetUndoValue;
    property Polarity: TPolarityType read m_Polarity write m_Polarity;
    property PolarityStyle: TPolarityStyle read m_PolarityStyle write m_PolarityStyle;
    property Readback: TParameterData read GetReadback;

    property OnValueChange: TNotifyEvent read m_ValueChanged write m_ValueChanged;
  end;

implementation

uses
  Windows,
  Messages,
  SysUtils,
  PhiMath,
  Math,
  Graphics;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterPolarity.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  m_ParameterTypePolarity := True;

  // Initialize member variables
  m_PosValue := 0.0;
  m_PosInitValue := m_PosValue;
  m_PosUndoValue := m_PosValue;

  m_NegValue := 0.0;
  m_NegInitValue := m_NegValue;
  m_NegUndoValue := m_NegValue;
  m_ValidNegativeValue := False;

  m_Polarity := plPositive;
  m_PolarityStyle := plPolarityStyleTwoValue;

  m_Min := c_DefaultMin;
  m_Max := c_DefaultMax;
  m_SlewInc := 1.0;
  m_ValueChanged := nil;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TParameterPolarity.Destroy();
begin
   inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if 'Value' has changed
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterPolarity.Changed(): Boolean;
var
  ScaleFactor: Double;
begin
  ScaleFactor := power(10, GetPrecision());
  if ((round(InitValue * ScaleFactor)) <> (round(Value * ScaleFactor))) then
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
procedure TParameterPolarity.Initialize(Sender: TParameter);
begin
  inherited;

  if (Sender is TParameterPolarity) then
  begin
    m_PosValue := (Sender as TParameterPolarity).m_PosValue;
    m_PosInitValue := (Sender as TParameterPolarity).m_PosInitValue;
    m_PosUndoValue := (Sender as TParameterPolarity).m_PosUndoValue;
    m_NegValue := (Sender as TParameterPolarity).m_NegValue;
    m_NegInitValue := (Sender as TParameterPolarity).m_NegInitValue;
    m_NegUndoValue := (Sender as TParameterPolarity).m_NegUndoValue;
    m_Min := (Sender as TParameterPolarity).m_Min;
    m_Max := (Sender as TParameterPolarity).m_Max;
    m_SlewInc := (Sender as TParameterPolarity).m_SlewInc;
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
procedure TParameterPolarity.SaveInit();
begin
  InitValue := Value;
  UndoValue := Value;
end;

procedure TParameterPolarity.SetInitValue(dValue: Double);
begin
  if m_Polarity = plPositive then
    m_PosInitValue := dValue
  else
    m_NegInitValue := dValue;
end;

function TParameterPolarity.GetInitValue: Double;
begin
  if m_Polarity = plPositive then
    result := m_PosInitValue
  else
    result := m_NegInitValue;
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
procedure TParameterPolarity.SaveUndo();
begin
  UndoValue := Value;
end;

procedure TParameterPolarity.SetUndoValue(dValue: Double);
begin
  if m_Polarity = plPositive then
    m_PosUndoValue := dValue
  else
    m_NegUndoValue := dValue;
end;

function TParameterPolarity.GetUndoValue: Double;
begin
  if m_Polarity = plPositive then
    result := m_PosUndoValue
  else
    result := m_NegUndoValue;
end;

function TParameterPolarity.GetMin: Double;
begin
  result := m_Min;
end;

function TParameterPolarity.GetMax: Double;
begin
  result := m_Max;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Single step undo back to the 'Undo' value.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.Undo();
begin
  Value := UndoValue;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy value from current polarity to opposite polarity
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.CopyPolarity();
begin
  if m_Polarity = plPositive then
    m_NegValue := m_PosValue
  else
    m_PosValue := m_NegValue;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Check that the data value is within min/max range.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterPolarity.MinMaxCheck(): Boolean;
begin
  Result := False;

  if (Value < Min) then
  begin
    Value := Min;
    Result := True;
  end
  else if (Value > Max) then
  begin
    Value := Max;
    Result := True;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the 'Caption'
// Inputs:       None
// Outputs:      Result: String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterPolarity.GetCaption: String;
var
  sPolarity: String;
begin
  if m_PolarityStyle = plPolarityStylePositiveNegative then
  begin
    if m_Polarity = plPositive then
      sPolarity := c_plPositive
    else
      sPolarity := c_plNegative;
  end
  else if m_PolarityStyle = plPolarityStyleInvertPositiveNegative then
  begin
    if m_Polarity = plPositive then
      sPolarity := c_plNegative
    else
      sPolarity := c_plPositive;
  end
  else if m_PolarityStyle = plPolarityStyleTwoValue then
    sPolarity := '';

  Result := StringReplace(m_Caption, '(', '('+ sPolarity, []);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Hint
// Inputs:       None
// Outputs:      Hint as String
// Note:         Hint depends on System Level vs. User Level.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterPolarity.GetHint: String;
begin
  if (UserLevel <= SystemLevel) then
  begin
    if m_PolarityStyle = plPolarityStylePositiveNegative then
      Result := m_Hint + '(+/-)'
    else if m_PolarityStyle = plPolarityStyleInvertPositiveNegative then
      Result := m_Hint + '(-/+)'
    else if m_PolarityStyle = plPolarityStyleTwoValue then
      Result := m_Hint;
  end
  else if (UserLevel = ulSuperuser) then
    Result := '''Superuser'' password protected'
  else if (UserLevel = ulService) then
    Result := '''Service'' password protected'
  else if (UserLevel = ulOpen) then
    Result := '''Open'' password protected'
end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the increment.
// Inputs:       Double
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterPolarity.GetIncrement(): Double;
var
  fIncrement: Double;
  fValue: Double;
begin
  if StringFormat = fmtScientific then
  begin
    if (not bEffectivelyEquals(Value, m_Max, 1E-10)) and (not bEffectivelyEquals(Value, m_Min, 1E-10)) then
    begin
      // Not at an endpoint so recalculate the slew increment; otherwise will use the previous increment
      fValue := abs(Value);
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
      m_SlewInc := fIncrement / power(10, Precision);
    end;
  end;

  Result := m_SlewInc;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the precision.
// Inputs:       Integer
// Outputs:      None
// Note:         Default precision is only possible the first time this routine
//               is called.  After that, precision is set.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterPolarity.GetPrecision(): Integer;
var
  FloatValue: Double;
begin
  if (m_Precision = c_DefaultPrecision) then
  begin
    // Set default precision to match resolution of increment
    m_Precision := 0;
    FloatValue := 1;
    while FloatValue > abs(m_SlewInc) do
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
function TParameterPolarity.GetValueAsPolarity(): Double;
begin
  if m_PolarityStyle = plPolarityStylePositiveNegative then
  begin
    if m_Polarity = plPositive then
      result := m_PosValue
    else
      result := -m_NegValue;
  end
  else if m_PolarityStyle = plPolarityStyleInvertPositiveNegative then
  begin
    if m_Polarity = plPositive then
      result := -m_PosValue
    else
      result := m_NegValue;
  end
  else if m_PolarityStyle = plPolarityStyleTwoValue then
  begin
    if m_Polarity = plPositive then
      result := m_PosValue
    else
      result := m_NegValue;
  end
  else
    result := m_PosValue;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return current value.
// Inputs:       None
// Outputs:      Value as Float
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterPolarity.GetValueAsFloat(): Double;
begin
  if m_Polarity = plPositive then
    result := m_PosValue
  else
    result := m_NegValue
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return current value.
// Inputs:       None
// Outputs:      Value as Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterPolarity.GetValueAsInt(): Integer;
begin
  result := round(Value);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return current value.
// Inputs:       None
// Outputs:      Value as String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterPolarity.GetValueAsString(): String;
begin
  Result := ParameterFloatToStr(Value);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current value as a Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterPolarity.GetValueAsVariant(): OleVariant;
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
procedure TParameterPolarity.SetMin(MinValue: Double);
var
  ValueChanged: Boolean;
begin
  m_Min := MinValue;

  // Make sure m_Value is withing the new min/max range
  ValueChanged := MinMaxCheck();

  if ValueChanged then
    ValueChangedTrigger;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set maximum data value.
// Inputs:       Double
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.SetMax(MaxValue: Double);
var
  ValueChanged: Boolean;
begin
  m_Max := MaxValue;

  // Make sure m_Value is withing the new min/max range
  ValueChanged := MinMaxCheck();

  if ValueChanged then
    ValueChangedTrigger;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as a double.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.SetValueAsPolarity(FloatValue: Double);
begin
  if m_PolarityStyle = plPolarityStylePositiveNegative then
  begin
    if m_Polarity = plPositive then
      m_PosValue := FloatValue
    else
      m_NegValue := -FloatValue
  end
  else if m_PolarityStyle = plPolarityStyleInvertPositiveNegative then
  begin
    if m_Polarity = plPositive then
      m_PosValue := -FloatValue
    else
      m_NegValue := FloatValue
  end
  else if m_PolarityStyle = plPolarityStyleTwoValue then
  begin
    if m_Polarity = plPositive then
      m_PosValue := FloatValue
    else
      m_NegValue := FloatValue
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as a double.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.SetValueAsPositive(FloatValue: Double);
begin
  m_PosValue := FloatValue;

  if not m_ValidNegativeValue then
  begin
    m_NegValue := FloatValue;

    m_ValidNegativeValue := True;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as a double.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.SetValueAsNegative(FloatValue: Double);
begin
  m_NegValue := FloatValue;

  m_ValidNegativeValue := True;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as a double.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.SetValueAsFloat(FloatValue: Double);
begin
  if m_Polarity = plPositive then
    ValueAsPositive := FloatValue
  else
    ValueAsNegative := FloatValue;

  // Make sure Value is withing min/max range
  MinMaxCheck;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as an integer.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.SetValueAsInt(IntValue: Integer);
begin
  Value := IntValue;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as a string.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.SetValueAsString(StringValue: String);
begin
  try
    if (StringFormat = fmtHexadecimal) then
      Value := StrToInt(StringValue)
    else
      Value := StrToFloat(StringValue);
  except
    Value := 0.0;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current value to the value of the Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.SetValueAsVariant(VariantValue: OleVariant);
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
procedure TParameterPolarity.ValueChangedTrigger;
begin
  // Value changed; clear any error set by application
  m_ParameterState := psOk;

  if Assigned(m_ValueChanged) then
  begin
    m_ValueChanged(Self);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// File Access
////////////////////////////////////////////////////////////////////////////////////////////////////////

// ConstructString
function TParameterPolarity.ConstructString(): String;
var
  sPosValue: String;
  sNegValue: String;
begin
  sPosValue := ParameterFloatToStr(m_PosValue);
  sNegValue := ParameterFloatToStr(m_NegValue);

  Result := sPosValue + ', ' + sNegValue;
end;

// DeConstructString
procedure TParameterPolarity.DeConstructString(sValue: String; var fPosValue: Double; var fNegValue: Double);
var
  sParseString: String;
  iDelimiterIndex: Integer;
  sPosValue, sNegValue: String;
begin
  sParseString := sValue;

  iDelimiterIndex := Pos(',', sParseString);
  if (iDelimiterIndex > 0) then
  begin
    sPosValue := Copy(sParseString, 0, iDelimiterIndex-1);
    sNegValue := Copy(sParseString, iDelimiterIndex+1, Length(sParseString)-(iDelimiterIndex));
  end
  else
  begin
    sPosValue := sValue;
    sNegValue := c_InvalidString;
  end;

  // Find the valid 'positive' value
  try
    if (StringFormat = fmtHexadecimal) then
      fPosValue := StrToInt(sPosValue)
    else
      fPosValue := StrToFloat(sPosValue);
  except
    fPosValue := m_PosValue;
  end;

  // Find the valid 'negative' value
  try
    if (StringFormat = fmtHexadecimal) then
      fNegValue := StrToInt(sNegValue)
    else
      fNegValue := StrToFloat(sNegValue);
  except
    fNegValue := fPosValue;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the Value from the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.ReadValueFromSetting(IniFile: TCustomIniFile);
var
  sValue: String;
  fPosValue, fNegValue: Double;
begin
  // Get 'Value' from the IniFile
  sValue := IniFile.ReadString(Group, Name, c_DefaultValue);

  // Save the value
  if (sValue <> c_DefaultValue) then
  begin
    DeConstructString(sValue, fPosValue, fNegValue);
    m_PosValue := fPosValue;
    m_NegValue := fNegValue;

    // Reset value (min,max checking and changed notification)
    SetValueAsFloat(ValueAsFloat);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the Value from the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.ReadValueFromSetting(IniFile: TCustomIniFile; TagName: String);
var
  sValue: String;
  fPosValue, fNegValue: Double;
begin
  // Get 'Value' from the IniFile
  sValue := IniFile.ReadString(Group, TagName, c_DefaultValue);

  // Save the value
  if (sValue <> c_DefaultValue) then
  begin
    DeConstructString(sValue, fPosValue, fNegValue);
    m_PosValue := fPosValue;
    m_NegValue := fNegValue;

    // Reset value (min,max checking and changed notification)
    SetValueAsFloat(ValueAsFloat);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the Value from the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.ReadValueFromRegistry(RegIniFile: TRegIniFile);
var
  sValue: String;
  fPosValue, fNegValue: Double;
begin
  // Get 'Value' from the IniFile
  sValue := RegIniFile.ReadString(Group, Name, c_DefaultValue);

  // Save the value
  if (sValue <> c_DefaultValue) then
  begin
    DeConstructString(sValue, fPosValue, fNegValue);
    m_PosValue := fPosValue;
    m_NegValue := fNegValue;

    // Reset value (min,max checking and changed notification)
    SetValueAsFloat(ValueAsFloat);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.WriteValueToSetting(IniFile: TCustomIniFile);
begin
  // Write 'PosValue, NegValue' to IniFile
  IniFile.WriteString(Group, Name, ConstructString());
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.WriteValueToSetting(IniFile: TCustomIniFile; TagName: String);
begin
  // Write 'PosValue, NegValue' to IniFile
  IniFile.WriteString(Group, TagName, ConstructString());
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to a text file directly(i.e. Setting File).
//               Write it out in ini file format but by pass TCustomIniFile to improve the performance.
// Inputs:       FileId - ID of the file to write to
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.WriteValueToSetting(var FileId: TextFile);
begin
  // Write 'PosValue, NegValue' to FileId
  Writeln(FileId, Name + '=' + ConstructString());
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to a text file directly(i.e. Setting File).
//               Write it out in ini file format but by pass TCustomIniFile to improve the performance.
// Inputs:       FileId - ID of the file to write to
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.WriteValueToSetting(var FileId: TextFile; TagName: String);
begin
  Writeln(FileId, TagName + '=' + ConstructString());
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'PosValue, NegValue' to the TAppSettings tag.
// Inputs:       Section - TAppSettings section
//               AppSettings - TAppSettings object
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.WriteValueToAcq(Section: String; AppSettings: TAppSettings);
var
  valueStr: String;
begin
  // Save both positive and negative values to the TAppSettings Object.
  valueStr := ConstructString();
  AppSettings.SetTag(Section, Name, valueStr);

  AppSettings.AddParameter(Section, Name, Self);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.WriteValueToRegistry(RegIniFile: TRegIniFile);
begin
  // Save 'Value' to the IniFile
  RegIniFile.WriteString(Group, Name, ConstructString());
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// AppSettings conversion methods
////////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterPolarity.AppSettingsToFloat(AppSettings: TAppSettings; Section: String): Double;
var
  tagAsFloat: Double;
  tagAsString: String;
  fPosValue, fNegValue: Double;
begin
  fPosValue := Min;
  fNegValue := Min;

  tagAsString := AppSettings.AppSettingsFile.ReadString(Section, Name, c_DefaultValue);
  if (tagAsString <> c_DefaultValue) then
    DeConstructString(tagAsString, fPosValue, fNegValue);

  if m_PolarityStyle = plPolarityStylePositiveNegative then
  begin
    if m_Polarity = plPositive then
      tagAsFloat := fPosValue
    else
      tagAsFloat := -fNegValue;
  end
  else if m_PolarityStyle = plPolarityStyleInvertPositiveNegative then
  begin
    if m_Polarity = plPositive then
      tagAsFloat := -fPosValue
    else
      tagAsFloat := fNegValue;
  end
  else if m_PolarityStyle = plPolarityStyleTwoValue then
  begin
    if m_Polarity = plPositive then
      tagAsFloat := fPosValue
    else
      tagAsFloat := fNegValue;
  end
  else
    tagAsFloat := fPosValue;

  Result := tagAsFloat;
end;

////////////////////////////////////////////////////////////////////////////////
// Readback
////////////////////////////////////////////////////////////////////////////////

// TParameterPolarity
procedure TParameterPolarity.InitReadback;
var
  parameterData: TParameterData;
begin
  if not assigned(m_Readback) then
  begin
    parameterData := TParameterData.Create(Self);

    parameterData.Name := GetReadbackName(Name);
    parameterData.Caption := GetReadbackCaption(Caption);;
    parameterData.Hint := GetReadbackHint(Hint);
    parameterData.CaptionLong := m_CaptionLong;
    parameterData.Units := Units;

    parameterData.Value := Value;
    parameterData.Min := c_DefaultMin;
    parameterData.Max := c_DefaultMax;
    parameterData.Increment := 1.0;
    parameterData.Precision := Precision;

    m_Readback := TParameter(parameterData);
  end;
end;

// GetReadback
function TParameterPolarity.GetReadback: TParameterData;
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
// Description:  Fill in TLabel component
// Inputs:       TLabel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.ToLabel(LabelPtr: TLabel; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  LabelPtr.Color := GetBackgroundColor(c_ColorBackgroundLabel);
  LabelPtr.Font.Color := GetForegroundColor(c_ColorForegroundLabel);

  if (Hint <> c_DefaultHint) then
  begin
    LabelPtr.ShowHint := True;
    LabelPtr.Hint := GetHintUsingMode(HintMode);
  end;

  LabelPtr.Visible := GetVisibleUsingMode(VisibleMode);
  LabelPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  LabelPtr.Caption := GetValueAsString();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TProgressBar component
// Inputs:       TProgressBar
// Outputs:      None
// Note:  Will set up progress bars to display percentage values from 0-100%
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.ToProgressBar(ProgressBarPtr: TProgressBar);
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
    ProgressBarPtr.Position := Round(100 * (Value / (Max - Min)));
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
procedure TParameterPolarity.ToRealEdit(RealEditPtr: TRealEdit);
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
  RealEditPtr.Minimum := Min - wiggleRoom;
  RealEditPtr.Maximum := Max + wiggleRoom;
  RealEditPtr.SetDataValue(status, Value);

  // Set increment after Min and Max!
  RealEditPtr.Increment := GetIncrement();
end;
                
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TLabel component
// Inputs:       TLabel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterPolarity.ToStaticText(StaticTextPtr: TStaticText; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  StaticTextPtr.Color := GetBackgroundColor(c_ColorBackgroundLabel);
  StaticTextPtr.Font.Color := GetForegroundColor(c_ColorForegroundLabel);

  if (Hint <> c_DefaultHint) then
  begin
    StaticTextPtr.ShowHint := True;
    StaticTextPtr.Hint := GetHintUsingMode(HintMode);
  end;

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
procedure TParameterPolarity.ToTrackBar(TrackBarPtr: TTrackBar);
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
    TrackBarPtr.Position := Round(100 * ((Value - Min) / (Max - Min)));
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
procedure TParameterPolarity.ToTrackEdit(TrackEditPtr: TTrackEdit);
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
  TrackEditPtr.Minimum := Min - wiggleRoom;
  TrackEditPtr.Maximum := Max + wiggleRoom;
  TrackEditPtr.Increment := GetIncrement();

  // Set the actual data value
  TrackEditPtr.SetDataValue(status, Value);
end;
                
end.

