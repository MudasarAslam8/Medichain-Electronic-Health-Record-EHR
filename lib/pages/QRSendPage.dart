import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medichain/pages/FundTransferPage.dart';
import 'package:medichain/routes/TransferFunds.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:web3dart/web3dart.dart';

class QRSendPage extends StatefulWidget {
  final Web3Client ethclient;
  const QRSendPage({Key? key, required this.ethclient}) : super(key: key);

  @override
  _QRSendPageState createState() => _QRSendPageState();
}

class _QRSendPageState extends State<QRSendPage> {
  bool initialized = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  void OpenCamera() async {
    var cameraScanResult = await BarcodeScanner.scan();
    setState(() {
      initialized = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TransferFunds(
                ethClient: widget.ethclient,
                targetAddress: cameraScanResult.rawContent,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!initialized) {
        OpenCamera();
      }
    });
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Text(''),
          ),
        )
      ],
    ));
  }
}
