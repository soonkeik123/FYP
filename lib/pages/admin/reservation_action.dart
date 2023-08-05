import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/admin/staff_manage.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/admin_header.dart';
import 'package:ohmypet/widgets/title_text.dart';

import '../../widgets/info_text.dart';

class ReservationActionPage extends StatefulWidget {
  final String reservationID;
  const ReservationActionPage({super.key, required this.reservationID});

  @override
  State<ReservationActionPage> createState() => _ReservationActionPageState();
}

class _ReservationActionPageState extends State<ReservationActionPage> {
  // Create a reference to Firebase database
  late DatabaseReference reservRef;
  late DatabaseReference petRef;

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

  @override
  void initState() {
    super.initState();

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
                    padding:
                        EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                    margin: const EdgeInsets.only(
                        top: 100, left: 15, right: 10, bottom: 15),
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
                            SizedBox(
                              width: 5,
                            ),
                            TitleText(
                              text: reservationId.replaceFirst("-", ""),
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(
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
                            SizedBox(
                              width: 5,
                            ),
                            TitleText(
                              text: paymentId,
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(
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
                            SizedBox(
                              width: 5,
                            ),
                            TitleText(
                              text: customerName,
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(
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
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  petInfoDialog(context);
                                },
                                child: Text('Show Pet Info'))
                          ],
                        ),
                        SizedBox(
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
                            SizedBox(
                              width: 5,
                            ),
                            TitleText(
                              text: serviceType,
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(
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
                              SizedBox(
                                width: 5,
                              ),
                              TitleText(
                                text: package,
                                size: 16,
                              ),
                            ],
                          ),
                        if (serviceType == 'Package')
                          SizedBox(
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
                            SizedBox(
                              width: 5,
                            ),
                            TitleText(
                              text: services,
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(
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
                            SizedBox(
                              width: 5,
                            ),
                            TitleText(
                              text: taxiRequired.toString(),
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(
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
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 196,
                                    child: Text(
                                      address,
                                      softWrap: true,
                                      // overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: AppColors.mainColor,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        if (taxiRequired)
                          SizedBox(
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
                            SizedBox(
                              width: 5,
                            ),
                            TitleText(
                              text: reservedDate,
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(
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
                            SizedBox(
                              width: 5,
                            ),
                            TitleText(
                              text: reservedTime,
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(
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
                            SizedBox(
                              width: 5,
                            ),
                            TitleText(
                              text: price.toString(),
                              size: 16,
                            ),
                          ],
                        ),
                        SizedBox(
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
                            SizedBox(
                              width: 5,
                            ),
                            TitleText(
                              text: status,
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
                                primary: Colors.red,
                              ),
                              child: Text('Cancel Booking'),
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            child: ElevatedButton(
                              onPressed: () {
                                _showAcceptTaskOptions(context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: Text('Accept Task'),
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
    );
  }

  void petInfoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pet Information'),
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
                child: Text('Close'),
              ),
            ],
          );
          ;
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
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Pick-up'),
              onTap: () {
                _checkStageAndRequirementForPickUp();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.brush),
              title: Text('Grooming'),
              onTap: () {
                _checkStageAndRequirementForGrooming();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Boarding'),
              onTap: () {
                _checkStageAndRequirementForBoarding();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('Deliver Home'),
              onTap: () {
                _checkStageAndRequirementForDeliver();
                Navigator.pop(context);
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
          title: Text('Confirm Cancellation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  cancellationReason = value;
                },
                decoration:
                    InputDecoration(labelText: 'Reason for cancellation'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle cancel button
                Navigator.pop(context);
              },
              child: Text('Cancel'),
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
              child: Text('Confirm'),
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
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    Navigator.pop(context); // Pop the context after the dialog is dismissed
  }

  void _checkStageAndRequirementForPickUp() {
    if (stage == 0) {
      if (taxiRequired) {
        //Proceed
        //Change stage to 1
        //Change status to 'processing'
        //Navigate to mapPage with a button of picked up
        //Add driver to reservation database
      } else {
        showMessageDialog(context, "Unavailable Task",
            "The customer do not require for Pet Taxi service.");
      }
    } else if (stage == 1) {
      //Change stage to 2(heading to ohmypet)
    } else if (stage == 2) {
      //Change stage to 3(Arrived and waiting)
    } else {
      showMessageDialog(context, "Unavailable Task",
          "You cannot accept this task right now.");
    }
  }

  void _checkStageAndRequirementForGrooming() {
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
        //Navigate to a page with a button of complete task
        //Add Groomer to reservation database
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
        //Change the status to 'processing'
        //Navigate to a page with a button of complete task
        //Add Groomer to reservation database
      }
    } else if (stage == 4) {
      if (taxiRequired) {
        //Change the stage to 5
      } else {
        //Change the stage to 8
        //Change the stage to Complete
      }
    } else {
      showMessageDialog(
          context, "Unavailable Task", "You cannot accept the task now.");
    }
  }

  void _checkStageAndRequirementForBoarding() {
    if (stage == 0) {
      if (taxiRequired) {
        showMessageDialog(context, "Accept Failed",
            "Customer required transportation, you cannot skip the progress, please check again.");
      } else if (services == "Cat Boarding" || services == "Dog Boarding") {
        //Change the stage to 6
        //Change the status to 'processing'
        //Navigate to a page with a button of complete task and send message
        //Add Carer to reservation database
      } else {
        showMessageDialog(context, "Unavailable Task",
            "The customer did not ask for this service.");
      }
    } else if (stage == 3) {
      //Change the stage to 6
      //Navigate to a page with a button of complete task and send message
      //Add Carer to reservation database
    }
    // else if(stage == 5 || (services == "Cat Boarding" || services == "Dog Boarding")){
    //Change the stage to 6
    //Navigate to a page with a button of complete task and send message
    //Add Carer to reservation database
    // }
    else if (stage == 6) {
      if (taxiRequired) {
        //Change the stage back to 5
      } else {
        //Change the stage to 8
        //Change the stage to Complete
      }
    } else {
      showMessageDialog(
          context, "Unavailable Task", "You cannot accept the task now.");
    }
  }

  void _checkStageAndRequirementForDeliver() {
    if (stage == 5) {
      if (taxiRequired) {
        //Change the stage to 7
        //Change status to 'processing'
        //Navigate to mapPage with a button of picked up
        //Add driver to reservation database
      } else {
        showMessageDialog(
            context, "Unavailable Task", "You cannot accept the task now.");
      }
    } else if (stage == 7) {
      //Change stage to 8
      //Change status to 'complete'
    } else {
      showMessageDialog(context, "Unavailable Task",
          "You cannot accept this task right now.");
    }
  }
}
