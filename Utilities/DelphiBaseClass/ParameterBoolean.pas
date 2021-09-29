unit ParameterBoolean;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterBoolean.pas
// Created:   on 99-12-27 by John Baker
// Purpose:   ParameterBoolean class is used in place of Boolean types when defining
//             member variables in the Doc.
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
  Controls,
  StdCtrls,
  Buttons,
  ExtCtrls,
  Menus,
  Graphics,
  Parameter,
  AppSettings;

{TParameterBoolean}
type
  TParameterBoolean = class(TParameter)
  private
    m_Value: Boolean;
    m_InitValue: Boolean;
    m_UndoValue: Boolean;
    m_TrueAsColor: Integer;
    m_FalseAsColor: Integer;
    m_TrueAsString: String;
    m_FalseAsString: String;
    m_TrueAsEnum: Integer;
    m_FalseAsEnum: Integer;
    m_TrueAsFileEnum: Integer;
    m_FalseAsFileEnum: Integer;

    m_ValueChanged: TNotifyEvent;

    function GetValueAsColor(): Integer;
    function GetValueAsEnum(): Integer;
    function GetValueAsFileEnum(): Integer;
    function GetValueAsIndex(): Integer;

    procedure SetValueAsBoolean(BoolValue: Boolean);
    procedure SetValueAsColor(ColorValue: Integer);
    procedure SetValueAsEnum(EnumValue: Integer);
    procedure SetValueAsFileEnum(EnumValue: Integer);
    procedure SetValueAsIndex(IndexValue: Integer);
    procedure ValueChangedTrigger(State: TParameterState=psOK);

    function GetReadback(): TParameterBoolean;
    procedure UpdateUnits();
  protected
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
    procedure AddValue(BooleanValue: Boolean; Tag: Integer; FileTag: Integer = -1; Color: Integer = -1);
    procedure AddTrue(StringValue: String; Tag: Integer = 1; FileTag: Integer = 1; Color: Integer = clGreen);
    procedure AddFalse(StringValue: String; Tag: Integer = 0; FileTag: Integer = 0; Color: Integer = clRed);

    // AppSettings Conversion
    function AppSettingsToBoolean(AppSettings: TAppSettings; Section: String): Boolean; override;

    // UI Update Methods
    procedure ToCaption(ButtonPtr: TSpeedButton;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToButton(ButtonPtr: TSpeedButton;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);
    procedure ToCheckBox(CheckBoxPtr: TCheckBox);
    procedure ToComboBox(ComboBoxPtr: TComboBox;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault;
      UseColor: Boolean = False);
    procedure ToControl(ControlPtr: TControl; StringValue: String; VisibleMode: TUserLevelDisplay = ulDisplayVisible); overload;
    procedure ToEditBox(EditPtr: TEdit);
    procedure ToGroupBox(GroupBoxPtr: TGroupBox);
    procedure ToPanel(PanelPtr: TPanel); overload;
    procedure ToPanel(PanelPtr: TPanel; VisibleState: Boolean; EnabledState: Boolean); overload;
    procedure ToRadioButton(RadioButtonPtr: TRadioButton; Index: Integer); overload;
    procedure ToRadioButton(RadioButtonPtr: TRadioButton; StringValue: String = c_DefaultValue;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToRadioButton(RadioButtonPtr: TRadioButton; BoolValue: Boolean); overload;
    procedure ToMenuItem(MenuItemPtr: TMenuItem); overload;
    procedure ToMenuItem(MenuItemPtr: TMenuItem; Index: Integer); overload;
    procedure ToMenuItem(MenuItemPtr: TMenuItem; StringValue: String); overload;
    procedure ToMenuItem(MenuItemPtr: TMenuItem; BoolValue: Boolean); overload;
    procedure ToSalient(PanelPtr: TPanel);
    procedure ToShape(ShapePtr: TShape;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);

    // Convert Methods
    function StringToBoolean(StringValue: String): Boolean;
    function StringToColor(StringValue: String): Integer;
    function StringToEnum(StringValue: String): Integer;

    function BooleanToString(BoolValue: Boolean): String;
    function ColorToString(ColorValue: Integer): String;
    function EnumToString(EnumValue: Integer): String;

    property UndoValue: Boolean read m_UndoValue write m_UndoValue;
    property TrueAsColor: Integer read m_TrueAsColor;
    property TrueAsString: String read m_TrueAsString;
    property TrueAsEnum: Integer read m_TrueAsEnum;
    property TrueAsFileEnum: Integer read m_TrueAsFileEnum;
    property FalseAsColor: Integer read m_FalseAsColor;
    property FalseAsString: String read m_FalseAsString;
    property FalseAsEnum: Integer read m_FalseAsEnum;
    property FalseAsFileEnum: Integer read m_FalseAsFileEnum;
    property Value: Boolean read m_Value write SetValueAsBoolean;
    property ValueAsColor: Integer read GetValueAsColor write SetValueAsColor;
    property ValueAsEnum: Integer read GetValueAsEnum write SetValueAsEnum;
    property ValueAsFileEnum: Integer read GetValueAsFileEnum write SetValueAsFileEnum;
    property ValueAsIndex: Integer read GetValueAsIndex write SetValueAsIndex;
    property ValueAsString: String read GetValueAsString write SetValueAsString;
    property ParameterState: TParameterState read GetParameterState write SetParameterState;

    property OnValueChange: TNotifyEvent read m_ValueChanged write m_ValueChanged;
    property Readback: TParameterBoolean read GetReadback;
  end;

implementation

uses
  System.UITypes, DateUtils,
  SysUtils,
  Dialogs,
  ParameterHistory;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterBoolean.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  m_Value := False;
  m_InitValue := m_Value;
  m_UndoValue := m_Value;
  m_TrueAsColor := clGreen;
  m_FalseAsColor := clRed;
  m_TrueAsString := 'True';
  m_FalseAsString := 'False';
  m_TrueAsEnum := 1;
  m_FalseAsEnum := 0;
  m_TrueAsFileEnum := 1;
  m_FalseAsFileEnum := 0;
  m_ValueChanged := nil;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TParameterBoolean.Destroy();
begin
   inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if 'Value' has changed
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterBoolean.Changed(): Boolean;
begin
  if (m_InitValue <> m_Value) then
    Result := True
  else
    Result := False;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy the memeber variables from the passed object
// Inputs:       Sender as TParameter
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.Initialize(Sender: TParameter);
begin
  inherited;

  if (Sender is TParameterBoolean) then
  begin
    m_Value := (Sender as TParameterBoolean).m_Value;
    m_InitValue := (Sender as TParameterBoolean).m_InitValue;
    m_UndoValue := (Sender as TParameterBoolean).m_UndoValue;
    m_TrueAsColor := (Sender as TParameterBoolean).m_TrueAsColor;
    m_FalseAsColor := (Sender as TParameterBoolean).m_FalseAsColor;
    m_TrueAsString := (Sender as TParameterBoolean).m_TrueAsString;
    m_FalseAsString := (Sender as TParameterBoolean).m_FalseAsString;
    m_TrueAsEnum := (Sender as TParameterBoolean).m_TrueAsEnum;
    m_FalseAsEnum := (Sender as TParameterBoolean).m_FalseAsEnum;
    m_TrueAsFileEnum := (Sender as TParameterBoolean).m_TrueAsFileEnum;
    m_FalseAsFileEnum := (Sender as TParameterBoolean).m_FalseAsFileEnum;
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
procedure TParameterBoolean.SaveInit();
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
procedure TParameterBoolean.SaveUndo();
begin
  m_UndoValue := m_Value;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Single step undo back to the 'Undo' value.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.Undo();
begin
  m_Value := m_UndoValue;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Add value and associated enumerated type
// Inputs:       Value as Boolean; Enumerated Type as Integer
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.AddValue(BooleanValue: Boolean; Tag: Integer; FileTag: Integer = -1; Color: Integer = -1);
begin
  if (BooleanValue = True) then
  begin
    m_TrueAsEnum := Tag;
    m_TrueAsFileEnum := FileTag;
    m_TrueAsColor := Color;
  end
  else
  begin
    m_FalseAsEnum := Tag;
    m_FalseAsFileEnum := FileTag;
    m_FalseAsColor := Color;
  end;

  // Update the Historical Data units.
  UpdateUnits();
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Add values that are to be equated to TRUE
// Inputs:       ValueAsString, ValueAsEnum, ValueAsFileEnum
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.AddTrue(StringValue: String; Tag: Integer; FileTag: Integer; Color: Integer);
begin
  m_TrueAsString := StringValue;
  m_TrueAsEnum := Tag;
  m_TrueAsFileEnum := FileTag;
  m_TrueAsColor := Color;

  // Update the Historical Data units.
  UpdateUnits();
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Add values that are to be equated to FALSE
// Inputs:       ValueAsString, ValueAsEnum, ValueAsFileEnum
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.AddFalse(StringValue: String; Tag: Integer; FileTag: Integer; Color: Integer);
begin
  m_FalseAsString := StringValue;
  m_FalseAsEnum := Tag;
  m_FalseAsFileEnum := FileTag;
  m_FalseAsColor := Color;

  // Update the Historical Data units.
  UpdateUnits();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Enumerated Type that is associated to the current Value.
// Inputs:       None.
// Outputs:      Enumerated Type as Integer.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterBoolean.GetValueAsColor(): Integer;
begin
  if (m_Value = True) then
    Result := m_TrueAsColor
  else
    Result := m_FalseAsColor;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Enumerated Type that is associated to the current Value.
// Inputs:       None.
// Outputs:      Enumerated Type as Integer.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterBoolean.GetValueAsEnum(): Integer;
begin
  if (m_Value = True) then
    Result := m_TrueAsEnum
  else
    Result := m_FalseAsEnum;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the 'File' Enumerated Type that is associated to the current Value.
// Inputs:       None.
// Outputs:      Enumerated Type as Integer.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterBoolean.GetValueAsFileEnum(): Integer;
begin
  if (m_Value = True) then
    Result := m_TrueAsFileEnum
  else
    Result := m_FalseAsFileEnum;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return current Value
// Inputs:       None
// Outputs:      Value as Float
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterBoolean.GetValueAsFloat(): Double;
begin
  if (m_Value = True) then
    Result := 1.0
  else
    Result := 0.0;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value as an Index.
// Inputs:       None.
// Outputs:      Value as Index starts at 0
// Note:         Boolean values are placed in Combo Box with True on top (Index 0!)
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterBoolean.GetValueAsIndex(): Integer;
begin
  if (m_Value = True) then
    Result := 0
  else
    Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return current Value
// Inputs:       None
// Outputs:      Value as Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterBoolean.GetValueAsInt(): Integer;
begin
  if (m_Value = True) then
    Result := 1
  else
    Result := 0;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value as a string.
// Inputs:       None.
// Outputs:      Value as String (String values default to 'True' or 'False').
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterBoolean.GetValueAsString(): String;
begin
  if (m_Value = True) then
    Result := m_TrueAsString
  else
    Result := m_FalseAsString;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current value as a Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterBoolean.GetValueAsVariant(): OleVariant;
begin
  case FileVariantType of
    variantValueAsDefault: Result := Value;
    variantValueAsBoolean: Result := Value;
    variantValueAsString: Result := ValueAsString;
    variantValueAsFloat: Result := ValueAsFloat;
    variantValueAsInt: Result := ValueAsInt;
    variantValueAsEnum: Result := ValueAsEnum;
    variantValueAsFileEnum: Result := ValueAsFileEnum;
  else;
    Result := Value;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current Value
// Inputs:       Value as Float
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.SetValueAsBoolean(BoolValue: Boolean);
begin
  m_Value := BoolValue;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value.
// Inputs:       Value as Enumerated Type.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.SetValueAsColor(ColorValue: Integer);
begin
  if (ColorValue = m_TrueAsColor) then
    m_Value := True
  else
    m_Value := False;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current Value
// Inputs:       Value as Float
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.SetValueAsFloat(FloatValue: Double);
begin
  if (FloatValue = 1.0) then
    m_Value := True
  else
    m_Value := False;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value as an Index.
// Inputs:       None.
// Outputs:      Value as Index starts at 0
// Note:         Boolean values are placed in Combo Box with True on top (Index 0!)
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.SetValueAsIndex(IndexValue: Integer);
begin
  if (IndexValue = 0) then
    m_Value := True
  else
    m_Value := False;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current Value
// Inputs:       Value as Float
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.SetValueAsInt(IntValue: Integer);
begin
  if (IntValue = 1) then
    m_Value := True
  else
    m_Value := False;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value.
// Inputs:       Value as Enumerated Type.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.SetValueAsEnum(EnumValue: Integer);
begin
  if (EnumValue = m_TrueAsEnum) then
    m_Value := True
  else
    m_Value := False;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value.
// Inputs:       Value as 'File' Enumerated Type.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.SetValueAsFileEnum(EnumValue: Integer);
begin
  if (EnumValue = m_TrueAsFileEnum) then
    m_Value := True
  else
    m_Value := False;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value as a string.
// Inputs:       Value as String (String values default to 'True' or 'False').
// Outputs:      None..
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.SetValueAsString(StringValue: String);
begin
  if (StringValue = m_TrueAsString) then
    m_Value := True
  else
    m_Value := False;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current value to the value of the Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.SetValueAsVariant(VariantValue: OleVariant);
begin
  m_Value := VariantValue;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fire and event when the value changes
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ValueChangedTrigger(State: TParameterState);
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
    TParameterHistory(m_History).TimeStamp();
    TParameterHistory(m_History).Value := ValueAsEnum;
  end;

  // Call the value changed callback.
  if Assigned(m_ValueChanged) then
  begin
    m_ValueChanged(Self);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Conversion methods
////////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterBoolean.StringToBoolean(StringValue: String): Boolean;
begin
  if (StringValue = m_TrueAsString) then
    Result := True
  else
    Result := False;
end;

function TParameterBoolean.StringToColor(StringValue: String): Integer;
begin
  if (StringValue = m_TrueAsString) then
    Result := m_TrueAsColor
  else
    Result := m_FalseAsColor;
end;

function TParameterBoolean.StringToEnum(StringValue: String): Integer;
begin
  if (StringValue = m_TrueAsString) then
    Result := m_TrueAsEnum
  else
    Result := m_FalseAsEnum;
end;

function TParameterBoolean.BooleanToString(BoolValue: Boolean): String;
begin
  if (BoolValue) then
    Result := m_TrueAsString
  else
    Result := m_FalseAsString;
end;

function TParameterBoolean.ColorToString(ColorValue: Integer): String;
begin
  if (ColorValue = m_TrueAsColor) then
    Result := m_TrueAsString
  else
    Result := m_FalseAsString;
end;

function TParameterBoolean.EnumToString(EnumValue: Integer): String;
begin
  if (EnumValue = m_TrueAsEnum) then
    Result := m_TrueAsString
  else
    Result := m_FalseAsString;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// AppSettings conversion methods
////////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterBoolean.AppSettingsToBoolean(AppSettings: TAppSettings; Section: String): Boolean;
var
  tagAsBoolean: Boolean;
  tagAsString: String;
begin
  tagAsBoolean := False;
  tagAsString := AppSettings.AppSettingsFile.ReadString(Section, Name, c_DefaultValue);

  if (tagAsString <> c_DefaultValue) then
    tagAsBoolean := StringToBoolean(tagAsString);

  Result := tagAsBoolean;
end;

////////////////////////////////////////////////////////////////////////////////
// History
////////////////////////////////////////////////////////////////////////////////

// InitHistory
procedure TParameterBoolean.InitHistory;
begin
  inherited;

  UpdateUnits();
end;

// UpdateUnits
procedure TParameterBoolean.UpdateUnits();
begin
  if (Assigned(m_History)) then
    m_History.Units  := m_TrueAsString + '(' + IntToStr(m_TrueAsEnum) + '), ' + m_FalseAsString + '(' + IntToStr(m_FalseAsEnum) + ')';
end;

////////////////////////////////////////////////////////////////////////////////
// Readback
////////////////////////////////////////////////////////////////////////////////

// InitReadback
procedure TParameterBoolean.InitReadback;
var
  parameterBoolean: TParameterBoolean;
begin
  if not assigned(m_Readback) then
  begin
    parameterBoolean := TParameterBoolean.Create(Self);
    parameterBoolean.Initialize(Self);

    parameterBoolean.Name := GetReadbackName(Name);
    parameterBoolean.Caption := Caption;
    parameterBoolean.CaptionLong := CaptionLong;
    parameterBoolean.Hint := GetReadbackHint(Hint);
    parameterBoolean.Units := Units;

    m_Readback := TParameter(parameterBoolean);
  end;
end;

// GetReadback
function TParameterBoolean.GetReadback: TParameterBoolean;
begin
  if not assigned(m_Readback) then
  begin
    InitReadback();
  end;

  Result := TParameterBoolean(m_Readback);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// UI Update Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TSpeedButton' component.
// Inputs:       TSpeedButton
// Outputs:      None
// Note:         Boolean values are shown as button up(False) and down(True) states
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToCaption(ButtonPtr: TSpeedButton; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  if (Hint <> c_DefaultHint) then
  begin
    ButtonPtr.ShowHint := True;
    ButtonPtr.Hint := GetHintUsingMode(HintMode);
  end;
  ButtonPtr.Visible := GetVisibleUsingMode(VisibleMode);
  ButtonPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  ButtonPtr.Caption:= Caption;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TSpeedButton' component.
// Inputs:       TSpeedButton
// Outputs:      None
// Note:         Boolean values are shown as button up(False) and down(True) states
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToButton(ButtonPtr: TSpeedButton; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  if (Hint <> c_DefaultHint) then
  begin
    ButtonPtr.ShowHint := True;
    ButtonPtr.Hint := GetHintUsingMode(HintMode);
  end;
  ButtonPtr.Visible := GetVisibleUsingMode(VisibleMode);
  ButtonPtr.Enabled := GetEnabledUsingMode(EnabledMode);

  // Set button state
  ButtonPtr.Down := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TCheckBox' component.
// Inputs:       TCheckBox
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToCheckBox(CheckBoxPtr: TCheckBox);
begin
  if (Hint <> c_DefaultHint) then
  begin
    CheckBoxPtr.ShowHint := True;
    CheckBoxPtr.Hint := Hint;
  end;
  CheckBoxPtr.Visible := Visible;
  CheckBoxPtr.Enabled := Enabled;
  CheckBoxPtr.Checked := m_Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TComboBox' component.
// Inputs:       TComboBox
// Outputs:      None
// Note:         Boolean values are placed in Combo Box with True on top (Index 0!)
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToComboBox(ComboBoxPtr: TComboBox; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode; UseColor: Boolean);
begin
  if m_ReadOnly then
  begin
    ComboBoxPtr.Color := clMenu;
    ComboBoxPtr.Font.Color := clWindowText;
    ComboBoxPtr.Style := csDropDownList;
   end
  else
  begin
    ComboBoxPtr.Color := GetBackgroundColor(BackgroundColor);
    ComboBoxPtr.Font.Color := GetForegroundColor(ForegroundColor);
    ComboBoxPtr.Style := csDropDownList;
  end;

  if (Hint <> c_DefaultHint) then
  begin
    if (HintAs = hintAsString) then
    begin
      ComboBoxPtr.ShowHint := True;
      ComboBoxPtr.Hint := ValueAsString;
    end
    else
    begin
      ComboBoxPtr.ShowHint := True;
      ComboBoxPtr.Hint := Hint;
    end;
  end;

  ComboBoxPtr.Visible := GetVisibleUsingMode(VisibleMode);
  ComboBoxPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  ComboBoxPtr.Items.Clear();

  if m_ReadOnly then
  begin
    if (ParameterType = ptRegistry) and (m_Value = True) then
      ComboBoxPtr.Items.Add('* * * * * * *')
    else
      ComboBoxPtr.Items.Add(ValueAsString);
    ComboBoxPtr.ItemIndex := 0;
  end
  else
  begin
    // Fill 'True' and 'False' Values into ComboBox
    ComboBoxPtr.Items.Add(m_TrueAsString);
    ComboBoxPtr.Items.Add(m_FalseAsString);

    // Set current item in ComboBox list
    ComboBoxPtr.ItemIndex := ValueAsIndex;
  end;

  if UseColor then
    ComboBoxPtr.Color := ValueAsColor;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter label information to a 'TComboBox' component.
// Inputs:       TLabel
// Outputs:      None
// Note:         This method is used only to update a label(i.e. the 'caption')
//               associated to the actual data field.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToControl(ControlPtr: TControl; StringValue: String; VisibleMode: TUserLevelDisplay);
var
  bValue: Boolean;
begin
  if (Hint <> c_DefaultHint) then
  begin
    ControlPtr.ShowHint := True;
    ControlPtr.Hint := Hint;
  end;

  if (ValueAsString = StringValue) then
    bValue := True
  else
    bValue := False;

  if VisibleMode = ulDisplayVisible then
    ControlPtr.Visible := bValue
  else if VisibleMode = ulDisplayEnable then
    ControlPtr.Enabled := bValue;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TEdit' component.
// Inputs:       TEdit
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToEditBox(EditPtr: TEdit);
begin
  if m_ReadOnly then
  begin
    EditPtr.Color := clMenu;
    EditPtr.Font.Color := clWindowText;
    EditPtr.ShowHint := True;
    EditPtr.Hint := 'Read-only';
    EditPtr.ReadOnly := True;
   end
  else
  begin
    EditPtr.Color := BackgroundColor;
    EditPtr.Font.Color := ForegroundColor;
    if (Hint <> c_DefaultHint) then
    begin
      EditPtr.ShowHint := True;
      EditPtr.Hint := Hint;
    end;
  end;

  EditPtr.Visible := Visible;
  EditPtr.Enabled := Enabled;
  EditPtr.Text := ValueAsString;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TGroupBox' component.
// Inputs:       TSpeedButton
// Outputs:      None
// Note:         Boolean values are shown as button up(False) and down(True) states
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToGroupBox(GroupBoxPtr: TGroupBox);
begin
  if (Hint <> c_DefaultHint) then
  begin
    GroupBoxPtr.ShowHint := True;
    GroupBoxPtr.Hint := Hint;
  end;
  GroupBoxPtr.Visible := Visible;
  GroupBoxPtr.Enabled := Enabled;

  // Force group box to bottom, which can only be used when control Align=alTop
  GroupBoxPtr.Top := 2000;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TMenuItem' component.
// Inputs:       RadioButtonPtr: TMenuItem
//               Index: True as index 0;  False as index 1;
// Outputs:      None
// Note:         Boolean values are placed in the menu item with True as index 0!
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToMenuItem(MenuItemPtr: TMenuItem);
begin
  if (Hint <> c_DefaultHint) then
  begin
    MenuItemPtr.Hint := Hint;
  end;
  MenuItemPtr.Visible := Visible;
  MenuItemPtr.Enabled := Enabled;

  MenuItemPtr.Caption := Caption;
  MenuItemPtr.Checked := m_Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TMenuItem' component.
// Inputs:       RadioButtonPtr: TMenuItem
//               Index: True as index 0;  False as index 1;
// Outputs:      None
// Note:         Boolean values are placed in the menu item with True as index 0!
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToMenuItem(MenuItemPtr: TMenuItem; Index: Integer);
begin
  if (Hint <> c_DefaultHint) then
  begin
    MenuItemPtr.Hint := Hint;
  end;
  MenuItemPtr.Visible := Visible;
  MenuItemPtr.Enabled := Enabled;

  if (Index = 0) then // True
  begin
    MenuItemPtr.Caption := Caption + ': ' + m_TrueAsString;
    MenuItemPtr.Checked := m_Value;
  end
  else // False
  begin
    MenuItemPtr.Caption := Caption + ': ' + m_FalseAsString;
    MenuItemPtr.Checked := not m_Value;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TMenuItem' component.
// Inputs:       RadioButtonPtr: TMenuItem
//               StringValue: String constant into select data list
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToMenuItem(MenuItemPtr: TMenuItem; StringValue: String);
begin
  if (Hint <> c_DefaultHint) then
  begin
    MenuItemPtr.Hint := Hint;
  end;
  MenuItemPtr.Visible := Visible;
  MenuItemPtr.Enabled := Enabled;

  if (StringValue = m_TrueAsString) then
  begin
    MenuItemPtr.Caption := Caption + ': ' + m_TrueAsString;
    MenuItemPtr.Checked := m_Value;
  end
  else
  begin
    MenuItemPtr.Caption := Caption + ': ' + m_FalseAsString;
    MenuItemPtr.Checked := not m_Value;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TMenuItem' component.
// Inputs:       RadioButtonPtr: TMenuItem
//               StringValue: String constant into select data list
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToMenuItem(MenuItemPtr: TMenuItem; BoolValue: Boolean);
begin
  if (Hint <> c_DefaultHint) then
  begin
    MenuItemPtr.Hint := Hint;
  end;
  MenuItemPtr.Visible := Visible;
  MenuItemPtr.Enabled := Enabled;

  if (BoolValue) then
  begin
    MenuItemPtr.Caption := Caption + ': ' + m_TrueAsString;
    MenuItemPtr.Checked := m_Value;
  end
  else
  begin
    MenuItemPtr.Caption := Caption + ': ' + m_FalseAsString;
    MenuItemPtr.Checked := not m_Value;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TPanel' component.
// Inputs:       TSpeedButton
// Outputs:      None
// Note:         Boolean values are shown as button up(False) and down(True) states
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToPanel(PanelPtr: TPanel);
begin
  if (Hint <> c_DefaultHint) then
  begin
    PanelPtr.ShowHint := True;
    PanelPtr.Hint := Hint;
  end;
  PanelPtr.Visible := Visible;
  PanelPtr.Enabled := Enabled;

  // Force panel to bottom, which can only be used when control Align=alTop
  PanelPtr.Top := 2000;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TPanel' component.
// Inputs:       TSpeedButton
// Outputs:      None
// Note:         Boolean values are shown as button up(False) and down(True) states
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToPanel(PanelPtr: TPanel; VisibleState: Boolean; EnabledState: Boolean);
begin
  if (Hint <> c_DefaultHint) then
  begin
    PanelPtr.ShowHint := True;
    PanelPtr.Hint := Hint;
  end;

  if VisibleState then
    PanelPtr.Visible := Value
  else
    PanelPtr.Visible := Visible;

  if EnabledState then
    PanelPtr.Enabled := Value
  else
    PanelPtr.Enabled := Enabled;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TRadioButton' component.
// Inputs:       RadioButtonPtr: TRadioButton
//               Index: True as index 0;  False as index 1;
// Outputs:      None
// Note:         Boolean values are placed in the radio button with True as index 0!
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToRadioButton(RadioButtonPtr: TRadioButton; Index: Integer);
var
  radioOnClick: TNotifyEvent;
begin
  if (Hint <> c_DefaultHint) then
  begin
    RadioButtonPtr.ShowHint := True;
    RadioButtonPtr.Hint := Hint;
  end;
  RadioButtonPtr.Visible := Visible;
  RadioButtonPtr.Enabled := Enabled;

  // Disable the OnClick handler
  radioOnClick := RadioButtonPtr.OnClick;
  RadioButtonPtr.OnClick := nil;

  if (Index = 0) then // True
  begin
    RadioButtonPtr.Caption := m_TrueAsString;
    RadioButtonPtr.Checked := m_Value;
  end
  else // False
  begin
    RadioButtonPtr.Caption := m_FalseAsString;
    RadioButtonPtr.Checked := not m_Value;
  end;

  // Enable the OnClick handler
  RadioButtonPtr.OnClick := radioOnClick;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TRadioButton' component.
// Inputs:       RadioButtonPtr: TRadioButton
//               StringValue: String constant into select data list
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToRadioButton(RadioButtonPtr: TRadioButton; StringValue: String; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
var
  radioOnClick: TNotifyEvent;
begin
  if (Hint <> c_DefaultHint) then
  begin
    RadioButtonPtr.ShowHint := True;
    RadioButtonPtr.Hint := GetHintUsingMode(HintMode);
  end;
  RadioButtonPtr.Visible := GetVisibleUsingMode(VisibleMode);
  RadioButtonPtr.Enabled := GetEnabledUsingMode(EnabledMode);

  // Disable the OnClick handler
  radioOnClick := RadioButtonPtr.OnClick;
  RadioButtonPtr.OnClick := nil;

  if (StringValue = m_TrueAsString) then
  begin
    RadioButtonPtr.Caption := m_TrueAsString;
    RadioButtonPtr.Checked := m_Value;
  end
  else
  begin
    RadioButtonPtr.Caption := m_FalseAsString;
    RadioButtonPtr.Checked := not m_Value;
  end;

  // Enable the OnClick handler
  RadioButtonPtr.OnClick := radioOnClick;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TRadioButton' component.
// Inputs:       RadioButtonPtr: TRadioButton
//               StringValue: String constant into select data list
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToRadioButton(RadioButtonPtr: TRadioButton; BoolValue: Boolean);
var
  radioOnClick: TNotifyEvent;
begin
  if (Hint <> c_DefaultHint) then
  begin
    RadioButtonPtr.ShowHint := True;
    RadioButtonPtr.Hint := Hint;
  end;
  RadioButtonPtr.Visible := Visible;
  RadioButtonPtr.Enabled := Enabled;

  // Disable the OnClick handler
  radioOnClick := RadioButtonPtr.OnClick;
  RadioButtonPtr.OnClick := nil;

  if (BoolValue) then
  begin
    RadioButtonPtr.Caption := m_TrueAsString;
    RadioButtonPtr.Checked := m_Value;
  end
  else
  begin
    RadioButtonPtr.Caption := m_FalseAsString;
    RadioButtonPtr.Checked := not m_Value;
  end;

  // Enable the OnClick handler
  RadioButtonPtr.OnClick := radioOnClick;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TPanel' component.
// Inputs:       PanelPtr: TPanel
// Outputs:      None
// Note:         Only updates the color
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToSalient(PanelPtr: TPanel);
begin
  if (Hint <> c_DefaultHint) then
  begin
    PanelPtr.ShowHint := True;
    PanelPtr.Hint := Hint;
  end;

  PanelPtr.Visible := Visible;
  PanelPtr.Enabled := Enabled;

  // Set the salient color
  PanelPtr.Color := ValueAsColor;

  // Show the salient if not the default color
  if (PanelPtr.Color = clBtnFace) then
    PanelPtr.BorderWidth := 0
  else
    PanelPtr.BorderWidth := 2
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TShape' component.
// Inputs:       TShape
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterBoolean.ToShape(ShapePtr: TShape; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  if (Hint <> c_DefaultHint) then
  begin
    ShapePtr.ShowHint := True;
    ShapePtr.Hint := GetHintUsingMode(HintMode);
  end;
  ShapePtr.Visible := GetVisibleUsingMode(VisibleMode);
  ShapePtr.Enabled := GetEnabledUsingMode(EnabledMode);

  if ShapePtr.Enabled then
    ShapePtr.Brush.Color := ValueAsColor
  else
    ShapePtr.Brush.Color := clInactiveCaption;
end;

// GetParameterState
function TParameterBoolean.GetParameterState(): TParameterState;
begin
  Result := m_ParameterState;
end;

// SetParameterState
procedure TParameterBoolean.SetParameterState(const Value: TParameterState);
begin
  // Trigger a changed event to anyone listening; only if the parameter state changes
  if (Value <> m_ParameterState) then
    ValueChangedTrigger(Value);
end;

end.

