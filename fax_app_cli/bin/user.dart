import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  String username;
  String password;
  String server;
  List<String> rooms;

  late String? accessToken;
  late String? userID;
  late String? deviceID;

  User(Map jsonData)
      : username = jsonData["username"],
        password = jsonData["password"],
        server = jsonData["server"],
        rooms = jsonData["roomIDs"];

  void login(http.Client client) async {
    Map body = {
      "type": "m.login.password",
      "user": username,
      "password": password
    };
    var jsonData = json.encode(body);
    print(jsonData);
    try {
      var response = await client
          .post(Uri.https(server, "_matrix/client/r0/login"), body: jsonData);
      var decodedResponse = jsonDecode(response.body) as Map;

      accessToken = decodedResponse["access_token"];
      userID = decodedResponse["user_id"];
      deviceID = decodedResponse["device_id"];
      print(accessToken);
    } catch (e) {
      print("Error: $e");
    }
  }

  // void register(http.Client client) async {
  //   try {
  //     var response = await client.get(server);
  //     var decodedResponse = jsonDecode(response.body) as Map;

  //     accessToken = decodedResponse["access_token"];
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }
}
