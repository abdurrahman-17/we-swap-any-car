class AppUpdateModel {
  num? iosVersion;
  String? iosUrl;
  String? androidUrl;
  num? androidVersion;
  bool isNormalUpdate = false;
  bool isForceUpdate = false;

  AppUpdateModel({
    this.iosVersion,
    this.iosUrl,
    this.androidUrl,
    this.androidVersion,
    this.isNormalUpdate = false,
    this.isForceUpdate = false,
  });

  AppUpdateModel.fromJson(Map<String, dynamic> json) {
    iosVersion = json['ios_version'] as num?;
    iosUrl = json['ios_url'] as String?;
    androidUrl = json['android_url'] as String?;
    androidVersion = json['android_version'] as num?;
    isNormalUpdate = json['isNormalUpdate'] as bool? ?? false;
    isForceUpdate = json['isForceUpdate'] as bool? ?? false;
  }
}
