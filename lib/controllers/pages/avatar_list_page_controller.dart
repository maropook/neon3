import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/common/field_name.dart';
import 'package:neon3/services/fire_avatar_service.dart';
import 'package:neon3/services/fire_storage_service.dart';

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
    @Default(null) Avatar? selectedAvatar,
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
    await fetchSelectedAvatar();
    await fetchAvatars();
  }

  Future<void> fetchSelectedAvatar() async {
    String selectedAvatarId = await fireAvatarService.fetchSelectedAvatarId();
    if (selectedAvatarId.isEmpty) {
      state = state.copyWith(selectedAvatar: defaultAvatar);
      return;
    }
    state = state.copyWith(
        selectedAvatar:
            await fireAvatarService.fetchAvatarFromUuid(id: selectedAvatarId));
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
    List<Avatar> defaultAvatarList =
        await fireAvatarService.fetchDefaultAvatar();
    state = state.copyWith(avatarList: [...avatarList, ...defaultAvatarList]);
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
}
