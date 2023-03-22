import 'dart:io';

import 'package:flutter/services.dart';
import 'package:maropook_neon2/gen/assets.gen.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:neon_video_encoder/audio_setting.dart';
import 'package:neon_video_encoder/avatar_animation.dart';
import 'package:neon_video_encoder/neon_video_encoder.dart';
import 'package:neon_video_encoder/subtitle_text.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class EncodeService {
  EncodeService();
  late String audioPath;
  late String mergedAudioPath;

  Future<String> imageToVideo() async {
    final NeonVideoEncoder neonVideoEncoder = NeonVideoEncoder();

    String imagePath = (await saveFile(
            inputFilePath: Assets.images.testBackground.path,
            outputFilePath: "test.png"))
        .path;

    final String videoFilePath = await neonVideoEncoder.imageToVideo(
      sourceImagePath: imagePath,
      videoDuration: const Duration(seconds: 30),
      outputFilePath: await getTempFilePath('image-to-movie.mp4'),
    );
    return videoFilePath;
  }

  Future<void> mergeAudio() async {
    NeonVoiceFileList neonVoiceFileList = NeonVoiceFileList();
    String voiceFilePath1 = (await saveFile(
            inputFilePath: Assets.audio.voiceFile1,
            outputFilePath: "audio1.mp3"))
        .path;
    String voiceFilePath2 = (await saveFile(
            inputFilePath: Assets.audio.voiceFile2,
            outputFilePath: "audio2.mp3"))
        .path;

    neonVoiceFileList.add(voiceFilePath: voiceFilePath1, startTime: 1.0);

    neonVoiceFileList.add(voiceFilePath: voiceFilePath2, startTime: 3.0);

    final NeonVideoEncoder neonVideoEncoder = NeonVideoEncoder();

    double progressRate = 0;

    neonVideoEncoder.getProgressStatus.listen((dynamic value) {
      progressRate = value as double;
      Logger.log('encode', 'mergeAudio  =>  $progressRate %');
    });

    final String ttsAudioFilePath = await neonVideoEncoder.mergeAudio(
        outputFilePath: await getTempFilePath('merge-audio.m4a'),
        voiceFileList: neonVoiceFileList);

    mergedAudioPath = ttsAudioFilePath;
  }

  Future<void> trimAudio() async {
    final NeonVideoEncoder neonVideoEncoder = NeonVideoEncoder();

    neonVideoEncoder.getProgressStatus.listen((dynamic value) {
      Logger.log('sttService', 'trimAudio');
    });
    audioPath = await neonVideoEncoder.trimAudio(
      inputFilePath: mergedAudioPath,
      outputFilePath: await getTempFilePath('trim-audio.m4a'),
      startTime: 0.0,
      endTime: 40.0,
    );
  }

  Future<String> encode({
    required String videoFilePath,
    required String audioFilePath,
    required void Function(dynamic value) addListenersFunction,
  }) async {
    await mergeAudio();
    await trimAudio();
    final NeonVideoEncoder neonVideoEncoder = NeonVideoEncoder();

    String voiceFilePath1 = (await saveFile(
            inputFilePath: Assets.audio.voiceFile1,
            outputFilePath: "audio1.mp3"))
        .path;
    String voiceFilePath2 = (await saveFile(
            inputFilePath: Assets.audio.voiceFile2,
            outputFilePath: "audio2.mp3"))
        .path;

    //SubtitleText
    final List<SubtitleText> subtitleTexts = [
      SubtitleText(
          startTime: 1.0,
          endTime: 2.0,
          word: "word1",
          voiceFilePath: voiceFilePath1),
      SubtitleText(
          startTime: 2.0,
          endTime: 3.0,
          word: "word2",
          voiceFilePath: voiceFilePath2),
    ];

    // AvatarAnimation
    final String activeImagePath = (await saveFile(
            inputFilePath: Assets.images.avatarActive.path,
            outputFilePath: 'active_avatar.png'))
        .path;
    final String stopImagePath = (await saveFile(
            inputFilePath: Assets.images.avatarStop.path,
            outputFilePath: 'stop_avatar.png'))
        .path;

    List<Map<String, double>> activeFrames = [
      {"startTime": 1.3, "endTime": 2.0},
      {"startTime": 3.0, "endTime": 4.5}
    ];

    AvatarAnimation avatarAnimation = AvatarAnimation(
        activeImagePath: activeImagePath,
        stopImagePath: stopImagePath,
        imageSizeRatio: 1.0,
        activeFrameList: activeFrames,
        avatarSizeRatio: 0.5,
        positionX: 0.5);

    //AudioSetting
    final musicFilePath = (await saveFile(
            inputFilePath: Assets.audio.musicFile,
            outputFilePath: 'music_file.mp3'))
        .path;

    AudioSetting audioSetting = AudioSetting(
        // defaultAudioPath: _audioFilePath,
        // isMutedDefaultAudio:
        //     true, //この場合は、voiceFileにある音声たちより、動画が短かったらExport failed: Operation Stoppedになる

        defaultAudioPath: audioFilePath,
        isMutedDefaultAudio: false,

        //true:artificial voiceFileListから使われる false:original→1秒から5秒まで字幕が表示されます
        backgroundAudioPath: musicFilePath,
        backgroundAudioVolume: 0.1);

    // Encode
    EncodeArgs encodeArgs = EncodeArgs(
        subtitleTexts: subtitleTexts,
        avatarAnimation: avatarAnimation,
        audioSetting: audioSetting);

    neonVideoEncoder.getProgressStatus.listen((dynamic value) {
      addListenersFunction(value);
      Logger.log('encode', 'encode =>  $value %');
    });

    final encodedVideoFilePath = await neonVideoEncoder.encode(
      encodeArgs: encodeArgs,
      // inputFilePath: await imageToVideo(),
      inputFilePath: videoFilePath,
      outputFilePath: await getTempFilePath('video-with-audio.mp4'),
    );

    return encodedVideoFilePath;
  }
}

Future<String> getTempFilePath(String fileName) async {
  final Directory documentsDirectory = await getTemporaryDirectory();
  return '${documentsDirectory.path}/$fileName';
}

Future<File> saveFile({
  required String inputFilePath,
  required String outputFilePath,
}) async {
  final ByteData assetByteData = await rootBundle.load(inputFilePath);

  final List<int> byteList = assetByteData.buffer
      .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);

  final String fullOutputFilePath =
      join((await getApplicationDocumentsDirectory()).path, outputFilePath);
  final File fileFuture = await File(fullOutputFilePath)
      .writeAsBytes(byteList, mode: FileMode.writeOnly, flush: false);

  return fileFuture;
}
