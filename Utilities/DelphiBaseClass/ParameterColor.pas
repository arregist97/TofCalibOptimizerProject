unit ParameterColor;
////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterColor.pas
// Created:   July, 2011 by Daniel Klooster
// Purpose:   ParameterColor class introduces baseclass behavior associated to
//            selectable colors.
//*********************************************************
// Copyright © 1998-2011 Physical Electronics-USA(a division of ULVAC-PHI).
// Created in 2011 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////
interface

uses
  Classes,
  Graphics,
  ExtCtrls,
  StdCtrls,
  Parameter;

const
  c_ColorValueActive = clYellow;
  c_ColorValueInactive = clInactiveCaptionText;

type
  TParameterColor = class(TParameter)
  private
  protected
    m_ColorValue: TColor;

    procedure SetColorValue(Value: TColor); virtual;
    function GetValueAsString(): String; override;
    procedure SetValueAsString(StringValue: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Initialize(Sender: TParameter); override ;

    procedure ToColorBox(ColorBoxPtr: TColorBox) ;

    property ColorValue: TColor read m_ColorValue write SetColorValue;
  end ;

implementation

uses
  SysUtils,
  FileCtrl ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterColor.Create(AOwner: TComponent) ;
begin
  inherited Create(AOwner) ;

  m_ColorValue := c_ColorValueActive;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Copy the memeber variables from the passed object
// Inputs:       TParameter
// Outputs:
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterColor.Initialize(Sender: TParameter) ;
begin
  inherited ;

  if (Sender is TParameterColor) then
  begin
    m_ColorValue := (Sender as TParameterColor).m_ColorValue;
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the shape color
// Inputs:       Enabled state
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterColor.SetColorValue(Value: TColor);
begin
  m_ColorValue := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TColorBox component
// Inputs:       TColorBox
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterColor.ToColorBox(ColorBoxPtr: TColorBox) ;
begin
  if m_ReadOnly then
  begin
    ColorBoxPtr.Color := c_ColorBackgroundReadOnly ;
    ColorBoxPtr.Font.Color := c_ColorForegroundReadOnly ;
  end
  else
  begin
    ColorBoxPtr.Color := GetBackgroundColor(BackgroundColor) ;
    ColorBoxPtr.Font.Color := GetForegroundColor(ForegroundColor) ;
  end;

  if (Hint <> c_DefaultHint) then
  begin
    ColorBoxPtr.ShowHint := True;
    ColorBoxPtr.Hint := Hint;
  end;

  ColorBoxPtr.Visible := Visible;
  ColorBoxPtr.Enabled := Enabled;

  ColorBoxPtr.Selected := m_ColorValue;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Return current value.
// Inputs:       None
// Outputs:      Value as String
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterColor.GetValueAsString(): String ;
begin
  Result := IntToStr(Integer(m_ColorValue)) ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set current data value as a string.
// Inputs:       String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterColor.SetValueAsString(StringValue: String) ;
begin
  try
    m_ColorValue := TColor(StrToInt(StringValue));
  except
    m_ColorValue := clInactiveCaptionText;
  end;
end ;

end.

