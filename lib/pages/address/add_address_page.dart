import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ohmypet/controllers/location_controller.dart';

import '../../utils/colors.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  TextEditingController _addressController = TextEditingController();
  CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(1.5338304733168895, 103.68183000980095), zoom: 17);
  late LatLng _initialPosition = LatLng(1.5338304733168895, 103.68183000980095);

  @override
  void initState() {
    super.initState();
    if (Get.find<LocationController>().addressList.isNotEmpty) {
      _cameraPosition = CameraPosition(
          target: LatLng(
              double.parse(
                  Get.find<LocationController>().getAddress["latitude"]),
              double.parse(
                  Get.find<LocationController>().getAddress["longtitude"])));
      _initialPosition = LatLng(
          double.parse(Get.find<LocationController>().getAddress["latitude"]),
          double.parse(
              Get.find<LocationController>().getAddress["longtitude"]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 2, color: AppColors.mainColor)),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _initialPosition, zoom: 17),
          ),
        ],
      ),
    );
  }
}
