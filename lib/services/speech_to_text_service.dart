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

  final NeonSpeechToText _neonSpeechToTextPlugin = NeonSpeechToText();
  EncodeService encodeService = EncodeService();
  FileService fileService = FileService();
  List<SubtitleText> texts = <SubtitleText>[];

  Future<void> speechToTexts(
      {required List<String> inputFilePathList,
      required void Function() completeCallBack}) async {
    try {
      _neonSpeechToTextPlugin.setListener(
          addListenersFunction: (LinkedHashMap map) async {
        final String word = map.entries.first.value;
        texts.add(SubtitleText(startTime: 0.0, endTime: 0.0, word: word));
      });

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
        inputFilePathList: [voiceFilePath1, voiceFilePath2, voiceFilePath3],
        completeCallBack: () {
          debugPrint("[speechToTexts]:complete speech_to_text");
        },
        // inputFilePathList: inputFilePathList,
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<SubtitleText>> buildTexts(
      List<Map<String, double>> activeFrames, String audioFilePath) async {
    final List<String> trimmedAudioFilePathList =
        await trimAudio(activeFrames, audioFilePath);

    await speechToTexts(
        inputFilePathList: trimmedAudioFilePathList, completeCallBack: () {});

    return texts;
  }

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

  Future<List<String>> trimAudio(
      List<Map<String, double>> activeFrames, String audioFilePath) async {
    final List<String> trimmedAudioFilePathList = [];
    for (int index = 0; index < activeFrames.length; ++index) {
      final String trimmedAudioFilePath = await encodeService.trimAudio(
        audioFilePath,
        await fileService.getTempFilePath('audio_$index.m4a'),
        activeFrames[index]['startTime']!,
        activeFrames[index]['endTime']!,
      );
      trimmedAudioFilePathList.add(trimmedAudioFilePath);
    }
    return trimmedAudioFilePathList;
  }
}
