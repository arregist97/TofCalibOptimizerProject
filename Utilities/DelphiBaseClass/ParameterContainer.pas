unit ParameterContainer;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterContainer.pas
// Created:   November, 2008 by John Baker
// Purpose:   ParameterContainer holds a list of dissimilar TParameter objects
//******************************************************************************
// Copyright © 1999-2008 Physical Electronics, Inc.
// Created in 2008 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////
interface

uses
  Classes,
  Contnrs,
  IniFiles,
  Parameter,
  AppSettings_TLB;


{TParameterContainer}
type
  TParameterContainer = class(TParameter)
  private
    m_Container: TObjectList;
  protected
    function GetCaption(): String; override; 

    procedure SetEnabled(const Value: Boolean); override;
    procedure SetHint(Value: String = c_DefaultHint); override;
    procedure SetGroup(const Value: String); override;
    procedure SetName(const Value: String); override;
    procedure SetSystemLevel(const Value: TUserLevel); override;
    procedure SetVisible(const Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent) ; override ;
    destructor Destroy() ; override ;
    function Changed(): Boolean; override;
    procedure SaveInit(); override;
    procedure SaveUndo(); override;
    procedure Undo(); override;
    procedure CopyValueFromSetting(FromIniFile: TCustomIniFile; ToIniFile: TCustomIniFile); override;
    procedure ReadValueFromAcq(AppSettings: IAppSettings); override;
    procedure ReadValueFromSetting(IniFile: TCustomIniFile); override;
    procedure WriteValueToAcq(AppSettings: IAppSettings); override;
    procedure WriteValueToSetting(IniFile: TCustomIniFile); override;
    procedure WriteValueToSetting(var FileId: TextFile); override;

    property Container: TObjectList read m_Container write m_Container ;
  end ;

implementation

uses
  StrUtils,
  SysUtils;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterContainer.Create(AOwner: TComponent) ;
begin
  inherited Create(AOwner) ;

  // List of TParameters
  m_Container := TObjectList.Create() ;
  m_Container.OwnsObjects := True ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TParameterContainer.Destroy() ;
begin
  // Cleanup after member variables
  if assigned(m_Container) then
    m_Container.Free() ;

   inherited Destroy ;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if 'Value' of any of the container TParameters have changed
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameterContainer.Changed(): Boolean;
var
  listChanged: Boolean;
  index: Integer ;
begin
  listChanged := False;

  // Check if any of the list member have changed
  index := 0;
  while ((index <= m_Container.Count - 1) and (not listChanged)) do
  begin
    listChanged := (m_Container.Items[index] as TParameter).Changed();
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
procedure TParameterContainer.SaveInit() ;
var
  index: Integer ;
begin
  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).SaveInit();
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
procedure TParameterContainer.SaveUndo() ;
var
  index: Integer ;
begin
  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).SaveUndo();
end ;

function TParameterContainer.GetCaption: String;
begin
  result := inherited GetCaption;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set Enabled
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.SetEnabled(const Value: Boolean);
var
  index: Integer ;
begin
  inherited;

  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).Enabled := Value;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set Hint
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.SetHint(Value: String);
var
  index: Integer ;
begin
  inherited;

  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).Hint := Value + ': ' + (m_Container.Items[index] as TParameter).Hint;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set Group
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.SetGroup(const Value: String);
var
  index: Integer ;
begin
  inherited;

  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).Group := Value;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set Name
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.SetName(const Value: String);
var
  previousName: String;
  parameterName: String;
  index: Integer;
begin
  // Get the name before it's changed in the baseclass
  previousName := Name;

  inherited;

  for index := 0 to m_Container.Count - 1 do
  begin
    // Get the TParameter name
    parameterName := (m_Container.Items[index] as TParameter).Name;

    // Strip off the previous container name
    parameterName := ReplaceStr(parameterName, previousName + ':', '');

    // Add the new container name as the prefix
    parameterName := Value + ':' + parameterName;

    (m_Container.Items[index] as TParameter).Name := parameterName;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set SystemLevel
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.SetSystemLevel(const Value: TUserLevel);
var
  index: Integer ;
begin
  inherited;

  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).SystemLevel := Value;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set Visible
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.SetVisible(const Value: Boolean);
var
  index: Integer ;
begin
  inherited;

  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).Visible := Value;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Single step undo back to the 'Undo' value.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.Undo() ;
var
  index: Integer ;
begin
  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).Undo();
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy the Value from one IniFile to another.
// Inputs:       FromIniFile, ToIniFile - Setting Files.
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.CopyValueFromSetting(FromIniFile: TCustomIniFile; ToIniFile: TCustomIniFile);
var
  index: Integer ;
begin
  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).CopyValueFromSetting(FromIniFile, ToIniFile);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the Value from the AppSettings object(i.e. Acquisition File).
// Inputs:       AppSettings - The App Settings interface.
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.ReadValueFromAcq(AppSettings: IAppSettings);
var
  index: Integer ;
begin
  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).ReadValueFromAcq(AppSettings);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the Value from the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.ReadValueFromSetting(IniFile: TCustomIniFile);
var
  index: Integer ;
begin
  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).ReadValueFromSetting(IniFile);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the AppSettings object(i.e. Acquisition File).
// Inputs:       AppSettings - The App Settings interface.
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.WriteValueToAcq(AppSettings: IAppSettings);
var
  index: Integer ;
begin
  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).WriteValueToAcq(AppSettings);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.WriteValueToSetting(IniFile: TCustomIniFile);
var
  index: Integer ;
begin
  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).WriteValueToSetting(IniFile);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to a text file directly(i.e. Setting File).
//               Write it out in ini file format but by pass TCustomIniFile to improve the performance.
// Inputs:       FileId - ID of the file to write to
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterContainer.WriteValueToSetting(var FileId: TextFile);
var
  index: Integer ;
begin
  for index := 0 to m_Container.Count - 1 do
    (m_Container.Items[index] as TParameter).WriteValueToSetting(FileId);
end;

end.

