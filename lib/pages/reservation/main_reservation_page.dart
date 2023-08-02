import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/reservation/track_progress.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/title_text.dart';

import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/header.dart';

class MainReservationPage extends StatefulWidget {
  static const routeName = '/reservation';
  const MainReservationPage({super.key});

  @override
  State<MainReservationPage> createState() => _MainReservationPageState();
}

class _MainReservationPageState extends State<MainReservationPage> {
  // Create a reference to Firebase database
  late DatabaseReference reservRef;

  int allIndex = 0; // reservation index
  String service = '';
  String status = '';
  String date = '';
  String time = '';
  String package = '';

  List<Map<String, dynamic>> reservations = [];

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      reservRef = FirebaseDatabase.instance.ref().child('reservations');
      getReservationByID(uid);
    }
  }

  // Get  data by ID
  Future<void> getReservationByID(String UID) async {
    reservRef.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        // List<Map<String, dynamic>> filterReservations = [];
        reservations.clear(); // Clear the list before adding new data
        data.forEach((key, value) {
          Map<String, dynamic> reservationData =
              Map.from(value); // Access the inner map
          reservationData['key'] = key;

          // Check if the user_id field matches the provided userID
          if (reservationData['user_id'] == UID) {
            setState(() {
              // reservations.addAll(filterReservations);
              reservations.add(reservationData);
            });
          }
        });
      }
    });
  }

  // [
  //   {
  //     "id": 001,
  //     "status": "Processing",
  //     "service": "Dog Basic Grooming",
  //     "date": "2023-07-20",
  //     "time": "10:00 AM"
  //   },
  //   {
  //     "id": 002,
  //     "status": "Incoming",
  //     "service": "Cat Boarding",
  //     "date": "2023-07-21",
  //     "time": "02:00 PM"
  //   },
  //   {
  //     "id": 003,
  //     "status": "Completed",
  //     "service": "Cat Full Grooming",
  //     "date": "2023-07-20",
  //     "time": "10:00 AM"
  //   },
  //   {
  //     "id": 004,
  //     "status": "Incoming",
  //     "service": "Cat Full Grooming",
  //     "date": "2023-07-23",
  //     "time": "02:00 PM"
  //   },
  //   {
  //     "id": 005,
  //     "status": "Canceled",
  //     "service": "Cat Basic Grooming",
  //     "date": "2023-07-21",
  //     "time": "12:00 PM"
  //   },
  //   {
  //     "id": 006,
  //     "status": "Incoming",
  //     "service": "Cat Basic Grooming",
  //     "date": "2023-07-21",
  //     "time": "12:00 PM"
  //   },
  // ];

  List<Map<String, dynamic>> filterReservattionsByStatus(
      List<Map<String, dynamic>> reservations, String status) {
    return reservations
        .where((reservations) => reservations["status"] == status)
        .toList();
  }

  // Future<void> fetchData() async {
  //   await Future.delayed(Duration(seconds: 2)); // Simulating async fetch
  //   // Once data is available, update the orders list
  //   setState(() {
  //     orders = [
  //       Order(
  //         id: '#001',
  //         status: 'Processing',
  //         serviceName: 'Pet Grooming',
  //         date: '2023-07-20',
  //         time: '10:00 AM',
  //       ),
  //       Order(
  //         id: '#002',
  //         status: 'Incoming',
  //         serviceName: 'Pet Boarding',
  //         date: '2023-07-21',
  //         time: '12:00 PM',
  //       ),
  //     ];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> incomingOrders =
        filterReservattionsByStatus(reservations, "Incoming");
    List<Map<String, dynamic>> processingOrders =
        filterReservattionsByStatus(reservations, "Processing");
    List<Map<String, dynamic>> completedOrders =
        filterReservattionsByStatus(reservations, "Completed");
    List<Map<String, dynamic>> canceledOrders =
        filterReservattionsByStatus(reservations, "Canceled");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        // Header
        const CustomHeader(pageTitle: "RESERVATION"),

        // Body
        Expanded(
          child: Container(
            height: double.maxFinite,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Ongoing",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mainColor),
                  ),
                  // OnGoing Reservation

                  SizedBox(
                    width: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          incomingOrders.length + processingOrders.length,
                      itemBuilder: (context, index) {
                        if (index < processingOrders.length) {
                          // Display processing orders
                          return OrderItemWidget(
                            id: index + 1,
                            status: processingOrders[index]["status"],
                            service: processingOrders[index]["service"],
                            date: processingOrders[index]["date"],
                            time: processingOrders[index]["time"],
                            // room: processingOrders[index]["room"],
                          );
                        } else {
                          // Display incoming orders
                          int incomingIndex = index - processingOrders.length;

                          return OrderItemWidget(
                            id: index + 1,
                            status: incomingOrders[incomingIndex]["status"],
                            service: incomingOrders[incomingIndex]["service"],
                            date: incomingOrders[incomingIndex]["date"],
                            time: incomingOrders[incomingIndex]["time"],
                            // room: processingOrders[index]["room"],
                          );
                        }
                      },
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45, width: 0.5)),
                  ),
                  TitleText(
                    text: "History",
                    size: 23,
                  ),
                  // History
                  SizedBox(
                      width: 300,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            completedOrders.length + canceledOrders.length,
                        itemBuilder: (context, index) {
                          if (index < completedOrders.length) {
                            // Display processing orders
                            return OrderItemWidget(
                              id: index + 1,
                              status: completedOrders[index]["status"],
                              service: completedOrders[index]["service"],
                              date: completedOrders[index]["date"],
                              time: completedOrders[index]["time"],
                              // room: processingOrders[index]["room"],
                            );
                          } else {
                            // Display incoming orders
                            int canceledIndex = index - completedOrders.length;

                            return OrderItemWidget(
                              id: index + 1,
                              status: canceledOrders[canceledIndex]["status"],
                              service: canceledOrders[canceledIndex]["service"],
                              date: canceledOrders[canceledIndex]["date"],
                              time: canceledOrders[canceledIndex]["time"],
                              // room: processingOrders[index]["room"],
                            );
                          }
                        },
                      )),
                ],
              ),
            ),
          ),
        )
      ]),
      bottomNavigationBar: const BottomNavBar(
        activePage: 2,
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final int id;
  final String status;
  final String service;
  final String date;
  final String time;
  // final String room;

  const OrderItemWidget({
    super.key,
    required this.id,
    required this.status,
    required this.service,
    required this.date,
    required this.time,
    // required this.room,
  });

  // String serviceColor() {
  //   if (this.status == "Incoming") {
  //     return "0xFF0D47B7";
  //   } else if (status == "Processing") {
  //     return "0xFFE65100";
  //   } else if (status == "Completed") {
  //     return "0xFF8D6E63";
  //   } else {
  //     return "0xFF8D6E63"; //0xFFC62828
  //   }
  // }

  String textColor() {
    if (status == "Incoming") {
      return "0xFF0D47A1";
    } else if (status == "Processing") {
      return "0xFFE65100";
    } else if (status == "Completed") {
      return "0xFF9E9E9E";
    } else {
      return "0xFFC62828";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black54,
                offset: Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 1)
          ],
          // color: Color(int.parse(serviceColor())).withOpacity(0.2),
          // border: Border.all(
          //     color: Color(int.parse(serviceColor())).withOpacity(0.5),
          //     width: 1.6),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#$id',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
                Text(
                  status,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(int.parse(textColor()))),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(service,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
                Text(
                  // (room.isEmpty) ? time : room,
                  time,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrackProgressPage(reservationID: id)));
      },
    );
  }
}
