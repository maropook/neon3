import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class ProgressBar extends StatelessWidget {
  ProgressBar(this.progressRate);
  double progressRate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: FAProgressBar(
        currentValue: progressRate,
        size: 50,
        borderRadius:
            BorderRadiusGeometry.lerp(BorderRadius.zero, BorderRadius.zero, 0),
        border: Border.all(color: Colors.white, width: 10),
        backgroundColor: Colors.black,
        progressColor: Colors.white,
      ),
    );
  }
}
