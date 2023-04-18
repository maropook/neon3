import 'package:uuid/uuid.dart';

class ActiveFrame {
  ActiveFrame({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  String id;
  double startTime;
  double endTime;

  static List<Map<String, double>> listToMap(List<ActiveFrame> activeFrames) {
    List<Map<String, double>> list = [];
    for (ActiveFrame frame in activeFrames) {
      list.add({
        'startTime': frame.startTime,
        'endTime': frame.endTime,
      });
    }
    return list;
  }
}

final sampleActiveFrames = [
  ActiveFrame(
    startTime: 0.2,
    endTime: 1.0,
    id: const Uuid().v4(),
  ),
  ActiveFrame(
    startTime: 1.2,
    endTime: 1.6,
    id: const Uuid().v4(),
  ),
  ActiveFrame(
    startTime: 2.0,
    endTime: 2.2,
    id: const Uuid().v4(),
  ),
];
