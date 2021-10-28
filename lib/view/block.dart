import 'package:flutter/material.dart';

class BlockPage extends StatelessWidget {
  const BlockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.dangerous_outlined,
                size: 48,
                color: Colors.red,
              ),
              SizedBox(height: 10),
              Text(
                "Telefonunuzun işletim sistemi orjinal değil. Güvenlik gereksinimleri sebebiyle uygulama çalışmayacaktır.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
