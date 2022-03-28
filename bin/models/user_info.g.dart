// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoAdapter extends TypeAdapter<UserInfo> {
  @override
  final int typeId = 1;

  @override
  UserInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfo(
      username: fields[0] as String,
      server: fields[1] as String,
    )
      ..nextBatch = fields[2] as String?
      ..rooms = (fields[3] as Map).cast<String, RoomInfo>()
      ..userId = fields[4] as String?
      ..deviceId = fields[5] as String?
      ..accessToken = (fields[6] as Map?)?.cast<String, String>();
  }

  @override
  void write(BinaryWriter writer, UserInfo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.server)
      ..writeByte(2)
      ..write(obj.nextBatch)
      ..writeByte(3)
      ..write(obj.rooms)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.deviceId)
      ..writeByte(6)
      ..write(obj.accessToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
