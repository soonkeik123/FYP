import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_and_text_widget.dart';
import '../../widgets/small_text.dart';
import '../utils/dimensions.dart';

class AppColumn extends StatelessWidget {
  final String text;
  int maxLine;

  AppColumn({
    Key? key,
    required this.text,
    this.maxLine = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
      children: [
        BigText(
          text: text,
          size: Dimensions.font26,
          maxLine: maxLine == 2 ? 2 : 1,
        ),
        SizedBox(
          // Using the height ratio of Dimensions class
          height: Dimensions.height10,
        ),
        Row(
          children: [
            Wrap(
              children: List.generate(
                  // List.generate can create list of children
                  5,
                  (index) => const Icon(
                        // => same as {return ...;}
                        Icons.star,
                        color: AppColors.mainColor,
                        size: 15,
                      )),
            ),
            const SizedBox(
              width: 10,
            ),
            SmallText(
              text: "4.5",
              color: Colors.grey,
            ),
            const SizedBox(
              width: 10,
            ),
            SmallText(
              text: "1287 comments",
              color: Colors.grey,
            ),
          ],
        ),
        SizedBox(
          // Using the height ratio of Dimensions class
          height: Dimensions.height20,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndTextWidget(
                icon: Icons.circle, text: "Normal", iconColor: Colors.orange),
            IconAndTextWidget(
                icon: Icons.location_on,
                text: "1.7km",
                iconColor: AppColors.mainColor),
            IconAndTextWidget(
                icon: Icons.access_time_rounded,
                text: "32min",
                iconColor: Colors.red),
          ],
        ),
      ],
    );
  }
}
