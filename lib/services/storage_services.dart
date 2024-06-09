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
    try {
    Reference ref = _storage.ref().child("profileImage/$fileName");
    UploadTask uploadImage = ref.putData(await file.readAsBytes());
    uploadImage.snapshotEvents.listen((event) {
    });
    TaskSnapshot snapshot = await uploadImage.whenComplete(() => null);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
    } catch (e) {
      print(e.toString());
    }
  }

}