import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ikiadim/model/onetimepass.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddOTPPage extends StatefulWidget {
  const AddOTPPage({Key? key}) : super(key: key);

  @override
  _AddOTPPageState createState() => _AddOTPPageState();
}

class _AddOTPPageState extends State<AddOTPPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Scaffold build(BuildContext context) => Scaffold(
        appBar: _appBarMethod(),
        body: _bodyMethod(),
      );

  AppBar _appBarMethod() => AppBar(
        title: const Text('Geri'),
        centerTitle: false,
      );

  Center _bodyMethod() => Center(
        child: _qrViewMethod(context),
      );

  QRView _qrViewMethod(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 5,
          borderLength: 100,
          borderWidth: 10,
          cutOutSize: _getCutOutSize(),
        ),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );

  double _getCutOutSize() {
    Size size = MediaQuery.of(context).size;
    return (size.width < 400 || size.height < 400) ? 150.0 : 300.0;
  }

  _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      Uri? uri = Uri.tryParse(scanData.code);
      if (uri?.scheme == "otpauth") {
        late Password type;

        String label = uri?.path.substring(1) ?? "İsimsiz";
        String digit = uri?.queryParameters["digits"] ?? "6";
        String period = uri?.queryParameters["period"] ?? "30";
        String counter = uri?.queryParameters["counter"] ?? "0";
        String algorithm = uri?.queryParameters["algorithm"] ?? "SHA1";

        switch (uri?.host ?? "totp") {
          case "totp":
            type = Password.totp;
            break;
          case "hotp":
            type = Password.hotp;
            break;
          default:
            Password.totp;
        }

        //TODO: secret validation
        String secret = uri!.queryParameters["secret"]!;

        Box<OneTimePassword> otpBox = Hive.box<OneTimePassword>(HiveBoxes.box);
        otpBox.add(
          OneTimePassword(
            type: type,
            label: label,
            secret: secret,
            algorithm: algorithm,
            length: int.tryParse(digit),
            interval: int.tryParse(period),
            counter: int.tryParse(counter),
          ),
        );

        //TEST: Scaffold message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label anahtarı eklendi.')),
        );
        controller.dispose();
        Navigator.pop(context);
      }
    });
  }

  _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    debugPrint('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamera erişim izni yok')),
      );
    }
  }
}
