unit SysLogQueue;

////////////////////////////////////////////////////////////////////////////////
//
// Filename:  SysLogQueue.pas
// Created:   on 06-23-04 by Melinda Caouette
// Purpose:   Provide global methods for logging messages to system log.
//             It also hides the details of the implementation so in the future
//             we can replace the SysLogQueue with something else easily.
//
// History:
// 1) Initial version
//     - Melinda Caouette 06-23-04
//
//*********************************************************
// Copyright © 2004 Physical Electronics USA
// Created in 2004 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
//
////////////////////////////////////////////////////////////////////////////////

interface

uses
  sysutils,
  SYSLOGQUEUELib_TLB;

function  LogTraceMsg(const ObjectName: WideString; Level: TraceLevel; const Msg: WideString): HResult; stdcall;
function  LogErrorMsg(const ObjectName: WideString; Level: ErrorLevel; Code: HResult;
                      const Msg: WideString): HResult; stdcall;
function  LogAlarmMsg(const ObjectName: WideString; const Msg: WideString): HResult; stdcall;

function GetSysLogQueueIntf: ISystemLogQueue2;

implementation

uses
  Windows,
  ComObj,
  ActiveX,

  StandardErrorCodes;

function  LogTraceMsg(const ObjectName: WideString; Level: TraceLevel; const Msg: WideString): HResult;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Log a trace message to the system log
// Inputs: ObjectName - name of the object that the trace message originates from
//         Level - trace level
//         Msg - the trace message to log
// Outputs: None
// Note:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  systemLogQueueIntf: ISystemLogQueue2;    // ISystemLogQueue interface ptr to SysLogQueue
  hr: HResult;
begin
  hr := S_OK;

  // get interface pointer to SysLogQueue from ROT
  systemLogQueueIntf := GetSysLogQueueIntf ;
  if (systemLogQueueIntf <> nil) then
  begin
    try
      systemLogQueueIntf.LogTraceMsg(ObjectName, Level, Msg + chr($0A));
    except
     on E: EOleSysError do
       hr := E.ErrorCode;
     on E: Exception do
       hr := E_FAIL;

      // don't raise exception to avoid infinite loop {LogError raiseException}+
    end ;

    // clean up
    systemLogQueueIntf := nil ;
  end ;

  Result := hr;
end;

function  LogErrorMsg(const ObjectName: WideString; Level: ErrorLevel; Code: HResult;
                      const Msg: WideString): HResult;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Log an error message to the system log
// Inputs: ObjectName - name of the object that the error messagge originates from
//         Level - error level
//         Code - error hresult code
//         Msg - the message to log
// Outputs: None
// Note:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  systemLogQueueIntf: ISystemLogQueue2;    // ISystemLogQueue interface ptr to SysLogQueue
  hr: HResult;
begin
  hr := S_OK;

  // get interface pointer to SysLogQueue from ROT
  systemLogQueueIntf := GetSysLogQueueIntf ;
  if (systemLogQueueIntf <> nil) then
  begin
    try
      systemLogQueueIntf.LogErrorMsg(
        ObjectName,
        Level,
        Code,
        Msg + ' ' +  GetStringFromErrorCode(Code)+ chr($0A)   // fill in more description for error hresult
        );
    except
     on E: EOleSysError do
       hr := E.ErrorCode;
     on E: Exception do
       hr := E_FAIL;

      // don't raise exception to avoid infinite loop {LogError raiseException}+
    end ;

    // clean up
    systemLogQueueIntf := nil ;
  end ;

  Result := hr;
end;

function  LogAlarmMsg(const ObjectName: WideString; const Msg: WideString): HResult;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Log an alarm message to the system log
// Inputs: ObjectName - name of the object that the alarm message originates from
//         Msg - the message to log
// Outputs: None
// Note:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  systemLogQueueIntf: ISystemLogQueue2;    // ISystemLogQueue interface ptr to SysLogQueue
  hr: HResult;
begin
  hr := S_OK;

  // get interface pointer to SysLogQueue from ROT
  systemLogQueueIntf := GetSysLogQueueIntf ;
  if (systemLogQueueIntf <> nil) then
  begin
    try
      systemLogQueueIntf.LogAlarmMsg(ObjectName, Msg + chr($0A));
    except
     on E: EOleSysError do
       hr := E.ErrorCode;
     on E: Exception do
       hr := E_FAIL;

      // don't raise exception to avoid infinite loop {LogError raiseException}+
    end ;

    // clean up
    systemLogQueueIntf := nil ;
  end ;

  Result := hr;
end;

function GetSysLogQueueIntf: ISystemLogQueue2;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return an interface pointer to SysLogQueue component
// Inputs:       Sender as TButton
// Outputs:      None
// Return:       ISystemLogQueue2 interface pointer to SysLogQueue; nil if failed
// Note:         GetActiveObject takes care of the different thread context.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  systemLogQueueIntf: ISystemLogQueue2;   // ISystemLogQueue interface ptr to SysLogQueue
  serverIUnknown: IUnknown;              // IUnknown interface ptr to SysLogQueue
  hr: HRESULT;
begin
  systemLogQueueIntf := nil ;
  serverIUnknown := nil ;

  try
    // get interface pointer to SysLogQueue from ROT
    hr := GetActiveObject(CLASS_CoSystemLogQueue {class id}, nil, serverIUnknown) ;
    if (SUCCEEDED(hr)) then
      systemLogQueueIntf := serverIUnknown as ISystemLogQueue2
    else // can't get it from ROT => create it instead
      systemLogQueueIntf := CoCoSystemLogQueue.Create as ISystemLogQueue2;

  except
    // don't raise exception to avoid infinite loop {LogError raiseException}+
  end ;

  Result := systemLogQueueIntf;

  // clean up
  serverIUnknown := nil ;
  systemLogQueueIntf := nil ;
end ;

end.

