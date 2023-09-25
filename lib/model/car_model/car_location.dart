class CarLocation {
  String? type;
  List<num>? coordinates;

  CarLocation({this.type, this.coordinates});

  CarLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String?;
    if (json['coordinates'] != null && json['coordinates'] is List<num>) {
      coordinates = json['coordinates'] as List<num>?;
    }
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': (coordinates ?? []).map((e) => e).toList(),
      };
}
