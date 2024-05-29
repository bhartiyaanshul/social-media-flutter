import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService{
  final auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String userName,
    required File file
  }) async {
    try{
      String? imageUrl = await uploadProfilePicture('test.png', file);
      auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      ).then((user) {
      _createUser(
        name: name, 
        username: userName, 
        email: email, 
        file: imageUrl!,
        id: user.user!.uid);
      } );
    }
    catch(e){
      log("something went wrong $e");
      print(auth);
    }
    return null;
  }

  final userCollectionRef = FirebaseFirestore.instance.collection("users");

  Future<void> _createUser({
    required String name,
    required String username,
    required String email,
    required String id,
    required String file
  }) async {
    log("Creating firebase user");
    try{
      
      await userCollectionRef.doc(id).set({
        'name': name,
        'username': username,
        'email': email,
        'profileImage': file,
        'createdAt': Timestamp.now()
      });
    }
    catch(e){
      print(e);
    }
  }

  Future<String?> uploadProfilePicture(String fileName, File file) async {
    print(fileName);
    try {
    Reference ref = _storage.ref().child(fileName);
    print("Test 1");
    UploadTask uploadImage = ref.putFile(file);
    uploadImage.snapshotEvents.listen((event) {
      print(event.state);
    });
    TaskSnapshot snapshot = await uploadImage;
    print("Test 2");
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User?> loginUserWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    try{
      print('Signing in');
      print(email);
      print(password);
      final credential = await auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      print(credential.user);
      return credential.user;
    }
    catch(e){
      log("$e");
    }
    return null;
  }

}