import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class QRCodePage extends StatefulWidget {
  final String etherAdresss;
  const QRCodePage({Key? key, required this.etherAdresss}) : super(key: key);

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: QrImage(
          data: widget.etherAdresss,
          size: MediaQuery.of(context).size.width / 2,
        ),
      ),
    );
  }
}
