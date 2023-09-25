import 'dart:convert';

class GetSystemConfigurationResponseModel {
  GetSystemConfigurationResponseModel({
    required this.systemConfigurations,
  });

  SystemConfiguration systemConfigurations;

  factory GetSystemConfigurationResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetSystemConfigurationResponseModel(
        systemConfigurations: SystemConfiguration.fromJson(
            jsonDecode(json['getSystemConfigurations'] as String)
                as Map<String, dynamic>),
      );
}

class SystemConfiguration {
  SystemConfiguration({
    required this.id,
    required this.priceApprovePercentage,
  });

  String id;
  double priceApprovePercentage;

  factory SystemConfiguration.fromJson(Map<String, dynamic> json) =>
      SystemConfiguration(
        id: json['_id'] as String,
        priceApprovePercentage:
            json['priceApprovePercentage']?.toDouble() as double,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'priceApprovePercentage': priceApprovePercentage,
      };
}
