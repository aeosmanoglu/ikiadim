import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikiadim/controller/controller.dart';
import 'package:ikiadim/model/custom_color.dart';
import 'package:ikiadim/model/onetimepass.dart';
import 'package:ikiadim/view/add.dart';
import 'package:ikiadim/view/block.dart';
import 'package:ikiadim/view/info.dart';
import 'package:otp/otp.dart';
import 'package:safe_device/safe_device.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with WidgetsBindingObserver {
  final Box _box = Hive.box<OneTimePassword>(HiveBoxes.box);
  double _value = Controller().counterValue();
  late Timer _timer;
  int _time = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
    _initPlatformState();
    _timer = _updateTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    state == AppLifecycleState.resumed
        ? _timer = _updateTimer()
        : _timer.cancel();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InfoPage()),
            ),
          ),
        ],
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
      subtitle: Text(
        otp.label,
        style: Theme.of(context).textTheme.headline6,
      ),
      title: Text(
        digits,
        style: GoogleFonts.robotoMono(
          textStyle: Theme.of(context).textTheme.headline3,
          color: _value <= .1
              ? Colors.orange
              : CustomColors().primarySwatch.shade300,
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
      subtitle: Text(
        otp.label,
        style: Theme.of(context).textTheme.headline6,
      ),
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
    blockApp() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BlockPage()),
      );
    }

    if (await SafeDevice.isJailBroken) {
      blockApp();
    }

    if (Platform.isAndroid && await SafeDevice.isOnExternalStorage) {
      blockApp();
    }

    if (!await SafeDevice.isRealDevice) {
      Controller().addDummyData();
    }
  }

  Timer _updateTimer() => Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() => _value = Controller().counterValue());
      });
}
