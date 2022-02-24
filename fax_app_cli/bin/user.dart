import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class User {
  String username;
  String password;
  String server;
  List<String> rooms;

  late Map<String, String>? accessToken;
  late String? userID;
  late String? deviceID;

  User(Map jsonData)
      : username = jsonData["username"],
        password = jsonData["password"],
        server = jsonData["server"],
        rooms = jsonData["roomIDs"];

  Future<void> login(http.Client client) async {
    Map data = {
      "type": "m.login.password",
      "user": username,
      "password": password
    };
    var jsonData = json.encode(data);
    try {
      var response = await client
          .post(Uri.https(server, "_matrix/client/r0/login"), body: jsonData);
      var decodedResponse = jsonDecode(response.body) as Map;

      accessToken = {
        "Authorization": "Bearer ${decodedResponse["access_token"]}"
      };
      userID = decodedResponse["user_id"];
      deviceID = decodedResponse["device_id"];
      print(accessToken);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> sendMessage(
      http.Client client, String? message, String room) async {
    Map data = {"msgtype": "m.text", "body": message};
    var jsonData = json.encode(data);

    String url =
        "_matrix/client/v3/rooms/$room:$server/send/m.room.message/${getRandomString(3)}";
    try {
      var response = await client.put(Uri.https(server, url),
          headers: accessToken, body: jsonData);
      var decodedResponse = jsonDecode(response.body) as Map;

      print(decodedResponse);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> joinRoom(http.Client client, String room) async {
    String url = "/_matrix/client/v3/join/$room:$server";
    try {
      var response =
          await client.post(Uri.https(server, url), headers: accessToken);
      var decodedResponse = jsonDecode(response.body) as Map;

      print(decodedResponse);
    } catch (e) {
      print("Error: $e");
    }
  }

  // TODO add ability to invite users when making a room
  // TODO different room preset options
  Future<void> createRoom(
      http.Client client, String roomName, String topic) async {
    String url = "/_matrix/client/v3/createRoom";
    Map data = {
      "creation_content": {"m.federate": false},
      "name": roomName,
      "preset": "public_chat",
      "room_alias_name": "testalias4",
      "topic": topic,
      "visibility": "public"
    };
    var jsonData = json.encode(data);

    try {
      var response = await client.post(Uri.https(server, url),
          headers: accessToken, body: jsonData);
      var decodedResponse = jsonDecode(response.body) as Map;

      print(decodedResponse);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> listRooms(http.Client client) async {
    String url = "/_matrix/client/v3/joined_rooms";
    try {
      var response =
          await client.get(Uri.https(server, url), headers: accessToken);
      var decodedResponse = jsonDecode(response.body) as Map;

      print(decodedResponse);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> inviteToRoom(http.Client client, String room,
      String userToInvite, String? reason) async {
    String url = "/_matrix/client/v3/rooms/$room:$server/invite";
    Map data = {"reason": reason, "user_id": userToInvite};
    var jsonData = json.encode(data);
    try {
      var response = await client.post(Uri.https(server, url),
          headers: accessToken, body: jsonData);
      var decodedResponse = jsonDecode(response.body) as Map;

      print(decodedResponse);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> knockOnRoom(
      http.Client client, String room, String? reason) async {
    String url = "/_matrix/client/v3/knock/$room:$server";
    Map data = {"reason": reason};
    var jsonData = json.encode(data);
    try {
      var response = await client.post(Uri.https(server, url),
          headers: accessToken, body: jsonData);
      var decodedResponse = jsonDecode(response.body) as Map;

      print(decodedResponse);
    } catch (e) {
      print("Error: $e");
    }
  }
}

String getRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
