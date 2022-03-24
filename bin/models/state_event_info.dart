import 'package:hive/hive.dart';

part 'state_event_info.g.dart';

@HiveType(typeId: 6)
class StateEventInfo {
  @HiveField(0)
  late String type;

  @HiveField(2)
  late String sender;

  @HiveField(3)
  late Map<String, dynamic> content;

  @HiveField(4)
  late String eventId;

  @HiveField(5)
  late int sentAt;

  StateEventInfo(
      {required this.type,
      required this.sender,
      required this.content,
      required this.eventId,
      required this.sentAt});

  StateEventInfo.fromSyncEndpoint(Map<String, dynamic> data) {
    type = data["type"] as String;
    sender = data["sender"] as String;
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
