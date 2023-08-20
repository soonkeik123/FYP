import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/admin/staff_manage.dart';
import 'package:ohmypet/pages/home/main_home_page.dart';
import 'package:ohmypet/widgets/reusable_widget.dart';

import '../../utils/colors.dart';
import '../../widgets/loading_animation.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUp';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();

  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final phoneRegex = RegExp(r'^60\d{9,10}$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("C5e4ff"),
          hexStringToColor("a9d6ff"),
          hexStringToColor("86c5ff")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Full Name as IC",
                  Icons.person_2_outlined, false, _userNameTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Email", Icons.email_outlined, false,
                  _emailTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Phone e.g. 60123456789",
                  Icons.phone_outlined, false, _phoneTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.lock_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 20,
              ),
              signInSignUpButton(context, false, () {
                bool isAllFilled = true;

                if (_userNameTextController.text.isEmpty ||
                    _emailTextController.text.isEmpty ||
                    _passwordTextController.text.isEmpty ||
                    _phoneTextController.text.isEmpty) {
                  isAllFilled = false;
                }

                if (isAllFilled) {
                  if (emailRegex.hasMatch(_emailTextController.text)) {
                    if (phoneRegex.hasMatch(_phoneTextController.text)) {
                      if (_passwordTextController.text.length >= 6) {
                        // Show loading dialog
                        LoadingAnimation.showSignUp(context);

                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                            .then((value) async {
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            String uid = user.uid;
                            // Now you have the UID of the current user

                            DatabaseReference profileRef = FirebaseDatabase
                                .instance
                                .ref()
                                .child('users')
                                .child(uid)
                                .child('Profile');

                            Map<String, dynamic> profileData = {
                              'full_name': _userNameTextController.text,
                              'nickname': '',
                              'email': _emailTextController.text,
                              'phone': _phoneTextController.text,
                              'point': 0,
                              'role': 'user',
                            };

                            profileRef.set(profileData).then((_) {
                              print('Data saved successfully!');
                              // Simulate loading for 2 seconds
                              Future.delayed(Duration(seconds: 2), () {
                                // Close the loading dialog
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainHomePage()));

                                showSuccessSnackBar(); // Show the success snackbar when data is saved successfully
                              });
                            }).catchError((error) {
                              print('Error saving data: $error');
                            });
                          }

                          print("Created New Account");
                        }).onError((error, stackTrace) {
                          print("Error ${error.toString()}");
                        });
                      } else {
                        showMessageDialog(context, "Register Failed",
                            "The password must have at least 6 digits.");
                      }
                    } else {
                      showMessageDialog(context, "Register Failed",
                          "Please make sure that phone number is start of '60' and only contains 11 to 12 digits. Example: 60123456789");
                    }
                  } else {
                    showMessageDialog(context, "Register Failed",
                        "Please make sure that you're using the correct Email format.");
                  }
                } else {
                  showMessageDialog(context, "Register Failed",
                      "Please make sure that you have filled up all the data field.");
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  bool showProgressIndicator = false;

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Register Successful, Welcome!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );
  }
}
