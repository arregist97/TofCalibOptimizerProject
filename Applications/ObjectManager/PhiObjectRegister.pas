unit PhiObjectRegister;

interface
uses
  SysUtils,Classes,
  ObjectManagerObjectInterface;

type

  TObjectType = class of TObject;
  TObjectManagerObjectInterfaceType = class of TObjectManagerObjectInterface;

  //////////////////////////////////////////////////////////////////////////////
  // Class TPhiObjectRegister
  //
  // This class provides the support for objects to register to be created at
  // system startup.  This function is separated from the Object manager so all
  // components don't have to bring in the object manager and 
  // it's required modules.
  //////////////////////////////////////////////////////////////////////////////
  TPhiObjectRegister = class(TObject)
  public
    class procedure Register(AClass: TObjectType;
                             Name: string;
                             ObjectInterfaceType: TClass);
    class procedure CleanUp;
    class function GetRegisteredObjectList: TStringList;
    class function GetObject(ObjectName:String): TObject;
  end;

implementation

var
  CVRegisteredObjects: TStringList;   // Class variable to hold registered classes.


////////////////////////////////////////////////////////////////////////////////
class procedure TPhiObjectRegister.Register(AClass: TObjectType;
                                            Name: string;
                                            ObjectInterfaceType: TClass);
// This class method is called by each class that wants the object manager
// to create an instance of it. The call to Register is done from the 
// Initialize section of a module, so it is done before any other code
// starts to execute.
// Inputs:
//    AClass  - Class of object to instantiate when CreateObjects 
//              method is called.
//    Name    - Unique Name given to the object.
//    ObjectInterfaceType - This is a class reference to the object interface
//                          class to create. See notes in 
//                          ObjectMangerObjectInterface class for a description
//                          of this class.
// Outputs:
//    CVRegisteredObjects - Class variable used to hold an ObjectInterfaceType
//                          for each class to be instantiated. Note: Delphi does
//                          not support the concept of class variables but it is
//                          typically done using a variable that is local to the
//                          unit that the class is defined in.
// Notes: The objects referenced by AClass are not created here; they are created
//        when CreateObjects is called at runtime by an object outside this class.
//        The class referenced by ObjectInterfaceType is instantiated here, 
//        and added to the CVRegisteredObjects list.  This object will hold the 
//        reference to AClass to be used when CreateObjects is called.
//
//        The local variable derivedClass holds the class reference to the 
//        ObjectInterfaceType to be created.  It is cast to the base class
//        TObjectManagerObjectInterfaceType to make the compiler happy, but the
//        line "derivedClass.Create(Name,AClass)" creates an instance of the
//        class referenced by ObjectInterfaceType which is a child class of
//        TObjectManagerObjectInterface.
var
  derivedClass: TObjectManagerObjectInterfaceType;
  objInterface: TObjectManagerObjectInterface;
begin
  derivedClass := TObjectManagerObjectInterfaceType(ObjectInterfaceType);
  objInterface :=  derivedClass.Create(Name,AClass);  
  if not assigned(CVRegisteredObjects) then 
  begin
    CVRegisteredObjects := TStringList.Create;
    CVRegisteredObjects.Capacity := 50;
  end;
  CVRegisteredObjects.AddObject(Name,objInterface);  
end;
////////////////////////////////////////////////////////////////////////////////
class function TPhiObjectRegister.GetRegisteredObjectList: TStringList;
// Accessor for the "class variable" CVRegisteredObjects.
begin
  result := CVRegisteredObjects;
end;
////////////////////////////////////////////////////////////////////////////////
class function TPhiObjectRegister.GetObject(ObjectName:String): TObject;
// Get the instance of the object referenced by ObjectName.
// CVRegisteredObjects holds a list of TObjectManagerObjectInterface child types.
// See description in TObjectManagerObjectInterface for details.
var
  index: integer;
begin
  index := CVRegisteredObjects.IndexOf(ObjectName); // returns -1 if not found.
  if index > -1 then
    result := (CVRegisteredObjects.Objects[index] 
               as TObjectManagerObjectInterface).Instance
  else
    result := nil;
end;

class procedure TPhiObjectRegister.CleanUp;
////////////////////////////////////////////////////////////////////////////////
//  Description: Clean up and free up objects.
//  Inputs:      None
//  Outputs:     None
//  Note:
////////////////////////////////////////////////////////////////////////////////
begin
  if (assigned(CVRegisteredObjects)) then
  begin
    CVRegisteredObjects.Free;
    CVRegisteredObjects := nil;
  end;
end;

end.
