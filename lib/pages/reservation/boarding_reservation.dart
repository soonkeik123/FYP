import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ohmypet/pages/reservation/select_room.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/big_text.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:ohmypet/widgets/small_text.dart';
import 'package:ohmypet/widgets/title_text.dart';

import '../../widgets/drop_down_button_widget.dart';

class BoardingReservation extends StatefulWidget {
  static const dogBoardingReservation = '/dogBoardingReservation';
  static const catBoardingReservation = '/catBoardingReservation';
  bool dogBoard;
  BoardingReservation({super.key, required this.dogBoard});

  @override
  State<BoardingReservation> createState() => _BoardingReservationState();
}

class _BoardingReservationState extends State<BoardingReservation> {
  late bool isDog;
  String roomtype = "";
  // Pet Selection
  List<String> petList = <String>['BeiBei', 'Zuzu', 'Huahua', 'Xiuniu'];
  // Date Picker
  TextEditingController dateInput = TextEditingController();
  // Pet Taxi Checkbox
  bool isChecked = false;
  // Room Selection
  String roomSelected = "";

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    isDog = widget.dogBoard;
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Column(
        children: [
          // Header
          const CustomHeader(
            pageTitle: "Make Reservation",
          ),

          Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  heightFactor: 1.25,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: double.maxFinite,
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pet Selection
                          TitleText(text: "Select Your Pet:"),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            width: 230,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15),
                              border: Border.all(
                                  color: AppColors.mainColor, width: 2.0),
                            ),
                            child: DropdownButtonWidget(
                              listPassDown: petList,
                              onChanged: (newValue) {},
                            ),
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
                                  color: AppColors.mainColor, width: 2.0),
                            ),
                            alignment: Alignment.centerLeft,
                            // padding: EdgeInsets.only(bottom: ),
                            width: 230,
                            height: 50,
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              enabled: false,
                              textAlign: TextAlign.left,
                              // readOnly: true,
                              controller: TextEditingController(
                                text: isDog ? "Dog Boarding" : "Cat Boarding",
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
                                  color: AppColors.mainColor, width: 2.0),
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

                          // Select Room
                          TitleText(text: "Select Room:"),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 230,
                            height: 40,
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15),
                              border: Border.all(
                                  color: AppColors.mainColor, width: 2.0),
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
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius15),
                                    ),
                                    child: TextButton(
                                        onPressed: () async {
                                          roomtype = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => isDog
                                                    ? SelectRoomPage(
                                                        dogBoard: true)
                                                    : SelectRoomPage(
                                                        dogBoard:
                                                            false)), // Replace NewPage with the name of your new page class
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
                                  TitleText(
                                    text: "Pet Taxi Required",
                                    size: 18,
                                  ),
                                  SmallText(
                                    text: "(Exclusive fee will be charged)",
                                    size: Dimensions.font14,
                                    color: AppColors.mainColor,
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          // Next Button
                          InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           const OrderConfirmationPage()), // Replace NewPage with the name of your new page class
                              // );
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
                  )),
              Positioned(
                  bottom: -5,
                  right: 5,
                  child: SizedBox(
                    height: 100,
                    child: Image.asset("assets/images/cute-image-2.png"),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
