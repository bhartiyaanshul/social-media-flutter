import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:social_media/services/storage_services.dart';

class AuthService{
  final auth = FirebaseAuth.instance;
  final StorageServices storage = StorageServices();

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String userName,
    required File file
  }) async {
    try{
      
      auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      ).then((user) {
      _createUser(
        name: name, 
        username: userName, 
        email: email, 
        file: file,
        id: user.user!.uid);
        }
      );
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
    required File file
  }) async {
    log("Creating firebase user");
    try{
      String? imageUrl = await storage.uploadProfilePicture('$id.png', file);
      await userCollectionRef.doc(id).set({
        'name': name,
        'username': username,
        'email': email,
        'id': id,
        'followers':0,
        'following':0,
        'postsCount':0,
        'profileImage': imageUrl,
        'createdAt': Timestamp.now()
      });
    }
    catch(e){
      print(e);
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

  Future<void> signOut() async {
    try{
      await auth.signOut();
      print("User Signed Out");
    }
    catch(e){
      log("$e");
    }
  }

  bool get isloggedIn => auth.currentUser != null;
}