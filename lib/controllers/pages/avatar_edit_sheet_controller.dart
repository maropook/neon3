import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/common/field_name.dart';
import 'package:neon3/services/fire_avatar_service.dart';
import 'package:neon3/services/fire_storage_service.dart';

import 'package:firebase_auth/firebase_auth.dart';

part 'avatar_edit_sheet_controller.freezed.dart';

@freezed
class AvatarEditSheetState with _$AvatarEditSheetState {
  const factory AvatarEditSheetState({
    @Default("") String newActiveImagePath,
    @Default("") String newStopImagePath,
  }) = _AvatarEditSheetState;
}

final avatarEditSheetProvider = StateNotifierProvider.autoDispose<
    AvatarEditSheetController, AvatarEditSheetState>((ref) {
  return throw UnimplementedError();
});

class AvatarEditSheetController extends StateNotifier<AvatarEditSheetState> {
  AvatarEditSheetController({required avatar})
      : _avatar = avatar,
        super(const AvatarEditSheetState()) {
    init();
  }
  final Avatar _avatar;
  final FireStorageService fireStorageService = FireStorageService();
  final FireAvatarService fireAvatarService = FireAvatarService();
  final uid = FirebaseAuth.instance.currentUser?.uid ??
      FieldName.noAccount; //currentUser==nullのときは匿名認証すらしていない

  Future<void> init() async {}

  Future<void> setNewImage({required bool isActive}) async {
    String imageFilePath = await fireStorageService.getNewImagePath();
    if (imageFilePath.isEmpty) return;

    if (isActive) {
      state = state.copyWith(newActiveImagePath: imageFilePath);
      return;
    }
    state = state.copyWith(newStopImagePath: imageFilePath);
  }

  Future<Avatar> updateAvatar({required Avatar previousAvatar}) async {
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
    return newAvatar;
  }
}
