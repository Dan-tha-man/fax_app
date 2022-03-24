import 'package:hive/hive.dart';
import 'message_info.dart';
import 'event_info.dart';
import 'state_event_info.dart';

part 'room_info.g.dart';

@HiveType(typeId: 4)
class RoomInfo {
  @HiveField(0)
  List roomStateEvents = [];

  @HiveField(1)
  List roomEvents = [];

  @HiveField(2)
  List roomMessageEvents = [];

  @HiveField(3)
  late String prevBatchFromSync;

  @HiveField(4)
  String? currentPrevBatch;

  @HiveField(5)
  late bool syncNewest;

  @HiveField(6)
  String? nextBatch;

  RoomInfo(
      {required this.prevBatchFromSync,
      required this.syncNewest,
      required this.nextBatch});

  RoomInfo.fromInitialSync(Map<String, dynamic> data) {
    for (Map event in data["timeline"]["events"]) {
      if (event["type"] == "m.room.message") {
        roomMessageEvents
            .add(MessageInfo.fromSyncEndpoint(event.cast<String, dynamic>()));
      } else {
        roomEvents
            .add(EventInfo.fromSyncEndpoint(event.cast<String, dynamic>()));
      }
    }
    if (data["timeline"]["state"]?["events"] != null) {
      for (Map event in data["timeline"]["state"]?["events"]) {
        roomStateEvents.add(
            StateEventInfo.fromSyncEndpoint(event.cast<String, dynamic>()));
      }
    }
    prevBatchFromSync = data["timeline"]["prev_batch"] as String;
    currentPrevBatch = prevBatchFromSync;
    syncNewest = true;
  }

  void saveSync(Map<String, dynamic> data) {
    for (Map event in data["timeline"]["events"]) {
      if (event["type"] == "m.room.message") {
        roomMessageEvents
            .add(MessageInfo.fromSyncEndpoint(event.cast<String, dynamic>()));
      } else {
        roomEvents
            .add(EventInfo.fromSyncEndpoint(event.cast<String, dynamic>()));
      }
    }
    if (data["timeline"]["state"]?["events"] != null) {
      for (Map event in data["timeline"]["state"]?["events"]) {
        roomStateEvents.add(
            StateEventInfo.fromSyncEndpoint(event.cast<String, dynamic>()));
      }
    }
    prevBatchFromSync = data["timeline"]["prev_batch"] as String;
    syncNewest = true;
  }

  void saveMessages(Map<String, dynamic> data) {
    for (Map message in data["chunk"]) {
      roomMessageEvents.add(
          MessageInfo.fromMessagesEndpoint(message.cast<String, dynamic>()));
    }
    currentPrevBatch = data["start"] as String;
    nextBatch = data["end"] as String;
    syncNewest = false;
  }

  void deleteRoomMessages() {
    roomMessageEvents = [];
    currentPrevBatch = prevBatchFromSync;
  }

  void printMessages() {
    for (MessageInfo message in roomMessageEvents) {
      var output =
          "${message.content}${DateTime.fromMillisecondsSinceEpoch(message.sentAt)}";
      print(output);
    }
  }

  void printEvents() {
    for (EventInfo event in roomEvents) {
      print(event.content);
    }
  }

  void printStateEvents() {
    for (StateEventInfo stateEvent in roomStateEvents) {
      print(stateEvent.content);
    }
  }
}
