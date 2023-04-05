import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maropook_neon2/models/src/avatar.dart';
import 'package:maropook_neon2/services/common/field_name.dart';
import 'package:uuid/uuid.dart';

class FireAvatarService {
  FireAvatarService();

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final String uid =
      FirebaseAuth.instance.currentUser?.uid ?? FieldName.noAccount;

  Future<void> addNewAvatar({required Avatar avatar}) async {
    fireStore
        .collection('users')
        .doc(uid)
        .collection('avatars')
        .doc(avatar.id)
        .set(avatar.toJson());
  }

  Future<void> updateAvatar({required Avatar avatar}) async {
    fireStore
        .collection('users')
        .doc(uid)
        .collection('avatars')
        .doc(avatar.id)
        .set(avatar.toJson());
  }

  Future<void> deleteAvatar({required String id}) async {
    await fireStore
        .collection('users')
        .doc(uid)
        .collection('avatars')
        .doc(id)
        .delete();
  }

  Future<List<Avatar>> fetchAvatars() async {
    final snapshot = await fireStore
        .collection('users')
        .doc(uid)
        .collection('avatars')
        .orderBy('created', descending: true)
        .get();
    return snapshot.docs.map((e) => Avatar.fromJson(e.data())).toList();
  }

  Future<Avatar?> fetchAvatarFromUuid({required String id}) async {
    final docSnapshot = await fireStore
        .collection('users')
        .doc(uid)
        .collection('avatars')
        .doc(id)
        .get();
    final data = docSnapshot.data();

    if (data != null) {
      return Avatar.fromJson(data);
    }
    return null;
  }

  Future<String> fetchSelectedAvatarId() async {
    final docSnapshot = await fireStore
        .collection('users')
        .doc(uid)
        .collection('avatars')
        .doc('selectedAvatar')
        .get();

    final data = docSnapshot.data();

    if (data != null) {
      return data['id'];
    }
    return '';
  }

  Future<void> setSelectAvatarId({required id}) async {
    await fireStore
        .collection('users')
        .doc(uid)
        .collection('avatars')
        .doc('selectedAvatar')
        .set({'id': id});
  }

  Future<List<Avatar>> fetchDefaultAvatar() async {
    final snapshot = await fireStore
        .collection('avatars')
        .orderBy('created', descending: true)
        .get();
    return snapshot.docs.map((e) => Avatar.fromJson(e.data())).toList();
  }
}
