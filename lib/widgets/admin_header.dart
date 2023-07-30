import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'title_text.dart';

class AdminHeader extends StatelessWidget {
  final String pageTitle;

  AdminHeader({super.key, required this.pageTitle});

  Widget _offsetPopup() => PopupMenuButton<int>(
        padding: const EdgeInsets.only(bottom: 2),
        // offset: Offset(0, 30),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 1,
            child: Text(
              "Show only current",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text(
              "Show all reservation",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ],
        onSelected: (value) {
          popUpOption = value;
        },
        icon: const Icon(
          Icons.filter_alt_outlined,
          color: AppColors.mainColor,
          size: 30,
        ),
      );

  int popUpOption = 0;

  @override
  Widget build(BuildContext context) {
    if (pageTitle == "MANAGE PACKAGE" ||
        pageTitle == "MANAGE STAFF" ||
        pageTitle == "MANAGE LOYALTY" ||
        pageTitle == "MANAGE RESERVATION") {
      return Container(
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black38,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 1))
          ]),
          // Here can set the height
          height: 90,
          // margin: EdgeInsets.only(bottom: Dimensions.height10),
          child: Container(
            margin: EdgeInsets.only(
                top: Dimensions.height45 + 5, bottom: Dimensions.height15),
            padding: EdgeInsets.only(
                left: Dimensions.width20, right: Dimensions.width20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Dimensions.width30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TitleText(
                    text: pageTitle,
                    size: Dimensions.font20,
                  ),
                ),
                Center(
                  child: InkWell(
                    child: SizedBox(
                      width: Dimensions.width45,
                      height: Dimensions.height45,
                      child: Icon(Icons.logout_outlined,
                          color: AppColors.mainColor,
                          size: Dimensions.iconSize26),
                    ),
                    onTap: () => Navigator.popAndPushNamed(context, '/signIn'),
                  ),
                )
              ],
            ),
          ));
    } else {
      return Container(
        // Here can set the height
        height: 90,
        // margin: EdgeInsets.only(bottom: Dimensions.height10),
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(
              top: Dimensions.height45, bottom: Dimensions.height10),
          padding: EdgeInsets.only(
              left: Dimensions.width20, right: Dimensions.width20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    size: Dimensions.height20,
                    color: AppColors.mainColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TitleText(
                    text: pageTitle,
                    size: Dimensions.font16,
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: Dimensions.width45,
                    height: Dimensions.height45,
                    child: Icon(Icons.notifications,
                        color: AppColors.mainColor,
                        size: Dimensions.iconSize26),
                  ),
                )
              ]),
        ),
      );
    }
  }
}
