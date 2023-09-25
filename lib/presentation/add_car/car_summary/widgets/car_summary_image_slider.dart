import 'package:carousel_slider/carousel_slider.dart';

import '../../../../model/slider_content_model.dart';
import '../../../../core/configurations.dart';
import '../../../../model/car_model/car_model.dart';
import '../../../common_widgets/full_screen_image_viewer.dart';
import '../../../common_widgets/full_screen_video_player.dart';
import '../../../common_widgets/video_player_widget.dart';

class CarSummaryImageSlider extends StatefulWidget {
  const CarSummaryImageSlider({Key? key, required this.car}) : super(key: key);
  final CarModel? car;
  @override
  State<CarSummaryImageSlider> createState() => _CarSummaryImageSliderState();
}

class _CarSummaryImageSliderState extends State<CarSummaryImageSlider> {
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
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (sliderContents[currentIndex].type == AttachmentType.image) {
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
          },
          child: CarouselSlider.builder(
            itemCount: sliderContents.length,
            carouselController: _carouselController,
            options: CarouselOptions(
              aspectRatio: 1.8,
              viewportFraction: 1,
              autoPlay: true,
              pauseAutoPlayInFiniteScroll: true,
              onPageChanged: (index, reason) =>
                  setState(() => currentIndex = index),
              autoPlayInterval: const Duration(seconds: 3),
            ),
            itemBuilder: (BuildContext context, int index, int pageViewIndex) =>
                Container(
              decoration: BoxDecoration(
                color: ColorConstant.kColorWhite,
                borderRadius: BorderRadius.circular(21.r),
              ),
              child: AspectRatio(
                aspectRatio: 1.8,
                child: sliderContents[index].type == AttachmentType.image
                    ? CustomImageView(
                        url: sliderContents[index].url,
                        fit: BoxFit.contain,
                      )
                    : VideoPlayerWidget(
                        videoUrl: sliderContents[index].url,
                        aspectRatio: 1.8,
                      ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Wrap(
            spacing: 1.w,
            children: sliderContents
                .asMap()
                .map((index, value) => MapEntry(
                      index,
                      Container(
                        width: (size.width - (100 - sliderContents.length)) /
                            sliderContents.length,
                        height: 4.71.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21.r),
                          gradient: LinearGradient(
                            colors: currentIndex == index
                                ? kPrimaryGradientColor
                                : [
                                    const Color(0xffD9D9D9).withOpacity(0.5),
                                    const Color(0xffD9D9D9).withOpacity(0.5),
                                  ],
                          ),
                        ),
                      ),
                    ))
                .values
                .toList(),
          ),
        ),
      ],
    );
  }
}
