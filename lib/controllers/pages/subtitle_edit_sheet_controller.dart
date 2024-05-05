import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/services/subtitle_font_service.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

part 'subtitle_edit_sheet_controller.freezed.dart';

enum EditorDragType { left, center, right }

@freezed
class SubtitleEditSheetState with _$SubtitleEditSheetState {
  const factory SubtitleEditSheetState({
    @Default(null) SubtitleText? subtitleText,
    @Default(Colors.white) Color customFontColor,
    @Default(Colors.white) Color customBorderColor,
  }) = _SubtitleEditSheetState;
}

class SubtitleEditSheetProviderArg {
  SubtitleEditSheetProviderArg({
    required this.subtitleText,
  });

  final SubtitleText subtitleText;
}

final subtitleEditSheetProvider = StateNotifierProvider.autoDispose<
    SubtitleEditSheetController, SubtitleEditSheetState>((ref) {
  return throw UnimplementedError();
});

class SubtitleEditSheetController
    extends StateNotifier<SubtitleEditSheetState> {
  SubtitleEditSheetController(
      {required SubtitleEditSheetProviderArg subtitleEditSheetProviderArg})
      : _subtitleEditSheetProviderArg = subtitleEditSheetProviderArg,
        super(const SubtitleEditSheetState()) {
    init();
  }

  final SubtitleEditSheetProviderArg _subtitleEditSheetProviderArg;
  Future<void> init() async {
    subtitleTextEditController.text =
        _subtitleEditSheetProviderArg.subtitleText.word;
    state = state.copyWith(
        subtitleText: _subtitleEditSheetProviderArg.subtitleText);
  }

  FocusNode focusNode = FocusNode();
  TextEditingController subtitleTextEditController =
      TextEditingController(text: '');

  void onChangeText(String text) {
    final subtitleText = state.subtitleText;
    subtitleText?.word = text;
    state = state.copyWith(subtitleText: subtitleText);
  }

  void onChangeFontName(String fontName) {
    final subtitleText = state.subtitleText;
    subtitleText?.fontName = fontName;
    state = state.copyWith(subtitleText: subtitleText);
  }

  void onChangeFonColor(String fontColorCode, bool isBorder) {
    final subtitleText = state.subtitleText;
    if (!isBorder) {
      subtitleText?.fontColorCode = fontColorCode;
    } else {
      subtitleText?.borderColorCode = fontColorCode;
    }
    state = state.copyWith(subtitleText: subtitleText);
  }

  void onChangeCustomFonColor(Color fontColor, bool isBorder) {
    if (!isBorder) {
      state = state.copyWith(customFontColor: fontColor);
      state = state.copyWith(
          customBorderColor:
              fontColor); //strokeを設定するときはこれは要らない、今はstrokeも内部の色もどっちも編集されるようにしている
    } else {
      state = state.copyWith(customBorderColor: fontColor);
    }
    onChangeFonColor(fontColor.toHexTriplet(), isBorder);
  }

  String colorsToColorCode(String color) {
    switch (color) {
      case 'white':
        return Colors.white.toHexTriplet();
      case 'blue':
        return Colors.blue.toHexTriplet();
      case 'black':
        return Colors.black.toHexTriplet();
      case 'red':
        return Colors.red.toHexTriplet();
      case 'green':
        return Colors.green.toHexTriplet();
      case 'yellow':
        return Colors.yellow.toHexTriplet();
      case 'customFontColor':
        return state.customFontColor.toHexTriplet();
      case 'customBorderColor':
        return state.customBorderColor.toHexTriplet();
    }
    return '#000000ff';
  }
}
