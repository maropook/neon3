import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/controllers/pages/avatar_list_page_controller.dart';
import 'package:maropook_neon2/gen/assets.gen.dart';
import 'package:maropook_neon2/ui/components/src/universal_image.dart';
import 'package:uuid/uuid.dart';

class AvatarListPage extends ConsumerWidget {
  const AvatarListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarList =
        ref.watch(avatarListPageProvider.select((s) => s.avatarList));
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('アバター一覧'),
        actions: [
          IconButton(
              onPressed: () => context.go('/avatar/list/detail'),
              icon: const Icon(Icons.chevron_right)),
        ],
        leading: IconButton(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.chevron_left)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10), //4辺すべて同じ値の余白
        itemCount: avatarList.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        //指定した要素の数分を生成
        itemBuilder: (context, index) {
          return Container(
            color: Colors.white,
            child: avatarList.length != index
                ? GestureDetector(
                    onTap: () async {
                      context.go('/avatar/list/detail',
                          extra: avatarList[index]);
                    },
                    child: avatarList[index].activeImagePath.isNotEmpty
                        ? UniversalImage(
                            avatarList[index].activeImagePath,
                            fit: BoxFit.cover,
                          )
                        : UniversalImage(
                            Assets.images.faceSmile,
                            fit: BoxFit.cover,
                          ),
                  )
                : _buildShowModalButton(context),
          );
        },
      ),
    );
  }

  Widget _buildShowModalButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            isDismissible: true,
            builder: (BuildContext context) {
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
                  child: _buildAddAvatarModalBody());
            });
      },
      child: const Center(child: Icon(Icons.add, size: 80)),
    );
  }

  Widget _buildAddAvatarModalBody() {
    return Consumer(builder: (context, ref, _) {
      final activeImagePath =
          ref.watch(avatarListPageProvider.select((s) => s.newActiveImagePath));
      final stopImagePath =
          ref.watch(avatarListPageProvider.select((s) => s.newStopImagePath));
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                child: activeImagePath.isNotEmpty
                    ? SizedBox(
                        width: 150, child: Image.file(File(activeImagePath)))
                    : _buildAddIcon(isActive: true),
                onTap: () async {
                  await ref
                      .read(avatarListPageProvider.notifier)
                      .uploadNewImage(isActive: true);
                },
              ),
              GestureDetector(
                child: stopImagePath.isNotEmpty
                    ? SizedBox(
                        width: 150, child: Image.file(File(stopImagePath)))
                    : _buildAddIcon(isActive: false),
                onTap: () async {
                  await ref
                      .read(avatarListPageProvider.notifier)
                      .uploadNewImage(isActive: false);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 100, //横幅
              height: 100, //高さ
              child: ElevatedButton(
                onPressed: () async {
                  EasyLoading.show();
                  await ref
                      .read(avatarListPageProvider.notifier)
                      .addNewAvatar();
                  EasyLoading.dismiss();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
                child: const Text(
                  '追加',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAddIcon({required bool isActive}) {
    return Container(
      color: Colors.white,
      width: 170,
      height: 170,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                  width: 70,
                  height: 70,
                  child: UniversalImage(
                      isActive ? Assets.images.face : Assets.images.faceSmile)),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                  width: 70,
                  height: 70,
                  child: UniversalImage(Assets.images.photos)),
            ),
          ],
        ),
      ),
    );
  }
}
