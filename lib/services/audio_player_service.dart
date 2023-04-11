import 'package:audioplayers/audioplayers.dart';
import 'package:neon3/services/logger.dart';

class AudioPlayerService {
  AudioPlayerService(this.audioFilePath) {
    init(audioFilePath);
  }

  String audioFilePath;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool get audioFilePathIsEmpty => audioFilePath.isEmpty;

  Future<void> init(String audioFilePath) async {
    try {
      if (audioFilePathIsEmpty) return;
      await _audioPlayer.setSourceDeviceFile(audioFilePath);
    } catch (e) {
      Logger.logError('audio_player_service init', e.toString());
    }
  }

  Future<void> play(String audioFilePath) async {
    try {
      if (audioFilePathIsEmpty) return;
      await _audioPlayer.play(UrlSource(audioFilePath));
    } catch (e) {
      Logger.logError('audio_player_service play', e.toString());
    }
  }

  Future<void> seek({required Duration duration}) async {
    try {
      if (audioFilePathIsEmpty) return;
      await _audioPlayer.seek(duration);
    } catch (e) {
      Logger.logError('audio_player_service', e.toString());
    }
  }

  Future<void> pause() async {
    try {
      if (audioFilePathIsEmpty) return;
      await _audioPlayer.pause();
    } catch (e) {
      Logger.logError('audio_player_service', e.toString());
    }
  }

  Future<void> dispose() async {
    try {
      if (audioFilePathIsEmpty) return;
      await _audioPlayer.dispose();
    } catch (e) {
      Logger.logError('audio_player_service', e.toString());
    }
  }
}
