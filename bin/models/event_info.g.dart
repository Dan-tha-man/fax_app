// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventInfoAdapter extends TypeAdapter<EventInfo> {
  @override
  final int typeId = 5;

  @override
  EventInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventInfo(
      type: fields[0] as String,
      sender: fields[2] as String,
      content: (fields[3] as Map).cast<String, dynamic>(),
      eventId: fields[4] as String,
      sentAt: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EventInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.sender)
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
      other is EventInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
