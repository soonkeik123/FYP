import 'package:flutter/material.dart';
import 'package:ohmypet/pages/home/home_page_body.dart';
import 'package:ohmypet/utils/dimensions.dart';

import '../../utils/colors.dart';
import '../../widgets/bottom_navigation_bar.dart';

class MainHomePage extends StatefulWidget {
  static const routeName = '/home';
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int currentIndex = 0; // Set the initial selected item to index 0
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          // Here can set the height
          height: 100,
          // margin: EdgeInsets.only(bottom: Dimensions.height10),
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.only(
                top: Dimensions.height45, bottom: Dimensions.height15),
            padding: EdgeInsets.only(
                left: Dimensions.width20, right: Dimensions.width20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Dimensions.width30,
                  ),
                  Image.asset(
                    "assets/images/title-logo.png",
                    width: 140,
                  ),
                  Center(
                    child: SizedBox(
                      width: Dimensions.width45,
                      height: Dimensions.height45,
                      child: Icon(Icons.notifications,
                          color: AppColors.mainColor,
                          size: Dimensions.iconSize28),
                    ),
                  )
                ]),
          ),
        ),
        // showing the body

        const Expanded(
            child: SingleChildScrollView(
          child: HomePageBody(),
        )),

        const BottomNavBar(
          activePage: 0,
        ),
      ],
    ));
  }
}
