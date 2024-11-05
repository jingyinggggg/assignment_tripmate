import "package:assignment_tripmate/constants.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class TravelAgentRevenueScreen extends StatefulWidget {
  final String userId;

  const TravelAgentRevenueScreen({
    super.key,
    required this.userId,
  });

  @override
  State<TravelAgentRevenueScreen> createState() => _TravelAgentRevenueScreenState();
}

class _TravelAgentRevenueScreenState extends State<TravelAgentRevenueScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, double> tourRevenueByMonth = {};
  Map<String, double> carRevenueByMonth = {};
  List<double> waitingWithdraw = [];
  List<double> doneWithdraw = [];
  double totalWaitingWithdraw = 0.0;
  bool isAmountVisible = true; 
  bool isLoading = false; 
  bool isCarLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeMonthlyData();
    _fetchTourRevenue(); // Fetch data on initialization
    _fetchCarRentalRevenue();
  }

  void _initializeMonthlyData() {
    tourRevenueByMonth = {
      for (var i = 1; i <= 12; i++) DateFormat('MMM').format(DateTime(0, i)): 0.0
    };
    carRevenueByMonth = {
      for (var i = 1; i <= 12; i++) DateFormat('MMM').format(DateTime(0, i)): 0.0
    };
  }

  Future<void> _fetchTourRevenue() async {
    setState(() {
      isLoading = true; // Set loading to true when starting to fetch data
    });

    try {
      // Query to find the specific revenue document where id matches localBuddyID
      QuerySnapshot revenueSnapshot = await _firestore
          .collection('revenue')
          .where('id', isEqualTo: widget.userId) // Use where to match id field
          .get();

      // Debug: Check if revenue documents were found
      if (revenueSnapshot.docs.isNotEmpty) {
        DocumentSnapshot revenueDoc = revenueSnapshot.docs.first;
        print('Revenue document found: ${revenueDoc.id}');
        
        waitingWithdraw.clear();
        doneWithdraw.clear();
        totalWaitingWithdraw = 0.0;

        // Fetch all documents in the profit subcollection
        QuerySnapshot profitSnapshot = await _firestore
            .collection('revenue')
            .doc(revenueDoc.id) // Use the found document ID here
            .collection('profit') // Access the profit subcollection
            .where('type', isEqualTo: 'tour')
            .get();

        for (var profitDoc in profitSnapshot.docs) {
          double profitAmount = profitDoc['profit'] ?? 0.0; // Adjust based on your field
          Timestamp profitDate = profitDoc['timestamp']; // Adjust based on your field
          int isWithdraw = profitDoc['isWithdraw'] ?? 0; // 0 for waiting, 1 for done

          if (isWithdraw == 0) {
            waitingWithdraw.add(profitAmount);
            totalWaitingWithdraw += profitAmount;
            String monthKey = DateFormat('MMM').format(profitDate.toDate());
            tourRevenueByMonth[monthKey] = (tourRevenueByMonth[monthKey] ?? 0) + profitAmount;
          } else {
            doneWithdraw.add(profitAmount);
            String monthKey = DateFormat('MMM').format(profitDate.toDate());
            tourRevenueByMonth[monthKey] = (tourRevenueByMonth[monthKey] ?? 0) + profitAmount;
          }

          print('Profit Document ID: ${profitDoc.id}, Amount: $profitAmount, Is Withdraw: $isWithdraw');
        }
      } else {
        print('No revenue document found for travelAgentID: ${widget.userId}');
      }
    } catch (e) {
      print('Error fetching revenue: $e');
    } finally {
      setState(() {
        isLoading = false; 
      });
    }
  }

  Future<void> _fetchCarRentalRevenue() async {
    setState(() {
      isCarLoading = true; // Set loading to true when starting to fetch data
    });

    try {
      // Query to find the specific revenue document where id matches localBuddyID
      QuerySnapshot revenueSnapshot = await _firestore
          .collection('revenue')
          .where('id', isEqualTo: widget.userId) // Use where to match id field
          .get();

      // Debug: Check if revenue documents were found
      if (revenueSnapshot.docs.isNotEmpty) {
        DocumentSnapshot revenueDoc = revenueSnapshot.docs.first;
        print('Revenue document found: ${revenueDoc.id}');
        
        waitingWithdraw.clear();
        doneWithdraw.clear();
        totalWaitingWithdraw = 0.0;

        // Fetch all documents in the profit subcollection
        QuerySnapshot profitSnapshot = await _firestore
            .collection('revenue')
            .doc(revenueDoc.id) // Use the found document ID here
            .collection('profit') // Access the profit subcollection
            .where('type', isEqualTo: 'carRental')
            .get();

        for (var profitDoc in profitSnapshot.docs) {
          double profitAmount = profitDoc['profit'] ?? 0.0; // Adjust based on your field
          Timestamp profitDate = profitDoc['timestamp']; // Adjust based on your field
          int isWithdraw = profitDoc['isWithdraw'] ?? 0; // 0 for waiting, 1 for done

          if (isWithdraw == 0) {
            waitingWithdraw.add(profitAmount);
            totalWaitingWithdraw += profitAmount;
            String monthKey = DateFormat('MMM').format(profitDate.toDate());
            carRevenueByMonth[monthKey] = (carRevenueByMonth[monthKey] ?? 0) + profitAmount;
          } else {
            doneWithdraw.add(profitAmount);
            String monthKey = DateFormat('MMM').format(profitDate.toDate());
            carRevenueByMonth[monthKey] = (carRevenueByMonth[monthKey] ?? 0) + profitAmount;
          }

          print('Profit Document ID: ${profitDoc.id}, Amount: $profitAmount, Is Withdraw: $isWithdraw');
        }
      } else {
        print('No revenue document found for travelAgentID: ${widget.userId}');
      }
    } catch (e) {
      print('Error fetching revenue: $e');
    } finally {
      setState(() {
        isCarLoading = false; 
      });
    }
  }

  List<FlSpot> _getDataPoints(Map<String, double> data) {
    List<String> months = data.keys.toList();
    return months.asMap().entries.map((entry) {
      int index = entry.key;
      String month = entry.value;
      return FlSpot(index.toDouble(), data[month]?.toDouble() ?? 0);
    }).toList();
  }

  // Determine the y-axis intervals and max value based on total revenue
  double _getMaxYValue() {
    double maxValue = totalWaitingWithdraw > 0 ? totalWaitingWithdraw : 1; // Fallback for maxValue
    if (maxValue <= 10000) return 10000; 
    if (maxValue <= 20000) return 20000; 
    if (maxValue <= 30000) return 30000; 
    if (maxValue <= 40000) return 40000; 
    if (maxValue <= 50000) return 50000; 
    if (maxValue <= 60000) return 60000; 
    if (maxValue <= 70000) return 70000; 
    if (maxValue <= 80000) return 80000; 
    if (maxValue <= 90000) return 90000; 
    if (maxValue <= 100000) return 100000; 
    return (maxValue / 10000).ceil() * 10000; // Round up to nearest thousand
  }

  double _getCarMaxYValue() {
    double maxValue = totalWaitingWithdraw > 0 ? totalWaitingWithdraw : 1; // Fallback for maxValue
    if (maxValue <= 1000) return 1000; 
    if (maxValue <= 2000) return 2000; 
    if (maxValue <= 3000) return 3000; 
    if (maxValue <= 4000) return 4000; 
    if (maxValue <= 5000) return 5000; 
    if (maxValue <= 6000) return 6000; 
    if (maxValue <= 7000) return 7000; 
    if (maxValue <= 8000) return 8000; 
    if (maxValue <= 9000) return 9000; 
    if (maxValue <= 10000) return 10000; 
    return (maxValue / 1000).ceil() * 1000; // Round up to nearest thousand
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    resizeToAvoidBottomInset: true,
    appBar: AppBar(
      title: const Text("Revenue"),
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
          Navigator.pop(context);
        },
      ),
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator(color: primaryColor))
        : SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16.0),
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Revenue to Withdraw",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  isAmountVisible
                                      ? "RM${totalWaitingWithdraw.toStringAsFixed(2)}"
                                      : "RM ****",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isAmountVisible ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isAmountVisible = !isAmountVisible;
                                    });
                                  },
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Handle withdraw action
                              },
                              child: const Text("Withdraw"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Monthly Revenue Trend (Tour)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Card(
                          margin: const EdgeInsets.all(16.0),
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Monthly Revenue Trend (Tour)",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: 300,
                                  child: LineChart(
                                    LineChartData(
                                      gridData: FlGridData(show: false),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 40,
                                            interval: _getMaxYValue() / 5,
                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                value.toInt().toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 38,
                                            getTitlesWidget: (value, meta) {
                                              int index = value.toInt();
                                              return Text(
                                                tourRevenueByMonth.keys.elementAt(index),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      ),
                                      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
                                      minX: 0,
                                      maxX: tourRevenueByMonth.length.toDouble() - 1,
                                      minY: 0,
                                      maxY: _getMaxYValue(),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: _getDataPoints(tourRevenueByMonth),
                                          isCurved: false,
                                          color: Colors.blue,
                                          dotData: FlDotData(show: true),
                                          belowBarData: BarAreaData(show: false),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Monthly Revenue Trend (Car Rental)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Card(
                          margin: const EdgeInsets.all(16.0),
                          elevation: 4,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Monthly Revenue Trend (Car Rental)",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: 300,
                                  child: LineChart(
                                    LineChartData(
                                      gridData: FlGridData(show: false),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 40,
                                            interval: _getCarMaxYValue() / 5,
                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                value.toInt().toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 38,
                                            getTitlesWidget: (value, meta) {
                                              int index = value.toInt();
                                              return Text(
                                                carRevenueByMonth.keys.elementAt(index),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      ),
                                      borderData: FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
                                      minX: 0,
                                      maxX: carRevenueByMonth.length.toDouble() - 1,
                                      minY: 0,
                                      maxY: _getCarMaxYValue(),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: _getDataPoints(carRevenueByMonth),
                                          isCurved: false,
                                          color: Colors.blue,
                                          dotData: FlDotData(show: true),
                                          belowBarData: BarAreaData(show: false),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
  );
}


}