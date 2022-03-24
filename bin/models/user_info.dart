import 'package:hive/hive.dart';
import 'room_info.dart';

part 'user_info.g.dart';

@HiveType(typeId: 1)
class UserInfo extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String server;

  @HiveField(2)
  String? nextBatch;

  @HiveField(3)
  Map<String, RoomInfo> rooms = {};

  @HiveField(4)
  String? userId;

  @HiveField(5)
  String? deviceId;

  @HiveField(6)
  Map<String, String>? accessToken;

  UserInfo({required this.username, required this.server});

  void saveLogin(Map<String, dynamic> data) {
    userId = data["user_id"];
    deviceId = data["device_id"];
    accessToken = {"Authorization": "Bearer ${data["access_token"]}"};
    save();
  }

  void saveInitialSync(Map<String, dynamic> data) {
    nextBatch = data["next_batch"] as String;
    for (String roomId in data["rooms"]["join"].keys) {
      rooms[roomId] = RoomInfo.fromInitialSync(
          data["rooms"]["join"][roomId].cast<String, dynamic>());
    }
    save();
  }

  void saveSync(Map<String, dynamic> data) {
    nextBatch = data["next_batch"] as String;
    if (data["rooms"]?["join"] != null) {
      for (String roomId in data["rooms"]?["join"].keys) {
        rooms[roomId]!
            .saveSync(data["rooms"]["join"][roomId].cast<String, dynamic>());
      }
    }
    save();
  }

  void printRoomEvents() {
    for (var roomId in rooms.keys) {
      print(rooms[roomId]?.prevBatchFromSync);
      rooms[roomId]?.printMessages();
      rooms[roomId]?.printEvents();
      rooms[roomId]?.printStateEvents();
    }
  }
}
