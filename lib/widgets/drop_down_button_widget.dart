import 'package:flutter/material.dart';
import 'package:ohmypet/widgets/big_text.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class DropdownButtonWidget extends StatefulWidget {
  List<String> listPassDown;
  DropdownButtonWidget(
      {super.key,
      required this.listPassDown,
      required Null Function(dynamic newValue) onChanged});

  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  late List<String> dropdownValue;
  String selectedValue = "";
  @override
  void initState() {
    super.initState();
    if (widget.listPassDown.isNotEmpty) {
      dropdownValue = widget.listPassDown.toList();
      selectedValue = dropdownValue.first;
    } else {
      dropdownValue = List.empty();
      selectedValue = dropdownValue.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: const SizedBox(
        width: 0,
        height: 0,
      ),
      borderRadius: BorderRadius.circular(Dimensions.radius15),
      value: selectedValue,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
      ),
      iconSize: 40,
      elevation: 4,
      style: const TextStyle(
        color: AppColors.mainColor,
        fontSize: 16,
      ),
      dropdownColor: Colors.white,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          selectedValue = value!;
        });
      },
      items: dropdownValue.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: SizedBox(
              width: 170,
              child: BigText(
                text: value,
                size: Dimensions.font18,
                color: AppColors.mainColor,
              )),
        );
      }).toList(),
    );
  }
}
