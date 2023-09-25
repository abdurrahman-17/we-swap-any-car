class TransmissionTypes {
  String? id;
  String? name;

  TransmissionTypes({
    this.id,
    this.name,
  });

  TransmissionTypes.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
      };
}
