unit EventLogCircularBuffer;

interface

uses
  CircularBuffer;

type
  TEventLogDataPacket = record
    MsgTypeID: Integer;
    MsgObjectID: Integer;
    TimeStamp: Double;
    EventMsgText: Array[0..255] of Char;
    EventMsgLength: Integer;
  end;

  TEventLogCircularBuffer = class(TThreadSafeCircularBuffer)

  public
    procedure AddEventLogPacket(EventLogDataPacket: TEventLogDataPacket);

    function GetEventLogPacket(var EventLogDataPacket: TEventLogDataPacket): boolean;
  end;

var
  g_EventLogCircularBuffer: TEventLogCircularBuffer = nil;

implementation

// AddEventLogPacket - Called from TParameterLog
procedure TEventLogCircularBuffer.AddEventLogPacket(EventLogDataPacket: TEventLogDataPacket);
begin
  // Add the packet to the event log circular buffer.
  Write(eventLogDataPacket, SizeOf(eventLogDataPacket));
end;

// GetEventLogPacket - Called from PhiDatabaseManager.
function TEventLogCircularBuffer.GetEventLogPacket(var EventLogDataPacket: TEventLogDataPacket): boolean;
var
  bytesRead: Integer;
  packetRead: boolean;
begin
    // Read a packet of data from the buffer. If no data is available on the
    // circular buffer, the bytesRead value will be 0.
    bytesRead := Read(eventLogDataPacket, SizeOf(eventLogDataPacket));

    // Check if data was read from the circular buffer.
    if bytesRead = SizeOf(eventLogDataPacket) then
      packetRead := true
    else
      packetRead := false;

    Result := packetRead;
end;

end.
