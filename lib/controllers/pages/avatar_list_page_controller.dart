import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/models/src/avatar.dart';
import 'package:maropook_neon2/services/fire_avatar_service.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'avatar_list_page_controller.freezed.dart';

@freezed
class AvatarListPageState with _$AvatarListPageState {
  const factory AvatarListPageState({
    @Default(null) Uint8List? image,
    @Default([]) List<Avatar> avatarList,
  }) = _AvatarListPageState;
}

final avatarListPageProvider = StateNotifierProvider.autoDispose<
    AvatarListPageController,
    AvatarListPageState>((ref) => AvatarListPageController());

class AvatarListPageController extends StateNotifier<AvatarListPageState> {
  AvatarListPageController() : super(const AvatarListPageState()) {
    init();
  }

  Future<void> init() async {
    fetchAvatars();
  }

  final FireAvatarService fireAvatarService = FireAvatarService();
  final userID = FirebaseAuth.instance.currentUser?.uid ??
      'no_account'; //currentUser==nullのときは匿名認証すらしていない

  void uploadPic() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      File file = File(image!.path);
      print(image.path.split('/').last);

      String uploadName = 'image.png';
      final storageRef =
          FirebaseStorage.instance.ref().child('users/$userID/$uploadName');
      await storageRef.putFile(file);
    } catch (e) {
      Logger.logError('upload_pic', e.toString());
    }
  }

  void downloadPic() async {
    try {
      /// 参照の作成
      String downloadName = 'image.png';
      final storageRef =
          FirebaseStorage.instance.ref().child('users/$userID/$downloadName');

      // const oneMegabyte = 1024 * 1024;
      const oneMegabyte = 2048 * 2048;
      state = state.copyWith(image: await storageRef.getData(oneMegabyte));
    } catch (e) {
      Logger.logError('download_pic', e.toString());
    }
  }

  void deletePic() async {
    try {
      String deleteName = 'image.png';
      final storageRef =
          FirebaseStorage.instance.ref().child('users/$userID/$deleteName');
      await storageRef.delete();
      state = state.copyWith(image: null);
    } catch (e) {
      Logger.logError('delete_pic', e.toString());
    }
  }

  Future<void> addNewAvatar({required Avatar avatar}) async {
    await fireAvatarService.addNewAvatar(avatar: avatar);

    state = state.copyWith(
      avatarList: [avatar, ...state.avatarList],
    );
  }

  Future<void> deleteAvatar({required String id}) async {
    await fireAvatarService.deleteAvatar(id: id);
    final List<Avatar> avatarList =
        state.avatarList.where((avatar) => avatar.id != id).toList();

    state = state.copyWith(avatarList: avatarList);
  }

  Future<void> updateAvatar(
      {required String id, required Avatar newAvatar}) async {
    await fireAvatarService.deleteAvatar(id: id);

    final List<Avatar> avatarList = state.avatarList
        .map((avatar) => avatar.id == newAvatar.id ? newAvatar : avatar)
        .toList();

    state = state.copyWith(avatarList: avatarList);
  }

  Future<List<Avatar>> fetchAvatars() async {
    List<Avatar> avatarList = await fireAvatarService.fetchAvatars();
    state = state.copyWith(avatarList: avatarList);

    return avatarList;
  }
}
