import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medichain/widgets/CustomDrawer.dart';
import 'package:web3dart/web3dart.dart';

class Insurance extends StatefulWidget {
  final Web3Client web3client;
  const Insurance({Key? key, required this.web3client}) : super(key: key);

  @override
  _InsuranceState createState() => _InsuranceState();
}

class _InsuranceState extends State<Insurance> {
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
    Credentials credentials = await widget.web3client.credentialsFromPrivateKey(
        "0xbc83f864392e04808310fd44206fbfda56c862f78a3c1e19dc83da7ee882bb0d");
    EthereumAddress address = await credentials.extractAddress();
    String abi = await getJson();
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex('0xE357f0e98a61724Fe92F041B38c6134e18e1c8dE');
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!initialized) {
        getBalance();
        isUserRegisted();
      }
    });
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Text('The section under development, it will be a DAO'),
        ),
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
