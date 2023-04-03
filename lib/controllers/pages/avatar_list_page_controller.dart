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
    await fetchAvatars();
  }

  final FireAvatarService fireAvatarService = FireAvatarService();
  final uid = FirebaseAuth.instance.currentUser?.uid ??
      'no_account'; //currentUser==nullのときは匿名認証すらしていない

  final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Uuid uuid = const Uuid();

  Future<String?> uploadImage({required String id}) async {
    final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile == null) return null;
    final croppedImageFile = await ImageCropper().cropImage(
      sourcePath: pickedImageFile.path,
      compressQuality: 80,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (croppedImageFile == null) return null;
    final File imageFile = File(croppedImageFile.path);
    final Reference ref = storage.ref("users/$uid/$id/${id}.jpg");
    try {
      await ref.putFile(imageFile);
    } catch (e) {
      Logger.logError('upload_image', e.toString());
    }

    return ref.getDownloadURL();
  }

  Future<void> deleteImage({required String id}) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('users/$uid/$id/${id}.jpg');
      await storageRef.delete();
      state = state.copyWith(image: null);
    } catch (e) {
      Logger.logError('delete_pic', e.toString());
    }
  }

  Future<List<Avatar>> fetchAvatars() async {
    List<Avatar> avatarList = await fireAvatarService.fetchAvatars();
    state = state.copyWith(avatarList: avatarList);

    return avatarList;
  }

  Future<void> addNewAvatar({required Avatar avatar}) async {
    final imageUrl = await uploadImage(id: avatar.id);
    if (imageUrl == null) return;
    avatar =
        avatar.copyWith(activeImagePath: imageUrl, stopImagePath: imageUrl);
    await fireAvatarService.addNewAvatar(avatar: avatar);

    state = state.copyWith(
      avatarList: [avatar, ...state.avatarList],
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
