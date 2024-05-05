import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/config/styles.dart';
import 'package:neon3/controllers/pages/subtitle_edit_sheet_controller.dart';
import 'package:neon3/gen/assets.gen.dart';
import 'package:neon3/services/subtitle_font_service.dart';
import 'package:neon3/ui/pages/edit_page/subtitle_custom_color_sheet.dart';
import 'package:neon3/ui/pages/page_router.dart';
import 'package:neon_video_encoder/subtitle_text.dart';

class EditArgsFromSubtitleEditSheet {
  EditArgsFromSubtitleEditSheet(
      {required this.subtitleText, required this.isDelete});
  SubtitleText? subtitleText;
  bool isDelete;
}

Future<EditArgsFromSubtitleEditSheet?> showSubtitleEditSheet(
  BuildContext context,
  SubtitleEditPageArgs subtitleEditPageArgs,
) {
  return showModalBottomSheet<EditArgsFromSubtitleEditSheet?>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return _SubtitleEditSheet(
          subtitleEditPageArgs: subtitleEditPageArgs,
        );
      });
}

class _SubtitleEditSheet extends StatelessWidget {
  const _SubtitleEditSheet({required this.subtitleEditPageArgs, super.key});

  final SubtitleEditPageArgs subtitleEditPageArgs;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(overrides: [
      subtitleEditSheetProvider.overrideWith((ref) {
        final subtitleEditSheetProviderArg = SubtitleEditSheetProviderArg(
          subtitleText: subtitleEditPageArgs.subtitleText,
        );
        return SubtitleEditSheetController(
            subtitleEditSheetProviderArg: subtitleEditSheetProviderArg);
      })
    ], child: _buildModal(context));
  }

  Widget _buildModal(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.longestSide - 64,
        margin: const EdgeInsets.only(top: 64),
        decoration: const BoxDecoration(
          color: Color.fromARGB(109, 0, 0, 0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _buildBody());
  }

  Widget _buildBody() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      _buildCompleteButton(),
      _buildSubtitleFonts(),
      _buildSubtitleWordColors(isBorder: false),
      _buildSubtitleWordColors(isBorder: true), //TODO:Border
      _buildSubtitleTextField()
    ]);
  }

  Widget _buildCompleteButton() {
    return Consumer(builder: (context, ref, _) {
      final subtitleText =
          ref.watch(subtitleEditSheetProvider.select((s) => s.subtitleText));
      final focusNode = ref.watch(subtitleEditSheetProvider.notifier).focusNode;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            child: const Text('完了',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
            onPressed: () {
              final FocusScopeNode currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                focusNode.unfocus();
              }
              Navigator.of(context).pop(EditArgsFromSubtitleEditSheet(
                  subtitleText: subtitleText, isDelete: false));
            },
          ),
          TextButton(
            child: const Text('削除',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
            onPressed: () {
              final FocusScopeNode currentScope = FocusScope.of(context);
              if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                focusNode.unfocus();
              }
              Navigator.of(context).pop(EditArgsFromSubtitleEditSheet(
                  subtitleText: subtitleText, isDelete: true));
            },
          ),
        ],
      );
    });
  }

  Widget _buildSubtitleTextField() {
    return Consumer(builder: (context, ref, _) {
      final subtitleTextEditController = ref
          .watch(subtitleEditSheetProvider.notifier)
          .subtitleTextEditController;
      final focusNode = ref.watch(subtitleEditSheetProvider.notifier).focusNode;

      return Column(
        children: [
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            obscureText: false,
            autofocus: true,
            focusNode: focusNode,
            onChanged:
                ref.read(subtitleEditSheetProvider.notifier).onChangeText,
            controller: subtitleTextEditController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Styles.secondaryColor.withOpacity(0),
              border: InputBorder.none,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSubtitleFonts() {
    return Consumer(builder: (context, ref, _) {
      final subtitleFontService = SubtitleFontService();
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < subtitleFontService.fontList.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildSubtitleFont(i),
            ),
        ],
      );
    });
  }

  Widget _buildSubtitleWordColors({required bool isBorder}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          !isBorder ? '　文字　' : 'ふちどり',
          style: const TextStyle(color: Colors.white),
        ),
        for (int i = 0; i < SubtitlesFontColor.values.length; i++)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: _buildSubtitleWordColor(i, isBorder),
          ),
      ],
    );
  }

  Widget _buildSubtitleWordColor(int index, bool isBorder) {
    return Consumer(builder: (context, ref, _) {
      final bool isCustom =
          SubtitlesFontColor.values[index].name.contains('custom');
      String colorCode = ref
          .read(subtitleEditSheetProvider.notifier)
          .colorsToColorCode(SubtitlesFontColor.values[index].name);
      if (isCustom) {
        final customColor = ref.watch(subtitleEditSheetProvider
            .select((s) => isBorder ? s.customBorderColor : s.customFontColor));
        colorCode = customColor.toHexTriplet();
      }
      final fontColorCode = ref.watch(subtitleEditSheetProvider
          .select((s) => s.subtitleText?.fontColorCode));
      final borderColorCode = ref.watch(subtitleEditSheetProvider
          .select((s) => s.subtitleText?.borderColorCode));
      final isSameColor =
          isBorder ? colorCode == borderColorCode : colorCode == fontColorCode;

      return GestureDetector(
        onTap: () async {
          if (!isCustom) {
            ref
                .read(subtitleEditSheetProvider.notifier)
                .onChangeFonColor(colorCode, isBorder);
            return;
          }

          final previousColor = ref.read(subtitleEditSheetProvider.select(
              (s) => isBorder ? s.customBorderColor : s.customFontColor));
          final newColor = await showColorPicker(context, previousColor);
          if (newColor == null) return;
          ref
              .read(subtitleEditSheetProvider.notifier)
              .onChangeCustomFonColor(newColor, isBorder);
        },
        child: Container(
          width: isSameColor ? 35 : 30,
          height: isSameColor ? 35 : 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white),
              color: HexColor.fromHex(colorCode)
              // border: fontColorBorders[i],
              ),
          child: isCustom
              ? SvgPicture.asset(
                  Assets.images.colorWheel,
                  width: isSameColor ? 35 : 30,
                  height: isSameColor ? 35 : 30,
                )
              : null,
        ),
      );
    });
  }

  Widget _buildSubtitleFont(int index) {
    return Consumer(builder: (context, ref, _) {
      final subtitleFontService = SubtitleFontService();
      final font = ref.watch(
          subtitleEditSheetProvider.select((s) => s.subtitleText?.fontName));
      final fontName = subtitleFontService.fontList[index].name;
      return GestureDetector(
        onTap: () {
          ref
              .read(subtitleEditSheetProvider.notifier)
              .onChangeFontName(fontName);
        },
        child: Text(
          'あ夏',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: fontName == 'systemFont' ? null : fontName,
              fontSize: 15,
              color: font == fontName
                  ? Colors.white
                  : Colors.white.withOpacity(0.5)),
        ),
      );
    });
  }
}
