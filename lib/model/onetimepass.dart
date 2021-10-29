// ignore_for_file: constant_identifier_names

import 'package:hive/hive.dart';

part 'onetimepass.g.dart';

@HiveType(typeId: 0)
class OneTimePassword extends HiveObject {
  @HiveField(0)
  late String label;

  @HiveField(1)
  String secret;

  @HiveField(2)
  int? length;

  @HiveField(3)
  int? interval;

  @HiveField(4)
  String? algorithm;

  @HiveField(5)
  bool? isGoogle;

  @HiveField(6)
  int? counter;

  @HiveField(7)
  Password type;

  OneTimePassword(
      {required this.label,
      required this.secret,
      required this.type,
      this.length = 6,
      this.interval = 30,
      this.algorithm,
      this.counter = 0,
      this.isGoogle = true});
}

@HiveType(typeId: 1)
enum Password {
  @HiveField(0)
  totp,

  @HiveField(1)
  hotp,
}

class HiveBoxes {
  static String box = "box";
}
