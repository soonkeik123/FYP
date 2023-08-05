import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'title_text.dart';

class AdminHeader extends StatelessWidget {
  final String pageTitle;

  const AdminHeader({super.key, required this.pageTitle});

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
                    onTap: () => showConfirmDialog(context),
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

  // Confirm Remove Action
  void showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          title: const Text('Logout'),
          titleTextStyle: const TextStyle(
            color: Colors.red,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          content: const SizedBox(
            height: 50,
            child: Text('Are you sure you want to sign out?'),
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
                'Cancel',
                style: TextStyle(color: AppColors.paraColor, fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, true); // Return true to indicate confirmation
              },
              child: const Text('Confirm',
                  style: TextStyle(
                      color: AppColors.catBasicRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value) {
        Navigator.popAndPushNamed(context, '/signIn');
      } else {}
    });
  }
}
