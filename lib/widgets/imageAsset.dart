import 'package:flutter/material.dart';

class customImage extends StatelessWidget {
  final String path;
  final double top;
  final double right;
  final double width;
  final double height;
  const customImage(
      {Key? key,
      required this.path,
      this.top = 0,
      this.right = 0,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Positioned(
        top: this.top,
        right: this.right,
        child: Image.asset(path),
      ),
    );
  }
}
