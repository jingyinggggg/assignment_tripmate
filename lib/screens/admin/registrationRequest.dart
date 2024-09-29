import "package:assignment_tripmate/constants.dart";
import "package:assignment_tripmate/screens/admin/homepage.dart";
import "package:assignment_tripmate/screens/admin/manageRegistrationRequest.dart";
import "package:assignment_tripmate/utils.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class RegistrationRequestScreen extends StatefulWidget {
  final String userId;

  const RegistrationRequestScreen({super.key, required this.userId});

  @override
  State<RegistrationRequestScreen> createState() => _RegistrationRequesrScreenState();
}

class _RegistrationRequesrScreenState extends State<RegistrationRequestScreen> {
  List<TravelAgent> _TAList = [];
  // List<TravelAgent> _foundedTAList = [];

  @override
  void initState() {
    super.initState();
    fetchTAList();
  }

  Future<void> fetchTAList() async {
    try {
      // Get the reference to the 'travelAgent' collection
      CollectionReference taRef = FirebaseFirestore.instance.collection('travelAgent');
      
      // Query where 'accountApproved' is equal to 0
      QuerySnapshot querySnapshot = await taRef.where('accountApproved', whereIn: [0, 3]).get();
      
      _TAList = querySnapshot.docs.map((doc) {
        return TravelAgent(
          doc['name'], 
          doc['companyName'], 
          doc['id'],
          doc['profileImage']
        );
      }).toList();

      setState(() {
        _TAList;
      });

    } catch (e) {
      print("Error fetching travel agents list: $e");
    }
  }
  
  @override 
  Widget build(BuildContext context) { 
    return DefaultTabController( 
      length: 2, 
      child: Scaffold( 
        backgroundColor: Colors.white,
        appBar: AppBar( 
          title: Text("Registration Request"), 
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
                MaterialPageRoute(builder: (context) => AdminHomepageScreen(userId: widget.userId))
              );
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70.0), // Adjust the height as needed
            child: Container(
              height: 60,
              color: Colors.white, // Set the background color of the TabBar
              child: TabBar(
                tabs: [
                  Tab(
                    child: 
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          ImageIcon(
                            AssetImage("images/travel-agent.png"),
                            size: 35,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Travel Agent",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), 
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: ImageIcon(
                            AssetImage("images/tour-guide.png"),
                            size: 35,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Local Buddy",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
                labelColor: Color(0xFF467BA1),
                indicatorColor: Color(0xFF467BA1),
                indicatorWeight: 3,
                unselectedLabelColor: Color(0xFFA4B4C0), // Unselected tab text color
                indicatorPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelStyle: TextStyle(fontSize: defaultFontSize),
              ),
            ),
          ),
        ), 
        body: TabBarView( 
          children: [ 
            Container(
              padding: EdgeInsets.only(right: 10, left: 15, top: 10), // Adjust the top padding as needed
              child: _TAList.isEmpty
              ? Center(child: Text('No pending review registration for travel agent.', style: TextStyle(fontSize: defaultFontSize, color: Colors.black)))
              : ListView.builder(
                  itemCount: _TAList.length,
                  itemBuilder: (context, index) {
                    return TAComponent(travelAgent: _TAList[index]);
                  }
                ),
            ),
            Center( 
              child: Icon(Icons.account_circle), 
            ), 
          ], 
        ),
      ), 
    ); 
  } 

  Widget TAComponent({required TravelAgent travelAgent}){
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60, 
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF467BA1), 
                    width: 2.0, 
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(travelAgent.image),
                ),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(travelAgent.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
                  SizedBox(height: 5,),
                  Text("Agency: " + travelAgent.companyName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12))
                ],
              )
            ],
          ),
          IconButton(
            onPressed: (){
              print("UserId: ${widget.userId}, TAId: ${travelAgent.id}");
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => AdminManageRegistrationRequestScreen(userId: widget.userId, TAId: travelAgent.id))
              );
            }, 
            icon: Icon(Icons.edit_document),
            iconSize: 25,
            color: Color(0xFF467BA1),
          ),
        ],
      ),
    );
  }
}
