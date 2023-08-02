import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/big_text.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:ohmypet/widgets/title_text.dart';

class OrderConfirmationPage extends StatefulWidget {
  static const routeName = '/confirmOrder';

  final String pet;
  final String service;
  final String date;
  final String time;
  final String room;
  final bool taxi;
  final double price;
  final String address;
  final String package;
  final bool pointRedeem;

  const OrderConfirmationPage({
    super.key,
    required this.pet,
    required this.service,
    required this.date,
    required this.time,
    required this.room,
    required this.taxi,
    required this.address,
    required this.package,
    required this.pointRedeem,
    required this.price,
  });

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  // Create a reference to Firebase database
  late DatabaseReference dbPetRef;

  // Pet
  late String petSelected;
  // Service
  late String serviceSelected;
  // Date
  late String dateSelected;
  // Time
  late String timeSelected;
  // Room Selection
  late String roomSelected;
  // Pet Taxi Checkbox
  late bool taxiChecked;
  // Address
  late String addressInput;
  // Price
  late double priceGet;
  // Package
  late String packageSelected;
  // Point Redemption
  late bool freeService;
  // Pet size for define price
  late String petSize;

  @override
  void initState() {
    super.initState();

    // 'Recognize the user' and 'Define the path'
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      dbPetRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(uid)
          .child('Pet');
    }
    // Data declaration
    setOrderData();
  }

  void setOrderData() {
    // Check if package was selected
    petSelected = widget.pet;
    serviceSelected = widget.service;
    dateSelected = widget.date;
    timeSelected = widget.time;
    roomSelected = widget.room;
    taxiChecked = widget.taxi;
    addressInput = widget.address;
    packageSelected = widget.package;
    freeService = widget.pointRedeem;
    priceGet = widget.price;
  }

  void isFreeService() {
    if (freeService && taxiChecked) {
      priceGet = 20;
    } else if (freeService && !taxiChecked) {
      priceGet = 0;
    }
  }

  String getPetSize() {
    String size = "";
    dbPetRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        // Check if the widget is still mounted and data is not null
        Map<dynamic, dynamic> petData = snapshot.value as Map<dynamic, dynamic>;
        // Iterate through the pet data to get pet names
        petData.forEach((key, value) {
          if (value['data']['name'] == petSelected) {
            size = value['data']['size'];
          }
        });
        print('Pet size: $size'); // Checking purpose
      } else {
        // No pets found for the user or widget is disposed
        print('No pets found for the user or widget is disposed.');
      }
    }, onError: (error) {
      // Error retrieving data from the database
      print('Error fetching pet data: $error');
    });
    return size;
  }

  @override
  Widget build(BuildContext context) {
    isFreeService();
    return Scaffold(
        backgroundColor: AppColors.themeColor,
        body: Column(
          children: [
            // Header
            const CustomHeader(
              pageTitle: "Make Reservation",
            ),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                alignment: Alignment.centerLeft,
                height: double.maxFinite, //MediaQuery.of(context).size.height,
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pet Selection
                      TitleText(text: "Pet Selected:"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        petSelected,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Selected Service
                      TitleText(text: "Selected Service:"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        serviceSelected,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children:
                      //   selectedService.map((item) => Text(item,
                      //           style: const TextStyle(
                      //               fontSize: 18, fontWeight: FontWeight.w500)))
                      //       .toList(),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Date
                      TitleText(text: "Date Selected:"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        dateSelected,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Time
                      roomSelected == ''
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleText(text: "Time Selected:"),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  timeSelected,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          : Container(),

                      const SizedBox(
                        height: 10,
                      ),

                      // Room Selected
                      roomSelected != ''
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Room Selected:",
                                  style: TextStyle(
                                      fontSize: 20, color: AppColors.mainColor),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  roomSelected,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          : Container(),

                      const SizedBox(
                        height: 10,
                      ),

                      // Pet Taxi
                      TitleText(text: "Pet Taxi Required"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        taxiChecked ? "Yes" : "None",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Addresss
                      taxiChecked
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleText(text: "Address"),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  addressInput,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          : Container(),

                      // Total Price
                      TitleText(text: "Total Price"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        ("RM $priceGet"),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            isFreeService();
                            User? user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              String uid = user.uid;
                              // Now you have the UID of the current user

                              // For storing the reservation to database
                              DatabaseReference reservationRef =
                                  FirebaseDatabase.instance
                                      .ref()
                                      .child('reservations');
                              // For update the user loyalty point
                              DatabaseReference profileLoyaltyRef =
                                  FirebaseDatabase.instance
                                      .ref()
                                      .child('users')
                                      .child(uid)
                                      .child('Profile')
                                      .child('point');

                              Map<String, dynamic> reservationData = {
                                'user_id': uid,
                                'pet': petSelected,
                                'service': serviceSelected,
                                'date': dateSelected,
                                'time': timeSelected,
                                'room': roomSelected,
                                'taxi': taxiChecked,
                                'address': addressInput,
                                'package': packageSelected,
                                'free_service': freeService,
                                'price': priceGet,
                                'payment_id': '',
                                'status': 'Incoming',
                                'stage': 0,
                              };

                              // Create a new unique key for reservation
                              DatabaseReference newReservationRef =
                                  reservationRef.push();

                              // Set the reservation data at the new unique key
                              newReservationRef
                                  .set(reservationData)
                                  .then((_) async {
                                // Reservation data is successfully stored in the database
                                print('Reservation data stored successfully');

                                // Add and update the user's loyalty point
                                // Get the current points value
                                final DataSnapshot snapshot =
                                    await profileLoyaltyRef.get();
                                if (snapshot.exists) {
                                  final data = snapshot.value;

                                  int newPoint = 0;

                                  if (freeService &&
                                      (serviceSelected ==
                                              'Cat Basic Grooming' ||
                                          serviceSelected ==
                                              'Dog Basic Grooming')) {
                                    newPoint = int.parse(data.toString()) - 600;
                                  } else if (freeService &&
                                      (serviceSelected == 'Cat Full Grooming' ||
                                          serviceSelected ==
                                              'Dog Full Grooming')) {
                                    newPoint = int.parse(data.toString()) - 800;
                                  } else {
                                    newPoint = int.parse(data.toString()) +
                                        priceGet.toInt();
                                  }

                                  print("new point : $newPoint");
                                  await profileLoyaltyRef
                                      .set(newPoint)
                                      .then((value) {
                                    showSuccessfulDialog(context);
                                    Navigator.popAndPushNamed(
                                        context, '/reservation');
                                  });
                                }
                              }).catchError((error) {
                                // Handle the error if data storage fails
                                print('Error storing reservation data: $error');
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius30),
                              color: AppColors.mainColor,
                            ),
                            height: 40,
                            width: 230,
                            child: BigText(
                              text: "Confirm & Payment",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  void showSuccessfulDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text('Reservation Added'),
          content: const Text(
              'You have successfully added a new reservation! We will redirect you to reservation page now.\n\nYou may view your loyalty point at Profile page.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                'Sure',
                style: TextStyle(color: AppColors.mainColor),
              ),
            ),
          ],
          backgroundColor:
              Colors.white, // Set your desired background color here
          titleTextStyle: const TextStyle(
            color: Colors.green, // Set your desired title text color here
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.black, // Set your desired content text color here
            fontSize: 16.0,
          ),
          buttonPadding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Set padding for the buttons

          // You can also customize other properties like buttonTextStyle, elevation, etc.
        );
      },
    );
  }
}
