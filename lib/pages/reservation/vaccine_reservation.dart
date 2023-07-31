import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/big_text.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:ohmypet/widgets/small_text.dart';
import 'package:ohmypet/widgets/title_text.dart';

import '../../widgets/drop_down_button_widget.dart';

class VaccineReservationPage extends StatefulWidget {
  static const routeName = '/vaccineReservation';
  const VaccineReservationPage({super.key});

  @override
  State<VaccineReservationPage> createState() => _VaccineReservationPageState();
}

class _VaccineReservationPageState extends State<VaccineReservationPage> {
  // Pet Selection
  List<String> petList = <String>['BeiBei', 'Zuzu', 'Huahua', 'Xiuniu'];
  // Vaccine Selection
  List<String> vaccineList = <String>[
    'Rabies Vaccine',
    'Canine Parvovirus',
    'Distemper',
    'Bordetella',
    'Feline Distemper',
    'Feline Herpesvirus-1',
    'Feline Calicivirus'
  ];
  // Time Selection
  List<String> timeList = <String>['10:00AM', '12:00PM', '2:00PM', '4:00PM'];
  // Date Picker
  TextEditingController dateInput = TextEditingController();
  // Pet Taxi Checkbox
  bool isChecked = false;

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
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

                          // Select Vaccine
                          TitleText(text: "Select Vaccine:"),
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
                              listPassDown: vaccineList,
                              onChanged: (newValue) {},
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
                                    // DateTime.now() - not to allow to choose before today.
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

                          // Choose Time
                          TitleText(text: "Choose Time:"),
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
                              listPassDown: timeList,
                              onChanged: (newValue) {},
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
                                  TitleText(text: "Pet Taxi Required"),
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
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const OrderConfirmationPage()));
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
                  left: -5,
                  child: SizedBox(
                    height: 140,
                    child: Image.asset("assets/images/cute-image-1.png"),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
