import 'dart:math';
import 'package:http/http.dart' as http;

import 'requester.dart';

class User extends Requester {
  String username;
  String password;
  List<String> rooms;

  late Map<String, String>? accessToken;
  late String? userID;
  late String? deviceID;

  User(Map jsonData)
      : username = jsonData["username"],
        password = jsonData["password"],
        rooms = jsonData["roomIDs"],
        super(jsonData["server"]);

  Future<void> login(http.Client client) async {
    Map payload = {
      "type": "m.login.password",
      "user": username,
      "password": password
    };
    String url = "_matrix/client/r0/login";

    Map response = await super.postRequest(client, url, data: payload);

    accessToken = {"Authorization": "Bearer ${response["access_token"]}"};
    userID = response["user_id"];
    deviceID = response["device_id"];
  }

  Future<void> sendMessage(
      http.Client client, String message, String roomID) async {
    String url =
        "_matrix/client/v3/rooms/$roomID:$server/send/m.room.message/${getRandomString(10)}";
    Map payload = {"msgtype": "m.text", "body": message};

    Map response = await super
        .putRequest(client, url, data: payload, headers: accessToken);
    print(response);
  }

  Future<void> joinRoom(http.Client client, String roomID) async {
    String url = "/_matrix/client/v3/join/$roomID:$server";

    Map response = await super.postRequest(client, url, headers: accessToken);
    print(response);
  }

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

    Map response =
        super.postRequest(client, url, data: payload, headers: accessToken);
    print(response);
  }

  Future<void> listRooms(http.Client client) async {
    String url = "/_matrix/client/v3/joined_rooms";

    Map response = super.getRequest(client, url, headers: accessToken);
    print(response);
  }

  Future<void> inviteToRoom(http.Client client, String roomID,
      String userToInvite, String? reason) async {
    String url = "/_matrix/client/v3/rooms/$roomID:$server/invite";
    Map payload = {"reason": reason, "user_id": "@$userToInvite:$server"};

    Map response =
        super.postRequest(client, url, data: payload, headers: accessToken);
    print(response);
  }

  Future<void> knockOnRoom(
      http.Client client, String roomID, String? reason) async {
    String url = "/_matrix/client/v3/knock/$roomID:$server";
    Map payload = {"reason": reason};

    Map response =
        super.postRequest(client, url, data: payload, headers: accessToken);
    print(response);
  }
}

String getRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
