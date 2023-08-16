import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ohmypet/pages/admin/staff_manage.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/header.dart';
import 'package:path_provider/path_provider.dart';

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

  File? _chosenImage;
  final ImagePicker _picker = ImagePicker();
  String storeImagePath = '';
  String imageUrl = '';

  TextEditingController fullNameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
      String image = userData['image'] ?? '';

      setState(() {
        userName = name;
        fullNameController.text = name;

        userNickname = nickname;
        nicknameController.text = nickname;

        userEmail = email;
        emailController.text = email;

        userPhone = phone;
        phoneController.text = phone;

        imageUrl = image;
        if (imageUrl.isNotEmpty) _chosenImage = File(imageUrl);
      });
    } else {
      print('No data available.');
    }
  }

  // Shows option when user clicked on profile image
  void _profilePicEdit() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                // Call the image picker function here
                openImagePicker();

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Implementing image picker
  Future<void> openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _chosenImage = File(pickedImage.path);
      });
    }
  }

  Future<void> saveImageLocally(File imageFile) async {
    // Get the path to the application's documents directory
    final appDocDir = await getApplicationDocumentsDirectory();

    // Get the original filename of the image
    String originalFilename = imageFile.path.split('/').last;

    // Define a new file in the documents directory with the original filename
    final savedImage = File('${appDocDir.path}/$originalFilename');

    // Copy the chosen image to the new file
    await imageFile.copy(savedImage.path);

    storeImagePath = savedImage.path;

    print('Image saved locally: ${savedImage.path}');
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
                    InkWell(
                      onTap: () => _profilePicEdit(),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(
                                  75), // Half of the width or height to make it circular
                            ),
                            child: _chosenImage != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          75), // To make the image inside circular
                                      image: DecorationImage(
                                        image: FileImage(_chosenImage!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Icon(Icons.person_add_alt_1_outlined,
                                    size: 40, color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Upload Picture",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
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

                        const SizedBox(
                          height: 15,
                        ),

                        // New Password
                        TitleText(
                          text: "Change New Password",
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
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
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
                            showConfirmationDialog(context);
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
    showMessageDialog(context, "Update Successful",
        "You have updated your profile information!");
    Navigator.popAndPushNamed(context, '/profile');
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Set your desired border radius here
          ),
          backgroundColor:
              Colors.white, // Set the background color of the dialog
          title: const Text('Confirmation'),
          titleTextStyle: const TextStyle(
            color:
                AppColors.mainColor, // Set your desired title text color here
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          content: const SizedBox(
            height: 50,
            child: Text('Do you confirm saving the information?'),
          ),
          contentTextStyle: const TextStyle(
            color:
                AppColors.mainColor, // Set your desired content text color here
            fontSize: 17.0,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, false); // Return false to indicate cancellation
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, true); // Return true to indicate confirmation
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    ).then((value) async {
      if (value != null && value) {
        if (_chosenImage != null) {
          await saveImageLocally(_chosenImage!);
        }
        bool fullname = fullNameController.text != userName;
        bool nickname = nicknameController.text != userNickname;
        bool phone = phoneController.text != userPhone;
        bool email = emailController.text != userEmail;
        bool password = _passwordController.text.isNotEmpty;
        bool image = imageUrl != storeImagePath;

        Map<String, String> updatedData = {
          if (fullname) 'full_name': fullNameController.text,
          if (nickname) 'nickname': nicknameController.text,
          if (phone) 'phone': phoneController.text,
          if (email) 'email': emailController.text,
          if (image) 'image': storeImagePath,
        };
        try {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null && email && password) {
            await user.updateEmail(emailController.text);
            await user.updatePassword(_passwordController.text);
            print('Email updated successfully');
          } else if (user != null && email) {
            await user.updateEmail(emailController.text);
            print('Email updated successfully');
          } else if (user != null && password) {
            await user.updatePassword(_passwordController.text);
            print('password changed successfully');
          }
          if (user != null) {
            print('No changes to email and password');
          } else {
            print('User not found');
          }
        } catch (e) {
          print('Error updating email: $e');
        }
        updateUserData(updatedData);
      } else {}
    });
  }
}
