import '../../../core/configurations.dart';

class AvatarVariationItemWidget extends StatelessWidget {
  const AvatarVariationItemWidget({
    super.key,
    this.url,
    this.selectedImageUrl,
    this.isLoading = false,
    this.onTapVariation,
  });

  final String? url;
  final String? selectedImageUrl;
  final bool isLoading;
  final GestureTapCallback? onTapVariation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapVariation,
      child: Container(
        height: getSize(84),
        width: getSize(84),
        decoration: url != null
            ? BoxDecoration(
                gradient: LinearGradient(colors: kPrimaryGradientColor),
                borderRadius: BorderRadius.circular(100.r))
            : BoxDecoration(
                color: ColorConstant.kColorE4E4E4,
                borderRadius: BorderRadius.circular(100.r)),
        child: isLoading
            ? Container(
                height: getSize(84),
                width: getSize(84),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: LinearProgressIndicator(
                    color: Colors.grey.shade200,
                    backgroundColor: Colors.grey.shade100,
                  ),
                ),
              )
            : url != null
                ? Container(
                    decoration: BoxDecoration(
                        border: url == selectedImageUrl
                            ? Border.all(
                                color: Colors.amber,
                                width: 2.5,
                              )
                            : null,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))),
                    child: CustomImageView(
                      url: url,
                      height: getSize(84),
                      width: getSize(84),
                      fit: BoxFit.fill,
                      radius: const BorderRadius.all(Radius.circular(100)),
                    ),
                  )
                : null,
      ),
    );
  }
}
