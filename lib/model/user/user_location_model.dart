class UserLocationModel {
  List<num>? coordinates;
  String? type;

  UserLocationModel({this.coordinates, this.type});

  UserLocationModel.fromJson(Map<String, dynamic> json) {
    if (json['coordinates'] != null) {
      coordinates = [];
      for (final item in json['coordinates'] as List) {
        coordinates!.add(item as num);
      }
    }
    type = json['type'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    data['type'] = type;
    return data;
  }
}
