unit ViewPhiWobbleProp;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ViewSemWobbleDlg.pas
// Created:   September, 2011 by John Baker
// Purpose:   This module contains the SEM Wobble view class.
//*********************************************************
// Copyright © 1998-2010 Physical Electronics-USA(a division of ULVAC-PHI).
// Created in 2010 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,
  ViewPhi, OleCtrls, RealEdit,
  Parameter,
  Menus;

type
  TPhiWobblePropView = class(TPhiView)
    WobbleGroupBox: TGroupBox;
    DataCaption: TLabel;
    DataEdit: TRealEdit;
    WobbleModeCaption: TLabel;
    AmplitudeCaption: TLabel;
    WobbleAutoCaption: TLabel;
    AmplitudeEdit: TRealEdit;
    Panel2: TPanel;
    WobbleOffRadio: TRadioButton;
    WobbleOnRadio: TRadioButton;
    WobbleAutoCheck: TCheckBox;
    Panel9: TPanel;
    CloseButton: TButton;
    PeriodCaption: TLabel;
    PeriodEdit: TRealEdit;
    OffsetCaption: TLabel;
    OffsetEdit: TRealEdit;
    NumberOfStepsCaption: TLabel;
    NumberOfStepsEdit: TRealEdit;

    WobblePopup: TPopupMenu;
    StartWobbleItem: TMenuItem;
    StopWobbleItem: TMenuItem;
    N3: TMenuItem;
    WobblePropertiesItem: TMenuItem;

    procedure WobbleOffRadioClick(Sender: TObject);
    procedure WobbleOnRadioClick(Sender: TObject);
    procedure WobbleAutoCheckClick(Sender: TObject);

    procedure DataEditChanged(Sender: TObject; CtrlValue: Double);
    procedure AmplitudeEditChanged(Sender: TObject; CtrlValue: Double);
    procedure PeriodEditChanged(Sender: TObject; CtrlValue: Double);
    procedure NumberOfStepsEditChanged(Sender: TObject; CtrlValue: Double);
    procedure OffsetEditChanged(Sender: TObject; CtrlValue: Double);

    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure StartWobbleItemClick(Sender: TObject);
    procedure StopWobbleItemClick(Sender: TObject);
    procedure WobblePropertiesItemClick(Sender: TObject);
    procedure WobblePopupPopup(Sender: TObject);
  private
    m_ParentPtr: TComponent;

    m_WobbleBasePtr: TObject;
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy(); override;

    procedure OnUpdateWobble(Hint: Integer);
  end;

var
  g_PhiWobblePropView: TPhiWobblePropView;

  implementation

{$R *.DFM}

uses
  AppDefinitions,
  ObjectPhi,
  ParameterWobbleBase,
  ParameterDataWobble,
  ParameterPolarityWobble,
  SysLogQueue,
  SYSLOGQUEUELib_TLB;

////////////////////////////////////////////////////////////////////////////////
// Description:  Constructor to create this object.
// Inputs:       AOwner - component that owns this object.  If NIL is specified
//                        as owner, creator is responsible for destroying this
//                        object.
// Outputs:      Object
// Note:
////////////////////////////////////////////////////////////////////////////////
constructor TPhiWobblePropView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  m_ParentPtr := AOwner;

  m_WobbleBasePtr := nil;
  if m_ParentPtr is TParameterDataWobble then
    m_WobbleBasePtr := TParameterDataWobble(m_ParentPtr).Wobble
  else if m_ParentPtr is TParameterPolarityWobble then
    m_WobbleBasePtr := TParameterPolarityWobble(m_ParentPtr).Wobble;

  TraceLog(traceOff, 'Create()');
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Destructor to destroy this object.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
destructor TPhiWobblePropView.Destroy();
begin
  TraceLog(traceOff, 'Destroy()');

  try
    inherited Destroy();
  except
    on E: Exception do
      LogErrorMsg(ClassName, eNormal, E_FAIL, 'Exception in Destroy. ' + E.Message);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Show form event handler
// Inputs:       Sender - Form
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiWobblePropView.FormShow(Sender: TObject);
begin
  TraceLog(traceDebug, 'FormShow()');

  try
    OnUpdateChange := True;
    OnUpdateWobble(ord(wobbleOnUpdateAll));
  finally
    OnUpdateChange := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Hide form event handler
// Inputs:       Sender - Form
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiWobblePropView.FormHide(Sender: TObject);
begin
  TraceLog(traceDebug, 'FormHide()');

  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Update from 'SEM'
// Inputs:       Hint - Enumerated type defined in the derived document class
//                      to specify what needs to be updated.
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiWobblePropView.OnUpdateWobble(Hint: Integer);
var
  sourceType: String;
  parameterWobblePtr: TParameterWobbleBase;
begin
  TraceLog(traceDebug, 'OnUpdateWobble()');

  if (Hint = Ord(wobbleOnUpdateShowProperties)) then
  begin
    ShowDialog();
  end;

  if not Visible then
    Exit;

  parameterWobblePtr := TParameterWobbleBase(m_WobbleBasePtr);

  if (Hint = Ord(wobbleOnUpdateAll)) or
     (Hint = Ord(wobbleOnUpdateWobble)) then
  begin
    if parameterWobblePtr.Source = wobbleSource_Firmware then
      sourceType := ' - Firmware'
    else
      sourceType := '';

    // TParameterDataWobble/TParameterPolarityWobble
    if m_ParentPtr is TParameterDataWobble then
    begin
      Caption := TParameterDataWobble(m_ParentPtr).Caption + sourceType;

      TParameterDataWobble(m_ParentPtr).ToCaption(DataCaption);
      TParameterDataWobble(m_ParentPtr).ToRealEdit(DataEdit, False);
    end
    else if m_ParentPtr is TParameterPolarityWobble then
    begin
      Caption := TParameterPolarityWobble(m_ParentPtr).Caption + sourceType;

      TParameterPolarityWobble(m_ParentPtr).ToCaption(DataCaption);
      TParameterPolarityWobble(m_ParentPtr).ToRealEdit(DataEdit, False);
    end;

    if not parameterWobblePtr.WobbleStatus.Value then
      DataEdit.ReadOnly := True;

    parameterWobblePtr.WobbleStatus.ToCaption(WobbleModeCaption);
    parameterWobblePtr.WobbleStatus.ToRadioButton(WobbleOnRadio, c_WobbleOn);
    parameterWobblePtr.WobbleStatus.ToRadioButton(WobbleOffRadio, c_WobbleOff);
  end;

  if (Hint = Ord(wobbleOnUpdateAll)) then
  begin
    parameterWobblePtr.WobbleAuto.ToCaption(WobbleAutoCaption);
    parameterWobblePtr.WobbleAuto.ToCheckBox(WobbleAutoCheck);

    parameterWobblePtr.Amplitude.ToCaption(AmplitudeCaption);
    parameterWobblePtr.Amplitude.ToRealEdit(AmplitudeEdit);

    parameterWobblePtr.NumberOfSteps.ToCaption(NumberOfStepsCaption);
    parameterWobblePtr.NumberOfSteps.ToRealEdit(NumberOfStepsEdit);

    parameterWobblePtr.PeriodInMs.ToCaption(PeriodCaption);
    parameterWobblePtr.PeriodInMs.ToRealEdit(PeriodEdit);

    parameterWobblePtr.Offset.ToCaption(OffsetCaption);
    parameterWobblePtr.Offset.ToRealEdit(OffsetEdit);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Focus Rocking Mode to "On".
// Inputs:       Sender - Radio Button
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiWobblePropView.WobbleOnRadioClick(Sender: TObject);
begin
  // Check if change is being forced by an OnUpdate() call
  if (OnUpdateChange) then
    Exit;

  if m_ParentPtr is TParameterDataWobble then
    TParameterDataWobble(m_ParentPtr).StartWobble(Sender)
  else if m_ParentPtr is TParameterPolarityWobble then
    TParameterPolarityWobble(m_ParentPtr).StartWobble(Sender);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Focus Rocking Mode to "Off".
// Inputs:       Sender - Radio Button
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiWobblePropView.WobbleOffRadioClick(Sender: TObject);
begin
  // Check if change is being forced by an OnUpdate() call
  if (OnUpdateChange) then
    Exit;

  if m_ParentPtr is TParameterDataWobble then
    TParameterDataWobble(m_ParentPtr).StopWobble(Sender)
  else if m_ParentPtr is TParameterPolarityWobble then
    TParameterPolarityWobble(m_ParentPtr).StopWobble(Sender);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set Focus Steering 'Auto' Rocking Mode
// Inputs:       Sender - CheckBox
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiWobblePropView.WobbleAutoCheckClick(Sender: TObject);
begin
  // Check if change is being forced by an OnUpdate() call
  if (OnUpdateChange) then
    Exit;

  TParameterWobbleBase(m_WobbleBasePtr).WobbleAuto.Value := WobbleAutoCheck.Checked;
end;

procedure TPhiWobblePropView.DataEditChanged(Sender: TObject; CtrlValue: Double);
begin
  if (OnUpdateChange) then
    Exit;

  // Do nothing but update the UI w/previous data value
  OnUpdateWobble(ord(wobbleOnUpdateAll));
end;

procedure TPhiWobblePropView.AmplitudeEditChanged(Sender: TObject; CtrlValue: Double);
begin
  if (OnUpdateChange) then
    Exit;

  TParameterWobbleBase(m_WobbleBasePtr).Amplitude.Value := CtrlValue;
end;

procedure TPhiWobblePropView.PeriodEditChanged(Sender: TObject;
  CtrlValue: Double);
begin
  if (OnUpdateChange) then
    Exit;

  TParameterWobbleBase(m_WobbleBasePtr).PeriodInMs.Value := CtrlValue;
end;

procedure TPhiWobblePropView.NumberOfStepsEditChanged(Sender: TObject; CtrlValue: Double);
begin
  if (OnUpdateChange) then
    Exit;

  TParameterWobbleBase(m_WobbleBasePtr).NumberOfSteps.Value := CtrlValue;
end;

procedure TPhiWobblePropView.OffsetEditChanged(Sender: TObject;
  CtrlValue: Double);
begin
  if (OnUpdateChange) then
    Exit;

  TParameterWobbleBase(m_WobbleBasePtr).Offset.Value := CtrlValue;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Callback for 'Close' button.
// Inputs:       Button
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiWobblePropView.CloseButtonClick(Sender: TObject);
begin
  // Check if change is being forced by an OnUpdate() call
  if (OnUpdateChange) then
    Exit;

  Self.Hide;
end;

////////////////////////////////////////////////////////////////////////////////
// Wobble popup menu
////////////////////////////////////////////////////////////////////////////////
procedure TPhiWobblePropView.StartWobbleItemClick(Sender: TObject);
begin
  if m_ParentPtr is TParameterDataWobble then
    TParameterDataWobble(m_ParentPtr).StartWobble(Sender)
  else if m_ParentPtr is TParameterPolarityWobble then
    TParameterPolarityWobble(m_ParentPtr).StartWobble(Sender);
end;

procedure TPhiWobblePropView.StopWobbleItemClick(Sender: TObject);
begin
  if m_ParentPtr is TParameterDataWobble then
    TParameterDataWobble(m_ParentPtr).StopWobble(Sender)
  else if m_ParentPtr is TParameterPolarityWobble then
    TParameterPolarityWobble(m_ParentPtr).StopWobble(Sender);
end;

procedure TPhiWobblePropView.WobblePropertiesItemClick(Sender: TObject);
begin
  ShowDialog();
end;

procedure TPhiWobblePropView.WobblePopupPopup(Sender: TObject);
begin
  if TParameterWobbleBase(m_WobbleBasePtr).WobbleStatus.Value then
  begin
    StartWobbleItem.Checked := True;
    StopWobbleItem.Checked := False;
  end
  else
  begin
    StartWobbleItem.Checked := False;
    StopWobbleItem.Checked := True;
  end;
end;

end.

