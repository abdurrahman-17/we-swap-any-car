class AdditionalInformation {
  String? attentionGraber;
  String? description;
  String? companyDescription;

  AdditionalInformation({
    this.attentionGraber,
    this.description,
    this.companyDescription,
  });

  factory AdditionalInformation.fromJson(Map<String, dynamic> json) =>
      AdditionalInformation(
        attentionGraber: json['attentionGraber'] as String?,
        description: json['description'] as String?,
        companyDescription: json['companyDescription'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'attentionGraber': attentionGraber,
        'description': description,
        'companyDescription': companyDescription,
      };
}
