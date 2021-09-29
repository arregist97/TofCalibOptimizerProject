program TofCalibOptimizer;
////////////////////////////////////////////////////////////////////////////////
// Filename:  TofCalibOptimizer.dpr
// Created:   8/1/2021
// Purpose:   This module contains the project source for the TofCalibOptimizer.
//
//*********************************************************
////////////////////////////////////////////////////////////////////////////////

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainView},
  DocTofCalibOptimizer in 'DocTofCalibOptimizer.pas' {TofCalibOptimizerDoc: TDataModule},
  ViewTofCalibOptimizer in 'ViewTofCalibOptimizer.pas' {TofCalibOptimizerView},
  ViewTofCalibOptimizerInput in 'ViewTofCalibOptimizerInput.pas' {TofCalibOptimizerInputView},
  viewPhi in '..\..\Utilities\DelphiBaseClass\viewPhi.pas' {PhiView},
  docPHI in '..\..\Utilities\DelphiBaseClass\docPHI.pas' {PhiDoc: TDataModule},
  PhiMath in '..\..\Utilities\SysCommon\PhiMath.pas',
  CircularBuffer in '..\..\Applications\AppDatabase\CircularBuffer.pas',
  CommStatsCircularBuffer in '..\..\Applications\AppDatabase\CommStatsCircularBuffer.pas',
  EventLogCircularBuffer in '..\..\Applications\AppDatabase\EventLogCircularBuffer.pas',
  HistDataCircularBuffer in '..\..\Applications\AppDatabase\HistDataCircularBuffer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
