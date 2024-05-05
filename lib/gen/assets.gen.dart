/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsAudioGen {
  const $AssetsAudioGen();

  /// File path: assets/audio/music_file.mp3
  String get musicFile => 'assets/audio/music_file.mp3';

  /// File path: assets/audio/voice_file_1.mp3
  String get voiceFile1 => 'assets/audio/voice_file_1.mp3';

  /// File path: assets/audio/voice_file_2.mp3
  String get voiceFile2 => 'assets/audio/voice_file_2.mp3';

  /// File path: assets/audio/voice_file_3.mp3
  String get voiceFile3 => 'assets/audio/voice_file_3.mp3';

  /// List of all assets
  List<String> get values => [musicFile, voiceFile1, voiceFile2, voiceFile3];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/add_bgm_icon.svg
  String get addBgmIcon => 'assets/images/add_bgm_icon.svg';

  /// File path: assets/images/artificial_voice_icon.svg
  String get artificialVoiceIcon => 'assets/images/artificial_voice_icon.svg';

  /// File path: assets/images/avatar_active.png
  AssetGenImage get avatarActive =>
      const AssetGenImage('assets/images/avatar_active.png');

  /// File path: assets/images/avatar_import_face.svg
  String get avatarImportFace => 'assets/images/avatar_import_face.svg';

  /// File path: assets/images/avatar_import_face_smile.svg
  String get avatarImportFaceSmile =>
      'assets/images/avatar_import_face_smile.svg';

  /// File path: assets/images/avatar_stop.png
  AssetGenImage get avatarStop =>
      const AssetGenImage('assets/images/avatar_stop.png');

  /// File path: assets/images/background_sea.png
  AssetGenImage get backgroundSea =>
      const AssetGenImage('assets/images/background_sea.png');

  /// File path: assets/images/change_avatar_icon.svg
  String get changeAvatarIcon => 'assets/images/change_avatar_icon.svg';

  /// File path: assets/images/color_wheel.svg
  String get colorWheel => 'assets/images/color_wheel.svg';

  /// File path: assets/images/encoding.png
  AssetGenImage get encoding =>
      const AssetGenImage('assets/images/encoding.png');

  /// File path: assets/images/face.svg
  String get face => 'assets/images/face.svg';

  /// File path: assets/images/face_smile.svg
  String get faceSmile => 'assets/images/face_smile.svg';

  /// File path: assets/images/icon_ios.png
  AssetGenImage get iconIos =>
      const AssetGenImage('assets/images/icon_ios.png');

  $AssetsImagesIconsGen get icons => const $AssetsImagesIconsGen();

  /// File path: assets/images/movie.svg
  String get movie => 'assets/images/movie.svg';

  /// File path: assets/images/note.svg
  String get note => 'assets/images/note.svg';

  /// File path: assets/images/pencil.svg
  String get pencil => 'assets/images/pencil.svg';

  /// File path: assets/images/photo.svg
  String get photo => 'assets/images/photo.svg';

  /// File path: assets/images/photos.svg
  String get photos => 'assets/images/photos.svg';

  /// File path: assets/images/test_background.png
  AssetGenImage get testBackground =>
      const AssetGenImage('assets/images/test_background.png');

  /// File path: assets/images/test_woman.png
  AssetGenImage get testWoman =>
      const AssetGenImage('assets/images/test_woman.png');

  /// File path: assets/images/text_edit_icon.svg
  String get textEditIcon => 'assets/images/text_edit_icon.svg';

  /// List of all assets
  List<dynamic> get values => [
        addBgmIcon,
        artificialVoiceIcon,
        avatarActive,
        avatarImportFace,
        avatarImportFaceSmile,
        avatarStop,
        backgroundSea,
        changeAvatarIcon,
        colorWheel,
        encoding,
        face,
        faceSmile,
        iconIos,
        movie,
        note,
        pencil,
        photo,
        photos,
        testBackground,
        testWoman,
        textEditIcon
      ];
}

class $AssetsMoviesGen {
  const $AssetsMoviesGen();

  /// File path: assets/movies/sample.mp4
  String get sample => 'assets/movies/sample.mp4';

  /// List of all assets
  List<String> get values => [sample];
}

class $AssetsImagesIconsGen {
  const $AssetsImagesIconsGen();

  /// File path: assets/images/icons/artificial_voice_icon.svg
  String get artificialVoiceIcon =>
      'assets/images/icons/artificial_voice_icon.svg';

  /// File path: assets/images/icons/avatar_face_icon.svg
  String get avatarFaceIcon => 'assets/images/icons/avatar_face_icon.svg';

  /// File path: assets/images/icons/check_avatar_green.svg
  String get checkAvatarGreen => 'assets/images/icons/check_avatar_green.svg';

  /// File path: assets/images/icons/complete_check.svg
  String get completeCheck => 'assets/images/icons/complete_check.svg';

  /// File path: assets/images/icons/movie.svg
  String get movie => 'assets/images/icons/movie.svg';

  /// File path: assets/images/icons/photo_single.svg
  String get photoSingle => 'assets/images/icons/photo_single.svg';

  /// File path: assets/images/icons/subtitle_add_icon.svg
  String get subtitleAddIcon => 'assets/images/icons/subtitle_add_icon.svg';

  /// File path: assets/images/icons/subtitle_edit_icon .svg
  String get subtitleEditIcon => 'assets/images/icons/subtitle_edit_icon .svg';

  /// List of all assets
  List<String> get values => [
        artificialVoiceIcon,
        avatarFaceIcon,
        checkAvatarGreen,
        completeCheck,
        movie,
        photoSingle,
        subtitleAddIcon,
        subtitleEditIcon
      ];
}

class Assets {
  Assets._();

  static const $AssetsAudioGen audio = $AssetsAudioGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsMoviesGen movies = $AssetsMoviesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
