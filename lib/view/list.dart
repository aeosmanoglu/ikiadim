import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikiadim/controller/progress.dart';
import 'package:ikiadim/model/onetimepass.dart';
import 'package:ikiadim/view/add.dart';
import 'package:ikiadim/view/block.dart';
import 'package:get/get.dart';
import 'package:otp/otp.dart';

class ListPage extends StatelessWidget {
  ListPage({Key? key}) : super(key: key);

  final Controller _controller = Get.put(Controller());

  Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode;

    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    (jailbroken || developerMode)
        ? Get.to(() => const BlockPage())
        : _controller.timer();
  }

  @override
  Widget build(BuildContext context) {
    initPlatformState();
    deleteMe();

    return Scaffold(
      appBar: _appBarMethod(),
      body: _bodyMethod(context),
      floatingActionButton: _fabMethod(),
    );
  }

  AppBar _appBarMethod() => AppBar(
        title: const Text("2 ADIM"),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(18.0),
          child: GetBuilder<Controller>(
            builder: (_) => CircularProgressIndicator(
              value: _.counter,
              color: Colors.white,
              backgroundColor: Colors.black87,
            ),
          ),
        ),
      );

  FloatingActionButton _fabMethod() => FloatingActionButton(
        onPressed: () => Get.to(() => const AddOTPPage()),
        child: const Icon(Icons.qr_code),
      );

  ValueListenableBuilder _bodyMethod(context) => ValueListenableBuilder(
        valueListenable: Hive.box<OneTimePassword>(HiveBoxes.box).listenable(),
        builder: (context, box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("Listeniz boş"),
            );
          }
          return _listViewMethod(box, context);
        },
      );

  ListView _listViewMethod(
    box,
    context,
  ) =>
      ListView.builder(
        itemCount: box.values.length,
        itemBuilder: (context, index) {
          OneTimePassword? otp = box.getAt(index);
          return _dismissMethod(otp, context);
        },
      );

  Dismissible _dismissMethod(
    OneTimePassword? otp,
    BuildContext context,
  ) =>
      Dismissible(
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
          return await showDialog(
            context: context,
            builder: (BuildContext context) => _dismissDialogMethod(
              otp,
              context,
            ),
          );
        },
        child: _listTileMethod(otp),
      );

  AlertDialog _dismissDialogMethod(
    OneTimePassword? otp,
    BuildContext context,
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
            },
            child: const Text("SİL", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("İPTAL"),
          )
        ],
      );

  ListTile _listTileMethod(OneTimePassword? otp) => totpTile(otp!);

  ListTile totpTile(OneTimePassword otp) {
    return ListTile(
      title: Text(otp.label),
      subtitle: Text("TODO"),
    );
  }

  /// This func creates a dummy row for debugging on every save
  deleteMe() {
    Box<OneTimePassword> otpBox = Hive.box<OneTimePassword>(HiveBoxes.box);
    otpBox.add(
      OneTimePassword(
        type: Password.totp,
        label: "label",
        secret: OTP.randomSecret(),
        algorithm: "SHA1",
        length: 6,
        interval: 30,
        counter: 0,
      ),
    );
  }
}
