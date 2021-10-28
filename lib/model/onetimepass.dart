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
  Algorithm? algorithm;

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
      this.length,
      this.interval,
      this.algorithm,
      this.counter});
}

@HiveType(typeId: 1)
enum Password {
  @HiveField(0)
  totp,

  @HiveField(1)
  hotp,
}

@HiveType(typeId: 2)
enum Algorithm {
  @HiveField(0)
  SHA1,

  @HiveField(1)
  SHA256,

  @HiveField(2)
  SHA512,
}

class HiveBoxes {
  static String box = "box";
}
