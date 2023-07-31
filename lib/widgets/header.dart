import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'title_text.dart';

class CustomHeader extends StatelessWidget {
  final String pageTitle;

  const CustomHeader({super.key, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    if (pageTitle == "SERVICES" ||
        pageTitle == "PROFILE" ||
        pageTitle == "RESERVATION") {
      return Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 7, offset: Offset(0, 1))
        ]),
        // Here can set the height
        height: 90,
        // margin: EdgeInsets.only(bottom: Dimensions.height10),
        child: Container(
          margin: EdgeInsets.only(
              top: Dimensions.height45 + 5, bottom: Dimensions.height15),
          padding: EdgeInsets.only(
              left: Dimensions.width20, right: Dimensions.width20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              width: Dimensions.width30,
            ),
            TitleText(
              text: pageTitle,
            ),
            Center(
              child: SizedBox(
                width: Dimensions.width45,
                height: Dimensions.height45,
                child: Icon(Icons.notifications,
                    color: AppColors.mainColor, size: Dimensions.iconSize28),
              ),
            )
          ]),
        ),
      );
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
                  onPressed: () => (pageTitle == "Edit Pet Profile")
                      ? Navigator.popAndPushNamed(context, '/home')
                      : Navigator.pop(context),
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
