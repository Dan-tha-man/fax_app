import 'dart:math';
import 'package:http/http.dart' as http;

import 'requester.dart';
import 'user_info.dart';

class User extends Requester {
  UserInfo info;

  User(this.info) : super(info.server);

  Future<void> login(http.Client client, String? password) async {
    Map payload = {
      "type": "m.login.password",
      "user": info.username,
      "password": password,
      "device_id": info.deviceID ?? getRandomString(10)
    };
    String url = "/_matrix/client/v3/login";

    Map response = await super.postRequest(client, url, data: payload);

    info.accessToken = {"Authorization": "Bearer ${response["access_token"]}"};
    info.userID = response["user_id"];
    info.deviceID = response["device_id"];

    print(response);
    info.writeToFile();
  }

  Future<void> sendMessage(
      http.Client client, String message, String roomID) async {
    String url =
        "/_matrix/client/v3/rooms/$roomID:$server/send/m.room.message/${getRandomString(10)}";
    Map payload = {"msgtype": "m.text", "body": message};

    Map response = await super
        .putRequest(client, url, data: payload, headers: info.accessToken);
    print(response);
  }

  Future<void> joinRoom(http.Client client, String roomID) async {
    String url = "/_matrix/client/v3/join/$roomID:$server";

    Map response =
        await super.postRequest(client, url, headers: info.accessToken);
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

  Future<void> inviteToRoom(http.Client client, String roomID,
      String userToInvite, String? reason) async {
    String url = "/_matrix/client/v3/rooms/$roomID:$server/invite";
    Map payload = {"reason": reason, "user_id": "@$userToInvite:$server"};

    Map response = await super
        .postRequest(client, url, data: payload, headers: info.accessToken);
    print(response);
  }

  Future<void> knockOnRoom(
      http.Client client, String roomID, String? reason) async {
    String url = "/_matrix/client/v3/knock/$roomID:$server";
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
