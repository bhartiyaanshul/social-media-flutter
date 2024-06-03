import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageServices{

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final postCollectionRef = FirebaseFirestore.instance.collection("posts");
  final userCollectionRef = FirebaseFirestore.instance.collection("users");
  final userId = FirebaseAuth.instance.currentUser!.uid;

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

  Future<Map<String, dynamic>?> getUserDetails(String? id) async {
    final docRef = await userCollectionRef.doc(id).get();
    return docRef.data();
  }

  Future<void> likePost({String? postId, String? userId}) async {
    final postLikeDocRef = postCollectionRef.doc(postId).collection('likes');
    print(postLikeDocRef);
    final getUserLike = await postLikeDocRef.doc(userId).get();
    print('user');
    print(getUserLike.exists);
    if(!getUserLike.exists){
      final like = await postLikeDocRef.doc(userId).set({
        'userId': userId,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now()
      });
    }
    else{
      final delete = await postLikeDocRef.doc(userId).delete();
    }
  }

  Future<int> likeCounts(String? postId) async {
    final postLikeDocRef = postCollectionRef.doc(postId).collection('likes');
    final docRef = await postLikeDocRef.get();
    final id = docRef.docs.map((doc) => doc.id).toList();
    final likecounts = id.length;
    return likecounts;
  }

  isliked({String? postId, String? userId}) async {
    final postLikeDocRef = postCollectionRef.doc(postId).collection('likes');
    final getUserLike = await postLikeDocRef.doc(userId).get();
    if(getUserLike.exists){
      return true;
    } else {
      return false;
    }
    // final postDocRef = postCollectionRef.doc(postId);
    // final post = await postDocRef.get();
    // if(post.data()?['likes'] != null){
    //   if(post.data()?['likes'].contains(userId)){
    //     return true;
    //   } else {
    //     return false;
    //   }
    // } else {
    //   return false;
    // }
  }

}