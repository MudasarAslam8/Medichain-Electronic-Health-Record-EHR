import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medichain/classes/StaticData.dart';
import 'package:web3dart/web3dart.dart';
import 'package:medichain/classes/User.dart';

class ProfileInfo extends StatefulWidget {
  final String userAddress;
  final Web3Client ethClient;
  const ProfileInfo(
      {Key? key, required String this.userAddress, required this.ethClient})
      : super(key: key);
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  bool initialized = false;
  User user = new User(
      name: "name",
      age: "age",
      gender: "gender",
      country: "country",
      accountBalance: "",
      accountType: "",
      useraddress: "");
  Future<String> getJson() async {
    final String response = await rootBundle.loadString('assets/abc.json');
    //final data = await jsonDecode(response);
    return response;
  }

  void getUserDetails() async {
    Credentials credentials =
        await widget.ethClient.credentialsFromPrivateKey(StaticData.privateKey);
    EthereumAddress address = await credentials.extractAddress();
    String abi = await getJson();
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract);
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction function = contract.function('getUserData');
    var data = await widget.ethClient.call(
        sender: address, contract: contract, function: function, params: []);
    print("wait");
    String add = address.toString();
    print(data);
    var userData = data[0];
    EtherAmount balance = await widget.ethClient.getBalance(address);
    var bal = double.parse(balance.getInWei.toString()) / 1000000000000000000;
    this.setState(() {
      user = new User(
          name: userData[0].toString(),
          age: userData[1].toString(),
          gender: userData[2].toString(),
          country: userData[3].toString(),
          useraddress: address.toString(),
          accountType: "User",
          accountBalance: bal.toString());

      initialized = true;
    });
    print(user.name);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!initialized) {
        getUserDetails();
      }
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            InfoTile(
              value: user.name,
              k: "Username",
            ),
            SizedBox(height: 10),
            InfoTile(
              value: user.age,
              k: "Age",
            ),
            SizedBox(height: 10),
            InfoTile(
              value: user.gender,
              k: "Gender",
            ),
            SizedBox(height: 10),
            InfoTile(
              value: user.country,
              k: "Country",
            ),
            SizedBox(height: 10),
            InfoTile(
              value: user.useraddress,
              k: "Address",
            ),
            SizedBox(height: 10),
            InfoTile(
              value: user.accountBalance,
              k: "Balance",
            ),
            SizedBox(height: 10),
            InfoTile(
              value: user.accountType,
              k: "Account Type",
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({Key? key, required this.k, required this.value})
      : super(key: key);

  final String k;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${k}:             ${value}'),
        ),
      ),
    );
  }
}
