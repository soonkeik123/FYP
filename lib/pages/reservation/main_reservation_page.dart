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
  List<String> reservationID = [];

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
              reservationID.add(key);
            });
          }
        });
      }
    });
  }

  List<Map<String, dynamic>> filterReservattionsByStatus(
      List<Map<String, dynamic>> reservations, String status, String status2) {
    return reservations
        .where((reservations) =>
            reservations["status"] == status ||
            reservations["status"] == status2)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> ongoingOrders =
        filterReservattionsByStatus(reservations, "Incoming", "Processing");
    List<Map<String, dynamic>> historyOrders =
        filterReservattionsByStatus(reservations, "Completed", "Canceled");

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
                      itemCount: ongoingOrders.length,
                      itemBuilder: (context, index) {
                        // Display processing orders
                        return OrderItemWidget(
                          id: reservationID[index],
                          status: ongoingOrders[index]["status"],
                          service: ongoingOrders[index]["service"],
                          date: ongoingOrders[index]["date"],
                          time: ongoingOrders[index]["time"],
                        );
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
                        itemCount: historyOrders.length,
                        itemBuilder: (context, index) {
                          // Display processing orders
                          return OrderItemWidget(
                            id: reservationID[index],
                            status: historyOrders[index]["status"],
                            service: historyOrders[index]["service"],
                            date: historyOrders[index]["date"],
                            time: historyOrders[index]["time"],
                            // room: processingOrders[index]["room"],
                          );
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
  final String id;
  final String status;
  final String service;
  final String date;
  final String time;

  const OrderItemWidget({
    super.key,
    required this.id,
    required this.status,
    required this.service,
    required this.date,
    required this.time,
  });

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
    if (status == 'Incoming' || status == 'Processing') {
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
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${id.substring(id.length - 5)}',
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
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500)),
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
          print(id + status + service + date + time);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TrackProgressPage(reservationID: id)));
        },
      );
    } else {
      return InkWell(
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${id.substring(id.length - 5)}',
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
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500)),
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
          print(id + status + service + date + time);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TrackProgressPage(reservationID: id)));
        },
      );
    }
  }
}
