import 'dart:async';

import 'package:get/get.dart';
import 'package:otp/otp.dart';

class Controller extends GetxController {
  double counter = 0.0;
  int time = DateTime.now().millisecondsSinceEpoch;

  timer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      counter = 1 - (DateTime.now().second % 30) / 30;
      update();
    });
  }

  /// Convert algorithm strings to Algorithm type
  Algorithm toAlgorithm(String algorithm) {
    switch (algorithm) {
      case "SHA1":
        return Algorithm.SHA1;
      case "SHA256":
        return Algorithm.SHA256;
      case "SHA512":
        return Algorithm.SHA512;
      default:
        return Algorithm.SHA1;
    }
  }
}
