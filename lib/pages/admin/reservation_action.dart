import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/admin/reservation_manage.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/admin_header.dart';
import 'package:ohmypet/widgets/title_text.dart';

import '../../widgets/info_text.dart';

class ReservationActionPage extends StatefulWidget {
  final String reservationID;
  final String role;
  const ReservationActionPage(
      {super.key, required this.reservationID, required this.role});

  @override
  State<ReservationActionPage> createState() => _ReservationActionPageState();
}

class _ReservationActionPageState extends State<ReservationActionPage> {
  // Create a reference to Firebase database
  late DatabaseReference reservRef;
  late DatabaseReference petRef;
  String currentUID = '';

  // Variable to store data
  String reservationId = '';
  String paymentId = '';
  String customerId = '';
  String customerName = '';
  Map selectedPet = {};
  String petName = '';
  String serviceType = '';
  String services = '';
  bool taxiRequired = false;
  String address = '';
  String reservedDate = '';
  String reservedTime = '';
  String package = '';
  double price = 0;
  int stage = 0;
  String status = '';
  late bool pointRedeem;

  // Show progress page
  bool showDetailPage = true;

  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) currentUID = user.uid;
    final rid = widget.reservationID;
    reservRef = FirebaseDatabase.instance.ref('reservations/$rid');
    fetchReservationData().then((value) => fetchPetData());
  }

  // Get data
  Future<void> fetchReservationData() async {
    final snapshot = await reservRef.get();
    if (snapshot.exists) {
      Map reservationData = snapshot.value as Map;
      setState(() {
        reservationId = widget.reservationID;
        paymentId = reservationData['payment_id'];
        customerId = reservationData['user_id'];
        services = reservationData['service'];
        taxiRequired = reservationData['taxi'];
        address = reservationData['address'];
        reservedDate = reservationData['date'];
        reservedTime = reservationData['time'];
        package = reservationData['package'];
        price = double.parse(reservationData['price'].toString());
        stage = reservationData['stage'];
        status = reservationData['status'];
        pointRedeem = reservationData['free_service'];
        petName = reservationData['pet'];
      });
      final nameSnapshot = await FirebaseDatabase.instance
          .ref('users/$customerId/Profile')
          .child('full_name')
          .get();
      setState(() {
        customerName = nameSnapshot.value.toString();
        if (package.isNotEmpty) {
          serviceType = "Package";
        } else if (pointRedeem) {
          serviceType = "Loyalty Point Redemption";
        } else {
          serviceType = "Normal";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: showDetailPage
            ? Column(
                children: [
                  // Header
                  const AdminHeader(pageTitle: 'Reservation Detail'),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppColors.mainColor),
                                borderRadius: BorderRadius.circular(15)),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 5, bottom: 5),
                            margin: const EdgeInsets.only(
                                top: 80, left: 15, right: 10, bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Reservation ID:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitleText(
                                      text: reservationId.replaceFirst("-", ""),
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Payment ID:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitleText(
                                      text: paymentId,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Customer Name:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitleText(
                                      text: customerName,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Selected Pet:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          petInfoDialog(context);
                                        },
                                        child: const Text('Show Pet Info'))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Service Type:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitleText(
                                      text: serviceType,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (serviceType == 'Package')
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: TitleText(
                                          text: "Package:",
                                          size: 16,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      TitleText(
                                        text: package,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                if (serviceType == 'Package')
                                  const SizedBox(
                                    height: 10,
                                  ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Services:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitleText(
                                      text: services,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Taxi Required:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitleText(
                                      text: taxiRequired.toString(),
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                taxiRequired
                                    ? Row(
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            child: TitleText(
                                              text: "Address:",
                                              size: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: 196,
                                            child: Text(
                                              address,
                                              softWrap: true,
                                              // overflow: TextOverflow.clip,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: AppColors.mainColor,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container(),
                                if (taxiRequired)
                                  const SizedBox(
                                    height: 10,
                                  ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Reserved Date:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitleText(
                                      text: reservedDate,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Reserved Time:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitleText(
                                      text: reservedTime,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Price:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitleText(
                                      text: price.toString(),
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Status:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitleText(
                                      text: status,
                                      size: 16,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TitleText(
                                        text: "Stage:",
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TitleText(
                                      text: _identifyStage(),
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (status != 'Canceled' && status != 'Completed')
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 130,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _showCancelBookingDialog(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('Cancel Booking'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _showAcceptTaskOptions(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: const Text('Accept Task'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Column(children: [
                // Header
                const AdminHeader(pageTitle: "Track Progress"),

                // ------body content-----

                // Processing
                stage == 1 || stage == 2
                    ? Expanded(
                        child: Container(
                          child: Stack(
                            children: [
                              Container(
                                height: 410,
                                color: Colors.lightBlueAccent,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 270,
                                  padding: const EdgeInsets.only(
                                      top: 2, left: 20, right: 20),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("#$reservationId",
                                          style: const TextStyle(
                                              color: AppColors.mainColor,
                                              fontSize: 18)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text("Booking Progress:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 19,
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(_identifyStage(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // Show address
                                      if (stage == 1)
                                        Text(
                                          address,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: AppColors.mainColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),

                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  stage = 0;
                                                  showDetailPage = true;
                                                });
                                                await reservRef.update({
                                                  'stage': stage
                                                }).then((value) {
                                                  print(
                                                      "Stage changed to $stage");
                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: const Text(
                                                  "Cancel Service",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                _checkStageAndRequirementForPickUp();
                                                if (stage == 3) {
                                                  showDetailPage = true;
                                                }
                                              },
                                              child: Container(
                                                height: 40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: AppColors.mainColor
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                  stage == 1
                                                      ? "Picked Up"
                                                      : "Complete Task",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),

                stage == 4
                    ? Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 1.3,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            // color: Colors.amber,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("#$reservationId",
                                    style: const TextStyle(
                                        color: AppColors.mainColor,
                                        fontSize: 22)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text("Booking Progress: ${_identifyStage()}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: const AssetImage(
                                            "assets/images/bath.png")),
                                  ),
                                ),
                                const SizedBox(
                                  height: 60,
                                ),
                                Text(
                                  "The progress now is Grooming! You may pressed the Complete Task button when you've finished the service.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        stage = 3;
                                        showDetailPage = true;
                                      });
                                      await reservRef.update(
                                          {'stage': stage}).then((value) {
                                        print("Stage changed to $stage");
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Text(
                                        "Cancel Service",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _checkStageAndRequirementForGrooming();

                                      showDetailPage = true;
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor
                                            .withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        "Complete Task",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),

                stage == 6
                    ? Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 1.3,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            // color: Colors.amber,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("#$reservationId",
                                    style: const TextStyle(
                                        color: AppColors.mainColor,
                                        fontSize: 22)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text("Booking Progress: ${_identifyStage()}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  height: 200,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/hotel.png")),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Text(
                                  "You may use the chatbox to realtime update our customer about their pets, and don't forget their safety and happiness are our objectives😊🐾",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        stage = 3;
                                        showDetailPage = true;
                                      });
                                      await reservRef.update(
                                          {'stage': stage}).then((value) {
                                        print("Stage changed to $stage");
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Text(
                                        "Cancel Service",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _checkStageAndRequirementForBoarding();

                                      showDetailPage = true;
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor
                                            .withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        "Complete Task",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),

                stage == 7
                    ? Expanded(
                        child: Container(
                          child: Stack(
                            children: [
                              Container(
                                height: 410,
                                color: Colors.lightBlueAccent,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 270,
                                  padding: const EdgeInsets.only(
                                      top: 2, left: 20, right: 20),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text("Booking Progress:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 19,
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(_identifyStage(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "You are now going to deliver customer's pet to their home, please confirm the address before departure. Safety is priority.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        address,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: AppColors.mainColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  stage = 5;
                                                  showDetailPage = true;
                                                });
                                                await reservRef.update({
                                                  'stage': stage
                                                }).then((value) {
                                                  print(
                                                      "Stage changed to $stage");
                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: const Text(
                                                  "Cancel Service",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                _checkStageAndRequirementForDeliver();

                                                showDetailPage = true;
                                              },
                                              child: Container(
                                                height: 40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: AppColors.mainColor
                                                      .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                  "Complete Task",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ]));
  }

  void petInfoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pet Information'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Name",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    InfoText(
                      text: selectedPet['name'],
                      normal: false,
                      size: 18,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Gender",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    InfoText(
                      text: selectedPet['gender'],
                      normal: false,
                      size: 18,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Pet Type",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    InfoText(
                      text: selectedPet['type'],
                      normal: false,
                      size: 18,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Breed",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    InfoText(
                      text: selectedPet['breed'],
                      normal: false,
                      size: 18,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        "Size",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    InfoText(
                      text: selectedPet['size'],
                      normal: false,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
  }

  Future<void> fetchPetData() async {
    petRef = FirebaseDatabase.instance.ref('users/$customerId/Pet');
    petRef.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map petData = snapshot.value as Map;
      petData.forEach((key, value) {
        if (value['data']['name'] == petName) {
          setState(() {
            selectedPet = value['data'];
          });
        }
      });
    });
  }

  void _showAcceptTaskOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (stage < 3 && taxiRequired)
              ListTile(
                leading: const Icon(Icons.directions_car),
                title: const Text('Pick-up'),
                onTap: () {
                  Navigator.pop(context);

                  _checkStageAndRequirementForPickUp();
                },
              ),
            if (((stage == 0 && !taxiRequired) || stage == 3) &&
                (services == "Cat Full Grooming" ||
                    services == "Dog Full Grooming" ||
                    services == "Cat Basic Grooming" ||
                    services == "Dog Basic Grooming"))
              ListTile(
                leading: const Icon(Icons.shower_outlined),
                title: const Text('Grooming'),
                onTap: () {
                  Navigator.pop(context);
                  _checkStageAndRequirementForGrooming();
                },
              ),
            if (((stage == 0 && !taxiRequired) || stage == 3) &&
                (services == "Cat Boarding" || services == "Dog Boarding"))
              ListTile(
                leading: const Icon(Icons.hotel_outlined),
                title: const Text('Boarding'),
                onTap: () {
                  Navigator.pop(context);
                  _checkStageAndRequirementForBoarding();
                },
              ),
            if (((stage == 5 && taxiRequired)))
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Deliver Home'),
                onTap: () {
                  Navigator.pop(context);
                  _checkStageAndRequirementForDeliver();
                },
              ),
          ],
        );
      },
    );
  }

  void _showCancelBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String cancellationReason = '';
        return AlertDialog(
          title: const Text('Confirm Cancellation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  cancellationReason = value;
                },
                decoration:
                    const InputDecoration(labelText: 'Reason for cancellation'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle cancel button
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Check if they input the reason of cancel
                if (cancellationReason.isNotEmpty) {
                  final ref = FirebaseDatabase.instance.ref('reservations');
                  await ref.child(widget.reservationID).update({
                    'status': 'Canceled',
                    'cancel_reason': cancellationReason,
                  }).then((value) {
                    _showSuccessDialog(
                      context,
                      "Canceled Successfully",
                      "You have canceled a reservation.",
                    );
                  });
                } else {
                  showMessageDialog(context, "Fail to Cancel",
                      "Please write down the reason of reservation cancellation, thank you.");
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSuccessDialog(
      BuildContext context, String title, String message) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    Navigator.pop(context); // Pop the context after the dialog is dismissed
  }

  Future<void> _checkStageAndRequirementForPickUp() async {
    if (stage == 0) {
      if (taxiRequired) {
        //Proceed
        //Change stage to 1
        setState(() {
          stage = 1;
//Navigate to mapPage with a button of picked up
          showDetailPage = false;
        });
        //Add driver to reservation database, also update stage in DB
        ////Change status to 'processing'
        final ref = FirebaseDatabase.instance.ref('reservations');
        await ref.child(reservationId).update({
          'stage': stage,
          'driver': currentUID,
          'status': 'Processing'
        }).then((value) {
          print("Stage changed to $stage, Driver updated");
        });
      } else {
        showMessageDialog(context, "Unavailable Task",
            "The customer do not require for Pet Taxi service.");
      }
    } else if (stage == 1) {
      //Change stage to 2(heading to ohmypet)
      setState(() {
        stage = 2;
      });
      await reservRef.update({
        'stage': stage,
      }).then((value) => print("Stage changed to $stage"));
    } else if (stage == 2) {
      //Change stage to 3(Arrived and waiting)
      setState(() {
        stage = 3;
      });
      await reservRef.update({
        'stage': stage,
      }).then((value) => print("Stage changed to $stage"));
    } else {
      showMessageDialog(context, "Unavailable Task",
          "You cannot accept this task right now.");
    }
  }

  Future<void> _checkStageAndRequirementForGrooming() async {
    if (stage == 0) {
      if (taxiRequired) {
        showMessageDialog(context, "Accept Failed",
            "Customer required transportation, you cannot skip the progress, please check again.");
      } else if (services == "Cat Full Grooming" ||
          services == "Dog Full Grooming" ||
          services == "Cat Basic Grooming" ||
          services == "Dog Basic Grooming") {
        //Change the stage to 4
        //Change the status to 'processing'
        //Add Groomer to reservation database
        setState(() {
          stage = 4;
          showDetailPage = false;
        });
        await reservRef.update({
          'stage': stage,
          'groomer': currentUID,
          'status': 'Processing'
        }).then((value) {
          print("Stage changed to $stage, groomer updated");
        });
      } else {
        showMessageDialog(context, "Unavailable Task",
            "The customer did not ask for this service.");
      }
    } else if (stage == 3) {
      if (services == "Cat Full Grooming" ||
          services == "Dog Full Grooming" ||
          services == "Cat Basic Grooming" ||
          services == "Dog Basic Grooming") {
        //Change the stage to 4
        //Add Groomer to reservation database
        setState(() {
          stage = 4;
          showDetailPage = false;
        });
        await reservRef
            .update({'stage': stage, 'groomer': currentUID}).then((value) {
          print("Stage changed to $stage, groomer updated");
        });
      }
    } else if (stage == 4) {
      if (taxiRequired) {
        //Change the stage to 5
        setState(() {
          stage = 5;
        });
        await reservRef.update({
          'stage': stage,
        }).then((value) {
          print("Stage changed to $stage");
        });
      } else {
        //Change the stage to 8
        //Change the stage to Complete
        setState(() {
          stage = 8;
        });
        await reservRef
            .update({'stage': stage, 'status': 'Completed'}).then((value) {
          print("Stage changed to $stage, task completed");
          Navigator.pop(context);
        });
      }
    } else {
      showMessageDialog(
          context, "Unavailable Task", "You cannot accept the task now.");
    }
  }

  void showMessageDialog(
      BuildContext context, String titleText, String contentText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: Text(contentText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkStageAndRequirementForBoarding() async {
    if (stage == 0) {
      if (taxiRequired) {
        showMessageDialog(context, "Accept Failed",
            "Customer required transportation, you cannot skip the progress, please check again.");
      } else if (services == "Cat Boarding" || services == "Dog Boarding") {
        //Change the stage to 6
        //Change the status to 'processing'
        //Add Carer to reservation database
        setState(() {
          stage = 6;
          showDetailPage = false;
        });
        await reservRef.update({
          'stage': stage,
          'carer': currentUID,
          'status': 'Processing'
        }).then((value) {
          print("Stage changed to $stage, carer updated");
        });
      } else {
        showMessageDialog(context, "Unavailable Task",
            "The customer did not ask for this service.");
      }
    } else if (stage == 3) {
      //Add Carer to reservation database
      //Change the stage to 6
      setState(() {
        stage = 6;
        showDetailPage = false;
      });
      await reservRef
          .update({'stage': stage, 'carer': currentUID}).then((value) {
        print("Stage changed to $stage, carer updated");
      });
    }
    // else if(stage == 5 || (services == "Cat Boarding" || services == "Dog Boarding")){
    //Change the stage to 6
    //Navigate to a page with a button of complete task and send message
    //Add Carer to reservation database
    // }
    else if (stage == 6) {
      if (taxiRequired) {
        //Change the stage back to 5
        setState(() {
          stage = 5;
        });
        await reservRef.update({'stage': stage}).then((value) {
          print("Stage changed to $stage");
        });
      } else {
        //Change the stage to 8
        //Change the stage to Complete
        setState(() {
          stage = 8;
        });
        await reservRef
            .update({'stage': stage, 'status': 'Completed'}).then((value) {
          print("Stage changed to $stage, task completed");
          Navigator.pop(context);
        });
      }
    } else {
      showMessageDialog(
          context, "Unavailable Task", "You cannot accept the task now.");
    }
  }

  Future<void> _checkStageAndRequirementForDeliver() async {
    if (stage == 5) {
      if (taxiRequired) {
        //Change the stage to 7
        //Add driver to reservation database
        setState(() {
          stage = 7;
          showDetailPage = false;
        });
        await reservRef.update(
            {'stage': stage, 'second_driver': currentUID}).then((value) {
          print("Stage changed to $stage, second_driver updated");
        });
      } else {
        showMessageDialog(
            context, "Unavailable Task", "You cannot accept the task now.");
      }
    } else if (stage == 7) {
      //Change stage to 8
      //Change status to 'complete'
      setState(() {
        stage = 8;
      });
      await reservRef
          .update({'stage': stage, 'status': 'Completed'}).then((value) {
        print("Stage changed to $stage, second_driver updated");
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReservationManagement(role: widget.role)));
    } else {
      showMessageDialog(context, "Unavailable Task",
          "You cannot accept this task right now.");
    }
  }

  String _identifyStage() {
    if (stage == 0) {
      return "Incoming";
    } else if (stage == 1) {
      return "Pick Up";
    } else if (stage == 2) {
      return "Sending";
    } else if (stage == 3) {
      return "Queuing";
    } else if (stage == 4) {
      return "Grooming";
    } else if (stage == 5) {
      return "Awaiting";
    } else if (stage == 6) {
      return "Boarding";
    } else if (stage == 7) {
      return "Deliver Home";
    } else if (stage == 8) {
      return "Completed";
    }
    return "";
  }
}
