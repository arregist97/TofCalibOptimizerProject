unit ParameterString;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterSelectData.pas
// Created:   on 99-12-27 by John Baker
// Purpose:   ParameterSelectData class is used in place of String types when defining
//             member variables in the Doc.  ParameterSelectData class can also
//             be used in place of Float, Double, and Integer types when discrete
//             values are needed.
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
  Buttons,
  Parameter;

{TParameterString}
type
  TVaType = (vaValueAsDefault, vaFilename, vaPathname, vaFilePathname);

  TParameterString = class(TParameter)
  private
    m_Value: String;
    m_ValueAs: TVaType;
    m_InitValue: String;
    m_UndoValue: String;

    m_ValueChanged: TNotifyEvent;

    function GetValue: String;
    function GetValueAsFilename: String;
    function GetValueAsPathname: String;
    function GetValueAsExtension: String;
    function GetValueAsShortFilePathname: String;
    procedure ValueChangedTrigger;
  protected
    function GetValueAsFloat(): Double; override;
    function GetValueAsInt(): Integer; override;
    function GetValueAsString(): String; override;
    function GetValueAsVariant(): OleVariant; override;

    procedure SetValueAsFloat(FloatValue: Double); override;
    procedure SetValueAsInt(IntValue: Integer); override;
    procedure SetValueAsString(StringValue: String); override;
    procedure SetValueAsVariant(VariantValue: OleVariant); override;
  public
    constructor Create(AOwner: TComponent) ; override ;
    destructor Destroy() ; override ;
    function Changed(): Boolean; override;
    procedure Initialize(Sender: TParameter); override ;
    procedure SaveInit(); override;
    procedure SaveUndo(); override;
    procedure Undo(); override;
    procedure ToButton(ButtonPtr: TSpeedButton; StringValue: String;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);
    procedure ToComboBox(ComboBox: TComboBox) ;
    procedure ToEditBox(EditPtr: TEdit; ValueAs: TVaType = vaValueAsDefault) ;
    procedure ToLabel(LabelPtr: TLabel;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);
    procedure ToMemo(MemoPtr: TMemo) ;

    property UndoValue: String read m_UndoValue write m_UndoValue;
    property ValueAs: TVaType read m_ValueAs write m_ValueAs;
    property ValueAsFilename: String read GetValueAsFilename;
    property ValueAsPathname: String read GetValueAsPathname;
    property ValueAsExtension: String read GetValueAsExtension;
    property ValueAsFilePathname: String read GetValueAsString;
    property ValueAsShortFilePathname: String read GetValueAsShortFilePathname;
    property Value: String read GetValue write SetValueAsString;

    property OnValueChange: TNotifyEvent read m_ValueChanged write m_ValueChanged;
  end ;

implementation

uses
  SysUtils,
  Graphics,
  FileCtrl ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterString.Create(AOwner: TComponent) ;
begin
  inherited Create(AOwner) ;

  m_Value := '';
  m_ValueAs := vaFilePathname;
  m_InitValue := m_Value;
  m_UndoValue := m_Value;
  m_ValueChanged := nil;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TParameterString.Destroy() ;
begin
   inherited Destroy ;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if 'Value' has changed
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterString.Changed(): Boolean;
begin
  if (m_InitValue <> m_Value) then
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
procedure TParameterString.Initialize(Sender: TParameter) ;
begin
  inherited ;

  if (Sender is TParameterString) then
  begin
    m_Value := (Sender as TParameterString).m_Value;
    m_ValueAs := (Sender as TParameterString).m_ValueAs;
    m_InitValue := (Sender as TParameterString).m_InitValue;
    m_UndoValue := (Sender as TParameterString).m_UndoValue;
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
procedure TParameterString.SaveInit() ;
begin
  m_InitValue := m_Value ;
  m_UndoValue := m_Value ;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save the 'Undo' value
// Inputs:       None
// Outputs:      None
// Note:         The 'Undo' value is also saved when a TParameter value is
//               changed as part of a 'Load' Setting or 'Load' File.  The 'Undo'
//               value, however, is typically changed many times during the
//               running of an application (each time a property dialog is displayed)
////////////////////////////////////////////////////////////////////////////////
procedure TParameterString.SaveUndo() ;
begin
  m_UndoValue := m_Value ;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Single step undo back to the 'Undo' value.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterString.Undo() ;
begin
  m_Value := m_UndoValue ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value
// Inputs:       None
// Outputs:      Value as String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterString.GetValue: String;
begin
  if (m_ValueAs = vaFilePathname) then
    Result := GetValueAsString()
  else if (m_ValueAs = vaFilename) then
    Result := GetValueAsFilename()
  else
    Result := GetValueAsPathname();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current value as an extension
// Inputs:       None
// Outputs:      Value as Pathname
// Note:         e.g. Result = .spe
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterString.GetValueAsExtension: String;
begin
  Result := LowerCase(ExtractFileExt(m_Value));
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value
// Inputs:       None
// Outputs:      Value as Filename
// Note:         e.g. Result = b12jun101.spe
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterString.GetValueAsFilename: String;
begin
  Result := ExtractFileName(m_Value);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current value as a short filename
// Inputs:       None
// Outputs:      Value as short path name
// Note:         e.g. Result = C:/.../TestFile/b12jun101.spe
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterString.GetValueAsShortFilePathname: String;
var
  driveLetter: String;
  pathName: String;
  fileName: String;
  index: Integer;
  noDelimeter: Integer;
  delimeterIndex: Integer;
begin
  try
    fileName := ExtractFileName(m_Value);
    driveLetter := ExtractFileDrive(m_Value);
    pathName := ExtractFilePath(m_Value);

    // Strip drive off of path, not utility to just get the path
    delimeterIndex := LastDelimiter(':', pathName);
    System.Delete(pathName, 1, delimeterIndex);

    // Locate the last two directory levels (looking for delimeters)
    delimeterIndex := 0;
    noDelimeter := 0;
    for index := length(pathName) downto 1 do
    begin
      if (IsPathDelimiter(pathName, index)) then
        inc(noDelimeter);

      if (noDelimeter = 3) and (delimeterIndex = 0) then
        delimeterIndex := index;
    end;

    // Replace all but the last two directory levels with '\...\'
    if (delimeterIndex > 1) then
    begin
      System.Delete(pathName, 1, delimeterIndex);
      pathName := '\...\' + pathName;
    end;

    Result := driveLetter + pathName + fileName;
  except
    Result := '';
  end;

end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value
// Inputs:       None
// Outputs:      Value as Float
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterString.GetValueAsFloat(): Double;
var
  FloatValue: Double;
begin
  try
    FloatValue := StrToFloat(m_Value);
  except
    FloatValue := 0.0;
  end;

  Result := FloatValue;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value
// Inputs:       None
// Outputs:      Value as Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterString.GetValueAsInt(): Integer;
var
  IntValue: Integer;
begin
  try
    IntValue := StrToInt(m_Value);
  except
    IntValue := 0;
  end;

  Result := IntValue;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value
// Inputs:       None
// Outputs:      Value as Pathname
// Note:         e.g. Result = b12jun101.spe
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterString.GetValueAsPathname: String;
begin
  Result := ExtractFilePath(m_Value);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value
// Inputs:       None
// Outputs:      Value as String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterString.GetValueAsString(): String ;
begin
  Result := m_Value;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current value as a Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterString.GetValueAsVariant(): OleVariant;
begin
  case FileVariantType of
    variantValueAsDefault: Result := m_Value;
    variantValueAsString: Result := ValueAsString;
    variantValueAsFloat: Result := ValueAsFloat;
    variantValueAsInt: Result := ValueAsInt;
  else ;
    Result := m_Value;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value
// Inputs:       Value as Float
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterString.SetValueAsFloat(FloatValue: Double);
begin
  // Convert value to string using the current precision
  m_Value := ParameterFloatToStr(FloatValue) ;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value
// Inputs:       Value as Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterString.SetValueAsInt(IntValue: Integer);
begin
  m_Value := Format('%d', [IntValue]);

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterString.SetValueAsString(StringValue: String) ;
begin
  m_Value := StringValue;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current value to the value of the Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterString.SetValueAsVariant(VariantValue: OleVariant);
begin
  case FileVariantType of
    variantValueAsDefault: m_Value := VariantValue;
    variantValueAsString: ValueAsString := VariantValue;
    variantValueAsFloat: ValueAsFloat := VariantValue;
    variantValueAsInt: ValueAsInt := VariantValue;
  else ;
    Value := VariantValue;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fire and event when the value changes
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterString.ValueChangedTrigger;
begin
  // Value changed; clear any error set by application
  m_ParameterState := psOk;

  if Assigned(m_ValueChanged) then
  begin
    m_ValueChanged(Self);
  end;
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
procedure TParameterString.ToButton(ButtonPtr: TSpeedButton; StringValue: String; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  if (HintMode <> tcHintDefault) then
  begin
    ButtonPtr.ShowHint := True;
    ButtonPtr.Hint := Hint + ' (' + StringValue + ')';
  end;
  ButtonPtr.Visible := GetVisibleUsingMode(VisibleMode);
  ButtonPtr.Enabled := GetEnabledUsingMode(EnabledMode);

  // Set button state
  if m_Value = StringValue then
    ButtonPtr.Down := True
  else
    ButtonPtr.Down := False;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TComboBox' component.
// Inputs:       TComboBox
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterString.ToComboBox(ComboBox: TComboBox);
var
  index: Integer;
begin
  ComboBox.Color := GetBackgroundColor(BackgroundColor);
  ComboBox.Font.Color := GetForegroundColor(ForegroundColor) ;

  if (Hint <> c_DefaultHint) then
  begin
    if (HintAs = hintAsString) then
    begin
      ComboBox.ShowHint := True;
      ComboBox.Hint := ValueAsString;
    end
    else
    begin
      ComboBox.ShowHint := True;
      ComboBox.Hint := Hint;
    end;
  end;

  ComboBox.Visible := Visible;
  ComboBox.Enabled := Enabled and (not m_ReadOnly);

  // Set Value in ComboBox list... make sure it's valid
  index := ComboBox.Items.IndexOf(Value);
  if index <> -1 then
  begin
    ComboBox.ItemIndex := index;
    ComboBox.Text := Value;
  end
  else
    ComboBox.Text := '';
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TEdit component
// Inputs:       TEdit
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterString.ToEditBox(EditPtr: TEdit; ValueAs: TVaType) ;
begin
  if m_ReadOnly then
  begin
    EditPtr.Color := c_ColorBackgroundReadOnly ;
    EditPtr.Font.Color := c_ColorForegroundReadOnly ;
    EditPtr.ReadOnly := True;
   end
  else
  begin
    EditPtr.Color := GetBackgroundColor(BackgroundColor);
    EditPtr.Font.Color := GetForegroundColor(ForegroundColor) ;
    EditPtr.ReadOnly := False;
  end;

  if (Hint <> c_DefaultHint) then
  begin
    if (HintAs = hintAsString) then
    begin
      EditPtr.ShowHint := True;
      EditPtr.Hint := ValueAsString;
    end
    else
    begin
      EditPtr.ShowHint := True;
      EditPtr.Hint := Hint;
    end;
  end;

  EditPtr.Visible := Visible;
  EditPtr.Enabled := Enabled;
  if ValueAs = vaValueAsDefault then
    EditPtr.Text := Value
  else if (ValueAs = vaFilePathname) then
     EditPtr.Text := GetValueAsString()
  else if (ValueAs = vaFilename) then
     EditPtr.Text := GetValueAsFilename()
  else
     EditPtr.Text := GetValueAsPathname();
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TLabel component
// Inputs:       TLabel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterString.ToLabel(LabelPtr: TLabel; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  LabelPtr.Color := GetBackgroundColor(c_ColorBackgroundReadOnly);
  LabelPtr.Font.Color := GetForegroundColor(c_ColorForegroundReadOnly);

  if (Hint <> c_DefaultHint) then
  begin
    if (HintAs = hintAsString) then
    begin
      LabelPtr.ShowHint := True;
      LabelPtr.Hint := ValueAsString;
    end
    else
    begin
      LabelPtr.ShowHint := True;
      LabelPtr.Hint := Hint;
    end;
  end;

  LabelPtr.Visible := GetVisibleUsingMode(VisibleMode);
  LabelPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  LabelPtr.Caption := Value;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TMemo component
// Inputs:       TMemo
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterString.ToMemo(MemoPtr: TMemo);
begin
  MemoPtr.Color := BackgroundColor;
  MemoPtr.Font.Color := ForegroundColor;

  if (Hint <> c_DefaultHint) then
  begin
    if (HintAs = hintAsString) then
    begin
      MemoPtr.ShowHint := True;
      MemoPtr.Hint := ValueAsString;
    end
    else
    begin
      MemoPtr.ShowHint := True;
      MemoPtr.Hint := Hint;
    end;
  end;

  MemoPtr.Visible := Visible;
  MemoPtr.Enabled := Enabled;
  MemoPtr.ReadOnly := m_ReadOnly;
  if m_ReadOnly then
    MemoPtr.Color := c_ColorBackgroundReadOnly ;
  MemoPtr.Text := Value;
end ;

end.

