unit StandardErrorCodes;

////////////////////////////////////////////////////////////////////////////////
//
// Filename:  StandardErrorCodes.pas
// Created:   on 6-12-02 by Rich Register
// Purpose:   This module defines standard HRESULT values.
//
//*********************************************************
// Copyright © 2001 Physical Electronics, Inc.
// Created in 2001 as an unpublished copyrighted work.  This program
// and the information contained in it are confidential and proprietary
// to Physical Electronics and may not be used, copied, or reproduced
// without the prior written permission of Physical Electronics.
//
////////////////////////////////////////////////////////////////////////////////

interface

uses
  SysUtils,
  Windows,
  PhiErrorCodes;

type
  TStandardErrorCodeRecord = record
    Code: HResult;
    Str:  String;
    MappedException: integer;
  end;

const

  E_UNEXPECTED                              = HRESULT($8000FFFF);
  E_NOTIMPL                                 = HRESULT($80004001);
  E_OUTOFMEMORY                             = HRESULT($8007000E);
  E_INVALIDARG                              = HRESULT($80070057);
  E_NOINTERFACE                             = HRESULT($80004002);
  E_POINTER                                 = HRESULT($80004003);
  E_HANDLE                                  = HRESULT($80070006);
  E_ABORT                                   = HRESULT($80004004);
  E_FAIL                                    = HRESULT($80004005);
  E_ACCESSDENIED                            = HRESULT($80070005);
  E_PENDING                                 = HRESULT($8000000A);
  CO_E_INIT_TLS                             = HRESULT($80004006);
  CO_E_INIT_SHARED_ALLOCATOR                = HRESULT($80004007);
  CO_E_INIT_MEMORY_ALLOCATOR                = HRESULT($80004008);
  CO_E_INIT_CLASS_CACHE                     = HRESULT($80004009);
  CO_E_INIT_RPC_CHANNEL                     = HRESULT($8000400A);
  CO_E_INIT_TLS_SET_CHANNEL_CONTROL         = HRESULT($8000400B);
  CO_E_INIT_TLS_CHANNEL_CONTROL             = HRESULT($8000400C);
  CO_E_INIT_UNACCEPTED_USER_ALLOCATOR       = HRESULT($8000400D);
  CO_E_INIT_SCM_MUTEX_EXISTS                = HRESULT($8000400E);
  CO_E_INIT_SCM_FILE_MAPPING_EXISTS         = HRESULT($8000400F);
  CO_E_INIT_SCM_MAP_VIEW_OF_FILE            = HRESULT($80004010);
  CO_E_INIT_SCM_EXEC_FAILURE                = HRESULT($80004011);
  CO_E_INIT_ONLY_SINGLE_THREADED            = HRESULT($80004012);
  CO_E_CANT_REMOTE                          = HRESULT($80004013);
  CO_E_BAD_SERVER_NAME                      = HRESULT($80004014);
  CO_E_WRONG_SERVER_IDENTITY                = HRESULT($80004015);
  CO_E_OLE1DDE_DISABLED                     = HRESULT($80004016);
  CO_E_RUNAS_SYNTAX                         = HRESULT($80004017);
  CO_E_CREATEPROCESS_FAILURE                = HRESULT($80004018);
  CO_E_RUNAS_CREATEPROCESS_FAILURE          = HRESULT($80004019);
  CO_E_RUNAS_LOGON_FAILURE                  = HRESULT($8000401A);
  CO_E_LAUNCH_PERMSSION_DENIED              = HRESULT($8000401B);
  CO_E_START_SERVICE_FAILURE                = HRESULT($8000401C);
  CO_E_REMOTE_COMMUNICATION_FAILURE         = HRESULT($8000401D);
  CO_E_SERVER_START_TIMEOUT                 = HRESULT($8000401E);
  CO_E_CLSREG_INCONSISTENT                  = HRESULT($8000401F);
  CO_E_IIDREG_INCONSISTENT                  = HRESULT($80004020);
  CO_E_NOT_SUPPORTED                        = HRESULT($80004021);
  CO_E_RELOAD_DLL                           = HRESULT($80004022);
  CO_E_MSI_ERROR                            = HRESULT($80004023);

  OLE_E_OLEVERB                             = HRESULT($80040000);
  OLE_E_ADVF                                = HRESULT($80040001);
  OLE_E_ENUM_NOMORE                         = HRESULT($80040002);
  OLE_E_ADVISENOTSUPPORTED                  = HRESULT($80040003);
  OLE_E_NOCONNECTION                        = HRESULT($80040004);
  OLE_E_NOTRUNNING                          = HRESULT($80040005);
  OLE_E_NOCACHE                             = HRESULT($80040006);
  OLE_E_BLANK                               = HRESULT($80040007);
  OLE_E_CLASSDIFF                           = HRESULT($80040008);
  OLE_E_CANT_GETMONIKER                     = HRESULT($80040009);
  OLE_E_CANT_BINDTOSOURCE                   = HRESULT($8004000A);
  OLE_E_STATIC                              = HRESULT($8004000B);
  OLE_E_PROMPTSAVECANCELLED                 = HRESULT($8004000C);
  OLE_E_INVALIDRECT                         = HRESULT($8004000D);
  OLE_E_WRONGCOMPOBJ                        = HRESULT($8004000E);
  OLE_E_INVALIDHWND                         = HRESULT($8004000F);
  OLE_E_NOT_INPLACEACTIVE                   = HRESULT($80040010);
  OLE_E_CANTCONVERT                         = HRESULT($80040011);
  OLE_E_NOSTORAGE                           = HRESULT($80040012);
  DV_E_FORMATETC                            = HRESULT($80040064);
  DV_E_DVTARGETDEVICE                       = HRESULT($80040065);
  DV_E_STGMEDIUM                            = HRESULT($80040066);
  DV_E_STATDATA                             = HRESULT($80040067);
  DV_E_LINDEX                               = HRESULT($80040068);
  DV_E_TYMED                                = HRESULT($80040069);
  DV_E_CLIPFORMAT                           = HRESULT($8004006A);
  DV_E_DVASPECT                             = HRESULT($8004006B);
  DV_E_DVTARGETDEVICE_SIZE                  = HRESULT($8004006C);
  DV_E_NOIVIEWOBJECT                        = HRESULT($8004006D);
  DRAGDROP_E_NOTREGISTERED                  = HRESULT($80040100);
  DRAGDROP_E_ALREADYREGISTERED              = HRESULT($80040101);
  DRAGDROP_E_INVALIDHWND                    = HRESULT($80040102);
  CLASS_E_NOAGGREGATION                     = HRESULT($80040110);
  CLASS_E_CLASSNOTAVAILABLE                 = HRESULT($80040111);
  CLASS_E_NOTLICENSED                       = HRESULT($80040112);
  VIEW_E_DRAW                               = HRESULT($80040140);
  REGDB_E_READREGDB                         = HRESULT($80040150);
  REGDB_E_WRITEREGDB                        = HRESULT($80040151);
  REGDB_E_KEYMISSING                        = HRESULT($80040152);
  REGDB_E_INVALIDVALUE                      = HRESULT($80040153);
  REGDB_E_CLASSNOTREG                       = HRESULT($80040154);
  REGDB_E_IIDNOTREG                         = HRESULT($80040155);
  CAT_E_CATIDNOEXIST                        = HRESULT($80040160);
  CAT_E_NODESCRIPTION                       = HRESULT($80040161);
  CS_E_PACKAGE_NOTFOUND                     = HRESULT($80040164);
  CS_E_NOT_DELETABLE                        = HRESULT($80040165);
  CS_E_CLASS_NOTFOUND                       = HRESULT($80040166);
  CS_E_INVALID_VERSION                      = HRESULT($80040167);
  CS_E_NO_CLASSSTORE                        = HRESULT($80040168);
  CACHE_E_NOCACHE_UPDATED                   = HRESULT($80040170);
  OLEOBJ_E_NOVERBS                          = HRESULT($80040180);
  OLEOBJ_E_INVALIDVERB                      = HRESULT($80040181);
  INPLACE_E_NOTUNDOABLE                     = HRESULT($800401A0);
  INPLACE_E_NOTOOLSPACE                     = HRESULT($800401A1);
  CONVERT10_E_OLESTREAM_GET                 = HRESULT($800401C0);
  CONVERT10_E_OLESTREAM_PUT                 = HRESULT($800401C1);
  CONVERT10_E_OLESTREAM_FMT                 = HRESULT($800401C2);
  CONVERT10_E_OLESTREAM_BITMAP_TO_DIB       = HRESULT($800401C3);
  CONVERT10_E_STG_FMT                       = HRESULT($800401C4);
  CONVERT10_E_STG_NO_STD_STREAM             = HRESULT($800401C5);
  CONVERT10_E_STG_DIB_TO_BITMAP             = HRESULT($800401C6);
  CLIPBRD_E_CANT_OPEN                       = HRESULT($800401D0);
  CLIPBRD_E_CANT_EMPTY                      = HRESULT($800401D1);
  CLIPBRD_E_CANT_SET                        = HRESULT($800401D2);
  CLIPBRD_E_BAD_DATA                        = HRESULT($800401D3);
  CLIPBRD_E_CANT_CLOSE                      = HRESULT($800401D4);
  MK_E_CONNECTMANUALLY                      = HRESULT($800401E0);
  MK_E_EXCEEDEDDEADLINE                     = HRESULT($800401E1);
  MK_E_NEEDGENERIC                          = HRESULT($800401E2);
  MK_E_UNAVAILABLE                          = HRESULT($800401E3);
  MK_E_SYNTAX                               = HRESULT($800401E4);
  MK_E_NOOBJECT                             = HRESULT($800401E5);
  MK_E_INVALIDEXTENSION                     = HRESULT($800401E6);
  MK_E_INTERMEDIATEINTERFACENOTSUPPORTED    = HRESULT($800401E7);
  MK_E_NOTBINDABLE                          = HRESULT($800401E8);
  MK_E_NOTBOUND                             = HRESULT($800401E9);
  MK_E_CANTOPENFILE                         = HRESULT($800401EA);
  MK_E_MUSTBOTHERUSER                       = HRESULT($800401EB);
  MK_E_NOINVERSE                            = HRESULT($800401EC);
  MK_E_NOSTORAGE                            = HRESULT($800401ED);
  MK_E_NOPREFIX                             = HRESULT($800401EE);
  MK_E_ENUMERATION_FAILED                   = HRESULT($800401EF);
  CO_E_NOTINITIALIZED                       = HRESULT($800401F0);
  CO_E_ALREADYINITIALIZED                   = HRESULT($800401F1);
  CO_E_CANTDETERMINECLASS                   = HRESULT($800401F2);
  CO_E_CLASSSTRING                          = HRESULT($800401F3);
  CO_E_IIDSTRING                            = HRESULT($800401F4);
  CO_E_APPNOTFOUND                          = HRESULT($800401F5);
  CO_E_APPSINGLEUSE                         = HRESULT($800401F6);
  CO_E_ERRORINAPP                           = HRESULT($800401F7);
  CO_E_DLLNOTFOUND                          = HRESULT($800401F8);
  CO_E_ERRORINDLL                           = HRESULT($800401F9);
  CO_E_WRONGOSFORAPP                        = HRESULT($800401FA);
  CO_E_OBJNOTREG                            = HRESULT($800401FB);
  CO_E_OBJISREG                             = HRESULT($800401FC);
  CO_E_OBJNOTCONNECTED                      = HRESULT($800401FD);
  CO_E_APPDIDNTREG                          = HRESULT($800401FE);
  CO_E_RELEASED                             = HRESULT($800401FF);
  CO_E_FAILEDTOIMPERSONATE                  = HRESULT($80040200);
  CO_E_FAILEDTOGETSECCTX                    = HRESULT($80040201);
  CO_E_FAILEDTOOPENTHREADTOKEN              = HRESULT($80040202);
  CO_E_FAILEDTOGETTOKENINFO                 = HRESULT($80040203);
  CO_E_TRUSTEEDOESNTMATCHCLIENT             = HRESULT($80040204);
  CO_E_FAILEDTOQUERYCLIENTBLANKET           = HRESULT($80040205);
  CO_E_FAILEDTOSETDACL                      = HRESULT($80040206);
  CO_E_ACCESSCHECKFAILED                    = HRESULT($80040207);
  CO_E_NETACCESSAPIFAILED                   = HRESULT($80040208);
  CO_E_WRONGTRUSTEENAMESYNTAX               = HRESULT($80040209);
  CO_E_INVALIDSID                           = HRESULT($8004020A);
  CO_E_CONVERSIONFAILED                     = HRESULT($8004020B);
  CO_E_NOMATCHINGSIDFOUND                   = HRESULT($8004020C);
  CO_E_LOOKUPACCSIDFAILED                   = HRESULT($8004020D);
  CO_E_NOMATCHINGNAMEFOUND                  = HRESULT($8004020E);
  CO_E_LOOKUPACCNAMEFAILED                  = HRESULT($8004020F);
  CO_E_SETSERLHNDLFAILED                    = HRESULT($80040210);
  CO_E_FAILEDTOGETWINDIR                    = HRESULT($80040211);
  CO_E_PATHTOOLONG                          = HRESULT($80040212);
  CO_E_FAILEDTOGENUUID                      = HRESULT($80040213);
  CO_E_FAILEDTOCREATEFILE                   = HRESULT($80040214);
  CO_E_FAILEDTOCLOSEHANDLE                  = HRESULT($80040215);
  CO_E_EXCEEDSYSACLLIMIT                    = HRESULT($80040216);
  CO_E_ACESINWRONGORDER                     = HRESULT($80040217);
  CO_E_INCOMPATIBLESTREAMVERSION            = HRESULT($80040218);
  CO_E_FAILEDTOOPENPROCESSTOKEN             = HRESULT($80040219);
  CO_E_DECODEFAILED                         = HRESULT($8004021A);
  CO_E_ACNOTINITIALIZED                     = HRESULT($8004021B);

  OLE_S_USEREG                              = HRESULT($00040000);
  OLE_S_STATIC                              = HRESULT($00040001);
  OLE_S_MAC_CLIPFORMAT                      = HRESULT($00040002);
  DRAGDROP_S_DROP                           = HRESULT($00040100);
  DRAGDROP_S_CANCEL                         = HRESULT($00040101);
  DRAGDROP_S_USEDEFAULTCURSORS              = HRESULT($00040102);
  DATA_S_SAMEFORMATETC                      = HRESULT($00040130);
  VIEW_S_ALREADY_FROZEN                     = HRESULT($00040140);
  CACHE_S_FORMATETC_NOTSUPPORTED            = HRESULT($00040170);
  CACHE_S_SAMECACHE                         = HRESULT($00040171);
  CACHE_S_SOMECACHES_NOTUPDATED             = HRESULT($00040172);
  OLEOBJ_S_INVALIDVERB                      = HRESULT($00040180);
  OLEOBJ_S_CANNOT_DOVERB_NOW                = HRESULT($00040181);
  OLEOBJ_S_INVALIDHWND                      = HRESULT($00040182);
  INPLACE_S_TRUNCATED                       = HRESULT($000401A0);
  CONVERT10_S_NO_PRESENTATION               = HRESULT($000401C0);
  MK_S_REDUCED_TO_SELF                      = HRESULT($000401E2);
  MK_S_ME                                   = HRESULT($000401E4);
  MK_S_HIM                                  = HRESULT($000401E5);
  MK_S_US                                   = HRESULT($000401E6);
  MK_S_MONIKERALREADYREGISTERED             = HRESULT($000401E7);

  CO_E_CLASS_CREATE_FAILED                  = HRESULT($80080001);
  CO_E_SCM_ERROR                            = HRESULT($80080002);
  CO_E_SCM_RPC_FAILURE                      = HRESULT($80080003);
  CO_E_BAD_PATH                             = HRESULT($80080004);
  CO_E_SERVER_EXEC_FAILURE                  = HRESULT($80080005);
  CO_E_OBJSRV_RPC_FAILURE                   = HRESULT($80080006);
  MK_E_NO_NORMALIZED                        = HRESULT($80080007);
  CO_E_SERVER_STOPPING                      = HRESULT($80080008);
  MEM_E_INVALID_ROOT                        = HRESULT($80080009);
  MEM_E_INVALID_LINK                        = HRESULT($80080010);
  MEM_E_INVALID_SIZE                        = HRESULT($80080011);

  CO_S_NOTALLINTERFACES                     = HRESULT($00080012);

  DISP_E_UNKNOWNINTERFACE                   = HRESULT($80020001);
  DISP_E_MEMBERNOTFOUND                     = HRESULT($80020003);
  DISP_E_PARAMNOTFOUND                      = HRESULT($80020004);
  DISP_E_TYPEMISMATCH                       = HRESULT($80020005);
  DISP_E_UNKNOWNNAME                        = HRESULT($80020006);
  DISP_E_NONAMEDARGS                        = HRESULT($80020007);
  DISP_E_BADVARTYPE                         = HRESULT($80020008);
  DISP_E_EXCEPTION                          = HRESULT($80020009);
  DISP_E_OVERFLOW                           = HRESULT($8002000A);
  DISP_E_BADINDEX                           = HRESULT($8002000B);
  DISP_E_UNKNOWNLCID                        = HRESULT($8002000C);
  DISP_E_ARRAYISLOCKED                      = HRESULT($8002000D);
  DISP_E_BADPARAMCOUNT                      = HRESULT($8002000E);
  DISP_E_PARAMNOTOPTIONAL                   = HRESULT($8002000F);
  DISP_E_BADCALLEE                          = HRESULT($80020010);
  DISP_E_NOTACOLLECTION                     = HRESULT($80020011);
  DISP_E_DIVBYZERO                          = HRESULT($80020012);
  TYPE_E_BUFFERTOOSMALL                     = HRESULT($80028016);
  TYPE_E_FIELDNOTFOUND                      = HRESULT($80028017);
  TYPE_E_INVDATAREAD                        = HRESULT($80028018);
  TYPE_E_UNSUPFORMAT                        = HRESULT($80028019);
  TYPE_E_REGISTRYACCESS                     = HRESULT($8002801C);
  TYPE_E_LIBNOTREGISTERED                   = HRESULT($8002801D);
  TYPE_E_UNDEFINEDTYPE                      = HRESULT($80028027);
  TYPE_E_QUALIFIEDNAMEDISALLOWED            = HRESULT($80028028);
  TYPE_E_INVALIDSTATE                       = HRESULT($80028029);
  TYPE_E_WRONGTYPEKIND                      = HRESULT($8002802A);
  TYPE_E_ELEMENTNOTFOUND                    = HRESULT($8002802B);
  TYPE_E_AMBIGUOUSNAME                      = HRESULT($8002802C);
  TYPE_E_NAMECONFLICT                       = HRESULT($8002802D);
  TYPE_E_UNKNOWNLCID                        = HRESULT($8002802E);
  TYPE_E_DLLFUNCTIONNOTFOUND                = HRESULT($8002802F);
  TYPE_E_BADMODULEKIND                      = HRESULT($800288BD);
  TYPE_E_SIZETOOBIG                         = HRESULT($800288C5);
  TYPE_E_DUPLICATEID                        = HRESULT($800288C6);
  TYPE_E_INVALIDID                          = HRESULT($800288CF);
  TYPE_E_TYPEMISMATCH                       = HRESULT($80028CA0);
  TYPE_E_OUTOFBOUNDS                        = HRESULT($80028CA1);
  TYPE_E_IOERROR                            = HRESULT($80028CA2);
  TYPE_E_CANTCREATETMPFILE                  = HRESULT($80028CA3);
  TYPE_E_CANTLOADLIBRARY                    = HRESULT($80029C4A);
  TYPE_E_INCONSISTENTPROPFUNCS              = HRESULT($80029C83);
  TYPE_E_CIRCULARTYPE                       = HRESULT($80029C84);
  STG_E_INVALIDFUNCTION                     = HRESULT($80030001);
  STG_E_FILENOTFOUND                        = HRESULT($80030002);
  STG_E_PATHNOTFOUND                        = HRESULT($80030003);
  STG_E_TOOMANYOPENFILES                    = HRESULT($80030004);
  STG_E_ACCESSDENIED                        = HRESULT($80030005);
  STG_E_INVALIDHANDLE                       = HRESULT($80030006);
  STG_E_INSUFFICIENTMEMORY                  = HRESULT($80030008);
  STG_E_INVALIDPOINTER                      = HRESULT($80030009);
  STG_E_NOMOREFILES                         = HRESULT($80030012);
  STG_E_DISKISWRITEPROTECTED                = HRESULT($80030013);
  STG_E_SEEKERROR                           = HRESULT($80030019);
  STG_E_WRITEFAULT                          = HRESULT($8003001D);
  STG_E_READFAULT                           = HRESULT($8003001E);
  STG_E_SHAREVIOLATION                      = HRESULT($80030020);
  STG_E_LOCKVIOLATION                       = HRESULT($80030021);
  STG_E_FILEALREADYEXISTS                   = HRESULT($80030050);
  STG_E_INVALIDPARAMETER                    = HRESULT($80030057);
  STG_E_MEDIUMFULL                          = HRESULT($80030070);
  STG_E_PROPSETMISMATCHED                   = HRESULT($800300F0);
  STG_E_ABNORMALAPIEXIT                     = HRESULT($800300FA);
  STG_E_INVALIDHEADER                       = HRESULT($800300FB);
  STG_E_INVALIDNAME                         = HRESULT($800300FC);
  STG_E_UNKNOWN                             = HRESULT($800300FD);
  STG_E_UNIMPLEMENTEDFUNCTION               = HRESULT($800300FE);
  STG_E_INVALIDFLAG                         = HRESULT($800300FF);
  STG_E_INUSE                               = HRESULT($80030100);
  STG_E_NOTCURRENT                          = HRESULT($80030101);
  STG_E_REVERTED                            = HRESULT($80030102);
  STG_E_CANTSAVE                            = HRESULT($80030103);
  STG_E_OLDFORMAT                           = HRESULT($80030104);
  STG_E_OLDDLL                              = HRESULT($80030105);
  STG_E_SHAREREQUIRED                       = HRESULT($80030106);
  STG_E_NOTFILEBASEDSTORAGE                 = HRESULT($80030107);
  STG_E_EXTANTMARSHALLINGS                  = HRESULT($80030108);
  STG_E_DOCFILECORRUPT                      = HRESULT($80030109);
  STG_E_BADBASEADDRESS                      = HRESULT($80030110);
  STG_E_INCOMPLETE                          = HRESULT($80030201);
  STG_E_TERMINATED                          = HRESULT($80030202);

  STG_S_CONVERTED                           = HRESULT($00030200);
  STG_S_BLOCK                               = HRESULT($00030201);
  STG_S_RETRYNOW                            = HRESULT($00030202);
  STG_S_MONITORING                          = HRESULT($00030203);
  STG_S_MULTIPLEOPENS                       = HRESULT($00030204);
  STG_S_CONSOLIDATIONFAILED                 = HRESULT($00030205);
  STG_S_CANNOTCONSOLIDATE                   = HRESULT($00030206);

  RPC_E_CALL_REJECTED                       = HRESULT($80010001);
  RPC_E_CALL_CANCELED                       = HRESULT($80010002);
  RPC_E_CANTPOST_INSENDCALL                 = HRESULT($80010003);
  RPC_E_CANTCALLOUT_INASYNCCALL             = HRESULT($80010004);
  RPC_E_CANTCALLOUT_INEXTERNALCALL          = HRESULT($80010005);
  RPC_E_CONNECTION_TERMINATED               = HRESULT($80010006);
  RPC_E_SERVER_DIED                         = HRESULT($80010007);
  RPC_E_CLIENT_DIED                         = HRESULT($80010008);
  RPC_E_INVALID_DATAPACKET                  = HRESULT($80010009);
  RPC_E_CANTTRANSMIT_CALL                   = HRESULT($8001000A);
  RPC_E_CLIENT_CANTMARSHAL_DATA             = HRESULT($8001000B);
  RPC_E_CLIENT_CANTUNMARSHAL_DATA           = HRESULT($8001000C);
  RPC_E_SERVER_CANTMARSHAL_DATA             = HRESULT($8001000D);
  RPC_E_SERVER_CANTUNMARSHAL_DATA           = HRESULT($8001000E);
  RPC_E_INVALID_DATA                        = HRESULT($8001000F);
  RPC_E_INVALID_PARAMETER                   = HRESULT($80010010);
  RPC_E_CANTCALLOUT_AGAIN                   = HRESULT($80010011);
  RPC_E_SERVER_DIED_DNE                     = HRESULT($80010012);
  RPC_E_SYS_CALL_FAILED                     = HRESULT($80010100);
  RPC_E_OUT_OF_RESOURCES                    = HRESULT($80010101);
  RPC_E_ATTEMPTED_MULTITHREAD               = HRESULT($80010102);
  RPC_E_NOT_REGISTERED                      = HRESULT($80010103);
  RPC_E_FAULT                               = HRESULT($80010104);
  RPC_E_SERVERFAULT                         = HRESULT($80010105);
  RPC_E_CHANGED_MODE                        = HRESULT($80010106);
  RPC_E_INVALIDMETHOD                       = HRESULT($80010107);
  RPC_E_DISCONNECTED                        = HRESULT($80010108);
  RPC_E_RETRY                               = HRESULT($80010109);
  RPC_E_SERVERCALL_RETRYLATER               = HRESULT($8001010A);
  RPC_E_SERVERCALL_REJECTED                 = HRESULT($8001010B);
  RPC_E_INVALID_CALLDATA                    = HRESULT($8001010C);
  RPC_E_CANTCALLOUT_ININPUTSYNCCALL         = HRESULT($8001010D);
  RPC_E_WRONG_THREAD                        = HRESULT($8001010E);
  RPC_E_THREAD_NOT_INIT                     = HRESULT($8001010F);
  RPC_E_VERSION_MISMATCH                    = HRESULT($80010110);
  RPC_E_INVALID_HEADER                      = HRESULT($80010111);
  RPC_E_INVALID_EXTENSION                   = HRESULT($80010112);
  RPC_E_INVALID_IPID                        = HRESULT($80010113);
  RPC_E_INVALID_OBJECT                      = HRESULT($80010114);
  RPC_S_CALLPENDING                         = HRESULT($80010115);
  RPC_S_WAITONTIMER                         = HRESULT($80010116);
  RPC_E_CALL_COMPLETE                       = HRESULT($80010117);
  RPC_E_UNSECURE_CALL                       = HRESULT($80010118);
  RPC_E_TOO_LATE                            = HRESULT($80010119);
  RPC_E_NO_GOOD_SECURITY_PACKAGES           = HRESULT($8001011A);
  RPC_E_ACCESS_DENIED                       = HRESULT($8001011B);
  RPC_E_REMOTE_DISABLED                     = HRESULT($8001011C);
  RPC_E_INVALID_OBJREF                      = HRESULT($8001011D);
  RPC_E_NO_CONTEXT                          = HRESULT($8001011E);
  RPC_E_TIMEOUT                             = HRESULT($8001011F);
  RPC_E_NO_SYNC                             = HRESULT($80010120);
  RPC_E_UNEXPECTED                          = HRESULT($8001FFFF);
  NTE_BAD_UID                               = HRESULT($80090001);
  NTE_BAD_HASH                              = HRESULT($80090002);
  NTE_BAD_KEY                               = HRESULT($80090003);
  NTE_BAD_LEN                               = HRESULT($80090004);
  NTE_BAD_DATA                              = HRESULT($80090005);
  NTE_BAD_SIGNATURE                         = HRESULT($80090006);
  NTE_BAD_VER                               = HRESULT($80090007);
  NTE_BAD_ALGID                             = HRESULT($80090008);
  NTE_BAD_FLAGS                             = HRESULT($80090009);
  NTE_BAD_TYPE                              = HRESULT($8009000A);
  NTE_BAD_KEY_STATE                         = HRESULT($8009000B);
  NTE_BAD_HASH_STATE                        = HRESULT($8009000C);
  NTE_NO_KEY                                = HRESULT($8009000D);
  NTE_NO_MEMORY                             = HRESULT($8009000E);
  NTE_EXISTS                                = HRESULT($8009000F);
  NTE_PERM                                  = HRESULT($80090010);
  NTE_NOT_FOUND                             = HRESULT($80090011);
  NTE_DOUBLE_ENCRYPT                        = HRESULT($80090012);
  NTE_BAD_PROVIDER                          = HRESULT($80090013);
  NTE_BAD_PROV_TYPE                         = HRESULT($80090014);
  NTE_BAD_PUBLIC_KEY                        = HRESULT($80090015);
  NTE_BAD_KEYSET                            = HRESULT($80090016);
  NTE_PROV_TYPE_NOT_DEF                     = HRESULT($80090017);
  NTE_PROV_TYPE_ENTRY_BAD                   = HRESULT($80090018);
  NTE_KEYSET_NOT_DEF                        = HRESULT($80090019);
  NTE_KEYSET_ENTRY_BAD                      = HRESULT($8009001A);
  NTE_PROV_TYPE_NO_MATCH                    = HRESULT($8009001B);
  NTE_SIGNATURE_FILE_BAD                    = HRESULT($8009001C);
  NTE_PROVIDER_DLL_FAIL                     = HRESULT($8009001D);
  NTE_PROV_DLL_NOT_FOUND                    = HRESULT($8009001E);
  NTE_BAD_KEYSET_PARAM                      = HRESULT($8009001F);
  NTE_FAIL                                  = HRESULT($80090020);
  NTE_SYS_ERR                               = HRESULT($80090021);
  CRYPT_E_MSG_ERROR                         = HRESULT($80091001);
  CRYPT_E_UNKNOWN_ALGO                      = HRESULT($80091002);
  CRYPT_E_OID_FORMAT                        = HRESULT($80091003);
  CRYPT_E_INVALID_MSG_TYPE                  = HRESULT($80091004);
  CRYPT_E_UNEXPECTED_ENCODING               = HRESULT($80091005);
  CRYPT_E_AUTH_ATTR_MISSING                 = HRESULT($80091006);
  CRYPT_E_HASH_VALUE                        = HRESULT($80091007);
  CRYPT_E_INVALID_INDEX                     = HRESULT($80091008);
  CRYPT_E_ALREADY_DECRYPTED                 = HRESULT($80091009);
  CRYPT_E_NOT_DECRYPTED                     = HRESULT($8009100A);
  CRYPT_E_RECIPIENT_NOT_FOUND               = HRESULT($8009100B);
  CRYPT_E_CONTROL_TYPE                      = HRESULT($8009100C);
  CRYPT_E_ISSUER_SERIALNUMBER               = HRESULT($8009100D);
  CRYPT_E_SIGNER_NOT_FOUND                  = HRESULT($8009100E);
  CRYPT_E_ATTRIBUTES_MISSING                = HRESULT($8009100F);
  CRYPT_E_STREAM_MSG_NOT_READY              = HRESULT($80091010);
  CRYPT_E_STREAM_INSUFFICIENT_DATA          = HRESULT($80091011);
  CRYPT_E_BAD_LEN                           = HRESULT($80092001);
  CRYPT_E_BAD_ENCODE                        = HRESULT($80092002);
  CRYPT_E_FILE_ERROR                        = HRESULT($80092003);
  CRYPT_E_NOT_FOUND                         = HRESULT($80092004);
  CRYPT_E_EXISTS                            = HRESULT($80092005);
  CRYPT_E_NO_PROVIDER                       = HRESULT($80092006);
  CRYPT_E_SELF_SIGNED                       = HRESULT($80092007);
  CRYPT_E_DELETED_PREV                      = HRESULT($80092008);
  CRYPT_E_NO_MATCH                          = HRESULT($80092009);
  CRYPT_E_UNEXPECTED_MSG_TYPE               = HRESULT($8009200A);
  CRYPT_E_NO_KEY_PROPERTY                   = HRESULT($8009200B);
  CRYPT_E_NO_DECRYPT_CERT                   = HRESULT($8009200C);
  CRYPT_E_BAD_MSG                           = HRESULT($8009200D);
  CRYPT_E_NO_SIGNER                         = HRESULT($8009200E);
  CRYPT_E_PENDING_CLOSE                     = HRESULT($8009200F);
  CRYPT_E_REVOKED                           = HRESULT($80092010);
  CRYPT_E_NO_REVOCATION_DLL                 = HRESULT($80092011);
  CRYPT_E_NO_REVOCATION_CHECK               = HRESULT($80092012);
  CRYPT_E_REVOCATION_OFFLINE                = HRESULT($80092013);
  CRYPT_E_NOT_IN_REVOCATION_DATABASE        = HRESULT($80092014);
  CRYPT_E_INVALID_NUMERIC_STRING            = HRESULT($80092020);
  CRYPT_E_INVALID_PRINTABLE_STRING          = HRESULT($80092021);
  CRYPT_E_INVALID_IA5_STRING                = HRESULT($80092022);
  CRYPT_E_INVALID_X500_STRING               = HRESULT($80092023);
  CRYPT_E_NOT_CHAR_STRING                   = HRESULT($80092024);
  CRYPT_E_FILERESIZED                       = HRESULT($80092025);
  CRYPT_E_SECURITY_SETTINGS                 = HRESULT($80092026);
  CRYPT_E_NO_VERIFY_USAGE_DLL               = HRESULT($80092027);
  CRYPT_E_NO_VERIFY_USAGE_CHECK             = HRESULT($80092028);
  CRYPT_E_VERIFY_USAGE_OFFLINE              = HRESULT($80092029);
  CRYPT_E_NOT_IN_CTL                        = HRESULT($8009202A);
  CRYPT_E_NO_TRUSTED_SIGNER                 = HRESULT($8009202B);
  CRYPT_E_OSS_ERROR                         = HRESULT($80093000);
  CERTSRV_E_BAD_REQUESTSUBJECT              = HRESULT($80094001);
  CERTSRV_E_NO_REQUEST                      = HRESULT($80094002);
  CERTSRV_E_BAD_REQUESTSTATUS               = HRESULT($80094003);
  CERTSRV_E_PROPERTY_EMPTY                  = HRESULT($80094004);
  CERTDB_E_JET_ERROR                        = HRESULT($80095000);
  TRUST_E_SYSTEM_ERROR                      = HRESULT($80096001);
  TRUST_E_NO_SIGNER_CERT                    = HRESULT($80096002);
  TRUST_E_COUNTER_SIGNER                    = HRESULT($80096003);
  TRUST_E_CERT_SIGNATURE                    = HRESULT($80096004);
  TRUST_E_TIME_STAMP                        = HRESULT($80096005);
  TRUST_E_BAD_DIGEST                        = HRESULT($80096010);
  TRUST_E_BASIC_CONSTRAINTS                 = HRESULT($80096019);
  TRUST_E_FINANCIAL_CRITERIA                = HRESULT($8009601E);
  TRUST_E_PROVIDER_UNKNOWN                  = HRESULT($800B0001);
  TRUST_E_ACTION_UNKNOWN                    = HRESULT($800B0002);
  TRUST_E_SUBJECT_FORM_UNKNOWN              = HRESULT($800B0003);
  TRUST_E_SUBJECT_NOT_TRUSTED               = HRESULT($800B0004);
  DIGSIG_E_ENCODE                           = HRESULT($800B0005);
  DIGSIG_E_DECODE                           = HRESULT($800B0006);
  DIGSIG_E_EXTENSIBILITY                    = HRESULT($800B0007);
  DIGSIG_E_CRYPTO                           = HRESULT($800B0008);
  PERSIST_E_SIZEDEFINITE                    = HRESULT($800B0009);
  PERSIST_E_SIZEINDEFINITE                  = HRESULT($800B000A);
  PERSIST_E_NOTSELFSIZING                   = HRESULT($800B000B);
  TRUST_E_NOSIGNATURE                       = HRESULT($800B0100);
  CERT_E_EXPIRED                            = HRESULT($800B0101);
  CERT_E_VALIDITYPERIODNESTING              = HRESULT($800B0102);
  CERT_E_ROLE                               = HRESULT($800B0103);
  CERT_E_PATHLENCONST                       = HRESULT($800B0104);
  CERT_E_CRITICAL                           = HRESULT($800B0105);
  CERT_E_PURPOSE                            = HRESULT($800B0106);
  CERT_E_ISSUERCHAINING                     = HRESULT($800B0107);
  CERT_E_MALFORMED                          = HRESULT($800B0108);
  CERT_E_UNTRUSTEDROOT                      = HRESULT($800B0109);
  CERT_E_CHAINING                           = HRESULT($800B010A);
  TRUST_E_FAIL                              = HRESULT($800B010B);
  CERT_E_REVOKED                            = HRESULT($800B010C);
  CERT_E_UNTRUSTEDTESTROOT                  = HRESULT($800B010D);
  CERT_E_REVOCATION_FAILURE                 = HRESULT($800B010E);
  CERT_E_CN_NO_MATCH                        = HRESULT($800B010F);
  CERT_E_WRONG_USAGE                        = HRESULT($800B0110);
  SPAPI_E_EXPECTED_SECTION_NAME             = HRESULT($800F0000);
  SPAPI_E_BAD_SECTION_NAME_LINE             = HRESULT($800F0001);
  SPAPI_E_SECTION_NAME_TOO_LONG             = HRESULT($800F0002);
  SPAPI_E_GENERAL_SYNTAX                    = HRESULT($800F0003);
  SPAPI_E_WRONG_INF_STYLE                   = HRESULT($800F0100);
  SPAPI_E_SECTION_NOT_FOUND                 = HRESULT($800F0101);
  SPAPI_E_LINE_NOT_FOUND                    = HRESULT($800F0102);
  SPAPI_E_NO_ASSOCIATED_CLASS               = HRESULT($800F0200);
  SPAPI_E_CLASS_MISMATCH                    = HRESULT($800F0201);
  SPAPI_E_DUPLICATE_FOUND                   = HRESULT($800F0202);
  SPAPI_E_NO_DRIVER_SELECTED                = HRESULT($800F0203);
  SPAPI_E_KEY_DOES_NOT_EXIST                = HRESULT($800F0204);
  SPAPI_E_INVALID_DEVINST_NAME              = HRESULT($800F0205);
  SPAPI_E_INVALID_CLASS                     = HRESULT($800F0206);
  SPAPI_E_DEVINST_ALREADY_EXISTS            = HRESULT($800F0207);
  SPAPI_E_DEVINFO_NOT_REGISTERED            = HRESULT($800F0208);
  SPAPI_E_INVALID_REG_PROPERTY              = HRESULT($800F0209);
  SPAPI_E_NO_INF                            = HRESULT($800F020A);
  SPAPI_E_NO_SUCH_DEVINST                   = HRESULT($800F020B);
  SPAPI_E_CANT_LOAD_CLASS_ICON              = HRESULT($800F020C);
  SPAPI_E_INVALID_CLASS_INSTALLER           = HRESULT($800F020D);
  SPAPI_E_DI_DO_DEFAULT                     = HRESULT($800F020E);
  SPAPI_E_DI_NOFILECOPY                     = HRESULT($800F020F);
  SPAPI_E_INVALID_HWPROFILE                 = HRESULT($800F0210);
  SPAPI_E_NO_DEVICE_SELECTED                = HRESULT($800F0211);
  SPAPI_E_DEVINFO_LIST_LOCKED               = HRESULT($800F0212);
  SPAPI_E_DEVINFO_DATA_LOCKED               = HRESULT($800F0213);
  SPAPI_E_DI_BAD_PATH                       = HRESULT($800F0214);
  SPAPI_E_NO_CLASSINSTALL_PARAMS            = HRESULT($800F0215);
  SPAPI_E_FILEQUEUE_LOCKED                  = HRESULT($800F0216);
  SPAPI_E_BAD_SERVICE_INSTALLSECT           = HRESULT($800F0217);
  SPAPI_E_NO_CLASS_DRIVER_LIST              = HRESULT($800F0218);
  SPAPI_E_NO_ASSOCIATED_SERVICE             = HRESULT($800F0219);
  SPAPI_E_NO_DEFAULT_DEVICE_INTERFACE       = HRESULT($800F021A);
  SPAPI_E_DEVICE_INTERFACE_ACTIVE           = HRESULT($800F021B);
  SPAPI_E_DEVICE_INTERFACE_REMOVED          = HRESULT($800F021C);
  SPAPI_E_BAD_INTERFACE_INSTALLSECT         = HRESULT($800F021D);
  SPAPI_E_NO_SUCH_INTERFACE_CLASS           = HRESULT($800F021E);
  SPAPI_E_INVALID_REFERENCE_STRING          = HRESULT($800F021F);
  SPAPI_E_INVALID_MACHINENAME               = HRESULT($800F0220);
  SPAPI_E_REMOTE_COMM_FAILURE               = HRESULT($800F0221);
  SPAPI_E_MACHINE_UNAVAILABLE               = HRESULT($800F0222);
  SPAPI_E_NO_CONFIGMGR_SERVICES             = HRESULT($800F0223);
  SPAPI_E_INVALID_PROPPAGE_PROVIDER         = HRESULT($800F0224);
  SPAPI_E_NO_SUCH_DEVICE_INTERFACE          = HRESULT($800F0225);
  SPAPI_E_DI_POSTPROCESSING_REQUIREd        = HRESULT($800F0226);
  SPAPI_E_INVALID_COINSTALLER               = HRESULT($800F0227);
  SPAPI_E_NO_COMPAT_DRIVERS                 = HRESULT($800F0228);
  SPAPI_E_NO_DEVICE_ICON                    = HRESULT($800F0229);
  SPAPI_E_INVALID_INF_LOGCONFIG             = HRESULT($800F022A);
  SPAPI_E_DI_DONT_INSTALL                   = HRESULT($800F022B);
  SPAPI_E_INVALID_FILTER_DRIVER             = HRESULT($800F022C);
  SPAPI_E_ERROR_NOT_INSTALLED               = HRESULT($800F1000);
//Add new Hresults both above and to the Mapped below!!!

  StandardErrorCodeArray: array[0..516] of TStandardErrorCodeRecord =
 (
  (Code: E_UNEXPECTED                              ; Str:'E_UNEXPECTED';                                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: E_NOTIMPL                                 ; Str:'E_NOTIMPL';                                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: E_OUTOFMEMORY                             ; Str:'E_OUTOFMEMORY';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: E_INVALIDARG                              ; Str:'E_INVALIDARG';                                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: E_NOINTERFACE                             ; Str:'E_NOINTERFACE';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: E_POINTER                                 ; Str:'E_POINTER';                                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: E_HANDLE                                  ; Str:'E_HANDLE';                                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: E_ABORT                                   ; Str:'E_ABORT';                                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: E_FAIL                                    ; Str:'E_FAIL';                                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: E_ACCESSDENIED                            ; Str:'E_ACCESSDENIED';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: E_PENDING                                 ; Str:'E_PENDING';                                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_TLS                             ; Str:'CO_E_INIT_TLS';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_SHARED_ALLOCATOR                ; Str:'CO_E_INIT_SHARED_ALLOCATOR';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_MEMORY_ALLOCATOR                ; Str:'CO_E_INIT_MEMORY_ALLOCATOR';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_CLASS_CACHE                     ; Str:'CO_E_INIT_CLASS_CACHE';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_RPC_CHANNEL                     ; Str:'CO_E_INIT_RPC_CHANNEL';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_TLS_SET_CHANNEL_CONTROL         ; Str:'CO_E_INIT_TLS_SET_CHANNEL_CONTROL';           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_TLS_CHANNEL_CONTROL             ; Str:'CO_E_INIT_TLS_CHANNEL_CONTROL';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_UNACCEPTED_USER_ALLOCATOR       ; Str:'CO_E_INIT_UNACCEPTED_USER_ALLOCATOR';         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_SCM_MUTEX_EXISTS                ; Str:'CO_E_INIT_SCM_MUTEX_EXISTS';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_SCM_FILE_MAPPING_EXISTS         ; Str:'CO_E_INIT_SCM_FILE_MAPPING_EXISTS';           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_SCM_MAP_VIEW_OF_FILE            ; Str:'CO_E_INIT_SCM_MAP_VIEW_OF_FILE';              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_SCM_EXEC_FAILURE                ; Str:'CO_E_INIT_SCM_EXEC_FAILURE';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INIT_ONLY_SINGLE_THREADED            ; Str:'CO_E_INIT_ONLY_SINGLE_THREADED';              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_CANT_REMOTE                          ; Str:'CO_E_CANT_REMOTE';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_BAD_SERVER_NAME                      ; Str:'CO_E_BAD_SERVER_NAME';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_WRONG_SERVER_IDENTITY                ; Str:'CO_E_WRONG_SERVER_IDENTITY';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_OLE1DDE_DISABLED                     ; Str:'CO_E_OLE1DDE_DISABLED';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_RUNAS_SYNTAX                         ; Str:'CO_E_RUNAS_SYNTAX';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_CREATEPROCESS_FAILURE                ; Str:'CO_E_CREATEPROCESS_FAILURE';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_RUNAS_CREATEPROCESS_FAILURE          ; Str:'CO_E_RUNAS_CREATEPROCESS_FAILURE';            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_RUNAS_LOGON_FAILURE                  ; Str:'CO_E_RUNAS_LOGON_FAILURE';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_LAUNCH_PERMSSION_DENIED              ; Str:'CO_E_LAUNCH_PERMSSION_DENIED';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_START_SERVICE_FAILURE                ; Str:'CO_E_START_SERVICE_FAILURE';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_REMOTE_COMMUNICATION_FAILURE         ; Str:'CO_E_REMOTE_COMMUNICATION_FAILURE';           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_SERVER_START_TIMEOUT                 ; Str:'CO_E_SERVER_START_TIMEOUT';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_CLSREG_INCONSISTENT                  ; Str:'CO_E_CLSREG_INCONSISTENT';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_IIDREG_INCONSISTENT                  ; Str:'CO_E_IIDREG_INCONSISTENT';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_NOT_SUPPORTED                        ; Str:'CO_E_NOT_SUPPORTED';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_RELOAD_DLL                           ; Str:'CO_E_RELOAD_DLL';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_MSI_ERROR                            ; Str:'CO_E_MSI_ERROR';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_OLEVERB                             ; Str:'OLE_E_OLEVERB';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_ADVF                                ; Str:'OLE_E_ADVF';                                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_ENUM_NOMORE                         ; Str:'OLE_E_ENUM_NOMORE';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_ADVISENOTSUPPORTED                  ; Str:'OLE_E_ADVISENOTSUPPORTED';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_NOCONNECTION                        ; Str:'OLE_E_NOCONNECTION';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_NOTRUNNING                          ; Str:'OLE_E_NOTRUNNING';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_NOCACHE                             ; Str:'OLE_E_NOCACHE';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_BLANK                               ; Str:'OLE_E_BLANK';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_CLASSDIFF                           ; Str:'OLE_E_CLASSDIFF';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_CANT_GETMONIKER                     ; Str:'OLE_E_CANT_GETMONIKER';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_CANT_BINDTOSOURCE                   ; Str:'OLE_E_CANT_BINDTOSOURCE';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_STATIC                              ; Str:'OLE_E_STATIC';                                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_PROMPTSAVECANCELLED                 ; Str:'OLE_E_PROMPTSAVECANCELLED';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_INVALIDRECT                         ; Str:'OLE_E_INVALIDRECT';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_WRONGCOMPOBJ                        ; Str:'OLE_E_WRONGCOMPOBJ';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_INVALIDHWND                         ; Str:'OLE_E_INVALIDHWND';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_NOT_INPLACEACTIVE                   ; Str:'OLE_E_NOT_INPLACEACTIVE';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_CANTCONVERT                         ; Str:'OLE_E_CANTCONVERT';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_E_NOSTORAGE                           ; Str:'OLE_E_NOSTORAGE';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DV_E_FORMATETC                            ; Str:'DV_E_FORMATETC';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DV_E_DVTARGETDEVICE                       ; Str:'DV_E_DVTARGETDEVICE';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DV_E_STGMEDIUM                            ; Str:'DV_E_STGMEDIUM';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DV_E_STATDATA                             ; Str:'DV_E_STATDATA';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DV_E_LINDEX                               ; Str:'DV_E_LINDEX';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DV_E_TYMED                                ; Str:'DV_E_TYMED';                                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DV_E_CLIPFORMAT                           ; Str:'DV_E_CLIPFORMAT';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DV_E_DVASPECT                             ; Str:'DV_E_DVASPECT';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DV_E_DVTARGETDEVICE_SIZE                  ; Str:'DV_E_DVTARGETDEVICE_SIZE';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DV_E_NOIVIEWOBJECT                        ; Str:'DV_E_NOIVIEWOBJECT';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DRAGDROP_E_NOTREGISTERED                  ; Str:'DRAGDROP_E_NOTREGISTERED';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DRAGDROP_E_ALREADYREGISTERED              ; Str:'DRAGDROP_E_ALREADYREGISTERED';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DRAGDROP_E_INVALIDHWND                    ; Str:'DRAGDROP_E_INVALIDHWND';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CLASS_E_NOAGGREGATION                     ; Str:'CLASS_E_NOAGGREGATION';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CLASS_E_CLASSNOTAVAILABLE                 ; Str:'CLASS_E_CLASSNOTAVAILABLE';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CLASS_E_NOTLICENSED                       ; Str:'CLASS_E_NOTLICENSED';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: VIEW_E_DRAW                               ; Str:'VIEW_E_DRAW';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: REGDB_E_READREGDB                         ; Str:'REGDB_E_READREGDB';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: REGDB_E_WRITEREGDB                        ; Str:'REGDB_E_WRITEREGDB';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: REGDB_E_KEYMISSING                        ; Str:'REGDB_E_KEYMISSING';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: REGDB_E_INVALIDVALUE                      ; Str:'REGDB_E_INVALIDVALUE';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: REGDB_E_CLASSNOTREG                       ; Str:'REGDB_E_CLASSNOTREG';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: REGDB_E_IIDNOTREG                         ; Str:'REGDB_E_IIDNOTREG';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CAT_E_CATIDNOEXIST                        ; Str:'CAT_E_CATIDNOEXIST';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CAT_E_NODESCRIPTION                       ; Str:'CAT_E_NODESCRIPTION';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CS_E_PACKAGE_NOTFOUND                     ; Str:'CS_E_PACKAGE_NOTFOUND';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CS_E_NOT_DELETABLE                        ; Str:'CS_E_NOT_DELETABLE';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CS_E_CLASS_NOTFOUND                       ; Str:'CS_E_CLASS_NOTFOUND';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CS_E_INVALID_VERSION                      ; Str:'CS_E_INVALID_VERSION';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CS_E_NO_CLASSSTORE                        ; Str:'CS_E_NO_CLASSSTORE';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CACHE_E_NOCACHE_UPDATED                   ; Str:'CACHE_E_NOCACHE_UPDATED';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLEOBJ_E_NOVERBS                          ; Str:'OLEOBJ_E_NOVERBS';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLEOBJ_E_INVALIDVERB                      ; Str:'OLEOBJ_E_INVALIDVERB';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: INPLACE_E_NOTUNDOABLE                     ; Str:'INPLACE_E_NOTUNDOABLE';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: INPLACE_E_NOTOOLSPACE                     ; Str:'INPLACE_E_NOTOOLSPACE';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CONVERT10_E_OLESTREAM_GET                 ; Str:'CONVERT10_E_OLESTREAM_GET';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CONVERT10_E_OLESTREAM_PUT                 ; Str:'CONVERT10_E_OLESTREAM_PUT';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CONVERT10_E_OLESTREAM_FMT                 ; Str:'CONVERT10_E_OLESTREAM_FMT';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CONVERT10_E_OLESTREAM_BITMAP_TO_DIB       ; Str:'CONVERT10_E_OLESTREAM_BITMAP_TO_DIB';         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CONVERT10_E_STG_FMT                       ; Str:'CONVERT10_E_STG_FMT';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CONVERT10_E_STG_NO_STD_STREAM             ; Str:'CONVERT10_E_STG_NO_STD_STREAM';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CONVERT10_E_STG_DIB_TO_BITMAP             ; Str:'CONVERT10_E_STG_DIB_TO_BITMAP';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CLIPBRD_E_CANT_OPEN                       ; Str:'CLIPBRD_E_CANT_OPEN';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CLIPBRD_E_CANT_EMPTY                      ; Str:'CLIPBRD_E_CANT_EMPTY';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CLIPBRD_E_CANT_SET                        ; Str:'CLIPBRD_E_CANT_SET';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CLIPBRD_E_BAD_DATA                        ; Str:'CLIPBRD_E_BAD_DATA';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CLIPBRD_E_CANT_CLOSE                      ; Str:'CLIPBRD_E_CANT_CLOSE';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_CONNECTMANUALLY                      ; Str:'MK_E_CONNECTMANUALLY';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_EXCEEDEDDEADLINE                     ; Str:'MK_E_EXCEEDEDDEADLINE';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_NEEDGENERIC                          ; Str:'MK_E_NEEDGENERIC';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_UNAVAILABLE                          ; Str:'MK_E_UNAVAILABLE';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_SYNTAX                               ; Str:'MK_E_SYNTAX';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_NOOBJECT                             ; Str:'MK_E_NOOBJECT';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_INVALIDEXTENSION                     ; Str:'MK_E_INVALIDEXTENSION';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_INTERMEDIATEINTERFACENOTSUPPORTED    ; Str:'MK_E_INTERMEDIATEINTERFACENOTSUPPORTED';      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_NOTBINDABLE                          ; Str:'MK_E_NOTBINDABLE';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_NOTBOUND                             ; Str:'MK_E_NOTBOUND';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_CANTOPENFILE                         ; Str:'MK_E_CANTOPENFILE';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_MUSTBOTHERUSER                       ; Str:'MK_E_MUSTBOTHERUSER';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_NOINVERSE                            ; Str:'MK_E_NOINVERSE';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_NOSTORAGE                            ; Str:'MK_E_NOSTORAGE';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_NOPREFIX                             ; Str:'MK_E_NOPREFIX';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_ENUMERATION_FAILED                   ; Str:'MK_E_ENUMERATION_FAILED';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_NOTINITIALIZED                       ; Str:'CO_E_NOTINITIALIZED';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_ALREADYINITIALIZED                   ; Str:'CO_E_ALREADYINITIALIZED';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_CANTDETERMINECLASS                   ; Str:'CO_E_CANTDETERMINECLASS';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_CLASSSTRING                          ; Str:'CO_E_CLASSSTRING';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_IIDSTRING                            ; Str:'CO_E_IIDSTRING';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_APPNOTFOUND                          ; Str:'CO_E_APPNOTFOUND';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_APPSINGLEUSE                         ; Str:'CO_E_APPSINGLEUSE';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_ERRORINAPP                           ; Str:'CO_E_ERRORINAPP';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_DLLNOTFOUND                          ; Str:'CO_E_DLLNOTFOUND';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_ERRORINDLL                           ; Str:'CO_E_ERRORINDLL';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_WRONGOSFORAPP                        ; Str:'CO_E_WRONGOSFORAPP';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_OBJNOTREG                            ; Str:'CO_E_OBJNOTREG';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_OBJISREG                             ; Str:'CO_E_OBJISREG';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_OBJNOTCONNECTED                      ; Str:'CO_E_OBJNOTCONNECTED';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_APPDIDNTREG                          ; Str:'CO_E_APPDIDNTREG';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_RELEASED                             ; Str:'CO_E_RELEASED';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_FAILEDTOIMPERSONATE                  ; Str:'CO_E_FAILEDTOIMPERSONATE';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_FAILEDTOGETSECCTX                    ; Str:'CO_E_FAILEDTOGETSECCTX';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_FAILEDTOOPENTHREADTOKEN              ; Str:'CO_E_FAILEDTOOPENTHREADTOKEN';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_FAILEDTOGETTOKENINFO                 ; Str:'CO_E_FAILEDTOGETTOKENINFO';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_TRUSTEEDOESNTMATCHCLIENT             ; Str:'CO_E_TRUSTEEDOESNTMATCHCLIENT';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_FAILEDTOQUERYCLIENTBLANKET           ; Str:'CO_E_FAILEDTOQUERYCLIENTBLANKET';             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_FAILEDTOSETDACL                      ; Str:'CO_E_FAILEDTOSETDACL';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_ACCESSCHECKFAILED                    ; Str:'CO_E_ACCESSCHECKFAILED';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_NETACCESSAPIFAILED                   ; Str:'CO_E_NETACCESSAPIFAILED';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_WRONGTRUSTEENAMESYNTAX               ; Str:'CO_E_WRONGTRUSTEENAMESYNTAX';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INVALIDSID                           ; Str:'CO_E_INVALIDSID';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_CONVERSIONFAILED                     ; Str:'CO_E_CONVERSIONFAILED';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_NOMATCHINGSIDFOUND                   ; Str:'CO_E_NOMATCHINGSIDFOUND';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_LOOKUPACCSIDFAILED                   ; Str:'CO_E_LOOKUPACCSIDFAILED';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_NOMATCHINGNAMEFOUND                  ; Str:'CO_E_NOMATCHINGNAMEFOUND';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_LOOKUPACCNAMEFAILED                  ; Str:'CO_E_LOOKUPACCNAMEFAILED';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_SETSERLHNDLFAILED                    ; Str:'CO_E_SETSERLHNDLFAILED';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_FAILEDTOGETWINDIR                    ; Str:'CO_E_FAILEDTOGETWINDIR';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_PATHTOOLONG                          ; Str:'CO_E_PATHTOOLONG';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_FAILEDTOGENUUID                      ; Str:'CO_E_FAILEDTOGENUUID';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_FAILEDTOCREATEFILE                   ; Str:'CO_E_FAILEDTOCREATEFILE';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_FAILEDTOCLOSEHANDLE                  ; Str:'CO_E_FAILEDTOCLOSEHANDLE';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_EXCEEDSYSACLLIMIT                    ; Str:'CO_E_EXCEEDSYSACLLIMIT';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_ACESINWRONGORDER                     ; Str:'CO_E_ACESINWRONGORDER';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_INCOMPATIBLESTREAMVERSION            ; Str:'CO_E_INCOMPATIBLESTREAMVERSION';              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_FAILEDTOOPENPROCESSTOKEN             ; Str:'CO_E_FAILEDTOOPENPROCESSTOKEN';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_DECODEFAILED                         ; Str:'CO_E_DECODEFAILED';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_ACNOTINITIALIZED                     ; Str:'CO_E_ACNOTINITIALIZED';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_S_USEREG                              ; Str:'OLE_S_USEREG';                                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_S_STATIC                              ; Str:'OLE_S_STATIC';                                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLE_S_MAC_CLIPFORMAT                      ; Str:'OLE_S_MAC_CLIPFORMAT';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DRAGDROP_S_DROP                           ; Str:'DRAGDROP_S_DROP';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DRAGDROP_S_CANCEL                         ; Str:'DRAGDROP_S_CANCEL';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DRAGDROP_S_USEDEFAULTCURSORS              ; Str:'DRAGDROP_S_USEDEFAULTCURSORS';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DATA_S_SAMEFORMATETC                      ; Str:'DATA_S_SAMEFORMATETC';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: VIEW_S_ALREADY_FROZEN                     ; Str:'VIEW_S_ALREADY_FROZEN';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CACHE_S_FORMATETC_NOTSUPPORTED            ; Str:'CACHE_S_FORMATETC_NOTSUPPORTED';              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CACHE_S_SAMECACHE                         ; Str:'CACHE_S_SAMECACHE';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CACHE_S_SOMECACHES_NOTUPDATED             ; Str:'CACHE_S_SOMECACHES_NOTUPDATED';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLEOBJ_S_INVALIDVERB                      ; Str:'OLEOBJ_S_INVALIDVERB';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLEOBJ_S_CANNOT_DOVERB_NOW                ; Str:'OLEOBJ_S_CANNOT_DOVERB_NOW';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: OLEOBJ_S_INVALIDHWND                      ; Str:'OLEOBJ_S_INVALIDHWND';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: INPLACE_S_TRUNCATED                       ; Str:'INPLACE_S_TRUNCATED';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CONVERT10_S_NO_PRESENTATION               ; Str:'CONVERT10_S_NO_PRESENTATION';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_S_REDUCED_TO_SELF                      ; Str:'MK_S_REDUCED_TO_SELF';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_S_ME                                   ; Str:'MK_S_ME';                                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_S_HIM                                  ; Str:'MK_S_HIM';                                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_S_US                                   ; Str:'MK_S_US';                                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_S_MONIKERALREADYREGISTERED             ; Str:'MK_S_MONIKERALREADYREGISTERED';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_CLASS_CREATE_FAILED                  ; Str:'CO_E_CLASS_CREATE_FAILED';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_SCM_ERROR                            ; Str:'CO_E_SCM_ERROR';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_SCM_RPC_FAILURE                      ; Str:'CO_E_SCM_RPC_FAILURE';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_BAD_PATH                             ; Str:'CO_E_BAD_PATH';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_SERVER_EXEC_FAILURE                  ; Str:'CO_E_SERVER_EXEC_FAILURE';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_OBJSRV_RPC_FAILURE                   ; Str:'CO_E_OBJSRV_RPC_FAILURE';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MK_E_NO_NORMALIZED                        ; Str:'MK_E_NO_NORMALIZED';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_E_SERVER_STOPPING                      ; Str:'CO_E_SERVER_STOPPING';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MEM_E_INVALID_ROOT                        ; Str:'MEM_E_INVALID_ROOT';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MEM_E_INVALID_LINK                        ; Str:'MEM_E_INVALID_LINK';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: MEM_E_INVALID_SIZE                        ; Str:'MEM_E_INVALID_SIZE';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CO_S_NOTALLINTERFACES                     ; Str:'CO_S_NOTALLINTERFACES';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_UNKNOWNINTERFACE                   ; Str:'DISP_E_UNKNOWNINTERFACE';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_MEMBERNOTFOUND                     ; Str:'DISP_E_MEMBERNOTFOUND';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_PARAMNOTFOUND                      ; Str:'DISP_E_PARAMNOTFOUND';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_TYPEMISMATCH                       ; Str:'DISP_E_TYPEMISMATCH';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_UNKNOWNNAME                        ; Str:'DISP_E_UNKNOWNNAME';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_NONAMEDARGS                        ; Str:'DISP_E_NONAMEDARGS';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_BADVARTYPE                         ; Str:'DISP_E_BADVARTYPE';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_EXCEPTION                          ; Str:'DISP_E_EXCEPTION';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_OVERFLOW                           ; Str:'DISP_E_OVERFLOW';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_BADINDEX                           ; Str:'DISP_E_BADINDEX';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_UNKNOWNLCID                        ; Str:'DISP_E_UNKNOWNLCID';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_ARRAYISLOCKED                      ; Str:'DISP_E_ARRAYISLOCKED';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_BADPARAMCOUNT                      ; Str:'DISP_E_BADPARAMCOUNT';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_PARAMNOTOPTIONAL                   ; Str:'DISP_E_PARAMNOTOPTIONAL';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_BADCALLEE                          ; Str:'DISP_E_BADCALLEE';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_NOTACOLLECTION                     ; Str:'DISP_E_NOTACOLLECTION';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DISP_E_DIVBYZERO                          ; Str:'DISP_E_DIVBYZERO';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_BUFFERTOOSMALL                     ; Str:'TYPE_E_BUFFERTOOSMALL';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_FIELDNOTFOUND                      ; Str:'TYPE_E_FIELDNOTFOUND';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_INVDATAREAD                        ; Str:'TYPE_E_INVDATAREAD';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_UNSUPFORMAT                        ; Str:'TYPE_E_UNSUPFORMAT';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_REGISTRYACCESS                     ; Str:'TYPE_E_REGISTRYACCESS';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_LIBNOTREGISTERED                   ; Str:'TYPE_E_LIBNOTREGISTERED';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_UNDEFINEDTYPE                      ; Str:'TYPE_E_UNDEFINEDTYPE';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_QUALIFIEDNAMEDISALLOWED            ; Str:'TYPE_E_QUALIFIEDNAMEDISALLOWED';              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_INVALIDSTATE                       ; Str:'TYPE_E_INVALIDSTATE';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_WRONGTYPEKIND                      ; Str:'TYPE_E_WRONGTYPEKIND';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_ELEMENTNOTFOUND                    ; Str:'TYPE_E_ELEMENTNOTFOUND';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_AMBIGUOUSNAME                      ; Str:'TYPE_E_AMBIGUOUSNAME';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_NAMECONFLICT                       ; Str:'TYPE_E_NAMECONFLICT';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_UNKNOWNLCID                        ; Str:'TYPE_E_UNKNOWNLCID';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_DLLFUNCTIONNOTFOUND                ; Str:'TYPE_E_DLLFUNCTIONNOTFOUND';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_BADMODULEKIND                      ; Str:'TYPE_E_BADMODULEKIND';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_SIZETOOBIG                         ; Str:'TYPE_E_SIZETOOBIG';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_DUPLICATEID                        ; Str:'TYPE_E_DUPLICATEID';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_INVALIDID                          ; Str:'TYPE_E_INVALIDID';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_TYPEMISMATCH                       ; Str:'TYPE_E_TYPEMISMATCH';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_OUTOFBOUNDS                        ; Str:'TYPE_E_OUTOFBOUNDS';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_IOERROR                            ; Str:'TYPE_E_IOERROR';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_CANTCREATETMPFILE                  ; Str:'TYPE_E_CANTCREATETMPFILE';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_CANTLOADLIBRARY                    ; Str:'TYPE_E_CANTLOADLIBRARY';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_INCONSISTENTPROPFUNCS              ; Str:'TYPE_E_INCONSISTENTPROPFUNCS';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TYPE_E_CIRCULARTYPE                       ; Str:'TYPE_E_CIRCULARTYPE';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_INVALIDFUNCTION                     ; Str:'STG_E_INVALIDFUNCTION';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_FILENOTFOUND                        ; Str:'STG_E_FILENOTFOUND';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_PATHNOTFOUND                        ; Str:'STG_E_PATHNOTFOUND';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_TOOMANYOPENFILES                    ; Str:'STG_E_TOOMANYOPENFILES';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_ACCESSDENIED                        ; Str:'STG_E_ACCESSDENIED';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_INVALIDHANDLE                       ; Str:'STG_E_INVALIDHANDLE';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_INSUFFICIENTMEMORY                  ; Str:'STG_E_INSUFFICIENTMEMORY';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_INVALIDPOINTER                      ; Str:'STG_E_INVALIDPOINTER';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_NOMOREFILES                         ; Str:'STG_E_NOMOREFILES';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_DISKISWRITEPROTECTED                ; Str:'STG_E_DISKISWRITEPROTECTED';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_SEEKERROR                           ; Str:'STG_E_SEEKERROR';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_WRITEFAULT                          ; Str:'STG_E_WRITEFAULT';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_READFAULT                           ; Str:'STG_E_READFAULT';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_SHAREVIOLATION                      ; Str:'STG_E_SHAREVIOLATION';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_LOCKVIOLATION                       ; Str:'STG_E_LOCKVIOLATION';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_FILEALREADYEXISTS                   ; Str:'STG_E_FILEALREADYEXISTS';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_INVALIDPARAMETER                    ; Str:'STG_E_INVALIDPARAMETER';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_MEDIUMFULL                          ; Str:'STG_E_MEDIUMFULL';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_PROPSETMISMATCHED                   ; Str:'STG_E_PROPSETMISMATCHED';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_ABNORMALAPIEXIT                     ; Str:'STG_E_ABNORMALAPIEXIT';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_INVALIDHEADER                       ; Str:'STG_E_INVALIDHEADER';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_INVALIDNAME                         ; Str:'STG_E_INVALIDNAME';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_UNKNOWN                             ; Str:'STG_E_UNKNOWN';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_UNIMPLEMENTEDFUNCTION               ; Str:'STG_E_UNIMPLEMENTEDFUNCTION';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_INVALIDFLAG                         ; Str:'STG_E_INVALIDFLAG';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_INUSE                               ; Str:'STG_E_INUSE';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_NOTCURRENT                          ; Str:'STG_E_NOTCURRENT';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_REVERTED                            ; Str:'STG_E_REVERTED';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_CANTSAVE                            ; Str:'STG_E_CANTSAVE';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_OLDFORMAT                           ; Str:'STG_E_OLDFORMAT';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_OLDDLL                              ; Str:'STG_E_OLDDLL';                                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_SHAREREQUIRED                       ; Str:'STG_E_SHAREREQUIRED';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_NOTFILEBASEDSTORAGE                 ; Str:'STG_E_NOTFILEBASEDSTORAGE';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_EXTANTMARSHALLINGS                  ; Str:'STG_E_EXTANTMARSHALLINGS';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_DOCFILECORRUPT                      ; Str:'STG_E_DOCFILECORRUPT';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_BADBASEADDRESS                      ; Str:'STG_E_BADBASEADDRESS';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_INCOMPLETE                          ; Str:'STG_E_INCOMPLETE';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_E_TERMINATED                          ; Str:'STG_E_TERMINATED';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_S_CONVERTED                           ; Str:'STG_S_CONVERTED';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_S_BLOCK                               ; Str:'STG_S_BLOCK';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_S_RETRYNOW                            ; Str:'STG_S_RETRYNOW';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_S_MONITORING                          ; Str:'STG_S_MONITORING';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_S_MULTIPLEOPENS                       ; Str:'STG_S_MULTIPLEOPENS';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_S_CONSOLIDATIONFAILED                 ; Str:'STG_S_CONSOLIDATIONFAILED';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: STG_S_CANNOTCONSOLIDATE                   ; Str:'STG_S_CANNOTCONSOLIDATE';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CALL_REJECTED                       ; Str:'RPC_E_CALL_REJECTED';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CALL_CANCELED                       ; Str:'RPC_E_CALL_CANCELED';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CANTPOST_INSENDCALL                 ; Str:'RPC_E_CANTPOST_INSENDCALL';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CANTCALLOUT_INASYNCCALL             ; Str:'RPC_E_CANTCALLOUT_INASYNCCALL';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CANTCALLOUT_INEXTERNALCALL          ; Str:'RPC_E_CANTCALLOUT_INEXTERNALCALL';            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CONNECTION_TERMINATED               ; Str:'RPC_E_CONNECTION_TERMINATED';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_SERVER_DIED                         ; Str:'RPC_E_SERVER_DIED';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CLIENT_DIED                         ; Str:'RPC_E_CLIENT_DIED';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_INVALID_DATAPACKET                  ; Str:'RPC_E_INVALID_DATAPACKET';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CANTTRANSMIT_CALL                   ; Str:'RPC_E_CANTTRANSMIT_CALL';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CLIENT_CANTMARSHAL_DATA             ; Str:'RPC_E_CLIENT_CANTMARSHAL_DATA';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CLIENT_CANTUNMARSHAL_DATA           ; Str:'RPC_E_CLIENT_CANTUNMARSHAL_DATA';             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_SERVER_CANTMARSHAL_DATA             ; Str:'RPC_E_SERVER_CANTMARSHAL_DATA';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_SERVER_CANTUNMARSHAL_DATA           ; Str:'RPC_E_SERVER_CANTUNMARSHAL_DATA';             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_INVALID_DATA                        ; Str:'RPC_E_INVALID_DATA';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_INVALID_PARAMETER                   ; Str:'RPC_E_INVALID_PARAMETER';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CANTCALLOUT_AGAIN                   ; Str:'RPC_E_CANTCALLOUT_AGAIN';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_SERVER_DIED_DNE                     ; Str:'RPC_E_SERVER_DIED_DNE';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_SYS_CALL_FAILED                     ; Str:'RPC_E_SYS_CALL_FAILED';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_OUT_OF_RESOURCES                    ; Str:'RPC_E_OUT_OF_RESOURCES';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_ATTEMPTED_MULTITHREAD               ; Str:'RPC_E_ATTEMPTED_MULTITHREAD';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_NOT_REGISTERED                      ; Str:'RPC_E_NOT_REGISTERED';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_FAULT                               ; Str:'RPC_E_FAULT';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_SERVERFAULT                         ; Str:'RPC_E_SERVERFAULT';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CHANGED_MODE                        ; Str:'RPC_E_CHANGED_MODE';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_INVALIDMETHOD                       ; Str:'RPC_E_INVALIDMETHOD';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_DISCONNECTED                        ; Str:'RPC_E_DISCONNECTED';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_RETRY                               ; Str:'RPC_E_RETRY';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_SERVERCALL_RETRYLATER               ; Str:'RPC_E_SERVERCALL_RETRYLATER';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_SERVERCALL_REJECTED                 ; Str:'RPC_E_SERVERCALL_REJECTED';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_INVALID_CALLDATA                    ; Str:'RPC_E_INVALID_CALLDATA';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CANTCALLOUT_ININPUTSYNCCALL         ; Str:'RPC_E_CANTCALLOUT_ININPUTSYNCCALL';           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_WRONG_THREAD                        ; Str:'RPC_E_WRONG_THREAD';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_THREAD_NOT_INIT                     ; Str:'RPC_E_THREAD_NOT_INIT';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_VERSION_MISMATCH                    ; Str:'RPC_E_VERSION_MISMATCH';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_INVALID_HEADER                      ; Str:'RPC_E_INVALID_HEADER';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_INVALID_EXTENSION                   ; Str:'RPC_E_INVALID_EXTENSION';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_INVALID_IPID                        ; Str:'RPC_E_INVALID_IPID';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_INVALID_OBJECT                      ; Str:'RPC_E_INVALID_OBJECT';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_S_CALLPENDING                         ; Str:'RPC_S_CALLPENDING';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_S_WAITONTIMER                         ; Str:'RPC_S_WAITONTIMER';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_CALL_COMPLETE                       ; Str:'RPC_E_CALL_COMPLETE';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_UNSECURE_CALL                       ; Str:'RPC_E_UNSECURE_CALL';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_TOO_LATE                            ; Str:'RPC_E_TOO_LATE';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_NO_GOOD_SECURITY_PACKAGES           ; Str:'RPC_E_NO_GOOD_SECURITY_PACKAGES';             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_ACCESS_DENIED                       ; Str:'RPC_E_ACCESS_DENIED';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_REMOTE_DISABLED                     ; Str:'RPC_E_REMOTE_DISABLED';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_INVALID_OBJREF                      ; Str:'RPC_E_INVALID_OBJREF';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_NO_CONTEXT                          ; Str:'RPC_E_NO_CONTEXT';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_TIMEOUT                             ; Str:'RPC_E_TIMEOUT';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_NO_SYNC                             ; Str:'RPC_E_NO_SYNC';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: RPC_E_UNEXPECTED                          ; Str:'RPC_E_UNEXPECTED';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_UID                               ; Str:'NTE_BAD_UID';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_HASH                              ; Str:'NTE_BAD_HASH';                                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_KEY                               ; Str:'NTE_BAD_KEY';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_LEN                               ; Str:'NTE_BAD_LEN';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_DATA                              ; Str:'NTE_BAD_DATA';                                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_SIGNATURE                         ; Str:'NTE_BAD_SIGNATURE';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_VER                               ; Str:'NTE_BAD_VER';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_ALGID                             ; Str:'NTE_BAD_ALGID';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_FLAGS                             ; Str:'NTE_BAD_FLAGS';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_TYPE                              ; Str:'NTE_BAD_TYPE';                                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_KEY_STATE                         ; Str:'NTE_BAD_KEY_STATE';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_HASH_STATE                        ; Str:'NTE_BAD_HASH_STATE';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_NO_KEY                                ; Str:'NTE_NO_KEY';                                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_NO_MEMORY                             ; Str:'NTE_NO_MEMORY';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_EXISTS                                ; Str:'NTE_EXISTS';                                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_PERM                                  ; Str:'NTE_PERM';                                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_NOT_FOUND                             ; Str:'NTE_NOT_FOUND';                               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_DOUBLE_ENCRYPT                        ; Str:'NTE_DOUBLE_ENCRYPT';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_PROVIDER                          ; Str:'NTE_BAD_PROVIDER';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_PROV_TYPE                         ; Str:'NTE_BAD_PROV_TYPE';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_PUBLIC_KEY                        ; Str:'NTE_BAD_PUBLIC_KEY';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_KEYSET                            ; Str:'NTE_BAD_KEYSET';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_PROV_TYPE_NOT_DEF                     ; Str:'NTE_PROV_TYPE_NOT_DEF';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_PROV_TYPE_ENTRY_BAD                   ; Str:'NTE_PROV_TYPE_ENTRY_BAD';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_KEYSET_NOT_DEF                        ; Str:'NTE_KEYSET_NOT_DEF';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_KEYSET_ENTRY_BAD                      ; Str:'NTE_KEYSET_ENTRY_BAD';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_PROV_TYPE_NO_MATCH                    ; Str:'NTE_PROV_TYPE_NO_MATCH';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_SIGNATURE_FILE_BAD                    ; Str:'NTE_SIGNATURE_FILE_BAD';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_PROVIDER_DLL_FAIL                     ; Str:'NTE_PROVIDER_DLL_FAIL';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_PROV_DLL_NOT_FOUND                    ; Str:'NTE_PROV_DLL_NOT_FOUND';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_BAD_KEYSET_PARAM                      ; Str:'NTE_BAD_KEYSET_PARAM';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_FAIL                                  ; Str:'NTE_FAIL';                                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: NTE_SYS_ERR                               ; Str:'NTE_SYS_ERR';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_MSG_ERROR                         ; Str:'CRYPT_E_MSG_ERROR';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_UNKNOWN_ALGO                      ; Str:'CRYPT_E_UNKNOWN_ALGO';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_OID_FORMAT                        ; Str:'CRYPT_E_OID_FORMAT';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_INVALID_MSG_TYPE                  ; Str:'CRYPT_E_INVALID_MSG_TYPE';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_UNEXPECTED_ENCODING               ; Str:'CRYPT_E_UNEXPECTED_ENCODING';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_AUTH_ATTR_MISSING                 ; Str:'CRYPT_E_AUTH_ATTR_MISSING';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_HASH_VALUE                        ; Str:'CRYPT_E_HASH_VALUE';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_INVALID_INDEX                     ; Str:'CRYPT_E_INVALID_INDEX';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_ALREADY_DECRYPTED                 ; Str:'CRYPT_E_ALREADY_DECRYPTED';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NOT_DECRYPTED                     ; Str:'CRYPT_E_NOT_DECRYPTED';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_RECIPIENT_NOT_FOUND               ; Str:'CRYPT_E_RECIPIENT_NOT_FOUND';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_CONTROL_TYPE                      ; Str:'CRYPT_E_CONTROL_TYPE';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_ISSUER_SERIALNUMBER               ; Str:'CRYPT_E_ISSUER_SERIALNUMBER';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_SIGNER_NOT_FOUND                  ; Str:'CRYPT_E_SIGNER_NOT_FOUND';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_ATTRIBUTES_MISSING                ; Str:'CRYPT_E_ATTRIBUTES_MISSING';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_STREAM_MSG_NOT_READY              ; Str:'CRYPT_E_STREAM_MSG_NOT_READY';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_STREAM_INSUFFICIENT_DATA          ; Str:'CRYPT_E_STREAM_INSUFFICIENT_DATA';            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_BAD_LEN                           ; Str:'CRYPT_E_BAD_LEN';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_BAD_ENCODE                        ; Str:'CRYPT_E_BAD_ENCODE';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_FILE_ERROR                        ; Str:'CRYPT_E_FILE_ERROR';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NOT_FOUND                         ; Str:'CRYPT_E_NOT_FOUND';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_EXISTS                            ; Str:'CRYPT_E_EXISTS';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NO_PROVIDER                       ; Str:'CRYPT_E_NO_PROVIDER';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_SELF_SIGNED                       ; Str:'CRYPT_E_SELF_SIGNED';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_DELETED_PREV                      ; Str:'CRYPT_E_DELETED_PREV';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NO_MATCH                          ; Str:'CRYPT_E_NO_MATCH';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_UNEXPECTED_MSG_TYPE               ; Str:'CRYPT_E_UNEXPECTED_MSG_TYPE';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NO_KEY_PROPERTY                   ; Str:'CRYPT_E_NO_KEY_PROPERTY';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NO_DECRYPT_CERT                   ; Str:'CRYPT_E_NO_DECRYPT_CERT';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_BAD_MSG                           ; Str:'CRYPT_E_BAD_MSG';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NO_SIGNER                         ; Str:'CRYPT_E_NO_SIGNER';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_PENDING_CLOSE                     ; Str:'CRYPT_E_PENDING_CLOSE';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_REVOKED                           ; Str:'CRYPT_E_REVOKED';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NO_REVOCATION_DLL                 ; Str:'CRYPT_E_NO_REVOCATION_DLL';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NO_REVOCATION_CHECK               ; Str:'CRYPT_E_NO_REVOCATION_CHECK';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_REVOCATION_OFFLINE                ; Str:'CRYPT_E_REVOCATION_OFFLINE';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NOT_IN_REVOCATION_DATABASE        ; Str:'CRYPT_E_NOT_IN_REVOCATION_DATABASE';          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_INVALID_NUMERIC_STRING            ; Str:'CRYPT_E_INVALID_NUMERIC_STRING';              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_INVALID_PRINTABLE_STRING          ; Str:'CRYPT_E_INVALID_PRINTABLE_STRING';            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_INVALID_IA5_STRING                ; Str:'CRYPT_E_INVALID_IA5_STRING';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_INVALID_X500_STRING               ; Str:'CRYPT_E_INVALID_X500_STRING';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NOT_CHAR_STRING                   ; Str:'CRYPT_E_NOT_CHAR_STRING';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_FILERESIZED                       ; Str:'CRYPT_E_FILERESIZED';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_SECURITY_SETTINGS                 ; Str:'CRYPT_E_SECURITY_SETTINGS';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NO_VERIFY_USAGE_DLL               ; Str:'CRYPT_E_NO_VERIFY_USAGE_DLL';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NO_VERIFY_USAGE_CHECK             ; Str:'CRYPT_E_NO_VERIFY_USAGE_CHECK';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_VERIFY_USAGE_OFFLINE              ; Str:'CRYPT_E_VERIFY_USAGE_OFFLINE';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NOT_IN_CTL                        ; Str:'CRYPT_E_NOT_IN_CTL';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_NO_TRUSTED_SIGNER                 ; Str:'CRYPT_E_NO_TRUSTED_SIGNER';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CRYPT_E_OSS_ERROR                         ; Str:'CRYPT_E_OSS_ERROR';                           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERTSRV_E_BAD_REQUESTSUBJECT              ; Str:'CERTSRV_E_BAD_REQUESTSUBJECT';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERTSRV_E_NO_REQUEST                      ; Str:'CERTSRV_E_NO_REQUEST';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERTSRV_E_BAD_REQUESTSTATUS               ; Str:'CERTSRV_E_BAD_REQUESTSTATUS';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERTSRV_E_PROPERTY_EMPTY                  ; Str:'CERTSRV_E_PROPERTY_EMPTY';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERTDB_E_JET_ERROR                        ; Str:'CERTDB_E_JET_ERROR';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_SYSTEM_ERROR                      ; Str:'TRUST_E_SYSTEM_ERROR';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_NO_SIGNER_CERT                    ; Str:'TRUST_E_NO_SIGNER_CERT';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_COUNTER_SIGNER                    ; Str:'TRUST_E_COUNTER_SIGNER';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_CERT_SIGNATURE                    ; Str:'TRUST_E_CERT_SIGNATURE';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_TIME_STAMP                        ; Str:'TRUST_E_TIME_STAMP';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_BAD_DIGEST                        ; Str:'TRUST_E_BAD_DIGEST';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_BASIC_CONSTRAINTS                 ; Str:'TRUST_E_BASIC_CONSTRAINTS';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_FINANCIAL_CRITERIA                ; Str:'TRUST_E_FINANCIAL_CRITERIA';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_PROVIDER_UNKNOWN                  ; Str:'TRUST_E_PROVIDER_UNKNOWN';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_ACTION_UNKNOWN                    ; Str:'TRUST_E_ACTION_UNKNOWN';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_SUBJECT_FORM_UNKNOWN              ; Str:'TRUST_E_SUBJECT_FORM_UNKNOWN';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_SUBJECT_NOT_TRUSTED               ; Str:'TRUST_E_SUBJECT_NOT_TRUSTED';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DIGSIG_E_ENCODE                           ; Str:'DIGSIG_E_ENCODE';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DIGSIG_E_DECODE                           ; Str:'DIGSIG_E_DECODE';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DIGSIG_E_EXTENSIBILITY                    ; Str:'DIGSIG_E_EXTENSIBILITY';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: DIGSIG_E_CRYPTO                           ; Str:'DIGSIG_E_CRYPTO';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: PERSIST_E_SIZEDEFINITE                    ; Str:'PERSIST_E_SIZEDEFINITE';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: PERSIST_E_SIZEINDEFINITE                  ; Str:'PERSIST_E_SIZEINDEFINITE';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: PERSIST_E_NOTSELFSIZING                   ; Str:'PERSIST_E_NOTSELFSIZING';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_NOSIGNATURE                       ; Str:'TRUST_E_NOSIGNATURE';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_EXPIRED                            ; Str:'CERT_E_EXPIRED';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_VALIDITYPERIODNESTING              ; Str:'CERT_E_VALIDITYPERIODNESTING';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_ROLE                               ; Str:'CERT_E_ROLE';                                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_PATHLENCONST                       ; Str:'CERT_E_PATHLENCONST';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_CRITICAL                           ; Str:'CERT_E_CRITICAL';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_PURPOSE                            ; Str:'CERT_E_PURPOSE';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_ISSUERCHAINING                     ; Str:'CERT_E_ISSUERCHAINING';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_MALFORMED                          ; Str:'CERT_E_MALFORMED';                            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_UNTRUSTEDROOT                      ; Str:'CERT_E_UNTRUSTEDROOT';                        MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_CHAINING                           ; Str:'CERT_E_CHAINING';                             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: TRUST_E_FAIL                              ; Str:'TRUST_E_FAIL';                                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_REVOKED                            ; Str:'CERT_E_REVOKED';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_UNTRUSTEDTESTROOT                  ; Str:'CERT_E_UNTRUSTEDTESTROOT';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_REVOCATION_FAILURE                 ; Str:'CERT_E_REVOCATION_FAILURE';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_CN_NO_MATCH                        ; Str:'CERT_E_CN_NO_MATCH';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: CERT_E_WRONG_USAGE                        ; Str:'CERT_E_WRONG_USAGE';                          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_EXPECTED_SECTION_NAME             ; Str:'SPAPI_E_EXPECTED_SECTION_NAME';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_BAD_SECTION_NAME_LINE             ; Str:'SPAPI_E_BAD_SECTION_NAME_LINE';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_SECTION_NAME_TOO_LONG             ; Str:'SPAPI_E_SECTION_NAME_TOO_LONG';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_GENERAL_SYNTAX                    ; Str:'SPAPI_E_GENERAL_SYNTAX';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_WRONG_INF_STYLE                   ; Str:'SPAPI_E_WRONG_INF_STYLE';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_SECTION_NOT_FOUND                 ; Str:'SPAPI_E_SECTION_NOT_FOUND';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_LINE_NOT_FOUND                    ; Str:'SPAPI_E_LINE_NOT_FOUND';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_ASSOCIATED_CLASS               ; Str:'SPAPI_E_NO_ASSOCIATED_CLASS';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_CLASS_MISMATCH                    ; Str:'SPAPI_E_CLASS_MISMATCH';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DUPLICATE_FOUND                   ; Str:'SPAPI_E_DUPLICATE_FOUND';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_DRIVER_SELECTED                ; Str:'SPAPI_E_NO_DRIVER_SELECTED';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_KEY_DOES_NOT_EXIST                ; Str:'SPAPI_E_KEY_DOES_NOT_EXIST';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_INVALID_DEVINST_NAME              ; Str:'SPAPI_E_INVALID_DEVINST_NAME';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_INVALID_CLASS                     ; Str:'SPAPI_E_INVALID_CLASS';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DEVINST_ALREADY_EXISTS            ; Str:'SPAPI_E_DEVINST_ALREADY_EXISTS';              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DEVINFO_NOT_REGISTERED            ; Str:'SPAPI_E_DEVINFO_NOT_REGISTERED';              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_INVALID_REG_PROPERTY              ; Str:'SPAPI_E_INVALID_REG_PROPERTY';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_INF                            ; Str:'SPAPI_E_NO_INF';                              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_SUCH_DEVINST                   ; Str:'SPAPI_E_NO_SUCH_DEVINST';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_CANT_LOAD_CLASS_ICON              ; Str:'SPAPI_E_CANT_LOAD_CLASS_ICON';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_INVALID_CLASS_INSTALLER           ; Str:'SPAPI_E_INVALID_CLASS_INSTALLER';             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DI_DO_DEFAULT                     ; Str:'SPAPI_E_DI_DO_DEFAULT';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DI_NOFILECOPY                     ; Str:'SPAPI_E_DI_NOFILECOPY';                       MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_INVALID_HWPROFILE                 ; Str:'SPAPI_E_INVALID_HWPROFILE';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_DEVICE_SELECTED                ; Str:'SPAPI_E_NO_DEVICE_SELECTED';                  MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DEVINFO_LIST_LOCKED               ; Str:'SPAPI_E_DEVINFO_LIST_LOCKED';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DEVINFO_DATA_LOCKED               ; Str:'SPAPI_E_DEVINFO_DATA_LOCKED';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DI_BAD_PATH                       ; Str:'SPAPI_E_DI_BAD_PATH';                         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_CLASSINSTALL_PARAMS            ; Str:'SPAPI_E_NO_CLASSINSTALL_PARAMS';              MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_FILEQUEUE_LOCKED                  ; Str:'SPAPI_E_FILEQUEUE_LOCKED';                    MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_BAD_SERVICE_INSTALLSECT           ; Str:'SPAPI_E_BAD_SERVICE_INSTALLSECT';             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_CLASS_DRIVER_LIST              ; Str:'SPAPI_E_NO_CLASS_DRIVER_LIST';                MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_ASSOCIATED_SERVICE             ; Str:'SPAPI_E_NO_ASSOCIATED_SERVICE';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_DEFAULT_DEVICE_INTERFACE       ; Str:'SPAPI_E_NO_DEFAULT_DEVICE_INTERFACE';         MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DEVICE_INTERFACE_ACTIVE           ; Str:'SPAPI_E_DEVICE_INTERFACE_ACTIVE';             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DEVICE_INTERFACE_REMOVED          ; Str:'SPAPI_E_DEVICE_INTERFACE_REMOVED';            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_BAD_INTERFACE_INSTALLSECT         ; Str:'SPAPI_E_BAD_INTERFACE_INSTALLSECT';           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_SUCH_INTERFACE_CLASS           ; Str:'SPAPI_E_NO_SUCH_INTERFACE_CLASS';             MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_INVALID_REFERENCE_STRING          ; Str:'SPAPI_E_INVALID_REFERENCE_STRING';            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_INVALID_MACHINENAME               ; Str:'SPAPI_E_INVALID_MACHINENAME';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_REMOTE_COMM_FAILURE               ; Str:'SPAPI_E_REMOTE_COMM_FAILURE';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_MACHINE_UNAVAILABLE               ; Str:'SPAPI_E_MACHINE_UNAVAILABLE';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_CONFIGMGR_SERVICES             ; Str:'SPAPI_E_NO_CONFIGMGR_SERVICES';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_INVALID_PROPPAGE_PROVIDER         ; Str:'SPAPI_E_INVALID_PROPPAGE_PROVIDER';           MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_SUCH_DEVICE_INTERFACE          ; Str:'SPAPI_E_NO_SUCH_DEVICE_INTERFACE';            MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DI_POSTPROCESSING_REQUIREd        ; Str:'SPAPI_E_DI_POSTPROCESSING_REQUIREd';          MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_INVALID_COINSTALLER               ; Str:'SPAPI_E_INVALID_COINSTALLER';                 MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_COMPAT_DRIVERS                 ; Str:'SPAPI_E_NO_COMPAT_DRIVERS';                   MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_NO_DEVICE_ICON                    ; Str:'SPAPI_E_NO_DEVICE_ICON';                      MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_INVALID_INF_LOGCONFIG             ; Str:'SPAPI_E_INVALID_INF_LOGCONFIG';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_DI_DONT_INSTALL                   ; Str:'SPAPI_E_DI_DONT_INSTALL';                     MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_INVALID_FILTER_DRIVER             ; Str:'SPAPI_E_INVALID_FILTER_DRIVER';               MappedException: E_OPERATING_SYSTEM_ERROR ),
  (Code: SPAPI_E_ERROR_NOT_INSTALLED               ; Str:'SPAPI_E_ERROR_NOT_INSTALLED';                 MappedException: E_OPERATING_SYSTEM_ERROR )
 );

function GetStringFromErrorCode(const ErrorCode: HResult): String;

implementation


function GetStringFromErrorCode(const ErrorCode: HResult): String;
////////////////////////////////////////////////////////////////////////////////
// Description:  Return the error string (standard or phi) for the ErrorCode.
// Inputs:       ErrorCode - ErrorCode of interest.
// Outputs:      Returns the error code description string, or a blank string if
//                 the error code is not found.
// Exceptions:
// Note:
////////////////////////////////////////////////////////////////////////////////
var
  codeIx: Integer;
begin
  Result := '';
  try
    //Look for the standard error string
    for codeIx := Low(StandardErrorCodeArray) to High(StandardErrorCodeArray) do
      if StandardErrorCodeArray[codeIx].Code = ErrorCode then
      begin
        Result := StandardErrorCodeArray[codeIx].Str;
        Exit;
      end;
    //Look for the phi error string
    for codeIx := Low(ErrorCodeArray) to High(ErrorCodeArray) do
      if ErrorCodeArray[codeIx].Code = ErrorCode then
      begin
        Result := ErrorCodeArray[codeIx].Str;
        Exit;
      end;
  except //Swallow exceptions related to obtaining an error code string
    Result := '';
  end;
end;

end.
