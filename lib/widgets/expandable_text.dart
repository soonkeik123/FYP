import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/small_text.dart';

class ExpandableText extends StatefulWidget {
  final String vaccineName;
  final String description;

  const ExpandableText(
      {super.key, required this.vaccineName, required this.description});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String title;
  late String detail;

  double textHeight = Dimensions.screenHeight / 120;

  bool hiddenText = true;

  @override
  void initState() {
    super.initState();
    if (widget.description.isNotEmpty && widget.vaccineName.isNotEmpty) {
      title = widget.vaccineName.substring(0, widget.vaccineName.length);
      detail = widget.description.substring(0, widget.description.length);
    } else {
      title = widget.vaccineName;
      detail = widget.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: detail.isEmpty
          ? SmallText(
              size: Dimensions.font16, color: AppColors.textColor, text: title)
          : Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallText(
                            size: Dimensions.font16,
                            color: AppColors.textColor,
                            text: title),
                        Icon(
                          hiddenText
                              ? Icons.arrow_drop_down_sharp
                              : Icons.arrow_drop_up_sharp,
                          color: AppColors.textColor,
                        ),
                      ],
                    ),
                  ),
                ),
                hiddenText
                    ? Container()
                    : Container(
                        child: Text(
                          detail,
                          style: TextStyle(
                              color: AppColors.paraColor,
                              fontSize: Dimensions.font14),
                          textAlign: TextAlign.justify,
                        ),
                      ),
              ],
            ),
    );
  }
}
