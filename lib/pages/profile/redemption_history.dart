import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../widgets/header.dart';

class RedemptionHistory extends StatefulWidget {
  static const routeName = '/redeemHistory';
  const RedemptionHistory({super.key});

  @override
  State<RedemptionHistory> createState() => _RedemptionHistoryState();
}

class _RedemptionHistoryState extends State<RedemptionHistory> {
  // Create a reference to Firebase database
  late DatabaseReference reservRef;

  List<Map<String, dynamic>> redeemedReservations = [];
  List<String> redeemedReservationID = [];

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      reservRef = FirebaseDatabase.instance.ref().child('reservations');
      getRedeemItemByID(uid);
    }
  }

  // Get  data by ID
  Future<void> getRedeemItemByID(String UID) async {
    reservRef.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        // List<Map<String, dynamic>> filterReservations = [];
        redeemedReservations.clear(); // Clear the list before adding new data
        data.forEach((key, value) {
          Map<String, dynamic> reservationData =
              Map.from(value); // Access the inner map
          reservationData['key'] = key;

          // Check if the user_id field matches the provided userID
          if (reservationData['user_id'] == UID) {
            if (reservationData['free_service'] == true) {
              setState(() {
                redeemedReservations.add(reservationData);
                redeemedReservationID.add(key);
              });
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          const CustomHeader(pageTitle: "Redemption History"),

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
                      "All Redeemed Service",
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
                        itemCount: redeemedReservations.length,
                        itemBuilder: (context, index) {
                          // Display processing orders
                          return RedeemItemWidget(
                            id: redeemedReservationID[index],
                            status: redeemedReservations[index]["status"],
                            service: redeemedReservations[index]["service"],
                            date: redeemedReservations[index]["date"],
                            time: redeemedReservations[index]["time"],
                            pet: redeemedReservations[index]["pet"],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RedeemItemWidget extends StatelessWidget {
  final String id;
  final String status;
  final String service;
  final String date;
  final String time;
  final String pet;

  const RedeemItemWidget({
    super.key,
    required this.id,
    required this.status,
    required this.service,
    required this.date,
    required this.time,
    required this.pet,
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

  int pointDeducted(String service) {
    if (service == "Cat Basic Grooming" || service == "Dog Basic Grooming") {
      return 600;
    } else {
      return 800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 0.5),
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
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
          Text("Pet: $pet",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
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
          const SizedBox(
            height: 5,
          ),
          Text("Point used: ${pointDeducted(service)}",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
