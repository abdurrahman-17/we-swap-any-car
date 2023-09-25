class SingleAttachmentModel {
  String? name;
  String? size;
  String? url;
  String? filePath;

  SingleAttachmentModel({
    this.name,
    this.size,
    this.url,
    this.filePath,
  });

  SingleAttachmentModel.fromJson(Map<String, dynamic> json) {
    name = json["name"] as String?;
    size = json["size"] as String?;
    url = json["url"] as String?;
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "size": size,
      "url": url,
    };
  }
}
