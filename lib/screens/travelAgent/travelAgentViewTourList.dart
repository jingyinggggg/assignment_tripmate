import 'package:assignment_tripmate/screens/travelAgent/travelAgentAddTourPackage.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentPreviewTourPackage.dart';
import 'package:assignment_tripmate/screens/travelAgent/travelAgentViewCity.dart';
import 'package:assignment_tripmate/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TravelAgentViewTourListScreen extends StatefulWidget {
  final String userId;
  final String countryName;
  final String cityName;

  const TravelAgentViewTourListScreen({super.key, required this.userId, required this.countryName, required this.cityName});

  @override
  State<StatefulWidget> createState() => _TravelAgentViewTourListScreenState();
}

class _TravelAgentViewTourListScreenState extends State<TravelAgentViewTourListScreen> {
  bool isLoading = true; 
  String? companyId;

  @override
  void initState() {
    super.initState();
    fetchCompanyID();
  }

  Future<void> fetchCompanyID() async {
    try {
      DocumentReference companyIDRef = FirebaseFirestore.instance.collection('travelAgent').doc(widget.userId);
      DocumentSnapshot documentSnapshot = await companyIDRef.get();

      if (documentSnapshot.exists) {
        setState(() {
          companyId = documentSnapshot.get("companyID").toString();
        });
        print('Company ID: $companyId');
      } else {
        print('No such document exists.');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching company ID: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext content) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                MaterialPageRoute(builder: (context) => TravelAgentViewCityScreen(userId: widget.userId, countryName: widget.countryName,))
              );
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 30,),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => TravelAgentAddTourPackageScreen(userId: widget.userId, countryName: widget.countryName, cityName: widget.cityName,))
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
              child: Container(
                height: 60,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF467BA1), width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    hintText: "Search tour package ...",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const TabBar(
              labelColor: Color(0xFF467BA1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF467BA1),
              tabs: [
                Tab(text: "Unpublished"),
                Tab(text: "Published")
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  // Unpublished Tab
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('tourPackage')
                        .where('countryName', isEqualTo: widget.countryName)
                        .where('cityName', isEqualTo: widget.cityName)
                        .where('companyID', isEqualTo: companyId)
                        .where('isPublish', isEqualTo: 0)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              "No unpublished tour package in the selected cities.",
                              style: TextStyle(
                                fontSize: 16
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      var tourData = snapshot.data!.docs.map((doc) => doc.data()).toList();

                      return Container(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: ListView.builder(
                          itemCount: tourData.length,
                          itemBuilder: (context, index) {
                            var tour = tourData[index];
                            return ListTile(
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Conditionally show the image
                                  if (tour['tourCover'] != null)
                                    Container(
                                      width: 70,
                                      height: 90,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(tour['tourCover']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  
                                  // If imageUrl is null, show a placeholder
                                  if (tour['tourCover'] == null)
                                    Container(
                                      width: 70,
                                      height: 90,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey[200], // Placeholder color
                                      ),
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey[600],
                                      ),
                                    ),

                                  // Tour Name
                                  Expanded(
                                    child: Text(
                                      tour['tourName'] ?? 'No Tour Name',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      // textAlign: TextAlign.justify,
                                    ),
                                  ),

                                  // Preview Button
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle preview button press
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => TravelAgentPreviewTourPackageScreen(userId: widget.userId, countryName: widget.countryName, cityName: widget.cityName, tourID: tour['tourID'])),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF467BA1),
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Preview',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  // Published Tab
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('tourPackage')
                        .where('countryName', isEqualTo: widget.countryName)
                        .where('cityName', isEqualTo: widget.cityName)
                        .where('companyID', isEqualTo: companyId)
                        .where('isPublish', isEqualTo: 1)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              "No published tour package uploaded in the selected cities.",
                              style: TextStyle(
                                fontSize: 16
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      var tourData = snapshot.data!.docs.map((doc) => doc.data()).toList();

                      return ListView.builder(
                        itemCount: tourData.length,
                        itemBuilder: (context, index) {
                          var tour = tourData[index];
                          return ListTile(
                            title: Text(tour['tourName'] ?? 'No Tour Name'),
                          );
                        },
                      );
                    },
                  ),                
                ],
              ),
            )
          ],
        )
      ),
    );
  }

    Widget tourPackageComponent({required TourPackage tourPackage}) {
    return Container(
      // color: Colors.white,
      padding: EdgeInsets.only(bottom: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 90,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  image: DecorationImage(
                    image: NetworkImage(tourPackage.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 20), // Spacing between image and text
              Text(
                tourPackage.tourName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: (){
                  // Navigator.push(
                  //   context, 
                  //   MaterialPageRoute(builder: (context) => AdminManageCityListScreen(userId: widget.userId, countryName: country.countryName))
                  // );
                }, 
                child: Text(
                  'Preview',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(20,35),
                  backgroundColor: const Color(0xFF467BA1),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}