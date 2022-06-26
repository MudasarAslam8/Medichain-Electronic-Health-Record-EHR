import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medichain/classes/StaticData.dart';
import 'package:medichain/classes/TransactionHistory.dart';
import 'package:web3dart/web3dart.dart';

class FundHistory extends StatefulWidget {
  final Web3Client ethClient;
  final int index;
  const FundHistory(
      {Key? key, required Web3Client this.ethClient, this.index = 0})
      : super(key: key);

  @override
  _FundHistoryState createState() => _FundHistoryState();
}

class _FundHistoryState extends State<FundHistory> {
  bool initialized = false;
  Future<String> getJson() async {
    final String response = await rootBundle.loadString('assets/abc.json');
    //final data = await jsonDecode(response);
    return response;
  }

  void getTransactionHistory() async {
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract); // contract address
    Credentials credentials =
        await widget.ethClient.credentialsFromPrivateKey(StaticData.privateKey);
    //EthereumAddress address = await credentials.then((value) => value.address);
    EthereumAddress address = await credentials.extractAddress();
    String abi = await getJson();
    EtherAmount ammount =
        EtherAmount.inWei(BigInt.from(20 * 100000000000000000));
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction history = contract.function('getTransactionHistory');
    var out = await widget.ethClient.call(
        sender: address, contract: contract, function: history, params: []);
    //print(out);
  }

  Future<List<Record>> newFundHistory() async {
    List<Record> reports = [];
    Credentials credentials =
        await widget.ethClient.credentialsFromPrivateKey(StaticData.privateKey);
    EthereumAddress address = await credentials.extractAddress();
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract);
    String abi = await getJson();
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction function = contract.function('getTransactionHistory');
    var myreports = await widget.ethClient.call(
        contract: contract, function: function, params: [], sender: address);
    myreports = myreports[0];
    for (var report in myreports) {
      Record _record = Record(
          to: report[0].toString(),
          from: report[1].toString(),
          ammount: BigInt.from(2),
          note: report[2].toString());
      reports.add(_record);
    }
    print(reports[0].to);
    return reports;
  }

  Future<List<Record>> getTransactionRecord() async {
    List<Record> record = [];
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract); // contract address
    Credentials credentials =
        await widget.ethClient.credentialsFromPrivateKey(StaticData.privateKey);
    //EthereumAddress address = await credentials.then((value) => value.address);
    EthereumAddress address = await credentials.extractAddress();
    String abi = await getJson();
    EtherAmount ammount =
        EtherAmount.inWei(BigInt.from(20 * 100000000000000000));
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction history = contract.function('getTransactionHistory');
    var out = await widget.ethClient.call(
        sender: address, contract: contract, function: history, params: []);
    var json = out[0];
    //print(json);
    for (int i = 0; i < out.length; i++) {
      var list = out[i];
      for (var l in list) {
        Record _record = Record(
            to: l[0].toString(),
            from: l[1].toString(),
            ammount: BigInt.from(2),
            note: l[2].toString());
        record.add(_record);
      }
    }
    //print(out[0]);
    return record;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!initialized) {
        //getTransactionHistory();
      }
    });
    return Container(
      child: FutureBuilder(
        future: newFundHistory(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                        child: InkWell(
                          onTap: () => print(snapshot.data[index].note),
                          child: Card(
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('To: ${snapshot.data[index].to}'),
                                  Text('From: ${snapshot.data[index].from}'),
                                  Text(
                                      'Value: ${snapshot.data[index].ammount.toString()}'),
                                  Text('Purpose: ${snapshot.data[index].note}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
          }
        },
      ),
    );
  }
}
