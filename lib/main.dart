import 'package:flutter/material.dart';
import 'package:ikiadim/controller/controller.dart';
import 'package:ikiadim/model/custom_color.dart';
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
        colorScheme: const ColorScheme.light().copyWith(
          primary: CustomColors().primarySwatch,
          secondary: CustomColors().primarySwatch.shade400,
          onSecondary: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark().copyWith(
          secondary: CustomColors().secondarySwatch,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const ListPage(),
    );
  }
}
