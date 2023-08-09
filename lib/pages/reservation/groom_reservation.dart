import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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
  bool freeService;
  GroomReservationPage(
      {super.key,
      required this.dogGroom,
      required this.fullGroom,
      required this.freeService});

  @override
  State<GroomReservationPage> createState() => _GroomReservationPageState();
}

class _GroomReservationPageState extends State<GroomReservationPage> {
  // Create a reference to Firebase database
  late DatabaseReference dbPetRef;

  final TextEditingController _addressController = TextEditingController();
  final CameraPosition _cameraPosition = const CameraPosition(
      target: LatLng(1.5338304733168895, 103.68183000980095), zoom: 14);
  final LatLng _center = const LatLng(1.5338304733168895, 103.68183000980095);
  GoogleMapController? _mapController;
  Marker? _marker;

  late bool isDog; // Define if it's dog or cat
  late bool isFull; // Define if it is Full Grooming

  late String serviceName;
  late double price = 0;
  double priceCalculated = 0;
  String selectedName = "";
  String dropdownValue1 = '';
  String dropdownValue2 = '';

  // Pet Selection
  List<String> petNames = [];
  List<Map> petList = [];
  String petSize = '';
  // Time Selection
  List<String> timeList = <String>['10:00AM', '12:00PM', '2:00PM', '4:00PM'];
  // Date Picker
  TextEditingController dateInput = TextEditingController();
  // Pet Taxi Checkbox
  bool isChecked = false;
  late bool isFree = false;
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
    isFree = widget.freeService;

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
    if (petNames.isNotEmpty) {
      dropdownValue1 = petNames.first;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
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
                    value: dropdownValue1,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue1 = newValue!;
                        selectedName = newValue;
                      });
                      calculatePrice(selectedName);
                    },
                    items:
                        petNames.map<DropdownMenuItem<String>>((String value) {
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
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      border:
                          Border.all(color: AppColors.mainColor, width: 1.0),
                    ),
                    alignment: Alignment.centerLeft,
                    height: 50,
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      enabled: false,
                      textAlign: TextAlign.left,
                      controller: TextEditingController(
                        text: serviceName,
                      ),
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
                    padding: const EdgeInsets.only(left: 10),
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      border:
                          Border.all(color: AppColors.mainColor, width: 1.0),
                    ),
                    child: TextField(
                      controller: dateInput,
                      // editing controller of this TextField
                      decoration: const InputDecoration(
                          iconColor: AppColors.mainColor,
                          icon: Icon(Icons.calendar_today), //icon of text field
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
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            dateInput.text =
                                formattedDate; //set output date to TextField value.

                            calculatePrice(dropdownValue1);
                          });
                        } else {}
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
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
                    items:
                        timeList.map<DropdownMenuItem<String>>((String value) {
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
                    height: 3,
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
                      ),
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
                                onMapCreated: (GoogleMapController controller) {
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
                        selectedName = dropdownValue1;
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderConfirmationPage(
                                    pet: selectedName,
                                    service: serviceName,
                                    date: dateInput.text,
                                    time: dropdownValue2,
                                    room: '',
                                    taxi: isChecked,
                                    price: priceCalculated,
                                    address: _addressController.text,
                                    package: '',
                                    pointRedeem: isFree,
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
      ]),
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

            if (serviceName == "Cat Basic Grooming" ||
                serviceName == "Dog Basic Grooming") {
              if (petSize == "Small") {
                price += 60;
              } else if (petSize == "Medium") {
                price += 65;
              } else if (petSize == "Large") {
                price += 70;
              } else if (petSize == "Giant") {
                price += 80;
              } else {
                print("Unknown error in price getting.");
              }
              print('Total price: $price'); // Checking purpose
              setState(() {
                priceCalculated = price;
              });
            } else if (serviceName == "Cat Full Grooming" ||
                serviceName == "Dog Full Grooming") {
              if (petSize == "Small") {
                price += 80;
              } else if (petSize == "Medium") {
                price += 85;
              } else if (petSize == "Large") {
                price += 90;
              } else if (petSize == "Giant") {
                price += 100;
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
