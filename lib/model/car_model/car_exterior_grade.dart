class ExteriorGrade {
  String? id;
  String? grade;
  int? percentageValue;
  ExteriorGrade({this.id, this.grade});

  ExteriorGrade.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    grade = json['grade'] as String?;
  }
  ExteriorGrade.fromQuery(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    grade = json['grade'] as String?;
    percentageValue = json['percentageValue'] as int?;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'grade': grade,
      };
}
