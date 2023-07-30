import 'package:flutter/cupertino.dart';
import 'package:ohmypet/utils/dimensions.dart';

class TitleText extends StatelessWidget {
  Color? color;
  final String text;
  double size;

  TitleText({
    Key? key,
    this.color = const Color(0xFF0D47A1),
    required this.text,
    this.size = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontFamily: 'Roboto',
          fontSize: size == 0 ? Dimensions.font20 : size,
          fontWeight: FontWeight.w400),
    );
  }
}
