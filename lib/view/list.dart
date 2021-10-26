import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
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
    );
  }

  FloatingActionButton fabMethod() {
    return const FloatingActionButton(
      onPressed: null,
      tooltip: 'Increment',
      child: Icon(Icons.qr_code),
    );
  }

  Center bodyMethod() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('Hello world'),
        ],
      ),
    );
  }
}
