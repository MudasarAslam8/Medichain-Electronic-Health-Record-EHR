import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Function pressed;
  final String text;
  final IconData icon;
  final double width;
  final double height;
  final bool customDimension;
  final double border;
  const CustomIconButton(
      {Key? key,
      required this.pressed,
      required this.text,
      required this.icon,
      this.width = 0,
      this.height = 0,
      this.border = 0,
      this.customDimension = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: customDimension ? width : MediaQuery.of(context).size.width / 3,
      height:
          customDimension ? height : MediaQuery.of(context).size.height / 15,
      decoration: BoxDecoration(
          color: Color.fromRGBO(82, 38, 255, 0.7),
          borderRadius: BorderRadius.circular(border)),
      child: GestureDetector(
        onTap: () {
          pressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
            Icon(
              this.icon,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
