import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'requester.dart';
import 'models/user_info.dart';
import 'models/message_update.dart';

class User extends Requester {
  //Class Members
  UserInfo info;

  //Class Constructor
  User(this.info) : super(info.server);

  //Class Methods
  //User Login Management
  Future<void> login(http.Client client, String? password) async {
    Map payload = {
      "type": "m.login.password",
      "user": info.username,
      "password": password,
      "device_id": info.deviceId ?? getRandomString(10)
    };
    String url = "/_matrix/client/v3/login";

    Map response = await super.postRequest(client, url, data: payload);

    info.accessToken = {"Authorization": "Bearer ${response["access_token"]}"};
    info.userId = response["user_id"];
    info.deviceId = response["device_id"];

    print(response);
    info.save();
  }

  //Getting and Sending Messages
  Future<void> sync(http.Client client) async {
    String url = "/_matrix/client/v3/sync";
    Map<String, dynamic> payload = {"since": info.nextBatch};
    Map response = await super
        .getRequest(client, url, data: payload, headers: info.accessToken);

    info.nextBatch = response["next_batch"] as String;
    info.save();

    print(response);
  }

  Future<void> getNewMessages(http.Client client, String roomId, Box db) async {
    String url = "/_matrix/client/v3/rooms/$roomId:$server/messages";
    Map<String, dynamic> payload;
    if (info.rooms[roomId]?["syncNewest"] ?? true) {
      payload = {"from": info.nextBatch};
    } else {
      payload = {"from": info.rooms[roomId]["end"]};
    }
    Map response = await super
        .getRequest(client, url, data: payload, headers: info.accessToken);

    info.rooms[roomId] = {
      "syncNewest": false,
      "end": response["end"] as String
    };
    info.save();

    MessageUpdate update =
        MessageUpdate.fromJson(response.cast<String, dynamic>());

    update.saveNewMessages(db);

    // for (MessageInfo message in update.messages) {
    //   print(message.content);
    // }
    print(response);
  }

  Future<void> sendMessage(
      http.Client client, String message, String roomId) async {
    String url =
        "/_matrix/client/v3/rooms/$roomId:$server/send/m.room.message/${getRandomString(10)}";
    Map payload = {"msgtype": "m.text", "body": message};

    Map response = await super
        .putRequest(client, url, data: payload, headers: info.accessToken);
    print(response);
  }

  //User Rooms Management
  // TODO add ability to invite users when making a room
  Future<void> createRoom(
      http.Client client, String roomName, String preset, String topic,
      {String? alias, String? visibility}) async {
    String url = "/_matrix/client/v3/createRoom";
    Map payload = {
      "creation_content": {"m.federate": false},
      "name": roomName,
      "preset": preset,
      "topic": topic
    };

    if (alias != null && visibility != null) {
      payload["room_alias_name"] = alias;
      payload["visibility"] = visibility;
    } else if (alias == null && visibility != null) {
      payload["visibility"] = visibility;
    } else if (alias != null && visibility == null) {
      payload["room_alias_name"] = alias;
    }

    Map response = await super
        .postRequest(client, url, data: payload, headers: info.accessToken);
    print(response);
  }

  Future<void> listRooms(http.Client client) async {
    String url = "/_matrix/client/v3/joined_rooms";

    Map response =
        await super.getRequest(client, url, headers: info.accessToken);
    print(response);
  }

  Future<void> joinRoom(http.Client client, String roomId) async {
    String url = "/_matrix/client/v3/join/$roomId:$server";

    Map response =
        await super.postRequest(client, url, headers: info.accessToken);
    print(response);
  }

  Future<void> inviteToRoom(http.Client client, String roomId,
      String userToInvite, String? reason) async {
    String url = "/_matrix/client/v3/rooms/$roomId:$server/invite";
    Map payload = {"reason": reason, "user_id": "@$userToInvite:$server"};

    Map response = await super
        .postRequest(client, url, data: payload, headers: info.accessToken);
    print(response);
  }

  Future<void> knockOnRoom(
      http.Client client, String roomId, String? reason) async {
    String url = "/_matrix/client/v3/knock/$roomId:$server";
    Map payload = {"reason": reason};

    Map response = await super
        .postRequest(client, url, data: payload, headers: info.accessToken);
    print(response);
  }
}

String getRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
