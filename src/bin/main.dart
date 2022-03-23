import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'user_info.dart';

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
  parser.addOption('user', abbr: 'u', help: 'user to invite');
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
  Directory baseDir = Directory.fromUri(pathToScript).parent.parent.parent;
  Directory dir =
      await Directory(baseDir.path + '/src').create(recursive: true);
  String fileName = "user_data.json";
  String filePath = dir.path + "/" + fileName;

  UserInfo? info = await checkForUserInfo(filePath);

  if (info != null) {
    user = User(info);
  } else {
    print('Server: ');
    String server = stdin.readLineSync() as String;
    print('Username: ');
    String username = stdin.readLineSync() as String;
    user =
        User(UserInfo(username: username, server: server, filePath: filePath));
    print("Password: ");
    await user.login(client, stdin.readLineSync());
  }

  switch (parserResults['command']) {
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
        String? roomName = roomNameIsValid(parserResults['roomName']);
        String? alias = parserResults['alias'];
        String preset = parserResults['preset']; // FIXME needs to be nullable
        String topic = parserResults['preset']; // FIXME needs to be nullable
        if (roomName != null) {
          await user.createRoom(client, roomName, preset, topic, alias: alias);
        } else {
          stdout.write('room name: ');
          roomName = stdin.readLineSync() as String;
        }
      }
      break;
    case 'message':
      {
        String? message = messageIsValid(parserResults['message']);
        String? roomId = roomIdIsValid(parserResults['roomId']);
        if (message != null && roomId != null) {
          await user.sendMessage(
              client, parserResults['message'], parserResults['roomId']);
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
        await user.inviteToRoom(client, parserResults['roomId'],
            parserResults['user'], parserResults['reason']);
      }
      break;
    case 'knock':
      {
        await user.knockOnRoom(
            client, parserResults['roomId'], parserResults['reason']);
      }
      break;
    default:
  }

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
