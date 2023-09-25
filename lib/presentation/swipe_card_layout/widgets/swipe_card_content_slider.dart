import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:wsac/core/configurations.dart';
import 'package:wsac/model/car_model/car_model.dart';
import 'package:wsac/presentation/common_widgets/video_player_widget.dart';

import '../../../model/slider_content_model.dart';
import '../../../service/deep_link_service.dart';
import '../../common_widgets/common_like_with_count.dart';
import '../../common_widgets/common_quick_offer_banner.dart';
import '../../common_widgets/common_share_widget.dart';
import '../../common_widgets/full_screen_image_viewer.dart';
import '../../common_widgets/full_screen_video_player.dart';

class SwipeCardContentSlider extends StatefulWidget {
  const SwipeCardContentSlider({
    Key? key,
    this.aspectRatio = 1,
    this.premiumTutorialKey,
    this.quickSaleTutorialKey,
    this.isTutorialVisible = false,
    required this.car,
  }) : super(key: key);
  final CarModel car;
  final double aspectRatio;
  final GlobalKey? premiumTutorialKey;
  final GlobalKey? quickSaleTutorialKey;
  final bool isTutorialVisible;
  @override
  State<SwipeCardContentSlider> createState() => _SwipeCardContentSliderState();
}

class _SwipeCardContentSliderState extends State<SwipeCardContentSlider> {
  late int currentIndex = 0;
  List<SliderContentModel> sliderContents = [];

  void autoMergeAllImgsAndVideo(CarModel car) {
    sliderContents.clear();
    for (String item in car.uploadPhotos?.rightImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car.uploadPhotos?.leftImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car.uploadPhotos?.frontImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car.uploadPhotos?.rearImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car.uploadPhotos?.interiorImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car.uploadPhotos?.bootSpaceImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car.uploadPhotos?.adittionalImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car.uploadPhotos?.videos ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.video,
        url: item,
      ));
    }
  }

  CarouselOptions get _carouselOptions => CarouselOptions(
        aspectRatio: widget.aspectRatio,
        viewportFraction: 1,
        pauseAutoPlayInFiniteScroll: true,
        autoPlay: true,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index, reason) => setState(() => currentIndex = index),
        autoPlayInterval: const Duration(seconds: 3),
      );

  @override
  Widget build(BuildContext context) {
    autoMergeAllImgsAndVideo(widget.car);
    return Stack(
      children: [
        sliderContents.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  if (sliderContents[currentIndex].type ==
                      AttachmentType.image) {
                    List<String> temp = [];
                    for (var element in sliderContents) {
                      temp.add(element.url);
                    }
                    Navigator.pushNamed(
                      context,
                      FullScreenImageViewer.routeName,
                      arguments: {
                        'imageList': temp,
                        'isMultiImage': true,
                        'initialIndex': currentIndex,
                      },
                    );
                  } else {
                    Navigator.pushNamed(
                      context,
                      FullScreenVideoPlayer.routeName,
                      arguments: {
                        'networkVideoUrl': sliderContents[currentIndex].url
                      },
                    );
                  }
                },
                child: CarouselSlider.builder(
                  itemCount: sliderContents.length,
                  options: _carouselOptions,
                  itemBuilder: (context, index, pageViewIndex) => Stack(
                    children: [
                      Container(
                        color: ColorConstant.kColorWhite,
                        child: AspectRatio(
                          aspectRatio: widget.aspectRatio,
                          child:
                              sliderContents[index].type == AttachmentType.image
                                  ? CustomImageView(
                                      url: sliderContents[index].url,
                                      fit: BoxFit.contain,
                                    )
                                  : VideoPlayerWidget(
                                      videoUrl: sliderContents[index].url,
                                      aspectRatio: widget.aspectRatio,
                                    ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                            colors: <Color>[
                              Colors.black.withOpacity(0.9),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: <Color>[
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: Container(
                  color: ColorConstant.kColor7C7C7C,
                  child: CustomImageView(
                    svgPath: Assets.imageNotFoundSvg,
                    color: ColorConstant.kColorWhite,
                  ),
                ),
              ),
        if (sliderContents.isNotEmpty)
          Positioned(
            bottom: 0,
            child: Wrap(
              spacing: 1.w,
              children: sliderContents
                  .asMap()
                  .map((index, value) => MapEntry(
                        index,
                        Container(
                          width: (size.width - sliderContents.length) /
                              sliderContents.length,
                          height: getVerticalSize(4.71.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: currentIndex == index
                                  ? kPrimaryGradientColor
                                  : [
                                      ColorConstant.kColorD9D9D9
                                          .withOpacity(0.5),
                                      ColorConstant.kColorD9D9D9
                                          .withOpacity(0.5),
                                    ],
                            ),
                          ),
                        ),
                      ))
                  .values
                  .toList(),
            ),
          ),
        userInfo(),
        if (widget.isTutorialVisible ||
            (widget.car.postType != null &&
                widget.car.postType == CarPostType.premium.name))
          Positioned(
            top: 25,
            right: 20,
            child: CustomImageView(
              key: widget.premiumTutorialKey,
              svgPath: Assets.premium,
            ),
          ),
        Positioned(
          bottom: 25,
          right: 20,
          child: ShareButtonWithIcon(
            onTapShare: () {
              final make =
                  widget.car.manufacturer?.name?.toUpperCase() ?? shortAppName;
              final model = widget.car.model ?? appName;
              shareFeature(
                content: make +
                    nextLine +
                    model +
                    nextLine +
                    generateDeepLink('carId=${widget.car.id ?? ''}'),
                imgUrl: widget.car.uploadPhotos?.rightImages?.first ?? '',
              );
            },
          ),
        ),
        Positioned(
          bottom: 25,
          left: 25,
          child: LikeWithCount(likeCount: widget.car.analytics?.likes ?? 0),
        ),
        if (widget.isTutorialVisible || (widget.car.quickSale ?? false))
          QuickOfferBanner(key: widget.quickSaleTutorialKey),
      ],
    );
  }

  Widget userInfo() {
    return Positioned(
      top: 25,
      left: 20,
      child: Row(
        children: [
          Container(
            height: getSize(42),
            width: getSize(42),
            decoration: AppDecoration.kGradientBoxDecoration.copyWith(
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: (widget.car.ownerProfileImage != null &&
                        widget.car.ownerProfileImage!.isNotEmpty) ||
                    (widget.car.companyLogo != null &&
                        widget.car.companyLogo!.isNotEmpty)
                ? CustomImageView(
                    url: widget.car.userType == UserType.private.name
                        ? widget.car.ownerProfileImage
                        : widget.car.companyLogo,
                    radius: BorderRadius.circular(100.r),
                    height: getSize(42),
                    width: getSize(42),
                    fit: BoxFit.cover,
                  )
                : CustomImageView(
                    svgPath: widget.car.userType == UserType.private.name
                        ? Assets.privatePlaceholder
                        : Assets.dealerPlaceholder,
                    color: ColorConstant.kColorWhite,
                    margin: getMargin(all: 9),
                  ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.car.userType == UserType.private.name
                    ? widget.car.ownerUserName ?? shortAppName
                    : widget.car.companyName ?? shortAppName,
                style: AppTextStyle.oswaldTextStyle,
              ),
              if (widget.car.userType != UserType.private.name)
                Padding(
                  padding: getPadding(top: 2.h),
                  child: RatingBar.builder(
                    initialRating: widget.car.companyRating?.toDouble() ?? 0.0,
                    minRating: 1,
                    allowHalfRating: true,
                    itemSize: 14,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.w),
                    unratedColor: ColorConstant.kColorDBDBDB,
                    ignoreGestures: true,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: ColorConstant.kColorFFC32A,
                    ),
                    onRatingUpdate: (double value) {},
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
