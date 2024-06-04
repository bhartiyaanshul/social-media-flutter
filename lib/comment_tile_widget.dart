import 'package:flutter/material.dart';
import 'package:social_media/main.dart';
import 'package:social_media/services/post_service.dart';

class CommentTileWidget extends StatefulWidget {
  final String? comment;
  final String? userId;
  const CommentTileWidget({super.key, this.comment, this.userId});

  @override
  State<CommentTileWidget> createState() => _CommentTileWidgetState();
}

class _CommentTileWidgetState extends State<CommentTileWidget> {

  final _postService = locator<PostService>();

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
    print(widget.comment);
    print(widget.userId);
    print(userDetails);
    return ListTile(
      leading: CircleAvatar(
              radius: 20,
              backgroundImage: userDetails['profileImage'] != null
                  ? Image.network(userDetails['profileImage']).image
                  : null,
            ),
      title: Text(userDetails['username'] ?? 'No name'),
      subtitle: Text(widget.comment ?? 'No comment'),
    );
  }
}