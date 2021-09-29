unit ObjectManagerPhiObjectInterface;

interface

uses
  ObjectPhi,
  ObjectManagerObjectInterface;
  
type
  TPhiObjectType = class of TPhiObject;

  //////////////////////////////////////////////////////////////////////////////
  //
  // Class TObjectManagerPhiObjectInterface
  //
  // This class provides the mechanism for creating instances of TPhiObject
  // (or subclasses of TPhiObject) by the object manager at system start up.
  // See the comments in parent class TObjectManagerObjectInterface for details.
  TObjectManagerPhiObjectInterface = class(TObjectManagerObjectInterface)
  public
    procedure CreateObject; override;
    procedure InitializeObject(); override;
    procedure DeinitializeObject(); override;
    procedure DestroyObject(); override;
    function GetPhiObject: TPhiObject; override;
  end;

implementation

uses
  sysutils;

///////////////////////////////////////////////////////////////////////////////  
procedure TObjectManagerPhiObjectInterface.CreateObject;
// Create instance of class referenced by the FObjectClass member variable.
// Note that even though the derivedClass variable is cast to TPhiObject,
// the instance created is whatever class is specified by ObjectClass (which
// will be TPhiObject or a subclass of it).
var
  derivedClass: TPhiObjectType;
begin
  derivedClass := TPhiObjectType(ObjectClass);
  Instance := derivedClass.Create('');
end;

///////////////////////////////////////////////////////////////////////////////
procedure TObjectManagerPhiObjectInterface.InitializeObject();
// Call Initialize on the object referenced by the FInstance memeber
// variable.
var
  obj: TPhiObject;
begin
  obj := Instance as TPhiObject;
  obj.Initialize();
end;

///////////////////////////////////////////////////////////////////////////////
procedure TObjectManagerPhiObjectInterface.DeinitializeObject();
// Call DeInitialize on the object referenced by the FInstance memeber
// variable.
var
  obj: TPhiObject;
begin
  obj := Instance as TPhiObject;
  obj.DeInitialize();
end;

///////////////////////////////////////////////////////////////////////////////
procedure TObjectManagerPhiObjectInterface.DestroyObject();
// Destroy the object instance referenced by the FInstance memeber
// variable.
begin
  if FInstance <> nil then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
function TObjectManagerPhiObjectInterface.GetPhiObject: TPhiObject;
// Get the TPhiObject instance from the object referenced by the 
// FInstance memeber variable.
begin
  result := TPhiObject(Instance);
end;

end.
