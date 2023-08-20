import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ohmypet/pages/admin/staff_manage.dart';
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

  final TextEditingController _addressController = TextEditingController();
  final CameraPosition _cameraPosition = const CameraPosition(
      target: LatLng(1.5338304733168895, 103.68183000980095), zoom: 14);
  final LatLng _center = const LatLng(1.5338304733168895, 103.68183000980095);
  GoogleMapController? _mapController;
  Marker? _marker;

  late bool isDog; // Define if it's dog or cat

  String roomtype = "";
  late double price = 0;
  double priceCalculated = 0;
  // Pet Selection
  List<String> petNames = [];
  List<Map> petList = [];
  // Date Picker
  TextEditingController dateInput = TextEditingController();
  final TextEditingController _serviceTypeController = TextEditingController();
  // Pet Taxi Checkbox
  bool isChecked = false;
  // Room Selection
  String roomSelected = "";
  String selectedName = '';
  String dropdownValue = '';
  String petSize = '';
  // Calender pick range date
  String startDate = '';
  String endDate = '';
  // Amount of date (used to calculate price)
  int numberOfDays = 1;

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

            petList.add(value);
            if (isDog) {
              if (value['type'] == 'Dog') {
                setState(() {
                  petNames.add(value['name']);
                });
              }
            } else {
              if (value['type'] == 'Cat') {
                setState(() {
                  petNames.add(value['name']);
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
                      height: 48,
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
                          Text(
                            dateInput.text,
                            style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 45,
                            height: 45,
                            decoration: const BoxDecoration(
                              color: AppColors.dogBasicPurple,
                              shape: BoxShape.circle,
                            ),
                            child: TextButton(
                              onPressed: () {
                                showCustomDateRangePicker(
                                  context,
                                  dismissible: true,
                                  minimumDate: DateTime.now()
                                      .add(const Duration(days: 1)),
                                  maximumDate: DateTime.now()
                                      .add(const Duration(days: 30)),
                                  // startDate: DateTime.now()
                                  //     .add(const Duration(days: 1)),
                                  onApplyClick: (start, end) {
                                    setState(() {
                                      endDate = (end).toString().split(' ')[0];
                                      startDate =
                                          (start).toString().split(' ')[0];
                                      dateInput.text = "$startDate to $endDate";
                                      numberOfDays =
                                          (end).difference(start).inDays;
                                      print(
                                          "Number of days between start and end: $numberOfDays");
                                    });
                                    calculatePrice(selectedName);
                                  },
                                  onCancelClick: () {
                                    setState(() {
                                      endDate = '';
                                      startDate = '';
                                    });
                                  },
                                );
                              },
                              child: const Icon(Icons.calendar_today_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
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
                                    if (petSize == '') {
                                      calculatePrice(dropdownValue);
                                    }
                                    roomtype = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => isDog
                                              ? SelectRoomPage(
                                                  dogBoard: true,
                                                  petSize: petSize)
                                              : SelectRoomPage(
                                                  dogBoard: false,
                                                  petSize: petSize,
                                                )), // Replace NewPage with the name of new page class
                                    );
                                    print(roomtype);
                                    setState(() {
                                      roomSelected = roomtype;
                                    });
                                    calculatePrice(selectedName);
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
                              calculatePrice(selectedName);
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
                                  markers:
                                      _marker != null ? <Marker>{_marker!} : {},
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
                                    borderSide: const BorderSide(
                                        color: AppColors.mainColor, width: 1.0),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search),
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
                        if (dateInput.text.isEmpty ||
                            selectedName == "" ||
                            roomSelected.isEmpty) {
                          showMessageDialog(context, "Empty Field Found",
                              "Please fill up the form before proceed to next reservation confirm stage.");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderConfirmationPage(
                                        pet: selectedName,
                                        service: _serviceTypeController.text,
                                        date: dateInput.text,
                                        time: '',
                                        room: roomSelected,
                                        taxi: isChecked,
                                        price: priceCalculated,
                                        address: _addressController.text,
                                        package: '',
                                        pointRedeem: false,
                                      )));
                        }
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
      LatLng latLng = LatLng(location.latitude, location.longitude);

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
        markerId: const MarkerId("current_position"),
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

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;

      String address = '';

      if (placemark.name != null) address += '${placemark.name!}, ';
      if (placemark.thoroughfare != null) {
        address += '${placemark.thoroughfare!}, ';
      }
      if (placemark.subLocality != null) {
        address += '${placemark.subLocality!}, ';
      }
      if (placemark.locality != null) {
        address += '${placemark.locality!}, ';
      }
      if (placemark.postalCode != null) {
        address += '${placemark.postalCode!}, ';
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
    double price = 0;
    if (isChecked) {
      price = 20;
    } else {
      price = 0;
    }
    dbPetRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        // Check if the widget is still mounted and data is not null
        Map<dynamic, dynamic> petData = snapshot.value as Map<dynamic, dynamic>;
        // Iterate through the pet data to get pet names
        petData.forEach((key, value) {
          if (value['name'] == newValue) {
            petSize = value['size'];

            if (petSize == "Small" || petSize == "Medium") {
              if (roomSelected == "D1" || roomSelected == "C1") {
                price += (50 * numberOfDays);
              } else if (roomSelected == "D2" || roomSelected == "C2") {
                price += (60 * numberOfDays);
              } else if (roomSelected == "D3" || roomSelected == "C3") {
                price += (70 * numberOfDays);
              } else {
                print("Unknown error in price getting.");
              }
              print('Total price: $price'); // Checking purpose
              setState(() {
                priceCalculated = price;
              });
            } else if (petSize == "Large" || petSize == "Giant") {
              if (roomSelected == "D1" || roomSelected == "C1") {
                price += (60 * numberOfDays);
              } else if (roomSelected == "D2" || roomSelected == "C2") {
                price += (70 * numberOfDays);
              } else if (roomSelected == "D3" || roomSelected == "C3") {
                price += (80 * numberOfDays);
              } else {
                print("Unknown error in price getting.");
              }
              print('Total price: $price'); // Checking purpose
              setState(() {
                priceCalculated = price;
              });
            }
          }
        });
      }
    });
  }
}
