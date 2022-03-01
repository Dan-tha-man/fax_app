import 'dart:core';
import 'json_file_handler.dart';

class UserInfo with JsonFileHandler {
  late String username;
  late String server;
  late String filePath;
  bool? syncNewest;
  String? syncPrevBatch;
  Map<String, dynamic> rooms = {};
  String? userID;
  String? deviceID;
  Map<String, String>? accessToken;

  UserInfo(
      {required this.username,
      required this.server,
      required this.filePath,
      this.syncNewest,
      this.syncPrevBatch,
      this.userID,
      this.deviceID,
      this.accessToken});

  UserInfo.fromJson(Map<String, dynamic> data) {
    username = data["username"] as String;
    server = data["server"] as String;
    filePath = data["filePath"] as String;
    syncNewest = data["syncNewest"] as bool?;
    syncPrevBatch = data["syncPrevBatch"] as String?;
    rooms = data["rooms"].cast<String, dynamic>();
    userID = data["userID"] as String?;
    deviceID = data["deviceID"] as String?;
    accessToken = data["accessToken"].cast<String, String>();
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "server": server,
      "filePath": filePath,
      "syncNewest": syncNewest,
      "syncPrevBatch": syncPrevBatch,
      "rooms": rooms,
      "userID": userID,
      "deviceID": deviceID,
      "accessToken": accessToken
    };
  }

  void writeToFile() {
    super.write(filePath, toJson());
  }
}
