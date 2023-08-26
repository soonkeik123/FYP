import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ohmypet/pages/admin/reservation_action%20copy.dart';
import 'package:ohmypet/pages/admin/reservation_manage.dart';
import 'package:ohmypet/pages/admin/staff_manage.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/admin_header.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskAccept extends StatefulWidget {
  final String reservationID;
  final String role;
  const TaskAccept(
      {super.key, required this.reservationID, required this.role});

  @override
  State<TaskAccept> createState() => _TaskAcceptState();
}

class _TaskAcceptState extends State<TaskAccept> {
  // Create a reference to Firebase database
  late DatabaseReference reservRef;
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

  // Map
  CameraPosition? _cameraPosition;
  Completer<GoogleMapController> _googleMapController = Completer();
  StreamSubscription<Position>? positionStream; // For realtime updating
  LatLng? destinationLatLng;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.medium,
    distanceFilter: 100,
  );
  Timer? positionTimer;

  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) currentUID = user.uid;

    _init();
    super.initState();

    final rid = widget.reservationID;
    reservRef = FirebaseDatabase.instance.ref('reservations/$rid');
    fetchReservationData();
  }

  @override
  void dispose() {
    positionStream!.cancel();
    positionTimer!.cancel();
    _googleMapController = Completer();
    super.dispose();
  }

  _init() async {
    _cameraPosition = const CameraPosition(
        target: LatLng(1.5338304733168895, 103.68183000980095), zoom: 15);
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
      _loadDestinationCoordinates();
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

  Future<void> _loadDestinationCoordinates() async {
    try {
      if (stage == 2) {
        destinationLatLng =
            const LatLng(1.5338304733168895, 103.68183000980095);
        setState(() {});
      } else {
        destinationLatLng = await getLatLngFromAddress(address);
        setState(() {});
      }
    } catch (e) {
      print('Error loading destination coordinates: $e');
    }
  }

  Future<LatLng> getLatLngFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);

    if (locations.isNotEmpty) {
      double latitude = locations[0].latitude;
      double longitude = locations[0].longitude;
      return LatLng(latitude, longitude);
    } else {
      throw Exception('No location found for the given address.');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Location services are not enabled don't continue
    //   // accessing the position and request users of the
    //   // App to enable the location services.
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  searchCurrentLocation() async {
    Position position = await _determinePosition();
    print(position);
    moveToPosition(LatLng(position.latitude, position.longitude));
  }

  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: 15),
    ));
    mapController.dispose();
  }

  Widget _getMarker() {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                spreadRadius: 4,
                blurRadius: 6)
          ]),
      child: ClipOval(child: Image.asset("assets/images/app-icon.png")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        // Header
        const AdminHeader(pageTitle: "Track Progress"),

        // ------body content-----

        // Processing
        if (stage == 1 || stage == 2)
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  Container(
                    height: 410,
                    color: Colors.lightBlueAccent,
                    child: Stack(
                      children: [
                        GoogleMap(
                            initialCameraPosition: _cameraPosition!,
                            mapType: MapType.normal,
                            markers: destinationLatLng != null
                                ? {
                                    Marker(
                                      markerId: const MarkerId('Destination'),
                                      position: destinationLatLng!,
                                    ),
                                  }
                                : {},
                            scrollGesturesEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              // now we need a variable to get the controiller of google map
                              if (!_googleMapController.isCompleted) {
                                _googleMapController.complete(controller);

                                // the map will move to currnt location
                                // Set up a timer to update the position every 3 seconds
                                if (stage == 1 || stage == 2) {
                                  positionTimer =
                                      Timer.periodic(const Duration(seconds: 3),
                                          (timer) async {
                                    if (stage != 1 && stage != 2) {
                                      positionTimer
                                          ?.cancel(); // Cancel the timer
                                      controller.dispose();
                                    }
                                    Position position =
                                        await _determinePosition();
                                    moveToPosition(LatLng(
                                        position.latitude, position.longitude));
                                    // Update the latitude and longitude fields in the database
                                    await reservRef.update({
                                      'latitude': position.latitude,
                                      'longitude': position.longitude,
                                    });
                                  });
                                }
                              }
                            }),
                        Positioned.fill(
                            child: Align(
                                alignment: Alignment.center,
                                child: _getMarker())),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 270,
                      padding:
                          const EdgeInsets.only(top: 2, left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Text("#$reservationId",
                              style: const TextStyle(
                                  color: AppColors.mainColor, fontSize: 18)),
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
                              style: const TextStyle(
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
                                    });
                                    await reservRef.update({
                                      'stage': stage,
                                      'task_accepted': false
                                    }).then((value) {
                                      redirectPage();
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
                                  onTap: () async {
                                    _checkStageAndRequirementForPickUp();
                                  },
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.mainColor.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      stage == 1
                                          ? "Picked Up"
                                          : "Complete Task",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
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
          ),

        if (stage == 4)
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.4,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                // color: Colors.amber,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("#$reservationId",
                        style: const TextStyle(
                            color: AppColors.mainColor, fontSize: 22)),
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
                            image: AssetImage("assets/images/bath.png")),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            stage = 3;
                          });
                          await reservRef.update({
                            'stage': stage,
                            'task_accepted': false
                          }).then((value) {
                            redirectPage();
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
                          if (package.isNotEmpty) {
                            _showTaskOptions(context);
                          } else {
                            _checkStageAndRequirementForGrooming();
                          }
                        },
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            package.isEmpty ? "Complete Task" : "Actions",
                            style: const TextStyle(
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
          ),

        if (stage == 6)
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.4,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                // color: Colors.amber,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("#$reservationId",
                        style: const TextStyle(
                            color: AppColors.mainColor, fontSize: 22)),
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
                            image: AssetImage("assets/images/hotel.png")),
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            stage = 3;
                          });
                          await reservRef.update({
                            'stage': stage,
                            'task_accepted': false
                          }).then((value) {
                            redirectPage();
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
                          if (package.isNotEmpty) {
                            _showTaskOptions(context);
                          } else {
                            _checkStageAndRequirementForGrooming();
                          }
                        },
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            package.isEmpty ? "Complete Task" : "Actions",
                            style: const TextStyle(
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
          ),

        if (stage == 7)
          Expanded(
            child: Container(
              child: Stack(
                children: [
                  Container(
                    height: 410,
                    color: Colors.lightBlueAccent,
                    child: Stack(
                      children: [
                        GoogleMap(
                            initialCameraPosition: const CameraPosition(
                                target: LatLng(
                                    1.5338304733168895, 103.68183000980095),
                                zoom: 15),
                            mapType: MapType.normal,
                            markers: destinationLatLng != null
                                ? {
                                    Marker(
                                      markerId:
                                          const MarkerId('destinationMarker'),
                                      position: destinationLatLng!,
                                    ),
                                  }
                                : {},
                            scrollGesturesEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              // now we need a variable to get the controiller of google map
                              if (!_googleMapController.isCompleted) {
                                _googleMapController.complete(controller);
                                // the map will move to currnt location
                                // Set up a timer to update the position every 3 seconds
                                if (stage == 7) {
                                  searchCurrentLocation();
                                  positionTimer =
                                      Timer.periodic(const Duration(seconds: 3),
                                          (timer) async {
                                    if (stage != 7) {
                                      positionTimer?.cancel();
                                      controller.dispose();
                                    }
                                    Position position =
                                        await _determinePosition();
                                    moveToPosition(LatLng(
                                        position.latitude, position.longitude));
                                    // Update the latitude and longitude fields in the database
                                    await reservRef.update({
                                      'latitude': position.latitude,
                                      'longitude': position.longitude,
                                    });
                                  });
                                }
                              }
                            }),
                        Positioned.fill(
                            child: Align(
                                alignment: Alignment.center,
                                child: _getMarker())),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 270,
                      padding:
                          const EdgeInsets.only(top: 2, left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 15,
                                fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            address,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
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
                                    });
                                    await reservRef.update({
                                      'stage': stage,
                                      'task_accepted': false
                                    }).then((value) {
                                      redirectPage();
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
                                    _checkStageAndRequirementForDeliver();
                                  },
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.mainColor.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Text(
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ]),
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

  Future<void> _checkStageAndRequirementForPickUp() async {
    if (stage == 1) {
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
      positionTimer!.cancel();

      await reservRef.update({
        'stage': stage,
        'task_accepted': false,
      }).then((value) {
        redirectPage();
      });
    }
  }

  Future<void> _checkStageAndRequirementForGrooming() async {
    if (stage == 4) {
      if (taxiRequired) {
        //Change the stage to 5
        setState(() {
          stage = 5;
        });
        await reservRef.update({
          'stage': stage,
          'task_accepted': false,
        }).then((value) {
          redirectPage();
        });
      } else {
        //Change the stage to 8
        //Change the stage to Complete
        setState(() {
          stage = 8;
        });
        await reservRef.update({
          'stage': stage,
          'status': 'Completed',
          'task_accepted': false
        }).then((value) {
          print("Stage changed to $stage, task completed");
          Navigator.pop(context);
        });
      }
    } else {
      showMessageDialog(context, "Unexpected Error", "Try again later.");
      Navigator.pop(context);
    }
  }

  Future<void> _checkStageAndRequirementForBoarding() async {
    if (stage == 6) {
      if (taxiRequired) {
        //Change the stage to 5
        setState(() {
          stage = 5;
        });
        await reservRef.update({
          'stage': stage,
          'task_accepted': false,
        }).then((value) {
          redirectPage();
        });
      } else {
        setState(() {
          stage = 8;
        });
        await reservRef.update({
          'stage': stage,
          'status': 'Completed',
          'task_accepted': false
        }).then((value) {
          print("Stage changed to $stage, task completed");
          Navigator.pop(context);
        });
      }
    } else {
      showMessageDialog(context, "Unexpected Error", "Try again later.");
      Navigator.pop(context);
    }
  }

  Future<void> _checkStageAndRequirementForDeliver() async {
    //Change stage to 8
    //Change status to 'complete'
    setState(() {
      stage = 8;
    });
    await reservRef.update({
      'stage': stage,
      'status': 'Completed',
      'task_accepted': false
    }).then((value) {
      positionTimer!.cancel();
      print("Stage changed to $stage, second_driver updated");
      showMessageDialog(context, "Completed", "Service Completed.");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReservationManagement(role: widget.role)));
    });
  }

  void redirectPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ReservationActionPage(
                reservationID: widget.reservationID, role: widget.role)));
  }

  void _showTaskOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return stage == 4
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.hotel_outlined),
                    title: const Text('Boarding'),
                    onTap: () async {
                      setState(() {
                        stage = 6;
                      });
                      final snapshot = await reservRef.child('carer').get();
                      if (snapshot.exists) {
                        await reservRef.update({
                          'stage': stage,
                        }).then((value) => print("Stage changed to $stage"));
                      } else {
                        await reservRef.update({
                          'stage': stage,
                          'carer': currentUID,
                        }).then((value) => print("Stage changed to $stage"));
                      }

                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.check_box_outlined),
                    title: const Text('Complete Task'),
                    onTap: () async {
                      final snapshot = await reservRef.child('groomer').get();
                      if (snapshot.exists) {
                        showConfirmationDialog().then((value) => {
                              if (value != null && value)
                                {
                                  _checkStageAndRequirementForBoarding(),
                                }
                              else
                                {
                                  Navigator.pop(context),
                                }
                            });
                      } else {
                        showMessageDialog(context, "Invalid Action",
                            "The pet grooming task has not complete yet.");
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shower_outlined),
                    title: const Text('Grooming'),
                    onTap: () async {
                      final snapshot = await reservRef.child('groomer').get();
                      if (snapshot.exists) {
                        showMessageDialog(context, "Invalid Action",
                            "The pet grooming task was completed.");
                      } else {
                        showConfirmationDialog().then((value) async => {
                              if (value != null && value)
                                {
                                  setState(() {
                                    stage = 4;
                                  }),
                                  await reservRef.update({
                                    'stage': stage,
                                    'groomer': currentUID,
                                  }).then((value) =>
                                      print("Stage changed to $stage")),
                                  Navigator.pop(context),
                                }
                              else
                                {
                                  Navigator.pop(context),
                                }
                            });
                      }
                    },
                  ),
                ],
              );
      },
    );
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
            child: Text('Do you confirm to this action?'),
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
}
