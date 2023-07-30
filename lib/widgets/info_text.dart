import 'package:flutter/cupertino.dart';
import 'package:ohmypet/utils/dimensions.dart';

class InfoText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  bool normal;

  InfoText({
    Key? key,
    this.color = const Color(0xff0000000),
    required this.text,
    this.size = 0,
    this.normal = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontFamily: 'Roboto',
          fontSize: size == 0 ? Dimensions.font20 : size,
          fontWeight: normal ? FontWeight.w500 : FontWeight.w300),
    );
  }
}
