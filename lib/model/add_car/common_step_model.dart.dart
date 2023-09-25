import '../../core/configurations.dart';

class CommonStepsModel {
  ProgressStatus? status;
  String title;
  String subTitle;
  String? asset;
  bool? isVideo;
  bool isMandatory;
  CommonStepsModel({
    this.status,
    this.asset,
    this.isVideo = false,
    required this.title,
    required this.subTitle,
    this.isMandatory = false,
  });
}
