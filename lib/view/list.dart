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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(),
      body: bodyMethod(),
      floatingActionButton: fabMethod(),
    );
  }

  AppBar appBarMethod() {
    return AppBar(
      title: const Text('2 Adım'),
      centerTitle: true,
    );
  }

  FloatingActionButton fabMethod() {
    return FloatingActionButton(
      onPressed: _testDataAdd,
      tooltip: 'Increment',
      child: const Icon(Icons.qr_code),
    );
  }

  ValueListenableBuilder bodyMethod() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<OneTimePassword>(HiveBoxes.box).listenable(),
      builder: (context, box, _) {
        if (box.values.isEmpty) {
          return const Center(
            child: Text("Listeniz boş"),
          );
        }
        return ListView.builder(
          itemCount: box.values.length,
          itemBuilder: (context, index) {
            OneTimePassword? otp = box.getAt(index);
            return ListTile(
              title: Text(otp!.label),
            );
          },
        );
      },
    );
  }

  void _testDataAdd() {
    Box<OneTimePassword> otpBox = Hive.box<OneTimePassword>(HiveBoxes.box);
    otpBox.add(OneTimePassword(
      label: "jandarma.gov.tr",
      secret: "JBSWY3DPEHPK3PXP",
      type: Password.totp,
    ));
    setState(() {});
  }
}
