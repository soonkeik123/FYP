import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/admin/task_accept.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/admin_header.dart';
import 'package:ohmypet/widgets/title_text.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String customerPhone = '';
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
  bool taskAccepted = false;

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

  @override
  void dispose() {
    super.dispose();
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
        taskAccepted = reservationData['task_accepted'];
      });
      final Snapshot = await FirebaseDatabase.instance
          .ref('users/$customerId/Profile')
          .get();
      if (Snapshot.exists) {
        Map user = Snapshot.value as Map;
        customerName = user['full_name'].toString();
        customerPhone = user['phone'].toString();
      }
      setState(() {
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
      body: Column(
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
                        border:
                            Border.all(width: 1, color: AppColors.mainColor),
                        borderRadius: BorderRadius.circular(15)),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 5),
                    margin: const EdgeInsets.only(
                        top: 60, left: 15, right: 10, bottom: 15),
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
                              text: paymentId.substring(paymentId.length - 10),
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
                            Container(
                              width: 155,
                              child: Text(
                                services,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.mainColor),
                              ),
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
                              text: taxiRequired ? "Yes" : "No",
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
                              text: "RM ${price.toStringAsFixed(2)}",
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String phoneNumber = "+$customerPhone";

          final Uri uri = Uri.https(
            'api.whatsapp.com',
            '/send',
            {'phone': phoneNumber},
          );
          // Use the phone number with country code
          if (await canLaunch(uri.toString())) {
            await launch(uri.toString());
          } else {
            throw 'Could not launch $uri';
          }
        },
        backgroundColor: Colors.green, // Green background color
        child: const Icon(
          Icons.phone, // Phone icon
          color: Colors.white, // Icon color
        ),
      ),
    );
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
                    SizedBox(
                      width: 150,
                      child: Text(
                        selectedPet['breed'],
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            overflow: TextOverflow.ellipsis),
                      ),
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
        if (value['name'] == petName) {
          setState(() {
            selectedPet = value;
          });
        }
      });
    });
  }

  void _showAcceptTaskOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return package.isNotEmpty
            ?

            // Package service
            Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (stage < 3 && taxiRequired)
                    ListTile(
                      leading: const Icon(Icons.directions_car),
                      title: const Text('Pick-up'),
                      onTap: () {
                        showConfirmationDialog().then((value) => {
                              if (value != null && value)
                                {
                                  Navigator.pop(context),
                                  _checkStageAndRequirementForPickUp(),
                                }
                              else
                                {
                                  Navigator.pop(context),
                                }
                            });
                      },
                    ),
                  if (((stage == 0 && !taxiRequired) || stage == 3))
                    Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.shower_outlined),
                          title: const Text('Grooming'),
                          onTap: () {
                            showConfirmationDialog().then((value) => {
                                  if (value != null && value)
                                    {
                                      Navigator.pop(context),
                                      _checkStageAndRequirementForGrooming(),
                                    }
                                  else
                                    {
                                      Navigator.pop(context),
                                    }
                                });
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.hotel_outlined),
                          title: const Text('Boarding'),
                          onTap: () {
                            showConfirmationDialog().then((value) => {
                                  if (value != null && value)
                                    {
                                      Navigator.pop(context),
                                      _checkStageAndRequirementForBoarding(),
                                    }
                                  else
                                    {
                                      Navigator.pop(context),
                                    }
                                });
                          },
                        ),
                      ],
                    ),
                  if (((stage == 5 && taxiRequired)))
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: const Text('Deliver Home'),
                      onTap: () {
                        showConfirmationDialog().then((value) => {
                              if (value != null && value)
                                {
                                  Navigator.pop(context),
                                  _checkStageAndRequirementForDeliver(),
                                }
                              else
                                {
                                  Navigator.pop(context),
                                }
                            });
                      },
                    ),
                ],
              )
            :
            // Normal - Single service
            Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (stage < 3 && taxiRequired)
                    ListTile(
                      leading: const Icon(Icons.directions_car),
                      title: const Text('Pick-up'),
                      onTap: () {
                        showConfirmationDialog().then((value) => {
                              if (value != null && value)
                                {
                                  Navigator.pop(context),
                                  _checkStageAndRequirementForPickUp(),
                                }
                              else
                                {
                                  Navigator.pop(context),
                                }
                            });
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
                        showConfirmationDialog().then((value) => {
                              if (value != null && value)
                                {
                                  Navigator.pop(context),
                                  _checkStageAndRequirementForGrooming(),
                                }
                              else
                                {
                                  Navigator.pop(context),
                                }
                            });
                      },
                    ),
                  if (((stage == 0 && !taxiRequired) || stage == 3) &&
                      (services == "Cat Boarding" ||
                          services == "Dog Boarding"))
                    ListTile(
                      leading: const Icon(Icons.hotel_outlined),
                      title: const Text('Boarding'),
                      onTap: () {
                        showConfirmationDialog().then((value) => {
                              if (value != null && value)
                                {
                                  Navigator.pop(context),
                                  _checkStageAndRequirementForBoarding(),
                                }
                              else
                                {
                                  Navigator.pop(context),
                                }
                            });
                      },
                    ),
                  if (((stage == 5 && taxiRequired)))
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: const Text('Deliver Home'),
                      onTap: () {
                        showConfirmationDialog().then((value) => {
                              if (value != null && value)
                                {
                                  Navigator.pop(context),
                                  _checkStageAndRequirementForDeliver(),
                                }
                              else
                                {
                                  Navigator.pop(context),
                                }
                            });
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
      //Proceed
      //Change stage to 1
      setState(() {
        stage = 1;
      });
      //Add driver to reservation database, also update stage in DB
      ////Change status to 'processing'
      final ref = FirebaseDatabase.instance.ref('reservations');
      await ref.child(reservationId).update({
        'stage': stage,
        'driver': currentUID,
        'status': 'Processing',
        'task_accepted': true,
      }).then((value) {
        print("Stage changed to $stage, Driver updated");
        redirectPage();
      });
    } else {
      showMessageDialog(
          context, "Accept Fail", "Other staff is taking this task.");
    }
  }

  Future<void> _checkStageAndRequirementForGrooming() async {
    if (stage == 0 || stage == 3) {
      //Change the stage to 4
      //Change the status to 'processing'
      //Add Groomer to reservation database
      setState(() {
        stage = 4;
      });
      await reservRef.update({
        'stage': stage,
        'groomer': currentUID,
        'status': 'Processing',
        'task_accepted': true,
      }).then((value) {
        redirectPage();
      });
    } else {
      showMessageDialog(
          context, "Accept Fail", "Other staff is taking this task.");
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
    if (stage == 0 || stage == 3) {
      //Change the stage to 6
      //Change the status to 'processing'
      //Add Carer to reservation database
      setState(() {
        stage = 6;
      });
      await reservRef.update({
        'stage': stage,
        'carer': currentUID,
        'status': 'Processing',
        'task_accepted': true,
      }).then((value) {
        redirectPage();
      });
    } else {
      showMessageDialog(
          context, "Accept Fail", "Other staff is taking this task.");
    }
  }

  Future<void> _checkStageAndRequirementForDeliver() async {
    if (stage == 5) {
      //Change the stage to 7
      //Add driver to reservation database
      setState(() {
        stage = 7;
      });
      await reservRef.update({
        'stage': stage,
        'second_driver': currentUID,
        'task_accepted': true
      }).then((value) {
        redirectPage();
      });
    } else {
      showMessageDialog(context, "Unavailable Task",
          "You cannot accept this task right now.");
    }
  }

  Future showConfirmationDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Set your desired border radius here
          ),
          backgroundColor:
              Colors.white, // Set the background color of the dialog
          title: const Text('Confirmation'),
          titleTextStyle: const TextStyle(
            color:
                AppColors.mainColor, // Set your desired title text color here
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          content: const SizedBox(
            height: 50,
            child: Text('Do you confirm to accept this task?'),
          ),
          contentTextStyle: const TextStyle(
            color:
                AppColors.mainColor, // Set your desired content text color here
            fontSize: 17.0,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, false); // Return false to indicate cancellation
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, true); // Return true to indicate confirmation
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void redirectPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TaskAccept(
                reservationID: widget.reservationID, role: widget.role)));
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
