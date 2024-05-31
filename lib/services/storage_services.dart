import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<String?> uploadPostPicture(String fileName, File file) async {
    print(fileName);
    try {
    Reference ref = _storage.ref().child("postPicture/${fileName}");
    UploadTask uploadImage = ref.putFile(file);
    TaskSnapshot snapshot = await uploadImage.whenComplete(() => null);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
    } catch (e) {
      print(e.toString());
    }
  }

  final postCollectionRef = FirebaseFirestore.instance.collection("posts");

  Future<void> createPost({
    required String title,
    required String description,
    required String user,
    required File file,
  }) async {
    try{
      final postDocRef = postCollectionRef.doc();
      String? imageUrl = await uploadPostPicture('${postDocRef.id}.png', file);
      final post = await postDocRef.set({
        'title': title,
        'description': description,
        'createdBy': user,
        'postImage': imageUrl,
        'id': postDocRef.id,
        'createdAt': Timestamp.now()
      });
    }
    catch(e){
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final docRef = await postCollectionRef.get();
    return docRef.docs.map((doc) => {...doc.data()}).toList();
  }
}