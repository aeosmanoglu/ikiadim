import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikiadim/model/onetimepass.dart';
import 'package:ikiadim/view/add.dart';
import 'package:ikiadim/view/block.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (jailbroken || developerMode) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BlockPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBarMethod(),
        body: _bodyMethod(),
        floatingActionButton: _fabMethod(),
      );

  AppBar _appBarMethod() => AppBar(
        title: const Text('2 ADIM'),
        centerTitle: true,
      );

  FloatingActionButton _fabMethod() => FloatingActionButton(
        onPressed: _navigate,
        tooltip: 'Increment',
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
        confirmDismiss: (direction) async => await showDialog(
          context: context,
          builder: (BuildContext context) => _dismissDialogMethod(
            otp,
            context,
          ),
        ),
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
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("İPTAL"),
          )
        ],
      );

  ListTile _listTileMethod(OneTimePassword? otp) => ListTile(
        title: Text(otp!.label),
      );

  void _navigate() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddOTPPage(),
        ),
      );
}
