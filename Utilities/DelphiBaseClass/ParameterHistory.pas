unit ParameterHistory;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterHistory.pas
// Created:   February 29, 2012 by J.Baker
// Purpose:   TParameterHistory is typically used to hold values readback from
//             hardware.
//*********************************************************
// Copyright © 2012 Physical Electronics, Inc.
// Created in 2012 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////
interface

uses
  Classes, Graphics, StdCtrls, ComCtrls, Menus, ExtCtrls, SysUtils, Windows,
  //VCLTee.Chart,
  Parameter,
  ParameterString,
  ParameterBoolean,
  ParameterColor,
  ParameterData;

type
  THistoryType = (htStateChange, htPolling, htReadback, htServiceReadback, htNone);

  TDoubleArray = Array of Double;

  THistDataRingBuffer = class(TObject)
  private
    m_HistoryValue: TDoubleArray;
    m_HistoryTime: TDoubleArray;
    m_HistoryBufferSize: Integer;
    m_FirstHistDataIdx: Integer;
    m_LastHistDataIdx: Integer;
    m_LastChartHistDataIdx: Integer;
  public
    constructor Create(AOwner: TComponent);
    procedure AddDataPoint(Value: Double; Time: Double);
    function GetLatestDataValue(): Double;
    procedure ClearData();
    function GetDataPointCount(): Integer;
    function GetNewDataPointCount(): Integer;
    procedure GetAllDataPoints(var ValueArr: TDoubleArray;
                               var TimeArr: TDoubleArray;
                               var DataPointCount: Integer);
    procedure GetNewDataPoints(var ValueArr: TDoubleArray;
                               var TimeArr: TDoubleArray;
                               var DataPointCount: Integer);
    procedure SetRingBufferSize(BufferSize: Integer);
    property HistoryBufferSize: Integer read m_HistoryBufferSize;
  end;

  TParameterHistory = class(TParameter)
  protected
    function GetValueAsFloat(): Double; override;
    procedure SetValueAsFloat(FloatValue: Double); override;
  private
    m_HistDataParameterID: Integer;
    m_HistoryType: THistoryType;

    m_Value: Double;
    m_Time: TDateTime;
    m_MinValue: Double;
    m_MaxValue: Double;

    m_HistDataRingBuffer: THistDataRingBuffer;

    m_PlotActive: Boolean;
    m_PlotVisible: Boolean;
    m_PlotColor: TColor;
    m_PlotScaleFactor: Double;
    m_PlotReferenceScaleFactor: Double;

    m_AutoScale: Boolean;
    m_AutoScaleMinValue: Double;
    m_AutoScaleMaxValue: Double;

    m_LineWidth: Integer;
    m_LineMarkerStyle: Integer;
    m_LastCountsVisible: Boolean;

    m_IsDirty: Boolean;
    m_IsDirtyData: Boolean;

    m_OnWriteCircularBuffer: TNotifyEvent;
    m_MinTimeBetweenDataSavesInSec: Int64;
    m_FastScanTimeInSec: Int64;
    m_TimeNextDataSaveAllowed: TDateTime;
    m_IgnoreDataSaveTimeLimit: Boolean;

    procedure SetPlotActive(Value: Boolean);
    procedure SetPlotVisible(Value: Boolean);
    procedure SetPlotColor(Value: TColor);
    procedure SetPlotScaleFactor(Value: Double);
    procedure SetPlotReferenceScaleFactor(Value: Double);

    procedure SetAutoScale(Value: Boolean);
    procedure SetAutoScaleMinValue(Value: Double);
    procedure SetAutoScaleMaxValue(Value: Double);

    procedure SetLineWidth(Value: Integer);
    procedure SetLineMarkerStyle(Value: Integer);
    procedure SetLastCountsVisible(Value: Boolean);

    function GetPlotMinValue: Double;
    function GetPlotMaxValue: Double;

    function GetAutoScaleReferenceMinValue: Double;
    function GetAutoScaleReferenceMaxValue: Double;

    procedure SetTimeNextDataSaveAllowed();

  public
    constructor Create(AOwner: TComponent); override;
    procedure Initialize(Sender: TParameter); override;

    procedure InitData();
    procedure ClearData();
    procedure RefreshData();
    procedure SetRingBufferSize(BufferSize: Integer);

    property HistDataParameterID: Integer read m_HistDataParameterID write m_HistDataParameterID;

    property HistoryType: THistoryType read m_HistoryType write m_HistoryType;

    property Value: Double read GetValueAsFloat write SetValueAsFloat;
    property Time: TDateTime read m_Time;

    property PlotActive: Boolean read m_PlotActive write SetPlotActive;
    property PlotVisible: Boolean read m_PlotVisible write SetPlotVisible;
    property PlotColor: TColor read m_PlotColor write SetPlotColor;
    property PlotScaleFactor: Double read m_PlotScaleFactor write SetPlotScaleFactor;
    property PlotReferenceScaleFactor: Double read m_PlotReferenceScaleFactor write SetPlotReferenceScaleFactor;

    property AutoScale: Boolean read m_AutoScale write SetAutoScale;
    property AutoScaleMinValue: Double read m_AutoScaleMinValue write SetAutoScaleMinValue;
    property AutoScaleMaxValue: Double read m_AutoScaleMaxValue write SetAutoScaleMaxValue;

    property AutoScaleReferenceMinValue: Double read GetAutoScaleReferenceMinValue;
    property AutoScaleReferenceMaxValue: Double read GetAutoScaleReferenceMaxValue;

    property LineWidth: Integer read m_LineWidth write SetLineWidth;
    property LineMarkerStyle: Integer read m_LineMarkerStyle write SetLineMarkerStyle;
    property LastCountsVisible: Boolean read m_LastCountsVisible write SetLastCountsVisible;

    property PlotMinValue: Double read GetPlotMinValue;
    property PlotMaxValue: Double read GetPlotMaxValue;

    procedure TimeStamp();
    procedure SaveDataToStringList(List: TStringList; ColumnNumber: Integer = 0);

    //procedure ToChart(Chart: TChart; CurveIndex: Integer = 0);

    property OnWriteCircularBuffer: TNotifyEvent read m_OnWriteCircularBuffer
                                                 write m_OnWriteCircularBuffer;
    property MinTimeBetweenDataSavesInSec: Int64 read m_MinTimeBetweenDataSavesInSec
                                                 write m_MinTimeBetweenDataSavesInSec;
    property FastScanTimeInSec: Int64 read m_FastScanTimeInSec
                                      write m_FastScanTimeInSec;
    property IgnoreDataSaveTimeLimit: Boolean read m_IgnoreDataSaveTimeLimit
                                              write m_IgnoreDataSaveTimeLimit;

    procedure GetAllDataPoints(var ValueArr: TDoubleArray;
                               var TimeArr: TDoubleArray;
                               var DataPointCount: Integer);
  end;

implementation

uses
  Math, Dialogs, DateUtils;
  //VCLTee.Series,
  //VCLTee.TeEngine;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterHistory.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  m_HistDataParameterID := c_InvalidIndex;
  m_HistoryType := htNone;

  m_Value := 0.0;
  m_Time := Now();

  m_HistDataRingBuffer := THistDataRingBuffer.Create(Self);

  m_MinValue := 1E50;
  m_MaxValue := -1E50;

  m_PlotActive := False;
  m_PlotVisible := False;
  m_PlotColor := clBlack;
  m_PlotScaleFactor := 1.0;
  m_PlotReferenceScaleFactor := 1.0;

  m_AutoScale := False;
  m_AutoScaleMinValue := 0.0;
  m_AutoScaleMaxValue := 0.0;

  m_LineWidth := 1;
  m_LineMarkerStyle := ord(0);//psNothing);
  m_LastCountsVisible := False;

  m_IsDirty := True;
  m_IsDirtyData := True;
  m_OnWriteCircularBuffer := nil;
  m_MinTimeBetweenDataSavesInSec := 1;
  m_FastScanTimeInSec := 0;
  m_TimeNextDataSaveAllowed := Now();
  m_IgnoreDataSaveTimeLimit := False;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy the memeber variables from the passed object
// Inputs:       TParameter
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterHistory.Initialize(Sender: TParameter);
begin
  inherited;

  Name := Sender.Name + ': History';

  if (Sender is TParameterHistory) then
  begin
    m_PlotActive := (Sender as TParameterHistory).m_PlotActive;
    m_PlotVisible:= ((Sender as TParameterHistory).m_PlotVisible);
    m_PlotColor:= ((Sender as TParameterHistory).m_PlotColor);
    m_PlotScaleFactor := (Sender as TParameterHistory).PlotScaleFactor;
    m_PlotReferenceScaleFactor := (Sender as TParameterHistory).PlotReferenceScaleFactor;
    m_LineWidth := (Sender as TParameterHistory).m_LineWidth;
    m_LineMarkerStyle := (Sender as TParameterHistory).m_LineMarkerStyle;
    m_LastCountsVisible := (Sender as TParameterHistory).m_LastCountsVisible;
  end;
end;

// InitHistory
procedure TParameterHistory.InitData();
begin
  // Cleanup static arrays used to hold history data
  ClearData();

  m_PlotActive := False;
  m_PlotVisible:= False;
  m_PlotColor := clBlack;
  m_PlotScaleFactor := 1.0;
  m_PlotReferenceScaleFactor := 1.0;

  m_AutoScale := False;
  m_AutoScaleMinValue := 0.0;
  m_AutoScaleMaxValue := 0.0;

  m_IsDirty := True;
  m_IsDirtyData := True;
end;

// ClearData
procedure TParameterHistory.ClearData();
begin
  // Clear the ring buffer.
  m_HistDataRingBuffer.ClearData();

  // Reinitialize the min and max values.
  m_MinValue := 1E50;
  m_MaxValue := -1E50;

  // Set flag to indicate the plot needs to be updated.
  m_IsDirty := True;
end;

// Refresh
procedure TParameterHistory.RefreshData();
begin
  m_IsDirty := True;
end;

// SetRingBufferSize
procedure TParameterHistory.SetRingBufferSize(BufferSize: Integer);
begin
  m_HistDataRingBuffer.SetRingBufferSize(BufferSize);
end;

// SetPlotActive
procedure TParameterHistory.SetPlotActive(Value: Boolean);
begin
  m_PlotActive := Value;
end;

// SetPlotVisible
procedure TParameterHistory.SetPlotVisible(Value: Boolean);
begin
  m_PlotVisible := Value;
end;

// SetPlotColor
procedure TParameterHistory.SetPlotColor(Value: TColor);
begin
  m_PlotColor := Value;
end;

// SetPlotScaleFactor
procedure TParameterHistory.SetPlotScaleFactor(Value: Double);
begin
  if m_PlotScaleFactor = Value then
    Exit;

  m_PlotScaleFactor := Value;
  m_IsDirty := True;
end;

// SetPlotReferenceScaleFactor
procedure TParameterHistory.SetPlotReferenceScaleFactor(Value: Double);
begin
  if m_PlotReferenceScaleFactor = Value then
    Exit;

  m_PlotReferenceScaleFactor := Value;
  m_IsDirty := True;
end;

// SetAutoScale
procedure TParameterHistory.SetAutoScale(Value: Boolean);
begin
  if m_AutoScale = Value then
    Exit;

  m_AutoScale := Value;
  m_IsDirty := True;
end;

// SetAutoScaleMinValue
procedure TParameterHistory.SetAutoScaleMinValue(Value: Double);
begin
  if m_AutoScaleMinValue = Value then
    exit;

  m_AutoScaleMinValue := Value;

  if m_AutoScale = True then
    m_IsDirty := True;
end;

// SetAutoScaleMaxValue
procedure TParameterHistory.SetAutoScaleMaxValue(Value: Double);
begin
  if m_AutoScaleMaxValue = Value then
    exit;

  m_AutoScaleMaxValue := Value;

  if m_AutoScale = True then
    m_IsDirty := True;
end;

// SetLineWidth
procedure TParameterHistory.SetLineWidth(Value: Integer);
begin
  m_LineWidth := Value;
end;

// SetLineMarkerStyle
procedure TParameterHistory.SetLineMarkerStyle(Value: Integer);
begin
  m_LineMarkerStyle := Value;
end;

// SetLineLastCountsVisible
procedure TParameterHistory.SetLastCountsVisible(Value: Boolean);
begin
  m_LastCountsVisible := Value;
end;

// GetPlotMinValue
function TParameterHistory.GetPlotMinValue: Double;
begin
  if m_PlotReferenceScaleFactor = 0.0 then
  begin
    Result := 0.0;
    Exit;
  end;

  if m_AutoScale then
    Result := m_AutoScaleMinValue
  else if (m_PlotScaleFactor / m_PlotReferenceScaleFactor) > 0.0 then
    Result := m_MinValue * (m_PlotScaleFactor / m_PlotReferenceScaleFactor)
  else
    Result := m_MaxValue * (m_PlotScaleFactor / m_PlotReferenceScaleFactor);
end;

// GetPlotMaxValue
function TParameterHistory.GetPlotMaxValue: Double;
begin
  if m_PlotReferenceScaleFactor = 0.0 then
  begin
    Result := 0.0;
    Exit;
  end;

  if m_AutoScale then
    Result := m_AutoScaleMaxValue
  else if (m_PlotScaleFactor / m_PlotReferenceScaleFactor) > 0.0 then
    Result := m_MaxValue * (m_PlotScaleFactor / m_PlotReferenceScaleFactor)
  else
    Result := m_MinValue * (m_PlotScaleFactor / m_PlotReferenceScaleFactor);
end;

// GetAutoScaleReferenceMinValue
function TParameterHistory.GetAutoScaleReferenceMinValue: Double;
begin
  Result := m_MinValue
end;

// GetAutoScaleReferenceMaxValue
function TParameterHistory.GetAutoScaleReferenceMaxValue: Double;
begin
  if m_MaxValue = m_MinValue then
    Result := m_MaxValue + (1.0 / power(10, Precision))
  else
    Result := m_MaxValue
end;

// GetValueAsFloat
function TParameterHistory.GetValueAsFloat(): Double;
begin
  result := m_Value;
end;

// SetValueAsFloat
procedure TParameterHistory.SetValueAsFloat(FloatValue: Double);
var
  valueSaved: Boolean;
begin
  try
    m_Value := FloatValue;
    m_Time := Now();

    valueSaved := False;
    if Assigned(m_OnWriteCircularBuffer) then
    begin
      if (m_Time > m_TimeNextDataSaveAllowed) or (m_IgnoreDataSaveTimeLimit) then
      begin
        // Write to database circular buffer
        m_OnWriteCircularBuffer(Self);

        valueSaved := True;
      end;
    end;

    if m_PlotActive then
    begin
      if (m_Time > m_TimeNextDataSaveAllowed) or (m_IgnoreDataSaveTimeLimit) then
      begin
        // Store the value and time in the ring buffer.
        m_HistDataRingBuffer.AddDataPoint(m_Value, m_Time);

        // Update the min and max values
        if m_Value < m_MinValue then
        begin
          m_MinValue := m_Value;
          if m_AutoScale then
            m_IsDirty := True;
        end;

        if m_Value > m_MaxValue then
        begin
          m_MaxValue := m_Value;
          if m_AutoScale then
            m_IsDirty := True;
        end;

        m_IsDirtyData := True;
        valueSaved := True;
      end;
    end;

    // If a value was saved, set the time when the next data save is allowed.
    if (valueSaved) then
      SetTimeNextDataSaveAllowed();

  except
    ShowMessage('TParameterHistory:SetValueAsFloat() Exception');
  end;
end;

// TimeStamp
procedure TParameterHistory.TimeStamp();
var
  previousValue: Double;
begin
  if m_PlotActive then
  begin
    // Get the previous value.
    previousValue := m_HistDataRingBuffer.GetLatestDataValue();

    // Store the previous value with the current time.
    m_HistDataRingBuffer.AddDataPoint(previousValue, Now());

    m_IsDirtyData := True;
  end;
end;

// SaveDataToStringList
procedure TParameterHistory.SaveDataToStringList(List: TStringList; ColumnNumber: Integer);
var
  valueArr: TDoubleArray;
  timeArr: TDoubleArray;
  dataPointCount: Integer;
  sDelimiter: String;
  nIndex: Integer;
begin
  try
    // Get the data from the ring buffer.
    m_HistDataRingBuffer.GetAllDataPoints(valueArr, timeArr, dataPointCount);

    if dataPointCount > 0 then
    begin
      // Update list capacity before write
      if List.Capacity < (List.Count + dataPointCount) then
        List.Capacity := (List.Count + dataPointCount);

      // Column position in csv file (i.e. Excel file) is achieved by adding multiple comma separators
      sDelimiter := '';
      for nIndex := 1 to ColumnNumber do
        sDelimiter := sDelimiter + ',';

      for nIndex := 0 to dataPointCount-1 do
      begin
        List.Append(FormatDateTime('mm/dd/yyyy hh:nn:ss', timeArr[nIndex]) +
                    sDelimiter +
                    FloatToStr(valueArr[nIndex]));
      end;
    end;

  finally
    SetLength(ValueArr, 0);
    SetLength(TimeArr, 0);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add the current readback value to a TChart object.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
(*procedure TParameterHistory.ToChart(Chart: TChart; CurveIndex: Integer);
var
  valueArr: TDoubleArray;
  timeArr: TDoubleArray;
  dataPointCount: Integer;
  idx: Integer;
  scaledDataValue: Double;
  latestValue: Double;
  latestChartIdx: Integer;
  chartItemCount: Integer;
  chartIdx: Integer;
  autoScaleReferenceRange: Double;
  autoScaleRange: Double;
  scaleFactor: Double;
begin
  try
    // Calculate the scale factors once.
    if m_AutoScale then
    begin
      autoScaleReferenceRange := AutoScaleReferenceMaxValue - AutoScaleReferenceMinValue;
      autoScaleRange := m_AutoScaleMaxValue - m_AutoScaleMinValue;
      scaleFactor := 1.0 / autoScaleReferenceRange * autoScaleRange;
    end
    else
    begin
      scaleFactor := (m_PlotScaleFactor / m_PlotReferenceScaleFactor);
    end;

    // Check if the entire plot must be updated.
    if m_IsDirty then
    begin
      // Clear the data.
      Chart.Series[CurveIndex].Clear;

      try
        // Get all the data from the ring buffer.
        m_HistDataRingBuffer.GetAllDataPoints(valueArr, timeArr, dataPointCount);

        // Loop through all the points in the data array.
        for idx := 0 to dataPointCount-1 do
        begin
          // Calculate the scaled data value.
          if m_AutoScale then
            scaledDataValue := m_AutoScaleMinValue + ((valueArr[idx] - m_MinValue) * scaleFactor)
          else
            scaledDataValue := valueArr[idx] * scaleFactor;

          // Add the new data value.
          Chart.Series[CurveIndex].AddXY(timeArr[idx], scaledDataValue);

          // Set the marks to not visible.
          Chart.Series[CurveIndex].Marks[idx].Visible := False;
        end;
      finally
        SetLength(ValueArr, 0);
        SetLength(TimeArr, 0);
      end;

      m_IsDirty := False;
      m_IsDirtyData := False;
    end

    // Check if new data has been added.
    else if m_IsDirtyData then
    begin
      // Hide the previous data marks.
      chartItemCount := Chart.Series[CurveIndex].Count;
      if chartItemCount > 0 then
        Chart.Series[CurveIndex].Marks.Item[chartItemCount-1].Visible := False;

      try
        // Get all the new data from the ring buffer.
        m_HistDataRingBuffer.GetNewDataPoints(valueArr, timeArr, dataPointCount);

        // Loop through all the points in the data array.
        for idx := 0 to dataPointCount-1 do
        begin
          // Calculate the scaled data value.
          if m_AutoScale then
            scaledDataValue := m_AutoScaleMinValue + ((valueArr[idx] - AutoScaleReferenceMinValue) * scaleFactor)
          else
            scaledDataValue := valueArr[idx] * scaleFactor;

          // If the data is at the point limit, delete the first data value.
          if chartItemCount = m_HistDataRingBuffer.HistoryBufferSize then
            Chart.Series[CurveIndex].Delete(0);

          // Add the new data value.
          Chart.Series[CurveIndex].AddXY(timeArr[idx], scaledDataValue);

          // Set the marks to not visible.
          chartIdx := Chart.Series[CurveIndex].Count - 1;
          Chart.Series[CurveIndex].Marks[chartIdx].Visible := False;
        end;
      finally
        SetLength(ValueArr, 0);
        SetLength(TimeArr, 0);
      end;

      m_IsDirtyData := False;
    end;

    Chart.Series[CurveIndex].Color := m_PlotColor;
    Chart.Series[CurveIndex].Visible := m_PlotVisible;
    Chart.Series[CurveIndex].Pen.Width := m_LineWidth;
    TLineSeries(Chart.Series[CurveIndex]).Pointer.Visible := True;
    TLineSeries(Chart.Series[CurveIndex]).Pointer.Style := TSeriesPointerStyle(m_LineMarkerStyle);

    // Add the 'Data' annotation; as needed
    latestChartIdx := Chart.Series[CurveIndex].Count - 1;
    if latestChartIdx >= 0 then
    begin
      latestValue := m_HistDataRingBuffer.GetLatestDataValue();
      Chart.Series[CurveIndex].Marks[latestChartIdx].Text.Text := ParameterFloatToStr(latestValue);
      Chart.Series[CurveIndex].Marks[latestChartIdx].Visible := m_LastCountsVisible;
    end;
   except
    ShowMessage('TParameterHistory:ToChart() Exception');
  end;
end;
*)

// SetTimeNextDataSaveAllowed
procedure TParameterHistory.SetTimeNextDataSaveAllowed();
var
  minTimeInSec: Int64;
  minTimeBetweenDataSavesInMSec: Int64;
begin
  // If a fast scan rate is set, use the minimum of the minimum time and the
  // fast scan time. Otherwise, use the minimun time.
  if (m_FastScanTimeInSec = 0) then
    minTimeInSec := m_MinTimeBetweenDataSavesInSec
  else
    minTimeInSec := Min(m_MinTimeBetweenDataSavesInSec, m_FastScanTimeInSec);

  // Subtract 500 milliseconds from the minimum time to account for timer variability
  // and the time it took to read the value.
  minTimeBetweenDataSavesInMSec := minTimeInSec*1000 - 500;

  // Set the next time when another DB write will be allowed.
  m_TimeNextDataSaveAllowed := IncMillisecond(Now(), minTimeBetweenDataSavesInMSec);
end;

// GetAllDataPoints
procedure TParameterHistory.GetAllDataPoints(var ValueArr: TDoubleArray;
                                             var TimeArr: TDoubleArray;
                                             var DataPointCount: Integer);
begin
  m_HistDataRingBuffer.GetAllDataPoints(ValueArr, TimeArr, DataPointCount);
end;

////////////////////////////////////////////////////////////////////////////////
// THistDataRingBuffer
////////////////////////////////////////////////////////////////////////////////
// Create
constructor THistDataRingBuffer.Create(AOwner: TComponent);
begin
  ClearData();
end;

// ClearData
procedure THistDataRingBuffer.ClearData();
begin
  SetLength(m_HistoryValue, 0);
  SetLength(m_HistoryTime, 0);
  m_FirstHistDataIdx := -1;
  m_LastHistDataIdx := -1;
  m_LastChartHistDataIdx := -1;
end;

// AddDataPoint
procedure THistDataRingBuffer.AddDataPoint(Value: Double; Time: Double);
begin
  // Check if this is the first point to be added to the arrays.
  if (m_FirstHistDataIdx < 0) then
  begin
    // Allocate memory to hold the arrays.
    SetLength(m_HistoryValue, m_HistoryBufferSize);
    SetLength(m_HistoryTime, m_HistoryBufferSize);

    // Set the indices.
    m_FirstHistDataIdx := 0;
    m_LastHistDataIdx := 0;
    m_LastChartHistDataIdx := -1;
  end
  else // Not the first point.
  begin
    // Increment the index of the last data point and handle the rollover.
    Inc(m_LastHistDataIdx);
    if (m_LastHistDataIdx = m_HistoryBufferSize) then
      m_LastHistDataIdx := 0;

    // If the last and first data indices are the same, increment the index
    // of the first data point and handle the rollover.
    if (m_LastHistDataIdx = m_FirstHistDataIdx) then
    begin
      Inc(m_FirstHistDataIdx);
      if (m_FirstHistDataIdx = m_HistoryBufferSize) then
        m_FirstHistDataIdx := 0;
    end;
  end;

  // Save the value and time in the ring buffer.
  m_HistoryValue[m_LastHistDataIdx] := Value;
  m_HistoryTime[m_LastHistDataIdx] := Time;
end;

// GetLatestDataValue
function THistDataRingBuffer.GetLatestDataValue(): Double;
begin
  if m_LastHistDataIdx = -1 then
    Result := 0.0
  else
    Result := m_HistoryValue[m_LastHistDataIdx];
end;

// GetDataPointCount
function THistDataRingBuffer.GetDataPointCount(): Integer;
var
  dataPointCount: Integer;
begin
  if m_FirstHistDataIdx < 0 then
    dataPointCount := 0
  else if m_FirstHistDataIdx = 0 then
    dataPointCount := m_LastHistDataIdx - m_FirstHistDataIdx + 1
  else
    dataPointCount := m_HistoryBufferSize;

  Result := dataPointCount;
end;

// GetAllDataPoints
procedure THistDataRingBuffer.GetAllDataPoints(var ValueArr: TDoubleArray;
                                               var TimeArr: TDoubleArray;
                                               var DataPointCount: Integer);
var
  histDataIdx: Integer;
  arrDataIdx: Integer;
begin
  // Get the size of the arrays.
  DataPointCount := GetDataPointCount();

  // Allocate memory for the arrays.
  SetLength(ValueArr, DataPointCount);
  SetLength(TimeArr, DataPointCount);

  if m_FirstHistDataIdx >= 0 then
  begin
    histDataIdx := m_FirstHistDataIdx;
    arrDataIdx := 0;

    ValueArr[arrDataIdx] := m_HistoryValue[histDataIdx];
    TimeArr[arrDataIdx] := m_HistoryTime[histDataIdx];

    while histDataIdx <> m_LastHistDataIdx do
    begin
      Inc(arrDataIdx);
      Inc(histDataIdx);
      if histDataIdx = m_HistoryBufferSize then
        histDataIdx := 0;

      ValueArr[arrDataIdx] := m_HistoryValue[histDataIdx];
      TimeArr[arrDataIdx] := m_HistoryTime[histDataIdx];
    end;
  end;

  // Update the index of the last value on the chart.
  m_LastChartHistDataIdx := m_LastHistDataIdx;
end;

// GetNewDataPointCount
function THistDataRingBuffer.GetNewDataPointCount(): Integer;
var
  dataPointCount: Integer;
begin
// Example using a 10 item ring buffer.

//               0123456789
// last chart      ^         Result = 0
// last data       x

//               0123456789
// last chart      ^         Result = 1
// last data        x

//               0123456789
// last chart             ^  Result = 3
// last data       x

  if m_LastChartHistDataIdx = m_LastHistDataIdx then
    dataPointCount := 0

  else if m_LastChartHistDataIdx < m_LastHistDataIdx then
    dataPointCount := m_LastHistDataIdx - m_LastChartHistDataIdx

  else
    dataPointCount := (m_HistoryBufferSize - m_LastChartHistDataIdx) +  m_LastHistDataIdx;

  Result := dataPointCount;
end;

// GetNewDataPoints
procedure THistDataRingBuffer.GetNewDataPoints(var ValueArr: TDoubleArray;
                                               var TimeArr: TDoubleArray;
                                               var DataPointCount: Integer);
var
  histDataIdx: Integer;
  arrDataIdx: Integer;
begin
  // Get the size of the arrays.
  DataPointCount := GetNewDataPointCount();

  if DataPointCount > 0 then
  begin
    // Allocate memory for the arrays.
    SetLength(ValueArr, DataPointCount);
    SetLength(TimeArr, DataPointCount);

    histDataIdx := m_LastChartHistDataIdx + 1;
    if histDataIdx = m_HistoryBufferSize then
      histDataIdx := 0;
    arrDataIdx := 0;

    ValueArr[arrDataIdx] := m_HistoryValue[histDataIdx];
    TimeArr[arrDataIdx] := m_HistoryTime[histDataIdx];

    while histDataIdx <> m_LastHistDataIdx do
    begin
      Inc(arrDataIdx);
      Inc(histDataIdx);
      if histDataIdx = m_HistoryBufferSize then
        histDataIdx := 0;

      ValueArr[arrDataIdx] := m_HistoryValue[histDataIdx];
      TimeArr[arrDataIdx] := m_HistoryTime[histDataIdx];
    end;

    // Update the index of the last value on the chart.
    m_LastChartHistDataIdx := m_LastHistDataIdx;
  end;
end;

// SetRingBufferSize
procedure THistDataRingBuffer.SetRingBufferSize(BufferSize: Integer);
var
  historyValueArray: TDoubleArray;
  historyTimeArray: TDoubleArray;
  dataPointCount: Integer;
  idx: Integer;
begin
  // Check that the buffer size has changed
  if BufferSize = m_HistoryBufferSize then
    exit;

  // Check if the old data size was 0.
  if m_HistoryBufferSize = 0 then
  begin
    ClearData();
  end
  else
  begin
    // Get all the data from the current Ring Buffer.
    GetAllDataPoints(historyValueArray, historyTimeArray, dataPointCount);

    // Set the length of the buffers.
    SetLength(m_HistoryValue, BufferSize);
    SetLength(m_HistoryTime, BufferSize);

    // Copy the data.
    idx := 0;
    while (idx < dataPointCount) and (idx < BufferSize) do
    begin
      m_HistoryValue[idx] := historyValueArray[idx];
      m_HistoryTime[idx] := historyTimeArray[idx];
      Inc(idx);
    end;

    // Set the start and end indices.
    if (dataPointCount = 0) then
    begin
      m_FirstHistDataIdx := -1;
      m_LastHistDataIdx := -1;
      m_LastChartHistDataIdx := -1;
    end
    else
    begin
      m_FirstHistDataIdx := 0;
      m_LastHistDataIdx := Min(dataPointCount, BufferSize) - 1;
      m_LastChartHistDataIdx := 0;
    end;

    // Free the memory for the arrays.
    SetLength(historyValueArray, 0);
    SetLength(historyTimeArray, 0);
  end;

  // Set the new buffer size.
  m_HistoryBufferSize := BufferSize;
end;

end.

