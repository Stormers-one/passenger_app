import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class FireStorageState with ChangeNotifier {
  static String _downURL =
      'https://thumbs.dreamstime.com/b/no-user-profile-picture-hand-drawn-illustration-53840792.jpg';
  String get downUrl => _downURL;
  String userID;

  // Profile PIC FIRE STORAGE
  Future getim() async {
    await _getImageFromFireStorage();
  }

  Future<void> _getImageFromFireStorage() async {
    try {
      if (await FirebaseStorage.instance
          .ref('profile_image/$userID')
          .fullPath
          .isNotEmpty) {
        _downURL = await FirebaseStorage.instance
            .ref('profile_image/$userID')
            .getDownloadURL();
        notifyListeners();
      }
    } on firebase_core.FirebaseException catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
