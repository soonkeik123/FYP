import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/profile/loyalty_points.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/header.dart';

import '../../widgets/bottom_navigation_bar.dart';

class MainProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  const MainProfilePage({super.key});

  @override
  State<MainProfilePage> createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  // Create a reference to Firebase database
  late DatabaseReference profileRef;

  String userName = "";
  String userNickname = "";
  String userPhone = "";
  String userEmail = "";
  int loyaltyPoint = 0;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      profileRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(uid)
          .child('Profile');
      getUserByID(uid);
    }
  }

  // Get a specific user data by ID
  Future<void> getUserByID(String UID) async {
    final snapshot = await profileRef.get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> userData = snapshot.value as Map;

      // Access individual properties of the user data
      String name = userData['full_name'];
      String nickname = userData['nickname'];
      String email = userData['email'];
      String phone = userData['phone'];
      int point = userData['point'];

      setState(() {
        userName = name;
        userNickname = nickname;
        userEmail = email;
        userPhone = phone;
        loyaltyPoint = point;
      });
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          const CustomHeader(pageTitle: "PROFILE"),

          // showing the body
          // Profile Picture and Name
          Expanded(
            child: SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Column(
                children: [
                  Container(
                    height: 130,
                    margin: const EdgeInsets.only(top: 30, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Profile picture
                        Container(
                          height: 120,
                          width: 120,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage("assets/images/1.jpg"),
                                  fit: BoxFit.cover)),
                        ),
                        // Profile info
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text((userNickname == '') ? userName : userNickname,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                            const SizedBox(
                              height: 3,
                            ),
                            Text("+$userPhone",
                                style: const TextStyle(fontSize: 16)),
                            Text(userEmail,
                                style: const TextStyle(fontSize: 14)),
                            // Line
                            Container(
                              width: 150,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.3,
                                      color: Colors.black.withOpacity(0.4))),
                            ),
                            Text("$loyaltyPoint Points",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ],
                              color: AppColors.petVaccineOrange,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15)),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                            // color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, '/editProfile');
                        },
                      ),
                      InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ],
                              color: AppColors.catBasicRed,
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15)),
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                            // color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.popAndPushNamed(context, '/signIn')
                              .then((_) => false);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  // Loyalty Point
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoyaltyPointPage()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      padding: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 1, color: Colors.black26)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Loyalty Point",
                            style: TextStyle(
                                color: AppColors.mainColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w400),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: AppColors.mainColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black26)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "FAQ",
                          style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: AppColors.mainColor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black26)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: AppColors.mainColor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black26)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Terms and Conditions",
                          style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: AppColors.mainColor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.black26)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: AppColors.mainColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(
        activePage: 3,
      ),
    );
  }
}
