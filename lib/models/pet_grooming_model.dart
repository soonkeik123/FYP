class PetGrooming {
  String? groomingType;
  List<String>? serviceIncluded;
  String? duration;
  Price? price;

  PetGrooming(
      {this.groomingType, this.serviceIncluded, this.duration, this.price});

  PetGrooming.fromJson(Map<String, dynamic> json) {
    groomingType = json['grooming_type'];
    serviceIncluded = json['service_included'].cast<String>();
    duration = json['duration'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['grooming_type'] = groomingType;
    data['service_included'] = serviceIncluded;
    data['duration'] = duration;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    return data;
  }
}

class Price {
  String? small;
  String? medium;
  String? large;
  String? giant;

  Price({this.small, this.medium, this.large, this.giant});

  Price.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    medium = json['medium'];
    large = json['large'];
    giant = json['giant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['small'] = small;
    data['medium'] = medium;
    data['large'] = large;
    data['giant'] = giant;
    return data;
  }
}
