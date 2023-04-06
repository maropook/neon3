import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maropook_neon2/gen/assets.gen.dart';
import 'package:maropook_neon2/models/src/avatar.dart';
import 'package:maropook_neon2/services/download_image_service.dart';
import 'package:maropook_neon2/services/file_service.dart';
import 'package:maropook_neon2/services/logger.dart';
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

  Future<String> mergeAudio() async {
    NeonVoiceFileList neonVoiceFileList = NeonVoiceFileList();
    String voiceFilePath1 = (await fileService.saveFile(
            inputFilePath: Assets.audio.voiceFile1,
            outputFilePath: "audio1.mp3"))
        .path;
    String voiceFilePath2 = (await fileService.saveFile(
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

  Future<String> encode({
    required String videoFilePath,
    required String audioFilePath,
    required List<Map<String, double>> activeFrames,
    required Avatar avatar,
    required void Function(dynamic value) addListenersFunction,
  }) async {
    EasyLoading.show();
    final String mergedAudioFilePath = await mergeAudio();
    final String trimmedAudioFilePath = await trimAudio(mergedAudioFilePath,
        await fileService.getTempFilePath('trim-audio.m4a'), 0.0, 40.0);
    final NeonVideoEncoder neonVideoEncoder = NeonVideoEncoder();
    final DownloadImageService downloadImageService = DownloadImageService();

    String voiceFilePath1 = (await fileService.saveFile(
            inputFilePath: Assets.audio.voiceFile1,
            outputFilePath: "audio1.mp3"))
        .path;
    String voiceFilePath2 = (await fileService.saveFile(
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
    final musicFilePath = (await fileService.saveFile(
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
