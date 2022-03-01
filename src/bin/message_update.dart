import 'dart:core';

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
      messages.add(MessageInfo.fromJson(message.cast<String, dynamic>()));
    }
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

  MessageInfo.fromJson(Map<String, dynamic> data) {
    type = data["type"] as String;
    roomID = data["room_id"] as String;
    userID = data["sender"] as String;
    content = data["content"].cast<String, dynamic>();
    eventID = data["event_id"] as String;
    DateTime now = DateTime.now();
    sentAt = DateTime.fromMillisecondsSinceEpoch(
        now.millisecondsSinceEpoch - data["age"] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "roomID": roomID,
      "userID": userID,
      "content": content,
      "eventID": eventID,
      "sentAt": sentAt,
    };
  }
}
