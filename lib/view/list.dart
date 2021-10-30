import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikiadim/controller/controller.dart';
import 'package:ikiadim/model/onetimepass.dart';
import 'package:ikiadim/view/add.dart';
import 'package:ikiadim/view/block.dart';
import 'package:otp/otp.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  double _value = Controller().counterValue();
  late Timer _timer;
  final int _time = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _timer = _updateTimer();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBarMethod(),
        body: _bodyMethod(),
        floatingActionButton: _fabMethod(),
      );

  AppBar _appBarMethod() => AppBar(
        title: const Text("2 ADIM"),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(18),
          child: CircularProgressIndicator(
            value: _value,
            color: _value <= .1 ? Colors.orange : Colors.white,
            backgroundColor: Colors.black87,
            strokeWidth: 4,
          ),
        ),
      );

  FloatingActionButton _fabMethod() => FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScannerPage()),
        ),
        child: const Icon(Icons.qr_code),
      );

  ValueListenableBuilder _bodyMethod() => ValueListenableBuilder(
        valueListenable: Hive.box<OneTimePassword>(HiveBoxes.box).listenable(),
        builder: (context, box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("Listeniz boş"),
            );
          }
          return _listViewMethod(box);
        },
      );

  ListView _listViewMethod(box) => ListView.builder(
        itemCount: box.values.length,
        itemBuilder: (context, index) {
          OneTimePassword? otp = box.getAt(index);
          return _dismissMethod(otp);
        },
      );

  Dismissible _dismissMethod(OneTimePassword? otp) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          alignment: AlignmentDirectional.centerEnd,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Icon(
              Icons.delete_forever_sharp,
              color: Colors.white,
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          _timer.cancel;
          return await showDialog(
            context: context,
            builder: (BuildContext context) => _dismissDialogMethod(otp),
          );
        },
        child: _listTileMethod(otp),
      );

  AlertDialog _dismissDialogMethod(
    OneTimePassword? otp,
  ) =>
      AlertDialog(
        title: const Text("Onaylayın"),
        content: const Text(
          "Bu veriyi sildiğinizde bir daha geri getiremeyeceksiniz. Emin misiniz?",
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              otp!.delete();
              Navigator.of(context).pop(true);
              _timer = _updateTimer();
            },
            child: const Text(
              "SİL",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              _timer = _updateTimer();
            },
            child: const Text("İPTAL"),
          )
        ],
      );

  ListTile _listTileMethod(OneTimePassword? otp) =>
      otp!.type == Password.totp ? totpTile(otp) : hotpTile(otp);

  ListTile totpTile(OneTimePassword otp) => ListTile(
        title: Text(otp.label),
        subtitle: Text(OTP.generateTOTPCodeString(
          otp.secret,
          _time,
          length: otp.length!,
          interval: otp.interval!,
          algorithm: Controller().toAlgorithm(otp.algorithm!),
          isGoogle: true,
        )),
      );

  ListTile hotpTile(OneTimePassword otp) => ListTile(
        title: Text(otp.label),
        subtitle: Text(OTP.generateHOTPCodeString(
          otp.secret,
          otp.counter!,
          length: otp.length!,
          algorithm: Controller().toAlgorithm(otp.algorithm!),
        )),
        trailing: IconButton(
          onPressed: () {
            int counter = otp.counter!;
            otp.box!.put("counter", counter++);
          },
          icon: const Icon(Icons.add_circle_outline),
        ),
      );

  Future<void> _initPlatformState() async {
    bool jailbroken;
    bool developerMode;

    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    if (!mounted) return;

    if (jailbroken || developerMode) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BlockPage()),
      );
    }
  }

  Timer _updateTimer() => Timer.periodic(const Duration(seconds: 1),
      (timer) => setState(() => _value = Controller().counterValue()));
}
