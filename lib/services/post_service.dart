import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class PostService{

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final postCollectionRef = FirebaseFirestore.instance.collection("posts");
  final userCollectionRef = FirebaseFirestore.instance.collection("users");
  final userId = FirebaseAuth.instance.currentUser?.uid;


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
        'likesCount': 0,
        'commentsCount': 0,
        'createdAt': Timestamp.now()
      });

      await userCollectionRef.doc(user).update({
        'postsCount': FieldValue.increment(1)
      });
    }
    catch(e){
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final docRef = await postCollectionRef.orderBy('createdAt', descending: true).get();
    final posts = docRef.docs.map((doc) => {...doc.data()}).toList();
    return posts;
  }

  Future<Map<String, dynamic>?> getUserDetails(String? id) async {
    final docRef = await userCollectionRef.doc(id).get();
    return docRef.data();
    // return docRef.map((doc) => {...doc.data(),'id':doc.id});
  }

  Future<void> likePost({String? postId, String? userId}) async {
    final postDocRef = postCollectionRef.doc(postId);
    final postLikeDocRef = postCollectionRef.doc(postId).collection('likes');
    print(postLikeDocRef);
    final getUserLike = await postLikeDocRef.doc(userId).get();
    print('user');
    print(getUserLike.exists);
    if(!getUserLike.exists){
      await postDocRef.set({
        'likesCount': FieldValue.increment(1)
      },
        SetOptions(merge: true)
      );
      print('like collection');
      await postLikeDocRef.doc(userId).set({
        'userId': userId,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now()
      });
    }
    else{
      print('already liked');
    }
  }



  Future<void> unlikePost({String? postId, String? userId}) async {
    final postDocRef = postCollectionRef.doc(postId);
    final postLikeDocRef = postCollectionRef.doc(postId).collection('likes');
    print(postLikeDocRef);
    final getUserLike = await postLikeDocRef.doc(userId).get();
    print('user');
    print(getUserLike.exists);
    if(getUserLike.exists){
      final likecount = await postDocRef.set({
        'likesCount': FieldValue.increment(-1)
      },
        SetOptions(merge: true)
      );
      final delete = await postLikeDocRef.doc(userId).delete();
    }
    else{
      print('already unliked');
    }
  }

  Future<int> likeCounts(String? postId) async {
    final postLikeDocRef = postCollectionRef.doc(postId).collection('likes');
    final docRef = await postLikeDocRef.get();
    final id = docRef.docs.map((doc) => doc.id).toList();
    final currLikecounts = id.length;
    return currLikecounts;
  }

  Future<List> getLikedUsers(String? postId) async {
    List<Map<String, dynamic>> users = [];
    final postLikeDocRef = postCollectionRef.doc(postId).collection('likes');
    final docRef = await postLikeDocRef.get();
    final ids = docRef.docs.map((doc) => doc.id).toList();
    print(ids);
    for(var id in ids){
      print(id);
      final user = await userCollectionRef.doc(id).get();
      users = [...users, user.data()!];
      print(users);
    }
    return users;
  }

  isliked({String? postId, String? userId}) async {
    final postLikeDocRef = postCollectionRef.doc(postId).collection('likes');
    final getUserLike = await postLikeDocRef.doc(userId).get();
    if(getUserLike.exists){
      return true;
    } else {
      return false;
    }
  }


  Future<String?> postComment({String? postId, String? userId, String? message}) async {
    final postDocRef = postCollectionRef.doc(postId);
    final postCommentDocRef = postCollectionRef.doc(postId).collection('comments').doc();
    final docId = postCommentDocRef.id;
    print(postCommentDocRef);
      await postDocRef.set({
        'commentsCount': FieldValue.increment(1)
      },
        SetOptions(merge: true)
      );

      await postCommentDocRef.set({
        'userId': userId,
        'comment': message,
        'id': docId,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now()
      });

      log("This is the latest id" + docId);

    return docId;
  }
  
  Future<List<Map<String, dynamic>>> getComments({String? postId}) async {
    final postCommentDocRef = postCollectionRef.doc(postId).collection('comments');
    final docRef = await postCommentDocRef.get();
    print('idididid');
    // print(docRef.docs.map((doc) => {doc.id,{...doc.data()}}).toList());
    // return docRef.docs.map((doc) => {doc.id,{...doc.data()}}).toList();
    print(docRef.docs.map((doc) => {...doc.data(),'id':doc.id}).toList());
    return docRef.docs.map((doc) => {...doc.data(),'id':doc.id}).toList();
  }

  Future<void> deleteComment({String? postId, String? commentId}) async {
    final postDocRef = postCollectionRef.doc(postId);
    final postCommentDocRef = postCollectionRef.doc(postId).collection('comments');
    await postDocRef.set({
      'commentsCount': FieldValue.increment(-1)
    },
      SetOptions(merge: true)
    );
    await postCommentDocRef.doc(commentId).delete();
  }

  Future<List<Map<String, dynamic>>> getUserPosts({String? userId}) async {
    final docRef = await postCollectionRef.where('createdBy', isEqualTo: userId).get();
    return docRef.docs.map((doc) => {...doc.data()}).toList();
  }

  Future<String?> follow({String? author, String? user}) async {
    final followingDocRef = userCollectionRef.doc(user).collection('following');
    final followerDocRef = userCollectionRef.doc(author).collection('followers');
    
    await userCollectionRef.doc(user).update({
      'following': FieldValue.increment(1)
    });

    await userCollectionRef.doc(author).update({
      'follower': FieldValue.increment(1)
    });

    await followingDocRef.doc(author).set({
      'userId': author,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now()
    }).then((value) => {

    });

    await followerDocRef.doc(user).set({
      'userId': user,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now()
    });
  }

  Future<String?> unfollow({String? author, String? user}) async {
    final followingDocRef = userCollectionRef.doc(user).collection('following');
    final followerDocRef = userCollectionRef.doc(author).collection('followers');
    
    await userCollectionRef.doc(user).update({
      'following': FieldValue.increment(-1)
    });

    await userCollectionRef.doc(author).update({
      'follower': FieldValue.increment(-1)
    });
    
    try{
      await followingDocRef.doc(author).delete();
      await followerDocRef.doc(user).delete();
    } catch(e){
      print(e);
    }
  }

  isFollowing({String? author, String? user}) async {
    final followerDocRef = userCollectionRef.doc(author).collection('followers');
    final getUserFollow = await followerDocRef.doc(user).get();
    return getUserFollow.exists;
  }
}