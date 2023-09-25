import '../../core/configurations.dart';

class CustomSocialMediaButton extends StatelessWidget {
  const CustomSocialMediaButton(
      {super.key, required this.asset, required this.onTap});
  final String asset;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: CustomImageView(svgPath: asset),
      ),
    );
  }
}
