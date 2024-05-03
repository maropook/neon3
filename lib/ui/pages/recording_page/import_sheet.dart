import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/import_sheet_controller.dart';
import 'package:neon3/gen/assets.gen.dart';

Future<ImportSheetArg?> showImportSheet(
  BuildContext context,
  ImportSheetArg importSheetArg,
) {
  return showModalBottomSheet<ImportSheetArg?>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return _ImportSheet(importSheetArg);
      });
}

class _ImportSheet extends StatelessWidget {
  _ImportSheet(this.importSheetArg, {Key? key}) : super(key: key);
  ImportSheetArg importSheetArg;
  @override
  Widget build(BuildContext context) {
    return ProviderScope(overrides: [
      importSheetProvider.overrideWith((ref) {
        return ImportSheetController(importSheetProviderArg: importSheetArg);
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
    return Consumer(builder: (context, ref, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            child: Container(
                color: Colors.white,
                width: 170,
                height: 170,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SvgPicture.asset(Assets.images.movie,
                      width: 90, height: 90),
                )),
            onTap: () async {
              final videoPath = await ref
                  .read(importSheetProvider.notifier)
                  .getPickedVideoFilePath();
              if (videoPath.isEmpty) return;
              Navigator.of(context).pop(ImportSheetArg(
                  recordingType: RecordingType.video,
                  importedFilePath: videoPath));
            },
          ),
          GestureDetector(
            child: Container(
                color: Colors.white,
                width: 170,
                height: 170,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SvgPicture.asset(Assets.images.photo,
                      width: 90, height: 90),
                )),
            onTap: () async {
              final imagePath = await ref
                  .read(importSheetProvider.notifier)
                  .getPickedImageFilePath();
              if (imagePath.isEmpty) return;

              Navigator.of(context).pop(ImportSheetArg(
                  recordingType: RecordingType.image,
                  importedFilePath: imagePath));
            },
          ),
        ],
      );
    });
  }
}
