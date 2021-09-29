unit AppDefinitions;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  AppDefinitions.pas
// Created:   on 00-11-06 by Keith Wildermuth
// Purpose:   This module defines useful Application wide definitions and constants.
//*****************************************************************************************************
// Copyright © 2000 Physical Electronics, Inc.
// Created in 2000 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////

interface

uses
  Graphics;

const
  // Extention used for setting files
  c_SettingFileExt = '.phi';
  c_PropertyFileExt = '.phi';
  c_FormFileExt = '.par';
  c_RecipeFileExt = '.phi';
  c_DefectFileExt = '.pff';
  c_LogFileExt = '.log';

  // Reserved setting names
  c_Initial = 'ZERO';
  c_Previous = 'PREVIOUS';
  c_Acquire = 'ACQUIRE';
  c_ZAlign = 'Z ALIGN';
  c_Mcd = 'MCD';
  c_Temp = 'TEMP';
  c_MapAcquire = 'MAP ACQUIRE';
  c_EMS = 'EMS';
  c_Center = 'CENTER';
  c_Idle = 'IDLE';
  c_Warm = 'WARM';

  // Session Names
  c_Session_Main = 'Main';
  c_Session_System = 'System';
  c_Session_Sample = 'Sample';
  c_Session_Tof = 'TOF';
  c_Session_Hardware = 'Hardware';
  c_Session_AutoTool = 'AutoTool';

  // AutoTool Group Names
  c_AutoTool_Acquire = 'TOF';
  c_AutoTool_Aperture = 'LMIG - MVA';
  c_AutoTool_Aperture2 = 'LMIG-2 - MVA';
  c_AutoTool_Bake = 'Bake';
  c_AutoTool_C6010kV = 'C6010kV';
  c_AutoTool_C6020kV = 'C6020kV';
  c_AutoTool_C6020kVAperture = 'C6020kV - MVA';
  c_AutoTool_Cesium = 'Cesium';
  c_AutoTool_ChartRecorder = 'Chart Recorder';
  c_AutoTool_DataManager = 'Data Manager';
  c_AutoTool_DSI = 'DSI';
  c_AutoTool_EnergySlit = 'Motors - Energy Slit';
  c_AutoTool_ENeut = 'E-Neut';
  c_AutoTool_FIB = 'FIB';
  c_AutoTool_GCIB = 'GCIB';
  c_AutoTool_Hardware = 'Hardware';
  c_AutoTool_HotCold = 'Hot Cold Stage';
  c_AutoTool_Instrument = 'Instrument';
  c_AutoTool_IonGun = 'Gas Gun';
  c_AutoTool_IonNeut = 'I-Neut';
  c_AutoTool_LMIG = 'LMIG';
  c_AutoTool_LMIG2 = 'LMIG-2';
  c_AutoTool_MosaicArea = 'Mosaic Area';
  c_AutoTool_MS2 = 'MS2';
  c_AutoTool_Navigation = 'Position List';
  c_AutoTool_Notification = 'Notification';
  c_AutoTool_Photo = 'Photo';
  c_AutoTool_PlatenManager = 'Platen Manager';
  c_AutoTool_Polarity = 'Polarity';
  c_AutoTool_SED = 'SED';
  c_AutoTool_Sputter = 'Sputter';
  c_AutoTool_Stage = 'Stage';
  c_AutoTool_Vacuum = 'Vacuum';

  // Custom Cursors (unique integers starting from 1)
  crHandGrab = 1;
  crHandGrabStage = 2;

  // Doc Names:  Spaces ARE NOT allowed in name because of the TabControl
  // Also, these names are used to create the ...\Settings\DocName\Properties
  // and ..\Settings\DocName\Settings directories
  // WARNING: No two doc names (i.e. strings) can be the same

  //////////////////////////////////////////////////////////////////////////////
  // Doc - Definitions
  //////////////////////////////////////////////////////////////////////////////

  // Doc:Main
  c_MainDoc = 'Main';

  c_FileEditorDoc = 'File Editor';

  c_ConfigManager = 'ConfigManager';
  c_DatabaseManager = 'DatabaseManager';
  c_DataSamplingManager = 'DataSamplingManager';
  c_DocManager = 'DocManager';
  c_ObjectManager = 'ObjectManager';
  c_QueueManager = 'QueueManager';
  c_SimulationConfig = 'SimulationConfig';
  c_StateManager = 'StateManager';
  c_ViewManager = 'ViewManager';

  c_AutoToolDoc = 'AutoTool';
  c_ServiceDoc = 'Service';
  c_ApplicationLogDoc = 'Application Log';
  c_ColorsDoc = 'Colors';

  // Doc: SYSTEM
  c_PlatenManagerDoc = 'Platen Manager';
  c_PlatenManager2Doc = 'Platen Manager-Q';
  c_NavigationDoc = 'Navigate';
  c_Navigation2Doc = 'Navigate-Q';
  c_DataManagerDoc = 'Data Manager';
  c_DataManager2Doc = 'Data Manager-Q';
  c_SampleHandlingDoc = c_PlatenManagerDoc;

//  c_SampleHandlingDoc = 'Sample Handling';
//  c_SampleHandlingCommonDoc = 'Sample Handling Common';

  c_IntroCameraDoc = 'Photo';
  c_VacuumDoc = 'Vacuum';
  c_HardwareManagerDoc = 'HardwareManager';

  // Doc: SAMPLE
  c_AutoZDoc = 'Auto Z';
  c_StageDoc = 'Stage';
  c_ChamberCameraDoc = 'Chamber Camera';
  c_DetectorCameraDoc = 'Detector Camera';
  c_DetectorCamera2Doc = 'MS2 Detector Camera';

  // Doc: IMAGE
  c_SedDoc = 'SED';
  c_ScintillatorDoc = 'Scintillator';

  // Doc: TOF
  c_AcqBaseDoc = 'Acq Base';
  c_AcqDoc = 'Acquisition';
  c_Acq2Doc = 'Acquisition-Q';
  c_AcqMSMSDoc = 'Acq MSMS';
  c_AcqMSMS2Doc = 'Acq MSMS-Q';
  c_MosaicAreaDoc = 'Mosaic Area';
  c_MosaicArea2Doc = 'Mosaic Area-Q';

  c_SpectralDataDoc = 'Spectral Data';
  c_ProfileDataDoc = 'Profile Data';
  c_ImageDataDoc = 'Map Data';
  c_PeriodicTableDoc = 'Periodic Table';
  c_NotificationDoc = 'Notification';

  // Doc: HARDWARE
  c_AmmeterDoc = 'Ammeter';
  c_ApertureDoc = 'Aperture';
  c_Aperture2Doc = 'Aperture-2';
  c_BakeDoc = 'Bake';
  c_HotColdStageDoc = 'Hot Cold Stage';
  c_InstrumentDoc = 'Instrument';
  c_PolarityDoc = 'Polarity';
  c_SputterToolDoc = 'Sputter Tool';
  c_SputterTool2Doc = 'Sputter Tool-Q';
  c_DsiDoc = 'Analyzer';
  c_MS2Doc = 'MS2';
  c_IonGunDoc = 'Gas Gun';
  c_IonNeutDoc = 'I-Neut';
  c_CsIonGunDoc = 'Cesium';
  c_C6010kVIonGunDoc = 'C60-10kV';
  c_C6020kVIonGunDoc = 'C60-20kV';
  c_C6020kVApertureDoc = 'C60-20kV Aperture';
  c_GCIBDoc = 'GCIB';
  c_SequencerDoc = 'Sequencer';
  c_PhiLmigDoc1 = 'PHI LMIG';
  c_PhiLmigDoc2 = 'PHI LMIG-2';
  c_EnergySlitDoc = 'Energy Slit';
  c_EGunNeutDoc = 'E-Neut';
  c_FibDoc = 'FIB';
  c_KnobBoxDoc = 'Knob Box';
  c_DetCalFactorsDoc = 'Detector Calibration Factors';
  c_TdcDoc = 'TDC';
  c_Tdc2Doc = 'TDC-2';
  c_TuningToolDoc = 'Tuning';

  c_SettingsEditorDoc = 'Settings Editor';
  c_OutgasDoc = 'Outgas';
  c_TestHardwareDoc = 'Test Hardware';
  c_HealthCheckDoc = 'Health Check';
  c_HistoryChartDoc = 'History Chart';
  c_HistoryPlotDoc = 'History Plot';
  c_ResourceMonitorDoc = 'Resource Monitor';
  c_CommStatsDoc = 'Communication Statistics';
  c_TuningChartDoc = 'Tuning Chart';
  c_CoffeeTimerDoc = 'Coffee Timer';
  c_UsbConnectionMonitorDoc = 'USB Connection Monitor';

  // View Names:  These view names are displayed as menu items in the UI.  They
  // must be unique and meaningful.  Spaces ARE allowed.  Dialog views should end
  // in '...' to show that a menu will popup.  Sub-views should have the same root
  // name as the parent view (eg. 'Survey', 'Survey Properties...', 'Survey Acq Time')

  // WARNING: No two view names (i.e. strings) can be the same

  //////////////////////////////////////////////////////////////////////////////
  // View - Definitions
  //////////////////////////////////////////////////////////////////////////////

  // View: MAIN
  c_View_AutoToolJob = 'Queue';
  c_View_AutoToolRecipe = 'AutoTool';
  c_View_AutoToolReport = 'Errors/Warnings';
  c_View_AutoToolStatus = 'AutoTool Status';
  c_View_AutoToolStatusRibbon = 'AutoTool Status Ribbon';
  c_View_AutoToolDiagnostics = 'Diagnostics';
  c_View_AutoToolContainer = 'AutoTool Diagnostics Container';
  c_View_AutoToolQueueContainer = 'Queue Container';
  c_View_AutoToolTree = 'Queue Tree';
  c_View_AutoToolTreeToolkit = 'Queue Tree Toolkit';
  c_View_AutoToolTreeRibbon = 'Queue Tree Ribbon';
  c_View_AutoToolTreeContainer = 'Queue Tree Container';
  c_View_AutoToolJobName = 'AutoTool Job Name';
  c_View_AutoToolProp = 'AutoTool Prop';
  c_View_AutoToolPropContainer = 'AutoTool Prop Container';
  c_View_AutoToolStopDlg = 'AutoTool Stop Dialog';
  c_View_AutoToolErrorDlg = 'AutoTool Error Dialog';
  c_View_AutoToolMessageDlg = 'AutoTool Message Dialog';
  c_View_AutoToolAddCustomItem = 'Queue Add Custom Item';
  c_View_AutoToolAddCustomItemContainer = 'Queue Add Custom Item Container';

  c_View_ConfigHardware = 'Hardware';
  c_View_ConfigHardwareOptions = 'Hardware Options';
  c_View_ConfigHardwareMSMS = 'Hardware MSMS';
  c_View_ConfigHardwareIntro = 'Hardware Intro';
  c_View_ConfigHardwareAux = 'Hardware Aux';
  c_View_ConfigHardwareVacuum = 'Hardware Vacuum';
  c_View_ConfigHardwareStage = 'Hardware Stage';
  c_View_ConfigHardwarePorts = 'Hardware Ports';
  c_View_ConfigHardwareLMIG1 = 'Hardware LMIG-1';
  c_View_ConfigHardwareLMIG2 = 'Hardware LMIG-2';
  c_View_ConfigHardwareGCIB = 'Hardware GCIB';
  c_View_ConfigHardwareC60 = 'Hardware C60';
  c_View_ConfigHardwareGasGun = 'Hardware GasGun';
  c_View_ConfigHardwareENeut = 'Hardware E-Neut';
  c_View_ConfigHardwareContainer = 'Hardware Container';

  c_View_ConfigComPorts = 'COM Ports';
  c_View_ConfigSimulation = 'Simulation';
  c_View_ConfigContainer = 'Configuration Container';

  c_View_DataColors = 'Data Colors';
  c_View_PositionColors = 'Position Colors';
  c_View_ColorContainer = 'Color Container';

  c_View_ServiceSystemLog = 'System Log';
  c_View_DataSampling = 'Data Sampling';
  c_View_ServiceContainer = 'Service Container';

  c_View_Instrument = 'Instrument Files';
  c_View_InstrumentContainer = 'Instrument File Container';

  c_View_LifetimeRibbonTab = 'Lifetime Ribbon Tab';
  c_View_HealthCheckRibbonTab = 'Health Check Ribbon';
  c_View_HealthCheck2RibbonTab = 'Health Check-2 Ribbon';
  c_View_ToolsRibbonTab = 'Tools Ribbon Tab';
  c_View_RibbonContainer = 'Ribbon Container';

  c_View_ApplicationLog = 'Application Log';

  // View: SYSTEM
  c_View_LabBook = 'Lab Book';
  c_View_LabBookProperties = 'Lab Book Properties';
  c_View_LabBookDetails = 'Lab Book Details';
  c_View_LabBookRibbon = 'Lab Book Ribbon';
  c_View_LabBookPrintPreview = 'Lab Book Print Preview';
  c_View_LabBookPrintPreviewContainer = 'Lab Book Print Preview Container';
  c_View_LabBookContactInfo = 'Contact Info';
  c_View_Directory = 'Directory';
  c_View_AutoFilename = 'Auto Filename';
  c_View_AutoFilename2 = 'Auto Filename-Q';
  c_View_AutoDirectory = 'Auto Directory';
  c_View_AutoDirectory2 = 'Auto Directory-Q';
  c_View_ListParameters = 'List Parameters';
  c_View_ListParametersData = 'List Parameters Data';
  c_View_ListParametersContainer = 'List Parameters Container';
  c_View_Platen = 'Platen';
  c_View_PlatenCreate = 'Platen Create';
  c_View_PlatenOverlay = 'Platen Overlay';
  c_View_PlatenOverlay2 = 'Platen Overlay-Q';

  c_View_PlatenManager = 'Platen';
  c_View_PlatenManagerProperties = 'Platen Manager Properties';
  c_View_PlatenManagerContainer = 'Platen Manager Container';

  c_View_SampleHandling = 'Sample Handling';
  c_View_SampleHandlingDiagnostics = 'Sample Handling Diagnostics';
  c_View_SampleHandlingStageLimits = 'Sample Handling Stage Limits';
  c_View_SampleHandlingContainer = 'Sample Handling Container';
  c_View_SampleHandlingBrowse = 'Sample Handling Browse';
  c_View_SampleHandlingBrowseContainer = 'Sample Handling Browse Container';

  c_View_PlatenManagerCPTransfer = 'Platen Manager CP Transfer';
  c_View_PlatenManagerCPCreate = 'Platen Manager CP Create';
  c_View_PlatenManagerCPBrowse = 'Platen Manager CP Browse';
  c_View_PlatenManagerCPBrowse2 = 'Platen Manager CP Browse-Q';
  c_View_PlatenManagerCPBrowseContainer = 'Platen Manager CP Browse Container';
  c_View_PlatenManagerCPIntroSample = 'Platen Manager CP Intro Sample';
  c_View_PlatenManagerCPExtractSample = 'Platen Manager CP Extract Sample';
  c_View_PlatenManagerCPPropertiesContainer = 'Platen Manager CP Properties Container';

  c_View_PlatenTransferIntroProp = 'Platen Transfer Intro Properties';
  c_View_PlatenTransferIntroEstTime = 'Platen Transfer Intro Est. Time';
  c_View_PlatenTransferExtractProp = 'Platen Transfer Extract Properties';
  c_View_PlatenTransferExtractEstTime = 'Platen Transfer Extract Est. Time';
  c_View_PlatenTransferStatusIntro = 'Sample Transfer Status Intro';
  c_View_PlatenTransferStatusIntroInit = 'Sample Transfer Status Intro w/Init';
  c_View_PlatenTransferStatusExtract = 'Sample Transfer Status Extract';

  c_View_PlatenParkProp = 'Platen Park Properties';
  c_View_PlatenTransferPropContainer = 'Platen Transfer Properties Container';

  c_View_Photo = 'Intro Camera';
  c_View_PhotoImage = 'Camera Viewer';
  c_View_PhotoCalibrate = 'Camera Calibrate';
  c_View_PhotoCalibrateProp = 'Camera Calibrate Properties';
  c_View_PhotoCalibratePropContainer = 'Camera Calibrate Properties Container';
  c_View_PhotoCanonProperties = 'Camera Canon Properties';
  c_View_PhotoGigEProperties = 'Camera GigE Properties';
  c_View_PhotoPropContainer = 'Intro Camera Properties Container';

  c_View_ChamberCameraImage = 'Chamber Camera Viewer';
  c_View_ChamberCameraProperties = 'Chamber Camera Properties';
  c_View_ChamberCameraPointClick = 'Chamber Camera Point Click';
  c_View_ChamberCameraPropContainer = 'Chamber Camera Properties Container';
  c_View_ChamberViewerContainer = 'Chamber Camera Multi-Viewer';

  c_View_DetectorCameraImage = 'Detector Camera Viewer';
  c_View_DetectorCameraProperties = 'Detector Camera Properties';
  c_View_DetectorCameraPropContainer = 'Detector Camera Properties Container';
  c_View_DetectorViewerContainer = 'Detector Camera Multi-Viewer';

  c_View_DetectorCamera2Image = 'Detector Camera-2 Viewer';
  c_View_DetectorCamera2Properties = 'Detector Camera-2 Properties';
  c_View_DetectorCamera2PropContainer = 'Detector Camera-2 Properties Container';

  c_View_Vacuum = 'Watcher';
  c_View_VacuumRibbon = 'Vacuum Ribbon';
  c_View_VacuumValves = 'Vacuum Valves';
  c_View_VacuumBakeValves = 'Vacuum Bake Valves';
  c_View_VacuumProperties = 'Vacuum Properties';
  c_View_VacuumInterlocks = 'Vacuum Interlocks';
  c_View_VacuumPressureReadings = 'Vacuum Pressure Readings';
  c_View_VacuumDiagnostics = 'Vacuum Diagnostics';
  c_View_VacuumContainer = 'Vacuum Properties Container';

  c_View_HardwareManager = 'Hardware Manager';
  c_View_HardwareManager970 = 'Hardware Manager MOD970';
  c_View_HardwareManagerDiagnostics970 = 'Hardware Manager Diagnostics MOD970';
  c_View_HardwareManagerPropertiesContainer = 'Hardware Manager Properties Container';
  c_View_HardwareManagerDiagnosticsContainer = 'Hardware Manager Diagnostics Container';

  c_View_SystemDiagnosticsContainer = 'System Diagnostics Container';

  c_View_MainValvePicture = 'Valve Viewer';
  c_View_ValvePictureContainer = 'Valve Viewer Container';

  c_View_BirdsEyeAnalyzer = 'Birds Eye Analyzer';
  c_View_BirdsEyeGuns = 'Birds Eye Guns';
  c_View_BirdsEyeNanoTOF = 'Birds Eye nanoTOF';
  c_View_BirdsEyeCDTOF = 'Birds Eye CD-TOF';
  c_View_BirdsEyePictureContainer = 'Birds Eye Container';

  // View: SAMPLE
  c_View_AutoZ = 'Auto Z';
  c_View_AutoZRun = 'Auto Z Run';
  c_View_AutoZStatus = 'Auto Z Status';
  c_View_AutoZProperties = 'Auto Z Properties';
  c_View_AutoZImage = 'Auto Z Image';
  c_View_AutoZLog = 'Auto Z Log';
  c_View_AutoZPropertiesContainer = 'Auto Z Properties Container';
  c_View_AutoZChargeCompProperties = 'Auto C Charge Comp Properties';
  c_View_AutoZChargeCompPropertiesContainer = 'Auto C Charge Comp Properties Container';

  c_View_WaferAlign = 'Platen Align';
  c_View_WaferAlignDiagnostics = 'Platen Align Diagnostics...';


  c_View_PositionList = 'Position List Viewer';
  c_View_PositionList2 = 'Position List Viewer-Q';
  c_View_PositionListSetup = 'Position List Setup';
  c_View_PositionListSetup2 = 'Position List Setup-Q';
  c_View_WaferInfo = 'Wafer Info';
  c_View_WaferInfo2 = 'Wafer Info-Q';
  c_View_WaferInfoContainer = 'Wafer Info Container';
  c_View_WaferInfoContainer2 = 'Wafer Info Container-Q';
  c_View_WaferPositionInfo = 'Position Info';
  c_View_WaferPositionInfo2 = 'Position Info-Q';
  c_View_WaferPositionInfoContainer = 'Position Info Container';
  c_View_WaferPositionInfoContainer2 = 'Position Info Container-Q';
  c_View_WaferCreatePosition = 'Create Position';
  c_View_WaferCreatePosition2 = 'Create Position-Q';
  c_View_WaferCreatePositionContainer = 'Create Position Container';
  c_View_WaferCreatePositionContainer2 = 'Create Position Container-Q';
  c_View_WaferSelect = 'Select Wafer Dialog';
  c_View_WaferFilter = 'Filter Dialog';
  c_View_WaferDefectSearch = 'Defect Search';

  c_View_WaferMap = 'Sample Viewer';
  c_View_WaferMap2 = 'Sample Viewer-Q';
  c_View_WaferMapImagePlot = 'Sample Viewer Image Plot';
  c_View_WaferMapImagePlot2 = 'Sample Viewer Image Plot-Q';

  c_View_PtGeneration = 'Point Generation';
  c_View_PtGeneration2 = 'Point Generation-Q';
  c_View_PtGenerationFOV = 'Point Generation FOV';
  c_View_PtGenerationFOV2 = 'Point Generation FOV-Q';
  c_View_PtGenerationSetup = 'Point Generation Setup';
  c_View_PtGenerationSetup2 = 'Point Generation Setup-Q';
  c_View_PtGenerationContainer = 'Point Generation Container';
  c_View_PtGenerationContainer2 = 'Point Generation Container-Q';

  c_View_Stage = 'Stage';
  c_View_StageRibbon = 'Stage Ribbon';
  c_View_StageProperties = 'Stage Properties';
  c_View_StagePropertiesContainer = 'Stage Properties Container';
  c_View_StageDiagnostics = 'Stage Diagnostics';
  c_View_StageDiagnostics2 = 'Stage Diagnostics-2';
  c_View_StageDiagnosticsContainer = 'Stage Diagnostics Container';
  c_View_StageJoyStick = 'Stage JoyStick';
  c_View_StageJoyStickRibbon = 'Stage JoyStick Ribbon';
  c_View_StageRotationCalibration = 'Stage Rotation Calibration';
  c_View_StageTiltCorrection = 'Stage Tilt Correction';
  c_View_StageMotorPositions = 'Stage Motor Positions';
  c_View_StageMotorMileage = 'Stage Motor Mileage';

  // View: IMAGE
  c_View_Sed = 'SED';
  c_View_SedRibbon = 'SED Ribbon';
  c_View_SedProperties = 'SED Properties';
  c_View_SedContainer = 'SED Container';

  c_View_SedImage = 'SED Viewer';
  c_View_SedImagePlot = 'SED Viewer Image Plot';
  c_View_SedViewerContainer = 'SED Multi-Viewer';

  c_View_SedImagePropAnnotate = 'SED Image Properties Annotate' ;
  c_View_SedImagePropPhoto = 'SED Image Properties Photo' ;
  c_View_SedImagePropImage = 'SED Image Properties Image' ;
  c_View_SedImageProperties = 'SED Image Properties';
  c_View_SedImagePropContainer = 'SED Image Properties Container' ;

  c_View_SedGoogleBar = 'SED Google Bar';
  c_View_SedHistogram = 'SED Histogram';
  c_View_SedPhotoStatus = 'SED Preview';

  c_View_Scintillator = 'Scintillator';
  c_View_ScintillatorDiagnostics = 'Scintillator Diagnostics';

  c_View_PointClickCalibrate = 'Point and Click Calibrate';

  // View: TOF
  c_View_AcqSpectrum = 'Acq Spectrum';
  c_View_AcqSpectrum2 = 'Acq Spectrum-Q';
  c_View_AcqSpectrumProperties = 'Acq Spectrum Properties';
  c_View_AcqSpectrumProperties2 = 'Acq Spectrum Properties-Q';
  c_View_AcqSpectrumChargeComp = 'Acq Spectrum Charge Comp';
  c_View_AcqSpectrumChargeComp2 = 'Acq Spectrum Charge Comp-Q';
  c_View_AcqSpectrumContainer = 'Acq Spectrum Container';
  c_View_AcqSpectrumContainer2 = 'Acq Spectrum Container-Q';

  c_View_AcqPhasedProfile = 'Acq Phased Profile';
  c_View_AcqPhasedProfile2 = 'Acq Phased Profile-Q';
  c_View_AcqPhasedProfileProperties = 'Acq Phased Profile Properties';
  c_View_AcqPhasedProfileProperties2 = 'Acq Phased Profile Properties-Q';
  c_View_AcqPhasedProfileContainer = 'Acq Phased Profile Container';
  c_View_AcqPhasedProfileContainer2 = 'Acq Phased Profile Container-Q';

  c_View_AcqPhasedProfileAcqPhase = 'Acquire Phase';
  c_View_AcqPhasedProfileAcqPhase2 = 'Acquire Phase-Q';
  c_View_AcqPhasedProfileSputterPhase = 'Sputter Phase';
  c_View_AcqPhasedProfileSputterPhase2 = 'Sputter Phase-Q';
  c_View_AcqPhasedProfileChargeCompPhase = 'Charge Comp Phase';
  c_View_AcqPhasedProfileChargeCompPhase2 = 'Charge Comp Phase-Q';

  c_View_AcqInterleaved = 'Acq Interleaved';
  c_View_AcqInterleaved2 = 'Acq Interleaved-Q';
  c_View_AcqInterleavedProperties = 'Acq Interleaved Properties';
  c_View_AcqInterleavedProperties2 = 'Acq Interleaved Properties-Q';
  c_View_AcqInterleavedChargeComp = 'Acq Interleaved Charge Comp';
  c_View_AcqInterleavedChargeComp2 = 'Acq Interleaved Charge Comp-Q';
  c_View_AcqInterleavedSputterProperties = 'Acq Interleaved Sputter Properties';
  c_View_AcqInterleavedSputterProperties2 = 'Acq Interleaved Sputter Properties-Q';
  c_View_AcqInterleavedContainer = 'Acq Interleaved Container';
  c_View_AcqInterleavedContainer2 = 'Acq Interleaved Container-Q';

  c_View_AcqMosaic = 'Acq Mosaic Map';
  c_View_AcqMosaic2 = 'Acq Mosaic Map-Q';
  c_View_AcqMosaicProperties = 'Acq Mosaic Map Properties';
  c_View_AcqMosaicProperties2 = 'Acq Mosaic Map Properties-Q';
  c_View_MosaicArea = 'Mosaic Area';
  c_View_MosaicArea2 = 'Mosaic Area-Q';

  c_View_AcqPropertiesContainer = 'Acq Properties Container';

  c_View_AcqStatus = 'Acq Status';
  c_View_AcqStatusRibbon = 'Acq Status Ribbon';

  c_View_AcqMSMS = 'Acq MSMS';
  c_View_AcqMSMS2 = 'Acq MSMS-Q';
  c_View_AcqSpectrumMS2Properties = 'Acq Spectrum MS2 Properties';
  c_View_AcqSpectrumMS2Properties2 = 'Acq Spectrum MS2 Properties-Q';
  c_View_AcqMSMSContainer = 'MSMS Container';
  c_View_AcqMSMSContainer2 = 'MSMS Container-Q';

  c_View_Fib = 'FIB';
  c_View_FibProp = 'FIB Properties';
  c_View_FibChargeComp = 'FIB Charge Comp';
  c_View_FibPropContainer = 'FIB Properties Container';
  c_View_FibStatus = 'FIB Status';

  c_View_SpectralViewer = 'Spectral Viewer';
  c_View_ProfileViewer = 'Profile Viewer';
  c_View_ImageViewer = 'Image Viewer';
  c_View_DataOuput = 'Data Viewer';
  c_View_Legend = 'Legend';

  c_View_ImageDataParm = 'Image Data';
  c_View_ImageDataContainer = 'Image Data Container';

  c_View_ImageDataImagePlot = 'Image Data Image Plot';

  c_View_Notification = 'Notification';
  c_View_NotificationProperties = 'Notification Properties';
  c_View_NotificationContainer = 'Notification Container';

  // View: HARDWARE
  c_View_Ammeter = 'Ammeter';
  c_View_AmmeterRibbon = 'Ammeter Ribbon';
  c_View_AmmeterLargeFont = 'Ammeter Large Font';
  c_View_AmmeterProperties = 'Ammeter Properties';
  c_View_AmmeterContainer = 'Ammeter Container';

  c_View_Bake = 'Bake';
  c_View_BakeContainer = 'Bake Container';

  c_View_HotColdStage = 'Hot Cold Stage';
  c_View_HotColdStageFastZalar = 'Fast Zalar';
  c_View_HotColdStageProperties = 'Hot Cold Stage Properties';
  c_View_HotColdStageContainer = 'Hot Cold Stage Container';
  c_View_HotColdStageDiagnostics = 'Hot Cold Stage Diagnostics';
  c_View_HotColdStageDiagnosticsContainer = 'Hot Cold Stage Diagnostics Container';

  c_View_SputterTool = 'Sputter Tool';
  c_View_SputterTool2 = 'Sputter Tool-Q';
  c_View_SputterToolRibbon = 'Sputter Tool Ribbon';
  c_View_SputterToolLargeFont = 'Sputter Tool Large Font';
  c_View_SputterToolProperties = 'Sputter Tool Properties';
  c_View_SputterToolChargeComp = 'Sputter Tool Charge Comp';
  c_View_SputterToolChargeComp2 = 'Sputter Tool Charge Comp-Q';
  c_View_SputterToolContainer = 'Sputter Tool Container';

  c_View_TuningTool = 'Tuning Tool';
  c_View_TuningToolRibbon = 'Tuning Tool Ribbon';
  c_View_TuningToolContainer = 'Tuning Tool Container';

  c_View_EGunNeut = 'E-Neut';
  c_View_EGunNeutProps = 'E-Neut Service Properties';
  c_View_EGunNeutPropsSource = 'E-Neut Source Properties';
  c_View_EGunNeutPropsContainer = 'E-Neut Properties Continer';
  c_View_EGunNeutDiagnostics = 'E-Neut Diagnostics';
  c_View_EGunNeutAdcDiagnostics = 'E-Neut ADC Diagnostics';
  c_View_EGunNeutDiagnosticsContainer = 'E-Neut Diagnostics Continer';
  c_View_EGunNeutDiagram = 'E-Neut Diagram';
  c_View_EGunNeutDiagramContainer = 'E-Neut Diagram Container';
  c_View_EGunNeutFilamentRibbon = 'E-Neut Filament Ribbon';
  c_View_EGunNeutHealthCheck = 'E-Neut Health Check';

  c_View_IonGun = 'Gas Gun';
  c_View_IonGunDiagnostics = 'Gas Gun Diagnostics';
  c_View_IonGunDiagnostics20066 = 'Gas Gun 20-066 Diagnostics';
  c_View_IonGunDiagnosticsContainer = 'Gas Gun Diagnostics Container';
  c_View_IonGunPressures = 'Gas Gun Pressure Readings...';
  c_View_IonGunDiagram = 'Gas Gun Diagram';
  c_View_IonGunDiagramContainer = 'Gas Gun Diagram Container';
  c_View_IonGunGoogleBar = 'Gas Gun Google Bar';
  c_View_IonGunFilamentRibbon = 'Gas Gun Filament Ribbon';
  c_View_IonGunHealthCheck = 'Gas Gun Health Check';

  c_View_IonGunPropSource = 'Gas Gun Properties Source';
  c_View_IonGunPropColumn = 'Gas Gun Properties Column';
  c_View_IonGunPropRaster = 'Gas Gun Properties Raster';
  c_View_IonGunPropService = 'Gas Gun Properties Service';
  c_View_IonGunPropContainer = 'Gas Gun Properties Container';

  c_View_IonNeut = 'Ion Neut';
  c_View_IonNeutDiagnostics = 'Ion Neut Diagnostics';
  c_View_IonNeutDiagnosticsContainer = 'Ion Neut Diagnostics Container';
  c_View_IonNeutProps = 'Ion Neut Properties...';
  c_View_IonNeutPropsContainer = 'Ion Neut Properties Container';
  c_View_IonNeutPressures = 'Ion Neut Pressure Readings...';
  c_View_IonNeutDiagram = 'Ion Neut Diagram';
  c_View_IonNeutDiagramContainer = 'Ion Neut Diagram Container';
  c_View_IonNeutGoogleBar = 'Ion Neut Google Bar';
  c_View_IonNeutHealthCheck = 'Ion Neut Health Check';

  c_View_PhiLmig = 'PHI LMIG';
  c_View_PhiLmigGaEmitter = 'PHI LMIG Ga Emitter';
  c_View_PhiLmigGaEmitterShutdown = 'PHI LMIG Ga Emitter Shutdown';
  c_View_PhiLmigGaEmitterContainer = 'PHI LMIG Ga Emitter Container';
  c_View_PhiLmigAuEmitter = 'PHI LMIG Au Emitter';
  c_View_PhiLmigAuEmitterShutdown = 'PHI LMIG Au Emitter Shutdown';
  c_View_PhiLmigAuEmitterContainer = 'PHI LMIG Au Emitter Container';
  c_View_PhiLmigBiEmitter = 'PHI LMIG Bi Emitter';
  c_View_PhiLmigBiEmitterRecover = 'PHI LMIG Bi Emitter Recover';
  c_View_PhiLmigBiEmitterRecoverStatus = 'PHI LMIG Bi Emitter Recover Status';
  c_View_PhiLmigBiEmitterShutdown = 'PHI LMIG Bi Emitter Shutdown';
  c_View_PhiLmigBiEmitterContainer = 'PHI LMIG Bi Emitter Container';
  c_View_PhiLmigSource = 'PHI LMIG Source';
  c_View_PhiLmigColumn = 'PHI LMIG Column';
  c_View_PhiLmigSourceDiagnostics = 'PHI LMIG Source Diagnostics';
  c_View_PhiLmigColumnDiagnostics = 'PHI LMIG Column Diagnostics';
  c_View_PhiLmigRasterDiagnostics = 'PHI LMIG Raster Diagnostics';
  c_View_PhiLmigDSIDiagnostics = 'PHI LMIG DSI Diagnostics';
  c_View_PhiLmigDiagnostics = 'PHI LMIG Diagnostics';
  c_View_PhiLmigDiagnosticsContainer = 'PHI LMIG Diagnostics Container';
  c_View_PhiLmigDiagram = 'PHI LMIG Diagram';
  c_View_PhiLmigDiagramContainer = 'PHI LMIG Diagram Container';
  c_View_PhiLmigProperties = 'PHI LMIG Properties';
  c_View_PhiLmigPropertiesContainer = 'PHI LMIG Properties Container';
  c_View_PhiLmigRaster = 'PHI LMIG Raster';
  c_View_PhiLmigEmitterStatus = 'PHI LMIG Emitter Status';
  c_View_PhiLmigEmitterStop = 'PHI LMIG Emitter Stop';
  c_View_PhiLmigStartEmitterError = 'PHI LMIG Start Emitter Error';
  c_View_PhiLmigReheatEmitter = 'PHI LMIG Reheat Emitter';
  c_View_PhiLmigReheatEmitterStatus = 'PHI LMIG Reheat Emitter Status';
  c_View_PhiLmigAuSoureContainer = 'PHI LMIG Au Properties Container';
  c_View_PhiLmigBiSoureContainer = 'PHI LMIG Bi Properties Container';
  c_View_PhiLmigGaSoureContainer = 'PHI LMIG Ga Properties Container';
  c_View_PhiLmigLockEmitter = 'PHI LMIG Lock Emitter';
  c_View_PhiLmigFilamentRibbon = 'PHI LMIG Filament Lifetime';
  c_View_PhiLmigHealthCheck = 'PHI LMIG Health Check';

  c_View_PhiLmig2 = 'PHI LMIG-2';
  c_View_PhiLmig2GaEmitter = 'PHI LMIG-2 Ga Emitter';
  c_View_PhiLmig2GaEmitterShutdown = 'PHI LMIG-2 Ga Emitter Shutdown';
  c_View_PhiLmig2GaEmitterContainer = 'PHI LMIG-2 Ga Emitter Container';
  c_View_PhiLmig2AuEmitter = 'PHI LMIG-2 Au Emitter';
  c_View_PhiLmig2AuEmitterShutdown = 'PHI LMIG-2 Au Emitter Shutdown';
  c_View_PhiLmig2AuEmitterContainer = 'PHI LMIG-2 Au Emitter Container';
  c_View_PhiLmig2BiEmitter = 'PHI LMIG-2 Bi Emitter';
  c_View_PhiLmig2BiEmitterShutdown = 'PHI LMIG-2 Bi Emitter Shutdown';
  c_View_PhiLmig2BiEmitterRecover = 'PHI LMIG-2 Bi Emitter Recover';
  c_View_PhiLmig2BiEmitterRecoverStatus= 'PHI LMIG-2 Bi Emitter Recover Status';
  c_View_PhiLmig2BiEmitterContainer = 'PHI LMIG-2 Bi Emitter Container';
  c_View_PhiLmig2Source = 'PHI LMIG-2 Source';
  c_View_PhiLmig2Column = 'PHI LMIG-2 Column';
  c_View_PhiLmig2SourceDiagnostics = 'PHI LMIG-2 Source Diagnostics';
  c_View_PhiLmig2ColumnDiagnostics = 'PHI LMIG-2 Column Diagnostics';
  c_View_PhiLmig2RasterDiagnostics = 'PHI LMIG-2 Raster Diagnostics';
  c_View_PhiLmig2DSIDiagnostics = 'PHI LMIG-2 DSI Diagnostics';
  c_View_PhiLmig2Diagnostics = 'PHI LMIG-2 Diagnostics';
  c_View_PhiLmig2DiagnosticsContainer = 'PHI LMIG-2 Diagnostics Container';
  c_View_PhiLmig2Diagram = 'PHI LMIG-2 Diagram';
  c_View_PhiLmig2DiagramContainer = 'PHI LMIG-2 Diagram Container';
  c_View_PhiLmig2Properties = 'PHI LMIG-2 Properties';
  c_View_PhiLmig2PropertiesContainer = 'PHI LMIG-2 Properties Container';
  c_View_PhiLmig2Raster = 'PHI LMIG-2 Raster';
  c_View_PhiLmig2EmitterStatus = 'PHI LMIG-2 Emitter Status';
  c_View_PhiLmig2EmitterStop = 'PHI LMIG-2 Emitter Stop';
  c_View_PhiLmig2StartEmitterError = 'PHI LMIG-2 Start Emitter Error';
  c_View_PhiLmig2ReheatEmitter = 'PHI LMIG-2 Reheat Emitter';
  c_View_PhiLmig2ReheatEmitterStatus = 'PHI LMIG-2 Reheat Emitter Status';
  c_View_PhiLmig2AuSoureContainer = 'PHI LMIG-2 Au Properties Container';
  c_View_PhiLmig2BiSoureContainer = 'PHI LMIG-2 Bi Properties Container';
  c_View_PhiLmig2GaSoureContainer = 'PHI LMIG-2 Ga Properties Container';
  c_View_PhiLmig2LockEmitter = 'PHI LMIG-2 Lock Emitter';
  c_View_PhiLmig2FilamentRibbon = 'PHI LMIG-2 Filament Lifetime';
  c_View_PhiLmig2HealthCheck = 'PHI LMIG-2 Health Check';

  c_View_GCIB = 'GCIB';
  c_View_GCIBSourceDiagnostics = 'GCIB Source Diagnostics' ;
  c_View_GCIBVacuumDiagnostics = 'GCIB Vacuum Diagnostics' ;
  c_View_GCIBDiagnostics = 'GCIB Diagnostics' ;
  c_View_GCIBDiagnosticsContainer = 'GCIB Diagnostics Container' ;
  c_View_GCIBValvePicture = 'GCIB Vacuum Viewer' ;
  c_View_GCIBDiagram = 'GCIB Diagram';
  c_View_GCIBDiagramContainer = 'GCIB Diagram Container';
  c_View_GCIBColunn = 'GCIB Column' ;
  c_View_GCIBPressure = 'GCIB Pressure' ;
  c_View_GCIBRaster = 'GCIB Raster' ;
  c_View_GCIBSource = 'GCIB Source' ;
  c_View_GCIBPropContainer = 'GCIB Properties Container' ;
  c_View_GCIBFilamentRibbon = 'GCIB Filament Ribbon';
  c_View_GCIBHealthCheck = 'GCIB Health Check';

  c_View_Cesium = 'Cesium';
  c_View_CesiumRaster = 'Cesium Raster' ;
  c_View_CesiumProp = 'Cesium Properties' ;
  c_View_CesiumPropContainer = 'Cesium Properties Container' ;
  c_View_CesiumValvePicture = 'Cesium Vacuum Viewer' ;
  c_View_CesiumSourceDiagnostics = 'Cesium Source Diagnostics' ;
  c_View_CesiumColumnDiagnostics = 'Cesium Column Diagnostics' ;
  c_View_CesiumRasterDiagnostics = 'Cesium Raster Diagnostics' ;
  c_View_CesiumDiagnostics = 'Cesium Diagnostics' ;
  c_View_CesiumDiagnosticsContainer = 'Cesium Diagnostics Container' ;
  c_View_CesiumDiagram = 'Cesium Diagram';
  c_View_CesiumDiagramContainer = 'Cesium Diagram Container';
  c_View_CesiumHealthCheck = 'Cesium Health Check';

  c_View_C6020kV = 'C6020kV';
  c_View_C6020kVRaster = 'C6020kV Raster' ;
  c_View_C6020kVSource = 'C6020kV Source' ;
  c_View_C6020kVColumn = 'C6020kV Column' ;
  c_View_C6020kVModeIdle = 'C6020kV Idle' ;
  c_View_C6020kVModeOff = 'C6020kV Off' ;
  c_View_C6020kVModeStandby = 'C6020kV Standby' ;
  c_View_C6020kVSourceContainer = 'C6020kV Source Container' ;
  c_View_C6020kVProp = 'C6020kV Properties' ;
  c_View_C6020kVPropContainer = 'C6020kV Properties Container' ;
  c_View_C6020kVSourceDiagnostics = 'C6020kV Source Diagnostics' ;
  c_View_C6020kVColumnDiagnostics = 'C6020kV Column Diagnostics' ;
  c_View_C6020kVRasterDiagnostics = 'C6020kV Raster Diagnostics' ;
  c_View_C6020kVDiagnostics = 'C6020kV Diagnostics' ;
  c_View_C6020kVDiagnosticsContainer = 'C6020kV Diagnostics Container' ;
  c_View_C6020kVCalibSetpoint = 'C6020kV Setpoint Calibration ' ;
  c_View_C6020kVCalibMonitor = 'C6020kV Monitor Calibration' ;
  c_View_C6020kVCalibContainer = 'C6020kV Calibration Container' ;
  c_View_C6020kVDiagram = 'C6020kV Diagram';
  c_View_C6020kVDiagramContainer = 'C6020kV Diagram Container';
  c_View_C6020kVFilamentRibbon = 'C6020kV Filament Ribbon';
  c_View_C6020kVHealthCheck = 'C6020kV Health Check';

  c_View_C6020kVAperture = 'C6020kV Aperture';
  c_View_C6020kVApertureProp = 'C6020kV Aperture Properties';
  c_View_C6020kVAperturePropContainer = 'C6020kV Aperture Properties Container';

  c_View_SequencerQuickAdjust = 'Sequencer Quick Adjust';
  c_View_SequencerC60Settings = 'Sequencer C60 Settings';
  c_View_SequencerLmigSettings = 'Sequencer LMIG Settings';
  c_View_SequencerLmig2Settings = 'Sequencer LMIG-2 Settings';
  c_View_SequencerMS2Settings = 'Sequencer MS2 Settings';
  c_View_SequencerAdjustContainer = 'Sequencer Adjust Container';

  c_View_SequencerDiagnostics = 'Sequencer Diagnostics';
  c_View_SequencerDataAcqDiagnostics = 'Sequencer Data Acq Diagnostics';
  c_View_SequencerSinglePulserDiagnostics = 'Sequencer Single Pulser Diagnostics';
  c_View_SequencerMultiPulserDiagnostics = 'Sequencer Multi Pulser Diagnostics';
  c_View_SequencerDiagnosticsContainer = 'Sequencer Diagnostics Container';
  c_View_SequencerHealthCheck = 'Sequencer Health Check';

  c_View_Tdc = 'TDC';
  c_View_Tdc2 = 'TDC-2';
  c_View_TdcContainer = 'TDC Container';
  c_View_TdcHealthCheck = 'TDC Health Check';
  c_View_Tdc2HealthCheck = 'TDC-2 Health Check';

  c_View_DSI = 'DSI';
  c_View_DsiDiagnostics = 'DSI Diagnostics';
  c_View_DsiDetectorDiagnostics = 'DSI Detector Diagnostics';
  c_View_DsiDetectorProperties = 'DSI Detector Properties';
  c_View_DsiSpectrometerDiagnostics = 'DSI Spectrometer Diagnostics';
  c_View_DsiSpectrometerProperties = 'DSI Spectrometer Properties';
  c_View_DsiInstrumentDiagnostics = 'DSI Instrument Diagnostics';
  c_View_DsiInstrumentProperties = 'DSI Instrument Properties';
  c_View_DsiDiagnosticsContainer = 'DSI Diagnostics Container';
  c_View_DsiPropertiesContainer = 'DSI Properties Container';
  c_View_DsiHealthCheck = 'DSI Health Check';

  c_View_MS2 = 'MS2';
  c_View_MS2Diagnostics = 'MS2 Diagnostics';
  c_View_MS2DiagnosticsADC = 'MS2 Diagnostics ADC';
  c_View_MS2FlightTimeCalibProperties = 'MS2 Flight Time Calib Properties';
  c_View_MS2MassCalibProperties = 'MS2 Mass Calib Properties';
  c_View_MS2Properties = 'MS2 Properties';
  c_View_MS2DiagnosticsContainer = 'MS2 Diagnostics Container';
  c_View_MS2PropertiesContainer = 'MS2 Properties Container';
  c_View_MS2HealthCheck = 'MS2 Health Check';
  c_View_MS2Diagram = 'MS2 Diagram';
  c_View_MS2DiagramContainer = 'MS2 Diagram Container';

  c_View_SpectrometerDiagram = 'Spectrometer Diagram';
  c_View_SpectrometerDiagramContainer = 'Spectrometer Diagram Container';

  c_View_DetCalFactorsRun = 'Detector Calibration Factors Run';
  c_View_DetCalFactorsStatus = 'Detector Calibration Factors Status';
  c_View_DetCalFactorsProperties = 'Detector Calibration Factors Properties';
  c_View_DetCalFactorsImage = 'Detector Calibration Factors Image';
  c_View_DetCalFactorsLog = 'Detector Calibration Factors Log';
  c_View_DetCalFactorsPropertiesContainer = 'Detector Calibration Factors Properties Container';
  c_View_DetCalFactorsChargeCompProperties = 'Detector Calibration Factors Charge Comp Properties';
  c_View_DetCalFactorsChargeCompPropertiesContainer = 'Detector Calibration Factors Charge Comp Properties Container';

  c_View_Aperture = 'Aperture';
  c_View_ApertureDiagnostics = 'Aperture Diagnostics';
  c_View_ApertureDiagnosticsContainer = 'Aperture Diagnostics Container';

  c_View_Aperture2 = 'Aperture-2';
  c_View_Aperture2Diagnostics = 'Aperture-2 Diagnostics';
  c_View_Aperture2DiagnosticsContainer = 'Aperture-2 Diagnostics Container';

  c_View_EnergySlit = 'Energy Slit';

  // Tools
  c_View_SettingsEditor = 'Settings Editor';

  c_View_Outgas = 'Outgas Conditioning';
  c_View_OutgasProperties = 'Outgas Conditioning Properteis';
  c_View_OutgasContainer = 'Outgas Conditioning Container';
  c_View_OutgasPreview = 'Outgas Preview';
  c_View_OutgasPreviewContainer = 'Outgas Preview Container';

  c_View_TestHardware = 'Test Hardware';
  c_View_TestHardwareContainer = 'Test Hardware Container';

  c_View_HealthCheck = 'Health Check';
  c_View_HealthCheckEditor = 'Health Check Editor';

  c_View_HistoryData = 'History Data';
  c_View_HistoryPlot = 'History Plot';

  c_View_HistoryChartData = 'History Chart Data';
  c_View_HistoryChartPlot = 'History Chart Plot';
  c_View_HistoryChartContainer = 'History Chart Container';
  c_View_HistoryChartProp = 'History Chart Properties';
  c_View_HistoryChartPropContainer = 'History Chart Properties Container';

  c_View_ResourceMonitor = 'Resource Monitor';
  c_View_ResourceMonitorContainer = 'Resource Monitor Container';

  c_View_DatabaseMonitor = 'Database Monitor';

  c_View_TuningChartPlot = 'Tuning Chart Plot';
  c_View_TuningChartContainer = 'Tuning Chart Container';
  c_View_TuningChartProp = 'Tuning Chart Properties';
  c_View_TuningChartPropContainer = 'Tuning Chart Properties Container';

  c_View_AutoToolCoffeeTimer = 'CoffeeTimer';
  c_View_AutoToolCoffeeTimerContainer = 'CoffeeTimer Container';

  c_View_Empty = 'Empty';

  //////////////////////////////////////////////////////////////////////////////
  // App - Definitions
  //////////////////////////////////////////////////////////////////////////////

  // Stage
  c_Stage_PositionXInMm = 'Stage Position X (mm)';
  c_Stage_PositionYInMm = 'Stage Position Y (mm)';
  c_Stage_PositionZInMm = 'Stage Position Z (mm)';
  c_Stage_PositionRInDeg = 'Stage Position R (deg)';
  c_Stage_PositionTInDeg = 'Stage Position T (deg)';
  c_State_ZalarRotationSpeedInRpm = 'Zalar Rotation Speed (rpm)';

  // Data Manager
  c_DataMan_AcqFileName = 'Acquisition Filename';
  c_DataMan_UserName = 'User Name';
  c_DataMan_Comment = 'Auto  Comment';

  // Acquisition
  c_Acq_AcqusitionType = 'Acquire Type';
  c_Acq_PrimaryGunType = 'Gun Type';
//  c_Acq_PrimaryGunParticle = 'Gun Particle';
  c_Acq_PrimaryGunSetting = 'Gun Setting';
  c_Acq_PrimaryGunSettingActive = 'Gun Setting Active';
  c_Acq_StartMassInAmu = 'Start Mass (amu)';
  c_Acq_EndMassInAmu = 'End Mass (amu)';
  c_Acq_AcqLimitMode = 'Acq Limit Mode';
  c_Acq_CyclesToAcquire = 'Cycles';
  c_Acq_FramesToAcquire = 'Frames';
  c_Acq_TimePerFrameInSec = 'Time per Frame (s)';

  c_Acq_ChargeCompActive = 'Charge Comp Active';
  c_Acq_ENeutActive = 'E-Neut Active';
  c_Acq_ENeutDCBeamActive = 'E-Neut DC Beam Active';
  c_Acq_ENeutSetting = 'E-Neut Setting';
  c_Acq_ENeutSettingActive = 'E-Neut Setting Active';
  c_Acq_INeutActive = 'I-Neut Active';
  c_Acq_INeutDCBeamActive = 'I-Neut DC Beam Active';
  c_Acq_INeutSetting = 'I-Neut Setting';
  c_Acq_INeutSettingActive = 'I-Neut Setting Active';

  c_Acq_PulsedSedActive = 'Pulsed SED Active';
  c_Acq_RasterType = 'Raster Pattern';
  c_Acq_RasterResolution = 'Raster Resolution';
//  c_Acq_DosePulseWidthInNsec = 'Dose Pulse Width(nSec)';
//  c_Acq_DoseDcCurrentInNamp = 'Dose DC Current(nA)';
  c_Acq_DetectorScanPattern = 'Detector Scan Pattern';
  c_Acq_DetectorScanImageModeStartPos = 'Detector Scan Image Mode Start Pos';
  c_Acq_TimePerChannelInPsec = 'Time Per Channel (pSec)';
  c_Acq_EstimatedCyclePeriodInUSec = 'Estimated Cycle Period (us)';

  c_Acq_PhasedProfileActive = 'Phased Profile Active';
  c_Acq_InterleavedSputterActive = 'Interleaved Phase Active';
  c_Acq_MosaicMapActive = 'Mosaic Active';
  c_Acq_MassCalibrationString = 'Mass Calibration String';

  //MSMS
  c_Acq_MS2Active = 'MSMS Active';
  c_Acq_MS2PrecursorMassInAmu = 'MSMS PrecursorMassInAmu';
  c_Acq_MS2DutyCycle = 'MSMS Duty Cycle';
  c_Acq_MS2MassCalibrationString = 'MS2 Mass Calibration String';

  // Phased
  c_Acq_SputterPhaseActive = 'Sputter Phase Active';
  c_Acq_SputterGunType = 'Sputter Gun Type';
  c_Acq_SputterGunSetting = 'Sputter Gun Setting';
  c_Acq_SputterGunSettingActive = 'Sputter Gun Setting Active';
  c_Acq_CoSputterActive = 'CoSputter Active';
  c_Acq_CoSputterGunType = 'CoSputter Gun Type';
  c_Acq_CoSputterGunSetting = 'CoSputter Gun Setting';
  c_Acq_CoSputterGunSettingActive = 'CoSputter Gun Setting Active';

  c_Acq_SputterPhaseChargeCompActive = 'Sputter Phase Charge Comp Active';
  c_Acq_SputterPhaseZalarActive = 'Sputter Phase Zalar Active';
  c_Acq_SputterPhaseENeutActive = 'Sputter Phase E-Neut Active';
  c_Acq_SputterPhaseENeutSetting = 'Sputter Phase E-Neut Setting';
  c_Acq_SputterPhaseENeutSettingActive = 'Sputter Phase E-Neut Setting Active';
  c_Acq_SputterPhaseINeutActive = 'Sputter Phase I-Neut Active';
  c_Acq_SputterPhaseINeutSetting = 'Sputter Phase I-Neut Setting';
  c_Acq_SputterPhaseINeutSettingActive = 'Sputter Phase I-Neut Setting Active';
  c_Acq_SampleBiasType = 'Sample Bias Type';
  c_Acq_SputterTime = 'Sputter Time (s)';

  c_Acq_ChargeCompPhaseActive = 'Charge Comp Phase Active';
  c_Acq_ChargeCompPhaseENeutActive = 'Charge Comp Phase E-Neut Active';
  c_Acq_ChargeCompPhaseENeutSetting = 'Charge Comp Phase E-Neut Setting';
  c_Acq_ChargeCompPhaseENeutSettingActive = 'Charge Comp Phase E-Neut Setting Active';
  c_Acq_ChargeCompPhaseINeutActive = 'Charge Comp Phase I-Neut Active';
  c_Acq_ChargeCompPhaseINeutSetting = 'Charge Comp Phase I-Neut Setting';
  c_Acq_ChargeCompPhaseINeutSettingActive = 'Charge Comp Phase I-Neut Setting Active';
  c_Acq_ChargeCompTime = 'Charge Comp Time (s)';

  c_Acq_AcqPhaseSettleTime = 'Acq Phase Settle Time (s)';
  c_Acq_SputterPhaseSettleTime = 'Sputter Phase Settle Time (s)';
  c_Acq_ChargeCompPhaseSettleTime = 'Charge Comp Phase Settle Time (s)';

  // Interleaved
  c_Acq_SputterPulseActive = 'Sputter Pulse Active';
  c_Acq_ChargeCompDutyCycleInPct = 'Target Charge Comp Duty Cycle (%)';
  c_Acq_ActualChargeCompDutyCycleInPct = 'Actual Charge Comp Duty Cycle (%)';
  c_Acq_SputterDutyCycleInPct = 'Target Sputter Duty Cycle (%)';
  c_Acq_ActualSputterDutyCycleInPct = 'Actual Sputter Duty Cycle (%)';

  // Mosaic
  c_Acq_MosaicCurrentTile = 'Current Tile';
  c_Acq_MosaicTilesInX = 'Number Of Tiles X';
  c_Acq_MosaicTilesInY = 'Number Of Tiles Y';
  c_Acq_MosaicTileSizeInMm = 'Tile Size (mm)';
  c_Acq_MosaicPositionLowerLeftXInMm = 'Lower Left Stage Position X (mm)';
  c_Acq_MosaicPositionLowerLeftYInMm = 'Lower Left Stage Position Y (mm)';
  c_Acq_MosaicPositionCenterXInMm = 'Center Stage Position X (mm)';
  c_Acq_MosaicPositionCenterYInMm = 'Center Stage Position Y (mm)';
  c_Acq_MosaicDisplayResolution = 'Display Resolution';
  c_Acq_MosaicRotationInDeg = 'Rotation (deg)';
  c_Acq_MosaicInactiveTiles = 'Inactive Tile';

  // Auto Z
  c_AutoZ_MinZHeightInMm = 'Min Z Height (mm)';
  c_AutoZ_MaxZHeightInMm = 'Max Z Height (mm)';
  c_AutoZ_AcqTimePerStepInSec = 'Acq Time/Step (sec)';
  c_AutoZ_ToleranceInPixels = 'Tolerance (pixels)';
  c_AutoZ_RasterSizeInUm = 'RasterSize (um)';
  c_AutoZ_MaxNumberOfSteps = 'Max Number Of Steps';
  c_AutoZ_CentroidAlgorithm = 'Centroid Algorithm';
  c_AutoZ_Threshold = 'Threshold';
  c_AutoZ_MinNoOfNonZeroPoints= 'Min Non-zero Points';
  c_AutoZ_ZHeightScaleFactorInMmPerPixel = 'Z Height Scale Factor(mm/pixel)';
  c_AutoZ_TransferLensVoltage = 'Transfer Lens 1(V)';
  c_AutoZ_MotionPolarity = 'Motion Polarity';
  c_AutoZ_CenteringAxis = 'Centering Axis';
  c_AutoZ_CdInForAutoZ = 'CD In For Auto Z';

  // Detector Calibration Factors
  c_DetCalFactors_CalibrationFileName = 'Calibration  File Name';
  c_DetCalFactors_ImageSizeInPixels = 'Image Size (pixels)';

  // Gun Base
  c_GunBase_PrimaryGunParticle = 'Gun Particle';
  c_GunBase_PulseWidthInNSec = 'Pulse Width (nSec)';
  c_GunBase_DcCurrentInNAmp = 'DC Current (nA)';
  c_GunBase_BeamSizeInNm = 'Beam Size (nm)';
  c_GunBase_FractionalBeamComposition = 'Fractiona lBeam Composition';
  c_GunBase_SputterRateInUmCubedPerNaPerSec = 'SputterRate (um^3/nA/sec)';

  // PHI LMIG
  c_PhiLMIG_BeamEnergyInV = 'Beam Energy (V)';
  c_PhiLMIG_HeaterCurrInA = 'Heater (A)';
  c_PhiLMIG_SuppressorInV = 'Suppressor (V)';
  c_PhiLMIG_ExtractorInV = 'Extractor (V)';
  c_PhiLMIG_Lens1InV = 'Lens 1 (V)';
  c_PhiLMIG_Lens2InV = 'Lens 2 (V)';
  c_PhiLMIG_Lens2DCInV = 'Lens 2 DC (V)';
  c_PhiLMIG_Stig1CenterX = 'Stigmator 1 Steering X';
  c_PhiLMIG_Stig1CenterY = 'Stigmator 1 Steering Y';
  c_PhiLMIG_Stig1Amplitude = 'Stig 1';
  c_PhiLMIG_Stig2CenterX = 'Stigmator 2 Steering X';
  c_PhiLMIG_Stig2CenterY = 'Stigmator 2 Steering Y';
  c_PhiLMIG_Stig2Amplitude = 'Stig 2';
  c_PhiLMIG_RasterSizeCalibration = 'Raster Size Calibration';
  c_PhiLMIG_RasterSizeInUm = 'Raster Size (um)';
  c_PhiLMIG_RasterOffsetXinUm = 'Raster Offset X (um)';
  c_PhiLMIG_RasterOffsetYinUm = 'Raster Offset Y (um)';
  c_PhiLMIG_QuadOffsetX = 'Beam Steering X';
  c_PhiLMIG_QuadOffsetY = 'Beam Steering Y';
  c_PhiLMIG_QuadToOct = 'Quad to Oct Ratio';
  c_PhiLMIG_RotationInDeg = 'Rotation (deg)';
  c_PhiLMIG_TiltXInDeg = 'Tilt X (deg)';
  c_PhiLMIG_TiltYInDeg = 'Tilt Y (deg)';
  c_PhiLMIG_TrapezoidalCorrX = 'Trapezoidal Correction X';
  c_PhiLMIG_TrapezoidalCorrY = 'Trapezoidal Correction Y';
  c_PhiLMIG_ApertureMotorPositionXInMm = 'TargetApertureX(mm)';
  c_PhiLMIG_ApertureMotorPositionYInMm = 'TargetApertureY(mm)';
  c_PhiLMIG_LmigBlankerAmplitudeInV = 'LMIG Blanker Amplitude (V)';
  c_PhiLMIG_LmigBlankerAmplDcInV = 'LMIG Blanker Amplitude DC (V)';
  c_PhiLMIG_LmigBlankerWidth = 'LMIG Blanker Width';
  c_PhiLMIG_LmigBuncherInV = 'LmigBuncher';
  c_PhiLMIG_LmigStaticInV = 'LmigStatic';
  c_PhiLMIG_LmigStaticDcInV = 'LmigStaticDC';
  c_PhiLMIG_ChicaneAmplInV = 'Chicane_Ampl';
  c_PhiLMIG_ChicaneRatio = 'Chicane_Ratio';
  c_PhiLMIG_ChicaneSteeringXInV = 'Lens 2 (Chicane) Steering X';
  c_PhiLMIG_ChicaneYDeltaInV = 'Lens 2 (Chicane) Steering Y Delta';
  c_PhiLMIG_QuadBlankerAmplitudeInV = 'Quad Blanker Amplitude';

  c_PhiLMIG_MassCalInterceptInUSec = 'MassCalInterceptInUSec';
  c_PhiLMIG_QuadBlankerStartTimeInUs = 'Quad Blanker Start Time (uSec)';
  c_PhiLMIG_QuadBlankerDurationInUs = 'Quad Blanker Duration (uSec)';
  c_PhiLMIG_BuncherStartTimeInUs = 'Buncher Start Time (uSec)';
  c_PhiLMIG_LmigBlankerStartTimeInUs = 'LMIG Blanker Start Time (uSec)';
  c_PhiLMIG_LmigBlankerDurationInUs = 'LMIG Blanker Duration (uSec)';
  c_PhiLMIG_PrimaryTiltCorrFactorXInPsPerUm = 'PrimaryTiltCorrFactorXInPsPerUm';
  c_PhiLMIG_PrimaryTiltCorrFactorYInPsPerUm = 'PrimaryTiltCorrFactorYInPsPerUm';

  // C60-20kV Gun
  c_C6020kV_AnodeEnergyInV = 'Anode Energy (V)';
  c_C6020kV_RasterSizeCalibration = 'Raster Size Calibration';
  c_C6020kV_RasterSizeInUm = 'Raster Size (um)';
  c_C6020kV_RasterOffsetXInUm = 'Raster Offset X(um)';
  c_C6020kV_RasterOffsetYInUm = 'Raster Offset Y(um)';
  c_C6020kV_GridVoltageInV = 'Grid Voltage (V)';
  c_C6020kV_RepellorVoltageInV = 'Repellor Voltage (V)';
  c_C6020kV_ExtractorVoltageInV = 'Extractor Voltage (V)';
  c_C6020kV_EmissionCurrentInMa = 'Emission Current (mA)';
  c_C6020kV_FilamentCurrentInA = 'Filament Current Limit (A)';
  c_C6020kV_WienFilterInV = 'Wien Filter (V)';
  c_C6020kV_Lens2VoltageInKv = 'Lens 2 Voltage (kV)';
  c_C6020kV_Steering1YInV = 'Steering 1 Y (V)';
  c_C6020kV_Steering2XInV = 'Steering 2 X (V)';
  c_C6020kV_Steering2YInV = 'Steering 2 Y (V)';
  c_C6020kV_StigmatorAmplitudeInV = 'Stigmator Amplitude (V)';
  c_C6020kV_StigmatorAngleInDeg = 'Stigmator Angle (deg)';
  c_C6020kV_BuncherInV = 'C60 Buncher (V)';
  c_C6020kV_Pulser1VoltageInV = 'Pulser 1 Voltage (V)';
  c_C6020kV_Pulser2VoltageInV = 'Pulser 2 Voltage (V)';
  c_C6020kV_BlankingVoltageInV = 'Blanking Voltage (V)';
  c_C6020kV_ApertureName = 'Aperture Name';
  c_C6020kV_AperturePositionInMm = 'Aperture Position(mm)';
  c_C6020kV_QuadOffsetX = 'Quad Offset X';
  c_C6020kV_QuadOffsetY = 'Quad Offset Y';
  c_C6020kV_Stig1Amplitude = 'Stig 1';
  c_C6020kV_Stig1CenterX = 'Stigmator 1 Steering X';
  c_C6020kV_Stig1CenterY = 'Stigmator 1 Steering Y';
  c_C6020kV_Stig2Amplitude = 'Stig 2';
  c_C6020kV_Stig2CenterX = 'Stigmator 2 Steering X';
  c_C6020kV_Stig2CenterY = 'Stigmator 2 Steering Y';
  c_C6020kV_RotationInDeg = 'Rotation (deg)';
  c_C6020kV_TiltXInDeg = 'Tilt X (deg)';
  c_C6020kV_TiltYInDeg = 'Tilt Y (deg)';

  c_C6020kV_MassCalInterceptInUSec = 'C60 MassCalInterceptInUSec';
  c_C6020kV_C60Pulser1StartTimeInUs = 'C60 C60Pulser1 Start Time (uSec)';
  c_C6020kV_C60Pulser1DurationInUs = 'C60 C60Pulser1 Duration (uSec)';
  c_C6020kV_C60Pulser2StartTimeInUs = 'C60 C60Pulser2 Start Time (uSec)';
  c_C6020kV_C60Pulser2DurationInUs = 'C60 C60Pulser2 Duration (uSec)';
  c_C6020kV_BuncherStartTimeInUs = 'C60 Buncher Start Time (uSec)';
  c_C6020kV_PrimaryTiltCorrFactorXInPsPerUm = 'C60 PrimaryTiltCorrFactorXInPsPerUm';
  c_C6020kV_PrimaryTiltCorrFactorYInPsPerUm = 'C60 PrimaryTiltCorrFactorYInPsPerUm';

  // Cesium Gun
  c_Cesium_BeamEnergyInV = 'Beam Energy (V)';
  c_Cesium_FritPowerInW = 'Frit Power(W)';
  c_Cesium_OvenTempInC = 'Oven Temp(C)';
  c_Cesium_ControlElectrodeVoltageInV = 'Control Delta(V)';
  c_Cesium_ExtractorVoltageInV = 'Extractor (V)';
  c_Cesium_BlankerVoltageInV = 'Blanker(V)';
  c_Cesium_CondenserXSteeringInPercent = 'Condenser X(%)';
  c_Cesium_CondenserYSteeringInPercent = 'Condenser Y(%)';
  c_Cesium_CondenserVoltageInV = 'Condenser(V)';
  c_Cesium_ObjectiveXSteeringInPercent = 'Objective Steering X(%)';
  c_Cesium_ObjectiveYSteeringInPercent = 'Objective Steering Y(%)';
  c_Cesium_ObjectiveVoltageInV = 'Objective(V)';
  c_Cesium_ApertureXSteeringInPercent = 'Aperture Steering X(%)';
  c_Cesium_ApertureYSteeringInPercent = 'Aperture Steering Y(%)';
  c_Cesium_OffsetDeflectionCorrection = 'Offset Deflection Correction(%)';
  c_Cesium_RasterSizeInUm = 'Raster Size (um)';
  c_Cesium_RasterOffsetXInUm = 'Raster Offset X(um)';
  c_Cesium_RasterOffsetYInUm = 'Raster Offset Y(um)';
  c_Cesium_StigmationAInPercent = 'Stigmator A(%)';
  c_Cesium_StigmationBInPercent = 'Stigmator B(%)';

  // GCIB
  c_GCIB_BeamEnergyInV = 'Beam Energy (V)';
  c_GCIB_IonizationVoltInV = 'Ionization (V)';
  c_GCIB_ExtractorVoltInKv = 'Extractor (kV)';
  c_GCIB_ObjectiveInPercent = 'Objective (%)';
  c_GCIB_FocusInPercent = 'Focus (%)';
  c_GCIB_WienVoltInV = 'Wien Deflection (V)';
  c_GCIB_BendVoltInV = 'Bend (V)';
  c_GCIB_MagnetInA = 'Magnet (A)';
  c_GCIB_EmissionInMa = 'Emission (mA)';
  c_GCIB_PressureInKpa = 'Target Pressure (kPa)';
  c_GCIB_IonCurrentInUa = 'Ion Current (uA)';
  c_GCIB_SputterRateInAngPerMin = 'Sputter Rate (A/min)';
  c_GCIB_RasterSizeCalibration = 'Raster Size Calibration';
  c_GCIB_RasterSizeInUm = 'Raster Size (um)';
  c_GCIB_RasterXOffsetInUm = 'Raster Offset (um) X';
  c_GCIB_RasterYOffsetInUm = 'Raster Offset (um) Y';
  c_GCIB_QuadOffsetX = 'Quad Offset X';
  c_GCIB_QuadOffsetY = 'Quad Offset Y';
  c_GCIB_Stig1Amplitude = 'Stig 1';
  c_GCIB_Stig1CenterX = 'Stigmator 1 Steering X';
  c_GCIB_Stig1CenterY = 'Stigmator 1 Steering Y';
  c_GCIB_Stig2Amplitude = 'Stig 2';
  c_GCIB_Stig2CenterX = 'Stigmator 2 Steering X';
  c_GCIB_Stig2CenterY = 'Stigmator 2 Steering Y';
  c_GCIB_RotationInDeg = 'Rotation (deg)';
  c_GCIB_TiltXInDeg = 'Tilt X (deg)';
  c_GCIB_TiltYInDeg = 'Tilt Y (deg)';

  // Gas Gun
  c_GasGun_IonCurrent = 'Ion Current(uA)';
  c_GasGun_SputterRate = 'Sputter Rate(A/min)';
  c_GasGun_IonSpecies = 'Ion Species';
  c_GasGun_BeamEnergyInV = 'Beam Energy (V)';
  c_GasGun_GridV = 'Grid Supply (V)';
  c_GasGun_TargetEmission = 'Target Emission Current(mA)';
  c_GasGun_Condenser = 'Condenser(V)';
  c_GasGun_Objective = 'Objective(V)';
  c_GasGun_BendVoltage = 'Bend(V)';
  c_GasGun_FloatV = 'Float(V)';
  c_GasGun_RasterSizeInUm = 'Raster Size (um)';
  c_GasGun_XRasterOffsetInUm = 'X Raster Offset (um)';
  c_GasGun_YRasterOffsetInUm = 'Y Raster Offset (um)';
  c_GasGun_FloatEnable = 'Float Enable';
  c_GasGun_DeflectionBiasV = 'Deflection Bias(V)';
  c_GasGun_PressureInMpa = 'Target Pressure (mPa)';
  c_GasGun_Neutralize = 'Neutralize';

  // Ion Neut
  c_IonNeut_BiasVoltageInV = 'Bias (V)';
  c_IonNeut_LensVoltageInV = 'Lens (V)';
  c_IonNeut_EmissionCurrentInMa = 'Emission (mA)';

  // E-Gun Neut
  c_EGunNeut_BiasInV = 'Bias (V)';
  c_EGunNeut_ExtractorInV = 'Extractor (V)';
  c_EGunNeut_XSteeringPercent = 'X Steering (%)';
  c_EGunNeut_YSteeringPercent = 'Y Steering (%)';
  c_EGunNeut_EmissionInUa = 'Emission Current (uA)';
  c_EGunNeut_FilamentInA = 'Filament Current (A)';
  c_EGunNeut_UseEmissionControlAutoMode = 'Emission Current Lock';
  c_EGunNeut_Gain = 'Gain';
  c_EGunNeut_TimeStepInMs = 'Time/Step (ms)';
  c_EGunNeut_RampRateInAPerS = 'Ramp Rate (A/s)';

  // DSI
  c_DSI_MassCalSlopeInUSecPerSqrtAMU = 'MassCalSlopeInUSecPerSqrtAMU';
  c_DSI_PostEsaMassCalSlope = 'Post ESA Mass Cal Slope';
  c_DSI_PostEsaMassCalInterceptOffsetInUSec = 'Post ESA Mass Calibrate Intercept Offset (us)';
  c_DSI_HighMassStartMassCalSlope = 'High Mass Start Mass Cal Slope';
  c_DSI_HighMassStartMassCalInterceptOffsetInUSec = 'High Mass Start Mass Calibrate Intercept Offset (us)';
  c_DSI_HighMassStopMassCalSlope = 'High Mass Stop Mass Cal Slope';
  c_DSI_HighMassStopMassCalInterceptOffsetInUSec = 'High Mass Stop Mass Calibrate Intercept Offset (us)';
  c_DSI_DetectorScanningOn = 'Detector Scanning On';    
  c_DSI_DetectorCalibrationFilePath = 'Detector Calibration File Path';

  // Sequencer
  c_Seq_DetectorAdvanceStartTimeInUs = 'Detector Advance Start Time (uSec)';
  c_Seq_DetectorAdvanceDurationInUs = 'Detector Advance Duration (uSec)';

  // MS2
  c_MS2_PrecursorMassCalSlope = 'Precursor Selector Mass Cal Slope';
  c_MS2_PrecursorVoltageInV = 'Precursor Selector Voltage (V)';
  c_MS2_BlankerVoltageInV = 'Blanker Voltage (V)';
  c_MS2_DMCPPhosphorInV = 'DMCP Phosphor (V)';
  c_MS2_DMCPDetectorInV = 'DMCP Detector (V)';
  c_MS2_WidthFactor = 'Width Factor';
  c_MS2_AngleInDeg = 'Angle (deg)';
  c_MS2_DistanceToBuncherDistanceInMm = 'Distance To Buncher (mm)';
  c_MS2_VelocityFactor = 'Velocity Factor';
  c_MS2_PreCursorOffsetInUs = 'Precursor Offsets (us)';
  c_MS2_PreCursorDifferentialOffsetInUs = 'Precursor Differential Offsets (us)';
  c_MS2_BuncherOffsetInUs = 'Buncher Offset (us)';
  c_MS2_TDCOffsetInUs = 'TDC Offset (us)';
  c_MS2_SampleBiasInV = 'Sample Bias (V)';
  c_MS2_BuncherDurationInUs = 'Buncher Duration (us)';
  c_MS2_TDCDurationInUs = 'TDC Duration (us)';
  c_MS2_BuncherVoltageInV = 'Buncher Voltage (V)';
  c_MS2_AccelerationVoltageInKv = 'Acceleration Voltage (kV)';
  c_MS2_MassCalibBuncherLengthInMm = 'Mass Calib Buncher Length (mm)';
  c_MS2_MassCalibBuncherToGridInMm = 'Mass Calib Buncher To Grid (mm)';
  c_MS2_MassCalibGridToAccelerationInMm = 'Mass Calib Grid To Acceleration (mm)';
  c_MS2_MassCalibAccelerationLengthInMm = 'Mass Calib Acceleration Length (mm)';
  c_MS2_MassCalibPreCursorKEInKv = 'Mass Calib Precursor KE (kV)';
  c_MS2_MassCalibBuncherVoltageInV = 'Mass Calib Buncher Voltage (V)';
  c_MS2_MassCalibAccelerationVoltageInKv = 'Mass Calib Acceleration Voltage (kV)';
  c_MS2_MassCalibOffsetInUs = 'Mass Calib Offset (us)';
  c_MS2_MassCalibBuncherCenterOffsetInUs = 'Mass Calib Buncher Center Offset (us)';

  // old obsolete captions - leave them here for backward compatiabilty for old settings
  c_MS2_PickerOffsetInUs = 'Precursor Offset (us)';
  c_MS2_PickerDifferentialOffsetInUs = 'Precursor Differential Offset (us)';

  // Polarity
  c_Pol_Polarity = 'Polarity';

  c_Pol_PolarityPositive = 'Positive (+) Ions';
  c_Pol_PolarityNegative = 'Negative (-) Ions';
  c_Pol_PolarityUnknown = 'Unknown';

  // Main
  c_Main_SoftwareProjectName = 'Project Name';
  c_Main_SoftwareVersion = 'Version';

  // Configuration
  c_Config_SystemEx = 'SystemEx';
  c_Config_LMIG1EmitterType = 'LMIG-1 Emitter Type';
  c_Config_LMIG2EmitterType = 'LMIG-2 Emitter Type';
  c_Config_MSMSTesting = 'MSMS Testing Flag';
  c_Config_VacuumMode = 'Vacuum Mode';

  //////////////////////////////////////////////////////////////////////////////
  // Common
  //////////////////////////////////////////////////////////////////////////////

  // Technique
  c_AcqTechniqueTOF = 'TOF';
  c_AcqTechniqueAES = 'AES' ;
  c_AcqTechniqueXPS = 'XPS' ;

  // Acquisiton Types
  c_AcqTypeNone = 'None';
  c_AcqTypeIdle = 'Idle';
  c_AcqTypeSem = 'SEM';
  c_AcqTypeSxi = 'SXI';
  c_AcqTypeSurvey = 'Survey'; // AES
  c_AcqTypeSurvey2 = 'Survey-Q'; // AES
  c_AcqTypeMultiplex = 'Multiplex'; // AES
  c_AcqTypeMultiplex2 = 'Multiplex-Q'; // AES
  c_AcqTypeSpectral = 'Spectrum'; // VP, XPS, TOF
  c_AcqTypeSpectral2 = 'Spectrum-Q'; // VP, XPS, TOF
  c_AcqTypeProfile = 'Profile'; // AES, VP, XPS
  c_AcqTypeProfile2 = 'Profile-Q'; // AES, VP, XPS
  c_AcqTypeAngle = 'Angle'; // VP, XPS
  c_AcqTypeAngle2 = 'Angle-Q'; // VP, XPS
  c_AcqTypeLine = 'Line'; // AES, VP, XPS
  c_AcqTypeLine2 = 'Line-Q'; // AES, VP, XPS
  c_AcqTypeMap = 'Map'; // AES, VP, XPS
  c_AcqTypeMap2 = 'Map-Q'; // AES, VP, XPS
  c_AcqTypePhasedProfile = 'Phased Profile'; // TOF
  c_AcqTypeInterleavedProfile = 'Interleaved Profile'; // TOF
  c_AcqTypeMosaicMap = 'Mosaic Map'; // TOF
  c_AcqTypeFib = 'FIB';
  c_AcqTypeSps = 'SPS';
  c_AcqTypeIntroPhoto = 'Intro Photo';
  c_AcqTypePhotoLow = 'Std Photo';
  c_AcqTypePhotoHigh = 'AR Photo';
  c_AcqTypePhotoDigital = 'Digital';
  c_AcqTypePlaten = 'Platen';
  c_AcqTypeRefresh = 'Refresh';
  c_AcqTypeBeamSize = 'Beam Size';
  c_AcqTypeBeamPower = 'Beam Power';
  c_AcqTypeBeamCurrent = 'Beam Current';
  c_AcqTypeEms = 'EMS';
  c_AcqTypeChannelSensitivity = 'Channel Sensitivity';
  c_AcqTypeZAlign = 'Z Align';
  c_AcqTypeSxiPreviewImaging = 'SXI Preview';
  c_AcqTypeSxiPreviewIR = 'SXI Image Registration';
  c_AcqTypeRegistration = 'Image Registration';
  c_AcqTypeDetCalFactors = 'Detector Calibration Factors';
  c_AcqTypePreviewImaging = 'SEM Preview';
  c_AcqTypeChamberCamera = 'Sample Camera';
  c_AcqTypeDetectorCamera = 'Detector Camera';

  // Gun Types
  c_GunType_None = 'None';
  c_GunType_LMIG1 = 'LMIG';
  c_GunType_LMIG2 = 'LMIG-2';
  c_GunType_C6020kV = 'C60-20kV';
  c_GunType_GCIB = 'GCIB';
  c_GunType_GasGun = 'Gas Gun';
  c_GunType_Cesium = 'Cesium';
  c_GunType_IonNeutralizer = 'I-Neut';
  c_GunType_EGunNeutralizer = 'E-Neut';

  c_GunParticle_Au1 = 'Au1';
  c_GunParticle_Au2 = 'Au2';
  c_GunParticle_Au3 = 'Au3';
  c_GunParticle_AuPlusPlus = 'Au ++';
  c_GunParticle_Au3PlusPlus = 'Au3 ++';
  c_GunParticle_BiPlus = 'Bi +';
  c_GunParticle_Bi2Plus = 'Bi2 +';
  c_GunParticle_Bi3Plus = 'Bi3 +';
  c_GunParticle_Bi4Plus = 'Bi4 +';
  c_GunParticle_Bi5Plus = 'Bi5 +';
  c_GunParticle_Bi7Plus = 'Bi7 +';
  c_GunParticle_BiPlusPlus = 'Bi ++';
  c_GunParticle_Bi3PlusPlus = 'Bi3 ++';
  c_GunParticle_Bi5PlusPlus = 'Bi5 ++';
  c_GunParticle_GaPlus = 'Ga +';
  c_GunParticle_C60 = 'C60 +';
  c_GunParticle_C60PlusPlus = 'C60 ++';
  c_GunParticle_C60PlusPlusPlus = 'C60 +++';

  // Excitation Source
  c_ExcitationSourceLMIG = 'LMIG';

  // Intro Camera Stations (Different systems can use different stations)
  c_introCam_StationIntro = 'Intro';
  c_introCam_StationPrep = 'Prep';

  // Cursor Modes
  c_AnnotationMode = 'Annotation';
  c_ZoomMode = 'Zoom';
  c_FingerPrintMode = 'Fingerprint';
  c_ElementCursorMode = 'Element Cursor';
  c_EnergyCursorMode = 'Energy Cursor';

  // Viewer orientation types
  c_ViewOrientPortrait = 'Portrait';
  c_ViewOrientLandscape = 'Landscape';
  c_ViewOrientSquare = 'Square';
  c_ViewOrientTall = 'Tall';

  // Table
  c_TableIndicatorColor : TColor = clTeal;
  c_TableIndicatorFontColor : TColor = clWhite;

  // Picker lookup table file name
  c_PickerLookupTableCsvFilename = 'PickerLookupTable.csv';
  
  // Standard sizing
  c_MainPanelWidth = 364;
  c_ViewWidth = 376;
  c_DialogHeight = 400;

  // Default peak id database name
  c_XPSPeakIdDatabaseName = 'xpspidpc21.db';
  c_XPSPeakIdRulebookName = 'XPSPeakIDRuleBook.csv';
  c_AESPeakIdDatabaseName = 'aespid.db';
  c_HXPSPeakIdDatabaseName = 'hxpspidpc.db';

  // Pascal to Torr Ratio values 152Torr = 20265Pa
  c_VacTorrToPascalValue : Double = 20265/152;
  c_VacPascalToTorrValue : Double = 152/20265;

  // Pressure Units
  c_VacPressureUnitTorr = 'Torr';
  c_VacPressureUnitPascal = 'Pascal';

  // Communication Status
  c_CommStatus_Normal = 'Normal';
  c_CommStatus_Failed = 'Failed';
  c_CommStatus_InitRequired = 'Initialization Required';
  c_CommStatus_MovingOrBusy = 'Moving or Busy';
  c_CommStatus_Simulation = 'Simulation';

  // Sample Bias
  c_SampleBiasType_HV = 'HV';
  c_SampleBiasType_Ground = 'GND';
  c_SampleBiasType_GroundwChargeComp = 'GND+Charge Comp';

  //////////////////////////////////////////////////////////////////////////////
  // Common String Defines
  //////////////////////////////////////////////////////////////////////////////
  c_appdefRasterPattern_Flyback = 'Flyback';
  c_appdefRasterPattern_Scatter = 'Scatter';
  c_appdefRasterPattern_NonInterlace = 'Non-Interlaced';
  c_appdefRasterPattern_2Fold = '2-Fold';
  c_appdefRasterPattern_4Fold = '4-Fold';

  // Common Image Plot
  c_IPModeNone = '' ;
  c_IPModeShift ='Move' ;
  c_IPModeFOV = 'Zoom' ;
  c_IPModeGrab = 'Grab' ;
  c_IPModeCalibrate = 'Calibrate' ;
  c_IPModeRotateHorz = 'Rotate Horizontal' ;
  c_IPModeFocus = 'Focus' ;
  c_IPModeStigmation = 'Stigmation' ;
  c_IPModeContrastBrightness = 'Brightness and Contrast' ;
  c_IPModeBrightness = 'Brightness' ;
  c_IPModeContrastStretch = 'Contrast Stretch' ;
  c_IPModeExtractorSteering = 'Extractor Steering' ;
  c_IPModeFocusSteering = 'Focus Steering' ;
  c_IPModeAnnotationShape = 'Annotation Shape' ;
  c_IPModePoint = 'Define Point' ;
  c_IPModeArea = 'Define Area' ;
  c_IPModeLine = 'Define Line' ;
  c_IPModeHp = 'Define HP';
  c_IPModeRegistration = 'Registration Area' ;
  c_IPModeTestAcquire = 'Test Acquire' ;
  c_IPModeMosaicDraw = 'Mosaic Draw' ;
  c_IPModeMosaicErase = 'Mosaic Erase' ;

  // Wafer Map Image Plot
  c_IPModeSelectPosition = 'Select Position';
  c_IPModeSelectDie = 'Select Die';
  c_IPModeMoveToMouse = 'Move to Mouse Click';
  c_IPModeMoveToPosition = 'Move to Position';
  c_IPModeMoveToDieCorner = 'Move to Die Corner';

  //////////////////////////////////////////////////////////////////////////////
  // System Masking
  //////////////////////////////////////////////////////////////////////////////
  c_SysMask_Polarity            = $00000001;       // running polarity switch
  c_SysMask_TimedSputter        = $00000002;       // timed sputter
  c_SysMask_DataAcq             = $00000004;       // running data acquisition
  c_SysMask_VacuumTask          = $00000008;       // running vacuum task
  c_SysMask_Bakeout             = $00000010;       // running bake out
  c_SysMask_MotorNotInitialized = $00000020;       // motor is not initialized
  c_SysMask_MovingStage         = $00000040;       // moving stage (include motor, zalar)
  c_SysMask_MovingPlaten        = $00000080;       // moving platen
  c_SysMask_SampleCurrent       = $00000100;       // reading sample current
  c_SysMask_SEM                 = $00000200;       // running SEM
  c_SysMask_FIB                 = $00000400;       // running FIB
  c_SysMask_PolarityIsPositive  = $00000800;       // Positive Polarity
  c_SysMask_PolarityIsNegative  = $00001000;       // Negative Polarity
  c_SysMask_HotColdActive       = $00002000;       // hot cold stage active
  c_SysMask_GasGunPressure      = $00004000;       // 20-068 pressure reading active

  // Description of system mask states
  c_SysMaskDesc_Polarity        = 'Polarity Switch';
  c_SysMaskDesc_TimedSputter    = 'Timed Sputter';
  c_SysMaskDesc_DataAcq         = 'Acquisition';
  c_SysMaskDesc_VacuumTask      = 'Vacuum Task';
  c_SysMaskDesc_Bakeout         = 'Bake System';
  c_SysMaskDesc_MotorNotInitialized  = 'Motor is Not Initialized';
  c_SysMaskDesc_MovingStage     = 'Move Stage';
  c_SysMaskDesc_MovingPlaten    = 'Move Platen';
  c_SysMaskDesc_SampleCurrent   = 'Read Beam Current';
  c_SysMaskDesc_SEM             = 'Imaging';
  c_SysMaskDesc_FIB             = 'FIB';
  c_SysMaskDesc_PolarityIsPositive = 'Polarity is Positive';
  c_SysMaskDesc_PolarityIsNegative = 'Polarity is Negative';
  c_SysMaskDesc_HotColdActive   = 'Hot Cold Stage';
  c_SysMaskDesc_GasGunPressure  = 'Gas Gun Pressure Reading';

  // Trace Log Level Names
  c_TraceLevelName_Debug = 'Debug';
  c_TraceLevelName_Service = 'Service';
  c_TraceLevelName_Diagnose = 'Diagnose';
  c_TraceLevelName_User = 'User';
  c_TraceLevelName_Off = 'Off';

type
  // Set containing valid atomic numbers (Custom atomic numbers 111-118).
  TAtomicNoSet = set of 1..118;

  // String Array
  TStringArray = array of string;

implementation

end.
