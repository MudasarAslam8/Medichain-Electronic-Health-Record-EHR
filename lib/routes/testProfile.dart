import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medichain/classes/StaticData.dart';
import 'package:medichain/pages/ProfileInfo.dart';
import 'package:medichain/pages/SIgnUp.dart';
import 'package:medichain/routes/Hospitals.dart';
import 'package:medichain/routes/TransferFunds.dart';
import 'package:medichain/routes/reports.dart';
import 'package:medichain/widgets/CustomDrawer.dart';
import 'package:medichain/widgets/cutsomIconButton.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' show join, dirname;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:medichain/widgets/imageAsset.dart';
import 'package:web3dart/web3dart.dart';

class TestWalletPage extends StatefulWidget {
  final Web3Client ethClient;
  const TestWalletPage({Key? key, required this.ethClient}) : super(key: key);

  @override
  _TestWalletPageState createState() => _TestWalletPageState();
}

class _TestWalletPageState extends State<TestWalletPage> {
  Future<String> getJson() async {
    final String response = await rootBundle.loadString('assets/abc.json');
    //final data = await jsonDecode(response);
    return response;
  }

  bool userStatus = false;
  String mybalance = "0";
  String etheradress = "";
  bool initialized = false;
  @override
  Widget build(BuildContext context) {
    void getBalance() async {
      print("getting balance");
      Credentials credentials = await widget.ethClient
          .credentialsFromPrivateKey(StaticData.privateKey);
      EthereumAddress address = await credentials.extractAddress();
      print(address);
      EtherAmount balance = await widget.ethClient.getBalance(address);
      print(balance.getInEther);
      setState(() {
        mybalance = balance.getInEther.toString();
        etheradress = address.toString();
        initialized = true;
      });
      print(etheradress);
    }

    void isUserRegisted() async {
      print('wait');
      Credentials credentials = await widget.ethClient
          .credentialsFromPrivateKey(StaticData.privateKey);
      EthereumAddress address = await credentials.extractAddress();
      String abi = await getJson();
      final EthereumAddress contractAddr =
          EthereumAddress.fromHex(StaticData.contract);
      final contract = DeployedContract(
          ContractAbi.fromJson(abi, 'testchain'), contractAddr);
      ContractFunction function = contract.function('isPersonRegistered');
      var isRegistered = await widget.ethClient.call(
          sender: address, contract: contract, function: function, params: []);
      print(isRegistered);
      setState(() {
        userStatus = isRegistered[0];
      });
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!initialized) {
        getBalance();
        isUserRegisted();
      }
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('Medichain'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              isUserRegisted();
            });
          },
        ),
        drawer: CustomDrawer(
          etheraddress: etheradress,
          ethClient: widget.ethClient,
        ),
        body: Container(
            child: userStatus
                ? ProfileInfo(
                    userAddress: etheradress,
                    ethClient: widget.ethClient,
                  )
                : Text('')));
  }
}
