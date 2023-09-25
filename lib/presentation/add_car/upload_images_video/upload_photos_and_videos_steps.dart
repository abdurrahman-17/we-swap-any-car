import 'dart:io';

import 'package:wsac/main.dart';

import '../../../bloc/car_details/car_details_bloc.dart';
import '../../../core/configurations.dart';
import '../../../helpers/upload_photo_video_stepper.dart';
import '../../../model/add_car/common_step_model.dart.dart';
import '../../../model/car_model/car_model.dart';
import '../../../service/amplify_api_service.dart/amplify_api_manager.dart';
import '../../common_widgets/animated_gradient_progress_bar.dart';
import '../../common_widgets/common_admin_support_button.dart';
import '../../common_widgets/common_divider.dart';
import '../../common_widgets/common_loader.dart';
import '../../common_widgets/common_popups.dart';
import '../../common_widgets/processing_step_tile.dart';
import 'upload_photo_and_video_screen.dart';

class UploadPhotosAndVideosStepScreen extends StatefulWidget {
  static const String routeName = 'upload_photos_and_video_stepper_screen';
  const UploadPhotosAndVideosStepScreen({
    Key? key,
    this.carModel,
  }) : super(key: key);
  final CarModel? carModel;
  @override
  State<UploadPhotosAndVideosStepScreen> createState() =>
      _UploadPhotosAndVideosStepScreenState();
}

class _UploadPhotosAndVideosStepScreenState
    extends State<UploadPhotosAndVideosStepScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> _progressAnimation;
  late AnimationController _progressAnimcontroller;
  late int index = 0;
  double? growStepWidth, beginWidth, endWidth = 0.0;
  List<int> completedIndex = [];

  //ImgUrls
  List<String> rightImagesUrls = [];
  List<String> leftImagesUrls = [];
  List<String> frontImagesUrls = [];
  List<String> rearImagesUrls = [];
  List<String> interiorImagesUrls = [];
  List<String> bootSpaceImagesUrls = [];
  List<String> additionalImagesUrls = [];
  List<String> videosUrls = [];

  //photos steps
  List<CommonStepsModel> carDifferentViews = [];
  final ValueNotifier<double> _downloadCount = ValueNotifier<double>(0);

  @override
  void initState() {
    carDifferentViews = UploadPhotoVideoStepperHelper.carDifferentViews;
    //Animation
    _progressAnimcontroller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _progressAnimation =
        Tween<double>(begin: 0, end: 0).animate(_progressAnimcontroller);

    autoPopulateData();
    super.initState();
  }

  void autoPopulateData() {
    if (widget.carModel?.uploadPhotos != null) {
      if ((widget.carModel?.uploadPhotos?.rightImages ?? []).isNotEmpty) {
        rightImagesUrls = widget.carModel!.uploadPhotos!.rightImages!;
        completedIndex.add(0);
      }
      if ((widget.carModel?.uploadPhotos?.leftImages ?? []).isNotEmpty) {
        leftImagesUrls = widget.carModel!.uploadPhotos!.leftImages!;
        completedIndex.add(1);
      }
      if ((widget.carModel?.uploadPhotos?.frontImages ?? []).isNotEmpty) {
        frontImagesUrls = widget.carModel!.uploadPhotos!.frontImages!;
        completedIndex.add(2);
      }
      if ((widget.carModel?.uploadPhotos?.rearImages ?? []).isNotEmpty) {
        rearImagesUrls = widget.carModel!.uploadPhotos!.rearImages!;
        completedIndex.add(3);
      }
      if ((widget.carModel?.uploadPhotos?.interiorImages ?? []).isNotEmpty) {
        interiorImagesUrls = widget.carModel!.uploadPhotos!.interiorImages!;
        completedIndex.add(4);
      }
      if ((widget.carModel?.uploadPhotos?.bootSpaceImages ?? []).isNotEmpty) {
        bootSpaceImagesUrls = widget.carModel!.uploadPhotos!.bootSpaceImages!;
        completedIndex.add(5);
      }
      if ((widget.carModel?.uploadPhotos?.adittionalImages ?? []).isNotEmpty) {
        additionalImagesUrls = widget.carModel!.uploadPhotos!.adittionalImages!;
        completedIndex.add(6);
      }
      if ((widget.carModel?.uploadPhotos?.videos ?? []).isNotEmpty) {
        videosUrls = widget.carModel!.uploadPhotos!.videos!;
        completedIndex.add(7);
      }
    }
    setProgressAnim(size.width, completedIndex.length);
  }

  void setProgressAnim(double maxWidth, int curPageIndex) {
    growStepWidth = maxWidth / carDifferentViews.length;
    beginWidth = growStepWidth! * (curPageIndex - 1);
    endWidth = growStepWidth! * curPageIndex;

    _progressAnimation = Tween<double>(begin: beginWidth, end: endWidth)
        .animate(_progressAnimcontroller);
    _progressAnimcontroller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarDetailsBloc, CarDetailsState>(
      listener: (context, state) {
        if (state is UpdateCarInfoState &&
            state.carCreateStatus == CarCreateStatus.uploadPhotos) {
          if (state.updateCarStatus == ProviderStatus.success) {
            Navigator.pop(context);
            CarModel? car = state.car;
            Navigator.of(context).pop({'carModel': car});
          } else if (state.updateCarStatus == ProviderStatus.error) {
            Navigator.pop(context);
            showSnackBar(message: state.errorMessage ?? '');
          } else {
            progressDialogue();
          }
        }
      },
      child: CustomScaffold(
        title: uploadPhotosandVideosAppBar,
        actions: const [
          AdminSupportButton(),
        ],
        body: SafeArea(
          child: Column(
            children: [
              AnimatedProgressBar(
                height: getVerticalSize(3.h),
                animation: _progressAnimation,
              ),
              Expanded(
                child: Padding(
                  padding: getPadding(left: 20.w, right: 20.w),
                  child: Column(
                    children: [
                      Container(
                        margin: getMargin(top: 15.h, bottom: 15.h),
                        padding: getPadding(
                          left: 20.w,
                          top: 16.h,
                          right: 20.w,
                          bottom: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.kColor2C2C2C.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Text(
                          herebyIConfirm,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.txtPTSansRegular14Gray30001,
                        ),
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: carDifferentViews.length,
                            itemBuilder: (context, index) {
                              return ProcessingTile(
                                stepNumber: index,
                                status: completedIndex.contains(index)
                                    ? ProgressStatus.completed
                                    : null,
                                title: carDifferentViews[index].title,
                                subTitle: carDifferentViews[index].subTitle,
                                isMandatory:
                                    carDifferentViews[index].isMandatory,
                                onTap: () async {
                                  final Object? result =
                                      await Navigator.pushNamed(
                                    context,
                                    UploadPhotosAndVideoScreen.routeName,
                                    arguments: {
                                      'selectedIndex': index,
                                      'carDifferentViews': carDifferentViews,
                                      'imgUrls': returnList(index),
                                    },
                                  );
                                  if (result != null) {
                                    final completedJson =
                                        result as Map<String, dynamic>;
                                    setValue(completedJson);
                                    setState(() {});
                                  }
                                },
                              );
                            },
                            separatorBuilder: (context, index) => CommonDivider(
                              color: ColorConstant.kColorC7C7C7,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 15.h, bottom: 15.h),
                        child: CustomElevatedButton(
                          title: proceedButton,
                          onTap: completedIndex.contains(0) &&
                                  completedIndex.contains(1) &&
                                  completedIndex.contains(2) &&
                                  completedIndex.contains(3) &&
                                  completedIndex.contains(4)
                              ? () => onTapProceed(onProceed: true)
                              : null,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (completedIndex.isNotEmpty) {
                            onTapProceed();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          skipForNowButton,
                          style: AppTextStyle.regularTextStyle.copyWith(
                            color: ColorConstant.kColor646464,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setValue(Map<String, dynamic> json) async {
    // progressDialogue();
    int index = json['index'] as int;
    List<String> selecteditems = json['images'] as List<String>;
    if (!completedIndex.contains(index)) {
      completedIndex.add(index);
    }
    completedIndex.toSet().toList();
    setProgressAnim(size.width, completedIndex.length);
    showUploadProgress(
      total: selecteditems.length,
      progress: _downloadCount,
    );
    if (selecteditems.isNotEmpty) {
      switch (index) {
        case 0:
          rightImagesUrls = await uploadPhotos(selecteditems);
        case 1:
          leftImagesUrls = await uploadPhotos(selecteditems);
        case 2:
          frontImagesUrls = await uploadPhotos(selecteditems);
        case 3:
          rearImagesUrls = await uploadPhotos(selecteditems);
        case 4:
          interiorImagesUrls = await uploadPhotos(selecteditems);
        case 5:
          bootSpaceImagesUrls = await uploadPhotos(selecteditems);
        case 6:
          additionalImagesUrls = await uploadPhotos(selecteditems);
        case 7:
          videosUrls = await uploadPhotos(selecteditems);
        default:
          break;
      }
    }
    Navigator.of(globalNavigatorKey.currentContext!).pop();
  }

  List<String> returnList(int index) {
    switch (index) {
      case 0:
        return rightImagesUrls;
      case 1:
        return leftImagesUrls;
      case 2:
        return frontImagesUrls;
      case 3:
        return rearImagesUrls;
      case 4:
        return interiorImagesUrls;
      case 5:
        return bootSpaceImagesUrls;
      case 6:
        return additionalImagesUrls;
      case 7:
        return videosUrls;
      default:
        return [];
    }
  }

  //Upload Photos to s3 bucket
  Future<List<String>> uploadPhotos(List<String> imageList) async {
    late List<String> uploadedImgUrls = [];
    _downloadCount.value = 0;
    await Future.wait(imageList.map((image) async {
      if (image.contains('https')) {
        uploadedImgUrls.add(getEncodedUrl(image));
      } else {
        final String imgUrl = await AmplifyApiManager.uploadImageToS3(
          File(image),
          progressFunction: (prog) {
            if (prog < 1) {
              _downloadCount.value = (_downloadCount.value).toInt() + prog;
            }
          },
        );
        if (imgUrl.isNotEmpty) {
          uploadedImgUrls.add(getEncodedUrl(imgUrl));
        }
      }
      _downloadCount.value = ((_downloadCount.value).toInt()) + 1;
    }));
    return uploadedImgUrls;
  }

  void onTapProceed({bool onProceed = false}) {
    List<String> createStatus = widget.carModel?.createStatus ?? [];
    createStatus.add(convertEnumToString(CarCreateStatus.uploadPhotos));

    BlocProvider.of<CarDetailsBloc>(context).add(
      UpdateCarInfoEvent(
        carInfoData: {
          '_id': widget.carModel?.id,
          if (onProceed) 'createStatus': createStatus.toSet().toList(),
          'uploadPhotos': {
            'rightImages': rightImagesUrls,
            'leftImages': leftImagesUrls,
            'frontImages': frontImagesUrls,
            'rearImages': rearImagesUrls,
            'interiorImages': interiorImagesUrls,
            'bootSpaceImages': bootSpaceImagesUrls,
            'adittionalImages': additionalImagesUrls,
            'videos': videosUrls,
          }
        },
        carCreateStatus: CarCreateStatus.uploadPhotos,
      ),
    );
  }
}
