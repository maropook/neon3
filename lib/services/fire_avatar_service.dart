import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maropook_neon2/models/src/avatar.dart';
import 'package:uuid/uuid.dart';

class FireAvatarService {
  FireAvatarService();

  final _fireStore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> addNewAvatar({required Avatar avatar}) async {
    String uid = currentUser?.uid ?? 'no_account';

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('images')
        .doc(avatar.id)
        .set(avatar.toJson());
  }

  Future<void> updateAvatar({required Avatar avatar}) async {
    String uid = currentUser?.uid ?? 'no_account';

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('images')
        .doc(avatar.id)
        .set(avatar.toJson());
  }

  Future<void> deleteAvatar({required String id}) async {
    String uid = currentUser?.uid ?? 'no_account';

    await _fireStore
        .collection('users')
        .doc(uid)
        .collection('images')
        .doc(id)
        .delete();
  }

  Future<List<Avatar>> fetchAvatars() async {
    String uid = currentUser?.uid ?? 'no_account';

    final snapshot = await _fireStore
        .collection('users')
        .doc(uid)
        .collection('images')
        .orderBy('created', descending: true)
        .get();
    return snapshot.docs.map((e) => Avatar.fromJson(e.data())).toList();
  }

  Future<Avatar?> fetchSelectedAvatar({required String uuid}) async {
    String uid = currentUser?.uid ?? 'no_account';

    final docSnapshot = await _fireStore
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
