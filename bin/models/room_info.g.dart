// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomInfoAdapter extends TypeAdapter<RoomInfo> {
  @override
  final int typeId = 4;

  @override
  RoomInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomInfo(
      prevBatchFromSync: fields[3] as String,
      syncNewest: fields[5] as bool,
      nextBatch: fields[6] as String?,
    )
      ..roomStateEvents = (fields[0] as List).cast<dynamic>()
      ..roomEvents = (fields[1] as List).cast<dynamic>()
      ..roomMessageEvents = (fields[2] as List).cast<dynamic>()
      ..currentPrevBatch = fields[4] as String?;
  }

  @override
  void write(BinaryWriter writer, RoomInfo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.roomStateEvents)
      ..writeByte(1)
      ..write(obj.roomEvents)
      ..writeByte(2)
      ..write(obj.roomMessageEvents)
      ..writeByte(3)
      ..write(obj.prevBatchFromSync)
      ..writeByte(4)
      ..write(obj.currentPrevBatch)
      ..writeByte(5)
      ..write(obj.syncNewest)
      ..writeByte(6)
      ..write(obj.nextBatch);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
