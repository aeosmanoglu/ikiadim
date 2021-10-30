import 'package:flutter/material.dart';
import 'package:ikiadim/controller/controller.dart';
import 'package:ikiadim/view/list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Controller().setSecureKey();
  await Controller().initTheBox();
  await Controller().openTheBox();
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
