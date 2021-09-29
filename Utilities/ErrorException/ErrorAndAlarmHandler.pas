unit ErrorAndAlarmHandler;

interface

uses
  ActiveX,
  Classes,
  Contnrs,
  EventPoint,
  EventPointTypes,
  ObjectPhi,
  PhiErrorCodes,
  PhiExceptions,
  StandardErrorCodes,
  SyncObjectPhi,
  SYSLOGQUEUELib_TLB,
  PhiUtils;

const
  ERROR_AND_ALARM_HANDLER_NAME = 'ErrorAndAlarmHandler';

  NO_ALARM = -1;   // Alarm ID value in lookup table that signifies no alarm should
                   //  be raised.

type  // Move these to PhiExceptions
  EAlarmClearedNotActive = class(EPhiSoftware);
  EErrorAndAlarmHandlerError = class(EPhiSoftware);

  TAlarmClearAction = (acNone, acAbort, acRetry, acContinue);

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TAlarm class.
//
////////////////////////////////////////////////////////////////////////////////

  TAlarm = class(TObject)
  private
    FAlarmID: Integer;
    FDescription: String;
  protected
  public
    property AlarmID: Integer read FAlarmID write FAlarmID;
    property Description: String read FDescription write FDescription;
  end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TError class.
//
////////////////////////////////////////////////////////////////////////////////

  TError = class(TObject)
  private
    FErrorCode: HResult;
    FDescription: String;
  protected
  public
    property ErrorCode: HResult read FErrorCode write FErrorCode;
    property Description: String read FDescription write FDescription;
  end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TLookup class.
//
////////////////////////////////////////////////////////////////////////////////

  TLookup = class(TObject)
  private
    FErrorCode: HResult;
    FAlarmID: Integer;
  protected
  public
    property ErrorCode: HResult read FErrorCode write FErrorCode;
    property AlarmID: Integer read FAlarmID write FAlarmID;
  end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TErrorAndAlarmHandler class.
//
////////////////////////////////////////////////////////////////////////////////

  TErrorAndAlarmHandler = class(TPhiSyncObject)
  private
    FEventContainer: TThreadSafeEventContainer;
    FActiveAlarms: TList;
    FPhiAlarmList: TObjectList;
    FPhiErrorList: TObjectList;
    FPhiLookupTable: TObjectList;
    FReportedErrorsCachedAtStartupList: TObjectList;
    //There is a period after this unit is initialized but before the
    //AlarmLookupTable is loaded that errors may be reported but alarms
    //cannot yet be raised. This member variable is used to 'cache' reported
    //errors during this period so that we can raise alarms if necessary.

    FAlarmIdForUnrecognizedErrors: Integer;
    FHandlingInternalError: boolean;

    function GetStringFromPhiAlarm(const AlarmID: Integer): String;
    function GetActiveAlarmIndex(const AlarmID: Integer): Integer;
    function GetPhiAlarmCount: Integer;
    function GetPhiAlarm(Index: Integer): TAlarm;
    function GetPhiErrorCount: Integer;
    function GetPhiError(Index: Integer): TError;
    function GetPhiLookupCount: Integer;
    function GetCachedReportedError(Index: Integer): TError;
    function GetPhiLookup(Index: Integer): TLookup;
    procedure LoadPhiErrors;
    procedure LoadStandardErrors;
    procedure LoadDefaultLookupTable;
    function  GetLookupTableEntry(const ErrorCode: HResult): TLookup;  // Returns AlarmID
    procedure HandleInternalError(const ObjectName: string;
            const Level: TErrorLevel; const Message: string; ErrorCode: HRESULT;
            const Source, HelpFile: string; HelpContext: Integer);
  protected
    procedure Lock(methodName: string);
    procedure Unlock;

  public
    constructor Create(Str: string); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure DeInitialize(); override;

    // singleton pattern: use this to retrieve an instance of error and alarm
    // handler
    class function GetInstance: TErrorAndAlarmHandler;

    procedure ReportError(const ObjectName: string; const Level: TErrorLevel;
                          const ErrorCode: Integer; const Description: String);
    procedure AlarmClear(const AlarmID: Integer; const Action: TAlarmClearAction);
    procedure AbortProcessing;

    property ActiveAlarms: TList read FActiveAlarms;
    // Set the alarm ID in the lookup table for ErrorCode
    procedure SetPhiLookup(const ErrorCode: HResult; const AlarmID: Integer);
    procedure LookupTableHasBeenInitialized;//external signal that table is loaded.
    property AlarmIdForUnrecognizedErrors: Integer read FAlarmIdForUnrecognizedErrors
                                                   write FAlarmIdForUnrecognizedErrors;

    property PhiAlarmCount: Integer read GetPhiAlarmCount;
    property PhiAlarms[Index: Integer]: TAlarm read GetPhiAlarm;
    property PhiErrorCount: Integer read GetPhiErrorCount;
    property PhiErrors[Index: Integer]: TError read GetPhiError;
    property PhiLookupCount: Integer read GetPhiLookupCount;
    property PhiLookups[Index: Integer]: TLookup read GetPhiLookup;
    function GetStringFromPhiError(const ErrorCode: HResult): String;

    property EventContainer: TThreadSafeEventContainer read FEventContainer;
  end;


////////////////////////////////////////////////////////////////////////////////
//
// interface for the TAlarmEvent class.
//
////////////////////////////////////////////////////////////////////////////////

  // date structure to hold event data.
  TAlarmEventData = record
    AlarmID: Integer;
    Description: array [0..255] of char;
  end;

  TOnAlarmEvent = procedure (Sender: TObject; AlarmID: Integer; Description: String) of object;

  TAlarmEvent = class(TEventClient)
  private
  protected
    // Atrributes
    FOnEvent : TOnAlarmEvent;
  public
    // class functions
    class procedure SetData(EventPoint: TEventPoint; AlarmID: Integer;
                            Description: String); overload;
    // Operations
    procedure NewEvent(AlarmID: Integer; Description: String); overload;
    // overrides
    procedure CallEvent(ClientData: pointer); override;
  published
    // properties
    property OnEvent : TOnAlarmEvent read FOnEvent write FOnEvent;
  end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TErrorEvent class.
//
////////////////////////////////////////////////////////////////////////////////

TErrorEvent = class(TAlarmEvent);

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TAbortProcessingEvent class.
//
////////////////////////////////////////////////////////////////////////////////

TAbortProcessingEvent = class(TNullEvent);


////////////////////////////////////////////////////////////////////////////////
//
// interface for the TAlarmClearedActionEvent class.
//
////////////////////////////////////////////////////////////////////////////////

  // date structure to hold event data.
  TAlarmClearedData = record
    AlarmID: Integer;
    Action: TAlarmClearAction;
  end;

  TOnAlarmClearedActionEvent = procedure (Sender: TObject; AlarmID: Integer;
                                          Action: TAlarmClearAction) of object;

  TAlarmClearedActionEvent = class(TEventClient)
  private
  protected
    // Atrributes
    FOnEvent : TOnAlarmClearedActionEvent;
  public
    // class functions
    class procedure SetData(EventPoint: TEventPoint; AlarmID: Integer;
                            Action: TAlarmClearAction); overload;
    // Operations
    procedure NewEvent(AlarmID: Integer; Action: TAlarmClearAction); overload;
    // overrides
    procedure CallEvent(ClientData: pointer); override;
  published
    // properties
    property OnEvent : TOnAlarmClearedActionEvent read FOnEvent write FOnEvent;
  end;

implementation

uses
  ComObj,
  Dialogs,
  Forms,
  registry,
  SysUtils,
  Windows,
  SysLogQueue;

var
  // Delphi doesn't support class variables so emulate the effect by declaring
  // a variable that is private to this unit
  s_ErrorAndAlarmHandlerInstance: TErrorAndAlarmHandler = nil;

{ TErrorAndAlarmHandler }

constructor TErrorAndAlarmHandler.Create(Str: string);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  inherited Create(ERROR_AND_ALARM_HANDLER_NAME);

  FHandlingInternalError := false;

  FAlarmIdForUnrecognizedErrors:= NO_ALARM;

  TraceLog(traceOff, 'Create ErrorAndAlarmHandler');

  // Create lists for Phi alarms and errors.  Lists get set in initialize.
  FPhiAlarmList:= TObjectList.Create;
  FPhiErrorList:= TObjectList.Create;
  FPhiLookupTable := TObjectList.Create();
  FReportedErrorsCachedAtStartupList:= TObjectList.Create;

  Lock('Create');
  try
    FActiveAlarms:= TList.Create;
    // Create the eventContainer
    FEventContainer := TThreadSafeEventContainer.Create();

    // Create the published event points.
    FEventContainer.CreateEventPoint(TAlarmEvent, epMulti, nil);
    FEventContainer.CreateEventPoint(TAlarmClearedActionEvent, epMulti, nil);
    FEventContainer.CreateEventPoint(TAbortProcessingEvent, epMulti, nil);
    FEventContainer.CreateEventPoint(TErrorEvent, epMulti, nil);

  finally
    Unlock();
  end;
end;


class function TErrorAndAlarmHandler.GetInstance: TErrorAndAlarmHandler;
////////////////////////////////////////////////////////////////////////////////
// Description:  Get an instance of error and alarm handler
//               singleton object.
// Inputs:       None
// Outputs:      None
// Return:       an instance of error and alarm handler; nil if not created
// Note:         Assume object manager creates it at startup
////////////////////////////////////////////////////////////////////////////////
begin
  Result := s_ErrorAndAlarmHandlerInstance;
end;

destructor TErrorAndAlarmHandler.Destroy;
////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
var
  ix: Integer;
begin
  TraceLog(traceOff, 'Destroy ErrorAndAlarmHandler');

  // Protect against rouge threads.
  Lock('Destroy');
  try
    // Cleanup members.
   FEventContainer.Free;
   FEventContainer := nil;

    for ix:= 0 to FActiveAlarms.Count - 1 do
    begin
      TAlarm(FActiveAlarms.Items[ix]).Free;
    end;
    // FActiveAlarms, FPhiAlarmList, FPhiErrorList, FPhiLookupTable and  FReportedErrorsCachedAtStartupList
    // are TObjectList and we don't need to explicitly free the objects in the lists.
    FActiveAlarms.Free;
    FActiveAlarms := nil;
    FPhiAlarmList.Free;
    FPhiAlarmList := nil;
    FPhiErrorList.Free;
    FPhiErrorList := nil;
    FPhiLookupTable.Free;
    FPhiLookupTable := nil;

    if Assigned(FReportedErrorsCachedAtStartupList) then
    begin
      FReportedErrorsCachedAtStartupList.Free;
      FReportedErrorsCachedAtStartupList := nil;
    end;

  finally
    Unlock();
  end;

  inherited;
end;

procedure TErrorAndAlarmHandler.AbortProcessing;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Abort any processing currently being carried out.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  TraceLog(traceDiagnose, 'AbortProcessing');

  //Broadcast the abort notification.  Can be done from any thread.
  TraceLog(traceDebug, 'Fire abort processing event');
  try
    FEventContainer.FireEvents(TAbortProcessingEvent);
  except
    on E:Exception do
    begin
      ErrorLog(errorNormal, EAAH_EVENT_NOTIFY_FAIL, 'AbortProcessing notify failed');
      Raise E; //re-raise
    end;
  end;

end;

procedure TErrorAndAlarmHandler.AlarmClear(const AlarmID: Integer;
                                           const Action: TAlarmClearAction);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Clear a currently active alarm.
// Inputs:       AlarmID - the ID of the active alarm to clear.
//               Action - the action to take in clearing the alarm
// Outputs:      None
// Exceptions:   EErrorAndAlarmHandler, EAAH_INVALID_PHI_ALARM_ERROR
//               EAlarmClearedNotActive, EAAH_ALARM_CLEARED_NOT_ACTIVE_ERROR
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  ep: TEventPoint;
  alarm: TAlarm;
  ix: Integer;
  str,actionStr: String;
begin
  if Action = acAbort then
    actionStr:= 'Abort'
  else if Action = acRetry then
    actionStr:= 'Retry'
  else if Action = acContinue then
    actionStr:= 'Continue'
  else
    actionStr:= 'Unknown';
  TraceLog(traceDiagnose, 'AlarmClear AlarmID:' + IntToStr(AlarmID) + ' Action:' + actionStr);

  // If the AlarmID is not a Phi defined alarm, raise an exception.  Use call
  //  to GetStringFromPhiAlarm to do this.
  str:= GetStringFromPhiAlarm(AlarmID);

  Lock('AlarmClear');
  try
    //If the alarm referenced by the alarm ID is not active, raise an
    //  EAlarmClearedNotActive error.
    ix:= GetActiveAlarmIndex(AlarmID);
    if ix = -1 then
    begin
      TraceLog(traceDebug, 'Cleared AlarmID is not active (Ignored)');
      Exit;
      {MP may clear an alarm that is not in our ActiveAlarm list.  This is
      an expected behavior, indicating that an alarm unrelated to our
      PM was raised and cleared.  (MP notifies us when any alarm is cleared,
      even if it did not originate from our PM1). -rich register 6/02}
    end;
    //Remove the alarm from the list of active alarms
    alarm:= TAlarm(FActiveAlarms.Items[ix]);
    alarm.Free;
    FActiveAlarms.Delete(ix);
  finally
    UnLock;
  end;

  //then an AlarmClearedActionEvent will be broadcast.
    ep:= FEventContainer.FindEventPoint(TAlarmClearedActionEvent);
    TAlarmClearedActionEvent.SetData(ep, AlarmID, Action);
    TraceLog(traceDebug, 'Fire alarm clear event');
  try
    FEventContainer.FireEvents(TAlarmClearedActionEvent);
  except
    on E:Exception do
    begin
      ErrorLog(errorNormal, EAAH_EVENT_NOTIFY_FAIL, 'AlarmClearedAction notify failed');
      Raise E; //re-raise
    end;
  end;

end;

procedure TErrorAndAlarmHandler.HandleInternalError(const ObjectName: string;
  const Level: TErrorLevel; const Message: string; ErrorCode: HRESULT;
  const Source, HelpFile: string; HelpContext: Integer);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Handles errors internal to the Error and Alarm Handler
//              The main point is not to allow exception escape, or call
//              ReportError repeatedly
//              since this error indicates that the error reporting code itself
//              is broken
// Inputs:       ObjectName
//               Level
//               Message
//               ErrorCode
//               Source
//               HelpFile
//               HelpContext
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  if not FHandlingInternalError then
  begin
    FHandlingInternalError := true;
    ReportError(ObjectName, Level, ErrorCode, '*Internal Error*' + Message);
    FHandlingInternalError := false;
  end;
end;

function TErrorAndAlarmHandler.GetActiveAlarmIndex(const AlarmID: Integer): Integer;
////////////////////////////////////////////////////////////////////////////////
// Description:  Returns the index of the active alarm in the FActiveAlarms list
//                 if active.  Returns -1 if the alarm is not in the active list.
// Inputs:       AlarmID - Alarm ID to check for
// Outputs:
// Note:         This routine needs to be called from within a Lock; and UnLock;
//                 call since it is not thread safe as written.
////////////////////////////////////////////////////////////////////////////////
var
  ix: Integer;
  found: Boolean;
begin
  ix:= 0;
  found:= False;
  Result:= -1;
  while (not found) and (ix < FActiveAlarms.Count) do
  begin
    if AlarmID = TAlarm(FActiveAlarms.Items[ix]).AlarmID then
    begin
      found:= True;
      Result:= ix;
    end;
    inc(ix);
  end;
end;


function TErrorAndAlarmHandler.GetLookupTableEntry(const ErrorCode: HResult): TLookup;
////////////////////////////////////////////////////////////////////////////////
// Description:  Get the lookup oject for a given error code from the error lookup table
// Inputs:       ErrorCode - the error code of interest.
// Outputs:      Return a pointer to the corresponding lookup object and nil if
//                 ErrorCode not found.
// Note:
////////////////////////////////////////////////////////////////////////////////
var
  ix: Integer;
  found: Boolean;
begin
  ix:= 0;
  found:= False;
  Result:= nil;
  while (not found) and(ix < FPhiLookupTable.Count) do
  begin
    if ErrorCode = TLookup(FPhiLookupTable.Items[ix]).ErrorCode then
    begin
      found:= True;
      Result:= TLookup(FPhiLookupTable.Items[ix]);
    end;
    inc(ix);
  end;
end;


function TErrorAndAlarmHandler.GetPhiAlarm(Index: Integer): TAlarm;
////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Phi defined alarm referenced by Index.
// Inputs:       Index - the index of the desired alarm
// Outputs:      Returns an alarm object
// Exceptions:   EErrorAndAlarmHandlerError, EAAH_LIST_ACCESS_ERROR
// Note:
////////////////////////////////////////////////////////////////////////////////
begin
  TraceLog(traceDebug, 'GetPhiAlarm');
  result := nil;
  try
    Result:= TAlarm(FPhiAlarmList.Items[Index]);
  except
    on E:Exception do
      HandleInternalError(classname, errorNormal,
                         'Error in GetPhiAlarm. ' + E.Message,
                         EAAH_LIST_ACCESS_ERROR, '', '', 0);
  end;
end;


function TErrorAndAlarmHandler.GetPhiAlarmCount: Integer;
////////////////////////////////////////////////////////////////////////////////
// Description:  Get the total number of Phi defined alarms.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
begin
  TraceLog(traceDebug, 'GetPhiAlarmCount');
  Result:= FPhiAlarmList.Count;
end;


function TErrorAndAlarmHandler.GetPhiError(Index: Integer): TError;
////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Phi defined error referenced by Index.
// Inputs:       Index - the index of the desired alarm
// Outputs:      Returns an error object
// Exceptions:   EErrorAndAlarmHandlerError, EAAH_LIST_ACCESS_ERROR
// Note:
////////////////////////////////////////////////////////////////////////////////
begin
  TraceLog(traceDebug, 'GetPhiError');
  result := nil;
  try
    Result:= TError(FPhiErrorList.Items[Index]);
  except
    on E:Exception do
      HandleInternalError(classname, errorNormal,
                         'Error in GetPhiError. ' + E.Message,
                         EAAH_LIST_ACCESS_ERROR, '', '', 0);
  end;
end;


function TErrorAndAlarmHandler.GetPhiErrorCount: Integer;
////////////////////////////////////////////////////////////////////////////////
// Description:  Get the total number of Phi defined errors.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
begin
  TraceLog(traceDebug, 'GetPhiErrorCount');
  Result:= FPhiErrorList.Count;
end;

function TErrorAndAlarmHandler.GetCachedReportedError(Index: Integer): TError;
////////////////////////////////////////////////////////////////////////////////
// Description:  Get the CachedReportedError referenced by Index.
// Inputs:       Index - the index of the desired alarm
// Outputs:      Returns an error object
// Exceptions:   EErrorAndAlarmHandlerError, EAAH_LIST_ACCESS_ERROR
// Note:
////////////////////////////////////////////////////////////////////////////////
begin
  TraceLog(traceDebug, 'GetCachedReportedError');

  Result:= nil;
  if not Assigned(FReportedErrorsCachedAtStartupList) then
    Exit;

  try
    Result:= TError(FReportedErrorsCachedAtStartupList.Items[Index]);
  except
    on E:Exception do
      HandleInternalError(classname, errorNormal,
                         'Error in GetPhiError. ' + E.Message,
                         EAAH_LIST_ACCESS_ERROR, '', '', 0);
  end;
end;


function TErrorAndAlarmHandler.GetPhiLookup(Index: Integer): TLookup;
////////////////////////////////////////////////////////////////////////////////
// Description:  Get the lookup table entry referenced by Index.
// Inputs:       Index - the index of the desired lookup table entry
// Outputs:      Returns an TLookup object
// Exceptions:   EErrorAndAlarmHandlerError, EAAH_LIST_ACCESS_ERROR
// Note:
////////////////////////////////////////////////////////////////////////////////
begin
  TraceLog(traceDebug, 'GetPhiLookup');
  result := nil;
  try
    Result:= TLookup(FPhiLookupTable.Items[Index]);
  except
    on E:Exception do
      HandleInternalError(classname, errorNormal,
                         'Error in GetPhiLookup. ' + E.Message,
                         EAAH_LIST_ACCESS_ERROR, '', '', 0);
  end;
end;


function TErrorAndAlarmHandler.GetPhiLookupCount: Integer;
////////////////////////////////////////////////////////////////////////////////
// Description:  Get the total number of lookup table entries
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
begin
  TraceLog(traceDebug, 'GetPhiLookupCount');
  Result:= FPhiLookupTable.Count;
end;


function TErrorAndAlarmHandler.GetStringFromPhiAlarm(const AlarmID: Integer): String;
////////////////////////////////////////////////////////////////////////////////
// Description:  Return the alarm string for the AlarmID.
// Inputs:       AlarmID - AlarmID of interest.
// Outputs:      None
// Exceptions:   EErrorAndAlarmHandler, EAAH_INVALID_PHI_ALARM_ERROR
// Note:
////////////////////////////////////////////////////////////////////////////////
var
  ix: Integer;
  found: Boolean;
begin
  ix:= 0;
  found:= False;
  Result:= '';
  while (not found) and (ix < FPhiAlarmList.Count) do
  begin
    if AlarmID = TAlarm(FPhiAlarmList.Items[ix]).AlarmID then
    begin
      found:= True;
      Result:= TAlarm(FPhiAlarmList.Items[ix]).Description;
    end;
    inc(ix);
  end;

  // if the alarm is not found, it is not in the database, and is not a valid Phi
  //   alarm.  Raise an exception.
  if not found then
  begin
    HandleInternalError(classname, errorNormal, 'Alarm ID ' +
                       IntToStr(AlarmID) + ' not valid Phi alarm.',
                       EAAH_INVALID_PHI_ALARM_ERROR, '', '', 0);
  end;
end;


function TErrorAndAlarmHandler.GetStringFromPhiError(const ErrorCode: HResult): String;
////////////////////////////////////////////////////////////////////////////////
// Description:  Return the error string for the ErrorCode.
// Inputs:       ErrorCode - ErrorCode of interest.
// Outputs:      Returns the error code description string, or a blank string if
//                 the error code is not found.
// Exceptions:
// Note:
////////////////////////////////////////////////////////////////////////////////
var
  ix: Integer;
  found: Boolean;
begin
  ix:= 0;
  found:= False;
  Result:= '';
  while (not found) and (ix < FPhiErrorList.Count) do
  begin
    if ErrorCode = TError(FPhiErrorList.Items[ix]).ErrorCode then
    begin
      found:= True;
      Result:= TError(FPhiErrorList.Items[ix]).Description;
    end;
    inc(ix);
  end;
end;

procedure TErrorAndAlarmHandler.Initialize;
////////////////////////////////////////////////////////////////////////////////
// Description:  Initialize the object loading the phi alarms, load phi errors,
//                 and generate a default errors lookup table.
// Inputs:       None
// Outputs:      None
// Note:         Not sure I need the Lock here, but I don't think it hurts.
////////////////////////////////////////////////////////////////////////////////
begin
  TraceLog(traceOff, 'Initialize');

  Lock('Initialize');
  try
    // Load Phi alarms... it was connected to MetaPort alarms database before...

    // Load all the Phi errors into FPhiErrorsList
    LoadPhiErrors;
    // load all the important standard windows errors
    LoadStandardErrors;
    // Setup the default lookup table
    LoadDefaultLookupTable;

    // only after it has been initialized, we count it as ready to be used
    s_ErrorAndAlarmHandlerInstance := self;
  finally
    UnLock;
  end;
end;

procedure TErrorAndAlarmHandler.DeInitialize();
////////////////////////////////////////////////////////////////////////////////
// Description:  Perform deinitialization before destroy.
// Inputs:       None
// Outputs:      None
//
////////////////////////////////////////////////////////////////////////////////
begin
  TraceLog(traceOff, 'DeInitialize');

  // nothing to deinitialize
end;

procedure TErrorAndAlarmHandler.LoadPhiErrors;
////////////////////////////////////////////////////////////////////////////////
// Description:  Read all the errors defined in PhiErrorCodes and load them into
//                 FPhiErrorList.
// Inputs:       None
// Outputs:      None
// Exceptions:   EErrorAndAlarmHandler, EAAH_DUPLICATE_ERROR
// Note:         If there are duplications of error codes, raise an exception.
////////////////////////////////////////////////////////////////////////////////
var
  ix, jx: Integer;
  error: TError;
  errorCode: HResult;
begin
  // Load all the Phi errors into FPhiErrorList
  for ix:= Low(ErrorCodeArray) to High(ErrorCodeArray) do
  begin
    errorCode:= ErrorCodeArray[ix].Code;
    // Check previous entries for duplicates
    for jx:= 0 to FPhiErrorList.Count - 1 do
    begin
      if errorCode = TError(FPhiErrorList.Items[jx]).ErrorCode then
      begin
        HandleInternalError(classname, errorNormal, 'Error code, ' +
                           IntToStr(errorCode) + ' (' +
                           ErrorCodeArray[ix].Str + '), already exists.',
                           EAAH_DUPLICATE_ERROR, '', '', 0);
      end;
    end;
    error:= TError.Create;
    error.ErrorCode:= errorCode;
    error.Description:= ErrorCodeArray[ix].Str;
    FPhiErrorList.Add(error);
  end;
end;

procedure TErrorAndAlarmHandler.LoadStandardErrors;
////////////////////////////////////////////////////////////////////////////////
// Description:  Read all the errors defined in StandardErrorCodes and load them into
//                 FPhiErrorList.
// Inputs:       None
// Outputs:      None
// Exceptions:   EErrorAndAlarmHandler, EAAH_DUPLICATE_ERROR
// Note:         If there are duplications of error codes, raise an exception.
////////////////////////////////////////////////////////////////////////////////
var
  ix, jx: Integer;
  error: TError;
  errorCode: HResult;
begin
  // Load all the standard errors into FPhiErrorList
  for ix:= Low(StandardErrorCodeArray) to High(StandardErrorCodeArray) do
  begin
    errorCode:= StandardErrorCodeArray[ix].Code;
    // Check previous entries for duplicates
    for jx:= 0 to FPhiErrorList.Count - 1 do
    begin
      if errorCode = TError(FPhiErrorList.Items[jx]).ErrorCode then
      begin
        HandleInternalError(classname, errorNormal, 'Error code, ' +
                           IntToStr(errorCode) + ' (' +
                           ErrorCodeArray[ix].Str + '), already exists.',
                           EAAH_DUPLICATE_ERROR, '', '', 0);
      end;
    end;
    error:= TError.Create;
    error.ErrorCode:= errorCode;
    error.Description:= StandardErrorCodeArray[ix].Str;
    FPhiErrorList.Add(error);
  end;
end;

procedure TErrorAndAlarmHandler.LoadDefaultLookupTable;
////////////////////////////////////////////////////////////////////////////////
// Description:  Generate a default list of TLookup objects.
// Inputs:       None
// Outputs:      None
// Exceptions:
// Note:
////////////////////////////////////////////////////////////////////////////////
var
  lookupObject: TLookup;
  ix: Integer;
begin
  // Creat a default look up table.  Insert all the errors, and give each a default
  //  alarm ID.

  for ix:= 0 to FPhiErrorList.Count - 1 do
  begin
    lookupObject := TLookup.Create;
    lookupObject.ErrorCode := TError(FPhiErrorList.Items[ix]).ErrorCode; //  ErrorCodeArray[index].Code;
    lookupObject.AlarmID := NO_ALARM; // Default to no alarm

    // Add object to list
    FPhiLookupTable.Add(lookupObject);
  end;
end;


procedure TErrorAndAlarmHandler.ReportError(const ObjectName: string;
                                            const Level: TErrorLevel;
                                            const ErrorCode: Integer;
                                            const Description: String);
////////////////////////////////////////////////////////////////////////////////
// Description:  Report and error to the error and alarm handler
// Inputs:       ErrorCode - the error code of the error that is being reported
//               Description - the description of the error
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
var
  alarm: TAlarm;
  ep: TEventPoint;
  alarmID: Integer;
  alarmStr: String;
  eLevel: ErrorLevel ;
  lookupEntry: TLookup;
  error: TError;
begin
  TraceLog(traceDiagnose,
           'ReportError (ErrorCode: ' + IntToHex(ErrorCode,8) + ')');

  // This procedure can be called from different threads, and needs
  // to be thread safe.
  Lock('ReportError');

  try
    // Log all incoming errors
    case Level of
      errorWarning:    eLevel := eWarning;
      errorNormal:     eLevel := eNormal;
      errorCritical:   eLevel := eCritical;
    else
      eLevel := eNormal;
    end;
    // log the error to system log
    // To-do: It would be nice to pull out the error description from the error list
    // but right now the implementation only allows a sequential search and
    // is very inefficient!
    LogErrorMsg(ObjectName, eLevel, ErrorCode, Description);

    // To-do: Need to define our error handling scheme and maybe redesign
    // error and alarm handler

    // Tell other clients an error has occured.
    ep:= FEventContainer.FindEventPoint(TErrorEvent);
    TErrorEvent.SetData(ep,
      ErrorCode,
      Description);
    FEventContainer.FireEvents(TErrorEvent);

    if Assigned(FReportedErrorsCachedAtStartupList) then
    begin
      error:= TError.Create;
      error.ErrorCode:= ErrorCode;
      error.Description:= ObjectName + ' ' + Description;
      FReportedErrorsCachedAtStartupList.Add(error);
    end;

    //  Get the lookup object for ErrorCode.  If there is no lookup table entry for
    //   ErrorCode, GetLookupTableEntry returns nil.
    lookupEntry:= GetLookupTableEntry(ErrorCode);

    if (lookupEntry = nil) then
    begin
      // Log an error if an error is reported that is not in the lookup table.
      ErrorLog(errorNormal, ErrorCode, 'Error reported that is not in the error lookup table');

      // If an urecognized ErrorID is reported.
      alarmID:= FAlarmIdForUnrecognizedErrors;
    end
    else
    begin
      alarmID:= lookupEntry.AlarmID;
    end;

    if (alarmID <> NO_ALARM) and (GetActiveAlarmIndex(alarmID) = -1) then
    begin  // If the error is not a 'no alarm' error, and not already active.
//    Create an alarm object and set the alarm ID.  Retrieve the alarm description
//    string or any other info from the alarms database.  The alarm object description
//    string property will contain the alarm ID, the alarm description from the
//    alarms database, the error ID, and the error description.
      alarm:= TAlarm.Create;
      alarm.AlarmID:= alarmID;
      alarmStr:= GetStringFromPhiAlarm(alarmID) + ' (AlarmID: ' + IntToStr(alarmID) + '). ';
      alarm.Description:= alarmStr + Description + ' ' + GetStringFromPhiError(ErrorCode) + ' (ErrorCode: ' + IntToHex(ErrorCode,8) + '). ';

      //Add the alarm object to the list of active alarms.
      FActiveAlarms.Add(alarm);

      //Log all alarms
      AlarmLog(alarm.Description);

      //Broadcast the alarm notification.  Can be done from any thread.
      ep:= FEventContainer.FindEventPoint(TAlarmEvent);
      TAlarmEvent.SetData(ep, alarm.AlarmID, alarm.Description);
      TraceLog(traceDebug, 'Fire alarm event');
      try
        FEventContainer.FireEvents(TAlarmEvent);
      except
      on E:Exception do
      begin
        ErrorLog(errorNormal, EAAH_EVENT_NOTIFY_FAIL, 'Alarm notify failed');
        Raise E; //re-raise
      end;
    end;
  end;
  finally
    UnLock;
  end;
end;


procedure TErrorAndAlarmHandler.SetPhiLookup(const ErrorCode: HResult; const AlarmID: Integer);
////////////////////////////////////////////////////////////////////////////////
// Description:  Set the alarm ID in the lookup table for ErrorCode
// Inputs:       ErrorCode - the error code
//               AlarmID - the alarm ID of the alarm that gets raised when an error
//                 with ErrorCode is reported.
// Outputs:
// Exceptions:   EErrorAndAlarmHandler, EAAH_INVALID_PHI_ALARM_ERROR
//               EErrorAndAlarmHandler, EAAH_INVALID_ERROR_TABLE
// Note:
////////////////////////////////////////////////////////////////////////////////
var
  lookupEntry: TLookup;
  s: String;
begin
  Lock('SetPhiLookup');
  try
    // First figure out if AlarmID is a valid alarm.  Use call to GetStringFromPhiAlarm
    //  since it throws an exception if AlarmID is invalid.
    GetStringFromPhiAlarm(AlarmID);

    // Get a pointer to the lookup object for ErrorCode.
    lookupEntry:= GetLookupTableEntry(ErrorCode);

    if Assigned(lookupEntry) then
      lookupEntry.AlarmID:= AlarmID
    else
    begin
      FmtStr(s,'SetPhiLookup: Invalid ErrorCode (Dec:%d Hex:%x) ',[ErrorCode,ErrorCode]);
      HandleInternalError(classname, errorNormal, s,
                         EAAH_INVALID_ERROR_TABLE, '', '', 0);
    end;
  finally
    UnLock;
  end;
end;


procedure TErrorAndAlarmHandler.LookupTableHasBeenInitialized;
////////////////////////////////////////////////////////////////////////////////
// Description:  An external client calls this procedure when it has loaded the
//               the ErrorCode to AlarmID lookup table.
//
//
// Inputs  Msg - The string message to log to the event log.
//
// Outputs: None.
////////////////////////////////////////////////////////////////////////////////
var
  ix: Integer;
  error: TError;
begin
  TraceLog(traceDiagnose, 'LookupTableHasBeenInitialized');
  if not Assigned(FReportedErrorsCachedAtStartupList) then
    Exit;

  for ix:= 0 to FReportedErrorsCachedAtStartupList.Count-1 do
  begin
    error:= GetCachedReportedError(ix);
    if Assigned(error) then
      ReportError('Cached error re-reported', errorNormal,error.ErrorCode,error.Description);
  end;

  FReportedErrorsCachedAtStartupList.Free;
  FReportedErrorsCachedAtStartupList := nil;
                               // FReportedErrorsCachedAtStartupList is a
                               //  TObjectList, and you don't need to
                               //  explictly free the objects in the list.

end;

procedure TErrorAndAlarmHandler.Unlock;
////////////////////////////////////////////////////////////////////////////////
// Description: This function release the lock on the mutex smepahore required
//              for the thread handshaking.
//
// Inputs: None.
//
// Outputs: None.
////////////////////////////////////////////////////////////////////////////////
begin
  // Release the mutex sempahore
  ReleaseSyncObject;
end;

procedure TErrorAndAlarmHandler.Lock(MethodName: string);
////////////////////////////////////////////////////////////////////////////////
// Description: Get the sync object for synchronization.  Log error if it fails.
//
// Inputs: MethodName - name of the method that fails to get sync object.
//
// Outputs: None.
////////////////////////////////////////////////////////////////////////////////
begin
  if (not GetSyncObject) then
    ErrorLog(errorNormal, E_FAIL,
             'GetSyncObject returned false, ' + Classname + '.' + MethodName);
end;

{ TAlarmEvent }

procedure TAlarmEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
// Inputs: None.
//
// Outputs: None.
////////////////////////////////////////////////////////////////////////////////
begin
  // Call the base class to allow the Disconnect. A time out here indocates that
  // you disconnect before you called the event.
  inherited;
  NewEvent(TAlarmEventData(ClientData^).AlarmID,
           TAlarmEventData(ClientData^).Description);
end;

procedure TAlarmEvent.NewEvent(AlarmID: Integer; Description: String);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, AlarmID, Description);
  end
end;


class procedure TAlarmEvent.SetData(EventPoint: TEventPoint; AlarmID: Integer;
                                    Description: String);
////////////////////////////////////////////////////////////////////////////////
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TAlarmEvent.SetData() and
// never from Delphi objects of type TAlarmEvent.
//
// Inputs: EventPoint - The event point that will keep the data for us.
//         Alarm - The pointer to the alarm object to call the clients with.
//         Description - Description string of the alarm
//
// Outputs: None.
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin
  // Allocate the memory for the event point data
  pData := AllocMem(sizeof(TAlarmEventData));
  TAlarmEventData(pData^).AlarmID:= AlarmID;
  StrFmt(TAlarmEventData(pData^).Description, '%s', [Description]);
  EventPoint.SetClientData(pData);
end;

{ TAlarmClearedActionEvent }

procedure TAlarmClearedActionEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
// Inputs: None.
//
// Outputs: None.
////////////////////////////////////////////////////////////////////////////////
begin
  inherited;
  NewEvent(TAlarmClearedData(ClientData^).AlarmID,
           TAlarmClearedData(ClientData^).Action);
end;


procedure TAlarmClearedActionEvent.NewEvent(AlarmID: Integer; Action: TAlarmClearAction);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, AlarmID, Action);
  end
end;

class procedure TAlarmClearedActionEvent.SetData(EventPoint: TEventPoint; AlarmID: Integer;
                                                 Action: TAlarmClearAction);
////////////////////////////////////////////////////////////////////////////////
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TAlarmEvent.SetData() and
// never from Delphi objects of type TAlarmEvent.
//
// Inputs: EventPoint - The event point that will keep the data for us.
//         AlarmID - The ID of the cleared alarm.
//         Action - The action taken in clearing the alarm.
//
// Outputs: None.
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin
  // Allocate the memory for the event point data
  pData := AllocMem(sizeof(TAlarmClearedData));
  TAlarmClearedData(pData^).AlarmID:= AlarmID;
  TAlarmClearedData(pData^).Action:= Action;
  EventPoint.SetClientData(pData);
end;

///////////////////////////////////////////////////////////////////////////////
initialization
  // Register so an instance of this class gets created by the object manager.
  TErrorAndAlarmHandler.Register(ERROR_AND_ALARM_HANDLER_NAME);

end.

