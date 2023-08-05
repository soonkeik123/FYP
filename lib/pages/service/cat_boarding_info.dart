import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/big_text.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:ohmypet/widgets/small_text.dart';
import 'package:ohmypet/widgets/title_text.dart';

class CatBoardingInfo extends StatelessWidget {
  static const routeName = '/catBoardingInfo';
  const CatBoardingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeColor,
      body: Column(
        children: [
          // Header
          const CustomHeader(
            pageTitle: "Pet Boarding",
          ),

          Stack(
            children: [
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 1.6,
                margin: const EdgeInsets.only(top: 110, bottom: 50),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: Dimensions.height30),
                      height: 150,
                      child: Image.asset("assets/images/petBoarding.png"),
                    ),
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
                          EdgeInsets.symmetric(horizontal: Dimensions.width30),

                      // Price of info
                      child: Column(
                        children: [
                          Text(
                            "Cat",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.font20,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                                      text: "Below 20cm",
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    BigText(
                                      text: "RM 50 - RM 80",
                                      size: Dimensions.font18,
                                      color: Colors.white,
                                    ),
                                    SmallText(
                                      text: "per night",
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
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
                                      text: "20cm - 35cm",
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    BigText(
                                      text: "RM 50 - RM 80",
                                      size: Dimensions.font18,
                                      color: Colors.white,
                                    ),
                                    SmallText(
                                      text: "per night",
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
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
                                      text: "Above 35cm",
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    BigText(
                                      text: "RM 60 - RM 90",
                                      size: Dimensions.font18,
                                      color: Colors.white,
                                    ),
                                    SmallText(
                                      text: "per night",
                                      color: Colors.white,
                                    ),
                                  ],
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
                    SizedBox(
                      height: Dimensions.height15,
                    ),
                    Container(
                      height: 100,
                      alignment: Alignment.topLeft,
                      margin:
                          EdgeInsets.symmetric(horizontal: Dimensions.width45),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.6,
                            child: Text(
                              'Come and be loved and pampered by our Certified Pet Carer in our whole day playtime together with your meow meow friends.',
                              style: TextStyle(
                                fontSize: Dimensions.font16,
                                color: AppColors.textColor,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.width15),
                      margin: const EdgeInsets.only(top: 34),
                      child: Text(
                        "**For pet boarding, the price will be fixed regardless of the check-in time.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimensions.font10 + 2,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius30),
                        color: AppColors.mainColor,
                      ),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/catBoardingReservation');
                          },
                          child: Text(
                            "Make Reservation",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.font20,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
