class AddressModel {
  late int? _id;
  late String _addressType;
  late String? _contactPersonName;
  late String? _contactPersonNumber;
  late String _address;
  late String _latitude;
  late String _longtitude;

  AddressModel(
      {id,
      required addressType,
      contactPersonName,
      contactPersonNumber,
      address,
      latitude,
      longtitude}) {
    _id = id;
    _addressType = _addressType;
    _contactPersonName = _contactPersonName;
    _contactPersonNumber = _contactPersonNumber;
    _address = _address;
    _latitude = _latitude;
    _longtitude = _longtitude;
  }
  String get address => _address;
  String get addressType => _addressType;
  String? get contactPersonName => _contactPersonName;
  String? get contactPersonNumber => _contactPersonNumber;
  String get latitude => _latitude;
  String get longtitude => _longtitude;

  AddressModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addressType = json["address_type"] ?? "";
    _contactPersonNumber = json["contact_person_number"] ?? "";
    _contactPersonName = json["contact_person_name"] ?? "";
    _address = json["address"];
    _latitude = json["latitude"];
    _longtitude = json["longtitude"];
  }
}
