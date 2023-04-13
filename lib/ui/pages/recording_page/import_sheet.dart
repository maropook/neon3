import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/controllers/pages/import_sheet_controller.dart';
import 'package:neon3/gen/assets.gen.dart';

Future<String?> showImportSheet(
  BuildContext context,
) {
  return showModalBottomSheet<String?>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return const _ImportSheet();
      });
}

class _ImportSheet extends StatelessWidget {
  const _ImportSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildModal(context);
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
            onTap: () async {},
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
            onTap: () async {},
          ),
        ],
      );
    });
  }
}
