import 'package:flutter_tts/flutter_tts.dart';
import 'package:neon3/services/file_service.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

class TextToSpeechService {
  FlutterTts flutterTts = FlutterTts();
  FileService fileService = FileService();

  int waitingWord = 0;
  int completeWord = 0;

  Future<void> generateSpeechFile(List<SubtitleText> texts) async {
    waitingWord = 0;
    completeWord = 0;
    for (int i = 0; i < texts.length; ++i) {
      if (texts[i].word == '') {
        continue;
      }
      ++waitingWord;
      final String filePath = 'speak_$i.caf';
      await _speakToFile(texts[i].word, filePath);
      texts[i].voiceFilePath = await fileService.getAppDocFilePath('filePath');
    }
    while (waitingWord != completeWord) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<void> _speakToFile(String word, String fileName) async {
    await flutterTts.setLanguage('ja-JP');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.synthesizeToFile(word, fileName);
    flutterTts.completionHandler = () {
      ++completeWord;
    };
  }
}
