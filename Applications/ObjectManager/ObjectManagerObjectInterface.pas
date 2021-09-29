unit ObjectManagerObjectInterface;

interface

uses
  ObjectPhi;
  
type

  //////////////////////////////////////////////////////////////////////////////
  //
  // Class TObjectManagerObjectInterface
  //
  // This is an abstract class which defines the interface needed for any
  // subclasses.
  // This class provides the mechanism for the object manager to instantiate
  // singleton objects in the system, without knowledge at compile time of what
  // those objects will be.  The object manager will hold a list of of 
  // subclass instances of this class.  There will be a subclass of this class
  // for each base class type that needs to be instantiated by the object 
  // manager.  For example, the TObjectManagerPhiObjectInterface is used by any 
  // classes that are subclasses of TPhiObject and want to be instantiated by 
  // the object manager when the system starts up.
  // There are several of these subclasses available but in the event that there
  // is not a subclass for the type of object that needs to be created, then
  // provide the interface defined here and look at the example of the other
  // subclasses.  
  TObjectManagerObjectInterface = class(TObject)
  public
    FName: string;          // Name provided by the class registering with the 
                            // object manager.
    FObjectClass: TClass;   // Class type to be instantiated at runtime.
    FInstance: TObject;     // Hold the instance of FObjectClass.
    FInitialized: Boolean;  // Indicated that Initialize has been called on 
                            // FInstance.
    constructor create(AName: string; AClass: TClass);
    procedure CreateObject; virtual; abstract; // Create an instance 
                                               // of FObjectClass.                           
    procedure InitializeObject(); virtual; abstract;   // Initialize FInstance.                           
    procedure DeinitializeObject(); virtual; abstract; // DeInitialize FInstance.                          
    procedure DestroyObject(); virtual; abstract;      // Destroy FInstance.
    function GetPhiObject: TPhiObject; virtual; abstract; // Get the TPhiObject 
                                                          // of FInstance.                          
    property Name: string read FName write FName;
    property ObjectClass: TClass read FObjectClass write FObjectClass;
    property Instance: TObject read FInstance write FInstance;
    property Initialized: Boolean read FInitialized write FInitialized;
  end;

implementation

constructor TObjectManagerObjectInterface.create(AName: string; AClass: TClass);
begin
  Inherited create;
  Name := AName;
  ObjectClass := AClass;
  Initialized := False;
end;

end.
