unit PhiMath;

////////////////////////////////////////////////////////////////////////////////
//
// Filename:       PhiMath.pas
//
// Created:        on 11/28/00
//
// Purpose:  This file defines global math functions.
//
// History:
//
// Initial revision
// - on 11/28/00
//
// Add bEffectivelyEquals for comparing Single or Double
// - on 9/24/04 by Melinda Caouette
//
// Add FloorMod for getting floor of extended value that's modified by some
// small amount to avoid getting floor value of unintended value which could be
// slightly off due to floating point representation (ie. 5.9999999 insead of 6.0).
// - on 9/3/09
//
// Copyright © 2004 Physical Electronics USA
//
// Created in 2004 as an unpublished copyrighted work.  This program and the
// information contained in it are confidential and proprietary to Physical
// Electronics and may not be used, copied, or reproduced without the prior
// written permission of Physical Electronics.
//
////////////////////////////////////////////////////////////////////////////////

interface

// Global Math Functions
function bEffectivelyEquals(F1: Double; F2: Double): Boolean; overload;
function bEffectivelyEquals(F1: Double; F2: Double; fEpsilon: Double): Boolean; overload;
function bEffectivelyEquals(F1: Single; F2: Single): Boolean; overload;
function bEffectivelyEquals(F1: Single; F2: Single; fEpsilon: Single): Boolean; overload;

function bIsEffectivelyInRange(fMin: Double; fValue: Double; fMax: Double): Boolean; overload;
function bIsEffectivelyInRange(fMin: Double; fValue: Double; fMax: Double; fEpsilon: Double): Boolean; overload;
function bIsEffectivelyInRange(fMin: Single; fValue: Single; fMax: Single): Boolean; overload;
function bIsEffectivelyInRange(fMin: Single; fValue: Single; fMax: Single; fEpsilon: Single): Boolean; overload;

function bIsEffectivelyGTE(fValue: Double; fMinValue: Double): Boolean; overload;
function bIsEffectivelyGTE(fValue: Double; fMinValue: Double; fEpsilon: Double): Boolean; overload;
function bIsEffectivelyGTE(fValue: Single; fMinValue: Single): Boolean; overload;
function bIsEffectivelyGTE(fValue: Single; fMinValue: Single; fEpsilon: Single): Boolean; overload;

function bIsEffectivelyLTE(fValue: Double; fMaxValue: Double): Boolean; overload;
function bIsEffectivelyLTE(fValue: Double; fMaxValue: Double; fEpsilon: Double): Boolean; overload;
function bIsEffectivelyLTE(fValue: Single; fMaxValue: Single): Boolean; overload;
function bIsEffectivelyLTE(fValue: Single; fMaxValue: Single; fEpsilon: Single): Boolean; overload;

function bIsEffectivelyZero(fValue: Double): Boolean; overload;
function bIsEffectivelyZero(fValue: Double; fEpsilon: Double): Boolean; overload;
function bIsEffectivelyZero(fValue: Single): Boolean; overload;
function bIsEffectivelyZero(fValue: Single; fEpsilon: Single): Boolean; overload;

function ElapsedTimeInMs(StartTime: Cardinal): Cardinal;

procedure FindMin(const Data: OleVariant; LowBound, HighBound: Integer; out MinValue: Double ; out IndexOfMinValue: Integer); overload;
procedure FindMax(const Data: OleVariant; LowBound, HighBound: Integer; out MaxValue: Double ; out IndexOfMaxValue: Integer); overload;
function BinarySearch(const Data: OleVariant; ValueToSearch: Double) : Integer; overload;
function BinarySearch(const Data: Array of Single; ValueToSearch: Double) : Integer; overload;

procedure FindFWHM(const Data: OleVariant; LowBound, HighBound: Integer; StepSizeInV: Single;
  out MinValue: Single ; out MaxValue: Single; out FWHM: Single; out MaxValueIndex: Integer); overload;
procedure FindFWHM(const DataArray: array of Double; StepSizeInV: Double;
  out FWHM: Double; out FWHMMidpointIndex: Integer; out FWHMMidpointIntensity: Double;
  DoBackgroundSubtraction: Boolean=True); overload;

procedure FindMin(const DataArray: array of Double; out fMinValue: Double; out nIndexOfMinValue: Integer);  overload;
procedure FindMin(const DataArray: array of Single; out fMinValue: Single; out nIndexOfMinValue: Integer);  overload;

procedure FindMax(const DataArray: array of Double; out fMaxValue: Double; out nIndexOfMaxValue: Integer);  overload;
procedure FindMax(const DataArray: array of Single; out fMaxValue: Single; out nIndexOfMaxValue: Integer);  overload;

function ConvertTorrToPascal(PressureInTorr: Double): Double ; overload;
function ConvertPascalToTorr(PressureInPa: Double): Double ; overload;
function ConvertTorrToPascal(PressureInTorr: Single): Single ; overload;
function ConvertPascalToTorr(PressureInPa: Single): Single ;  overload;

function FloorMod(fValue: Extended): Integer; overload;
function FloorMod(fValue: Extended; fEpsilon: Single): Integer; overload;
function FloorMod(fValue: Extended; fEpsilon: Double): Integer; overload;

function GreatestCommonDivisor(nUValue: Integer; nVValue: Integer): Integer ;

procedure DifferentiateNormalize(
  nNoOfPointDerivative: Integer;
  fStepSize: Single;
  nStartDataIndex: Integer;
  nEndDataIndex: Integer;
  var Data: OleVariant;
  out dMaxValue: Double;
  out dMinValue: Double
);
procedure Differentiate(
  nNoOfDiffPoints: Integer;
  nStartDataIndex: Integer;
  nEndDataIndex: Integer;
  var Data: OleVariant;
  out dMaxValue: Double;
  out dMinValue: Double
);
procedure SmoothData(
  nNoOfDataPoints: Integer;
  nNoOfSmoothPoints: Integer;
  var Data: OleVariant;
  var dMinDataVal: Double;
  var dMaxDataVal: Double;
  var nMinDataIndex: Integer;
  var nMaxDataIndex: Integer
);
procedure BinomialSmoothData(
  nNoOfDataPoints: Integer;
  nNoOfSmoothPoints: Integer;
  var Data: OleVariant;
  var dMinDataVal: Double;
  var dMaxDataVal: Double;
  var nMinDataIndex: Integer;
  var nMaxDataIndex: Integer
);

procedure dif_min_max(var dValue: Double; var dMinValue: Double; var dMaxValue: Double);
procedure dif_buff(Data: array of Double; nStartIndex: Integer; nNoOfDiffPoints: Integer; out dDiff: Double);


const
  // Default epsilon value if not specified for double
  c_fDefaultDoubleEpsilon: Double = 1e-8;

  // Default epsilon value if not specified for single
  c_fDefaultSingleEpsilon: Single = 1e-6;

implementation

uses
  Windows,
  mmsystem,
  PhiExceptions,
  ObjectPhi,
  SysLogQueue,
  SYSLOGQUEUELib_TLB,

  Variants, Math, ActiveX, Sysutils;

const
  // Pascal to Torr Ratio values 152Torr = 20265Pa
  c_TorrToPascalFactor : Double = 20265/152 ;
  c_PascalToTorrFactor : Double = 152/20265 ;

  c_YNorms: array[0..24] of Double = (
    0.0,    2.0,   10.0,   28.0,   60.0,  110.0,  182.0,  280.0,  408.0,
    570.0,  770.0, 1012.0, 1300.0, 1638.0, 2030.0, 2480.0, 2992.0, 3570.0,
    4218.0, 4940.0, 5740.0, 6622.0, 7588.0, 8644.0, 9794.0 );

  // Const arrays used with n-pt smoothing
  c_fSmoothXNormArray: array[0..12] of Single = (0.0, 4.0, 35.0, 21.0, 231.0,
    429.0, 143.0, 1105.0, 323.0, 2261.0, 3059.0, 805.0, 5175.0);

  c_nSmoothCoeffArray: array [0..90] of Integer = (0, 2, 1, 17, 12, -3, 7, 6,
    3, -2, 59, 54, 39, 14, -21, 89, 84, 69, 44, 9, -36, 25, 24, 21, 16, 9, 0,
    -11, 167, 162, 147, 122, 87, 42, -13, -78, 43, 42, 39, 34, 27, 18, 7, -6,
    -21, 269, 264, 249, 224, 189, 144, 89, 24, -51, -136, 329, 324, 309, 284,
    249, 204, 149, 84, 9, -76, -171, 79, 78, 75, 70, 63, 54, 43, 30, 15, -2,
    -21, -42, 467, 462, 447, 422, 387, 342, 287, 222, 147, 62, -33, -138, -253);

type
  DataDoubleArray  = array[0..$effffff] of Double;
  PDataDoubleArray = ^DataDoubleArray;

procedure FindMax(const Data: OleVariant; LowBound,
  HighBound: Integer; out MaxValue: Double; out IndexOfMaxValue: Integer);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Find the maximum for the given data in the given range
// Inputs:      Data - an ole variant array of double
//              LowBound - starting index to search
//              HighBound - ending index to search
// Outputs:     MaxValue - maximum value found in the given range
//              IndexOfMaxValue - index of the maximum value
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  DataHighBound, DataLowBound: Integer ;               // low and high bound of data
  Index: Integer ;
begin
  assert(VarType(Data) = (VT_ARRAY + VT_R8)) ;

  DataLowBound := VarArrayLowBound(Data, 1) ;
  DataHighBound := VarArrayHighBound(Data, 1) ;

  IndexOfMaxValue := LowBound ;
  MaxValue := -MaxDouble ;

  if (LowBound >= DataLowBound) and (HighBound <= DataHighBound) then
  begin
    for Index := LowBound+1 to HighBound do
    begin
      if (Data[Index] > MaxValue) then
      begin
        MaxValue := Data[Index] ;
        IndexOfMaxValue := Index ;
      end ;
    end;
  end;

end;

procedure FindMin(const Data: OleVariant; LowBound,
  HighBound: Integer; out MinValue: Double; out IndexOfMinValue: Integer);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Find the minimum for the given data in the given range
// Inputs:      Data - an ole variant array of double
//              LowBound - starting index to search
//              HighBound - ending index to search
// Outputs:     MinValue - minimum value found in the given range
//              IndexOfMinValue - index of the minimum value
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  DataHighBound, DataLowBound: Integer ;               // low and high bound of data
  Index: Integer ;
begin
  assert(VarType(Data) = (VT_ARRAY + VT_R8)) ;

  DataLowBound := VarArrayLowBound(Data, 1) ;
  DataHighBound := VarArrayHighBound(Data, 1) ;

  MinValue := MaxDouble ;
  IndexOfMinValue := LowBound ;

  if (LowBound >= DataLowBound) and (HighBound <= DataHighBound) then
  begin
    MinValue := Data[LowBound] ;
    IndexOfMinValue := LowBound ;

    for Index := LowBound+1 to HighBound do
    begin
      if (Data[Index] < MinValue) then
      begin
        MinValue := Data[Index] ;
        IndexOfMinValue := Index ;
      end ;
    end;
  end;
end;

procedure FindFWHM(const Data: OleVariant; LowBound, HighBound: Integer; StepSizeInV: Single;
  out MinValue: Single ; out MaxValue: Single; out FWHM: Single; out MaxValueIndex: Integer);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Find FWHM for the given data in the given range
// Inputs:      Data - an ole variant array of double
//              LowBound - starting index to search
//              HighBound - ending index to search
//              StepSizeInV - step size (x data increment)
// Outputs:     MinValue - minimum value found in the given range
//              MaxValue - maximum value found in the given range
//              FWHM - full width half max in V calculated for the given range
//              MaxValueIndex - index of the data with the maximum count
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  DataHighBound, DataLowBound: Integer ;               // low and high bound of data
  nIndex: Integer ;
  nFwhmCount: Integer;
  nPeakIndex, nFwhmRightIndex, nFwhmLeftIndex: Integer;
  bFound: Boolean;
  nNoOfFwhmDataPoints: Integer;
  fLeftEndPointCount, fRightEndPointCount: Double;
  fBaselineSlope, fBaseline: Double;
  fMax : Double;                                 
  fHalfMax: Double;
  fIntensity: Double;
  nFinalFwhmLeftIndex, nFinalFwhmRightIndex: Integer;
  fFinalFwhmLeftIndex, fFinalFwhmRightIndex: Single;
  fIntensityOfRightFWHM, fIntensityofLeftFWHM: Double;
begin
  assert(VarType(Data) = (VT_ARRAY + VT_R8)) ;

  DataLowBound := VarArrayLowBound(Data, 1) ;
  DataHighBound := VarArrayHighBound(Data, 1) ;

  if (LowBound >= DataLowBound) and (HighBound <= DataHighBound) then
  begin
    // find max and min
    MinValue := Data[LowBound] ;
    MaxValue := Data[LowBound];
    nPeakIndex := LowBound;
    FWHM := 0.0;

    for nIndex := LowBound+1 to HighBound do
    begin
      if (Data[nIndex] < MinValue) then
      begin
        MinValue := Data[nIndex] ;
      end ;

      if (Data[nIndex] > MaxValue) then
      begin
        MaxValue := Data[nIndex] ;
        nPeakIndex := nIndex;
        MaxValueIndex := nIndex;
      end ;
    end;

    // half the number of counts of the peak
    nFwhmCount := Round(MaxValue - (MaxValue - MinValue) * 0.5);

    // find right point of FWHM line (in first scan, don't worry about background subtraction)
    bFound := false;
    nFwhmRightIndex := nPeakIndex;
    nIndex := nPeakIndex + 1;
    while (not bFound) and (nIndex <= HighBound) do
    begin
      if (Data[nIndex] < nFwhmCount) then
      begin
        nFwhmRightIndex := nIndex;
        bFound := true;
      end ;

      Inc(nIndex);
    end;

    // find left point of FWHM line (in first scan, don't worry about background subtraction)
    bFound := false;
    nFwhmLeftIndex := nPeakIndex;
    nIndex := nPeakIndex - 1;
    while (not bFound) and (nIndex >= LowBound) do
    begin
      if (Data[nIndex] < nFwhmCount) then
      begin
        nFwhmLeftIndex := nIndex;
        bFound := true;
      end ;

      Dec(nIndex);
    end;

    // zoom into a smaller section of the data around peak
    nNoOfFwhmDataPoints := (nFwhmRightIndex - nFwhmLeftIndex + 1) * 2;

    // adjust right and left indicies to include more points around peak
    nFwhmRightIndex := nPeakIndex + nNoOfFwhmDataPoints;
    if (nFwhmRightIndex > HighBound) then
      nFwhmRightIndex := HighBound;

    nFwhmLeftIndex := nPeakIndex - nNoOfFwhmDataPoints;
    if (nFwhmLeftIndex < LowBound) then
      nFwhmLeftIndex := LowBound;

    if (nFwhmRightIndex - nFwhmLeftIndex + 1 > 4) then
    begin
      // end points of baseline
      fRightEndPointCount := Data[nFwhmRightIndex];
      fLeftEndPointCount := Data[nFwhmLeftIndex];

      // calculate slope of baseline (increment/decrement of background per data point)
      fBaselineSlope := (fRightEndPointCount - fLeftEndPointCount) / (nFwhmRightIndex - nFwhmLeftIndex + 1) ;

      // determine peak height
      fBaseline := fLeftEndPointCount;
      fMax := 0.0;
      nPeakIndex := nFwhmLeftIndex;
      for nIndex := nFwhmLeftIndex to nFwhmRightIndex do
      begin
        // subtract background
        fIntensity := Data[nIndex] - fBaseline;
        if (fIntensity > fMax) then
        begin
          fMax := fIntensity;
          nPeakIndex := nIndex;
        end;

        fBaseline := fBaseline + fBaselineSlope;
      end;

      // determine right FWHM point
      fBaseline := fBaselineSlope * (nPeakIndex - nFwhmLeftIndex) + fLeftEndPointCount;
      fHalfMax := fMax / 2.0;
      bFound := false;
      nIndex := nPeakIndex;
      nFinalFwhmRightIndex := nFwhmRightIndex;
      fFinalFwhmRightIndex := nFinalFwhmRightIndex;
      while (not bFound) and (nIndex <= nFwhmRightIndex) do
      begin
        // subtract background
        fIntensity := Data[nIndex] - fBaseline;
        if (bIsEffectivelyLTE(fIntensity, fHalfMax)) then
        begin
          // step back one
          nFinalFwhmRightIndex := nIndex - 1;
          // can't go pass peak index
          if (nFinalFwhmRightIndex < nPeakIndex) then
          begin
            nFinalFwhmRightIndex := nPeakIndex;
          end;

          bFound := true;

          fIntensityOfRightFWHM := Data[nFinalFwhmRightIndex] - fBaseline;

          if (not bEffectivelyEquals(fIntensityOfRightFWHM, fIntensity)) then
            fFinalFwhmRightIndex := (fHalfMax - fIntensityOfRightFWHM) / (fIntensity - fIntensityOfRightFWHM) +
                                      nFinalFwhmRightIndex;
        end
        else
        begin
          fBaseline := fBaseline + fBaselineSlope;

          Inc(nIndex);
        end;
      end;

      // determine left FWHM point
      fBaseline := fBaselineSlope * (nPeakIndex - nFwhmLeftIndex) + fLeftEndPointCount;
      bFound := false;
      nIndex := nPeakIndex;
      nFinalFwhmLeftIndex := nFwhmLeftIndex;
      fFinalFwhmLeftIndex := nFinalFwhmLeftIndex;
      while (not bFound) and (nIndex >= nFwhmLeftIndex) do
      begin
        // subtract background
        fIntensity := Data[nIndex] - fBaseline;
        if (bIsEffectivelyLTE(fIntensity, fHalfMax)) then
        begin
          nFinalFwhmLeftIndex := nIndex;
          // can't go pass peak index
          if (nFinalFwhmLeftIndex > nPeakIndex) then
          begin
            nFinalFwhmLeftIndex := nPeakIndex;
          end;

          bFound := true;

          fIntensityOfLeftFWHM := Data[nFinalFwhmLeftIndex+1] - fBaseline;

          if (not bEffectivelyEquals(fIntensityOfLeftFWHM, fIntensity)) then
            fFinalFwhmLeftIndex := (fHalfMax - fIntensity) / (fIntensityOfLeftFWHM - fIntensity) + nFinalFwhmLeftIndex;
        end
        else
        begin
          fBaseline := fBaseline - fBaselineSlope;

          Dec(nIndex);
        end;
      end;

      FWHM := (fFinalFwhmRightIndex - fFinalFwhmLeftIndex) * StepSizeInV;

      if (FWHM < 0.0) then
      begin
        LogTraceMsg('FindFWHM', tNoTrace, 'FWHM is -ve: right=' + FloatToStr(fFinalFwhmRightIndex) + ' left=' +
          FloatToStr(fFinalFwhmLeftIndex) + ' peak=' + IntToStr(nPeakIndex));
        FWHM := 0.0;
      end;
    end;
  end;
end;

procedure FindFWHM(const DataArray: array of Double; StepSizeInV: Double;
  out FWHM: Double; out FWHMMidpointIndex: Integer; out FWHMMidpointIntensity: Double;
  DoBackgroundSubtraction: Boolean);
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Find FWHM for the given data in the given range
// Inputs:      DataArray - y data intensity
//              StepSizeInV - step size (x data increment)
//              DoBackgroundSubtraction - do background subtraction in locating FWHM
// Outputs:     FWHM - full width half max in V calculated for the given range
//              FWHMMidpointIndex - index of the FWHM midpoint
//              FWHMMidpointIntensity - intensity of the FWHM midpoint
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  HighBound, LowBound: Integer ;               // low and high bound of data
  nIndex: Integer ;
  nFwhmCount: Integer;
  nPeakIndex, nFwhmRightIndex, nFwhmLeftIndex: Integer;
  bFound: Boolean;
  nNoOfFwhmDataPoints: Integer;
  fLeftEndPointCount, fRightEndPointCount: Double;
  fBaselineSlope, fBaseline: Double;
  fMax : Double;
  fHalfMax: Double;
  fIntensity: Double;
  nFinalFwhmLeftIndex, nFinalFwhmRightIndex: Integer;
  fFinalFwhmLeftIndex, fFinalFwhmRightIndex: Single;
  fIntensityOfRightFWHM, fIntensityofLeftFWHM: Double;
  MinValue, MaxValue: Single;
begin
  LowBound := Low(DataArray) ;
  HighBound := High(DataArray) ;

  // find max and min
  MinValue := DataArray[LowBound] ;
  MaxValue := DataArray[LowBound];
  nPeakIndex := LowBound;
  FWHM := 0.0;

  for nIndex := LowBound+1 to HighBound do
  begin
    if (DataArray[nIndex] < MinValue) then
    begin
      MinValue := DataArray[nIndex] ;
    end ;

    if (DataArray[nIndex] > MaxValue) then
    begin
      MaxValue := DataArray[nIndex] ;
      nPeakIndex := nIndex;
    end ;
  end;

  // half the number of counts of the peak
  nFwhmCount := Round(MaxValue - (MaxValue - MinValue) * 0.5);

  // find right point of FWHM line (in first scan, don't worry about background subtraction)
  bFound := false;
  nFwhmRightIndex := nPeakIndex;
  nIndex := nPeakIndex + 1;
  while (not bFound) and (nIndex <= HighBound) do
  begin
    if (DataArray[nIndex] < nFwhmCount) then
    begin
      nFwhmRightIndex := nIndex;
      bFound := true;
    end ;

    Inc(nIndex);
  end;

  // find left point of FWHM line (in first scan, don't worry about background subtraction)
  bFound := false;
  nFwhmLeftIndex := nPeakIndex;
  nIndex := nPeakIndex - 1;
  while (not bFound) and (nIndex >= LowBound) do
  begin
    if (DataArray[nIndex] < nFwhmCount) then
    begin
      nFwhmLeftIndex := nIndex;
      bFound := true;
    end ;

    Dec(nIndex);
  end;

  // zoom into a smaller section of the data around peak
  nNoOfFwhmDataPoints := (nFwhmRightIndex - nFwhmLeftIndex + 1) * 2;

  // adjust right and left indicies to include more points around peak
  nFwhmRightIndex := nPeakIndex + nNoOfFwhmDataPoints;
  if (nFwhmRightIndex > HighBound) then
    nFwhmRightIndex := HighBound;

  nFwhmLeftIndex := nPeakIndex - nNoOfFwhmDataPoints;
  if (nFwhmLeftIndex < LowBound) then
    nFwhmLeftIndex := LowBound;

  if (nFwhmRightIndex - nFwhmLeftIndex + 1 > 4) then
  begin
    // end points of baseline
    fRightEndPointCount := DataArray[nFwhmRightIndex];
    fLeftEndPointCount := DataArray[nFwhmLeftIndex];

    // calculate slope of baseline (increment/decrement of background per data point)
    fBaselineSlope := (fRightEndPointCount - fLeftEndPointCount) / (nFwhmRightIndex - nFwhmLeftIndex + 1) ;

    // determine peak height
    fBaseline := fLeftEndPointCount;
    fMax := 0.0;
    nPeakIndex := nFwhmLeftIndex;
    for nIndex := nFwhmLeftIndex to nFwhmRightIndex do
    begin
      if (DoBackgroundSubtraction) then
        // subtract background
        fIntensity := DataArray[nIndex] - fBaseline
      else
        fIntensity := DataArray[nIndex];

      if (fIntensity > fMax) then
      begin
        fMax := fIntensity;
        nPeakIndex := nIndex;
      end;

      fBaseline := fBaseline + fBaselineSlope;
    end;

    // determine right FWHM point
    fBaseline := fBaselineSlope * (nPeakIndex - nFwhmLeftIndex) + fLeftEndPointCount;
    fHalfMax := fMax / 2.0;
    bFound := false;
    nIndex := nPeakIndex;
    nFinalFwhmRightIndex := nFwhmRightIndex;
    fFinalFwhmRightIndex := nFinalFwhmRightIndex;
    while (not bFound) and (nIndex <= nFwhmRightIndex) do
    begin
      if (DoBackgroundSubtraction) then
        // subtract background
        fIntensity := DataArray[nIndex] - fBaseline
      else
        fIntensity := DataArray[nIndex];

      if (bIsEffectivelyLTE(fIntensity, fHalfMax)) then
      begin
        bFound := true;

        // step back one
        nFinalFwhmRightIndex := nIndex - 1;

        // can't go pass peak index
        if (nFinalFwhmRightIndex < nPeakIndex) then
        begin
          nFinalFwhmRightIndex := nPeakIndex;
        end;

        if (DoBackgroundSubtraction) then
          fIntensityOfRightFWHM := DataArray[nFinalFwhmRightIndex] - fBaseline
        else
          fIntensityOfRightFWHM := DataArray[nFinalFwhmRightIndex];

        if (not bEffectivelyEquals(fIntensityOfRightFWHM, fIntensity)) then
          fFinalFwhmRightIndex := (fHalfMax - fIntensityOfRightFWHM) / (fIntensity - fIntensityOfRightFWHM) + nFinalFwhmRightIndex;
      end
      else  // not found
      begin
        fBaseline := fBaseline + fBaselineSlope;
        Inc(nIndex);
      end;
    end;

    // determine left FWHM point
    fBaseline := fBaselineSlope * (nPeakIndex - nFwhmLeftIndex) + fLeftEndPointCount;
    bFound := false;
    nIndex := nPeakIndex;
    nFinalFwhmLeftIndex := nFwhmLeftIndex;
    fFinalFwhmLeftIndex := nFinalFwhmLeftIndex;
    while (not bFound) and (nIndex >= nFwhmLeftIndex) do
    begin
      if (DoBackgroundSubtraction) then
        // subtract background
        fIntensity := DataArray[nIndex] - fBaseline
      else
        fIntensity := DataArray[nIndex];

      if (bIsEffectivelyLTE(fIntensity, fHalfMax)) then
      begin
        bFound := true;

        nFinalFwhmLeftIndex := nIndex;

        // can't go pass peak index
        if (nFinalFwhmLeftIndex > nPeakIndex) then
        begin
          nFinalFwhmLeftIndex := nPeakIndex;
        end;

        if (DoBackgroundSubtraction) then
          fIntensityOfLeftFWHM := DataArray[nFinalFwhmLeftIndex+1] - fBaseline
        else
          fIntensityOfLeftFWHM := DataArray[nFinalFwhmLeftIndex+1];

        if (not bEffectivelyEquals(fIntensityOfLeftFWHM, fIntensity)) then
          fFinalFwhmLeftIndex := (fHalfMax - fIntensity) / (fIntensityOfLeftFWHM - fIntensity) + nFinalFwhmLeftIndex;
      end
      else   // not found
      begin
        fBaseline := fBaseline - fBaselineSlope;
        Dec(nIndex);
      end;
    end;

    FWHM := (fFinalFwhmRightIndex - fFinalFwhmLeftIndex) * StepSizeInV;

    FWHMMidpointIndex := Round((fFinalFwhmRightIndex + fFinalFwhmLeftIndex) / 2 );
    if (FWHMMidpointIndex > HighBound) then
      FWHMMidpointIndex := HighBound;
    if (FWHMMidpointIndex < LowBound) then
      FWHMMidpointIndex := LowBound;

    FWHMMidpointIntensity := DataArray[FWHMMidpointIndex];

    if (FWHM < 0.0) then
    begin
      LogTraceMsg('FindFWHM', tNoTrace, 'FWHM is -ve: right=' + FloatToStr(fFinalFwhmRightIndex) + ' left=' +
        FloatToStr(fFinalFwhmLeftIndex) + ' peak=' + IntToStr(nPeakIndex));
      FWHM := 0.0;
    end;
  end;

end;

function BinarySearch(const Data: OleVariant; ValueToSearch: Double): Integer;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Perform a binary search
// Inputs:      Data - an ole variant array of double
//              ValuesToSearch - value to search
// Outputs:     None
// Return:      Index of value to search
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  DividerIndex, LowIndex, HighIndex: Integer ;
  DataHighBound, DataLowBound, SwapTemp: Integer ;   // low and high bound of data
begin
  assert(VarType(Data) = (VT_ARRAY + VT_R8)) ;

  DataLowBound := VarArrayLowBound(Data, 1) ;
  DataHighBound := VarArrayHighBound(Data, 1) ;

  // Swap bounds indexes if data is decending
  if (Data[DataLowBound] > Data[DataHighBound]) then
  begin
     SwapTemp := DataHighBound ;
     DataHighBound := DataLowBound ;
     DataLowBound := SwapTemp ;
  end;

  if (ValueToSearch <= Data[DataLowBound]) then
    Result := DataLowBound
  else if (ValueToSearch >= Data[DataHighBound]) then
    Result := DataHighBound
  else
  begin
    LowIndex := DataLowBound ;
    HighIndex := DataHighBound ;
    DividerIndex := (DataHighBound + DataLowBound) shr 1 ;

    while ((DividerIndex <> LowIndex) and (DividerIndex <> HighIndex)) do
    begin
      if (ValueToSearch > Data[DividerIndex]) then
        LowIndex := DividerIndex
      else
        HighIndex := DividerIndex ;

      DividerIndex := (LowIndex + HighIndex) shr 1 ;
    end;

    // return index of closest value
    if (Data[HighIndex] - ValueToSearch) < (ValueToSearch - Data[LowIndex]) then
      Result := HighIndex + 1
    else
      Result := LowIndex + 1 ;

  end ;
end;

function BinarySearch(const Data: Array of Single; ValueToSearch: Double): Integer;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Perform a binary search
// Inputs:      Data - an ole variant array of double
//              ValuesToSearch - value to search
// Outputs:     None
// Return:      Index of value to search
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
var
  DividerIndex, LowIndex, HighIndex: Integer ;
  DataHighBound, DataLowBound, SwapTemp: Integer ;   // low and high bound of data
begin
  DataLowBound := 0;
  DataHighBound := Length(Data)-1 ;

  // Swap bounds indexes if data is decending
  if (Data[DataLowBound] > Data[DataHighBound]) then
  begin
     SwapTemp := DataHighBound ;
     DataHighBound := DataLowBound ;
     DataLowBound := SwapTemp ;
  end;

  if (ValueToSearch <= Data[DataLowBound]) then
    Result := DataLowBound
  else if (ValueToSearch >= Data[DataHighBound]) then
    Result := DataHighBound
  else
  begin
    LowIndex := DataLowBound ;
    HighIndex := DataHighBound ;
    DividerIndex := (DataHighBound + DataLowBound) shr 1 ;

    while ((DividerIndex <> LowIndex) and (DividerIndex <> HighIndex)) do
    begin
      if (ValueToSearch > Data[DividerIndex]) then
        LowIndex := DividerIndex
      else
        HighIndex := DividerIndex ;

      DividerIndex := (LowIndex + HighIndex) shr 1 ;
    end;

    // return index of closest value
    if (Data[HighIndex] - ValueToSearch) < (ValueToSearch - Data[LowIndex]) then
    begin
      Result := HighIndex;
    end
    else
    begin
      Result := LowIndex;
    end;

  end;
end;

function bEffectivelyEquals(F1: Double; F2: Double): Boolean;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the two given doubles are effectively equal
//
//
// Inputs: F1, F2 - the two numbers to compare
//
//
// Return: True if effectively equals
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := bEffectivelyEquals(F1, F2, c_fDefaultDoubleEpsilon);
end;

function bEffectivelyEquals(F1: Double; F2: Double; fEpsilon: Double): Boolean;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the two given doubles are effectively equal
//
//
// Inputs: F1, F2 - the two numbers to compare
//         fEpsilon - how much can the two numbers differ
//
//
// Return: True if effectively equals
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := Abs(F2-F1) < fEpsilon;
end;

function bEffectivelyEquals(F1: Single; F2: Single): Boolean; overload;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the two given singles are effectively equal
//
//
// Inputs: F1, F2 - the two numbers to compare
//
//
// Return: True if effectively equals
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := bEffectivelyEquals(F1, F2, c_fDefaultSingleEpsilon);
end;

function bEffectivelyEquals(F1: Single; F2: Single; fEpsilon: Single): Boolean; overload;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the two given singles are effectively equal
//
//
// Inputs: F1, F2 - the two numbers to compare
//         fEpsilon - how much can the two numbers differ
//
//
// Return: True if effectively equals
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := Abs(F2-F1) < fEpsilon;
end;

function bIsEffectivelyGTE(fValue: Double; fMinValue: Double): Boolean;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given value is greater than or 'close enough'
//               to be equal to the given minimum value.
//
//
// Inputs:
//   fValue - the value to compare
//   fMinValue - minimum value that fValue is GTE
//
//
// Return: True if effectively greater than or 'close enough' to be equal
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := bIsEffectivelyGTE(fValue, fMinValue, c_fDefaultDoubleEpsilon);
end;

function bIsEffectivelyGTE(fValue: Double; fMinValue: Double; fEpsilon: Double): Boolean;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given value is greater than or 'close enough'
//               to be equal to the given minimum value.
//
//
// Inputs:
//   fValue - the value to compare
//   fMinValue - minimum value that fValue is GTE
//   fEpsilon - the epsilon to determine whether 'close enough' to be equal
//
//
// Return: True if effectively greater than or 'close enough' to be equal
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := (fMinValue - fValue) < fEpsilon;
end;

function bIsEffectivelyGTE(fValue: Single; fMinValue: Single): Boolean; overload;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given value is greater than or 'close enough'
//               to be equal to the given minimum value.
//
//
// Inputs:
//   fValue - the value to compare
//   fMinValue - minimum value that fValue is GTE
//
//
// Return: True if effectively greater than or 'close enough' to be equal
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := bIsEffectivelyGTE(fValue, fMinValue, c_fDefaultSingleEpsilon);
end;

function bIsEffectivelyGTE(fValue: Single; fMinValue: Single; fEpsilon: Single): Boolean; overload;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given value is greater than or 'close enough'
//               to be equal to the given minimum value.
//
//
// Inputs:
//   fValue - the value to compare
//   fMinValue - minimum value that fValue is GTE
//   fEpsilon - the epsilon to determine whether 'close enough' to be equal
//
//
// Return: True if effectively greater than or 'close enough' to be equal
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := (fMinValue - fValue) < fEpsilon;
end;

function bIsEffectivelyLTE(fValue: Double; fMaxValue: Double): Boolean;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given value is less than or 'close enough'
//               to be equal to the given maximum value.
//
//
// Inputs:
//   fValue - the value to compare
//   fMaxValue - maximum value that fValue is LTE
//
//
// Return: True if effectively less than or 'close enough' to be equal
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := bIsEffectivelyLTE(fValue, fMaxValue, c_fDefaultDoubleEpsilon);
end;

function bIsEffectivelyLTE(fValue: Double; fMaxValue: Double; fEpsilon: Double): Boolean;
/////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given value is less than or 'close enough'
//               to be equal to the given maximum value.
//
//
// Inputs:
//   fValue - the value to compare
//   fMaxValue - maximum value that fValue is LTE
//   fEpsilon - the epsilon to determine whether 'close enough' to be equal
//
//
// Return: True if effectively less than or 'close enough' to be equal
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := (fValue - fMaxValue) < fEpsilon;
end;

function bIsEffectivelyLTE(fValue: Single; fMaxValue: Single): Boolean; overload;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given value is less than or 'close enough'
//               to be equal to the given maximum value.
//
//
// Inputs:
//   fValue - the value to compare
//   fMaxValue - maximum value that fValue is LTE
//
//
// Return: True if effectively less than or 'close enough' to be equal
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := bIsEffectivelyLTE(fValue, fMaxValue, c_fDefaultSingleEpsilon);
end;

function bIsEffectivelyLTE(fValue: Single; fMaxValue: Single; fEpsilon: Single): Boolean; overload;
/////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given value is less than or 'close enough'
//               to be equal to the given maximum value.
//
//
// Inputs:
//   fValue - the value to compare
//   fMaxValue - maximum value that fValue is LTE
//   fEpsilon - the epsilon to determine whether 'close enough' to be equal
//
//
// Return: True if effectively less than or 'close enough' to be equal
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := (fValue - fMaxValue) < fEpsilon;
end;

function bIsEffectivelyZero(fValue: Double): Boolean;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the two given doubles are effectively equal
//
//
// Inputs: F1, F2 - the two numbers to compare
//
//
// Return: True if effectively equals
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := bIsEffectivelyZero(fValue, c_fDefaultDoubleEpsilon);
end;

function bIsEffectivelyZero(fValue: Double; fEpsilon: Double): Boolean;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given double is effectively zero
//
//
// Inputs: fValue - value to check
//         fEpsilon - how far off can the value is from zero
//
//
// Return: True if effectively equals
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := Abs(fValue) < fEpsilon;
end;

function bIsEffectivelyZero(fValue: Single): Boolean; overload;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given single is effectively zero
//
//
// Inputs: fValue - value to check
//
//
// Return: True if effectively equals
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := bIsEffectivelyZero(fValue, c_fDefaultSingleEpsilon);
end;

function bIsEffectivelyZero(fValue: Single; fEpsilon: Single): Boolean; overload;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given single is effectively zero
//
//
// Inputs: fValue - value to check
//         fEpsilon - how far off can the value is from zero
//
//
// Return: True if effectively equals
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := Abs(fValue) < fEpsilon;
end;

function bIsEffectivelyInRange(fMin: Double; fValue: Double; fMax: Double): Boolean;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given single is effectively in the given range
//               inclusively.
//
//
// Inputs: fValue - value to check
//         fMin, fMax - define the range
//
//
// Return: True if effectively in range.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := bIsEffectivelyInRange(fMin, fValue, fMax, c_fDefaultDoubleEpsilon);
end;

function bIsEffectivelyInRange(fMin: Double; fValue: Double; fMax: Double; fEpsilon: Double): Boolean;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given single is effectively in the given range
//               inclusively.
//
//
// Inputs: fValue - value to check
//         fMin, fMax - define the range
//         fEpsilon - how far off can the value is from zero
//
//
// Return: True if effectively in range.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  if (fMax < fMin) then
    // be little bit more forgiving and flip the min and max if reversed
    Result := bIsEffectivelyInRange(fMax, fValue, fMin, fEpsilon)
  else
  begin
    Result := bIsEffectivelyGTE(fValue, fMin, fEpsilon) and
              bIsEffectivelyLTE(fValue, fMax, fEpsilon);
  end;
end;

function bIsEffectivelyInRange(fMin: Single; fValue: Single; fMax: Single): Boolean;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given double is effectively in the given range
//               inclusively.
//
//
// Inputs: fValue - value to check
//         fMin, fMax - define the range
//
//
// Return: True if effectively in range.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  Result := bIsEffectivelyInRange(fMin, fValue, fMax, c_fDefaultSingleEpsilon);
end;

function bIsEffectivelyInRange(fMin: Single; fValue: Single; fMax: Single; fEpsilon: Single): Boolean;
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Check if the given double is effectively in the given range
//               inclusively.
//
//
// Inputs: fValue - value to check
//         fMin, fMax - define the range
//         fEpsilon - how far off can the value is from zero
//
//
// Return: True if effectively in range.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  if (fMax < fMin) then
    // be little bit more forgiving and flip the min and max if reversed
    Result := bIsEffectivelyInRange(fMax, fValue, fMin, fEpsilon)
  else
  begin
    Result := bIsEffectivelyGTE(fValue, fMin, fEpsilon) and
              bIsEffectivelyLTE(fValue, fMax, fEpsilon);
  end;
end;

procedure FindMin(const DataArray: array of Double; out fMinValue: Double; out nIndexOfMinValue: Integer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Find the index and value for the item in the given array that
//                has the minimum value.   If more than one item has the same
//                minimum value, the index of the first item is returned.
//
//
// Inputs: DataArray - a dynamic array of double
//         fMinValue - minimum value found
//         nIndexOfMinValue - index of the first item with the minimum value.
//
//
// Note: In Pascal, the starting index of an array doesn't need to start from 0.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  DataIndex: Integer;
begin
  assert(Length(DataArray) > 0);

  nIndexOfMinValue := Low(DataArray);        // starting index of the array
  fMinValue := DataArray[nIndexOfMinValue];
  for DataIndex := Low(DataArray) + 1 to High(DataArray) do
  begin
    if (DataArray[DataIndex] < fMinValue) then
    begin
      // find something smaller
      nIndexOfMinValue := DataIndex;
      fMinValue := DataArray[DataIndex];
    end;
  end;
end;

procedure FindMin(const DataArray: array of Single; out fMinValue: Single; out nIndexOfMinValue: Integer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Find the index and value for the item in the given array that
//                has the minimum value.   If more than one item has the same
//                minimum value, the index of the first item is returned.
//
//
// Inputs: DataArray - a dynamic array of singles
//         fMinValue - minimum value found
//         nIndexOfMinValue - index of the first item with the minimum value.
//
//
// Note: In Pascal, the starting index of an array doesn't need to start from 0.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  DataIndex: Integer;
begin
  assert(Length(DataArray) > 0);

  nIndexOfMinValue := Low(DataArray);        // starting index of the array
  fMinValue := DataArray[nIndexOfMinValue];
  for DataIndex := Low(DataArray) + 1 to High(DataArray) do
  begin
    if (DataArray[DataIndex] < fMinValue) then
    begin
      // find something smaller
      nIndexOfMinValue := DataIndex;
      fMinValue := DataArray[DataIndex];
    end;
  end;
end;

procedure FindMax(const DataArray: array of Double; out fMaxValue: Double; out nIndexOfMaxValue: Integer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Find the index and value for the item in the given array that
//                has the maximum value.   If more than one item has the same
//                maximum value, the index of the first item is returned.
//
//
// Inputs: DataArray - a dynamic array of double
//         fMaxValue - maximum value found
//         nIndexOfMaxValue - index of the first item with the maximum value.
//
//
// Note: In Pascal, the starting index of an array doesn't need to start from 0.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  DataIndex: Integer;
begin
  assert(Length(DataArray) > 0);

  nIndexOfMaxValue := Low(DataArray);        // starting index of the array
  fMaxValue := DataArray[nIndexOfMaxValue];
  for DataIndex := Low(DataArray) + 1 to High(DataArray) do
  begin
    if (DataArray[DataIndex] > fMaxValue) then
    begin
      // find something bigger
      nIndexOfMaxValue := DataIndex;
      fMaxValue := DataArray[DataIndex];
    end;
  end;
end;

procedure FindMax(const DataArray: array of Single; out fMaxValue: Single; out nIndexOfMaxValue: Integer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Find the index and value for the item in the given array that
//                has the maximum value.   If more than one item has the same
//                maximum value, the index of the first item is returned.
//
//
// Inputs: DataArray - a dynamic array of singles
//         fMaxValue - maximum value found
//         nIndexOfMaxValue - index of the first item with the maximum value.
//
//
// Note: In Pascal, the starting index of an array doesn't need to start from 0.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  DataIndex: Integer;
begin
  assert(Length(DataArray) > 0);

  nIndexOfMaxValue := Low(DataArray);        // starting index of the array
  fMaxValue := DataArray[nIndexOfMaxValue];
  for DataIndex := Low(DataArray) + 1 to High(DataArray) do
  begin
    if (DataArray[DataIndex] > fMaxValue) then
    begin
      // find something bigger
      nIndexOfMaxValue := DataIndex;
      fMaxValue := DataArray[DataIndex];
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Convert a pressure value in Torr to its equivalent value in
//               Pascals. Return Pascals value.
// Inputs:       None
// Outputs:      Single
// Note:
////////////////////////////////////////////////////////////////////////////////
function ConvertTorrToPascal(PressureInTorr : Double): Double;
begin
  // Torr to Pascals conversion
  Result := (PressureInTorr * c_TorrToPascalFactor);

end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Convert a pressure value in Pascal to its equivalent value in
//               Torr.
// Inputs:       PressureInPa - the pressure in pascal to be converted
// Outputs:      Single
// Return:       the converted pressure in Torr
////////////////////////////////////////////////////////////////////////////////
function ConvertPascalToTorr(PressureInPa : Single): Single;
begin
  // Pascals to Torr conversion
  Result := (PressureInPa * c_PascalToTorrFactor) ;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Convert a pressure value in Torr to its equivalent value in
//               Pascals.
// Inputs:       PressureInTorr - the pressure in Torr to be converted
// Outputs:      None
// Return:       The converted pressure in Pascal
////////////////////////////////////////////////////////////////////////////////
function ConvertTorrToPascal(PressureInTorr : Single): Single;
begin
  // Torr to Pascals conversion
  Result := (PressureInTorr * c_TorrToPascalFactor);
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Convert a pressure value in Pascals to its equivalent value in
//               Torr. Return Pascals value.
// Inputs:       None
// Outputs:      Single
// Note:
////////////////////////////////////////////////////////////////////////////////
function ConvertPascalToTorr(PressureInPa : Double): Double;
begin
  // Pascals to Torr conversion
  Result := (PressureInPa * c_PascalToTorrFactor) ;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Return floor of value given after adding some small tolerance
//               value to avoid truncating to an inteded value that is just
//               slightly off due to floating point representation.
//               (ie. 5.9999997 vs 6.0)
// Inputs:       fValue - Value to modify, then get floor of
//               fEpsilon - amount to add to fValue before getting floor
// Outputs:      Integer - floored value
// Note:
////////////////////////////////////////////////////////////////////////////////
function FloorMod(fValue: Extended): Integer;
begin
  // Add the tolerance value to value passed in, then floor it.
  Result := floor(fValue + c_fDefaultSingleEpsilon);
end;
function FloorMod(fValue: Extended; fEpsilon: Single): Integer; overload;
begin
  // Add the tolerance value to value passed in, then floor it.
  Result := floor(fValue + fEpsilon);
end;
function FloorMod(fValue: Extended; fEpsilon: Double): Integer; overload;
begin
  // Add the tolerance value to value passed in, then floor it.
  Result := floor(fValue + fEpsilon);
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Do n point diff on the given data
// Inputs:       Data - data to diff
//               nStartIndex - start index of the data to look at
//               nNoOfDiffPoints - number of derivative
// Outputs:      dDiff - differentiated value
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure dif_buff(
  Data: array of Double;
  nStartIndex: Integer;
  nNoOfDiffPoints: Integer;
  out dDiff: Double
);
var
  nMid, nOffset: Integer;
  dX: Double;
begin
  dX := 0.0;
  dDiff := 0.0;

  nMid := FloorMod((nNoOfDiffPoints - 1) / 2);
  for nOffset := 1 to nMid do
  begin
    dX := dX + 1.0;
    dDiff := dDiff + dX * (Data[nStartIndex+nMid+nOffset] - Data[nStartIndex+nMid-nOffset]);
  end;

  dDiff := dDiff / c_YNorms[nMid];

end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Check the min/max values against the new calculated value
// Inputs:       dValue - value to check against min and max
//               nNoOfDiffPoints - number of derivative
// Outputs:      dDiff - diff value
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure dif_min_max(
  var dValue: Double;
  var dMinValue: Double;
  var dMaxValue: Double
);
begin
  if (dValue > MaxSingle) then
    dValue := MaxSingle;
  if (dValue < -MaxSingle) then
    dValue := -MaxSingle;

  if (dValue < dMinValue) then
    dMinVAlue := dValue;

  if (dValue > dMaxValue) then
    dMaxValue := dValue;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description: Differentiate and normalize data.
// Inputs:      nNoOfPointDerivative - how many points of derivative
//              fStepSize - step size
//              Data - an ole variant array of double
//              nStartDataIndex - starting index to do derivative and normalize
//              nEndDataIndex - ending index to to do derivative and normalize
// Outputs:     dMaxValue, dMinValue - min and max values of data after differentiation and normalization
//              Data - differentiated data
//
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure DifferentiateNormalize(
  nNoOfPointDerivative: Integer;
  fStepSize: Single;
  nStartDataIndex: Integer;
  nEndDataIndex: Integer;
  var Data: OleVariant;
  out dMaxValue: Double;
  out dMinValue: Double
);
var
  nDataIndex, nDataHighBound, nDataLowBound: Integer;
  pData : PDataDoubleArray ;
  nNoOfDiffPoints: Integer;
  dNormalizeFactor: Double;
  dValue: Double;
  k: Integer;
begin
  dMaxValue := 0.0;
  dMinValue := 0.0;

  // Verify the variant type
  if (VarType(Data) <> VT_ARRAY + VT_R8) then
  begin
    raise EPhiSoftware.Create('PhiMath', errorNormal,
        'Unexpected variant type in DifferentiateNormalize',
        E_UNEXPECTED, '', '', 0);
  end;

  try
    try
      if (fStepSize < 1.0) then
      begin
        k := Round(1.0 / fStepSize);
        nNoOfDiffPoints := k * (nNoOfPointDerivative - 1) + 1;
      end
      else
      begin
        k := Round(fStepSize);
        nNoOfDiffPoints := FloorMod((nNoOfPointDerivative + k - 1) / k);
      end;

      // make sure it's within limits
      if (nNoOfDiffPoints < 3) then
        nNoOfDiffPoints := 3
      else if (nNoOfDiffPoints > 49) then
        nNoOfDiffPoints := 49;

      // differentiate data
      Differentiate(nNoOfDiffPoints, nStartDataIndex, nEndDataIndex, Data, dMaxValue, dMinValue);

      // normalize data
      dNormalizeFactor := 1.0 / fStepSize;

      nDataHighBound := VarArrayHighBound(Data, 1);
      nDataLowBound  := VarArrayLowBound(Data, 1);

      // adjust nDataHighBound and nDataLowBound
      nDataHighBound := Min(nDataHighBound, nDataLowBound+nEndDataIndex);
      nDataLowBound := nDataLowBound + nStartDataIndex;

      // Use VarArrayLock to improve performance
      pData := VarArrayLock(Data);

      for nDataIndex := nDataLowBound to nDataHighBound do
      begin
        dValue := pData^[nDataIndex] * dNormalizeFactor;
        if (dValue < -MaxSingle) then
          dValue := -MaxSingle
        else if (dValue > MaxSingle) then
          dValue := MaxSingle;
        pData^[nDataIndex] := dValue;
      end;

      // check max value
      dValue := dMaxValue * dNormalizeFactor;
      if (dValue < -MaxSingle) then
        dValue := -MaxSingle
      else if (dValue > MaxSingle) then
        dValue := MaxSingle;
      dMaxValue := dValue;

      // check min value
      dValue := dMinValue * dNormalizeFactor;
      if (dValue < -MaxSingle) then
        dValue := -MaxSingle
      else if (dValue > MaxSingle) then
        dValue := MaxSingle;
      dMinValue := dValue;

    except
      on E: Exception do
        raise EPhiSoftware.Create('PhiMath', errorNormal,
          'Exception in DifferentiateNormalize',
          E_UNEXPECTED, '', '', 0);
    end;
  finally
    VarArrayUnlock(Data);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Differentiate the given data
// Inputs:       nNoOfDiffPoints - number of point derivative
//               nStartDataIndex, nStartDataIndex - range of data to differentiate
//               Data - data of type Double
// Outputs:      dMaxValue, dMinValue - max and min values of data after differentiation
//               Data - data after differentiation
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure Differentiate(
  nNoOfDiffPoints: Integer;
  nStartDataIndex: Integer;
  nEndDataIndex: Integer;
  var Data: OleVariant;
  out dMaxValue: Double;
  out dMinValue: Double
);
var
  nDataIndex, nDataHighBound, nDataLowBound: Integer;
  pData : PDataDoubleArray ;
  nNoOfPoints: Integer;
  OriginalData: array of Double;    // copy of original data as Data is differentiated and udpated
  nTempIndex: Integer;
  nMid: Integer;
  nDiffPts: Integer;
  dDiff: Double;
begin
  // Verify the variant type
  if (VarType(Data) <> VT_ARRAY + VT_R8) then
  begin
    raise EPhiSoftware.Create('PhiMath', errorNormal,
        'Unexpected variant type in Differentiate',
        E_UNEXPECTED, '', '', 0);
  end;

  try
    nDataHighBound := VarArrayHighBound(Data, 1);
    nDataLowBound  := VarArrayLowBound(Data, 1);

    // adjust nDataHighBound and nDataLowBound
    nDataHighBound := Min(nDataHighBound, nDataLowBound+nEndDataIndex);
    nDataLowBound := nDataLowBound + nStartDataIndex;

    // Use VarArrayLock to improve performance
    pData := VarArrayLock(Data);

    // allocate memory for differentiated data
    nNoOfPoints := nDataHighBound - nDataLowBound + 1;
    SetLength(OriginalData, nNoOfPoints);

    for nDataIndex := nDataLowBound to nDataHighBound do
    begin
      OriginalData[nDataIndex-nDataLowBound] := pData^[nDataIndex] * 100.0;
    end;

    dMaxValue := -MaxSingle;
    dMinValue := MaxSingle;
    nMid := FloorMod((nNoOfDiffPoints - 1) / 2);

    // variable point on beginning points
    nTempIndex := 0;      // which data to start looking at
    nDataIndex := 1;      // first data to fill in is second data point
    nDiffPts := 3;
    while (nDiffPts < nNoOfDiffPoints) do
    begin
      dif_buff(OriginalData, nTempIndex, nDiffPts, dDiff);
      dif_min_max(dDiff, dMinValue, dMaxValue);
      pData^[nDataIndex] := Round(dDiff);

      Inc(nDataIndex);
      Inc(nDiffPts, 2);
    end;

    // fixed diff on middle points
    nTempIndex := nDataIndex - nMid;
    while (nTempIndex < (nNoOfPoints-nNoOfDiffPoints)) do
    begin
      dif_buff(OriginalData, nTempIndex, nNoOfDiffPoints, dDiff);
      dif_min_max(dDiff, dMinValue, dMaxValue);
      pData^[nDataIndex] := Round(dDiff);

      Inc(nDataIndex);
      Inc(nTempIndex);
    end;

    // variable point on beginning points
    nDiffPts := nNoOfDiffPoints;
    while (nDataIndex < nNoOfPoints-1) do
    begin
      dif_buff(OriginalData, nTempIndex, nDiffPts, dDiff);
      dif_min_max(dDiff, dMinValue, dMaxValue);
      pData^[nDataIndex] := Round(dDiff);

      Inc(nDataIndex);
      Dec(nDiffPts, 2);
      Inc(nTempIndex, 2);
    end;

    // do last point and first point
    pData^[nNoOfPoints-1] := pData^[nNoOfPoints-2];
    pData^[0] := pData^[1];

  finally
    VarArrayUnlock(Data);
  end;
end;


procedure SmoothData(
  nNoOfDataPoints: Integer;
  nNoOfSmoothPoints: Integer;
  var Data: OleVariant;
  var dMinDataVal: Double;
  var dMaxDataVal: Double;
  var nMinDataIndex: Integer;
  var nMaxDataIndex: Integer
);
////////////////////////////////////////////////////////////////////////////////
// Description:  Performs an n-pt smooth on data array given.
//
// Inputs:       nNoOfDataPoints - Number of pts contained in Data array.
//               nNoOfSmoothPoints - number-pt-smooth.
//               Data - An olevariant of data of type Double
//
// Outputs:      dMinDataVal - Min smoothed value found in data during smooth
//               dMaxDataVal - Max smoothed value found in data during smooth
//               nMinDataIndex, nMaxDataIndex - indicies of max and min values
//
// result:       None.
////////////////////////////////////////////////////////////////////////////////
var
  fTempPtHolder: array[0..24] of Double;
  dSmoothVal: Double;
  nIndex, nMid, nOffset, nCoeffIndex, nTempIndex: Integer;  // Indexes
  pData: pDataDoubleArray;
begin
  // Verify the variant type
  if (VarType(Data) <> VT_ARRAY + VT_R8) then
  begin
    raise EPhiSoftware.Create('PhiMath', errorNormal,
        'Unexpected variant type in SmoothData()',
        E_UNEXPECTED, '', '', 0);
  end;

  try
    try
      pData := VarArrayLock(Data);

      // Subtract one from our num pts and num pts to smooth for zero indexing
      nNoOfDataPoints := nNoOfDataPoints - 1;
      nNoOfSmoothPoints := nNoOfSmoothPoints - 1;

      // Index to Data and nTempPtHolder, always truncate midpoint value down
      nMid := Trunc(nNoOfSmoothPoints/2);

      // Buffer the first nMid places with Data[0] in temp pt holder
      for nIndex := 0 to nMid do
        fTempPtHolder[nIndex] := pData^[0];

      // Fill next mid-1 points of temp pt holder with Data[1] - Data[mid-1]
      for nIndex := 1 to nMid - 1 do
        fTempPtHolder[nIndex + nMid] := pData^[nIndex];

      // Set coefficient index
      nCoeffIndex := 0;
      for nIndex := 1 to nMid do
        nCoeffIndex := nCoeffIndex + nIndex;

      // Calculate smooth value for first point
      nIndex := 0;
      fTempPtHolder[nNoOfSmoothPoints] := pData^[nIndex + nMid];
      dSmoothVal := fTempPtHolder[nMid] * c_nSmoothCoeffArray[nCoeffIndex];
      for nOffset := 1 to nMid do
        dSmoothVal := dSmoothVal + c_nSmoothCoeffArray[nCoeffIndex + nOffset] *
                (fTempPtHolder[nMid + nOffset] + fTempPtHolder[nMid - nOffset]);
      dSmoothVal := dSmoothVal / c_fSmoothXNormArray[nMid];

      // Smooth value must be at least 0
      if (dSmoothVal < 0) then
        dSmoothVal := 0.0;

      // Mindata, maxdata start as first point smoothed value
      dMinDataVal := dSmoothVal;
      dMaxDataVal := dSmoothVal;
      pData^[nIndex] := dSmoothVal;  // put result into Data[nIndex] (still zero)

      // Shift temp values
      for nTempIndex := 0 to nNoOfSmoothPoints - 1 do
         fTempPtHolder[nTempIndex] := fTempPtHolder[nTempIndex + 1];

      // Calculate smooth value for each point
      for nIndex := 1 to nNoOfDataPoints do
      begin
        if ((nIndex + nMid) <= nNoOfDataPoints) then
          fTempPtHolder[nNoOfSmoothPoints] := pData^[nIndex + nMid];
        dSmoothVal :=  fTempPtHolder[nMid] * c_nSmoothCoeffArray[nCoeffIndex];
        for nOffset := 1 to nMid do
          dSmoothVal := dSmoothVal + c_nSmoothCoeffArray[nCoeffIndex + nOffset] *
              (fTempPtHolder[nMid + nOffset] + fTempPtHolder[nMid - nOffset]);
        dSmoothVal := dSmoothVal / c_fSmoothXNormArray[nMid];


        // Update min and max smoothed values and indexes
        if (dSmoothVal < dMinDataVal) then
        begin
          if (dSmoothVal < 0) then
            dSmoothVal := 0;
          dMinDataVal := dSmoothVal;
          nMinDataIndex := nIndex;
        end;
        if (dSmoothVal > dMaxDataVal) then
        begin
          dMaxDataVal := dSmoothVal;
          nMaxDataIndex := nIndex;
        end;

        // Put smoothed value into Data array
        pData^[nIndex] := dSmoothVal;

        // Shift temp values
        for nTempIndex := 0 to nNoOfSmoothPoints - 1 do
          fTempPtHolder[nTempIndex] := fTempPtHolder[nTempIndex + 1];
      end;

    except
      on E: Exception do
      begin
        LogErrorMsg('PhiMath', eWarning, E_FAIL, 'SmoothData exception: ' + E.Message);
        raise;
      end;
    end;
  finally
    VarArrayUnlock(Data);
  end;

end;


////////////////////////////////////////////////////////////////////////////////
// Description:  Performs an n-pt smooth on data array given.
//
// Date       : 11 Dec 90
// Author     : Dave Watson
// Purpose    : Binomial Smooth - e.g see Marchand and Marmet, Rev. Sci. Instrum.,
//                                       54(8) (1983) 1034
// Notes:     : For double vector smoothing; smooth done in place
////////////////////////////////////////////////////////////////////////////////
procedure BinomialSmoothData(
  nNoOfDataPoints: Integer;
  nNoOfSmoothPoints: Integer;
  var Data: OleVariant;
  var dMinDataVal: Double;
  var dMaxDataVal: Double;
  var nMinDataIndex: Integer;
  var nMaxDataIndex: Integer
);
var
  i, i1: Integer;
  v0, v1: Double;
  norm: Double;
  pData: pDataDoubleArray;
begin
  // Verify the variant type
  if (VarType(Data) <> VT_ARRAY + VT_R8) then
  begin
    raise EPhiSoftware.Create('PhiMath', errorNormal,
        'Unexpected variant type in BinomialSmoothData()',
        E_UNEXPECTED, '', '', 0);
  end;

  try
    try
      pData := VarArrayLock(Data);

      // Save endpoints */
      i1 := nNoOfDataPoints - 1;
      v0 := pData^[0];
      v1 := pData^[i1];
      norm := 1.0;

      while (nNoOfSmoothPoints > 1) do
      begin
        for i := 0 to i1 - 1  do
          pData^[i] := pData^[i] + pData^[i+1];

        for i := i1-1 downto 1  do
          pData^[i] := pData^[i] + pData^[i-1];

        norm := norm * 0.25;
        pData^[0] := v0 / norm;
        pData^[i1] := v1 / norm;
        nNoOfSmoothPoints := nNoOfSmoothPoints - 2;
      end;

      // Do final normalization run
      norm := norm * 0.25;
      for i := 0 to i1 - 1  do
        pData^[i] := pData^[i] + pData^[i+1];

      for i := i1-1 downto 1  do
        pData^[i] := (pData^[i-1] + pData^[i]) * norm;

      pData^[0] := v0;
      pData^[i1] := v1;

      // Find maximum and minimum data values */
      dMaxDataVal := pData^[0];
      dMinDataVal := pData^[0];
      nMinDataIndex := 0;
      nMaxDataIndex := 0;
      for i := 0 to nNoOfDataPoints - 1  do
      begin
        if (pData^[i] < dMinDataVal) then
        begin
          dMinDataVal := pData^[i];
          nMinDataIndex := i;
        end
        else if (pData^[i] > dMaxDataVal) then
        begin
          dMaxDataVal := pData^[i];
          nMaxDataIndex := i;
        end;
      end;
    except
      on E: Exception do
      begin
        LogErrorMsg('PhiMath', eWarning, E_FAIL, 'BinomialSmoothData() exception: ' + E.Message);
        raise;
      end;
    end;
  finally
    VarArrayUnlock(Data);
  end;
end;

function GreatestCommonDivisor(nUValue: Integer; nVValue: Integer): Integer;
////////////////////////////////////////////////////////////////////////////////
// Description:  Given two integer values, find the greatest common integer
//               divisor.
// Inputs:       nUValue - Non-negative Integer
//               nVValue - Non-negative Integer
// Outputs:      Integer - Largest Integer value that divides evenly into both
//                         given values. Returns -1 with invalid input parameters.
// Note:  NEGATIVE INPUT VALUES NOT SUPPORTED
//        Using Binary GCD Algorithm or 'Stein's Algorithm' for solving
//        greatest common divisor.  Tail-recursive, worst case O((log2 UV)^2) time
////////////////////////////////////////////////////////////////////////////////
begin
  // Negative values are not allowed, return -1 as result.  This is only
  // possible if initially given values were negative
  if ((nUVAlue < 0) or (nVValue < 0) or ((nUVAlue = 0) and (nVVAlue = 0))) then
  begin
    raise EPhiSoftware.Create('PhiMath', errorNormal,
        'Invalid Parameters Given to GreatestCommonDivisor()',
        E_INVALIDARG, '', '', 0);
  end

  // Check if U or V is zero, result is other value (even if other value is zero)
  else if (nUValue = 0) then
    Result := nVValue
  else if (nVValue = 0) then
    Result := nUValue

  // if both values are even, 2 is a common divisor, reduce
  else if (((nUValue mod 2) = 0) and ((nVValue mod 2) = 0)) then
  begin
    Result := 2 * GreatestCommonDivisor(Round(nUValue/2), Round(nVValue/2));
  end

  // if one of two values is even, divide that value by two as 2 is
  // not a common divisor
  else if ((nUValue mod 2) = 0) then
  begin
    Result := GreatestCommonDivisor(Round(nUValue/2), nVValue);
  end
  else if ((nVValue mod 2) = 0) then
  begin
    Result := GreatestCommonDivisor(nUValue, Round(nVValue/2));
  end

  // both values are odd
  else if (nUValue >= nVValue) then
  begin
    Result := GreatestCommonDivisor(Round((nUValue - nVValue)/2), nVValue);
  end
  else
  begin
    Result := GreatestCommonDivisor(Round((nVValue - nUValue)/2), nUValue);
  end;

  // Eventualy nUValue will equal nVValue and nUValue will become zero
  // answer will be 2^k * nVValue, where k is the number of times both
  // nVValue and nUValue were even
end;

function ElapsedTimeInMs(StartTime: Cardinal): Cardinal;
/////////////////////////////////////////////////////////////////////////////
// Description: How long has it been since the given time?
//
// Inputs:      StartTime - start time; used to compare to current time
//
// Outputs:     none
//
// Return:      Elapsed time so far in milliseconds
//
/////////////////////////////////////////////////////////////////////////////
var
  nCurrentTimeInMs: Cardinal;   // current system time in milliseconds (resets every 2^32 ms or 49.71 days);
  nTimeDiffInMs: Cardinal;      // how long has it been since start time
begin
  nCurrentTimeInMs := timeGetTime();
  if (nCurrentTimeInMs < StartTime) then
    nTimeDiffInMs := (High(Cardinal) - StartTime) + nCurrentTimeInMs
  else
    nTimeDiffInMs := nCurrentTimeInMs - StartTime;

  Result := nTimeDiffInMs;
end;

end.
