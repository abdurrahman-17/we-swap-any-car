class PostCodeDetailsResponseModel {
  PostCodeDetailsResponseModel({
    required this.status,
    required this.result,
  });

  int status;
  List<PostCodeDetails> result;

  factory PostCodeDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final result = json['result'] as List<dynamic>;
    return PostCodeDetailsResponseModel(
      status: json['status'] as int,
      result: List<PostCodeDetails>.from(result
          .map((x) => PostCodeDetails.fromJson(x as Map<String, dynamic>))),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'result': List<PostCodeDetails>.from(result.map((x) => x.toJson())),
      };
}

class PostCodeDetails {
  PostCodeDetails({
    required this.postcode,
    required this.country,
    required this.nhsHa,
    required this.longitude,
    required this.latitude,
    required this.europeanElectoralRegion,
    required this.primaryCareTrust,
    required this.region,
    required this.parliamentaryConstituency,
    required this.adminDistrict,
    required this.parish,
    required this.adminWard,
    required this.ccg,
  });

  String postcode;
  String country;
  String nhsHa;
  double longitude;
  double latitude;
  String europeanElectoralRegion;
  String primaryCareTrust;
  String region;
  String parliamentaryConstituency;
  String adminDistrict;
  String parish;
  String adminWard;
  String ccg;

  factory PostCodeDetails.fromJson(Map<String, dynamic> json) =>
      PostCodeDetails(
        postcode: json['postcode'] as String,
        country: json['country'] as String,
        nhsHa: json['nhs_ha'] as String,
        longitude: json['longitude']?.toDouble() as double,
        latitude: json['latitude']?.toDouble() as double,
        europeanElectoralRegion: json['european_electoral_region'] as String,
        primaryCareTrust: json['primary_care_trust'] as String,
        region: json['region'] as String,
        parliamentaryConstituency: json['parliamentary_constituency'] as String,
        adminDistrict: json['admin_district'] as String,
        parish: json['parish'] as String,
        adminWard: json['admin_ward'] as String,
        ccg: json['ccg'] as String,
      );

  Map<String, dynamic> toJson() => {
        'postcode': postcode,
        'country': country,
        'nhs_ha': nhsHa,
        'longitude': longitude,
        'latitude': latitude,
        'european_electoral_region': europeanElectoralRegion,
        'primary_care_trust': primaryCareTrust,
        'region': region,
        'parliamentary_constituency': parliamentaryConstituency,
        'admin_district': adminDistrict,
        'parish': parish,
        'admin_ward': adminWard,
        'ccg': ccg,
      };
}
