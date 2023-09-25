class FaqModel {
  String? id;
  String? createdAt;
  String? question;
  String? answer;
  String? updatedAt;
  String? updatedBy;
  String? status;
  int? sortOrder;
  String? type;

  FaqModel({
    this.id,
    this.createdAt,
    this.question,
    this.answer,
    this.status,
    this.sortOrder,
    this.type,
    this.updatedAt,
    this.updatedBy,
  });

  FaqModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    createdAt = json['createdAt'] as String?;
    question = json['question'] as String?;
    answer = json['answer'] as String?;
    updatedAt = json['updatedAt'] as String?;
    status = json['status'] as String?;
    updatedBy = json['updatedBy'] as String?;
    type = json['type'] as String?;
    sortOrder = json['sortOrder'] as int?;
  }
}
