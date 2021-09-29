unit PhiUtils;
////////////////////////////////////////////////////////////////////////////////
// Filename:  PhiUtils.pas
// Created:   on 00-11-27 by John Baker
// Purpose:   This module contains common routines that are use by the applications.
//             These routines, in general, cannot be included in an object derived
//             from TPhiDoc, as they are used directly in TPhiDoc, and would cause
//             a circular dependency.
//*********************************************************
// Copyright © 1998 Physical Electronics, Inc.
// Created in 1998 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////

interface

uses
  ComCtrls, ActiveX, Registry, Classes, ShellApi;

const
  // 'Invalid' values are used in the Parameter and Component classes to set default behavior
  c_InvalidFilterIndex = -1;
  c_InvalidDirectory = '-1';
  c_InvalidFilter = '-1';

  c_DataType_Sem = '.sem';
  c_DataType_Sxi = '.sxi';
  c_DataType_Survey = '.spe';
  c_DataType_Profile = '.pro';
  c_DataType_Angle = '.ang';
  c_DataType_Line = '.lin';
  c_DataType_Map = '.map';
  c_DataType_Sps = '.sps';
  c_DataType_Photo = '.pho';
  c_DataType_Platen = '.pff';
  c_DataType_Bmp = '.bmp';
  c_DataType_Raw = '.raw';
  c_DataType_Spectra = '.tdc';
  c_DataType_Images = '.ims';
  c_DataType_Profiles = '.dat';
  c_DataType_3DImages = '.3di';
  c_DataType_Peaks = '.pk';
  c_DataType_DetectorCalib = '.bin';

  // TOFDR
  c_DataType_JPG = '.jpg';
  c_DataType_SED = '.wmf';
  c_DataType_Detector = '.jpg';
  c_DataType_Analysis = '.jpg';
  c_DataType_DetectorCamera = '.bmp';
  c_DataType_AnalysisCamera = '.bmp';
  c_DataType_Spectrum = '.tdc';
//  c_DataType_Profile = '.dat';
  c_DataType_3dImage = '.3di';
  c_DataType_3dModel = '.3dm';
  c_DataType_Peak = '.pk';

  c_FilterIndexSem = 1;
  c_FilterIndexSxi = 2;
  c_FilterIndexSurvey = 3;
  c_FilterIndexProfile = 4;
  c_FilterIndexAngle = 5;
  c_FilterIndexLine = 6;
  c_FilterIndexMap = 7;
  c_FilterIndexSps = 8;
  c_FilterIndexPho = 9;
  c_FilterIndexAll = 10;

  c_FormDir = 'Forms';
  c_LogDir = 'Logs';
  c_PropertyDir: String = 'Properties';
  c_SettingDir: String = 'Settings';

  c_COCFileName: String = 'C:\SmartSoft-XPS\Bin\COC_SS_Connect.txt';

  c_SmartSoftAES = 'SmartSoft-AES';
  c_SmartSoftTOF = 'SmartSoft-TOF';
  c_SmartSoftVP = 'SmartSoft-VersaProbe';
  c_SmartSoftXPS = 'SmartSoft-XPS';
  c_SmartSoft4700 = 'SmartSoft-4700';
  c_SmartSoft4800 = 'SmartSoft-4800';
  c_SmartSoftIG = 'SmartSoft-IonGun';
  c_TOFDR = 'TOF-DR';

  // Data filter.  Note: Limited to 256 characters, split into two strings
  c_DataFilter1: String = 'SEM (*.sem)|*.sem|SXI (*.sxi)|*.sxi|Spectrum (*.spe)|*.spe|Profile (*.pro)|*.pro|Angle (*.ang)|*.ang|Line (*.lin)|*.lin|Map (*.map)|*.map|SPS (*.sps)|*.sps|Photo (*.pho)|*.pho|';
  c_DataFilter2: String = 'Data files (*.sem;*.sxi;*.spe;*.pro;*.ang;*.lin;*.map)|*.sem;*.sxi;*.spe;*.pro;*.ang;*.lin;*.map';
  c_DataFilterTOF: String = 'RAW (*.raw)|*.raw|SEM (*.sem)|*.sem|Photo (*.pho)|*.pho|Spectra (*.tdc)|*.tdc|Images (*.ims)|*.ims|Profiles (*.dat)|*.dat|3D Images (*.3di)|*.3di|Peaks (*.pk)|*.pk';
  c_DataFilterTOFDR1: String = 'TOF-DR Files|*.raw;*.tdc;*.ims;*.dat;*.pk;*.3di;*.pho|Raw (*.raw)|*.raw|Spectrum (*.tdc)|*.tdc';
  c_DataFilterTOFDR2: String = 'Image (*.ims)|*.ims|Profile (*.dat)|*.dat|Peak (*.pk)|*.pk|3D Image (*.3di)|*.3di|Photo (*.pho)|*.pho';

  c_DataFilterPHI: String = 'PHI files (*.phi)|*.phi';
  c_DataFilterDefect: String = 'Defect files (*.phi;*.pff;*.kff;*.rff;*.tff;*.fxy;*.000;*.001;*.00;*.01)|*.phi;*.pff;*.kff;*.rff;*.tff;*.fxy;*.000;*.001;*.00;*.01';

  c_DataFilterAll: String = 'All files (*)|*';

  c_InvalidWindowCharacters = '/\:*?<>|';
  c_InvalidCharacters = c_InvalidWindowCharacters + '~' + '_' + '+';  // Invalid Windows Characters + Area Delimeter(_) + Duplicate Delimeter(~) + More Delimiter(+)

type
  // List of possible SMARTSoft directories
  TDirectories = (dirApp,
                  dirAppForm,
                  dirAppLog,
                  dirAppProperty,
                  dirAppSetting,
                  dirAppSimulation,
                  dirBin,
                  dirCalibration,
                  dirConfig,
                  dirCursor,
                  dirDatafiles,
                  dirDiagnostics,
                  dirDiagnosticsArchive,
                  dirDriver,
                  dirElementDatabase,
                  dirLog,
                  dirManual,
                  dirPeakIdDatabase,
                  dirPlaten,
                  dirProject,
                  dirSetting,
                  dirLanguage,
                  dirSmart,
                  dirSystemLog,
                  dirChartRecorder);

  // window OS : only list out the ones we are interested
  TWindowOS = (osNT,
               os2000,
               osXP,
               osWindows7,
               osWindows10,
               osOther             // anything but NT, 2000, XP, Windows7
               );

  TMaskCheck = (maskCheckNone,
                maskCheckAnd,
                maskCheckOr,
                maskCheckNot);

  procedure FileCopy(const FromFile, ToFile: string);

  procedure SetProjectName(ProjectName: String);
  function GetProjectName(): String;

  function GetPhiCurrentDirectory(): String;
  function GetPhiDirectory(Directory: TDirectories; ApplicationName: String = 'Application'): String;
  function GetEnvironmentVariablePath(EnvironmentVariable: String): String;
  function GetWindowSystemDir(): String;
  function GetWindowDir(): String;
  function GetWindowOS(): TWindowOS;
  function GetFileFilter(): WideString;
  function GetDefectFileFilter(): WideString;

  procedure SetFileFilterIndex(Filter: Integer);
  function GetFileFilterIndex(): Integer;

  procedure RenameAbortedFile(AbortFilename: String);
  function RemoveInvalidCharacters(Filename: String; const InvalidCharacters: String = c_InvalidCharacters): String;
  function SetPhiCurrentDirectory(Path: String): String;
  procedure SetSmartSoftCOC(Path: String);
  function ValidDataExtension(Extension: String): Boolean;
  function ValidDefectExtension(Extension: String): Boolean;
  function MaskCheck(PrimaryMask: Integer; MaskCheckMode: TMaskCheck; CheckMask: Integer): Boolean;
  function GetExeVersion(sExecutableName: String): String;
  procedure DeleteDirectory(const Dir: String);
  procedure RenameDirectory(const DirFrom: String; const DirTo: String);
  procedure CopyDirectory(const DirFrom: String; const DirTo: String);
  function CompareVersions(sVersion1: String; sVersion2: String): Integer;
  function ProcessExists(ProcessFilename: String): Boolean;

  function GetSEEDbAppInstallationDir(): String;

implementation

uses
  TlHelp32,
  Windows, FileCtrl, SysUtils, Dialogs, Math,
  PhiProject;

const
  // Directory names
  c_Bin: String = 'Bin';
  c_Datafiles: String = 'Datafiles';
  c_Configuration: String = 'Configuration';
  c_Cursor: String = 'Cursor';
  c_ElementDatabase: String = 'ElementDatabase';
  c_Setting: String = 'Setting';
  c_Simulation: String = 'Simulation';
  c_Driver: String = 'Driver';
  c_Manual: String = 'Manual';
  c_Calibration: String = 'Calibration';
  c_Log: String = 'Log';
  c_SystemLogDir: String = 'SystemLog';
  c_ChartRecorderDir: String = 'ChartRecorder';
  c_Diagnostics: String = 'Diagnostics';
  c_Platen: String = 'Platen' ;
  c_Language: String = 'Language';

  c_DefectDelimiter: String = '|';

var
  dataExtensions: array [0..8] of String = (c_DataType_Sem,
                                            c_DataType_Sxi,
                                            c_DataType_Survey,
                                            c_DataType_Profile,
                                            c_DataType_Angle,
                                            c_DataType_Line,
                                            c_DataType_Map,
                                            c_DataType_Sps,
                                            c_DataType_Photo);

  dataExtensionsTOF: array [0..2] of String = (c_DataType_Raw,
                                            c_DataType_Bmp,
                                            c_DataType_Photo);

  dataExtensionsTOFDR: array [0..10] of String = (c_DataType_JPG,
                                            c_DataType_Photo,
                                            c_DataType_SED,
                                            c_DataType_Detector,
                                            c_DataType_Analysis,
                                            c_DataType_Raw,
                                            c_DataType_Spectrum,
                                            c_DataType_Images,
                                            c_DataType_Profile,
                                            c_DataType_3dImage,
                                            c_DataType_3dModel);

  defectExtensions: array [0..9] of String = ('.phi',
                                            '.pff',
                                            '.kff',
                                            '.rff',
                                            '.tff',
                                            '.fxy',
                                            '.000',
                                            '.001',
                                            '.00',
                                            '.01');

  m_COCFileHandle: Integer = -1;
  m_CurrentDirectory: String = c_InvalidDirectory;
  m_CurrentFilterIndex: Integer = c_FilterIndexAll;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Project Name. (Used to determine Environment variable and
//               directory structures)
// Inputs:       ProjectName - Project Name
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure SetProjectName(ProjectName: String);
begin
  PhiProject.SetProjectName(ProjectName);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Project Name. (Used to determine Environment variable and
//               directory structures)
// Inputs:       ProjectName - Project Name
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function GetProjectName(): String;
begin
  Result := PhiProject.GetProjectName();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Copy a file
// Inputs:      FromFile, ToFile
// Outputs:     None
// Note:        This way uses memory blocks for read/write.}
////////////////////////////////////////////////////////////////////////////////
procedure FileCopy(const FromFile, ToFile: string);
  var
  FromF, ToF: file;
  NumRead, NumWritten: Integer;
  Buf: array[1..2048] of Char;
begin
  AssignFile(FromF, FromFile);
  Reset(FromF, 1); // Record size = 1
  AssignFile(ToF, ToFile); // Open output file
  Rewrite(ToF, 1); // Record size = 1 }
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  CloseFile(FromF);
  CloseFile(ToF);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the pathname defined by the given environment variable
// Inputs:       EnvironmentVariable - interested environment variable
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
function GetEnvironmentVariablePath(EnvironmentVariable: String): String;
const
  c_BufferSize = 1024;
var
  pathName: String;
  Buf : array [0..c_BufferSize-1] of Char;
begin
  pathName := '';

  // Buf must be declared as an array [0..c_BufferSize] to use like this
  if (GetEnvironmentVariable(PChar(EnvironmentVariable), @Buf, c_BufferSize) <> 0) then
    pathName := Buf;

  Result := pathName;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current 'Current' directory pathname
// Inputs:       None
// Outputs:      'Current' directory as String
// Note:
////////////////////////////////////////////////////////////////////////////////
function GetPhiCurrentDirectory(): String;
begin
  // Check for the default directory (i.e. directory has not been set)
  if (m_CurrentDirectory = c_InvalidDirectory) then
    m_CurrentDirectory := GetPhiDirectory(dirDatafiles);

  // Check for valid directory
  if (not DirectoryExists(m_CurrentDirectory)) then
    m_CurrentDirectory := GetPhiDirectory(dirDatafiles);

  Result := m_CurrentDirectory;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the pathname used for settings or properties.
// Inputs:       None.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
function GetPhiDirectory(Directory: TDirectories; ApplicationName: String): String;
const
  c_BufferSize = 1024;
var
  pathName: String;
  driveName: String;
  Buf : array [0..c_BufferSize-1] of Char;
begin
  // Buf must be declared as an array [0..c_BufferSize] to use like this
  if (GetEnvironmentVariable(PChar(GetProjectName()), @Buf, c_BufferSize) <> 0) then
    pathName := Buf
  else
  begin
    pathName := 'C:\' + GetProjectName();
    if (DirectoryExists(pathName) = False) then
      ForceDirectories(pathName);

    // Temporarily sets environment variable
    SetEnvironmentVariable(PChar(GetProjectName()), PChar(pathName));
  end;

  // Find the drive
  driveName := ExtractFileDrive(pathName);

  // Trim trailing '\' from pathname
  if IsDelimiter('\', pathName, Length(pathName)) then
    pathName := Copy(pathName, 0, Length(pathName) - 1);

  case Directory of
    dirApp: pathName := pathName + '\' + c_Setting + '\' + ApplicationName;
    dirAppForm: pathName := pathName + '\' + c_Setting + '\' + ApplicationName + '\' + c_FormDir;
    dirAppLog: pathName := pathName + '\' + c_Setting + '\' + ApplicationName + '\' + c_LogDir;
    dirAppProperty: pathName := pathName + '\' + c_Setting + '\' + ApplicationName + '\' + c_PropertyDir;
    dirAppSetting: pathName := pathName + '\' + c_Setting + '\' + ApplicationName + '\' + c_SettingDir;
    dirAppSimulation: pathName := pathName + '\' + c_Simulation + '\' + ApplicationName;
    dirBin: pathName := pathName + '\' + c_Bin;
    dirCalibration: pathName := pathName + '\' + c_Calibration;
    dirConfig: pathName := pathName + '\' + c_Configuration;
    dirCursor: pathName := pathName + '\' + c_Cursor;
    dirDatafiles: pathName := driveName + '\' + c_Datafiles;
    dirDiagnostics: pathName := pathName + '\' + c_Diagnostics;
    dirDiagnosticsArchive: pathName := ':\' + GetProjectName() + '\' + c_Diagnostics;
    dirDriver: pathName := pathName  + '\' + c_Driver;
    dirElementDatabase: pathName := pathName + '\' + c_Configuration;
    dirLog: pathName := pathName + '\' + c_Log;
    dirManual: pathName := pathName + '\' + c_Manual;
    dirPeakIdDatabase: pathName := pathName + '\' + c_Configuration;
    dirPlaten: pathName := pathName + '\' + c_Platen ;
    dirSetting: pathName := pathName + '\' + c_Setting;
    dirLanguage: pathName := PathName + '\' + c_Language;
    dirSmart:;
    dirSystemLog: pathName := PathName + '\' + c_Log + '\' + c_SystemLogDir;
    dirChartRecorder: pathName := PathName + '\' + c_Log + '\' + c_ChartRecorderDir;

  else
    pathName := '.';
  end;

  // Create the directory if it doesn't already exist
  if (DirectoryExists(pathName) = False) then
    ForceDirectories(pathName);

  Result := pathName;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the system directory pathname
// Inputs:       None
// Outputs:      None
// Return:       Full system pathname if successful; Empty string if failure
// Note:
////////////////////////////////////////////////////////////////////////////////
function GetWindowSystemDir(): String;
const
  c_BufferSize = 1024;
var
  PathName: String;
  Buf : array [0..c_BufferSize] of Char;
begin
  // Buf must be declared as an array [0..c_BufferSize] to use like this
  if (GetSystemDirectory(@Buf, c_BufferSize) > 0) then
    PathName := Buf
  else
    PathName := '';

  Result := PathName;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the window directory pathname
// Inputs:       None
// Outputs:      None
// Return:       Full window pathname if successful; Empty string if failure
// Note:
////////////////////////////////////////////////////////////////////////////////
function GetWindowDir(): String;
const
  c_BufferSize = 1024;
var
  PathName: String;
  Buf : array [0..c_BufferSize] of Char;
begin
  // Buf must be declared as an array [0..c_BufferSize] to use like this
  if (GetWindowsDirectory(@Buf, c_BufferSize) > 0) then
    PathName := Buf
  else
    PathName := '';

  Result := PathName;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the operating system type
// Inputs:       None
// Outputs:      None
// Return:       Window OS type
// Note:
////////////////////////////////////////////////////////////////////////////////
function GetWindowOS(): TWindowOS;
var
		VerBuild,
		VerMajor,
		VerMinor,
		VerPlatformID: WORD;
		OSVerInf: TOSVersionInfo;
    OSType: TWindowOS;
begin
  OSType := osOther;

	// This is necessary to tell GetVersionEx function to handle structure //
	OSVerInf.dwOSVersionInfoSize:= SizeOf(TOSVersionInfo);

	// Check if OSVerInfo structure size is big enough to hold version information
	if (GetVersionEx(OSVerInf)) then
  begin
  	VerMajor:= OSVerInf.dwMajorVersion;
	  VerMinor:= OSVerInf.dwMinorVersion;
	  VerPlatformID:= OSVerInf.dwPlatformID;

    if (VerPlatformID = VER_PLATFORM_WIN32_NT) then
    begin
      VerBuild:= OSVerInf.dwBuildNumber;

      // test if it is NT
      if ((VerMajor = 4) and (VerMinor = 0) and (VerBuild = 1381)) then
        OSType := osNT
      // test if it is 2000
      else if ((VerMajor = 5) and (VerMinor = 0)) then
        OSType := os2000
      // test if it is XP
      else if ((VerMajor = 5) and (VerMinor = 1)) then
        OSType := osXP
      else if ((VerMajor = 6) and (VerMinor = 1)) then
        OSType := osWindows7
      else if (VerMajor = 10) then
        OSType := osWindows10;
    end;
  end;

  Result := OSType;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the File Dialog box filter
// Inputs:       File Filter as String
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function GetFileFilter(): WideString;
begin
  // Concatinate the filters :dataFilter + '|' + defectFilter + '|' + allFilter
  Result := c_DataFilterAll;

  if (c_DataFilterDefect <> '') then
    Result := c_DataFilterDefect + '|' + Result;

  if (GetProjectName() = c_SmartSoftTOF) then
  begin
    if (c_DataFilterTOF <> '') then
      Result := c_DataFilterTOF + '|' + Result;
  end
  else if (GetProjectName() = c_TOFDR) then
  begin
    if (c_DataFilterTOFDR1 <> '') and (c_DataFilterTOFDR2 <> '') then
      Result := c_DataFilterTOFDR1 + c_DataFilterTOFDR2 + '|' + Result;
  end
  else
  begin
    if (c_DataFilter1 <> '') and (c_DataFilter2 <> '') then
      Result := c_DataFilter1 + c_DataFilter2 + '|' + Result;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the File Dialog box filter
// Inputs:       File Filter as String
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function GetDefectFileFilter(): WideString;
begin
  // Concatinate the filters :defectFilter + '|' + allFilter
  Result := c_DataFilterAll;
  if (c_DataFilterDefect <> '') then
    Result := c_DataFilterDefect + '|' + Result;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Rename the aborted file
// Inputs:       Aborted Filename
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure RenameAbortedFile(AbortFilename: String);
var
  sTimestamp: string;
  sNewFilename: string;
  sStringToInsert: string;
  nLastUnderscorePos: Integer;
begin
  sTimestamp := FormatDateTime('mmm d yyyy h n', Now());
  Fmtstr(sStringToInsert, ' aborted at %s', [sTimestamp]);

  nLastUnderscorePos := LastDelimiter('_', AbortFilename);
  if (nLastUnderscorePos >= 1) then // there is an underscore in filename
  begin
    sNewFilename := AbortFilename;
    Insert(sStringToInsert, sNewFilename, nLastUnderscorePos);
  end
  else // no underscore
    sNewFilename := ChangeFileExt(AbortFilename, '') + sStringToInsert +  ExtractFileExt(AbortFilename);

  RenameFile(AbortFilename, sNewFilename);
end;

////////////////////////////////////////////////////////////////////////////////
// RemoveInvalidCharacters
////////////////////////////////////////////////////////////////////////////////
function RemoveInvalidCharacters(Filename: String; const InvalidCharacters: String): String;
var
  nInvalidCharacterPosisition: Integer;
  sCleanFilenameName: String;
begin
  sCleanFilenameName := Filename;

  nInvalidCharacterPosisition := LastDelimiter(InvalidCharacters, sCleanFilenameName);
  while (nInvalidCharacterPosisition >= 1) do // there is an invalid character in the filename
  begin
    Delete(sCleanFilenameName, nInvalidCharacterPosisition, 1);
    nInvalidCharacterPosisition := LastDelimiter(InvalidCharacters, sCleanFilenameName);
  end;

  Result := sCleanFilenameName;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set the the File Dialog box filter index.  This will keep the
//                selected extension constant from application to application
// Inputs:       Filter as Integer
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure SetFileFilterIndex(Filter: Integer);
begin
  m_CurrentFilterIndex := Filter;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the the File Dialog box filter index.  This will keep the
//                selected extension constant from application to application
// Inputs:       None
// Outputs:      Filter as Integer
// Note:
////////////////////////////////////////////////////////////////////////////////
function GetFileFilterIndex(): Integer;
begin
  Result := m_CurrentFilterIndex;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current 'Current' directory pathname
// Inputs:       Current directory as String
// Outputs:      Returns the current directory.
// Note:
////////////////////////////////////////////////////////////////////////////////
function SetPhiCurrentDirectory(Path: String): String;
begin
  // Check for the default directory (i.e. directory has not been set)
  if (Path = c_InvalidDirectory) then
    Path := GetPhiDirectory(dirDatafiles);

  // Check for valid directory
  if (DirectoryExists(Path)) then
    m_CurrentDirectory := Path
  else
    m_CurrentDirectory := GetPhiDirectory(dirDatafiles);

  Result := m_CurrentDirectory;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set the COC file with 'directory to process'
// Inputs:       Directory as String
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure SetSmartSoftCOC(Path: String);
var
  buffer:PChar;
  cocFileHandle: Integer;
begin
  if not FileExists(c_COCFileName) then
  begin
    cocFileHandle := FileCreate(c_COCFileName);
    try
    finally
      FileClose(cocFileHandle);
    end;
  end;

  if FileExists(c_COCFileName) then
  begin
    cocFileHandle := FileOpen(c_COCFileName, fmOpenReadWrite or fmShareExclusive);
    try
      // Move to the end of the file
      FileSeek(cocFileHandle, 0, 2);

      // Write the pathname
      buffer := PChar(Path);
      FileWrite(cocFileHandle, buffer^, Length(buffer));

      // Write a newline
      buffer := #13#10;
      FileWrite(cocFileHandle, buffer^, 2);
    finally
      FileClose(cocFileHandle);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if the passed extension is a valid 'data' file extension.
// Inputs:       Extension - String
// Outputs:      None
// Note:         Extension can be full pathnames, or extensions only, but must include the leading '.'
////////////////////////////////////////////////////////////////////////////////
function ValidDataExtension(Extension: String): Boolean;
var
  fileExtension: String;
  i: Integer;
begin
  Result := False;

  // Handle complete filenames and pathnames
  fileExtension := ExtractFileExt(Extension);

  if (GetProjectName() = c_SmartSoftTOF) then
  begin
    for i:= 0 to Length(dataExtensionsTOF) - 1 do
      if (CompareText(fileExtension, dataExtensionsTOF[i]) = 0) then
        Result := True;
  end
  else if (GetProjectName() = c_TOFDR) then
  begin
    for i:= 0 to Length(dataExtensionsTOFDR) - 1 do
      if (CompareText(fileExtension, dataExtensionsTOFDR[i]) = 0) then
        Result := True;
  end
  else
  begin
    for i:= 0 to Length(dataExtensions) - 1 do
      if (CompareText(fileExtension, dataExtensions[i]) = 0) then
        Result := True;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if the passed extension is a valid 'defect' file extension.
// Inputs:       Extension - String
// Outputs:      None
// Note:         Extension can be full pathnames, or extensions only, but must include the leading '.'
////////////////////////////////////////////////////////////////////////////////
function ValidDefectExtension(Extension: String): Boolean;
var
  fileExtension: String;
  i: Integer;
begin
  Result := False;

  // Handle complete filenames and pathnames
  fileExtension := ExtractFileExt(Extension);

  for i:= 0 to Length(defectExtensions) - 1 do
    if (CompareText(fileExtension, defectExtensions[i]) = 0) then
      Result := True;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Check if the check mask is valid (and/or/not) against the primary mask
// Inputs:       PrimaryMask - Integer
//               MaskMode - TMaskMode
//               CheckMask - Integer
// Outputs:      True if check mask is valid
// Note:         When passing in multiple bits for check mask use an 'or' to combine
//                the bits.
//                e.g. MaskCheck(PrimaryMask, maskCheckAnd, (MaskBit1 or MaskBit2 or MaskBit3));
///////////////////////////////////////////////////////////////////////////////////////////////////////
function MaskCheck(PrimaryMask: Integer; MaskCheckMode: TMaskCheck; CheckMask: Integer): Boolean;
begin
  Result := True;

  // Check for valid mask
  if MaskCheckMode = maskCheckAnd then
    if (PrimaryMask and CheckMask) <> CheckMask then
      Result := False;
  if MaskCheckMode = maskCheckOr then
    if ((PrimaryMask and CheckMask) = $0) and (CheckMask <> $0) then
      Result := False;
  if MaskCheckMode = maskCheckNot then
    if ((PrimaryMask and CheckMask) <> $0) and (CheckMask <> $0) then
      Result := False;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the version number which is stored with the given
//               executable file
// Inputs:       sExecutableName - name of the interested executable
// Outputs:      None
// Return:       Version as String
////////////////////////////////////////////////////////////////////////////////
function GetExeVersion(sExecutableName: String): String;
var
  memBffrSz,
  ignored      : DWord;
  memBffr      : Pointer;
  versionInfo  : PChar;
  versionInfL  : UINT;
  versionName: String;
begin
  // Initialize the TAboutDialog controls to version information if available
  memBffrSz:= GetFileVersionInfoSize(PChar(sExecutableName), ignored);
  if memBffrSz > 0 then
    memBffr := AllocMem(memBffrSz)
  else
    memBffr := nil;

  // Get the version information
  versionName := '?.?';
  if GetFileVersionInfo(PChar(sExecutableName), ignored, memBffrSz, memBffr) then
  begin
    if VerQueryValue(memBffr, '\StringFileInfo\040904E4\FileVersion', Pointer(versionInfo),
      versionInfL) then
    begin
      versionName := versionInfo;
    end;
  end;

  if (memBffr <> nil) then
    FreeMem(memBffr, memBffrSz);

  Result := versionName;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Delete a directory and any files/folders in the directory.
// Inputs:       Dir - the directory to delete
// Outputs:      None
////////////////////////////////////////////////////////////////////////////////
procedure DeleteDirectory(const Dir: String);
var
  sDir: String;
  searchRec: TSearchRec;
begin
  sDir := IncludeTrailingPathDelimiter(Dir);
  if FindFirst(sDir + '*.*', faAnyFile, searchRec) = 0 then
  try
    repeat
      if (searchRec.Attr and faDirectory) = faDirectory then
      begin
        if (searchRec.Name <> '.') and (searchRec.Name <> '..') then
          DeleteDirectory(sDir + searchRec.Name);
      end
      else
      begin
        DeleteFile(sDir + searchRec.Name);
      end;
    until FindNext(searchRec) <> 0;
  finally
    FindClose(searchRec);
  end;
  RemoveDir(sDir);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Rename a directory.
// Inputs:       DirFrom - the old directory name
//               DirTo - the new directory name
// Outputs:      None
////////////////////////////////////////////////////////////////////////////////
procedure RenameDirectory(const DirFrom: String; const DirTo: String);
var
  shellInfo: TSHFileOpStruct;
begin
  shellInfo.Wnd    := 0;
  shellInfo.wFunc  := FO_RENAME;
  shellInfo.pFrom  := PChar(DirFrom);
  shellInfo.pTo    := PChar(DirTo);
  shellInfo.fFlags := FOF_FILESONLY or FOF_ALLOWUNDO or FOF_SILENT or FOF_NOCONFIRMATION;
  SHFileOperation(shellInfo);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Copy a directory with all of it's files and subdirectories.
// Inputs:       DirFrom - the source directory name
//               DirTo - the destination directory name
// Outputs:      None
////////////////////////////////////////////////////////////////////////////////
procedure CopyDirectory(const DirFrom: String; const DirTo: String);
var
  shellInfo: TSHFileOpStruct;
begin
  shellInfo.Wnd    := 0;
  shellInfo.wFunc  := FO_COPY;
  shellInfo.pFrom  := PChar(DirFrom);
  shellInfo.pTo    := PChar(DirTo);
  shellInfo.fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
  SHFileOperation(shellInfo);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Compare the two given version strings.   Return
//                0 if the two versions are the same
//                1 if the first version > second version
//                -1 if first version < second version
//
//               The two version strings may contain other verbiage.
//
// Inputs:       sVersion1, sVersion2: Versions to compare
// Outputs:      none
// Note:         Assumes that passed in version contains version # in format x.x.x (major.minor.build)
//               and rest of string contains no '.'
///////////////////////////////////////////////////////////////////////////////////////////////////////
function CompareVersions(sVersion1: String; sVersion2: String): Integer;
var
  version1TokenList, version2TokenList: TStrings;
  version1NumberList, version2NumberList: TStrings;  // contain major, minor, and build numbers
  delimiters, leadingWhiteSpace: TSysCharSet;
  nComparsionResult: Integer;
  nIndex, nCount: Integer;
begin
  version1TokenList := TStringList.Create;
  version2TokenList := TStringList.Create;
  version1NumberList := TStringList.Create;
  version2NumberList := TStringList.Create;

  try
    nComparsionResult := 0;

    // delimiters include 'v' or 'v' in case of V1.2.2
    delimiters := [' ', ':', '=', 'V', 'v'];

    // no leading white space to ignore
    leadingWhiteSpace := [];

    // version 1

    // create list of strings out of version string to search for
    // substring with version info
    ExtractStrings(delimiters, leadingWhiteSpace, PChar(sVersion1), version1TokenList);

    // version info will be in substring containing decimals '.'
    for nIndex := 0 to version1TokenList.Count - 1 do
    begin
      if StrScan(PChar(version1TokenList[nIndex]), '.') <> nil then
      begin
        ExtractStrings(['.'], leadingWhiteSpace, PChar(version1TokenList[nIndex]), version1NumberList);
        break;
      end;
    end;

    // version 2

    // create list of strings out of version string to search for
    // substring with version info
    ExtractStrings(delimiters, leadingWhiteSpace, PChar(sVersion2), version2TokenList);

    // version info will be in substring containing decimals '.'
    for nIndex := 0 to version2TokenList.Count - 1 do
    begin
      if StrScan(PChar(version2TokenList[nIndex]), '.') <> nil then
      begin
        ExtractStrings(['.'], leadingWhiteSpace, PChar(version2TokenList[nIndex]), version2NumberList);
        break;
      end;
    end;

   nCount := Min(version1NumberList.Count, version2NumberList.Count);
   nIndex := 0;
   nComparsionResult := 0;
   while (nIndex < nCount) and (nComparsionResult = 0) do
   begin
     if (StrToInt(version1NumberList[nIndex]) > StrToInt(version2NumberList[nIndex])) then
     begin
       nComparsionResult := 1;
     end
     else if (StrToInt(version1NumberList[nIndex]) < StrToInt(version2NumberList[nIndex])) then
     begin
       nComparsionResult := -1;
     end;

     Inc(nIndex);
   end;

  finally
    version1TokenList.Free;
    version2TokenList.Free;
    version1NumberList.Free;
    version2NumberList.Free;
  end;

  Result := nComparsionResult;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Check if the given process is running
//
// Inputs:       ProcessFilePath - filename of the EXE to check
// Outputs:      none
// Note:         True if the process is running; otherwise False
///////////////////////////////////////////////////////////////////////////////////////////////////////
function ProcessExists(ProcessFilename: string): Boolean;
var
  bContinueLoop: BOOL;
  snapshotHandle: THandle;
  processEntry32: TProcessEntry32;
begin
  snapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  processEntry32.dwSize := SizeOf(processEntry32);
  bContinueLoop := Process32First(snapshotHandle, processEntry32);
  Result := False;
  while Integer(bContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(processEntry32.szExeFile)) =
      UpperCase(ProcessFilename)) or (UpperCase(processEntry32.szExeFile) =
      UpperCase(ProcessFilename))) then
    begin
      Result := True;
    end;
    bContinueLoop := Process32Next(snapshotHandle, processEntry32);
  end;
  CloseHandle(snapshotHandle);
end;

function GetSEEDbAppInstallationDir(): String;
begin
  Result := 'C:\Program Files\Physical Electronics\SEE Database Apps';
end;

end.
