import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikiadim/model/onetimepass.dart';
import 'package:ikiadim/view/list.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(OneTimePasswordAdapter());
  Hive.registerAdapter(PasswordAdapter());
  await Hive.openBox<OneTimePassword>(HiveBoxes.box);
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
/// - delete list row
/// - secure hive
/// - secure app
/// - read qr code
/// - name
/// - logo
