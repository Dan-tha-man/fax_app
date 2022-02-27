import 'dart:io';
import 'dart:convert';
import 'dart:core';

class UserInfo {
  late String username;
  late String server;
  late String filePath;
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

  UserInfo.fromJson(Map<String, dynamic> data) {
    username = data["username"] as String;
    server = data["server"] as String;
    filePath = data["filePath"] as String;
    userID = data["userID"] as String?;
    deviceID = data["deviceID"] as String?;
    accessToken = data["accessToken"].cast<String, String>();
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
    const JsonEncoder json = JsonEncoder.withIndent('    ');
    File jsonFile = File(filePath);
    jsonFile.writeAsString(json.convert(toJson()));
  }
}
