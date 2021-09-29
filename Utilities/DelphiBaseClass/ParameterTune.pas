unit ParameterTune;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterTune.pas
// Created:   10/17/2018 by Melinda Caouette
// Purpose:   This module defines the ParameterTune base class.
//             classes are derived.
//*********************************************************
// Copyright © 2018 Physical Electronics, Inc.
// Created in 2018 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////
interface

uses
  Classes,
  StdCtrls,
  IniFiles,
  Controls,
  Graphics,
  Menus,
  Extctrls,
  //VCLTee.Chart,
  Parameter,
  ParameterBoolean,
  ParameterSelectData,
  ParameterContainer,
  ParameterPolarity,
  ParameterData,
  AppSettings_TLB,
  RealEdit,
  ViewPhiTuneProp;

const
  c_TuneOn = 'On';
  c_TuneOff = 'Off';

  c_TunePeakMethodFWHM = 'FWHM';
  c_TunePeakMethodMaximum = 'Maximum Intensity';

  c_TuneAmmeterRange_FixedRangeDivider =  '--- fixed range ---';

type
  TNotifySetEvent = procedure(Value: Double) of object;

  // List of view updates triggered using OnUpdate callback
  TTuneOnUpdate = (tuneOnUpdateAll,
                   tuneOnUpdateStatus,
                   tuneOnUpdateTuneData,
                   tuneOnUpdateShowProperties);

  TTunePeakMethod = (tunePeakMethodMax, tunePeakMethodFWHM);

  TParameterTune = class(TParameterContainer)
  private
    m_TuneData: TParameterData;            // tune data as we are stepping it to tune
    m_TuneRange: TParameterData;
    m_TuneStepSize: TParameterData;
    m_TuneDelayInMs: TParameterData;
    m_TuneStatus: TParameterBoolean;       // is tune in process?
    m_TunePeakMethod: TParameterSelectData; // how to locate the peak? which algorithm to use
    m_AmmeterRange: TParameterSelectData;

    m_TuneView: TPhiTunePropView;

    m_OnTuneStart: TNotifyEvent;           // callback to start tuning
    m_OnTuneStop: TNotifyEvent;            // callback to stop tuning
    m_OnTuneAbort: TNotifyEvent;           // callback to abort tuning
    m_OnSetHardware: TNotifySetEvent;      // callback to set hardware
    m_OnUpdateAllViews: TUpdateAllViews;
    m_OnUpdateHintShowChartDialog: Integer;  // hint for showing chart dialog

  private
    m_ParentPtr: TParameter;               // the parent object that contains this tune parameter object

    m_TuneSupplyID: Integer;               // ID the supply to tune (for now, no device/gun info)
    m_DataIntensityCaption: String;
    m_StartTuneValue: Double;              // supply setpoint before tuning; for restore

    m_TuneDataSetpoints: Array of Double;
    m_TuneDataIntensities: Array of Double;
    m_TuneDataIndex: Integer;

    m_MinValue: Double;
    m_MaxValue: Double;
    m_MaxValueIndex: Integer;

    m_FWHMPeakIndex: Integer;              // correspoinding peak index for FWHM
    m_FWHMPeakIntensity: Double;           // FWHM peak intensity

    m_PlotActive: Boolean;
    m_PlotVisible: Boolean;
    m_PlotColor: TColor;
    m_PlotScaleFactor: Double;
    m_PlotReferenceScaleFactor: Double;

    m_LineWidth: Integer;
    m_LineMarkerStyle: Integer;
    m_LastCountsVisible: Boolean;

    m_IsDirty: Boolean;
    m_IsDirtyData: Boolean;

    procedure SetPlotActive(Value: Boolean);
    procedure SetPlotVisible(Value: Boolean);
    procedure SetPlotColor(Value: TColor);
    procedure SetPlotScaleFactor(Value: Double);
    procedure SetPlotReferenceScaleFactor(Value: Double);
    procedure SetLineWidth(Value: Integer);
    procedure SetLineMarkerStyle(Value: Integer);
    procedure SetLastCountsVisible(Value: Boolean);

    function GetPlotMaxValue: Double;
    function GetPlotMinValue: Double;
    function GetMinimumValue: Double;
    function GetMaximumValue: Double;

    function GetParentValue: Double;
    function GetXWithMaxValue: Double;
    function GetXWithFWHMPeakValue: Double;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy() ; override ;
    procedure Initialize(Sender: TParameter); override ;

    procedure SetParent(const AParent: TParameter);

    procedure InitData();
    procedure ClearData();
    procedure RefreshData();

    procedure UpdateTuneParameters();
    procedure StartTune(Sender: TObject);
    procedure StopTune(Sender: TObject);
    procedure AbortTune(Sender: TObject);
    procedure SetHardware(Value: Double);

    procedure SetNewTuneData(Setpoint: Double; Intensity: Double);

    property OnTuneStart: TNotifyEvent read m_OnTuneStart write m_OnTuneStart;
    property OnTuneStop:  TNotifyEvent read m_OnTuneStop write m_OnTuneStop;
    property OnTuneAbort: TNotifyEvent read m_OnTuneAbort write m_OnTuneAbort;
    property OnSetHardware: TNotifySetEvent read m_OnSetHardware write m_OnSetHardware;
    property OnUpdateAllViews: TUpdateAllViews read m_OnUpdateAllViews write m_OnUpdateAllViews;
    property OnUpdateHintShowChartDialog: Integer read m_OnUpdateHintShowChartDialog write m_OnUpdateHintShowChartDialog;

    procedure ToRealEdit(RealEditPtr: TRealEdit; UpdateTuneView: Boolean = True); overload;
    //procedure ToChart(Chart: TChart; UpdateVisual: Boolean = True; CurveIndex: Integer = 1; VisualIndex: Integer = 0);

    procedure SetTuneStatus(InProcess: Boolean);
    procedure SetTuneValue(Setpoint: Double);
    procedure SetTunePeakMethod(PeakMethod: String);
    procedure SetAmmeterRange(AmmeterRange: String);

    property Parent: TParameter read m_ParentPtr write SetParent;

    property TuneData: TParameterData read m_TuneData;
    property TuneDelayInMs: TParameterData read m_TuneDelayInMs;
    property TuneRange: TParameterData read m_TuneRange;
    property TuneStepSize: TParameterData read m_TuneStepSize;
    property TuneStatus: TParameterBoolean read m_TuneStatus;
    property TunePeakMethod: TParameterSelectData read m_TunePeakMethod;
    property AmmeterRange: TParameterSelectData read m_AmmeterRange;

    property StartTuneValue: Double read m_StartTuneValue;
    property XWithMaxValue: Double read GetXWithMaxValue;
    property XWithFWHMPeakValue: Double read GetXWithFWHMPeakValue;
    property FWHMPeakIntensity: Double read m_FWHMPeakIntensity;

    property TuneSupplyID: Integer read m_TuneSupplyID write m_TuneSupplyID;
    property DataIntensityCaption: String read m_DataIntensityCaption write m_DataIntensityCaption;
    property PlotActive: Boolean read m_PlotActive write SetPlotActive;
    property PlotVisible: Boolean read m_PlotVisible write SetPlotVisible;
    property PlotColor: TColor read m_PlotColor write SetPlotColor;
    property PlotScaleFactor: Double read m_PlotScaleFactor write SetPlotScaleFactor;
    property PlotReferenceScaleFactor: Double read m_PlotReferenceScaleFactor write SetPlotReferenceScaleFactor;

    property LineWidth: Integer read m_LineWidth write SetLineWidth;
    property LineMarkerStyle: Integer read m_LineMarkerStyle write SetLineMarkerStyle;
    property LastCountsVisible: Boolean read m_LastCountsVisible write SetLastCountsVisible;

    property PlotMinValue: Double read GetPlotMinValue;
    property PlotMaxValue: Double read GetPlotMaxValue;

    property TuneMinimum: Double read GetMinimumValue;
    property TuneMaximum: Double read GetMaximumValue;

    procedure ToTunePopupMenu(RealEditPtr: TRealEdit); overload;
    procedure ToTunePopupMenu(LabelPtr: TLabel); overload;

    procedure DisplayTuneProperties(Sender: TObject);

    function FindFWHM(): Single;
  end ;

implementation

uses
  System.Math,
  System.Contnrs,
  System.SysUtils,

  Variants,
  Dialogs,

  //VCLTee.Series,
  //VCLTee.TeEngine,

  PhiMath;

const
  c_DefaultArraySize = 50;
  c_OnUpdateAll = 0;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterTune.Create(AOwner: TComponent) ;
begin
  inherited;

  m_TuneSupplyID := -1;
  m_DataIntensityCaption := '';

  SetLength(m_TuneDataSetpoints, 0);
  SetLength(m_TuneDataIntensities, 0);
  m_TuneDataIndex := -1;
  m_StartTuneValue := 0.0;

  m_MinValue := 0.0;
  m_MaxValue := 0.0;
  m_MaxValueIndex := 0;
  m_FWHMPeakIndex := 0;

  m_TuneView := nil;

  m_PlotActive := True;
  m_PlotVisible := True;
  m_PlotColor := clBlack;
  m_PlotScaleFactor := 1.0;
  m_PlotReferenceScaleFactor := 1.0;

  m_LineWidth := 1;
  m_LineMarkerStyle := ord(0);//psNothing);
  m_LastCountsVisible := False;
  m_IsDirty := True;
  m_IsDirtyData := True;

  m_TuneRange := TParameterData.Create(Self);
  m_TuneRange.Name:= 'Range';
  m_TuneRange.Caption:= 'Range';
  m_TuneRange.Hint:= 'Range';
  m_TuneRange.Min := 0.1;
  m_TuneRange.Max := 10000.0;
  m_TuneRange.SmallIncrement:= 0.1;
  m_TuneRange.LargeIncrement:= 1.0;
  m_TuneRange.Value := 0.0;
  Container.Add(m_TuneRange);

  m_TuneStepSize := TParameterData.Create(Self);
  m_TuneStepSize.Name:= 'Step Size';
  m_TuneStepSize.Caption:= 'Step Size';
  m_TuneStepSize.Hint:= 'Step Size';
  m_TuneStepSize.Precision := 1;
  m_TuneStepSize.Min := 0.1;
  m_TuneStepSize.Max := 0.9;
  m_TuneStepSize.SmallIncrement:= 0.1;
  m_TuneStepSize.LargeIncrement:= 0.1;
  m_TuneStepSize.Value := 0.1;
  Container.Add(m_TuneStepSize);

  m_TuneDelayInMs := TParameterData.Create(Self);
  m_TuneDelayInMs.Name:= 'Reading Frequency (ms)';
  m_TuneDelayInMs.Caption:= 'Reading Frequency (ms)';
  m_TuneDelayInMs.Hint:= 'Tuning delay time between each ammeter read';
  m_TuneDelayInMs.Min := 1;
  m_TuneDelayInMs.Max := 100000;
  m_TuneDelayInMs.SmallIncrement:= 100.0;
  m_TuneDelayInMs.LargeIncrement:= 500.0;
  m_TuneDelayInMs.Value := 1000;
  m_TuneDelayInMs.Precision := 0;
  Container.Add(m_TuneDelayInMs);

  m_TuneData := TParameterData.Create(Self);
  m_TuneData.Name:= 'Tune Data';
  Container.Add(m_TuneData);

  m_TuneStatus := TParameterBoolean.Create(Self);
  m_TuneStatus.Name:= 'Tune Status';
  m_TuneStatus.Caption:= 'Status';
  m_TuneStatus.Hint:= 'Status';
  m_TuneStatus.AddTrue(c_TuneOn);
  m_TuneStatus.AddFalse(c_TuneOff);
  Container.Add(m_TuneStatus);

  m_TunePeakMethod := TParameterSelectData.Create(Self);
  m_TunePeakMethod.Name := 'Peak Method';
  m_TunePeakMethod.Caption := 'Peak Method';
  m_TunePeakMethod.Hint := 'The method used to locate the peak';
  m_TunePeakMethod.AddValue(c_TunePeakMethodFWHM, ord(tunePeakMethodFWHM));
  m_TunePeakMethod.AddValue(c_TunePeakMethodMaximum, ord(tunePeakMethodMax));
  m_TunePeakMethod.Value := c_TunePeakMethodFWHM;
  Container.Add(m_TunePeakMethod);

  m_AmmeterRange := TParameterSelectData.Create(Self);
  m_AmmeterRange.Name := 'Picoammeter Range';
  m_AmmeterRange.Caption := 'Picoammeter Range';
  m_AmmeterRange.Hint := 'Picoammeter Range';
  // Doc is responsible for filling in the desirable ranges
  Container.Add(m_AmmeterRange);

  // callbacks
  m_OnTuneStart := nil;
  m_OnTuneStop := nil;
  m_OnTuneAbort := nil;
  m_OnSetHardware := nil;
  m_OnUpdateAllViews := nil;
  m_OnUpdateHintShowChartDialog := c_OnUpdateAll;

end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TParameterTune.Destroy() ;
begin
  // clear memory
  SetLength(m_TuneDataSetpoints, 0);
  SetLength(m_TuneDataIntensities, 0);

  inherited Destroy ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Initialize member variables using parent parameter
// Inputs:       Sender - this is the parent
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterTune.Initialize(Sender: TParameter) ;
begin
  inherited ;

  Name := Sender.Name + ': Tune';
end;

function TParameterTune.GetParentValue: Double;
var
  dValue: Double;
begin
  dValue := 0.0;

  if (m_ParentPtr is TParameterData) then
     dValue := TParameterData(m_ParentPtr).Value
  else if (m_ParentPtr is TParameterPolarity) then
     dValue := TParameterPolarity(m_ParentPtr).Value;

  Result := dValue;
end;

function TParameterTune.GetXWithMaxValue: Double;
var
  dValue: Double;
begin
  dValue := 0;

  if (Length(m_TuneDataSetpoints) > m_MaxValueIndex) then
    dValue := m_TuneDataSetpoints[m_MaxValueIndex];

  Result := dValue;
end;

function TParameterTune.GetXWithFWHMPeakValue: Double;
var
  dValue: Double;
begin
  dValue := 0;

  if (Length(m_TuneDataSetpoints) > m_FWHMPeakIndex) then
    dValue := m_TuneDataSetpoints[m_FWHMPeakIndex];

  Result := dValue;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set parent for the tune parameter
// Inputs:       Parent - the parameter object that contains this tune parameter
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterTune.UpdateTuneParameters();
var
  parentParameterData: TParameterData;
  parentParameterPolarity: TParameterPolarity;
begin
  m_TuneData.Value := GetParentValue;
  m_StartTuneValue := m_TuneData.Value;

  // some parameters' min and max change on the fly
  if (m_ParentPtr is TParameterData) then
  begin
    parentParameterData := TParameterData(m_ParentPtr);

    m_TuneData.Min := parentParameterData.Min;
    m_TuneData.Max := parentParameterData.Max;

    m_TuneRange.Max := parentParameterData.Max - parentParameterData.Min;
  end
  else if (m_ParentPtr is TParameterPolarity) then
  begin
    parentParameterPolarity := TParameterPolarity(m_ParentPtr);

    m_TuneData.Min := parentParameterPolarity.Min;
    m_TuneData.Max := parentParameterPolarity.Max;

    m_TuneRange.Max := parentParameterPolarity.Max - parentParameterPolarity.Min;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Set parent for the tune parameter
// Inputs:       Parent - the parameter object that contains this tune parameter
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterTune.SetParent(const AParent: TParameter);
var
  parentParameterData: TParameterData;
  parentParameterPolarity: TParameterPolarity;
begin
  m_ParentPtr := AParent;

  if (AParent is TParameterData) then
  begin
    parentParameterData := TParameterData(m_ParentPtr);

    m_TuneData.Precision := m_ParentPtr.Precision;

    m_TuneData.Min := parentParameterData.Min;
    m_TuneData.Max := parentParameterData.Max;

    m_TuneRange.Max := parentParameterData.Max - parentParameterData.Min;

    m_TuneStepSize.Precision := parentParameterData.Precision;
    if (m_TuneStepSize.Precision = 0) then
      m_TuneStepSize.Min := 1.0
    else
      m_TuneStepSize.Min := power(10.0, m_TuneStepSize.Precision * -1.0);
    m_TuneStepSize.Max := parentParameterData.Max;
    m_TuneStepSize.Value := parentParameterData.Increment;
  end
  else if (AParent is TParameterPolarity) then
  begin
    parentParameterPolarity := TParameterPolarity(m_ParentPtr);

    m_TuneData.Precision := parentParameterPolarity.Precision;

    m_TuneData.Min := parentParameterPolarity.Min;
    m_TuneData.Max := parentParameterPolarity.Max;

    m_TuneRange.Max := parentParameterPolarity.Max - parentParameterPolarity.Min;

    m_TuneStepSize.Precision := parentParameterPolarity.Precision;
    if (m_TuneStepSize.Precision = 0) then
      m_TuneStepSize.Min := 1.0
    else
      m_TuneStepSize.Min := power(10.0, m_TuneStepSize.Precision * -1.0);
    m_TuneStepSize.Max := parentParameterPolarity.Max;
    m_TuneStepSize.Value := parentParameterPolarity.Increment;
  end;

  // default range to good value
  m_TuneRange.Precision := m_ParentPtr.Precision;
  if (m_TuneRange.Value < abs(m_TuneStepSize.Value)) then
  begin
    m_TuneRange.Value := abs(m_TuneStepSize.Value) * 20.0;
  end;

  UpdateTuneParameters();
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Start tuning
// Inputs: Sender - not used
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TParameterTune.StartTune(Sender: TObject);
begin
  if (assigned(m_OnTuneStart)) then
  begin
    UpdateTuneParameters;

    if assigned(m_TuneView) then
    begin
      m_TuneView.OnUpdateTune(ord(tuneOnUpdateAll));
    end;

    // make sure tuning chart dialog is displayed
    if assigned(m_OnUpdateAllViews) then
      m_OnUpdateAllViews(Ord(m_OnUpdateHintShowChartDialog));

    // callback knows how to start tuning
    m_OnTuneStart(Self);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Stop tuning
// Inputs: Sender - not used
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TParameterTune.StopTune(Sender: TObject);
begin
  // Run the stop callback if one is defined
  if (assigned(m_OnTuneStop)) then
  begin
    m_OnTuneStop(Self);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Abort tuning
// Inputs: Sender - not used
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TParameterTune.AbortTune(Sender: TObject);
begin
  // Run the abort callback if one is defined
  if (assigned(m_OnTuneAbort)) then
  begin
    m_OnTuneAbort(Self);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description: Go thru the callback to set hardware
// Inputs: Value - requested setpoint
// Outputs: None
////////////////////////////////////////////////////////////////////////////////
procedure TParameterTune.SetHardware(Value: Double);
begin
  if (assigned(m_OnSetHardware)) then
  begin
    // set hardware
    m_OnSetHardware(Value);

    SetTuneValue(Value);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TRealEdit component.
// Inputs:       TRealEdit
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterTune.ToRealEdit(
  RealEditPtr: TRealEdit;
  UpdateTuneView: Boolean
);
begin
  m_TuneData.ToRealEdit(RealEditPtr);
  if (assigned(m_ParentPtr)) then
  begin
    if (m_ParentPtr is TParameterData) then
      TParameterData(m_ParentPtr).ToRealEdit(RealEditPtr)
    else if (m_ParentPtr is TParameterPolarity) then
      TParameterPolarity(m_ParentPtr).ToRealEdit(RealEditPtr);
  end;

  // If the value is being tuned, set the background color to yellow
  if (m_TuneStatus.Value) then
  begin
    RealEditPtr.BackColor := clYellow;
  end
  else
  begin
    RealEditPtr.BackColor := clWhite;
  end;

  if UpdateTuneView and assigned(m_TuneView) then
  begin
    m_TuneView.OnUpdateTune(ord(tuneOnUpdateTuneData));
  end;
end;

procedure TParameterTune.InitData();
begin
  // Cleanup static arrays used to hold history data
  ClearData();

  m_PlotActive := False;
  m_PlotVisible:= False;
  m_PlotColor := clBlack;
  m_PlotScaleFactor := 1.0;
  m_PlotReferenceScaleFactor := 1.0;

  m_IsDirty := True;
  m_IsDirtyData := True;
end;

procedure TParameterTune.ClearData();
begin
  // Empty the array
  SetLength(m_TuneDataSetpoints, 0);
  SetLength(m_TuneDataIntensities, 0);
  m_TuneDataIndex := -1;

  m_MinValue := 0.0;
  m_MaxValue := 0.0;
  m_MaxValueIndex := 0;
  m_FWHMPeakIndex := 0;
  m_IsDirty := True;

  if assigned(m_OnUpdateAllViews) then
    m_OnUpdateAllViews(c_OnUpdateAll);
end;

// Refresh
procedure TParameterTune.RefreshData();
begin
  m_IsDirty := True;
end;

// SetPlotActive
procedure TParameterTune.SetPlotActive(Value: Boolean);
begin
  m_PlotActive := Value;
end;

// SetPlotVisible
procedure TParameterTune.SetPlotVisible(Value: Boolean);
begin
  m_PlotVisible := Value;
end;

// SetPlotColor
procedure TParameterTune.SetPlotColor(Value: TColor);
begin
  m_PlotColor := Value;
end;

// SetPlotScaleFactor
procedure TParameterTune.SetPlotScaleFactor(Value: Double);
begin
  if m_PlotScaleFactor = Value then
    Exit;

  m_PlotScaleFactor := Value;
  m_IsDirty := True;
end;

// SetPlotReferenceScaleFactor
procedure TParameterTune.SetPlotReferenceScaleFactor(Value: Double);
begin
  if m_PlotReferenceScaleFactor = Value then
    Exit;

  m_PlotReferenceScaleFactor := Value;
  m_IsDirty := True;
end;

// SetLineWidth
procedure TParameterTune.SetLineWidth(Value: Integer);
begin
  m_LineWidth := Value;
end;

// SetLineMarkerStyle
procedure TParameterTune.SetLineMarkerStyle(Value: Integer);
begin
  m_LineMarkerStyle := Value;
end;

// SetLineLastCountsVisible
procedure TParameterTune.SetLastCountsVisible(Value: Boolean);
begin
  m_LastCountsVisible := Value;
end;

function TParameterTune.GetMinimumValue: Double;
var
  dMin: Double;
begin
  dMin := m_TuneData.Value - m_TuneRange.Value / 2.0;
  Result := dMin;
end;

function TParameterTune.GetMaximumValue: Double;
var
  dMax: Double;
begin
  dMax := m_TuneData.Value + m_TuneRange.Value / 2.0;
  Result := dMax;
end;

// GetPlotMinValue
function TParameterTune.GetPlotMinValue: Double;
begin
  if (m_PlotReferenceScaleFactor = 0.0) then
  begin
    Result := 0.0;
    Exit;
  end;

  if (m_PlotScaleFactor / m_PlotReferenceScaleFactor) > 0.0 then
    Result := m_MinValue * (m_PlotScaleFactor / m_PlotReferenceScaleFactor)
  else
    Result := m_MaxValue * (m_PlotScaleFactor / m_PlotReferenceScaleFactor);
end;

// GetPlotMaxValue
function TParameterTune.GetPlotMaxValue: Double;
begin
  if (m_PlotReferenceScaleFactor = 0.0) then
  begin
    Result := 0.0;
    Exit;
  end;

  if (m_PlotScaleFactor / m_PlotReferenceScaleFactor) > 0.0 then
    Result := m_MaxValue * (m_PlotScaleFactor / m_PlotReferenceScaleFactor)
  else
    Result := m_MinValue * (m_PlotScaleFactor / m_PlotReferenceScaleFactor);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Add a pair of [hardware supply setpoint,  measurement intensity].
// Inputs:       Setpoint - hardware supply setpoint
//               Intensity - measurement with hardware supply set to the given setpoint
// Outputs:      None
////////////////////////////////////////////////////////////////////////////////
procedure TParameterTune.SetNewTuneData(Setpoint: Double; Intensity: Double);
var
  nArraySize: Integer;
begin
  m_TuneData.Value := Setpoint;

  Inc(m_TuneDataIndex);

  // Check if the array size is large enough to hold the new item; also check that less-than time limit
  nArraySize := Length(m_TuneDataSetpoints);
  if (m_TuneDataIndex >= nArraySize) then
  begin
    SetLength(m_TuneDataSetpoints, max(nArraySize * 2, c_DefaultArraySize));
    SetLength(m_TuneDataIntensities, max(nArraySize * 2, c_DefaultArraySize));
  end;

  m_TuneDataSetpoints[m_TuneDataIndex] := Setpoint;
  m_TuneDataIntensities[m_TuneDataIndex] := Intensity;

  if m_TuneDataIndex = 0 then
  begin
    // Set the starting min and max values
    m_MinValue := m_TuneDataIntensities[0];
    m_MaxValue := m_TuneDataIntensities[0];
  end
  else
  begin
    // Update the min and max values
    if m_TuneDataIntensities[m_TuneDataIndex] < m_MinValue then
      m_MinValue := m_TuneDataIntensities[m_TuneDataIndex]
    else if m_TuneDataIntensities[m_TuneDataIndex] > m_MaxValue then
    begin
      m_MaxValue := m_TuneDataIntensities[m_TuneDataIndex];
      m_MaxValueIndex := m_TuneDataIndex;
    end;
  end;

  m_IsDirtyData := True;

  if assigned(m_OnUpdateAllViews) then
    m_OnUpdateAllViews(c_OnUpdateAll);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update the TChart object with the tune data
// Inputs:       UpdateVisual - whether to update visual
//               CurveIndex - series index for the curve of the tune data in chart
//               VisualIndex - series index for visual data (just one point to show the point selection)
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
(*procedure TParameterTune.ToChart(Chart: TChart; UpdateVisual: Boolean; CurveIndex: Integer; VisualIndex: Integer);
var
  dataIndex: Integer;
  scaledDataValue: Double;
  dMinValue, dMaxValue: Double;
begin
  try
    if m_IsDirty then
    begin
      // Rebuild the DBChart from scratch
      Chart.Series[CurveIndex].Clear;
      if (m_TuneDataIndex = 0) then
      begin
        // make sure we are in full scale
        Chart.UndoZoom;
      end;

      if m_TuneDataIndex >= 0 then
      begin
        for dataIndex := 0 to m_TuneDataIndex do
        begin
          scaledDataValue := (m_TuneDataIntensities[dataIndex] * (m_PlotScaleFactor / m_PlotReferenceScaleFactor));
          Chart.Series[CurveIndex].AddXY(m_TuneDataSetpoints[dataIndex], scaledDataValue);
          Chart.Series[CurveIndex].Marks[dataIndex].Visible := False;
        end;

        m_IsDirty := False;
        m_IsDirtyData := False;
      end;
    end
    else if m_IsDirtyData then
    begin
      // Remove the previous 'Data' annotation
      if Chart.Series[CurveIndex].Count > 0 then
        Chart.Series[CurveIndex].Marks[Chart.Series[CurveIndex].Count - 1].Visible := False;

      // Add new values to the DBChart
      for dataIndex := Chart.Series[CurveIndex].Count to m_TuneDataIndex do
      begin
        scaledDataValue := (m_TuneDataIntensities[dataIndex] * (m_PlotScaleFactor / m_PlotReferenceScaleFactor));
        Chart.Series[CurveIndex].AddXY(m_TuneDataSetpoints[dataIndex], scaledDataValue);
        Chart.Series[CurveIndex].Marks[dataIndex].Visible := False;
      end;

      m_IsDirtyData := False;
    end;

    Chart.Title.Caption := m_Caption;
    Chart.Axes.Bottom.Title.Caption := GetUnits;
    Chart.Axes.Left.Title.Caption := m_DataIntensityCaption;

    // add some head room
    if (PlotMaxValue > 0.0) then
      dMaxValue := PlotMaxValue * 1.05
    else
      dMaxValue := PlotMaxValue * 0.95;

    if (PlotMinValue > 0.0) then
      dMinValue := PlotMinValue * 0.95
    else
      dMinValue := PlotMinValue * 1.05;

    Chart.Axes.Left.SetMinMax(dMinValue, dMaxValue);
    Chart.Axes.Right.SetMinMax(dMinValue, dMaxValue);

    Chart.Series[CurveIndex].Color := m_PlotColor;
    Chart.Series[CurveIndex].Visible := m_PlotVisible;
    Chart.Series[CurveIndex].Pen.Width := m_LineWidth;
    TLineSeries(Chart.Series[CurveIndex]).Pointer.Visible := True;
    TLineSeries(Chart.Series[CurveIndex]).Pointer.Style := TSeriesPointerStyle(m_LineMarkerStyle);

    // Add the 'Data' annotation; as needed
    if (m_TuneDataIndex >= 0) and (UpdateVisual) then
    begin
      Chart.Series[CurveIndex].Marks[m_TuneDataIndex].Text.Text := ParameterFloatToStr(m_TuneDataIntensities[m_TuneDataIndex]);
      Chart.Series[CurveIndex].Marks[m_TuneDataIndex].Visible := m_LastCountsVisible;

      // update the data indicator to the maximum value
      Chart.Series[VisualIndex].Visible := False;
      Chart.Series[VisualIndex].Clear;
      Chart.Series[VisualIndex].AddXY(m_TuneDataSetpoints[m_MaxValueIndex], PlotMaxValue);
      Chart.Series[VisualIndex].Marks[0].Visible := False;
      Chart.Series[VisualIndex].Visible := True;
    end
    else  // no data
    begin
      Chart.Series[VisualIndex].Visible := False;
    end;

   except
    ShowMessage('TParameterTune:ToChart() Exception');
  end;
end;
*)

////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TRealEdit component.
// Inputs:       TRealEdit
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterTune.ToTunePopupMenu(RealEditPtr: TRealEdit);
begin
  if not assigned(m_TuneView) then
    m_TuneView := TPhiTunePropView.Create(Self);

  RealEditPtr.PopupMenu := m_TuneView.TunePopup;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TRealEdit component.
// Inputs:       TRealEdit
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterTune.ToTunePopupMenu(LabelPtr: TLabel);
begin
  if not assigned(m_TuneView) then
  begin
    m_TuneView := TPhiTunePropView.Create(Self);
  end;

  LabelPtr.PopupMenu := m_TuneView.TunePopup;
end;

procedure TParameterTune.SetTuneStatus(InProcess: Boolean);
begin
  m_TuneStatus.Value := InProcess;

  if assigned(m_TuneView) then
    m_TuneView.OnUpdate(Ord(tuneOnUpdateStatus));
end;

procedure TParameterTune.SetTuneValue(Setpoint: Double);
begin
  m_TuneData.Value := Setpoint;

  if (m_ParentPtr is TParameterData) then
     TParameterData(m_ParentPtr).Value := Setpoint
  else if (m_ParentPtr is TParameterPolarity) then
     TParameterPolarity(m_ParentPtr).Value := Setpoint;

  if assigned(m_TuneView) then
    m_TuneView.OnUpdate(Ord(tuneOnUpdateTuneData));
end;

procedure TParameterTune.DisplayTuneProperties(Sender: TObject);
begin
  if assigned(m_TuneView) then
    m_TuneView.OnUpdate(Ord(tuneOnUpdateShowProperties));
end;

procedure TParameterTune.SetTunePeakMethod(PeakMethod: String);
begin
  m_TunePeakMethod.Value := PeakMethod;

  if assigned(m_TuneView) then
    m_TuneView.OnUpdate(Ord(tuneOnUpdateAll));
end;

procedure TParameterTune.SetAmmeterRange(AmmeterRange: String);
begin
  m_AmmeterRange.Value := AmmeterRange;

  if assigned(m_TuneView) then
    m_TuneView.OnUpdate(Ord(tuneOnUpdateAll));
end;

function TParameterTune.FindFWHM: Single;
var
  dFWHM: Double;
begin
  PhiMath.FindFWHM(m_TuneDataIntensities, m_TuneStepSize.Value,
    dFWHM, m_FWHMPeakIndex, m_FWHMPeakIntensity, false {skip background subtraction});

  Result := dFWHM;
end;

end.

