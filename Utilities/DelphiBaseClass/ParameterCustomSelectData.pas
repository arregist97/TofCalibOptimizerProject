unit ParameterCustomSelectData;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterCustomSelectData.pas
// Created:   4.10.2007 by John Baker
// Purpose:   ParameterCustomSelectData class is used in to determine the behavior
//             of a list component (Sort, Duplicate, DropDownSize, ...).  This
//             class should not be used by the application developer, instead use
//             TParameterSelectData.
//*********************************************************
// Copyright © 1999-2007 Physical Electronics, Inc.
// Created in 2007 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////
interface

uses
  Classes,
  Parameter ;

type
  TParameterCustomSelectData = class(TParameter)
  private
    m_DropDownCount: Integer;

  protected

  public
    constructor Create(AOwner: TComponent); overload ; override ;
    destructor Destroy(); override ;

    property DropDownCount: Integer read m_DropDownCount write m_DropDownCount;
  end ;

implementation

uses
  AppDefinitions;

const
  c_DefaultDropDownCount = 30;

////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
////////////////////////////////////////////////////////////////////////////////
constructor TParameterCustomSelectData.Create(AOwner: TComponent) ;
begin
  inherited Create(AOwner) ;

  m_DropDownCount := c_DefaultDropDownCount;
end ;

////////////////////////////////////////////////////////////////////////////////
// Description:  Base class destructor.
// Inputs:       None
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
destructor TParameterCustomSelectData.Destroy() ;
begin
   inherited Destroy ;
end ;

end.

