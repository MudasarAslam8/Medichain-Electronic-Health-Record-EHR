import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medichain/classes/StaticData.dart';
import 'package:medichain/pages/QRSendPage.dart';
import 'package:medichain/widgets/cutsomIconButton.dart';
import 'package:web3dart/web3dart.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FundTransferPage extends StatefulWidget {
  final Web3Client ethClient;
  final String targetAddress;
  const FundTransferPage(
      {Key? key, required this.ethClient, this.targetAddress = ""})
      : super(key: key);

  @override
  _FundTransferPageState createState() => _FundTransferPageState();
}

class _FundTransferPageState extends State<FundTransferPage> {
  Future<String> getJson() async {
    final String response = await rootBundle.loadString('assets/abc.json');
    //final data = await jsonDecode(response);
    return response;
  }

  final addressText = TextEditingController();
  final noteText = TextEditingController();
  bool initialized = false;
  void getTransactionHistory(
      EthereumAddress address, String abi, DeployedContract contract) async {
    ContractFunction history = contract.function('getTransactionHistory');
    var out = await widget.ethClient.call(
        sender: address, contract: contract, function: history, params: []);
    print(out);
  }

  void sendTransaction() async {
    Fluttertoast.showToast(
        msg: "Sending Payment, please Wait",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromRGBO(82, 38, 255, 0.7),
        textColor: Colors.white,
        fontSize: 16.0);
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract); // contract address
    Credentials credentials =
        await widget.ethClient.credentialsFromPrivateKey(StaticData.privateKey);
    //EthereumAddress address = await credentials.then((value) => value.address);
    EthereumAddress address = await credentials.extractAddress();

    EthereumAddress targetAddress = EthereumAddress.fromHex(addressText.text);
    String abi = await getJson();
    EtherAmount ammount =
        EtherAmount.inWei(BigInt.from(20 * 100000000000000000));
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction transferFunction = contract.function('sendFunds');
    DateTime now = DateTime.now();
    bool s = StaticData.isMatic;
    int id = s ? 80001 : 1666700000;
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    try {
      await widget.ethClient.sendTransaction(
          credentials,
          Transaction.callContract(
              from: address,
              contract: contract,
              value: ammount,
              function: transferFunction,
              parameters: [targetAddress, noteText.text]),
          chainId: id);
      print("Transferred");
      Fluttertoast.showToast(
          msg: "Payment transffered successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(82, 38, 255, 0.7),
          textColor: Colors.white,
          fontSize: 16.0);
      getTransactionHistory(address, abi, contract);
    } catch (Exception) {
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print('already exists');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!initialized) {
        addressText.text = widget.targetAddress;
      }
    });
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Transfer your funds',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )),
        Positioned(
          top: MediaQuery.of(context).size.height / 7,
          left: MediaQuery.of(context).size.width / 8,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 1.7,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      child: Card(
                        child: TextField(
                          controller: addressText,
                          decoration: const InputDecoration(
                              hintText: "Enter Address to destination"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      child: Card(
                        child: TextField(
                          controller: noteText,
                          decoration: const InputDecoration(
                              hintText: "Enter Purpose of transaction"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomIconButton(
                      icon: Icons.send,
                      pressed: () {
                        sendTransaction();
                      },
                      text: "Send ",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomIconButton(
                      icon: Icons.qr_code_2_outlined,
                      pressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QRSendPage(
                                    ethclient: widget.ethClient,
                                  )),
                        );
                      },
                      text: "",
                      width: 60,
                      height: 60,
                      border: 30,
                      customDimension: true,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
