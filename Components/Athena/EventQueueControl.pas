unit EventQueueControl;

interface

uses
    Classes,
    Windows,
    Contnrs,
    messages,
    TypInfo,
    Controls,
    SysUtils,
    SyncObjs,
    SyncObjectPhi,
    EventPoint,
    ObjectPhi;
    
const
  EVENT_QUEUE_CONTROL_NAME = 'EventQueueControl';

type
////////////////////////////////////////////////////////////////////////////////
//
// Classes declared in this file
//  TObject
      TEventQueueItem = class;
//    TThread
        TEventQueueThread = class;
//    TPhiSyncObject
        TEventQueueControl = class;
//
////////////////////////////////////////////////////////////////////////////////
  
///////////////////////////////////////////////////////////////////////////////
// Class TEventQueueControl
//
// This class provides a mechanism to queue events that need to be fired
// and provide for sequencial firing of a particular event point which 
// has multiple event requests queued.
// Create and start up the TEventQueueThread.
// 
///////////////////////////////////////////////////////////////////////////////
TEventQueueControl = class(TPhiSyncObject)
 
protected
  FEventQueueThread: TEventQueueThread;
  FEventQueue: TObjectList;   // Hold a list of TEventQueueItem objects
  FEventQueueChange: TEvent;  // Signaled when FEventQueue has changed.

  function GetReadyEventPoint(Index: integer): TEventPoint;
  procedure FireReadyEventPoint(EventPoint: TEventPoint);

public   
  constructor Create(name: string); override;
  destructor  Destroy; override;
  procedure   Initialize; override;
  procedure   DeInitialize(); override;

  class function GetCurrent: TEventQueueControl;

  procedure AddEvent(EventPoint: TEventPoint; pData: pointer);
  procedure FireQueuedEvents(EventPoint: TEventPoint);
  procedure EventComplete(EventPoint: TEventPoint);
  function GetQueueCount: integer;
  function WaitForNextReadyEventPoint: TEventPoint;
  function IsEventInQueue(eventPoint: TEventPoint): boolean;
  procedure SetTraceLevel(Level : TTraceLevel) ; override ;
  procedure RemoveEvent(Index: integer);
  procedure SetFireSignaled(EventPoint: TEventPoint);

  property EventQueueChange: TEvent read FEventQueueChange;
  

end;  // Class TEventQueueControl

///////////////////////////////////////////////////////////////////////////////
// Class TEventQueueItem
//
// This class holds information on a TEventPoint instance and the data 
// required for firing an event.
//
///////////////////////////////////////////////////////////////////////////////

TEventQueueItem = class(TObject)

protected
  FEventPoint: TEventPoint;
  FData: pointer;         // Event data pointer
  FFireSignaled: Boolean; //Indicated FireEvents has been for the eventPoint.

public
  constructor Create(EventPoint: TEventPoint; pData: pointer);
  destructor Destroy; override;
  function GetEventPoint: TEventPoint;
  function GetData: pointer;
  function GetFireSignaled: boolean;
  procedure SetFireSignaled;
  
end;  // Class TEventQueueItem

///////////////////////////////////////////////////////////////////////////////
// Class TEventQueueThread
//
// This class is a thread whose whole purpose is to fire the events in the 
// event queue when the event is ready.  The event is ready when the object 
// wanting to fire the event has called FireEvents on the event container, 
// and the event in question is not currently handling a previous request.
// 
///////////////////////////////////////////////////////////////////////////////
TEventQueueThread = class(TThread)
private
   FPhiObject: TPhiObject;    // For trace capabilities

protected
  procedure Execute; override;            // Main loop of thread
  
public
  constructor Create(CreateSuspended: Boolean);
  destructor  Destroy; override;

  property PhiObject: TPhiObject read FPhiObject write FPhiObject;

end;  // Class TWaferSequeningThread


///////////////////////////////////////////////////////////////////////////////
implementation
  
var
  CCurrentInstance: TEventQueueControl;

///////////////////////////////////////////////////////////////////////////////
constructor TEventQueueControl.Create(name: string);
begin
  inherited Create(EVENT_QUEUE_CONTROL_NAME);
  CCurrentInstance := Self;

  FEventQueue := TObjectList.Create;
  FEventQueue.Capacity := 100;

  FEventQueueChange := TEvent.Create(nil, TRUE, FALSE, 'EventQueueChange');
  FEventQueueThread := TEventQueueThread.Create(True);
  FEventQueueThread.Priority := tpHighest;
  FEventQueueThread.Start();

  FEventQueueThread.PhiObject.SetTraceLevel(GetTraceLevel);
end;

///////////////////////////////////////////////////////////////////////////////
destructor TEventQueueControl.Destroy;
begin
  FEventQueueThread.Free;
  FEventQueueThread := nil;

  FEventQueue.Free;
  FEventQueue := nil;

  FEventQueueChange.Free;
  FEventQueueChange := nil;

  inherited;
end;

///////////////////////////////////////////////////////////////////////////////

procedure TEventQueueControl.Initialize;
begin
  inherited;
end;
////////////////////////////////////////////////////////////////////////////////
procedure TEventQueueControl.DeInitialize();
begin
  FEventQueueThread.Terminate;
  FEventQueueChange.SetEvent;  // Make sure we get out of the
  FEventQueueThread.WaitFor;  // Wait forEventQueueThread to terminates.

  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
class function TEventQueueControl.GetCurrent;
//Get the current instance of TEventQueueControl.
begin
  result := CCurrentInstance;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TEventQueueControl.AddEvent(EventPoint: TEventPoint;
                                           pData: pointer);
// Create a new TEventPointItem and add it to the FEventQueue.                                           
var
  eventQueueItem: TEventQueueItem;
  str: string;
begin
  FmtStr(str,'Add Event to queue, Event = %s, Data = %d',
             [EventPoint.EventClass.ClassName,Integer(pData)]);
  TraceLog(traceDebug,str);  
  eventQueueItem := TEventQueueItem.Create(EventPoint,pData);
  try
    GetSyncObject;
    FEventQueue.Add(eventQueueItem);
  finally
    ReleaseSyncObject;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TEventQueueControl.IsEventInQueue(EventPoint: TEventPoint): boolean;
// Find out if eventpoint is the the FEventQueue
var
  i: integer;
  eventQueueItem: TEventQueueItem;
  loopCount: integer;
begin
  result := False;
  try
    GetSyncObject;
    loopCount := GetQueueCount - 1;
    for i := 0 to loopCount do
    begin
      eventQueueItem := FEventQueue.Items[i] as TEventQueueItem;
      if eventQueueItem.GetEventPoint = EventPoint  then
        result := True;
    end;
  finally
    ReleaseSyncObject;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TEventQueueControl.RemoveEvent(Index: integer);
// Remove a TEventQueueItem instance from the FEventQueue.
// The FEventQueue is a TObjectList with OwnsObjects set to True, so the
// EventQueueItem will be automatically destroyed.
begin
//  TraceLog(traceDebug,'RemoveEvent ' + 
//    eventQueueItem.GetEventPoint.EventClass.ClassName);
  try
    GetSyncObject;
    FEventQueue.Delete(Index);
  finally
    ReleaseSyncObject;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TEventQueueControl.FireQueuedEvents(EventPoint: TEventPoint);
// This method is called from TThreadSafeEventContainer.FireEvents(eventType).
// Set the EventQueueItem for EventPoint to FFireSignaled and
// signal the TEventQueueThread to run.
begin
  SetFireSignaled(EventPoint); 
  FEventQueueChange.SetEvent;  // Cause event queue thread to run.
end;

///////////////////////////////////////////////////////////////////////////////
procedure TEventQueueControl.EventComplete(EventPoint: TEventPoint);
// This method is called from TThreadSafeEventContainer.FireEvents(eventPoint)
// when the eventpoint has called all it's client handlers.
// Signal the TEventQueueThread to run.
begin
  TraceLog(traceDebug,'EventComplete, Event =' + EventPoint.EventClass.ClassName);

  FEventQueueChange.SetEvent;  // Cause event queue thread to run.
end;

///////////////////////////////////////////////////////////////////////////////
procedure TEventQueueControl.SetFireSignaled(EventPoint: TEventPoint);
// Set the FFireSignaled flag for a TEventQueueItem in the FEventQueue.
// It will match a TEventQueueItem that has the same EventPoint and has
// not already been signaled (there may be more than one of the same eventpoint).
var
  i: integer;
  eventQueueItem: TEventQueueItem;
  loopCount: integer;
  readyEventPoint: TEventPoint;
begin
  try
    readyEventPoint := nil;
    GetSyncObject;
    loopCount := GetQueueCount - 1;
    for i := 0 to loopCount do
    begin
      eventQueueItem := FEventQueue.Items[i] as TEventQueueItem;
      if (eventQueueItem.GetEventPoint = EventPoint) and
         (not eventQueueItem.GetFireSignaled) then
      begin
        eventQueueItem.SetFireSignaled;
        readyEventPoint := GetReadyEventPoint(i);
        Break; // only signal one eventQueueItem
      end;
    end;
  finally
    ReleaseSyncObject;
  end;
  if readyEventPoint <> nil then
    FireReadyEventPoint(readyEventPoint); // Fire the event in the calling thread.
end;

///////////////////////////////////////////////////////////////////////////////
function TEventQueueControl.GetQueueCount: integer;
// return the current number of items in FEventQueue
begin
  result := FEventQueue.Count;
end;

///////////////////////////////////////////////////////////////////////////////
function TEventQueueControl.WaitForNextReadyEventPoint: TEventPoint;
// Wait for a change in the FEventQueue, then check for a TEventPoint 
// in the FEventQueue that is ready to run.
// A TEventPoint is ready to run when it's FMessageSync is signaled
// and the TEventPointItem.FFireSignaled is True.
// If multiple events of the same type have been put on the
// queue a call to FireEvents will cause the first one queued to be
// fired.
var
  i: integer;
  eventPoint: TEventPoint;
  loopCount: integer;
begin
  repeat
    EventQueueChange.WaitFor(2000); // Wait for signal or timeout.
    EventQueueChange.ResetEvent;
    eventPoint := nil;

    try
      GetSyncObject;
      loopCount := GetQueueCount - 1;
      for i := 0 to loopCount do
      begin
        eventPoint := GetReadyEventPoint(i);
        if eventPoint <> nil then
          Break;
      end;
    finally
      ReleaseSyncObject;
    end;
  until (eventPoint <> nil) or FEventQueueThread.Terminated;

  Result := eventPoint;
end;

///////////////////////////////////////////////////////////////////////////////
function TEventQueueControl.GetReadyEventPoint(Index: integer): TEventPoint;
// Return eventpoint that is ready to fire.
// Sets the eventpoint data and resets eventpoint messageSync.
// If event is ready then remove it from the queue.
// This must be called from a method that has the
// EventQueuecontrol sync semaphore.
var
  eventQueueItem: TEventQueueItem;
begin
  result := nil;
  eventQueueItem := FEventQueue.Items[Index] as TEventQueueItem;
  if eventQueueItem.GetEventPoint.IsAvailableToFire and
     eventQueueItem.GetFireSignaled then
  begin
    result := eventQueueItem.GetEventPoint;
    result.MessageSync.ResetEvent; // signal event busy
    result.SetData(eventQueueItem.GetData);
    RemoveEvent(Index);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TEventQueueControl.FireReadyEventPoint(EventPoint: TEventPoint);
// Call the fire on the event container for eventpoint.
var
  eventContainer: TThreadSafeEventContainer;
  str: string;
begin
  FmtStr(str,'Fire Event, Event = %s, Data = %d',
        [EventPoint.EventClass.ClassName,Integer(EventPoint.FClientData)]);
  TraceLog(traceDebug,str);
  eventContainer := EventPoint.ParentEventContainer
                      as  TThreadSafeEventContainer;
  eventContainer.FireEventsInternal(EventPoint);
end;
///////////////////////////////////////////////////////////////////////////////
procedure TEventQueueControl.SetTraceLevel(Level : TTraceLevel) ;
begin
  inherited;
  if FEventQueueThread <> nil then
    FEventQueueThread.PhiObject.SetTraceLevel(Level);
end;

///////////////////////////////////////////////////////////////////////////////
// Class TEventQueueItem
///////////////////////////////////////////////////////////////////////////////

constructor TEventQueueItem.Create(EventPoint: TEventPoint; pData: pointer);
begin
  inherited Create;
  FEventPoint := EventPoint;
  FData := pData;
  FFireSignaled := False;
end;

///////////////////////////////////////////////////////////////////////////////
destructor TEventQueueItem.Destroy;
begin
  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
function TEventQueueItem.GetEventPoint: TEventPoint;
begin
  result := FEventPoint;
end;
///////////////////////////////////////////////////////////////////////////////
function TEventQueueItem.GetData: pointer;
begin
  result := FData;
end;
///////////////////////////////////////////////////////////////////////////////
function TEventQueueItem.GetFireSignaled: Boolean;
begin
  result := FFireSignaled;
end;
///////////////////////////////////////////////////////////////////////////////
procedure TEventQueueItem.SetFireSignaled;
begin
 FFireSignaled := True;
end;

///////////////////////////////////////////////////////////////////////////////
  

///////////////////////////////////////////////////////////////////////////////
//
// Class TEventQueueThread
//
///////////////////////////////////////////////////////////////////////////////
constructor TEventQueueThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);

  FPhiObject := TPhiObject.Create('EventQueueThread');
end;

///////////////////////////////////////////////////////////////////////////////
destructor TEventQueueThread.Destroy;
begin
  FPhiObject.Free;
  FPhiObject := nil;
  inherited;
end;

///////////////////////////////////////////////////////////////////////////////
procedure TEventQueueThread.Execute;
// Main  loop of this thread.
// Loop on eventQueueControl.GetNextReadyEventPointItem which 
// will wait until EventQueueChange TEvent is signaled and the event queue
// has an eventpoint that is ready to run. 
// When an eventpoint is found then fire the events for it's event container.
// This thread runs until system is shutdown.
var
  eventPoint: TEventPoint;
  eventQueueControl: TEventQueueControl;
begin
  eventQueueControl := TEventQueueControl.GetCurrent;
  While not Terminated do
  begin
    eventPoint := eventQueueControl.WaitForNextReadyEventPoint;
    if not Terminated then
      eventQueueControl.FireReadyEventPoint(eventPoint);
    if Terminated then
      FPhiObject.TraceLog(TraceOff,'Thread Terminating');
  end; // While not terminated
end;
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// End Class TEventQueueThread
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
initialization
  // Register to be created by the object manager
  TEventQueueControl.Register(EVENT_QUEUE_CONTROL_NAME);

////////////////////////////////////////////////////////////////////////////////
end.