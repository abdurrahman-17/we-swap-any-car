class FuelTypes {
  String? id;
  String? name;

  FuelTypes({
    this.id,
    this.name,
  });

  FuelTypes.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
      };
}
