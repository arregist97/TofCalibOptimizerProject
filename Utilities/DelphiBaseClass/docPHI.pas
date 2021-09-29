unit DocPhi;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  PHIDoc.pas
// Created:   on 98-12-10 by Mark Rosen
// Purpose:   This module defines the base class for all PHI Documents.  The
//             base class TPHIDoc is derived from TObject and defines
//             functions to add and remove views from its view list and an
//             UpdateAllViews procedure to call OnUpdate() for all views.
//*********************************************************
// Copyright © 1998 Physical Electronics, Inc.
// Created in 1998 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Contnrs,
  viewPhi, ObjectPhi, SYSLOGQUEUELib_TLB, IniFiles, Registry, ExtCtrls,
  AppSettings,
  AppSettings_TLB,   
  CoMultiPakLib_TLB,
  Parameter,
  ParameterAutoTool,
  ParameterBoolean,
  ParameterSelectData,
  ParameterString;

const
  c_MaskEmpty = $00000000;

  c_Default = 'DEFAULT';

  c_PropertyName = 'Properties' ;
  c_ParameterMissing = 'ParameterIsMissing';
  c_OnUdateDefaultIntervalInMs = 10;
  c_InvalidFileCharacters = '/\:*?<>|';

  c_SaveSetting_AlwaysPrompt = 'Prompt User when Settings Change';
  c_SaveSetting_NeverPromptSave = 'Don''t Prompt - Save Changes';
  c_SaveSetting_NeverPrompt = 'Don''t Prompt - Don''t Save Changes';

  c_OnUpdateAll = 0;

  c_docHighlight_None = 'None';
  c_docHighlight_Properties = 'Properties';
  c_docHighlight_Settings = 'Settings';
  c_docHighlight_History = 'History';
  c_docHighlight_Polarity = 'Polarity';
  c_docHighlight_Wobble = 'Wobble';
  c_docHighlight_Outgas = 'Outgas';
  c_docHighlight_Tune = 'Tune';
  c_docHighlight_All = 'All';

type
  TMaskMode = (maskModeNone,
                maskModeSet,
                maskModeInclude,
                maskModeExclude);

  TChangedMode = (changedModeSettings,
                  changedModeProperties,
                  changedModeSettingsAndProperties);

  TPreAcquireStatus = (ePreAcquireNone, ePreAcquireSkip);

  TAcqObjectInfo = record
    AcqType: String;
    SourceType: String;
    AreaNumber: Integer;
  end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// TPhiDoc
///////////////////////////////////////////////////////////////////////////////////////////////////////
  TPhiDoc = class(TDataModule)
  private
    m_AcqFileSectionName: String;
    m_CurrentSetting: String;
    m_CategoryList: TParameterString;
    m_TempSetting: String;
    m_FileDirectory: String;
    m_FileExtensionSetting: String;
    m_LocalMask: Integer;
    m_ModalDialogTimer: TTimer;
    m_ModalDialogDialogType: TDialogType;
    m_ModalDialogStrMsg: string;
    m_Parameter: TParameter;
    m_ParameterList: TList; // list of parameters that are registered with this document
    m_HardwareParameterList: TList;
    m_PhiObject: TPhiObject; // PhiObject (logging, error messages, ...)
    m_ReservedList: TStringList; // list of reserved setting names
    m_SettingList: TStringList; // list of setting names associated to this application
    m_SystemLevel: TUserLevel;
    m_SystemMask: Integer;
    m_SystemMaskChanged: TNotifyEvent;
    m_UpdateAllViewsTimer: TTimer;
    m_UpdateAllViewsHint: Integer;
    m_UpdateAllViewsPreviousTickTime: DWORD;
    m_UpdateEnable: Boolean;
    m_UsesRegistry: Boolean;
    m_UsesProperties: Boolean;
    m_UsesSettings: Boolean;
    m_UsesReservedList: Boolean;
    m_ValidateChangesPrompt: TParameterSelectData;
    m_ViewList: TList; // list of views that are registered with this document

    function GetDocName: string;
    procedure SetDocName(strName: string);

    function GetAcqFileSectionName: string;
  protected
    // Wait Cursor
    m_CursorNormal: TCursor;
    m_CursorWait: TCursor;

    // Queue Editor
    m_IsQueueEditor: Boolean;
    m_QueueFilename: TParameterString;
    m_QueueSection: TParameterString;

    procedure ReadFileParameters(AppSettings: IAppSettings);
    procedure ReadRegistryParameters() ;
    procedure ReadPropertyParameters() ;
    procedure ReadSettingParameters(FileName: String); overload;
    procedure ReadSettingParameters(FileName: String; Section: String); overload;
    procedure ReadSettingParameters(FileName: String; Section: String; Parameter: TParameter); overload;
    procedure ReadSectionParameters(FileName: String; Section: String); overload;
    procedure WriteFileParameters(AppSettings: IAppSettings); overload;
    procedure WriteFileParameters(AppSettings: TAppSettings); overload;
    procedure WriteRegistryParameters();
    procedure WritePropertyParameters(Filename: String; bAppend: Boolean=False); overload;
    procedure WritePropertyParameters(Filename: String; Section: String; bAppend: Boolean=False); overload;
    procedure WriteSettingParameters(Filename: String; bAppend: Boolean=False); overload;
    procedure WriteSettingParameters(Filename: String; Section: String; bAppend: Boolean=False); overload;
    procedure WriteSettingParameters(Filename: String; Section: String; Parameter: TParameter; bAppend: Boolean=False); overload;
    procedure WriteSettingParametersSafe(Filename: String; Section: String; bAppend: Boolean=False); overload;
    procedure WriteSettingParametersSafe(Filename: String; Section: String; Parameter: TParameter; bAppend: Boolean=False); overload;
    procedure WriteSectionParameters(Filename: String; Section: String; bAppend: Boolean=False); overload;
    procedure WriteSectionParametersSafe(Filename: String; Section: String; bAppend: Boolean=False); overload;

    procedure CopySettingParameters(FromFileName: String; ToFileName: String; Overwrite: Boolean) ;
    procedure UpdateAllViewsTimer(Sender: TObject);
    procedure ModalDialogTimer(Sender: TObject);
  public
    constructor Create(AOwner : TComponent); overload; override;
    constructor Create(AOwner : TComponent; DocName : string); reintroduce; overload; virtual;
    destructor  Destroy() ; override ;

    procedure Initialize(); virtual;
    procedure DeInitialize(); virtual;
    function PreAcquire_Init(AcqType: String; MoreFlag: Boolean; var Status: TPreAcquireStatus): Boolean; virtual;
    function PreAcquire_CleanUp(AcqType: String; MoreFlag: Boolean): Boolean; virtual;
    function PreAcquire(AcqType: String; MoreFlag: Boolean = False): Boolean; overload; virtual;
    function PreAcquire(AcqType: String; MoreFlag: Boolean; var Status: TPreAcquireStatus): Boolean; overload; virtual;
    function PreAcquire2(AcqType: String; MoreFlag: Boolean = False): Boolean; overload; virtual;
    function PreAcquire2(AcqType: String; MoreFlag: Boolean; var Status: TPreAcquireStatus): Boolean; overload; virtual;
    function PreShutdown(): Boolean; virtual;
    function Validate(PreCheck: Boolean): Boolean; virtual;

    procedure AddView(View: TphiView) ;
    procedure RemoveView(View: TphiView) ;
    procedure UpdateAllViews(Hint: Integer); overload; virtual;
    procedure UpdateAllViews(Hint: Integer; TimerFlag: Boolean; Interval: Integer = c_OnUdateDefaultIntervalInMs); overload;

    // Dialogs
    function ModalDialog(DialogType: TDialogType; Buttons: TDialogButtons; strMsg: string): TDialogResult; overload;
    function ModalDialog(DialogType: TDialogType; Buttons: TDialogButtons; strMsg: string; TimerFlag: Boolean): TDialogResult; overload;
    function ModelessDialog(DialogType: TDialogType; strMsg: string): TForm;
    function ModelessWaitDialog(strMsg: string): TForm;

    function MessageDialog(DialogType : TDialogType; Buttons : TDialogButtons;
                      strMsg : string) : TDialogResult ;
    function MessageDialogCreate(DialogType: TDialogType; Buttons: TDialogButtons;
                     strMsg: string): TForm;
    function MessageDialogShow(Dialog: TForm): TDialogResult;
    procedure MessageDialogClose(Dialog: TForm; CloseResult: TDialogResult);

    // Error Logging
    procedure ErrorLog(Level: TErrorLevel; Code: HResult; strMsg: string); overload;
    procedure ErrorLog(Level: TErrorLevel; Code: HResult; strMsg: string; Args: array of const); overload;
    function  ErrorLog(Level : TErrorLevel; Code : HResult; Reported : boolean;
                      PrevError : TPHIResult; Msg : string): TPHIResult; overload;
    procedure TraceLog(Level : TTraceLevel; Msg: string); overload;
    procedure TraceLog(Level : TTraceLevel; Msg: string; Value: Double); overload;
    procedure TraceLog(Level : TTraceLevel; Msg: string; Value: String); overload;
    procedure TraceLog(Level : TTraceLevel; Msg: string; Value: Boolean); overload;
    procedure TraceLog(Level: TTraceLevel; strMsg: string; Args: array of const); overload;

    function  GetTraceLevel : TTraceLevel ;
    procedure SetTraceLevel(Level : TTraceLevel) ;
    function  GetErrorLevel : TErrorLevel ;
    procedure SetErrorLevel(Level : TErrorLevel) ;

    // Parameters
    procedure AddParameter(Parameter: TParameter); overload;
    procedure AddParameter(Container: TObjectList); overload;
    procedure RemoveParameter(Parameter: TParameter) ;
    procedure ClearParameter();
    procedure SaveInit();
    procedure SaveUndo();
    procedure Undo() ;

    // Hardware Parameters
    procedure AddHardwareParameter(HardwareParameter: TParameter); overload;
    procedure RemoveHardwareParameter(HardwareParameter: TParameter);
    procedure ClearHardwareParameter;   
    procedure WriteHardwareParameters(FileName: String); virtual;

    // Settings, Properties, and Forms
    function DeleteSetting(SettingName: String; NotifyUser: Boolean): Boolean;
    function GetSettingList(): TStringList;
    function GetCurrentSetting(): String;
    procedure SetCurrentSetting(SettingName: String);
    procedure InitializeSettings(); overload;
    procedure InitializeSettings(SettingName: String); overload;
    function LoadFile(FilePath: String; NotifyUser: Boolean = True): Boolean; virtual;
    function LoadAcq(FilePath: String): Boolean;
    function LoadForm(FileName: String; Instance: TComponent): Boolean;
    function LoadTemp(): Boolean; overload;
    function LoadSetting(SettingName: String; NotifyUser: Boolean): Boolean; overload;
    function LoadSetting(FilePath: String): Boolean; overload;
    function LoadSection(Filename: String; Section: String; NotifyUser: Boolean): Boolean; overload;
    function LoadSection(Filename: String; Section: String; Parameter: TParameter; NotifyUser: Boolean): Boolean; overload;
    function LoadParameter(Filename: String; Section: String; Parameter: TParameter): Boolean;

    procedure SaveAcqObject(AppSettings: IAppSettings; AcqObjectInfo: TAcqObjectInfo); overload; virtual;
    procedure SaveAcqObject(AppSettings: IAppSettings); overload; virtual;
    procedure SaveAcqObject(AppSettings: TAppSettings); overload; virtual;
    procedure SaveForm(FileName: String; Instance: TComponent);
    function SaveSetting(SettingName: String; NotifyUser: Boolean): Boolean; overload; virtual;
    function SaveSection(Filename: String; Section: String; FastWrite: Boolean = True): Boolean; overload; virtual;
    function SaveSectionSafe(Filename: String; Section: String; Append: Boolean = False): Boolean; overload; virtual;
    function SaveSectionSafe(Filename: String; Section: String; Parameter: TParameter; Append: Boolean = False): Boolean; overload; virtual;
    function SaveParameter(Filename: String; Section: String; Tag: String; Parameter: TParameter): Boolean; overload; virtual;

    procedure SaveParameter(Sender: TObject); overload;
    function IsValidSection(Filename: String; Section: String): Boolean;
    function CopySection(FromFilename: String; ToFilename: String; Section: String): Boolean; overload; virtual;
    function CopySection(FromFilename: String; ToFilename: String; FromSection: String; ToSection: String): Boolean; overload; virtual;
    function CopySection(var FromIniFile: TMemIniFile; var ToIniFile: TIniFile; Section: String): Boolean; overload; virtual;
    procedure SaveTemp();
    procedure SavePrevious(); overload; virtual;
    procedure SaveAll(Filename: String); virtual;
    function CopySetting(FromSetting: String; ToSetting: String; Overwrite: Boolean): Boolean; virtual;
    function ValidRegistry(RegistryKey: String): Boolean;
    function ValidSetting(FileName: String; SectionName: String = c_InvalidString): Boolean;
    function GetFormFilename(FileName: String): String;
    function GetRegistryFilename(): String ;
    function GetReservedFilename(): String;
    function GetPropertyFilename(Filename: String = ''): String ;
    function GetSettingFilename(Filename: String = ''): String;
    function GetSectionName(SectionPrefix: String = ''): String;
    function GetSettingsDirectory(): string; virtual;
    function ValidateChanges(): Boolean;
    function ParameterChanged(changedMode: TChangedMode = changedModeSettings): Boolean;

    procedure ReadCaptionParameters(Filename: String);
    procedure ReadHintParameters(Filename: String);
    function ReadParameter(Filename: String; Tag: String): String; overload; virtual;
    function ReadParameter(Filename: String; Parameter: TParameter): String; overload; virtual;
    function ReadParameter(Filename: String; Section: String; Tag: String): String; overload; virtual;

    function ReadParameterAsFloat(Filename: String; Tag: String): Double; overload; virtual;
    function ReadParameterAsFloat(Filename: String; Parameter: TParameter): Double; overload; virtual;
    function ReadParameterAsFloat(Filename: String; Section: String; Tag: String): Double; overload; virtual;

    function ReadProperty(Tag: String): String; overload; virtual;
    function ReadProperty(Parameter: TParameter): String; overload; virtual;
    function ReadProperty(Section: String; Tag: String): String; overload; virtual;

    procedure WriteCaptionParameters(Filename: String);
    procedure WriteHintParameters(Filename: String);
    procedure WriteParameter(Filename: String; Tag: String; Value: String); overload;
    procedure WriteParameter(Filename: String; Parameter: TParameter; Value: String); overload;
    procedure WriteParameter(Filename: String; Section: String; Tag: String; Value: String); overload;
    procedure WriteParameter(Filename: String; Section: String; Tag: String; Parameter: TParameter); overload;

    procedure AddReserved(SettingName: String);
    procedure DeleteReserved(SettingName: String);
    function IsReserved(SettingName: String): Boolean;
    property ReservedList: TStringList read m_ReservedList;

    procedure SetSystemLevel(SystemLevel: TUserLevel); virtual;
    property SystemLevel: TUserLevel read m_SystemLevel;

    procedure SetMask(var MaskInOut: Integer; MaskMode: TMaskMode; MaskChange: Integer);

    procedure SetLocalMask(MaskMode: TMaskMode; Mask: Integer);
    property LocalMask: Integer read m_LocalMask;

    procedure SetSystemMask(MaskMode: TMaskMode; Mask: Integer); virtual;
    property SystemMask: Integer read m_SystemMask write m_SystemMask;

    procedure SetSystemMaskChanged(Mask: Integer); virtual;
    property SystemMaskChanged: TNotifyEvent read m_SystemMaskChanged write m_SystemMaskChanged;

    procedure Highlight(HightlightType: String; UpdateUI: Boolean = True); virtual;

    property ValidateChangesPrompt: TParameterSelectData read m_ValidateChangesPrompt;

    property AcqFileSectionName: String read GetAcqFileSectionName write m_AcqFileSectionName;
    property CategoryList: TParameterString read m_CategoryList;
    property DocName: string read GetDocName write SetDocName;
    property FileDirectory: String read m_FileDirectory write m_FileDirectory;
    property FileExtensionSetting: String read m_FileExtensionSetting write m_FileExtensionSetting;
    property Parameter: TParameter read m_Parameter;
    property PhiObject: TPhiObject read m_PhiObject;
    property UpdateEnable: Boolean read m_UpdateEnable write m_UpdateEnable;
    property UsesRegistry: Boolean read m_UsesRegistry write m_UsesRegistry;
    property UsesProperties: Boolean read m_UsesProperties write m_UsesProperties;
    property UsesSettings: Boolean read m_UsesSettings write m_UsesSettings;
    property UsesReservedList: Boolean read m_UsesReservedList write m_UsesReservedList;
    property Parameters: TList read m_ParameterList;
    property HardwareParameters: TList read m_HardwareParameterList;

    // Queue Editor
    property IsQueueEditor: Boolean read m_IsQueueEditor;
    property QueueFilename: TParameterString read m_QueueFilename;
    property QueueSection: TParameterString read m_QueueSection;
  end;

var
  PhiDoc: TPhiDoc;
  g_IsQueueEditor: Boolean = False;

implementation

{$R *.DFM}

uses
  System.Types,
  FileCtrl,
  MMSystem,
  AppDefinitions,
  PhiUtils,
  PhiFileOpen;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor that should not be called.
//                User should call constructor with 2 args.
// Inputs:       AOwner - parent component
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TPhiDoc.Create(AOwner: TComponent);
begin
  Create(AOwner, '');

  ErrorLog(errorCritical, E_FAIL, True, 0,
    'The wrong version of Create is called without DocName. This may result in Views not updated correctly.');
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor that should not be called.
//                User should call constructor with 2 args.
// Inputs:       AOwner - parent component
//               DocName -- document name
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TPhiDoc.Create(AOwner: TComponent; DocName : string);
begin
  inherited Create(AOwner) ;

  // Set doc name
  if DocName = '' then
    DocName := Name;

  // Set queue editor flag
  m_IsQueueEditor := g_IsQueueEditor;
  g_IsQueueEditor := False;

  // instantiate PhiObject (EnableLogging = True)
  m_PhiObject := TPhiObject.Create(DocName, True);

  // Initialize list of views
  m_ViewList := TList.Create();
  m_ViewList.Clear();

  // Initialize list of parameters
  m_ParameterList := TList.Create();
  m_ParameterList.Clear();

  // Initialize the list of hardware parameters.
  m_HardwareParameterList := TList.Create();
  m_HardwareParameterList.Clear();

  // Add a default parameter, used to update ui compon
  m_Parameter := TParameter.Create(Self);
  m_Parameter.Name := DocName;
  m_Parameter.Caption := DocName;
  m_Parameter.Hint := DocName;
  m_ParameterList.Add(m_Parameter);

  m_ValidateChangesPrompt := TParameterSelectData.Create(Self) ;
  m_ValidateChangesPrompt.Name := 'Setting Change' ;
  m_ValidateChangesPrompt.AddValue(c_SaveSetting_AlwaysPrompt);
  m_ValidateChangesPrompt.AddValue(c_SaveSetting_NeverPrompt);
  m_ValidateChangesPrompt.AddValue(c_SaveSetting_NeverPromptSave);
  m_ValidateChangesPrompt.Value:= c_SaveSetting_AlwaysPrompt;
  m_ValidateChangesPrompt.ParameterType := ptProperties;
  AddParameter(m_ValidateChangesPrompt) ;

  m_QueueFilename := TParameterString.Create(Self);
  m_QueueFilename.Name:= 'Queue Filename';
  m_QueueFilename.Caption:= 'Filename';
  m_QueueFilename.Hint:= 'Queue Filename';
  m_QueueFilename.Value := '';
  AddParameter(m_QueueFilename) ;

  m_QueueSection := TParameterString.Create(Self);
  m_QueueSection.Name:= 'Queue Section';
  m_QueueSection.Caption:= 'Section';
  m_QueueSection.Hint:= 'Queue Section';
  m_QueueSection.Value := '';
  m_QueueSection.ReadOnly := True;
  AddParameter(m_QueueSection) ;

  m_ReservedList := TStringList.Create();
  m_ReservedList.Add(c_Previous);
  m_ReservedList.Add(c_Default);

  m_CategoryList := TParameterString.Create(Self);
  m_CategoryList.Name := 'Category List';
  m_CategoryList.Value := '';
  m_CategoryList.ParameterType := ptProperties;
  AddParameter(m_CategoryList);

  // Initialize list of setting names
  m_AcqFileSectionName := c_InvalidString;
  m_SettingList := TStringList.Create();
  m_CurrentSetting := '';
  m_FileDirectory := GetSettingsDirectory();
  m_FileExtensionSetting := c_SettingFileExt;

  // Initialize member variables
  m_LocalMask := c_DefaultMask;
  m_UsesRegistry := False;
  m_UsesProperties := False;
  m_UsesSettings := False;
  m_UsesReservedList := False;

  m_UpdateEnable := True;
  m_SystemLevel:= ulOpen;
  m_SystemMask:= c_DefaultMask;
  m_SystemMaskChanged := nil;

  m_ModalDialogTimer := TTimer.Create(Self);
  m_ModalDialogTimer.Enabled := False;
  m_ModalDialogTimer.Interval := 1;
  m_ModalDialogTimer.OnTimer := ModalDialogTimer;
  m_ModalDialogDialogType := infoDialog;
  m_ModalDialogStrMsg := '';

  m_UpdateAllViewsTimer := TTimer.Create(Self);
  m_UpdateAllviewsTimer.Enabled := False;
  m_UpdateAllViewsTimer.Interval := 1;
  m_UpdateAllViewsTimer.OnTimer := UpdateAllViewsTimer;

  m_UpdateAllViewsHint := 0;
  m_UpdateAllViewsPreviousTickTime := 0;

  m_CursorNormal := crDefault;
  m_CursorWait := crHourGlass;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TPhiDoc.Destroy();
begin
  // Cleanup after member variables
  m_ViewList.Free();
  m_ViewList := nil;

  m_ParameterList.Free();
  m_ParameterList := nil;

  m_HardwareParameterList.Free();
  m_HardwareParameterList := nil;

  m_ReservedList.Free();
  m_ReservedList := nil;

  m_SettingList.Free();
  m_SettingList := nil;

  // clean up PhiObject
  m_PhiObject.Free();
  m_PhiObject := nil;

  inherited Destroy();
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Initialize
// Inputs:      None
// Outputs:     None
// Note:        Initialize supports processing during startup, after this doc,
//                and all other docs, are created.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.Initialize;
begin
  // Implement in derived class
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: DeInitialize
// Inputs:      None
// Outputs:     None
// Note:        DeInitialize supports processing during shutdown, before this doc,
//               or all other docs, are destroyed.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.DeInitialize;
begin
  // disable timers
  m_ModalDialogTimer.Enabled := False;
  m_UpdateAllViewsTimer.Enabled := False;

  // Save 'Previous' Settings and Properties
  SavePrevious();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Allow application to check itself for valid acquisition parameters.
// Inputs:       AcqType - Integer (AcqType)
// Outputs:      None
// Return:       True: if acquisition is valid
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.PreAcquire(AcqType: String; MoreFlag: Boolean): Boolean;
begin
  // Implement in derived class
  Result := True;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Allow application to check itself for valid acquisition parameters.
// Inputs:       AcqType - Integer (AcqType)
// Outputs:      Status - Preacquire Status
// Return:       True: if acquisition is valid
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.PreAcquire(AcqType: String; MoreFlag: Boolean; var Status: TPreAcquireStatus): Boolean;
begin
  // Implement in derived class
  Result := PreAcquire(AcqType, MoreFlag);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Allow application to check itself for valid acquisition parameters.
// Inputs:       AcqType - Integer (AcqType)
// Outputs:      None
// Return:       True: if acquisition is valid
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.PreAcquire2(AcqType: String; MoreFlag: Boolean): Boolean;
begin
  // Implement in derived class
  Result := True;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Allow application to check itself for valid acquisition parameters.
// Inputs:       AcqType - Integer (AcqType)
// Outputs:      Status - Preacquire Status
// Return:       True: if acquisition is valid
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.PreAcquire2(AcqType: String; MoreFlag: Boolean; var Status: TPreAcquireStatus): Boolean;
begin
  Status := ePreAcquireNone;

  Result := PreAcquire2(AcqType, MoreFlag);
end;

function TPhiDoc.PreAcquire_Init(AcqType: String; MoreFlag: Boolean; var Status: TPreAcquireStatus): Boolean;
begin
  Result := True;
end;

function TPhiDoc.PreAcquire_CleanUp(AcqType: String; MoreFlag: Boolean): Boolean;
begin
  Result := True;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Allow application to check itself for valid shutdown.
// Inputs:       None
// Outputs:      None
// Return:       True - if okay to shut down; False - not okay to shutdown
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.PreShutdown(): Boolean;
begin
  // Implement in derived class
  Result := True;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Perform validation
// Inputs:       PreCheck - pre-validation or run-time check?
// Outputs:      None
// Return:       True - if valid; otherwise False
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.Validate(PreCheck: Boolean): Boolean;
begin
  // Implement in derived class
  Result := True;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add specified view to this document's update list.
// Inputs:       View - view to add to update list
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.AddView(View: TPhiView) ;
begin
  // Add view to list
  if assigned(m_ViewList) then
    m_ViewList.Add(View) ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Remove specified view from this document's update list.
// Inputs:       View - view to add to update list
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.RemoveView(View: TPhiView) ;
begin
  // Remove view from list (only if it is in the list)
  if assigned(m_ViewList) then
    m_ViewList.Remove(View) ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Tell all views in the view list to update themselves.
// Inputs:       Hint - enum defined in the derived document class (derived from TPHIDoc)
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.UpdateAllViews(Hint : integer) ;
var
  Index : longint ;    // Index for looping through Views in the ViewList
  Item : TPHIView ;    // Temporary View pointer
begin
  // Check if updates are enabled
  if (not m_UpdateEnable) then
    Exit;

  // Call OnUpdate(Hint) for all views in the view list
  for Index := 1 to m_ViewList.Count do
  begin
    Item := m_ViewList.Items[Index-1] ;

    // Set 'OnUpdateChange' flag to show that view is in the midst of being updated
    Item.OnUpdateChange := True ;

    // Need a try/finally block to ensure that the flag is reset even if error
    try
      // Update the view
      Item.OnUpdate(Hint) ;
      Item.OnUpdate(DocName, Hint) ;
    finally
      // Clear the 'OnUpdateChange' flag
      Item.OnUpdateChange := False ;
    end;

  end ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Tell all views in the view list to update themselves.
// Inputs:       Hint - enum defined in the derived document class (derived from TPHIDoc)
//               TimerFlag - Boolean (flags if timer should be used update views, or if a direct call is made to each view)
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.UpdateAllViews(Hint: Integer; TimerFlag: Boolean; Interval: Integer);
begin
  // Check if using a timer (timers are used to when processing must continue immediatly i.e. events)
  if (TimerFlag) then
  begin
    m_UpdateAllViewsHint := Hint;
    m_UpdateAllViewsTimer.Interval := Interval;
    m_UpdateAllViewsTimer.Enabled := True;
  end
  else
  begin
    UpdateAllViews(Hint);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Tell all views in the view list to update themselves.
// Inputs:       Hint - enum defined in the derived document class (derived from TPHIDoc)
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.UpdateAllViewsTimer(Sender: TObject);
var
  currentTickTime: DWORD;
  tickTimeDifference: Cardinal;
begin
  // Check the time between the last handled timer event and this timer 'tick'
  // skip handling if this interval is less than the timer's interval to prevent
  // handling multiple queued up timer events that can occur when GUI thread is
  // blocked to ensure one handler event per expected interval.
  currentTickTime := timeGetTime();
  tickTimeDifference := Round(Abs(currentTickTime - m_UpdateAllViewsPreviousTickTime));
  if (tickTimeDifference >= (m_UpdateAllViewsTimer.Interval)) then
  begin
    if (m_UpdateAllViewsTimer.Enabled) then
    begin
      // Disable and Re-Enable timer in handler to avoid timer ticks
      // while processing timer event handler.  Should be safe since
      // only single GUI thread enabling and disabling timer.
      m_UpdateAllViewsTimer.Enabled := False;
      m_UpdateAllViewsTimer.Interval := c_OnUdateDefaultIntervalInMs;

      // Call the OnTimer callback.
      UpdateAllViews(m_UpdateAllViewsHint);

      // Update timer handled time after doing work in case the work done may take
      // longer than timer interval itself.  We want to skip the queued timer
      // events which occured during this time.
      m_UpdateAllViewsPreviousTickTime := timeGetTime();
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add Parameter to the list of Parameters associated to this view.
// Inputs:       Parameter as TParameter
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.AddParameter(Parameter : TParameter) ;
begin
  // Add the Parameter to list of Parameters
  if assigned(Parameter) and
    not ((m_IsQueueEditor = True) and (Parameter is TParameterAutoTool)) then
  begin
    // Set the system level for all newly added parameter, otherwise it will be out of sync
    Parameter.SystemLevel := m_SystemLevel;

    // Add a reference to the Doc
    Parameter.ParentDocPtr := Self;
    if (assigned(Parameter.History)) then
      Parameter.History.ParentDocPtr := Self;
    if (assigned(Parameter.Readback)) then
    begin
      Parameter.Readback.ParentDocPtr := Self;

      if (assigned(Parameter.Readback.History)) then
        Parameter.Readback.History.ParentDocPtr := Self;
    end;

    // Set the system level for all newly added parameter
    m_ParameterList.Add(Parameter) ;
  end ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add Parameter to the list of Parameters associated to this view.
// Inputs:       Parameter as TParameter
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.AddParameter(Container: TObjectList) ;
var
  index: Integer ;
  parameter: TParameter;
begin
  if assigned(Container) then
  begin
    for index := 0 to Container.Count - 1 do
    begin
      parameter := TParameter(Container.Items[index]);

      // Add a reference to the Doc
      parameter.ParentDocPtr := Self;
      if (assigned(parameter.History)) then
        parameter.History.ParentDocPtr := Self;
      if (assigned(Parameter.Readback)) and (assigned(Parameter.Readback.History)) then
        Parameter.Readback.History.ParentDocPtr := Self;

      AddParameter(parameter);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Remove a Parameter from the list of Parameters associated to this view.
// Inputs:       Parameter as TParameter
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.RemoveParameter(Parameter : TParameter) ;
begin
  // Remove the Parameter if it is in the list, otherwise do nothing
  m_ParameterList.Remove(Parameter) ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Clear Parameter List
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ClearParameter();
begin
  // Clear parameter list
  m_ParameterList.Clear();
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Check for, and and allow the user to save, any unsaved changed
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ValidateChanges(): Boolean;
var
  confirm: TDialogResult;
begin
  Result := True;

  if (ParameterChanged()) then
  begin
    if m_ValidateChangesPrompt.Value = c_SaveSetting_NeverPrompt then
      confirm := noResult
    else if m_ValidateChangesPrompt.Value = c_SaveSetting_NeverPromptSave then
      confirm := yesResult
    else
      confirm := MessageDialog(warningDialog, yesNoCancel, 'Do you want to save the changes you made to ''' + m_CurrentSetting + '''.');

    if (confirm = yesResult) then
      SaveSetting(m_CurrentSetting, False)
    else if (confirm = cancelResult) then
      Result := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Check for, and and allow the user to save, any unsaved changed
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ParameterChanged(changedMode: TChangedMode): Boolean;
var
  index: integer ;
  item: TParameter ;
  hasParametersChanged: Boolean;
begin
  // Check for unsaved changed
  hasParametersChanged := False;
  index := 1;
  while ((index <= m_ParameterList.Count) and (not hasParametersChanged)) do
  begin
    item := m_ParameterList.Items[index-1] ;

    // Check for changes in settings, properties, or both
    if (changedMode = changedModeSettings) then
    begin
      if (item.ParameterType = ptSettings) or (item.ParameterType = ptSettingsWriteOnly) then
        hasParametersChanged := item.Changed;
    end
    else if (changedMode = changedModeProperties) then
    begin
      if (item.ParameterType = ptProperties) or (item.ParameterType = ptPropertiesWriteOnly) then
        hasParametersChanged := item.Changed;
    end
    else if (changedMode = changedModeSettingsAndProperties) then
    begin
      if (item.ParameterType = ptSettings) or (item.ParameterType = ptSettingsWriteOnly) or
        (item.ParameterType = ptProperties) or (item.ParameterType = ptPropertiesWriteOnly) then
        hasParametersChanged := item.Changed;
    end;

    index := index + 1;
  end;

  if hasParametersChanged then
    Result := True
  else
    Result := False;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Save the 'InitValues' for all Parameters registered to this Doc
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SaveInit() ;
var
  Index: integer ;
  Item: TParameter ;
begin
  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.SaveInit ;
  end ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Save the 'UndoValues' for all Parameters registered to this Doc
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SaveUndo() ;
var
  Index: integer ;
  Item: TParameter ;
begin
  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.SaveUndo ;
  end ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Restore the Undo values for all Parameters registered to this Doc
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.Undo() ;
var
  Index: integer ;
  Item: TParameter ;
begin
  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Undo ;
  end ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Create a 'Modal' Dialog
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ModalDialog(DialogType: TDialogType; Buttons: TDialogButtons;
  strMsg: string): TDialogResult;
begin
  // Delegate to PhiObject
  Result := m_PhiObject.ModalDialog(DialogType, Buttons, strMsg) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Tell all views in the view list to update themselves.
// Inputs:       Hint - enum defined in the derived document class (derived from TPHIDoc)
//               TimerFlag - Boolean (flags if timer should be used update views, or if a direct call is made to each view)
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ModalDialog(DialogType: TDialogType; Buttons: TDialogButtons;
  strMsg: string; TimerFlag: Boolean): TDialogResult;
begin
  // Check if using a timer (timers are used to when processing must continue immediatly i.e. events)
  if (TimerFlag) then
  begin
    m_ModalDialogDialogType := DialogType;
    m_ModalDialogStrMsg := strMsg;
    m_ModalDialogTimer.Enabled := True;
    Result := okResult;
  end
  else
  begin
    Result := ModalDialog(DialogType, Buttons, strMsg);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Tell all views in the view list to update themselves.
// Inputs:       Hint - enum defined in the derived document class (derived from TPHIDoc)
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ModalDialogTimer(Sender: TObject);
begin
  // Disable timer
  m_ModalDialogTimer.Enabled := False;

  // Update all views
  ModalDialog(m_ModalDialogDialogType, ok, m_ModalDialogStrMsg);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Create a 'Modeless' Dialog
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ModelessDialog(DialogType : TDialogType; strMsg : string): TForm;
begin
  // Delegate to PhiObject
  Result := m_PhiObject.ModelessDialog(DialogType, strMsg) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Create a 'Modeless' Dialog with 'Please wait...' title and no buttons.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ModelessWaitDialog(strMsg : string): TForm;
begin
  // Delegate to PhiObject
  Result := m_PhiObject.ModelessWaitDialog(strMsg) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Message Dialog
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.MessageDialog(DialogType : TDialogType; Buttons : TDialogButtons;
  strMsg : string) : TDialogResult ;
begin
  // Delegate to PhiObject
  Result := m_PhiObject.MessageDialog(DialogType, Buttons, strMsg) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Message Dialog Create
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.MessageDialogCreate(DialogType: TDialogType; Buttons: TDialogButtons;
                       strMsg: string): TForm;
begin
  // Delegate to PhiObject
  Result := m_PhiObject.MessageDialogCreate(DialogType, Buttons, strMsg) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Message Dialog Show
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.MessageDialogShow(Dialog: TForm): TDialogResult;
begin
  // Delegate to PhiObject
  Result := m_PhiObject.MessageDialogShow(Dialog) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Message Dialog Close
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.MessageDialogClose(Dialog: TForm; CloseResult: TDialogResult);
begin
  // Delegate to PhiObject
  m_PhiObject.MessageDialogClose(Dialog, CloseResult) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write error message to the system error log.
// Inputs:       Level - error level for this error message
//               Code - HResult for this error
//               Reported - TRUE/FALSE if this error has been reported to the user  (not used)
//               PrevError - previous error PHIResult  (not used)
//               Msg - error message to log
// Return:       PHIResult - PHIResult for this error to be used in subsequent ErrorLog calls relating
//                to this error (not used any more)
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ErrorLog(Level: TErrorLevel; Code: HResult;
  Reported: boolean; PrevError: TPHIResult; Msg: string): TPHIResult;
begin
   // Delegate to PhiObject
   Result := m_PhiObject.ErrorLog(Level, Code, Reported, PrevError, Msg) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write error message to the system error log.
// Inputs:       Level - error level for this error message
//               Code - HResult for this error
//               Msg - error message to log
// Return:       None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ErrorLog(Level: TErrorLevel; Code: HResult; strMsg: string);
begin
  m_PhiObject.ErrorLog(Level, Code, strMsg);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write error message to the system error log.
// Inputs:       Level - error level for this error message
//               Code - HResult for this error
//               Msg - error message to log
//               Args - formats the message in the same way as
//                 Format(strMsg,[]) see delphi help 'Format' for details.
// Return:       None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ErrorLog(Level: TErrorLevel; Code: HResult; strMsg: string;
  Args: array of const);
begin
  m_PhiObject.ErrorLog(Level, Code, strMsg, Args);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write trace message to system error log.
// Inputs:       Level - trace logging level
//               Msg - message to write to trace log
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.TraceLog(Level: TTraceLevel; Msg: string);
begin
  // Delegate to PhiObject
  m_PhiObject.TraceLog(Level, Msg) ;
end;

procedure TPhiDoc.TraceLog(Level: TTraceLevel; Msg: string; Value: Double);
begin
  // delegate to PhiObject
  m_PhiObject.TraceLog(Level, Msg + ': ' + FloatToStr(Value)) ;
end;

procedure TPhiDoc.TraceLog(Level: TTraceLevel; Msg: string; Value: String);
begin
  // delegate to PhiObject
  m_PhiObject.TraceLog(Level, Msg + ': ' + Value) ;
end;

procedure TPhiDoc.TraceLog(Level: TTraceLevel; Msg: string; Value: Boolean);
begin
  // delegate to PhiObject
  m_PhiObject.TraceLog(Level, Msg + ': ' + BoolToStr(Value, True)) ;
end;

procedure TPhiDoc.TraceLog(Level: TTraceLevel; strMsg: string; Args: array of const);
begin
  m_PhiObject.TraceLog(Level, strMsg, Args);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get current Error Logging Level.
// Inputs:       None
// Return:       Current Error logging level
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetErrorLevel: TErrorLevel;
begin
  // Delegate to PhiObject
  Result := m_PhiObject.GetErrorLevel ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set error logging level for this object.
// Inputs:       Level - error logging level
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SetErrorLevel(Level: TErrorLevel);
begin
  // Delegate to PhiObject
  m_PhiObject.SetErrorLevel(Level) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get current Trace Logging Level.
// Inputs:       None
// Return:       Current Trace logging level
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetTraceLevel: TTraceLevel;
begin
  // Delegate to PhiObject
  Result := m_PhiObject.GetTraceLevel ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set trace logging level for this object.
// Inputs:       Level - trace logging level
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SetTraceLevel(Level: TTraceLevel);
begin
  // Delegate to PhiObject
  m_PhiObject.SetTraceLevel(Level) ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get Name of this object.
// Inputs:       None
// Return:       Name of this object
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetDocName: string;
begin
  // Delegate to PhiObject
  Result := m_PhiObject.GetName ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get name of this object.
// Inputs:       None
// Return:       Name of this object
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SetDocName(strName: string) ;
begin
  // Delegate to PhiObject
  m_PhiObject.SetName(strName) ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the file section name
// Inputs:       None
// Return:       Name of section - defaults to DocName if not set
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetAcqFileSectionName: string;
begin
  if m_AcqFileSectionName = c_InvalidString then
    Result := DocName
  else
    Result := m_AcqFileSectionName;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the full filename (pathname + filename + '.ini') used for 'Forms'.
// Inputs:       Filename as String
// Outputs:      None
// Note:         Checks if filename includes pathname.  Uses default pathname if needed.
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetFormFilename(FileName: String): String ;
var
  pathName: String;
begin
  if (ExtractFilePath(FileName) = '') then
    Result := m_FileDirectory  + '\' + c_FormDir + '\' + FileName + c_FormFileExt
  else
    Result := FileName;

  // Create the directory if it doesn't already exist
  pathName := ExtractFilePath(Result);
  if (SysUtils.DirectoryExists(pathName) = False) then
    SysUtils.ForceDirectories(pathName);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the full filename (pathname + filename + '.ini') used for 'Properties'.
// Inputs:       Filename as String
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetRegistryFilename(): String ;
var
  projectName: String;
begin
  // Get the current SmartSoft installation directory
  projectName := GetProjectName();

  // Registry key
  Result := '\SOFTWARE\Physical Electronics\' + projectName;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the full filename (pathname + filename + '.ini') used for 'Forms'.
// Inputs:       Filename as String
// Outputs:      None
// Note:         Checks if filename includes pathname.  Uses default pathname if needed.
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetReservedFilename(): String ;
var
  pathName: String;
begin
  Result := m_FileDirectory + '\' + c_SettingDir + '\' + 'Reserved' + '\' + 'Reserved' + m_FileExtensionSetting;

  // Create the directory if it doesn't already exist
  pathName := ExtractFilePath(Result);
  if (SysUtils.DirectoryExists(pathName) = False) then
    SysUtils.ForceDirectories(pathName);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the full filename (pathname + filename + '.ini') used for 'Properties'.
// Inputs:       Filename as String
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetPropertyFilename(Filename: String): String ;
var
  pathName: String;
begin
  if (Filename = '') then
    Result := m_FileDirectory + '\' + c_PropertyDir + '\' + c_PropertyName + c_PropertyFileExt
  else
    Result := Filename;

  // Create the directory if it doesn't already exist
  pathName := ExtractFilePath(Result);
  if (SysUtils.DirectoryExists(pathName) = False) then
    SysUtils.ForceDirectories(pathName);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the full filename (pathname + filename + '.ini') used for 'Settings'.
// Inputs:       Filename as String
// Outputs:      None
// Note:         Checks if filename includes pathname.  Uses default pathname if needed.
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetSettingFilename(Filename: String): String ;
var
  pathName: String;
begin
  if (ExtractFilePath(FileName) = '') then
    Result := m_FileDirectory + '\' + c_SettingDir + '\' + FileName + m_FileExtensionSetting
  else
    Result := FileName;

  // Create the directory if it doesn't already exist
  pathName := ExtractFilePath(Result);
  if (SysUtils.DirectoryExists(pathName) = False) then
    SysUtils.ForceDirectories(pathName);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the full filename (pathname + filename + '.ini') used for 'Settings'.
// Inputs:       Filename as String
// Outputs:      None
// Note:         Checks if filename includes pathname.  Uses default pathname if needed.
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetSectionName(SectionPrefix: String): String ;
begin
  if (SectionPrefix = '') then
    SectionPrefix := DocName;

  Result := SectionPrefix + '.' + FormatDateTime(c_DataMangledNameFormat, Now());
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the full filename (pathname + filename + '.ini') used for 'Settings'.
// Inputs:       Filename as String
// Outputs:      None
// Note:         Checks if filename includes pathname.  Uses default pathname if needed.
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetSettingsDirectory(): String ;
begin
  Result := GetPhiDirectory(dirApp, m_PhiObject.GetName());
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Find all settings file in the settings directory.
// Inputs:       None.
// Outputs:      List of settings names.
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetSettingList(): TStringList ;
var
  SearchRec: TSearchRec;
begin
  m_SettingList.Clear() ;

  // Find only the filenames that are in the current setting directory (i.e. 'AppDir\Settings\*.phi')
  if FindFirst(GetSettingFilename('*'), faAnyFile, SearchRec) = 0 then
  begin
    // Add file name to list of file names
    m_SettingList.Append(SearchRec.Name) ;

    // Find the next filename, and add to list
    while FindNext(SearchRec) = 0 do
    begin
      m_SettingList.Append(SearchRec.Name) ;
    end ;
    FindClose(SearchRec);
  end ;

  Result := m_SettingList ;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Get the current setting name
// Inputs:       None.
// Outputs:      List of settings names.
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.GetCurrentSetting: String;
begin
  Result := m_CurrentSetting;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set the current setting name
// Inputs:       None.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SetCurrentSetting(SettingName: String);
begin
  m_CurrentSetting := SettingName;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Add a reserved setting name
// Inputs:       String - Reserved Name
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.AddReserved(SettingName: String);
begin
  m_ReservedList.Add(SettingName);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Delete a reserved setting name
// Inputs:       String - Reserved Name
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.DeleteReserved(SettingName: String);
begin
  m_ReservedList.Delete(m_ReservedList.IndexOf(SettingName));
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check if setting is a reserved setting name
// Inputs:       String - Reserved Name
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.IsReserved(SettingName: String): Boolean;
var
  settingNameNoExtension: String;
begin
  settingNameNoExtension := StringReplace(ExtractFileName(SettingName), m_FileExtensionSetting, '', []);

  if (m_ReservedList.IndexOf(settingNameNoExtension) <> -1) then
    Result := True
  else
    Result := False;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Delete Setting
// Inputs:       String - Name of setting to be deleted; NotifyUser - Flag used
//                to warn users before deleting file
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.DeleteSetting(SettingName: String; NotifyUser: Boolean): Boolean ;
var
  validDelete: Boolean;
  Confirm: TDialogResult ;
begin
  validDelete := False;

  Confirm := yesResult ;
  if (NotifyUser) then
  begin
    if (m_ReservedList.IndexOf(SettingName) <> -1) then
    begin
      MessageDialog(infoDialog, ok, '''' + SettingName + ''' is a reserved setting which can not be deleted.') ;
      Confirm := cancelResult ;
    end
    else if (FileExists(GetSettingFilename(SettingName)) = False) then
    begin
      MessageDialog(errorDialog, ok, '''' + SettingName + '''setting was not found.') ;
      Confirm := cancelResult ;
    end
    else if (Pos('\', SettingName) <> 0) then
    begin
      MessageDialog(errorDialog, ok, 'Unable to delete ''' + SettingName + '''.') ;
      Confirm := cancelResult ;
    end
    else
      Confirm := MessageDialog(warningDialog, yesNo, 'Delete setting ''' + SettingName + '''?') ;
  end ;

  if (Confirm = yesResult) then
  begin
    // Delete Setting
    DeleteFile(GetSettingFilename(SettingName)) ;
    validDelete := True;
  end ;

  Result := validDelete;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Initialize hardware 'Properties' and 'Settings' to PREVIOUS.
// Inputs:       ParameterType.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.InitializeSettings();
begin
  InitializeSettings(c_Previous);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Initialize hardware 'Properties' and 'Settings'.
// Inputs:       ParameterType.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.InitializeSettings(SettingName: String);
var
  Index: longint ;
  Item: TParameter ;
begin
  // Check if Settings and/or Properties are needed
  Index := 1 ;
  while ((m_UsesSettings = False) or (m_UsesProperties = False) or (m_UsesRegistry = False)) and
    (Index <= m_ParameterList.Count) do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    if (Item.ParameterType = ptSettings) or (Item.ParameterType = ptSettingsReadOnly) or
      (Item.ParameterType = ptSettingsWriteOnly) then
      m_UsesSettings := True ;
    if (Item.ParameterType = ptProperties) or (Item.ParameterType = ptPropertiesReadOnly) or
      (Item.ParameterType = ptPropertiesWriteOnly) then
      m_UsesProperties := True ;
    if (Item.ParameterType = ptRegistry) or (Item.ParameterType = ptRegistryReadOnly) or
      (Item.ParameterType = ptRegistryWriteOnly) then
      m_UsesRegistry := True ;
    Index := Index + 1 ;
  end ;

  // Initialize 'Reserved' settings
  if (m_UsesReservedList = True)and (m_IsQueueEditor = False)   then
  begin
    if (FileExists(GetReservedFilename()) = True) then
      m_ReservedList.LoadFromFile(GetReservedFilename());
  end;

  // Initialize 'Registry'
  if (m_UsesRegistry = True)and (m_IsQueueEditor = False)   then
  begin
    if ValidRegistry(GetRegistryFilename()) = False then
      WriteRegistryParameters() ;

    // Load Registry
    ReadRegistryParameters() ;
  end ;

  // Initialize 'Properties'
  if (m_UsesProperties = True)and (m_IsQueueEditor = False)   then
  begin
    if ValidSetting(GetPropertyFilename()) = False then
      WritePropertyParameters(GetPropertyFilename()) ;

    // Load Properties
    ReadPropertyParameters() ;
  end ;

  // Initialize 'Settings'
  if (m_UsesSettings = True) and (m_IsQueueEditor = False)  then
  begin
    // Save a 'DEFAULT' setting file which captures parameters before loading in the previous settings
    WriteSettingParameters(GetSettingFilename(c_Default)) ;

    for Index := 0 to m_ReservedList.Count -1 do
    begin
      // Make sure that the list to be loaded exists (create it if it's not there)
      if ValidSetting(GetSettingFilename(m_ReservedList[Index])) = False then
        SaveSetting(m_ReservedList[Index], False);
    end;

    // Set the current setting to the passed in SettingName
    if ValidSetting(GetSettingFilename(SettingName)) = True then
      LoadSetting(SettingName, False) ;
  end ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Loads parameters from a file.
// Inputs:       FilePath - Filename as either: filename, or file pathname
//               NotifyUser - Flag used to suppress error messages.
// Outputs:      True if file loaded, else False.
// Note:         This routine supports settings files (i.e. .phi) and acquisition
//                files (i.e. .spe, .pro, .map, ...)
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.LoadFile(FilePath: String; NotifyUser: Boolean): Boolean;
var
  ValidLoad: Boolean;
begin
  // Initialize valid load flag
  ValidLoad := True;
  Result := False;

  // Set flag indicating status of load, User can 'Cancel' in ValidateChanges()
  if (NotifyUser) then
    ValidLoad := ValidateChanges();

  // User can 'Cancel' in ValidateChanges()
  if (ValidLoad) then
  begin
    // Check if the section exists in the filname
    if ValidSetting(FilePath, GetAcqFileSectionName()) then
      Result := LoadSetting(FilePath)
    else
      Result := LoadAcq(FilePath);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Loads setting values from a acquisition file (i.e. .spe, .pro, .map, ...).
// Inputs:       FileName - String
// Outputs:      True if file loaded, else False.
// Note:         Use the more robust LoadFile() method.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.LoadAcq(FilePath: String): Boolean;
var
  MultiPak: IMultiPak;
  AppSettings : IAppSettings;
  ErrorString: String;
  FileName: String;
  ErrorFound: Boolean;
  ValidLoad: Boolean;
  hr: HRESULT;
begin
  // Initialize valid load flag
  ValidLoad := True;

  // User can 'Cancel' in ValidateChanges()
  if (ValidLoad) then
  begin
    // Catch all exceptions.
    ErrorFound := false;
    try

      // Create a CoMultiPak object
      try
        MultiPak := CoMultiPak.Create();
      except
        ErrorString := 'Problems creating CoMultiPak object.';
        ErrorLog(errorCritical, E_FAIL, True, 0, ErrorString);
        ErrorFound := true;
        raise;
      end;

      // Create an AppSettings object.
      try
        AppSettings := CoAppSettings_.Create;
      except
        ErrorString := 'Problems creating CoAppSettings object.';
        ErrorLog(errorCritical, E_FAIL, True, 0, ErrorString);
        ErrorFound := true;
        raise;
      end;

      // Load the settings from the MultiPak file into the AppSettings object.
      hr := MultiPak.LoadSettings(FilePath, ssAllSettings, AppSettings as IUnknown);
      if (FAILED(hr)) then
      begin
        ErrorString := 'Error on call to LoadSettings.';
        ErrorLog(errorCritical, E_FAIL, True, 0, ErrorString);
        ErrorFound := true;
      end;

      // Read 'File' parameters from Acquisition Objects
      try
        ReadFileParameters(AppSettings);
      except
        ErrorString := 'Error on call to ReadFileParameters.';
        ErrorLog(errorCritical, E_FAIL, True, 0, ErrorString);
        ErrorFound := true;
        raise;
      end;

    finally
      FileName := ExtractFileName(FilePath);

      // Pop up a message dialog if an error was found.
      if (ErrorFound) then
      begin
        MessageDialog(errorDialog, ok, 'Unable to open "' + FileName + '".');
        ValidLoad := False;
      end
      else
      begin
        // Save 'Init' values for all Parameters registered to this doc
        SaveInit();

        // Save the current setting name
        m_CurrentSetting := FileName;
      end;

      // Clean up.
      MultiPak := nil;
      AppSettings := nil;
    end;
  end;

  Result := ValidLoad;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Read a TComponent which has been stored in a Window's resource file format
// Inputs:       Filename as String; Instance as TComponent
// Outputs:      None
// Note:         Returns True if 'Load' succeeds, else False
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.LoadForm(FileName: String; Instance: TComponent): Boolean;
var
  FilePath: String;
  ValidLoad: Boolean;
begin
  ValidLoad := True;

  FilePath := GetFormFilename(FileName);
  if (FileExists(FilePath)) then
  begin
    try
      ReadComponentResFile(FilePath, Instance);
    except
      DeleteFile(FilePath);
      ValidLoad := False;
    end;
  end
  else
    ValidLoad := False;

  if not ValidLoad then
  begin
    TraceLog(traceDebug, 'Unable to open ''' + FilePath + '''.') ;
  end;

  Result := ValidLoad;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Loads parameters from a setting file.
// Inputs:       SettingName - Filename as either: filename, or file pathname
//               NotifyUser - Flag used to suppress error messages.
// Outputs:      True if file loaded, else False.
// Note:         This routine supports settings files (i.e. .phi).
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.LoadTemp(): Boolean;
var
  validLoad: Boolean;
begin
  validLoad := LoadSetting(c_Temp, False);

  if (validLoad) then
  begin
    // Set the file name to the name saved in TempSetting
    m_CurrentSetting := m_TempSetting;

    // Delete the temp setting
    DeleteSetting(c_Temp, False);
  end;

  Result := validLoad;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Loads parameters from a setting file.
// Inputs:       SettingName - Filename as either: filename, or file pathname
//               NotifyUser - Flag used to suppress error messages.
// Outputs:      True if file loaded, else False.
// Note:         This routine supports settings files (i.e. .phi).
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.LoadSetting(SettingName: String; NotifyUser: Boolean): Boolean;
var
  ValidLoad: Boolean;
begin
  ValidLoad := True;

  // Check for any changes to the setting
  if (NotifyUser) then
  begin
    ValidLoad := ValidateChanges();
  end;

  // User can 'Cancel' in ValidateChanges()
  if (ValidLoad) then
  begin
    // Check that the file exists
    if (FileExists(GetSettingFilename(SettingName)) = True) then
    begin
      // Read the setting information
      ReadSettingParameters(GetSettingFilename(SettingName));

      // Save 'Init' values for all Parameters registered to this doc
      SaveInit();

      // Save the current setting name
      m_CurrentSetting := SettingName;
    end
    else
    begin
      if (NotifyUser) then
        MessageDialog(errorDialog, ok, '''' + SettingName + ''' Setting was not found.') ;

      // Set flag indicating load failed
      ValidLoad := False;
    end;
  end;

  Result := ValidLoad;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Load Setting
// Inputs:      String - Name of file to be loaded
// Outputs:     None
// Note:        Returns True if 'Load' succeeds, else False
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.LoadSetting(FilePath: String): Boolean;
var
  ValidLoad: Boolean;
begin
  // Initialize valid load flag
  ValidLoad := True;

  if (ValidLoad) then
  begin
    // Check that the file exists
    if (FileExists(FilePath) = True) then
    begin
      // Read the setting information
      ReadSettingParameters(FilePath);

      // Save 'Init' values for all Parameters registered to this doc
      SaveInit();

      // Save the current setting name
      m_CurrentSetting := FilePath;
    end
    else
    begin
      MessageDialog(errorDialog, ok, 'Unable to open ''' + ExtractFileName(FilePath) + '''.');

      // Set flag indicating load failed
      ValidLoad := False;
    end;
  end;

  Result := ValidLoad;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Loads parameters from a specific 'Section' of a .phi file.
// Inputs:       Filename: Filename as either: filename, or file pathname
//               Section: Section name
//               NotifyUser: Flag used to suppress error messages.
// Outputs:      True if file loaded, else False.
// Note:         This routine supports settings files (i.e. .phi).
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.LoadSection(Filename: String; Section: String; NotifyUser: Boolean): Boolean;
var
  ValidLoad: Boolean;
begin
  ValidLoad := True;

  // Check for any changes to the setting
  if (NotifyUser) then
  begin
    ValidLoad := ValidateChanges();
  end;

  // User can 'Cancel' in ValidateChanges()
  if (ValidLoad) then
  begin
    // Check that the file exists
    if (FileExists(Filename) = True) then
    begin
      // Read the setting information
      ReadSectionParameters(Filename, Section);

      // Save 'Init' values for all Parameters registered to this doc
      SaveInit();

      // Save the current setting name as PREVIOUS
      m_CurrentSetting := Section;
    end
    else
    begin
      ErrorLog(errorCritical, E_FAIL, False, 0, 'LoadSection(): Unable to load the section from file: ' + Section);

      // Set flag indicating load failed
      ValidLoad := False;
    end;
  end;

  Result := ValidLoad;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Loads parameters from a specific 'Section' of a .phi file.
// Inputs:       Filename: Filename as either: filename, or file pathname
//               Section: Section name
//               NotifyUser: Flag used to suppress error messages.
// Outputs:      True if file loaded, else False.
// Note:         This routine supports settings files (i.e. .phi).
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.LoadSection(Filename: String; Section: String; Parameter: TParameter; NotifyUser: Boolean): Boolean;
var
  ValidLoad: Boolean;
begin
  ValidLoad := True;

  // Check for any changes to the setting
  if (NotifyUser) then
  begin
    ValidLoad := ValidateChanges();
  end;

  // User can 'Cancel' in ValidateChanges()
  if (ValidLoad) then
  begin
    // Check that the file exists
    if (FileExists(Filename) = True) then
    begin
      // Read the setting information
      ReadSettingParameters(Filename, Section, Parameter);

      // Save 'Init' values for all Parameters registered to this doc
      SaveInit();

      // Save the current setting name as PREVIOUS
      m_CurrentSetting := Section;
    end
    else
    begin
      ErrorLog(errorCritical, E_FAIL, False, 0, 'LoadSection(): Unable to load the section from file: ' + Section);

      // Set flag indicating load failed
      ValidLoad := False;
    end;
  end;

  Result := ValidLoad;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Loads a parameter from a specific 'Section' of a .phi file.
// Inputs:       Filename: Filename as either: filename, or file pathname
//               Section: Section name
// Outputs:      True if file loaded, else False.
// Note:         This routine supports settings files (i.e. .phi).
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.LoadParameter(Filename: String; Section: String; Parameter: TParameter): Boolean;
var
  validLoad: Boolean;
  iniFile: TMemIniFile;
  item: TParameter ;
begin
  validLoad := True;

  // Check that the file exists
  if not FileExists(Filename) then
  begin
    ErrorLog(errorCritical, E_FAIL, False, 0, 'LoadParameter(' + Filename + ',' + Section + ',' + Parameter.Name + '): Error');

    // Set flag indicating load failed
    validLoad := False;
  end;

  if validLoad then
  begin
      iniFile := TMemIniFile.Create(FileName);
    try
      item := Parameter ;
      item.Group := Section;

      // Read parameter from file; assumes that read type is correct (ptSettings), or application code knows what it's doing
      item.ReadValueFromSetting(iniFile);
    finally
      iniFile.Free ;
    end;
  end;

  Result := validLoad;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save Parameters to Acqusition Object
// Inputs:       AppSettings - An App Settings interface pointer
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SaveAcqObject(AppSettings: IAppSettings; AcqObjectInfo: TAcqObjectInfo);
begin
  // Write 'File' parameters that are stored in the Doc class to the Acquisition Object
  WriteFileParameters(AppSettings);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save Parameters to Acqusition Object
// Inputs:       AppSettings - An App Settings interface pointer
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SaveAcqObject(AppSettings: IAppSettings);
var
  AcqObjectInfo: TAcqObjectInfo;
begin
  // Write 'File' parameters that are stored in the Doc class to the Acquisition Object
  SaveAcqObject(AppSettings, AcqObjectInfo);
end;
 
////////////////////////////////////////////////////////////////////////////////
// Description:  Save Parameters to TAppSettings Object
// Inputs:       AppSettings - A TAppSettings object
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SaveAcqObject(AppSettings: TAppSettings);
begin
  // Write 'File' parameters that are stored in the Doc class to the Acquisition Object
  WriteFileParameters(AppSettings);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save a TComponent in a Window's resource file format
// Inputs:       Filename as String; Instance as TComponent
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SaveForm(FileName: String; Instance: TComponent);
var
  FilePath: String;
begin
  FilePath := GetFormFilename(FileName);
  try
    WriteComponentResFile(FilePath, Instance);
  except
    DeleteFile(FilePath);
    TraceLog(traceDebug, 'Unable to save ''' + FilePath + '''.') ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save Setting
// Inputs:       String - Name of setting to be saved.  This name may be the
//                setting name only, in which case the pathname is added, or
//                the full pathname, in which case no pathname is added.
//               NotifyUser - Flag used to warn users before writing over an
//                existing file
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.SaveSetting(SettingName: String; NotifyUser: Boolean): Boolean;
var
  validSave: Boolean;
  Confirm: TDialogResult ;
  delimiterLocation: Integer;
begin
  validSave := False;

  Confirm := yesResult ;

  SettingName := Trim(SettingName);

  if (Confirm = yesResult) then
  begin
    // Make sure the filename is not empty
    if (SettingName = '') then
    begin
      Confirm := cancelResult ;
    end;
  end;

  if (Confirm = yesResult) then
  begin
    // Make sure there are no illegal characters in filename (i.e. '\')
    delimiterLocation := LastDelimiter(c_InvalidFileCharacters, ExtractFileName(SettingName));
    if (delimiterLocation <> 0) then
    begin
      MessageDialog(errorDialog, ok, 'A file name cannot contain any of the following characters: ' + c_InvalidFileCharacters);
      Confirm := cancelResult ;
    end;
  end;

  if (Confirm = yesResult) then
  begin
    if (NotifyUser = False) then // If notify user flag not set, don't prompt
      Confirm := yesResult
    else if (SettingName = m_CurrentSetting) then // If saving same file, don't prompt
      Confirm := yesResult
    else if (FileExists(GetSettingFilename(SettingName)) = True) then // If file exixts, prompt
      Confirm := MessageDialog(warningDialog, yesNo, '''' + SettingName + ''' already exists.  Do you want to update the setting?') ;
  end;

  if (Confirm = yesResult) then
  begin
    // Save setting information
    if (m_UsesSettings) and (m_IsQueueEditor = False) then
      WriteSettingParameters(GetSettingFilename(SettingName)) ;

    // Save property information
    if (m_UsesProperties)  and (m_IsQueueEditor = False) then
      WritePropertyParameters(GetPropertyFilename()) ;

    // Save 'Init' values for all Parameters registered to this doc
    SaveInit();

    // Save the current setting name
    m_CurrentSetting := SettingName;

    validSave := True;
  end ;

  Result := validSave;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save the settings values to a specific filename and section name.
//                This method is similar to the save settings, but instead of
//                auto-saving to section=DocName, the section name is passed as
//                a parameter.
// Inputs:       Filename - Name of setting to be saved.  This name may be the
//                setting name only, in which case the pathname is added, or
//                the full pathname, in which case no pathname is added.
//               Section - Section within the file where data will be saved.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.SaveSection(Filename: String; Section: String; FastWrite: Boolean): Boolean;
var
  validSave: Boolean;
begin
  validSave := True;

  if (validSave) then
  begin
    // Fast write used FileId, otherwise uses IniFileWrite
    if FastWrite then
      WriteSectionParameters(Filename, Section, True{append})
    else
      WriteSectionParametersSafe(Filename, Section, True{append});
  end ;

  Result := validSave;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save the settings values to a specific filename and section name.
//                This method is similar to the save settings, but instead of
//                auto-saving to section=DocName, the section name is passed as
//                a parameter.
// Inputs:       Filename - Name of setting to be saved.  This name may be the
//                setting name only, in which case the pathname is added, or
//                the full pathname, in which case no pathname is added.
//               Section - Section within the file where data will be saved.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.SaveSectionSafe(Filename: String; Section: String; Append: Boolean): Boolean;
var
  validSave: Boolean;
begin
  validSave := True;

  if (validSave) then
  begin
    WriteSectionParametersSafe(Filename, Section, Append);
  end ;

  Result := validSave;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save the settings values to a specific filename and section name.
//                This method is similar to the save settings, but instead of
//                auto-saving to section=DocName, the section name is passed as
//                a parameter.
// Inputs:       Filename - Name of setting to be saved.  This name may be the
//                setting name only, in which case the pathname is added, or
//                the full pathname, in which case no pathname is added.
//               Section - Section within the file where data will be saved.
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.SaveSectionSafe(Filename: String; Section: String; Parameter: TParameter; Append: Boolean): Boolean;
var
  validSave: Boolean;
begin
  validSave := True;

  if (validSave) then
  begin
    WriteSettingParametersSafe(Filename, Section, Parameter, Append);
  end ;

  Result := validSave;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save the settings value to a specific filename, section name, parameter name.
// Inputs:       Filename - Name of setting to be saved.  This name may be the
//                setting name only, in which case the pathname is added, or
//                the full pathname, in which case no pathname is added.
//               Section - Section within the file where data will be saved.
//               Parameter - TParameter
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.SaveParameter(Filename: String; Section: String; Tag: String; Parameter: TParameter): Boolean;
var
  validSave: Boolean;
  sMessage: String;
begin
  validSave := True;

  if not FileExists(GetSettingFilename(Filename)) then
  begin
    if not CopyFile(PWideChar(GetSettingFilename(c_Default)), PWideChar(GetSettingFilename(Filename)), True) then
    begin
      Fmtstr(sMessage, 'SaveParameter(%s,%s,%s): Error', [Filename, Section, Tag]);
      ErrorLog(errorCritical, E_FAIL, False, 0, sMessage);

      validSave := False;
    end;
  end;

  if validSave then
  begin
    WriteParameter(Filename, Section, Tag, Parameter) ;
  end ;

  Result := validSave;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save the settings value to a specific filename, section name, parameter name.
// Inputs:       Filename - Name of setting to be saved.  This name may be the
//                setting name only, in which case the pathname is added, or
//                the full pathname, in which case no pathname is added.
//               Section - Section within the file where data will be saved.
//               Parameter - TParameter
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SaveParameter(Sender: TObject);
var
  parameterPtr: TParameter;
  fileId: TextFile;
  filename: String;
  pathName: String;
  bAppend: Boolean;
begin
  parameterPtr := TParameter(Sender);

  filename := m_FileDirectory  + '\' + c_LogDir + '\' + parameterPtr.Name + c_PropertyFileExt;

  // Associate file variable fileId to the given property file name
  AssignFile(fileId, filename);
  try
    // Check that file exists; can't append if file doesn't exist
    if (FileExists(filename)) then
      bAppend := True
    else
    begin
      bAppend := False;

      // Create the directory if it doesn't already exist
      pathName := ExtractFilePath(filename);
      if (SysUtils.DirectoryExists(pathName) = False) then
        SysUtils.ForceDirectories(pathName);
    end;

    if (bAppend) then
      // Prepare the file to append to the end of file
      Append(fileId)
    else
      // Create a new external file with the name assigned to fileId
      Rewrite(fileId);

    parameterPtr.WriteValueToSetting(fileId);
  finally
    CloseFile(fileId);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  This method copies all of the tag=values, from the specified section,
//                 from on file to another.
// Inputs:       Filename - Name of setting to be saved.  This name may be the
//                 setting name only, in which case the pathname is added, or
//                 the full pathname, in which case no pathname is added.
//               Section - Section within the file where data will be saved.
// Outputs:      None
// Note:         The values are read directly from the file, and do not rely on any
//                 TParameter support.
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.CopySection(FromFilename: String; ToFilename: String; Section: String): Boolean;
var
  readIniFile: TMemIniFile;
  writeIniFile: TIniFile;
  sectionTags: TStrings;
  tagIndex: Integer;
  value: String;
  tag: String;
begin
  Result := False;

  // Get pathname+filename
  ToFilename := GetSettingFilename(ToFilename);
  FromFilename := GetSettingFilename(FromFilename);

  // Check that the section exists in the 'from' file
  if not IsValidSection(FromFilename, Section) then
    Exit;

  writeIniFile := TIniFile.Create(ToFilename);
  readIniFile := TMemIniFile.Create(FromFilename);
  sectionTags := TStringList.Create();
  try
    // Cleanup previous section information, as needed
    if writeIniFile.SectionExists(Section) then
      writeIniFile.EraseSection(Section);

    // Read all section tag string values from the file
    readIniFile.ReadSection(Section, sectionTags);

    // Copy each section tag
    for tagIndex := 0 to sectionTags.Count - 1 do
    begin
      tag := sectionTags.Strings[tagIndex];
      value := readIniFile.ReadString(Section, tag, 'Error');
      writeIniFile.WriteString(Section, tag, value);
    end;

    // Flush the memory ini file
    writeIniFile.UpdateFile();
  finally
    if assigned(sectionTags) then
      sectionTags.Free();
    if assigned(readIniFile) then
      readIniFile.Free();
    if assigned(writeIniFile) then
      writeIniFile.Free();
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  This method copies all of the tag=values, from the specified section,
//                 from on file to another.
// Inputs:       Filename - Name of setting to be saved.  This name may be the
//                 setting name only, in which case the pathname is added, or
//                 the full pathname, in which case no pathname is added.
//               Section - Section within the file where data will be saved.
// Outputs:      None
// Note:         The values are read directly from the file, and do not rely on any
//                 TParameter support.
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.CopySection(FromFilename: String; ToFilename: String; FromSection: String; ToSection: String): Boolean;
var
  readIniFile: TMemIniFile;
  writeIniFile: TIniFile;
  sectionTags: TStrings;
  tagIndex: Integer;
  value: String;
  tag: String;
begin
  Result := False;

  // Get pathname+filename
  ToFilename := GetSettingFilename(ToFilename);
  FromFilename := GetSettingFilename(FromFilename);

  // Check that the section exists in the 'from' file
  if not IsValidSection(FromFilename, FromSection) then
    Exit;

  writeIniFile := TIniFile.Create(ToFilename);
  readIniFile := TMemIniFile.Create(FromFilename);
  sectionTags := TStringList.Create();
  try
    // Cleanup previous section information, as needed
    if writeIniFile.SectionExists(ToSection) then
      writeIniFile.EraseSection(ToSection);

    // Read all section tag string values from the file
    readIniFile.ReadSection(FromSection, sectionTags);

    // Copy each section tag
    for tagIndex := 0 to sectionTags.Count - 1 do
    begin
      tag := sectionTags.Strings[tagIndex];
      value := readIniFile.ReadString(FromSection, tag, 'Error');
      writeIniFile.WriteString(ToSection, tag, value);
    end;

    // Flush the memory ini file
    writeIniFile.UpdateFile();
  finally
    if assigned(sectionTags) then
      sectionTags.Free();
    if assigned(readIniFile) then
      readIniFile.Free();
    if assigned(writeIniFile) then
      writeIniFile.Free();
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  This method copies all of the tag=values, from the specified section,
//                 from on file to another.
// Inputs:       FromIniFile -  TMemIniFile instance already loaded with 'from' file
//                              ini file content
//               ToIniFile -  TIniFile instance already loaded with 'to' file
//                              ini file content; specified section will be copied
//                              to this file
//               Section - Section within the file where data will be copied.
// Outputs:      None
// Returns:      Not used (always false)
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.CopySection(
  var FromIniFile: TMemIniFile;
  var ToIniFile: TIniFile;
  Section: String
): Boolean;
var
  tagIndex: Integer;
  value: String;
  tag: String;
  sectionTags: TStrings;
begin
  Result := False;

  // Skip if given section doesn't exist
  if (not FromIniFile.SectionExists(Section)) then
    Exit;

  sectionTags := nil;
  try
    // Cleanup previous section information, as needed
    // We will rewrite the interested section
    if (ToIniFile.SectionExists(Section)) then
      ToIniFile.EraseSection(Section);

    // Read all section tag string values from the file
    sectionTags := TStringList.Create();
    FromIniFile.ReadSection(Section, sectionTags);

    // Copy each section tag
    for tagIndex := 0 to sectionTags.Count - 1 do
    begin
      tag := sectionTags.Strings[tagIndex];
      value := FromIniFile.ReadString(Section, tag, 'Error');
      ToIniFile.WriteString(Section, tag, value);
    end;
  finally
    if assigned(sectionTags) then
      sectionTags.Free();
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  This method check if a specific section exists.
// Inputs:       Filename - Setting file name.
//               Section - Section name within the file.
// Outputs:      True: if section is found.
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.IsValidSection(Filename: String; Section: String): Boolean;
var
  iniFile: TMemIniFile;
begin
  Result := False;

  // Check that the file exists
  if not FileExists(GetSettingFilename(Filename)) then
    Exit;

  // Check for empty section: causes an exception in SectionExists()
  if Section = '' then
    Exit;

  // Check for valid section
  iniFile := TMemIniFile.Create(GetSettingFilename(Filename));
  if iniFile.SectionExists(Section) then
    Result := True;
  iniFile.Free ;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Save previous is used as a means to periodically save a copy
//              of the Doc's parameters.  The parameter are saved to the 'PREVIOUS'
//              setting.
// Inputs:      None.
// Outputs:     None.
// Note:        The 'Current Setting Name' is NOT updated.
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SaveTemp() ;
begin
  m_TempSetting := m_CurrentSetting;

  // Save setting information
  if (m_UsesSettings) and (m_IsQueueEditor = False)  then
    WriteSettingParameters(GetSettingFilename(c_Temp)) ;

  // Save property information
  if (m_UsesProperties) and (m_IsQueueEditor = False)  then
    WritePropertyParameters(GetPropertyFilename()) ;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description: Save previous is used as a means to periodically save a copy
//              of the Doc's parameters.  The parameter are saved to the 'PREVIOUS'
//              setting.
// Inputs:      None.
// Outputs:     None.
// Note:        The 'Current Setting Name' is NOT updated.
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SavePrevious() ;
begin
  // Don't save a reserved setting to 'PREVIOUS'
  if (m_ReservedList.IndexOf(m_CurrentSetting) = -1) or (m_CurrentSetting = c_Previous) then
  begin
    // Save setting information
    if (m_UsesSettings)  and (m_IsQueueEditor = False) then
      WriteSettingParameters(GetSettingFilename(c_Previous)) ;
  end ;

  // Save property information
  if (m_UsesProperties) and (m_IsQueueEditor = False) then
    WritePropertyParameters(GetPropertyFilename()) ;

  // Save registry information
  if (m_UsesRegistry) and (m_IsQueueEditor = False)  then
    WriteRegistryParameters() ;

  // Save list of reserved settings
  if (m_UsesReservedList) and (m_IsQueueEditor = False)  then
    m_ReservedList.SaveToFile(GetReservedFilename());
end ;

////////////////////////////////////////////////////////////////////////////////
// Description: Save previous is used as a means to periodically save a copy
//              of the Doc's parameters.  The parameter are saved to the 'PREVIOUS'
//              setting.
// Inputs:      None.
// Outputs:     None.
// Note:        The 'Current Setting Name' is NOT updated.
////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SaveAll(Filename: String);
var
  bAppend: Boolean;
begin
  // append all the settings and properties together in one file
  bAppend := True;

  // Save setting information
  if (m_UsesSettings)  and (m_IsQueueEditor = False) then
    WriteSettingParameters(GetSettingFilename(Filename), DocName + ': ' + m_CurrentSetting, bAppend) ;

  // Save property information
  if (m_UsesProperties)  and (m_IsQueueEditor = False) then
    WritePropertyParameters(GetPropertyFilename(Filename), DocName + ': Properties', bAppend) ;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description: Copy application settings.
// Inputs:      Setting name to copy from; Setting name to copy to.
// Outputs:     None.
// Note:        If setting name does NOT include a path, the path name of the
//               current application is used.
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.CopySetting(FromSetting: String; ToSetting: String; Overwrite: Boolean): Boolean;
var
  ValidCopy: Boolean;
begin
  // Set flag indicating copy status
  ValidCopy := True;

  // Make sure that these are full pathnames
  FromSetting := GetSettingFilename(FromSetting);
  ToSetting := GetSettingFilename(ToSetting);

  // Check that the file exists
  if (FileExists(FromSetting) = True) then
  begin
    // Copy the setting information
    if (m_UsesSettings) then
      CopySettingParameters(FromSetting, ToSetting, Overwrite) ;
  end
  else
  begin
    // Set flag indicating copy failed
    ValidCopy := False;
  end;

  Result := ValidCopy;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Check the registry key is valid.
// Inputs:      None.
// Outputs:     None.
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ValidRegistry(RegistryKey: String): Boolean ;
var
  readRegIniFile: TRegIniFile;
begin
  Result := False;

  readRegIniFile := TRegIniFile.Create();
  try
    readRegIniFile.RootKey := HKEY_LOCAL_MACHINE;

    if readRegIniFile.KeyExists(RegistryKey) then
      Result := True
  finally
    readRegIniFile.CloseKey;
    readRegIniFile.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Check the setting is valid.
// Inputs:      None.
// Outputs:     None.
// Note:
////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ValidSetting(Filename: String; SectionName: String): Boolean ;
var
  IniFile: TMemIniFile;
begin
  Result := False;

  // Support for custom section name
  if SectionName = c_InvalidString then
    SectionName := DocName;

  // Get full filepathname; if needed
  Filename := GetSettingFilename(Filename);

  // Check that file exists
  if (FileExists(Filename) = True) then
  begin
    IniFile := TMemIniFile.Create(Filename);

    // If section exists, then the file is valid
    Result := IniFile.SectionExists(SectionName);

    IniFile.Free ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read 'File' Parameters from the passed Acquisition Object
// Inputs:       AppSettings - An App Settings interface pointer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ReadFileParameters(AppSettings: IAppSettings);
var
  Index: Integer;
  Item: TParameter;
begin
  // Make sure Acquisition Object is valid
  if (AppSettings = nil) then
    Exit;

  // Loop through all TParameters
  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1];
    if (Item.FileParameterType = ptDefaultToSettings) then
    begin
      if (Item.ParameterType = ptSettings) or (Item.ParameterType = ptSettingsReadOnly) then
        Item.ReadValueFromAcq(AppSettings);
    end
    else if (Item.FileParameterType = ptSettings) or (Item.FileParameterType = ptSettingsReadOnly) then
      Item.ReadValueFromAcq(AppSettings);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read 'Registry' Parameters
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ReadRegistryParameters() ;
var
  index: Integer;
  parameterPtr: TParameter;
  readRegIniFile: TRegIniFile;
  registryKey: String;
begin
  readRegIniFile := TRegIniFile.Create;

  try
    readRegIniFile.RootKey := HKEY_LOCAL_MACHINE;

    registryKey := GetRegistryFilename();
    if readRegIniFile.OpenKey(registryKey, True) then
    begin
      for index := 1 to m_ParameterList.Count do
      begin
        parameterPtr := m_ParameterList.Items[index-1] ;
        parameterPtr.Group := DocName;
        if (parameterPtr.ParameterType = ptRegistry) or (parameterPtr.ParameterType = ptRegistryReadOnly) then
          parameterPtr.ReadValueFromRegistry(readRegIniFile);
      end;
    end
    else
    begin
      ErrorLog(errorCritical, E_FAIL, 'Check user access permission. Unable to open/create registry key: ' + registryKey);
    end;
  finally
    readRegIniFile.CloseKey;
    readRegIniFile.Free;
  end;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read 'Properties' Parameters
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ReadPropertyParameters() ;
var
  IniFile: TMemIniFile;
  Index: Integer;
  Item: TParameter;
begin
  IniFile := TMemIniFile.Create(GetPropertyFilename());

  // Loop through all TParameters
  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Group := DocName;
    if (Item.ParameterType = ptProperties) or (Item.ParameterType = ptPropertiesReadOnly) then
      Item.ReadValueFromSetting(IniFile);
  end ;
  IniFile.Free ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read 'Settings' Parameters
// Inputs:       FileName as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ReadSettingParameters(FileName: String) ;
var
  IniFile: TMemIniFile;
  Index: Integer ;
  Item: TParameter ;
begin
  IniFile := TMemIniFile.Create(FileName);

  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Group := DocName;
    if (Item.ParameterType = ptSettings) or (Item.ParameterType = ptSettingsReadOnly) then
      Item.ReadValueFromSetting(IniFile);
  end ;
  IniFile.Free ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read 'Settings' Parameters
// Inputs:       FileName as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ReadSettingParameters(FileName: String; Section: String) ;
var
  IniFile: TMemIniFile;
  Index: Integer ;
  Item: TParameter ;
begin
  IniFile := TMemIniFile.Create(FileName);

  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Group := Section;
    if (Item.ParameterType = ptSettings) or (Item.ParameterType = ptSettingsReadOnly) then
      Item.ReadValueFromSetting(IniFile);
  end ;
  IniFile.Free ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read 'Settings' Parameters
// Inputs:       FileName as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ReadSettingParameters(FileName: String; Section: String; Parameter: TParameter) ;
var
  IniFile: TMemIniFile;
  Item: TParameter ;
begin
  IniFile := TMemIniFile.Create(FileName);
  try
    Item := Parameter ;
    Item.Group := Section;
    Item.ReadValueFromSetting(IniFile);
  finally
    IniFile.Free ;
  end;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read 'Settings' Parameters
// Inputs:       FileName as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ReadSectionParameters(FileName: String; Section: String) ;
var
  IniFile: TMemIniFile;
  Index: Integer ;
  Item: TParameter ;
begin
  IniFile := TMemIniFile.Create(FileName);

  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Group := Section;
    if (Item.SectionParameterType = ptSectionReadWrite) or (Item.SectionParameterType = ptSectionRead) then
      Item.ReadValueFromSetting(IniFile);
  end ;
  IniFile.Free ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read 'Caption' Parameters
// Inputs:       FileName as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ReadCaptionParameters(FileName: String) ;
var
  IniFile: TMemIniFile;
  Index: Integer ;
  Item: TParameter ;
begin
  IniFile := TMemIniFile.Create(FileName);

  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Group := DocName;
    Item.ReadCaptionFromSetting(IniFile);
  end ;
  IniFile.Free ;

  UpdateAllViews(c_OnUpdateAll);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read 'Hint' Parameters
// Inputs:       FileName as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ReadHintParameters(FileName: String) ;
var
  IniFile: TMemIniFile;
  Index: Integer ;
  Item: TParameter ;
begin
  IniFile := TMemIniFile.Create(FileName);

  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Group := DocName;
    Item.ReadHintFromSetting(IniFile);
  end ;
  IniFile.Free ;

  UpdateAllViews(c_OnUpdateAll);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read a tag-value from a settings file 'i.e INI file'.
// Inputs:       Filename - String
//               Section - String
//               Tag - String
// Outputs:      Value - String (Note: If file, section, or tag is missing,
//               'c_ParameterMissing' is returned).
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ReadParameter(Filename: String; Tag: String): String;
begin
  Result := ReadParameter(Filename, DocName, Tag);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read a tag-value from a settings file 'i.e INI file'.
// Inputs:       Filename - String
//               Parameter - TParameter
// Outputs:      Value - String (Note: If file, section, or tag is missing,
//               'c_ParameterMissing' is returned).
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ReadParameter(Filename: String; Parameter: TParameter): String;
begin
  Result := ReadParameter(Filename, DocName, Parameter.Name);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read a tag-value from a settings file 'i.e INI file'.
// Inputs:       Filename - String
//               Section - String
//               Tag - String
// Outputs:      Value - String (Note: If file, section, or tag is missing,
//               'c_ParameterMissing' is returned).
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ReadParameter(Filename: String; Section: String; Tag: String): String;
var
  iniFile: TMemIniFile;
begin
  Result := c_ParameterMissing;

  // Check that the file exists
  if (FileExists(GetSettingFilename(Filename)) = True) then
  begin
    // Open file
    iniFile := TMemIniFile.Create(GetSettingFilename(Filename));

    // Read value
    Result := iniFile.ReadString(Section, Tag, c_ParameterMissing);

    // Cleanup
    iniFile.Free ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read a tag-value from a settings file 'i.e INI file'.
// Inputs:       Filename - String
//               Section - String
//               Tag - String
// Outputs:      Value - String (Note: If file, section, or tag is missing,
//               'c_ParameterMissing' is returned).
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ReadParameterAsFloat(Filename: String; Tag: String): Double;
begin
  try
    Result := StrToFloat(ReadParameter(Filename, DocName, Tag));
  except
    ModalDialog(warningDialog, ok, Tag + ' is missing from the ' + Filename + 'setting file: Please resave the file.');
    Result := 0.0;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read a tag-value from a settings file 'i.e INI file'.
// Inputs:       Filename - String
//               Parameter - TParameter
// Outputs:      Value - String (Note: If file, section, or tag is missing,
//               'c_ParameterMissing' is returned).
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ReadParameterAsFloat(Filename: String; Parameter: TParameter): Double;
begin
  try
    Result := StrToFloat(ReadParameter(Filename, DocName, Parameter.Name));
  except
    Result := Parameter.ValueAsFloat;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read a tag-value from a settings file 'i.e INI file'.
// Inputs:       Filename - String
//               Section - String
//               Tag - String
// Outputs:      Value - String (Note: If file, section, or tag is missing,
//               'c_ParameterMissing' is returned).
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ReadParameterAsFloat(Filename: String; Section: String; Tag: String): Double;
begin
  try
    Result := StrToFloat(ReadParameter(Filename, Section, Tag));
  except
    ModalDialog(warningDialog, ok, Tag + ' is missing from the ' + Filename + 'setting file: Please resave the file.');
    Result := 0.0;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read a tag-value from a settings file 'i.e INI file'.
// Inputs:       Tag - String
// Outputs:      Value - String (Note: If file, section, or tag is missing,
//               'c_ParameterMissing' is returned).
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ReadProperty(Tag: String): String;
begin
  Result := ReadProperty(DocName, Tag);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read a tag-value from a settings file 'i.e INI file'.
// Inputs:       Parameter - TParameter
// Outputs:      Value - String (Note: If file, section, or tag is missing,
//               'c_ParameterMissing' is returned).
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ReadProperty(Parameter: TParameter): String;
begin
  Result := ReadProperty(DocName, Parameter.Name);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read a tag-value from a settings file 'i.e INI file'.
// Inputs:       Section - String
//               Tag - String
// Outputs:      Value - String (Note: If file, section, or tag is missing,
//               'c_ParameterMissing' is returned).
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiDoc.ReadProperty(Section: String; Tag: String): String;
var
  iniFile: TMemIniFile;
begin
  Result := c_ParameterMissing;

  // Check that the file exists
  if (FileExists(GetPropertyFilename()) = True) then
  begin
    // Open file
    iniFile := TMemIniFile.Create(GetPropertyFilename());

    // Read value
    Result := iniFile.ReadString(Section, Tag, c_ParameterMissing);

    // Cleanup
    iniFile.Free ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'File' Parameters to the passed Acquisition Object
// Inputs:       AppSettings - An App Settings interface pointer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteFileParameters(AppSettings: IAppSettings);
var
  Index: Integer;
  Item: TParameter;
begin
  // Make sure Acquisition Object is valid
  if (AppSettings = nil) then
    Exit;

  // Loop through all the Setting objects in the list.
  for Index := 1 to m_ParameterList.Count do
  begin
    // Get the TParameter object from the list.
    Item := m_ParameterList.Items[Index-1];
    if (Item.FileParameterType = ptDefaultToSettings) then
    begin
      if (Item.ParameterType = ptSettings) or (Item.ParameterType = ptSettingsWriteOnly) then
        Item.WriteValueToAcq(AppSettings);
    end
    else if (Item.FileParameterType = ptSettings) or (Item.FileParameterType = ptSettingsWriteOnly) then
      Item.WriteValueToAcq(AppSettings);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'File' Parameters to the passed TAppSettings Object
// Inputs:       AppSettings - A TAppSettings object
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteFileParameters(AppSettings: TAppSettings);
var
  Index: Integer;
  Item: TParameter;
begin
  // Make sure Acquisition Object is valid
  if (AppSettings = nil) then
    Exit;

  // Loop through all the Setting objects in the list.
  for Index := 1 to m_ParameterList.Count do
  begin
    // Get the TParameter object from the list.
    Item := m_ParameterList.Items[Index-1];
    if (Item.FileParameterType = ptDefaultToSettings) then
    begin
      if (Item.ParameterType = ptSettings) or (Item.ParameterType = ptSettingsWriteOnly) then
        Item.WriteValueToAcq(AcqFileSectionName, AppSettings);
    end
    else if (Item.FileParameterType = ptSettings) or (Item.FileParameterType = ptSettingsWriteOnly) then
      Item.WriteValueToAcq(AcqFileSectionName, AppSettings);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Properties' Parameters.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteRegistryParameters() ;
var
  index: Integer;
  parameterPtr: TParameter;
  writeRegIniFile: TRegIniFile;
  registryKey: String;
begin
  writeRegIniFile := TRegIniFile.Create;

  try
    writeRegIniFile.RootKey := HKEY_LOCAL_MACHINE;

    registryKey := GetRegistryFilename();
    if writeRegIniFile.OpenKey(registryKey, True) then
    begin
      for index := 1 to m_ParameterList.Count do
      begin
        parameterPtr := m_ParameterList.Items[index-1] ;
        parameterPtr.Group := DocName;
        if (parameterPtr.ParameterType = ptRegistry) or (parameterPtr.ParameterType = ptRegistryWriteOnly) then
          parameterPtr.WriteValueToRegistry(writeRegIniFile);
      end;
    end;
  finally
    writeRegIniFile.CloseKey;
    writeRegIniFile.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Properties' Parameters.  Write properties in ini file format.
// Inputs:       Filename - full pathname of file to write to
//               bAppend - if true, append properties to file; otherwise rewrite the file
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WritePropertyParameters(Filename: String; bAppend: Boolean) ;
var
  Index: Integer;
  Item: TParameter;
  fileId: TextFile;
begin
  // Associate file variable fileId to the given property file name
  AssignFile(fileId, Filename);

  // can't append if file doesn't exist
  if (not FileExists(Filename)) then
    bAppend := False;

  if (bAppend) then
    // Prepare the file to append to the end of file
    Append(fileId)
  else
    // Create a new external file with the name assigned to fileId
    Rewrite(fileId);

  // Write section header
  Writeln(FileId, '[' + DocName + ']');

  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Group := DocName;
    if (Item.ParameterType = ptProperties) or (Item.ParameterType = ptPropertiesWriteOnly) then
      Item.WriteValueToSetting(fileId);
  end ;

  // Append a blank line at the end of the section
  Writeln(FileId, ' ');

  CloseFile(fileId);
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Properties' Parameters.    Write properties in ini file format.
// Inputs:       Filename - full pathname of file to write to
//               Section - section name
//               bAppend - if true, append properties to file; otherwise rewrite the file
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WritePropertyParameters(Filename: String; Section: String; bAppend: Boolean) ;
var
  Index: Integer;
  Item: TParameter;
  fileId: TextFile;
begin
  // Associate file variable fileId to the given property file name
  AssignFile(fileId, Filename);

  // can't append if file doesn't exist
  if (not FileExists(Filename)) then
    bAppend := False;

  if (bAppend) then
    // Prepare the file to append to the end of file
    Append(fileId)
  else
    // Create a new external file with the name assigned to fileId
    Rewrite(fileId);

  // Write section header
  Writeln(FileId, '[' + Section + ']');

  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Group := Section;
    if (Item.ParameterType = ptProperties) or (Item.ParameterType = ptPropertiesWriteOnly) then
      Item.WriteValueToSetting(fileId);
  end ;

  // Append a blank line at the end of the section
  Writeln(FileId, ' ');

  CloseFile(fileId);
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Setting' Parameters.    Write settings in ini file format.
// Inputs:       Filename - full pathname of file to write to
//               bAppend - if true, append settings to file; otherwise rewrite the file
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteSettingParameters(Filename: String; bAppend: Boolean) ;
var
  Index: Integer;
  Item: TParameter;
  fileId: TextFile;
begin
  // Associate file variable fileId to the given property file name
  AssignFile(fileId, Filename);

  // can't append if file doesn't exist
  if (not FileExists(Filename)) then
    bAppend := False;

  if (bAppend) then
    // Prepare the file to append to the end of file
    Append(fileId)
  else
    // Create a new external file with the name assigned to fileId
    Rewrite(fileId);

  // Write section header
  Writeln(FileId, '[' + DocName + ']');

  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Group := DocName;
    if (Item.ParameterType = ptSettings) or (Item.ParameterType = ptSettingsWriteOnly) then
      Item.WriteValueToSetting(fileId);
  end ;

  // Append a blank line at the end of the section
  Writeln(FileId, ' ');

  CloseFile(fileId);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Setting' Parameters.    Write settings in ini file format.
// Inputs:       Filename - full pathname of file to write to
//               Section - section name
//               bAppend - if true, append settings to file; otherwise rewrite the file
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteSettingParameters(Filename: String; Section: String; bAppend: Boolean) ;
var
  Index: Integer;
  Item: TParameter;
  fileId: TextFile;
begin
  // Associate file variable fileId to the given property file name
  AssignFile(fileId, Filename);

  // can't append if file doesn't exist
  if (not FileExists(Filename)) then
    bAppend := False;

  if (bAppend) then
    // Prepare the file to append to the end of file
    Append(fileId)
  else
    // Create a new external file with the name assigned to fileId
    Rewrite(fileId);

  // Write section header
  Writeln(FileId, '[' + Section + ']');

  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Group := Section;
    if (Item.ParameterType = ptSettings) or (Item.ParameterType = ptSettingsWriteOnly) then
      Item.WriteValueToSetting(fileId);
  end ;

  // Append a blank line at the end of the section
  Writeln(FileId, ' ');

  CloseFile(fileId);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Setting' Parameters.    Write settings in ini file format.
// Inputs:       Filename - full pathname of file to write to
//               Section - section name
//               bAppend - if true, append settings to file; otherwise rewrite the file
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteSettingParameters(Filename: String; Section: String; Parameter: TParameter; bAppend: Boolean) ;
var
  Item: TParameter;
  fileId: TextFile;
begin
  // Associate file variable fileId to the given property file name
  AssignFile(fileId, Filename);
  try
    // can't append if file doesn't exist
    if (not FileExists(Filename)) then
      bAppend := False;

    if (bAppend) then
      // Prepare the file to append to the end of file
      Append(fileId)
    else
      // Create a new external file with the name assigned to fileId
      Rewrite(fileId);

    // Write section header
    Writeln(FileId, '[' + Section + ']');

    Item := Parameter ;
    Item.Group := Section;
    Item.WriteValueToSetting(fileId);

    // Append a blank line at the end of the section
    Writeln(FileId, ' ');
  finally
    CloseFile(fileId);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Setting' Parameters.    Write settings in ini file format.
// Inputs:       Filename - full pathname of file to write to
//               Section - section name
//               bAppend - if true, append settings to file; otherwise rewrite the file
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteSettingParametersSafe(Filename: String; Section: String; bAppend: Boolean) ;
var
  iniFile: TMemIniFile;
  index: Integer ;
  item: TParameter ;
begin
  // Open ini file
  iniFile := TMemIniFile.Create(FileName);

  try
    // Cleanup previous section information, as needed
    if (bAppend = False) and iniFile.SectionExists(Section) then
      iniFile.EraseSection(Section);

    for index := 1 to m_ParameterList.Count do
    begin
      item := m_ParameterList.Items[index-1] ;
      item.Group := Section;
      if (item.ParameterType = ptSettings) or (item.ParameterType = ptSettingsWriteOnly) then
        item.WriteValueToSetting(iniFile);
    end ;

    // Flush the memory ini file
    iniFile.UpdateFile();
  finally
    if assigned(iniFile) then
      iniFile.Free ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Setting' Parameters.    Write settings in ini file format.
// Inputs:       Filename - full pathname of file to write to
//               Section - section name
//               bAppend - if true, append settings to file; otherwise rewrite the file
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteSettingParametersSafe(Filename: String; Section: String; Parameter: TParameter; bAppend: Boolean) ;
var
  iniFile: TMemIniFile;
  item: TParameter ;
begin
  // Open ini file
  iniFile := TMemIniFile.Create(FileName);

  try
    // Cleanup previous section information, as needed
    if (bAppend = False) and iniFile.SectionExists(Section) then
      iniFile.EraseSection(Section);

    // Write the parameter
    item := Parameter ;
    item.Group := Section;
    item.WriteValueToSetting(iniFile);

    // Flush the memory ini file
    iniFile.UpdateFile();
  finally
    if assigned(iniFile) then
      iniFile.Free ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Setting' Parameters.    Write settings in ini file format.
// Inputs:       Filename - full pathname of file to write to
//               Section - section name
//               bAppend - if true, append settings to file; otherwise rewrite the file
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteSectionParameters(Filename: String; Section: String; bAppend: Boolean) ;
var
  Index: Integer;
  Item: TParameter;
  fileId: TextFile;
begin
  // Associate file variable fileId to the given property file name
  AssignFile(fileId, Filename);

  // can't append if file doesn't exist
  if (not FileExists(Filename)) then
    bAppend := False;

  if (bAppend) then
    // Prepare the file to append to the end of file
    Append(fileId)
  else
    // Create a new external file with the name assigned to fileId
    Rewrite(fileId);

  // Write section header
  Writeln(FileId, '[' + Section + ']');

  for Index := 1 to m_ParameterList.Count do
  begin
    Item := m_ParameterList.Items[Index-1] ;
    Item.Group := Section;
    if (Item.SectionParameterType = ptSectionReadWrite) or (Item.SectionParameterType = ptSectionWrite) then
      Item.WriteValueToSetting(fileId);
  end ;

  // Append a blank line at the end of the section
  Writeln(FileId, ' ');

  CloseFile(fileId);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Setting' Parameters.    Write settings in ini file format.
// Inputs:       Filename - full pathname of file to write to
//               Section - section name
//               bAppend - if true, append settings to file; otherwise rewrite the file
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteSectionParametersSafe(Filename: String; Section: String; bAppend: Boolean) ;
var
  iniFile: TMemIniFile;
  index: Integer ;
  item: TParameter ;
begin
  // Open ini file
  iniFile := TMemIniFile.Create(FileName);

  try
    // Cleanup previous section information, as needed
    if (bAppend = False) and iniFile.SectionExists(Section) then
      iniFile.EraseSection(Section);

    for index := 1 to m_ParameterList.Count do
    begin
      item := m_ParameterList.Items[index-1] ;
      item.Group := Section;
      if (item.SectionParameterType = ptSectionReadWrite) or (item.SectionParameterType = ptSectionWrite) then
        item.WriteValueToSetting(iniFile);
    end ;

    // Flush the memory ini file
    iniFile.UpdateFile();
  finally
    if assigned(iniFile) then
      iniFile.Free ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Caption' Parameters.    Write settings in ini file format.
// Inputs:       Filename - full pathname of file to write to
//               bAppend - if true, append settings to file; otherwise rewrite the file
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteCaptionParameters(Filename: String) ;
var
  iniFile: TMemIniFile;
  index: Integer ;
  item: TParameter ;
begin
  // Open ini file
  iniFile := TMemIniFile.Create(FileName);

  try
    // Cleanup previous section information, as needed
    if iniFile.SectionExists(DocName) then
      iniFile.EraseSection(DocName);

    for index := 1 to m_ParameterList.Count do
    begin
      item := m_ParameterList.Items[index-1] ;
      item.Group := DocName;
      item.WriteCaptionToSetting(iniFile);
    end ;

    // Flush the memory ini file
    iniFile.UpdateFile();
  finally
    if assigned(iniFile) then
      iniFile.Free ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write 'Caption' Parameters.    Write settings in ini file format.
// Inputs:       Filename - full pathname of file to write to
//               bAppend - if true, append settings to file; otherwise rewrite the file
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteHintParameters(Filename: String) ;
var
  iniFile: TMemIniFile;
  index: Integer ;
  item: TParameter ;
begin
  // Open ini file
  iniFile := TMemIniFile.Create(FileName);

  try
    // Cleanup previous section information, as needed
    if iniFile.SectionExists(DocName) then
      iniFile.EraseSection(DocName);

    for index := 1 to m_ParameterList.Count do
    begin
      item := m_ParameterList.Items[index-1] ;
      item.Group := DocName;
      item.WriteHintToSetting(iniFile);
    end ;

    // Flush the memory ini file
    iniFile.UpdateFile();
  finally
    if assigned(iniFile) then
      iniFile.Free ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write a tag-value to a settings file 'i.e INI file'.
// Inputs:       Filename - String
//               Section - String
//               Tag - String
//               Value - String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteParameter(Filename: String; Tag: String; Value: String);
begin
  WriteParameter(Filename, DocName, Tag, Value);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write a tag-value to a settings file 'i.e INI file'.
// Inputs:       Filename - String
//               Section - String
//               Tag - String
//               Value - String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteParameter(Filename: String; Parameter: TParameter; Value: String);
begin
  WriteParameter(Filename, DocName, Parameter.Name, Value);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write a tag-value to a settings file 'i.e INI file'.
// Inputs:       Filename - String
//               Section - String
//               Tag - String
//               Value - String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteParameter(Filename: String; Section: String; Tag: String; Value: String);
var
  iniFile: TIniFile;
begin
  // Check that the file exists
  if (FileExists(GetSettingFilename(Filename)) = True) then
  begin
    // Open file
    iniFile := TIniFile.Create(GetSettingFilename(Filename));

    // Read value
    iniFile.WriteString(Section, Tag, Value);

    // Cleanup
    iniFile.Free ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write a tag-value to a settings file 'i.e INI file'.
// Inputs:       Filename - String
//               Section - String
//               Tag - String
//               Value - String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteParameter(Filename: String; Section: String; Tag: String; Parameter: TParameter);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(GetSettingFilename(Filename));
  try
    Parameter.Group := Section;
    Parameter.WriteValueToSetting(iniFile, Tag);
    iniFile.UpdateFile();
  finally
    iniFile.Free ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy 'Settings' Parameters.
// Inputs:       FromFileName as String; ToFileName as String;
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.CopySettingParameters(FromFileName, ToFileName: String; Overwrite: Boolean);
var
  readIniFile: TMemIniFile;
  writeIniFile: TIniFile;
  Index: Integer;
  Item: TParameter;
begin
  writeIniFile := TIniFile.Create(ToFileName);
  if (writeIniFile.SectionExists(DocName) = False) or (Overwrite = True) then
  begin
    writeIniFile.EraseSection(DocName);

    readIniFile := TMemIniFile.Create(FromFileName);

    for Index := 1 to m_ParameterList.Count do
    begin
      Item := m_ParameterList.Items[Index-1] ;
      Item.Group := DocName;
      if (Item.ParameterType = ptSettings) or (Item.ParameterType = ptSettingsReadOnly) then
        Item.CopyValueFromSetting(readIniFile, writeIniFile);
    end;
    readIniFile.Free();
  end;
  writeIniFile.Free();
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the system level for the doc, and all of the TParameters
//                contained in the doc.
// Inputs:       SystemLevel - TUserLevel
// Outputs:      None
// Note:         Each TParameter will compare the current system level
//                against an it's own user level to determine if the
//                parameter should be enabled/disabled.  The refreshing of
//                the UI control will be handled by an override SetSystemLevel
//                call in the derived doc class, which should include a
//                UpdateAllViews() call.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SetSystemLevel(SystemLevel: TUserLevel) ;
var
  Index: Integer ;
  Item: TParameter ;
begin
  m_SystemLevel := SystemLevel;

  for Index := 0 to m_ParameterList.Count - 1 do
  begin
    Item := m_ParameterList.Items[Index] ;
    Item.SystemLevel := m_SystemLevel;
  end ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update the mask using the mask change information.
// Inputs:       MaskInOut - Integer
//               MaskMode - TMaskMode
//               MaskChange - Integer
// Outputs:      None
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SetMask(var MaskInOut: Integer; MaskMode: TMaskMode; MaskChange: Integer);
begin
  if MaskMode = maskModeSet then
    MaskInOut := MaskChange
  else if MaskMode = maskModeInclude then
    MaskInOut := MaskInOut or MaskChange
  else if MaskMode = maskModeExclude then
    MaskInOut := MaskInOut and (not MaskChange);
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the application(i.e. local) masking for the doc, then set
//                the application masking stored within each TParameter member
//                variable.
//               Mask - Integer
// Outputs:      None
// Note:         Each TParameter will compare the current local mask
//                against an it's own local mask to determine if the
//                parameter should be enabled/visible.  The UI should be able to
//                refresh the enabled/visible states without an override method.
//                This is different that the SetSystemMask() method.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SetLocalMask(MaskMode: TMaskMode; Mask: Integer);
var
  Index: Integer;
  Item: TParameter;
begin
  SetMask(m_LocalMask, MaskMode, Mask);

  for Index := 0 to m_ParameterList.Count - 1 do
  begin
    Item := m_ParameterList.Items[Index];
    Item.MaskLocal := m_LocalMask;
  end ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the system masking for the doc, then broadcast the system masking
//                to all cods.
// Inputs:       MaskMode - TMaskMode
//               Mask - Integer
// Outputs:      None
// Note:         Each TParameter will compare the current system mask
//                against an it's own system mask(and/or/not) to determine if the
//                parameter should be enabled/visible.  The refreshing of
//                the UI control will be handled by an override SetSystemMask
//                call in the derived doc class, which should include a
//                UpdateAllViews() call.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SetSystemMask(MaskMode: TMaskMode; Mask: Integer);
begin
  SetMask(m_SystemMask, MaskMode, Mask);

  // Notify all of the docs (including this one) of the system mask change
  if Assigned(m_SystemMaskChanged)  then
    m_SystemMaskChanged(Self);
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the system masking for the doc, then set the system masking
//                stored within each TParameter member variable.
// Inputs:       Mask - Integer
// Outputs:      None
// Note:         Each TParameter will compare the current system mask
//                against an it's own system mask(and/or/not) to determine if the
//                parameter should be enabled/visible.  The refreshing of
//                the UI control will be handled by an override SetSystemMask
//                call in the derived doc class, which should include a
//                UpdateAllViews() call.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.SetSystemMaskChanged(Mask: Integer);
var
  index: Integer;
  item: TParameter;
begin
  m_SystemMask := Mask;

  for index := 0 to m_ParameterList.Count - 1 do
  begin
    item := m_ParameterList.Items[index];
    item.MaskSystem := m_SystemMask;
  end ;
end ;

procedure TPhiDoc.Highlight(HightlightType: String; UpdateUI: Boolean);
var
  index: Integer;
  item: TParameter;
begin
  for index := 0 to m_ParameterList.Count - 1 do
  begin
    item := m_ParameterList.Items[index];

    if (HightlightType = c_docHighlight_Properties) and (item.ParameterTypeProperties) then
      item.Highlight := True
    else if (HightlightType = c_docHighlight_Settings) and (item.ParameterTypeSettings) then
      item.Highlight := True
    else if (HightlightType = c_docHighlight_History) and (item.ParameterTypeHistory) then
      item.Highlight := True
    else if (HightlightType = c_docHighlight_Polarity) and (item.ParameterTypePolarity) then
      item.Highlight := True
    else if (HightlightType = c_docHighlight_Wobble) and (item.ParameterTypeWobble) then
      item.Highlight := True
    else if (HightlightType = c_docHighlight_Outgas) and (item.ParameterTypeOutgas) then
      item.Highlight := True
    else if (HightlightType = c_docHighlight_Tune) and (item.ParameterTypeTune) then
      item.Highlight := True
    else if (HightlightType = c_docHighlight_All) then
    begin
      item.Highlight := True;
      if assigned(item.Readback) then
        item.Readback.Highlight := True;
    end
    else
    begin
      item.Highlight := False;
      if assigned(item.Readback) then
        item.Readback.Highlight := False;
    end;
  end ;

  if UpdateUI then
    UpdateAllViews(c_OnUpdateAll);
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add Parameter to the list of Hardware Parameters associated to
//               this view.
// Inputs:       HardwareParameter as TParameter
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.AddHardwareParameter(HardwareParameter: TParameter);
begin
  // Add the Parameter to list of Hardware Parameters
  if assigned(HardwareParameter) then
  begin
    m_HardwareParameterList.Add(HardwareParameter);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Remove a Parameter from the list of Hardware Parameters
///              associated to this view.
// Inputs:       Parameter as TParameter
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.RemoveHardwareParameter(HardwareParameter: TParameter);
begin
  // Remove the Hardware Parameter from the list.
  m_HardwareParameterList.Remove(HardwareParameter);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Clear the lists of Hardware Parameters.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.ClearHardwareParameter;
begin
  // Clear parameter list
  m_HardwareParameterList.Clear;
end;
     
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Log all hardware parameters to the output file.
// Inputs:       FileName - The file to log the values to.
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiDoc.WriteHardwareParameters(FileName: String);
var         
  fileId: TextFile;
  idx: Integer;
  item: TParameter;
begin
  // Check if there is something to write.
  if m_HardwareParameterList.Count > 0 then
  begin
    // Associate file variable fileId to the given property file name
    AssignFile(fileId, Filename);

    // Open the file for writing.
    if FileExists(Filename) then
      Append(fileId)
    else
      Rewrite(fileId);

    // Write section header
    Writeln(fileId, '[' + DocName + ']');

    for idx := 1 to m_HardwareParameterList.Count do
    begin
      item := m_HardwareParameterList.Items[idx-1];
      item.Group := DocName;
      item.WriteValueToSetting(fileId);
    end;

    // Append a blank line at the end of the section
    Writeln(FileId, ' ');

    CloseFile(fileId);
  end;
end;

end.
