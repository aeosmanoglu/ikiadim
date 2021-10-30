import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikiadim/model/onetimepass.dart';
import 'package:otp/otp.dart';

class Controller {
  /// Eğer yaratılmamışsa bir anahtar yaratır ve bunu cihazın güvenli alanında
  /// saklar.
  setSecureKey() async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    bool containsEncryptionKey = await secureStorage.containsKey(key: 'key');
    if (!containsEncryptionKey) {
      List<int> key = Hive.generateSecureKey();
      await secureStorage.write(key: 'key', value: base64UrlEncode(key));
    }
  }

  /// Veri tabanını ve adaptörleri başlatır.
  initTheBox() async {
    await Hive.initFlutter();
    Hive.registerAdapter(OneTimePasswordAdapter());
    Hive.registerAdapter(PasswordAdapter());
  }

  /// Veri tabanını açar.
  openTheBox() async {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    String? value = await secureStorage.read(key: 'key');
    Uint8List encryptionKey = base64Url.decode(value!);
    await Hive.openBox<OneTimePassword>(
      HiveBoxes.box,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  /// Verilen saniye değerine göre 0 ile 1 arasında değer üretir. Varsayılan
  /// olarak azalan değer verir ve 30 sn'dir.
  double counterValue({
    bool upScale = false,
    int seconds = 30,
  }) =>
      upScale
          ? (DateTime.now().second % seconds) / seconds
          : 1 - (DateTime.now().second % seconds) / seconds;

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
