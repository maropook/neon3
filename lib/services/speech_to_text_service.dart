import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neon3/gen/assets.gen.dart';
import 'package:neon3/models/src/active_frame.dart';
import 'package:neon3/services/encode_service.dart';
import 'package:neon3/services/file_service.dart';
import 'package:neon3/services/logger.dart';
import 'package:neon_speech_to_text/neon_speech_to_text.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

class SpeechToTextService {
  SpeechToTextService();

  final NeonSpeechToText _neonSpeechToTextPlugin = NeonSpeechToText();
  EncodeService encodeService = EncodeService();
  FileService fileService = FileService();
  List<SubtitleText> texts = <SubtitleText>[];

  Future<void> buildTexts(List<ActiveFrame> activeFrames, String audioFilePath,
      void Function(List<SubtitleText> texts) completeCallBack) async {
    final List<String> trimmedAudioFilePathList =
        await trimAudio(activeFrames, audioFilePath);

    if (trimmedAudioFilePathList.isEmpty) {
      Logger.log("build_texts", "trimmedAudioFilePathList.isEmpty");
      completeCallBack([]);
      return;
    }

    if (trimmedAudioFilePathList.length != activeFrames.length) {
      Logger.logError("build_texts",
          "trimmedAudioFilePathList.length != activeFrames.length");
      completeCallBack([]);
      return;
    }
    await speechToTexts(
        //音声がなかったらここでbadStateNoElementになる
        activeFrames: activeFrames,
        inputFilePathList: trimmedAudioFilePathList,
        completeCallBack: completeCallBack);

    //ここでtextsは返せない。completeCallBackでtextが作られるが作られるが、それを察知して自分でtextを取りに行くしかない
  }

  Future<List<String>> trimAudio(
      List<ActiveFrame> activeFrames, String audioFilePath) async {
    final List<String> trimmedAudioFilePathList = [];

    for (int index = 0; index < activeFrames.length; ++index) {
      final String trimmedAudioFilePath = await encodeService.trimAudio(
        audioFilePath,
        await fileService.getTempFilePath('audio_$index.m4a'),
        activeFrames[index].startTime,
        activeFrames[index].endTime,
      );
      trimmedAudioFilePathList.add(trimmedAudioFilePath);
    }
    return trimmedAudioFilePathList;
  }

  Future<void> speechToTexts({
    required List<ActiveFrame> activeFrames,
    required List<String> inputFilePathList,
    required void Function(List<SubtitleText> texts) completeCallBack,
  }) async {
    void setSubtitleTexts(List<String> speechTextsList) {
      Logger.log("speechToTexts_complete_call_back", "complete");

      if (activeFrames.length != speechTextsList.length) {
        Logger.logError(
            "build_texts", "speechTextsList.length != activeFrames.length");
        completeCallBack([]);
        return;
      }
      for (int index = 0; index < activeFrames.length; ++index) {
        //completeしてからじゃなくて、addListenersCallBackでtexts.addしたほうがいいのか？
        texts.add(SubtitleText(
            id: activeFrames[index].id,
            startTime: activeFrames[index].startTime,
            endTime: activeFrames[index].endTime,
            word: 'ハロー')); //TODO:!!いまは人工音声のため
        // word: speechTextsList[index])); //TODO:!!いまは人工音声のため
        // Logger.log(
        //     "speechToTexts_complete_call_back", speechTextsList[index]);
        completeCallBack(texts);
      }
    }

    try {
      //TODO:テスト値
      final String voiceFilePath1 = (await fileService.saveFile(
              inputFilePath: Assets.audio.voiceFile1,
              outputFilePath: "audio1.mp3"))
          .path;
      final String voiceFilePath2 = (await fileService.saveFile(
              inputFilePath: Assets.audio.voiceFile2,
              outputFilePath: "audio2.mp3"))
          .path;
      final String voiceFilePath3 = (await fileService.saveFile(
              inputFilePath: Assets.audio.voiceFile3,
              outputFilePath: "audio3.mp3"))
          .path;

      await _neonSpeechToTextPlugin.speechToTexts(
        // inputFilePathList: [voiceFilePath1, voiceFilePath2, voiceFilePath3],//TODO:テスト値
        inputFilePathList: inputFilePathList,
        completeCallBack: setSubtitleTexts,
        addListenersFunction: (LinkedHashMap map) async {},
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}
