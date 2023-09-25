import '../../core/configurations.dart';

class CommonSmoothIndicator extends StatelessWidget {
  const CommonSmoothIndicator({
    Key? key,
    required this.count,
    required this.currentIndex,
    this.activeDotColor = const LinearGradient(
      colors: [Color(0xffD9D9D9), Color(0xffD9D9D9)],
    ),
    this.dotColor = const Color(0xffD9D9D9),
    this.spacing = 8.0,
    this.dotWidth = 12.0,
    this.dotHeight = 12.0,
  }) : super(key: key);

  final int count;
  final int currentIndex;
  final Gradient activeDotColor;
  final Color dotColor;
  final double spacing;
  final double dotWidth;
  final double dotHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => _buildDot(
          index: index,
          isActive: index == currentIndex,
        ),
      ),
    );
  }

  Widget _buildDot({
    required int index,
    required bool isActive,
  }) {
    return Container(
      width: dotWidth,
      height: dotHeight,
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dotColor,
        gradient: isActive ? activeDotColor : null,
      ),
    );
  }
}
