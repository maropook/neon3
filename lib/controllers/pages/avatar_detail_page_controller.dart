import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/common/field_name.dart';
import 'package:neon3/services/fire_avatar_service.dart';
import 'package:neon3/services/fire_storage_service.dart';

part 'avatar_detail_page_controller.freezed.dart';

@freezed
class AvatarDetailPageState with _$AvatarDetailPageState {
  const factory AvatarDetailPageState({
    @Default("") String newActiveImagePath,
    @Default("") String newStopImagePath,
    @Default(null) Avatar? avatar,
    @Default("") String selectedAvatarId,
  }) = _AvatarDetailPageState;
}

final avatarDetailPageProvider = StateNotifierProvider.autoDispose<
    AvatarDetailPageController, AvatarDetailPageState>((ref) {
  return throw UnimplementedError();
});

class AvatarDetailPageController extends StateNotifier<AvatarDetailPageState> {
  AvatarDetailPageController({required avatar})
      : _avatar = avatar,
        super(const AvatarDetailPageState()) {
    init();
  }
  final Avatar _avatar;
  final FireStorageService fireStorageService = FireStorageService();
  final FireAvatarService fireAvatarService = FireAvatarService();

  Future<void> init() async {
    await fetchAvatarFromId();
    await fetchSelectedAvatarId();
  }

  Future<void> selectAvatar() async {
    if (_avatar.id == state.selectedAvatarId) {
      return;
    }
    await fireAvatarService.setSelectAvatarId(id: _avatar.id);
    state = state.copyWith(selectedAvatarId: _avatar.id);
  }

  Future<void> fetchSelectedAvatarId() async {
    state = state.copyWith(
        selectedAvatarId: await fireAvatarService.fetchSelectedAvatarId());
  }

  Future<void> fetchAvatarFromId() async {
    if (_avatar.id.isEmpty) {
      state = state.copyWith(avatar: defaultAvatar);
      return;
    }
    state = state.copyWith(
        avatar: await fireAvatarService.fetchAvatarFromUuid(id: _avatar.id));
  }

  Future<void> update({required Avatar newAvatar}) async {
    state = state.copyWith(avatar: newAvatar);
  }

  Future<void> deleteAvatar({required String id}) async {
    if (id == state.selectedAvatarId || id == '') {
      return;
    }
    await fireAvatarService.deleteAvatar(id: id);
    await fireStorageService.deleteImage(
        id: id, imageName: FieldName.activeAvatar);
    await fireStorageService.deleteImage(
        id: id, imageName: FieldName.stopAvatar);
    state = state.copyWith(avatar: null);
  }
}
