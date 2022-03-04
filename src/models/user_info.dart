import 'package:hive/hive.dart';
part 'user_info.g.dart';

@HiveType(typeId: 1)
class UserInfo extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String server;

  @HiveField(2)
  String? nextBatch;

  @HiveField(3)
  Map<String, dynamic> rooms = {};

  @HiveField(4)
  String? userId;

  @HiveField(5)
  String? deviceId;

  @HiveField(6)
  Map<String, String>? accessToken;

  UserInfo(
      {required this.username,
      required this.server,
      this.nextBatch,
      this.userId,
      this.deviceId,
      this.accessToken});
}
