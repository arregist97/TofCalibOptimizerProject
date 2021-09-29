unit ViewPhiTuneProp;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ViewPhiTuneProp.pas
// Created:   10/17/2018 by Melinda Caouette
// Purpose:   This module contains the Tune view class.
//*********************************************************
// Copyright © 2018 Physical Electronics-USA(a division of ULVAC-PHI).
// Created in 2018 as an unpublished copyrighted work.  This program
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
  Menus, Vcl.Buttons;

type
  TPhiTunePropView = class(TPhiView)
    TuneGroupBox: TGroupBox;
    DataCaption: TLabel;
    DataEdit: TRealEdit;
    RangeCaption: TLabel;
    RangeEdit: TRealEdit;
    Panel9: TPanel;
    CloseButton: TButton;
    ReadingFrequencyCaption: TLabel;
    ReadingFrequencyEdit: TRealEdit;
    StepSizeCaption: TLabel;
    StepSizeEdit: TRealEdit;
    TunePopup: TPopupMenu;
    StartTuningItem: TMenuItem;
    StopTuningItem: TMenuItem;
    N3: TMenuItem;
    TunePropertiesItem: TMenuItem;
    TuneButton: TSpeedButton;
    Panel1: TPanel;
    PlotButton: TSpeedButton;
    PeakMethodCombo: TComboBox;
    PeakMethodCaption: TLabel;
    AmmeterRangeCaption: TLabel;
    Panel2: TPanel;
    AmmeterRangeCombo: TComboBox;

    procedure RangeEditChanged(Sender: TObject; CtrlValue: Double);
    procedure StepSizeEditChanged(Sender: TObject; CtrlValue: Double);
    procedure ReadingFrequencyEditChanged(Sender: TObject; CtrlValue: Double);

    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure StartTuningItemClick(Sender: TObject);
    procedure StopTuningItemClick(Sender: TObject);
    procedure TunePropertiesItemClick(Sender: TObject);
    procedure TunePopupPopup(Sender: TObject);
    procedure TuneButtonClick(Sender: TObject);
    procedure PlotButtonClick(Sender: TObject);
    procedure PeakMethodComboChange(Sender: TObject);
    procedure AmmeterRangeComboChange(Sender: TObject);

  private
    m_ParentPtr: TComponent;        // point to the corresponding TParameterTune object

  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy(); override;

    procedure OnUpdate(Hint: Integer); override;
    procedure OnUpdateTune(Hint: Integer);
  end;

var
  g_PhiTunePropView: TPhiTunePropView;

  implementation

{$R *.DFM}

uses
  AppDefinitions,
  ObjectPhi,
  ParameterTune,
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
constructor TPhiTunePropView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  m_ParentPtr := AOwner;

  TraceLog(traceOff, 'Create()');
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Destructor to destroy this object.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
destructor TPhiTunePropView.Destroy();
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
procedure TPhiTunePropView.FormShow(Sender: TObject);
begin
  TraceLog(traceDebug, 'FormShow()');

  try
    OnUpdateChange := True;
    OnUpdateTune(ord(tuneOnUpdateAll));
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
procedure TPhiTunePropView.FormHide(Sender: TObject);
begin
  TraceLog(traceDebug, 'FormHide()');

  if assigned(m_ParentPtr) then
    TParameterTune(m_ParentPtr).AbortTune(nil);

  inherited;
end;
////////////////////////////////////////////////////////////////////////////////
// Description: Override of PHIView base class OnUpdate(hint) method.  Once this
//                object is registered with a document derived from PHIDoc, the
//                document calls this method to update this view.
// Inputs:      Hint - Enumerated type defined in the derived document class
//                to specify what needs to be updated.
// Outputs:     None.
// Note:        Only processed when application is visible
////////////////////////////////////////////////////////////////////////////////
procedure TPhiTunePropView.OnUpdate(Hint: Integer);
begin
  OnUpdateTune(Hint);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Update from 'Tune'
// Inputs:       Hint - Enumerated type defined in the derived document class
//                      to specify what needs to be updated.
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiTunePropView.OnUpdateTune(Hint: Integer);
var
  parameterTunePtr: TParameterTune;
begin
  TraceLog(traceDebug, 'OnUpdateTune()');

  if (Hint = Ord(tuneOnUpdateShowProperties)) then
  begin
    if assigned(m_ParentPtr) then
      TParameterTune(m_ParentPtr).UpdateTuneParameters;

    ShowDialog();
  end;

  if not Visible then
    Exit;

  parameterTunePtr :=  m_ParentPtr as TParameterTune;

  if (Hint = Ord(tuneOnUpdateAll)) or
     (Hint = Ord(tuneOnUpdateTuneData)) then
  begin
    Caption := parameterTunePtr.Caption;

    parameterTunePtr.ToCaption(DataCaption);
    parameterTunePtr.ToRealEdit(DataEdit, False);

    if not parameterTunePtr.TuneStatus.Value then
      DataEdit.ReadOnly := True;
  end;

  if (Hint = Ord(tuneOnUpdateAll)) or
     (Hint = Ord(tuneOnUpdateStatus)) then
  begin
    TuneButton.Down := parameterTunePtr.TuneStatus.Value;
  end;

  if (Hint = Ord(tuneOnUpdateAll)) then
  begin
    parameterTunePtr.TuneDelayInMs.ToCaption(ReadingFrequencyCaption);
    parameterTunePtr.TuneDelayInMs.ToRealEdit(ReadingFrequencyEdit);

    parameterTunePtr.TuneRange.ToCaption(RangeCaption);
    parameterTunePtr.TuneRange.ToRealEdit(RangeEdit);

    parameterTunePtr.TuneStepSize.ToCaption(StepSizeCaption);
    parameterTunePtr.TuneStepSize.ToRealEdit(StepSizeEdit);

    parameterTunePtr.TunePeakMethod.ToCaption(PeakMethodCaption);
    parameterTunePtr.TunePeakMethod.ToComboBox(PeakMethodCombo);

    parameterTunePtr.AmmeterRange.ToCaption(AmmeterRangeCaption);
    parameterTunePtr.AmmeterRange.ToComboBox(AmmeterRangeCombo);
  end;
end;

procedure TPhiTunePropView.TuneButtonClick(Sender: TObject);
begin
  if (OnUpdateChange) then
    Exit;

  if assigned(m_ParentPtr) then
  begin
    if TuneButton.Down then
      TParameterTune(m_ParentPtr).StartTune(Sender)
    else
      TParameterTune(m_ParentPtr).StopTune(Sender);
  end;
end;

procedure TPhiTunePropView.PlotButtonClick(Sender: TObject);
var
  parameterTune: TParameterTune;
begin
  if (OnUpdateChange) then
    Exit;

  if (assigned(m_ParentPtr)) then
  begin
    parameterTune := TParameterTune(m_ParentPtr);
    if (assigned(parameterTune.OnUpdateAllViews)) then
      parameterTune.OnUpdateAllViews(parameterTune.OnUpdateHintShowChartDialog);
  end;
end;


procedure TPhiTunePropView.RangeEditChanged(Sender: TObject; CtrlValue: Double);
begin
  if (OnUpdateChange) then
    Exit;

  TParameterTune(m_ParentPtr).TuneRange.Value := CtrlValue;
end;

procedure TPhiTunePropView.StepSizeEditChanged(Sender: TObject; CtrlValue: Double);
begin
  if (OnUpdateChange) then
    Exit;

  TParameterTune(m_ParentPtr).TuneStepSize.Value := CtrlValue;
end;

procedure TPhiTunePropView.ReadingFrequencyEditChanged(Sender: TObject;
  CtrlValue: Double);
begin
  if (OnUpdateChange) then
    Exit;

  TParameterTune(m_ParentPtr).TuneDelayInMs.Value := CtrlValue;
end;

procedure TPhiTunePropView.PeakMethodComboChange(Sender: TObject);
begin
  if (OnUpdateChange) then
    Exit;

  TParameterTune(m_ParentPtr).TunePeakMethod.Value := PeakMethodCombo.Text;
end;

procedure TPhiTunePropView.AmmeterRangeComboChange(Sender: TObject);
begin
  if (OnUpdateChange) then
    Exit;

  // don't allow selection of divider
  if (TComboBox(Sender).Text <> c_TuneAmmeterRange_FixedRangeDivider) then
  begin
    TParameterTune(m_ParentPtr).AmmeterRange.Value := AmmeterRangeCombo.Text;
  end
  else
  begin
    // force an update to show the previously selected picoammeter range
    OnUpdateTune(Ord(tuneOnUpdateAll));
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Callback for 'Close' button.
// Inputs:       Button
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TPhiTunePropView.CloseButtonClick(Sender: TObject);
begin
  // Check if change is being forced by an OnUpdate() call
  if (OnUpdateChange) then
    Exit;

  Self.Hide;
end;

////////////////////////////////////////////////////////////////////////////////
// Tune popup menu
////////////////////////////////////////////////////////////////////////////////
procedure TPhiTunePropView.StartTuningItemClick(Sender: TObject);
begin
  if assigned(m_ParentPtr) then
  begin
    TParameterTune(m_ParentPtr).StartTune(Sender);
  end;
end;

procedure TPhiTunePropView.StopTuningItemClick(Sender: TObject);
begin
  if assigned(m_ParentPtr) then
    TParameterTune(m_ParentPtr).StopTune(Sender);
end;

procedure TPhiTunePropView.TunePropertiesItemClick(Sender: TObject);
begin
  if assigned(m_ParentPtr) then
    TParameterTune(m_ParentPtr).UpdateTuneParameters;

  ShowDialog();
end;

procedure TPhiTunePropView.TunePopupPopup(Sender: TObject);
begin
  if TParameterTune(m_ParentPtr).TuneStatus.Value then
  begin
    StartTuningItem.Checked := True;
    StopTuningItem.Checked := False;
  end
  else
  begin
    StartTuningItem.Checked := False;
    StopTuningItem.Checked := True;
  end;
end;

end.

