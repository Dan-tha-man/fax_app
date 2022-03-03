import 'dart:core';
import 'dart:io';
import 'dart:convert';

class UserInfo {
  late String username;
  late String server;
  late String filePath;
  bool? syncNewest;
  String? syncPrevBatch;
  Map<String, dynamic> rooms = {};
  String? userId;
  String? deviceId;
  Map<String, String>? accessToken;

  UserInfo(
      {required this.username,
      required this.server,
      required this.filePath,
      this.syncPrevBatch,
      this.userId,
      this.deviceId,
      this.accessToken});

  UserInfo.fromJson(Map<String, dynamic> data) {
    username = data["username"] as String;
    server = data["server"] as String;
    filePath = data["filePath"];
    syncPrevBatch = data["syncPrevBatch"] as String?;
    rooms = data["rooms"].cast<String, dynamic>();
    userId = data["userId"] as String?;
    deviceId = data["deviceId"] as String?;
    accessToken = data["accessToken"].cast<String, String>();
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "server": server,
      "filePath": filePath,
      "syncPrevBatch": syncPrevBatch,
      "rooms": rooms,
      "userId": userId,
      "deviceId": deviceId,
      "accessToken": accessToken
    };
  }

  void writeToFile() {
    const JsonEncoder json = JsonEncoder.withIndent('    ');
    File jsonFile = File(filePath);
    jsonFile.writeAsString(json.convert(toJson()));
  }
}
