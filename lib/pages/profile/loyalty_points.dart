import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/info_text.dart';

import '../../widgets/big_text.dart';
import '../../widgets/header.dart';

class LoyaltyPointPage extends StatefulWidget {
  static const routeName = '/loyaltyPoint';
  const LoyaltyPointPage({super.key});

  @override
  State<LoyaltyPointPage> createState() => _LoyaltyPointPageState();
}

class _LoyaltyPointPageState extends State<LoyaltyPointPage> {
  // Create a reference to Firebase database
  late DatabaseReference profileRef;

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
      int point = userData['point'];

      setState(() {
        loyaltyPoint = point;
      });
    } else {
      print('No data available.');
    }
  }

  final List<Map<String, dynamic>> gridData = [
    {
      'title': 'Cat Basic Grooming',
      'imageUrl': 'assets/images/cat-basic-grooming.png',
      'color': '0xFFC62828',
      'point': '600',
    },
    {
      'title': 'Dog Basic Grooming',
      'imageUrl': 'assets/images/dog-basic-grooming.png',
      'color': '0xFF7986CB',
      'point': '600',
    },
    {
      'title': 'Cat Full Grooming',
      'imageUrl': 'assets/images/cat-full-grooming.png',
      'color': '0xFF8D6E63',
      'point': '800',
    },
    {
      'title': 'Dog Full Grooming',
      'imageUrl': 'assets/images/dog-full-grooming.png',
      'color': '0xFFFF9E80',
      'point': '800',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          const CustomHeader(pageTitle: "Loyalty Point"),

          // Points Showing
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            width: double.maxFinite,
            height: 200,
            decoration: const BoxDecoration(
              color: AppColors.themeColor,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InfoText(
                    text: "You've accumulated",
                    size: 20,
                    normal: false,
                    color: AppColors.mainColor,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InfoText(
                      text: "$loyaltyPoint pt",
                      size: 40,
                      normal: false,
                      color: AppColors.mainColor),
                  const SizedBox(
                    height: 15,
                  ),
                  InfoText(
                      text: "Thanks for sticking with us!",
                      size: 20,
                      normal: false,
                      color: AppColors.mainColor),
                ],
              ),
            ),
          ),

          // Services that can be redeemed free with certain points
          // Title
          Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                left: 30,
                top: 30,
              ),
              child: BigText(
                text: "Redeem",
                color: AppColors.mainColor,
                size: 20,
              )),
          // Items
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
            height: 370,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // controller: ScrollController(keepScrollOffset: false),
              itemCount: gridData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                print(gridData.toString());
                return CustomGridItem(
                  title: gridData[index]['title'],
                  imageUrl: gridData[index]['imageUrl'],
                  color: gridData[index]['color'],
                  point: gridData[index]['point'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomGridItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String point;
  final String color;

  const CustomGridItem(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.point,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(int.parse(color)), spreadRadius: 1, blurRadius: 5)
          ]),
      child: Column(
        children: [
          Image.asset(
            imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          // SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          Text("$point points",
              style: const TextStyle(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
