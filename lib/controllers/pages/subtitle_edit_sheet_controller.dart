import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

part 'subtitle_edit_sheet_controller.freezed.dart';

enum EditorDragType { left, center, right }

@freezed
class SubtitleEditSheetState with _$SubtitleEditSheetState {
  const factory SubtitleEditSheetState({
    @Default(null) SubtitleText? subtitleText,
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
}
