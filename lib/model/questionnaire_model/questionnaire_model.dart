class QuestionnaireModel {
  String? question;
  String? ansType;
  String? status;
  String? type;
  List<String>? options;
  List<String>? questionnaireAnswer;
  String? id;
  int? sortOrder;
  // String? createdAt;
  // String? updatedAt;
  // String? updatedBy;

  QuestionnaireModel({
    required this.question,
    required this.ansType,
    required this.status,
    required this.type,
    required this.options,
    required this.questionnaireAnswer,
    required this.id,
    required this.sortOrder,
    // required this.createdAt,
    // required this.updatedAt,
    // required this.updatedBy,
  });

  QuestionnaireModel.fromJson(Map<String, dynamic> json) {
    question = json['question'] as String?;
    ansType = json['ansType'] as String?;
    status = json['status'] as String?;
    type = json['type'] as String?;
    if (json['options'] != null) {
      options = [];
      for (final item in json['options'] as List) {
        options!.add("$item");
      }
    }
    if (json['questionnaireAnswer'] != null) {
      questionnaireAnswer = [];
      for (final item in json['questionnaireAnswer'] as List) {
        questionnaireAnswer!.add("$item");
      }
    }
    id = json['_id'] as String?;
    sortOrder = json['sortOrder'] as int?;
    // createdAt = json['createdAt'] as String?;
    // updatedAt = json['updatedAt'] as String?;
    // updatedBy = json['updatedBy'] as String?;
  }
}
