import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/admin/reservation_action.dart';
import 'package:ohmypet/widgets/admin_header.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_bar.dart';

late String role;

class ReservationManagement extends StatefulWidget {
  static const staffRoute = '/staffManageReservation';
  static const adminRoute = '/adminManageReservation';
  final String role;
  const ReservationManagement({super.key, required this.role});

  @override
  State<ReservationManagement> createState() => _ReservationManagementState();
}

class _ReservationManagementState extends State<ReservationManagement> {
  // Create a reference to Firebase database
  late DatabaseReference reservRef;

  TextEditingController idController = TextEditingController();
  List<Map<String, dynamic>> filteredReservations = [];

  @override
  void initState() {
    super.initState();
    role = widget.role;

    reservRef = FirebaseDatabase.instance.ref().child('reservations');
    fetchReservations();
  }

  // Get data
  StreamSubscription<DatabaseEvent>? reservationSubscription;

  Future<void> fetchReservations() async {
    reservationSubscription = reservRef.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        ongoingReservations.clear();
        allReservations.clear();
        data.forEach((key, value) {
          Map<String, dynamic> reservationData = Map.from(value);
          reservationData['key'] = key;
          allReservations.add(reservationData);

          if (reservationData['status'] == 'Incoming' ||
              reservationData['status'] == 'Processing') {
            setState(() {
              ongoingReservations.add(reservationData);
            });
          }
        });
      }
    });
  }

  // Call this method when done with listening to events
  void cancelReservationSubscription() {
    reservationSubscription?.cancel();
  }

  void filterReservations(String id) {
    setState(() {
      filteredReservations = allReservations
          .where((reservation) => reservation['key']
              .toString()
              .toLowerCase()
              .contains(id.toLowerCase()))
          .toList();
    });
  }

  ValueNotifier<int> myVariable = ValueNotifier<int>(0);

  bool showCurrent = true;
  bool showAll = false;

  List<Map<String, dynamic>> ongoingReservations = [];
  List<Map<String, dynamic>> allReservations = [];

  Widget _offsetPopup() => PopupMenuButton<int>(
        padding: const EdgeInsets.only(bottom: 2),
        // offset: Offset(0, 30),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 0,
            child: Text(
              "Incoming & Processing",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text(
              "All Reservations",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 0) {
            setState(() {
              showCurrent = true;
              showAll = false;
            });
          } else if (value == 1) {
            setState(() {
              showCurrent = false;
              showAll = true;
            });
          }
        },
        icon: const Icon(
          Icons.filter_alt_outlined,
          color: AppColors.mainColor,
          size: 30,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        // Header
        const AdminHeader(pageTitle: "MANAGE RESERVATION"),

        // Body
        Expanded(
          child: Container(
            height: double.maxFinite,
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Filter Reservation",
                      style: TextStyle(
                          color: AppColors.mainColor.withOpacity(0.9),
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      height: 35,
                      width: 35,
                      child: _offsetPopup(),
                    ),
                  ],
                ),
                showAll
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: idController,
                          decoration: InputDecoration(labelText: 'Enter ID'),
                          onChanged: (value) {
                            filterReservations(value);
                          },
                        ),
                      )
                    : Container(),
                showAll
                    ? SizedBox(
                        width: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredReservations.length,
                          itemBuilder: (context, index) {
                            return OrderItemWidget(
                              id: filteredReservations[index]['key'],
                              status: filteredReservations[index]["status"],
                              service: filteredReservations[index]["service"],
                              date: filteredReservations[index]["date"],
                              time: filteredReservations[index]["time"],
                            );
                          },
                        ),
                      )
                    : Container(),
                showCurrent
                    ? SizedBox(
                        width: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ongoingReservations.length,
                          itemBuilder: (context, index) {
                            // Display processing orders
                            return OrderItemWidget(
                              id: ongoingReservations[index]['key'],
                              status: ongoingReservations[index]["status"],
                              service: ongoingReservations[index]["service"],
                              date: ongoingReservations[index]["date"],
                              time: ongoingReservations[index]["time"],
                            );
                          },
                        ),
                      )
                    : Container(),
              ]),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: AdminBottomNavBar(
        activePage: 0,
        role: widget.role,
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
                builder: (context) => ReservationActionPage(
                      reservationID: id,
                      role: role,
                    )));
      },
    );
  }
}
