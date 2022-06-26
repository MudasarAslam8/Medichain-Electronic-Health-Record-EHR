// its a route

import 'package:flutter/material.dart';
import 'package:medichain/routes/testProfile.dart';
import 'package:medichain/widgets/cutsomIconButton.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medichain/routes/ProfilePage.dart';

class HomePageUI extends StatefulWidget {
  final Web3Client ethClient;
  const HomePageUI({Key? key, required Web3Client this.ethClient})
      : super(key: key);

  @override
  _HomePageUIState createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> {
  @override
  Widget build(BuildContext context) {
    Container container1 = Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
                top: -10,
                right: 10,
                child: Container(
                  width: (MediaQuery.of(context).size.width / 100) * 50,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: SvgPicture.asset('assets/doctor.svg'),
                )),
            Positioned(
              top: MediaQuery.of(context).size.width / 3,
              left: MediaQuery.of(context).size.width / 15,
              child: Text(
                'Medichain',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.width / 2,
              left: MediaQuery.of(context).size.width / 20,
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                child: SvgPicture.asset('assets/record.svg'),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.width / 2.2,
              left: MediaQuery.of(context).size.width / 13,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                    'A decenterlized solution to keep track of your medical history, so you can live carefree and happily'),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3,
              left: MediaQuery.of(context).size.width / 13,
              child: CustomIconButton(
                icon: Icons.medication,
                text: 'Open Dapp',
                pressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TestWalletPage(
                                ethClient: widget.ethClient,
                              )));
                },
                border: 10,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 1.6,
              left: MediaQuery.of(context).size.width / 2,
              child: Text(
                'Access Control',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 1.48,
              left: MediaQuery.of(context).size.width / 2,
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Text(
                    'Your data is your asset, access it from anywhere, we keep it transparent to world, so you be confident to what matters to you'),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 1.2,
              left: MediaQuery.of(context).size.width / 2,
              child: CustomIconButton(
                icon: Icons.remove_red_eye,
                text: 'Learn more',
                pressed: () {},
                border: 10,
              ),
            )
          ],
        ));
    Container container2 = Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  width: (MediaQuery.of(context).size.width / 100) * 50,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: SvgPicture.asset('assets/right.svg'),
                )),
            Positioned(
              top: MediaQuery.of(context).size.width / 3,
              left: MediaQuery.of(context).size.width / 20,
              child: Text(
                'Gain what you owns',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.width / 2.2,
              left: MediaQuery.of(context).size.width / 13,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                    "Your data, is your property. you own it. Our solution puts your medical reports next to you without allowing a third party to interfere with it. You have absoulte access of your data, your privacy"),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3.1,
              left: MediaQuery.of(context).size.width / 13,
              child: Container(
                width: MediaQuery.of(context).size.height / 4,
                child: SvgPicture.asset('assets/eth.svg'),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height / 1.32,
                right: 20,
                child: CustomIconButton(
                  icon: Icons.send,
                  pressed: () {},
                  text: 'Explore Dapp',
                  border: 10,
                ))
          ],
        ));
    Container container3 = Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                child: SvgPicture.asset(
                  'assets/control.svg',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2,
              left: MediaQuery.of(context).size.width / 13,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Validate the reports',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text(
                        'Our solution promises the valid reports and reduces the chance of document forgery or fake reports.\n The smart contract takes care of what is fake or valid. Every transaction can be validated by public key, so making the medical reports acceptable to anyone'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Access the data around the world',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text(
                        'No matter where you live, where you go for treatment, you can gain the access of your medical reports from our smart contract'),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 1.2,
              right: 20,
              child: Container(
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.height / 10,
                child: SvgPicture.asset('assets/world.svg'),
              ),
            )
          ],
        ));
    Container container4 = Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 10,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 3,
                child: SvgPicture.asset(
                  'assets/analyse.svg',
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3,
              left: MediaQuery.of(context).size.width / 13,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Text(
                      'Deep Analysis to our smart contract',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text('Our Smart contract runs on Polygon Matic Mainet, allowing everyone to distribute data on blockchain using minimum gas fee and high throughput.' +
                        '\n \n Our Smart contract has following features' +
                        '\n \n 1) Medicine supply chain, allowing you to find the medicine availible in any store of the city' +
                        '\n \n 2) Stores the medical reports hosted over trusted IPFS nodes, so that you can access them anywhere, anytime' +
                        '\n \n 3) Stores the information about hospitals,doctors, labortries and patient' +
                        '\n \n 4) ERC-20 token for the payment purposes' +
                        '\n \n 5) Salt and pharmaceutical medicines information' +
                        '\n \n 6) Track the medical specialists to meet your requirment'),
                  )
                ],
              ),
            )
          ],
        ));
    Container container5 = Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  width: (MediaQuery.of(context).size.width / 100) * 50,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: SvgPicture.asset('assets/connection.svg'),
                )),
            Positioned(
              top: MediaQuery.of(context).size.width / 3,
              left: MediaQuery.of(context).size.width / 20,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Text(
                  'Accessable to Developers',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3.5,
              left: MediaQuery.of(context).size.width / 13,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Text("Being decenterilized in nature, we are welcoming all developers around the world to build DAPPs on our smart contract, to maximaize the scalability of our solution to meet the requirments of end user" +
                    "\n \n Developers can use our API to integrate our services on their existing or upcoming system," +
                    "so that anyone can take part in our very long ledger and make medical services available to anyone around the world"),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3.1,
              left: MediaQuery.of(context).size.width / 13,
              child: Container(
                width: MediaQuery.of(context).size.height / 5,
                child: SvgPicture.asset('assets/sdk.svg'),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height / 1.32,
                right: 20,
                child: Column(
                  children: [
                    CustomIconButton(
                      icon: Icons.send,
                      pressed: () {},
                      text: 'node js docs',
                      border: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomIconButton(
                      icon: Icons.send,
                      pressed: () {},
                      text: 'flutter docs',
                      border: 10,
                    )
                  ],
                ))
          ],
        ));
    List<Container> containers = [
      container1,
      container2,
      container3,
      container4,
      container5
    ];
    return Scaffold(
        body: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 5,
            itemBuilder: (_, index) {
              return containers[index];
            }));
  }
}
