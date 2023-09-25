import 'dart:developer';
import 'dart:io';

import 'package:wsac/presentation/common_widgets/video_player_widget.dart';

import '../../../core/configurations.dart';
import '../../../model/add_car/common_step_model.dart.dart';
import '../../../utility/file_upload_helper.dart';
import '../../common_widgets/common_admin_support_button.dart';
import '../../common_widgets/common_bullet_points.dart';
import '../../common_widgets/common_stepper_badge.dart';
import '../../common_widgets/full_screen_image_viewer.dart';
import '../../common_widgets/full_screen_video_player.dart';

class UploadPhotosAndVideoScreen extends StatefulWidget {
  static const String routeName = 'upload_photos_and_video_screen';
  const UploadPhotosAndVideoScreen({
    super.key,
    this.selectedIndex,
    this.carDifferentViews,
    this.imgOrVideoUrls,
  });
  final int? selectedIndex;
  final List<CommonStepsModel>? carDifferentViews;
  final List<String>? imgOrVideoUrls;

  @override
  State<UploadPhotosAndVideoScreen> createState() =>
      _UploadPhotosAndVideoScreenState();
}

class _UploadPhotosAndVideoScreenState
    extends State<UploadPhotosAndVideoScreen> {
  late PageController _pageController;
  late int index = 0;
  List<CommonStepsModel> carViews = [];
  late List<String> uploadedImgsOrVideo = [];
  bool isUploadButtonEnabled = true;

  @override
  void initState() {
    index = widget.selectedIndex ?? 0;
    carViews = widget.carDifferentViews ?? [];
    uploadedImgsOrVideo = List.from(widget.imgOrVideoUrls ?? []);
    _pageController = PageController(initialPage: index);
    _pageController.addListener(() {
      index = _pageController.page!.toInt();
      setState(() {});
    });

    checkButtonEnableOrNot();
    super.initState();
  }

  void checkButtonEnableOrNot() {
    //for video only one item
    if (index == 7) {
      isUploadButtonEnabled = uploadedImgsOrVideo.isNotEmpty ? false : true;
    } else {
      isUploadButtonEnabled = uploadedImgsOrVideo.length < 4 ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: index == 7 ? uploadVideoAppBar : uploadPhotosAppBar,
      actions: const [
        AdminSupportButton(),
      ],
      body: Stack(
        children: [
          CustomImageView(
            svgPath: Assets.homeBackground,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
            alignment: Alignment.bottomCenter,
          ),
          Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) {},
                  children: carViews
                      .asMap()
                      .map((i, element) => MapEntry(
                          i,
                          Padding(
                            padding: getPadding(left: 20.w, right: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: getPadding(top: 16.h, bottom: 16.h),
                                  child: Text(
                                    i == 7
                                        ? readInstructionVideoUpload
                                        : readInstructionImageUpload,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppTextStyle.regularTextStyle.copyWith(
                                      color: ColorConstant.kColorBlack,
                                      fontWeight: FontWeight.w700,
                                      fontSize: getFontSize(16),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          CustomImageView(
                                            imagePath: element.asset,
                                            width: double.infinity,
                                            radius: BorderRadius.circular(10.r),
                                            fit: BoxFit.fill,
                                            color: Colors.black54,
                                            colorBlendMode: BlendMode.darken,
                                          ),
                                          Positioned(
                                            bottom: -13.h,
                                            child: const ProgressBagde(
                                              hasWhiteBorder: true,
                                              status: ProgressStatus.cancel,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 14.w),
                                    Expanded(
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          CustomImageView(
                                            imagePath: element.asset,
                                            width: double.infinity,
                                            radius: BorderRadius.circular(10.r),
                                            fit: BoxFit.fill,
                                          ),
                                          Positioned(
                                            bottom: -13.h,
                                            child: const ProgressBagde(
                                              hasWhiteBorder: true,
                                              status: ProgressStatus.completed,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: getPadding(bottom: 16.h),
                                  child: Text(
                                    (element.isVideo ?? false)
                                        ? instructionForUploadVideo
                                        : instructionForUploadPhoto,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppTextStyle.regularTextStyle.copyWith(
                                      color: ColorConstant.kColor535353,
                                    ),
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: carViews
                                        .asMap()
                                        .map((indicatorIndex, element) =>
                                            MapEntry(
                                                indicatorIndex,
                                                Padding(
                                                  padding: getPadding(
                                                      right: 2.w, left: 2.w),
                                                  child: CircleAvatar(
                                                    radius: 3,
                                                    backgroundColor:
                                                        i == indicatorIndex
                                                            ? ColorConstant
                                                                .kPrimaryDarkRed
                                                            : ColorConstant
                                                                .kColorCD9393,
                                                  ),
                                                )))
                                        .values
                                        .toList()),
                                Padding(
                                  padding: getPadding(top: 16.h, bottom: 16.h),
                                  child: Text(
                                    element.subTitle,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppTextStyle.regularTextStyle.copyWith(
                                      color: ColorConstant.kColorBlack,
                                      fontWeight: FontWeight.w700,
                                      fontSize: getFontSize(16),
                                    ),
                                  ),
                                ),
                                GradientElevatedButton(
                                  title: element.isVideo ?? false
                                      ? uploadVideoButton
                                      : uploadPhotosAppBar,
                                  onTap: isUploadButtonEnabled
                                      ? () async {
                                          element.isVideo ?? false
                                              ? await onTapUploadVideo(element)
                                              : await onTapUploadPhoto(element);
                                        }
                                      : null,
                                  buttonGradient: !isUploadButtonEnabled
                                      ? disabledGradient
                                      : null,
                                ),
                                SizedBox(height: 10.h),
                                BulletPoint(
                                  text: element.isVideo ?? false
                                      ? userCanUploadOnlyOneVideo
                                      : userCanUploadFourImages,
                                ),
                                BulletPoint(
                                  text: element.isVideo ?? false
                                      ? sizeShouldBeTwentyMb
                                      : sizeShouldBeFiveMb,
                                ),
                                if (uploadedImgsOrVideo.isNotEmpty)
                                  imagesAndVideoGridview(element),
                              ],
                            ),
                          )))
                      .values
                      .toList(),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          title: backButton,
                          onTap: () async => Navigator.of(context).pop(),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: GradientElevatedButton(
                          title: carViews[index].isVideo ?? false
                              ? submitButton
                              : nextButton,
                          onTap: () {
                            if (carViews[index].isVideo ?? false) {
                              if (uploadedImgsOrVideo.isNotEmpty) {
                                Navigator.pop(context, {
                                  'index': index,
                                  'images': uploadedImgsOrVideo
                                });
                              } else {
                                Navigator.of(context).pop();
                              }
                            } else if (index == 5 || index == 6) {
                              if (uploadedImgsOrVideo.isNotEmpty) {
                                Navigator.pop(context, {
                                  'index': index,
                                  'images': uploadedImgsOrVideo
                                });
                              } else {
                                Navigator.of(context).pop();
                              }
                            } else {
                              if (uploadedImgsOrVideo.isNotEmpty) {
                                Navigator.pop(context, {
                                  'index': index,
                                  'images': uploadedImgsOrVideo
                                });
                              } else {
                                showSnackBar(message: 'Please upload photos');
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget imagesAndVideoGridview(CommonStepsModel element) {
    return element.isVideo ?? false
        ? videoWidget(uploadedImgsOrVideo[0], uploadedImgsOrVideo)
        : GridView.builder(
            shrinkWrap: true,
            padding: getPadding(top: 20.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: getVerticalSize(70),
              crossAxisCount: 4,
              mainAxisSpacing: getHorizontalSize(5),
              crossAxisSpacing: getHorizontalSize(10),
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: uploadedImgsOrVideo.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    log(uploadedImgsOrVideo.toString());
                    Navigator.pushNamed(
                      context,
                      FullScreenImageViewer.routeName,
                      arguments: {
                        'imageList': uploadedImgsOrVideo,
                        "isMultiImage": true,
                        "initialIndex": index,
                      },
                    );
                  },
                  child: imageView(
                      uploadedImgsOrVideo[index], uploadedImgsOrVideo));
            },
          );
  }

  Widget imageView(String image, List<dynamic> selectedList) {
    return Stack(
      children: [
        Container(
          height: getVerticalSize(59.h),
          width: double.infinity,
          margin: getMargin(bottom: 8.h),
          decoration: BoxDecoration(
            color: ColorConstant.kColorBlack,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: CustomImageView(
            file: !image.contains('https') ? File(image) : null,
            url: image.contains('https') ? image : null,
            radius: BorderRadius.circular(8.r),
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 6.h,
          right: 8.w,
          child: InkWell(
            onTap: () {
              selectedList.removeWhere((element) => element == image);
              setState(() {
                isUploadButtonEnabled =
                    uploadedImgsOrVideo.length < 4 ? true : false;
              });
            },
            child: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 18,
            ),
          ),
        )
      ],
    );
  }

  Widget videoWidget(String video, List<dynamic> selectedList) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          FullScreenVideoPlayer.routeName,
          arguments: {
            if (video.contains('http')) 'networkVideoUrl': video,
            if (!video.contains('http')) 'fileVideoUrl': video
          },
        );
      },
      child: VideoPlayerWidget(
        videoFilePath: !video.contains('http') ? video : null,
        videoUrl: video.contains('http') ? video : null,
        height: 80.h,
        width: 95.w,
        borderRadius: BorderRadius.circular(8.r),
        removeAction: () {
          setState(() {
            selectedList.removeWhere((element) => element == video);
            isUploadButtonEnabled = true;
          });
        },
      ),
    );
  }

  Future<void> onTapUploadPhoto(CommonStepsModel stepsModel) async {
    FileManager().showModelSheetForImage(
      isMultiImage: true,
      fileCount: 4 - uploadedImgsOrVideo.length,
      maxFileCount: 4,
      getFiles: (values) async {
        for (final image in values) {
          final bool isNotExist = uploadedImgsOrVideo
              .where((element) => element.toLowerCase() == image.toLowerCase())
              .isEmpty;
          if (isNotExist) {
            uploadedImgsOrVideo.add(image);
          }
        }
        setState(() {
          isUploadButtonEnabled = uploadedImgsOrVideo.length < 4 ? true : false;
        });
      },
    );
  }

  Future<void> onTapUploadVideo(CommonStepsModel stepsModel) async {
    FileManager().showModelSheetForImage(
      pickVideo: true,
      getFile: (value) async {
        if (value != null && value.isNotEmpty) {
          uploadedImgsOrVideo.add(value);
          setState(() {
            isUploadButtonEnabled = false;
          });
        }
      },
    );
  }
}
