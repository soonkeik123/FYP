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
  @override
  void initState() {
    super.initState();

    // fetchData();
  }

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

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> incomingOrders =
        filterOrdersByStatus(orders, "Incoming");
    List<Map<String, dynamic>> processingOrders =
        filterOrdersByStatus(orders, "Processing");
    List<Map<String, dynamic>> completedOrders =
        filterOrdersByStatus(orders, "Completed");
    List<Map<String, dynamic>> canceledOrders =
        filterOrdersByStatus(orders, "Canceled");

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
                            id: processingOrders[index]['id'],
                            status: processingOrders[index]["status"],
                            service: processingOrders[index]["service"],
                            date: processingOrders[index]["date"],
                            time: processingOrders[index]["time"],
                          );
                        } else {
                          // Display incoming orders
                          int incomingIndex = index - processingOrders.length;

                          return OrderItemWidget(
                            id: incomingOrders[incomingIndex]["id"],
                            status: incomingOrders[incomingIndex]["status"],
                            service: incomingOrders[incomingIndex]["service"],
                            date: incomingOrders[incomingIndex]["date"],
                            time: incomingOrders[incomingIndex]["time"],
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
                              id: completedOrders[index]["id"],
                              status: completedOrders[index]["status"],
                              service: completedOrders[index]["service"],
                              date: completedOrders[index]["date"],
                              time: completedOrders[index]["time"],
                            );
                          } else {
                            // Display incoming orders
                            int canceledIndex = index - completedOrders.length;

                            return OrderItemWidget(
                              id: canceledOrders[canceledIndex]["id"],
                              status: canceledOrders[canceledIndex]["status"],
                              service: canceledOrders[canceledIndex]["service"],
                              date: canceledOrders[canceledIndex]["date"],
                              time: canceledOrders[canceledIndex]["time"],
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
