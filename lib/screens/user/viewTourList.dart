import "package:assignment_tripmate/screens/user/homepage.dart";
import "package:assignment_tripmate/screens/user/viewCity.dart";
import "package:assignment_tripmate/utils.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class ViewTourListScreen extends StatefulWidget {
  final String userId;
  final String countryName;
  final String cityName;

  const ViewTourListScreen({super.key, required this.userId, required this.countryName, required this.cityName});

  @override
  State<ViewTourListScreen> createState() => _ViewTourListScreenState();
}

class _ViewTourListScreenState extends State<ViewTourListScreen> {
  Map<String, dynamic>? cityData;
  List<UserViewTourList> _tourList = [];
  List<UserViewTourList> _foundedTour = [];
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    _fetchCityImage();
    _fetchTourList();
    setState(() {
      _foundedTour = _tourList;
    });
  }

  Future<void> _fetchTourList() async {
    try {
      CollectionReference tourListRef = FirebaseFirestore.instance.collection('tourPackage');
      QuerySnapshot querySnapshot = await tourListRef
                                      .where('countryName', isEqualTo: widget.countryName)
                                      .where('cityName', isEqualTo: widget.cityName)
                                      .where('isPublish', isEqualTo: 1)
                                      .get();
      
      if(querySnapshot.docs.isNotEmpty){

        _tourList = querySnapshot.docs.map((doc) {
          return UserViewTourList(
            doc['tourName'],
            doc['tourID'],
            doc['tourCover'],
            doc['agency'],
            doc['tourHighlight'],
            doc['availability'],
          );
        }).toList();
      }

      setState(() {
        _foundedTour = _tourList;
      });
    } catch (e) {
      setState(() {
      });
      print('Error fetching tour data: $e');
    }
  }

  Future<void> _fetchCityImage() async {
    setState((){
      _isLoading = true;
    });

    try {
      DocumentReference cityRef = FirebaseFirestore.instance.collection('countries').doc(widget.countryName).collection('cities').doc(widget.cityName);
      DocumentSnapshot citySnapshot = await cityRef.get();

      if (citySnapshot.exists) {
        setState(() {
          cityData = citySnapshot.data() as Map<String, dynamic>;
          _isLoading = false; // Image is fetched, stop loading
        });
      } else {
        setState(() {
          _isLoading = false; // No city image found, stop loading
        });
        print("No matching cities found");
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Handle error and stop loading
      });
      print('Error fetching city data: $e');
    }
  }

  // void onSearch(String search) {
  //   setState(() {
  //     _foundedTour = _tourList
  //         .where((country) =>
  //             country.countryName.toUpperCase().contains(search.toUpperCase()))
  //         .toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Group Tour"),
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => ViewCityScreen(userId: widget.userId, countryName: widget.countryName,))
            );
          },
        ),
      ),

      body: Stack(
        children: [
          if (_isLoading) // Show loader while fetching the image
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (cityData?['cityImage'] != null) ...[
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(cityData!['cityImage']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.center, // Center the search bar
                child: Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueGrey, width: 2), // Set the border color
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueGrey, width: 2), // Border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF467BA1), width: 2), // Border when focused
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red, width: 2), // Red border for error state
                      ),
                      hintText: "Search tour package in ${cityData!['city_name']} ...",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
          ] else ...[
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: const Center(
                child: Text(
                  'No Image Available',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],

          Container(
            padding: EdgeInsets.only(right: 10, left: 10, top:230),
            child: ListView.builder(
              itemCount: _foundedTour.length,
              itemBuilder: (context, index) {
                return tourListComponent(tour: _foundedTour[index]);
              }
            ),
          ),
        ]
      )

    );
  }

Widget tourListComponent({required UserViewTourList tour}) {
  // Find the cheapest price from the availability list
  double cheapestPrice = double.infinity; // Start with a high value
  if (tour.availability.isNotEmpty) {
    cheapestPrice = tour.availability
        .map((item) => item['price'])
        .where((price) => price != null)
        .fold<double>(double.infinity, (currentMin, price) => price < currentMin ? price : currentMin);
  }

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1.5, color: const Color(0xFF467BA1)),
    ),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children to the same height
        children: [
          Container(
            width: 105,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(tour.image),
                fit: BoxFit.cover, // Ensure the image covers the available space
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              border: const Border(
                right: BorderSide(color: Color(0xFF467BA1), width: 1.5),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.tourName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Agency : ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        tour.agency,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        maxLines: null,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.justify,
                      ),
                    ]
                  ),
                  const SizedBox(height: 10),
                  // Displaying tour highlights
                  ...tour.tourHighlight.map((highlight) {
                    final no = highlight["no"] ?? 'No Numbering';
                    final description = highlight["description"] ?? 'No Description';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          Text(
                            "$no. ",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Expanded(
                            child: Text(
                              description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.justify,
                              maxLines: null, 
                              overflow: TextOverflow.visible, 
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 10),
                  if (cheapestPrice < double.infinity) // Display only if a price is found
                    Text(
                      "Cheapest Price: \$${cheapestPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


}