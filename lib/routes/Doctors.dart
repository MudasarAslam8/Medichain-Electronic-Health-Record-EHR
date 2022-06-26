import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medichain/classes/DoctorModel.dart';
import 'package:medichain/classes/StaticData.dart';
import 'package:medichain/widgets/CustomDrawer.dart';
import 'package:medichain/widgets/DoctorTile.dart';
import 'package:web3dart/web3dart.dart';

class Doctors extends StatefulWidget {
  final Web3Client web3client;
  const Doctors({Key? key, required this.web3client}) : super(key: key);

  @override
  _DoctorsState createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  bool userStatus = false;
  String mybalance = "0";
  String etheradress = "";
  bool initialized = false;
  String cityname = "";
  bool OpenList = false;
  String specialist = "";
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

  void getCityName() async {
    Credentials credentials = await widget.web3client
        .credentialsFromPrivateKey(StaticData.privateKey);
    EthereumAddress address = await credentials.extractAddress();
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract);
    String abi = await getJson();
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction function = contract.function('getCityName');
    var cityname = await widget.web3client.call(
        contract: contract, function: function, params: [], sender: address);
    setState(() {
      this.cityname = cityname[0].toString();
    });
    print('cityname : ${cityname}');
  }

  Future<List<DoctorModel>> getSpecialistsFromCity() async {
    List<DoctorModel> doctors = [];
    print('hello');
    Credentials credentials = await widget.web3client
        .credentialsFromPrivateKey(StaticData.privateKey);
    EthereumAddress address = await credentials.extractAddress();
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract);
    String abi = await getJson();
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction function =
        contract.function('getDoctorSpecialistInTheCity');
    var specialists = await widget.web3client.call(
        contract: contract,
        function: function,
        params: ['Multan', specialist],
        sender: address);
    specialists = specialists[0];
    for (var i in specialists) {
      DoctorModel model = DoctorModel(
          name: i[0].toString(),
          address: i[1].toString(),
          gender: i[2].toString(),
          experience: i[3].toString(),
          hospitalAddress: i[4].toString(),
          specialist: i[5].toString());
      doctors.add(model);
    }
    print(doctors);
    doctors.shuffle();
    return doctors;
  }

  void getHospital() async {
    Credentials credentials = await widget.web3client
        .credentialsFromPrivateKey(StaticData.privateKey);
    EthereumAddress address = await credentials.extractAddress();
    final EthereumAddress contractAddr =
        EthereumAddress.fromHex(StaticData.contract);
    String abi = await getJson();
    final contract =
        DeployedContract(ContractAbi.fromJson(abi, 'testchain'), contractAddr);
    ContractFunction function = contract.function('getHospital');
    var Hospitals = await widget.web3client.call(
        contract: contract,
        function: function,
        params: ['0xabfff912e2370c15ac7627652f93a70df8b19288'],
        sender: address);
    print('Hospitals : ${Hospitals}');
  }

  void closeList() {
    setState(() {
      OpenList = false;
    });
  }

  void openList(String _specialist) {
    setState(() {
      OpenList = true;
      specialist = _specialist;
    });
  }

  void setSpecialist(String _specialist) {
    setState(() {
      specialist = _specialist;
    });
    print(specialist);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (!initialized) {
        getBalance();
        isUserRegisted();
        getCityName();
        //getSpecialistsFromCity();
      }
    });
    return Scaffold(
      body: !OpenList
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                // Generate 100 widgets that display their index in the List.
                children:
                    List.generate(StaticData.Specilizaion.length, (index) {
                  return InkWell(
                    onTap: () =>
                        {setSpecialist(StaticData.SpecilizaionKey[index])},
                    child: DoctorService(
                      function: openList,
                      specialization: StaticData.Specilizaion[index],
                      sKey: StaticData.SpecilizaionKey[index],
                    ),
                  );
                }),
              ),
            )
          : FutureBuilder(
              future: getSpecialistsFromCity(),
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
                            return DoctorTile(model: snapshot.data[index]);
                          });
                }
              }),
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

class DoctorService extends StatelessWidget {
  final String specialization;
  final String sKey;
  final function;
  const DoctorService(
      {Key? key,
      required this.specialization,
      required this.function,
      required this.sKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () => function(sKey),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.health_and_safety),
              SizedBox(
                height: 10,
              ),
              Text(specialization)
            ],
          ),
        ),
      ),
    );
  }
}
