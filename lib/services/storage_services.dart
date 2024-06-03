import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageServices{

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final postCollectionRef = FirebaseFirestore.instance.collection("posts");
  final userCollectionRef = FirebaseFirestore.instance.collection("users");
  final userId = FirebaseAuth.instance.currentUser?.uid;

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