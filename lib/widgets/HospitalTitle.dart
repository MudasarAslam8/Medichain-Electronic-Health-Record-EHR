import 'package:flutter/material.dart';
import 'package:medichain/classes/HospitalModel.dart';

class HospitalTile extends StatefulWidget {
  final HospitalData model;
  const HospitalTile({Key? key, required HospitalData this.model})
      : super(key: key);

  @override
  _HospitalTileState createState() => _HospitalTileState();
}

class _HospitalTileState extends State<HospitalTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hospital Name : ${widget.model.hospitalName}'),
                  Text('Hospital Location : ${widget.model.hospitalLocation}'),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Text(
                              'Hospital Address : ${widget.model.hospitalAddress}')),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
