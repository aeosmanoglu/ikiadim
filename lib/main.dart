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
      theme: ThemeData(
        primarySwatch: Controller().createMC(const Color(0xFF194073)),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark().copyWith(
          secondary: const Color(0xFFD9CA7E),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const ListPage(),
    );
  }
}
