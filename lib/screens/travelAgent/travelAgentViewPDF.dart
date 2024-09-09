import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TravelAgentViewPDFScreen extends StatefulWidget {
  final String pdfPath;

  const TravelAgentViewPDFScreen({super.key, required this.pdfPath});

  @override
  State<TravelAgentViewPDFScreen> createState() => _TravelAgentViewPDFScreenState();
}

class _TravelAgentViewPDFScreenState extends State<TravelAgentViewPDFScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("PDF View"),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ],
      ),
      body: 
        SfPdfViewer.network(
          widget.pdfPath
        )
    );
  }
}