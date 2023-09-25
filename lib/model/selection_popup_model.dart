class SelectionPopupModel {
  int? id;
  // String? name;
  String? title;
  dynamic value;
  bool? isSelected;

  SelectionPopupModel({
    this.id,
    // required this.name,
    required this.title,
    this.value,
    this.isSelected,
  });

  SelectionPopupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    // name = json['name'] as String?;
    value = json['value'] as dynamic;
    isSelected = json['isSelected'] as bool? ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    // data['name'] = name;
    return data;
  }
}
