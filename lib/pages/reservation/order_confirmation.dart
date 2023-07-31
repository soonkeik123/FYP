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
  late double price;
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
    price = calculatePrice();
  }

  double calculatePrice() {
    double totalPrice = 0 + widget.price;
    if (freeService) {
      totalPrice = 0;
    } else {
      if (packageSelected.isEmpty) {
        if (serviceSelected == "Cat Boarding" ||
            serviceSelected == "Dog Boarding") {
          if (getPetSize() == "Small" || getPetSize() == "Medium") {
            if (roomSelected == "D1" || roomSelected == "C1") {
              totalPrice += 50;
            } else if (roomSelected == "D2" || roomSelected == "C2") {
              totalPrice += 60;
            } else if (roomSelected == "D3" || roomSelected == "C3") {
              totalPrice += 70;
            }
          } else if (getPetSize() == "Large" || getPetSize() == "Giant") {
            if (roomSelected == "D1" || roomSelected == "C1") {
              totalPrice += 60;
            } else if (roomSelected == "D2" || roomSelected == "C2") {
              totalPrice += 70;
            } else if (roomSelected == "D3" || roomSelected == "C3") {
              totalPrice += 80;
            }
          }
        }
      }
    }
    return totalPrice;
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
                                Text(
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
                        ("RM ${calculatePrice()}"),
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
                            print("ok He PRESSED!");
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
}
