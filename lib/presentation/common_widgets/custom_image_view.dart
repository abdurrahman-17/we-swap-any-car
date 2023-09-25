import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/configurations.dart';

class CustomImageView extends StatelessWidget {
  const CustomImageView({
    super.key,
    this.url,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.errorAsset = Assets.imageNotFound,
    this.onLongPress,
    this.colorBlendMode,
  });

  ///[url] is required parameter for fetching network image
  final String? url;

  ///[imagePath] is required parameter for showing png,jpg,etc image
  final String? imagePath;

  ///[svgPath] is required parameter for showing svg image
  final String? svgPath;

  ///[file] is required parameter for fetching image file
  final File? file;

  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String errorAsset;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;
  final BlendMode? colorBlendMode;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  Widget _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  Widget _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (svgPath != null && svgPath!.isNotEmpty) {
      return SizedBox(
        height: height,
        width: width,
        child: SvgPicture.asset(
          svgPath!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.contain,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        ),
      );
    } else if (file != null && file!.path.isNotEmpty) {
      return Image.file(
        file!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        colorBlendMode: colorBlendMode,
        cacheHeight: 200,
        cacheWidth: 200,
      );
    } else if (url != null && url!.isNotEmpty) {
      String imageUrl = url!;
      if (url!.startsWith(s3BaseUrl)) {
        imageUrl =
            "${url!.replaceAll(s3BaseUrl, cloudFront)}?format=webp&width=500";
      }

      return CachedNetworkImage(
        height: height,
        width: width,
        fit: fit,
        imageUrl: imageUrl,
        color: color,
        colorBlendMode: colorBlendMode,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade200,
          direction: ShimmerDirection.btt,
          child: Container(color: ColorConstant.kColorWhite),
        ),
        errorWidget: (context, url, error) => Image.asset(
          errorAsset,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
        ),
      );
    } else if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        colorBlendMode: colorBlendMode,
      );
    }
    //no image
    return Image.asset(
      errorAsset,
      height: height ?? 50,
      width: width ?? 50,
      fit: fit ?? BoxFit.cover,
    );
  }
}
