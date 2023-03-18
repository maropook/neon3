import 'package:flutter/material.dart';
import 'package:maropook_neon2/gen/assets.gen.dart';

class Advertisement extends StatelessWidget {
  Advertisement(this.size);
  final double size;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.images.encoding.path,
      width: size,
      height: size,
    );
  }
}
