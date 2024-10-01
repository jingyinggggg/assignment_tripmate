import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/user/localBuddyHomepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocalBuddyDetailsScreen extends StatefulWidget{
  final String userId;
  final String localBuddyId;

  const LocalBuddyDetailsScreen({
    super.key,
    required this.userId,
    required this.localBuddyId
  });

  @override
  State<StatefulWidget> createState() => _LocalBuddyDetailsScreenState();
}

class _LocalBuddyDetailsScreenState extends State<LocalBuddyDetailsScreen>{
  Map<String, dynamic>? localBuddyData;
  Map<String, dynamic>? userData;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchLocalBuddyData();
  }

  Future<void> _fetchLocalBuddyData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentReference LocalBuddyRef = FirebaseFirestore.instance.collection('localBuddy').doc(widget.localBuddyId);
      DocumentSnapshot docSnapshot = await LocalBuddyRef.get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(data!['userID'] ?? '');
        DocumentSnapshot userSnapshot = await userRef.get();

        Map<String, dynamic>? usersData = userSnapshot.data() as Map<String, dynamic>?;

        setState(() {
          localBuddyData = data;
          userData = usersData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No local buddy details found with the given id.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tour data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar( 
        title: Text("Local Buddy"), 
        centerTitle: true,
        backgroundColor: const Color(0xFF749CB9),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Inika',
          fontWeight: FontWeight.bold,
          fontSize: defaultAppBarTitleFontSize,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => LocalBuddyHomepageScreen(userId: widget.userId))
            );
          },
        ),
      ),
      body: isLoading
        ? Center(child: CircularProgressIndicator(color: primaryColor))
        : SingleChildScrollView(
          child: Column(
            children: [
              if(userData?['profileImage'] != null) ...[
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(userData!['profileImage']),
                      fit: BoxFit.cover
                    )
                  ),
                )
              ] else ...[
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey
                  ),
                  child: const Center(
                    child: Text(
                      'No Profile Image Available',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                )
              ],

              if(localBuddyData != null)...[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        localBuddyData!['bio'] ?? '',
                        style: TextStyle(
                          fontSize: defaultFontSize,
                          fontWeight: FontWeight.w500
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: null,
                      )
                    ],
                  ),
                )
              ] else ...[
                Center(
                  child: Text(
                    'No data available.', 
                    style: TextStyle(
                      fontSize: defaultFontSize,
                      fontWeight: FontWeight.w500
                    )
                  )
                )
              ]
            ],
          ),
        )
      
      ,
    );
  }
}