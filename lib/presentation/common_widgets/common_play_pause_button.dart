import '../../core/configurations.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({
    super.key,
    this.isPlaying = false,
    this.onTap,
    this.size,
  });
  final bool isPlaying;
  final GestureTapCallback? onTap;
  final double? size;
  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            svgPath: Assets.blurVideoPlayerBg,
            height: getSize(widget.size ?? 35),
            width: getSize(widget.size ?? 35),
          ),
          CustomImageView(
            svgPath: Assets.videoPlayerGradientBg,
            height: getSize(widget.size ?? 35) / 1.3,
            width: getSize(widget.size ?? 35) / 1.3,
          ),
          Icon(
            widget.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: getSize(widget.size ?? 35) / 1.9,
            color: ColorConstant.kColorWhite,
          ),
        ],
      ),
    );
  }
}
