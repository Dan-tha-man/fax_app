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

    Map response = await testResponse(super.post(client, url, data: payload));

    accessToken = {"Authorization": "Bearer ${response["access_token"]}"};
    userID = response["user_id"];
    deviceID = response["device_id"];
  }

  Future<void> sendMessage(
      http.Client client, String message, String roomID) async {
    String url =
        "_matrix/client/v3/rooms/$roomID:$server/send/m.room.message/${getRandomString(10)}";
    Map payload = {"msgtype": "m.text", "body": message};

    await testResponse(
        super.put(client, url, data: payload, headers: accessToken));
  }

  Future<void> joinRoom(http.Client client, String roomID) async {
    String url = "/_matrix/client/v3/join/$roomID:$server";

    await testResponse(super.post(client, url, headers: accessToken));
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

    testResponse(super.post(client, url, data: payload, headers: accessToken));
  }

  Future<void> listRooms(http.Client client) async {
    String url = "/_matrix/client/v3/joined_rooms";

    testResponse(super.get(client, url, headers: accessToken));
  }

  Future<void> inviteToRoom(http.Client client, String roomID,
      String userToInvite, String? reason) async {
    String url = "/_matrix/client/v3/rooms/$roomID:$server/invite";
    Map payload = {"reason": reason, "user_id": "@$userToInvite:$server"};

    testResponse(super.post(client, url, data: payload, headers: accessToken));
  }

  Future<void> knockOnRoom(
      http.Client client, String roomID, String? reason) async {
    String url = "/_matrix/client/v3/knock/$roomID:$server";
    Map payload = {"reason": reason};

    testResponse(super.post(client, url, data: payload, headers: accessToken));
  }
}

String getRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}

Future<Map> testResponse(Future response) async {
  try {
    Map decodedResponse = await response;
    print(decodedResponse); //!for testing only
    return decodedResponse;
  } catch (e) {
    print("Error: $e");
    return {"error": e};
  }
}
