import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maropook_neon2/gen/assets.gen.dart';
import 'package:maropook_neon2/services/encode_service.dart';
import 'package:maropook_neon2/services/file_service.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:neon_speech_to_text/neon_speech_to_text.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

class SpeechToTextService {
  SpeechToTextService();

  final List<SubtitleText> subtitleTexts = [
    SubtitleText(
      startTime: 1.0,
      endTime: 2.0,
      word: "word1",
      // voiceFilePath: voiceFilePath1
    ),
    SubtitleText(
      startTime: 2.0,
      endTime: 3.0,
      word: "word2",
      // voiceFilePath: voiceFilePath2
    ),
  ];

  final NeonSpeechToText _neonSpeechToTextPlugin = NeonSpeechToText();
  EncodeService encodeService = EncodeService();
  FileService fileService = FileService();
  List<SubtitleText> texts = <SubtitleText>[];

  Future<void> buildTexts(
      List<Map<String, double>> activeFrames,
      String audioFilePath,
      void Function(List<SubtitleText> texts) completeCallBack) async {
    final List<String> trimmedAudioFilePathList =
        await trimAudio(activeFrames, audioFilePath);
    // if (trimmedAudioFilePathList.isEmpty) {
    //   completeCallBack([]);
    //   return;
    // }

    //TODO:一旦activeFramesとsubtitleTextはサンプルの値にする
    if (true) {
      completeCallBack(subtitleTexts);
      return;
    }
    //TODO:一旦activeFramesとsubtitleTextはサンプルの値にする

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
      List<Map<String, double>> activeFrames, String audioFilePath) async {
    final List<String> trimmedAudioFilePathList = [];

    final String voiceFilePath1 = (await fileService.saveFile(
            inputFilePath: Assets.audio.voiceFile1,
            outputFilePath: "audio1.mp3"))
        .path;

    for (int index = 0; index < activeFrames.length; ++index) {
      final String trimmedAudioFilePath = await encodeService.trimAudio(
        audioFilePath,
        // voiceFilePath1,
        await fileService.getTempFilePath('audio_$index.m4a'),
        activeFrames[index]['startTime']!,
        activeFrames[index]['endTime']!,
      );
      trimmedAudioFilePathList.add(trimmedAudioFilePath);
    }
    return trimmedAudioFilePathList;
  }

  Future<void> speechToTexts({
    required List<Map<String, double>> activeFrames,
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
            startTime: activeFrames[index]['startTime']!,
            endTime: activeFrames[index]['endTime']!,
            word: speechTextsList[index]));
        // Logger.log(
        //     "speechToTexts_complete_call_back", speechTextsList[index]);
        completeCallBack(texts);
      }
    }

    try {
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
        // inputFilePathList: [voiceFilePath1, voiceFilePath2, voiceFilePath3],
        inputFilePathList: inputFilePathList, //TODO
        completeCallBack: setSubtitleTexts,
        addListenersFunction: (LinkedHashMap map) async {},
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}
