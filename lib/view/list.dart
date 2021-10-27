import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikiadim/model/onetimepass.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBarMethod(),
        body: bodyMethod(),
        floatingActionButton: fabMethod(),
      );

  AppBar appBarMethod() => AppBar(
        title: const Text('2 Adım'),
        centerTitle: true,
      );

  FloatingActionButton fabMethod() => FloatingActionButton(
        onPressed: _testDataAdd,
        tooltip: 'Increment',
        child: const Icon(Icons.qr_code),
      );

  ValueListenableBuilder bodyMethod() => ValueListenableBuilder(
        valueListenable: Hive.box<OneTimePassword>(HiveBoxes.box).listenable(),
        builder: (context, box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text("Listeniz boş"),
            );
          }
          return listViewMethod(box);
        },
      );

  ListView listViewMethod(box) => ListView.builder(
        itemCount: box.values.length,
        itemBuilder: (context, index) {
          OneTimePassword? otp = box.getAt(index);
          return dismissMethod(otp);
        },
      );

  Dismissible dismissMethod(OneTimePassword? otp) => Dismissible(
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
          builder: (BuildContext context) => dismissDialogMethod(
            otp,
            context,
          ),
        ),
        child: listTileMethod(otp),
      );

  AlertDialog dismissDialogMethod(
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

  ListTile listTileMethod(OneTimePassword? otp) => ListTile(
        title: Text(otp!.label),
      );

  void _testDataAdd() {
    Box<OneTimePassword> otpBox = Hive.box<OneTimePassword>(HiveBoxes.box);
    otpBox.add(OneTimePassword(
      label: "jandarma.gov.tr",
      secret: "JBSWY3DPEHPK3PXP",
      type: Password.totp,
    ));
  }
}
