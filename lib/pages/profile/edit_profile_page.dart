import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/header.dart';

import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/title_text.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = '/editProfile';
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Create a reference to Firebase database
  late DatabaseReference profileRef;

  // To record the original text
  String userName = "";
  String userNickname = "";
  String userPhone = "";
  String userEmail = "";

  TextEditingController fullNameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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

      setState(() {
        userName = name;
        fullNameController.text = name;

        userNickname = nickname;
        nicknameController.text = nickname;

        userEmail = email;
        emailController.text = email;

        userPhone = phone;
        phoneController.text = phone;
      });
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile picture
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      height: 130,
                      width: 130,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/images/1.jpg"),
                              fit: BoxFit.cover)),
                    ),

                    // Personal Information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name
                        TitleText(
                          text: "Full Name",
                          size: 16,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.mainColor, width: 2.0),
                          ),
                          alignment: Alignment.centerLeft,
                          // padding: EdgeInsets.only(bottom: ),
                          width: 230,
                          height: 40,
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            enabled: true,
                            textAlign: TextAlign.left,
                            controller: fullNameController,
                            style: const TextStyle(color: AppColors.mainColor),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 12)),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        // Nickname
                        TitleText(
                          text: "Nickname",
                          size: 16,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.mainColor, width: 2.0),
                          ),
                          alignment: Alignment.centerLeft,
                          // padding: EdgeInsets.only(bottom: ),
                          width: 230,
                          height: 40,
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            enabled: true,
                            textAlign: TextAlign.left,
                            controller: nicknameController,
                            style: const TextStyle(color: AppColors.mainColor),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 12),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        // Phone Number
                        TitleText(
                          text: "Mobile",
                          size: 16,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.mainColor, width: 2.0),
                          ),
                          alignment: Alignment.centerLeft,
                          // padding: EdgeInsets.only(bottom: ),
                          width: 230,
                          height: 40,
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            enabled: true,
                            textAlign: TextAlign.left,
                            controller: phoneController,
                            style: const TextStyle(color: AppColors.mainColor),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 12),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        // Email Address
                        TitleText(
                          text: "Email",
                          size: 16,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppColors.mainColor, width: 2.0),
                          ),
                          alignment: Alignment.centerLeft,
                          // padding: EdgeInsets.only(bottom: ),
                          width: 230,
                          height: 40,
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            enabled: true,
                            textAlign: TextAlign.left,
                            controller: emailController,
                            style: const TextStyle(color: AppColors.mainColor),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    // Cancel and Save Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.mainColor, width: 1),
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius15)),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.mainColor),
                              // color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.popAndPushNamed(context, '/profile');
                          },
                        ),
                        InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius15)),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                              // color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            bool fullname = fullNameController.text != userName;
                            bool nickname = nicknameController != userNickname;
                            bool phone = phoneController != userPhone;
                            bool email = emailController != userEmail;

                            Map<String, String> updatedData = {
                              if (fullname)
                                'full_name': fullNameController.text,
                              if (nickname) 'nickname': nicknameController.text,
                              if (phone) 'phone': phoneController.text,
                              if (email) 'email': emailController.text,
                            };

                            updateUserData(updatedData);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
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

  Future<void> updateUserData(Map<String, String> updatedData) async {
    await profileRef.update(updatedData);
    print("Success");
    Navigator.popAndPushNamed(context, '/profile');
  }
}
