import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:neon3/models/src/avatar.dart';
import 'package:neon3/services/fire_avatar_service.dart';

part 'change_avatar_sheet_controller.freezed.dart';

@freezed
class ChangeAvatarSheetState with _$ChangeAvatarSheetState {
  const factory ChangeAvatarSheetState({
    @Default([]) List<Avatar> avatarList,
    @Default(null) Avatar? selectedAvatar,
  }) = _ChangeAvatarSheetState;
}

final changeAvatarSheetProvider = StateNotifierProvider.autoDispose<
    ChangeAvatarSheetController,
    ChangeAvatarSheetState>((ref) => ChangeAvatarSheetController());

class ChangeAvatarSheetController
    extends StateNotifier<ChangeAvatarSheetState> {
  ChangeAvatarSheetController() : super(const ChangeAvatarSheetState()) {
    init();
  }
  final FireAvatarService fireAvatarService = FireAvatarService();

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

  Future<List<Avatar>> fetchAvatars() async {
    List<Avatar> avatarList = await fireAvatarService.fetchAvatars();
    List<Avatar> defaultAvatarList =
        await fireAvatarService.fetchDefaultAvatar();
    state = state.copyWith(avatarList: [...avatarList, ...defaultAvatarList]);
    return avatarList;
  }

  Future<Avatar> selectAvatar(Avatar avatar) async {
    if (avatar.id == state.selectedAvatar?.id) {
      return avatar;
    }
    await fireAvatarService.setSelectAvatarId(id: avatar.id);
    state = state.copyWith(selectedAvatar: avatar);
    return avatar;
  }
}
