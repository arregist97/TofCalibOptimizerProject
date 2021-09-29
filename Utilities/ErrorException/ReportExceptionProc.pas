unit ReportExceptionProc;

////////////////////////////////////////////////////////////////////////////////
//
// Filename:  ReportException.pas
// Created:   on 6-21-02 by Melinda Caouette
// Purpose:   This module defines global helper procedures
//              for error reporting and the option of reraising exceptions.
//
//*********************************************************
// Copyright © 2002-04 Physical Electronics, Inc.
// Created in 2002 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
//
////////////////////////////////////////////////////////////////////////////////

interface

uses
  SysUtils,
  ObjectPhi;

// procedure for reporting error to E&AH and re-raising the exception
procedure ReportException(const ObjectName: string; const Level: TErrorLevel;
      const AppendMessage: string; const E: Exception) ;

// procedure for reporting error to E&AH
procedure ReportError(const ObjectName: string; const Level: TErrorLevel;
      const ErrorCode: Integer; const Description: String) ;

implementation

uses
  Windows,
  ComObj,
  ActiveX,
  ErrorAndAlarmHandler,
  SYSLOGQUEUELib_TLB,
  SysLogQueue;

procedure ReportException(const ObjectName: string; const Level: TErrorLevel;
      const AppendMessage: string; const E: Exception) ;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Extract exception information and report the error to E&AH.
//                If E&AH is not available, just log the error.
// Inputs: ObjectName - name of the object that raises the exception
//         Level - error level
//         AppendMessage - any message to be appended before the exception message
//         E - exception
// Outputs: None
// Exceptions:
// Note:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  errorCode: HResult;                      // error code
  errorMessage: String;                    // error message
  oleSysError: EOleSysError;               // exception as EOleSysError
begin
  // determine the error code
  if (E is EOleSysError) then
  begin
    oleSysError := EOleSysError(E) ;
    errorCode := oleSysError.ErrorCode ;
  end
  else // no error code info
    errorCode := E_UNEXPECTED;

  // ignore OLE_E_WRONGCOMPOBJ (compobj.dll and ole2.dll mismatch - 16/32 comp. dlls)
  if(errorCode <> OLE_E_WRONGCOMPOBJ) then
  begin
    // assemble the message
    errorMessage := 'detected exception(' + E.Classname + ') '+ AppendMessage + '; ' + E.Message ;

    // call report error (procedure located below)
    ReportError(ObjectName, Level, errorCode, errorMessage) ;
  end;
end;

procedure ReportError(const ObjectName: string; const Level: TErrorLevel;
      const ErrorCode: Integer; const Description: String) ;
////////////////////////////////////////////////////////////////////////////////
// Description: Report error to E&AH.
// Inputs: ObjectName - name of the object that raises the exception
//         Level - error level
//         ErrorCode - HResult error code used to map errors to alarms
//         Description - the error message to report
// Outputs: None
// Exceptions:
// Note:
//
////////////////////////////////////////////////////////////////////////////////
var
  eLevel: ErrorLevel ;                     // error level
  ErrorAndAlarmHandler: TErrorAndAlarmHandler;
begin
  ErrorAndAlarmHandler := TErrorAndAlarmHandler.GetInstance;
  if (Assigned(ErrorAndAlarmHandler)) then  // Error and Alarm Handler is ready/available
  begin
    // let E&AH handles the error reporting
    ErrorAndAlarmHandler.ReportError(ObjectName, Level, ErrorCode, Description) ;
  end
  else // E&AH is not available => just log the error to system log
  begin
    // log the error
    case Level of
      errorWarning:    eLevel := eWarning;
      errorNormal:     eLevel := eNormal;
      errorCritical:   eLevel := eCritical ;
    else
      eLevel := eNormal;
    end;
    LogErrorMsg(ObjectName, eLevel, ErrorCode, Description) ;
  end;
end;

end.
