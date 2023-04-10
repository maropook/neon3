import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neon3/services/common/field_name.dart';
import 'package:neon3/services/logger.dart';

class FireStorageService {
  FireStorageService();

  final String uid = FirebaseAuth.instance.currentUser?.uid ??
      FieldName.noAccount; //currentUser==nullのときは匿名認証すらしていない
  // final ImagePicker picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> getPickedFilePath() async {
    final FilePickerResult? pickedImageFile =
        await FilePicker.platform.pickFiles();
    if (pickedImageFile == null) {
      return '';
    }
    final String pickedImageFilePath = pickedImageFile.files.single.path!;

    // final pickedImageFile = await picker.pickImage(source: ImageSource.gallery);
    //   if (pickedImageFile == null) return '';
    // final String pickedImageFilePath =pickedImageFile.path!;

    // final croppedImageFile = await ImageCropper().cropImage(
    //   sourcePath: pickedImageFilePath, //pickedImageFile.path
    //   compressQuality: 80,
    //   maxWidth: 1024,
    //   maxHeight: 1024,
    //   aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    // );
    // if (croppedImageFile == null) return '';//image_cropperとimage_pickerは透過に対応してない
    return pickedImageFilePath;
  }

  Future<String> uploadImage({
    required String id,
    required String imagePath,
    required String imageName,
  }) async {
    if (imagePath.isEmpty) {
      Logger.log('upload_image', 'image_path_is_empty');
      return '';
    }
    final Reference storageRef = storage.ref("users/$uid/$id/$imageName.jpg");
    try {
      await storageRef.putFile(File(imagePath));
    } catch (e) {
      Logger.logError('upload_image', e.toString());
    }
    return await storageRef.getDownloadURL();
  }

  Future<void> deleteImage({
    required String id,
    required String imageName,
  }) async {
    try {
      final Reference storageRef = storage.ref("users/$uid/$id/$imageName.jpg");
      await storageRef.delete();
    } catch (e) {
      Logger.logError('delete_pic', e.toString());
    }
  }
}
