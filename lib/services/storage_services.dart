import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageServices{

  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String?> uploadProfilePicture(String fileName, File file) async {
    print(fileName);
    try {
    Reference ref = _storage.ref().child("profileImage/${fileName}");
    UploadTask uploadImage = ref.putData(await file.readAsBytes());
    uploadImage.snapshotEvents.listen((event) {
      print(event.state);
    });
    TaskSnapshot snapshot = await uploadImage.whenComplete(() => null);
    print("Test 2");
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
    } catch (e) {
      print(e.toString());
    }
  }
}