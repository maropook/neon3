import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:neon3/controllers/pages/artificial_voice_edit_sheet_controller.dart';
import 'package:neon3/gen/assets.gen.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/download_image_service.dart';
import 'package:neon3/services/file_service.dart';
import 'package:neon3/services/logger.dart';
import 'package:neon_video_encoder/audio_setting.dart';
import 'package:neon_video_encoder/avatar_animation.dart';
import 'package:neon_video_encoder/neon_video_encoder.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

class EncodeService {
  EncodeService();

  final FileService fileService = FileService();

  Future<String> imageToVideo() async {
    final NeonVideoEncoder neonVideoEncoder = NeonVideoEncoder();

    String imagePath = (await fileService.saveFile(
            inputFilePath: Assets.images.testBackground.path,
            outputFilePath: "test.png"))
        .path;

    final String videoFilePath = await neonVideoEncoder.imageToVideo(
      sourceImagePath: imagePath,
      videoDuration: const Duration(seconds: 30),
      outputFilePath: await fileService.getTempFilePath('image-to-movie.mp4'),
    );
    return videoFilePath;
  }

  Future<String> mergeAudio(List<SubtitleText> subtitleTexts) async {
    NeonVoiceFileList neonVoiceFileList = NeonVoiceFileList();
    final NeonVideoEncoder neonVideoEncoder = NeonVideoEncoder();

    for (SubtitleText text in subtitleTexts) {
      if (text.voiceFilePath == null) {
        continue;
      }
      neonVoiceFileList.add(
          voiceFilePath: text.voiceFilePath!, startTime: text.startTime);
    }

    double progressRate = 0;
    neonVideoEncoder.getProgressStatus.listen((dynamic value) {
      progressRate = value as double;
      Logger.log('encode', 'mergeAudio  =>  $progressRate %');
    });

    final String mergedAudioFilePath = await neonVideoEncoder.mergeAudio(
        outputFilePath: await fileService.getTempFilePath('merge-audio.m4a'),
        voiceFileList: neonVoiceFileList);

    return mergedAudioFilePath;
  }

  Future<String> trimAudio(String audioFilePath, String outPutFilePath,
      double startTime, double endTime) async {
    final NeonVideoEncoder neonVideoEncoder = NeonVideoEncoder();

    neonVideoEncoder.getProgressStatus.listen((dynamic value) {
      Logger.log('sttService', 'trimAudio');
    });
    final String trimmedAudioFilePath = await neonVideoEncoder.trimAudio(
      inputFilePath: audioFilePath,
      outputFilePath:
          outPutFilePath, // await getTempFilePath('trim-audio.m4a'),
      startTime: startTime, //0.0,
      endTime: endTime, //40.0,
    );
    return trimmedAudioFilePath;
  }

  //TODO:現在、recording_pageから渡されたaudio_fileとactive_framesが仮の値になっている
  Future<String> encode({
    required String videoFilePath,
    required String audioFilePath,
    required String musicFilePath,
    required String ttsAudioFilePath,
    required List<Map<String, double>> activeFrames,
    required List<SubtitleText> subtitleTexts,
    required Avatar avatar,
    required void Function(dynamic value) addListenersFunction,
  }) async {
    EasyLoading.show();
    final NeonVideoEncoder neonVideoEncoder = NeonVideoEncoder();
    final DownloadImageService downloadImageService = DownloadImageService();

    //SubtitleText
    //TODO:人工音声を追加できるようになったら変更する
    for (int i = 0; i < subtitleTexts.length; ++i) {
      subtitleTexts[i].word = 'word${i}';
    }

    // AvatarAnimation
    AvatarAnimation avatarAnimation = AvatarAnimation(
        activeImagePath: await downloadImageService.downloadImage(
            downloadUrl: avatar.activeImageUrl),
        stopImagePath: await downloadImageService.downloadImage(
            downloadUrl: avatar.stopImageUrl),
        imageSizeRatio: 1.0,
        activeFrameList: activeFrames,
        avatarSizeRatio: 0.5,
        positionX: 0.5);

    //AudioSetting
    //isMutedDefaultAudio→ true:artificial voiceFileListから使われる false:original→1秒から5秒まで字幕が表示されます
    // isMutedDefaultAudio:trueの場合は、voiceFileにある音声たちより、動画が短かったらExport failed: Operation Stoppedになる

    AudioType audioType =
        ttsAudioFilePath.isEmpty ? AudioType.original : AudioType.artificial;
    AudioSetting audioSetting = AudioSetting(
        defaultAudioPath: audioType == AudioType.original ? audioFilePath : '',
        isMutedDefaultAudio: audioType == AudioType.original ? false : true,
        backgroundAudioPath: musicFilePath.isNotEmpty ? musicFilePath : null,
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
    EasyLoading.dismiss();
    final encodedVideoFilePath = await neonVideoEncoder.encode(
      encodeArgs: encodeArgs,
      // inputFilePath: await imageToVideo(),
      inputFilePath: videoFilePath,
      outputFilePath: await fileService.getTempFilePath('video-with-audio.mp4'),
    );

    return encodedVideoFilePath;
  }
}
