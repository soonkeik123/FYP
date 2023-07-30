import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/header.dart';

import '../../widgets/info_text.dart';

class TrackProgressPage extends StatefulWidget {
  static const routeName = '/trackProgress';

  int reservationID;

  TrackProgressPage({super.key, required this.reservationID});

  @override
  State<TrackProgressPage> createState() => _TrackProgressPageState();
}

class _TrackProgressPageState extends State<TrackProgressPage>
    with TickerProviderStateMixin {
  int currentID = 0;
  int stage = 0;
  double boundary = 12.5;
  int loyaltyPoint = 146;

  late AnimationController controller;
  bool determinate = false;
  bool isFullGroom = false;
  bool changePic = true;

  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();

  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      upperBound: 1.0,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    controller.value = 0.0;
    // controller.repeat();

    currentID = widget.reservationID;
    super.initState();
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
    controller.value = boundary / 100.0;
    print(boundary);
  }

  @override
  void dispose() {
    controller.dispose();
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
      return "Vaccinating";
    } else if (stage == 6) {
      return "Boarding";
    } else if (stage == 7) {
      return "Deliver Home";
    } else if (stage == 8) {
      return "Completed";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
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
                          const Text("Current Stage:",
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
                          Container(
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
                          Container(
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
                                Container(
                                  height: 40,
                                  width: 200,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Text(
                                    "Send Message To Us",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
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
                    Container(
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
                                        ? const AssetImage("assets/images/bath.png")
                                        : const AssetImage("assets/images/blow.png")),
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
                    Container(
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
                            "Your fur-baby is getting their special vaccine treatment right meow! Don't worry, we've got it all under control and will make sure they're as happy and healthy as ever! ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    Container(
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
                    Container(
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
                                Container(
                                  height: 40,
                                  width: 200,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Text(
                                    "Send Message To Us",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
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
                                      text: "$loyaltyPoint pt",
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
                    Container(
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
                    )
                  ],
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        if (stage < 8) {
          setState(() {
            stage++;
          });
        }

        updateProgress();
      }),
    );
  }
}
