import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'user.dart';
import 'user_info.dart';

void main(List<String> arguments) async {
  http.Client client = http.Client();
  User user;

  Directory dir = await Directory('src').create(recursive: true);
  String fileName = "user_data.json";
  String filePath = dir.path + "/" + fileName;

  UserInfo? info = await checkForUserInfo(filePath);

  if (info != null) {
    user = User(info);
  } else {
    user = User(getUserInfo(filePath));
    print("Enter your password: ");
    await user.login(client, stdin.readLineSync());
  }

  // TODO make a CLI to access different commands
  try {
    await user.joinRoom(client, "!QpeulGJrJPvafTNtiG");
    await user.createRoom(client, "testRoom", "private_chat", "test room test",
        alias: "testalias42");
    await user.sendMessage(client, "yo whats up", "!QpeulGJrJPvafTNtiG");
    await user.listRooms(client);
    await user.inviteToRoom(
        client, "!QpeulGJrJPvafTNtiG", "testuser", "reason");
    await user.knockOnRoom(client, "!QpeulGJrJPvafTNtiG", "reason");
  } catch (e) {
    print("Error: $e");
  }

  client.close();
}

UserInfo getUserInfo(String filePath) {
  print("Enter the server: ");
  String server = stdin.readLineSync() as String;
  print("Enter your username: ");
  String username = stdin.readLineSync() as String;

  return UserInfo(username: username, server: server, filePath: filePath);
}

Future<UserInfo?> checkForUserInfo(String filePath) async {
  File jsonFile = File(filePath);

  bool fileExists = jsonFile.existsSync();

  if (fileExists) {
    return UserInfo.fromJson(jsonDecode(await jsonFile.readAsString()));
  } else {
    jsonFile.createSync();
    return null;
  }
}
