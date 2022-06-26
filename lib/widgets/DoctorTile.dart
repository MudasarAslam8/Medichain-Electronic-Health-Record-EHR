import 'package:flutter/material.dart';
import 'package:medichain/classes/DoctorModel.dart';
import 'package:medichain/widgets/cutsomIconButton.dart';

class DoctorTile extends StatefulWidget {
  final DoctorModel model;
  const DoctorTile({Key? key, required this.model}) : super(key: key);

  @override
  _DoctorTileState createState() => _DoctorTileState();
}

class _DoctorTileState extends State<DoctorTile> {
  bool isOpened = false;
  void expand() {
    setState(() {
      isOpened = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isOpened
        ? DoctorDetail(model: widget.model)
        : Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: InkWell(
              onTap: () => expand(),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        minRadius: 40,
                        maxRadius: 40,
                        backgroundImage: NetworkImage(
                            "https://avatars.dicebear.com/api/male/q${widget.model.address}${widget.model.name}.png"),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Doctor Name: ${widget.model.name}'),
                          Text(
                              'Doctor Specialization: ${widget.model.specialist}')
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class DoctorDetail extends StatelessWidget {
  const DoctorDetail({
    Key? key,
    required this.model,
  }) : super(key: key);

  final DoctorModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width / 1.3,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    minRadius: 40,
                    maxRadius: 40,
                    backgroundImage: NetworkImage(
                        "https://avatars.dicebear.com/api/male/q${model.address}${model.name}.png"),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Doctor Name : ${model.name}'),
                      Text('Doctor Gender: ${model.gender}'),
                      Text('Doctor Specialization: ${model.specialist}'),
                      Text('Doctor experience: ${model.experience} years'),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Doctor Hospital Address:'),
                  InkWell(
                    onTap: () => print(model.hospitalAddress),
                    child: Container(
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(model.hospitalAddress),
                        ),
                      ),
                    ),
                  ),
                  Text('Doctor Address:'),
                  InkWell(
                    onTap: () => print(model.address),
                    child: Container(
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(model.address),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              CustomIconButton(
                pressed: () {},
                text: "Book Appointment",
                icon: Icons.medical_services,
                customDimension: true,
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                border: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
