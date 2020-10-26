import 'package:flutter/material.dart';
import 'package:subtitle_wrapper_package/models/style/subtitle_style.dart';
import 'package:subtitle_wrapper_package/models/subtitle.dart';
import 'package:subtitle_wrapper_package/models/subtitles.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:video_player/video_player.dart';

class SubtitleTextView extends StatefulWidget {
  final SubtitleController subtitleController;
  final VideoPlayerController videoPlayerController;
  final SubtitleStyle subtitleStyle;
  final double opacityBgText;

  const SubtitleTextView({
    Key key,
    @required this.subtitleController,
    this.videoPlayerController,
    this.subtitleStyle,
    this.opacityBgText = 0.7,
  }) : super(key: key);

  @override
  _SubtitleTextViewState createState() =>
      _SubtitleTextViewState(videoPlayerController);
}

class _SubtitleTextViewState extends State<SubtitleTextView> {
  final VideoPlayerController videoPlayerController;
  Subtitle subtitle;

  _SubtitleTextViewState(this.videoPlayerController);

  @override
  void initState() {
    videoPlayerController
        .addListener(() => _subtitleWatcher(videoPlayerController));

    _subtitleWatcher(videoPlayerController);
    super.initState();
  }

  _subtitleWatcher(VideoPlayerController videoPlayerController) async {
    Subtitles subtitles = await widget.subtitleController.getSubtitles();
    VideoPlayerValue latestValue = videoPlayerController.value;

    Duration videoPlayerPosition = latestValue.position;
    if (videoPlayerPosition != null) {
      subtitles.subtitles.forEach((Subtitle subtitleItem) {
        if (videoPlayerPosition.inMilliseconds >
                subtitleItem.startTime.inMilliseconds &&
            videoPlayerPosition.inMilliseconds <
                subtitleItem.endTime.inMilliseconds) {
          setState(() {
            subtitle = subtitleItem;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return subtitle != null
        ? Container(
            child: Stack(
              children: <Widget>[
                widget.subtitleStyle.hasBorder
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          color: Colors.black.withOpacity(widget.opacityBgText),
                          child: Text(
                            subtitle.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: widget.subtitleStyle.fontSize,
                              foreground: Paint()
                                ..style = widget.subtitleStyle.borderStyle.style
                                ..strokeWidth =
                                    widget.subtitleStyle.borderStyle.strokeWidth
                                ..color =
                                    widget.subtitleStyle.borderStyle.color,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        child: null,
                      ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    color: Colors.black.withOpacity(0.4),
                    child: Text(
                      subtitle.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: widget.subtitleStyle.fontSize,
                        color: widget.subtitleStyle.textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            child: null,
          );
  }
}
