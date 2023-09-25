class BodyTypes {
  String? slug;
  String? name;
  String? id;

  BodyTypes({
    this.slug,
    this.name,
    this.id,
  });

  BodyTypes.fromJson(Map<String, dynamic> json) {
    slug = json['slug'] as String?;
    name = json['name'] as String?;
    id = json['_id'] as String?;
  }

  Map<String, dynamic> toJson() => {
        'slug': slug,
        'name': name,
        '_id': id,
      };
}
