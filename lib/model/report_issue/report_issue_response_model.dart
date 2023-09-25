class ReportIssueResponseModel {
  String? sId;
  String? createdAt;
  String? description;
  String? status;
  String? reportedBy;
  String? title;
  String? typeId;
  String? updatedAt;
  String? updatedBy;

  ReportIssueResponseModel(
      {this.sId,
      this.createdAt,
      this.description,
      this.status,
      this.reportedBy,
      this.title,
      this.typeId,
      this.updatedAt,
      this.updatedBy});

  ReportIssueResponseModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] as String?;
    createdAt = json['createdAt'] as String?;
    description = json['description'] as String?;
    status = json['status'] as String?;
    reportedBy = json['reportedBy'] as String?;
    title = json['title'] as String?;
    typeId = json['typeId'] as String?;
    updatedAt = json['updatedAt'] as String?;
    updatedBy = json['updatedBy'] as String?;
  }
}
