class AddressDetailModel {
  String? postcode;
  num? latitude;
  num? longitude;
  List<String>? formattedAddress;
  String? thoroughfare;
  String? buildingName;
  String? subBuildingName;
  String? subBuildingNumber;
  String? buildingNumber;
  String? line1;
  String? line2;
  String? line3;
  String? line4;
  String? locality;
  String? townOrCity;
  String? county;
  String? district;
  String? country;
  bool? residential;

  AddressDetailModel({
    this.postcode,
    this.latitude,
    this.longitude,
    this.formattedAddress,
    this.thoroughfare,
    this.buildingName,
    this.subBuildingName,
    this.subBuildingNumber,
    this.buildingNumber,
    this.line1,
    this.line2,
    this.line3,
    this.line4,
    this.locality,
    this.townOrCity,
    this.county,
    this.district,
    this.country,
    this.residential,
  });

  AddressDetailModel.fromJson(Map<String, dynamic> json) {
    postcode = json['postcode'] as String?;
    latitude = json['latitude'] as num?;
    longitude = json['longitude'] as num?;
    if (json['formatted_address'] != null) {
      formattedAddress = [];
      for (final item in json['formatted_address'] as List) {
        formattedAddress!.add("$item");
      }
    }
    thoroughfare = json['thoroughfare'] as String?;
    buildingName = json['building_name'] as String?;
    subBuildingName = json['sub_building_name'] as String?;
    subBuildingNumber = json['sub_building_number'] as String?;
    buildingNumber = json['building_number'] as String?;
    line1 = json['line_1'] as String?;
    line2 = json['line_2'] as String?;
    line3 = json['line_3'] as String?;
    line4 = json['line_4'] as String?;
    locality = json['locality'] as String?;
    townOrCity = json['town_or_city'] as String?;
    county = json['county'] as String?;
    district = json['district'] as String?;
    country = json['country'] as String?;
    residential = json['residential'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postcode'] = postcode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['formatted_address'] = formattedAddress;
    data['thoroughfare'] = thoroughfare;
    data['building_name'] = buildingName;
    data['sub_building_name'] = subBuildingName;
    data['sub_building_number'] = subBuildingNumber;
    data['building_number'] = buildingNumber;
    data['line_1'] = line1;
    data['line_2'] = line2;
    data['line_3'] = line3;
    data['line_4'] = line4;
    data['locality'] = locality;
    data['town_or_city'] = townOrCity;
    data['county'] = county;
    data['district'] = district;
    data['country'] = country;
    data['residential'] = residential;
    return data;
  }
}
