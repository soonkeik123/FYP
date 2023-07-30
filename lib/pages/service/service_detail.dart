
import 'package:flutter/material.dart';
import 'package:ohmypet/utils/colors.dart';
import 'package:ohmypet/utils/dimensions.dart';
import 'package:ohmypet/widgets/app_icon.dart';
import 'package:ohmypet/widgets/big_text.dart';
import 'package:ohmypet/widgets/expandable_text_widget.dart';

class ServiceDetail extends StatelessWidget {
  const ServiceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 75,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIcon(icon: Icons.clear),
                AppIcon(icon: Icons.notifications),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius20),
                      topRight: Radius.circular(Dimensions.radius20),
                    )),
                child: Center(
                    child: BigText(
                  text: "Sliver App Bar",
                  size: Dimensions.font26,
                )),
              ),
            ),
            pinned: true, // Avoid affect from overscroll
            expandedHeight: 300,
            backgroundColor: AppColors.mainColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/1.jpg",
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                ),
                child: const ExpandableTextWidget(
                    text:
                        "method is a lifecycle method in Flutter that imethod is a lifecycle method in Flutter that is called when the stateful widget is insertewed into the widget tree for the first time. It is used to perform one-time initialization tasks  the widget, such as setting up listeners, initializing variables, or fetching data. you ensure that the  default initialization tasks defined in the State class are executed, which may include important setup operations  for the widget's state. Skipping this call could potentially lead to unexpected behavior or errorsmethod is a lifecycle method in Flutter that is called when the stateful widget is insertewed into the widget tree for the first time. It is used to perform one-time initialization tasks  the widget, such as setting up listeners, initializing variables, or fetching data. you ensure that the  default initialization tasks defined in the State class are executed, which may include important setup operations  for the widget's state. Skipping this call could potentially lead to unexpected behavior or errorsmethod is a lifecycle method in Flutter that is called when the stateful widget is insertewed into the widget tree for the first time. It is used to perform one-time initialization tasks  the widget, such as setting up listeners, initializing variables, or fetching data. you ensure that the  default initialization tasks defined in the State class are executed, which may include important setup operations  for the widget's state. Skipping this call could potentially lead to unexpected behavior or errorsmethod is a lifecycle method in Flutter that is called when the stateful widget is insertewed into the widget tree for the first time. It is used to perform one-time initialization tasks  the widget, such as setting up listeners, initializing variables, or fetching data. you ensure that the  default initialization tasks defined in the State class are executed, which may include important setup operations  for the widget's state. Skipping this call could potentially lead to unexpected behavior or errorss called when the stateful widget is insertewed into the widget tree for the first time. It is used to perform one-time initialization tasks  the widget, such as setting up listeners, initializing variables, or fetching data. you ensure that the  default initialization tasks defined in the State class are executed, which may include important setup operations  for the widget's state. Skipping this call could potentially lead to unexpected behavior or errors.method is a lifecycle method in Flutter that is called when the stateful widget is insertewed into the widget tree for the first time. It is used to perform one-time initialization tasks  the widget, such as setting up listeners, initializing variables, or fetching data. you ensure that the  default initialization tasks defined in the State class are executed, which may include important setup operations  for the widget's state. Skipping this call could potentially lead to unexpected behavior or errorsmethod is a lifecycle method in Flutter that is called when the stateful widget is insertewed into the widget tree for the first time. It is used to perform one-time initialization tasks  the widget, such as setting up listeners, initializing variables, or fetching data. you ensure that the  default initialization tasks defined in the State class are executed, which may include important setup operations  for the widget's state. Skipping this call could potentially lead to unexpected behavior or errorsmethod is a lifecycle method in Flutter that is called when the stateful widget is insertewed into the widget tree for the first time. It is used to perform one-time initialization tasks  the widget, such as setting up listeners, initializing variables, or fetching data. you ensure that the  default initialization tasks defined in the State class are executed, which may include important setup operations  for the widget's state. Skipping this call could potentially lead to unexpected behavior or errors"),
              ),
            ],
          )),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: Dimensions.width20 * 2.5,
              right: Dimensions.width20 * 2.5,
              top: Dimensions.height10,
              bottom: Dimensions.height10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIcon(
                  icon: Icons.remove,
                  iconColor: AppColors.signColor,
                  backgroundColor: AppColors.buttonBackgroundColor,
                  iconSize: Dimensions.iconSize24,
                ),
                BigText(
                  text: "\$12.88 X 0",
                  color: Colors.black,
                  size: Dimensions.font22,
                ),
                AppIcon(
                  icon: Icons.add,
                  iconColor: AppColors.signColor,
                  backgroundColor: AppColors.buttonBackgroundColor,
                  iconSize: Dimensions.iconSize24,
                ),
              ],
            ),
          ),
          Container(
            height: Dimensions.bottomHeightBar,
            padding: EdgeInsets.only(
                top: Dimensions.height10,
                bottom: Dimensions.height10,
                left: Dimensions.width20,
                right: Dimensions.width20),
            decoration: const BoxDecoration(
              color: AppColors.buttonBackgroundColor,
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(Dimensions.radius20 * 2),
              //   topRight: Radius.circular(Dimensions.radius20 * 2),
              // )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: Dimensions.height15,
                      bottom: Dimensions.height15,
                      left: Dimensions.width15,
                      right: Dimensions.width15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: AppColors.signColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: Dimensions.height15,
                      bottom: Dimensions.height15,
                      left: Dimensions.width15,
                      right: Dimensions.width15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: Colors.white,
                  ),
                  child: BigText(
                    text: "Use Package",
                    color: AppColors.signColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
