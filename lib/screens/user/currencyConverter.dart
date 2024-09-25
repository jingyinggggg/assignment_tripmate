import 'package:assignment_tripmate/screens/user/row_button.dart';
import 'package:flutter/material.dart';
import 'package:assignment_tripmate/screens/user/homepage.dart';

class CurrencyConverterScreen extends StatefulWidget {
  final String userId;

  const CurrencyConverterScreen({super.key, required this.userId});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {

  int _pageIndexHolder = 0;

  // List<Widget> _listPages = [ConverterPageScreen(), RatesPageScreen(), InfoPageScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Currency Converter"),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserHomepageScreen(userId: widget.userId),
              ),
            );
          },
        ),
      ),

      body: Container(
        child: Column(
          children: [
            RowButtons(
              onSave: (pageIndexValue){
                print(pageIndexValue);
                if(mounted)
                setState(() {
                  _pageIndexHolder = pageIndexValue;
                });
              },
            ),
            // Expanded(
            //   child: _listPages[_pageIndexHolder],
            // )
          ],
        )
      )
      
    );
  }
}
