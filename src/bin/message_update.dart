import 'dart:core';
import 'dart:io';
import 'dart:convert';

class MessageUpdate {
  late String start;
  late String end;
  late List<MessageInfo> messages;

  MessageUpdate(
      {required this.start, required this.end, required this.messages});

  MessageUpdate.fromJson(Map<String, dynamic> data) {
    start = data["start"];
    end = data["end"];
    messages = [];
    for (Map message in data["chunk"]) {
      messages.add(MessageInfo.fromAPI(message.cast<String, dynamic>()));
    }
  }

  void writeToFile() async {
    Uri pathToScript = Platform.script;
    Directory baseDir = Directory.fromUri(pathToScript).parent.parent.parent;
    Directory dir =
        await Directory(baseDir.path + '/src').create(recursive: true);
    String fileName = "messages.json";
    String filePath = dir.path + "/" + fileName;
    File jsonFile = File(filePath);

    const JsonEncoder json = JsonEncoder.withIndent('    ');

    bool fileExists = await jsonFile.exists();
    if (!fileExists) {
      await jsonFile.create(recursive: true);
      await jsonFile.writeAsString(json.convert([]));
    }

    List<dynamic> messagesFromJson = jsonDecode(await jsonFile.readAsString());
    for (Map message in messagesFromJson) {
      messages.add(MessageInfo.fromJson(message.cast<String, dynamic>()));
    }

    List messagesToJson = [];
    for (MessageInfo message in messages) {
      messagesToJson.add(message.toJson());
    }

    await jsonFile.writeAsString(json.convert(messagesToJson));
  }
}

class MessageInfo {
  late String type;
  late String roomID;
  late String userID;
  late Map<String, dynamic> content;
  late String eventID;
  late DateTime sentAt;

  MessageInfo(
      {required this.type,
      required this.roomID,
      required this.userID,
      required this.content,
      required this.eventID,
      required this.sentAt});

  MessageInfo.fromAPI(Map<String, dynamic> data) {
    type = data["type"] as String;
    roomID = data["room_id"] as String;
    userID = data["sender"] as String;
    content = data["content"].cast<String, dynamic>();
    eventID = data["event_id"] as String;
    DateTime now = DateTime.now();
    sentAt = DateTime.fromMillisecondsSinceEpoch(
        now.millisecondsSinceEpoch - data["age"] as int);
  }

  MessageInfo.fromJson(Map<String, dynamic> data) {
    type = data["type"] as String;
    roomID = data["roomID"] as String;
    userID = data["userID"] as String;
    content = data["content"].cast<String, dynamic>();
    eventID = data["eventID"] as String;
    sentAt = DateTime.fromMillisecondsSinceEpoch(data["sentAt"] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "roomID": roomID,
      "userID": userID,
      "content": content,
      "eventID": eventID,
      "sentAt": sentAt.millisecondsSinceEpoch,
    };
  }
}
