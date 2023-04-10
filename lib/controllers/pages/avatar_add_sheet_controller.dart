import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/common/field_name.dart';
import 'package:neon3/services/fire_avatar_service.dart';
import 'package:neon3/services/fire_storage_service.dart';

import 'package:uuid/uuid.dart';

part 'avatar_add_sheet_controller.freezed.dart';

@freezed
class AvatarAddSheetState with _$AvatarAddSheetState {
  const factory AvatarAddSheetState({
    @Default("") String newActiveImagePath,
    @Default("") String newStopImagePath,
  }) = _AvatarAddSheetState;
}

final avatarAddSheetProvider = StateNotifierProvider.autoDispose<
    AvatarAddSheetController,
    AvatarAddSheetState>((ref) => AvatarAddSheetController());

class AvatarAddSheetController extends StateNotifier<AvatarAddSheetState> {
  AvatarAddSheetController() : super(const AvatarAddSheetState()) {
    init();
  }
  final FireStorageService fireStorageService = FireStorageService();
  final FireAvatarService fireAvatarService = FireAvatarService();

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

  Future<Avatar> addNewAvatar() async {
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
    return newAvatar;
  }
}
