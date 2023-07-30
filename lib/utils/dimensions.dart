import 'package:flutter/widgets.dart';

class Dimensions {
  static double screenHeight =
      WidgetsBinding.instance.window.physicalSize.height;
  static double screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  // // Make sure every phone has the same ratio of page viewing
  static double pageView = screenHeight / 10;
  static double pageViewContainer = screenHeight / 10.91;
  static double pageViewTextContainer = screenHeight / 18.46;

  //dynamic height padding and margin
  static double height10 = screenHeight / 240.0;
  static double height15 = screenHeight / 160.0;
  static double height20 = screenHeight / 120.0;
  static double height30 = screenHeight / 80.0;
  static double height45 = screenHeight / 53.33;

  //dynamic width padding and margin
  static double width10 = screenWidth / 108.0;
  static double width15 = screenWidth / 72.0;
  static double width20 = screenWidth / 54.0;
  static double width30 = screenWidth / 36.0;
  static double width40 = screenWidth / 27.0;
  static double width45 = screenWidth / 24.0;

  // font size
  static double font10 = screenHeight / 240.0;
  static double font14 = screenHeight / 171.43;
  static double font16 = screenHeight / 150.0;
  static double font18 = screenHeight / 133.3;
  static double font20 = screenHeight / 120.0;
  static double font22 = screenHeight / 109.09;
  static double font26 = screenHeight / 92.30;

  static double radius15 = screenHeight / 160.0;
  static double radius20 = screenHeight / 120.0;
  static double radius30 = screenHeight / 80.0;

  // icon Size
  static double iconSize18 = screenHeight / 133.33;
  static double iconSize20 = screenHeight / 120.0;
  static double iconSize22 = screenHeight / 109.1;
  static double iconSize24 = screenHeight / 100.0;
  static double iconSize26 = screenHeight / 92.31;
  static double iconSize28 = screenHeight / 85.71;

  // List view size
  static double listViewImgSize = screenWidth / 9.0;
  static double listViewTextContSize = screenWidth / 10.8;

  // service package
  static double servicePckgImgSize = screenHeight / 6.86;

  // bottom height
  static double bottomHeightBar = screenHeight / 31.54;
}
