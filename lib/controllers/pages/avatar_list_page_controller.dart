import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/models/src/avatar.dart';
import 'package:maropook_neon2/services/fire_avatar_service.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

part 'avatar_list_page_controller.freezed.dart';

@freezed
class AvatarListPageState with _$AvatarListPageState {
  const factory AvatarListPageState({
    @Default(null) Avatar? newAvatar,
    @Default("") String newActiveImagePath,
    @Default("") String newStopImagePath,
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
    await fetchAvatars();
  }

  final FireAvatarService fireAvatarService = FireAvatarService();
  final uid = FirebaseAuth.instance.currentUser?.uid ??
      'no_account'; //currentUser==nullのときは匿名認証すらしていない

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Uuid uuid = const Uuid();

  Future<void> uploadNewImage({required bool isActive}) async {
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile == null) return;
    final croppedImageFile = await ImageCropper().cropImage(
      sourcePath: pickedImageFile.path,
      compressQuality: 80,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (croppedImageFile == null) return;

    if (isActive) {
      state = state.copyWith(newActiveImagePath: croppedImageFile.path);
      return;
    }
    state = state.copyWith(newStopImagePath: croppedImageFile.path);
  }

  Future<Map<String, String>> uploadImageOfFiles({
    required String id,
  }) async {
    if (state.newActiveImagePath.isEmpty || state.newStopImagePath.isEmpty) {
      Logger.log('upload_image_of_files', 'image_path_is_empty');
      return {};
    }
    final Reference activeRef = storage.ref("users/$uid/$id/activeAvatar.jpg");
    final Reference stopRef = storage.ref("users/$uid/$id/stopAvatar.jpg");
    try {
      await activeRef.putFile(File(state.newActiveImagePath));
      await stopRef.putFile(File(state.newStopImagePath));
    } catch (e) {
      Logger.logError('upload_image', e.toString());
    }
    return {
      'activeImageUrl': await activeRef.getDownloadURL(),
      'stopImageUrl': await activeRef.getDownloadURL(),
    };
  }

  Future<void> deleteImage({required String id}) async {
    try {
      final Reference activeRef =
          storage.ref("users/$uid/$id/activeAvatar.jpg");
      final Reference stopRef = storage.ref("users/$uid/$id/stopAvatar.jpg");
      await activeRef.delete();
      await stopRef.delete();
    } catch (e) {
      Logger.logError('delete_pic', e.toString());
    }
  }

  Future<List<Avatar>> fetchAvatars() async {
    List<Avatar> avatarList = await fireAvatarService.fetchAvatars();
    state = state.copyWith(avatarList: avatarList);

    return avatarList;
  }

  Future<void> addNewAvatar() async {
    final newAvatarId = uuid.v4();

    final imageUrlMap = await uploadImageOfFiles(id: newAvatarId);
    final newAvatar = Avatar(
      activeImagePath: imageUrlMap['activeImageUrl'] ?? '',
      stopImagePath: imageUrlMap['stopImageUrl'] ?? '',
      id: newAvatarId,
      created: DateTime.now(),
      updated: DateTime.now(),
    );
    await fireAvatarService.addNewAvatar(avatar: newAvatar);

    state = state.copyWith(
      avatarList: [newAvatar, ...state.avatarList],
    );
  }

  Future<void> updateAvatar(
      {required String id, required Avatar newAvatar}) async {
    await fireAvatarService.deleteAvatar(id: id);

    final List<Avatar> avatarList = state.avatarList
        .map((avatar) => avatar.id == newAvatar.id ? newAvatar : avatar)
        .toList();

    state = state.copyWith(avatarList: avatarList);
  }

  Future<void> deleteAvatar({required String id}) async {
    await fireAvatarService.deleteAvatar(id: id);
    final List<Avatar> avatarList =
        state.avatarList.where((avatar) => avatar.id != id).toList();
    await deleteImage(id: id);
    state = state.copyWith(avatarList: avatarList);
  }
}
