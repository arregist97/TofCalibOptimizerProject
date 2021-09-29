unit ParameterSelectData;
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
  Controls,
  StdCtrls,
  ComCtrls,
  Buttons,
  Menus,
  ExtCtrls,
  EditList,
  TrackEdit,
  Parameter,
  ParameterCustomSelectData,
  AppSettings;

const
  c_DefaultMin = -1000000000000000.0;  // -1e15
  c_DefaultMax = 1000000000000000.0;   // 1e15

type
  TSortType = (stNone,
                stAlphaSort,
                stNumericSort,
                stNumericSortInverse);

  TDropDownType = (ddListNone,
                    ddListStatic,
                    ddListDynamic);

  TParameterSelectData = class(TParameterCustomSelectData)
  private
    m_Value: Integer;
    m_TempValue: Integer;
    m_InitValue: String;
    m_UndoValue: String;
    m_ListOfColors: TStringList;
    m_ListOfValues: TStringList;
    m_ListOfTags: TStringList;
    m_ListOfFileTags: TStringList;
    m_ListOfCustomValues: TStringList;
    m_ConvertOldValue: TStringList;
    m_ConvertNewValue: TStringList;
    m_DropDownStyle: TDropDownType;
    m_DropDownCount: Integer;
    m_DropDownIsDirty: Boolean;
    m_Duplicates: Boolean;
    m_Sort: TSortType;
    m_Wrap: Boolean;
    m_Min: Double;
    m_Max: Double;

    m_OnValueChangedEvent: TNotifyEvent;
    m_OnListDisplayEvent: TNotifyEvent;

    function GetNumberOfValues(): Integer;
    function GetDuplicates: Boolean;
    function GetSorted: TSortType;
    function GetSortedIndex(const StringValue: String): Integer;
    function GetWrap: Boolean;
    function GetValue: String;
    function GetValues(Index: Integer): String;
    function GetValueAsColor(): Integer;
    function GetValueAsFileTag(): Integer;
    function GetValueAsFileTags(Value: String): Integer;
    function GetValueAsFloats(Index: Integer): Double;
    function GetValueAsIndex(): Integer;
    function GetValueAsIndexs(Value: String): Integer;
    function GetValueAsMenuItem: String;
    function GetValueAsTag(): Integer;
    function GetValueAsTags(Value: String): Integer;
    function GetValueAsObject(): TObject;
    function GetValueAsObjects(Value: String): TObject;

    procedure SetDuplicates(const BooleanValue: Boolean);
    procedure SetSorted(const SortValue: TSortType);
    procedure SetWrap(const BooleanValue: Boolean);
    procedure SetValue(const StringValue: String);
    procedure SetValueAsColor(ColorValue: Integer);
    procedure SetValueAsFileTag(TagValue: Integer);
    procedure SetValueAsIndex(IndexValue: Integer);
    procedure SetValueAsMenuItem(MenuItem: String);
    procedure SetValueAsTag(TagValue: Integer);
    procedure SetValueAsObject(ParameterObject: TObject);
    procedure ValueChangedTrigger(State: TParameterState=psOK);

    procedure OnDropDown(Sender: TObject);

    function GetReadback: TParameterSelectData;
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
    constructor Create(AOwner: TComponent); overload; override;
    destructor Destroy(); override;
    function Changed(): Boolean; override;
    procedure Clear();
    procedure Initialize(Sender: TParameter); override;
    procedure InitHistory(); override;
    procedure InitReadback(); override;
    procedure SaveInit(); override;
    procedure SaveUndo(); override;
    procedure Undo(); override;
    function IsValid(StringValue: String): Boolean; overload;
    function IsValid(FloatValue: Double): Boolean; overload;
    function IsEmpty(): Boolean;
    procedure SetValues(List: TStringList; StringValue: String = c_InvalidString);
    procedure SetValuesAsSetting(List: TStringList; StringValue: String = c_InvalidString);
    procedure AddValue(StringValue: String; Tag: Integer = -1; FileTag: Integer = -1; Color: Integer = -1); overload;
    procedure AddValue(FloatValue: Double; Tag: Integer = -1; FileTag: Integer = -1; Color: Integer = -1); overload;
    procedure SetObjects(List: TStringList; StringValue: String = c_InvalidString); overload;
    procedure SetObjects(List: TList; StringValue: String = c_InvalidString); overload;
    procedure AddObject(StringValue: String; ObjectPtr: TObject; Tag: Integer = -1; FileTag: Integer = -1; Color: Integer = -1);
    procedure AddCustomValue(StringValue: String);
    procedure NextValue();
    procedure PreviousValue();

    procedure AddConvert(FromValue: String; ToValue: String);
    function Convert(Value: String): String;

    // AppSettings Conversion
    function AppSettingsToEnum(AppSettings: TAppSettings; Section: String): Integer; override;

    procedure RebuildComboBox(ComboBox: TComboBox);
    procedure RebuildStringList(var StringList: TStringList);

    // UI Update Methods
    procedure ToButton(ButtonPtr: TSpeedButton; StringValue: String;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);
    procedure ToCheckBox(CheckBoxPtr: TCheckBox; StringValue: String = c_DefaultValue); overload;
    procedure ToColorBox(ColorBox: TColorBox);
    procedure ToComboBox(ComboBox: TComboBox);
    procedure ToControl(ControlPtr: TControl; StringValue: String; VisibleMode: TUserLevelDisplay = ulDisplayVisible); overload;
    procedure ToEditBox(EditPtr: TEdit);
    procedure ToEditList(EditList: TEditList);
    procedure ToLabel(LabelPtr: TLabel);
    procedure ToListBox(ListBoxPtr: TListBox);
    procedure ToMenuItem(MenuItemPtr: TMenuItem; IndexValue: Integer); overload;
    procedure ToMenuItem(MenuItemPtr: TMenuItem; StringValue: String = c_InvalidString;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault); overload;
    procedure ToPanel(PanelPtr: TPanel);
    procedure ToPopupMenu(PopupMenuPtr: TPopupMenu; OnChangeEvent: TNotifyEvent = nil);
    procedure ToRadioButton(RadioButtonPtr: TRadioButton; IndexValue: Integer); overload;
    procedure ToRadioButton(RadioButtonPtr: TRadioButton; StringValue: String = c_InvalidString;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToShape(ShapePtr: TShape;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);
    procedure ToStatusPanel(PanelPtr: TPanel);
    procedure ToTrackBar(TrackBarPtr: TTrackBar);
    procedure ToTrackEdit(TrackEditPtr: TTrackEdit); override;

    function MinMaxCheck(ComboBoxPtr: TCombobox): Boolean;
    function MinMaxClip(DoubleValue: Double): Double;
    function IndexToString(IndexValue: Integer): String;
    function IndexToTag(IndexValue: Integer): Integer;
    function MenuItemToString(MenuItem: String): String;
    function StringToIndex(StringValue: String): Integer;
    function StringToMenuItem(StringValue: String): String;
    function StringToTag(StringValue: String): Integer;
    function TagToIndex(TagValue: Integer): Integer;
    function TagToString(TagValue: Integer): String;

    property DropDownStyle: TDropDownType read m_DropDownStyle write m_DropDownStyle;
    property DropDownCount: Integer read m_DropDownCount write m_DropDownCount;
    property DropDownIsDirty: Boolean read m_DropDownIsDirty write m_DropDownIsDirty;
    property Duplicates: Boolean read GetDuplicates write SetDuplicates;
    property Sorted: TSortType read GetSorted write SetSorted;
    property Wrap: Boolean read GetWrap write SetWrap;
    property ListOfColors: TStringList read m_ListOfColors;
    property ListOfValues: TStringList read m_ListOfValues;
    property ListOfTags: TStringList read m_ListOfTags;
    property ListOfFileTags: TStringList read m_ListOfFileTags;
    property ListOfCustomValues: TStringList read m_ListOfCustomValues;
    property Max: Double read m_Max write m_Max;
    property Min: Double read m_Min write m_Min;
    property NumberOfValues: Integer read GetNumberOfValues;
    property Readback: TParameterSelectData read GetReadback;
    property UndoValue: String read m_UndoValue write m_UndoValue;
    property Value: String read GetValue write SetValue;
    property Values[Index: Integer]: String read GetValues;
    property ValueAsColor: Integer read GetValueAsColor write SetValueAsColor;
    property ValueAsIndex: Integer read GetValueAsIndex write SetValueAsIndex;
    property ValueAsIndexs[Value: String]: Integer read GetValueAsIndexs;
    property ValueAsEnum: Integer read GetValueAsTag write SetValueAsTag;
    property ValueAsEnums[Value: String]: Integer read GetValueAsTags;
    property ValueAsFileEnum: Integer read GetValueAsFileTag write SetValueAsFileTag;
    property ValueAsFileEnums[Value: String]: Integer read GetValueAsFileTags;
    property ValueAsFloats[Index: Integer]: Double read GetValueAsFloats;
    property ValueAsMenuItem: String read GetValueAsMenuItem write SetValueAsMenuItem;
    property ValueAsObject: TObject read GetValueAsObject write SetValueAsObject;
    property ValueAsObjects[Value: String]: TObject read GetValueAsObjects;
    property ParameterState: TParameterState read GetParameterState write SetParameterState;

    property OnValueChange: TNotifyEvent read m_OnValueChangedEvent write m_OnValueChangedEvent;
    property OnListDisplay: TNotifyEvent read m_OnListDisplayEvent write m_OnListDisplayEvent;
  end;

implementation

uses
  System.UITypes, DateUtils,
  Dialogs,
  Messages,
  Graphics,
  StrUtils,
  SysUtils,
  AppDefinitions,
  ParameterHistory;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterSelectData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  m_DropDownStyle := ddListNone;
  m_DropDownCount := 16;
  m_DropDownIsDirty := True;
  m_DropDownStyle := ddListNone;
  m_Value := c_InvalidIndex;
  m_TempValue := c_InvalidIndex;
  m_InitValue := '';
  m_UndoValue := '';
  m_Duplicates := False;
  m_Sort := stNone;
  m_Wrap := False;
  m_Min := c_DefaultMin;
  m_Max := c_DefaultMax;

  m_OnValueChangedEvent := nil;
  m_OnListDisplayEvent := nil;

  m_ListOfColors := TStringList.Create();
  m_ListOfColors.Capacity := 20;
  m_ListOfColors.Duplicates := dupAccept;

  m_ListOfValues := TStringList.Create();
  m_ListOfValues.Capacity := 20;
  m_ListOfValues.Duplicates := dupAccept;
  m_ListOfValues.Sorted := False;

  m_ListOfTags := TStringList.Create();
  m_ListOfTags.Capacity := 20;
  m_ListOfTags.Duplicates := dupAccept;

  m_ListOfFileTags := TStringList.Create();
  m_ListOfFileTags.Capacity := 20;
  m_ListOfFileTags.Duplicates := dupAccept;

  m_ListOfCustomValues := TStringList.Create();
  m_ListOfCustomValues.Capacity := 20;
  m_ListOfCustomValues.Duplicates := dupAccept;
  m_ListOfCustomValues.Sorted := False;

  m_ConvertOldValue := TStringList.Create() ;
  m_ConvertOldValue.Capacity := 20;
  m_ConvertOldValue.Duplicates := dupAccept;
  m_ConvertOldValue.Sorted := False;

  m_ConvertNewValue := TStringList.Create() ;
  m_ConvertNewValue.Capacity := 20;
  m_ConvertNewValue.Duplicates := dupAccept;
  m_ConvertNewValue.Sorted := False;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TParameterSelectData.Destroy();
begin
   m_ListOfColors.Free;
   m_ListOfValues.Free;
   m_ListOfTags.Free;
   m_ListOfFileTags.Free;
   m_ListOfCustomValues.Free;
   m_ConvertOldValue.Free ;
   m_ConvertNewValue.Free ;

   inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if 'Value' has changed
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.Changed(): Boolean;
begin
  if (m_InitValue <> ValueAsString) then
    Result := True
  else
    Result := False;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Clear
// Inputs:       None
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.Clear();
begin
  m_Value := c_InvalidIndex;
  m_TempValue := c_InvalidIndex;

  // Use 'Delete' instead of 'Clear'.  This maintains the size of the allocated object list
  while m_ListOfColors.Count > 0 do
    m_ListOfColors.Delete(0);
  while m_ListOfValues.Count > 0 do
    m_ListOfValues.Delete(0);
  while m_ListOfTags.Count > 0 do
    m_ListOfTags.Delete(0);
  while m_ListOfFileTags.Count > 0 do
    m_ListOfFileTags.Delete(0);
  while m_ListOfCustomValues.Count > 0 do
    m_ListOfCustomValues.Delete(0);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy the memeber variables from the passed object
// Inputs:       TParameter
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.Initialize(Sender: TParameter);
begin
  inherited;

  if (Sender is TParameterSelectData) then
  begin
    m_Value := (Sender as TParameterSelectData).m_Value;
    m_TempValue := (Sender as TParameterSelectData).m_TempValue;
    m_InitValue := (Sender as TParameterSelectData).m_InitValue;
    m_UndoValue := (Sender as TParameterSelectData).m_UndoValue;
    m_ListOfColors.Assign((Sender as TParameterSelectData).m_ListOfColors);
    m_ListOfValues.Assign((Sender as TParameterSelectData).m_ListOfValues);
    m_ListOfTags.Assign((Sender as TParameterSelectData).m_ListOfTags);
    m_ListOfFileTags.Assign((Sender as TParameterSelectData).m_ListOfFileTags);
    m_ListOfCustomValues.Assign((Sender as TParameterSelectData).m_ListOfCustomValues);
    m_ConvertOldValue.Assign((Sender as TParameterSelectData).m_ConvertOldValue);
    m_ConvertNewValue.Assign((Sender as TParameterSelectData).m_ConvertNewValue);
    m_DropDownStyle := (Sender as TParameterSelectData).m_DropDownStyle;
    m_DropDownCount := (Sender as TParameterSelectData).m_DropDownCount;
    m_DropDownIsDirty := (Sender as TParameterSelectData).m_DropDownIsDirty;
    m_Duplicates := (Sender as TParameterSelectData).m_Duplicates;
    m_Sort := (Sender as TParameterSelectData).m_Sort;
    m_Wrap := (Sender as TParameterSelectData).m_Wrap;
    m_Min := (Sender as TParameterSelectData).m_Min;
    m_Max := (Sender as TParameterSelectData).m_Max;
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
procedure TParameterSelectData.SaveInit();
begin
  m_InitValue := ValueAsString;
  m_UndoValue := ValueAsString;
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
procedure TParameterSelectData.SaveUndo();
begin
  m_UndoValue := ValueAsString;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Single step undo back to the 'Undo' value.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.Undo();
begin
  ValueAsString := m_UndoValue;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set the list of values from a TStringList.
// Inputs:       StringValue
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.IsValid(StringValue: String): Boolean;
var
  Index: Integer;
begin
  Result := False;
  for Index := 0 to m_ListOfValues.Count - 1 do
  begin
    // Check if 'CurrentSetting' name is in list
    if (m_ListOfValues.Strings[Index] = StringValue) then
      Result := True;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if the value in in the list of values from a TStringList.
// Inputs:       FloatValue
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.IsValid(FloatValue: Double): Boolean;
var
  Index: Integer;
  stringValue: String;
begin
  Result := False;

  // Covert the value to a string
  stringValue := ParameterFloatToStr(FloatValue);

  for Index := 0 to m_ListOfValues.Count - 1 do
  begin
    // Check if 'CurrentSetting' name is in list
    if (m_ListOfValues.Strings[Index] = stringValue) then
      Result := True;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if there are any values in the TStringList.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.IsEmpty(): Boolean;
begin
  Result := False;

  if m_ListOfValues.Count = 0 then
    Result := True;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set the list of values from a TStringList.
// Inputs:       List as TStringList
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValues(List: TStringList; StringValue: String);
var
  i: Integer;
begin
  // Clear the lists
  Clear();

  // Add the strings to the list one at a time, incase they are to be sorted
  for i := 0 to List.Count - 1 do
    AddValue(List.Strings[i]);

  if (StringValue <> c_InvalidString) then
    ValueAsString := StringValue;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set the list of values from a TStringList.
// Inputs:       List as TStringList
// Outputs:      None
// Note:         Strips off the .phi at the end of the setting name.
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValuesAsSetting(List: TStringList; StringValue: String);
var
  i: Integer;
  FileName: String;
begin
  // Clear the lists
  Clear();

  // Add the strings to the list one at a time, incase they are to be sorted
  for i := 0 to (List.Count - 1) do
  begin
    // Strip off the .phi file extension
    FileName := StringReplace(List.Strings[i], c_SettingFileExt, '', [rfIgnoreCase]);
    AddValue(FileName);
  end;

  if (StringValue <> c_InvalidString) then
    ValueAsString := StringValue;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set the list of values from a TStringList.
// Inputs:       List as TStringList
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetObjects(List: TStringList; StringValue: String);
var
  i: Integer;
begin
  // Clear the lists
  Clear();

  // Add the strings to the list one at a time, incase they are to be sorted
  for i := 0 to List.Count - 1 do
    AddObject(List.Strings[i], List.Objects[i]);

  if (StringValue <> c_InvalidString) then
    ValueAsString := StringValue;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set the list of values from a TStringList.
// Inputs:       List as TStringList
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetObjects(List: TList; StringValue: String);
var
  i: Integer;
  parameterPtr: TParameter;
begin
  // Clear the lists
  Clear();

  // Add the strings to the list one at a time, incase they are to be sorted
  for i := 0 to List.Count - 1 do
  begin
    parameterPtr := TParameter(List.Items[i]);
    AddObject(parameterPtr.Caption, parameterPtr);
  end;

  if (StringValue <> c_InvalidString) then
    ValueAsString := StringValue;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Add a String value to the list of values.
// Inputs:       Value as String; Enum as Integer
// Outputs:      None
// Note:         Because duplicates are supported for both sorted AND unsorted list
//               (StringList only support duplicates for sorted list), the checking
//               is handled within this TParameterSelectData class.
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.AddValue(StringValue: String; Tag: Integer; FileTag: Integer; Color: Integer);
var
  TagString: String;
  Index: Integer;
begin
  // Add 'Value' and 'Tag' to list only if 'Value' does NOT exist and Duplicates are allowed
  if ((m_ListOfValues.IndexOf(StringValue) = -1) or (m_Duplicates)) then
  begin
    if (m_Sort = stNumericSort) or (m_Sort = stNumericSortInverse) then
    begin
      // Add string to list.  Note: AlphaSort is handled by the StringList, if needed
      Index := GetSortedIndex(StringValue);
      if Index <> c_InvalidIndex then
        m_ListOfValues.Insert(Index, StringValue)
      else
        Index := m_ListOfValues.Add(StringValue);
    end
    else
    begin
      // Add string to list.  Note: AlphaSort is handled by the StringList, if needed
      Index := m_ListOfValues.Add(StringValue);
    end;

    // Add Color to list
    TagString := Format('%d', [Color]);
    m_ListOfColors.Insert(Index, TagString);

    // Add Enum to list
    TagString := Format('%d', [Tag]);
    m_ListOfTags.Insert(Index, TagString);

    // Add File Enum to list
    TagString := Format('%d', [FileTag]);
    m_ListOfFileTags.Insert(Index, TagString);

    // There is now a valid value, change the m_Value to reflect this
    if (m_Value = c_InvalidIndex) then
      m_value := Index;

    // Update the Units field.
    UpdateUnits();
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Add a Double (or Float) value to the list of values.
// Inputs:       Value as Double
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.AddValue(FloatValue: Double; Tag: Integer; FileTag: Integer; Color: Integer);
var
  StringValue: String;
begin
  // Convert value to string
  StringValue := ParameterFloatToStr(FloatValue);

  // Add string to list and Enum to list
  AddValue(StringValue, Tag, FileTag, Color);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Add a String value to the list of values.
// Inputs:       Value as String; Enum as Integer
// Outputs:      None
// Note:         Because duplicates are supported for both sorted AND unsorted list
//               (StringList only support duplicates for sorted list), the checking
//               is handled within this TParameterSelectData class.
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.AddObject(StringValue: String; ObjectPtr: TObject; Tag: Integer; FileTag: Integer; Color: Integer);
var
  TagString: String;
  Index: Integer;
begin
  // Add 'Value' and 'Tag' to list only if 'Value' does NOT exist and Duplicates are allowed
  if ((m_ListOfValues.IndexOf(StringValue) = -1) or (m_Duplicates)) then
  begin
    if (m_Sort = stNumericSort) or (m_Sort = stNumericSortInverse) then
    begin
      // Add string to list.  Note: AlphaSort is handled by the StringList, if needed
      Index := GetSortedIndex(StringValue);
      if Index <> c_InvalidIndex then
        m_ListOfValues.InsertObject(Index, StringValue, ObjectPtr)
      else
        Index := m_ListOfValues.AddObject(StringValue, ObjectPtr);
    end
    else
    begin
      // Add string to list.  Note: AlphaSort is handled by the StringList, if needed
      Index := m_ListOfValues.AddObject(StringValue, ObjectPtr);
    end;

    // Add Color to list
    TagString := Format('%d', [Color]);
    m_ListOfColors.Insert(Index, TagString);

    // Add Enum to list
    TagString := Format('%d', [Tag]);
    m_ListOfTags.Insert(Index, TagString);

    // Add File Enum to list
    TagString := Format('%d', [FileTag]);
    m_ListOfFileTags.Insert(Index, TagString);

    // There is now a valid value, change the m_Value to reflect this
    if (m_Value = c_InvalidIndex) then
      m_value := Index;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Add a String value to the list of values.
// Inputs:       Value as String; Enum as Integer
// Outputs:      None
// Note:         Because duplicates are supported for both sorted AND unsorted list
//               (StringList only support duplicates for sorted list), the checking
//               is handled within this TParameterSelectData class.
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.AddCustomValue(StringValue: String);
begin
  // Add 'Value' to list of custom values; only if 'Value' does NOT exist
  if ((m_ListOfCustomValues.IndexOf(StringValue) = -1)) then
  begin
    // Add string to custom value list
    m_ListOfCustomValues.Add(StringValue);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Add conversion values
// Inputs:       FromValue, To Value: String
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.AddConvert(FromValue: String; ToValue: String);
begin
  // Add old value
  m_ConvertOldValue.Add(FromValue);

  // Add new value
  m_ConvertNewValue.Add(ToValue);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Convert from old value to new value
// Inputs:       Old Value as String
// Outputs:      New Value as String
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.Convert(Value: String): String;
var
  convertIndex: Integer;
begin
  Result := Value;
  convertIndex := m_ConvertOldValue.IndexOf(Value);
  if convertIndex <> -1 then
  begin
    if m_ConvertNewValue.Count > convertIndex then
      Result := m_ConvertNewValue.Strings[convertIndex];
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get 'Duplicates'
// Inputs:       None
// Outputs:      Value as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetDuplicates: Boolean;
begin
  Result := m_Duplicates;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get 'Sort' type
// Inputs:       None
// Outputs:      Value as TSortType
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetSorted: TSortType;
begin
  Result := m_Sort;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Returns and index where the value should be inserted into the List.
//               Used for numeric sorts only (alpha sorting is supported by TStringList
// Inputs:       Value as String
// Outputs:      Index
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetSortedIndex(const StringValue: String): Integer;
var
  FloatValue: Double;
  Index, InsertIndex: Integer;
begin
  Result := c_InvalidIndex;
  if (m_ListOfValues.Count = 0) then
    Exit;

  try
    InsertIndex := c_InvalidIndex;

    // Determine type of sort
    if (m_Sort = stNumericSort) then
    begin
      // Determine if insert needed before first, or after last list item
      FloatValue := StrToFloat(StringValue);
      if (FloatValue <= StrToFloat(m_ListOfValues.Strings[0])) then
        InsertIndex := 0;
      if (FloatValue >= StrToFloat(m_ListOfValues.Strings[m_ListOfValues.Count - 1])) then
        InsertIndex := m_ListOfValues.Count;

      // Insert into list, if position not yet found
      Index := 0;
      while (InsertIndex = c_InvalidIndex) and (Index < m_ListOfValues.Count - 1) do
      begin
        if (FloatValue > StrToFloat(m_ListOfValues.Strings[Index])) and
          (FloatValue <= StrToFloat(m_ListOfValues.Strings[Index + 1])) then
          InsertIndex := Index + 1;
        Index := Index + 1;
      end;
    end
    else // m_Sort = stNumericSortInverse
    begin
      // Determine if insert needed before first, or after last list item
      FloatValue := StrToFloat(StringValue);
      if (FloatValue >= StrToFloat(m_ListOfValues.Strings[0])) then
        InsertIndex := 0;
      if (FloatValue <= StrToFloat(m_ListOfValues.Strings[m_ListOfValues.Count - 1])) then
        InsertIndex := m_ListOfValues.Count;

      // Insert into list, if position not yet found
      Index := 0;
      while (InsertIndex = c_InvalidIndex) and (Index < m_ListOfValues.Count - 1) do
      begin
        if (FloatValue < StrToFloat(m_ListOfValues.Strings[Index])) and
          (FloatValue >= StrToFloat(m_ListOfValues.Strings[Index + 1])) then
          InsertIndex := Index + 1;
        Index := Index + 1;
      end;
    end;
  except
    InsertIndex := c_InvalidIndex;
  end;

  Result := InsertIndex;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get 'Wrap'
// Inputs:       None
// Outputs:      Value as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetWrap: Boolean;
begin
  Result := m_Wrap;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value
// Inputs:       None
// Outputs:      Value as String
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValue: String;
begin
  Result := ValueAsString;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value as an Color.
// Inputs:       None.
// Outputs:      Value as Index starts at 0, -1 if no valid value.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsColor(): Integer;
begin
  if (ValueAsIndex <> c_InvalidIndex) then
    Result := StrToInt(m_ListOfColors.Strings[ValueAsIndex])
  else
    Result := c_InvalidIndex;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the File Tag that is associated to the current Value.
// Inputs:       None.
// Outputs:      Tag as Integer.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsFileTag(): Integer;
begin
  if (ValueAsIndex <> c_InvalidIndex) then
    Result := StrToInt(m_ListOfFileTags.Strings[ValueAsIndex])
  else
    Result := c_InvalidIndex;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the File Tag that is associated to the current Value.
// Inputs:       None.
// Outputs:      Tag as Integer.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsFileTags(Value: String): Integer;
var
  ObjectIndex: Integer;
begin
  ObjectIndex := m_ListOfValues.IndexOf(Value);
  if ObjectIndex <> -1 then
    Result := StrToInt(m_ListOfFileTags.Strings[ObjectIndex])
  else
    Result := c_InvalidIndex;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get current Value as a Double.
// Inputs:       None
// Outputs:      Value as Double
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsFloat(): Double;
var
  FloatValue: Double;
begin
  try
    FloatValue := StrToFloat(ValueAsString)
  except
    FloatValue := 0.0;
  end;

  Result := FloatValue;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get current Value as a Double.
// Inputs:       None
// Outputs:      Value as Double
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsFloats(Index: Integer): Double;
var
  FloatValue: Double;
begin
  if ((Index >= 0) and (Index < m_ListOfValues.Count) and (m_ListOfValues.Count > 0)) then
  begin
    try
      FloatValue := StrToFloat(Values[Index])
    except
      FloatValue := 0.0;
    end;
  end
  else
    FloatValue := 0.0;

  Result := FloatValue;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value as an Index.
// Inputs:       None.
// Outputs:      Value as Index starts at 0, -1 if no valid value.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsIndex(): Integer;
begin
  if ((m_Value >= 0) and (m_Value < m_ListOfValues.Count) and (m_ListOfValues.Count > 0)) then
  begin
    Result := m_Value;
  end
  else
    Result := c_InvalidIndex;

end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value as an Index.
// Inputs:       None.
// Outputs:      Value as Index starts at 0, -1 if no valid value.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsIndexs(Value: String): Integer;
var
  ObjectIndex: Integer;
begin
  ObjectIndex := m_ListOfValues.IndexOf(Value);
  if ObjectIndex <> -1 then
    Result := ObjectIndex
  else
    Result := c_InvalidIndex;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return current data value as an integer.
// Inputs:       None
// Outputs:      Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsInt(): Integer;
begin
  Result := round(Self.GetValueAsFloat);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return current value as the menu item (Caption + Value).
// Inputs:       None
// Outputs:      Integer
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsMenuItem: String;
begin
  Result := Caption + ': ' + ValueAsString;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Object that is associated to the current value.
// Inputs:       None.
// Outputs:      Object as TParameter.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsObject(): TObject;
begin
  if (ValueAsIndex <> c_InvalidIndex) then
    Result := m_ListOfValues.Objects[ValueAsIndex] as TObject
  else
    Result := nil;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Object that is associated to the current value.
// Inputs:       None.
// Outputs:      Object as TParameter.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsObjects(Value: String): TObject;
var
  ObjectIndex: Integer;
begin
  ObjectIndex := m_ListOfValues.IndexOf(Value);
  if ObjectIndex <> -1 then
    Result := m_ListOfValues.Objects[ObjectIndex] as TObject
  else
    Result := nil;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current Value
// Inputs:       None
// Outputs:      Value as String
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsString(): String;
begin
  if (ValueAsIndex <> c_InvalidIndex) then
    Result := m_ListOfValues.Strings[ValueAsIndex]
  else
    Result := '';
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Tag that is associated to the current Value.
// Inputs:       None.
// Outputs:      Tag as Integer.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsTag(): Integer;
begin
  if (ValueAsIndex <> c_InvalidIndex) then
    Result := StrToInt(m_ListOfTags.Strings[ValueAsIndex])
  else
    Result := c_InvalidIndex;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Tag that is associated to the current Value.
// Inputs:       None.
// Outputs:      Tag as Integer.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsTags(Value: String): Integer;
var
  ObjectIndex: Integer;
begin
  ObjectIndex := m_ListOfValues.IndexOf(Value);
  if ObjectIndex <> -1 then
    Result := StrToInt(m_ListOfTags.Strings[ObjectIndex])
  else
    Result := c_InvalidIndex;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current value as a Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValueAsVariant(): OleVariant;
begin
  case FileVariantType of
    variantValueAsDefault: Result := ValueAsString;
    variantValueAsString: Result := ValueAsString;
    variantValueAsFloat: Result := ValueAsFloat;
    variantValueAsInt: Result := ValueAsInt;
    variantValueAsEnum: Result := ValueAsEnum;
    variantValueAsFileEnum: Result := ValueAsFileEnum;
  else;
    Result := ValueAsString;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set 'Duplicates'
// Inputs:       None
// Outputs:      Value as Boolean
// Note:         'Duplicates' can only be changed if list is empty.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetDuplicates(const BooleanValue: Boolean);
begin
  // Duplicates can only be changed if list is empty
  if (m_ListOfValues.Count = 0) then
    m_Duplicates := BooleanValue;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set 'Sorted'
// Inputs:       None
// Outputs:      Value as Boolean
// Note:         'Sorted' can only be changed if list is empty.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetSorted(const SortValue: TSortType);
begin
  // Sort can only be changed if list is empty
  if (m_ListOfValues.Count = 0) then
  begin
    m_Sort := SortValue;
    if (m_Sort = stAlphaSort) then
      //'Sorted' only set for ListOfValues.  Tags are added to the ListOfTags based on how added to ListOfValues
      m_ListOfValues.Sorted := True
    else
      m_ListOfValues.Sorted := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set 'Wrap'
// Inputs:       None
// Outputs:      Value as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetWrap(const BooleanValue: Boolean);
begin
  m_Wrap := BooleanValue;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value
// Inputs:       Value as String
// Outputs:      None
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValue(const StringValue: String);
begin
  ValueAsString := StringValue;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value.
// Inputs:       Value as File Tag.
// Outputs:      None.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValueAsColor(ColorValue: Integer);
begin
  // Find the index of the current Tag, and use to set current value
  ValueAsIndex := m_ListOfColors.IndexOf(Format('%d', [ColorValue]));
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value.
// Inputs:       Value as File Tag.
// Outputs:      None.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValueAsFileTag(TagValue: Integer);
begin
  // Find the index of the current Tag, and use to set current value
  ValueAsIndex := m_ListOfFileTags.IndexOf(Format('%d', [TagValue]));
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value.
// Inputs:       Value as Double.
// Outputs:      None.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValueAsFloat(FloatValue: Double);
begin
  // Convert value to string using the current precision
  ValueAsString := ParameterFloatToStr(MinMaxClip(FloatValue));
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value as an Index.
// Inputs:       Value as Index.
// Outputs:      None.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValueAsIndex(IndexValue: Integer);
begin
  if ((IndexValue >= 0) and (IndexValue < m_ListOfValues.Count) and (m_ListOfValues.Count > 0)) then
  begin
    // First check if there is a temporary value in the list and it was not the index selected
    if (m_TempValue <> c_InvalidIndex) and (m_TempValue <> IndexValue) then
    begin
      // Removing the TempValue will offset the index by one
      if (m_TempValue < IndexValue) then
        IndexValue := IndexValue - 1;

      // Remove the TempValue from the list
      m_ListOfColors.Delete(m_TempValue);
      m_ListOfValues.Delete(m_TempValue);
      m_ListOfTags.Delete(m_TempValue);
      m_ListOfFileTags.Delete(m_TempValue);
      m_TempValue := c_InvalidIndex;
    end;
    m_Value := IndexValue;
  end;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as an integer.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValueAsInt(IntValue: Integer);
begin
  // Convert integer value to string
  ValueAsString := Format('%d', [IntValue]);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as a menu item (Caption + Value)
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValueAsMenuItem(MenuItem: String);
begin
  // Remove the caption from the string
  ValueAsString := ReplaceStr(MenuItem, Caption + ': ', '');
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current value using the index of the passed object.
// Inputs:       Value as TParameter object.
// Outputs:      None.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValueAsObject(ParameterObject: TObject);
begin
  // Find the index of the current object, and use to set current value
  ValueAsIndex := m_ListOfValues.IndexOfObject(ParameterObject);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value
// Inputs:       Value as String
// Outputs:      None
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValueAsString(StringValue: String);
var
  Index: Integer;
begin
  // Check if there is a string conversion needed(i.e. compatability support)
  StringValue := Convert(StringValue);

  // First check if there is a temporary value in the list, Remove it
  if (m_TempValue <> c_InvalidIndex) then
  begin
    m_ListOfColors.Delete(m_TempValue);
    m_ListOfValues.Delete(m_TempValue);
    m_ListOfTags.Delete(m_TempValue);
    m_ListOfFileTags.Delete(m_TempValue);
    m_TempValue := c_InvalidIndex;
  end;

  // Check if the new value is in the list
  Index := m_ListOfValues.IndexOf(StringValue);
  if (Index <> c_InvalidIndex) then
  begin
    // New value is in the list, simply set it
    m_Value := Index;
  end
  else
  begin
    // New value is NOT in the list; if allowed (style=ddListAdd), temporarily insert the value into the list
    if not (m_DropDownStyle = ddListStatic) then
    begin
      if (m_Sort = stNumericSort) or (m_Sort = stNumericSortInverse) then
      begin
        // Add string to list.  Note: AlphaSort is handled by the StringList, if needed
        m_TempValue := GetSortedIndex(StringValue);
        if m_TempValue <> c_InvalidIndex then
          m_ListOfValues.Insert(m_TempValue, StringValue)
        else
          m_TempValue := m_ListOfValues.Add(StringValue);
      end
      else
      begin
        // Add string to list.  Note: AlphaSort is handled by the StringList, if needed
        m_TempValue := m_ListOfValues.Add(StringValue);
      end;

      // Also add a value to the Tag(Enum) list.  Note: Temporary value tags are not valid
      m_ListOfColors.Insert(m_TempValue, '-1');
      m_ListOfTags.Insert(m_TempValue, '-1');
      m_ListOfFileTags.Insert(m_TempValue, '-1');

      // Set the index
      m_Value := m_TempValue;
    end;
  end;

  // Trigger a value changed event to anyone listening
  ValueChangedTrigger(psOK);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current Value.
// Inputs:       Value as Tag.
// Outputs:      None.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValueAsTag(TagValue: Integer);
begin
  // Find the index of the current Tag, and use to set current value
  ValueAsIndex := m_ListOfTags.IndexOf(Format('%d', [TagValue]));
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current value to the value of the Variant.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.SetValueAsVariant(VariantValue: OleVariant);
begin
  case FileVariantType of
    variantValueAsDefault: ValueAsString := VariantValue;
    variantValueAsString: ValueAsString := VariantValue;
    variantValueAsFloat: ValueAsFloat := VariantValue;
    variantValueAsInt: ValueAsInt := VariantValue;
    variantValueAsEnum: ValueAsEnum := VariantValue;
    variantValueAsFileEnum: ValueAsFileEnum := VariantValue;
  else;
    ValueAsString := VariantValue;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get a specific Value.
// Inputs:       Index into list of values.
// Outputs:      Value as String
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetValues(Index: Integer): String;
begin
  if ((Index >= 0) and (Index <= m_ListOfValues.Count)) then
    Result:= m_ListOfValues.Strings[Index];
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get number of Values stored in ListOfValues.
// Inputs:       None
// Outputs:      NumberOfValues as Integer.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.GetNumberOfValues(): Integer;
begin
  Result := m_ListOfValues.Count;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the next value stored in ListOfValue, will loop around.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.NextValue;
begin
  if m_Value < m_ListOfValues.Count - 1 then
    SetValueAsIndex(m_Value + 1)
  else if m_Wrap then
    SetValueAsIndex((m_Value + 1) mod m_ListOfValues.Count);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the previous value stored in ListOfValue, will loop around.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.PreviousValue;
begin
  if m_Value > 0 then
    SetValueAsIndex(m_Value - 1)
  else if m_Wrap then
    SetValueAsIndex(((m_Value - 1) + m_ListOfValues.Count) mod m_ListOfValues.Count);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fire and event when the value changes
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ValueChangedTrigger;
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
  if Assigned(m_OnValueChangedEvent) then
  begin
    m_OnValueChangedEvent(Self);
  end;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Check that the data value is within min/max range.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.MinMaxCheck(ComboBoxPtr: TCombobox): Boolean;
var
  floatValue: Double;
begin
  Result := False;

  try
    floatValue := StrToFloat(ComboBoxPtr.Text);

    if (floatValue >= m_Min) and (floatValue <= m_Max) then
    begin
      ComboBoxPtr.Text := ParameterFloatToStr(floatValue);
      Result := True;
    end
    else
    begin
      ComboBoxPtr.Color := clRed;
    end;
  except
    ComboBoxPtr.Color := clRed;
  end;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Check that the data value is within min/max range.
// Inputs:       Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.MinMaxClip(DoubleValue: Double): Double;
begin
  if (DoubleValue < m_Min) then
    Result := m_Min
  else if (DoubleValue > m_Max) then
    Result := m_Max
  else
    Result := DoubleValue;
end;

function TParameterSelectData.IndexToString(IndexValue: Integer): String;
begin
  Result := c_InvalidString;

  if ((IndexValue >= 0) and (IndexValue <= m_ListOfValues.Count)) then
    Result:= m_ListOfValues.Strings[IndexValue];
end;

function TParameterSelectData.IndexToTag(IndexValue: Integer): Integer;
begin
  Result := c_InvalidIndex;

  if ((IndexValue >= 0) and (IndexValue <= m_ListOfValues.Count)) then
    Result:= StrToInt(m_ListOfTags.Strings[IndexValue]);
end;

function TParameterSelectData.MenuItemToString(MenuItem: String): String;
begin
  Result := ReplaceStr(MenuItem, Caption + ': ', '');
end;

function TParameterSelectData.StringToIndex(StringValue: String): Integer;
begin
  Result := m_ListOfValues.IndexOf(StringValue);
end;

function TParameterSelectData.StringToMenuItem(StringValue: String): String;
begin
  Result := Caption + ': ' + StringValue;
end;

function TParameterSelectData.StringToTag(StringValue: String): Integer;
var
  index: Integer;
begin
  Result := c_InvalidIndex;

  index := m_ListOfValues.IndexOf(StringValue);
  if ((index >= 0) and (index <= m_ListOfTags.Count)) then
    Result:= StrToInt(m_ListOfTags.Strings[index]);
end;

function TParameterSelectData.TagToIndex(TagValue: Integer): Integer;
begin
  Result := m_ListOfTags.IndexOf(Format('%d', [TagValue]));
end;

function TParameterSelectData.TagToString(TagValue: Integer): String;
var
  index: Integer;
begin
  Result := c_InvalidString;

  index := m_ListOfTags.IndexOf(Format('%d', [TagValue]));
  if ((index >= 0) and (index <= m_ListOfValues.Count)) then
    Result:= m_ListOfValues.Strings[index];
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// AppSettings conversion methods
////////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterSelectData.AppSettingsToEnum(AppSettings: TAppSettings; Section: String): Integer;
var
  tagAsEnum: Integer;
  tagAsString: String;
begin
  tagAsEnum := -1;
  tagAsString := AppSettings.AppSettingsFile.ReadString(Section, Name, c_DefaultValue);

  if (tagAsString <> c_DefaultValue) then
    tagAsEnum := StringToTag(tagAsString);

  Result := tagAsEnum;
end;

////////////////////////////////////////////////////////////////////////////////
// History
////////////////////////////////////////////////////////////////////////////////

// InitHistory
procedure TParameterSelectData.InitHistory;
begin
  inherited;

  UpdateUnits();
end;

// UpdateUnits
procedure TParameterSelectData.UpdateUnits();
var
  nIndex: Integer;
begin
  if (Assigned(m_History)) and (m_ListOfValues.Count > 0) then
  begin
    m_History.Units  := m_ListOfValues[0] + '(' + m_ListOfTags[0] + ')';
    for nIndex := 1 to m_ListOfValues.Count - 1 do
      m_History.Units := m_History.Units + ', ' + m_ListOfValues[nIndex] + '(' + m_ListOfTags[nIndex] + ')';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Readback
////////////////////////////////////////////////////////////////////////////////

// InitReadback
procedure TParameterSelectData.InitReadback;
var
  parameterSelectData: TParameterSelectData;
begin
  if not assigned(m_Readback) then
  begin
    parameterSelectData := TParameterSelectData.Create(Self);
    parameterSelectData.Initialize(Self);

    parameterSelectData.Name := GetReadbackName(Name);
    parameterSelectData.Caption := Caption;
    parameterSelectData.CaptionLong := CaptionLong;
    parameterSelectData.Hint := GetReadbackHint(Hint);
    parameterSelectData.Units := Units;

    m_Readback := TParameter(parameterSelectData);
  end;
end;

// GetReadback
function TParameterSelectData.GetReadback: TParameterSelectData;
begin
  if not assigned(m_Readback) then
  begin
    InitReadback();
  end;

  Result := TParameterSelectData(m_Readback)
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
procedure TParameterSelectData.ToButton(ButtonPtr: TSpeedButton; StringValue: String; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
var
  indexValue: Integer;
begin
  if (HintMode <> tcHintDefault) then
  begin
    ButtonPtr.ShowHint := True;
    ButtonPtr.Hint := Hint + ' (' + StringValue + ')';
  end;
  ButtonPtr.Visible := GetVisibleUsingMode(VisibleMode);
  ButtonPtr.Enabled := GetEnabledUsingMode(EnabledMode);

  // Set button state
  indexValue := m_ListOfValues.IndexOf(StringValue);
  if (indexValue = ValueAsIndex) then
    ButtonPtr.Down := True
  else
    ButtonPtr.Down := False;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'ToCheckBox' component.
// Inputs:       CheckBoxPtr: TCheckBox
//               StringValue: String constant into select data list
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToCheckBox(CheckBoxPtr: TCheckBox; StringValue: String);
var
  onClickEvent: TNotifyEvent;
  indexValue: Integer;
begin
  if (Hint <> c_DefaultHint) then
  begin
    CheckBoxPtr.ShowHint := True;
    CheckBoxPtr.Hint := Hint + ': ' + StringValue;
  end;
  CheckBoxPtr.Visible := Visible;
  CheckBoxPtr.Enabled := Enabled;

  // Disable the OnClick handler
  onClickEvent := CheckBoxPtr.OnClick;
  CheckBoxPtr.OnClick := nil;

  // Set radio caption and checked state... make sure it's a valid string constant
  indexValue := m_ListOfValues.IndexOf(StringValue);
  if ((indexValue <> -1)) then
  begin
    if (indexValue = ValueAsIndex) then
      CheckBoxPtr.Checked := True
    else
      CheckBoxPtr.Checked := False;
  end;

  // Enable the OnClick handler
  CheckBoxPtr.OnClick := onClickEvent;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TComboBox' component.
// Inputs:       TComboBox
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToColorBox(ColorBox: TColorBox);
var
  Index: Integer;
begin
  if m_ReadOnly then
  begin
    ColorBox.Color := c_ColorBackgroundReadOnly;
    ColorBox.Font.Color := c_ColorForegroundReadOnly;
   end
  else
  begin
    ColorBox.Color := GetBackgroundColor(BackgroundColor);
    ColorBox.Font.Color := GetForegroundColor(ForegroundColor);
  end;

  if (Hint <> c_DefaultHint) then
  begin
    ColorBox.ShowHint := True;
    ColorBox.Hint := Hint;
  end;

  ColorBox.Visible := Visible;
  ColorBox.Enabled := Enabled;
  try
    // suspend update until the list is rebuilt/updated
    ColorBox.Items.BeginUpdate();

    ColorBox.Items.Clear();
    if m_ReadOnly then
    begin
      // Set current item in ComboBox list... make sure it's valid
      ColorBox.Items.InsertObject(0, ValueAsString, TObject(StringToColor(m_ListOfColors.Strings[ValueAsIndex])));
    end
    else
    begin
      // Fill Values into ComboBox
     for Index := 0 to m_ListOfValues.Count - 1 do
       ColorBox.Items.InsertObject(0, m_ListOfValues[Index], TObject(StringToColor(m_ListOfColors.Strings[Index])));
    end;

    // Set current item in ComboBox list... make sure it's valid
    if ((ValueAsIndex >= 0) and (ValueAsIndex < ColorBox.Items.Count)) then
      ColorBox.ItemIndex := ValueAsIndex
    else
      ColorBox.ItemIndex := 0;
  finally
    ColorBox.Items.EndUpdate();
  end;
//
//
//
//
//
//  if m_ReadOnly then
//  begin
//    // Set current item in ComboBox list... make sure it's valid
//    ColorBox.Items.InsertObject(0, ValueAsString, TObject(ValueAsColor));
//  end
//  else
//  begin
//    // Fill Values into ComboBox
//    for Index := 0 to m_ListOfValues.Count - 1 do
//      ColorBox.Items.InsertObject(0, ColorToString(Parameter[Index].ColorValue), TObject(Parameter[Index].ColorValue));
//  end;
//
//  // Set current item in ComboBox list... make sure it's valid
//  if ((ParameterIndex.ValueAsInt >= 0) and (ParameterIndex.ValueAsInt < ColorBox.Items.Count)) then
//    ColorBox.ItemIndex := ParameterIndex.ValueAsInt
//  else
//    ColorBox.ItemIndex := 0;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TComboBox' component.
// Inputs:       TComboBox
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToComboBox(ComboBox: TComboBox);
begin
  if m_ReadOnly then
  begin
    ComboBox.Color := c_ColorBackgroundReadOnly;
    ComboBox.Font.Color := c_ColorForegroundReadOnly;
    ComboBox.Style := csDropDownList;
   end
  else
  begin
    ComboBox.Color := GetBackgroundColor(BackgroundColor);
    ComboBox.Font.Color := GetForegroundColor(ForegroundColor);

    if m_DropDownStyle = ddListDynamic then
    begin
      ComboBox.Style := csDropDown;
      ComboBox.AutoComplete := False;
    end
    else if m_DropDownStyle = ddListStatic then
    begin
      ComboBox.Style := csDropDownList;
      ComboBox.AutoComplete := True;
    end;

    ComboBox.DropDownCount := DropDownCount;
  end;

  // If style=dynamic and sort=numeric, assumes that there are limits that should be displayed
  if (m_DropDownStyle = ddListDynamic) and ((m_Sort = stNumericSort) or (m_Sort = stNumericSortInverse)) then
    Hint := ParameterFloatToStr(m_Min) + ' <= Value <= ' + ParameterFloatToStr(m_Max);

  if (Hint <> c_DefaultHint) then
  begin
    if (HintAs = hintAsString) then
    begin
      ComboBox.ShowHint := True;
      ComboBox.Hint := Value;
    end
    else
    begin
      ComboBox.ShowHint := True;
      ComboBox.Hint := Hint;
    end;
  end;

  ComboBox.Visible := Visible;
  ComboBox.Enabled := Enabled;

  // For performance reasons don't populate the combobox list here; wait until the drop-down is selected
  ComboBox.OnDropDown := OnDropDown;

  if ((ValueAsIndex < 0) or (ValueAsIndex >= m_ListOfValues.Count)) then
    m_DropDownIsDirty := True
  else if ComboBox.Items.Count <> m_ListOfValues.Count then
    m_DropDownIsDirty := True
  else if ComboBox.Items.Strings[ComboBox.ItemIndex] <> m_ListOfValues.Strings[ValueAsIndex] then
    m_DropDownIsDirty := True;
  RebuildComboBox(ComboBox);
end;

procedure TParameterSelectData.OnDropDown(Sender: TObject);
var
  ComboBox: TComboBox;
begin
  if (Assigned(m_OnListDisplayEvent)) then
    m_OnListDisplayEvent(Self);

  ComboBox := Sender as TComboBox;
  m_DropDownIsDirty := True;

  RebuildComboBox(ComboBox);
end;

procedure TParameterSelectData.RebuildComboBox(ComboBox: TComboBox);
begin
  if m_DropDownIsDirty = False then
    Exit;

  try
    // suspend update until the list is rebuilt/updated
    ComboBox.Items.BeginUpdate();

    ComboBox.Items.Clear();
    if m_ReadOnly then
    begin
      // Set current item in ComboBox list... make sure it's valid
      if ((ValueAsIndex >= 0) and (ValueAsIndex < m_ListOfValues.Count)) then
        ComboBox.Items.Add(m_ListOfValues.Strings[ValueAsIndex])
      else if m_ListOfValues.Count > 0 then
        ComboBox.Items.Add(m_ListOfValues.Strings[0]);
    end
    else
    begin
      // Fill Values into ComboBox
      ComboBox.Perform(CB_INITSTORAGE, m_ListOfValues.Count, Length(m_ListOfValues.Text));
      ComboBox.Items := m_ListOfValues;

      ComboBox.Perform(CB_INITSTORAGE, m_ListOfCustomValues.Count, Length(m_ListOfCustomValues.Text));
      ComboBox.Items.AddStrings(m_ListOfCustomValues);
    end;

    // Set current item in ComboBox list... make sure it's valid
    if ((ValueAsIndex >= 0) and (ValueAsIndex < ComboBox.Items.Count)) then
      ComboBox.ItemIndex := ValueAsIndex
    else
      ComboBox.ItemIndex := 0;

    m_DropDownIsDirty := False;
  finally
    ComboBox.Items.EndUpdate();
  end;
end;

procedure TParameterSelectData.RebuildStringList(var StringList: TStringList);
begin
  if m_DropDownIsDirty = False then
    Exit;

  try
    // suspend update until the list is rebuilt/updated
    StringList.BeginUpdate();

    StringList.Clear();
    if m_ReadOnly then
    begin
      // Set current item in ComboBox list... make sure it's valid
      if ((ValueAsIndex >= 0) and (ValueAsIndex < m_ListOfValues.Count)) then
        StringList.Add(m_ListOfValues.Strings[ValueAsIndex])
      else if m_ListOfValues.Count > 0 then
        StringList.Add(m_ListOfValues.Strings[0]);
    end
    else
    begin
      // Fill Values into ComboBox
      StringList.AddStrings(m_ListOfValues);

      StringList.AddStrings(m_ListOfCustomValues);
    end;
  finally
    StringList.EndUpdate();
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter label information to a 'TComboBox' component.
// Inputs:       TLabel
// Outputs:      None
// Note:         This method is used only to update a label(i.e. the 'caption')
//               associated to the actual data field.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToControl(ControlPtr: TControl; StringValue: String; VisibleMode: TUserLevelDisplay);
var
  iIndex: Integer;
  bValue: Boolean;
begin
  iIndex := m_ListOfValues.IndexOf(StringValue);
  if (iIndex = ValueAsIndex) then
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
procedure TParameterSelectData.ToEditBox(EditPtr: TEdit);
begin
  if m_ReadOnly then
  begin
    EditPtr.Color := c_ColorBackgroundReadOnly;
    EditPtr.Font.Color := c_ColorForegroundReadOnly;
    EditPtr.ShowHint := True;
    EditPtr.Hint := 'Read-only';
    EditPtr.ReadOnly := True;
   end
  else
  begin
    EditPtr.Color := GetBackgroundColor(BackgroundColor);
    EditPtr.Font.Color := GetForegroundColor(ForegroundColor);

    if (Hint <> c_DefaultHint) then
    begin
      if (HintAs = hintAsString) then
      begin
        EditPtr.ShowHint := True;
        EditPtr.Hint := Value;
      end
      else
      begin
        EditPtr.ShowHint := True;
        EditPtr.Hint := Hint;
      end;
    end;
  end;

  EditPtr.Visible := Visible;
  EditPtr.Enabled := Enabled;
  EditPtr.Text := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TEditList component
// Inputs:       TEditList
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToEditList(EditList: TEditList);
var
  i: Integer;
//  ParameterPtr: TParameterString;
  editPtr: TEdit;
begin
  // If the hint is unset(i.e. c_DefaultHint) the hint values from the design time control are used
  if (Hint <> c_DefaultHint) then
  begin
    EditList.ShowHint := True;
    EditList.Hint := Hint;
  end;
  EditList.Visible := Visible;

  // Disable the user callbacks before modifying. This will cause problems if not done
  EditList.EnableEvents := False;

  // Clear the EditList and set the size
  EditList.ReInitialize(NumberOfValues);

  // Set Indicator, must happen before setting color
  EditList.IndicatorIndex := ValueAsIndex;

  // Set secondary indicator (only if being used)
  EditList.SecondaryIndicator := False;

  // Fill values into each TEdit control contained in the list
  for i := 0 to NumberOfValues - 1 do
  begin
    editPtr := EditList.Control[i];
    editPtr.Text := Values[i];

    // A TParameterList 'Enabled' state of 'False' overrides the individual control state
    if not (Enabled) then
      editPtr.Enabled := False;

    EditList.ControlRecolor(i);
  end;

  // reposition controls (top and spacing) if visibility has changed
  EditList.RepositionWithVisibility;

  // Enable the user callbacks
  EditList.EnableEvents := True;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TLabel' component.
// Inputs:       TLabel
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToLabel(LabelPtr: TLabel);
begin
  LabelPtr.Color := GetBackgroundColor(c_ColorBackgroundLabel);
  LabelPtr.Font.Color := GetForegroundColor(c_ColorForegroundLabel);

  if (Hint <> c_DefaultHint) then
  begin
    if (HintAs = hintAsString) then
    begin
      LabelPtr.ShowHint := True;
      LabelPtr.Hint := Value;
    end
    else
    begin
      LabelPtr.ShowHint := True;
      LabelPtr.Hint := Hint;
    end;
  end;

  LabelPtr.Visible := Visible;
  LabelPtr.Enabled := Enabled;
  LabelPtr.Caption := Value;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TListBox' component.
// Inputs:       RadioButtonPtr: TRadioButton
//               StringValue: String constant into select data list
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToListBox(ListBoxPtr: TListBox);
begin
  ListBoxPtr.Color := GetBackgroundColor(BackgroundColor);
  ListBoxPtr.Font.Color := GetForegroundColor(ForegroundColor);
  if (Hint <> c_DefaultHint) then
  begin
    ListBoxPtr.ShowHint := True;
    ListBoxPtr.Hint := Hint;
  end;
  ListBoxPtr.Visible := Visible;
  ListBoxPtr.Enabled := Enabled;
  ListBoxPtr.Items := m_ListOfValues;

  // Set current item in ComboBox list... make sure it's valid
  if ((ValueAsIndex >= 0) and (ValueAsIndex < ListBoxPtr.Items.Count)) then
    ListBoxPtr.ItemIndex := ValueAsIndex
  else
    ListBoxPtr.ItemIndex := 0;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TMenuItem' component.
// Inputs:       MenuItemPtr: TMenuItem
//               Index: True as index 0;  False as index 1;
// Outputs:      None
// Note:         Boolean values are placed in the radio button with True as index 0!
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToMenuItem(MenuItemPtr: TMenuItem; IndexValue: Integer);
begin
  if (Hint <> c_DefaultHint) then
  begin
    MenuItemPtr.Hint := Hint;
  end;
  MenuItemPtr.Visible := Visible;
  MenuItemPtr.Enabled := Enabled;

  // Set radio caption and checked state... make sure it's a valid index
  if ((IndexValue >= 0) and (IndexValue < m_ListOfValues.Count)) then
  begin
    if Caption <> '' then
      MenuItemPtr.Caption := CaptionLong + ': ' + m_ListOfValues.Strings[indexValue]
    else
      MenuItemPtr.Caption := m_ListOfValues.Strings[indexValue];

    if (IndexValue = ValueAsIndex) then
      MenuItemPtr.Checked := True
    else
      MenuItemPtr.Checked := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TMenuItem' component.
// Inputs:       MenuItemPtr: TMenuItem
//               StringValue: String constant into select data list
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToMenuItem(MenuItemPtr: TMenuItem; StringValue: String; EnabledMode: TToControlEnabledMode);
var
  indexValue: Integer;
begin
  if (Hint <> c_DefaultHint) then
  begin
    MenuItemPtr.Hint := Hint;
  end;
  MenuItemPtr.Visible := Visible;
  MenuItemPtr.Enabled := GetEnabledUsingMode(EnabledMode);

  // Default to current value if no parameter is passed in
  if StringValue = c_InvalidString then
    indexValue := ValueAsIndex
  else
    indexValue := m_ListOfValues.IndexOf(StringValue);

  // Set radio caption and checked state... make sure it's a valid string constant
  if ((indexValue <> -1)) then
  begin
    if Caption <> '' then
      MenuItemPtr.Caption := CaptionLong + ': ' + m_ListOfValues.Strings[indexValue]
    else
      MenuItemPtr.Caption := m_ListOfValues.Strings[indexValue];

    if (indexValue = ValueAsIndex) then
      MenuItemPtr.Checked := True
    else
      MenuItemPtr.Checked := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TPanel' component.
// Inputs:       PanelPtr: TPanel
// Outputs:      None
// Note:         Only updates the color
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToPanel(PanelPtr: TPanel);
begin
  if (Hint <> c_DefaultHint) then
  begin
    PanelPtr.ShowHint := True;
    PanelPtr.Hint := Hint;
  end;

  PanelPtr.Visible := Visible;
  PanelPtr.Enabled := Enabled;

  PanelPtr.Color := ValueAsColor
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TPanel' component.
// Inputs:       PanelPtr: TPanel
// Outputs:      None
// Note:         Only updates the color
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToPopupMenu(PopupMenuPtr: TPopupMenu; OnChangeEvent: TNotifyEvent);
var
  index: Integer;
  newItem: TMenuItem;
  bVisible: Boolean;
  bEnabled: Boolean;
begin
  bVisible := Visible;
  bEnabled := Enabled;

  // Set the popup menu properties as needed
  PopupMenuPtr.AutoHotkeys := maManual;

  // Fill Values into ComboBox
  PopupMenuPtr.Items.Clear();
  for index := 0 to m_ListOfValues.Count - 1 do
  begin
    newItem := TMenuItem.Create(PopupMenuPtr);
    newItem.Caption := StringToMenuItem(m_ListOfValues.Strings[index]);

    newItem.Visible := bVisible;
    newItem.Enabled := bEnabled;
    newItem.OnClick := OnChangeEvent;

    PopupMenuPtr.Items.Add(newItem);
  end;

  // Set the current item as 'checked'
  if ((ValueAsIndex >= 0) and (ValueAsIndex < PopupMenuPtr.Items.Count)) then
    PopupMenuPtr.Items[ValueAsIndex].Checked := True;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TRadioButton' component.
// Inputs:       RadioButtonPtr: TRadioButton
//               IndexValue: Index into select data list
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToRadioButton(RadioButtonPtr: TRadioButton; IndexValue: Integer);
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

  // Set radio caption and checked state... make sure it's a valid index
  if ((IndexValue >= 0) and (IndexValue < m_ListOfValues.Count)) then
  begin
    if RadioButtonPtr.Caption <> '' then
      RadioButtonPtr.Caption := m_ListOfValues.Strings[IndexValue];

    if (IndexValue = ValueAsIndex) then
      RadioButtonPtr.Checked := True
    else
      RadioButtonPtr.Checked := False;
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
procedure TParameterSelectData.ToRadioButton(RadioButtonPtr: TRadioButton; StringValue: String; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
var
  radioOnClick: TNotifyEvent;
  indexValue: Integer;
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

  // Default to current value if no parameter is passed in
  if StringValue = c_InvalidString then
    indexValue := ValueAsIndex
  else
    indexValue := m_ListOfValues.IndexOf(StringValue);

  // Set radio caption and checked state... make sure it's a valid string constant
  if ((indexValue <> -1)) then
  begin
    if RadioButtonPtr.Caption <> '' then
      RadioButtonPtr.Caption := m_ListOfValues.Strings[indexValue];

    if (indexValue = ValueAsIndex) then
      RadioButtonPtr.Checked := True
    else
      RadioButtonPtr.Checked := False;
  end
  else
  begin
    RadioButtonPtr.Hint := 'Not available';
    RadioButtonPtr.ShowHint := True;
    RadioButtonPtr.Enabled := False;
    RadioButtonPtr.Checked := False;
  end;

  // Enable the OnClick handler
  RadioButtonPtr.OnClick := radioOnClick;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TShape' component.
// Inputs:       TShape
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToShape(ShapePtr: TShape; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
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

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TPanel' component.
// Inputs:       PanelPtr: TPanel
// Outputs:      None
// Note:         Only updates the color
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToStatusPanel(PanelPtr: TPanel);
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
// Description:  Fill in TTrackBar component
// Inputs:       TTrackBar
// Outputs:      None
// Note:  Will set up progress bars to display percentage values from 0-100%
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToTrackBar(TrackBarPtr: TTrackBar);
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
  TrackBarPtr.Min := 1;
  TrackBarPtr.Max := m_ListOfValues.Count;
  try
    TrackBarPtr.Position := ValueAsIndex;
  except
    TrackBarPtr.Position := TrackBarPtr.Min;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TTrackEdit component.
// Inputs:       TTrackEdit
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterSelectData.ToTrackEdit(TrackEditPtr: TTrackEdit);
var
  status: Integer;
  dIndex: Double;
begin
  if (Hint <> c_DefaultHint) then
  begin
    TrackEditPtr.ShowHint := True;
    TrackEditPtr.Hint := Hint;
  end;

  TrackEditPtr.Visible := Visible;
  TrackEditPtr.Enabled := Enabled;
  TrackEditPtr.Precision := GetPrecision();

  // Set to number of values in the list
  TrackEditPtr.Minimum := 0;
  TrackEditPtr.Maximum := m_ListOfValues.Count - 1;
  TrackEditPtr.Increment := -1;

  // Set the actual data value
  dIndex := ValueAsIndex;
  TrackEditPtr.SetDataValue(status, dIndex);
end;

// GetParameterState
function TParameterSelectData.GetParameterState(): TParameterState;
begin
  Result := m_ParameterState;
end;

// SetParameterState
procedure TParameterSelectData.SetParameterState(const Value: TParameterState);
begin
  // Trigger a changed event to anyone listening; only if the parameter state changes
  if (Value <> m_ParameterState) then
    ValueChangedTrigger(Value);
end;

end.

