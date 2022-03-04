// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_update.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageInfoAdapter extends TypeAdapter<MessageInfo> {
  @override
  final int typeId = 2;

  @override
  MessageInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageInfo(
      type: fields[0] as String,
      roomId: fields[1] as String,
      userId: fields[2] as String,
      content: (fields[3] as Map).cast<String, dynamic>(),
      eventId: fields[4] as String,
      sentAt: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MessageInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.roomId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.eventId)
      ..writeByte(5)
      ..write(obj.sentAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageUpdateAdapter extends TypeAdapter<MessageUpdate> {
  @override
  final int typeId = 3;

  @override
  MessageUpdate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageUpdate(
      start: fields[0] as String,
      end: fields[1] as String,
      messages: (fields[2] as List).cast<MessageInfo>(),
    );
  }

  @override
  void write(BinaryWriter writer, MessageUpdate obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end)
      ..writeByte(2)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageUpdateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
