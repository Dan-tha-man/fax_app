import 'package:hive/hive.dart';

part 'message_info.g.dart';

@HiveType(typeId: 2)
class MessageInfo {
  @HiveField(0)
  late String type;

  @HiveField(2)
  late String userId;

  @HiveField(3)
  late Map<String, dynamic> content;

  @HiveField(4)
  late String eventId;

  @HiveField(5)
  late int sentAt;

  MessageInfo(
      {required this.type,
      required this.userId,
      required this.content,
      required this.eventId,
      required this.sentAt});

  MessageInfo.fromMessagesEndpoint(Map<String, dynamic> data) {
    type = data["type"] as String;
    userId = data["user_id"] as String;
    content = data["content"].cast<String, dynamic>();
    eventId = data["event_id"] as String;
    DateTime now = DateTime.now();
    sentAt = now.millisecondsSinceEpoch - data["age"] as int;
  }

  MessageInfo.fromSyncEndpoint(Map<String, dynamic> data) {
    type = data["type"] as String;
    userId = data["sender"] as String;
    content = data["content"].cast<String, dynamic>();
    eventId = data["event_id"] as String;
    DateTime now = DateTime.now();
    if (data["age"] == null) {
      sentAt = now.millisecondsSinceEpoch - (data["unsigned"]["age"] as int);
    } else {
      sentAt = now.millisecondsSinceEpoch - (data["age"] as int);
    }
  }
}

// @HiveType(typeId: 3)
// class MessageUpdate extends HiveObject {
//   @HiveField(0)
//   late String start;

//   @HiveField(1)
//   late String end;

//   @HiveField(2)
//   late List<MessageInfo> messages;

//   MessageUpdate(
//       {required this.start, required this.end, required this.messages});

//   MessageUpdate.fromJson(Map<String, dynamic> data) {
//     start = data["start"];
//     end = data["end"];
//     messages = [];
//     for (Map message in data["chunk"]) {
//       messages.add(MessageInfo.fromJson(message.cast<String, dynamic>()));
//     }
//   }

//   void saveNewMessages(Box db) {
//     MessageUpdate previousUpdate = db.get('messages');
//     List<MessageInfo> oldMessages = previousUpdate.messages;
//     messages = List.from(oldMessages)..addAll(messages);
//     db.put('messages', this);
//   }
// }
