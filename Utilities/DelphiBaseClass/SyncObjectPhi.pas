unit SyncObjectPhi;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  SyncObjectPhi.pas
// Created:   on 11-05-01 by Melinda Caouette
// Purpose:   This module defines a base class that provides
//            intra-object synchronization support to protect
//            its states and variables from multithreads.
//            Mutex is used for synchronization and there is a
//            maximum wait time of 250 ms.
//*********************************************************
// Copyright © 2001 Physical Electronics, Inc.
// Created in 2001 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////
interface

uses
  Windows, objectPhi, PhiErrorCodes, PhiExceptions ;

type
  // PHI synchronization class
  TPhiSyncObject = class(TPhiObject)
  private
    FMutex: THandle ;             // mutex for intra-object synchronization;
                                  // used to protect states and variables
    FValidSyncObject: Boolean ;   // indicate if synchronization object created is valid

  protected
    function SyncObjectCreated: boolean ;

  public
    constructor Create(strName : string; bEnableLog : boolean) ; override;
    constructor Create(strName : string); override;
    destructor Destroy; override;

    function GetSyncObject: boolean ;
    procedure ReleaseSyncObject ;
  end;


implementation
uses
  Variants, Sysutils;

const
{$IFDEF Debug}
  SYNC_TIMEOUT_MS = 6000 ;     // timeout value for waiting for mutex in ms for debug
{$ELSE}
  SYNC_TIMEOUT_MS = 25 ;       // timeout value for waiting for mutex in ms
{$ENDIF}

{ TPhiSyncObject }

constructor TPhiSyncObject.Create(strName: string; bEnableLog: boolean);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       strName - name of object instance
//               bEnableLog -- True to enable logging; False to disable. Default to True.
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  inherited Create(strName, bEnableLog) ;

  FMutex := CreateMutex(nil, False, nil) ;

  if (FMutex <> NULL) then   // successful
    FValidSyncObject := True
  else   // failed to create a mutex
  begin
    ErrorLog(errorCritical, E_FAIL, 'Unable to create mutex for synchronization') ;
    FValidSyncObject := False ;
  end ;
end;

constructor TPhiSyncObject.Create(strName: string);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       strName - name of object instance
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  Create(strName, True);
end;

destructor TPhiSyncObject.Destroy;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  if (FValidSyncObject) then
  begin
    CloseHandle(FMutex) ;
    FValidSyncObject := False ;
  end ;

  inherited;
end;

function TPhiSyncObject.GetSyncObject: boolean;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Attempt to get the synchronization object (mutex)
// Inputs:       None
// Outputs:      True if synchronization object grabbed, False if unable to do so
// Note:         There is a timeout limit for attemting to grab the synchronization object
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  bGetSyncObject: boolean ;            // able to get sync object?
  nNoOfRetry: integer;
  msgstr: String;
begin
  bGetSyncObject := False ;

  if (FValidSyncObject) then
  begin
    nNoOfRetry := 1 ;
    while ((not bGetSyncObject) and (nNoOfRetry <= 12)) do
    begin
      // attempt to get the synchronization object (should return as soon as it's available)
      // if timeout occurs, this method should fail
      if (WaitForSingleObject(FMutex, SYNC_TIMEOUT_MS * nNoOfRetry) = WAIT_OBJECT_0) then // got mutex before timeout
        bGetSyncObject := True
      else  // fail to grab mutex => try again
      begin
        // log message
        Fmtstr(msgstr, 'Attempt #%d to get sync object failed for thread %d.\n',
          [nNoOfRetry, GetCurrentThreadId]) ;
        TraceLog(traceDiagnose, msgstr) ;

        Inc(nNoOfRetry);
      end
    end;

    if (not bGetSyncObject) then
      ErrorLog(errorNormal, E_FAIL, 'Unable to get sync object (mutex)') ;
  end;

  Result := bGetSyncObject ;
end;

procedure TPhiSyncObject.ReleaseSyncObject;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Release the synchronization object
// Inputs:       None
// Outputs:      none
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  if (FValidSyncObject) then
  begin
    ReleaseMutex(FMutex) ;
  end ;
end;

function TPhiSyncObject.SyncObjectCreated: boolean;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return True if valid synchronization object created (for use
//                by derived classes to check for valid sync object)
// Inputs:       None
// Outputs:      True if sync object created, False if otherwise
// Note:         
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  Result := FValidSyncObject ;
end;

end.
