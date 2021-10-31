import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final Box _box = Hive.box<OneTimePassword>(HiveBoxes.box);
  double _value = Controller().counterValue();
  late Timer _timer;
  int _time = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _timer = _updateTimer();
    Controller().deleteMe();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: _body(),
        floatingActionButton: _fab(),
      );

  AppBar _appBar() => AppBar(
        title: const Text("2 ADIM"),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(18),
          child: _indicator(),
        ),
      );

  CircularProgressIndicator _indicator() => CircularProgressIndicator(
        value: _value,
        color: _value <= .1 ? Colors.orange : Colors.white,
        backgroundColor: Colors.black87,
        strokeWidth: 4,
      );

  FloatingActionButton _fab() => FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScannerPage()),
        ),
        child: const Icon(Icons.qr_code),
      );

  ValueListenableBuilder _body() => ValueListenableBuilder(
        valueListenable: _box.listenable(),
        builder: (context, box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text(
                "Listeniz boş.",
                style: Theme.of(context).textTheme.headline6,
              ),
            );
          }
          return _listener(box);
        },
      );

  Listener _listener(box) => Listener(
        onPointerDown: (_) => _timer.cancel(),
        onPointerUp: (_) => _timer = _updateTimer(),
        child: _listView(box),
      );

  ListView _listView(box) => ListView.separated(
        itemCount: box.values.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          OneTimePassword? otp = box.getAt(index);
          return _dismiss(otp);
        },
      );

  Dismissible _dismiss(OneTimePassword? otp) => Dismissible(
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
          _timer.cancel();
          return await showDialog(
            context: context,
            builder: (BuildContext context) => _dialog(otp),
          );
        },
        child: _listTile(otp),
      );

  AlertDialog _dialog(OneTimePassword? otp) => AlertDialog(
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

  ListTile _listTile(OneTimePassword? otp) =>
      otp!.type == Password.totp ? _totpTile(otp) : _hotpTile(otp);

  ListTile _totpTile(OneTimePassword otp) {
    _time = DateTime.now().millisecondsSinceEpoch;
    String digits = OTP.generateTOTPCodeString(
      otp.secret,
      _time,
      length: otp.length!,
      interval: otp.interval!,
      algorithm: Controller().toAlgorithm(otp.algorithm!),
      isGoogle: true,
    );
    return ListTile(
      subtitle: Text(otp.label),
      title: Text(
        digits,
        style: GoogleFonts.robotoMono(
          textStyle: Theme.of(context).textTheme.headline3,
        ),
      ),
      onTap: () => Controller().copy2clipboard(context, digits, otp.label),
    );
  }

  ListTile _hotpTile(OneTimePassword otp) {
    String digits = OTP.generateHOTPCodeString(
      otp.secret,
      otp.counter!,
      length: otp.length!,
      algorithm: Controller().toAlgorithm(otp.algorithm!),
    );
    return ListTile(
      subtitle: Text(otp.label),
      title: Text(
        digits,
        style: GoogleFonts.robotoMono(
          textStyle: Theme.of(context).textTheme.headline3,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          otp.counter = otp.counter! + 1;
          var key = _box.keyAt(otp.key);
          _box.put(key, otp);
        },
        icon: const Icon(Icons.add_circle_outline),
      ),
      onTap: () => Controller().copy2clipboard(context, digits, otp.label),
    );
  }

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

  Timer _updateTimer() => Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() => _value = Controller().counterValue());
      });
}
