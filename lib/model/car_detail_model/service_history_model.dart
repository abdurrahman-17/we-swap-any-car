class ServiceHistory {
  int? mainDealer;
  int? independent;
  String? record;

  ServiceHistory({this.mainDealer, this.independent, this.record});

  ServiceHistory.fromJson(Map<String, dynamic> json) {
    mainDealer = json['mainDealer'] as int?;
    independent = json['independent'] as int?;
    record = json['record'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mainDealer'] = mainDealer;
    data['independent'] = independent;
    data['record'] = record;
    return data;
  }
}
