import 'package:hive/hive.dart';
import 'package:otp/otp.dart';

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

  OneTimePassword({
    required this.label,
    required this.secret,
    required this.type,
  });
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
