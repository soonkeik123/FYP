import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/big_text.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:ohmypet/widgets/title_text.dart';

class OrderConfirmationPage extends StatefulWidget {
  static const routeName = '/confirmOrder';
  const OrderConfirmationPage({super.key});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  // Pet
  String pet = "Bei Bei";
  // Service
  List<String> selectedService = ['Dog Boarding', 'Dog Basic Grooming'];
  // Room Selection
  String room = "D2";
  // Date
  String dateSelected = "2023-07-24";
  // Time
  String timeSelected = "-";
  // Pet Taxi Checkbox
  bool isChecked = false;
  // Price
  int price = 60;

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
                      TitleText(text: "Select Your Pet:"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        pet,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: selectedService
                            .map((item) => Text(item,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Date
                      TitleText(text: "Date Chosen"),
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
                      TitleText(text: "Time Selected:"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        timeSelected,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Room Selected
                      TitleText(text: "Room Selected:"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        room,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Pet Taxi
                      TitleText(text: "Pet Taxi Required"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        isChecked ? "Yes" : "None",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Total Price
                      TitleText(text: "Total Price"),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        ("RM '$price'"),
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
                            width: 140,
                            child: BigText(
                              text: "Proceed",
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
