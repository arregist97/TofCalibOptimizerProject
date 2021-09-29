unit PhiProject;
////////////////////////////////////////////////////////////////////////////////
// Filename:  PhiProject.pas
// Created:   on 04-28-2016 by Melinda Caouette
// Purpose:   This module contains support for Project name.
//*********************************************************
// Copyright © 2016 Physical Electronics, Inc.
// Created in 2016 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////

interface

uses
  ComCtrls, ActiveX, Registry, Classes;

  procedure SetProjectName(ProjectName: String);
  function GetProjectName(): String;

implementation

uses
  Windows, FileCtrl, SysUtils, Dialogs, PhiUtils ;

var
  m_ProjectName: String = c_SmartSoftTOF;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Project Name. (Used to determine Environment variable and
//               directory structures)
// Inputs:       ProjectName - Project Name
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure SetProjectName(ProjectName: String) ;
begin
  m_ProjectName := ProjectName ;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Project Name. (Used to determine Environment variable and
//               directory structures)
// Inputs:       ProjectName - Project Name
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function GetProjectName(): String ;
begin
  Result := m_ProjectName;
end ;

end.
