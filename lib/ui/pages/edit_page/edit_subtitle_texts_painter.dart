
import 'package:flutter/material.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

class EditSubtitleTextsPainter extends CustomPainter {
  EditSubtitleTextsPainter(
    this.sttText,
    this.videoDuration,
    this.timelineWidth,
    this.timelineHeight,
  );
  final SubtitleText sttText;
  final Duration videoDuration;
  final double timelineWidth;
  final double timelineHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final double startTimeInMilliseconds = sttText.startTime * 1000;
    final double endTimeInMilliseconds = sttText.endTime * 1000;

    final Offset startPos = Offset(
        startTimeInMilliseconds / videoDuration.inMilliseconds * timelineWidth,
        0);
    final Offset endPos = Offset(
        endTimeInMilliseconds / videoDuration.inMilliseconds * timelineWidth,
        timelineHeight);

    final double startRatio =
        startTimeInMilliseconds / videoDuration.inMilliseconds;
    double endRatio = endTimeInMilliseconds / videoDuration.inMilliseconds;
    if (endRatio > 1) {
      endRatio = 1;
    }

    final Paint timelinePaint = Paint();
    if (sttText.word.isEmpty) {
      timelinePaint.color = Colors.grey;
    } else {
      timelinePaint.color = const Color.fromARGB(255, 212, 212, 212);
    }
    final Rect timelineInner = Rect.fromPoints(
        Offset(startRatio * timelineWidth, 0),
        Offset(endRatio * timelineWidth, endPos.dy));
    canvas.drawRect(timelineInner, timelinePaint);

    const double timelineEdgeWidth = 6.0;
    final Paint timelineEdgePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = timelineEdgeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final Path timelineEdge = Path();
    timelineEdge.moveTo(startPos.dx + timelineEdgeWidth / 3, 0);
    timelineEdge.lineTo(startPos.dx + timelineEdgeWidth / 3, endPos.dy);
    timelineEdge.moveTo(endPos.dx + timelineEdgeWidth / 3, endPos.dy);
    timelineEdge.lineTo(endPos.dx + timelineEdgeWidth / 3, 0);
    canvas.drawPath(timelineEdge, timelineEdgePaint);

    final String timelineText =
        sttText.word.isEmpty ? '※空白のテキスト' : sttText.word;
    final TextPainter timelineTextPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            style: TextStyle(
              color: sttText.word.isEmpty
                  ? Colors.black.withOpacity(0.5)
                  : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            children: <TextSpan>[
              TextSpan(text: timelineText.replaceAll('\n', '')),
            ]));
    timelineTextPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    timelineTextPainter.paint(
        canvas, Offset(startPos.dx + 10, endPos.dy / 2 - 9));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
