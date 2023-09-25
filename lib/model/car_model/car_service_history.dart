class ServiceHistory {
  List<String>? images;
  int? independent;
  int? mainDealer;
  String? record;

  ServiceHistory({
    this.images,
    this.independent,
    this.mainDealer,
    this.record,
  });

  factory ServiceHistory.fromJson(Map<String, dynamic> json) {
    List<String> imageList = [];
    if (json['images'] != null) {
      for (final item in json['images'] as List) {
        imageList.add("$item");
      }
    }

    return ServiceHistory(
      images: imageList,
      independent: json['independent'] as int?,
      mainDealer: json['mainDealer'] as int?,
      record: json['record'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'images': (images ?? []).map((x) => x).toList(),
        'independent': independent,
        'mainDealer': mainDealer,
        'record': record,
      };
}
