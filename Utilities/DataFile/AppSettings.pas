unit AppSettings;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  AppSettings.pas
// Created:   on 7-19-2013 by Dan Hennen
// Purpose:   This module defines the TAppSettings class.
//*********************************************************
// Copyright © 2013 Physical Electronics, Inc.
// Created in 2013 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////
interface

uses
  Classes, IniFiles, Types,
  ObjectPhi;

const
  c_AppSection_MultiPak = 'MultiPak';

type
  TTagLineTypeEnum = (eTagLineType_Section,
                      eTagLineType_Tag,
                      eTagLineType_Other);

  TAppSettings = class(TPhiObject)

  private
    m_ParameterList: TStringList;

    m_AppSettingsIniFile: TMemIniFile;
  protected
    function GetCustomSectionName(SectionName: String; SettingsName: String): String;
  public
    constructor Create(FileName: String); reintroduce; virtual;
    destructor Destroy; override;
    procedure Initialize(Sender: TAppSettings); reintroduce; 

    procedure PreSaveAcqObject(); virtual;
    procedure PostSaveAcqObject(); virtual;

    procedure AddParameter(Section: String; Tag: String; Parameter: TObject);

    property AppSettingsFile: TMemIniFile read m_AppSettingsIniFile;
    property ParameterList: TStringList read m_ParameterList;

    procedure SetTag(Section: String; Tag: String; Value: String);
    procedure SetTagList(TagList: TStringList);

    function GetTagAsBoolean(Section: String; Tag: String; SettingName: String = ''): Boolean;
    function GetTagAsBooleanArray(Section: String; Tag: String; SettingName: String = ''): TBooleanDynArray;
    function GetTagAsEnum(Section: String; Tag: String; SettingName: String = ''): Integer;
    function GetTagAsEnumArray(Section: String; Tag: String; SettingName: String = ''): TIntegerDynArray;
    function GetTagAsFloat(Section: String; Tag: String; SettingName: String = ''): Double;
    function GetTagAsFloatArray(Section: String; Tag: String; SettingName: String = ''): TDoubleDynArray;
    function GetTagAsInt(Section: String; Tag: String; SettingName: String = ''): Integer;
    function GetTagAsIntArray(Section: String; Tag: String; SettingName: String = ''): TIntegerDynArray;
    function GetTagAsString(Section: String; Tag: String; SettingName: String = ''): String;

    procedure GetTagsAsStringList(var HeaderStringList: TStringList);

    procedure ParseTagLine(TagLine: String;
                           var TagLineType: TTagLineTypeEnum;
                           var SectionName: String;
                           var TagName: String;
                           var TagValueStr: String);
    function GetHeaderSizeInBytes: Integer;

    procedure CopySection(SourceSection: String;
                          DestinationSection: String);

    procedure LoadSectionFromFile(SettingsFile: String;
                                  SourceSection: String;
                                  DestinationSection: String);

    function SaveSetting(SettingsFile: String; SectionName: String): Boolean;
  end;

implementation

uses
  System.UITypes,
  Windows,
  Dialogs,
  PhiUtils,
  Parameter,
  SysUtils,
  SysLogQueue,
  SYSLOGQUEUELib_TLB;

const
  c_InvalidValue = 'NAN';

// Create
constructor TAppSettings.Create(FileName: String);
begin
  inherited Create(FileName);

  m_AppSettingsIniFile := nil;
  m_ParameterList := nil;

  // Create a .ini file object to hold the settings; Note that this file resides
  // in memory only - debug mode will force a write to disk
  m_AppSettingsIniFile := TMemIniFile.Create(FileName);

  // Because we're now using a file which is saved to disk (w/debug mode) - must
  // Clear() the memory, otherwise will start w/values read from disk
  m_AppSettingsIniFile.Clear;

  // Create the parameter list.
  m_ParameterList := TStringList.Create();
end;

// Destroy
destructor TAppSettings.Destroy;
begin
  try
    if (assigned(m_AppSettingsIniFile)) then
    begin
      m_AppSettingsIniFile.Free;
      m_AppSettingsIniFile := nil;
    end;

    if (assigned(m_ParameterList)) then
    begin
      m_ParameterList.Free();
      m_ParameterList := nil;
    end;

    inherited Destroy;
  except
    on E: Exception do
      LogErrorMsg(ClassName, eNormal, E_FAIL, 'Exception in Destroy. ' + E.Message);
  end;
end;

// Initialize - Copy object contents to the passed object.
procedure TAppSettings.Initialize(Sender: TAppSettings);
var
  stringList: TStringList;
begin
  // Get a StringList from the .ini file.
  stringList := TStringList.Create;
  Sender.AppSettingsFile.GetStrings(stringList);

  // Set the StringList in the passed object.
  m_AppSettingsIniFile.SetStrings(stringList);
  stringList.Free;

  // Copy the parameter list to the passed object.
  m_ParameterList.Assign(Sender.ParameterList);
end;

// SaveBegin
procedure TAppSettings.PreSaveAcqObject();
begin
end;

// SaveEnd
procedure TAppSettings.PostSaveAcqObject();
begin
  // INI file only resides in memory unless debugging is active
  if GetTraceLevel() <> traceOff then
    m_AppSettingsIniFile.UpdateFile();
end;

procedure TAppSettings.AddParameter(Section: String; Tag: String; Parameter: TObject);
begin
  // Add the header tag to the .ini file object.
  m_ParameterList.AddObject(Section+Tag, Parameter);
end;

// SetTag
procedure TAppSettings.SetTag(Section: String; Tag: String; Value: String);
begin
  // Add the header tag to the .ini file object.
  m_AppSettingsIniFile.WriteString(Section, Tag, Value);
end;

////////////////////////////////////////////////////////////////////////////////
// Description: SetTagList
// Note:
//     MultiPak lines have the following format.
//         tag: string
//
//     PHI Settings lines use the Delphi .ini file format.
//         tag=string
//
////////////////////////////////////////////////////////////////////////////////
procedure TAppSettings.SetTagList(TagList: TStringList);
var
  tagIdx: Integer;
  tagLine: String;
  currentSection: String;
  delimiter: String;  
  beforeDelimiter: Boolean;
  charIdx: Integer;
  tagStr: String;
  valueStr: String;
  tagChar: Char;
begin
  // Set the current section to MultiPak. This assumes that all of the MultiPak
  // tags are before the first section line.
  currentSection := c_AppSection_MultiPak;

  // Loop through each line in the tag list.
  for tagIdx := 0 to TagList.Count - 1 do
  begin
    // Get a line from the tag list.
    tagLine := TagList.Strings[tagIdx];

    // Check for a section line.
    if tagLine[1] = '[' then
    begin
      // Remove the first and last characters in the line to get the section.
      currentSection := Copy(tagLine, 2, Length(tagLine)-2);
    end
    // Else, this is a normal line.
    else
    begin
      // Check if this is a MultiPak format line.
      if currentSection = c_AppSection_MultiPak then
        delimiter := ':'
      else
        delimiter := '=';

      // Loop through each character in the tag line.
      beforeDelimiter := True;
      tagStr := '';
      valueStr := '';
      for charIdx := 1 to Length(tagLine) do
      begin
        // Get a character from the line.
        tagChar := tagLine[charIdx];
        // If the character is the delimitter, set a flag.
        if tagChar = delimiter then
          beforeDelimiter := False
        // If the delimiter hasn't been reached, add the character to the tag name string.
        else if beforeDelimiter then
          tagStr := tagStr + tagChar
        // If the delimiter has been reached, add the character to the value string.
        else
        begin
          // Check for a space character at the begining of the string.
          if (Length(valueStr) > 0) or (tagChar <> ' ') then
            valueStr := valueStr + tagChar;
        end;
      end;

      // Add an entry to the .ini file object.
      m_AppSettingsIniFile.WriteString(currentSection, tagStr, valueStr);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// AppSettings Access Routines
////////////////////////////////////////////////////////////////////////////////

// GetTagAsBoolean
function TAppSettings.GetTagAsBoolean(Section: String; Tag: String; SettingName: String): Boolean;
var
  tagAsBoolean: Boolean;
  tagAsString: String;
  parameter: TParameter;
  index: Integer;
  msgStr: String;
begin
  tagAsBoolean := False;
  parameter := nil;

  index := m_ParameterList.IndexOf(Section+Tag);
  if (index <> -1) then
    parameter := m_ParameterList.Objects[index] as TParameter;

  if assigned(parameter) then
    tagAsBoolean := parameter.AppSettingsToBoolean(Self, GetCustomSectionName(Section, SettingName))
  else if Section = c_AppSection_MultiPak then
  begin
    tagAsString := m_AppSettingsIniFile.ReadString(Section, Tag, c_InvalidValue);
    if (tagAsString = 'TRUE') then
      tagAsBoolean := True
    else if (tagAsString = 'FALSE') then
      tagAsBoolean := False
    else
      ErrorLog(errorNormal, E_FAIL, False, 0,
               'AppSettings Boolean tag is missing in file: Section=' + Section +
               ' Tag=' + Tag + ' Value=' + tagAsString);
  end
  else
  begin
    msgStr := 'AppSettings Boolean tag is missing: Section=' + Section + ' Tag=' + Tag;
    ErrorLog(errorNormal, E_FAIL, False, 0,msgStr);
    MessageDlg(msgStr, mtError, [mbOk], 0);
  end;

  Result := tagAsBoolean;
end;

// GetTagAsBoolean
function TAppSettings.GetTagAsBooleanArray(Section: String; Tag: String; SettingName: String): TBooleanDynArray;
var
  parameter: TParameter;
  index: Integer;
  tagAsBooleanArray: TBooleanDynArray;
begin
  tagAsBooleanArray := nil;
  parameter := nil;

  index := m_ParameterList.IndexOf(Section+Tag);
  if (index <> -1) then
    parameter := m_ParameterList.Objects[index] as TParameter;

  if assigned(parameter) then
    tagAsBooleanArray := parameter.AppSettingsToBooleanArray(Self, GetCustomSectionName(Section, SettingName))
  else
    ErrorLog(errorNormal, E_FAIL, False, 0, 'AppSettingsToBooleanArray tag is missing in file: Section=' + Section + ' Tag=' + Tag);

  Result := tagAsBooleanArray;
end;

// GetTagAsEnum
function TAppSettings.GetTagAsEnum(Section: String; Tag: String; SettingName: String): Integer;
var
  tagAsEnum: Integer;
  parameter: TParameter;
  index: Integer;
begin
  tagAsEnum := 0;
  parameter := nil;

  index := m_ParameterList.IndexOf(Section+Tag);
  if (index <> -1) then
    parameter := m_ParameterList.Objects[index] as TParameter;

  if assigned(parameter) then
  begin
    tagAsEnum := parameter.AppSettingsToEnum(Self, GetCustomSectionName(Section, SettingName));
    if tagAsEnum = c_InvalidIndex then
      ErrorLog(errorNormal, E_FAIL, False, 0,
               'Parameter enums are not defined in ' + Section + '; Parameter=' + Tag);
  end
  else if Section = c_AppSection_MultiPak then
  begin
    ErrorLog(errorNormal, E_FAIL, False, 0,
             'AppSettings Enum tag is missing in file: Section=' + Section + ' Tag=' + Tag);
  end
  else
    ErrorLog(errorNormal, E_FAIL, False, 0,
             'AppSettings Enum tag is missing in file: Section=' + Section + ' Tag=' + Tag);

  Result := tagAsEnum;
end;

// GetTagAsEnumArray
function TAppSettings.GetTagAsEnumArray(Section: String; Tag: String; SettingName: String): TIntegerDynArray;
var
  parameter: TParameter;
  index: Integer;
  tagAsIntegerArray: TIntegerDynArray;
begin
  tagAsIntegerArray := nil;
  parameter := nil;

  index := m_ParameterList.IndexOf(Section+Tag);
  if (index <> -1) then
    parameter := m_ParameterList.Objects[index] as TParameter;

  if assigned(parameter) then
    tagAsIntegerArray := parameter.AppSettingsToEnumArray(Self, GetCustomSectionName(Section, SettingName))
  else
    ErrorLog(errorNormal, E_FAIL, False, 0, 'AppSettingsToEnumArray tag is missing in file: Section=' + Section + ' Tag=' + Tag);

  Result := tagAsIntegerArray;
end;

// GetTagAsFloat
function TAppSettings.GetTagAsFloat(Section: String; Tag: String; SettingName: String): Double;
var
  tagAsDouble: Double;
  tagAsString: String;
  parameter: TParameter;
  index: Integer;
begin
  tagAsDouble := 0.0;
  parameter := nil;

  index := m_ParameterList.IndexOf(Section+Tag);
  if (index <> -1) then
    parameter := m_ParameterList.Objects[index] as TParameter;

  if assigned(parameter) then
    tagAsDouble := parameter.AppSettingsToFloat(Self, GetCustomSectionName(Section, SettingName))
  else if Section = c_AppSection_MultiPak then
  begin
    tagAsString := m_AppSettingsIniFile.ReadString(Section, Tag, c_InvalidValue);
    if (tagAsString <> c_InvalidValue) then
      tagAsDouble := StrToFloat(tagAsString)
    else
      ErrorLog(errorNormal, E_FAIL, False, 0,
               'AppSettings Float tag is missing in file: Section=' + Section +
               ' Tag=' + Tag + ' Value=' + tagAsString);
  end
  else
    ErrorLog(errorNormal, E_FAIL, False, 0,
             'AppSettings Float tag is missing in file: Section=' + Section +
             ' Tag=' + Tag);

  Result := tagAsDouble;
end;

// GetTagAsFloatArray
function TAppSettings.GetTagAsFloatArray(Section: String; Tag: String; SettingName: String): TDoubleDynArray;
var
  parameter: TParameter;
  index: Integer;
  tagAsDoubleArray: TDoubleDynArray;
begin
  tagAsDoubleArray := nil;
  parameter := nil;

  index := m_ParameterList.IndexOf(Section+Tag);
  if (index <> -1) then
    parameter := m_ParameterList.Objects[index] as TParameter;

  if assigned(parameter) then
    tagAsDoubleArray := parameter.AppSettingsToFloatArray(Self, GetCustomSectionName(Section, SettingName))
  else
    ErrorLog(errorNormal, E_FAIL, False, 0, 'AppSettingsToFloatArray tag is missing in file: Section=' + Section + ' Tag=' + Tag);

  Result := tagAsDoubleArray;
end;

// GetTagAsInt
function TAppSettings.GetTagAsInt(Section: String; Tag: String; SettingName: String): Integer;
var
  tagAsInteger: Integer;
  tagAsString: String;
  parameter: TParameter;
  index: Integer;
begin
  tagAsInteger := 0;
  parameter := nil;

  index := m_ParameterList.IndexOf(Section+Tag);
  if (index <> -1) then
    parameter := m_ParameterList.Objects[index] as TParameter;

  if assigned(parameter) then
    tagAsInteger := round(parameter.AppSettingsToFloat(Self, GetCustomSectionName(Section, SettingName)))
  else if Section = c_AppSection_MultiPak then
  begin
    tagAsString := m_AppSettingsIniFile.ReadString(Section, Tag, c_InvalidValue);
    if (tagAsString <> c_InvalidValue) then
      tagAsInteger := StrToInt(tagAsString)
    else
      ErrorLog(errorNormal, E_FAIL, False, 0,
               'AppSettings Integer tag is missing in file: Section=' + Section +
               ' Tag=' + Tag + ' Value=' + tagAsString);
  end
  else
    ErrorLog(errorNormal, E_FAIL, False, 0,
             'AppSettings Integer tag is missing in file: Section=' + Section +
             ' Tag=' + Tag);

  Result := tagAsInteger;
end;

// GetTagAsIntArray
function TAppSettings.GetTagAsIntArray(Section: String; Tag: String; SettingName: String): TIntegerDynArray;
var
  parameter: TParameter;
  index: Integer;
  tagAsIntegerArray: TIntegerDynArray;
begin
  tagAsIntegerArray := nil;
  parameter := nil;

  index := m_ParameterList.IndexOf(Section+Tag);
  if (index <> -1) then
    parameter := m_ParameterList.Objects[index] as TParameter;

  if assigned(parameter) then
    tagAsIntegerArray := parameter.AppSettingsToIntArray(Self, GetCustomSectionName(Section, SettingName))
  else
    ErrorLog(errorNormal, E_FAIL, False, 0, 'AppSettingsToIntArray tag is missing in file: Section=' + Section + ' Tag=' + Tag);

  Result := tagAsIntegerArray;
end;

// GetTagAsString
function TAppSettings.GetTagAsString(Section: String; Tag: String; SettingName: String): String;
var
  tagAsString: String;
  parameter: TParameter;
  index: Integer;
begin
  tagAsString := '';
  parameter := nil;

  index := m_ParameterList.IndexOf(Section+Tag);
  if (index <> -1) then
    parameter := m_ParameterList.Objects[index] as TParameter;

  if assigned(parameter) then
    tagAsString := parameter.AppSettingsToString(Self, GetCustomSectionName(Section, SettingName))
  else if Section = c_AppSection_MultiPak then
  begin
    tagAsString := m_AppSettingsIniFile.ReadString(Section, Tag, c_InvalidValue);
  end
  else
    ErrorLog(errorNormal, E_FAIL, False, 0,
             'AppSettings String tag is missing in file: Section=' + Section  + ' Tag=' + Tag);

  Result := tagAsString;
end;

// GetTagsAsStringList
procedure TAppSettings.GetTagsAsStringList(var HeaderStringList: TStringList);
var
  stringList: TStringList;
  idx: Integer;
  line: String;
  tagLineType: TTagLineTypeEnum;
  currentSection: String;
  tagName: String;
  tagValueStr: String;
  tagLine: String;
begin
  // Clear the header string list.
  HeaderStringList.Clear;

  // Get the strings from the .ini file object.
  stringList := TStringList.Create;
  stringList.Clear;
  m_AppSettingsIniFile.GetStrings(stringList);

  // Loop through the string list to find the MultiPak tags.
  currentSection := '';
  for idx := 0 to stringList.Count - 1 do
  begin
    // Get a line from the string list object.
    line := stringList.Strings[idx];

    // Parse the line.
    ParseTagLine(line, tagLineType, currentSection, tagName, tagValueStr);

    // Check for a tag line.
    if tagLineType = eTagLineType_Tag then
    begin
      // Check if processing the MultiPak section.
      if currentSection = c_AppSection_MultiPak then
      begin
        // Convert the tag line to MultiPak format.
        tagLine := tagName + ': ' + tagValueStr;

        // Add the tag line to the Header String List.
        HeaderStringList.Add(tagLine);
      end;
    end;
  end;

  // Loop through the string list again to process the other tags.
  currentSection := '';
  for idx := 0 to stringList.Count - 1 do
  begin
    // Get a line from the string list object.
    line := stringList.Strings[idx];

    // Parse the line.
    ParseTagLine(line, tagLineType, currentSection, tagName, tagValueStr);

    // Check that this isn't the MultiPak section.
    if currentSection <> c_AppSection_MultiPak then
    begin
      // Ignore blank lines
      if (tagLineType = eTagLineType_Section) or
         (tagLineType = eTagLineType_Tag) then
      begin
        // Add the line to the Header String List.
        HeaderStringList.Add(line);
      end;
    end;
  end;

  // Free the string list memory.
  stringList.Free;
end;

// ParseTagLine
procedure TAppSettings.ParseTagLine(TagLine: String;
                                    var TagLineType: TTagLineTypeEnum;
                                    var SectionName: String;
                                    var TagName: String;
                                    var TagValueStr: String);
var
  beforeDelimiter: Boolean;
  charIdx: Integer;
  tagChar: Char;
begin
  // Initialize the Tag Line Type return parameter.
  TagLineType := eTagLineType_Other;

  // Check that the length of the line is at least 2 characters long.
  if Length(TagLine) > 2 then
  begin
    // Check for a section line.
    if TagLine[1] = '[' then
    begin
      // Set the Tag Line Type to section.
      TagLineType := eTagLineType_Section;

      // Remove the first and last characters in the line to get the section name.
      SectionName := Copy(TagLine, 2, Length(TagLine)-2);
    end
    // Else, this is a normal line.
    else
    begin
      // Loop through each character in the tag line.
      beforeDelimiter := True;
      TagName := '';
      TagValueStr := '';
      for charIdx := 1 to Length(TagLine) do
      begin
        // Get a character from the line.
        tagChar := TagLine[charIdx];

        // If the character is the delimitter, set a flag.
        if (beforeDelimiter) and ((tagChar = '=') or (tagChar = ':')) then
        begin
          // Set the Tag Line Type to tag.
          TagLineType := eTagLineType_Tag;

          // Set flag to indicate that the delimiter has been found.
          beforeDelimiter := False;
        end

        // If the delimiter hasn't been reached, add the character to the tag name string.
        else if beforeDelimiter then
          TagName := TagName + tagChar

        // If the delimiter has been reached, add the character to the value string.
        else
        begin
          // Check for a space character at the begining of the string.
          if (Length(TagValueStr) > 0) or (tagChar <> ' ') then
            TagValueStr := TagValueStr + tagChar;
        end;
      end;
    end;
  end;
end;

// GetHeaderSizeInBytes
function TAppSettings.GetHeaderSizeInBytes: Integer;
var
  headerStringList: TStringList;
  idx: Integer;
  line: String;
  sizeInBytes: Integer;
begin
  // Create the String List.
  headerStringList := TStringList.Create;

  // Read the tags into the String List.
  GetTagsAsStringList(headerStringList);

  // Add up the length of each string.
  sizeInBytes := 0;
  for idx := 0 to headerStringList.Count - 1 do
  begin
    // Get a line from the string list object.
    line := headerStringList.Strings[idx];

    // Add the bytes for the line to the string list.
    sizeInBytes := sizeInBytes + Length(line) + 2;  // CR+LF
  end;

  // Free the String List.
  headerStringList.Free;

  // Return the header size.
  Result := sizeInBytes;
end;

// CopySection
procedure TAppSettings.CopySection(SourceSection: String;
                                   DestinationSection: String);
var
  sectionStringList: TStringList;
  idx: Integer;
  tagLineType: TTagLineTypeEnum;
  sectionName: String;
  tagName: String;
  tagValueStr: String;
begin
  // Get the strings for the specified section from the .ini file object.
  sectionStringList := TStringList.Create;
  sectionStringList.Clear;
  m_AppSettingsIniFile.ReadSectionValues(SourceSection, sectionStringList);

  // Add the strings to the destination section.
  for idx := 0 to sectionStringList.Count - 1 do
  begin
    // Get the tag name and tag value strings from the tag line.
    ParseTagLine(sectionStringList[idx],
                 tagLineType,
                 sectionName,
                 tagName,
                 tagValueStr);

    // Add the tag to the new section.
    SetTag(DestinationSection, tagName, tagValueStr);
  end;

  // Free memory.
  sectionStringList.Free;
end;

// LoadSectionFromFile
procedure TAppSettings.LoadSectionFromFile(SettingsFile: String;
                                           SourceSection: String;
                                           DestinationSection: String);
var
  settingsIniFile: TMemIniFile;
  sectionStringList: TStringList;
  idx: Integer;
  tagLineType: TTagLineTypeEnum;
  sectionName: String;
  tagName: String;
  tagValueStr: String;
begin
  // Read the settings file into a TMemIniFile object.
  settingsIniFile := TMemIniFile.Create(SettingsFile);

  // Get the strings for the specified section from the .ini file object.
  sectionStringList := TStringList.Create;
  sectionStringList.Clear;

  try
    settingsIniFile.ReadSectionValues(SourceSection, sectionStringList);

    // Add the strings to the destination section.
    for idx := 0 to sectionStringList.Count - 1 do
    begin
      // Get the tag name and tag value strings from the tag line.
      ParseTagLine(sectionStringList[idx],
                   tagLineType,
                   sectionName,
                   tagName,
                   tagValueStr);

      // Add the tag to the new section.
      SetTag(DestinationSection, tagName, tagValueStr);
    end;
  finally
    settingsIniFile.Free;
    sectionStringList.Free;
  end;
end;

// SaveSettingToAcqObject
function TAppSettings.SaveSetting(SettingsFile: String; SectionName: String): Boolean;
var
  bValidSave: Boolean;
  sSettingsNameNoPathNoExt: String;
  sCustomSectionName: String;
begin
  bValidSave := True;

  if bValidSave then
  begin
    // Verify that file is valid
    if not FileExists(SettingsFile) then
      bValidSave := False;
  end;

  if bValidSave then
  begin
    // Create a custom section name by combining doc name and setting name - e.g. [GasGun:3kV2x2]
    sSettingsNameNoPathNoExt := StringReplace(ExtractFileName(SettingsFile), ExtractFileExt(SettingsFile), '', []);
    sCustomSectionName := GetCustomSectionName(SectionName, sSettingsNameNoPathNoExt);
  end;

  if bValidSave then
  begin
    // Load the section from the file into the custom section name
    LoadSectionFromFile(SettingsFile, SectionName, sCustomSectionName);
  end;

  Result := bValidSave;
end;

// GetCustomSectionName
function TAppSettings.GetCustomSectionName(SectionName: String; SettingsName: String): String;
begin
  if SettingsName = '' then
    Result := SectionName
  else
    Result := SectionName + ':' + SettingsName;
end;

end.

