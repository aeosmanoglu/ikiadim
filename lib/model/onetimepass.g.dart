// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onetimepass.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OneTimePasswordAdapter extends TypeAdapter<OneTimePassword> {
  @override
  final int typeId = 0;

  @override
  OneTimePassword read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OneTimePassword(
      label: fields[0] as String,
      secret: fields[1] as String,
      type: fields[7] as Password,
    )
      ..length = fields[2] as int?
      ..interval = fields[3] as int?
      ..algorithm = fields[4] as Algorithm?
      ..isGoogle = fields[5] as bool?
      ..counter = fields[6] as int?;
  }

  @override
  void write(BinaryWriter writer, OneTimePassword obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.secret)
      ..writeByte(2)
      ..write(obj.length)
      ..writeByte(3)
      ..write(obj.interval)
      ..writeByte(4)
      ..write(obj.algorithm)
      ..writeByte(5)
      ..write(obj.isGoogle)
      ..writeByte(6)
      ..write(obj.counter)
      ..writeByte(7)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OneTimePasswordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PasswordAdapter extends TypeAdapter<Password> {
  @override
  final int typeId = 1;

  @override
  Password read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Password.totp;
      case 1:
        return Password.hotp;
      default:
        return Password.totp;
    }
  }

  @override
  void write(BinaryWriter writer, Password obj) {
    switch (obj) {
      case Password.totp:
        writer.writeByte(0);
        break;
      case Password.hotp:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
