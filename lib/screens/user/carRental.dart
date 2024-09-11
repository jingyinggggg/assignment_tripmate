// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:assignment_tripmate/APIConnection.dart';
// import 'package:http/http.dart' as http;

// class CarRentalScreen extends StatefulWidget {
//   @override
//   _CarRentalScreenState createState() => _CarRentalScreenState();
// }

// class _CarRentalScreenState extends State<CarRentalScreen> {
//   String? _token;
//   bool _isLoading = true;
//   List<dynamic> _carDetails = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchToken();
//   }

//   Future<void> _fetchToken() async {
//     String? token = await getAmadeusToken(); // Replace with your token retrieval method
//     if (token != null) {
//       setState(() {
//         _token = token;
//         _fetchCarDetails(); // Fetch car details once token is retrieved
//       });
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//       // Handle token retrieval failure
//     }
//   }

//   Future<void> _fetchCarDetails() async {
//     String location = "KUL"; // Example: Kuala Lumpur Airport code for Malaysia

//     try {
//       final cars = await fetchCarDetails(_token!, location);
//       setState(() {
//         _carDetails = cars;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       // Handle error (display a message)
//     }
//   }

//   Future<List<dynamic>> fetchCarDetails(String token, String location) async {
//     final response = await http.get(
//       Uri.parse('https://test.api.amadeus.com/v1/shopping/availability/cars?pickupLocation=$location'),
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       List<dynamic> cars = data['data']; // Adjust this to the actual structure of Amadeus' API response

//       // Limit the results to only the first 5 cars
//       return cars.take(5).toList();
//     } else {
//       throw Exception('Failed to load car details');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Car Rental')),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _carDetails.isEmpty
//               ? Center(child: Text('No cars available'))
//               : ListView.builder(
//                   itemCount: _carDetails.length,
//                   itemBuilder: (context, index) {
//                     final car = _carDetails[index];
//                     return CarListingWidget(car: car);
//                   },
//                 ),
//     );
//   }
// }

// class CarListingWidget extends StatelessWidget {
//   final dynamic car;

//   CarListingWidget({required this.car});

//   @override
//   Widget build(BuildContext context) {
//     // Replace these with the actual field names from the Amadeus API response
//     String carModel = car['vehicleInfo']['model'] ?? "Unknown Model";
//     String carBrand = car['vehicleInfo']['brand'] ?? "Unknown Brand";
//     String provider = car['provider']['companyName'] ?? "Unknown Provider";
//     String carType = car['vehicleInfo']['category'] ?? "Unknown Type";
//     String price = car['price']['total'] ?? "Unknown Price";
//     String currency = car['price']['currency'] ?? "";
//     String imageUrl = car['vehicleInfo']['image'] ?? "https://via.placeholder.com/150"; // Placeholder image URL if not available

//     return Card(
//       margin: EdgeInsets.all(10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Image.network(imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover), // Car image
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   carModel,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 5),
//                 Text("Brand: $carBrand"),
//                 SizedBox(height: 5),
//                 Text("Provider: $provider"),
//                 SizedBox(height: 5),
//                 Text("Type: $carType"),
//                 SizedBox(height: 5),
//                 Text("Price: $price $currency / day"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


