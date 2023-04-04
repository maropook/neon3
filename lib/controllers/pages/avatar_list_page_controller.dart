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

  void clearNewImagePath() {
    state = state.copyWith(newActiveImagePath: '', newStopImagePath: '');
  }

  Future<void> setNewImage({required bool isActive}) async {
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

  Future<String> uploadImage({
    required String id,
    required String imagePath,
    required String imageName,
  }) async {
    if (imagePath.isEmpty) {
      Logger.log('upload_image', 'image_path_is_empty');
      return '';
    }
    final Reference storageRef = storage.ref("users/$uid/$id/$imageName.jpg");
    try {
      await storageRef.putFile(File(imagePath));
    } catch (e) {
      Logger.logError('upload_image', e.toString());
    }
    return await storageRef.getDownloadURL();
  }

  Future<void> deleteImage({
    required String id,
    required String imageName,
  }) async {
    try {
      final Reference storageRef = storage.ref("users/$uid/$id/$imageName.jpg");
      await storageRef.delete();
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

    final newAvatar = Avatar(
      activeImageUrl: await uploadImage(
          id: newAvatarId,
          imageName: 'activeAvatar',
          imagePath: state.newActiveImagePath),
      stopImageUrl: await uploadImage(
          id: newAvatarId,
          imageName: 'stopAvatar',
          imagePath: state.newStopImagePath),
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
    await deleteImage(id: id, imageName: 'activeAvatar');
    await deleteImage(id: id, imageName: 'stopAvatar');
    state = state.copyWith(avatarList: avatarList);
  }
}
