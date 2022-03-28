import 'dart:io';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import 'models/message_info.dart';
import 'models/user_info.dart';
import 'models/room_info.dart';
import 'models/state_event_info.dart';
import 'models/event_info.dart';

import 'user.dart';

void main(List<String> args) async {
  var parser = ArgParser();
  parser.addFlag('help',
      abbr: 'h', negatable: false, help: 'show this message');
  parser.addOption('command',
      abbr: 'c',
      help: 'name of the command to use',
      allowed: ['join', 'create', 'message', 'list', 'invite', 'knock']);
  parser.addOption('roomId', abbr: 'r', help: 'room ID');
  parser.addOption('room-name', help: 'room name');
  parser.addOption('message', abbr: 'm', help: 'message body');
  parser.addOption('preset',
      abbr: 'p',
      help: 'publicity preset for room creation',
      allowed: ['public_chat', 'private_chat', 'trusted_private_chat']);
  parser.addOption('topic', abbr: 't', help: 'room topic');
  parser.addOption('alias', abbr: 'a', help: 'room alias');
  parser.addOption('username', abbr: 'u', help: 'user to invite');
  parser.addOption('reason', help: 'reason for invite/knock');

  ArgResults parserResults;

  try {
    parserResults = parser.parse(args);
  } on FormatException {
    print('invalid parameter for option');
    exit(400);
  } catch (e) {
    print(e);
    exit(400);
  }

  if (parserResults['help']) {
    print(parser.usage);
    exit(200);
  }

  http.Client client = http.Client();
  User user;

  Uri pathToScript = Platform.script;
  Directory baseDir = Directory.fromUri(pathToScript).parent;
  Directory dir =
      await Directory(baseDir.path + '/data').create(recursive: true);
  String filePath = dir.path;

  Hive
    ..init(filePath)
    ..registerAdapter(UserInfoAdapter())
    ..registerAdapter(StateEventInfoAdapter())
    ..registerAdapter(EventInfoAdapter())
    ..registerAdapter(RoomInfoAdapter())
    ..registerAdapter(MessageInfoAdapter());
  var db = await Hive.openBox('User');
  await db.compact();

  if (db.get('userInfo') == null) {
    print('Server: ');
    String server = stdin.readLineSync() as String;
    print('Username: ');
    String username = stdin.readLineSync() as String;
    UserInfo userInfo = UserInfo(username: username, server: server);
    user = User(userInfo);
    print("Password: ");
    db.put('userInfo', userInfo);
    await user.login(client, stdin.readLineSync());
  } else {
    user = User(db.get('userInfo'));
  }

  switch (parserResults['command']) {
    case 'initialSync':
      {
        await user.initialSync(client);
      }
      break;
    case 'sync':
      {
        await user.sync(client);
      }
      break;
    case 'newMessages':
      {
        await user.getMessages(client, parserResults['roomID'], limit: 25);
      }
      break;
    case 'oldMessages':
      {
        await user.getMessages(client, parserResults['roomID'],
            reverse: true, limit: 25);
      }
      break;
    case 'join':
      {
        String? roomId = roomIdIsValid(parserResults['roomId']);
        if (roomId != null) {
          user.joinRoom(client, roomId);
        }
      }
      break;
    case 'create':
      {
        String? roomName = roomNameIsValid(parserResults['room-name']);
        String? alias = parserResults['alias'];
        String preset = parserResults['preset']; // FIXME needs to be nullable
        String topic = parserResults['preset']; // FIXME needs to be nullable
        if (roomName != null) {
          await user.createRoom(client, roomName, preset, topic, alias: alias);
        }
      }
      break;
    case 'message':
      {
        String? message = messageIsValid(parserResults['message']);
        String? roomId = roomIdIsValid(parserResults['roomId']);
        if (message != null && roomId != null) {
          await user.sendMessage(client, message, roomId);
        }
      }
      break;
    case 'list':
      {
        await user.listRooms(client);
      }
      break;
    case 'invite':
      {
        String? roomId = roomIdIsValid(parserResults['roomId']);
        String? username = userNameIsValid(parserResults['username']);
        String? reason = parserResults['reason'];
        //FIXME remove typecasting in command below, null should be allowed
        if (roomId != null && username != null) {
          await user.inviteToRoom(client, roomId, username, reason);
        }
      }
      break;
    case 'knock':
      {
        String? roomId = roomIdIsValid(parserResults['roomId']);
        String? reason = parserResults['reason'];
        if (roomId != null) {
          await user.knockOnRoom(client, roomId, reason);
        }
      }
      break;
    default:
  }

  await db.close();
  client.close();
}

Future<UserInfo?> checkForUserInfo(String filePath) async {
  File jsonFile = File(filePath);

  bool fileExists = await jsonFile.exists();

  if (fileExists) {
    return UserInfo.fromJson(jsonDecode(await jsonFile.readAsString()));
  } else {
    await jsonFile.create();
    return null;
  }
}

String? roomIdIsValid(String? roomId) {
  RegExp roomIdScheme = RegExp(r'[!][A-Za-z]{18}');
  if (roomId == null) {
    stdout.write('roomId: ');
    roomId = stdin.readLineSync();
  }
  String? match = roomIdScheme.stringMatch(roomId as String);
  if (match != null) {
    return roomId;
  } else {
    print('need valid room id to join a room');
  }
}

String? roomNameIsValid(String? roomName) {
  if (roomName == null) {
    stdout.write('roomName: ');
    roomName = stdin.readLineSync();
  }
  if (roomName != null) {
    return roomName;
  } else {
    print('need a valid roomName to create');
  }
}

String? messageIsValid(String? message) {
  if (message == null) {
    stdout.write('message: ');
    message = stdin.readLineSync();
  }
  if (message != null) {
    return message;
  } else {
    print('need a valid message to send');
  }
}

String? userNameIsValid(String? user) {
  if (user == null) {
    stdout.write('user: ');
    user = stdin.readLineSync();
  }
  if (user != null) {
    return user;
  } else {
    print('need a valid userId to invite');
  }
}
