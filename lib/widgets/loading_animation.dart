import 'package:flutter/material.dart';

class LoadingAnimation {
  static void showLoadingDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(text),
            ],
          ),
        );
      },
    );
  }

  static void showLoading(BuildContext context) {
    showLoadingDialog(context, 'Loading...');
  }

  static void showLogin(BuildContext context) {
    showLoadingDialog(context, 'Logging in...');
  }

  static void showSignUp(BuildContext context) {
    showLoadingDialog(context, 'Signing up...');
  }
}
