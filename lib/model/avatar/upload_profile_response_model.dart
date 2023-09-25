class AvatarResponse {
  String? sId;
  String? name;
  String? url;
  String? status;
  String? createdAt;
  String? updatedAt;

  AvatarResponse(
      {this.sId,
      this.name,
      this.url,
      this.status,
      this.createdAt,
      this.updatedAt});

  AvatarResponse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] as String?;
    name = json['name'] as String?;
    url = json['url'] as String?;
    status = json['status'] as String?;
    createdAt = json['createdAt'] as String?;
    updatedAt = json['updatedAt'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['url'] = url;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
