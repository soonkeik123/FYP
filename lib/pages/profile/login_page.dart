import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

// const users = {
//   'soonkeik123@hotmail.com': '1208',
//   'hunter@gmail.com': 'hunter',
// };

class LoginPage extends StatelessWidget {
  static const routeName = '/login';
  LoginPage({super.key});

  final List<Map<String, dynamic>> userDataList = [];
  void refreshItems(Map<String, dynamic> user) {
    // Simulate a data refresh by adding a new item to the list
    userDataList.add(user);
  }

  DatabaseReference userRef = FirebaseDatabase.instance.ref().child('User');

  Duration get loginTime => const Duration(milliseconds: 2000);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      // if (!userDataList[].containsKey(data.name)) {
      //   return 'User not exists';
      // }
      // if (userDataList[data.name] != data.password) {
      //   return 'Password does not match';
      // }
      // return null;
      Map<String, dynamic>? user = userDataList.firstWhere(
        (user) => user['name'] == data.name,
        orElse: () => {},
      );

      if (user.isEmpty) {
        return 'User not exists';
      }

      // Check if the password matches
      if (user['password'] != data.password) {
        return 'Password does not match';
      }

      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    Map<String, String> users = {
      'email': '${data.name}',
      'nickname': 'User',
      'phone': '',
      'full_name': '',
      'password': '${data.password}',
      'role': 'user'
    };
    userRef.push().set(users);

    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      Map<String, dynamic>? user = userDataList.firstWhere(
        (user) => user['name'] == name,
        orElse: () => {},
      );

      if (user.isEmpty) {
        return 'User not exists';
      }

      // Here, you can implement the logic for recovering the password if needed.
      // For now, let's just return an empty string to indicate success.
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    userRef.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        userDataList.clear(); // Clear the list before adding new data
        data.forEach((key, value) {
          Map<String, dynamic> user = value;
          user['key'] = key;
          // petDataList.add(pet);
          refreshItems(user);
        });
      }
    });
    return FlutterLogin(
      // title: 'OHMYPET',
      logo: const AssetImage("assets/images/cover-logo.png"),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
