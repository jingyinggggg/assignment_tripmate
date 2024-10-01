import 'package:assignment_tripmate/constants.dart';
import 'package:assignment_tripmate/screens/admin/registrationRequest.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminManageLocalBuddyRegistrationRequestScreen extends StatefulWidget {
  final String userId;
  final String localBuddyId;

  const AdminManageLocalBuddyRegistrationRequestScreen({super.key, required this.userId, required this.localBuddyId});

  @override
  State<AdminManageLocalBuddyRegistrationRequestScreen> createState() => _AdminManageLocalBuddyRegistrationRequestScreenState();
}

class _AdminManageLocalBuddyRegistrationRequestScreenState extends State<AdminManageLocalBuddyRegistrationRequestScreen>  with WidgetsBindingObserver {
  Map<String, dynamic>? localBuddyData;
  Map<String, dynamic>? userData;
  bool isLoading = false;
  bool isScheduledInterview = false;
  bool isRejectLoading = false;
  bool isDeclineLoading = false;
  bool isShortlistedLoading = false;
  TextEditingController _rejectReasonController = TextEditingController();
  TextEditingController _declineInterviewReasonController = TextEditingController();
  DateTime? interviewDateTime;

  @override
  void initState() {
    super.initState();
    _fetchLocalBuddyData();
    WidgetsBinding.instance.addObserver(this); // Register observer
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
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

  Future<void> _rejectRequest(String reason) async {
    try {
      setState(() {
        isRejectLoading = true;
      });

      await FirebaseFirestore.instance.collection('localBuddy').doc(widget.localBuddyId).update({
        'registrationStatus': 3,
        'rejectReason': reason,
      });

      _showDialog(
        title: 'Rejected',
        content: 'You have rejected the registration request.',
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationRequestScreen(userId: widget.userId)),
          );
        },
      );
    } catch (e) {
      _showDialog(
        title: 'Error',
        content: 'An error occurred: $e',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    } finally {
      setState(() {
        isRejectLoading = false; // Stop loading
      });
    }
  }

  void _showRejectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reject Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please provide a reason for rejection:'),
              TextField(
                controller: _rejectReasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter rejection reason...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _rejectRequest(_rejectReasonController.text); // Perform reject request
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _shorlistedRequest() async {
    try {
      setState(() {
        isShortlistedLoading = true;
      });

      await FirebaseFirestore.instance.collection('localBuddy').doc(widget.localBuddyId).update({
        'registrationStatus': 2,
      });

      _showDialog(
        title: 'Success',
        content: 'You have approved the registration request successfully.',
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationRequestScreen(userId: widget.userId)),
          );
        },
      );

      setState(() {
        isShortlistedLoading = false; // Stop loading
      });
    } catch (e) {
      _showDialog(
        title: 'Error',
        content: 'An error occurred: $e',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    } finally {
      setState(() {
        isShortlistedLoading = false; // Stop loading
      });
    }
  }

  Future<void> _declineInterview(String reason) async {
    try {
      setState(() {
        isDeclineLoading = true;
      });

      await FirebaseFirestore.instance.collection('localBuddy').doc(widget.localBuddyId).update({
        'registrationStatus': 4,
        'declineInterviewReason': reason,
      });

      _showDialog(
        title: 'Rejected',
        content: 'You have reject the registration request after interview session.',
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationRequestScreen(userId: widget.userId)),
          );
        },
      );
    } catch (e) {
      _showDialog(
        title: 'Error',
        content: 'An error occurred: $e',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    } finally {
      setState(() {
        isDeclineLoading = false; // Stop loading
      });
    }
  }

  void _showDeclineDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reject Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please provide a reason for rejection:'),
              TextField(
                controller: _rejectReasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter rejection reason...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _declineInterview(_declineInterviewReasonController.text); // Perform reject request
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _createGoogleCalendarEvent(String email) async {
    // Constructing the calendar URL
    final String calendarUrl =
        "https://calendar.google.com/calendar/render?action=TEMPLATE&text=Interview&details=Please+attend+the+interview&location=Google+Meet&add=" +
        Uri.encodeComponent(email);

    final Uri uri = Uri.parse(calendarUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $calendarUrl';
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // User has returned to the app
      _updateRegistrationStatus(1); // Update registration status
      setState(() {
        
      });
    }
  }

  Future<void> _updateRegistrationStatus(int status) async {
    await FirebaseFirestore.instance.collection('localBuddy').doc(widget.localBuddyId).update({'registrationStatus': status});
    print("Registration status updated to: $status");
  }  

  void _showDialog({
    required String title,
    required String content,
    required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: onPressed,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
          fontSize: defaultAppBarTitleFontSize,
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
          : localBuddyData == null
              ? Center(child: Text('No local buddy details available.'))
              : SingleChildScrollView( 
                child: Padding(
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
                                  child: _buildImage(userData?['profileImage'], 75, 110),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow('Name', userData?['name'], 50),
                                      SizedBox(height: 10),
                                      _buildDetailRow('DOB', _formatDate(userData?['dob']), 50),
                                      SizedBox(height: 10),
                                      _buildDetailRow('Gender', userData?['gender'], 50),
                                      SizedBox(height: 10),
                                      _buildDetailRow('Email', userData?['email'], 50),
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
                                'Background Infomation',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height:20),

                            _buildDetailRow('Bio', localBuddyData?['bio'], 70),
                            SizedBox(height: 10),
                            _buildDetailRow('Address', localBuddyData?['location'], 70),
                            SizedBox(height: 10),
                            _buildDetailRow('Occupation', localBuddyData?['occupation'], 70),
                            SizedBox(height: 10),
                            _buildDetailRow('Language Spoken', localBuddyData?['languageSpoken'], 70),

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
                                'Availability',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height:20),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row for 'Working Time :'
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 90,
                                      child: Text(
                                        'Working Time',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: defaultFontSize,
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
                                          fontSize: defaultFontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Table for availability data
                                localBuddyData!['availability'] != null
                                    ? Table(
                                        columnWidths: {
                                          0: FixedColumnWidth(100), // Fixed width for day column
                                          1: FixedColumnWidth(120), // Fixed width for time column
                                        },
                                        border: TableBorder.all(), // Adds borders to the table
                                        children: [
                                          // Header Row
                                          TableRow(
                                            decoration: BoxDecoration(
                                              color: Color(0xFF749CB9)
                                            ),
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Day',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: defaultFontSize,
                                                    color: Colors.white
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Time',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: defaultFontSize,
                                                    color: Colors.white
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Availability Rows
                                          for (var availability in localBuddyData!['availability'])
                                            TableRow(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    availability['day'],
                                                    style: TextStyle(
                                                      fontSize: defaultFontSize,
                                                      fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${availability['startTime']} - ${availability['endTime']}',
                                                    style: TextStyle(
                                                      fontSize: defaultFontSize,
                                                      fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(left: 110),
                                        child: Text('No availability data'),
                                      ),
                              ],
                            ),


                            SizedBox(height: 10),
                            _buildDetailRow('Price', 'RM ${localBuddyData?['pricePerHour'].toString()}/hour', 90),

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
                                'Additional Infomation ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            SizedBox(height:20),

                            _buildDetailRow('Previous Experience', localBuddyData?['previousExperience'] != null ? '' : 'N/A', 130),
                            SizedBox(height: 10),
                            _buildDetailRow('Identification Card', localBuddyData?['idCardImage'] != null ? '' : 'N/A', 130),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.5),
                              ),
                              child: _buildImage(localBuddyData?['idCardImage'], double.infinity, 220),
                            ),
                            SizedBox(height: 10),
                            _buildDetailRow('References', localBuddyData?['referenceImage'] != null ? '' : 'N/A', 130),
                            if (localBuddyData?['referenceImage'] != null && localBuddyData!['referenceImage'].isNotEmpty) ...[
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.5),
                                ),
                                child: _buildImage(localBuddyData!['referenceImage'], double.infinity, 220),
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      if(localBuddyData?['registrationStatus'] == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                          ElevatedButton(
                            onPressed: isScheduledInterview ? null : () {
                              setState(() {
                                isScheduledInterview = true;
                              });
                              _createGoogleCalendarEvent(userData?['email'] ?? ''); // Create calendar event
                              setState(() {
                                isScheduledInterview = false;
                              });
                            },
                            child: isScheduledInterview
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Schedule Interview',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.green, width: 2),
                              ),
                              minimumSize: Size(100, 40),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: isRejectLoading
                                ? null
                                : () {
                                    _showRejectDialog();
                                  },
                            child: isRejectLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Reject',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.red, width: 2),
                              ),
                              minimumSize: Size(100, 40),
                            ),
                          )
                        ]
                      )
                      
                      else if(localBuddyData?['registrationStatus'] == 1)
                        Container(
                          child: Column(
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
                                  'Interview Session',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height:20),
                              _buildDetailRow('Interview Meeting', localBuddyData?['registrationStatus'] == 1 ? 'Scheduled' : 'N/A', 130),
                              localBuddyData?['declineInterviewReason'] != null
                              ? _buildDetailRow('Reject Reason: ', localBuddyData?['declineInterviewReason'], 130)
                              : Container(),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                ElevatedButton(
                                  onPressed: isScheduledInterview ? null : () {
                                    _shorlistedRequest();
                                  },
                                  child: isScheduledInterview
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.green,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Shorlisted',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w900,
                                            fontSize: defaultLabelFontSize,
                                          ),
                                        ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: Colors.green, width: 2),
                                    ),
                                    minimumSize: Size(100, 40),
                                  ),
                                ),
                                  SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: isRejectLoading
                                        ? null
                                        : () {
                                            _showDeclineDialog();
                                          },
                                    child: isRejectLoading
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.red,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'Reject',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w900,
                                              fontSize: defaultLabelFontSize,
                                            ),
                                          ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: BorderSide(color: Colors.red, width: 2),
                                      ),
                                      minimumSize: Size(100, 40),
                                    ),
                                  )
                                ]
                              )
                            ],
                          ),
                        )
                    ],
                  ),
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
                imageProvider: CachedNetworkImageProvider(imageUrl),
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
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
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
      return DateFormat('dd-MM-yyyy').format(dt);
    }
    return date?.toString() ?? 'N/A';
  }

}