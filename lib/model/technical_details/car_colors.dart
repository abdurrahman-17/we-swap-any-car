class CarColors {
  String? id;
  String? colorCode;
  String? name;

  CarColors({
    this.id,
    this.colorCode,
    this.name,
  });

  CarColors.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    colorCode = json['colorCode'] as String?;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'colorCode': colorCode,
        'name': name,
      };
}
