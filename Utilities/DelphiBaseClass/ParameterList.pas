unit ParameterList;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterList.pas
// Created:   on 00-10-19 by John Baker
// Purpose:   ParameterList class.  Used to hold a list of type TParameter.
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
  Types,
  StdCtrls,
  Contnrs,
  ControlList,
  Parameter,
  ParameterData,
  IniFiles,
  AppSettings,
  AppSettings_TLB;

const
  c_parmlistnameCount = 'Count';

{TParameterList}
type
  TParameterList = class(TParameter)
  private
    m_InitCapacity: Integer;
    m_UseSecondaryIndex: Boolean;
    m_StaticList: Boolean;

    function GetParameter(Index: Integer): TParameter;
    function GetCurrentParameter(): TParameter;
    function GetSecondaryParameter(): TParameter;
  protected
    m_List: TObjectList;
    m_Index: TParameterData;
    m_ListCount: TParameterData;
    m_SecondaryIndex: TParameterData;

    function GetValueAsFloat(): Double; override;
    function GetValueAsInt(): Integer; override;
    function GetValueAsString(): String; override;
    function GetValueAsVariant(): OleVariant; override;

    procedure SetValueAsFloat(Value: Double); override;
    procedure SetValueAsInt(Value: Integer); override;
    procedure SetValueAsString(Value: String); override;
    procedure SetValueAsVariant(Value: OleVariant); override;

    procedure SetSystemLevel(const Value: TUserLevel); override;

    function SettingsListHeaderName(): String;
    function SettingsListItemName(Index: Integer): String;
  public
    constructor Create(AOwner: TComponent) ; override ;
    destructor Destroy() ; override ;
    procedure Capacity(Value: Integer) ;
    procedure Clear(); virtual;
    procedure Add(); overload; virtual;
    procedure Add(Value: String); overload; virtual;
    procedure Add(InitialValues: TParameter); overload; virtual;
    procedure Insert(Index: Integer); overload; virtual;
    procedure Insert(Index: Integer; InitialValues: TParameter); overload; virtual;
    procedure Delete(); overload; virtual;
    procedure Delete(Value: TObject); overload; virtual;
    procedure Delete(Value: Integer); overload; virtual;
    procedure MoveUp(); virtual;
    procedure MoveDown(); virtual;
    procedure Move(OldIndex: Integer; NewIndex: Integer); virtual;
    function Changed(): Boolean; override;
    procedure SaveInit(); override;
    procedure SaveUndo(); override;
    procedure Size(Value: Integer);
    procedure Undo(); override;

    function IndexOf(Parameter: TParameter): Integer ;
    function IsEmpty(): Boolean ;

    procedure SetAll();
    procedure SetParameterIndex(Index: Integer); virtual;

    procedure CopyValueFromSetting(FromIniFile: TCustomIniFile; ToIniFile: TCustomIniFile); override;
    procedure ReadValueFromAcq(AppSettings: IAppSettings); override;
    procedure ReadValueFromSetting(IniFile: TCustomIniFile); override;
    procedure WriteValueToAcq(AppSettings: IAppSettings); override;
    procedure WriteValueToAcq(Section: String; AppSettings: TAppSettings); override;
    procedure WriteValueToSetting(IniFile: TCustomIniFile); override;
    procedure WriteValueToSetting(var FileId: TextFile); override;

    function AppSettingsToFloatArray(AppSettings: TAppSettings; Section: String): TDoubleDynArray; override;
    function AppSettingsToIntArray(AppSettings: TAppSettings; Section: String): TIntegerDynArray; override;
    function AppSettingsToStringArray(AppSettings: TAppSettings; Section: String): TStringDynArray; override;

    procedure ToComponent(ControlList: TControlList); virtual; abstract;

    property CurrentParameter: TParameter read GetCurrentParameter;
    property SecondaryParameter: TParameter read GetSecondaryParameter;
    property Parameter[Index: Integer]: TParameter read GetParameter;

    property ParameterList: TObjectList read m_List;
    property ParameterIndex: TParameterData read m_Index;
    property SecondaryIndex: TParameterData read m_SecondaryIndex ;

    property ParameterCount: TParameterData read m_ListCount;
    property UseSecondaryIndex: Boolean read m_UseSecondaryIndex write m_UseSecondaryIndex ;
    property StaticList: Boolean read m_StaticList write m_StaticList ;
  end ;

implementation

uses
  Math,
  Messages,
  Variants,
  SysUtils ;

var
  sFloatArray: TDoubleDynArray;
  sIntegerArray: TIntegerDynArray;
  sStringArray: TStringDynArray;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterList.Create(AOwner: TComponent) ;
begin
  inherited Create(AOwner) ;

  // Initialize member variables
  m_InitCapacity := 20;
  m_UseSecondaryIndex := False;
  m_StaticList := False;

  // Parameter List
  m_List := TObjectList.Create() ;
  m_List.Capacity := m_InitCapacity ;
  m_List.OwnsObjects := True ;

  m_Index := TParameterData.Create(Self);
  m_Index.Name:= 'Index';
  m_Index.Precision := 0;
  m_Index.Value := c_InvalidIndex;

  m_ListCount := TParameterData.Create(Self);
  m_ListCount.Name:= c_parmlistnameCount;
  m_ListCount.Hint:= m_ListCount.Name;
  m_ListCount.Precision := 0;
  m_ListCount.Value := 0;

  m_SecondaryIndex := TParameterData.Create(Self);
  m_SecondaryIndex.Name:= 'Secondary Index';
  m_SecondaryIndex.Precision := 0;
  m_SecondaryIndex.Value := c_InvalidIndex;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TParameterList.Destroy() ;
begin
  // Cleanup after member variables
  if assigned(m_List) then
    m_List.Free() ;

  inherited Destroy ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Pre-allocate space in the list.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Capacity(Value: Integer) ;
begin
  // Set member variable
  m_InitCapacity := Value ;

  // Size the list
  m_List.Capacity := m_InitCapacity ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Clear all Controls from list.  Objects are removed and freed.
// Inputs:       None
// Outputs:      None
// Note:         m_List uses a TObjectList which takes care of cleaning up after objects
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Clear() ;
begin
  // Clear List
  m_List.Clear();
  m_List.Capacity := m_InitCapacity;

  m_ListCount.Value := m_List.Count;
  m_Index.ValueAsInt := -1 ;
  m_SecondaryIndex.ValueAsInt := -1 ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add Parameter to the list of Parameters associated to this control.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Add;
begin
  Assert(True, 'Add method must be implemented in derived class');
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add Parameter to the list of Parameters associated to this control.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Add(Value: String);
begin
  Assert(True, 'Add method must be implemented in derived class');
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add Parameter to the list of Parameters associated to this control.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Add(InitialValues: TParameter);
begin
  Assert(True, 'Add method must be implemented in derived class');
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Insert Parameter to the list of Parameters associated to this control.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Insert(Index: Integer);
begin
  Assert(True, 'Insert method must be implemented in derived class');
end;

// Description:  Insert Parameter to the list of Parameters associated to this control.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Insert(Index: Integer; InitialValues: TParameter);
begin
  Assert(True, 'Insert method must be implemented in derived class');
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Remove the current object from the list.  Objects is removed and freed.
// Inputs:       None
// Outputs:      None
// Note:         m_List uses a TObjectList which takes care of cleaning up after objects
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Delete() ;
begin
  Delete(m_Index.ValueAsInt);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Remove a Controls from list.  Objects is removed and freed.
// Inputs:       Index
// Outputs:      None
// Note:         m_List uses a TObjectList which takes care of cleaning up after objects
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Delete(Value: TObject) ;
begin
  Delete(m_List.IndexOf(Value));
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Remove an object from the list.  Objects is removed and freed.
// Inputs:       Index
// Outputs:      None
// Note:         m_List uses a TObjectList which takes care of cleaning up after objects
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Delete(Value: Integer) ;
begin
  if (Value >= 0) and (Value < m_List.Count) then
  begin
    // Remove the Control from the list
    m_List.Delete(Value) ;
    m_ListCount.Value := m_List.Count;

    // Set the index to the value just deleted
    if (Value < m_List.Count) then
      m_Index.ValueAsInt := Value
    else
      m_Index.ValueAsInt := m_List.Count - 1 ; // Note: sets index to -1 when list is empty
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Move the current list entry to the previous list entry (i.e. swapping the
//                current data value with the previous data value).
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.MoveUp();
var
  newIndex: Integer;
begin
  // Moving up
  newIndex := m_Index.ValueAsInt - 1;

  // The new index must be a valid index
  if (newIndex >= 0) and (newIndex < m_List.Count) then
  begin
    m_List.Move(m_Index.ValueAsInt, newIndex) ;

    m_Index.ValueAsInt := newIndex;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Move the current list entry to the next list entry (i.e. swapping the
//                current data value with the next data value).
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.MoveDown();
var
  newIndex: Integer;
begin
  // Moving down
  newIndex := m_Index.ValueAsInt + 1;

  // The new index must be a valid index
  if (newIndex >= 0) and (newIndex < m_List.Count) then
  begin
    m_List.Move(m_Index.ValueAsInt, newIndex) ;

    m_Index.ValueAsInt := newIndex;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Move the current list entry to the next list entry (i.e. swapping the
//                current data value with the next data value).
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Move(OldIndex: Integer; NewIndex: Integer);
begin
  // Check that the old and new index is valid
  if (OldIndex < 0) or (OldIndex >= m_List.Count) then
    Exit;
  if (NewIndex < 0) or (NewIndex >= m_List.Count) then
    Exit;

  // Move the list value
  m_List.Move(OldIndex, NewIndex);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if 'Value' has changed
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterList.Changed(): Boolean;
var
  index: Integer ;
  listChanged: Boolean;
begin
  listChanged := False;

  // Check if the number if items in the list has changed
  if m_ListCount.Changed() then
    listChanged := True;

  // Check if any of the list member have changed
  index := 0;
  while ((index <= m_List.Count - 1) and (not listChanged)) do
  begin
    listChanged := (m_List.Items[index] as TParameter).Changed();
    index := index + 1;
  end;

  Result := listChanged;
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
procedure TParameterList.SaveInit() ;
var
  index: Integer ;
begin
  m_ListCount.SaveInit();

  for index := 0 to m_List.Count - 1 do
    (m_List.Items[index] as TParameter).SaveInit();
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
procedure TParameterList.SaveUndo() ;
var
  index: Integer ;
begin
  // Note: can only undo list items, not the number of list items

  for index := 0 to m_List.Count - 1 do
    (m_List.Items[index] as TParameter).SaveUndo();
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the number of controls to a specific value.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Size(Value: Integer);
var
  index: Integer ;
begin
  if (Value < m_List.Count) then
  begin
    for index := m_List.Count-1 downto Value do
      Delete(index);
  end
  else if (Value > m_List.Count) then
  begin
    for index := m_List.Count to Value-1 do
      Add();
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Single step undo back to the 'Undo' value.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.Undo() ;
var
  index: Integer ;
begin
  // Note: can only undo list items, not the number of list items

  for index := 0 to m_List.Count - 1 do
    (m_List.Items[index] as TParameter).Undo();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the TParameter object Index.
// Inputs:       TParameter
// Outputs:      Index; -1 is returned if object is not in list
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterList.IndexOf(Parameter: TParameter): Integer;
begin
  Result := m_List.IndexOf(Parameter) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Check if list is empty
// Inputs:       None
// Outputs:      True/False
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterList.IsEmpty(): Boolean;
begin
  Result := True;
  if (m_List.Count > 0) then
    Result := False;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get a TParameter object from the list.
// Inputs:       Index
// Outputs:      TParameterBoolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterList.GetParameter(Index: Integer): TParameter;
begin
  if ((Index >= 0) and (Index < m_List.Count)) then
    Result := (m_List.Items[Index] as TParameter)
  else
    Result := nil;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get a TParameter object from the list.
// Inputs:       Index
// Outputs:      TParameterBoolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterList.GetCurrentParameter(): TParameter;
begin
  if ((m_Index.ValueAsInt >= 0) and (m_Index.ValueAsInt < m_List.Count)) then
    Result := (m_List.Items[m_Index.ValueAsInt] as TParameter)
  else
    Result := nil;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get a TParameter object from the list.
// Inputs:       Index
// Outputs:      TParameterBoolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterList.GetSecondaryParameter(): TParameter;
begin
  if ((m_SecondaryIndex.ValueAsInt >= 0) and (m_SecondaryIndex.ValueAsInt < m_List.Count)) then
    Result := (m_List.Items[m_SecondaryIndex.ValueAsInt] as TParameter)
  else
    Result := nil;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return the 'current' list memeber value
// Inputs:       None
// Outputs:      Value as Double
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterList.GetValueAsFloat(): Double;
begin
  if ((m_Index.ValueAsInt >= 0) and (m_Index.ValueAsInt < m_List.Count)) then
    Result := (m_List.Items[m_Index.ValueAsInt] as TParameter).ValueAsFloat
  else
    Result := 0.0 ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return the 'current' list memeber value
// Inputs:       None
// Outputs:      Value as Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterList.GetValueAsInt(): Integer;
begin
  if ((m_Index.ValueAsInt >= 0) and (m_Index.ValueAsInt < m_List.Count)) then
    Result := (m_List.Items[m_Index.ValueAsInt] as TParameter).ValueAsInt
  else
    Result := 0 ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return the 'current' list memeber value
// Inputs:       None
// Outputs:      Value as String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterList.GetValueAsString: String;
begin
  if ((m_Index.ValueAsInt >= 0) and (m_Index.ValueAsInt < m_List.Count)) then
    Result := (m_List.Items[m_Index.ValueAsInt] as TParameter).ValueAsString
  else
    Result := '' ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current value as a Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterList.GetValueAsVariant(): OleVariant;
begin
  if ((m_Index.ValueAsInt >= 0) and (m_Index.ValueAsInt < m_List.Count)) then
    Result := (m_List.Items[m_Index.ValueAsInt] as TParameter).ValueAsVariant
  else
    Result := Unassigned;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current list memeber value
// Inputs:       None
// Outputs:      Value as Double
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.SetValueAsFloat(Value: Double);
begin
  if ((m_Index.ValueAsInt >= 0) and (m_Index.ValueAsInt < m_List.Count)) then
    (m_List.Items[m_Index.ValueAsInt] as TParameter).ValueAsFloat := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current list memeber value
// Inputs:       None
// Outputs:      Value as Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.SetValueAsInt(Value: Integer);
begin
  if ((m_Index.ValueAsInt >= 0) and (m_Index.ValueAsInt < m_List.Count)) then
    (m_List.Items[m_Index.ValueAsInt] as TParameter).ValueAsInt := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current list memeber value
// Inputs:       None
// Outputs:      Value as String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.SetValueAsString(Value: String);
begin
  if ((m_Index.ValueAsInt >= 0) and (m_Index.ValueAsInt < m_List.Count)) then
    (m_List.Items[m_Index.ValueAsInt] as TParameter).ValueAsString := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current value to the value of the Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.SetValueAsVariant(Value: OleVariant);
begin
  if ((m_Index.ValueAsInt >= 0) and (m_Index.ValueAsInt < m_List.Count)) then
    (m_List.Items[m_Index.ValueAsInt] as TParameter).ValueAsVariant := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the sytem level for all members of the list
// Inputs:       Value as TUserLevel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.SetSystemLevel(const Value: TUserLevel);
var
  Index: Integer ;
begin
  inherited;

  for Index := 0 to m_List.Count - 1 do
    (m_List.Items[Index] as TParameter).SystemLevel := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set all of the values to the current value.  Uses ValueAsString, as this
//                is the data type supported by all TParameter classes
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.SetAll();
var
  index: Integer;
  stringValue: String;
begin
  stringValue := GetCurrentParameter().ValueAsString;
  for index := 0 to m_List.Count - 1 do
    (m_List.Items[index] as TParameter).ValueAsString := stringValue;
end;

// SetParameterIndex
procedure TParameterList.SetParameterIndex(Index: Integer);
begin
  if ((Index >= 0) and (Index < m_List.Count)) then
  begin
    m_Index.ValueAsInt := Index;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy the Value from one IniFile to another.
// Inputs:       FromIniFile, ToIniFile - Setting Files.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.CopyValueFromSetting(FromIniFile: TCustomIniFile; ToIniFile: TCustomIniFile);
var
  sCountName: String;
  sParameterName: String;
  sValue: String;
  nListCount: Integer;
  index: Integer;
begin
  // The count doesn't contain it's parent contianer's name(box), concatinate the box name and list name
  sCountName := SettingsListHeaderName();

  // Read the number of list members from the Setting File(.ini file)
  sValue := FromIniFile.ReadString(Group, sCountName, c_DefaultValue);
  if (sValue <> c_DefaultValue) then
    nListCount := StrToInt(sValue)
  else
    nListCount := -1 ;

  // Assumes the 'Count' to be correct
  for index := 0 to nListCount - 1 do
  begin
    // The parameter name was generated when written, do it again here to assure a match
    sParameterName := SettingsListItemName(index);

    // Read each list member from the Setting File(.ini file)
    sValue := FromIniFile.ReadString(Group, sParameterName, c_DefaultValue);
    ToIniFile.WriteString(Group, sParameterName, sValue);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the Value from the AppSettings object(i.e. Acquisition File).
// Inputs:       AppSettings - The App Settings interface.
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.ReadValueFromAcq(AppSettings: IAppSettings);
var
  validValue: Boolean;
  index: Integer ;
  readValue: OleVariant;
  phiRes: Integer;
begin
  // Only clear if NOT a static list
  if not m_StaticList then
    Clear();

  // Count is not saved in file as part of list, must read until end of list
  validValue := True;
  index := 0;
  while validValue do
  begin
    // Get 'Value' from the AppSettings Object
    AppSettings.GetSetting(phiRes, FileGroupId, FileSettingId, index, readValue);

    // Check and Set valid 'Value'
    if ((phiRes = 0) and (not (VarIsEmpty(readValue)))) then
    begin
      // Only add if NOT a static list
      if not m_StaticList then
        Add();

      // Override the File flags of the list member with those of the base class
      Parameter[ParameterIndex.ValueAsInt].FileVariantType := FileVariantType;

      // Set the 'Value'
      Parameter[ParameterIndex.ValueAsInt].ValueAsVariant := readValue;
    end
    else
      validValue := False;

    // Increment index
    index := index + 1;

    // For static list read in no more that m_List.Count number of values
    if m_StaticList and (index >= m_List.Count) then
      validValue := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the Value from the Setting File(.ini file)
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.ReadValueFromSetting(IniFile: TCustomIniFile);
var
  index: Integer ;
  sCountName: String;
  sParameterName: String;
  sValue: String;
  nValue: Integer;
begin
  // The count doesn't contain it's parent contianer's name(box), concatinate the box name and list name
  sCountName := SettingsListHeaderName();

  // Read the number of list members from the Setting File(.ini file)
  sValue := IniFile.ReadString(Group, sCountName, c_DefaultValue);

  // Check for a valid read, if not a valid read then do nothing and let the default values remain
  if (sValue <> c_DefaultValue) then
  begin
    nValue := StrToInt(sValue);

    // Only clear if NOT a static list
    if not m_StaticList then
      Clear();

    // For static lists read in no more that m_List.Count number of values
    if m_StaticList and (nValue > m_List.Count) then
      nValue := m_List.Count;

    for index := 0 to nValue - 1 do
    begin
      // Only add if NOT a static list
      if not m_StaticList then
        Add();

      // Read from the file, and set the TParameter value
      sParameterName := SettingsListItemName(Index);
      sValue := IniFile.ReadString(Group, sParameterName, c_DefaultValue);
      if (sValue <> c_DefaultValue) then
        TParameter(m_List.Items[index]).ValueAsString := sValue;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the AppSettings object(i.e. Acquisition File).
// Inputs:       AppSettings - The App Settings interface.
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.WriteValueToAcq(AppSettings: IAppSettings);
var
  Index: Integer ;
  ParameterPtr: TParameter ;
  PhiRes: Integer;
begin
  for Index := 0 to m_List.Count - 1 do
  begin
    // Override the File flags of the list member with those of the base class
    ParameterPtr := (m_List.Items[Index] as TParameter) ;
    ParameterPtr.FileVariantType := FileVariantType;
    ParameterPtr.FileGroupId := FileGroupId;
    ParameterPtr.FileSettingId := FileSettingId;

    // Write each list member to the AppSettings Object
    AppSettings.PutSetting(PhiRes,
                            ParameterPtr.FileGroupId,
                            ParameterPtr.FileSettingId,
                            Index,
                            ParameterPtr.ValueAsVariant);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the TAppSettings object.
// Inputs:       AppSettings - The TAppSettings interface.
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.WriteValueToAcq(Section: String; AppSettings: TAppSettings);
var
  sCountName: String;
  sParameterName: String;
  parameterPtr: TParameter ;
  index: Integer ;
begin
  // The count doesn't contain it's parent contianer's name(box), concatinate the box name and list name
  sCountName := SettingsListHeaderName();

  // Write the number of list members to the Setting File(.ini file)
  AppSettings.SetTag(Section, sCountName, m_ListCount.ValueAsString);

  for index := 0 to m_ListCount.ValueAsInt - 1 do
  begin
    // The parameter name in the list is not guaranteed to be correct
    sParameterName := SettingsListItemName(index);

    // Write each list member to the Setting File(.ini file)
    parameterPtr := (m_List.Items[index] as TParameter) ;
    AppSettings.SetTag(Section, sParameterName, parameterPtr.ValueAsString);
  end;

  AppSettings.AddParameter(Section, Name, Self);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the Setting File(.ini file)
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.WriteValueToSetting(IniFile: TCustomIniFile);
var
  sCountName: String;
  sParameterName: String;
  parameterPtr: TParameter ;
  index: Integer ;
begin
  // The count doesn't contain it's parent contianer's name(box), concatinate the box name and list name
  sCountName := SettingsListHeaderName();

  // Write the number of list members to the Setting File(.ini file)
  IniFile.WriteString(Group, sCountName, m_ListCount.ValueAsString);

  for index := 0 to m_ListCount.ValueAsInt - 1 do
  begin
    // The parameter name in the list is not guaranteed to be correct
    sParameterName := SettingsListItemName(index);

    // Write each list member to the Setting File(.ini file)
    parameterPtr := (m_List.Items[index] as TParameter) ;
    IniFile.WriteString(Group, sParameterName, parameterPtr.ValueAsString);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to a text file directly(i.e. Setting File).
//               Write it out in ini file format but by pass TCustomIniFile to improve the performance.
// Inputs:       FileId - ID of the file to write to
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterList.WriteValueToSetting(var FileId: TextFile);
var
  sCountName: String;
  sParameterName: String;
  parameterPtr: TParameter ;
  index: Integer ;
begin
  // The count doesn't contain it's parent container's name(box), concatenate the box name and list name
  sCountName := SettingsListHeaderName();

  // Write the number of list members to the Setting File
  Writeln(FileId, sCountName + '=' + m_ListCount.ValueAsString);

  for index := 0 to m_ListCount.ValueAsInt - 1 do
  begin
    // The parameter name in the list is not guaranteed to be correct
    sParameterName := SettingsListItemName(index);

    // Write each list member to the Setting File
    parameterPtr := (m_List.Items[index] as TParameter) ;
    Writeln(FileId, sParameterName + '=' + parameterPtr.ValueAsString);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// AppSettings
////////////////////////////////////////////////////////////////////////////////////////////////////////

// AppSettingsToFloatArray
function TParameterList.AppSettingsToFloatArray(AppSettings: TAppSettings; Section: String): TDoubleDynArray;
var
  sCountName: String;
  sParameterName: String;
  nArraySize: Integer;
  tagAsFloat: Double;
  tagAsString: String;
  nIndex: Integer ;
begin
  sCountName := SettingsListHeaderName();

  // Get the list size
  nArraySize := AppSettings.AppSettingsFile.ReadInteger(Section, sCountName, 0);

  // Resize dynamic array
  SetLength(sFloatArray, nArraySize);

  for nIndex := 0 to nArraySize - 1 do
  begin
    sParameterName := SettingsListItemName(nIndex);

    // Value as Float
    tagAsFloat := 0.0;
    tagAsString := AppSettings.AppSettingsFile.ReadString(Section, sParameterName, c_DefaultValue);
    if (tagAsString <> c_DefaultValue) then
    begin
      try
        tagAsFloat := StrToFloat(tagAsString);
      except
        tagAsFloat := 0.0;
      end;
    end;

    sFloatArray[nIndex] := tagAsFloat;
  end;

  Result := sFloatArray;
end;

// AppSettingsToIntArray
function TParameterList.AppSettingsToIntArray(AppSettings: TAppSettings; Section: String): TIntegerDynArray;
var
  sCountName: String;
  sParameterName: String;
  nArraySize: Integer;
  tagAsInteger: Integer;
  tagAsString: String;
  nIndex: Integer ;
begin
  sCountName := SettingsListHeaderName();

  // Get the list size
  nArraySize := AppSettings.AppSettingsFile.ReadInteger(Section, sCountName, 0);

  // Resize dynamic array
  SetLength(sIntegerArray, nArraySize);

  for nIndex := 0 to nArraySize - 1 do
  begin
    sParameterName := SettingsListItemName(nIndex);

    // Value as Integer
    tagAsInteger := -1;
    tagAsString := AppSettings.AppSettingsFile.ReadString(Section, sParameterName, c_DefaultValue);
    if (tagAsString <> c_DefaultValue) then
    begin
      try
        tagAsInteger := round(StrToFloat(tagAsString));
      except
        tagAsInteger := -1;
      end;
    end;

    sIntegerArray[nIndex] := tagAsInteger;
  end;

  Result := sIntegerArray;
end;

// AppSettingsToStringArray
function TParameterList.AppSettingsToStringArray(AppSettings: TAppSettings; Section: String): TStringDynArray;
var
  sCountName: String;
  sParameterName: String;
  nArraySize: Integer;
  tagAsString: String;
  nIndex: Integer ;
begin
  sCountName := SettingsListHeaderName();

  // Get the list size
  nArraySize := AppSettings.AppSettingsFile.ReadInteger(Section, sCountName, 0);

  // Resize dynamic array
  SetLength(sStringArray, nArraySize);

  for nIndex := 0 to nArraySize - 1 do
  begin
    sParameterName := SettingsListItemName(nIndex);

    // Value as String
    tagAsString := AppSettings.AppSettingsFile.ReadString(Section, sParameterName, c_DefaultValue);

    sStringArray[nIndex] := tagAsString;
  end;

  Result := sStringArray;
end;

function TParameterList.SettingsListHeaderName: String;
begin
  Result := Name + ' '  + m_ListCount.Name;
end;

function TParameterList.SettingsListItemName(Index: Integer): String;
begin
  Result := Name + ' ' + Format('%d', [Index]);
end;

end.

