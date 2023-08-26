import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/info_text.dart';
import '../../widgets/title_text.dart';

class TrackProgressPage extends StatefulWidget {
  static const routeName = '/trackProgress';

  String reservationID;

  TrackProgressPage({super.key, required this.reservationID});

  @override
  State<TrackProgressPage> createState() => _TrackProgressPageState();
}

class _TrackProgressPageState extends State<TrackProgressPage>
    with TickerProviderStateMixin {
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
  String status = '';
  late bool pointRedeem;

  String currentID = '';
  int stage = 0;
  double boundary = 12.5;

  late AnimationController controller;
  bool determinate = false;
  bool isFullGroom = false;
  bool changePic = true;

  CameraPosition? _cameraPosition;
  final Completer<GoogleMapController> _googleMapController = Completer();
  LatLng? destinationLatLng;

  @override
  void initState() {
    _init();
    controller = AnimationController(
      vsync: this,
      upperBound: 1.0,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    // controller.value = 0.0;
    controller.repeat();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUID = user.uid;
    }
    final rid = widget.reservationID;
    reservRef = FirebaseDatabase.instance.ref('reservations/$rid');
    fetchReservationData().then((value) => fetchPetData());

    currentID =
        (widget.reservationID).substring(widget.reservationID.length - 5);
    super.initState();
  }

  _init() {
    _cameraPosition = const CameraPosition(
        target: LatLng(1.5338304733168895, 103.68183000980095), zoom: 15);
  }

  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: latLng, zoom: 15),
    ));
  }

  Future<void> _loadDestinationCoordinates() async {
    try {
      destinationLatLng = await getLatLngFromAddress(address);
    } catch (e) {
      print('Error loading destination coordinates: $e');
    }
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
      _loadDestinationCoordinates(); //set address LatLng
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

  void updateProgress() {
    // Set the value of the controller to the desired percentage
    boundary = boundary + 12.5;

    // Create a new AnimationController with the updated upper bound
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      upperBound: boundary,

      // Set the value of the new controller to the desired percentage
    );
    // controller.value = boundary / 100.0;
    print(boundary);
  }

  @override
  void dispose() {
    controller.dispose();
    reservRef.onDisconnect();
    super.dispose();
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

  StreamSubscription<DatabaseEvent>?
      positionListener; // Declare the listener reference

  @override
  Widget build(BuildContext context) {
    fetchReservationData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          const CustomHeader(pageTitle: "Track Progress"),

          // ------body content-----
          // Incoming
          stage == 0
              ? Column(
                  children: [
                    LinearProgressIndicator(
                      value: controller.value,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.3,
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      // color: Colors.amber,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("#$currentID",
                              style: const TextStyle(
                                  color: AppColors.mainColor, fontSize: 22)),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("Booking Process:",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(_identifyStage(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Your service is scheduled for a future date or time. Please be patient until the reserved Date and Time. We will notify you once the service has started.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => removeConfirmationDialog(
                              context,
                            ),
                            child: Container(
                              height: 40,
                              width: 130,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.catBasicRed,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              String phoneNumber = "+60102211208";

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
                            child: Container(
                              height: 40,
                              width: 130,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.mainColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "Send Message",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              : Container(),

          // Processing
          stage == 1 || stage == 2
              ? Expanded(
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
                                            markerId: const MarkerId(
                                                'destinationMarker'),
                                            position: destinationLatLng!,
                                          ),
                                        }
                                      : {},
                                  scrollGesturesEnabled: false,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    // now we need a variable to get the controiller of google map
                                    if (!_googleMapController.isCompleted) {
                                      _googleMapController.complete(controller);

                                      if (stage == 1 || stage == 2) {
                                        positionListener =
                                            reservRef.onValue.listen((event) {
                                          if (event.snapshot.value != null) {
                                            Map reservationData =
                                                event.snapshot.value as Map;
                                            double currentLatitude =
                                                reservationData['latitude'];
                                            double currentLongitude =
                                                reservationData['longitude'];

                                            moveToPosition(LatLng(
                                                currentLatitude,
                                                currentLongitude));
                                          }
                                        });
                                      } else {
                                        reservRef.onDisconnect();
                                        positionListener?.cancel();
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
                            padding: const EdgeInsets.only(
                                top: 2, left: 20, right: 20),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                LinearProgressIndicator(
                                  value: controller.value,
                                  semanticsLabel: 'Linear progress indicator',
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text("#$currentID",
                                    style: const TextStyle(
                                        color: AppColors.mainColor,
                                        fontSize: 18)),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text("Current Stage:",
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
                                  stage == 1
                                      ? "Your pet taxi driver will be arriving to pick up your pet, please ensure that your pet is ready and prepared."
                                      : "Your pet has been picked up by our driver and is on the way to enjoy our pet services. You can follow us to get real-time progress updates!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                InkWell(
                                  onTap: () async {
                                    SendMessage();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 200,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.mainColor.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Text(
                                      "Send Message To Us",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),

          stage == 3
              ? Column(
                  children: [
                    LinearProgressIndicator(
                      value: controller.value,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.3,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      // color: Colors.amber,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Icon(
                            Icons.check_circle,
                            size: 150,
                            color: Colors.green.shade400,
                          ),
                          Text("Arrived",
                              style: TextStyle(
                                  color: Colors.green.shade400,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 60,
                          ),
                          Text("Current Stage: ${_identifyStage()}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Your pet has been transferred to the waiting zone with a drink supplied. The pet service will begin soon. We promise to ensure your pet's comfort and safety.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => SendMessage(),
                      child: Container(
                        height: 40,
                        width: 170,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Send Message",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                )
              : Container(),

          stage == 4
              ? Column(
                  children: [
                    LinearProgressIndicator(
                      value: controller.value,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.3,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      // color: Colors.amber,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("#$currentID",
                              style: const TextStyle(
                                  color: AppColors.mainColor, fontSize: 22)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Current Stage: ${_identifyStage()}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onLongPress: () {
                              setState(() {
                                changePic = !changePic;
                              });
                            },
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: changePic
                                        ? const AssetImage(
                                            "assets/images/bath.png")
                                        : const AssetImage(
                                            "assets/images/blow.png")),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Text(
                            isFullGroom
                                ? "Your pet is now experiencing comprehensive grooming provided by our professional pet carers. The hair cut will be performed once they finish the bath and blow-drying process."
                                : "Your pet is now experiencing comprehensive grooming provided by our professional pet carers. We will notify you as soon as the grooming process is completed.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => SendMessage(),
                      child: Container(
                        height: 40,
                        width: 170,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Send Message",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                )
              : Container(),

          stage == 5
              ? Column(
                  children: [
                    LinearProgressIndicator(
                      value: controller.value,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.3,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      // color: Colors.amber,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("#$currentID",
                              style: const TextStyle(
                                  color: AppColors.mainColor, fontSize: 22)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Current Stage: ${_identifyStage()}",
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
                                      "assets/images/vaccinating.png")),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Text(
                            "Your fur-baby has enjoyed their previous services! Before the next step, we will let'em take a rest and will make sure they're on safety spot!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => SendMessage,
                      child: Container(
                        height: 40,
                        width: 170,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Send Message",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                )
              : Container(),

          stage == 6
              ? Column(
                  children: [
                    LinearProgressIndicator(
                      value: controller.value,
                      semanticsLabel: 'Linear progress indicator',
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.3,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      // color: Colors.amber,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("#$currentID",
                              style: const TextStyle(
                                  color: AppColors.mainColor, fontSize: 22)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Current Stage: ${_identifyStage()}",
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
                            "Your pet has now checked in to their cozy room, ready to enjoy their own personal space and 24-hour pampering! Don't worry, we'll make sure they never go hungry! Taking care of them is our top priority, and we'll shower them with love and attention! 😊🐾",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => SendMessage(),
                      child: Container(
                        height: 40,
                        width: 170,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Send Message",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 15),
                        ),
                      ),
                    )
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
                          child: Stack(
                            children: [
                              GoogleMap(
                                  initialCameraPosition: _cameraPosition!,
                                  mapType: MapType.normal,
                                  scrollGesturesEnabled: false,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    // now we need a variable to get the controiller of google map
                                    if (!_googleMapController.isCompleted) {
                                      _googleMapController.complete(controller);
                                      if (stage == 7) {
                                        positionListener =
                                            reservRef.onValue.listen((event) {
                                          if (event.snapshot.value != null) {
                                            Map reservationData =
                                                event.snapshot.value as Map;
                                            double currentLatitude =
                                                reservationData['latitude'];
                                            double currentLongitude =
                                                reservationData['longitude'];

                                            moveToPosition(LatLng(
                                                currentLatitude,
                                                currentLongitude));
                                          }
                                        });
                                      } else {
                                        positionListener?.cancel();
                                        reservRef.onDisconnect();
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
                            padding: const EdgeInsets.only(
                                top: 2, left: 20, right: 20),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                LinearProgressIndicator(
                                  value: controller.value,
                                  semanticsLabel: 'Linear progress indicator',
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text("Current Stage:",
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
                                  "Our talented drivers are now whisking your furry friend back into the warmth of your loving arms! We're sure they've had a 'pawsome' time with us and can't wait to see them again! 🐾😊",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                InkWell(
                                  onTap: () => SendMessage(),
                                  child: Container(
                                    height: 40,
                                    width: 200,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.mainColor.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Text(
                                      "Send Message To Us",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),

          stage == 8
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
                          Text("- Service ${_identifyStage()} -",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400)),
                          const SizedBox(
                            height: 15,
                          ),
                          // Points Showing
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            width: double.maxFinite,
                            height: 200,
                            decoration: const BoxDecoration(
                              color: AppColors.themeColor,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  InfoText(
                                    text: "You've accumulated",
                                    size: 20,
                                    normal: false,
                                    color: AppColors.mainColor,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  InfoText(
                                      text: "${price.toInt()} pt",
                                      size: 40,
                                      normal: false,
                                      color: AppColors.mainColor),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  InfoText(
                                      text: "Thanks for choosing our service!",
                                      size: 20,
                                      normal: false,
                                      color: AppColors.mainColor),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Text(
                            "We hope your adorable pet had a paw-some time with us and enjoyed every moment of their grooming session. Your pet's health and happiness are our top priorities, and we thank you for entrusting their care to us. Looking forward to seeing your furry friend again soon! 🐾😊",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),

                          Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/thankyou.png")),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          Navigator.popAndPushNamed(context, '/loyaltyPoint'),
                      child: Container(
                        height: 45,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "View Loyalty Points",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      ),
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  void removeConfirmationDialog(BuildContext context) {
    print(widget.reservationID);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          title: const Text('Remove Confirmation'),
          titleTextStyle: const TextStyle(
            color: Colors.red,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          content: const SizedBox(
            height: 50,
            child: Text('Do you want to cancel this reservation?'),
          ),
          contentTextStyle: const TextStyle(
            color: AppColors.catBasicRed,
            fontSize: 17.0,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, false); // Return false to indicate cancellation
              },
              child: const Text(
                'Back',
                style: TextStyle(color: AppColors.paraColor, fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, true); // Return true to indicate confirmation
              },
              child: const Text('Cancel',
                  style: TextStyle(
                      color: AppColors.catBasicRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
          ],
        );
      },
    ).then((value) async {
      if (value != null && value) {
        final ref = FirebaseDatabase.instance.ref('reservations');

        //  Map<String, dynamic> profileData = {
        //                       'status': 'Canceled',
        //                     };
        await ref.update({
          "${widget.reservationID}/status": 'Canceled',
        }).then((value) {
          Navigator.pop(context);
        });
      } else {}
    });
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

  Future<void> SendMessage() async {
    String phoneNumber = "+60102211208";

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
  }
}

class ReservationDetail extends StatefulWidget {
  final String reservationID;
  const ReservationDetail({super.key, required this.reservationID});

  @override
  State<ReservationDetail> createState() => _ReservationDetailState();
}

class _ReservationDetailState extends State<ReservationDetail> {
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
  String status = '';
  late bool pointRedeem;

  String currentID = '';
  int stage = 0;
  double boundary = 12.5;

  late AnimationController controller;
  bool determinate = false;
  bool isFullGroom = false;
  bool changePic = true;

  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUID = user.uid;
    }
    final rid = widget.reservationID;
    reservRef = FirebaseDatabase.instance.ref('reservations/$rid');
    fetchReservationData().then((value) => fetchPetData());

    currentID =
        (widget.reservationID).substring(widget.reservationID.length - 5);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          const CustomHeader(pageTitle: 'Reservation Detail'),

          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors.mainColor),
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
              ])))
        ],
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
}
