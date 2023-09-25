class CarSummaryModel {
  List<CarSummaryDetails> carSummaryDetailsFromJson(
          {required List<Map<String, dynamic>> jsonList}) =>
      List<CarSummaryDetails>.from(
          jsonList.map((x) => CarSummaryDetails.fromJson(x)));
}

class CarSummaryDetails {
  CarSummaryDetails({
    required this.label,
    required this.value,
  });

  String label;
  String value;

  factory CarSummaryDetails.fromJson(Map<String, dynamic> json) =>
      CarSummaryDetails(
        label: json['label'] as String,
        value: json['value'] as String,
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
      };
}
