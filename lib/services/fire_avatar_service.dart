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
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('images')
        .doc(avatar.id)
        .set(avatar.toJson());
  }

  Future<void> updateAvatar({required Avatar avatar}) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('images')
        .doc(avatar.id)
        .set(avatar.toJson());
  }

  Future<void> deleteAvatar({required String id}) async {
    await fireStore
        .collection('users')
        .doc(uid)
        .collection('images')
        .doc(id)
        .delete();
  }

  Future<List<Avatar>> fetchAvatars() async {
    final snapshot = await fireStore
        .collection('users')
        .doc(uid)
        .collection('images')
        .orderBy('created', descending: true)
        .get();
    return snapshot.docs.map((e) => Avatar.fromJson(e.data())).toList();
  }

  Future<Avatar?> fetchSelectedAvatar({required String uuid}) async {
    final docSnapshot = await fireStore
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
