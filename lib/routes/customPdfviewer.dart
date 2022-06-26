import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class customPdfPage extends StatefulWidget {
  final String url;
  const customPdfPage({Key? key, required this.url}) : super(key: key);

  @override
  _customPdfPageState createState() => _customPdfPageState();
}

class _customPdfPageState extends State<customPdfPage> {
  late PdfViewerController controller;
  @override
  void initState() {
    controller = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfPdfViewer.network(
        widget.url,
        controller: controller,
      ),
    );
  }
}
