import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:social_media/main.dart';
import 'package:social_media/services/post_service.dart';

class CommentTileWidget extends StatefulWidget {
  final String? comment;
  final String? userId;
  final Timestamp createdAt;
  final String? postid;
  final String commentid;
  final Function(String id) onDelete;
  const CommentTileWidget(
      {super.key, this.comment, this.userId, required this.createdAt, required this.postid, required this.commentid, required this.onDelete});

  @override
  State<CommentTileWidget> createState() => _CommentTileWidgetState();
}

class _CommentTileWidgetState extends State<CommentTileWidget> {
  final _postService = locator<PostService>();
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  var userDetails = {};

  getUserDetails() async {
    final user = await _postService.getUserDetails(widget.userId);
    print(userDetails);
    setState(() {
      userDetails = user!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.comment);
    // print(widget.userId);
    // print(userDetails);
    // print(widget.commentid);
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: userDetails['profileImage'] != null
            ? CachedNetworkImageProvider(userDetails['profileImage'])
            // ? Image.network(userDetails['profileImage']).image
            : null,
      ),
      title: Text(userDetails['username'] ?? 'No name'),
      subtitle: Text(widget.comment ?? 'No comment'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(GetTimeAgo.parse(widget.createdAt.toDate())),
          currentUser == widget.userId
              ? IconButton(
                onPressed: () async {
                  print(widget.commentid);
                  await _postService.deleteComment(postId: widget.postid, commentId: widget.commentid);
                  widget.onDelete(widget.commentid);
                },
                icon: const Icon(Icons.delete)
                )
              : IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  style: const ButtonStyle(
                      iconColor: MaterialStatePropertyAll(Colors.transparent)),
                ),
        ],
      ),
    );
  }
}
