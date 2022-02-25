import 'dart:io';
import 'dart:convert';

class UserInfo {
  String username;
  String server;
  String filePath;
  String? userID;
  String? deviceID;
  Map<String, String>? accessToken;

  UserInfo(
      {required this.username,
      required this.server,
      required this.filePath,
      this.userID,
      this.deviceID,
      this.accessToken});

  factory UserInfo.fromJson(Map<String, dynamic> data) {
    final username = data["username"] as String;
    final server = data["server"] as String;
    final filePath = data["filePath"] as String;
    final userID = data["userID"] as String?;
    final deviceID = data["deviceID"] as String?;
    final token = data["accessToken"]["Authorization"] as String?;
    final accessToken = {"Authorization": "$token"};

    return UserInfo(
        username: username,
        server: server,
        filePath: filePath,
        userID: userID,
        deviceID: deviceID,
        accessToken: accessToken);
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "server": server,
      "filePath": filePath,
      "userID": userID,
      "deviceID": deviceID,
      "accessToken": accessToken
    };
  }

  void writeToFile() {
    File jsonFile = File(filePath);
    jsonFile.writeAsString(jsonEncode(toJson()));
  }
}
