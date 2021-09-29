unit CommStatsCircularBuffer;

interface

uses
  CircularBuffer;

type

  TCommStatsDataPacket = record
    DeviceID: Integer;
    TimeStamp: TDateTime;
    RequestCount: Integer;
    LockObtainedCount: Integer;
    UnableToGetLockCount: Integer;
    WaitingForLockTimeInMSec: Integer;
    ChannelActiveTimeInMSec: Integer;
  end;

  TCommStatsCircularBuffer = class(TThreadSafeCircularBuffer)

    procedure AddCommStatsPacket(CommStatsDataPacket: TCommStatsDataPacket);

    function GetCommStatsPacket(var CommStatsDataPacket: TCommStatsDataPacket): boolean;
  end;

var
  g_CommStatsCircularBuffer: TCommStatsCircularBuffer = nil;

implementation

// AddCommStatsPacket - Called from Comm Stats doc.
procedure TCommStatsCircularBuffer.AddCommStatsPacket(CommStatsDataPacket: TCommStatsDataPacket);
var
  packetSize: Integer;
begin
  // Add the packet to the Comm Stats circular buffer.
  packetSize := SizeOf(commStatsDataPacket);
  Write(commStatsDataPacket, packetSize);
end;

// GetCommStatsPacket - Called from PhiDatabaseManager.
function TCommStatsCircularBuffer.GetCommStatsPacket(var CommStatsDataPacket: TCommStatsDataPacket): boolean;
var
  packetSize: Integer;
  bytesRead: Integer;
  packetRead: boolean;
begin
    // Read a packet of data from the buffer. If no data is available on the
    // circular buffer, the bytesRead value will be 0.
    packetSize := SizeOf(commStatsDataPacket);
    bytesRead := Read(commStatsDataPacket, packetSize);

    // Check if data was read from the circular buffer.
    if bytesRead = packetSize then
      packetRead := true
    else
      packetRead := false;

    Result := packetRead;
end;

end.
