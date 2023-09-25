import '../../core/configurations.dart';

class GradientDivider extends StatelessWidget {
  const GradientDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: kPrimaryGradientColor),
      ),
    );
  }
}

class CommonDivider extends StatelessWidget {
  const CommonDivider({
    super.key,
    this.color,
    this.indent,
    this.endIndent,
    this.thickness,
  });
  final double? indent;
  final double? endIndent;
  final Color? color;
  final double? thickness;
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? ColorConstant.kColorE6E6E6,
      indent: indent,
      endIndent: endIndent,
      thickness: thickness,
    );
  }
}
