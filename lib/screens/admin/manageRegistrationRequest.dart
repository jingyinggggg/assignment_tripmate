import 'package:assignment_tripmate/screens/admin/registrationRequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class AdminManageRegistrationRequestScreen extends StatefulWidget {
  final String userId;
  final String TAId;

  const AdminManageRegistrationRequestScreen({super.key, required this.userId, required this.TAId});

  @override
  State<AdminManageRegistrationRequestScreen> createState() => _AdminManageRegistrationRequestScreenState();
}

class _AdminManageRegistrationRequestScreenState extends State<AdminManageRegistrationRequestScreen>{
  Map<String, dynamic>? travelAgentData;
  bool isLoading = false;
  bool isActionLoading = false;

  @override
  void initState(){
    super.initState();
    _fetchTAData();
  }

  Future<void> _fetchTAData() async{
    setState(() {
      isLoading = true;
    });

    try{
      print(widget.TAId);
      DocumentReference TARef = FirebaseFirestore.instance.collection('travelAgent').doc(widget.TAId);
      DocumentSnapshot docSnapshot = await TARef.get();

      if(docSnapshot.exists){
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;

        setState(() {
          travelAgentData = data ?? {};
          isLoading = false;
        });
      } else{
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No travel agent details found with the given id.')),
        );
      }
    }catch(e){
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Registration Request"),
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
              MaterialPageRoute(
                builder: (context) => RegistrationRequestScreen(userId: widget.userId),
              ),
            );
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : travelAgentData == null
              ? Center(child: Text('No travel agent details available.'))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.black, width: 1.5),
                                  bottom: BorderSide(color: Colors.black, width: 1.5),
                                ),
                              ),
                              child: Text(
                                'Personal Info',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1.5),
                                  ),
                                  child: _buildImage(travelAgentData?['profileImage'], 75, 110),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow('Name', travelAgentData?['name'], 55),
                                      SizedBox(height: 10),
                                      _buildDetailRow('DOB', _formatDate(travelAgentData?['dob']), 55),
                                      SizedBox(height: 10),
                                      _buildDetailRow('Gender', travelAgentData?['gender'], 55),
                                      SizedBox(height: 10),
                                      _buildDetailRow('Email', travelAgentData?['email'], 55),
                                    ],
                                  ),
                                ),
                                
                              ],
                            ),

                            SizedBox(height: 20),

                            Container(
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.black, width: 1.5),
                                  bottom: BorderSide(color: Colors.black, width: 1.5),
                                ),
                              ),
                              child: Text(
                                'Company Info',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height:20),

                            _buildDetailRow('Company Name', travelAgentData?['companyName'], 125),
                            SizedBox(height: 10),
                            _buildDetailRow('Company Contact', _formatDate(travelAgentData?['companyContact']), 125),
                            SizedBox(height: 10),
                            _buildDetailRow('Company Address', travelAgentData?['companyAddress'], 125),
                            SizedBox(height: 10),
                            _buildDetailRow('Employee Card', '', 125),
                            SizedBox(height: 10),

                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.5),
                              ),
                              child: _buildImage(travelAgentData?['employeeCardPath'], double.infinity, 220),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: (){}, 
                            child: Text(
                              'Approve',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w900,
                                fontSize: 16
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.green, width: 2),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: (){}, 
                            child: Text(
                              'Reject',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w900,
                                fontSize: 16
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.red, width: 2),
                              ),
                            ),
                          )
                        ]
                      )
                    ],
                  ),
                ),
    );
  }

  Widget _buildImage(String? imageUrl, double width, double height) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: Center(child: Icon(Icons.error, color: Colors.red)),
      );
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
            );
          },
        );
      },
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
        fit: BoxFit.fill,
      ),
    );
  }


  Widget _buildDetailRow(String label, String? value, double width) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: 10,
          child: Text(
            ':',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value ?? 'N/A',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: null,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      DateTime dt = date.toDate();
      return DateFormat('yyyy-MM-dd').format(dt);
    }
    return date?.toString() ?? 'N/A';
  }

}