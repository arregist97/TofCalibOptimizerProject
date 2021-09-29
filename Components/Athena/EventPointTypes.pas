unit EventPointTypes;

////////////////////////////////////////////////////////////////////////////////
//
// Filename:       EventPointTypes.pas
//
// Created:         on 01/10/98 by Dave Martel.
//
// Purpose:  This file defines several eventpoint types that can connect to
// the event/client services provided in the event point.pas file..
//
// History:
//
// 1.0- Revisions to base class ??. - Dave Martel 01/10/99
//
// 1.2- Make this code thread safe for use in the CMP and Targa projects. -
//  Al Pike 04/03/2002  Only certain of the original eventpoint types have
// been brought up to the new scheme.
//
// 1.3 - Changed Connect method in event point types so it finds the
//       connection point using ClassType instead of hardcoding the class name.
//       The idea is then we can easily create another event point with
//       something like: TMyIntegerEvent  = class(TIntegerEvent) without
//       defining a new class.
//        - Melinda Caouette 06/23/04
//
// 1.4 - Added TStatusEvent for event client that returns a HResult.
//
// 1.5 - Added TModeChangeEvent
//        - Melinda Caouette 07/21/04
//
// 1.6 - Added TStatusWithDescEvent and upgraded TModeChangedEvent to use
//       the new event point features.
//         - Melinda Caouette 09/20/04
//
// 1.7 - Updated TDoubleEvent to the latest event point scheme.
//         - Melinda Caouette 03/08/05
//
// 1.8 - Added TTaskChangedEvent
//         - Melinda Caouette 04/28/05
//
// 1.9 - Added TTwoIntegerEvent, TTwoDoubleEvent
//         - Melinda Caouette 05/19/05
//
// 1.10 - Added TTwoSingleEvent
//         - Melinda Caouette 05/23/05
//
// 1.11 - Added TWordBoolEvent
//         - Melinda Caouette 12/05/05
//
// 1.14 - Added TOleVarEvent, TTwoOleVarEvent
//         - Daniel Klooster 03/03/06
//
// 1.15 - Added TNameEvent
//         - Melinda Caouette 08/18/06
//
// 1.16 - Added TDoubleWordBoolEvent, TSingleWordBoolEvent
//         - Melinda Caouette 12/12/06
//
// 1.17 - Added TTwoDoubleEvent
//         - Daniel Klooster 01/15/07
//
// 1.18 - Added TIntegerWordBoolEvent
//         - Melinda Caouette 06/28/07
//
// 1.19 - Added TTimedOnChangedEvent
//         - Melinda Caouette 10/29/10
//
// Copyright © 1999-2014 Physical Electronics USA
//
// Created in 1999 as an unpublished copyrighted work.  This program and the
// information contained in it are confidential and proprietary to Physical
// Electronics and may not be used, copied, or reproduced without the prior
// written permission of Physical Electronics.
//
////////////////////////////////////////////////////////////////////////////////

interface

uses

  // Delphi Units
  classes,
  contnrs,

  // PHI Units
  EventPoint;

type

////////////////////////////////////////////////////////////////////////////////
//
// Classes declared in this file
//
//  TObject
//    TEventClient
        TNullEvent = class;
        TIntegerEvent = class;
          TTimedIntegerEvent = class;
        TTwoIntegerEvent = class;
        TDoubleEvent = class;
        TTwoDoubleEvent = class;
        TThreeDoubleEvent = class;
        TSingleEvent = class;
        TTwoSingleEvent = class;
        TThreeSingleEvent = class;
        TDoubleIntegerEvent = class;
        TIntegerDoubleEvent = class;
        TSingleIntegerEvent = class;
        TTaskCompleteEvent = class;
        TTaskChangedEvent = class;
        TStatusEvent = class;
        TStatusWithDescEvent = class;
        TModeChangedEvent = class;
        TWordBoolEvent = class;
        TDoubleWordBoolEvent = class;
        TSingleWordBoolEvent = class;
        TIntegerWordBoolEvent = class;
        TFourWordBoolEvent = class;
        TSevenWordBoolEvent = class;
        TOleVarEvent = class;
        TTwoOleVarEvent = class;
        TTimedOnChangedEvent = class;
        TTwoDoubleAndStrEvent = class;
        TNameEvent = class;
        TStringChangedEvent = class;
        TIntegerWithDescEvent = class;
        TStatusMessageEvent = class;
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TNullEvent class.
//
////////////////////////////////////////////////////////////////////////////////

TOnNullEvent = TNotifyEvent;
TNullEvent = class(TEventClient)

// Operations
public
  procedure NewEvent(); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnNullEvent;

// properties
published
  property OnEvent : TOnNullEvent
    read FOnEvent
    write FOnEvent;
end;


////////////////////////////////////////////////////////////////////////////////
//
// interface for the TIntegerEvent class.
//
////////////////////////////////////////////////////////////////////////////////

TOnNewEventInteger = procedure(Sender: TObject; Reading: Integer) of object;
TIntegerEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; newvalue: Integer); overload;

// Operations
public
  procedure NewEvent(Reading: Integer); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnNewEventInteger;

// properties
published
  property OnEvent : TOnNewEventInteger
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TTwoIntegerEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold two integer values
TTwoIntegerData = record
  Integer1: Integer;
  Integer2: Integer;
end;

TOnTTwoInteger = procedure(Sender: TObject; Integer1: Integer; Integer2: Integer) of object;
TTwoIntegerEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; Integer1: Integer; Integer2: Integer); overload;

// Operations
public
  procedure NewEvent(Integer1: Integer; Integer2: Integer); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnTTwoInteger;

// properties
published
  property OnEvent : TOnTTwoInteger
    read FOnEvent
    write FOnEvent;
end;


////////////////////////////////////////////////////////////////////////////////
//
// interface for the TFourWordBoolEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold four WordBool values
TFourWordBoolData = record
  WordBool1: WordBool;
  WordBool2: WordBool;
  WordBool3: WordBool;
  WordBool4: WordBool;
end;

TOnTFourWordBoolData = procedure(Sender: TObject; WordBool1: WordBool; WordBool2: WordBool;
  WordBool3: WordBool;WordBool4: WordBool) of object;
TFourWordBoolEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; WordBool1: WordBool; WordBool2: WordBool;
  WordBool3: WordBool;WordBool4: WordBool); overload;

// Operations
public
  procedure NewEvent(WordBool1: WordBool; WordBool2: WordBool;
  WordBool3: WordBool;WordBool4: WordBool); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnTFourWordBoolData;

// properties
published
  property OnEvent : TOnTFourWordBoolData
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TSevenWordBoolEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold seven WordBool values
TSevenWordBoolData = record
  WordBool1: WordBool;
  WordBool2: WordBool;
  WordBool3: WordBool;
  WordBool4: WordBool;
  WordBool5: WordBool;
  WordBool6: WordBool;
  WordBool7: WordBool;
end;

TOnTSevenWordBoolData = procedure(Sender: TObject; WordBool1: WordBool; WordBool2: WordBool;
  WordBool3: WordBool; WordBool4: WordBool; WordBool5: WordBool; WordBool6: WordBool; WordBool7: WordBool) of object;
TSevenWordBoolEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; WordBool1: WordBool; WordBool2: WordBool;
  WordBool3: WordBool;WordBool4: WordBool; WordBool5: WordBool; WordBool6: WordBool; WordBool7: WordBool); overload;

// Operations
public
  procedure NewEvent(WordBool1: WordBool; WordBool2: WordBool;
    WordBool3: WordBool; WordBool4: WordBool; WordBool5: WordBool; WordBool6: WordBool; WordBool7: WordBool); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnTSevenWordBoolData;

// properties
published
  property OnEvent : TOnTSevenWordBoolData
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TTwoDoubleEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold two double values
TTwoDoubleData = record
  Double1: Double;
  Double2: Double;
end;

TOnTTwoDouble = procedure(Sender: TObject; Double1: Double; Double2: Double) of object;
TTwoDoubleEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; Double1: Double; Double2: Double); overload;

// Operations
public
  procedure NewEvent(Double1: Double; Double2: Double); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnTTwoDouble;

// properties
published
  property OnEvent : TOnTTwoDouble
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TThreeDoubleEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold three double values
TThreeDoubleData = record
  Double1: Double;
  Double2: Double;
  Double3: Double;
end;

TOnTThreeDouble = procedure(Sender: TObject; Double1: Double; Double2: Double; Double3: Double) of object;
TThreeDoubleEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; Double1: Double; Double2: Double; Double3: Double); overload;

// Operations
public
  procedure NewEvent(Double1: Double; Double2: Double; Double3: Double); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnTThreeDouble;

// properties
published
  property OnEvent : TOnTThreeDouble
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TTwoSingleEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold two float values
TTwoSingleData = record
  Single1: Single;
  Single2: Single;
end;

TOnTTwoSingle = procedure(Sender: TObject; Single1: Single; Single2: Single) of object;
TTwoSingleEvent= class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; Single1: Single; Single2: Single); overload;

// Operations
public
  procedure NewEvent(Single1: Single; Single2: Single); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnTTwoSingle;

// properties
published
  property OnEvent : TOnTTwoSingle
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TThreeSingleEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold three float values
TThreeSingleData = record
  Single1: Single;
  Single2: Single;
  Single3: Single;
end;

TOnThreeSingle = procedure(Sender: TObject; Single1: Single; Single2: Single; Single3: Single) of object;
TThreeSingleEvent= class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; Single1: Single; Single2: Single; Single3: Single); overload;

// Operations
public
  procedure NewEvent(Single1: Single; Single2: Single; Single3: Single); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnThreeSingle;

// properties
published
  property OnEvent : TOnThreeSingle
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TTwoIntegerOneSingleEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold two integer and one single values
TTwoIntegerOneSingleData = record
  Integer1: Integer;
  Integer2: Integer;
  Single1: Single;
end;

TOnTwoIntegerOneSingle = procedure(Sender: TObject; Integer1: Integer; Integer2: Integer; Single1: Single) of object;
TTwoIntegerOneSingleEvent= class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; Integer1: Integer; Integer2: Integer; Single1: Single); overload;

// Operations
public
  procedure NewEvent(Integer1: Integer; Integer2: Integer; Single1: Single); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnTwoIntegerOneSingle;

// properties
published
  property OnEvent : TOnTwoIntegerOneSingle
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TDoubleIntegerEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold two float values
TDoubleIntegerData = record
  Double1: Double;
  Integer1: Integer;
end;

TOnTDoubleInteger = procedure(Sender: TObject; Double1: Double; Integer1: Integer) of object;
TDoubleIntegerEvent= class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; Double1: Double; Integer1: Integer); overload;

// Operations
public
  procedure NewEvent(Double1: Double; Integer1: Integer); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnTDoubleInteger;

// properties
published
  property OnEvent : TOnTDoubleInteger
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TIntegerDoubleEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold and integer and a double
TIntegerDoubleData = record
  Double1: Double;
  Integer1: Integer;
end;

TOnIntegerDouble = procedure(Sender: TObject; Integer1: Integer; Double1: Double) of object;

TIntegerDoubleEvent= class(TEventClient)
// class functions
public
  class procedure SetData(EventPoint: TEventPoint; Integer1: Integer; Double1: Double); overload;

// Operations
public
  procedure NewEvent(Integer1: Integer; Double1: Double); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnIntegerDouble;

// properties
published
  property OnEvent: TOnIntegerDouble read FOnEvent write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TSingleIntegerEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold one single and one integer
TSingleIntegerData = record
  Single1: Single;
  Integer1: Integer;
end;

TOnSingleInteger = procedure(Sender: TObject; Single1: Single; Integer1: Integer) of object;
TSingleIntegerEvent= class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; Single1: Single; Integer1: Integer); overload;

// Operations
public
  procedure NewEvent(Single1: Single; Integer1: Integer); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnSingleInteger;

// properties
published
  property OnEvent : TOnSingleInteger
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TWordBoolEvent class.
//
////////////////////////////////////////////////////////////////////////////////

TOnNewEventWordBool = procedure(Sender: TObject; Reading: WordBool) of object;
TWordBoolEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; newvalue: WordBool); overload;

// Operations
public
  procedure NewEvent(Reading: WordBool); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnNewEventWordBool;

// properties
published
  property OnEvent : TOnNewEventWordBool
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TDoubleWordBoolEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold two float values
TDoubleWordBoolData = record
  DoubleValue: Double;
  BoolValue: WordBool;
end;

TOnNewEventDoubleWordBool = procedure(Sender: TObject; DoubleValue: Double; BoolValue: WordBool) of object;
TDoubleWordBoolEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; DoubleValue: Double; BoolValue: WordBool); overload;

// Operations
public
  procedure NewEvent(DoubleValue: Double; BoolValue: WordBool); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnNewEventDoubleWordBool;

// properties
published
  property OnEvent : TOnNewEventDoubleWordBool
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TSingleWordBoolEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold two float values
TSingleWordBoolData = record
  SingleValue: Single;
  BoolValue: WordBool;
end;

TOnNewEventSingleWordBool = procedure(Sender: TObject; SingleValue: Single; BoolValue: WordBool) of object;
TSingleWordBoolEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; SingleValue: Single; BoolValue: WordBool); overload;

// Operations
public
  procedure NewEvent(SingleValue: Single; BoolValue: WordBool); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnNewEventSingleWordBool;

// properties
published
  property OnEvent : TOnNewEventSingleWordBool
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TIntegerWordBoolEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold two float values
TIntegerWordBoolData = record
  IntegerValue: Integer;
  BoolValue: WordBool;
end;

TOnNewEventIntegerWordBool = procedure(Sender: TObject; IntegerValue: Integer; BoolValue: WordBool) of object;
TIntegerWordBoolEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; IntegerValue: Integer; BoolValue: WordBool); overload;

// Operations
public
  procedure NewEvent(IntegerValue: Integer; BoolValue: WordBool); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnNewEventIntegerWordBool;

// properties
published
  property OnEvent : TOnNewEventIntegerWordBool
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TTimedIntegerEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// The event signature.
TOnNewEventTimedInteger = procedure(Sender : TObject; Time: TDateTime;
  Reading: Integer) of object;

// data strucutre to hold this data.
TTimedIntegerData = record
  Reading: Integer;
  Time: TDateTime;
end;

TTimedIntegerEvent = class(TIntegerEvent)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; Time: TDateTime;
    newvalue: Integer); overload;

// Operations
public
  procedure NewEvent(Time: TDateTime; Reading: Integer); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Attributes
private
  FOnEvent : TOnNewEventTimedInteger;

// Properties
published
  property OnEvent : TOnNewEventTimedInteger
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TDoubleEvent class.
//
////////////////////////////////////////////////////////////////////////////////

TOnNewEventDouble = procedure(Sender : TObject; Reading: Double) of object;
TDoubleEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; fNewValue: Double); overload;

// Operations
public
  procedure NewEvent(Reading: Double); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnNewEventDouble;

// properties
published
  property OnEvent : TOnNewEventDouble read FOnEvent write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TSingleEvent class.
//
////////////////////////////////////////////////////////////////////////////////

TOnNewEventSingle = procedure(Sender : TObject; Reading: Single) of object;
TSingleEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; fNewValue: Single); overload;

// Operations
public
  procedure NewEvent(Reading: Single); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnNewEventSingle;

// properties
published
  property OnEvent : TOnNewEventSingle read FOnEvent write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TOleVarEvent class.
//
////////////////////////////////////////////////////////////////////////////////

TOnNewEventOleVar = procedure(Sender : TObject; Reading: OleVariant) of object;
TOleVarEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; NewValue: OleVariant); overload;

// Operations
public
  procedure NewEvent(Reading: OleVariant); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnNewEventOleVar;

// properties
published
  property OnEvent : TOnNewEventOleVar read FOnEvent write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TStatusIntegerEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold event data.
TStatusIntegerData = record
  StatusCode: HRESULT;
  nNoOfFrames: Integer;
end;

TOnStatusInteger = procedure (Sender : TObject;
  StatusCode: HRESULT; nNoOfFrames: Integer) of object;
TStatusIntegerEvent = class(TEventClient)

// Class functions
public
  class procedure SetData(EventPoint: TEventPoint;
    StatusCode: HRESULT; nNoOfFrames: Integer); overload;

    // Operations
public
  procedure NewEvent(StatusCode: HRESULT; nNoOfFrames: Integer); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnStatusInteger;

// properties
published
  property OnEvent: TOnStatusInteger
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TTwoOleVarEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold two float values
TTwoOleVarData = record
  OleVar1: OleVariant;
  OleVar2: OleVariant;
end;

TOnNewEventTwoOleVar = procedure(Sender : TObject; OleVar1: OleVariant;
  OleVar2: OleVariant) of object;

TTwoOleVarEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; NewValue1: OleVariant;
    NewValue2: OleVariant); overload;

// Operations
public
  procedure NewEvent(Reading1: OleVariant; Reading2: OleVariant); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnNewEventTwoOleVar;

// properties
published
  property OnEvent : TOnNewEventTwoOleVar read FOnEvent write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TModeChangedEvent class.
//
////////////////////////////////////////////////////////////////////////////////

TOnModeChanged = procedure(Sender: TObject; NewMode: Integer) of object;
TModeChangedEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; NewMode: Integer); overload;

// Operations
public
  procedure NewEvent(NewMode: Integer); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnModeChanged;

// properties
published
  property OnEvent : TOnModeChanged
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TTaskCompleteEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold event data.
TTaskCompleteData = record
  TaskID: Integer;
  rc: HRESULT;
  resString: array [0..255] of char;
end;

TOnTaskComplete = procedure (Sender : TObject; TaskID: Integer; rc: HRESULT;
  resString: string) of object;
TTaskCompleteEvent = class(TEventClient)

// Class functions
public
  class procedure SetData(EventPoint: TEventPoint;
    TaskID: Integer; rc: HRESULT; resString: string); overload;

    // Operations
public
  procedure NewEvent(TaskID: Integer; rc: HRESULT; resString: string); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnTaskComplete;

// properties
published
  property OnEvent: TOnTaskComplete
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TTaskChangedEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold event data.
TTaskChangedData = record
  TaskID: Integer;
  TaskStatus: Integer;
  rc: HRESULT;
  resString: array [0..255] of char;
end;

TOnTaskChanged = procedure (Sender : TObject; TaskID: Integer; TaskStatus: Integer;
  rc: HRESULT; resString: string) of object;
TTaskChangedEvent = class(TEventClient)

// Class functions
public
  class procedure SetData(EventPoint: TEventPoint;
    TaskID: Integer; TaskStatus: Integer; rc: HRESULT; resString: string); overload;

    // Operations
public
  procedure NewEvent(TaskID: Integer; TaskStatus: Integer;
                     rc: HRESULT; resString: string); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnTaskChanged;

// properties
published
  property OnEvent: TOnTaskChanged
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TModeChangeEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold event data.
TModeChangeEventData = record
  PreviousModeID: Integer;
  NewModeID: Integer;
  rc: HRESULT;
  resString: array [0..255] of char;
end;

TOnModeChange = procedure (Sender : TObject; PreviousModeID: Integer;
  NewModeID: Integer; rc: HRESULT; resString: string) of object;
TModeChangeEvent = class(TEventClient)

// Class functions
public
  class procedure SetData(EventPoint: TEventPoint;
    PreviousModeID: Integer; NewModeID: Integer;
    rc: HRESULT; resString: string); overload;

    // Operations
public
  procedure NewEvent(PreviousModeID: Integer; NewModeID: Integer;
    rc: HRESULT; resString: string); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnModeChange;

// properties
published
  property OnEvent: TOnModeChange
    read FOnEvent
    write FOnEvent;
end;


////////////////////////////////////////////////////////////////////////////////
//
// interface for the TStatusEvent class.
//
////////////////////////////////////////////////////////////////////////////////

TOnEventStatus = procedure (Sender : TObject; ReturnCode: HRESULT) of object;
TStatusEvent = class(TEventClient)

// Class functions
public
  class procedure SetData(EventPoint: TEventPoint; newValue: HRESULT); overload;

// Operations
public
  procedure NewEvent(ReturnCode: HRESULT); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnEventStatus;

// properties
published
  property OnEvent: TOnEventStatus
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TIntegerWithDescEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold event data.
TIntegerWithDescEventData = record
  Integer1: Integer;
  StatusDescription: array [0..511] of char;
end;

TOnIntegerWithDesc = procedure (Sender : TObject;
  Integer1: Integer; StatusDescription: string) of object;
TIntegerWithDescEvent = class(TEventClient)

// Class functions
public
  class procedure SetData(EventPoint: TEventPoint;
    Integer1: Integer; StatusDescription: string); overload;

    // Operations
public
  procedure NewEvent(Integer1: Integer; StatusDescription: string); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnIntegerWithDesc;

// properties
published
  property OnEvent: TOnIntegerWithDesc
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TStatusWithDescEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold event data.
TStatusWithDescEventData = record
  StatusCode: HRESULT;
  StatusDescription: array [0..511] of char;
end;

TOnStatusWithDesc = procedure (Sender : TObject;
  StatusCode: HRESULT; StatusDescription: string) of object;
TStatusWithDescEvent = class(TEventClient)

// Class functions
public
  class procedure SetData(EventPoint: TEventPoint;
    StatusCode: HRESULT; StatusDescription: string); overload;

    // Operations
public
  procedure NewEvent(StatusCode: HRESULT; StatusDescription: string); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnStatusWithDesc;

// properties
published
  property OnEvent: TOnStatusWithDesc
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TStatusMessageEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold event data.
TStatusMessageEventData = record
  StatusMessage: array [0..511] of char;
end;

TOnStatusMessage = procedure (Sender : TObject;
  StatusMessage: string) of object;
TStatusMessageEvent = class(TEventClient)

// Class functions
public
  class procedure SetData(EventPoint: TEventPoint;
    StatusMessage: string); overload;

    // Operations
public
  procedure NewEvent(StatusMessage: string); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnStatusMessage;

// properties
published
  property OnEvent: TOnStatusMessage
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TStringChangedEvent class.
//
////////////////////////////////////////////////////////////////////////////////

TOnStringChanged = procedure (Sender : TObject; NewString: String) of object;
TStringChangedEvent = class(TEventClient)

// Class functions
public
  class procedure SetData(EventPoint: TEventPoint; NewString: String); virtual;

    // Operations
public
  procedure NewEvent(NewString: String); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnStringChanged;

// properties
published
  property OnEvent: TOnStringChanged
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for task progress event class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold event data.
TTaskProgressData = record
  fTotalWaitTimeInS: Single;
  fWaitTimeLeftInS: Single;
  TaskID: Integer;
  TaskDescription: array [0..255] of char;
end;

TOnTaskProgress = procedure (Sender : TObject;
  fTotalWaitTimeInS: Single; fWaitTimeLeftInS: Single; TaskID: Integer; TaskDescription: String) of object;
TTaskProgressEvent = class(TEventClient)

// Class functions
public
  class procedure SetData(EventPoint: TEventPoint;
    fTotalWaitTimeInS: Single; fWaitTimeLeftInS: Single; TaskID: Integer; TaskDescription: String); overload;

    // Operations
public
  procedure NewEvent(fTotalWaitTimeInS: Single; fWaitTimeLeftInS: Single; TaskID: Integer; TaskDescription: String); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnTaskProgress;

// properties
published
  property OnEvent: TOnTaskProgress
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TNameEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold event data.
TNameEventData = record
  Name: array [0..255] of char;
end;

TOnName = procedure (Sender : TObject; Name: string) of object;
TNameEvent = class(TEventClient)

// Class functions
public
  class procedure SetData(EventPoint: TEventPoint; Name: string); overload;

    // Operations
public
  procedure NewEvent(Name: string); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnName;

// properties
published
  property OnEvent: TOnName
    read FOnEvent
    write FOnEvent;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TTimedOnChangedEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold event data
TTimedOnChangedData = record
  fRemainingOnTimeInMin: Single;
  bOnDone: WordBool;
  StatusCode: HRESULT;
end;

TOnTimedonChangedEvent = procedure (Sender : TObject; fRemainingOnTimeInMin: Single;
  bOnDone: WordBool; StatusCode: HRESULT) of object;

TTimedOnChangedEvent = class(TEventClient)
// Class functions
public
  class procedure SetData(EventPoint: TEventPoint;
    fRemainingOnTimeInMin: Single; bOnDone: WordBool; StatusCode: HRESULT); overload;

// Operations
public
  procedure NewEvent(fRemainingOnTimeInMin: Single; bOnDone: WordBool; StatusCode: HRESULT); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
private
  FOnEvent: TOnTimedonChangedEvent;

// properties
published
  property OnEvent: TOnTimedonChangedEvent
    read FOnEvent
    write FOnEvent;
end;


TOnNewEventTimedDouble = procedure ( Sender : TObject; Time: TDateTime; Reading: Double ) of object;
TTimedDoubleEvent = class(TEventClient)
private
  FServer : TEventPoint;
  FOnEvent : TOnNewEventTimedDouble;
  FTag : Integer;
public
  procedure Connect(Server : TEventContainer); override;
  procedure Disconnect(fatal: BOOLEAN = TRUE); override;
  procedure NewEvent(Time: TDateTime; Reading: Double);
  property OnEvent : TOnNewEventTimedDouble write FOnEvent;
  property Tag : Integer read FTag write FTag;
end;

TOnNewTimedString = procedure ( Sender : TObject; Time: TDateTime; Value : String ) of object;
TTimedStringEvent = class(TEventClient)
private
  FServer : TEventPoint;
  FOnNewEvent : TOnNewTimedString;
  FTag : Integer;
public
  procedure Connect(Server : TEventContainer); override;
  procedure Disconnect(fatal: BOOLEAN = TRUE); override;
  procedure NewString(Time: TDateTime; Value: String);
  property OnNewString : TOnNewTimedString write FOnNewEvent;
  property Tag : Integer read FTag write FTag;
end;

{Return a string}
TOnNewString = procedure ( Sender : TObject; Value : String ) of object;
TStringEvent = class(TEventClient)
private
  FServer : TEventPoint;
  FOnNewEvent : TOnNewString;
  FTag : Integer;
public
  procedure Connect(Server : TEventContainer); override;
  procedure Disconnect(fatal: BOOLEAN = TRUE); override;
  procedure NewString(Value: String);
  property OnNewString : TOnNewString write FOnNewEvent;
  property Tag : Integer read FTag write FTag;
end;

{Return an integer and an object list}
TOnNewEventObjectList = procedure ( Sender : TObject; CurrentIndex: Integer; Values: TObjectList ) of object;
TObjectListEvent = class(TEventClient)
private
  FServer : TEventPoint;
  FOnEvent : TOnNewEventObjectList;
  FTag : Integer;
public
  procedure Connect(Server : TEventContainer); override;
  procedure Disconnect(fatal: BOOLEAN = TRUE); override;
  procedure NewEvent(CurrentIndex: Integer; Values: TObjectList);
  property OnEvent : TOnNewEventObjectList read FOnEvent write FOnEvent;
  property Tag : Integer read FTag write FTag;
end;

{Return an integer array}
TOnNewEventIntegerArray = procedure ( Sender : TObject; Values: array of integer ) of object;
TIntegerArrayEvent = class(TEventClient)
private
  FServer : TEventPoint;
  FOnEvent : TOnNewEventIntegerArray;
  FTag : Integer;
public
  procedure Connect(Server : TEventContainer); override;
  procedure Disconnect(fatal: BOOLEAN = TRUE); override;
  procedure NewEvent(Values: array of integer);
  property OnEvent : TOnNewEventIntegerArray read FOnEvent write FOnEvent;
  property Tag : Integer read FTag write FTag;
end;

////////////////////////////////////////////////////////////////////////////////
//
// interface for the TTwoDoubleAndStrEvent class.
//
////////////////////////////////////////////////////////////////////////////////

// data strucutre to hold two double values and a string
TTwoDoubleAndStrData = record
  Double1: Double;
  Double2: Double;
  Str: array [0..511] of char;
end;

TOnTTwoDoubleAndStr = procedure(Sender: TObject; Double1: Double; Double2: Double; Str: String) of object;
TTwoDoubleAndStrEvent = class(TEventClient)

// class functions
public
  class procedure SetData(EventPoint: TEventPoint; Double1: Double; Double2: Double; Str: String); overload;

// Operations
public
  procedure NewEvent(Double1: Double; Double2: Double; Str: String); overload;

// overrides
public
  procedure CallEvent(ClientData: pointer); override;

// Atrributes
protected
  FOnEvent : TOnTTwoDoubleAndStr;

// properties
published
  property OnEvent : TOnTTwoDoubleAndStr
    read FOnEvent
    write FOnEvent;
end;

implementation

uses
  sysutils;

{ TNullEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TNullEvent
//
// Description:
//
// Class provides to provide client/event services for the null event.
//
////////////////////////////////////////////////////////////////////////////////

procedure TNullEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs:
//
// ClientData:  pointer with the memory of the data that will be passed to the
// event handlers.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////

begin

  // Call the base class to allow the Disconnect. A time out here indicates that
  // you disconnect before you called the event.
  inherited;
  NewEvent();
end;

procedure TNullEvent.NewEvent;
begin
   if Assigned(FOnEvent) then
  begin
    FOnEvent(Self);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TIntegerEvent
//
// Description:
//
// Class provides to provide client/event services for the Integer data type.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Class TIntegerEvent
//
// Class Functions
//
////////////////////////////////////////////////////////////////////////////////

class procedure TIntegerEvent.SetData(EventPoint: TEventPoint;
  newvalue: Integer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TIntegerEvent.SetData() and never from
// Delphi objects of type TIntegerEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
//
// newValue: The new value of the data to call the clients with.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(Integer));
  Integer(pData^) := newvalue;
  EventPoint.SetClientData(pData);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TIntegerEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TIntegerEvent.NewEvent(Reading: Integer);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Reading);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TIntegerEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TIntegerEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Call the base class to allow the Disconnect. A time out here indocates that
  // you disconnect before you called the event.
  inherited;
  if (assigned(ClientData)) then
    NewEvent(Integer(ClientData^));
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TTimedIntegerEvent
//
// Description:
//
// Class provides to provide client/event services for the Integer data type.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Class TTimedEventClient
//
// Class Functions
//
////////////////////////////////////////////////////////////////////////////////

class procedure TTimedIntegerEvent.SetData(EventPoint: TEventPoint;
  Time: TDateTime; newvalue: Integer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TIntegerEvent.SetData() and never from
// Delphi objects of type TIntegerEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
//
// newValue: The new value of the data to call the clients with.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTimedIntegerData));
  TTimedIntegerData(pData^).Reading := newvalue;
  TTimedIntegerData(pData^).Time := Time;
  EventPoint.SetClientData(pData);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TTimedIntegerEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TTimedIntegerEvent.NewEvent(Time: TDateTime; Reading: Integer);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Time, Reading);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TTimedIntegerEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TTimedIntegerEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TTimedIntegerData(ClientData^).Time,
    TTimedIntegerData(ClientData^).Reading);
end;

{TDoubleEvent}

////////////////////////////////////////////////////////////////////////////////
//
// Class TDoubleEvent
//
// Description:
//
// Class provides to provide client/event services for the Double data type.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Class TDoubleEvent
//
// Class Functions
//
////////////////////////////////////////////////////////////////////////////////

class procedure TDoubleEvent.SetData(EventPoint: TEventPoint; fNewValue: Double);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TDoubleEvent.SetData() and never from
// Delphi objects of type TDoubleEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
//
// fNewValue: The new value of the data to call the clients with.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(Double));
  Double(pData^) := fNewValue;
  EventPoint.SetClientData(pData);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TDoubleEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TDoubleEvent.NewEvent(Reading: Double);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Reading);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TDoubleEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TDoubleEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Call the base class to allow the Disconnect. A time out here indocates that
  // you disconnect before you called the event.
  inherited;
  if (assigned(ClientData)) then
    NewEvent(Double(ClientData^));
end;

{ TModeChangedEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TModeChangedEvent
//
// Description:
//
// Class provides to provide client/event services for Mode Changed Event.
// Mode is of type Integer.
//
////////////////////////////////////////////////////////////////////////////////

class procedure TModeChangedEvent.SetData(EventPoint: TEventPoint;
  NewMode: Integer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TModeChangedEvent.SetData() and never from
// Delphi objects of type TModeChangedEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
//
// NewMode: The new value of the data to call the clients with.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(Integer));
  Integer(pData^) := NewMode;
  EventPoint.SetClientData(pData);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TModeChangedEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TModeChangedEvent.NewEvent(NewMode: Integer);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, NewMode);
  end
end;

procedure TModeChangedEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Call the base class to allow the Disconnect. A time out here indocates that
  // you disconnect before you called the event.
  inherited;
  if (assigned(ClientData)) then
    NewEvent(Integer(ClientData^));
end;

{ TIntegerWithDescEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TIntegerWithDescEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TIntegerWithDescEvent.NewEvent(
  Integer1: Integer;
  StatusDescription: string
);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self,
      Integer1,
      StatusDescription);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TIntegerWithDescEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TIntegerWithDescEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TIntegerWithDescEventData(ClientData^).Integer1,
           TIntegerWithDescEventData(ClientData^).StatusDescription);

  // Critical need to call base class;
  inherited;
end;

class procedure TIntegerWithDescEvent.SetData(EventPoint: TEventPoint;
  Integer1: Integer; StatusDescription: string);
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TIntegerWithDescEventData));
  TIntegerWithDescEventData(pData^).Integer1 := Integer1;
  StrLFmt(TIntegerWithDescEventData(pData^).StatusDescription,
    511, '%s',
    [StatusDescription]);
  EventPoint.SetClientData(pData);
end;


{ TStatusWithDescEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TStatusWithDescEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TStatusWithDescEvent.NewEvent(StatusCode: HRESULT;
  StatusDescription: string);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self,
      StatusCode,
      StatusDescription);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TStatusWithDescEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TStatusWithDescEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TStatusWithDescEventData(ClientData^).StatusCode,
           TStatusWithDescEventData(ClientData^).StatusDescription);

  // Critical need to call base class;
  inherited;
end;

class procedure TStatusWithDescEvent.SetData(EventPoint: TEventPoint;
  StatusCode: HRESULT; StatusDescription: string);
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TStatusWithDescEventData));
  TStatusWithDescEventData(pData^).StatusCode := StatusCode;
  StrLFmt(TStatusWithDescEventData(pData^).StatusDescription,
    511, '%s',
    [StatusDescription]);
  EventPoint.SetClientData(pData);
end;


{ TStatusMessageEvent}

////////////////////////////////////////////////////////////////////////////////
//
// Class TStatusMessageEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TStatusMessageEvent.NewEvent(StatusMessage: string);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self,
      StatusMessage);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TStatusMessageEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TStatusMessageEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TStatusMessageEventData(ClientData^).StatusMessage);

  // Critical need to call base class;
  inherited;
end;

class procedure TStatusMessageEvent.SetData(EventPoint: TEventPoint;
  StatusMessage: string);
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TStatusMessageEventData));
  StrLFmt(TStatusMessageEventData(pData^).StatusMessage,
    511, '%s',
    [StatusMessage]);
  EventPoint.SetClientData(pData);
end;

{ TStringChangedEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TStringChangedEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TStringChangedEvent.NewEvent(NewString: String);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self,NewString);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TStringChangedEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TStringChangedEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
// Note that ClientData points at a null-terminated array of Char (aka WideChar,
// ie 16bit unicode characters)
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(PChar(ClientData)); //The compiler implicitly converts the PChar to a Pascal string

  // Critical need to call base class;
  inherited;
end;

class procedure TStringChangedEvent.SetData(EventPoint: TEventPoint; NewString: String);
var
  tempPWideChar: PChar;
  strLen: Integer;
begin
  strLen := Length(NewString);
  // Allocate the memory for the event point data.
  tempPWideChar := AllocMem((strLen+1)*sizeof(Char)); //Note 1 is added for the zero terminator.
  // Copy the WideChars into the allocated memory
  StrLFmt(tempPWideChar,strLen, '%s',[NewString]);
  EventPoint.SetClientData(tempPWideChar);
end;



{ TTaskProgressEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TTaskProgressEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TTaskProgressEvent.NewEvent(
  fTotalWaitTimeInS: Single;
  fWaitTimeLeftInS: Single;
  TaskID: Integer;
  TaskDescription: String
);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self,
      fTotalWaitTimeInS,
      fWaitTimeLeftInS,
      TaskID,
      TaskDescription);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TStatusWithDescEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TTaskProgressEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(
    TTaskProgressData(ClientData^).fTotalWaitTimeInS,
    TTaskProgressData(ClientData^).fWaitTimeLeftInS,
    TTaskProgressData(ClientData^).TaskID,
    TTaskProgressData(ClientData^).TaskDescription);

  // Critical need to call base class;
  inherited;
end;

class procedure TTaskProgressEvent.SetData(
  EventPoint: TEventPoint;
  fTotalWaitTimeInS: Single;
  fWaitTimeLeftInS: Single;
  TaskID: Integer;
  TaskDescription: String
);
var
  pData: pointer;
begin
  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTaskProgressData));
  TTaskProgressData(pData^).fTotalWaitTimeInS := fTotalWaitTimeInS;
  TTaskProgressData(pData^).fWaitTimeLeftInS := fWaitTimeLeftInS;
  TTaskProgressData(pData^).TaskID := TaskID;
  StrLFmt(TTaskProgressData(pData^).TaskDescription,
    255, '%s',
    [TaskDescription]);
  EventPoint.SetClientData(pData);
end;

{ TNameEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TNameEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TNameEvent.NewEvent(Name: string);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Name);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TNameEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TNameEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TNameEventData(ClientData^).Name);

  // Critical need to call base class;
  inherited;
end;

class procedure TNameEvent.SetData(EventPoint: TEventPoint; Name: string);
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TNameEventData));
  StrLFmt(TNameEventData(pData^).Name,
    255, '%s',
    [Name]);
  EventPoint.SetClientData(pData);
end;


{ TTaskCompleteEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TTaskCompleteEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TTaskCompleteEvent.NewEvent(TaskID: Integer; rc: HRESULT;
  resString: string);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self,
      TaskID,
      rc,
      resString);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TTaskCompleteEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TTaskCompleteEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TTaskCompleteData(ClientData^).TaskID,
    TTaskCompleteData(ClientData^).rc,
    TTaskCompleteData(ClientData^).resstring);

  // Critical need to call base class;
  inherited;
end;

class procedure TTaskCompleteEvent.SetData(EventPoint: TEventPoint;
  TaskID: Integer; rc: HRESULT; resString: string);
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTaskCompleteData));
  TTaskCompleteData(pData^).TaskID := TaskID;
  TTaskCompleteData(pData^).rc := rc;
  StrLFmt(TTaskCompleteData(pData^).resString,
    255, '%s',
    [resString]);
  EventPoint.SetClientData(pData);
end;

{ TTaskChangedEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TTaskChangedEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TTaskChangedEvent.NewEvent(TaskID: Integer; TaskStatus: Integer;
  rc: HRESULT; resString: string);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self,
      TaskID,
      TaskStatus,
      rc,
      resString);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TTaskChangedEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TTaskChangedEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: ClientData - points to data already set thru SetData to be passed along
//                      when event fired
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TTaskChangedData(ClientData^).TaskID,
           TTaskChangedData(ClientData^).TaskStatus,
           TTaskChangedData(ClientData^).rc,
           TTaskChangedData(ClientData^).resstring);

  // Critical need to call base class;
  inherited;
end;

class procedure TTaskChangedEvent.SetData(EventPoint: TEventPoint;
  TaskID: Integer; TaskStatus: Integer; rc: HRESULT; resString: string);
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTaskChangedData));
  TTaskChangedData(pData^).TaskID := TaskID;
  TTaskChangedData(pData^).TaskStatus := TaskStatus;
  TTaskChangedData(pData^).rc := rc;
  StrLFmt(TTaskChangedData(pData^).resString,
    255, '%s',
    [resString]);
  EventPoint.SetClientData(pData);
end;


{ TModeChangeEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TModeChangeEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TModeChangeEvent.NewEvent(
  PreviousModeID: Integer;
  NewModeID: Integer;
  rc: HRESULT;
  resString: string);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self,
      PreviousModeID,
      NewModeID,
      rc,
      resString);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TModeChangeEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TModeChangeEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(
    TModeChangeEventData(ClientData^).PreviousModeID,
    TModeChangeEventData(ClientData^).NewModeID,
    TModeChangeEventData(ClientData^).rc,
    TModeChangeEventData(ClientData^).resstring);

  // Critical need to call base class;
  inherited;
end;

class procedure TModeChangeEvent.SetData(
  EventPoint: TEventPoint;
  PreviousModeID: Integer;
  NewModeID: Integer;
  rc: HRESULT;
  resString: string);
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTaskCompleteData));
  TModeChangeEventData(pData^).PreviousModeID := PreviousModeID;
  TModeChangeEventData(pData^).NewModeID := NewModeID;
  TModeChangeEventData(pData^).rc := rc;
  StrLFmt(TModeChangeEventData(pData^).resString,
    255, '%s',
    [resString]);
  EventPoint.SetClientData(pData);
end;

{ TStatusEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TStatusEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TStatusEvent.NewEvent(ReturnCode: HRESULT);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, ReturnCode);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TStatusEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TStatusEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  // Call the base class to allow the Disconnect. A time out here indicates that
  // you disconnect before you called the event.
  inherited;
  if (assigned(ClientData)) then
    NewEvent(HResult(ClientData^));

end;

class procedure TStatusEvent.SetData(EventPoint: TEventPoint;
  newValue: HRESULT);
var
  pData: pointer;
begin
  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(HRESULT));
  HRESULT(pData^) := newValue;
  EventPoint.SetClientData(pData);
end;

{  TTwoIntegerEvent }

class procedure TTwoIntegerEvent.SetData(EventPoint: TEventPoint;
  Integer1: Integer; Integer2: Integer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TTwoIntegerEvent.SetData() and never from
// Delphi objects of type TTwoIntegerEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
// Integer1, Integer2 - two integer values
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTwoIntegerData));
  TTwoIntegerData(pData^).Integer1 := Integer1;
  TTwoIntegerData(pData^).Integer2 := Integer2;
  EventPoint.SetClientData(pData);
end;


procedure TTwoIntegerEvent.NewEvent(Integer1: Integer; Integer2: Integer);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Integer1, Integer2);
  end
end;


procedure TTwoIntegerEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TTwoIntegerData(ClientData^).Integer1,
           TTwoIntegerData(ClientData^).Integer2);
end;

{  TTwoDoubleEvent }

class procedure TTwoDoubleEvent.SetData(EventPoint: TEventPoint;
  Double1: Double; Double2: Double);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TTwoDoubleEvent.SetData() and never from
// Delphi objects of type TTwoDoubleEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
// Double1, Double2 - two double values
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTwoDoubleData));
  TTwoDoubleData(pData^).Double1 := Double1;
  TTwoDoubleData(pData^).Double2 := Double2;
  EventPoint.SetClientData(pData);
end;


procedure TTwoDoubleEvent.NewEvent(Double1: Double; Double2: Double);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Double1, Double2);
  end
end;


procedure TTwoDoubleEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TTwoDoubleData(ClientData^).Double1,
           TTwoDoubleData(ClientData^).Double2);
end;

{  TThreeDoubleEvent }

class procedure TThreeDoubleEvent.SetData(EventPoint: TEventPoint;
  Double1: Double; Double2: Double; Double3: Double);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TThreeDoubleEvent.SetData() and never from
// Delphi objects of type TThreeDoubleEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
// Double1, Double2, Double3 - three double values
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TThreeDoubleData));
  TThreeDoubleData(pData^).Double1 := Double1;
  TThreeDoubleData(pData^).Double2 := Double2;
  TThreeDoubleData(pData^).Double3 := Double3;
  EventPoint.SetClientData(pData);
end;


procedure TThreeDoubleEvent.NewEvent(Double1: Double; Double2: Double; Double3: Double);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Double1, Double2, Double3);
  end
end;


procedure TThreeDoubleEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TThreeDoubleData(ClientData^).Double1,
           TThreeDoubleData(ClientData^).Double2,
           TThreeDoubleData(ClientData^).Double3
           );
end;

{  TTwoSingleEvent }

class procedure TTwoSingleEvent.SetData(EventPoint: TEventPoint;
  Single1: Single; Single2: Single);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TTwoSingleEvent.SetData() and never from
// Delphi objects of type TTwoSingleEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
// Single1, Single2 - two single values
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTwoSingleData));
  TTwoSingleData(pData^).Single1 := Single1;
  TTwoSingleData(pData^).Single2 := Single2;
  EventPoint.SetClientData(pData);
end;


procedure TTwoSingleEvent.NewEvent(Single1: Single; Single2: Single);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Single1, Single2);
  end
end;


procedure TTwoSingleEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TTwoSingleData(ClientData^).Single1,
           TTwoSingleData(ClientData^).Single2);
end;


{  TThreeSingleEvent }

class procedure TThreeSingleEvent.SetData(EventPoint: TEventPoint;
  Single1: Single; Single2: Single; Single3: Single);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TTwoSingleEvent.SetData() and never from
// Delphi objects of type TTwoSingleEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
// Single1, Single2, Single3 - single values
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TThreeSingleData));
  TThreeSingleData(pData^).Single1 := Single1;
  TThreeSingleData(pData^).Single2 := Single2;
  TThreeSingleData(pData^).Single3 := Single3;
  EventPoint.SetClientData(pData);
end;

procedure TThreeSingleEvent.NewEvent(Single1: Single; Single2: Single; Single3: Single);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Single1, Single2, Single3);
  end
end;


procedure TThreeSingleEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TThreeSingleData(ClientData^).Single1,
           TThreeSingleData(ClientData^).Single2,
           TThreeSingleData(ClientData^).Single3);
end;

{  TTwoIntegerOneSingleEvent }

class procedure TTwoIntegerOneSingleEvent.SetData(EventPoint: TEventPoint;
  Integer1: Integer; Integer2: Integer; Single1: Single);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TTwoSingleEvent.SetData() and never from
// Delphi objects of type TTwoSingleEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
// Integer1, Integer2, Single1 - data values
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTwoIntegerOneSingleData));
  TTwoIntegerOneSingleData(pData^).Integer1 := Integer1;
  TTwoIntegerOneSingleData(pData^).Integer2 := Integer2;
  TTwoIntegerOneSingleData(pData^).Single1 := Single1;
  EventPoint.SetClientData(pData);
end;

procedure TTwoIntegerOneSingleEvent.NewEvent(Integer1: Integer; Integer2: Integer; Single1: Single);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Integer1, Integer2, Single1);
  end
end;


procedure TTwoIntegerOneSingleEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TTwoIntegerOneSingleData(ClientData^).Integer1,
           TTwoIntegerOneSingleData(ClientData^).Integer2,
           TTwoIntegerOneSingleData(ClientData^).Single1);
end;


{  TSingleIntegerEvent }

class procedure TSingleIntegerEvent.SetData(EventPoint: TEventPoint;
                                            Single1: Single;
                                            Integer1: Integer);
var
  pData: pointer;
begin
  // Allocate the memory for the event point data
  pData := AllocMem(sizeof(TSingleIntegerData));
  TSingleIntegerData(pData^).Single1 := Single1;
  TSingleIntegerData(pData^).Integer1 := Integer1;
  EventPoint.SetClientData(pData);
end;

procedure TSingleIntegerEvent.NewEvent(Single1: Single; Integer1: Integer);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Single1, Integer1);
  end
end;

procedure TSingleIntegerEvent.CallEvent(ClientData: pointer);
begin
  NewEvent(TSingleIntegerData(ClientData^).Single1,
           TSingleIntegerData(ClientData^).Integer1);
end;



{  TDoubleIntegerEvent }

class procedure TDoubleIntegerEvent.SetData(EventPoint: TEventPoint;
                                            Double1: Double;
                                            Integer1: Integer);
var
  pData: pointer;
begin
  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TDoubleIntegerData));
  TDoubleIntegerData(pData^).Double1 := Double1;
  TDoubleIntegerData(pData^).Integer1 := Integer1;
  EventPoint.SetClientData(pData);
end;

procedure TDoubleIntegerEvent.NewEvent(Double1: Double; Integer1: Integer);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Double1, Integer1);
  end
end;

procedure TDoubleIntegerEvent.CallEvent(ClientData: pointer);
begin
  NewEvent(TDoubleIntegerData(ClientData^).Double1,
           TDoubleIntegerData(ClientData^).Integer1);
end;

{  TIntegerDoubleEvent }

class procedure TIntegerDoubleEvent.SetData(EventPoint: TEventPoint;
                                            Integer1: Integer;
                                            Double1: Double);
var
  pData: pointer;
begin
  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TDoubleIntegerData));  
  TDoubleIntegerData(pData^).Integer1 := Integer1;
  TDoubleIntegerData(pData^).Double1 := Double1;
  EventPoint.SetClientData(pData);
end;

procedure TIntegerDoubleEvent.NewEvent(Integer1: Integer; Double1: Double);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Integer1, Double1);
  end
end;

procedure TIntegerDoubleEvent.CallEvent(ClientData: pointer);
begin
  NewEvent(TIntegerDoubleData(ClientData^).Integer1,
           TIntegerDoubleData(ClientData^).Double1);
end;

{  TOleVarEvent }

class procedure TOleVarEvent.SetData(EventPoint: TEventPoint;
  NewValue: OleVariant);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TOleVarEvent.SetData() and never from
// Delphi objects of type TOleVarEvent.
//
//
// Inputs:
//
// EventPoint - The event point that will keep the data for us.
// NewValue - Ole Variant value
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(OleVariant));
  OleVariant(pData^) := NewValue;
  EventPoint.SetClientData(pData);
end;


procedure TOleVarEvent.NewEvent(Reading: OleVariant);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Reading);
  end
end;


procedure TOleVarEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  // Call the base class to allow the Disconnect. A time out here indocates that
  // you disconnect before you called the event.
  inherited;
  if (assigned(ClientData)) then
    NewEvent(OleVariant(ClientData^));
end;

{ TStatusIntegerEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TStatusIntegerEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TStatusIntegerEvent.NewEvent(
  StatusCode: HRESULT;
  nNoOfFrames: Integer
);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self,
      StatusCode,
      nNoOfFrames);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TStatusWithDescEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TStatusIntegerEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TStatusIntegerData(ClientData^).StatusCode,
           TStatusIntegerData(ClientData^).nNoOfFrames);

  // Critical need to call base class;
  inherited;
end;

class procedure TStatusIntegerEvent.SetData(
  EventPoint: TEventPoint;
  StatusCode: HRESULT;
  nNoOfFrames: Integer
);
var
  pData: pointer;
begin

  // Allocate the memory for the event point data
  pData := AllocMem(sizeof(TStatusIntegerData));
  TStatusIntegerData(pData^).StatusCode := StatusCode;
  TStatusIntegerData(pData^).nNoOfFrames := nNoOfFrames;
  EventPoint.SetClientData(pData);
end;

{  TTwoOleVarEvent }

class procedure TTwoOleVarEvent.SetData(EventPoint: TEventPoint;
  NewValue1: OleVariant; NewValue2: OleVariant);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TTwoOleVarEvent.SetData() and never from
// Delphi objects of type TTwoOleVarEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
// OleVar1, OleVar2 - two Ole Variant values
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTwoOleVarData));
  TTwoOleVarData(pData^).OleVar1 := NewValue1;
  TTwoOleVarData(pData^).OleVar2 := NewValue2;
  EventPoint.SetClientData(pData);
end;


procedure TTwoOleVarEvent.NewEvent(Reading1: OleVariant; Reading2: OleVariant);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Reading1, Reading2);
  end
end;


procedure TTwoOleVarEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TTwoOleVarData(ClientData^).OleVar1,
           TTwoOleVarData(ClientData^).OleVar2);
end;

{  TWordBoolEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TWordBoolEvent
//
// Description:
//
// Class provides to provide client/event services for the WordBool data type.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Class TWordBoolEvent
//
// Class Functions
//
////////////////////////////////////////////////////////////////////////////////

class procedure TWordBoolEvent.SetData(EventPoint: TEventPoint;
  newvalue: WordBool);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TWordBoolEvent.SetData() and never from
// Delphi objects of type TWordBoolEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
//
// newValue: The new value of the data to call the clients with.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(WordBool));
  WordBool(pData^) := newvalue;
  EventPoint.SetClientData(pData);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TWordBoolEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TWordBoolEvent.NewEvent(Reading: WordBool);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Reading);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TWordBoolEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TWordBoolEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Call the base class to allow the Disconnect. A time out here indocates that
  // you disconnect before you called the event.
  inherited;
  if (assigned(ClientData)) then
    NewEvent(WordBool(ClientData^));
end;


{  TDoubleWordBoolEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TDoubleWordBoolEvent
//
// Description:
//
// Class provides to provide client/event services for the Double and WordBool data types.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Class TDoubleWordBoolEvent
//
// Class Functions
//
////////////////////////////////////////////////////////////////////////////////

class procedure TDoubleWordBoolEvent.SetData(
  EventPoint: TEventPoint;
  DoubleValue: Double;
  BoolValue: WordBool
);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TDoubleWordBoolEvent.SetData() and never from
// Delphi objects of type TDoubleWordBoolEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
//
// DoubleValue, BoolValue: The new values of the data to call the clients with.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TDoubleWordBoolData));
  TDoubleWordBoolData(pData^).DoubleValue := DoubleValue;
  TDoubleWordBoolData(pData^).BoolValue := BoolValue;
  EventPoint.SetClientData(pData);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TDoubleWordBoolEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TDoubleWordBoolEvent.NewEvent(
  DoubleValue: Double;
  BoolValue: WordBool
);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, DoubleValue, BoolValue);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TDoubleWordBoolEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TDoubleWordBoolEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Call the base class to allow the Disconnect. A time out here indocates that
  // you disconnect before you called the event.
  inherited;
  if (assigned(ClientData)) then
    NewEvent(
      TDoubleWordBoolData(ClientData^).DoubleValue,
      TDoubleWordBoolData(ClientData^).BoolValue
    );
end;


{  TSingleWordBoolEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TSingleWordBoolEvent
//
// Description:
//
// Class provides to provide client/event services for the Single and WordBool data types.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Class TSingleWordBoolEvent
//
// Class Functions
//
////////////////////////////////////////////////////////////////////////////////

class procedure TSingleWordBoolEvent.SetData(
  EventPoint: TEventPoint;
  SingleValue: Single;
  BoolValue: WordBool
);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TSingleWordBoolEvent.SetData() and never from
// Delphi objects of type TSingleWordBoolEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
//
// SingleValue, BoolValue: The new values of the data to call the clients with.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TSingleWordBoolData));
  TSingleWordBoolData(pData^).SingleValue := SingleValue;
  TSingleWordBoolData(pData^).BoolValue := BoolValue;
  EventPoint.SetClientData(pData);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TSingleWordBoolEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TSingleWordBoolEvent.NewEvent(
  SingleValue: Single;
  BoolValue: WordBool
);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, SingleValue, BoolValue);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TSingleWordBoolEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TSingleWordBoolEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Call the base class to allow the Disconnect. A time out here indocates that
  // you disconnect before you called the event.
  inherited;
  if (assigned(ClientData)) then
    NewEvent(
      TSingleWordBoolData(ClientData^).SingleValue,
      TSingleWordBoolData(ClientData^).BoolValue
    );
end;

{ TIntegerWordBoolEvent }

////////////////////////////////////////////////////////////////////////////////
//
// Class TIntegerWordBoolEvent
//
// Description:
//
// Class provides to provide client/event services for the Integer and WordBool data types.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Class TIntegerWordBoolEvent
//
// Class Functions
//
////////////////////////////////////////////////////////////////////////////////

class procedure TIntegerWordBoolEvent.SetData(
  EventPoint: TEventPoint;
  IntegerValue: Integer;
  BoolValue: WordBool
);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TIntegerWordBoolData.SetData() and never from
// Delphi objects of type TIntegerWordBoolData.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
//
// IntegerValue, BoolValue: The new values of the data to call the clients with.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TIntegerWordBoolData));
  TIntegerWordBoolData(pData^).IntegerValue := IntegerValue;
  TIntegerWordBoolData(pData^).BoolValue := BoolValue;
  EventPoint.SetClientData(pData);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TIntegerWordBoolEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TIntegerWordBoolEvent.NewEvent(
  IntegerValue: Integer;
  BoolValue: WordBool
);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, IntegerValue, BoolValue);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TIntegerWordBoolEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TIntegerWordBoolEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Call the base class to allow the Disconnect. A time out here indocates that
  // you disconnect before you called the event.
  inherited;
  if (assigned(ClientData)) then
    NewEvent(
      TIntegerWordBoolData(ClientData^).IntegerValue,
      TIntegerWordBoolData(ClientData^).BoolValue
    );
end;


{TSingleEvent}

////////////////////////////////////////////////////////////////////////////////
//
// Class TSingleEvent
//
// Description:
//
// Class provides to provide client/event services for the Single data type.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Class TSingleEvent
//
// Class Functions
//
////////////////////////////////////////////////////////////////////////////////

class procedure TSingleEvent.SetData(EventPoint: TEventPoint; fNewValue: Single);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TSingleEvent.SetData() and never from
// Delphi objects of type TSingleEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
//
// fNewValue: The new value of the data to call the clients with.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(Single));
  Single(pData^) := fNewValue;
  EventPoint.SetClientData(pData);
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TSingleEvent
//
// Operations
//
////////////////////////////////////////////////////////////////////////////////

procedure TSingleEvent.NewEvent(Reading: Single);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Reading);
  end
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TSingleEvent
//
// Overrides
//
////////////////////////////////////////////////////////////////////////////////

procedure TSingleEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Call the base class to allow the Disconnect. A time out here indocates that
  // you disconnect before you called the event.
  inherited;
  if (assigned(ClientData)) then
    NewEvent(Single(ClientData^));
end;

////////////////////////////////////////////////////////////////////////////////
//
// Class TTimedOnChangedEvent
//
////////////////////////////////////////////////////////////////////////////////

class procedure TTimedOnChangedEvent.SetData(
  EventPoint: TEventPoint;
  fRemainingOnTimeInMin: Single;
  bOnDone: WordBool;
  StatusCode: HRESULT
);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TIonGunProcessControlTimedOnChangedEvent.SetData()
// and never from Delphi objects of type TIonGunProcessControlTimedOnChangedEvent.
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
//
// fRemainingOnTimeInMin - how much time in min left for timed on?
// bOnDone - are we done with timed on?
// StatusCode - did we finish successfully, aborted, or ran into isssues?
//
// Outputs: None.
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTimedOnChangedData));
  TTimedOnChangedData(pData^).fRemainingOnTimeInMin := fRemainingOnTimeInMin;
  TTimedOnChangedData(pData^).bOnDone := bOnDone;
  TTimedOnChangedData(pData^).StatusCode := StatusCode;
  EventPoint.SetClientData(pData);
end;

procedure TTimedOnChangedEvent.NewEvent(
  fRemainingOnTimeInMin: Single;
  bOnDone: WordBool;
  StatusCode: HRESULT
);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, fRemainingOnTimeInMin, bOnDone, StatusCode);
  end
end;

procedure TTimedOnChangedEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin

  // Call the base class to allow the Disconnect. A time out here indocates that
  // you disconnect before you called the event.
  inherited;
  if (assigned(ClientData)) then
    NewEvent(
      TTimedOnChangedData(ClientData^).fRemainingOnTimeInMin,
      TTimedOnChangedData(ClientData^).bOnDone,
      TTimedOnChangedData(ClientData^).StatusCode
    );
end;

////////////////////////////////////////////////////////////////////////////////
//
// Old event point types
//
////////////////////////////////////////////////////////////////////////////////

//----------------------------
procedure TTimedDoubleEvent.NewEvent (Time: TDateTime; Reading: Double );
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Time, Reading);
  end
end;

//----------------------------
procedure TTimedDoubleEvent.Connect ( Server : TEventContainer );
begin
  If Assigned(Server) then
  begin
    if Assigned(FServer) then
    begin
      FServer.UnAdvise(Self);
    end;
    FServer := Server.FindEventPoint(TEventClass(ClassType));
    If Assigned(FServer) then
    begin
      FServer.Advise(Self);
    end;
  end;
end;

//----------------------------
procedure TTimedDoubleEvent.Disconnect;
begin
  if Assigned(FServer) then
  begin
    FServer.UnAdvise(Self);
    FServer := nil;
  end;
end;

//----------------------------
//----------------------------
//----------------------------
procedure TTimedStringEvent.NewString (Time: TDateTime; Value: String);
begin
  if Assigned(FOnNewEvent) then
  begin
    FOnNewEvent(Self, Time, Value);
  end
end;

//----------------------------
procedure TTimedStringEvent.Connect ( Server : TEventContainer );
begin
  If Assigned(Server) then
  begin
    if Assigned(FServer) then
    begin
      FServer.UnAdvise(Self);
    end;
    FServer := Server.FindEventPoint(TEventClass(ClassType));
    If Assigned(FServer) then
    begin
      FServer.Advise(Self);
    end;
  end;
end;

//----------------------------
procedure TTimedStringEvent.Disconnect;
begin
  if Assigned(FServer) then
  begin
    FServer.UnAdvise(Self);
    FServer := nil;
  end;
end;

//----------------------------
{ TStringEvent }
//----------------------------

procedure TStringEvent.NewString (Value: String);
begin
  if Assigned(FOnNewEvent) then
  begin
    FOnNewEvent(Self, Value);
  end
end;

//----------------------------
procedure TStringEvent.Connect ( Server : TEventContainer );
begin
  If Assigned(Server) then
  begin
    if Assigned(FServer) then
    begin
      FServer.UnAdvise(Self);
    end;
    FServer := Server.FindEventPoint(TEventClass(ClassType));
    If Assigned(FServer) then
    begin
      FServer.Advise(Self);
    end;
  end;
end;

//----------------------------
procedure TStringEvent.Disconnect;
begin
  if Assigned(FServer) then
  begin
    FServer.UnAdvise(Self);
    FServer := nil;
  end;
end;

//----------------------------
{ TObjectListEvent }
//----------------------------

procedure TObjectListEvent.Connect(Server: TEventContainer);
begin
  If Assigned(Server) then
  begin
    if Assigned(FServer) then
    begin
      FServer.UnAdvise(Self);
    end;
    FServer := Server.FindEventPoint(TEventClass(ClassType));
    If Assigned(FServer) then
    begin
      FServer.Advise(Self);
    end;
  end;
end;

procedure TObjectListEvent.Disconnect;
begin
  if Assigned(FServer) then
  begin
    FServer.UnAdvise(Self);
    FServer := nil;
  end;
end;

procedure TObjectListEvent.NewEvent(CurrentIndex: Integer; Values: TObjectList);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, CurrentIndex, Values);
  end
end;

//----------------------------
{ TIntegerArrayEvent }
//----------------------------

procedure TIntegerArrayEvent.Connect(Server: TEventContainer);
begin
  If Assigned(Server) then
  begin
    if Assigned(FServer) then
    begin
      FServer.UnAdvise(Self);
    end;
    FServer := Server.FindEventPoint(TEventClass(ClassType));
    If Assigned(FServer) then
    begin
      FServer.Advise(Self);
    end;
  end;
end;

procedure TIntegerArrayEvent.Disconnect;
begin
  if Assigned(FServer) then
  begin
    FServer.UnAdvise(Self);
    FServer := nil;
  end;
end;

procedure TIntegerArrayEvent.NewEvent(Values: array of integer);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Values);
  end
end;

{  TTwoDoubleAndStrEvent }

class procedure TTwoDoubleAndStrEvent.SetData(EventPoint: TEventPoint;
  Double1: Double; Double2: Double; Str: String);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TTwoDoubleAndStrEvent.SetData() and never from
// Delphi objects of type TTwoDoubleAndStrEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
// Double1, Double2 - two double values
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TTwoDoubleAndStrData));
  TTwoDoubleAndStrData(pData^).Double1 := Double1;
  TTwoDoubleAndStrData(pData^).Double2 := Double2;
  StrLFmt(TTwoDoubleAndStrData(pData^).Str,
    511, '%s',
    [Str]);
  EventPoint.SetClientData(pData);
end;


procedure TTwoDoubleAndStrEvent.NewEvent(Double1: Double; Double2: Double;
  Str: String);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, Double1, Double2, Str);
  end
end;


procedure TTwoDoubleAndStrEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TTwoDoubleAndStrData(ClientData^).Double1,
           TTwoDoubleAndStrData(ClientData^).Double2,
           TTwoDoubleAndStrData(ClientData^).Str);

  // Critical need to call base class;
  inherited;
end;

{  TFourWordBoolEvent }
class procedure TFourWordBoolEvent.SetData(
  EventPoint: TEventPoint;
  WordBool1: WordBool;
  WordBool2: WordBool;
  WordBool3: WordBool;
  WordBool4: WordBool
);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TFourWordBoolEvent.SetData() and never from
// Delphi objects of type TFourWordBoolEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
// WordBool1, WordBool2, WordBool3, WordBool4 - two double values
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin

  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TFourWordBoolData));
  TFourWordBoolData(pData^).WordBool1 := WordBool1;
  TFourWordBoolData(pData^).WordBool2 := WordBool2;
  TFourWordBoolData(pData^).WordBool3 := WordBool3;
  TFourWordBoolData(pData^).WordBool4 := WordBool4;
  EventPoint.SetClientData(pData);
end;

procedure TFourWordBoolEvent.NewEvent(
  WordBool1: WordBool;
  WordBool2: WordBool;
  WordBool3: WordBool;
  WordBool4: WordBool
);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, WordBool1, WordBool2, WordBool3, WordBool4);
  end
end;

procedure TFourWordBoolEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TFourWordBoolData(ClientData^).WordBool1,
           TFourWordBoolData(ClientData^).WordBool2,
           TFourWordBoolData(ClientData^).WordBool3,
           TFourWordBoolData(ClientData^).WordBool4);
end;

{  TSevenWordBoolEvent }
class procedure TSevenWordBoolEvent.SetData(
  EventPoint: TEventPoint;
  WordBool1: WordBool;
  WordBool2: WordBool;
  WordBool3: WordBool;
  WordBool4: WordBool;
  WordBool5: WordBool;
  WordBool6: WordBool;
  WordBool7: WordBool
);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this class function to set the data for the events. Always
// call it as a class function i.e. TSevenWordBoolEvent.SetData() and never from
// Delphi objects of type TSevenWordBoolEvent.
//
//
// Inputs:
//
// EventPoint: The event point that will keep the data for us.
// WordBool1, WordBool2, WordBool3, WordBool4, WordBool5, WordBool6, WordBool7 - boolean values
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
var
  pData: pointer;
begin
  // Allocate the memory for the event point data.
  pData := AllocMem(sizeof(TSevenWordBoolData));
  TSevenWordBoolData(pData^).WordBool1 := WordBool1;
  TSevenWordBoolData(pData^).WordBool2 := WordBool2;
  TSevenWordBoolData(pData^).WordBool3 := WordBool3;
  TSevenWordBoolData(pData^).WordBool4 := WordBool4;
  TSevenWordBoolData(pData^).WordBool5 := WordBool5;
  TSevenWordBoolData(pData^).WordBool6 := WordBool6;
  TSevenWordBoolData(pData^).WordBool7 := WordBool7;
  EventPoint.SetClientData(pData);
end;

procedure TSevenWordBoolEvent.NewEvent(
  WordBool1: WordBool;
  WordBool2: WordBool;
  WordBool3: WordBool;
  WordBool4: WordBool;
  WordBool5: WordBool;
  WordBool6: WordBool;
  WordBool7: WordBool
);
begin
  if Assigned(FOnEvent) then
  begin
    FOnEvent(Self, WordBool1, WordBool2, WordBool3, WordBool4,
      WordBool5, WordBool6, WordBool7);
  end
end;

procedure TSevenWordBoolEvent.CallEvent(ClientData: pointer);
////////////////////////////////////////////////////////////////////////////////
//
// Description:  Use this virtual function to actually call the event. The data
// to use for the parameters has previously been set by the call to TEventClient
// Set data called as a class function.
//
//
// Inputs: None.
//
//
// Outputs: None.
//
//
////////////////////////////////////////////////////////////////////////////////
begin
  NewEvent(TSevenWordBoolData(ClientData^).WordBool1,
           TSevenWordBoolData(ClientData^).WordBool2,
           TSevenWordBoolData(ClientData^).WordBool3,
           TSevenWordBoolData(ClientData^).WordBool4,
           TSevenWordBoolData(ClientData^).WordBool5,
           TSevenWordBoolData(ClientData^).WordBool6,
           TSevenWordBoolData(ClientData^).WordBool7);
end;

end.
