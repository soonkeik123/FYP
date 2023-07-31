import 'package:get/get.dart';
import 'package:ohmypet/data/repository/location_repo.dart';

import '../controllers/location_controller.dart';

Future<void> init() async {
  // // api client
  // Get.lazyPut(() => ApiClient(appBaseUrl: "https://www.dbestech.com"));
  // // repo
  // Get.lazyPut(() => PetGroomingRepo(apiClient: Get.find()));
  Get.lazyPut(() =>
      LocationRepo(apliClient: Get.find(), sharedPreferences: Get.find()));

  // // controllers
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  // Get.lazyPut(() => PetGroomingController(petGroomingRepo: Get.find()));
}
