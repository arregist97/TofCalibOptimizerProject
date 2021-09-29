unit CircularBuffer;

interface

uses
  Windows, Classes;

type

////////////////////////////////////////////////////////////////////////////////
///  TCircularBuffer Class
////////////////////////////////////////////////////////////////////////////////
  TCircularBuffer = class
  private
    FMemoryStream: TMemoryStream;
    FUserData: Pointer;
    function GetMemory: Pointer;
  protected
    FReadPosition: Integer;
    FWritePosition: Integer;
    FCanReadCount: Integer;
    FCanWriteCount: Integer;
  public
    constructor Create(const BuffSize: Integer); virtual;
    destructor Destroy(); override;
    function Write(const Buffer; Count: Integer): Integer; virtual;
    function Read(var Buffer; Count: Integer): Integer; virtual;
  public
    property ReadPosition: Integer read FReadPosition;
    property WritePosition: Integer read FWritePosition;
    property CanReadCount: Integer read FCanReadCount;
    property CanWriteCount: Integer read FCanWriteCount;
    property Memory: Pointer read GetMemory;
    property UserData: Pointer read FUserData write FUserData;
  end;

////////////////////////////////////////////////////////////////////////////////
///  TThreadSafeCircularBuffer Class
////////////////////////////////////////////////////////////////////////////////
  TThreadSafeCircularBuffer = class(TCircularBuffer)
  private
    FCriticalSection: TRTLCriticalSection;
    function GetReadPosition(): Integer;
    function GetWritePosition(): Integer;
    function GetCanReadCount(): Integer;
    function GetCanWriteCount(): Integer;
  public
    constructor Create(const BuffSize: Integer); override;
    destructor Destroy(); override;
    function Write(const Buffer; Count: Integer): Integer; override;
    function Read(var Buffer; Count: Integer): Integer; override;
  public
    property ReadPosition: Integer read GetReadPosition;
    property WritePosition: Integer read GetWritePosition;
    property CanReadCount: Integer read GetCanReadCount;
    property CanWriteCount: Integer read GetCanWriteCount;
  end;

implementation

////////////////////////////////////////////////////////////////////////////////
///  TCircularBuffer
////////////////////////////////////////////////////////////////////////////////

// Constructor
constructor TCircularBuffer.Create(const BuffSize: Integer);
begin
  FMemoryStream := TMemoryStream.Create();
  FMemoryStream.Size := BuffSize;
  FMemoryStream.Position := 0;
  FWritePosition := 0;
  FReadPosition := 0;
  FCanWriteCount := BuffSize;
  FCanReadCount := 0;
  // \\
  ZeroMemory(FMemoryStream.Memory, FMemoryStream.Size);
end;

// Destructor
destructor TCircularBuffer.Destroy;
begin
  inherited;
  FMemoryStream.Free();
end;

// GetMemory
function TCircularBuffer.GetMemory: Pointer;
begin
  Result := FMemoryStream.Memory;
end;

// Read
function TCircularBuffer.Read(var Buffer; Count: Integer): Integer;
var
  P: PAnsiChar;
  Len, DataLen: Integer;
begin
  Result := 0;
  // (I)
  if FCanReadCount <= 0 then
  begin
    Exit;
  end;

  if Count > FCanReadCount then
    DataLen := FCanReadCount
  else
    DataLen := Count;

  FMemoryStream.Position := FReadPosition mod FMemoryStream.Size;
  Result := FMemoryStream.Read(Buffer, DataLen);
  Dec(FCanReadCount, Result);
  Dec(Count, Result);

  // (II)
  if (Count > 0) and (FCanReadCount > 0) then // Continue reading
  begin
    DataLen := Count;
    if DataLen > FCanReadCount then
      DataLen := FCanReadCount;
    FMemoryStream.Position := 0;
    P := @Buffer;
    Inc(P, Result);
    Len := FMemoryStream.Read(P^, DataLen);
    Inc(Result, Len);
    Dec(FCanReadCount, Len);
  end;

  // Increasing the number of bytes written
  Inc(FCanWriteCount, Result);
  if FCanWriteCount > FMemoryStream.Size then
    FCanWriteCount := FMemoryStream.Size;

  // Adjust the read pointer position
  Inc(FReadPosition, Result);
  if FReadPosition > FMemoryStream.Size then
    Dec(FReadPosition, FMemoryStream.Size);

end;

// Write
function TCircularBuffer.Write(const Buffer; Count: Integer): Integer;
var
  Len, DataLen: Integer;
  P: PAnsiChar;
begin
  Result := 0;
  // (I)
  if FCanWriteCount <= 0 then
  begin
    Exit;
  end;

  if Count > FCanWriteCount then
    DataLen := FCanWriteCount
  else
    DataLen := Count;
  FMemoryStream.Position := FWritePosition mod FMemoryStream.Size;
  Result := FMemoryStream.Write(Buffer, DataLen);
  P := FMemoryStream.Memory;
  if P = nil then
    Exit;
  Dec(Count, Result);
  Dec(FCanWriteCount, Result);
  if (Count > 0) and (FCanWriteCount > 0) then
  begin
    // (II)
    P := @Buffer;
    Inc(P, Result);
    Len := FReadPosition - 0;
    if Count > Len then
      DataLen := Len
    else
      DataLen := Count;
    FMemoryStream.Position := 0;
    Len := FMemoryStream.Write(P^, DataLen);
    Inc(Result, Len);
    Dec(FCanWriteCount, Len);
  end;

  // Increase the number of bytes read
  Inc(FCanReadCount, Result);
  if FCanReadCount > FMemoryStream.Size then
    FCanReadCount := FMemoryStream.Size;

  // Adjust the position of the write pointer
  Inc(FWritePosition, Result);
  if FWritePosition > FMemoryStream.Size then
    FWritePosition := FWritePosition - FMemoryStream.Size;
end;

////////////////////////////////////////////////////////////////////////////////
///  TThreadSafeCircularBuffer
////////////////////////////////////////////////////////////////////////////////

// Constructor
constructor TThreadSafeCircularBuffer.Create(const BuffSize: Integer);
begin
  InitializeCriticalSection(FCriticalSection); // Initialization
  inherited Create(BuffSize);
end;

// Destructor
destructor TThreadSafeCircularBuffer.Destroy;
begin
  DeleteCriticalSection(FCriticalSection);
  inherited;
end;

// GetCanReadCount
function TThreadSafeCircularBuffer.GetCanReadCount: Integer;
begin
  EnterCriticalSection(FCriticalSection);
  Result := FCanReadCount;
  LeaveCriticalSection(FCriticalSection);
end;

// GetCanWriteCount
function TThreadSafeCircularBuffer.GetCanWriteCount: Integer;
begin
  EnterCriticalSection(FCriticalSection);
  Result := FCanWriteCount;
  LeaveCriticalSection(FCriticalSection);
end;

// GetReadPosition
function TThreadSafeCircularBuffer.GetReadPosition: Integer;
begin
  EnterCriticalSection(FCriticalSection);
  Result := FReadPosition;
  LeaveCriticalSection(FCriticalSection);
end;

// GetWritePosition
function TThreadSafeCircularBuffer.GetWritePosition: Integer;
begin
  EnterCriticalSection(FCriticalSection);
  Result := FWritePosition;
  LeaveCriticalSection(FCriticalSection);
end;

// Read
function TThreadSafeCircularBuffer.Read(var Buffer; Count: Integer): Integer;
begin
  EnterCriticalSection(FCriticalSection);
  try
    Result := inherited read(Buffer, Count);
  finally
    LeaveCriticalSection(FCriticalSection);
  end;
end;

// Write
function TThreadSafeCircularBuffer.Write(const Buffer; Count: Integer): Integer;
begin
  EnterCriticalSection(FCriticalSection);
  try
    Result := inherited Write(Buffer, Count);
  finally
    LeaveCriticalSection(FCriticalSection);
  end;
end;

end.
