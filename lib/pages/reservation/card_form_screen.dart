import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ohmypet/widgets/header.dart';

class CardFormScreen extends StatelessWidget {
  const CardFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // header
          const CustomHeader(pageTitle: "Payment with Card"),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Card Form",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                CardFormField(
                  controller: CardFormEditController(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
