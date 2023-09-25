class IssueType {
  String? id;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;

  IssueType(
      {this.id,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt,
      });

  IssueType.fromJson(Map<String, dynamic> json) {
    id = json['_id'] as String?;
    createdAt = json['createdAt'] as String?;
    name = json["name"] as String?;
    status = json['status'] as String?;
    updatedAt = json['updatedAt'] as String?;
  }
}
