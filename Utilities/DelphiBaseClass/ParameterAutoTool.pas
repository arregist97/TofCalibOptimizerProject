unit ParameterAutoTool;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterAutoTool.pas
// Created:   on 2.26.02 by John Baker
// Purpose:   ParameterAutoTool class is used to encapsulate automation requests
//             as an object.  See the 'Command Patterns' chapter in the Design Patterns
//             book.  Design Patterns by Gamma-Helm-Johnson-Vlissides(p.233).
//*********************************************************
// Copyright © 1999-2009 Physical Electronics, Inc.
// Created in 1999 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////
interface

uses
  Classes,
  StdCtrls,
  System.Contnrs,
  Parameter,
  ParameterData,
  ParameterSelectData,
  ParameterString;

{TParameterAutoTool}
const
  c_SummaryListDelimeter = ', ';
  c_SummaryTaskDelimeterStart = '';
  c_SummaryTaskDelimeterEnd = '';
  c_SummaryTaskDelimeter = ' || ';

  c_TaskDelimeterComma = ',';
  c_TaskDelimeterColon = ':';
  c_TaskDelimeterDash = ' - ';

  c_DataMangledNameFormat = 'm.d.yyyy.hh.nn.ss.zzz';

  c_InvalidTaskProgress = -1;

type
  TTaskStatus = (atIdle,
                  atWait,
                  atRun);

  TStopStatus = (atStopNone,
                  atStopAll,
                  atStopUntilNextPosition,
                  atStopUntilNextJob);

  TExecuteResult = (atExNone,
                  atExWait,
                  atExError);

  TAbortType = (atAbortTypeAbort,
                atAbortTypeStop);

  TAbortResult = (atAbortNone,
                  atAbortWait,
                  atAbortComplete);

  TCompleteResult = (atCompNone,
                  atCompError);

  TValidateStatus = (atvNone, atvValid, atvInValid, atvRequireConfirmation);
  TExecuteMode = (emNormal, emAlways);
  TAutoToolLogMessages = (atLogNone, atLogStatus, atLogApplicationLog, atLogReportAsWarning, atLogReportAsError, atLogDialog);
  TMessageType = set of atLogNone..atLogDialog;

  TAbortEvent = procedure(Sender: TObject; var Status: TAbortResult) of object;
  TAbort2Event = procedure(Sender: TObject; AbortType: TAbortType; var Status: TAbortResult) of object;
  TAddEvent = procedure(Sender: TObject; Data: TParameter; Recipe: String) of object;
  TCompleteEvent = procedure(Status: TCompleteResult) of object;
  TDataSetupEvent = procedure(Sender: TObject; Data: TParameter) of object;
  TEditEvent = procedure(Sender: TObject; Data: TParameter; Recipe: String; var Status: TExecuteResult) of object;
  TExecuteEvent = procedure(Sender: TObject; Data: TParameter; Recipe: String; var Status: TExecuteResult) of object;
  TLoadEvent = procedure(Sender: TObject; Data: TParameter; Recipe: String) of object;
  TProgressEvent = procedure(Sender: TObject) of object;
  TSaveEvent = procedure(Sender: TObject; Data: TParameter; Recipe: String) of object;
  TSummaryEvent = procedure(Sender: TObject; Data: TParameter; Summary: TParameter; Recipe: String) of object;
  TTaskSetupEvent = procedure(Sender: TObject; Data: TParameter) of object;
  TValidateEvent = procedure(Sender: TObject; SystemMask: TObject; Data: TParameter; var Status: TValidateStatus) of object;
  TValidate2Event = procedure(Sender: TObject; SystemMask: TObject; Data: TParameter; Recipe: String; var Status: TValidateStatus) of object;
  TLogMessageEvent = procedure(Sender: TObject; sMessageToLog: String; LogMessage: TMessageType) of object;
  TTaskTimeEvent = procedure(Sender: TObject; Data: TParameter; Time: TParameter) of object;

  TParameterAutoTool = class(TParameter)
  private
    m_Session: String ;
    m_TaskDescription: String ;
    m_TaskData: String ;
    m_TaskDelimeter: String ;
    m_TaskProgress: TParameterData ;
    m_ExecuteMode: TExecuteMode;
    m_RecipeIndex: Integer ;
    m_LoopCounterList: TList;
    m_LoopIndexList: TList;
    m_ExecuteStatus: TTaskStatus;
    m_StopStatus: TStopStatus;

    m_ConfirmationMsg: String; // In validation, some tasks require confirmation from users. Set validate status to atvRequireConfirmation and fill in confirm message.
    m_ErrorMsg: String; // Used to report an error message back to AutoTool

    m_OnAbortEvent: TAbortEvent;
    m_OnAbort2Event: TAbort2Event;
    m_OnAddEvent: TAddEvent;
    m_OnCompleteEvent: TCompleteEvent;
    m_OnDataSetupEvent: TDataSetupEvent;
    m_OnEditEvent: TEditEvent;
    m_OnExecuteEvent: TExecuteEvent;
    m_OnLoadEvent: TLoadEvent;
    m_OnProgressEvent: TProgressEvent;
    m_OnSaveEvent: TSaveEvent;
    m_OnSummaryEvent: TSummaryEvent;
    m_OnTaskSetupEvent: TTaskSetupEvent;
    m_OnValidateEvent: TValidateEvent;
    m_OnValidate2Event: TValidate2Event;
    m_OnLogMessageEvent: TLogMessageEvent;
    m_OnTaskTimeEvent: TTaskTimeEvent;

    m_QueueImageIndex: Integer;
    m_QueueSettingsPtrList: TObjectList;

    function GetTaskName: String;
    function GetLoopIndexList: TList;
    function GetLoopCounterList: TList;

    procedure SetSession(const Value: String);

    procedure AddQueueSettingsPtr(const Value: TObject);
  protected
    m_EstimatedTimeInSec: Double;

    procedure SetName(const Value: String); override;
    function GetEstimatedTimeInSec: Double; virtual;

    function GetDefaultSummary(Data: TParameter; Summary: TParameter; Recipe: String): String; virtual;
  public
    constructor Create(AOwner: TComponent) ; override ;
    destructor Destroy() ; override ;
    procedure Initialize(Sender: TParameter); override ;

    // Methods w/possible callbacks
    procedure Abort(AbortType: TAbortType; var Status: TAbortResult);
    procedure Add(Data: TParameter; Recipe: String);
    procedure Complete(Status: TCompleteResult = atCompNone);
    procedure Copy(Data: TParameter; FromRecipe: String; ToRecipe: String);
    procedure DataSetup(Data: TParameter);
    procedure ExecuteInit();
    procedure Edit(Data: TParameter; Recipe: String; var Status: TExecuteResult);
    procedure Execute(Data: TParameter; Recipe: String; var Status: TExecuteResult);
    procedure Load(Data: TParameter; Recipe: String; var Status: TExecuteResult);
    procedure Progress(fProgress: Double = c_InvalidTaskProgress);
    procedure Save(Data: TParameter; Recipe: String; var Status: TExecuteResult);
    procedure Summary(Data: TParameter; Summary: TParameter; Recipe: String);
    procedure TaskSetup(Data: TParameter);
    procedure Validate(SystemMask: TObject; Data: TParameter; Recipe: String; var Status: TValidateStatus);
    procedure UpdateTaskTime(Data: TParameter; Time: TParameter);

    // Properties which are used to hookup callbacks
    property OnAbort: TAbortEvent read m_OnAbortEvent write m_OnAbortEvent;
    property OnAbort2: TAbort2Event read m_OnAbort2Event write m_OnAbort2Event;
    property OnAdd: TAddEvent read m_OnAddEvent write m_OnAddEvent;
    property OnChange: TDataSetupEvent read m_OnDataSetupEvent write m_OnDataSetupEvent;
    property OnComplete: TCompleteEvent read m_OnCompleteEvent write m_OnCompleteEvent;
    property OnDropDown: TTaskSetupEvent read m_OnTaskSetupEvent write m_OnTaskSetupEvent;
    property OnEdit: TEditEvent read m_OnEditEvent write m_OnEditEvent ;
    property OnExecute: TExecuteEvent read m_OnExecuteEvent write m_OnExecuteEvent ;
    property OnLoad: TLoadEvent read m_OnLoadEvent write m_OnLoadEvent ;
    property OnProgress: TProgressEvent read m_OnProgressEvent write m_OnProgressEvent;
    property OnSave: TSaveEvent read m_OnSaveEvent write m_OnSaveEvent ;
    property OnSummary: TSummaryEvent read m_OnSummaryEvent write m_OnSummaryEvent;
    property OnValidate: TValidateEvent read m_OnValidateEvent write m_OnValidateEvent ;
    property OnValidate2: TValidate2Event read m_OnValidate2Event write m_OnValidate2Event ;
    property OnLogMessage: TLogMessageEvent read m_OnLogMessageEvent write m_OnLogMessageEvent ;
    property OnTaskTime: TTaskTimeEvent read m_OnTaskTimeEvent write m_OnTaskTimeEvent;

    property OnDataSetup: TDataSetupEvent read m_OnDataSetupEvent write m_OnDataSetupEvent ; // Obsolete - replaced by OnTaskDropDown()
    property OnTaskSetup: TTaskSetupEvent read m_OnTaskSetupEvent write m_OnTaskSetupEvent ; // Obsolete - replaced by OnTaskChange()

    // Error Reporting: All reporting goes through LogMessage()
    procedure ReportError(Value: String);
    procedure ReportWarning(Value: String);
    procedure ReportStatus(Value: String);
    procedure LogMessage(sMessageToLog: String; LogMessage: TMessageType = [atLogNone]);

    // Properties
    property Session: String read m_Session write SetSession;
    property TaskName: String read GetTaskName ;
    property TaskDescription: String read m_TaskDescription write m_TaskDescription ;
    property TaskData: String read m_TaskData write m_TaskData ;
    property TaskDelimeter: String read m_TaskDelimeter write m_TaskDelimeter ;
    property TaskProgress: TParameterData read m_TaskProgress;
    property ExecuteMode: TExecuteMode read m_ExecuteMode write m_ExecuteMode ;
    property RecipeIndex: Integer read m_RecipeIndex write m_RecipeIndex ;
    property LoopCounterList: TList read GetLoopCounterList;
    property LoopIndexList: TList read GetLoopIndexList;
    property ExecuteStatus: TTaskStatus read m_ExecuteStatus write m_ExecuteStatus ;
    property StopStatus: TStopStatus read m_StopStatus write m_StopStatus ;

    property ConfirmationMsg: String read m_ConfirmationMsg write m_ConfirmationMsg ;
    property ErrorMsg: String read m_ErrorMsg write m_ErrorMsg ;

    property EstimatedTimeInSec: Double read GetEstimatedTimeInSec write m_EstimatedTimeInSec;

    // Obsolete; Only here for backwards compatability
    property RecipeComment: String write ReportStatus ;
    property ErrorStatus: String write ReportError ;

    // Queue
    property ImageIndex: Integer read m_QueueImageIndex write m_QueueImageIndex;
    property SettingsPtr: TObject write AddQueueSettingsPtr;
    property SettingsPtrList: TObjectList read m_QueueSettingsPtrList;
  end ;

implementation

uses
  SysUtils,
  Dialogs;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterAutoTool.Create(AOwner: TComponent) ;
begin
  inherited Create(AOwner) ;

  // Initialize base class member variables
  m_UserLevelDisplay := ulDisplayVisible;

  // Initialize member variables
  m_Session := '';
  m_ExecuteMode := emNormal;
  m_RecipeIndex := c_InvalidIndex;
  m_LoopCounterList := nil;
  m_LoopIndexList := nil;
  m_StopStatus := atStopNone;
  m_ExecuteStatus := atIdle;

  m_ConfirmationMsg := c_InvalidString;
  m_ErrorMsg := 'Error';

  m_TaskDescription := c_InvalidString;
  m_TaskData := '';
  m_TaskDelimeter := c_TaskDelimeterDash;

  m_TaskProgress := TParameterData.Create(Self);
  m_TaskProgress.Hint := '' ;
  m_TaskProgress.Value := 0 ;
  m_TaskProgress.Precision := 0 ;
  m_TaskProgress.Min := 0.0 ;
  m_TaskProgress.Max := 10.0 ;
  m_TaskProgress.SmallIncrement := 1.0 ;
  m_TaskProgress.LargeIncrement := 10.0 ;

  m_EstimatedTimeInSec := 0.0;

  // Callbacks
  m_OnAbortEvent := nil;
  m_OnAbort2Event := nil;
  m_OnAddEvent := nil;
  m_OnCompleteEvent := nil;
  m_OnDataSetupEvent := nil;
  m_OnEditEvent := nil;
  m_OnExecuteEvent := nil;
  m_OnLoadEvent := nil;
  m_OnProgressEvent := nil;
  m_OnSaveEvent := nil;
  m_OnSummaryEvent := nil;
  m_OnTaskSetupEvent := nil;
  m_OnValidateEvent := nil;
  m_OnValidate2Event := nil;
  m_OnTaskTimeEvent := nil;

  m_QueueImageIndex := -1;
  m_QueueSettingsPtrList := TObjectList.Create();
  m_QueueSettingsPtrList.Capacity := 20;
  m_QueueSettingsPtrList.OwnsObjects := False;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy the memeber variables from the passed object
// Inputs:       TParameter.
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Initialize(Sender: TParameter) ;
begin
  inherited ;

  if (Sender is TParameterAutoTool) then
    begin
    m_Session := (Sender as TParameterAutoTool).m_Session;
    m_ExecuteMode := (Sender as TParameterAutoTool).m_ExecuteMode;
    m_OnAbortEvent := (Sender as TParameterAutoTool).m_OnAbortEvent;
    m_OnAbort2Event := (Sender as TParameterAutoTool).m_OnAbort2Event;
    m_OnAddEvent := (Sender as TParameterAutoTool).m_OnAddEvent;
    m_OnCompleteEvent := (Sender as TParameterAutoTool).m_OnCompleteEvent;
    m_OnDataSetupEvent := (Sender as TParameterAutoTool).m_OnDataSetupEvent;
    m_OnEditEvent := (Sender as TParameterAutoTool).m_OnEditEvent;
    m_OnExecuteEvent := (Sender as TParameterAutoTool).m_OnExecuteEvent;
    m_OnLoadEvent := (Sender as TParameterAutoTool).m_OnLoadEvent;
    m_OnProgressEvent := (Sender as TParameterAutoTool).m_OnProgressEvent;
    m_OnSaveEvent := (Sender as TParameterAutoTool).m_OnSaveEvent;
    m_OnSummaryEvent := (Sender as TParameterAutoTool).m_OnSummaryEvent;
    m_OnTaskSetupEvent := (Sender as TParameterAutoTool).m_OnTaskSetupEvent;
    m_OnValidateEvent := (Sender as TParameterAutoTool).m_OnValidateEvent;
    m_OnValidate2Event := (Sender as TParameterAutoTool).m_OnValidate2Event;
    m_OnTaskTimeEvent := (Sender as TParameterAutoTool).m_OnTaskTimeEvent;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Destructor.
// Inputs:       None.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TParameterAutoTool.Destroy() ;
begin
  if assigned(m_QueueSettingsPtrList) then
    m_QueueSettingsPtrList.Free();

  inherited Destroy ;
end ;

procedure TParameterAutoTool.AddQueueSettingsPtr(const Value: TObject);
begin
  // Protect against adding same object to the SettingsList; error message for developer only
  if m_QueueSettingsPtrList.IndexOf(Value) < 0 then
    m_QueueSettingsPtrList.Add(Value)
  else
    ShowMessage(TaskName + ': Duplicate setting entry added to the list');
end;

procedure TParameterAutoTool.ExecuteInit();
begin
  m_TaskProgress.Hint := '' ;
  m_TaskProgress.Value := 0 ;
  m_TaskProgress.Precision := 0 ;
  m_TaskProgress.Min := 0.0 ;
  m_TaskProgress.Max := 10.0 ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the 'Task' name.  This is the combination of m_Session
//               and m_Name
// Inputs:       None.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterAutoTool.GetTaskName: String;
begin
  if m_Session = '' then
    Result := Name
  else
    Result := m_Session + m_TaskDelimeter + Name;
end;

// GetLoopCounterList
function TParameterAutoTool.GetLoopCounterList: TList;
begin
  if not assigned(m_LoopCounterList) then
    m_LoopCounterList := TList.Create();
  Result := m_LoopCounterList
end;

// GetLoopIndexList
function TParameterAutoTool.GetLoopIndexList: TList;
begin
  if not assigned(m_LoopIndexList) then
    m_LoopIndexList := TList.Create();
  Result := m_LoopIndexList
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the estimated time for this task
// Inputs:       None.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterAutoTool.GetEstimatedTimeInSec: Double;
begin
    Result := m_EstimatedTimeInSec;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Override SetName() to default the TaskDescription to the parameter name.
//                For a unique task description (shown in the status dialog), it
//                must be set after the parameter name.
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.SetName(const Value: String);
begin
  inherited;

  m_TaskDescription := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the session name
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.SetSession(const Value: String);
begin
  m_Session := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Log an error messages
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.ReportError(Value: String);
begin
  LogMessage('Error: ' + Value, [atLogApplicationLog, atLogReportAsError]);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Log a warning messages
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.ReportWarning(Value: String);
begin
  LogMessage('Warning: ' + Value, [atLogApplicationLog, atLogReportAsWarning]);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add status to application log
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.ReportStatus(Value: String);
begin
  LogMessage(Value, [atLogApplicationLog]);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'LogMessage' handler.  This 'LogMessage' method callback is implemented
//               in the AutoToolDoc code, and is connected by assigning the m_OnLogMessageEvent
//               member variable to the associated 'LogMessage' method.  This a callback
//               is connected before the task is executed and is cleared immediately
//               after being called.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.LogMessage(sMessageToLog: String;
  LogMessage: TMessageType);
begin
  // Call setup routine when 'Task' value has changed
  if (Assigned(m_OnLogMessageEvent)) then
    m_OnLogMessageEvent(Self, sMessageToLog, LogMessage);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Abort' handler.  This 'Abort' method callback is implemented
//               in the application code, and is connected by assigning the m_OnAbortEvent
//               member variable to the associated 'Abort' method.
// Inputs:       None
// Outputs:      None
// Note:         The 'Abort' method is called when the recipe task is aborted.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Abort(AbortType: TAbortType; var Status: TAbortResult);
begin
  Status := atAbortComplete;

  // Abort the current task
  if (Assigned(m_OnAbort2Event)) then
    m_OnAbort2Event(Self, AbortType, Status)
  else if (Assigned(m_OnAbortEvent)) then
    m_OnAbortEvent(Self, Status);

  // Report to application log
  if Status = atAbortNone then
    LogMessage('Stop Request: Cleared', [atLogApplicationLog])
  else if Status = atAbortWait then
    LogMessage('Stop Request: Waiting', [atLogApplicationLog])
  else if Status = atAbortComplete then
    LogMessage('Stopped', [atLogApplicationLog]);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Add' handler.  This 'Add' method callback is implemented
//                in the application code, and is connected by assigning the m_OnAddEvent
//                member variable to the associated 'Add' method.
// Inputs:       None
// Outputs:      None
// Note:         'Add' allows an application to set default parameters when the
//                 task is added.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Add(Data: TParameter; Recipe: String);
begin
  if (Assigned(m_OnAddEvent)) then
    m_OnAddEvent(Self, Data, Recipe)
  else
  begin
    // Start w/an empty list if no event is connected
    TParameterSelectData(Data).Clear();

    // Set default value; this can be initialized in the docs during the creation of the TParameterAuto
    TParameterSelectData(Data).Value := m_TaskData;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Complete' handler.  This 'Complete' method callback is implemented
//               in the AutoToolDoc code, and is connected by assigning the m_OnCompleteEvent
//               member variable to the associated 'Complete' method.  This a callback
//               is connected before the task is 'Executed' and is cleared immediately
//               after being called.
// Inputs:       None
// Outputs:      None
// Note:         The 'Complete' method is called when the recipe task is completed.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Complete(Status: TCompleteResult);
var
  completeCallbackPtr: TCompleteEvent;
begin
  // Disconnect from the complete() event first; guarentees that complete event is only called once
  if Assigned(m_OnCompleteEvent) then
  begin
   // Hold a temporary copy of the callback
    completeCallbackPtr := m_OnCompleteEvent;

    // nill complete events
    m_OnCompleteEvent := nil;

    // Set the progress to complete
    Progress(m_TaskProgress.Max);

    // Report any error to application log before calling; as the error is handled in complete
    if Status = atCompError then
      LogMessage('Complete: Error', [atLogApplicationLog]);

    // Disconnect progress and message events
    m_OnProgressEvent := nil;
    m_OnLogMessageEvent := nil;

    // Call Complete()
    completeCallbackPtr(Status);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Add' handler.  This 'Add' method callback is implemented
//                in the application code, and is connected by assigning the m_OnAddEvent
//                member variable to the associated 'Add' method.
// Inputs:       None
// Outputs:      None
// Note:         'Add' allows an application to set default parameters when the
//                 task is added.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Copy(Data: TParameter; FromRecipe: String; ToRecipe: String);
var
  Status: TExecuteResult;
begin
  Status := atExNone;

  if (Assigned(m_OnEditEvent)) then
    m_OnEditEvent(Self, Data, FromRecipe, Status);

  if (Assigned(m_OnSaveEvent)) then
    m_OnSaveEvent(Self, nil, ToRecipe);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'DataSetup' handler.  This 'DataSetup' method callback is implemented
//               in the application code, and is connected by assigning the m_OnDataSetupEvent
//               member variable to the associated 'DataSetup' method.
// Inputs:       None
// Outputs:      None
// Note:         'Data Setup' allows the application to perform some special processing
//               in order to select the current 'Data' option (e.g Display a file dialog
//               box in order to select a file name).
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.DataSetup(Data: TParameter);
begin
  // Call setup routine when 'Data' value has changed
  if (Assigned(m_OnDataSetupEvent)) then
    m_OnDataSetupEvent(Self, Data);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Edit' handler.  This 'Execute' method callback is implemented
//               in the application code, and is connected by assigning the m_OnExecuteEvent
//               member variable to the associated 'Execute' method.
// Inputs:       None
// Outputs:      None
// Note:         The 'Execute' method is called when the recipe task is run.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Edit(Data: TParameter; Recipe: String; var Status: TExecuteResult);
begin
  // Call Edit()
  if (Assigned(m_OnEditEvent)) then
    m_OnEditEvent(Self, Data, Recipe, Status);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Execute' handler.  This 'Execute' method callback is implemented
//               in the application code, and is connected by assigning the m_OnExecuteEvent
//               member variable to the associated 'Execute' method.
// Inputs:       None
// Outputs:      None
// Note:         The 'Execute' method is called when the recipe task is run.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Execute(Data: TParameter; Recipe: String; var Status: TExecuteResult);
var
  validExecute: Boolean;
begin
  Status := atExNone;

  // Check if a stop has been initiated, and see if this task is to be executed regardless
  validExecute := False;
  if (m_StopStatus = atStopNone) then
    validExecute := True
  else if (m_ExecuteMode = emAlways) then
    validExecute := True;

  if validExecute then
  begin
    // Report to application log, log task name only (which is automatic), as Execute() is implied
    LogMessage('', [atLogApplicationLog]);

    // Call Execute()
    if (Assigned(m_OnExecuteEvent)) then
      m_OnExecuteEvent(Self, Data, Recipe, Status);

    // Report 'Error' or 'Waiting' status to application log
    if Status = atExWait then
      LogMessage('Waiting', [atLogApplicationLog])
    else if Status = atExError then
      LogMessage('Error', [atLogApplicationLog]);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Edit' handler.  This 'Execute' method callback is implemented
//               in the application code, and is connected by assigning the m_OnExecuteEvent
//               member variable to the associated 'Execute' method.
// Inputs:       None
// Outputs:      None
// Note:         The 'Execute' method is called when the recipe task is run.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Load(Data: TParameter; Recipe: String; var Status: TExecuteResult);
begin
  // Call Load()
  if (Assigned(m_OnLoadEvent)) then
    m_OnLoadEvent(Self, Data, Recipe);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Progress' handler.  This 'Progress' method callback is implemented
//               in the AutoToolDoc code, and is connected by assigning the m_OnProgressEvent
//               member variable to the associated 'Progress' method.  This a callback
//               is connected before the task is 'Executed' and is cleared following
//               the completion.
// Inputs:       None
// Outputs:      None
// Note:         The 'Complete' method is called when the recipe task is completed.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Progress(fProgress: Double);
begin
  if fProgress <> c_InvalidTaskProgress then
    m_TaskProgress.Value := fProgress;

  if Assigned(m_OnProgressEvent) then
    m_OnProgressEvent(Self);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Edit' handler.  This 'Execute' method callback is implemented
//               in the application code, and is connected by assigning the m_OnExecuteEvent
//               member variable to the associated 'Execute' method.
// Inputs:       None
// Outputs:      None
// Note:         The 'Execute' method is called when the recipe task is run.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Save(Data: TParameter; Recipe: String; var Status: TExecuteResult);
begin
  // Call Save()
  if (Assigned(m_OnSaveEvent)) then
    m_OnSaveEvent(Self, Data, Recipe);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Summary' handler.  This Summary() method callback is implemented
//               in the application code, and is connected by assigning the m_OnSummaryEvent
//               member variable to the associated 'Summary' method.
// Inputs:       None
// Outputs:      None
// Note:         'Summary' allows the application to create a short summary string which details the selection.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Summary(Data: TParameter; Summary: TParameter; Recipe: String);
begin
  if (Assigned(m_OnSummaryEvent)) then
    m_OnSummaryEvent(Self, Data, Summary, Recipe)
  else
    // No callback is conneted
    TParameterString(Summary).Value := GetDefaultSummary(Data, Summary, Recipe);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return a default string for summary
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterAutoTool.GetDefaultSummary(Data: TParameter; Summary: TParameter; Recipe: String): String;
begin
  // default to data value
  Result := Data.ValueAsString;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'TaskSetup' handler.  This 'TaskSetup' method callback is implemented
//               in the application code, and is connected by assigning the m_OnTaskSetupEvent
//               member variable to the associated 'TaskSetup' method.
// Inputs:       None
// Outputs:      None
// Note:         'Task Setup' allows the application to create the list of 'Data' options.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.TaskSetup(Data: TParameter);
begin
  if (Assigned(m_OnTaskSetupEvent)) then
  begin
    // Default the list to a alpha sort, individual TaskSetup() will change if needed
    TParameterSelectData(Data).Sorted := stNone;

    m_OnTaskSetupEvent(Self, Data);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Validate' handler.  This 'Validate' method callback is implemented
//               in the application code, and is connected by assigning the m_OnValidateEvent
//               member variable to the associated 'Validate' method.
// Inputs:       SystemMask - keep track of the system states; used to determine if
//                            a given task is valid.
//               Data - data for a task (e.g. setting name for a load task)
//               Recipe - recipe pathname
//               Status - Is the task valid?
// Outputs:      None
// Note:         The 'Validate' method is called to validate a receipe.  So it can be
//               called when a task is added/edited and before running a recipe.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.Validate(
  SystemMask: TObject;
  Data: TParameter;
  Recipe: String;
  var Status: TValidateStatus
);
begin
  // default to valid
  Status := atvValid;

  // Validate the task if a validate method is provided
  if (Assigned(m_OnValidate2Event)) then
    m_OnValidate2Event(Self, SystemMask, Data, Recipe, Status)
  else if (Assigned(m_OnValidateEvent)) then
    m_OnValidateEvent(Self, SystemMask, Data, Status);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Default 'Update Task Time' handler.  This TaskTime() method callback is implemented
//               in the application code, and is connected by assigning the m_OnTaskTimeEvent
//               member variable to the associated 'TaskTime' method.
// Inputs:       Data - data for a task (e.g. setting name for a load task)
//               Time - Date/Time Parameter reference
// Outputs:      None
// Note:         'UpdateTaskTime' allows the application to calculate an estimated task
//               time for the autotool task to complete.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterAutoTool.UpdateTaskTime(Data: TParameter; Time: TParameter);
begin
  if (Assigned(m_OnTaskTimeEvent)) then
    m_OnTaskTimeEvent(Self, Data, Time);
end;

end.


