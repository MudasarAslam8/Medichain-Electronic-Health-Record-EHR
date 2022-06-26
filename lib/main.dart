import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medichain/classes/StaticData.dart';
import 'package:medichain/pages/FundTransferPage.dart';
import 'package:medichain/routes/Doctors.dart';
import 'package:medichain/routes/Hospitals.dart';
import 'package:medichain/routes/ProfilePage.dart';
import 'package:medichain/routes/TransferFunds.dart';
import 'package:medichain/routes/reports.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' show join, dirname;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'pages/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var apiUrl = "https://api.s0.b.hmny.io/"; 
    bool testMode = true;
    var httpClient = new Client();
    var ethClient = new Web3Client(
        StaticData.isMatic ? StaticData.polygon : apiUrl, httpClient);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePageUI(ethClient: ethClient),
      debugShowCheckedModeBanner: false,
    );
  }
}

