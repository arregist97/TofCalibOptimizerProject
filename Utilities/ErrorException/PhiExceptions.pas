unit PhiExceptions;

////////////////////////////////////////////////////////////////////////////////
//
// Filename:  PhiExceptions.pas
// Created:   on 11-09-01 by Melinda Caouette
// Purpose:   This module defines PHI derived exception classes.
//
// History:
//
// 1) Initial version
//
// 2) Merged changes from Revera and cleaned up
//    - Melinda Caouette 06-24-04
//
//*********************************************************
// Copyright © 2001-04 Physical Electronics USA
// Created in 2001 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
//
////////////////////////////////////////////////////////////////////////////////

interface

uses
  ComObj,
  ObjectPhi,
  sysutils,
  SysLogqueue,
  SYSLOGQUEUELib_TLB;

type
  {Phi Exception Classes}

  EPhiException = class(EOleException)
  public
    constructor Create(const ObjectName: string; const Level: TErrorLevel;
      const Message: string; ErrorCode: HRESULT;
      const Source, HelpFile: string; HelpContext: Integer;
      LogError: Boolean=true); overload; virtual;
    constructor Create(const Message: string; ErrorCode: HRESULT;
      const Source, HelpFile: string; HelpContext: Integer); overload;
 end;

  EPhiHardware = class(EPhiException)  ;
  EPhiComException = class(EPhiHardware);
  EPhiStage = class(EPhiHardware);
  EPhiIonGun = class(EPhiHardware);
  EPhiNeut = class(EPhiHardware);
  EPhiVac = class(EPhiHardware);
  EPhiMotor = class(EPhiHardware);
  EFrameGrabberException = class(EPhiHardware);
  ECameraException = class(EPhiHardware);
  EKnobBoxControlException = class (EPhiHardware);
  EXRayException = class (EPhiHardware);
  EGauzeLensException = class (EPhiHardware);
  EBiasBoxException = class (EPhiHardware);
  EShutterBiasException = class (EPhiHardware);
  ESCAAnalyzerException = class (EPhiHardware);
  ESCAMultiplierException = class (EPhiHardware);
  EScanBoardException = class (EPhiHardware);
  EC60IonGunException = class(EPhiHardware);
  EGCIBException = class(EPhiHardware);
  EJunctionIOException = class(EPhiHardware);
  EIonGaugeException = class(EPhiHardware);
  ETungstenEGunException = class (EPhiHardware);

  EPhiSoftware = class(EPhiException)  ;
  EPhiInvalidParameter = class(EPhiSoftware);
  EPhiLockObject = class(EPhiSoftware)  ;
  EPhiTimeout = class(EPhiSoftware);
  EStateMachine = class(EPhiSoftware);
  EState = class(EPhiSoftware) ;
  ELogServer = class(EPhiSoftware) ;
  EKnObjectException = class(EPhiSoftware);
  EAcqProcCtrlException = class(EPhiSoftware) ;
  EAcqControlException = class(EPhiSoftware);
  EScanPattern = class(EPhiSoftware);
  ESampleHandlingException = class(EPhiSoftware);
  EPlatenTransferStateMachineException = class(EPhiSoftware);
  EImagingDataException = class(EPhiSoftware);
  ESavingDataStateMachineException = class(EPhiSoftware);
  EVacuumProcessControlException = class(EPhiSoftware);
  EBakeProcessControlException = class(EPhiSoftware);
  ESublimationProcessControlException = class(EPhiSoftware);
  ESPSIntroPhotoManagementException = class(EPhiSoftware);
  EAnalyzerManagerException = class(EPhiSoftware);
  EIonGunProcessControlException = class(EPhiSoftware);
  EGunProcessControlException = class(EPhiSoftware);
  EC60IonGunProcessControlException = class(EPhiSoftware);
  EImageRegistrationProcessControlException = class(EPhiSoftware);
  EGCIBProcessControlException = class(EPhiSoftware);
  EWaferHandlerProcessControlException = class(EPhiSoftware);
  EAutoVideoProcessControlException = class(EPhiSoftware);
  EAmmeterProcessControlException = class(EPhiSoftware);
  ESEMProcessControlException = class(EPhiSoftware);
  EMCPProcessControlException = class(EPhiSoftware);
  EHardwareManagerProcessControlException = class(EPhiSoftware);
  EXRayProcessControlException = class(EPhiSoftware);
  ESequencerControllerException = class(EPhiSoftware);
  EDSIProcessControlException = class(EPhiSoftware);
  EEventServerException = class(EPhiSoftware);
  EEGunNeutProcessControlException = class(EPhiSoftware);
  EInstrumentProcessControlException = class(EPhiSoftware);
  EHotColdStageProcessControlException = class(EPhiSoftware);
  ESputterToolProcessControlException = class(EPhiSoftware);
  EIonNeutProcessControlException = class(EPhiSoftware);
  ECesiumProcessControlException = class(EPhiSoftware);
  ETOF_DR_Exception = class(EPhiSoftware);
  ERawDataAggregatorProcessControlException = class(EPhiSoftware);
  EPhiLmigProcessControlException = class(EPhiSoftware);
  EMS2SupplyProcessControlException = class(EPhiSoftware);
  EMassCalibrationException = class(EPhiSoftware);
  EFibProcessControlException = class(EPhiSoftware);
  EHotColdProcessControlException = class(EPhiSoftware);
  EDualSourceIonGunProcessControlException = class(EPhiSoftware);
  EUPSProcessControlException = class(EPhiSoftware);
  ESmartWatcherControlException = class(EPhiSoftware);
  EStageProcessControlException = class(EPhiSoftware);

  EPhiSimulator = class(EPhiException);

  EStateMachineTimeout = class(EPhiSoftware)
  private
    FnStateAfterTimeout: Integer;   // after timeout, which state to transition to
  public
    property nStateAfterTimeout: Integer read FnStateAfterTimeout;

    constructor Create(const ObjectName: string; const Level: TErrorLevel;
      const Message: string; ErrorCode: HRESULT;
      const Source, HelpFile: string; HelpContext: Integer;
      const nStateAfterTimeout: Integer); reintroduce;
  end;

  // We don't want to log this error. Trap and ignore.
  // Intended to help us ignore the EOLE_WRONG_COMPOBJ exception.
  EIgnorableWrongCompObj = class(EOleException)
  public
    constructor Create(const Message: string; ErrorCode: HRESULT); overload;
  end;

implementation

uses
  ActiveX,
  ErrorAndAlarmHandler ;

////////////////////////////////////////////////////////////////////////////////
//
// Class EPhiException
//
// EPhiException is the PHI exception base class.
//
////////////////////////////////////////////////////////////////////////////////

constructor EPhiException.Create(const ObjectName: string;
  const Level: TErrorLevel; const Message: string; ErrorCode: HRESULT;
  const Source, HelpFile: string; HelpContext: Integer; LogError: Boolean);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Constructor
// Inputs: ObjectName - name of the object that raises the exception
//         Level - error level
//         Message - error message
//         ErrorCode - error code
//         Source - source of the exception
//         HelpFile - full path of the help file that describes the error
//         HelpContext - help-context ID number for context-sensitive online help
//                       associated with the exception.
//         LogError - set to true (dafault) to call LogErrorMsg().
// Outputs: None
//
// Note:
// Exceptions:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  eLevel: ErrorLevel;                       // error level
begin
  inherited Create(Message, ErrorCode, Source, HelpFile, HelpContext);

  // get interface pointer to SysLogQueue from ROT
  case Level of
    errorWarning:    eLevel := eWarning;
    errorNormal:     eLevel := eNormal;
    errorCritical:   eLevel := eCritical ;
  else
    eLevel := eNormal;
  end;

  if (LogError) then
    LogErrorMsg(ObjectName, eLevel, ErrorCode, Message);

end;

constructor EPhiException.Create(const Message: string; ErrorCode: HRESULT;
  const Source, HelpFile: string; HelpContext: Integer);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Constructor
// Inputs: Message - error message
//         ErrorCode - error code
//         Source - source of the exception
//         HelpFile - full path of the help file that describes the error
//         HelpContext - help-context ID number for context-sensitive online help
//                       associated with the exception.
// Outputs: None
//
// Note: Default to Normal error level and use class name as object name in error
//       logging message.
// Exceptions:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  // default object name to class name and error level to NORMAL
  Create(ClassName, errorNormal, Message, ErrorCode, Source, HelpFile, HelpContext) ;
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class EStateMachineTimeout
//
// An exception class for state machine timeout.
//
////////////////////////////////////////////////////////////////////////////////

constructor EStateMachineTimeout.Create(const ObjectName: string;
  const Level: TErrorLevel; const Message: string; ErrorCode: HRESULT;
  const Source, HelpFile: string; HelpContext: Integer;
  const nStateAfterTimeout: Integer);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Constructor
// Inputs: ObjectName - name of the object that raises the exception
//         Level - error level
//         Message - error message
//         ErrorCode - error code
//         Source - source of the exception
//         HelpFile - full path of the help file that describes the error
//         HelpContext - help-context ID number for context-sensitive online help
//                       associated with the exception.
//         nStateAfterTimeout - which state to transition to after timeout
// Outputs: None
//
// Note:
// Exceptions:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
  inherited Create(ObjectName, Level, Message, ErrorCode, Source, HelpFile, HelpContext);

  FnStateAfterTimeout := nStateAfterTimeout;
end;


////////////////////////////////////////////////////////////////////////////////
//
// Class EIgnorableWrongCompObj
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Constructor
// Inputs: Message - error message
//         ErrorCode - error code
// Outputs: None
//
// Exceptions:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor EIgnorableWrongCompObj.Create(const Message: string; ErrorCode: HRESULT);
begin
  inherited Create(Message, ErrorCode, '', '', 0);

  // trace error
  LogTraceMsg('EIgnorableWrongCompObj', tDebug, Message);
end;

end.

