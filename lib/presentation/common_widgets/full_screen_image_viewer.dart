import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../core/configurations.dart';

class FullScreenImageViewer extends StatefulWidget {
  static const String routeName = 'full_screen_image_viewer';
  const FullScreenImageViewer({
    super.key,
    required this.isMultiImage,
    this.initialIndex,
    this.imageFile,
    this.svgImages = const [],
    this.imageList = const [],
  });

  final bool isMultiImage;
  final int? initialIndex;
  final dynamic imageFile;
  final List<String> svgImages;
  final List<dynamic> imageList;

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  final PhotoViewController _controller = PhotoViewController();
  late PageController pageController;
  var _quarterTurns = 0;
  List<dynamic> tempList = [];
  int currentIndex = 0;

  @override
  void initState() {
    currentIndex = widget.initialIndex ?? 0;
    pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _rotateRight90Degrees() {
    _quarterTurns = _quarterTurns == 3 ? 0 : _quarterTurns + 1;
    _controller.rotation = math.pi / 2 * _quarterTurns;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _rotateRight90Degrees,
          backgroundColor: Colors.white38,
          child: Icon(
            Icons.rotate_left_rounded,
            color: ColorConstant.kColorWhite,
          ),
        ),
        body: Stack(
          children: [
            Container(
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height,
              ),
              child: getChildWidget(),
            ),
            Positioned(
              right: 10.w,
              top: 10.h,
              child: IconButton(
                icon: CustomImageView(
                  svgPath: Assets.removeImg,
                  height: getSize(50),
                  width: getSize(50),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            if (tempList.isNotEmpty)
              Positioned(
                top: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: tempList
                      .asMap()
                      .map(
                        (index, value) => MapEntry(
                          index,
                          Container(
                            width: MediaQuery.of(context).size.width /
                                tempList.length,
                            height: 4.71,
                            margin: const EdgeInsets.symmetric(horizontal: 0.9),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: currentIndex == index
                                    ? kPrimaryGradientColor
                                    : [
                                        const Color(0xffD9D9D9)
                                            .withOpacity(0.6),
                                        const Color(0xffD9D9D9)
                                            .withOpacity(0.6),
                                      ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget getChildWidget() {
    if (!widget.isMultiImage) {
      ///file image
      if (widget.imageFile is File) {
        return _buildPhotoView(
            imageProvider: FileImage(widget.imageFile as File));
      }

      ///network image
      else if (widget.imageFile is String &&
          "${widget.imageFile}".contains("http")) {
        return _buildPhotoView(
            imageProvider: NetworkImage(widget.imageFile.toString()));
      }

      ///svg image
      else if (widget.imageFile is String &&
          "${widget.imageFile}".contains(".svg")) {
        return PhotoView.customChild(
          controller: _controller,
          heroAttributes: PhotoViewHeroAttributes(tag: "${widget.imageFile}"),
          child: SizedBox(
            child: SvgPicture.asset(
              widget.imageFile.toString(),
            ),
          ),
        );
      }

      ///assets
      else if (widget.imageFile is String &&
          "${widget.imageFile}".contains("assets")) {
        return _buildPhotoView(
            imageProvider: AssetImage(widget.imageFile.toString()));
      }
    }

    ///image list
    else {
      if (widget.imageList.isNotEmpty) {
        return _buildMultiImage(list: widget.imageList, builder: _buildItem);
      } else if (widget.svgImages.isNotEmpty) {
        tempList = widget.svgImages;
        return _buildMultiImage(list: widget.svgImages, builder: _svgBuildItem);
      }
    }
    return const SizedBox();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  PhotoViewGallery _buildMultiImage({
    required List<dynamic> list,
    required PhotoViewGalleryPageOptions Function(BuildContext, int)? builder,
  }) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: builder,
      itemCount: list.length,
      onPageChanged: onPageChanged,
      pageController: pageController,
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      controller: _controller,
      imageProvider: getImageProvider(index),
      initialScale: PhotoViewComputedScale.contained,
      heroAttributes: PhotoViewHeroAttributes(tag: "$index"),
    );
  }

  PhotoViewGalleryPageOptions _svgBuildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions.customChild(
      child: SvgPicture.asset(
        widget.svgImages[index],
      ),
      controller: _controller,
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: widget.svgImages[index]),
    );
  }

  ImageProvider<Object>? getImageProvider(int index) {
    if (widget.imageList[index] is File) {
      return FileImage(widget.imageList[index] as File);
    } else if (widget.imageList[index] is String &&
        widget.imageList[index].toString().contains("http")) {
      return NetworkImage(widget.imageList[index].toString());
    } else if (widget.imageList[index] is String &&
        widget.imageList[index].toString().contains("assets")) {
      return AssetImage(widget.imageList[index].toString());
    } else {
      return FileImage(File(widget.imageList[index].toString()));
    }
  }

  PhotoView _buildPhotoView({required ImageProvider<Object> imageProvider}) {
    return PhotoView(
      controller: _controller,
      enableRotation: true,
      imageProvider: imageProvider,
    );
  }
}
