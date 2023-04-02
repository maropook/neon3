import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/models/src/avatar.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'avatar_list_page_controller.freezed.dart';

@freezed
class AvatarListPageState with _$AvatarListPageState {
  const factory AvatarListPageState({
    @Default(null) Uint8List? image,
  }) = _AvatarListPageState;
}

final avatarListPageProvider = StateNotifierProvider.autoDispose<
    AvatarListPageController,
    AvatarListPageState>((ref) => AvatarListPageController());

class AvatarListPageController extends StateNotifier<AvatarListPageState> {
  AvatarListPageController() : super(const AvatarListPageState()) {
    init();
  }

  Future<void> init() async {}

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
}

class FirestoreService {
  FirestoreService();

  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Future<void> getDocs() async {
  //   String uid = currentUser?.uid ?? 'no_account';

  //   final ref = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .collection('images')
  //       .get();

  //   for (int i = 0; ref.docs.length > i; i++) {
  //     print(ref.docs[i].get("activeImagePath"));
  //   }
  // }

  void addAvatar() {
    final _avatar = Avatar(
      activeImagePath: "activeImagePath",
      stopImagePath: "",
      uniqueKey: const Uuid().v4(),
      created: DateTime.now(),
      updated: DateTime.now(),
    );

    String uid = currentUser?.uid ?? 'no_account';
    var uuid = const Uuid();

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('images')
        // .doc(uuid.v4())
        .doc('sample')
        .set(_avatar.toJson());
  }

  void deleteAvatar({required String uuid}) {
    String uid = currentUser?.uid ?? 'no_account';

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('images')
        .doc('sample')
        // .doc(uuid)
        .delete();
  }

  final _fireStore = FirebaseFirestore.instance;

  Future<List<Avatar>> fetchAvatars() async {
    String uid = currentUser?.uid ?? 'no_account';

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('images')
        .orderBy('created', descending: true)
        .get();
    return snapshot.docs.map((e) => Avatar.fromJson(e.data())).toList();
  }

  Future<void> fetch() async {
    final List<Avatar> list = await fetchAvatars();

    for (int i = 0; list.length > i; i++) {
      print(list[i].activeImagePath);
    }
  }

  // teamId,matchIDを指定してMatchを取得
  Future<Avatar?> fetchSelectedAvatar({required String uuid}) async {
    String uid = currentUser?.uid ?? 'no_account';

    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('images')
        .doc(uuid)
        .get();
    final data = docSnapshot.data();

    if (data != null) {
      return Avatar.fromJson(data);
    }
    return null;
  }
}
