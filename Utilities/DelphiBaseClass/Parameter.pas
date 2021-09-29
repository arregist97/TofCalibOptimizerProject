unit Parameter;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  Parameter.pas
// Created:   on 99-12-27 by John Baker
// Purpose:   This module defines the Parameter base class.  This Parameter
//             class is is the base class from which all other ParameterXXXX
//             classes are derived.
//*********************************************************
// Copyright © 1999 Physical Electronics, Inc.
// Created in 1999 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
///////////////////////////////////////////////////////////////////////////////////////////////////////
interface

uses
  Classes,
  Types,
  StdCtrls,
  IniFiles,
  Registry,
  Controls,
  Graphics,
  Menus,
  RealEdit,
  TrackEdit,
  AppSettings,
  AppSettings_TLB;

const
  c_DefaultHint = '-1';
  c_DefaultValue = 'NAN';
  c_DefaultPrecision = -1;
  c_DefaultMask = $0;
  c_DefaultHelp = 0;
  c_DefaultDivider = ' --------------------------------------------------------- ';

  c_InvalidHandle = -1;
  c_InvalidIndex = -1;
  c_InvalidString = 'NAN';
  c_InvalidFloat = -3.1415926536;

  c_ReadbackNameSuffix = ': Read';
  c_ReadbackHintSuffix = ': Readback';
  c_HistoryNameSuffix = ': History';
  c_TuneNameSuffix = ': Tune';

  c_ColorForegroundEdit = clWindowText;
  c_ColorForegroundLabel = clWindowText;
  c_ColorForegroundReadOnly = clWindowText;
  c_ColorForegroundWarning = clWindowText;
  c_ColorForegroundError = clWindow;

  c_ColorBackgroundEdit = clWindow;
  c_ColorBackgroundLabel = clBtnFace;
  c_ColorBackgroundReadOnly = cl3DLight;
  c_ColorBackgroundWarning = clYellow;
  c_ColorBackgroundError = clRed;

  c_ShapeColorActive = clYellow;
  c_ShapeColorInactive = clInactiveCaptionText;

  c_HightlightActive = clYellow;
  c_HightlightInactive = clBtnFace;
type
  TUserLevel = (ulUser, ulSuperuser, ulService, ulOpen);
  TUserLevelCheck = (ulCheckNone, ulCheckLessThan, ulCheckLessThanOrEqual, ulCheckGreaterThan, ulCheckGreaterThanOrEqual, ulCheckMatchExactly);
  TUserLevelDisplay = (ulDisplayNone, ulDisplayEnable, ulDisplayVisible);

  TParameterType = (ptNone,
                    ptSettings,
                    ptSettingsReadOnly,
                    ptSettingsWriteOnly,
                    ptProperties,
                    ptPropertiesReadOnly,
                    ptPropertiesWriteOnly,
                    ptRegistry,
                    ptRegistryReadOnly,
                    ptRegistryWriteOnly,
                    ptDefaultToSettings);

  TSectionParameterType = (ptSectionNone,
                          ptSectionReadWrite,
                          ptSectionRead,
                          ptSectionWrite);

  TVariantType = (variantValueAsDefault,
                  variantValueAsString,
                  variantValueAsFloat,
                  variantValueAsInt,
                  variantValueAsEnum,
                  variantValueAsFileEnum,
                  variantValueAsBoolean);

  TParameterState = (psOk,
                     psWarning,
                     psOutOfRange,
                     psError);

  TParameterValueState = (pvsNormal,
                          pvsWarning,
                          pvsError);

  TStringFormat = (fmtFixed,
                  fmtGeneral,
                  fmtInteger,
                  fmtScientific,
                  fmtHexadecimal,
                  fmtDateTime);

  THintAsType = (hintAsHint, hintAsString);

  TToControlVisibleMode = (tcVisibleDefault, tcVisibleOn, tcVisibleOff, tcVisibleUserLevel, tcVisibleMask, tcVisibleMaskNot);

  TToControlEnabledMode = (tcEnabledDefault, tcEnabledOn, tcEnabledOff, tcEnabledUserLevel, tcEnabledMask, tcEnabledMaskNot);

  TToControlHintMode = (tcHintDefault, tcHintOn, tcHintOff);

  TUpdateAllViews = procedure(Hint: Integer) of object;

  TParameter = class(TComponent)
  private
    m_BackgroundColor: TColor;
    m_Enabled: Boolean ;
    m_FileParameterType: TParameterType ;
    m_FileGroupId: tAppSettingType;
    m_FileSettingId: Integer;
    m_FileVariantType: TVariantType;
    m_Focus: Boolean ;
    m_ForegroundColor: TColor;
    m_Group: String ;
    m_HelpId: Integer ;
    m_Highlight: Boolean ;
    m_MaskLocal: Integer;
    m_MaskLocalAnd: Integer;
    m_MaskLocalOr: Integer;
    m_MaskLocalNot: Integer;
    m_MaskSystem: Integer;
    m_MaskSystemAnd: Integer;
    m_MaskSystemOr: Integer;
    m_MaskSystemNot: Integer;
    m_MaskDisplay: TUserLevelDisplay ;
    m_Name: String ;
    m_ParameterType: TParameterType ;
    m_SectionParameterType: TSectionParameterType ;
    m_StringFormat: TStringFormat;
    m_SystemLevel: TUserLevel ;
    m_Units: String ;
    m_UserLevel: TUserLevel ;
    m_UserLevelCheck: TUserLevelCheck ;
    m_Visible: Boolean ;

    // Parent Doc reference
    m_ParentDocPtr: TObject;

    procedure SetOnDataReadback(const Value: TNotifyEvent);

    function GetTune(): TParameter;

  protected
    m_Active: Boolean;
    m_Caption: String ;
    m_CaptionLong: String ;
    m_Hint: String ;
    m_HintAs: THintAsType ;
    m_ParameterState: TParameterState; 
    m_ParameterValueState: TParameterValueState;
    m_ParameterTypeHistory: Boolean;
    m_ParameterTypeOutgas: Boolean;
    m_ParameterTypePolarity: Boolean;
    m_ParameterTypeProperties: Boolean;
    m_ParameterTypeSettings: Boolean;
    m_ParameterTypeWobble: Boolean;
    m_ParameterTypeTune: Boolean;
    m_Precision: Integer ;
    m_ReadOnly: Boolean ;
    m_UserLevelDisplay: TUserLevelDisplay ;

    // History
    m_History: TParameter;

    // Tune
    m_Tune: TParameter;

    // Readback
    m_Readback: TParameter;
    m_ReadbackHdwrCtrlName: String;
    m_ReadbackHistDataRateInSec: Integer;
    m_ReadbackMinTimeBetweenReadsInSec: Int64;
    m_ReadbackTimeNextReadAllowed: TDateTime;
    m_OnDataReadback: TNotifyEvent;

    function GetActive(): Boolean;
    function GetBackgroundColor(): TColor; overload; virtual;
    function GetBackgroundColor(DefaultColor: TColor): TColor; overload; virtual;
    function GetCaption(): String; virtual;
    function GetCaptionLong(): String; virtual;
    function GetEnabled(): Boolean; virtual;
    function GetEnabledUserLevel(): Boolean; overload; virtual;
    function GetEnabledUserLevel(UserLevelValue: TUserLevel; UserLevelDisplayValue: TUserLevelDisplay): Boolean; overload; virtual;
    function GetEnabledMask(): Boolean; virtual;
    function GetEnabledUsingMode(Mode: TToControlEnabledMode): Boolean;
    function GetFileGroupId(): tAppSettingType; virtual;
    function GetFileParameterType(): TParameterType; virtual;
    function GetFileSettingId(): Integer; virtual;
    function GetFileVariantType(): TVariantType; virtual;
    function GetFocus(): Boolean; virtual;
    function GetForegroundColor(): TColor; overload; virtual;
    function GetForegroundColor(DefaultColor: TColor): TColor; overload; virtual;
    function GetGroup(): String; virtual;
    function GetHelpId(): Integer; virtual;
    function GetHint(): String; virtual;
    function GetHintUsingUserLevel(HintValue: String; UserLevelValue: TUserLevel): String; virtual;
    function GetHintUsingMode(Mode: TToControlHintMode): String;
    function GetMaskDisplay(): TUserLevelDisplay; virtual;
    function GetName(): String; virtual;
    function GetParameterState(): TParameterState; virtual;
    function GetParameterType(): TParameterType; virtual;
    function GetSectionParameterType(): TSectionParameterType; virtual;
    function GetPrecision(): Integer; virtual;
    function GetSystemLevel(): TUserLevel; virtual;
    function GetUnits(): String; virtual;
    function GetUserLevel(): TUserLevel; virtual;
    function GetUserLevelCheck(): TUserLevelCheck; virtual;
    function GetUserLevelDisplay(): TUserLevelDisplay; virtual;
    function GetVisible(): Boolean; virtual;
    function GetVisibleUserLevel(): Boolean; virtual;
    function GetVisibleMask(): Boolean; virtual;
    function GetVisibleUsingMode(Mode: TToControlVisibleMode): Boolean;

    function GetParameterTypeProperties(): Boolean;
    function GetParameterTypeSettings(): Boolean;
    function GetParameterTypeHistory(): Boolean;
    function GetParameterTypeTune(): Boolean;

    function ValidUserLevel(UserLevelValue: TUserLevel): Boolean; overload;
    function ValidUserLevel(): Boolean; overload;

    function GetValueAsFloat(): Double; virtual;
    function GetValueAsInt(): Integer; virtual;
    function GetValueAsSingle(): Single; virtual;
    function GetValueAsString(): String; virtual;
    function GetValueAsUnits(): String; virtual;
    function GetValueAsVariant(): OleVariant; virtual;

    procedure SetActive(const Value: Boolean);
    procedure SetBackgroundColor(const Value: TColor); virtual;
    procedure SetCaption(const Value: String); virtual;
    procedure SetCaptionLong(const Value: String); virtual;
    procedure SetEnabled(const Value: Boolean); virtual;
    procedure SetFileGroupId(const Value: tAppSettingType); virtual;
    procedure SetFileParameterType(const Value: TParameterType); virtual;
    procedure SetFileSettingId(const Value: Integer); virtual;
    procedure SetFileVariantType(const Value: TVariantType); virtual;
    procedure SetFocus(const Value: Boolean); virtual;
    procedure SetForegroundColor(const Value: TColor); virtual;
    procedure SetGroup(const Value: String); virtual;
    procedure SetHighlight(const Value: Boolean); virtual;
    procedure SetHint(Value: String = c_DefaultHint); virtual;
    procedure SetMaskDisplay(const Value: TUserLevelDisplay); virtual;
    procedure SetName(const Value: String); reintroduce; virtual;
    procedure SetParameterState(const Value: TParameterState); virtual;
    procedure SetParameterType(const Value: TParameterType); virtual;
    procedure SetSectionParameterType(const Value: TSectionParameterType); virtual;
    procedure SetPrecision(const Value: Integer); virtual;
    procedure SetSystemLevel(const Value: TUserLevel); virtual;
    procedure SetUnits(const Value: string); virtual;
    procedure SetUserLevel(const Value: TUserLevel); virtual;
    procedure SetUserLevelCheck(const Value: TUserLevelCheck); virtual;
    procedure SetUserLevelDisplay(const Value: TUserLevelDisplay); virtual;
    procedure SetVisible(const Value: Boolean); virtual;

    procedure SetValueAsFloat(FloatValue: Double); virtual;
    procedure SetValueAsInt(IntValue: Integer); virtual;
    procedure SetValueAsSingle(SingleValue: Single); virtual;
    procedure SetValueAsString(StringValue: String); virtual;
    procedure SetValueAsUnits(StringValue: String); virtual;
    procedure SetValueAsVariant(VariantValue: OleVariant); virtual;

    procedure SetReadbackTimeNextReadAllowed();

    procedure BuildPopUpMenu(PopUpMenu: TPopUpMenu); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy() ; override ;
    procedure Initialize(Sender: TParameter); virtual ;
    function Changed(): Boolean; virtual;
    procedure SaveInit(); virtual;
    procedure SaveUndo(); virtual;
    procedure Undo(); virtual;

    procedure CopyValueFromSetting(FromIniFile: TCustomIniFile; ToIniFile: TCustomIniFile); virtual;
    procedure ReadValueFromAcq(AppSettings: IAppSettings); virtual;
    procedure ReadValueFromSetting(IniFile: TCustomIniFile); overload; virtual;
    procedure ReadValueFromSetting(IniFile: TCustomIniFile; TagName: String); overload; virtual;
    procedure ReadValueFromRegistry(RegIniFile: TRegIniFile); virtual;
    procedure ReadCaptionFromSetting(IniFile: TCustomIniFile); overload; virtual;
    procedure ReadHintFromSetting(IniFile: TCustomIniFile); overload; virtual;

    procedure WriteValueToAcq(AppSettings: IAppSettings); overload; virtual;
    procedure WriteValueToAcq(Section: String; AppSettings: TAppSettings); overload; virtual;
    procedure WriteValueToSetting(IniFile: TCustomIniFile); overload; virtual;
    procedure WriteValueToSetting(IniFile: TCustomIniFile; TagName: String); overload; virtual;
    procedure WriteValueToSetting(var FileId: TextFile); overload; virtual;
    procedure WriteValueToSetting(var FileId: TextFile; TagName: String); overload; virtual;
    procedure WriteValueToRegistry(RegIniFile: TRegIniFile); virtual;
    procedure WriteCaptionToSetting(IniFile: TCustomIniFile); overload; virtual;
    procedure WriteHintToSetting(IniFile: TCustomIniFile); overload; virtual;

    // AppSettings Conversion
    function AppSettingsToBoolean(AppSettings: TAppSettings; Section: String): Boolean; virtual;
    function AppSettingsToEnum(AppSettings: TAppSettings; Section: String): Integer; virtual;
    function AppSettingsToFloat(AppSettings: TAppSettings; Section: String): Double; virtual;
    function AppSettingsToString(AppSettings: TAppSettings; Section: String): String; virtual;

    function AppSettingsToBooleanArray(AppSettings: TAppSettings; Section: String): TBooleanDynArray; virtual;
    function AppSettingsToEnumArray(AppSettings: TAppSettings; Section: String): TIntegerDynArray; virtual;
    function AppSettingsToFloatArray(AppSettings: TAppSettings; Section: String): TDoubleDynArray; virtual;
    function AppSettingsToIntArray(AppSettings: TAppSettings; Section: String): TIntegerDynArray; virtual;
    function AppSettingsToStringArray(AppSettings: TAppSettings; Section: String): TStringDynArray; virtual;

    // UI Update Methods
    procedure ToCaption(LabelPtr: TLabel; UseLongCaption: Boolean = False;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToCaption(LabelPtr: TLabel; CustomCaption: String;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToCaption(LabelPtr: TLabel;
      EnabledMode: TToControlEnabledMode;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToCaption(EditPtr: TEdit;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToControl(ControlPtr: TControl;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToControl(MenuItemPtr: TMenuItem;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault); overload;
    procedure ToControl(ControlPtr: TControl;
      UserLevel: TUserLevel;
      Hint: String); overload;
    procedure ToHint(LabelPtr: TLabel;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);
    procedure ToLabel(LabelPtr: TLabel;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);
    procedure ToMemo(MemoPtr: TMemo;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault);
    procedure ToMenuItem(MenuItemPtr: TMenuItem;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToMenuItem(MenuItemPtr: TMenuItem;
      UserLevel: TUserLevel;
      Hint: String); overload;
    procedure ToTrackEdit(TrackEditPtr: TTrackEdit); virtual;
    procedure ToUnits(LabelPtr: TLabel;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToUnits(EditPtr: TEdit;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToUnits(MemoPtr: TMemo;
      EnabledMode: TToControlEnabledMode = tcEnabledDefault;
      VisibleMode: TToControlVisibleMode = tcVisibleDefault;
      HintMode: TToControlHintMode = tcHintDefault); overload;
    procedure ToPopUpMenu(PopUpMenu: TPopUpMenu; RealEditPtr: TRealEdit); overload;
    procedure ToPopUpMenu(PopUpMenu: TPopUpMenu; LabelPtr: TLabel); overload;

    function ParameterFloatToStr(Value: Double): string;

    property Active: Boolean read GetActive write SetActive;
    property Caption: String read GetCaption write SetCaption;
    property CaptionShort: String read GetCaption write SetCaption;
    property CaptionLong: String read GetCaptionLong write SetCaptionLong;
    property BackgroundColor: TColor read GetBackgroundColor write SetBackgroundColor;
    property Name: String read GetName write SetName;
    property Group: String read GetGroup write SetGroup;
    property Highlight: Boolean read m_Highlight write SetHighlight;
    property Hint: String read GetHint write SetHint;
    property HintAs: THintAsType read m_HintAs write m_HintAs;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Focus: Boolean read GetFocus write SetFocus;
    property ForegroundColor: TColor read GetForegroundColor write SetForegroundColor;
    property ParameterState: TParameterState read GetParameterState write SetParameterState ;
    property ParameterValueState: TParameterValueState read m_ParameterValueState write m_ParameterValueState;
    property ParameterType: TParameterType read GetParameterType write SetParameterType;
    property ParameterTypeProperties: Boolean read GetParameterTypeProperties write m_ParameterTypeProperties;
    property ParameterTypeSettings: Boolean read GetParameterTypeSettings write m_ParameterTypeSettings;
    property ParameterTypePolarity: Boolean read m_ParameterTypePolarity write m_ParameterTypePolarity;
    property ParameterTypeWobble: Boolean read m_ParameterTypeWobble write m_ParameterTypeWobble;
    property ParameterTypeTune: Boolean read GetParameterTypeTune write m_ParameterTypeTune;
    property ParameterTypeHistory: Boolean read GetParameterTypeHistory write m_ParameterTypeHistory;
    property ParameterTypeOutgas: Boolean read m_ParameterTypeOutgas write m_ParameterTypeOutgas;
    property Precision: Integer read GetPrecision write SetPrecision;
    property ReadOnly: Boolean read m_ReadOnly write m_ReadOnly;
    property SectionParameterType: TSectionParameterType read GetSectionParameterType write SetSectionParameterType;
    property StringFormat: TStringFormat read m_StringFormat write m_StringFormat;
    property SystemLevel: TUserLevel read GetSystemLevel write SetSystemLevel ;
    property UserLevel: TUserLevel read GetUserLevel write SetUserLevel ;
    property UserLevelCheck: TUserLevelCheck read GetUserLevelCheck write SetUserLevelCheck ;
    property UserLevelDisplay: TUserLevelDisplay read GetUserLevelDisplay write SetUserLevelDisplay ;
    property Visible: Boolean read GetVisible write SetVisible ;
    property FileParameterType: TParameterType read GetFileParameterType write SetFileParameterType ;
    property FileGroupId: tAppSettingType read GetFileGroupId write SetFileGroupId;
    property FileSettingId: Integer read GetFileSettingId write SetFileSettingId;
    property FileVariantType: TVariantType read GetFileVariantType write SetFileVariantType ;
    property MaskLocal: Integer read m_MaskLocal write m_MaskLocal ;
    property MaskLocalAnd: Integer read m_MaskLocalAnd write m_MaskLocalAnd ;
    property MaskLocalOr: Integer read m_MaskLocalOr write m_MaskLocalOr ;
    property MaskLocalNot: Integer read m_MaskLocalNot write m_MaskLocalNot ;
    property MaskSystem: Integer read m_MaskSystem write m_MaskSystem ;
    property MaskSystemAnd: Integer read m_MaskSystemAnd write m_MaskSystemAnd ;
    property MaskSystemOr: Integer read m_MaskSystemOr write m_MaskSystemOr ;
    property MaskSystemNot: Integer read m_MaskSystemNot write m_MaskSystemNot ;
    property MaskDisplay: TUserLevelDisplay read GetMaskDisplay write SetMaskDisplay;
    property Units: String read GetUnits write SetUnits;
    property ValueAsFloat: Double read GetValueAsFloat write SetValueAsFloat ;
    property ValueAsInt: Integer read GetValueAsInt write SetValueAsInt ;
    property ValueAsSingle: Single read GetValueAsSingle write SetValueAsSingle ;
    property ValueAsString: String read GetValueAsString write SetValueAsString ;
    property ValueAsUnits: String read GetValueAsUnits write SetValueAsUnits ;
    property ValueAsVariant: OleVariant read GetValueAsVariant write SetValueAsVariant ;

    // Parent Doc
    property ParentDocPtr: TObject read m_ParentDocPtr write m_ParentDocPtr;

    // History
    property History: TParameter read m_History;
    procedure InitHistory(); virtual;
    procedure SetMinTimeBetweenDataSavesInSec(MinTimeBetweenDataSavesInSec: Int64);
    procedure SetIgnoreDataSaveTimeLimit(Ignore: Boolean);

    // Tune
    property Tune: TParameter read GetTune;
    procedure InitTune(); virtual;

    // Readback
    property Readback: TParameter read m_Readback;
    procedure InitReadback(); virtual;

    property HdwrCtrlName: String read m_ReadbackHdwrCtrlName write m_ReadbackHdwrCtrlName;
    property HistDataRateInSec: Integer read m_ReadbackHistDataRateInSec write m_ReadbackHistDataRateInSec;
    property MinTimeBetweenReadsInSec: Int64 read m_ReadbackMinTimeBetweenReadsInSec write m_ReadbackMinTimeBetweenReadsInSec;

    property OnDataReadback: TNotifyEvent read m_OnDataReadback write SetOnDataReadback;
    property OnDataHistory: TNotifyEvent read m_OnDataReadback write SetOnDataReadback;
    procedure DoDataReadback;
  end ;

function GetReadbackName(sName: String): String;
function GetReadbackCaption(sName: String): String;
function GetReadbackHint(sName: String): String;

function GetHistoryName(sName: String): String;
function GetTuneName(sName: String): String;

implementation

uses
  System.UITypes, DateUtils,
  Variants,
  SysUtils,
  Dialogs,
  ParameterBoolean,
  ParameterSelectData,
  ParameterHistory,
  ParameterTune,
  ParameterDataWobble,
  ParameterWobbleBase,
  ParameterPolarityWobble;


function GetReadbackName(sName: String): String;
begin
  Result := sName + c_ReadbackNameSuffix;
end;

function GetReadbackCaption(sName: String): String;
begin
  Result := sName;
end;

function GetReadbackHint(sName: String): String;
begin
  Result := sName + c_ReadbackHintSuffix;
end;

function GetHistoryName(sName: String): String;
begin
  Result := sName + c_HistoryNameSuffix;
end;

function GetTuneName(sName: String): String;
begin
  Result := sName + c_TuneNameSuffix;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameter.Create(AOwner: TComponent) ;
begin
  inherited Create(AOwner) ;

  // Initialize member variables
  m_Active := True;
  m_Caption := '';
  m_CaptionLong := '';
  m_BackgroundColor := clWhite;
  m_Enabled := True;
  m_FileParameterType := ptDefaultToSettings;
  m_FileGroupId := astNone;
  m_FileSettingId := asSemNone;
  m_FileVariantType := variantValueAsDefault;
  m_Focus := False;
  m_ForegroundColor := clBlack;
  m_Group := 'Parameter';
  m_HelpId := c_DefaultHelp;
  m_Highlight := False;
  m_Hint := c_DefaultHint;
  m_HintAs := hintAsHint;
  m_MaskLocal := c_DefaultMask;
  m_MaskLocalAnd := c_DefaultMask;
  m_MaskLocalOr := c_DefaultMask;
  m_MaskLocalNot := c_DefaultMask;
  m_MaskSystem := c_DefaultMask;
  m_MaskSystemAnd := c_DefaultMask;
  m_MaskSystemOr := c_DefaultMask;
  m_MaskSystemNot := c_DefaultMask;
  m_MaskDisplay := ulDisplayEnable;
  m_Name := '';
  m_ParameterState := psOk;
  m_ParameterValueState := pvsNormal;
  m_ParameterType := ptNone;
  m_ParameterTypeHistory := False;
  m_ParameterTypeOutgas := False;
  m_ParameterTypePolarity := False;
  m_ParameterTypeProperties := False;
  m_ParameterTypeSettings := False;
  m_ParameterTypeWobble := False;
  m_ParameterTypeTune := False;
  m_Precision := c_DefaultPrecision;
  m_ReadOnly := False;
  m_SectionParameterType := ptSectionNone;
  m_StringFormat := fmtFixed;
  m_SystemLevel := ulOpen;
  m_Units := '';
  m_UserLevel := ulUser;
  m_UserLevelCheck := ulCheckGreaterThan;
  m_UserLevelDisplay := ulDisplayEnable;
  m_Visible := True;
  m_ParentDocPtr := nil;

  m_History := nil;
  m_Tune := nil;

  m_Readback := nil;
  m_ReadbackHdwrCtrlName := '';
  m_ReadbackHistDataRateInSec := 60;
  m_ReadbackMinTimeBetweenReadsInSec := 1;
  m_ReadbackTimeNextReadAllowed := Now();
  m_OnDataReadback := nil;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None.
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
destructor TParameter.Destroy() ;
begin
   inherited Destroy ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy the memeber variables from the passed object
// Inputs:       TParameter.
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.Initialize(Sender: TParameter) ;
begin
  m_Active := Sender.m_Active;
  m_Enabled := Sender.m_Enabled ;
  m_FileParameterType := Sender.m_FileParameterType;
  m_FileGroupId := Sender.m_FileGroupId;
  m_FileSettingId := Sender.m_FileSettingId;
  m_FileVariantType := Sender.m_FileVariantType;
  m_Focus := Sender.m_Focus;
  m_Group := Sender.m_Group;
  m_HelpId := Sender.m_HelpId;
  m_Highlight := Sender.m_Highlight;
  m_Hint := Sender.m_Hint;
  m_HintAs := Sender.m_HintAs;
  m_MaskLocal := Sender.m_MaskLocal;
  m_MaskLocalAnd := Sender.m_MaskLocalAnd;
  m_MaskLocalOr := Sender.m_MaskLocalOr;
  m_MaskLocalNot := Sender.m_MaskLocalNot;
  m_MaskSystem := Sender.m_MaskSystem;
  m_MaskSystemAnd := Sender.m_MaskSystemAnd;
  m_MaskSystemOr := Sender.m_MaskSystemOr;
  m_MaskSystemNot := Sender.m_MaskSystemNot;
  m_MaskDisplay := Sender.m_MaskDisplay;
  m_Name := Sender.m_Name;
  m_Caption := Sender.m_Caption;
  m_CaptionLong := Sender.m_CaptionLong;
  m_ParameterState := Sender.m_ParameterState;
  m_ParameterValueState := Sender.m_ParameterValueState;
  m_ParameterType := Sender.m_ParameterType;
  m_Precision := Sender.m_Precision;
  m_ReadOnly := Sender.m_ReadOnly;
  m_SectionParameterType := Sender.m_SectionParameterType;
  m_StringFormat := Sender.m_StringFormat;
  m_SystemLevel := Sender.m_SystemLevel;
  m_Units := Sender.m_Units;
  m_UserLevel := Sender.m_UserLevel;
  m_UserLevelCheck := Sender.m_UserLevelCheck;
  m_UserLevelDisplay := Sender.m_UserLevelDisplay;
  m_Visible := Sender.m_Visible;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return changed value.
// Inputs:       None
// Outputs:      Value as Float
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.Changed(): Boolean;
begin
//  MessageDlg('Changed(): Not implmented', mtError, [mbOk], 0);
  Result := False;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save the 'Init' value
// Inputs:       None
// Outputs:      None
// Note:         The 'Init' value is typically saved when a TParameter value is
//               changed as part of a 'Load' Setting or 'Load' File.  The 'Init'
//               value does not change during the running of an application and is
//               therefore, available as a check to see if the value has changed.
//               See the Changed() method above.  Note that the 'Undo' value is
//               also saved here.
////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SaveInit();
begin
//  MessageDlg(Name + ': SaveInit(): Not implmented', mtError, [mbOk], 0);
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Save the 'Undo' value
// Inputs:       None
// Outputs:      None
// Note:         The 'Undo' value is also saved when a TParameter value is
//               changed as part of a 'Load' Setting or 'Load' File.  The 'Undo'
//               value, however, is typically changed many times during the
//               running of an application (each time a property dialog is displayed)
////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SaveUndo() ;
begin
//  MessageDlg(Name + ': SaveUndo(): Not implmented', mtError, [mbOk], 0);
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Single step undo back to the 'Undo' value.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameter.Undo() ;
begin
//  MessageDlg(Name + ': Undo(): Not implmented', mtError, [mbOk], 0);
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the active state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetActive: Boolean;
begin
  Result := m_Active;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Background color
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameter.GetBackgroundColor(): TColor;
begin
  Result := m_BackgroundColor;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Background color
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameter.GetBackgroundColor(DefaultColor: TColor): TColor;
begin
  if (m_ParameterState = psWarning) or
     (m_ParameterValueState = pvsWarning) then
    Result := c_ColorBackgroundWarning
  else if (m_ParameterState = psError) or
          (m_ParameterValueState = pvsError) then
    Result := c_ColorBackgroundError
  else if not m_Active then
    Result := c_ColorBackgroundReadOnly
  else if m_ReadOnly then
    Result := c_ColorBackgroundReadOnly
  else
    Result := DefaultColor;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the 'Caption'
// Inputs:       None
// Outputs:      Result: String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetCaption: String;
begin
  Result := m_Caption;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the 'CaptionLong'
// Inputs:       None
// Outputs:      Result: String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetCaptionLong: String;
begin
  Result := m_CaptionLong;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Enabled state
// Inputs:       None
// Outputs:      Enabled as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetEnabled: Boolean;
begin
  Result := m_Enabled;

  // Check for valid 'User Level'
  if Result then
    Result := GetEnabledUserLevel() ;

  // Check for valid 'Application Mask'
  if Result then
    Result := GetEnabledMask() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Enabled state
// Inputs:       None
// Outputs:      Enabled as Boolean
// Note:         Enabled state depends on System Level vs. User Level.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetEnabledUserLevel: Boolean;
begin
  Result := m_Enabled;

  if Result then
  begin
    // Check for valid 'User Level'
    if (UserLevelDisplay = ulDisplayEnable) and not ValidUserLevel() then
      Result := False ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Enabled state
// Inputs:       None
// Outputs:      Enabled as Boolean
// Note:         Enabled state depends on System Level vs. User Level.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetEnabledUserLevel(UserLevelValue: TUserLevel; UserLevelDisplayValue: TUserLevelDisplay): Boolean;
begin
  Result := m_Enabled;

  if Result then
  begin
    // Check for valid 'User Level'
    if (UserLevelDisplayValue = ulDisplayEnable) and not ValidUserLevel(UserLevelValue) then
      Result := False ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Enabled state
// Inputs:       None
// Outputs:      Enabled as Boolean
// Note:         Enabled state depends on System Level vs. User Level.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetEnabledMask: Boolean;
begin
  Result := m_Enabled;

  if Result then
  begin
    // Check for valid 'Application Mask'
    if (MaskDisplay = ulDisplayEnable) then
    begin
      if Result then
        if (m_MaskLocal and m_MaskLocalAnd) <> m_MaskLocalAnd then
          Result := False;

      if Result then
        if ((m_MaskLocal and m_MaskLocalOr) = $0) and (m_MaskLocalOr <> $0) then
          Result := False;

      if Result then
        if ((m_MaskLocal and m_MaskLocalNot) <> $0) and (m_MaskLocalNot <> $0) then
          Result := False;

      // Check for valid 'System Mask'
      if Result then
        if (m_MaskSystem and m_MaskSystemAnd) <> m_MaskSystemAnd then
          Result := False;

      if Result then
        if ((m_MaskSystem and m_MaskSystemOr) = $0) and (m_MaskSystemOr <> $0) then
          Result := False;

      if Result then
        if ((m_MaskSystem and m_MaskSystemNot) <> $0) and (m_MaskSystemNot <> $0) then
          Result := False;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Enabled state using the mode flag
// Inputs:       None
// Outputs:      Enabled as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetEnabledUsingMode(Mode: TToControlEnabledMode): Boolean;
begin
  if (Mode = tcEnabledDefault) then
    Result := Enabled
  else if (Mode = tcEnabledOn) then
    Result := True
  else if (Mode = tcEnabledOff) then
    Result := False
  else if (Mode = tcEnabledUserLevel) then
    Result := GetEnabledUserLevel()
  else if (Mode = tcEnabledMask) then
    Result := GetEnabledMask()
  else if (Mode = tcEnabledMaskNot) then
    Result := not GetEnabledMask()
  else
    Result := Enabled;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Foreground color
// Inputs:       None
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetForegroundColor(): TColor;
begin
  Result := m_ForegroundColor;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Foreground color
// Inputs:       None
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetForegroundColor(DefaultColor: TColor): TColor;
begin
  if (m_ParameterState = psWarning) or
     (m_ParameterValueState = pvsWarning) then
    Result := c_ColorForegroundWarning
  else if (m_ParameterState = psError) or
          (m_ParameterValueState = pvsError) then
    Result := c_ColorForegroundError
  else if not m_Active then
    Result := clWindowText
  else if m_ReadOnly then
    Result := clWindowText
  else
    Result := DefaultColor;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Hint
// Inputs:       None
// Outputs:      Hint as String
// Note:         Hint depends on System Level vs. User Level.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetHint: String;
begin
  if (UserLevel <= SystemLevel) then
    Result := m_Hint
  else if (UserLevel = ulSuperuser) then
    Result := '''Superuser'' password protected'
  else if (UserLevel = ulService) then
    Result := '''Service'' password protected'
  else if (UserLevel = ulOpen) then
    Result := '''Open'' password protected'
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Hint
// Inputs:       None
// Outputs:      Hint as String
// Note:         Hint depends on System Level vs. User Level.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetHintUsingUserLevel(HintValue: String; UserLevelValue: TUserLevel): String;
begin
  if (UserLevelValue <= SystemLevel) then
    Result := HintValue
  else if (UserLevelValue = ulSuperuser) then
    Result := '''Superuser'' password protected'
  else if (UserLevelValue = ulService) then
    Result := '''Service'' password protected'
  else if (UserLevelValue = ulOpen) then
    Result := '''Open'' password protected'
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Hint
// Inputs:       None
// Outputs:      Hint as String
// Note:         Hint depends on System Level vs. User Level.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetHintUsingMode(Mode: TToControlHintMode): String;
begin
  if (Mode = tcHintOn) then
    Result := m_Hint
  else if (Mode = tcHintOff) then
    Result := ''
  else
  begin
    if (UserLevel <= SystemLevel) then
      Result := m_Hint
    else if (UserLevel = ulSuperuser) then
      Result := '''Superuser'' password protected'
    else if (UserLevel = ulService) then
      Result := '''Service'' password protected'
    else if (UserLevel = ulOpen) then
      Result := '''Open'' password protected'
  end ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetVisible: Boolean;
begin
  Result := m_Visible;

  // Check for valid 'User Level'
  if Result then
    Result := GetVisibleUserLevel() ;

  // Check for valid 'Application Mask'
  if Result then
    Result := GetVisibleMask() ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetVisibleUserLevel: Boolean;
begin
  Result := m_Visible;

  if Result then
  begin
    // Check for valid 'User Level'
    if (UserLevelDisplay = ulDisplayVisible) and not ValidUserLevel() then
      Result := False ;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetVisibleMask: Boolean;
begin
  Result := m_Visible;

  if Result then
  begin
    // Check for valid 'Application Mask'
    if (MaskDisplay = ulDisplayVisible) then
    begin
      if Result then
        if (m_MaskLocal and m_MaskLocalAnd) <> m_MaskLocalAnd then
          Result := False;

      if Result then
        if ((m_MaskLocal and m_MaskLocalOr) = $0) and (m_MaskLocalOr <> $0) then
          Result := False;

      if Result then
        if ((m_MaskLocal and m_MaskLocalNot) <> $0) and (m_MaskLocalNot <> $0) then
          Result := False;

      // Check for valid 'System Mask'
      if Result then
        if (m_MaskSystem and m_MaskSystemAnd) <> m_MaskSystemAnd then
          Result := False;

      if Result then
        if ((m_MaskSystem and m_MaskSystemOr) = $0) and (m_MaskSystemOr <> $0) then
          Result := False;

      if Result then
        if ((m_MaskSystem and m_MaskSystemNot) <> $0) and (m_MaskSystemNot <> $0) then
          Result := False;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state using the mode flag
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetVisibleUsingMode(Mode: TToControlVisibleMode): Boolean;
begin
  if (Mode = tcVisibleDefault) then
    Result := Visible
  else if (Mode = tcVisibleOn) then
    Result := True
  else if (Mode = tcVisibleOff) then
    Result := False
  else if (Mode = tcVisibleUserLevel) then
    Result := GetVisibleUserLevel()
  else if (Mode = tcVisibleMask) then
    Result := GetVisibleMask()
  else if (Mode = tcVisibleMaskNot) then
    Result := not GetVisibleMask()
  else
    Result := Visible;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetFileGroupId: tAppSettingType;
begin
  Result := m_FileGroupId;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetFileParameterType: TParameterType;
begin
  Result := m_FileParameterType;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetFileSettingId: Integer;
begin
  Result := m_FileSettingId;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetFileVariantType: TVariantType;
begin
  Result := m_FileVariantType;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetFocus: Boolean;
begin
  Result := m_Focus;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetGroup: String;
begin
  Result := m_Group;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the 'help id'
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetHelpId: Integer;
begin
  Result := m_HelpId;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the mask display
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetMaskDisplay(): TUserLevelDisplay;
begin
  Result := m_MaskDisplay;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetName: String;
begin
  Result := m_Name;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the parameter state
// Inputs:       None
// Outputs:      TParameterState
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetParameterState: TParameterState;
begin
  Result := m_ParameterState;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetParameterType: TParameterType;
begin
  Result := m_ParameterType;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get section type
// Inputs:       None
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetSectionParameterType: TSectionParameterType;
begin
  Result := m_SectionParameterType;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetPrecision: Integer;
begin
  Result := m_Precision;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Visible state
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetSystemLevel: TUserLevel;
begin
  Result := m_SystemLevel;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the 'Units'
// Inputs:       None
// Outputs:      Result: String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetUnits: String;
begin
  Result := m_Units;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the User Level
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetUserLevel: TUserLevel;
begin
  Result := m_UserLevel;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the User Level Check
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetUserLevelCheck: TUserLevelCheck;
begin
  Result := m_UserLevelCheck;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the User Level Display
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetUserLevelDisplay: TUserLevelDisplay;
begin
  Result := m_UserLevelDisplay;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return changed value.
// Inputs:       None
// Outputs:      Value as Float
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetValueAsFloat(): Double;
begin
  MessageDlg(Name + ': GetValueAsFloat(): Not implmented', mtError, [mbOk], 0);
  Result := 0.0;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return changed value.
// Inputs:       None
// Outputs:      Value as Float
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetValueAsInt(): Integer;
begin
  MessageDlg(Name + ': GetValueAsInt(): Not implmented', mtError, [mbOk], 0);
  Result := 0;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Support casting float value to single
// Inputs:       None
// Outputs:      Value as Single
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetValueAsSingle: Single;
var
  floatValue: Double;
  singleValue: Single;
begin
  floatValue := GetValueAsFloat();
  singleValue := floatValue;
  result := singleValue;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return changed value.
// Inputs:       None
// Outputs:      Value as Float
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetValueAsString(): String;
begin
  MessageDlg(Name + ': GetValueAsString(): Not implmented', mtError, [mbOk], 0);
  Result := '';
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return changed value.
// Inputs:       None
// Outputs:      Value as Float
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetValueAsVariant(): OleVariant;
begin
  MessageDlg(Name + ': GetValueAsVariant(): Not implmented', mtError, [mbOk], 0);
  Result := 0.0;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return changed value.
// Inputs:       None
// Outputs:      Value as Float
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetValueAsUnits(): String;
begin
  Result := ValueAsString + ' ' + Units;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the properties
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetParameterTypeProperties: Boolean;
begin
  Result := False;

  if m_ParameterTypeProperties = True then
    Result := True
  else
  begin
    if (m_ParameterType = ptProperties) or (m_ParameterType = ptPropertiesReadOnly) or
      (m_ParameterType = ptPropertiesWriteOnly) or
      (m_ParameterType = ptRegistry) or (m_ParameterType = ptRegistryReadOnly) or
      (m_ParameterType = ptRegistryWriteOnly) then
    Result := True
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Settings
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetParameterTypeSettings: Boolean;
begin
  Result := False;

  if m_ParameterTypeSettings = True then
    Result := True
  else
  begin
    if (m_ParameterType = ptSettings) or (m_ParameterType = ptSettingsReadOnly) or
      (m_ParameterType = ptSettingsWriteOnly) then
      Result := True
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Settings
// Inputs:       None
// Outputs:      Visible as Boolean
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetParameterTypeHistory: Boolean;
begin
  Result := False;

  if m_ParameterTypeHistory = True then
    Result := True
  else
  begin
    if Assigned(m_History) then
      Result := True
    else if Assigned(m_Readback) then
      if Assigned(m_Readback.History) then
        Result := True;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Does parameter support tune?
// Inputs:       None
// Outputs:      None
// Return:       True if parameter returns true; support tune
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.GetParameterTypeTune: Boolean;
var
  bParameterTypeTune: Boolean;
begin
  bParameterTypeTune := False;

  if m_ParameterTypeTune = True then
    bParameterTypeTune := True
  else if assigned(m_Tune) then
    bParameterTypeTune := True;

  Result := bParameterTypeTune;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Enabled state
// Inputs:       None
// Outputs:      Enabled as Boolean
// Note:         Enabled state depends on System Level vs. User Level.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.ValidUserLevel(UserLevelValue: TUserLevel): Boolean;
begin
  // Initialize return
  Result := False;

  if (UserLevelCheck = ulCheckLessThan) then
  begin
    if (SystemLevel <= UserLevelValue) then
      Result := True;
  end
  else if (UserLevelCheck = ulCheckLessThanOrEqual) then
  begin
    if (SystemLevel < UserLevelValue) then
      Result := True;
  end
  else if (UserLevelCheck = ulCheckGreaterThan) then
  begin
    if (SystemLevel >= UserLevelValue) then
      Result := True;
  end
  else if (UserLevelCheck = ulCheckGreaterThanOrEqual) then
  begin
    if (SystemLevel > UserLevelValue) then
      Result := True;
  end
  else if (UserLevelCheck = ulCheckMatchExactly) then
  begin
    if (UserLevelValue = SystemLevel) then
      Result := True;
  end
  else // Unknown
    assert(False, 'ValidUserLevel(): Unkown UserLevelDisplay');
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the Enabled state
// Inputs:       None
// Outputs:      Enabled as Boolean
// Note:         Enabled state depends on System Level vs. User Level.
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.ValidUserLevel(): Boolean;
begin
  Result := ValidUserLevel(GetUserLevel());
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Convert a float value to a string value using the current precision.
// Inputs:       Value as Double
// Outputs:      Value as String
// Note:
////////////////////////////////////////////////////////////////////////////////
function TParameter.ParameterFloatToStr(Value: Double): String;
var
  precisionFormat: String;
  typeFormat: String;
begin
  // Set the type
  if (m_StringFormat = fmtFixed) then
    typeFormat := 'f'
  else if (m_StringFormat = fmtInteger) then
    typeFormat := 'd'
  else if (m_StringFormat = fmtHexadecimal) then
    typeFormat := 'x'
  else if (m_StringFormat = fmtGeneral) then
    typeFormat := 'g'
  else
    typeFormat := 'f';

  // Set the precision
  if (m_StringFormat = fmtScientific) then
  begin
    if (m_Precision <> c_DefaultPrecision) then
    begin
      precisionFormat := '0.' + Format('%.' + IntToStr(m_Precision) + 'd', [0]) + 'e+00';
    end
    else
      precisionFormat := '0.###e+00';
  end
  else
  begin
    if (m_Precision <> c_DefaultPrecision) then
      precisionFormat := '.' + Format('%d', [m_Precision])
    else
      precisionFormat := '';
  end;

  // return the formated string
  if (m_StringFormat = fmtHexadecimal) then
    Result := '0x' + Format('%' + precisionFormat + typeFormat, [round(Value)])
  else if (m_StringFormat = fmtScientific) then
    Result := FormatFloat(precisionFormat, Value)
  else if (m_StringFormat = fmtDateTime) then
    Result := DateTimeToStr(Value)
  else
    Result := Format('%' + precisionFormat + typeFormat, [Value]);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set active
// Inputs:       Value as Boolean
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetActive(const Value: Boolean);
begin
  m_Active := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the background color
// Inputs:       Enabled state
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetBackgroundColor(const Value: TColor);
begin
  m_BackgroundColor := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the 'Caption'
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetCaption(const Value: String);
var
  startStr, endStr, lengthStr: Integer;
begin
  m_Caption:= Value;

  // Default the long caption
  m_CaptionLong := m_Caption;

  // Default the units
  startStr := LastDelimiter('(', m_Caption);
  endStr := LastDelimiter(')', m_Caption);
  lengthStr := (endStr - startStr) - 1;
  if lengthStr > 0 then
    m_Units := Copy(m_Caption, startStr + 1, lengthStr);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the 'CaptionLong'
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetCaptionLong(const Value: String);
var
  startStr, endStr, lengthStr: Integer;
begin
  m_CaptionLong := Value;

  // Default the units
  startStr := LastDelimiter('(', m_CaptionLong);
  endStr := LastDelimiter(')', m_CaptionLong);
  lengthStr := (endStr - startStr) - 1;
  if lengthStr > 0 then
    m_Units := Copy(m_CaptionLong, startStr + 1, lengthStr);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Enabled state
// Inputs:       Enabled state
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetEnabled(const Value: Boolean);
begin
  m_Enabled := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the foreground color
// Inputs:       Enabled state
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetForegroundColor(const Value: TColor);
begin
  m_ForegroundColor := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Hint
// Inputs:       Hint string
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetHint(Value: String);
begin
  m_Hint := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Visible state
// Inputs:       Visible state
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetVisible(const Value: Boolean);
begin
  m_Visible := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the File Group Id
// Inputs:       Value as tAppSettingType
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetFileGroupId(const Value: tAppSettingType);
begin
  m_FileGroupId := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the FileParameterType
// Inputs:       Value as TParameterType
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetFileParameterType(const Value: TParameterType);
begin
  m_FileParameterType := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the FileSettingId
// Inputs:       Value as Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetFileSettingId(const Value: Integer);
begin
  m_FileSettingId := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the FileVariantType
// Inputs:       Value as TVariantType
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetFileVariantType(const Value: TVariantType);
begin
  m_FileVariantType := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Focus
// Inputs:       Value as Boolean
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetFocus(const Value: Boolean);
begin
  m_Focus := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Group
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetGroup(const Value: String);
begin
  m_Group := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Group
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetHighlight(const Value: Boolean);
begin
  m_Highlight := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the masking display
// Inputs:       Value as TUserLevelDisplay
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetMaskDisplay(const Value: TUserLevelDisplay);
begin
  m_MaskDisplay := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Name
// Inputs:       Value as String
// Outputs:      None
// Note:         Name cannot have trailing spaces.  Causes a problem when reading
//                from ini file.  trim() is done here to keep the writing of the
//                file fast.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetName(const Value: String);
begin
  m_Name := trim(Value);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Parameter State
// Inputs:       Value as TParameterState
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetParameterState(const Value: TParameterState);
begin
  m_ParameterState := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the ParameterType
// Inputs:       Value as TParameterType
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetParameterType(const Value: TParameterType);
begin
  m_ParameterType := Value;

  if m_ParameterType = ptSettings then
    m_SectionParameterType := ptSectionReadWrite;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the SetSectionParameterType
// Inputs:       Value as SetSectionParameterType
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetSectionParameterType(const Value: TSectionParameterType);
begin
  m_SectionParameterType := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Precision
// Inputs:       Value as Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetPrecision(const Value: Integer);
begin
  m_Precision := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the SystemLevel
// Inputs:       Value as TUserLevel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetSystemLevel(const Value: TUserLevel);
begin
  m_SystemLevel := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the Units
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetUnits(const Value: String);
begin
  m_Units:= Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the UserLevel
// Inputs:       Value as TUserLevel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetUserLevel(const Value: TUserLevel);
begin
  m_UserLevel := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the UserLevel Check
// Inputs:       Value as TUserLevelCheck
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetUserLevelCheck(const Value: TUserLevelCheck);
begin
  m_UserLevelCheck := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the UserLevel Display
// Inputs:       Value as TUserLevelDisplay
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetUserLevelDisplay(const Value: TUserLevelDisplay);
begin
  m_UserLevelDisplay := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Support casting float value to single
// Inputs:       Value as Single
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetValueAsFloat(FloatValue: Double);
begin
  MessageDlg(Name + ': SetValueAsFloat(): Not implmented', mtError, [mbOk], 0);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Support casting float value to single
// Inputs:       Value as Single
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetValueAsInt(IntValue: Integer);
begin
  MessageDlg(Name + ': SetValueAsInt(): Not implmented', mtError, [mbOk], 0);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Support casting float value to single
// Inputs:       Value as Single
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetValueAsSingle(SingleValue: Single);
var
  floatValue: Double;
begin
  floatValue := SingleValue;
  SetValueAsFloat(floatValue);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Support casting float value to single
// Inputs:       Value as Single
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetValueAsString(StringValue: String);
begin
  MessageDlg(Name + ': SetValueAsString(): Not implmented', mtError, [mbOk], 0);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Support casting float value to single
// Inputs:       Value as Single
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetValueAsVariant(VariantValue: OleVariant);
begin
  MessageDlg(Name + ': SetValueAsVariant(): Not implmented', mtError, [mbOk], 0);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Support casting float value to single
// Inputs:       Value as Single
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.SetValueAsUnits(StringValue: String);
begin
  MessageDlg(Name + ': SetValueAsUnits(): Not implmented', mtError, [mbOk], 0);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy the Value from one IniFile to another.
// Inputs:       FromIniFile, ToIniFile - Setting Files.
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.CopyValueFromSetting(FromIniFile: TCustomIniFile; ToIniFile: TCustomIniFile);
var
  Value: String;
begin
  // Copy 'Value' from the 'From' IniFile to the 'To' IniFile
  Value := FromIniFile.ReadString(Group, Name, c_DefaultValue);
  ToIniFile.WriteString(Group, Name, Value);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the Value from the AppSettings object(i.e. Acquisition File).
// Inputs:       AppSettings - The App Settings interface.
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ReadValueFromAcq(AppSettings: IAppSettings);
var
  Value: OleVariant;
  PhiRes: Integer;
begin
  if (FileGroupId = astNone) then
    MessageDlg('File GroupID missing for ' + Name, mtError, [mbOk], 0)
  else
  begin
    try
      // Get 'Value' from the AppSettings Object
      AppSettings.GetSetting(PhiRes, FileGroupId, FileSettingId, 0, Value);

      // Save the value
      if ((PhiRes = 0) and (not (VarIsEmpty(Value)))) then
      begin
        ValueAsVariant := Value;
      end;
    except
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the Value from the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ReadValueFromSetting(IniFile: TCustomIniFile);
var
  Value: String;
begin
  // Get 'Value' from the IniFile
  Value := IniFile.ReadString(Group, Name, c_DefaultValue);

  // Save the value
  if (Value <> c_DefaultValue) then
  begin
    ValueAsString := Value;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the Value from the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ReadValueFromSetting(IniFile: TCustomIniFile; TagName: String);
var
  Value: String;
begin
  // Get 'Value' from the IniFile
  Value := IniFile.ReadString(Group, TagName, c_DefaultValue);

  // Save the value
  if (Value <> c_DefaultValue) then
  begin
    ValueAsString := Value;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the Value from the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ReadValueFromRegistry(RegIniFile: TRegIniFile);
var
  Value: String;
begin
  // Get 'Value' from the IniFile
  Value := RegIniFile.ReadString(Group, Name, c_DefaultValue);

  // Save the value
  if (Value <> c_DefaultValue) then
  begin
    ValueAsString := Value;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the CAPTION from the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ReadCaptionFromSetting(IniFile: TCustomIniFile);
var
  Value: String;
begin
  // Get 'Value' from the IniFile
  Value := IniFile.ReadString(Group, Name, c_DefaultValue);

  // Save the value
  if (Value <> c_DefaultValue) then
  begin
    m_Caption := Value;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Read the HINT from the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ReadHintFromSetting(IniFile: TCustomIniFile);
var
  Value: String;
begin
  // Get 'Value' from the IniFile
  Value := IniFile.ReadString(Group, Name, c_DefaultValue);

  // Save the value
  if (Value <> c_DefaultValue) then
  begin
    m_Hint := Value;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the AppSettings object(i.e. Acquisition File).
// Inputs:       AppSettings - The App Settings interface.
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.WriteValueToAcq(AppSettings: IAppSettings);
var
  PhiRes: Integer;
begin
  if (FileGroupId = astNone) then
    MessageDlg('File GroupID missing for ' + Name, mtError, [mbOk], 0)
  else
    // Save 'Value' to the AppSettings Object
    AppSettings.PutSetting(PhiRes, FileGroupId, FileSettingId, 0, ValueAsVariant);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the TAppSettings object.
// Inputs:       AppSettings - The TAppSettings interface.
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.WriteValueToAcq(Section: String; AppSettings: TAppSettings);
begin
  // Save 'Value' to the TAppSettings Object.
  AppSettings.SetTag(Section, Name, ValueAsString);

  AppSettings.AddParameter(Section, Name, Self);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.WriteValueToSetting(IniFile: TCustomIniFile);
begin
  // Save 'Value' to the IniFile
  IniFile.WriteString(Group, Name, ValueAsString);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.WriteValueToSetting(IniFile: TCustomIniFile; TagName: String);
begin
  // Save 'Value' to the IniFile
  IniFile.WriteString(Group, TagName, ValueAsString);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to a text file directly(i.e. Setting File).
//               Write it out in ini file format but by pass TCustomIniFile to improve the performance.
// Inputs:       FileId - ID of the file to write to
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.WriteValueToSetting(var FileId: TextFile);
begin
  Writeln(FileId, Name + '=' + ValueAsString);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to a text file directly(i.e. Setting File).
//               Write it out in ini file format but by pass TCustomIniFile to improve the performance.
// Inputs:       FileId - ID of the file to write to
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.WriteValueToSetting(var FileId: TextFile; TagName: String);
begin
  Writeln(FileId, TagName + '=' + ValueAsString);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the Value to the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.WriteValueToRegistry(RegIniFile: TRegIniFile);
begin
  // Save 'Value' to the IniFile
  RegIniFile.WriteString(Group, Name, ValueAsString);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the CAPTION to the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.WriteCaptionToSetting(IniFile: TCustomIniFile);
begin
  IniFile.WriteString(Group, Name, m_Caption);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Write the HINT to the IniFile object(i.e. Setting File).
// Inputs:       IniFile - Setting File
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.WriteHintToSetting(IniFile: TCustomIniFile);
begin
  IniFile.WriteString(Group, Name, m_Hint);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// AppSettings conversion methods
////////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameter.AppSettingsToBoolean(AppSettings: TAppSettings; Section: String): Boolean;
begin
  MessageDlg(Name + ': AppSettingsToBoolean(): Not implmented', mtError, [mbOk], 0);
  Result := True;
end;

function TParameter.AppSettingsToEnum(AppSettings: TAppSettings; Section: String): Integer;
begin
  MessageDlg(Name + ': AppSettingsToEnum(): Not implmented', mtError, [mbOk], 0);
  Result := 0;
end;

function TParameter.AppSettingsToFloat(AppSettings: TAppSettings; Section: String): Double;
var
  tagAsFloat: Double;
begin
  // Get the header tag string from the .ini file object.
  tagAsFloat := AppSettings.AppSettingsFile.ReadFloat(Section, Name, 0.0);

  // Return the header tag string.
  Result := tagAsFloat;
end;

function TParameter.AppSettingsToString(AppSettings: TAppSettings; Section: String): String;
var
  tagAsString: String;
begin
  // Get the header tag string from the .ini file object.
  tagAsString := AppSettings.AppSettingsFile.ReadString(Section, Name, '');

  // Return the header tag string.
  Result := tagAsString;
end;

function TParameter.AppSettingsToBooleanArray(AppSettings: TAppSettings; Section: String): TBooleanDynArray;
begin
  MessageDlg(Name + ': AppSettingsToBooleanArray(): Not implmented', mtError, [mbOk], 0);
  Result := nil;
end;

function TParameter.AppSettingsToEnumArray(AppSettings: TAppSettings; Section: String): TIntegerDynArray;
begin
  MessageDlg(Name + ': AppSettingsToEnumArray(): Not implmented', mtError, [mbOk], 0);
  Result := nil;
end;

function TParameter.AppSettingsToFloatArray(AppSettings: TAppSettings; Section: String): TDoubleDynArray;
begin
  MessageDlg(Name + ': AppSettingsToFloatArray(): Not implmented', mtError, [mbOk], 0);
  Result := nil;
end;

function TParameter.AppSettingsToIntArray(AppSettings: TAppSettings; Section: String): TIntegerDynArray;
begin
  MessageDlg(Name + ': AppSettingsToIntArray(): Not implmented', mtError, [mbOk], 0);
  Result := nil;
end;

function TParameter.AppSettingsToStringArray(AppSettings: TAppSettings; Section: String): TStringDynArray;
begin
  MessageDlg(Name + ': AppSettingsToStringArray(): Not implmented', mtError, [mbOk], 0);
  Result := nil;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// History
////////////////////////////////////////////////////////////////////////////////////////////////////////

// InitHistory
procedure TParameter.InitHistory();
var
  parameterHistory: TParameterHistory;
  bIsReadback: Boolean;
  bIsStateDataType: Boolean;
begin
  if not assigned(m_History) then
  begin
    parameterHistory := TParameterHistory.Create(Self);
    parameterHistory.Name := GetHistoryName(Name);
    parameterHistory.Caption := Caption;
    parameterHistory.CaptionLong := CaptionLong;
    parameterHistory.Hint := Hint;
    parameterHistory.Units := Units;
    parameterHistory.Precision := Precision;
    parameterHistory.StringFormat := StringFormat;

    // Check if this is a readback object (i.e. this is the 'read' TParameter associated to a 'set' TParameter
    bIsReadback := False;
    if Self.Owner is TParameter then
    begin
      if TParameter(Self.Owner).Readback = Self then
        bIsReadback := True;
    end;

    // Check if this is a 'state' or 'mode' type object (e.g. On|Off|Auto)
    bIsStateDataType := False;
    if (Self is TParameterSelectData) or (Self is TParameterBoolean) then
      bIsStateDataType := True;

    // Assign HistoryType; this is used to group items in the chart recorder dropdown list
    if not assigned(m_OnDataReadback) and bIsStateDataType then
      parameterHistory.HistoryType := htStateChange
    else if not assigned(m_OnDataReadback) and not bIsStateDataType then
      parameterHistory.HistoryType := htPolling
    else if assigned(m_OnDataReadback) and bIsReadback then
      parameterHistory.HistoryType := htReadback
    else if assigned(m_OnDataReadback) and not bIsReadback then
      parameterHistory.HistoryType := htServiceReadback
    else
      parameterHistory.HistoryType := htNone;

    m_History := TParameter(parameterHistory);
  end;
end;

// SetMinTimeBetweenDataSavesInSec
procedure TParameter.SetMinTimeBetweenDataSavesInSec(MinTimeBetweenDataSavesInSec: Int64);
var
  parameterHistory: TParameterHistory;
begin
  parameterHistory := TParameterHistory(m_History);
  parameterHistory.MinTimeBetweenDataSavesInSec := MinTimeBetweenDataSavesInSec;
end;

// SetIgnoreDataSaveTimeLimit
procedure TParameter.SetIgnoreDataSaveTimeLimit(Ignore: Boolean);
var
  parameterHistory: TParameterHistory;
begin
  parameterHistory := TParameterHistory(m_History);
  parameterHistory.IgnoreDataSaveTimeLimit := Ignore;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tune
////////////////////////////////////////////////////////////////////////////////////////////////////////

function TParameter.GetTune(): TParameter;
begin
  InitTune();

  Result := m_Tune;
end;

procedure TParameter.InitTune();
var
  parameterTune: TParameterTune;
begin
  if not assigned(m_Tune) then
  begin
    ParameterTypeTune := true;

    parameterTune := TParameterTune.Create(Self);
    parameterTune.Name := GetTuneName(Name);
    parameterTune.Caption := Caption;
    parameterTune.CaptionLong := CaptionLong;
    parameterTune.Hint := Hint;
    parameterTune.Units := Units;

    parameterTune.Precision := Precision;
    parameterTune.TuneStepSize.Precision := Precision;
    parameterTune.TuneRange.Precision := Precision;

    parameterTune.StringFormat := StringFormat;
    parameterTune.TuneStepSize.StringFormat := StringFormat;
    parameterTune.TuneRange.StringFormat := StringFormat;

    parameterTune.TuneDelayInMs.ValueAsInt := 10;

    m_Tune := TParameter(parameterTune);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Readback
////////////////////////////////////////////////////////////////////////////////////////////////////////

// InitReadback
procedure TParameter.InitReadback();
begin
  MessageDlg(Name + ': InitReadback(): Must be implemented in derived class', mtError, [mbOk], 0);
end;

// SetOnDataReadback
procedure TParameter.SetOnDataReadback(const Value: TNotifyEvent);
begin
  m_OnDataReadback := Value;

  InitHistory();
end;

// DoDataReadback
procedure TParameter.DoDataReadback;
var
  currentTime: Double;
begin
  // Check if a readback method is defined.
  if Assigned(m_OnDataReadback) then
  begin
    // Check that it's not too soon to do another read.
    currentTime := Now();
    if currentTime > m_ReadbackTimeNextReadAllowed then
    begin
      // Call the user-supplied method to perform the read.
      m_OnDataReadback(Self);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// UI Update Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter caption information to a 'TLabel' component.
// Inputs:       TLabel
// Outputs:      None
// Note:         This method is used only to update a label(i.e. the 'caption')
//               associated to the actual data field.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToCaption(LabelPtr: TLabel; UseLongCaption: Boolean; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  if (Hint <> c_DefaultHint) then
  begin
    LabelPtr.ShowHint := True ;
    LabelPtr.Hint := GetHintUsingMode(HintMode);
  end;

  if Highlight then
    LabelPtr.Color := c_HightlightActive
  else
    LabelPtr.Color := c_HightlightInactive;

  LabelPtr.Transparent := False;
  LabelPtr.Visible := GetVisibleUsingMode(VisibleMode);
  LabelPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  if UseLongCaption then
    LabelPtr.Caption := CaptionLong
  else
    LabelPtr.Caption := Caption;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter caption information to a 'TLabel' component.
// Inputs:       TLabel
// Outputs:      None
// Note:         This method is used only to update a label(i.e. the 'caption')
//               associated to the actual data field.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToCaption(LabelPtr: TLabel; CustomCaption: String; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  if (Hint <> c_DefaultHint) then
  begin
    LabelPtr.ShowHint := True ;
    LabelPtr.Hint := GetHintUsingMode(HintMode);
  end;

  if Highlight then
    LabelPtr.Color := c_HightlightActive
  else
    LabelPtr.Color := c_HightlightInactive;

  LabelPtr.Transparent := False;
  LabelPtr.Visible := GetVisibleUsingMode(VisibleMode);
  LabelPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  LabelPtr.Caption := CustomCaption;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter caption information to a 'TLabel' component.
// Inputs:       TLabel
// Outputs:      None
// Note:         This method is used only to update a label(i.e. the 'caption')
//               associated to the actual data field.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToCaption(LabelPtr: TLabel; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode) ;
begin
  if (Hint <> c_DefaultHint) then
  begin
    LabelPtr.ShowHint := True ;
    LabelPtr.Hint := GetHintUsingMode(HintMode);
  end;

  if Highlight then
    LabelPtr.Color := c_HightlightActive
  else
    LabelPtr.Color := c_HightlightInactive;

  LabelPtr.Transparent := False;
  LabelPtr.Visible := GetVisibleUsingMode(VisibleMode);
  LabelPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  LabelPtr.Caption := Caption ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter caption information to a 'TEdit' component.
// Inputs:       TLabel
// Outputs:      None
// Note:         This method is used only to update a label(i.e. the 'caption')
//               associated to the actual data field.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToCaption(EditPtr: TEdit;
  EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode;
  HintMode: TToControlHintMode);
begin
  if (Hint <> c_DefaultHint) then
  begin
    EditPtr.ShowHint := True ;
    EditPtr.Hint := GetHintUsingMode(HintMode);
  end;

  if Highlight then
    EditPtr.Color := c_HightlightActive
  else
    EditPtr.Color := c_HightlightInactive;

  EditPtr.Visible := GetVisibleUsingMode(VisibleMode);
  EditPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  EditPtr.Text := Caption ;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter label information to a 'TComboBox' component.
// Inputs:       TLabel
// Outputs:      None
// Note:         This method is used only to update a label(i.e. the 'caption')
//               associated to the actual data field.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToControl(ControlPtr: TControl;
  EnabledMode: TToControlEnabledMode;
  VisibleMode: TToControlVisibleMode;
  HintMode: TToControlHintMode) ;
begin
  if (False) then // Don't set hint generic ToControl
  begin
    ControlPtr.ShowHint := True ;
    ControlPtr.Hint := GetHintUsingMode(HintMode);
  end;

  ControlPtr.Visible := GetVisibleUsingMode(VisibleMode);
  ControlPtr.Enabled := GetEnabledUsingMode(EnabledMode);
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter label information to a 'TComboBox' component.
// Inputs:       TLabel
// Outputs:      None
// Note:         This method is used only to update a label(i.e. the 'caption')
//               associated to the actual data field.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToControl(MenuItemPtr: TMenuItem;
  EnabledMode: TToControlEnabledMode;
  VisibleMode: TToControlVisibleMode);
begin
  MenuItemPtr.Visible := GetVisibleUsingMode(VisibleMode);
  MenuItemPtr.Enabled := GetEnabledUsingMode(EnabledMode);
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TControl' component.
// Inputs:       TControl
// Outputs:      None
// Note:         This method is used set hint and user level
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToControl(ControlPtr: TControl; UserLevel: TUserLevel; Hint: String) ;
begin
  ControlPtr.Hint := GetHintUsingUserLevel(Hint, UserLevel);
  ControlPtr.Enabled := GetEnabledUserLevel(UserLevel, ulDisplayEnable);
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter caption information to a 'TLabel' component.
// Inputs:       TLabel
// Outputs:      None
// Note:         This method is used only to update a label(i.e. the 'caption')
//               associated to the actual data field.
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToHint(LabelPtr: TLabel; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode) ;
begin
  if (Hint <> c_DefaultHint) then
  begin
    LabelPtr.ShowHint := True ;
    LabelPtr.Hint := GetHintUsingMode(HintMode);
  end;

  LabelPtr.Transparent := False;
  LabelPtr.Visible := GetVisibleUsingMode(VisibleMode);
  LabelPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  LabelPtr.Caption := m_Hint ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TLabel component
// Inputs:       TLabel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToLabel(LabelPtr: TLabel; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  LabelPtr.Color := GetBackgroundColor(c_ColorBackgroundLabel);
  LabelPtr.Font.Color := GetForegroundColor(c_ColorForegroundLabel);

  if (Hint <> c_DefaultHint) then
  begin
    LabelPtr.ShowHint := True ;
    LabelPtr.Hint := GetHintUsingMode(HintMode);
  end;

  LabelPtr.Transparent := False;
  LabelPtr.Visible := GetVisibleUsingMode(VisibleMode);
  LabelPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  LabelPtr.Caption := GetValueAsString();
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TMemo component
// Inputs:       TLabel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToMemo(MemoPtr: TMemo; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  MemoPtr.Color := GetBackgroundColor(c_ColorBackgroundLabel);
  MemoPtr.Font.Color := GetForegroundColor(c_ColorForegroundLabel);

  if (Hint <> c_DefaultHint) then
  begin
    MemoPtr.ShowHint := True ;
    MemoPtr.Hint := GetHintUsingMode(HintMode);
  end;

  MemoPtr.Visible := GetVisibleUsingMode(VisibleMode);
  MemoPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  MemoPtr.Lines.Text := GetValueAsString();
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TMenuItem' component.
// Inputs:       TMenuItem
// Outputs:      None
// Note:         This method is used set hint and user level
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToMenuItem(MenuItemPtr: TMenuItem; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode) ;
begin
  if (Hint <> c_DefaultHint) then
  begin
    MenuItemPtr.Hint := GetHintUsingMode(HintMode);
  end;
  MenuItemPtr.Visible := GetVisibleUsingMode(VisibleMode);
  MenuItemPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  MenuItemPtr.Caption := Caption ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TMenuItem' component.
// Inputs:       TMenuItem
// Outputs:      None
// Note:         This method is used set hint and user level
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToMenuItem(MenuItemPtr: TMenuItem; UserLevel: TUserLevel; Hint: String) ;
begin
  MenuItemPtr.Hint := GetHintUsingUserLevel(Hint, UserLevel);
  MenuItemPtr.Enabled := GetEnabledUserLevel(UserLevel, ulDisplayEnable);
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TTrackEdit component.
// Inputs:       TTrackEdit
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToTrackEdit(TrackEditPtr: TTrackEdit) ;
begin
  // Must be defined in derived class
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TLabel component.
// Inputs:       TLabel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToUnits(LabelPtr: TLabel; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode) ;
begin
  if (Hint <> c_DefaultHint) then
  begin
    LabelPtr.ShowHint := True ;
    LabelPtr.Hint := GetHintUsingMode(HintMode);
  end;

  LabelPtr.Transparent := False;
  LabelPtr.Visible := GetVisibleUsingMode(VisibleMode);
  LabelPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  LabelPtr.Caption := GetValueAsUnits;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TLabel component.
// Inputs:       TLabel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToUnits(EditPtr: TEdit; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode) ;
begin
  if (Hint <> c_DefaultHint) then
  begin
    EditPtr.ShowHint := True ;
    EditPtr.Hint := GetHintUsingMode(HintMode);
  end;

  EditPtr.Visible := GetVisibleUsingMode(VisibleMode);
  EditPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  EditPtr.Text := GetValueAsUnits;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TMemo component
// Inputs:       TLabel
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameter.ToUnits(MemoPtr: TMemo; EnabledMode: TToControlEnabledMode; VisibleMode: TToControlVisibleMode; HintMode: TToControlHintMode);
begin
  MemoPtr.Color := GetBackgroundColor(c_ColorBackgroundLabel);
  MemoPtr.Font.Color := GetForegroundColor(c_ColorForegroundLabel);

  if (Hint <> c_DefaultHint) then
  begin
    MemoPtr.ShowHint := True ;
    MemoPtr.Hint := GetHintUsingMode(HintMode);
  end;

  MemoPtr.Visible := GetVisibleUsingMode(VisibleMode);
  MemoPtr.Enabled := GetEnabledUsingMode(EnabledMode);
  MemoPtr.Lines.Text := GetValueAsUnits();
end ;

procedure TParameter.SetReadbackTimeNextReadAllowed();
var
  readbackMinTimeBetweenReadsInMSec: Int64;
begin
  // Subtract 20 milliseconds from the minimum time to account for timer variability.
  readbackMinTimeBetweenReadsInMSec := m_ReadbackMinTimeBetweenReadsInSec*1000 - 20;

  // Set the next time when another read will be allowed.
  m_ReadbackTimeNextReadAllowed := IncMillisecond(Now(), readbackMinTimeBetweenReadsInMSec);
end;

procedure TParameter.BuildPopUpMenu(PopUpMenu: TPopUpMenu);
var
  newItem: TMenuItem;
  parameterTune: TParameterTune;
begin
  PopupMenu.Items.Clear();

  if (ParameterTypeWobble) then
  begin
    if (Self is TParameterDataWobble) then
    begin
      newItem := TMenuItem.Create(PopupMenu);
      newItem.Caption := 'Start Wobble';
      newItem.Checked := false;
      newItem.OnClick := TParameterDataWobble(Self).StartWobble;
      PopupMenu.Items.Add(newItem);

      newItem := TMenuItem.Create(PopupMenu);
      newItem.Caption := 'Stop Wobble';
      newItem.Checked := false;
      newItem.OnClick := TParameterDataWobble(Self).StopWobble;
      PopupMenu.Items.Add(newItem);

      newItem := TMenuItem.Create(PopupMenu);
      newItem.Caption := 'Wobble Properties...';
      newItem.OnClick := TParameterDataWobble(Self).DisplayWobbleProperties;
      PopupMenu.Items.Add(newItem);
    end
    else if (Self is TParameterPolarityWobble) then
    begin
      newItem := TMenuItem.Create(PopupMenu);
      newItem.Caption := 'Start Wobble';
      newItem.Checked := false;
      newItem.OnClick := TParameterPolarityWobble(Self).StartWobble;
      PopupMenu.Items.Add(newItem);

      newItem := TMenuItem.Create(PopupMenu);
      newItem.Caption := 'Stop Wobble';
      newItem.Checked := false;
      newItem.OnClick := TParameterPolarityWobble(Self).StopWobble;
      PopupMenu.Items.Add(newItem);

      newItem := TMenuItem.Create(PopupMenu);
      newItem.Caption := 'Wobble Properties...';
      newItem.OnClick := TParameterPolarityWobble(Self).DisplayWobbleProperties;
      PopupMenu.Items.Add(newItem);
    end;
  end;

  if (ParameterTypeTune) then
  begin
    if (ParameterTypeWobble) then
    begin
      // add separator
      newItem := TMenuItem.Create(PopupMenu);
      newItem.Caption := '-';
      PopupMenu.Items.Add(newItem);
    end;

    parameterTune := TParameterTune(m_Tune);

    newItem := TMenuItem.Create(PopupMenu);
    newItem.Caption := 'Start Tune';
    newItem.Checked := false;
    newItem.OnClick := parameterTune.StartTune;
    PopupMenu.Items.Add(newItem);

    newItem := TMenuItem.Create(PopupMenu);
    newItem.Caption := 'Stop Tune';
    newItem.Checked := false;
    newItem.OnClick := parameterTune.StopTune;
    PopupMenu.Items.Add(newItem);

    newItem := TMenuItem.Create(PopupMenu);
    newItem.Caption := 'Tune Properties...';
    newItem.OnClick := parameterTune.DisplayTuneProperties;
    PopupMenu.Items.Add(newItem);
  end;
end;

procedure TParameter.ToPopupMenu( PopUpMenu: TPopUpMenu; RealEditPtr: TRealEdit);
begin
  BuildPopUpMenu(PopUpMenu);

  RealEditPtr.PopupMenu := PopUpMenu;
end;

procedure TParameter.ToPopupMenu(PopUpMenu: TPopUpMenu; LabelPtr: TLabel);
begin
  BuildPopUpMenu(PopUpMenu);

  LabelPtr.PopupMenu := PopUpMenu;
end;

end.

