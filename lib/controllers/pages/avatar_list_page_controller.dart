import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maropook_neon2/services/logger.dart';
import 'package:image_picker/image_picker.dart';
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

  void getDoc() {
    String uid = currentUser?.uid ?? 'no_account';

    FirebaseFirestore.instance.collection('users').doc(uid).get().then((ref) {
      print(ref.get("sample"));
    });
  }

  void setDoc() {
    String uid = currentUser?.uid ?? 'no_account';

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'sample': "abc"});
  }

  void deleteDoc() {
    String uid = currentUser?.uid ?? 'no_account';

    FirebaseFirestore.instance.collection('users').doc(uid).delete();
  }

  final _fireStore = FirebaseFirestore.instance;

  // Future<List<Match>> fetchMyTeamYearlyMatches({required String teamId}) async {
  //   final snapshot = await _fireStore.collection('matches').doc('v1').get();
  //   return snapshot.docs.map((e) => Match.fromJson(e.data())).toList();
  // }

  // // teamId,matchIDを指定してMatchを取得
  // Future<Match?> fetchSelectedMatch(
  //     {required String teamId, required String matchId}) async {
  //   final docSnapshot = await _fireStore.collection('matches').doc('v1').get();
  //   final data = docSnapshot.data();
  //   if (data != null) {
  //     return Match.fromJson(data);
  //   }
  // }
}
