import 'package:maropook_neon2/services/logger.dart';
import 'package:record/record.dart';

class AudioRecordService {
  AudioRecordService();

  final Record _audioRecorder = Record();
  Future<Amplitude> getAmplitude() async => await _audioRecorder.getAmplitude();

  Future<void> startAudioRecording(String audioPath) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start();
      }
    } catch (e) {
      Logger.logError(
          'recording_page_controller:start_audio_recording', e.toString());
    }
  }

  Future<String?> stopAudioRecording() async {
    return await _audioRecorder.stop();
  }

  void dispose() {
    _audioRecorder.dispose();
  }
}
