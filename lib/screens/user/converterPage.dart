// import 'package:country_currency_pickers/currency_picker_dialog.dart';
// import 'package:country_currency_pickers/currency_picker_dropdown.dart';
// import 'package:country_pickers/country.dart';
// import 'package:country_pickers/utils/utils.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fluttercurrencyconverter/bloc/currency_converter/currency_converter_bloc.dart';
// // import 'package:fluttercurrencyconverter/bloc/currency_converter/currency_converter_event.dart';
// // import 'package:fluttercurrencyconverter/bloc/currency_converter/currency_converter_state.dart';
// // import 'package:fluttercurrencyconverter/screen/common/chart_widget.dart';

// class ConverterPageScreen extends StatelessWidget{
//   String _fromCurrencyCode = "USD";
//   String _toCurrencyCode = "EUR";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         padding: EdgeInsets.symmetric(vertical:20, horizontal: 20),
//         child: Column(
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.black, width: 1.5),
//               ),
//               child: TextField(
//                 style: TextStyle(fontSize: 20),
//                 textAlign: TextAlign.center,
//                 textInputAction: TextInputAction.done,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   hintText: "Amount e.g 250",
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(
//                     fontSize: 25
//                   )
//                 ),
//               )
//             ),
//             SizedBox(height:10),
//             Container(
//               child: Row(
//                 children: <Widget>[
//                   fromCurrenyItemWidget(),
//                   GestureDetector(onTap: _openCurrencyPickerDialog, child: toCurrencyItemWidget(),),
//                 ],
//               ),
//             )
//           ],
//         )
//         )
//     );
//   }

//   Widget toCurrencyItemWidget(){
//     return Row(
//       children: <Widget> [
//         Icon(Icons.keyboard_arrow_down),
//         Text(
//           _ToIOS3 = "EUR",
//         )
//       ],
//     );
//   }

//   Widget fromCurrenyItemWidget(){
//     return CurrencyPickerDropdown(
//       initialValue: "US",
//       itemBuilder: _buildDropDownItem,
//     );
//   }

//   Widget _buildDropdownItem(Country country) => Container(
//     child: Row(
//       children: <Widget>[
//         CountryPickerUtils.getDefaultFlagImage(country),
//         SizedBox(
//           width: 8.0,
//         ),
//         Text("+${country.phoneCode}(${country.isoCode})"),
//       ],
//     ),
//   );

//   void _openCurrencyPickerDialog(){
//     showDialog(context: context, 
//     builder: (_) => CurrencyPickerDialog(
//       itemBuilder: _buildDropDownItem,
//       title: Text("Convert to"),
//       isSearchable: true,
//       onValuePicked: (Country country){
//         if(mounted)
//         setState(({
//           _ToIOS3 = country.iso3Code;
//         }))
//       },
//     ));
//   }

//   // void _openCurrencyPickerDialog() => showDialog(
//   //   context: context,
//   //   builder: (context) => Theme(
//   //       data: Theme.of(context).copyWith(primaryColor: Colors.pink),
//   //       child: CurrencyPickerDialog(
//   //           titlePadding: EdgeInsets.all(8.0),
//   //           searchCursorColor: Colors.pinkAccent,
//   //           searchInputDecoration: InputDecoration(hintText: 'Search...'),
//   //           isSearchable: true,
//   //           title: Text('Select your Currency'),
//   //           onValuePicked: (Country country) =>
//   //               setState(() => _selectedDialogCountry = country),
//   //           itemBuilder: _buildCurrencyDialogItem)),
//   // );
// }