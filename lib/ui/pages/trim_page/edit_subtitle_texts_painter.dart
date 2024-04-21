import 'package:flutter/material.dart';

class EditSubtitleTextsPainter extends CustomPainter {
  EditSubtitleTextsPainter(
    this.startTimeInMilliseconds,
    this.endTimeInMilliseconds,
    this.videoDuration,
    this.timelineWidth,
    this.timelineHeight,
  );
  final Duration videoDuration;
  final double timelineWidth;
  final double startTimeInMilliseconds;
  final double endTimeInMilliseconds;
  final double timelineHeight;

  @override
  void paint(Canvas canvas, Size size) {
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
    timelinePaint.color = Colors.transparent;

    final Rect timelineInner = Rect.fromPoints(
        Offset(startRatio * timelineWidth, 0),
        Offset(endRatio * timelineWidth, endPos.dy));
    canvas.drawRect(timelineInner, timelinePaint);

    const double timelineEdgeWidth = 6.0;
    const double timelineEdgeHalfWidth = 3.0;
    final Paint timelineEdgePaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = timelineEdgeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final Path timelineEdge = Path();
    timelineEdge.moveTo(startPos.dx, 0 + timelineEdgeHalfWidth);
    timelineEdge.lineTo(startPos.dx, endPos.dy + timelineEdgeHalfWidth); //｜←
    timelineEdge.lineTo(
        endPos.dx + timelineEdgeWidth, endPos.dy + timelineEdgeHalfWidth); //_↓
    timelineEdge.lineTo(
        endPos.dx + timelineEdgeWidth, 0 + timelineEdgeHalfWidth); //｜→
    timelineEdge.lineTo(startPos.dx, 0 + timelineEdgeHalfWidth); //_↑
    canvas.drawPath(timelineEdge, timelineEdgePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
