import 'dart:io';

import 'package:video_player/video_player.dart';

import '../../core/configurations.dart';
import 'common_play_pause_button.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  static const String routeName = 'full_screen_video_player';
  const FullScreenVideoPlayer({
    super.key,
    this.networkVideoUrl,
    this.fileVideoUrl,
    this.assetVideoUrl,
  });

  final String? networkVideoUrl;
  final String? fileVideoUrl;
  final String? assetVideoUrl;

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoViewerState();
}

class _FullScreenVideoViewerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    if (widget.networkVideoUrl != null) {
      _videoPlayerController =
          VideoPlayerController.network(widget.networkVideoUrl!);
    } else if (widget.fileVideoUrl != null) {
      _videoPlayerController =
          VideoPlayerController.file(File(widget.fileVideoUrl!));
    } else if (widget.assetVideoUrl != null) {
      _videoPlayerController =
          VideoPlayerController.asset(widget.assetVideoUrl!);
    }
    _videoPlayerController.initialize().then(
      (value) {
        setState(() {
          _videoPlayerController.play();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              child: AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: _videoPlayerController.value.isInitialized
                    ? GestureDetector(
                        onTap: () {
                          if (_videoPlayerController.value.isPlaying) {
                            _videoPlayerController.pause();
                          }
                          setState(() {});
                        },
                        child: VideoPlayer(
                          _videoPlayerController,
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
            if (_videoPlayerController.value.isInitialized &&
                !_videoPlayerController.value.isPlaying)
              PlayPauseButton(
                size: getSize(50),
                isPlaying: _videoPlayerController.value.isPlaying,
                onTap: () {
                  if (_videoPlayerController.value.isPlaying) {
                    _videoPlayerController.pause();
                  } else {
                    _videoPlayerController.play();
                  }
                  setState(() {});
                },
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}
