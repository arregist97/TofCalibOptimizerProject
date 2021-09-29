unit PhiFileOpen;
////////////////////////////////////////////////////////////////////////////////
// Filename:  PhiFileOpen.pas
// Created:   on 1/3/1 by Dan Hennen
// Purpose:   This module contains common routines that are used to open
//            MultiPak files.
//*********************************************************
// Copyright © 2001 Physical Electronics, Inc.
// Created in 2001 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
////////////////////////////////////////////////////////////////////////////////

interface

uses
  pjAcquisition_TLB,
  PHIDataSet_TLB,
  AppSettings_TLB,
  pjGeneralInterfaces_TLB;

  procedure CreateAcqObject(var Acquisition: IAcquisition;
                            var Collection: ICollection;
                            var SpectralDataSet: ISpectralDataSet;
                            var ProfileDataSet: IProfileDataSet;
                            var ImageDataSet: IImageDataSet;
                            var AppSettings: IAppSettings);

implementation
 
uses
  System.UITypes,
  Dialogs;

////////////////////////////////////////////////////////////////////////////////
// Description: Create an empty Acquisition object.
// Inputs:      None
// Outputs:     Acquisition - The IAcquisition interface.
//              Collection - The ICollection interface.
//              SpectralDataSet - The ISpectralDataSet interface.
//              ProfileDataSet - The IProfileDataSet interface.
//              ImageDataSet - The IImageDataSet interface.
//              AppSettings - The IAppSettings interface.
// Note:
////////////////////////////////////////////////////////////////////////////////
procedure CreateAcqObject(var Acquisition: IAcquisition;
                          var Collection: ICollection;
                          var SpectralDataSet: ISpectralDataSet;
                          var ProfileDataSet: IProfileDataSet;
                          var ImageDataSet: IImageDataSet;
                          var AppSettings: IAppSettings);
var
  ErrorString: String;
  bErrorFound: Boolean;
begin
  // Initialize the error flag.
  bErrorFound := false;

  try
    // Create an Acquisition object.
    try
      Acquisition := CoAcquisition.Create;
    except
      bErrorFound := true;
      raise;
    end;

    // Get the Collection interface from the Acquisition object.
    try
      Collection := Acquisition.GetCollection();
    except
      bErrorFound := true;
      raise;
    end;

    // Create Data Set and App Settings objects.
    try
      SpectralDataSet := CoSpectralDataSet.Create;
      ProfileDataSet := CoProfileDataSet.Create;
      ImageDataSet := CoImageDataSet.Create;
      AppSettings := CoAppSettings_.Create;
    except
      bErrorFound := true;
      raise;
    end;

    // Add the Data Set and App Settings objects to the Collection object.
    try
      Collection.AddItem(SpectralDataSet as IOwner);
      Collection.AddItem(ProfileDataSet as IOwner);
      Collection.AddItem(ImageDataSet as IOwner);
      Collection.AddItem(AppSettings as IOwner);
    except
      bErrorFound := true;
      raise;
    end;

  finally
    // Check for errors.
    if (bErrorFound) then
    begin

      // Pop-up a message dialog.
      ErrorString := 'Error creating Acquisition object.';
      MessageDlg(ErrorString, mtError, [mbOK], 0);

      // Set all the interface pointers to nil to indicate an error.
      Acquisition := nil;
      Collection := nil;
      SpectralDataSet := nil;
      ProfileDataSet := nil;
      ImageDataSet := nil;
      AppSettings := nil;
    end;
  end;
end;

end.
