import 'dart:io';

import 'package:flutter/material.dart';
import 'package:neon3/services/logger.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerService {
  VideoPlayerService({required String videoFilePath})
      : _videoFilePath = videoFilePath;

  final String _videoFilePath;
  VideoPlayerController? _videoPlayerController;
  bool get isPlaying => _videoPlayerController?.value.isPlaying ?? false;
  double get currentSeconds =>
      0.001 * (_videoPlayerController?.value.position.inMilliseconds ?? 0);

  Future<void> init({required void Function() addListenersFunction}) async {
    try {
      _videoPlayerController = VideoPlayerController.file(File(_videoFilePath));
      await _videoPlayerController!.initialize();
      await _videoPlayerController!.setLooping(true);
      addListener(addListenersFunction);

      await play();
    } catch (e) {
      Logger.logError('video_player_service:init', e.toString());
    }
  }

  void addListener(void Function() function) {
    _videoPlayerController!.addListener(() {
      function();
    });
  }

  Widget buildVideoPlayer() {
    return _videoPlayerController != null
        ? AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController!),
          )
        : const SizedBox();
  }

  Future<void> play() async {
    await _videoPlayerController!.play();
  }

  Future<void> pause() async {
    await _videoPlayerController!.pause();
  }

  void dispose() {
    _videoPlayerController?.dispose();
  }
}
