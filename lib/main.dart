import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikiadim/model/onetimepass.dart';
import 'package:ikiadim/view/list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FlutterSecureStorage
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  bool containsEncryptionKey = await secureStorage.containsKey(key: 'key');
  if (!containsEncryptionKey) {
    List<int> key = Hive.generateSecureKey();
    await secureStorage.write(key: 'key', value: base64UrlEncode(key));
  }
  String? value = await secureStorage.read(key: 'key');
  Uint8List encryptionKey = base64Url.decode(value!);

  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(OneTimePasswordAdapter());
  Hive.registerAdapter(PasswordAdapter());
  Hive.registerAdapter(AlgorithmAdapter());
  await Hive.openBox<OneTimePassword>(
    HiveBoxes.box,
    encryptionCipher: HiveAesCipher(encryptionKey),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const ListPage(),
    );
  }
}

/// TODO:
/// - add try - catch
/// - add sentry
/// - logo
