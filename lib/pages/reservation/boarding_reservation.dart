import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ohmypet/pages/reservation/select_room.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/big_text.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:ohmypet/widgets/small_text.dart';
import 'package:ohmypet/widgets/title_text.dart';

import 'order_confirmation.dart';

class BoardingReservation extends StatefulWidget {
  static const dogBoardingReservation = '/dogBoardingReservation';
  static const catBoardingReservation = '/catBoardingReservation';
  bool dogBoard;
  BoardingReservation({super.key, required this.dogBoard});

  @override
  State<BoardingReservation> createState() => _BoardingReservationState();
}

class _BoardingReservationState extends State<BoardingReservation> {
  // Create a reference to Firebase database
  late DatabaseReference dbPetRef;

  TextEditingController _addressController = TextEditingController();
  CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(1.5338304733168895, 103.68183000980095), zoom: 14);
  LatLng _center = LatLng(1.5338304733168895, 103.68183000980095);
  GoogleMapController? _mapController;
  Marker? _marker;

  late bool isDog; // Define if it's dog or cat

  late String serviceName;
  String roomtype = "";
  double price = 0;

  // Pet Selection
  List<String> petNames = [];
  List<Map> petList = [];
  // Date Picker
  TextEditingController dateInput = TextEditingController();
  TextEditingController _serviceTypeController = TextEditingController();
  // Pet Taxi Checkbox
  bool isChecked = false;
  // Room Selection
  String roomSelected = "";
  String selectedName = '';
  String dropdownValue = '';
  String petSize = '';

  bool _isDisposed = false;

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    isDog = widget.dogBoard;
    if (isDog) {
      _serviceTypeController.text = "Dog Boarding";
    } else {
      _serviceTypeController.text = "Cat Boarding";
    }

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
            dropdownValue = "";
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
  Widget build(
    BuildContext context,
  ) {
    if (petNames.isNotEmpty) {
      dropdownValue = petNames.first;
    }
    return Scaffold(
      backgroundColor: Colors.white,
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
            height: MediaQuery.of(context).size.height * 0.8,
            width: double.maxFinite,
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
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          selectedName = newValue;
                        });
                        calculatePrice(selectedName);
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
                      height: 5,
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
                        border:
                            Border.all(color: AppColors.mainColor, width: 1.0),
                      ),
                      alignment: Alignment.centerLeft,
                      // padding: EdgeInsets.only(bottom: ),
                      height: 50,
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        enabled: false,
                        textAlign: TextAlign.left,
                        controller: _serviceTypeController,
                        style: const TextStyle(color: AppColors.mainColor),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    // Choose Date
                    TitleText(text: "Choose Date:"),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: double.maxFinite,
                      height: 316,
                      child: DateRangePickerWidget(
                        maximumPeriodLength: 14,
                        minimumPeriodLength: 1,
                        // disabledDates: [DateTime(2023, 11, 20)],
                        initialDisplayedDate: DateTime(2023, 8, 1),
                        onPeriodChanged: (Period value) {
                          debugPrint(value.toString());
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    // Select Room
                    TitleText(text: "Select Room:"),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15),
                        border:
                            Border.all(color: AppColors.mainColor, width: 1.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleText(text: roomSelected),
                          Container(
                              alignment: Alignment.center,
                              width: 90,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.dogBasicPurple,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius15),
                              ),
                              child: TextButton(
                                  onPressed: () async {
                                    roomtype = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => isDog
                                              ? SelectRoomPage(dogBoard: true)
                                              : SelectRoomPage(
                                                  dogBoard:
                                                      false)), // Replace NewPage with the name of new page class
                                    );
                                    print(roomtype);
                                    setState(() {
                                      roomSelected = roomtype;
                                    });
                                  },
                                  child: TitleText(
                                    text: "View Room",
                                    color: Colors.white,
                                    size: 12,
                                  ))),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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
                            TitleText(
                              text: "Pet Taxi Required",
                              size: 18,
                            ),
                            SmallText(
                              text: "(Exclusive fee will be charged)",
                              size: Dimensions.font10 + 2,
                              color: AppColors.mainColor,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),

                    isChecked
                        ? Column(
                            children: [
                              Container(
                                height: 150,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 2, color: AppColors.mainColor)),
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: _cameraPosition,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _mapController = controller;
                                  },
                                  markers: _marker != null
                                      ? Set<Marker>.from([_marker!])
                                      : {},
                                  onCameraMove: (CameraPosition position) {
                                    updateMarkerPosition(position);
                                  },
                                  onCameraIdle: () async {
                                    await updateAddressFromCameraPosition();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: _addressController,
                                decoration: InputDecoration(
                                  labelText: 'Enter Address',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: AppColors.mainColor, width: 1.0),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: () {
                                      moveCameraToAddress();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),

                    const SizedBox(
                      height: 10,
                    ),

                    // Next Button
                    InkWell(
                      onTap: () {
                        // In case that user havent choose any pet, set default to avoid blank
                        if (selectedName == "") {
                          selectedName = dropdownValue;
                          calculatePrice(dropdownValue);
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderConfirmationPage(
                                      pet: selectedName,
                                      service: serviceName,
                                      date: dateInput.text,
                                      time: '',
                                      room: '',
                                      taxi: isChecked,
                                      price: price,
                                      address: _addressController.text,
                                      package: '',
                                      pointRedeem: false,
                                    )));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 60),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius30),
                          color: AppColors.mainColor,
                        ),
                        height: 40,
                        width: 180,
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
        ],
      ),
    );
  }

  void moveCameraToAddress() async {
    // Get the address entered by the user
    String address = _addressController.text;

    // Use the geocoding package to retrieve the LatLng coordinates of the address
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      Location location = locations.first;
      LatLng latLng = LatLng(location.latitude!, location.longitude!);

      // Move the camera to the specified address
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
    } else {
      // Address not found, show an error message or handle it as needed
      print('Address not found: $address');
    }
  }

  void updateMarkerPosition(CameraPosition position) {
    setState(() {
      _marker = Marker(
        markerId: MarkerId("current_position"),
        position: LatLng(position.target.latitude, position.target.longitude),
      );
    });
  }

  Future<void> updateAddressFromCameraPosition() async {
    if (_mapController == null) return;

    LatLng coordinates = await _mapController!.getLatLng(
      ScreenCoordinate(
        x: MediaQuery.of(context).size.width ~/ 2,
        y: MediaQuery.of(context).size.height ~/ 2,
      ),
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude, coordinates.longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;

      String address = '';

      if (placemark.name != null) address += placemark.name! + ', ';
      if (placemark.thoroughfare != null)
        address += placemark.thoroughfare! + ', ';
      if (placemark.subLocality != null) {
        address += placemark.subLocality! + ', ';
      }
      if (placemark.locality != null) {
        address += placemark.locality! + ', ';
      }
      if (placemark.postalCode != null) {
        address += placemark.postalCode! + ', ';
      }
      if (placemark.country != null) {
        address += placemark.country!;
      }

      setState(() {
        _addressController.text = address;
      });
    }
  }

  void calculatePrice(String newValue) {
    price = 0;
    dbPetRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        // Check if the widget is still mounted and data is not null
        Map<dynamic, dynamic> petData = snapshot.value as Map<dynamic, dynamic>;
        // Iterate through the pet data to get pet names
        petData.forEach((key, value) {
          if (value['data']['name'] == newValue) {
            petSize = value['data']['size'];

            if (petSize == "Small" || petSize == "Medium") {
              if (roomSelected == "D1" || roomSelected == "C1") {
                price += 50;
              } else if (roomSelected == "D2" || roomSelected == "C2") {
                price += 60;
              } else if (roomSelected == "D3" || roomSelected == "C3") {
                price += 70;
              } else {
                print("Unknown error in price getting.");
              }
            } else if (petSize == "Large" || petSize == "Giant") {
              if (roomSelected == "D1" || roomSelected == "C1") {
                price += 60;
              } else if (roomSelected == "D2" || roomSelected == "C2") {
                price += 70;
              } else if (roomSelected == "D3" || roomSelected == "C3") {
                price += 80;
              } else {
                print("Unknown error in price getting.");
              }
            }

            print('Pet size: $petSize'); // Checking purpose
          }
        });
      }
    });
  }
}
