unit EventPoint;

////////////////////////////////////////////////////////////////////////////////
//
// Filename:       EventPoint.pas
//
// Created:         on ??/??/98 by Jeff Hagen.
//
// Purpose:  This file defines base classes that are used to fire events between
// Delphi objects. First, a connection server of type TEventContainer is
// created.  This class is conceptually similar to a COM server and houses the
// various types of events that are supported.  Each supported event is a
// separate object of type TEventPoint, i.e. OnRobotMoveDone.  The individual
// derived event point classes are attached to the server by calling the
// TEventContainer.CreateEventPoint() method.  Individual clients of type
// TEventClient, may then connect to the server if it supports the desired
// eventpoint. It does this by calling TEventPoint.Advise().  To disconnect
// from the server TEventPoint.Unadvise() is called.
//
// History:
//
// 1.0- Initial revision.
//  - Jeff Hagen ??/??/98
//
// 1.1- Revisions to base class ??.
//  - Dave Martel 01/16/99
//
// 1.2- Make this code thread safe for use in the CMP and Targa projects. -
//  -Al Pike 04/03/2002
//
// 1.3- Add a way to call clients directly from the worker thread rather than
// going through the overhead of a PostMessage for those simple clients that
// do not make extensive GUI API calls.
//  -Al Pike 10/28/2002
//
// 1.4- Change FireEvents again and make it easier to add new event types. Also
// make the event point have the message sync rather than the event container.
// This allows multiple event types to fire at once in the same event container.
// Also add the Async GUI calling context.  Changed client list from TList to
// TObject list since it already has management code that was previously in this
// object.  This allows the number of clients to equal the count of the list
// and elimintaes the concept of unused elements from the list.
//  -Al Pike 09/18/2003
//
//
// Copyright © 1998-2003 Physical Electronics, Inc.
//
// Created in 1998 as an unpublished copyrighted work.  This program and the
// information contained in it are confidential and proprietary to Physical
// Electronics and may not be used, copied, or reproduced without the prior
// written permission of Physical Electronics.
//
////////////////////////////////////////////////////////////////////////////////

interface
{$M+}

uses

  // Delphi Units.
  Classes,
  Contnrs,
  SyncObjs,
  SysUtils,
  Windows,

  // PHI Units.
  objectPhi,
  SyncObjectPhi;

type

////////////////////////////////////////////////////////////////////////////////
//
// Classes declared in this file
//
//  TObject
      TEventClient = class;
      TEventPoint = class;
      TEventContainer = class;
        TThreadSafeEventContainer = class;
//
////////////////////////////////////////////////////////////////////////////////

TEventPointKind = (epSingle, epMulti);

EAlreadyConnected = class(Exception);
EInvalidSink = class(Exception);
EEventPointNotFound = class(Exception);
EInvalidIndex = class(Exception);
EEventPointExists = class(Exception);

TEventClass = class of TEventClient;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TEventClient class.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Calling Context definitions.
//
//
// epNotActive:  The event point is not currently executing any code and is
// available for a client to use.
//
// epInitMemory: The event point memory has been set but the events have not
// been fired yet. Other clients that try to use the event point will hold in
// this state until after the event point goes back to epNotActive.  This
// happens after all the connected events have been fired.  This type is not
// used with event points directly and is handled internally.
//
// epDirectThreadContext: The event point is calling those client handlers that
// are marked as epDirectThreadContext.  This means that the callback handlers
// are called directly (as a normal procedure call) in the context of the thread
// that fired the events.
//
// epGUIThreadContext: The event point is calling those client handlers that are
// marked as epGUIThreadContext.  This means that if the thread that fired the
// events is the GUI thread the event callbacks will be called directly as in
// the epDirectThreadCOntext.  However if a worker thread has fired the events
// then a message is posted to the window procedure for the event container
// causing the FireEvents function to be called from the context og the GUI
// thread.  This calling context is provided to make sure GUI code is serailized
// and can only run in the GUI thread.
//
// epAsyncGUIContext:  The event point is calling those client handlers that are
// marked as epAsyncGUIContext.  This means that a message will always be posted
// to the window procedure for the event container independent of who fired the
// events.  This calling context allows event points to become nested allowing
// the handlers of one event point type to fire events of a different type. By
// using the post message it is ensured that the code of the first event type
// will finish running before the nested event callback are called. When called
// from a COM event handler the type should also be epAsyncGUIContext so that
// the COM habdler can return to its server and release the message loop back to
// our app.
//
//
////////////////////////////////////////////////////////////////////////////////

TEventClientCallingContext = (epNotActive, epInitMemory, epFreeMemory,
  epDirectThreadContext, epGUIThreadContext, epAsyncGUIContext);

TEventClient = class(TObject)

// Construction / Destruction
public
  constructor Create();
  destructor Destroy ; override ;

// class functions
public
  class procedure SetData(EventPoint: TEventPoint); overload;
  class procedure FreeData(EventPoint: TEventPoint); virtual;

//  procedure DumpStackToTraceLog(stacklabel: string) ;

// Operations
public
  procedure Connect(Server: TEventContainer); virtual;
  procedure Disconnect(fatal: BOOLEAN = FALSE); virtual;
  procedure EventPointDestroy; virtual;
  procedure Lock();
  procedure Unlock();

// Overrides
public
  procedure CallEvent(ClientData: pointer); virtual;

// Attributes
protected
  FDisconnectEvent: TEvent;               // handles calling Disconnect to fast.
  FCallingContext: TEventClientCallingContext;

private
  FServer: TEventPoint;              // TEventContainer Server that fires events
  FOnEventPointDestroy: TNotifyEvent;// Destroy method pointer(?)
  FTag: Integer;                     // Unknown
  FRunLock: TPhiSyncObject;         // Used to make calls Threadsafe.

// Properties
published
  property OnEventPointDestroy: TNotifyEvent
    read FOnEventPointDestroy
    write FOnEventPointDestroy;
  property Tag: Integer
    read FTag
    write FTag ;
  property phiObject: TPhiSyncObject
    read FRunLock;
  property Server: TEventPoint
    read FServer;
  property Context: TEventClientCallingContext
    read FCallingContext
    write FCallingContext;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TEventPoint class.
//
////////////////////////////////////////////////////////////////////////////////

TEventPoint = class(TObject)

// Construction / Destruction
public
  constructor Create(eventClass: TEventClass; eventKind: TEventPointKind;
    OnConnect: TNotifyEvent; evtCont: TEventContainer);
  destructor Destroy; override;

// Operations
public
  procedure Advise(Sink: TEventClient);
  function FireEvents(clientType: TEventClientCallingContext): BOOLEAN;
  function GetSinkCount: Integer;
  function GetSink(index: Integer): TEventClient;
  function GetClientData(): pointer;
  procedure SetClientData(pData: pointer; nestingForbidden: Boolean = TRUE);
  procedure SetData(pData: pointer);
  procedure Lock();
  procedure UnAdvise(eventClient: TEventClient);
  procedure Unlock();
  function IsAvailableToFire: boolean;
//  procedure DumpStackToTraceLog(stacklabel: string);
  procedure SetFirstCallingContext;
  procedure SetNextCallingContext;
  
// Overrides
protected
  procedure CallEvents(eventList: TList); virtual;

// Implementation
protected
  function GetEventPointKind: TEventPointKind;
  function GetEventClass: TEventClass;
  procedure CleanupUserMemory(); virtual;
  procedure ClearEventData;

// Attributes
private
  FEventClass: TEventClass;   // The type of event this point supports.
  FOnConnect: TNotifyEvent;   // User defined event when a client connects.
  FEventList: TObjectList;    // The list of clients connect to this event.
  FEventsToCallList: TList;
  FType: TEventPointKind;     // A multi or single event type.
  FTotalEventCalled: Integer;
  FCallingState: TEventClientCallingContext; // Indicates what the EP is doing.
  FMessageSync: TEvent;

  FUsingThread: DWORD;
  FNextData: TList;

public
  FClientData: pointer;       // Pointer to the data used in the event call.
  FFireDirectInGUI: BOOLEAN;  // fires directly from GUI without PostMessage
  FRunLock: TPhiSyncObject;         // Used to make calls Threadsafe.
  FPendingForPreviousUIInstance: Boolean;
  FParentEventContainer: TEventContainer;

// Properties
published
  property phiObject: TPhiSyncObject read FRunLock;
  property FireDirectInGUI: BOOLEAN read FFireDirectInGUI write FFireDirectInGUI;
  property MessageSync: TEvent read FMessageSync;
  property ParentEventContainer: TEventContainer read FParentEventContainer;
  property EventClass: TEventClass read FEventClass;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TEventContainer class.
//
////////////////////////////////////////////////////////////////////////////////

TEventContainer = class(TObject)

// Construction / Destruction
public
  constructor Create;
  destructor Destroy; override;

// Attributes
private
  FRunLock: TPhiSyncObject;         // Used to make calls Threadsafe.
  FEventPoints: TList;                // List of the attached eventpoints.

  FCancelEvent: TEvent;             // Used during destruction to abort waits

// Operations
public
  function CreateEventPoint(eventType: TEventClass; eventKind: TEventPointKind;
    OnConnect: TNotifyEvent): TEventPoint;
  function GetEventPointCount: Integer;
  function GetEventPoint(index: Integer): TEventPoint;
  function FindEventPoint(eventType: TEventClass): TEventPoint;
  procedure Lock();
  procedure Unlock();

//  procedure DumpStackToTraceLog(stacklabel: string);

// Properties
published
  property CancelEvent: TEvent
    read FCancelEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TThreadSafeEventContainer class.
//
////////////////////////////////////////////////////////////////////////////////

TThreadSafeEventContainer = class(TEventContainer)

// Construction / Destruction
public
  constructor Create;
  destructor Destroy; override;

// Operations
public
  procedure FireEvents(eventType: TEventClass); overload;
  procedure FireEventsInternal(eventPoint: TEventPoint); overload;

// Class Functions
public
  class function ThreadSafeEventWndProc(Window: HWND; Message,
    wParam, lParam: Longint): Longint;

// Implementation
protected
  function AllocateWindow: HWND;
end;

implementation

uses

  // Delphi Units
  messages,
  TypInfo,

  // Phi Units
  PhiErrorCodes,
  PhiExceptions,
  ReportExceptionProc,
  EventQueueControl;

const

  // define our message type.
  WMU_RUNINGUITHREAD        = WM_USER + $01;
  WMU_SETCLIENTDATAWAITING  = WM_USER + $02;

var

  // Shared by TEventPoint and TThreadSafeEventContainer.
  gFGUIThreadID: Cardinal;
  gFMsgHandlerWnd: HWND = 0;

{ TEventPoint }

////////////////////////////////////////////////////////////////////////////////
//
// Class TEventPoint
//
// Description:
//
// Class provides to support single or multiple client events.  Each of the
// events are housed by a TEventContainer object.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Class TEventPoint
//
// Construction / Destruction
//
////////////////////////////////////////////////////////////////////////////////
{
procedure TEventPoint.DumpStackToTraceLog(stacklabel: string);
var
  myStack: TCallStack;
  myStackStr: string;
  myStackStrPart: string;
  strPos: integer;
begin
  FillCallStack(myStack, 0);
  myStackStr := CallStackTextualRepresentation(myStack, '');
  while (Length(myStackStr) > 0) do
  begin
    strPos := Pos(#10, myStackStr);
    myStackStrPart := Copy(myStackStr, 0, strPos);
    myStackStr := Copy(myStackStr, strPos+1, Length(myStackStr));
    FRunLock.TraceLog(traceDebug,
      format('%s (%s)',
        [stacklabel, myStackStrPart]));
  end;
end;
}
constructor TEventPoint.Create(eventClass: TEventClass;
  eventKind: TEventPointKind; OnConnect: TNotifyEvent;
  evtCont: TEventContainer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Initialize member variables and create the delphi object.
//
//
// Inputs:
//
// eventClass: the event class type that this eventpoint supports it is a
// TEventClient object.
//
// eventKind: the type of event, single client or multiple client.
//
// OnConnect: the method to call when a client connects to this event point.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  inherited Create;

  // Create the mutex semaphore.
  FRunLock := TPhiSyncObject.Create(EventClass.className);

//{$ifdef debug}
//  FRunLock.TraceLog(traceOff,
//    format('TEventPoint create runlock (%d)',[FRunLock.Handle]));
//  DumpStackToTraceLog('TEventPoint create runlock stack');
//{$endif}

  // Some outside thread may attempt a connection before we are ready. Lock()
  // to prevent this.
  Lock();
  try
    FClientData := nil;

    // Create the list of clients that will attach.
    FEventList := TObjectList.Create(FALSE);
    FEventList.Capacity := 10;
    FEventsToCallList := TList.Create();
    FOnConnect := OnConnect;
    FEventClass := eventClass;
    FType := eventKind;
    FFireDirectInGUI := TRUE;
    FTotalEventCalled := 0;
    FCallingState := epNotActive;
    FPendingForPreviousUIInstance := FALSE;
    FParentEventContainer := evtCont;
    FNextData := TList.Create;
    FNextData.Capacity := 10;

    // No one is using this event point yet.
    FUsingThread := 0;

    FMessageSync := TEvent.Create(nil,
      TRUE,
      TRUE,
      '');
{$ifdef debug}
    FRunLock.TraceLog(traceDebug,
      format('TEventPoint create msgsync (%d)',[FMessageSync.Handle]));
//    DumpStackToTraceLog('TEventPoint create msgsync stack');
{$endif}
  finally

    // Done with the mutex the event point is ready to use.
    Unlock();
  end;
end;

destructor TEventPoint.Destroy;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Destroy this object also calls the defined callback
// EventPointDestroy().
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  i: Integer;
  ec: TEventClient;
begin

  // Acquire the mutex.
  Lock();

  try

    // Free the list of clients if any
    for i := FEventList.Count - 1 downto 0 do
    begin

      // Iterate through the list.
      if (FEventList[i] <> NIL) then
      begin

        // Call the user defined cleanup code. This does not free the client
        // object itself. That is left to the client's creator/owner.
        ec := FEventList[i] as TEventClient;
        ec.EventPointDestroy();

        // Server is going away must disconnect if have not done so. Note: the
        // ec remains in tact.
        ec.Disconnect();

        // Does not delete owns objects is FALSE. This will also move other
        // entries in the list forward removing nil entries so coun is now
        // always equal to the number of clients.
        if(FEventList.IndexOf(ec) <> -1) then
        begin

          // If the entry has not already been removed from the list then remove
          // it now.  If the client has an event point destroy that calls
          // Disconnect then Disconnect will remove the item from the list.
          FEventList.Delete(i);
        end;
      end;
    end;
 
    ClearEventData;  // Free the data memory if it is pointer to something.

  finally
    Unlock();
  end;

  FreeAndNil(FEventsToCallList);

  if (FEventList <> nil) then
  begin
    FEventList.Free;
    FEventList := nil;
  end;
  if (FMessageSync <> nil) then
  begin
{$ifdef debug}
    FRunLock.TraceLog(traceDebug,
      format('TEventPoint delete msgsync (%d)',[FMessageSync.Handle]));
//    DumpStackToTraceLog('TEventPoint delete msgsync stack');
{$endif}

    FMessageSync.Free;
    FMessageSync := nil;
  end;
  if (FRunLock <> nil) then
  begin
//{$ifdef debug}
//    FRunLock.TraceLog(traceDebug,
//      format('TEventPoint delete runlock (%d)',[FRunLock.Handle]));
//    DumpStackToTraceLog('TEventPoint delete runlock stack');
//{$endif}

    FRunLock.Free;
    FRunLock := nil;
  end;
  If FNextData <> nil then
  begin
    FNextData.Free;
    FNextData := nil;
  end;
  inherited;
end;

procedure TEventPoint.Advise(Sink: TEventClient);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function connects a client of sink type to the eventpoint.
//
//
// Inputs:
//
// Sink:  the event client that will connect to this event point.
//
// ident: the index of this client in the client list.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Make sure not already connected.
  if (FType = epSingle) and
    (GetSinkCount <> 0) then
  begin
    raise EAlreadyConnected.Create('Event Point Already Connected in' +
      'TEventPoint.Advise');
  end;

  // Acquire the mutex we will be changing shared member variables.
  Lock();
  try

    // Make sure we are the correct type.
    if not(sink is FEventClass) then
    begin
      raise EInvalidSink.Create('Invalid Class in TEventPoint.Advise');
    end;

      // Always add to the end of the list. Delete will move objects up and
      // prevent blank spaces. TObject list includes this code so the original
      // code to do this has been removed.
      FEventList.Add(sink);
  finally

    // Release the Mutex.
    Unlock();
  end;

  // A client has connected.
  if Assigned(FOnConnect) then
  begin
    FOnConnect(self);
  end;
end;

procedure TEventPoint.CleanupUserMemory;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this function to cleanup any memory that may be referencec
// by the event point data.  Sometimes its useful to have this memory point
// to other objects. This is your chance to cleanup that memory.
//
//
// Inputs: None.
//
// Outputs: None.
//
// Exceptions: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Call this as a class function
  FEventClass.FreeData(Self);
end;

function TEventPoint.FireEvents(clientType: TEventClientCallingContext): BOOLEAN;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This method notifies the events in its client list with the
// new set of data held by FDataPointer.
//
//
// Inputs:
//
// direct:  If direct is FALSE this function is being called by the event
// container from the context of the GUI thread.  If direct is TRUE this
// function is being called directly from the context of the calling thread.
// The parent TThreadSfaeEventContainer mananges the state of this variable for
// you and calls this function with the proper value.
//
//
// Outputs:
//
// result: Indicates whether all clients where called.  If all clients are of
// type direct then no message is posted saving processing overhead.
//
//
////////////////////////////////////////////////////////////////////////////////
var
//  eventList: TList;
  sink: TEventClient;
  sinkcount, i: Integer;
  s: string;
begin
  sinkcount:= 0; //eliminates compiler warning

  // Create the local vraiables.  Made as a member to reduce fragmentation.
//  eventList := TList.Create();

  // Acquire the mutex lock.
  Lock();
  try

    // By setting count to zero and leaving capacity alone we reuse the same
    // memory rather than allocating it again.
    FEventsToCallList.Count := 0;

    // Get the attached clients quickly and under a lock so the list memory
    // does not become corrupt.
    sinkcount := GetSinkCount();
    if(sinkcount = 0) then
    begin
      result := TRUE;
      Exit; // (jumps to finally)
    end;
    for i := 0 to sinkCount - 1 do
    begin
      sink := GetSink(i);
      if(sink.Context = clientType) then
      begin

        // Add will only reallocate if it needs to.
        FEventsToCallList.Add(sink);
      end;
    end;

    // Fire the events. Here we separate the acquisition of the event pointers
    // which must be thread safe from the potentially lengthy event calls. This
    // allows pending threads to be blocked for a minimum amount of time.
    FmtStr(s,
      'Will fire %d events of type %s.',
      [FEventsToCallList.Count,
      GetEnumName(TypeInfo(TEventClientCallingContext), Ord(FCallingState))]);
    FRunLock.TraceLog(traceDebug, s);

    if(FEventsToCallList.Count <> 0) then
    begin

      // Ok there are events to call do it.
      CallEvents(FEventsToCallList);
    end;
  finally

    // Have we called all of the events?
    FTotalEventCalled := FTotalEventCalled + FEventsToCallList.Count;
    if(FTotalEventCalled = sinkCount) then
    begin
      FTotalEventCalled := 0;
      result := TRUE;
    end
    else
    begin
      result := FALSE;
    end;

    FmtStr(s,
      'Fired %d events of type %s.',
      [FEventsToCallList.Count,
      GetEnumName(TypeInfo(TEventClientCallingContext), Ord(FCallingState))]);
    FRunLock.TraceLog(traceDebug, s);

    // Done with the Mutex.
    Unlock();

    // Free eventlist. Now we reuse list.
//    eventList.Clear();
//    FreeAndNil(eventList);
  end;
end;


function TEventPoint.GetClientData: pointer;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function returns the client data to the fire events
// functionthat is interested in firing the events.
//
//
// Inputs: None.
//
//
// Outputs:
//
// result: a pointer to the data.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Acquire the Lock. Just to be safe.
  Lock();
  try
    result := FClientData;
  finally
    Unlock();
  end;
end;

procedure TEventPoint.UnAdvise(eventClient: TEventClient);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function disconnects a client of sink type to the
// eventpoint using its index into the list.
//
//
// Inputs:
//
// ident: the index of this client in the client list.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  index: Integer;
begin

  // Acquire the mutex in case someone tries to fire this event or is already
  // doing so.
  Lock();
  try

    index := FEventList.IndexOf(eventClient);
    if(index = -1) then
    begin

      // Invalid nothing to do.
      Exit;
    end;

    // Removes entry and moves all others up in the list. i.e. now there are no
    // longer nil entries and count = eventcount.
    FEventList.Delete(index);
  finally

    // Realese the mutex.
    Unlock();
  end;
end;

function TEventPoint.GetSinkCount: Integer;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function is called to determine how many clients are
// currently connected to the evenbt point.  Remember to not count those
// positons that are empty.
//
//
// Inputs: None.
//
//
// Outputs:
//
// result:  The number of clients connected.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Acquire the mutex. Don't want count to change during the process. The count
  // returned could be wrong.
  Lock();

  try

    // By using object list now count and the number of clients are synchronized.
    result := FEventList.Count;
  finally

    // Done with the Mutex.
    Unlock();
  end;
end;

procedure TEventPoint.Lock();
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function acquires the mutex sempaphore used in the thread
// handshaking.  This is a wrapper for the call into the TSyncObject member
// variable.
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Acquire the mutex sempahore
  FRunLock.GetSyncObject();
end;

////////////////////////////////////////////////////////////////////////////////
procedure TEventPoint.SetClientData(pData: pointer; nestingForbidden: Boolean);
// Add this event to the event queue
begin
  TEventQueueControl.GetCurrent.AddEvent(self,pData);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TEventPoint.SetData(pData: pointer);
begin
  ClearEventData;
  FClientData := pData;
  SetFirstCallingContext;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TEventPoint.ClearEventData;
begin
  if(FClientData <> nil) then
  begin
    try
    // Cleanup any non contiguous TObject reference by FClientData.
    CleanupUserMemory();

    // If already used we want to free the exisitng memory. Note: This
    // function is called by the destructor to clean this up on destructuion.
    FreeMem(FClientData);
    FClientData := nil;
    except
    on E: Exception do
      raise E;
    end;
  end;
end;
////////////////////////////////////////////////////////////////////////////////
function TEventPoint.IsAvailableToFire: boolean;
// Check if this eventpoint is available to fire events or if it is
// currently handling events.

begin
  result := FMessageSync.WaitFor(0)= wrSignaled;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TEventPoint.Unlock();
//
// Description: This function release the lock on the mutex smepahore required
// for the thread handshaking.  This is a wrapper for the call into the
// TSyncObject member variable.
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Acquire the mutex sempahore
  FRunLock.ReleaseSyncObject();
end;

function TEventPoint.GetSink(index: Integer): TEventClient;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function returns the client at position index.  This
// function is used to iterate through the valid clients.  It maps valid
// indices to a count value.  Be careful when iterating through the list in
// a multi-threaded environment.  You should acquire the lock before iterating
// since clients connecting or disconnecting during this time would not be good.
//
// Inputs:
//
// index: The position for which you want the client.
//
//
// Outputs:
//
// result:  The event client found at this position.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  ec: TEventClient;
begin

  // Error checking on the index value.
  if (index < 0) or
  (index >= GetSinkCount()) then
  begin
    raise EInvalidIndex.Create('Invalid Index in TEventPoint.GetSink');
  end;

  // Acquire the Mutex.
  Lock();
  try
    ec := FEventList.Items[index] as TEventClient;
    result := ec;
  finally

    // Done with the Mutex.
    Unlock();
  end;
end;

procedure TEventPoint.CallEvents(eventList: TList);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  The default implementation of this function calls the event
// list with a pointer to the data that it will use to update itself with.
// Since this is a local copy of the list there is no danger of the list
// changing while the update is occuring.  Also clients that connect during
// this process will not be notified until the next time this event is fired
// since they are added to the master list and not the this local copy.
//
// Inputs:
//
// eventList:  local copy of the list that is provided which contains all of the
// events clients that will be notified for this event point.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  i: Integer;
  client: TEventClient;
  s: String;
begin
  Lock();
  client := nil; // Initialize to avoid compiler warning.
  try
    for i := 0 to eventList.Count - 1 do
    begin
      try
        FmtStr(s,
          classname + 'Fire event %d',
          [i]);
        FRunLock.TraceLog(traceDebug, s);

        // Get the client and fire its event.
        client := TEventClient(eventList[i]);
        client.CallEvent(FClientData);
      except
        on E: Exception do
        begin
          FmtStr(s, ' Exception occurred within CallEvents handler for ' +
            client.ClassName + '; Event %d of %d.',[i+1,eventList.Count]);
          ReportException(ClassName,errorNormal,s,E);
        end;
      end; 
    end;
  finally
    Unlock();
  end;
end;

function TEventPoint.GetEventPointKind: TEventPointKind;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function returns the type of event point that this
// point represents.
//
// Inputs: None.
//
//
// Outputs:
//
// result:  The type of the event point. single / or multiple.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // This is essentially read only and is set only at construction. No lock
  // needed.
  result := FType;
end;

function TEventPoint.GetEventClass: TEventClass;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function returns the class type of event point that this
// point represents.
//
// Inputs: None.
//
//
// Outputs:
//
// result:  The class type of the event point. TEventClient or descendant.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // This is essentially read only and is set only at construction. No lock
  // needed.
  result := FEventClass;
end;

procedure TEventPoint.SetFirstCallingContext;
begin
  FCallingState := epDirectThreadContext;
end;
////////////////////////////////////////////////////////////////////////////
procedure TEventPoint.SetNextCallingContext;
begin
  if FCallingState = epDirectThreadContext then
    FCallingState := epGUIThreadContext
  else if FCallingState = epGUIThreadContext then
    FCallingState := epAsyncGUIContext
  else
    FCallingState := epFreeMemory;
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TEventContainer
//
// Description:
//
// Class provides functionality to house multiple event types using EventPoint
// objects.  Each eventpoint type is kept inside a TList member variable.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Class TEventContainer
//
// Construction / Destruction
//
////////////////////////////////////////////////////////////////////////////////
{
procedure TEventContainer.DumpStackToTraceLog(stacklabel: string);
var
  myStack: TCallStack;
  myStackStr: string;
  myStackStrPart: string;
  strPos: integer;
begin
  FillCallStack(myStack, 0);
  myStackStr := CallStackTextualRepresentation(myStack, '');
  while (Length(myStackStr) > 0) do
  begin
    strPos := Pos(#10, myStackStr);
    myStackStrPart := Copy(myStackStr, 0, strPos);
    myStackStr := Copy(myStackStr, strPos+1, Length(myStackStr));
    FRunLock.TraceLog(traceDebug,
      format('%s (%s)',
        [stacklabel, myStackStrPart]));
  end;
end;
 }
constructor TEventContainer.Create;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Initialize member variables and create the delphi object.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  inherited Create;

  // Create the mutex semaphore.
  FRunLock := TPhiSyncObject.Create(className);

//{$ifdef debug}
//  FRunLock.TraceLog(traceDebug,
//    format('TEventContainer create runlock (%d)',[FRunLock.Handle]));
//  DumpStackToTraceLog('TEventContainer create runlock stack');
//{$endif}

  // create the cancel event
  FCancelEvent := TEvent.Create(nil, TRUE, FALSE, '');

{$ifdef debug}
  FRunLock.TraceLog(traceDebug,
    format('TEventContainer create cancel (%d)',[FCancelEvent.Handle]));
//  DumpStackToTraceLog('TEventContainer create cancel stack');
{$endif}

  // A client could theoretically try to use the list before it exists or during
  // the creation process. Need to protect against this.
  Lock();
  try

    // Create the list of event points.
    FEventPoints := TList.Create;
    FEventPoints.Capacity := 10;
  finally

    // OK done with the mutex.
    Unlock();
  end;
end;

destructor TEventContainer.Destroy;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Destroy this object also calls the defined callback
// EventPointDestroy().
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  i, num: Integer;
  eventPoint: TEventPoint;
begin

  // Get the Mutex.
  Lock();
  try

    num := FEventPoints.Count - 1;
    for i := num downto 0 do
    begin

      eventPoint := TEventPoint(FEventPoints[i]);
      if(eventPoint <> nil) then
      begin

        // Get and destroy the event point.
        eventPoint.Free();
      end;
      FEventPoints.Delete(i);
    end;
  finally
    Unlock();
  end;

  if (FEventPoints <> nil) then
  begin
    FEventPoints.Free;
    FEventPoints := nil;
  end;
  if (FCancelEvent <> nil) then
  begin
{$ifdef debug}
    FRunLock.TraceLog(traceDebug,
      format('TEventContainer delete cancel (%d)',[FCancelEvent.Handle]));
//    DumpStackToTraceLog('TEventContainer delete cancel stack');
{$endif}

    FCancelEvent.Free;
    FCancelEvent := nil;
  end;
  if (FRunLock <> nil) then
  begin
//{$ifdef debug}
//    FRunLock.TraceLog(traceDebug,
//      format('TEventContainer delete runlock (%d)',[FRunLock.Handle]));
//    DumpStackToTraceLog('TEventContainer delete runlock stack');
//{$endif}

    FRunLock.Free;
    FRunLock := nil;
  end;

  inherited;
end;

function TEventContainer.CreateEventPoint(eventType: TEventClass; eventKind: TEventPointKind; OnConnect: TNotifyEvent): TEventPoint;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function is called to create an event point in the list
// of the specified type.
//
//
// Inputs:
//
// eventType: specifies a single client event or a multiple client event.
//
// eventkind: specifies the class that will be used to call the event point.
//
//
// Outputs:
//
// result: a reference to the event point if it is successfully created.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  result := TEventPoint.Create(eventType,
    eventKind,
    OnConnect,
    Self);

  // Access to the list must be protected.
  Lock();
  try
    FEventPoints.Add(result);
  finally
    Unlock();
  end;
end;

function TEventContainer.GetEventPointCount: Integer;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this function to determine the number of event points or
// the number of different event types that this container supports.
//
//
// Inputs: None.
//
//
// Outputs:
//
// result: the number of events types supported by this event container.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  Lock();
  try
    result := FEventPoints.Count;
  finally
    Unlock();
  end;
end;

function TEventContainer.GetEventPoint(index: Integer): TEventPoint;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Get the event point from the list represented by the desired
// index.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  if (index < 0) and
    (index >= FEventPoints.Count) then
  begin
    raise EInvalidIndex.Create('Invalid Index in TEventContainer.GetEventPoint');
  end;

  // Event points cannot be removed once added. This is a read only function.
  // Therefore no lock is needed.  If this changes, this function will need to
  // be updated.
  result := TEventPoint(FEventPoints[index]);
end;

function TEventContainer.FindEventPoint(eventType: TEventClass): TEventPoint;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this function to return the eventpoint object that handles
// the specified type of events.
//
//
// Inputs:
//
// eventType:  the type of event you are intersted in getting the event point
// for.
//
//
// Outputs:
//
// result: If the Conatiner supports this event point it is a reference to that
// event point. Otherwise it is nil.
//
//
////////////////////////////////////////////////////////////////////////////////
var i: Integer;
    point: TEventPoint;
begin
  i := 0;
  result := nil;

  // Acquire the mutex semaphore.
  Lock();
  try

    // Iterate over the list.
    while i < FEventPoints.Count do
    begin

      // Get the event point.
      point := TEventPoint(FEventPoints[i]);

      // Does it match the specified type?
      if (point.GetEventClass = eventType) then
      begin

        // Yes. Save it and return it.
        result := point;
        i := FEventPoints.Count;
      end;

      // No. Keep looking.
      Inc(i);
    end;
  finally

    // Done with the mutex.
    Unlock();
  end;
end;

procedure TEventContainer.Lock;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function acquires the mutex sempaphore used in the thread
// handshaking.
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Acquire the mutex sempahore
  FRunLock.GetSyncObject();
end;

procedure TEventContainer.Unlock;
////////////////////////////////////////////////////////////////////////////////
//
// Description: This function release the lock on the mutex smepahore required
// for the thread handshaking.
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Acquire the mutex sempahore
  FRunLock.ReleaseSyncObject();
end;

{ TEventClient }

////////////////////////////////////////////////////////////////////////////////
//
// Class TEventClient
//
// Description:
//
// Class provides functionality provide an event function that can be called by
// a TEventContainer object.  Call Connect() to connect this object up to the
// desried server specified.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Class TEventClient
//
// Construction / Destruction
//
////////////////////////////////////////////////////////////////////////////////
{
procedure TEventClient.DumpStackToTraceLog(stacklabel: string);
var
  myStack: TCallStack;
  myStackStr: string;
  myStackStrPart: string;
  strPos: integer;
begin
  FillCallStack(myStack, 0);
  myStackStr := CallStackTextualRepresentation(myStack, '');
  while (Length(myStackStr) > 0) do
  begin
    strPos := Pos(#10, myStackStr);
    myStackStrPart := Copy(myStackStr, 0, strPos);
    myStackStr := Copy(myStackStr, strPos+1, Length(myStackStr));
    FRunLock.TraceLog(traceDebug,
      format('%s (%s)',
        [stacklabel, myStackStrPart]));
  end;
end;
 }
constructor TEventClient.Create;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Initialize member variables and create the delphi object.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  inherited Create();

  // Create the mutex semaphore.
  FRunLock := TPhiSyncObject.Create('TEventClient');

//{$ifdef debug}
//  FRunLock.TraceLog(traceDebug,
//    format('TEventClient create runlock (%d)',[FRunLock.Handle]));
//  DumpStackToTraceLog('TEventClient create runlock stack');
//{$endif}

  // Create the Disconnect synchronization semaphore.
  FDisconnectEvent := TEvent.Create(nil,
    TRUE,
    TRUE,
    '');

{$ifdef debug}
  FRunLock.TraceLog(traceDebug,
    format('TEventClient create disconnect (%d)',[FDisconnectEvent.Handle]));
//  DumpStackToTraceLog('TEventClient create disconnect stack');
{$endif}

  FCallingContext := epDirectThreadContext; //Default to direct thread context
end;

destructor TEventClient.Destroy;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Destroy this object also calls the defined callback
// EventPointDestroy().
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Disconnect from the server. Will use RunLock.
  try
    Disconnect();
  except
  end;

  //Cleanup.
  if (FDisconnectEvent <> nil) then
  begin
{$ifdef debug}
    FRunLock.TraceLog(traceDebug,
      format('TEventClient delete disconnect (%d)',[FDisconnectEvent.Handle]));
//    DumpStackToTraceLog('TEventClient delete disconnect stack');
{$endif}

    FDisconnectEvent.Free;
    FDisconnectEvent:= nil;
  end;
  if (FRunLock <> nil) then
  begin
//{$ifdef debug}
//    FRunLock.TraceLog(traceDebug,
//      format('TEventClient delete runlock (%d)',[FRunLock.Handle]));
//    DumpStackToTraceLog('TEventClient delete runlock stack');
//{$endif}

    FRunLock.Free;
    FRunLock:= nil;
  end;

  inherited Destroy();
end ;

////////////////////////////////////////////////////////////////////////////////
//
// Class TEventClient
//
// class functions.
//
////////////////////////////////////////////////////////////////////////////////

class procedure TEventClient.FreeData(EventPoint: TEventPoint);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this function to set free any data that might be
// represented by copies of objects in the event point data. For example in
// TWSMInternal event the event point data pointer represents an externally
// created TObject.  Here is your chance to cleanup that memory.
//
//
// Inputs:
//
// EventPoint:  The eventpoint that will hold the data that its clients will
// use.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

end;

class procedure TEventClient.SetData(EventPoint: TEventPoint);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this function to set the EventPoint FClientData pointer.
// The data passed in must all be put into a structure if more than one element
// or argument is required. Calling SetClientData will cause the eventpoint
// and it's data to get queued up for firing.
// Inputs:
//
// EventPoint:  The eventpoint that will hold the data that its clients will
// use.
// Outputs: None.
////////////////////////////////////////////////////////////////////////////////
begin
  if (EventPoint <> nil) then
    EventPoint.SetClientData(nil);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TEventClient
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TEventClient.Connect(Server: TEventContainer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Call this function to advise this Event client to the provided
// TEventContainer Server Object. Note: the FServer is NOT an eventpoint
// container but rather the eventpoint to which this client belongs.
//
//
// Inputs:
//
// Server: The server to which the event point will connect.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // If not a valid TEventContainer server nothing to do.
  if not Assigned(Server) then
  begin
    Exit;
  end;

  // Will touch member variables now need the mutex.
  Lock();
  try

    // Check for an existing EventPoint connection.
    if Assigned(FServer) then
    begin

      // Remove ourself from the existing eventpoint.
      FServer.UnAdvise(Self);
    end ;

    // Now find the event point in the provided server. TEventClass(classType)
    // allows us to move this code into the base class. It is a way for the
    // class to determine its own type and pass that into the FEventCOntainer.
    FServer := Server.FindEventPoint(TEventClass(classType)) ;
    if not Assigned(FServer) then
    begin
       Exit;
    end;

    // Set this sempahore. It is used to let you know you tried to disconnect
    // before you called the event code.
    FDisconnectEvent.ResetEvent();

    // Attach to the event point.
    FServer.Advise(Self);
  finally

    // Need to release the mutex now.
    Unlock();
  end;
end;


procedure TEventClient.Disconnect(fatal: BOOLEAN);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Call this function to unadvise this Event client from its
// currene event point conneciton. Note: the FServer is NOT an eventpoint
// container but rather the eventpoint to which this client belongs.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  waitResult: TWaitResult;
begin

  if(fatal = TRUE) then
  begin

    // Has this code been called without calling the event handlers? If a timeout
    // error occured this call has been called before the event handler has.
    // Perhaps this is the desired effect hence the low timeout.
    waitResult := FDisconnectEvent.WaitFor(50);
    if(waitResult = wrTimeout) then
    begin

      // Tried to call disconnect before event was called.
      raise EPHITimeout.Create('Tried to disconnect before handler was called',
        E_TIMEOUT,
        '',
        '',
        0);
    end;
  end;

  // Will access member variable get lock.
  Lock();
  try

    if Assigned(FServer) then
    begin

      // Detach from the EventPoint
      FServer.UnAdvise(Self);

      // Discard the EventPoint its not needed.
      FServer := nil ;
    end ;
  finally

    // Member variable access complete release the lock.
    Unlock();
  end;
end;

procedure TEventClient.EventPointDestroy;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Calls the user provide destroy callback.
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  if Assigned(FOnEventPointDestroy) then
  begin
    FOnEventPointDestroy(Self);
  end;
end;

procedure TEventClient.Lock;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function acquires the mutex sempaphore used in the thread
// handshaking.
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Acquire the mutex sempahore
  FRunLock.GetSyncObject();
end;

procedure TEventClient.Unlock;
////////////////////////////////////////////////////////////////////////////////
//
// Description: This function release the lock on the mutex smepahore required
// for the thread handshaking.
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Acquire the mutex sempahore
  FRunLock.ReleaseSyncObject();
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TEventClient
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TEventClient.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description: Call event call the client handler using the parameter data that
// it extracts out of the ClientData pointer that has been provided by the
// calling eventpoint.  This default implementation set a synchronization
// semaphore that checks to see if you have called the function before you
// disconnect.  All derived class must call this function.
//
// Inputs:
//
// ClientData:  a pointer to the most recent data held by the event point. It
// will be used to extract the parameters for the FOnEvent call.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  FDisconnectEvent.SetEvent();
end;

{ TThreadSafeEventContainer }

////////////////////////////////////////////////////////////////////////////////
//
// Class TThreadSafeEventContainer
//
// Description:
//
// Class provides all the functionality to the base class TEventContainer. In
// addition this class provides functionality to ensure that all event handlers
// will be call from the context of the GUI thread so that objects created there
// do not need to be thread safe.  A message is posted to the window of this
// class and it is used to call the event code.
//
////////////////////////////////////////////////////////////////////////////////

function StaticThreadSafeEventWndProc(Window: HWND; Message, wParam, lParam: Integer): Longint; stdcall;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  A window procedure must NOT be in a VTABLE and must be directly
// accessible in the code segment.  Therefore it is declared as a regular
// Pascal function.  This function is used as a gateway to get us back to the
// class object by directly calling the class function, i.e. this function
// although itself is a static function it is allowed to use and make calls into
// Delphi objects. This code is put in the TThreadSafeEventContainer section
// to remind you that only this class should ever call it. The programmer should
// however need to call this.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Pass control back to TThreadSafeEventContainer.  Note: at this point we
  // are now in the context of the GUI thread now. Proceed with caution.
  Result := TThreadSafeEventContainer.ThreadSafeEventWndProc(Window,
    Message,
    wParam,
    lParam);

  // When the above returns 1 we want to also have the default windows
  // processing for this message.
  if(Result = 1) then
  begin

    // Send the message to the default message handler.
    Result := DefWindowProc(Window, Message, wParam, lParam);
  end;
end;

var

// static variable emulation for the TThreadSafeEventContainer type Window.
gFThreadSafeEventWindowClass: TWndClass = (style: 0;
  lpfnWndProc: @StaticThreadSafeEventWndProc;
  cbClsExtra: 0;
  cbWndExtra: 0;
  hInstance: 0;
  hIcon: 0;
  hCursor: 0;
  hbrBackground: 0;
  lpszMenuName: nil;
  lpszClassName: 'ThreadSafeEventWindowClass');

// Window handle used for thread communication.  All messages will be posted to
// and dispached by this Window.
gFServerObjectCount: Cardinal = 0;

////////////////////////////////////////////////////////////////////////////////
//
// Class TThreadSafeEventContainer
//
// Construction / Destruction
//
////////////////////////////////////////////////////////////////////////////////

constructor TThreadSafeEventContainer.Create;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Initialize member variables and create the delphi object.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  inherited Create();

  // Note:  Rather than waste resources of the system all objects derived from
  // TThreadSafeEventContainer will use the same window.  Only the first object
  // of this type ever created then needs to create the window.
  if(gFMsgHandlerWnd = 0) and
    (gFServerObjectCount = 0) then
  begin

    // Create the window for this control.
    gFMsgHandlerWnd := AllocateWindow();

    // Get the ID of the GUI thread that creates this window. Subsequent message
    // will be posted to this thread.
    gFGUIThreadID := GetCurrentThreadId();
  end;

  // Increment out Global server count.
  Inc(gFServerObjectCount);
end;

destructor TThreadSafeEventContainer.Destroy;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Destroy this object also calls the defined callback
// EventPointDestroy().
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // One Less Server now .
  Dec(gFServerObjectCount);
  if(gFServerObjectCount = 0) then
  begin

    // Cleanup the GUI window.
    PostMessage(gFMsgHandlerWnd,
      WM_DESTROY,
      0,
      0);
  end;
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TThreadSafeEventContainer
//
// Class Functions
//
////////////////////////////////////////////////////////////////////////////////

class function TThreadSafeEventContainer.ThreadSafeEventWndProc(
  Window: HWND; Message, wParam, lParam: Integer): Longint;
////////////////////////////////////////////////////////////////////////////////
//
// Description: This class function is called to determine if the message is
// for us. Presently only WMU_RUNINGUITHREAD is handled which is a user message
// defined in the const section for this class. All messages for this class
// MUST pass a pointer to the calling TThreadSafeEventContainer as the wParam.
// You can then recast it back to the calling object here and call the
// FireEvents of the proper TThreadSafeEventContainer object.
//
// Inputs:
//
// Window: the handle of the calling window.
//
// message: the message to be processed by this function.
//
// wParam: The wParam for the message always Integer(TThreadSafeEventContainer)
// i.e. the reference of the calling TThreadSafeEventContainer cast to an
// Integer.
//
// lParam: Undefined the user may use this to pass his own data. For example our
// WMU_RUNINGUITHREAD message requires the type info for the ecentpoint to call.
// We simply pass this in the variable.
//
//
// Outputs:
//
// result: TRUE if you want DefWindowProc to also process this message. False
// means all processing is complete and you will not call DefWindowProc
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pEventContainer: TThreadSafeEventContainer;
//  eventClass: TEventClass;
  pEventPoint: TEventPoint;
begin
  if Message = WMU_RUNINGUITHREAD then
  begin
    // Extract parameters for this message.
    pEventContainer := TThreadSafeEventContainer(wParam);
    PEventPoint := TEventPoint(lParam);
//    pEventPoint := pEventContainer.FindEventPoint(eventClass);

    // OK we are in the context of the main thread now it is OK to fire the
    // events. The event in the list will be called with the data that was
    // previously set by calling the class function TEventClient::SetData().
    pEventContainer.FireEventsInternal(pEventPoint);
  end;
  result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TThreadSafeEventContainer
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////
procedure TThreadSafeEventContainer.FireEventsInternal(EventPoint: TEventPoint);
// This method is only called from TEventQueueThread.Execute and
// ThreadSafeEventWndProc.  When this method is called EventPoint is ready
// to run(i.e. call all the client event handlers).

var
  allEventsFired: boolean;
begin
  allEventsFired := False;
  try
    // All calling states come through this code(epDirectThreadContext,
    // epGUIThreadContext, epAsyncGUIContext).
    allEventsFired := EventPoint.FireEvents(eventPoint.FCallingState);
  finally
    EventPoint.SetNextCallingContext;  // Set next FCallingState
    if allEventsFired  then
    begin
      // EventPoint has called all client handlers. Free FClientData memory
      // and signal EventQueueControl.
      EventPoint.ClearEventData;
      EventPoint.FMessageSync.SetEvent;
      TEventQueueControl.GetCurrent.EventComplete(EventPoint);
    end
    else
    begin
      // We are not in the GUI  and all events have not been fired yet so we
      // Post a message to decouple us from the worker thread. This will cause
      // this function to be called again from the context of the main thread.
      // All reamining types are called from the context of the GUI thread.
      PostMessage(gFMsgHandlerWnd,
                  WMU_RUNINGUITHREAD,
                  Integer(Self),
                  Integer(EventPoint));
      // Cause event queue thread to run.
      TEventQueueControl.GetCurrent.EventQueueChange.SetEvent;
    end;
  end; // try - finally
end;
////////////////////////////////////////////////////////////////////////////////

procedure TThreadSafeEventContainer.FireEvents(eventType: TEventClass);
// This is the public method that is called from any object that wants
// to get the events fired of eventType.
// An object that is calling this should already have called SetData or
// SetClientData which puts the eventpoint and its data in the
// TEventQueueControl.EventQueue.  There is an extra check here, just
// in case it was not called.  It will get the event queued and then
// call FireQueuedEvents.
var
  eventPoint: TEventPoint;
begin
  eventPoint := FindEventPoint(eventType);
  if not TEventQueueControl.GetCurrent.IsEventInQueue(eventPoint) then
    eventPoint.SetClientData(nil);
  TEventQueueControl.GetCurrent.FireQueuedEvents(eventPoint);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TThreadSafeEventContainer
//
// Implementation
//
////////////////////////////////////////////////////////////////////////////////

function TThreadSafeEventContainer.AllocateWindow: HWND;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  This function creates the window that is responsible for
// handling the messages that cause the client to be fired in the context of
// the GUI thread.  Note: It was much easier to use a native Win32 API window
// rather than a Delphi object. That means you only have a handle to the
// window and may not call Delphi functions on this window.
//
//
// Inputs: None.
//
//
// Outputs:
//
// HWND: The handle to the window created.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  TempClass: TWndClass;
  ClassRegistered: Boolean;
begin

  // Setup the instance for our class.
  gFThreadSafeEventWindowClass.hInstance := HInstance;

  // Has this class been registered yet i.e. we create the window by passing
  // a pointer to the class.
  ClassRegistered := GetClassInfo(HInstance,
      gFThreadSafeEventWindowClass.lpszClassName,
      TempClass);

  // Are we not reigstered register with the system?
  if not ClassRegistered  or
    (TempClass.lpfnWndProc <> @StaticThreadSafeEventWndProc) then
  begin
    if ClassRegistered then
    begin
      Windows.UnregisterClass(gFThreadSafeEventWindowClass.lpszClassName,
        HInstance);
    end;

      // No then register.
      Windows.RegisterClass(gFThreadSafeEventWindowClass);
    end;

  // Create a Window of our new class. It will be invisible and only used to
  // transfer code execution to the MainThread.  All TThreadSafeEventContainers
  // will use this single window.
  Result := CreateWindow(gFThreadSafeEventWindowClass.lpszClassName,
    '',
    0,
    0,
    0,
    0,
    0,
    HWND(HWND_MESSAGE),
    0,
    HInstance,
    nil);
end;

end.


