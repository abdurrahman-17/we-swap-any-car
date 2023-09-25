class ValuesSectionInput {
  String? id;
  String? name;

  ValuesSectionInput({this.id, this.name});

  ValuesSectionInput.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
