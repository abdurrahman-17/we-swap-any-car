import '../core/configurations.dart';
import '../model/add_car/common_step_model.dart.dart';

class UploadPhotoVideoStepperHelper {
  static List<CommonStepsModel> carDifferentViews = [
    CommonStepsModel(
      title: 'Right',
      subTitle: 'Right side view',
      asset: Assets.carRightSideView,
      isMandatory: true,
    ),
    CommonStepsModel(
      title: 'Left',
      subTitle: 'Left side view',
      asset: Assets.carLeftSideView,
      isMandatory: true,
    ),
    CommonStepsModel(
      title: 'Front',
      subTitle: 'Front view',
      asset: Assets.carFrontView,
      isMandatory: true,
    ),
    CommonStepsModel(
      title: 'Rear',
      subTitle: 'Rear view',
      asset: Assets.carRearView,
      isMandatory: true,
    ),
    CommonStepsModel(
      title: 'Interior (Inside)',
      subTitle: 'Dashboard view',
      asset: Assets.carDashboard,
      isMandatory: true,
    ),
    CommonStepsModel(
      title: 'Boot Space',
      subTitle: 'Boot space view',
      asset: Assets.carBootSpaceView,
    ),
    CommonStepsModel(
      title: 'Additional Images',
      subTitle: 'Additional images of vehicle',
      asset: Assets.carFrontView,
    ),
    CommonStepsModel(
      isVideo: true,
      title: 'Video',
      subTitle: 'Vehicle video',
      asset: Assets.carFrontView,
    ),
  ];
}
