unit HistDataCircularBuffer;

interface

uses
  CircularBuffer;

type

  THistDataDataPacket = record
    ParameterID: Integer;
    DataValue: Double;
    TimeStamp: TDateTime;
    ValidData: Boolean;
  end;

  THistDataCircularBuffer = class(TThreadSafeCircularBuffer)

    procedure AddHistDataPacket(HistDataDataPacket: THistDataDataPacket);

    function GetHistDataPacket(var HistDataDataPacket: THistDataDataPacket): boolean;
  end;

var
  g_HistDataCircularBuffer: THistDataCircularBuffer = nil;

implementation

// AddHistDataPacket - Called from TParameterHistory
procedure THistDataCircularBuffer.AddHistDataPacket(HistDataDataPacket: THistDataDataPacket);
begin
  // Add the packet to the historical data circular buffer.
  Write(histDataDataPacket, SizeOf(histDataDataPacket));
end;

// GetHistDataPacket - Called from PhiDatabaseManager.
function THistDataCircularBuffer.GetHistDataPacket(var HistDataDataPacket: THistDataDataPacket): boolean;
var
  bytesRead: Integer;
  packetRead: boolean;
begin
    // Read a packet of data from the buffer. If no data is available on the
    // circular buffer, the bytesRead value will be 0.
    bytesRead := Read(histDataDataPacket, SizeOf(histDataDataPacket));

    // Check if data was read from the circular buffer.
    if bytesRead = SizeOf(histDataDataPacket) then
      packetRead := true
    else
      packetRead := false;

    Result := packetRead;
end;

end.
