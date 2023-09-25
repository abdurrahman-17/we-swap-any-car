import 'package:carousel_slider/carousel_slider.dart';

import '../../../core/configurations.dart';
import '../../../model/slider_content_model.dart';
import '../../../service/deep_link_service.dart';
import '../../common_widgets/common_quick_offer_banner.dart';
import '../../common_widgets/common_share_widget.dart';
import '../../common_widgets/full_screen_image_viewer.dart';
import '../../common_widgets/full_screen_video_player.dart';
import '../../../model/car_model/car_model.dart';
import '../../common_widgets/video_player_widget.dart';

class MyCarProfileContentSlider extends StatefulWidget {
  const MyCarProfileContentSlider({
    Key? key,
    this.aspectRatio = 1,
    this.widgetWidth,
    required this.car,
    this.onTapSlider,
    this.isContinueAddCar = false,
  }) : super(key: key);
  final CarModel? car;
  final double aspectRatio;
  final double? widgetWidth;
  final bool isContinueAddCar;
  final VoidCallback? onTapSlider;
  @override
  State<MyCarProfileContentSlider> createState() =>
      _MyCarProfileContentSliderState();
}

class _MyCarProfileContentSliderState extends State<MyCarProfileContentSlider> {
  final CarouselController _carouselController = CarouselController();

  late int currentIndex = 0;
  List<SliderContentModel> sliderContents = [];

  void autoMergeAllImgsAndVideo(CarModel? car) {
    sliderContents.clear();

    for (String item in car?.uploadPhotos?.rightImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car?.uploadPhotos?.leftImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car?.uploadPhotos?.frontImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car?.uploadPhotos?.rearImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car?.uploadPhotos?.interiorImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car?.uploadPhotos?.bootSpaceImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car?.uploadPhotos?.adittionalImages ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.image,
        url: item,
      ));
    }

    for (String item in car?.uploadPhotos?.videos ?? []) {
      sliderContents.add(SliderContentModel(
        type: AttachmentType.video,
        url: item,
      ));
    }
  }

  @override
  void initState() {
    autoMergeAllImgsAndVideo(widget.car);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return sliderContents.isNotEmpty
        ? myCarContentSlider()
        : AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Container(
              color: ColorConstant.kColor7C7C7C,
              child: CustomImageView(
                svgPath: Assets.imageNotFoundSvg,
                color: ColorConstant.kColorWhite,
              ),
            ),
          );
  }

  Widget myCarContentSlider() {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onTapSlider ??
              () {
                if (!widget.isContinueAddCar) {
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
                        'networkVideoUrl': sliderContents[currentIndex].url,
                      },
                    );
                  }
                }
              },
          child: CarouselSlider.builder(
            itemCount: sliderContents.length,
            carouselController: _carouselController,
            options: CarouselOptions(
              aspectRatio: widget.aspectRatio,
              viewportFraction: 1,
              pauseAutoPlayInFiniteScroll: true,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              autoPlay: !widget.isContinueAddCar,
              onPageChanged: (index, reason) =>
                  setState(() => currentIndex = index),
              autoPlayInterval: const Duration(seconds: 3),
            ),
            itemBuilder: (context, index, pageViewIndex) =>
                widget.isContinueAddCar
                    ? ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          ColorConstant.gray400,
                          BlendMode.saturation,
                        ),
                        child: contentView(),
                      )
                    : contentView(),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Wrap(
            spacing: 1.w,
            children: sliderContents
                .asMap()
                .map((index, value) => MapEntry(
                      index,
                      Container(
                        width: ((widget.widgetWidth ?? size.width) -
                                sliderContents.length) /
                            sliderContents.length,
                        height: getVerticalSize(4.71.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: widget.isContinueAddCar
                                ? [
                                    ColorConstant.kColorD9D9D9.withOpacity(0.5),
                                    ColorConstant.kColorD9D9D9.withOpacity(0.5),
                                  ]
                                : currentIndex == index
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
        if (!widget.isContinueAddCar)
          Positioned(
            bottom: 25,
            right: 20,
            child: ShareButtonWithIcon(
              onTapShare: () {
                final make = widget.car?.manufacturer?.name?.toUpperCase() ??
                    shortAppName;
                final model = widget.car?.model ?? appName;
                shareFeature(
                  content: make +
                      nextLine +
                      model +
                      nextLine +
                      generateDeepLink('carId=${widget.car?.id ?? ''}'),
                  imgUrl: widget.car?.uploadPhotos?.rightImages?.first ?? '',
                );
              },
            ),
          ),
        if (widget.car?.postType != null &&
            widget.car!.postType == convertEnumToString(CarPostType.premium))
          Positioned(
            top: 25,
            right: 20,
            child: CustomImageView(
              svgPath: Assets.premium,
              height: getVerticalSize(30.h),
            ),
          ),
        if (widget.car?.quickSale ?? false) const QuickOfferBanner(),
      ],
    );
  }

  Widget contentView() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: sliderContents[currentIndex].type == AttachmentType.image
              ? CustomImageView(
                  url: sliderContents[currentIndex].url,
                  fit: BoxFit.contain,
                )
              : VideoPlayerWidget(
                  videoUrl: sliderContents[currentIndex].url,
                  aspectRatio: widget.aspectRatio,
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
    );
  }
}
