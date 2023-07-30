import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ohmypet/pages/profile/signup_screen.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/widgets/reusable_widget.dart';

import '../admin/reservation_manage.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signIn';
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/cover-logo.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Username", Icons.person_2_outlined,
                    false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) async {
                    String uid = value.user?.uid ??
                        ''; // Get the user's UID from the FirebaseUser object
                    DatabaseReference profileRef = FirebaseDatabase.instance
                        .ref()
                        .child('users')
                        .child(uid)
                        .child('Profile');

                    // Retrieve the user's profile data
                    final snapshot = await profileRef.child('role').get();
                    if (snapshot.exists) {
                      if (snapshot.value.toString() == 'user') {
                        Navigator.pushReplacementNamed(context, '/home');
                      } else if (snapshot.value.toString() == 'staff' ||
                          snapshot.value == 'admin') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReservationManagement(
                                    role: snapshot.value.toString(),
                                  )),
                        );
                      }

                      print(snapshot.value);
                    } else {
                      print('No data available.');
                    }
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have account? ",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
                color: AppColors.mainColor, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
