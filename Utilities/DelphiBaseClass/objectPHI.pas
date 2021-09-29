unit ObjectPhi;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  PHIObject.pas
// Created:   on 99-12-27 by Melinda Caouette
// Purpose:   This module defines a utility class for all PHI classes
//             to provide logging capability. Since Delphi does not
//             support multiple inheritance, we will use composition
//             instead of inheritance to provide functionality for
//             PHI classes.
//*********************************************************
// Copyright © 1999 Physical Electronics, Inc.
// Created in 1999 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////
interface

uses
  Windows,
  Dialogs,
  Forms,
  Controls,
  ActiveX,
  SYSLOGQUEUELib_TLB;

const
   c_ColonSpace = ': ';
   c_ErrorSpace = 'ERROR: ';
   PHIOBJ_BEEP = MB_ICONASTERISK;

{TPhiObject}
type
  TPHIResult = longint;
  TErrorLevel = (errorWarning, errorNormal, errorCritical, errorOff);
  TTraceLevel = (traceDebug, traceService, traceDiagnose, traceUser, traceOff);
  TDialogType = (infoDialog, warningDialog, errorDialog, confirmDialog);
  TDialogButtons = (ok, cancel, okcancel, yesNo, yesNoCancel);
  TDialogResult = (okResult, cancelResult, yesResult, noResult);

  TPhiObject = class(TObject)
  private
    m_ErrorLevel: TErrorLevel;  // current error logging level
    m_TraceLevel: TTraceLevel;  // current trace logging level
    m_Simulation: Boolean;        // simulation flag
    m_strName: string;          // name of object instance

    procedure ModelessDialogOnOkClick(Sender: TObject);
    procedure ModelessDialogOnClose(Sender: TObject; var Action: TCloseAction);

  protected
    FbEnableLogging: Boolean;      // enable trace logging?

  public
    constructor Create(strName : string; bEnableLog : boolean); overload; virtual;
    constructor Create(strName : string); overload; virtual;
    destructor  Destroy(); override;

    procedure Initialize(); overload; virtual;
    procedure DeInitialize(); virtual;
    class procedure Register(Name: String);

    // logging methods
    procedure ErrorLog(Level: TErrorLevel; Code: HResult; strMsg: string); overload;
    procedure ErrorLog(Level: TErrorLevel; Code: HResult; strMsg: string; Args: array of const); overload;
    function  ErrorLog(Level : TErrorLevel; Code : HResult; bReported : boolean;
      PrevError : TPHIResult; strMsg : string): TPHIResult; overload;
    procedure TraceLog(Level : TTraceLevel; strMsg : string); overload;
    procedure TraceLog(Level: TTraceLevel; strMsg: string; Args: array of const); overload;
    procedure AlarmLog(strMsg: String);


    function ModalDialog(DialogType: TDialogType; Buttons: TDialogButtons;
                        strMsg: string): TDialogResult;
    function ModelessDialog(DialogType: TDialogType; strMsg: string): TForm;
    function ModelessWaitDialog(strMsg: string): TForm;

    function MessageDialog(DialogType: TDialogType; Buttons : TDialogButtons;
                     strMsg : string) : TDialogResult;
    function MessageDialogCreate(DialogType: TDialogType; Buttons: TDialogButtons;
                     strMsg: string): TForm;
    function MessageDialogShow(Dialog: TForm): TDialogResult;
    procedure MessageDialogClose(Dialog: TForm; CloseResult: TDialogResult);

    function  GetName: string;  overload;
    procedure SetName(strName: string); overload;
    function  GetSimulation : Boolean; overload;
    procedure SetSimulation(Mode : Boolean); overload; virtual;
    function  GetTraceLevel : TTraceLevel;overload;
    procedure SetTraceLevel(Level : TTraceLevel); overload; virtual;
    function  GetErrorLevel : TErrorLevel; overload;
    procedure SetErrorLevel(Level : TErrorLevel); overload;
    function  GetLoggingEnabled: Boolean;
    procedure SetLoggingEnabled(Enabled: Boolean);

    // IPhiObject methods
    procedure GetName(var pRes: SYSINT; out name: WideString); overload;
    procedure GetSimulation(var pRes: SYSINT; out mode: WordBool); overload;
    procedure SetSimulation(var pRes: SYSINT; mode: WordBool); overload;
    procedure GetErrorLevel(var pRes: SYSINT; out pLevel: ErrorLevel); overload;
    procedure SetErrorLevel(var pRes: SYSINT; level: ErrorLevel); overload;
    procedure GetTraceLevel(var pRes: SYSINT; out pLevel: TraceLevel); overload;
    procedure SetTraceLevel(var pRes: SYSINT; level: TraceLevel); overload;

    property Simulated: Boolean read m_Simulation write m_Simulation;
  end;

Function GetX87SW: word; // Assembler;
procedure ClearX87Exceptions;

var
  fpu: word;
  fpuBogus: Integer;

implementation

uses
  StdCtrls,
  SysUtils,
  ComObj,
  SysLogQueue,
  PhiObjectRegister,
  ObjectManagerPhiObjectInterface;


////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       strName - name of object instance
//               bEnableLog -- True to enable logging; False to disable. Default to True.
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TPhiObject.Create(strName : string; bEnableLog : boolean);
begin
  inherited Create;

  m_strName := strName;

  // Set default error and trace levels
  m_ErrorLevel := errorOff;
  m_TraceLevel := traceOff;
  m_Simulation := False;
  FbEnableLogging := bEnableLog;

end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       strName - name of object instance
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TPhiObject.Create(strName : string);
begin
  Create(strName, True);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TPhiObject.Destroy();
begin
   inherited Destroy;
end;


////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get name of object instance.  Each instance of this class (or derived class)
//                has a different name.
// Inputs:       None
// Return:       Object name
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiObject.GetName: string;
begin
   Result := m_strName;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Do Initialization
// Inputs:       None
// Outputs:      None
// Note:         Base class will override
////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.Initialize();
begin
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Do De-initialization
// Inputs:       None
// Outputs:      None
// Note:         Base class will override
////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.DeInitialize();
begin
end;

class procedure TPhiObject.Register(Name: string);
//  Register the class with the object manager.
//  Each subclass of TBaseClass1 should add a call
//  to this method in it's initialization section (of the unit).
//  note: Since this is a class method, self is the class reference,
//  not an instance.
begin
  TPhiObjectRegister.Register(self,Name, TObjectManagerPhiObjectInterface);
end;


////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set name of object instance.  Each instance of this class (or derived class)
//                has a different name.
// Inputs:       None
// Return:       Object name
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.SetName(strName: string);
begin
   m_strName := strName;
end;

function TPhiObject.GetSimulation: Boolean;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get simulation mode.
// Inputs:       None
// Outputs:      Simulation mode
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
   Result := m_Simulation;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set simulation mode for this object.
// Inputs:       Mode: Simulation mode
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.SetSimulation(Mode: Boolean);
begin
   m_Simulation := Mode;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get current Error Logging Level.
// Inputs:       None
// Return:       Current Error logging level
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiObject.GetErrorLevel: TErrorLevel;
begin
   Result := m_ErrorLevel;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set error logging level for this object.
// Inputs:       Level - error logging level
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.SetErrorLevel(Level: TErrorLevel);
begin
   m_ErrorLevel := Level;
end;

function TPhiObject.GetTraceLevel: TTraceLevel;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get current Trace Logging Level.
// Inputs:       None
// Outputs:      Current Trace logging level
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
begin
   Result := m_TraceLevel;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set trace logging level for this object.
// Inputs:       Level - trace logging level
// Return:       None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.SetTraceLevel(Level: TTraceLevel);
begin
   m_TraceLevel := Level;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get name of object instance.  Each instance of this class (or derived class)
//                has a different name.
// Inputs:       None
// Outputs:      pRes - phi result value (not used)
//               name - object name (used in logging)
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.GetName(var pRes: SYSINT; out name: WideString);
begin
  pRes := 0;
  name := m_strName;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set simulation mode for this object.
// Inputs:       None
// Outputs:      pRes - phi result value (not used)
//               mode - simulation mode
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.GetSimulation(var pRes: SYSINT; out mode: WordBool);
begin
  pRes := 0;
  mode := m_Simulation;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set simulation mode for this object.
// Inputs:       mode - simulation mode
// Outputs:      pRes - phi result value (not used)
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.SetSimulation(var pRes: SYSINT; mode: WordBool);
begin
  pRes := 0;
  m_Simulation := mode;
end;

////////////////////////////////////////////////////////////////////////////////
function  TPhiObject.GetLoggingEnabled: Boolean;
begin
  result := FbEnableLogging;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.SetLoggingEnabled(Enabled: Boolean);
begin
  FbEnableLogging := Enabled;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get error logging level for this object.
// Inputs:       None
// Outputs:      pRes - phi result value (not used)
//               pLevel - error logging level
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.GetErrorLevel(var pRes: SYSINT; out pLevel: ErrorLevel);
begin
  pRes := 0;

  case m_ErrorLevel of
    errorWarning:  pLevel := eWarning;
    errorNormal:   pLevel := eNormal;
    errorCritical: pLevel := eCritical;
    errorOff:      pLevel := eNoError;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set error logging level for this object.
// Inputs:       level - error logging level
// Outputs:      pRes - phi result value (not used)
// Note:         exceptions raised:
//                   EOleSysError (E_FAIL) for unexpected error level
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.SetErrorLevel(var pRes: SYSINT; level: ErrorLevel);
begin
  pRes := 0;

  case level of
    eWarning:  m_ErrorLevel := errorWarning;
    eNormal:   m_ErrorLevel := errorNormal;
    eCritical: m_ErrorLevel := errorCritical;
    eNoError:  m_ErrorLevel := errorOff;
  else   // unknown level
    ErrorLog(errorWarning, E_FAIL, 'Unexpected error level');
    raise EOleSysError.Create('Unexpected error level in SetErrorLevel', E_FAIL, 0);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get trace logging level for this object.
// Inputs:       None
// Outputs:      pRes - phi result value (not used)
//               pLevel - trace logging level
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.GetTraceLevel(var pRes: SYSINT; out pLevel: TraceLevel);
begin
  pRes := 0;

  case m_TraceLevel of
    traceDebug:    pLevel := tDebug;
    traceService:  pLevel := tService;
    traceDiagnose: pLevel := tDiagnose;
    traceUser:     pLevel := tUser;
    traceOff:      pLevel := tNoTrace;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set trace logging level for this object.
// Inputs:       level - trace logging level
// Outputs:      pRes - phi result value (not used)
// Note:         exceptions raised:
//                   EOleSysError (E_FAIL) for unexpected trace level
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.SetTraceLevel(var pRes: SYSINT; level: TraceLevel);
begin
  pRes := 0;

  case level of
    tDebug:     m_TraceLevel := traceDebug;
    tService:   m_TraceLevel := traceService;
    tDiagnose:  m_TraceLevel := traceDiagnose;
    tUser:      m_TraceLevel := traceUser;
    tNoTrace:   m_TraceLevel := traceOff;
  else  // unknown level
    ErrorLog(errorWarning, E_FAIL, 'Unexpected trace level');
    raise EOleSysError.Create('Unexpected trace level in SetTraceLevel', E_FAIL, 0);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write error message to the system error log.
// Inputs:       Level - error level for this error message
//               Code - HResult for this error
//               bReported - True if this error has been reported to user; otherwise False  (not used)
//               PrevError - PHIResult from a previous error that led to this ErrorLog call  (not used)
//               strMsg - error message to log
// Return:       PHIResult - PHIResult for this error to be used in subsequent ErrorLog calls relating
//                to this error (not used)
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiObject.ErrorLog(Level: TErrorLevel; Code: HResult;
  bReported: boolean; PrevError: TPHIResult; strMsg: string): TPHIResult;
begin
  ErrorLog(Level, Code, strMsg);

  // PhiResult is not used anymore
  Result := 0;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write error message to the system error log.
// Inputs:       Level - error level for this error message
//               Code - HResult for this error
//               strMsg - error message to log
//               Args - formats the message in the same way as
//                 Format(strMsg,[]) see delphi help 'Format' for details.
// Return:       None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.ErrorLog(Level: TErrorLevel; Code: HResult; strMsg: string;
  Args: array of const);
begin
  ErrorLog(Level, Code, Format(strMsg, Args));
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write error message to the system error log.
// Inputs:       Level - error level for this error message
//               Code - HResult for this error
//               strMsg - error message to log
// Note:         Always log error regardless of level
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.ErrorLog(Level: TErrorLevel; Code: HResult; strMsg: string);
var
  ELevel: longint;
begin
  case Level of
    errorWarning:
      ELevel := eWarning;
    errorNormal:
      ELevel := eNormal;
    errorCritical:
      ELevel := eCritical;
    errorOff:
      ELevel := eNoError;
  else // unexpected level value
      ELevel := eNormal;
      strMsg := 'Unexpected error level. ' + strMsg;
  end;

  LogErrorMsg(m_strName, ELevel, Code, strMsg);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write trace message to system error log.
// Inputs:       Level - trace logging level
//               strMsg - message to write to trace log
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.TraceLog(Level: TTraceLevel; strMsg: string);
var
  TLevel : longint;
begin
  fpu := GetX87SW;
  if fpu and ($FF-$22) <> 0 then
  begin
    fpuBogus := 1;
    strMsg := strMsg + 'FLOATING POINT ERROR' + IntToHex(fpu,4) + chr($0A);
    ClearX87Exceptions;
  end;

  // based on the trace level of the object, decide whether to log a given message
  if (ord(Level) >= ord(m_TraceLevel)) or (fpuBogus = 1) then
  begin
    if (FbEnableLogging) then
    begin
      case Level of
        traceDebug:
          TLevel := tDebug;
        traceService:
          TLevel := tService;
        traceDiagnose:
          TLevel := tDiagnose;
        traceUser:
          TLevel := tUser;
        traceOff:
          TLevel := tNoTrace;
        else // unexpected level value
          TLevel := tDebug;
          strMsg := 'Unexpected error level. ' + strMsg;
        end;

      LogTraceMsg(m_strName, TLevel, strMsg);
    end;
  end;

  fpuBogus := 0;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Write trace message to system log.
// Inputs:      Level - trace logging level
//              strMsg - message to write to trace log
//              Args - formats the message in the same way as
//              Format(strMsg,[]) see delphi help 'Format' for details.
// Outputs: None
// Exceptions:
// Note:
//
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.TraceLog(Level: TTraceLevel; strMsg: string;
  Args: array of const);
begin
  TraceLog(Level, Format(strMsg, Args));
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write alarm message to system error log.
// Inputs:       strMsg - alarm message to write to log
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.AlarmLog(strMsg: String);
begin
  if (FbEnableLogging) then
  begin
    LogAlarmMsg(m_strName, strMsg);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Pop up a modal error/confirmation dialog and return which button
//                was pressed by user.
// Inputs:       DialogType - type of dialog
//               Buttons -- Buttons to display
//               strMsg - message to display in dialog
//               strCaption -- caption for the dialog; default to '', which means use default
//                caption according to dialog type.
// Outputs:      Which button user pressed to dismiss dialog
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiObject.MessageDialog(DialogType: TDialogType; Buttons: TDialogButtons;
                       strMsg: string): TDialogResult;
var
  Dialog: TForm;
begin
  Dialog := MessageDialogCreate(DialogType, Buttons, strMsg);
  Result := MessageDialogShow(Dialog);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Message Dialog Create
// Inputs:       DialogType - type of dialog
//               Buttons -- Buttons to display
//               strMsg - message to display in dialog
//               strCaption -- caption for the dialog; default to '', which means use default
//                caption according to dialog type.
// Outputs:      Dialog Object as TForm
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiObject.MessageDialogCreate(DialogType: TDialogType; Buttons: TDialogButtons;
                       strMsg: string): TForm;
var
   DlgType: TMsgDlgType;
   DlgButtons: TMsgDlgButtons;
   dialogForm: TForm;
begin
  case (DialogType) of
    infoDialog: DlgType := mtInformation;
    warningDialog: DlgType := mtWarning;
    errorDialog: DlgType := mtError;
    confirmDialog: DlgType := mtWarning;
    else
      DlgType:= mtCustom;
  end;

  case (Buttons) of
    ok: DlgButtons := [mbOK];
    cancel: DlgButtons := [mbCancel];
    okCancel: DlgButtons := [mbOK, mbCancel];
    yesNo: DlgButtons := [mbYes, mbNo];
    yesNoCancel: DlgButtons := [mbYes, mbNo, mbCancel];
    else
      DlgButtons:= [mbOK];
  end;

  // Create a message dialog. This allows us to display the class name in the title
  dialogForm := CreateMessageDialog(strMsg, DlgType, DlgButtons);

  // For error dialogs, append the time and date of the error to the title bar text.
  if DlgType = mtError then
  begin
    dialogForm.Caption := dialogForm.Caption + FormatDateTime(': d-mmm-yyyy @ h:nn:ss',  Now());
  end;

  Result := dialogForm;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Message Dialog Show
// Inputs:       Dialog - Dialog Object
// Outputs:      Which button user pressed to dismiss dialog
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiObject.MessageDialogShow(Dialog: TForm): TDialogResult;
var
  Response: longint;
begin
  try
    // chosen not to use default caption
    if (m_strName <> '') then
      Dialog.Caption := m_strName + ' ' + Dialog.Caption;

    // Beep to inticate that a dialog is now dispayed
    MessageBeep(PHIOBJ_BEEP);

    Response := Dialog.ShowModal;
    case (Response) of
      mrYes: Result := yesResult;
      mrNo: Result := noResult;
      mrOk: Result := okResult;
      mrCancel: Result := cancelResult;
    else
      Result := cancelResult;
    end;
  finally
    Dialog.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Message Dialog Close
// Inputs:       Dialog - Dialog Object
//               CloseResult - Modal Result used to close dialog
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.MessageDialogClose(Dialog: TForm; CloseResult: TDialogResult);
var
  DialogResult: Integer;
begin
  case (CloseResult) of
    yesResult: DialogResult := mrYes;
    noResult: DialogResult := mrNo;
    okResult: DialogResult := mrOk;
    cancelResult: DialogResult := mrCancel;
  else
    DialogResult := mrCancel;
  end;

  // chosen not to use default caption
  if (Dialog <> nil) then
    Dialog.ModalResult := DialogResult;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Pop up a 'Modal' error/confirmation dialog and return which button
//                was pressed by user.
// Inputs:       DialogType - type of dialog
//               Buttons -- Buttons to display
//               strMsg - message to display in dialog
// Outputs:      Which button user pressed to dismiss dialog
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiObject.ModalDialog(DialogType: TDialogType; Buttons: TDialogButtons; strMsg: string): TDialogResult;
begin
  Result := MessageDialog(DialogType, Buttons, strMsg);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Pop up a 'Modeless' error/confirmation dialog
// Inputs:       DialogType - type of dialog
//               strMsg - message to display in dialog
// Outputs:      the modeless dialog created
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiObject.ModelessDialog(DialogType: TDialogType; strMsg: string): TForm;
var
  DlgType: TMsgDlgType;
  Dialog: TForm;
  i: Integer;
begin
  case (DialogType) of
    infoDialog: DlgType := mtInformation;
    warningDialog: DlgType := mtWarning;
    errorDialog: DlgType := mtError;
    confirmDialog: DlgType := mtWarning;
    else
      DlgType:= mtCustom;
  end;

  // Create a message dialog. This allows us to display the class name in the title
  Dialog := CreateMessageDialog(strMsg, DlgType, [mbOK]);

  // chosen not to use default caption
  if (m_strName <> '') then
    Dialog.Caption := m_strName + ' ' + Dialog.Caption;

  // For error dialogs, append the time and date of the error to the title bar text.
  if DlgType = mtError then
  begin
    Dialog.Caption := Dialog.Caption + FormatDateTime(': d-mmm-yyyy @ h:nn:ss',  Now());
  end;

  // Set the 'OK' button event callback
  for i := 0 to Dialog.ComponentCount - 1 do
  begin
    if (Dialog.Components[i] is TButton) then
      (Dialog.Components[i] as TButton).OnClick := ModelessDialogOnOkClick;
  end;

  Dialog.OnClose := ModelessDialogOnClose;
  Dialog.FormStyle := fsStayOnTop;

  // Beep to inticate that a dialog is now dispayed
  MessageBeep(PHIOBJ_BEEP);

  Dialog.Show;

  Result := Dialog;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Pop up a 'Modeless' wait dialog.   Dialog title is 'Please wait...' and there is
//               no dialog button.
// Inputs:       strMsg - message to display in dialog
// Outputs:      the modeless dialog created
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TPhiObject.ModelessWaitDialog(strMsg: string): TForm;
var
  DlgType: TMsgDlgType;
  Dialog: TForm;
begin
  DlgType := mtInformation;

  // Create a message dialog with no button
  Dialog := CreateMessageDialog(strMsg, DlgType, []);

  // adjust dialog height as there won't be buttons
  Dialog.Height := Dialog.Height - 30;

  // chosen not to use default caption
  Dialog.Caption := 'Please wait...';

  Dialog.OnClose := ModelessDialogOnClose;
  Dialog.FormStyle := fsStayOnTop;

  // Beep to inticate that a dialog is now dispayed
  MessageBeep(PHIOBJ_BEEP);

  Dialog.Show;

  Result := Dialog;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  On OK button click handler for modeless dialog
// Inputs:       Sender as TButton
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.ModelessDialogOnOkClick(Sender: TObject);
begin
  // Close modeless dialog
  ((Sender as TButton).Parent as TForm).Close;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  On Close handler for modeless dialog
// Inputs:       Sender as TButton
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TPhiObject.ModelessDialogOnClose(Sender: TObject; var Action: TCloseAction);
begin
  // Destroy dialog and free all memory
  Action := caFree;
end;

Function GetX87SW: word; // Assembler;
ASM
  FStSW [Result]
End;

(* CW Mask bits prevent interrupt when true:
   (Pending interrupt flags in status word have matching positions.) )
    $0001 -- IM (Invalid op interrupt Mask)
    $0002 -- DM (Denormalized op interrupt Mask)
    $0004 -- ZM (Zero divide interrupt Mask)
    $0008 -- OM (Overflow interrupt Mask)
    $0010 -- UM (Underflow interrupt Mask)
    $0020 -- PM (Loss of precision interrupt Mask) }
{ CW Control bits change operation:
    $0300 -- PC (Precision Control mask)
    $0C00 -- RC (Rounding Control mask)
    $1000 -- IC (Infinity Control mask) *)

procedure ClearX87Exceptions;
{ clears pending FPU exceptions.}
asm
  FNCLEX
end;

end.

