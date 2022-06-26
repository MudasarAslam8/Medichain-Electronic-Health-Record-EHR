import 'package:flutter/material.dart';
import 'package:medichain/routes/Doctors.dart';
import 'package:medichain/routes/Hospitals.dart';
import 'package:medichain/routes/Insurance.dart';
import 'package:medichain/routes/Medicines.dart';
import 'package:medichain/routes/Prescriptions.dart';
import 'package:medichain/routes/ProfilePage.dart';
import 'package:medichain/routes/TransferFunds.dart';
import 'package:medichain/routes/reports.dart';
import 'package:web3dart/web3dart.dart';

class CustomDrawer extends StatefulWidget {
  final String etheraddress;
  final Web3Client ethClient;
  const CustomDrawer(
      {Key? key, required this.etheraddress, required this.ethClient})
      : super(key: key);
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 30,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                minRadius: 40,
                maxRadius: 40,
                backgroundImage: NetworkImage(
                    "https://avatars.dicebear.com/api/avataaars/${widget.etheraddress}sdjkjdl.png"),
              ),
              SizedBox(
                height: 10,
              ),
              Text(widget.etheraddress),
              SizedBox(
                height: 10,
              ),
              Divider(),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Hospitals(
                                web3client: widget.ethClient,
                              )))
                },
                child: ListTile(
                  title: Text("Find Hospitals"),
                  trailing: Icon(Icons.local_hospital),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Doctors(
                                web3client: widget.ethClient,
                              )))
                },
                child: ListTile(
                  title: Text("Find Doctors"),
                  trailing: Icon(Icons.people_outline),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Medicines(
                                web3client: widget.ethClient,
                              )))
                },
                child: ListTile(
                    title: Text("Find Medicines"),
                    trailing: Icon(Icons.medical_services)),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MedicalReports(
                                web3client: widget.ethClient,
                              )))
                },
                child: ListTile(
                  title: Text("Get Medical Reports"),
                  trailing: Icon(Icons.report),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Prescriptions(
                                web3client: widget.ethClient,
                              )))
                },
                child: ListTile(
                    title: Text("Get Doctor Prescriptions"),
                    trailing: Icon(Icons.pages)),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransferFunds(
                                ethClient: widget.ethClient,
                              )))
                },
                child: ListTile(
                    title: Text("Transfer Funds"), trailing: Icon(Icons.money)),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Insurance(
                                web3client: widget.ethClient,
                              )))
                },
                child: ListTile(
                    title: Text("Health Insurrance"),
                    trailing: Icon(Icons.health_and_safety)),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WalletPage(
                                ethClient: widget.ethClient,
                              )))
                },
                child: ListTile(
                  title: Text("Profile"),
                  trailing: Icon(Icons.person),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
