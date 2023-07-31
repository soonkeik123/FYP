import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ohmypet/data/repository/location_repo.dart';
import 'package:ohmypet/models/address_model.dart';

class LocationController extends GetxController implements GetxService {
  LocationRepo locationRepo;
  LocationController({required this.locationRepo});
  bool _loading = false;
  late Position _position;
  late Position _pickPosition;

  Placemark placemark = Placemark();
  Placemark _pickPlaceMark = Placemark();
  // Placemark get pickPlaceMark => _pickPlaceMark;

  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;
  late List<AddressModel> _allAddressList = [];
  List<String> _addressTypeList = ["home", "office", "others"];
  int _addressTypeIndex = 0;
  late Map<String, dynamic> _getAddress;
  Map get getAddress => _getAddress;

  // Future<List<Prediction>> searchLocation(
  //     BuildContext context, String text) async {
  //   if (text != null && text.isNotEmpty) {
  //     http.Response response = await getLocationData(text);
  //     var data = jsonDecode(response.body.toString());
  //     print("my status is " + data["status"]);
  //     if (data['status'] == 'OK') {
  //       _predictionList = [];
  //       data['predictions'].forEach((predition) =>
  //           _predictionList.add(Prediction.fromJason(prediction)));
  //     } else {}
  //     return _predictionList;
  //   }
  // }
}
