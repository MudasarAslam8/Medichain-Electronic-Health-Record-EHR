import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medichain/classes/StaticData.dart';
import 'package:medichain/pages/FundHistory.dart';
import 'package:medichain/pages/FundTransferPage.dart';
import 'package:medichain/pages/QrPayment.dart';
import 'package:medichain/widgets/CustomDrawer.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class TransferFunds extends StatefulWidget {
  final Web3Client ethClient;
  final String targetAddress;
  const TransferFunds(
      {Key? key, required this.ethClient, this.targetAddress = ""})
      : super(key: key);

  @override
  _TransferFundsState createState() => _TransferFundsState();
}

class _TransferFundsState extends State<TransferFunds> {
  Future<String> getJson() async {
    final String response = await rootBundle.loadString('assets/abc.json');

    //final data = await jsonDecode(response);
    return response;
  }

  bool userStatus = false;
  String mybalance = "0";
  String etheradress = "";
  bool initialized = false;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var apiUrl = "https://api.s0.b.hmny.io/"; //Replace with your API
    void getBalance() async {
      print("getting balance");
      Credentials credentials = await widget.ethClient.credentialsFromPrivateKey(
          "0xbc83f864392e04808310fd44206fbfda56c862f78a3c1e19dc83da7ee882bb0d");
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
    List<Widget> section = [
      FundTransferPage(
        ethClient: widget.ethClient,
        targetAddress: widget.targetAddress,
      ),
      QRCodePage(
        etherAdresss: etheradress,
      ),
      FundHistory(
        ethClient: widget.ethClient,
        index: selectedIndex,
      )
    ];
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
        bottomNavigationBar: BottomNavyBar(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          selectedIndex: selectedIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            selectedIndex = index;
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.money),
              title: Text('Transfer Funds'),
              activeColor: Color.fromRGBO(82, 38, 255, 0.7),
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.qr_code_2),
                title: Text('Receive'),
                activeColor: Color.fromRGBO(82, 38, 255, 0.7)),
            BottomNavyBarItem(
                icon: Icon(Icons.history),
                title: Text('Fund History'),
                activeColor: Color.fromRGBO(82, 38, 255, 0.7)),
          ],
        ),
        drawer: CustomDrawer(
          etheraddress: etheradress,
          ethClient: widget.ethClient,
        ),
        body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: userStatus ? section[selectedIndex] : Text('registerd')));
  }
}
