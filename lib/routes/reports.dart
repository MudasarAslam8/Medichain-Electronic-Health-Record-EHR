import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medichain/classes/MedicalReport.dart';
import 'package:medichain/classes/StaticData.dart';
import 'package:medichain/routes/customPdfviewer.dart';
import 'package:medichain/widgets/CustomDrawer.dart';
import 'package:web3dart/web3dart.dart';

class MedicalReports extends StatefulWidget {
  final Web3Client web3client;
  const MedicalReports({Key? key, required this.web3client}) : super(key: key);

  @override
  _MedicalReportsState createState() => _MedicalReportsState();
}

class _MedicalReportsState extends State<MedicalReports> {
  bool userStatus = true;
  String mybalance = "0";
  String etheradress = "";
  bool initialized = false;
  int selectedIndex = 0;
  Future<String> getJson() async {
    final String response = await rootBundle.loadString('assets/abc.json');

    //final data = await jsonDecode(response);
    return response;
  }

  var apiUrl = "https://api.s0.b.hmny.io/"; //Replace with your API
  void getBalance() async {
    print("getting balance");
    Credentials credentials = await widget.web3client.credentialsFromPrivateKey(
        "0xbc83f864392e04808310fd44206fbfda56c862f78a3c1e19dc83da7ee882bb0d");
    EthereumAddress address = await credentials.extractAddress();
    print(address);
    EtherAmount balance = await widget.web3client.getBalance(address);
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
    Credentials credentials = await widget.web3client
        .credentialsFromPrivateKey(StaticData.privateKey);
    EthereumAddress address = await credentials.extractAddress();
    String abi = await getJson();
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract);
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction function = contract.function('isPersonRegistered');
    var isRegistered = await widget.web3client.call(
        sender: address, contract: contract, function: function, params: []);
    print(isRegistered);
    setState(() {
      userStatus = isRegistered[0];
    });
  }

  Future<List<MedicalReportModel>> getMedicalReports() async {
    List<MedicalReportModel> reports = [];
    Credentials credentials = await widget.web3client
        .credentialsFromPrivateKey(StaticData.privateKey);
    EthereumAddress address = await credentials.extractAddress();
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract);
    String abi = await getJson();
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction function = contract.function('getMyMedicalReports');
    var myreports = await widget.web3client.call(
        contract: contract, function: function, params: [], sender: address);
    myreports = myreports[0];
    for (var report in myreports) {
      String from = report[1].toString();
      String to = report[0].toString();
      String date = report[2].toString();
      String url = report[3].toString();
      reports.add(MedicalReportModel(from: from, to: to, url: url, date: date));

      print('${from} ${to} ${date} ${url}');
    }
    print(reports[0].to);

    return reports.length > 0 ? reports : [];
  }

  void showReports() async {
    List<MedicalReportModel> reports = [];
    Credentials credentials = await widget.web3client
        .credentialsFromPrivateKey(StaticData.privateKey);
    EthereumAddress address = await credentials.extractAddress();
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract);
    String abi = await getJson();
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction function = contract.function('getMyMedicalReports');
    var myreports = await widget.web3client.call(
        contract: contract, function: function, params: [], sender: address);
    myreports = myreports[0];
    for (var report in myreports) {
      String from = report[1].toString();
      String to = report[0].toString();
      String date = report[2].toString();
      String url = report[3].toString();
      reports.add(MedicalReportModel(from: from, to: to, url: url, date: date));

      print('${from} ${to} ${date} ${url}');
    }
    print(reports[0].to);
    //print(reports[0].url);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!initialized) {
        getBalance();
        isUserRegisted();
      }
    });
    return Scaffold(
      body: false
          ? InkWell(
              onTap: () {
                showReports();
              },
              child: Center(child: Text('sjjs')))
          : FutureBuilder(
              future: getMedicalReports(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading....');
                  default:
                    if (snapshot.hasError)
                      return Text('No Reports availible right now');
                    else
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width / 1.1,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 13),
                              child: InkWell(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => customPdfPage(
                                                url: snapshot.data[index].url
                                                    .toString(),
                                              )))
                                },
                                child: Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('To: ${snapshot.data[index].to}'),
                                        Text(
                                            'From: ${snapshot.data[index].from}'),
                                        Text(
                                            'Publish Date: ${snapshot.data[index].date}'),
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
      appBar: AppBar(
        title: Text('Medichain'),
      ),
      drawer: CustomDrawer(
        etheraddress: etheradress,
        ethClient: widget.web3client,
      ),
    );
  }
}
