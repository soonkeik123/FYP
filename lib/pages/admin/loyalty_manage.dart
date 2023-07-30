import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/admin_header.dart';
import 'package:ohmypet/widgets/admin_navigation_bar.dart';

class LoyaltyManagement extends StatefulWidget {
  static const routeName = '/loyaltyManagement';
  const LoyaltyManagement({super.key});

  @override
  State<LoyaltyManagement> createState() => _LoyaltyManagementState();
}

class _LoyaltyManagementState extends State<LoyaltyManagement> {
  // Create a reference to Firebase database
  late DatabaseReference profileRef;

  String staffName = "";
  String staffEmail = "";
  String staffRole = "";
  String staffID = "";
  @override
  void initState() {
    super.initState();

    User? staff = FirebaseAuth.instance.currentUser;
    if (staff != null) {
      String sid = staff.uid;
      profileRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(sid)
          .child('Profile');
      getStaffByID(sid);
    }
  }

  // Get a specific user data by ID
  Future<void> getStaffByID(String UID) async {
    final snapshot = await profileRef.get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> staffData = snapshot.value as Map;

      // Access individual properties of the user data
      String name = staffData['full_name'];
      String role = staffData['role'];
      String email = staffData['email'];
      String id = UID;

      setState(() {
        staffName = name;
        staffRole = role;
        staffEmail = email;
        staffID = id;
      });
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            AdminHeader(pageTitle: "MANAGE LOYALTY"),

            // Body content
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              height: 580,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Search user
                  const Text(
                    "Search User",
                    style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // Textfield for user email
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.mainColor, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.mainColor, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Enter user email',
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  // Reservation ID
                  const Text(
                    "Reservation ID",
                    style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // Textfield
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.mainColor, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.mainColor, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Enter reservation ID',
                      labelText: 'Reservation ID',
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),

                  // Reservation ID
                  const Text(
                    "Total Point",
                    style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Textfield
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.mainColor, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.mainColor, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Points',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  // submit button
                  InkWell(
                    child: Container(
                      width: 160,
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.mainColor),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    onTap: () {
                      print("ok");
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: AdminBottomNavBar(
        activePage: 1,
        role: staffRole,
      ),
    );
  }
}
