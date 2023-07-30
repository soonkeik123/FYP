import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/big_text.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:ohmypet/widgets/small_text.dart';
import 'package:ohmypet/widgets/title_text.dart';

class DogGroomInfo extends StatefulWidget {
  static const dogBasicGroomInfo = '/dogBasicGroomInfo';
  static const dogFullGroomInfo = '/dogFullGroomInfo';
  bool fullGrooming;
  DogGroomInfo({super.key, required this.fullGrooming});

  @override
  State<DogGroomInfo> createState() => _DogGroomInfoState();
}

class _DogGroomInfoState extends State<DogGroomInfo> {
  // Access fullGrooming directly from widget object
  late bool isFullGrooming;

  List<Map<String, dynamic>> dogGroomingList = [
    {
      'type': 'Dog Basic Groom',
      'price': ['RM 60', 'RM 65', 'RM 70', 'RM 80'],
      'services': [
        'Bath',
        'Blow',
        'Ear Cleaning',
        'Nail Cutting',
        'Private Part Shaving',
      ],
    },
    {
      'type': 'Dog Full Groom',
      'price': ['RM 80', 'RM 85', 'RM 90', 'RM100'],
      'services': [
        'Bath',
        'Blow',
        'Ear Cleaning',
        'Nail Cutting',
        'Private Part Shaving',
        'Designated Hair Cut',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Access fullGrooming here and assign it to isFullGrooming
    isFullGrooming = widget.fullGrooming;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Column(
        children: [
          // Header
          const CustomHeader(
            pageTitle: "Dog Grooming",
          ),

          Stack(
            children: [
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 1.6,
                margin: const EdgeInsets.only(top: 110, bottom: 60),
              ),
              Container(
                child: Column(
                  children: [
                    // Image
                    Container(
                      margin: EdgeInsets.only(top: Dimensions.height30),
                      height: 140,
                      child: Image.asset(isFullGrooming
                          ? "assets/images/dog-full-grooming.png"
                          : "assets/images/dog-basic-grooming.png"),
                    ),

                    // Price
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                        color: AppColors.mainColor,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width30,
                          vertical: Dimensions.height10),
                      margin:
                          EdgeInsets.symmetric(horizontal: Dimensions.width40),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BigText(
                                      text: "Small",
                                      color: Colors.white,
                                      size: Dimensions.font18,
                                    ),
                                    SmallText(
                                      text: "Below 30cm",
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                BigText(
                                  text: isFullGrooming
                                      ? dogGroomingList[1]['price'][0]
                                      : dogGroomingList[0]['price'][0],
                                  size: Dimensions.font22,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BigText(
                                      text: "Medium",
                                      color: Colors.white,
                                      size: Dimensions.font18,
                                    ),
                                    SmallText(
                                      text: "30cm - 40cm",
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                BigText(
                                  text: isFullGrooming
                                      ? dogGroomingList[1]['price'][1]
                                      : dogGroomingList[0]['price'][1],
                                  size: Dimensions.font22,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BigText(
                                      text: "Large",
                                      color: Colors.white,
                                      size: Dimensions.font18,
                                    ),
                                    SmallText(
                                      text: "40cm - 60cm",
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                BigText(
                                  text: isFullGrooming
                                      ? dogGroomingList[1]['price'][2]
                                      : dogGroomingList[0]['price'][2],
                                  size: Dimensions.font22,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BigText(
                                      text: "Giant",
                                      color: Colors.white,
                                      size: Dimensions.font18,
                                    ),
                                    SmallText(
                                      text: "Above 60cm",
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                BigText(
                                  text: isFullGrooming
                                      ? dogGroomingList[1]['price'][3]
                                      : dogGroomingList[0]['price'][3],
                                  size: Dimensions.font22,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin:
                          EdgeInsets.symmetric(horizontal: Dimensions.width45),
                      child: TitleText(
                        text: "Service Included",
                        size: Dimensions.font18,
                      ),
                    ),
                    Container(
                      height: 180,
                      alignment: Alignment.topLeft,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        // padding: EdgeInsets.symmetric(horizontal: 5),
                        itemCount: isFullGrooming
                            ? dogGroomingList[1]['services'].length
                            : dogGroomingList[0]['services'].length,
                        itemBuilder: ((context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: Dimensions.width45),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                BigText(
                                  text: isFullGrooming
                                      ? dogGroomingList[1]['services'][index]
                                      : dogGroomingList[0]['services'][index],
                                  size: Dimensions.font18,
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 50,
                right: 50,
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    color: AppColors.mainColor,
                  ),
                  child: TextButton(
                      onPressed: () {
                        isFullGrooming
                            ? Navigator.pushNamed(
                                context, '/dogFullGroomReservation')
                            : Navigator.pushNamed(
                                context, '/dogBasicGroomReservation');
                      },
                      child: Text(
                        "Make Reservation",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.font20,
                        ),
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
