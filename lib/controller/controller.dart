import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  /// Datayı panoya kopyalar. Tüm açık snackbarları kapatarak, yeni snackbar ile
  /// bilgi verir.
  copy2clipboard(BuildContext context, String data, String label) {
    ScaffoldMessenger.of(context).clearSnackBars();
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"$label" kopyalandı.')),
    );
  }

  /// Verilen değerin BASE32 olup olmadığını kontrol eder.
  bool isBase32(String key) {
    key = key.toUpperCase();
    RegExp regExp = RegExp(r"^[A-Z2-7]+=*$");
    return key.length % 8 != 0 ? false : regExp.hasMatch(key);
  }

  /// Debug için dummy data ekler. Productiondan önce silinmeli.
  deleteMe() {
    Box<OneTimePassword> otpBox = Hive.box<OneTimePassword>(HiveBoxes.box);
    otpBox.add(
      OneTimePassword(
        type: Password.totp,
        label: "Label TOTP",
        secret: OTP.randomSecret(),
        algorithm: "SHA1",
        length: 6,
        interval: 30,
        counter: 0,
      ),
    );
    otpBox.add(
      OneTimePassword(
        type: Password.hotp,
        label: "Label HOTP",
        secret: OTP.randomSecret(),
        algorithm: "SHA1",
        length: 6,
        interval: 30,
        counter: 0,
      ),
    );
  }
}
