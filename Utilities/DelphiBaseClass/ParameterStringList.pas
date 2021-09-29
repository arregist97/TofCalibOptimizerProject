unit ParameterStringList;
////////////////////////////////////////////////////////////////////////////////////////////////////////
// Filename:  ParameterStringList.pas
// Created:   on 00-10-19 by John Baker
// Purpose:   TParameterStringList class.  Used to hold a list of type TParameterStringList.
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
  StdCtrls,
  ComCtrls,
  EditList,
  ComboBoxList,
  ControlList,
  Parameter,
  ParameterList,
  ParameterString;

{TParameterStringList}
type
  TParameterStringList = class(TParameterList)
  private
    m_Initial: TParameterString;
    function GetParameter(Index: Integer): TParameterString;
    function GetValue: String;
    procedure SetValue(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Add(); overload; override;
    procedure Add(Value: String); overload; override;
    procedure Add(InitialValues: TParameterString); overload;
    procedure Add(InitialValues: TParameter); overload; override;
    procedure Insert(Index: Integer); overload; override;
    procedure Insert(Index: Integer; Value: String); overload;
    procedure Insert(Index: Integer; InitialValues: TParameterString); overload;
    procedure Insert(Index: Integer; InitialValues: TParameter); overload; override;

    property Initial: TParameterString read m_Initial;
    property Parameter[Index: Integer]: TParameterString read GetParameter;
    property Value: String read GetValue write SetValue;

    function IndexOf(Value: String): Integer;

    procedure ToComponent(ControlList: TControlList); override;
    procedure ToComboBox(ComboBox: TComboBox);
    procedure ToComboBoxList(ComboBoxList: TComboBoxList);
    procedure ToEditList(EditList: TEditList; ValueAs: TVaType = vaValueAsDefault);
    procedure ToIndicator(EditList: TEditList);
    procedure ToMemo(MemoPtr: TMemo);
    procedure ToTreeView(TreeViewPtr: TTreeView);
  end;

implementation

uses
  System.Contnrs,
  System.Math,
  Graphics;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Base class constructor.
// Inputs:       TComponent. Used for auto-destruction
// Outputs:      None.
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
constructor TParameterStringList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  m_Initial := TParameterString.Create(AOwner);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add Parameter to the list of Parameters associated to this control.
// Inputs:       None
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.Add();
begin
  Add(m_Initial);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add Parameter to the list of Parameters associated to this control.
// Inputs:       Value as String
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.Add(Value: String);
begin
  Add(m_Initial);

  // Set the value
  Parameter[ParameterIndex.ValueAsInt].ValueAsString := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add Parameter to the list of Parameters associated to this control.
// Inputs:       Initial Values as TParameterData
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.Add(InitialValues: TParameterString);
var
  ParameterPtr: TParameterString;
begin
  // Check that the passed values are valid
  if (InitialValues = nil) then
    InitialValues := m_Initial;

  // Create a new TParameterSelectData object and set default values
  ParameterPtr := TParameterString.Create(nil);
  ParameterPtr.Initialize(TParameter(InitialValues));

  // Add to list
  ParameterIndex.ValueAsInt := ParameterList.Add(ParameterPtr);

  // Update the number of list members
  ParameterCount.Value := ParameterList.Count;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Add Parameter to the list of Parameters associated to this control.
// Inputs:       Initial Values as TParameter
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.Add(InitialValues: TParameter);
begin
  if (InitialValues is TParameterString) then
    Add(TParameterString(InitialValues))
  else
    Add(m_Initial);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Insert Parameter to the list of Parameters associated to this control.
// Inputs:       Index as Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.Insert(Index: Integer);
begin
  Insert(Index, m_Initial);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Insert Parameter to the list of Parameters associated to this control.
// Inputs:       Index as Integer
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.Insert(Index: Integer; Value: String);
begin
  Insert(Index, m_Initial);

  // Set the value
  Parameter[Index].Value := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Insert Parameter to the list of Parameters associated to this control.
// Inputs:       Index as Integer; Initial Values as TParameterData
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.Insert(Index: Integer; InitialValues: TParameterString);
var
  ParameterPtr: TParameterString;
begin
  // Check that the passed values are valid
  if (InitialValues = nil) then
    InitialValues := m_Initial;

  // Create a new TParameterSelectData object and set default values
  ParameterPtr := TParameterString.Create(nil);
  ParameterPtr.Initialize(TParameter(InitialValues));

  // Check for valid (minimum) index
  if (Index < 0) then
    Index := 0;

  // Insert into list, if at the end simply add
  if (Index >= ParameterList.Count) then
    Index := ParameterList.Add(ParameterPtr)
  else
    ParameterList.Insert(Index, ParameterPtr);

  // Set the index
  ParameterIndex.ValueAsInt := Index;

  // Update the number of list members
  ParameterCount.Value := ParameterList.Count;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Insert Parameter to the list of Parameters associated to this control.
// Inputs:       Index as Integer; Initial Values as TParameter
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.Insert(Index: Integer; InitialValues: TParameter);
begin
  if (InitialValues is TParameterString) then
    Insert(Index, TParameterString(InitialValues))
  else
    Insert(Index, m_Initial);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get a TParameter object from the list.
// Inputs:       Index
// Outputs:      TParameterString
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterStringList.GetParameter(Index: Integer): TParameterString;
begin
  if ((Index >= 0) and (Index < ParameterList.Count)) then
    Result := (ParameterList.Items[Index] as TParameterString)
  else
    Result := m_Initial;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the value from the current TParameter list object.
// Inputs:       Index
// Outputs:      TParameterString
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterStringList.GetValue: String;
begin
  if (ParameterList.Count > 0) and
    ((ParameterIndex.ValueAsInt >= 0) and
    (ParameterIndex.ValueAsInt < ParameterList.Count)) then
    Result := (ParameterList.Items[ParameterIndex.ValueAsInt] as TParameterString).Value
  else
    Result := m_Initial.Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Set the value to the current TParameter list object.
// Inputs:       Index
// Outputs:      TParameterString
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.SetValue(const Value: String);
begin
  if (ParameterList.Count > 0) and
    ((ParameterIndex.ValueAsInt >= 0) and
    (ParameterIndex.ValueAsInt < ParameterList.Count)) then
    (ParameterList.Items[ParameterIndex.ValueAsInt] as TParameterString).Value := Value;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Get the TParameter object Index.
// Inputs:       TParameter
// Outputs:      Index; -1 is returned if object is not in list
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
function TParameterStringList.IndexOf(Value: String): Integer;
var
  Index: Integer;
begin
  Result := c_InvalidIndex;

  // Fill Values into ComboBox
  for Index := 0 to ParameterCount.ValueAsInt - 1 do
    if Parameter[Index].Value = Value then
      Result := Index;
end;

////////////////////////////////////////////////////////////////////////////////
// Description:  Update parameter information to a 'TComboBox' component.
// Inputs:       TComboBox
// Outputs:      None
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.ToComboBox(ComboBox: TComboBox);
var
  Index: Integer;
begin
  if m_ReadOnly then
  begin
    ComboBox.Color := c_ColorBackgroundReadOnly;
    ComboBox.Font.Color := c_ColorForegroundReadOnly;
    ComboBox.Style := csDropDownList;
   end
  else
  begin
    ComboBox.Color := GetBackgroundColor(BackgroundColor);
    ComboBox.Font.Color := GetForegroundColor(ForegroundColor);
    ComboBox.Style := csDropDownList;

    ComboBox.AutoComplete := True;
  end;

  if (Hint <> c_DefaultHint) then
  begin
    if (HintAs = hintAsString) then
    begin
      ComboBox.ShowHint := True;
      ComboBox.Hint := Value;
    end
    else
    begin
      ComboBox.ShowHint := True;
      ComboBox.Hint := Hint;
    end;
  end;

  ComboBox.Visible := Visible;
  ComboBox.Enabled := Enabled;
  ComboBox.Items.Clear();

  if m_ReadOnly then
  begin
    // Set current item in ComboBox list... make sure it's valid
    ComboBox.Items.Add(Parameter[ParameterIndex.ValueAsInt].Value);
  end
  else
  begin
    // Fill Values into ComboBox
    for Index := 0 to ParameterCount.ValueAsInt - 1 do
      ComboBox.Items.Add(Parameter[Index].Value);
  end;

  // Set current item in ComboBox list... make sure it's valid
  if ((ParameterIndex.ValueAsInt >= 0) and (ParameterIndex.ValueAsInt < ComboBox.Items.Count)) then
    ComboBox.ItemIndex := ParameterIndex.ValueAsInt
  else
    ComboBox.ItemIndex := 0;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TComboBoxList parameters.
// Inputs:       TComboBoxList
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.ToComboBoxList(ComboBoxList: TComboBoxList);
var
  Index: Integer;
  ParameterPtr: TParameterString;
  ComboBoxPtr: TComboBox;
begin
  // If the hint is unset(i.e. c_DefaultHint) the hint values from the design time control are used
  if (Hint <> c_DefaultHint) then
  begin
    ComboBoxList.ShowHint := True;
    ComboBoxList.Hint := Hint;
  end;
  ComboBoxList.Visible := Visible;

  // Disable the user callbacks before modifying. This will cause problems if not done
  ComboBoxList.EnableEvents := False;

  // Set Indicator, must happen before setting color
  ComboBoxList.IndicatorIndex := ParameterIndex.ValueAsInt;

  // Set secondary indicator (only if being used)
  if UseSecondaryIndex then
    ComboBoxList.SecondaryIndicator := True
  else
    ComboBoxList.SecondaryIndicator := False;
  ComboBoxList.SecondaryIndicatorIndex := SecondaryIndex.ValueAsInt;

  // Clear the ComboBoxList and set the size
  ComboBoxList.ReInitialize(ParameterList.Count);

  // Fill values into each TEdit control contained in the list
  for Index := 0 to ComboBoxList.CustomScrollBoxSize - 1 do
  begin
    ParameterPtr := (ParameterList.Items[Index + ComboBoxList.CustomScrollBoxStartIndex] as TParameterString);
    ComboBoxPtr := ComboBoxList.Control[Index];
    ParameterPtr.ToComboBox(ComboBoxPtr);

    // A TParameterList 'Enabled' state of 'False' overrides the individual control state
    if not (Enabled) then
      ComboBoxPtr.Enabled := False;

    ComboBoxList.ControlRecolor(Index);
  end;

  // reposition controls (top and spacing) if visibility has changed
  ComboBoxList.RepositionWithVisibility;

  // Enable the user callbacks
  ComboBoxList.EnableEvents := True;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in Edit parameters.
// Inputs:       TControlList
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.ToComponent(ControlList: TControlList);
begin
  if (ControlList is TEditList) then
  begin
    ToEditList(TEditList(ControlList));
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TEditList component
// Inputs:       TEditList
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.ToEditList(EditList: TEditList; ValueAs: TVaType);
var
  Index: Integer;
  ParameterPtr: TParameterString;
  EditPtr: TEdit;
begin
  // If the hint is unset(i.e. c_DefaultHint) the hint values from the design time control are used
  if (Hint <> c_DefaultHint) then
  begin
    EditList.ShowHint := True;
    EditList.Hint := Hint;
  end;
  EditList.Visible := Visible;

  // Disable the user callbacks before modifying. This will cause problems if not done
  EditList.EnableEvents := False;

  // Set Indicator, must happen before setting color
  EditList.IndicatorIndex := ParameterIndex.ValueAsInt;

  // Set secondary indicator (only if being used)
  if UseSecondaryIndex then
    EditList.SecondaryIndicator := True
  else
    EditList.SecondaryIndicator := False;
  EditList.SecondaryIndicatorIndex := SecondaryIndex.ValueAsInt;

  // Clear the EditList and set the size
  EditList.ReInitialize(ParameterList.Count);

  // Fill values into each TEdit control contained in the list
  for Index := 0 to EditList.CustomScrollBoxSize - 1 do
  begin
    ParameterPtr := (ParameterList.Items[Index + EditList.CustomScrollBoxStartIndex] as TParameterString);
    EditPtr := EditList.Control[Index];
    ParameterPtr.ToEditBox(EditPtr, ValueAs);

    // A TParameterList 'Enabled' state of 'False' overrides the individual control state
    if not (Enabled) then
      editPtr.Enabled := False;

    EditList.ControlRecolor(Index);
  end;

  // reposition controls (top and spacing) if visibility has changed
  EditList.RepositionWithVisibility;

  // Enable the user callbacks
  EditList.EnableEvents := True;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in ScrollBar parameters.
// Inputs:       TScrollBar
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.ToIndicator(EditList: TEditList);
var
  Index: Integer;
  EditPtr: TEdit;
begin
  // Set Indicator, must happen before setting color
  EditList.IndicatorIndex := ParameterIndex.ValueAsInt;

  // Set secondary indicator (only if being used)
  if UseSecondaryIndex then
    EditList.SecondaryIndicator := True
  else
    EditList.SecondaryIndicator := False;
  EditList.SecondaryIndicatorIndex := SecondaryIndex.ValueAsInt;

  // Fill values into each TEdit control contained in the list
  for Index := 0 to ParameterList.Count - 1 do
  begin
    EditPtr := EditList.Control[Index];
    EditPtr.Color := BackgroundColor;
    EditPtr.Font.Color := ForegroundColor;

    EditList.ControlRecolor(Index);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TMemo component
// Inputs:       TMemo
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.ToMemo(MemoPtr: TMemo);
var
  index: Integer;
begin
  MemoPtr.Color := BackgroundColor;
  MemoPtr.Font.Color := ForegroundColor;
  if (Hint <> c_DefaultHint) then
  begin
    MemoPtr.ShowHint := True;
    MemoPtr.Hint := Hint;
  end;
  MemoPtr.Visible := Visible;
  MemoPtr.Enabled := Enabled;
  MemoPtr.ReadOnly := m_ReadOnly;
  if m_ReadOnly then
    MemoPtr.Color := c_ColorBackgroundReadOnly;

  // Fill string values into TMemo
  MemoPtr.Lines.Clear();
  for index := 0 to ParameterList.Count - 1 do
  begin
    MemoPtr.Lines.Add((ParameterList.Items[index] as TParameterString).Value);
  end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Description:  Fill in TMemo component
// Inputs:       TMemo
// Outputs:      None
// Note:
///////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TParameterStringList.ToTreeView(TreeViewPtr: TTreeView);
var
  index: Integer;
  jobNodePtr: TTreeNode;
  positionListBranch: TTreeNode;
  acqsetupListBranch: TTreeNode;
  acqpropListBranch: TTreeNode;
begin
//  TreeViewPtr.Color := BackgroundColor;
//  TreeViewPtr.Font.Color := ForegroundColor;
  if (Hint <> c_DefaultHint) then
  begin
    TreeViewPtr.ShowHint := True;
    TreeViewPtr.Hint := Hint;
  end;
//  TreeViewPtr.Visible := Visible;
//  TreeViewPtr.Enabled := Enabled;
//  TreeViewPtr.ReadOnly := m_ReadOnly;
//  if m_ReadOnly then
//    TreeViewPtr.Color := c_ColorBackgroundReadOnly;

  TreeViewPtr.Items.Clear;
  for index := 0 to ParameterList.Count - 1 do
  begin
    jobNodePtr := TreeViewPtr.Items.Add(nil, (ParameterList.Items[index] as TParameterString).Value);

    positionListBranch := TreeViewPtr.Items.AddChild(jobNodePtr, 'Position List');
    positionListBranch.ImageIndex := 1;

    acqpropListBranch := TreeViewPtr.Items.AddChild(positionListBranch, 'Acq Properties');
    acqpropListBranch.ImageIndex := 3;

    acqsetupListBranch := TreeViewPtr.Items.AddChild(positionListBranch, 'Spectrum');
    acqsetupListBranch.ImageIndex := 2;
  end;

//    TreeViewPtr.Items.Clear; { Remove any existing nodes. }
//    MyTreeNode1 := Add(nil, 'RootTreeNode1'); { Add a root node. }
//    { Add a child node to the node just added. }
//    TreeViewPtr.Items.AddChild(MyTreeNode1,'ChildNode1');
//
//    {Add another root node}
//    MyTreeNode2 := Add(MyTreeNode1, 'RootTreeNode2');
//    {Give MyTreeNode2 to a child. }
//    TreeViewPtr.Items.AddChild(MyTreeNode2,'ChildNode2');
//
//    {Change MyTreeNode2 to ChildNode2 }
//    { Add a child node to it. }
//    MyTreeNode2 := TreeViewPtr.Items[3];
//    TreeViewPtr.Items.AddChild(MyTreeNode2,'ChildNode2a');
//
//    { Add another child to ChildNode2, after ChildNode2a. }
//    TreeViewPtr.Items.AddChild(MyTreeNode2,'ChildNode2b');
//
//    { Add another root node. }
//    TreeViewPtr.Items.Add(MyTreeNode1, 'RootTreeNode3');
end;

end.

