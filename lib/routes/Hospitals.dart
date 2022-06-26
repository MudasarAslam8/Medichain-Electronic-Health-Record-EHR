import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medichain/classes/HospitalModel.dart';
import 'package:medichain/classes/StaticData.dart';
import 'package:medichain/widgets/CustomDrawer.dart';
import 'package:medichain/widgets/HospitalTitle.dart';
import 'package:medichain/widgets/cutsomIconButton.dart';
import 'package:web3dart/web3dart.dart';

class Hospitals extends StatefulWidget {
  final Web3Client web3client;
  const Hospitals({Key? key, required this.web3client}) : super(key: key);

  @override
  _HospitalsState createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
  bool userStatus = false;
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
    Credentials credentials = await widget.web3client
        .credentialsFromPrivateKey(StaticData.privateKey);
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

  Future<List<HospitalData>> getHospitalList() async {
    List<HospitalData> hospitals = [];
    Credentials credentials = await widget.web3client
        .credentialsFromPrivateKey(StaticData.privateKey);
    EthereumAddress address = await credentials.extractAddress();
    String abi = await getJson();
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract);
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction function = contract.function('getHospitalsFromTheCity');
    var hospitalList = await widget.web3client.call(
        sender: address,
        contract: contract,
        function: function,
        params: ['Multan']);
    for (var hospital in hospitalList) {
      for (var hos in hospital) {
        HospitalData data = HospitalData(
            hospitalName: hos[0].toString(),
            hospitalLocation: hos[1].toString(),
            hospitalAddress: hos[2].toString());
        hospitals.add(data);
      }
    }
    print(hospitalList);
    print("done");
    return hospitals;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!initialized) {
        getBalance();
        isUserRegisted();
        //getHospitalList();
      }
    });
    return Scaffold(
      body: FutureBuilder(
        future: getHospitalList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return HospitalTile(model: snapshot.data[index]);
            },
          );
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
