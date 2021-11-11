import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ikiadim/controller/controller.dart';
import 'package:ikiadim/model/custom_color.dart';
import 'package:ikiadim/view/list.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['DSN'];
      options.environment = "profile";
    },
    appRunner: () async {
      try {
        await Controller().setSecureKey();
        await Controller().initTheBox();
        await Controller().openTheBox();
      } on Exception catch (exception, stackTrace) {
        await Sentry.captureException(
          exception,
          stackTrace: stackTrace,
        );
      }
      runApp(const MyApp());
    },
  );
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
