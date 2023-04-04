import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/models/src/avatar.dart';
import 'package:maropook_neon2/services/common/field_name.dart';
import 'package:maropook_neon2/services/fire_avatar_service.dart';
import 'package:maropook_neon2/services/fire_storage_service.dart';

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

  final FireStorageService fireStorageService = FireStorageService();
  final FireAvatarService fireAvatarService = FireAvatarService();
  final uid = FirebaseAuth.instance.currentUser?.uid ??
      FieldName.noAccount; //currentUser==nullのときは匿名認証すらしていない

  Future<void> init() async {
    await fetchAvatars();
  }

  void clearNewImagePath() {
    state = state.copyWith(newActiveImagePath: '', newStopImagePath: '');
  }

  Future<void> setNewImage({required bool isActive}) async {
    String imageFilePath = await fireStorageService.getNewImagePath();
    if (imageFilePath.isEmpty) return;

    if (isActive) {
      state = state.copyWith(newActiveImagePath: imageFilePath);
      return;
    }
    state = state.copyWith(newStopImagePath: imageFilePath);
  }

  Future<List<Avatar>> fetchAvatars() async {
    List<Avatar> avatarList = await fireAvatarService.fetchAvatars();
    state = state.copyWith(avatarList: avatarList);

    return avatarList;
  }

  Future<void> addNewAvatar() async {
    final newAvatarId = const Uuid().v4();

    final newAvatar = Avatar(
      activeImageUrl: await fireStorageService.uploadImage(
          id: newAvatarId,
          imageName: FieldName.activeAvatar,
          imagePath: state.newActiveImagePath),
      stopImageUrl: await fireStorageService.uploadImage(
          id: newAvatarId,
          imageName: FieldName.stopAvatar,
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

  Future<void> updateAvatar({required Avatar previousAvatar}) async {
    final id = previousAvatar.id;
    var newAvatar = Avatar(
      activeImageUrl: previousAvatar.activeImageUrl,
      stopImageUrl: previousAvatar.stopImageUrl,
      id: previousAvatar.id,
      created: previousAvatar.created,
      updated: DateTime.now(),
    );

    if (state.newActiveImagePath.isNotEmpty) {
      await fireStorageService.deleteImage(
          id: id, imageName: FieldName.activeAvatar);
      final activeImageUrl = await fireStorageService.uploadImage(
          id: id,
          imageName: FieldName.activeAvatar,
          imagePath: state.newActiveImagePath);
      newAvatar = newAvatar.copyWith(activeImageUrl: activeImageUrl);
    }

    if (state.newStopImagePath.isNotEmpty) {
      await fireStorageService.deleteImage(
          id: id, imageName: FieldName.stopAvatar);
      final stopImageUrl = await fireStorageService.uploadImage(
          id: id,
          imageName: FieldName.stopAvatar,
          imagePath: state.newStopImagePath);
      newAvatar = newAvatar.copyWith(stopImageUrl: stopImageUrl);
    }

    await fireAvatarService.updateAvatar(avatar: newAvatar);

    final List<Avatar> avatarList = state.avatarList
        .map((avatar) => avatar.id == newAvatar.id ? newAvatar : avatar)
        .toList();

    state = state.copyWith(avatarList: avatarList);
  }

  Future<void> deleteAvatar({required String id}) async {
    await fireAvatarService.deleteAvatar(id: id);
    final List<Avatar> avatarList =
        state.avatarList.where((avatar) => avatar.id != id).toList();
    await fireStorageService.deleteImage(
        id: id, imageName: FieldName.activeAvatar);
    await fireStorageService.deleteImage(
        id: id, imageName: FieldName.stopAvatar);
    state = state.copyWith(avatarList: avatarList);
  }
}
