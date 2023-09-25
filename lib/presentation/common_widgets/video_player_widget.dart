import 'dart:io';

import 'package:video_player/video_player.dart';

import '../../core/configurations.dart';
import 'common_loader.dart';
import 'common_play_pause_button.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    this.videoUrl,
    this.videoFilePath,
    this.playAction,
    this.removeAction,
    this.aspectRatio,
    this.height,
    this.width,
    this.borderRadius,
  });

  final String? videoUrl;
  final String? videoFilePath;
  final VoidCallback? playAction;
  final VoidCallback? removeAction;
  final double? aspectRatio;
  final double? height;
  final double? width;
  final BorderRadiusGeometry? borderRadius;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    if (widget.videoFilePath != null) {
      _videoController = VideoPlayerController.file(File(widget.videoFilePath!))
        ..initialize().then((_) {
          setState(() {});
        });
    } else if (widget.videoUrl != null) {
      _videoController = VideoPlayerController.network(widget.videoUrl!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _videoController.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              widget.aspectRatio != null
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: ClipRRect(
                        borderRadius:
                            widget.borderRadius ?? BorderRadius.circular(0),
                        child: VideoPlayer(_videoController),
                      ))
                  : FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        height: widget.height ?? getVerticalSize(150),
                        width: widget.width ?? getHorizontalSize(200),
                        child: ClipRRect(
                          borderRadius:
                              widget.borderRadius ?? BorderRadius.circular(0),
                          child: VideoPlayer(_videoController),
                        ),
                      ),
                    ),

              //PLAY/PAUSE VIDEO
              PlayPauseButton(onTap: widget.playAction),

              ///REMOVE BUTTON
              if (widget.removeAction != null)
                Positioned(
                  top: widget.height != null ? (widget.height! * 0.12) : 12.h,
                  right: widget.width != null ? (widget.width! * 0.10) : 12.w,
                  child: GestureDetector(
                    onTap: widget.removeAction,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ),
            ],
          )
        : shimmerLoader(
            Container(
              height: widget.height ?? getVerticalSize(150),
              width: widget.width ?? getHorizontalSize(200),
              decoration: BoxDecoration(
                color: ColorConstant.kColorWhite,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
              ),
            ),
          );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
}
