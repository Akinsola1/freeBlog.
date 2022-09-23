import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:free_blog/resources/storageMethod.dart';

import '../utils/utils.dart';

class UserMethod {
  final CollectionReference firestore =
      FirebaseFirestore.instance.collection('users');
  String res = "An error occured";

  Future<String> editProfile(
      Uint8List? _image, var userData, String name, String bio) async {
    try {
      if (_image == null) {
        firestore.doc(userData["uid"]).update({"username": name, "bio": bio});
        res = 'success';
      } else {
        String profImage =
            await StorageMethod().uploadImage('profilePics', _image, false);

        firestore
            .doc(userData["uid"])
            .update({"username": name, "bio": bio, "photoUrl": profImage});
        res = 'success';

      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
