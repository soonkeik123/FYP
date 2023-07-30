import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ohmypet/pages/reservation/order_confirmation.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/big_text.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:ohmypet/widgets/small_text.dart';
import 'package:ohmypet/widgets/title_text.dart';

class GroomReservationPage extends StatefulWidget {
  static const dogBasicGroomReservation = '/dogBasicGroomReservation';
  static const catBasicGroomReservation = '/catBasicGroomReservation';
  static const dogFullGroomReservation = '/dogFullGroomReservation';
  static const catFullGroomReservation = '/catFullGroomReservation';
  bool dogGroom;
  bool fullGroom;
  GroomReservationPage(
      {super.key, required this.dogGroom, required this.fullGroom});

  @override
  State<GroomReservationPage> createState() => _GroomReservationPageState();
}

class _GroomReservationPageState extends State<GroomReservationPage> {
  // Create a reference to Firebase database
  late DatabaseReference dbPetRef;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late bool isDog; // Define if it's dog or cat
  late bool isFull; // Define if it is Full Grooming

  String serviceName = "";
  String selectedName = "";
  String dropdownValue1 = '';
  String dropdownValue2 = '';

  // Pet Selection
  List<String> petNames = [];
  List<Map> petList = [];
  // Time Selection
  List<String> timeList = <String>['10:00AM', '12:00PM', '2:00PM', '4:00PM'];
  // Date Picker
  TextEditingController dateInput = TextEditingController();
  // Pet Taxi Checkbox
  bool isChecked = false;

  bool _isDisposed = false;

  @override
  void initState() {
    // Differentiate the service selected
    isDog = widget.dogGroom;
    isFull = widget.fullGroom;
    if (isDog && isFull) {
      serviceName = "Dog Full Grooming";
    } else if (isDog && !isFull) {
      serviceName = "Dog Basic Grooming";
    } else if (!isDog && isFull) {
      serviceName = "Cat Full Grooming";
    } else {
      serviceName = "Cat Basic Grooming";
    }
    dropdownValue2 = timeList.first;

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
    getAllPet();
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    petNames.clear();
    super.dispose();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void getAllPet() {
    dbPetRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        // Check if the widget is still mounted and data is not null
        Map<dynamic, dynamic> petData = snapshot.value as Map<dynamic, dynamic>;
        // Iterate through the pet data to get pet names
        petData.forEach((key, value) {
          if (!_isDisposed) {
            // Check if the widget is still mounted before updating the state

            petList.add(value['data']);
            if (isDog) {
              if (value['data']['type'] == 'Dog') {
                setState(() {
                  petNames.add(value['data']['name']);
                });
              }
            } else {
              if (value['data']['type'] == 'Cat') {
                setState(() {
                  petNames.add(value['data']['name']);
                });
              }
            }
          }
        });
        if (petNames.isEmpty) {
          setState(() {
            dropdownValue1 = "";
          });
        }
        // print('Pet Names: $petNames'); // Checking purpose
      } else {
        // No pets found for the user or widget is disposed
        print('No pets found for the user or widget is disposed.');
      }
    }, onError: (error) {
      // Error retrieving data from the database
      print('Error fetching pet data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (petNames.isNotEmpty) dropdownValue1 = petNames.first;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          const CustomHeader(
            pageTitle: "Make Reservation",
          ),

          Expanded(
            child: Align(
                alignment: Alignment.center,
                heightFactor: 1.25,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pet Selection
                          TitleText(text: "Select Your Pet:"),
                          const SizedBox(
                            height: 5,
                          ),

                          // Select Pet
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: AppColors.mainColor, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: AppColors.mainColor, width: 1),
                              ),
                              filled: false,
                            ),
                            dropdownColor: Colors.white,
                            value: dropdownValue1,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue1 = newValue!;
                              });
                            },
                            items: petNames
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      fontSize: 17, color: AppColors.mainColor),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          // Selected Service
                          TitleText(text: "Selected Service:"),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15),
                              border: Border.all(
                                  color: AppColors.mainColor, width: 1.0),
                            ),
                            alignment: Alignment.centerLeft,
                            width: 230,
                            height: 50,
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              enabled: false,
                              textAlign: TextAlign.left,
                              controller: TextEditingController(
                                text: serviceName,
                              ),
                              style:
                                  const TextStyle(color: AppColors.mainColor),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // Choose Date
                          TitleText(text: "Choose Date:"),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            height: 60,
                            width: 230,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15),
                              border: Border.all(
                                  color: AppColors.mainColor, width: 1.0),
                            ),
                            child: TextField(
                              controller: dateInput,
                              //editing controller of this TextField
                              decoration: const InputDecoration(
                                  iconColor: AppColors.mainColor,
                                  icon: Icon(Icons
                                      .calendar_today), //icon of text field
                                  labelText: "Enter Date", //label text of field
                                  border: InputBorder.none),
                              readOnly: true,
                              //set it true, so that user will not able to edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2024));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    dateInput.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {}
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // Select Pet
                          TitleText(text: "Select Timeslot:"),
                          const SizedBox(
                            height: 5,
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: AppColors.mainColor, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    color: AppColors.mainColor, width: 1),
                              ),
                              filled: false,
                            ),
                            dropdownColor: Colors.white,
                            value: dropdownValue2,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue2 = newValue!;
                              });
                            },
                            items: timeList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      fontSize: 17, color: AppColors.mainColor),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // Pet Taxi
                          Row(
                            children: [
                              Checkbox(
                                  activeColor: AppColors.mainColor,
                                  value: isChecked,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      isChecked = newValue ?? false;
                                    });
                                  }),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleText(text: "Pet Taxi Required"),
                                  SmallText(
                                    text: "(Exclusive fee will be charged)",
                                    size: Dimensions.font10 + 2,
                                    color: AppColors.mainColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          isChecked
                              ? Container(
                                  height: 360,
                                  width: double.maxFinite,
                                  child: GoogleMap(
                                    mapType: MapType.hybrid,
                                    initialCameraPosition: _kGooglePlex,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _controller.complete(controller);
                                    },
                                  ),
                                )
                              : Container(),

                          const SizedBox(
                            height: 10,
                          ),

                          // Next Button
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrderConfirmationPage()));
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius30),
                                color: AppColors.mainColor,
                              ),
                              height: 40,
                              width: 140,
                              child: BigText(
                                text: "Next",
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            // Positioned(
            //     bottom: -5,
            //     left: -5,
            //     child: SizedBox(
            //       height: 140,
            //       child: Image.asset("assets/images/cute-image-1.png"),
            //     )),
          ),
        ],
      ),
    );
  }
}
