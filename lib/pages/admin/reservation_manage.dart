import 'package:flutter/material.dart';
import 'package:ohmypet/pages/reservation/track_progress.dart';
import 'package:ohmypet/widgets/admin_header.dart';

import '../../utils/colors.dart';
import '../../widgets/admin_navigation_bar.dart';

class ReservationManagement extends StatefulWidget {
  static const staffRoute = '/staffManageReservation';
  static const adminRoute = '/adminManageReservation';
  final String role;
  const ReservationManagement({super.key, required this.role});

  @override
  State<ReservationManagement> createState() => _ReservationManagementState();
}

class _ReservationManagementState extends State<ReservationManagement> {
  late String role;

  @override
  void initState() {
    super.initState();
    role = widget.role;
    // fetchData();
  }

  ValueNotifier<int> myVariable = ValueNotifier<int>(0);

  bool showCurrent = true;
  bool showAll = false;

  List<Map<String, dynamic>> orders = [
    {
      "id": 001,
      "status": "Processing",
      "service": "Dog Basic Grooming",
      "date": "2023-07-20",
      "time": "10:00 AM"
    },
    {
      "id": 002,
      "status": "Incoming",
      "service": "Cat Boarding",
      "date": "2023-07-21",
      "time": "02:00 PM"
    },
    {
      "id": 003,
      "status": "Completed",
      "service": "Cat Full Grooming",
      "date": "2023-07-20",
      "time": "10:00 AM"
    },
    {
      "id": 004,
      "status": "Incoming",
      "service": "Cat Full Grooming",
      "date": "2023-07-23",
      "time": "02:00 PM"
    },
    {
      "id": 005,
      "status": "Canceled",
      "service": "Cat Basic Grooming",
      "date": "2023-07-21",
      "time": "12:00 PM"
    },
    {
      "id": 006,
      "status": "Incoming",
      "service": "Cat Basic Grooming",
      "date": "2023-07-21",
      "time": "12:00 PM"
    },
  ];

  List<Map<String, dynamic>> filterOrdersByStatus(
      List<Map<String, dynamic>> orders, String status) {
    return orders.where((order) => order["status"] == status).toList();
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

  Widget _offsetPopup() => PopupMenuButton<int>(
        padding: const EdgeInsets.only(bottom: 2),
        // offset: Offset(0, 30),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 0,
            child: Text(
              "Show only current",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text(
              "Show all reservation",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ],
        onSelected: (value) {
          setState(() {
            showAll = !showAll;
            showCurrent = !showCurrent;
          });
        },
        icon: const Icon(
          Icons.filter_alt_outlined,
          color: AppColors.mainColor,
          size: 30,
        ),
      );

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> incomingOrders =
        filterOrdersByStatus(orders, "Incoming");
    List<Map<String, dynamic>> processingOrders =
        filterOrdersByStatus(orders, "Processing");
    // List<Map<String, dynamic>> completedOrders =
    //     filterOrdersByStatus(orders, "Completed");
    // List<Map<String, dynamic>> canceledOrders =
    //     filterOrdersByStatus(orders, "Canceled");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        // Header
        AdminHeader(pageTitle: "MANAGE RESERVATION"),

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
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black38,
                                spreadRadius: 0.5,
                                blurRadius: 0.5)
                          ],
                          borderRadius: BorderRadius.circular(5)),
                      height: 35,
                      width: 35,
                      child: _offsetPopup(),
                    ),
                  ],
                ),
                showAll
                    ? SizedBox(
                        width: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orders.toList().length,
                          itemBuilder: (context, index) {
                            // Display processing orders
                            return OrderItemWidget(
                              id: orders.toList()[index]['id'],
                              status: orders.toList()[index]["status"],
                              service: orders.toList()[index]["service"],
                              date: orders.toList()[index]["date"],
                              time: orders.toList()[index]["time"],
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
                          itemCount:
                              incomingOrders.length + processingOrders.length,
                          itemBuilder: (context, index) {
                            if (index < processingOrders.length) {
                              // Display processing orders
                              return OrderItemWidget(
                                id: processingOrders[index]['id'],
                                status: processingOrders[index]["status"],
                                service: processingOrders[index]["service"],
                                date: processingOrders[index]["date"],
                                time: processingOrders[index]["time"],
                              );
                            } else {
                              // Display incoming orders
                              int incomingIndex =
                                  index - processingOrders.length;

                              return OrderItemWidget(
                                id: incomingOrders[incomingIndex]["id"],
                                status: incomingOrders[incomingIndex]["status"],
                                service: incomingOrders[incomingIndex]
                                    ["service"],
                                date: incomingOrders[incomingIndex]["date"],
                                time: incomingOrders[incomingIndex]["time"],
                              );
                            }
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
  final int id;
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
